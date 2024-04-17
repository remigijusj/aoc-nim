# Advent of Code 2016 - Day 18

import std/[strutils]
import ../utils/common

const traps = ["^^.", ".^^", "^..", "..^"]

proc parseData: string =
  readInput().strip


proc nextGen(row: var string) =
  var prev = '.' & row & '.'
  for n in 0..<row.len:
    row[n] = (if prev[n..n+2] in traps: '^' else: '.')


func countSafeTiles(data: string, rows: int): int =
  var row = data
  for _ in 1..rows:
    result += row.count('.')
    row.nextGen


let data = parseData()

benchmark:
  echo data.countSafeTiles(40)
  echo data.countSafeTiles(400000)
