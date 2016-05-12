using Artexacta.App.Activities;
using Artexacta.App.Activities.BLL;
using Artexacta.App.Area;
using Artexacta.App.Area.BLL;
using Artexacta.App.Organization;
using Artexacta.App.Organization.BLL;
using Artexacta.App.People;
using Artexacta.App.People.BLL;
using Artexacta.App.Project;
using Artexacta.App.Project.BLL;
using Artexacta.App.User;
using Artexacta.App.User.BLL;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class AutoCompleteWS_ComboBoxWebServices : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static List<Organization> Get_Organizations(string filter)
    {
        List<Organization> theList = new List<Organization>();
        try
        {
            theList = OrganizationBLL.GetOrganizationsForAutocomplete(filter);
        }
        catch (Exception exc)
        {
            log.Error("Error in GetOrganizationsForAutocomplete to filter: " + filter, exc);
        }
        return theList;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static List<Area> Get_Areas(string organizationId, string filter)
    {
        List<Area> theList = new List<Area>();
        if (!string.IsNullOrEmpty(organizationId))
        {
            try
            {
                theList = AreaBLL.GetAreasForAutocomplete(Convert.ToInt32(organizationId), filter);
            }
            catch (Exception exc)
            {
                log.Error("Error in GetAreasForAutocomplete to filter: " + filter + " and organizationId: " + organizationId, exc);
            }
        }
        return theList;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static List<Project> Get_Projects(string organizationId, string areaId, string filter)
    {
        List<Project> theList = new List<Project>();
        if (string.IsNullOrEmpty(areaId))
            areaId = "0";
        if (!string.IsNullOrEmpty(organizationId))
        {
            try
            {
                theList = ProjectBLL.GetProjectsForAutocomplete(Convert.ToInt32(organizationId), Convert.ToInt32(areaId), filter);
            }
            catch (Exception exc)
            {
                log.Error("Error in GetProjectsForAutocomplete to filter: " + filter + ", organizationId: " + organizationId + " and areaId: " + areaId, exc);
            }
        }
        return theList;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static List<Activity> Get_Activities(string organizationId, string areaId, string projectId, string filter)
    {
        List<Activity> theList = new List<Activity>();
        if (string.IsNullOrEmpty(areaId))
            areaId = "0";
        if (string.IsNullOrEmpty(projectId))
            projectId = "0";
        if (!string.IsNullOrEmpty(organizationId))
        {
            try
            {
                theList = ActivityBLL.GetActivitiesForAutocomplete(Convert.ToInt32(organizationId), Convert.ToInt32(areaId), Convert.ToInt32(projectId), filter);
            }
            catch (Exception exc)
            {
                log.Error("Error in GetActivitiesForAutocomplete to filter: " + filter + ", organizationId: " + organizationId + ", areaId: " + areaId + " and projectId:" + projectId, exc);
            }
        }
        return theList;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static List<People> Get_People(string organizationId, string areaId, string filter)
    {
        List<People> theList = new List<People>();
        if (string.IsNullOrEmpty(areaId))
            areaId = "0";
        if (!string.IsNullOrEmpty(organizationId))
        {
            try
            {
                theList = PeopleBLL.GetPeopleForAutocomplete(Convert.ToInt32(organizationId), Convert.ToInt32(areaId), filter);
            }
            catch (Exception exc)
            {
                log.Error("Error in GetPeopleForAutocomplete to filter: " + filter + ", organizationId: " + organizationId + " and areaId: " + areaId, exc);
            }
        }
        return theList;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static List<User> Get_User(string filter)
    {
        List<User> theList = new List<User>();
        try
        {
            theList = UserBLL.GetUsersForAutoComplete(filter);
        }
        catch (Exception exc)
        {
            log.Error("Error in GetUsersForAutoComplete to filter: " + filter, exc);
        }
        return theList;
    }

}