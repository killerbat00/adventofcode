from utils import withStream
from std/strutils import split, parseInt, isDigit, join
from std/sequtils import mapIt, map, toSeq
from std/streams import lines, newStringStream, StringStream, atEnd, readChar
from std/sets import toHashSet, len

const testData = """
mjqjpqmgbljsphdztnvjfqwrcgsmlb
bvwbjplbgvbhsrlpgdmjqwftvncz
nppdvjthqldpwncqszvftbrmjlhg
nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg
zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw
"""

proc findStartOfPacket(input: StringStream): int =
    var
        buffer = newSeq[char]()
        curr: char
        count = 0
    while not input.atEnd:
        curr = input.readChar()
        buffer.add(curr)
        if (buffer.len == 4):
            if sets.len(buffer.toHashSet()) == 4:
                return count + 1
            buffer = buffer[1 .. ^1]
        count += 1
    return count

proc partOne() =
    var
        inputLine: StringStream
        results = newSeq[int]()

    let fn = "./input/day_6.txt"
    #let fn = testData

    withStream(f, fn, fmRead):
        for line in lines(f):
            if line == "":
                continue
            inputLine = newStringStream(line)
            results.add(findStartOfPacket(inputLine))

    echo "Part one: ", $results

proc partTwo() =
    echo "Part two: "

when isMainModule:
    partOne()
    partTwo()
