# Advent of Code 2023 - Day 15

import std/[strutils,sequtils,strscans,tables]
import ../utils/common

type
  Data = seq[string]

  Item = tuple
    label: string
    lens: int

  Box = OrderedTable[string, int]

  Boxes = array[256, Box]


proc parseData: Data =
  readAll(stdin).strip.split(",")


func hash(line: string): int =
  for c in line:
    result = (result + c.ord) * 17 and 255


func parseItem(item: string): Item =
  assert item.scanf("$+=$i", result.label, result.lens) or item.scanf("$+-", result.label)


func initBoxes(data: Data): Boxes =
  for line in data:
    let item = line.parseItem
    let b = item.label.hash
    if item.lens > 0:
      result[b][item.label] = item.lens
    else:
      result[b].del(item.label)


func focusingPower(boxes: Boxes): int =
  for b, box in boxes:
    var slot = 0
    for lens in box.values:
      slot.inc
      result += (b+1) * slot * lens


let data = parseData()

benchmark:
  echo data.map(hash).sum
  echo data.initBoxes.focusingPower
