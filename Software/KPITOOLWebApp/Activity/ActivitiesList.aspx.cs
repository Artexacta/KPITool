using Artexacta.App.Utilities.SystemMessages;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using Artexacta.App.Activities;

public partial class Activity_ActivitiesList : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

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

    private string ownerToSelectInSearch;

    private void ProcessSessionParameters()
    {
        if (Session["OwnerId"] != null && !string.IsNullOrEmpty(Session["OwnerId"].ToString()))
        {
            ownerToSelectInSearch = Session["OwnerId"].ToString();
        }
        Session["OwnerId"] = null;
    }
 

    protected string GetOwnerInfo(Object obj)
    {
     
            return "N/A";

     
    }

    protected void ActivityRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem)
            return;
        //Activity item = (Activity)e.Item.DataItem;
        //if (item == null)
        //    return;
        //if (item.Kpis.Count == 0)
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
        //    if (firstKpi.KpiValues.Count > 0)
        //    {
        //        imageOfKpi.OwnerId = item.ObjectId;
        //        imageOfKpi.Visible = true;
        //    }
        //}

        //LinkButton kpisButton = (LinkButton)e.Item.FindControl("KpisButton");

        //Literal and = (Literal)e.Item.FindControl("AndLiteral");

        //kpisButton.Visible = item.Kpis.Count > 0;
        //kpisButton.Text = kpisButton.Visible ? item.Kpis.Count + " KPI(s)" : "";

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
            SystemMessages.DisplaySystemErrorMessage("Could not complete the requested action");
            return;
        }
        if (e.CommandName == "EditActivity")
        {
            Session["ActivityId"] = activityId;
            Response.Redirect("~/Activity/AddActivity.aspx");
            return;
        }
        if (e.CommandName == "ViewActivity")
        {
            Session["ActivityId"] = activityId;
            Response.Redirect("~/Activity/DetailActivity.aspx");
            return;
        }
        if (e.CommandName == "DeleteActivity")
        {
            //Activity objActivity = FrtwbSystem.Instance.Activities[activityId];
            //if (objActivity.Kpis.Count > 0)
            //{
            //    SystemMessages.DisplaySystemErrorMessage("This project cannot be delete because has KPIs related to it");
            //    return;
            //}
            //RemoveActivityFromOldOwner(objActivity);
            //objActivity.Owner = null;
            //FrtwbSystem.Instance.Activities.Remove(objActivity.ObjectId);
            //SystemMessages.DisplaySystemMessage("The Activity was deleted");
            //SearchActivities();
            return;
        }
        if (e.CommandName == "ViewOwner")
        {

            //Activity objActivity = FrtwbSystem.Instance.Activities[activityId];
            //FrtwbObject ownerObject = objActivity.Owner;
            //if (ownerObject == null)
            //    return;

            //if (ownerObject is Organization)
            //{
            //    Session["OrganizationId"] = ownerObject.ObjectId;
            //    Response.Redirect("~/Organization/OrganizationDetails.aspx");
            //}
            //else if (ownerObject is Area && ownerObject.Owner != null)
            //{
            //    Area area = (Area)ownerObject;
            //    Session["OrganizationId"] = area.Owner.ObjectId;
            //    Response.Redirect("~/Organization/OrganizationDetails.aspx#Area");
            //}
            //else if (ownerObject is Project)
            //{
            //    Session["ProjectId"] = ownerObject.ObjectId;
            //    Response.Redirect("~/Project/ProjectDetails.aspx");
            //}
            return;
        }
    }

   

    private void RemoveActivityFromOldOwner(Activity objActivity)
    {
        //if (objActivity.Owner is Area)
        //{
        //    Area oldArea = (Area)objActivity.Owner;
        //    oldArea.Activities.Remove(objActivity.ObjectId);
        //}
        //else if (objActivity.Owner is Project)
        //{
        //    Project oldProject = (Project)objActivity.Owner;
        //    oldProject.Activities.Remove(objActivity.ObjectId);
        //}
        //else if (objActivity.Owner is Organization)
        //{
        //    Organization oldOrganization = (Organization)objActivity.Owner;
        //    oldOrganization.Activities.Remove(objActivity.ObjectId);
        //}
    }
}
