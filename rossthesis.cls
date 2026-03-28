% rossthesis.cls
% PhD thesis class built on report, with palette theming, structured
% frontmatter, chapter styling, and bibliography support.
%
% Usage:
%   \documentclass[palette=oxford,font=libertinus]{rossthesis}
%
% Options:
%   palette   — any rosspalettes palette name (default: oxford)
%   font      — libertinus | times | palatino | default (default: libertinus)
%   draft     — boolean, activates draft mode
%   bibstyle  — numeric | authoryear (default: authoryear)
%
% Ross Dunne / Claude, 2026

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{rossthesis}[2026/03/24 PhD thesis class]

% ================================================================
%  Dependencies for option handling
% ================================================================

\RequirePackage{pgfkeys}
\RequirePackage{pgfopts}
\RequirePackage{etoolbox}

% ================================================================
%  Class options via pgfkeys
% ================================================================

\newif\ifrt@draft
\rt@draftfalse

\pgfkeys{
  /rossthesis/.cd,
  palette/.store in  = \rt@palette,
  palette            = oxford,
  font/.store in     = \rt@font,
  font               = libertinus,
  draft/.is if       = rt@draft,
  draft              = false,
  bibstyle/.store in = \rt@bibstyle,
  bibstyle           = authoryear,
}
\ProcessPgfOptions{/rossthesis}

% ================================================================
%  Base class
% ================================================================

\ifrt@draft
  \PassOptionsToClass{draft}{report}
\fi
\LoadClass[12pt,a4paper,twoside]{report}

% ================================================================
%  Core packages (palettes, tables, figures)
% ================================================================

\RequirePackage[palette=\rt@palette]{rosspalettes}
\RequirePackage{rosstables}
\RequirePackage{rossfigures}

% ================================================================
%  Page geometry
% ================================================================

\RequirePackage[
  inner  = 35mm,
  outer  = 25mm,
  top    = 25mm,
  bottom = 30mm,
  headheight = 14pt,
  headsep    = 12mm,
]{geometry}

% ================================================================
%  Typography
% ================================================================

\RequirePackage{setspace}
\onehalfspacing

\RequirePackage[
  activate={true,nocompatibility},
  final,
  tracking  = true,
  factor    = 1100,
  stretch   = 10,
  shrink    = 10,
]{microtype}

% ---- Font selection ----
\RequirePackage{ifthen}

\ifthenelse{\equal{\rt@font}{libertinus}}{%
  \RequirePackage{libertinus-type1}%
  \RequirePackage[T1]{fontenc}%
  \RequirePackage{libertinust1math}%
}{}

\ifthenelse{\equal{\rt@font}{times}}{%
  \RequirePackage[T1]{fontenc}%
  \RequirePackage{mathptmx}%
}{}

\ifthenelse{\equal{\rt@font}{palatino}}{%
  \RequirePackage[T1]{fontenc}%
  \RequirePackage{mathpazo}%
  \linespread{1.05}%  Palatino benefits from wider leading
}{}

% default = Computer Modern — no extra packages needed

% ================================================================
%  Colours (derived from loaded palette)
% ================================================================

\colorlet{thesisChapter}{rpPrimary}
\colorlet{thesisAccent}{rpAccent}
\colorlet{thesisText}{rpText}
\colorlet{thesisTextLight}{rpTextLight}
\colorlet{thesisTextMuted}{rpTextMuted}
\colorlet{thesisLink}{rpAccent}

% ================================================================
%  Header / footer via fancyhdr
% ================================================================

\RequirePackage{fancyhdr}

\fancypagestyle{thesis}{%
  \fancyhf{}%
  \fancyhead[LE]{\small\color{thesisTextMuted}\nouppercase{\leftmark}}%
  \fancyhead[RO]{\small\color{thesisTextMuted}\nouppercase{\rightmark}}%
  \fancyfoot[C]{\small\color{thesisTextMuted}\thepage}%
  \renewcommand{\headrulewidth}{0.4pt}%
  \renewcommand{\footrulewidth}{0pt}%
  \renewcommand{\headrule}{%
    {\color{thesisAccent}\hrule width\headwidth height\headrulewidth\vskip-\headrulewidth}}%
}

\fancypagestyle{plain}{%
  \fancyhf{}%
  \fancyfoot[C]{\small\color{thesisTextMuted}\thepage}%
  \renewcommand{\headrulewidth}{0pt}%
  \renewcommand{\footrulewidth}{0pt}%
}

\pagestyle{thesis}

% ================================================================
%  Chapter styling
% ================================================================

\RequirePackage{titlesec}
\RequirePackage{tikz}

% --- Chapter format ---
\titleformat{\chapter}[display]
  {\normalfont\Huge\bfseries}                       % format
  {%                                                  % label
    \begin{tikzpicture}[remember picture, overlay]
      \node[anchor=south east,
            font=\fontsize{72}{80}\selectfont\bfseries,
            text=thesisChapter!20]
        at ([xshift=-1cm, yshift=-1cm]current page.north east)
        {\thechapter};
    \end{tikzpicture}%
  }
  {0pt}                                              % sep
  {%                                                  % before-code
    \color{thesisChapter}%
    \vspace{-1.5ex}%
  }
  [%                                                  % after-code
    \vspace{0.5ex}%
    {\color{thesisAccent}\titlerule[1.5pt]}%
  ]

% --- Section and subsection ---
\titleformat{\section}
  {\normalfont\Large\bfseries\color{thesisChapter}}
  {\thesection}{1em}{}

\titleformat{\subsection}
  {\normalfont\large\bfseries\color{thesisChapter!80}}
  {\thesubsection}{1em}{}

\titleformat{\subsubsection}
  {\normalfont\normalsize\bfseries\color{thesisChapter!60}}
  {\thesubsubsection}{1em}{}

% --- Spacing ---
\titlespacing*{\chapter}{0pt}{0pt}{30pt}
\titlespacing*{\section}{0pt}{18pt plus 4pt minus 2pt}{6pt plus 2pt}
\titlespacing*{\subsection}{0pt}{14pt plus 3pt minus 2pt}{4pt plus 2pt}
\titlespacing*{\subsubsection}{0pt}{10pt plus 2pt minus 2pt}{3pt plus 1pt}

% ================================================================
%  Epigraph command
% ================================================================

\newcommand{\epigraph}[2]{%
  \vspace{1em}%
  \begin{flushright}
    \begin{minipage}{0.72\textwidth}
      \small\itshape ``#1''%
      \par\vspace{0.4em}%
      \normalfont\small\color{thesisTextMuted}--- #2%
    \end{minipage}
  \end{flushright}%
  \vspace{1em}%
}

% ================================================================
%  Frontmatter infrastructure
% ================================================================

% Store thesis metadata
\newcommand{\thesistitle}[1]{\gdef\rt@thesistitle{#1}}
\newcommand{\thesisauthor}[1]{\gdef\rt@thesisauthor{#1}}
\newcommand{\thesisdegree}[1]{\gdef\rt@thesisdegree{#1}}
\newcommand{\thesisuniversity}[1]{\gdef\rt@thesisuniversity{#1}}
\newcommand{\thesisdepartment}[1]{\gdef\rt@thesisdepartment{#1}}
\newcommand{\thesisyear}[1]{\gdef\rt@thesisyear{#1}}
\newcommand{\thesissupervisor}[1]{\gdef\rt@thesissupervisor{#1}}

% Defaults
\gdef\rt@thesistitle{Thesis Title}
\gdef\rt@thesisauthor{Author Name}
\gdef\rt@thesisdegree{Doctor of Philosophy}
\gdef\rt@thesisuniversity{University Name}
\gdef\rt@thesisdepartment{Department Name}
\gdef\rt@thesisyear{\the\year}
\gdef\rt@thesissupervisor{}

% ================================================================
%  Title page
% ================================================================

\renewcommand{\maketitle}{%
  \begin{titlepage}
    \centering
    \vspace*{2cm}
    {\color{thesisAccent}\rule{\textwidth}{1.5pt}}\\[1.5cm]
    {\fontsize{28}{34}\selectfont\bfseries\color{thesisChapter}\rt@thesistitle\par}
    \vspace{1.5cm}
    {\color{thesisAccent}\rule{0.5\textwidth}{0.75pt}}\\[1.5cm]
    {\Large\rt@thesisauthor\par}
    \vspace{1cm}
    {\large A thesis submitted for the degree of\\[0.3em]
     \textit{\rt@thesisdegree}\par}
    \vspace{1.5cm}
    {\large\rt@thesisdepartment\\[0.3em]
     \rt@thesisuniversity\par}
    \vfill
    {\large\rt@thesisyear\par}
    \vspace{0.5cm}
    {\color{thesisAccent}\rule{\textwidth}{1.5pt}}
  \end{titlepage}
  \cleardoublepage
}

% ================================================================
%  Declaration of originality
% ================================================================

\newcommand{\declaration}{%
  \chapter*{Declaration of Originality}
  \addcontentsline{toc}{chapter}{Declaration of Originality}
  \thispagestyle{plain}
  I hereby declare that this thesis is entirely my own work and that
  it has not been submitted, in whole or in part, for any other degree
  or diploma at this or any other institution.  Where I have consulted
  the published work of others, this is always clearly attributed.
  Where I have quoted from the work of others, the source is always
  given.  With the exception of such quotations, this thesis is
  entirely my own work.  I have acknowledged all main sources of help.

  \vspace{3cm}
  \noindent
  \begin{tabular}{@{}ll@{}}
    Signed:  & \makebox[6cm]{\hrulefill} \\[1.5em]
    Date:    & \makebox[6cm]{\hrulefill} \\[1.5em]
    Name:    & \rt@thesisauthor \\
  \end{tabular}
  \cleardoublepage
}

% ================================================================
%  Abstract
% ================================================================

\newcommand{\thesisabstract}[1]{%
  \chapter*{Abstract}
  \addcontentsline{toc}{chapter}{Abstract}
  \thispagestyle{plain}
  #1
  \cleardoublepage
}

% ================================================================
%  Acknowledgements
% ================================================================

\newcommand{\acknowledgements}[1]{%
  \chapter*{Acknowledgements}
  \addcontentsline{toc}{chapter}{Acknowledgements}
  \thispagestyle{plain}
  #1
  \cleardoublepage
}

% ================================================================
%  Dedication
% ================================================================

\newcommand{\dedication}[1]{%
  \thispagestyle{empty}
  \vspace*{\fill}
  \begin{center}
    \large\itshape #1
  \end{center}
  \vspace*{\fill}
  \cleardoublepage
}

% ================================================================
%  Abbreviations environment
% ================================================================

\RequirePackage{longtable}

\newcommand{\abbrev}[2]{%
  \textbf{#1} & #2 \\
}

\newenvironment{abbreviations}{%
  \chapter*{List of Abbreviations}
  \addcontentsline{toc}{chapter}{List of Abbreviations}
  \thispagestyle{plain}
  \begin{longtable}{@{}l@{\hspace{2em}}l@{}}
}{%
  \end{longtable}
  \cleardoublepage
}

% ================================================================
%  Automatic lists (TOC, LOF, LOT)
% ================================================================

\RequirePackage{tocloft}

% TOC styling
\renewcommand{\cftchapfont}{\bfseries\color{thesisChapter}}
\renewcommand{\cftchappagefont}{\bfseries\color{thesisChapter}}
\renewcommand{\cftsecfont}{\color{thesisText}}
\renewcommand{\cftsecpagefont}{\color{thesisText}}
\renewcommand{\cftsubsecfont}{\color{thesisTextMuted}}
\renewcommand{\cftsubsecpagefont}{\color{thesisTextMuted}}

% Dot leaders
\renewcommand{\cftchapleader}{\cftdotfill{\cftdotsep}}

\newcommand{\makefrontlists}{%
  {%
    \singlespacing
    \tableofcontents
    \cleardoublepage
    \listoffigures
    \addcontentsline{toc}{chapter}{\listfigurename}
    \cleardoublepage
    \listoftables
    \addcontentsline{toc}{chapter}{\listtablename}
    \cleardoublepage
  }%
}

% ================================================================
%  Frontmatter / mainmatter / backmatter
% ================================================================

\newcommand{\frontmatter}{%
  \cleardoublepage
  \pagenumbering{roman}%
}

\newcommand{\mainmatter}{%
  \cleardoublepage
  \pagenumbering{arabic}%
}

\newcommand{\backmatter}{%
  \cleardoublepage
}

% ================================================================
%  Appendix chapter command
% ================================================================

\newcommand{\appendixchapter}{%
  \appendix
  % Reformat chapter title for appendices
  \titleformat{\chapter}[display]
    {\normalfont\Huge\bfseries}
    {%
      \begin{tikzpicture}[remember picture, overlay]
        \node[anchor=south east,
              font=\fontsize{72}{80}\selectfont\bfseries,
              text=thesisAccent!20]
          at ([xshift=-1cm, yshift=-1cm]current page.north east)
          {\thechapter};
      \end{tikzpicture}%
    }
    {0pt}
    {\color{thesisAccent}\vspace{-1.5ex}}
    [\vspace{0.5ex}{\color{thesisAccent}\titlerule[1.5pt]}]
}

% ================================================================
%  Bibliography via biblatex
% ================================================================

\RequirePackage{csquotes}  % recommended by biblatex

\ifthenelse{\equal{\rt@bibstyle}{numeric}}{%
  \RequirePackage[
    backend    = biber,
    style      = numeric-comp,
    sorting    = nyt,
    maxnames   = 6,
    minnames   = 3,
    giveninits = true,
    uniquename = init,
    doi        = true,
    isbn       = false,
    url        = false,
    eprint     = false,
  ]{biblatex}%
}{%
  \RequirePackage[
    backend    = biber,
    style      = authoryear-comp,
    sorting    = nyt,
    maxcitenames = 2,
    maxbibnames  = 99,
    minnames   = 1,
    giveninits = true,
    uniquename = init,
    uniquelist = false,
    dashed     = false,
    doi        = true,
    isbn       = false,
    url        = false,
    eprint     = false,
  ]{biblatex}%
}

% Print bibliography helper
\newcommand{\thesisbibliography}[1][References]{%
  \cleardoublepage
  \phantomsection
  \addcontentsline{toc}{chapter}{#1}%
  {%
    \singlespacing
    \printbibliography[title={#1}]%
  }%
}

% ================================================================
%  Hyperref (loaded late to avoid conflicts)
% ================================================================

\RequirePackage[
  colorlinks  = true,
  linkcolor   = thesisChapter,
  citecolor   = thesisAccent,
  urlcolor    = thesisLink,
  bookmarks   = true,
  bookmarksnumbered = true,
  pdfstartview = FitH,
]{hyperref}

% PDF metadata (set at begin-document when user commands are resolved)
\AtBeginDocument{%
  \hypersetup{
    pdftitle  = {\rt@thesistitle},
    pdfauthor = {\rt@thesisauthor},
  }%
}

% ================================================================
%  Cleveref (loaded after hyperref)
% ================================================================

\RequirePackage[capitalise,noabbrev]{cleveref}

% ================================================================
%  Footnotes
% ================================================================

\RequirePackage[bottom,hang]{footmisc}
\setlength{\footnotesep}{1.1em}

% ================================================================
%  Captions
% ================================================================

\RequirePackage{caption}
\captionsetup{
  font       = small,
  labelfont  = {bf,color=thesisChapter},
  textfont   = {color=thesisText},
  format     = hang,
  margin     = 1em,
}

% ================================================================
%  Draft watermark (when draft option is true)
% ================================================================

\ifrt@draft
  \RequirePackage{draftwatermark}
  \SetWatermarkText{DRAFT}
  \SetWatermarkScale{1.5}
  \SetWatermarkColor{thesisAccent!15}
  \RequirePackage{lineno}
  \linenumbers
\fi

% ================================================================
%  Miscellaneous utilities
% ================================================================

% Blank page with message
\newcommand{\blankpage}{%
  \thispagestyle{empty}%
  \null\vfill
  \begin{center}
    \textit{\color{thesisTextMuted}This page intentionally left blank.}
  \end{center}
  \vfill\newpage
}

% Coloured horizontal rule
\newcommand{\thesisrule}[1][thesisAccent]{%
  {\color{#1}\rule{\textwidth}{1.5pt}}%
}

% Thesis note (marginal annotation in draft mode)
\ifrt@draft
  \newcommand{\thesisnote}[1]{%
    \marginpar{\footnotesize\color{thesisAccent}\raggedright #1}%
  }
\else
  \newcommand{\thesisnote}[1]{}
\fi

% ================================================================
%  End of class
% ================================================================

\endinput
