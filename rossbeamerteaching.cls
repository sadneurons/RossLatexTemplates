% rossbeamerteaching.cls
% Teaching Beamer class — learning objectives, poll questions,
% worked examples, key terms, exam questions, activities, recaps,
% and reading lists for lectures, seminars, and workshops.
%
% Usage:
%   \documentclass[palette=lecture]{rossbeamerteaching}
%
% Available palettes:
%   lecture  (default) — warm navy / green / yellow
%   seminar            — teal / coral
%   workshop           — orange / charcoal
%
% Options:
%   palette=<name>   font=<fira|inter|sourcesans|libertinus|heros|georgia|system>
%   monofont=<name>  nobar  nologo
%
% Ross Dunne / Claude, 2026

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{rossbeamerteaching}[2026/03/24 Teaching Beamer class]

% ----------------------------------------------------------------
% Option handling
% ----------------------------------------------------------------

\RequirePackage{pgfkeys}
\RequirePackage{pgfopts}

\newif\ifrb@nobar  \rb@nobarfalse
\newif\ifrb@nologo \rb@nologofalse

\pgfkeys{
  /teachbeamer/.cd,
  palette/.store in=\teach@palette,   palette=lecture,
  font/.store in=\teach@fontchoice,   font=fira,
  monofont/.store in=\teach@mono,     monofont=,
  nobar/.code={\rb@nobartrue},
  nologo/.code={\rb@nologotrue},
}
\ProcessPgfOptions{/teachbeamer}

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
% \teach@defpal{name}
%   {primary}{secondary}{accent}{text}{textlight}{textmuted}{bg}{rule}
%   {accentdark}{accentlight}{accentbg}{lightmuted}
%
% First command consumes name + 8 core colours.
% Continuation consumes 4 refinement colours.
% ----------------------------------------------------------------

\newcommand{\teach@defpal}[9]{%
  \expandafter\def\csname teach@p@#1@P\endcsname{#2}%   primary
  \expandafter\def\csname teach@p@#1@S\endcsname{#3}%   secondary
  \expandafter\def\csname teach@p@#1@A\endcsname{#4}%   accent
  \expandafter\def\csname teach@p@#1@T\endcsname{#5}%   text
  \expandafter\def\csname teach@p@#1@TL\endcsname{#6}%  textlight
  \expandafter\def\csname teach@p@#1@TM\endcsname{#7}%  textmuted
  \expandafter\def\csname teach@p@#1@B\endcsname{#8}%   bg
  \expandafter\def\csname teach@p@#1@R\endcsname{#9}%   rule
  \teach@defpal@cont{#1}%
}
\newcommand{\teach@defpal@cont}[5]{%
  \expandafter\def\csname teach@p@#1@AD\endcsname{#2}%  accentdark
  \expandafter\def\csname teach@p@#1@AL\endcsname{#3}%  accentlight
  \expandafter\def\csname teach@p@#1@AB\endcsname{#4}%  accentbg
  \expandafter\def\csname teach@p@#1@LM\endcsname{#5}%  lightmuted
}

% Lecture — warm navy primary, forest-green secondary, golden-yellow accent
%                    name        P       S       A       T       TL      TM      B       R
\teach@defpal{lecture}  {1B2A4A}{3A7D44}{E8B830}{1C1C1C}{FFFFFF}{6A6A78}{F8F7F5}{D8D6D0}
%                                AD      AL      AB      LM
                                {B08A18}{F0D060}{FDF8E8}{A0A0B8}

% Seminar — teal primary, warm coral accent
\teach@defpal{seminar}  {0A4B5E}{2A9D8F}{E07050}{1C1C1C}{FFFFFF}{5A7078}{F6F9F8}{CDD8D5}
                                {B85840}{F09880}{FDF2EF}{8098A0}

% Workshop — deep orange primary, charcoal secondary, amber accent
\teach@defpal{workshop} {C05020}{3A3A3A}{F0A830}{1C1C1C}{FFFFFF}{6A6060}{FAF8F5}{D8D0CC}
                                {C89020}{F5C860}{FDF6E6}{989098}

% ----------------------------------------------------------------
% Palette activation
% ----------------------------------------------------------------

\newcommand{\teach@activatepalette}{%
  % Core colours
  \definecolor{rbPrimary}{HTML}{\csname teach@p@\teach@palette @P\endcsname}%
  \definecolor{rbSecondary}{HTML}{\csname teach@p@\teach@palette @S\endcsname}%
  \definecolor{rbAccent}{HTML}{\csname teach@p@\teach@palette @A\endcsname}%
  \definecolor{rbText}{HTML}{\csname teach@p@\teach@palette @T\endcsname}%
  \definecolor{rbTextLight}{HTML}{\csname teach@p@\teach@palette @TL\endcsname}%
  \definecolor{rbTextMuted}{HTML}{\csname teach@p@\teach@palette @TM\endcsname}%
  \definecolor{rbBg}{HTML}{\csname teach@p@\teach@palette @B\endcsname}%
  \definecolor{rbRule}{HTML}{\csname teach@p@\teach@palette @R\endcsname}%
  % Derive standard colours
  \rb@derivecolors
  % Override with explicit palette refinements
  \definecolor{rbAccentDark}{HTML}{\csname teach@p@\teach@palette @AD\endcsname}%
  \definecolor{rbAccentLight}{HTML}{\csname teach@p@\teach@palette @AL\endcsname}%
  \definecolor{rbAccentBg}{HTML}{\csname teach@p@\teach@palette @AB\endcsname}%
  \definecolor{rbLightMuted}{HTML}{\csname teach@p@\teach@palette @LM\endcsname}%
  % Legacy aliases
  \colorlet{teachPrimary}{rbPrimary}%
  \colorlet{teachSecondary}{rbSecondary}%
  \colorlet{teachAccent}{rbAccent}%
  \colorlet{teachText}{rbText}%
  \colorlet{teachTextLight}{rbTextLight}%
  \colorlet{teachTextMuted}{rbTextMuted}%
  \colorlet{teachBg}{rbBg}%
  \colorlet{teachRule}{rbRule}%
}
\teach@activatepalette

\newcommand{\setpalette}[1]{\def\teach@palette{#1}\teach@activatepalette}

% ----------------------------------------------------------------
% Beamer setup
% ----------------------------------------------------------------

\rb@setupbeamer
\setbeamersize{text margin left=12mm, text margin right=12mm}

% Teaching frame title: with accent underline rule
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
\rb@activatefont{\teach@fontchoice}
\rb@activatemono{\teach@mono}
\usefonttheme[onlymath]{serif}

% Footer: always on
\rb@activatefooter

% ----------------------------------------------------------------
% Title page — dark with accent bottom strip
% ----------------------------------------------------------------

\def\teach@module{}
\newcommand{\module}[1]{\def\teach@module{#1}}

\defbeamertemplate*{title page}{rossbeamerteaching}{%
  \begin{tikzpicture}[remember picture, overlay]
    \fill[rbPrimary] (current page.south west) rectangle (current page.north east);
    \fill[rbAccent]
      ([yshift=10mm]current page.south west) rectangle
      ([yshift=10.8mm]current page.south east);
    \fill[rbSecondary, opacity=0.06]
      ([xshift=50mm, yshift=-15mm]current page.north east) circle (40mm);
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
  \ifx\teach@module\empty\else
    \vskip4pt{\usebeamerfont{date}\color{rbLightMuted}\itshape\teach@module\par}\fi
  \vfill
}

% ================================================================
% TEACHING-SPECIFIC FEATURES
% ================================================================

% ----------------------------------------------------------------
% Learning objectives environment
%
%   \begin{learningobjectives}
%     \item Describe the key components of \ldots
%     \item Explain the relationship between \ldots
%   \end{learningobjectives}
% ----------------------------------------------------------------

\newcounter{teach@lo}
\newenvironment{learningobjectives}[1][Learning Objectives]{%
  \setcounter{teach@lo}{0}%
  \begin{tcolorbox}[
    enhanced, colback=rbAccentBg, colframe=rbAccentBg, boxrule=0pt,
    borderline west={3pt}{0pt}{rbAccent}, sharp corners,
    left=8pt, right=8pt, top=6pt, bottom=6pt,
    fonttitle=\bfseries\color{rbAccentDark},
    coltitle=rbAccentDark,
    title={\raisebox{-0.1em}{\tikz\node[circle, fill=rbAccent,
      text=rbTextLight, inner sep=0pt, minimum size=1.4em,
      font=\scriptsize\bfseries]{$\checkmark$};}%
      \hspace{6pt}#1},
  ]%
  \small\color{rbText}%
  \let\olditem\item
  \renewcommand{\item}{%
    \stepcounter{teach@lo}%
    \par\vskip3pt%
    {\bfseries\color{rbAccentDark}\theteach@lo.\hspace{4pt}}%
  }%
}{%
  \end{tcolorbox}%
}

% ----------------------------------------------------------------
% Poll question — multiple choice slide layout
%
%   \pollquestion{What is the capital of France?}
%     {London}{Paris}{Berlin}{Madrid}
% ----------------------------------------------------------------

\newcommand{\pollquestion}[5]{%
  \begin{frame}{Poll Question}
    \centering\vfill
    \begin{tcolorbox}[
      enhanced, colback=rbPrimary!5!white, colframe=rbPrimary!5!white,
      boxrule=0pt, sharp corners,
      left=12pt, right=12pt, top=10pt, bottom=10pt,
    ]
      {\large\bfseries\color{rbPrimary}#1\par}%
    \end{tcolorbox}%
    \vskip10pt%
    \begin{minipage}{0.90\textwidth}
      \begin{columns}[T]
        \begin{column}{0.47\textwidth}
          \teach@polloption{A}{#2}\par\vskip6pt%
          \teach@polloption{C}{#4}%
        \end{column}
        \begin{column}{0.47\textwidth}
          \teach@polloption{B}{#3}\par\vskip6pt%
          \teach@polloption{D}{#5}%
        \end{column}
      \end{columns}
    \end{minipage}
    \vfill
  \end{frame}
}

\newcommand{\teach@polloption}[2]{%
  \begin{tcolorbox}[
    enhanced, colback=white, colframe=rbRule,
    boxrule=0.4pt, sharp corners,
    left=6pt, right=6pt, top=4pt, bottom=4pt,
  ]
    {\bfseries\color{rbAccentDark}#1.\hspace{4pt}}%
    {\color{rbText}#2}%
  \end{tcolorbox}%
}

% ----------------------------------------------------------------
% Worked example environment — step-by-step numbered
%
%   \begin{workedexample}
%     \item Identify the given values: \ldots
%     \item Substitute into the formula: \ldots
%     \item Solve: \ldots
%   \end{workedexample}
% ----------------------------------------------------------------

\newcounter{teach@wes}
\newenvironment{workedexample}[1][Worked Example]{%
  \setcounter{teach@wes}{0}%
  \begin{tcolorbox}[
    enhanced, colback=rbSecondary!6!white, colframe=rbSecondary!6!white,
    boxrule=0pt, borderline west={3pt}{0pt}{rbSecondary},
    sharp corners,
    left=8pt, right=8pt, top=6pt, bottom=6pt,
    fonttitle=\bfseries\color{rbSecondary!80!black},
    coltitle=rbSecondary!80!black,
    title={\raisebox{-0.1em}{\tikz\node[circle, fill=rbSecondary,
      text=rbTextLight, inner sep=0pt, minimum size=1.4em,
      font=\scriptsize\bfseries]{\#};}%
      \hspace{6pt}#1},
  ]%
  \small\color{rbText}%
  \let\olditem\item
  \renewcommand{\item}{%
    \stepcounter{teach@wes}%
    \par\vskip3pt%
    {\bfseries\color{rbSecondary!80!black}Step~\theteach@wes.\hspace{4pt}}%
  }%
}{%
  \end{tcolorbox}%
}

% ----------------------------------------------------------------
% Key term — highlighted term card
%
%   \keyterm{Synapse}{The junction between two nerve cells,
%     across which impulses pass by diffusion of a neurotransmitter.}
% ----------------------------------------------------------------

\newcommand{\keyterm}[2]{%
  \begin{tcolorbox}[
    enhanced, colback=rbPrimary!5!white, colframe=rbPrimary!5!white,
    boxrule=0pt, borderline west={3pt}{0pt}{rbPrimary},
    sharp corners,
    left=8pt, right=8pt, top=5pt, bottom=5pt,
  ]
    {\bfseries\color{rbPrimary}#1\par}%
    \vskip2pt{\small\color{rbText}#2\par}%
  \end{tcolorbox}%
}

% ----------------------------------------------------------------
% Key terms frame — glossary-style multi-term layout
%
%   \begin{keytermsframe}{Key Terms}
%     \keytermentry{Synapse}{Junction between two nerve cells}
%     \keytermentry{Axon}{Long projection of a nerve cell}
%   \end{keytermsframe}
% ----------------------------------------------------------------

\newenvironment{keytermsframe}[1][Key Terms]{%
  \begin{frame}{#1}%
}{%
  \end{frame}%
}

\newcommand{\keytermentry}[2]{%
  \par\vskip4pt%
  \begin{minipage}[t]{0.25\textwidth}\raggedleft
    {\small\bfseries\color{rbPrimary}#1}%
  \end{minipage}\hspace{8pt}%
  \begin{minipage}[t]{0.68\textwidth}%
    {\small\color{rbText}#2}%
  \end{minipage}%
  \par\vskip2pt{\color{rbRule!50}\hrule height 0.2pt}%
}

% ----------------------------------------------------------------
% Exam question — formatted exam-style question
%
%   \examquestion[10]{Describe the stages of mitosis,
%     including the key events at each stage.}
% ----------------------------------------------------------------

\newcommand{\examquestion}[2][]{%
  \begin{tcolorbox}[
    enhanced, colback=rbBg, colframe=rbBg, boxrule=0pt,
    borderline west={3pt}{0pt}{rbAccentDark},
    sharp corners,
    left=8pt, right=8pt, top=6pt, bottom=6pt,
  ]
    \ifx\relax#1\relax\else
      {\scriptsize\bfseries\color{rbAccentDark}%
        \hfill[#1~mark\ifnum#1>1 s\fi]\par\vskip2pt}%
    \fi
    {\color{rbText}#2\par}%
  \end{tcolorbox}%
}

% ----------------------------------------------------------------
% Think–Pair–Share — activity prompt slide
%
%   \thinkpairshare{What are the ethical implications of
%     genetic screening in the workplace?}
% ----------------------------------------------------------------

\newcommand{\thinkpairshare}[1]{%
  \begin{frame}[c,plain]{}
    \begin{tikzpicture}[remember picture, overlay]
      \fill[rbPrimary!5!white]
        (current page.south west) rectangle (current page.north east);
    \end{tikzpicture}%
    \centering\vfill
    \tikz\node[circle, fill=rbPrimary, text=rbTextLight,
      inner sep=0pt, minimum size=2.4em,
      font=\large\bfseries]{?};%
    \par\vskip8pt%
    {\small\bfseries\color{rbAccentDark}\MakeUppercase{Think -- Pair -- Share}\par}%
    \vskip10pt%
    {\Large\color{rbPrimary}\itshape #1\par}%
    \vfill
  \end{frame}
}

% ----------------------------------------------------------------
% Recap environment — end-of-lecture summary box
%
%   \begin{recap}
%     \item The central dogma describes \ldots
%     \item Transcription occurs in \ldots
%   \end{recap}
% ----------------------------------------------------------------

\newcounter{teach@recap}
\newenvironment{recap}[1][Recap]{%
  \setcounter{teach@recap}{0}%
  \begin{tcolorbox}[
    enhanced, colback=rbPrimary!6!white, colframe=rbPrimary!6!white,
    boxrule=0pt, borderline west={3pt}{0pt}{rbPrimary},
    borderline south={2pt}{0pt}{rbAccent},
    sharp corners,
    left=8pt, right=8pt, top=6pt, bottom=6pt,
    fonttitle=\bfseries\color{rbPrimary},
    coltitle=rbPrimary,
    title={\raisebox{-0.1em}{\tikz\node[circle, fill=rbPrimary,
      text=rbTextLight, inner sep=0pt, minimum size=1.4em,
      font=\scriptsize\bfseries]{$\Sigma$};}%
      \hspace{6pt}#1},
  ]%
  \small\color{rbText}%
  \let\olditem\item
  \renewcommand{\item}{%
    \stepcounter{teach@recap}%
    \par\vskip3pt%
    {\bfseries\color{rbPrimary}\theteach@recap.\hspace{4pt}}%
  }%
}{%
  \end{tcolorbox}%
}

% ----------------------------------------------------------------
% Reading list environment + reading entry
%
%   \begin{readinglist}
%     \readingentry{Smith, J.}{2023}
%       {Introduction to Neuroscience}
%       {Oxford University Press, Ch.~3--5}
%     \readingentry{Jones, A.}{2021}
%       {Cognitive Psychology: A Student's Handbook}
%       {Routledge, pp.~110--145}
%   \end{readinglist}
% ----------------------------------------------------------------

\newenvironment{readinglist}[1][Recommended Reading]{%
  \begin{tcolorbox}[
    enhanced, colback=rbBg, colframe=rbBg, boxrule=0pt,
    borderline west={3pt}{0pt}{rbSecondary},
    sharp corners,
    left=8pt, right=8pt, top=6pt, bottom=6pt,
    fonttitle=\bfseries\color{rbSecondary!80!black},
    coltitle=rbSecondary!80!black,
    title={\raisebox{-0.1em}{\tikz\node[circle, fill=rbSecondary,
      text=rbTextLight, inner sep=0pt, minimum size=1.4em,
      font=\scriptsize\bfseries]{\textsc{r}};}%
      \hspace{6pt}#1},
  ]%
  \small\color{rbText}%
}{%
  \end{tcolorbox}%
}

\newcommand{\readingentry}[4]{%
  \par\vskip4pt%
  {\color{rbText}#1 (#2).\hspace{3pt}%
    \textit{#3}.\hspace{3pt}%
    {\color{rbTextMuted}#4}\par}%
}

% ----------------------------------------------------------------
\endinput
