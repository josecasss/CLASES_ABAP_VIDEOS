CLASS zcl_10_itab_fcasas DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_10_itab_fcasas IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

*    "FOR"
*
*    TYPES: BEGIN OF lty_fligths,  "LOCAL TYPE " "Creando un tipo de estructura"
*             iduser     TYPE /dmo/customer_id,
*             aircode    TYPE /dmo/carrier_id,
*             flightnum     TYPE /dmo/connection_id,
*             key        TYPE land1,
*             seat       TYPE /dmo/customer_id,
*             flightdate TYPE /dmo/flight_date,
*           END OF lty_fligths.
*
*    DATA: gt_flights_info TYPE TABLE OF lty_fligths,
*          gt_my_flights   TYPE TABLE OF lty_fligths.
*
*
*    gt_my_flights = VALUE #( FOR i = 1 UNTIL i > 30
*                         ( iduser     = | { 0 + i } - USER |
*                           aircode    = 'LH'
*                           flightnum  = 0000 + i
*                           key        = 'US'
*                           seat       = 0 + i
*                           flightdate = cl_abap_context_info=>get_system_date( ) + i ) ).
*
*    out->write( data = gt_my_flights name = 'gt_my_fligths' ).
*    out->write( |\n| ).
*
*    " WHILE"
*
*    gt_flights_info = VALUE #( FOR i = 1 WHILE i <= 20
*                           ( iduser     = | { 1 + i } - USER |
*                             aircode    = 'LH'
*                             flightnum  = 0000 + i
*                             key        = 'US'
*                             seat       = 0 + i
*                             flightdate = cl_abap_context_info=>get_system_date( ) + i ) ).
*
*    out->write( data = gt_flights_info name = 'gt_fligths_info' ).
*
*    "FOR PARA RELLENAR TABLA"
*
*    gt_flights_info = VALUE #( FOR gs_my_flight IN gt_my_flights              " gs_my_flight no necestio declararlo, se crea ahi noma, osae declararlo con data"
*                            WHERE ( aircode = 'LH' and flightnum <= 000012 )
*                            ( iduser     =  gs_my_flight-iduser
*                              aircode    = gs_my_flight-aircode
*                              flightnum     = gs_my_flight-flightnum
*                              key        = gs_my_flight-key
*                              seat       = gs_my_flight-seat
*                              flightdate = gs_my_flight-flightdate ) ).
*
* out->write( data = gt_flights_info name = 'gt_flights_info' ).


    "FOR ANIDADO

*    TYPES: BEGIN OF lty_flights,
*             aircode     TYPE /dmo/carrier_id,
*             flightnum   TYPE /dmo/connection_id,
*             flightdate  TYPE /dmo/flight_date,
*             flightprice TYPE /dmo/flight_price,
*             currency    TYPE /dmo/currency_code,
*           END OF lty_flights.
*
*    SELECT FROM /dmo/flight
*    FIELDS *
*    INTO TABLE @DATA(gt_flights_type).
*
*    SELECT FROM /dmo/booking_m
*    FIELDS carrier_id, connection_id, flight_price, currency_code
*    INTO TABLE @DATA(gt_airline)
*    UP TO 20 ROWS.
*
*    DATA gt_final TYPE SORTED TABLE OF lty_flights WITH NON-UNIQUE KEY flightprice.       "Signfica que el campo flight price como es KEY-NONUNIQUE PUEDE TENER REGISTROS DUPLICADOS"
*
*    gt_final = VALUE #( FOR gs_flight_type IN gt_flights_type WHERE ( carrier_id = 'AA' )
*
*                        FOR gs_airline IN gt_airline WHERE ( carrier_id = gs_flight_type-carrier_id )
*
*                        ( aircode     = gs_flight_type-carrier_id
*                          flightnum   = gs_flight_type-connection_id
*                          flightdate  = gs_flight_type-flight_date
*                          flightprice = gs_airline-flight_price
*                          currency    = gs_airline-currency_code ) ).
*
*
*    out->write( data = gt_final name = 'gt_final' ).


    "AÑADIR MULTIPLES LINEAS (SELECT)

    "SELECT

*    SELECT FROM /dmo/flight  "Lectura de base de datos"
*    FIELDS *
*    WHERE carrier_id = 'LH'
*    INTO TABLE @DATA(gt_flights).  " @DATA crea la tabla interna en linea " "Es Standart, por que no estoy declarado el tipo de tabla que será explicitamente"

****Lectura de una tabla interna*

*    SELECT carrier_id, connection_id, flight_date "Seleccionar solo esos campos de la tabla gt_flight"
*    FROM @gt_flights AS gt "Referencia a mi tabla con @ que cree anteriormente y llamando todo ese conjunto de registros "gt" "
*    INTO TABLE @DATA(gt_flights_copy).

*    out->write( data = gt_flights name = 'gt_flights' ).
*    out->write( |\n| ).
*    out->write( data = gt_flights_copy name = 'gt_flights_copy' ).

    "SORT   "Se usa mas para Standart, ya que en tablas SORT se puede ordenar por KEY por defecto"

**** SORT gt_flights BY carrier_id connection_id flight_date. "Ordenando esos campos y por defecto se ordenan ascendentemente (Menor a Mayor)
*     SORT gt_flights BY carrier_id connection_id flight_date DESCENDING. "Descendente de (Mayor a menor).
**** SORT gt_flights BY carrier_id ASCENDING connection_id ASCENDING flight_date DESCENDING. "Especificando el orden de CADA UNO de los campos.
*    out->write( |\n| ).
*    out->write( data = gt_flights name = 'gt_flights' ).

    "MODIFY REGISTROS

*    out->write( data = gt_flights name = 'BEFORE MODIFY / gt_gt_flights'  ).

*    LOOP AT gt_flights INTO DATA(gs_flight). " Declarando dentro de una estructura"

*       IF  gs_flight-flight_date > '20250101'. " Si en la estructura gs_flight en el campo flight_date es mayor que esa fecha"

*            gs_flight-flight_date = cl_abap_context_info=>get_system_date( ).  " Aca lo va cambiar por la fecha del sistema actual"

       "OLD SYNTAXIS"
*****   MODIFY gt_flights FROM gs_flight INDEX 2.  " Aca se especifica en que index se hará ese cambio para esa condicion.
*****   MODIFY gt_flights FROM gs_flight TRANSPORTING flight_date.
       "NEW SYNTAXIS"
*        MODIFY gt_flights FROM VALUE #( connection_id = '111'
*                                        carrier_id    = 'XX'
*                                        plane_type_id = 'YY' ). "Si se cumple la condicion, hará estos cambios a estos campos, pero afectara los otros campos no especificados inicializandolos en 0."

*        MODIFY gt_flights FROM VALUE #( connection_id = '111'
*                                        carrier_id    = 'XX'
*                                        plane_type_id = 'YY' ) TRANSPORTING connection_id
*                                                                            carrier_id
*                                                                            plane_type_id. " Transporta solo los campos especificados, sin afectar los demas campos"
*
*       ENDIF.
*
*    ENDLOOP.

*    out->write( |\n| ).
*    out->write( data = gt_flights name = 'AFTER MODIFY / gt_gt_flights'  ).
    
    "DELETE
    
    SELECT FROM /dmo/airport
    FIELDS *
    WHERE country = 'US'
    INTO TABLE @DATA(gt_flights_struc). "DECLARACION EN LINEA TABLA INTERNA STANDART.
    
    IF sy-subrc = 0.
    
    out->write( data = gt_flights_struc name = 'BEFORE gt_flights_struc' ).
    
    LOOP AT gt_flights_struc INTO DATA(gs_flights_struc). "LECTURA DE LA TABLA INTERNA STANDART Y ALMACENADA EN LA ESTRUCTURA DECLARADA EN LINEA" 
    
    
    ENDLOOP.
    
    ENDIF.
