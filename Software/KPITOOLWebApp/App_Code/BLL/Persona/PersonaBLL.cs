using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using PersonaDSTableAdapters;

namespace Artexacta.App.Persona.BLL
{
    /// <summary>
    /// Summary description for PersonaBLL
    /// </summary>
    [System.ComponentModel.DataObject]
    public class PersonaBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        PersonaTableAdapter _theAdapter = null;

        protected PersonaTableAdapter theAdapter
        {
            get
            {
                if (_theAdapter == null)
                    _theAdapter = new PersonaTableAdapter();
                return _theAdapter;
            }
        }

        public PersonaBLL()
        {
        }

        private static Persona FillRecord(PersonaDS.PersonaRow row)
        {
            Persona theNewRecord = new Persona(
                row.personaId,
                row.nombre,
                row.IsemailNull() ? "" : row.email,
                row.IsfechaNacimientoNull() ? DateTime.MinValue : row.fechaNacimiento,
                row.IspaisIdNull() ? "" : row.paisId,
                row.IsestadoCivilNull() ? "" : row.estadoCivil,
                row.IsgeneroNull() ? "" : row.genero,
                row.IssalarioNull () ? 0 : row.salario);

            return theNewRecord;
        }

        public static Persona GetRecordById(int personaId)
        {
            PersonaTableAdapter localAdapter = new PersonaTableAdapter();

            if (personaId <= 0)
                throw new ArgumentException("El identificador no puede ser null");

            Persona theData = null;

            try
            {
                PersonaDS.PersonaDataTable theTable =
                    localAdapter.GetPersonaById(personaId);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    PersonaDS.PersonaRow theRow = theTable[0];
                    theData = FillRecord(theRow);
                }
            }
            catch (Exception exc)
            {
                log.Error("Ocurrió un error mientras se obtenía la Persona de id =" + personaId, exc);
                throw exc;
            }

            return theData;
        }

        public static Persona GetRecordByEmail(string email)
        {
            PersonaTableAdapter localAdapter = new PersonaTableAdapter();

            if (string.IsNullOrEmpty(email))
                throw new ArgumentException("El dato email no puede ser null");

            Persona theData = null;

            try
            {
                PersonaDS.PersonaDataTable theTable = localAdapter.GetPersonaByEmail(email);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    PersonaDS.PersonaRow theRow = theTable[0];
                    theData = FillRecord(theRow);
                }
            }
            catch (Exception exc)
            {
                log.Error("Ocurrió un error mientras se obtenía la Persona de email =" + email, exc);
                throw exc;
            }

            return theData;
        }

        public static int InsertRecord(Persona newData)
        {
            int? newDataId = 0;

            if (newData == null)
            {
                throw new ArgumentException("La Persona no puede ser null");
            }

            if (string.IsNullOrEmpty(newData.Nombre))
            {
                throw new ArgumentException("El dato nombre no puede ser nulo o vacio");
            }

            try
            {
                PersonaTableAdapter localAdapter = new PersonaTableAdapter();
                DateTime? nullDate = null;
                localAdapter.InsertPersona(ref newDataId,
                    newData.Nombre,
                    newData.Email,
                    newData.FechaNacimiento == DateTime.MinValue ? nullDate : newData.FechaNacimiento,
                    newData.PaisId,
                    newData.EstadoCivil,
                    newData.Genero,
                    newData.Salario);

                log.Debug("Se insertó la Persona de nombre " + newData.Nombre);

                if (newDataId == null || newDataId <= 0)
                {
                    throw new Exception("SQL insertó el registro exitosamente pero retornó un status null <= 0");
                }
                return (int)newDataId;
            }
            catch (Exception q)
            {
                log.Error("Ocurrió un error mientras se insertaba la Persona", q);
                throw q;
            }
        }

        public static bool UpdateRecord(Persona theData)
        {
            if (theData == null)
            {
                throw new ArgumentException("El Departamento no puede ser null");
            }

            if (string.IsNullOrEmpty(theData.Nombre))
            {
                throw new ArgumentException("El dato nombre no puede ser nulo o vacio");
            }

            try
            {
                PersonaTableAdapter localAdapter = new PersonaTableAdapter();
                DateTime? nullDate = null;
                localAdapter.UpdatePersona(theData.Nombre,
                    theData.Email,
                    theData.FechaNacimiento == DateTime.MinValue ? nullDate : theData.FechaNacimiento,
                    theData.PaisId,
                    theData.EstadoCivil,
                    theData.Genero,
                    theData.Salario,
                    theData.PersonaId);

                log.Debug("Se modificó el Departamento de id = " + theData.PersonaId);
                return true;
            }
            catch (Exception exc)
            {
                log.Error("Ocurrió un error mientras se actualizaba la Persona", exc);
                throw exc;
            }
        }

        public static bool DeleteRecord(int personaId)
        {
            if (personaId <= 0)
                throw new ArgumentException("Error en el identificador a eliminar.");

            try
            {
                PersonaTableAdapter localAdapter = new PersonaTableAdapter();
                localAdapter.DeletePersona(personaId);
                return true;
            }
            catch (Exception exc)
            {
                log.Error("Ocurrió un error mientras se eliminaba la Persona", exc);
                throw exc;
            }
        }

        public static bool DeleteRecord(Persona theData)
        {
            if (theData == null)
                throw new ArgumentException("Persona no puede ser nulo");

            if (theData.PersonaId <= 0)
                throw new ArgumentException("Error en el identificador a eliminar.");

            try
            {
                PersonaTableAdapter localAdapter = new PersonaTableAdapter();
                localAdapter.DeletePersona(theData.PersonaId);
                return true;
            }
            catch (Exception exc)
            {
                log.Error("Ocurrió un error mientras se eliminaba la Persona", exc);
                throw exc;
            }
        }

        public static List<Persona> GetRecordForSearch(string whereClause)
        {
            if (string.IsNullOrEmpty(whereClause))
                whereClause = "1 = 1";

            List<Persona> theList = new List<Persona>();
            Persona theData = null;

            try
            {
                PersonaTableAdapter localAdapter = new PersonaTableAdapter();

                PersonaDS.PersonaDataTable theTable = localAdapter.GetPersonasForSearch(whereClause);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (PersonaDS.PersonaRow theRow in theTable.Rows)
                    {
                        theData = FillRecord(theRow);
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception exc)
            {
                log.Error("Un error ocurrió al obtener la lista de Personas", exc);
                throw exc;
            }

            return theList;
        }

    }
}