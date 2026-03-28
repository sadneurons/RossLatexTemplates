% rossbeamerneuroimaging.cls
% Neuroimaging Beamer class — dark backgrounds, activation maps,
% MNI coordinates, colour bars, brain slice layouts, and contrast
% result cards for fMRI / PET / structural imaging talks.
%
% Usage:
%   \documentclass[palette=brainlab]{rossbeamerneuroimaging}
%
% Available palettes:
%   brainlab (default), cortex, fmri, neurorad
%
% Options:
%   palette=<name>   font=<fira|inter|sourcesans|libertinus|heros|georgia|system>
%   monofont=<name>  nobar  nologo
%
% Ross Dunne / Claude, 2026

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{rossbeamerneuroimaging}[2026/03/24 Neuroimaging Beamer class]

% ----------------------------------------------------------------
% Option handling
% ----------------------------------------------------------------

\RequirePackage{pgfkeys}
\RequirePackage{pgfopts}

% Pre-declare base flags so pgfkeys can set them
\newif\ifrb@nobar  \rb@nobarfalse
\newif\ifrb@nologo \rb@nologofalse

\pgfkeys{
  /nibeamer/.cd,
  palette/.store in=\ni@palette,     palette=brainlab,
  font/.store in=\ni@fontchoice,     font=fira,
  monofont/.store in=\ni@mono,       monofont=,
  nobar/.code={\rb@nobartrue},
  nologo/.code={\rb@nologotrue},
}
\ProcessPgfOptions{/nibeamer}

\PassOptionsToClass{aspectratio=169}{beamer}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{beamer}}
\ProcessOptions\relax
\LoadClass{beamer}

% ----------------------------------------------------------------
% Load shared base
% ----------------------------------------------------------------

\RequirePackage{rossbeamerbase}

% ----------------------------------------------------------------
% Additional TikZ libraries for neuroimaging features
% ----------------------------------------------------------------

\usetikzlibrary{positioning,calc}

% ----------------------------------------------------------------
% Palette definitions (7-field compact format)
%   \ni@defpal{name}{primary}{secondary}{accent}{textdark}{textlight}{textmuted}
%
% Neuroimaging palettes use dark primary colours suited for
% brain-scan backgrounds, with accent colours drawn from
% activation-map hues.
% ----------------------------------------------------------------

\newcommand{\ni@defpal}[7]{%
  \expandafter\def\csname ni@p@#1@P\endcsname{#2}%
  \expandafter\def\csname ni@p@#1@S\endcsname{#3}%
  \expandafter\def\csname ni@p@#1@A\endcsname{#4}%
  \expandafter\def\csname ni@p@#1@TD\endcsname{#5}%
  \expandafter\def\csname ni@p@#1@TL\endcsname{#6}%
  \expandafter\def\csname ni@p@#1@TM\endcsname{#7}%
}

% brainlab — deep navy base, hot-orange activation accent
\ni@defpal{brainlab}  {0D1B2A}{1B2838}{FF4500}{E0E0E0}{FFFFFF}{8899AA}
% cortex — charcoal-grey base, synaptic teal accent
\ni@defpal{cortex}    {1A1A2E}{2A2A3E}{26A69A}{D8D8D8}{FFFFFF}{8A8A9E}
% fmri — near-black base, warm-yellow BOLD accent
\ni@defpal{fmri}      {0A0A14}{181828}{FFB347}{E0E0E0}{FFFFFF}{7A7A90}
% neurorad — dark slate base, cool-blue radiological accent
\ni@defpal{neurorad}  {12202C}{1E3040}{4FC3F7}{D0D8E0}{FFFFFF}{7A8898}

% ----------------------------------------------------------------
% Palette activation
% ----------------------------------------------------------------

\newcommand{\ni@activatepalette}{%
  \definecolor{rbPrimary}{HTML}{\csname ni@p@\ni@palette @P\endcsname}%
  \definecolor{rbSecondary}{HTML}{\csname ni@p@\ni@palette @S\endcsname}%
  \definecolor{rbAccent}{HTML}{\csname ni@p@\ni@palette @A\endcsname}%
  \definecolor{rbText}{HTML}{\csname ni@p@\ni@palette @TD\endcsname}%
  \definecolor{rbTextLight}{HTML}{\csname ni@p@\ni@palette @TL\endcsname}%
  \definecolor{rbTextMuted}{HTML}{\csname ni@p@\ni@palette @TM\endcsname}%
  \definecolor{rbBg}{HTML}{0D1117}%
  \colorlet{rbRule}{rbTextMuted!30}%
  \rb@derivecolors
  % Legacy aliases
  \colorlet{niPrimary}{rbPrimary}%
  \colorlet{niSecondary}{rbSecondary}%
  \colorlet{niAccent}{rbAccent}%
  \colorlet{niText}{rbText}%
  \colorlet{niTextLight}{rbTextLight}%
  \colorlet{niTextMuted}{rbTextMuted}%
}
\ni@activatepalette

\newcommand{\setpalette}[1]{%
  \def\ni@palette{#1}\ni@activatepalette
}

% ----------------------------------------------------------------
% Beamer setup
% ----------------------------------------------------------------

\rb@setupbeamer
\setbeamersize{text margin left=12mm, text margin right=12mm}

% Neuroimaging frame title: light text with thin accent underline
\setbeamertemplate{frametitle}{%
  \vskip6pt%
  {\usebeamerfont{frametitle}\usebeamercolor[fg]{frametitle}\insertframetitle}%
  \ifx\insertframesubtitle\empty\else
    \par\vskip1pt%
    {\usebeamerfont{framesubtitle}\usebeamercolor[fg]{framesubtitle}\insertframesubtitle}%
  \fi
  \vskip2pt{\color{rbAccent!50}\hrule height 0.4pt}\vskip4pt%
}

% Font activation + serif math
\rb@activatefont{\ni@fontchoice}
\rb@activatemono{\ni@mono}
\usefonttheme[onlymath]{serif}

% Footer: always on
\rb@activatefooter

% ----------------------------------------------------------------
% Default dark background for all content frames
% ----------------------------------------------------------------

\setbeamercolor{normal text}{fg=rbTextLight, bg=rbPrimary}
\setbeamercolor{frametitle}{fg=rbTextLight}
\setbeamercolor{framesubtitle}{fg=rbTextMuted}
\setbeamercolor{itemize item}{fg=rbAccent}
\setbeamercolor{itemize subitem}{fg=rbTextMuted}
\setbeamercolor{enumerate item}{fg=rbAccent}
\setbeamercolor{enumerate subitem}{fg=rbTextMuted}
\setbeamercolor{block title}{fg=rbTextLight, bg=rbSecondary}
\setbeamercolor{block body}{fg=rbTextLight, bg=rbPrimary!80!black}
\setbeamercolor{block title alerted}{fg=rbTextLight, bg=rbBrainHot}
\setbeamercolor{block body alerted}{fg=rbTextLight, bg=rbBrainHot!15!rbPrimary}
\setbeamercolor{block title example}{fg=rbTextLight, bg=rbBrainCool!70!black}
\setbeamercolor{block body example}{fg=rbTextLight, bg=rbBrainCool!10!rbPrimary}
\setbeamercolor{caption name}{fg=rbTextMuted}
\setbeamercolor{description item}{fg=rbAccent}
\setbeamercolor{table head}{fg=rbTextLight, bg=rbSecondary}

% Bullet styling for dark backgrounds
\setbeamertemplate{itemize item}{\tikz\draw[fill=rbAccent,draw=none] (0,0) circle (0.07);}
\setbeamertemplate{itemize subitem}{\tikz\draw[fill=rbTextMuted,draw=none] (0,0) circle (0.05);}

% ----------------------------------------------------------------
% Title page — dark with gradient and brain-scan accent
% ----------------------------------------------------------------

\def\ni@conference{}
\newcommand{\conference}[1]{\def\ni@conference{#1}}

\defbeamertemplate*{title page}{rossbeamerneuroimaging}{%
  \begin{tikzpicture}[remember picture, overlay]
    % Dark gradient background
    \shade[shading=axis, shading angle=160,
      left color=rbPrimary, right color=rbPrimary!90!black]
      (current page.south west) rectangle (current page.north east);
    % Subtle secondary glow in top-right
    \fill[rbSecondary, opacity=0.08]
      ([xshift=30mm, yshift=-15mm]current page.north east) circle (55mm);
    % Accent bar at bottom
    \fill[rbAccent, opacity=0.85]
      (current page.south west) rectangle
      ([yshift=2.5mm]current page.south east);
  \end{tikzpicture}%
  \vfill
  {\usebeamerfont{title}\color{rbTextLight}\inserttitle\par}%
  \ifx\insertsubtitle\empty\else
    \vskip6pt{\usebeamerfont{subtitle}\color{rbTextMuted}\insertsubtitle\par}\fi
  \vskip14pt%
  \ifx\insertauthor\empty\else
    {\usebeamerfont{author}\color{rbTextLight!85}\insertauthor\par}\fi
  \ifx\insertinstitute\empty\else
    \vskip2pt{\usebeamerfont{institute}\color{rbTextMuted}\insertinstitute\par}\fi
  \ifx\insertdate\empty\else
    \vskip2pt{\usebeamerfont{date}\color{rbTextMuted}\insertdate\par}\fi
  \ifx\ni@conference\empty\else
    \vskip4pt{\usebeamerfont{date}\color{rbTextMuted}\itshape\ni@conference\par}\fi
  \vfill
}

\setbeamerfont{title}{size=\Huge, series=\bfseries}

% ================================================================
% NEUROIMAGING-SPECIFIC FEATURES
% ================================================================

% ----------------------------------------------------------------
% MNI coordinate formatting
%
%   \mnicoord{-42}{18}{30}  ->  (-42, 18, 30)
%   Renders as a monospaced coordinate triple in accent colour.
% ----------------------------------------------------------------

\newcommand{\mnicoord}[3]{%
  {\texttt{\color{rbAccent}(\,#1,\;#2,\;#3\,)}}%
}

% ----------------------------------------------------------------
% Colour bar — vertical TikZ gradient bar for activation maps
%
%   \colorbar{t-value}{0}{8}
%   Draws a vertical gradient from rbBrainCool to rbBrainHot
%   with min/max labels and a centred title.
%
%   Optional first argument: colour pair {bottom}{top}
%   \colorbar[rbBrainCold][rbBrainHot]{Z-score}{-3}{3}
% ----------------------------------------------------------------

\newcommand{\colorbar}[5][rbBrainCool]{%
  \ni@colorbar@inner{#1}{#2}{#3}{#4}{#5}%
}
\newcommand{\ni@colorbar@inner}[5]{%
  % #1 = bottom colour, #2 = top colour
  % #3 = label, #4 = min, #5 = max
  \begin{tikzpicture}[baseline=(current bounding box.center)]
    \shade[bottom color=#1, top color=#2, draw=rbTextMuted!40, thin]
      (0,0) rectangle (0.35,3);
    \node[anchor=east, font=\tiny\color{rbTextLight}] at (-0.08,0) {#4};
    \node[anchor=east, font=\tiny\color{rbTextLight}] at (-0.08,3) {#5};
    \node[anchor=south, font=\tiny\bfseries\color{rbTextLight},
      rotate=90] at (0.55,1.5) {#3};
  \end{tikzpicture}%
}

% Convenience: default hot-to-cool bar
\let\ni@colorbar@orig\colorbar
\renewcommand{\colorbar}[3]{%
  \ni@colorbar@inner{rbBrainCool}{rbBrainHot}{#1}{#2}{#3}%
}

% Full version with custom colours
\newcommand{\colorbarfull}[5]{%
  % \colorbarfull{bottomcol}{topcol}{label}{min}{max}
  \ni@colorbar@inner{#1}{#2}{#3}{#4}{#5}%
}

% ----------------------------------------------------------------
% Scan overlay — full-bleed brain image with dark overlay
%
%   \scanoverlay{scan.png}
%   Fills frame background with image, applies a dark semi-
%   transparent overlay so text remains legible.
%
%   Optional argument: overlay opacity (default 0.55)
% ----------------------------------------------------------------

\newcommand{\scanoverlay}[2][0.55]{%
  \begin{tikzpicture}[remember picture, overlay]
    \node[inner sep=0pt] at (current page.center)
      {\includegraphics[width=\paperwidth, height=\paperheight,
        keepaspectratio=false]{#2}};
    \fill[rbPrimary, opacity=#1]
      (current page.south west) rectangle (current page.north east);
  \end{tikzpicture}%
}

% ----------------------------------------------------------------
% Brain slice — formatted brain image with caption label
%
%   \brainslice{axial_z30.png}{Axial slice, $z = 30$}
%   Renders the image centred with a styled caption underneath.
%
%   Optional first argument: width (default \linewidth)
% ----------------------------------------------------------------

\newcommand{\brainslice}[3][\linewidth]{%
  \begin{minipage}[t]{#1}\centering
    \includegraphics[width=\linewidth]{#2}\par
    \vskip3pt%
    \begin{tikzpicture}
      \node[fill=rbPrimary!80!black, inner xsep=6pt, inner ysep=2pt,
        rounded corners=1.5pt, font=\scriptsize\color{rbTextLight}] {#3};
    \end{tikzpicture}
  \end{minipage}%
}

% ----------------------------------------------------------------
% Contrast card — activation result summary card
%
%   \contrastcard{Faces > Houses}{4.82}{142}{R Fusiform Gyrus}
%   Renders a compact card showing contrast name, peak t-value,
%   cluster extent, and anatomical region.
% ----------------------------------------------------------------

\newcommand{\contrastcard}[4]{%
  \begin{tcolorbox}[
    enhanced, colback=rbSecondary!60!rbPrimary, colframe=rbSecondary!60!rbPrimary,
    boxrule=0pt, borderline west={3pt}{0pt}{rbAccent},
    sharp corners, left=8pt, right=8pt, top=5pt, bottom=5pt,
  ]
    {\small\bfseries\color{rbTextLight}#1\par}%
    \vskip3pt%
    \begin{minipage}[t]{0.30\textwidth}
      {\scriptsize\color{rbTextMuted}Peak $t$\par}%
      {\normalsize\bfseries\color{rbBrainHot}#2}%
    \end{minipage}%
    \begin{minipage}[t]{0.30\textwidth}
      {\scriptsize\color{rbTextMuted}Cluster $k$\par}%
      {\normalsize\bfseries\color{rbAccent}#3}%
    \end{minipage}%
    \begin{minipage}[t]{0.38\textwidth}
      {\scriptsize\color{rbTextMuted}Region\par}%
      {\normalsize\color{rbTextLight}#4}%
    \end{minipage}%
  \end{tcolorbox}%
}

% ----------------------------------------------------------------
% ROI annotation — highlighted ROI label badge
%
%   \roiannotation{Hippocampus}
%   Renders a small pill-shaped badge for labelling ROIs on
%   figures or in running text.
%
%   Optional argument: badge colour (default rbAccent)
% ----------------------------------------------------------------

\newcommand{\roiannotation}[2][rbAccent]{%
  \tikz[baseline=-0.3em]{%
    \node[rounded corners=0.7em, fill=#1!25!rbPrimary, text=#1,
      inner xsep=6pt, inner ysep=1.5pt,
      font=\scriptsize\bfseries] {#2};}%
}

% ----------------------------------------------------------------
% Atlas frame environment — multi-panel anatomical layout
%
%   \begin{atlasframe}{Title}
%     \atlasleft{sagittal.png}{Sagittal}
%     \atlasright{%
%       \atlaspanel{axial.png}{Axial}
%       \atlaspanel{coronal.png}{Coronal}
%     }
%   \end{atlasframe}
%
% Provides a two-column layout (large left panel + stacked right
% panels) typical of neuroanatomical atlases.
% ----------------------------------------------------------------

% atlasframe — use INSIDE a frame, not as a frame wrapper.
% Usage:
%   \begin{frame}{Title}
%     \begin{atlasframe}
%       \atlasleft{img}{cap}
%       \atlasright{\atlaspanel{img}{cap}}
%     \end{atlasframe}
%   \end{frame}
\newenvironment{atlasframe}{%
  \begin{columns}[T]%
}{%
  \end{columns}%
}

% Left column: large primary view
\newcommand{\atlasleft}[2]{%
  \begin{column}{0.55\textwidth}%
    \centering
    \includegraphics[width=\linewidth]{#1}\par
    \vskip3pt%
    {\scriptsize\color{rbTextMuted}#2}%
  \end{column}%
}

% Right column: container for stacked panels
\newcommand{\atlasright}[1]{%
  \begin{column}{0.42\textwidth}%
    #1%
  \end{column}%
}

% Individual panel within atlasright
\newcommand{\atlaspanel}[2]{%
  \centering
  \includegraphics[width=\linewidth]{#1}\par
  \vskip2pt%
  {\scriptsize\color{rbTextMuted}#2}\par
  \vskip6pt%
}

% ----------------------------------------------------------------
% Coordinate table — tabular MNI results
%
%   \begin{coordtable}
%     \coordrow{L Inferior Frontal}{-42}{18}{24}{5.12}{186}
%     \coordrow{R Fusiform}{38}{-52}{-18}{4.87}{142}
%   \end{coordtable}
% ----------------------------------------------------------------

\newenvironment{coordtable}{%
  \small
  \begin{tabular}{@{}l c c c r r@{}}
    \toprule
    \color{rbTextLight}\bfseries Region &
    \color{rbTextLight}\bfseries $x$ &
    \color{rbTextLight}\bfseries $y$ &
    \color{rbTextLight}\bfseries $z$ &
    \color{rbTextLight}\bfseries $t$ &
    \color{rbTextLight}\bfseries $k$ \\
    \midrule
}{%
    \bottomrule
  \end{tabular}%
}

\newcommand{\coordrow}[6]{%
  \color{rbTextLight}#1 &
  \color{rbAccent}\texttt{#2} &
  \color{rbAccent}\texttt{#3} &
  \color{rbAccent}\texttt{#4} &
  \color{rbBrainHot}#5 &
  \color{rbTextMuted}#6 \\
}

% ----------------------------------------------------------------
% Threshold badge — display significance threshold
%
%   \thresholdbadge{$p < .001$ (unc.)}
%   \thresholdbadge[rbBrainCool]{FWE $p < .05$}
% ----------------------------------------------------------------

\newcommand{\thresholdbadge}[2][rbBrainWarm]{%
  \tikz[baseline=-0.3em]{%
    \node[rounded corners=1pt, fill=#1!20!rbPrimary, text=#1,
      inner xsep=5pt, inner ysep=2pt,
      font=\scriptsize\bfseries] {#2};}%
}

% ----------------------------------------------------------------
% Paradigm timeline — experimental design diagram
%
%   \begin{paradigmframe}{Task Design}
%     \paradigmblock{0}{3}{rbBrainHot}{Faces}
%     \paradigmblock{3}{6}{rbBrainCool}{Houses}
%     \paradigmblock{6}{8}{rbPrimary!50}{Rest}
%     \paradigmblock{8}{11}{rbBrainHot}{Faces}
%   \end{paradigmframe}
% ----------------------------------------------------------------

\newenvironment{paradigmframe}[1]{%
  \begin{frame}{#1}\centering
  \begin{tikzpicture}[every node/.style={font=\small}]
    \draw[rbTextMuted!40, line width=1pt] (0,0) -- (12,0);
    \node[anchor=east, font=\scriptsize\color{rbTextMuted}] at (-0.2,0) {Time};
}{%
  \end{tikzpicture}
  \end{frame}%
}

\newcommand{\paradigmblock}[4]{%
  % #1=start, #2=end, #3=colour, #4=label
  \fill[#3, opacity=0.7, rounded corners=1pt]
    (#1,0.15) rectangle (#2,0.8);
  \node[font=\scriptsize\bfseries\color{rbTextLight}]
    at ({(#1+#2)/2},0.475) {#4};
}

% ----------------------------------------------------------------
% Activation overlay annotation — place labelled arrows on scans
%
%   \activationlabel{0.3}{0.6}{R FFA}
%   Positions a label with leader line at relative coordinates
%   on the current frame.
% ----------------------------------------------------------------

\newcommand{\activationlabel}[3]{%
  % #1=relative x (0-1), #2=relative y (0-1), #3=label
  \begin{tikzpicture}[remember picture, overlay]
    \coordinate (target) at
      ([xshift=#1\paperwidth, yshift=#2\paperheight]current page.south west);
    \node[fill=rbPrimary!80!black, text=rbAccent,
      font=\scriptsize\bfseries, inner xsep=4pt, inner ysep=2pt,
      rounded corners=1pt, anchor=west]
      (lbl) at ([xshift=8pt]target) {#3};
    \draw[rbAccent, thick, -] (target) -- (lbl.west);
    \fill[rbAccent] (target) circle (2pt);
  \end{tikzpicture}%
}

% ----------------------------------------------------------------
% Scan comparison — side-by-side before/after or two-condition
%
%   \scancompare{pre.png}{Pre-treatment}{post.png}{Post-treatment}
% ----------------------------------------------------------------

\newcommand{\scancompare}[4]{%
  \begin{columns}[c]
    \begin{column}{0.47\textwidth}\centering
      \includegraphics[width=\linewidth]{#1}\par
      \vskip3pt%
      \begin{tikzpicture}
        \node[fill=rbSecondary!50!rbPrimary, inner xsep=6pt, inner ysep=2pt,
          rounded corners=1.5pt, font=\scriptsize\bfseries\color{rbTextLight}] {#2};
      \end{tikzpicture}
    \end{column}
    \begin{column}{0.47\textwidth}\centering
      \includegraphics[width=\linewidth]{#3}\par
      \vskip3pt%
      \begin{tikzpicture}
        \node[fill=rbSecondary!50!rbPrimary, inner xsep=6pt, inner ysep=2pt,
          rounded corners=1.5pt, font=\scriptsize\bfseries\color{rbTextLight}] {#4};
      \end{tikzpicture}
    \end{column}
  \end{columns}%
}

% ----------------------------------------------------------------
% Pipeline step — method diagram building block
%
%   \pipelinestep{1}{Preprocessing}{Motion correction, ...}
% ----------------------------------------------------------------

\newcommand{\pipelinestep}[3]{%
  \begin{minipage}[t]{0.20\textwidth}\centering
    \tikz{\node[circle, fill=rbAccent, text=rbPrimary,
      minimum size=2em, font=\bfseries] {#1};}%
    \par\vskip4pt{\small\bfseries\color{rbTextLight}#2\par}%
    \vskip2pt{\scriptsize\color{rbTextMuted}#3\par}%
  \end{minipage}%
}
\newcommand{\pipelinearrow}{%
  \hfill\tikz[baseline=-0.3em]{%
    \draw[->, rbAccent!60, line width=1.5pt] (0,0) -- (0.8,0);}%
  \hfill
}

% ----------------------------------------------------------------
% Modality badge — label for imaging modality
%
%   \modalitybadge{fMRI}  \modalitybadge[rbBrainCool]{DTI}
% ----------------------------------------------------------------

\newcommand{\modalitybadge}[2][rbAccent]{%
  \tikz[baseline=-0.3em]{%
    \node[rounded corners=0.7em, fill=#1!20!rbPrimary, text=#1,
      inner xsep=6pt, inner ysep=1.5pt,
      font=\scriptsize\bfseries\sffamily] {\MakeUppercase{#2}};}%
}

% ----------------------------------------------------------------
\endinput
