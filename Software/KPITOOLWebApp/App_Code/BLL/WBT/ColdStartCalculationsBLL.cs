using System;
using System.Collections.Generic;
using System.Data.SqlTypes;
using System.Web;
using log4net;
using Artexacta.App.Configuration;

namespace Artexacta.App.WBT
{
    public class ColdStartCalculationsBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        public ColdStartCalculationsBLL() { }

        private static ColdStartCalculationsClass FillRecord(TestDS.WBTColdStartCalculationsRow row)
        {
            ColdStartCalculationsClass obj = new ColdStartCalculationsClass();

            // Insert here the code to recover the object from row

            obj.testColdStartCalcID = row.testColdStartCalcID;

            obj.surveyID = row.surveyID;

            obj.questionnaireID = row.questionnaireID;

            obj.testNumber = row.testNumber;

            obj.fcm = row.IsfcmNull() ? (decimal?)null : row.fcm;

            obj.deltacc = row.IsdeltaccNull() ? (decimal?)null : row.deltacc;

            obj.fcd = row.IsfcdNull() ? (decimal?)null : row.fcd;

            obj.wcv = row.IswcvNull() ? (decimal?)null : row.wcv;

            obj.wcr = row.IswcrNull() ? (decimal?)null : row.wcr;

            obj.deltatc = row.IsdeltatcNull() ? (decimal?)null : row.deltatc;

            obj.deltatTc = row.IsdeltatTcNull() ? (decimal?)null : row.deltatTc;

            obj.hc = row.IshcNull() ? (decimal?)null : row.hc;

            obj.rcb = row.IsrcbNull() ? (decimal?)null : row.rcb;

            obj.SCc = row.IsSCcNull() ? (decimal?)null : row.SCc;

            obj.SCTc = row.IsSCTcNull() ? (decimal?)null : row.SCTc;

            obj.SETC = row.IsSETCNull() ? (decimal?)null : row.SETC;

            obj.FPc = row.IsFPcNull() ? (decimal?)null : row.FPc;

            return obj;
        }

        public static List<ColdStartCalculationsClass> getColdStartCalculationsByTestNumber(string testNumber)
        {
            if (string.IsNullOrWhiteSpace(testNumber))
                throw new ArgumentException("Test Number cannot be empty");

            List<ColdStartCalculationsClass> theList = null;
            try
            {
                TestDSTableAdapters.WBTColdStartCalculationsTableAdapter adapter = new TestDSTableAdapters.WBTColdStartCalculationsTableAdapter();
                TestDS.WBTColdStartCalculationsDataTable theTable = adapter.GetColdStartCalculationsByTestNumber(testNumber);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    theList = new List<ColdStartCalculationsClass>();
                    foreach (TestDS.WBTColdStartCalculationsRow theRow in theTable.Rows)
                    {
                        ColdStartCalculationsClass theData = FillRecord(theRow);
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception q)
            {
                log.Error("Error gettint ColdStartCalculations with test number " + testNumber, q);
                throw q;
            }

            return theList;
        }
    }
}