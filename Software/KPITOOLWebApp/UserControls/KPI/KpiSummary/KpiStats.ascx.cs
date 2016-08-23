using Artexacta.App.Currency;
using Artexacta.App.Currency.BLL;
using Artexacta.App.KPI;
using Artexacta.App.KPI.BLL;
using Artexacta.App.Utilities;
using log4net;
using System;
using System.Collections.Generic;
using System.Globalization;
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
            int firstDayOfWeek = Artexacta.App.Configuration.Configuration.GetFirstDayOfWeek();
            KPIBLL.GetKpiStats(KpiId, CategoryId, CategoryItemId, firstDayOfWeek, ref currentValue, ref lowestValue, ref highestValue, ref averageValue, ref progress, ref trend);

            CurrentValueLiteral.Text = GetValue(currentValue, objKpi.UnitID, objKpi.Currency, objKpi.CurrencyUnitID);
            LowestValueLiteral.Text = GetValue(lowestValue, objKpi.UnitID, objKpi.Currency, objKpi.CurrencyUnitID);
            HighestValueLiteral.Text = GetValue(highestValue, objKpi.UnitID, objKpi.Currency, objKpi.CurrencyUnitID);
            AverageLiteral.Text = GetValue(averageValue, objKpi.UnitID, objKpi.Currency, objKpi.CurrencyUnitID);
            
            ProgressLiteral.Text = progress == decimal.MinValue ? "-" : progress != 0 ? progress.ToString(CultureInfo.InvariantCulture) + "%": "0%";
            
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
                TrendLiteral.Text = Resources.KpiStats.NoChangesLabel;
                
                PeriodLiteral.Text = objKpi.ReportingUnitName.ToLower();
                return;
            }

            TrendPercentageLiteral.Text = Math.Abs(trend).ToString() + " %";
            PeriodLiteral.Text = objKpi.ReportingUnitName.ToLower();

        }
        catch (Exception ex)
        {
            log.Error("Error getting stats for KPI", ex);
        }

        

    }

    private string GetValue(decimal value, string unit, string currency, string currencyUnit)
    {
        if (value == decimal.MinValue)
            return "-";
        if (unit == "TIME")
        {
            try
            {
                KPIDataTime datatime = KPIDataTimeBLL.GetKPIDataTimeFromValue(value);
                return datatime.TimeDescription;
            }
            catch (Exception ex)
            {
                log.Error("Error getting datatime for measurement value", ex);
            }
            return "-";
        }
        else if (unit == "PERCENT")
        {
            return (value != 0 ? value.ToString("#.##") : "0" ) + " %";
        }
        else if (unit == "MONEY")
        {
            string lang = LanguageUtilities.GetLanguageFromContext();
            string name = "";
            try
            {
                CurrencyUnitBLL cuBll = new CurrencyUnitBLL();
                CurrencyBLL cBll = new CurrencyBLL();
                List<Currency> currencies = cBll.GetCurrencys(lang);
                CurrencyUnit cu = cuBll.GetCurrencyUnitsById(lang, currency, currencyUnit);
                Currency selected = null;
                foreach (var item in currencies)
                {
                    if (item.CurrencyID == currency)
                    {
                        selected = item;
                        break;
                    }
                }
                string currencyUnitLabel = currencyUnit == "DOL" ? "" : cu.Name + " " + Resources.KpiStats.OfLabel + " ";
                
                if (selected != null)
                    name = currencyUnitLabel + selected.Name;
                else
                    name = currencyUnitLabel + currency;
            }
            catch (Exception ex)
            {
                log.Error("Error getting currency data", ex);
            }
            return (value != 0 ? value.ToString("#.##") : "0") + " " + name;
        }
        else if (unit == "INT")
        {
            return Convert.ToInt32(value).ToString();
        }
        else
        {
            return (value != 0 ? value.ToString("#.##") : "0");
        }
        
    }
}