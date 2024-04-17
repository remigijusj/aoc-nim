# Advent of code 2020 - Day 7

import std/[strutils, sequtils, tables, nre]
import ../utils/common

type
  Bag = tuple[count: int, color: string]

  Rules = TableRef[string, seq[Bag]]


proc parseRule(rules: Rules, line: string) =
  let color = line.match(re"^(\w+ \w+) bags contain ").get.captures[0]
  var bags = newSeq[Bag]()
  for match in line.findIter(re"(\d+) (\w+ \w+) bags?"):
    bags.add (parseInt(match.captures[0]), match.captures[1])

  rules[color] = bags


proc parseData: Rules =
  result = newTable[string, seq[Bag]]()
  for line in readInput().strip.splitLines:
    result.parseRule(line)


proc contains(rules: Rules, root, target: string): bool =
  rules[root].anyIt(it.color == target or rules.contains(it.color, target))


proc countContaining(rules: Rules, color: string): int =
  rules.keys.toSeq.countIt(rules.contains(it, color))


proc countInside(rules: Rules, color: string): int =
  rules[color].mapIt(it.count * (rules.countInside(it.color) + 1)).sum


let rules = parseData()

benchmark:
  echo rules.countContaining("shiny gold")
  echo rules.countInside("shiny gold")
