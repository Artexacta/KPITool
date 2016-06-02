using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.KPI
{
    /// <summary>
    /// Summary description for KPIMeasurements
    /// </summary>
    public class KPIMeasurements
    {
        private int _measurementID;
        private int _kpiID;
        private DateTime _date;
        private decimal _measurement;

        public KPIMeasurements()
        {
        }

        public KPIMeasurements(int MeasurementID, int KpiID, DateTime Date, decimal Measurement)
        {
            this._measurementID = MeasurementID;
            this._kpiID = KpiID;
            this._date = Date;
            this._measurement = Measurement;
        }

        public int MeasurementID
        {
            get { return _measurementID; }
            set { _measurementID = value; }
        }

        public int KpiID
        {
            get { return _kpiID; }
            set { _kpiID = value; }
        }

        public DateTime Date
        {
            get { return _date; }
            set { _date = value; }
        }

        public decimal Measurement
        {
            get { return _measurement; }
            set { _measurement = value; }
        }

        public string Detalle { get; set; }

        public string Categories { get; set; }

        public KPIDataTime DataTime { get; set; }

        public string TypeImport { get; set; }

    }
}