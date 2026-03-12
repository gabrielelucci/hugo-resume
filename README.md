# Resume with Hugo

This project generates a personal resume using Hugo, a static site generator.

The resume is defined in [config.toml](config.toml) and is styled using the [companion Hugo theme](https://github.com/gabrielelucci/hugo-devresume-theme).

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

The site will be available at `http://localhost:1313/resume/`.

## Production build

### Using Hugo directly

```sh
hugo --minify --gc
```

Output will be in the `public/` directory.

## TODO

- Define the resume as a JSON file, possibly using [JSON resume schema](https://jsonresume.org/schema), instead of TOML.
- Make the JSON itself downloadable.
