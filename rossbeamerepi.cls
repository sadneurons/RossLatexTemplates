% rossbeamerepi.cls
% Epidemiology Beamer class — DAGs, 2x2 tables, epidemic curves,
% forest plot annotations, STROBE checklists, and epi measure
% formatting for public-health and epidemiology presentations.
%
% Usage:
%   \documentclass[palette=epi]{rossbeamerepi}
%
% Available palettes:
%   epi (default)    — earth/green tones
%   outbreak         — red/amber alert palette
%   surveillance     — blue/grey monitoring palette
%
% Options:
%   palette=<name>   font=<fira|inter|sourcesans|libertinus|heros|georgia|system>
%   monofont=<name>  loadstats  nobar  nologo
%
% Ross Dunne / Claude, 2026

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{rossbeamerepi}[2026/03/24 Epidemiology Beamer class]

% ----------------------------------------------------------------
% Option handling
% ----------------------------------------------------------------

\RequirePackage{pgfkeys}
\RequirePackage{pgfopts}

\newif\ifrb@nobar      \rb@nobarfalse
\newif\ifrb@nologo     \rb@nologofalse
\newif\ifepi@loadstats \epi@loadstatsfalse

\pgfkeys{
  /epibeamer/.cd,
  palette/.store in=\epi@palette,      palette=epi,
  font/.store in=\epi@fontchoice,      font=fira,
  monofont/.store in=\epi@mono,        monofont=,
  loadstats/.code={\epi@loadstatstrue},
  nobar/.code={\rb@nobartrue},
  nologo/.code={\rb@nologotrue},
}
\ProcessPgfOptions{/epibeamer}

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

\ifepi@loadstats
  \RequirePackage{rossstats}
\fi

% ----------------------------------------------------------------
% Palette definitions (12-field format)
%
% \epi@defpal{name}
%   {primary}{secondary}{accent}{text}{textlight}{textmuted}{bg}{rule}
%   {accentdark}{accentlight}{accentbg}{lightmuted}
% ----------------------------------------------------------------

\newcommand{\epi@defpal}[9]{%
  \expandafter\def\csname epi@p@#1@P\endcsname{#2}%   primary
  \expandafter\def\csname epi@p@#1@S\endcsname{#3}%   secondary
  \expandafter\def\csname epi@p@#1@A\endcsname{#4}%   accent
  \expandafter\def\csname epi@p@#1@T\endcsname{#5}%   text
  \expandafter\def\csname epi@p@#1@TL\endcsname{#6}%  textlight
  \expandafter\def\csname epi@p@#1@TM\endcsname{#7}%  textmuted
  \expandafter\def\csname epi@p@#1@B\endcsname{#8}%   bg
  \expandafter\def\csname epi@p@#1@R\endcsname{#9}%   rule
  \epi@defpal@cont{#1}%
}
\newcommand{\epi@defpal@cont}[5]{%
  \expandafter\def\csname epi@p@#1@AD\endcsname{#2}%  accentdark
  \expandafter\def\csname epi@p@#1@AL\endcsname{#3}%  accentlight
  \expandafter\def\csname epi@p@#1@AB\endcsname{#4}%  accentbg
  \expandafter\def\csname epi@p@#1@LM\endcsname{#5}%  lightmuted
}

%                      name          P       S       A       T       TL      TM      B       R       AD      AL      AB      LM
% epi: earth/green — field epidemiology
\epi@defpal{epi}       {1B3A2A}{4A7C59}{2D6A4F}{1C1C1C}{FFFFFF}{5A6B5A}{F7FAF5}{C8D8CE}{1B4332}{6BAF8D}{EDF5F0}{90B0A0}
% outbreak: red/amber — emergency / outbreak response
\epi@defpal{outbreak}  {3A0A0A}{D95040}{C0392B}{1C1C1C}{FFFFFF}{786060}{FBF6F5}{DDD0CC}{8B1A10}{E08060}{FBEEEB}{B89898}
% surveillance: blue/grey — routine monitoring / surveillance
\epi@defpal{surveillance}{1A2838}{5A8AA8}{3B6B8A}{1C1C1C}{FFFFFF}{607080}{F5F7F9}{CDD5DD}{2A5070}{7AAFC5}{ECF2F6}{90A0B0}

% ----------------------------------------------------------------
% Palette activation
% ----------------------------------------------------------------

\newcommand{\epi@activatepalette}{%
  % Core colours
  \definecolor{rbPrimary}{HTML}{\csname epi@p@\epi@palette @P\endcsname}%
  \definecolor{rbSecondary}{HTML}{\csname epi@p@\epi@palette @S\endcsname}%
  \definecolor{rbAccent}{HTML}{\csname epi@p@\epi@palette @A\endcsname}%
  \definecolor{rbText}{HTML}{\csname epi@p@\epi@palette @T\endcsname}%
  \definecolor{rbTextLight}{HTML}{\csname epi@p@\epi@palette @TL\endcsname}%
  \definecolor{rbTextMuted}{HTML}{\csname epi@p@\epi@palette @TM\endcsname}%
  \definecolor{rbBg}{HTML}{\csname epi@p@\epi@palette @B\endcsname}%
  \definecolor{rbRule}{HTML}{\csname epi@p@\epi@palette @R\endcsname}%
  % Derive standard colours
  \rb@derivecolors
  % Override with explicit palette refinements
  \definecolor{rbAccentDark}{HTML}{\csname epi@p@\epi@palette @AD\endcsname}%
  \definecolor{rbAccentLight}{HTML}{\csname epi@p@\epi@palette @AL\endcsname}%
  \definecolor{rbAccentBg}{HTML}{\csname epi@p@\epi@palette @AB\endcsname}%
  \definecolor{rbLightMuted}{HTML}{\csname epi@p@\epi@palette @LM\endcsname}%
  % Legacy aliases
  \colorlet{epibDark}{rbPrimary}%
  \colorlet{epibText}{rbText}%
  \colorlet{epibMuted}{rbTextMuted}%
  \colorlet{epibAccent}{rbAccent}%
  \colorlet{epibAccentDark}{rbAccentDark}%
  \colorlet{epibAccentLight}{rbAccentLight}%
  \colorlet{epibAccentBg}{rbAccentBg}%
  \colorlet{epibBg}{rbBg}%
  \colorlet{epibLight}{rbTextLight}%
  \colorlet{epibLightMuted}{rbLightMuted}%
  \colorlet{epibRule}{rbRule}%
  \colorlet{epibProgress1}{rbAccent}%
  \colorlet{epibProgress2}{rbRule}%
}
\epi@activatepalette

\newcommand{\setpalette}[1]{\def\epi@palette{#1}\epi@activatepalette}

% ----------------------------------------------------------------
% Beamer setup
% ----------------------------------------------------------------

\rb@setupbeamer
\setbeamersize{text margin left=12mm, text margin right=12mm}

% Epi frame title: with underline rule
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
\rb@activatefont{\epi@fontchoice}
\rb@activatemono{\epi@mono}
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

\def\epi@conference{}
\newcommand{\conference}[1]{\def\epi@conference{#1}}

\defbeamertemplate*{title page}{rossbeamerepi}{%
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
  \ifx\epi@conference\empty\else
    \vskip4pt{\usebeamerfont{date}\color{rbLightMuted}\itshape\epi@conference\par}\fi
  \vfill
}

% ================================================================
% EPIDEMIOLOGY-SPECIFIC FEATURES
% ================================================================

% ----------------------------------------------------------------
% Incidence rate formatting
% \incidencerate{5.2}{1{,}000}{person-years}
%   → Incidence rate: 5.2 per 1,000 person-years
% ----------------------------------------------------------------

\newcommand{\incidencerate}[3]{%
  {\small\color{rbAccentDark}\textbf{Incidence rate:}\enspace
    #1\enspace per\enspace #2\enspace #3}%
}

% ----------------------------------------------------------------
% Prevalence rate formatting
% \prevalencerate{12.4\%}{95\% CI [10.1, 14.8]}
%   → Prevalence: 12.4% (95% CI [10.1, 14.8])
% ----------------------------------------------------------------

\newcommand{\prevalencerate}[2]{%
  {\small\color{rbAccentDark}\textbf{Prevalence:}\enspace #1\enspace (#2)}%
}

% ----------------------------------------------------------------
% Rate ratio display
% \rateratio{45.0}{22.5}{2.0}{1.4--2.8}
%   → tabular: Exposed 45.0 | Unexposed 22.5 | RR = 2.0 (95% CI 1.4–2.8)
% ----------------------------------------------------------------

\newcommand{\rateratio}[4]{%
  \begin{tabular}{@{}lll@{}}
    \toprule
    {\small\bfseries\color{rbAccent}Exposed} &
    {\small\bfseries\color{rbAccent}Unexposed} &
    {\small\bfseries\color{rbAccent}Rate Ratio} \\
    \midrule
    {\small #1} & {\small #2} &
    {\small RR~=~#3\enspace (95\%~CI~#4)} \\
    \bottomrule
  \end{tabular}%
}

% ----------------------------------------------------------------
% 2×2 contingency table
% \twobytwo{a}{b}{c}{d}
%             Disease+  Disease-
%   Exposed+     a         b
%   Exposed-     c         d
% ----------------------------------------------------------------

\newcommand{\twobytwo}[4]{%
  \begin{center}
  \begin{tabular}{@{}l
      >{\centering\arraybackslash}p{2.4cm}
      >{\centering\arraybackslash}p{2.4cm}@{}}
    \toprule
    & {\small\bfseries\color{rbAccent}Disease\,+}
    & {\small\bfseries\color{rbAccent}Disease\,\textminus} \\
    \midrule
    {\small\bfseries\color{rbPrimary}Exposed\,+}
      & {\small #1} & {\small #2} \\[3pt]
    {\small\bfseries\color{rbPrimary}Exposed\,\textminus}
      & {\small #3} & {\small #4} \\
    \bottomrule
  \end{tabular}
  \end{center}%
}

% ----------------------------------------------------------------
% DAG diagram helpers
%
% \begin{dagframe}{DAG Title}
%   \dagnode{E}{Exposure}{0}{0}
%   \dagnode{O}{Outcome}{4}{0}
%   \dagconfounder{C}{Confounder}{2}{1.5}
%   \dagarrow{E}{O}
%   \dagarrow{C}{E}
%   \dagarrow{C}{O}
% \end{dagframe}
% ----------------------------------------------------------------

\usetikzlibrary{arrows.meta,positioning}

\newenvironment{dagframe}[1]{%
  \begin{frame}{#1}%
  \centering
  \begin{tikzpicture}[
    dagnode/.style={
      rectangle, rounded corners=3pt,
      draw=rbAccent, fill=rbAccentBg,
      text=rbText, font=\small\bfseries,
      minimum width=2cm, minimum height=0.8cm,
      inner sep=4pt,
    },
    dagconf/.style={
      rectangle, rounded corners=3pt,
      draw=rbSecondary, fill=rbSecondary!10!white,
      text=rbText, font=\small\bfseries,
      minimum width=2cm, minimum height=0.8cm,
      inner sep=4pt,
    },
    dagedge/.style={
      -Stealth, thick, rbPrimary,
    },
  ]
}{%
  \end{tikzpicture}%
  \end{frame}%
}

\newcommand{\dagnode}[4]{%
  \node[dagnode] (#1) at (#3,#4) {#2};%
}
\newcommand{\dagarrow}[2]{%
  \draw[dagedge] (#1) -- (#2);%
}
\newcommand{\dagconfounder}[4]{%
  \node[dagconf] (#1) at (#3,#4) {#2};%
}

% ----------------------------------------------------------------
% Outbreak timeline / epidemic curve
%
% \begin{outbreaktimeline}
%   \epiweek{1}{5}{Wk 1}
%   \epiweek{2}{12}{Wk 2}
%   \epiweek{3}{8}{Wk 3}
% \end{outbreaktimeline}
% ----------------------------------------------------------------

\newcounter{epi@maxcases}
\newcommand{\epi@barscale}{0.12}

\newenvironment{outbreaktimeline}{%
  \begin{center}
  \begin{tikzpicture}[
    epibar/.style={
      fill=rbAccent, draw=rbAccentDark, line width=0.3pt,
    },
  ]
  \def\epi@bars{}%
  \gdef\epi@barcount{0}%
}{%
  % Draw axis
  \draw[rbText, thick, -Stealth]
    (-0.3,0) -- (\epi@barcount+0.8,0)
    node[right, font=\scriptsize\color{rbTextMuted}] {Time};
  \draw[rbText, thick, -Stealth]
    (0,-0.3) -- (0,4.5)
    node[above, font=\scriptsize\color{rbTextMuted}] {Cases};
  \end{tikzpicture}
  \end{center}%
}

\newcommand{\epiweek}[3]{%
  % #1=x position, #2=case count, #3=label
  \fill[epibar] (#1-0.35,0) rectangle (#1+0.35,#2*\epi@barscale);
  \node[below, font=\scriptsize\color{rbTextMuted}] at (#1,0) {#3};
  \node[above, font=\scriptsize\bfseries\color{rbAccentDark}]
    at (#1,#2*\epi@barscale) {#2};
  \xdef\epi@barcount{#1}%
}

% ----------------------------------------------------------------
% Forest plot row annotation
% \forestrow{Study}{1.25}{0.98}{1.60}{15\%}
%   → Study   ——●——   1.25 [0.98, 1.60]  15%
% ----------------------------------------------------------------

\newcommand{\forestrow}[5]{%
  % #1=study, #2=effect, #3=lower, #4=upper, #5=weight
  \par\vskip2pt%
  \noindent
  \begin{minipage}[c]{0.20\textwidth}
    {\small\color{rbText}#1}%
  \end{minipage}%
  \begin{minipage}[c]{0.35\textwidth}\centering
    \begin{tikzpicture}[baseline=0pt]
      % CI line
      \pgfmathsetmacro{\lo}{(#3-1)*3}
      \pgfmathsetmacro{\hi}{(#4-1)*3}
      \pgfmathsetmacro{\pt}{(#2-1)*3}
      \draw[rbAccent, thick] (\lo,0) -- (\hi,0);
      % Point estimate
      \fill[rbPrimary] (\pt,0) circle (2.5pt);
      % Null line
      \draw[rbRule, thin, dashed] (0,-0.2) -- (0,0.2);
    \end{tikzpicture}%
  \end{minipage}%
  \begin{minipage}[c]{0.30\textwidth}
    {\small\color{rbText}#2~[#3,~#4]}%
  \end{minipage}%
  \begin{minipage}[c]{0.12\textwidth}\raggedleft
    {\small\color{rbTextMuted}#5}%
  \end{minipage}%
}

% ----------------------------------------------------------------
% Attributable risk (providecommand — avoids clash with rossstats)
% \attributablerisk{0.15}  → AR = 0.15
% ----------------------------------------------------------------

\providecommand{\attributablerisk}[1]{%
  AR~=~#1%
}

% ----------------------------------------------------------------
% Odds ratio (providecommand — avoids clash with rossstats)
% \oddsratio{2.1}{1.4}{3.2}  → Odds ratio = 2.1 [1.4, 3.2]
% ----------------------------------------------------------------

\providecommand{\oddsratio}[3]{%
  Odds ratio~=~#1~[#2,~#3]%
}

% ----------------------------------------------------------------
% STROBE checklist item
% \strobeitem{1}{Title and abstract}
% ----------------------------------------------------------------

\newcommand{\strobeitem}[2]{%
  \par\vskip2pt\noindent
  \tikz[baseline=-0.3em]{%
    \node[circle, fill=rbAccent, text=rbTextLight,
          inner sep=0pt, minimum size=1.5em,
          font=\scriptsize\bfseries] {#1};}%
  \enspace{\small\color{rbText}#2}%
}

% ----------------------------------------------------------------
% Finding / limitation / implication boxes (epi-tuned)
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
\newtcolorbox{implicationbox}[1][Public Health Implication]{%
  enhanced, colback=rbSuccessBg, colframe=rbSuccessBg, boxrule=0pt,
  borderline west={3pt}{0pt}{rbSuccess}, sharp corners,
  left=8pt, right=8pt, top=5pt, bottom=5pt,
  fonttitle=\small\bfseries\color{rbSuccess},
  coltitle=rbSuccess, title={#1},
}

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
\endinput
