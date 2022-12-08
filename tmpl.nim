from utils import withStream
from streams import lines

proc partOne() =
    let fn = "./input/day_X.txt"

    withStream(f, fn, fmRead):
        for line in lines(f):
            echo line

    echo "Part one: "

proc partTwo() =
    let fn = "./input/day_X.txt"
    
    withStream(f, fn, fmRead):
        for line in lines(f):
            echo line
    echo "Part two: "

when isMainModule:
    partOne()
    partTwo()
