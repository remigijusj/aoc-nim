# Advent of Code 2017 - Day 11

import std/[strutils,sequtils]
import ../utils/common

type
  Hex = tuple[q, r, s: int]

  Dir = enum
    n, ne, se, s, sw, nw

  Data = seq[Dir]


func distance(hex: Hex): int =
  (hex.q.abs + hex.r.abs + hex.s.abs) div 2


proc parseData: Data =
  readInput().strip.split(",").map(parseEnum[Dir])


proc move(hex: var Hex, dir: Dir) =
  case dir
    of n:  hex.q.inc; hex.r.dec
    of ne: hex.q.inc; hex.s.dec
    of se: hex.r.inc; hex.s.dec
    of s:  hex.r.inc; hex.q.dec
    of sw: hex.s.inc; hex.q.dec
    of nw: hex.s.inc; hex.r.dec


func pathLast(data: Data): int =
  var hex: Hex
  for dir in data:
    hex.move(dir)
  result = hex.distance


func pathMax(data: Data): int =
  var hex: Hex
  for dir in data:
    hex.move(dir)
    let dist = hex.distance
    if dist > result: result = dist


let data = parseData()

benchmark:
  echo data.pathLast
  echo data.pathMax
