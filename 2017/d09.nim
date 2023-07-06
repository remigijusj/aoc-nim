# Advent of Code 2017 - Day 9

import std/[strutils,sequtils,tables]
import npeg

type
  Data = string

  Stream = object
    level, score, garbage: int


const streamParser = peg("group", s: Stream):
  anychar <- {' '..'~'}
  escaped <- '!' * anychar
  regular <- anychar - '>':
    s.garbage.inc
  garbage <- >('<' * *(escaped | regular) * '>')
  chunk <- garbage | group
  open <- '{':
    s.level.inc
  close <- '}':
    s.score += s.level
    s.level.dec
  group <- open * (chunk * *(',' * chunk) | 0) * close


proc parseData: Data =
  readAll(stdin).strip


proc parseStream(data: string): Stream =
  assert streamParser.match(data, result).matchLen == data.len


let data = parseData()
let stream = data.parseStream

echo stream.score
echo stream.garbage
