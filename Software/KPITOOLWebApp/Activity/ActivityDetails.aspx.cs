using Artexacta.App.Activities;
using Artexacta.App.Activities.BLL;
using Artexacta.App.KPI;
using Artexacta.App.PermissionObject;
using Artexacta.App.PermissionObject.BLL;
using Artexacta.App.Utilities.SystemMessages;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Activity_ActivityDetails : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    protected override void InitializeCulture()
    {
        Artexacta.App.Utilities.LanguageUtilities.SetLanguageFromContext();
        base.InitializeCulture();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ProcessSessionParameteres();
            if (!string.IsNullOrEmpty(ActivityIdHiddenField.Value))
                LoadData();
            else
                Response.Redirect("~/Activity/ActivitiesList.aspx");
        }
    }

    private void ProcessSessionParameteres()
    {
        int activityId = 0;
        if (Request["ID"] != null && !string.IsNullOrEmpty(Request["ID"].ToString()))
        {
            try
            {
                activityId = Convert.ToInt32(Request["ID"].ToString());
            }
            catch
            {
                log.Error("no se pudo realizar la conversion del parametro ID");
            }
        }
        else if (Session["ACTIVITYID"] != null && !string.IsNullOrEmpty(Session["ACTIVITYID"].ToString()))
        {
            try
            {
                activityId = Convert.ToInt32(Session["ACTIVITYID"].ToString());
            }
            catch
            {
                log.Error("no se pudo realizar la conversion de la session activityId:" + Session["ACTIVITYID"]);
            }

            Session["ACTIVITYID"] = null;
        }

        if (activityId > 0)
            ActivityIdHiddenField.Value = activityId.ToString();
    }

    private void LoadData()
    {
        //-- verify is user is OWNER
        //PermissionObject theUser = new PermissionObject();
        //try
        //{
        //    theUser = PermissionObjectBLL.GetPermissionsByUser(PermissionObject.ObjectType.ACTIVITY.ToString(), Convert.ToInt32(ActivityIdHiddenField.Value));
        //}
        //catch (Exception exc)
        //{
        //    SystemMessages.DisplaySystemErrorMessage(exc.Message);
        //    Response.Redirect("~/Activity/ActivitiesList.aspx");
        //}

        //if (theUser == null || !theUser.TheActionList.Exists(i => i.ObjectActionID.Equals("OWN")))
        //{
        //    SystemMessages.DisplaySystemWarningMessage(Resources.DataDetails.UserNotOwner);
        //    Response.Redirect("~/Activity/ActivitiesList.aspx");
        //}

        //-- show Data
        Activity theData = null;
        try
        {
            theData = ActivityBLL.GetActivityById(Convert.ToInt32(ActivityIdHiddenField.Value));
        }
        catch (Exception exc)
        {
            log.Error(exc.Message);
            SystemMessages.DisplaySystemErrorMessage(Resources.DataDetails.MessageErrorGetActivity);
            Response.Redirect("~/Activity/ActivitiesList.aspx");
        }

        if (theData != null)
        {
            TitleLabel.Text = theData.Name;
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
                HyperLink projectNameLink = (HyperLink)e.Row.FindControl("ProjectNameLink");
                projectNameLink.Visible = false;
            }
            else
            {
                HyperLink projectNameLink = (HyperLink)e.Row.FindControl("ProjectNameLink");
                projectNameLink.NavigateUrl = "~/Project/ProjectDetails.aspx?ID=" + theData.ProjectID.ToString();
            }
            if (theData.ActivityID <= 0)
            {
                Label separatorActivity = (Label)e.Row.FindControl("SeparatorActivity");
                separatorActivity.Visible = false;
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
        if (e.CommandName.Equals("ViewData") && !string.IsNullOrEmpty(kpiId))
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
            SystemMessages.DisplaySystemErrorMessage(e.Exception.Message);
        }
    }

}