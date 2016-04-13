using System;
using System.Collections.Generic;
using System.Data.SqlTypes;
using System.Web;
using log4net;
using Artexacta.App.Configuration;

namespace Artexacta.App.WBT 
{
    public class TestBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        public TestBLL() { }

        private static Test FillRecord(TestDS.WBTTestRow row)
        {
            Test objTest = new Test(row.testIndexID, row.testNumber);
            return objTest;
        }

        public static Test getTestById(int testId) {
            if (testId <= 0)
                throw new ArgumentException("Test ID cannot be negative or 0");

            Test obj = null;
            try
            {
                TestDSTableAdapters.WBTTestTableAdapter adapter = new TestDSTableAdapters.WBTTestTableAdapter();
                TestDS.WBTTestDataTable aTable = adapter.GetTestById(testId);

                if (aTable == null || aTable.Rows.Count <= 0)
                    return null;

                obj = FillRecord(aTable[0]);

            }
            catch (Exception q)
            {
                log.Error("Error gettint Test " + testId + " from the table", q);
                throw q;
            }

            return obj;
        }
    }
}