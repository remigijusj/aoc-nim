# Advent of Code 2018 - Day 15

import std/[strutils,sequtils,deques,sets,tables,algorithm]

type
  XY = tuple[x, y: int]

  Unit = object
    pos: XY
    kind: char
    ap, hp: int

  Data = object
    grid: seq[string]
    units: seq[Unit]


iterator neighbors(pos: XY): XY =
  yield (pos.x, pos.y-1)
  yield (pos.x-1, pos.y)
  yield (pos.x+1, pos.y)
  yield (pos.x, pos.y+1)


func dist(a, b: XY): int = abs(a.x - b.x) + abs(a.y - b.y)


func cmp(a, b: XY): int =
  result = cmp(a.y, b.y)
  if result == 0:
    result = cmp(a.x, b.x)


func cmp(a, b: Unit): int = cmp(a.pos, b.pos)


func alive(unit: Unit): bool = unit.hp > 0


proc parseData: Data =
  result.grid = readAll(stdin).strip.splitLines
  for y, line in result.grid:
    for x, c in line:
      if c in {'E','G'}:
        result.units.add Unit(kind: c, pos: (x, y), ap: 3, hp: 200)


# return nearest cells in range of enemy, and levels of visited cells
proc floodFill(me: Unit, data: Data): tuple[front: seq[XY], levels: Table[XY, int]] =
  var queue = [(0, me.pos)].toDeque
  result.levels = [(me.pos, 0)].toTable

  var nearest = int.high
  while queue.len > 0:
    let (dist, this) = queue.popFirst
    if dist > nearest: return

    for cell in this.neighbors:
      let obj = data.grid[cell.y][cell.x]
      if obj == '#' or obj == me.kind: continue
      if obj != '.': # enemy found
        nearest = dist
        result.front.add(this)
      elif cell notin result.levels:
        result.levels[cell] = dist+1
        queue.addLast((dist+1, cell))


proc backtrack(start: XY, levels: Table[XY, int]): HashSet[XY] =
  var front: HashSet[XY]
  result.incl(start)

  for level in countdown(levels[start]-1, 1):
    swap(front, result)
    result.clear()
    for cell in front:
      for next in cell.neighbors:
        if levels.getOrDefault(next) == level:
          result.incl(next)


proc move(me: var Unit, data: var Data) =
  # find target in range
  var (targets, levels) = me.floodFill(data)
  if targets.len == 0 or me.pos in targets: return
  targets.sort(cmp)
  let target = targets[0]

  # find cell next to me
  var neighbors = target.backtrack(levels).toSeq
  neighbors.sort(cmp)
  let next = neighbors[0]

  # move there
  data.grid[me.pos.y][me.pos.x] = '.'
  me.pos = next
  data.grid[me.pos.y][me.pos.x] = me.kind


proc attack(me: Unit, data: var Data) =
  # find adjacent enemies
  var enemies: seq[(int, Unit)]
  for i, unit in data.units:
    if unit.kind != me.kind and unit.alive and dist(unit.pos, me.pos) == 1:
      enemies.add((i, unit))

  # sort by hit points
  if enemies.len == 0: return
  enemies.sort do (a, b: (int, Unit)) -> int:
    result = cmp(a[1].hp, b[1].hp)
    if result == 0:
      result = cmp(a[1].pos, b[1].pos)

  # hit the enemy
  var eid = enemies[0][0]
  data.units[eid].hp.dec(me.ap)
  let enemy = data.units[eid]
  if enemy.hp <= 0: # bury dead
    data.grid[enemy.pos.y][enemy.pos.x] = '.'


func combatFinished(data: Data): bool =
  result = data.units.filterIt(it.alive).mapIt(it.kind).toHashSet.card == 1


func hitPointsLeft(data: Data): int =
  result = data.units.mapIt(it.hp).foldl(a + b, 0)


func combatOutcome(data: Data): tuple[score, dead: int] =
  var data = data
  var rounds = 0
  while not combatFinished(data):
    block round:
      data.units.sort(cmp)
      for i, unit in data.units.mpairs:
        if unit.alive:
          unit.move(data)
          unit.attack(data)
          if combatFinished(data) and i < data.units.len-1: break round
      rounds.inc

    result.dead += data.units.countIt(it.kind == 'E' and not it.alive)
    data.units.keepItIf(it.alive)

  result.score = rounds * data.hitPointsLeft


func combatOutcomeZeroElfDeaths(data: Data): int =
  var data = data
  for ap in 3..int.high:
    for unit in data.units.mitems:
      if unit.kind == 'E': unit.ap = ap

    let (score, dead) = data.combatOutcome
    if dead == 0: return score


let data = parseData()

echo data.combatOutcome[0]
echo data.combatOutcomeZeroElfDeaths
