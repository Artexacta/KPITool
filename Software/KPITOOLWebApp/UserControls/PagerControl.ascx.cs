using System;
using System.Linq;
using log4net;

public partial class UserControls_PagerControl : System.Web.UI.UserControl
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    public delegate void PageChangedHandler(int row);

    public event PageChangedHandler PageChanged;

    public string CssClass
    {
        set { PagePanel.CssClass = value; }
        get { return PagePanel.CssClass; }
    }

    public string LabelCssClass
    {
        set { InfoPageLabel.CssClass = value; }
        get { return InfoPageLabel.CssClass; }
    }

    public enum InvisibilityMethodValues
    {
        PropertyControl,
        CssStyle
    }

    public InvisibilityMethodValues InvisibilityMethod
    {
        set { InvisibilityMethodHiddenField.Text = value.ToString(); }
        get
        {
            InvisibilityMethodValues value = InvisibilityMethodValues.PropertyControl;
            try
            {
                value = (InvisibilityMethodValues)Enum.Parse(typeof(InvisibilityMethodValues), InvisibilityMethodHiddenField.Text, true);
            }
            catch (Exception ex)
            {
                log.Error("cannot convert 'InvisibilityMethodHiddenField.Text' to 'InvisibilityMethodValues' value", ex);
                throw;
            }
            return value;
        }
    }

    public string ButtonsCssClass
    {
        set 
        { 
            FistPageLinkButton.CssClass = value;
            PreviousPageLinkButton.CssClass = value;
            NextPageLinkButton.CssClass = value;
            LastPageLinkButton.CssClass = value; 
        }
    }

    public int CurrentRow
    {
        set { CurrentRowHiddenField.Text = value.ToString(); }
        get
        {
            int currentRow = 0;
            try
            {
                currentRow = Convert.ToInt32(CurrentRowHiddenField.Text);
            }
            catch (Exception ex)
            {
                log.Error("Failed to convert CurrentRowHiddenField.Value to integer value", ex);
            }
            return currentRow;
        }
    }

    public int TotalRows
    {
        set { TotalRowsHiddenField.Text = value.ToString(); }
        get
        {
            int totalRows = 0;
            try
            {
                totalRows = Convert.ToInt32(TotalRowsHiddenField.Text);
            }
            catch (Exception ex)
            {
                log.Error("Failed to convert TotalRowsHiddenField.Value to integer value", ex);
            }
            return totalRows;
        }
    }

    public int PageSize
    {
        set { PageSizeHiddenField.Text = value.ToString(); }
        get
        {
            int pageSize = 10;
            try
            {
                pageSize = Convert.ToInt32(PageSizeHiddenField.Text);
            }
            catch (Exception ex)
            {
                log.Error("Failed to convert TotalRowsHiddenField.Value to integer value", ex);
            }
            return pageSize;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    #region Pagination Handlers

    public void BuildPagination()
    {
        if (InvisibilityMethod == InvisibilityMethodValues.PropertyControl)
        {
            FistPageLinkButton.Visible =
                PreviousPageLinkButton.Visible =
                NextPageLinkButton.Visible =
                LastPageLinkButton.Visible = true;
        }
        else
        {
            FistPageLinkButton.Style["visibility"] =
                PreviousPageLinkButton.Style["visibility"] =
                NextPageLinkButton.Style["visibility"] =
                LastPageLinkButton.Style["visibility"] = "visible";
        }

        int lastShowing = CurrentRow + PageSize > TotalRows ? TotalRows : CurrentRow + PageSize;
        InfoPageLabel.Text = Resources.Pager.ShowingLabel + (CurrentRow + 1).ToString() + " - " + lastShowing.ToString()
            + " " + Resources.Pager.OfLabel + " " + TotalRows.ToString();

        if (CurrentRow == 0)
        {
            if (InvisibilityMethod == InvisibilityMethodValues.PropertyControl)
            {
                FistPageLinkButton.Visible = PreviousPageLinkButton.Visible = false;
                NextPageLinkButton.Visible = CurrentRow + PageSize < TotalRows;
                LastPageLinkButton.Visible = NextPageLinkButton.Visible;
            }
            else
            {
                FistPageLinkButton.Style["visibility"] = PreviousPageLinkButton.Style["visibility"] = "hidden";
                NextPageLinkButton.Style["visibility"] = CurrentRow + PageSize < TotalRows ? "visible" : "hidden";
                LastPageLinkButton.Style["visibility"] = NextPageLinkButton.Style["visibility"];
            }
            return;
        }
        int lastRow = ((int)(TotalRows - 1) / PageSize) * PageSize;
        if (CurrentRow == lastRow)
        {
            if (InvisibilityMethod == InvisibilityMethodValues.PropertyControl)
            {
                NextPageLinkButton.Visible = LastPageLinkButton.Visible = false;
                PreviousPageLinkButton.Visible = FistPageLinkButton.Visible = true;
            }
            else
            {
                NextPageLinkButton.Style["visibility"] = LastPageLinkButton.Style["visibility"] = "hidden";
                PreviousPageLinkButton.Style["visibility"] = FistPageLinkButton.Style["visibility"] = "visible";
            }
        }

    }

    protected void FistPageLinkButton_Click(object sender, EventArgs e)
    {
        CurrentRow = 0;
        BuildPagination();
        if (PageChanged != null)
            PageChanged(CurrentRow);
    }

    protected void PreviousPageLinkButton_Click(object sender, EventArgs e)
    {
        CurrentRow -= PageSize;
        BuildPagination();
        if (PageChanged != null)
            PageChanged(CurrentRow);
    }

    protected void NextPageLinkButton_Click(object sender, EventArgs e)
    {
        CurrentRow += PageSize;
        BuildPagination();
        if (PageChanged != null)
            PageChanged(CurrentRow);
    }

    protected void LastPageLinkButton_Click(object sender, EventArgs e)
    {
        CurrentRow = ((int)(TotalRows - 1) / PageSize) * PageSize;
        BuildPagination();
        if (PageChanged != null)
            PageChanged(CurrentRow);
    }

    #endregion
}