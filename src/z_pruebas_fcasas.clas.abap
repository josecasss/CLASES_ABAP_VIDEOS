CLASS z_pruebas_fcasas DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z_pruebas_fcasas IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

DATA gt_flights_sort2 TYPE SORTED TABLE OF /dmo/flight "SORT= ORDENADO (alfabeticamente"
     WITH UNIQUE KEY carrier_id. "Aca se especifica que campo será el ord

     SELECT FROM /dmo/flight
     FIELDS *
     INTO TABLE @gt_flights_sort2.

out->write( data = gt_flights_sort2  name = 'gt_flight_sort' ).
  ENDMETHOD.
ENDCLASS.
