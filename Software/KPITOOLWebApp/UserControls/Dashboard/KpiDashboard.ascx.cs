using Artexacta.App.Dashboard;
using Artexacta.App.Dashboard.BLL;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class UserControls_Dashboard_KpiDashboard : System.Web.UI.UserControl
{
    private static readonly ILog log = LogManager.GetLogger("Standard");
    
    public delegate void DeleteKpiHandler();
    public event DeleteKpiHandler KpiDeleted;

    public int UserId
    {
        set { UserIdHiddenField.Value = value.ToString(); }
        get
        {
            int userId = 0;
            try
            {
                userId = Convert.ToInt32(UserIdHiddenField.Value);
            }
            catch (Exception ex)
            {
                log.Error("Error trying to convert UserIdHiddenField.Value to integer value", ex);
            }
            return userId;
        }
    }

    public int DashboardId
    {
        set { DashboardIdHiddenField.Value = value.ToString(); }
        get
        {
            int dashboardId = 0;
            try
            {
                dashboardId = Convert.ToInt32(DashboardIdHiddenField.Value);
            }
            catch (Exception ex)
            {
                log.Error("Error trying to convert DashboardIdHiddenField.Value to integer value", ex);
            }
            return dashboardId;
        }
    }

    public string TabId
    {
        set { TabIdHiddenField.Value = value; }
        get { return TabIdHiddenField.Value; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {

        LoadKpis();
    }

    public void LoadKpis()
    {
        try
        {
            KpisRepeater.DataSource = KpiDashboardBLL.GetKpiDashboard(DashboardId, UserId);
            KpisRepeater.DataBind();
        }
        catch (Exception ex)
        {
            log.Error("Error loading KPIs to dashboard", ex);
        }
    }

    protected override void OnPreRender(EventArgs e)
    {
        base.OnPreRender(e);
    }

    protected void KpiDataSource_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        if (e.Exception == null)
            return;
        log.Error("Error getting KPI for Dashboard", e.Exception);
        e.ExceptionHandled = true;
    }

    protected void KpisRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if(e.CommandName == "ViewKPI")
        {
            Session["KpiId"] = e.CommandArgument.ToString();
            Response.Redirect("~/Kpis/KpiDetails.aspx");
            return;
        }

        if (e.CommandName == "ExportKPI")
        {
            return;
        }

        if (e.CommandName == "DeleteKPI")
        {
            try
            {
                int kpiId = Convert.ToInt32(e.CommandArgument);
                int dashboardId = DashboardId;
                int userId = UserId;
                KpiDashboardBLL.DeleteKpiDashboard(dashboardId, userId, kpiId);
                if (KpiDeleted != null)
                    KpiDeleted();
                LoadKpis();
            }
            catch (Exception ex)
            {
                log.Error("error deleting kpi from Dashboard", ex);
                
            }
        }
    }

    protected void KpisRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        //if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem)
        //    return;
        //UserControls_KPI_KpiChart control = (UserControls_KPI_KpiChart)e.Item.FindControl("KpiChartControl");
        //if(control != null)
        //    control.BuildChart();
    }
}