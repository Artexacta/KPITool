using Artexacta.App.FRTWB;
using Artexacta.App.Utilities.SystemMessages;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Project_ProjectForm : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    public int ProjectId
    {
        set { ProjectIdHiddenField.Value = value.ToString(); }
        get
        {
            int projectId = 0;
            try
            {
                projectId = Convert.ToInt32(ProjectIdHiddenField.Value);
            }
            catch (Exception ex)
            {
                log.Error("Error trying to convert ProjectIdHiddenField.Value to integer value", ex);
            }
            return projectId;
        }
    }

    private Project currentObject;

    public string ParentPage
    {
        set { ParentPageHiddenField.Value = value; }
        get { return string.IsNullOrEmpty(ParentPageHiddenField.Value) ? "~/MainPage.aspx" : ParentPageHiddenField.Value; }
    }

    protected override void InitializeCulture()
    {
        Artexacta.App.Utilities.LanguageUtilities.SetLanguageFromContext();
        base.InitializeCulture();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack)
            return;

        ProcessSessionParametes();
        LoadProjectData();

        OrganizationComboBox.DataSource = FrtwbSystem.Instance.Organizations.Values;
        OrganizationComboBox.DataBind();

        AreaComboBox.DataSource = new List<Area>();
        AreaComboBox.DataBind();
    }

    private void ProcessSessionParametes()
    {
        if (Session["ParentPage"] != null && !string.IsNullOrEmpty(Session["ParentPage"].ToString()))
        {
            ParentPage = Session["ParentPage"].ToString();
        }
        Session["ParentPage"] = null;
        if (Session["ProjectId"] != null && !string.IsNullOrEmpty(Session["ProjectId"].ToString()))
        {
            int projectId = 0;
            try
            {
                projectId = Convert.ToInt32(Session["ProjectId"].ToString());
            }
            catch (Exception ex)
            {
                log.Error("Error trying to convert Session['ProjectId'] to integer value", ex);
            }
            ProjectId = projectId;
        }
        Session["ProjectId"] = null;
    }

    private void LoadProjectData()
    {
        int projectId = ProjectId;
        if (projectId <= 0)
        {
            TitleLiteral.Text = "Create Project";
            Title = "Create Project";
            return;
        }
        try
        {
            TitleLiteral.Text = "Edit Project";
            Title = "Edit Project";
            currentObject = FrtwbSystem.Instance.Projects[projectId];
            ProjectNameTextBox.Text = currentObject.Name;
        }
        catch (Exception ex)
        {
            log.Error("Error loading project data", ex);
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

    protected void AreaComboBox_DataBound(object sender, EventArgs e)
    {
        AreaComboBox.Items.Insert(0, new ListItem("-- Select an Area --", ""));

        if (currentObject == null)
            return;

        if(currentObject.Owner is Area){
            string areaId =  currentObject.Owner.ObjectId.ToString();
            ListItem item = OrganizationComboBox.Items.FindByValue(areaId);
            if (item != null)
                item.Selected = true;
        }
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        try
        {
            int projectId = this.ProjectId;
            string projectName = ProjectNameTextBox.Text;
            int organizationId = Convert.ToInt32(OrganizationComboBox.SelectedValue);
            string area = AreaComboBox.SelectedValue;


            Project objProject = null;
            bool isNew = projectId == 0;

            if (isNew)
            {
                objProject = new Project()
                {
                    Name = projectName
                };
                FrtwbSystem.Instance.Projects.Add(objProject.ObjectId, objProject);
            }
            else
            {
                objProject = FrtwbSystem.Instance.Projects[projectId];
                objProject.Name = projectName;
            }


            Organization objOrg = FrtwbSystem.Instance.Organizations[organizationId];
            if (!string.IsNullOrEmpty(area))
            {
                int areaId = Convert.ToInt32(area);
                Area objArea = objOrg.Areas[areaId];
                if (objProject.Owner != null && objProject.Owner != objArea)
                {
                    RemoveProjectFromOldOwner(objProject);
                }
                if(!objArea.Projects.ContainsKey(objProject.ObjectId))
                    objArea.Projects.Add(objProject.ObjectId, objProject);
                objProject.Owner = objArea;
                
            }
            else
            {
                if (objProject.Owner != null && objProject.Owner != objOrg)
                {
                    RemoveProjectFromOldOwner(objProject);
                }
                if (!objOrg.Projects.ContainsKey(objProject.ObjectId))
                    objOrg.Projects.Add(objProject.ObjectId, objProject);
                objProject.Owner = objOrg;
            }
            
            if (isNew)
                SystemMessages.DisplaySystemMessage("Project was created");
            else
                SystemMessages.DisplaySystemMessage("Project was modified");
        }
        catch (Exception ex)
        {
            log.Error("Error saving project", ex);
            return;
        }
        Response.Redirect("~/Project/ProjectList.aspx");

    }

    private void RemoveProjectFromOldOwner(Project objProject)
    {
        if (objProject.Owner is Area)
        {
            Area oldArea = (Area)objProject.Owner;
            oldArea.Projects.Remove(objProject.ObjectId);
        }
        else if (objProject.Owner is Organization)
        {
            Organization oldOrganization = (Organization)objProject.Owner;
            oldOrganization.Projects.Remove(objProject.ObjectId);
        }
    }

    protected void CancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect(ParentPage);
    }
}