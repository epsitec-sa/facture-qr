# facture-qr

This repository hosts a validator for the Swiss QR Invoice and
the `S1` format for additional information defined by Swico.
The project is built as an [Elm](http://elm-lang.org/) app.

It is based on the [Elm Webpack starter](https://github.com/moarwick/elm-webpack-starter) project.

## Building and running the application

### Install

Install all dependencies using the handy `reinstall` script:

```bash
npm run reinstall
```

This does a clean (re)install of all npm and elm packages, plus
a **global** `elm` and `rimraf` install.

### Serve locally

```bash
npm start
```

* Access app at `http://localhost:8080/`
* Get coding! The entry point file is `src/elm/Main.elm`
* Browser will refresh automatically on any file changes

### Build & bundle for prod:

```bash
npm run build
```

* Files are saved into the `/dist` folder
* To check it, open `dist/index.html`
