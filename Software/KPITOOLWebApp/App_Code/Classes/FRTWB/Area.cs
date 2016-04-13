using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Web;

namespace Artexacta.App.FRTWB
{
    /// <summary>
    /// Summary description for Area
    /// </summary>
    public class Area : FrtwbObject
    {
        #region Id Generation

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


        public Dictionary<int, Project> Projects { get; set; }
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

        public Area()
        {
            ObjectId = GetNextId();
            Type = "Area";
            Projects = new Dictionary<int, Project>();
            Activities = new Dictionary<int, Activity>();
            Kpis = new Dictionary<int, Kpi>();
        }

        public List<Project> GetProjectsToList()
        {
            return Projects.Values.ToList();
        }
    }
}