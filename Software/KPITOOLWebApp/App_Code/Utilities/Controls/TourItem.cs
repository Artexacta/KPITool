using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Artexacta.App.Utilities.Controls
{    
    public class TourItem 
    {

        public string element { get; set; }
        public string title { get; set; }
        public string content { get; set; }

        public string placement { get; set; }

        public TourItem()
        {
            element = "body";
            title = "Tour";
            content = "";
            placement = "rigth";
        }
    }
}