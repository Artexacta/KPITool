using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class UserControls_SearchUserControl_SC_TextSearchItem : AbstractSearchItem
{
    protected void Page_Load(object sender, EventArgs e)
    {
        rbtnOperation.Visible = ShowAndOrButtons;
        lblSpace.Visible = !ShowAndOrButtons;
        lblTitle.Text = this._title;
    }

    public override string GetValue()
    {
        if (string.IsNullOrEmpty(CSearch_Item_AspnetControl.Text.Trim()))
            return "";
        return "@" + this.SearchColumnKey + " " + CSearch_Item_AspnetControl.Text;
    }

    public override string GetOperation()
    {
        return rbtnOperation.SelectedValue;
    }

}