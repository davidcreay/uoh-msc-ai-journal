# uoh-msc-ai-journal

Learning journal and coursework for the MSc AI programme (University of Hertfordshire).

## Layout

- **Root:** `README.md`, `Makefile`, `.gitignore`. Config and templates live in `config/` and `templates/`.
- **config/** — Shared LaTeX/bib (e.g. `glossary.tex`, `refs.bib`).
- **templates/** — `templates/assignment/` is the assignment template (use `make assignment ASSIGNMENT_NAME=...` to copy).
- **modules/** — One folder per module:
  - **ml/** — Machine Learning (unit1–unit11), R scripts, tasks, Graded_Discussion, activities.
  - **responsible-technology-1/** — LaTeX dissertation and build; `exam_prep/` for revision materials.
  - **responsible-technology-2/** — Exercises, projects, and module materials (submitted work lives in `_submissions/`, not here).
- **journal/** — Reflections and notes by module; one file per unit or week (e.g. `journal/ml/unit01.md` … `unit11.md`). See `journal/README.md`.
- **assets/** — Course materials and shared media: `assets/course/` (briefs and unit materials), `assets/fonts/`, `assets/images/`.
- **src/msc_ai/** — Python and other code.

## Assignments and private content

Assignment submissions and private reflection content are kept **locally only** and are **not** in this repository. They live in the `_submissions/` folder (and that folder is listed in `.gitignore`). Back them up elsewhere (e.g. OneDrive, Canvas, or a private repo) if you need version history or cloud backup.

## Building

From the repo root, run `make` to build LaTeX PDFs (from `modules/responsible-technology-1/`) and create the submission zip (see `Makefile`).
