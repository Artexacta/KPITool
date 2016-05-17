using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.Dashboard
{

    /// <summary>
    /// Summary description for UserDashboard
    /// </summary>
    public class UserDashboard
    {
        public int DashboardId { get; set; }
        public string Name { get; set; }
        public int OwnerUserId { get; set; }

        public UserDashboard()
        {
            Name = "";
        }
    }
}