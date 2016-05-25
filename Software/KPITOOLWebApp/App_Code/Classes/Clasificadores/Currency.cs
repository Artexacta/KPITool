using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.Currency
{
    /// <summary>
    /// Summary description for Currency
    /// </summary>
    public class Currency
    {
        public string CurrencyID { get; set; }
        public string Name { get; set; }
                        
        public Currency()
        {
        }

        public Currency(string currencyID, string name)
        {
            this.CurrencyID = currencyID;
            this.Name = name;
        }

    }
}