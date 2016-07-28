using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using KPIDataTimeDSTableAdapters;

namespace Artexacta.App.KPI.BLL
{
    /// <summary>
    /// Summary description for KPIDataTimeBLL
    /// </summary>
    public class KPIDataTimeBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        KPIDataTimeTableAdapter _theAdapter = null;

        protected KPIDataTimeTableAdapter theAdapter
        {
            get
            {
                if (_theAdapter == null)
                    _theAdapter = new KPIDataTimeTableAdapter();
                return _theAdapter;
            }
        }

        public KPIDataTimeBLL()
        {
        }

        private static KPIDataTime FillRecord(KPIDataTimeDS.KPIDataTimeRow row)
        {
            KPIDataTime theNewRecord = new KPIDataTime(
                row.IsyearNull() ? 0 : row.year,
                row.IsmonthNull() ? 0 : row.month,
                row.IsdayNull() ? 0 : row.day,
                row.IshourNull() ? 0 : row.hour,
                row.IsminuteNull() ? 0 : row.minute);

            return theNewRecord;
        }

        public static KPIDataTime GetKPIDataTimeFromValue(decimal value)
        {
            if (value <= 0)
                throw new ArgumentException("The value cannor be zero.");

            KPIDataTime theData = null;
            try
            {
                KPIDataTimeTableAdapter localAdapter = new KPIDataTimeTableAdapter();
                KPIDataTimeDS.KPIDataTimeDataTable theTable = localAdapter.GetKPIDataTimeFromValue(value);
                if (theTable != null && theTable.Rows.Count > 0)
                {
                    KPIDataTimeDS.KPIDataTimeRow theRow = theTable[0];
                    theData = FillRecord(theRow);
                }
            }
            catch (Exception exc)
            {
                log.Error("Error en GetKPIDataTimeFromValue para value: " + value, exc);
                throw exc;
            }

            return theData;
        }

        public static decimal GetValueFromKPIDataTime(KPIDataTime theData)
        {
            if (theData.Year <= 0 && theData.Month <= 0 && theData.Day <= 0 && theData.Hour <= 0 && theData.Minute <= 0)
                throw new ArgumentException("The data cannot be zero.");

            decimal? valor = 0;
            try
            {
                KPIDataTimeTableAdapter localAdapter = new KPIDataTimeTableAdapter();
                localAdapter.GetValueFromKPIDataTime(theData.Year, theData.Month, theData.Day, theData.Hour, theData.Minute, ref valor);
            }
            catch (Exception ex)
            {
                log.Error("Error en GetValueFromKPIDataTime para los datos year: " + theData.Year + ", month: " + theData.Month +
                    ", day: " + theData.Day + ", hour: " + theData.Hour + " y minute: " + theData.Minute, ex);
                throw ex;
            }

            return Convert.ToDecimal(valor);
        }

    }
}