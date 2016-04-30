# src/client/app.coffee becomes:
### public/js/app.js ###

app = angular.module 'Scrumtious', []

app.controller 'BoardCtrl', ['$scope', ($scope) ->
  $scope.stickyList = []
  $scope.stickyList.push {text: 'some sticky text'}

  $scope.addSticky = ->
    console.log 'Sticky added!'
]

app.directive 'sticky', ($document) ->
  {
    restrict: 'E'
    scope: {
      text: '@'
    }
    template: '''
    <div class='card blue-grey darken-1'>
      <div class='card-content white-text'>
        <p>{{text}}<p>
      </div>
    </div>
    '''
    link: (scope, element, attrs) ->
      startX = startY = x = y = 0
      element.css {
        'position': 'relative'
        'display': 'block'
        'width': '150px'
        'height': '150px'
        'cursor': 'pointer'
      }

      element.on 'dblclick', (event) ->
        scope.stickyInfo.text = prompt 'Change the text', scope.stickyInfo.text

      element.on 'mousedown', (event) ->
        event.preventDefault()
        startX = event.screenX - x
        startY = event.screenY - y
        $document.on 'mousemove', mousemove
        $document.on 'mouseup', mouseup

      mousemove = (event) ->
        y = event.screenY - startY
        x = event.screenX - startX
        element.css {
          top: y + 'px'
          left: x + 'px'
        }

      mouseup = (event) ->
        $document.off 'mousemove', mousemove
        $document.off 'mouseup', mouseup
  }
