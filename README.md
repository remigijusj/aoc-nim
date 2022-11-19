# aoc-nim

Advent of Code in Nim

My goal is to build self-contained solutions (no external libs) using clean and concise code.

## Running scripts

All code compiles with the current (>= v1.6) Nim compiler, for example: `nim c -r d01`.

To run the solutions:
- years 2019-2021 just run dXX, which will read data file from input folder.
- years from 2022 feed input to stdin, e.g. `dXX < input/dXX.txt`, or use the helper script.
- to use data from clipboard: `pbpaste --lf | dXX`

Helper script to download puzzles/input data and run/test solutions:
```
bin/aoc command [day] [year]
```
Available commands (for the given day/year):
- p, puzzle - downloads the puzzle
- i, input - downloads the input data file
- t, template - copies the template as placeholder
- a, all - runs all 3 above commands
- r, run - compile and run the script
- x, check - compile and run the scipt, check is answers match saved data

Day and year are optional, default to current.
Download commands need the session.txt file to be present.

### Structure

`bin/aoc` is a helper tool to download puzzles & inputs, prepare template.
AoC session cookie is expected to be saved in the file `session.txt` (just the value).
Puzzle parsing depends on the [html2md](https://github.com/suntong/html2md) tool.

Sub-folders for each year contain:
- `puzzles` - description of AoC puzzles
- `inputs` - (my personal) input data
- `answers` - (my personal) solution answers
- solutions code
