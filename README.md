# Wink
A library with CLI exposing functionality to blink Android screen.

# Installation
## Get prebuilt binary:
- A prebuilt binary is provided for ARM architecture in releases.

## Build you own:
- A unix like environment with gcc or musl-gcc is required.
  - if you want to use `gcc`
    - run `nimble install --passNim:'-d:release -d:strip --passL:-static' https://github.com/m33mt33n/wink`
    - will install library and build an static binary (don't use `--passL:-static` flag if you want dynamically linked binary).

  - if you want to use `musl-gcc`
    - run `nimble install --passNim:'-d:release -d:strip -d:musl' https://github.com/m33mt33n/wink`
    - will install library and build an static binary.

  - alternatively `git` could be used
    - run `git clone  https://github.com/m33mt33n/wink.git`
      - run `cd wink && make wink-bin-static-glibc` if using `gcc`
      - run `cd wink && make wink-bin-static-musl` if using `musl-gcc`

# Usage
```text
v0.1.0-alpha (24.12.2025)
Blink android screen

Usage: wink [-h] [-v] [-d=int] [-c=int]

Required arguments:


Optional arguments:
   -h, --help           Show this help message and exit.
   -v, --version        Show version number and exit.
   -d=int, --delay=int  delay between blinks in ms
   -c=int, --count=int  number of blinks
```

# Examples
```shell
# wink screen a single time.
wink

# wink screen 3 times, wait for 1000 milliseconds between each blinking.
wink -c:3 -d:1000
```
