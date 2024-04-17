# Advent of Code 2016 - Day 5

import std/[strutils,sequtils]
import checksums/md5
import ../utils/common

type Data = string


proc parseData: Data =
  readInput().strip


proc findPassword1(data: Data): string =
  for n in 0..int.high:
    let hash = getMD5(data & $n)
    if hash.startsWith("00000"):
      result.add hash[5]
    if result.len == 8:
      return


proc findPassword2(data: Data): string =
  result.setLen(8)
  var found = 0
  for n in 0..int.high:
    let hash = getMD5(data & $n)
    if hash.startsWith("00000"):
      let pos = fromHex[int](hash[5..5])
      if pos < 8 and result[pos] == '\0':
        result[pos] = hash[6]
        found.inc
        if found == 8:
          return


let data = parseData()

benchmark:
  echo data.findPassword1 # 7s
benchmark:
  echo data.findPassword2 # 11s
