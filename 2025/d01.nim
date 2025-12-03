# Advent of Code 2025 - Day 1

import std/[strutils,sequtils,math]
import ../utils/common

type
  Rot = int

  Data = seq[Rot]

const
  start = 50
  cycle = 100


func parseRot(line: string): Rot =
  let sign = if line[0] == 'L': -1 else: 1
  result = sign * parseInt(line[1..^1])


proc parseData: Data =
  readInput().strip.splitLines.map(parseRot)


func countZeros1(data: Data): int =
  var this = start
  for it in data:
    this = euclMod(this + it, cycle)
    if this == 0: result.inc


func countZeros2a(data: Data): int =
  var this = start
  for it in data:
    for _ in 0..<it.abs:
      this = euclMod(this + it.sgn, cycle)
      if this == 0: result.inc


func countZeros2(data: Data): int =
  var this = start
  for it in data:
    let next = this + it
    result += next.abs div cycle
    if next <= 0 and this > 0: result.inc
    this = euclMod(next, cycle)


let data = parseData()

benchmark:
  echo data.countZeros1
  echo data.countZeros2
