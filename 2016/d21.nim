# Advent of Code 2016 - Day 21

import std/[strscans,strutils,sequtils,algorithm]
import ../utils/common

type
  RuleKind = enum
    swapPos, swapLetter, rotateLeft, rotateRight, rotatePos, reversePos, movePos

  Rule = object
    kind: RuleKind
    x, y: int
    a, b: char

  Data = seq[Rule]


const
  perm1 = [9, 1, 6, 2, 7, 3, 8, 4]


func parseRule(line: string): Rule =
  if line.scanf("swap position $i with position $i", result.x, result.y):
    result.kind = swapPos
  elif line.scanf("swap letter $c with letter $c", result.a, result.b):
    result.kind = swapLetter
  elif line.scanf("rotate left $i step", result.x):
    result.kind = rotateLeft
  elif line.scanf("rotate right $i step", result.x):
    result.kind = rotateRight
  elif line.scanf("rotate based on position of letter $c", result.a):
    result.kind = rotatePos
  elif line.scanf("reverse positions $i through $i", result.x, result.y):
    result.kind = reversePos
  elif line.scanf("move position $i to position $i", result.x, result.y):
    result.kind = movePos
  else:
    assert false


proc parseData: Data =
  readInput().strip.splitLines.map(parseRule)


func scramble(data: Data, origin: string): string =
  result = origin
  for rule in data:
    case rule.kind
    of swapPos:
      swap result[rule.x], result[rule.y]
    of swapLetter:
      result = result.multiReplace(($rule.a, $rule.b), ($rule.b, $rule.a))
    of rotateLeft:
      discard result.rotateLeft(rule.x)
    of rotateRight:
      discard result.rotateLeft(-rule.x)
    of rotatePos:
      let i = result.find(rule.a)
      let x = i + 1 + (if i >= 4: 1 else: 0)
      discard result.rotateLeft(-x)
    of reversePos:
      result.reverse(rule.x, rule.y)
    of movePos:
      if rule.x < rule.y:
        discard result.rotateLeft(rule.x..rule.y, 1)
      else:
        discard result.rotateLeft(rule.y..rule.x, -1)


func unscramble(data: Data, origin: string): string =
  result = origin
  for rule in data.reversed:
    case rule.kind
    of swapPos:
      swap result[rule.x], result[rule.y]
    of swapLetter:
      result = result.multiReplace(($rule.a, $rule.b), ($rule.b, $rule.a))
    of rotateLeft:
      discard result.rotateLeft(-rule.x)
    of rotateRight:
      discard result.rotateLeft(rule.x)
    of rotatePos:
      let j = result.find(rule.a)
      let x = perm1[j]
      discard result.rotateLeft(x)
    of reversePos:
      result.reverse(rule.x, rule.y)
    of movePos:
      if rule.x < rule.y:
        discard result.rotateLeft(rule.x..rule.y, -1)
      else:
        discard result.rotateLeft(rule.y..rule.x, 1)


let data = parseData()

benchmark:
  echo data.scramble("abcdefgh")
  echo data.unscramble("fbgdceah")
