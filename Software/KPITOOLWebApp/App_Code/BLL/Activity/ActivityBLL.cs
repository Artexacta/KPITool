using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using ActivityDSTableAdapters;

namespace Artexacta.App.Activities.BLL
{
    /// <summary>
    /// Summary description for ActivityBLL
    /// </summary>
    [System.ComponentModel.DataObject]
    public class ActivityBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        ActivitiesTableAdapter _theAdapter = null;

        protected ActivitiesTableAdapter theAdapter
        {
            get
            {
                if (_theAdapter == null)
                    _theAdapter = new ActivitiesTableAdapter();
                return _theAdapter;
            }
        }

        public ActivityBLL()
        {
        }

        private static Activity FillRecord(ActivityDS.ActivitiesRow row)
        {
            Activity theNewRecord = new Activity(
                row.activityID,
                row.name,
                row.organizationID,
                row.IsareaIDNull() ? 0 : row.areaID,
                row.IsprojectIDNull() ? 0 : row.projectID);
            theNewRecord.OrganizationName = row.organizationName;
            theNewRecord.AreaName = row.IsareaNameNull() ? "" : row.areaName;
            theNewRecord.ProjectName = row.IsprojectNameNull() ? "" : row.projectName;
            theNewRecord.NumberOfKpis = row.IsnumberKPIsNull() ? 0 : row.numberKPIs;
            theNewRecord.IsOwner = row.IsisOwnerNull() ? false : Convert.ToBoolean(row.isOwner);
            return theNewRecord;
        }

        public static Activity GetActivityById(int activityId)
        {
            if (activityId <= 0)
                throw new ArgumentException(Resources.Activity.MessageErrorActivityID);

            Activity theData = null;
            try
            {
                ActivitiesTableAdapter localAdapter = new ActivitiesTableAdapter();
                ActivityDS.ActivitiesDataTable theTable = localAdapter.GetActivityById(activityId);
                if (theTable != null && theTable.Rows.Count > 0)
                {
                    ActivityDS.ActivitiesRow theRow = theTable[0];
                    theData = FillRecord(theRow);
                }
            }
            catch (Exception exc)
            {
                log.Error(Resources.Activity.MessageErrorGetActivity + " id: " + activityId, exc);
                throw new Exception(Resources.Activity.MessageErrorGetActivity);
            }

            return theData;
        }

        public List<Activity> GetActivitiesByOrganization(int organizationId)
        {
            if (organizationId <= 0)
                throw new ArgumentException(Resources.Organization.MessageZeroOrganizationId);

            string userName = HttpContext.Current.User.Identity.Name;
            List<Activity> theList = new List<Activity>();
            Activity theData = null;
            try
            {
                ActivityDS.ActivitiesDataTable theTable = theAdapter.GetActivitiesByOrganization(organizationId, userName);
                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (ActivityDS.ActivitiesRow theRow in theTable)
                    {
                        theData = FillRecord(theRow);
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception exc)
            {
                log.Error(Resources.Activity.MessageErrorGetForOrganization + " para organizationId: " + organizationId.ToString() + " y userName: " + userName, exc);
                throw new ArgumentException(Resources.Activity.MessageErrorGetForOrganization);
            }

            return theList;
        }

        public List<Activity> GetActivitiesBySearch(string whereClause)
        {
            if (string.IsNullOrEmpty(whereClause))
                whereClause = "1=1";

            string username = HttpContext.Current.User.Identity.Name;

            List<Activity> theList = new List<Activity>();
            Activity theData = null;

            try
            {
                ActivityDS.ActivitiesDataTable theTable = theAdapter.GetActivityBySearch(username, whereClause);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (ActivityDS.ActivitiesRow theRow in theTable)
                    {
                        theData = FillRecord(theRow);
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception exc)
            {
                log.Error(Resources.Activity.MessageErrorActivityList, exc);
                throw new Exception(Resources.Activity.MessageErrorActivityList);
            }

            return theList;
        }

        public static List<Activity> GetActivitiesForAutocomplete(int organizationId, int areaId, int projectId, string filter)
        {
            string userName = HttpContext.Current.User.Identity.Name;

            List<Activity> theList = new List<Activity>();
            Activity theData = null;
            try
            {
                ActivitiesTableAdapter localAdapter = new ActivitiesTableAdapter();
                ActivityDS.ActivitiesDataTable theTable = localAdapter.GetActivitiesForAutocomplete(userName, organizationId, areaId, projectId, filter);
                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (ActivityDS.ActivitiesRow theRow in theTable)
                    {
                        theData = FillRecord(theRow);
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception exc)
            {
                log.Error(Resources.Activity.MessageErrorActivityList + " for autocomplete.", exc);
                throw new Exception(Resources.Activity.MessageErrorActivityList);
            }

            return theList;
        }

        public List<Activity> GetActivitiesByProject(int projectId)
        {
            if (projectId <= 0)
                throw new ArgumentException(Resources.Organization.MessageZeroProjectId);

            string userName = HttpContext.Current.User.Identity.Name;
            List<Activity> theList = new List<Activity>();
            Activity theData = null;
            try
            {
                ActivityDS.ActivitiesDataTable theTable = theAdapter.GetActivitiesByProject(projectId, userName);
                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (ActivityDS.ActivitiesRow theRow in theTable)
                    {
                        theData = FillRecord(theRow);
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception exc)
            {
                log.Error(Resources.Activity.MessageErrorGetForProject + " para projectId: " + projectId.ToString() + " y userName: " + userName, exc);
                throw new ArgumentException(Resources.Activity.MessageErrorGetForProject);
            }

            return theList;
        }

        public static int InsertActivity(Activity theClass)
        {
            if (theClass.OrganizationID <= 0)
                throw new ArgumentException(Resources.Organization.MessageZeroOrganizationId);

            if (string.IsNullOrEmpty(theClass.Name))
                throw new ArgumentException(Resources.Activity.MessageNameEmpty);

            ActivitiesTableAdapter localAdapter = new ActivitiesTableAdapter();

            int? activityId = 0;
            string userName = HttpContext.Current.User.Identity.Name;

            try
            {
                localAdapter.InsertActivity(userName, theClass.OrganizationID, theClass.AreaID, theClass.ProjectID, theClass.Name, ref activityId);
            }
            catch (Exception exc)
            {
                log.Error(Resources.Activity.MessageErrorCreate, exc);
                throw new Exception(Resources.Activity.MessageErrorCreate);
            }

            if ((int)activityId <= 0)
            {
                log.Error(Resources.Activity.MessageErrorCreate);
                throw new ArgumentException(Resources.Activity.MessageErrorCreate);
            }

            return (int)activityId;
        }

        public static void UpdateActivity(Activity theClass)
        {
            if (theClass.OrganizationID <= 0)
                throw new ArgumentException(Resources.Organization.MessageZeroOrganizationId);

            if (string.IsNullOrEmpty(theClass.Name))
                throw new ArgumentException(Resources.Activity.MessageNameEmpty);

            ActivitiesTableAdapter localAdapter = new ActivitiesTableAdapter();

            string userName = HttpContext.Current.User.Identity.Name;

            try
            {
                localAdapter.UpdateActivity(theClass.ActivityID, theClass.Name, theClass.OrganizationID, theClass.AreaID, theClass.ProjectID);
            }
            catch (Exception exc)
            {
                log.Error(Resources.Activity.MessageErrorUpdate, exc);
                throw new Exception(Resources.Activity.MessageErrorUpdate);
            }
        }

        public static void DeleteActivity(int activityID)
        {
            if (activityID <= 0)
                throw new ArgumentException(Resources.Organization.MessageZeroActivityId);

            ActivitiesTableAdapter localAdapter = new ActivitiesTableAdapter();
            string username = HttpContext.Current.User.Identity.Name;

            try
            {
                localAdapter.DeleteActivity(activityID, username);
            }
            catch (Exception exc)
            {
                log.Error(Resources.Activity.MessageErrorDelete, exc);
                throw new Exception(Resources.Activity.MessageErrorDelete);
            }
        }
    }
}