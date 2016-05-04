using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.Activities
{
    /// <summary>
    /// Summary description for Activity
    /// </summary>
    public class Activity
    {
        private int _activityID;
        private string _name;
        private int _organizationID;
        private int _areaID;
        private int _projectID;

        public Activity()
        {
        }

        public Activity(int activityID, string name, int organizationID, int areaID, int projectID)
        {
            this._activityID = activityID;
            this._name = name;
            this._organizationID = organizationID;
            this._areaID = areaID;
            this._projectID = projectID;
        }

        public int ActivityID
        {
            get { return _activityID; }
            set { _activityID = value; }
        }

        public string Name
        {
            get { return _name; }
            set { _name = value; }
        }

        public int OrganizationID
        {
            get { return _organizationID; }
            set { _organizationID = value; }
        }

        public int AreaID
        {
            get { return _areaID; }
            set { _areaID = value; }
        }

        public int ProjectID
        {
            get { return _projectID; }
            set { _projectID = value; }
        }

        public int NumberOfKpis { get; set; }

        public string NumberOfKpisForDisplay
        {
            get { return NumberOfKpis + " KPIs"; }
        }

        public string OrganizationName { get; set; }
        public string AreaName { get; set; }
        public string ProjectName { get; set; }
        
    }
}