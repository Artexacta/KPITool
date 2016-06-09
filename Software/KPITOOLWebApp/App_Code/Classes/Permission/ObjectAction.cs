using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.ObjectAction
{
    /// <summary>
    /// Summary description for ObjectAction
    /// </summary>
    public class ObjectAction
    {
        public string ObjectActionID { get; set; }

        public ObjectAction()
        {
        }

        public ObjectAction(string objectActionID)
        {
            this.ObjectActionID = objectActionID;
        }

        public string ObjectActionName
        {
            get
            {
                string name = "";
                switch (this.ObjectActionID)
                {
                    case "OWN":
                        name = "Owner";
                        break;

                    case "MAN_PROJECT":
                        name = "Manage Project";
                        break;

                    case "MAN_ACTIVITY":
                        name = "Manage Activity";
                        break;

                    case "MAN_PEOPLE":
                        name = "Manage People";
                        break;

                    case "MAN_KPI":
                        name = "Manage KPI";
                        break;

                    case "VIEW_KPI":
                        name = "View";
                        break;

                    case "ENTER_DATA":
                        name = "View and enter data";
                        break;

                    default:
                        name = "[ Select a permission ]";
                        break;
                }
                return name;
            }
        }

    }
}