from utils import withStream
from streams import lines
import strutils
import sets
import strformat

const TEST_DATA = """30373
25512
65332
33549
35390"""

proc partOne() =
    let fn = "./input/day_8.txt"
    #let fn = TEST_DATA

    var heightMap = newSeq[seq[int]]()
    
    withStream(f, fn, fmRead):
        for line in lines(f):
            var row = newSeq[int]()
            for c in line:
                row.add(($c).parseInt())
            heightMap.add(row)

    var numVisible = (heightMap.len * 2) + (heightMap[0].len * 2) - 4 # don't double count corners

    for y in 1 ..< heightMap.len - 1:
        for x in 1 ..< heightMap[y].len - 1:
            let tree = heightMap[y][x]
            var right = newSeq[int]()
            var left = newSeq[int]()
            var up = newSeq[int]()
            var down = newSeq[int]()
            
            # right
            for x2 in x+1 ..< heightMap[y].len:
                right.add(heightMap[y][x2])

            # left
            for x2 in 0 ..< x:
                left.add(heightMap[y][x2])

            # down
            for y2 in y+1 ..< heightMap.len:
                down.add(heightMap[y2][x])

            # up
            for y2 in 0 ..< y:
                up.add(heightMap[y2][x])

            if tree > max(right) or tree > max(left) or tree > max(up) or tree > max(down):
                numVisible += 1

    echo "Part one: ", numVisible

proc partTwo() =
    #let fn = "./input/day_8.txt"
    let fn = TEST_DATA

    var heightMap = newSeq[seq[int]]()
    
    withStream(f, fn, fmRead):
        for line in lines(f):
            var row = newSeq[int]()
            for c in line:
                row.add(($c).parseInt())
            heightMap.add(row)
            
    echo "Part two: "

when isMainModule:
    partOne()
    partTwo()
