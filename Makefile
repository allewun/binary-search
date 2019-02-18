build:
	swift build -c release -Xswiftc -static-stdlib && cp -f .build/release/binary-search /usr/local/bin/binary-search
