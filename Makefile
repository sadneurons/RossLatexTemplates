# ============================================================================
# Makefile for RossLatexTemplates
# Compiles example documents using latexmk with XeLaTeX + Biber.
#
# Usage:
#   make all          — compile every example in examples/
#   make clean        — remove auxiliary files
#   make <name>       — compile a single example, e.g. make scientific
#   make cheatsheet   — compile rosscheatsheet.tex (if present)
#
# Requires: TeX Live (full recommended), XeLaTeX, Biber, latexmk
# ============================================================================

# Engine and flags
LATEX_ENGINE  := xelatex
LATEXMK       := latexmk
LATEXMK_FLAGS := -$(LATEX_ENGINE) -interaction=nonstopmode -halt-on-error \
                 -shell-escape -file-line-error

# Ensure the root directory is in TEXINPUTS so .cls and .sty files are found
ROOT_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
export TEXINPUTS := $(ROOT_DIR):$(ROOT_DIR)//:$(TEXINPUTS)

# Directories
EXAMPLES_DIR := examples

# Discover all example .tex files
EXAMPLE_SRCS := $(wildcard $(EXAMPLES_DIR)/example-*.tex)
EXAMPLE_PDFS := $(EXAMPLE_SRCS:.tex=.pdf)

# Derive short names: examples/example-scientific.tex -> scientific
EXAMPLE_NAMES := $(patsubst $(EXAMPLES_DIR)/example-%.tex,%,$(EXAMPLE_SRCS))

# Auxiliary file extensions to clean
AUX_EXTS := aux log bbl bcf blg fls fdb_latexmk nav out snm toc vrb run.xml \
            synctex.gz synctex

# ============================================================================
# Default target
# ============================================================================

.PHONY: all clean help cheatsheet $(EXAMPLE_NAMES)

all: $(EXAMPLE_PDFS)
	@echo "===== All examples compiled successfully. ====="

# ============================================================================
# Pattern rule: compile any example .tex -> .pdf
# ============================================================================

$(EXAMPLES_DIR)/%.pdf: $(EXAMPLES_DIR)/%.tex
	@echo "===== Compiling $< ====="
	cd $(EXAMPLES_DIR) && $(LATEXMK) $(LATEXMK_FLAGS) $(notdir $<)

# ============================================================================
# Short-name targets: make scientific -> examples/example-scientific.pdf
# ============================================================================

define EXAMPLE_RULE
.PHONY: $(1)
$(1): $(EXAMPLES_DIR)/example-$(1).pdf
endef

$(foreach name,$(EXAMPLE_NAMES),$(eval $(call EXAMPLE_RULE,$(name))))

# ============================================================================
# Individual named targets (explicit list for discoverability)
# ============================================================================

# Beamer classes
.PHONY: scientific corporate clinical epi genomics maths minimal
.PHONY: neuroimaging pitch poster-beamer psych teaching biomarker

# Document classes
.PHONY: manuscript thesis cv letter abstract poster

# Standalone packages
.PHONY: stats figures tables code

# Combined convenience targets
.PHONY: beamer documents packages

beamer: scientific corporate clinical epi genomics maths minimal \
        neuroimaging pitch poster-beamer psych teaching biomarker

documents: manuscript thesis cv letter abstract poster

packages: stats figures tables code

# ============================================================================
# Cheatsheet (lives in the root directory)
# ============================================================================

cheatsheet: rosscheatsheet.pdf

rosscheatsheet.pdf: rosscheatsheet.tex
	@echo "===== Compiling cheatsheet ====="
	$(LATEXMK) $(LATEXMK_FLAGS) $<

# ============================================================================
# Clean
# ============================================================================

clean:
	@echo "===== Cleaning auxiliary files ====="
	@for ext in $(AUX_EXTS); do \
		find . -name "*.$$ext" -type f -delete 2>/dev/null; \
	done
	@# Also clean latexmk's own tracking files
	@find . -name "*.xdv" -type f -delete 2>/dev/null
	@echo "===== Clean complete. ====="

clean-pdf:
	@echo "===== Removing generated PDFs ====="
	@find $(EXAMPLES_DIR) -name "*.pdf" -type f -delete 2>/dev/null
	@rm -f rosscheatsheet.pdf
	@echo "===== PDF removal complete. ====="

distclean: clean clean-pdf

# ============================================================================
# Help
# ============================================================================

help:
	@echo ""
	@echo "RossLatexTemplates — Build System"
	@echo "================================="
	@echo ""
	@echo "  make all           Compile all examples"
	@echo "  make <name>        Compile a single example (e.g. make scientific)"
	@echo "  make beamer        Compile all beamer examples"
	@echo "  make documents     Compile all document-class examples"
	@echo "  make packages      Compile all standalone-package examples"
	@echo "  make cheatsheet    Compile the cheatsheet"
	@echo "  make clean         Remove auxiliary files"
	@echo "  make clean-pdf     Remove generated PDFs"
	@echo "  make distclean     Remove aux files and PDFs"
	@echo "  make help          Show this help message"
	@echo ""
	@echo "Available example names:"
	@echo "  $(EXAMPLE_NAMES)" | fold -s -w 72
	@echo ""
	@echo "Engine: $(LATEX_ENGINE) via latexmk"
	@echo "TEXINPUTS includes: $(ROOT_DIR)"
	@echo ""
