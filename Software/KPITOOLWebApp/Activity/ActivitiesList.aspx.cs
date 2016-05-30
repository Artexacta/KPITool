using Artexacta.App.FRTWB;
using Artexacta.App.Utilities.SystemMessages;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

public partial class Activity_ActivitiesList : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ProcessSessionParameters();
            cargarDatos();
        }
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

    private void cargarDatos()
    {
        BindAllActivities();

        ObjectsComboBox.DataSource = FrtwbSystem.Instance.GetObjectsForSearch("Activity");
        ObjectsComboBox.DataBind();

        if (string.IsNullOrEmpty(ownerToSelectInSearch))
        {
            BindAllActivities();
            return;
        }
        ObjectsComboBox.ClearSelection();
        RadComboBoxItem item = ObjectsComboBox.Items.FindItemByValue(ownerToSelectInSearch);
        if (item != null)
        {
            item.Selected = true;
            SearchActivities();
        }
        else
        {
            BindAllActivities();
        }
    }

    private void BindAllActivities()
    {
        ActivityRepeater.DataSource = FrtwbSystem.Instance.Activities.Values;
        ActivityRepeater.DataBind();
    }
    

    protected string GetOwnerInfo(Object obj)
    {
        FrtwbObject ownerObject = (FrtwbObject)obj;
        if (ownerObject == null)
            return "N/A";

        string type = "";
        if (ownerObject is Organization)
            return "Organization: " + ownerObject.Name;
        else if (ownerObject is Area)
        {
            string owner = "Area: " + ownerObject.Name;
            Area area = (Area)ownerObject;
            if (area.Owner != null)
                owner += " of Organization " + area.Owner.Name;
            return owner;
        }
        else if (ownerObject is Project)
        {
            string owner = "Project: " + ownerObject.Name;
            Project project = (Project)ownerObject;
            if (project.Owner != null)
            {
                if (project.Owner is Area)
                {
                    owner += " of Area " + project.Owner.Name;
                    Area area = (Area)project.Owner;
                    if (area.Owner != null)
                        owner += " of Organization " + area.Owner.Name;
                }
                else if (project.Owner is Organization)
                {
                    owner += " of Organization " + project.Owner.Name;
                }
            }
            return owner;
        }
        return type;
    }

    protected void ActivityRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem)
            return;
        Activity item = (Activity)e.Item.DataItem;
        if (item == null)
            return;
        if (item.Kpis.Count == 0)
        {
            Panel element = (Panel)e.Item.FindControl("emptyMessage");
            element.Visible = true;
            return;
        }
        Panel detailsPanel = (Panel)e.Item.FindControl("detailsContainer");
        detailsPanel.Visible = true;

        Panel kpiImagePanel = (Panel)e.Item.FindControl("KpiImageContainer");
        kpiImagePanel.Visible = true;

        UserControls_FRTWB_KpiImage imageOfKpi = (UserControls_FRTWB_KpiImage)e.Item.FindControl("ImageOfKpi");
        if (item.Kpis.Count > 0)
        {
            Kpi firstKpi = item.Kpis.Values.ToList()[0];
            if (firstKpi.KpiValues.Count > 0)
            {
                imageOfKpi.OwnerId = item.ObjectId;
                imageOfKpi.Visible = true;
            }
        }

        LinkButton kpisButton = (LinkButton)e.Item.FindControl("KpisButton");

        Literal and = (Literal)e.Item.FindControl("AndLiteral");

        kpisButton.Visible = item.Kpis.Count > 0;
        kpisButton.Text = kpisButton.Visible ? item.Kpis.Count + " KPI(s)" : "";

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
            Activity objActivity = FrtwbSystem.Instance.Activities[activityId];
            if (objActivity.Kpis.Count > 0)
            {
                SystemMessages.DisplaySystemErrorMessage("This project cannot be delete because has KPIs related to it");
                return;
            }
            RemoveActivityFromOldOwner(objActivity);
            objActivity.Owner = null;
            FrtwbSystem.Instance.Activities.Remove(objActivity.ObjectId);
            SystemMessages.DisplaySystemMessage("The Activity was deleted");
            SearchActivities();
            return;
        }
        if (e.CommandName == "ViewOwner")
        {

            Activity objActivity = FrtwbSystem.Instance.Activities[activityId];
            FrtwbObject ownerObject = objActivity.Owner;
            if (ownerObject == null)
                return;

            if (ownerObject is Organization)
            {
                Session["OrganizationId"] = ownerObject.ObjectId;
                Response.Redirect("~/Organization/OrganizationDetails.aspx");
            }
            else if (ownerObject is Area && ownerObject.Owner != null)
            {
                Area area = (Area)ownerObject;
                Session["OrganizationId"] = area.Owner.ObjectId;
                Response.Redirect("~/Organization/OrganizationDetails.aspx#Area");
            }
            else if (ownerObject is Project)
            {
                Session["ProjectId"] = ownerObject.ObjectId;
                Response.Redirect("~/Project/ProjectDetails.aspx");
            }
            return;
        }
    }

    protected void SearchButton_Click(object sender, EventArgs e)
    {
        SearchActivities();
    }

    private void SearchActivities()
    {
        string searchTerm = SearchTextBox.Text;
        Dictionary<int, Activity> source = null;
        if (!string.IsNullOrEmpty(ObjectsComboBox.SelectedValue))
        {
            string[] values = ObjectsComboBox.SelectedValue.Split(new char[] { '-' });
            int id = Convert.ToInt32(values[0]);
            string ownerObjectType = values[1];
            FrtwbObject owner = null;
            if (ownerObjectType == "Organization")
            {

                source = FrtwbSystem.Instance.Organizations[id].Activities;
                owner = FrtwbSystem.Instance.Organizations[id];
            }
            else if (ownerObjectType == "Area")
            {
                source = FrtwbSystem.Instance.Areas[id].Activities;
                owner = FrtwbSystem.Instance.Areas[id];
            }
            else if (ownerObjectType == "Project")
            {
                source = FrtwbSystem.Instance.Projects[id].Activities;
                owner = FrtwbSystem.Instance.Projects[id];
            }
            else
                source = new Dictionary<int, Activity>();

            OwnerObjectLabel.Text = "";
            bool first = true;
            while (owner != null)
            {
                if (first)
                {
                    OwnerObjectLabel.Text = owner.Type + ": " + owner.Name;
                    first = false;
                }
                else
                    OwnerObjectLabel.Text = owner.Type + ": " + owner.Name + " / " + OwnerObjectLabel.Text;

                owner = owner.Owner;
            }
            OwnerObjectLabel.Text = "Searching activities from : " + OwnerObjectLabel.Text;
        }
        else
        {
            source = FrtwbSystem.Instance.Activities;
            OwnerObjectLabel.Text = "";
        }

        List<Activity> result = new List<Activity>();
        foreach (var item in source.Values)
        {
            if (item.Name.Contains(searchTerm))
                result.Add(item);
        }
        ActivityRepeater.DataSource = result;
        ActivityRepeater.DataBind();
    }


    private void RemoveActivityFromOldOwner(Activity objActivity)
    {
        if (objActivity.Owner is Area)
        {
            Area oldArea = (Area)objActivity.Owner;
            oldArea.Activities.Remove(objActivity.ObjectId);
        }
        else if (objActivity.Owner is Project)
        {
            Project oldProject = (Project)objActivity.Owner;
            oldProject.Activities.Remove(objActivity.ObjectId);
        }
        else if (objActivity.Owner is Organization)
        {
            Organization oldOrganization = (Organization)objActivity.Owner;
            oldOrganization.Activities.Remove(objActivity.ObjectId);
        }
    }
}
