# Nombre del archivo de salida
OUT = a.out

# Nombre del archivo de resultados
RESULTS = resultados.vcd

# Archivos fuente
SRC = testbench.v

# Comando para compilar
IVERILOG = iverilog -o $(OUT) $(SRC)

# Comando para ejecutar
VVP = vvp $(OUT)

# Comando para visualizar
GTKWAVE = gtkwave $(RESULTS)

# Detectar el sistema operativo
ifeq ($(OS),Windows_NT)
    RM = del
else
    RM = rm -f
endif

# Objetivo por defecto
run: $(OUT)
	$(VVP)
	$(GTKWAVE)

# Objetivo para compilar
$(OUT): $(SRC)
	$(IVERILOG)

# Objetivo para limpiar
clean:
	$(RM) $(OUT) $(RESULTS) cajero_synth.v cajero_rtlil.v

# Objetivo para RTLIL
rtlil:
	yosys sintesis_rtlil.ys
	iverilog testbench_rtlil.v
	$(VVP)
	$(GTKWAVE)

# Objetivo para síntesis
synth:
	yosys sintesis.ys
	iverilog testbench_synth.v
	$(VVP)
	$(GTKWAVE)
