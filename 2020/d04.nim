# Advent of code 2020 - Day 4

import std/[strutils, sequtils, re, tables]
import ../utils/common


type
  Key = enum
    byr, iyr, eyr, hgt, hcl, ecl, pid, cid

  Passport = Table[Key, string]

  Data = seq[Passport]


let rules = {
  byr: re"^19[2-9][0-9]|200[0-2]$",
  iyr: re"^(201[0-9]|2020)$",
  eyr: re"^(202[0-9]|2030)$",
  hgt: re"^((1[5-8][0-9]|19[0-3])cm|(59|6[0-9]|7[0-6])in)$",
  hcl: re"^#[0-9a-f]{6}$",
  ecl: re"^(amb|blu|brn|gry|grn|hzl|oth)$",
  pid: re"^[0-9]{9}$",
  cid: re"" # optional
}.toTable


proc parsePassport(record: string): Passport =
  for piece in record.findAll(re"\S{3}:\S+"):
    let key = parseEnum[Key](piece[0..2])
    result[key] = piece[4..^1]


proc parseData: Data =
  readInput().strip.split("\n\n").map(parsePassport)


proc validKeys(p: Passport): bool =
  p.len == 8 or (p.len == 7 and not p.hasKey(cid))


proc validValues(p: Passport): bool =
  result = true
  for key, val in p.pairs:
    if not val.match(rules[key]):
      return false


let data = parseData()

benchmark:
  echo data.countIt(it.validKeys)
  echo data.countIt(it.validKeys and it.validValues)
