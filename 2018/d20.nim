# Advent of Code 2018 - Day 20

import std/[strutils,sequtils,tables]

type
  Data = string
  Room = array[2, int32]
  Dist = Table[Room, int]


proc parseData: Data =
  readAll(stdin).strip(chars = Whitespace + {'^','$'})


proc walk(room: var Room, dir: char) =
  case dir
  of 'W': room[0].dec
  of 'E': room[0].inc
  of 'N': room[1].dec
  of 'S': room[1].inc
  else: discard


func calcDist(data: Data): Dist =
  var stack: seq[Room]
  var room: Room
  result[room] = 0
  for c in data:
    case c
    of '(':
      stack.add(room)
    of '|':
      room = stack[^1]
    of ')':
      room = stack.pop
    else:
      let dist = result[room]
      room.walk(c)
      if room notin result or result[room] > dist+1:
        result[room] = dist+1


let data = parseData()
let dist = data.calcDist.values.toSeq

echo dist.max
echo dist.countIt(it >= 1000)
