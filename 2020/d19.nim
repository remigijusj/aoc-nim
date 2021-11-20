# Advent of code 2020 - Day 19

import sequtils, strutils, tables, regex

type Data = object
  rules: Table[string, string]
  regex: Table[string, string]
  messages: seq[string]


proc compile(data: var Data, key: string): string =
  if key in data.regex:
    return data.regex[key]

  let rule = data.rules[key]
  if rule[0] == '"':
    data.regex[key] = rule[1..1]
    return data.regex[key]

  var pieces: seq[string]
  for alt in rule.split(" | "):
    pieces.add alt.split(" ").mapIt(data.compile(it)).join
  if pieces.len > 1:
    data.regex[key] = "(?:" & pieces.join("|") & ")"
  else:
    data.regex[key] = pieces[0]
  return data.regex[key]


proc readData(filename: string): Data =
  let parts = readFile(filename).split("\n\n")
  for line in parts[0].splitLines:
    let parts = line.split(": ", 2)
    result.rules[parts[0]] = parts[1]

  for line in parts[1].splitWhitespace:
    result.messages.add line

  discard result.compile("0")


proc partOne(data: Data): int =
  let regex = re(data.regex["0"])
  data.messages.countIt(it.match(regex))

proc partTwo(data: Data): int =
  var m: RegexMatch
  let regex = re("(" & data.regex["42"] & ")+(" & data.regex["31"] & ")+")
  data.messages.countIt(it.match(regex, m) and m.group(0, it).len > m.group(1, it).len)


let data = readData("inputs/19.txt")
echo partOne(data)
echo partTwo(data)
