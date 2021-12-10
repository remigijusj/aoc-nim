# Advent of Code 2021 - Day 10

import std/[sequtils, tables, algorithm]

const
  Trans = {'(': ')', '[': ']', '{': '}', '<': '>'}.toTable
  Error = {')': 3, ']': 57, '}': 1197, '>': 25137}.toTable
  Final = {')': 1, ']': 2, '}': 3, '>': 4}.toTable

type Data = seq[string]


proc parseData(filename: string): Data =
  lines(filename).toSeq


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


proc partOne(data: Data): int = data.mapIt(it.parse.score).foldl(a + b)
proc partTwo(data: Data): int = data.mapIt(it.parse).filterIt(it.score == 0).mapIt(it.stack.completion).median


let data = parseData("inputs/10.txt")
echo partOne(data)
echo partTwo(data)
