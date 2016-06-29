function decimalToYYMMDDhhmm(decDate) {

    var daysMonth = [
  			31, 28, 31,
  			30, 31, 30,
        31, 31, 30,
        31, 30, 31];

    var minuteSlice = 1.0 / (60.0 * 24.0);

    var intDays = Math.floor(decDate);
    var intYear = Math.floor(intDays / 365);
    var intDaysInYear = intDays % 365;
    var intDaysInMonth = intDaysInYear;

    var intMonth = 0;
    var sumMonth = 0;
    for (var i = 0; i < daysMonth.length; i++) {
        sumMonth += daysMonth[i];
        if (intDaysInYear >= sumMonth) {
            intMonth = i + 1;
            intDaysInMonth = intDaysInYear - sumMonth;
        }
    }

    var nbMinutes = Math.round((decDate - intDays) / minuteSlice);
    var nbHours = Math.floor(nbMinutes / 60);
    var nbMinutesInHour = nbMinutes % 60;

    return {
        years: intYear,
        months: intMonth,
        days: intDaysInMonth,
        hours: nbHours,
        minutes: nbMinutesInHour,
        toString: function (yearSingleLabel, yearLabel, monthSigleLabel, monthLabel, daySingleLabel, dayLabel, hourSingleLabel, hourLabel, minuteSingleLabel, minuteLabel) {
            var dataTime = "";
            if (this.years > 0)
            {
                dataTime = this.years + " " + (this.years == 1 ? yearSingleLabel : yearLabel);
            }
            if (this.months > 0)
            {
                dataTime = (dataTime || dataTime == "" ? "" : dataTime + ", ") + this.months + " " + (this.months == 1 ? monthSigleLabel : monthLabel);
            }
            if (this.days > 0)
            {
                dataTime = (dataTime || dataTime == "" ? "" : dataTime + ", ") + this.days + " " + (this.days == 1 ? daySingleLabel : dayLabel);
            }
            if (this.hours > 0)
            {
                dataTime = (dataTime || dataTime == "" ? "" : dataTime + ", ") + this.hours + " " + (this.hours == 1 ? hourSingleLabel : hourLabel);
            }
            if (this.minutes > 0)
            {
                dataTime = (dataTime || dataTime == "" ? "" : dataTime + ", ") + this.minutes + " " + (this.minutes == 1 ? minuteSingleLabel : minuteLabel);
            }
            return dataTime;
        }
    };
}