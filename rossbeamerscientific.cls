% scibeamer.cls
% A scientific Beamer class for conference talks.
%
% Lancet-inspired palette: deep crimson accent, near-black text,
% warm off-white content backgrounds, dark title/conclusion frames.
% Sans-serif throughout (Fira Sans > Source Sans > TeX Gyre Heros).
% Thin progress bar, figure panel helpers, clean tables,
% highlight boxes, slide-master-style logo/footer configuration,
% and biblatex integration with superscript numeric citations.
%
% Usage:
%   \documentclass{scibeamer}
%
% Compile with: xelatex → biber → xelatex → xelatex
%
% Ross Dunne / Claude, 2026

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{scibeamer}[2026/03/21 Scientific Beamer class]

% ----------------------------------------------------------------
% Options
% ----------------------------------------------------------------

\RequirePackage{pgfkeys}
\RequirePackage{pgfopts}

\newif\ifscib@nobar  \scib@nobarfalse
\newif\ifscib@nologo \scib@nologofalse

\pgfkeys{
  /scibeamer/.cd,
  font/.store in=\scib@fontchoice,
  font=fira,
  monofont/.store in=\scib@monofontchoice,
  monofont=,
  palette/.store in=\scib@palette,
  palette=lancet,
  nobar/.code={\scib@nobartrue},
  nologo/.code={\scib@nologotrue},
}

% Storage for custom system font name (used when font=system)
\def\scib@customfontname{}
\newcommand{\customfontname}[1]{\def\scib@customfontname{#1}}

\ProcessPgfOptions{/scibeamer}

\PassOptionsToClass{aspectratio=169}{beamer}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{beamer}}
\ProcessOptions\relax
\LoadClass{beamer}

% ----------------------------------------------------------------
% Packages
% ----------------------------------------------------------------

\RequirePackage{xcolor}
\RequirePackage{colortbl}
\RequirePackage{tikz}
\RequirePackage{etoolbox}
\RequirePackage{fontspec}
\RequirePackage{calc}
\RequirePackage{graphicx}
\RequirePackage{ragged2e}
\RequirePackage{booktabs}
\RequirePackage{tcolorbox}
\tcbuselibrary{skins,breakable}
\RequirePackage{subcaption}
\RequirePackage{appendixnumberbeamer}
\RequirePackage{attachfile2}

% ----------------------------------------------------------------
% Colour palettes
% Body text is near-black for projector legibility across all palettes.
%
% Available palettes:
%   Institutional/Scientific:
%     lancet (default), nhs, uom, economist, nature, nejm,
%     slate, evergreen, oxford, teal, cambridge, imperial,
%     charcoal, jama, bmj, cell, copper, rose, graphite
%   Corporate/Business:
%     obsidian, nordic, ember, indigo, ivory, plum, steel,
%     moss, bordeaux, arctic, saffron, dusk
% ----------------------------------------------------------------

%                           Dark      Text    Muted   Accent  AccDark AccLight AccBg   Bg      Light   LightMut Rule
\newcommand{\scib@definepalette}[1]{} % forward declaration
\renewcommand{\scib@definepalette}[1]{%
  \csname scib@pal@#1\endcsname
}

% Storage: each palette defines a command that sets all colours
\newcommand{\scib@pal@lancet}{%
  \definecolor{scibDark}{HTML}{1A1A2E}%
  \definecolor{scibText}{HTML}{1C1C1C}%
  \definecolor{scibMuted}{HTML}{6A6A78}%
  \definecolor{scibAccent}{HTML}{A4243B}%
  \definecolor{scibAccentDark}{HTML}{7B1A2C}%
  \definecolor{scibAccentLight}{HTML}{D4384F}%
  \definecolor{scibAccentBg}{HTML}{FBF0F2}%
  \definecolor{scibBg}{HTML}{F8F7F5}%
  \definecolor{scibLight}{HTML}{FFFFFF}%
  \definecolor{scibLightMuted}{HTML}{B0B0BE}%
  \definecolor{scibRule}{HTML}{D8D6D0}%
}

\newcommand{\scib@pal@nhs}{%
  \definecolor{scibDark}{HTML}{003087}%
  \definecolor{scibText}{HTML}{1C1C1C}%
  \definecolor{scibMuted}{HTML}{5A6B7B}%
  \definecolor{scibAccent}{HTML}{005EB8}%
  \definecolor{scibAccentDark}{HTML}{003087}%
  \definecolor{scibAccentLight}{HTML}{41B6E6}%
  \definecolor{scibAccentBg}{HTML}{E8F1F8}%
  \definecolor{scibBg}{HTML}{F5F5F5}%
  \definecolor{scibLight}{HTML}{FFFFFF}%
  \definecolor{scibLightMuted}{HTML}{A0B4C8}%
  \definecolor{scibRule}{HTML}{D0D8E0}%
}

\newcommand{\scib@pal@uom}{%
  \definecolor{scibDark}{HTML}{2B0A3D}%
  \definecolor{scibText}{HTML}{1C1C1C}%
  \definecolor{scibMuted}{HTML}{6B5F78}%
  \definecolor{scibAccent}{HTML}{660099}%
  \definecolor{scibAccentDark}{HTML}{4A0072}%
  \definecolor{scibAccentLight}{HTML}{8B3DB8}%
  \definecolor{scibAccentBg}{HTML}{F3ECF8}%
  \definecolor{scibBg}{HTML}{F8F7F9}%
  \definecolor{scibLight}{HTML}{FFFFFF}%
  \definecolor{scibLightMuted}{HTML}{B0A0C0}%
  \definecolor{scibRule}{HTML}{D8D0E0}%
}

\newcommand{\scib@pal@economist}{%
  \definecolor{scibDark}{HTML}{1F1F1F}%
  \definecolor{scibText}{HTML}{1C1C1C}%
  \definecolor{scibMuted}{HTML}{707078}%
  \definecolor{scibAccent}{HTML}{E3120B}%
  \definecolor{scibAccentDark}{HTML}{B30D08}%
  \definecolor{scibAccentLight}{HTML}{F04840}%
  \definecolor{scibAccentBg}{HTML}{FDF0F0}%
  \definecolor{scibBg}{HTML}{F7F7F7}%
  \definecolor{scibLight}{HTML}{FFFFFF}%
  \definecolor{scibLightMuted}{HTML}{A8A8B0}%
  \definecolor{scibRule}{HTML}{D0D0D0}%
}

\newcommand{\scib@pal@nature}{%
  \definecolor{scibDark}{HTML}{15202B}%
  \definecolor{scibText}{HTML}{1C1C1C}%
  \definecolor{scibMuted}{HTML}{5A6878}%
  \definecolor{scibAccent}{HTML}{0072B2}%
  \definecolor{scibAccentDark}{HTML}{005080}%
  \definecolor{scibAccentLight}{HTML}{3498D8}%
  \definecolor{scibAccentBg}{HTML}{E8F2FA}%
  \definecolor{scibBg}{HTML}{F6F8FA}%
  \definecolor{scibLight}{HTML}{FFFFFF}%
  \definecolor{scibLightMuted}{HTML}{98B0C8}%
  \definecolor{scibRule}{HTML}{D0D8E0}%
}

\newcommand{\scib@pal@nejm}{%
  \definecolor{scibDark}{HTML}{2A1520}%
  \definecolor{scibText}{HTML}{1C1C1C}%
  \definecolor{scibMuted}{HTML}{706068}%
  \definecolor{scibAccent}{HTML}{8B2332}%
  \definecolor{scibAccentDark}{HTML}{6A1A26}%
  \definecolor{scibAccentLight}{HTML}{A83848}%
  \definecolor{scibAccentBg}{HTML}{F8EEF0}%
  \definecolor{scibBg}{HTML}{FAF8F5}%
  \definecolor{scibLight}{HTML}{FFFFFF}%
  \definecolor{scibLightMuted}{HTML}{B8A0A8}%
  \definecolor{scibRule}{HTML}{DDD0D4}%
}

\newcommand{\scib@pal@slate}{%
  \definecolor{scibDark}{HTML}{1E2A38}%
  \definecolor{scibText}{HTML}{1C1C1C}%
  \definecolor{scibMuted}{HTML}{607080}%
  \definecolor{scibAccent}{HTML}{3B6B8A}%
  \definecolor{scibAccentDark}{HTML}{2A5070}%
  \definecolor{scibAccentLight}{HTML}{5A8AA8}%
  \definecolor{scibAccentBg}{HTML}{ECF2F6}%
  \definecolor{scibBg}{HTML}{F5F7F9}%
  \definecolor{scibLight}{HTML}{FFFFFF}%
  \definecolor{scibLightMuted}{HTML}{90A0B0}%
  \definecolor{scibRule}{HTML}{CDD5DD}%
}

\newcommand{\scib@pal@evergreen}{%
  \definecolor{scibDark}{HTML}{1A2E1A}%
  \definecolor{scibText}{HTML}{1C1C1C}%
  \definecolor{scibMuted}{HTML}{5A6B5A}%
  \definecolor{scibAccent}{HTML}{2D6A4F}%
  \definecolor{scibAccentDark}{HTML}{1B4332}%
  \definecolor{scibAccentLight}{HTML}{40916C}%
  \definecolor{scibAccentBg}{HTML}{EDF5F0}%
  \definecolor{scibBg}{HTML}{F8FAF7}%
  \definecolor{scibLight}{HTML}{FFFFFF}%
  \definecolor{scibLightMuted}{HTML}{90B0A0}%
  \definecolor{scibRule}{HTML}{C8D8CE}%
}

\newcommand{\scib@pal@oxford}{%
  \definecolor{scibDark}{HTML}{002147}%
  \definecolor{scibText}{HTML}{1C1C1C}%
  \definecolor{scibMuted}{HTML}{5A6878}%
  \definecolor{scibAccent}{HTML}{002147}%
  \definecolor{scibAccentDark}{HTML}{001530}%
  \definecolor{scibAccentLight}{HTML}{1A3A60}%
  \definecolor{scibAccentBg}{HTML}{E8EEF5}%
  \definecolor{scibBg}{HTML}{F6F7F9}%
  \definecolor{scibLight}{HTML}{FFFFFF}%
  \definecolor{scibLightMuted}{HTML}{8898B0}%
  \definecolor{scibRule}{HTML}{C8D0D8}%
}

% --- Teal / clinical trial aesthetic (distinct from the blues) ---
\newcommand{\scib@pal@teal}{%
  \definecolor{scibDark}{HTML}{0A2E2E}%
  \definecolor{scibText}{HTML}{1C1C1C}%
  \definecolor{scibMuted}{HTML}{587878}%
  \definecolor{scibAccent}{HTML}{008080}%
  \definecolor{scibAccentDark}{HTML}{005F5F}%
  \definecolor{scibAccentLight}{HTML}{2AABAB}%
  \definecolor{scibAccentBg}{HTML}{E6F5F5}%
  \definecolor{scibBg}{HTML}{F6FAFA}%
  \definecolor{scibLight}{HTML}{FFFFFF}%
  \definecolor{scibLightMuted}{HTML}{88B8B8}%
  \definecolor{scibRule}{HTML}{C8DEDE}%
}

% --- Cambridge blue (pale blue-green, formal) ---
\newcommand{\scib@pal@cambridge}{%
  \definecolor{scibDark}{HTML}{1A2930}%
  \definecolor{scibText}{HTML}{1C1C1C}%
  \definecolor{scibMuted}{HTML}{5A6E78}%
  \definecolor{scibAccent}{HTML}{5B8FA8}%
  \definecolor{scibAccentDark}{HTML}{3A6E88}%
  \definecolor{scibAccentLight}{HTML}{7AAFC5}%
  \definecolor{scibAccentBg}{HTML}{EBF3F7}%
  \definecolor{scibBg}{HTML}{F7F9FA}%
  \definecolor{scibLight}{HTML}{FFFFFF}%
  \definecolor{scibLightMuted}{HTML}{90B0C0}%
  \definecolor{scibRule}{HTML}{CCD8E0}%
}

% --- Imperial (navy with tangerine accent — high contrast) ---
\newcommand{\scib@pal@imperial}{%
  \definecolor{scibDark}{HTML}{002147}%
  \definecolor{scibText}{HTML}{1C1C1C}%
  \definecolor{scibMuted}{HTML}{5A6878}%
  \definecolor{scibAccent}{HTML}{D35400}%
  \definecolor{scibAccentDark}{HTML}{A04000}%
  \definecolor{scibAccentLight}{HTML}{E87530}%
  \definecolor{scibAccentBg}{HTML}{FDF2E9}%
  \definecolor{scibBg}{HTML}{F7F8FA}%
  \definecolor{scibLight}{HTML}{FFFFFF}%
  \definecolor{scibLightMuted}{HTML}{8898B0}%
  \definecolor{scibRule}{HTML}{C8D0D8}%
}

% --- Charcoal / minimal (near-achromatic, single warm accent) ---
\newcommand{\scib@pal@charcoal}{%
  \definecolor{scibDark}{HTML}{252525}%
  \definecolor{scibText}{HTML}{1C1C1C}%
  \definecolor{scibMuted}{HTML}{787878}%
  \definecolor{scibAccent}{HTML}{C0392B}%
  \definecolor{scibAccentDark}{HTML}{962D22}%
  \definecolor{scibAccentLight}{HTML}{D95040}%
  \definecolor{scibAccentBg}{HTML}{FBEEED}%
  \definecolor{scibBg}{HTML}{F7F7F7}%
  \definecolor{scibLight}{HTML}{FFFFFF}%
  \definecolor{scibLightMuted}{HTML}{A0A0A0}%
  \definecolor{scibRule}{HTML}{D0D0D0}%
}

% --- JAMA (warm taupe with burgundy accent) ---
\newcommand{\scib@pal@jama}{%
  \definecolor{scibDark}{HTML}{2C2420}%
  \definecolor{scibText}{HTML}{1C1C1C}%
  \definecolor{scibMuted}{HTML}{786858}%
  \definecolor{scibAccent}{HTML}{7A2E40}%
  \definecolor{scibAccentDark}{HTML}{5C2030}%
  \definecolor{scibAccentLight}{HTML}{9A4858}%
  \definecolor{scibAccentBg}{HTML}{F6EEF0}%
  \definecolor{scibBg}{HTML}{FAF8F5}%
  \definecolor{scibLight}{HTML}{FFFFFF}%
  \definecolor{scibLightMuted}{HTML}{B8A898}%
  \definecolor{scibRule}{HTML}{DDD5CC}%
}

% --- BMJ (mid-blue with warm grey, slightly friendlier than Nature) ---
\newcommand{\scib@pal@bmj}{%
  \definecolor{scibDark}{HTML}{1B2838}%
  \definecolor{scibText}{HTML}{1C1C1C}%
  \definecolor{scibMuted}{HTML}{606C78}%
  \definecolor{scibAccent}{HTML}{2E6FA0}%
  \definecolor{scibAccentDark}{HTML}{1E5080}%
  \definecolor{scibAccentLight}{HTML}{4A8CC0}%
  \definecolor{scibAccentBg}{HTML}{EAF1F8}%
  \definecolor{scibBg}{HTML}{F6F8FA}%
  \definecolor{scibLight}{HTML}{FFFFFF}%
  \definecolor{scibLightMuted}{HTML}{90A8C0}%
  \definecolor{scibRule}{HTML}{CDD5DD}%
}

% --- Cell (dark indigo with gold accent — the Cell Press look) ---
\newcommand{\scib@pal@cell}{%
  \definecolor{scibDark}{HTML}{1A1A40}%
  \definecolor{scibText}{HTML}{1C1C1C}%
  \definecolor{scibMuted}{HTML}{606078}%
  \definecolor{scibAccent}{HTML}{C8960C}%
  \definecolor{scibAccentDark}{HTML}{9A7008}%
  \definecolor{scibAccentLight}{HTML}{E0B030}%
  \definecolor{scibAccentBg}{HTML}{FBF6E8}%
  \definecolor{scibBg}{HTML}{F9F8F5}%
  \definecolor{scibLight}{HTML}{FFFFFF}%
  \definecolor{scibLightMuted}{HTML}{9898B8}%
  \definecolor{scibRule}{HTML}{D0D0D8}%
}

% --- Copper (warm neutral, the Lilly-adjacent option from earlier) ---
\newcommand{\scib@pal@copper}{%
  \definecolor{scibDark}{HTML}{1A1A1A}%
  \definecolor{scibText}{HTML}{1C1C1C}%
  \definecolor{scibMuted}{HTML}{6E6460}%
  \definecolor{scibAccent}{HTML}{B45A28}%
  \definecolor{scibAccentDark}{HTML}{8A4018}%
  \definecolor{scibAccentLight}{HTML}{D07040}%
  \definecolor{scibAccentBg}{HTML}{FBF2EC}%
  \definecolor{scibBg}{HTML}{FAF8F6}%
  \definecolor{scibLight}{HTML}{FFFFFF}%
  \definecolor{scibLightMuted}{HTML}{B0A098}%
  \definecolor{scibRule}{HTML}{DDD5CC}%
}

% --- Rose (softer than lancet, works for patient-facing or
%     health psychology contexts) ---
\newcommand{\scib@pal@rose}{%
  \definecolor{scibDark}{HTML}{2A1822}%
  \definecolor{scibText}{HTML}{1C1C1C}%
  \definecolor{scibMuted}{HTML}{786070}%
  \definecolor{scibAccent}{HTML}{C25B78}%
  \definecolor{scibAccentDark}{HTML}{9A4060}%
  \definecolor{scibAccentLight}{HTML}{D87898}%
  \definecolor{scibAccentBg}{HTML}{FBF0F3}%
  \definecolor{scibBg}{HTML}{FBF8F9}%
  \definecolor{scibLight}{HTML}{FFFFFF}%
  \definecolor{scibLightMuted}{HTML}{C0A0B0}%
  \definecolor{scibRule}{HTML}{E0D0D8}%
}

% --- Graphite (true achromatic — no colour accent at all,
%     relies purely on weight and value contrast) ---
\newcommand{\scib@pal@graphite}{%
  \definecolor{scibDark}{HTML}{1A1A1A}%
  \definecolor{scibText}{HTML}{1C1C1C}%
  \definecolor{scibMuted}{HTML}{707070}%
  \definecolor{scibAccent}{HTML}{404040}%
  \definecolor{scibAccentDark}{HTML}{2A2A2A}%
  \definecolor{scibAccentLight}{HTML}{606060}%
  \definecolor{scibAccentBg}{HTML}{F0F0F0}%
  \definecolor{scibBg}{HTML}{F7F7F7}%
  \definecolor{scibLight}{HTML}{FFFFFF}%
  \definecolor{scibLightMuted}{HTML}{A0A0A0}%
  \definecolor{scibRule}{HTML}{D0D0D0}%
}

% --- Corporate/business palettes (shared with claudeslides) ---

% --- Obsidian (premium dark, luxury/finance — warm gold accent) ---
\newcommand{\scib@pal@obsidian}{%
  \definecolor{scibDark}{HTML}{1A1A1A}%
  \definecolor{scibText}{HTML}{1C1C1C}%
  \definecolor{scibMuted}{HTML}{8A8A8A}%
  \definecolor{scibAccent}{HTML}{C9A84C}%
  \definecolor{scibAccentDark}{HTML}{A08030}%
  \definecolor{scibAccentLight}{HTML}{E0C070}%
  \definecolor{scibAccentBg}{HTML}{FAF6EC}%
  \definecolor{scibBg}{HTML}{F8F8F7}%
  \definecolor{scibLight}{HTML}{FFFFFF}%
  \definecolor{scibLightMuted}{HTML}{A0A0A0}%
  \definecolor{scibRule}{HTML}{D0D0CC}%
}

% --- Nordic (Scandinavian minimal, cool grey-blue with muted teal) ---
\newcommand{\scib@pal@nordic}{%
  \definecolor{scibDark}{HTML}{2A3A48}%
  \definecolor{scibText}{HTML}{1C1C1C}%
  \definecolor{scibMuted}{HTML}{6A7888}%
  \definecolor{scibAccent}{HTML}{3A8E8E}%
  \definecolor{scibAccentDark}{HTML}{286868}%
  \definecolor{scibAccentLight}{HTML}{58B0B0}%
  \definecolor{scibAccentBg}{HTML}{E8F4F4}%
  \definecolor{scibBg}{HTML}{F6F8F9}%
  \definecolor{scibLight}{HTML}{FFFFFF}%
  \definecolor{scibLightMuted}{HTML}{8098A8}%
  \definecolor{scibRule}{HTML}{CCD5DD}%
}

% --- Ember (warm energy, deep orange-brown with bright amber) ---
\newcommand{\scib@pal@ember}{%
  \definecolor{scibDark}{HTML}{2A1A0A}%
  \definecolor{scibText}{HTML}{1C1C1C}%
  \definecolor{scibMuted}{HTML}{7A6858}%
  \definecolor{scibAccent}{HTML}{C06020}%
  \definecolor{scibAccentDark}{HTML}{8B3A0A}%
  \definecolor{scibAccentLight}{HTML}{E08040}%
  \definecolor{scibAccentBg}{HTML}{FDF3EA}%
  \definecolor{scibBg}{HTML}{FAF8F5}%
  \definecolor{scibLight}{HTML}{FFFFFF}%
  \definecolor{scibLightMuted}{HTML}{A08868}%
  \definecolor{scibRule}{HTML}{DDD5CA}%
}

% --- Indigo (tech/engineering, deep indigo with electric blue) ---
\newcommand{\scib@pal@indigo}{%
  \definecolor{scibDark}{HTML}{1A1A3E}%
  \definecolor{scibText}{HTML}{1C1C1C}%
  \definecolor{scibMuted}{HTML}{606080}%
  \definecolor{scibAccent}{HTML}{3F51B5}%
  \definecolor{scibAccentDark}{HTML}{283593}%
  \definecolor{scibAccentLight}{HTML}{5C6BC0}%
  \definecolor{scibAccentBg}{HTML}{ECEEF8}%
  \definecolor{scibBg}{HTML}{F7F7FA}%
  \definecolor{scibLight}{HTML}{FFFFFF}%
  \definecolor{scibLightMuted}{HTML}{8088B8}%
  \definecolor{scibRule}{HTML}{CCCCDD}%
}

% --- Ivory (consulting, warm professional — muted navy accent) ---
\newcommand{\scib@pal@ivory}{%
  \definecolor{scibDark}{HTML}{2C3E6B}%
  \definecolor{scibText}{HTML}{1C1C1C}%
  \definecolor{scibMuted}{HTML}{6A7080}%
  \definecolor{scibAccent}{HTML}{2C3E6B}%
  \definecolor{scibAccentDark}{HTML}{1A2848}%
  \definecolor{scibAccentLight}{HTML}{4A5E8B}%
  \definecolor{scibAccentBg}{HTML}{ECEEF5}%
  \definecolor{scibBg}{HTML}{FAF9F7}%
  \definecolor{scibLight}{HTML}{FFFFFF}%
  \definecolor{scibLightMuted}{HTML}{8090A8}%
  \definecolor{scibRule}{HTML}{D0D0D8}%
}

% --- Plum (creative agency, deep purple with soft lilac) ---
\newcommand{\scib@pal@plum}{%
  \definecolor{scibDark}{HTML}{2A1038}%
  \definecolor{scibText}{HTML}{1C1C1C}%
  \definecolor{scibMuted}{HTML}{706078}%
  \definecolor{scibAccent}{HTML}{7B3F9E}%
  \definecolor{scibAccentDark}{HTML}{4A1A5E}%
  \definecolor{scibAccentLight}{HTML}{9A60BE}%
  \definecolor{scibAccentBg}{HTML}{F4ECF8}%
  \definecolor{scibBg}{HTML}{F9F7FA}%
  \definecolor{scibLight}{HTML}{FFFFFF}%
  \definecolor{scibLightMuted}{HTML}{A888B8}%
  \definecolor{scibRule}{HTML}{D8D0E0}%
}

% --- Steel (industrial, blue-grey with safety orange) ---
\newcommand{\scib@pal@steel}{%
  \definecolor{scibDark}{HTML}{2D3748}%
  \definecolor{scibText}{HTML}{1C1C1C}%
  \definecolor{scibMuted}{HTML}{6A7888}%
  \definecolor{scibAccent}{HTML}{DD6B20}%
  \definecolor{scibAccentDark}{HTML}{B85000}%
  \definecolor{scibAccentLight}{HTML}{ED8936}%
  \definecolor{scibAccentBg}{HTML}{FDF2E6}%
  \definecolor{scibBg}{HTML}{F7F8F9}%
  \definecolor{scibLight}{HTML}{FFFFFF}%
  \definecolor{scibLightMuted}{HTML}{8898A8}%
  \definecolor{scibRule}{HTML}{CDD5DD}%
}

% --- Moss (sustainability, muted olive-green with warm clay) ---
\newcommand{\scib@pal@moss}{%
  \definecolor{scibDark}{HTML}{2A3018}%
  \definecolor{scibText}{HTML}{1C1C1C}%
  \definecolor{scibMuted}{HTML}{686E58}%
  \definecolor{scibAccent}{HTML}{6A7B3C}%
  \definecolor{scibAccentDark}{HTML}{4A5828}%
  \definecolor{scibAccentLight}{HTML}{8A9B5C}%
  \definecolor{scibAccentBg}{HTML}{F2F5EC}%
  \definecolor{scibBg}{HTML}{F8F9F5}%
  \definecolor{scibLight}{HTML}{FFFFFF}%
  \definecolor{scibLightMuted}{HTML}{889878}%
  \definecolor{scibRule}{HTML}{CDD5C8}%
}

% --- Bordeaux (executive, deep wine red with champagne gold) ---
\newcommand{\scib@pal@bordeaux}{%
  \definecolor{scibDark}{HTML}{2A0818}%
  \definecolor{scibText}{HTML}{1C1C1C}%
  \definecolor{scibMuted}{HTML}{786068}%
  \definecolor{scibAccent}{HTML}{8A3048}%
  \definecolor{scibAccentDark}{HTML}{5A1028}%
  \definecolor{scibAccentLight}{HTML}{AA5068}%
  \definecolor{scibAccentBg}{HTML}{F8EEF1}%
  \definecolor{scibBg}{HTML}{FAF8F7}%
  \definecolor{scibLight}{HTML}{FFFFFF}%
  \definecolor{scibLightMuted}{HTML}{A88898}%
  \definecolor{scibRule}{HTML}{DDD0D5}%
}

% --- Arctic (healthcare tech, ice blue with crisp navy) ---
\newcommand{\scib@pal@arctic}{%
  \definecolor{scibDark}{HTML}{1A3A60}%
  \definecolor{scibText}{HTML}{1C1C1C}%
  \definecolor{scibMuted}{HTML}{5A7090}%
  \definecolor{scibAccent}{HTML}{1A3A60}%
  \definecolor{scibAccentDark}{HTML}{0A2040}%
  \definecolor{scibAccentLight}{HTML}{3A5A80}%
  \definecolor{scibAccentBg}{HTML}{E8F0F8}%
  \definecolor{scibBg}{HTML}{F4F8FC}%
  \definecolor{scibLight}{HTML}{FFFFFF}%
  \definecolor{scibLightMuted}{HTML}{7898B0}%
  \definecolor{scibRule}{HTML}{C8D8E8}%
}

% --- Saffron (bold media, deep navy with bright saffron yellow) ---
\newcommand{\scib@pal@saffron}{%
  \definecolor{scibDark}{HTML}{1A2744}%
  \definecolor{scibText}{HTML}{1C1C1C}%
  \definecolor{scibMuted}{HTML}{607080}%
  \definecolor{scibAccent}{HTML}{E8A820}%
  \definecolor{scibAccentDark}{HTML}{C08810}%
  \definecolor{scibAccentLight}{HTML}{F0C040}%
  \definecolor{scibAccentBg}{HTML}{FDF8E8}%
  \definecolor{scibBg}{HTML}{F8F8F5}%
  \definecolor{scibLight}{HTML}{FFFFFF}%
  \definecolor{scibLightMuted}{HTML}{7888A8}%
  \definecolor{scibRule}{HTML}{D0D0D0}%
}

% --- Dusk (modern fintech, muted purple-grey with coral pink) ---
\newcommand{\scib@pal@dusk}{%
  \definecolor{scibDark}{HTML}{2A2038}%
  \definecolor{scibText}{HTML}{1C1C1C}%
  \definecolor{scibMuted}{HTML}{686070}%
  \definecolor{scibAccent}{HTML}{E87070}%
  \definecolor{scibAccentDark}{HTML}{C05050}%
  \definecolor{scibAccentLight}{HTML}{F09090}%
  \definecolor{scibAccentBg}{HTML}{FDF0F0}%
  \definecolor{scibBg}{HTML}{F9F7F9}%
  \definecolor{scibLight}{HTML}{FFFFFF}%
  \definecolor{scibLightMuted}{HTML}{9888A8}%
  \definecolor{scibRule}{HTML}{D8D0D8}%
}

% Activate the chosen palette
\scib@definepalette{\scib@palette}

% Derived colours used by progress bar (adapt to any palette)
\colorlet{scibProgress1}{scibAccent}
\colorlet{scibProgress2}{scibRule}
% ----------------------------------------------------------------
% Typography — sans throughout, switchable via font= option
%
% Available fonts:
%   font=fira        Fira Sans (default) — humanist, excellent legibility
%   font=inter       Inter — clean geometric, great for data-heavy slides
%   font=sourcesans  Source Sans 3 — Adobe's workhorse sans-serif
%   font=libertinus  Libertinus Sans — pairs well with math content
%   font=heros       TeX Gyre Heros — Helvetica metric-compatible fallback
%
% Any system font:
%   font=system      then set \customfontname{Roboto} in preamble
%                    (or any font name visible to fontspec/fontconfig)
%
% Monospace font (for code listings):
%   monofont=Fira Code      or any monospace system font
%   If omitted, uses TeX Gyre Cursor as default.
% ----------------------------------------------------------------

\newcommand{\scib@setfont@fira}{%
  \IfFontExistsTF{Fira Sans}{%
    \setsansfont{Fira Sans}[
      BoldFont = {Fira Sans SemiBold},
      ItalicFont = {Fira Sans Italic},
      BoldItalicFont = {Fira Sans SemiBold Italic},
    ]%
  }{\setsansfont{TeX Gyre Heros}}%
}

\newcommand{\scib@setfont@inter}{%
  \IfFontExistsTF{Inter}{%
    \setsansfont{Inter}[
      BoldFont = {Inter SemiBold},
      ItalicFont = {Inter Italic},
      BoldItalicFont = {Inter SemiBold Italic},
    ]%
  }{\setsansfont{TeX Gyre Heros}}%
}

\newcommand{\scib@setfont@sourcesans}{%
  \IfFontExistsTF{Source Sans 3}{%
    \setsansfont{Source Sans 3}%
  }{%
    \IfFontExistsTF{Source Sans Pro}{%
      \setsansfont{Source Sans Pro}%
    }{\setsansfont{TeX Gyre Heros}}%
  }%
}

\newcommand{\scib@setfont@libertinus}{%
  \IfFontExistsTF{Libertinus Sans}{%
    \setsansfont{Libertinus Sans}%
  }{\setsansfont{TeX Gyre Heros}}%
}

\newcommand{\scib@setfont@heros}{%
  \setsansfont{TeX Gyre Heros}%
}

% Activate the chosen font
\def\scib@tmp@fira{fira}
\def\scib@tmp@inter{inter}
\def\scib@tmp@sourcesans{sourcesans}
\def\scib@tmp@libertinus{libertinus}
\def\scib@tmp@heros{heros}
\def\scib@tmp@system{system}

\ifx\scib@fontchoice\scib@tmp@inter
  \scib@setfont@inter
\else\ifx\scib@fontchoice\scib@tmp@sourcesans
  \scib@setfont@sourcesans
\else\ifx\scib@fontchoice\scib@tmp@libertinus
  \scib@setfont@libertinus
\else\ifx\scib@fontchoice\scib@tmp@heros
  \scib@setfont@heros
\else\ifx\scib@fontchoice\scib@tmp@system
  % Deferred: \customfontname{} must be called in preamble.
  % Applied at \begin{document} so the preamble has time to set it.
  \AtBeginDocument{%
    \ifx\scib@customfontname\empty
      \ClassWarning{scibeamer}{font=system used but \string\customfontname\space not set. Falling back to TeX Gyre Heros.}%
      \setsansfont{TeX Gyre Heros}%
    \else
      \IfFontExistsTF{\scib@customfontname}{%
        \setsansfont{\scib@customfontname}%
      }{%
        \ClassWarning{scibeamer}{Font '\scib@customfontname' not found. Falling back to TeX Gyre Heros.}%
        \setsansfont{TeX Gyre Heros}%
      }%
    \fi
  }%
\else
  \scib@setfont@fira
\fi\fi\fi\fi\fi

% Monospace font (for code, listings, verbatim)
\ifx\scib@monofontchoice\empty
  \IfFontExistsTF{Fira Code}{%
    \setmonofont{Fira Code}[Scale=0.85]%
  }{%
    \IfFontExistsTF{TeX Gyre Cursor}{%
      \setmonofont{TeX Gyre Cursor}[Scale=0.85]%
    }{}%
  }%
\else
  \IfFontExistsTF{\scib@monofontchoice}{%
    \setmonofont{\scib@monofontchoice}[Scale=0.85]%
  }{%
    \ClassWarning{scibeamer}{Monospace font '\scib@monofontchoice' not found. Using default.}%
  }%
\fi

% Keep math in serif for readability
\usefonttheme[onlymath]{serif}

% ----------------------------------------------------------------
% Beamer base — strip all chrome
% ----------------------------------------------------------------

\usetheme{default}
\useinnertheme{default}
\useoutertheme{default}
\setbeamertemplate{navigation symbols}{}
\setbeamertemplate{headline}{}
\setbeamersize{text margin left=12mm, text margin right=12mm}

% ----------------------------------------------------------------
% Beamer colour assignments
% ----------------------------------------------------------------

\setbeamercolor{normal text}{fg=scibText, bg=white}
\setbeamercolor{frametitle}{fg=scibDark}
\setbeamercolor{framesubtitle}{fg=scibMuted}
\setbeamercolor{itemize item}{fg=scibAccent}
\setbeamercolor{itemize subitem}{fg=scibMuted}
\setbeamercolor{enumerate item}{fg=scibAccent}
\setbeamercolor{enumerate subitem}{fg=scibMuted}
\setbeamercolor{description item}{fg=scibDark}
\setbeamercolor{caption name}{fg=scibMuted}
\setbeamercolor{block title}{fg=scibLight, bg=scibDark}
\setbeamercolor{block body}{fg=scibText, bg=scibBg}
\setbeamercolor{block title alerted}{fg=scibLight, bg=scibAccent}
\setbeamercolor{block body alerted}{fg=scibText, bg=scibAccentBg}

% Bullet shapes
\setbeamertemplate{itemize item}{\tikz\draw[fill=scibAccent,draw=none] (0,0) circle (0.07);}
\setbeamertemplate{itemize subitem}{\tikz\draw[fill=scibMuted,draw=none] (0,0) circle (0.05);}
\setbeamertemplate{enumerate item}{\insertenumlabel.}
\setbeamerfont{enumerate item}{series=\bfseries}

% ----------------------------------------------------------------
% Frame title
% No accent lines. Left-aligned.
% ----------------------------------------------------------------

\setbeamerfont{frametitle}{size=\Large, series=\bfseries}
\setbeamerfont{framesubtitle}{size=\small, series=\mdseries}

\setbeamertemplate{frametitle}{%
  \vskip6pt%
  {\usebeamerfont{frametitle}\usebeamercolor[fg]{frametitle}\insertframetitle}%
  \ifx\insertframesubtitle\empty\else
    \par\vskip1pt%
    {\usebeamerfont{framesubtitle}\usebeamercolor[fg]{framesubtitle}\insertframesubtitle}%
  \fi
  \vskip2pt%
  {\color{scibRule}\hrule height 0.4pt}%
  \vskip4pt%
}

% Body text left-aligned
\AtBeginDocument{\RaggedRight}

% ----------------------------------------------------------------
% Slide master: logo, footer text, short title
%
% Configure in preamble:
%   \slidelogo{logo.png}        or \slidelogo[height=6mm]{logo.png}
%   \footertext{GMDRC}
%   \slidenote{Confidential}    (optional right-footer note)
% ----------------------------------------------------------------

% Storage macros
\def\scib@logo{}
\def\scib@logoheight{6mm}
\def\scib@footertext{}
\def\scib@slidenote{}

% Logo position: bottomleft (default), bottomright, topleft, topright
\def\scib@logopos{bottomleft}
\newcommand{\logoposition}[1]{\def\scib@logopos{#1}}

\newcommand{\slidelogo}[2][height=6mm]{%
  \def\scib@logo{#2}%
  \def\scib@logoopts{#1}%
}
\newcommand{\footertext}[1]{\def\scib@footertext{#1}}
\newcommand{\slidenote}[1]{\def\scib@slidenote{#1}}

\def\scib@conference{}
\newcommand{\conference}[1]{\def\scib@conference{#1}}

% ----------------------------------------------------------------
% Footer: slide number (left), footer text (centre), note (right)
% Plus logo placement.
% ----------------------------------------------------------------

\setbeamertemplate{footline}{%
  \ifx\scib@logo\empty\else
    \begin{tikzpicture}[remember picture, overlay]
      \ifx\scib@logopos\empty\def\scib@logopos{bottomleft}\fi
      \def\scib@bl{bottomleft}\def\scib@br{bottomright}%
      \def\scib@tl{topleft}\def\scib@tr{topright}%
      \ifx\scib@logopos\scib@bl
        \node[anchor=south west, inner sep=0pt]
          at ([xshift=10mm, yshift=4mm]current page.south west)
          {\includegraphics[\scib@logoopts]{\scib@logo}};%
      \fi
      \ifx\scib@logopos\scib@br
        \node[anchor=south east, inner sep=0pt]
          at ([xshift=-10mm, yshift=4mm]current page.south east)
          {\includegraphics[\scib@logoopts]{\scib@logo}};%
      \fi
      \ifx\scib@logopos\scib@tl
        \node[anchor=north west, inner sep=0pt]
          at ([xshift=10mm, yshift=-4mm]current page.north west)
          {\includegraphics[\scib@logoopts]{\scib@logo}};%
      \fi
      \ifx\scib@logopos\scib@tr
        \node[anchor=north east, inner sep=0pt]
          at ([xshift=-10mm, yshift=-4mm]current page.north east)
          {\includegraphics[\scib@logoopts]{\scib@logo}};%
      \fi
    \end{tikzpicture}%
  \fi
  \hbox to \paperwidth{%
    \hskip12mm%
    {\usebeamerfont{footline}\color{scibMuted}%
      \insertframenumber\,/\,\inserttotalframenumber}%
    \hfill%
    {\usebeamerfont{footline}\color{scibMuted}\scib@footertext}%
    \hfill%
    {\usebeamerfont{footline}\color{scibMuted}\scib@slidenote}%
    \hskip12mm%
  }%
  \vskip3pt%
}
\setbeamerfont{footline}{size=\tiny}

% ----------------------------------------------------------------
% Progress bar (thin line at very top of slide)
% Disable with class option: nobar
% ----------------------------------------------------------------

\ifscib@nobar\else
  \addtobeamertemplate{headline}{}{%
    \begin{tikzpicture}[remember picture, overlay]
      % track
      \fill[scibProgress2]
        (current page.north west) rectangle
        ([yshift=-1.8pt]current page.north east);
      % filled portion
      \ifnum\inserttotalframenumber>0
        \pgfmathsetmacro{\progresswidth}{%
          \paperwidth * \insertframenumber / \inserttotalframenumber}%
        \fill[scibProgress1]
          (current page.north west) rectangle
          ([xshift=\progresswidth pt, yshift=-1.2pt]current page.north west);
      \fi
    \end{tikzpicture}%
  }
\fi

% ----------------------------------------------------------------
% Title page
% ----------------------------------------------------------------

\defbeamertemplate*{title page}{scibeamer}{%
  \begin{tikzpicture}[remember picture, overlay]
    \fill[scibDark] (current page.south west) rectangle (current page.north east);
    % subtle accent rule
    \fill[scibAccent]
      ([yshift=12mm]current page.south west) rectangle
      ([yshift=12.6mm]current page.south east);
  \end{tikzpicture}%
  \vfill
  {\usebeamerfont{title}\color{scibLight}\inserttitle\par}%
  \ifx\insertsubtitle\empty\else
    \vskip6pt%
    {\usebeamerfont{subtitle}\color{scibLightMuted}\insertsubtitle\par}%
  \fi
  \vskip14pt%
  \ifx\insertauthor\empty\else
    {\usebeamerfont{author}\color{scibLight!85}\insertauthor\par}%
  \fi
  \ifx\insertinstitute\empty\else
    \vskip2pt%
    {\usebeamerfont{institute}\color{scibLightMuted}\insertinstitute\par}%
  \fi
  \ifx\insertdate\empty\else
    \vskip2pt%
    {\usebeamerfont{date}\color{scibLightMuted}\insertdate\par}%
  \fi
  \ifx\scib@conference\empty\else
    \vskip4pt%
    {\usebeamerfont{date}\color{scibLightMuted}\itshape\scib@conference\par}%
  \fi
  \vfill
}

\setbeamerfont{title}{size=\huge, series=\bfseries}
\setbeamerfont{subtitle}{size=\large, series=\mdseries}
\setbeamerfont{author}{size=\normalsize}
\setbeamerfont{institute}{size=\small}
\setbeamerfont{date}{size=\small}

% ----------------------------------------------------------------
% Dark frame environment
% For title, section dividers, conclusion slides.
% ----------------------------------------------------------------

\newenvironment{darkframe}[2][]{%
  \begingroup
  \setbeamercolor{normal text}{fg=scibLight, bg=scibDark}%
  \setbeamercolor{frametitle}{fg=scibLight}%
  \setbeamercolor{framesubtitle}{fg=scibLightMuted}%
  \setbeamercolor{itemize item}{fg=scibAccent!70!white}%
  \setbeamercolor{itemize subitem}{fg=scibLightMuted}%
  \setbeamercolor{enumerate item}{fg=scibAccent!70!white}%
  \setbeamertemplate{frametitle}{%
    \vskip6pt%
    {\usebeamerfont{frametitle}\color{scibLight}\insertframetitle}%
    \ifx\insertframesubtitle\empty\else
      \par\vskip1pt%
      {\usebeamerfont{framesubtitle}\color{scibLightMuted}\insertframesubtitle}%
    \fi
    \vskip2pt%
    {\color{scibLight!20}\hrule height 0.4pt}%
    \vskip4pt%
  }%
  \usebeamercolor[fg]{normal text}%
  \begin{frame}[environment=darkframe,#1]{#2}%
}{%
  \end{frame}%
  \endgroup
}

% ----------------------------------------------------------------
% Section divider
% ----------------------------------------------------------------

\newcommand{\sectiondivider}{%
  \begin{darkframe}[c,plain]{}
    \centering
    {\usebeamerfont{title}\color{scibLight}\insertsection\par}%
  \end{darkframe}
}

\newcommand{\enablesectiondividers}{%
  \AtBeginSection{\sectiondivider}%
}

% ----------------------------------------------------------------
% Conclusion slide
% ----------------------------------------------------------------

\newcommand{\conclusionslide}[2][Thank you]{%
  \begin{darkframe}[c,plain]{}
    \centering
    {\usebeamerfont{title}\color{scibLight}#1\par}%
    \vskip10pt%
    {\normalsize\color{scibLightMuted}#2\par}%
  \end{darkframe}
}

% ----------------------------------------------------------------
% Highlight box (tcolorbox) — for key findings, take-home points
% ----------------------------------------------------------------

\newtcolorbox{highlight}[1][]{%
  enhanced,
  colback=scibAccentBg,
  colframe=scibAccentBg,
  boxrule=0pt,
  borderline west={2.5pt}{0pt}{scibAccent},
  sharp corners,
  left=8pt, right=8pt, top=5pt, bottom=5pt,
  fonttitle=\bfseries\color{scibAccentDark},
  coltitle=scibAccentDark,
  #1
}

\newtcolorbox{notebox}[1][]{%
  enhanced,
  colback=scibBg,
  colframe=scibBg,
  boxrule=0pt,
  borderline west={2.5pt}{0pt}{scibDark},
  sharp corners,
  left=8pt, right=8pt, top=5pt, bottom=5pt,
  fonttitle=\bfseries\color{scibDark},
  coltitle=scibDark,
  #1
}

% ----------------------------------------------------------------
% Stat callout (large numbers with labels)
% ----------------------------------------------------------------

\newcommand{\statcallout}[3][scibDark]{%
  \begin{center}
    {\fontsize{44}{48}\selectfont\bfseries\color{#1}#2\par}%
    \vskip3pt%
    {\small\color{scibMuted}#3\par}%
  \end{center}%
}

\newcommand{\stat}[3][scibDark]{%
  \begin{minipage}[t]{0.22\textwidth}%
    \centering
    {\fontsize{32}{36}\selectfont\bfseries\color{#1}#2\par}%
    \vskip2pt%
    {\small\color{scibMuted}#3\par}%
  \end{minipage}%
}

\newcommand{\statrow}[1]{%
  \begin{center}
    \begin{tabular}{*{10}{c}}
      #1
    \end{tabular}
  \end{center}
}

% ----------------------------------------------------------------
% Two-column helper
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
  \def\scib@figurepanelcaption{#1}%
}{%
  \ifx\scib@figurepanelcaption\empty\else
    \vskip2pt%
    {\small\color{scibMuted}\scib@figurepanelcaption\par}%
  \fi
  \end{figure}%
}

\newcommand{\panel}[3][0.48]{%
  \begin{minipage}[t]{#1\textwidth}%
    \centering
    \includegraphics[width=\linewidth]{#2}%
    \par\vskip2pt%
    {\footnotesize\color{scibMuted}#3}%
  \end{minipage}\hfill%
}

% ----------------------------------------------------------------
% Source attribution for figures and tables
%
% Usage: \source{EPAD cohort, 2024}
% Renders as small muted text below the current element.
% ----------------------------------------------------------------

\newcommand{\source}[1]{%
  \par\vskip2pt%
  {\scriptsize\color{scibMuted}\textit{Source:} #1\par}%
}

% ----------------------------------------------------------------
% Table styling
% Works with booktabs. Sets default beamer table colours.
% ----------------------------------------------------------------

\setbeamercolor{table head}{fg=scibLight, bg=scibDark}

% Helper: a styled table header row
% Usage: \rowcolor{scibDark} applied manually, then \thead{} per cell.
%   \rowcolor{scibDark} \thead{Col 1} & \thead{Col 2} & \thead{Col 3} \\
\newcommand{\thead}[1]{\bfseries\color{scibLight}#1}

% Alternating row shading (optional, use inside tabular)
\newcommand{\shaderow}{\rowcolor{scibBg}}

% ----------------------------------------------------------------
% References — biblatex with biber
%
% Superscript numeric citations (Vancouver style).
% Styled bibliography slides at the end.
%
% In preamble of your .tex file:
%   \addbibresource{refs.bib}
%
% In body:
%   \cite{jones2024}          → superscript [1]
%   \fullcite{jones2024}      → full inline ref
%
% At end:
%   \begin{referenceslide}
%     \printbibliography[heading=none]
%   \end{referenceslide}
% ----------------------------------------------------------------

\RequirePackage[
  backend=biber,
  style=numeric-comp,
  sorting=none,
  autocite=superscript,
  maxbibnames=3,
  minbibnames=1,
  maxcitenames=2,
  mincitenames=1,
  giveninits=true,
  doi=false,
  isbn=false,
  url=false,
  eprint=false,
]{biblatex}

% Make \cite produce superscript numbers by aliasing to \supercite
\let\cite=\supercite

% Style the bibliography entries: small, muted numbers, compact
\DeclareFieldFormat{labelnumberwidth}{\mkbibbold{\color{scibAccent}#1}}
\setbeamertemplate{bibliography item}[text]
\setbeamercolor{bibliography item}{fg=scibAccent}
\setbeamercolor{bibliography entry author}{fg=scibText}
\setbeamercolor{bibliography entry title}{fg=scibText}
\setbeamercolor{bibliography entry location}{fg=scibMuted}
\setbeamercolor{bibliography entry note}{fg=scibMuted}
\setbeamerfont{bibliography item}{size=\scriptsize}
\setbeamerfont{bibliography entry author}{size=\scriptsize}
\setbeamerfont{bibliography entry title}{size=\scriptsize}
\setbeamerfont{bibliography entry location}{size=\scriptsize}
\setbeamerfont{bibliography entry note}{size=\scriptsize}

% Reduce spacing between bibliography entries
\setlength\bibitemsep{2pt}
\setlength\biblabelsep{4pt}

% Convenience environment for reference slides
% Uses allowframebreaks so long bibliographies auto-paginate.
\newenvironment{referenceslide}[1][References]{%
  \begin{frame}[allowframebreaks]{#1}%
}{%
  \end{frame}%
}

% ----------------------------------------------------------------
% Appendix slides (unnumbered, after \appendix)
% Uses appendixnumberbeamer to reset frame counter.
% ----------------------------------------------------------------

% ----------------------------------------------------------------
% Embedded file attachments
%
% Embeds files inside the PDF so they travel with it. Double-clicking
% the icon in a compatible viewer (Acrobat, Foxit, Okular) extracts
% and opens the file. Not supported in macOS Preview.
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
  color=scibAccent,
  icon=Paperclip,
  mimetype=application/octet-stream,
}

% Embed a file with an icon (default: paperclip)
% Optional argument: attachfile2 key-value options
\newcommand{\embedfile}[2][]{%
  \attachfile[#1]{#2}%
}

% Embed a file with clickable text instead of an icon
\newcommand{\embedfilelink}[3][]{%
  \textattachfile[#1]{#2}{{\small\color{scibAccent}\underline{#3}}}%
}

% Link to a local file without embedding (uses \href{run:...})
\newcommand{\localfilelink}[2]{%
  {\small\color{scibAccent}\href{run:#1}{\underline{#2}}}%
}

% ----------------------------------------------------------------
% Draft / watermark mode
%
% Enable with class option: draft
% Or in preamble: \enabledraft  /  \enabledraft[CONFIDENTIAL]
% Places a diagonal watermark across every slide.
% ----------------------------------------------------------------

\newif\ifscib@draft \scib@draftfalse
\def\scib@drafttext{DRAFT}

\newcommand{\enabledraft}[1][DRAFT]{%
  \scib@drafttrue
  \def\scib@drafttext{#1}%
}

% Hook into every frame
\addtobeamertemplate{background}{}{%
  \ifscib@draft
    \begin{tikzpicture}[remember picture, overlay]
      \node[rotate=45, scale=6, text=scibAccent!12, font=\bfseries\sffamily]
        at (current page.center) {\scib@drafttext};
    \end{tikzpicture}%
  \fi
}

% ----------------------------------------------------------------
% QR code generation
%
% Requires the qrcode package. Generates QR codes inline.
%
% Usage:
%   \slideqr{https://doi.org/10.1234/example}
%   \slideqr[2cm]{https://example.com}          with custom size
%   \slideqrbox{https://example.com}{Scan for full paper}
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
    {\scriptsize\color{scibMuted}#3}%
  \end{minipage}%
}

% QR code anchored to bottom-right of slide (for use anywhere in a frame)
\newcommand{\slideqrcorner}[2][1.2cm]{%
  \begin{tikzpicture}[remember picture, overlay]
    \node[anchor=south east, inner sep=0pt]
      at ([xshift=-12mm, yshift=10mm]current page.south east)
      {\qrcode[height=#1]{#2}};
  \end{tikzpicture}%
}

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
  \gdef\scib@compright{#2}%
  \begin{columns}[T]
  \begin{column}{0.47\textwidth}
    {\small\bfseries\color{scibAccent}#1\par}%
    \vskip1pt{\color{scibRule}\hrule height 0.3pt}\vskip4pt%
}{%
  \end{column}
  \end{columns}
}
\newcommand{\comparisondivide}{%
  \end{column}%
  \hfill%
  \begin{column}{0.47\textwidth}%
    {\small\bfseries\color{scibAccent}\scib@compright\par}%
    \vskip1pt{\color{scibRule}\hrule height 0.3pt}\vskip4pt%
}

% ----------------------------------------------------------------
% Title-only frame
%
% A frame that renders only the title and subtitle with no body
% content, useful for introducing a topic before detailed slides.
%
% Usage:
%   \titleonlyframe{Main Point}{Optional elaboration below}
% ----------------------------------------------------------------

\newcommand{\titleonlyframe}[2][]{%
  \begin{frame}[c]{}
    \centering
    {\usebeamerfont{title}\color{scibDark}#2\par}%
    \ifx\relax#1\relax\else
      \vskip8pt%
      {\large\color{scibMuted}#1\par}%
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
    enhanced, colback=scibBg, colframe=scibBg,
    boxrule=0pt, sharp corners,
    left=6pt, right=6pt, top=3pt, bottom=3pt,
  ]
    {\small\color{scibMuted}#1}%
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
    \color{scibMuted}\small
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
    {\Large\itshape\color{scibDark}``#1''\par}%
    \vskip10pt%
    {\normalsize\color{scibMuted}#2\par}%
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
        \fill[scibDark, opacity=#1]
          (current page.south west) rectangle (current page.north east);
      \fi
    \end{tikzpicture}%
  \end{frame}
}

% ----------------------------------------------------------------
% Warning / success / info boxes
%
% Additional callout levels beyond highlight and notebox.
% ----------------------------------------------------------------

\definecolor{scibWarning}{HTML}{B85C00}
\definecolor{scibWarningBg}{HTML}{FFF4E6}
\definecolor{scibSuccess}{HTML}{2D6A4F}
\definecolor{scibSuccessBg}{HTML}{EDF5F0}
\definecolor{scibInfo}{HTML}{0072B2}
\definecolor{scibInfoBg}{HTML}{E8F2FA}

\newtcolorbox{warningbox}[1][]{%
  enhanced, colback=scibWarningBg, colframe=scibWarningBg,
  boxrule=0pt, borderline west={2.5pt}{0pt}{scibWarning},
  sharp corners, left=8pt, right=8pt, top=5pt, bottom=5pt,
  fonttitle=\bfseries\color{scibWarning}, coltitle=scibWarning, #1
}

\newtcolorbox{successbox}[1][]{%
  enhanced, colback=scibSuccessBg, colframe=scibSuccessBg,
  boxrule=0pt, borderline west={2.5pt}{0pt}{scibSuccess},
  sharp corners, left=8pt, right=8pt, top=5pt, bottom=5pt,
  fonttitle=\bfseries\color{scibSuccess}, coltitle=scibSuccess, #1
}

\newtcolorbox{infobox}[1][]{%
  enhanced, colback=scibInfoBg, colframe=scibInfoBg,
  boxrule=0pt, borderline west={2.5pt}{0pt}{scibInfo},
  sharp corners, left=8pt, right=8pt, top=5pt, bottom=5pt,
  fonttitle=\bfseries\color{scibInfo}, coltitle=scibInfo, #1
}

% ----------------------------------------------------------------
% Slide footnotes
%
% Usage:
%   \slidefootnote{Data from EPAD cohort, n = 1,906}
%   \slidefootnote[0.5\paperwidth]{Shorter note}
% ----------------------------------------------------------------

\newcommand{\slidefootnote}[2][0.7\paperwidth]{%
  \begin{tikzpicture}[remember picture, overlay]
    \node[anchor=south west, inner sep=0pt, text width=#1]
      at ([xshift=12mm, yshift=8mm]current page.south west)
      {\scriptsize\color{scibMuted}#2};
  \end{tikzpicture}%
}

% ----------------------------------------------------------------
% Statistical formatting helpers
%
% Usage:
%   \pval{0.003}                   -> p = .003
%   \pval{0.00001}                 -> p < .001
%   \ci{1.23}{0.98}{1.56}         -> 1.23 [0.98, 1.56]
%   \CI{95}{1.23}{0.98}{1.56}     -> 1.23, 95% CI [0.98, 1.56]
%   \effectsize{d}{0.45}           -> d = 0.45
%   \chisq{2.34}                   -> χ² = 2.34
%   \fstat{3}{120}{4.56}           -> F(3, 120) = 4.56
%   \tstat{120}{2.34}              -> t(120) = 2.34
%   \OR{2.1}{1.4}{3.2}            -> OR = 2.1 [1.4, 3.2]
%   \HR{0.72}{0.58}{0.90}         -> HR = 0.72 [0.58, 0.90]
%   \betacoef{0.34}               -> β = 0.34
% ----------------------------------------------------------------

\newcommand{\pval}[1]{%
  \ifdim #1 pt < 0.001 pt
    \textit{p}~<~.001%
  \else
    \textit{p}~=~\strip@prefix\meaning\csname scib@pval@#1\endcsname
  \fi
}
% Simpler robust version that avoids pgfmath issues:
\renewcommand{\pval}[1]{%
  \textit{p}~\ifdim #1pt<0.001pt <~.001\else =~#1\fi
}

\newcommand{\ci}[3]{%
  #1~[#2,~#3]%
}

\newcommand{\CI}[4]{%
  #2,~#1\%~CI~[#3,~#4]%
}

\newcommand{\effectsize}[2]{%
  \textit{#1}~=~#2%
}

\newcommand{\chisq}[1]{%
  \ensuremath{\chi^2}~=~#1%
}

\newcommand{\fstat}[3]{%
  \textit{F}(#1,\,#2)~=~#3%
}

\newcommand{\tstat}[2]{%
  \textit{t}(#1)~=~#2%
}

\newcommand{\OR}[3]{%
  OR~=~#1~[#2,~#3]%
}

\newcommand{\HR}[3]{%
  HR~=~#1~[#2,~#3]%
}

\newcommand{\betacoef}[1]{%
  \ensuremath{\beta}~=~#1%
}

% ----------------------------------------------------------------
% Finding / limitation / implication callout boxes
%
% Usage:
%   \begin{findingbox}
%     Sleep fragmentation mediated the effect of age on
%     executive function (\betacoef{-0.23}, \pval{0.003}).
%   \end{findingbox}
%
%   \begin{findingbox}[Key Result]
%     Custom title...
%   \end{findingbox}
%
%   \begin{limitationbox}
%     Cross-sectional design precludes causal inference.
%   \end{limitationbox}
%
%   \begin{implicationbox}
%     Targeting sleep quality may improve cognitive outcomes.
%   \end{implicationbox}
% ----------------------------------------------------------------

\newtcolorbox{findingbox}[1][Key Finding]{%
  enhanced, colback=scibAccentBg, colframe=scibAccentBg,
  boxrule=0pt, borderline west={3pt}{0pt}{scibAccent},
  sharp corners, left=8pt, right=8pt, top=5pt, bottom=5pt,
  fonttitle=\small\bfseries\color{scibAccentDark},
  coltitle=scibAccentDark, title={#1},
}

\newtcolorbox{limitationbox}[1][Limitation]{%
  enhanced, colback=scibWarningBg, colframe=scibWarningBg,
  boxrule=0pt, borderline west={3pt}{0pt}{scibWarning},
  sharp corners, left=8pt, right=8pt, top=5pt, bottom=5pt,
  fonttitle=\small\bfseries\color{scibWarning},
  coltitle=scibWarning, title={#1},
}

\newtcolorbox{implicationbox}[1][Clinical Implication]{%
  enhanced, colback=scibSuccessBg, colframe=scibSuccessBg,
  boxrule=0pt, borderline west={3pt}{0pt}{scibSuccess},
  sharp corners, left=8pt, right=8pt, top=5pt, bottom=5pt,
  fonttitle=\small\bfseries\color{scibSuccess},
  coltitle=scibSuccess, title={#1},
}

% ----------------------------------------------------------------
% APA-style figure and table notes
%
% Usage:
%   \figurenote{N = 245. Error bars represent 95\% CIs.}
%   \tablenote{Bold values indicate significance at p < .05.}
%   \sigmarkers
% ----------------------------------------------------------------

\newcommand{\figurenote}[1]{%
  \par\vskip2pt%
  {\scriptsize\color{scibText}\textit{Note.}~#1\par}%
}

\newcommand{\tablenote}[1]{%
  \par\vskip2pt%
  {\scriptsize\color{scibText}\textit{Note.}~#1\par}%
}

\newcommand{\sigmarkers}{%
  \par\vskip1pt%
  {\scriptsize\color{scibMuted}%
    *\,\textit{p}~<~.05.\quad
    **\,\textit{p}~<~.01.\quad
    ***\,\textit{p}~<~.001.\par}%
}

% ----------------------------------------------------------------
% Backup slides section
%
% Usage:
%   \backupslides
%   \begin{frame}{Additional Analysis 1} ... \end{frame}
% ----------------------------------------------------------------

\newcommand{\backupslides}{%
  \appendix
  \begin{darkframe}[c,plain]{}
    \centering
    {\usebeamerfont{title}\color{scibLight}Backup Slides\par}%
    \vskip6pt%
    {\normalsize\color{scibLightMuted}Additional analyses and supplementary material\par}%
  \end{darkframe}
}

% ----------------------------------------------------------------
% Equation highlighting
%
% Usage:
%   In display math: $Y = \eqhl{\beta_1} X + \epsilon$
%   \eqhl[scibSuccess]{\beta_1}
%
%   \begin{eqbox}[Model 1]
%     $Y_i = \beta_0 + \beta_1 X_i + \epsilon_i$
%   \end{eqbox}
% ----------------------------------------------------------------

\newcommand{\eqhl}[2][scibAccent]{%
  \tikz[baseline=(X.base)]{%
    \node[fill=#1!15, inner sep=1.5pt, rounded corners=1pt] (X) {$\displaystyle #2$};%
  }%
}

\newtcolorbox{eqbox}[1][]{%
  enhanced, colback=scibBg, colframe=scibRule,
  boxrule=0.4pt, sharp corners,
  left=4pt, right=4pt, top=4pt, bottom=4pt,
  fonttitle=\scriptsize\color{scibMuted},
  coltitle=scibMuted,
  title={#1},
}

% ----------------------------------------------------------------
% Corresponding author and ORCID
%
% Usage:
%   \author{Ross Dunne\corresponding \and Jane Smith}
%   % On title slide:
%   \correspondinginfo{ross.dunne@example.ac.uk}
%
%   % In acknowledgements or title:
%   \orcid{0000-0001-2345-6789}
% ----------------------------------------------------------------

\newcommand{\corresponding}{%
  \textsuperscript{\color{scibAccent}*}%
}

\newcommand{\correspondinginfo}[1]{%
  \begin{tikzpicture}[remember picture, overlay]
    \node[anchor=south west, inner sep=0pt]
      at ([xshift=12mm, yshift=4mm]current page.south west)
      {\scriptsize\color{scibLightMuted}\textsuperscript{*}Corresponding author: #1};
  \end{tikzpicture}%
}

\newcommand{\orcid}[1]{%
  {\scriptsize\color{scibAccent}\href{https://orcid.org/#1}{ORCID: #1}}%
}

% ----------------------------------------------------------------
% Research question / hypothesis frames
%
% Usage:
%   \researchquestion{Does sleep architecture mediate the
%     relationship between age and cognitive decline?}
%
%   \hypothesis{We hypothesise that increased sleep
%     fragmentation will be associated with lower
%     executive function scores, controlling for age.}
%
%   \hypothesis[H\textsubscript{2}]{Secondary hypothesis here}
% ----------------------------------------------------------------

\newcommand{\researchquestion}[2][Research Question]{%
  \begin{frame}[c]{}
    \centering
    {\small\bfseries\color{scibAccent}\MakeUppercase{#1}\par}%
    \vskip8pt%
    {\Large\color{scibDark}\itshape #2\par}%
  \end{frame}
}

\newcommand{\hypothesis}[2][Hypothesis]{%
  \begin{frame}[c]{}
    \centering
    {\small\bfseries\color{scibAccent}\MakeUppercase{#1}\par}%
    \vskip8pt%
    {\large\color{scibDark}#2\par}%
  \end{frame}
}

% ----------------------------------------------------------------
% Study design summary frame
%
% Usage:
%   \begin{studydesign}{Methods}
%     \designitem{Design}{Cross-sectional observational}
%     \designitem{Sample}{N = 1,906 from EPAD cohort}
%     \designitem{Outcome}{RBANS Total Scale score}
%     \designitem{Analysis}{Structural equation modelling}
%   \end{studydesign}
% ----------------------------------------------------------------

\newenvironment{studydesign}[1]{%
  \begin{frame}{#1}%
}{%
  \end{frame}%
}

\newcommand{\designitem}[2]{%
  \par\vskip4pt%
  \begin{minipage}[t]{0.22\textwidth}%
    \raggedleft
    {\small\bfseries\color{scibAccent}#1}%
  \end{minipage}%
  \hspace{8pt}%
  \begin{minipage}[t]{0.70\textwidth}%
    {\small\color{scibText}#2}%
  \end{minipage}%
}

% ----------------------------------------------------------------
% Sample / CONSORT flow helper
%
% Usage:
%   \flowbox{Screened\\(N = 3{,}200)}
%   \flowboxexcluded{Excluded (n = 450)\\Did not meet criteria}
%   \flowarrow
% ----------------------------------------------------------------

\newcommand{\flowbox}[1]{%
  \tikz{%
    \node[draw=scibAccent, rounded corners=2pt, fill=scibAccentBg,
      text=scibText, font=\small, align=center,
      inner xsep=8pt, inner ysep=4pt] {#1};%
  }%
}

\newcommand{\flowboxexcluded}[1]{%
  \tikz{%
    \node[draw=scibRule, rounded corners=2pt, fill=scibBg,
      text=scibMuted, font=\scriptsize, align=center,
      inner xsep=6pt, inner ysep=3pt] {#1};%
  }%
}

\newcommand{\flowarrow}{%
  \par\vskip2pt%
  \centering\tikz{\draw[->, scibAccent, line width=1pt] (0,0) -- (0,-0.5);}%
  \par\vskip2pt%
}

% ----------------------------------------------------------------
% End of class
% ----------------------------------------------------------------
\endinput