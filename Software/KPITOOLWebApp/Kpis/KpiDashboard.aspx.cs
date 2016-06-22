using Artexacta.App.Dashboard;
using Artexacta.App.Dashboard.BLL;
using Artexacta.App.FRTWB;
using Artexacta.App.User.BLL;
using Artexacta.App.Utilities.SystemMessages;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Kpis_KpiDashboard : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    protected override void InitializeCulture()
    {
        Artexacta.App.Utilities.LanguageUtilities.SetLanguageFromContext();
        base.InitializeCulture();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        LoadKpisData();
    }

    public void LoadKpisData()
    {
        try
        {
            int userId = UserBLL.GetUserIdByUsername(User.Identity.Name);
            MainKpiDashboardControl.UserId = userId;
            UserIdHiddenField.Value = userId.ToString();

            List<UserDashboard> dashboards = UserDashboardBLL.GetUserDashboards(userId);
            UserDashboard2Repeater.DataSource = dashboards;
            UserDashboard2Repeater.DataBind();
            UserDashboardRepeater.DataSource = dashboards;
            UserDashboardRepeater.DataBind();
        }
        catch (Exception ex)
        {
            log.Error("Error getting user id of current user", ex);
        }
    }

    protected void UserDashboardDataSource_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        if (e.Exception == null)
            return;
        log.Error("Error getting KPI for Dashboard", e.Exception);
        e.ExceptionHandled = true;
    }

    protected void UserDashboard2Repeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        UserControls_Dashboard_KpiDashboard control = (UserControls_Dashboard_KpiDashboard)e.Item.FindControl("UserDashboardControl");
        if (control == null)
            return;

        try
        {
            control.UserId = Convert.ToInt32(UserIdHiddenField.Value);
            control.LoadKpis();
        }
        catch (Exception ex)
        {
            log.Error("Error setting userID to KpiDashboard", ex);
        }
        Literal header = (Literal)e.Item.FindControl("HeaderLiteral");
        if (header == null)
            return;
        try
        {
            UserDashboard obj = (UserDashboard)e.Item.DataItem;

            header.Text = "<div role=\"tabpanel\" class=\"tab-pane\" id=\"t-" + obj.DashboardId + "\">";
        }
        catch (Exception ex)
        {
            log.Error("Error getting dataitem from repeater item", ex);
        }
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        try
        {
            int dashboardId = Convert.ToInt32(SelectedDashboardHiddenField.Value);
            if (dashboardId == 0)
            {
                int userId = Convert.ToInt32(UserIdHiddenField.Value);
                UserDashboardBLL.InsertUserDashboard(DashboardNameTextBox.Text, userId);
            }
            else
                UserDashboardBLL.UpdateUserDashboard(dashboardId, DashboardNameTextBox.Text);
            LoadKpisData();
            SelectedDashboardHiddenField.Value = "0";
            DashboardNameTextBox.Text = "";
            ModalTitle.Text = "Add Dashboard";
        }
        catch (Exception ex)
        {
            log.Error("Error saving selected dashboard", ex);
        }
    }

    protected void UserDashboard2Repeater_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if(e.CommandName == "RenameDashboard")
        {
            try
            {
                ModalTitle.Text = "Rename Dashboard";
                int dashboardId = Convert.ToInt32(e.CommandArgument);
                SelectedDashboardHiddenField.Value = dashboardId.ToString();
                UserDashboard obj = UserDashboardBLL.GetUserDashboardById(dashboardId);
                DashboardNameTextBox.Text = obj.Name;
                OpenPopup.Value = "true";
            }
            catch (Exception ex)
            {
                log.Error("error getting data of user dashboard", ex);
            }
        }
        if (e.CommandName == "DeleteDashboard")
        {
            try
            {
                int dashboardId = Convert.ToInt32(e.CommandArgument);
                UserDashboardBLL.DeleteUserDashboard(dashboardId);
                CurrentTabIndex.Value = "0";
                LoadKpisData();
            }
            catch (Exception ex)
            {
                log.Error("Error deleting selected dashboard", ex);
            }
        }
    }

    protected void UserDashboardControl_KpiDeleted()
    {
        LoadKpisData();
    }
}