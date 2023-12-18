# Advent of Code 2023 - Day 18

import std/[strutils,sequtils,strscans]
import ../utils/common

type
  Item = tuple
    dir: char
    len: int
    code: string

  Data = seq[Item]

  XY = tuple[x, y: int]

  Move = tuple[dir, len: int]

const
  moves = "RDLU"
  delta: array[4, XY] = [(1, 0), (0, 1), (-1, 0), (0, -1)]


func parseInstruction(line: string): Item =
  assert line.scanf("$c $i (#$+)", result.dir, result.len, result.code)


proc parseData: Data =
  readAll(stdin).strip.splitLines.map(parseInstruction)


func lagoonArea(list: seq[Move]): int =
  var size = 0
  var area = 0
  var pos: XY = (0, 0)
  for item in list:
    let move = delta[item.dir]
    pos.x += move.x * item.len
    pos.y += move.y * item.len
    let mult = delta[(item.dir + 1) mod 4]
    area += (pos.x * mult.x + pos.y * mult.y) * item.len
    size += item.len

  result = area.abs div 2 + size div 2 + 1


func decode1(it: Item): Move = (moves.find(it.dir), it.len)

func decode2(it: Item): Move = (it.code[5..5].parseInt, it.code[0..4].parseHexInt)


let data = parseData()

benchmark:
  echo data.map(decode1).lagoonArea
  echo data.map(decode2).lagoonArea
