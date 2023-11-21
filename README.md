# OMICsBase
## OMICs Softwares Downloads and generic functions wrapped in R

Es necesario agregar una ruta de descarga por default que sirva para las distintas distribuciones!

### Requisitos
Los requisitos para descargar cada software es:
1. Tener Linux OS. Preferiblemente con distribucion Ubuntu.
2. Descargar con permiso SUDO las dependencias de Linux necesarias para cada software

### Estructura del Algoritmo de Descarga
La logica del codigo con las descargas de todos los softwares es la siguiente:

1. Chequear si ya esta descargado anteriormente

    - 1.1. En caso de estar descargado, ver si funciona el ejecutable

    - 1.2 En caso de no funcionar el ejecutable, elimina la carpeta completa con todos los archivos del software dentro

2. Si no esta descargado el ejecutable no funciona, descargar el software:

    - 2.1. Crear directorio con el nombre del Software

    - 2.2 Dentro del directorio descargar el paquete completo, generalmente comprimido en ZIP

    - 2.3 Descomprimir el ZIP y eliminar el archivo ZIP

    - 2.4 Comprobar que se hizo la instalacion correctamente ejecutando el comando de help del software 

    - 2.5 Guardar el PATH del ejecutable y guardarlo como variable global

3. Quedara guardado el path del ejecutable en una variable con el nombre del software, en el entorno global.


Los condicionales durante la descarga no se realizan con IF. Los condicionales se dan con la funcion 

`tryCatch(expr, error, warning, finally)`

Esto nos da versatilidad en cuanto a reconocer errores.

# Dudas a resolver

- Que path ponemos como input por default para las descargas de los softwares?
- Con respecto a las descargas de las referencias: Hago la descarga y el indexado por separado o en una misma funcion? El problema de hacerlo en una misma funcion es que estamos comprometiendo al usuario a tener que usar necesariamente un software especifico de alineacion. En MitoR usamos BWA, pero en RNA usamos STAR.
- Cuando importamos solamente 1 funcion de una libreria completa, se importan las librerias dependientes de la libreria completa? En caso de que no, vamos a tener que poner como dependencia de las librerias por debajo de esta aquellos paquetes necesarios para que se descarguen los softwares.
