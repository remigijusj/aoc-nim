# Advent of Code 2017 - Day 21

import std/[strutils,sequtils,tables]

type
  Data = seq[(string, string)]

  Rules = Table[string, string]

  Image = tuple
    size: int
    data: string

const
  start: Image = (3, ".#...####")
  flips   = {4: @[2, 3, 0, 1], 9: @[6, 7, 8, 3, 4, 5, 0, 1, 2]}.toTable
  rotates = {4: @[1, 3, 0, 2], 9: @[2, 5, 8, 1, 4, 7, 0, 3, 6]}.toTable


func parseRule(line: string): (string, string) =
  let parts = line.split(" => ")
  result = (parts[0].replace("/"), parts[1].replace("/"))


proc parseData: Data =
  readAll(stdin).strip.splitLines.map(parseRule)


proc change(line: var string, perm: seq[int]) =
  var orig = line
  for i in 0..<line.len:
    line[i] = orig[perm[i]]


iterator transforms(line: string): string =
  let (flip, rotate) = (flips[line.len], rotates[line.len])
  var s = line
  for _ in 0..3:
    yield s
    s.change(rotate)
  s.change(flip)
  for _ in 0..3:
    yield s
    s.change(rotate)


func buildRules(data: Data): Rules =
  for (source, target) in data:
    for key in source.transforms:
      result[key] = target


func enhance(image: Image, rules: Rules): Image =
  let step = if image.size mod 2 == 0: 2 else: 3
  let step1 = step + 1 # by rules
  let size = image.size div step
  result.size = size * step1
  result.data = newString(result.size * result.size)
  var key = newString(step * step)

  for ri in 0..<size:
    for ci in 0..<size:
      for k in 0..<step:
        let idx = (ri * step + k) * step * size + (ci * step)
        key[step*k ..< step*(k+1)] = image.data[idx ..< idx+step]

      let val = rules[key]

      for k in 0..<step1:
        let idx = (ri * step1 + k) * step1 * size + (ci * step1)
        result.data[idx ..< idx+step1] = val[step1*k ..< step1*(k+1)]


func repeatEnhancement(rules: Rules, steps: int): Image =
  result = start
  for i in 0..<steps:
    result = result.enhance(rules)


let data = parseData()
let rules = data.buildRules

echo rules.repeatEnhancement(5).data.count('#')
echo rules.repeatEnhancement(18).data.count('#')
