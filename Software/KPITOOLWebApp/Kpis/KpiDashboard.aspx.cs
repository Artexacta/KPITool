using Artexacta.App.FRTWB;
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

    protected void Page_Load(object sender, EventArgs e)
    {
        LoadKpisData();
    }

    private void LoadKpisData()
    {
        KpisRepeater.DataSource = FrtwbSystem.Instance.Kpis.Values;
        KpisRepeater.DataBind();
    }

    protected void KpisRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        Random rnd = new Random();
        int option = rnd.Next(0, 100);
        Literal datas = (Literal)e.Item.FindControl("KpiExtraData");
        Image image = (Image)e.Item.FindControl("Graphic");
        if (option <= 33)
        {
            datas.Text = "<p>Lowest value: 4,000 M TK</p><p>Highest value: 16,000 M TK</p><p>Current value: 9,500 M TK</p><p>Year to date average: 12,567 M TK</p><p>Target: 22,000 M TK</p>";
            image.ImageUrl = "~/Images/graphic04.jpg";
        }
        else if (option > 33 && option <= 66)
        {
            datas.Text = "<p>Lowest value: 2 Days</p><p>Highest value: 1.6 months</p><p>Current value: 1.0 months</p><p>Year to date average: 0.7 months</p><p>Target: 2 months</p>";
            image.ImageUrl = "~/Images/graphic05.jpg";
        }
        else
        {
            datas.Text = "<p>Lowest value: 2 units</p><p>Highest value: 250 units</p><p>Current value: 12.0 units</p><p>Year to date average: 98 units</p><p>Target: 270 units</p>";
            image.ImageUrl = "~/Images/graphic06.jpg";
        }
    }
    protected void KpisRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
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
            SystemMessages.DisplaySystemErrorMessage("Could not complete the requested action");
            return;
        }
        if (e.CommandName == "ViewKpi")
        {
            Session["KpiId"] = kpiId;
            Response.Redirect("~/Kpis/KpiDetails.aspx");
            return;
        }
        if (e.CommandName == "DeleteKpi")
        {
            //Consultamos Owner
            if (FrtwbSystem.Instance.Kpis[kpiId].Owner is Organization)
                FrtwbSystem.Instance.Organizations[FrtwbSystem.Instance.Kpis[kpiId].Owner.ObjectId].Kpis.Remove(kpiId);
            if (FrtwbSystem.Instance.Kpis[kpiId].Owner is Area)
                FrtwbSystem.Instance.Areas[FrtwbSystem.Instance.Kpis[kpiId].Owner.ObjectId].Kpis.Remove(kpiId);
            if (FrtwbSystem.Instance.Kpis[kpiId].Owner is Project)
                FrtwbSystem.Instance.Projects[FrtwbSystem.Instance.Kpis[kpiId].Owner.ObjectId].Kpis.Remove(kpiId);
            if (FrtwbSystem.Instance.Kpis[kpiId].Owner is Activity)
                FrtwbSystem.Instance.Activities[FrtwbSystem.Instance.Kpis[kpiId].Owner.ObjectId].Kpis.Remove(kpiId);
            FrtwbSystem.Instance.Kpis.Remove(kpiId);
            //Refrescamos el Repeater
            KpisRepeater.DataSource = FrtwbSystem.Instance.Kpis.Values;
            KpisRepeater.DataBind();
            return;
        }
    }
}