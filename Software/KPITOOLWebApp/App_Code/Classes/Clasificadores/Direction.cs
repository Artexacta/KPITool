using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.Direction
{
    /// <summary>
    /// Summary description for Direction
    /// </summary>
    public class Direction
    {
        public string DirectionID { get; set; }
        public string Name { get; set; }
                        
        public Direction()
        {
        }

        public Direction(string directionID, string name)
        {
            this.DirectionID = directionID;
            this.Name = name;
        }

    }
}