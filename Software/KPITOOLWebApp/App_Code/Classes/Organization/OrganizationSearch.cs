using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using SearchComponent;

namespace Artexacta.App.Organization
{
    /// <summary>
    /// Summary description for OrganizationSearch
    /// </summary>
    public class OrganizationSearch : ConfigColumns
    {
        public OrganizationSearch()
        {
            Column col = new Column("[o].[name]", "name", Column.ColumnType.String);
            col.AppearInStandardSearch = true;
            col.DisplayHelp = true;
            col.Description = Resources.Organization.TitleOrganizationName;
            this.Cols.Add(col);

            col = new Column("[o].[organizationID]", "organizationID", Column.ColumnType.Numeric);
            col.AppearInStandardSearch = false;
            col.DisplayHelp = false;
            col.Description = Resources.Organization.TitleOrganizationName;
            this.Cols.Add(col);
        }
    }
}