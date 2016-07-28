# duplexer2-unwrappable

[![Build Status][ci-master]][travis-ci]
[![Coverage Status][coverage-master]][coveralls]
[![Dependency Status][dependency]][david]
[![devDependency Status][dev-dependency]][david]
[![Downloads][downloads]][npm]

Like [duplexer2](https://github.com/deoxxa/duplexer2) but unwrappable

[![NPM][npm-stats]][npm]

```javascript
var stream = require("stream");

var duplexer2 = require("duplexer2-unwrappable");

var writable = new stream.Writable({objectMode: true}),
    readable = new stream.Readable({objectMode: true});

writable._write = function _write(input, encoding, done) {
  if (readable.push(input)) {
    return done();
  } else {
    readable.once("drain", done);
  }
};

readable._read = function _read(n) {
  // no-op
};

// simulate the readable thing closing after a bit
writable.once("finish", function() {
  setTimeout(function() {
    readable.push(null);
  }, 500);
});

var duplex = duplexer2(writable, readable);

duplex.on("data", function(e) {
  console.log("got data", JSON.stringify(e));
});

duplex.on("finish", function() {
  console.log("got finish event");
});

duplex.on("end", function() {
  console.log("got end event");
});

duplex.write("oh, hi there", function() {
  console.log("finished writing");
});

duplex.end(function() {
  console.log("finished ending");
});
```

```
got data "oh, hi there"
finished writing
got finish event
finished ending
got end event
```

## Overview

This is a reimplementation of [duplexer](https://www.npmjs.com/package/duplexer) using the
Streams3 API which is standard in Node as of v4. Everything largely
works the same.



## Installation

[Available via `npm`](https://docs.npmjs.com/cli/install):

```
$ npm i duplexer2-unwrappable
```

## API

### duplexer2

Creates a new `DuplexWrapper` object, which is the actual class that implements
most of the fun stuff. **All that fun stuff is ~~hidden. DON'T LOOK.~~ now exposed so you can unwrap streams and avoid having closures bind streams together forever.**

```javascript
new duplexer2([options], writable, readable)
```

```javascript
const duplex = new duplexer2(new stream.Writable(), new stream.Readable());
```

Arguments

* __options__ - an object specifying the regular `stream.Duplex` options, as
  well as the properties described below.
* __writable__ - a writable stream
* __readable__ - a readable stream

Options

* __bubbleErrors__ - a boolean value that specifies whether to bubble errors
  from the underlying readable/writable streams. Default is `true`.

Instance Methods

* __unbind__ - unbinds the duplexer2 instance from the writable and readable stream methods, allowing the underlying streams to be re-used.


## License

3-clause BSD. [A copy](./LICENSE) is included with the source.

## Contact

* GitHub ([deoxxa](http://github.com/deoxxa))
* Twitter ([@deoxxa](http://twitter.com/deoxxa))
* Email ([deoxxa@fknsrs.biz](mailto:deoxxa@fknsrs.biz))


  [ci-master]: https://img.shields.io/travis/nextorigin/duplexer2-unwrappable/master.svg?style=flat-square
  [travis-ci]: https://travis-ci.org/nextorigin/duplexer2-unwrappable
  [coverage-master]: https://img.shields.io/coveralls/nextorigin/duplexer2-unwrappable/master.svg?style=flat-square
  [coveralls]: https://coveralls.io/r/nextorigin/duplexer2-unwrappable
  [dependency]: https://img.shields.io/david/nextorigin/duplexer2-unwrappable.svg?style=flat-square
  [david]: https://david-dm.org/nextorigin/duplexer2-unwrappable
  [dev-dependency]: https://img.shields.io/david/dev/nextorigin/duplexer2-unwrappable.svg?style=flat-square
  [david-dev]: https://david-dm.org/nextorigin/duplexer2-unwrappable#info=devDependencies
  [downloads]: https://img.shields.io/npm/dm/duplexer2-unwrappable.svg?style=flat-square
  [npm]: https://www.npmjs.org/package/duplexer2-unwrappable
  [npm-stats]: https://nodei.co/npm/duplexer2-unwrappable.png?downloads=true&downloadRank=true&stars=true

