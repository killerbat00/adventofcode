# Copyright 2022 Brian Houston Morrow
import std/[os, terminal, exitprocs, strutils]

const SNOWFLAKES = "❄ ❅ ❆"
const WELCOME = "Advent of Code 2022"

const LIGHTS = @[
"❄          ❄         ❄         ❄         ❄         ❄",
" ○         ○         ○         ○         ○        ○",
"   ○     ○   ○     ○   ○     ○   ○     ○   ○     ○",
"      ○         ○         ○         ○         ○"
]

const LIGHT_LEN = LIGHTS[0].len
const INTRO_LEN = SNOWFLAKES.len + WELCOME.len + SNOWFLAKES.len + 2

proc alternateColors(color1, color2: ForegroundColor, s1: string) =
  var i = 0
  for x in s1:
    let color = if i mod 2 == 0: color1 else: color2
    stdout.styledWrite(styleBright, color, $x)
    inc i

proc drawIntro(padding: int) =
  stdout.styledWrite(fgWhite, " ".repeat(padding) & SNOWFLAKES & " ", resetStyle)
  alternateColors(fgRed, fgGreen, WELCOME & " ")
  stdout.styledWrite(fgWhite, SNOWFLAKES, resetStyle, "\n")

proc drawLights(padding: int, hlRow: int) =
  var i = 0
  for x in LIGHTS:
    if i == hlRow:
      stdout.styledWrite(" ".repeat(padding), styleBright, fgRed, x.replace("○", "●"), resetStyle)
    else:
      stdout.styledWrite(" ".repeat(padding), styleDim, fgRed, x, resetStyle)
    stdout.write("\n")
    inc i

proc drawScreen(hlRow, lightPadding, introPadding: int) =
  stdout.setCursorPos(0, 0)
  drawIntro(introPadding)
  drawLights(lightPadding, hlRow)

proc cleanQuit() {.noconv.} =
  resetAttributes()
  stdout.showCursor()
  quit(0)

proc cleanUp() =
  resetAttributes()
  stdout.showCursor()

when isMainModule:
  exitprocs.addExitProc(cleanUp)
  setControlCHook(cleanQuit)

  let
    width = terminalSize()[0]
    halfWidth = width div 2
    lightMiddle = LIGHT_LEN div 2
    introMiddle = INTRO_LEN div 2

  if (halfWidth < lightMiddle) or (halfWidth < introMiddle):
    quit(1)

  let
    lightPadding = halfWidth - lightMiddle
    introPadding = halfWidth - introMiddle
  var hlRow = 0

  stdout.hideCursor()
  stdout.eraseScreen()

  while true:
    drawScreen(hlRow, lightPadding, introPadding)
    sleep(1000)
    hlRow = (hlRow + 1) mod 4
