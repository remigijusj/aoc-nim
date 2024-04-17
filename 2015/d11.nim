# Advent of Code 2015 - Day 11

import std/[strutils]
import ../utils/common


proc parseData: string =
  readInput().strip


func isValid(data: string): bool =
  var triplet: bool
  var doubles: seq[int]
  for i, c in data:
    if c in "iol":
      return false
    if i >= 1 and c == data[i-1] and i-1 notin doubles:
      doubles.add(i)
    if i >= 2 and c == data[i-1].succ and data[i-1] == data[i-2].succ:
      triplet = true

  result = triplet and doubles.len >= 2


proc increment(data: var string) =
  var i = data.high
  while true:
    if data[i] == 'z':
      data[i] = 'a'
      i.dec
    else:
      data[i] = data[i].succ
      break


proc nextPassword(pass: var string): string =
  while true:
    pass.increment
    if pass.isValid:
      return pass


var data = parseData()

benchmark:
  echo data.nextPassword
  echo data.nextPassword
