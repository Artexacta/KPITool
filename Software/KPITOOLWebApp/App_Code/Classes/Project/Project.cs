using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for Project
/// </summary>
/// 
namespace Artexacta.App.Project
{
    public class Project
    {
        public int ProjectID { get; set; }
        public string Name { get; set; }
        public int OrganizationID { get; set; }
        public int AreaID { get; set; }
        public string OrganizationName { get; set; }
        public string AreaName { get; set; }
        public int NumberOfKpis { get; set; }
        public bool IsOwner { get; set; }
        public string Owner { get; set; }

        public Project()
        {
        }

        public Project(int projectId, string name, int organizationId, int areaId)
        {
            ProjectID = projectId;
            Name = name;
            OrganizationID = organizationId;
            AreaID = areaId;
        }

        public string NumberOfKpisForDisplay
        {
            get { return NumberOfKpis + " KPIs"; }
        }
    }
}