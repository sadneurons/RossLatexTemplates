% rossbeamergenomics.cls
% Genomics Beamer class for variant interpretation, bioinformatics
% pipelines, and genetic research presentations.
%
% Usage:
%   \documentclass[palette=genome]{rossbeamergenomics}
%
% Available palettes:
%   genome (default) — deep navy/green for clinical genomics
%   variant          — dark tones with nucleotide accent colours
%   omics            — teal/purple for multi-omics data
%
% Options:
%   palette=<name>   font=<fira|inter|sourcesans|libertinus|heros|georgia|system>
%   monofont=<name>  nobar  nologo
%
% Ross Dunne / Claude, 2026

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{rossbeamergenomics}[2026/03/24 Genomics Beamer class]

% ----------------------------------------------------------------
% Option handling
% ----------------------------------------------------------------

\RequirePackage{pgfkeys}
\RequirePackage{pgfopts}

\newif\ifrb@nobar  \rb@nobarfalse
\newif\ifrb@nologo \rb@nologofalse

\pgfkeys{
  /genbeamer/.cd,
  palette/.store in=\gen@palette,   palette=genome,
  font/.store in=\gen@fontchoice,   font=fira,
  monofont/.store in=\gen@mono,     monofont=,
  nobar/.code={\rb@nobartrue},
  nologo/.code={\rb@nologotrue},
}
\ProcessPgfOptions{/genbeamer}

\PassOptionsToClass{aspectratio=169}{beamer}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{beamer}}
\ProcessOptions\relax
\LoadClass{beamer}

% ----------------------------------------------------------------
% Load shared base
% ----------------------------------------------------------------

\RequirePackage{rossbeamerbase}

% ----------------------------------------------------------------
% Palette definitions (12-field format)
%
% \gen@defpal{name}
%   {primary}{secondary}{accent}{text}{textlight}{textmuted}{bg}{rule}
%   {accentdark}{accentlight}{accentbg}{lightmuted}
% ----------------------------------------------------------------

\newcommand{\gen@defpal}[9]{%
  \expandafter\def\csname gen@p@#1@P\endcsname{#2}%   primary
  \expandafter\def\csname gen@p@#1@S\endcsname{#3}%   secondary
  \expandafter\def\csname gen@p@#1@A\endcsname{#4}%   accent
  \expandafter\def\csname gen@p@#1@T\endcsname{#5}%   text
  \expandafter\def\csname gen@p@#1@TL\endcsname{#6}%  textlight
  \expandafter\def\csname gen@p@#1@TM\endcsname{#7}%  textmuted
  \expandafter\def\csname gen@p@#1@B\endcsname{#8}%   bg
  \expandafter\def\csname gen@p@#1@R\endcsname{#9}%   rule
  \gen@defpal@cont{#1}%
}
\newcommand{\gen@defpal@cont}[5]{%
  \expandafter\def\csname gen@p@#1@AD\endcsname{#2}%  accentdark
  \expandafter\def\csname gen@p@#1@AL\endcsname{#3}%  accentlight
  \expandafter\def\csname gen@p@#1@AB\endcsname{#4}%  accentbg
  \expandafter\def\csname gen@p@#1@LM\endcsname{#5}%  lightmuted
}

%                    name       P       S       A       T       TL      TM      B       R       AD      AL      AB      LM
% genome: deep navy primary, forest green secondary, teal accent
\gen@defpal{genome}  {0D1B2A}{2D6A4F}{1B7A6E}{1C1C1C}{FFFFFF}{5A6B78}{F6F8FA}{CDD8DE}{0F5C52}{2AABAB}{E6F5F3}{8A9CAA}
% variant: dark charcoal primary, warm grey secondary, nucleotide-inspired red accent
\gen@defpal{variant} {1A1A28}{4A4A5A}{C0392B}{1C1C1C}{FFFFFF}{6A6A78}{F8F7F5}{D0D0D8}{8E2B20}{E57373}{FBEEED}{9898A8}
% omics: rich teal primary, purple secondary, violet accent
\gen@defpal{omics}   {0A2928}{7B3F9E}{5E35B1}{1C1C1C}{FFFFFF}{587878}{F7F8FA}{CCD5D5}{3E1A78}{9575CD}{F0EAF8}{88A8A8}

% ----------------------------------------------------------------
% Palette activation
% ----------------------------------------------------------------

\newcommand{\gen@activatepalette}{%
  % Core colours
  \definecolor{rbPrimary}{HTML}{\csname gen@p@\gen@palette @P\endcsname}%
  \definecolor{rbSecondary}{HTML}{\csname gen@p@\gen@palette @S\endcsname}%
  \definecolor{rbAccent}{HTML}{\csname gen@p@\gen@palette @A\endcsname}%
  \definecolor{rbText}{HTML}{\csname gen@p@\gen@palette @T\endcsname}%
  \definecolor{rbTextLight}{HTML}{\csname gen@p@\gen@palette @TL\endcsname}%
  \definecolor{rbTextMuted}{HTML}{\csname gen@p@\gen@palette @TM\endcsname}%
  \definecolor{rbBg}{HTML}{\csname gen@p@\gen@palette @B\endcsname}%
  \definecolor{rbRule}{HTML}{\csname gen@p@\gen@palette @R\endcsname}%
  % Derive standard colours
  \rb@derivecolors
  % Override with explicit palette refinements
  \definecolor{rbAccentDark}{HTML}{\csname gen@p@\gen@palette @AD\endcsname}%
  \definecolor{rbAccentLight}{HTML}{\csname gen@p@\gen@palette @AL\endcsname}%
  \definecolor{rbAccentBg}{HTML}{\csname gen@p@\gen@palette @AB\endcsname}%
  \definecolor{rbLightMuted}{HTML}{\csname gen@p@\gen@palette @LM\endcsname}%
  % Legacy aliases
  \colorlet{genDark}{rbPrimary}%
  \colorlet{genText}{rbText}%
  \colorlet{genMuted}{rbTextMuted}%
  \colorlet{genAccent}{rbAccent}%
  \colorlet{genAccentDark}{rbAccentDark}%
  \colorlet{genAccentLight}{rbAccentLight}%
  \colorlet{genAccentBg}{rbAccentBg}%
  \colorlet{genBg}{rbBg}%
  \colorlet{genLight}{rbTextLight}%
  \colorlet{genLightMuted}{rbLightMuted}%
  \colorlet{genRule}{rbRule}%
}
\gen@activatepalette

\newcommand{\setpalette}[1]{\def\gen@palette{#1}\gen@activatepalette}

% ----------------------------------------------------------------
% Beamer setup
% ----------------------------------------------------------------

\rb@setupbeamer
\setbeamersize{text margin left=12mm, text margin right=12mm}

% Genomics frame title: with thin accent underline
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
\rb@activatefont{\gen@fontchoice}
\rb@activatemono{\gen@mono}
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
% Title page — dark with double-helix accent stripe
% ----------------------------------------------------------------

\def\gen@conference{}
\newcommand{\conference}[1]{\def\gen@conference{#1}}

\defbeamertemplate*{title page}{rossbeamergenomics}{%
  \begin{tikzpicture}[remember picture, overlay]
    \fill[rbPrimary] (current page.south west) rectangle (current page.north east);
    \fill[rbAccent]
      ([yshift=12mm]current page.south west) rectangle
      ([yshift=12.6mm]current page.south east);
    \fill[rbSecondary!60]
      ([yshift=13.2mm]current page.south west) rectangle
      ([yshift=13.6mm]current page.south east);
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
  \ifx\gen@conference\empty\else
    \vskip4pt{\usebeamerfont{date}\color{rbLightMuted}\itshape\gen@conference\par}\fi
  \vfill
}

% ================================================================
% GENOMICS-SPECIFIC FEATURES
% ================================================================

% ----------------------------------------------------------------
% Domain colours for genomics elements
% ----------------------------------------------------------------

\definecolor{genOncogene}{HTML}{C62828}
\definecolor{genSuppressor}{HTML}{1565C0}
\definecolor{genGeneOther}{HTML}{757575}
\definecolor{genBenign}{HTML}{2E7D32}
\definecolor{genVUS}{HTML}{F9A825}
\definecolor{genPathogenic}{HTML}{C62828}

% ----------------------------------------------------------------
% \genelabel{name}{type}
% Coloured gene tag: oncogene=red, suppressor=blue, other=grey
% ----------------------------------------------------------------

\newcommand{\genelabel}[2]{%
  \def\gen@type{#2}%
  \def\gen@oncogene{oncogene}%
  \def\gen@suppressor{suppressor}%
  \ifx\gen@type\gen@oncogene
    \tikz[baseline=(G.base)]{\node[fill=genOncogene!12, text=genOncogene,
      font=\small\bfseries\ttfamily, inner xsep=4pt, inner ysep=1.5pt,
      rounded corners=2pt] (G) {#1};}%
  \else\ifx\gen@type\gen@suppressor
    \tikz[baseline=(G.base)]{\node[fill=genSuppressor!12, text=genSuppressor,
      font=\small\bfseries\ttfamily, inner xsep=4pt, inner ysep=1.5pt,
      rounded corners=2pt] (G) {#1};}%
  \else
    \tikz[baseline=(G.base)]{\node[fill=genGeneOther!12, text=genGeneOther,
      font=\small\bfseries\ttfamily, inner xsep=4pt, inner ysep=1.5pt,
      rounded corners=2pt] (G) {#1};}%
  \fi\fi
}

% ----------------------------------------------------------------
% \variantcard{gene}{variant}{consequence}{freq}{pathogenicity}
% Variant summary card using tcolorbox
% ----------------------------------------------------------------

\newtcolorbox{gen@variantbox}{%
  enhanced, colback=rbBg, colframe=rbBg, boxrule=0pt,
  borderline west={3pt}{0pt}{rbAccent}, sharp corners,
  left=8pt, right=8pt, top=5pt, bottom=5pt,
}

\newcommand{\variantcard}[5]{%
  \begin{gen@variantbox}
    {\small\bfseries\ttfamily\color{rbPrimary}#1}\hfill%
    {\small\ttfamily\color{rbAccentDark}#2}%
    \par\vskip3pt%
    {\scriptsize\color{rbText}\textbf{Consequence:}~#3\hfill%
    \textbf{Frequency:}~#4}%
    \par\vskip2pt%
    {\scriptsize\color{rbText}\textbf{Classification:}~\pathogenicity{#5}}%
  \end{gen@variantbox}%
}

% ----------------------------------------------------------------
% \manhattanpoint{chr}{pos}{gene}{pval}
% Annotation helper for Manhattan plots (overlay node)
% ----------------------------------------------------------------

\newcommand{\manhattanpoint}[4]{%
  \tikz[baseline=(M.base)]{%
    \node[fill=rbAccentBg, draw=rbAccent, line width=0.4pt,
      rounded corners=2pt, inner xsep=4pt, inner ysep=2pt,
      font=\scriptsize] (M)
      {\textbf{Chr#1}:#2~~{\ttfamily #3}~~\textit{p}~=~#4};}%
}

% ----------------------------------------------------------------
% pipelineflow environment + \pipelinestep + \pipelinearrow
% Bioinformatics pipeline diagram using TikZ
% ----------------------------------------------------------------

\newcounter{gen@pipestep}

\newenvironment{pipelineflow}{%
  \setcounter{gen@pipestep}{0}%
  \begin{center}%
  \begin{tikzpicture}[
    node distance=0.5cm,
    pipenode/.style={
      draw=rbAccent, fill=rbAccentBg, rounded corners=3pt,
      text=rbText, font=\small, align=center,
      inner xsep=10pt, inner ysep=5pt, line width=0.6pt,
    },
    pipearrow/.style={
      ->, >=stealth, rbAccent, line width=0.8pt,
    },
  ]%
}{%
  \end{tikzpicture}%
  \end{center}%
}

\newcommand{\pipelinestep}[2]{%
  \stepcounter{gen@pipestep}%
  \ifnum\value{gen@pipestep}=1
    \node[pipenode] (pipe\thegen@pipestep) {\textbf{#1}\\[1pt]{\scriptsize #2}};%
  \else
    \node[pipenode, right=of pipe\the\numexpr\value{gen@pipestep}-1\relax]
      (pipe\thegen@pipestep) {\textbf{#1}\\[1pt]{\scriptsize #2}};%
  \fi
}

\newcommand{\pipelinearrow}{%
  \ifnum\value{gen@pipestep}>1
    \draw[pipearrow]
      (pipe\the\numexpr\value{gen@pipestep}-1\relax) -- (pipe\thegen@pipestep);%
  \fi
}

% ----------------------------------------------------------------
% \sequencingqc{reads}{coverage}{quality}
% QC summary card for sequencing metrics
% ----------------------------------------------------------------

\newtcolorbox{gen@qcbox}{%
  enhanced, colback=rbBg, colframe=rbBg, boxrule=0pt,
  borderline west={3pt}{0pt}{rbSecondary}, sharp corners,
  left=8pt, right=8pt, top=5pt, bottom=5pt,
}

\newcommand{\sequencingqc}[3]{%
  \begin{gen@qcbox}
    {\small\bfseries\color{rbSecondary}Sequencing QC}\par\vskip3pt%
    \begin{tabular}{@{}l@{\hskip8pt}l@{}}
      {\scriptsize\bfseries\color{rbText}Total Reads:} &
        {\scriptsize\color{rbText}#1}\\[2pt]
      {\scriptsize\bfseries\color{rbText}Mean Coverage:} &
        {\scriptsize\color{rbText}#2}\\[2pt]
      {\scriptsize\bfseries\color{rbText}Base Quality:} &
        {\scriptsize\color{rbText}#3}\\
    \end{tabular}%
  \end{gen@qcbox}%
}

% ----------------------------------------------------------------
% \chromosomebar{chr}{start}{end}{label}
% Ideogram annotation bar using TikZ
% ----------------------------------------------------------------

\newcommand{\chromosomebar}[4]{%
  \begin{tikzpicture}[baseline=-0.3em]
    % Chromosome bar body
    \fill[rbRule!40, rounded corners=2pt] (0,0) rectangle (4,0.35);
    % Highlighted region
    \pgfmathsetmacro{\startfrac}{#2/250}%   normalised to 250 Mb scale
    \pgfmathsetmacro{\endfrac}{#3/250}%
    \fill[rbAccent!60, rounded corners=1pt]
      ({4*\startfrac},0.02) rectangle ({4*\endfrac},0.33);
    % Label
    \node[anchor=west, font=\scriptsize\bfseries, text=rbPrimary]
      at (4.15,0.175) {Chr#1};
    \node[anchor=west, font=\tiny, text=rbTextMuted]
      at (4.15,-0.08) {#4};
  \end{tikzpicture}%
}

% ----------------------------------------------------------------
% \nucleotide{base}
% Coloured nucleotide letter using rbAdenine/rbThymine/rbCytosine/
% rbGuanine defined in rossbeamerbase
% ----------------------------------------------------------------

\newcommand{\nucleotide}[1]{%
  \def\gen@base{#1}%
  \def\gen@A{A}\def\gen@T{T}\def\gen@C{C}\def\gen@G{G}%
  \ifx\gen@base\gen@A
    {\bfseries\ttfamily\color{rbAdenine}A}%
  \else\ifx\gen@base\gen@T
    {\bfseries\ttfamily\color{rbThymine}T}%
  \else\ifx\gen@base\gen@C
    {\bfseries\ttfamily\color{rbCytosine}C}%
  \else\ifx\gen@base\gen@G
    {\bfseries\ttfamily\color{rbGuanine}G}%
  \else
    {\bfseries\ttfamily\color{rbTextMuted}#1}%
  \fi\fi\fi\fi
}

% ----------------------------------------------------------------
% \pathogenicity{level}
% Badge: benign=green, VUS=amber, pathogenic=red
% ----------------------------------------------------------------

\newcommand{\pathogenicity}[1]{%
  \def\gen@lvl{#1}%
  \def\gen@benign{benign}%
  \def\gen@vus{VUS}%
  \def\gen@pathogenic{pathogenic}%
  \def\gen@likelyben{likely benign}%
  \def\gen@likelypath{likely pathogenic}%
  \ifx\gen@lvl\gen@benign
    \tikz[baseline=(P.base)]{\node[fill=genBenign!15, text=genBenign,
      font=\scriptsize\bfseries, inner xsep=4pt, inner ysep=1.5pt,
      rounded corners=2pt] (P) {Benign};}%
  \else\ifx\gen@lvl\gen@likelyben
    \tikz[baseline=(P.base)]{\node[fill=genBenign!10, text=genBenign!80!black,
      font=\scriptsize\bfseries, inner xsep=4pt, inner ysep=1.5pt,
      rounded corners=2pt] (P) {Likely Benign};}%
  \else\ifx\gen@lvl\gen@vus
    \tikz[baseline=(P.base)]{\node[fill=genVUS!15, text=genVUS!80!black,
      font=\scriptsize\bfseries, inner xsep=4pt, inner ysep=1.5pt,
      rounded corners=2pt] (P) {VUS};}%
  \else\ifx\gen@lvl\gen@likelypath
    \tikz[baseline=(P.base)]{\node[fill=genPathogenic!10, text=genPathogenic!80!black,
      font=\scriptsize\bfseries, inner xsep=4pt, inner ysep=1.5pt,
      rounded corners=2pt] (P) {Likely Pathogenic};}%
  \else\ifx\gen@lvl\gen@pathogenic
    \tikz[baseline=(P.base)]{\node[fill=genPathogenic!15, text=genPathogenic,
      font=\scriptsize\bfseries, inner xsep=4pt, inner ysep=1.5pt,
      rounded corners=2pt] (P) {Pathogenic};}%
  \else
    \tikz[baseline=(P.base)]{\node[fill=genGeneOther!12, text=genGeneOther,
      font=\scriptsize\bfseries, inner xsep=4pt, inner ysep=1.5pt,
      rounded corners=2pt] (P) {#1};}%
  \fi\fi\fi\fi\fi
}

% ----------------------------------------------------------------
% Slide footnotes (genomics context)
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
    \vskip6pt{\normalsize\color{rbLightMuted}Supplementary analyses and additional data\par}
  \end{darkframe}
}

% ----------------------------------------------------------------
\endinput
