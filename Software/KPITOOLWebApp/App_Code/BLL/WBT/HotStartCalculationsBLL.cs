using System;
using System.Collections.Generic;
using System.Data.SqlTypes;
using System.Web;
using log4net;
using Artexacta.App.Configuration;

namespace Artexacta.App.WBT
{
    public class HotStartCalculationsBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        public HotStartCalculationsBLL() { }

        private static HotStartCalculationsClass FillRecord(TestDS.WBTHotStartCalculationsRow row)
        {
            HotStartCalculationsClass obj = new HotStartCalculationsClass();

            // Insert here the code to recover the object from row

            obj.testHotStartCalcID = row.testHotStartCalcID;

            obj.surveyID = row.surveyID;

            obj.questionnaireID = row.questionnaireID;

            obj.testNumber = row.testNumber;

            obj.fhm = row.IsfhmNull() ? (decimal?)null : row.fhm;

            obj.deltach = row.IsdeltachNull() ? (decimal?)null : row.deltach;

            obj.fhd = row.IsfhdNull() ? (decimal?)null : row.fhd;

            obj.whv = row.IswhvNull() ? (decimal?)null : row.whv;

            obj.whr = row.IswhrNull() ? (decimal?)null : row.whr;

            obj.deltath = row.IsdeltachNull() ? (decimal?)null : row.deltath;

            obj.deltatTh = row.IsdeltatThNull() ? (decimal?)null : row.deltatTh;

            obj.hh = row.IshhNull() ? (decimal?)null : row.hh;

            obj.rhb = row.IsrhbNull() ? (decimal?)null : row.rhb;

            obj.SCh = row.IsSChNull() ? (decimal?)null : row.SCh;

            obj.SCTh = row.IsSCThNull() ? (decimal?)null : row.SCTh;

            obj.SETH = row.IsSETHNull() ? (decimal?)null : row.SETH;

            obj.FPh = row.IsFPhNull() ? (decimal?)null : row.FPh;

            return obj;
        }

        public static List<HotStartCalculationsClass> getHotStartCalculationsByTestNumber(string testNumber)
        {
            if (string.IsNullOrWhiteSpace(testNumber))
                throw new ArgumentException("Test Number cannot be empty");

            List<HotStartCalculationsClass> theList = null;
            try
            {
                TestDSTableAdapters.WBTHotStartCalculationsTableAdapter adapter = new TestDSTableAdapters.WBTHotStartCalculationsTableAdapter();
                TestDS.WBTHotStartCalculationsDataTable theTable = adapter.GetHotStartCalculationsByTestNumber(testNumber);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    theList = new List<HotStartCalculationsClass>();
                    foreach (TestDS.WBTHotStartCalculationsRow theRow in theTable.Rows)
                    {
                        HotStartCalculationsClass theData = FillRecord(theRow);
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception q)
            {
                log.Error("Error gettint HotStartCalculations with test number " + testNumber, q);
                throw q;
            }

            return theList;
        }
    }
}