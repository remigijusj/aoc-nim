# Advent of Code 2022 - Day 5

import std/[strutils,strscans,algorithm]
import ../utils/common

type
  Move = tuple[num, src, dst: int]

  Stacks = array[10, seq[char]]

  Data = object
    stacks: Stacks
    moves: seq[Move]


proc parseData: Data =
  var a, b, c: int
  for line in readInput().strip.splitLines:
    if line.len > 0 and line[0] == '[':
      for i in 1..9:
        let c = line[i*4-3]
        if c != ' ': result.stacks[i].insert(c)

    elif line.scanf("move $i from $i to $i", a, b, c):
      result.moves.add (a, b, c)


proc moveCrates(data: Data, multi = false): Stacks =
  result = data.stacks
  for (num, src, dst) in data.moves:
    for i in 0..<num:
      result[dst].add result[src].pop
    if multi:
      let l = result[dst].len
      result[dst].reverse(l-num, l-1)


proc top(stacks: Stacks): string =
  for s in stacks[1..^1]:
    result.add s[^1]


let data = parseData()

benchmark:
  echo data.moveCrates.top
  echo data.moveCrates(true).top
