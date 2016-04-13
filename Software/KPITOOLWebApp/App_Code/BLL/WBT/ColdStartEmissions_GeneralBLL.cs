using System;
using System.Collections.Generic;
using System.Data.SqlTypes;
using System.Web;
using log4net;
using Artexacta.App.Configuration;

namespace Artexacta.App.WBT
{
    public class ColdStartEmissions_GeneralBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        public ColdStartEmissions_GeneralBLL() { }

        private static ColdStartEmissions_GeneralClass FillRecord(TestDS.WBTColdStartEmissions_GeneralRow row)
        {
            ColdStartEmissions_GeneralClass obj = new ColdStartEmissions_GeneralClass();

            // Insert here the code to recover the object from row

            obj.coldStartEmissionsGeneralID = row.coldStartEmissionsGeneralID;

            obj.surveyID = row.surveyID;

            obj.questionnaireID = row.questionnaireID;

            obj.testNumber = row.testNumber;

            obj.Vc = row.IsVcNull() ? 0 : row.Vc;

            obj.CCc = row.IsCCcNull() ? 0 : row.CCc;

            obj.Cc = row.IsCcNull() ? 0 : row.Cc;

            obj.fce = row.IsfceNull() ? 0 : row.fce;

            obj.CBc = row.IsCBcNull() ? 0 : row.CBc;

            obj.tmCO2c = row.IstmCO2cNull() ? 0 : row.tmCO2c;

            obj.tmCOc = row.IstmCOcNull() ? 0 : row.tmCOc;

            obj.tmPMc = row.IstmPMcNull() ? 0 : row.tmPMc;

            return obj;
        }

        public static List<ColdStartEmissions_GeneralClass> getColdStartEmissions_GeneralByTestNumber(string testNumber)
        {
            if (string.IsNullOrWhiteSpace(testNumber))
                throw new ArgumentException("Test Number cannot be empty");

            List<ColdStartEmissions_GeneralClass> theList = null;
            try
            {
                TestDSTableAdapters.WBTColdStartEmissions_GeneralTableAdapter adapter = new TestDSTableAdapters.WBTColdStartEmissions_GeneralTableAdapter();
                TestDS.WBTColdStartEmissions_GeneralDataTable theTable = adapter.GetColdStartEmissions_GeneralByTestNumber(testNumber);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (TestDS.WBTColdStartEmissions_GeneralRow theRow in theTable.Rows)
                    {
                        ColdStartEmissions_GeneralClass theData = FillRecord(theRow);
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception q)
            {
                log.Error("Error gettint ColdStartEmissions_General with test number " + testNumber, q);
                throw q;
            }

            return theList;
        }
    }
}