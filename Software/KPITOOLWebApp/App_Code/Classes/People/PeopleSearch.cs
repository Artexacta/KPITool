using SearchComponent;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for PeopleSearch
/// </summary>
public class PeopleSearch : ConfigColumns
{
    public PeopleSearch(): base()
	{
        Column col = new Column("[p].[name]", "name", Column.ColumnType.String);
        col.AppearInStandardSearch = true;
        col.DisplayHelp = true;
        col.Description = Resources.People.LabelName;
        this.Cols.Add(col);

        col = new Column("[p].[personID]", "personId", Column.ColumnType.Numeric);
        col.AppearInStandardSearch = false;
        col.DisplayHelp = false;
        col.Description = "PersonID";
        this.Cols.Add(col);

        col = new Column("[p].[id]", "Id", Column.ColumnType.String);
        col.AppearInStandardSearch = true;
        col.DisplayHelp = true;
        col.Description = Resources.People.LabelDocIdentification;
        this.Cols.Add(col);
        

        col = new Column("[p].[organizationID]", "organizationID", Column.ColumnType.Numeric);
        col.AppearInStandardSearch = false;
        col.DisplayHelp = false;
        col.Description = Resources.Organization.TitleOrganizationName;
        this.Cols.Add(col);

        col = new Column("[p].[areaID]", "areaId", Column.ColumnType.Numeric);
        col.AppearInStandardSearch = false;
        col.DisplayHelp = false;
        col.Description = Resources.Organization.TitleArea;
        this.Cols.Add(col);

	}
}