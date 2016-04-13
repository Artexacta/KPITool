using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Web;

namespace Artexacta.App.FRTWB
{
    /// <summary>
    /// Summary description for Project
    /// </summary>
    public class Project : FrtwbObject
    {
        #region Id generation

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

        #endregion

        public Dictionary<int, Activity> Activities { get; set; }
        public Dictionary<int, Kpi> Kpis { get; set; }
        
        public string NumerOfKpisForDisplay
        {
            get { return Kpis.Count + " KPIs"; }
        }

        public int NumerOfKpis
        {
            get { return Kpis.Count; }
        }

        public Project()
        {
            ObjectId = GetNextId();
            Type = "Project";
            Activities = new Dictionary<int, Activity>();
            Kpis = new Dictionary<int, Kpi>();
        }

    }
}