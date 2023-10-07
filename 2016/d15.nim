# Advent of Code 2016 - Day 15

import std/[strscans,strutils,sequtils,math]
import ../utils/common

type
  Config = tuple
    disc, count, start: int

  Data = seq[Config]


func parseConfig(line: string): Config =
  assert line.scanf("Disc #$i has $i positions; at time=0, it is at position $i.",
    result.disc, result.count, result.start)


proc parseData: Data =
  readAll(stdin).strip.splitLines.map(parseConfig)


proc modInv(a0, b0: int): int =
  var (a, b, x0) = (a0, b0, 0)
  result = 1
  if b == 1: return
  while a > 1:
    let q = a div b
    a = a mod b
    swap a, b
    result = result - q * x0
    swap x0, result
  if result < 0: result += b0


# result ~ ai mod ni
proc chineseRemainder(n, a: openArray[int]): int =
  var prod = 1
  for x in n: prod *= x

  var sum = 0
  for i in 0..<n.len:
    let p = prod div n[i]
    sum += a[i] * modInv(p, n[i]) * p

  result = euclMod(sum, prod)


func firstTime(data: Data): int =
  let n = data.mapIt(it.count)
  let a = data.mapIt(- it.start - it.disc)
  result = chineseRemainder(n, a)


var data = parseData()

benchmark:
  echo data.firstTime
  data &= (7, 11, 0)
  echo data.firstTime
