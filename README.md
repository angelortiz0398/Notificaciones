# FHL_SGD_Notificaciones
Repositorio creado para el almacenamiento de una solución que implementa servicios de notificaciones a partir de la WEB API de Twilio en el lenguaje de C#.
La solución consiste en varios proyectos de diferentes tipos y funciones. Primeramente, un proyecto de tipo WEB API que se encarga de validar si hay notificaciones habilitadas y crearlas. Además, de un proyecto hecho con .NET Framework 4.8.1 que se utiliza como servicio de Windows y que está consumiendo la WEB API cada cierto tiempo para saber si hay alguna notificación que alertar, este cuenta con su propio gestor de errores. También tiene varios proyectos que son del tipo librería de clases, el cual tiene toda la estructura del proyecto y diferencia las responsabilidades que tiene cada parte del mismo. 
La arquitectura del proyecto es por capas, al contar con una capa de modelo, de acceso a los datos (ADO.NET), de negocio y de servicio. Todo la solución tiene el patrón de diseño repository, el cual se usa para no repetir código en lo mayor posible.  
Es importante destacar que se esta usando una base de datos de tipo sql server y se utilizan stored procedures para crear, actualizar, obtener y eliminar informacion (Aunque no este implementado). 

# ¿Como crear el servicio de windows despues de compilar el proyecto?
Para ello creamos un archivo de texto en cualquier editor, le ponemos por ejemplo NotificacionesServiceInstall.bat 
Le damos a editar y luego colocamos esto en su interior: \n    
@ECHO Installing Service...
@SET PATH=%PATH%;C:\Windows\Microsoft.NET\Framework\v4.0.30319\
@InstallUtil  C:\Users\Usuario\source\repos\FHL_SGD_Notificaciones\FHL_SGD_Notificaciones_Service\bin\Debug\FHL_SGD_Notificaciones_Service.exe
@ECHO Install Done.
@pause

Donde "@InstallUtil  C:\Users\Usuario\source\repos\FHL_SGD_Notificaciones\FHL_SGD_Notificaciones_Service\bin\Debug\FHL_SGD_Notificaciones_Service.exe" lo remplazaremos con la ubicacion donde se encuentre el ejecutable resultante de la compilacion de FHL_SGD_Notificaciones_Service. 
