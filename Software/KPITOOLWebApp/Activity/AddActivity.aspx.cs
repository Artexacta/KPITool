using Artexacta.App.FRTWB;
using Artexacta.App.Utilities.SystemMessages;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Activity_AddActivity : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    public int ActivityId
    {
        set { ActivityIdHiddenField.Value = value.ToString(); }
        get
        {
            int activityId = 0;
            try
            {
                activityId = Convert.ToInt32(ActivityIdHiddenField.Value);
            }
            catch (Exception ex)
            {
                log.Error("Error trying to convert ActivityIdHiddenField.Value to integer value", ex);
            }
            return activityId;
        }
    }

    private Artexacta.App.FRTWB.Activity currentObject;

    public string ParentPage
    {
        set { ParentPageHiddenField.Value = value; }
        get { return string.IsNullOrEmpty(ParentPageHiddenField.Value) ? "~/MainPage.aspx" : ParentPageHiddenField.Value; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack)
            return;

        ProcessSessionParametes();
        LoadActivityData();

        OrganizationComboBox.DataSource = FrtwbSystem.Instance.Organizations.Values;
        OrganizationComboBox.DataBind();
    }

    private void ProcessSessionParametes()
    {
        if (Session["ParentPage"] != null && !string.IsNullOrEmpty(Session["ParentPage"].ToString()))
        {
            ParentPage = Session["ParentPage"].ToString();
        }
        Session["ParentPage"] = null;
        if (Session["ActivityId"] != null && !string.IsNullOrEmpty(Session["ActivityId"].ToString()))
        {
            int activityId = 0;
            try
            {
                activityId = Convert.ToInt32(Session["ActivityId"].ToString());
            }
            catch (Exception ex)
            {
                log.Error("Error trying to convert Session['ActivityId'] to integer value", ex);
            }
            ActivityId = activityId;
        }
        Session["ActivityId"] = null;
    }

    private void LoadActivityData()
    {
        int activityId = ActivityId;
        if (activityId <= 0)
            return;

        try
        {
            currentObject = FrtwbSystem.Instance.Activities[activityId];
            ActivityNameTextBox.Text = currentObject.Name;
        }
        catch (Exception ex)
        {
            log.Error("Error loading activity data", ex);
        }
    }

    protected void OrganizationComboBox_DataBound(object sender, EventArgs e)
    {
        OrganizationComboBox.Items.Insert(0, new ListItem("-- Select a Organization --", ""));
        if (currentObject == null)
            return;

        string organizationId = currentObject.Owner is Organization ? currentObject.Owner.ObjectId.ToString() :
            currentObject.Owner.Owner.ObjectId.ToString();
        ListItem item = OrganizationComboBox.Items.FindByValue(organizationId);
        if (item != null)
            item.Selected = true;

        LoadAreaComboBox(organizationId);

    }

    protected void OrganizationComboBox_SelectedIndexChanged(object sender, EventArgs e)
    {
        LoadAreaComboBox(OrganizationComboBox.SelectedValue);
        LoadProjectComboBoxByOrganization(OrganizationComboBox.SelectedValue);
    }

    protected void AreaComboBox_SelectedIndexChanged(object sender, EventArgs e)
    {
        LoadProjectComboBoxByArea(AreaComboBox.SelectedValue);
    }

    private void LoadAreaComboBox(string value)
    {
        if (string.IsNullOrEmpty(value))
        {
            AreaComboBox.DataSource = new List<Area>();
            AreaComboBox.DataBind();
            return;
        }

        try
        {
            Organization org = FrtwbSystem.Instance.Organizations[Convert.ToInt32(value)];
            AreaComboBox.DataSource = org.Areas.Values;
            AreaComboBox.DataBind();
        }
        catch (Exception ex)
        {
            log.Error("Error loading areas from selected organization", ex);
        }
    }

    private void LoadProjectComboBoxByOrganization(string value)
    {
        if (string.IsNullOrEmpty(value))
        {
            ProjectComboBox.DataSource = new List<Project>();
            ProjectComboBox.DataBind();
            return;
        }

        try
        {
            Organization org = FrtwbSystem.Instance.Organizations[Convert.ToInt32(value)];
            ProjectComboBox.DataSource = org.Projects.Values;
            ProjectComboBox.DataBind();
        }
        catch (Exception ex)
        {
            log.Error("Error loading activitys from selected organization", ex);
        }
    }

    private void LoadProjectComboBoxByArea(string value)
    {
        if (string.IsNullOrEmpty(value))
        {
            ProjectComboBox.DataSource = new List<Project>();
            ProjectComboBox.DataBind();
            return;
        }

        try
        {
            Area org = FrtwbSystem.Instance.Areas[Convert.ToInt32(value)];
            ProjectComboBox.DataSource = org.Projects.Values;
            ProjectComboBox.DataBind();
        }
        catch (Exception ex)
        {
            log.Error("Error loading activitys from selected area", ex);
        }
    }


    protected void AreaComboBox_DataBound(object sender, EventArgs e)
    {
        AreaComboBox.Items.Insert(0, new ListItem("-- Select an Area --", ""));

        if (currentObject == null)
            return;

        string areaId = currentObject.Owner is Area ? currentObject.Owner.ObjectId.ToString() :
            currentObject.Owner.Owner.ObjectId.ToString();
        ListItem item = AreaComboBox.Items.FindByValue(areaId);
        if (item != null)
            item.Selected = true;

        LoadProjectComboBoxByArea(areaId);
    }

    protected void ProjectComboBox_DataBound(object sender, EventArgs e)
    {
        ProjectComboBox.Items.Insert(0, new ListItem("-- Select a Project --", ""));

        if (currentObject == null)
            return;

        if (currentObject.Owner is Project)
        {
            string activityId = currentObject.Owner.ObjectId.ToString();
            ListItem item = ProjectComboBox.Items.FindByValue(activityId);
            if (item != null)
                item.Selected = true;
        }
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        try
        {
            int activityId = this.ActivityId;
            string activityName = ActivityNameTextBox.Text;
            int organizationId = Convert.ToInt32(OrganizationComboBox.SelectedValue);
            string area = AreaComboBox.SelectedValue;
            string project = ProjectComboBox.SelectedValue;


            Activity objActivity = null;
            bool isNew = activityId == 0;

            if (isNew)
            {
                objActivity = new Activity()
                {
                    Name = activityName
                };
                FrtwbSystem.Instance.Activities.Add(objActivity.ObjectId, objActivity);
            }
            else
            {
                objActivity = FrtwbSystem.Instance.Activities[activityId];
                objActivity.Name = activityName;
            }


            Organization objOrg = FrtwbSystem.Instance.Organizations[organizationId];
            if (!string.IsNullOrEmpty(area))
            {
                int areaId = Convert.ToInt32(area);
                Area objArea = objOrg.Areas[areaId];
                if (!string.IsNullOrEmpty(project))
                {
                    int projectId = Convert.ToInt32(project);
                    Project objProject = objArea.Projects[projectId];
                    if (objActivity.Owner != null && objActivity.Owner != objProject)
                    {
                        RemoveActivityFromOldOwner(objActivity);
                    }
                    if (!objProject.Activities.ContainsKey(objActivity.ObjectId))
                        objProject.Activities.Add(objActivity.ObjectId, objActivity);
                    objActivity.Owner = objProject;
                }
                else
                {
                    if (objActivity.Owner != null && objActivity.Owner != objArea)
                    {
                        RemoveActivityFromOldOwner(objActivity);
                    }
                    if (!objArea.Activities.ContainsKey(objActivity.ObjectId))
                        objArea.Activities.Add(objActivity.ObjectId, objActivity);
                    objActivity.Owner = objArea;
                }

            }
            else
            {
                if (!string.IsNullOrEmpty(project))
                {
                    int projectId = Convert.ToInt32(project);
                    Project objProject = objOrg.Projects[projectId];
                    if (objActivity.Owner != null && objActivity.Owner != objProject)
                    {
                        RemoveActivityFromOldOwner(objActivity);
                    }
                    if (!objProject.Activities.ContainsKey(objActivity.ObjectId))
                        objProject.Activities.Add(objActivity.ObjectId, objActivity);
                    objActivity.Owner = objProject;
                }
                else
                {
                    if (objActivity.Owner != null && objActivity.Owner != objOrg)
                    {
                        RemoveActivityFromOldOwner(objActivity);
                    }
                    if (!objOrg.Activities.ContainsKey(objActivity.ObjectId))
                        objOrg.Activities.Add(objActivity.ObjectId, objActivity);
                    objActivity.Owner = objOrg;
                }
            }
            if (isNew)
                SystemMessages.DisplaySystemMessage("Activity was created");
            else
                SystemMessages.DisplaySystemMessage("Activity was modified");
            Response.Redirect("~/Activity/ActivitiesList.aspx");

        }
        catch (Exception ex)
        {
            log.Error("Error saving activity", ex);
        }

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

    protected void CancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect(ParentPage);
    }
}