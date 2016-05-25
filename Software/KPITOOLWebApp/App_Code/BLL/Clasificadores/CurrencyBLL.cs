using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using CurrencyDSTableAdapters;

namespace Artexacta.App.Currency.BLL
{
    /// <summary>
    /// Summary description for CurrencyBLL
    /// </summary>
    [System.ComponentModel.DataObject]
    public class CurrencyBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        CurrenciesTableAdapter _theAdapter = null;

        protected CurrenciesTableAdapter theAdapter
        {
            get
            {
                if (_theAdapter == null)
                    _theAdapter = new CurrenciesTableAdapter();
                return _theAdapter;
            }
        }

        public CurrencyBLL()
        {
        }

        private static Currency FillRecord(CurrencyDS.CurrenciesRow row)
        {
            Currency theNewRecord = new Currency(
                row.currencyID,
                row.name);

            return theNewRecord;
        }

        public List<Currency> GetCurrencys(string language)
        {
            List<Currency> theList = new List<Currency>();
            Currency theData = null;

            try
            {
                CurrencyDS.CurrenciesDataTable theTable = theAdapter.GetCurrencyData(language);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (CurrencyDS.CurrenciesRow theRow in theTable.Rows)
                    {
                        theData = FillRecord(theRow);
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception exc)
            {
                log.Error("Ocurrió un error al obtener la lista de Currencys de la Base de Datos", exc);
                throw exc;
            }

            return theList;
        }


    }
}