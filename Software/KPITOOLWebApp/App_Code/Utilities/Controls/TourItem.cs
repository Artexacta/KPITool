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
        public enum SourceTypeOption
        {
            Resource,
            HelpFile
        }

        public SourceTypeOption SourceType { get; set; }
        public string element { get; set; }
        public string title { get; set; }
        public string content { get; set; }

        public string placement { get; set; }

        public TourItem()
        {
            SourceType = SourceTypeOption.Resource;
            element = "body";
            title = "Tour";
            content = "";
            placement = "rigth";
        }
    }
}