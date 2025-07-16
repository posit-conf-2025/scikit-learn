PYTHON ?= python3
PIP := $(PYTHON) -m pip
VENV_DIR ?= .venv

.PHONY: setup slides render preview publish clean

setup:
	@if [ ! -d $(VENV_DIR) ]; then \
		echo "Creating virtual environment in $(VENV_DIR)"; \
		$(PYTHON) -m venv $(VENV_DIR); \
	fi
	@echo "Activating virtual environment and installing dependencies"
	@. $(VENV_DIR)/bin/activate && \
		pip install --upgrade pip && \
		pip install -r requirements.txt
	@echo "Removing original welcome notebook if it exists"
	@rm -f ../welcome.ipynb

slides:
	find ./materials/slides/ -type f -name "*.qmd" -exec quarto render {} \;

render:
	quarto render

preview:
	quarto preview index.qmd --port 8888

publish:
	# Run this once before using this target if CI is setup:
	# git checkout --orphan gh-pages
	# git reset --hard
	# git commit --allow-empty -m "Initialising gh-pages branch"
	# git push origin gh-pages

	make render
	quarto publish gh-pages

clean:
	rm -rf docs/ _site/ _freeze
	rm -rf materials/slides/.jupyter_cache
	rm -rf materials/slides/*_files
	rm -rf materials/slides/*.html

