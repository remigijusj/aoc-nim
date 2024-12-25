# Advent of Code 2024 - Day 25

import std/[strutils,sequtils]
import ../utils/common

type
  Item = tuple
    pins: array[5, range[0..5]] 
    lock: bool

  Data = seq[Item]


func parseItem(part: string): Item =
  let lines = part.split("\n")
  assert lines.len == 7 and lines.allIt(it.len == 5)
  result.lock = lines[0] == "#####"
  assert lines[if result.lock: lines.len-1 else: 0] == "....."
  for line in lines[1..^2]:
    for i, val in line:
      if val == '#':
        result.pins[i].inc


proc parseData: Data =
  readInput().strip.split("\n\n").mapIt(it.parseItem)


func countFitting(data: Data): int =
  for a in data:
    for b in data:
      if a.lock and not b.lock:
        if zip(a.pins, b.pins).mapIt(it[0] + it[1]).allIt(it <= 5):
          result.inc


let data = parseData()

benchmark:
  echo data.countFitting
