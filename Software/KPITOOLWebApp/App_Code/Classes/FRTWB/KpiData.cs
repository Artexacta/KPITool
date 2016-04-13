
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Web;
namespace Artexacta.App.FRTWB
{
    /// <summary>
    /// Summary description for KpiData
    /// </summary>
    public class KpiData
    {

        public KpiData()
        {

        }
        public string DateId
        {
            get
            {
                return DateCreated.ToShortDateString();
            }
        }
        public Kpi Kpi { get; set; }
        public DateTime DateCreated { get; set; }
        public string Value { get; set; }
        public string ValueForDisplay
        {
            get
            {
                switch (Kpi.KpiType.KpiTypeUnitType)
                {
                    case UnitType.DECIMAL:
                        return Value;
                    case UnitType.INTEGER:
                        return Value;
                    case UnitType.MONEY:

                        string typeDefinition = Kpi.KpiTarget;
                        string[] typeSplitted = typeDefinition.Split(new char[] { ';' });
                        string currency = "";
                        Currency selectedCurrency = (Currency)Enum.Parse(typeof(Currency), typeSplitted[1]);
                        MoneyMeasurements selectedMeasurement = (MoneyMeasurements)Enum.Parse(typeof(MoneyMeasurements), typeSplitted[2]);
                        switch (selectedCurrency)
                        {
                            case Currency.US_DOLLARS:
                                currency = "US Dollars";
                                break;
                            case Currency.EUROS:
                                currency = "Euros";
                                break;
                        }
                        string measurement = "";
                        switch (selectedMeasurement)
                        {
                            case MoneyMeasurements.BILLIONS:
                                measurement = "Billions";
                                break;
                            case MoneyMeasurements.CRORES:
                                measurement = "Crores";
                                break;
                            case MoneyMeasurements.MILLIONS:
                                measurement = "Millions";
                                break;
                            case MoneyMeasurements.LAKHS:
                                measurement = "Lakhs";
                                break;
                            case MoneyMeasurements.THOUSANDS:
                                measurement = "Thousands";
                                break;
                        }
                        string textToShow = Value + " " + measurement + " of " + currency;
                        return textToShow;
                    case UnitType.PERCENTAGE:
                        return Value + " %";
                    case UnitType.TIMESPAN:
                        string[] dateSplitted = Value.Split(new char[] { ';' });
                        string finalTimespan = "";
                        if (dateSplitted[0] != "0")
                        {
                            finalTimespan += dateSplitted[0] + " years";
                        }
                        if (dateSplitted[1] != "0")
                        {
                            if (finalTimespan == "")
                            {
                                finalTimespan += dateSplitted[1] + " months";
                            }
                            else
                            {
                                finalTimespan += ", " + dateSplitted[1] + " months";
                            }
                        }
                        if (dateSplitted[2] != "0")
                        {
                            if (finalTimespan == "")
                            {
                                finalTimespan += dateSplitted[2] + " days";
                            }
                            else
                            {
                                finalTimespan += ", " + dateSplitted[2] + " days";
                            }
                        }
                        if (dateSplitted[3] != "0")
                        {
                            if (finalTimespan == "")
                            {
                                finalTimespan += dateSplitted[3] + " hours";
                            }
                            else
                            {
                                finalTimespan += ", " + dateSplitted[3] + " hours";
                            }
                        }
                        if (dateSplitted[4] != "0")
                        {
                            if (finalTimespan == "")
                            {
                                finalTimespan += dateSplitted[4] + " minutes";
                            }
                            else
                            {
                                finalTimespan += ", " + dateSplitted[4] + " minutes";
                            }
                        }
                        return finalTimespan;
                }
                return Value;

            }
        }

    }
}