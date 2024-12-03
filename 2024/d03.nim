# Advent of Code 2024 - Day 3

import std/[nre,sequtils,strutils]
import ../utils/common


proc parseData: string =
  readInput()


func scanMul(data: string): int =
  for m in data.findIter(re"mul\((\d+),(\d+)\)"):
    let cap = m.captures.mapIt(it.get.parseInt)
    result += cap[0] * cap[1]


func scanMulExtended(data: string): int =
  var mul = true
  for m in data.findIter(re"do\(\)|don't\(\)|mul\((\d+),(\d+)\)"):
    if m.match == "do()":
      mul = true
    elif m.match == "don't()":
      mul = false
    elif mul:
      let cap = m.captures.mapIt(it.get.parseInt)
      result += cap[0] * cap[1]


let data = parseData()

benchmark:
  echo data.scanMul
  echo data.scanMulExtended
