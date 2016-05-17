using Artexacta.App.Dashboard;
using Artexacta.App.Dashboard.BLL;
using Artexacta.App.FRTWB;
using Artexacta.App.KPI;
using Artexacta.App.KPI.BLL;
using Artexacta.App.User.BLL;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Kpis_KpiDetails : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");



    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack)
            return;
        ProcessSessionParameters();
        if (KpiIdHiddenField.Value == "0")
        {
            Response.Redirect("~/Kpi/KpiList.aspx");
            return;
        }
        LoadKpiData();
    }

    private void ProcessSessionParameters()
    {
        if(Session["KpiId"] != null && !string.IsNullOrEmpty(Session["KpiId"].ToString()))
        {
            KpiIdHiddenField.Value = Session["KpiId"].ToString();
        }
        Session["KpiId"] = null;
    }

    private void LoadKpiData()
    {
        int kpiId = Convert.ToInt32(KpiIdHiddenField.Value);
        int userId = UserBLL.GetUserIdByUsername(User.Identity.Name);
        UserIdHiddenField.Value = userId.ToString();

        KPI kpi = KPIBLL.GetKPIById(kpiId);
        KpiNameLiteral.Text = kpi.Name;
        
        //Obtengo aleatoriamente el dato a mostrar
        Random rnd = new Random();
        int caso = rnd.Next(1, 100);
        //Inicializo los valores conocidos
        KpiType.Text = "<div class='col-md-4 col-sm-4'>KPI Type:</div><div class='col-md-8 col-sm-8'>" + kpi.KpiTypeID + "</div>";
        WebServiceId.Text = "<div class='col-md-4 col-sm-4'>Web Service ID:</div><div class='col-md-8 col-sm-8'>SERV-Reliavility</div>";
        ReportingUnit.Text = "<div class='col-md-4 col-sm-4'>Reporting Unit:</div><div class='col-md-8 col-sm-8'>" + kpi.ReportingUnitID + "</div>";
        //KpiTarget.Text = "<div class='col-md-4 col-sm-4'>KPI Target:</div><div class='col-md-8 col-sm-8'>" + (string.IsNullOrEmpty(kpi.re) ? "12 months" : kpi.KpiTarget) + "</div>";

        //if (caso <= 50)
        //{
        //    StartingDate.Text = "<div class='col-md-4 col-sm-4'>Starting Date:</div><div class='col-md-8 col-sm-8'>01/15/16</div>";
        //    MeanTimeGraphic.Visible = true;
        //    MeanTimeProgress.Visible = true;
        //}
        //else
        //{
            StartingDate.Text = "<div class='col-md-4 col-sm-4'>Starting Date:</div><div class='col-md-8 col-sm-8'>05/17/15</div>";
            RevenueCollectionGraphic.Visible = true;
            RevenueCollectionProgress.Visible = true;
            ChartControl.KpiId = kpiId;
        //}
    }

    protected void UserDashboardDataSource_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        if (e.Exception == null)
            return;
        log.Error("Error getting KPI for Dashboard", e.Exception);
        e.ExceptionHandled = true;
    }

    protected void DashboardsComboBox_DataBound(object sender, EventArgs e)
    {
        DashboardsComboBox.Items.Insert(0, new ListItem("-- Select a Dashboard --", ""));
        if (IsAddedInMainDashboard.Value == "true")
            return;
        ListItem item = DashboardsComboBox.Items.FindByValue("0");
        if(item == null)
            DashboardsComboBox.Items.Insert(1, new ListItem("Main Dashboard", "0"));
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        try
        {
            int kpiId = Convert.ToInt32(KpiIdHiddenField.Value);
            int dashboardId = Convert.ToInt32(DashboardsComboBox.SelectedValue);
            int userId = Convert.ToInt32(UserIdHiddenField.Value);
            KpiDashboardBLL.InsertKpiToDashboard(kpiId, dashboardId, userId);
            DashboardRepeater.DataBind();
            DashboardsComboBox.DataBind();
        }
        catch (Exception ex)
        {
            log.Error("Error saving KPI in dashboard", ex);
        }
    }

    protected void DashboardRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        
        if(e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            UserDashboard obj = (UserDashboard)e.Item.DataItem;
            if (obj == null)
                return;
            if (IsAddedInMainDashboard.Value != "true" && obj.DashboardId == 0)
                IsAddedInMainDashboard.Value = "true";
            
        }
    }

    protected void DashboardRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if(e.CommandName == "DeleteDashboard")
        {
            try
            {
                int dashboardId = Convert.ToInt32(e.CommandArgument);
                int userId = Convert.ToInt32(UserIdHiddenField.Value);
                int kpiId = Convert.ToInt32(KpiIdHiddenField.Value);
                KpiDashboardBLL.DeleteKpiDashboard(dashboardId, userId, kpiId);
                IsAddedInMainDashboard.Value = "false";
                DashboardRepeater.DataBind();
                DashboardsComboBox.DataBind();

                
            }
            catch (Exception ex)
            {
                log.Error("Error deleting kpi from dashboard", ex);
            }
        }
    }

    protected void DashboardRepeater_PreRender(object sender, EventArgs e)
    {
        HeaderTemplate.Visible = DashboardRepeater.Items.Count > 0;
        EmptyTemplate.Visible = !HeaderTemplate.Visible;
    }
}