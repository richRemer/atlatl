ASM=nasm
ASMFLAGS=-f elf64
LD=ld
LDFLAGS=
SOURCES=atlatl.asm zstr.asm zptrs.asm std.asm sys.asm
OBJECTS=$(SOURCES:.asm=.o)
EXECUTABLE=atlatl

all: $(SOURCES) $(EXECUTABLE)

clean:
	-rm -f *.o

$(EXECUTABLE): $(OBJECTS)
	$(LD) $(LDFLAGS) $(OBJECTS) -o $@

%.o: %.asm
	$(ASM) $(ASMFLAGS) $< -o $@
