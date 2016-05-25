using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using StrategyDSTableAdapters;

namespace Artexacta.App.Strategy.BLL
{
    /// <summary>
    /// Summary description for StrategyBLL
    /// </summary>
    [System.ComponentModel.DataObject]
    public class StrategyBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        StrategiesTableAdapter _theAdapter = null;

        protected StrategiesTableAdapter theAdapter
        {
            get
            {
                if (_theAdapter == null)
                    _theAdapter = new StrategiesTableAdapter();
                return _theAdapter;
            }
        }

        public StrategyBLL()
        {
        }

        private static Strategy FillRecord(StrategyDS.StrategiesRow row)
        {
            Strategy theNewRecord = new Strategy(
                row.strategyID,
                row.name);

            return theNewRecord;
        }

        public List<Strategy> GetReportingUnit(string language)
        {
            List<Strategy> theList = new List<Strategy>();
            Strategy theData = null;

            try
            {
                StrategyDS.StrategiesDataTable theTable = theAdapter.GetStrategies(language);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (StrategyDS.StrategiesRow theRow in theTable.Rows)
                    {
                        theData = FillRecord(theRow);
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception exc)
            {
                log.Error("Ocurrió un error al obtener la lista de Strategys de la Base de Datos", exc);
                throw exc;
            }

            return theList;
        }

    }
}