# Advent of Code 2017 - Day 6

import std/[strutils,sequtils,tables]
import ../utils/common

type
  Data = seq[int]

  Loop = Table[Data, int]


proc parseData: Data =
  readInput().strip.splitWhitespace.map(parseInt)


proc redistribute(data: var Data) =
  var idx = data.maxIndex
  let num = data[idx]

  data[idx] = 0
  for i in 0..<num:
    idx = (idx + 1) mod data.len
    data[idx].inc


func detectLoop(data: Data): (int, int) =
  var data = data
  var loop: Loop

  while data notin loop:
    loop[data] = loop.len
    data.redistribute

  result = (loop.len, loop.len - loop[data])


let data = parseData()

benchmark:
  let loop = data.detectLoop
  echo loop[0]
  echo loop[1]
