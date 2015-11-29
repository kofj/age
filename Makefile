all: drawin win linux
	@echo Build over.

drawin:
	@GOARCH=386 GOOS=darwin go build -ldflags "-w -s" -o ./bin/age.Darwin-i386 main.go
	@GOARCH=amd64 GOOS=darwin go build -ldflags "-w -s" -o ./bin/age.Darwin-x86_64 main.go

win:
	@GOARCH=386 GOOS=windows go build -ldflags "-w -s" -o ./bin/age.windows-i386.exe main.go
	@GOARCH=amd64 GOOS=windows go build -ldflags "-w -s" -o ./bin/age.windows-x86_64.exe main.go

linux:
	@GOARCH=386 GOOS=linux go build -ldflags "-w -s" -o ./bin/age.Linux-i386 main.go
	@GOARCH=amd64 GOOS=linux go build -ldflags "-w -s" -o ./bin/age.Linux-x86_64 main.go
