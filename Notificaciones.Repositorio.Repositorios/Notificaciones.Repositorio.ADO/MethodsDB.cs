
using System;
using System.Collections.Generic;
using System.Dynamic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Notificaciones.Repositorio.ADO
{
    public class MethodsDB
    {
        #region Clientes
        public const string QueryGetClientesByActivos = @"[Clientes].[spGetClientes]";
        public const string QueryInsertDestinatarios = @"[Clientes].[spInsertDestinatarios]";
        public const string QueryInsertClientes = @"[Clientes].[uspInsertaClientes]";
        public const string QueryInsertaTarifa = @"[Clientes].[spInsertarTarifa]";
        public const string QueryActualizarTarifa = @"[Clientes].[spActualizarTarifa]";
        public const string QueryObtenerCustodiasPaginado = @"[Clientes].[uspObtenerCustodiasPaginado]";
        public const string QueryObtenerTipoEmpaquesPaginado = @"[Clientes].[uspObtenerTipoEmpaquesPaginado]";
        public const string QueryObtenerSobrecargoPaginado = @"[Clientes].[uspObtenerSobrecargoPaginado]";
        public const string QueryObtenerRangoPaginado = @"[Clientes].[uspObtenerRangoPaginado]";
        public const string QueryObtenerTipoTarifaClientePaginado = @"[Clientes].[uspObtenerTiposTarifasClientesPaginado]";
        public const string QueryObtenerClientesPaginado = @"[Clientes].[uspObtenerClientesPaginado]";
        //------Nodo------
        public const string QueryEliminarNodo = @"[Clientes].[uspEliminarNodo]";
        public const string QueryInsertarActualizarNodos = @"[Clientes].[uspInsertarActualizarNodos]";
        public const string QueryObtenerNodos = @"[Clientes].[uspObtenerNodos]";
        //------Dias de entrega------
        public const string QueryEliminarDiaEntrega = @"[Clientes].[uspEliminarDiaEntrega]";
        public const string QueryInsertarActualizarDiasEntregas = @"[Clientes].[uspInsertarActualizarDiasEntregas]";
        public const string QueryObtenerDiasEntregas = @"[Clientes].[uspObtenerDiasEntregas]";
        //------Prioridades------
        public const string QueryEliminarPrioridad = @"[Clientes].[uspEliminarPrioridad]";
        public const string QueryInsertarActualizarPrioridades = @"[Clientes].[uspInsertarActualizarPrioridades]";
        public const string QueryObtenerPrioridades = @"[Clientes].[uspObtenerPrioridades]";
        //------Tipos de peso------
        public const string QueryEliminarTipoPeso = @"[Clientes].[uspEliminarTipoPeso]";
        public const string QueryInsertarActualizarTiposPesos = @"[Clientes].[uspInsertarActualizarTiposPesos]";
        public const string QueryObtenerTiposPesos = @"[Clientes].[uspObtenerTiposPesos]";
        //------Tipos------
        public const string QueryEliminarTipoServicio = @"[Clientes].[uspEliminarTipoServicio]";
        public const string QueryInsertarActualizarTiposServicios = @"[Clientes].[uspInsertarActualizarTiposServicios]";
        public const string QueryObtenerTiposServicios = @"[Clientes].[uspObtenerTiposServicios]";
        //------Tipos de tarifa------
        public const string QueryEliminarTipoTarifa = @"[Clientes].[uspEliminarTipoTarifa]";
        public const string QueryInsertarActualizarTiposTarifas = @"[Clientes].[uspInsertarActualizarTiposTarifas]";
        public const string QueryObtenerTiposTarifas = @"[Clientes].[uspObtenerTiposTarifas]";
        //------Tipos de tarifa cliente------
        public const string QueryEliminarTipoTarifaCliente = @"[Clientes].[uspEliminarTipoTarifaCliente]";
        public const string QueryInsertarActualizarTiposTarifasClientes = @"[Clientes].[uspInsertarActualizarTiposTarifasClientes]";
        public const string QueryObtenerTiposTarifasClientes = @"[Clientes].[uspObtenerTiposTarifasClientes]";

		//------Clientes------
		public const string QueryObtenerClientes = @"[Clientes].[uspObtenerClientes]";
		public const string QueryEliminarCliente = @"[Clientes].[uspEliminarCliente]";
		public const string QueryInsertarActualizarClientes = @"[Clientes].[uspInsertarActualizarClientes]";
		//------Custodia------
		public const string QueryObtenerCustodiasCliente = @"[Clientes].[uspObtenerCustodias]";
		public const string QueryEliminarCustodiaCliente = @"[Clientes].[uspEliminarCustodia]";
		public const string QueryInsertarActualizarCustodiasCliente = @"[Clientes].[uspInsertarActualizarCustodias]";
		public const string QueryInsertarActualizarRevivirCustodias = @"[Clientes].[uspInsertarActualizarRevivirCustodias]";
		//------Consideraciones Viajes-----
		public const string QueryObtenerConsideracionesViajes = @"[Clientes].[uspObtenerConsideracionesViajes]";
		public const string QueryEliminarConsideracionViaje = @"[Clientes].[uspEliminarConsideracionViaje]";
		public const string QueryInsertarActualizarConsideracionesViajes = @"[Clientes].[uspInsertarActualizarConsideracionesViaje]";
		//------Proveedores-------
		public const string QueryObtenerProveedores = @"[Clientes].[uspObtenerProveedores]";
		public const string QueryEliminarProveedor = @"[Clientes].[uspEliminarProveedor]";
		public const string QueryInsertarActualizarProveedores = @"[Clientes].[uspInsertarActualizarProveedores]";
		//------Tipos de empaque-------
		public const string QueryObtenerTiposEmpaques = @"[Clientes].[uspObtenerTiposEmpaques]";
		public const string QueryEliminarTipoEmpaque = @"[Clientes].[uspEliminarTipoEmpaque]";
		public const string QueryInsertarActualizarTiposEmpaques = @"[Clientes].[uspInsertarActualizarTiposEmpaques]";
		public const string QueryInsertarActualizarRevivirTiposEmpaques = @"[Clientes].[uspInsertarActualizarRevivirTiposEmpaques]";
		//------Rangos de operación-----
		public const string QueryObtenerRangosOperaciones = @"[Clientes].[uspObtenerRangosOperaciones]";
		public const string QueryEliminarRangoOperacion = @"[Clientes].[uspEliminarRangoOperacion]";
		public const string QueryInsertarActualizarRangosOperaciones = @"[Clientes].[uspInsertarActualizarRangosOperaciones]";
		public const string QueryInsertarActualizarRevivirRangosOperaciones = @"[Clientes].[uspInsertarActualizarRevivirRangosOperaciones]";
		//------Sobrecargo por Combustible-----
		public const string QueryObtenerSobreCargosCombustibles = @"[Clientes].[uspObtenerSobreCargosCombustibles]";
		public const string QueryEliminarSobreCargoCombustible = @"[Clientes].[uspEliminarSobreCargoCombustible]";
		public const string QueryInsertarActualizarSobreCargosCombustibles = @"[Clientes].[uspInsertarActualizarSobreCargosCombustibles]";
		//-----Evidencias----
		public const string QueryObtenerEvidencia = @"[Clientes].[uspObtenerEvidencias]";
		public const string QueryEliminarEvidencia = @"[Clientes].[uspEliminarEvidencias]";
		public const string QueryInsertarActualizarEvidencias = @"[Clientes].[uspInsertarActualizarEvidencias]";
		//--------Contactos-----------------------
		public const string QueryObtenerContactos = @"[Clientes].[uspObtenerContactos]";
		public const string QueryEliminarContactos = @"[Clientes].[uspEliminarContactos]";
		public const string QueryInsertarActualizarContactos = @"[Clientes].[uspInsertarActualizarContactos]";
		//------Tarifas-------
		public const string QueryObtenerTarifas = @"[Clientes].[uspObtenerTarifas]";
		public const string QueryEliminarTarifas = @"[Clientes].[uspEliminarTarifas]";
		public const string QueryInsertarActualizarTarifas = @"[Clientes].[uspInsertarActualizarTarifas]";
		//-------Destinatarios------------
		public const string QueryObtenerDestinatarios = @"[Clientes].[uspObtenerDestinatarios]";
		public const string QueryEliminarDestinatarios = @"[Clientes].[uspEliminarDestinatarios]";
		public const string QueryInsertarActualizarDestinatarios = @"[Clientes].[uspInsertarActualizarDestinatarios]";
		public const string QueryInsertarActualizarRevivirSobreCargosCombustibles = @"[Clientes].[uspInsertarActualizarRevivirSobreCargosCombustibles]";
		#endregion
		#region Colaboradores

		//------colaboradores------
		public const string QueryObtenerColaboradores = @"[Operadores].[uspObtenerColaboradores]";
		public const string QueryObtenerColaboradoresPaginado = @"[Operadores].[uspObtenerColaboradoresPaginado]";
		public const string QueryEliminarColaborador = @"[Operadores].[uspEliminarColaborador]";
		public const string QueryInsertarActualizarColaboradores = @"[Operadores].[uspInsertarActualizarColaboradores]";
		public const string QueryObtenerIncidenciasPaginado = @"[Operadores].[uspObtenerIncidenciasPaginado]";
		public const string QueryObtenerCheckPointsPaginado = @"[Operadores].[uspObtenerCheckpointsPaginado]";
		//------Birtacora de manejo------
		public const string QueryEliminarBitacoraManejo = @"[Operadores].[uspEliminarBitacoraManejo]";
		public const string QueryInsertarActualizarBitacorasManejos = @"[Operadores].[uspInsertarActualizarBitacorasManejos]";
		public const string QueryObtenerBitacorasManejos = @"[Operadores].[uspObtenerBitacorasManejos]";
		//------Categoria de infraccion------
		public const string QueryEliminarCategoriaInfraccion = @"[Operadores].[uspEliminarCategoriaInfraccion]";
		public const string QueryInsertarActualizarCategoriasInfracciones = @"[Operadores].[uspInsertarActualizarCategoriasInfracciones]";
		public const string QueryObtenerCategoriasInfracciones = @"[Operadores].[uspObtenerCategoriasInfracciones]";
		//------Categoria de siniestros------
		public const string QueryEliminarCategoriaSiniestro = @"[Operadores].[uspEliminarCategoriaSiniestro]";
		public const string QueryInsertarActualizarCategoriasSiniestros = @"[Operadores].[uspInsertarActualizarCategoriasSiniestros]";
		public const string QueryObtenerCategoriasSiniestros = @"[Operadores].[uspObtenerCategoriasSiniestros]";
		//------CheckPoint------
		public const string QueryEliminarCheckPoint = @"[Operadores].[uspEliminarCheckPoint]";
		public const string QueryInsertarActualizarCheckPoint = @"[Operadores].[uspInsertarActualizarCheckPoint]";
		public const string QueryInsertarActualizarRevivirCheckPoints = @"[Operadores].[uspInsertarActualizarRevivirCheckPoint]";
		public const string QueryObtenerCheckPoint = @"[Operadores].[uspObtenerCheckpoint]";
		//------Checkpoint ruta------
		public const string QueryEliminarCheckpointRuta = @"[Operadores].[uspEliminarCheckpointRuta]";
		public const string QueryInsertarActualizarCheckpointRutas = @"[Operadores].[uspInsertarActualizarCheckpointRutas]";
		public const string QueryObtenerCheckpointRutas = @"[Operadores].[uspObtenerCheckpointRutas]";
		//------Comentarios del colaborador------
		public const string QueryEliminarComentarioColaborador = @"[Operadores].[uspEliminarComentarioColaborador]";
		public const string QueryInsertarActualizarComentariosColaboradores = @"[Operadores].[uspInsertarActualizarComentariosColaboradores]";
		public const string QueryObtenerComentariosColaboradores = @"[Operadores].[uspObtenerComentariosColaboradores]";
		//------Documento del colaborador------
		public const string QueryEliminarDocumentoColaborador = @"[Operadores].[uspEliminarDocumentoColaborador]";
		public const string QueryInsertarActualizarDocumentosColaboradores = @"[Operadores].[uspInsertarActualizarDocumentosColaboradores]";
		public const string QueryObtenerDocumentosColaboradores = @"[Operadores].[uspObtenerDocumentosColaboradores]";
		public const string QueryInsertarActualizarRevivirDocumentosColaboradores = @"[Operadores].[uspInsertarActualizarRevivirDocumentosColaboradores]";
		//------Habilidades del colaborador------
		public const string QueryEliminarHabilidadColaborador = @"[Operadores].[uspEliminarHabilidadColaborador]";
		public const string QueryInsertarActualizarHabilidadesColaboradores = @"[Operadores].[uspInsertarActualizarHabilidadesColaboradores]";
		public const string QueryObtenerHabilidadesColaboradores = @"[Operadores].[uspObtenerHabilidadesColaboradores]";
		//------Incidencias del colaborador------
		public const string QueryEliminarIncidenciaOperador = @"[Operadores].[uspEliminarIncidenciaOperador]";
		public const string QueryInsertarActualizarIncidenciasOperadores = @"[Operadores].[uspInsertarActualizarIncidenciasOperadores]";
		public const string QueryObtenerIncidenciasOperadores = @"[Operadores].[uspObtenerIncidenciasOperadores]";
		//------Incidencias------
		public const string QueryEliminarIncidencia = @"[Operadores].[uspEliminarIncidencia]";
		public const string QueryInsertarActualizarIncidencias = @"[Operadores].[uspInsertarActualizarIncidencias]";
		public const string QueryInsertarActualizarRevivirIncidencias = @"[Operadores].[uspInsertarActualizarRevivirIncidencias]";
		public const string QueryObtenerIncidencias = @"[Operadores].[uspObtenerIncidencias]";
        //------Infracciones de colaborador------
        public const string QueryEliminarInfraccionColaborador = @"[Operadores].[uspEliminarInfraccionColaborador]";
        public const string QueryInsertarActualizarInfraccionesColaboradores = @"[Operadores].[uspInsertarActualizarInfraccionesColaboradores]";
        public const string QueryObtenerInfraccionesColaboradores = @"[Operadores].[uspObtenerInfraccionesColaboradores]";
        //------Resguardos de colaborador------
        public const string QueryEliminarResguardoColaborador = @"[Operadores].[uspEliminarResguardoColaborador]";
        public const string QueryInsertarActualizarResguardosColaboradores = @"[Operadores].[uspInsertarActualizarResguardosColaboradores]";
        public const string QueryObtenerResguardosColaboradores = @"[Operadores].[uspObtenerResguardosColaboradores]";
        //------Rutas------
        public const string QueryEliminarRuta = @"[Operadores].[uspEliminarRuta]";
        public const string QueryInsertarActualizarRutas = @"[Operadores].[uspInsertarActualizarRutas]";
        public const string QueryObtenerRutas = @"[Operadores].[uspObtenerRutas]";
        public const string QueryInsertarActualizarRevivirRutas = @"[Operadores].[uspInsertarActualizarRevivirRutas]";
        //------Siniestros de colaborador------
        public const string QueryEliminarSiniestroColaborador = @"[Operadores].[uspEliminarSiniestroColaborador]";
        public const string QueryInsertarActualizarSiniestrosColaboradores = @"[Operadores].[uspInsertarActualizarSiniestrosColaboradores]";
        public const string QueryObtenerSiniestrosColaboradores = @"[Operadores].[uspObtenerSiniestrosColaboradores]";
        //------Tipos de documento del colaborador------
        public const string QueryEliminarTipoDocumentoColaborador = @"[Operadores].[uspEliminarTipoDocumentoColaborador]";
        public const string QueryInsertarActualizarTiposDocumentoColaboradores = @"[Operadores].[uspInsertarActualizarTiposDocumentoColaboradores]";
        public const string QueryObtenerTiposDocumentoColaboradores = @"[Operadores].[uspObtenerTiposDocumentoColaboradores]";
        //------Tipos de perfil------
        public const string QueryEliminarTipoPerfil = @"[Operadores].[uspEliminarTipoPerfil]";
        public const string QueryInsertarActualizarTiposPerfiles = @"[Operadores].[uspInsertarActualizarTiposPerfiles]";
        public const string QueryObtenerTiposPerfiles = @"[Operadores].[uspObtenerTiposPerfiles]";
        public const string QueryObtenerRutasPaginado = @"[Operadores].[uspObtenerRutasPaginado]";
        #endregion
        #region Vehiculos
        // Lista con la información completa de vehículos
        public const string QueryGetAllVehiculos = @"[Vehiculos].[uspObtenerVehiculos]";
        //------Vehiculos------
        public const string QueryEliminarVehiculo = @"[Vehiculos].[uspEliminarVehiculo]";
        public const string QueryInsertarActualizarVehiculos = @"[Vehiculos].[uspInsertarActualizarVehiculos]";
        public const string QueryObtenerVehiculos = @"[Vehiculos].[uspObtenerVehiculo]";
        public const string QueryInsertarActualizarRevivirVehiculos = @"[Vehiculos].[uspInsertarActualizarRevivirVehiculos]";
        //------Grupos------
        public const string QueryEliminarGrupo = @"[Vehiculos].[uspEliminarGrupo]";
        public const string QueryInsertarActualizarGrupos = @"[Vehiculos].[uspInsertarActualizarGrupos]";
        public const string QueryObtenerGrupos = @"[Vehiculos].[uspObtenerGrupos]";
        public const string QueryObtenerGruposPaginado = @"[Vehiculos].[uspObtenerGruposPaginado]";
        public const string QueryInsertarActualizarRevivirGrupos = @"[Vehiculos].[uspInsertarActualizarRevivirGrupos]";
        //------Grupos de detalles------
        public const string QueryEliminarGrupoDetalle = @"[Vehiculos].[uspEliminarGrupo]";
        public const string QueryInsertarActualizarGruposDetalles = @"[Vehiculos].[uspInsertarActualizarGruposDetalles]";
        public const string QueryObtenerGruposDetalles = @"[Vehiculos].[uspObtenerGruposDetalles]";
        //------Tipos de vehiculos------
        public const string QueryEliminarTipoVehiculo = @"[Vehiculos].[uspEliminarTipo]";
        public const string QueryInsertarActualizarTiposVehiculos = @"[Vehiculos].[uspInsertarActualizarTipos]";
        public const string QueryInsertarActualizarRevivirTiposVehiculos = @"[Vehiculos].[uspInsertarActualizarRevivirTipos]";
        public const string QueryObtenerTiposVehiculos = @"[Vehiculos].[uspObtenerTipos]";
        public const string QueryObtenerTipoVehiculosPaginado = @"[Vehiculos].[uspObtenerTiposVehiculosPaginado]";
        // Lista con la información completa de vehículos
        //public const string QueryGetAllVehiculos = @"[Vehiculos].[uspObtenerVehiculos]";
        //Lista de vehiculos de forma paginada
        public const string QueryObtenerVehiculosPaginado = @"[Vehiculos].[uspObtenerVehiculosPaginado]";
        // Inserción de bloque de vehículos vía Carga Masiva
        public const string QueryCargaMasivaVehiculos = @"[Vehiculos].[uspInsertarVehiculos]";
		//------Modelos------
		public const string QueryObtenerModelosPaginado = @"[Vehiculos].[uspObtenerModelosPaginado]";
		public const string QueryObtenerModelos = @"[Vehiculos].[uspObtenerModelos]";
		public const string QueryInsertarActualizarModelos = @"[Vehiculos].[uspInsertarActualizarModelos]";
		public const string QueryInsertarActualizarRevivirModelos = @"[Vehiculos].[uspInsertarActualizarRevivirModelos]";
		public const string QueryEliminarModelo = @"[Vehiculos].[uspEliminarModelos]";
		//------Marcas------
		public const string QueryObtenerMarcasPaginado = @"[Vehiculos].[uspObtenerMarcasPaginado]";
		public const string QueryObtenerMarcas = @"[Vehiculos].[uspObtenerMarcas]";
		public const string QueryInsertarActualizarMarcas = @"[Vehiculos].[uspInsertarActualizarMarcas]";
		public const string QueryInsertarActualizarRevivirMarcas = @"[Vehiculos].[uspInsertarActualizarRevivirMarcas]";
		public const string QueryEliminarMarca = @"[Vehiculos].[uspEliminarMarcas]";
		//------Colores------
		public const string QueryObtenerColoresPaginado = @"[Vehiculos].[uspObtenerColoresPaginado]";
		public const string QueryObtenerColores = @"[Vehiculos].[uspObtenerColores]";
		public const string QueryInsertarActualizarColores = @"[Vehiculos].[uspInsertarActualizarColores]";
		public const string QueryInsertarActualizarRevivirColores = @"[Vehiculos].[uspInsertarActualizarRevivirColores]";
		public const string QueryEliminarColor = @"[Vehiculos].[uspEliminarColores]";
        //-----Habilidades Vehiculos----------
        public const string QueryObtenerHabilidadesVehiculos = @"[Vehiculos].[uspObtenerHabilidadesVehiculos]";
        public const string QueryEliminarHabilidadesVehiculos = @"[Vehiculos].[uspEliminarHabilidadesVehiculos]";
        public const string QueryInsertarActualizarHabilidadesVehiculos = @"[Vehiculos].[uspInsertarActualizarHabilidadesVehiculos]";
        //------Configuraciones--------
        public const string QueryObtenerConfiguraciones = @"[Vehiculos].[uspObtenerConfiguraciones]";
        public const string QueryInsertarActualizarConfiguraciones = @"[Vehiculos].[uspInsertarActualizarConfiguraciones]";
        public const string QueryInsertarActualizarRevivirConfiguraciones = @"[Vehiculos].[uspInsertarActualizarRevivirConfiguraciones]";
        public const string QueryEliminarConfiguraciones = @"[Vehiculos].[uspEliminarConfiguraciones]";
        public const string QueryObtenerConfiguracionPaginado = @"[Vehiculos].[uspObtenerConfiguracionesVehiculosPaginado]";

        //------Esquemas-------------
        public const string QueryObtenerEsquemas = @"[Vehiculos].[uspObtenerEsquemas]";
        public const string QueryInsertarActualizarEsquemas = @"[Vehiculos].[uspInsertarActualizarEsquemas]";
        public const string QueryInsertarActualizarRevivirEsquemas = @"[Vehiculos].[uspInsertarActualizarRevivirEsquemas]";
        public const string QueryEliminarEsquemas = @"[Vehiculos].[uspEliminarEsquemas]";
        public const string QueryObtenerEsquemaPaginado = @"[Vehiculos].[uspObtenerEsquemasVehiculosPaginado]";
        //------TiposDocumentosVehiculos-------------
        public const string QueryObtenerTiposDocumentosVehiculos = @"[Vehiculos].[uspObtenerTiposDocumentosVehiculo]";
        public const string QueryInsertarActualizarTiposDocumentosVehiculos = @"[Vehiculos].[uspInsertarActualizarTiposDocumentosVehiculos]";
        public const string QueryEliminarTiposDocumentosVehiculos = @"[Vehiculos].[uspEliminarTiposDocumentosVehiculos]";
        public const string QueryInsertarActualizarRevivirTiposDocumentosVehiculos = @"[Vehiculos].[uspInsertarActualizarRevivirTiposDocumentosVehiculo]";
        //------Checklist-------------
        public const string QueryObtenerCheckslist = @"[Vehiculos].[uspObtenerChecklist]";
        public const string QueryInsertarActualizarCheckslist = @"[Vehiculos].[uspInsertarActualizarCheckslist]";
        public const string QueryEliminarCheckslist = @"[Vehiculos].[uspEliminarCheckslist]";
        //------Documentos-------------
        public const string QueryObtenerDocumentos = @"[Vehiculos].[uspObtenerDocumentos]";
        public const string QueryInsertarActualizarDocumentos = @"[Vehiculos].[uspInsertarActualizarDocumentos]";
        public const string QueryEliminarDocumentos = @"[Vehiculos].[uspEliminarDocumentos]";
        #endregion
        #region Combustibles
        public const string QueryObtenerBitacorasPaginado = @"[Combustibles].[uspObtenerBitacorasPaginado]";
        public const string QueryCargaMasivaBitacoras = @"[Combustibles].[uspInsertarBitacorasCSV]";
        public const string QueryObtenerSolicitudesPaginado = @"[Combustibles].[uspObtenerSolicitudCombustiblePaginado]";
        public const string QueryObtenerEstacionesPaginado = @"[Combustibles].[uspObtenerEstacionesPaginado]";
        //-----TipoCombustible-----
        public const string QueryInsertarActualizarTiposCombustibles = @"[Combustibles].[uspInsertarActualizarTiposCombustibles]";
        public const string QueryEliminarTipoCombustible = @"[Combustibles].[uspEliminarTipoCombustible]";
        public const string QueryObtenerTiposCombustibles = @"[Combustibles].[uspObtenerTiposCombustibles]";
        public const string QueryInsertarActualizarRevivirTiposCombustibles = @"[Combustibles].[uspInsertarActualizarRevivirTiposCombustibles]";
        //-----Estaciones------
        public const string QueryInsertarActualizarEstaciones = @"[Combustibles].[uspInsertarActualizarEstaciones]";
        public const string QueryEliminarEstacion = @"[Combustibles].[uspEliminarEstaciones]";
        public const string QueryObtenerEstaciones = @"[Combustibles].[uspObtenerEstaciones]";
        public const string QueryInsertarActualizarRevivirEstaciones = @"[Combustibles].[uspInsertarActualizarRevivirEstaciones]";
        //-----SolicitudCombustible------
        public const string QueryInsertarActualizarSolicitudesCombustibles = @"[Combustibles].[uspInsertarActualizarSolicitudesCombustibles]";
        public const string QueryEliminarSolicitudCombustible = @"[Combustibles].[uspEliminarSolicitudesCombustibles]";
        public const string QueryObtenerSolicitudesCombustibles = @"[Combustibles].[uspObtenerSolicitudesCombustibles]";
        public const string QueryInsertarActualizarRevivirSolicitudesCombustibles = @"[Combustibles].[uspInsertarActualizarRevivirSolicitudesCombustibles]";
        //-----BitacoraCombustible-------
        public const string QueryInsertarActualizarBitacorasCombustibles = @"[Combustibles].[uspInsertarActualizarBitacorasCombustibles]";
        public const string QueryEliminarBitacoraCombustible = @"[Combustibles].[uspEliminarBitacorasCombustibles]";
        public const string QueryObtenerBitacorasCombustibles = @"[Combustibles].[uspObtenerBitacorasCombustibles]";
        public const string QueryInsertarActualizarRevivirBitacorasCombustibles = @"[Combustibles].[uspInsertarActualizarRevivirBitacorasCombustibles]";
        #endregion
        #region Productos
        public const string QueryInsertaProductos = @"[Productos].[spInsertaProducto]";
        public const string QueryInsertarActualizarEmbalaje = @"[Productos].[uspInsertarActualizarEmbalaje]";
        public const string QueryInsertarActualizarUnidadMEdida = @"[Productos].[uspInsertarActualizarUnidadMEdidaConJSon]";
        public const string QueryInsertarActualizarPeligroso = @"[Productos].[uspInsertarActualizarPeligrosoConJSon]";
        public const string QueryInsertarActualizarEmbalajes = @"[Productos].[uspInsertarActualizarEmbalajes]";
        public const string QueryEliminarEmbalajes = @"[Productos].[uspEliminarEmbalajes]";
        public const string QueryObtenerEmbalajes = @"[Productos].[uspObtenerEmbalajes]";
        public const string QueryInsertarActualizarPeligrosos = @"[Productos].[uspInsertarActualizaPeligrosos]";
        public const string QueryEliminarPeligrosos = @"[Productos].[uspEliminarPeligrosos]";
        public const string QueryObtenerPeligrosos = @"[Productos].[uspObtenerPeligrosos]";
        public const string QueryInsertarActualizarProductos = @"[Productos].[uspInsertarActualizarProductos]";
        public const string QueryEliminarProductos = @"[Productos].[uspEliminarProductos]";
        public const string QueryObtenerProductos = @"[Productos].[uspObtenerProductos]";
        public const string QueryInsertarActualizarUN = @"[Productos].[uspInsertarActualizarUN]";
        public const string QueryEliminarUN = @"[Productos].[uspEliminarUN]";
        public const string QueryObtenerUN = @"[Productos].[uspObtenerUN]";
        public const string QueryInsertarActualizarUnidadesMedidas = @"[Productos].[uspInsertarActualizarUnidadesMedidas]";
        public const string QueryEliminarUnidadesMedidas = @"[Productos].[uspEliminarUnidadesMedidas]";
        public const string QueryObtenerUnidadesMedidas = @"[Productos].[uspObtenerUnidadesMedidas]";
        public const string QueryObtenerEmbalajePaginado = @"[Productos].[uspObtenerEmbalajesPaginado]";
        public const string QueryObtenerPeligrosoPaginado = @"[Productos].[uspObtenerPeligrosoPaginado]";
        public const string QueryObtenerProductosPaginado = @"[Productos].[uspObtenerProductosPaginado]";
        public const string QueryObtenerUnPaginado = @"[Productos].[uspObtenerUnPaginado]";
        public const string QueryObtenerUnidadesMedidaPaginado = @"[Productos].[uspObtenerUnidadesMedidaPaginado]";

        #endregion
        #region Gestor de Documentos
        public const string QueryInsertaeActualizarTipoDocumento = @"[GestorDocumentos].[UspInsertarActualizarDocumento]";
        public const string QueryInsertaActualizaExpediente = @"[GestorDocumentos].[UspInsertarActualizarExpediente]";
        public const string QueryInsertarActualizarExpedienteDocumento = @"[GestorDocumentos].[uspInsertaExpedientesDocumento]";
        //------Categoria de infraccion------
        public const string QueryEliminarTipoDocumento = @"[GestorDocumentos].[uspEliminarTipoDocumento]";
        public const string QueryObtenerTiposDocumentos = @"[GestorDocumentos].[uspObtenerTiposDocumentos]";

        //--------Expedientes-----------
        public const string QueryObtenerExpedientes = @"[GestorDocumentos].[uspObtenerExpedientes]";
        public const string QueryInsertarActualizarExpedientes = @"[GestorDocumentos].[UspInsertarActualizarExpedientes]";
        public const string QueryElminarExpedientes = @"[GestorDocumentos].[uspEliminarExpedientes]";
        public const string QueryObtenerExpedeintePaginado = @"[GestorDocumentos].[uspObtenerExpedientesPaginado]";


        //-------Expedientes Documentos----------
        public const string QueryObtenerExpedientesDocumentos = @"[GestorDocumentos].[uspObtenerExpedientesDocumentos]";
        public const string QueryInsertarActualizarExpedientesDocumentos = @"[GestorDocumentos].[UspInsertarActualizarExpedientesDocumentos]";
        public const string QueryEliminarExpedientesDocumentos = @"[GestorDocumentos].[uspEliminarExpedientesDocumentos]";
        public const string QueryObtenerExpedienteDocumento = @"[GestorDocumentos].[uspObtenerExpedienteDocumentosPaginado]";

        //---------Tipo Documentos-------------
        public const string QueryInsertarActualizarTiposDocumentos = @"[GestorDocumentos].[uspInsertarActualizarTiposDocumentos]";
        public const string QueryEliminarTiposDocumentos = @"[GestorDocumentos].[uspEliminarTiposDocumentos]";
        public const string QueryObtenerTipoDocumentoPaginado = @"[GestorDocumentos].[uspObtenerTiposDocumentosPaginado]";

        #endregion
        #region Checklist
        public const string QueryObtenerPreguntasConRespuestas = @"[Checklist].[uspObtenerPreguntasConRespuestas]";
        public const string QueryInsertarPreguntasConRespuestas = @"[Checklist].[uspInsertarPreguntasRespuestas]";
        public const string QueryObtenerChecklistsPaginado = @"[Checklist].[uspObtenerChecklistPaginado]";
        //----------Checklist-----------
        public const string QueryObtenerChecklist = @"[Checklist].[uspObtenerChecklist]";
        public const string QueryEliminarCheckList = @"[Checklist].[uspEliminarCheckList]";
        public const string QueryInsertarActualizarChecklist = @"[Checklist].[uspInsertarActualizarCheckList]";
        public const string QueryInsertarActualizarRevivirChecklist = @"[Checklist].[uspInsertarActualizarRevivirCheckList]";
        //----------Respuestas-----------
        public const string QueryObtenerRespuestasChecklist = @"[Checklist].[uspObtenerRespuestasChecklist]";
        public const string QueryEliminarRespuestasChecklist = @"[Checklist].[uspEliminarRespuestasChecklist]";
        public const string QueryInsertarActualizarRespuestasChecklist = @"[Checklist].[uspInsertarActualizarRespuestasChecklist]";
        //----------Preguntas-----------
        public const string QueryObtenerPreguntasChecklist = @"[Checklist].[uspObtenerPreguntasChecklist]";
        public const string QueryEliminarPreguntasCheckList = @"[Checklist].[uspEliminarPreguntasCheckList]";
        public const string QueryInsertarActualizarPreguntasChecklist = @"[Checklist].[uspInsertarActualizarPreguntasChekList]";
        #endregion
        #region Despachos
        public const string QueryObtenerTicketsPaginado = @"[Despachos].[uspObtenerTicketsPaginado]";
        public const string QueryInsertarCentroDistribuciones = @"[Despachos].[uspInsertarActualizarCentroDistribuciones]";
        public const string QueryObtenerTicket = @"[Despachos].[uspObtenerFolio]";
        public const string QueryObtenerDespacho = @"[Despachos].[uspObtenerDespachos]";
        public const string QueryObtenerDespachosPaginado = @"[Despachos].[uspObtenerDespachosPaginado]";
        public const string QueryObtenerTrafico = @"[Despachos].[uspObtenerTraficos]";
        public const string QueryObtenerVisorCustodia = @"[Despachos].[uspObtenerVisoresCustodia]";
        public const string QueryObtenerOperadoresDisponibles = @"[Despachos].[uspObtenerOperadoresDisponibles]";
        public const string QueryObtenerVehiculosDisponibles = @"[Despachos].[uspObtenerVehiculosDisponibles]";
        public const string QueryObtenerTicketsDisponibles = @"[Despachos].[uspObtenerTicketsDisponibles]";
        public const string QueryInsertaVisores_V1 = @"[Despachos].[uspInsertaVisores_V1]";
        public const string QueryInsertaSello = @"[Despachos].[uspInsertaSellos]";
        public const string QueryActualizarEstatusTicket = @"[Despachos].[uspActualizarEstatusTicket]";
        public const string QueryObtenerAlmacenesPaginado = @"[Despachos].[uspObtenerAlmacenesPaginado]";
        public const string QueryObtenerAndenesPaginado = @"[Despachos].[uspObtenerAndenesPaginado]";
        public const string QueryObtenerVisoresCustodiaPaginado = @"[Despachos].[uspObtenerVisoresCustodiaPaginado]";
        public const string QueryObtenerTraficoPaginado = @"[Despachos].[uspObtenerTraficosPaginado]";
        public const string QueryObtenerCentrosDistribuciones = @"[Operadores].[uspObtenerCentrosDistribuciones]";
        public const string QueryObtenerVisoresPaginado = @"[Despachos].[uspObtenerVisoresPaginado]";

        #region GastosOperativos
        //Registros dispersiones
        public const string QueryObtenerRegistrosDispersionesPaginado = @"[Despachos].[uspObtenerRegistrosDispersionesPaginado]";
        public const string QueryCargaMasivaRegistrosDispersiones = @"[Despachos].[uspInsertarRegistrosDispersionesCSV]";
        public const string QueryEliminarRegistroDispersiones = @"[Despachos].[uspEliminarRegistroDispersion]";
        public const string QueryInsertarActualizarRegistrosDispersiones = @"[Despachos].[uspInsertarActualizarRegistrosDispersiones]";
        public const string QueryObtenerRegistroDispersiones = @"[Despachos].[uspObtenerRegistroDispersiones]";
        public const string QueryInsertarActualizarRevivirRegistrosDispersiones = @"[Despachos].[uspInsertarActualizarRevivirRegistrosDispersiones]";
        //Tipo Gastos
        public const string QueryObtenerTipoGastosPaginado = @"[Despachos].[uspObtenerTipoGastosPaginado]";
        public const string QueryCargaMasivaTiposGastos = @"[Despachos].[uspInsertarTiposGastosCSV]";
        public const string QueryEliminarTipoGastos = @"[Despachos].[uspEliminarTipoGastos]";
        public const string QueryInsertarActualizarTipoGastos = @"[Despachos].[uspInsertarActualizarTipoGastos]";
        public const string QueryObtenerTipoGastos = @"[Despachos].[uspObtenerTipoGastos]";
        public const string QueryInsertarActualizarRevivirTipoGastos = @"[Despachos].[uspInsertarActualizarRevivirTipoGastos]";
        //Registros liquidaciones
        public const string QueryObtenerRegistrosLiquidacionesPaginado = @"[Despachos].[uspObtenerRegistrosLiquidacionesPaginado]";
        public const string QueryCargaMasivaRegistrosLiquidaciones = @"[Despachos].[uspInsertarRegistrosLiquidacionesCSV]";
        public const string QueryEliminarRegistrosLiquidaciones = @"[Despachos].[uspEliminarRegistroLiquidacion]";
        public const string QueryInsertarActualizarRegistrosLiquidaciones = @"[Despachos].[uspInsertarActualizarRegistrosLiquidaciones]";
        public const string QueryObtenerRegistroLiquidaciones = @"[Despachos].[uspObtenerRegistroLiquidaciones]";
        public const string QueryInsertarActualizarRevivirRegistrosLiquidaciones = @"[Despachos].[uspInsertarActualizarRevivirRegistrosLiquidaciones]";
        //Registros Ajustes
        public const string QueryObtenerRegistrosAjustesPaginado = @"[Despachos].[uspObtenerRegistrosAjustesPaginado]";
        public const string QueryCargaMasivaRegistrosAjustes = @"[Despachos].[uspInsertarRegistrosAjustesCSV]";
        public const string QueryEliminarRegistrosAjustes = @"[Despachos].[uspEliminarRegistroAjuste]";
        public const string QueryInsertarActualizarRegistrosAjustes = @"[Despachos].[uspInsertarActualizarRegistroAjuste]";
        public const string QueryObtenerRegistroAjustes = @"[Despachos].[uspObtenerRegistroAjustes]";
        public const string QueryInsertarActualizarRevivirRegistrosAjustes = @"[Despachos].[uspInsertarActualizarRevivirRegistrosAjustes]";
        //Casetas
        public const string QueryCargaMasivaCasetas = @"[Despachos].[uspInsertarCasetasCSV]";
        public const string QueryObtenerCasetasPaginado = @"[Despachos].[uspObtenerCasetasPaginado]";
        public const string QueryEliminarCasetas = @"[Despachos].[uspEliminarCaseta]";
        public const string QueryInsertarActualizarCasetas = @"[Despachos].[uspInsertarActualizarCasetas]";
        public const string QueryObtenerCasetasDespachos = @"[Despachos].[uspObtenerCasetas]";
        public const string QueryInsertarActualizarRevivirCasetas = @"[Despachos].[uspInsertarActualizarRevivirCasetas]";
        //Registros Proveedores
        public const string QueryCargaMasivaRegistrosProveedores = @"[Despachos].[uspInsertarRegistrosProveedoresCSV]";
        public const string QueryObtenerRegistrosProveedoresPaginado = @"[Despachos].[uspObtenerProveedoresPaginado]";
        public const string QueryEliminarRegistroProveedor = @"[Despachos].[uspEliminarRegistroProveedor]";
        public const string QueryInsertarActualizarRegistrosProveedores = @"[Despachos].[uspInsertarActualizarRegistroProveedores]";
        public const string QueryObtenerRegistrosProveedores = @"[Despachos].[uspObtenerRegistroProveedores]";
        public const string QueryInsertarActualizarRevivirRegistrosProveedores = @"[Despachos].[uspInsertarActualizarRevivirRegistrosProveedores]";
        #endregion
        public const string QueryObtenerTicketsConSeguro = @"[Despachos].[uspObtenerTicketsConSeguro]";
        public const string QueryObtenerEstatusTicket = @"[Despachos].[uspObtenerStatusTickets]";
        public const string QueryObtenerTicketsManifiesto = @"[Despachos].[uspObtenerTicketsManifiesto]";
        public const string QueryObtenerTicketsAsignadosEliminar = @"[Despachos].[uspObtenerTicketsEliminar]";
        public const string QueryInsertarActualizarVisores = @"[Despachos].[uspInsertarActualizarVisores]";
        public const string QueryInsertaActualizaVisores = @"[Despachos].[uspInsertarVisoresJson_V1]";
        public const string QueryInsertaVisores = @"[Despachos].[uspInsertaVisores]";
        public const string QueryObtenerAuxiliaresDespacho = @"[Despachos].[uspObtenerAuxiliaresDespacho]";
        public const string QueryObtenerAuxiliaresHorasLaboradas = @"[Despachos].[uspObtenerAuxiliaresHorasLaboradas]";
        // Lista con la información de notificaciones ligadas a un Usuario
        public const string QueryGetAllNotificacionesByUsuario = @"[Notificaciones].[uspObtenerNotificacionesByUsuario]";
        public const string QueryObtenerDespachosPorEstatus = @"[Despachos].[uspObtenerManifiestosPorEstatus]";
        //------Despachos------
        public const string QueryEliminarDespacho = @"[Despachos].[uspEliminarDespacho]";
        public const string QueryInsertarActualizarDespachos = @"[Despachos].[uspInsertarActualizarDespachos]";
        public const string QueryObtenerDespachos = @"[Despachos].[uspObtenerDespachos]";
        //------Documento ticket------
        public const string QueryEliminarDocumentoTicket = @"[Despachos].[uspEliminarDocumentoTicket]";
        public const string QueryInsertarActualizarDocumentosTickets = @"[Despachos].[uspInsertarActualizarDocumentosTickets]";
        public const string QueryObtenerDocumentosTickets = @"[Despachos].[uspObtenerDocumentosTickets]";
        //------Servicio adicional------
        public const string QueryEliminarServicioAdicional = @"[Despachos].[uspEliminarServicioAdicional]";
        public const string QueryInsertarActualizarServiciosAdicionales = @"[Despachos].[uspInsertarActualizarServiciosAdicionales]";
        public const string QueryObtenerServiciosAdicionales = @"[Despachos].[uspObtenerServiciosAdicionales]";
        //------Servicio medico------
        public const string QueryEliminarServicioMedico = @"[Despachos].[uspEliminarServicioMedico]";
        public const string QueryInsertarActualizarServiciosMedicos = @"[Despachos].[uspInsertarActualizarServiciosMedicos]";
        public const string QueryObtenerServiciosMedicos = @"[Despachos].[uspObtenerServiciosMedicos]";
        //------Tickets------
        public const string QueryEliminarTicket = @"[Despachos].[uspEliminarTicket]";
        public const string QueryInsertarActualizarTickets = @"[Despachos].[uspInsertarActualizarTickets]";
        public const string QueryObtenerTickets = @"[Despachos].[uspObtenerTickets]";
        //------Tickets asignados------
        // SP para eliminar solo un ticket y de manera virtual (Actualizando el eliminado)
        public const string QueryEliminarTicketAsignado = @"[Despachos].[uspEliminarTicketAsignado]";
        // SP para eliminar muchos tickets y de manera fisica (Eliminandolos de la bas de datos)
        public const string QueryEliminarTicketsAsignados = @"[Despachos].[uspEliminarTicketsAsignados]";
        public const string QueryInsertarActualizarTicketsAsignados = @"[Despachos].[uspInsertarActualizarTicketsAsignados]";
        public const string QueryObtenerTicketsAsignados = @"[Despachos].[uspObtenerTicketsAsignados]";
        //------Tickets no entregados------
        public const string QueryEliminarTicketNoEntregado = @"[Despachos].[uspEliminarTicketNoEntregado]";
        public const string QueryInsertarActualizarTicketsNoEntregados = @"[Despachos].[uspInsertarActualizarTicketsNoEntregados]";
        public const string QueryObtenerTicketsNoEntregados = @"[Despachos].[uspObtenerTicketsNoEntregados]";
		//------Almacenes------
		public const string QueryInsertarActualizarAlmacen = @"[Despachos].[uspInsertarActualizarAlmacen]";
		public const string QueryInsertarActualizarRevivirAlmacenes = @"[Despachos].[uspInsertarActualizarRevivirAlmacenes]";
		public const string QueryObtenerAlmacenes = @"[Despachos].[uspObtenerAlmacenes]";
		public const string QueryEliminarAlmacen = @"[Despachos].[uspEliminarAlmacen]";
		//------Andenes------
		public const string QueryInsertarActualizarRevivirAndenes = @"[Despachos].[uspInsertarActualizarRevivirAndenes]";
		public const string QueryInsertarActualizarAnden = @"[Despachos].[uspInsertarActualizarAnden]";
		public const string QueryEliminarAnden = @"[Despachos].[uspEliminarAnden]";
		public const string QueryObtenerAndenes = @"[Despachos].[uspObtenerAndenes]";
		//------Auxiliar------
		public const string QueryInsertarActualizarAuxiliar = @"[Despachos].[uspInsertarActualizarAuxiliar]";
        public const string QueryObtenerAuxiliares = @"[Despachos].[uspObtenerAuxiliares]";
        public const string QueryEliminarAuxiliar = @"[Despachos].[uspEliminarAuxiliar]";
		//------Custodia------
		public const string QueryInsertarActualizarCustodias = @"[Despachos].[uspInsertarActualizarCustodias]";
		public const string QueryObtenerCustodias = @"[Despachos].[uspObtenerCustodias]";
		public const string QueryEliminarCustodia = @"[Despachos].[uspEliminarCustodia]";
		//------CartasPorte------
		public const string QueryInsertarActualizarCartasPorte = @"[Despachos].[uspInsertarActualizarCartasPorte]";
        public const string QueryObtenerCartasPorte = @"[Despachos].[uspObtenerCartasPorte]";
        public const string QueryEliminarCartaPorte = @"[Despachos].[uspEliminarCartaPorte]";
        //------CausasCambios------
        public const string QueryInsertarActualizarCausasCambios = @"[Despachos].[uspInsertarActualizarCausasCambios]";
        public const string QueryEliminarCausaCambio = @"[Despachos].[uspEliminarCausaCambio]";
        public const string QueryObtenerCausasCambios = @"[Despachos].[uspObtenerCausasCambios]";
        //-----TipoCustodia-----
        public const string QueryInsertarActualizarTiposCustodia = @"[Despachos].[uspInsertarActualizarTiposCustodias]";
        public const string QueryEliminarTipoCustodia = @"[Despachos].[uspEliminarTipoCustodia]";
        public const string QueryObtenerTiposCustodias = @"[Despachos].[uspObtenerTiposCustodias]";
        //------Visores-----------
        public const string QueryObtenerVisores = @"[Despachos].[uspObtenerVisores]";
        public const string QueryEliminarVisores = @"[Despachos].[uspEliminarVIsor]";
        //-------Sellos---------
        public const string QueryObtenerSellos = @"[Despachos].[uspObtenerSellos]";
        public const string QueryInsertarActualizarSellos = @"[Despahos].[uspInsertarActualizarSellos]";
        public const string QueryEliminarSellos = @"[Despachos].[uspEliminarSellos]";
        //------SeguroDespachos----
        public const string QueryInsertarActualizarSeguroDespacho = @"[Despachos].[uspInsertarSegurosDespachos]";
        public const string QueryObtenerSeguroDespacho = @"[Despachos].[uspObtenerSegurosDespachos]";
        public const string QueryEliminarSeguroDespacho = @"[Despachos].[uspEliminarSeguroDespacho]";
		//------ReasigaTickets-----------
		public const string QueryObtenerReasignaTickets = @"[Despachos].[uspObtenerReasignaTickets]";
		public const string QueryInsertarActualizarReasignaTickets = @"[Despachos].[uspInsertarActualizarReasignaTicket]";
		//------CentrosDistribuciones------ 
		public const string QueryObtenerCedisPaginado = @"[Despachos].[uspObtenerCedisPaginado]";
		public const string QueryInsertarActualizarCedis = @"[Despachos].[uspInsertarActualizarCEDIS]";
		public const string QueryEliminarCentroDistribucion = @"[Operadores].[uspEliminarCentroDistribucion]";
		public const string QueryInsertarActualizarCentroDistribuciones = @"[Operadores].[uspInsertarActualizarCentroDistribuciones]";
		#endregion
		#region Notificaciones
		// Lista con la información de notificaciones agrupadas por Categoría
		public const string QueryGetAllNotificacionesByCategoria = @"[Notificaciones].[uspObtenerNotificacionesByCategoria]";
        //Lista con la información de las bandejas por usuario paginado
        public const string QueryGetAllBandejaByUsuarioPaginado = @"[Notificaciones].[uspObtenerBandejaPaginado]";
        //Alertas
        public const string QueryInsertarActualizarAlertas = @"[Notificaciones].[uspInsertarActualizarAlertas]";
        public const string QueryEliminarAlertas = @"[Notificaciones].[uspEliminarAlertas]";
        public const string QueryObtenerAlertas = @"[Notificaciones].[uspObtenerAlertas]";
        public const string QueryObtenerAlertasPaginado = @"[Notificaciones].[uspObtenerAlertasPaginado]";
        //Bandejas
        public const string QueryInsertarActualizarBandejas = @"[Notificaciones].[uspInsertarActualizarBandejas]";
        public const string QueryEliminarBandejas = @"[Notificaciones].[uspEliminarBandejas]";
        public const string QueryObtenerBandejas = @"[Notificaciones].[uspObtenerBandejas]";
        //CategoriasNotificaciones
        public const string QueryInsertarActualizarCategoriasNotificaciones = @"[Notificaciones].[uspInsertarActualizarCategoriasNotificaciones]";
        public const string QueryEliminarCategoriasNotificaciones = @"[Notificaciones].[uspEliminarCategoriasNotificaciones]";
        public const string QueryObtenerCategoriasNotificaciones = @"[Notificaciones].[uspObtenerCategoriasNotificaciones]";
        //Notificaciones
        public const string QueryInsertarActualizarNotificaciones = @"[Notificaciones].[uspInsertarActualizarNotificaciones]";
        public const string QueryEliminarNotificaciones = @"[Notificaciones].[uspEliminarNotificaciones]";
        public const string QueryObtenerNotificaciones = @"[Notificaciones].[uspObtenerNotificaciones]";
        #endregion
        #region GPS
        #endregion
        #region No conformidades
        #endregion
    }
}
