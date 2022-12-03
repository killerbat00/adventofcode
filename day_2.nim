from utils import withFile
from std/strutils import splitWhitespace

proc partOne() =
    var
        totalScore = 0

    withFile(f, "./input/day_2.txt", fmRead):
        for line in lines(f):
            if line != "":
                let
                    splitLine = line.splitWhitespace()
                    opponent = splitLine[0]
                    me = splitLine[1]
                if opponent == "A": # rock
                    if me == "X": # rock
                        totalScore += 1
                        totalScore += 3 # draw
                    elif me == "Y": # paper
                        totalScore += 2
                        totalScore += 6 # win
                    elif me == "Z": # scissors
                        totalScore += 3
                        totalScore += 0 # lose
                elif opponent == "B": # paper
                    if me == "X": # rock
                        totalScore += 1
                        totalScore += 0 # lose
                    elif me == "Y": # paper
                        totalScore += 2
                        totalScore += 3 # draw
                    elif me == "Z": # scissors
                        totalScore += 3
                        totalScore += 6 # win
                elif opponent == "C": # scissors
                    if me == "X": # rock
                        totalScore += 1
                        totalScore += 6 # win
                    elif me == "Y": # paper
                        totalScore += 2
                        totalScore += 0 # lose
                    elif me == "Z": # scissors
                        totalScore += 3
                        totalScore += 3 # draw

    echo "Part one: ", totalScore

proc partTwo() =
    var
        totalScore = 0

    withFile(f, "./input/day_2.txt", fmRead):
        for line in lines(f):
            if line != "":
                let
                    splitLine = line.splitWhitespace()
                    opponent = splitLine[0]
                    me = splitLine[1]
                if opponent == "A": # rock
                    if me == "X": # lose, choose scissors
                        totalScore += 3 # scissors
                        totalScore += 0 # lose
                    elif me == "Y": # draw, choose rock
                        totalScore += 1 # rock
                        totalScore += 3 # draw
                    elif me == "Z": # win, choose paper
                        totalScore += 2 # paper
                        totalScore += 6 # win
                elif opponent == "B": # paper
                    if me == "X": # lose, choose rock
                        totalScore += 1 # rock
                        totalScore += 0 # lose
                    elif me == "Y": # draw, choose paper
                        totalScore += 2 # paper
                        totalScore += 3 # draw
                    elif me == "Z": # win, choose scissors
                        totalScore += 3 # scissors
                        totalScore += 6 # win
                elif opponent == "C": # scissors
                    if me == "X": # lose, choose paper
                        totalScore += 2 # paper
                        totalScore += 0 # lose
                    elif me == "Y": # draw, choose scissors
                        totalScore += 3 # scissors
                        totalScore += 3 # draw
                    elif me == "Z": # win, choose rock
                        totalScore += 1 # rock
                        totalScore += 6 # win

    echo "Part two: ", totalScore

when isMainModule:
    partOne()
    partTwo()
