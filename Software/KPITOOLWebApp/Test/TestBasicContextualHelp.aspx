<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TestBasicContextualHelp.aspx.cs" Inherits="Test_TestBasicContextualHelp" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    
    <asp:Literal ID="JqueryAndMainMenuScript" runat="server"></asp:Literal>
</head>
<body>
    <form id="form1" runat="server" style="margin-left: 50px">
        <app:BasicContextualHelp runat="server" HelpText="This is a Help text. This text can be loaded from Resource" Mode="Popover" />
        <br />
        <app:BasicContextualHelp runat="server" HelpText="This is a Help text. This is shown in a tooltip" Mode="Tooltip" />
        <br />
        <app:BasicContextualHelp runat="server" HelpText="The help text also can be shown in modal dialog" Mode="Dialog"  />
    </form>
</body>
</html>
