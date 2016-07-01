using Artexacta.App.KPI;
using Artexacta.App.KPI.BLL;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class UserControls_KPI_KpiSummary_KpiMeasurements : System.Web.UI.UserControl
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

    public string Unit
    {
        set
        {
            UnitHiddenField.Value = value;
        }
        get
        {
            return UnitHiddenField.Value;
        }
    }

    public string Currency
    {
        set
        {
            CurrencyHiddenField.Value = value;
        }
        get
        {
            return CurrencyHiddenField.Value;
        }
    }

    public string CurrencyUnit
    {
        set
        {
            CurrencyUnitHiddenField.Value = value;
        }
        get
        {
            return CurrencyUnitHiddenField.Value;
        }
    }


    protected void Page_Load(object sender, EventArgs e)
    {
       // LoadMeasurements();
    }

    protected override void OnPreRender(EventArgs e)
    {
        base.OnPreRender(e);
        
    }


    protected void MeasurementsDataSource_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        if (e.Exception == null)
            return;

        log.Error("Error loading measurements", e.Exception);
        e.ExceptionHandled = true;
    }

    protected void MeasurementsGridView_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (!(e.Row.DataItem is KPIMeasurement))
            return;

        KPIMeasurement measurement = (KPIMeasurement) e.Row.DataItem;
        if (measurement == null)
            return;
        Literal valueLiteral = (Literal)e.Row.FindControl("ValueLiteral");
        string unit = this.Unit;
        if(unit == "TIME")
        {
            try
            {
                KPIDataTime datatime = KPIDataTimeBLL.GetKPIDataTimeFromValue(measurement.Measurement);
                valueLiteral.Text = datatime.TimeDescription;
            }
            catch (Exception ex)
            {
                log.Error("Error getting datatime for measurement value", ex);
            }
        }
        else if(unit == "PERCENT")
        {
            valueLiteral.Text = measurement.Measurement.ToString("#.##") + " %";
        }
        else if(unit == "MONEY")
        {
            valueLiteral.Text = measurement.Measurement.ToString("#.##") + " " + Currency + " " + CurrencyUnit;
        }
        else if (unit == "INT")
        {
            valueLiteral.Text = Convert.ToInt32(measurement.Measurement).ToString();
        }
        else
        {
            valueLiteral.Text = measurement.Measurement.ToString("#.##");
        }

    }
}