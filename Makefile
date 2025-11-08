swiss_clock_tikz.gray.expanded.pdf:


%.pdf: %.tex
	pdflatex --shell-escape $^


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
