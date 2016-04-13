using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DepartamentoDSTableAdapters;

namespace Artexacta.App.Departamento.BLL
{
    /// <summary>
    /// Summary description for DepartamentoBLL
    /// </summary>
    [System.ComponentModel.DataObject]
    public class DepartamentoBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        DepartamentoTableAdapter _theAdapter = null;

        protected DepartamentoTableAdapter theAdapter
        {
            get
            {
                if (_theAdapter == null)
                    _theAdapter = new DepartamentoTableAdapter();
                return _theAdapter;
            }
        }

        public DepartamentoBLL()
        {
        }

        private static Departamento FillRecord(DepartamentoDS.DepartamentoRow row)
        {
            Departamento theNewRecord = new Departamento(
                row.departamentoId,
                row.nombre);

            return theNewRecord;
        }

        public List<Departamento> GetAllRecords()
        {
            List<Departamento> theList = new List<Departamento>();
            Departamento theData = null;

            try
            {
                DepartamentoDS.DepartamentoDataTable theTable =
                    theAdapter.GetAllDepartamentos();

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (DepartamentoDS.DepartamentoRow theRow in theTable.Rows)
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

        public static Departamento GetRecordById(int departamentoId)
        {
            DepartamentoTableAdapter localAdapter = new DepartamentoTableAdapter();

            if (departamentoId <= 0)
                throw new ArgumentException("El identificador no puede ser null");

            Departamento theData = null;

            try
            {
                DepartamentoDS.DepartamentoDataTable theTable =
                    localAdapter.GetDepartamentoById(departamentoId);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    DepartamentoDS.DepartamentoRow theRow = theTable[0];
                    theData = FillRecord(theRow);
                }
            }
            catch (Exception exc)
            {
                log.Error("Ocurrió un error mientras se obtenía el Departamento de id =" + departamentoId, exc);
                throw exc;
            }

            return theData;
        }

        public static Departamento GetRecordByNombre(string nombre)
        {
            if (string.IsNullOrEmpty(nombre))
                throw new ArgumentException("El dato nombre no puede ser nulo o vacio");

            DepartamentoTableAdapter localAdapter = new DepartamentoTableAdapter();
            Departamento theData = null;

            try
            {
                DepartamentoDS.DepartamentoDataTable theTable =
                    localAdapter.GetDepartamentoByNombre(nombre);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    DepartamentoDS.DepartamentoRow theRow = theTable[0];
                    theData = FillRecord(theRow);
                }
            }
            catch (Exception exc)
            {
                log.Error("Ocurrió un error mientras se obtenía el Departamento de nombre =" + nombre, exc);
                throw exc;
            }

            return theData;
        }

        public static int InsertRecord(Departamento newData)
        {
            int? newDataId = 0;

            if (newData == null)
            {
                throw new ArgumentException("El Departamento no puede ser null");
            }

            if (string.IsNullOrEmpty(newData.Nombre))
            {
                throw new ArgumentException("El dato nombre no puede ser nulo o vacio");
            }

            try
            {
                DepartamentoTableAdapter localAdapter = new DepartamentoTableAdapter();

                localAdapter.InsertDepartamento(ref newDataId,
                    newData.Nombre);

                log.Debug("Se insertó el Departamento de nombre " + newData.Nombre);

                if (newDataId == null || newDataId <= 0)
                {
                    throw new Exception("SQL insertó el registro exitosamente pero retornó un status null <= 0");
                }
                return (int)newDataId;
            }
            catch (Exception q)
            {
                log.Error("Ocurrió un error mientras se insertaba el Departamento", q);
                throw q;
            }
        }

        public static bool UpdateRecord(Departamento theData)
        {
            if (theData == null)
            {
                throw new ArgumentException("El Departamento no puede ser null");
            }

            if (theData.DepartamentoId <= 0)
            {
                throw new ArgumentException("El dato departamentoId no puede ser <= 0");
            }

            if (string.IsNullOrEmpty(theData.Nombre))
            {
                throw new ArgumentException("El dato nombre no puede ser nulo o vacio");
            }

            try
            {
                DepartamentoTableAdapter localAdapter = new DepartamentoTableAdapter();

                localAdapter.UpdateDepartamento(theData.Nombre,
                    theData.DepartamentoId);

                log.Debug("Se modificó el Departamento de id = " + theData.DepartamentoId);
                return true;
            }
            catch (Exception exc)
            {
                log.Error("Ocurrió un error mientras se actualizaba el Departamento", exc);
                throw exc;
            }
        }

        public static bool DeleteRecord(int departamentoId)
        {
            if (departamentoId <= 0)
                throw new ArgumentException("Error en el identificador a eliminar.");

            try
            {
                DepartamentoTableAdapter localAdapter = new DepartamentoTableAdapter();
                localAdapter.DeleteDepartamento(departamentoId);
                return true;
            }
            catch (Exception exc)
            {
                log.Error("Ocurrió un error mientras se eliminaba el Departamento", exc);
                throw exc;
            }
        }

        public static bool DeleteRecord(Departamento theData)
        {
            if (theData.DepartamentoId <= 0)
                throw new ArgumentException("Error en el identificador a eliminar.");

            try
            {
                DepartamentoTableAdapter localAdapter = new DepartamentoTableAdapter();
                localAdapter.DeleteDepartamento(theData.DepartamentoId);
                return true;
            }
            catch (Exception exc)
            {
                log.Error("Ocurrió un error mientras se eliminaba el Departamento", exc);
                throw exc;
            }
        }

    }
}