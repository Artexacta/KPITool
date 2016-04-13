using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Reflection;
using log4net;
using Artexacta.App.Utilities.TaskManager;
using Artexacta.App.Utilities.TaskManager.BLL;

/// <summary>
/// Summary description for ManageTask
/// </summary>
/// 
namespace Artexacta.App.Utilities.TaskManager
{
	public static class TaskManager
	{
		public static bool pleaseStop;
		private static readonly ILog log = LogManager.GetLogger("Standard");
		/// <summary>
		/// Every Method that this method calls by reflection, must be static and public
		/// </summary>
		/// <param name="className">Name of the class</param>
		/// <param name="methodName">Name of the method to execute</param>
		/// <returns>true if was a good execution, false if not</returns>
		private static bool InvokeStringMethod(string className, string methodName)
		{
			try
			{
				// Get the Type for the class
				Type calledType = Type.GetType(className);

				// Invoke the method itself.
				calledType.InvokeMember(
								methodName,
								BindingFlags.InvokeMethod | BindingFlags.Public |
									BindingFlags.Static,
								null,
								null,
								null);
				return true;
			}
			catch (Exception ex)
			{
				log.Error("Error executing " + className + "." + methodName + "() in the Task Manager Thread", ex);
				return false;
			}
		}
		/// <summary>
		/// Executes the tasks available for execution
		/// </summary>
		public static void executeTasks()
		{
			List<Task> executionList = TaskBLL.GetTasksForExecution();
			foreach (Task theTask in executionList)
			{
				if (pleaseStop)
					break;
				executeSingleTask(theTask);
			}
		}
		/// <summary>
		/// Executes a single task
		/// </summary>
		/// <param name="theTask"></param>
		private static void executeSingleTask(Task theTask)
		{
			bool res = InvokeStringMethod("Artexacta.App.Utilities.TaskManager.TaskMethods", "Task_" + theTask.TaskId);
			if (res)
			{
				log.Debug("task " + theTask.TaskId + " executed correctly");
				theTask.LastExecutionDate = DateTime.Now;

				theTask.IterationsExecuted++;

				try
				{
					TaskBLL.UpdateTaskRecord(theTask);
				}
				catch (Exception ex)
				{
					log.Error("Error updating task", ex);
				}
			}
			else
			{
				log.Error("Error executing task " + theTask.TaskId);
			}
		}
	}
}