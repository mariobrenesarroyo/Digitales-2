# Nombre del archivo de salida
OUT = a.out

# Nombre del archivo de resultados
RESULTS = prueba1.vcd

# Archivo fuente
SRC = tb.v

# Comando para compilar
IVERILOG = iverilog -o $(OUT) $(SRC)

# Comando para ejecutar
VVP = vvp $(OUT)

# Comando para visualizar
GTKWAVE = gtkwave $(RESULTS)

# Detectar el sistema operativo
ifeq ($(OS),Windows_NT)
    RM = del /f
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
	$(RM) $(OUT) $(RESULTS)

# Objetivo para RTLIL (ajustar si es necesario)
rtlil: $(SRC) sintesis_rtlil.ys
	yosys sintesis_rtlil.ys
	iverilog -o $(OUT) testbench_rtlil.v
	$(VVP)
	$(GTKWAVE)

# Objetivo para síntesis (ajustar si es necesario)
synth: $(SRC) sintesis.ys
	yosys sintesis.ys
	iverilog -o $(OUT) testbench_synth.v
	$(VVP)
	$(GTKWAVE)
