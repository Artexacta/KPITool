using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.Strategy
{
    /// <summary>
    /// Summary description for Strategy
    /// </summary>
    public class Strategy
    {
        public string StrategyID { get; set; }
        public string Name { get; set; }
                        
        public Strategy()
        {
        }

        public Strategy(string strategyID, string name)
        {
            this.StrategyID = strategyID;
            this.Name = name;
        }

    }
}