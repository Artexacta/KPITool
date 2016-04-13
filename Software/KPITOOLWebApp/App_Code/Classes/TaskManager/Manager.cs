using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;

namespace Artexacta.App.Utilities.TaskManager
{
	/// <summary>
	/// Summary description for Manager
	/// </summary>
	public class Manager
	{
		private int _managerId;

		private bool _status;

		private long _sleepTimeSeconds;

		private int _numberOfOverlapsAllowed;

		public long SleepTimeSeconds
		{
			get { return _sleepTimeSeconds; }
			set { _sleepTimeSeconds = value; }
		}

		public bool Status
		{
			get { return _status; }
			set { _status = value; }
		}
		public int ManagerId
		{
			get { return _managerId; }
			set { _managerId = value; }
		}
		public int NumberOfOverlapsAllowed
		{
			get { return _numberOfOverlapsAllowed; }
			set { _numberOfOverlapsAllowed = value; }
		}
		public Manager()
		{ }

		public Manager(int managerId,
			bool status,
			long sleepTimeSeconds,
			int numberOfOverlapsAllowed)
		{
			_managerId = managerId;
			_status = status;
			_sleepTimeSeconds = sleepTimeSeconds;
			_numberOfOverlapsAllowed = numberOfOverlapsAllowed;
		}
	}
}