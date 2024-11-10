# Nombre del archivo de salida
OUT = a.out

# Nombre del archivo de resultados
RESULTS = resultados.vcd

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



# Objetivo para síntesis (ajustar si es necesario)
synth: $(SRC) sintesis.ys
	yosys sintesis.ys
	iverilog -o $(OUT) testbench_synth.v
	$(VVP)
	$(GTKWAVE)
