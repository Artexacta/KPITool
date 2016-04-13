using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Web;

namespace Artexacta.App.FRTWB
{
    /// <summary>
    /// Summary description for Kpi
    /// </summary>
    public class Kpi : FrtwbObject
    {
        #region Id generation

        private static object lockedObject = new Object();
        private static int currentId = 1;
        public Dictionary<string, KpiData> KpiValues { get; set; }
        public UnitType KpiUnitType { get; set; }
        public TypeDirection KpiSelectedDirection { get; set; }
        public GroupingStrategy KpiGroupingStrategy { get; set; }
        public ReportingPeriod KpiReportingPeriod { get; set; }
        public int ReportingUnits { get; set; }
        public ReportingPeriod ReportingUnitsPeriod { get; set; }
        public string KpiTarget { get; set; }
        public string WebServiceID { get; set; }
        private static int GetNextId()
        {
            int result = 0;
            Monitor.Enter(lockedObject);
            result = currentId++;
            Monitor.Exit(lockedObject);
            return result;
        }

        #endregion

        public int Progress { get; set; }
        public KpiType KpiType { get; set; }
        public Kpi()
        {
            ObjectId = GetNextId();
            KpiValues = new Dictionary<string, KpiData>();
            Type = "KPI";

            Random random = new Random();
            Progress = random.Next(0, 100); ;
        }
    }
    public enum ReportingPeriod
    {
        YEAR,
        SEMESTER,
        QUARTER,
        MONTH,
        WEEK,
        DAY
    }
    public enum Currency
    {
        US_DOLLARS,
        EUROS
    }
    public enum MoneyMeasurements
    {
        BILLIONS,
        CRORES,
        MILLIONS,
        LAKHS,
        THOUSANDS
    }
}