using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Artexacta.App.Utilities.Controls
{
    /// <summary>
    /// Summary description for TourSettings
    /// </summary>
    [ParseChildren(true)]
    public class TourSettings : WebControl
    {
        [PersistenceMode(PersistenceMode.InnerProperty)]
        public List<TourItem> Items { get; set; }

        public TourSettings()
        {
            Items = new List<TourItem>();
        }
    }
}