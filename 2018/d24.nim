# Advent of Code 2018 - Day 24

import std/[strscans,strutils,sequtils,algorithm]

type
  Kind = enum
    immuneSys, infection

  Group = tuple
    index: int
    kind: Kind
    units, hitPoints, damage, init: int
    attack: string
    weak, immune: seq[string]

  Data = seq[Group]

  Hit = tuple
    source, target: int
    damage: int


func parseGroup(line: string, kind: Kind): Group =
  result.kind = kind

  var side: string
  assert line.scanf("$i units each with $i hit points $*with an attack that does $i $+ damage at initiative $i",
    result.units, result.hitPoints, side, result.damage, result.attack, result.init)

  if side.len > 0:
    for part in side[1..^3].split("; "):
      if part.startsWith("weak"):
        result.weak = part[8..^1].split(", ")
      if part.startsWith("immune"):
        result.immune = part[10..^1].split(", ")


proc parseData: Data =
  let parts = readAll(stdin).strip.split("\n\n")
  result &= parts[0].splitLines[1..^1].mapIt(it.parseGroup(immuneSys))
  result &= parts[1].splitLines[1..^1].mapIt(it.parseGroup(infection))
  for i in 0..<result.len:
    result[i].index = i


func effectivePower(group: Group, boost: int): int =
  group.units * (group.damage + (if group.kind == immuneSys: boost else: 0))


proc selectTargets(groups: Data, boost: int): seq[Hit] =
  let sorted = groups.sorted do (x, y: Group) -> int:
    result = cmp(y.effectivePower(boost), x.effectivePower(boost))
    if result == 0:
      result = cmp(y.init, x.init)

  for group in sorted:
    if group.units <= 0: continue

    var hits: seq[Hit]

    for other in groups:
      if other.units <= 0: continue
      if other.kind == group.kind: continue

      var damage = group.effectivePower(boost)
      if group.attack in other.immune: damage = 0
      if group.attack in other.weak: damage *= 2
      # skip if the target already picked, or no projected damage
      if not result.anyIt(it.target == other.index) and damage > 0:
        hits.add (group.index, other.index, damage)

    hits.sort do (x, y: Hit) -> int:
      result = cmp(y.damage, x.damage)
      if result == 0:
        result = cmp(groups[y.target].effectivePower(boost), groups[x.target].effectivePower(boost))
        if result == 0:
          result = cmp(groups[y.target].init, groups[x.target].init)

    if hits.len == 0: continue
    result.add(hits[0])

  # pre-sort for attack
  result.sort do (x, y: Hit) -> int:
    result = cmp(groups[y.source].init, groups[x.source].init)


proc attackTargets(groups: var Data, hits: seq[Hit], boost: int): int =
  for hit in hits:
    if groups[hit.target].units <= 0:
      continue

    var damage = groups[hit.source].effectivePower(boost)
    if groups[hit.source].attack in groups[hit.target].immune: damage = 0
    if groups[hit.source].attack in groups[hit.target].weak: damage *= 2

    let kills = damage div groups[hit.target].hitPoints
    groups[hit.target].units.dec(kills)
    if groups[hit.target].units < 0: groups[hit.target].units = 0
    result.inc(kills)


func remainingUnits(groups: Data): array[2, int] =
  for group in groups:
    if group.units > 0:
      result[group.kind.ord].inc(group.units)


func winningUnits(data: Data, boost: int = 0): array[2, int] =
  var groups = data
  while true:
    var hits = groups.selectTargets(boost)
    let kill = groups.attackTargets(hits, boost)
    result = groups.remainingUnits
    if kill == 0: break


func binarySearch(data: Data): int =
  var boost1 = 1
  while true:
    result = data.winningUnits(boost1)[1]
    if result == 0: break
    boost1 *= 2

  var boost0 = boost1 div 2
  while boost0 < boost1-1:
    let boost = (boost0 + boost1) div 2
    result = data.winningUnits(boost)[1]
    if result == 0:
      boost1 = boost
    else:
      boost0 = boost

  if result == 0:
    result = data.winningUnits(boost1)[0]
  else:
    result = data.winningUnits(boost0)[0]


let data = parseData()

echo data.winningUnits.max
echo data.binarySearch
