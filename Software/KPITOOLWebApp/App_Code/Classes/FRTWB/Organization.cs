using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Web;

namespace Artexacta.App.FRTWB
{
    /// <summary>
    /// Summary description for Organization
    /// </summary>
    public class Organization : FrtwbObject
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


        public Dictionary<int, Area> Areas { get; set; }
        public Dictionary<int, Project> Projects { get; set; }
        public Dictionary<int, Activity> Activities { get; set; }
        public Dictionary<int, Kpi> Kpis { get; set; }

        public int NumerOfKpis
        {
            get { return Kpis.Count; }
        }

        public Organization()
        {
            ObjectId = GetNextId();
            Type = "Organization";
            Areas = new Dictionary<int, Area>();
            Projects = new Dictionary<int, Project>();
            Activities = new Dictionary<int, Activity>();
            Kpis = new Dictionary<int, Kpi>();

        }

        public List<Area> GetAreasToList()
        {
            return Areas.Values.ToList();
        }

        public List<Project> GetProjectsToList()
        {
            List<Project> myProjects = Projects.Values.ToList();
            foreach (var area in Areas.Values)
	        {
                myProjects.Concat(area.GetProjectsToList());
	        }

            return myProjects;
        }

        public List<Activity> GetActivitisToList()
        {
            List<Activity> myActivities = Activities.Values.ToList();

            //Getting activities from organization projects  (own and project areas)
            List<Project> myProjects = GetProjectsToList();
            foreach (var project in myProjects)
            {
                myActivities.Concat(project.Activities.Values);
            }

            //Getting activities from organization areas
            foreach (var area in Areas.Values)
            {
                myActivities.Concat(area.Activities.Values);
            }

            return myActivities;
        }
    }
}