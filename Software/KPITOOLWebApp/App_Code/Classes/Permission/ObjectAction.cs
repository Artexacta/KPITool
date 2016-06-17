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
                        name = Resources.ShareData.ObjectActionOwn;
                        break;

                    case "MAN_PROJECT":
                        name = Resources.ShareData.ObjectActionProject;
                        break;

                    case "MAN_ACTIVITY":
                        name = Resources.ShareData.ObjectActionActivity;
                        break;

                    case "MAN_PEOPLE":
                        name = Resources.ShareData.ObjectActionPeople;
                        break;

                    case "MAN_KPI":
                        name = Resources.ShareData.ObjectActionKpi;
                        break;

                    case "VIEW_KPI":
                        name = Resources.ShareData.ObjectActionViewKpi;
                        break;

                    case "ENTER_DATA":
                        name = Resources.ShareData.ObjectActionEnterData;
                        break;

                    default:
                        name = Resources.ShareData.ObjectActionDefault;
                        break;
                }
                return name;
            }
        }

    }
}