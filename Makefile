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
