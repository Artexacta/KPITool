using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.KPI
{
    /// <summary>
    /// Summary description for KPITarget
    /// </summary>
    public class KPITarget
    {
        public int TargetID{get; set;}
        public int KpiID {get; set; }
        public decimal Target {get; set;}
        public string Detalle { get; set; }
        public string Categories { get; set; }

        public KPITarget()
        {
        }

        public KPITarget(int targetID, int kpiID, decimal target)
        {
            this.TargetID = targetID;
            this.KpiID = kpiID;
            this.Target = target;
        }
    }
}