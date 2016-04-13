using System;
using System.Collections.Generic;
using System.Data.SqlTypes;
using System.Web;
using log4net;
using Artexacta.App.Configuration;

namespace Artexacta.App.WBT
{
    public class PhotographsBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        public PhotographsBLL() { }

        private static PhotographsClass FillRecord(TestDS.WBTPhotographsRow row)
        {
            PhotographsClass obj = new PhotographsClass();

            // Insert here the code to recover the object from row

            obj.testPhotoID = row.testPhotoID;

            obj.surveyID = row.surveyID;

            obj.questionnaireID = row.questionnaireID;

            obj.testNumber = row.testNumber;

            obj.stovePhotograph = row.IsstovePhotographNull() ? (int?)null : row.stovePhotograph;

            obj.potPhotograph = row.IspotPhotographNull() ? (int?)null : row.potPhotograph;

            return obj;
        }

        public static List<PhotographsClass> getPhotographsByTestNumber(string testNumber)
        {
            if (string.IsNullOrWhiteSpace(testNumber))
                throw new ArgumentException("Test Number cannot be empty");

            List<PhotographsClass> theList = new List<PhotographsClass>() ;
            try
            {
                TestDSTableAdapters.WBTPhotographsTableAdapter adapter = new TestDSTableAdapters.WBTPhotographsTableAdapter();
                TestDS.WBTPhotographsDataTable theTable = adapter.GetPhotographsByTestNumber(testNumber);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (TestDS.WBTPhotographsRow theRow in theTable.Rows)
                    {
                        PhotographsClass theData = FillRecord(theRow);
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception q)
            {
                log.Error("Error gettint Photographs with test number " + testNumber, q);
                throw q;
            }

            return theList;
        }
    }
}