# Advent of Code 2022 - Day 13

import std/[strutils,json,algorithm]

type Data = seq[JsonNode]


proc parseData: Data =
  for line in readAll(stdin).splitLines:
    if line != "":
      result.add line.parseJson


func rightOrder(a, b: JsonNode): int =
  if a.kind == JInt and b.kind == JInt:
    return cmp(a.getInt, b.getInt)

  elif a.kind == JArray and b.kind == JArray:
    let ae = a.getElems
    let be = b.getElems
    for i in 0..<min(ae.len, be.len):
      let cmp = rightOrder(ae[i], be[i])
      if cmp != 0: return cmp
    return cmp(ae.len, be.len)

  elif a.kind == JInt and b.kind == JArray:
    return rightOrder(%*[a], b)

  elif a.kind == JArray and b.kind == JInt:
    return rightOrder(a, %*[b])


func rightIndicesSum(data: Data): int =
  for i in countup(0, data.len-1, 2):
    if rightOrder(data[i], data[i+1]) == -1:
      result.inc (i div 2) + 1


func decoderKey(data: Data): int =
  let (d1, d2) = (%*[[2]], %*[[6]])
  var data = data & d1 & d2
  data.sort(rightOrder)
  result = (data.find(d1) + 1) * (data.find(d2) + 1)


let data = parseData()

let part1 = data.rightIndicesSum
let part2 = data.decoderKey

echo part1
echo part2
