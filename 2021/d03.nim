# Advent of Code 2021 - Day 3

import std/[strutils, sequtils]
import ../utils/common

type Data = seq[string]

proc parseData: Data =
  readInput().strip.splitLines.toSeq


proc decideBit(data: Data, idx: int, majority: bool): char =
  let ones = data.countIt(it[idx] == '1')
  let moreOnes = (ones > data.len div 2) or (ones == data.len div 2 and data.len mod 2 == 0)
  result = if moreOnes == majority: '1' else: '0'


proc selectBits(data: Data, majority: bool): string =
  for idx in 0..<12:
    let bit = data.decideBit(idx, majority)
    result &= bit


proc selectIterated(data: Data, majority: bool): string =
  var data = data
  for idx in 0..<12:
    let bit = data.decideBit(idx, majority)
    data.keepItIf(it[idx] == bit)
    if data.len == 1: return data[0]


proc calcRating(data: Data, select: proc(data: Data, majority: bool): string): int =
  let one = data.select(true)
  let two = data.select(false)
  result = one.parseBinInt * two.parseBinInt


let data = parseData()

benchmark:
  echo data.calcRating(selectBits)
  echo data.calcRating(selectIterated)
