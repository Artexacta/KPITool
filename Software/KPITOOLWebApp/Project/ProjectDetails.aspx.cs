using Artexacta.App.FRTWB;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Project_ProjectDetails : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    private int ProjectId
    {
        set { ProjectIdHiddenField.Value = value.ToString(); }
        get
        {
            int id = 0;
            try
            {
                id = Convert.ToInt32(ProjectIdHiddenField.Value);
            }
            catch (Exception ex)
            {
                log.Error("Error trying to convert ProjectIdHiddenField.Value to integer value", ex);
            }
            return id;
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
        LoadData();
    }

    private void LoadData()
    {
        int projectId = ProjectId;
        if (projectId <= 0)
        {
            Response.Redirect(ParentPage);
            return;
        }
        Project objProject = FrtwbSystem.Instance.Projects[projectId];

        ProjectNameLiteral.Text = objProject.Name;
        ActivitiesGridView.DataSource = objProject.Activities.Values;
        ActivitiesGridView.DataBind();
        KpisGridView.DataSource = objProject.Kpis.Values;
        KpisGridView.DataBind();
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
            int id = 0;
            try
            {
                id = Convert.ToInt32(Session["ProjectId"].ToString());
            }
            catch (Exception ex)
            {
                log.Error("Error trying to convert Session['ProjectId'] to integer value", ex);
            }
            ProjectId = id;
        }
        Session["ProjectId"] = null;
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
    protected void ViewActivityButton_Click(object sender, EventArgs e)
    {
        OperationHiddenField.Value = "VIEW";
    }
    protected void ViewKpiButton_Click(object sender, EventArgs e)
    {
        OperationHiddenField.Value = "VIEW";
    }
    protected void KpisGridView_RowDataBound(object sender, GridViewRowEventArgs e)
    {

    }
    protected void ActivitiesGridView_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        UserControls_FRTWB_KpiImage img = (UserControls_FRTWB_KpiImage)e.Row.FindControl("ImageOfKpi");
        if (img == null)
            return;

        if (e.Row.DataItem is Activity)
        {
            Activity objActivity = (Activity)e.Row.DataItem;
            if (objActivity != null && objActivity.Kpis.Count > 0)
            {
                List<Kpi> kpis = objActivity.Kpis.Values.ToList();
                Kpi objKpi = kpis[0];
                if (objKpi.KpiValues.Count > 0)
                {
                    img.OwnerId = objActivity.ObjectId;
                    img.Visible = true;
                }
            }
        }
    }
}