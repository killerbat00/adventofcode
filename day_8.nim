from utils import withStream
from streams import lines
import strutils

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
            var
                rightMax = 0
                leftMax = 0
                upMax = 0
                downMax = 0
            
            rightMax = max(heightMap[y][x+1 ..< heightMap[y].len])
            leftMax = max(heightMap[y][0 ..< x])

            for y2 in y+1 ..< heightMap.len:
                downMax = max(downMax, heightMap[y2][x])

            for y2 in 0 ..< y:
                upMax = max(upMax, heightMap[y2][x])

            if tree > rightMax or tree > leftMax or tree > upMax or tree > downMax:
                numVisible += 1

    echo "Part one: ", numVisible

proc partTwo() =
    let fn = "./input/day_8.txt"
    #let fn = TEST_DATA

    var heightMap = newSeq[seq[int]]()
    
    withStream(f, fn, fmRead):
        for line in lines(f):
            var row = newSeq[int]()
            for c in line:
                row.add(($c).parseInt())
            heightMap.add(row)

    var scenicScores = newSeq[int]()

    for y in 1 ..< heightMap.len - 1:
        for x in 1 ..< heightMap[y].len - 1:
            let tree = heightMap[y][x]
            var canSeeRight = 0
            var canSeeLeft = 0
            var canSeeUp = 0
            var canSeeDown = 0
            
            # right
            for x2 in x+1 ..< heightMap[y].len:
                if heightMap[y][x2] <= tree:
                    canSeeRight += 1
                if heightMap[y][x2] >= tree:
                    break

            # left
            for x2 in 0 ..< x:
                if heightMap[y][x2] <= tree:
                    canSeeLeft += 1
                if heightMap[y][x2] >= tree:
                    break

            # down
            for y2 in y+1 ..< heightMap.len:
                if heightMap[y2][x] <= tree:
                    canSeeDown += 1
                if heightMap[y2][x] >= tree:
                    break

            # up
            for y2 in 0 ..< y:
                if heightMap[y2][x] <= tree:
                    canSeeUp += 1
                if heightMap[y2][x] >= tree:
                    break

            scenicScores.add(canSeeRight * canSeeLeft * canSeeUp * canSeeDown)

    echo "Part two: ", max(scenicScores)

when isMainModule:
    partOne()
    partTwo()
