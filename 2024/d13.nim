# Advent of Code 2024 - Day 13

import std/[strscans,strutils,sequtils]
from math import divMod
import ../utils/common

type
  Machine = tuple
    ax, ay, bx, by, cx, cy: int

  Data = seq[Machine]


func parseMachine(blob: string): Machine =
  assert blob.scanf("Button A: X+$i, Y+$i\nButton B: X+$i, Y+$i\nPrize: X=$i, Y=$i",
    result.ax, result.ay, result.bx, result.by, result.cx, result.cy)


proc parseData: Data =
  readInput().strip.split("\n\n").map(parseMachine)


# ax * a + bx * b = cx
# ay * a + by * b = cy
func minTokens(m: Machine): int =
  let det = m.ax * m.by - m.bx * m.ay
  assert det != 0
  let aaa = m.cx * m.by - m.bx * m.cy
  let bbb = m.ax * m.cy - m.cx * m.ay
  let (a, ar) = divMod(aaa, det)
  let (b, br) = divMod(bbb, det)
  if ar == 0 and br == 0:
    result = 3 * a + b


func modify(m: Machine): Machine =
  result = m
  result.cx += 10_000_000_000_000
  result.cy += 10_000_000_000_000


let data = parseData()

benchmark:
  echo data.mapIt(it.minTokens).sum
  echo data.mapIt(it.modify.minTokens).sum
