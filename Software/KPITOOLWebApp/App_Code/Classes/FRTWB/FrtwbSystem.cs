using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.FRTWB
{
    /// <summary>
    /// Summary description for FrtwbSystem
    /// </summary>
    public class FrtwbSystem
    {
        private static FrtwbSystem theInstance;

        public Dictionary<int, Organization> Organizations { get; set; }

        public Dictionary<int, Area> Areas { get; set; }
        public Dictionary<int, Project> Projects { get; set; }
        public Dictionary<int, Activity> Activities { get; set; }
        public Dictionary<int, Kpi> Kpis { get; set; }

        public Dictionary<int, KpiType> KpiTypes { get; set; }
        
        public static FrtwbSystem Instance
        {
            get
            {
                if (theInstance == null)
                    theInstance = new FrtwbSystem();

                return theInstance;
            }
        }

        public static void Reset()
        {
            theInstance = null;
        }

        private FrtwbSystem()
        {
            Organizations = new Dictionary<int, Organization>();
            Areas = new Dictionary<int, Area>();
            Projects = new Dictionary<int, Project>();
            Activities = new Dictionary<int, Activity>();
            Kpis = new Dictionary<int, Kpi>();
            KpiTypes = new Dictionary<int, KpiType>();
                       

            KpiTypes = new Dictionary<int, KpiType>() {
                { 1,new KpiType() { Id=1,Name="Overall Equipment Effectiveness",KpiTypeUnitType=UnitType.PERCENTAGE,KpiTypeDirection=TypeDirection.MAXIMIZE,KpiGroupingStrategy=GroupingStrategy.AVERAGE_OVER_PERIOD} },
                { 2,new KpiType() { Id=2,Name="Availability",KpiTypeUnitType=UnitType.PERCENTAGE,KpiTypeDirection=TypeDirection.MAXIMIZE,KpiGroupingStrategy=GroupingStrategy.AVERAGE_OVER_PERIOD} },
                { 3,new KpiType() { Id=3,Name="Performance",KpiTypeUnitType=UnitType.PERCENTAGE,KpiTypeDirection=TypeDirection.MAXIMIZE,KpiGroupingStrategy=GroupingStrategy.AVERAGE_OVER_PERIOD} },
                { 4,new KpiType() { Id=4,Name="Quality",KpiTypeUnitType=UnitType.PERCENTAGE,KpiTypeDirection=TypeDirection.MAXIMIZE,KpiGroupingStrategy=GroupingStrategy.AVERAGE_OVER_PERIOD} },
                { 5,new KpiType() { Id=5,Name="Utilization",KpiTypeUnitType=UnitType.PERCENTAGE,KpiTypeDirection=TypeDirection.MAXIMIZE,KpiGroupingStrategy=GroupingStrategy.AVERAGE_OVER_PERIOD} },
                { 6,new KpiType() { Id=6,Name="Mean time between failure",KpiTypeUnitType=UnitType.TIMESPAN,KpiTypeDirection=TypeDirection.MAXIMIZE,KpiGroupingStrategy=GroupingStrategy.AVERAGE_OVER_PERIOD} },
                { 7,new KpiType() { Id=7,Name="Mean time to repair",KpiTypeUnitType=UnitType.TIMESPAN,KpiTypeDirection=TypeDirection.MINIMIZE,KpiGroupingStrategy=GroupingStrategy.AVERAGE_OVER_PERIOD} },
                { 8,new KpiType() { Id=8,Name="Earned Value",KpiTypeUnitType=UnitType.MONEY,KpiTypeDirection=TypeDirection.MAXIMIZE,KpiGroupingStrategy=GroupingStrategy.SUM_OVER_PERIOD} },
                { 9,new KpiType() { Id=9,Name="Amount Spent",KpiTypeUnitType=UnitType.MONEY,KpiTypeDirection=TypeDirection.MINIMIZE,KpiGroupingStrategy=GroupingStrategy.SUM_OVER_PERIOD} },
                { 10,new KpiType() { Id=10,Name="Revenue",KpiTypeUnitType=UnitType.MONEY,KpiTypeDirection=TypeDirection.MAXIMIZE,KpiGroupingStrategy=GroupingStrategy.SUM_OVER_PERIOD} },
                { 11,new KpiType() { Id=11,Name="Collections",KpiTypeUnitType=UnitType.MONEY,KpiTypeDirection=TypeDirection.MAXIMIZE,KpiGroupingStrategy=GroupingStrategy.SUM_OVER_PERIOD} },
                { 12,new KpiType() { Id=12,Name="Earnings",KpiTypeUnitType=UnitType.MONEY,KpiTypeDirection=TypeDirection.MAXIMIZE,KpiGroupingStrategy=GroupingStrategy.SUM_OVER_PERIOD} },
                { 13,new KpiType() { Id=13,Name="Average time to deliver",KpiTypeUnitType=UnitType.TIMESPAN,KpiTypeDirection=TypeDirection.MINIMIZE,KpiGroupingStrategy=GroupingStrategy.AVERAGE_OVER_PERIOD} },
                { 14,new KpiType() { Id=14,Name="Debtor days",KpiTypeUnitType=UnitType.TIMESPAN,KpiTypeDirection=TypeDirection.MINIMIZE,KpiGroupingStrategy=GroupingStrategy.AVERAGE_OVER_PERIOD} },
                { 15,new KpiType() { Id=15,Name="Creditor days",KpiTypeUnitType=UnitType.TIMESPAN,KpiTypeDirection=TypeDirection.MINIMIZE,KpiGroupingStrategy=GroupingStrategy.AVERAGE_OVER_PERIOD} },
                { 16,new KpiType() { Id=16,Name="Cycle time",KpiTypeUnitType=UnitType.TIMESPAN,KpiTypeDirection=TypeDirection.MINIMIZE,KpiGroupingStrategy=GroupingStrategy.AVERAGE_OVER_PERIOD} },
                { 17,new KpiType() { Id=17,Name="Sales",KpiTypeUnitType=UnitType.TIMESPAN,KpiTypeDirection=TypeDirection.MINIMIZE,KpiGroupingStrategy=GroupingStrategy.SUM_OVER_PERIOD} },
                { 18,new KpiType() { Id=18,Name="Generic Percentage",KpiTypeUnitType=UnitType.PERCENTAGE,KpiTypeDirection=TypeDirection.USER_DEFINED,KpiGroupingStrategy=GroupingStrategy.USER_DEFINED} },
                { 19,new KpiType() { Id=19,Name="Generic Decimal Number",KpiTypeUnitType=UnitType.DECIMAL,KpiTypeDirection=TypeDirection.USER_DEFINED,KpiGroupingStrategy=GroupingStrategy.USER_DEFINED} },
                { 20,new KpiType() { Id=20,Name="Generic Integer Number",KpiTypeUnitType=UnitType.INTEGER,KpiTypeDirection=TypeDirection.USER_DEFINED,KpiGroupingStrategy=GroupingStrategy.USER_DEFINED} },
                { 21,new KpiType() { Id=21,Name="Generic Time",KpiTypeUnitType=UnitType.TIMESPAN,KpiTypeDirection=TypeDirection.USER_DEFINED,KpiGroupingStrategy=GroupingStrategy.USER_DEFINED} },
                { 22,new KpiType() { Id=22,Name="Generic Money",KpiTypeUnitType=UnitType.MONEY,KpiTypeDirection=TypeDirection.USER_DEFINED,KpiGroupingStrategy=GroupingStrategy.USER_DEFINED} },
            };

            //kpi.KpiType = KpiTypes[1];

            //objOrg.Kpis.Add(kpi.ObjectId, kpi);

            
        }

        public List<FrtwbObject> GetObjectsForSearch(string objectTypeFor)
        {
            List<FrtwbObject> objects = new List<FrtwbObject>();
            foreach (var item in Organizations.Values)
            {
                objects.Add(item);
            }
            foreach (var item in Areas.Values)
            {
                objects.Add(item);
            }
            if (objectTypeFor != "Project")
            {
                foreach (var item in Projects.Values)
                {
                    objects.Add(item);
                }
            }
            if (objectTypeFor != "Activity" && objectTypeFor != "Project")
            {
                foreach (var item in Activities.Values)
                {
                    objects.Add(item);
                }
            }

            if (objectTypeFor != "Activity" && objectTypeFor != "Project" && objectTypeFor != "KPIs")
            {
                foreach (var item in Kpis.Values)
                {
                    objects.Add(item);
                }
            }

            return objects;
        }

        private void PopulateData()
        {
            Organization objorg = new Organization()
            {
                Name = "artexacta"
            };

            Area area = new Area()
            {
                Name = "marketing"
            };

            objorg.Areas.Add(area.ObjectId, area);
            area.Owner = objorg;
            Areas.Add(area.ObjectId, area);

            area = new Area()
            {
                Name = "development"
            };
            objorg.Areas.Add(area.ObjectId, area);
            area.Owner = objorg;
            Areas.Add(area.ObjectId, area);


            ////Kpi kpi = new Kpi()
            ////{
            ////    Name = "KPI Test Data",
            ////    Progress = 32
            ////};
            ////kpi.Owner = objOrg;
            ////Kpis.Add(kpi.ObjectId, kpi);
            ////objOrg.Kpis.Add(kpi.ObjectId, kpi);
            Project project = new Project()
            {
                Name = "Project 1"
            };
            project.Owner = objorg;
            Projects.Add(project.ObjectId, project);
            objorg.Projects.Add(project.ObjectId, project);

            Activity activity = new Activity()
            {
                Name = "Activity 1"
            };
            activity.Owner = objorg;
            Activities.Add(activity.ObjectId, activity);
            objorg.Activities.Add(activity.ObjectId, activity);

            Organizations.Add(objorg.ObjectId, objorg);
        }
    }
}