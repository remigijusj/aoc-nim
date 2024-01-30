# Advent of Code 2015 - Day 4

import std/[strutils]
import checksums/md5
import ../utils/common

type Data = string


proc parseData: Data =
  readAll(stdin).strip


proc findHash(data: Data, count: int): int =
  let target = repeat('0', count)
  for n in 1..int.high:
    let hash = getMD5(data & $n)
    if hash.startsWith(target):
      return n


let data = parseData()

benchmark:
  echo data.findHash(5) # 0.1s
benchmark:
  echo data.findHash(6) # 4s
