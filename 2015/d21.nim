# Advent of Code 2015 - Day 21

import std/[strutils,sequtils,math]
import ../utils/common

type
  Player = tuple
    hit_points, damage, armor: int

  Item = tuple
    cost, damage, armor: int

const
  weapons: seq[Item] = @[(8, 4, 0), (10, 5, 0), (25, 6, 0), (40, 7, 0), (74, 8, 0)]
  armor: seq[Item] = @[(13, 0, 1), (31, 0, 2), (53, 0, 3), (75, 0, 4), (102, 0, 5), (0, 0, 0)] # optional
  rings: seq[Item] = @[(25, 1, 0), (50, 2, 0), (100, 3, 0), (20, 0, 1), (40, 0, 2), (80, 0, 3)]


proc parsePlayer: Player =
  let parts = readAll(stdin).strip.splitLines.mapIt(it.split(": "))
  result = (parts[0][1].parseInt, parts[1][1].parseInt, parts[2][1].parseInt)


func `+`(a, b: Item): Item = (a.cost + b.cost, a.damage + b.damage, a.armor + b.armor)


iterator shopForItems: Item =
  for w in weapons:
    for a in armor:
      yield(w + a)
      for r1 in rings:
        yield(w + a + r1)
        for r2 in rings:
          if r2 == r1: continue
          yield(w + a + r1 + r2)


func simulateFight(mine, boss: Player): bool =
  let mine_damage = max(1, mine.damage - boss.armor)
  let boss_damage = max(1, boss.damage - mine.armor)
  let mine_hits = ceilDiv(boss.hit_points, mine_damage)
  let boss_hits = ceilDiv(mine.hit_points, boss_damage)
  result = mine_hits <= boss_hits


func minCostToWin(boss: Player, hit_points: int): int =
  result = int.high
  for (cost, damage, armor) in shopForItems():
    let player = (hit_points, damage, armor)
    let wins = simulateFight(player, boss)
    if wins and cost < result:
      result = cost


func maxCostToLose(boss: Player, hit_points: int): int =
  result = 0
  for (cost, damage, armor) in shopForItems():
    let player = (hit_points, damage, armor)
    let wins = simulateFight(player, boss)
    if not wins and cost > result:
      result = cost


let boss = parsePlayer()

benchmark:
  echo minCostToWin(boss, 100)
  echo maxCostToLose(boss, 100)
