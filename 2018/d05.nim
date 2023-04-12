# Advent of Code 2018 - Day 5

import std/[strutils,sequtils,sugar]
import timeit

proc parseData: string =
  readAll(stdin).strip


func reduced(data: string, skip = ' '): string =
  result = newStringOfCap(data.len)
  for c in data:
    if c.toLowerAscii == skip: continue
    result.add(c)
    while result.len >= 2 and ((result[^1].ord xor result[^2].ord) == 32):
      result.setLen(result.len-2)


func improvedLen(data: string): int =
  result = data.len
  for c in 'a'..'z':
    let better = data.reduced(c)
    if better.len < result:
      result = better.len


let data = parseData()

echo data.reduced.len
echo data.improvedLen
