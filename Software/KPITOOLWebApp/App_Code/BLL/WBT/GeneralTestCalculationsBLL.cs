using System;
using System.Collections.Generic;
using System.Data.SqlTypes;
using System.Web;
using log4net;
using Artexacta.App.Configuration;

namespace Artexacta.App.WBT
{
    public class GeneralTestCalculationsBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        public GeneralTestCalculationsBLL() { }

        private static GeneralTestCalculationsClass FillRecord(TestDS.WBTGeneralTestCalculationsRow row)
        {
            GeneralTestCalculationsClass obj = new GeneralTestCalculationsClass();

            // Insert here the code to recover the object from row

            obj.genCalcID = row.genCalcID;

            obj.testNumber = row.testNumber;

            obj.defaultGrossCalorificValue = row.IsdefaultGrossCalorificValueNull() ? (decimal?)null : row.defaultGrossCalorificValue;

            obj.defaultNetCalorificValue = row.IsdefaultNetCalorificValueNull() ? (decimal?)null : row.defaultNetCalorificValue;

            obj.charCalorificValue = row.IscharCalorificValueNull() ? (decimal?)null : row.charCalorificValue;

            obj.charCarbonContent = row.IscharCarbonContentNull() ? (decimal?)null : row.charCarbonContent;

            obj.assumedNetCalorificValue = row.IsassumedNetCalorificValueNull() ? (decimal?)null : row.assumedNetCalorificValue;

            obj.gorssCalorificValue = row.IsgorssCalorificValueNull() ? (decimal?)null : row.gorssCalorificValue;

            obj.netCalorificValue = row.IsnetCalorificValueNull() ? (decimal?)null : row.netCalorificValue;

            obj.fuelCarbonContent = row.IsfuelCarbonContentNull() ? (decimal?)null : row.fuelCarbonContent;

            return obj;
        }

        public static GeneralTestCalculationsClass getGeneralTestCalculationsByTestNumber(string testNumber)
        {
            if (string.IsNullOrWhiteSpace(testNumber))
                throw new ArgumentException("Test Number cannot be empty");

            GeneralTestCalculationsClass obj = null;
            try
            {
                TestDSTableAdapters.WBTGeneralTestCalculationsTableAdapter adapter = new TestDSTableAdapters.WBTGeneralTestCalculationsTableAdapter();
                TestDS.WBTGeneralTestCalculationsDataTable theTable = adapter.GetGeneralTestCalculationsByTestNumber(testNumber);

                if (theTable == null || theTable.Rows.Count <= 0)
                    return null;

                obj = FillRecord(theTable[0]);
            }
            catch (Exception q)
            {
                log.Error("Error gettint GeneralTestCalculations with test number " + testNumber, q);
                throw q;
            }

            return obj;
        }
    }
}