# ==============================
# LaTeX Build Configuration
# ==============================
FILE_NAME = dissertation_main
MODULE    := Responsibility1
DOC=$(shell basename $(CURDIR))
ID        = DavidReay
ENGINE    ?= lualatex     # can be: pdflatex, lualatex, or xelatex

# ==============================
# Build Targets
# ==============================
all: clean-zone-identifiers wordcount pdf index bibtex pdf1 pdf2 rename zip count_words

pdf:
	-$(ENGINE) -interaction=nonstopmode $(FILE_NAME).tex

pdf1:
	-$(ENGINE) -interaction=nonstopmode $(FILE_NAME).tex

pdf2:
	-$(ENGINE) -interaction=nonstopmode $(FILE_NAME).tex

index:
	-makeindex -s $(FILE_NAME).ist -o $(FILE_NAME).gls $(FILE_NAME).glo > /dev/null

bibtex:
	-bibtex $(FILE_NAME) > /dev/null

rename:
	cp $(FILE_NAME).pdf $(ID)_$(DOC)_$(MODULE).pdf
	rm $(FILE_NAME).pdf

zip:
	zip $(ID)_$(DOC)_$(MODULE).zip $(ID)_$(DOC)_$(MODULE).pdf

wordcount:
	texcount -sum -1 $(FILE_NAME).tex > wordcount.txt

clean:
	@rm -rf $(FILE_NAME).aux $(FILE_NAME).bbl $(FILE_NAME).blg $(FILE_NAME).glo \
	         $(FILE_NAME).gls $(FILE_NAME).ilg $(FILE_NAME).ist $(FILE_NAME).log \
	         $(FILE_NAME).toc $(FILE_NAME).out $(FILE_NAME).pdf wordcount.txt count_words.txt

COUNT_FILE = count_words.txt
count_words:
	texcount -sub=section -v $(FILE_NAME).tex > $(COUNT_FILE)

clean-zone-identifiers:
	@echo "🧹 Removing all Zone.Identifier files..."
	@find . -type f \( -name '*:Zone.Identifier' -o -name 'Zone.Identifier' \) -print -delete 2>/dev/null || true
	@echo "✅ Done."
