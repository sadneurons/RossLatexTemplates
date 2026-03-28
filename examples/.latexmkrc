## latexmkrc for examples directory
## Ensures cls/sty files in the parent directory are found.
ensure_path('TEXINPUTS', '..//');
ensure_path('BIBINPUTS', '..//');
$pdf_mode = 5;        # xelatex via pdf
$xelatex = 'xelatex -interaction=nonstopmode -synctex=1 %O %S';
