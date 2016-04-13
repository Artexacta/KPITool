using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.FRTWB
{
    /// <summary>
    /// Summary description for FrtwbObject
    /// </summary>
    public class FrtwbObject
    {
        public int ObjectId { get; set; }
        public string Name { get; set; }
        public string Type { get; set; }

        public FrtwbObject Owner { get; set; }

        public string UniqueId { get { return ObjectId + "-" + Type; } }

        public FrtwbObject()
        {

        }
    }
}