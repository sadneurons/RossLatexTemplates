% rossbeamerpsych.cls
% Psychological / neuropsychological assessment Beamer class — score cards,
% norm bars, cognitive profiles, DSM checklists, and classification tables
% for clinical and research presentations.
%
% Usage:
%   \documentclass[palette=psych]{rossbeamerpsych}
%
% Available palettes:
%   psych   — clinical blue/green (default)
%   neuro   — dark navy/warm accents
%   assess  — slate/teal
%
% Options:
%   palette=<name>   font=<fira|inter|sourcesans|libertinus|heros|georgia|system>
%   monofont=<name>  nobar  nologo  stats
%
% Ross Dunne / Claude, 2026

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{rossbeamerpsych}[2026/03/24 Psychological assessment Beamer class]

% ----------------------------------------------------------------
% Option handling
% ----------------------------------------------------------------

\RequirePackage{pgfkeys}
\RequirePackage{pgfopts}

\newif\ifrb@nobar  \rb@nobarfalse
\newif\ifrb@nologo \rb@nologofalse
\newif\ifpsy@stats \psy@statsfalse

\pgfkeys{
  /psybeamer/.cd,
  palette/.store in=\psy@palette,       palette=psych,
  font/.store in=\psy@fontchoice,       font=fira,
  monofont/.store in=\psy@mono,         monofont=,
  nobar/.code={\rb@nobartrue},
  nologo/.code={\rb@nologotrue},
  stats/.code={\psy@statstrue},
}
\ProcessPgfOptions{/psybeamer}

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

\ifpsy@stats
  \RequirePackage{rossstats}
\fi

% ----------------------------------------------------------------
% Additional packages for domain features
% ----------------------------------------------------------------

\RequirePackage{array}
\RequirePackage{xparse}

% ----------------------------------------------------------------
% Palette definitions (12-field format)
%
% \psy@defpal{name}
%   {primary}{secondary}{accent}{text}{textlight}{textmuted}{bg}{rule}
%   {accentdark}{accentlight}{accentbg}{lightmuted}
% ----------------------------------------------------------------

\newcommand{\psy@defpal}[9]{%
  \expandafter\def\csname psy@p@#1@P\endcsname{#2}%   primary
  \expandafter\def\csname psy@p@#1@S\endcsname{#3}%   secondary
  \expandafter\def\csname psy@p@#1@A\endcsname{#4}%   accent
  \expandafter\def\csname psy@p@#1@T\endcsname{#5}%   text
  \expandafter\def\csname psy@p@#1@TL\endcsname{#6}%  textlight
  \expandafter\def\csname psy@p@#1@TM\endcsname{#7}%  textmuted
  \expandafter\def\csname psy@p@#1@B\endcsname{#8}%   bg
  \expandafter\def\csname psy@p@#1@R\endcsname{#9}%   rule
  \psy@defpal@cont{#1}%
}
\newcommand{\psy@defpal@cont}[5]{%
  \expandafter\def\csname psy@p@#1@AD\endcsname{#2}%  accentdark
  \expandafter\def\csname psy@p@#1@AL\endcsname{#3}%  accentlight
  \expandafter\def\csname psy@p@#1@AB\endcsname{#4}%  accentbg
  \expandafter\def\csname psy@p@#1@LM\endcsname{#5}%  lightmuted
}

%                     name       P       S       A       T       TL      TM      B       R       AD      AL      AB      LM
\psy@defpal{psych}   {1B3A5C}{3A8E7A}{2E7D6A}{1C1C1C}{FFFFFF}{5A6B78}{F6F8FA}{CDD5DD}{1B5E4A}{5AB89A}{ECF5F2}{8898A8}
\psy@defpal{neuro}   {0F1B2D}{C07040}{B45A28}{1C1C1C}{FFFFFF}{5A6878}{F7F8FA}{CCD4DD}{8A3E18}{D8906A}{FBF2EC}{8898B0}
\psy@defpal{assess}  {2A3848}{3A9A9A}{2A8080}{1C1C1C}{FFFFFF}{607080}{F5F8F9}{CDD5DD}{1A6060}{5ABAAB}{E8F4F2}{90A0B0}

% ----------------------------------------------------------------
% Palette activation
% ----------------------------------------------------------------

\newcommand{\psy@activatepalette}{%
  % Core colours
  \definecolor{rbPrimary}{HTML}{\csname psy@p@\psy@palette @P\endcsname}%
  \definecolor{rbSecondary}{HTML}{\csname psy@p@\psy@palette @S\endcsname}%
  \definecolor{rbAccent}{HTML}{\csname psy@p@\psy@palette @A\endcsname}%
  \definecolor{rbText}{HTML}{\csname psy@p@\psy@palette @T\endcsname}%
  \definecolor{rbTextLight}{HTML}{\csname psy@p@\psy@palette @TL\endcsname}%
  \definecolor{rbTextMuted}{HTML}{\csname psy@p@\psy@palette @TM\endcsname}%
  \definecolor{rbBg}{HTML}{\csname psy@p@\psy@palette @B\endcsname}%
  \definecolor{rbRule}{HTML}{\csname psy@p@\psy@palette @R\endcsname}%
  % Derive standard colours
  \rb@derivecolors
  % Override with explicit palette refinements
  \definecolor{rbAccentDark}{HTML}{\csname psy@p@\psy@palette @AD\endcsname}%
  \definecolor{rbAccentLight}{HTML}{\csname psy@p@\psy@palette @AL\endcsname}%
  \definecolor{rbAccentBg}{HTML}{\csname psy@p@\psy@palette @AB\endcsname}%
  \definecolor{rbLightMuted}{HTML}{\csname psy@p@\psy@palette @LM\endcsname}%
}
\psy@activatepalette

\newcommand{\setpalette}[1]{\def\psy@palette{#1}\psy@activatepalette}

% ----------------------------------------------------------------
% Beamer setup
% ----------------------------------------------------------------

\rb@setupbeamer
\setbeamersize{text margin left=12mm, text margin right=12mm}

% Psych frame title: with accent underline
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
\rb@activatefont{\psy@fontchoice}
\rb@activatemono{\psy@mono}
\usefonttheme[onlymath]{serif}

% Footer: always on
\rb@activatefooter

% ----------------------------------------------------------------
% Biblatex integration
% ----------------------------------------------------------------

\RequirePackage[
  backend=biber,
  style=apa,
  sorting=nyt,
  autocite=inline,
  maxbibnames=3, minbibnames=1,
  maxcitenames=2, mincitenames=1,
  giveninits=true,
  doi=false, isbn=false, url=false, eprint=false,
]{biblatex}

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
% Title page — dark with accent rule
% ----------------------------------------------------------------

\defbeamertemplate*{title page}{rossbeamerpsych}{%
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
  \vfill
}

% ================================================================
% PSYCHOLOGICAL ASSESSMENT FEATURES
% ================================================================

% ----------------------------------------------------------------
% Classification colours (used across multiple commands)
% ----------------------------------------------------------------

\definecolor{psy@Impaired}{HTML}{C62828}
\definecolor{psy@Borderline}{HTML}{E65100}
\definecolor{psy@LowAverage}{HTML}{F9A825}
\definecolor{psy@Average}{HTML}{2E7D32}
\definecolor{psy@HighAverage}{HTML}{1565C0}
\definecolor{psy@Superior}{HTML}{4A148C}
\definecolor{psy@VySuperior}{HTML}{1A237E}

% Map classification string to colour
\newcommand{\psy@classcolor}[1]{%
  \def\psy@tmp{#1}%
  \def\psy@cImp{Impaired}\def\psy@cBord{Borderline}%
  \def\psy@cLow{Low Average}\def\psy@cAvg{Average}%
  \def\psy@cHigh{High Average}\def\psy@cSup{Superior}%
  \def\psy@cVS{Very Superior}%
  \ifx\psy@tmp\psy@cImp psy@Impaired%
  \else\ifx\psy@tmp\psy@cBord psy@Borderline%
  \else\ifx\psy@tmp\psy@cLow psy@LowAverage%
  \else\ifx\psy@tmp\psy@cAvg psy@Average%
  \else\ifx\psy@tmp\psy@cHigh psy@HighAverage%
  \else\ifx\psy@tmp\psy@cSup psy@Superior%
  \else\ifx\psy@tmp\psy@cVS psy@VySuperior%
  \else rbTextMuted%
  \fi\fi\fi\fi\fi\fi\fi
}

% ----------------------------------------------------------------
% \scorecard{test}{score}{percentile}{classification}
%   Styled card displaying a single test result
% ----------------------------------------------------------------

\newcommand{\scorecard}[4]{%
  \begin{tcolorbox}[
    enhanced, colback=white, colframe=rbRule,
    boxrule=0.4pt, sharp corners,
    left=8pt, right=8pt, top=6pt, bottom=6pt,
    borderline west={3pt}{0pt}{\psy@classcolor{#4}},
  ]
    {\small\bfseries\color{rbPrimary}#1}\hfill
    {\small\color{rbTextMuted}Percentile: #3}\par
    \vskip4pt
    {\fontsize{28}{32}\selectfont\bfseries\color{\psy@classcolor{#4}}#2}\hfill
    {\normalsize\color{\psy@classcolor{#4}}#4\par}%
  \end{tcolorbox}%
}

% ----------------------------------------------------------------
% \normbar{score}{mean}{sd}{label}
%   Horizontal bar showing score position relative to norms
% ----------------------------------------------------------------

\newcommand{\normbar}[4]{%
  \begin{tikzpicture}[x=0.035\textwidth, y=1cm]
    % Axis: score range mapped as mean +/- 4 SD
    \pgfmathsetmacro{\axmin}{#2 - 4*#3}%
    \pgfmathsetmacro{\axmax}{#2 + 4*#3}%
    \pgfmathsetmacro{\normlo}{#2 - #3}%
    \pgfmathsetmacro{\normhi}{#2 + #3}%
    \pgfmathsetmacro{\scorepos}{max(min(#1,\axmax),\axmin)}%
    % Map to 0–28 drawing units
    \pgfmathsetmacro{\drawmin}{0}%
    \pgfmathsetmacro{\drawmax}{28}%
    \pgfmathsetmacro{\tounit}{(\drawmax-\drawmin)/(\axmax-\axmin)}%
    \pgfmathsetmacro{\nloU}{(\normlo-\axmin)*\tounit}%
    \pgfmathsetmacro{\nhiU}{(\normhi-\axmin)*\tounit}%
    \pgfmathsetmacro{\meanU}{(#2-\axmin)*\tounit}%
    \pgfmathsetmacro{\scoreU}{(\scorepos-\axmin)*\tounit}%
    % Background bar
    \fill[rbBg] (0,-0.15) rectangle (28,0.15);
    % Normal range shading
    \fill[rbAccentBg] (\nloU,-0.15) rectangle (\nhiU,0.15);
    % Mean marker
    \draw[rbTextMuted, line width=0.6pt, dashed] (\meanU,-0.18) -- (\meanU,0.18);
    % Score marker
    \fill[rbAccent] (\scoreU,0) circle (0.12);
    % Label
    \node[anchor=west, font=\scriptsize, text=rbTextMuted] at (28.5,0) {#4};
    % Score value
    \node[anchor=south, font=\scriptsize\bfseries, text=rbAccentDark] at (\scoreU,0.22) {#1};
  \end{tikzpicture}%
}

% ----------------------------------------------------------------
% testbattery environment + \batteryrow
%   Multi-test summary table
% ----------------------------------------------------------------

\newenvironment{testbattery}[1][Test Battery Summary]{%
  {\small\bfseries\color{rbPrimary}#1}\par\vskip4pt%
  \begingroup
  \small
  \begin{tabular}{>{\raggedright\arraybackslash}p{0.36\textwidth}
                  >{\centering\arraybackslash}p{0.12\textwidth}
                  >{\centering\arraybackslash}p{0.14\textwidth}
                  >{\raggedright\arraybackslash}p{0.24\textwidth}}
    \toprule
    \thead{Test} & \thead{Score} & \thead{Percentile} & \thead{Classification} \\
    \midrule
}{%
    \bottomrule
  \end{tabular}%
  \endgroup\par
}

\newcommand{\batteryrow}[4]{%
  #1 & #2 & #3 & {\color{\psy@classcolor{#4}}#4} \\
}

% ----------------------------------------------------------------
% \percentileformat{raw}{percentile}{classification}
%   Inline formatted result
% ----------------------------------------------------------------

\newcommand{\percentileformat}[3]{%
  #1~(\textit{#2\textsuperscript{th}};~{\color{\psy@classcolor{#3}}#3})%
}

% ----------------------------------------------------------------
% \rci{pre}{post}{se}
%   Reliable change index with significance indicator
% ----------------------------------------------------------------

\newcommand{\rci}[3]{%
  \pgfmathsetmacro{\rcivalue}{(#2 - #1) / (#3 * 1.41421356)}%
  \pgfmathsetmacro{\absrci}{abs(\rcivalue)}%
  RCI~=~\pgfmathprintnumber[fixed, precision=2]{\rcivalue}%
  \ifdim \absrci pt>1.96pt\relax
    ~{\bfseries\color{psy@Average}*}%
  \else
    ~{\color{rbTextMuted}n.s.}%
  \fi
}

% ----------------------------------------------------------------
% \cutoffindicator{score}{cutoff}{label}
%   Visual indicator above/below cutoff
% ----------------------------------------------------------------

\newcommand{\cutoffindicator}[3]{%
  \ifdim #1 pt<#2 pt\relax
    \def\psy@cutcol{psy@Impaired}%
    \def\psy@cutdir{Below}%
  \else
    \def\psy@cutcol{psy@Average}%
    \def\psy@cutdir{At/Above}%
  \fi
  \begin{tikzpicture}[baseline=-0.3em]
    \node[rounded corners=2pt, fill=\psy@cutcol!15, inner sep=3pt,
          font=\small] {%
      {\bfseries\color{\psy@cutcol}#1}%
      ~{\scriptsize\color{rbTextMuted}#3~cutoff~#2:~\psy@cutdir}%
    };
  \end{tikzpicture}%
}

% ----------------------------------------------------------------
% \cognitiveprofile{domain1/score1, domain2/score2, ...}
%   Multi-domain horizontal bar chart (TikZ)
% ----------------------------------------------------------------

\newcommand{\cognitiveprofile}[1]{%
  \begin{tikzpicture}[y=-0.7cm, x=0.012\textwidth]
    % Reference lines
    \draw[rbRule!40, dashed] (100,0.3) -- (100,-0.7*20);
    \draw[rbBg, line width=8pt] (70,0.3) -- (70,-0.7*20);
    \draw[rbBg, line width=8pt] (130,0.3) -- (130,-0.7*20);
    %
    \def\psy@row{0}%
    \foreach \domain/\score in {#1} {%
      \pgfmathsetmacro{\psy@row}{\psy@row + 1}%
      % Bar colour based on score
      \pgfmathsetmacro{\barval}{\score}%
      \ifdim \barval pt<70pt\relax
        \def\psy@barcol{psy@Impaired}%
      \else\ifdim \barval pt<80pt\relax
        \def\psy@barcol{psy@Borderline}%
      \else\ifdim \barval pt<90pt\relax
        \def\psy@barcol{psy@LowAverage}%
      \else\ifdim \barval pt<110pt\relax
        \def\psy@barcol{psy@Average}%
      \else\ifdim \barval pt<120pt\relax
        \def\psy@barcol{psy@HighAverage}%
      \else\ifdim \barval pt<130pt\relax
        \def\psy@barcol{psy@Superior}%
      \else
        \def\psy@barcol{psy@VySuperior}%
      \fi\fi\fi\fi\fi\fi
      % Bar
      \fill[\psy@barcol!70] (0,\psy@row) rectangle (\score,\psy@row+0.45);
      % Label
      \node[anchor=east, font=\scriptsize, text=rbText] at (-1,\psy@row+0.22) {\domain};
      % Score
      \node[anchor=west, font=\scriptsize\bfseries, text=\psy@barcol] at (\score+1,\psy@row+0.22) {\score};
    }%
    % Mean reference label
    \pgfmathsetmacro{\labely}{\psy@row + 1.2}%
    \node[anchor=north, font=\tiny, text=rbTextMuted] at (100,\labely) {M=100};
  \end{tikzpicture}%
}

% ----------------------------------------------------------------
% \zdiscrepancy{z1}{z2}{label1}{label2}
%   z-score discrepancy display
% ----------------------------------------------------------------

\newcommand{\zdiscrepancy}[4]{%
  \pgfmathsetmacro{\zdiff}{#1 - #2}%
  \pgfmathsetmacro{\absdiff}{abs(\zdiff)}%
  \begin{tcolorbox}[
    enhanced, colback=rbBg, colframe=rbRule,
    boxrule=0.3pt, sharp corners,
    left=8pt, right=8pt, top=5pt, bottom=5pt,
  ]
    {\small\bfseries\color{rbPrimary}Discrepancy Analysis}\par\vskip3pt
    {\small #3:~$z$~=~\pgfmathprintnumber[fixed, precision=2]{#1}\hfill
           #4:~$z$~=~\pgfmathprintnumber[fixed, precision=2]{#2}}\par\vskip2pt
    {\small Difference:~$\Delta z$~=~\pgfmathprintnumber[fixed, precision=2]{\zdiff}%
    \ifdim \absdiff pt>1.5pt\relax
      \hfill{\bfseries\color{psy@Impaired}Significant discrepancy}%
    \else
      \hfill{\color{rbTextMuted}Within normal limits}%
    \fi\par}%
  \end{tcolorbox}%
}

% ----------------------------------------------------------------
% \dsmcriterion{letter}{description}{met/unmet}
%   DSM criterion checklist item
% ----------------------------------------------------------------

\newcommand{\dsmcriterion}[3]{%
  \def\psy@mettest{#3}%
  \def\psy@metval{met}%
  \ifx\psy@mettest\psy@metval
    \def\psy@checkmark{\color{psy@Impaired}\bfseries\checkmark}%
    \def\psy@descstyle{\color{rbText}}%
  \else
    \def\psy@checkmark{\color{rbTextMuted}--}%
    \def\psy@descstyle{\color{rbTextMuted}}%
  \fi
  \par\vskip2pt\noindent
  \begin{tabular}{@{}c@{\hskip6pt}c@{\hskip8pt}p{0.82\textwidth}@{}}
    {\small\bfseries\color{rbPrimary}#1} &
    {\small\psy@checkmark} &
    {\small\psy@descstyle #2}%
  \end{tabular}%
}

% ----------------------------------------------------------------
% classificationtable environment
%   Classification / severity table
% ----------------------------------------------------------------

\newenvironment{classificationtable}[1][Classification Ranges]{%
  {\small\bfseries\color{rbPrimary}#1}\par\vskip4pt%
  \begingroup
  \small
  \begin{tabular}{>{\centering\arraybackslash}p{0.22\textwidth}
                  >{\centering\arraybackslash}p{0.22\textwidth}
                  >{\raggedright\arraybackslash}p{0.40\textwidth}}
    \toprule
    \thead{Score Range} & \thead{Percentile} & \thead{Classification} \\
    \midrule
}{%
    \bottomrule
  \end{tabular}%
  \endgroup\par
}

% ----------------------------------------------------------------
\endinput
