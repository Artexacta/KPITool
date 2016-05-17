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
        if (!IsPostBack)
        {
            BindOrganizations();
        }
    }

    private void BindOrganizations()
    {
        //Get the list of organizations
        OrganizationBLL theBLL = new OrganizationBLL();
        List<Organization> theOrganizations = new List<Organization>();

        try
        {
            theOrganizations = theBLL.GetOrganizationsByUser("1=1");
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
            //ResetTourHiddenField.Value = "true";
            //showTourBtn.Visible = false;
            Tour.Hide();
        }
        if (theOrganizations.Count > 0)
        {
            Tour.Show();
            //ShowTourHiddenField.Value = "true";
        }
    }
    
    protected void OrganizationsRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem)
            return;
        
        Organization item = (Organization)e.Item.DataItem;

        //if (item.Areas.Count == 0 && item.Projects.Count == 0 && item.Activities.Count == 0 && item.Kpis.Count == 0)
        //{
        //    Panel element = (Panel)e.Item.FindControl("emptyMessage");
        //    element.Visible = true;
        //    return;
        //}

        //Panel detailsPanel = (Panel)e.Item.FindControl("detailsContainer");
        //detailsPanel.Visible = true;

        //Panel kpiImagePanel = (Panel)e.Item.FindControl("KpiImageContainer");
        //kpiImagePanel.Visible = true;

        //UserControls_FRTWB_KpiImage imageOfKpi = (UserControls_FRTWB_KpiImage)e.Item.FindControl("ImageOfKpi");
        //if (item.Kpis.Count > 0)
        //{
        //    Kpi firstKpi = item.Kpis.Values.ToList()[0];
        //    if(firstKpi.KpiValues.Count > 0){
        //        imageOfKpi.KpiId = firstKpi.ObjectId;
        //        imageOfKpi.Visible = true;
        //    }
        //}
        //Label areasLabel = (Label)e.Item.FindControl("AreasLabel");
        //LinkButton projectButton = (LinkButton)e.Item.FindControl("ProjectsButton");
        //LinkButton activitiesButton = (LinkButton)e.Item.FindControl("ActivitiesButton");
        //LinkButton kpisButton = (LinkButton)e.Item.FindControl("KpisButton");

        //Literal and1 = (Literal)e.Item.FindControl("AndLiteral1");
        //Literal and2 = (Literal)e.Item.FindControl("AndLiteral2");
        //Literal and3 = (Literal)e.Item.FindControl("AndLiteral3");

        //areasLabel.Visible = item.Areas.Count > 0;
        //areasLabel.Text = areasLabel.Visible ? item.Areas.Count + " Area" + (item.Areas.Count == 1 ? "" : "s")  : "";

        //projectButton.Visible = item.Projects.Count > 0;
        //projectButton.Text = projectButton.Visible ? item.Projects.Count + " Project(s)" : "";

        //activitiesButton.Visible = item.Activities.Count > 0;
        //activitiesButton.Text = activitiesButton.Visible ? item.Activities.Count + (item.Activities.Count == 1 ? " Activity" : " Activities") : "";

        //kpisButton.Visible = item.Kpis.Count > 0;
        //kpisButton.Text = kpisButton.Visible ? item.Kpis.Count + " KPI" + (item.Kpis.Count == 1 ? "" : "s") : "";


        //and1.Visible = areasLabel.Visible && projectButton.Visible;
        //if (and1.Visible)
        //{
        //    if (activitiesButton.Visible || kpisButton.Visible)
        //        and1.Text = ",";
        //    else
        //        and1.Text = " and ";
        //}

        //and2.Visible = projectButton.Visible && activitiesButton.Visible;
        //if (and2.Visible)
        //{
        //    if (kpisButton.Visible)
        //        and2.Text = ",";
        //    else
        //        and2.Text = " and ";
        //}

        //and3.Visible =  kpisButton.Visible;
        //if (and3.Visible && kpisButton.Visible)
        //{
        //    and3.Text = " and ";
        //}
    }
    
    protected void SearchButton_Click(object sender, EventArgs e)
    {
        //string searchTerm = SearchTextBox.Text.Trim().ToLower();
        //List<Organization> results = new List<Organization>();
        //foreach (var item in FrtwbSystem.Instance.Organizations.Values)
        //{
        //    if (item.Name.ToLower().Contains(searchTerm))
        //        results.Add(item);
        //}

        //OrganizationsRepeater.DataSource = results;
        //OrganizationsRepeater.DataBind();
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
            Session["OwnerId"] = organizationId + "-Organization";
            Response.Redirect("~/Project/ProjectList.aspx");
            return;
        }
        if (e.CommandName == "ViewActivities")
        {
            Session["OwnerId"] = organizationId + "-Organization";
            Response.Redirect("~/Activity/ActivitiesList.aspx");
            return;
        }
        if (e.CommandName == "ViewKPIs")
        {
            Session["OwnerId"] = organizationId + "-Organization";
            Response.Redirect("~/Kpi/KpiList.aspx");
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

}