from utils import withStream
from std/strutils import split, parseInt, isDigit, join
from std/sequtils import mapIt, map, toSeq
from std/streams import lines

const testData = """
1 Z N
2 M C D
3 P

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2
"""

proc partOne() =
    var
        stackData = newSeq[seq[string]]()
        movements = newSeq[seq[int]]()

    let fn = "./input/day_5.txt"
    #let fn = testData

    withStream(f, fn, fmRead):
        for line in lines(f):
            if line == "":
                continue
            if line[0].isDigit():
                stackData.add(@[line.split(" ")[1 .. ^1]])
            else:
                let lineParts = line.split(" ")
                movements.add(@[@[lineParts[1], lineParts[3], lineParts[5]].map(parseInt)])
    for move in movements:
        var count = move[0]
        let
            frm = move[1]
            to = move[2]
        while count > 0:
            stackData[to - 1].add(stackData[frm - 1].pop())
            count -= 1

    var topCrates = stackData.mapIt(it[^1])

    echo "Part one: ", $topCrates.join("")

proc partTwo() =
    echo "Part two: "

when isMainModule:
    partOne()
    partTwo()
