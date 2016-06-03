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

        public KPICategoyCombination()
        {
        }

        public KPICategoyCombination(string itemsList, string categoriesList)
        {
            this.ItemsList = itemsList;
            this.CategoriesList = categoriesList;
        }
    }
}