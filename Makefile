all: arfnet2.html arfnet2.pdf

arfnet2.html: arfnet2.md template.html
	pandoc --template template.html -s arfnet2.md -o arfnet2.html

arfnet2.pdf: arfnet2.md
	pandoc -V geometry:margin=2.5cm -s arfnet2.md -o arfnet2.pdf
