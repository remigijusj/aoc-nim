# Advent of code 2020 - Day 7

import strutils, sequtils, tables, nre
from math import sum

type Bag = tuple[count: int, color: string]

type Rules = TableRef[string, seq[Bag]]

proc parseRule(rules: Rules, line: string) =
  let color = line.match(re"^(\w+ \w+) bags contain ").get.captures[0]
  var bags = newSeq[Bag]()
  for match in line.findIter(re"(\d+) (\w+ \w+) bags?"):
    bags.add (parseInt(match.captures[0]), match.captures[1])

  rules[color] = bags


proc fetchRules(filename: string): Rules =
  result = newTable[string, seq[Bag]]()
  for line in lines(filename):
    result.parseRule(line)


proc contains(rules: Rules, root, target: string): bool =
  rules[root].anyIt(it.color == target or rules.contains(it.color, target))


proc countContaining(rules: Rules, color: string): int =
  rules.keys.toSeq.countIt(rules.contains(it, color))


proc countInside(rules: Rules, color: string): int =
  rules[color].mapIt(it.count * (rules.countInside(it.color) + 1)).sum


proc partOne(rules: Rules): int = rules.countContaining("shiny gold")
proc partTwo(rules: Rules): int = rules.countInside("shiny gold")


let rules = fetchRules("inputs/07.txt")
echo partOne(rules)
echo partTwo(rules)
