# src/client/app.coffee becomes:
### public/js/app.js ###

app = angular.module 'Scrumtious', []

getGlobals = {}

app.controller 'BoardCtrl', ['$scope', ($scope) ->
  $scope.stickyList = []
  $scope.stickyIdTracker = 0

  getGlobals = ->
    [$scope.stickyList, $scope.stickyIdTracker]

  $scope.addSticky = ->
    $scope.stickyList.push {
      idn: $scope.stickyIdTracker++
      x: 50
      y: 50
      text: prompt 'Give your sticky some content:'
    }
]

app.directive 'sticky', ($document) ->
  {
    restrict: 'E'
    scope: {
      info: '='
    }
    template: '''
    <div class="card blue-grey darken-1">
      <div class="card-content white-text">
        <p>{{info.text}}</p>
    </div>
    '''
    link: (scope, element, attrs) ->
      info = scope.info
      startX = info.x
      startY = info.y

      element.css {
        position: 'relative'
        display: 'block'
        width: '150px'
        height: '150px'
        cursor: 'pointer'
        left: info.x + 'px'
        top: info.y + 'px'
      }

      element.on 'mousedown', (event) ->
        event.preventDefault()
        startX = event.screenX - info.x
        startY = event.screenY - info.y
        $document.on 'mousemove', mousemove
        $document.on 'mouseup', mouseup

      mousemove = (event) ->
        info.y = event.screenY - startY
        info.x = event.screenX - startX
        element.css {
          top: info.y + 'px'
          left: info.x + 'px'
        }

      mouseup = (event) ->
        $document.off 'mousemove', mousemove
        $document.off 'mouseup', mouseup
  }
