using System;
using System.Collections.Generic;
using System.Data.SqlTypes;
using System.Web;
using log4net;
using Artexacta.App.Configuration;

namespace Artexacta.App.WBT
{
    public class SimmerBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        public SimmerBLL() { }

        private static SimmerClass FillRecord(TestDS.WBTSimmerRow row)
        {
            SimmerClass obj = new SimmerClass();

            // Insert here the code to recover the object from row

            obj.hotStartID = row.hotStartID;

            obj.surveyID = row.surveyID;

            obj.questionnaireID = row.questionnaireID;

            obj.testNumber = row.testNumber;

            obj.tsi = row.IstsiNull() ? TimeSpan.MinValue : row.tsi;

            obj.fsi = row.IsfsiNull() ? 0 : row.fsi;

            obj.T1si = row.IsT1siNull() ? (decimal?)null : row.T1si;

            obj.T2si = row.IsT2siNull() ? (decimal?)null : row.T2si;

            obj.T3si = row.IsT3siNull() ? (decimal?)null : row.T3si;

            obj.T4si = row.IsT4siNull() ? (decimal?)null : row.T4si;

            obj.P1si = row.IsP1siNull() ? (int?)null : row.P1si;

            obj.P2si = row.IsP2siNull() ? (int?)null : row.P2si;

            obj.P3si = row.IsP3siNull() ? (int?)null : row.P3si;

            obj.P4si = row.IsP4siNull() ? (int?)null : row.P4si;

            obj.TESTFIRESTARTS = row.IsTESTFIRESTARTSNull() ? "" : row.TESTFIRESTARTS;

            obj.tsf = row.IstsfNull() ? TimeSpan.MinValue : row.tsf;

            obj.fsf = row.IsfsfNull() ? (int?)null : row.fsf;

            obj.T1sf = row.IsT1sfNull() ? (decimal ?)null : row.T1sf;

            obj.T2sf = row.IsT2sfNull() ? (decimal?)null : row.T2sf;

            obj.T3sf = row.IsT3sfNull() ? (decimal?)null : row.T3sf;

            obj.T4sf = row.IsT4sfNull() ? (decimal?)null : row.T4sf;

            obj.P1sf = row.IsP1sfNull() ? (int?)null : row.P1sf;

            obj.P2sf = row.IsP2sfNull() ? (int?)null : row.P2sf;

            obj.P3sf = row.IsP3sfNull() ? (int?)null : row.P3sf;

            obj.P4sf = row.IsP4sfNull() ? (int?)null : row.P4sf;

            obj.cs = row.IscsNull() ? (decimal?)null : row.cs;

            obj.CO2s = row.IsCO2sNull() ? (decimal?)null : row.CO2s;

            obj.COs = row.IsCOsNull() ? (decimal?)null : row.COs;

            obj.PMs = row.IsPMsNull() ? (decimal?)null : row.PMs;

            obj.Tsd = row.IsTsdNull() ? (decimal?)null : row.Tsd;

            obj.mCO2_s = row.Is_mCO2_sNull() ? (decimal?)null : row._mCO2_s;

            obj.mCO_s = row.Is_mCO_sNull() ? (decimal?)null : row._mCO_s;

            obj.mPM_s = row.Is_mPM_sNull() ? (decimal?)null : row._mPM_s;

            return obj;
        }

        public static List<SimmerClass> getSimmerByTestNumber(string testNumber)
        {
            if (string.IsNullOrWhiteSpace(testNumber))
                throw new ArgumentException("Test Number cannot be empty");

            List<SimmerClass> theList = null;
            try
            {
                TestDSTableAdapters.WBTSimmerTableAdapter adapter = new TestDSTableAdapters.WBTSimmerTableAdapter();
                TestDS.WBTSimmerDataTable theTable = adapter.GetSimmerByTestNumber(testNumber);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    theList = new List<SimmerClass>();
                    foreach (TestDS.WBTSimmerRow theRow in theTable.Rows)
                    {
                        SimmerClass theData = FillRecord(theRow);
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception q)
            {
                log.Error("Error gettint Simmer with test number " + testNumber, q);
                throw q;
            }

            return theList;
        }
    }
}