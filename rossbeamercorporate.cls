% claudeslides.cls
% A Beamer class replicating the design system used by the pptxgenjs
% presentation skill: bold palettes, dark/light sandwich structure,
% typography hierarchy, and clean modern layout.
%
% Usage:
%   \documentclass[palette=midnight]{claudeslides}
%
% Available palettes:
%   Core palettes:
%     midnight, forest, coral, terracotta, ocean, charcoal,
%     teal, berry, sage, cherry
%   Institutional/Scientific palettes:
%     uom, slate, evergreen, oxford, lancet, nhs, economist,
%     nature, nejm, cambridge, imperial, jama, bmj, cell,
%     copper, rose, graphite
%   Corporate/Business palettes:
%     obsidian, nordic, ember, indigo, ivory, plum, steel,
%     moss, bordeaux, arctic, saffron, dusk
%
% Available options:
%   palette=<name>       Colour palette (default: midnight)
%   font=<name>          Font family: fira, inter, sourcesans,
%                        libertinus, heros, system (default: fira)
%   monofont=<name>      Monospace font name (default: auto-detect)
%   darkmode             Invert to dark primary background
%   nobar                Disable progress bar
%   nologo               Disable logo rendering
%
% PowerPoint-like layouts:
%   \titleonlyframe      Title-only slide
%   comparison env       Side-by-side comparison
%   pictureframe env     Picture with caption
%   captionframe env     Content with caption sidebar
%   \quoteslide          Quote / statement slide
%   \fullbleedimage      Full-bleed image slide
%
% Ross Dunne / Claude, 2026

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{claudeslides}[2026/03/21 Claude presentation style for Beamer]

% ----------------------------------------------------------------
% Option handling
% ----------------------------------------------------------------

\RequirePackage{pgfkeys}
\RequirePackage{pgfopts}

\newif\ifcs@darkmode  \cs@darkmodefalse
\newif\ifcs@nobar     \cs@nobarfalse
\newif\ifcs@nologo    \cs@nologofalse

\pgfkeys{
  /claudeslides/.cd,
  palette/.store in=\cs@palette,
  palette=midnight,
  font/.store in=\cs@fontchoice,
  font=fira,
  monofont/.store in=\cs@monofontchoice,
  monofont=,
  darkmode/.is if=cs@darkmode,
  nobar/.code={\cs@nobartrue},
  nologo/.code={\cs@nologotrue},
}

% Storage for custom system font name (used when font=system)
\def\cs@customfontname{}
\newcommand{\customfontname}[1]{\def\cs@customfontname{#1}}

\ProcessPgfOptions{/claudeslides}

% Pass 16:9 aspect ratio and any remaining options to beamer
\PassOptionsToClass{aspectratio=169}{beamer}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{beamer}}
\ProcessOptions\relax
\LoadClass{beamer}

% ----------------------------------------------------------------
% Required packages
% ----------------------------------------------------------------

\RequirePackage{xcolor}
\RequirePackage{colortbl}
\RequirePackage{tikz}
\RequirePackage{calc}
\RequirePackage{etoolbox}
\RequirePackage{fontspec}     % requires xelatex or lualatex
\RequirePackage{tcolorbox}
\tcbuselibrary{skins,breakable}
\RequirePackage{graphicx}
\RequirePackage{ragged2e}
\RequirePackage{booktabs}
\RequirePackage{subcaption}
\RequirePackage{appendixnumberbeamer}
\RequirePackage{attachfile2}

% ----------------------------------------------------------------
% Colour palettes
% Each palette defines: primary, secondary, accent, textdark,
% textlight, textmuted
% ----------------------------------------------------------------

\newcommand{\cs@definepalette}[7]{%
  \expandafter\def\csname cs@pal@#1@primary\endcsname{#2}%
  \expandafter\def\csname cs@pal@#1@secondary\endcsname{#3}%
  \expandafter\def\csname cs@pal@#1@accent\endcsname{#4}%
  \expandafter\def\csname cs@pal@#1@textdark\endcsname{#5}%
  \expandafter\def\csname cs@pal@#1@textlight\endcsname{#6}%
  \expandafter\def\csname cs@pal@#1@textmuted\endcsname{#7}%
}

%                        name        primary   secondary accent    textdark  textlight textmuted
\cs@definepalette{midnight}    {1E2761}{CADCFC}{FFFFFF}{1E2761}{FFFFFF}{8090B0}
\cs@definepalette{forest}      {2C5F2D}{97BC62}{F5F5F5}{2C3E28}{FFFFFF}{7A9A7B}
\cs@definepalette{coral}       {F96167}{F9E795}{2F3C7E}{2F3C7E}{FFFFFF}{8890B0}
\cs@definepalette{terracotta}  {B85042}{E7E8D1}{A7BEAE}{3E2218}{FFFFFF}{8A7068}
\cs@definepalette{ocean}       {065A82}{1C7293}{21295C}{0A2540}{FFFFFF}{6A8FA0}
\cs@definepalette{charcoal}    {36454F}{F2F2F2}{212121}{212121}{FFFFFF}{808890}
\cs@definepalette{teal}        {028090}{00A896}{02C39A}{023E48}{FFFFFF}{60A0A8}
\cs@definepalette{berry}       {6D2E46}{A26769}{ECE2D0}{3E1828}{FFFFFF}{A08090}
\cs@definepalette{sage}        {84B59F}{69A297}{50808E}{2A3E34}{FFFFFF}{708880}
\cs@definepalette{cherry}      {990011}{FCF6F5}{2F3C7E}{2F1018}{FFFFFF}{907078}
% Additional institutional/scientific-inspired palettes
\cs@definepalette{uom}         {660099}{9A4DBE}{FFC300}{2B0A3D}{FFFFFF}{A084BA}
\cs@definepalette{slate}       {3B6B8A}{5A8AA8}{3B6B8A}{1E2A38}{FFFFFF}{7A90A8}
\cs@definepalette{evergreen}   {2D6A4F}{40916C}{7FB069}{1A2E1A}{FFFFFF}{66957D}
\cs@definepalette{oxford}      {002147}{1A3A60}{DAA520}{002147}{FFFFFF}{6B8FA0}
\cs@definepalette{lancet}      {A4243B}{D4384F}{E7B4B9}{1A1A2E}{FFFFFF}{9A7A80}
\cs@definepalette{nhs}         {005EB8}{41B6E6}{005EB8}{003087}{FFFFFF}{6A8FA0}
\cs@definepalette{economist}   {E3120B}{F04840}{E8B4B0}{1F1F1F}{FFFFFF}{8A7A78}
\cs@definepalette{nature}      {0072B2}{3498D8}{0072B2}{15202B}{FFFFFF}{6A8FA0}
\cs@definepalette{nejm}        {8B2332}{A83848}{E6B9BF}{2A1520}{FFFFFF}{A08090}
\cs@definepalette{cambridge}   {5B8FA8}{7AAFC5}{5B8FA8}{1A2930}{FFFFFF}{7B9FA8}
% Ported from scibeamer (scientific class)
\cs@definepalette{imperial}    {002147}{1A3A60}{D35400}{002147}{FFFFFF}{6B8FA0}
\cs@definepalette{jama}        {7A2E40}{9A4858}{5C2030}{2C2420}{FFFFFF}{A89888}
\cs@definepalette{bmj}         {2E6FA0}{4A8CC0}{1E5080}{1B2838}{FFFFFF}{90A8C0}
\cs@definepalette{cell}        {1A1A40}{9898B8}{C8960C}{1A1A40}{FFFFFF}{9898B8}
\cs@definepalette{copper}      {B45A28}{D07040}{8A4018}{1A1A1A}{FFFFFF}{B0A098}
\cs@definepalette{rose}        {C25B78}{D87898}{9A4060}{2A1822}{FFFFFF}{C0A0B0}
\cs@definepalette{graphite}    {404040}{606060}{2A2A2A}{1A1A1A}{FFFFFF}{A0A0A0}
% Corporate / business palettes
\cs@definepalette{obsidian}    {1A1A1A}{2E2E2E}{C9A84C}{1A1A1A}{FFFFFF}{8A8A8A}
\cs@definepalette{nordic}      {4A6274}{6E8898}{3A8E8E}{2A3A48}{FFFFFF}{8098A8}
\cs@definepalette{ember}       {8B3A0A}{C06020}{E8A020}{2A1A0A}{FFFFFF}{A08868}
\cs@definepalette{indigo}      {283593}{3F51B5}{448AFF}{1A1A3E}{FFFFFF}{8088B8}
\cs@definepalette{ivory}       {2C3E6B}{8090B0}{B8985A}{2C3E6B}{FFFFFF}{8090A8}
\cs@definepalette{plum}        {4A1A5E}{7B3F9E}{C8A0D8}{2A1038}{FFFFFF}{A888B8}
\cs@definepalette{steel}       {4A5568}{718096}{DD6B20}{2D3748}{FFFFFF}{8898A8}
\cs@definepalette{moss}        {5A6B3C}{8A9B6C}{B07848}{2A3018}{FFFFFF}{889878}
\cs@definepalette{bordeaux}    {5A1028}{8A3048}{C9A84C}{2A0818}{FFFFFF}{A88898}
\cs@definepalette{arctic}      {A8D0E6}{C8E4F4}{1A3A60}{1A3A60}{FFFFFF}{7898B0}
\cs@definepalette{saffron}     {1A2744}{3A4A6E}{E8A820}{1A2744}{FFFFFF}{7888A8}
\cs@definepalette{dusk}        {4A3F5E}{6E6088}{E87070}{2A2038}{FFFFFF}{9888A8}

% Activate the chosen palette
\newcommand{\cs@activatepalette}{%
  \definecolor{csPrimary}{HTML}{\csname cs@pal@\cs@palette @primary\endcsname}%
  \definecolor{csSecondary}{HTML}{\csname cs@pal@\cs@palette @secondary\endcsname}%
  \definecolor{csAccent}{HTML}{\csname cs@pal@\cs@palette @accent\endcsname}%
  \definecolor{csTextDark}{HTML}{\csname cs@pal@\cs@palette @textdark\endcsname}%
  \definecolor{csTextLight}{HTML}{\csname cs@pal@\cs@palette @textlight\endcsname}%
  \definecolor{csTextMuted}{HTML}{\csname cs@pal@\cs@palette @textmuted\endcsname}%
  % Derived colours
  \colorlet{csPrimaryLight}{csPrimary!15!white}%
  \colorlet{csPrimaryFaded}{csPrimary!8!white}%
  \colorlet{csSecondaryDark}{csSecondary!70!black}%
}
\cs@activatepalette

% Convenience: switch palette mid-document if needed
\newcommand{\setpalette}[1]{%
  \def\cs@palette{#1}%
  \cs@activatepalette
}

% ----------------------------------------------------------------
% Typography — switchable via font= option
%
% Available fonts:
%   font=fira        Fira Sans (default) — humanist, excellent legibility
%   font=inter       Inter — clean geometric, great for data-heavy slides
%   font=sourcesans  Source Sans 3 — Adobe's workhorse sans-serif
%   font=libertinus  Libertinus Sans — pairs well with math content
%   font=heros       TeX Gyre Heros — Helvetica metric-compatible fallback
%   font=georgia     Georgia / TeX Gyre Schola (original corporate default)
%
% Any system font:
%   font=system      then set \customfontname{Roboto} in preamble
%                    (or any font name visible to fontspec/fontconfig)
%
% Monospace font (for code listings):
%   monofont=Fira Code      or any monospace system font
%   If omitted, uses Fira Code > TeX Gyre Cursor as default.
% ----------------------------------------------------------------

\newcommand{\cs@setfont@fira}{%
  \IfFontExistsTF{Fira Sans}{%
    \setsansfont{Fira Sans}[
      BoldFont = {Fira Sans SemiBold},
      ItalicFont = {Fira Sans Italic},
      BoldItalicFont = {Fira Sans SemiBold Italic},
    ]%
  }{\setsansfont{TeX Gyre Heros}}%
}

\newcommand{\cs@setfont@inter}{%
  \IfFontExistsTF{Inter}{%
    \setsansfont{Inter}[
      BoldFont = {Inter SemiBold},
      ItalicFont = {Inter Italic},
      BoldItalicFont = {Inter SemiBold Italic},
    ]%
  }{\setsansfont{TeX Gyre Heros}}%
}

\newcommand{\cs@setfont@sourcesans}{%
  \IfFontExistsTF{Source Sans 3}{%
    \setsansfont{Source Sans 3}%
  }{%
    \IfFontExistsTF{Source Sans Pro}{%
      \setsansfont{Source Sans Pro}%
    }{\setsansfont{TeX Gyre Heros}}%
  }%
}

\newcommand{\cs@setfont@libertinus}{%
  \IfFontExistsTF{Libertinus Sans}{%
    \setsansfont{Libertinus Sans}%
  }{\setsansfont{TeX Gyre Heros}}%
}

\newcommand{\cs@setfont@heros}{%
  \setsansfont{TeX Gyre Heros}%
}

\newcommand{\cs@setfont@georgia}{%
  \IfFontExistsTF{Georgia}{%
    \setmainfont{Georgia}%
  }{\setmainfont{TeX Gyre Schola}}%
  \setsansfont{TeX Gyre Heros}%
}

% Activate the chosen font
\def\cs@tmp@fira{fira}
\def\cs@tmp@inter{inter}
\def\cs@tmp@sourcesans{sourcesans}
\def\cs@tmp@libertinus{libertinus}
\def\cs@tmp@heros{heros}
\def\cs@tmp@georgia{georgia}
\def\cs@tmp@system{system}

\ifx\cs@fontchoice\cs@tmp@inter
  \cs@setfont@inter
\else\ifx\cs@fontchoice\cs@tmp@sourcesans
  \cs@setfont@sourcesans
\else\ifx\cs@fontchoice\cs@tmp@libertinus
  \cs@setfont@libertinus
\else\ifx\cs@fontchoice\cs@tmp@heros
  \cs@setfont@heros
\else\ifx\cs@fontchoice\cs@tmp@georgia
  \cs@setfont@georgia
\else\ifx\cs@fontchoice\cs@tmp@system
  % Deferred: \customfontname{} must be called in preamble.
  % Applied at \begin{document} so the preamble has time to set it.
  \AtBeginDocument{%
    \ifx\cs@customfontname\empty
      \ClassWarning{claudeslides}{font=system used but \string\customfontname\space not set. Falling back to TeX Gyre Heros.}%
      \setsansfont{TeX Gyre Heros}%
    \else
      \IfFontExistsTF{\cs@customfontname}{%
        \setsansfont{\cs@customfontname}%
      }{%
        \ClassWarning{claudeslides}{Font '\cs@customfontname' not found. Falling back to TeX Gyre Heros.}%
        \setsansfont{TeX Gyre Heros}%
      }%
    \fi
  }%
\else
  \cs@setfont@fira
\fi\fi\fi\fi\fi\fi

% Monospace font (for code, listings, verbatim)
\ifx\cs@monofontchoice\empty
  \IfFontExistsTF{Fira Code}{%
    \setmonofont{Fira Code}[Scale=0.85]%
  }{%
    \IfFontExistsTF{TeX Gyre Cursor}{%
      \setmonofont{TeX Gyre Cursor}[Scale=0.85]%
    }{}%
  }%
\else
  \IfFontExistsTF{\cs@monofontchoice}{%
    \setmonofont{\cs@monofontchoice}[Scale=0.85]%
  }{%
    \ClassWarning{claudeslides}{Monospace font '\cs@monofontchoice' not found. Using default.}%
  }%
\fi

% Size hierarchy (approximate pptx points in beamer's smaller canvas)
% Title slide: 36-44pt -> \Huge
% Frame title: 20-24pt -> \Large
% Body: 14-16pt -> \normalsize (beamer default ~11pt scaled)
% Captions: 10-12pt -> \small / \footnotesize

% ----------------------------------------------------------------
% Beamer theme settings
% ----------------------------------------------------------------

\usetheme{default}
\useinnertheme{default}
\useoutertheme{default}

% Strip all default navigation chrome
\setbeamertemplate{navigation symbols}{}
\setbeamertemplate{footline}{}
\setbeamertemplate{headline}{}

% ----------------------------------------------------------------
% Frame geometry
% Beamer 16:9 gives 160mm x 90mm. The pptx spec asks for 0.5in
% (12.7mm) margins. Beamer's default text margin is ~8mm.
% ----------------------------------------------------------------

\setbeamersize{text margin left=12.7mm, text margin right=12.7mm}

% ----------------------------------------------------------------
% Colour assignments
% ----------------------------------------------------------------

% Content frames: light background
\setbeamercolor{normal text}{fg=csTextDark, bg=white}
\setbeamercolor{frametitle}{fg=csPrimary, bg=white}
\setbeamercolor{framesubtitle}{fg=csTextMuted}
\setbeamercolor{itemize item}{fg=csPrimary}
\setbeamercolor{itemize subitem}{fg=csSecondaryDark}
\setbeamercolor{enumerate item}{fg=csPrimary}
\setbeamercolor{enumerate subitem}{fg=csSecondaryDark}
\setbeamercolor{description item}{fg=csTextDark}
\setbeamercolor{caption name}{fg=csTextMuted}
\setbeamercolor{block title}{fg=csTextLight, bg=csPrimary}
\setbeamercolor{block body}{fg=csTextDark, bg=csPrimaryFaded}
\setbeamercolor{block title alerted}{fg=csTextLight, bg=csAccent}
\setbeamercolor{block body alerted}{fg=csTextDark, bg=csAccent!8!white}
\setbeamercolor{block title example}{fg=csTextLight, bg=csSecondaryDark}
\setbeamercolor{block body example}{fg=csTextDark, bg=csSecondary!15!white}

% Bullet shapes
\setbeamertemplate{itemize item}{\tikz\draw[fill=csPrimary,draw=none] (0,0) circle (0.08);}
\setbeamertemplate{itemize subitem}{\tikz\draw[fill=csSecondaryDark,draw=none] (0,0) circle (0.06);}
\setbeamertemplate{enumerate item}{\insertenumlabel.}
\setbeamerfont{enumerate item}{series=\bfseries}

% ----------------------------------------------------------------
% Frame title template
% Left-aligned, no underline (the skill spec explicitly forbids
% accent lines under titles as "a hallmark of AI-generated slides").
% ----------------------------------------------------------------

\setbeamertemplate{frametitle}{%
  \vskip4pt%
  {\usebeamerfont{frametitle}\usebeamercolor[fg]{frametitle}\insertframetitle}%
  \ifx\insertframesubtitle\empty\else
    \par\vskip1pt%
    {\usebeamerfont{framesubtitle}\usebeamercolor[fg]{framesubtitle}\insertframesubtitle}%
  \fi
}

\setbeamerfont{frametitle}{size=\Large, series=\bfseries}
\setbeamerfont{framesubtitle}{size=\small, series=\mdseries}

% Body text: left-aligned (ragged right)
\apptocmd{\frame}{}{}{}
\AtBeginDocument{\RaggedRight}

% ----------------------------------------------------------------
% Slide master: logo, footer text, short title
%
% Configure in preamble:
%   \slidelogo{logo.png}        or \slidelogo[height=6mm]{logo.png}
%   \footertext{Company Name}
%   \slidenote{Confidential}    (optional right-footer note)
%   \logoposition{bottomright}  (bottomleft, bottomright, topleft, topright)
% ----------------------------------------------------------------

% Storage macros
\def\cs@logo{}
\def\cs@logoheight{6mm}
\def\cs@footertext{}
\def\cs@slidenote{}

% Logo position: bottomleft (default), bottomright, topleft, topright
\def\cs@logopos{bottomleft}
\newcommand{\logoposition}[1]{\def\cs@logopos{#1}}

\newcommand{\slidelogo}[2][height=6mm]{%
  \def\cs@logo{#2}%
  \def\cs@logoopts{#1}%
}
\newcommand{\footertext}[1]{\def\cs@footertext{#1}}
\newcommand{\slidenote}[1]{\def\cs@slidenote{#1}}

% ----------------------------------------------------------------
% Footer: slide number (left), footer text (centre), note (right)
% Plus logo placement.
% Enable with \enablefooter in preamble.
% ----------------------------------------------------------------

\newcommand{\enablefooter}{%
  \setbeamertemplate{footline}{%
    \ifcs@nologo\else
      \ifx\cs@logo\empty\else
        \begin{tikzpicture}[remember picture, overlay]
          \ifx\cs@logopos\empty\def\cs@logopos{bottomleft}\fi
          \def\cs@bl{bottomleft}\def\cs@br{bottomright}%
          \def\cs@tl{topleft}\def\cs@tr{topright}%
          \ifx\cs@logopos\cs@bl
            \node[anchor=south west, inner sep=0pt]
              at ([xshift=10mm, yshift=4mm]current page.south west)
              {\includegraphics[\cs@logoopts]{\cs@logo}};%
          \fi
          \ifx\cs@logopos\cs@br
            \node[anchor=south east, inner sep=0pt]
              at ([xshift=-10mm, yshift=4mm]current page.south east)
              {\includegraphics[\cs@logoopts]{\cs@logo}};%
          \fi
          \ifx\cs@logopos\cs@tl
            \node[anchor=north west, inner sep=0pt]
              at ([xshift=10mm, yshift=-4mm]current page.north west)
              {\includegraphics[\cs@logoopts]{\cs@logo}};%
          \fi
          \ifx\cs@logopos\cs@tr
            \node[anchor=north east, inner sep=0pt]
              at ([xshift=-10mm, yshift=-4mm]current page.north east)
              {\includegraphics[\cs@logoopts]{\cs@logo}};%
          \fi
        \end{tikzpicture}%
      \fi
    \fi
    \hbox to \paperwidth{%
      \hskip12.7mm%
      {\usebeamerfont{footline}\color{csTextMuted}%
        \insertframenumber\,/\,\inserttotalframenumber}%
      \hfill%
      {\usebeamerfont{footline}\color{csTextMuted}\cs@footertext}%
      \hfill%
      {\usebeamerfont{footline}\color{csTextMuted}\cs@slidenote}%
      \hskip12.7mm%
    }%
    \vskip3pt%
  }%
}
\setbeamerfont{footline}{size=\tiny}

% ----------------------------------------------------------------
% Progress bar (thin line at very top of slide)
% Disable with class option: nobar
% ----------------------------------------------------------------

\ifcs@nobar\else
  \addtobeamertemplate{headline}{}{%
    \begin{tikzpicture}[remember picture, overlay]
      % track
      \fill[csTextMuted!30]
        (current page.north west) rectangle
        ([yshift=-1.8pt]current page.north east);
      % filled portion
      \ifnum\inserttotalframenumber>0
        \pgfmathsetmacro{\progresswidth}{%
          \paperwidth * \insertframenumber / \inserttotalframenumber}%
        \fill[csPrimary]
          (current page.north west) rectangle
          ([xshift=\progresswidth pt, yshift=-1.2pt]current page.north west);
      \fi
    \end{tikzpicture}%
  }
\fi

% ----------------------------------------------------------------
% Dark frame environment
% Used for title slides, section dividers, and conclusion slides
% (the "sandwich" structure).
% ----------------------------------------------------------------

\newenvironment{darkframe}[1][]{%
  \begingroup
  \setbeamercolor{normal text}{fg=csTextLight, bg=csPrimary}%
  \setbeamercolor{frametitle}{fg=csTextLight, bg=csPrimary}%
  \setbeamercolor{framesubtitle}{fg=csTextMuted!50!csTextLight}%
  \setbeamercolor{itemize item}{fg=csAccent}%
  \setbeamercolor{itemize subitem}{fg=csSecondary}%
  \setbeamercolor{enumerate item}{fg=csAccent}%
  \usebeamercolor[fg]{normal text}%
  \begin{frame}[#1]%
  \colorlet{currentbg}{csPrimary}%
}{%
  \end{frame}%
  \endgroup
}

% Variant: secondary-colour dark frame (for variety)
\newenvironment{accentframe}[1][]{%
  \begingroup
  \setbeamercolor{normal text}{fg=csTextLight, bg=csAccent}%
  \setbeamercolor{frametitle}{fg=csTextLight, bg=csAccent}%
  \usebeamercolor[fg]{normal text}%
  \begin{frame}[#1]%
}{%
  \end{frame}%
  \endgroup
}

% ----------------------------------------------------------------
% Title page
% ----------------------------------------------------------------

\defbeamertemplate*{title page}{claudeslides}{%
  \begin{tikzpicture}[remember picture, overlay]
    % Gradient background
    \shade[shading=axis, shading angle=135,
      left color=csPrimary, right color=csPrimary!85!csSecondary]
      (current page.south west) rectangle (current page.north east);
    % Decorative: large faded circle (modern corporate motif)
    \fill[csSecondary, opacity=0.08]
      ([xshift=40mm, yshift=-20mm]current page.north east) circle (50mm);
    % Bottom accent strip
    \fill[csAccent, opacity=0.9]
      (current page.south west) rectangle
      ([yshift=3mm]current page.south east);
  \end{tikzpicture}%
  \vfill
  {\usebeamerfont{title}\color{csTextLight}\inserttitle\par}%
  \ifx\insertsubtitle\empty\else
    \vskip6pt%
    {\usebeamerfont{subtitle}\color{csTextLight!80}\insertsubtitle\par}%
  \fi
  \vskip12pt%
  \ifx\insertauthor\empty\else
    {\usebeamerfont{author}\color{csTextLight!70}\insertauthor\par}%
  \fi
  \ifx\insertinstitute\empty\else
    \vskip2pt%
    {\usebeamerfont{institute}\color{csTextLight!60}\insertinstitute\par}%
  \fi
  \ifx\insertdate\empty\else
    \vskip4pt%
    {\usebeamerfont{date}\color{csTextLight!60}\insertdate\par}%
  \fi
  \vfill
}

\setbeamerfont{title}{size=\Huge, series=\bfseries}
\setbeamerfont{subtitle}{size=\large, series=\mdseries}
\setbeamerfont{author}{size=\normalsize}
\setbeamerfont{date}{size=\small}
\setbeamerfont{institute}{size=\small}

% ----------------------------------------------------------------
% Section divider page
% Automatically inserted at each \section if enabled.
% ----------------------------------------------------------------

\newcommand{\sectiondivider}{%
  \begin{darkframe}[c]
    \centering
    {\usebeamerfont{title}\color{csTextLight}\insertsection\par}
  \end{darkframe}
}

% Opt-in: \enablesectiondividers in preamble
\newcommand{\enablesectiondividers}{%
  \AtBeginSection{\sectiondivider}%
}

% ----------------------------------------------------------------
% Conclusion / thank-you slide
% ----------------------------------------------------------------

\newcommand{\conclusionslide}[2][Thank you]{%
  \begin{darkframe}[c]
    \centering
    {\usebeamerfont{title}\color{csTextLight}#1\par}%
    \vskip10pt%
    {\normalsize\color{csTextLight!70}#2\par}%
  \end{darkframe}
}

% ----------------------------------------------------------------
% Stat callout
% The pptx skill uses 60-72pt numbers with small labels.
% ----------------------------------------------------------------

\newcommand{\statcallout}[3][csPrimary]{%
  % #1 = colour (optional, default csPrimary)
  % #2 = big number/stat
  % #3 = label below
  \begin{center}
    {\fontsize{48}{52}\selectfont\bfseries\color{#1}#2\par}%
    \vskip4pt%
    {\small\color{csTextMuted}#3\par}%
  \end{center}%
}

% Multiple stats in a row
\newcommand{\statrow}[1]{%
  % #1 = content using \stat commands separated by &
  % Usage: \statrow{\stat{42\%}{Retention} & \stat{3.2}{Mean Score}}
  \begin{center}
  \begin{tabular}{*{10}{c}}
    #1
  \end{tabular}
  \end{center}
}

\newcommand{\stat}[3][csPrimary]{%
  \begin{minipage}[t]{0.22\textwidth}%
    \centering
    {\fontsize{36}{40}\selectfont\bfseries\color{#1}#2\par}%
    \vskip2pt%
    {\small\color{csTextMuted}#3\par}%
  \end{minipage}%
}

% ----------------------------------------------------------------
% Card environment
% The pptx skill uses coloured-border cards extensively.
% ----------------------------------------------------------------

\newtcolorbox{card}[1][]{%
  enhanced,
  colback=white,
  colframe=white,
  boxrule=0pt,
  borderline west={3pt}{0pt}{csPrimary},
  sharp corners,
  left=8pt, right=8pt, top=6pt, bottom=6pt,
  fonttitle=\bfseries\color{csPrimary},
  #1
}

\newtcolorbox{accentcard}[1][]{%
  enhanced,
  colback=csAccent!5!white,
  colframe=csAccent!5!white,
  boxrule=0pt,
  borderline west={3pt}{0pt}{csAccent},
  sharp corners,
  left=8pt, right=8pt, top=6pt, bottom=6pt,
  fonttitle=\bfseries\color{csAccent},
  #1
}

% ----------------------------------------------------------------
% Highlight box (tcolorbox) — for key findings, take-home points
% ----------------------------------------------------------------

\newtcolorbox{highlight}[1][]{%
  enhanced,
  colback=csPrimaryFaded,
  colframe=csPrimaryFaded,
  boxrule=0pt,
  borderline west={2.5pt}{0pt}{csPrimary},
  sharp corners,
  left=8pt, right=8pt, top=5pt, bottom=5pt,
  fonttitle=\bfseries\color{csPrimary},
  coltitle=csPrimary,
  #1
}

\newtcolorbox{notebox}[1][]{%
  enhanced,
  colback=csTextMuted!8!white,
  colframe=csTextMuted!8!white,
  boxrule=0pt,
  borderline west={2.5pt}{0pt}{csTextDark},
  sharp corners,
  left=8pt, right=8pt, top=5pt, bottom=5pt,
  fonttitle=\bfseries\color{csTextDark},
  coltitle=csTextDark,
  #1
}

% ----------------------------------------------------------------
% Warning / success / info boxes
% ----------------------------------------------------------------

\definecolor{csWarning}{HTML}{B85C00}
\definecolor{csWarningBg}{HTML}{FFF4E6}
\definecolor{csSuccess}{HTML}{2D6A4F}
\definecolor{csSuccessBg}{HTML}{EDF5F0}
\definecolor{csInfo}{HTML}{0072B2}
\definecolor{csInfoBg}{HTML}{E8F2FA}

\newtcolorbox{warningbox}[1][]{%
  enhanced, colback=csWarningBg, colframe=csWarningBg,
  boxrule=0pt, borderline west={2.5pt}{0pt}{csWarning},
  sharp corners, left=8pt, right=8pt, top=5pt, bottom=5pt,
  fonttitle=\bfseries\color{csWarning}, coltitle=csWarning, #1
}

\newtcolorbox{successbox}[1][]{%
  enhanced, colback=csSuccessBg, colframe=csSuccessBg,
  boxrule=0pt, borderline west={2.5pt}{0pt}{csSuccess},
  sharp corners, left=8pt, right=8pt, top=5pt, bottom=5pt,
  fonttitle=\bfseries\color{csSuccess}, coltitle=csSuccess, #1
}

\newtcolorbox{infobox}[1][]{%
  enhanced, colback=csInfoBg, colframe=csInfoBg,
  boxrule=0pt, borderline west={2.5pt}{0pt}{csInfo},
  sharp corners, left=8pt, right=8pt, top=5pt, bottom=5pt,
  fonttitle=\bfseries\color{csInfo}, coltitle=csInfo, #1
}

% ----------------------------------------------------------------
% Icon circle
% Approximation of the "icon in coloured circle" motif.
% Requires a symbol or tikz content.
% ----------------------------------------------------------------

\newcommand{\iconcircle}[2][csPrimary]{%
  % #1 = fill colour
  % #2 = content (symbol, letter, number)
  \tikz[baseline=-0.3em]{%
    \node[circle, fill=#1, text=csTextLight,
          inner sep=0pt, minimum size=1.6em,
          font=\bfseries\small] {#2};%
  }%
}

% ----------------------------------------------------------------
% Two-column helper
% Wraps beamer columns with consistent spacing.
% ----------------------------------------------------------------

\newenvironment{twocol}[1][0.48]{%
  \begin{columns}[T]
  \begin{column}{#1\textwidth}
}{%
  \end{column}
  \end{columns}
}

\newcommand{\colbreak}[1][0.48]{%
  \end{column}%
  \begin{column}{#1\textwidth}%
}

% ----------------------------------------------------------------
% Figure panels
%
% Usage:
%   \begin{figurepanel}{Overall caption}
%     \panel[0.48]{image1.pdf}{Subcaption A}
%     \panel[0.48]{image2.pdf}{Subcaption B}
%   \end{figurepanel}
%
% Width argument is fraction of \textwidth (default 0.48).
% ----------------------------------------------------------------

\newenvironment{figurepanel}[1][]{%
  \begin{figure}[htb]%
  \centering
  \def\cs@figurepanelcaption{#1}%
}{%
  \ifx\cs@figurepanelcaption\empty\else
    \vskip2pt%
    {\small\color{csTextMuted}\cs@figurepanelcaption\par}%
  \fi
  \end{figure}%
}

\newcommand{\panel}[3][0.48]{%
  \begin{minipage}[t]{#1\textwidth}%
    \centering
    \includegraphics[width=\linewidth]{#2}%
    \par\vskip2pt%
    {\footnotesize\color{csTextMuted}#3}%
  \end{minipage}\hfill%
}

% ----------------------------------------------------------------
% Source attribution for figures and tables
%
% Usage: \source{Annual Report, 2024}
% Renders as small muted text below the current element.
% ----------------------------------------------------------------

\newcommand{\source}[1]{%
  \par\vskip2pt%
  {\scriptsize\color{csTextMuted}\textit{Source:} #1\par}%
}

% ----------------------------------------------------------------
% Table styling
% Works with booktabs. Sets default beamer table colours.
% ----------------------------------------------------------------

\setbeamercolor{table head}{fg=csTextLight, bg=csPrimary}

% Helper: a styled table header row
% Usage: \rowcolor{csPrimary} applied manually, then \thead{} per cell.
%   \rowcolor{csPrimary} \thead{Col 1} & \thead{Col 2} & \thead{Col 3} \\
\newcommand{\thead}[1]{\bfseries\color{csTextLight}#1}

% Alternating row shading (optional, use inside tabular)
\newcommand{\shaderow}{\rowcolor{csPrimaryFaded}}

% ----------------------------------------------------------------
% Comparison layout
%
% Two-column layout with separate headed sections, matching
% PowerPoint's "Comparison" built-in layout.
%
% Usage:
%   \begin{comparison}{Left heading}{Right heading}
%     Left column content
%   \comparisondivide
%     Right column content
%   \end{comparison}
% ----------------------------------------------------------------

\newenvironment{comparison}[2]{%
  \gdef\cs@compright{#2}%
  \begin{columns}[T]
  \begin{column}{0.47\textwidth}
    {\small\bfseries\color{csPrimary}#1\par}%
    \vskip1pt{\color{csTextMuted!30}\hrule height 0.3pt}\vskip4pt%
}{%
  \end{column}
  \end{columns}
}
\newcommand{\comparisondivide}{%
  \end{column}%
  \hfill%
  \begin{column}{0.47\textwidth}%
    {\small\bfseries\color{csPrimary}\cs@compright\par}%
    \vskip1pt{\color{csTextMuted!30}\hrule height 0.3pt}\vskip4pt%
}

% ----------------------------------------------------------------
% Title-only frame
%
% A frame that renders only the title and subtitle with no body
% content, useful for introducing a topic before detailed slides.
%
% Usage:
%   \titleonlyframe{Main Point}
%   \titleonlyframe[Optional elaboration below]{Main Point}
% ----------------------------------------------------------------

\newcommand{\titleonlyframe}[2][]{%
  \begin{frame}[c]{}
    \centering
    {\usebeamerfont{title}\color{csPrimary}#2\par}%
    \ifx\relax#1\relax\else
      \vskip8pt%
      {\large\color{csTextMuted}#1\par}%
    \fi
  \end{frame}
}

% ----------------------------------------------------------------
% Picture with caption
%
% Full-width image with a caption bar below, matching PowerPoint's
% "Picture with Caption" layout.
%
% Usage:
%   \begin{pictureframe}{Title}
%     \includegraphics[width=\textwidth]{image.png}
%     \picturecaption{Description of the figure}
%   \end{pictureframe}
% ----------------------------------------------------------------

\newenvironment{pictureframe}[1]{%
  \begin{frame}{#1}%
  \centering
}{%
  \end{frame}%
}

\newcommand{\picturecaption}[1]{%
  \par\vskip4pt%
  \begin{tcolorbox}[
    enhanced, colback=csPrimaryFaded, colframe=csPrimaryFaded,
    boxrule=0pt, sharp corners,
    left=6pt, right=6pt, top=3pt, bottom=3pt,
  ]
    {\small\color{csTextMuted}#1}%
  \end{tcolorbox}%
}

% ----------------------------------------------------------------
% Content with caption
%
% Main content on the left (~65%), narrow caption/annotation on
% the right (~30%), matching PowerPoint's "Content with Caption".
%
% Usage:
%   \begin{captionframe}{Title}
%     Main content here (left side)
%   \framecaption
%     Annotation or explanation (right side)
%   \end{captionframe}
% ----------------------------------------------------------------

\newenvironment{captionframe}[1]{%
  \begin{frame}{#1}%
  \begin{columns}[T]
  \begin{column}{0.63\textwidth}%
}{%
  \end{column}
  \end{columns}
  \end{frame}%
}

\newcommand{\framecaption}{%
  \end{column}%
  \begin{column}{0.33\textwidth}%
    \color{csTextMuted}\small
}

% ----------------------------------------------------------------
% Quote / statement slide
%
% Large centred text on a light background for key quotes or
% single-statement slides.
%
% Usage:
%   \quoteslide{We cannot solve problems with the same thinking
%     that created them.}{Albert Einstein}
% ----------------------------------------------------------------

\newcommand{\quoteslide}[2]{%
  \begin{frame}[c,plain]{}
    \centering
    \vfill
    {\Large\itshape\color{csPrimary}``#1''\par}%
    \vskip10pt%
    {\normalsize\color{csTextMuted}#2\par}%
    \vfill
  \end{frame}
}

% ----------------------------------------------------------------
% Full-bleed image frame
%
% Image covers the entire slide with optional overlay text.
%
% Usage:
%   \fullbleedimage{photo.jpg}
%   \fullbleedimage[0.4]{photo.jpg}    with 40% dark overlay
% ----------------------------------------------------------------

\newcommand{\fullbleedimage}[2][0]{%
  \begin{frame}[plain]{}
    \begin{tikzpicture}[remember picture, overlay]
      \node[inner sep=0pt] at (current page.center) {%
        \includegraphics[width=\paperwidth, height=\paperheight, keepaspectratio=false]{#2}%
      };
      \ifnum\pdfstrcmp{#1}{0}=0 \else
        \fill[csPrimary, opacity=#1]
          (current page.south west) rectangle (current page.north east);
      \fi
    \end{tikzpicture}%
  \end{frame}
}

% ----------------------------------------------------------------
% Embedded file attachments
%
% Embeds files inside the PDF so they travel with it.
%
% Usage:
%   \embedfile{data.csv}                         Paperclip icon
%   \embedfile[icon=Graph]{results.xlsx}         Graph icon
%   \embedfilelink{paper.pdf}{See full paper}    Clickable text link
%   \localfilelink{../data/raw.csv}{Open CSV}    Link to local file (not embedded)
%
% Icon options: Paperclip (default), Graph, PushPin, Tag
% ----------------------------------------------------------------

% Configure attachfile2 defaults to match the class palette
\attachfilesetup{
  color=csPrimary,
  icon=Paperclip,
  mimetype=application/octet-stream,
}

% Embed a file with an icon (default: paperclip)
\newcommand{\embedfile}[2][]{%
  \attachfile[#1]{#2}%
}

% Embed a file with clickable text instead of an icon
\newcommand{\embedfilelink}[3][]{%
  \textattachfile[#1]{#2}{{\small\color{csPrimary}\underline{#3}}}%
}

% Link to a local file without embedding (uses \href{run:...})
\newcommand{\localfilelink}[2]{%
  {\small\color{csPrimary}\href{run:#1}{\underline{#2}}}%
}

% ----------------------------------------------------------------
% Draft / watermark mode
%
% Enable in preamble: \enabledraft  /  \enabledraft[CONFIDENTIAL]
% Places a diagonal watermark across every slide.
% ----------------------------------------------------------------

\newif\ifcs@draft \cs@draftfalse
\def\cs@drafttext{DRAFT}

\newcommand{\enabledraft}[1][DRAFT]{%
  \cs@drafttrue
  \def\cs@drafttext{#1}%
}

% Hook into every frame
\addtobeamertemplate{background}{}{%
  \ifcs@draft
    \begin{tikzpicture}[remember picture, overlay]
      \node[rotate=45, scale=6, text=csPrimary!12, font=\bfseries\sffamily]
        at (current page.center) {\cs@drafttext};
    \end{tikzpicture}%
  \fi
}

% ----------------------------------------------------------------
% QR code generation
%
% Requires the qrcode package. Generates QR codes inline.
%
% Usage:
%   \slideqr{https://example.com}
%   \slideqr[2cm]{https://example.com}          with custom size
%   \slideqrbox{https://example.com}{Scan me}
% ----------------------------------------------------------------

\RequirePackage{qrcode}

% Simple QR code, default 1.5cm
\newcommand{\slideqr}[2][1.5cm]{%
  \qrcode[height=#1]{#2}%
}

% QR code with label below
\newcommand{\slideqrbox}[3][1.5cm]{%
  \begin{minipage}[t]{#1}%
    \centering
    \qrcode[height=#1]{#2}%
    \par\vskip2pt%
    {\scriptsize\color{csTextMuted}#3}%
  \end{minipage}%
}

% QR code anchored to bottom-right of slide (for use anywhere in a frame)
\newcommand{\slideqrcorner}[2][1.2cm]{%
  \begin{tikzpicture}[remember picture, overlay]
    \node[anchor=south east, inner sep=0pt]
      at ([xshift=-12.7mm, yshift=10mm]current page.south east)
      {\qrcode[height=#1]{#2}};
  \end{tikzpicture}%
}

% ----------------------------------------------------------------
% Slide references (lightweight — no biblatex dependency)
%
% Corporate decks rarely use academic citations. Use \slideref
% for source attributions on individual slides.
%
% Usage:
%   \slideref{McKinsey Global Survey, 2024}
%   \slideref{Internal data, Q3 FY25}
% ----------------------------------------------------------------

\newcommand{\slideref}[1]{%
  \begin{tikzpicture}[remember picture, overlay]
    \node[anchor=south west, inner sep=0pt, text width=0.7\paperwidth]
      at ([xshift=12.7mm, yshift=8mm]current page.south west)
      {\scriptsize\color{csTextMuted}#1};
  \end{tikzpicture}%
}

% ----------------------------------------------------------------
% Agenda slide
%
% Usage:
%   \begin{agendaframe}
%     \agendaitem{Introduction}
%     \agendaitemactive{Market Analysis}
%     \agendaitem{Strategy}
%     \agendaitem{Next Steps}
%   \end{agendaframe}
% ----------------------------------------------------------------

\newcounter{cs@agendaitem}

\newenvironment{agendaframe}[1][Agenda]{%
  \begin{frame}{#1}%
  \setcounter{cs@agendaitem}{0}%
}{%
  \end{frame}%
}

\newcommand{\agendaitem}[1]{%
  \stepcounter{cs@agendaitem}%
  \par\vskip6pt%
  {\Large\bfseries\color{csTextMuted!50}\thecs@agendaitem.\hspace{6pt}}%
  {\large\color{csTextDark}#1\par}%
  \vskip1pt{\color{csTextMuted!20}\hrule height 0.3pt}%
}

\newcommand{\agendaitemactive}[1]{%
  \stepcounter{cs@agendaitem}%
  \par\vskip4pt%
  \begin{tcolorbox}[enhanced, colback=csPrimaryFaded, colframe=csPrimaryFaded,
    boxrule=0pt, borderline west={3pt}{0pt}{csPrimary},
    sharp corners, left=6pt, right=6pt, top=3pt, bottom=3pt]
    {\Large\bfseries\color{csPrimary}\thecs@agendaitem.\hspace{6pt}}%
    {\large\bfseries\color{csPrimary}#1}%
  \end{tcolorbox}%
}

% ----------------------------------------------------------------
% Timeline / roadmap
%
% Usage:
%   \begin{timelineframe}{Project Roadmap}
%     \milestone{0}{Q1 2025}{Research}
%     \milestone{3}{Q2 2025}{Development}
%     \milestonecurrent{6}{Q3 2025}{Launch}
%     \milestone{9}{Q4 2025}{Scale}
%   \end{timelineframe}
% ----------------------------------------------------------------

\newenvironment{timelineframe}[1]{%
  \begin{frame}{#1}%
  \centering
  \begin{tikzpicture}[
    every node/.style={font=\small},
    mlabel/.style={above=10pt, align=center, font=\footnotesize\bfseries\color{csTextDark}},
    msub/.style={below=10pt, align=center, font=\scriptsize\color{csTextMuted}},
  ]
  % horizontal track
  \draw[csTextMuted!30, line width=2pt] (0,0) -- (12,0);
}{%
  \end{tikzpicture}
  \end{frame}%
}

\newcommand{\milestone}[3]{%
  % #1 = x position (0-12), #2 = label above, #3 = sublabel below
  \fill[csSecondaryDark] (#1, 0) circle (5pt);
  \node[above=10pt, align=center, font=\footnotesize\bfseries\color{csTextDark}] at (#1, 0) {#2};
  \node[below=10pt, align=center, font=\scriptsize\color{csTextMuted}] at (#1, 0) {#3};
}

\newcommand{\milestonecurrent}[3]{%
  \fill[csPrimary] (#1, 0) circle (7pt);
  \fill[white] (#1, 0) circle (3pt);
  \node[above=10pt, align=center, font=\footnotesize\bfseries\color{csPrimary}] at (#1, 0) {#2};
  \node[below=10pt, align=center, font=\scriptsize\bfseries\color{csPrimary}] at (#1, 0) {#3};
}

\newcommand{\milestonedone}[3]{%
  \fill[csSecondaryDark] (#1, 0) circle (5pt);
  \node[font=\tiny, text=csTextLight] at (#1, 0) {\checkmark};
  \node[above=10pt, align=center, font=\footnotesize\color{csTextMuted}] at (#1, 0) {#2};
  \node[below=10pt, align=center, font=\scriptsize\color{csTextMuted}] at (#1, 0) {#3};
}

% ----------------------------------------------------------------
% Metric cards (KPI dashboard)
%
% Usage:
%   \begin{frame}{Q3 Performance}
%     \metricrow{%
%       \metriccard{£2.4M}{Revenue}{+12\% YoY}
%       \metriccard[csSuccess]{98.5\%}{Uptime}{Target: 99\%}
%       \metriccard[csWarning]{34}{Open Issues}{-8 from last month}
%     }
%   \end{frame}
% ----------------------------------------------------------------

\newcommand{\metriccard}[4][csPrimary]{%
  \begin{minipage}[t]{0.30\textwidth}%
    \begin{tcolorbox}[enhanced, colback=white, colframe=white,
      boxrule=0pt, borderline south={2pt}{0pt}{#1},
      sharp corners, left=4pt, right=4pt, top=6pt, bottom=6pt]
      {\fontsize{28}{32}\selectfont\bfseries\color{#1}#2\par}%
      \vskip3pt%
      {\small\color{csTextDark}#3\par}%
      \vskip1pt%
      {\scriptsize\bfseries\color{csTextMuted}#4\par}%
    \end{tcolorbox}%
  \end{minipage}\hfill%
}

\newcommand{\metricrow}[1]{%
  \begin{center}#1\end{center}%
}

% ----------------------------------------------------------------
% Profile cards (team slides)
%
% Usage:
%   \begin{frame}{Leadership Team}
%     \profilecard{Jane Smith}{CEO}{15 years in fintech}
%     \profilecard{John Doe}{CTO}{Former Google engineer}
%     \profilecard{Amy Lee}{CFO}{Ex-McKinsey partner}
%   \end{frame}
% ----------------------------------------------------------------

\newcommand{\profilecard}[4][]{%
  % #1 = optional image path, #2 = name, #3 = title, #4 = short bio
  \begin{minipage}[t]{0.22\textwidth}
    \centering
    \ifx\relax#1\relax
      \tikz{\node[circle, fill=csPrimaryLight, minimum size=2cm,
        font=\Huge\bfseries\color{csPrimary}]
        {\csname @car\endcsname#2\@nil};}%
    \else
      \tikz{\node[circle, minimum size=2cm, path picture={
        \node at (path picture bounding box.center)
          {\includegraphics[width=2cm, height=2cm]{#1}};}] {};}%
    \fi
    \par\vskip4pt%
    {\small\bfseries\color{csTextDark}#2\par}%
    {\scriptsize\color{csPrimary}#3\par}%
    \vskip2pt%
    {\scriptsize\color{csTextMuted}#4\par}%
  \end{minipage}\hfill%
}

% ----------------------------------------------------------------
% Pill badges / tags
%
% Usage:
%   \pillbadge{In Progress}
%   \pillbadge[csSuccess]{Complete}
%   \pillbadge[csWarning]{At Risk}
% ----------------------------------------------------------------

\newcommand{\pillbadge}[2][csPrimary]{%
  \tikz[baseline=-0.3em]{%
    \node[rounded corners=0.7em, fill=#1!15, text=#1,
      inner xsep=6pt, inner ysep=1.5pt,
      font=\scriptsize\bfseries] {#2};%
  }%
}

% ----------------------------------------------------------------
% Process / step indicators
%
% Usage:
%   \begin{processframe}{Our Approach}
%     \processstep{1}{Discover}{Stakeholder interviews}
%     \processarrow
%     \processstep{2}{Design}{Prototype \& test}
%     \processarrow
%     \processstep{3}{Deliver}{Roll out solution}
%   \end{processframe}
% ----------------------------------------------------------------

\newenvironment{processframe}[1]{%
  \begin{frame}{#1}%
  \centering
  \vfill
  \begin{minipage}{0.95\textwidth}
  \centering
}{%
  \end{minipage}
  \vfill
  \end{frame}%
}

\newcommand{\processstep}[3]{%
  % #1 = step number, #2 = title, #3 = description
  \begin{minipage}[t]{0.20\textwidth}%
    \centering
    \tikz{\node[circle, fill=csPrimary, text=csTextLight,
      minimum size=2em, font=\bfseries] {#1};}%
    \par\vskip4pt%
    {\small\bfseries\color{csTextDark}#2\par}%
    \vskip2pt%
    {\scriptsize\color{csTextMuted}#3\par}%
  \end{minipage}%
}

\newcommand{\processarrow}{%
  \hfill
  \tikz[baseline=-0.3em]{\draw[->, csTextMuted!50, line width=1.5pt] (0,0) -- (0.8,0);}%
  \hfill
}

% ----------------------------------------------------------------
% SWOT / quadrant grid
%
% Usage:
%   \begin{swotframe}{SWOT Analysis}
%     \swotquadrant{csPrimary}{Strengths}{Strong brand...}
%     \swotquadrant{csInfo}{Opportunities}{New markets...}
%     \swotquadrant{csWarning}{Weaknesses}{Limited reach...}
%     \swotquadrant{csWarning!70!red}{Threats}{Competition...}
%   \end{swotframe}
% ----------------------------------------------------------------

\newenvironment{swotframe}[1]{%
  \begin{frame}{#1}%
  \centering
  \begin{minipage}{0.95\textwidth}
  \begin{tabular}{@{}p{0.47\textwidth}@{\hspace{0.04\textwidth}}p{0.47\textwidth}@{}}
}{%
  \end{tabular}
  \end{minipage}
  \end{frame}%
}

\newcommand{\swotquadrant}[3]{%
  % #1 = colour, #2 = heading, #3 = content
  \begin{tcolorbox}[enhanced, colback=#1!5!white, colframe=#1!5!white,
    boxrule=0pt, borderline north={2pt}{0pt}{#1},
    sharp corners, left=6pt, right=6pt, top=4pt, bottom=4pt,
    height=3cm, valign=top]
    {\small\bfseries\color{#1}#2\par}\vskip2pt%
    {\scriptsize\color{csTextDark}#3}%
  \end{tcolorbox}%
}

% ----------------------------------------------------------------
% Key takeaway bar
%
% Anchored to the bottom of a slide, for a one-line takeaway.
%
% Usage (inside any frame):
%   \keytakeaway{Revenue grew 12\% driven by APAC expansion.}
% ----------------------------------------------------------------

\newcommand{\keytakeaway}[1]{%
  \begin{tikzpicture}[remember picture, overlay]
    \fill[csPrimary]
      ([yshift=10mm]current page.south west) rectangle
      ([yshift=18mm]current page.south east);
    \node[anchor=west, inner sep=0pt, text=csTextLight, font=\small\bfseries]
      at ([xshift=14mm, yshift=14mm]current page.south west)
      {#1};
  \end{tikzpicture}%
}

% ----------------------------------------------------------------
% Dark-mode toggle
% If darkmode option is set, invert the default: all content
% frames get the dark primary background.
% ----------------------------------------------------------------

\ifcs@darkmode
  \setbeamercolor{normal text}{fg=csTextLight, bg=csPrimary}
  \setbeamercolor{frametitle}{fg=csTextLight, bg=csPrimary}
  \setbeamercolor{framesubtitle}{fg=csTextMuted!50!csTextLight}
  \setbeamercolor{itemize item}{fg=csAccent}
  \setbeamercolor{itemize subitem}{fg=csSecondary}
  \setbeamercolor{block body}{fg=csTextLight, bg=csPrimary!80!black}
  \setbeamercolor{block title}{fg=csPrimary, bg=csSecondary}
\fi

% ----------------------------------------------------------------
% End of class
% ----------------------------------------------------------------
\endinput
