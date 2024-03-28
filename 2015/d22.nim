# Advent of Code 2015 - Day 22

import std/[strutils,sequtils,deques]
import ../utils/common

type
  Player = tuple
    health, armor, mana: int

  Enemy = tuple
    health, damage: int

  Effect = tuple
    rounds, mana, damage, armor: int

  Spell = tuple
    cost, damage, heal, effect: int

  State = tuple
    self: Player
    boss: Enemy
    spent: int
    timers: array[3, int]

const
  effects: array[3, Effect] = [
    (6, 0, 0, 7),
    (6, 0, 3, 0),
    (5, 101, 0, 0),
  ]

  spells: array[5, Spell] = [
    ( 53, 4, 0, -1),
    ( 73, 2, 2, -1),
    (113, 0, 0, 0),
    (173, 0, 0, 1),
    (229, 0, 0, 2),
  ]


proc parseEnemy: Enemy =
  let parts = readAll(stdin).strip.splitLines.mapIt(it.split(": "))
  result = (parts[0][1].parseInt, parts[1][1].parseInt)


func won(state: State): bool {.inline.} = state.boss.health <= 0
func lost(state: State): bool {.inline.} = state.self.health <= 0


proc runEffects(state: var State) {.inline.} =
  state.self.armor = 0
  for i, time in state.timers.mpairs:
    if time <= 0: continue
    time.dec
    let effect = effects[i]
    state.self.mana += effect.mana
    state.self.armor += effect.armor
    state.boss.health -= effect.damage


func castSpell(state: State, spell: Spell): State {.inline.} =
  result = state
  result.spent += spell.cost
  result.self.mana -= spell.cost
  result.self.health += spell.heal
  result.boss.health -= spell.damage
  if spell.effect >= 0:
    result.timers[spell.effect] = effects[spell.effect].rounds
  result.runEffects
  if result.won:
    return
  result.self.health -= max(1, result.boss.damage - result.self.armor)


func allowed(spell: Spell, state: State): bool {.inline.} =
  (spell.cost <= state.self.mana) and
    (spell.effect < 0 or state.timers[spell.effect] <= 0)


iterator simulateFight(self: Player, boss: Enemy, hard: bool): int =
  var queue: Deque[State] = [(self, boss, 0, [0, 0, 0])].toDeque
  while queue.len > 0:
    var state = queue.popFirst

    if hard:
      state.self.health -= 1
      if state.lost:
        continue

    state.runEffects
    if state.won:
      yield state.spent
      continue

    for spell in spells.filterIt(it.allowed(state)):
      let fight = state.castSpell(spell)
      if fight.lost:
        continue
      elif fight.won:
        yield fight.spent
      else:
        queue.addLast(fight)


func minCostToWin(self: Player, boss: Enemy, hard: bool): int =
  result = int.high
  for cost in simulateFight(self, boss, hard):
    if cost < result:
      result = cost


let self = (50, 0, 500)
let boss = parseEnemy()

benchmark:
  echo minCostToWin(self, boss, false)
  echo minCostToWin(self, boss, true)
