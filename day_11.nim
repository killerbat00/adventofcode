import strutils
import sugar
import algorithm
import strformat

const fn = "./input/day_11.txt"
const data = slurp(fn)

type
    Monkey = object 
        items: seq[int]
        op: string
        op_code: (int) -> int
        test: string
        test_code: (int) -> bool
        true_monkey: int 
        false_monkey: int 

var mod_num: int = 9699690
        
func `$`(monkey: ref Monkey): string =
    result = "Monkey: " & " items: " & $monkey.items & " op: " & monkey.op & " test: " & monkey.test & " true: " & $monkey.true_monkey & " false: " & $monkey.false_monkey

func initMonkey(monkeyData: seq[string]): ref Monkey =
    result = new(Monkey)

    result.items = newSeq[int]()
    let it = monkeyData[1].replace(",", "").split(" ")
    for i in it[2..^1]:
        result.items.add(i.parseInt)
    
    result.op = monkeyData[2].split(":")[1].strip()
    let code = result.op.split(" ")
    case code[^2]:
        of "+":
            result.op_code = (oldWorry: int) => oldWorry + code[^1].parseInt
        of "*":
            if code[^1] == "old":
                result.op_code = (oldWorry: int) => oldWorry * oldWorry
            else:
                result.op_code = (oldWorry: int) => oldWorry * code[^1].parseInt

    result.test = monkeyData[3].split(":")[1].strip()
    let testCode = result.test.split(" ")
    result.test_code = (worryLevel: int) => worryLevel mod testCode[^1].parseInt == 0
    result.true_monkey = monkeyData[4].split(" ")[^1].parseInt
    result.false_monkey = monkeyData[5].split(" ")[^1].parseInt

proc doRound(monkeys: seq[ref Monkey], itemsInspected: var seq[int], modNum: int = 0) =
    for i in 0..monkeys.len - 1:
        let monkey = monkeys[i]
        
        # no items, go to next monkey
        if monkey.items.len == 0:
            continue

        for item in monkey.items:
            itemsInspected[i] += 1
            var itemWorried = monkey.op_code(item)
            
            if modNum == 0:
                itemWorried = itemWorried div 3
            else:
                itemWorried = itemWorried mod mod_num

            if monkey.test_code(itemWorried):
                monkeys[monkey.true_monkey].items.add(itemWorried)
            else:
                monkeys[monkey.false_monkey].items.add(itemWorried)
        monkey.items = newSeq[int]()

proc partOne() =
    var monkeys = newSeq[ref Monkey]()

    let monkeyData = collect(newSeq):
        for line in data.split("\n"):
            line.strip()
    
    for i in countup(0, monkeyData.len - 7, 7):
        monkeys.add(initMonkey(monkeyData[i..<i+6]))
    
    var itemsInspected = collect(newSeq, (for i in 0..<monkeys.len: 0))

    for i in 0..<20:
        doRound(monkeys, itemsInspected)

    itemsInspected.sort()

    # monkey business is calculated by multiplying the number of 
    # items inspected by the two monkeys who inspected the most
    # items
    echo &"Part one: {itemsInspected[^1] * itemsInspected[^2]}"

proc partTwo() =
    var monkeys = newSeq[ref Monkey]()

    let monkeyData = collect(newSeq):
        for line in data.split("\n"):
            line.strip()
    
    for i in countup(0, monkeyData.len - 7, 7):
        monkeys.add(initMonkey(monkeyData[i..<i+6]))
    
    var itemsInspected = collect(newSeq, (for i in 0..<monkeys.len: 0))

    # to keep worry levels in check, we find the lowest
    # common multiple of all the test numbers (which happen
    # to be prime). We can safely mod our worry level for
    # each item by this number without impacting the result
    # of the test for recipient monkey
    var modNum = 1
    for m in monkeys:
        modNum *= m.test.split(" ")[^1].parseInt


    for i in 0..<10000:
        doRound(monkeys, itemsInspected, modNum)

    itemsInspected.sort()

    # monkey business is calculated by multiplying the number of 
    # items inspected by the two monkeys who inspected the most
    # items
    echo &"Part two: {itemsInspected[^1] * itemsInspected[^2]}"

when isMainModule:
    partOne()
    partTwo()
