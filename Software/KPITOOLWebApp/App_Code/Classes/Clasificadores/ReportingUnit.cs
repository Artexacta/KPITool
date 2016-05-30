using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.ReportingUnit
{
    /// <summary>
    /// Summary description for ReportingUnit
    /// </summary>
    public class ReportingUnit
    {
        public string ReportingUnitID { get; set; }
        public string Name { get; set; }
                        
        public ReportingUnit()
        {
        }

        public ReportingUnit(string reportingUnitID, string name)
        {
            this.ReportingUnitID = reportingUnitID;
            this.Name = name;
        }

    }
}