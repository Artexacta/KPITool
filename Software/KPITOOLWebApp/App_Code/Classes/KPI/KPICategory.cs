using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.KPI
{
    /// <summary>
    /// Summary description for KPICategory
    /// </summary>
    public class KPICategory
    {
        public int KpiId { get; set; }
        public string CategoryId { get; set; }
        public string CategoryName { get; set; }
        public string CategoryItemId { get; set; }
        public string CategoryItemName { get; set; }

        public string HtmlId {
            get
            {
                return (CategoryId + "-" + CategoryItemId).Replace(" ", "-");
            }
        }

        public string ObjectForDisplay
        {
            get
            {
                return CategoryName + " - " + CategoryItemName + " (" + CategoryId + "," + CategoryItemId + ")";
            }
        }

        public KPICategory()
        {
            
        }
    }
}