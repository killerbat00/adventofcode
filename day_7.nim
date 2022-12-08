from utils import withStream
from std/streams import lines
from std/strutils import split, parseInt
import std/tables

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

type Directory = ref object
    name: string
    size: int
    parent: Directory
    subdirs: seq[Directory]
    files: ref Table[string, int]

proc emulate(commands: seq[string]) =
    var
        rootDirectory = Directory(name: "/", size: 0, parent: nil, subDirs: newSeq[Directory](), files: newTable[string, int]())
        parsingOutput = false
        currentDir = rootDirectory

    for line in commands:
        if parsingOutput:
            if line[0] == '$':
                parsingOutput = false
            else:
                let
                    parts = line.split(' ')
                    name = parts[1]
                    size = parts[0]
                if size == "dir":
                    var newDir = Directory(name: name, size: 0, parent: currentDir, subDirs: newSeq[Directory](), files: newTable[string, int]())
                    currentDir.subdirs.add(newDir)
                else:
                    let size = parseInt(size)
                    currentDir.files[name] = size
                    currentDir.size += size
                    var tmpDir = currentDir
                    while not isNil(tmpDir.parent):
                        tmpDir.parent.size += size
                        tmpDir = tmpDir.parent

        if line[0] == '$':
            let
                commandParts = line.split(' ')
                command = commandParts[1]
            if command == "cd":
                let args = commandParts[2]
                if args == currentDir.name:
                    continue
                elif args == "..":
                    if not isNil(currentDir.parent):
                        currentDir = currentDir.parent
                else:
                    var newDir = Directory(name: args, size: 0, parent: currentDir, subDirs: newSeq[Directory](), files: newTable[string, int]())
                    currentDir = newDir
            elif command == "ls":
                parsingOutput = true
                continue

    echo rootDirectory.size

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

    emulate(commands)
    echo "Part one: "

proc partTwo() =
    echo "Part two: "

when isMainModule:
    partOne()
    partTwo()
