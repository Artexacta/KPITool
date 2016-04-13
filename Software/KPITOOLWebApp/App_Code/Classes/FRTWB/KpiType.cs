using System;
using System.Threading;

namespace Artexacta.App.FRTWB
{
    public class KpiType
    {
        private static object lockedObject = new Object();
        private static int currentId = 1;
        public UnitType KpiTypeUnitType { get; set; }
        public TypeDirection KpiTypeDirection { get; set; }
        public GroupingStrategy KpiGroupingStrategy { get; set; }
        private static int GetNextId()
        {
            int result = 0;
            Monitor.Enter(lockedObject);
            result = currentId++;
            Monitor.Exit(lockedObject);
            return result;
        }
        public KpiType()
        {
            // Id = GetNextId();
        }
        public int Id { get; set; }

        public string Name { get; set; }
        public string KpiValueForCombobox
        {
            get
            {
                return Id + ";" + KpiTypeUnitType.ToString() + ";" + KpiTypeDirection.ToString() + ";" + KpiGroupingStrategy.ToString();
            }
        }
    }
    public enum UnitType
    {
        PERCENTAGE,
        TIMESPAN,
        MONEY,
        INTEGER,
        DECIMAL
    }
    public enum TypeDirection
    {
        MAXIMIZE,
        MINIMIZE,
        USER_DEFINED
    }
    public enum GroupingStrategy
    {
        AVERAGE_OVER_PERIOD,
        SUM_OVER_PERIOD,
        USER_DEFINED
    }
}