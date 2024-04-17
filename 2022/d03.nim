# Advent of Code 2022 - Day 3

import std/[strutils,sequtils,setutils]
import ../utils/common

type Data = seq[string]


proc parseData: Data =
  readInput().strip.splitLines


func halves(item: string): seq[string] =
  item.toSeq.distribute(2).mapIt(it.join)


func threes(data: seq[string]): seq[seq[string]] =
  data.distribute(data.len div 3)


func intersect(group: seq[string]): char =
  group.mapIt(it.toSet).foldl(a * b).toSeq[0]


func priority(c: char): int =
  if c.isUpperAscii:
    c.ord - 'A'.ord + 27
  else:
    c.ord - 'a'.ord + 1


let data = parseData()

benchmark:
  echo data.mapIt(it.halves.intersect.priority).sum
  echo data.threes.mapIt(it.intersect.priority).sum
