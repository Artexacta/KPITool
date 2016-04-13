using System;
using System.Collections.Generic;
using System.Data.SqlTypes;
using System.Linq;
using System.Web;
using log4net;
using Artexacta.App.Configuration;

namespace Artexacta.MSCRRHH.Bitacora.BLL
{
    public class EventoBitacoraBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        public EventoBitacoraBLL() { }

        private static EventoBitacora FillRecord(EventoBitacoraDS.EventoBitacoraRow row)
        {
            EventoBitacora objEventoBitacora = new EventoBitacora(
                row.id, row.fecha, row.tipoEvento, row.empleado, row.tipoObjeto, row.idObjeto, row.mensaje);
            return objEventoBitacora;
        }

        public static List<EventoBitacora> getEventoBitacoraList(string search, int firstRow, int pageSize, ref int? totalRows)
        {
            int husoHorario = Configuration.GetHusoHorario();

            List<EventoBitacora> theList = new List<EventoBitacora>();
            EventoBitacora theEventoBitacora = null;
            try
            {
                EventoBitacoraDSTableAdapters.EventoBitacoraTableAdapter theAdapter = new EventoBitacoraDSTableAdapters.EventoBitacoraTableAdapter();
                EventoBitacoraDS.EventoBitacoraDataTable theTable = theAdapter.GetEventoBitacoraBySearch(search, husoHorario, pageSize, firstRow, ref totalRows);
                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (EventoBitacoraDS.EventoBitacoraRow row in theTable.Rows)
                    {
                        theEventoBitacora = FillRecord(row);
                        theList.Add(theEventoBitacora);
                    }
                }
            }
            catch (Exception ex)
            {
                log.Error("An error was ocurred while geting list EventoBitacora", ex);
                throw;
            }
            return theList;
        }
    }
}