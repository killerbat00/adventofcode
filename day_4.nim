from utils import withFile
from std/strutils import split, parseInt
from std/sequtils import map
from std/streams import lines

template fmtLine(line: string): untyped =
    var result: seq[int] = @[]
    if line != "":
        let
            parts = line.split(",")
            left = parts[0].split("-").map(parseInt)
            right = parts[1].split("-").map(parseInt)
        result = @[left[0], left[1], right[0], right[1]]
    result

const testData = """
2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8
"""

proc partOne() =
    var
        enclosedRanges = 0

    let fn = "./input/day_4.txt"
    #let fn = testData

    withFile(f, fn, fmRead):
        for line in lines(f):
            let
                assignments = fmtLine(line)
                left = assignments[0 ..< 2]
                right = assignments[2 ..< assignments.len]

            if left[0] <= right[0] and left[1] >= right[1]:
                enclosedRanges += 1
            elif right[0] <= left[0] and right[1] >= left[1]:
                enclosedRanges += 1

    echo "Part one: ", enclosedRanges

proc partTwo() =
    echo "Part two: "

when isMainModule:
    partOne()
    partTwo()
