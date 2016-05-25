using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.KPI
{
    /// <summary>
    /// Summary description for KpiChartData
    /// </summary>
    public class KpiChartData
    {
        public string Period { get; set; }
        public decimal Measurement { get; set; }

        public KpiChartData()
        {
            //
            // TODO: Add constructor logic here
            //
        }
    }
}