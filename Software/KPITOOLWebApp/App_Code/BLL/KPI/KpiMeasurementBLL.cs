using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.KPI.BLL
{
    /// <summary>
    /// Summary description for KpiMeasurementBLL
    /// </summary>
    public class KpiMeasurementBLL
    {
        public KpiMeasurementBLL()
        {
            
        }

        public static List<KPIMeasurement> GetKpiMeasurementsByKpiId(int kpiId)
        {
            if (kpiId <= 0)
            {
                throw new ArgumentException("KpiId cannot be equals or less than zero");
            }

            KpiMeasurementDSTableAdapters.KpiMeasurementTableAdapter adapter = new KpiMeasurementDSTableAdapters.KpiMeasurementTableAdapter();
            KpiMeasurementDS.KpiMeasurementDataTable table = adapter.GetKpiMeasurements(kpiId);

            List<KPIMeasurement> list = new List<KPIMeasurement>();
            foreach (var row in table)
            {
                list.Add(new KPIMeasurement()
                {
                    KPIID = row.kpiID,
                    Date = row.date,
                    Measurement = row.measurement
                });
            }

            return list;
        }

        public static List<KPIMeasurement> GetKpiMeasurementsByKpiOwner(int ownerId, string ownerType, string userName, ref decimal maxValue, ref decimal minValue)
        {
            if (ownerId <= 0)
            {
                throw new ArgumentException("ownerId cannot be equals or less than zero");
            }
            if (string.IsNullOrEmpty(ownerType))
            {
                throw new ArgumentException("ownerType cannot be null or empty");
            }
            if (string.IsNullOrEmpty(userName))
                throw new ArgumentException("userName cannot be null or empty");

            decimal? max = 0;
            decimal? min = 0;
            KpiMeasurementDSTableAdapters.KpiMeasurementTableAdapter adapter = new KpiMeasurementDSTableAdapters.KpiMeasurementTableAdapter();
            KpiMeasurementDS.KpiMeasurementDataTable table = adapter.GetKpiMeasurementsByKpiOwner(ownerId, ownerType, userName, ref min, ref max);
            maxValue = max == null ? 0 : max.Value;
            minValue = min == null ? 0 : min.Value;

            List<KPIMeasurement> list = new List<KPIMeasurement>();
            foreach (var row in table)
            {
                list.Add(new KPIMeasurement()
                {
                    KPIID = row.kpiID,
                    Date = row.date,
                    Measurement = row.measurement
                });
            }

            return list;
        }

        public static List<KpiChartData> GetKPIMeasurementForChart(int kpiId, int categoryId, int categoryItemId, ref string strategyId, ref decimal target)
        {
            if (kpiId <= 0)
            {
                throw new ArgumentException("kpiId cannot be equals or less than zero");
            }

            decimal? paramTarget = 0;
            KpiMeasurementDSTableAdapters.KpiMeasurementsForChartTableAdapter adapter = new KpiMeasurementDSTableAdapters.KpiMeasurementsForChartTableAdapter();
            KpiMeasurementDS.KpiMeasurementsForChartDataTable table = adapter.GetKpiMeasurementsForChart(kpiId, categoryId, categoryItemId, ref strategyId, ref paramTarget);
            target = paramTarget == null ? 0 :  paramTarget.Value;

            List<KpiChartData> list = new List<KpiChartData>();
            foreach (var row in table)
            {
                list.Add(new KpiChartData()
                {
                    Period = row.period,
                    Measurement = row.measurement
                });
            }
            return list;
        }
    }
}