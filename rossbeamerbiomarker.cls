% rossbeamerbiomarker.cls
% Biomarker / clinical-lab Beamer class — assay result cards,
% threshold visualisations, diagnostic test summaries, and
% multi-analyte panel tables for laboratory & translational talks.
%
% Usage:
%   \documentclass[palette=assay]{rossbeamerbiomarker}
%
% Available palettes:
%   assay (default) — clinical blue / amber
%   diagnostic      — green / red threshold
%   biotech         — teal / gold
%
% Options:
%   palette=<name>   font=<fira|inter|sourcesans|libertinus|heros|georgia|system>
%   monofont=<name>  nobar  nologo  stats
%
% Ross Dunne / Claude, 2026

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{rossbeamerbiomarker}[2026/03/24 Biomarker Beamer class]

% ----------------------------------------------------------------
% Option handling
% ----------------------------------------------------------------

\RequirePackage{pgfkeys}
\RequirePackage{pgfopts}

\newif\ifrb@nobar  \rb@nobarfalse
\newif\ifrb@nologo \rb@nologofalse
\newif\ifbiom@stats  \biom@statsfalse

\pgfkeys{
  /bmbeamer/.cd,
  palette/.store in=\biom@palette,   palette=assay,
  font/.store in=\biom@fontchoice,   font=fira,
  monofont/.store in=\biom@mono,     monofont=,
  nobar/.code={\rb@nobartrue},
  nologo/.code={\rb@nologotrue},
  stats/.code={\biom@statstrue},
}
\ProcessPgfOptions{/bmbeamer}

\PassOptionsToClass{aspectratio=169}{beamer}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{beamer}}
\ProcessOptions\relax
\LoadClass{beamer}

% ----------------------------------------------------------------
% Load shared base
% ----------------------------------------------------------------

\RequirePackage{rossbeamerbase}

% ----------------------------------------------------------------
% Optionally load rossstats.sty
% ----------------------------------------------------------------

\ifbiom@stats
  \RequirePackage{rossstats}
\fi

% ----------------------------------------------------------------
% Palette definitions (12-field format)
%
% \biom@defpal{name}
%   {primary}{secondary}{accent}{text}{textlight}{textmuted}{bg}{rule}
%   {accentdark}{accentlight}{accentbg}{lightmuted}
% ----------------------------------------------------------------

\newcommand{\biom@defpal}[9]{%
  \expandafter\def\csname biom@p@#1@P\endcsname{#2}%   primary
  \expandafter\def\csname biom@p@#1@S\endcsname{#3}%   secondary
  \expandafter\def\csname biom@p@#1@A\endcsname{#4}%   accent
  \expandafter\def\csname biom@p@#1@T\endcsname{#5}%   text
  \expandafter\def\csname biom@p@#1@TL\endcsname{#6}%  textlight
  \expandafter\def\csname biom@p@#1@TM\endcsname{#7}%  textmuted
  \expandafter\def\csname biom@p@#1@B\endcsname{#8}%   bg
  \expandafter\def\csname biom@p@#1@R\endcsname{#9}%   rule
  \biom@defpal@cont{#1}%
}
\newcommand{\biom@defpal@cont}[5]{%
  \expandafter\def\csname biom@p@#1@AD\endcsname{#2}%  accentdark
  \expandafter\def\csname biom@p@#1@AL\endcsname{#3}%  accentlight
  \expandafter\def\csname biom@p@#1@AB\endcsname{#4}%  accentbg
  \expandafter\def\csname biom@p@#1@LM\endcsname{#5}%  lightmuted
}

% --- assay: clinical blue / amber ---
%                    name      P       S       A       T       TL      TM      B       R       AD      AL      AB      LM
\biom@defpal{assay}   {1A2A44}{1565C0}{FF8F00}{1C1C1C}{FFFFFF}{5A6878}{F6F8FA}{CDD5DD}{B87000}{FFB740}{FFF6E6}{8898B0}

% --- diagnostic: green / red threshold ---
\biom@defpal{diagnostic}{1A2E1A}{43A047}{E53935}{1C1C1C}{FFFFFF}{5A6B5A}{F8FAF7}{C8D8CE}{B71C1C}{EF9A9A}{FFEBEE}{90B0A0}

% --- biotech: teal / gold ---
\biom@defpal{biotech} {0A2E2E}{00897B}{FFB300}{1C1C1C}{FFFFFF}{587878}{F6FAFA}{C8DEDE}{C68A00}{FFD54F}{FFF8E1}{88B8B8}

% ----------------------------------------------------------------
% Palette activation
% ----------------------------------------------------------------

\newcommand{\biom@activatepalette}{%
  % Core colours
  \definecolor{rbPrimary}{HTML}{\csname biom@p@\biom@palette @P\endcsname}%
  \definecolor{rbSecondary}{HTML}{\csname biom@p@\biom@palette @S\endcsname}%
  \definecolor{rbAccent}{HTML}{\csname biom@p@\biom@palette @A\endcsname}%
  \definecolor{rbText}{HTML}{\csname biom@p@\biom@palette @T\endcsname}%
  \definecolor{rbTextLight}{HTML}{\csname biom@p@\biom@palette @TL\endcsname}%
  \definecolor{rbTextMuted}{HTML}{\csname biom@p@\biom@palette @TM\endcsname}%
  \definecolor{rbBg}{HTML}{\csname biom@p@\biom@palette @B\endcsname}%
  \definecolor{rbRule}{HTML}{\csname biom@p@\biom@palette @R\endcsname}%
  % Derive standard colours
  \rb@derivecolors
  % Override with explicit palette refinements
  \definecolor{rbAccentDark}{HTML}{\csname biom@p@\biom@palette @AD\endcsname}%
  \definecolor{rbAccentLight}{HTML}{\csname biom@p@\biom@palette @AL\endcsname}%
  \definecolor{rbAccentBg}{HTML}{\csname biom@p@\biom@palette @AB\endcsname}%
  \definecolor{rbLightMuted}{HTML}{\csname biom@p@\biom@palette @LM\endcsname}%
  % Legacy aliases
  \colorlet{bmDark}{rbPrimary}%
  \colorlet{bmText}{rbText}%
  \colorlet{bmMuted}{rbTextMuted}%
  \colorlet{bmAccent}{rbAccent}%
  \colorlet{bmAccentDark}{rbAccentDark}%
  \colorlet{bmAccentLight}{rbAccentLight}%
  \colorlet{bmAccentBg}{rbAccentBg}%
  \colorlet{bmBg}{rbBg}%
  \colorlet{bmLight}{rbTextLight}%
  \colorlet{bmLightMuted}{rbLightMuted}%
  \colorlet{bmRule}{rbRule}%
}
\biom@activatepalette

\newcommand{\setpalette}[1]{\def\biom@palette{#1}\biom@activatepalette}

% ----------------------------------------------------------------
% Beamer setup
% ----------------------------------------------------------------

\rb@setupbeamer
\setbeamersize{text margin left=12mm, text margin right=12mm}

% Frame title with underline rule
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
\rb@activatefont{\biom@fontchoice}
\rb@activatemono{\biom@mono}
\usefonttheme[onlymath]{serif}

% Footer: always on
\rb@activatefooter

% ----------------------------------------------------------------
% Title page — dark with thin accent rule
% ----------------------------------------------------------------

\def\biom@conference{}
\newcommand{\conference}[1]{\def\biom@conference{#1}}

\defbeamertemplate*{title page}{rossbeamerbiomarker}{%
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
  \ifx\biom@conference\empty\else
    \vskip4pt{\usebeamerfont{date}\color{rbLightMuted}\itshape\biom@conference\par}\fi
  \vfill
}

% ================================================================
% BIOMARKER-SPECIFIC FEATURES
% ================================================================

% ----------------------------------------------------------------
% Additional TikZ libraries
% ----------------------------------------------------------------

\usetikzlibrary{positioning,calc}

% ----------------------------------------------------------------
% Assay result card
%
% \assaycard{name}{value}{unit}{range}{interpretation}
%
% Renders a bordered card showing an analyte result with its
% reference range and clinical interpretation.
% ----------------------------------------------------------------

\newcommand{\assaycard}[5]{%
  \begin{tcolorbox}[
    enhanced, colback=white, colframe=rbRule,
    boxrule=0.4pt, sharp corners,
    left=8pt, right=8pt, top=6pt, bottom=6pt,
    borderline west={3pt}{0pt}{rbSecondary},
  ]
    {\small\bfseries\color{rbSecondary}#1}\hfill
    {\scriptsize\color{rbTextMuted}Ref:~#4}\par
    \vskip4pt
    {\fontsize{28}{32}\selectfont\bfseries\color{rbPrimary}#2}%
    \kern4pt{\normalsize\color{rbTextMuted}#3}\par
    \vskip3pt
    {\small\itshape\color{rbAccentDark}#5}%
  \end{tcolorbox}%
}

% ----------------------------------------------------------------
% Cutoff callout
%
% \cutoffcallout{value}{threshold}{interpretation}
%
% Draws a centred callout that compares a value to a threshold
% and displays an interpretive label beneath.
% ----------------------------------------------------------------

\newcommand{\cutoffcallout}[3]{%
  \begin{center}
    \begin{tikzpicture}
      \node[fill=rbAccentBg, draw=rbAccent, rounded corners=3pt,
            inner xsep=12pt, inner ysep=8pt, line width=0.6pt]
        (box) {%
          \begin{tabular}{@{}c@{}}
            {\fontsize{24}{28}\selectfont\bfseries\color{rbPrimary}#1}%
            \kern6pt{\normalsize\color{rbTextMuted}vs.\ cutoff}%
            \kern4pt{\fontsize{24}{28}\selectfont\bfseries\color{rbAccent}#2}\\[4pt]
            {\small\itshape\color{rbAccentDark}#3}%
          \end{tabular}%
        };
    \end{tikzpicture}
  \end{center}%
}

% ----------------------------------------------------------------
% Threshold bar
%
% \thresholdbar{value}{cutoff}{label}
%
% TikZ horizontal bar where a marker shows the measured value
% and a vertical line marks the threshold.
% ----------------------------------------------------------------

\newcommand{\thresholdbar}[3]{%
  \begin{center}
    \begin{tikzpicture}[x=0.06\textwidth]
      % Bar track
      \fill[rbBg] (0,0) rectangle (16,0.45);
      % Filled portion up to value (clamped to 0–16)
      \pgfmathsetmacro{\valpos}{min(max(#1/max(#2,0.001)*8,0),16)}%
      \fill[rbSecondary!40] (0,0) rectangle (\valpos,0.45);
      % Cutoff line at midpoint (8)
      \draw[rbAccent, line width=1.5pt, dashed] (8,-0.15) -- (8,0.60);
      \node[above, font=\scriptsize\bfseries, text=rbAccent] at (8,0.60)
        {Cutoff: #2};
      % Value marker
      \fill[rbPrimary] (\valpos,0.225) circle (0.18);
      \node[below, font=\scriptsize\bfseries, text=rbPrimary] at (\valpos,-0.15)
        {#1};
      % Label
      \node[right, font=\small\color{rbTextMuted}] at (16.3,0.225) {#3};
    \end{tikzpicture}
  \end{center}%
}

% ----------------------------------------------------------------
% Diagnostic test summary card
%
% \diagnosticcard{test}{sens}{spec}{ppv}{npv}{auc}
%
% A tcolorbox card summarising operating characteristics of a
% diagnostic test.
% ----------------------------------------------------------------

\newcommand{\diagnosticcard}[6]{%
  \begin{tcolorbox}[
    enhanced, colback=white, colframe=rbRule,
    boxrule=0.4pt, sharp corners,
    left=8pt, right=8pt, top=6pt, bottom=6pt,
    borderline west={3pt}{0pt}{rbPrimary},
    fonttitle=\small\bfseries\color{rbPrimary},
    coltitle=rbPrimary, title={#1},
  ]
    \small
    \begin{tabular}{@{}l@{\kern12pt}l@{\kern12pt}l@{\kern12pt}l@{\kern12pt}l@{}}
      \color{rbTextMuted}Sensitivity & \color{rbTextMuted}Specificity &
      \color{rbTextMuted}PPV & \color{rbTextMuted}NPV &
      \color{rbTextMuted}AUC \\[3pt]
      \bfseries\color{rbPrimary}#2 & \bfseries\color{rbPrimary}#3 &
      \bfseries\color{rbPrimary}#4 & \bfseries\color{rbPrimary}#5 &
      \bfseries\color{rbAccent}#6 \\
    \end{tabular}%
  \end{tcolorbox}%
}

% ----------------------------------------------------------------
% Biomarker panel environment
%
% \begin{biomarkerpanel}{title}
%   Name & Value & Unit & Range & Status \\
%   ...
% \end{biomarkerpanel}
%
% Multi-analyte result table with header row and alternating
% shading for readability.
% ----------------------------------------------------------------

\newcounter{biom@rowcnt}

\newenvironment{biomarkerpanel}[1]{%
  \begin{tcolorbox}[
    enhanced, colback=white, colframe=rbRule,
    boxrule=0.4pt, sharp corners,
    left=4pt, right=4pt, top=6pt, bottom=4pt,
    borderline north={2pt}{0pt}{rbPrimary},
    fonttitle=\small\bfseries\color{rbPrimary},
    coltitle=rbPrimary, title={#1},
  ]
  \small
  \setcounter{biom@rowcnt}{0}%
  \begin{tabular}{@{}l r l l l@{}}
    \toprule
    \bfseries\color{rbPrimary}Analyte &
    \bfseries\color{rbPrimary}Value &
    \bfseries\color{rbPrimary}Unit &
    \bfseries\color{rbPrimary}Range &
    \bfseries\color{rbPrimary}Status \\
    \midrule
}{%
    \bottomrule
  \end{tabular}%
  \end{tcolorbox}%
}

% Helper for rows inside biomarkerpanel
\newcommand{\panelrow}[5]{%
  #1 & #2 & #3 & #4 & #5 \\
}

% ----------------------------------------------------------------
% ROC point badge
%
% \rocpoint{label}
%
% A small coloured badge for annotating ROC curves in figures.
% ----------------------------------------------------------------

\newcommand{\rocpoint}[1]{%
  \tikz[baseline=-0.3em]{%
    \node[circle, fill=rbAccent, text=white,
          inner sep=0pt, minimum size=1.4em,
          font=\scriptsize\bfseries] {#1};}%
}

% ----------------------------------------------------------------
% Normal reference range
%
% \normalrange{low}{high}
%
% Formatted inline reference range in muted colour.
% ----------------------------------------------------------------

\newcommand{\normalrange}[2]{%
  {\small\color{rbTextMuted}[#1\,--\,#2]}%
}

% ----------------------------------------------------------------
% Inline biomarker result with colour-coded status
%
% \biomarkerresult{name}{value}{status}
%
% status = normal | borderline | abnormal
% Uses rbNormal / rbThresholdAmber / rbAbnormal from base.
% ----------------------------------------------------------------

\newcommand{\biom@statuscolor}[1]{%
  \def\biom@tmp{#1}%
  \def\biom@stnorm{normal}%
  \def\biom@stbord{borderline}%
  \def\biom@stabn{abnormal}%
  \ifx\biom@tmp\biom@stnorm rbNormal%
  \else\ifx\biom@tmp\biom@stbord rbThresholdAmber%
  \else\ifx\biom@tmp\biom@stabn rbAbnormal%
  \else rbTextMuted%
  \fi\fi\fi
}

\newcommand{\biomarkerresult}[3]{%
  {\small\bfseries\color{rbText}#1}%
  \kern3pt%
  {\small\bfseries\color{\biom@statuscolor{#3}}#2}%
  \kern3pt%
  \tikz[baseline=-0.2em]{%
    \node[rounded corners=2pt, fill=\biom@statuscolor{#3},
          text=white, inner xsep=4pt, inner ysep=1.5pt,
          font=\scriptsize\bfseries] {#3};}%
}

% ----------------------------------------------------------------
\endinput
