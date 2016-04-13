using Artexacta.App.FRTWB;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Activity_DetailActivity : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    private int ActivityId
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
        int activityId = ActivityId;
        if (activityId <= 0)
        {
            Response.Redirect(ParentPage);
            return;
        }
        Activity objActivity = FrtwbSystem.Instance.Activities[activityId];

        ActivityNameLiteral.Text = objActivity.Name;
        KpisGridView.DataSource = objActivity.Kpis.Values;
        KpisGridView.DataBind();
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
            int id = 0;
            try
            {
                id = Convert.ToInt32(Session["ActivityId"].ToString());
            }
            catch (Exception ex)
            {
                log.Error("Error trying to convert Session['ActivityId'] to integer value", ex);
            }
            ActivityId = id;
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
    protected void ViewButton_Click(object sender, EventArgs e)
    {
        OperationHiddenField.Value = "VIEW";
    }
}