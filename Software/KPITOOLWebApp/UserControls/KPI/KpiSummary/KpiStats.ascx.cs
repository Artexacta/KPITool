using Artexacta.App.KPI;
using Artexacta.App.KPI.BLL;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class UserControls_KPI_KpiSummary_KpiStats : System.Web.UI.UserControl
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

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
    public string CategoryId
    {
        set
        {
            CategoryIdHiddenField.Value = value;
        }
        get
        {
            return CategoryIdHiddenField.Value;
        }
    }

    public string CategoryItemId
    {
        set
        {
            CategoryItemIdHiddenField.Value = value;
        }
        get
        {
            return CategoryItemIdHiddenField.Value;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        //69065091 
    }

    protected override void OnPreRender(EventArgs e)
    {
        try
        {
            KPI objKpi = KPIBLL.GetKPIById(KpiId);
            decimal currentValue = 0;
            decimal lowestValue = 0;
            decimal highestValue = 0;
            decimal averageValue = 0;
            decimal progress = 0;
            decimal trend = 0;
            bool isTime = objKpi.UnitID == "TIME";
            KPIBLL.GetKpiStats(KpiId, CategoryId, CategoryItemId, ref currentValue, ref lowestValue, ref highestValue, ref averageValue, ref progress, ref trend);
            CurrentValueLiteral.Text = currentValue == decimal.MinValue ? "-" : currentValue != 0 ? currentValue.ToString("#.##") : "0";
            LowestValueLiteral.Text = lowestValue == decimal.MinValue ? "-" : lowestValue != 0 ? lowestValue.ToString("#.##") : "0";
            HighestValueLiteral.Text = highestValue == decimal.MinValue ? "-" : highestValue != 0 ? highestValue.ToString("#.##") : "0";
            AverageLiteral.Text = averageValue == decimal.MinValue ? "-" : averageValue != 0 ? averageValue.ToString("#.##") : "0";
            ProgressLiteral.Text = progress == decimal.MinValue ? "-" : progress != 0 ? progress.ToString("#.##") : "0";

            if(trend < 0)
            {
                IconLabel.CssClass = "text-danger";
                IconLabel.Text = "<i class='zmdi zmdi-long-arrow-down zmdi-hc-fw'></i>";
                TrendLiteral.Text = Resources.Kpi.DownLabel;
            }
            else if (trend > 0)
            {
                IconLabel.CssClass = "text-success";
                IconLabel.Text = "<i class='zmdi zmdi-long-arrow-up zmdi-hc-fw'></i>";
                TrendLiteral.Text = Resources.Kpi.UpLabel;
            }
            else
            {
                IconLabel.Text = "-";
                TrendLiteral.Text = "No changes";
                PeriodLiteral.Text = objKpi.ReportingUnitID.ToLower();
                return;
            }

            TrendPercentageLiteral.Text = Math.Abs(trend).ToString() + " %";
            PeriodLiteral.Text = objKpi.ReportingUnitID.ToLower();

        }
        catch (Exception ex)
        {
            log.Error("Error getting stats for KPI", ex);
        }

    }
}