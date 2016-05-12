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
                throw new ArgumentException(Resources.Organization.MessageZeroOrganizationId);

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
                throw new ArgumentException("Ocurrió un error al obtener el listado de permisos para la organización."); ;
            }

            return theList;
        }

        public static List<ObjectAction> GetObjectActionsForProject()
        {
            List<ObjectAction> theList = new List<ObjectAction>();
            ObjectAction theData = null;
            try
            {
                ObjectActionTableAdapter localAdapter = new ObjectActionTableAdapter();
                ObjectActionDS.ObjectActionDataTable theTable = localAdapter.GetObjectActionsForProject();

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
                log.Error("Ocurrió un error en GetObjectActionsForProject", exc);
                throw exc;
            }

            return theList;
        }

        public static List<ObjectAction> GetObjectActionsForActivity()
        {
            List<ObjectAction> theList = new List<ObjectAction>();
            ObjectAction theData = null;
            try
            {
                ObjectActionTableAdapter localAdapter = new ObjectActionTableAdapter();
                ObjectActionDS.ObjectActionDataTable theTable = localAdapter.GetObjectActionsForActivity();

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
                log.Error("Ocurrió un error en GetObjectActionsForActivity", exc);
                throw exc;
            }

            return theList;
        }

        public static List<ObjectAction> GetObjectActionsForPeople()
        {
            List<ObjectAction> theList = new List<ObjectAction>();
            ObjectAction theData = null;
            try
            {
                ObjectActionTableAdapter localAdapter = new ObjectActionTableAdapter();
                ObjectActionDS.ObjectActionDataTable theTable = localAdapter.GetObjectActionsForPeople();

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
                log.Error("Ocurrió un error en GetObjectActionsForPeople", exc);
                throw exc;
            }

            return theList;
        }

        public static List<ObjectAction> GetObjectActionsForKPI()
        {
            List<ObjectAction> theList = new List<ObjectAction>();
            ObjectAction theData = null;
            try
            {
                ObjectActionTableAdapter localAdapter = new ObjectActionTableAdapter();
                ObjectActionDS.ObjectActionDataTable theTable = localAdapter.GetObjectActionsForKPI();

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
                log.Error("Ocurrió un error en GetObjectActionsForKPI", exc);
                throw exc;
            }

            return theList;
        }

    }
}