# Advent of Code 2015 - Day 1

import std/[strutils]
import ../utils/common

type
  Data = string

  Result = tuple[level, below: int]


proc parseData: Data =
  readAll(stdin).strip


func simulate(data: Data): Result =
  for i, c in data:
    if c == '(':
      result.level.inc
    elif c == ')':
      result.level.dec

    if result.level < 0 and result.below == 0:
      result.below = i + 1


let data = parseData()
let (level, below) = data.simulate

benchmark:
  echo level
  echo below
