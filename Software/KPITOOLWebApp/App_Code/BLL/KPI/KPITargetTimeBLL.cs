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
    public class KPITargetTimeBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        KPITargetTimeTableAdapter _theAdapter = null;

        protected KPITargetTimeTableAdapter theAdapter
        {
            get
            {
                if (_theAdapter == null)
                    _theAdapter = new KPITargetTimeTableAdapter();
                return _theAdapter;
            }
        }

        public KPITargetTimeBLL()
        {
        }

        private static KPITargetTime FillRecord(KPITargetDS.KPITargetTimeRow row)
        {
            KPITargetTime theNewRecord = new KPITargetTime(
                row.targetID,
                row.kpiID,
                row.IsyearNull() ? 0 : row.year,
                row.IsmonthNull() ? 0 : row.month,
                row.IsdayNull() ? 0 : row.day,
                row.IshourNull() ? 0 : row.hour,
                row.IsminuteNull() ? 0 : row.minute);

            return theNewRecord;
        }

        public static KPITargetTime GetKPITargetTimeByKpi(int kpiId)
        {
            if (kpiId <= 0)
                throw new ArgumentException("El ID del KPI no puede ser cero.");

            KPITargetTime theData = null;
            try
            {
                KPITargetTimeTableAdapter localAdapter = new KPITargetTimeTableAdapter();
                KPITargetDS.KPITargetTimeDataTable theTable = localAdapter.GetKPITargetTimeFromKpi(kpiId);
                if (theTable != null && theTable.Rows.Count > 0)
                {
                    KPITargetDS.KPITargetTimeRow theRow = theTable[0];
                    theData = FillRecord(theRow);
                }
            }
            catch (Exception exc)
            {
                log.Error("Ocurrió un error mientras se obtenía el KPI Target Time de id: " + kpiId, exc);
                throw exc;
            }

            return theData;
        }

        public static decimal GetNumberFromTime(int year, int month, int day, int hour, int minute)
        {
            double? valor = 0;

            if (year <= 0 && month <= 0 && day <= 0 && hour <= 0 && minute <= 0)
                throw new ArgumentException("Los valores son inválidos.");

            KPITargetTimeTableAdapter localAdapter = new KPITargetTimeTableAdapter();

            try
            {
                localAdapter.GetNumberFromTime(year, month, day, hour, minute, ref valor);
            }
            catch (Exception ex)
            {
                log.Error("Error al obtener el valor decimal de un time.", ex);
                throw ex;
            }

            return Convert.ToDecimal(valor);
        }

    }
}