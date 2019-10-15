init = () ->
  COLORS = ['red', 'blue', 'green', 'yellow', 'black']

  class Canvas
    constructor: (idElement, width, height) ->
      @element = document.getElementById idElement
      @ctx = @element.getContext '2d'
      @element.width = width
      @element.height = height
    drawStar: (x, y, r, p, m, color) ->
      @ctx.save()
      @ctx.beginPath()
      @ctx.translate x, y
      @ctx.moveTo 0, 0 - r
      for item in [0...p]
        @ctx.rotate Math.PI / p
        @ctx.lineTo 0, 0 - r * m
        @ctx.rotate Math.PI / p
        @ctx.lineTo 0, 0 - r
      @ctx.fillStyle = color
      @ctx.fill()
      @ctx.restore()

  canvasBig   = new Canvas 'canvasBig', 600, 600
  canvasSmall = new Canvas 'canvasSmall', 600, 100

  randomNumber = () -> Math.floor(Math.random() * 500) + 50
  for i in [0...5]
    canvasBig.drawStar randomNumber(), randomNumber(), 50, 5, 0.4, COLORS[i]

  canvasBig.element.addEventListener 'click',
    (e) ->
      ctx = @getContext '2d'
      imageData = ctx.getImageData e.pageX, e.pageY, 1, 1
      r = imageData.data[0]
      g = imageData.data[1]
      b = imageData.data[2]
      a = imageData.data[3] / 255
      canvasSmall.element.style.backgroundColor = "rgba(#{r},#{g},#{b},#{a})"

window.onload = init