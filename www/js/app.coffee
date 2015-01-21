angular.module 'app', ['onsen', 'app.controllers', 'app.services']

.filter 'urlToHost', ->
  (value) ->
    hostname = value.replace /^http(s)?:\/\//, ''
    hostname = (hostname.split '/')[0]

    parts = hostname.split '.'

    parts
      .slice parts.length - 2, parts.length
      .join '.'

.filter 'timeAgo', ->
  (value) ->

    current = (new Date).getTime()
    previous = 1000 * (parseInt value)

    msPerMinute = 60 * 1000
    msPerHour = msPerMinute * 60
    msPerDay = msPerHour * 24
    msPerMonth = msPerDay * 30
    msPerYear = msPerDay * 365

    elapsed = current - previous
 
    if elapsed < msPerMinute
      return Math.round(elapsed/1000) + ' seconds ago'
    else if elapsed < msPerHour
      return Math.round(elapsed/msPerMinute) + ' minutes ago'
    else if elapsed < msPerDay
      return Math.round(elapsed/msPerHour ) + ' hours ago'
    else if elapsed < msPerMonth
      return Math.round(elapsed/msPerDay) + ' days ago'
    else if elapsed < msPerYear
      return Math.round(elapsed/msPerMonth) + ' months ago'
    else
      return Math.round(elapsed/msPerYear ) + ' years ago'
