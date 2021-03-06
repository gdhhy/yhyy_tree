<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <title>充值记录 - 道和云科</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0"/>

    <!-- bootstrap & fontawesome -->
    <link href="components/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="components/font-awesome/css/font-awesome.css"/>

    <!-- page specific plugin styles -->
    <!-- ace styles -->
    <link rel="stylesheet" href="assets/css/ace.css" class="ace-main-stylesheet" id="main-ace-style"/> <!--重要-->

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
    <script src="js/common.js"></script>
    <script src="js/accounting.min.js"></script>

    <link rel="stylesheet" href="css/jqueryui/jquery-ui.min.css"/>
    <link rel="stylesheet" href="components/jquery-ui.custom/jquery-ui.custom.css"/>

    <script type="text/javascript">
        jQuery(function ($) {
            var orderNo = $.getUrlParam("orderNo");
            var memberNo = $.getUrlParam("memberNo");
            $('#orderNo').text(orderNo);
            var url = "/product.jspx?orderNo=" + orderNo;

            function showMemberInfo(memberNo) {
                $.getJSON("/listMember.jspx?memberNo=" + memberNo, function (result) { //https://www.cnblogs.com/liuling/archive/2013/02/07/sdafsd.html
                    if (result.data.length > 0) {
                        $('#realName').text(result.data[0].realName);
                        $('#idCard').text(result.data[0].idCard);
                        $('#memberNo').text(result.data[0].memberNo);
                        $(document).attr("title", result.data[0].realName + ' - ' + $(document).attr("title"));//修改title值
                    }
                });
            }

            showMemberInfo(memberNo);
            var myTable = $('#dynamic-table')
            //.wrap("<div class='dataTables_borderWrap' />")   //if you are applying horizontal scrolling (sScrollX)
                .DataTable({
                    bAutoWidth: false,
                    "columns": [
                        {"data": "ID", "sClass": "center"},
                        {"data": "下订单时间", "sClass": "center"},
                        {"data": "订购会员ID", "sClass": "center"},
                        {"data": "供应商编号", "sClass": "center"},
                        {"data": "产品名称", "sClass": "center"},
                        {"data": "产品说明、如型号、颜色、规格等", "sClass": "center"},
                        {"data": "产品的单价", "sClass": "center"},
                        {"data": "购买的产品数量", "sClass": "center"},
                        {"data": "实际支付金额", "sClass": "center"},
                        {"data": "该订单产品的状态", "sClass": "center"}
                    ],

                    'columnDefs': [
                        {
                            "orderable": false, 'targets': 0, width: 20, render: function (data, type, row, meta) {
                                return meta.row + 1 + meta.settings._iDisplayStart;
                            }
                        },
                        {"orderable": true, 'targets': 1, title: '订单时间', width: 160},
                        {"orderable": false, "targets": 2, title: '订购会员ID'},
                        {"orderable": false, "targets": 3, title: '供应商编号', render: function (data, type, row, meta) {
                                return '<a href="#" class="hasDetail" data-Url="/memberInfo.jspx?memberNo={0}">{1}</a>'.format(data, data);
                            }},
                        {"orderable": false, "targets": 4, title: '产品名称'},
                        {"orderable": false, "targets": 5, title: '产品描述'},
                        {"orderable": false, "targets": 6, title: '产品单价'},
                        {"orderable": false, "targets": 7, title: '数量'},
                        {"orderable": false, "targets": 8, title: '支付金额'},
                        {"orderable": false, "targets": 9, title: '状态'}
                    ],
                    "aLengthMenu": [[20, 100, 1000, -1], ["20", "100", "1000", "全部"]],//二组数组，第一组数量，第二组说明文字;
                    "aaSorting": [],//"aaSorting": [[ 4, "desc" ]],//设置第5个元素为默认排序
                    language: {
                        url: '/js/datatables/datatables.chinese.json'
                    },
                    scrollY: '60vh',
                    "ajax": url,
                    "processing": true,
                    /*"footerCallback": function (tfoot, data, start, end, display) {
                        var total1 = 0.0;
                        var total2 = 0.0;
                        $.each(data, function (index, value) {
                            if (value["状态"] === '支付成功')
                                total1 += value["金额"];
                            if (value["状态"] === '审核通过')
                                total2 += value["金额"];
                        });
                        // Update footer
                        $(tfoot).find('th').eq(0).html('在线支付 成功金额合计： ' + accounting.formatMoney(total1, '￥') +
                            '&nbsp;&nbsp;&nbsp;线下转账 成功金额合计： ' + accounting.formatMoney(total2, '￥') +
                            '&nbsp;&nbsp;&nbsp;&nbsp;总计： ' + accounting.formatMoney(total1 + total2, '￥'));
                    },*/
                    select: {style: 'single'}
                });
            myTable.on('draw', function () {
                $('#dynamic-table tr').find('.hasDetail').click(function () {
                    window.open($(this).attr("data-Url"), "_blank");
                });
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

            <div class="page-content">

                <div class="row">
                    <div class="col-xs-12">

                        <div class="row">

                            <div class="col-xs-12">
                                <div class="table-header">
                                    姓名：<span id="realName"></span>，身份证号：<span id="idCard"></span>， 会员号：<span id="memberNo"></span>，订单 <span id="orderNo"></span> 明细
                                    <div class="pull-right tableTools-container"></div>
                                </div>
                                <!-- div.table-responsive -->

                                <!-- div.dataTables_borderWrap -->
                                <div>
                                    <table id="dynamic-table" class="table table-striped table-bordered table-hover">
                                        <%--<tfoot>
                                        <tr>
                                            <th colspan="7" style="text-align:right">
                                                <div id="footTotal">&nbsp;</div>
                                            </th>
                                        </tr>
                                        </tfoot>--%>
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