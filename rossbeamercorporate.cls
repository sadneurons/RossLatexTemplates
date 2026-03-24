% rossbeamercorporate.cls
% Corporate Beamer class — bold palettes, gradient title slides,
% agenda/timeline/metric layouts, dark/light sandwich structure.
%
% Usage:
%   \documentclass[palette=midnight]{rossbeamercorporate}
%
% Available palettes:
%   Core:        midnight, forest, coral, terracotta, ocean, charcoal,
%                teal, berry, sage, cherry
%   Institution: uom, slate, evergreen, oxford, lancet, nhs, economist,
%                nature, nejm, cambridge, imperial, jama, bmj, cell,
%                copper, rose, graphite
%   Corporate:   obsidian, nordic, ember, indigo, ivory, plum, steel,
%                moss, bordeaux, arctic, saffron, dusk
%
% Options:
%   palette=<name>   font=<fira|inter|sourcesans|libertinus|heros|georgia|system>
%   monofont=<name>  darkmode  nobar  nologo
%
% Ross Dunne / Claude, 2026

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{rossbeamercorporate}[2026/03/24 Corporate Beamer class]

% ----------------------------------------------------------------
% Option handling
% ----------------------------------------------------------------

\RequirePackage{pgfkeys}
\RequirePackage{pgfopts}

% Pre-declare base flags so pgfkeys can set them
\newif\ifrb@nobar  \rb@nobarfalse
\newif\ifrb@nologo \rb@nologofalse
\newif\ifcorp@darkmode \corp@darkmodefalse

\pgfkeys{
  /corpbeamer/.cd,
  palette/.store in=\corp@palette,   palette=midnight,
  font/.store in=\corp@fontchoice,   font=fira,
  monofont/.store in=\corp@mono,     monofont=,
  darkmode/.is if=corp@darkmode,
  nobar/.code={\rb@nobartrue},
  nologo/.code={\rb@nologotrue},
}
\ProcessPgfOptions{/corpbeamer}

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
%   \corp@defpal{name}{primary}{secondary}{accent}{textdark}{textlight}{textmuted}
% ----------------------------------------------------------------

\newcommand{\corp@defpal}[7]{%
  \expandafter\def\csname corp@p@#1@P\endcsname{#2}%
  \expandafter\def\csname corp@p@#1@S\endcsname{#3}%
  \expandafter\def\csname corp@p@#1@A\endcsname{#4}%
  \expandafter\def\csname corp@p@#1@TD\endcsname{#5}%
  \expandafter\def\csname corp@p@#1@TL\endcsname{#6}%
  \expandafter\def\csname corp@p@#1@TM\endcsname{#7}%
}

% Core palettes
\corp@defpal{midnight}    {1E2761}{CADCFC}{FFFFFF}{1E2761}{FFFFFF}{8090B0}
\corp@defpal{forest}      {2C5F2D}{97BC62}{F5F5F5}{2C3E28}{FFFFFF}{7A9A7B}
\corp@defpal{coral}       {F96167}{F9E795}{2F3C7E}{2F3C7E}{FFFFFF}{8890B0}
\corp@defpal{terracotta}  {B85042}{E7E8D1}{A7BEAE}{3E2218}{FFFFFF}{8A7068}
\corp@defpal{ocean}       {065A82}{1C7293}{21295C}{0A2540}{FFFFFF}{6A8FA0}
\corp@defpal{charcoal}    {36454F}{F2F2F2}{212121}{212121}{FFFFFF}{808890}
\corp@defpal{teal}        {028090}{00A896}{02C39A}{023E48}{FFFFFF}{60A0A8}
\corp@defpal{berry}       {6D2E46}{A26769}{ECE2D0}{3E1828}{FFFFFF}{A08090}
\corp@defpal{sage}        {84B59F}{69A297}{50808E}{2A3E34}{FFFFFF}{708880}
\corp@defpal{cherry}      {990011}{FCF6F5}{2F3C7E}{2F1018}{FFFFFF}{907078}
% Institutional palettes
\corp@defpal{uom}         {660099}{9A4DBE}{FFC300}{2B0A3D}{FFFFFF}{A084BA}
\corp@defpal{slate}       {3B6B8A}{5A8AA8}{3B6B8A}{1E2A38}{FFFFFF}{7A90A8}
\corp@defpal{evergreen}   {2D6A4F}{40916C}{7FB069}{1A2E1A}{FFFFFF}{66957D}
\corp@defpal{oxford}      {002147}{1A3A60}{DAA520}{002147}{FFFFFF}{6B8FA0}
\corp@defpal{lancet}      {A4243B}{D4384F}{E7B4B9}{1A1A2E}{FFFFFF}{9A7A80}
\corp@defpal{nhs}         {005EB8}{41B6E6}{005EB8}{003087}{FFFFFF}{6A8FA0}
\corp@defpal{economist}   {E3120B}{F04840}{E8B4B0}{1F1F1F}{FFFFFF}{8A7A78}
\corp@defpal{nature}      {0072B2}{3498D8}{0072B2}{15202B}{FFFFFF}{6A8FA0}
\corp@defpal{nejm}        {8B2332}{A83848}{E6B9BF}{2A1520}{FFFFFF}{A08090}
\corp@defpal{cambridge}   {5B8FA8}{7AAFC5}{5B8FA8}{1A2930}{FFFFFF}{7B9FA8}
\corp@defpal{imperial}    {002147}{1A3A60}{D35400}{002147}{FFFFFF}{6B8FA0}
\corp@defpal{jama}        {7A2E40}{9A4858}{5C2030}{2C2420}{FFFFFF}{A89888}
\corp@defpal{bmj}         {2E6FA0}{4A8CC0}{1E5080}{1B2838}{FFFFFF}{90A8C0}
\corp@defpal{cell}        {1A1A40}{9898B8}{C8960C}{1A1A40}{FFFFFF}{9898B8}
\corp@defpal{copper}      {B45A28}{D07040}{8A4018}{1A1A1A}{FFFFFF}{B0A098}
\corp@defpal{rose}        {C25B78}{D87898}{9A4060}{2A1822}{FFFFFF}{C0A0B0}
\corp@defpal{graphite}    {404040}{606060}{2A2A2A}{1A1A1A}{FFFFFF}{A0A0A0}
% Corporate palettes
\corp@defpal{obsidian}    {1A1A1A}{2E2E2E}{C9A84C}{1A1A1A}{FFFFFF}{8A8A8A}
\corp@defpal{nordic}      {4A6274}{6E8898}{3A8E8E}{2A3A48}{FFFFFF}{8098A8}
\corp@defpal{ember}       {8B3A0A}{C06020}{E8A020}{2A1A0A}{FFFFFF}{A08868}
\corp@defpal{indigo}      {283593}{3F51B5}{448AFF}{1A1A3E}{FFFFFF}{8088B8}
\corp@defpal{ivory}       {2C3E6B}{8090B0}{B8985A}{2C3E6B}{FFFFFF}{8090A8}
\corp@defpal{plum}        {4A1A5E}{7B3F9E}{C8A0D8}{2A1038}{FFFFFF}{A888B8}
\corp@defpal{steel}       {4A5568}{718096}{DD6B20}{2D3748}{FFFFFF}{8898A8}
\corp@defpal{moss}        {5A6B3C}{8A9B6C}{B07848}{2A3018}{FFFFFF}{889878}
\corp@defpal{bordeaux}    {5A1028}{8A3048}{C9A84C}{2A0818}{FFFFFF}{A88898}
\corp@defpal{arctic}      {A8D0E6}{C8E4F4}{1A3A60}{1A3A60}{FFFFFF}{7898B0}
\corp@defpal{saffron}     {1A2744}{3A4A6E}{E8A820}{1A2744}{FFFFFF}{7888A8}
\corp@defpal{dusk}        {4A3F5E}{6E6088}{E87070}{2A2038}{FFFFFF}{9888A8}

% ----------------------------------------------------------------
% Palette activation
% ----------------------------------------------------------------

\newcommand{\corp@activatepalette}{%
  \definecolor{rbPrimary}{HTML}{\csname corp@p@\corp@palette @P\endcsname}%
  \definecolor{rbSecondary}{HTML}{\csname corp@p@\corp@palette @S\endcsname}%
  \definecolor{rbAccent}{HTML}{\csname corp@p@\corp@palette @A\endcsname}%
  \definecolor{rbText}{HTML}{\csname corp@p@\corp@palette @TD\endcsname}%
  \definecolor{rbTextLight}{HTML}{\csname corp@p@\corp@palette @TL\endcsname}%
  \definecolor{rbTextMuted}{HTML}{\csname corp@p@\corp@palette @TM\endcsname}%
  \definecolor{rbBg}{HTML}{FAFAFA}%
  \colorlet{rbRule}{rbTextMuted!30}%
  \rb@derivecolors
  % Legacy aliases
  \colorlet{csPrimary}{rbPrimary}%
  \colorlet{csSecondary}{rbSecondary}%
  \colorlet{csAccent}{rbAccent}%
  \colorlet{csTextDark}{rbText}%
  \colorlet{csTextLight}{rbTextLight}%
  \colorlet{csTextMuted}{rbTextMuted}%
  \colorlet{csPrimaryLight}{rbPrimaryLight}%
  \colorlet{csPrimaryFaded}{rbPrimaryFaded}%
  \colorlet{csSecondaryDark}{rbSecondaryDark}%
}
\corp@activatepalette

\newcommand{\setpalette}[1]{%
  \def\corp@palette{#1}\corp@activatepalette
}

% ----------------------------------------------------------------
% Beamer setup
% ----------------------------------------------------------------

\rb@setupbeamer
\setbeamersize{text margin left=12.7mm, text margin right=12.7mm}

% Corporate overrides: bullets use primary, all-sans titles
\setbeamercolor{itemize item}{fg=rbPrimary}
\setbeamercolor{itemize subitem}{fg=rbSecondaryDark}
\setbeamercolor{enumerate item}{fg=rbPrimary}
\setbeamercolor{enumerate subitem}{fg=rbSecondaryDark}
\setbeamertemplate{itemize item}{\tikz\draw[fill=rbPrimary,draw=none] (0,0) circle (0.08);}
\setbeamertemplate{itemize subitem}{\tikz\draw[fill=rbSecondaryDark,draw=none] (0,0) circle (0.06);}

% Font activation
\rb@activatefont{\corp@fontchoice}
\rb@activatemono{\corp@mono}

% Footer: opt-in via \enablefooter
\newcommand{\enablefooter}{\rb@activatefooter}

% ----------------------------------------------------------------
% Title page — gradient with decorative geometry
% ----------------------------------------------------------------

\defbeamertemplate*{title page}{rossbeamercorporate}{%
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
% CORPORATE-SPECIFIC FEATURES
% ================================================================

% ----------------------------------------------------------------
% Slide reference (lightweight — no biblatex)
% ----------------------------------------------------------------

\newcommand{\slideref}[1]{%
  \begin{tikzpicture}[remember picture, overlay]
    \node[anchor=south west, inner sep=0pt, text width=0.7\paperwidth]
      at ([xshift=12.7mm, yshift=8mm]current page.south west)
      {\scriptsize\color{rbTextMuted}#1};
  \end{tikzpicture}%
}

% ----------------------------------------------------------------
% Agenda slide
%
%   \begin{agendaframe}
%     \agendaitem{Introduction}
%     \agendaitemactive{Market Analysis}
%     \agendaitem{Next Steps}
%   \end{agendaframe}
% ----------------------------------------------------------------

\newcounter{corp@agenda}
\newenvironment{agendaframe}[1][Agenda]{%
  \begin{frame}{#1}\setcounter{corp@agenda}{0}%
}{\end{frame}}

\newcommand{\agendaitem}[1]{%
  \stepcounter{corp@agenda}\par\vskip6pt%
  {\Large\bfseries\color{rbTextMuted!50}\thecorp@agenda.\hspace{6pt}}%
  {\large\color{rbText}#1\par}%
  \vskip1pt{\color{rbTextMuted!20}\hrule height 0.3pt}%
}
\newcommand{\agendaitemactive}[1]{%
  \stepcounter{corp@agenda}\par\vskip4pt%
  \begin{tcolorbox}[enhanced, colback=rbPrimaryFaded, colframe=rbPrimaryFaded,
    boxrule=0pt, borderline west={3pt}{0pt}{rbPrimary},
    sharp corners, left=6pt, right=6pt, top=3pt, bottom=3pt]
    {\Large\bfseries\color{rbPrimary}\thecorp@agenda.\hspace{6pt}}%
    {\large\bfseries\color{rbPrimary}#1}%
  \end{tcolorbox}%
}

% ----------------------------------------------------------------
% Timeline / roadmap
%
%   \begin{timelineframe}{Roadmap}
%     \timepoint{0}{Q1}{Research}
%     \timepointcurrent{4}{Q2}{Launch}
%     \timepointdone{8}{Q3}{Scale}
%   \end{timelineframe}
% ----------------------------------------------------------------

\newenvironment{timelineframe}[1]{%
  \begin{frame}{#1}\centering
  \begin{tikzpicture}[every node/.style={font=\small}]
  \draw[rbTextMuted!30, line width=2pt] (0,0) -- (12,0);
}{\end{tikzpicture}\end{frame}}

\newcommand{\timepoint}[3]{%
  \fill[rbSecondaryDark] (#1,0) circle (5pt);
  \node[above=10pt, align=center, font=\footnotesize\bfseries\color{rbText}] at (#1,0) {#2};
  \node[below=10pt, align=center, font=\scriptsize\color{rbTextMuted}] at (#1,0) {#3};
}
\newcommand{\timepointcurrent}[3]{%
  \fill[rbPrimary] (#1,0) circle (7pt);
  \fill[white] (#1,0) circle (3pt);
  \node[above=10pt, align=center, font=\footnotesize\bfseries\color{rbPrimary}] at (#1,0) {#2};
  \node[below=10pt, align=center, font=\scriptsize\bfseries\color{rbPrimary}] at (#1,0) {#3};
}
\newcommand{\timepointdone}[3]{%
  \fill[rbSecondaryDark] (#1,0) circle (5pt);
  \node[font=\tiny, text=rbTextLight] at (#1,0) {\checkmark};
  \node[above=10pt, align=center, font=\footnotesize\color{rbTextMuted}] at (#1,0) {#2};
  \node[below=10pt, align=center, font=\scriptsize\color{rbTextMuted}] at (#1,0) {#3};
}

% ----------------------------------------------------------------
% Metric cards (KPI dashboard)
%
%   \metricrow{%
%     \metriccard{£2.4M}{Revenue}{+12\% YoY}
%     \metriccard[rbSuccess]{98\%}{Uptime}{Target: 99\%}
%   }
% ----------------------------------------------------------------

\newcommand{\metriccard}[4][rbPrimary]{%
  \begin{minipage}[t]{0.30\textwidth}%
    \begin{tcolorbox}[enhanced, colback=white, colframe=white,
      boxrule=0pt, borderline south={2pt}{0pt}{#1},
      sharp corners, left=4pt, right=4pt, top=6pt, bottom=6pt]
      {\fontsize{28}{32}\selectfont\bfseries\color{#1}#2\par}%
      \vskip3pt{\small\color{rbText}#3\par}%
      \vskip1pt{\scriptsize\bfseries\color{rbTextMuted}#4\par}%
    \end{tcolorbox}%
  \end{minipage}\hfill%
}
\newcommand{\metricrow}[1]{\begin{center}#1\end{center}}

% ----------------------------------------------------------------
% Profile cards (team slides)
%
%   \profilecard{Jane Smith}{CEO}{15 years in fintech}
% ----------------------------------------------------------------

\newcommand{\profilecard}[4][]{%
  \begin{minipage}[t]{0.22\textwidth}\centering
    \ifx\relax#1\relax
      \tikz{\node[circle, fill=rbPrimaryLight, minimum size=2cm,
        font=\Huge\bfseries\color{rbPrimary}] {};}%
    \else
      \tikz{\node[circle, minimum size=2cm, path picture={
        \node at (path picture bounding box.center)
          {\includegraphics[width=2cm, height=2cm]{#1}};}] {};}%
    \fi
    \par\vskip4pt%
    {\small\bfseries\color{rbText}#2\par}%
    {\scriptsize\color{rbPrimary}#3\par}%
    \vskip2pt{\scriptsize\color{rbTextMuted}#4\par}%
  \end{minipage}\hfill%
}

% ----------------------------------------------------------------
% Pill badges / tags
%
%   \pillbadge{In Progress}  \pillbadge[rbSuccess]{Complete}
% ----------------------------------------------------------------

\newcommand{\pillbadge}[2][rbPrimary]{%
  \tikz[baseline=-0.3em]{%
    \node[rounded corners=0.7em, fill=#1!15, text=#1,
      inner xsep=6pt, inner ysep=1.5pt,
      font=\scriptsize\bfseries] {#2};}%
}

% ----------------------------------------------------------------
% Process / step flow
%
%   \begin{processframe}{Our Approach}
%     \processstep{1}{Discover}{Research}
%     \processarrow
%     \processstep{2}{Design}{Prototype}
%   \end{processframe}
% ----------------------------------------------------------------

\newenvironment{processframe}[1]{%
  \begin{frame}{#1}\centering\vfill
  \begin{minipage}{0.95\textwidth}\centering
}{\end{minipage}\vfill\end{frame}}

\newcommand{\processstep}[3]{%
  \begin{minipage}[t]{0.20\textwidth}\centering
    \tikz{\node[circle, fill=rbPrimary, text=rbTextLight,
      minimum size=2em, font=\bfseries] {#1};}%
    \par\vskip4pt{\small\bfseries\color{rbText}#2\par}%
    \vskip2pt{\scriptsize\color{rbTextMuted}#3\par}%
  \end{minipage}%
}
\newcommand{\processarrow}{%
  \hfill\tikz[baseline=-0.3em]{%
    \draw[->, rbTextMuted!50, line width=1.5pt] (0,0) -- (0.8,0);}%
  \hfill
}

% ----------------------------------------------------------------
% SWOT / quadrant grid
%
%   \begin{swotframe}{SWOT Analysis}
%     \swotquadrant{rbPrimary}{Strengths}{Strong brand...} &
%     \swotquadrant{rbInfo}{Opportunities}{New markets...} \\[4pt]
%     \swotquadrant{rbWarning}{Weaknesses}{Limited...} &
%     \swotquadrant{rbWarning!70!red}{Threats}{Competition...}
%   \end{swotframe}
% ----------------------------------------------------------------

\newenvironment{swotframe}[1]{%
  \begin{frame}{#1}\centering
  \begin{minipage}{0.95\textwidth}
  \begin{tabular}{@{}p{0.47\textwidth}@{\hspace{0.04\textwidth}}p{0.47\textwidth}@{}}
}{\end{tabular}\end{minipage}\end{frame}}

\newcommand{\swotquadrant}[3]{%
  \begin{tcolorbox}[enhanced, colback=#1!5!white, colframe=#1!5!white,
    boxrule=0pt, borderline north={2pt}{0pt}{#1},
    sharp corners, left=6pt, right=6pt, top=4pt, bottom=4pt,
    height=3cm, valign=top]
    {\small\bfseries\color{#1}#2\par}\vskip2pt%
    {\scriptsize\color{rbText}#3}%
  \end{tcolorbox}%
}

% ----------------------------------------------------------------
% Key takeaway bar (anchored to bottom of slide)
%
%   \keytakeaway{Revenue grew 12\% driven by APAC expansion.}
% ----------------------------------------------------------------

\newcommand{\keytakeaway}[1]{%
  \begin{tikzpicture}[remember picture, overlay]
    \fill[rbPrimary]
      ([yshift=10mm]current page.south west) rectangle
      ([yshift=18mm]current page.south east);
    \node[anchor=west, inner sep=0pt, text=rbTextLight, font=\small\bfseries]
      at ([xshift=14mm, yshift=14mm]current page.south west) {#1};
  \end{tikzpicture}%
}

% ----------------------------------------------------------------
% Dark-mode toggle
% ----------------------------------------------------------------

\ifcorp@darkmode
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
