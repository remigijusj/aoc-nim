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


# avoiding regex :(
proc findAnswer(page: string, start: int): (int, int) =
  let p1 = page.find("<p>Your puzzle answer was <code>", start)
  if p1 < 0: return
  let p2 = page.find("</code>", p1 + 32)
  if p2 < 0: return
  result = (p1 + 32, p2)


proc parseAnswers(page: string): string =
  let (s1, e1) = page.findAnswer(0)
  let a1 = if e1 > 0: page.substr(s1, e1-1) else: ""
  let (s2, e2) = page.findAnswer(e1)
  let a2 = if e2 > 0: page.substr(s2, e2-1) else: ""
  result = [a1, a2].join("\n")


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


proc prepAnswers(yd: YearDay) =
  createDir(getPath(fmt"{yd.year}/answers"))
  let target = getPath(fmt"{yd.year}/answers/{yd.day:02}.txt")
  if not fileExists(target):
    writeFile(target, "0\n0\n")


# Test given answers against saved file.
proc testAnswers(given: string, yd: YearDay): string =
  let target = getPath(fmt"{yd.year}/answers/{yd.day:02}.txt")
  if not fileExists(target):
    return "No answers file"

  let saved = readFile(target).strip
  let given = given.strip
  return (if given == saved: "OK" else: "-- SAVED --\n" & saved & "\n-- GIVEN --\n" & given)


proc writeAnswers(yd: YearDay) =
  let target = getPath(fmt"{yd.year}/answers/{yd.day:02}.txt")
  if not fileExists(target):
    echo "No answers file"; return
  if not fileExists(getPath(fmt"{yd.year}/d{yd.day:02}.exe")):
    echo "No program file"; return

  let current = runProgram(yd).strip & "\n"
  writeFile(target, current)


proc openBrowser(yd: YearDay) =
  let uri = fmt"https://adventofcode.com/{yd.year}/day/{yd.day}"
  discard execProcess("cmd /c start " & uri)


proc printHelp() =
  echo """
Usage: aoc [pitbcrxwaRT] [day] [year]
    pit - Puzzle,Input,Template download
    b   - open puzzle page in Browser
    cr  - Compile,Run program
    e   - Example run with data from clipboard (not in years 2019/21)
    x   - run program, compare with answers file
    w   - run program, Write to answers file
    a   - download Answers from website, compare with answers file
  Options: R(elease) T(iming) """


# Steps are lowercase, Opts are uppercase
proc runSteps(steps: string, yd: YearDay, opts: string) =
  for step in steps:
    case step:
      of 'b': openBrowser(yd)
      of 'p': fetchAocPage(yd).parsePuzzle.saveFile(yd, "puzzles")
      of 'i': fetchAocPage(yd, "/input").saveFile(yd, "inputs")
      of 't': copyTemplate(yd); prepAnswers(yd)
      of 'c': compileProgram(yd, opts)
      of 'e': echo runProgram(yd, true)
      of 'r': echo runProgram(yd)
      of 'x': echo runProgram(yd).testAnswers(yd)
      of 'w': writeAnswers(yd)
      of 'a': echo fetchAocPage(yd).parseAnswers.testAnswers(yd)
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
