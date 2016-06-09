using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for Area
/// </summary>
/// 
namespace Artexacta.App.Area
{
    public class Area
    {

        public int AreaID { get; set; }
        public int OrganizationID { get; set; }
        public string Name { get; set; }
        public string OrganizationName { get; set; }
        public int NumberOfKpis { get; set; }

        public Area()
        {
        }

        public Area(int areaId, int organizationId, string name)
        {
            AreaID = areaId;
            OrganizationID = organizationId;
            Name = name;
        }

        public string NumberOfKpisForDisplay
        {
            get { return NumberOfKpis + " KPIs"; }
        }

    }
}