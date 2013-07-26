# i18n-extractor

This is a module/command line application to parse Javascript and search for
nodes of the form `i18n('literal string')`, printing out all such strings it
finds. (The function name can be customized.)

## Install

`npm install i18n-extractor`

## Usage

```bash
$ i18n-extract file.js
{"":["translate me","keep translating me"]}
```

## et cetera

If there's something you want, then do it and send me a pull request (please).
