using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.KPI
{
    /// <summary>
    /// Summary description for KPICategoyCombination
    /// </summary>
    public class KPICategoyCombination
    {
        public string ItemsList { get; set; }
        public string CategoriesList { get; set; }
        public int KpiId { get; set; }

        public KPICategoyCombination()
        {
        }

        public string HtmlId
        {
            get
            {
                return (ItemsList + "-" + CategoriesList).Replace(" ", "-").Replace(",","-");
            }
        }

        public KPICategoyCombination(string itemsList, string categoriesList)
        {
            this.ItemsList = itemsList;
            this.CategoriesList = categoriesList;
        }
    }
}