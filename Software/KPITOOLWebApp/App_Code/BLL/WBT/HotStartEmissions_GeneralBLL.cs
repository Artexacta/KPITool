using System;
using System.Collections.Generic;
using System.Data.SqlTypes;
using System.Web;
using log4net;
using Artexacta.App.Configuration;

namespace Artexacta.App.WBT
{
    public class HotStartEmissions_GeneralBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        public HotStartEmissions_GeneralBLL() { }

        private static HotStartEmissions_GeneralClass FillRecord(TestDS.WBTHotStartEmissions_GeneralRow row)
        {
            HotStartEmissions_GeneralClass obj = new HotStartEmissions_GeneralClass();

            // Insert here the code to recover the object from row

            obj.hotStartEmissionsGeneralID = row.hotStartEmissionsGeneralID;

            obj.surveyID = row.surveyID;

            obj.questionnaireID = row.questionnaireID;

            obj.testNumber = row.testNumber;

            obj.Vh = row.IsVhNull() ? (decimal?)null : row.Vh;

            obj.CCh = row.IsCChNull() ? (decimal?)null : row.CCh;

            obj.Ch = row.IsChNull() ? (decimal?)null : row.Ch;

            obj.fhe = row.IsfheNull() ? (decimal?)null : row.fhe;

            obj.CBh = row.IsCBhNull() ? (decimal?)null : row.CBh;

            obj.tmCO2h = row.IstmCO2hNull() ? (decimal?)null : row.tmCO2h;

            obj.tmCOh = row.IstmCOhNull() ? (decimal?)null : row.tmCOh;

            obj.tmPMh = row.IstmPMhNull() ? (decimal?)null : row.tmPMh;

            return obj;
        }

        public static List<HotStartEmissions_GeneralClass> getHotStartEmissions_GeneralByTestNumber(string testNumber)
        {
            if (string.IsNullOrWhiteSpace(testNumber))
                throw new ArgumentException("Test Number cannot be empty");

            List<HotStartEmissions_GeneralClass> theList = null;
            try
            {
                TestDSTableAdapters.WBTHotStartEmissions_GeneralTableAdapter adapter = new TestDSTableAdapters.WBTHotStartEmissions_GeneralTableAdapter();
                TestDS.WBTHotStartEmissions_GeneralDataTable theTable = adapter.GetHotStartEmissions_GeneralByTestNumber(testNumber);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (TestDS.WBTHotStartEmissions_GeneralRow theRow in theTable.Rows)
                    {
                        HotStartEmissions_GeneralClass theData = FillRecord(theRow);
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception q)
            {
                log.Error("Error gettint HotStartEmissions_General with test number " + testNumber, q);
                throw q;
            }

            return theList;
        }
    }
}