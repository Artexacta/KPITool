using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using PersonaDepartamentoDSTableAdapters;

namespace Artexacta.App.PersonaDepartamento.BLL
{
    /// <summary>
    /// Summary description for PersonaDepartamentoBLL
    /// </summary>
    [System.ComponentModel.DataObject]
    public class PersonaDepartamentoBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        PersonaDepartamentoTableAdapter _theAdapter = null;

        protected PersonaDepartamentoTableAdapter theAdapter
        {
            get
            {
                if (_theAdapter == null)
                    _theAdapter = new PersonaDepartamentoTableAdapter();
                return _theAdapter;
            }
        }

        public PersonaDepartamentoBLL()
        {
        }

        private static PersonaDepartamento FillRecord(PersonaDepartamentoDS.PersonaDepartamentoRow row)
        {
            PersonaDepartamento theNewRecord = new PersonaDepartamento(
                row.personaId,
                row.departamentoId,
                row.IscargoNull() ? "" : row.cargo);

            return theNewRecord;
        }

        public static PersonaDepartamento GetRecordById(int personaId, int departamentoId)
        {
            PersonaDepartamentoTableAdapter localAdapter = new PersonaDepartamentoTableAdapter();

            if (personaId <= 0)
                throw new ArgumentException("El identificador personaId no puede ser null");

            if (personaId <= 0)
                throw new ArgumentException("El identificador departamentoId no puede ser null");

            PersonaDepartamento theData = null;

            try
            {
                PersonaDepartamentoDS.PersonaDepartamentoDataTable theTable =
                    localAdapter.GetPersonaDepartamentoById(personaId, departamentoId);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    PersonaDepartamentoDS.PersonaDepartamentoRow theRow = theTable[0];
                    theData = FillRecord(theRow);
                }
            }
            catch (Exception exc)
            {
                log.Error("Ocurrió un error mientras se obtenía de PersonaDepartamento la informacion para personaId = " 
                    + personaId + " y departamentoId = " + departamentoId, exc);
                throw exc;
            }

            return theData;
        }

        public static bool InsertRecord(PersonaDepartamento newData)
        {
            if (newData == null)
            {
                throw new ArgumentException("La Persona no puede ser null");
            }

            if (newData.PersonaId <= 0)
            {
                throw new ArgumentException("El dato personaId no puede ser <= 0");
            }

            if (newData.DepartamentoId <= 0)
            {
                throw new ArgumentException("El dato departamentoId no puede ser <= 0");
            }

            try
            {
                PersonaDepartamentoTableAdapter localAdapter = new PersonaDepartamentoTableAdapter();
                localAdapter.InsertPersonaDepartamento(
                    newData.PersonaId,
                    newData.DepartamentoId,
                    newData.Cargo);

                log.Debug("Se insertó PersonaDepartamento para la personaId =  " + newData.PersonaId + " y departamentoId = " 
                    + newData.DepartamentoId);

                return true;
            }
            catch (Exception q)
            {
                log.Error("Ocurrió un error mientras se insertaba el dato PersonaDepartamento", q);
                throw q;
            }
        }

        public static bool UpdateRecord(PersonaDepartamento theData)
        {
            if (theData == null)
            {
                throw new ArgumentException("El Departamento no puede ser null");
            }

            if (theData.PersonaId <= 0)
            {
                throw new ArgumentException("El dato personaId no puede ser <= 0");
            }

            if (theData.DepartamentoId <= 0)
            {
                throw new ArgumentException("El dato departamentoId no puede ser <= 0");
            }

            try
            {
                PersonaDepartamentoTableAdapter localAdapter = new PersonaDepartamentoTableAdapter();
                localAdapter.UpdatePersonaDepartamento(theData.PersonaId,
                    theData.DepartamentoId,
                    theData.Cargo);

                log.Debug("Se modificó el PersonaDepartamento para la personaId = " + theData.PersonaId + " y departamentoId = " 
                    + theData.DepartamentoId);
                
                return true;
            }
            catch (Exception exc)
            {
                log.Error("Ocurrió un error mientras se actualizaba el dato PersonaDepartamento", exc);
                throw exc;
            }
        }

        public static bool DeleteRecord(int personaId, int departamentoId)
        {
            if (personaId <= 0)
                throw new ArgumentException("Error en el identificador personaId a eliminar.");

            if (personaId <= 0)
                throw new ArgumentException("Error en el identificador departamentoId a eliminar.");

            try
            {
                PersonaDepartamentoTableAdapter localAdapter = new PersonaDepartamentoTableAdapter();
                localAdapter.DeletePersonaDepartamento(personaId, departamentoId);
                return true;
            }
            catch (Exception exc)
            {
                log.Error("Ocurrió un error mientras se eliminaba el dato PersonaDepartamento", exc);
                throw exc;
            }
        }

        public static bool DeleteRecord(PersonaDepartamento theData)
        {
            if (theData.PersonaId <= 0)
                throw new ArgumentException("Error en el identificador personaId a eliminar.");

            if (theData.DepartamentoId <= 0)
                throw new ArgumentException("Error en el identificador departamentoId a eliminar.");

            try
            {
                PersonaDepartamentoTableAdapter localAdapter = new PersonaDepartamentoTableAdapter();
                localAdapter.DeletePersonaDepartamento(theData.PersonaId, theData.DepartamentoId);
                return true;
            }
            catch (Exception exc)
            {
                log.Error("Ocurrió un error mientras se eliminaba el dato PersonaDepartamento", exc);
                throw exc;
            }
        }

        public List<PersonaDepartamento> GetPersonaDepartamentoByPersonaId(int personaId)
        {
            List<PersonaDepartamento> theList = new List<PersonaDepartamento>();
            PersonaDepartamento theData = null;

            try
            {
                PersonaDepartamentoDS.PersonaDepartamentoDataTable theTable =
                    theAdapter.GetPersonaDepartamentoByPersonaId(personaId);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (PersonaDepartamentoDS.PersonaDepartamentoRow theRow in theTable.Rows)
                    {
                        theData = FillRecord(theRow);
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception exc)
            {
                log.Error("Ocurrió un error al obtener la lista de PersonaDepartamento de la Base de Datos para personaId = " + personaId, exc);
                throw exc;
            }
            return theList;
        }

    }
}