using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using log4net;
using ManagerDSTableAdapters;

namespace Artexacta.App.Utilities.TaskManager.BLL
{
	/// <summary>
	/// Summary description for ManagerBLL
	/// </summary>
	[System.ComponentModel.DataObject]
	public class ManagerBLL
	{
		private static readonly ILog log = LogManager.GetLogger("Standard");

		ManagerTableAdapter _theAdapter = null;

		protected ManagerTableAdapter theAdapter
		{
			get
			{
				if (_theAdapter == null)
					_theAdapter = new ManagerTableAdapter();
				return _theAdapter;
			}
		}

		public ManagerBLL()
		{
		}

		private static Manager FillManagerRecord(ManagerDS.ManagerRow row)
		{
			Manager theNewRecord = new Manager(row.ManagerId,
				row.Status,
				row.SleepTimeSeconds
				,row.NumberOfOverlapsAllowed);

			return theNewRecord;
		}
		public static Manager GetManagerById(int idManager)
		{
			ManagerTableAdapter localAdapter = new ManagerTableAdapter();

			if (idManager <= 0)
				return null;

			Manager theManager = null;

			try
			{
				ManagerDS.ManagerDataTable table = localAdapter.GetManagerById(idManager);

				if (table != null && table.Rows.Count > 0)
				{
					ManagerDS.ManagerRow row = table[0];
					theManager = FillManagerRecord(row);
				}
			}
			catch (Exception q)
			{
				log.Error("An error was ocurred while geting Task Manager data", q);
				return null;
			}

			return theManager;
		}

		public static int InsertManagerRecord(bool status,
			long sleepTime, int numberOfOverlapsAllowed)
		{
			int? newmanagerId = 0;

			try
			{
				ManagerTableAdapter localAdapter = new ManagerTableAdapter();

				object resutl = localAdapter.InsertManagerRecord(status ? 1 : 0,
					sleepTime, numberOfOverlapsAllowed,
					ref newmanagerId);

				log.Debug("Se insertó el Task Manager con ID = " + newmanagerId);

				if (newmanagerId == null || newmanagerId <= 0)
				{
					throw new Exception("SQL insertó el registro exitosamente pero retornó un status null <= 0");
				}
				return (int)newmanagerId;
			}
			catch (Exception q)
			{
				log.Error("An error was ocurred while inserting Task Manager", q);
				throw q;
			}
		}
		public static int InsertExceptionRecord(Manager manager)
		{
			int? newManagerId = 0;

			try
			{
				ManagerTableAdapter localAdapter = new ManagerTableAdapter();

				object resutl = localAdapter.InsertManagerRecord(manager.Status?1:0,
					manager.SleepTimeSeconds, manager.NumberOfOverlapsAllowed,
					ref newManagerId);

				log.Debug("Se insertó el Task Manager con id = " + newManagerId);

				if (newManagerId == null || newManagerId <= 0)
				{
					throw new Exception("SQL insertó el registro exitosamente pero retornó un status null <= 0");
				}
				return (int)newManagerId;
			}
			catch (Exception q)
			{
				log.Error("An error was ocurred while inserting Task Manager", q);
				throw q;
			}
		}


		public static bool UpdateManagerRecord(int Managerid, bool status,
			long sleepTime, int numberOfOverlapsAllowed)
		{
			if (Managerid <= 0)
				throw new ArgumentException("Id del Task Manager no puede ser <= 0");
			try
			{
				ManagerTableAdapter localAdapter = new ManagerTableAdapter();

				localAdapter.UpdateManagerRecord(status ? 1 : 0, sleepTime, numberOfOverlapsAllowed, Managerid);

				log.Debug("Se modifico el Task Manager con id = " + Managerid);
				return true;
			}
			catch (Exception q)
			{
				log.Error("An error was ocurred while updating Task Manager", q);
				return false;
			}
		}

		public static bool UpdateManagernRecord(Manager theManager)
		{
			if (theManager.ManagerId <= 0)
				throw new ArgumentException("Id del Task Manager no puede ser <= 0");
			try
			{
				ManagerTableAdapter localAdapter = new ManagerTableAdapter();

				localAdapter.UpdateManagerRecord(theManager.Status?1:0,
					theManager.SleepTimeSeconds, theManager.NumberOfOverlapsAllowed, theManager.ManagerId);

				log.Debug("Se modifico el Task Manager con id = " + theManager.ManagerId);
				return true;
			}
			catch (Exception q)
			{
				log.Error("An error was ocurred while updating Task Manager", q);
				return false;
			}
		}

		public static bool DeleteManagerRecord(int ManagerId)
		{
			if (ManagerId <= 0)
				throw new ArgumentException("Error en el código de Task Manager a eliminar.");

			try
			{
				ManagerTableAdapter localAdapter = new ManagerTableAdapter();
				localAdapter.DeleteManagerRecord(ManagerId);
				return true;
			}
			catch (Exception q)
			{
				log.Error("An error was ocurred while deleting Task Manager", q);
				throw q;
			}
		}

		public static bool DeleteManagerRecord(Manager theManager)
		{
			if (theManager.ManagerId <= 0)
				throw new ArgumentException("Error en el código de Task Manager a eliminar.");

			try
			{
				ManagerTableAdapter localAdapter = new ManagerTableAdapter();
				localAdapter.DeleteManagerRecord(theManager.ManagerId);
				return true;
			}
			catch (Exception q)
			{
				log.Error("An error was ocurred while deleting Task Manager", q);
				throw q;
			}
		}

		public static Manager GetCurrentmanager()
		{
			ManagerTableAdapter localAdapter = new ManagerTableAdapter();
			Manager theManager = null;

			try
			{
				ManagerDS.ManagerDataTable table = localAdapter.GetCurrentManager();

				if (table != null && table.Rows.Count > 0)
				{
					ManagerDS.ManagerRow row = table[0];
					theManager = FillManagerRecord(row);
				}
			}
			catch (Exception q)
			{
				log.Error("An error was ocurred while geting Task Manager data", q);
				return null;
			}

			return theManager;
		}
	}
}