# Advent of Code 2021 - Day 10

import std/[sequtils, strutils, tables, algorithm]
import ../utils/common

const
  Trans = {'(': ')', '[': ']', '{': '}', '<': '>'}.toTable
  Error = {')': 3, ']': 57, '}': 1197, '>': 25137}.toTable
  Final = {')': 1, ']': 2, '}': 3, '>': 4}.toTable

type Data = seq[string]


proc parseData: Data =
  readInput().strip.splitLines


proc parse(line: string): tuple[stack: seq[char], score: int] =
  for c in line:
    if c in Trans:
      result.stack.add(Trans[c])
    elif result.stack.len == 0 or result.stack.pop() != c:
      result.score = Error[c]
      return


proc completion(stack: seq[char]): int =
  for c in stack.reversed:
    result = result * 5 + Final[c]


proc median(list: seq[int]): int =
  let list = list.sorted
  result = list[list.len div 2]


let data = parseData()

benchmark:
  echo data.mapIt(it.parse.score).sum
  echo data.mapIt(it.parse).filterIt(it.score == 0).mapIt(it.stack.completion).median
