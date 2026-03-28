% rossmanuscript.cls
% APA 7th edition manuscript class for journal submissions.
% Builds on article with consistent Ross ecosystem integration
% (rosspalettes, rossstats, rosstables).
%
% Usage:
%   \documentclass[palette=lancet,journal={Sleep},blind]{rossmanuscript}
%
% Ross Dunne / Claude, 2026

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{rossmanuscript}[2026/03/24 APA 7th manuscript class]

% ================================================================
% Options via pgfkeys
% ================================================================

\RequirePackage{pgfkeys}
\RequirePackage{pgfopts}
\RequirePackage{etoolbox}

\newif\ifrm@blind
\rm@blindfalse

\pgfkeys{
  /rossmanuscript/.cd,
  palette/.store in = \rm@palette,
  palette           = lancet,
  journal/.store in = \rm@journal,
  journal           = {},
  blind/.is if      = rm@blind,
  blind/.default    = true,
}
\ProcessPgfOptions{/rossmanuscript}

% ================================================================
% Base class
% ================================================================

\LoadClass[12pt]{article}

% ================================================================
% Ross ecosystem packages
% ================================================================

\RequirePackage[palette=\rm@palette]{rosspalettes}
\RequirePackage{rossstats}
\RequirePackage{rosstables}

% ================================================================
% Core packages
% ================================================================

\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage{mathpazo}            % Palatino — common APA choice
\RequirePackage[
  top=1in, bottom=1in,
  left=1in, right=1in
]{geometry}
\RequirePackage{setspace}
\doublespacing

\RequirePackage{graphicx}
\RequirePackage{hyperref}
\hypersetup{
  colorlinks  = true,
  linkcolor   = rpPrimary,
  citecolor   = rpPrimary,
  urlcolor    = rpAccent,
  pdfcreator  = {rossmanuscript class},
}

% Ragged right (APA style — no full justification)
\raggedright
\setlength{\parindent}{0.5in}
\setlength{\parskip}{0pt}

% ================================================================
% Running head (fancyhdr)
% ================================================================

\RequirePackage{fancyhdr}

\newcommand{\rm@runninghead}{}
\newcommand{\runninghead}[1]{\renewcommand{\rm@runninghead}{\MakeUppercase{#1}}}

\fancypagestyle{manuscript}{%
  \fancyhf{}%
  \fancyhead[L]{\footnotesize\rm@runninghead}%
  \fancyhead[R]{\footnotesize\thepage}%
  \renewcommand{\headrulewidth}{0pt}%
  \renewcommand{\footrulewidth}{0pt}%
}
\pagestyle{manuscript}

% First-page style (APA: running head label on page 1)
\fancypagestyle{titlepage}{%
  \fancyhf{}%
  \fancyhead[L]{\footnotesize\rm@runninghead}%
  \fancyhead[R]{\footnotesize\thepage}%
  \renewcommand{\headrulewidth}{0pt}%
  \renewcommand{\footrulewidth}{0pt}%
}

% ================================================================
% Line numbering (opt-in)
% ================================================================

\RequirePackage{lineno}
\newcommand{\linenumbering}{%
  \linenumbers
  \renewcommand{\linenumberfont}{\normalfont\footnotesize\color{rpTextMuted}}%
}

% ================================================================
% Metadata storage
% ================================================================

\newcommand{\rm@title}{}
\newcommand{\rm@shorttitle}{}
\newcommand{\rm@author}{}
\newcommand{\rm@affiliation}{}
\newcommand{\rm@authornote}{}
\newcommand{\rm@correspondingname}{}
\newcommand{\rm@correspondingemail}{}
\newcommand{\rm@orcid}{}
\newcommand{\rm@keywords}{}
\newcommand{\rm@conflict}{}
\newcommand{\rm@funding}{}
\newcommand{\rm@dataavail}{}
\newcommand{\rm@supplementary}{}

% Public metadata commands
\renewcommand{\title}[1]{\renewcommand{\rm@title}{#1}}
\newcommand{\shorttitle}[1]{%
  \renewcommand{\rm@shorttitle}{#1}%
  \runninghead{#1}%
}
\renewcommand{\author}[1]{\renewcommand{\rm@author}{#1}}
\newcommand{\affiliation}[1]{\renewcommand{\rm@affiliation}{#1}}
\newcommand{\authornote}[1]{\renewcommand{\rm@authornote}{#1}}
\newcommand{\correspondingauthor}[2]{%
  \renewcommand{\rm@correspondingname}{#1}%
  \renewcommand{\rm@correspondingemail}{#2}%
}
\newcommand{\orcid}[1]{\renewcommand{\rm@orcid}{#1}}
\newcommand{\keywords}[1]{\renewcommand{\rm@keywords}{#1}}
\newcommand{\conflictofinterest}[1]{\renewcommand{\rm@conflict}{#1}}
\newcommand{\funding}[1]{\renewcommand{\rm@funding}{#1}}
\newcommand{\dataavailability}[1]{\renewcommand{\rm@dataavail}{#1}}
\newcommand{\supplementary}[1]{\renewcommand{\rm@supplementary}{#1}}

% ================================================================
% Title page
% ================================================================

\newcommand{\maketitlepage}{%
  \thispagestyle{titlepage}%
  \begin{center}%
    \vspace*{1in}%
    {\Large\bfseries \rm@title\par}%
    \vspace{24pt}%
    %
    % Suppress author block when blind review is active
    \ifrm@blind\else
      {\large \rm@author\par}%
      \vspace{6pt}%
      \ifdefempty{\rm@affiliation}{}{%
        {\normalsize \rm@affiliation\par}%
      }%
      \vspace{6pt}%
      \ifdefempty{\rm@orcid}{}{%
        {\small ORCID: \href{https://orcid.org/\rm@orcid}{\rm@orcid}\par}%
      }%
    \fi
  \end{center}%
  \vspace{24pt}%
  %
  % Author note (suppressed if blind)
  \ifrm@blind\else
    \ifdefempty{\rm@authornote}{}{%
      \begingroup
        \setlength{\parindent}{0.5in}%
        \noindent\textbf{Author Note}\par
        \rm@authornote\par
        \ifdefempty{\rm@correspondingname}{}{%
          \noindent Correspondence concerning this article should be addressed to
          \rm@correspondingname.\ E-mail: \href{mailto:\rm@correspondingemail}{\rm@correspondingemail}.\par
        }%
      \endgroup
    }%
  \fi
  \newpage
}

% ================================================================
% Structured abstract (APA 7th)
% ================================================================

% \structuredabstract{background}{methods}{results}{conclusions}
\newcommand{\structuredabstract}[4]{%
  \newpage
  \begin{center}%
    {\large\bfseries Abstract}%
  \end{center}%
  \vspace{6pt}%
  \begingroup
    \setlength{\parindent}{0pt}%
    \noindent\textbf{Background:} #1\par\vspace{4pt}%
    \noindent\textbf{Methods:} #2\par\vspace{4pt}%
    \noindent\textbf{Results:} #3\par\vspace{4pt}%
    \noindent\textbf{Conclusions:} #4\par
  \endgroup
  %
  \ifdefempty{\rm@keywords}{}{%
    \vspace{12pt}%
    \noindent\textit{Keywords:} \rm@keywords
  }%
  \newpage
}

% Non-structured abstract alternative
\renewenvironment{abstract}{%
  \newpage
  \begin{center}%
    {\large\bfseries Abstract}%
  \end{center}%
  \vspace{6pt}%
  \noindent\ignorespaces
}{%
  \par
  \ifdefempty{\rm@keywords}{}{%
    \vspace{12pt}%
    \noindent\textit{Keywords:} \rm@keywords
  }%
  \newpage
}

% ================================================================
% Section formatting — unnumbered by default (APA style)
% ================================================================

\setcounter{secnumdepth}{0}

\RequirePackage{titlesec}

% Level 1: centred, bold
\titleformat{\section}
  {\normalfont\large\bfseries\centering}
  {}{0em}{}
\titlespacing*{\section}{0pt}{24pt}{12pt}

% Level 2: flush left, bold
\titleformat{\subsection}
  {\normalfont\normalsize\bfseries}
  {}{0em}{}
\titlespacing*{\subsection}{0pt}{18pt}{6pt}

% Level 3: flush left, bold italic
\titleformat{\subsubsection}
  {\normalfont\normalsize\bfseries\itshape}
  {}{0em}{}
\titlespacing*{\subsubsection}{0pt}{12pt}{6pt}

% Level 4: indented, bold, ending with period, run-in
\titleformat{\paragraph}[runin]
  {\normalfont\normalsize\bfseries}
  {}{0em}{}[.]
\titlespacing*{\paragraph}{0.5in}{12pt}{6pt}

% Level 5: indented, bold italic, ending with period, run-in
\titleformat{\subparagraph}[runin]
  {\normalfont\normalsize\bfseries\itshape}
  {}{0em}{}[.]
\titlespacing*{\subparagraph}{0.5in}{12pt}{6pt}

% ================================================================
% References — biblatex with APA 7th style
% ================================================================

\RequirePackage[
  style=apa,
  sortcites=true,
  sorting=nyt,
  backend=biber
]{biblatex}

% ================================================================
% Endfloat-like behaviour (opt-in)
% ================================================================

\newif\ifrm@endfloat
\rm@endfloatfalse

\newcommand{\floatsatend}{%
  \rm@endfloattrue
  \RequirePackage[nomarkers,nolists,tablesfirst]{endfloat}%
}

% ================================================================
% Disclosure / compliance sections
% ================================================================

\newcommand{\printdisclosures}{%
  \ifdefempty{\rm@conflict}{}{%
    \subsection{Conflict of Interest}%
    \rm@conflict\par\vspace{6pt}%
  }%
  \ifdefempty{\rm@funding}{}{%
    \subsection{Funding}%
    \rm@funding\par\vspace{6pt}%
  }%
  \ifdefempty{\rm@dataavail}{}{%
    \subsection{Data Availability}%
    \rm@dataavail\par\vspace{6pt}%
  }%
  \ifdefempty{\rm@supplementary}{}{%
    \subsection{Supplementary Material}%
    \rm@supplementary\par\vspace{6pt}%
  }%
}

% ================================================================
% Convenience: word count placeholder
% ================================================================

\newcommand{\wordcount}[1]{%
  \newcommand{\rm@wordcount}{#1}%
}

% ================================================================
% PDF metadata hook (at begin document)
% ================================================================

\AtBeginDocument{%
  \hypersetup{
    pdftitle  = {\rm@title},
    pdfauthor = {\ifrm@blind Anonymous\else\rm@author\fi},
  }%
  % If journal is specified, store in PDF subject
  \ifdefempty{\rm@journal}{}{%
    \hypersetup{pdfsubject={Prepared for: \rm@journal}}%
  }%
}

% ================================================================
% Footnotes: APA uses superscript arabic numerals (default in
% article), but ensure no rule separator
% ================================================================

\renewcommand{\footnoterule}{}

% ================================================================
% Lists: tighter spacing in manuscripts
% ================================================================

\RequirePackage{enumitem}
\setlist{nosep, leftmargin=0.5in}

% ================================================================
% Captions: APA style (bold label, italic caption text)
% ================================================================

\RequirePackage{caption}
\captionsetup[table]{
  labelfont   = bf,
  textfont    = it,
  labelsep    = newline,
  justification = raggedright,
  singlelinecheck = false,
  skip        = 6pt,
}
\captionsetup[figure]{
  labelfont   = bf,
  textfont    = it,
  labelsep    = period,
  justification = raggedright,
  singlelinecheck = false,
  skip        = 6pt,
}

% ================================================================
% Convenience command: journal note in footer (non-blind only)
% ================================================================

\newcommand{\printjournalnote}{%
  \ifdefempty{\rm@journal}{}{%
    \ifrm@blind\else
      \begin{center}%
        \footnotesize Prepared for: \textit{\rm@journal}%
      \end{center}%
    \fi
  }%
}

% ================================================================
% End of class
% ================================================================
\endinput
