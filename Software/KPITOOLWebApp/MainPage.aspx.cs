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
using Artexacta.App.Utilities.Quantity;
using Artexacta.App.User.BLL;

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
        log.Debug(OrgSearchControl.Sql);
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

        try
        {
            int userId = UserBLL.GetUserIdByUsername(User.Identity.Name);
            Tour.UserId = userId;
        }
        catch (Exception ex)
        {
            log.Error("Error getting userId from session", ex);
        }

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

        LinkButton buttonDelete = (LinkButton)e.Item.FindControl("DeleteOrganization");
        if (buttonDelete != null)
            buttonDelete.OnClientClick = String.Format("return confirm('{0}')", Resources.Organization.MessageConfirmDelete);

        Organization item = (Organization)e.Item.DataItem;

        if (item == null)
            return;

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

        Quantity theQuantity = null;

        try
        {
            theQuantity = OrganizationBLL.GetQuantityByOrganization(item.OrganizationID);
        }
        catch {}

        if (theQuantity == null)
            return;

        if (theQuantity.Areas == 0 && theQuantity.Projects == 0 && theQuantity.Activities == 0 && theQuantity.Kpis == 0 && theQuantity.People == 0)
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

        areasLabel.Visible = theQuantity.Areas > 0;
        areasLabel.Text = areasLabel.Visible ? theQuantity.Areas + " Area" + (theQuantity.Areas == 1 ? "" : "s") : "";

        projectButton.Visible = theQuantity.Projects > 0;
        projectButton.Text = projectButton.Visible ? theQuantity.Projects + " " + Resources.Organization.LabelProjects : "";

        activitiesButton.Visible = theQuantity.Activities > 0;
        activitiesButton.Text = activitiesButton.Visible ? theQuantity.Activities + (theQuantity.Activities == 1 ? " " + Resources.Organization.LabelActivity : " " + Resources.Organization.LabelActivities) : "";

        if (ShowPeopleCheckbox.Checked)
        {
            PersonButton.Visible = theQuantity.People > 0;
            PersonButton.Text = PersonButton.Visible ? theQuantity.People + (theQuantity.People == 1 ? " " + Resources.Organization.LabelPeople : " " + Resources.Organization.LabelPerson) : "";
        }

        kpisButton.Visible = theQuantity.Kpis > 0;
        kpisButton.Text = kpisButton.Visible ? theQuantity.Kpis + " KPI" + (theQuantity.Kpis == 1 ? "" : "s") : "";

        and1.Visible = areasLabel.Visible && projectButton.Visible;
        if (and1.Visible)
        {
            if (activitiesButton.Visible || kpisButton.Visible)
                and1.Text = ",";
            else
                and1.Text = " " + Resources.Organization.LabelAnd + " ";
        }

        and2.Visible = projectButton.Visible && activitiesButton.Visible;
        if (and2.Visible)
        {
            if (kpisButton.Visible)
                and2.Text = ",";
            else
                and2.Text = " " + Resources.Organization.LabelAnd + " ";
        }

        and3.Visible = activitiesButton.Visible && PersonButton.Visible;
        if (and3.Visible)
        {
            if (PersonButton.Visible)
                and3.Text = ",";
            else
                and3.Text = " " + Resources.Organization.LabelAnd + " ";
        }

        and4.Visible = kpisButton.Visible;
        if (and4.Visible && kpisButton.Visible)
        {
            and4.Text = " " + Resources.Organization.LabelAnd + " ";
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
        if (organizationId <= 0)
        {
            SystemMessages.DisplaySystemErrorMessage(Resources.Organization.MessageNoComplete);
            return;
        }

        if (e.CommandName == "ViewProjects")
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
        if (e.CommandName == "DeleteOrganization")
        {
            try
            {
                OrganizationBLL.DeleteOrganization(organizationId);
                SystemMessages.DisplaySystemMessage(Resources.Organization.MessageDeleteOk);
            }
            catch (Exception ex)
            {
                SystemMessages.DisplaySystemErrorMessage(ex.Message);
                return;
            }

            BindOrganizations();
            return;
        }

        if (e.CommandName == "EditOrganization")
        {
            Session["OrganizationId"] = organizationId;
            Response.Redirect("~/Organization/EditOrganization.aspx");
            return;
        }

        if (e.CommandName == "ViewOrganization")
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
            SystemMessages.DisplaySystemErrorMessage(e.Exception.Message);
            e.ExceptionHandled = true;
        }
    }
    protected void ShowPeopleCheckbox_CheckedChanged(object sender, EventArgs e)
    {
        BindOrganizations();
    }
}