# Makefile para simulación y limpieza

# Variables
VFILES = testbench.v
RTLILFILES = testbench_rtlil.v
SYNTHFILES = testbench_synth.v
OUTFILE = a.out
VCDFILE = resultados.vcd
SYNTHESIS_SCRIPT = sintesis_rtlil.ys
SYNTH_SCRIPT = sintesis.ys
RTLIL_CONTROL = control_rtlil.v
SYNTH_CONTROL = control_synth.v

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

# Regla para la síntesis
synth:
	sudo yosys $(SYNTH_SCRIPT)
	sudo iverilog $(SYNTHFILES)
	sudo vvp $(OUTFILE)
	sudo gtkwave $(VCDFILE)

# Regla para limpiar archivos generados
clean:
	del $(OUTFILE) $(VCDFILE) || true
	rm -f $(OUTFILE) $(VCDFILE)

# Regla para limpiar archivos RTLIL específicos
clean-rtlil: clean
	del $(RTLIL_CONTROL) || true
	rm -f $(RTLIL_CONTROL)

# Regla para limpiar archivos Synth específicos
clean-synth: clean
	del $(SYNTH_CONTROL) || true
	rm -f $(SYNTH_CONTROL)

.PHONY: all conductual rtlil synth clean clean-rtlil clean-synth
