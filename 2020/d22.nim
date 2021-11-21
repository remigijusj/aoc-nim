# Advent of code 2020 - Day 22

import strutils, sequtils, sets

type
  Game = array[2, seq[int]]

  Outcome = tuple[winner: int, cards: seq[int]]

proc readData(filename: string): Game =
  for part in readFile(filename).strip.split("\n\n"):
    let lines = part.splitLines
    if part.startsWith("Player 1"): result[0] = lines[1..^1].mapIt(it.parseInt)
    if part.startsWith("Player 2"): result[1] = lines[1..^1].mapIt(it.parseInt)


proc combat(game: Game, recursive = false): Outcome

proc playRound(game: var Game, recursive: bool): int =
  if recursive and game[0].len > game[0][0] and game[1].len > game[1][0]:
    let subgame = [game[0][1..game[0][0]], game[1][1..game[1][0]]]
    combat(subgame, recursive = true).winner
  else:
    if game[0][0] > game[1][0]: 0 else: 1


proc moveCards(game: var Game, winner: int) =
  game[winner].add(game[winner][0])
  game[winner].add(game[1-winner][0])
  game[0].delete(0..0)
  game[1].delete(0..0)


proc combat(game: Game, recursive = false): Outcome =
  var game = game
  var cache: HashSet[Game]
  while true:
    let winner =
      if cache.containsOrIncl(game):
        return (0, game[0])
      else:
        game.playRound(recursive = recursive)

    game.moveCards(winner)

    if game[1-winner].len == 0:
      return (winner, game[winner])


proc score(win: Outcome): int =
  for i, val in win.cards:
    result += val * (win.cards.len-i)


proc partOne(game: Game): int = game.combat.score
proc partTwo(game: Game): int = game.combat(recursive = true).score


let data = readData("inputs/22.txt")
echo partOne(data)
echo partTwo(data)
