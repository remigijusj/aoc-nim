# Advent of Code 2024 - Day 19

import std/[strutils,sequtils,algorithm]
import ../utils/common
import memo

type
  Data = tuple
    towels: seq[string]
    designs: seq[string]

var data: Data


proc parseData: Data =
  let parts = readInput().strip.split("\n\n")
  result.towels = parts[0].split(", ").sortedByIt(-it.len)
  result.designs = parts[1].split("\n")


func possible(design: string, idx: int): bool {.memoized.} =
  if idx == design.len:
    return true
  for tow in data.towels:
    if design.continuesWith(tow, idx) and design.possible(idx + tow.len):
      return true


func compositions(design: string, idx: int): int {.memoized.} =
  if idx == design.len:
    return 1
  for tow in data.towels:
    if design.continuesWith(tow, idx):
      result += design.compositions(idx + tow.len)


data = parseData()

benchmark:
  echo data.designs.countIt(it.possible(0))
  echo data.designs.mapIt(it.compositions(0)).sum
