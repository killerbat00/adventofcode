from utils import withStream
from streams import lines

import deques
import strformat

type
    Point = ref object
        x: int
        y: int
        numSteps: int

const TEST_DATA = """
Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi
"""

proc partOne() =
    var q = initDeque[Point]()
    var map = newSeq[seq[int]]()

    let fn = "./input/day_12.txt"
    #let fn = TEST_DATA

    var startPoint = Point(x: 0, y: 0)
    var destPoint = Point(x: 0, y: 0)

    withStream(f, fn, fmRead):
        var i = 0
        for line in lines(f):
            var lineSeq = newSeq[int]()
            var j = 0
            for c in line:
                if c == 'S':
                    startPoint = Point(x: j, y: i, numSteps: 0)
                    lineSeq.add(ord('a'))
                elif c == 'E':
                    destPoint = Point(x: j, y: i)
                    lineSeq.add(ord('z'))
                else:
                    lineSeq.add(ord(c))
                j += 1
            map.add(lineSeq)
            i += 1

    let
        rows = map.len
        cols = map[0].len

    var visited = newSeq[int](rows * cols)

    # use breadth first search to find the shortest path
    # from startPoint to destPoint.
    # at each step, move exactly one square in any of the
    # four cardinal directions as long as the square is
    # less than or equal to the current square's height + 1
    q.addLast(startPoint)
    visited[startPoint.y * cols + startPoint.x] = 1

    while q.len > 0:
        var curPoint = q.popFirst()

        let newPos = @[(curPoint.x - 1, curPoint.y), (curPoint.x + 1, curPoint.y),
                        (curPoint.x, curPoint.y - 1), (curPoint.x, curPoint.y + 1)]
        for pos in newPos:
            let newX = pos[0]
            let newY = pos[1]

            if newX < 0 or newX >= cols or newY < 0 or newY >= rows:
                continue

            if visited[newY * cols + newX] == 1:
                continue

            if map[newY][newX] > map[curPoint.y][curPoint.x] + 1:
                continue

            var newPoint = Point(x: newX, y: newY, numSteps: curPoint.numSteps + 1)

            q.addLast(newPoint)
            visited[newY * cols + newX] = 1

            if newPoint.x == destPoint.x and newPoint.y == destPoint.y:
                echo &"Part one: found it! in {curPoint.numSteps + 1}"
                return

proc partTwo() =
    var q = initDeque[Point]()
    var map = newSeq[seq[int]]()

    let fn = "./input/day_12.txt"
    #let fn = TEST_DATA

    var startPoint = Point(x: 0, y: 0)

    withStream(f, fn, fmRead):
        var i = 0
        for line in lines(f):
            var lineSeq = newSeq[int]()
            var j = 0
            for c in line:
                if c == 'S':
                    lineSeq.add(ord('a'))
                elif c == 'E':
                    startPoint = Point(x: j, y: i)
                    lineSeq.add(ord('z'))
                else:
                    lineSeq.add(ord(c))
                j += 1
            map.add(lineSeq)
            i += 1

    let
        rows = map.len
        cols = map[0].len

    var visited = newSeq[int](rows * cols)

    # use breadth first search to find the shortest path
    # from startPoint to destPoint.
    # at each step, move exactly one square in any of the
    # four cardinal directions as long as the square is
    # less than or equal to the current square's height + 1
    q.addLast(startPoint)
    visited[startPoint.y * cols + startPoint.x] = 1

    while q.len > 0:
        var curPoint = q.popFirst()

        let newPos = @[(curPoint.x - 1, curPoint.y), (curPoint.x + 1, curPoint.y),
                        (curPoint.x, curPoint.y - 1), (curPoint.x, curPoint.y + 1)]
        for pos in newPos:
            let newX = pos[0]
            let newY = pos[1]

            if newX < 0 or newX >= cols or newY < 0 or newY >= rows:
                continue

            if visited[newY * cols + newX] == 1:
                continue

            if map[curPoint.y][curPoint.x] - 1 > map[newY][newX]:
                continue

            var newPoint = Point(x: newX, y: newY, numSteps: curPoint.numSteps + 1)
            q.addLast(newPoint)
            visited[newY * cols + newX] = 1

            if map[newY][newX] == ord('a'):
                echo &"Part two: found it! in {curPoint.numSteps + 1}"
                return

when isMainModule:
    partOne()
    partTwo()
