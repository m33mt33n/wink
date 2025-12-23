#┌───────────────────────────────────────────────────────────────────────────┐
#  File           wink.nim
#  Description    A library with CLI exposing functionality to blink
#                 Android screen.
#  Version        0.1.0 alpha
#  Author         Moin Khan <m33mt33n>
#  Source         https://github.com/m33mt33n/wink
#  License        GNU General Public License v3.0 or later (see LICENSE)
#  Created        December 24, 2025 01:15
#  Last Updated   December 24, 2025 02:45
#└───────────────────────────────────────────────────────────────────────────┘

import os
import strutils

const
  DEVICE = "/sys/class/leds/lcd-backlight/brightness"


proc wink(count:int=1, delay_ms:int=200): int =
  ## Blinks the Android screen
  ##
  ## Arguments:
  ##   count: number of times to blink thescreen
  ##   delay_ms: delay between blinks in milliseconds
  if not file_exists(DEVICE):
    return 2
  let
    level_orig = readfile(DEVICE).strip()
    #level_high = "255"
    level_high = level_orig
    level_low = "0"
  for i in 0..<count:
    try:
      writefile(DEVICE, level_low)
      sleep(100)
      writefile(DEVICE, level_high)
      sleep(100)
      if i < count-1:
        sleep(delay_ms)
    except OSError:
      return 1
  try:
    writefile(DEVICE, level_orig)
  except OSError:
    return 1
  return 0


when is_main_module:
  import tables
  import strformat
  import clapfn

  const prog = "wink"
  var parser = ArgumentParser(
    program_name: prog,
    description: "Blink android screen",
    version: "0.1.0-alpha (24.12.2025)",
  )
  parser.add_store_argument(
    "-c", "--count", usage_input="int", default="1",
    help="number of blinks",
  )
  parser.add_store_argument(
    "-d", "--delay", usage_input="int", default="200",
    help="delay between blinks in milliseconds",
  )
  let args = parser.parse()
  var sink = init_table[string, int]()
  for key, val in args:
    try:
      sink[key] = parse_int(val)
    except ValueError:
      echo(fmt"{prog}: invalid arguments: {val}")
      quit(1)
  let rcode = wink(count=sink["c"], delay_ms=sink["d"])
  if rcode == 2:
    echo(fmt"{prog}: unsupported device!")
  quit(rcode)
