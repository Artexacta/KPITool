using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DirectionDSTableAdapters;

namespace Artexacta.App.Direction.BLL
{
    /// <summary>
    /// Summary description for DirectionBLL
    /// </summary>
    [System.ComponentModel.DataObject]
    public class DirectionBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        DirectionsTableAdapter _theAdapter = null;

        protected DirectionsTableAdapter theAdapter
        {
            get
            {
                if (_theAdapter == null)
                    _theAdapter = new DirectionsTableAdapter();
                return _theAdapter;
            }
        }

        public DirectionBLL()
        {
        }

        private static Direction FillRecord(DirectionDS.DirectionsRow row)
        {
            Direction theNewRecord = new Direction(
                row.directionID,
                row.name);

            return theNewRecord;
        }

        public List<Direction> GetDirections(string language)
        {
            List<Direction> theList = new List<Direction>();
            Direction theData = null;

            try
            {
                DirectionDS.DirectionsDataTable theTable = theAdapter.GetDirections(language);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (DirectionDS.DirectionsRow theRow in theTable.Rows)
                    {
                        theData = FillRecord(theRow);
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception exc)
            {
                log.Error("Ocurrió un error al obtener la lista de Directions de la Base de Datos", exc);
                throw exc;
            }

            return theList;
        }

    }
}