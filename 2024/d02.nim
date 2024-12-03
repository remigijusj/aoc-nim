# Advent of Code 2024 - Day 2

import std/[strutils,sequtils]
import ../utils/common

type
  Report = seq[int]

  Data = seq[Report]


proc parseData: Data =
  readInput().strip.splitLines.mapIt(it.split(" ").map(parseInt))


func delta(repo: Report): Report =
  var prev: int
  for i, this in repo:
    if i > 0:
      result.add(this - prev)
    prev = this


func safe(diff: Report): bool =
  diff.allIt(it in 1..3) or diff.allIt(-it in 1..3)


func dampenedSafe(repo: Report): bool =
  if repo.delta.safe:
    return true
  for i in 0..<repo.len:
    var repo = repo
    repo.delete(i..i)
    if repo.delta.safe:
      return true


let data = parseData()

benchmark:
  echo data.countIt(it.delta.safe)
  echo data.countIt(it.dampenedSafe)
