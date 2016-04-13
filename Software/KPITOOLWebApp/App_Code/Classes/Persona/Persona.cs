using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.Persona
{
    /// <summary>
    /// Summary description for Persona
    /// </summary>
    public class Persona
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        private int _personaId;
        private string _nombre;
        private string _email;
        private DateTime _fechaNacimiento;
        private string _paisId;
        private string _estadoCivil;
        private string _genero;
        private decimal _salario;
                
        public Persona()
        {
        }

        public Persona(int PersonaId, string Nombre, string Email, DateTime FechaNacimiento, string PaisId, 
            string EstadoCivil, string Genero, decimal Salario)
        {
            this._personaId = PersonaId;
            this._nombre = Nombre;
            this._email = Email;
            this._fechaNacimiento = FechaNacimiento;
            this._paisId = PaisId;
            this._estadoCivil = EstadoCivil;
            this._genero = Genero;
            this._salario = Salario;
        }

        public int PersonaId
        {
            get { return _personaId; }
            set { _personaId = value; }
        }

        public string Nombre
        {
            get { return _nombre; }
            set { _nombre = value; }
        }

        public string Email
        {
            get { return _email; }
            set { _email = value; }
        }

        public DateTime FechaNacimiento
        {
            get { return _fechaNacimiento; }
            set { _fechaNacimiento = value; }
        }

        public string PaisId
        {
            get { return _paisId; }
            set { _paisId = value; }
        }

        public string EstadoCivil
        {
            get { return _estadoCivil; }
            set { _estadoCivil = value; }
        }

        public string Genero
        {
            get { return _genero; }
            set { _genero = value; }
        }

        public decimal Salario
        {
            get { return _salario; }
            set { _salario = value; }
        }

        public string PaisForDisplay
        {
            get
            {
                string pais = " - ";

                if (!string.IsNullOrEmpty(this._paisId))
                {
                    try
                    {
                        string idiomaId = Artexacta.App.Utilities.LanguageUtilities.GetLanguageFromContext().ToUpper();
                        Country.Country theData = Country.BLL.CountryBLL.GetRecordById(this._paisId, idiomaId);

                        if (theData != null)
                            pais = theData.Nombre;
                    }
                    catch
                    {
                        log.Error("Error al obtener la informacion del pais en Persona.cs");
                    }
                }

                return pais;
            }
        }

    }
}