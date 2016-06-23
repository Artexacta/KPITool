using Artexacta.App.GridPageSize;
using Artexacta.App.GridPageSize.BLL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class UserControls_GridRows : System.Web.UI.UserControl
{
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

    public bool Rows3
    {
        get
        {
            return Convert.ToBoolean(Rows3HF.Value);
        }
        set
        {
            Rows3HF.Value = value.ToString();
        }
    }

    public bool Rows5
    {
        get
        {
            return Convert.ToBoolean(Rows5HF.Value);
        }
        set
        {
            Rows5HF.Value = value.ToString();
        }
    }

    public bool Rows10
    {
        get
        {
            return Convert.ToBoolean(Rows10HF.Value);
        }
        set
        {
            Rows10HF.Value = value.ToString();
        }
    }

    public bool Rows20
    {
        get
        {
            return Convert.ToBoolean(Rows20HF.Value);
        }
        set
        {
            Rows20HF.Value = value.ToString();
        }
    }

    public bool Rows30
    {
        get
        {
            return Convert.ToBoolean(Rows30HF.Value);
        }
        set
        {
            Rows30HF.Value = value.ToString();
        }
    }

    public bool Rows50
    {
        get
        {
            return Convert.ToBoolean(Rows50HF.Value);
        }
        set
        {
            Rows50HF.Value = value.ToString();
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (AssociatedGridView == null || AssociatedGridView.Length == 0)
        {
            this.Visible = false;
            return;
        }

        string gridType = gridType = this.Parent.FindControl(AssociatedGridView).GetType().FullName;

        switch (gridType)
        {
            //case "Telerik.Web.UI.RadGrid":
            //    RadGrid theRadGrid = (RadGrid)this.Parent.FindControl(AssociatedGridView);
            //    if (theRadGrid != null)
            //    {
            //        Rows3ImageButton.Visible = Rows3;
            //        Rows5ImageButton.Visible = Rows5;
            //        Rows10ImageButton.Visible = Rows10;
            //        Rows20ImageButton.Visible = Rows20;
            //        Rows30ImageButton.Visible = Rows30;
            //        Rows50ImageButton.Visible = Rows50;

            //        GridPageSizeBLL theBLL = new GridPageSizeBLL();
            //        GridPageSize theGridPageSize = theBLL.GetGridPageSizeState(AssociatedGridView.ToString(),
            //            HttpContext.Current.User.Identity.Name);
            //        if (theGridPageSize != null)
            //        {
            //            theRadGrid.PageSize = theGridPageSize.PageSize;
            //        }
            //    }
            //    else
            //    {
            //        this.Visible = false;
            //    }
            //    break;
            case "System.Web.UI.WebControls.GridView":
                GridView theGridView = (GridView)this.Parent.FindControl(AssociatedGridView);
                if (theGridView != null)
                {
                    Rows3ImageButton.Visible = Rows3;
                    Rows5ImageButton.Visible = Rows5;
                    Rows10ImageButton.Visible = Rows10;
                    Rows20ImageButton.Visible = Rows20;
                    Rows30ImageButton.Visible = Rows30;
                    Rows50ImageButton.Visible = Rows50;

                    GridPageSizeBLL theBLL = new GridPageSizeBLL();
                    GridPageSize TheGridPageSize = theBLL.GetGridPageSizeState(AssociatedGridView.ToString(),
                        HttpContext.Current.User.Identity.Name);
                    if (TheGridPageSize != null)
                    {
                        theGridView.PageSize = TheGridPageSize.PageSize;
                    }
                }
                else
                {
                    this.Visible = false;
                }
                break;
            default:
                this.Visible = false;
                break;
        }
    }

    protected void Rows3ImageButton_Click(object sender, ImageClickEventArgs e)
    {
        SetGridSize(3);
    }

    protected void Rows5ImageButton_Click(object sender, ImageClickEventArgs e)
    {
        SetGridSize(5);
    }

    protected void Rows10ImageButton_Click(object sender, ImageClickEventArgs e)
    {
        SetGridSize(10);
    }

    protected void Rows20ImageButton_Click(object sender, ImageClickEventArgs e)
    {
        SetGridSize(20);
    }

    protected void Rows30ImageButton_Click(object sender, ImageClickEventArgs e)
    {
        SetGridSize(30);
    }

    protected void Rows50ImageButton_Click(object sender, ImageClickEventArgs e)
    {
        SetGridSize(50);
    }

    private void SetGridSize(int size)
    {
        GridPageSizeBLL TheBll = new GridPageSizeBLL();

        string gridType = gridType = this.Parent.FindControl(AssociatedGridView).GetType().FullName;

        if (gridType == "System.Web.UI.WebControls.GridView")
        {
            GridView theGridView = (GridView)this.Parent.FindControl(AssociatedGridView);
            if (theGridView != null)
            {
                theGridView.PageSize = size;
                TheBll.SaveGridPageSizeState(AssociatedGridView.ToString(),
                    HttpContext.Current.User.Identity.Name, size);
            }
        }
        //else if (gridType == "Telerik.Web.UI.RadGrid")
        //{
        //    RadGrid theTelerikGrid = (RadGrid)this.Parent.FindControl(AssociatedGridView);
        //    if (theTelerikGrid != null)
        //    {
        //        theTelerikGrid.PageSize = size;
        //        TheBll.SaveGridPageSizeState(AssociatedGridView.ToString(),
        //            HttpContext.Current.User.Identity.Name, size);
        //    }
        //}

        // now fire the event that tells the page that we changed the grid rows, so they can choose to 
        // rebind if necessary
        EventArgs theEventArgs = new EventArgs();
        OnGridRowsChanged(theEventArgs);
    }

    public delegate void GridRowsChangedHandler(object sender, EventArgs e);

    public event GridRowsChangedHandler GridRowsChanged;

    public virtual void OnGridRowsChanged(EventArgs e)
    {
        if (GridRowsChanged != null)
        {
            GridRowsChanged(this, e);
        }
    }

}