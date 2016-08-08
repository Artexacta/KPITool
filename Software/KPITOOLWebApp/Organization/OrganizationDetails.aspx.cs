using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Artexacta.App.Organization.BLL;
using Artexacta.App.Organization;
using Artexacta.App.Utilities.SystemMessages;
using Artexacta.App.Area;
using Artexacta.App.PermissionObject;
using Artexacta.App.PermissionObject.BLL;
using Artexacta.App.Project;
using Artexacta.App.Activities;
using Artexacta.App.People;
using Artexacta.App.KPI;

public partial class Organization_OrganizationDetails : System.Web.UI.Page
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
            if (!string.IsNullOrEmpty(OrganizationIdHiddenField.Value))
                LoadData();
            else
                Response.Redirect("~/Organization/ListOrganizations.aspx");
        }
    }

    private void ProcessSessionParameteres()
    {
        int organizationId = 0;
        if (Request["ID"] != null && !string.IsNullOrEmpty(Request["ID"].ToString()))
        {
            try
            {
                organizationId = Convert.ToInt32(Request["ID"].ToString());
            }
            catch
            {
                log.Error("no se pudo realizar la conversion del parametro ID");
            }
        }
        else if (Session["ORGANIZATIONID"] != null && !string.IsNullOrEmpty(Session["ORGANIZATIONID"].ToString()))
        {
            try
            {
                organizationId = Convert.ToInt32(Session["ORGANIZATIONID"].ToString());
            }
            catch
            {
                log.Error("no se pudo realizar la conversion de la session organizationId:" + Session["ORGANIZATIONID"]);
            }

            Session["ORGANIZATIONID"] = null;
        }

        if (organizationId > 0)
            OrganizationIdHiddenField.Value = organizationId.ToString();
    }

    private void LoadData()
    {
        //-- verify is user is OWNER
        //PermissionObject theUser = new PermissionObject();
        //try
        //{
        //    theUser = PermissionObjectBLL.GetPermissionsByUser(PermissionObject.ObjectType.ORGANIZATION.ToString(), Convert.ToInt32(OrganizationIdHiddenField.Value));
        //}
        //catch (Exception exc)
        //{
        //    SystemMessages.DisplaySystemErrorMessage(exc.Message);
        //    Response.Redirect("~/Organization/ListOrganizations.aspx");
        //}

        //if (theUser == null || !theUser.TheActionList.Exists(i => i.ObjectActionID.Equals("OWN")))
        //{
        //    SystemMessages.DisplaySystemWarningMessage(Resources.DataDetails.UserNotOwner);
        //    Response.Redirect("~/Organization/ListOrganizations.aspx");
        //}

        //-- show Data
        Organization theData = null;
        try
        {
            theData = OrganizationBLL.GetOrganizationById(Convert.ToInt32(OrganizationIdHiddenField.Value));
        }
        catch (Exception exc)
        {
            log.Error(exc.Message);
            SystemMessages.DisplaySystemErrorMessage(Resources.DataDetails.MessageErrorGetOrganization);
            Response.Redirect("~/Organization/ListOrganizations.aspx");
        }

        if (theData != null)
        {
            TitleLabel.Text = theData.Name;
        }
    }

    protected void ProjectsGridView_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.DataItem is Project)
        {
            Project theData = (Project)e.Row.DataItem;
            if (theData.AreaID <= 0)
            {
                Label separatorArea = (Label)e.Row.FindControl("SeparatorArea");
                separatorArea.Visible = false;
                Label areaNameLabel = (Label)e.Row.FindControl("AreaNameLabel");
                areaNameLabel.Visible = false;
            }

            HyperLink viewButton = (HyperLink)e.Row.FindControl("ViewButton");
            viewButton.NavigateUrl = "~/Project/ProjectDetails.aspx?ID=" + theData.ProjectID;
        }
    }

    protected void ActivitiesGridView_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.DataItem is Activity)
        {
            Activity theData = (Activity)e.Row.DataItem;
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

            HyperLink viewButton = (HyperLink)e.Row.FindControl("ViewButton");
            viewButton.NavigateUrl = "~/Activity/ActivityDetails.aspx?ID=" + theData.ActivityID;
        }
    }

    protected void PeopleGridView_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.DataItem is People)
        {
            People theData = (People)e.Row.DataItem;
            if (theData.AreaId <= 0)
            {
                Label separatorArea = (Label)e.Row.FindControl("SeparatorArea");
                separatorArea.Visible = false;
                Label areaNameLabel = (Label)e.Row.FindControl("AreaNameLabel");
                areaNameLabel.Visible = false;
            }

            HyperLink viewButton = (HyperLink)e.Row.FindControl("ViewButton");
            viewButton.NavigateUrl = "~/People/PersonDetails.aspx?ID=" + theData.PersonId;
        }
    }

    protected void KpisGridView_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.DataItem is KPI)
        {
            KPI theData = (KPI)e.Row.DataItem;
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