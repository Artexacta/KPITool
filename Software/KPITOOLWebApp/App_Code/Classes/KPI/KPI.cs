using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.KPI
{
    /// <summary>
    /// Summary description for KPI
    /// </summary>
    public class KPI
    {
        private int _kpiID;
        private string _name;
        private int _organizationID;
        private int _areaID;
        private int _projectID;
        private int _activityID;
        private int _personID;
        private string _unitID;
        private string _directionID;
        private string _strategyID;
        private DateTime _startDate;
        private string _reportingUnitID;
        private int _targetPeriod;
        private bool _allowCategories;
        private string _currency;
        private string _currencyUnitID;
        private string _kpiTypeID;

        public KPI()
        {
        }

        public KPI(int kpiID, string name, int organizationID, int areaID, int projectID, int activityID, int personID, 
            string unitID, string directionID, string strategyID, DateTime startDate, string reportingUnitID, int targetPeriod, 
            bool allowCategories, string currency, string currencyUnitID, string kpiTypeID)
        {
            this._kpiID = kpiID;
            this._name = name;
            this._organizationID = organizationID;
            this._areaID = areaID;
            this._projectID = projectID;
            this._activityID = activityID;
            this._personID = personID;
            this._unitID = unitID;
            this._directionID = directionID;
            this._strategyID = strategyID;
            this._startDate = startDate;
            this._reportingUnitID = reportingUnitID;
            this._targetPeriod = targetPeriod;
            this._allowCategories = allowCategories;
            this._currency = currency;
            this._currencyUnitID = currencyUnitID;
            this._kpiTypeID = kpiTypeID;
        }

        public int KpiID
        {
            get { return _kpiID; }
            set { _kpiID = value; }
        }

        public string Name
        {
            get { return _name; }
            set { _name = value; }
        }

        public int OrganizationID
        {
            get { return _organizationID; }
            set { _organizationID = value; }
        }

        public int AreaID
        {
            get { return _areaID; }
            set { _areaID = value; }
        }

        public int ProjectID
        {
            get { return _projectID; }
            set { _projectID = value; }
        }

        public int ActivityID
        {
            get { return _activityID; }
            set { _activityID = value; }
        }

        public int PersonID
        {
            get { return _personID; }
            set { _personID = value; }
        }

        public string UnitID
        {
            get { return _unitID; }
            set { _unitID = value; }
        }

        public string DirectionID
        {
            get { return _directionID; }
            set { _directionID = value; }
        }

        public string StrategyID
        {
            get { return _strategyID; }
            set { _strategyID = value; }
        }

        public DateTime StartDate
        {
            get { return _startDate; }
            set { _startDate = value; }
        }

        public string ReportingUnitID
        {
            get { return _reportingUnitID; }
            set { _reportingUnitID = value; }
        }

        public int TargetPeriod
        {
            get { return _targetPeriod; }
            set { _targetPeriod = value; }
        }

        public bool AllowCategories
        {
            get { return _allowCategories; }
            set { _allowCategories = value; }
        }

        public string Currency
        {
            get { return _currency; }
            set { _currency = value; }
        }

        public string CurrencyUnitID
        {
            get { return _currencyUnitID; }
            set { _currencyUnitID = value; }
        }

        public string KpiTypeID
        {
            get { return _kpiTypeID; }
            set { _kpiTypeID = value; }
        }

        public string OrganizationName { get; set; }
        public string AreaName { get; set; }
        public string ProjectName { get; set; }
        public string ActivityName { get; set; }
        public string PersonName { get; set; }

    }
}