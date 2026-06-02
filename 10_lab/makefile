.PHONY: all task1 clean asm1

CXX := clang++
FL := -fasm-blocks

ifeq ($(FPU), yes)
    FPU_FLAG := -m80387 -mfpmath=387
else
    FPU_FLAG := -mno-80387 -msse2 -mfpmath=sse
endif

task1:
	$(CXX) $(FL) $(FPU_FLAG) -m32 task1.cpp -o task1.exe

task2:
	$(CXX) $(FL) task2.cpp -o task2.exe

task3:
	$(CXX) $(FL) -m32 task3.cpp -o task3.exe

asm1:
	$(CXX) $(FL) $(FPU_FLAG) -S task1.cpp -o task1.s

clean:
	rm -f *.exe *.s
