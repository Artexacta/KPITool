using System;
using System.Collections.Generic;
using System.Data.SqlTypes;
using System.Web;
using log4net;
using Artexacta.App.Configuration;

namespace Artexacta.App.WBT
{
    public class IWAPERFORMANCEMETRICS_GeneralBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        public IWAPERFORMANCEMETRICS_GeneralBLL() { }

        private static IWAPERFORMANCEMETRICS_GeneralClass FillRecord(TestDS.WBTIWAPERFORMANCEMETRICS_GeneralRow row)
        {
            IWAPERFORMANCEMETRICS_GeneralClass obj = new IWAPERFORMANCEMETRICS_GeneralClass();

            // Insert here the code to recover the object from row

            obj.iwaPerfMetricsGeneralID = row.iwaPerfMetricsGeneralID;

            obj.surveyID = row.surveyID;

            obj.questionnaireID = row.questionnaireID;

            obj.testNumber = row.testNumber;

            obj.highPowerThermalEfficiency = row.IshighPowerThermalEfficiencyNull() ? (decimal?)null : row.highPowerThermalEfficiency;

            obj.highPowerThermalEfficiencyTier = row.IshighPowerThermalEfficiencyTierNull() ? (int?)null : row.highPowerThermalEfficiencyTier;

            obj.lowPowerSpecificFuelConsumption = row.IslowPowerSpecificFuelConsumptionNull() ? (decimal?)null : row.lowPowerSpecificFuelConsumption;

            obj.lowPowerSpecificFuelConsumptionTier = row.IslowPowerSpecificFuelConsumptionTierNull() ? (int?)null : row.lowPowerSpecificFuelConsumptionTier;

            return obj;
        }

        public static List<IWAPERFORMANCEMETRICS_GeneralClass> getIWAPERFORMANCEMETRICS_GeneralByTestNumber(string testNumber)
        {
            if (string.IsNullOrWhiteSpace(testNumber))
                throw new ArgumentException("Test Number cannot be empty");

            List<IWAPERFORMANCEMETRICS_GeneralClass> theList = null;
            try
            {
                TestDSTableAdapters.WBTIWAPERFORMANCEMETRICS_GeneralTableAdapter adapter = new TestDSTableAdapters.WBTIWAPERFORMANCEMETRICS_GeneralTableAdapter();
                TestDS.WBTIWAPERFORMANCEMETRICS_GeneralDataTable theTable = adapter.GetIWAPERFORMANCEMETRICS_GeneralByTestNumber(testNumber);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (TestDS.WBTIWAPERFORMANCEMETRICS_GeneralRow theRow in theTable.Rows)
                    {
                        IWAPERFORMANCEMETRICS_GeneralClass theData = FillRecord(theRow);
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception q)
            {
                log.Error("Error gettint IWAPERFORMANCEMETRICS_General with test number " + testNumber, q);
                throw q;
            }

            return theList;
        }
    }
}