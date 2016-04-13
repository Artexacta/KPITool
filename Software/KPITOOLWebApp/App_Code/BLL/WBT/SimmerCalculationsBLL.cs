using System;
using System.Collections.Generic;
using System.Data.SqlTypes;
using System.Web;
using log4net;
using Artexacta.App.Configuration;

namespace Artexacta.App.WBT
{
    public class SimmerCalculationsBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        public SimmerCalculationsBLL() { }

        private static SimmerCalculationsClass FillRecord(TestDS.WBTSimmerCalculationsRow row)
        {
            SimmerCalculationsClass obj = new SimmerCalculationsClass();

            // Insert here the code to recover the object from row

            obj.testSimmerCalcID = row.testSimmerCalcID;

            obj.surveyID = row.surveyID;

            obj.questionnaireID = row.questionnaireID;

            obj.testNumber = row.testNumber;

            obj.fsm = row.IsfsmNull() ? (decimal?)null : row.fsm;

            obj.deltacs = row.IsdeltacsNull() ? (decimal?)null : row.deltacs;

            obj.fsd = row.IsfsdNull() ? (decimal?)null : row.fsd;

            obj.wsv = row.IswsvNull() ? (decimal?)null : row.wsv;

            obj.wsr = row.IswsrNull() ? (decimal?)null : row.wsr;

            obj.deltats = row.IsdeltatsNull() ? (decimal?)null : row.deltats;

            obj.hs = row.IshsNull() ? (decimal?)null : row.hs;

            obj.rsb = row.IsrsbNull() ? (decimal?)null : row.rsb;

            obj.SCs = row.IsSCsNull() ? (decimal?)null : row.SCs;

            obj.FPs = row.IsFPsNull() ? (decimal?)null : row.FPs;

            obj.TDR = row.IsTDRNull() ? (decimal?)null : row.TDR;

            obj.SES = row.IsSESNull() ? (decimal?)null : row.SES;

            obj.BF = row.IsBFNull() ? (decimal?)null : row.BF;

            obj.BE = row.IsBENull() ? (decimal?)null : row.BE;

            return obj;
        }

        public static List<SimmerCalculationsClass> getSimmerCalculationsByTestNumber(string testNumber)
        {
            if (string.IsNullOrWhiteSpace(testNumber))
                throw new ArgumentException("Test Number cannot be empty");

            List<SimmerCalculationsClass> theList = null;
            try
            {
                TestDSTableAdapters.WBTSimmerCalculationsTableAdapter adapter = new TestDSTableAdapters.WBTSimmerCalculationsTableAdapter();
                TestDS.WBTSimmerCalculationsDataTable theTable = adapter.GetSimmerCalculationsByTestNumber(testNumber);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    theList = new List<SimmerCalculationsClass>();
                    foreach (TestDS.WBTSimmerCalculationsRow theRow in theTable.Rows)
                    {
                        SimmerCalculationsClass theData = FillRecord(theRow);
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception q)
            {
                log.Error("Error gettint SimmerCalculations with test number " + testNumber, q);
                throw q;
            }

            return theList;
        }
    }
}