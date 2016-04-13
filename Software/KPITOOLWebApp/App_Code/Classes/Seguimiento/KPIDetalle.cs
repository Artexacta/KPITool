using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.Seguimiento
{
    /// <summary>
    /// Summary description for KPIDetalle
    /// </summary>
    public class KPIDetalle
    {
        public string descripcion { get; set; }
        public int orden { get; set; }
        public int anterior { get; set; }
        public int actual { get; set; }

        public KPIDetalle()
        {
        }

        public KPIDetalle(string _descripcion, int _orden, int _anterior, int _actual)
        {
            this.descripcion = _descripcion;
            this.orden = _orden;
            this.anterior = _anterior;
            this.actual = _actual;
        }
    }
}