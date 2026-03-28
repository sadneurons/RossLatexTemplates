% rossposter.cls
% Conference poster class based on tikzposter — large-format A0/A1
% posters with rosspalette colour theming, styled blocks, and
% convenience macros for figures, QR codes, and references.
%
% This is distinct from rossbeamerposter.cls (which uses beamer).
%
% Usage:
%   \documentclass[palette=lancet,size=a0]{rossposter}
%
% Available palettes: all rosspalettes palettes (lancet, nhs, oxford,
%   nature, slate, evergreen, nejm, charcoal, teal, cambridge, etc.)
%
% Options:
%   palette=<name>   (default: lancet)
%   size=<a0|a1>     (default: a0)
%
% Ross Dunne / Claude, 2026

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{rossposter}[2026/03/24 Conference poster class (tikzposter)]

% ----------------------------------------------------------------
% Option handling
% ----------------------------------------------------------------

\RequirePackage{pgfkeys}
\RequirePackage{pgfopts}

\pgfkeys{
  /rossposter/.cd,
  palette/.store in=\rpost@palette,   palette=lancet,
  size/.store in=\rpost@size,         size=a0,
}
\ProcessPgfOptions{/rossposter}

% ----------------------------------------------------------------
% Paper size resolution and class loading
% ----------------------------------------------------------------

\def\rpost@sz@a1{a1}

\ifx\rpost@size\rpost@sz@a1
  \PassOptionsToClass{a1paper,25pt}{tikzposter}
\else
  \PassOptionsToClass{a0paper,25pt}{tikzposter}
\fi

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{tikzposter}}
\ProcessOptions\relax
\LoadClass{tikzposter}

% ----------------------------------------------------------------
% Dependencies
% ----------------------------------------------------------------

\RequirePackage[palette=\rpost@palette]{rosspalettes}
\RequirePackage{rossfigures}
\RequirePackage{qrcode}
\RequirePackage{graphicx}
\RequirePackage{etoolbox}
\RequirePackage{tikz}
\RequirePackage[
  backend=biber,
  style=numeric-comp,
  sorting=none,
  maxbibnames=3, minbibnames=1,
  maxcitenames=2, mincitenames=1,
  giveninits=true,
  doi=false, isbn=false, url=false, eprint=false,
]{biblatex}

% ----------------------------------------------------------------
% Palette-driven colour aliases for tikzposter elements
%
% rosspalettes provides: rpPrimary, rpSecondary, rpAccent, rpText,
%   rpTextLight, rpTextMuted, rpBg, rpPrimaryLight, rpPrimaryFaded,
%   rpAccentBg, rpAccentLight, rpRule
% ----------------------------------------------------------------

\colorlet{rpostTitleBg}{rpPrimary}
\colorlet{rpostTitleFg}{rpTextLight}
\colorlet{rpostBlockBg}{white}
\colorlet{rpostBlockTitleBg}{rpPrimary}
\colorlet{rpostBlockTitleFg}{rpTextLight}
\colorlet{rpostBlockBorder}{rpPrimary}
\colorlet{rpostNoteBg}{rpAccentBg}
\colorlet{rpostNoteFg}{rpText}
\colorlet{rpostNoteBorder}{rpAccent}
\colorlet{rpostInnerBg}{rpBg}
\colorlet{rpostInnerFg}{rpText}
\colorlet{rpostFrameBg}{rpBg}

% ----------------------------------------------------------------
% tikzposter background style
% ----------------------------------------------------------------

\definebackgroundstyle{RossBackground}{%
  \draw[line width=0pt, color=rpostFrameBg, fill=rpostFrameBg]
    (bottomleft) rectangle (topright);
}

% ----------------------------------------------------------------
% tikzposter title style
%
% Full-width band with rpPrimary background and white text.
% ----------------------------------------------------------------

\definetitlestyle{RossTitle}{
  width=\paperwidth,
  roundedcorners=0,
  linewidth=0pt,
  innersep=20mm,
  titletotopverticalspace=0mm,
  titletoblockverticalspace=30mm,
}{%
  \begin{scope}[line width=0pt]
    \draw[color=rpostTitleBg, fill=rpostTitleBg]
      (\titleposleft, \titleposbottom)
      rectangle
      (\titleposright, \titlepostop);
    % Accent rule along the bottom edge
    \draw[color=rpAccent, line width=3pt]
      (\titleposleft, \titleposbottom)
      -- (\titleposright, \titleposbottom);
  \end{scope}
}

% ----------------------------------------------------------------
% tikzposter block style — coloured left border, white body
%
% Mimics the "card" aesthetic from the beamer classes:
% a coloured bar on the left edge, rpPrimary title bar on top,
% and white body.
% ----------------------------------------------------------------

\defineblockstyle{RossBlock}{
  titlewidthscale=1,
  bodywidthscale=1,
  titlecenter,
  titleoffsetx=0pt,
  titleoffsety=0pt,
  bodyoffsetx=0pt,
  bodyoffsety=0pt,
  bodyverticalshift=0pt,
  roundedcorners=8,
  linewidth=2pt,
  titleinnersep=12mm,
  bodyinnersep=12mm,
}{%
  % Block body: white background, thin border, thick left accent
  \draw[
    color=rpRule,
    fill=rpostBlockBg,
    line width=\blocklinewidth,
    rounded corners=\blockroundedcorners,
  ]
    (blockbody.south west)
    rectangle
    (blocktitle.north east);
  % Coloured left border (the "card" bar)
  \fill[rpostBlockBorder, rounded corners=\blockroundedcorners]
    (blocktitle.north west)
    rectangle
    ([xshift=5pt]blockbody.south west);
  % Title bar fill
  \fill[
    rpostBlockTitleBg,
    rounded corners=\blockroundedcorners,
  ]
    (blocktitle.south west)
    rectangle
    (blocktitle.north east);
  % Re-draw left accent over title area corner
  \fill[rpostBlockBorder]
    (blocktitle.north west)
    rectangle
    ([xshift=5pt]blocktitle.south west);
}

% ----------------------------------------------------------------
% tikzposter inner-block style
% ----------------------------------------------------------------

\defineinnerblockstyle{RossInnerBlock}{
  titlewidthscale=1,
  bodywidthscale=1,
  roundedcorners=6,
  linewidth=1pt,
  titleinnersep=8mm,
  bodyinnersep=8mm,
}{%
  \draw[
    color=rpRule,
    fill=rpostInnerBg,
    line width=\innerblocklinewidth,
    rounded corners=\innerblockroundedcorners,
  ]
    (innerblockbody.south west)
    rectangle
    (innerblocktitle.north east);
  \draw[
    color=rpPrimaryLight,
    fill=rpPrimaryLight,
    rounded corners=\innerblockroundedcorners,
  ]
    (innerblocktitle.south west)
    rectangle
    (innerblocktitle.north east);
}

% ----------------------------------------------------------------
% tikzposter note style
% ----------------------------------------------------------------

\definenotestyle{RossNote}{
  targetoffsetx=0pt,
  targetoffsety=0pt,
  angle=90,
  radius=8cm,
  width=20cm,
  connection=false,
  rotate=0,
  roundedcorners=6,
  linewidth=1pt,
  innersep=8mm,
}{%
  \draw[
    color=rpostNoteBorder,
    fill=rpostNoteBg,
    line width=\notelinewidth,
    rounded corners=\noteroundedcorners,
  ]
    (notefooter.south west)
    rectangle
    (notetitle.north east);
}

% ----------------------------------------------------------------
% tikzposter colour style — ties everything together
% ----------------------------------------------------------------

\definecolorstyle{RossColors}{
  % Palette passed to tikzposter
  \definecolor{colorOne}{named}{rpPrimary}
  \definecolor{colorTwo}{named}{rpSecondary}
  \definecolor{colorThree}{named}{rpAccent}
}{
  % Background
  \colorlet{backgroundcolor}{rpostFrameBg}
  \colorlet{framecolor}{rpostFrameBg}
  % Title
  \colorlet{titlefgcolor}{rpostTitleFg}
  \colorlet{titlebgcolor}{rpostTitleBg}
  % Block
  \colorlet{blocktitlebgcolor}{rpostBlockTitleBg}
  \colorlet{blocktitlefgcolor}{rpostBlockTitleFg}
  \colorlet{blockbodybgcolor}{rpostBlockBg}
  \colorlet{blockbodyfgcolor}{rpText}
  % Inner block
  \colorlet{innerblocktitlebgcolor}{rpPrimaryLight}
  \colorlet{innerblocktitlefgcolor}{rpPrimary}
  \colorlet{innerblockbodybgcolor}{rpostInnerBg}
  \colorlet{innerblockbodyfgcolor}{rpText}
  % Note
  \colorlet{notefgcolor}{rpostNoteFg}
  \colorlet{notebgcolor}{rpostNoteBg}
  \colorlet{notefrcolor}{rpostNoteBorder}
}

% ----------------------------------------------------------------
% Combine into a tikzposter theme and apply
% ----------------------------------------------------------------

\definelayouttheme{RossTheme}{
  \usecolorstyle{RossColors}
  \usebackgroundstyle{RossBackground}
  \usetitlestyle{RossTitle}
  \useblockstyle{RossBlock}
  \useinnerblockstyle{RossInnerBlock}
  \usenotestyle{RossNote}
}

\usetheme{RossTheme}

% ----------------------------------------------------------------
% Global text colour
% ----------------------------------------------------------------

\AtBeginDocument{%
  \color{rpText}%
}

% ----------------------------------------------------------------
% \posterauthor{name}{affiliation}{email}
%
% Accumulates author entries for use in \maketitle or \postertitle.
% Call once per author before \maketitle.
% ----------------------------------------------------------------

\def\rpost@authorlist{}

\newcommand{\posterauthor}[3]{%
  \g@addto@macro\rpost@authorlist{%
    \textbf{#1}\enspace{\small #2}\enspace{\small\texttt{#3}}%
    \quad
  }%
}

% Inject accumulated authors into tikzposter's author field
\newcommand{\rpost@commitauthors}{%
  \author{\rpost@authorlist}%
}

% ----------------------------------------------------------------
% \postertitle{title}
%
% Convenience wrapper: sets \title and calls \maketitle.
% Alternatively, users can set \title{} and \author{} directly
% and call \maketitle themselves.
% ----------------------------------------------------------------

\newcommand{\postertitle}[1]{%
  \title{#1}%
  \rpost@commitauthors
  \maketitle
}

% ----------------------------------------------------------------
% \posterblock{title}{content}
%
% Convenience wrapper around tikzposter's \block.
% ----------------------------------------------------------------

\newcommand{\posterblock}[2]{%
  \block{#1}{#2}%
}

% ----------------------------------------------------------------
% \posterfigure[width]{image}{caption}
%
% Figure with image and caption inside a poster block context.
% Width defaults to 0.9\linewidth.
% ----------------------------------------------------------------

\renewcommand{\posterfigure}[3][0.9\linewidth]{%
  \begin{tikzfigure}[#3]%
    \includegraphics[width=#1]{#2}%
  \end{tikzfigure}%
}

% ----------------------------------------------------------------
% \posterqr{url}{label}
%
% QR code in a styled box with a caption beneath.
% ----------------------------------------------------------------

\newcommand{\posterqr}[2]{%
  \begin{tikzpicture}
    \node[
      draw=rpRule,
      fill=white,
      line width=1pt,
      rounded corners=6pt,
      inner sep=10mm,
    ] (qrbox) {%
      \begin{minipage}{50mm}%
        \centering
        \qrcode[height=40mm]{#1}\par
        \vskip6pt
        {\small\color{rpTextMuted}#2\par}%
      \end{minipage}%
    };
  \end{tikzpicture}%
}

% ----------------------------------------------------------------
% \posterreferences
%
% Compact bibliography section — small font, tight spacing.
% Placed inside an \innerblock for visual separation.
% ----------------------------------------------------------------

\newcommand{\posterreferences}{%
  \block{References}{%
    \begingroup
      \small
      \setlength\bibitemsep{3pt}%
      \setlength\biblabelsep{4pt}%
      \renewcommand*{\bibfont}{\small}%
      \printbibliography[heading=none]%
    \endgroup
  }%
}

% ----------------------------------------------------------------
% Bibliography label styling
% ----------------------------------------------------------------

\DeclareFieldFormat{labelnumberwidth}{\mkbibbold{\color{rpAccent}#1}}

% ----------------------------------------------------------------
% Column configuration helpers
%
% tikzposter uses \columns{N} and \column{} natively.
% We provide thin wrappers for consistency with rossbeamerposter.
% ----------------------------------------------------------------

\newcommand{\postercolumns}[1]{%
  \begin{columns}%
  \column{#1}%
}

\newcommand{\nextpostercolumn}[1]{%
  \column{#1}%
}

\newcommand{\endpostercolumns}{%
  \end{columns}%
}

% ----------------------------------------------------------------
% \posterfooter{left}{centre}{right}
%
% A full-width coloured band at the bottom of the poster.
% Must be called after all blocks/columns.
% ----------------------------------------------------------------

\newcommand{\posterfooter}[3]{%
  \block[bodyoffsety=-5mm,bodyinnersep=10mm]{}{%
    \begin{minipage}[c]{0.3\linewidth}%
      \raggedright\color{rpTextMuted}#1%
    \end{minipage}%
    \hfill
    \begin{minipage}[c]{0.35\linewidth}%
      \centering\color{rpTextMuted}#2%
    \end{minipage}%
    \hfill
    \begin{minipage}[c]{0.3\linewidth}%
      \raggedleft\color{rpTextMuted}#3%
    \end{minipage}%
  }%
}

% ----------------------------------------------------------------
% Statistical formatting helpers (consistent with rossbeamerposter)
% ----------------------------------------------------------------

\newcommand{\pval}[1]{%
  \textit{p}~\ifdim #1pt<0.001pt <~.001\else =~#1\fi
}
\newcommand{\ci}[3]{#1~[#2,~#3]}
\newcommand{\CI}[4]{#2,~#1\%~CI~[#3,~#4]}
\newcommand{\effectsize}[2]{\textit{#1}~=~#2}

% ----------------------------------------------------------------
% APA-style notes (consistent with rossbeamerposter)
% ----------------------------------------------------------------

\providecommand{\figurenote}[1]{%
  \par\vskip4pt{\small\color{rpTextMuted}\textit{Note.}~#1\par}%
}
\providecommand{\tablenote}[1]{%
  \par\vskip4pt{\small\color{rpTextMuted}\textit{Note.}~#1\par}%
}
\newcommand{\sigmarkers}{%
  \par\vskip2pt{\small\color{rpTextMuted}%
    *\,\textit{p}~<~.05.\quad **\,\textit{p}~<~.01.\quad ***\,\textit{p}~<~.001.\par}%
}

% ----------------------------------------------------------------
\endinput
