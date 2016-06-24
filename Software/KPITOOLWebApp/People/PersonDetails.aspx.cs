using Artexacta.App.KPI;
using Artexacta.App.People;
using Artexacta.App.People.BLL;
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

public partial class People_PersonDetails : System.Web.UI.Page
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
            if (!string.IsNullOrEmpty(PersonIdHiddenField.Value))
                LoadData();
            else
                Response.Redirect("~/People/PeopleList.aspx");
        }
    }

    private void ProcessSessionParameteres()
    {
        int personId = 0;
        if (Request["ID"] != null && !string.IsNullOrEmpty(Request["ID"].ToString()))
        {
            try
            {
                personId = Convert.ToInt32(Request["ID"].ToString());
            }
            catch
            {
                log.Error("no se pudo realizar la conversion del parametro ID");
            }
        }
        else if (Session["PERSONID"] != null && !string.IsNullOrEmpty(Session["PERSONID"].ToString()))
        {
            try
            {
                personId = Convert.ToInt32(Session["PERSONID"].ToString());
            }
            catch
            {
                log.Error("no se pudo realizar la conversion de la session personId:" + Session["PERSONID"]);
            }

            Session["PERSONID"] = null;
        }

        if (personId > 0)
            PersonIdHiddenField.Value = Request["ID"].ToString();
    }

    private void LoadData()
    {
        //-- verify is user is OWNER
        PermissionObject theUser = new PermissionObject();
        try
        {
            theUser = PermissionObjectBLL.GetPermissionsByUser(PermissionObject.ObjectType.PERSON.ToString(), Convert.ToInt32(PersonIdHiddenField.Value));
        }
        catch (Exception exc)
        {
            SystemMessages.DisplaySystemErrorMessage(exc.Message);
            Response.Redirect("~/People/PeopleList.aspx");
        }

        if (theUser == null || !theUser.TheActionList.Exists(i => i.ObjectActionID.Equals("OWN")))
        {
            SystemMessages.DisplaySystemWarningMessage(Resources.DataDetails.UserNotOwner);
            Response.Redirect("~/People/PeopleList.aspx");
        }

        //-- show Data
        People theData = null;
        try
        {
            theData = PeopleBLL.GetPeopleById(Convert.ToInt32(PersonIdHiddenField.Value));
        }
        catch (Exception exc)
        {
            log.Error(exc.Message);
            SystemMessages.DisplaySystemErrorMessage(Resources.DataDetails.MessageErrorGetPersona);
            Response.Redirect("~/People/PeopleList.aspx");
        }

        if (theData != null)
        {
            TitleLabel.Text = theData.Name + " (" + theData.Id + ")";
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