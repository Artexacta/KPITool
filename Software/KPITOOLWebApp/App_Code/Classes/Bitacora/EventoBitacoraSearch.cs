using SearchComponent;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.MSCRRHH.Bitacora
{
    /// <summary>
    /// Summary description for EventoBitacoraSearch
    /// </summary>
    public class EventoBitacoraSearch : ConfigColumns
    {
        public EventoBitacoraSearch()
        {
            Column col = new Column("[id]", "id", Column.ColumnType.Numeric);
            col.AppearInStandardSearch = false;
            col.Description = "El identificador del evento de la bitácora";
            col.DisplayHelp = true;
            this.Cols.Add(col);

            col = new Column("fecha", "fecha", Column.ColumnType.Date);
            col.AppearInStandardSearch = false;
            col.DisplayHelp = true;
            col.Description = "La fecha/hora en que ocurrió el evento";
            this.Cols.Add(col);

            col = new Column("tipoEvento", "evento", Column.ColumnType.String);
            col.AppearInStandardSearch = true;
            col.Description = "El tipo de evento que aparece en la bitácora";
            col.DisplayHelp = true;
            this.Cols.Add(col);

            col = new Column("empleado", "usuario", Column.ColumnType.String);
            col.AppearInStandardSearch = true;
            col.Description = "El usuario que realizó el evento";
            col.DisplayHelp = true;
            this.Cols.Add(col);

            col = new Column("tipoObjeto", "tipoObjeto", Column.ColumnType.String);
            col.AppearInStandardSearch = true;
            col.Description = "El objeto que intervino en el evento grabado en la bitácora";
            col.DisplayHelp = true;
            this.Cols.Add(col);

            col = new Column("idObjeto", "idObjeto", Column.ColumnType.String);
            col.AppearInStandardSearch = true;
            col.Description = "El identificador del objeto que intervino en el evento";
            col.DisplayHelp = true;
            this.Cols.Add(col);

            col = new Column("mensaje", "mensaje", Column.ColumnType.String);
            col.AppearInStandardSearch = true;
            col.Description = "El mensaje con el que se grabó el evento en la bitácora";
            col.DisplayHelp = true;
            this.Cols.Add(col);
        }
    }
}