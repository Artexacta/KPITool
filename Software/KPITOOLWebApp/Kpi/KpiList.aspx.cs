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

    protected void KpisRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        int KpiId = 0;
        try
        {
            KpiId = Convert.ToInt32(e.CommandArgument);
        }
        catch (Exception ex)
        {
            log.Error("Error getting object id", ex);
        }
        if (KpiId <= 0)
        {
            SystemMessages.DisplaySystemErrorMessage("Could not complete the requested action");
            return;
        }

        switch (e.CommandName)
        {
            case "ViewOwner":
                //Kpi objKpi = FrtwbSystem.Instance.Kpis[KpiId];
                //FrtwbObject ownerObject = objKpi.Owner;
                //if (ownerObject == null)
                //    return;


                //if (ownerObject is Organization)
                //{
                //    Session["OrganizationId"] = ownerObject.ObjectId;
                //    Response.Redirect("~/Organization/OrganizationDetails.aspx");
                //}
                //else if (ownerObject is Area)
                //{
                //    Area area = (Area)ownerObject;
                //    Session["OrganizationId"] = area.Owner.ObjectId;
                //    Response.Redirect("~/Organization/OrganizationDetails.aspx");
                //}
                //else if (ownerObject is Activity)
                //{
                //    Session["ActivityId"] = ownerObject.ObjectId;
                //    Response.Redirect("~/Activity/ActivityDetails.aspx");
                //}
                //else if (ownerObject is Project)
                //{
                //    Session["ProjectId"] = ownerObject.ObjectId;
                //    Response.Redirect("~/Project/ProjectDetails.aspx");
                //}
                return;
            case "DeleteKpi":

                //objKpi = FrtwbSystem.Instance.Kpis[KpiId];


                //RemoveKpiFromOldOwner(objKpi);
                //objKpi.Owner = null;
                //FrtwbSystem.Instance.Kpis.Remove(objKpi.ObjectId);
                //SystemMessages.DisplaySystemMessage("The Kpi was deleted");
                //SearchKpis();
                break;
            case "ViewActivities":

                Session["OwnerId"] = KpiId + "-Kpi";
                Response.Redirect("~/Activity/ActivitiesList.aspx");
                break;
            case "EditKpi":
                Session["KPI_ID"] = KpiId.ToString();
                Response.Redirect("~/Kpi/KpiForm.aspx");
                break;
        }
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