<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <title>云科传销查询系统</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0"/>

    <!-- bootstrap & fontawesome -->
    <link href="components/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="components/font-awesome/css/font-awesome.css"/>

    <!-- page specific plugin styles -->
    <!-- ace styles -->
    <link rel="stylesheet" href="assets/css/ace.css" class="ace-main-stylesheet" id="main-ace-style"/> <!--重要-->

    <!-- HTML5shiv and Respond.js for IE8 to support HTML5 elements and media queries -->

    <!--[if lte IE 8]-->
    <%--  <script src="js/html5shiv/dist/html5shiv.js"></script>
      <script src="js/respond/dest/respond.min.js"></script>--%>
    <!--[endif]-->
    <!-- basic scripts -->

    <script src="js/jquery-3.2.0.min.js"></script>

    <!--<script src="components/bootstrap/dist/js/bootstrap.js"></script>-->
    <script src="js/bootstrap.min.js"></script>

    <!-- page specific plugin scripts -->
    <!-- static.html end-->
    <script src="js/datatables/jquery.dataTables.min.js"></script>
    <script src="js/datatables/jquery.dataTables.bootstrap.min.js"></script>
    <%--<script src="js/datatables.net-buttons/dataTables.buttons.min.js"></script>--%>

    <script src="components/datatables.net-buttons/js/dataTables.buttons.js"></script>
    <script src="components/datatables.net-buttons/js/buttons.html5.js"></script>
    <script src="components/datatables.net-buttons/js/buttons.print.js"></script>
    <script src="js/datatables/dataTables.select.min.js"></script>
    <script src="js/jquery-ui/jquery-ui.min.js"></script>

    <%--<script src="js/jquery.form.js"></script>--%>
    <script src="js/func.js"></script>

    <link rel="stylesheet" href="css/jqueryui/jquery-ui.min.css"/>
    <link rel="stylesheet" href="components/jquery-ui.custom/jquery-ui.custom.css"/>

    <script type="text/javascript">
        jQuery(function ($) {
            var myTable = $('#dynamic-table')
            //.wrap("<div class='dataTables_borderWrap' />")   //if you are applying horizontal scrolling (sScrollX)
                .DataTable({
                    bAutoWidth: false,
                    "columns": [
                        {"data": "memberId", "sClass": "center", type: "num"},
                        {"data": "memberNo", "sClass": "center"},
                        {"data": "userName", "sClass": "center"},
                        {"data": "realName", "sClass": "center"},
                        {"data": "idCard", "sClass": "center"},
                        {"data": "phone", "sClass": "center"},
                        {"data": "userLevel", "sClass": "center"},
                        {"data": "yunkePoint", "sClass": "center"},
                        {"data": "deposit", "sClass": "center"},
                        {"data": "withdraw", "sClass": "center"},
                        {"data": "parentName", "sClass": "center"},
                        {"data": "curLevel", "sClass": "center"},
                        {"data": "childTotal", "sClass": "center"},
                        {"data": "childDepth", "sClass": "center"},
                        {"data": "directCount", "sClass": "center"},
                        {"data": "memberNo", "sClass": "center"}
                    ],

                    'columnDefs': [
                        {
                            "orderable": false, "targets": 0, width: "10px", render: function (data, type, row, meta) {
                                return meta.row + 1 + meta.settings._iDisplayStart;
                            }
                        },
                        {
                            "orderable": false, "targets": 1, title: '云科号', render: function (data, type, row, meta) {
                                return '<a href="#" class="hasDetail" data-Url="/memberInfo.jspx?memberId={0}">{1}</a>'.format(row["memberId"], data);
                            }
                        },
                        {"orderable": false, "targets": 2, title: '用户名'},
                        {"orderable": false, "targets": 3, title: '姓名'},
                        {"orderable": false, "targets": 4, title: '证件号'},
                        {"orderable": false, "targets": 5, title: '手机号'},
                        {"orderable": false, "targets": 6, title: '用户类型'},
                        {"orderable": false, "targets": 7, title: '云科盾'},
                        {
                            "orderable": false, "targets": 8, title: '充值记录',
                            render: function (data, type, row, meta) {
                                return data > 0 ? '<a href="#" class="hasDetail" data-Url="/memberDeposit.jsp?memberId={0}">{1}</a>'.format(row["memberId"], data) : '';
                            }
                        },
                        {
                            "orderable": false, "targets": 9, title: '提现金额',
                            render: function (data, type, row, meta) {
                                return data > 0 ? '<a href="#" class="hasDetail" data-Url="/memberWithdraw.jsp?memberId={0}">{1}</a>'.format(row["memberId"], data) : '';
                            }
                        },

                        {
                            "orderable": false, "targets": 10, title: '推荐人',
                            render: function (data, type, row, meta) {
                                return '<a href="#" class="research" name="parentNo" data-parentNo="{0}">{1}</a>'.format(row["parentNo"], data);
                            }
                        },
                        {"orderable": false, 'targets': 11, title: '当前层级'},
                        {"orderable": false, "targets": 12, title: '下级总数'},
                        {"orderable": false, "targets": 13, title: '最深级数'},
                        {"orderable": false, 'targets': 14, title: '直接下级数'},
                        {
                            "orderable": false, 'targets': 15, title: '查看上级',
                            render: function (data, type, row, meta) {
                                return '<div class="hidden-sm hidden-xs action-buttons">' +
                                    '<a class="hasDetail" href="#" data-Url="/memberParent.jsp?memberNo={0}&realName={1}"   >'.format(row["memberNo"], encodeURI(encodeURI(row["realName"]))) +
                                    '<i class="ace-icon green glyphicon glyphicon-arrow-up bigger-130"></i>' +
                                    '</a>' +
                                    '</div>';
                            }
                        }
                    ],
                    "aLengthMenu": [[20, 100, 1000], ["20", "100", "1000"]],//二组数组，第一组数量，第二组说明文字;
                    "aaSorting": [],//"aaSorting": [[ 4, "desc" ]],//设置第5个元素为默认排序
                    language: {
                        url: '/js/datatables/datatables.chinese.json'
                    },
                    searching: false,
                    scrollY: '60vh',
                    "ajax": {
                        url: "/listMember.jspx",
                        "data": function (d) {//删除多余请求参数
                            for (var key in d)
                                if (key.indexOf("columns") === 0 || key.indexOf("order") === 0 || key.indexOf("search") === 0)  //以columns开头的参数删除
                                    delete d[key];
                        }
                    },
                    "processing": true,
                    "serverSide": true,
                    select: {style: 'single'}
                });
            myTable.on('xhr', function (e, settings, json, xhr) {
                if (json.data.length > 0)
                    for (var i = 0; i < json.data.length; i++) {
                        var memberInfo = JSON.parse(json.data[i].memberInfo);
                        json.data[i].userLevel = memberInfo['基本信息']['等级'];
                        json.data[i].parentName = memberInfo['基本信息']['推荐人'] === '' ? json.data[i].parentNo : memberInfo['基本信息']['推荐人'];
                        json.data[i].deposit = memberInfo['资金']['充值金额'];
                        json.data[i].withdraw = memberInfo['资金']['提现金额'];
                        json.data[i].yunkePoint = memberInfo['资金']['云科盾'];
                    }
            });
            myTable.on('draw', function () {
                var url;
                /* $('#dynamic-table tr').find('a:eq(0)').click(function () {
                     url = "/memberInfo.jspx?memberNo={0}".format($(this).text());
                     window.open(url, "_blank");
                 });*/

                $('#dynamic-table tr').find('.research').click(function () {
                    url = "/listMember.jspx?{0}={1}".format($(this).attr("name"), $(this).attr("data-parentNo"));
                    $('.form-search')[0].reset();
                    $('input[name="parentNo"]').val($(this).attr("data-parentNo"));
                    myTable.ajax.url(encodeURI(url)).load();
                    $('#resultName').text($(this).attr("data-parentNo") + "的直接下级");
                });
                $('#dynamic-table tr').find('.hasDetail').click(function () {
                    window.open($(this).attr("data-Url"), "_blank");
                });
            });
            $('.btn-success').click(function () {
                search();
            });
            $('.form-search :text:lt(2)').each(function () {
                $(this).width(80);
            });
            $('.form-search :text:eq(2)').each(function () {
                $(this).width(160);
            });
            $('.form-search :text:eq(3)').each(function () {
                $(this).width(90);
            });
            $('.form-search :text:gt(3)').each(function () {
                $(this).width(60);
            });
            $('.form-search :text').keydown(function (event) {
                if (event.keyCode === 13)
                    search();
            });

            //$.fn.dataTable.Buttons.defaults.dom.container.className = 'dt-buttons btn-overlap btn-group btn-overlap';
            new $.fn.dataTable.Buttons(myTable, {
                buttons: [
                    {
                        "extend": "copy",
                        "text": "<i class='fa fa-copy bigger-110 pink'></i> <span class='hidden'>Copy to clipboard</span>",
                        "className": "btn btn-white btn-primary btn-bold"
                    },
                    {
                        "extend": "csv",
                        "text": "<i class='fa fa-database bigger-110 orange'></i> <span class='hidden'>Export to CSV</span>",
                        "className": "btn btn-white btn-primary btn-bold"
                    },
                    {
                        "extend": "excel",
                        "text": "<i class='fa fa-file-excel-o bigger-110 green'></i> <span class='hidden'>Export to Excel</span>",
                        "className": "btn btn-white btn-primary btn-bold"
                    },
                    {
                        "extend": "pdf",
                        "text": "<i class='fa fa-file-pdf-o bigger-110 red'></i> <span class='hidden'>Export to PDF</span>",
                        "className": "btn btn-white btn-primary btn-bold"
                    },
                    {
                        "extend": "print",
                        "text": "<i class='fa fa-print bigger-110 grey'></i> <span class='hidden'>Print</span>",
                        "className": "btn btn-white btn-primary btn-bold",
                        autoPrint: false
                    }
                ]
            }); // todo why only copy csv print
            myTable.buttons().container().appendTo($('.tableTools-container'));

            function search() {
                var url = "/listMember.jspx";
                var searchParam = "?threeThirty=" + $('#three_thirty').is(':checked');
                $('.form-search :text').each(function () {
                    if ($(this).val())
                        searchParam += "&" + $(this).attr("name") + "=" + $(this).val();
                });
                if (searchParam !== "")
                    url = "/listMember.jspx" + searchParam;
                //url = "/listMember.jspx" + searchParam.replace(/&/, "?");
                myTable.ajax.url(encodeURI(url)).load();
            }
        })
    </script>
</head>
<body class="no-skin">
<div class="main-container ace-save-state" id="main-container">
    <script type="text/javascript">
        try {
            ace.settings.loadState('main-container')
        } catch (e) {
        }
    </script>
    <div class="main-content">
        <div class="main-content-inner">

            <div class="breadcrumbs" id="breadcrumbs">
                <ul class="breadcrumb">
                    <form class="form-search form-inline">
                        <label>云科号：</label>
                        <input type="text" name="memberNo" placeholder="云科号……" class="nav-search-input"
                               autocomplete="off"/>
                        姓名：
                        <input type="text" name="realName" placeholder="姓名……" class="nav-search-input"
                               autocomplete="off"/>
                        证件号：
                        <input type="text" name="idCard" placeholder="证件号……" class="nav-search-input" autocomplete="off"/>
                        手机号：
                        <input type="text" name="phone" placeholder="手机号……" class="nav-search-input"
                               autocomplete="off"/>
                        推荐人 ：
                        <input type="text" name="parentName" placeholder="推荐人姓名……" class="nav-search-input"
                               autocomplete="off"/>&nbsp;&nbsp;&nbsp;
                        三层30人：
                        <input type="checkbox" id="three_thirty">&nbsp;&nbsp;&nbsp;
                        <button class="btn btn-sm btn-reset" type="reset">
                            <i class="ace-icon fa fa-undo bigger-110"></i>
                            清空
                        </button>
                    </form>
                </ul>
                <!-- #section:basics/content.searchbox -->
                <div class="nav-search" id="nav-search">
                    <button type="button" class="btn btn-sm btn-success">
                        搜索
                        <i class="ace-icon fa fa-arrow-right icon-on-right bigger-110"></i>
                    </button>
                </div><!-- /.nav-search -->

                <!-- /section:basics/content.searchbox -->
            </div>
            <!-- /section:basics/content.breadcrumbs -->
            <div class="page-content">

                <div class="row">
                    <div class="col-xs-12">

                        <div class="row">

                            <div class="col-xs-12">
                                <div class="table-header">
                                    <span id="resultName"></span> 成员列表
                                    <div class="pull-right tableTools-container"></div>
                                </div>
                                <!-- div.table-responsive -->

                                <!-- div.dataTables_borderWrap -->
                                <div>
                                    <table id="dynamic-table" class="table table-striped table-bordered table-hover">
                                    </table>
                                </div>
                            </div>
                        </div>

                        <!-- PAGE CONTENT ENDS -->
                    </div><!-- /.col -->
                </div><!-- /.row -->

            </div><!-- /.page-content -->
        </div><!-- /.main-container-inner -->
    </div><!-- /.main-content -->
    <div class="footer">
        <div class="footer-inner">
            <!-- #section:basics/footer -->
            <div class="footer-content">
                <span class="bigger-120"><span class="blue bolder">广东鑫证</span>司法鉴定所 &copy; 2018
                </span>
            </div>
            <!-- /section:basics/footer -->
        </div>
    </div>
</div><!-- /.main-container -->

</body>
</html>