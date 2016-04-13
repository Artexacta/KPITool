<%@ Application Language="C#" %>

<script RunAt="server">

    /// <summary>
    /// If the task manageris running any tasks
    /// </summary>
    static bool runningTasks;
    /// <summary>
    /// The number of times the manager is ordered to start a task... and if a task had already begun,
    /// thus possibly overlapping tasks
    /// </summary>
    static int noOverlapTaskTry;
    /// <summary>
    /// The lock object used with monitors to ensure that only one task at a time is executed
    /// </summary>
    static object lockObject = new object();
    
    /// <summary>
    /// The key used for task manager cache handler
    /// </summary>
    private const string DummyCacheItemKey = "DummyCachePage";
    void Application_Start(object sender, EventArgs e)
    {
        // Code that runs on application startup
        // Configure the logging system
        log4net.Config.XmlConfigurator.Configure();

        log4net.ILog log = log4net.LogManager.GetLogger("Standard");

        log.Info("Application is starting");

        // Make sure that the administrator user record are created
        Artexacta.App.Security.BLL.SecurityBLL.SetUpAccessControlPermisions();

        log.Debug("Access control permissions set. Initializing configuration");

        // ---------------------------------------------------
        // - Installation of the Task Manager
        // ---------------------------------------------------

        //Task Manager SetUp
        RegisterCacheEntry();

    }
    private bool RegisterCacheEntry()
    {
        if (null != HttpContext.Current.Cache[DummyCacheItemKey]) return false;

        HttpContext.Current.Cache.Add(DummyCacheItemKey, "Test", null,
            DateTime.MaxValue, TimeSpan.FromMinutes(1),
            CacheItemPriority.Normal,
            new CacheItemRemovedCallback(CacheItemRemovedCallback));

        return true;
    }
    public void CacheItemRemovedCallback(string key,
          object value, CacheItemRemovedReason reason)
    {
        System.Diagnostics.Debug.WriteLine("Cache item callback: " + DateTime.Now.ToString());

        HitPage();

        // Do the service works

        DoTasksWork();
    }

    private void HitPage()
    {
        System.Net.WebClient client = new System.Net.WebClient();
        client.DownloadData(Artexacta.App.Configuration.Configuration.DummyPageUrl());
    }
    private void DoTasksWork()
    {
        log4net.ILog log = log4net.LogManager.GetLogger("Standard");
        Artexacta.App.Utilities.TaskManager.Manager theManager =
            Artexacta.App.Utilities.TaskManager.BLL.ManagerBLL.GetCurrentmanager();
        try
        {
            if (runningTasks)
            {
                noOverlapTaskTry++;
                log.Info("Tasks are currently being executed");
                if (noOverlapTaskTry > theManager.NumberOfOverlapsAllowed)
                {
                    log.Debug("Sorry, Too Much overlapping, must kill the tasks");
                    Artexacta.App.Utilities.TaskManager.TaskManager.pleaseStop = true;
                }
                return;
            }
        }
        catch (Exception ex)
        {
            log.Error("There was an error verifying tasks", ex);
        }

        System.Threading.Monitor.Enter(lockObject);

        if (!runningTasks)
        {
            try
            {
                log.Info("Start tasks execution");
                noOverlapTaskTry = 0;
                runningTasks = true;
                Artexacta.App.Utilities.TaskManager.TaskManager.pleaseStop = false;
                Artexacta.App.Utilities.TaskManager.TaskManager.executeTasks();
                log.Debug("Tasks executed correctly");
            }
            catch (Exception ex)
            {
                log.Error("Error executing tasks", ex);
            }
            runningTasks = false;

        }

        System.Threading.Monitor.Exit(lockObject);
    }

    void Application_End(object sender, EventArgs e)
    {
        //  Code that runs on application shutdown

    }

    void Application_Error(object sender, EventArgs e)
    {
        // Code that runs when an unhandled error occurs

    }

    void Session_Start(object sender, EventArgs e)
    {
        // Code that runs when a new session is started

    }

    void Session_End(object sender, EventArgs e)
    {
        // Code that runs when a session ends. 
        // Note: The Session_End event is raised only when the sessionstate mode
        // is set to InProc in the Web.config file. If session mode is set to StateServer 
        // or SQLServer, the event is not raised.

    }
    protected void Application_BeginRequest(Object sender, EventArgs e)
    {
        // If the dummy page is hit, then it means we want to add another item

        // in cache

        if (HttpContext.Current.Request.Url.ToString() == Artexacta.App.Configuration.Configuration.DummyPageUrl())
        {
            // Add the item in cache and when succesful, do the work.

            RegisterCacheEntry();
        }
    }
</script>
