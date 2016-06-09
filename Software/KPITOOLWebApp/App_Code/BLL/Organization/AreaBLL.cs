using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using log4net;
using AreaDSTableAdapters;

namespace Artexacta.App.Area.BLL
{
    /// <summary>
    /// Summary description for AreaBLL
    /// </summary>
    /// 

    [System.ComponentModel.DataObject]
    public class AreaBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        AreaTableAdapter _theAdapter = null;

        protected AreaTableAdapter theAdapter
        {
            get
            {
                if (_theAdapter == null)
                    _theAdapter = new AreaTableAdapter();
                return _theAdapter;
            }
        }

        public AreaBLL()
        {
        }

        private static Area FillRecord(AreaDS.AreaRow row)
        {
            Area theNewRecord = new Area(
                row.areaID,
                row.organizationID,
                row.name);
            theNewRecord.OrganizationName = row.IsorganizationNameNull() ? "" : row.organizationName;
            theNewRecord.NumberOfKpis = row.IsnumberKPIsNull() ? 0 : row.numberKPIs;
            return theNewRecord;
        }

        public List<Area> GetAreasByOrganization(int organizationId)
        {
            if (organizationId<=0)
                throw new ArgumentException(Resources.Organization.MessageZeroOrganizationId);

            string userName = HttpContext.Current.User.Identity.Name;
            List<Area> theList = new List<Area>();
            Area theData = null;
            try
            {
                AreaDS.AreaDataTable theTable = theAdapter.GetAreasByOrganization(organizationId, userName);
                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (AreaDS.AreaRow theRow in theTable)
                    {
                        theData = FillRecord(theRow);
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception exc)
            {
                log.Error("Error en GetAreasByOrganization para organizationId: " + organizationId.ToString() + " y userName: " + userName, exc);
                throw new ArgumentException("Ocurrió un error al obtener el listado de áreas de la organización.");
            }

            return theList;
        }

        public Area GetAreaByOrganizationAndName(int organizationId, string name)
        {
            if (organizationId <= 0)
                throw new ArgumentException(Resources.Organization.MessageZeroOrganizationId);

            if (string.IsNullOrEmpty(name))
                throw new ArgumentException(Resources.Organization.MessageEmptyNameArea);

            Area theData = null;
            
            try
            {
                AreaDS.AreaDataTable theTable = theAdapter.GetAreaByOrganizationAndArea(organizationId, name);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    AreaDS.AreaRow theRow = theTable[0];
                    theData = FillRecord(theRow);
                }
            }
            catch (Exception exc)
            {
                log.Error("Ocurrió un error mientras se obtenía el area de nombre: " + name, exc);
                throw exc;
            }

            return theData;
        }

        public static int InsertArea(int organizationId, string name)
        {
            if (organizationId <= 0)
                throw new ArgumentException(Resources.Organization.MessageZeroOrganizationId);

            if (string.IsNullOrEmpty(name))
                throw new ArgumentException(Resources.Organization.MessageEmptyNameArea);

            AreaTableAdapter localAdapter = new AreaTableAdapter();

            int? areaId =0;

            try
            {
                localAdapter.InsertArea(organizationId, name, ref areaId);
            }
            catch (Exception exc)
            {
                log.Error(Resources.Organization.MessageErrorCreateArea, exc);
                throw exc;
            }

            if ((int)areaId <= 0)
            {
                log.Error(Resources.Organization.MessageErrorCreateArea);
                throw new ArgumentException(Resources.Organization.MessageErrorCreateArea);
            }

            return (int)areaId;
        }

        public static void UpdateArea(int areaId, string name)
        {
            if (areaId <= 0)
                throw new ArgumentException(Resources.Organization.MessageZeroAreaId);
            
            if (string.IsNullOrEmpty(name))
                throw new ArgumentException(Resources.Organization.MessageEmptyNameArea);

            AreaTableAdapter localAdapter = new AreaTableAdapter();

            try
            {
                localAdapter.UpdateArea(areaId, name);
            }
            catch (Exception exc)
            {
                log.Error(Resources.Organization.MessageErrorUpdateArea, exc);
                throw exc;
            }
        }

        public static void DeleteArea(int areaId)
        {
            if (areaId <= 0)
                throw new ArgumentException(Resources.Organization.MessageZeroAreaId);

            AreaTableAdapter localAdapter = new AreaTableAdapter();

            try
            {
                localAdapter.DeleteArea(areaId);
            }
            catch (Exception exc)
            {
                log.Error(Resources.Organization.MessageErrorDeleteArea, exc);
                throw new Exception(Resources.Organization.MessageErrorDeleteArea);
            }
        }

        public static Area GetAreaById(int areaId)
        {
            if (areaId <= 0)
                throw new ArgumentException(Resources.Organization.MessageZeroAreaId);

            Area theData = null;
            try
            {
                AreaTableAdapter localAdapter = new AreaTableAdapter();
                AreaDS.AreaDataTable theTable = localAdapter.GetAreaById(areaId);
                if (theTable != null && theTable.Rows.Count > 0)
                {
                    AreaDS.AreaRow theRow = theTable[0];
                    theData = FillRecord(theRow);
                }
            }
            catch (Exception exc)
            {
                log.Error("Ocurrió un error mientras se obtenía el area de id: " + areaId, exc);
                throw exc;
            }

            return theData;
        }

        public static List<Area> GetAreasForAutocomplete(int organizationId, string filter)
        {
            List<Area> theList = new List<Area>();
            Area theData = null;
            try
            {
                AreaTableAdapter localAdapter = new AreaTableAdapter();
                AreaDS.AreaDataTable theTable = localAdapter.GetAreasForAutocomplete(organizationId, filter);
                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (AreaDS.AreaRow theRow in theTable)
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