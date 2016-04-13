using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.Seguimiento
{
    /// <summary>
    /// Summary description for KPICampana
    /// </summary>
    public class KPICampana
    {
        public int idCampana { get; set; }
        public int semana { get; set; }
        public List<KPIDetalle> valoresKPIs { get; set; }

        public KPICampana()
        {
        }

        public KPICampana(int _idCampana, int _semana)
        {
            this.idCampana = _idCampana;
            this.semana = _semana;
            valoresKPIs = new List<KPIDetalle>();
        }
    }
}