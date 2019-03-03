# LoadPattern_3.tcl 

# LoadPattern "LoadingP":    patternTag    tsTag 
pattern  Plain       1       2  { 
    # Load    nodeTag    LoadValues 
 
    # SP    nodeTag    dofTag    DispValue 
    sp       2     1  +1.000000E+000 
 
    # eleLoad    eleTags    beamUniform    Wy    <Wx> 
 
    # eleLoad    eleTags    beamPoint    Py    xL    <Px> 
} 
