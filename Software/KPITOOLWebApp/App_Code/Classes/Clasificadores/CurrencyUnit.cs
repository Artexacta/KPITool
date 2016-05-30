using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.Currency
{
    /// <summary>
    /// Summary description for CurrencyUnit
    /// </summary>
    public class CurrencyUnit
    {
        public string CurrencyID { get; set; }
        public string CurrencyUnitID { get; set; }
        public string Name { get; set; }
                        
        public CurrencyUnit()
        {
        }

        public CurrencyUnit(string currencyID, string currencyUnitID, string name)
        {
            this.CurrencyID = currencyID;
            this.CurrencyUnitID = currencyUnitID;
            this.Name = name;
        }

    }
}