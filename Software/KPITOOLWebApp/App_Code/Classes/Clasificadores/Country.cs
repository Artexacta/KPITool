using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.Country
{
    /// <summary>
    /// Summary description for Country
    /// </summary>
    public class Country
    {
        private string _countryId;
        private string _iso2;
        private int _isoNumero;
        private string _nombre;
                
        public Country()
        {
        }

        public Country(string countryId, string ISO2, int ISONumero, string Nombre)
        {
            this._countryId = countryId;
            this._iso2 = ISO2;
            this._isoNumero = ISONumero;
            this._nombre = Nombre;
        }

        public string countryId
        {
            get { return _countryId; }
            set { _countryId = value; }
        }

        public string Iso2
        {
            get { return _iso2; }
            set { _iso2 = value; }
        }

        public int IsoNumero
        {
            get { return _isoNumero; }
            set { _isoNumero = value; }
        }

        public string Nombre
        {
            get { return _nombre; }
            set { _nombre = value; }
        }

    }
}