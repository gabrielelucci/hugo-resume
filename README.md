# Resume with Hugo

This project generates a personal resume using Hugo, a static site generator.

The resume is defined in [config/_default/](config/_default/), in English
([params.en.toml](config/_default/params.en.toml)) and Italian
([params.it.toml](config/_default/params.it.toml)), and is styled using the
[companion Hugo theme](https://github.com/gabrielelucci/hugo-devresume-theme).
Keep the two languages in sync, and check that each still prints to a single page.

## Prerequisites

- [Hugo](https://gohugo.io/installation/) (extended edition)
- [Node.js](https://nodejs.org/) (for theme dependencies)
- [Docker](https://docs.docker.com/get-docker/) or [Podman](https://podman.io/) (for containerized builds)

## Setup

Clone with submodules and install theme dependencies:

```sh
git clone --recurse-submodules <repo-url>
cd hugo-resume
npm ci --prefix themes/hugo-devresume-theme
```

## Local development

```sh
hugo server -D
```

The site will be available at `http://localhost:1313/resume/` (English) and
`http://localhost:1313/resume/it/` (Italian).

## Printing to PDF

The phone number is read from `HUGO_RESUME_PHONE` at build time, so it never lands in
the repository or on the published site, where it would get scraped. To print a copy
with it, serve the resume locally and use the browser's _Print → Save as PDF_:

```sh
HUGO_RESUME_PHONE="+39 …" hugo server
```

Or, without a local Hugo:

```sh
podman run --rm -e HUGO_RESUME_PHONE="+39 …" -v .:/src:Z -p 1313:1313 \
  ghcr.io/hugomods/hugo:exts hugo server --bind 0.0.0.0
```

## Production build

### Using Hugo directly

```sh
hugo --minify --gc
```

Output will be in the `public/` directory.

## TODO

- Define the resume as a JSON file, possibly using [JSON resume schema](https://jsonresume.org/schema), instead of TOML.
- Make the JSON itself downloadable.
