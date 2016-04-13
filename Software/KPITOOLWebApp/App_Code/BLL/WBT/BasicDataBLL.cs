using System;
using System.Collections.Generic;
using System.Data.SqlTypes;
using System.Web;
using log4net;
using Artexacta.App.Configuration;

namespace Artexacta.App.WBT
{
    public class BasicDataBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        public BasicDataBLL() { }

        private static BasicDataClass FillRecord(TestDS.WBTBasicDataRow row)
        {
            BasicDataClass obj = new BasicDataClass();

            // Insert here the code to recover the object from row
            obj.basicDataID = row.basicDataID;

            obj.surveyID = row.surveyID;

            obj.questionnaireID = row.questionnaireID;

            obj.testNumber = row.testNumber;

            obj.testerName = row.testerName;

            obj.testDate = row.IstestDateNull() ? (DateTime?)null : row.testDate;

            obj.airTemperature = row.IsairTemperatureNull() ? (decimal?)null : row.airTemperature;

            obj.windConditions = row.windConditions;

            obj.fuelDimensions = row.fuelDimensions;

            obj.MC = row.IsMCNull() ? (decimal?)null : row.MC;

            obj.P1 = row.IsP1Null() ? (int?)null : row.P1;

            obj.P2 = row.IsP2Null() ? (int?)null : row.P2;

            obj.P3 = row.IsP3Null() ? (int?)null : row.P3;

            obj.P4 = row.IsP4Null() ? (int?)null : row.P4;

            obj.k = row.IskNull() ? (int?)null : row.k;

            obj.CO2_B = row.Is_CO2_BNull() ? (decimal?)null : row._CO2_B;

            obj.CO_B = row.Is_CO_BNull() ? (decimal?)null : row._CO_B;

            obj.PM_B = row.Is_PM_BNull() ? (decimal?)null : row._PM_B;

            obj.testNotes = row.testNotes;

            obj.NOTESHPCST = row.NOTESHPCST;

            obj.NOTESHPHST = row.NOTESHPHST;

            obj.NOTESLPST = row.NOTESLPST;


            return obj;
        }

        public static List<BasicDataClass> getBasicDataByTestNumber(string testNumber)
        {
            if (string.IsNullOrWhiteSpace(testNumber))
                throw new ArgumentException("Test Number cannot be empty");

            List<BasicDataClass> theList = new List<BasicDataClass>();
            try
            {
                TestDSTableAdapters.WBTBasicDataTableAdapter adapter = new TestDSTableAdapters.WBTBasicDataTableAdapter();
                TestDS.WBTBasicDataDataTable theTable = adapter.GetBasicDataByTestNumber(testNumber);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (TestDS.WBTBasicDataRow theRow in theTable.Rows)
                    {
                        BasicDataClass theData = FillRecord(theRow);
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception q)
            {
                log.Error("Error gettint BasicData with test number " + testNumber, q);
                throw q;
            }

            return theList;
        }
    }
}