ASM=nasm
ASMFLAGS=-f elf64
LD=ld
LDFLAGS=
SOURCES=atlatl.asm sys.asm mem.asm std.asm zstr.asm zptrs.asm
OBJECTS=$(SOURCES:.asm=.o)
EXECUTABLE=atlatl

all: $(SOURCES) $(EXECUTABLE)

clean:
	-rm -f *.o

$(EXECUTABLE): $(OBJECTS)
	$(LD) $(LDFLAGS) $(OBJECTS) -o $@

%.o: %.asm
	$(ASM) $(ASMFLAGS) $< -o $@
