# Advent of Code 2021 - Day 4

import std/[strutils, sequtils]

type
  Card = seq[int]

  Play = seq[bool]

  Data = object
    numbers: seq[int]
    cards: seq[Card]


proc parseCard(text: string): Card =
  result = text.splitWhitespace.mapIt(it.parseInt)


proc parseData(filename: string): Data =
  let parts = readFile(filename).strip.split("\n\n")
  result.numbers = parts[0].split(",").mapIt(it.parseInt)
  result.cards = parts[1..^1].mapIt(it.parseCard)


proc bingo(play: Play): bool =
  for row in 0..4:
    if toSeq(0..4).allIt(play[5*row+it]):
      return true
  for col in 0..4:
    if toSeq(0..4).allIt(play[5*it+col]):
      return true


proc sumUnmarked(card: Card, play: Play): int =
  for i, number in card:
    if not play[i]: result += number


proc playBingo(card: Card, numbers: seq[int]): tuple[index, score: int] =
  var play = newSeq[bool](card.len)
  for nidx, number in numbers:
    let cidx = card.find(number)
    if cidx < 0: continue
    play[cidx] = true
    if play.bingo:
      return (nidx, number * card.sumUnmarked(play))


proc winningScore(data: Data, pick: proc(x: openArray[int]): int): int =
  let results = data.cards.mapIt(it.playBingo(data.numbers))
  let index = results.mapIt(it.index).pick
  for res in results:
    if res.index == index: return res.score


proc partOne(data: Data): int = data.winningScore(min)
proc partTwo(data: Data): int = data.winningScore(max)


let data = parseData("inputs/04.txt")
echo partOne(data)
echo partTwo(data)
