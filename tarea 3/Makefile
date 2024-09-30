# Makefile para compilar y ejecutar simulaciones Verilog

# Nombre del archivo de salida
OUT = a.out

# Nombre del archivo de resultados
RESULTS = resultados.vcd

# Comando para compilar
IVERILOG = iverilog -o $(OUT) testbench.v

# Comando para ejecutar
VVP = vvp $(OUT)

# Comando para visualizar
GTKWAVE = gtkwave $(RESULTS)

# Objetivo por defecto
run: $(OUT)
	$(VVP)
	$(GTKWAVE)

# Objetivo para compilar
$(OUT):
	$(IVERILOG)

# Objetivo para limpiar
clean:
	del $(OUT) $(RESULTS)
