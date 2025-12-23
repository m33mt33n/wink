
all: wink-bin-static-musl

wink-bin-static-glibc: src/wink.nim
	nim --out:wink -d:release --passL:-static -d:strip c src/wink.nim

wink-bin-static-musl: src/wink.nim
	nim --out:wink -d:release -d:musl -d:strip c src/wink.nim

clean:
	rm -f wink
