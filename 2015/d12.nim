# Advent of Code 2015 - Day 12

import std/[strutils,tables,json]
import ../utils/common


proc parseData: JsonNode =
  readInput().strip.parseJson


func sumNumbers(node: JsonNode, skipRed: bool): int =
  case node.kind
  of JInt:
    result += node.num
  of JArray:
    for sub in node.elems:
      result += sub.sumNumbers(skipRed)
  of JObject:
    for sub in node.fields.values:
      result += sub.sumNumbers(skipRed)
      if skipRed and sub.kind == JString and sub.str == "red":
        return 0
  else:
    discard


let data = parseData()

benchmark:
  echo data.sumNumbers(false)
  echo data.sumNumbers(true)
