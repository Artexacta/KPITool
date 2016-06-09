using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using ObjectActionDSTableAdapters;

namespace Artexacta.App.ObjectAction.BLL
{
    /// <summary>
    /// Summary description for ObjectActionBLL
    /// </summary>
    [System.ComponentModel.DataObject]
    public class ObjectActionBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        ObjectActionTableAdapter _theAdapter = null;

        protected ObjectActionTableAdapter theAdapter
        {
            get
            {
                if (_theAdapter == null)
                    _theAdapter = new ObjectActionTableAdapter();
                return _theAdapter;
            }
        }

        public ObjectActionBLL()
        {
        }

        public static List<ObjectAction> GetObjectActionsForOrganization(int organizationId)
        {
            if (organizationId <= 0)
                throw new ArgumentException(Resources.ShareData.MessageZeroOrganizationId);

            List<ObjectAction> theList = new List<ObjectAction>();
            ObjectAction theData = null;
            try
            {
                ObjectActionTableAdapter localAdapter = new ObjectActionTableAdapter();
                ObjectActionDS.ObjectActionDataTable theTable = localAdapter.GetObjectActionsForOrganization(organizationId);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (ObjectActionDS.ObjectActionRow theRow in theTable)
                    {
                        theData = new ObjectAction(theRow.objectActionID);
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception exc)
            {
                log.Error("Error en GetObjectActionsForOrganization para organizationId: " + organizationId, exc);
                throw new ArgumentException(Resources.ShareData.MessageErrorPermissionsByOrganization);
            }

            return theList;
        }

        public static List<ObjectAction> GetObjectActionsForProject(int projectId)
        {
            if (projectId <= 0)
                throw new ArgumentException(Resources.ShareData.MessageZeroProjectId);

            List<ObjectAction> theList = new List<ObjectAction>();
            ObjectAction theData = null;
            try
            {
                ObjectActionTableAdapter localAdapter = new ObjectActionTableAdapter();
                ObjectActionDS.ObjectActionDataTable theTable = localAdapter.GetObjectActionsForProject(projectId);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (ObjectActionDS.ObjectActionRow theRow in theTable)
                    {
                        theData = new ObjectAction(theRow.objectActionID);
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception exc)
            {
                log.Error("Error en GetObjectActionsForProject para projectId: " + projectId, exc);
                throw new ArgumentException(Resources.ShareData.MessageErrorPermissionsByProject);
            }

            return theList;
        }

        public static List<ObjectAction> GetObjectActionsForActivity(int activityId)
        {
            if (activityId <= 0)
                throw new ArgumentException(Resources.ShareData.MessageZeroActivityId);

            List<ObjectAction> theList = new List<ObjectAction>();
            ObjectAction theData = null;
            try
            {
                ObjectActionTableAdapter localAdapter = new ObjectActionTableAdapter();
                ObjectActionDS.ObjectActionDataTable theTable = localAdapter.GetObjectActionsForActivity(activityId);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (ObjectActionDS.ObjectActionRow theRow in theTable)
                    {
                        theData = new ObjectAction(theRow.objectActionID);
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception exc)
            {
                log.Error("Error en GetObjectActionsForActivity para activityId: " + activityId, exc);
                throw new ArgumentException(Resources.ShareData.MessageErrorPermissionsByActivity);
            }

            return theList;
        }

        public static List<ObjectAction> GetObjectActionsForPerson(int personId)
        {
            if (personId <= 0)
                throw new ArgumentException(Resources.ShareData.MessageZeroPersonId);

            List<ObjectAction> theList = new List<ObjectAction>();
            ObjectAction theData = null;
            try
            {
                ObjectActionTableAdapter localAdapter = new ObjectActionTableAdapter();
                ObjectActionDS.ObjectActionDataTable theTable = localAdapter.GetObjectActionsForPeople(personId);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (ObjectActionDS.ObjectActionRow theRow in theTable)
                    {
                        theData = new ObjectAction(theRow.objectActionID);
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception exc)
            {
                log.Error("Error en GetObjectActionsForPerson para personId: " + personId, exc);
                throw new ArgumentException(Resources.ShareData.MessageErrorPermissionsByPerson);
            }

            return theList;
        }

        public static List<ObjectAction> GetObjectActionsForKPI(int kpiId)
        {
            if (kpiId <= 0)
                throw new ArgumentException(Resources.ShareData.MessageZeroKPIId);

            List<ObjectAction> theList = new List<ObjectAction>();
            theList.Add(new ObjectAction(""));
            ObjectAction theData = null;
            try
            {
                ObjectActionTableAdapter localAdapter = new ObjectActionTableAdapter();
                ObjectActionDS.ObjectActionDataTable theTable = localAdapter.GetObjectActionsForKPI(kpiId);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (ObjectActionDS.ObjectActionRow theRow in theTable)
                    {
                        theData = new ObjectAction(theRow.objectActionID);
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception exc)
            {
                log.Error("Error en GetObjectActionsForKPI para kpiId: " + kpiId, exc);
                throw new ArgumentException(Resources.ShareData.MessageErrorPermissionsByKPI);
            }

            return theList;
        }

    }
}