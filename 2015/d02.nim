# Advent of Code 2015 - Day 2

import std/[strscans,strutils,sequtils]
import ../utils/common

type
  Box = tuple[l, w, h: int]

  Data = seq[Box]


func parseBox(line: string): Box =
  assert line.scanf("$ix$ix$i", result.l, result.w, result.h)


proc parseData: Data =
  readAll(stdin).strip.splitLines.map(parseBox)


func wrappingPaper(box: Box): int =
  let sides = [box.l * box.w, box.l * box.h, box.w * box.h]
  result = 2 * sides.sum + sides.min


func ribbonLength(box: Box): int =
  let sides = [box.l + box.w, box.l + box.h, box.w + box.h]
  let volume = box.l * box.w * box.h
  result = 2 * sides.min + volume


let data = parseData()

benchmark:
  echo data.map(wrappingPaper).sum
  echo data.map(ribbonLength).sum
