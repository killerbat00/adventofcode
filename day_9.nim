from utils import withStream
from streams import lines
import strutils
import sets
import sugar

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

const TEST_DATA_2 = """
R 5
U 8
L 8
D 3
R 17
D 10
L 25
U 20
"""

type
    Point = object
        x: int
        y: int

func touching(head: Point, tail: Point): bool =
    if abs(head.x - tail.x) <= 1 and abs(head.y - tail.y) <= 1:
        return true
    return false

proc `$`(p: Point): string =
    return "Point(x: " & $p.x & ", y: " & $p.y & ")"

proc singleMove(direction: string, pHead: var Point, pTail: var Point, tailMoves: var HashSet[Point], isTail: bool = false) =
    case direction:
        of "R":
            pHead.x += 1
        of "L":
            pHead.x -= 1
        of "U":
            pHead.y -= 1
        of "D":
            pHead.y += 1

proc catchUp(pHead: var Point, pTail: var Point, tailMoves: var HashSet[Point], isTail: bool = false) =
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
    if isTail:
        tailMoves.incl(Point(x: pTail.x, y: pTail.y))

proc partOne() =
    let fn = "./input/day_9.txt"
    #let fn = TEST_DATA

    var moveMap = newSeq[tuple[dir: string, amt: int]]()

    withStream(f, fn, fmRead):
        for line in lines(f):
            let parts = line.split(" ")
            moveMap.add((dir: parts[0], amt: parseInt(parts[1])))

    var pHead = Point(x: 0, y: 0)
    var pTail = Point(x: 0, y: 0)
    var tailMoves = initHashSet[Point]()
    for move in moveMap:
        for i in 0 ..< move.amt:
            singleMove(move.dir, pHead, pTail, tailMoves, true)
            if not touching(pHead, pTail):
                catchUp(pHead, pTail, tailMoves, true)

    echo "Part one: ", tailMoves.len + 1 #count tail starting position

proc partTwo() =
    let fn = "./input/day_9.txt"
    #let fn = TEST_DATA_2

    var moveMap = newSeq[tuple[dir: string, amt: int]]()
    var points = collect(newSeq):
        for x in 0 ..< 10:
            Point(x: 0, y: 0)

    withStream(f, fn, fmRead):
        for line in lines(f):
            let parts = line.split(" ")
            moveMap.add((dir: parts[0], amt: parseInt(parts[1])))

    var tailMoves = initHashSet[Point]()
    for move in moveMap:
        for i in 0 ..< move.amt:
            singleMove(move.dir, points[0], points[1], tailMoves)
            for p in 1 ..< points.len:
                if not touching(points[p - 1], points[p]):
                    if p == points.len - 1:
                        catchUp(points[p - 1], points[p], tailMoves, true)
                    else:
                        catchUp(points[p - 1], points[p], tailMoves)

    echo "Part two: ", tailMoves.len + 1 #count tail starting position

when isMainModule:
    partOne()
    partTwo()
