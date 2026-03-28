% rossbeamermaths.cls
% Mathematics Beamer class — blackboard aesthetics, theorem environments,
% proof layouts, equation highlighting, and step-by-step derivations.
%
% Usage:
%   \documentclass[palette=blackboard]{rossbeamermaths}
%
% Available palettes:
%   blackboard (default) — dark green board with chalk-white text
%   proof               — cream background with navy text
%   theorem             — blue/white clean academic style
%
% Options:
%   palette=<name>   font=<fira|inter|sourcesans|libertinus|heros|georgia|system>
%   monofont=<name>  nobar  nologo  chalkboard
%
% The chalkboard option overrides the normal text background to dark
% green with chalk-white foreground regardless of palette — useful for
% a "writing on the board" feel on every slide.
%
% Ross Dunne / Claude, 2026

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{rossbeamermaths}[2026/03/24 Mathematics Beamer class]

% ----------------------------------------------------------------
% Option handling
% ----------------------------------------------------------------

\RequirePackage{pgfkeys}
\RequirePackage{pgfopts}

% Pre-declare base flags so pgfkeys can set them
\newif\ifrb@nobar     \rb@nobarfalse
\newif\ifrb@nologo    \rb@nologofalse
\newif\ifmth@chalkboard \mth@chalkboardfalse

\pgfkeys{
  /mathbeamer/.cd,
  palette/.store in=\mth@palette,       palette=blackboard,
  font/.store in=\mth@fontchoice,       font=fira,
  monofont/.store in=\mth@mono,         monofont=,
  nobar/.code={\rb@nobartrue},
  nologo/.code={\rb@nologotrue},
  chalkboard/.is if=mth@chalkboard,
}
\ProcessPgfOptions{/mathbeamer}

\PassOptionsToClass{aspectratio=169}{beamer}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{beamer}}
\ProcessOptions\relax
\LoadClass{beamer}

% ----------------------------------------------------------------
% Load shared base
% ----------------------------------------------------------------

\RequirePackage{rossbeamerbase}

% ----------------------------------------------------------------
% Mathematics packages
% ----------------------------------------------------------------

\RequirePackage{amsmath}
\RequirePackage{amssymb}

% ----------------------------------------------------------------
% Palette definitions (12-field format)
%
% \mth@defpal{name}
%   {primary}{secondary}{accent}{text}{textlight}{textmuted}{bg}{rule}
%   {accentdark}{accentlight}{accentbg}{lightmuted}
% ----------------------------------------------------------------

\newcommand{\mth@defpal}[9]{%
  \expandafter\def\csname mth@p@#1@P\endcsname{#2}%   primary
  \expandafter\def\csname mth@p@#1@S\endcsname{#3}%   secondary
  \expandafter\def\csname mth@p@#1@A\endcsname{#4}%   accent
  \expandafter\def\csname mth@p@#1@T\endcsname{#5}%   text
  \expandafter\def\csname mth@p@#1@TL\endcsname{#6}%  textlight
  \expandafter\def\csname mth@p@#1@TM\endcsname{#7}%  textmuted
  \expandafter\def\csname mth@p@#1@B\endcsname{#8}%   bg
  \expandafter\def\csname mth@p@#1@R\endcsname{#9}%   rule
  \mth@defpal@cont{#1}%
}
\newcommand{\mth@defpal@cont}[5]{%
  \expandafter\def\csname mth@p@#1@AD\endcsname{#2}%  accentdark
  \expandafter\def\csname mth@p@#1@AL\endcsname{#3}%  accentlight
  \expandafter\def\csname mth@p@#1@AB\endcsname{#4}%  accentbg
  \expandafter\def\csname mth@p@#1@LM\endcsname{#5}%  lightmuted
}

%                       name         P       S       A       T       TL      TM      B       R       AD      AL      AB      LM
\mth@defpal{blackboard} {2E4A3E}{4A7A6A}{FFEE58}{F5F5DC}{F5F5DC}{A0B8A8}{2E4A3E}{5A8A6E}{C8B820}{FFEE58}{3A5A4A}{8AA898}
\mth@defpal{proof}      {1A2744}{3A5A80}{8B2332}{2C2420}{FFFDF5}{8A8070}{FFF8E8}{D8D0B8}{6A1A26}{A83848}{FFF0E8}{B0A890}
\mth@defpal{theorem}    {1A3A6B}{4A80B8}{D35400}{1C1C1C}{FFFFFF}{6A7888}{F4F8FC}{C8D8E8}{A04000}{E87530}{EAF0F8}{8898B0}

% ----------------------------------------------------------------
% Palette activation
% ----------------------------------------------------------------

\newcommand{\mth@activatepalette}{%
  % Core colours
  \definecolor{rbPrimary}{HTML}{\csname mth@p@\mth@palette @P\endcsname}%
  \definecolor{rbSecondary}{HTML}{\csname mth@p@\mth@palette @S\endcsname}%
  \definecolor{rbAccent}{HTML}{\csname mth@p@\mth@palette @A\endcsname}%
  \definecolor{rbText}{HTML}{\csname mth@p@\mth@palette @T\endcsname}%
  \definecolor{rbTextLight}{HTML}{\csname mth@p@\mth@palette @TL\endcsname}%
  \definecolor{rbTextMuted}{HTML}{\csname mth@p@\mth@palette @TM\endcsname}%
  \definecolor{rbBg}{HTML}{\csname mth@p@\mth@palette @B\endcsname}%
  \definecolor{rbRule}{HTML}{\csname mth@p@\mth@palette @R\endcsname}%
  % Derive standard colours
  \rb@derivecolors
  % Override with explicit palette refinements
  \definecolor{rbAccentDark}{HTML}{\csname mth@p@\mth@palette @AD\endcsname}%
  \definecolor{rbAccentLight}{HTML}{\csname mth@p@\mth@palette @AL\endcsname}%
  \definecolor{rbAccentBg}{HTML}{\csname mth@p@\mth@palette @AB\endcsname}%
  \definecolor{rbLightMuted}{HTML}{\csname mth@p@\mth@palette @LM\endcsname}%
  % Legacy aliases
  \colorlet{mthDark}{rbPrimary}%
  \colorlet{mthText}{rbText}%
  \colorlet{mthMuted}{rbTextMuted}%
  \colorlet{mthAccent}{rbAccent}%
  \colorlet{mthBg}{rbBg}%
}
\mth@activatepalette

\newcommand{\setpalette}[1]{\def\mth@palette{#1}\mth@activatepalette}

% ----------------------------------------------------------------
% Beamer setup
% ----------------------------------------------------------------

\rb@setupbeamer
\setbeamersize{text margin left=12mm, text margin right=12mm}

% Frame title with underline rule
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
\expandafter\rb@activatefont\expandafter{\mth@fontchoice}
\expandafter\rb@activatemono\expandafter{\mth@mono}
\usefonttheme[onlymath]{serif}

% Footer: always on
\rb@activatefooter

% ----------------------------------------------------------------
% Chalkboard mode
%
% When the chalkboard option is set, override normal text
% background to dark green and foreground to chalk white.
% ----------------------------------------------------------------

\ifmth@chalkboard
  \setbeamercolor{normal text}{fg=rbChalkWhite, bg=rbBoardGreen}%
  \setbeamercolor{frametitle}{fg=rbChalkWhite}%
  \setbeamercolor{framesubtitle}{fg=rbChalkWhite!70}%
  \setbeamercolor{itemize item}{fg=rbChalkYellow}%
  \setbeamercolor{itemize subitem}{fg=rbChalkWhite!60}%
  \setbeamercolor{enumerate item}{fg=rbChalkYellow}%
  \setbeamercolor{enumerate subitem}{fg=rbChalkWhite!60}%
  \setbeamercolor{block title}{fg=rbBoardGreen, bg=rbChalkYellow!80}%
  \setbeamercolor{block body}{fg=rbChalkWhite, bg=rbBoardGreen!80!black}%
\fi

% ----------------------------------------------------------------
% Title page — dark with accent rule
% ----------------------------------------------------------------

\defbeamertemplate*{title page}{rossbeamermaths}{%
  \begin{tikzpicture}[remember picture, overlay]
    \fill[rbPrimary] (current page.south west) rectangle (current page.north east);
    \fill[rbAccent]
      ([yshift=12mm]current page.south west) rectangle
      ([yshift=12.6mm]current page.south east);
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
  \vfill
}

% ================================================================
% MATHEMATICS-SPECIFIC FEATURES
% ================================================================

% ----------------------------------------------------------------
% Theorem counter (shared across theorem-like environments)
% ----------------------------------------------------------------

\newcounter{mth@thmcounter}
\AtBeginDocument{\setcounter{mth@thmcounter}{0}}

% ----------------------------------------------------------------
% Theorem environment
%   Numbered tcolorbox: "Theorem 1"
% ----------------------------------------------------------------

\newtcolorbox{mth@thmbox}[1][]{%
  enhanced, colback=rbAccentBg, colframe=rbAccentBg, boxrule=0pt,
  borderline west={3pt}{0pt}{rbAccent}, sharp corners,
  left=8pt, right=8pt, top=5pt, bottom=5pt,
  fonttitle=\small\bfseries\color{rbAccentDark},
  coltitle=rbAccentDark, title={#1},
}

\renewenvironment{theorem}[1][]{%
  \stepcounter{mth@thmcounter}%
  \def\mth@thmtitle{Theorem~\themth@thmcounter}%
  \ifx\relax#1\relax\else
    \def\mth@thmtitle{Theorem~\themth@thmcounter~(#1)}%
  \fi
  \begin{mth@thmbox}[\mth@thmtitle]%
}{%
  \end{mth@thmbox}%
}

% ----------------------------------------------------------------
% Lemma environment
% ----------------------------------------------------------------

\renewenvironment{lemma}[1][]{%
  \stepcounter{mth@thmcounter}%
  \def\mth@thmtitle{Lemma~\themth@thmcounter}%
  \ifx\relax#1\relax\else
    \def\mth@thmtitle{Lemma~\themth@thmcounter~(#1)}%
  \fi
  \begin{mth@thmbox}[\mth@thmtitle]%
}{%
  \end{mth@thmbox}%
}

% ----------------------------------------------------------------
% Corollary environment
% ----------------------------------------------------------------

\renewenvironment{corollary}[1][]{%
  \stepcounter{mth@thmcounter}%
  \def\mth@thmtitle{Corollary~\themth@thmcounter}%
  \ifx\relax#1\relax\else
    \def\mth@thmtitle{Corollary~\themth@thmcounter~(#1)}%
  \fi
  \begin{mth@thmbox}[\mth@thmtitle]%
}{%
  \end{mth@thmbox}%
}

% ----------------------------------------------------------------
% Definition environment (different colour — uses rbInfo tones)
% ----------------------------------------------------------------

\newtcolorbox{mth@defbox}[1][]{%
  enhanced, colback=rbInfoBg, colframe=rbInfoBg, boxrule=0pt,
  borderline west={3pt}{0pt}{rbInfo}, sharp corners,
  left=8pt, right=8pt, top=5pt, bottom=5pt,
  fonttitle=\small\bfseries\color{rbInfo},
  coltitle=rbInfo, title={#1},
}

\renewenvironment{definition}[1][]{%
  \stepcounter{mth@thmcounter}%
  \def\mth@thmtitle{Definition~\themth@thmcounter}%
  \ifx\relax#1\relax\else
    \def\mth@thmtitle{Definition~\themth@thmcounter~(#1)}%
  \fi
  \begin{mth@defbox}[\mth@thmtitle]%
}{%
  \end{mth@defbox}%
}

% ----------------------------------------------------------------
% Proof environment (with QED symbol at end)
% ----------------------------------------------------------------

\newtcolorbox{mth@proofbox}[1][]{%
  enhanced, colback=rbBg, colframe=rbBg, boxrule=0pt,
  borderline west={2pt}{0pt}{rbTextMuted}, sharp corners,
  left=8pt, right=8pt, top=5pt, bottom=5pt,
  fonttitle=\small\itshape\color{rbText},
  coltitle=rbText, title={#1},
}

\renewenvironment{proof}[1][Proof]{%
  \begin{mth@proofbox}[#1.]%
}{%
  \hfill\QED
  \end{mth@proofbox}%
}

% ----------------------------------------------------------------
% QED — tombstone symbol
% ----------------------------------------------------------------

\newcommand{\QED}{%
  \ensuremath{\blacksquare}%
}

% ----------------------------------------------------------------
% Proof sketch environment — informal proof outline
% ----------------------------------------------------------------

\newenvironment{proofsketch}[1][Proof sketch]{%
  \begin{mth@proofbox}[\textit{#1}.]%
}{%
  \hfill\ensuremath{\diamond}%
  \end{mth@proofbox}%
}

% ----------------------------------------------------------------
% Equation highlighting
%   \eqhl[colour]{math} — highlight a term in an equation
% ----------------------------------------------------------------

\newcommand{\eqhl}[2][rbAccent]{%
  \tikz[baseline=(X.base)]{%
    \node[fill=#1!15, inner sep=1.5pt, rounded corners=1pt] (X)
      {$\displaystyle #2$};}%
}

% ----------------------------------------------------------------
% eqbox environment — boxed equation with optional label
% ----------------------------------------------------------------

\newtcolorbox{eqbox}[1][]{%
  enhanced, colback=rbBg, colframe=rbRule,
  boxrule=0.4pt, sharp corners,
  left=4pt, right=4pt, top=4pt, bottom=4pt,
  fonttitle=\scriptsize\color{rbTextMuted},
  coltitle=rbTextMuted, title={#1},
}

% ----------------------------------------------------------------
% \step{content} — numbered steps for step-by-step proofs
% ----------------------------------------------------------------

\newcounter{mth@stepcounter}

\newcommand{\resetsteps}{\setcounter{mth@stepcounter}{0}}

\newcommand{\step}[1]{%
  \stepcounter{mth@stepcounter}%
  \par\vskip3pt%
  {\small\bfseries\color{rbAccent}Step~\themth@stepcounter.\hspace{4pt}}%
  {\color{rbText}#1}%
}

% ----------------------------------------------------------------
% Backup slides
% ----------------------------------------------------------------

\newcommand{\backupslides}{%
  \appendix
  \begin{darkframe}[c,plain]
    \centering
    {\usebeamerfont{title}\color{rbTextLight}Backup Slides\par}%
    \vskip6pt{\normalsize\color{rbLightMuted}Additional proofs and computations\par}
  \end{darkframe}
}

% ----------------------------------------------------------------
\endinput
