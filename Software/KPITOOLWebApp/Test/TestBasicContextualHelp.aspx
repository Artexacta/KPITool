<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TestBasicContextualHelp.aspx.cs" Inherits="Test_TestBasicContextualHelp" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    
    <asp:Literal ID="JqueryAndMainMenuScript" runat="server"></asp:Literal>
</head>
<body>
    <form id="form1" runat="server" style="margin-left: 50px">
        <app:BasicContextualHelp runat="server" SourceType="HelpFile" HelpSourceFile="ORG-WIZ-1" Mode="Popover" />
        <br />
        <app:BasicContextualHelp runat="server" SourceType="HelpFile" HelpSourceFile="ORG-WIZ-1" Mode="Tooltip" />
        <br />
        <app:BasicContextualHelp runat="server" SourceType="HelpFile" HelpSourceFile="ORG-WIZ-1" Mode="Dialog"  />
    </form>
</body>
</html>
