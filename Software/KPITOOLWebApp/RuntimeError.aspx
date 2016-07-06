<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RuntimeError.aspx.cs" Inherits="RuntimeError" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head id="Head1" runat="server">
        <title>Runtime Error</title>
        <asp:Literal ID="JqueryAndMainMenuScript" runat="server"></asp:Literal>
    </head>
    <body>
        <form id="form1" runat="server">
            <div class="middle-box text-center animated fadeInDown">
                <h3 class="font-bold">
                    <asp:Image ID="Image1" runat="server" ImageUrl="~/Images/logo.png" />
                </h3>
                <div class="error-desc">
                    <p>
                        Estamos experimentando dificultades técnicas con el sistema.&nbsp; El error fue
                        registrado.&nbsp;  Si este problema persiste, contáctese con el administrador de su sistema.
                    </p>
                    <p>
                        <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="~/MainPage.aspx">Retornar a la página principal</asp:HyperLink>
                    </p>
                </div>
            </div>
        </form>
    </body>
</html>
