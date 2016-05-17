using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.Dashboard
{
    /// <summary>
    /// Summary description for KpiDashboard
    /// </summary>
    public class KpiDashboard
    {
        public int KpiDashboardId { get; set; }
        public int KpiId { get; set; }
        public int DashboardId { get; set; }
        public int OwnerUserId { get; set; }
        public string KpiName { get; set; }

        public KpiDashboard()
        {
            ;
        }
    }
}