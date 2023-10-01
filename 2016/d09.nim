# Advent of Code 2016 - Day 9

import std/[parseutils,strutils,sequtils]
import ../utils/common

type Data = string


proc parseData: Data =
  readAll(stdin).strip


func decompressedLen(data: Data, recursive=false): int =
  var idx = 0
  var marker: string

  while idx < data.len:
    let pre = data.skipUntil('(', idx)
    idx.inc(pre+1)
    result.inc(pre)
    if idx >= data.len: break

    let xxx = data.parseUntil(marker, ')', idx)
    idx.inc(xxx+1)

    let parts = marker.split('x').map(parseInt)
    let val = if recursive:
                decompressedLen(data[idx ..< idx+parts[0]], true)
              else:
                parts[0]
    result += val * parts[1]
    idx += parts[0]


let data = parseData()

benchmark:
  echo data.decompressedLen
  echo data.decompressedLen(true)
