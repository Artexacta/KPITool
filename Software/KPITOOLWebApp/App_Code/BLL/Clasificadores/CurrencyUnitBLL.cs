using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using CurrencyDSTableAdapters;

namespace Artexacta.App.Currency.BLL
{
    /// <summary>
    /// Summary description for CurrencyUnitBLL
    /// </summary>
    [System.ComponentModel.DataObject]
    public class CurrencyUnitBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        CurrencyUnitsForCurrencyTableAdapter _theAdapter = null;

        protected CurrencyUnitsForCurrencyTableAdapter theAdapter
        {
            get
            {
                if (_theAdapter == null)
                    _theAdapter = new CurrencyUnitsForCurrencyTableAdapter();
                return _theAdapter;
            }
        }

        public CurrencyUnitBLL()
        {
        }

        private static CurrencyUnit FillRecord(CurrencyDS.CurrencyUnitsForCurrencyRow row)
        {
            CurrencyUnit theNewRecord = new CurrencyUnit(
                row.currencyID,
                row.currencyUnitID,
                row.name);

            return theNewRecord;
        }

        public List<CurrencyUnit> GetCurrencyUnitsByCurrency(string language, string currencyID)
        {
            List<CurrencyUnit> theList = new List<CurrencyUnit>();
            CurrencyUnit theData = null;

            try
            {
                CurrencyDS.CurrencyUnitsForCurrencyDataTable theTable = theAdapter.GetCurrencyUnitsByCurrency(language, currencyID);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (CurrencyDS.CurrencyUnitsForCurrencyRow theRow in theTable.Rows)
                    {
                        theData = FillRecord(theRow);
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception exc)
            {
                log.Error("Ocurrió un error al obtener la lista de CurrencyUnits de la Base de Datos", exc);
                throw exc;
            }

            return theList;
        }

    }
}