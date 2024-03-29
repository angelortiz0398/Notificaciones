USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Checklist].[uspObtenerPreguntasConRespuestas]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		NewlandApps
-- Create date: Agosto de 2023
-- Description:	Obtiene la información del catálogo de Preguntas activos en un formato Json ligando sus respuestas asociadas
-- =============================================

CREATE PROCEDURE [Checklist].[uspObtenerPreguntasConRespuestas]
    @idChecklist bigint
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @JsonSalida NVARCHAR(MAX);

    SELECT @JsonSalida = (
        SELECT
            Preguntas.Id,
			Preguntas.CheckListId,
			Preguntas.Nombre,
			Preguntas.TipoCampo,
			Preguntas.Categoria,
			Preguntas.GeneraFalla,
			Preguntas.FotoRequerida,
			Preguntas.Evidencia,
			Preguntas.Usuario,
			Preguntas.Eliminado,
			Preguntas.FechaCreacion,
			Preguntas.Trail,
			
            JSON_QUERY((select * from Checklist.RespuestasChecklist
			where PreguntaId = Preguntas.Id and CheckListId = @idChecklist FOR JSON PATH)) AS Respuestas

        FROM Checklist.PreguntasChecklist Preguntas
		

        WHERE Preguntas.CheckListId = @idChecklist AND Preguntas.Eliminado = 1
		
        FOR JSON PATH
    );

    SELECT @JsonSalida AS JsonSalida;
END;
GO
