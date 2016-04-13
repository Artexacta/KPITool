using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.Departamento
{
    /// <summary>
    /// Summary description for Departamento
    /// </summary>
    public class Departamento
    {
        private int _departamentoId;
        private string _nombre;

        public Departamento()
        {
        }

        public Departamento(int DepartamentoId, string Nombre)
        {
            this._departamentoId = DepartamentoId;
            this._nombre = Nombre;
        }
        
        public int DepartamentoId
        {
            get { return _departamentoId; }
            set { _departamentoId = value; }
        }

        public string Nombre
        {
            get { return _nombre; }
            set { _nombre = value; }
        }
        
    }
}