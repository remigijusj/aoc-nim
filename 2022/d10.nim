# Advent of Code 2022 - Day 10

import std/[strutils,sequtils]

type Data = seq[int]


func parseLine(line: string): int =
  if line == "noop":
    0
  else:
    parseInt(line[5..^1])


proc parseData: Data =
  readAll(stdin).strip.splitLines.map(parseLine)


iterator runCycles(data: Data): (int, int) =
  var x = 1
  var c = 0
  for op in data:
    if op == 0:
      c.inc
    else:
      c.inc
      yield (c, x)
      c.inc
    yield (c, x)
    x += op


func totalStrength(data: Data): int =
  for (c, x) in data.runCycles:
    if c mod 40 == 20:
      result += c * x


func renderCRT(data: Data): string =
  var crt = newSeqWith(6, ' '.repeat(40))

  for (c, x) in data.runCycles:
    let (row, col) = ((c-1) div 40, (c-1) mod 40)
    if (x - col).abs <= 1:
      crt[row][col] = '#'

  result = crt.join("\n")


let data = parseData()

let part1 = data.totalStrength
let part2 = data.renderCRT

echo part1
echo part2
