# src/client/app.coffee becomes:
### public/js/app.js ###

app = angular.module 'scrumtious', []

app.controller 'StickyButtonCtrl', ($scope) ->
  $scope.addSticky = ->
    alert 'Sticky added!'

  $scope.mouseover = ->
    console.log 'Moused over'


app.controller 'BoardCtrl', ($scope) ->
  $scope.columns = ['Todo', 'In Progress', 'Done']

app.directive 'ss-column', ($scope) ->
  {
    template: '''
      <td>

      </td>
    '''
  }



app.directive 'sb-draggable', ->
  {
    restrict: 'A'
    compile: (element, attrs) ->
      # body...


  }

app.directive 'sb-sticky', ($document) ->
  (scope, element, attr) ->
    startX = startY = x = y = 0
    element.on 'mousedown', (event) ->
      event.preventDefault()
      startX = event.screenX - x
      startY = event.screenY - y
      $document.on 'mousemove', mousemove
      $document.on 'mouseup', mouseup

    mousemove = (event) ->
      x = event.screenX - startX
      y = event.screenY - startY
      element.css {
        left: x + 'px'
        top: y + 'px'
      }

    mouseup = (event) ->
      $document.off 'mousemove', mousemove
      $document.off 'mouseup', mouseup

    template = '''
      <div sb-draggable>
        <p>Sticky directive<p>
      </div>
    '''
