using Artexacta.App.Area;
using Artexacta.App.Area.BLL;
using Artexacta.App.Organization;
using Artexacta.App.Organization.BLL;
using Artexacta.App.Project;
using Artexacta.App.Project.BLL;
using Artexacta.App.Utilities.SystemMessages;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class UserControls_FRTWB_AddDataControl : System.Web.UI.UserControl
{
    public enum AddType
    {
        PRJ,
        ACT,
        PPL,
        KPI
    }

    public string DataType
    {
        get
        {
            if (string.IsNullOrEmpty(DataTypeHiddenField.Value))
                return "";
            else
                return DataTypeHiddenField.Value;
        }
        set 
        { 
            DataTypeHiddenField.Value = value.ToString();
            LoadForm();
        }
    }

    public int OrganizationId
    {
        get
        {
            if (string.IsNullOrEmpty(OrganizationIdHiddenField.Value))
                return 0;
            else
                return Convert.ToInt32(OrganizationIdHiddenField.Value);
        }
        set { OrganizationIdHiddenField.Value = value.ToString(); }
    }

    public int AreaId
    {
        get
        {
            if (string.IsNullOrEmpty(AreaIdHiddenField.Value))
                return 0;
            else
                return Convert.ToInt32(AreaIdHiddenField.Value);
        }
        set { AreaIdHiddenField.Value = value.ToString(); }
    }

    public int ProjectId
    {
        get
        {
            if (string.IsNullOrEmpty(ProjectIdHiddenField.Value))
                return 0;
            else
                return Convert.ToInt32(ProjectIdHiddenField.Value);
        }
        set { ProjectIdHiddenField.Value = value.ToString(); }
    }

    public int ActivityId
    {
        get
        {
            if (string.IsNullOrEmpty(ActivityIdHiddenField.Value))
                return 0;
            else
                return Convert.ToInt32(ActivityIdHiddenField.Value);
        }
        set { ActivityIdHiddenField.Value = value.ToString(); }
    }

    public int PeopleId
    {
        get
        {
            if (string.IsNullOrEmpty(PeopleIdHiddenField.Value))
                return 0;
            else
                return Convert.ToInt32(PeopleIdHiddenField.Value);
        }
        set { PeopleIdHiddenField.Value = value.ToString(); }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadOperation();
            LoadArea();
            LoadProject();
        }
    }

    private void LoadForm()
    {
        switch (DataTypeHiddenField.Value)
        {
            case "PRJ":
                OrganizationRequired.Visible = true;
                pnlArea.Visible = true;
                pnlProject.Visible = false;
                pnlActivity.Visible = false;
                pnlPeople.Visible = false;
                break;

            case "ACT":
                OrganizationRequired.Visible = false;
                pnlArea.Visible = true;
                pnlProject.Visible = true;
                pnlActivity.Visible = false;
                pnlPeople.Visible = false;
                break;

            case "PPL":
                OrganizationRequired.Visible = true;
                pnlArea.Visible = true;
                pnlProject.Visible = false;
                pnlActivity.Visible = false;
                pnlPeople.Visible = false;
                break;

            case "KPI":
                OrganizationRequired.Visible = true;
                pnlArea.Visible = false;
                pnlKPI.Visible = true;
                break;
        }
    }

    private void LoadOperation()
    {
        if (OrganizationId > 0)
        {
            Organization theData = null;
            try
            {
                theData = OrganizationBLL.GetOrganizationById(OrganizationId);
            }
            catch (Exception exc)
            {
                SystemMessages.DisplaySystemErrorMessage(exc.Message);
            }
            if (theData != null)
                OrganizationTextBox.Text = theData.Name;
        }
    }

    private void LoadArea()
    {
        if (AreaId > 0)
        {
            Area theData = null;
            try
            {
                theData = AreaBLL.GetAreaById(AreaId);
            }
            catch (Exception exc)
            {
                SystemMessages.DisplaySystemErrorMessage(exc.Message);
            }
            if (theData != null)
            {
                if (theData.OrganizationID != OrganizationId)
                    SystemMessages.DisplaySystemWarningMessage(Resources.Organization.MessageAreaOrganizationError);
                else
                    AreaTextBox.Text = theData.Name;
            }
        }
    }

    private void LoadProject()
    {
        if (ProjectId > 0)
        {
            Project theData = null;
            try
            {
                theData = ProjectBLL.GetProjectById(ProjectId);
            }
            catch (Exception exc)
            {
                SystemMessages.DisplaySystemErrorMessage(exc.Message);
            }
            if (theData != null)
            {
                if (theData.OrganizationID != OrganizationId)
                    SystemMessages.DisplaySystemWarningMessage(Resources.Organization.MessageProjectOrganizationError);
                else if(theData.AreaID != AreaId)
                    SystemMessages.DisplaySystemWarningMessage(Resources.Organization.MessageProjectAreaError);
                else
                    ProjectTextBox.Text = theData.Name;
            }
        }
    }
    
    protected void OrganizationObjectDataSource_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        if (e.Exception != null)
        {
            SystemMessages.DisplaySystemErrorMessage(e.Exception.Message);
            e.ExceptionHandled = true;
        }
    }

}