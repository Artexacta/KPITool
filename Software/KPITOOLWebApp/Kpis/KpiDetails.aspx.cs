using Artexacta.App.FRTWB;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Kpis_KpiDetails : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        LoadKpiData();
    }

    private void LoadKpiData()
    {
        int kpiId = Convert.ToInt32(Session["KpiId"].ToString());
        Kpi kpi = FrtwbSystem.Instance.Kpis[kpiId];
        KpiNameLiteral.Text = kpi.Name;
        Progress.Value = kpi.Progress.ToString();
        //Obtengo aleatoriamente el dato a mostrar
        Random rnd = new Random();
        int caso = rnd.Next(1, 100);
        //Inicializo los valores conocidos
        KpiType.Text = "<div class='col-md-4 col-sm-4'>KPI Type:</div><div class='col-md-8 col-sm-8'>" + kpi.KpiType.Name + "</div>";
        WebServiceId.Text = "<div class='col-md-4 col-sm-4'>Web Service ID:</div><div class='col-md-8 col-sm-8'>SERV-Reliavility</div>";
        ReportingUnit.Text = "<div class='col-md-4 col-sm-4'>Reporting Unit:</div><div class='col-md-8 col-sm-8'>" + kpi.ReportingUnits + "</div>";
        KpiTarget.Text = "<div class='col-md-4 col-sm-4'>KPI Target:</div><div class='col-md-8 col-sm-8'>" + (string.IsNullOrEmpty(kpi.KpiTarget) ? "12 months" : kpi.KpiTarget) + "</div>";

        if (caso <= 50)
        {
            StartingDate.Text = "<div class='col-md-4 col-sm-4'>Starting Date:</div><div class='col-md-8 col-sm-8'>01/15/16</div>";
            MeanTimeGraphic.Visible = true;
            MeanTimeProgress.Visible = true;
        }
        else
        {
            StartingDate.Text = "<div class='col-md-4 col-sm-4'>Starting Date:</div><div class='col-md-8 col-sm-8'>05/17/15</div>";
            RevenueCollectionGraphic.Visible = true;
            RevenueCollectionProgress.Visible = true;
        }
    }
}