% rossletter.cls
% Formal letter class with institutional branding and palette support.
%
% Usage:
%   \documentclass[palette=slate]{rossletter}
%
% Available palettes: any palette defined in rosspalettes.sty
%   e.g. slate, lancet, nhs, oxford, nature, nejm, uom, ...
%
% Ross Dunne / Claude, 2026

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{rossletter}[2026/03/24 Formal letter class]

% ----------------------------------------------------------------
% Option handling
% ----------------------------------------------------------------

\RequirePackage{pgfkeys}
\RequirePackage{pgfopts}

\pgfkeys{
  /rossletter/.cd,
  palette/.store in=\rl@palette,
  palette=slate,
}
\ProcessPgfOptions{/rossletter}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass[11pt,a4paper]{article}

% ----------------------------------------------------------------
% Core packages
% ----------------------------------------------------------------

\PassOptionsToPackage{palette=\rl@palette}{rosspalettes}
\RequirePackage{rosspalettes}
\RequirePackage{geometry}
\RequirePackage{graphicx}
\RequirePackage{xcolor}
\RequirePackage{etoolbox}
\RequirePackage{fancyhdr}
\RequirePackage{parskip}
\RequirePackage{hyperref}
\RequirePackage{lastpage}

% ----------------------------------------------------------------
% Page geometry — letter-appropriate margins
% ----------------------------------------------------------------

\geometry{
  a4paper,
  left=25mm,
  right=25mm,
  top=20mm,
  bottom=25mm,
}

% ----------------------------------------------------------------
% Page style — small footer page number for multi-page letters
% ----------------------------------------------------------------

\pagestyle{fancy}
\fancyhf{}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}
\fancyfoot[C]{%
  \ifnum\value{page}>1
    \small\color{rpTextMuted}\thepage\,/\,\pageref{LastPage}%
  \fi
}
\fancypagestyle{plain}{\pagestyle{fancy}}

% ----------------------------------------------------------------
% Hyperref configuration
% ----------------------------------------------------------------

\hypersetup{
  colorlinks=true,
  linkcolor=rpPrimary,
  urlcolor=rpSecondary,
  pdfborder={0 0 0},
}

% ----------------------------------------------------------------
% Internal storage
% ----------------------------------------------------------------

\def\rl@sendername{}
\def\rl@sendertitle{}
\def\rl@senderemail{}
\def\rl@senderphone{}

\def\rl@recipname{}
\def\rl@reciptitle{}
\def\rl@recipinst{}
\def\rl@recipaddr{}

\def\rl@letterdate{\today}
\def\rl@subject{}
\def\rl@sigimage{}

% ----------------------------------------------------------------
% User commands — sender
% ----------------------------------------------------------------

\newcommand{\sender}[4]{%
  \def\rl@sendername{#1}%
  \def\rl@sendertitle{#2}%
  \def\rl@senderemail{#3}%
  \def\rl@senderphone{#4}%
}

% ----------------------------------------------------------------
% User commands — recipient
% ----------------------------------------------------------------

\newcommand{\recipient}[4]{%
  \def\rl@recipname{#1}%
  \def\rl@reciptitle{#2}%
  \def\rl@recipinst{#3}%
  \def\rl@recipaddr{#4}%
}

% ----------------------------------------------------------------
% User commands — date, subject, signature image
% ----------------------------------------------------------------

\newcommand{\letterdate}[1]{\def\rl@letterdate{#1}}
\newcommand{\re}[1]{\def\rl@subject{#1}}
\newcommand{\signatureimage}[1]{\def\rl@sigimage{#1}}

% ----------------------------------------------------------------
% \letterheader{logo}{institution}{department}{address}
% ----------------------------------------------------------------

\newcommand{\letterheader}[4]{%
  \noindent
  \begin{minipage}[t]{0.15\textwidth}
    \ifblank{#1}{}{\includegraphics[width=\linewidth]{#1}}%
  \end{minipage}%
  \hfill
  \begin{minipage}[t]{0.80\textwidth}
    \raggedright
    {\Large\bfseries\color{rpPrimary}#2}\par
    \vspace{1pt}
    {\normalsize\color{rpSecondary}#3}\par
    \vspace{2pt}
    {\small\color{rpTextMuted}#4}%
  \end{minipage}%
  \par\vspace{6pt}
  {\color{rpAccent}\hrule height 0.8pt}%
  \vspace{16pt}
}

% ----------------------------------------------------------------
% \opening{salutation} — prints date, recipient block, RE, then salutation
% ----------------------------------------------------------------

\newcommand{\opening}[1]{%
  % Date — right-aligned
  \noindent\hfill{\rl@letterdate}\par
  \vspace{10pt}
  % Recipient block
  \noindent
  \ifx\rl@recipname\empty\else
    {\rl@recipname}%
    \ifx\rl@reciptitle\empty\else\\{\rl@reciptitle}\fi
    \ifx\rl@recipinst\empty\else\\{\rl@recipinst}\fi
    \ifx\rl@recipaddr\empty\else\\{\rl@recipaddr}\fi
    \par\vspace{10pt}
  \fi
  % RE line
  \ifx\rl@subject\empty\else
    \noindent\textbf{RE:~\rl@subject}\par
    \vspace{8pt}
  \fi
  % Salutation
  \noindent #1\par
  \vspace{4pt}
}

% ----------------------------------------------------------------
% \closing{valediction}
% ----------------------------------------------------------------

\newcommand{\closing}[1]{%
  \par\vspace{16pt}
  \noindent #1\par
  \vspace{4pt}
}

% ----------------------------------------------------------------
% \signature{name}{title}
% ----------------------------------------------------------------

\newcommand{\signature}[2]{%
  % Optional scanned signature image
  \ifx\rl@sigimage\empty\else
    \vspace{4pt}
    \noindent\includegraphics[height=28pt]{\rl@sigimage}\par
  \fi
  \vspace{20pt}
  \noindent{\bfseries\color{rpPrimary}#1}\par
  \noindent{\small\color{rpTextMuted}#2}\par
  % Sender contact details below signature
  \ifx\rl@senderemail\empty\else
    \vspace{2pt}
    \noindent{\small\color{rpTextMuted}%
      \ifx\rl@senderemail\empty\else\href{mailto:\rl@senderemail}{\rl@senderemail}\fi
      \ifx\rl@senderphone\empty\else\quad\rl@senderphone\fi
    }%
    \par
  \fi
}

% ----------------------------------------------------------------
% \enclosure{list}
% ----------------------------------------------------------------

\newcommand{\enclosure}[1]{%
  \par\vspace{12pt}
  \noindent{\small\textbf{Enc:}~#1}\par
}

% ----------------------------------------------------------------
% \cc{list}
% ----------------------------------------------------------------

\newcommand{\cc}[1]{%
  \par\vspace{4pt}
  \noindent{\small\textbf{CC:}~#1}\par
}

% ----------------------------------------------------------------
% Typography defaults
% ----------------------------------------------------------------

\setlength{\parindent}{0pt}
\setlength{\parskip}{8pt plus 2pt minus 1pt}

\endinput
