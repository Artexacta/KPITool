using System;
using System.Collections.Generic;
using System.Data.SqlTypes;
using System.Web;
using log4net;
using Artexacta.App.Configuration;

namespace Artexacta.App.WBT
{
    public class SimmerEmissions_GeneralBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        public SimmerEmissions_GeneralBLL() { }

        private static SimmerEmissions_GeneralClass FillRecord(TestDS.WBTSimmerEmissions_GeneralRow row)
        {
            SimmerEmissions_GeneralClass obj = new SimmerEmissions_GeneralClass();

            // Insert here the code to recover the object from row

            obj.simmerEmissionsGeneralID = row.simmerEmissionsGeneralID;

            obj.surveyID = row.surveyID;

            obj.questionnaireID = row.questionnaireID;

            obj.testNumber = row.testNumber;

            obj.Vs = row.IsVsNull() ? (decimal?)null : row.Vs;

            obj.CCs = row.IsCCsNull() ? (decimal?)null : row.CCs;

            obj.Cs = row.IsCsNull() ? (decimal?)null : row.Cs;

            obj.fse = row.IsfseNull() ? (decimal?)null : row.fse;

            obj.CBs = row.IsCBsNull() ? (decimal?)null : row.CBs;

            obj.tmCO2s = row.IstmCO2sNull() ? (decimal?)null : row.tmCO2s;

            obj.tmCOs = row.IstmCOsNull() ? (decimal?)null : row.tmCOs;

            obj.tmPMs = row.IstmPMsNull() ? (decimal?)null : row.tmPMs;

            return obj;
        }

        public static List<SimmerEmissions_GeneralClass> getSimmerEmissions_GeneralByTestNumber(string testNumber)
        {
            if (string.IsNullOrWhiteSpace(testNumber))
                throw new ArgumentException("Test Number cannot be empty");

            List<SimmerEmissions_GeneralClass> theList = null;
            try
            {
                TestDSTableAdapters.WBTSimmerEmissions_GeneralTableAdapter adapter = new TestDSTableAdapters.WBTSimmerEmissions_GeneralTableAdapter();
                TestDS.WBTSimmerEmissions_GeneralDataTable theTable = adapter.GetSimmerEmissions_GeneralByTestNumber(testNumber);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (TestDS.WBTSimmerEmissions_GeneralRow theRow in theTable.Rows)
                    {
                        SimmerEmissions_GeneralClass theData = FillRecord(theRow);
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception q)
            {
                log.Error("Error gettint SimmerEmissions_General with test number " + testNumber, q);
                throw q;
            }

            return theList;
        }
    }
}