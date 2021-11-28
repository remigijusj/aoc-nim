import std/[httpclient, os, osproc, strformat, tempfiles, strutils, times]

type YearDay = tuple[year, day: int]

type Step = enum stP, stI, stT

proc getYearDay(args: seq[string]): YearDay =
  let time = now().utc
  let day  = if args.len > 0: args[0].parseInt else: time.monthday
  let year = if args.len > 1: args[1].parseInt else: time.year
  result = (year, day)


proc fetchAocPage(yd: YearDay, suffix: string = ""): string =
  let cookie = readFile("../session.txt")
  var client = newHttpClient()
  client.headers = newHttpHeaders({"Cookie": "session=" & cookie})
  result = client.getContent(fmt"https://adventofcode.com/{yd.year}/day/{yd.day}" & suffix)


# See https://github.com/suntong/html2md
proc parsePuzzle(page: string): string =
  let (temp, path) = createTempFile("pzl_", ".tmp")
  temp.write(page)
  temp.close
  result = execProcess("html2md -d adventofcode.com -s article --opt-code-block-style -i " & path)
  result = result.replace("<em>", "").replace("</em>", "").replace("\\-", "-")
  removeFile(path)


proc saveFile(data: string, yd: YearDay, folder: string) =
  if data == "":
    echo "No content, won't save: " & $(yd) & " " & folder
    return
  createDir(fmt"../{yd.year}/{folder}")
  writeFile(fmt"../{yd.year}/{folder}/{yd.day:02}.txt", data)


proc copyTemplate(yd: YearDay) =
  createDir(fmt"../{yd.year}")
  let target = fmt"../{yd.year}/d{yd.day:02}.nim"
  if fileExists(target):
    echo "Code file already exists"
  else:
    let code = readFile("template.nim")
      .replace("{year}", $(yd.year)).replace("{day}", $(yd.day)).replace("{day:02}", fmt"{yd.day:02}")
    writeFile(target, code)


proc prepAnswers(yd: YearDay) =
  createDir(fmt"../{yd.year}/answers")
  let target = fmt"../{yd.year}/answers/{yd.day:02}.txt"
  if not fileExists(target):
    writeFile(target, "")


proc printHelp() =
  echo "aoc a(all)|p(uzzle)|i(nput)|t(template) [day] [year]"


proc runSteps(yd: YearDay, steps: varargs[Step]) =
  for step in steps:
    case step:
    of stP: fetchAocPage(yd).parsePuzzle.saveFile(yd, "puzzles")
    of stI: fetchAocPage(yd, "/input").saveFile(yd, "inputs")
    of stT: copyTemplate(yd); prepAnswers(yd)


# DEBUG: echo readFile(fmt"cache/{yd.year}{yd.day:02}.htm").parsePuzzle
proc runCommand(args: seq[string]) =
  if args.len == 0:
    printHelp()
    return

  let cmd = args[0]
  let yd = getYearDay(args[1..^1])
  case cmd:
  of "a", "all":
    runSteps(yd, stP, stI, stT)
  of "p", "puzzle":
    runSteps(yd, stP)
  of "i", "input":
    runSteps(yd, stI)
  of "t", "template":
    runSteps(yd, stT)
  else:
    printHelp()


when isMainModule:
  try:
    runCommand(commandLineParams())
  except IOError as e:
    echo "ERROR: " & e.msg
