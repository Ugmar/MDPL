run: build
	./main.exe

build:
	../../masm32/bin/ml.exe /c /coff main.asm
	../../masm32/bin/link.exe /SUBSYSTEM:WINDOWS main.obj

clean:
	rm -rf *.exe *obj
