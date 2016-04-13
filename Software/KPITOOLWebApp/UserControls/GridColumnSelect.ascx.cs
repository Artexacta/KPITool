using Artexacta.App.GridColumn;
using Artexacta.App.GridColumn.BLL;
using Artexacta.App.User;
using Artexacta.App.User.BLL;
using Artexacta.App.Utilities.SystemMessages;
using log4net;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

public partial class UserControls_GridColumnSelect : System.Web.UI.UserControl
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    public string AssociatedGridView
    {
        get
        {
            return AssociatedGridHF.Value;
        }
        set
        {
            AssociatedGridHF.Value = value.ToString();
        }
    }

    /// <summary>
    /// We ignore all columns that are in this comma separated list
    /// </summary>
    public string IgnoreColumnList
    {
        get
        {
            return IgnoreColumnsHF.Value;
        }
        set
        {
            IgnoreColumnsHF.Value = value.ToString();
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            FillColumnsPanel();
        }
    }

    private List<string> GetListOfIgnoreColumns()
    {
        List<string> theList = new List<string>();

        string[] columns = IgnoreColumnList.Split(new char[] { ',' });
        for (int i = 0; i < columns.Length; i++)
            if (!String.IsNullOrEmpty(columns[i].Trim()))
                theList.Add(columns[i].Trim());

        return theList;
    }

    protected void FillColumnsPanel()
    {
        List<string> ignoreColumns = GetListOfIgnoreColumns();

        string gridType = this.Parent.FindControl(AssociatedGridView).GetType().FullName;
        GridTypeHF.Value = gridType;

        ColumnCheckBoxList.Items.Clear();

        //Get the columns count number and add the columns to the checklist.  

        GridView theGridView = null;
        RadGrid theRadGrid = null;

        if (gridType == "System.Web.UI.WebControls.GridView")
        {
            // In the gridview we use the column number as the column name
            theGridView = (GridView)this.Parent.FindControl(AssociatedGridView);
            for (int i = 0; i < theGridView.Columns.Count; i++)
                if (!ignoreColumns.Contains(i.ToString()))
                {
                    ListItem theItem = new ListItem(theGridView.Columns[i].HeaderText,
                        i.ToString());
                    ColumnCheckBoxList.Items.Add(theItem);
                }
        }
        else if (gridType == "Telerik.Web.UI.RadGrid")
        {
            // In the Telerik grids we use the unique column name as the name of the column
            theRadGrid = (RadGrid)this.Parent.FindControl(AssociatedGridView);
            for (int i = 0; i < theRadGrid.Columns.Count; i++)
                if (!String.IsNullOrEmpty(theRadGrid.Columns[i].UniqueName) &&
                    !ignoreColumns.Contains(theRadGrid.Columns[i].UniqueName))
                {
                    ListItem theItem = new ListItem(theRadGrid.Columns[i].HeaderText,
                        theRadGrid.Columns[i].UniqueName);
                    ColumnCheckBoxList.Items.Add(theItem);
                }
        }
        else
        {
            throw new Exception("Unknown Grid of type " + gridType);
        }

        //Get the current user
        User theUser = null;
        List<SelectionGridColumn> theColumnList = null;
        try
        {
            theUser = UserBLL.GetUserByUsername(HttpContext.Current.User.Identity.Name);

            if (theUser == null || theUser.UserId <= 0)
            {
                log.Error("Cannot get user from database.");
                return;
            }

            UserIDHF.Value = theUser.UserId.ToString();

            //Get the columns visibility by user by grid
            GridColumnBLL theBLL = new GridColumnBLL();
            theColumnList = theBLL.GetColumnsByGridByUser(AssociatedGridView, theUser.UserId);
        }
        catch (Exception q)
        {
            SystemMessages.DisplaySystemErrorMessage("Failed to load columns state for grid. Grid column selector disabled");
            log.Error("Failed to get user details or column list", q);
            this.Visible = false;
            return;
        }

        // We add all these into a hashtable for quick lookup later. 
        Hashtable columnsHash = new Hashtable();
        foreach (SelectionGridColumn col in theColumnList)
            columnsHash.Add(col.Column, col);

        //Id the list is null or empty, then all columns should keep the visibility initially  
        //specified in the Grid
        if (theColumnList == null || theColumnList.Count <= 0)
        {

            foreach (ListItem theItem in ColumnCheckBoxList.Items)
            {
                bool visibility = false;

                if (gridType == "System.Web.UI.WebControls.GridView")
                {
                    visibility = theGridView.Columns[Convert.ToInt32(theItem.Value)].Visible;
                }
                else if (gridType == "Telerik.Web.UI.RadGrid")
                {
                    for (int i = 0; i < theRadGrid.Columns.Count; i++)
                        if (theRadGrid.Columns[i].UniqueName == theItem.Value)
                        {
                            visibility = theRadGrid.Columns[i].Visible;
                            break;
                        }
                }

                theItem.Selected = visibility;
            }
        }
        else
        {
            //If the lists is not null then we set the correct value for each column

            foreach (ListItem theItem in ColumnCheckBoxList.Items)
            {
                if (columnsHash.ContainsKey(theItem.Value))
                {
                    SelectionGridColumn col = (SelectionGridColumn)columnsHash[theItem.Value];
                    theItem.Selected = col.Visible;
                }
                else
                {
                    // We have a column that we did not store.  That's visible.
                    theItem.Selected = true;
                }
            }
        }

        // Now initialize the Grid so the columns have the appropriate visibility
        // Now change the column selection for the grid

        if (gridType == "System.Web.UI.WebControls.GridView")
        {
            // In the gridview we use the column number as the column name
            for (int i = 0; i < theGridView.Columns.Count; i++)
                if (!ignoreColumns.Contains(i.ToString()) &&
                    columnsHash.ContainsKey(i.ToString()))
                {
                    SelectionGridColumn theCol = (SelectionGridColumn)columnsHash[i.ToString()];
                    theGridView.Columns[i].Visible = theCol.Visible;
                }
        }
        else if (gridType == "Telerik.Web.UI.RadGrid")
        {
            // In the Telerik grids we use the unique column name as the name of the column
            for (int i = 0; i < theRadGrid.Columns.Count; i++)
                if (!ignoreColumns.Contains(theRadGrid.Columns[i].UniqueName) &&
                    columnsHash.ContainsKey(theRadGrid.Columns[i].UniqueName))
                {
                    SelectionGridColumn theCol = (SelectionGridColumn)columnsHash[theRadGrid.Columns[i].UniqueName];
                    theRadGrid.Columns[i].Visible = theCol.Visible;
                }
        }
        else
        {
            throw new Exception("Unknown Grid of type " + gridType);
        }
    }

    protected void SaveVisibleButton_Click(object sender, EventArgs e)
    {
        List<SelectionGridColumn> theList = new List<SelectionGridColumn>();

        string gridType = GridTypeHF.Value;
        List<string> ignoreColumns = GetListOfIgnoreColumns();

        if (ColumnCheckBoxList.Items.Count <= 0)
            return;

        // We add all the selections into a hashtable for quick lookup later. 
        Hashtable columnsHash = new Hashtable();

        foreach (ListItem theItem in ColumnCheckBoxList.Items)
        {
            SelectionGridColumn thecol = new SelectionGridColumn(AssociatedGridView,
                Convert.ToInt32(UserIDHF.Value), theItem.Value, theItem.Selected);
            columnsHash.Add(thecol.Column, thecol);
            theList.Add(thecol);
        }

        bool inserted = false;


        try
        {
            // Try to save the visibility statos of the columns as stated by the user
            GridColumnBLL theBLL = new GridColumnBLL();
            inserted = theBLL.InsertColumns(theList);
        }
        catch (Exception q)
        {
            log.Error("Failed to save column visibility list", q);
        }

        if (!inserted)
        {
            log.Error("Cannot modify column visibility for activities grid");
            SystemMessages.DisplaySystemErrorMessage("Failed to save column list to databse, please try again");
            return;
        }

        // Now change the column selection for the grid

        if (gridType == "System.Web.UI.WebControls.GridView")
        {
            // In the gridview we use the column number as the column name
            GridView theGridView = (GridView)this.Parent.FindControl(AssociatedGridView);
            for (int i = 0; i < theGridView.Columns.Count; i++)
                if (!ignoreColumns.Contains(i.ToString()) &&
                    columnsHash.ContainsKey(i.ToString()))
                {
                    SelectionGridColumn theCol = (SelectionGridColumn)columnsHash[i.ToString()];
                    theGridView.Columns[i].Visible = theCol.Visible;
                }
        }
        else if (gridType == "Telerik.Web.UI.RadGrid")
        {
            // In the Telerik grids we use the unique column name as the name of the column
            RadGrid theRadGrid = (RadGrid)this.Parent.FindControl(AssociatedGridView);
            for (int i = 0; i < theRadGrid.Columns.Count; i++)
                if (!ignoreColumns.Contains(theRadGrid.Columns[i].UniqueName) &&
                    columnsHash.ContainsKey(theRadGrid.Columns[i].UniqueName))
                {
                    SelectionGridColumn theCol = (SelectionGridColumn)columnsHash[theRadGrid.Columns[i].UniqueName];
                    theRadGrid.Columns[i].Visible = theCol.Visible;
                }
        }
        else
        {
            throw new Exception("Unknown Grid of type " + gridType);
        }


        // now fire the event that tells the page that we changed the grid rows, so they can choose to 
        // rebind if necessary
        EventArgs theEventArgs = new EventArgs();
        OnGridColumnsSelected(theEventArgs);
    }

    public delegate void GridColumnsSelectedHandler(object sender, EventArgs e);

    public event GridColumnsSelectedHandler GridColumnsSelected;

    public virtual void OnGridColumnsSelected(EventArgs e)
    {
        if (GridColumnsSelected != null)
        {
            GridColumnsSelected(this, e);
        }
    }

}