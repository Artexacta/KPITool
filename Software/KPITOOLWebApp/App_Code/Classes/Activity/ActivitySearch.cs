using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using SearchComponent;

namespace Artexacta.App.Activities
{
    /// <summary>
    /// Summary description for ProjectSearch
    /// </summary>
    public class ActivitiesSearch : ConfigColumns
    {
        public ActivitiesSearch()
        {
            Column col = new Column("[a].[name]", "name", Column.ColumnType.String);
            col.AppearInStandardSearch = true;
            col.DisplayHelp = true;
            col.Description = Resources.Organization.TitleActivityName;
            this.Cols.Add(col);

            col = new Column("[a].[organizationID]", "organizationID", Column.ColumnType.Numeric);
            col.AppearInStandardSearch = false;
            col.DisplayHelp = false;
            col.Description = Resources.Organization.TitleOrganizationName;
            this.Cols.Add(col);

            col = new Column("[a].[areaID]", "areaId", Column.ColumnType.Numeric);
            col.AppearInStandardSearch = false;
            col.DisplayHelp = false;
            col.Description = Resources.Organization.TitleArea;
            this.Cols.Add(col);

            col = new Column("[a].[projectID]", "projectID", Column.ColumnType.Numeric);
            col.AppearInStandardSearch = false;
            col.DisplayHelp = false;
            col.Description = Resources.Organization.TitleProjectName;
            this.Cols.Add(col);

        }
    }
}