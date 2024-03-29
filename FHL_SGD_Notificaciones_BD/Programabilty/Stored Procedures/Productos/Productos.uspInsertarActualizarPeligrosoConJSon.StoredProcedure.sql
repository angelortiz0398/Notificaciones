USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Productos].[uspInsertarActualizarPeligrosoConJSon]    Script Date: 11/03/2024 02:11:12 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Productos].[uspInsertarActualizarPeligrosoConJSon] 
	@Json varchar(MAX) = NULL
    
    
AS

BEGIN
	-- Crea una tabla temporal para recuperar la información del JSON que se recibe como parámetro
	CREATE TABLE #TablaTmp(
		ClavePeligroso VARCHAR(50),
		Nombre VARCHAR(150),
		ClavePeligrosoSAT VARCHAR(50),
		Usuario VARCHAR(150),
        RegistroNuevo BIT DEFAULT 1
	)

	-- Inserta la información necesaria proveniente del JSON
	INSERT INTO #TablaTmp (ClavePeligroso, Nombre, ClavePeligrosoSAT, Usuario)
		SELECT * FROM OPENJSON (@Json)
			WITH
			(
				ClavePeligroso varchar(50),
				Nombre varchar(150),
				ClavePeligrosoSat VARCHAR(50),
				Usuario VARCHAR(150)
			)
    --se actualiza el campo para validar si el registro es nuevo para que se inserte en la tabla
    Update #TablaTmp set RegistroNuevo = 0
    FROM #TablaTmp
    Join Productos.Peligrosos on #TablaTmp.ClavePeligroso = Productos.Peligrosos.ClavePeligroso


	-- Inserta la información y complementa con campos con información predefinida
	INSERT INTO Productos.Peligrosos (ClavePeligroso, Nombre, ClavePeligrosoSAT, Usuario, Eliminado, FechaCreacion, Trail)
		SELECT
			ClavePeligroso,
			Nombre,
			ClavePeligrosoSAT,
			Usuario,
			1,
			CURRENT_TIMESTAMP,
			'[{"trail_system_user":"valentinbaltazar","trail_workstation":null,"trail_notes":"Alta de Registro","trail_timemark":"2023-07-14T14:36:11.481678-06:00"}]'
		FROM #TablaTmp
		WHERE RegistroNuevo = 1;

	-- Elimina la tabla temporal
	DROP TABLE #TablaTmp;
END
GO
