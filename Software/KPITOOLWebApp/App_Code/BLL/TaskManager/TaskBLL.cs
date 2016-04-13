using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using log4net;
using TaskDSTableAdapters;

namespace Artexacta.App.Utilities.TaskManager.BLL
{
	/// <summary>
	/// Summary description for TaskBLL
	/// </summary>
	[System.ComponentModel.DataObject]
	public class TaskBLL
	{
		private static readonly ILog log = LogManager.GetLogger("Standard");

		TaskTableAdapter _theAdapter = null;

		protected TaskTableAdapter theAdapter
		{
			get
			{
				if (_theAdapter == null)
					_theAdapter = new TaskTableAdapter();
				return _theAdapter;
			}
		}

		public TaskBLL()
		{
		}

		private static Task FillTaskRecord(TaskDS.TaskRow row)
		{
			Task theNewRecord = new Task(row.TaskId,
				row.TaskName,
				row.TaskDescription,
				row.StartDate,
				row.IsEndDateNull() ? new DateTime?() : row.EndDate,
				row.Iterations,
				row.Enabled,
				row.IterationsExecuted,
				row.IsLastExecutionDateNull() ? new DateTime?() : row.LastExecutionDate,
				row.PeriodLengthSeconds);

			return theNewRecord;
		}

		public static Task GetTaskById(string idTask)
		{
			TaskTableAdapter localAdapter = new TaskTableAdapter();

			if (string.IsNullOrEmpty(idTask))
				return null;

			Task theTask = null;

			try
			{
				TaskDS.TaskDataTable table = localAdapter.GetTaskById(idTask);

				if (table != null && table.Rows.Count > 0)
				{
					TaskDS.TaskRow row = table[0];
					theTask = FillTaskRecord(row);
				}
			}
			catch (Exception q)
			{
				log.Error("An error was ocurred while geting client data", q);
				return null;
			}

			return theTask;
		}

		public static List<Task> GetTasksById(string idTask)
		{
			TaskTableAdapter localAdapter = new TaskTableAdapter();

			if (string.IsNullOrEmpty(idTask))
				return null;

			List<Task> theList = new List<Task>();
			Task theTask = null;

			try
			{
				TaskDS.TaskDataTable theTable = localAdapter.GetTaskById(idTask);

				if (theTable != null && theTable.Rows.Count > 0)
				{
					foreach (TaskDS.TaskRow theRow in theTable.Rows)
					{
						theTask = FillTaskRecord(theRow);
						theList.Add(theTask);
					}
				}
			}
			catch (Exception q)
			{
				log.Error("An error was ocurred while geting client data", q);
				return null;
			}

			return theList;
		}

		public static string InsertTaskRecord(string taskId, string taskName,
			string taskDescription, DateTime startDate, DateTime? endDate,
			long periodLength, int iterations, bool enabled)
		{

			if (string.IsNullOrEmpty(taskId))
				throw new ArgumentException("Task Id no puede ser nulo.");
			if (string.IsNullOrEmpty(taskName))
				throw new ArgumentException("Task Name no puede ser nulo.");
			if (string.IsNullOrEmpty(taskDescription))
				throw new ArgumentException("Task Description no puede ser nulo.");
			try
			{
				TaskTableAdapter localAdapter = new TaskTableAdapter();

				localAdapter.InsertTaskRecord(taskName,
					taskDescription,
					startDate, endDate, periodLength,
					iterations, enabled, 0, null, taskId);

				log.Debug("Se insertó el Task con ID = " + taskId);

				return taskId;
			}
			catch (Exception q)
			{
				log.Error("An error was ocurred while inserting Task", q);
				throw q;
			}
		}
		public static string InsertTaskRecord(Task theTask)
		{
			if (string.IsNullOrEmpty(theTask.TaskId))
				throw new ArgumentException("Task Id no puede ser nulo.");
			if (string.IsNullOrEmpty(theTask.TaskName))
				throw new ArgumentException("Task Name no puede ser nulo.");
			if (string.IsNullOrEmpty(theTask.TaskDescription))
				throw new ArgumentException("Task Description no puede ser nulo.");
			try
			{
				TaskTableAdapter localAdapter = new TaskTableAdapter();

				localAdapter.InsertTaskRecord(theTask.TaskName,
					theTask.TaskDescription,
					theTask.StartDate, theTask.EndDate, theTask.PeriodLengthSeconds,
					theTask.Iterations, theTask.Enabled, 0, null, theTask.TaskId);

				log.Debug("Se insertó el Task con ID = " + theTask.TaskId);

				return theTask.TaskId;
			}
			catch (Exception q)
			{
				log.Error("An error was ocurred while inserting Task", q);
				throw q;
			}
		}


		public static bool UpdateTaskRecord(string taskId, string taskName,
			string taskDescription, DateTime startDate, DateTime? endDate,
			long periodLength, int iterations, bool enabled, DateTime? lastExecutionDate, int iterationsExecuted)
		{
			if (string.IsNullOrEmpty(taskId))
				throw new ArgumentException("Task Id no puede ser nulo.");
			if (string.IsNullOrEmpty(taskName))
				throw new ArgumentException("Task Name no puede ser nulo.");
			if (string.IsNullOrEmpty(taskDescription))
				throw new ArgumentException("Task Description no puede ser nulo.");
			try
			{
				TaskTableAdapter localAdapter = new TaskTableAdapter();

				localAdapter.UpdateTaskRecord(taskName,
					taskDescription,
					startDate, endDate, periodLength,
					iterations, enabled, iterationsExecuted, lastExecutionDate, taskId);

				log.Debug("Se modifico el Task con id = " + taskId);
				return true;
			}
			catch (Exception q)
			{
				log.Error("An error was ocurred while updating Task", q);
				return false;
			}
		}

		public static bool UpdateTaskRecord(Task theTask)
		{
			if (string.IsNullOrEmpty(theTask.TaskId))
				throw new ArgumentException("Task Id no puede ser nulo.");
			if (string.IsNullOrEmpty(theTask.TaskName))
				throw new ArgumentException("Task Name no puede ser nulo.");
			if (string.IsNullOrEmpty(theTask.TaskDescription))
				throw new ArgumentException("Task Description no puede ser nulo.");
			try
			{
				TaskTableAdapter localAdapter = new TaskTableAdapter();
				if (theTask.LastExecutionDate.Value.Year == 1) {
					theTask.LastExecutionDate = new DateTime?();
				}

				localAdapter.UpdateTaskRecord(theTask.TaskName,
					theTask.TaskDescription,
					theTask.StartDate, theTask.EndDate, theTask.PeriodLengthSeconds,
					theTask.Iterations, theTask.Enabled, theTask.IterationsExecuted, theTask.LastExecutionDate, theTask.TaskId);

				log.Debug("Se modifico el Task con id = " + theTask.TaskId);
				return true;
			}
			catch (Exception q)
			{
				log.Error("An error was ocurred while updating task", q);
				return false;
			}
		}

		public static bool DeleteTaskRecord(string TaskId)
		{
			if (string.IsNullOrEmpty(TaskId))
				throw new ArgumentException("Error en el Task Id a eliminar.");

			try
			{
				TaskTableAdapter localAdapter = new TaskTableAdapter();
				localAdapter.DeleteTaskRecord(TaskId);
				return true;
			}
			catch (Exception q)
			{
				log.Error("An error was ocurred while deleting Task", q);
				throw q;
			}
		}
		public static bool DeleteTaskRecord(Task theTask)
		{
			if (string.IsNullOrEmpty(theTask.TaskId))
				throw new ArgumentException("Error en el Task Id a eliminar.");

			try
			{
				TaskTableAdapter localAdapter = new TaskTableAdapter();
				localAdapter.DeleteTaskRecord(theTask.TaskId);
				return true;
			}
			catch (Exception q)
			{
				log.Error("An error was ocurred while deleting Task", q);
				throw q;
			}
		}

		public static List<Task> GetTasksForExecution()
		{
			TaskTableAdapter localAdapter = new TaskTableAdapter();

			List<Task> theList = new List<Task>();
			Task theClient = null;

			try
			{
				TaskDS.TaskDataTable theTable =
					localAdapter.GetTasksForExecution();

				if (theTable != null && theTable.Rows.Count > 0)
				{
					foreach (TaskDS.TaskRow theRow in theTable.Rows)
					{
						theClient = FillTaskRecord(theRow);
						theList.Add(theClient);
					}
				}
			}
			catch (Exception q)
			{
				log.Error("Ocurrió un error al obtener la lista de Tasks de la Base de Datos", q);
			}
			return theList;
		}

		public static List<Task> GetAllTasks()
		{
			TaskTableAdapter localAdapter = new TaskTableAdapter();

			List<Task> theList = new List<Task>();
			Task theClient = null;

			try
			{
				TaskDS.TaskDataTable theTable =
					localAdapter.GetAllTasks();

				if (theTable != null && theTable.Rows.Count > 0)
				{
					foreach (TaskDS.TaskRow theRow in theTable.Rows)
					{
						theClient = FillTaskRecord(theRow);
						theList.Add(theClient);
					}
				}
			}
			catch (Exception q)
			{
				log.Error("Ocurrió un error al obtener la lista de Tasks de la Base de Datos", q);
			}
			return theList;
		}

	}
}