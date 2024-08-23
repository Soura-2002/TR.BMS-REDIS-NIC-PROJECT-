<%-- 
    Document   : schemeWiseform
    Created on : 30 May, 2024, 11:48:18 AM
    Author     : Acer
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
        <%
            String reference_id = request.getParameter("data");

        %>
        <style>
            .form-group.required .control-label:after {
                content: "*";
                color: red;
            }
            legend.scheduler-border {
                width:inherit; /* Or auto */
                padding:0 10px; /* To give a bit of padding on the left and right */
                border-bottom:none;
                font-size: 15px;
            }
            fieldset.scheduler-border {
                border: 1px groove #ddd !important;
                padding: 0 1.4em 1.4em 1.4em !important;
                margin: 0 0 1.5em 0 !important;
                -webkit-box-shadow:  0px 0px 0px 0px #000;
                box-shadow:  0px 0px 0px 0px #000;
            }
            #param_field .btn-group{
                width: 50%;
            }
            #param_field button{
                padding: .375rem 1.75rem .375rem .75rem;
                font-weight: 400;
                line-height: 1.5;
                color: #495057;
                background-color: rgba(0, 0, 0, 0);
                background-color: #fff;
                border: 1px solid #ced4da;
                border-radius: .25rem;
                -webkit-appearance: none;
                -moz-appearance: none;
                appearance: none;
                width: 100%;
            }
            .multiselect-container{
                width: 100%;
            }
        </style>
    </head>
    <body>
        <div class="container-fluid bg-light">
            <jsp:include page="/Web/header.jsp"></jsp:include>            

                <div class="row mb-2">
                    <div class="col-md-12">


                        <div class="row mb-2">
                            <div class="col-sm-12">
                                <div class="row mb-2">
                                    <div class="col-md-12 col-md-offset-3 msform">
                                        <div id="msform">
                                            <input type="hidden" name="reference_id" id="reference_id" value="<%=reference_id%>" />
                                        <fieldset>
                                            <form id="msform5" action="" method="post">
                                                <h2 class="fs-title">Form</h2>
                                                <div id = "specific_info"> </div>
                                                <input type="Submit" name="Submit" id="Submit" class="btn btn-primary mt-2" value="Submit"/>
                                            </form>
                                        </fieldset>
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
        </body>
        <script>
            $(document).ready(function () {
                var reference_id = $("#reference_id").val();
                $.ajax({
                    url: "${pageContext.request.contextPath}/SpecificInfoHtml",
                    type: "POST",
                    data: {
                        reference_id: reference_id
                        },
                    success: function (data) {
                        $("#title").css("display", "block");
                        $("#specific_info").html(data);
                    }
                });
            });
    </script>
</html>