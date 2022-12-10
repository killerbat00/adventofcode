from utils import withStream
from streams import lines

proc partOne() =
    let fn = "./input/day_10.txt"

    withStream(f, fn, fmRead):
        for line in lines(f):
            discard line
            #echo line

    echo "Part one: "

proc partTwo() =
    let fn = "./input/day_10.txt"
    
    withStream(f, fn, fmRead):
        for line in lines(f):
            discard line
            #echo line
    echo "Part two: "

when isMainModule:
    partOne()
    partTwo()
