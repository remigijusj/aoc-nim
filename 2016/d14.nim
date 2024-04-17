# Advent of Code 2016 - Day 14

import std/[strutils,nre]
import checksums/md5
import ../utils/common

type
  Data = string # salt

let repeat = re"(.)\1{2,4}"


proc parseData: Data =
  readInput().strip


iterator keys(data: Data, stretch: bool): (int, string) =
  var repeats: array[16, seq[int]]

  for i in 0..int.high:
    var hash = getMD5(data & $i)
    if stretch:
      for k in 1..2016:
        hash = getMD5(hash)

    var added = false
    for rep in hash.findAll(repeat):
      let hi = fromHex[int](rep[0..0])
      if rep.len == 5:
        for j in repeats[hi]:
          if i - j <= 1000:
            yield (j, hash)
      elif not added:
        repeats[hi].add(i)
        added = true


proc findNth(data: Data, n: int, stretch = false): int =
  var indices: seq[int]
  for i, key in data.keys(stretch):
    indices.add(i)
    if indices.len == n: # may be out of order?!
      return indices[n-1]


let data = parseData()

benchmark:
  echo data.findNth(64)
  echo data.findNth(64, true)
