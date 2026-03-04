# ==============================
# LaTeX Build Configuration
# ==============================
MODULE := IGO741
ID     := DavidReay
ZIP    := $(ID)_$(MODULE).zip
SUBDIRS := modules/responsible-technology-1

# ==============================
# Build Targets
# ==============================
.PHONY: all pdfs clean zip

all: pdfs zip

# Run 'make' in each subdirectory
pdfs:
	@for dir in $(SUBDIRS); do \
		echo "📄 Building $$dir..."; \
		$(MAKE) -C $$dir; \
	done

# Collect PDFs and create zip
zip:
	@echo "📦 Collecting PDFs..."
	@rm -f $(ZIP)
	@mkdir -p _dist
	@for dir in $(SUBDIRS); do \
		find $$dir -maxdepth 1 -type f -name '*.pdf' -exec cp {} _dist/ \; ; \
	done
	@zip -j $(ZIP) _dist/*.pdf
	@rm -rf _dist
	@echo "✅ Created $(ZIP)"

clean:
	@for dir in $(SUBDIRS); do \
		echo "🧹 Cleaning $$dir..."; \
		$(MAKE) -C $$dir clean || true; \
	done
	@rm -f $(ZIP)

ASSIGNMENT_NAME?=
assignment:
	echo "Copying template to ...$(ASSIGNMENT_NAME)"
	cp -rf templates/assignment $(ASSIGNMENT_NAME)

checkin:
	@echo "Enter commit message:"
	@read REPLY; \
	git add --all; \
	git commit -m "$$REPLY"; \
	git push