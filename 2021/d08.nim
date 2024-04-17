# Advent of Code 2021 - Day 8

import std/[strutils, sequtils, packedsets]
import ../utils/common

type
  Word = PackedSet[char]

  Display = object
    digits: seq[Word]
    four: seq[Word]

  Data = seq[Display]


proc parseDisplay(line: string): Display =
  let parts = line.split(" | ")
  result.digits = parts[0].split(" ").mapIt(it.toPackedSet)
  result.four = parts[1].split(" ").mapIt(it.toPackedSet)


proc parseData: Data =
  for line in readInput().strip.splitLines:
    result.add line.parseDisplay


proc countEasyWords(data: Data): int =
  let uniq = [2, 3, 4, 7]
  for display in data:
    let easy = display.four.countIt(it.card in uniq)
    result.inc(easy)


proc decodeDigits(digits: seq[Word]): array[10, Word] =
  for word in digits:
    case word.card
    of 2: result[1] = word
    of 3: result[7] = word
    of 4: result[4] = word
    of 7: result[8] = word
    else: continue

  let (r1, r4, d41) = (result[1], result[4], result[4] - result[1])
  for word in digits:
    case word.card
    of 5:
      if (word * r4).card == 2: result[2] = word
      if (word * r1).card == 2: result[3] = word
      if (word * d41).card == 2: result[5] = word
    of 6:
      if (word * d41).card == 1: result[0] = word
      if (word * r1).card == 1: result[6] = word
      if (word * r4).card == 4: result[9] = word
    else: continue


proc decodeFour(display: Display): int =
  let mapping = decodeDigits(display.digits)
  for word in display.four:
    let digit = mapping.find(word)
    assert digit >= 0
    result = result * 10 + digit


let data = parseData()

benchmark:
  echo data.countEasyWords
  echo data.mapIt(it.decodeFour).sum
