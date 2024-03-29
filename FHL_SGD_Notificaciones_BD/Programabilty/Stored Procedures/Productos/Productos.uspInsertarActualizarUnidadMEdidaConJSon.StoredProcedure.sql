USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Productos].[uspInsertarActualizarUnidadMEdidaConJSon]    Script Date: 11/03/2024 02:11:12 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Productos].[uspInsertarActualizarUnidadMEdidaConJSon] 
	@Json varchar(MAX) = NULL
    
    
AS

BEGIN
-- Crea una tabla temporal para recuperar la información del JSON que se recibe como parámetro
	CREATE TABLE #TablaTmp(
		ClaveUnidadMedida VARCHAR(50),
		Nombre VARCHAR(150),
		ClaveUnidadSat VARCHAR(50),
		Usuario VARCHAR(150),
        RegistroNuevo BIT DEFAULT 1
	)

						-- Inserta la informacion proveniente del json
						INSERT  INTO #TablaTmp(ClaveUnidadMedida,Nombre,ClaveUnidadSat, Usuario)
                        SELECT * FROM OPENJSON(@Json)
                        WITH (
                            ClaveUnidadMedida varchar(50),
                        Nombre varchar(150),
                        ClaveUnidadSat VARCHAR(50),
                        Usuario VARCHAR(150)
                        )
                         --se actualiza el campo para validar si el registro es nuevo para que se inserte en la tabla
    Update #TablaTmp set RegistroNuevo = 0
    FROM #TablaTmp
    Join Productos.UnidadesMedidas on #TablaTmp.ClaveUnidadMedida = Productos.UnidadesMedidas.ClaveUnidadMedida
						-- Inserta la información y complementa con campos con información predefinida
    INSERT INTO Productos.UnidadesMedidas(ClaveUnidadMedida,Nombre,ClaveUnidadSAT, Usuario,Eliminado,FechaCreacion,Trail)
    SELECT
    ClaveUnidadMedida,
    Nombre,
    ClaveUnidadSAT,
    Usuario,
    1,
    CURRENT_TIMESTAMP,
    '[{"trail_system_user":"valentinbaltazar","trail_workstation":null,"trail_notes":"Alta de Registro","trail_timemark":"2023-07-14T14:36:11.481678-06:00"}]'
    From #TablaTmp
		WHERE RegistroNuevo = 1;

    	DROP TABLE #TablaTmp;

end
GO
