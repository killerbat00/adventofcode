from utils import withStream
from streams import lines

import algorithm
import strutils
import strformat
import sequtils

type
    PacketType = enum
        ptInt,
        ptList

    Packet = ref object
        case kind: PacketType
            of ptInt: intVal: int
            of ptList: listVal: seq[Packet]

proc `$`(p: Packet): string =
    case p.kind
    of ptInt:
        return $p.intVal
    of ptList:
        return $p.listVal

const TEST_DATA = """
[1,1,3,1,1]
[1,1,5,1,1]

[[1],[2,3,4]]
[[1],4]

[9]
[[8,7,6]]

[[4,4],4,4]
[[4,4],4,4,4]

[7,7,7,7]
[7,7,7]

[]
[3]

[[[]]]
[[]]

[1,[2,[3,[4,[5,6,7]]]],8,9]
[1,[2,[3,[4,[5,6,0]]]],8,9]
"""

proc `==`(a, b: Packet): bool =
    if a.kind == ptInt and b.kind == ptInt:
        return a.intVal == b.intVal
    if a.kind == ptInt and b.kind == ptList:
        return Packet(kind: ptList, listVal: @[a]) == b
    if a.kind == ptList and b.kind == ptInt:
        return a == Packet(kind: ptList, listVal: @[b])

    let numLeft = a.listVal.len
    let numRight = b.listVal.len

    if numLeft != numRight:
        return false

    for i in 0..<numLeft:
        if a.listVal[i] != b.listVal[i]:
            return false
    return true

proc `<`(a, b: Packet): bool =
    if a.kind == ptInt and b.kind == ptInt:
        return a.intVal < b.intVal
    if a.kind == ptInt and b.kind == ptList:
        return Packet(kind: ptList, listVal: @[a]) < b
    if a.kind == ptList and b.kind == ptInt:
        return a < Packet(kind: ptList, listVal: @[b])

    let numLeft = a.listVal.len
    let numRight = b.listVal.len

    if numLeft == 0:
        return true
    if numRight == 0:
        return false

    for i in 0..<max(numLeft, numRight):
        if i >= numLeft:
            return true
        if i >= numRight:
            return false

        if a.listVal[i] == b.listVal[i]:
            continue
        elif a.listVal[i] < b.listVal[i]:
            return true
        else:
            return false
    return true


proc parsePacket(input: string): Packet =
    let l = input.len
    var stack = newSeq[Packet]()

    stack.add(Packet(kind: ptList, listVal: @[]))
    let p = stack[^1]

    var i = 0
    while i < l:
        let c = input[i]

        if c == '[':
            stack.add(Packet(kind: ptList, listVal: @[]))
            i += 1
        elif c == ']':
            let popped = stack.pop()
            stack[^1].listVal.add(popped)
            i += 1
        else:
            var curNum = newSeq[char]()
            while i < l:
                let cc = input[i]
                if cc in {'0'..'9'}:
                    curNum.add(cc)
                    i += 1
                    continue
                elif cc == ',' or cc == ']':
                    let num = curNum.join("")
                    if num.len > 0:
                        stack[^1].listVal.add(Packet(kind: ptInt, intVal: num.parseInt))
                    if cc == ',':
                        i += 1
                    break
    return p.listVal[0]

proc partOne() =
    let fn = "./input/day_13.txt"
    #let fn = TEST_DATA
    var packets = newSeq[Packet]()

    withStream(f, fn, fmRead):
        for line in lines(f):
            if line.len > 0:
                packets.add(parsePacket(line))

    var index = 1
    var correctPairs = newSeq[int]()
    for i in countup(1, packets.len - 1, 2):
        var left = packets[i - 1]
        var right = packets[i]

        if left < right:
            correctPairs.add(index)
        index += 1

    echo &"Part one: {correctPairs.foldl(a + b)}"

proc partTwo() =
    let fn = "./input/day_13.txt"
    #let fn = TEST_DATA
    var packets = newSeq[Packet]()

    withStream(f, fn, fmRead):
        for line in lines(f):
            if line.len > 0:
                packets.add(parsePacket(line))

    let div1 = Packet(kind: ptList, listVal: @[Packet(kind: ptInt, intVal: 2)])
    let div2 = Packet(kind: ptList, listVal: @[Packet(kind: ptInt, intVal: 6)])
    packets.add(div1)
    packets.add(div2)

    packets.sort()
    var i1 = -1
    var i2 = -1
    for i in 0..<packets.len:
        if packets[i] == div1:
            i1 = i + 1
        elif packets[i] == div2:
            i2 = i + 1

    echo &"Part two: {i1 * i2}"

when isMainModule:
    #partOne()
    partTwo()
