﻿using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class _Default : System.Web.UI.Page
{
    protected override void InitializeCulture()
    {
        Artexacta.App.Utilities.LanguageUtilities.SetLanguageFromContext();
        base.InitializeCulture();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        DateTextBox.Text = DateTime.Now.ToString();

        decimal valor = Convert.ToDecimal(500.563);

        DecimalTextBox.Text = valor.ToString(CultureInfo.InvariantCulture);
    }

}