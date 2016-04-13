using System;
using System.Collections.Generic;
using System.Data.SqlTypes;
using System.Web;
using log4net;
using Artexacta.App.Configuration;

namespace Artexacta.App.WBT
{
    public class ColdStartBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        public ColdStartBLL() { }

        private static ColdStartClass FillRecord(TestDS.WBTColdStartRow row)
        {
            ColdStartClass obj = new ColdStartClass();

            // Insert here the code to recover the object from row

            obj.coldStartID = row.coldStartID;

            obj.surveyID = row.surveyID;

            obj.questionnaireID = row.questionnaireID;

            obj.testNumber = row.testNumber;

            obj.tci = row.IstciNull() ? (TimeSpan?)null : row.tci;

            obj.fci = row.IsfciNull() ? (int?)null : row.fci;

            obj.T1ci = row.IsT1ciNull() ? (decimal?)null : row.T1ci;

            obj.T2ci = row.IsT2ciNull() ? (decimal?)null : row.T2ci;

            obj.T3ci = row.IsT3ciNull() ? (decimal?)null : row.T3ci;

            obj.T4ci = row.IsT4ciNull() ? (decimal?)null : row.T4ci;

            obj.P1ci = row.IsP1ciNull() ? (int?)null : row.P1ci;

            obj.P2ci = row.IsP2ciNull() ? (int?)null : row.P2ci;

            obj.P3ci = row.IsP3ciNull() ? (int?)null : row.P3ci;

            obj.P4ci = row.IsP4ciNull() ? (int?)null : row.P4ci;

            obj.TESTFIRESTARTC = row.IsTESTFIRESTARTCNull() ? "" : row.TESTFIRESTARTC;

            obj.tcf = row.IstcfNull() ? (TimeSpan?)null : row.tcf;

            obj.fcf = row.IsfcfNull() ? (int?)null : row.fcf;

            obj.T1cf = row.IsT1cfNull() ? (decimal?)null : row.T1cf;

            obj.T2cf = row.IsT2cfNull() ? (decimal?)null : row.T2cf;

            obj.T3cf = row.IsT3cfNull() ? (decimal?)null : row.T3cf;

            obj.T4cf = row.IsT4cfNull() ? (decimal?)null : row.T4cf;

            obj.P1cf = row.IsP1cfNull() ? (int?)null : row.P1cf;

            obj.P2cf = row.IsP2cfNull() ? (int?)null : row.P2cf;

            obj.P3cf = row.IsP3cfNull() ? (int?)null : row.P3cf;

            obj.P4cf = row.IsP4cfNull() ? (int?)null : row.P4cf;

            obj.cc = row.IsccNull() ? (decimal?)null : row.cc;

            obj.CO2c = row.IsCO2cNull() ? (decimal?)null : row.CO2c;

            obj.COc = row.IsCOcNull() ? (decimal?)null : row.COc;

            obj.PMc = row.IsPMcNull() ? (decimal?)null : row.PMc;

            obj.Tcd = row.IsTcdNull() ? (decimal?)null : row.Tcd;

            obj.mCO2_c = row.Is_mCO2_cNull() ? (decimal?)null : row._mCO2_c;

            obj.mCO_c = row.Is_mCO_cNull() ? (decimal?)null : row._mCO_c;

            obj.mPM_c = row.Is_mPM_cNull() ? (decimal?)null : row._mPM_c;

            return obj;
        }

        public static List<ColdStartClass> getColdStartByTestNumber(string testNumber)
        {
            if (string.IsNullOrWhiteSpace(testNumber))
                throw new ArgumentException("Test Number cannot be empty");

            List<ColdStartClass> theList = null;
            try
            {
                TestDSTableAdapters.WBTColdStartTableAdapter adapter = new TestDSTableAdapters.WBTColdStartTableAdapter();
                TestDS.WBTColdStartDataTable theTable = adapter.GetColdStartByTestNumber(testNumber);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    theList = new List<ColdStartClass>();
                    foreach (TestDS.WBTColdStartRow theRow in theTable.Rows)
                    {
                        ColdStartClass theData = FillRecord(theRow);
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception q)
            {
                log.Error("Error gettint ColdStart with test number " + testNumber, q);
                throw q;
            }

            return theList;
        }
    }
}