# Advent of Code 2015 - Day 13

import std/[strscans,strutils,sequtils,algorithm]
import ../utils/common

const N = 8

type
  Item = tuple
    this, next: string
    change: int

  Data = seq[Item]

  Matrix = array[N, array[N, int]]


func parseItem(line: string): Item =
  var verb: string
  assert line.scanf("$+ would $+ $i happiness units by sitting next to $+.", result.this, verb, result.change, result.next)
  if verb == "lose":
    result.change = -result.change


proc parseData: Data =
  readAll(stdin).strip.splitLines.map(parseItem)


func buildMatrix(data: Data): Matrix =
  var names: seq[string]
  for (a, b, c) in data:
    if a notin names: names.add(a)
    if b notin names: names.add(b)
    let (ai, bi) = (names.find(a), names.find(b))
    result[ai][bi] = c


iterator permutations: seq[int] =
  var order = toSeq(0..<N)
  yield order
  while order.nextPermutation:
    yield order


proc optimalOrder(matrix: Matrix, score: proc(order: seq[int], matrix: Matrix): int): int =
  for order in permutations():
    let total = score(order, matrix)
    if total > result:
      result = total


func totalChange1(order: seq[int], matrix: Matrix): int =
  for i in 0..<N:
    result += matrix[order[i]][order[(i-1+N) mod N]]
    result += matrix[order[i]][order[(i+1) mod N]]


func totalChange2(order: seq[int], matrix: Matrix): int =
  for i in 0..<N:
    if i > 0:
      result += matrix[order[i]][order[i-1]]
    if i < N-1:
      result += matrix[order[i]][order[i+1]]


let data = parseData()
let matrix = data.buildMatrix

benchmark:
  echo matrix.optimalOrder(totalChange1)
  echo matrix.optimalOrder(totalChange2)
