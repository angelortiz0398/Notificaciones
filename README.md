# Notificaciones
Repositorio creado para el almacenamiento de una solución que implementa servicios de notificaciones a partir de la WEB API de Twilio para la mensajería de Whatsapp, SMS y envio de correos electrónicos mediante SendGrid y para el caso de las Push Notification implemente FireBase, todo esto en el lenguaje de C#.
La solución consiste en varios proyectos de diferentes tipos y funciones. Primeramente, un proyecto de tipo WEB API que se encarga de validar si hay notificaciones habilitadas y crearlas. Además, de un proyecto hecho con .NET Framework 4.8.1 que se utiliza como servicio de Windows y que está consumiendo la WEB API cada cierto tiempo para saber si hay alguna notificación que alertar, este cuenta con su propio gestor de errores. También tiene varios proyectos que son del tipo librería de clases, el cual tiene toda la estructura del proyecto y diferencia las responsabilidades que tiene cada parte del mismo. 
La arquitectura del proyecto es por capas, al contar con una capa de modelo, de acceso a los datos (ADO.NET), de negocio y de servicio. Todo la solución tiene el patrón de diseño repository, el cual se usa para no repetir código en lo mayor posible.  
Es importante destacar que se esta usando una base de datos de tipo sql server y se utilizan stored procedures para crear, actualizar, obtener y eliminar información (Aunque no este implementado). 

# ¿Que se necesita para compilar el proyecto?
Se ocupa .NET 8 y NET Framework 4.8.1
https://dotnet.microsoft.com/es-es/download/visual-studio-sdks?cid=getdotnetsdk

# ¿Cómo crear la base de datos?
Abrir la solucion FHL_SGD_Notificaciones_BD, el cual contendrá todos los scripts para creación de tablas, usuario, stored procedures y esquemas que se necesitan. Colocar la cadena de conexión de una instancia sql server en la configuración del proyecto de modo que todos los scripts se ejecuten en ella. Después de crear la base de datos debemos obtener la cadena de conexión e integrar a la configuración de la aplicación de la WEB API (appsettings), en el apartado de ** ConnectionStrings.Default **

# ¿Cómo empezar a ambientar el proyecto y hacer pruebas con las notificaciones? 
1. Obtenemos las claves de usuario para el uso de los servicios proporcionados por Twilio, SendGrid y Firebase en los Web Services o en el API Rest.
Por obvias razones, estas van en los archivos de configuración de la aplicación “appsettings”, donde dependiendo el ambiente elegimos un ambiente u otro (Local, Development, Producción, etc). 
2. Configuramos las propiedades de depuración del proyecto, específicamente de FHL_SGD_Notificaciones_Api
           ![image](https://github.com/angelortiz0398/Notificaciones/assets/54503142/248e133d-759b-41da-883d-81ef69aab73c)
3. Dependiendo del ambiente qué elijamos llenamos con las apikey de los servicios, correos electrónicos, números de servicio e información privada. 
```JSON
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft": "Warning",
      "Microsoft.Hosting.Lifetime": "Information"
    }
  },
  "ConnectionStrings": {
    "Default": ""
  },
  "ApiURLS": {
    "AllowedHosts": "*",
    "Secret": "N2k8TCxNVHUxvYcFYTxeeZncZlNEyiVeZlSodfVCz8dNLlaW2kdVZk1B9ks8XudBhmax5wU3pN2KrlqSDApVsfIerLTeP40ZN2qS4sUPxYPOfwQ5fsgvHTpNScx8rxBw",
    "accountSid": "",
    "authToken": "",
    "numeroServicio": "",
    "SENDGRID_API_KEY": "",
    "FireBaseToken": "",
    "Email": ""
  }
}
```
Guardamos, limpiamos y compilamos toda la solución. Esto hará qué se copie este archivo en el directorio donde está el ejecutable de la WEB API. 

# ¿Cómo crear el servicio de windows después de compilar el proyecto?
Para ello creamos un archivo de texto en cualquier editor, le ponemos por ejemplo NotificacionesServiceInstall.bat 
Le damos a editar y luego colocamos esto en su interior:         
```Batchfile
@ECHO Installing Service...
@SET PATH=%PATH%;C:\Windows\Microsoft.NET\Framework\v4.0.30319\
@InstallUtil  C:\Users\Usuario\source\repos\FHL_SGD_Notificaciones\FHL_SGD_Notificaciones_Service\bin\Debug\FHL_SGD_Notificaciones_Service.exe
@ECHO Install Done.
@pause
```
Donde "@InstallUtil  C:\Users\Usuario\source\repos\FHL_SGD_Notificaciones\FHL_SGD_Notificaciones_Service\bin\Debug\FHL_SGD_Notificaciones_Service.exe" lo remplazaremos con la ubicacion donde se encuentre el ejecutable resultante de la compilacion de FHL_SGD_Notificaciones_Service. 

# Ejecutamos la WEB API de FHL_SGD_Notificaciones_Api
Para desplegar la API y qué pueda ser consumida por el servicio de windows. 

![image](https://github.com/angelortiz0398/Notificaciones/assets/54503142/79914c59-614e-4e15-aace-1e7d5a2cdcf2)

![image](https://github.com/angelortiz0398/Notificaciones/assets/54503142/715c89af-d211-49de-a08b-68caee3f606e)

# ¿Cómo ejecutar el servicio de windows y visualizar los registros de la aplicación?
Vamos a servicios de windows y buscamos “Servicio de notificacion SGD”, hacemos click derecho y le damos iniciar.
![image](https://github.com/angelortiz0398/Notificaciones/assets/54503142/cf9e4e09-e96d-4f06-8d78-e98a74164ce1)
Para ver los registros que van generando el servicio de windows y los logs de la api no vamos al visor de eventos. 
Abriremos en este orden:
1. Visor de eventos (Local)
   - Registros de aplicaciones y servicios
     -  Log
![image](https://github.com/angelortiz0398/Notificaciones/assets/54503142/90b0a107-cef3-4c1d-8071-7d1c68b6f270)

