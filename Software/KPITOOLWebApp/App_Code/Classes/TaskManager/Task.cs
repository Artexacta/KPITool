using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;

namespace Artexacta.App.Utilities.TaskManager
{
	/// <summary>
	/// Summary description for Task
	/// </summary>
	public class Task
	{
		private string _taskId;

		private string _taskName;

		private string _taskDescription;

		private DateTime _startDate;

		private DateTime? _endDate;

		private int _iterations;

		private bool _enabled;

		private int _iterationsExecuted;

		private DateTime? _lastExecutionDate;

		private long _periodLengthSeconds;

		public long PeriodLengthSeconds
		{
			get { return _periodLengthSeconds; }
			set { _periodLengthSeconds = value; }
		}

		public DateTime? LastExecutionDate
		{
			get { return _lastExecutionDate; }
			set { _lastExecutionDate = value; }
		}
		public int IterationsExecuted
		{
			get { return _iterationsExecuted; }
			set { _iterationsExecuted = value; }
		}
		public bool Enabled
		{
			get { return _enabled; }
			set { _enabled = value; }
		}
		public int Iterations
		{
			get { return _iterations; }
			set { _iterations = value; }
		}

		public string TaskName
		{
			get { return _taskName; }
			set { _taskName = value; }
		}
		public string TaskId
		{
			get { return _taskId; }
			set { _taskId = value; }
		}
		public string TaskDescription
		{
			get { return _taskDescription; }
			set { _taskDescription = value; }
		}
		public DateTime? EndDate
		{
			get { return _endDate; }
			set { _endDate = value; }
		}
		public DateTime StartDate
		{
			get { return _startDate; }
			set { _startDate = value; }
		}
		public Task()
		{
			IterationsExecuted = 0;
		}

		public Task(
			string taskId,
			string taskName,			
			string taskDescription,
			DateTime startDate,
			DateTime? endDate,
			int iterations,
			bool enabled,
			int iterationsExecuted,
			DateTime? lastExecutionDate,
			long periodLengthSeconds)
		{
			_taskId = taskId;
			_taskDescription = taskDescription;
			_endDate = endDate;
			_taskName = taskName;
			_startDate = startDate;
			_enabled = enabled;
			_iterations = iterations;
			_iterationsExecuted = iterationsExecuted;
			_lastExecutionDate = lastExecutionDate;
			_periodLengthSeconds = periodLengthSeconds;
		}
		public Task(
			string taskId,
			string taskName,
			string taskDescription,
			DateTime startDate,
			DateTime? endDate,
			int iterations,
			bool enabled,
			long periodLengthSeconds)
		{
			_taskId = taskId;
			_taskDescription = taskDescription;
			_endDate = endDate;
			_taskName = taskName;
			_startDate = startDate;
			_enabled = enabled;
			_iterations = iterations;
			_iterationsExecuted = 0;
			_lastExecutionDate = new DateTime?();
			_periodLengthSeconds = periodLengthSeconds;
		}
	}
}