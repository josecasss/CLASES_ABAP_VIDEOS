CLASS zcl_09_itab_fcasas DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_09_itab_fcasas IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    "TIPOS

    "STANDART TABLE
    "INDEX Permite duplicados, búsqueda lenta O(n), ideal para acceso secuencial."
    DATA lt_flight_stand TYPE STANDARD TABLE OF /dmo/flight.
    DATA lt_flight_stan2 TYPE TABLE OF /dmo/flight. "Si no se especifica por defecto es STANDART."

    "SORTED TABLE
    "INDEX Ordenada, permite clave única o no única, búsqueda O(log n), útil para datos ordenados"

    DATA lt_flight_sort TYPE SORTED TABLE OF /dmo/flight WITH NON-UNIQUE KEY carrier_id.

    "HASHED TABLE
    "ALGORITMO Siempre con clave única, búsqueda O(1), óptima para acceso rápido por clave, no considera el orden"
    DATA lt_flight_hash TYPE HASHED TABLE OF /dmo/flight WITH UNIQUE KEY carrier_id.


***********

    "AÑADIR REGISTROS

    DATA: lt_employees TYPE STANDARD TABLE OF zem_employees,
          ls_employee  TYPE zem_employees.


    TYPES lty_employee LIKE lt_employees.

    lt_employees = VALUE #( (  id            = '0001'
                               first_name    = 'Jose'
                               last_name     = 'Casas'
                               email         = 'josecasasmejia97@gmail.com'
                               phone_number  = '932492312'
                               salary        = '3000.2'
                               currency_code = 'EUR'        )  ).

    out->write( lt_employees ).

    "Declaracion en linea con VALUE sin Asignacion # y insertar registros
    DATA(lt_employees2) = VALUE lty_employee( ( id            = '0001'
                                                first_name    = 'Jose'
                                                last_name     = 'Casas'
                                                email         = 'josecasasmejia97@gmail.com'
                                                phone_number  = '932492312'
                                                salary        = '3000.2'
                                                currency_code = 'EUR'        )

                                              ( id           = '0002'
                                               first_name    = 'Samira'
                                               last_name     = 'Casas'
                                               email         = 'samcasss@gmail.com'
                                               phone_number  = '932492312'
                                               salary        = '3200.5'
                                               currency_code = 'EUR'        )

                                              ( id           = '0003'
                                               first_name    = 'Paulina'
                                               last_name     = 'Sobik'
                                               email         = 'paulinasobik5@gmail.com'
                                               phone_number  = '932492312'
                                               salary        = '4000.8'
                                               currency_code = 'EUR'        )  ).


     out->write( lt_employees ).
     out->write( lt_employees2 ).


    "INSERTAR REGISTROS otra manera

    ls_employee-id            = '0001'.
    ls_employee-first_name    = 'Jose'.
    ls_employee-last_name     = 'Casas'.
    ls_employee-email         = 'josecasasmejia97@gmail.com'.
    ls_employee-phone_number  = '93271345'.
    ls_employee-salary        = '4000.67'.
    ls_employee-currency_code = 'USD'.

    INSERT ls_employee INTO TABLE lt_employees.

    out->write( lt_employees ).

    "INSERT VALUE  "MEJOR PRACTICA"

    INSERT VALUE #( id            = '0002'
                    first_name    = 'Josesito'
                    last_name     = 'Casas'
                    email         = 'josecasasmejia97@gmail.com'
                    phone_number  = '93271345'
                    salary        = '4000.67'
                    currency_code = 'USD'    ) INTO TABLE lt_employees.


    INSERT INITIAL LINE INTO TABLE lt_employees.  "Para poner un registro en blanco sin nada

    "INSERT ESPECIFICANDO INDICE  "INSERT MEJOR PRACTICA"

    INSERT VALUE #( id            = '0003'
                    first_name    = 'FREDDY'
                    last_name     = 'Casas'
                    email         = 'fcasas800@hotmail.com'
                    phone_number  = '91234545'
                    salary        = '10000.67'
                    currency_code = 'PEN'     ) INTO lt_employees INDEX 2. "Poner el indice 2 "INDEX"

    out->write( lt_employees ).

    "PASAR REGISTROS DE UNA TABLA INTERNA A OTRA

    INSERT LINES OF lt_employees INTO TABLE lt_employees2.

    "PASAR REGISTROS DE UNA TABLA INTERNA A OTRA HASTA UN INDICE INDICADO

    INSERT LINES OF lt_employees TO 1 INTO TABLE lt_employees2.

    "PASAR REGISTROS DE UNA TABLA INTERNA A OTRA CON INDICE DESDE-HASTA.

    INSERT LINES OF lt_employees FROM 2 TO 3 INTO TABLE lt_employees2.

    out->write( data = lt_employees name = 'Employee Table' ).
    out->write( |\n| ).
    out->write( data = lt_employees2 name = 'Employee Table 2' ).


    "APPEND SOLO EN STANDART, AÑADIR REGISTROS RECOMENDADO EN ITAB STANDART

    ls_employee-id            = '0001'.
    ls_employee-first_name    = 'Jose'.
    ls_employee-last_name     = 'Casas'.
    ls_employee-email         = 'josecasasmejia97@gmail.com'.
    ls_employee-phone_number  = '93271345'.
    ls_employee-salary        = '4000.67'.
    ls_employee-currency_code = 'USD'.

    APPEND ls_employee TO lt_employees.

    APPEND INITIAL LINE TO lt_employees.

    "SIEMPRE SE COLOCA EN LA ULTIMA POSICION, NO SE PUEDE ESPECIFICAR INDICE APPEND VALUE
    APPEND VALUE #( id = '0002'
                    first_name = 'Freddy'
                    last_name = 'Casas'
                    email = 'fcasas800@hotmail.com'
                    phone_number = '91212345'
                    salary = '78000.67'
                    currency_code = 'USD' ) TO lt_employees.

    out->write( data = lt_employees
                name = 'Employee Table' ).

    "CORRESPONDING

    TYPES: BEGIN OF  lty_flights,    " lty_ prefijo = Tipo de dato local (Local Type)"
             carrier     TYPE /dmo/carrier_id,
             connection  TYPE /dmo/connection_id, "AGREGAR _id"
             flight_date TYPE /dmo/flight_date,
           END OF lty_flights.

    DATA: gt_my_flights TYPE STANDARD TABLE OF lty_flights, "gt = GLOBAL itab   gs_ = Global Structure"
          gs_my_flight  TYPE lty_flights.

    SELECT FROM /dmo/flight
    FIELDS *
    WHERE currency_code = 'USD'
    INTO TABLE @DATA(gt_flights).

    "MOVE-CORRESPONDING
    "MOVE-CORRESPONDING gt_flights TO gt_my_flights.

    "CORRESPONDING # ( )       FUNCION MEJOR PRACTICA
    gt_my_flights = CORRESPONDING #( gt_flights ).

    "AÑADIR MAS REGISTROS, MANTENIENDO LOS ANTERIORES REGISTROS CON KEEP TARGET LINES.
    MOVE-CORRESPONDING gt_flights TO gt_my_flights KEEPING TARGET LINES.

    "OTRA FORMA DE AÑADIR REGISTROS CORRESPONDING FUNCION
    gt_my_flights = CORRESPONDING #( BASE ( gt_my_flights ) gt_flights ).

    "MAPEO = Ingresar registros cuando los campos no coinciden
    gt_my_flights = CORRESPONDING #( gt_flights MAPPING carrier = carrier_id connection = connection_id ).


    out->write( data = gt_flights name = 'gt_flights' ).
    out->write( |\n| ).
    out->write( data = gt_my_flights name = 'gt_my_flights' ).

    "READ TABLE with INDEX

    SELECT FROM /dmo/airport
    FIELDS *
    INTO TABLE @DATA(lt_flights).

    IF sy-subrc = 0.

      READ TABLE lt_flights INTO DATA(ls_flight) INDEX 1.

      out->write( data = lt_flights name = 'lt_flights' ).
      out->write( |\n| ).
      out->write( data = ls_flight name = 'ls_flights *Filtrando Primer indice*' ).


      READ TABLE lt_flights INTO DATA(ls_flight2) INDEX 2 TRANSPORTING airport_id city.
      out->write( |\n| ).
      out->write( data = ls_flight2 name = 'ls_flights2 *Filtrando 2 Segundo indice y Transportando los campos que quiero*' ).

      READ TABLE lt_flights ASSIGNING FIELD-SYMBOL(<lfs_flight>) INDEX 3. "Asigna los campos y valores en esa una variable < variable > con el indice 3"
      out->write( data = <lfs_flight> name = 'lfs_flights *Filtrando 3*' ).

      "NEW SINTAXIS"

      out->write( data = lt_flights name = 'lt_flights tabla interna' ).

      DATA(ls_data) = lt_flights[ 2 ].  "[ 2 ] numero de indice"
      out->write( |\n| ).
      out->write( data = ls_data name = 'lt_flights *Filtrando 2*' ).

      DATA(ls_data2) = VALUE #( lt_flights[ 20 ] OPTIONAL ). "OPTIONAL HACE QUE SE MUESTRE EL REGISTRO PERO SIN VALORES, PARA MANEJAR ERRORES"
      out->write( |\n| ).
      out->write( data = ls_data2 name = 'lt_flights *Filtrando 20*'  ). "NO EXISTE INDICE 20 Y CUANDO NO EXISTE NO IMPRIME NADA, *USO OPTIONAL ARRIBA*"

      DATA(ls_data3) = VALUE #( lt_flights[ 20 ] DEFAULT lt_flights[ 1 ] ). "DEFAULT HACE QUE SE MUESTRE EL REGISTRO DECLARADO SI EL NO EXISTE EL REGISTRO REQUERIDO"
      out->write( |\n| ).
      out->write( data = ls_data3 name = 'lt_flights *Filtrando 20*'  ). "NO EXISTE INDICE 20 Y CUANDO NO EXISTE NO IMPRIME NADA, *USO DEFAULT ARRIBA*"

    ENDIF.

    "READ TABLE CON KEY

    out->write( data = lt_flights name = 'lt_flights' ).
    out->write( |\n| ).
    READ TABLE lt_flights INTO DATA(ls_flight) WITH KEY city = 'Berlin'. "SIEMPRE PRIMER FILTRO SE ALMACENA"
    out->write( data = ls_flight name = 'ls_flight *Filtrando con KEY* ' ).

    "NUEVA SINTAXIS"

    DATA(ls_flight2) = lt_flights[ airport_id = 'SXF' ].
    out->write( |\n| ).
    out->write( data = ls_flight name = 'ls_flight2 *Filtrando con KEY* ' ).


    DATA(lv_flight) = lt_flights[ airport_id = 'SXF' ]-name.
    out->write( |\n| ).
    out->write( data = lv_flight name = 'ls_flight *Filtrando con KEY y retornar campo especifico* ' ).

    "READ TABLE WITH PRIMARY KEY

    DATA gt_flights_sort TYPE SORTED TABLE OF /dmo/airport "SORT= ORDENADO (alfabeticamente"
    WITH NON-UNIQUE KEY airport_id. "Aca se especifica que campo será el ordenado" "NON UNIQUE KEY PERMITE REGISTROS DUPLICADOS EN EL CAMPO DECLARADO"

    SELECT FROM /dmo/airport
    FIELDS *
    INTO TABLE @gt_flights_sort.

    READ TABLE gt_flights_sort INTO DATA(ls_flight3) WITH TABLE KEY airport_id = 'LAS'.
    out->write( data = gt_flights_sort  name = 'gt_flight_sort  SORT= ORDENADO (alfabeticamente)' ).
    out->write( |\n| ).
    out->write( data = ls_flight3 name = 'ls_flight3 *Filtrando con KEY ' ).

    "NEW SYNTAXIS"

    DATA(ls_flight4) = gt_flights_sort[ KEY primary_key airport_id = 'NRT' ].
    out->write( |\n| ).
    out->write( data = ls_flight4 name = 'ls_flight3 *Filtrando con KEY ' ).

    "LINE EXISTS

    DATA gt_flights TYPE STANDARD TABLE OF /dmo/flight.

    "MEJOR PRACTICA SELECT, CONSULTAS"
    SELECT *
    FROM /dmo/flight
    WHERE carrier_id = 'LH'
    INTO TABLE @gt_flights.

    IF sy-subrc = 0.  "Agregar esto en la nueva syntaxis  luego del line_exists"

      READ TABLE gt_flights WITH KEY connection_id = '0403' TRANSPORTING NO FIELDS.

      IF sy-subrc = 0. " SE USA USA ESTE IF Y ELSE PARA HACER VALIDACIONES DE REGISTROS"
        out->write( 'The flight exists in the database' ).
      ELSE.
        out->write( 'The flight does not exists in the database' ).
      ENDIF.

    ENDIF.

    "NEW SYNTAXIS"

    IF line_exists( gt_flights[ connection_id = '0403' ] ).

      out->write( 'The flight exists in the database' ).
    ELSE.
      out->write( 'The flight does not exists in the database' ).
    ENDIF.

  ENDIF.

ENDMETHOD.
ENDCLASS.
