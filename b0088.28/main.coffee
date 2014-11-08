loadScript = ->
    moduleId = $pz.module.id
    t = new Date().getTime()
    
    scriptId = "draw_script"
    $("#"+scriptId).remove()
    script = $ "<script>"
        id: scriptId
        src: "puzlet/source.php?pageId=#{moduleId}&file=draw.js&t="+t
    $(document.head).append script
    window.$setupDrawing()

init = ->
    window.$setupDrawing()
    $pz.event.codeSaved.on ((d) -> loadScript())  

puzletInit.register (=> init())

#!end (1)

