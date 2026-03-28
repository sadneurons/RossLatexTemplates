# CLAUDE.md — Project Conventions for RossLatexTemplates

## Project Overview

RossLatexTemplates is a modular LaTeX template ecosystem providing:

- **Beamer presentation classes** for scientific talks, corporate decks,
  clinical reports, epidemiology, genomics, neuroimaging, and more.
- **Document classes** for manuscripts, theses, CVs, letters, abstracts,
  and posters.
- **Standalone packages** for statistics formatting, code listings,
  figures, and tables.

All classes share a consistent palette system, font infrastructure, and
visual identity while allowing domain-specific customisation.

---

## Architecture

```
rossbeamerbase.sty          Shared infrastructure for ALL beamer classes
    |                       (fonts, colours, progress bar, environments)
    +-- rossbeamerscientific.cls
    +-- rossbeamercorporate.cls
    +-- rossbeamerclinical.cls
    +-- rossbeamerepi.cls
    +-- rossbeamergenomics.cls
    +-- rossbeamermaths.cls
    +-- rossbeamerminimal.cls
    +-- rossbeamerneuroimaging.cls
    +-- rossbeamerpitch.cls
    +-- rossbeamerposter.cls
    +-- rossbeamerpsych.cls
    +-- rossbeamerteaching.cls
    +-- rossbeamerbiomarker.cls

rosspalettes.sty            Shared palette system for NON-beamer classes
    |                       (rpPrimary, rpSecondary, rpAccent, etc.)
    +-- rossmanuscript.cls
    +-- rossthesis.cls
    +-- rosscv.cls
    +-- rossletter.cls
    +-- rossabstract.cls
    +-- rossposter.cls

Standalone packages (usable with any document class):
    rossstats.sty           Statistical formatting helpers
    rossfigures.sty         Figure placement and styling
    rosstables.sty          Table formatting
    rosscode.sty            Code listing configuration
```

---

## File Naming Conventions

| Pattern               | Purpose                          |
|-----------------------|----------------------------------|
| `rossbeamer*.cls`     | Beamer presentation classes      |
| `ross*.cls`           | Non-beamer document classes      |
| `ross*.sty`           | Shared packages / infrastructure |
| `examples/example-*.tex` | Compilable example documents  |

---

## Colour Naming

- **Beamer classes** use the `rb*` prefix: `rbPrimary`, `rbSecondary`,
  `rbAccent`, `rbText`, `rbTextLight`, `rbTextMuted`, `rbBg`.
  Derived tints: `rbPrimaryLight`, `rbPrimaryDark`, etc.
- **Document classes** use the `rp*` prefix: `rpPrimary`, `rpSecondary`,
  `rpAccent`, `rpText`, `rpTextLight`, `rpTextMuted`, `rpBg`.

Both systems define the same 7 semantic slots; only the prefix differs.

---

## Build Instructions

### Requirements

- **TeX Live Full** (recommended) or equivalent distribution
- **XeLaTeX** (fontspec requires it; LuaLaTeX also works)
- **Biber** (for biblatex-based classes)
- **latexmk** (build orchestrator)

### Compiling

```bash
make all              # Compile every example
make scientific       # Compile a single example
make beamer           # Compile all beamer examples
make documents        # Compile all document-class examples
make cheatsheet       # Compile the cheatsheet
make clean            # Remove auxiliary files
```

TEXINPUTS is configured by the Makefile so that .cls and .sty files in
the repository root are found automatically.

---

## How to Add a New Palette

1. **For beamer classes**: open `rossbeamerbase.sty`, find the palette
   definition block, and add a new `\rb@defpal{name}{...}` entry with
   7 colours (primary, secondary, accent, text, textlight, textmuted, bg).
   Then add the palette name to the documentation comment at the top of
   each beamer `.cls` that should support it.

2. **For document classes**: open `rosspalettes.sty`, find the palette
   block, and add a new `\rp@defpal{name}{...}` entry with the same
   7 fields. Update the documentation comment in each document `.cls`.

Palettes must be added to **both** systems if you want them available
everywhere.

---

## How to Add a New Beamer Class

1. Copy an existing class (e.g., `rossbeamerscientific.cls`) as a
   starting skeleton.
2. Rename the file to `rossbeamer<domain>.cls`.
3. Update `\ProvidesClass`, the pgfkeys namespace, and internal macro
   prefixes.
4. Define which palettes are available (or inherit all from base).
5. Add domain-specific features: custom environments, title page
   layouts, specialised frames.
6. Call `\rb@setupbeamer` (from `rossbeamerbase.sty`) to activate the
   shared beamer infrastructure.
7. Create a matching `examples/example-<domain>.tex` file.
8. Run `make <domain>` to verify compilation.

---

## Common Patterns

- **pgfkeys option handling**: each class defines a pgfkeys family
  (e.g., `/scibeamer/`) with `palette`, `font`, `monofont`, `nobar`,
  `nologo` keys. Options are processed with `\ProcessPgfOptions`.
- **`\rb@setupbeamer` call**: after the beamer class loads and palette
  colours are activated, this macro (from `rossbeamerbase.sty`) sets up
  the beamer colour theme, inner/outer themes, fonts, and templates.
- **Palette activation**: the loading class maps its chosen palette to
  the 7 semantic `rb*` colours, then calls the base setup. The base
  derives tints and shades automatically.
- **`\newif` flags**: `\ifrb@nobar` and `\ifrb@nologo` are defined
  early (before loading the base) so the base can read them.

---

## Testing

To verify changes have not broken anything:

```bash
make clean && make all
```

Every file in `examples/` should compile without errors. Warnings about
missing fonts can be resolved by installing the relevant font packages
or switching to `font=system`.

---

## Dependencies

Recommended: **TeX Live Full** (texlive-full on Debian/Ubuntu).

Key packages used across classes:
- `fontspec` (requires XeLaTeX or LuaLaTeX)
- `biblatex` + `biber` (bibliography in scientific/clinical/epi/genomics/corporate classes)
- `tcolorbox`, `tikz` (boxes and diagrams)
- `booktabs`, `subcaption` (tables and figures)
- `pgfkeys`, `pgfopts` (option processing)
- `etoolbox` (LaTeX programming utilities)
- `hyperref` (links, loaded last by most classes)
