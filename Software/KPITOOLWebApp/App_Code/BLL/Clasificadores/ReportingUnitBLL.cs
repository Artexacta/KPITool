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

        public ReportingUnit GetReportingUnitByID(string reportingUnitID, string language)
        {
            if (string.IsNullOrEmpty(reportingUnitID))
                throw new ArgumentException("El ID no puede ser <= 0.");

            if (string.IsNullOrEmpty(language))
                language = Artexacta.App.Utilities.LanguageUtilities.GetLanguageFromContext();

            ReportingUnit theData = null;
            try
            {
                ReportingUnitDS.ReportingUnitsDataTable theTable = theAdapter.GetReportingUnitById(reportingUnitID, language);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    ReportingUnitDS.ReportingUnitsRow theRow = theTable[0];
                    theData = FillRecord(theRow);
                }
            }
            catch (Exception exc)
            {
                log.Error("Error en GetReportingUnitByID para reportingUnitID: " + reportingUnitID + " y language: " + language, exc);
                throw exc;
            }

            return theData;
        }

    }
}