using Artexacta.App.KPI;
using Artexacta.App.KPI.BLL;
using DotNet.Highcharts.Enums;
using DotNet.Highcharts.Helpers;
using DotNet.Highcharts.Options;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class UserControls_KPI_KpiCharts_KpiLineChart : System.Web.UI.UserControl
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    public int KpiId
    {
        set {
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
                log.Error("Error getting kpiId", ex);
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
        try
        {
            BuildChart();
        }
        catch (Exception ex)
        {
            log.Error("Error building chart", ex);
        }
    }

    public void BuildChart()
    {
        int kpiId = KpiId;
        string strategyId = "";
        string startingPeriod = "";
        decimal target = 0;
        int firstDayOfWeek = Artexacta.App.Configuration.Configuration.GetFirstDayOfWeek();

        List<KpiChartData> measurements = KpiMeasurementBLL.GetKPIMeasurementForChart(kpiId, CategoryId, CategoryItemId, firstDayOfWeek, ref strategyId, ref target, ref startingPeriod);
        Dictionary<string, object> standardSerie = new Dictionary<string, object>();
        Dictionary<string, object> targetStandardSerie = new Dictionary<string, object>();

        Dictionary<string, object> sumSerie = new Dictionary<string, object>();
        Dictionary<string, object> targetSumSerie = new Dictionary<string, object>();

        KPI objKpi = KPIBLL.GetKPIById(kpiId);

        bool hasTarget = target != -1;
        bool isSum = strategyId == "SUM";
        bool isTargetUsable = false;
        //bool isSerieUsable = false;

        decimal sumMeasurement = 0;
        decimal sumTarget = 0;
        foreach (var item in measurements)
        {
            //if (!string.IsNullOrEmpty(startingPeriod) && item.Period == startingPeriod)
            //    isSerieUsable = true;
            //if (isSerieUsable)
                standardSerie.Add(item.Period, item.Measurement);
            //else
            //    standardSerie.Add(item.Period, null);

            if (isSum)
            {
                sumMeasurement = sumMeasurement + item.Measurement;
                
                //if (isSerieUsable)
                    sumSerie.Add(item.Period, sumMeasurement);
                //else
                //    sumSerie.Add(item.Period, null);
                if (hasTarget)
                {
                    if (!string.IsNullOrEmpty(startingPeriod) && item.Period == startingPeriod)
                        isTargetUsable = true;

                    if (isTargetUsable)
                    {
                        sumTarget = sumTarget + target;
                        targetSumSerie.Add(item.Period, sumTarget);
                    }
                    else
                        targetSumSerie.Add(item.Period, null);

                }
            }
            if (hasTarget)
            {
                if (!string.IsNullOrEmpty(startingPeriod) && item.Period == startingPeriod)
                    isTargetUsable = true;

                if (isTargetUsable)
                    targetStandardSerie.Add(item.Period, target);
                else
                    targetStandardSerie.Add(item.Period, null);
            }
                
        }
        List<Series> series = new List<Series>();
        series.Add(new Series
        {
            Name = Resources.KpiDetails.ValuesLabel,
            Data = new Data(standardSerie.Values.ToArray<object>())
        });
        if(hasTarget)
        {
            series.Add(new Series
            {
                Name = Resources.KpiDetails.KpiTargetLabel,
                Color = System.Drawing.Color.Red,
                Data = new Data(targetStandardSerie.Values.ToArray<object>())
            });
        }

        DotNet.Highcharts.Highcharts chart = new DotNet.Highcharts.Highcharts(ClientID)
            .InitChart(new Chart(){
                Type =  ChartTypes.Line
            })
            .SetTitle(new Title()
            {
                Text = ""
            })
            .SetXAxis(new XAxis
                        {
                            Categories = standardSerie.Keys.ToArray<string>()
                        })
            .SetSeries(series.ToArray())
            .SetLegend(new Legend()
            {
                Layout = Layouts.Horizontal,
                Align = HorizontalAligns.Center,
                VerticalAlign = VerticalAligns.Bottom,
                BorderWidth = 0
            });
        if(objKpi.UnitID != "TIME")
        {
            //chart.SetTooltip(new Tooltip()
            //{
            //    ValueSuffix = " " + objKpi.uni.ToLower() + "s"

            //});
        }
        else
        {
            chart.SetTooltip(new Tooltip()
            {
                Formatter = "function (){" +
                    "return decimalToYYMMDDhhmm(this.y).toString('" + Resources.DataTime.YearsValueSingle + "','" + Resources.DataTime.YearsValue + "'," +
                    "'" + Resources.DataTime.MonthsValueSingle + "'," +
                    "'" + Resources.DataTime.MonthsValue + "'," +
                    "'" + Resources.DataTime.DaysValueSingle + "'," +
                    "'" + Resources.DataTime.DaysValue + "'," +
                    "'" + Resources.DataTime.HoursValueSingle + "'," +
                    "'" + Resources.DataTime.HoursValue + "'," +
                    "'" + Resources.DataTime.MinutesValueSingle + "'," +
                    "'" + Resources.DataTime.MinutesValue + "');" +
                "}"

            });
        }
        
        ChartLiteral.Text = chart.ToHtmlString();

        if (isSum)
        {
            series = new List<Series>();
            series.Add(new Series
            {
                Name = Resources.KpiDetails.ValuesLabel,
                Data = new Data(sumSerie.Values.ToArray<object>())
            });
            if (hasTarget)
            {
                series.Add(new Series
                {
                    Name = Resources.KpiDetails.KpiTargetLabel,
                    Color = System.Drawing.Color.Red,
                    Data = new Data(targetSumSerie.Values.ToArray<object>())
                });
            }
            chart = new DotNet.Highcharts.Highcharts(ClientID + "_sum")
            .InitChart(new Chart()
            {
                Type = ChartTypes.Line
            })
            .SetTitle(new Title()
            {
                Text = ""
            })
            .SetXAxis(new XAxis
            {
                Categories = standardSerie.Keys.ToArray<string>()
            })
            .SetSeries(series.ToArray())
            .SetLegend(new Legend()
            {
                Layout = Layouts.Horizontal,
                Align = HorizontalAligns.Center,
                VerticalAlign = VerticalAligns.Bottom,
                BorderWidth = 0
            });
            if (objKpi.UnitID != "TIME")
            {
                //chart.SetTooltip(new Tooltip()
                //{
                //    ValueSuffix = " " + objKpi.uni.ToLower() + "s"

                //});
            }
            else
            {
                chart.SetTooltip(new Tooltip()
                {
                    Formatter = "function (){" +
                        "return decimalToYYMMDDhhmm(this.y).toString('" + Resources.DataTime.YearsValueSingle + "','" + Resources.DataTime.YearsValue + "'," +
                        "'" + Resources.DataTime.MonthsValueSingle + "'," +
                        "'" + Resources.DataTime.MonthsValue + "'," +
                        "'" + Resources.DataTime.DaysValueSingle + "'," +
                        "'" + Resources.DataTime.DaysValue + "'," +
                        "'" + Resources.DataTime.HoursValueSingle + "'," +
                        "'" + Resources.DataTime.HoursValue + "'," +
                        "'" + Resources.DataTime.MinutesValueSingle + "'," +
                        "'" + Resources.DataTime.MinutesValue + "');" +
                    "}"

                });
            }
            SumChartLiteral.Text = chart.ToHtmlString();
            SumChartPanel.Visible = true;
        }
    }
}