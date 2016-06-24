﻿using Artexacta.App.Utilities.SystemMessages;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using Artexacta.App.Activities;
using Artexacta.App.Organization;
using Artexacta.App.Organization.BLL;
using Artexacta.App.Project;
using Artexacta.App.Project.BLL;
using Artexacta.App.KPI.BLL;
using Artexacta.App.KPI;
using Artexacta.App.Activities.BLL;

public partial class Activity_ActivitiesList : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    protected override void InitializeCulture()
    {
        Artexacta.App.Utilities.LanguageUtilities.SetLanguageFromContext();
        base.InitializeCulture();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        ActivitySearchControl.Config = new ActivitiesSearch();
        ActivitySearchControl.OnSearch += ActivitySearchControl_OnSearch;

        if (!IsPostBack)
        {
            Tour.Show();
            ProcessSessionParameters();
        }
    }

    void ActivitySearchControl_OnSearch()
    {
        ActivityRepeater.DataBind();
    }

    private void ProcessSessionParameters()
    {
        if (Session["SEARCH_PARAMETER"] != null && !string.IsNullOrEmpty(Session["SEARCH_PARAMETER"].ToString()))
        {
            ActivitySearchControl.Query = Session["SEARCH_PARAMETER"].ToString();
        }
        Session["SEARCH_PARAMETER"] = null;
    }

    protected string GetOrganizationInfo(Object obj)
    {
        int OrganizationID = 0;
        string name = "";
        try
        {
            OrganizationID = (int)obj;
        }
        catch { return "-"; }

        if (OrganizationID > 0)
        {
            Organization theClass = null;

            try
            {
                theClass = OrganizationBLL.GetOrganizationById(OrganizationID);
            }
            catch { }

            if (theClass != null)
                name = theClass.Name;
        }

        return name;
    }

    protected string GetProjectInfo(Object obj)
    {
        int projectID = 0;
        string name = "";
        try
        {
            projectID = (int)obj;
        }
        catch { return "-"; }

        if (projectID > 0)
        {
            Project theClass = null;

            try
            {
                theClass = ProjectBLL.GetProjectById(projectID);
            }
            catch { }

            if (theClass != null)
                name = " - " + theClass.Name;
        }

        return name;
    }

    protected void ActivityRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem)
            return;

        LinkButton buttonDelete = (LinkButton)e.Item.FindControl("DeleteActivity");
        if (buttonDelete != null)
            buttonDelete.OnClientClick = String.Format("return confirm('{0}')", Resources.Activity.MessageConfirmDelete);

        Activity item = (Activity)e.Item.DataItem;

        //KPI
        KPIBLL theKBLL = new KPIBLL();
        List<KPI> theKPIs = new List<KPI>();

        try
        {
            theKPIs = theKBLL.GetKPIsByActivity(item.ActivityID);
        }
        catch { }

        if (theKPIs.Count == 0)
        {
            Panel element = (Panel)e.Item.FindControl("emptyMessage");
            element.Visible = true;
            return;
        }

        Panel detailsPanel = (Panel)e.Item.FindControl("detailsContainer");
        detailsPanel.Visible = true;

        Panel kpiImagePanel = (Panel)e.Item.FindControl("KpiImageContainer");
        kpiImagePanel.Visible = true;

        LinkButton kpisButton = (LinkButton)e.Item.FindControl("KpisButton");

        kpisButton.Visible = theKPIs.Count > 0;
        kpisButton.Text = kpisButton.Visible ? theKPIs.Count + " KPI(s)" : "";

    }

    protected void ActivityRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        int activityId = 0;
        try
        {
            activityId = Convert.ToInt32(e.CommandArgument);
        }
        catch (Exception ex)
        {
            log.Error("Error getting object id", ex);
        }
        if (activityId <= 0)
        {
            SystemMessages.DisplaySystemErrorMessage(Resources.Organization.MessageNoComplete);
            return;
        }
        if (e.CommandName == "EditActivity")
        {
            Session["ActivityId"] = activityId;
            Session["ParentPage"] = "~/Activity/ActivitiesList.aspx";
            Response.Redirect("~/Activity/AddActivity.aspx");
            return;
        }
        if (e.CommandName == "ViewActivity")
        {
            Session["ActivityId"] = activityId;
            Session["ParentPage"] = "~/Activity/ActivitiesList.aspx";
            Response.Redirect("~/Activity/ActivityDetails.aspx");
            return;
        }
        if (e.CommandName == "DeleteActivity")
        {
            try
            {
                ActivityBLL.DeleteActivity(activityId);
            }
            catch (Exception ex)
            {
                SystemMessages.DisplaySystemErrorMessage(ex.Message);
                return;
            }
            SystemMessages.DisplaySystemMessage(Resources.Activity.MessageDeleted);
            ActivityRepeater.DataBind();
        }
        if (e.CommandName == "ViewKPIs")
        {
            Session["SEARCH_PARAMETER"] = "@activityID " + activityId.ToString();
            Response.Redirect("~/Kpi/KpiList.aspx");
            return;
        }
        if (e.CommandName == "ViewOrganization")
        {
            Session["SEARCH_PARAMETER"] = "@organizationID " + activityId.ToString();
            Response.Redirect("~/MainPage.aspx");
            return;
        }
        if (e.CommandName == "ViewProject")
        {
            Session["SEARCH_PARAMETER"] = "@projectID " + activityId.ToString();
            Response.Redirect("~/Project/ProjectList.aspx");
            return;
        }
    }

    protected void ActivityObjectDataSource_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        if (e.Exception != null)
        {
            e.ExceptionHandled = true;
            SystemMessages.DisplaySystemErrorMessage(Resources.Activity.MessageErrorGetActivities);
        }
    }
}
