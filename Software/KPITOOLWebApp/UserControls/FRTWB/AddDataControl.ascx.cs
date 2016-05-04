using Artexacta.App.Activities;
using Artexacta.App.Activities.BLL;
using Artexacta.App.Area;
using Artexacta.App.Area.BLL;
using Artexacta.App.KPI;
using Artexacta.App.KPI.BLL;
using Artexacta.App.Organization;
using Artexacta.App.Organization.BLL;
using Artexacta.App.People;
using Artexacta.App.People.BLL;
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
        PRJ, //Project
        ACT, //Activity
        PPL, //People
        KPI //KPI
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

    public int PersonId
    {
        get
        {
            if (string.IsNullOrEmpty(PersonaIdHiddenField.Value))
                return 0;
            else
                return Convert.ToInt32(PersonaIdHiddenField.Value);
        }
        set { PersonaIdHiddenField.Value = value.ToString(); }
    }

    public int KPIId
    {
        get
        {
            if (string.IsNullOrEmpty(KPIIdHiddenField.Value))
                return 0;
            else
                return Convert.ToInt32(KPIIdHiddenField.Value);
        }
        set { KPIIdHiddenField.Value = value.ToString(); }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadKPI();
            LoadPerson();
            LoadActivity();
            LoadProject();
            LoadArea();
            LoadOrganization();
        }
    }

    private void LoadForm()
    {
        switch (DataTypeHiddenField.Value)
        {
            case "PRJ":
                OrganizationRequired.Visible = true;
                pnlArea.Style["display"] = "block";
                pnlProject.Visible = false;
                pnlActivity.Visible = false;
                pnlPeople.Visible = false;
                break;

            case "ACT":
                OrganizationRequired.Visible = false;
                pnlArea.Style["display"] = "block";
                pnlProject.Visible = true;
                pnlActivity.Visible = false;
                pnlPeople.Visible = false;
                break;

            case "PPL":
                OrganizationRequired.Visible = true;
                pnlArea.Style["display"] = "block";
                pnlProject.Visible = false;
                pnlActivity.Visible = false;
                pnlPeople.Visible = false;
                break;

            case "KPI":
                OrganizationRequired.Visible = true;
                pnlArea.Style["display"] = "none";
                pnlKPI.Visible = true;
                break;
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
                if (DataTypeHiddenField.Value.Equals("KPI"))
                {
                    pnlAddProject.Style["display"] = "none";
                    pnlKPIProject.Style["display"] = "inline";
                    KPIProjectText.Text = theData.Name;

                    pnlAddPeople.Style["display"] = "none";
                    pnlKPIPeople.Style["display"] = "none";

                    pnlKPIData.Style["display"] = "block";
                }
                else
                    ProjectTextBox.Text = theData.Name;

                OrganizationId = theData.OrganizationID;
                AreaId = theData.AreaID;
            }
        }
    }

    private void LoadActivity()
    {
        if (ActivityId > 0)
        {
            Activity theData = null;
            try
            {
                theData = ActivityBLL.GetActivityById(ActivityId);
            }
            catch (Exception exc)
            {
                SystemMessages.DisplaySystemErrorMessage(exc.Message);
            }
            if (theData != null)
            {
                if (DataTypeHiddenField.Value.Equals("KPI"))
                {
                    pnlAddActivity.Style["display"] = "none";
                    pnlKPIActivity.Style["display"] = "inline";
                    KPIActivityText.Text = theData.Name;

                    pnlAddProject.Style["display"] = "none";
                    pnlAddPeople.Style["display"] = "none";
                    pnlKPIPeople.Style["display"] = "none";

                    pnlKPIData.Style["display"] = "block";
                    pnlKPI.Style["display"] = "none";
                }

                OrganizationId = theData.OrganizationID;
                AreaId = theData.AreaID;
                ProjectId = theData.ProjectID;
            }
        }
    }

    private void LoadPerson()
    {
        if (PersonId > 0)
        {
            People theData = null;
            try
            {
                theData = PeopleBLL.GetPeopleById(PersonId);
            }
            catch (Exception exc)
            {
                SystemMessages.DisplaySystemErrorMessage(exc.Message);
            }
            if (theData != null)
            {
                if (DataTypeHiddenField.Value.Equals("KPI"))
                {
                    pnlAddPeople.Style["display"] = "none";
                    pnlKPIPeople.Style["display"] = "inline";
                    KPIPeopleText.Text = theData.Name;

                    pnlKPIProject.Style["display"] = "none";
                    pnlAddProject.Style["display"] = "none";
                    pnlKPIActivity.Style["display"] = "none";
                    pnlAddActivity.Style["display"] = "none";

                    pnlKPIData.Style["display"] = "block";
                    pnlKPI.Style["display"] = "none";
                }

                OrganizationId = theData.OrganizationId;
                AreaId = theData.AreaId;
            }
        }
    }

    private void LoadOrganization()
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
            {
                OrganizationTextBox.Text = theData.Name;
            }
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
                if (DataTypeHiddenField.Value.Equals("KPI"))
                {
                    pnlAddArea.Style["display"] = "none";
                    pnlKPIArea.Style["display"] = "inline";
                    KPIAreaText.Text = theData.Name;
                }
                else
                    AreaTextBox.Text = theData.Name;
            }
        }
    }

    private void LoadKPI()
    {
        if (KPIId > 0 && DataTypeHiddenField.Value.Equals("KPI"))
        {
            KPI theData = null;
            try
            {
                theData = KPIBLL.GetKPIById(KPIId);
            }
            catch (Exception exc)
            {
                SystemMessages.DisplaySystemErrorMessage(exc.Message);
            }
            if (theData != null)
            {
                if (theData.OrganizationID > 0)
                {
                    pnlKPIEnabled.Style["display"] = "block";
                    pnlKPIDisabled.Style["display"] = "none";
                }
                else
                {
                    pnlKPIEnabled.Style["display"] = "none";
                    pnlKPIDisabled.Style["display"] = "block";
                }

                if (theData.AreaID > 0 || theData.ProjectID > 0 || theData.ActivityID > 0 || theData.PersonID > 0)
                    pnlKPIData.Style["display"] = "block";
                else
                    pnlKPIData.Style["display"] = "none";

                OrganizationId = theData.OrganizationID;
                AreaId = theData.AreaID;
                ProjectId = theData.ProjectID;
                ActivityId = theData.ActivityID;
                PersonId = theData.PersonID;
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