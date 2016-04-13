using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Web;

namespace Artexacta.App.FRTWB
{
    /// <summary>
    /// Summary description for Activity
    /// </summary>
    public class Activity : FrtwbObject
    {
        private static object lockedObject = new Object();
        private static int currentId = 1;

        private static int GetNextId()
        {
            int result = 0;
            Monitor.Enter(lockedObject);
            result = currentId++;
            Monitor.Exit(lockedObject);
            return result;
        }

        public Dictionary<int, Kpi> Kpis { get; set; }

        public string NumerOfKpisForDisplay
        {
            get { return Kpis.Count + " KPIs"; }
        }

        public int NumerOfKpis
        {
            get { return Kpis.Count; }
        }

        public Activity()
        {
            ObjectId = GetNextId();
            Type = "Activity";
            Kpis = new Dictionary<int, Kpi>();
        }
    }
}