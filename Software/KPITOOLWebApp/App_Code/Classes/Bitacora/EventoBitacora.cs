using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.MSCRRHH.Bitacora
{
    /// <summary>
    /// Summary description for EventoBitacora
    /// </summary>
    public class EventoBitacora
    {
        public int Id { get; set; }
        public DateTime Fecha { get; set; }
        public string TipoEvento { get; set; }
        public string Empleado { get; set; }
        public string TipoObjeto { get; set; }
        public string IdObjeto { get; set; }
        public string Mensaje { get; set; }

        public EventoBitacora(int id, DateTime fecha, string tipoEvt, string empl, string tipoObj, string idobj, string msg)
        {
            Id = id;
            Fecha = fecha;
            TipoEvento = tipoEvt;
            Empleado = empl;
            TipoObjeto = tipoObj;
            IdObjeto = idobj;
            Mensaje = msg;
        }
    }
}