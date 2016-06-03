﻿using log4net;
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
            theNewRecord.OrganizationName = row.IsorganizationNameNull() ? "" : row.organizationName;
            theNewRecord.AreaName = row.IsareaNameNull() ? "" : row.areaName;
            theNewRecord.ProjectName = row.IsprojectNameNull() ? "" : row.projectName;
            theNewRecord.NumberOfKpis = row.IsnumberKPIsNull() ? 0 : row.numberKPIs;
            return theNewRecord;
        }

        public static Activity GetActivityById(int activityId)
        {
            if (activityId <= 0)
                throw new ArgumentException(Resources.Organization.MessageZeroAreaId);

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
                log.Error("Ocurrió un error mientras se obtenía la actividad de id: " + activityId, exc);
                throw exc;
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
                log.Error("Error en GetActivitiesByOrganization para organizationId: " + organizationId.ToString() + " y userName: " + userName, exc);
                throw new ArgumentException("Ocurrió un error al obtener el listado de actividades de la organización.");
            }

            return theList;
        }

        public List<Activity> GetActivitiesByProject(int projectId)
        {
            if (projectId <= 0)
                throw new ArgumentException(Resources.Organization.MessageZeroProjectId);

            List<Activity> theList = new List<Activity>();
            Activity theData = null;

            try
            {
                ActivityDS.ActivitiesDataTable theTable = theAdapter.GetActivitiesByProject(projectId);

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
                log.Error("Ocurrió un error mientras se obtenía las actividades del proyecto de id =" + projectId.ToString(), exc);
                throw exc;
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
                log.Error("Ocurrió un error mientras se obtenía las actividades de la organización.", exc);
                throw exc;
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
                throw exc;
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
                log.Error("Error en GetActivitiesByProject para projectId: " + projectId.ToString() + " y userName: " + userName, exc);
                throw new ArgumentException("Ocurrió un error al obtener el listado de actividades del proyecto.");
            }

            return theList;
        }

    }
}