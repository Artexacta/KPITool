using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.KPI
{
    /// <summary>
    /// This class is used to represent a single KPI measurement
    /// </summary>
    public class KPIMeasurement
    {
        public int KPIID { get; set; }
        public DateTime Date { get; set; }
        public decimal Measurement { get; set; }
        public string CategoryID { get; set; }
        public string CategoryItemID { get; set; }
        public string Unit { get; set; }

        public string MeasurementForDisplay
        {
            get
            {
                return Measurement.ToString("#.##") + (string.IsNullOrEmpty(Unit) ? "" : " " + Unit);
            }
        }

        public string DateForDisplay
        {
            get { return Date.ToString("yyyy-MM-dd"); }
        }

        public KPIMeasurement()
        {
        }

        /// <summary>
        /// Creates a new KPI measurement
        /// </summary>
        /// <param name="kpiID">The KPI ID</param>
        /// <param name="date">The data for the measurement</param>
        /// <param name="measurement">The actual measurement.  Timespans are recorded as Ticks (see https://msdn.microsoft.com/en-us/library/system.timespan.ticks(v=vs.110).aspx </param>
        /// <param name="categoryID">The CateogryID if any.  If none, use "" </param>
        /// <param name="categoryItemID">the CategoryItemID.  If none, use "" </param>
        public KPIMeasurement(int kpiID, DateTime date, decimal measurement, string categoryID, string categoryItemID)
        {
            KPIID = kpiID;
            Date = date;
            Measurement = measurement;
            CategoryID = categoryID;
            CategoryItemID = categoryItemID;
        }
    }
}