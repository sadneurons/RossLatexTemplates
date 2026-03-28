% rosscv.cls
% Academic CV class built on article with rosspalettes colour theming.
% Supports one-column and two-column layouts with a rich set of
% academic entry commands (publications, grants, supervision, etc.).
%
% Usage:
%   \documentclass[palette=slate,layout=onecol]{rosscv}
%
% Options:
%   palette=<name>   Any palette from rosspalettes (default: slate)
%   layout=onecol    Single-column layout (default)
%   layout=twocol    Two-column layout with sidebar
%
% Ross Dunne / Claude, 2026

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{rosscv}[2026/03/24 Academic CV class]

% ================================================================
% Option handling
% ================================================================

\RequirePackage{pgfkeys}
\RequirePackage{pgfopts}

\newif\ifcv@twocol

\pgfkeys{
  /rosscv/.cd,
  palette/.store in=\cv@palette,   palette=slate,
  layout/.is choice,
  layout/onecol/.code={\cv@twocolfalse},
  layout/twocol/.code={\cv@twocoltrue},
  layout=onecol,
}
\ProcessPgfOptions{/rosscv}

% ================================================================
% Base class
% ================================================================

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass[11pt,a4paper]{article}

% ================================================================
% Packages
% ================================================================

\RequirePackage[palette=\cv@palette]{rosspalettes}
\RequirePackage{geometry}
\RequirePackage{etoolbox}
\RequirePackage{xcolor}
\RequirePackage{graphicx}
\RequirePackage{enumitem}
\RequirePackage{hyperref}
\RequirePackage{fontawesome5}
\RequirePackage{tabularx}
\RequirePackage{parskip}
\RequirePackage{tikz}
\RequirePackage{calc}
\RequirePackage{ifthen}
\RequirePackage{fancyhdr}

% ================================================================
% Geometry
% ================================================================

\ifcv@twocol
  \geometry{a4paper, top=20mm, bottom=20mm, left=20mm, right=20mm}
\else
  \geometry{a4paper, top=20mm, bottom=20mm, left=20mm, right=20mm}
\fi

% ================================================================
% Hyperref setup
% ================================================================

\hypersetup{
  colorlinks=true,
  linkcolor=rpPrimary,
  urlcolor=rpSecondary,
  citecolor=rpAccent,
  pdfborder={0 0 0},
}

% ================================================================
% Page numbering — suppress on first page, small thereafter
% ================================================================

\fancypagestyle{plain}{%
  \fancyhf{}%
  \renewcommand{\headrulewidth}{0pt}%
  \renewcommand{\footrulewidth}{0pt}%
}

\fancypagestyle{cvpages}{%
  \fancyhf{}%
  \fancyfoot[R]{%
    \small\color{rpTextMuted}\thepage%
  }%
  \renewcommand{\headrulewidth}{0pt}%
  \renewcommand{\footrulewidth}{0pt}%
}

\pagestyle{cvpages}
\thispagestyle{plain}

% ================================================================
% Font defaults — use sans-serif
% ================================================================

\RequirePackage[T1]{fontenc}
\RequirePackage{lmodern}
\renewcommand{\familydefault}{\sfdefault}

% ================================================================
% Colour aliases for convenience
% ================================================================

\colorlet{cvprimary}{rpPrimary}
\colorlet{cvsecondary}{rpSecondary}
\colorlet{cvaccent}{rpAccent}
\colorlet{cvtext}{rpText}
\colorlet{cvmuted}{rpTextMuted}
\colorlet{cvrule}{rpRule}
\colorlet{cvbg}{rpBg}

% ================================================================
% Internal spacing helpers
% ================================================================

\newlength{\cv@sidebarwidth}
\setlength{\cv@sidebarwidth}{60mm}
\newlength{\cv@mainwidth}
\setlength{\cv@mainwidth}{\textwidth-\cv@sidebarwidth-8mm}

\newcommand{\cv@sectionskip}{\vspace{10pt}}
\newcommand{\cv@entryskip}{\vspace{6pt}}
\newcommand{\cv@rulethickness}{0.8pt}

% ================================================================
% \cvheader{name}{title}{email}{phone}{orcid}{address}
% ================================================================

\newcommand{\cvheader}[6]{%
  \begin{center}%
    {\fontsize{26}{30}\selectfont\bfseries\color{cvprimary}#1\par}%
    \vskip4pt%
    {\large\color{cvmuted}#2\par}%
    \vskip8pt%
    {\small\color{cvtext}%
      \ifblank{#3}{}{\faEnvelope\ \href{mailto:#3}{#3}}%
      \ifblank{#4}{}{\quad\faPhone\ #4}%
      \ifblank{#5}{}{\quad\faOrcid\ \href{https://orcid.org/#5}{#5}}%
      \par}%
    \ifblank{#6}{}{%
      \vskip2pt%
      {\small\color{cvmuted}\faMapMarker*\ #6\par}%
    }
  \end{center}%
  \vskip4pt%
  {\color{cvprimary}\hrule height \cv@rulethickness}%
  \vskip10pt%
}

% ================================================================
% \cvsection{title}
% ================================================================

\newcommand{\cvsection}[1]{%
  \cv@sectionskip%
  {\Large\bfseries\color{cvprimary}#1\par}%
  \vskip3pt%
  {\color{cvprimary}\hrule height \cv@rulethickness}%
  \vskip6pt%
}

% ================================================================
% \cvsubsection{title}
% ================================================================

\newcommand{\cvsubsection}[1]{%
  \vskip6pt%
  {\large\bfseries\color{cvsecondary}#1\par}%
  \vskip3pt%
}

% ================================================================
% \cventry{years}{title}{institution}{location}{description}
% ================================================================

\newcommand{\cventry}[5]{%
  \cv@entryskip%
  \noindent%
  \begin{tabularx}{\linewidth}{@{}p{28mm}X@{}}%
    {\small\color{cvmuted}#1} &
    {\bfseries\color{cvtext}#2}%
    \ifblank{#3}{}{, \color{cvsecondary}#3}%
    \ifblank{#4}{}{\hfill\small\color{cvmuted}#4}%
    \ifblank{#5}{}{\newline\small\color{cvtext}#5}%
  \end{tabularx}%
  \par%
}

% ================================================================
% \publication{authors}{year}{title}{journal}{volume}{pages}{doi}
% ================================================================

\newcommand{\publication}[7]{%
  \cv@entryskip%
  \noindent%
  \begin{tabularx}{\linewidth}{@{}p{28mm}X@{}}%
    {\small\color{cvmuted}#2} &
    {%
      \color{cvtext}#1\ %
      \ifblank{#3}{}{{\bfseries #3.}}\ %
      \ifblank{#4}{}{{\itshape\color{cvsecondary}#4}}%
      \ifblank{#5}{}{, \color{cvtext}#5}%
      \ifblank{#6}{}{, #6}%
      \ifblank{#7}{}{. \small\color{cvaccent}\href{https://doi.org/#7}{doi:\,#7}}%
    }%
  \end{tabularx}%
  \par%
}

% ================================================================
% \grant{title}{funder}{amount}{period}{role}
% ================================================================

\newcommand{\grant}[5]{%
  \cv@entryskip%
  \noindent%
  \begin{tabularx}{\linewidth}{@{}p{28mm}X@{}}%
    {\small\color{cvmuted}#4} &
    {%
      {\bfseries\color{cvtext}#1}\newline
      {\color{cvsecondary}#2}%
      \ifblank{#3}{}{\hfill\bfseries\color{cvaccent}#3}\newline
      {\small\color{cvmuted}Role: #5}%
    }%
  \end{tabularx}%
  \par%
}

% ================================================================
% \teachingentry{course}{role}{institution}{years}
% ================================================================

\newcommand{\teachingentry}[4]{%
  \cv@entryskip%
  \noindent%
  \begin{tabularx}{\linewidth}{@{}p{28mm}X@{}}%
    {\small\color{cvmuted}#4} &
    {%
      {\bfseries\color{cvtext}#1}%
      \ifblank{#2}{}{\newline\small\color{cvsecondary}#2}%
      \ifblank{#3}{}{\newline\small\color{cvmuted}#3}%
    }%
  \end{tabularx}%
  \par%
}

% ================================================================
% \conferenceentry{title}{conference}{year}{type}
%   type = talk / poster / invited
% ================================================================

\newcommand{\cv@confbadge}[1]{%
  \ifthenelse{\equal{#1}{invited}}{%
    {\scriptsize\bfseries\color{cvaccent}[Invited]}%
  }{%
    \ifthenelse{\equal{#1}{poster}}{%
      {\scriptsize\bfseries\color{cvsecondary}[Poster]}%
    }{%
      {\scriptsize\bfseries\color{cvmuted}[Talk]}%
    }%
  }%
}

\newcommand{\conferenceentry}[4]{%
  \cv@entryskip%
  \noindent%
  \begin{tabularx}{\linewidth}{@{}p{28mm}X@{}}%
    {\small\color{cvmuted}#3} &
    {%
      {\bfseries\color{cvtext}#1}\ \cv@confbadge{#4}\newline
      {\small\itshape\color{cvsecondary}#2}%
    }%
  \end{tabularx}%
  \par%
}

% ================================================================
% \supervision{name}{degree}{year}{status}
% ================================================================

\newcommand{\supervision}[4]{%
  \cv@entryskip%
  \noindent%
  \begin{tabularx}{\linewidth}{@{}p{28mm}X@{}}%
    {\small\color{cvmuted}#3} &
    {%
      {\bfseries\color{cvtext}#1}%
      \ifblank{#2}{}{\ {\small\color{cvsecondary}(#2)}}%
      \ifblank{#4}{}{\hfill\small\itshape\color{cvmuted}#4}%
    }%
  \end{tabularx}%
  \par%
}

% ================================================================
% \award{name}{year}{details}
% ================================================================

\newcommand{\award}[3]{%
  \cv@entryskip%
  \noindent%
  \begin{tabularx}{\linewidth}{@{}p{28mm}X@{}}%
    {\small\color{cvmuted}#2} &
    {%
      {\bfseries\color{cvtext}#1}%
      \ifblank{#3}{}{\newline\small\color{cvmuted}#3}%
    }%
  \end{tabularx}%
  \par%
}

% ================================================================
% \skill{category}{items}
% ================================================================

\newcommand{\skill}[2]{%
  \cv@entryskip%
  \noindent%
  \begin{tabularx}{\linewidth}{@{}p{28mm}X@{}}%
    {\small\bfseries\color{cvprimary}#1} &
    {\color{cvtext}#2}%
  \end{tabularx}%
  \par%
}

% ================================================================
% Two-column layout support
% ================================================================

% Sidebar contact block for twocol mode
% \cvsidebar{content} — wraps content in the left sidebar
% \cvmain{content}    — wraps content in the right main column

\ifcv@twocol

  % Redefine cvheader for twocol — name spans full width
  \renewcommand{\cvheader}[6]{%
    {\fontsize{26}{30}\selectfont\bfseries\color{cvprimary}#1\par}%
    \vskip2pt%
    {\large\color{cvmuted}#2\par}%
    \vskip6pt%
    {\color{cvprimary}\hrule height \cv@rulethickness}%
    \vskip8pt%
    % Store contact details for sidebar
    \gdef\cv@stored@email{#3}%
    \gdef\cv@stored@phone{#4}%
    \gdef\cv@stored@orcid{#5}%
    \gdef\cv@stored@address{#6}%
  }

  % Environment for the two-column body
  \newenvironment{cvcolumns}{%
    \noindent%
    \begin{minipage}[t]{\cv@sidebarwidth}%
      \raggedright%
      % Print contact info if stored
      \ifdef{\cv@stored@email}{%
        \cvsection{Contact}%
        \ifx\cv@stored@email\empty\else
          {\small\faEnvelope\ \href{mailto:\cv@stored@email}{\cv@stored@email}\par\vskip3pt}%
        \fi
        \ifx\cv@stored@phone\empty\else
          {\small\faPhone\ \cv@stored@phone\par\vskip3pt}%
        \fi
        \ifx\cv@stored@orcid\empty\else
          {\small\faOrcid\ \href{https://orcid.org/\cv@stored@orcid}{\cv@stored@orcid}\par\vskip3pt}%
        \fi
        \ifx\cv@stored@address\empty\else
          {\small\faMapMarker*\ \cv@stored@address\par\vskip3pt}%
        \fi
      }{}%
  }{%
    \end{minipage}%
  }

  % Sidebar column (left)
  \newcommand{\cvsidebar}[1]{%
    #1%
    \end{minipage}%
    \hfill%
    \begin{minipage}[t]{\cv@mainwidth}%
      \raggedright%
  }

  % Convenience: end main column is just closing cvcolumns
  \newcommand{\cvmain}[1]{%
    #1%
  }

\else

  % One-column stubs
  \newenvironment{cvcolumns}{}{}
  \newcommand{\cvsidebar}[1]{#1}
  \newcommand{\cvmain}[1]{#1}

\fi

% ================================================================
% List styling
% ================================================================

\setlist[itemize]{leftmargin=14pt, labelsep=6pt, itemsep=1pt,
  label={\color{cvprimary}\textbullet}}
\setlist[enumerate]{leftmargin=14pt, labelsep=6pt, itemsep=1pt}

% ================================================================
% Section/subsection overrides (if user calls \section directly)
% ================================================================

\renewcommand{\section}[1]{\cvsection{#1}}
\renewcommand{\subsection}[1]{\cvsubsection{#1}}

% ================================================================
% Utility commands
% ================================================================

% Coloured rule
\newcommand{\cvrule}{%
  \vskip4pt%
  {\color{cvrule}\hrule height 0.4pt}%
  \vskip4pt%
}

% Compact contact line for footers or headers
\newcommand{\cvcontactline}[3]{%
  {\small\color{cvmuted}#1\quad#2\quad#3}%
}

% Date helper — right-aligned muted date
\newcommand{\cvdate}[1]{%
  \hfill{\small\color{cvmuted}#1}%
}

% ================================================================
\endinput
