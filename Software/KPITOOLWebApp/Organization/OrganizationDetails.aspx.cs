using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Artexacta.App.Organization.BLL;
using Artexacta.App.Organization;
using Artexacta.App.Utilities.SystemMessages;
using Artexacta.App.Area;

public partial class Organization_OrganizationDetails : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    private int OrganizationId
    {
        set { OrganizationIdHiddenField.Value = value.ToString(); }
        get
        {
            int organizationId = 0;
            try
            {
                organizationId = Convert.ToInt32(OrganizationIdHiddenField.Value);
            }
            catch (Exception ex)
            {
                log.Error("Error trying to convert OrganizationIdHiddenField.Value to integer value", ex);
            }
            return organizationId;
        }
    }

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
        LoadData();
    }

    private void LoadData()
    {
        int organizationId = OrganizationId;

        if (organizationId <= 0)
        {
            Response.Redirect(ParentPage);
            return;
        }

        OrganizationBLL theBLL = new OrganizationBLL();
        Organization organization = null;

        try
        {
            organization = theBLL.GetOrganizationById(organizationId);
        }
        catch (Exception exc)
        {
            SystemMessages.DisplaySystemErrorMessage(exc.Message);
            Response.Redirect(ParentPage);
        }

        if (organization != null)
        {
            OrganizationNameLiteral.Text = organization.Name;
            AreasGridView.DataBind();

            //ProjectsGridView.DataSource = objOrganization.Projects.Values;
            //ProjectsGridView.DataBind();

            //ActivitiesGridView.DataSource = objOrganization.Activities.Values;
            //ActivitiesGridView.DataBind();

            //KpisGridView.DataSource = objOrganization.Kpis.Values;
            //KpisGridView.DataBind();
        }
    }

    private void ProcessSessionParametes()
    {
        if (Session["ParentPage"] != null && !string.IsNullOrEmpty(Session["ParentPage"].ToString()))
        {
            ParentPage = Session["ParentPage"].ToString();
        }
        Session["ParentPage"] = null;

        if (Session["OrganizationId"] != null && !string.IsNullOrEmpty(Session["OrganizationId"].ToString()))
        {
            int id = 0;
            try
            {
                id = Convert.ToInt32(Session["OrganizationId"].ToString());
            }
            catch (Exception ex)
            {
                log.Error("Error trying to convert Session['OrganizationId'] to integer value", ex);
            }
            OrganizationId = id;
        }
        Session["OrganizationId"] = null;
    }
    protected void ProjectsGridView_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ProjectsGridView.SelectedDataKey == null)
        {
            return;
        }

        int projectId = (int)ProjectsGridView.SelectedDataKey.Value;
        if (OperationHiddenField.Value == "VIEW")
        {
            Session["ProjectId"] = projectId;
            Response.Redirect("~/Project/ProjectDetails.aspx");
        }
    }
    protected void ViewProjectButton_Click(object sender, EventArgs e)
    {
        OperationHiddenField.Value = "VIEW";
    }
    protected void ActivitiesGridView_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ActivitiesGridView.SelectedDataKey == null)
        {
            return;
        }

        int activityId = (int)ActivitiesGridView.SelectedDataKey.Value;
        if (OperationHiddenField.Value == "VIEW")
        {
            Session["ActivityId"] = activityId;
            Response.Redirect("~/Activity/DetailActivity.aspx");
        }
    }
    protected void ViewActivityButton_Click(object sender, EventArgs e)
    {
        OperationHiddenField.Value = "VIEW";
    }
    protected void KpisGridView_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (KpisGridView.SelectedDataKey == null)
        {
            return;
        }

        int idKpi = (int)KpisGridView.SelectedDataKey.Value;
        if (OperationHiddenField.Value == "VIEW")
        {
            Session["KpiId"] = idKpi;
            Response.Redirect("~/Kpis/KpiDetails.aspx");
        }
    }
    protected void ViewKpiButton_Click(object sender, EventArgs e)
    {
        OperationHiddenField.Value = "VIEW";
    }
   
    protected void ActivitiesGridView_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        //UserControls_FRTWB_KpiImage img = (UserControls_FRTWB_KpiImage)e.Row.FindControl("ImageOfKpi");
        //if (img == null)
        //    return;

        //if (e.Row.DataItem is Activity)
        //{
        //    Activity objActivity = (Activity)e.Row.DataItem;
        //    if (objActivity != null && objActivity.Kpis.Count > 0)
        //    {
        //        List<Kpi> kpis = objActivity.Kpis.Values.ToList();
        //        Kpi objKpi = kpis[0];
        //        if (objKpi.KpiValues.Count > 0)
        //        {
        //            img.KpiId = objKpi.ObjectId;
        //            img.Visible = true;
        //        }
        //    }
        //}
    }
    protected void ProjectsGridView_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        //UserControls_FRTWB_KpiImage img = (UserControls_FRTWB_KpiImage)e.Row.FindControl("ImageOfKpi");
        //if (img == null)
        //    return;

        //if (e.Row.DataItem is Project)
        //{
        //    Project objProject = (Project)e.Row.DataItem;
        //    if (objProject != null && objProject.Kpis.Count > 0)
        //    {
        //        List<Kpi> kpis = objProject.Kpis.Values.ToList();
        //        Kpi objKpi = kpis[0];
        //        if (objKpi.KpiValues.Count > 0)
        //        {
        //            img.KpiId = objKpi.ObjectId;
        //            img.Visible = true;
        //        }
        //    }
        //}
    }
    protected void AreasGridView_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        UserControls_FRTWB_KpiImage img = (UserControls_FRTWB_KpiImage)e.Row.FindControl("ImageOfKpi");
        
        if (img == null)
            return;

        if (e.Row.DataItem is Area)
        {
            //Area objArea = (Area)e.Row.DataItem;
            //if (objArea != null && objArea.Kpis.Count > 0)
            //{
            //    List<Kpi> kpis = objArea.Kpis.Values.ToList();
            //    Kpi objKpi = kpis[0];
            //    if (objKpi.KpiValues.Count > 0)
            //    {
            //        img.KpiId = objKpi.ObjectId;
            //        img.Visible = true;
            //    }
            //}
        }
    }
    protected void AreasObjectDataSource_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        if (e.Exception != null)
        {
            e.ExceptionHandled = true;
            SystemMessages.DisplaySystemErrorMessage(Resources.Organization.MessageErrorCargarAreas);
        }
    }
}