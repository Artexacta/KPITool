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
    public class KPITargetBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        KPITargetTableAdapter _theAdapter = null;

        protected KPITargetTableAdapter theAdapter
        {
            get
            {
                if (_theAdapter == null)
                    _theAdapter = new KPITargetTableAdapter();
                return _theAdapter;
            }
        }

        public KPITargetBLL()
        {
        }

        private static KPITarget FillRecord(KPITargetDS.KPITargetRow row)
        {
            KPITarget theNewRecord = new KPITarget(
                row.targetID,
                row.kpiID,
                row.target);

            return theNewRecord;
        }

        public static KPITarget GetKPITargetByKpiId(int kpiId)
        {
            if (kpiId <= 0)
                throw new ArgumentException("El ID del KPI no puede ser cero.");

            KPITarget theData = null;
            try
            {
                KPITargetTableAdapter localAdapter = new KPITargetTableAdapter();
                KPITargetDS.KPITargetDataTable theTable = localAdapter.GetKPITargetById(kpiId);
                if (theTable != null && theTable.Rows.Count > 0)
                {
                    KPITargetDS.KPITargetRow theRow = theTable[0];
                    theData = FillRecord(theRow);
                }
            }
            catch (Exception exc)
            {
                log.Error("Ocurrió un error mientras se obtenía el KPI Target de id: " + kpiId, exc);
                throw exc;
            }

            return theData;
        }

    }
}