using Artexacta.App.Seguimiento;
using Artexacta.App.Utilities.SystemMessages;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Artexacta.App.Organization.BLL;
using Artexacta.App.Organization;
using Artexacta.App.Area.BLL;
using Artexacta.App.Area;
using Artexacta.App.Project.BLL;
using Artexacta.App.Project;
using Artexacta.App.Activities.BLL;
using Artexacta.App.Activities;
using Artexacta.App.KPI.BLL;
using Artexacta.App.KPI;
using Artexacta.App.People.BLL;
using Artexacta.App.People;

public partial class MainPage : SqlViewStatePage
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

        protected override void InitializeCulture()
        {
            Artexacta.App.Utilities.LanguageUtilities.SetLanguageFromContext();
            base.InitializeCulture();
        }

    protected void Page_Load(object sender, EventArgs e)
    {
        OrgSearchControl.Config = new OrganizationSearch();
        OrgSearchControl.OnSearch += OrgSearchControl_OnSearch;

        if (!IsPostBack)
        {
            if (Session["SEARCH_PARAMETER"] != null && !string.IsNullOrEmpty(Session["SEARCH_PARAMETER"].ToString()))
            {
                OrgSearchControl.Query = Session["SEARCH_PARAMETER"].ToString();
            }
            Session["SEARCH_PARAMETER"] = null;

            BindOrganizations();
        }
    }

    void OrgSearchControl_OnSearch()
    {
        BindOrganizations();
    }

    private void BindOrganizations()
    {
        //Get the list of organizations
        OrganizationBLL theBLL = new OrganizationBLL();
        List<Organization> theOrganizations = new List<Organization>();

        try
        {
            theOrganizations = theBLL.GetOrganizationsByUser(OrgSearchControl.Sql);
        }
        catch (Exception exc)
        {
            SystemMessages.DisplaySystemErrorMessage(exc.Message);
            return;
        }

        OrganizationsRepeater.DataSource = theOrganizations;
        OrganizationsRepeater.DataBind();

        if (theOrganizations.Count == 0)
        {
            Tour.Hide();
        }
        if (theOrganizations.Count > 0)
        {
            Tour.Show();
        }
    }
    
    protected void OrganizationsRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem)
            return;
        
        Organization item = (Organization)e.Item.DataItem;

        if (item == null)
            return;

        //Areas
        AreaBLL theABLL = new AreaBLL();
        List<Area> theAreas = new List<Area>();
        try
        {
            theAreas = theABLL.GetAreasByOrganization(item.OrganizationID);
        }
        catch {}

        //Projects
        ProjectBLL thePBLL = new ProjectBLL();
        List<Project> theProjects = new List<Project>();

        try
        {
            theProjects = thePBLL.GetProjectsByOrganization(item.OrganizationID);
        }
        catch {}

        //Activities
        ActivityBLL theACBLL = new ActivityBLL();
        List<Activity> theActivities = new List<Activity>();

        try
        {
            theActivities = theACBLL.GetActivitiesByOrganization(item.OrganizationID);
        }
        catch {}

        //KPI
        KPIBLL theKBLL = new KPIBLL();
        List<KPI> theKPIs = new List<KPI>();

        try
        {
            theKPIs = theKBLL.GetKPIsByOrganization(item.OrganizationID);
        }
        catch {}

        //Person
        PeopleBLL thePLLBLL = new PeopleBLL();
        List<People> thePerson = new List<People>();

        if (ShowPeopleCheckbox.Checked)
        {
            try
            {
                thePerson = thePLLBLL.GetPeopleByOrganization(item.OrganizationID);
            }
            catch { }
        }

        if (theAreas.Count == 0 && theProjects.Count == 0 && theActivities.Count == 0 && theKPIs.Count == 0 && thePerson.Count == 0)
        {
            Panel element = (Panel)e.Item.FindControl("emptyMessage");
            element.Visible = true;
            return;
        }

        Panel detailsPanel = (Panel)e.Item.FindControl("detailsContainer");
        detailsPanel.Visible = true;

        Panel kpiImagePanel = (Panel)e.Item.FindControl("KpiImageContainer");
        kpiImagePanel.Visible = true;

        Label areasLabel = (Label)e.Item.FindControl("AreasLabel");
        LinkButton projectButton = (LinkButton)e.Item.FindControl("ProjectsButton");
        LinkButton activitiesButton = (LinkButton)e.Item.FindControl("ActivitiesButton");
        LinkButton kpisButton = (LinkButton)e.Item.FindControl("KpisButton");
        LinkButton PersonButton = (LinkButton)e.Item.FindControl("PersonLinkButton");

        Literal and1 = (Literal)e.Item.FindControl("AndLiteral1");
        Literal and2 = (Literal)e.Item.FindControl("AndLiteral2");
        Literal and3 = (Literal)e.Item.FindControl("AndLiteral3");
        Literal and4 = (Literal)e.Item.FindControl("AndLiteral4");

        areasLabel.Visible = theAreas.Count > 0;
        areasLabel.Text = areasLabel.Visible ? theAreas.Count + " Area" + (theAreas.Count == 1 ? "" : "s") : "";

        projectButton.Visible = theProjects.Count > 0;
        projectButton.Text = projectButton.Visible ? theProjects.Count + " Project(s)" : "";

        activitiesButton.Visible = theActivities.Count > 0;
        activitiesButton.Text = activitiesButton.Visible ? theActivities.Count + (theActivities.Count == 1 ? " Activity" : " Activities") : "";

        if (ShowPeopleCheckbox.Checked)
        {
            PersonButton.Visible = thePerson.Count > 0;
            PersonButton.Text = PersonButton.Visible ? thePerson.Count + (thePerson.Count == 1 ? " People" : " Person") : "";
        }

        kpisButton.Visible = theKPIs.Count > 0;
        kpisButton.Text = kpisButton.Visible ? theKPIs.Count + " KPI" + (theKPIs.Count == 1 ? "" : "s") : "";

        and1.Visible = areasLabel.Visible && projectButton.Visible;
        if (and1.Visible)
        {
            if (activitiesButton.Visible || kpisButton.Visible)
                and1.Text = ",";
            else
                and1.Text = " and ";
        }

        and2.Visible = projectButton.Visible && activitiesButton.Visible;
        if (and2.Visible)
        {
            if (kpisButton.Visible)
                and2.Text = ",";
            else
                and2.Text = " and ";
        }

        and3.Visible = activitiesButton.Visible && PersonButton.Visible;
        if (and3.Visible)
        {
            if (PersonButton.Visible)
                and3.Text = ",";
            else
                and3.Text = " and ";
        }

        and4.Visible = kpisButton.Visible;
        if (and4.Visible && kpisButton.Visible)
        {
            and4.Text = " and ";
        }
    }
    
    protected void OrganizationsRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        int organizationId = 0;
        try
        {
            organizationId = Convert.ToInt32(e.CommandArgument);
        }
        catch (Exception ex)
        {
            log.Error("Cannot convert e.CommandArgument to integer value", ex);
        }
        if(organizationId <= 0)
        {
            SystemMessages.DisplaySystemErrorMessage("Could not complete the requested action");
            return;
        }

        if(e.CommandName == "ViewProjects")
        {
            Session["SEARCH_PARAMETER"] = "@organizationID " + organizationId.ToString();
            Response.Redirect("~/Project/ProjectList.aspx");
            return;
        }
        if (e.CommandName == "ViewActivities")
        {
            Session["SEARCH_PARAMETER"] = "@organizationID " + organizationId.ToString();
            Response.Redirect("~/Activity/ActivitiesList.aspx");
            return;
        }
        if (e.CommandName == "ViewKPIs")
        {
            Session["SEARCH_PARAMETER"] = "@organizationID " + organizationId.ToString();
            Response.Redirect("~/Kpi/KpiList.aspx");
            return;
        }
        if (e.CommandName == "ViewPersons")
        {
            Session["SEARCH_PARAMETER"] = "@organizationID " + organizationId.ToString();
            Response.Redirect("~/Personas/ListaPersonas.aspx");
            return;
        }
        if(e.CommandName == "DeleteOrganization")
        {
            try
            {
                OrganizationBLL.DeleteOrganization(organizationId);
                SystemMessages.DisplaySystemMessage(Resources.Organization.MessageDeleteOk);
            }
            catch (Exception ex)
            {
                log.Error("Error deleting an Organization", ex);
                SystemMessages.DisplaySystemErrorMessage(ex.Message);
                return;
            }

            BindOrganizations();
            return;
        }

        if(e.CommandName == "EditOrganization")
        {
            Session["OrganizationId"] = organizationId;
            Response.Redirect("~/Organization/EditOrganization.aspx");
            return;
        }
        
        if(e.CommandName == "ViewOrganization")
        {
            Session["OrganizationId"] = organizationId;
            Response.Redirect("~/Organization/OrganizationDetails.aspx");
        }

        if (e.CommandName.Equals("ShareOrganization"))
        {
            Session["ORGANIZATIONID"] = organizationId;
            Response.Redirect("~/Organization/ShareOrganization.aspx");
        }
    }

    protected void OrgObjectDataSource_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        if (e.Exception != null)
        {
            SystemMessages.DisplaySystemErrorMessage("Error to get the organization list.");
            e.ExceptionHandled = true;
        }
    }
    protected void ShowPeopleCheckbox_CheckedChanged(object sender, EventArgs e)
    {
        BindOrganizations();
    }
}