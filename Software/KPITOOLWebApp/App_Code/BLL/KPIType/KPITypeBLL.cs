using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Transactions;
using System.Data.SqlClient;
using System.Configuration;
using log4net;
using KPITypeDSTableAdapters;

namespace Artexacta.App.KPI.BLL
{
    /// <summary>
    /// BLL for handling KPIType
    /// </summary>
    [System.ComponentModel.DataObject]
    public class KPITypeBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        KPITypeDetailTableAdapter _theAdapter = null;

        protected KPITypeDetailTableAdapter theAdapter
        {
            get
            {
                if (_theAdapter == null)
                    _theAdapter = new KPITypeDetailTableAdapter();
                return _theAdapter;
            }
        }

        public KPITypeBLL()
        {
        }

        private static KPIType FillRecord(KPITypeDS.KPITypeDetailRow row)
        {
            KPIType theNewRecord = new KPIType(
                row.kpiTypeID,
                row.directionID,
                row.strategyID,
                row.unitID,
                row.typeName,
                row.description);

            return theNewRecord;
        }

        public List<KPIType> GetKPITypes(string language)
        {
            if (string.IsNullOrEmpty(language))
                language = Artexacta.App.Utilities.LanguageUtilities.GetLanguageFromContext();

            List<KPIType> theList = new List<KPIType>();
            KPIType theData = null;

            try
            {
                KPITypeDS.KPITypeDetailDataTable theTable = theAdapter.GetKPITypes(language);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (KPITypeDS.KPITypeDetailRow theRow in theTable)
                    {
                        theData = FillRecord(theRow);
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception exc)
            {
                log.Error("Ocurrió un error mientras se obtenía los KPITypes.", exc);
                throw exc;
            }

            return theList;
        }

        public KPIType GetKPITypesByID(string kpiTypeID, string language)
        {
            if (string.IsNullOrEmpty(language))
                language = Artexacta.App.Utilities.LanguageUtilities.GetLanguageFromContext();

            KPIType theData = null;

            try
            {
                KPITypeDS.KPITypeDetailDataTable theTable = theAdapter.GetKpiTypeById(kpiTypeID, language);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    KPITypeDS.KPITypeDetailRow theRow = theTable[0];
                    theData = FillRecord(theRow);
                }
            }
            catch (Exception exc)
            {
                log.Error("Ocurrió un error mientras se obtenía un KPIType.", exc);
                throw exc;
            }

            return theData;
        }
    }
}