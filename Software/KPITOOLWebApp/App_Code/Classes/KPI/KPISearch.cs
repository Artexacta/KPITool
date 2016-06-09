using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using SearchComponent;

namespace Artexacta.App.KPI
{
    /// <summary>
    /// Summary description for KPISearch
    /// </summary>
    public class KPISearch : ConfigColumns
    {
        public KPISearch()
        {
            Column col = new Column("[k].[name]", "name", Column.ColumnType.String);
            col.AppearInStandardSearch = true;
            col.DisplayHelp = true;
            col.Description = Resources.Organization.TitleKPIName;
            this.Cols.Add(col);

            col = new Column("[k].[organizationID]", "organizationID", Column.ColumnType.Numeric);
            col.AppearInStandardSearch = false;
            col.DisplayHelp = false;
            col.Description = Resources.Organization.TitleOrganizationName;
            this.Cols.Add(col);

            col = new Column("[k].[projectID]", "projectID", Column.ColumnType.Numeric);
            col.AppearInStandardSearch = false;
            col.DisplayHelp = false;
            col.Description = Resources.Organization.TitleProjectName;
            this.Cols.Add(col);

            col = new Column("[k].[activityID]", "activityID", Column.ColumnType.Numeric);
            col.AppearInStandardSearch = false;
            col.DisplayHelp = false;
            col.Description = Resources.Organization.TitleActivityName;
            this.Cols.Add(col);

            col = new Column("[k].[personID]", "personID", Column.ColumnType.Numeric);
            col.AppearInStandardSearch = false;
            col.DisplayHelp = false;
            col.Description = "Person";
            this.Cols.Add(col);
        }
    }
}