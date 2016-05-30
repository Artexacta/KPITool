<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Populate.aspx.cs" Inherits="Populate_Populate" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .auto-style1 {
            color: #800000;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div style="padding-left: 20px">
            <p>
                <span class="auto-style1"><strong>Important:</strong></span>
                This process will populate the database with a sample records.  Please configure the parameters below before executing the process. 
            </p>

            <p>
                User names to use durng the creation: <br /> 
                <asp:TextBox ID="UsersTextBox" runat="server" TextMode="MultiLine" Height="100px" 
                    Width="500px">ivan, peter, mary, tom, lucca, samson, lourdes, sergio, samantha, will, marion, solange, yousef, arrya, lisbeth, lucy, trent, silvia, stephanie, charles, jose, raul, vladimir, gaby, fabiola, carlos, marcela, camile, ahmed, rian, cesar, sulla, cicero, mugal, nawer, paco, lien99, may566, circe199, cienaga, planta, wall, cranting, prentter, petterson, admin</asp:TextBox>
            </p>
            <p>
                Users to create for each organization or area (random between 0 and this number): <br />
                <asp:DropDownList ID="UserNumberDropDownList" runat="server">
                    <asp:ListItem Text="0 to 5" Value="5"></asp:ListItem>
                    <asp:ListItem Text="0 to 10" Value="10" Selected="True"></asp:ListItem>
                    <asp:ListItem Text="0 to 15" Value="15"></asp:ListItem>
                    <asp:ListItem Text="0 to 20" Value="20"></asp:ListItem>
                    <asp:ListItem Text="0 to 30" Value="30"></asp:ListItem>
                </asp:DropDownList>
            </p>
            <p>
                Projects to create for each organization or area (random between 0 and this number): <br />
                <asp:DropDownList ID="ProjectsDropDownList" runat="server">
                    <asp:ListItem Text="0 to 5" Value="5"></asp:ListItem>
                    <asp:ListItem Text="0 to 10" Value="10" Selected="True"></asp:ListItem>
                    <asp:ListItem Text="0 to 15" Value="15"></asp:ListItem>
                    <asp:ListItem Text="0 to 20" Value="20"></asp:ListItem>
                    <asp:ListItem Text="0 to 30" Value="30"></asp:ListItem>
                </asp:DropDownList>
            </p>
            <p>
                Activities to create for each organizaiton, area or project (random between 0 and this number): <br />
                <asp:DropDownList ID="ActivitiesDropDownList" runat="server">
                    <asp:ListItem Text="0 to 5" Value="5"></asp:ListItem>
                    <asp:ListItem Text="0 to 10" Value="10" Selected="True"></asp:ListItem>
                    <asp:ListItem Text="0 to 15" Value="15"></asp:ListItem>
                    <asp:ListItem Text="0 to 20" Value="20"></asp:ListItem>
                    <asp:ListItem Text="0 to 30" Value="30"></asp:ListItem>
                </asp:DropDownList>
            </p>
            <p>
                KPIs to create for each organizaiton, area, project, activity or person (random between 0 and this number): <br />
                <asp:DropDownList ID="KPIDropDownList" runat="server">
                    <asp:ListItem Text="0 to 5" Value="5"></asp:ListItem>
                    <asp:ListItem Text="0 to 10" Value="10" Selected="True"></asp:ListItem>
                    <asp:ListItem Text="0 to 15" Value="15"></asp:ListItem>
                    <asp:ListItem Text="0 to 20" Value="20"></asp:ListItem>
                    <asp:ListItem Text="0 to 30" Value="30"></asp:ListItem>
                </asp:DropDownList>
            </p>
            <p>
                Percentage of the time that KPIs created have targets: <br />
                <asp:DropDownList ID="KPITargetsDropDownList" runat="server">
                    <asp:ListItem Text="30%" Value="3"></asp:ListItem>
                    <asp:ListItem Text="50%" Value="5" Selected="True"></asp:ListItem>
                    <asp:ListItem Text="70%" Value="7"></asp:ListItem>
                </asp:DropDownList>
            </p>
            <p>
                Percentage of the time that KPIs created have categories: <br />
                <asp:DropDownList ID="KPICategoriesDropDownList" runat="server">
                    <asp:ListItem Text="30%" Value="3"></asp:ListItem>
                    <asp:ListItem Text="50%" Value="5" Selected="True"></asp:ListItem>
                    <asp:ListItem Text="70%" Value="7"></asp:ListItem>
                </asp:DropDownList>
            </p>
            <p>
                Categories to create for each KPI, if the KPI needs categories (random between 1 and this number): <: <br />
                <asp:DropDownList ID="CategoriesDropDownList" runat="server">
                    <asp:ListItem Text="1 and 2" Value="2"></asp:ListItem>
                    <asp:ListItem Text="1 and 3" Value="3"></asp:ListItem>
                    <asp:ListItem Text="1 and 4" Value="4" Selected="True"></asp:ListItem>
                    <asp:ListItem Text="1 and 5" Value="5"></asp:ListItem>
                </asp:DropDownList>
            </p>
            <p>
                Percentage of the time that KPIs created have will have measurements (between 0 and this number: <br />
                <asp:DropDownList ID="MeasurementsDropDownList" runat="server">
                    <asp:ListItem Text="10%" Value="1"></asp:ListItem>
                    <asp:ListItem Text="30%" Value="3" Selected="True"></asp:ListItem>
                    <asp:ListItem Text="50%" Value="5"></asp:ListItem>
                    <asp:ListItem Text="70%" Value="7"></asp:ListItem>
                    <asp:ListItem Text="90%" Value="9"></asp:ListItem>
                </asp:DropDownList>
            </p>
            <p>
                Number of measurements to record for each KPI, when we generate measurements (between 0 and this number: <br />
                <asp:DropDownList ID="MeasurementsToGenerateDropDownList" runat="server">
                    <asp:ListItem Text="10" Value="10"></asp:ListItem>
                    <asp:ListItem Text="30" Value="30"></asp:ListItem>
                    <asp:ListItem Text="50" Value="50"></asp:ListItem>
                    <asp:ListItem Text="70" Value="70" Selected="True"></asp:ListItem>
                    <asp:ListItem Text="90" Value="90"></asp:ListItem>
                </asp:DropDownList>
            </p>
            <p>
                % of the time Everyone is allowed to Manage aspects (between 0 and this number: <br />
                <asp:DropDownList ID="AllowedEveryoneManageDropDownList" runat="server">
                    <asp:ListItem Text="1%" Value="1"></asp:ListItem>
                    <asp:ListItem Text="3%" Value="3" Selected="True"></asp:ListItem>
                    <asp:ListItem Text="10%" Value="10"></asp:ListItem>
                    <asp:ListItem Text="20%" Value="20"></asp:ListItem>
                    <asp:ListItem Text="30%" Value="20"></asp:ListItem>
                </asp:DropDownList>
            </p>
            <p>
                Number of people that are allowed to Own an object (randon number between 0 and this number: <br />
                <asp:DropDownList ID="AllowedOwnDropDownList" runat="server">
                    <asp:ListItem Text="1" Value="1"></asp:ListItem>
                    <asp:ListItem Text="2" Value="2"></asp:ListItem>
                    <asp:ListItem Text="3" Value="3" Selected="True"></asp:ListItem>
                    <asp:ListItem Text="5" Value="5"></asp:ListItem>
                    <asp:ListItem Text="7" Value="7"></asp:ListItem>
                </asp:DropDownList>
            </p>
            <p>
                Number of people that are allowed to Manage some aspect of Organizations, Projects, Activities and People (randon number between 0 and this number: <br />
                <asp:DropDownList ID="AllowManageDropDownList" runat="server">
                    <asp:ListItem Text="1" Value="1"></asp:ListItem>
                    <asp:ListItem Text="2" Value="2"></asp:ListItem>
                    <asp:ListItem Text="3" Value="3" Selected="True"></asp:ListItem>
                    <asp:ListItem Text="5" Value="5"></asp:ListItem>
                    <asp:ListItem Text="7" Value="7"></asp:ListItem>
                </asp:DropDownList>
            </p>
            <p>
                Number of people that are allowed to View / Enter Data for KPI (randon number between 0 and this number: <br />
                <asp:DropDownList ID="AllowedViewKPIDropdownList" runat="server">
                    <asp:ListItem Text="1" Value="1"></asp:ListItem>
                    <asp:ListItem Text="2" Value="3"></asp:ListItem>
                    <asp:ListItem Text="3" Value="5" Selected="True"></asp:ListItem>
                    <asp:ListItem Text="5" Value="7"></asp:ListItem>
                    <asp:ListItem Text="7" Value="10"></asp:ListItem>
                </asp:DropDownList>
            </p>
            <p>
                % of the time that the KPI is public for viewing (randon number between 0 and this number: <br />
                <asp:DropDownList ID="PublicKPIDropDownList" runat="server">
                    <asp:ListItem Text="5" Value="5"></asp:ListItem>
                    <asp:ListItem Text="10" Value="10"></asp:ListItem>
                    <asp:ListItem Text="20" Value="20" Selected="True"></asp:ListItem>
                    <asp:ListItem Text="30" Value="30"></asp:ListItem>
                    <asp:ListItem Text="50" Value="50"></asp:ListItem>
                </asp:DropDownList>
            </p>
            <p>
                Also, please note that when you execute this option, all data records for the database will be deleted!!!  You will loose ALL YOUR DATA.
            </p>

        <asp:Button ID="PopulateButton" runat="server" Text="Populate" OnClick="PopulateButton_Click" 
            OnClientClick="return confirm('Are you sure you want to delete all the data and re-populate the database?');"   />
        </div>
    </form>
</body>
</html>
