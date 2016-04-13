using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.MSCRRHH.Utilities.Bitacora
{
    /// <summary>
    /// Summary description for Bitacora
    /// </summary>
    public class Bitacora
    {
        private static readonly ILog log = LogManager.GetLogger("Bitacora_Operaciones");
        private static readonly ILog logStandard = LogManager.GetLogger("Standard");

        public enum TraceType
        {
            UserLogin,              // Un empleado hace un login en un sistema
            UserLogout,             // Un empleado hace un logout en el sistema
            CreacionVentaFactura,       // Un empleado efectúa una venta con factura
            CreacionVentaRecibo,        // Un empleado efectúa una venta con recibo
            AnulacionVenta,         // Un empleado anula una venta
            RegisterPerson,
            ImportWBT,            // A user imports a WBT
        }

        public Bitacora()
        {
        }

        /// <summary>
        /// Registra una pista en el log de pistas
        /// </summary>
        /// <param name="traceType">El tipo de medida que estamos incluyendo</param>
        /// <param name="empleado">El login del empleado.  Puede ser vació o nulo</param>
        /// <param name="tipoObjeto">El tipo de objecto para el cual aplica la pista.  Puede ser vació o nulo</param>
        /// <param name="idObjeto">El ID del objecto para el cual aplica la pista.  Puede ser vació o nulo</param>
        /// <param name="mensaje">El mensaje detallado para la pista.  Puede ser vació o nulo</param>
        public void RecordTrace(TraceType tipoDeEvento, string empleado, string tipoObjeto,
            string idObjeto, string mensaje)
        {
            // Esto nunca de debería tirar una excepción

            try
            {
                string empleadoReal = string.IsNullOrEmpty(empleado) ? "[Sin Texto]" : empleado;
                string tipoObjetoReal = string.IsNullOrEmpty(tipoObjeto) ? "[Sin Texto]" : tipoObjeto;
                string idObjetoReal = string.IsNullOrEmpty(idObjeto) ? "[Sin Texto]" : idObjeto;
                string mensajeReal = string.IsNullOrEmpty(mensaje) ? "[Sin Texto]" : mensaje;

                log.Info(tipoDeEvento.ToString() + "|" +
                    empleadoReal + "|" +
                    tipoObjetoReal + "|" +
                    idObjetoReal + "|" +
                    mensajeReal);
            }
            catch (Exception exc)
            {
                logStandard.Error(exc.Message);
                // Si no podemos generar este mensaje, el sistema de Logs no está funcionando
                // y por lo tanto no hay nada que podamos hacer al respecto.  
            }
        }

        /// <summary>
        /// Convierte una cadena al tipo de dato correspondiente en la enumeración
        /// </summary>
        /// <param name="type">El valor de la enumeración como cadena</param>
        /// <returns>La enumeración correspondiente a la cadena provista</returns>
        public static TraceType GetTypeFromString(string type)
        {
            switch (type)
            {
                case "UserLogin": return TraceType.UserLogin;
                case "UserLogout": return TraceType.UserLogout;
                case "CreacionVentaFactura": return TraceType.CreacionVentaFactura;
                case "CreacionVentaRecibo": return TraceType.CreacionVentaRecibo;
                case "RegisterPerson": return TraceType.RegisterPerson;
                default: return TraceType.AnulacionVenta;
            }
        }

    }
}