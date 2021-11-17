# Advent of code 2020 - Day 16

import strutils, sequtils, strscans

# departure track: 33-197 or 203-957
type Rule = object
  field: string
  r1_from, r1_till, r2_from, r2_till: int

type Ticket = seq[int]

type Data = object
  rules: seq[Rule]
  ticket: Ticket
  nearby: seq[Ticket]


proc parseRule(line: string): Rule =
  discard line.scanf("$+: $i-$i or $i-$i", result.field, result.r1_from, result.r1_till, result.r2_from, result.r2_till)

proc parseTicket(line: string): Ticket = line.split(',').mapIt(it.parseInt)


proc readData(filename: string): Data =
  let parts = readFile(filename).split("\n\n")
  for line in parts[0].splitLines:
    result.rules.add(line.parseRule)

  result.ticket = parts[1].splitLines[^1].parseTicket

  for line in parts[2].splitLines[1..^1].filterIt(it.len > 0):
    result.nearby.add(line.parseTicket)


proc match(rule: Rule, val: int): bool {.inline.} =
  rule.r1_from <= val and val <= rule.r1_till or rule.r2_from <= val and val <= rule.r2_till


# sum ticket values not matching any rule
proc invalidValues(ticket: Ticket, rules: seq[Rule]): seq[int] =
  for val in ticket:
    if not rules.anyIt(it.match(val)):
      result.add(val)


proc nearbyInvalidValues(data: Data): seq[int] =
  for ticket in data.nearby:
    for val in ticket.invalidValues(data.rules):
      result.add val


proc unifyRules(list: var seq[set[int8]]) =
  var uniques: set[int8]
  while true:
    uniques = list.filterIt(it.card == 1).foldl(a + b)
    for idx, subset in list:
      if subset <= uniques: continue
      list[idx] = subset - uniques

    if uniques.len == list.len: break


proc rulesMatching(rules: seq[Rule], values: seq[int]): set[int8] =
  for ri, rule in rules:
    if values.allIt(rule.match(it)):
      result.incl(ri.int8)


proc inferFields(data: Data): seq[string] =
  var tickets: seq[Ticket] = data.nearby.filterIt(it.invalidValues(data.rules).len == 0)
  tickets.add(data.ticket)
  var matching: seq[set[int8]]
  for idx in 0..<data.ticket.len:
    matching.add data.rules.rulesMatching(tickets.mapIt(it[idx]))

  matching.unifyRules
  for subset in matching:
    result.add data.rules[subset.toSeq()[0]].field


proc departureValues(fields: seq[string], ticket: Ticket): seq[int] =
  for idx, field in fields:
    if field.startsWith("departure"):
      result.add ticket[idx]


proc partOne(data: Data): int = data.nearbyInvalidValues.foldl(a + b)
proc partTwo(data: Data): int = data.inferFields.departureValues(data.ticket).foldl(a * b)


let data = readData("inputs/16.txt")
echo partOne(data)
echo partTwo(data)
