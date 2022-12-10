from utils import withStream
from streams import lines
import strutils
import strformat
import sets

const TEST_DATA = """
R 4
U 4
L 3
D 1
R 4
D 1
L 5
R 2
"""

type
    Point = object
        x: int
        y: int

var pHead = Point(x: 0, y: 0)
var pTail = Point(x: 0, y: 0)

var tailMoves: HashSet[Point] = initHashSet[Point]()

func touching(head: Point, tail: Point): bool =
    if abs(head.x - tail.x) <= 1 and abs(head.y - tail.y) <= 1:
        return true
    return false

proc singleMove(direction: string) =
    case direction:
        of "R":
            pHead.x += 1
        of "L":
            pHead.x -= 1
        of "U":
            pHead.y -= 1
        of "D":
            pHead.y += 1

    if touching(pHead, pTail):
        return
    
    if pHead.x == pTail.x:
        if pHead.y - pTail.y == 2:
            # head is further down, tail needs to move down one
            pTail.y += 1
        if pHead.y - pTail.y == -2:
            # head is further up one, tail needs to move up one
            pTail.y -= 1
    elif pHead.y == pTail.y:
        if pHead.x - pTail.x == 2:
            # head is further right, tail needs to move right one
            pTail.x += 1
        if pHead.x - pTail.x == -2:
            # head is further left, tail needs to move left one
            pTail.x -= 1
    else:
        if pHead.x > pTail.x:
            if pHead.y > pTail.y:
                # head is further down and right, tail needs to move down and right
                pTail.x += 1
                pTail.y += 1
            else:
                # head is further up and right, tail needs to move up and right
                pTail.x += 1
                pTail.y -= 1
        elif pHead.x < pTail.x:
            if pHead.y > pTail.y:
                # head is further down and left, tail needs to move down and left
                pTail.x -= 1
                pTail.y += 1
            else:
                # head is further up and left, tail needs to move up and left
                pTail.x -= 1
                pTail.y -= 1
    #echo fmt"Head is at {pHead.x}, {pHead.y}. Tail is at {pTail.x}, {pTail.y}"
    tailMoves.incl(Point(x: pTail.x, y: pTail.y))

proc partOne() =
    let fn = "./input/day_9.txt"
    #let fn = TEST_DATA

    var moveMap = newSeq[tuple[dir: string, amt: int]]()

    withStream(f, fn, fmRead):
        for line in lines(f):
            let parts = line.split(" ")
            moveMap.add((dir: parts[0], amt: parseInt(parts[1])))

    pHead = Point(x: 0, y: 0)
    pTail = Point(x: 0, y: 0)
    tailMoves = initHashSet[Point]()
    for move in moveMap:
        for i in 0 ..< move.amt:
            singleMove(move.dir)

    echo "Part one: ", tailMoves.len + 1 #count tail starting position

proc partTwo() =
    #let fn = "./input/day_9.txt"
    let fn = TEST_DATA

    var moveMap = newSeq[tuple[dir: string, amt: int]]()

    withStream(f, fn, fmRead):
        for line in lines(f):
            let parts = line.split(" ")
            moveMap.add((dir: parts[0], amt: parseInt(parts[1])))

    echo "Part two: "

when isMainModule:
    partOne()
    partTwo()
