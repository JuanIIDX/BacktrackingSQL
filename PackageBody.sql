----★★★★★★★Cuerpo★★★★★★★★
CREATE OR REPLACE PACKAGE BODY BACKTRACKING AS
----Funcion que se encarga de procesar el archivo de texto, recibe una posicion x, y, y el ID del archivo de texto
----en la base de datos
FUNCTION INICIO(X NUMBER,Y NUMBER,V_ID NUMBER) RETURN VARCHAR AS
BEGIN
   lista:= vector();
   laberinto := matriz();
   
   --Se lee el archivo de texto de archivos
   --El formato debe de ser 
   --
   --0,1,0,1
   --0,1,0,1
   --0,0,1,0
   --1,0,5,1
   --
   --Donde 0 es un espacio libre, 1 es una pared y 5 es la salida
   
   --Se guarda el archivo de texto en un varchar
   select utl_raw.cast_to_varchar2(dbms_lob.substr(archivo)) into matrizoriginal from archivos where ID = V_ID;

    ---Se rellena la matriz inicial por medio del archivo plano
    CONT1:=1;
    for I in (SELECT REGEXP_SUBSTR(matrizoriginal,  '[^'|| CHR(10) || ']+', 1, level) AS COL1 FROM dual CONNECT BY REGEXP_SUBSTR(matrizoriginal,  '[^'|| CHR(10) || ']+', 1, level) IS NOT NULL) loop
    CONT2:=1;
    lista:= vector();
    FOR J IN(SELECT regexp_substr(I.COL1, '[^,]+', 1, LEVEL) col2 FROM dual CONNECT BY regexp_substr(I.COL1, '[^,]+', 1, LEVEL) IS NOT NULL) LOOP
    lista.extend;
    lista(CONT2):=j.col2;
    CONT2:=CONT2+1;
    END LOOP;
    ANCHO:=CONT2;
    laberinto.extend;
    laberinto(CONT1):= lista;
    CONT1:=CONT1+1;
    end loop;
    ALTO:=CONT1-1;
    ANCHO:=CONT2-1;


    --Se corre el metodo
    T1:=BUSQUEDA_LABERINTO(X,Y);

    --Si se encuentra una solucion se pone 
    IF T1=TRUE THEN
        dbms_output.put_line('Se encontro solucion');
    ELSE
        dbms_output.put_line('No tiene solucion');
    END IF;
    

RETURN T1;
END INICIO;

--Funcion que busca por medio de backtracking una solucion, retorna true si la encuentra
FUNCTION BUSQUEDA_LABERINTO(X NUMBER,Y NUMBER) RETURN BOOLEAN AS

BEGIN

--1-si x,y fuera del laberinto retorna false
   if(x>4)or(x<=0)or(y>4)or(y<=0) then
    return false;
   end if;


--2-si x,y es estado final retorna true
    if(laberinto(x)(y)=5) then
        CONVIERTEVARCHAR();
        return true;
    end if;

--3-if (x,y no es abierto) retorna false
   if(laberinto(x)(y)=1 OR laberinto(x)(y)=2) then
      return false;
   end if;

--4-Marcar x,y como parte del camino solución
   laberinto(x)(y):=2;

--5-Si ENCONTRAR_CAMINO(Al Norte de x,y) true retorna true
  if(BUSQUEDA_LABERINTO(X,Y-1)=true) then
  
     return true;
     
  end if;

--6-si ENCONTRAR_CAMINO(Al Este de x,y) true retorna true
  if(BUSQUEDA_LABERINTO(X+1,Y)=true) then
     return true;
  end if;

--7-si ENCONTRAR_CAMINO(Al Sur de x,y) true retorna true
  if(BUSQUEDA_LABERINTO(X,Y+1)=true) then
     return true;
  end if;

--8-si ENCONTRAR_CAMINO(Al Oeste de x,y) true return true
  if(BUSQUEDA_LABERINTO(X-1,Y)=true) then
     return true;
  end if;

--9-desmarcar x,y como parte del camino solución
   laberinto(x)(y):=0;
   
--10-return false
   return false;

END BUSQUEDA_LABERINTO;

--Funcion para pruebas, imprime la matriz resultante
PROCEDURE CONVIERTEVARCHAR AS
BEGIN
        matrizTexto:='';
        dbms_output.put_line('Es el camino final');
        for i in laberinto.first..laberinto.last loop
            for j in 1..ANCHO loop
            matrizTexto:=matrizTexto||(laberinto(i)(j));
        end loop;
        matrizTexto:=matrizTexto||chr(10);
        end loop;
        
        dbms_output.put_line(matrizTexto);

END CONVIERTEVARCHAR;




END;
