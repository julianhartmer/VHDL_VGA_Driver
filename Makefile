# Makefile automatically generated by ghdl
# Version: GHDL 0.33 (20150921) [Dunoon edition] - GCC back-end code generator
# Command used to generate this makefile:
# ghdl --gen-makefile --ieee=synopsys vga_controller_tb

GHDL=ghdl
GHDLFLAGS= --ieee=synopsys

# Default target
all: vga_controller_tb

# Elaboration target
vga_controller_tb: /usr/local/lib/gcc/x86_64-linux-gnu/4.9.3/vhdl//v93/std/textio.o /usr/local/lib/gcc/x86_64-linux-gnu/4.9.3/vhdl//v93/std/textio_body.o /usr/local/lib/gcc/x86_64-linux-gnu/4.9.3/vhdl//v93/synopsys/std_logic_1164.o /usr/local/lib/gcc/x86_64-linux-gnu/4.9.3/vhdl//v93/synopsys/std_logic_1164_body.o /usr/local/lib/gcc/x86_64-linux-gnu/4.9.3/vhdl//v93/synopsys/std_logic_textio.o vga_controller_tb.o /usr/local/lib/gcc/x86_64-linux-gnu/4.9.3/vhdl//v93/synopsys/numeric_std.o /usr/local/lib/gcc/x86_64-linux-gnu/4.9.3/vhdl//v93/synopsys/numeric_std-body.o vga_controller.o
	$(GHDL) -e $(GHDLFLAGS) $@

# Run target
run: vga_controller_tb
	$(GHDL) -r vga_controller_tb $(GHDLRUNFLAGS)

# Targets to analyze files
/usr/local/lib/gcc/x86_64-linux-gnu/4.9.3/vhdl//v93/std/textio.o: /usr/local/lib/gcc/x86_64-linux-gnu/4.9.3/vhdl//v93/std/../../src/std/textio.v93
	@echo "This file was not locally built ($<)"
	exit 1
/usr/local/lib/gcc/x86_64-linux-gnu/4.9.3/vhdl//v93/std/textio_body.o: /usr/local/lib/gcc/x86_64-linux-gnu/4.9.3/vhdl//v93/std/../../src/std/textio_body.v93
	@echo "This file was not locally built ($<)"
	exit 1
/usr/local/lib/gcc/x86_64-linux-gnu/4.9.3/vhdl//v93/synopsys/std_logic_1164.o: /usr/local/lib/gcc/x86_64-linux-gnu/4.9.3/vhdl//v93/synopsys/../../src/ieee/std_logic_1164.v93
	@echo "This file was not locally built ($<)"
	exit 1
/usr/local/lib/gcc/x86_64-linux-gnu/4.9.3/vhdl//v93/synopsys/std_logic_1164_body.o: /usr/local/lib/gcc/x86_64-linux-gnu/4.9.3/vhdl//v93/synopsys/../../src/ieee/std_logic_1164_body.v93
	@echo "This file was not locally built ($<)"
	exit 1
/usr/local/lib/gcc/x86_64-linux-gnu/4.9.3/vhdl//v93/synopsys/std_logic_textio.o: /usr/local/lib/gcc/x86_64-linux-gnu/4.9.3/vhdl//v93/synopsys/../../src/synopsys/std_logic_textio.vhdl
	@echo "This file was not locally built ($<)"
	exit 1
vga_controller_tb.o: vga_controller_tb.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
/usr/local/lib/gcc/x86_64-linux-gnu/4.9.3/vhdl//v93/synopsys/numeric_std.o: /usr/local/lib/gcc/x86_64-linux-gnu/4.9.3/vhdl//v93/synopsys/../../src/ieee/numeric_std.v93
	@echo "This file was not locally built ($<)"
	exit 1
/usr/local/lib/gcc/x86_64-linux-gnu/4.9.3/vhdl//v93/synopsys/numeric_std-body.o: /usr/local/lib/gcc/x86_64-linux-gnu/4.9.3/vhdl//v93/synopsys/../../src/ieee/numeric_std-body.v93
	@echo "This file was not locally built ($<)"
	exit 1
vga_controller.o: vga_controller.vhd
	$(GHDL) -a $(GHDLFLAGS) $<

# Files dependences
/usr/local/lib/gcc/x86_64-linux-gnu/4.9.3/vhdl//v93/std/textio.o: 
/usr/local/lib/gcc/x86_64-linux-gnu/4.9.3/vhdl//v93/std/textio_body.o:  /usr/local/lib/gcc/x86_64-linux-gnu/4.9.3/vhdl//v93/std/textio.o
/usr/local/lib/gcc/x86_64-linux-gnu/4.9.3/vhdl//v93/synopsys/std_logic_1164.o: 
/usr/local/lib/gcc/x86_64-linux-gnu/4.9.3/vhdl//v93/synopsys/std_logic_1164_body.o:  /usr/local/lib/gcc/x86_64-linux-gnu/4.9.3/vhdl//v93/synopsys/std_logic_1164.o
/usr/local/lib/gcc/x86_64-linux-gnu/4.9.3/vhdl//v93/synopsys/std_logic_textio.o:  /usr/local/lib/gcc/x86_64-linux-gnu/4.9.3/vhdl//v93/std/textio.o /usr/local/lib/gcc/x86_64-linux-gnu/4.9.3/vhdl//v93/synopsys/std_logic_1164.o /usr/local/lib/gcc/x86_64-linux-gnu/4.9.3/vhdl//v93/synopsys/std_logic_1164_body.o
vga_controller_tb.o:  /usr/local/lib/gcc/x86_64-linux-gnu/4.9.3/vhdl//v93/std/textio.o /usr/local/lib/gcc/x86_64-linux-gnu/4.9.3/vhdl//v93/std/textio_body.o /usr/local/lib/gcc/x86_64-linux-gnu/4.9.3/vhdl//v93/synopsys/std_logic_textio.o /usr/local/lib/gcc/x86_64-linux-gnu/4.9.3/vhdl//v93/synopsys/std_logic_1164.o
/usr/local/lib/gcc/x86_64-linux-gnu/4.9.3/vhdl//v93/synopsys/numeric_std.o:  /usr/local/lib/gcc/x86_64-linux-gnu/4.9.3/vhdl//v93/synopsys/std_logic_1164.o
/usr/local/lib/gcc/x86_64-linux-gnu/4.9.3/vhdl//v93/synopsys/numeric_std-body.o:  /usr/local/lib/gcc/x86_64-linux-gnu/4.9.3/vhdl//v93/synopsys/numeric_std.o
vga_controller.o:  /usr/local/lib/gcc/x86_64-linux-gnu/4.9.3/vhdl//v93/synopsys/std_logic_1164.o /usr/local/lib/gcc/x86_64-linux-gnu/4.9.3/vhdl//v93/synopsys/numeric_std.o /usr/local/lib/gcc/x86_64-linux-gnu/4.9.3/vhdl//v93/synopsys/numeric_std-body.o