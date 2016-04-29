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
                row.areaID);

            return theNewRecord;
        }

        public List<Project> GetProjectByOrganization(int organizationId)
        {
            if (organizationId <= 0)
                throw new ArgumentException(Resources.Organization.MessageZeroOrganizationId);

            List<Project> theList = new List<Project>();
            Project theData = null;

            try
            {
                ProjectDS.ProjectsDataTable theTable = theAdapter.GetProjectsByOrganization(organizationId);

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
                log.Error("Ocurrió un error mientras se obtenía los proyectos de la organización de id =" + organizationId.ToString(), exc);
                throw exc;
            }

            return theList;
        }

        public static int InsertProject(int organizationId, int areaId, string name)
        {
            if (organizationId <= 0)
                throw new ArgumentException(Resources.Organization.MessageZeroOrganizationId);

            if (areaId <= 0)
                throw new ArgumentException(Resources.Organization.MessageZeroAreaId);

            if (string.IsNullOrEmpty(name))
                throw new ArgumentException(Resources.Organization.MessageEmptyNameProject);

            ProjectsTableAdapter localAdapter = new ProjectsTableAdapter();

            int? projectId = 0;
            string userName = HttpContext.Current.User.Identity.Name;

            try
            {
                localAdapter.InsertProject(userName, organizationId, areaId, name, ref projectId);
            }
            catch (Exception exc)
            {
                log.Error(Resources.Organization.MessageErrorCreateProject, exc);
                throw exc;
            }

            if ((int)projectId <= 0)
            {
                log.Error(Resources.Organization.MessageErrorCreateProject);
                throw new ArgumentException(Resources.Organization.MessageErrorCreateProject);
            }

            return (int)projectId;
        }

        public static void UpdateProject(int projectId, string name, int organizationId, int areaId)
        {
            if (projectId <= 0)
                throw new ArgumentException(Resources.Organization.MessageZeroProjectId);

            if (string.IsNullOrEmpty(name))
                throw new ArgumentException(Resources.Organization.MessageEmptyNameProject);

            ProjectsTableAdapter localAdapter = new ProjectsTableAdapter();

            try
            {
                localAdapter.UpdateProject(projectId, name, organizationId, areaId);
            }
            catch (Exception exc)
            {
                log.Error(Resources.Organization.MessageErrorUpdateProject, exc);
                throw exc;
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

        public static Project GetProjectById(int areaId)
        {
            if (areaId <= 0)
                throw new ArgumentException(Resources.Organization.MessageZeroProjectId);

            Project theData = null;
            try
            {
                ProjectsTableAdapter localAdapter = new ProjectsTableAdapter();
                ProjectDS.ProjectsDataTable theTable = localAdapter.GetProjectById(areaId);
                if (theTable != null && theTable.Rows.Count > 0)
                {
                    ProjectDS.ProjectsRow theRow = theTable[0];
                    theData = FillRecord(theRow);
                }
            }
            catch (Exception exc)
            {
                log.Error("Ocurrió un error mientras se obtenía el proyecto de id: " + areaId, exc);
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
                ProjectDS.ProjectsDataTable theTable = localAdapter.GetPorjectsForAutocomplete(userName, organizationId, areaId, filter);
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