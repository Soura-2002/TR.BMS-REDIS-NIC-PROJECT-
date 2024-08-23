<%-- 
    Document   : billList
    Created on : 27 Feb, 2023, 12:38:14 PM
    Author     : acer
--%>

<%@page import="java.sql.Connection"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.util.Calendar"%>
<%@page import="Common.CommonMethod"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
// Set to expire far in the past.
    response.setHeader("Expires", "Sat, 6 May 1995 12:00:00 GMT");
    // Set standard HTTP/1.1 no-cache headers.
    response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
    // Set IE extended HTTP/1.1 no-cache headers (use addHeader).
    response.addHeader("Cache-Control", "post-check=0, pre-check=0");
    // Set standard HTTP/1.0 no-cache header.
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Configuration </title>
        <jsp:include page="/Web/header_style_sheet.jsp"></jsp:include>

        </head>
        <body>
            <div class="container-fluid bg-light">

                <div class="row">
                    <div class="col-md-12">


                        <div class="row">
                            <div class="col-sm-12">


                                <div class="card">
                                    <div class="card-header bg-info">
                                        <h4 class="text-white">Scheme List:</h4>
                                    </div>
                                    <div class="card-body bg-light">


                                        <div class="row d-none mt-2" id="benListDiv">
                                            <div class="col-md-12"> 
                                                <div class="row">
                                                    <div class="col-md-12">
                                                        <div class="card">
                                                            <div class="card-body bg-dark ">
                                                                <span class="text-white font-weight-bold">Scheme List</span>
                                                            </div> 
                                                        </div>
                                                    </div>                                                    
                                                </div>
                                                <div class="row">
                                                    <div class="input-group mb-3 col-md-12">
                                                        <table id="beneficiaryList" class="table table-sm table-striped table-bordered" style="width:100%">
                                                            <thead>
                                                                <tr>
                                                                    <th>Scheme Name</th>
                                                                    <th>Action</th>
                                                                </tr>
                                                            </thead>                                        
                                                        </table>
                                                    </div>
                                                </div>

                                            </div>
                                        </div>

                                    </div>
                                </div>
                            </div>            
                        </div>

                    </div>
                </div>
            <jsp:include page="/Web/footer.jsp"></jsp:include>
            </div>
        <jsp:include page="/Web/footer_script_file.jsp"></jsp:include>




            <script>
                $(document).ready(function () {


                    var table, table1;
                    var i = 0;


                    $('#benListDiv').removeClass("d-none").addClass("d-block");
                    $('#beneficiaryList').DataTable().clear().destroy();
                    table = $('#beneficiaryList').DataTable({
                        "ajax": {
                            "url": "${pageContext.request.contextPath}/SchemeList",
                            "type": "POST"
                        },
                        "iDisplayLength": 50,
                        'order': [[1, 'desc']],
                        'responsive': true,
                        "columns": [
                            {"data": "scheme_name"},
                            {"data": function (data, type, dataToSet) {
                                    return  "<a class=\"btn btn-primary\" href=\"${pageContext.request.contextPath}/schemeWiseform.jsp?data=" + data.reference_id + "\" target=\"_blank\">View Form</a>";
                                }}


                        ]



                    });
                    $('#beneficiaryList_wrapper').addClass("col-md-12");
                    $("select[name='beneficiaryList_length']").removeClass("custom-select custom-select-sm ");

                });


        </script>

    </body>
</html>


