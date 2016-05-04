using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using PeopleDSTableAdapters;

namespace Artexacta.App.People.BLL
{
    /// <summary>
    /// Summary description for PeopleBLL
    /// </summary>
    [System.ComponentModel.DataObject]
    public class PeopleBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        PeopleTableAdapter _theAdapter = null;

        protected PeopleTableAdapter theAdapter
        {
            get
            {
                if (_theAdapter == null)
                    _theAdapter = new PeopleTableAdapter();
                return _theAdapter;
            }
        }

        public PeopleBLL()
        {
        }

        private static People FillRecord(PeopleDS.PeopleRow row)
        {
            People theNewRecord = new People(
                row.personID,
                row.id,
                row.name,
                row.organizationID,
                row.IsareaIDNull() ? 0 : row.areaID);

            return theNewRecord;
        }

        public static People GetPeopleById(int personId)
        {
            if (personId <= 0)
                throw new ArgumentException(Resources.Organization.MessageZeroAreaId);

            People theData = null;
            try
            {
                PeopleTableAdapter localAdapter = new PeopleTableAdapter();
                PeopleDS.PeopleDataTable theTable = localAdapter.GetPersonById(personId);
                if (theTable != null && theTable.Rows.Count > 0)
                {
                    PeopleDS.PeopleRow theRow = theTable[0];
                    theData = FillRecord(theRow);
                }
            }
            catch (Exception exc)
            {
                log.Error("Ocurrió un error mientras se obtenía la persona de id: " + personId, exc);
                throw exc;
            }

            return theData;
        }

        public static List<People> GetPeopleForAutocomplete(int organizationId, int areaId, string filter)
        {
            string userName = HttpContext.Current.User.Identity.Name;

            List<People> theList = new List<People>();
            People theData = null;
            try
            {
                PeopleTableAdapter localAdapter = new PeopleTableAdapter();
                PeopleDS.PeopleDataTable theTable = localAdapter.GetPeopleForAutocomplete(userName, organizationId, areaId, filter);
                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (PeopleDS.PeopleRow theRow in theTable)
                    {
                        theData = FillRecord(theRow);
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception exc)
            {
                throw exc;
            }
            return theList;
        }

    }
}