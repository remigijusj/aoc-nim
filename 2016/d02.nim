# Advent of Code 2016 - Day 2

import std/[strutils,tables]
import ../utils/common

type
  Data = seq[string]

  XY = tuple[x, y: int]

  Keypad = Table[XY, char]


proc parseData: Data =
  readInput().strip.splitLines


converter toKeypad(rep: string): Keypad =
  let lines = rep.split("|")
  for y, line in lines:
    for x, c in line:
      if c != ' ': result[(x, y)] = c


func find(keypad: Keypad, key: char): XY =
  for xy, c in keypad:
    if c == key:
      return xy


func move(pos: XY, code: char): XY =
  case code
    of 'U': result = (pos.x, pos.y-1)
    of 'D': result = (pos.x, pos.y+1)
    of 'L': result = (pos.x-1, pos.y)
    of 'R': result = (pos.x+1, pos.y)
    else: assert false


func runCodes(data: Data, keypad: Keypad): string =
  var this = keypad.find('5')
  for codes in data:
    for code in codes:
      let next = this.move(code)
      if next in keypad:
        this = next

    result &= keypad[this]


let data = parseData()

benchmark:
  echo data.runCodes("123|456|789")
  echo data.runCodes("  1  | 234 |56789| ABC |  D  ")
