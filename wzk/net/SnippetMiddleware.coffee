goog.require 'goog.dom.dataset'

class wzk.net.SnippetMiddleware

  ###*
    @enum {string}
  ###
  @DATA:
    SNIPPET: 'snippet'
    TYPE: 'snippetType'

  ###*
    @enum {string}
  ###
  @TYPE:
    REPLACE: 'replace'
    APPEND: 'append'
    PREPEND: 'prepend'

  ###*
    @param {wzk.app.Processor} proc
    @param {wzk.dom.Dom} dom
    @param {Object} opts
  ###
  constructor: (@proc, @dom, @opts) ->

  ###*
    @param {Object} res
  ###
  apply: (res) ->
    return unless res['snippets']

    T = wzk.net.SnippetMiddleware.TYPE
    D = wzk.net.SnippetMiddleware.DATA

    for name, snip of res['snippets']
      el = @dom.one "*[data-snippet=#{name}]"
      continue unless el

      type = goog.dom.dataset.get(el, D.TYPE) ? T.REPLACE

      method = switch type
        when T.REPLACE then @replace
        when T.APPEND then @append
        when T.PREPEND then @prepend

      goog.bind(method, @, snip, el)()

  ###*
    @protected
    @param {string} html
    @param {Element} el
  ###
  replace: (html, el) ->
    el.innerHTML = html

  ###*
    @protected
    @param {string} html
    @param {Element} el
  ###
  append: (html, el) ->
    newEl = @dom.htmlToDocumentFragment html
    @dom.append el, newEl

  ###*
    @protected
    @param {string} html
    @param {Element} el
  ###
  prepend: (html, el) ->
    newEl = @dom.htmlToDocumentFragment html
    @dom.prependChild el, newEl
