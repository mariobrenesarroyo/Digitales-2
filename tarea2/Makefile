# Makefile para simulación y limpieza

# Variables
VFILES = testbench.v
RTLILFILES = testbench_rtlil.v
OUTFILE = a.out
VCDFILE = resultados.vcd
SYNTHESIS_SCRIPT = sintesis_rtlil.ys

# Regla por defecto
all: conductual

# Regla para la simulación conductual
conductual:
	iverilog $(VFILES)
	vvp $(OUTFILE)
	gtkwave $(VCDFILE)

# Regla para la simulación RTLIL
rtlil:
	yosys $(SYNTHESIS_SCRIPT)
	iverilog $(RTLILFILES)
	vvp $(OUTFILE)
	gtkwave $(VCDFILE)

# Regla para limpiar archivos generados
clean:
	del $(OUTFILE) $(VCDFILE) || true
	rm -f $(OUTFILE) $(VCDFILE)

.PHONY: all conductual rtlil clean
