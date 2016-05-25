using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using UnitDSTableAdapters;

namespace Artexacta.App.Unit.BLL
{
    /// <summary>
    /// Summary description for UnitBLL
    /// </summary>
    [System.ComponentModel.DataObject]
    public class UnitBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        UnitsTableAdapter _theAdapter = null;

        protected UnitsTableAdapter theAdapter
        {
            get
            {
                if (_theAdapter == null)
                    _theAdapter = new UnitsTableAdapter();
                return _theAdapter;
            }
        }

        public UnitBLL()
        {
        }

        private static Unit FillRecord(UnitDS.UnitsRow row)
        {
            Unit theNewRecord = new Unit(
                row.unitID,
                row.name);

            return theNewRecord;
        }

        public List<Unit> GetUnits(string language)
        {
            List<Unit> theList = new List<Unit>();
            Unit theData = null;

            try
            {
                UnitDS.UnitsDataTable theTable = theAdapter.GetUnits(language);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (UnitDS.UnitsRow theRow in theTable.Rows)
                    {
                        theData = FillRecord(theRow);
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception exc)
            {
                log.Error("Ocurrió un error al obtener la lista de Units de la Base de Datos", exc);
                throw exc;
            }

            return theList;
        }

    }
}