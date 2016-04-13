using SearchComponent;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for PersonaSearch
/// </summary>
public class PersonaSearch : ConfigColumns
{
	public PersonaSearch() : base()
	{
        Column col = new Column("[pe].[nombre]", "nombre", Column.ColumnType.String);
        col.AppearInStandardSearch = true;
        col.DisplayHelp = true;
        col.Description = "Nombre completo";
        this.Cols.Add(col);

        col = new Column("[pe].[email]", "email", Column.ColumnType.String);
        col.AppearInStandardSearch = true;
        col.DisplayHelp = true;
        col.Description = "Correo electrónico";
        this.Cols.Add(col);

        col = new Column("[pe].[estadoCivil]", "estadoCivil", Column.ColumnType.String);
        col.AppearInStandardSearch = true;
        col.DisplayHelp = true;
        col.Description = "Estado Civil";
        this.Cols.Add(col);

        col = new Column("[pe].[paisId]", "pais", Column.ColumnType.String);
        col.AppearInStandardSearch = false;
        col.DisplayHelp = false;
        col.Description = "País";
        this.Cols.Add(col);

        col = new Column("[pe].[genero]", "genero", Column.ColumnType.String);
        col.AppearInStandardSearch = true;
        col.DisplayHelp = true;
        col.Description = "Género";
        this.Cols.Add(col);

        col = new Column("[pe].[salario]", "salario", Column.ColumnType.Numeric);
        col.AppearInStandardSearch = true;
        col.DisplayHelp = true;
        col.Description = "Salario";
        this.Cols.Add(col);

	}
}