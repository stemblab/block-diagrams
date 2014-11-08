window.drawing = ->
    
    d = new Drawing id: "canvas"
                    
    b1 = d.block {o: [180, 150], label: "This is a multi-line label"}
    b2 = d.block {o: [400, 150], label: "<b>html label</b>"}
    b3 = b2.right.from
        line: 50, width: 100, height: 50
        id: "pz_text"
        noArrow: true
    #b3 = d.block x: 520, y: 300, id: "pz_text"
    b4 = d.block {o: [280, 270], id: "pz_text2"}
#    b4 = d.block x: 280, y: 270, id: "pz_text2"
    
    b5 = b3.bottom.to {label: "x", noArrow: true}
    
    b1.right.connect b2.left
    b1.right.label "y"
    b2.left.label "x"
    
    #b2.right.connect b3.top

    b2.bottom.connect b4.right

    b1.left.inp {line: 70, id: "twoline", height: 50}
    b2.top.inp {line: 50, label: "$\\alpha$", width: 80, noArrow: true}
#    b2.top.inp {line: 50, label: "$\\sum_{n=0}^N \\alpha_n$", width: 80}
        # id: "pz_theta" 
    b2.bottom.label "z"

    #b3.right.lineOut 50, "$\\theta_2$"
    #b3.top.label id: "pz_gamma"

    b4.bottom.inp
        line: 40
        label: "AD"+Math.floor(100*Math.random())
        width: 60
    b4.left.out {line: 40, label: "$y$", noArrow: false}
    
    b6 = d.circle {x: 450, y: 350, label: "$\\times$"}
    b6.top.inp {line: 30, label: "x"}
    b6.left.inp {line: 30, label: "y"}
    b6.right.connect b5.bottom
    
    d.junc {o: b1.bottom, label: "X", offset: 20}
    
    #console.log "done"

#!end (4)

