swiss_clock_tikz.gray.pdf:


swiss_clock_tikz.pdf: swiss_clock_tikz.tex
	pdflatex --shell-escape $^


%.gray.pdf: %.pdf
	gs -sDEVICE=pdfwrite \
	    -sOutputFile=$@   \
	    -dProcessColorModel=/DeviceGray \
	    -dColorConversionStrategy=/Gray \
	    -dNOPAUSE -dBATCH   \
	    -o $@ \
	    $<


