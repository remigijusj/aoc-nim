import std/[httpclient, os, osproc, strformat, tempfiles, strutils, times]

type
  YearDay = tuple[year, day: int]


proc getCmdOpts(arg: string): (string, string) =
  for c in arg:
    if c.isUpperAscii:
      result[1].add(c)
    else:
      result[0].add(c)


proc getYearDay(args: seq[string]): YearDay =
  let time = now().utc
  let cdir = lastPathPart(getCurrentDir())
  let day  = if args.len > 0: args[0].parseInt else: time.monthday
  var year = if args.len > 1: args[1].parseInt elif cdir.startsWith("20"): cdir.parseInt else: time.year
  if year < 2000: year = 2000 + year
  result = (year, day)


proc getPath(subpath: string): string =
  result = absolutePath("../" & subpath, getAppDir())


proc fetchAocPage(yd: YearDay, suffix: string = ""): string =
  let cookie = readFile(getPath("session.txt"))
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
  if data.len > 0:
    createDir(getPath(fmt"{yd.year}/{folder}"))
    writeFile(getPath(fmt"{yd.year}/{folder}/{yd.day:02}.txt"), data)
  else:
    echo "No content, won't save: " & $(yd) & " " & folder


proc copyTemplate(yd: YearDay) =
  createDir(getPath(fmt"{yd.year}"))
  let target = getPath(fmt"{yd.year}/d{yd.day:02}.nim")
  if fileExists(target):
    echo "Code file already exists"
  else:
    let code = readFile(getPath("bin/template.nim"))
      .replace("{year}", $(yd.year)).replace("{day}", $(yd.day)).replace("{day:02}", fmt"{yd.day:02}")
    writeFile(target, code)


proc prepAnswers(yd: YearDay) =
  createDir(getPath(fmt"{yd.year}/answers"))
  let answers = getPath(fmt"{yd.year}/answers/{yd.day:02}.txt")
  if not fileExists(answers):
    writeFile(answers, "0\n0\n")


proc compileProgram(yd: YearDay, opt: string) =
  echo fmt"Compiling d{yd.day:02}..."
  var options = ""
  if 'R' in opt: options &= " -d:release"
  if 'T' in opt: options &= " -d:timing"
  let outputs = execProcess(fmt"nim c{options} d{yd.day:02}.nim", getPath(fmt"{yd.year}"))
  if not contains(outputs, "[SuccessX]"):
    echo outputs


proc runProgram(yd: YearDay, clipboard = false): string =
  setCurrentDir(getPath(fmt"{yd.year}"))
  if yd.year in 2019..2021:
    execProcess(fmt"cmd /c d{yd.day:02}.exe")
  elif clipboard:
    execProcess(fmt"cmd /c pbpaste | d{yd.day:02}.exe")
  else:
    execProcess(fmt"cmd /c d{yd.day:02}.exe < inputs/{yd.day:02}.txt")


proc testAnswers(yd: YearDay) =
  let target = getPath(fmt"{yd.year}/answers/{yd.day:02}.txt")
  if not fileExists(target):
    echo "No answers file"; return
  if not fileExists(getPath(fmt"{yd.year}/d{yd.day:02}.exe")):
    echo "No program file"; return

  let answers = readFile(target).strip
  let current = runProgram(yd).strip
  echo (if answers == current: "OK" else: "Mismatch!\n[answers]\n" & answers & "\n[current]\n" & current)


proc printHelp() =
  echo """
Usage: aoc [pitcerxR] [day] [year]
  Command: p(uzzle) | i(nput) | t(emplate) | c(ompile) | e(xample) | r(un) | x(check)
  Options: R(elease) T(iming)
  Warning: "e" command doesn't work in years 2019-2021"""


# Steps are lowercase, Opts are uppercase
proc runSteps(steps: string, yd: YearDay, opts: string) =
  for step in steps:
    case step:
      of 'p': fetchAocPage(yd).parsePuzzle.saveFile(yd, "puzzles")
      of 'i': fetchAocPage(yd, "/input").saveFile(yd, "inputs")
      of 't': copyTemplate(yd); prepAnswers(yd)
      of 'c': compileProgram(yd, opts)
      of 'e': echo runProgram(yd, true)
      of 'r': echo runProgram(yd)
      of 'x': testAnswers(yd)
      else: discard


# DEBUG: echo readFile(fmt"cache/{yd.year}{yd.day:02}.htm").parsePuzzle
proc runCommands(args: seq[string]) =
  if args.len > 0:
    let (cmd, opt) = getCmdOpts(args[0])
    let yd = getYearDay(args[1..^1])
    runSteps(cmd, yd, opt)
  else:
    printHelp()


# Example: aoc pit 1 2019
when isMainModule:
  try:
    runCommands(commandLineParams())
  except IOError as e:
    echo "ERROR: " & e.msg
