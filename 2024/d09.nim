# Advent of Code 2024 - Day 9

import std/[strutils,sequtils]
import ../utils/common

type
  Data = seq[int]

  Item = tuple
    idx, len, fid: int

  List = seq[Item]


proc parseData: Data =
  readInput().strip.mapIt(it.ord - '0'.ord)


func buildList(data: Data): List =
  var idx = 0
  for i, val in data:
    let fid = if i mod 2 == 0: i div 2 else: -1
    result.add (idx, val, fid)
    idx += val


template compact(list: List, ops: untyped): untyped =
  result = list
  var b {.inject.} = result.len-1
  while b > 0:
    if result[b].fid >= 0 and result[b].len > 0:
      for a {.inject.} in 0..<b:
        if result[a].fid == -1:
          ops # pass: a, b
          break
    b.dec


func compacted(list: List, whole = false): List =
  compact(list):
    let rest = result[a].len - result[b].len

    if rest > 0:
      result[a].fid = result[b].fid
      result[a].len = result[b].len
      result[b].fid = -1
      let frag = (result[a].idx + result[b].len, rest, -1)
      result.insert(frag, a+1)
      b.inc

    elif rest == 0:
      result[a].fid = result[b].fid
      result[b].fid = -1

    else: # rest < 0
      if whole:
        continue
      result[a].fid = result[b].fid
      result[b].len = -rest
      b.inc


func checksum(list: List): int =
  for (idx, len, fid) in list:
    if fid > 0:
      let sum = idx * len + (len * (len-1) div 2)
      result += sum * fid


let data = parseData()
let list = data.buildList

benchmark:
  echo list.compacted.checksum
  echo list.compacted(whole=true).checksum
