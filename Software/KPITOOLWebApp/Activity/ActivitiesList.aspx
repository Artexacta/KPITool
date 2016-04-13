<%@ Page Title="Activities" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="ActivitiesList.aspx.cs" Inherits="Activity_ActivitiesList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="Server">
    <div class="row">
        <div class="col-md-12">
            <div class="page-header">
                <div class="row">
                    <div class="col-md-1">
                        <app:AddButton ID="TheAddButton" runat="server" />
                    </div>
                    <div class="col-md-8 col-md-offset-3">
                        <asp:Panel ID="SearchPanel" runat="server" CssClass="input-group" DefaultButton="SearchImageButton">
                            <asp:TextBox ID="SearchTextBox" runat="server" CssClass="form-control" placeholder="Search..."></asp:TextBox>
                            <div class="input-group-addon last" style="cursor: pointer">

                                <a class="dropdown-toggle" id="advanced-search" style="color: #000; display: block">
                                    <i class="zmdi zmdi-chevron-down" id="advanced-search-icon"></i>
                                </a>
                                <div id="advanced-search-panel" class="dropdown-menu col-md-12" style="padding: 10px">
                                    <div style="font-size:12px;" class="m-b-5">Owner</div>
                                    <telerik:RadComboBox ID="ObjectsComboBox" runat="server"
                                        Width="100%"
                                        Filter="Contains"
                                        DataValueField="UniqueId"
                                        DataTextField="Name"
                                        OnClientSelectedIndexChanged="onObjectSelected"
                                        BorderColor="Transparent"
                                        EmptyMessage="-- Select an Object --">
                                        <HeaderTemplate>
                                            <ul>
                                                <li class="radcol">Name</li>
                                                <li class="radcol">Type</li>
                                            </ul>
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <ul>
                                                <li class="radcol">
                                                    <%# DataBinder.Eval(Container.DataItem, "Name") %>
                                                </li>
                                                <li class="radcol">
                                                    <%# DataBinder.Eval(Container.DataItem, "Type") %>
                                                </li>
                                            </ul>
                                        </ItemTemplate>
                                    </telerik:RadComboBox>
                                    <div class="text-right">
                                        <a href="#" id="clearSelection" style="display:none;font-size:9px">Clear selection</a>
                                    </div>
                                </div>
                            </div>
                            <span class="input-group-addon last">
                                <asp:LinkButton ID="SearchButton" runat="server" Style="color: #000" OnClick="SearchButton_Click">
                                    <i class="zmdi zmdi-search"></i>
                                </asp:LinkButton>
                                <asp:ImageButton ID="SearchImageButton" runat="server" OnClick="SearchButton_Click"
                                    ImageUrl="~/Images/Neutral/pixel.gif" Style="display: none" />
                            </span>
                        </asp:Panel>
                        <asp:Label ID="OwnerObjectLabel" runat="server" style="font-size: 10px"></asp:Label>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-6">
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <div class="tile">
                <div class="t-header">
                    <div class="th-title">Activities</div>
                </div>
                <div class="t-body tb-padding" id="ActivityList">
                    <asp:Repeater ID="ActivityRepeater" runat="server" OnItemDataBound="ActivityRepeater_ItemDataBound"
                        OnItemCommand="ActivityRepeater_ItemCommand">
                        <ItemTemplate>
                            <div class="row">
                                <div class="col-md-1">
                                    <asp:LinkButton ID="ViewActivity" CommandArgument='<%# Eval("ObjectId") %>' runat="server" CssClass="viewBtn detailsBtn" 
                                        CommandName="ViewActivity">
                                        <i class="zmdi zmdi-eye zmdi-hc-fw"></i>
                                    </asp:LinkButton>
                                </div>
                                <div class="col-md-1">
                                    <asp:LinkButton ID="EditActivity" CommandArgument='<%# Eval("ObjectId") %>' runat="server" CssClass="viewBtn editBtn" 
                                        CommandName="EditActivity">
                                        <i class="zmdi zmdi-edit zmdi-hc-fw"></i>
                                    </asp:LinkButton>
                                </div>
                                <div class="col-md-1 disabled">
                                    <asp:LinkButton ID="ShareActivity" CommandArgument='<%# Eval("ObjectId") %>' runat="server" CssClass="viewBtn shareBtn" 
                                        >
                                        <i class="zmdi zmdi-share zmdi-hc-fw"></i>
                                    </asp:LinkButton>
                                </div>
                                <div class="col-md-1">
                                    <asp:LinkButton ID="DeleteActivity" CommandArgument='<%# Eval("ObjectId") %>' runat="server" CssClass="viewBtn deleteBtn"
                                        CommandName="DeleteActivity"
                                        OnClientClick="return confirm('Are you sure you want to delete selected Activity?')">   
                                        <i class="zmdi zmdi-minus-circle-outline zmdi-hc-fw"></i>
                                    </asp:LinkButton>
                                </div>
                                <div class="col-md-8">
                                    <p style="font-size: 14px; padding-top: 2px;">
                                        <%# Eval("Name") %>
                                        (
                                            <asp:LinkButton ID="OwnerLinkButton" runat="server" Text='<%# GetOwnerInfo(Eval("Owner")) %>'
                                                CommandName="ViewOwner"
                                                CommandArgument='<%# Eval("ObjectId") %>'></asp:LinkButton>
                                        )
                                    </p>
                                </div>
                            </div>
                            <div class="row m-b-20">
                                <asp:Panel runat="server" id="emptyMessage" class="col-md-11 col-md-offset-1 m-t-5" visible="false">
                                    This activity does not have any objects. Create one by clicking on the <i class="zmdi zmdi-plus-circle-o"></i> icon above
                                </asp:Panel>
                                <asp:Panel ID="KpiImageContainer" runat="server" CssClass="col-md-1 m-t-5" Visible="false">
                                    <app:KpiImage ID="ImageOfKpi" runat="server" Visible="false" />
                                </asp:Panel>
                                <asp:Panel runat="server" id="detailsContainer" class="col-md-111 m-t-5" visible="false">
                                    This activity has 
                                    <asp:LinkButton ID="KpisButton" runat="server" Visible="false"></asp:LinkButton>
                                </asp:Panel>
                            </div>
                        </ItemTemplate>
                        <FooterTemplate>                                
                            <asp:Panel ID="EmptyMessageContaienr" runat="server" CssClass="row" Visible='<%# ActivityRepeater.Items.Count == 0 %>'>
                                <div class="col-md-12 text-center">
                                    -- There are no Activities registered. Create one by clicking on the <i class="zmdi zmdi-plus-circle-o"></i> icon above --
                                </div>
                            </asp:Panel>
                        </FooterTemplate>
                    </asp:Repeater>

                    <br />
                    <div style="overflow: hidden">
                        <a id="showTourBtn" runat="server" href="#" class="btn btn-default pull-right" clientidmode="Static" style="display: none">Show tips for this page</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <asp:HiddenField ID="ForceShowTour" runat="server" Value="false" />
    <script type="text/javascript">
        $(document).ready(function () {
            $("#clearSelection").click(function () {
                $find("<%= ObjectsComboBox.ClientID %>").clearSelection();
                $("#clearSelection").hide();
                return false;
            });
            $(".rcbArrowCellRight a").html("V");

            $("#advanced-search").click(function () {
                if($("#advanced-search-panel").is(":visible")){
                    $("#advanced-search-panel").slideUp(500, function () { $("#advanced-search-icon").removeClass("zmdi-chevron-up").addClass("zmdi-chevron-down"); });
                } else {
                    $("#advanced-search-panel").slideDown(500, function () { $("#advanced-search-icon").removeClass("zmdi-chevron-down").addClass("zmdi-chevron-up"); });
                }
                
            });
            
            $("#showTourBtn").click(function () {
                var storageKeys = Object.keys(localStorage);
                for (var i in storageKeys) {
                    var key = storageKeys[i];
                    if (key.indexOf("ActivityListPageTour") >= 0)
                        localStorage.removeItem(key);
                }
                $("#<%= ForceShowTour.ClientID %>").val("true");
                showTour();
                return false;
            });
            showTour();
            
        });
        $telerik.$(document).ready(function () {
            if ($find("<%= ObjectsComboBox.ClientID %>").get_value() != "")
                $("#clearSelection").show();
        });

        function onObjectSelected(sender, args) {
            $("#clearSelection").show();
        }

        function showTour() {
            
            var tour = new Tour({
                name: "ActivityListPageTour",
                steps: [
                    {
                        element: "#<%= TheAddButton.ClientID %>",
                        title: "You are in the Activity List page.",
                        content: "At any time you can create new system objects by clicking on this icon. You can create new organizations, evaluations, projects, actions or KPIs from anywhere"
                    }, {
                        element: "#ActivityList .editBtn:first",
                        title: "You are in the Activity List page.",
                        content: "Organizations, projects and actions have properties that you can set. You can edit the name as well as the properties by clickin on this icon."
                    }, {
                        element: "#ActivityList .detailsBtn:first",
                        title: "You are in the Activity List page.",
                        content: "You can view the object page using this icon.  In the object page you can see everything about the object."
                    }, {
                        element: "#ActivityList .shareBtn:first",
                        title: "You are in the Activity List page.",
                        content: "You can share this project with other people by clicking on this button"
                    }, {
                        element: "#<%= SearchPanel.ClientID %>",
                        title: "You are in the Activity List page.",
                        content: "You can search using this textbox. You can simply search be entering any text.",
                        placement: "bottom"
                    }
                ],
                backdrop: true
            });

            // Initialize the tour
            if ($("#<%= ForceShowTour.ClientID %>").val() == "true") {
                $("#<%= ForceShowTour.ClientID %>").val("false");
                tour.init(true);
            } else
                tour.init();

            // Start the tour
            tour.start();
            $("#showTourBtn").show();
        }

    </script>
</asp:Content>

