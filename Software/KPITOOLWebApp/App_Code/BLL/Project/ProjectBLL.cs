using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using log4net;
using ProjectDSTableAdapters;

namespace Artexacta.App.Project.BLL
{
    /// <summary>
    /// Summary description for ProjectBLL
    /// </summary>
    /// 
    [System.ComponentModel.DataObject]
    public class ProjectBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        ProjectDSTableAdapters.ProjectsTableAdapter _theAdapter = null;

        protected ProjectDSTableAdapters.ProjectsTableAdapter theAdapter
        {
            get
            {
                if (_theAdapter == null)
                    _theAdapter = new ProjectDSTableAdapters.ProjectsTableAdapter();
                return _theAdapter;
            }
        }

        public ProjectBLL()
        {
        }

        private static Project FillRecord(ProjectDS.ProjectsRow row)
        {
            Project theNewRecord = new Project(
                row.projectID,
                row.name,
                row.organizationID,
                row.IsareaIDNull() ? 0 : row.areaID);
            theNewRecord.OrganizationName = row.IsorganizationNameNull() ? "" : row.organizationName;
            theNewRecord.AreaName = row.IsareaNameNull() ? "" : row.areaName;
            theNewRecord.NumberOfKpis = row.IsnumberKPIsNull() ? 0 : row.numberKPIs;
            return theNewRecord;
        }

        public List<Project> GetProjectsByOrganization(int organizationId)
        {
            if (organizationId <= 0)
                throw new ArgumentException(Resources.Organization.MessageZeroOrganizationId);

            string userName = HttpContext.Current.User.Identity.Name;
            List<Project> theList = new List<Project>();
            Project theData = null;
            try
            {
                ProjectDS.ProjectsDataTable theTable = theAdapter.GetProjectsByOrganization(organizationId, userName);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (ProjectDS.ProjectsRow theRow in theTable)
                    {
                        theData = FillRecord(theRow);
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception exc)
            {
                log.Error("Error en GetProjectByOrganization para organizationId: " + organizationId.ToString() + " y userName: " + userName, exc);
                throw new ArgumentException(Resources.DataDetails.MessageErrorProjectsByOrganization);
            }

            return theList;
        }

        public List<Project> GetProjectBySearch(string whereClause)
        {
            if (string.IsNullOrEmpty(whereClause))
                whereClause = "1=1";

            List<Project> theList = new List<Project>();
            Project theData = null;

            string userName = HttpContext.Current.User.Identity.Name;

            try
            {
                ProjectDS.ProjectsDataTable theTable = theAdapter.GetProjectBySearch(userName, whereClause);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (ProjectDS.ProjectsRow theRow in theTable)
                    {
                        theData = FillRecord(theRow);
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception exc)
            {
                log.Error("Ocurrió un error mientras se obtenía los proyectos by search =" + whereClause, exc);
                throw exc;
            }

            return theList;
        }

        public static int InsertProject(Project theClass)
        {
            if (theClass.OrganizationID <= 0)
                throw new ArgumentException(Resources.Organization.MessageZeroOrganizationId);

            if (string.IsNullOrEmpty(theClass.Name))
                throw new ArgumentException(Resources.Organization.MessageEmptyNameProject);

            ProjectsTableAdapter localAdapter = new ProjectsTableAdapter();

            int? projectId = 0;
            string userName = HttpContext.Current.User.Identity.Name;

            try
            {
                localAdapter.InsertProject(userName, theClass.OrganizationID, theClass.AreaID, theClass.Name, ref projectId);
            }
            catch (Exception exc)
            {
                log.Error(Resources.Organization.MessageErrorCreateProject, exc);
                throw new Exception(Resources.Organization.MessageErrorCreateProject);
            }

            if ((int)projectId <= 0)
            {
                log.Error(Resources.Organization.MessageErrorCreateProject);
                throw new ArgumentException(Resources.Organization.MessageErrorCreateProject);
            }

            return (int)projectId;
        }

        public static void UpdateProject(Project theClass)
        {
            if (theClass.ProjectID <= 0)
                throw new ArgumentException(Resources.Organization.MessageZeroProjectId);

            if (theClass.OrganizationID <= 0)
                throw new ArgumentException(Resources.Organization.MessageZeroOrganizationId);

            if (string.IsNullOrEmpty(theClass.Name))
                throw new ArgumentException(Resources.Organization.MessageEmptyNameProject);

            ProjectsTableAdapter localAdapter = new ProjectsTableAdapter();

            try
            {
                localAdapter.UpdateProject(theClass.ProjectID,
                    theClass.Name,
                    theClass.OrganizationID,
                    theClass.AreaID);
            }
            catch (Exception exc)
            {
                log.Error(Resources.Organization.MessageErrorUpdateProject, exc);
                throw new Exception(Resources.Organization.MessageErrorUpdateProject);
            }
        }

        public static void DeleteProject(int projectId)
        {
            if (projectId <= 0)
                throw new ArgumentException(Resources.Organization.MessageZeroProjectId);

            ProjectsTableAdapter localAdapter = new ProjectsTableAdapter();

            try
            {
                localAdapter.DeleteProject(projectId);
            }
            catch (Exception exc)
            {
                log.Error(Resources.Organization.MessageErrorDeleteProject, exc);
                throw new Exception(Resources.Organization.MessageErrorDeleteProject);
            }
        }

        public static Project GetProjectById(int projectId)
        {
            if (projectId <= 0)
                throw new ArgumentException(Resources.Organization.MessageZeroProjectId);

            Project theData = null;
            try
            {
                ProjectsTableAdapter localAdapter = new ProjectsTableAdapter();
                ProjectDS.ProjectsDataTable theTable = localAdapter.GetProjectById(projectId);
                if (theTable != null && theTable.Rows.Count > 0)
                {
                    ProjectDS.ProjectsRow theRow = theTable[0];
                    theData = FillRecord(theRow);
                }
            }
            catch (Exception exc)
            {
                log.Error("Ocurrió un error mientras se obtenía el proyecto de id: " + projectId, exc);
                throw exc;
            }

            return theData;
        }

        public static List<Project> GetProjectsForAutocomplete(int organizationId, int areaId, string filter)
        {
            string userName = HttpContext.Current.User.Identity.Name;

            List<Project> theList = new List<Project>();
            Project theData = null;
            try
            {
                ProjectsTableAdapter localAdapter = new ProjectsTableAdapter();
                ProjectDS.ProjectsDataTable theTable = localAdapter.GetProjectsForAutocomplete(userName, organizationId, areaId, filter);
                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (ProjectDS.ProjectsRow theRow in theTable)
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

    }
}