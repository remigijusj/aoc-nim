# Advent of Code 2018 - Day 8

import std/[strutils,sequtils]
import ../utils/common

type Data = seq[int]


proc parseData: Data =
  readInput().strip.split(' ').map(parseInt)


func fold(data: Data, value: bool): int =
  var idx = 0

  proc helper(): int =
    let nodes = data[idx]
    let metas = data[idx+1]
    idx.inc(2)

    var children: seq[int]
    for _ in 0..<nodes:
      let val = helper()
      children.add(val)
      if not value:
        result += val

    for _ in 0..<metas:
      if value and nodes > 0:
        if data[idx] in 1..children.len:
          result += children[data[idx]-1]
      else:
        result += data[idx]
      idx.inc

  helper()


let data = parseData()

benchmark:
  echo data.fold(false)
  echo data.fold(true)
