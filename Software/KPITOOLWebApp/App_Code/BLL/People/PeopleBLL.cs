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
            theNewRecord.OrganizationName = row.organizationName;
            theNewRecord.AreaName = row.IsareaNameNull() ? "" : row.areaName;
            theNewRecord.NumberOfKpis = row.IsnumberKPIsNull() ? 0 : row.numberKPIs;
            theNewRecord.IsOwner = row.IsisOwnerNull() ? false : Convert.ToBoolean(row.isOwner);
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

        public static List<People> GetPeopleBySearch(string whereClause)
        {
            if (string.IsNullOrEmpty(whereClause))
                whereClause = "1=1";

            string userName = HttpContext.Current.User.Identity.Name;

            List<People> theList = new List<People>();
            People theData = null;
            try
            {
                PeopleTableAdapter localAdapter = new PeopleTableAdapter();
                PeopleDS.PeopleDataTable theTable = localAdapter.GetPeopleBySearch(userName, whereClause);

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
                log.Error("Error to obtain the people by search.");
                throw exc;
            }

            return theList;
        }

        public List<People> GetPeopleByOrganization(int organizationId)
        {
            if (organizationId <= 0)
                throw new ArgumentException(Resources.Organization.MessageZeroOrganizationId);

            string userName = HttpContext.Current.User.Identity.Name;
            List<People> theList = new List<People>();
            People theData = null;
            try
            {
                PeopleDS.PeopleDataTable theTable = theAdapter.GetPersonByOrganization(organizationId, userName);
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
                log.Error("Error en GetPeopleByOrganization para organizationId: " + organizationId.ToString() + " y userName: " + userName, exc);
                throw new ArgumentException(Resources.DataDetails.MessageErrorPeopleByOrganization);
            }

            return theList;
        }

        public static int InsertPeople(People theClass)
        {
            if (theClass.OrganizationId <= 0)
                throw new ArgumentException(Resources.Organization.MessageZeroOrganizationId);

            PeopleTableAdapter localAdapter = new PeopleTableAdapter();

            int? personId = 0;
            string userName = HttpContext.Current.User.Identity.Name;

            try
            {
                localAdapter.InsertPerson(userName, theClass.OrganizationId, theClass.AreaId, theClass.Name, theClass.Id, ref personId);
            }
            catch (Exception exc)
            {
                log.Error(Resources.People.MessageErrorCreatePerson, exc);
                throw new Exception(Resources.People.MessageErrorCreatePerson);
            }

            if ((int)personId <= 0)
            {
                log.Error(Resources.People.MessageErrorCreatePerson);
                throw new ArgumentException(Resources.People.MessageErrorCreatePerson);
            }

            return (int)personId;
        }

        public static void UpdatePeople(People theClass)
        {
            if (theClass.OrganizationId <= 0)
                throw new ArgumentException(Resources.Organization.MessageZeroOrganizationId);

            PeopleTableAdapter localAdapter = new PeopleTableAdapter();

            try
            {
                localAdapter.UpdatePerson(theClass.PersonId, theClass.Id, theClass.Name, theClass.OrganizationId, theClass.AreaId);
            }
            catch (Exception exc)
            {
                log.Error(Resources.People.MessageErrorUpdatePerson, exc);
                throw new Exception(Resources.People.MessageErrorUpdatePerson);
            }
        }

        public static void DeletePeople(int personId)
        {
            if (personId <= 0)
                throw new ArgumentException(Resources.People.MessageIdPersonZero);

            PeopleTableAdapter localAdapter = new PeopleTableAdapter();
            string userName = HttpContext.Current.User.Identity.Name;

            try
            {
                localAdapter.DeletePerson(personId,userName);
            }
            catch (Exception exc)
            {
                log.Error(Resources.People.MessageErrorDeletePerson, exc);
                throw new Exception(Resources.People.MessageErrorDeletePerson);
            }
        }

        public static void DeletePermanently(int personId)
        {
            PeopleTableAdapter adapter = new PeopleTableAdapter();

            try
            {
                adapter.DeletePermanentlyPerson(personId);
            }
            catch (Exception ex)
            {
                log.Error(Resources.People.MessageErrorDeletePerson, ex);
                throw new Exception(Resources.People.MessageErrorDeletePerson);
            }
        }
    }
}