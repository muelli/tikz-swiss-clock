swiss_clock_tikz.gray.pdf:


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


