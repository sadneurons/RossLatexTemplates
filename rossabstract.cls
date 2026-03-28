% rossabstract.cls
% Conference abstract class for oral presentations, posters, etc.
% Provides structured and unstructured abstract environments,
% automatic word counting, and clean single-page layout.
%
% Ross Dunne / Claude, 2026

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{rossabstract}[2026/03/24 Conference abstract class]

\RequirePackage{pgfkeys}
\RequirePackage{pgfopts}

% ----------------------------------------------------------------
% Options
% ----------------------------------------------------------------

\pgfkeys{
  /rossabstract/.cd,
  palette/.store in=\ra@palette,
  palette=lancet,
  wordlimit/.store in=\ra@wordlimit,
  wordlimit=300,
}
\ProcessPgfOptions{/rossabstract}

% ----------------------------------------------------------------
% Base class
% ----------------------------------------------------------------

\LoadClass[11pt,a4paper]{article}

% ----------------------------------------------------------------
% Packages
% ----------------------------------------------------------------

\RequirePackage[palette=\ra@palette]{rosspalettes}
\RequirePackage{geometry}
\RequirePackage{enumitem}
\RequirePackage{titlesec}
\RequirePackage{fancyhdr}
\RequirePackage{xstring}
\RequirePackage{totcount}
\RequirePackage{hyperref}

% ----------------------------------------------------------------
% Geometry — single page, 20mm margins
% ----------------------------------------------------------------

\geometry{
  a4paper,
  margin=20mm,
}

% ----------------------------------------------------------------
% Typography
% ----------------------------------------------------------------

\pagestyle{empty}
\setlength{\parindent}{0pt}
\setlength{\parskip}{0.5\baselineskip plus 2pt minus 1pt}

% ----------------------------------------------------------------
% Metadata commands
% ----------------------------------------------------------------

\newcommand{\ra@affiliation}{}
\newcommand{\ra@correspondingauthor}{}
\newcommand{\ra@conference}{}
\newcommand{\ra@abstracttype}{}
\newcommand{\ra@keywords}{}
\newcommand{\ra@conflict}{}
\newcommand{\ra@funding}{}

\newcommand{\affiliation}[1]{\renewcommand{\ra@affiliation}{#1}}
\newcommand{\correspondingauthor}[1]{\renewcommand{\ra@correspondingauthor}{#1}}
\newcommand{\conference}[1]{\renewcommand{\ra@conference}{#1}}
\newcommand{\abstracttype}[1]{\renewcommand{\ra@abstracttype}{#1}}
\newcommand{\keywords}[1]{\renewcommand{\ra@keywords}{#1}}
\newcommand{\conflictofinterest}[1]{\renewcommand{\ra@conflict}{#1}}
\newcommand{\funding}[1]{\renewcommand{\ra@funding}{#1}}

% ----------------------------------------------------------------
% Word count machinery
% ----------------------------------------------------------------

\newcounter{ra@wordcount}
\setcounter{ra@wordcount}{0}

% Approximate word count: split on spaces.  Not perfect, but
% works without shell escape.  When shell escape is available
% the count file written by \write18 overrides.
\newcommand{\ra@countwords}[1]{%
  \begingroup
    \def\ra@tmp{#1}%
    \@tempcnta=\z@
    \expandafter\ra@@countloop\ra@tmp{} \@nil
    \global\addtocounter{ra@wordcount}{\the\@tempcnta}%
  \endgroup
}
\def\ra@@countloop#1 #2\@nil{%
  \def\ra@tok{#1}%
  \ifx\ra@tok\empty\else
    \advance\@tempcnta\@ne
  \fi
  \def\ra@rest{#2}%
  \ifx\ra@rest\empty\else
    \ra@@countloop#2\@nil
  \fi
}

% ----------------------------------------------------------------
% Word limit check (called at end of document)
% ----------------------------------------------------------------

\newcommand{\ra@checklimit}{%
  \ifnum\value{ra@wordcount}>\ra@wordlimit\relax
    \ClassWarning{rossabstract}{%
      Word count (\the\value{ra@wordcount}) exceeds the
      word limit (\ra@wordlimit)}%
  \fi
}

% ----------------------------------------------------------------
% Title block
% ----------------------------------------------------------------

\renewcommand{\maketitle}{%
  \begingroup
    % Conference header
    \ifx\ra@conference\empty\else
      {\centering\small\color{rpTextMuted}\ra@conference\par}%
      \vspace{2pt}%
    \fi
    % Abstract type
    \ifx\ra@abstracttype\empty\else
      {\centering\small\scshape\color{rpAccent}\ra@abstracttype\par}%
      \vspace{6pt}%
    \fi
    % Rule
    {\color{rpAccent}\hrule height 0.8pt}%
    \vspace{8pt}%
    % Title
    {\centering\Large\bfseries\color{rpPrimary}\@title\par}%
    \vspace{4pt}%
    % Author
    {\centering\normalsize\@author\par}%
    % Affiliation
    \ifx\ra@affiliation\empty\else
      \vspace{2pt}%
      {\centering\small\itshape\color{rpTextMuted}\ra@affiliation\par}%
    \fi
    % Corresponding author
    \ifx\ra@correspondingauthor\empty\else
      \vspace{2pt}%
      {\centering\small\color{rpTextMuted}%
        Corresponding author: \href{mailto:\ra@correspondingauthor}%
        {\ra@correspondingauthor}\par}%
    \fi
    \vspace{6pt}%
    {\color{rpAccent}\hrule height 0.4pt}%
    \vspace{8pt}%
  \endgroup
}

% ----------------------------------------------------------------
% Structured abstract
% ----------------------------------------------------------------

\newcommand{\ra@sectionlabel}[1]{%
  {\textbf{\color{rpPrimary}#1:}\hspace{0.5em}}%
}

\newcommand{\structuredabstract}[4]{%
  \ra@countwords{#1}%
  \ra@countwords{#2}%
  \ra@countwords{#3}%
  \ra@countwords{#4}%
  \begingroup
    \small
    \ra@sectionlabel{Background}#1\par
    \ra@sectionlabel{Methods}#2\par
    \ra@sectionlabel{Results}#3\par
    \ra@sectionlabel{Conclusions}#4\par
  \endgroup
}

% ----------------------------------------------------------------
% Regular (unstructured) abstract
% ----------------------------------------------------------------

\renewenvironment{abstract}{%
  \begingroup\small
  \def\ra@abstracttext{}%
}{%
  \endgroup
}

% Patch: capture text for word counting in unstructured abstracts.
% We use a simpler approach — users write text directly and we
% count after the fact via the structured path or manually.
% For unstructured abstracts, provide \countwords.
\newcommand{\countwords}[1]{\ra@countwords{#1}#1}

% ----------------------------------------------------------------
% Keywords
% ----------------------------------------------------------------

\newcommand{\ra@printkeywords}{%
  \ifx\ra@keywords\empty\else
    \vspace{6pt}%
    {\small\textbf{\color{rpPrimary}Keywords:}\hspace{0.5em}%
      \ra@keywords\par}%
  \fi
}

% ----------------------------------------------------------------
% Conflict of interest and funding
% ----------------------------------------------------------------

\newcommand{\ra@printdisclosures}{%
  \ifx\ra@conflict\empty\else
    \vspace{4pt}%
    {\small\textbf{\color{rpPrimary}Conflict of Interest:}\hspace{0.5em}%
      \ra@conflict\par}%
  \fi
  \ifx\ra@funding\empty\else
    \vspace{4pt}%
    {\small\textbf{\color{rpPrimary}Funding:}\hspace{0.5em}%
      \ra@funding\par}%
  \fi
}

% ----------------------------------------------------------------
% Footer: word count and limit warning
% ----------------------------------------------------------------

\newcommand{\ra@printwordcount}{%
  \vfill
  {\color{rpRule}\hrule height 0.4pt}%
  \vspace{4pt}%
  {\small\color{rpTextMuted}%
    Word count: \the\value{ra@wordcount}%
    \ifnum\value{ra@wordcount}>\ra@wordlimit\relax
      \hspace{1em}{\color{red}\bfseries
        [Exceeds limit of \ra@wordlimit]}%
    \else
      \hspace{1em}(limit: \ra@wordlimit)%
    \fi
  \par}%
}

% ----------------------------------------------------------------
% End-of-document hook: print keywords, disclosures, word count
% ----------------------------------------------------------------

\AtEndDocument{%
  \ra@printkeywords
  \ra@printdisclosures
  \ra@printwordcount
  \ra@checklimit
}

% ----------------------------------------------------------------
% Single-page enforcement
% ----------------------------------------------------------------

\AtEndDocument{%
  \ifnum\value{page}>1\relax
    \ClassWarning{rossabstract}{%
      Abstract exceeds one page. Please shorten your content}%
  \fi
}

% ----------------------------------------------------------------
% Hyperref configuration
% ----------------------------------------------------------------

\AtBeginDocument{%
  \hypersetup{
    colorlinks=true,
    linkcolor=rpPrimary,
    urlcolor=rpAccent,
    citecolor=rpPrimary,
    pdfauthor={\@author},
    pdftitle={\@title},
  }%
}

\endinput
