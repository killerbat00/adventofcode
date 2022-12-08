from utils import withStream
from std/streams import lines

const testData = """
$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k
"""

proc partOne() =
    var
        commands = newSeq[string]()

    #let fn = "./input/day_7.txt"
    let fn = testData

    withStream(f, fn, fmRead):
        for line in lines(f):
            if line == "":
                continue
            commands.add(line)

    echo "Part one: ", $commands

proc partTwo() =
    echo "Part two: "

when isMainModule:
    partOne()
    partTwo()
