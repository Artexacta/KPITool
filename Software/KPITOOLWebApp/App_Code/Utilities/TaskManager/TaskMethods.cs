
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using log4net;
using System.Threading;
using Artexacta.App.ViewStateSql;

namespace Artexacta.App.Utilities.TaskManager
{
    /// <summary>
    /// This class must have one method for every Task, being called: Task_[TaskId], without parameters
    /// </summary>
    public class TaskMethods
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        /// <summary>
        /// This task deletes all viewstate that are outdated. Just calls the BLL
        /// </summary>
        public static void Task_ExpireViewState()
        {
            log.Debug("BEGIN Task Expire ViewState");

            try
            {
                Artexacta.App.ViewStateSql.BLL.ViewStateSqlBLL.ExpireViewState();
                log.Info("Expired view state has been deleted from DB");
            }
            catch
            {
                log.Error("Could not expire the view state, something wrong with database");
            }

            log.Debug("BEGIN Task Expire ViewState");
        }
    }
}