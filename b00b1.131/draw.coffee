window.drawing = ->
    
    # setup drawing
    unit = 48 
    d = new Drawing
        id: "canvas"
        height: 500
        unit: unit
        showJunctions: false
        defaultFill: "yellow"
    
    # shortcuts
    [block, junc, connect, inp, output] = d.shortcuts()
        
    # feedforward gain (anchor with absolute coordinates)
    ffg = block {o: [120, 80], label: "$k_r$"}
    inp {o: ffg.left, label: "$r(s)$"}
    
    # feedback error
    fbe = block {o: ffg.right, type: "sum"}
    
    # common subsystem for process and model (B,A,C,1/s)
    class feedbackSystem
        constructor: (@spec) ->
            d.defaultFill = @spec.fill if @spec.fill?
            @B = block {o: @spec.o, label: @label("B")}  # input gain
            @E = block {o: @B.right, type: "sum"}
            @I = block {o: @E.right, \
                        label: "$\\Large\\frac{1}{s}$"}  # integrator
            @I.j = junc {o: @I.right, label: "I"}
            @I.j2 = junc {o: @I.j.bottom, label: "I2", offset: 3/2*unit}
            @A = block {o: @I.j2.left, label: @label("A")}  # fb gain
            connect @A.left, @E.bottom
            @C = block {o: @I.j.right, label: @label("C")}  # output gain
            @C.j = junc {o: @C.right, label: "C"}
        label: (name) -> @spec.labels?[name] ? "$#{name}$"
    
    # process
    fbe.j = junc {o: fbe.right, label: "fbe"}
    process = new feedbackSystem {o: fbe.j.right, fill: "blue"}
    output {o: process.C.j.right, label: "$y(s)$"}    
    process.I.right.label {label: "$x$"}
    process.I.left.label {label: "$\\dot{x}$"}
    
    # process system equation
    p = process.I.top
    t = block 
        o: [p.x, p.y-30]
        width: 300
        label: "$\\color{blue}{H(s)=C(sI-A)^{-1}B}$"
    t.style "fill:white; fill-opacity: 0.5;"
    
    # model
    fbe.j2 = junc {o: fbe.j.bottom, label: "fbe2", offset: 5*unit}
    model = new feedbackSystem 
        o: fbe.j2.right, labels: {C: "$-C$"}, fill: "red"
    model.I.right.label {label: "$\\hat{x}$"}
    model.I.left.label {label: "$\\dot{\\hat{x}}$"}
    model.C.j.right.label {label:"$-\\hat{y}$"}

    d.defaultFill = "yellow"
    
    # observer error
    obe = block {o: process.C.j.bottom, offset: 3*unit, type: "sum"}
    obe.style "fill:red; fill-opacity:0.1; stroke:black; stroke-width:1.5"
    obe.left.label {label: "$\\varepsilon$"}
    connect model.C.right, obe.bottom
    
    # observer gain
    L = block {o: [process.E.x, obe.y], label: "$L$"}
    L.style "fill:red; fill-opacity:0.1; stroke:black; stroke-width:1.5"
    connect obe.left, L.right
    connect L.bottom, model.E.top
    
    # observer system equation
    p = model.E.bottom
    t = block 
        o: [p.x, p.y+2.3*unit]
        width: 300
        label: "$\\small\\color{red}{\\dot{\\hat{x}}=(A-BK-LC)\\hat{x}+Ly}$"
    t.style "fill:white; fill-opacity: 0.5;"
    
    # feedback gain
    K = block {o: [fbe.x, L.y], label: "$-K$"}
    K.style "fill:yellow; fill-opacity:0.1; stroke:red; stroke-width:2"
    K.j = junc {o: model.I.j2.bottom, label: "fbg", offset: 1.5*unit}
    connect K.j.left, K.bottom
    connect K.top, fbe.bottom

#!end (3)

