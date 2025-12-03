# Advent of Code 2025 - Day 3

import std/[strutils,sequtils]
import ../utils/common

type
  Bank = seq[int]
  Data = seq[Bank]


func parseBank(line: string): Bank =
  line.mapIt(it.ord - '0'.ord)


proc parseData: Data =
  readInput().strip.splitLines.mapIt(it.parseBank)


func maxJoltage2(bank: Bank): int =
  for i, b in bank:
    for j, a in bank[0..<i]:
      result = max(result, a * 10 + b)


# Greedy largest subsequence using monotonic stack
func maxJoltage(bank: Bank, k: int): int =
  var stack: seq[int]
  var rest = bank.len - k

  for d in bank:
    while stack.len > 0 and d > stack[^1] and rest > 0:
      discard stack.pop
      rest.dec
    stack.add(d)

  for d in stack[0..<k]:
    result = result * 10 + d


let data = parseData()

benchmark:
  echo data.mapIt(it.maxJoltage2).sum
  echo data.mapIt(it.maxJoltage(12)).sum
