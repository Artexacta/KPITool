using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.KPI
{
    /// <summary>
    /// Summary description for KPI
    /// </summary>
    public class KPIType
    {
        public string KpiTypeID { get; set; }
        public string DirectionID { get; set; }
        public string StrategyID { get; set; }
        public string UnitID { get; set; }
        public string TypeName { get; set; }
        public string Description { get; set; }

        public KPIType()
        {
        }

        public KPIType(string kpiTypeID,
            string directionID,
            string strategyID,
            string unitID,
            string typeName,
            string description)
        {
            this.KpiTypeID = kpiTypeID;
            this.DirectionID = directionID;
            this.StrategyID = strategyID;
            this.UnitID = unitID;
            this.TypeName = typeName;
            this.Description = description;
        }

    }
}