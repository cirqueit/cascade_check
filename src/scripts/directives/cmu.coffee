do ->
angular.module('flatuiApp.directives').directive('cmu',['$document', '$timeout', ($document, $timeout) ->
             return {
                 restrict: "A"
                 scope: {
                     box : "="
                     color : "="
                     timeout : "="
                     fill : "="
                 }
                 link: (scope, element, attrs) ->
                     draw = ->
                         img = element.parent().find('img')[0]
                         [rw, rh] = [img.width/img.naturalWidth, img.height/img.naturalHeight]

                         ctx = element[0].getContext('2d')
                         ctx.canvas.width  = img.width
                         ctx.canvas.height = img.height

                         x = scope.box[0]*rw
                         y = scope.box[1]*rh
                         w = scope.box[2]*rw
                         h = scope.box[3]*rh

                         if scope.fill != "0"
                             if 0
                                 ctx.globalAlpha = 0.5
                                 ctx.fillStyle=scope.color
                                 ctx.arc(x+w/2, y+h/2, w/2, 0, 2 * Math.PI, false)
                                 ctx.fill()
                              else
                                 ctx.strokeRect(x, y, w, h)
                                 ctx.strokeStyle=scope.color
                                 ctx.lineWidth=5
                                 ctx.strokeRect(x, y, w, h)
                         else
                             ctx.lineWidth = 3
                             ctx.strokeStyle=scope.color
                             ctx.arc(x+w/2, y+h/2, w/2, 0, 2 * Math.PI, false)
                             ctx.stroke()

                     $timeout(draw, scope.timeout)
             }
])
