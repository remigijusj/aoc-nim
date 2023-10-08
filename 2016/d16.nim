# Advent of Code 2016 - Day 16

import std/[strutils,algorithm]
import ../utils/common


proc parseData: string =
  readAll(stdin).strip


func fillDisk(data: string, size: int): string =
  result = data
  while result.len < size:
    result &= "0" & result.reversed.join.multiReplace(("0","1"), ("1","0"))
  result.setLen(size)


func checksum(data: string): string =
  result = data
  while result.len mod 2 == 0:
    for i in countup(0, result.len-2, 2):
      result[i div 2] = if result[i] == result[i+1]: '1' else: '0'
    result.setLen(result.len div 2)


let data = parseData()

benchmark:
  echo data.fillDisk(272).checksum
  echo data.fillDisk(35651584).checksum
