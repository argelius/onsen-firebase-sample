angular.module 'app.services', []
  .factory 'HackerNews', ->
    new Firebase 'https://hacker-news.firebaseio.com/v0'
