from utils import withStream
from std/strutils import isUpperAscii
from std/sequtils import toSeq
from std/streams import lines
import sets

proc partOne() =
    var
        totalScore = 0

    withStream(f, "./input/day_3.txt", fmRead):
        for line in lines(f):
            if line != "":
                let
                    lineLen = line.len() div 2
                    left = line[0 ..< lineLen].toHashSet()
                    right = line[lineLen ..< line.len].toHashSet()
                    common = intersection(left, right).toSeq()[0]
                if common.isUpperAscii():
                    totalScore += int(common) - 38
                else:
                    totalScore += int(common) - 96

    echo "Part one: ", totalScore

proc partTwo() =
    var
        idx = 0
        totalScore = 0
        peerGroup = newSeq[string]()

    withStream(f, "./input/day_3.txt", fmRead):
        for line in lines(f):
            if line != "":
                peerGroup.add(line)
                idx = (idx + 1) mod 3
                if idx == 0:
                    let
                        common = intersection(intersection(peerGroup[0].toHashSet(), peerGroup[1].toHashSet()), peerGroup[2].toHashSet()).toSeq()[0]

                    if common.isUpperAscii():
                        totalScore += int(common) - 38
                    else:
                        totalScore += int(common) - 96
                    peerGroup.setLen(0)

    echo "Part two: ", totalScore

when isMainModule:
    partOne()
    partTwo()
