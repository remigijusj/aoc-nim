# Advent of Code 2021 - Day 14

import std/[strutils, sequtils, tables]

type
  Data = object
    poly: string
    rules: Table[string, string]


proc parseRule(line: string): (string, string) =
  let parts = line.split(" -> ")
  result = (parts[0], parts[1])


proc parseData(filename: string): Data =
  let parts = readFile(filename).strip.split("\n\n")
  result.poly = parts[0]
  result.rules = parts[1].split("\n").map(parseRule).toTable


proc pairCounts(poly: string): CountTable[string] =
  for i in 0..<poly.len-1:
    result.inc(poly[i..i+1])


proc charCounts(table: CountTable[string]): CountTable[char] =
  for key, cnt in table:
    result.inc(key[0], cnt)


proc replace(table: CountTable[string], rules: Table[string, string]): CountTable[string] =
  for pair, cnt in table:
    result.inc(pair[0] & rules[pair], cnt)
    result.inc(rules[pair] & pair[1], cnt)


proc generate(data: Data, steps: int): CountTable[char] =
  var table = pairCounts(data.poly)
  for _ in 1..steps:
    table = table.replace(data.rules)

  result = table.charCounts
  result.inc(data.poly[^1])
  result.sort


proc width(table: CountTable[char]): int =
  let counts = table.values.toSeq
  result = counts[0] - counts[^1]


proc partOne(data: Data): int = data.generate(10).width
proc partTwo(data: Data): int = data.generate(40).width


let data = parseData("inputs/14.txt")
echo partOne(data)
echo partTwo(data)
