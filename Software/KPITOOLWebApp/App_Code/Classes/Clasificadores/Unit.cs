using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.Unit
{
    /// <summary>
    /// Summary description for Unit
    /// </summary>
    public class Unit
    {
        public string UnitID { get; set; }
        public string Name { get; set; }
                        
        public Unit()
        {
        }

        public Unit(string unitID, string name)
        {
            this.UnitID = unitID;
            this.Name = name;
        }

    }
}