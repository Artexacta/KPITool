using SearchComponent;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for UserSearch
/// </summary>
public class UserSearch : ConfigColumns
{
	public UserSearch() : base()
	{
        Column col = new Column("U.[fullname]", Resources.UserData.FullNameKeySearch, Column.ColumnType.String);
        col.AppearInStandardSearch = true;
        col.DisplayHelp = true;
        this.Cols.Add(col);

        col = new Column("U.[cellphone]", Resources.UserData.MobilePhoneKeySearch, Column.ColumnType.String);
        col.AppearInStandardSearch = true;
        col.DisplayHelp = true;
        this.Cols.Add(col);

        col = new Column("U.[address]", Resources.UserData.AddressKeySearch, Column.ColumnType.String);
        col.AppearInStandardSearch = true;
        col.DisplayHelp = true;
        this.Cols.Add(col);

        col = new Column("U.[phonenumber]", Resources.UserData.PhoneNumberKeySearch, Column.ColumnType.String);
        col.AppearInStandardSearch = true;
        col.DisplayHelp = true;
        this.Cols.Add(col);

        col = new Column("U.[username]", Resources.UserData.UserNameKeySearch, Column.ColumnType.String);
        col.AppearInStandardSearch = true;
        col.DisplayHelp = true;
        this.Cols.Add(col);

        col = new Column("U.[email]", Resources.UserData.EmailKeySearch, Column.ColumnType.String);
        col.AppearInStandardSearch = true;
        col.DisplayHelp = true;
        this.Cols.Add(col);

        col = new Column("U.[allowExternalAccess]", Resources.UserData.ExternalAccesKeyName, Column.ColumnType.Boolean);
        col.AppearInStandardSearch = true;
        col.DisplayHelp = true;
        this.Cols.Add(col);
	}
}