using Artexacta.App.Utilities.SystemMessages;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using Artexacta.App.Project.BLL;
using Artexacta.App.Project;
using Artexacta.App.Activities.BLL;
using Artexacta.App.Activities;
using Artexacta.App.KPI.BLL;
using Artexacta.App.KPI;
using Artexacta.App.Organization.BLL;
using Artexacta.App.Organization;
using Artexacta.App.Area;
using Artexacta.App.Area.BLL;

public partial class Project_ProjectList : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    protected override void InitializeCulture()
    {
        Artexacta.App.Utilities.LanguageUtilities.SetLanguageFromContext();
        base.InitializeCulture();
    }

    private string ownerToSelectInSearch;

    protected void Page_Load(object sender, EventArgs e)
    {
        ProjectSearchControl.Config = new ProjectSearch();
        ProjectSearchControl.OnSearch += ProjectSearchControl_OnSearch;

        if (!IsPostBack)
        {
        }
    }

    void ProjectSearchControl_OnSearch()
    {
        
    }

    protected void ViewProject_Click(object sender, EventArgs e)
    {
        LinkButton btnClick = (LinkButton)sender;
        Session["ProjectId"] = btnClick.Attributes["data-id"];
        Response.Redirect("~/Project/ProjectDetails.aspx");
    }

    protected void EditProject_Click(object sender, EventArgs e)
    {
        LinkButton btnClick = (LinkButton)sender;
        Session["ProjectId"] = btnClick.Attributes["data-id"];
        Session["ParentPage"] = "~/Project/ProjectList.aspx";
        Response.Redirect("~/Project/ProjectForm.aspx");
    }
    protected void ShareProject_Click(object sender, EventArgs e)
    {

    }
    protected void DeleteProject_Click(object sender, EventArgs e)
    {

    }
    protected string GetOrganizationInfo(Object obj)
    {
        int OrganizationID = 0;
        string name = "";
        try
        {
            OrganizationID = (int)obj;
        }
        catch {return "-";}

        if (OrganizationID > 0)
        {
            Organization theClass = null;

            try
            {
                theClass = OrganizationBLL.GetOrganizationById(OrganizationID);
            }
            catch {}

            if (theClass != null)
                name = theClass.Name;
        }

        return name;
    }
    protected string GetAreaInfo(Object obj)
    {
        int areaID = 0;
        string name = "";
        try
        {
            areaID = (int)obj;
        }
        catch { return "-"; }

        if (areaID > 0)
        {
            Area theClass = null;

            try
            {
                theClass = AreaBLL.GetAreaById(areaID);
            }
            catch { }

            if (theClass != null)
                name = " - " + theClass.Name;
        }

        return name;
    }
    protected void ProjectsRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem)
            return;

        Project item = (Project)e.Item.DataItem;

        if (item == null)
            return;
        
        //Activities
        ActivityBLL theACBLL = new ActivityBLL();
        List<Activity> theActivities = new List<Activity>();

        try
        {
            theActivities = theACBLL.GetActivitiesByProject(item.ProjectID);
        }
        catch { }

        //KPI
        KPIBLL theKBLL = new KPIBLL();
        List<KPI> theKPIs = new List<KPI>();

        try
        {
            theKPIs = theKBLL.GetKPIsByProject(item.ProjectID);
        }
        catch { }

        if (theActivities.Count == 0 && theKPIs.Count == 0)
        {
            Panel element = (Panel)e.Item.FindControl("emptyMessage");
            element.Visible = true;
            return;
        }

        Panel detailsPanel = (Panel)e.Item.FindControl("detailsContainer");
        detailsPanel.Visible = true;

        Panel kpiImagePanel = (Panel)e.Item.FindControl("KpiImageContainer");
        kpiImagePanel.Visible = true;

        LinkButton activitiesButton = (LinkButton)e.Item.FindControl("ActivitiesButton");
        LinkButton kpisButton = (LinkButton)e.Item.FindControl("KpisButton");

        Literal and = (Literal)e.Item.FindControl("AndLiteral");


        activitiesButton.Visible = theActivities.Count > 0;
        activitiesButton.Text = activitiesButton.Visible ? theActivities.Count + (theActivities.Count == 1 ? " Activity" : " Activities") : "";

        kpisButton.Visible = theKPIs.Count > 0;
        kpisButton.Text = kpisButton.Visible ? theKPIs.Count + " KPI(s)" : "";

        and.Visible = activitiesButton.Visible && kpisButton.Visible;
    }


    protected void ProjectsRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        int projectId = 0;
        try
        {
            projectId = Convert.ToInt32(e.CommandArgument);
        }
        catch (Exception ex)
        {
            log.Error("Error getting object id", ex);
        }
        if (projectId <= 0)
        {
            SystemMessages.DisplaySystemErrorMessage("Could not complete the requested action");
            return;
        }

        if (e.CommandName == "EditProject")
        {
            Session["ProjectId"] = projectId;
            Session["ParentPage"] = "~/Project/ProjectList.aspx";
            Response.Redirect("~/Project/ProjectForm.aspx");
            return;
        }

        if (e.CommandName == "ViewProject")
        {
            Session["ProjectId"] = projectId;
            Response.Redirect("~/Project/ProjectDetails.aspx");
            return;
        }

        if (e.CommandName == "ViewOwner")
        {
            //Project objProject = FrtwbSystem.Instance.Projects[projectId];
            //if (objProject == null)
            //    return;
            //FrtwbObject ownerObject = objProject.Owner;
            //if (ownerObject == null)
            //    return;

            //if (ownerObject is Organization)
            //{
            //    Session["OrganizationId"] = ownerObject.ObjectId;
            //    Response.Redirect("~/Organization/OrganizationDetails.aspx");
            //}
            //else if (ownerObject is Area)
            //{
            //    Area area = (Area)ownerObject;
            //    Session["OrganizationId"] = area.Owner.ObjectId;
            //    Response.Redirect("~/Organization/OrganizationDetails.aspx#Area");
            //}
            return;
        }

        if (e.CommandName == "DeleteProject")
        {
            try
            {
                ProjectBLL.DeleteProject(projectId);
            }
            catch (Exception ex)
            {
                SystemMessages.DisplaySystemErrorMessage(ex.Message);
                return;
            }

            SystemMessages.DisplaySystemMessage(Resources.Organization.MessageDeleteProjectOK);
            ProjectsRepeater.DataBind();
            return;
        }
        if (e.CommandName == "ViewActivities")
        {
            Session["OwnerId"] = projectId + "-Project";
            Response.Redirect("~/Activity/ActivitiesList.aspx");
            return;
        }
        if (e.CommandName == "ViewKPIs")
        {
            Session["OwnerId"] = projectId + "-Project";
            Response.Redirect("~/Kpi/KpiList.aspx");
            return;
        }
    }

    private void RemoveProjectFromOldOwner(Project objProject)
    {
        //if (objProject.Owner is Area)
        //{
        //    Area oldArea = (Area)objProject.Owner;
        //    oldArea.Projects.Remove(objProject.ObjectId);
        //}
        //else if (objProject.Owner is Organization)
        //{
        //    Organization oldOrganization = (Organization)objProject.Owner;
        //    oldOrganization.Projects.Remove(objProject.ObjectId);
        //}
    }
    protected void SearchButton_Click(object sender, EventArgs e)
    {
        //SearchProjects();
    }

    //private void SearchProjects()
    //{
    //    string searchTerm = SearchTextBox.Text.Trim().ToLower();

    //    Dictionary<int, Project> source = null;
    //    if (!string.IsNullOrEmpty(ObjectsComboBox.SelectedValue))
    //    {
    //        string[] values = ObjectsComboBox.SelectedValue.Split(new char[] { '-' });
    //        int id = Convert.ToInt32(values[0]);
    //        string ownerObjectType = values[1];
    //        FrtwbObject owner = null;
    //        if (ownerObjectType == "Organization")
    //        {

    //            source = FrtwbSystem.Instance.Organizations[id].Projects;
    //            owner = FrtwbSystem.Instance.Organizations[id];
    //        }
    //        else if (ownerObjectType == "Area")
    //        {
    //            source = FrtwbSystem.Instance.Areas[id].Projects;
    //            owner = FrtwbSystem.Instance.Areas[id];
    //        }
    //        else
    //            source = new Dictionary<int, Project>();

    //        OwnerObjectLabel.Text = "";
    //        bool first = true;
    //        while (owner != null)
    //        {
    //            if (first)
    //            {
    //                OwnerObjectLabel.Text = owner.Type + ": " + owner.Name;
    //                first = false;
    //            }
    //            else
    //                OwnerObjectLabel.Text = owner.Type + ": " + owner.Name + " / " + OwnerObjectLabel.Text;

    //            owner = owner.Owner;
    //        }
    //        OwnerObjectLabel.Text = "Searching activities from : " + OwnerObjectLabel.Text;
    //    }
    //    else
    //    {
    //        source = FrtwbSystem.Instance.Projects;
    //        OwnerObjectLabel.Text = "";
    //    }


    //    List<Project> results = new List<Project>();
    //    foreach (var item in source.Values)
    //    {
    //        if (item.Name.ToLower().Contains(searchTerm))
    //            results.Add(item);
    //    }

    //    ProjectsRepeater.DataSource = results;
    //    ProjectsRepeater.DataBind();
    //}

    protected void ObjectsComboBox_DataBound(object sender, EventArgs e)
    {

    }
    protected void ProjectsObjectDataSource_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        if (e.Exception != null)
        {
            SystemMessages.DisplaySystemErrorMessage(Resources.Organization.MessageErrorProjectList);
            e.ExceptionHandled = true;
        }
    }
}