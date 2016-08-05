using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Artexacta.App.Utilities.Quantity;
using log4net;
using OrganizationDSTableAdapters;

namespace Artexacta.App.Organization.BLL
{
    /// <summary>
    /// Summary description for OrganizationBLL
    /// </summary>
    /// 

    [System.ComponentModel.DataObject]
    public class OrganizationBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        OrganizationTableAdapter _theAdapter = null;

        protected OrganizationTableAdapter theAdapter
        {
            get
            {
                if (_theAdapter == null)
                    _theAdapter = new OrganizationTableAdapter();
                return _theAdapter;
            }
        }

        public OrganizationBLL()
        {
        }

        private static Organization FillRecord(OrganizationDS.OrganizationRow row)
        {
            Organization theNewRecord = new Organization(
                row.organizationID,
                row.name);

            return theNewRecord;
        }

        public static Organization GetOrganizationById(int organizationId)
        {
            if (organizationId <= 0)
                throw new ArgumentException(Resources.Organization.MessageZeroOrganizationId);

            Organization theData = null;
            try
            {
                OrganizationTableAdapter localAdapter = new OrganizationTableAdapter();
                OrganizationDS.OrganizationDataTable theTable = localAdapter.GetOrganizationById(organizationId);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    OrganizationDS.OrganizationRow theRow = theTable[0];
                    theData = FillRecord(theRow);
                }
            }
            catch (Exception exc)
            {
                log.Error("Ocurrió un error mientras se obtenía la organización de id =" + organizationId.ToString(), exc);
                throw new Exception(Resources.Organization.MessageErrorObtainOrganization);
            }

            return theData;
        }

        public static List<Organization> GetOrganizationsByUser(string whereClause)
        {
            List<Organization> theList = new List<Organization>();
            Organization theData = null;

            string userName = HttpContext.Current.User.Identity.Name;

            try
            {
                OrganizationTableAdapter localAdapter = new OrganizationTableAdapter();
                OrganizationDS.OrganizationDataTable theTable = localAdapter.GetOrganizationsByUser(userName, whereClause);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (OrganizationDS.OrganizationRow theRow in theTable)
                    {
                        theData = FillRecord(theRow);
                        theData.IsOwner = theRow.isOwner;
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception exc)
            {
                log.Error(Resources.Organization.MessageOrganizationList + whereClause, exc);
                throw new Exception(Resources.Organization.MessageOrganizationList);
            }

            return theList;
        }

        public Organization GetOrganizationByName(string name)
        {
            if (string.IsNullOrEmpty(name))
                throw new ArgumentException(Resources.Organization.MessageEmptyName);

            Organization theData = null;
            string userName = HttpContext.Current.User.Identity.Name;

            try
            {
                OrganizationDS.OrganizationDataTable theTable = theAdapter.GetOrganizationByName(userName, name);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    OrganizationDS.OrganizationRow theRow = theTable[0];
                    theData = FillRecord(theRow);
                }
            }
            catch (Exception exc)
            {
                log.Error("Ocurrió un error mientras se obtenía la organización de nombre: " + name, exc);
                throw new Exception(Resources.Organization.MessageErrorObtainOrganization);
            }

            return theData;
        }

        public static int InsertOrganization(string name)
        {
            if (string.IsNullOrEmpty(name))
                throw new ArgumentException(Resources.Organization.MessageEmptyName);

            OrganizationTableAdapter localAdapter = new OrganizationTableAdapter();

            int? organizacionId = 0;
            string userName = HttpContext.Current.User.Identity.Name;

            try
            {
                localAdapter.InsertOrganization(userName, name, ref organizacionId);
            }
            catch (Exception exc)
            {
                log.Error(Resources.Organization.MessageErrorCreate, exc);
                throw exc;
            }

            if ((int)organizacionId <= 0)
            {
                log.Error(Resources.Organization.MessageErrorCreate);
                throw new ArgumentException(Resources.Organization.MessageErrorCreate);
            }

            return (int)organizacionId;
        }

        public static void UpdateOrganization(int organizationId, string name)
        {
            if (organizationId <= 0)
                throw new ArgumentException(Resources.Organization.MessageZeroOrganizationId);

            if (string.IsNullOrEmpty(name))
                throw new ArgumentException(Resources.Organization.MessageEmptyName);

            OrganizationTableAdapter localAdapter = new OrganizationTableAdapter();

            try
            {
                localAdapter.UpdateOrganization(organizationId, name);
            }
            catch (Exception exc)
            {
                log.Error(Resources.Organization.MessageErrorUpdate, exc);
                throw exc;
            }
        }

        public static void DeleteOrganization(int organizationId)
        {
            if (organizationId <= 0)
                throw new ArgumentException(Resources.Organization.MessageZeroOrganizationId);

            OrganizationTableAdapter localAdapter = new OrganizationTableAdapter();
            string userName = HttpContext.Current.User.Identity.Name;

            try
            {
                localAdapter.DeleteOrganization(organizationId, userName);
            }
            catch (Exception exc)
            {
                log.Error(Resources.Organization.MessageErrorDelete, exc);
                throw new Exception(Resources.Organization.MessageErrorDelete);
            }
        }

        public static List<Organization> GetOrganizationsForAutocomplete(string filter)
        {
            string userName = HttpContext.Current.User.Identity.Name;

            List<Organization> theList = new List<Organization>();
            Organization theData = null;
            try
            {
                OrganizationTableAdapter localAdapter = new OrganizationTableAdapter();
                OrganizationDS.OrganizationDataTable theTable = localAdapter.GetOrganizationsForAutocomplete(userName, filter);
                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (OrganizationDS.OrganizationRow theRow in theTable)
                    {
                        theData = FillRecord(theRow);
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception exc)
            {
                log.Error("Error al obtener una organizacion for autocomplete.", exc);
                throw new Exception(Resources.Organization.MessageErrorObtainOrganization);
            }
            return theList;
        }

        public static Quantity GetQuantityByOrganization(int organizationId)
        {
            Quantity theClass = null;
            string userName = HttpContext.Current.User.Identity.Name;

            try
            {
                QuantityTableAdapter localAdapter = new QuantityTableAdapter();
                OrganizationDS.QuantityDataTable theTable = localAdapter.GetQuantityByOrganization(organizationId, userName);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    OrganizationDS.QuantityRow row = theTable[0];
                    theClass = new Quantity(row.Areas, row.Projects, row.People, row.Activities, row.Kpis);
                }
            }
            catch (Exception exc)
            {
                log.Error("Error al obtener la cantidades de la organizacion " + organizationId.ToString() + " para usuario " + userName, exc);
                throw new Exception(Resources.Organization.MessageErrorObtainOrganization);
            }

            return theClass;
        }

        public static void DeletePermanently(int organizationId)
        {
            OrganizationTableAdapter adapter = new OrganizationTableAdapter();

            try
            {
                adapter.DeletePermanentlyOrganization(organizationId);
            }
            catch (Exception ex)
            {
                log.Error(Resources.Organization.MessageErrorDelete, ex);
                throw new Exception(Resources.Organization.MessageErrorDelete);
            }
        }
    }
}