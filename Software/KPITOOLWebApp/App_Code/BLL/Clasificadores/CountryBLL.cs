using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using CountryDSTableAdapters;

namespace Artexacta.App.Country.BLL
{
    /// <summary>
    /// Summary description for CountryBLL
    /// </summary>
    [System.ComponentModel.DataObject]
    public class CountryBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        CountryTableAdapter _theAdapter = null;

        protected CountryTableAdapter theAdapter
        {
            get
            {
                if (_theAdapter == null)
                    _theAdapter = new CountryTableAdapter();
                return _theAdapter;
            }
        }

        public CountryBLL()
        {
        }

        private static Country FillRecord(CountryDS.CountryRow row)
        {
            Country theNewRecord = new Country(
                row.CountryId,
                row.iso2,
                row.isoNumero,
                row.countryName);

            return theNewRecord;
        }

        public static Country GetRecordById(string countryId, string idiomaId)
        {
            CountryTableAdapter localAdapter = new CountryTableAdapter();

            if (string.IsNullOrEmpty(countryId))
                throw new ArgumentException("El identificador countryId no puede ser null o vacio");

            if (string.IsNullOrEmpty(idiomaId))
                throw new ArgumentException("El identificador idiomaId no puede ser null o vacio");

            Country theData = null;

            try
            {
                CountryDS.CountryDataTable theTable =
                    localAdapter.GetCountryById(countryId, idiomaId);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    CountryDS.CountryRow theRow = theTable[0];
                    theData = FillRecord(theRow);
                }
            }
            catch (Exception exc)
            {
                log.Error("Ocurrió un error mientras se obtenía el country de id =" + countryId, exc);
                throw exc;
            }

            return theData;
        }

        public static List<Country> GetCountryForAutocomplete(int? start, int? numItems, string filter, string idiomaId, ref int? totalRows)
        {
            List<Country> theList = new List<Country>();
            Country theData = null;

            try
            {
                CountryTableAdapter localAdapter = new CountryTableAdapter();
                CountryDS.CountryDataTable theTable =
                    localAdapter.GetCountryForAutocomplete(numItems, start, filter, idiomaId, ref totalRows);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (CountryDS.CountryRow theRow in theTable.Rows)
                    {
                        theData = FillRecord(theRow);
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception exc)
            {
                log.Error("Ocurrió un error al obtener la lista de Departamentos de la Base de Datos", exc);
                throw exc;
            }
            return theList;
        }

    }
}