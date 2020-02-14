# facture-qr

This repository hosts a validator for the Swiss QR Invoice and
the `S1` format for additional information defined by Swico.
The project is built as an [Elm](http://elm-lang.org/) app.

It is based on the [Elm Webpack starter](https://github.com/moarwick/elm-webpack-starter) project.

## Building and running the application

### Prerequisites

- Node.js and npm.
- Python 2.7.x for `node-gyp`.

Install Python 2.7.x package, easiest is with NuGet command:

```bash
nuget install python2 -ExcludeVersion -OutputDirectory .
```

Make sure that `NODE_GYP_FORCE_PYTHON` points to `./python2/tools/python.exe`,
like this, for instance (if using PowertShell):

```ps1
$env:NODE_GYP_FORCE_PYTHON= 'S:\git\swiss-qr-invoice-dev\facture-qr\python2\tools\python.exe'
```

### Install

Install all dependencies using the handy `reinstall` script:

```bash
npm run reinstall
```

This does a clean (re)install of all npm and elm packages, plus
a **global** `elm` and `rimraf` install. You might have to run it
several times if you start on a clean computer.

### Serve locally

```bash
npm start
```

- Access app at `http://localhost:8080/`
- Get coding! The entry point file is `src/elm/Main.elm`
- Browser will refresh automatically on any file changes

### Build & bundle for prod:

```bash
npm run build
```

- Files are saved into the `/dist` folder
- To check it, open `dist/index.html`
