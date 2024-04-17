# Advent of Code 2019 - Day 6

import std/[strutils,tables,sets]
import ../utils/common

type Data = Table[string,string]


proc parseData: Data =
  for line in readInput().strip.splitLines:
    let parts = line.split(')')
    result[parts[1]] = parts[0]


proc ancestorsCount(data: Data, node: string): int =
  var node = node
  while data.hasKey(node):
    node = data[node]
    result.inc


proc ancestorsSet(data: Data, node: string): HashSet[string] =
  var node = node
  while data.hasKey(node):
    node = data[node]
    result.incl(node)


proc countOrbits(data: Data): int =
  for node in data.keys:
    result += data.ancestorsCount(node)


proc minTransfers(data: Data): int =
  let you = data.ancestorsSet("YOU")
  let san = data.ancestorsSet("SAN")
  result = (you -+- san).card


let data = parseData()

benchmark:
  echo data.countOrbits
  echo data.minTransfers
