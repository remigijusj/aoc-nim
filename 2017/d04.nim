# Advent of Code 2017 - Day 4

import std/[strutils,sequtils,algorithm]

type
  Pass = seq[string]
  Data = seq[Pass]


proc parseData: Data =
  readAll(stdin).strip.splitLines.mapIt(it.splitWhitespace)


func valid1(pass: Pass): bool =
  pass.deduplicate.len == pass.len


func valid2(pass: Pass): bool =
  pass.mapIt(it.sorted).deduplicate.len == pass.len


let data = parseData()

echo data.countIt(it.valid1)
echo data.countIt(it.valid2)
