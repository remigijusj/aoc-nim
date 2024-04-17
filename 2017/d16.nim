# Advent of Code 2017 - Day 16

import std/[strscans,strutils,algorithm]
import ../utils/common

type
  Data = seq[string]

const
  start = "abcdefghijklmnop"


proc parseData: Data =
  readInput().strip.split(",")


func runMoves(chars: var string, data: Data) =
  var s1, x1, x2: int
  var p1, p2: string

  for move in data:
    if move.scanf("s$i", s1):
      chars.rotateLeft(-s1)
    elif move.scanf("x$i/$i", x1, x2):
      swap(chars[x1], chars[x2])
    elif move.scanf("p$+/$+", p1, p2):
      x1 = chars.find(p1)
      x2 = chars.find(p2)
      swap(chars[x1], chars[x2])
    else:
      assert false


func findPeriod(data: Data): int =
  var chars = start
  while result == 0 or chars != start:
    chars.runMoves(data)
    result.inc


func runRepeat(data: Data, count: int): string =
  let period = data.findPeriod
  let times = count mod period

  result = start
  for _ in 0..<times:
    result.runMoves(data)


let data = parseData()

benchmark:
  echo data.runRepeat(1)
  echo data.runRepeat(1_000_000_000)
