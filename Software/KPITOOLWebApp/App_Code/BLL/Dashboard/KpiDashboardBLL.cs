using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.Dashboard.BLL
{
    /// <summary>
    /// Summary description for KpiDashboard
    /// </summary>
    public class KpiDashboardBLL
    {
        public KpiDashboardBLL()
        {
            
        }

        public static void InsertKpiToDashboard(int kpiId, int dashboardId, int userId)
        {
            if (kpiId <= 0)
                throw new ArgumentException("KpiId cannot be equals or less than zero");

            if (dashboardId < 0)
                throw new ArgumentException("dashboardId cannot be less than zero");

            if (userId <= 0)
                throw new ArgumentException("userId cannot be equals or less than zero");

            DashboardDSTableAdapters.KpiDashboardTableAdapter adapter = new DashboardDSTableAdapters.KpiDashboardTableAdapter();
            adapter.InsertKpiToDashboard(dashboardId, kpiId, userId);
        }

        public static void DeleteKpiDashboard(int dashboardId, int userId, int kpiId)
        {
            if(kpiId <= 0)
                throw new ArgumentException("KpiId cannot be equals or less than zero");

            if (dashboardId < 0)
                throw new ArgumentException("dashboardId cannot be less than zero");

            if (userId <= 0)
                throw new ArgumentException("userId cannot be equals or less than zero");

            DashboardDSTableAdapters.KpiDashboardTableAdapter adapter = new DashboardDSTableAdapters.KpiDashboardTableAdapter();
            adapter.DeleteKpiDashboard(kpiId, userId, dashboardId);

        }

        public static List<KpiDashboard> GetKpiDashboard(int dashboardId, int userId)
        {
            if (dashboardId < 0)
                throw new ArgumentException("dashboardId cannot be less than zero");

            if (userId <= 0)
                throw new ArgumentException("userId cannot be equals or less than zero");

            DashboardDSTableAdapters.KpiDashboardTableAdapter adapter = new DashboardDSTableAdapters.KpiDashboardTableAdapter();
            DashboardDS.KpiDashboardDataTable table = adapter.GetKpisFromDashboard(dashboardId, userId);

            List<KpiDashboard> list = new List<KpiDashboard>();
            foreach (var row in table)
            {
                list.Add(new KpiDashboard()
                {
                    KpiDashboardId = row.kpiDashboardId,
                    KpiId = row.kpiId,
                    DashboardId = row.IsdashboardIdNull() ? 0 : row.dashboardId ,
                    OwnerUserId = row.ownerUserId,
                    KpiName = row.name
                });
            }
            return list;
        }
    }
}