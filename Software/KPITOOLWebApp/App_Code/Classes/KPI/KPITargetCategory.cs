using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.KPI
{
    /// <summary>
    /// Summary description for KPITargetCategory
    /// </summary>
    public class KPITargetCategory
    {
        public int TargetID { get; set; }
        public string Detalle { get; set; }
        public decimal Target { get; set; }

        public KPITargetCategory()
        {
        }

        public KPITargetCategory(int targetID, string detalle, decimal target)
        {
            this.TargetID = targetID;
            this.Detalle = detalle;
            this.Target = target;
        }
    }
}