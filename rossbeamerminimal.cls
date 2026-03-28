% rossbeamerminimal.cls
% Minimal Beamer class — deliberately sparse, text-focused presentations.
% Inspired by Tufte and Butterick: generous whitespace, no decoration,
% muted colour, restrained typography.
%
% Usage:
%   \documentclass[palette=minimal]{rossbeamerminimal}
%
% Available palettes:
%   minimal (default) — near-white background, dark text, single muted accent
%   tufte             — warm cream background, dark brown text
%   ink               — pure white background, pure black text
%
% Options:
%   palette=<name>   font=<fira|inter|sourcesans|libertinus|heros|georgia|system>
%   monofont=<name>
%
% The nobar flag is always forced on. There is no progress bar.
%
% Ross Dunne / Claude, 2026

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{rossbeamerminimal}[2026/03/24 Minimal Beamer class]

% ----------------------------------------------------------------
% Option handling
% ----------------------------------------------------------------

\RequirePackage{pgfkeys}
\RequirePackage{pgfopts}

\newif\ifrb@nobar
\newif\ifrb@nologo

% Force nobar on — this class never shows a progress bar
\rb@nobartrue
\rb@nologotrue

\pgfkeys{
  /minbeamer/.cd,
  palette/.store in=\min@palette,   palette=minimal,
  font/.store in=\min@fontchoice,   font=fira,
  monofont/.store in=\min@mono,     monofont=,
}
\ProcessPgfOptions{/minbeamer}

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
% \min@defpal{name}
%   {primary}{secondary}{accent}{text}{textlight}{textmuted}{bg}{rule}
%   {accentdark}{accentlight}{accentbg}{lightmuted}
% ----------------------------------------------------------------

\newcommand{\min@defpal}[9]{%
  \expandafter\def\csname min@p@#1@P\endcsname{#2}%   primary
  \expandafter\def\csname min@p@#1@S\endcsname{#3}%   secondary
  \expandafter\def\csname min@p@#1@A\endcsname{#4}%   accent
  \expandafter\def\csname min@p@#1@T\endcsname{#5}%   text
  \expandafter\def\csname min@p@#1@TL\endcsname{#6}%  textlight
  \expandafter\def\csname min@p@#1@TM\endcsname{#7}%  textmuted
  \expandafter\def\csname min@p@#1@B\endcsname{#8}%   bg
  \expandafter\def\csname min@p@#1@R\endcsname{#9}%   rule
  \min@defpal@cont{#1}%
}
\newcommand{\min@defpal@cont}[5]{%
  \expandafter\def\csname min@p@#1@AD\endcsname{#2}%  accentdark
  \expandafter\def\csname min@p@#1@AL\endcsname{#3}%  accentlight
  \expandafter\def\csname min@p@#1@AB\endcsname{#4}%  accentbg
  \expandafter\def\csname min@p@#1@LM\endcsname{#5}%  lightmuted
}

% minimal — near-white bg, dark text, single muted steel-blue accent
%                    name       P       S       A       T       TL      TM      B       R       AD      AL      AB      LM
\min@defpal{minimal} {3A3A3A}{6A6A6A}{7A8A9A}{2C2C2C}{FAFAFA}{9A9A9A}{FBFBFB}{E0E0E0}{5A6A7A}{A0B0C0}{F2F4F6}{B0B0B0}

% tufte — warm cream bg, dark brown text, earthy muted accent
\min@defpal{tufte}   {3E3228}{6B5D4F}{8A7A60}{33291F}{FAF6F0}{A09080}{FAF7F2}{E0D8CC}{6A5A40}{B0A080}{F5F0E8}{B8A898}

% ink — pure white bg, pure black text, no-nonsense grey accent
\min@defpal{ink}     {000000}{333333}{555555}{111111}{FFFFFF}{888888}{FFFFFF}{D0D0D0}{333333}{888888}{F0F0F0}{AAAAAA}

% ----------------------------------------------------------------
% Palette activation
% ----------------------------------------------------------------

\newcommand{\min@activatepalette}{%
  \definecolor{rbPrimary}{HTML}{\csname min@p@\min@palette @P\endcsname}%
  \definecolor{rbSecondary}{HTML}{\csname min@p@\min@palette @S\endcsname}%
  \definecolor{rbAccent}{HTML}{\csname min@p@\min@palette @A\endcsname}%
  \definecolor{rbText}{HTML}{\csname min@p@\min@palette @T\endcsname}%
  \definecolor{rbTextLight}{HTML}{\csname min@p@\min@palette @TL\endcsname}%
  \definecolor{rbTextMuted}{HTML}{\csname min@p@\min@palette @TM\endcsname}%
  \definecolor{rbBg}{HTML}{\csname min@p@\min@palette @B\endcsname}%
  \definecolor{rbRule}{HTML}{\csname min@p@\min@palette @R\endcsname}%
  \rb@derivecolors
  \definecolor{rbAccentDark}{HTML}{\csname min@p@\min@palette @AD\endcsname}%
  \definecolor{rbAccentLight}{HTML}{\csname min@p@\min@palette @AL\endcsname}%
  \definecolor{rbAccentBg}{HTML}{\csname min@p@\min@palette @AB\endcsname}%
  \definecolor{rbLightMuted}{HTML}{\csname min@p@\min@palette @LM\endcsname}%
}
\min@activatepalette

\newcommand{\setpalette}[1]{\def\min@palette{#1}\min@activatepalette}

% ----------------------------------------------------------------
% Beamer setup
% ----------------------------------------------------------------

\rb@setupbeamer
\setbeamersize{text margin left=15mm, text margin right=15mm}

% ----------------------------------------------------------------
% Override bullets — dashes, not dots
% ----------------------------------------------------------------

\setbeamertemplate{itemize item}{--}
\setbeamertemplate{itemize subitem}{--}
\setbeamercolor{itemize item}{fg=rbTextMuted}
\setbeamercolor{itemize subitem}{fg=rbTextMuted}
\setbeamertemplate{enumerate item}{\insertenumlabel.}
\setbeamercolor{enumerate item}{fg=rbTextMuted}

% ----------------------------------------------------------------
% No progress bar (already forced via \rb@nobartrue)
% Minimal footer — page number only, right-aligned
% ----------------------------------------------------------------

\setbeamertemplate{footline}{%
  \hfill%
  {\usebeamerfont{footline}\color{rbTextMuted}\insertframenumber}%
  \hskip15mm%
  \vskip5pt%
}

% ----------------------------------------------------------------
% Frame title — small, muted, no decoration
% ----------------------------------------------------------------

\setbeamerfont{frametitle}{size=\normalsize, series=\mdseries}
\setbeamerfont{framesubtitle}{size=\small, series=\mdseries}
\setbeamercolor{frametitle}{fg=rbTextMuted}
\setbeamercolor{framesubtitle}{fg=rbTextMuted}

\setbeamertemplate{frametitle}{%
  \vskip8pt%
  {\usebeamerfont{frametitle}\usebeamercolor[fg]{frametitle}%
    \MakeLowercase{\insertframetitle}}%
  \ifx\insertframesubtitle\empty\else
    \par\vskip1pt%
    {\usebeamerfont{framesubtitle}\usebeamercolor[fg]{framesubtitle}%
      \insertframesubtitle}%
  \fi
  \vskip6pt%
}

% ----------------------------------------------------------------
% Font activation
% ----------------------------------------------------------------

\rb@activatefont{\min@fontchoice}
\rb@activatemono{\min@mono}
\usefonttheme[onlymath]{serif}

% ----------------------------------------------------------------
% Title page — text only, no background fill, no decoration
% ----------------------------------------------------------------

\setbeamerfont{title}{size=\Large, series=\mdseries}
\setbeamerfont{subtitle}{size=\normalsize, series=\mdseries}
\setbeamerfont{author}{size=\small}
\setbeamerfont{institute}{size=\small}
\setbeamerfont{date}{size=\small}

\defbeamertemplate*{title page}{rossbeamerminimal}{%
  \vfill
  {\usebeamerfont{title}\color{rbText}\inserttitle\par}%
  \ifx\insertsubtitle\empty\else
    \vskip6pt{\usebeamerfont{subtitle}\color{rbTextMuted}\insertsubtitle\par}%
  \fi
  \vskip18pt%
  \ifx\insertauthor\empty\else
    {\usebeamerfont{author}\color{rbTextMuted}\insertauthor\par}%
  \fi
  \ifx\insertinstitute\empty\else
    \vskip2pt{\usebeamerfont{institute}\color{rbTextMuted}\insertinstitute\par}%
  \fi
  \ifx\insertdate\empty\else
    \vskip2pt{\usebeamerfont{date}\color{rbTextMuted}\insertdate\par}%
  \fi
  \vfill
}

% ================================================================
% DOMAIN FEATURES — deliberately sparse
% ================================================================

% ----------------------------------------------------------------
% \marginnote{text} — small text in the right margin via TikZ overlay
% ----------------------------------------------------------------

\newcommand{\marginnote}[1]{%
  \begin{tikzpicture}[remember picture, overlay]
    \node[anchor=north west, text width=25mm, inner sep=0pt,
          font=\scriptsize\color{rbTextMuted}]
      at ([xshift=2mm, yshift=0mm]current page.north east |- {pic cs:marginnote\the\value{page}})
      {#1};
  \end{tikzpicture}%
  \tikz[remember picture] \coordinate (marginnote\the\value{page});%
}
% Simpler fallback that always positions near the current text:
\renewcommand{\marginnote}[1]{%
  \smash{\rlap{\hspace{\dimexpr\textwidth+4mm\relax}%
    \parbox[t]{24mm}{\scriptsize\color{rbTextMuted}\RaggedRight #1}}}%
}

% ----------------------------------------------------------------
% \aside{text} — italicised aside in muted colour
% ----------------------------------------------------------------

\newcommand{\aside}[1]{%
  \par\vskip2pt{\small\itshape\color{rbTextMuted}#1\par}\vskip2pt%
}

% ----------------------------------------------------------------
% \wideimage{file}{caption} — full-width image with thin caption
% ----------------------------------------------------------------

\newcommand{\wideimage}[2]{%
  \par\vskip4pt%
  \begin{center}%
    \includegraphics[width=\linewidth]{#1}%
  \end{center}%
  \par\vskip1pt%
  {\scriptsize\color{rbTextMuted}#2\par}%
  \vskip4pt%
}

% ----------------------------------------------------------------
% \blankslide — completely empty frame
% ----------------------------------------------------------------

\newcommand{\blankslide}{%
  \begin{frame}[plain,c]{}%
  \end{frame}%
}

% ----------------------------------------------------------------
% \epigraph{quote}{author} — styled epigraph for opening frames
% ----------------------------------------------------------------

\newcommand{\epigraph}[2]{%
  \begin{frame}[c,plain]{}%
    \centering\vfill
    {\large\itshape\color{rbText}``#1''\par}%
    \vskip10pt%
    {\small\color{rbTextMuted}--- #2\par}%
    \vfill
  \end{frame}%
}

% ----------------------------------------------------------------
\endinput
