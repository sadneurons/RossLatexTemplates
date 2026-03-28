% rossbeamerclinical.cls
% Clinical Beamer class for clinical trial presentations — CONSORT flows,
% endpoint cards, safety summaries, protocol timelines, and AE tables.
%
% Usage:
%   \documentclass[palette=clinical]{rossbeamerclinical}
%
% Available palettes:
%   clinical   — medical blue / white (default)
%   trial      — navy / green
%   safety     — dark / red-green
%
% Options:
%   palette=<name>   font=<fira|inter|sourcesans|libertinus|heros|georgia|system>
%   monofont=<name>  nobar  nologo  stats
%
% Ross Dunne / Claude, 2026

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{rossbeamerclinical}[2026/03/24 Clinical Beamer class]

% ----------------------------------------------------------------
% Option handling
% ----------------------------------------------------------------

\RequirePackage{pgfkeys}
\RequirePackage{pgfopts}

\newif\ifrb@nobar  \rb@nobarfalse
\newif\ifrb@nologo \rb@nologofalse
\newif\ifclin@stats \clin@statsfalse

\pgfkeys{
  /clinbeamer/.cd,
  palette/.store in=\clin@palette,     palette=clinical,
  font/.store in=\clin@fontchoice,     font=fira,
  monofont/.store in=\clin@mono,       monofont=,
  nobar/.code={\rb@nobartrue},
  nologo/.code={\rb@nologotrue},
  stats/.code={\clin@statstrue},
}
\ProcessPgfOptions{/clinbeamer}

\PassOptionsToClass{aspectratio=169}{beamer}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{beamer}}
\ProcessOptions\relax
\LoadClass{beamer}

% ----------------------------------------------------------------
% Load shared base
% ----------------------------------------------------------------

\RequirePackage{rossbeamerbase}

% ----------------------------------------------------------------
% Optionally load rossstats
% ----------------------------------------------------------------

\ifclin@stats
  \RequirePackage{rossstats}
\fi

% ----------------------------------------------------------------
% TikZ libraries needed for protocol timelines and flow diagrams
% ----------------------------------------------------------------

\usetikzlibrary{arrows.meta, positioning, calc}

% ----------------------------------------------------------------
% Palette definitions (12-field format)
%
% \clin@defpal{name}
%   {primary}{secondary}{accent}{text}{textlight}{textmuted}{bg}{rule}
%   {accentdark}{accentlight}{accentbg}{lightmuted}
% ----------------------------------------------------------------

\newcommand{\clin@defpal}[9]{%
  \expandafter\def\csname clin@p@#1@P\endcsname{#2}%   primary
  \expandafter\def\csname clin@p@#1@S\endcsname{#3}%   secondary
  \expandafter\def\csname clin@p@#1@A\endcsname{#4}%   accent
  \expandafter\def\csname clin@p@#1@T\endcsname{#5}%   text
  \expandafter\def\csname clin@p@#1@TL\endcsname{#6}%  textlight
  \expandafter\def\csname clin@p@#1@TM\endcsname{#7}%  textmuted
  \expandafter\def\csname clin@p@#1@B\endcsname{#8}%   bg
  \expandafter\def\csname clin@p@#1@R\endcsname{#9}%   rule
  \clin@defpal@cont{#1}%
}
\newcommand{\clin@defpal@cont}[5]{%
  \expandafter\def\csname clin@p@#1@AD\endcsname{#2}%  accentdark
  \expandafter\def\csname clin@p@#1@AL\endcsname{#3}%  accentlight
  \expandafter\def\csname clin@p@#1@AB\endcsname{#4}%  accentbg
  \expandafter\def\csname clin@p@#1@LM\endcsname{#5}%  lightmuted
}

%                        name        P       S       A       T       TL      TM      B       R       AD      AL      AB      LM
% clinical: medical blue / white — clean hospital-grade palette
\clin@defpal{clinical}   {1565C0}{1E88E5}{0D47A1}{1C1C1C}{FFFFFF}{607D8B}{F5F8FC}{D0D8E4}{0B3A7A}{4A90D9}{E3EDF7}{90A4AE}
% trial: navy / green — emphasis on treatment vs control
\clin@defpal{trial}      {1A237E}{2E7D32}{1B5E20}{1C1C1C}{FFFFFF}{546E7A}{F4F7F5}{C8D5D0}{0D1642}{4CAF50}{E8F5E9}{78909C}
% safety: dark charcoal / red-green — adverse event focus
\clin@defpal{safety}     {212121}{C62828}{2E7D32}{1C1C1C}{FFFFFF}{757575}{F5F5F5}{BDBDBD}{8E0000}{EF5350}{FFEBEE}{9E9E9E}

% ----------------------------------------------------------------
% Palette activation
% ----------------------------------------------------------------

\newcommand{\clin@activatepalette}{%
  % Core colours
  \definecolor{rbPrimary}{HTML}{\csname clin@p@\clin@palette @P\endcsname}%
  \definecolor{rbSecondary}{HTML}{\csname clin@p@\clin@palette @S\endcsname}%
  \definecolor{rbAccent}{HTML}{\csname clin@p@\clin@palette @A\endcsname}%
  \definecolor{rbText}{HTML}{\csname clin@p@\clin@palette @T\endcsname}%
  \definecolor{rbTextLight}{HTML}{\csname clin@p@\clin@palette @TL\endcsname}%
  \definecolor{rbTextMuted}{HTML}{\csname clin@p@\clin@palette @TM\endcsname}%
  \definecolor{rbBg}{HTML}{\csname clin@p@\clin@palette @B\endcsname}%
  \definecolor{rbRule}{HTML}{\csname clin@p@\clin@palette @R\endcsname}%
  % Derive standard colours
  \rb@derivecolors
  % Override with explicit palette refinements
  \definecolor{rbAccentDark}{HTML}{\csname clin@p@\clin@palette @AD\endcsname}%
  \definecolor{rbAccentLight}{HTML}{\csname clin@p@\clin@palette @AL\endcsname}%
  \definecolor{rbAccentBg}{HTML}{\csname clin@p@\clin@palette @AB\endcsname}%
  \definecolor{rbLightMuted}{HTML}{\csname clin@p@\clin@palette @LM\endcsname}%
  % Legacy / convenience aliases
  \colorlet{clinDark}{rbPrimary}%
  \colorlet{clinText}{rbText}%
  \colorlet{clinMuted}{rbTextMuted}%
  \colorlet{clinAccent}{rbAccent}%
  \colorlet{clinAccentDark}{rbAccentDark}%
  \colorlet{clinAccentLight}{rbAccentLight}%
  \colorlet{clinAccentBg}{rbAccentBg}%
  \colorlet{clinBg}{rbBg}%
  \colorlet{clinLight}{rbTextLight}%
  \colorlet{clinLightMuted}{rbLightMuted}%
  \colorlet{clinRule}{rbRule}%
  \colorlet{clinProgress1}{rbAccent}%
  \colorlet{clinProgress2}{rbRule}%
}
\clin@activatepalette

\newcommand{\setpalette}[1]{\def\clin@palette{#1}\clin@activatepalette}

% ----------------------------------------------------------------
% Beamer setup
% ----------------------------------------------------------------

\rb@setupbeamer
\setbeamersize{text margin left=12mm, text margin right=12mm}

% Clinical frame title: with underline rule
\setbeamertemplate{frametitle}{%
  \vskip6pt%
  {\usebeamerfont{frametitle}\usebeamercolor[fg]{frametitle}\insertframetitle}%
  \ifx\insertframesubtitle\empty\else
    \par\vskip1pt%
    {\usebeamerfont{framesubtitle}\usebeamercolor[fg]{framesubtitle}\insertframesubtitle}%
  \fi
  \vskip2pt{\color{rbRule}\hrule height 0.4pt}\vskip4pt%
}

% Font activation + serif math
\rb@activatefont{\clin@fontchoice}
\rb@activatemono{\clin@mono}
\usefonttheme[onlymath]{serif}

% Footer: always on
\rb@activatefooter

% ----------------------------------------------------------------
% Biblatex integration
% ----------------------------------------------------------------

\RequirePackage[
  backend=biber,
  style=numeric-comp,
  sorting=none,
  autocite=superscript,
  maxbibnames=3, minbibnames=1,
  maxcitenames=2, mincitenames=1,
  giveninits=true,
  doi=false, isbn=false, url=false, eprint=false,
]{biblatex}

\let\cite=\supercite

\DeclareFieldFormat{labelnumberwidth}{\mkbibbold{\color{rbAccent}#1}}
\setbeamertemplate{bibliography item}[text]
\setbeamercolor{bibliography item}{fg=rbAccent}
\setbeamercolor{bibliography entry author}{fg=rbText}
\setbeamercolor{bibliography entry title}{fg=rbText}
\setbeamercolor{bibliography entry location}{fg=rbTextMuted}
\setbeamercolor{bibliography entry note}{fg=rbTextMuted}
\setbeamerfont{bibliography item}{size=\scriptsize}
\setbeamerfont{bibliography entry author}{size=\scriptsize}
\setbeamerfont{bibliography entry title}{size=\scriptsize}
\setbeamerfont{bibliography entry location}{size=\scriptsize}
\setbeamerfont{bibliography entry note}{size=\scriptsize}
\setlength\bibitemsep{2pt}
\setlength\biblabelsep{4pt}

\newenvironment{referenceslide}[1][References]{%
  \begin{frame}[allowframebreaks]{#1}%
}{\end{frame}}

% ----------------------------------------------------------------
% Title page — dark with thin accent rule
% ----------------------------------------------------------------

\def\clin@trialid{}
\newcommand{\trialid}[1]{\def\clin@trialid{#1}}
\def\clin@sponsor{}
\newcommand{\sponsor}[1]{\def\clin@sponsor{#1}}

\defbeamertemplate*{title page}{rossbeamerclinical}{%
  \begin{tikzpicture}[remember picture, overlay]
    \fill[rbPrimary] (current page.south west) rectangle (current page.north east);
    \fill[rbAccent]
      ([yshift=12mm]current page.south west) rectangle
      ([yshift=12.6mm]current page.south east);
  \end{tikzpicture}%
  \vfill
  {\usebeamerfont{title}\color{rbTextLight}\inserttitle\par}%
  \ifx\insertsubtitle\empty\else
    \vskip6pt{\usebeamerfont{subtitle}\color{rbLightMuted}\insertsubtitle\par}\fi
  \vskip14pt%
  \ifx\insertauthor\empty\else
    {\usebeamerfont{author}\color{rbTextLight!85}\insertauthor\par}\fi
  \ifx\insertinstitute\empty\else
    \vskip2pt{\usebeamerfont{institute}\color{rbLightMuted}\insertinstitute\par}\fi
  \ifx\insertdate\empty\else
    \vskip2pt{\usebeamerfont{date}\color{rbLightMuted}\insertdate\par}\fi
  \ifx\clin@trialid\empty\else
    \vskip4pt{\usebeamerfont{date}\color{rbLightMuted}\texttt{\clin@trialid}\par}\fi
  \ifx\clin@sponsor\empty\else
    \vskip2pt{\usebeamerfont{date}\color{rbLightMuted}\itshape\clin@sponsor\par}\fi
  \vfill
}

% ================================================================
% CLINICAL-SPECIFIC FEATURES
% ================================================================

% ----------------------------------------------------------------
% Clinical colours (always available regardless of palette)
% ----------------------------------------------------------------

\definecolor{clinTreatment}{HTML}{1565C0}
\definecolor{clinControl}{HTML}{78909C}
\definecolor{clinPositive}{HTML}{2E7D32}
\definecolor{clinNegative}{HTML}{C62828}
\definecolor{clinNeutral}{HTML}{F9A825}
\definecolor{clinExclusion}{HTML}{B71C1C}
\definecolor{clinEnrolment}{HTML}{0D47A1}
\definecolor{clinAllocation}{HTML}{1B5E20}
\definecolor{clinFollowUp}{HTML}{E65100}
\definecolor{clinAnalysis}{HTML}{4A148C}

% ----------------------------------------------------------------
% NNT / ARR / NNH formatters
% ----------------------------------------------------------------

\providecommand{\NNT}[1]{%
  \textbf{\color{clinPositive}NNT\,=\,#1}%
}
\providecommand{\ARR}[1]{%
  \textbf{\color{clinPositive}ARR\,=\,#1}%
}
\providecommand{\NNH}[1]{%
  \textbf{\color{clinNegative}NNH\,=\,#1}%
}

% ----------------------------------------------------------------
% Inclusion / Exclusion criteria — two-column layout
% ----------------------------------------------------------------

\newcommand{\inclusionexclusion}[2]{%
  \begin{columns}[T]
    \begin{column}{0.47\textwidth}
      {\small\bfseries\color{clinPositive}Inclusion Criteria\par}%
      \vskip2pt{\color{clinPositive!40}\hrule height 0.3pt}\vskip4pt%
      {\small
        \begin{itemize}
          \setlength{\itemsep}{2pt}%
          \renewcommand{\labelitemi}{\color{clinPositive}\textbullet}%
          #1%
        \end{itemize}
      }%
    \end{column}%
    \hfill
    \begin{column}{0.47\textwidth}
      {\small\bfseries\color{clinExclusion}Exclusion Criteria\par}%
      \vskip2pt{\color{clinExclusion!40}\hrule height 0.3pt}\vskip4pt%
      {\small
        \begin{itemize}
          \setlength{\itemsep}{2pt}%
          \renewcommand{\labelitemi}{\color{clinExclusion}\textbullet}%
          #2%
        \end{itemize}
      }%
    \end{column}%
  \end{columns}%
}

% ----------------------------------------------------------------
% Endpoint card — primary / secondary outcome result
%
% \endpointcard{name}{result}{CI}{pval}
% ----------------------------------------------------------------

\newcommand{\endpointcard}[4]{%
  \begin{tcolorbox}[
    enhanced, colback=rbAccentBg, colframe=rbAccentBg, boxrule=0pt,
    borderline west={3pt}{0pt}{rbAccent}, sharp corners,
    left=8pt, right=8pt, top=6pt, bottom=6pt,
  ]
    {\small\bfseries\color{rbAccentDark}#1\par}%
    \vskip4pt%
    \begin{minipage}[t]{0.35\textwidth}
      {\fontsize{22}{26}\selectfont\bfseries\color{rbPrimary}#2\par}%
    \end{minipage}%
    \hfill
    \begin{minipage}[t]{0.55\textwidth}\raggedleft
      {\small\color{rbTextMuted}95\%~CI:~#3\par}%
      \vskip2pt%
      {\small\color{rbTextMuted}\textit{p}~=~#4\par}%
    \end{minipage}%
  \end{tcolorbox}%
}

% ----------------------------------------------------------------
% Adverse event row helper
%
% \adverseevent{event}{grade}{n}{pct}
% ----------------------------------------------------------------

\newcommand{\adverseevent}[4]{%
  #1 & {\small\color{rbTextMuted}Grade~#2} & #3 & #4\%%
  \\
}

% ----------------------------------------------------------------
% Adverse event table (convenience wrapper)
% ----------------------------------------------------------------

\newenvironment{aetable}[1][Adverse Events]{%
  \begin{frame}{#1}%
  \small
  \begin{tabular}{@{}l c r r@{}}
    \toprule
    \thead{Event} & \thead{Grade} & \thead{n} & \thead{\%} \\
    \midrule
}{%
    \bottomrule
  \end{tabular}%
  \end{frame}%
}

% ----------------------------------------------------------------
% Protocol timeline environment + visit points
%
% \begin{protocoltimeline}{total length cm}
%   \visitpoint{pos}{label}{procedures}
% \end{protocoltimeline}
% ----------------------------------------------------------------

\newenvironment{protocoltimeline}[1][12]{%
  \def\clin@tl@len{#1}%
  \begin{center}
  \begin{tikzpicture}[
    >={Stealth[length=4pt]},
    visitnode/.style={
      draw=rbPrimary, fill=rbAccentBg, rounded corners=2pt,
      font=\scriptsize, align=center, inner xsep=4pt, inner ysep=3pt,
      text=rbText,
    },
    visitlabel/.style={
      font=\scriptsize\bfseries, text=rbPrimary,
    },
    proctext/.style={
      font=\tiny, text=rbTextMuted, align=center,
    },
  ]
    % Draw the main timeline arrow
    \draw[->, line width=1.2pt, rbPrimary]
      (0,0) -- (\clin@tl@len,0);
    % Tick marks at start and end
    \draw[rbPrimary, line width=0.8pt] (0,-0.15) -- (0,0.15);
}{%
  \end{tikzpicture}
  \end{center}
}

\newcommand{\visitpoint}[3]{%
  % #1 = x-position along timeline (cm)
  % #2 = visit label (e.g. "Screening", "Week 4")
  % #3 = procedures text
  \draw[rbPrimary, line width=0.8pt] (#1,-0.15) -- (#1,0.15);
  \fill[rbAccent] (#1,0) circle (3pt);
  \node[visitlabel, above=6pt] at (#1,0) {#2};
  \node[proctext, below=8pt, text width=2cm] at (#1,0) {#3};
}

% ----------------------------------------------------------------
% CONSORT flow helpers
% ----------------------------------------------------------------

\providecommand{\consentflow}{%
  % Provide standard CONSORT phase labels
  \def\clin@flow@enrolled{Enrolment}%
  \def\clin@flow@allocated{Allocation}%
  \def\clin@flow@followup{Follow-Up}%
  \def\clin@flow@analysed{Analysis}%
}

\providecommand{\flowbox}[1]{%
  \tikz{\node[draw=rbAccent, rounded corners=2pt, fill=rbAccentBg,
    text=rbText, font=\small, align=center,
    inner xsep=8pt, inner ysep=4pt] {#1};}%
}
\providecommand{\flowboxexcluded}[1]{%
  \tikz{\node[draw=clinExclusion!60, rounded corners=2pt, fill=clinExclusion!5,
    text=rbTextMuted, font=\scriptsize, align=center,
    inner xsep=6pt, inner ysep=3pt] {#1};}%
}
\providecommand{\flowarrow}{%
  \par\vskip2pt\centering
  \tikz{\draw[->, rbAccent, line width=1pt] (0,0) -- (0,-0.5);}%
  \par\vskip2pt%
}

% ----------------------------------------------------------------
% Randomisation diagram
%
% \randomise{n}{arms}  — arms is a comma-separated list
% e.g. \randomise{240}{Treatment (n=120), Placebo (n=120)}
% ----------------------------------------------------------------

\newcommand{\randomise}[2]{%
  \begin{center}
  \begin{tikzpicture}[
    >={Stealth[length=4pt]},
    rbox/.style={
      draw=rbPrimary, fill=rbAccentBg, rounded corners=3pt,
      font=\small, align=center, text=rbText,
      inner xsep=10pt, inner ysep=6pt, minimum width=3.5cm,
    },
    armbox/.style={
      draw=rbSecondary, fill=rbSecondary!8, rounded corners=3pt,
      font=\small, align=center, text=rbText,
      inner xsep=8pt, inner ysep=5pt, minimum width=3cm,
    },
  ]
    % Top: randomised box
    \node[rbox] (R) at (0,0) {Randomised\\(\textit{N}\,=\,#1)};
    % Parse arms: count them
    \def\clin@armlist{#2}%
    \newcount\clin@armcount\clin@armcount=0
    \def\clin@countarms##1,{\advance\clin@armcount by 1\@ifnextchar\relax{}{\clin@countarms}}%
    % Simple approach: place arms manually by splitting on comma
    \newcount\clin@armidx\clin@armidx=0
    \def\clin@spacing{3.5}%
    % We use a \foreach to handle the arm list
    \foreach \armtext [count=\ai from 0] in {#2} {
      \pgfmathsetmacro{\totalarms}{0}%
      \foreach \dummy in {#2} {
        \pgfmathsetmacro{\totalarms}{\totalarms+1}%
      }%
      \pgfmathsetmacro{\xpos}{(\ai - (\totalarms-1)/2) * \clin@spacing}%
      \node[armbox] (arm\ai) at (\xpos,-2) {\armtext};
      \draw[->, rbPrimary, line width=0.8pt] (R.south) -- ++(0,-0.5) -| (arm\ai.north);
    }
  \end{tikzpicture}
  \end{center}
}

% ----------------------------------------------------------------
% Safety comparison card
%
% \safetycard{event}{treatment %}{control %}{p-value}
% ----------------------------------------------------------------

\newcommand{\safetycard}[4]{%
  \begin{tcolorbox}[
    enhanced, colback=white, colframe=white, boxrule=0pt,
    borderline west={3pt}{0pt}{clinNegative!70}, sharp corners,
    left=8pt, right=8pt, top=5pt, bottom=5pt,
  ]
    {\small\bfseries\color{rbText}#1\par}%
    \vskip3pt%
    \begin{minipage}[t]{0.30\textwidth}
      {\small\color{clinTreatment}\textbf{Treatment}\par}%
      {\normalsize\bfseries\color{clinTreatment}#2\par}%
    \end{minipage}%
    \hfill
    \begin{minipage}[t]{0.30\textwidth}
      {\small\color{clinControl}\textbf{Control}\par}%
      {\normalsize\bfseries\color{clinControl}#3\par}%
    \end{minipage}%
    \hfill
    \begin{minipage}[t]{0.25\textwidth}\raggedleft
      {\small\color{rbTextMuted}\textit{p}~=~#4\par}%
    \end{minipage}%
  \end{tcolorbox}%
}

% ----------------------------------------------------------------
% Finding / limitation / implication boxes (clinical flavour)
% ----------------------------------------------------------------

\newtcolorbox{findingbox}[1][Key Finding]{%
  enhanced, colback=rbAccentBg, colframe=rbAccentBg, boxrule=0pt,
  borderline west={3pt}{0pt}{rbAccent}, sharp corners,
  left=8pt, right=8pt, top=5pt, bottom=5pt,
  fonttitle=\small\bfseries\color{rbAccentDark},
  coltitle=rbAccentDark, title={#1},
}
\newtcolorbox{limitationbox}[1][Limitation]{%
  enhanced, colback=rbWarningBg, colframe=rbWarningBg, boxrule=0pt,
  borderline west={3pt}{0pt}{rbWarning}, sharp corners,
  left=8pt, right=8pt, top=5pt, bottom=5pt,
  fonttitle=\small\bfseries\color{rbWarning},
  coltitle=rbWarning, title={#1},
}
\newtcolorbox{implicationbox}[1][Clinical Implication]{%
  enhanced, colback=rbSuccessBg, colframe=rbSuccessBg, boxrule=0pt,
  borderline west={3pt}{0pt}{rbSuccess}, sharp corners,
  left=8pt, right=8pt, top=5pt, bottom=5pt,
  fonttitle=\small\bfseries\color{rbSuccess},
  coltitle=rbSuccess, title={#1},
}

% ----------------------------------------------------------------
% Statistical formatting helpers (basic; use stats option for full)
% ----------------------------------------------------------------

\providecommand{\pval}[1]{%
  \textit{p}~\ifdim #1pt<0.001pt <~.001\else =~#1\fi
}
\providecommand{\ci}[3]{#1~[#2,~#3]}
\providecommand{\CI}[4]{#2,~#1\%~CI~[#3,~#4]}
\providecommand{\OR}[3]{OR~=~#1~[#2,~#3]}
\providecommand{\HR}[3]{HR~=~#1~[#2,~#3]}
\providecommand{\RR}[3]{RR~=~#1~[#2,~#3]}
\providecommand{\effectsize}[2]{\textit{#1}~=~#2}

% ----------------------------------------------------------------
% Slide footnotes
% ----------------------------------------------------------------

\newcommand{\slidefootnote}[2][0.7\paperwidth]{%
  \begin{tikzpicture}[remember picture, overlay]
    \node[anchor=south west, inner sep=0pt, text width=#1]
      at ([xshift=12mm, yshift=8mm]current page.south west)
      {\scriptsize\color{rbTextMuted}#2};
  \end{tikzpicture}%
}

% ----------------------------------------------------------------
% APA-style notes
% ----------------------------------------------------------------

\newcommand{\figurenote}[1]{%
  \par\vskip2pt{\scriptsize\color{rbText}\textit{Note.}~#1\par}%
}
\newcommand{\tablenote}[1]{%
  \par\vskip2pt{\scriptsize\color{rbText}\textit{Note.}~#1\par}%
}
\newcommand{\sigmarkers}{%
  \par\vskip1pt{\scriptsize\color{rbTextMuted}%
    *\,\textit{p}~<~.05.\quad **\,\textit{p}~<~.01.\quad ***\,\textit{p}~<~.001.\par}%
}

% ----------------------------------------------------------------
% Backup slides
% ----------------------------------------------------------------

\newcommand{\backupslides}{%
  \appendix
  \begin{darkframe}[c,plain]
    \centering
    {\usebeamerfont{title}\color{rbTextLight}Backup Slides\par}%
    \vskip6pt{\normalsize\color{rbLightMuted}Additional analyses and supplementary material\par}
  \end{darkframe}
}

% ----------------------------------------------------------------
% Research question / hypothesis frames
% ----------------------------------------------------------------

\newcommand{\researchquestion}[2][Research Question]{%
  \begin{frame}[c]{}\centering
    {\small\bfseries\color{rbAccent}\MakeUppercase{#1}\par}%
    \vskip8pt{\Large\color{rbPrimary}\itshape #2\par}%
  \end{frame}
}
\newcommand{\hypothesis}[2][Hypothesis]{%
  \begin{frame}[c]{}\centering
    {\small\bfseries\color{rbAccent}\MakeUppercase{#1}\par}%
    \vskip8pt{\large\color{rbPrimary}#2\par}%
  \end{frame}
}

% ----------------------------------------------------------------
% Study design summary
% ----------------------------------------------------------------

\newenvironment{studydesign}[1]{\begin{frame}{#1}}{\end{frame}}
\newcommand{\designitem}[2]{%
  \par\vskip4pt%
  \begin{minipage}[t]{0.22\textwidth}\raggedleft
    {\small\bfseries\color{rbAccent}#1}%
  \end{minipage}\hspace{8pt}%
  \begin{minipage}[t]{0.70\textwidth}%
    {\small\color{rbText}#2}%
  \end{minipage}%
}

% ----------------------------------------------------------------
% Corresponding author / ORCID
% ----------------------------------------------------------------

\newcommand{\corresponding}{\textsuperscript{\color{rbAccent}*}}
\newcommand{\correspondinginfo}[1]{%
  \begin{tikzpicture}[remember picture, overlay]
    \node[anchor=south west, inner sep=0pt]
      at ([xshift=12mm, yshift=4mm]current page.south west)
      {\scriptsize\color{rbLightMuted}\textsuperscript{*}Corresponding author: #1};
  \end{tikzpicture}%
}
\newcommand{\orcid}[1]{%
  {\scriptsize\color{rbAccent}\href{https://orcid.org/#1}{ORCID: #1}}%
}

% ----------------------------------------------------------------
% Equation highlighting
% ----------------------------------------------------------------

\newcommand{\eqhl}[2][rbAccent]{%
  \tikz[baseline=(X.base)]{%
    \node[fill=#1!15, inner sep=1.5pt, rounded corners=1pt] (X) {$\displaystyle #2$};}%
}
\newtcolorbox{eqbox}[1][]{%
  enhanced, colback=rbBg, colframe=rbRule,
  boxrule=0.4pt, sharp corners,
  left=4pt, right=4pt, top=4pt, bottom=4pt,
  fonttitle=\scriptsize\color{rbTextMuted}, coltitle=rbTextMuted, title={#1},
}

% ----------------------------------------------------------------
\endinput
