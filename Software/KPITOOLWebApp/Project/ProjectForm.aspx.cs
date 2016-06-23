using Artexacta.App.Utilities.SystemMessages;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Artexacta.App.Project;
using Artexacta.App.Project.BLL;
using Artexacta.App.PermissionObject;
using Artexacta.App.PermissionObject.BLL;

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

    protected void LoadProjectData()
    {
        OrganizationControl.DataType = UserControls_FRTWB_AddDataControl.AddType.PRJ.ToString();

        if (string.IsNullOrEmpty(ProjectIdHiddenField.Value) || ProjectIdHiddenField.Value == "0")
        {
            //Insert
            OrganizationControl.OrganizationId = 0;
        }
        else
        {
            PermissionObject theUser = new PermissionObject();
            try
            {
                theUser = PermissionObjectBLL.GetPermissionsByUser(PermissionObject.ObjectType.PROJECT.ToString(), Convert.ToInt32(ProjectIdHiddenField.Value));
            }
            catch (Exception exc)
            {
                SystemMessages.DisplaySystemErrorMessage(exc.Message);
                Response.Redirect("~/MainPage.aspx");
            }

            bool readOnly = false;

            if (theUser == null || !theUser.TheActionList.Exists(i => i.ObjectActionID.Equals("OWN") || i.ObjectActionID.Equals("MANAGE_PROJECT")))
            {
                readOnly = true;
            }

            OrganizationControl.ReadOnly = readOnly;

            //Update
            Project theData = null;
            try
            {
                theData = ProjectBLL.GetProjectById(Convert.ToInt32(ProjectIdHiddenField.Value));
            }
            catch (Exception exc)
            {
                SystemMessages.DisplaySystemErrorMessage(exc.Message);
            }

            if (theData != null)
            {
                TitleLiteral.Text = theData.Name;
                ProjectNameTextBox.Text = theData.Name;
                OrganizationControl.OrganizationId = theData.OrganizationID;
                OrganizationControl.AreaId = theData.AreaID;
                ProjectNameTextBox.Enabled = !readOnly;    
            }

            SaveButton.Visible = !readOnly;
            RequiredLabel.Visible = !readOnly;
        }
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        Project theProj = new Project();
        theProj.Name = ProjectNameTextBox.Text;
        theProj.OrganizationID = OrganizationControl.OrganizationId;
        theProj.AreaID = OrganizationControl.AreaId;

        if (string.IsNullOrEmpty(ProjectIdHiddenField.Value) || ProjectIdHiddenField.Value == "0")
        {
            //Insert
            try
            {
                ProjectBLL.InsertProject(theProj);
            }
            catch (Exception ex)
            {
                SystemMessages.DisplaySystemErrorMessage(ex.Message);
                return;
            }
        }
        else
        {
            //Update
            theProj.ProjectID = Convert.ToInt32(ProjectIdHiddenField.Value);
            try
            {
                ProjectBLL.UpdateProject(theProj);
            }
            catch (Exception ex)
            {
                SystemMessages.DisplaySystemErrorMessage(ex.Message);
                return;
            }
        }

        Response.Redirect("~/Project/ProjectList.aspx");
    }

    protected void CancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect(ParentPage);
    }
}