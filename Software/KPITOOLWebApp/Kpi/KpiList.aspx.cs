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

public partial class Kpi_KpiList : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    protected override void InitializeCulture()
    {
        Artexacta.App.Utilities.LanguageUtilities.SetLanguageFromContext();
        base.InitializeCulture();
    }

    private string ownerToSelectInSearch;

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
        if (Session["OwnerId"] != null && !string.IsNullOrEmpty(Session["OwnerId"].ToString()))
        {
            ownerToSelectInSearch = Session["OwnerId"].ToString();
        }
    }

    protected void ViewKpi_Click(object sender, EventArgs e)
    {
        LinkButton btnClick = (LinkButton)sender;
        Session["KpiId"] = btnClick.Attributes["data-id"];
        Response.Redirect("~/Kpis/KpiDetails.aspx");
    }

    protected void EditKpi_Click(object sender, EventArgs e)
    {
        LinkButton btnClick = (LinkButton)sender;
        Session["KpiId"] = btnClick.Attributes["data-id"];
        Session["ParentPage"] = "~/Kpi/KpiList.aspx";
        Response.Redirect("~/Kpi/KpiForm.aspx");
    }
    protected void ShareKpi_Click(object sender, EventArgs e)
    {

    }
    protected void DeleteKpi_Click(object sender, EventArgs e)
    {

    }
    protected string GetOwnerInfo(Object obj)
    {
        return "N/A";
        //FrtwbObject ownerObject = (FrtwbObject)obj;
        //if (ownerObject == null)
        //    return "N/A";

        //string type = "";
        //if (ownerObject is Organization)
        //    return "Organization: " + ownerObject.Name;
        //else if (ownerObject is Area)
        //{
        //    string owner = "Area: " + ownerObject.Name;
        //    Area area = (Area)ownerObject;
        //    if (area.Owner != null)
        //        owner += " of Organization " + area.Owner.Name;
        //    return owner;
        //}
        //else if (ownerObject is Project)
        //{
        //    string owner = "Project: " + ownerObject.Name;
        //    Project project = (Project)ownerObject;
        //    if (project.Owner != null)
        //    {
        //        if (project.Owner is Area)
        //        {
        //            owner += " of Area " + project.Owner.Name;
        //            Area area = (Area)project.Owner;
        //            if (area.Owner != null)
        //                owner += " of Organization " + area.Owner.Name;
        //        }
        //        else if (project.Owner is Organization)
        //        {
        //            owner += " of Organization " + project.Owner.Name;
        //        }
        //    }
        //    return owner;
        //}
        //else if (ownerObject is Activity)
        //{
        //    string owner = "Activity: " + ownerObject.Name;
        //    Activity activity = (Activity)ownerObject;
        //    if (activity.Owner != null)
        //    {
        //        if (activity.Owner is Area)
        //        {
        //            owner += " of Area " + activity.Owner.Name;
        //            Area area = (Area)activity.Owner;
        //            if (area.Owner != null)
        //                owner += " of Organization " + area.Owner.Name;
        //        }
        //        else if (activity.Owner is Organization)
        //        {
        //            owner += " of Organization " + activity.Owner.Name;
        //        }
        //        else if (activity.Owner is Project)
        //        {
        //            owner += " of Project " + activity.Owner.Name;
        //            Project project = (Project)activity.Owner;
        //            if (project.Owner != null)
        //            {
        //                if (project.Owner is Area)
        //                {
        //                    owner += " of Area " + project.Owner.Name;
        //                    Area area = (Area)project.Owner;
        //                    if (area.Owner != null)
        //                        owner += " of Organization " + area.Owner.Name;
        //                }
        //                else if (activity.Owner is Organization)
        //                {
        //                    owner += " of Organization " + activity.Owner.Name;
        //                }
        //            }

        //        }
        //    }
        //    return owner;
        //}
        //return type;
    }


    protected void NewKpiButton_Click(object sender, EventArgs e)
    {
        Session["ParentPage"] = "~/Kpi/KpiList.aspx";
        Response.Redirect("~/Kpi/KpiForm.aspx");
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

    private void RemoveKpiFromOldOwner(KPI objKpi)
    {
        //if (objKpi.Owner is Area)
        //{
        //    Area oldArea = (Area)objKpi.Owner;
        //    oldArea.Kpis.Remove(objKpi.ObjectId);
        //}
        //else if (objKpi.Owner is Organization)
        //{
        //    Organization oldOrganization = (Organization)objKpi.Owner;
        //    oldOrganization.Kpis.Remove(objKpi.ObjectId);
        //}
    }


    protected void ListValuesKpi_Click(object sender, EventArgs e)
    {
        LinkButton btnClick = (LinkButton)sender;
        Session["KpiId"] = btnClick.Attributes["data-id"];
        Response.Redirect("~/Kpi/KpiDataEntry.aspx");
    }
    protected void KPIListObjectDataSource_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        if (e.Exception != null)
        {
            SystemMessages.DisplaySystemErrorMessage("Error to get KPI List.");
            e.ExceptionHandled = true;
        }
    }
}