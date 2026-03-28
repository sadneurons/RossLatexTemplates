% rossbeamerpitch.cls
% Pitch-deck Beamer class — bold palettes, gradient title slides,
% problem/solution/ask/traction layouts for startups and grants.
%
% Usage:
%   \documentclass[palette=pitch]{rossbeamerpitch}
%
% Available palettes:
%   pitch    — bold dark blue / bright orange (default)
%   startup  — electric purple / lime
%   venture  — charcoal / gold
%   grant    — navy / green (grant applications)
%
% Options:
%   palette=<name>   font=<fira|inter|sourcesans|libertinus|heros|georgia|system>
%   monofont=<name>  darkmode  nobar  nologo
%
% Ross Dunne / Claude, 2026

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{rossbeamerpitch}[2026/03/24 Pitch-deck Beamer class]

% ----------------------------------------------------------------
% Option handling
% ----------------------------------------------------------------

\RequirePackage{pgfkeys}
\RequirePackage{pgfopts}

% Pre-declare base flags so pgfkeys can set them
\newif\ifrb@nobar  \rb@nobarfalse
\newif\ifrb@nologo \rb@nologofalse
\newif\ifpitch@darkmode \pitch@darkmodefalse

\pgfkeys{
  /pitchbeamer/.cd,
  palette/.store in=\pitch@palette,   palette=pitch,
  font/.store in=\pitch@fontchoice,   font=fira,
  monofont/.store in=\pitch@mono,     monofont=,
  darkmode/.is if=pitch@darkmode,
  nobar/.code={\rb@nobartrue},
  nologo/.code={\rb@nologotrue},
}
\ProcessPgfOptions{/pitchbeamer}

\PassOptionsToClass{aspectratio=169}{beamer}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{beamer}}
\ProcessOptions\relax
\LoadClass{beamer}

% ----------------------------------------------------------------
% Load shared base
% ----------------------------------------------------------------

\RequirePackage{rossbeamerbase}

% ----------------------------------------------------------------
% Palette definitions (6-field compact format)
%   \pitch@defpal{name}{primary}{secondary}{accent}{textdark}{textlight}{textmuted}
% ----------------------------------------------------------------

\newcommand{\pitch@defpal}[7]{%
  \expandafter\def\csname pitch@p@#1@P\endcsname{#2}%
  \expandafter\def\csname pitch@p@#1@S\endcsname{#3}%
  \expandafter\def\csname pitch@p@#1@A\endcsname{#4}%
  \expandafter\def\csname pitch@p@#1@TD\endcsname{#5}%
  \expandafter\def\csname pitch@p@#1@TL\endcsname{#6}%
  \expandafter\def\csname pitch@p@#1@TM\endcsname{#7}%
}

% Pitch: bold dark blue + bright orange
\pitch@defpal{pitch}      {1B2A4A}{3A5894}{FF6B2B}{1B2A4A}{FFFFFF}{7080A0}
% Startup: electric purple + lime
\pitch@defpal{startup}    {6B21A8}{9333EA}{84CC16}{2E1065}{FFFFFF}{A090C0}
% Venture: charcoal + gold
\pitch@defpal{venture}    {374151}{6B7280}{D4A017}{1F2937}{FFFFFF}{9CA3AF}
% Grant: navy + green
\pitch@defpal{grant}      {0C2340}{1A3D6D}{228B22}{0C2340}{FFFFFF}{6888A8}

% ----------------------------------------------------------------
% Palette activation
% ----------------------------------------------------------------

\newcommand{\pitch@activatepalette}{%
  \definecolor{rbPrimary}{HTML}{\csname pitch@p@\pitch@palette @P\endcsname}%
  \definecolor{rbSecondary}{HTML}{\csname pitch@p@\pitch@palette @S\endcsname}%
  \definecolor{rbAccent}{HTML}{\csname pitch@p@\pitch@palette @A\endcsname}%
  \definecolor{rbText}{HTML}{\csname pitch@p@\pitch@palette @TD\endcsname}%
  \definecolor{rbTextLight}{HTML}{\csname pitch@p@\pitch@palette @TL\endcsname}%
  \definecolor{rbTextMuted}{HTML}{\csname pitch@p@\pitch@palette @TM\endcsname}%
  \definecolor{rbBg}{HTML}{FAFAFA}%
  \colorlet{rbRule}{rbTextMuted!30}%
  \rb@derivecolors
}
\pitch@activatepalette

\newcommand{\setpalette}[1]{%
  \def\pitch@palette{#1}\pitch@activatepalette
}

% ----------------------------------------------------------------
% Beamer setup
% ----------------------------------------------------------------

\rb@setupbeamer
\setbeamersize{text margin left=12.7mm, text margin right=12.7mm}

% Pitch overrides: bullets use primary, all-sans titles
\setbeamercolor{itemize item}{fg=rbPrimary}
\setbeamercolor{itemize subitem}{fg=rbSecondaryDark}
\setbeamercolor{enumerate item}{fg=rbPrimary}
\setbeamercolor{enumerate subitem}{fg=rbSecondaryDark}
\setbeamertemplate{itemize item}{\tikz\draw[fill=rbPrimary,draw=none] (0,0) circle (0.08);}
\setbeamertemplate{itemize subitem}{\tikz\draw[fill=rbSecondaryDark,draw=none] (0,0) circle (0.06);}

% Font activation
\rb@activatefont{\pitch@fontchoice}
\rb@activatemono{\pitch@mono}

% Footer: opt-in via \enablefooter
\newcommand{\enablefooter}{\rb@activatefooter}

% ----------------------------------------------------------------
% Title page — gradient with decorative geometry
% ----------------------------------------------------------------

\defbeamertemplate*{title page}{rossbeamerpitch}{%
  \begin{tikzpicture}[remember picture, overlay]
    \shade[shading=axis, shading angle=135,
      left color=rbPrimary, right color=rbPrimary!85!rbSecondary]
      (current page.south west) rectangle (current page.north east);
    \fill[rbSecondary, opacity=0.08]
      ([xshift=40mm, yshift=-20mm]current page.north east) circle (50mm);
    \fill[rbAccent, opacity=0.9]
      (current page.south west) rectangle
      ([yshift=3mm]current page.south east);
  \end{tikzpicture}%
  \vfill
  {\usebeamerfont{title}\color{rbTextLight}\inserttitle\par}%
  \ifx\insertsubtitle\empty\else
    \vskip6pt{\usebeamerfont{subtitle}\color{rbTextLight!80}\insertsubtitle\par}\fi
  \vskip12pt%
  \ifx\insertauthor\empty\else
    {\usebeamerfont{author}\color{rbTextLight!70}\insertauthor\par}\fi
  \ifx\insertinstitute\empty\else
    \vskip2pt{\usebeamerfont{institute}\color{rbTextLight!60}\insertinstitute\par}\fi
  \ifx\insertdate\empty\else
    \vskip4pt{\usebeamerfont{date}\color{rbTextLight!60}\insertdate\par}\fi
  \vfill
}

\setbeamerfont{title}{size=\Huge, series=\bfseries}

% ================================================================
% PITCH-SPECIFIC FEATURES
% ================================================================

% ----------------------------------------------------------------
% Problem slide — bold frame with dark background and large text
%
%   \problemslide{Millions of people struggle with X every day.}
% ----------------------------------------------------------------

\newcommand{\problemslide}[1]{%
  \begingroup
  \setbeamercolor{normal text}{fg=rbTextLight, bg=rbPrimary}%
  \usebeamercolor[fg]{normal text}%
  \begin{frame}[c,plain]{}%
    \begin{tikzpicture}[remember picture, overlay]
      \fill[rbPrimary]
        (current page.south west) rectangle (current page.north east);
      \fill[rbAccent, opacity=0.12]
        ([xshift=-30mm, yshift=-10mm]current page.north west) circle (40mm);
    \end{tikzpicture}%
    \centering\vfill
    {\scriptsize\bfseries\color{rbAccent}\MakeUppercase{The Problem}\par}%
    \vskip8pt%
    {\fontsize{28}{34}\selectfont\bfseries\color{rbTextLight}#1\par}%
    \vfill
  \end{frame}%
  \endgroup
}

% ----------------------------------------------------------------
% Solution slide — bold frame with accent background
%
%   \solutionslide{Our platform automates X, saving 10x time.}
% ----------------------------------------------------------------

\newcommand{\solutionslide}[1]{%
  \begingroup
  \setbeamercolor{normal text}{fg=rbTextLight, bg=rbAccent}%
  \usebeamercolor[fg]{normal text}%
  \begin{frame}[c,plain]{}%
    \begin{tikzpicture}[remember picture, overlay]
      \fill[rbAccent]
        (current page.south west) rectangle (current page.north east);
      \fill[rbPrimary, opacity=0.10]
        ([xshift=35mm, yshift=15mm]current page.south east) circle (45mm);
    \end{tikzpicture}%
    \centering\vfill
    {\scriptsize\bfseries\color{rbTextLight!85}\MakeUppercase{The Solution}\par}%
    \vskip8pt%
    {\fontsize{28}{34}\selectfont\bfseries\color{rbTextLight}#1\par}%
    \vfill
  \end{frame}%
  \endgroup
}

% ----------------------------------------------------------------
% Traction metrics — KPI card with trend arrow
%
%   \tractionmetric{£2.4M}{ARR}{up}
%   \tractionmetric{12\%}{Churn}{down}
%   \tractionmetric{340}{Customers}{flat}
%
%   \tractionrow{
%     \tractionmetric{£2.4M}{ARR}{up}
%     \tractionmetric{98\%}{Retention}{up}
%     \tractionmetric{340}{Customers}{flat}
%   }
% ----------------------------------------------------------------

\newcommand{\pitch@trendsymbol}[1]{%
  \def\pitch@tup{up}\def\pitch@tdown{down}\def\pitch@tmp{#1}%
  \ifx\pitch@tmp\pitch@tup
    {\color{rbSuccess}\raisebox{0.1em}{$\blacktriangle$}}%
  \else\ifx\pitch@tmp\pitch@tdown
    {\color{rbAlertRed}\raisebox{-0.1em}{$\blacktriangledown$}}%
  \else
    {\color{rbTextMuted}$\bullet$}%
  \fi\fi
}

\newcommand{\tractionmetric}[3]{%
  \begin{minipage}[t]{0.28\textwidth}%
    \begin{tcolorbox}[enhanced, colback=white, colframe=white,
      boxrule=0pt, borderline south={2pt}{0pt}{rbPrimary},
      sharp corners, left=4pt, right=4pt, top=6pt, bottom=6pt]
      {\fontsize{30}{34}\selectfont\bfseries\color{rbPrimary}#1%
        \hspace{4pt}\pitch@trendsymbol{#3}\par}%
      \vskip3pt{\small\color{rbText}#2\par}%
    \end{tcolorbox}%
  \end{minipage}\hfill%
}

\newcommand{\tractionrow}[1]{%
  \begin{center}#1\end{center}%
}

% ----------------------------------------------------------------
% Competitive matrix — feature comparison grid
%
%   \begin{competitivematrix}{Feature}{Us}{Comp A}{Comp B}
%     \competitor{Speed}{\yes}{\no}{\yes}
%     \competitor{Price}{\yes}{\yes}{\no}
%   \end{competitivematrix}
% ----------------------------------------------------------------

\newcommand{\yes}{{\color{rbSuccess}\bfseries\checkmark}}
\newcommand{\no}{{\color{rbTextMuted!40}---}}
\newcommand{\competitor}[2]{%
  #1 & #2 \\
}

\newenvironment{competitivematrix}[4]{%
  \def\pitch@cmheadA{#1}%
  \def\pitch@cmheadB{#2}%
  \def\pitch@cmheadC{#3}%
  \def\pitch@cmheadD{#4}%
  \begin{center}
  \renewcommand{\arraystretch}{1.4}%
  \begin{tabular}{
    >{\raggedright\arraybackslash}p{0.28\textwidth}
    >{\centering\arraybackslash}p{0.16\textwidth}
    >{\centering\arraybackslash}p{0.16\textwidth}
    >{\centering\arraybackslash}p{0.16\textwidth}
  }
  \toprule
  \rowcolor{rbPrimary}
  \thead{\pitch@cmheadA} & \thead{\pitch@cmheadB} &
  \thead{\pitch@cmheadC} & \thead{\pitch@cmheadD} \\
  \midrule
}{%
  \bottomrule
  \end{tabular}
  \end{center}
}

% ----------------------------------------------------------------
% Ask slide — fundraising / grant ask layout
%
%   \askslide{£500K}{Seed round to scale engineering and GTM.}
% ----------------------------------------------------------------

\newcommand{\askslide}[2]{%
  \begingroup
  \setbeamercolor{normal text}{fg=rbTextLight, bg=rbPrimary}%
  \usebeamercolor[fg]{normal text}%
  \begin{frame}[c,plain]{}%
    \begin{tikzpicture}[remember picture, overlay]
      \shade[shading=axis, shading angle=160,
        left color=rbPrimary, right color=rbPrimary!80!rbSecondary]
        (current page.south west) rectangle (current page.north east);
      \fill[rbAccent, opacity=0.9]
        ([yshift=0mm]current page.south west) rectangle
        ([yshift=3mm]current page.south east);
    \end{tikzpicture}%
    \centering\vfill
    {\scriptsize\bfseries\color{rbAccent}\MakeUppercase{The Ask}\par}%
    \vskip10pt%
    {\fontsize{44}{50}\selectfont\bfseries\color{rbTextLight}#1\par}%
    \vskip14pt%
    {\large\color{rbTextLight!80}#2\par}%
    \vfill
  \end{frame}%
  \endgroup
}

% ----------------------------------------------------------------
% Market size — concentric circles (TAM / SAM / SOM)
%
%   \marketsize{£10B}{£1.2B}{£150M}
% ----------------------------------------------------------------

\newcommand{\marketsize}[3]{%
  \begin{frame}{Market Opportunity}
    \centering\vfill
    \begin{tikzpicture}
      % TAM — outermost
      \fill[rbPrimary!12] (0,0) circle (3.8cm);
      \node[font=\scriptsize\bfseries\color{rbPrimary}, anchor=north] at (0,3.4) {TAM};
      \node[font=\large\bfseries\color{rbPrimary}] at (0,2.8) {#1};
      % SAM — middle
      \fill[rbPrimary!25] (0,-0.4) circle (2.5cm);
      \node[font=\scriptsize\bfseries\color{rbPrimary}, anchor=north] at (0,1.6) {SAM};
      \node[font=\large\bfseries\color{rbPrimary}] at (0,1.0) {#2};
      % SOM — innermost
      \fill[rbAccent!35] (0,-0.8) circle (1.3cm);
      \node[font=\scriptsize\bfseries\color{rbAccent!80!black}, anchor=north] at (0,0.1) {SOM};
      \node[font=\large\bfseries\color{rbAccent!80!black}] at (0,-0.5) {#3};
    \end{tikzpicture}
    \vfill
  \end{frame}
}

% ----------------------------------------------------------------
% Team slide — reuses profilecard from base
%
%   \teamslide{Our Team}{
%     \profilecard{Jane Smith}{CEO}{15 years fintech}
%     \profilecard{John Doe}{CTO}{Ex-Google engineer}
%   }
% ----------------------------------------------------------------

\newcommand{\teamslide}[2][Our Team]{%
  \begin{frame}{#1}
    \centering\vfill
    #2%
    \vfill
  \end{frame}
}

% ----------------------------------------------------------------
% Milestone track — funding-stage timeline
%
%   \milestonetrack{
%     \milestone{2024 Q1}{Pre-seed}{Complete}
%     \milestonecurrent{2024 Q3}{Seed}{In progress}
%     \milestonefuture{2025 Q2}{Series A}{Planned}
%   }
% ----------------------------------------------------------------

\newcounter{pitch@ms}

\newcommand{\milestonetrack}[2][Milestones]{%
  \begin{frame}{#1}
    \centering\vfill
    \setcounter{pitch@ms}{0}%
    \begin{tikzpicture}[every node/.style={font=\small}]
      \draw[rbTextMuted!30, line width=2.5pt] (0,0) -- (12,0);
      #2
    \end{tikzpicture}
    \vfill
  \end{frame}
}

\newcommand{\milestone}[3]{%
  \stepcounter{pitch@ms}%
  \pgfmathsetmacro{\pitch@msx}{(\thepitch@ms - 1) * 3.0 + 1.5}%
  \fill[rbSecondaryDark] (\pitch@msx,0) circle (6pt);
  \node[font=\tiny, text=rbTextLight] at (\pitch@msx,0) {\checkmark};
  \node[above=12pt, align=center,
    font=\footnotesize\bfseries\color{rbText}] at (\pitch@msx,0) {#1};
  \node[below=10pt, align=center,
    font=\footnotesize\color{rbPrimary}] at (\pitch@msx,0) {#2};
  \node[below=22pt, align=center,
    font=\scriptsize\color{rbTextMuted}] at (\pitch@msx,0) {#3};
}

\newcommand{\milestonecurrent}[3]{%
  \stepcounter{pitch@ms}%
  \pgfmathsetmacro{\pitch@msx}{(\thepitch@ms - 1) * 3.0 + 1.5}%
  \fill[rbAccent] (\pitch@msx,0) circle (8pt);
  \fill[white] (\pitch@msx,0) circle (3.5pt);
  \node[above=12pt, align=center,
    font=\footnotesize\bfseries\color{rbAccent}] at (\pitch@msx,0) {#1};
  \node[below=10pt, align=center,
    font=\footnotesize\bfseries\color{rbAccent}] at (\pitch@msx,0) {#2};
  \node[below=22pt, align=center,
    font=\scriptsize\bfseries\color{rbAccent!80!black}] at (\pitch@msx,0) {#3};
}

\newcommand{\milestonefuture}[3]{%
  \stepcounter{pitch@ms}%
  \pgfmathsetmacro{\pitch@msx}{(\thepitch@ms - 1) * 3.0 + 1.5}%
  \draw[rbTextMuted!50, line width=1.5pt] (\pitch@msx,0) circle (6pt);
  \node[above=12pt, align=center,
    font=\footnotesize\color{rbTextMuted}] at (\pitch@msx,0) {#1};
  \node[below=10pt, align=center,
    font=\footnotesize\color{rbTextMuted}] at (\pitch@msx,0) {#2};
  \node[below=22pt, align=center,
    font=\scriptsize\color{rbTextMuted!70}] at (\pitch@msx,0) {#3};
}

% ----------------------------------------------------------------
% Value proposition — headline + supporting text
%
%   \valueprop{10x faster onboarding}{Our AI-driven platform reduces
%     customer onboarding from weeks to hours.}
% ----------------------------------------------------------------

\newcommand{\valueprop}[2]{%
  \begin{frame}[c]{}
    \centering\vfill
    \begin{minipage}{0.80\textwidth}\centering
      {\fontsize{30}{36}\selectfont\bfseries\color{rbPrimary}#1\par}%
      \vskip14pt%
      {\large\color{rbTextMuted}#2\par}%
    \end{minipage}
    \vfill
  \end{frame}
}

% ----------------------------------------------------------------
% Dark-mode toggle
% ----------------------------------------------------------------

\ifpitch@darkmode
  \setbeamercolor{normal text}{fg=rbTextLight, bg=rbPrimary}
  \setbeamercolor{frametitle}{fg=rbTextLight, bg=rbPrimary}
  \setbeamercolor{framesubtitle}{fg=rbTextMuted!50!rbTextLight}
  \setbeamercolor{itemize item}{fg=rbAccent}
  \setbeamercolor{itemize subitem}{fg=rbSecondary}
  \setbeamercolor{block body}{fg=rbTextLight, bg=rbPrimary!80!black}
  \setbeamercolor{block title}{fg=rbPrimary, bg=rbSecondary}
\fi

% ----------------------------------------------------------------
\endinput
