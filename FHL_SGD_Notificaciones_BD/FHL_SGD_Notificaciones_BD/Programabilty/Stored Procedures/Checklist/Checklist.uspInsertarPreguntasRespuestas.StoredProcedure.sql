USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Checklist].[uspInsertarPreguntasRespuestas]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






-- =============================================
-- Author:      NewlandApps
-- Create date: Agosto de 2023
-- Description: Inserta una lista de preguntas y respuestas pasados como parámetros en formato JSON
-- =============================================
CREATE PROCEDURE [Checklist].[uspInsertarPreguntasRespuestas]
    -- Add the parameters for the stored procedure here
	@ChecklistId						bigint = NULL,
    @ListaPreguntasRespuestas			VARCHAR(MAX) = NULL,
	@ListaRespuestas					VARCHAR(MAX) = NULL
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
    -- Variables de salida al ejecutar el SP
    DECLARE @Resultado  INT = 0;
    DECLARE @Mensaje    VARCHAR(MAX) = NULL;
	DECLARE @QuestionIdMap TABLE (IdPregunta bigint, RelacionId int); --Tabla en la cual guardaremos los Id insertados y su relación

	

	--1. Valida que se tenga una cadena de texto JSON con información
        IF @ListaPreguntasRespuestas IS NULL
            BEGIN
                SET @Resultado = -1;
                SET @Mensaje = 'El JSON esta vació';
                GOTO SALIDA;
            END;

	--2. Cambiar el eliminado de todas las preguntas y respuestas con el ChecklistId asociado 
	 -- Actualizar el eliminado de las preguntas
	
	UPDATE Checklist.PreguntasChecklist
    SET Eliminado = 0
    WHERE ChecklistId = @ChecklistId;

	-- Actualizar el eliminado de las respuestas
    UPDATE Checklist.RespuestasChecklist
    SET Eliminado = 0
    WHERE ChecklistId = @ChecklistId;

   --3. Craremos una tabla temp para poder revisar la información que nos esta llegando   
        CREATE TABLE #TablaTmp(
            
            Id							BIGINT, -- Identificador que se actualizará al momento de realizar la inserción de la información de cada registro          
            CheckListId					BIGINT,
            Nombre						VARCHAR(500),
            TipoCampo					INT,
            Categoria                   VARCHAR(500),
            GeneraFalla		            BIT,
            FotoRequerida	            BIT,
            Evidencia                   BIT,
			RelacionId					INT,
			Usuario						VARCHAR(150),
			Trail						VARCHAR(MAX),
        )
		
		Create TABLE #TableRespTemp(
			Id							BIGINT,
			CheckListId					BIGINT,
			PreguntaId					BIGINT,
			Nombre						VARCHAR(500),
			Ponderacion					INT,
			RelacionId					INT,
			Usuario						VARCHAR(150),
			Trail						VARCHAR(MAX),
		)

		
		--En la tabla temporal creada guardaremos la información de nuestro JSON
		INSERT INTO #TablaTmp(
			Id,
            CheckListId,
            Nombre,
            TipoCampo,
            Categoria,
            GeneraFalla,
            FotoRequerida,
            Evidencia,
			RelacionId,
			Usuario,
			Trail) SELECT * FROM OPENJSON(@ListaPreguntasRespuestas)
			WITH(
			Id							BIGINT, -- Identificador que se actualizará al momento de realizar la inserción de la información de cada registro          
            CheckListId					BIGINT,
            Nombre						VARCHAR(500),
            TipoCampo					INT,
            Categoria                   VARCHAR(500),
            GeneraFalla		            BIT,
            FotoRequerida	            BIT,
            Evidencia                   BIT,
			RelacionId					INT,
			Usuario						VARCHAR(150),			
			Trail						VARCHAR(MAX)
			);

			--En la tabla temporal creada guardaremos la información de nuestro JSON
		INSERT INTO #TableRespTemp(
			Id,
			CheckListId,
			PreguntaId,
			Nombre,
			Ponderacion,
			RelacionId,
			Usuario,
			Trail
			) SELECT * FROM OPENJSON(@ListaRespuestas)
			WITH(
			Id							BIGINT,
			CheckListId					BIGINT,
			PreguntaId					BIGINT,
			Nombre						VARCHAR(500),
			Ponderacion					INT,
			RelacionId					INT,
			Usuario						VARCHAR(150),
			Trail						VARCHAR(MAX)
			);

	--4. Ya con la información en una tabla temporal lo que haremos sera hacerle merge con la información que tenemos actualmente

	/*as target es la tabla a la que insertaremos o actualizaremos la información
	  as source es la tabla de la cual sacaremos la información*/
	MERGE INTO [Checklist].[PreguntasChecklist] AS TARGET
	USING #TablaTmp AS SOURCE
	--on se utiliza para hacer la condición de que si coinciden los Id de las tablas
	--se ejecturara el when matched cuando coincidan y when no matched cuando no
	ON TARGET.Id = SOURCE.Id
	WHEN MATCHED THEN
		UPDATE SET
			TARGET.Nombre = SOURCE.Nombre,
			TARGET.TipoCampo = SOURCE.TipoCampo,
			TARGET.Categoria = SOURCE.Categoria,
			TARGET.GeneraFalla = SOURCE.GeneraFalla,
			TARGET.FotoRequerida = SOURCE.FotoRequerida,
			TARGET.Evidencia = SOURCE.Evidencia,
			TARGET.Usuario = SOURCE.Usuario,
			TARGET.Eliminado = 1,
			TARGET.Trail = SOURCE.Trail	
	--Cuando no coincidan los Id se realizara un insert a la tabla
	WHEN NOT MATCHED THEN
		INSERT(ChecklistId, Nombre, TipoCampo, Categoria, GeneraFalla, FotoRequerida, Evidencia, Usuario, Eliminado, FechaCreacion, Trail)
		VALUES(SOURCE.ChecklistId ,SOURCE.Nombre, SOURCE.TipoCampo, SOURCE.Categoria, SOURCE.GeneraFalla, SOURCE.FotoRequerida, SOURCE.Evidencia, SOURCE.Usuario, 1, CURRENT_TIMESTAMP, Trail)
		OUTPUT inserted.Id, source.RelacionId INTO @QuestionIdMap (IdPregunta, RelacionId);



	--5.  Ahora que tenemos la información del id que se le dio a la pregunta 
		--Necesitamos modificarle el PreguntaId a las respuestas
		UPDATE TableResp
			SET TableResp.PreguntaId = QuestionIdMap.IdPregunta
			FROM #TableRespTemp AS TableResp
			JOIN @QuestionIdMap AS QuestionIdMap ON TableResp.RelacionId = QuestionIdMap.RelacionId
			WHERE TableResp.PreguntaId = 0;


	--6. Ya que tenemos las respuestas con su PreguntaId correcto lo que haremos sera insertar y actualizar en la tabla de respuestas preguntas
	/*as target es la tabla a la que insertaremos o actualizaremos la información
	  as source es la tabla de la cual sacaremos la información*/
	MERGE INTO [Checklist].[RespuestasChecklist] AS TARGET
	USING #TableRespTemp AS SOURCE
	--on se utiliza para hacer la condición de que si coinciden los Id de las tablas
	--se ejecturara el when matched cuando coincidan y when no matched cuando no
	ON TARGET.Id = SOURCE.Id
	WHEN MATCHED THEN
		UPDATE SET
			TARGET.Nombre = SOURCE.Nombre,
			TARGET.Ponderacion = SOURCE.Ponderacion,
			TARGET.Usuario = SOURCE.Usuario,
			TARGET.Eliminado = 1,
			TARGET.Trail = SOURCE.Trail	
	--Cuando no coincidan los Id se realizara un insert a la tabla
	WHEN NOT MATCHED THEN
		INSERT(ChecklistId, PreguntaId, Nombre, Ponderacion, Usuario, Eliminado, FechaCreacion, Trail)
		VALUES(SOURCE.ChecklistId, SOURCE.PreguntaId, SOURCE.Nombre, SOURCE.Ponderacion, SOURCE.Usuario, 1, CURRENT_TIMESTAMP, Trail);



	--7 Ahora eliminaremos los registros que ya no son necesarios en la base de datos:
		--Eliminamos las respuestas
		DELETE FROM [Checklist].[RespuestasChecklist]
		WHERE Eliminado = 0 AND ChecklistId = @ChecklistId;

		--Eliminamos las preguntas
		DELETE FROM Checklist.PreguntasChecklist
		WHERE Eliminado = 0 AND ChecklistId = @ChecklistId;

    -- 8. Recupera las estadisticas y la lista de mensajes para informar lo sucedido en la ejeción del SP
    SALIDA:
        -- Devuelve el resultado de la ejecución del SP junto con su respectivo mensaje
		
        SELECT			
			@Mensaje AS JsonSalida;

		DROP TABLE #TablaTmp;
		DROP TABLE #TableRespTemp;
END
GO
