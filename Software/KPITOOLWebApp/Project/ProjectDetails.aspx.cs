using Artexacta.App.Activities;
using Artexacta.App.KPI;
using Artexacta.App.PermissionObject;
using Artexacta.App.PermissionObject.BLL;
using Artexacta.App.Project;
using Artexacta.App.Project.BLL;
using Artexacta.App.Utilities.SystemMessages;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Project_ProjectDetails : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ProcessSessionParameteres();
            if (!string.IsNullOrEmpty(ProjectIdHiddenField.Value))
                LoadData();
            else
                Response.Redirect("~/Project/ProjectList.aspx");
        }
    }

    private void ProcessSessionParameteres()
    {
        int projectId = 0;
        if (Request["ID"] != null && !string.IsNullOrEmpty(Request["ID"].ToString()))
        {
            try
            {
                projectId = Convert.ToInt32(Request["ID"].ToString());
            }
            catch
            {
                log.Error("no se pudo realizar la conversion del parametro ID");
            }
        }
        else if (Session["PROJECTID"] != null && !string.IsNullOrEmpty(Session["PROJECTID"].ToString()))
        {
            try
            {
                projectId = Convert.ToInt32(Session["PROJECTID"].ToString());
            }
            catch
            {
                log.Error("no se pudo realizar la conversion de la session projectId:" + Session["PROJECTID"]);
            }

            Session["PROJECTID"] = null;
        }

        if (projectId > 0)
            ProjectIdHiddenField.Value = projectId.ToString();
    }

    private void LoadData()
    {
        //-- verify is user is OWNER
        PermissionObject theUser = new PermissionObject();
        try
        {
            theUser = PermissionObjectBLL.GetPermissionsByUser(PermissionObject.ObjectType.PROJECT.ToString(), Convert.ToInt32(ProjectIdHiddenField.Value));
        }
        catch (Exception exc)
        {
            SystemMessages.DisplaySystemErrorMessage(exc.Message);
            Response.Redirect("~/Project/ProjectList.aspx");
        }

        if (theUser == null || !theUser.TheActionList.Exists(i => i.ObjectActionID.Equals("OWN")))
        {
            SystemMessages.DisplaySystemWarningMessage("The user is not owner, cannot view the summary information.");
            Response.Redirect("~/Project/ProjectList.aspx");
        }

        //-- show Data
        Project theData = null;
        try
        {
            theData = ProjectBLL.GetProjectById(Convert.ToInt32(ProjectIdHiddenField.Value));
        }
        catch (Exception exc)
        {
            SystemMessages.DisplaySystemErrorMessage(exc.Message);
            Response.Redirect("~/Project/ProjectList.aspx");
        }

        if (theData != null)
        {
            TitleLabel.Text = theData.Name;
        }
    }

    protected void ActivitiesGridView_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.DataItem is Activity)
        {
            Activity theData = (Activity)e.Row.DataItem;

            HyperLink viewButton = (HyperLink)e.Row.FindControl("ViewButton");
            viewButton.NavigateUrl = "~/Activity/ActivityDetails.aspx?ID=" + theData.ActivityID;

            HyperLink organizationNameLink = (HyperLink)e.Row.FindControl("OrganizationNameLink");
            organizationNameLink.NavigateUrl = "~/Organization/OrganizationDetails.aspx?ID=" + theData.OrganizationID;

            if (theData.AreaID <= 0)
            {
                Label separatorArea = (Label)e.Row.FindControl("SeparatorArea");
                separatorArea.Visible = false;
                Label areaNameLabel = (Label)e.Row.FindControl("AreaNameLabel");
                areaNameLabel.Visible = false;
            }
            if (theData.ProjectID <= 0)
            {
                Label separatorProject = (Label)e.Row.FindControl("separatorProject");
                separatorProject.Visible = false;
            }
        }
    }

    protected void KpisGridView_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.DataItem is KPI)
        {
            KPI theData = (KPI)e.Row.DataItem;

            HyperLink organizationNameLink = (HyperLink)e.Row.FindControl("OrganizationNameLink");
            organizationNameLink.NavigateUrl = "~/Organization/OrganizationDetails.aspx?ID=" + theData.OrganizationID;

            if (theData.AreaID <= 0)
            {
                Label separatorArea = (Label)e.Row.FindControl("SeparatorArea");
                separatorArea.Visible = false;
                Label areaNameLabel = (Label)e.Row.FindControl("AreaNameLabel");
                areaNameLabel.Visible = false;
            }
            if (theData.ProjectID <= 0)
            {
                Label separatorProject = (Label)e.Row.FindControl("separatorProject");
                separatorProject.Visible = false;
            }
            if (theData.ActivityID <= 0)
            {
                Label separatorActivity = (Label)e.Row.FindControl("SeparatorActivity");
                separatorActivity.Visible = false;
                HyperLink activityNameLink = (HyperLink)e.Row.FindControl("ActivityNameLink");
                activityNameLink.Visible = false;
            }
            else
            {
                HyperLink activityNameLink = (HyperLink)e.Row.FindControl("ActivityNameLink");
                activityNameLink.NavigateUrl = "~/Activity/ActivityDetails.aspx?ID=" + theData.ActivityID;
            }
            if (theData.PersonID <= 0)
            {
                Label separatorPerson = (Label)e.Row.FindControl("SeparatorPerson");
                separatorPerson.Visible = false;
                HyperLink personNameLink = (HyperLink)e.Row.FindControl("PersonNameLink");
                personNameLink.Visible = false;
            }
            else
            {
                HyperLink personNameLink = (HyperLink)e.Row.FindControl("PersonNameLink");
                personNameLink.NavigateUrl = "~/People/PersonDetails.aspx?ID=" + theData.PersonID;
            }
        }
    }

    protected void KpisGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        string kpiId = e.CommandArgument.ToString();
        if (e.CommandName.Equals("ViewData"))
        {
            Session["KpiId"] = kpiId;
            Response.Redirect("~/Kpis/KpiDetails.aspx");
        }
    }

    protected void ObjectDataSource_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        if (e.Exception != null)
        {
            e.ExceptionHandled = true;
            SystemMessages.DisplaySystemErrorMessage(Resources.Organization.MessageErrorCargarAreas);
        }
    }

}