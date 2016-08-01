using Artexacta.App.Currency;
using Artexacta.App.Currency.BLL;
using Artexacta.App.Dashboard;
using Artexacta.App.Dashboard.BLL;
using Artexacta.App.FRTWB;
using Artexacta.App.KPI;
using Artexacta.App.KPI.BLL;
using Artexacta.App.User.BLL;
using Artexacta.App.Utilities;
using Artexacta.App.Utilities.SystemMessages;
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

    protected override void InitializeCulture()
    {
        Artexacta.App.Utilities.LanguageUtilities.SetLanguageFromContext();
        base.InitializeCulture();
    }

    public int KpiId
    {
        set
        {
            KpiIdHiddenField.Value = value.ToString();
        }
        get
        {
            int kpiId = 0;
            try
            {
                kpiId = Convert.ToInt32(KpiIdHiddenField.Value);
            }
            catch (Exception ex)
            {
                log.Error("Error getting ", ex);
            }
            return kpiId;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack)
            return;
        ProcessSessionParameters();
        if (KpiIdHiddenField.Value == "0")
        {
            SystemMessages.DisplaySystemErrorMessage(Resources.KpiDetails.ErrorLoadingKpi);
            Response.Redirect("~/Kpi/KpiList.aspx");
            return;
        }

        try
        {
            LoadKpiData();
            return;
        }
        catch (Exception ex)
        {
            SystemMessages.DisplaySystemErrorMessage(Resources.KpiDetails.ErrorLoadingKpi);
            log.Error("Error loading KPI", ex);
        }
        Response.Redirect("~/Kpi/KpiList.aspx");
    }

    private void ProcessSessionParameters()
    {
        if(Session["KpiId"] != null && !string.IsNullOrEmpty(Session["KpiId"].ToString()))
        {
            KpiIdHiddenField.Value = Session["KpiId"].ToString();
        }
        Session["KpiId"] = null;
        if (Session["SEARCH_PARAMETER"] != null && !string.IsNullOrEmpty(Session["SEARCH_PARAMETER"].ToString()))
        {
            SearchQuery.Value = Session["SEARCH_PARAMETER"].ToString();
        }
        Session["SEARCH_PARAMETER"] = null;
    }

    private void LoadKpiData()
    {
        int kpiId = Convert.ToInt32(KpiIdHiddenField.Value);
        int userId = UserBLL.GetUserIdByUsername(User.Identity.Name);
        UserIdHiddenField.Value = userId.ToString();

        KPI kpi = KPIBLL.GetKPIById(kpiId);
        KpiNameLiteral.Text = kpi.Name;

        List<KPICategory> categories = KPICategoryBLL.GetKpiCategoriesByKpiId(kpiId);
        if(categories.Count > 0)
        {
            CategoriesRepeater.DataSource = categories;
            CategoriesRepeater.DataBind();
            CategoriesPanel.Visible = true;
        }
        //Inicializo los valores conocidos
        string lang = LanguageUtilities.GetLanguageFromContext();
        KPITypeBLL theBll = new KPITypeBLL();
        KPIType type = theBll.GetKPITypesByID(kpi.KpiTypeID, lang);
        KpiType.Text = type != null ? type.TypeName : kpi.KpiTypeID ;
        //WebServiceId.Text = "<div class='col-md-4 col-sm-4'>Web Service ID:</div><div class='col-md-8 col-sm-8'>SERV-Reliavility</div>";
        ReportingUnit.Text = kpi.ReportingUnitName;
        KpiTarget.Text = (kpi.TargetPeriod == 0 ? Resources.KpiDetails.NoTargetLabel : kpi.TargetPeriod + " " + kpi.ReportingUnitID);

        //if (caso <= 50)
        //{
        //    StartingDate.Text = "<div class='col-md-4 col-sm-4'>Starting Date:</div><div class='col-md-8 col-sm-8'>01/15/16</div>";
        //    MeanTimeGraphic.Visible = true;
        //    MeanTimeProgress.Visible = true;
        //}
        //else
        //{
        StartingDate.Text = kpi.StartDate != DateTime.MinValue ? kpi.StartDate.ToShortDateString() : "-";
        RevenueCollectionGraphic.Visible = true;
            //RevenueCollectionProgress.Visible = true;
        ChartControl.KpiId = kpiId;
        ExportControl.KpiId = kpiId;
        StatsControl.KpiId = kpiId;
        MeasurementsControl.KpiId = kpiId;
        
        MeasurementsControl.Unit = kpi.UnitID;

        //CurrencyUnitBLL currencyUnitBll = new CurrencyUnitBLL();
        //CurrencyUnit currencyUnit = currencyUnitBll.GetCurrencyUnitsById(lang, ;

        //MeasurementsControl.Currency = kpi.Currency;

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
        DashboardsComboBox.Items.Insert(0, new ListItem(Resources.KpiDetails.SelectDashboardLabel, ""));
        if (IsAddedInMainDashboard.Value == "true")
            return;
        ListItem item = DashboardsComboBox.Items.FindByValue("0");
        if(item == null)
            DashboardsComboBox.Items.Insert(1, new ListItem(Resources.KpiDashboard.MainDashboardTitle, "0"));
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
            return;
        }

        Session["KpiId"] = KpiIdHiddenField.Value;
        Response.Redirect("~/Kpis/KpiDetails.aspx");
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

    protected void CategoriesRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        Literal lt = (Literal)e.Item.FindControl("CollapseLiteral");
        if (lt == null)
            return;
        KPICategory obj = (KPICategory) e.Item.DataItem;
        if (obj == null)
            return;
        lt.Text = "<div class='collapse m-b-20' id='" + obj.HtmlId + "'>";
    }

    protected void BackToListButton_Click(object sender, EventArgs e)
    {
        Session["SEARCH_PARAMETER"] = SearchQuery.Value;
        Response.Redirect("~/Kpi/KpiList.aspx");
    }
}