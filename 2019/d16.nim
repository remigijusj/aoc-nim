# Advent of Code 2019 - Day 16

import std/[strutils,sequtils]
import ../utils/common

type Data = seq[int]


proc parseData(): Data =
  readInput().strip.mapIt(it.ord - '0'.ord)


proc applyFFT(data: var Data) =
  var val: int
  for n in 0..<data.len:
    val = 0
    for k in n..<data.len:
      case (k-n) div (n+1) mod 4
        of 0: val.inc(data[k])
        of 2: val.dec(data[k])
        else: continue

    data[n] = (val mod 10).abs


proc firstEight(data: Data): string =
  var data = data
  for _ in 1..100:
    data.applyFFT
  result = data[0..<8].mapIt($it).join


# lower half of FFT is triangular ones matrix
proc embeddedMsg(data: Data): string =
  let offset = data[0..<7].foldl(a * 10 + b)
  var data = data.cycle(10_000)[offset..^1]
  for _ in 1..100:
    for k in countdown(data.len-2, 0):
      data[k] = (data[k] + data[k+1]) mod 10
  result = data[0..<8].mapIt($it).join


let data = parseData()

benchmark:
  echo data.firstEight
  echo data.embeddedMsg
