# Advent of Code 2017 - Day 19

import std/[strutils]
import ../utils/common

type
  Data = seq[string]

  Dir = enum
    up, dn, lt, rt

  XY = tuple[x, y: int]


proc parseData: Data =
  readInput().splitLines


func followPath(data: Data): tuple[seen: string, step: int] =
  var loc: XY = (data[0].find('|'), 0)
  var dir: Dir = dn

  while true:
    let this = data[loc.y][loc.x]
    if this == ' ':
      return
    elif this == '+':
      case dir
        of up, dn:
          if data[loc.y][loc.x+1] != ' ':
            loc.x.inc
            dir = rt
          else:
            loc.x.dec
            dir = lt
        of lt, rt:
          if data[loc.y+1][loc.x] != ' ':
            loc.y.inc
            dir = dn
          else:
            loc.y.dec
            dir = up
    else:
      if this in 'A'..'Z':
        result.seen.add(this)
      case dir
        of up: loc.y.dec
        of dn: loc.y.inc
        of lt: loc.x.dec
        of rt: loc.x.inc

    result.step.inc


let data = parseData()

benchmark:
  let path = data.followPath
  echo path.seen
  echo path.step
