using log4net;
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
        private static readonly ILog log = LogManager.GetLogger("Standard");

        public KpiMeasurementBLL()
        {
        }

        public static List<KPIMeasurement> GetKpiMeasurementsByKpiId(int kpiId, string categoryId, string categoryItemId, string unit)
        {
            if (kpiId <= 0)
            {
                throw new ArgumentException("KpiId cannot be equals or less than zero");
            }

            KpiMeasurementDSTableAdapters.KpiMeasurementTableAdapter adapter = new KpiMeasurementDSTableAdapters.KpiMeasurementTableAdapter();
            KpiMeasurementDS.KpiMeasurementDataTable table = adapter.GetKpiMeasurements(kpiId, categoryId, categoryItemId);

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

        public static List<KpiChartData> GetKPIMeasurementForChart(int kpiId, string categoryId, string categoryItemId, ref string strategyId, ref decimal target, ref string startingPeriod)
        {
            if (kpiId <= 0)
            {
                throw new ArgumentException("kpiId cannot be equals or less than zero");
            }

            decimal? paramTarget = 0;
            KpiMeasurementDSTableAdapters.KpiMeasurementsForChartTableAdapter adapter = new KpiMeasurementDSTableAdapters.KpiMeasurementsForChartTableAdapter();
            KpiMeasurementDS.KpiMeasurementsForChartDataTable table = adapter.GetKpiMeasurementsForChart(kpiId, categoryId, categoryItemId, ref strategyId, ref paramTarget, ref startingPeriod);
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

        public static List<KPIMeasurements> GetKPIMeasurementCategoriesByKpiId(int kpiId)
        {
            if (kpiId <= 0)
                throw new ArgumentException(Resources.ImportData.ZeroKpiId);

            List<KPIMeasurements> theList = new List<KPIMeasurements>();
            KPIMeasurements theData = null;
            try
            {
                KpiMeasurementDSTableAdapters.KpiMeasurementTableAdapter localAdapter = new KpiMeasurementDSTableAdapters.KpiMeasurementTableAdapter();
                KpiMeasurementDS.KpiMeasurementDataTable theTable = localAdapter.GetKpiMeasurementCategoriesByKpiId(kpiId);
                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (KpiMeasurementDS.KpiMeasurementRow theRow in theTable)
                    {
                        theData = new KPIMeasurements(theRow.measurmentID, theRow.kpiID, theRow.date, theRow.measurement);
                        theData.Detalle = theRow.IsdetalleNull() ? "" : theRow.detalle;
                        theData.Categories = theRow.IscategoriesNull() ? "" : theRow.categories;
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception exc)
            {
                log.Error("Error en GetKPIMeasurementCategoriesByKpiId para kpiId: " + kpiId, exc);
                throw new ArgumentException(Resources.ImportData.GetKPIMeasurements);
            }

            return theList;
        }

        public static List<KPIMeasurements> GetKPIMeasurementCategoriesTimeByKpiId(int kpiId)
        {
            if (kpiId <= 0)
                throw new ArgumentException(Resources.ImportData.ZeroKpiId);

            List<KPIMeasurements> theList = new List<KPIMeasurements>();
            KPIMeasurements theData = null;
            try
            {
                KpiMeasurementDSTableAdapters.KpiMeasurementTableAdapter localAdapter = new KpiMeasurementDSTableAdapters.KpiMeasurementTableAdapter();
                KpiMeasurementDS.KpiMeasurementDataTable theTable = localAdapter.GetKpiMeasurementCategoriesByKpiId(kpiId);
                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (KpiMeasurementDS.KpiMeasurementRow theRow in theTable)
                    {
                        theData = new KPIMeasurements(theRow.measurmentID, theRow.kpiID, theRow.date, theRow.measurement);
                        theData.Detalle = theRow.IsdetalleNull() ? "" : theRow.detalle;
                        theData.DataTime = KPIDataTimeBLL.GetKPIDataTimeFromValue(theData.Measurement);
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception exc)
            {
                log.Error("Error en GetKPIMeasurementCategoriesByKpiId para kpiId: " + kpiId, exc);
                throw new ArgumentException(Resources.ImportData.GetKPIMeasurements);
            }

            return theList;
        }

        public static void InsertKpiMeasuerementImported(int kpiId, List<KPIMeasurements> theList, string type)
        {
            if (kpiId <= 0)
                throw new ArgumentException(Resources.ImportData.ZeroKpiId);

            using (System.Transactions.TransactionScope transaction = new System.Transactions.TransactionScope())
            {
                try
                {
                    KpiMeasurementDSTableAdapters.QueriesTableAdapter queries = new KpiMeasurementDSTableAdapters.QueriesTableAdapter();

                    foreach(KPIMeasurements theData in theList)
                    {
                        if (theData.DataTime != null)
                            theData.Measurement = KPIDataTimeBLL.GetValueFromKPIDataTime(theData.DataTime);

                        if (!string.IsNullOrEmpty(theData.MeasurementIDsToReplace) && type.Equals("R"))
                            queries.DeleteKpiMeasurementByListIds(theData.MeasurementIDsToReplace);

                        int? newData = 0;
                        queries.InsertKpiMeasurement(ref newData, kpiId, theData.Date, theData.Measurement);

                        if (!string.IsNullOrEmpty(theData.Detalle))
                        {
                            string[] itemList = theData.Detalle.Split(',');
                            string[] categoryList = theData.Categories.Split(',');
                            for (int i = 0; i < itemList.Length; i++)
                            {
                                queries.InsertKpiMeasurementCategories(newData.Value, itemList[i].Trim(), categoryList[i].Trim());
                            }
                        }
                    }

                    transaction.Complete();
                }
                catch (Exception exc)
                {
                    log.Error("Error en InsertKpiMeasuerementImported para kpiId: " + kpiId, exc);
                    transaction.Dispose();
                    throw new Exception(Resources.ImportData.InsertMeasurementError);
                }           
            }
        }

        public static bool DeleteKpiMeasuerement(int measurementId)
        {
            if (measurementId <= 0)
                throw new ArgumentException(Resources.ImportData.ZeroMeasurementId);

            try
            {
                KpiMeasurementDSTableAdapters.KpiMeasurementTableAdapter localAdapter = new KpiMeasurementDSTableAdapters.KpiMeasurementTableAdapter();
                localAdapter.DeleteKpiMeasurement(measurementId);
                return true;
            }
            catch (Exception exc)
            {
                log.Error("Error en DeleteKpiMeasuerement para kpiMeasurementId: " + measurementId, exc);
                throw new ArgumentException(Resources.ImportData.DeleteMeasurementError);
            }
        }

        public static string VerifyKPIMeasurements(int kpiId, DateTime date, string detalle, string categories)
        {
            if (kpiId <= 0)
                throw new ArgumentException("El ID del KPI no puede ser cero.");

            string listIds = "";
            try
            {
                KpiMeasurementDSTableAdapters.KpiMeasurementTableAdapter localAdapter = new KpiMeasurementDSTableAdapters.KpiMeasurementTableAdapter();
                KpiMeasurementDS.KpiMeasurementDataTable theTable = localAdapter.VerifyKpiMeasurements(kpiId, date, detalle, categories);
                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (KpiMeasurementDS.KpiMeasurementRow theRow in theTable)
                    {
                        listIds = string.IsNullOrEmpty(listIds) ? theRow.measurmentID.ToString() : (listIds + ";" + theRow.measurmentID.ToString());
                    }
                }
            }
            catch (Exception exc)
            {
                log.Error("Error en VerifyKPIMeasurements para kpiId: " + kpiId + ", date: " + date.ToString() + ", detalle: " + detalle + " y categories: " + categories, exc);
                throw exc;
            }

            return listIds;
        }

    }
}