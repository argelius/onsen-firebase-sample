angular.module 'app.services', []
  .factory 'HackerNews', ->
    fb = new Firebase 'https://hacker-news.firebaseio.com/v0'

    return fb
