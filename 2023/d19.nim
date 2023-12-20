# Advent of Code 2023 - Day 19

import std/[strscans,strutils,sequtils,tables,deques]
import ../utils/common

type
  Rule = tuple
    cidx: int
    cond: Slice[int]
    send: string

  Workflow = seq[Rule]

  Part = array[4, int]

  Rules = Table[string, Workflow]

  Data = tuple
    rules: Rules
    parts: seq[Part]

  Combo = array[4, Slice[int]]


func parseRule(line: string): Rule =
  var cat, op: char
  var val: int
  if line.scanf("$c$c$i:$+", cat, op, val, result.send):
    result.cidx = "xmas".find(cat)
    assert result.cidx >= 0 and op in "<>"
    if op == '<':
      result.cond = 1..(val-1)
    else:
      result.cond = (val+1)..4000
  else:
    result.cidx = -1
    result.send = line


func parseWorkflow(line: string): tuple[name: string, flow: Workflow] =
  var rules: string
  assert line.scanf("$w{$+}", result.name, rules)
  result.flow = rules.split(",").map(parseRule)


func parsePart(line: string): Part =
  assert line.scanf("{x=$i,m=$i,a=$i,s=$i}", result[0], result[1], result[2], result[3])


proc parseData: Data =
  let chunks = readAll(stdin).strip.split("\n\n")
  result.rules = chunks[0].splitLines.map(parseWorkflow).toTable
  result.parts = chunks[1].splitLines.map(parsePart)


func accepted(rules: Rules, part: Part): bool =
  var name = "in"
  while name in rules:
    for rule in rules[name]:
      if rule.cidx < 0 or part[rule.cidx] in rule.cond:
        name = rule.send
        break

  assert name in "AR"
  return name == "A"


func rating(part: Part): int = part.sum

func volume(item: Combo): int = item.mapIt(it.len).foldl(a * b)

func `&`(x, y: Slice[int]): Slice[int] = max(x.a, y.a)..min(x.b, y.b)

func `-`(x, y: Slice[int]): Slice[int] =
  if x.a < y.a: return x.a..(y.a-1)
  if x.b > y.b: return (y.b+1)..x.b


const combinations: Combo = [1..4000, 1..4000, 1..4000, 1..4000]

func acceptable(rules: Rules, start: Combo): int =
  var queue = [(start, "in", 0)].toDeque
  while queue.len > 0:
    var (combo, name, ridx) = queue.popFirst
    if name in rules:
      let rule = rules[name][ridx]
      if rule.cidx < 0:
        queue.addLast (combo, rule.send, 0)
      else:
        let good = combo[rule.cidx] & rule.cond
        let rest = combo[rule.cidx] - rule.cond
        if good.len > 0:
          combo[rule.cidx] = good
          queue.addLast (combo, rule.send, 0)
        if rest.len > 0:
          combo[rule.cidx] = rest
          queue.addLast (combo, name, ridx+1)
    else:
      assert name in "AR"
      if name == "A":
        result += combo.volume


let (rules, parts) = parseData()

benchmark:
  echo parts.filterIt(rules.accepted(it)).map(rating).sum
  echo rules.acceptable(combinations)
