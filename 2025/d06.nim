# Advent of Code 2025 - Day 6

import std/[strutils,sequtils]
import ../utils/common

type
  Data = seq[string]
  Problem = seq[string]


proc parseData: Data =
  readInput().strip(chars = {'\r','\n'}).splitLines


func getGaps(data: Data): seq[int] =
  for i in 0..<data[0].len:
    if data.allIt(it[i] == ' '):
      result.add(i)
  result.add(data[0].len)


func splitProblems(data: Data): seq[Problem] = 
  let gaps = data.getGaps
  var prev = -1
  for stop in gaps:
    let prob = data.mapIt(it[prev+1..<stop])
    result.add(prob)
    prev = stop


func calculate(nums: seq[int], op: string): int =
  if op == "+":
    result = nums.sum
  elif op == "*":
    result = nums.prod


func transpose(lines: seq[string]): seq[string] =
  result.setLen(lines[0].len)
  for i, line in lines:
    for j, c in line:
      result[j].add(c)


func answer1(lines: Problem): int =
  let op = lines[^1].strip
  let nums = lines[0..^2].mapIt(it.strip.parseInt)
  result = calculate(nums, op)


func answer2(lines: Problem): int =
  let op = lines[^1].strip
  let nums = lines[0..^2].transpose.mapIt(it.strip.parseInt)
  result = calculate(nums, op)


let data = parseData()

benchmark:
  let problems = data.splitProblems
  echo problems.map(answer1).sum
  echo problems.map(answer2).sum
