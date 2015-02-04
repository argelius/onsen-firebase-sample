angular
  .module 'app.controllers', ['app.services']

  .controller 'AppController', ['$scope', '$sce', '$timeout', '$window', '$q', 'HackerNews', ($scope, $sce, $timeout, $window, $q, HackerNews) ->

    # Show the 'Top stories' section at startup.
    $scope.section = 'top'

    # Navigate to story view.
    $scope.gotoStory = (story) ->
      $scope.currentStory = story
      $scope.storyUrl = $sce.trustAsResourceUrl story.url
      $scope.navi.pushPage 'story.html'

    # Open the URL in a dedicated webview instead of an iframe. 
    # Some articles can't be displayed in iframes.
    $scope.loadUrl = (url) ->
      $window.open url, '_system'

    # Fetch a story from API. Resolves to 'undefined' if there
    # if the item isn't a story or if it doesn't exist.
    $scope.getStory = (id) ->
      deferred = $q.defer()
      timer = $timeout deferred.resolve, 1000

      HackerNews
        .child "item/#{id}"
        .once 'value', (data) ->
          item = data.val()

          if item && item.type == 'story' && !item.deleted && item.url
            $timeout.cancel timer
            deferred.resolve item
          else
            $timeout.cancel timer
            deferred.resolve()

      deferred.promise
  ]

  .controller 'TopController', ['$scope', '$q', 'HackerNews', ($scope, $q, HackerNews) ->
    $scope.stories = []

    $scope.getTopStories = ->
      HackerNews
        .child 'topstories'
        .limitToFirst 20
        .once 'value', (data) ->
          console.log(data.val())
          ids = data.val()

          promises = []
          for id in ids
            promises.push $scope.getStory(id)

          $q.all(promises).then (stories) ->
            stories = stories.filter (story) ->
              typeof story != 'undefined'
            if stories.length > 0
              $scope.stories = stories

    # Reload top stories every time they are changed.
    HackerNews
      .child 'topstories'
      .on 'value', $scope.getTopStories
  ]

  .controller 'LatestController', ['$scope', '$q', 'HackerNews', ($scope, $q, HackerNews) ->
    $scope.stories = []
 
    $scope.getLatestStories = ->
      HackerNews
        .child 'maxitem'
        .once 'value', (data) ->
          maxId = data.val()

          promises = []
          for id in [maxId...maxId - 100]
            promises.push $scope.getStory(id)

          $q.all(promises).then (stories) ->
            stories = stories.filter (story) ->
              typeof story != 'undefined'
            if stories.length > 0
              $scope.stories = stories
    
    # Reload recent stories if a new item is added to Hacker News.
    HackerNews
      .child 'maxitem'
      .on 'value', $scope.getLatestStories

  ]
