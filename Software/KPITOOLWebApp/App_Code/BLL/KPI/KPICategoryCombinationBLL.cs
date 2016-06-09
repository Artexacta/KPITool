using Artexacta.App.Categories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Transactions;
using System.Data.SqlClient;
using System.Configuration;
using log4net;
using KPICategoryCombinationDSTableAdapters;

namespace Artexacta.App.KPI.BLL
{
    /// <summary>
    /// BLL for handling KPIs
    /// </summary>
    [System.ComponentModel.DataObject]
    public class KPICategoryCombinationBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        KPICombinationCategoryTableAdapter _theAdapter = null;

        protected KPICombinationCategoryTableAdapter theAdapter
        {
            get
            {
                if (_theAdapter == null)
                    _theAdapter = new KPICombinationCategoryTableAdapter();
                return _theAdapter;
            }
        }

        public KPICategoryCombinationBLL()
        {
        }

        private static KPICategoyCombination FillRecord(KPICategoryCombinationDS.KPICombinationCategoryRow row)
        {
            KPICategoyCombination theNewRecord = new KPICategoyCombination(
                row.productoId,
                row.categoriesId);

            return theNewRecord;
        }

        public static List<KPICategoyCombination> GetKPITargetCategoriesByKpiId(List<Category> theCategories)
        {
            if (theCategories == null || theCategories.Count <= 0)
                throw new ArgumentException("No se tiene la lista de categorias.");

            string categories = "";

            foreach (Category cat in theCategories)
            {
                categories =  string.IsNullOrEmpty(categories) ? cat.ID : categories + "," + cat.ID;
            }
            
            List<KPICategoyCombination> theList = new List<KPICategoyCombination>();
            KPICategoyCombination theData = null;

            try
            {
                KPICombinationCategoryTableAdapter localAdapter = new KPICombinationCategoryTableAdapter();
                KPICategoryCombinationDS.KPICombinationCategoryDataTable theTable = localAdapter.GetCombinationCategoryItems(categories);
                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (KPICategoryCombinationDS.KPICombinationCategoryRow theRow in theTable)
                    {
                        theData = FillRecord(theRow);
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception exc)
            {
                log.Error("Error en GetKPITargetCategoriesByKpiId.", exc);
                throw exc;
            }

            return theList;
        }

        public static List<KPICategoyCombination> GetCategoryItemsCombinatedByKpiId(int kpiId)
        {
            if (kpiId <= 0)
                throw new ArgumentException("El ID del KPI no puede ser cero.");

            List<KPICategoyCombination> theList = new List<KPICategoyCombination>();
            KPICategoyCombination theData = null;
            try
            {
                KPICombinationCategoryTableAdapter localAdapter = new KPICombinationCategoryTableAdapter();
                KPICategoryCombinationDS.KPICombinationCategoryDataTable theTable = localAdapter.GetCategoryItemsCombinatedByKpiId(kpiId);
                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (KPICategoryCombinationDS.KPICombinationCategoryRow theRow in theTable)
                    {
                        theData = FillRecord(theRow);
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception exc)
            {
                log.Error("Error en GetCategoryItemsCombinatedByKpiId para kpiId: " + kpiId, exc);
                throw exc;
            }

            return theList;
        }

    }
}