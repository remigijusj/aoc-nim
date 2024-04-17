# Advent of Code 2018 - Day 2

import std/[strutils,sequtils,tables]
import ../utils/common

type Data = seq[string]


proc parseData: Data =
  readInput().strip.splitLines


func countChars(line: string): CountTable[char] =
  for c in line: result.inc(c)


func calcChecksum(data: Data): int =
  var twos, threes: int

  for line in data:
    let val = line.countChars.values.toSeq
    if 2 in val: twos.inc
    if 3 in val: threes.inc

  twos * threes


func difference(a, b: string): int =
  for k in 0 ..< a.len:
    if a[k] != b[k]:
      result.inc


func matchingChars(a, b: string): string =
  for k in 0 ..< a.len:
    if a[k] == b[k]:
      result.add(a[k])


func findCorrectPair(data: Data): string =
  for i in 0 ..< data.len:
    for j in 0 ..< i:
      let a = data[i]
      let b = data[j]
      if difference(a, b) == 1:
        return matchingChars(a, b)


let data = parseData()

benchmark:
  echo data.calcChecksum
  echo data.findCorrectPair
