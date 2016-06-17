using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.KPI.BLL
{
    /// <summary>
    /// Summary description for KPICategory
    /// </summary>
    public class KPICategoryBLL
    {
        public KPICategoryBLL()
        {
            
        }

        public static List<KPICategory> GetKpiCategoriesByKpiId(int kpiId)
        {
            if (kpiId <= 0)
            {
                throw new ArgumentException("KpiId cannot be equals or less than zero");
            }

            KPICategoryDSTableAdapters.KpiCategoryTableAdapter adapter = new KPICategoryDSTableAdapters.KpiCategoryTableAdapter();
            KPICategoryDS.KpiCategoryDataTable table = adapter.GetKpiCategories(kpiId);

            List<KPICategory> list = new List<KPICategory>();
            foreach (var row in table)
            {
                list.Add(new KPICategory()
                {
                    KpiId = kpiId,
                    CategoryId = row.categoryID,
                    CategoryName = row.categoryName,
                    CategoryItemId = row.categoryItemID,
                    CategoryItemName = row.categoryItemName
                });
            }
            return list;
        }
    }
}