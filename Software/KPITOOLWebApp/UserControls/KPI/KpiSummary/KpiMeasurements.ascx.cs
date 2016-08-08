using Artexacta.App.KPI;
using Artexacta.App.KPI.BLL;
using Artexacta.App.Utilities.SystemMessages;
using log4net;
using System;
using System.Collections.Generic;
using System.Globalization;
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
        if (!IsPostBack)
        {
            List<KPIMeasurements> theList = new List<KPIMeasurements>();
            try
            {
                if (Unit.Equals("TIME"))
                    theList = KpiMeasurementBLL.GetKPIMeasurementCategoriesTimeByKpiId(KpiId, CategoryId, CategoryItemId);
                else
                    theList = KpiMeasurementBLL.GetKPIMeasurementCategoriesByKpiId(KpiId, CategoryId, CategoryItemId);
            }
            catch (Exception exc)
            {
                SystemMessages.DisplaySystemErrorMessage(exc.Message);
            }

            MeasurementsGridView.DataSource = theList;
            MeasurementsGridView.DataBind();

            if (theList.FindAll(i => !string.IsNullOrEmpty(i.Detalle)).Count > 0)
                MeasurementsGridView.Columns[2].Visible = true;
            else
                MeasurementsGridView.Columns[2].Visible = false;
        }
    }

    protected void MeasurementsGridView_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.DataItem is KPIMeasurements)
        {
            KPIMeasurements theData = (KPIMeasurements)e.Row.DataItem;
            Label valueLabel = (Label)e.Row.FindControl("ValueLabel");
            switch (Unit)
            {
                case "TIME":
                    valueLabel.Text = theData.DataTime.TimeDescription;
                    break;
                case "INT":
                    valueLabel.Text = Convert.ToInt32(theData.Measurement).ToString();
                    break;
                case "PERCENT":
                    valueLabel.Text = theData.Measurement.ToString(CultureInfo.InvariantCulture) + " %";
                    break;
                case "MONEY":
                    valueLabel.Text = theData.Measurement.ToString(CultureInfo.InvariantCulture) + " " + Currency + " " + CurrencyUnit;
                    break;
                default:
                    valueLabel.Text = theData.Measurement.ToString(CultureInfo.InvariantCulture);
                    break;
            }
        }
    }

}