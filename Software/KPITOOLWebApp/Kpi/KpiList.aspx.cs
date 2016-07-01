using Artexacta.App.Utilities.SystemMessages;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Artexacta.App.KPI;
using Artexacta.App.Organization;
using Artexacta.App.Organization.BLL;
using Artexacta.App.Area;
using Artexacta.App.Area.BLL;
using Artexacta.App.Project;
using Artexacta.App.Project.BLL;
using Artexacta.App.KPI.BLL;

public partial class Kpi_KpiList : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    protected override void InitializeCulture()
    {
        Artexacta.App.Utilities.LanguageUtilities.SetLanguageFromContext();
        base.InitializeCulture();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        KPISearchControl.Config = new KPISearch();
        KPISearchControl.OnSearch += KPISearchControl_OnSearch;

        if (!IsPostBack)
        {
            ProcessSessionParameters();
        }
    }

    void KPISearchControl_OnSearch()
    {

    }

    private void ProcessSessionParameters()
    {
        if (Session["SEARCH_PARAMETER"] != null && !string.IsNullOrEmpty(Session["SEARCH_PARAMETER"].ToString()))
        {
            KPISearchControl.Query = Session["SEARCH_PARAMETER"].ToString();
        }
        Session["SEARCH_PARAMETER"] = null;
    }

    protected void KPIListObjectDataSource_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        if (e.Exception != null)
        {
            SystemMessages.DisplaySystemErrorMessage("Error to get KPI List.");
            e.ExceptionHandled = true;
        }
    }

    protected void KpisGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        int kpiId = 0;
        try
        {
            kpiId = Convert.ToInt32(e.CommandArgument);
        }
        catch (Exception ex)
        {
            log.Error("Error getting object id", ex);
        }

        if (kpiId <= 0)
        {
            SystemMessages.DisplaySystemErrorMessage(Resources.Kpi.MessageNotAction);
            return;
        }

        if (e.CommandName == "ViewKpi")
        {
            Session["KpiId"] = kpiId.ToString();
            Session["SEARCH_PARAMETER"] = KPISearchControl.Query;
            Response.Redirect("~/Kpis/KpiDetails.aspx");
        }
        if (e.CommandName == "EditKpi")
        {
            Session["KPI_ID"] = kpiId.ToString();
            Response.Redirect("~/Kpi/KpiForm.aspx");
        }
        if (e.CommandName == "ShareKpi")
        {
            Session["KPIID"] = kpiId.ToString();
            Response.Redirect("~/Kpi/ShareKpi.aspx");
        }
        if (e.CommandName == "ListValuesKpi")
        {
            Session["KPIID"] = kpiId.ToString();
            Response.Redirect("~/Kpi/ImportData.aspx");
        }
        if (e.CommandName == "ViewOrganization")
        {
            Session["SEARCH_PARAMETER"] = "@organizationID " + kpiId.ToString();
            Response.Redirect("~/MainPage.aspx");
        }
        if (e.CommandName == "ViewProject")
        {
            Session["SEARCH_PARAMETER"] = "@projectID " + kpiId.ToString();
            Response.Redirect("~/Project/ProjectList.aspx");
        }
        if (e.CommandName == "ViewArea")
        {
            Session["OrganizationId"] = kpiId.ToString();
            Response.Redirect("~/Organization/EditOrganization.aspx");
        }
        if (e.CommandName == "DeleteKpi")
        {
            try
            {
                KPIBLL.DeleteKPI(kpiId);
            }
            catch (Exception ex)
            {
                SystemMessages.DisplaySystemErrorMessage(ex.Message);
                return;
            }
            KpisGridView.DataBind();
        }
    }

    protected void KpisGridView_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.DataItem is KPI)
        {
            KPI theData = (KPI)e.Row.DataItem;

            if (theData == null)
                return;

            Panel theDelete = (Panel)e.Row.FindControl("pnlDelete");
            if (theDelete != null && !theData.IsOwner)
            {
                theDelete.CssClass = "disabled";
            }

            Panel theShare = (Panel)e.Row.FindControl("pnlShare");
            if (theShare != null && !theData.IsOwner)
            {
                theShare.CssClass = "disabled";
            }

            //If exists AreaName Show the GuionLabel
            if (!string.IsNullOrEmpty(theData.AreaName))
            {
                Label theGuionA = (Label)e.Row.FindControl("GuionALabel");
                if (theGuionA != null)
                    theGuionA.Visible = true;
            }
            //If exists ProjectName Show the GuionLabel
            if (!string.IsNullOrEmpty(theData.ProjectName))
            {
                Label theGuionP = (Label)e.Row.FindControl("GuionPLabel");
                if (theGuionP != null)
                    theGuionP.Visible = true;
            }

        }
    }
}