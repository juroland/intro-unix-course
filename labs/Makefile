INPUTS=$(wildcard *.md)
OUTPUTS=$(patsubst %.md,%.pdf,$(INPUTS))

all: $(OUTPUTS)

%.pdf: %.md
	pandoc --template=../../pandoc-templates/default.latex --filter pandoc-numbering -V geometry:margin=1in $< -o $@

clean:
	rm -rf $(OUTPUTS)
