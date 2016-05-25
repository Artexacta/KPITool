using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using ReportingUnitDSTableAdapters;

namespace Artexacta.App.ReportingUnit.BLL
{
    /// <summary>
    /// Summary description for ReportingUnitBLL
    /// </summary>
    [System.ComponentModel.DataObject]
    public class ReportingUnitBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        ReportingUnitsTableAdapter _theAdapter = null;

        protected ReportingUnitsTableAdapter theAdapter
        {
            get
            {
                if (_theAdapter == null)
                    _theAdapter = new ReportingUnitsTableAdapter();
                return _theAdapter;
            }
        }

        public ReportingUnitBLL()
        {
        }

        private static ReportingUnit FillRecord(ReportingUnitDS.ReportingUnitsRow row)
        {
            ReportingUnit theNewRecord = new ReportingUnit(
                row.reportingUnitID,
                row.name);

            return theNewRecord;
        }

        public List<ReportingUnit> GetReportingUnit(string language)
        {
            List<ReportingUnit> theList = new List<ReportingUnit>();
            ReportingUnit theData = null;

            try
            {
                ReportingUnitDS.ReportingUnitsDataTable theTable = theAdapter.GetReportingUnits(language);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (ReportingUnitDS.ReportingUnitsRow theRow in theTable.Rows)
                    {
                        theData = FillRecord(theRow);
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception exc)
            {
                log.Error("Ocurrió un error al obtener la lista de ReportingUnits de la Base de Datos", exc);
                throw exc;
            }

            return theList;
        }

    }
}