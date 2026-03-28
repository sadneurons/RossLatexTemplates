% rossbeamerposter.cls
% Beamer-based conference poster class — large-format A0/A1 posters
% with palette-driven colour, structured column layout, and styled
% content blocks.
%
% Usage:
%   \documentclass[palette=lancet]{rossbeamerposter}
%
% Available palettes:
%   lancet (default), nhs, oxford, nature, slate, evergreen,
%   nejm, charcoal, teal, cambridge
%
% Options:
%   palette=<name>   font=<fira|inter|sourcesans|libertinus|heros|georgia|system>
%   monofont=<name>  nobar  nologo
%   size=<a0|a1|custom>   customwidth=<dim>   customheight=<dim>
%
% Ross Dunne / Claude, 2026

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{rossbeamerposter}[2026/03/24 Beamer-based conference poster class]

% ----------------------------------------------------------------
% Option handling
% ----------------------------------------------------------------

\RequirePackage{pgfkeys}
\RequirePackage{pgfopts}

\newif\ifrb@nobar  \rb@nobartrue   % no progress bar on posters
\newif\ifrb@nologo \rb@nologofalse

\pgfkeys{
  /postbeamer/.cd,
  palette/.store in=\post@palette,       palette=lancet,
  font/.store in=\post@fontchoice,       font=fira,
  monofont/.store in=\post@mono,         monofont=,
  nobar/.code={\rb@nobartrue},
  nologo/.code={\rb@nologotrue},
  size/.store in=\post@size,             size=a0,
  customwidth/.store in=\post@cw,        customwidth=841mm,
  customheight/.store in=\post@ch,       customheight=1189mm,
}
\ProcessPgfOptions{/postbeamer}

% ----------------------------------------------------------------
% Paper size → geometry via beamerposter
% ----------------------------------------------------------------

\PassOptionsToClass{aspectratio=169}{beamer}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{beamer}}
\ProcessOptions\relax
\LoadClass{beamer}

% beamerposter handles the actual paper dimensions
\def\post@sz@a0{a0}\def\post@sz@a1{a1}\def\post@sz@custom{custom}
\ifx\post@size\post@sz@a1
  \RequirePackage[orientation=portrait,size=a1,scale=1.0]{beamerposter}
\else\ifx\post@size\post@sz@custom
  \RequirePackage[orientation=portrait,width=\post@cw,height=\post@ch,scale=1.0]{beamerposter}
\else
  % default: a0
  \RequirePackage[orientation=portrait,size=a0,scale=1.0]{beamerposter}
\fi\fi

% ----------------------------------------------------------------
% Load shared base
% ----------------------------------------------------------------

\RequirePackage{rossbeamerbase}

% ----------------------------------------------------------------
% Palette definitions (12-field format)
%
% \post@defpal{name}
%   {primary}{secondary}{accent}{text}{textlight}{textmuted}{bg}{rule}
%   {accentdark}{accentlight}{accentbg}{lightmuted}
% ----------------------------------------------------------------

\newcommand{\post@defpal}[9]{%
  \expandafter\def\csname post@p@#1@P\endcsname{#2}%   primary
  \expandafter\def\csname post@p@#1@S\endcsname{#3}%   secondary
  \expandafter\def\csname post@p@#1@A\endcsname{#4}%   accent
  \expandafter\def\csname post@p@#1@T\endcsname{#5}%   text
  \expandafter\def\csname post@p@#1@TL\endcsname{#6}%  textlight
  \expandafter\def\csname post@p@#1@TM\endcsname{#7}%  textmuted
  \expandafter\def\csname post@p@#1@B\endcsname{#8}%   bg
  \expandafter\def\csname post@p@#1@R\endcsname{#9}%   rule
  \post@defpal@cont{#1}%
}
\newcommand{\post@defpal@cont}[5]{%
  \expandafter\def\csname post@p@#1@AD\endcsname{#2}%  accentdark
  \expandafter\def\csname post@p@#1@AL\endcsname{#3}%  accentlight
  \expandafter\def\csname post@p@#1@AB\endcsname{#4}%  accentbg
  \expandafter\def\csname post@p@#1@LM\endcsname{#5}%  lightmuted
}

%                     name         P       S       A       T       TL      TM      B       R       AD      AL      AB      LM
\post@defpal{lancet}   {1A1A2E}{D4384F}{A4243B}{1C1C1C}{FFFFFF}{6A6A78}{F8F7F5}{D8D6D0}{7B1A2C}{D4384F}{FBF0F2}{B0B0BE}
\post@defpal{nhs}      {003087}{41B6E6}{005EB8}{1C1C1C}{FFFFFF}{5A6B7B}{F5F5F5}{D0D8E0}{003087}{41B6E6}{E8F1F8}{A0B4C8}
\post@defpal{oxford}   {002147}{1A3A60}{002147}{1C1C1C}{FFFFFF}{5A6878}{F6F7F9}{C8D0D8}{001530}{1A3A60}{E8EEF5}{8898B0}
\post@defpal{nature}   {15202B}{3498D8}{0072B2}{1C1C1C}{FFFFFF}{5A6878}{F6F8FA}{D0D8E0}{005080}{3498D8}{E8F2FA}{98B0C8}
\post@defpal{slate}    {1E2A38}{5A8AA8}{3B6B8A}{1C1C1C}{FFFFFF}{607080}{F5F7F9}{CDD5DD}{2A5070}{5A8AA8}{ECF2F6}{90A0B0}
\post@defpal{evergreen}{1A2E1A}{40916C}{2D6A4F}{1C1C1C}{FFFFFF}{5A6B5A}{F8FAF7}{C8D8CE}{1B4332}{40916C}{EDF5F0}{90B0A0}
\post@defpal{nejm}     {2A1520}{A83848}{8B2332}{1C1C1C}{FFFFFF}{706068}{FAF8F5}{DDD0D4}{6A1A26}{A83848}{F8EEF0}{B8A0A8}
\post@defpal{charcoal} {252525}{D95040}{C0392B}{1C1C1C}{FFFFFF}{787878}{F7F7F7}{D0D0D0}{962D22}{D95040}{FBEEED}{A0A0A0}
\post@defpal{teal}     {0A2E2E}{2AABAB}{008080}{1C1C1C}{FFFFFF}{587878}{F6FAFA}{C8DEDE}{005F5F}{2AABAB}{E6F5F5}{88B8B8}
\post@defpal{cambridge}{1A2930}{7AAFC5}{5B8FA8}{1C1C1C}{FFFFFF}{5A6E78}{F7F9FA}{CCD8E0}{3A6E88}{7AAFC5}{EBF3F7}{90B0C0}

% ----------------------------------------------------------------
% Palette activation
% ----------------------------------------------------------------

\newcommand{\post@activatepalette}{%
  \definecolor{rbPrimary}{HTML}{\csname post@p@\post@palette @P\endcsname}%
  \definecolor{rbSecondary}{HTML}{\csname post@p@\post@palette @S\endcsname}%
  \definecolor{rbAccent}{HTML}{\csname post@p@\post@palette @A\endcsname}%
  \definecolor{rbText}{HTML}{\csname post@p@\post@palette @T\endcsname}%
  \definecolor{rbTextLight}{HTML}{\csname post@p@\post@palette @TL\endcsname}%
  \definecolor{rbTextMuted}{HTML}{\csname post@p@\post@palette @TM\endcsname}%
  \definecolor{rbBg}{HTML}{\csname post@p@\post@palette @B\endcsname}%
  \definecolor{rbRule}{HTML}{\csname post@p@\post@palette @R\endcsname}%
  \rb@derivecolors
  \definecolor{rbAccentDark}{HTML}{\csname post@p@\post@palette @AD\endcsname}%
  \definecolor{rbAccentLight}{HTML}{\csname post@p@\post@palette @AL\endcsname}%
  \definecolor{rbAccentBg}{HTML}{\csname post@p@\post@palette @AB\endcsname}%
  \definecolor{rbLightMuted}{HTML}{\csname post@p@\post@palette @LM\endcsname}%
}
\post@activatepalette

\newcommand{\setpalette}[1]{\def\post@palette{#1}\post@activatepalette}

% ----------------------------------------------------------------
% Beamer setup — poster-specific
% ----------------------------------------------------------------

\rb@setupbeamer
\setbeamersize{text margin left=30mm, text margin right=30mm}

% Remove footline / headline entirely for posters
\setbeamertemplate{footline}{}
\setbeamertemplate{headline}{}
\setbeamertemplate{navigation symbols}{}

% Font activation
\rb@activatefont{\post@fontchoice}
\rb@activatemono{\post@mono}
\usefonttheme[onlymath]{serif}

% ----------------------------------------------------------------
% Poster-scale font sizes
% ----------------------------------------------------------------

\setbeamerfont{title}{size=\VeryHuge, series=\bfseries}
\setbeamerfont{subtitle}{size=\LARGE, series=\mdseries}
\setbeamerfont{author}{size=\Large}
\setbeamerfont{institute}{size=\large}
\setbeamerfont{date}{size=\large}
\setbeamerfont{frametitle}{size=\Huge, series=\bfseries}
\setbeamerfont{framesubtitle}{size=\Large, series=\mdseries}
\setbeamerfont{block title}{size=\Large, series=\bfseries}
\setbeamerfont{block body}{size=\large}
\setbeamerfont{caption}{size=\normalsize}
\setbeamerfont{caption name}{size=\normalsize}

% ================================================================
% POSTER-SPECIFIC FEATURES
% ================================================================

% ----------------------------------------------------------------
% posterheader environment
%
% Renders a full-width header band with title, authors,
% affiliations, and optional logos.
%
% Usage:
%   \begin{posterheader}
%     \postertitle{My Title}
%     \postersubtitle{Optional subtitle}
%     \posterauthor{Name}{Affiliation}{email}
%     \posterauthor{Name2}{Affiliation2}{email2}
%     \posterlogo[height=40mm]{logo.png}
%   \end{posterheader}
% ----------------------------------------------------------------

\def\post@headerlogos{}
\def\post@headerauthors{}
\newcommand{\post@addlogo}[2][height=35mm]{%
  \g@addto@macro\post@headerlogos{\hspace{10mm}\includegraphics[#1]{#2}}%
}
\newcommand{\post@addauthor}[3]{%
  \g@addto@macro\post@headerauthors{%
    \begin{minipage}[t]{0.28\textwidth}%
      {\large\bfseries\color{rbTextLight}#1}\par\vskip2pt%
      {\normalsize\color{rbLightMuted}#2}\par\vskip1pt%
      {\small\color{rbLightMuted}\texttt{#3}}%
    \end{minipage}\hfill%
  }%
}

\def\post@postertitle{}
\def\post@postersubtitle{}
\newcommand{\postertitle}[1]{\def\post@postertitle{#1}}
\newcommand{\postersubtitle}[1]{\def\post@postersubtitle{#1}}
\newcommand{\posterauthor}[3]{\post@addauthor{#1}{#2}{#3}}
\newcommand{\posterlogo}[2][height=35mm]{\post@addlogo[#1]{#2}}

\newenvironment{posterheader}{%
  % Reset accumulators
  \gdef\post@headerlogos{}%
  \gdef\post@headerauthors{}%
  \gdef\post@postertitle{}%
  \gdef\post@postersubtitle{}%
}{%
  % Render the header band
  \begin{tikzpicture}[remember picture, overlay]
    \fill[rbPrimary]
      (current page.north west) rectangle
      ([yshift=-160mm]current page.north east);
    \fill[rbAccent]
      ([yshift=-160mm]current page.north west) rectangle
      ([yshift=-163mm]current page.north east);
  \end{tikzpicture}%
  \vspace*{-20mm}%
  \begin{columns}[T]
    \begin{column}{0.72\textwidth}
      {\usebeamerfont{title}\color{rbTextLight}\post@postertitle\par}%
      \ifx\post@postersubtitle\empty\else
        \vskip8pt{\usebeamerfont{subtitle}\color{rbLightMuted}\post@postersubtitle\par}%
      \fi
      \vskip16pt%
      \post@headerauthors
    \end{column}
    \begin{column}{0.25\textwidth}
      \raggedleft
      \post@headerlogos
    \end{column}
  \end{columns}
  \vskip30mm%
}

% ----------------------------------------------------------------
% postercolumn environment
%
% Wraps beamer columns for multi-column poster layouts.
%
% Usage:
%   \begin{postercolumn}{3}
%     \column{0.32\textwidth}
%       ... content ...
%     \column{0.32\textwidth}
%       ... content ...
%     \column{0.32\textwidth}
%       ... content ...
%   \end{postercolumn}
% ----------------------------------------------------------------

\newenvironment{postercolumn}[1][3]{%
  \vskip10mm%
  \begin{columns}[T]%
}{%
  \end{columns}%
  \vskip10mm%
}

% ----------------------------------------------------------------
% \posterbox{title}{content}
%
% A styled content block with a coloured header bar.
% ----------------------------------------------------------------

\newtcolorbox{post@boxinner}[1]{%
  enhanced,
  colback=white,
  colframe=rbRule,
  boxrule=0.8pt,
  arc=3pt,
  sharp corners=south,
  top=8pt, bottom=8pt, left=10pt, right=10pt,
  fonttitle=\Large\bfseries\color{rbTextLight},
  coltitle=rbTextLight,
  colbacktitle=rbPrimary,
  title={#1},
  toptitle=6pt, bottomtitle=6pt,
  lefttitle=10pt, righttitle=10pt,
  attach boxed title to top left={yshift=0mm},
  boxed title style={
    colback=rbPrimary,
    sharp corners,
    boxrule=0pt,
    arc=3pt,
    sharp corners=south,
  },
}

\newcommand{\posterbox}[2]{%
  \vskip6mm%
  \begin{post@boxinner}{#1}%
    \large #2%
  \end{post@boxinner}%
  \vskip6mm%
}

% ----------------------------------------------------------------
% \posterfigure[width]{image}{caption}
%
% Poster-scale figure with styled caption.
% ----------------------------------------------------------------

\newcommand{\posterfigure}[3][0.95\linewidth]{%
  \vskip4mm%
  \begin{center}
    \includegraphics[width=#1]{#2}\par\vskip4pt%
    {\normalsize\color{rbTextMuted}#3\par}%
  \end{center}%
  \vskip4mm%
}

% ----------------------------------------------------------------
% \postertable — alias for poster-scale table
%
% Usage:
%   \begin{postertable}{title}{lcc}
%     ... & ... & ... \\
%   \end{postertable}
% ----------------------------------------------------------------

\newenvironment{postertable}[2]{%
  \vskip4mm%
  \begin{center}%
    {\Large\bfseries\color{rbPrimary}#1\par}\vskip4pt%
    \large%
    \begin{tabular}{#2}%
    \toprule
}{%
    \bottomrule
    \end{tabular}%
  \end{center}%
  \vskip4mm%
}

% ----------------------------------------------------------------
% \posterqr{url}{label}
%
% QR code in a styled box with a label beneath.
% ----------------------------------------------------------------

\newcommand{\posterqr}[2]{%
  \begin{center}
    \begin{tcolorbox}[
      enhanced,
      colback=white,
      colframe=rbRule,
      boxrule=0.6pt,
      arc=3pt,
      width=60mm,
      halign=center,
      top=6pt, bottom=6pt, left=6pt, right=6pt,
    ]%
      \centering
      \qrcode[height=40mm]{#1}\par\vskip6pt%
      {\normalsize\color{rbTextMuted}#2\par}%
    \end{tcolorbox}%
  \end{center}%
}

% ----------------------------------------------------------------
% \posterreferences
%
% Compact bibliography section for posters — small font,
% tight spacing, no numbering clutter.
%
% Usage:
%   \posterreferences  (prints the bibliography)
% ----------------------------------------------------------------

\newcommand{\posterreferences}{%
  \vskip6mm%
  {\color{rbRule}\hrule height 0.6pt}\vskip6mm%
  {\Large\bfseries\color{rbPrimary}References\par}\vskip4mm%
  \begingroup
    \small
    \setlength\bibitemsep{3pt}%
    \setlength\biblabelsep{4pt}%
    \renewcommand*{\bibfont}{\small}%
    \printbibliography[heading=none]%
  \endgroup
}

% ----------------------------------------------------------------
% Biblatex integration (poster defaults)
% ----------------------------------------------------------------

\RequirePackage[
  backend=biber,
  style=numeric-comp,
  sorting=none,
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

% ----------------------------------------------------------------
% Poster-specific beamer block override
%
% Blocks on posters use larger fonts and more padding.
% ----------------------------------------------------------------

\setbeamertemplate{block begin}{%
  \vskip6mm%
  \begin{tcolorbox}[
    enhanced,
    colback=white,
    colframe=rbRule,
    boxrule=0.8pt,
    arc=3pt,
    top=8pt, bottom=8pt, left=10pt, right=10pt,
    fonttitle=\Large\bfseries\color{rbTextLight},
    coltitle=rbTextLight,
    colbacktitle=rbPrimary,
    title={\insertblocktitle},
    toptitle=6pt, bottomtitle=6pt,
  ]%
  \large%
}
\setbeamertemplate{block end}{%
  \end{tcolorbox}%
  \vskip6mm%
}

\setbeamertemplate{block alerted begin}{%
  \vskip6mm%
  \begin{tcolorbox}[
    enhanced,
    colback=rbAccentBg,
    colframe=rbAccent,
    boxrule=0.8pt,
    arc=3pt,
    top=8pt, bottom=8pt, left=10pt, right=10pt,
    fonttitle=\Large\bfseries\color{rbTextLight},
    coltitle=rbTextLight,
    colbacktitle=rbAccent,
    title={\insertblocktitle},
    toptitle=6pt, bottomtitle=6pt,
  ]%
  \large%
}
\setbeamertemplate{block alerted end}{%
  \end{tcolorbox}%
  \vskip6mm%
}

% ----------------------------------------------------------------
% Statistical formatting helpers (inherited from scientific)
% ----------------------------------------------------------------

\newcommand{\pval}[1]{%
  \textit{p}~\ifdim #1pt<0.001pt <~.001\else =~#1\fi
}
\newcommand{\ci}[3]{#1~[#2,~#3]}
\newcommand{\CI}[4]{#2,~#1\%~CI~[#3,~#4]}
\newcommand{\effectsize}[2]{\textit{#1}~=~#2}

% ----------------------------------------------------------------
% APA-style notes for poster figures/tables
% ----------------------------------------------------------------

\newcommand{\figurenote}[1]{%
  \par\vskip4pt{\normalsize\color{rbText}\textit{Note.}~#1\par}%
}
\newcommand{\tablenote}[1]{%
  \par\vskip4pt{\normalsize\color{rbText}\textit{Note.}~#1\par}%
}
\newcommand{\sigmarkers}{%
  \par\vskip2pt{\normalsize\color{rbTextMuted}%
    *\,\textit{p}~<~.05.\quad **\,\textit{p}~<~.01.\quad ***\,\textit{p}~<~.001.\par}%
}

% ----------------------------------------------------------------
% Poster footer band
%
% Optional coloured band at the bottom of the poster.
% Usage: \posterfooter{Left text}{Centre text}{Right text}
% ----------------------------------------------------------------

\newcommand{\posterfooter}[3]{%
  \vfill
  \begin{tikzpicture}[remember picture, overlay]
    \fill[rbPrimary]
      (current page.south west) rectangle
      ([yshift=25mm]current page.south east);
  \end{tikzpicture}%
  \vspace*{-15mm}%
  \begin{columns}[c]
    \begin{column}{0.3\textwidth}
      {\normalsize\color{rbTextLight}#1}%
    \end{column}
    \begin{column}{0.35\textwidth}
      \centering{\normalsize\color{rbTextLight}#2}%
    \end{column}
    \begin{column}{0.3\textwidth}
      \raggedleft{\normalsize\color{rbTextLight}#3}%
    \end{column}
  \end{columns}%
}

% ----------------------------------------------------------------
\endinput
