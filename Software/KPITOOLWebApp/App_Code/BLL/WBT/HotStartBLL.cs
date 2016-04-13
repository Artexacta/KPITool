using System;
using System.Collections.Generic;
using System.Data.SqlTypes;
using System.Web;
using log4net;
using Artexacta.App.Configuration;

namespace Artexacta.App.WBT
{
    public class HotStartBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        public HotStartBLL() { }

        private static HotStartClass FillRecord(TestDS.WBTHotStartRow row)
        {
            HotStartClass obj = new HotStartClass();

            // Insert here the code to recover the object from row


            obj.testSimmerID = row.testSimmerID;

            obj.surveyID = row.surveyID;

            obj.questionnaireID = row.questionnaireID;

            obj.testNumber = row.testNumber;

            obj.HIGHPOW = row.IsHIGHPOWNull() ? (bool?)null : row.HIGHPOW;

            obj.thi = row.IsthiNull() ? (TimeSpan?)null : row.thi;

            obj.fhi = row.IsfhiNull() ? (int?)null : row.fhi;

            obj.T1hi = row.IsT1hiNull() ? (decimal?)null : row.T1hi;

            obj.T2hi = row.IsT2hiNull() ? (decimal?)null : row.T2hi;

            obj.T3hi = row.IsT3hiNull() ? (decimal?)null : row.T3hi;

            obj.T4hi = row.IsT4hiNull() ? (decimal?)null : row.T4hi;

            obj.P1hi = row.IsP1hiNull() ? (int?)null : row.P1hi;

            obj.P2hi = row.IsP2hiNull() ? (int?)null : row.P2hi;

            obj.P3hi = row.IsP3hiNull() ? (int?)null : row.P3hi;

            obj.P4hi = row.IsP4hiNull() ? (int?)null : row.P4hi;

            obj.TESTFIRESTARTH = row.IsTESTFIRESTARTHNull() ? "" : row.TESTFIRESTARTH;

            obj.thf = row.IsthfNull() ? (TimeSpan?)null : row.thf;

            obj.fhf = row.IsfhfNull() ? (int?)null : row.fhf;

            obj.T1hf = row.IsT1hfNull() ? (decimal?)null : row.T1hf;

            obj.T2hf = row.IsT2hfNull() ? (decimal?)null : row.T2hf;

            obj.T3hf = row.IsT3hfNull() ? (decimal?)null : row.T3hf;

            obj.T4hf = row.IsT4hfNull() ? (decimal?)null : row.T4hf;

            obj.P1hf = row.IsP1hfNull() ? (int?)null : row.P1hf;

            obj.P2hf = row.IsP2hfNull() ? (int?)null : row.P2hf;

            obj.P3hf = row.IsP3hfNull() ? (int?)null : row.P3hf;

            obj.P4hf = row.IsP4hfNull() ? (int?)null : row.P4hf;

            obj.ch = row.IschNull() ? (decimal?)null : row.ch;

            obj.CO2h = row.IsCO2hNull() ? (decimal?)null : row.CO2h;

            obj.COh = row.IsCOhNull() ? (decimal?)null : row.COh;

            obj.PMh = row.IsPMhNull() ? (decimal?)null : row.PMh;

            obj.Thd = row.IsThdNull() ? (decimal?)null : row.Thd;

            obj.mCO2_h = row.Is_mCO2_hNull() ? (decimal?)null : row._mCO2_h;

            obj.mCO_h = row.Is_mCO_hNull() ? (decimal?)null : row._mCO_h;

            obj.mPM_h = row.Is_mPM_hNull() ? (decimal?)null : row._mPM_h;

            return obj;
        }

        public static List<HotStartClass> getHotStartByTestNumber(string testNumber)
        {
            if (string.IsNullOrWhiteSpace(testNumber))
                throw new ArgumentException("Test Number cannot be empty");

            List<HotStartClass> theList = null;
            try
            {
                TestDSTableAdapters.WBTHotStartTableAdapter adapter = new TestDSTableAdapters.WBTHotStartTableAdapter();
                TestDS.WBTHotStartDataTable theTable = adapter.GetHotStartByTestNumber(testNumber);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    theList = new List<HotStartClass>();
                    foreach (TestDS.WBTHotStartRow theRow in theTable.Rows)
                    {
                        HotStartClass theData = FillRecord(theRow);
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception q)
            {
                log.Error("Error gettint HotStart with test number " + testNumber, q);
                throw q;
            }

            return theList;
        }
    }
}