using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.KPI
{
    /// <summary>
    /// Summary description for KPITargetTime
    /// </summary>
    public class KPITargetTime
    {
        public int TargetID{get; set;}
        public int KpiID {get; set; }
        public int Year {get; set;}
        public int Month { get; set; }
        public int Day { get; set; }
        public int Hour { get; set; }
        public int Minute { get; set; }

        public KPITargetTime()
        {
        }

        public KPITargetTime(int targetID, int kpiID, int year, int month, int day, int hour, int minute)
        {
            this.TargetID = targetID;
            this.KpiID = kpiID;
            this.Year = year;
            this.Month = month;
            this.Day = day;
            this.Hour = hour;
            this.Minute = minute;
        }
    }
}