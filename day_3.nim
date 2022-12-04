from utils import withFile
from std/strutils import isUpperAscii
from std/sequtils import toSeq
import sets

proc partOne() =
    var
        totalScore = 0

    withFile(f, "./input/day_3.txt", fmRead):
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
    echo "Part two: "

when isMainModule:
    partOne()
    partTwo()
