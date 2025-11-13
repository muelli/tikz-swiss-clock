clock.pdf: swiss_clock_tikz.with_sources.gray.expanded.pdf
	cp -ar --reflink=auto  $^  $@

swiss_clock_tikz.pdf: swiss_clock_tikz.deps

-include swiss_clock_tikz.deps

%.pdf: %.tex
	#pdflatex --shell-escape
	latexmk -f  -pdf -use-make $*.tex


%.gray.pdf: %.pdf
	gs -sDEVICE=pdfwrite \
	    -sOutputFile=$@   \
	    -dProcessColorModel=/DeviceGray \
	    -dColorConversionStrategy=/Gray \
	    -dNOPAUSE -dBATCH   \
	    -o $@ \
	    $<


%.expanded.pdf: %.pdf
	podofouncompress  "$<"  "$@"


%.png: %.pdf
	pdftoppm -png -f 1 -l 1  $<  $@
	mv $@-1.png  $@



# Target to generate list of local input files
%.input_files: %.fls
	cat $< | \
		awk '/^INPUT/ {sub(/^INPUT\s*/, ""); sub(/^\.\//, ""); print}' | \
		grep -vE '^/usr/share/texlive|^/usr/local/texlive' | \
		grep -v '^/' | \
		grep -v '^svg-inkscape/' | \
		grep -v '\.aux$$' | \
		sort -u > $@
	echo Makefile >> $@

# Target to create source ZIP
%_sources.zip: %.input_files
	xargs -a $*.input_files zip -r $@

# Rule to create PDF with embedded sources
%.with_sources.pdf: %.pdf %_sources.zip
	#pdftk $*.pdf attach_files $*_sources.zip output $@
	#qpdf --add-attachment=$*_sources.zip $*.pdf $@
	cp $< $@  ; pdfcpu attach add  $@   '$*_sources.zip, Source files - use LaTeX to compile'
	rm $*_sources.zip

# Generate .fls file with all input files
%.fls: %.tex
	latexmk -pdf -recorder -silent $<

%.deps: %.tex
	-latexmk -pdf -silent -deps-out=$@  $<


%.pdf: %.svg
	inkscape $*.svg  --export-filename=$@  --export-pdf-version=1.5


clean:
	latexmk -c   swiss_clock_tikz
	-rm *.fls *.aux
	-rm *.deps *.input_files
	-rm *.pdf
