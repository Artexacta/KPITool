<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TestImagePhoto.aspx.cs" Inherits="Test_TestImagePhoto" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:Image ID="ImagenInmueble" runat="server"
                                        AlternateText='otra cosa'
                                        ImageUrl="~/ImageResize.aspx?W=100&H=150&ID=10811" />
    </div>
    </form>
</body>
</html>
