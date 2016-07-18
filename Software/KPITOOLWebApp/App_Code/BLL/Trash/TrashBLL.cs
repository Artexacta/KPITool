using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using TrashDSTableAdapters;

namespace Artexacta.App.Trash.BLL
{
    /// <summary>
    /// Summary description for TrashBLL
    /// </summary>
    [System.ComponentModel.DataObject]
    public class TrashBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        TrashTableAdapter _theAdapter = null;

        protected TrashTableAdapter theAdapter
        {
            get
            {
                if (_theAdapter == null)
                    _theAdapter = new TrashTableAdapter();
                return _theAdapter;
            }
        }

        public TrashBLL()
        {
        }

        private static Trash FillRecord(TrashDS.TrashRow row)
        {
            Trash theNewRecord = new Trash(
                row.objectId,
                row.name,
                row.dateDeleted,
                row.fullname);

            return theNewRecord;
        }

        public List<Trash> GetTrashByObjectType(string objectType, string whereClause)
        {
            List<Trash> theList = new List<Trash>();
            Trash theData = null;

            try
            {
                TrashDS.TrashDataTable theTable = theAdapter.GetTrashByObjectType(objectType, whereClause);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (TrashDS.TrashRow theRow in theTable.Rows)
                    {
                        theData = FillRecord(theRow);
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception exc)
            {
                log.Error("Ocurrió un error al obtener la lista de Eliminados para " + objectType, exc);
                throw exc;
            }
            return theList;
        }

        public static void RestoreTrash(string objectType, int objectId)
        {
            TrashTableAdapter localAdapter = new TrashTableAdapter();

            try
            {
                localAdapter.RestoreTrashObject(objectType, objectId);
            }
            catch (Exception exc)
            {
                log.Error("Error al restaurar un objeto del trash.", exc);
                throw new Exception(Resources.Trash.MessageErrorRestore);
            }
        }

    }
}