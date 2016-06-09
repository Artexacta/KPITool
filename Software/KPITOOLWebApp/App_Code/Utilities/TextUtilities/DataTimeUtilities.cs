using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.Utilities.DataTime
{
    public class DataTime
    {
        public int Id { get; set; }
        public string Value { get; set; }

        public DataTime(int id, string value)
        {
            this.Id = id;
            this.Value = value;
        }
    }

    [System.ComponentModel.DataObject]
    public class DataTimeUtilities
    {
        public static List<DataTime> GetYears()
        {
            List<DataTime> theList = new List<DataTime>();
            for (int i = 0; i < 11; i++)
            {
                theList.Add(new DataTime(i, i.ToString() + " " + (i == 1 ? Resources.DataTime.YearsValueSingle : Resources.DataTime.YearsValue)));
            }
            return theList;
        }

        public static List<DataTime> GetMonths()
        {
            List<DataTime> theList = new List<DataTime>();
            for (int i = 0; i < 12; i++)
            {
                theList.Add(new DataTime(i, i.ToString() + " " + (i == 1 ? Resources.DataTime.MonthsValueSingle : Resources.DataTime.MonthsValue)));
            }
            return theList;
        }

        public static List<DataTime> GetDays()
        {
            List<DataTime> theList = new List<DataTime>();
            for (int i = 0; i < 31; i++)
            {
                theList.Add(new DataTime(i, i.ToString() + " " + (i == 1 ? Resources.DataTime.DaysValueSingle : Resources.DataTime.DaysValue)));
            }
            return theList;
        }

        public static List<DataTime> GetHours()
        {
            List<DataTime> theList = new List<DataTime>();
            for (int i = 0; i < 24; i++)
            {
                theList.Add(new DataTime(i, i.ToString() + " " + (i == 1 ? Resources.DataTime.HoursValueSingle : Resources.DataTime.HoursValue)));
            }
            return theList;
        }

        public static List<DataTime> GetMinutes()
        {
            List<DataTime> theList = new List<DataTime>();
            for (int i = 0; i < 60; i++)
            {
                theList.Add(new DataTime(i, i.ToString() + " " + (i == 1 ? Resources.DataTime.MinutesValueSingle : Resources.DataTime.MinutesValue)));
            }
            return theList;
        }

    }
}