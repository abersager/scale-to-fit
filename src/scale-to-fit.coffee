((factory) ->
  if typeof define == 'function' and define.amd
    # AMD. Register as an anonymous module.
    define [ 'jquery' ], factory
  else if typeof module == 'object' and module.exports
    # Node/CommonJS

    module.exports = (root, jQuery) ->
      if jQuery == undefined
        # require('jQuery') returns a factory that requires window to
        # build a jQuery instance, we normalize how we use modules
        # that require this pattern but the window provided is a noop
        # if it's defined (how jquery works)
        if typeof window != 'undefined'
          jQuery = require('jquery')
        else
          jQuery = require('jquery')(root)
      factory jQuery
      jQuery

  else
    # Browser globals
    factory jQuery
  return
) ($) ->

  scaleElementToFitWrapper = (element, options = {}) ->
    parent = options.parent || element.parent()
    if typeof parent == 'string'
      parent = element.closest(parent)

    setElementScale element

    position = element.css 'position'
    element.css
      position: 'absolute'
    elementWidth = element.width()
    if options.withLeftPosition
       elementWidth += Math.max(element.position().left, 0)
    ratioWidth = parent.width() / elementWidth
    elementHeight = element.height()
    ratioHeight = parent.height() / elementHeight
    element.css
      position: position
    ratio = Math.min ratioWidth, 1
    if options.scaleToHeight
      ratio = Math.min ratio, ratioHeight
    if ratio < 1
       setElementScale element, elementWidth, elementHeight, ratio
    ratio

  getScaledElementMargin = (size, ratio) ->
    (size * -1 * (1 - ratio)) + "px"

  setElementScale = (element, width, height, ratio) ->
    if typeof width == 'number' && typeof height == 'number' && typeof ratio == 'number'
      transform = "scale(#{ratio})"
      marginLeft = getScaledElementMargin width, ratio
      marginTop = getScaledElementMargin height, ratio
    else
      transform = 'none'
      marginLeft = 0
      marginTop = 0

    element.css
      "margin-left": marginLeft
      "margin-top": marginTop
      "-webkit-transform": transform
      "-moz-transform": transform
      "-o-transform": transform
      "-ms-transform": transform
      "transform": transform
      "-webkit-transform-origin": '100% 100%',
      "-moz-transform-origin": '100% 100%',
      "-o-transform-origin": '100% 100%',
      "-ms-transform-origin": '100% 100%',
      "transform-origin": '100% 100%'


  $.fn.scaleToFit = (options = {})->
    this.each ->
      scaleElementToFitWrapper $(this), options

  return
