# Advent of Code 2024 - Day 21

import std/[strutils,sequtils,tables]
from algorithm import reverse
import ../utils/common

type
  Data = seq[string]

  RC = tuple[r, c: int]

  Keypad = Table[char, RC]

  Item = tuple
    move: RC
    reverse: bool

  Steps = CountTable[Item]


func buildKeypad(keypad: openArray[string]): Keypad =
  for r, row in keypad:
    for c, val in row:
      result[val] = (r, c)

const
  numPad = ["789","456","123"," 0A"].buildKeypad
  dirPad = [" ^A","<v>"].buildKeypad


proc parseData: Data =
  readInput().strip.splitLines


func `-`(a, b: RC): RC = (a.r - b.r, a.c - b.c)

func total(s: Steps): int = s.values.toSeq.sum


func steps(keypad: Keypad, code: string, cnt = 1): Steps =
  var this = keypad['A']
  let gap = keypad[' ']
  for c in code:
    let next = keypad[c]
    let f = (next.r == gap.r and this.c == gap.c) or (next.c == gap.c and this.r == gap.r)
    result.inc((next - this, f), cnt)
    this = next


func buildCode(it: Item): string =
  if it.move.c < 0: result &= repeat('<', -it.move.c)
  if it.move.r > 0: result &= repeat('v', +it.move.r)
  if it.move.r < 0: result &= repeat('^', -it.move.r)
  if it.move.c > 0: result &= repeat('>', +it.move.c)
  if it.reverse:
    result.reverse


func chainRobots(code: string, level: int): Steps =
  if level < 0:
    result = numPad.steps(code)
  else:
    for it, cnt in code.chainRobots(level - 1):
      for k, v in dirPad.steps(it.buildCode & 'A', cnt):
        result.inc(k, v)


func complexity(code: string, level: int): int =
  code.chainRobots(level).total * parseInt(code[0..^2])


let data = parseData()

benchmark:
  echo data.mapIt(it.complexity(2)).sum
  echo data.mapIt(it.complexity(25)).sum
