using Artexacta.App.Utilities.SystemMessages;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Artexacta.App.Organization;
using Artexacta.App.Organization.BLL;
using Artexacta.App.Area;
using Artexacta.App.Area.BLL;
using Artexacta.App.People;
using Artexacta.App.KPI.BLL;
using Artexacta.App.KPI;
using Artexacta.App.People.BLL;

public partial class Personas_ListaPersonas : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    protected override void InitializeCulture()
    {
        Artexacta.App.Utilities.LanguageUtilities.SetLanguageFromContext();
        base.InitializeCulture();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        PeopleSearchControl.Config = new PeopleSearch();
        PeopleSearchControl.OnSearch += new UserControls_SearchUserControl_SearchControl.OnSearchDelegate(PeopleSearchControl_OnSearch);

        if (!IsPostBack)
        {
            if (Session["SEARCH_PARAMETER"] != null && !string.IsNullOrEmpty(Session["SEARCH_PARAMETER"].ToString()))
            {
                PeopleSearchControl.Query = Session["SEARCH_PARAMETER"].ToString();
            }
            Session["SEARCH_PARAMETER"] = null;
        }
    }

    void PeopleSearchControl_OnSearch()
    {
        log.Debug("Binding RadGrid on Search");
        PeopleRepeater.DataBind();
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

    protected void PersonaObjectDataSource_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        if (e.Exception != null)
        {
            SystemMessages.DisplaySystemErrorMessage(e.Exception.Message);
            e.ExceptionHandled = true;
        }
    }

    protected void PeopleRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        int personId = 0;
        try
        {
            personId = Convert.ToInt32(e.CommandArgument);
        }
        catch (Exception ex)
        {
            log.Error("Error getting object id", ex);
        }
        if (personId <= 0)
        {
            SystemMessages.DisplaySystemErrorMessage(Resources.People.MessageNotAction);
            return;
        }

        if (e.CommandName.Equals("ViewPerson"))
        {
            Session["PERSONID"] = personId.ToString();
            Response.Redirect("~/People/PersonDetails.aspx");
        }
        if (e.CommandName == "EditPerson")
        {
            Session["PersonId"] = personId.ToString();
            Response.Redirect("~/Personas/PeopleForm.aspx");
        }
        if (e.CommandName == "DeletePerson")
        {
            try
            {
                PeopleBLL.DeletePeople(personId);
            }
            catch (Exception ex)
            {
                SystemMessages.DisplaySystemErrorMessage(ex.Message);
                return;
            }
            SystemMessages.DisplaySystemMessage(Resources.People.MessageDeletePersonOk);
            PeopleRepeater.DataBind();
        }
        if (e.CommandName == "ViewOrganization")
        {
            Session["SEARCH_PARAMETER"] = "@organizationID " + personId.ToString();
            Response.Redirect("~/MainPage.aspx");
            return;
        }
        if (e.CommandName == "ViewArea")
        {
            Session["OrganizationId"] = personId.ToString();
            Response.Redirect("~/Organization/EditOrganization.aspx");
            return;
        }
        if (e.CommandName == "ViewKPIs")
        {
            Session["SEARCH_PARAMETER"] = "@personID " + personId.ToString();
            Response.Redirect("~/Kpi/KpiList.aspx");
            return;
        }
        if (e.CommandName.Equals("SharePerson"))
        {
            Session["PERSONID"] = personId.ToString();
            Response.Redirect("~/People/SharePerson.aspx");
        }
    }
    
    protected void PeopleRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem)
            return;

        LinkButton buttonDelete = (LinkButton)e.Item.FindControl("DeletePerson");
        if (buttonDelete != null)
            buttonDelete.OnClientClick = String.Format("return confirm('{0}')", Resources.People.MessageConfirmDeletePerson);

        People item = (People)e.Item.DataItem;

        if (item == null)
            return;

        //If exists AreaName Show the GuionLabel
        if (!string.IsNullOrEmpty(item.AreaName))
        {
            Label theGuionA = (Label)e.Item.FindControl("GuionLabel");
            if (theGuionA != null)
                theGuionA.Visible = true;
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

        if (item.NumberOfKpis == 0)
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

        Literal and = (Literal)e.Item.FindControl("AndLiteral");

        kpisButton.Visible = item.NumberOfKpis > 0;
        kpisButton.Text = kpisButton.Visible ? item.NumberOfKpis + " KPI(s)" : "";

    }
}