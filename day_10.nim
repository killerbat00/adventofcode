from utils import withStream
from streams import lines
import options
import strutils
import strformat
import sequtils

type
    Instruction = object
        ins: string
        val: Option[int]

    CPU = object
        cycle: int
        X: int
        regHistory: seq[int] #value of X at cycle i
        ip: int
        instructions: seq[Instruction]

const TEST_DATA = """
addx 15
addx -11
addx 6
addx -3
addx 5
addx -1
addx -8
addx 13
addx 4
noop
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx -35
addx 1
addx 24
addx -19
addx 1
addx 16
addx -11
noop
noop
addx 21
addx -15
noop
noop
addx -3
addx 9
addx 1
addx -3
addx 8
addx 1
addx 5
noop
noop
noop
noop
noop
addx -36
noop
addx 1
addx 7
noop
noop
noop
addx 2
addx 6
noop
noop
noop
noop
noop
addx 1
noop
noop
addx 7
addx 1
noop
addx -13
addx 13
addx 7
noop
addx 1
addx -33
noop
noop
noop
addx 2
noop
noop
noop
addx 8
noop
addx -1
addx 2
addx 1
noop
addx 17
addx -9
addx 1
addx 1
addx -3
addx 11
noop
noop
addx 1
noop
addx 1
noop
noop
addx -13
addx -19
addx 1
addx 3
addx 26
addx -30
addx 12
addx -1
addx 3
addx 1
noop
noop
noop
addx -9
addx 18
addx 1
addx 2
noop
noop
addx 9
noop
noop
noop
addx -1
addx 2
addx -37
addx 1
addx 3
noop
addx 15
addx -21
addx 22
addx -6
addx 1
noop
addx 2
addx 1
noop
addx -10
noop
noop
addx 20
addx 1
addx 2
addx 2
addx -6
addx -11
noop
noop
noop
"""

func initCPU(): ref CPU = 
    result = new(CPU)
    result.cycle = 0
    result.X = 1
    result.regHistory = newSeq[int]()
    result.regHistory.add(-1) # cycles are 1 indexed, add a placeholder value
    result.ip = 0
    result.instructions = newSeq[Instruction]()

proc oneCycle(cpu: ref CPU) =
    cpu.cycle += 1
    cpu.regHistory.add(cpu.X)

proc oneInstruction(cpu: ref CPU) =
    let ins = cpu.instructions[cpu.ip]
    case ins.ins:
        of "noop":
            oneCycle(cpu)
        of "addx":
            oneCycle(cpu)
            oneCycle(cpu)
            try:
                cpu.X += ins.val.get()
            except UnpackDefect:
                echo "Error: addx instruction missing value"
    cpu.ip += 1

proc partOne() =
    let fn = "./input/day_10.txt"
    #let fn = TEST_DATA

    var cpu = initCPU()

    withStream(f, fn, fmRead):
        for line in lines(f):
            let iParts = line.split(" ")
            if iParts.len == 2:
                let val = iParts[1].parseInt()
                cpu.instructions.add(Instruction(ins: iParts[0], val: some(val)))
            else:
                cpu.instructions.add(Instruction(ins: iParts[0]))
    
    while cpu.ip < cpu.instructions.len:
        oneInstruction(cpu)

    let parts = @[cpu.regHistory[20]*20, cpu.regHistory[60]*60, cpu.regHistory[100]*100, cpu.regHistory[140]*140, cpu.regHistory[180]*180, cpu.regHistory[220]*220]
    echo parts

    echo "Part one: ", parts.foldl(a + b, 0)

proc partTwo() =
    let fn = "./input/day_10.txt"
    
    withStream(f, fn, fmRead):
        for line in lines(f):
            discard line
            #echo line
    echo "Part two: "

when isMainModule:
    partOne()
    partTwo()
