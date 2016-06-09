using Artexacta.App.Categories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Transactions;
using System.Data.SqlClient;
using System.Configuration;
using log4net;
using KPITargetDSTableAdapters;

namespace Artexacta.App.KPI.BLL
{
    /// <summary>
    /// BLL for handling KPIs
    /// </summary>
    [System.ComponentModel.DataObject]
    public class KPITargetCategoryBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        KPITargetCategoriesTableAdapter _theAdapter = null;

        protected KPITargetCategoriesTableAdapter theAdapter
        {
            get
            {
                if (_theAdapter == null)
                    _theAdapter = new KPITargetCategoriesTableAdapter();
                return _theAdapter;
            }
        }

        public KPITargetCategoryBLL()
        {
        }

        private static KPITargetCategory FillRecord(KPITargetDS.KPITargetCategoriesRow row)
        {
            KPITargetCategory theNewRecord = new KPITargetCategory(
                row.targetID,
                row.detalle,
                row.target);

            return theNewRecord;
        }

        public static List<KPITargetCategory> GetKPITargetCategoriesByKpiId(int kpiId)
        {
            if (kpiId <= 0)
                throw new ArgumentException("El ID del KPI no puede ser cero.");

            List<KPITargetCategory> theList = new List<KPITargetCategory>();
            KPITargetCategory theData = null;

            try
            {
                KPITargetCategoriesTableAdapter localAdapter = new KPITargetCategoriesTableAdapter();
                KPITargetDS.KPITargetCategoriesDataTable theTable = localAdapter.GetKPITargetCategoriesByKpiId(kpiId);
                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (KPITargetDS.KPITargetCategoriesRow theRow in theTable)
                    {
                        theData = FillRecord(theRow);
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception exc)
            {
                log.Error("Ocurrió un error mientras se obtenía el KPI Category de id: " + kpiId, exc);
                throw exc;
            }

            return theList;
        }

        /// <summary>
        /// Add or delete a categoryTarget by KPI
        /// </summary>
        /// <param name="kpiId"></param>
        /// <param name="categoryId"></param>
        /// <param name="operation">1: Insert 2: Delete</param>
        public static void AddDeleteCategoryByKpi(int kpiId, string categoryId, int operation)
        {
            if (kpiId <= 0)
                throw new ArgumentException("El ID del KPI no puede ser cero.");

            try
            {
                KPITargetCategoriesTableAdapter localAdapter = new KPITargetCategoriesTableAdapter();
                localAdapter.AddDeleteCategoryTargetByKpi(kpiId, categoryId, operation);
            }
            catch (Exception ex)
            {
                log.Error("Error to add or delete the KPI Target Category.", ex);
                throw ex;
            }
        }

    }
}