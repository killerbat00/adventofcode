from utils import withStream
from streams import lines
import 
    algorithm,
    sequtils,
    strformat,
    strutils

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

type 
    File = ref object
        name: string
        size: float

    Directory = ref object
        name: string
        parent: Directory
        subdirs: seq[Directory]
        files: seq[File]
        totalSize: float

var allDirs: seq[Directory] = @[]
proc recurseDirs(curDir: Directory, dirSize: float = 0): float =
    var dSize = dirSize
    for subDir in curDir.subDirs:
        dSize += recurseDirs(subDir, dirSize)
    for file in curDir.files:
        dSize += file.size
    
    curDir.totalSize = dSize
    allDirs.add(curDir)
    return dSize

proc emulate(commands: seq[string]): Directory =
    var
        root = Directory(name: "/", parent: nil, subDirs: newSeq[Directory](), files: newSeq[File]())
        curDir = root

    for line in commands:
        let parts = line.split(' ')

        if parts[0] == "dir":
            curDir.subDirs.add(Directory(name: parts[1], parent: curDir, subDirs: newSeq[Directory](), files: newSeq[File]()))
            continue

        if parts[0] == "$":
            if parts[1] == "cd":
                let dest = parts[2]

                if dest == curDir.name: #same dir
                    continue 
                elif dest == "..": #move to parent dir
                    if curDir.name == "/":
                        continue
                    elif isNil(curDir.parent):
                        quit(-1)
                    else:
                        curDir = curDir.parent
                        continue
                else: #move to child dir
                    var found = false
                    for subDir in curDir.subDirs:
                        if subDir.name == dest:
                            curDir = subDir
                            found = true
                            break
                    if found:
                        continue
                    var newDir = Directory(name: dest, parent: curDir, subDirs: newSeq[Directory](), files: newSeq[File]())
                    curDir.subDirs.add(newDir)
                    curDir = newDir
                    continue
        else:
            let 
                size = parts[0].parsefloat()
                name = parts[1]
            curDir.files.add(File(name: name, size: size))

    return root

proc partOne() =
    var commands = newSeq[string]()

    let fn = "./input/day_7.txt"
    #let fn = testData

    withStream(f, fn, fmRead):
        for line in lines(f):
            if line == "":
                continue
            commands.add(line)
    
    let rootDir = emulate(commands)
    discard recurseDirs(rootDir)

    var smallDirs: seq[int] = @[]
    for d in allDirs:
        if d.totalSize <= 100000.float:
            smallDirs.add(d.totalSize.int)

    echo &"Part one: {int(smallDirs.foldl(a + b))}"

proc partTwo() =
    # reset
    allDirs.delete(0..allDirs.high)
    var commands = newSeq[string]()
    
    let fn = "./input/day_7.txt"
    #let fn = testData

    withStream(f, fn, fmRead):
        for line in lines(f):
            if line == "":
                continue
            commands.add(line)

    let 
        rootDir = emulate(commands)
        ourSize = int(recurseDirs(rootDir))
        totalSize = 70000000
        totalSizeNeeded = 30000000
        freeSpace = totalSize - ourSize
        neededToFree = totalSizeNeeded - freeSpace

    var mightDelete: seq[Directory] = @[]
    for d in allDirs:
        if d.totalSize >= neededToFree.float:
            mightDelete.add(d)
    
    mightDelete.sort do (x, y: Directory) -> int:
        result = cmp(x.totalSize, y.totalSize)

    echo &"Part two: `rm -rf {mightDelete[0].name} #size={mightDelete[0].totalSize.int}`"

when isMainModule:
    partOne()
    partTwo()
