using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.Dashboard.BLL
{
    /// <summary>
    /// Summary description for UserDashboardBLL
    /// </summary>
    public class UserDashboardBLL
    {
        public UserDashboardBLL()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        public static List<UserDashboard> GetUserDashboards(int userId)
        {
            if (userId <= 0)
                throw new ArgumentException("userId cannot be equals or less than zero");

            DashboardDSTableAdapters.UserDashboardsTableAdapter adapter = new DashboardDSTableAdapters.UserDashboardsTableAdapter();
            DashboardDS.UserDashboardsDataTable table = adapter.GetUserDashboardsByUser(userId);
            List<UserDashboard> list = new List<UserDashboard>();

            foreach (var row in table)
            {
                list.Add(new UserDashboard()
                {
                    DashboardId = row.dashboardId,
                    Name = row.name,
                    OwnerUserId = row.ownerUserId
                });
            }
            return list;
        }

        public static UserDashboard GetUserDashboardById(int dashboardId)
        {
            if (dashboardId <= 0)
                throw new ArgumentException("dashboardId cannot be equals or less than zero");

            DashboardDSTableAdapters.UserDashboardsTableAdapter adapter = new DashboardDSTableAdapters.UserDashboardsTableAdapter();
            DashboardDS.UserDashboardsDataTable table = adapter.GetUserDashboardById(dashboardId);
            DashboardDS.UserDashboardsRow row = table[0];

            UserDashboard obj = new UserDashboard()
            {
                DashboardId = row.dashboardId,
                Name = row.name,
                OwnerUserId = row.ownerUserId
            };
            return obj;
        }

        public static List<UserDashboard> GetUserDashboardsByKpiId(int kpiId, int userId)
        {
            if (kpiId <= 0)
                throw new ArgumentException("kpiId cannot be equals or less than zero");

            if (userId <= 0)
                throw new ArgumentException("userId cannot be equals or less than zero");
            DashboardDSTableAdapters.UserDashboardsTableAdapter adapter = new DashboardDSTableAdapters.UserDashboardsTableAdapter();
            DashboardDS.UserDashboardsDataTable table = adapter.GetUserDashboardByKpiId(kpiId, userId);
            List<UserDashboard> list = new List<UserDashboard>();

            foreach (var row in table)
            {
                list.Add(new UserDashboard()
                {
                    DashboardId = row.dashboardId,
                    Name = row.name,
                    OwnerUserId = row.ownerUserId
                });
            }
            return list;
        }

        public static List<UserDashboard> GetUserDashboardWhenKpiIdIsNotIn(int kpiId, int userId)
        {
            if (kpiId <= 0)
                throw new ArgumentException("kpiId cannot be equals or less than zero");

            if (userId <= 0)
                throw new ArgumentException("userId cannot be equals or less than zero");
            DashboardDSTableAdapters.UserDashboardsTableAdapter adapter = new DashboardDSTableAdapters.UserDashboardsTableAdapter();
            DashboardDS.UserDashboardsDataTable table = adapter.GetUserDashboardWhenKpiIdIsNotIn(kpiId, userId);
            List<UserDashboard> list = new List<UserDashboard>();

            foreach (var row in table)
            {
                list.Add(new UserDashboard()
                {
                    DashboardId = row.dashboardId,
                    Name = row.name,
                    OwnerUserId = row.ownerUserId
                });
            }
            return list;
        }

        public static int InsertUserDashboard(string name, int ownserUserId)
        {
            if (string.IsNullOrEmpty(name))
                throw new ArgumentException("name cannot be null or empty");

            if(ownserUserId <= 0)
                throw new ArgumentException("ownserUserId cannot be equals or less than zero");

            int? dashboardId = 0;
            DashboardDSTableAdapters.UserDashboardsTableAdapter adapter = new DashboardDSTableAdapters.UserDashboardsTableAdapter();
            adapter.InsertUserDashboard(name, ownserUserId, ref dashboardId);

            if (dashboardId == null || dashboardId.Value <= 0)
                throw new Exception("Error when SP trying to generate primary key");

            return dashboardId.Value;
        }

        public static void UpdateUserDashboard(int dashboardId, string name)
        {
            if (string.IsNullOrEmpty(name))
                throw new ArgumentException("name cannot be null or empty");

            if (dashboardId <= 0)
                throw new ArgumentException("dashboardId cannot be equals or less than zero");

            DashboardDSTableAdapters.UserDashboardsTableAdapter adapter = new DashboardDSTableAdapters.UserDashboardsTableAdapter();
            adapter.UpdateUserDashboard(name, dashboardId);
        }
        
        public static void DeleteUserDashboard(int dashboardId)
        {
            if (dashboardId <= 0)
                throw new ArgumentException("dashboardId cannot be equals or less than zero");

            DashboardDSTableAdapters.UserDashboardsTableAdapter adapter = new DashboardDSTableAdapters.UserDashboardsTableAdapter();
            adapter.DeleteUserDashboard(dashboardId);
        }
    }
}