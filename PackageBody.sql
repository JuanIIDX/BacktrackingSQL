--Paquete con los metodos para encontrar el camino en un laberinto

--★★★★★★★Paquete★★★★★★★
CREATE OR REPLACE PACKAGE BACKTRACKING AS
--Declaracion 

----Declaracion de los tipos
--vector que contiene una linea del laberinto
TYPE vector is varray(20) of varchar(2);
lista vector := vector();
--Matriz que contiene todas las lineas del laberinto
TYPE matriz IS VARRAY (20) OF vector;
laberinto matriz := matriz();

---Declaracion de las varibales
matrizoriginal VARCHAR(300);  --texto plano de la matriz ingresada
matrizTexto VARCHAR(300);     --texto plano de la matriz convertida

--Variables para los calculos
ANCHO NUMBER;
ALTO NUMBER;
--Contadores para los for
cont1 number;
cont2 number;

--Bandera para determinar errores
T1 BOOLEAN:=false;


END;


