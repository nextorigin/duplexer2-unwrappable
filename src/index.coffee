"use strict"


stream = require "readable-stream"


class DuplexWrapper extends stream.Duplex
  constructor: (options, writable, readable) ->
    if typeof readable is "undefined"
      readable = writable
      writable = options
      options  = {}

    super options

    if typeof readable.read isnt "function"
      readable = (new stream.Readable options).wrap readable

    @_writable = writable
    @_readable = readable
    @_waiting  = false

    @bindEvents options

  bindEvents: ({bubbleErrors}) ->
    @_writable.once "finish",        @_end
    @once           "finish",        @_endWritable

    @_readable.on   "readable",      @readIfWaiting
    @_readable.once "end",           @pushNull

    return unless (bubbleErrors or not bubbleErrors?)
    @_writable.on "error",           @bubbleError
    @_readable.on "error",           @bubbleError

  _end: => @end()
  _endWritable: => @_writable.end()

  readIfWaiting: =>
    return unless @_waiting
    @_waiting = false
    @_read()

  pushNull: =>
    @push null

  bubbleError: (err) =>
    @emit "error", err

  _write: (input, encoding, done) ->
    @_writable.write input, encoding, done

  _read: ->
    buf = undefined
    reads = 0
    while (buf = @_readable.read()) isnt null
      @push buf
      reads++
    @_waiting = true if reads is 0


module.exports = DuplexWrapper
