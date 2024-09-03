# Definir el compilador de Verilog
SIM = iverilog

# Definir los archivos fuente
SRC1 = control_de_acceso.v
SRC2 = tester.v
SRC3 = testbench.v

# Definir los archivos de salida
OUT1 = a_tb
OUT2 = b_tb
OUT3 = c_tb

# Regla para compilar, ejecutar la simulación y abrir GTKWave
run: $(OUT1) $(OUT2) $(OUT3)
	$(SIM) -o acceso_tb.vvp $(SRC3)
	vvp acceso_tb.vvp
	gtkwave resultados.vcd

$(OUT1): $(SRC1)
	$(SIM) -o $(OUT1) $(SRC1)

$(OUT2): $(SRC2)
	$(SIM) -o $(OUT2) $(SRC2)

$(OUT3): $(SRC3)
	$(SIM) -o $(OUT3) $(SRC3)

# Regla para limpiar los archivos generados
clean:
	del $(OUT1) $(OUT2) $(OUT3) acceso_tb.vvp resultados.vcd
