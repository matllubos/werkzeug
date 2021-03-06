goog.require 'goog.array'


class wzk.ui.DatePicker extends goog.ui.DatePicker

  constructor: (date, dateTimeSymbols, dom, renderer) ->
    super(date, dateTimeSymbols, dom, renderer)
    @yearMenuRange = null

  ###*
    Sets a start and end for year menu range.
    @param {Array.<Number>} range
  ###
  setYearMenuRange: (range) ->
    if range? and range.length < 2
      throw Error('Given unexpected range values, expected two given: ' + range.length)
    @yearMenuRange = range


  ###*
    @suppress {visibility}
  ###
  showYearMenu_: (e) ->
    unless @yearMenuRange?
      super(e)
      return

    e.stopPropagation()
    list = []
    loopDate = @activeMonth_.clone()

    formatYear = (year) =>
      loopDate.setFullYear(year)
      return @i18nDateFormatterYear_.format(loopDate)

    @createMenu_(
      @elYear_,
      (formatYear(year) for year in goog.array.range(@yearMenuRange[0], @yearMenuRange[1]))
      @handleYearMenuClick_,
      @i18nDateFormatterYear_.format(@activeMonth_)
    )

  ###*
    @suppress {visibility}
    @protected
    @param {number} currentYear
    @param {number} itemIndex
    @return {number}
  ###
  computePickedYear: (currentYear, itemIndex) ->
    return (
      if @yearMenuRange? then @yearMenuRange[0] + itemIndex
      else currentYear + itemIndex - goog.ui.DatePicker.YEAR_MENU_RANGE_
    )

  ###*
    @suppress {visibility}
  ###
  handleYearMenuClick_: (target) ->
    if target.firstChild.nodeType is goog.dom.NodeType.TEXT
      @activeMonth_.setFullYear(
        @computePickedYear(@activeMonth_.getFullYear(), Number(target.getAttribute('itemIndex'))))
      @updateCalendarGrid_()
    @elYear_.focus()
