﻿using Artexacta.App.Utilities.SystemMessages;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
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
using Artexacta.App.User.BLL;

public partial class Project_ProjectList : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    protected override void InitializeCulture()
    {
        Artexacta.App.Utilities.LanguageUtilities.SetLanguageFromContext();
        base.InitializeCulture();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        ProjectSearchControl.Config = new ProjectSearch();
        ProjectSearchControl.OnSearch += ProjectSearchControl_OnSearch;

        if (!IsPostBack)
        {
            try
            {
                int userId = UserBLL.GetUserIdByUsername(User.Identity.Name);
                Tour.UserId = userId;
            }
            catch (Exception ex)
            {
                log.Error("Error getting userId from session", ex);
            }
            Tour.Show();
            if (Session["SEARCH_PARAMETER"] != null && !string.IsNullOrEmpty(Session["SEARCH_PARAMETER"].ToString()))
            {
                ProjectSearchControl.Query = Session["SEARCH_PARAMETER"].ToString();
            }
            Session["SEARCH_PARAMETER"] = null;
        }
    }

    void ProjectSearchControl_OnSearch()
    {
        log.Debug(ProjectSearchControl.Query.ToString());
    }

    protected void ProjectsRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem)
            return;

        //Change the text of confirmation message of delete button
        LinkButton buttonDelete = (LinkButton)e.Item.FindControl("DeleteProject");
        if (buttonDelete != null)
            buttonDelete.OnClientClick = String.Format("return confirm('{0}')", Resources.Project.MessageConfirmDelete);

        Project item = (Project)e.Item.DataItem;

        if (item == null)
            return;

        //If exists AreaName Show the GuionLabel
        if (!string.IsNullOrEmpty(item.AreaName))
        {
            Label theGuion = (Label)e.Item.FindControl("GuionLabel");
            if (theGuion != null)
                theGuion.Visible = true;
        }

        //Show the delete button if is Owner
        HiddenField theHFOwner = (HiddenField)e.Item.FindControl("IsOwnerHiddenField");
        if (theHFOwner != null)
        {
            if (!Convert.ToBoolean(theHFOwner.Value))
            {
                Panel panelDelete = (Panel)e.Item.FindControl("pnlDelete");
                if (panelDelete != null)
                {
                    panelDelete.CssClass = "col-md-1 col-sm-1 col-xs-3 disabled";
                }

                Panel panelShare = (Panel)e.Item.FindControl("pnlShare");
                if (panelShare != null)
                {
                    panelShare.CssClass = "col-md-1 col-sm-1 col-xs-3 disabled";
                }
            }
        }

        //Activities
        ActivityBLL theACBLL = new ActivityBLL();
        List<Activity> theActivities = new List<Activity>();

        try
        {
            theActivities = theACBLL.GetActivitiesByProject(item.ProjectID);
        }
        catch { }

        if (theActivities.Count == 0 && item.NumberOfKpis == 0)
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
        activitiesButton.Text = activitiesButton.Visible ? theActivities.Count + (theActivities.Count == 1 ? " " + Resources.Organization.LabelActivity : " " + Resources.Organization.LabelActivities) : "";

        kpisButton.Visible = item.NumberOfKpis > 0;
        kpisButton.Text = kpisButton.Visible ? item.NumberOfKpis + " KPI(s)" : "";

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
            SystemMessages.DisplaySystemErrorMessage(Resources.Organization.MessageNoComplete);
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
            Session["SEARCH_PARAMETER"] = "@projectID " + projectId.ToString();
            Response.Redirect("~/Activity/ActivitiesList.aspx");
            return;
        }
        if (e.CommandName == "ViewKPIs")
        {
            Session["SEARCH_PARAMETER"] = "@projectID " + projectId.ToString();
            Response.Redirect("~/Kpi/KpiList.aspx");
            return;
        }
        if (e.CommandName == "ViewOrganization")
        {
            Session["SEARCH_PARAMETER"] = "@organizationID " + projectId.ToString();
            Response.Redirect("~/MainPage.aspx");
            return;
        }
        if (e.CommandName == "ViewArea")
        {
            Session["OrganizationId"] = projectId.ToString();
            Response.Redirect("~/Organization/EditOrganization.aspx");
            return;
        }
        if (e.CommandName.Equals("ShareProject"))
        {
            Session["PROJECTID"] = projectId.ToString();
            Response.Redirect("~/Project/ShareProject.aspx");
        }
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