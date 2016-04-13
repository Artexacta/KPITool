using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.PersonaDepartamento
{
    /// <summary>
    /// Summary description for PersonaDepartamento
    /// </summary>
    public class PersonaDepartamento
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        private int _personaId;
        private int _departamentoId;
        private string _cargo;

        public PersonaDepartamento()
        {
        }

        public PersonaDepartamento(int PersonaId, int DepartamentoId, string Cargo)
        {
            this._personaId = PersonaId;
            this._departamentoId = DepartamentoId;
            this._cargo = Cargo;
        }

        public int PersonaId
        {
            get { return _personaId; }
            set { _personaId = value; }
        }

        public int DepartamentoId
        {
            get { return _departamentoId; }
            set { _departamentoId = value; }
        }

        public string Cargo
        {
            get { return _cargo; }
            set { _cargo = value; }
        }

        public string DepartamentoForDisplay
        {
            get
            {
                string departamento = " - ";

                try
                {
                    Departamento.Departamento theData = Departamento.BLL.DepartamentoBLL.GetRecordById(this._departamentoId);
                    if (theData != null)
                        departamento = theData.Nombre;
                }
                catch
                {
                    log.Error("Error al obtener la informacion del Departamento en PersonaDepartamento.cs");
                }

                return departamento;
            }
        }

    }
}