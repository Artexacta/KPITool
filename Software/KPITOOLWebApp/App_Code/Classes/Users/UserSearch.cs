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
        Column col = new Column("U.[fullname]", "NombreCompleto", Column.ColumnType.String);
        col.AppearInStandardSearch = true;
        col.DisplayHelp = true;
        this.Cols.Add(col);

        col = new Column("U.[cellphone]", "TelefonoMovil", Column.ColumnType.String);
        col.AppearInStandardSearch = true;
        col.DisplayHelp = true;
        this.Cols.Add(col);

        col = new Column("U.[address]", "Direccion", Column.ColumnType.String);
        col.AppearInStandardSearch = true;
        col.DisplayHelp = true;
        this.Cols.Add(col);

        col = new Column("U.[phonenumber]", "Telefono", Column.ColumnType.String);
        col.AppearInStandardSearch = true;
        col.DisplayHelp = true;
        this.Cols.Add(col);

        col = new Column("U.[username]", "NombreUsuario", Column.ColumnType.String);
        col.AppearInStandardSearch = true;
        col.DisplayHelp = true;
        this.Cols.Add(col);

        col = new Column("U.[email]", "Email", Column.ColumnType.String);
        col.AppearInStandardSearch = true;
        col.DisplayHelp = true;
        this.Cols.Add(col);

        col = new Column("U.[allowExternalAccess]", "AccesoExterno", Column.ColumnType.Boolean);
        col.AppearInStandardSearch = true;
        col.DisplayHelp = true;
        this.Cols.Add(col);
	}
}