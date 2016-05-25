using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using SearchComponent;

namespace Artexacta.App.Project
{
    /// <summary>
    /// Summary description for ProjectSearch
    /// </summary>
    public class ProjectSearch : ConfigColumns
    {
        public ProjectSearch()
        {
            Column col = new Column("[p].[name]", "name", Column.ColumnType.String);
            col.AppearInStandardSearch = true;
            col.DisplayHelp = true;
            col.Description = Resources.Organization.TitleProjectName;
            this.Cols.Add(col);

            col = new Column("[p].[organizationID]", "organizationID", Column.ColumnType.Numeric);
            col.AppearInStandardSearch = false;
            col.DisplayHelp = false;
            col.Description = Resources.Organization.TitleOrganizationName;
            this.Cols.Add(col);

            col = new Column("[p].[projectID]", "ProjectID", Column.ColumnType.Numeric);
            col.AppearInStandardSearch = false;
            col.DisplayHelp = false;
            col.Description = Resources.Organization.TitleProjectName;
            this.Cols.Add(col);
        }
    }
}