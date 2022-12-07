from utils import withStream
from std/streams import lines, newStringStream, StringStream, atEnd, readChar
from std/sets import toHashSet, len

const testData = """
mjqjpqmgbljsphdztnvjfqwrcgsmlb
bvwbjplbgvbhsrlpgdmjqwftvncz
nppdvjthqldpwncqszvftbrmjlhg
nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg
zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw
"""

proc findStartOfPacket(input: StringStream, uniqueChars: int): int =
    var
        buffer = newSeq[char]()
        curr: char
        count = 0
    while not input.atEnd:
        curr = input.readChar()
        buffer.add(curr)
        if (buffer.len == uniqueChars):
            if sets.len(buffer.toHashSet()) == uniqueChars:
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
            results.add(findStartOfPacket(inputLine, 4))

    echo "Part one: ", $results

proc partTwo() =
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
            results.add(findStartOfPacket(inputLine, 14))

    echo "Part two: ", $results

when isMainModule:
    partOne()
    partTwo()
