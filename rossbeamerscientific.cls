% rossbeamerscientific.cls
% Scientific Beamer class for conference talks — clean typography,
% thin progress bar, citation integration, statistical helpers,
% and layouts for research presentations.
%
% Usage:
%   \documentclass[palette=lancet]{rossbeamerscientific}
%
% Available palettes:
%   Scientific:  lancet (default), nhs, uom, economist, nature, nejm,
%                slate, evergreen, oxford, teal, cambridge, imperial,
%                charcoal, jama, bmj, cell, copper, rose, graphite
%   Corporate:   obsidian, nordic, ember, indigo, ivory, plum, steel,
%                moss, bordeaux, arctic, saffron, dusk
%
% Options:
%   palette=<name>   font=<fira|inter|sourcesans|libertinus|heros|georgia|system>
%   monofont=<name>  nobar  nologo
%
% Ross Dunne / Claude, 2026

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{rossbeamerscientific}[2026/03/24 Scientific Beamer class]

% ----------------------------------------------------------------
% Option handling
% ----------------------------------------------------------------

\RequirePackage{pgfkeys}
\RequirePackage{pgfopts}

\newif\ifrb@nobar  \rb@nobarfalse
\newif\ifrb@nologo \rb@nologofalse

\pgfkeys{
  /scibeamer/.cd,
  palette/.store in=\sci@palette,   palette=lancet,
  font/.store in=\sci@fontchoice,   font=fira,
  monofont/.store in=\sci@mono,     monofont=,
  nobar/.code={\rb@nobartrue},
  nologo/.code={\rb@nologotrue},
}
\ProcessPgfOptions{/scibeamer}

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
% \sci@defpal{name}
%   {primary}{secondary}{accent}{text}{textlight}{textmuted}{bg}{rule}
%   {accentdark}{accentlight}{accentbg}{lightmuted}
%
% First command consumes name + 8 core colours.
% Continuation consumes 4 refinement colours.
% ----------------------------------------------------------------

\newcommand{\sci@defpal}[9]{%
  \expandafter\def\csname sci@p@#1@P\endcsname{#2}%   primary
  \expandafter\def\csname sci@p@#1@S\endcsname{#3}%   secondary
  \expandafter\def\csname sci@p@#1@A\endcsname{#4}%   accent
  \expandafter\def\csname sci@p@#1@T\endcsname{#5}%   text
  \expandafter\def\csname sci@p@#1@TL\endcsname{#6}%  textlight
  \expandafter\def\csname sci@p@#1@TM\endcsname{#7}%  textmuted
  \expandafter\def\csname sci@p@#1@B\endcsname{#8}%   bg
  \expandafter\def\csname sci@p@#1@R\endcsname{#9}%   rule
  \sci@defpal@cont{#1}%
}
\newcommand{\sci@defpal@cont}[5]{%
  \expandafter\def\csname sci@p@#1@AD\endcsname{#2}%  accentdark
  \expandafter\def\csname sci@p@#1@AL\endcsname{#3}%  accentlight
  \expandafter\def\csname sci@p@#1@AB\endcsname{#4}%  accentbg
  \expandafter\def\csname sci@p@#1@LM\endcsname{#5}%  lightmuted
}

%                    name       P       S       A       T       TL      TM      B       R       AD      AL      AB      LM
\sci@defpal{lancet}  {1A1A2E}{D4384F}{A4243B}{1C1C1C}{FFFFFF}{6A6A78}{F8F7F5}{D8D6D0}{7B1A2C}{D4384F}{FBF0F2}{B0B0BE}
\sci@defpal{nhs}     {003087}{41B6E6}{005EB8}{1C1C1C}{FFFFFF}{5A6B7B}{F5F5F5}{D0D8E0}{003087}{41B6E6}{E8F1F8}{A0B4C8}
\sci@defpal{uom}     {2B0A3D}{8B3DB8}{660099}{1C1C1C}{FFFFFF}{6B5F78}{F8F7F9}{D8D0E0}{4A0072}{8B3DB8}{F3ECF8}{B0A0C0}
\sci@defpal{economist}{1F1F1F}{F04840}{E3120B}{1C1C1C}{FFFFFF}{707078}{F7F7F7}{D0D0D0}{B30D08}{F04840}{FDF0F0}{A8A8B0}
\sci@defpal{nature}  {15202B}{3498D8}{0072B2}{1C1C1C}{FFFFFF}{5A6878}{F6F8FA}{D0D8E0}{005080}{3498D8}{E8F2FA}{98B0C8}
\sci@defpal{nejm}    {2A1520}{A83848}{8B2332}{1C1C1C}{FFFFFF}{706068}{FAF8F5}{DDD0D4}{6A1A26}{A83848}{F8EEF0}{B8A0A8}
\sci@defpal{slate}   {1E2A38}{5A8AA8}{3B6B8A}{1C1C1C}{FFFFFF}{607080}{F5F7F9}{CDD5DD}{2A5070}{5A8AA8}{ECF2F6}{90A0B0}
\sci@defpal{evergreen}{1A2E1A}{40916C}{2D6A4F}{1C1C1C}{FFFFFF}{5A6B5A}{F8FAF7}{C8D8CE}{1B4332}{40916C}{EDF5F0}{90B0A0}
\sci@defpal{oxford}  {002147}{1A3A60}{002147}{1C1C1C}{FFFFFF}{5A6878}{F6F7F9}{C8D0D8}{001530}{1A3A60}{E8EEF5}{8898B0}
\sci@defpal{teal}    {0A2E2E}{2AABAB}{008080}{1C1C1C}{FFFFFF}{587878}{F6FAFA}{C8DEDE}{005F5F}{2AABAB}{E6F5F5}{88B8B8}
\sci@defpal{cambridge}{1A2930}{7AAFC5}{5B8FA8}{1C1C1C}{FFFFFF}{5A6E78}{F7F9FA}{CCD8E0}{3A6E88}{7AAFC5}{EBF3F7}{90B0C0}
\sci@defpal{imperial}{002147}{E87530}{D35400}{1C1C1C}{FFFFFF}{5A6878}{F7F8FA}{C8D0D8}{A04000}{E87530}{FDF2E9}{8898B0}
\sci@defpal{charcoal}{252525}{D95040}{C0392B}{1C1C1C}{FFFFFF}{787878}{F7F7F7}{D0D0D0}{962D22}{D95040}{FBEEED}{A0A0A0}
\sci@defpal{jama}    {2C2420}{9A4858}{7A2E40}{1C1C1C}{FFFFFF}{786858}{FAF8F5}{DDD5CC}{5C2030}{9A4858}{F6EEF0}{B8A898}
\sci@defpal{bmj}     {1B2838}{4A8CC0}{2E6FA0}{1C1C1C}{FFFFFF}{606C78}{F6F8FA}{CDD5DD}{1E5080}{4A8CC0}{EAF1F8}{90A8C0}
\sci@defpal{cell}    {1A1A40}{E0B030}{C8960C}{1C1C1C}{FFFFFF}{606078}{F9F8F5}{D0D0D8}{9A7008}{E0B030}{FBF6E8}{9898B8}
\sci@defpal{copper}  {1A1A1A}{D07040}{B45A28}{1C1C1C}{FFFFFF}{6E6460}{FAF8F6}{DDD5CC}{8A4018}{D07040}{FBF2EC}{B0A098}
\sci@defpal{rose}    {2A1822}{D87898}{C25B78}{1C1C1C}{FFFFFF}{786070}{FBF8F9}{E0D0D8}{9A4060}{D87898}{FBF0F3}{C0A0B0}
\sci@defpal{graphite}{1A1A1A}{606060}{404040}{1C1C1C}{FFFFFF}{707070}{F7F7F7}{D0D0D0}{2A2A2A}{606060}{F0F0F0}{A0A0A0}
% Corporate palettes (shared with rossbeamercorporate)
\sci@defpal{obsidian}{1A1A1A}{E0C070}{C9A84C}{1C1C1C}{FFFFFF}{8A8A8A}{F8F8F7}{D0D0CC}{A08030}{E0C070}{FAF6EC}{A0A0A0}
\sci@defpal{nordic}  {2A3A48}{58B0B0}{3A8E8E}{1C1C1C}{FFFFFF}{6A7888}{F6F8F9}{CCD5DD}{286868}{58B0B0}{E8F4F4}{8098A8}
\sci@defpal{ember}   {2A1A0A}{E08040}{C06020}{1C1C1C}{FFFFFF}{7A6858}{FAF8F5}{DDD5CA}{8B3A0A}{E08040}{FDF3EA}{A08868}
\sci@defpal{indigo}  {1A1A3E}{5C6BC0}{3F51B5}{1C1C1C}{FFFFFF}{606080}{F7F7FA}{CCCCDD}{283593}{5C6BC0}{ECEEF8}{8088B8}
\sci@defpal{ivory}   {2C3E6B}{4A5E8B}{2C3E6B}{1C1C1C}{FFFFFF}{6A7080}{FAF9F7}{D0D0D8}{1A2848}{4A5E8B}{ECEEF5}{8090A8}
\sci@defpal{plum}    {2A1038}{9A60BE}{7B3F9E}{1C1C1C}{FFFFFF}{706078}{F9F7FA}{D8D0E0}{4A1A5E}{9A60BE}{F4ECF8}{A888B8}
\sci@defpal{steel}   {2D3748}{ED8936}{DD6B20}{1C1C1C}{FFFFFF}{6A7888}{F7F8F9}{CDD5DD}{B85000}{ED8936}{FDF2E6}{8898A8}
\sci@defpal{moss}    {2A3018}{8A9B5C}{6A7B3C}{1C1C1C}{FFFFFF}{686E58}{F8F9F5}{CDD5C8}{4A5828}{8A9B5C}{F2F5EC}{889878}
\sci@defpal{bordeaux}{2A0818}{AA5068}{8A3048}{1C1C1C}{FFFFFF}{786068}{FAF8F7}{DDD0D5}{5A1028}{AA5068}{F8EEF1}{A88898}
\sci@defpal{arctic}  {1A3A60}{3A5A80}{1A3A60}{1C1C1C}{FFFFFF}{5A7090}{F4F8FC}{C8D8E8}{0A2040}{3A5A80}{E8F0F8}{7898B0}
\sci@defpal{saffron} {1A2744}{F0C040}{E8A820}{1C1C1C}{FFFFFF}{607080}{F8F8F5}{D0D0D0}{C08810}{F0C040}{FDF8E8}{7888A8}
\sci@defpal{dusk}    {2A2038}{F09090}{E87070}{1C1C1C}{FFFFFF}{686070}{F9F7F9}{D8D0D8}{C05050}{F09090}{FDF0F0}{9888A8}

% ----------------------------------------------------------------
% Palette activation
% ----------------------------------------------------------------

\newcommand{\sci@activatepalette}{%
  % Core colours
  \definecolor{rbPrimary}{HTML}{\csname sci@p@\sci@palette @P\endcsname}%
  \definecolor{rbSecondary}{HTML}{\csname sci@p@\sci@palette @S\endcsname}%
  \definecolor{rbAccent}{HTML}{\csname sci@p@\sci@palette @A\endcsname}%
  \definecolor{rbText}{HTML}{\csname sci@p@\sci@palette @T\endcsname}%
  \definecolor{rbTextLight}{HTML}{\csname sci@p@\sci@palette @TL\endcsname}%
  \definecolor{rbTextMuted}{HTML}{\csname sci@p@\sci@palette @TM\endcsname}%
  \definecolor{rbBg}{HTML}{\csname sci@p@\sci@palette @B\endcsname}%
  \definecolor{rbRule}{HTML}{\csname sci@p@\sci@palette @R\endcsname}%
  % Derive standard colours
  \rb@derivecolors
  % Override with explicit palette refinements
  \definecolor{rbAccentDark}{HTML}{\csname sci@p@\sci@palette @AD\endcsname}%
  \definecolor{rbAccentLight}{HTML}{\csname sci@p@\sci@palette @AL\endcsname}%
  \definecolor{rbAccentBg}{HTML}{\csname sci@p@\sci@palette @AB\endcsname}%
  \definecolor{rbLightMuted}{HTML}{\csname sci@p@\sci@palette @LM\endcsname}%
  % Legacy aliases
  \colorlet{scibDark}{rbPrimary}%
  \colorlet{scibText}{rbText}%
  \colorlet{scibMuted}{rbTextMuted}%
  \colorlet{scibAccent}{rbAccent}%
  \colorlet{scibAccentDark}{rbAccentDark}%
  \colorlet{scibAccentLight}{rbAccentLight}%
  \colorlet{scibAccentBg}{rbAccentBg}%
  \colorlet{scibBg}{rbBg}%
  \colorlet{scibLight}{rbTextLight}%
  \colorlet{scibLightMuted}{rbLightMuted}%
  \colorlet{scibRule}{rbRule}%
  \colorlet{scibProgress1}{rbAccent}%
  \colorlet{scibProgress2}{rbRule}%
}
\sci@activatepalette

\newcommand{\setpalette}[1]{\def\sci@palette{#1}\sci@activatepalette}

% ----------------------------------------------------------------
% Beamer setup
% ----------------------------------------------------------------

\rb@setupbeamer
\setbeamersize{text margin left=12mm, text margin right=12mm}

% Scientific frame title: with underline rule
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
\rb@activatefont{\sci@fontchoice}
\rb@activatemono{\sci@mono}
\usefonttheme[onlymath]{serif}

% Footer: always on
\rb@activatefooter

% ----------------------------------------------------------------
% Biblatex integration
% ----------------------------------------------------------------

\RequirePackage[
  backend=biber,
  style=numeric-comp,
  sorting=none,
  autocite=superscript,
  maxbibnames=3, minbibnames=1,
  maxcitenames=2, mincitenames=1,
  giveninits=true,
  doi=false, isbn=false, url=false, eprint=false,
]{biblatex}

\let\cite=\supercite

\DeclareFieldFormat{labelnumberwidth}{\mkbibbold{\color{rbAccent}#1}}
\setbeamertemplate{bibliography item}[text]
\setbeamercolor{bibliography item}{fg=rbAccent}
\setbeamercolor{bibliography entry author}{fg=rbText}
\setbeamercolor{bibliography entry title}{fg=rbText}
\setbeamercolor{bibliography entry location}{fg=rbTextMuted}
\setbeamercolor{bibliography entry note}{fg=rbTextMuted}
\setbeamerfont{bibliography item}{size=\scriptsize}
\setbeamerfont{bibliography entry author}{size=\scriptsize}
\setbeamerfont{bibliography entry title}{size=\scriptsize}
\setbeamerfont{bibliography entry location}{size=\scriptsize}
\setbeamerfont{bibliography entry note}{size=\scriptsize}
\setlength\bibitemsep{2pt}
\setlength\biblabelsep{4pt}

\newenvironment{referenceslide}[1][References]{%
  \begin{frame}[allowframebreaks]{#1}%
}{\end{frame}}

% ----------------------------------------------------------------
% Title page — dark with thin accent rule
% ----------------------------------------------------------------

\def\sci@conference{}
\newcommand{\conference}[1]{\def\sci@conference{#1}}

\defbeamertemplate*{title page}{rossbeamerscientific}{%
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
  \ifx\sci@conference\empty\else
    \vskip4pt{\usebeamerfont{date}\color{rbLightMuted}\itshape\sci@conference\par}\fi
  \vfill
}

% ================================================================
% SCIENTIFIC-SPECIFIC FEATURES
% ================================================================

% ----------------------------------------------------------------
% Slide footnotes
% ----------------------------------------------------------------

\newcommand{\slidefootnote}[2][0.7\paperwidth]{%
  \begin{tikzpicture}[remember picture, overlay]
    \node[anchor=south west, inner sep=0pt, text width=#1]
      at ([xshift=12mm, yshift=8mm]current page.south west)
      {\scriptsize\color{rbTextMuted}#2};
  \end{tikzpicture}%
}

% ----------------------------------------------------------------
% Statistical formatting helpers
% ----------------------------------------------------------------

\newcommand{\pval}[1]{%
  \textit{p}~\ifdim #1pt<0.001pt <~.001\else =~#1\fi
}
\newcommand{\ci}[3]{#1~[#2,~#3]}
\newcommand{\CI}[4]{#2,~#1\%~CI~[#3,~#4]}
\newcommand{\effectsize}[2]{\textit{#1}~=~#2}
\newcommand{\chisq}[1]{\ensuremath{\chi^2}~=~#1}
\newcommand{\fstat}[3]{\textit{F}(#1,\,#2)~=~#3}
\newcommand{\tstat}[2]{\textit{t}(#1)~=~#2}
\newcommand{\OR}[3]{OR~=~#1~[#2,~#3]}
\newcommand{\HR}[3]{HR~=~#1~[#2,~#3]}
\newcommand{\betacoef}[1]{\ensuremath{\beta}~=~#1}

% ----------------------------------------------------------------
% Finding / limitation / implication boxes
% ----------------------------------------------------------------

\newtcolorbox{findingbox}[1][Key Finding]{%
  enhanced, colback=rbAccentBg, colframe=rbAccentBg, boxrule=0pt,
  borderline west={3pt}{0pt}{rbAccent}, sharp corners,
  left=8pt, right=8pt, top=5pt, bottom=5pt,
  fonttitle=\small\bfseries\color{rbAccentDark},
  coltitle=rbAccentDark, title={#1},
}
\newtcolorbox{limitationbox}[1][Limitation]{%
  enhanced, colback=rbWarningBg, colframe=rbWarningBg, boxrule=0pt,
  borderline west={3pt}{0pt}{rbWarning}, sharp corners,
  left=8pt, right=8pt, top=5pt, bottom=5pt,
  fonttitle=\small\bfseries\color{rbWarning},
  coltitle=rbWarning, title={#1},
}
\newtcolorbox{implicationbox}[1][Clinical Implication]{%
  enhanced, colback=rbSuccessBg, colframe=rbSuccessBg, boxrule=0pt,
  borderline west={3pt}{0pt}{rbSuccess}, sharp corners,
  left=8pt, right=8pt, top=5pt, bottom=5pt,
  fonttitle=\small\bfseries\color{rbSuccess},
  coltitle=rbSuccess, title={#1},
}

% ----------------------------------------------------------------
% APA-style notes
% ----------------------------------------------------------------

\newcommand{\figurenote}[1]{%
  \par\vskip2pt{\scriptsize\color{rbText}\textit{Note.}~#1\par}%
}
\newcommand{\tablenote}[1]{%
  \par\vskip2pt{\scriptsize\color{rbText}\textit{Note.}~#1\par}%
}
\newcommand{\sigmarkers}{%
  \par\vskip1pt{\scriptsize\color{rbTextMuted}%
    *\,\textit{p}~<~.05.\quad **\,\textit{p}~<~.01.\quad ***\,\textit{p}~<~.001.\par}%
}

% ----------------------------------------------------------------
% Backup slides
% ----------------------------------------------------------------

\newcommand{\backupslides}{%
  \appendix
  \begin{darkframe}[c,plain]
    \centering
    {\usebeamerfont{title}\color{rbTextLight}Backup Slides\par}%
    \vskip6pt{\normalsize\color{rbLightMuted}Additional analyses and supplementary material\par}
  \end{darkframe}
}

% ----------------------------------------------------------------
% Equation highlighting
% ----------------------------------------------------------------

\newcommand{\eqhl}[2][rbAccent]{%
  \tikz[baseline=(X.base)]{%
    \node[fill=#1!15, inner sep=1.5pt, rounded corners=1pt] (X) {$\displaystyle #2$};}%
}
\newtcolorbox{eqbox}[1][]{%
  enhanced, colback=rbBg, colframe=rbRule,
  boxrule=0.4pt, sharp corners,
  left=4pt, right=4pt, top=4pt, bottom=4pt,
  fonttitle=\scriptsize\color{rbTextMuted}, coltitle=rbTextMuted, title={#1},
}

% ----------------------------------------------------------------
% Corresponding author / ORCID
% ----------------------------------------------------------------

\newcommand{\corresponding}{\textsuperscript{\color{rbAccent}*}}
\newcommand{\correspondinginfo}[1]{%
  \begin{tikzpicture}[remember picture, overlay]
    \node[anchor=south west, inner sep=0pt]
      at ([xshift=12mm, yshift=4mm]current page.south west)
      {\scriptsize\color{rbLightMuted}\textsuperscript{*}Corresponding author: #1};
  \end{tikzpicture}%
}
\newcommand{\orcid}[1]{%
  {\scriptsize\color{rbAccent}\href{https://orcid.org/#1}{ORCID: #1}}%
}

% ----------------------------------------------------------------
% Research question / hypothesis frames
% ----------------------------------------------------------------

\newcommand{\researchquestion}[2][Research Question]{%
  \begin{frame}[c]{}\centering
    {\small\bfseries\color{rbAccent}\MakeUppercase{#1}\par}%
    \vskip8pt{\Large\color{rbPrimary}\itshape #2\par}%
  \end{frame}
}
\newcommand{\hypothesis}[2][Hypothesis]{%
  \begin{frame}[c]{}\centering
    {\small\bfseries\color{rbAccent}\MakeUppercase{#1}\par}%
    \vskip8pt{\large\color{rbPrimary}#2\par}%
  \end{frame}
}

% ----------------------------------------------------------------
% Study design summary
% ----------------------------------------------------------------

\newenvironment{studydesign}[1]{\begin{frame}{#1}}{\end{frame}}
\newcommand{\designitem}[2]{%
  \par\vskip4pt%
  \begin{minipage}[t]{0.22\textwidth}\raggedleft
    {\small\bfseries\color{rbAccent}#1}%
  \end{minipage}\hspace{8pt}%
  \begin{minipage}[t]{0.70\textwidth}%
    {\small\color{rbText}#2}%
  \end{minipage}%
}

% ----------------------------------------------------------------
% CONSORT flow helpers
% ----------------------------------------------------------------

\newcommand{\flowbox}[1]{%
  \tikz{\node[draw=rbAccent, rounded corners=2pt, fill=rbAccentBg,
    text=rbText, font=\small, align=center,
    inner xsep=8pt, inner ysep=4pt] {#1};}%
}
\newcommand{\flowboxexcluded}[1]{%
  \tikz{\node[draw=rbRule, rounded corners=2pt, fill=rbBg,
    text=rbTextMuted, font=\scriptsize, align=center,
    inner xsep=6pt, inner ysep=3pt] {#1};}%
}
\newcommand{\flowarrow}{%
  \par\vskip2pt\centering
  \tikz{\draw[->, rbAccent, line width=1pt] (0,0) -- (0,-0.5);}%
  \par\vskip2pt%
}

% ----------------------------------------------------------------
\endinput
