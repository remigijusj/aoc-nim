# Advent of code 2020 - Day 21

import std/[strutils, sequtils, sets, tables, algorithm]
import ../utils/common

type
  Item = object
    ingredients: HashSet[string]
    allergens: HashSet[string]

  Data = seq[Item]


proc parseItem(line: string): Item =
  let cont = line.find(" (contains ")
  result.ingredients = line[0..<cont].splitWhitespace.toHashSet
  result.allergens = line[cont+11..^2].split(", ").toHashSet


proc parseData: Data =
  readInput().strip.splitLines.map(parseItem)


proc combineAllergens(list: Data): Table[string, HashSet[string]] =
  for item in list:
    for a in item.allergens:
      if a in result:
        result[a] = result[a] * item.ingredients
      else:
        result[a] = item.ingredients


proc ingredientAllergens(list: Data): Table[string, string] =
  var a2is = list.combineAllergens
  while a2is.len > 0:
    let uniques = a2is.keys.toSeq.filterIt(a2is[it].card == 1)
    for a in uniques:
      let i = a2is[a].pop
      a2is.del(a)
      for ais in mvalues(a2is): ais.excl(i)
      result[i] = a



proc countSafeIngredients(list: Data): int =
  let i2a = list.ingredientAllergens
  for item in list:
    for i in item.ingredients:
      if not(i in i2a): result.inc


# sorted by allergen alphabetically
proc dangerousIngredients(list: Data): seq[string] =
  let i2a = list.ingredientAllergens
  result = i2a.keys.toSeq.sortedByIt(i2a[it])


var data = parseData()

benchmark:
  echo data.countSafeIngredients
  echo data.dangerousIngredients.join(",")
