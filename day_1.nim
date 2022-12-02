from utils import withFile
from std/strutils import parseInt
from std/sequtils import foldl

import std/heapqueue

when isMainModule:
    var
        currentElf = newSeq[int]()
        elfQ = initHeapQueue[int]()

    withFile(f, "./input/day_1.txt", fmRead):
        for line in lines(f):
            if line != "":
                currentElf.add(line.parseInt())
            else:
                elfQ.push(currentElf.foldl(a + b))
                currentElf = newSeq[int]()

    while elfQ.len > 3:
        discard elfQ.pop()
    
    echo "Maximum Calories: ", elfQ[1] # 3 elements, largest (root) is index 1 (the middle)
    echo "Total top 3 Carolies: ", elfQ.foldl(a + b)
