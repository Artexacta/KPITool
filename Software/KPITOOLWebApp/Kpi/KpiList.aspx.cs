using Artexacta.App.Utilities.SystemMessages;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
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

    protected string GetOrganizationInfo(Object obj)
    {
        int OrganizationID = 0;
        string name = "";
        try
        {
            OrganizationID = (int)obj;
        }
        catch { return "-"; }

        if (OrganizationID > 0)
        {
            Organization theClass = null;

            try
            {
                theClass = OrganizationBLL.GetOrganizationById(OrganizationID);
            }
            catch { }

            if (theClass != null)
                name = theClass.Name;
        }

        return name;
    }

    protected string GetAreaInfo(Object obj)
    {
        int areaID = 0;
        string name = "";
        try
        {
            areaID = (int)obj;
        }
        catch { return "-"; }

        if (areaID > 0)
        {
            Area theClass = null;

            try
            {
                theClass = AreaBLL.GetAreaById(areaID);
            }
            catch { }

            if (theClass != null)
                name = " - " + theClass.Name;
        }

        return name;
    }

    protected string GetProjectInfo(Object obj)
    {
        int projectID = 0;
        string name = "";
        try
        {
            projectID = (int)obj;
        }
        catch { return "-"; }

        if (projectID > 0)
        {
            Project theClass = null;

            try
            {
                theClass = ProjectBLL.GetProjectById(projectID);
            }
            catch { }

            if (theClass != null)
                name = " - " + theClass.Name;
        }

        return name;
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

}