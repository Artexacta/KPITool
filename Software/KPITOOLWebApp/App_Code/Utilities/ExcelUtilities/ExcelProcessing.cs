using OfficeOpenXml;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;

namespace Artexacta.App.Utilities.ExcelProcessing
{
    public static class ExStringUtilities
    {
        public static bool AreAnyDuplicates<T>(this IEnumerable<T> list)
        {
            var hashset = new HashSet<T>();
            return list.Any(e => !hashset.Add(e));
        }
    }

    public enum ExColumnType { Integer, Decimal, Double, Date, String, List };

    public abstract class ExColumn
    {
        public ExColumn()
        {
            _type = ExColumnType.Integer;
            _name = "";
            _mandatory = false;
        }

        protected String _name;
        protected ExColumnType _type;
        protected bool _mandatory;
        protected bool _key;

        public bool IsKey
        {
            get { return _key; }
            set { _key = value; }
        }

        public bool Mandatory
        {
            get { return _mandatory; }
            set { _mandatory = value; }
        }

        public ExColumnType Type
        {
            get { return _type; }
            set { _type = value; }
        }

        public String Name
        {
            get { return _name; }
            set { _name = value; }
        }

        abstract public Type GetColumnSystemType();

        abstract public bool ValueIsAcceptable(object value);

        abstract public object ConvertValueToObjectToStoreInDataSet(object value);
    }

    public class BooleanExColumn : ExColumn
    {
        public BooleanExColumn()
            : base()
        {
        }

        public BooleanExColumn(String name, bool mandatory, bool isKey)
        {
            _name = name;
            _mandatory = mandatory;
            _type = ExColumnType.Integer;
            _key = isKey;
        }

        public override Type GetColumnSystemType()
        {
            return typeof(System.Boolean);
        }

        public override bool ValueIsAcceptable(object value)
        {
            if (value == null)
                return true;

            if (value is Boolean)
                return true;

            if (value is String && String.IsNullOrEmpty((string)value))
                // Valores "" se consideran vaciós en booleans
                return true;

            if (!(value is bool))
                return false;

            return true;
        }

        public override object ConvertValueToObjectToStoreInDataSet(object value)
        {
            // Los enteros en Excel son en realidad Doubles.  Necesitamos convertirlo a entero
            if (value == null || (value is String && ((string)value) == ""))
                return DBNull.Value;

            if (!(value is Boolean))
                throw new ArgumentException("Invalid boolean parameter passed");

            return (bool)value;
        }
    }

    public class IntegerExColumn : ExColumn
    {
        public IntegerExColumn()
            : base()
        {
        }

        private bool _emptyAsNull;

        public bool TreatEmptyAsNull
        {
            get { return _emptyAsNull; }
            set { _emptyAsNull = value; }
        }

        public IntegerExColumn(String name, bool mandatory, bool isKey, bool treatEmptyAsNull)
        {
            _name = name;
            _mandatory = mandatory;
            _type = ExColumnType.Integer;
            _key = isKey;
            _emptyAsNull = treatEmptyAsNull;
        }

        public override Type GetColumnSystemType()
        {
            return typeof(System.Int32);
        }

        public override bool ValueIsAcceptable(object value)
        {
            if (value == null)
                return true;

            if (value is Int32)
                return true;

            if (value is String && String.IsNullOrEmpty((string)value))
                // Valores "" se consideran vaciós en enteros
                return true;

            if (!(value is double))
                return false;

            if (Double.IsNaN((double)value))
                return false;

            if (!(((double)value % 1) == 0))
                //  Hay un número pero no es entero
                return false;

            return true;
        }

        public override object ConvertValueToObjectToStoreInDataSet(object value)
        {
            // Los enteros en Excel son en realidad Doubles.  Necesitamos convertirlo a entero
            if (value == null || (value is String && ((string)value) == ""))
                if (TreatEmptyAsNull)
                    return DBNull.Value;
                else
                    return 0;

            return Convert.ToInt32(value);
        }
    }

    public class DecimalExColumn : ExColumn
    {
        public DecimalExColumn()
            : base()
        {
        }

        private bool _emptyAsNull;

        public bool TreatEmptyAsNull
        {
            get { return _emptyAsNull; }
            set { _emptyAsNull = value; }
        }

        public DecimalExColumn(String name, bool mandatory, bool isKey, bool treatEmptyAsNull)
        {
            _name = name;
            _mandatory = mandatory;
            _type = ExColumnType.Decimal;
            _key = isKey;
            _emptyAsNull = treatEmptyAsNull;
        }

        public override Type GetColumnSystemType()
        {
            return typeof(System.Decimal);
        }

        public override bool ValueIsAcceptable(object value)
        {
            if (value == null)
                return true;

            if (value is Decimal)
                return true;

            if (value is String && String.IsNullOrEmpty((string)value))
                // Valores "" se consideran vaciós en decimales
                return true;

            if (!(value is double))
                return false;

            if (Double.IsNaN((double)value))
                return false;

            try
            {
                // Probamos convertir este número a Decimal. Si el número es muy grande, no es un decimal válido
                decimal x = Convert.ToDecimal(value);
            }
            catch
            {
                return false;
            }

            return true;
        }

        public override object ConvertValueToObjectToStoreInDataSet(object value)
        {
            // Los decimales en Excel son en realidad Doubles.  Necesitamos convertirlo a decimal
            if (value == null || (value is String && ((string)value) == ""))
                if (TreatEmptyAsNull)
                    return DBNull.Value;
                else
                    return 0m;

            return Convert.ToDecimal(value);
        }
    }

    public class DoubleExColumn : ExColumn
    {
        public DoubleExColumn()
            : base()
        {
        }

        private bool _emptyAsNull;

        public bool TreatEmptyAsNull
        {
            get { return _emptyAsNull; }
            set { _emptyAsNull = value; }
        }

        public DoubleExColumn(String name, bool mandatory, bool isKey, bool treatEmptyAsNull)
        {
            _name = name;
            _mandatory = mandatory;
            _type = ExColumnType.Double;
            _key = isKey;
            _emptyAsNull = treatEmptyAsNull;
        }

        public override Type GetColumnSystemType()
        {
            return typeof(System.Double);
        }
        public override bool ValueIsAcceptable(object value)
        {
            if (value == null)
                return true;

            if (value is Double)
                return true;

            if (value is String && String.IsNullOrEmpty((string)value))
                // Valores "" se consideran vaciós en dobles
                return true;

            if (!(value is double))
                return false;

            if (Double.IsNaN((double)value))
                return false;

            return true;
        }

        public override object ConvertValueToObjectToStoreInDataSet(object value)
        {
            if (value == null || (value is String && ((string)value) == ""))
                if (TreatEmptyAsNull)
                    return DBNull.Value;
                else
                    return 0d;

            if (!(value is double))
                throw new ArgumentException("Invalid double value passed.");

            return (double)value;
        }
    }

    public class StringExColumn : ExColumn
    {
        public StringExColumn()
            : base()
        {
        }

        public StringExColumn(String name, bool mandatory, bool isKey)
        {
            _name = name;
            _mandatory = mandatory;
            _type = ExColumnType.String;
            _key = isKey;
        }

        public override Type GetColumnSystemType()
        {
            return typeof(System.String);
        }

        public override bool ValueIsAcceptable(object value)
        {
            if (value == null)
                // Valores nulos se consideran vaciós en strings
                return true;

            if (value is String && String.IsNullOrEmpty((string)value))
                // Valores "" se consideran vaciós en strings
                return true;

            return true;
        }

        public override object ConvertValueToObjectToStoreInDataSet(object value)
        {
            if (value == null)
                return DBNull.Value;

            if (value is String)
            {
                return value;
            }
            else
            {
                return Convert.ToString(value);
            }
        }
    }

    public class GeoRefExColumn : ExColumn
    {
        public GeoRefExColumn()
            : base()
        {
        }

        public GeoRefExColumn(String name, bool mandatory, bool isKey)
        {
            _name = name;
            _mandatory = mandatory;
            _type = ExColumnType.String;
            _key = isKey;
        }

        public override Type GetColumnSystemType()
        {
            return typeof(System.String);
        }

        public override bool ValueIsAcceptable(object value)
        {
            if (value == null)
                // Valores nulos se consideran vaciós en GeoRefs
                return true;

            if (value is String && String.IsNullOrEmpty((string)value))
                // Valores "" se consideran vaciós en GeoRefs
                return true;

            if (!(value is String))
                // Necesitamos un string obligatorio
                return false;

            Regex format1 = new Regex("^([-+]?\\d{1,2}([.]\\d+)?),\\s*([-+]?\\d{1,3}([.]\\d+)?)$");
            Regex format2 = new Regex("^(N|S)\\s+(\\d+)\\s+(\\d+)\\s+(\\d+|\\d+.\\d+)\\s*,\\s*(W|E)\\s+(\\d+)\\s+(\\d+)\\s+(\\d+|\\d+.\\d+)$");

            Match matches = format1.Match((string)value);
            if (matches.Success)
            {
                // El formato coordenadas es el par latitud y longitud, con signo negativo para las direcciones de latitud sur y longitud oeste, 
                // separados por el símbolo coma. Los valores válidos para la latitud están entre -90.0° y 90.0°, 
                // mientras que para la longitud están entre -180.0° y 180.0°

                string first = matches.Groups[1].Value;
                string second = matches.Groups[3].Value;

                // Latitud es -90 to +90
                decimal lat = Convert.ToDecimal(first, CultureInfo.InvariantCulture);
                if (lat < -90 || lat > 90)
                    return false;

                // Longitud is -180 to +180 
                decimal lon = Convert.ToDecimal(second, CultureInfo.InvariantCulture);
                if (lon < -180 || lon > 180)
                    return false;

                return true;
            }

            matches = format2.Match((string)value);
            if (matches.Success)
            {
                // Los grados se expresan en números enteros sin signo entre 0 y 90 para la latitud y de 0 a 180 para la longitud
                // Los minutos se expresan en números enteros sin signo entre 0 y 59
                // Los segundos se expresan en números decimales sin signo, entre 0 (ó 0.0000) y 59.9999.

                // Latitud es 0 a 90
                int lat = Convert.ToInt32(matches.Groups[2].Value);
                if (lat < 0 || lat > 90)
                    return false;

                // Longitud es 0 to 180
                int lon = Convert.ToInt32(matches.Groups[6].Value, CultureInfo.InvariantCulture);
                if (lon < 0 || lon > 180)
                    return false;

                // Minutos es 0 a 59
                int min = Convert.ToInt32(matches.Groups[3].Value, CultureInfo.InvariantCulture);
                if (min < 0 || min > 59)
                    return false;
                min = Convert.ToInt32(matches.Groups[7].Value, CultureInfo.InvariantCulture);
                if (min < 0 || min > 59)
                    return false;

                // Segundos es 0 a 59.9999...
                decimal sec = Convert.ToDecimal(matches.Groups[4].Value, CultureInfo.InvariantCulture);
                if (sec < 0 || sec >= 60)
                    return false;
                sec = Convert.ToDecimal(matches.Groups[8].Value, CultureInfo.InvariantCulture);
                if (sec < 0 || sec >= 60)
                    return false;

                return true;
            }

            return false;
        }

        public override object ConvertValueToObjectToStoreInDataSet(object value)
        {
            if (value == null)
                return DBNull.Value;

            if (!(value is String))
                throw new ArgumentException("Invalid Geo Tag passed");

            Regex format1 = new Regex("^([-+]?\\d{1,2}([.]\\d+)?),\\s*([-+]?\\d{1,3}([.]\\d+)?)$");
            Regex format2 = new Regex("^(N|S)\\s+(\\d+)\\s+(\\d+)\\s+(\\d+|\\d+.\\d+)\\s*,\\s*(W|E)\\s+(\\d+)\\s+(\\d+)\\s+(\\d+|\\d+.\\d+)$");

            Match matches = format1.Match((string)value);
            if (matches.Success)
            {
                return value;
            }

            matches = format2.Match((string)value);
            if (matches.Success)
            {
                // Los grados se expresan en números enteros sin signo entre 0 y 90 para la latitud y de 0 a 180 para la longitud
                // Los minutos se expresan en números enteros sin signo entre 0 y 59
                // Los segundos se expresan en números decimales sin signo, entre 0 (ó 0.0000) y 59.9999.

                int lat = Convert.ToInt32(matches.Groups[2].Value);
                int latMin = Convert.ToInt32(matches.Groups[3].Value);
                decimal latSec = Convert.ToDecimal(matches.Groups[4].Value, CultureInfo.InvariantCulture);

                int lon = Convert.ToInt32(matches.Groups[6].Value);
                int lonMin = Convert.ToInt32(matches.Groups[7].Value);
                decimal lonSec = Convert.ToDecimal(matches.Groups[8].Value, CultureInfo.InvariantCulture);

                int latOperator = (matches.Groups[1].Value == "N" ? 1 : -1);
                int longOperator = (matches.Groups[5].Value == "W" ? -1 : 1);

                decimal latNumber = Convert.ToDecimal(lat) + Convert.ToDecimal(latMin) / 60m + latSec / 3600m;
                decimal lonNumber = Convert.ToDecimal(lon) + Convert.ToDecimal(lonMin) / 60m + lonSec / 3600m;

                string result = (latNumber * latOperator).ToString("##0.000000") + ", " + (lonNumber * longOperator).ToString("##0.000000#");
                return result;
            }

            throw new ArgumentException("Invalid GeoTag passed");
        }
    }

    public class DateExColumn : ExColumn
    {
        public DateExColumn()
            : base()
        {
        }

        public DateExColumn(String name, bool mandatory, bool isKey)
        {
            _name = name;
            _mandatory = mandatory;
            _type = ExColumnType.Date;
            _key = isKey;
        }

        public override Type GetColumnSystemType()
        {
            return typeof(System.DateTime);
        }

        public override bool ValueIsAcceptable(object value)
        {
            if (value == null)
                // Valores null se consideran vaciós en fechas
                return true;

            if (value is String && String.IsNullOrEmpty((string)value))
                // Valores "" se consideran vaciós en fechas
                return true;

            if (!(value is DateTime))
                return false;

            return true;
        }

        public override object ConvertValueToObjectToStoreInDataSet(object value)
        {
            if (value == null || (value is String && ((string)value) == ""))
                return DBNull.Value;

            if (!(value is DateTime))
                throw new ArgumentException("Invalid date object passed");

            return value;
        }
    }

    public class ListExColumn : ExColumn
    {
        public ListExColumn()
            : base()
        {
        }

        public ListExColumn(String name, bool mandatory, bool isKey, List<String> allowedValues)
        {
            _name = name;
            _mandatory = mandatory;
            _type = ExColumnType.List;
            _key = isKey;
            _allowed = allowedValues;
        }

        private List<String> _allowed;

        public List<String> AllowedValues
        {
            get { return _allowed; }
            set { _allowed = value; }
        }

        public override Type GetColumnSystemType()
        {
            return typeof(System.String);
        }

        public override bool ValueIsAcceptable(object value)
        {
            if (value == null)
                // Valores nulos se consideran vaciós en listas
                return true;

            if (value is String && String.IsNullOrEmpty((string)value))
                // Valores "" se consideran vaciós en listas
                return true;

            string convertedValue = "";

            if (value is String)
                convertedValue = (string)value;
            else
                // convertimos lo que tengamos a string.... en principio esto solo para con números
                convertedValue = value.ToString();

            if (!AllowedValues.Contains(convertedValue))
                // El valor está fuera de la lista permitida
                return false;

            return true;
        }

        public override object ConvertValueToObjectToStoreInDataSet(object value)
        {
            if (value == null)
                return DBNull.Value;

            if (!(value is String))
                throw new ArgumentException("Invalid string value passed.");

            return value;
        }
    }

    public class InclusiveListExColumn : ExColumn
    {
        public InclusiveListExColumn()
            : base()
        {
        }

        public InclusiveListExColumn(String name, bool mandatory, bool isKey, List<String> allowedValues)
        {
            _name = name;
            _mandatory = mandatory;
            _type = ExColumnType.List;
            _key = isKey;
            _allowed = allowedValues;
        }

        private List<String> _allowed;

        public List<String> AllowedValues
        {
            get { return _allowed; }
            set { _allowed = value; }
        }

        public override Type GetColumnSystemType()
        {
            return typeof(System.String);
        }

        public override bool ValueIsAcceptable(object value)
        {
            if (value == null)
                // Valores nulos se consideran vaciós en listas
                return true;

            if (value is String && String.IsNullOrEmpty((string)value))
                // Valores "" se consideran vaciós en listas
                return true;

            string convertedValue = "";

            if (value is String)
                convertedValue = (string)value;
            else
                // convertimos lo que tengamos a string.... en principio esto solo para con números
                convertedValue = value.ToString();

            // La lista inclusivas son separadas por comas, en el formato XXX, YYY, ZZZ donde cada uno tiene que estár en la lista.

            List<String> values = ((string)value).Split(new char[] { ',' }).Select(v => v.Trim()).ToList();

            foreach (string val in values)
            {
                if (!AllowedValues.Contains(((string)val).Trim()))
                    // El valor está fuera de la lista permitida
                    return false;
            }

            if (ExStringUtilities.AreAnyDuplicates<String>(values))
                return false;

            return true;
        }

        public override object ConvertValueToObjectToStoreInDataSet(object value)
        {
            if (value == null)
                return DBNull.Value;

            if (!(value is String))
                throw new ArgumentException("Invalid string value passed.");

            // Convertimos la lista a una lista separada por comas SIN espacios raros

            String[] values = ((string)value).Split(new char[] { ',' });

            StringBuilder newList = new StringBuilder();

            foreach (string val in values)
            {
                if (newList.Length == 0)
                    newList.Append(val.Trim());
                else
                    newList.Append(", " + val.Trim());
            }

            return value.ToString();
        }
    }

    public class ExProcess
    {
        /// <summary>
        /// Toma dos datasets, que tengan en común una serie de columnas con el mismo nombre y mismo tipo,
        /// y las compara.  Devuelve una lista de filas eliminadas en el segundo data set, una lista de las 
        /// filas eliminadas en el primer dataset, y un dataset con las filas que tuviron cambios.   
        /// En el DataSet de los cambios, para cada Row del DataSet se incluye la lista de las columnas
        /// que cambiaron separadas con |.
        /// </summary>
        /// <param name="dataSet1">El primer dataset a comparar (old).  Debe tener las llaves corréctamente definidas.</param>
        /// <param name="dataSet2">El segundo dataset a comparar (new). Debe tener las llaves corréctamente definidas.</param>
        /// <param name="columnsToCompare">Las columnas que tenemos que comparar. Ignoramos las otras columnas</param>
        /// <param name="keysInDataSet1Only">Una lista de las llaves que están en el primer dataset y no en el segundo (eliminadas en el segundo dataset)</param>
        /// <param name="keysInDataSet2Only">Una lista de las llaves que están en el segundo dataset y no en el primero (añadidas en el segundo dataset)</param>
        /// <returns></returns>
        public static DataSet CompareDataSets(DataSet dataSet1, DataSet dataSet2,
            List<String> columnsToCompare, List<String> keysInDataSet1Only, List<String> keysInDataSet2Only)
        {
            DataColumn[] table1Keys = dataSet1.Tables[0].PrimaryKey;
            DataColumn[] table2Keys = dataSet2.Tables[0].PrimaryKey;

            if (table1Keys == null || table1Keys.Count() == 0)
                throw new ArgumentException("First data set does not have keys defined");

            if (table2Keys == null || table2Keys.Count() == 0)
                throw new ArgumentException("Second data set does not have keys defined");

            if (table1Keys.Count() != table2Keys.Count())
                throw new ArgumentException("The datasets do not have the same keys.  They are not the same size.");

            for (int i = 0; i < table1Keys.Count(); i++)
            {
                if (table1Keys[i].ColumnName != table2Keys[i].ColumnName)
                    throw new ArgumentException("The datasets do not have the same keys. The key " + i.ToString() +
                        " is \"" + table1Keys[i].ColumnName + "\" in the first dataset and \"" + table2Keys[i].ColumnName + "\" in the second.");

                if (table1Keys[i].DataType != table2Keys[i].DataType)
                    throw new ArgumentException("The datasets do not have the same types in the keys. The key " +
                        "\"" + table1Keys[i].ColumnName + "\" is of type " + table1Keys[i].DataType.ToString() +
                        " in the first dataset and of type " + table2Keys[i].DataType.ToString() + " in the second");
            }

            // Verificar si la lista de columnas existe en ambos datasets con el mismo tipo
            foreach (string column in columnsToCompare)
            {
                if (!dataSet1.Tables[0].Columns.Contains(column))
                    throw new ArgumentException("The column \"" + column + "\" does not exist in the firsts dataset");

                if (!dataSet2.Tables[0].Columns.Contains(column))
                    throw new ArgumentException("The column \"" + column + "\" does not exist in the second dataset");

                if (dataSet1.Tables[0].Columns[column].DataType != dataSet2.Tables[0].Columns[column].DataType)
                {
                    throw new ArgumentException("The datasets do not have the same types for the columns. The column " +
                        "\"" + column + "\" is of type " + dataSet1.Tables[0].Columns[column].DataType.ToString() +
                        " in the first dataset and of type " + dataSet2.Tables[0].Columns[column].DataType.ToString() + " in the second");
                }
            }

            Hashtable rowCounts = new Hashtable();

            // En rowCounts ponemos un 1 en todas los Keys donde en DataSet1 hay algun valor
            foreach (DataRow row in dataSet1.Tables[0].Rows)
            {
                // Construir la llave combinada de todos los Keys
                StringBuilder keyText = new StringBuilder();
                foreach (DataColumn col in table1Keys)
                {
                    if (keyText.Length == 0)
                        keyText.Append(row[col.ColumnName]);
                    else
                    {
                        keyText.Append(" - ");
                        keyText.Append(row[col.ColumnName]);
                    }
                }

                rowCounts.Add(keyText.ToString(), 1);
            }

            // En rowCounts le quitamos un 1 en todas los Keys donde en DataSet2 hay algun valor
            foreach (DataRow row in dataSet2.Tables[0].Rows)
            {
                // Construir la llave combinada de todos los Keys
                StringBuilder keyText = new StringBuilder();
                foreach (DataColumn col in table2Keys)
                {
                    if (keyText.Length == 0)
                        keyText.Append(row[col.ColumnName]);
                    else
                    {
                        keyText.Append(" - ");
                        keyText.Append(row[col.ColumnName]);
                    }
                }

                if (rowCounts.ContainsKey(keyText.ToString()))
                    rowCounts[keyText.ToString()] = 0;
                else
                    rowCounts.Add(keyText.ToString(), -1);
            }

            // Ahora en rowCounts hay 1 donde hay registros en DataSet1 que no están en DataSet2, -1 donde hay
            // registros que están en DataSet2 pero no en DataSet1 y 0 donde hay registros en ambos.

            // Construimos una lista de los Keys que están el DataSet1 y que nó están en el DataSet2
            // Construimos una lista de los Keys que están el DataSet2 y que nó están en el DataSet1
            keysInDataSet1Only.Clear();
            keysInDataSet2Only.Clear();

            foreach (string key in rowCounts.Keys)
            {
                if ((int)rowCounts[key] == -1)
                    keysInDataSet2Only.Add(key);
                else if ((int)rowCounts[key] == 1)
                    keysInDataSet1Only.Add(key);
            }

            // Ahora necesitamos construir dos Hashtables, cada uno con una referencia al DataRow de cada key
            Hashtable dataRowsHash1 = new Hashtable();
            foreach (DataRow row in dataSet1.Tables[0].Rows)
            {
                // Construir la llave combinada de todos los Keys
                StringBuilder keyText = new StringBuilder();
                foreach (DataColumn col in table1Keys)
                {
                    if (keyText.Length == 0)
                        keyText.Append(row[col.ColumnName]);
                    else
                    {
                        keyText.Append(" - ");
                        keyText.Append(row[col.ColumnName]);
                    }
                }

                dataRowsHash1.Add(keyText.ToString(), row);
            }

            Hashtable dataRowsHash2 = new Hashtable();
            foreach (DataRow row in dataSet2.Tables[0].Rows)
            {
                // Construir la llave combinada de todos los Keys
                StringBuilder keyText = new StringBuilder();
                foreach (DataColumn col in table2Keys)
                {
                    if (keyText.Length == 0)
                        keyText.Append(row[col.ColumnName]);
                    else
                    {
                        keyText.Append(" - ");
                        keyText.Append(row[col.ColumnName]);
                    }
                }

                dataRowsHash2.Add(keyText.ToString(), row);
            }

            // Ahora pasamos por todos los rows que tienen datos en ambos DataSets, comparando los valores de antes y despues
            // y construimos un DataSet

            DataTable changedTable = new DataTable("CHANGES");

            foreach (DataColumn col in table1Keys)
            {
                changedTable.Columns.Add(col.ColumnName, dataSet1.Tables[0].Columns[col.ColumnName].DataType);
            }

            foreach (string col in columnsToCompare)
            {
                changedTable.Columns.Add(col, dataSet1.Tables[0].Columns[col].DataType);
            }

            foreach (string key in rowCounts.Keys)
            {
                // Solo nos interesa donde hay datos en ambos data sets
                if ((int)rowCounts[key] != 0)
                    continue;

                object value1 = null;
                object value2 = null;

                bool rowchanged = false;

                DataRow row = changedTable.NewRow();

                DataRow dr1 = (DataRow)dataRowsHash1[key];
                DataRow dr2 = (DataRow)dataRowsHash2[key];

                foreach (DataColumn keyColum in table2Keys)
                {
                    row[keyColum.ColumnName] = dr2[keyColum.ColumnName];
                }

                foreach (string col in columnsToCompare)
                {
                    value1 = dr1[col];
                    value2 = dr2[col];

                    if (dataSet2.Tables[0].Columns[col].DataType == typeof(System.Int32))
                    {
                        if (value2 == null || value2.GetType() != typeof(System.Int32))
                            row[col] = DBNull.Value;
                        else
                            row[col] = value2;
                    }
                    else if (dataSet2.Tables[0].Columns[col].DataType == typeof(System.Double))
                    {
                        if (value2 == null || value2.GetType() != typeof(System.Double))
                            row[col] = DBNull.Value;
                        else
                            row[col] = value2;
                    }
                    else if (dataSet2.Tables[0].Columns[col].DataType == typeof(System.Decimal))
                    {
                        if (value2 == null || value2.GetType() != typeof(System.Decimal))
                            row[col] = DBNull.Value;
                        else
                            row[col] = value2;
                    }
                    else if (dataSet2.Tables[0].Columns[col].DataType == typeof(System.DateTime))
                    {
                        if (value2 == null || value2.GetType() != typeof(System.DateTime))
                            row[col] = DBNull.Value;
                        else
                            row[col] = value2;
                    }
                    else if (dataSet2.Tables[0].Columns[col].DataType == typeof(System.String))
                    {
                        if (value2 == null || value2.GetType() != typeof(System.String))
                            row[col] = DBNull.Value;
                        else
                            row[col] = value2;
                    }
                    else
                    {
                        throw new Exception("Unsuported data type");
                    }


                    if (!ObjectsAreEqual(value1, value2))
                    {
                        if (String.IsNullOrWhiteSpace(row.RowError))
                            row.RowError = col;
                        else
                            row.RowError = row.RowError + "|" + col;
                        rowchanged = true;
                    }
                }

                if (rowchanged)
                {
                    // Si hubo cambios, grabamos la fila en el dataset de cambios... y caso contrario ignoramos la fila
                    changedTable.Rows.Add(row);
                }

                // Necesitamos decirle al DataSet que tenemos llaves en algunos de los campos
                DataColumn[] keyColumn = new DataColumn[keysInDataSet2Only.Count];
                int i = 0;
                foreach (string col in keysInDataSet2Only)
                {
                    keyColumn[i++] = changedTable.Columns[col];
                }
                changedTable.PrimaryKey = keyColumn;

            }

            DataSet newDataSet = new DataSet();
            newDataSet.Tables.Add(changedTable);

            return newDataSet;
        }

        public static DataSet CompareDataSets(DataSet dataSet1, DataSet dataSet2,
            List<String> columnsToCompare, List<String> keysInDataSet1Only, List<String> keysInDataSet2Only, ref DataSet DataSetInDataSet2Only)
        {
            DataColumn[] table1Keys = dataSet1.Tables[0].PrimaryKey;
            DataColumn[] table2Keys = dataSet2.Tables[0].PrimaryKey;

            if (table1Keys == null || table1Keys.Count() == 0)
                throw new ArgumentException("First data set does not have keys defined");

            if (table2Keys == null || table2Keys.Count() == 0)
                throw new ArgumentException("Second data set does not have keys defined");

            if (table1Keys.Count() != table2Keys.Count())
                throw new ArgumentException("The datasets do not have the same keys.  They are not the same size.");

            for (int i = 0; i < table1Keys.Count(); i++)
            {
                if (table1Keys[i].ColumnName != table2Keys[i].ColumnName)
                    throw new ArgumentException("The datasets do not have the same keys. The key " + i.ToString() +
                        " is \"" + table1Keys[i].ColumnName + "\" in the first dataset and \"" + table2Keys[i].ColumnName + "\" in the second.");

                if (table1Keys[i].DataType != table2Keys[i].DataType)
                    throw new ArgumentException("The datasets do not have the same types in the keys. The key " +
                        "\"" + table1Keys[i].ColumnName + "\" is of type " + table1Keys[i].DataType.ToString() +
                        " in the first dataset and of type " + table2Keys[i].DataType.ToString() + " in the second");
            }

            // Verificar si la lista de columnas existe en ambos datasets con el mismo tipo
            foreach (string column in columnsToCompare)
            {
                if (!dataSet1.Tables[0].Columns.Contains(column))
                    throw new ArgumentException("The column \"" + column + "\" does not exist in the firsts dataset");

                if (!dataSet2.Tables[0].Columns.Contains(column))
                    throw new ArgumentException("The column \"" + column + "\" does not exist in the second dataset");

                if (dataSet1.Tables[0].Columns[column].DataType != dataSet2.Tables[0].Columns[column].DataType)
                {
                    throw new ArgumentException("The datasets do not have the same types for the columns. The column " +
                        "\"" + column + "\" is of type " + dataSet1.Tables[0].Columns[column].DataType.ToString() +
                        " in the first dataset and of type " + dataSet2.Tables[0].Columns[column].DataType.ToString() + " in the second");
                }
            }

            Hashtable rowCounts = new Hashtable();

            // En rowCounts ponemos un 1 en todas los Keys donde en DataSet1 hay algun valor
            foreach (DataRow row in dataSet1.Tables[0].Rows)
            {
                // Construir la llave combinada de todos los Keys
                StringBuilder keyText = new StringBuilder();
                foreach (DataColumn col in table1Keys)
                {
                    if (keyText.Length == 0)
                        keyText.Append(row[col.ColumnName]);
                    else
                    {
                        keyText.Append(" - ");
                        keyText.Append(row[col.ColumnName]);
                    }
                }

                rowCounts.Add(keyText.ToString(), 1);
            }

            // En rowCounts le quitamos un 1 en todas los Keys donde en DataSet2 hay algun valor
            foreach (DataRow row in dataSet2.Tables[0].Rows)
            {
                // Construir la llave combinada de todos los Keys
                StringBuilder keyText = new StringBuilder();
                foreach (DataColumn col in table2Keys)
                {
                    if (keyText.Length == 0)
                        keyText.Append(row[col.ColumnName]);
                    else
                    {
                        keyText.Append(" - ");
                        keyText.Append(row[col.ColumnName]);
                    }
                }

                if (rowCounts.ContainsKey(keyText.ToString()))
                    rowCounts[keyText.ToString()] = 0;
                else
                    rowCounts.Add(keyText.ToString(), -1);
            }

            // Ahora en rowCounts hay 1 donde hay registros en DataSet1 que no están en DataSet2, -1 donde hay
            // registros que están en DataSet2 pero no en DataSet1 y 0 donde hay registros en ambos.

            // Construimos una lista de los Keys que están el DataSet1 y que nó están en el DataSet2
            // Construimos una lista de los Keys que están el DataSet2 y que nó están en el DataSet1
            keysInDataSet1Only.Clear();
            keysInDataSet2Only.Clear();

            foreach (string key in rowCounts.Keys)
            {
                if ((int)rowCounts[key] == -1)
                    keysInDataSet2Only.Add(key);
                else if ((int)rowCounts[key] == 1)
                    keysInDataSet1Only.Add(key);
            }

            // Ahora necesitamos construir dos Hashtables, cada uno con una referencia al DataRow de cada key
            Hashtable dataRowsHash1 = new Hashtable();
            foreach (DataRow row in dataSet1.Tables[0].Rows)
            {
                // Construir la llave combinada de todos los Keys
                StringBuilder keyText = new StringBuilder();
                foreach (DataColumn col in table1Keys)
                {
                    if (keyText.Length == 0)
                        keyText.Append(row[col.ColumnName]);
                    else
                    {
                        keyText.Append(" - ");
                        keyText.Append(row[col.ColumnName]);
                    }
                }

                dataRowsHash1.Add(keyText.ToString(), row);
            }

            Hashtable dataRowsHash2 = new Hashtable();
            foreach (DataRow row in dataSet2.Tables[0].Rows)
            {
                // Construir la llave combinada de todos los Keys
                StringBuilder keyText = new StringBuilder();
                foreach (DataColumn col in table2Keys)
                {
                    if (keyText.Length == 0)
                        keyText.Append(row[col.ColumnName]);
                    else
                    {
                        keyText.Append(" - ");
                        keyText.Append(row[col.ColumnName]);
                    }
                }

                dataRowsHash2.Add(keyText.ToString(), row);
            }

            //Ahora se crea el dataset con los rows nuevos
            DataTable tableinDataSet2Only = new DataTable("NEWS");

            foreach (DataColumn col in table1Keys)
            {
                tableinDataSet2Only.Columns.Add(col.ColumnName, dataSet1.Tables[0].Columns[col.ColumnName].DataType);
            }

            foreach (string col in columnsToCompare)
            {
                tableinDataSet2Only.Columns.Add(col, dataSet1.Tables[0].Columns[col].DataType);
            }

            foreach (string key in rowCounts.Keys)
            {
                if ((int)rowCounts[key] == -1)
                {
                    object value2 = null;

                    DataRow row = tableinDataSet2Only.NewRow();
                    DataRow dr2 = (DataRow)dataRowsHash2[key];

                    try
                    {
                        foreach (DataColumn keyColum in table2Keys)
                        {
                            row[keyColum.ColumnName] = dr2[keyColum.ColumnName];
                        }

                        foreach (string col in columnsToCompare)
                        {
                            value2 = dr2[col];

                            if (dataSet2.Tables[0].Columns[col].DataType == typeof(System.Int32))
                            {
                                if (value2 == null || value2.GetType() != typeof(System.Int32))
                                    row[col] = DBNull.Value;
                                else
                                    row[col] = value2;
                            }
                            else if (dataSet2.Tables[0].Columns[col].DataType == typeof(System.Double))
                            {
                                if (value2 == null || value2.GetType() != typeof(System.Double))
                                    row[col] = DBNull.Value;
                                else
                                    row[col] = value2;
                            }
                            else if (dataSet2.Tables[0].Columns[col].DataType == typeof(System.Decimal))
                            {
                                if (value2 == null || value2.GetType() != typeof(System.Decimal))
                                    row[col] = DBNull.Value;
                                else
                                    row[col] = value2;
                            }
                            else if (dataSet2.Tables[0].Columns[col].DataType == typeof(System.DateTime))
                            {
                                if (value2 == null || value2.GetType() != typeof(System.DateTime))
                                    row[col] = DBNull.Value;
                                else
                                    row[col] = value2;
                            }
                            else if (dataSet2.Tables[0].Columns[col].DataType == typeof(System.String))
                            {
                                if (value2 == null || value2.GetType() != typeof(System.String))
                                    row[col] = DBNull.Value;
                                else
                                    row[col] = value2;
                            }
                            else
                            {
                                throw new Exception("Unsuported data type");
                            }
                        }
                    }
                    catch
                    {
                        //No cumple con los tipos de datos de las columnas
                        continue;
                    }
                    tableinDataSet2Only.Rows.Add(row);
                    keysInDataSet2Only.Remove(row[0].ToString() + " - " + row[1].ToString());
                }
            }

            DataSetInDataSet2Only.Tables.Add(tableinDataSet2Only);

            // Ahora pasamos por todos los rows que tienen datos en ambos DataSets, comparando los valores de antes y despues
            // y construimos un DataSet

            DataTable changedTable = new DataTable("CHANGES");

            foreach (DataColumn col in table1Keys)
            {
                changedTable.Columns.Add(col.ColumnName, dataSet1.Tables[0].Columns[col.ColumnName].DataType);
            }

            foreach (string col in columnsToCompare)
            {
                changedTable.Columns.Add(col, dataSet1.Tables[0].Columns[col].DataType);
            }

            foreach (string key in rowCounts.Keys)
            {
                // Solo nos interesa donde hay datos en ambos data sets
                if ((int)rowCounts[key] != 0)
                    continue;

                object value1 = null;
                object value2 = null;

                bool rowchanged = false;

                DataRow row = changedTable.NewRow();

                DataRow dr1 = (DataRow)dataRowsHash1[key];
                DataRow dr2 = (DataRow)dataRowsHash2[key];

                foreach (DataColumn keyColum in table2Keys)
                {
                    row[keyColum.ColumnName] = dr2[keyColum.ColumnName];
                }

                foreach (string col in columnsToCompare)
                {
                    value1 = dr1[col];
                    value2 = dr2[col];

                    if (dataSet2.Tables[0].Columns[col].DataType == typeof(System.Int32))
                    {
                        if (value2 == null || value2.GetType() != typeof(System.Int32))
                            row[col] = DBNull.Value;
                        else
                            row[col] = value2;
                    }
                    else if (dataSet2.Tables[0].Columns[col].DataType == typeof(System.Double))
                    {
                        if (value2 == null || value2.GetType() != typeof(System.Double))
                            row[col] = DBNull.Value;
                        else
                            row[col] = value2;
                    }
                    else if (dataSet2.Tables[0].Columns[col].DataType == typeof(System.Decimal))
                    {
                        if (value2 == null || value2.GetType() != typeof(System.Decimal))
                            row[col] = DBNull.Value;
                        else
                            row[col] = value2;
                    }
                    else if (dataSet2.Tables[0].Columns[col].DataType == typeof(System.DateTime))
                    {
                        if (value2 == null || value2.GetType() != typeof(System.DateTime))
                            row[col] = DBNull.Value;
                        else
                            row[col] = value2;
                    }
                    else if (dataSet2.Tables[0].Columns[col].DataType == typeof(System.String))
                    {
                        if (value2 == null || value2.GetType() != typeof(System.String))
                            row[col] = DBNull.Value;
                        else
                            row[col] = value2;
                    }
                    else
                    {
                        throw new Exception("Unsuported data type");
                    }


                    if (!ObjectsAreEqual(value1, value2))
                    {
                        if (String.IsNullOrWhiteSpace(row.RowError))
                            row.RowError = col;
                        else
                            row.RowError = row.RowError + "|" + col;
                        rowchanged = true;
                    }
                }

                if (rowchanged)
                {
                    // Si hubo cambios, grabamos la fila en el dataset de cambios... y caso contrario ignoramos la fila
                    changedTable.Rows.Add(row);
                }

                // Necesitamos decirle al DataSet que tenemos llaves en algunos de los campos
                DataColumn[] keyColumn = new DataColumn[keysInDataSet2Only.Count];
                int i = 0;
                foreach (string col in keysInDataSet2Only)
                {
                    keyColumn[i++] = changedTable.Columns[col];
                }
                changedTable.PrimaryKey = keyColumn;

            }

            DataSet newDataSet = new DataSet();
            newDataSet.Tables.Add(changedTable);

            return newDataSet;
        }
        /// <summary>
        /// Lee de un archivo Excel 2007 o superior (con la extensión XLSX, las columnas indicadas.  Leemos sólamente el primer
        /// wokrsheet
        /// </summary>
        /// <param name="theSheet">El Stream de donde sacamos el archivo Excel </param>
        /// <param name="columnsToProcess">La lista de columnas que deseamos extrel del Excel</param>
        /// <param name="errors">La lista de errores.  Si esta lista tiene registros hay errores y no se genera el dataset</param>
        /// <returns>Un DataSet con las columnas indicadas y los datos leìdos del archivo Excel</returns>
        public static DataSet ReadExcelSpreadhseet(Stream theSheet, List<ExColumn> columnsToProcess, List<String> errors)
        {
            using (ExcelPackage package = new ExcelPackage(theSheet))
            {
                // get the first worksheet in the workbook
                ExcelWorksheet worksheet = package.Workbook.Worksheets[1];

                if (worksheet.Dimension == null)
                {
                    errors.Add("El archivo está vacío.");
                    return null;
                }

                ExcelCellAddress topLeft = worksheet.Dimension.Start;
                ExcelCellAddress bottomRight = worksheet.Dimension.End;

                List<String> keys = new List<string>();
                Hashtable columnNumbers = new Hashtable();
                foreach (ExColumn column in columnsToProcess)
                {
                    // Necesitamos acordarnos cuales son las columnas que son llaves para el Data Set
                    if (column.IsKey)
                        keys.Add(column.Name);

                    // We need to find in which Excel columns we have the columns we want to process.  
                    // We currently have names and we need column numbers. 
                    // We will make a pass at the data looking for them.  In the hash table we will 
                    // record the column numbers. 
                    columnNumbers.Add(column.Name, 0);
                }

                for (int i = topLeft.Column; i <= bottomRight.Column; i++)
                {
                    string columnTitle = GetStringValueFromCell(worksheet.Cells[topLeft.Row, i].Value);
                    if (!String.IsNullOrWhiteSpace(columnTitle) && columnNumbers.ContainsKey(columnTitle))
                    {
                        if ((int)columnNumbers[columnTitle] > 0)
                            // we already saw this column.  It's a duplicate
                            errors.Add(String.Format(Resources.ExcelProcessingResource.DuplicateColumnErrorMessage, columnTitle));
                        else
                            columnNumbers[columnTitle] = i;
                    }
                }

                foreach (ExColumn column in columnsToProcess)
                {
                    if ((int)columnNumbers[column.Name] == 0)
                        errors.Add(String.Format(Resources.ExcelProcessingResource.RequiredColumnNotFoundErrorMessage, column.Name));
                }

                if (errors.Count > 0)
                    return null;

                // Ahora procesamos cada columna y verificamos la data.

                // Primero veamos si las columnas obligatorias tienen dato y si los tipos de datos son correctos
                foreach (ExColumn column in columnsToProcess)
                {
                    for (int j = topLeft.Row + 1; j <= bottomRight.Row; j++)
                    {
                        object value = worksheet.Cells[j, (int)columnNumbers[column.Name]].Value;
                        string address = worksheet.Cells[j, (int)columnNumbers[column.Name]].Address;
                        string stringValue = GetStringValueFromCell(value);

                        // Verificamos que la celda no tenga errores
                        if (value is double && Double.IsNaN((double)value))
                        {
                            // This is typically an error in a formula.  Invalid
                            errors.Add(String.Format(Resources.ExcelProcessingResource.InvalidValueErrorMessage, address));
                            continue;
                        }

                        // Verificamos que la celda no esté vacía cuando es obligatoria
                        if ((value == null || String.IsNullOrEmpty(stringValue)) && column.Mandatory)
                        {
                            errors.Add(String.Format(Resources.ExcelProcessingResource.RequiredValueErrorMessage, address, column.Name));
                            continue;
                        }

                        // Verificamos el tipo de dato.  
                        if (column is BooleanExColumn && !column.ValueIsAcceptable(value))
                        {
                            errors.Add(String.Format(Resources.ExcelProcessingResource.ColumnNeedsBooleanValueErrorMessage, address, column.Name));
                            continue;
                        }
                        if (column is IntegerExColumn && !column.ValueIsAcceptable(value))
                        {
                            errors.Add(String.Format(Resources.ExcelProcessingResource.ColumnNeedsIntegerValueErrorMessage, address, column.Name));
                            continue;
                        }
                        else if (column is DecimalExColumn && !column.ValueIsAcceptable(value))
                        {
                            errors.Add(String.Format(Resources.ExcelProcessingResource.ColumnNeedsDecimalValueErrorMessage, address, column.Name));
                            continue;
                        }
                        else if (column is DoubleExColumn && !column.ValueIsAcceptable(value))
                        {
                            errors.Add(String.Format(Resources.ExcelProcessingResource.ColumnNeedsDoubleValueErrorMessage, address, column.Name));
                            continue;
                        }
                        else if (column is DateExColumn && !column.ValueIsAcceptable(value))
                        {
                            errors.Add(String.Format(Resources.ExcelProcessingResource.ColumnNeedsDateValueErrorMessage, address, column.Name));
                            continue;
                        }
                        else if (column is ListExColumn && !column.ValueIsAcceptable(value))
                        {
                            errors.Add(String.Format(Resources.ExcelProcessingResource.InvalidValueForColumnErrorMessage, address, column.Name));
                            continue;
                        }
                        else if (column is InclusiveListExColumn && !column.ValueIsAcceptable(value))
                        {
                            errors.Add(String.Format(Resources.ExcelProcessingResource.InvalidMultipleValueForColumnErrorMessage, address, column.Name));
                            continue;
                        }
                        else if (column is StringExColumn && !column.ValueIsAcceptable(value))
                        {
                            errors.Add(String.Format(Resources.ExcelProcessingResource.ColumnNeedsTextValueErrorMessage, address, column.Name));
                            continue;
                        }
                        else if (column is GeoRefExColumn && !column.ValueIsAcceptable(value))
                        {
                            errors.Add(String.Format(Resources.ExcelProcessingResource.ColumnNeedsGeoTagValueErrorMessage, address, column.Name));
                            continue;
                        }
                    }
                }

                if (errors.Count > 0)
                    return null;

                // Si llegamos hasta aqui el Spreadsheet pasó todos los tests y debería ser válido. Lo leemos al dataset

                DataTable table1 = new DataTable("EXCEL");

                foreach (ExColumn column in columnsToProcess)
                {
                    string name = column.Name;
                    Type dataType = column.GetColumnSystemType();
                    table1.Columns.Add(name, dataType);
                }

                for (int j = topLeft.Row + 1; j <= bottomRight.Row; j++)
                {
                    DataRow row = table1.NewRow();

                    foreach (ExColumn column in columnsToProcess)
                    {
                        try
                        {
                            row[column.Name] = column.ConvertValueToObjectToStoreInDataSet(worksheet.Cells[j, (int)columnNumbers[column.Name]].Value);
                        }
                        catch
                        {
                            errors.Add(String.Format(Resources.ExcelProcessingResource.InvalidValueForColumnErrorMessage, j, column.Name));
                        }

                    }

                    table1.Rows.Add(row);
                }

                if (errors.Count > 0)
                    return null;

                if (keys.Count > 0)
                {
                    // Necesitamos decirle al DataSet que tenemos llaves en algunos de los campos
                    DataColumn[] keyColumn = new DataColumn[keys.Count];
                    int i = 0;
                    foreach (string key in keys)
                    {
                        keyColumn[i++] = table1.Columns[key];
                    }
                    table1.PrimaryKey = keyColumn;
                }

                DataSet newDataSet = new DataSet();
                newDataSet.Tables.Add(table1);

                return newDataSet;

            } // the using statement automatically calls Dispose() which closes the package.
        }

        private static string GetStringValueFromCell(object value)
        {
            string stringValue = "";

            if (value is int)
            {
                stringValue = ((int)value).ToString();
            }
            else if (value is decimal)
            {
                stringValue = ((decimal)value).ToString();
            }
            else if (value is double)
            {
                stringValue = ((double)value).ToString();
            }
            else if (value is bool)
            {
                stringValue = ((bool)value).ToString();
            }
            else if (value is string)
            {
                stringValue = ((string)value);
            }
            else if (value is DateTime)
            {
                stringValue = ((DateTime)value).ToString("s", System.Globalization.CultureInfo.InvariantCulture);
            }

            return stringValue;
        }

        /// <summary>
        /// Returns true is the contents of the two objects are equal
        /// </summary>
        /// <param name="value1"></param>
        /// <param name="value2"></param>
        /// <returns></returns>
        private static bool ObjectsAreEqual(object value1, object value2)
        {
            if (value1 == null && value2 == null)
                return true;

            if (value1 == null || value2 == null)
                return false;

            if (DBNull.Value.Equals(value1) && DBNull.Value.Equals(value2))
                return true;

            if (DBNull.Value.Equals(value1) || DBNull.Value.Equals(value2))
                return false;

            if (value1.GetType() != value2.GetType())
                return false;

            if (value1.GetType() == typeof(System.Int32))
                return (int)value1 == (int)value2;
            else if (value1.GetType() == typeof(System.Decimal))
                return (decimal)value1 == (decimal)value2;
            else if (value1.GetType() == typeof(System.Double))
                return (double)value1 == (double)value2;
            else if (value1.GetType() == typeof(System.DateTime))
                return (DateTime)value1 == (DateTime)value2;
            else if (value1.GetType() == typeof(System.String))
                return (string)value1 == (string)value2;
            else if (value1.GetType() == typeof(System.Boolean))
                return (bool)value1 == (bool)value2;
            else
                throw new Exception("Unsupported type in comparison");
        }
    }
}