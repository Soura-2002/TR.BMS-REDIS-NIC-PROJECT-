<%-- 
    Document   : schemeRegistration
    Created on : Jul 29, 2021, 2:04:08 PM
    Author     : Administrator
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
        <%
            int deptId = 0, schemeId = 0, roleId = 0, officeId = 0;
            String userName = "", userDes = "";
            Connection con = null;

            Common.CommonMethod cm = new CommonMethod();
            String benefit_type = "", department_id = "", reference_id = "", edit = "", ddlprefilledlist = "",renewal = "";
            String Specific_info_html = "";
            int tot_textbox = 0, tot_dropdown = 0, tot_datefield = 0, tot_priority = 0;
            String declaration = "I do hereby declare that the information stated above is true to the best of my knowledge and I shall take full responsibility for any false / incorrect information furnished.";

//            Specific_info_html = cm.getSpecific_info_textbox_html(reference_id);
//
//            tot_textbox = cm.getTotTextboxCount(reference_id);
//            tot_dropdown = cm.getTotDropdownCount(reference_id);
//            tot_datefield = cm.getTotDateFieldCount(reference_id);
//            tot_priority = cm.getTotPriorityCount(reference_id) + 1;
//
ddlprefilledlist = cm.getPrefilledList();

        %>
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
                                            <h3 class="text-center">Configuration</h3>
                                            <!-- progressbar -->
                                            <ul id="progressbar">
                                                <li class="active">Dynamic Information</li>
                                                <li>Preview & Submit</li>
                                            </ul>
                                            <!-- fieldsets -->
                                            <input type="hidden" name="reference_id_final" id="reference_id_final" />



                                            <fieldset id="additational_info">
                                                <form id="msform4" action="" method="post">
                                                    <input type="hidden" name="edit_additational_info" id="edit_additational_info" <% if (!edit.equals("")) {%>value="1" <% } else { %>value="0"<% }%>/>
                                                <input type="hidden" name="tot_textbox" id="tot_textbox" <% if (!edit.equals("")) {%>value="<%=tot_textbox%>" <% } else { %>value=""<% }%> />
                                                <input type="hidden" name="tot_dropdown" id="tot_dropdown"  <% if (!edit.equals("")) {%>value="<%=tot_dropdown%>" <% } else { %>value=""<% }%> />
                                                <input type="hidden" name="tot_datefield" id="tot_datefield" <% if (!edit.equals("")) {%>value="<%=tot_datefield%>" <% } else { %>value=""<% }%> />
                                                <input type="hidden" name="tot_priority" id="tot_priority" <% if (!edit.equals("")) {%>value="<%=tot_priority%>" <% } else { %>value="1"<% }%> />

                                                <input type="hidden" name="additational_reference_id" id="additational_reference_id"  value="<%=reference_id%>"/>
                                                <input type="hidden" name="specific_info" value="1" />
                                                <div class="row mb-2">
                                                    <h4>Specific Information</h4>
                                                </div>

                                                <div class="row mb-2">

                                                    <div class="row" id="specific_info_field">
                                                        <div class="form-group col-md-4 required mb-2">
                                                            <label for="scheme" class="control-label">Scheme Name :</label>
                                                            <input type="text" autocomplete="off" required="" class="form-control" id="scheme_name" name="scheme_name" placeholder="Scheme Name">
                                                        </div>
                                                        <div class="form-group col-md-12">

                                                            <span name="add_textbox" id="add_textbox" class="btn btn-primary mr-2" onclick="openSpecificInfoHtml(1)">Add Textbox</span>
                                                            <span name="add_dropdown" id="add_textbox" class="btn btn-primary" onclick="openSpecificInfoHtml(2)">Add Dropdown</span>
                                                            <span name="add_date" id="add_date" class="btn btn-primary" onclick="openSpecificInfoHtml(4)">Add Datepicker</span>
                                                            <span name="add_master" id="add_master" class="btn btn-primary" onclick="openSpecificInfoHtml(3)">Include Prefilled List</span>
 

                                                            <span id="lblinstallmentError" style="color: red"></span>
                                                            <% if (!Specific_info_html.equals("")) {%>
                                                            <%=Specific_info_html%>
                                                            <%   }%>
                                                            <div class="row" id="prefilledlist" style="display:none;">
                                                                <div class="form-group col-md-6">
                                                                    <input type="hidden" name="master_priority" id="master_priority" value="" />
                                                                    <label for="scheme_code" class="control-label">Prefilled List :(Please use 'CTRL' key for multiple selection)</label>
                                                                    <select class="form-select mr-sm-2" multiple data-live-search="true" name="prefilled_list" onclick="addPriorityForMaster()">
                                                                        <%=ddlprefilledlist%>
                                                                    </select>                                      
                                                                </div>

                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <input type="button" id="submit_specific_data" name="metadata" class="next4 action-button" value="Save & Next"/>
                                                <a class="btn-danger btn text-decoration-none" href="SchemeList.jsp">Scheme List</a>
                                            </form>
                                        </fieldset>              
                                        <fieldset  id="preview">
                                            <form id="msform5" action="" method="post">
                                                <h2 class="fs-title">Preview</h2>
                                                <div class="print" id="printableArea">


                                                </div>
                                                <input type="button" name="previous4" id="previous4" class="previous action-button-previous" value="Previous"/>
                                                <input type="button" id="submit_final_data" name="submit_final_data" class="submit_final_data action-button" value="Final Submit"/>
                                                <a class="btn-danger btn text-decoration-none" href="SchemeList.jsp">Scheme List</a>
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





            <script>

                function printDiv(divName) {
                    var printContents = document.getElementById(divName).innerHTML;
                    var originalContents = document.body.innerHTML;
                    document.body.innerHTML = printContents;
                    window.print();
                    document.body.innerHTML = originalContents;
                }

                function getSpecificInfoHtml(reference_id) {
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
                }

                //jQuery time
                var current_fs, next_fs, other_fs, previous_fs; //fieldsets
                var left, opacity, scale; //fieldset properties which we will animate
                var animating; //flag to prevent quick multi-click glitches


                $(".next4").click(function () {

                    var reference_id = $("#additational_reference_id").val();
                    // $("#msform3").load();
                    if ($("#msform4").valid()) {
                        $.ajax({
                            url: "${pageContext.request.contextPath}/saveAdditationalInfo",
                            type: "POST",
                            data: $("#msform4").serialize(),
                            success: function (data) {
                                // alert(data);
                                var preview_refer_id = data;
                                var scheme_name = $("#scheme_name").val();
                                $("#additational_reference_id").val(data);
                                if (animating)
                                    return false;
                                animating = true;
                                current_fs = $("#additational_info");
                                // next_fs = $(this).parent().next();
                                next_fs = $("#preview");
                                //activate next step on progressbar using the index of next_fs
                                $("#progressbar li").eq(4).addClass("active");
                                $("#progressbar li").eq($("fieldset").index(current_fs)).removeClass("active");
                                $("#progressbar li").eq(3).addClass("success");
                                //show the next fieldset
                                next_fs.show();
                                //hide the current fieldset with style
                                current_fs.animate({opacity: 0}, {
                                    step: function (now, mx) {
                                        //as the opacity of current_fs reduces to 0 - stored in "now"
                                        //1. scale current_fs down to 80%
                                        scale = 1 - (1 - now) * 0.2;
                                        //2. bring next_fs from the right(50%)
                                        left = (now * 50) + "%";
                                        //3. increase opacity of next_fs to 1 as it moves in
                                        opacity = 1 - now;
                                        current_fs.css({
                                            'transform': 'scale(' + scale + ')',
                                            'position': 'absolute'
                                        });
                                        next_fs.css({'left': left, 'opacity': opacity});
                                    },
                                    duration: 800,
                                    complete: function () {
                                        current_fs.hide();
                                        animating = false;
                                    },
                                    //this comes from the custom easing plugin
                                    easing: 'easeInOutBack'
                                });
                                $.ajax({
                                    url: "${pageContext.request.contextPath}/PreviewDetails?reference_id=" + preview_refer_id + "&scheme_name=" + scheme_name,
                                    success: function (data) {
                                        $("#printableArea").html(data);
                                        getSpecificInfoHtml(preview_refer_id);
                                        $("#reference_id_final").val(preview_refer_id);
                                    }
                                });
                            }
                        });
                    }
                });
                $("#previous4").click(function () {
                    $("#edit_additational_info").val("1");
                    if (animating)
                        return false;
                    animating = true;
                    current_fs = $("#preview");
                    previous_fs = $("#additational_info");
                    //de-activate current step on progressbar
                    $("#progressbar li").eq(5).removeClass("active");
                    //show the previous fieldset
                    previous_fs.show();
                    //hide the current fieldset with style
                    current_fs.animate({opacity: 0}, {
                        step: function (now, mx) {
                            //as the opacity of current_fs reduces to 0 - stored in "now"
                            //1. scale previous_fs from 80% to 100%
                            scale = 0.8 + (1 - now) * 0.2;
                            //2. take current_fs to the right(50%) - from 0%
                            left = ((1 - now) * 50) + "%";
                            //3. increase opacity of previous_fs to 1 as it moves in
                            opacity = 1 - now;
                            previous_fs.css({
                                'transform': 'scale(' + scale + ')',
                                'position': 'relative',
                                'opacity': opacity
                            });
                            current_fs.css({'left': left, 'opacity': opacity});
                            //                                                                            current_fs.css({'left': left});
                            //                                                                            previous_fs.css({'transform': 'scale(' + scale + ')', 'opacity': opacity});
                        },
                        duration: 800,
                        complete: function () {
                            current_fs.hide();
                            animating = false;
                        },
                        //this comes from the custom easing plugin
                        easing: 'easeInOutBack'
                    });
                });
                $(".submit_final_data").click(function () {
                    var referenceid_final = $("#reference_id_final").val();
                    $.ajax({
                        url: "${pageContext.request.contextPath}/saveFinalData?reference_id_final=" + referenceid_final,
                        type: "POST",
                        success: function (data) {
                            if (!data == "0") {
                                alert("Data Successfully Submitted");
                                $(location).attr('href', '${pageContext.request.contextPath}/index.jsp');
                            }


                        }
                    });
                });

                function IsNumeric(e) {
                    var key = window.e ? e.keyCode : e.which;
                    if (e.keyCode === 8 || e.keyCode === 46) {
                        return true;
                    } else if (key < 48 || key > 57) {
                        lblinstallmentError.innerHTML = "Only Numbers are Allowed.";
                        //alert("Only Numbers are Allowed");
                        return false;
                    } else {
                        lblinstallmentError.innerHTML = "";
                        return true;
                    }
                }
                function isAlphaNumeric(e) {
                    var keyCode = window.e ? e.keyCode : e.which;
                    var lblError = document.getElementById("lblError");
                    lblError.innerHTML = "";
                    //Regex for Valid Characters i.e. Alphabets and Numbers.
                    var regex = /^[A-Za-z0-9]+$/;
                    //Validate TextBox value against the Regex.
                    var isValid = regex.test(String.fromCharCode(keyCode));
                    if (!isValid) {
                        lblError.innerHTML = "Only Alphabets and Numbers allowed.";
                    }

                    return isValid;
                }
                function lettersOnly()
                {
                    var charCode = event.keyCode;
                    if ((charCode > 64 && charCode < 91) || (charCode > 96 && charCode < 123) || charCode == 8)
                        return true;
                    else
                        return false;
                }


                function openSpecificInfoHtml(field_type) {
                    var tot_priority_count = $("#tot_priority").val();
                    if (field_type === 1) {
                        addTextboxConfig(tot_priority_count);
                        var textbox_count = $("#tot_textbox").val();
                        textbox_count++;
                        $("#tot_textbox").val(textbox_count);
                        tot_priority_count++;
                        $("#tot_priority").val(tot_priority_count);
                    } else if (field_type === 2) {
                        addDropdownConfig(tot_priority_count);
                        var dropdown_count = $("#tot_dropdown").val();
                        dropdown_count++;
                        $("#tot_dropdown").val(dropdown_count);
                        tot_priority_count++;
                        $("#tot_priority").val(tot_priority_count);
                    }  else if (field_type === 3) {
                        $("#prefilledlist").css("display", "block");
                        var tot_priority_count = $("#tot_priority").val();
                        tot_priority_count++;
                        $("#tot_priority").val(tot_priority_count);
                    } else {
                        addDateFieldConfig(tot_priority_count);
                        var datefield_count = $("#tot_datefield").val();
                        datefield_count++;
                        $("#tot_datefield").val(datefield_count);
                        tot_priority_count++;
                        $("#tot_priority").val(tot_priority_count);
                    }
                }
                function addPriorityForMaster() {
                    var tot_priority_count = $("#tot_priority").val();
                    tot_priority_count++;
                    var prev_master_priority = $("#master_priority").val();
                    $("#master_priority").val(prev_master_priority + "," + tot_priority_count);
                    $("#tot_priority").val(tot_priority_count);
                }


                function openFieldtypeSelection() {
                    $("#specific_info_field").append('<div class="form-group col-md-8 required"><div class="input-group"><div class="form-group col-md-3"><label for="installment" class="control-label">Field Type :</label><select id="field_type" class="form-select mr-sm-2" name="field_type" onchange="openSchemeSpecificInfoHtml(this.value)"><option value="">Please Select</option><option value="1" selected>Textbox</option><option value="2">Dropdown</option></select> <span id="lblinstallmentError" style="color: red"></span></div></div></div>');
                }

                var textbox = 0;
                var maxField = 50;
                var x = 1;
                function addTextboxConfig(tot_priority_count) {
                    $("#text_config_headline").css("display", "block");
                    // $("#specific_info_field").html("");
                    if (x < maxField) {
                        x++;
                        var addTextboxConfig_array =
                                textbox++;
                        var objTo = document.getElementById('specific_info_field')
                        var divtest = document.createElement("div");
                        divtest.setAttribute("class", "form-group col-md-12 removeclass_textbox" + textbox);
                        var rdiv = 'removeclass_textbox' + textbox;
                        divtest.innerHTML = '<div class="input-group"> <div class="form-group col-md-3 required"><input type="hidden" name="textbox_priority' + textbox + '" value="' + tot_priority_count + '" /><label for="installment" class="control-label">Text Field Label :</label><input autocomplete="off" type="text" class="form-control" name="textbox_lebel' + textbox + '" value=""><span id="lblinstallmentError" style="color: red"></span></div><div class="form-group col-md-3 required"><label for="installment" class="control-label">Maximum Length :</label><input autocomplete="off" type="text" class="form-control" name="textbox_length' + textbox + '" value=""><span id="lblinstallmentError" style="color: red"></span> </div><div class="form-group col-md-2 required"><label for="periodicity" class="control-label">Required:</label><input type="checkbox" class="form-check" value="1" name="textbox_valid' + textbox + '"><span id="lblinstallmentError" style="color: red"></span></div><div class="form-group col-md-1 required"><label for="periodicity" class="control-label">Numeric:</label><input type="radio" class="form-check" value="2" name="textbox_numericvalid' + textbox + '"><span id="lblinstallmentError" style="color: red"></span></div><div class="form-group col-md-1 required"><label for="periodicity" class="control-label">Decimal:</label><input type="radio" class="form-check" value="3" name="textbox_numericvalid' + textbox + '"><span id="lblinstallmentError" style="color: red"></span></div><div class="input-group-btn col-md-2"><br><button class="btn btn-danger mr-1" type="button" onclick="remove_TextboxConfig_fields(' + textbox + ');"><span class="minus">-</span> </button></div></div></div>';
                        objTo.appendChild(divtest)
                    }
                }

                function remove_TextboxConfig_fields(rid) {
                    //alert(rid);
                    if (rid === 2) {

                        $("#text_config_headline").css("display", "none");
                    }
                    $('.removeclass_textbox' + rid).remove();
                }

                var datefield = 0;
                var maxDateField = 50;
                var x = 1;
                function addDateFieldConfig(tot_priority_count) {
                    $("#date_config_headline").css("display", "block");
                    // $("#specific_info_field").html("");
                    if (x < maxDateField) {
                        x++;
                        var addDateConfig_array =
                                datefield++;
                        var objTo = document.getElementById('specific_info_field')
                        var divtest = document.createElement("div");
                        divtest.setAttribute("class", "form-group col-md-12 removeclass_datefield" + datefield);
                        var rdiv = 'removeclass_datefield' + datefield;
                        divtest.innerHTML = '<div class="input-group"> <div class="form-group col-md-3 required"><input type="hidden" name="datefield_priority' + datefield + '" value="' + tot_priority_count + '" /><label for="installment" class="control-label">Date Field Label :</label><input autocomplete="off" type="text" class="form-control" name="datefield_lebel' + datefield + '" value=""><span id="lblinstallmentError" style="color: red"></span></div><div class="form-group col-md-2"><label for="periodicity" class="control-label">Required:</label><input type="checkbox" class="form-check" value="1" name="datefield_valid' + datefield + '"><span id="lblinstallmentError" style="color: red"></span></div><div class="input-group-btn col-md-2"><br><button class="btn btn-danger mr-1" type="button" onclick="remove_datefieldConfig_fields(' + datefield + ');"><span class="minus">-</span> </button></div></div></div>';
                        objTo.appendChild(divtest)
                    }
                }

                function remove_datefieldConfig_fields(rid) {
                    //alert(rid);
                    if (rid === 2) {

                        $("#date_config_headline").css("display", "none");
                    }
                    $('.removeclass_datefield' + rid).remove();
                }

                var dropdown = 0;
                var maxField = 50;
                var y = 1;
                function addDropdownConfig(tot_priority_count) {
                    $("#dropdown_config_headline").css("display", "block");
                    //$("#specific_info_field").html("");
                    //                                                                alert(y );
                    //                                                                if (y < maxField) {
                    //                                                                    y++;
                    var adddropdown_array =
                            dropdown++;
                    var objTo = document.getElementById('specific_info_field')
                    var divtest = document.createElement("div");
                    divtest.setAttribute("class", "form-group col-md-12  removeclass_dropdown" + dropdown);
                    var rdiv = 'removeclass_dropdown' + dropdown;
                    divtest.innerHTML = '<div class="input-group"><input type="hidden" name="dropdown_priority' + dropdown + '" value="' + tot_priority_count + '" /><div class="form-group col-md-4 required"> <label for="installment" class="control-label">Field Label :</label><input autocomplete="off" type="text" class="form-control" name="dropdown_field_lebel' + dropdown + '"   value="" ><span id="lblinstallmentError" style="color: red"></span></div><div class="col-md-8" id="specific_dropdown_field_option' + dropdown + '"><div class="input-group"><div class="form-group col-md-4 required"><label for="installment" class="control-label">Option Name :</label><input autocomplete="off" type="text" class="form-control" name="option_name' + dropdown + '" value="" ><span id="lblinstallmentError" style="color: red"></span></div><div class="form-group col-md-4 required"> <label for="periodicity" class="control-label">Option Value:</label><input autocomplete="off" type="text" class="form-control" name="option_value' + dropdown + '" value="" ><span id="lblinstallmentError" style="color: red"></span> </div><div class="form-group col-md-2 required"><label for="periodicity" class="control-label">Required:</label><input type="checkbox" class="form-check" value="1" name="dropdown_valid' + dropdown + '"><span id="lblinstallmentError" style="color: red"></span></div> <div class="input-group-btn col-md-2"><br/><button class="btn btn-success mr-1" type="button"  onclick="adddropdownConfigoption(' + dropdown + ');"> <span class="plus">+</span> </button><button class="btn btn-danger" type="button" onclick="remove_dropdown_fields(' + dropdown + ');"><span class="minus">-</span> </button></button></div> </div></div></div><div class="clear"></div>';
                    objTo.appendChild(divtest)

                    // }

                }
                function remove_dropdown_fields(rid) {
                    if (rid === 2) {

                        $("#dropdown_config_headline").css("display", "none");
                    }
                    $('.removeclass_dropdown' + rid).remove();
                }
                var dropdown_option = 1;
                var maxField = 50;
                var z = 1;
                function adddropdownConfigoption(dropdowndivID) {
                    //                                                                if (z < maxField) {
                    //                                                                    alert(dropdowndivID);
                    //                                                                    z++;

                    var adddropdown_option_array =
                            dropdown_option++;
                    var objTo = document.getElementById('specific_dropdown_field_option' + dropdowndivID);
                    var divtest = document.createElement("div");
                    divtest.setAttribute("class", "form-group removeclass_option" + dropdown_option);
                    var rdiv = 'removeclass_option' + dropdown_option;
                    divtest.innerHTML = '<div class="input-group"><div class="form-group col-md-4 required"><label for="installment" class="control-label">Option Name :</label><input autocomplete="off" type="text" class="form-control" name="option_name' + dropdowndivID + '" value=""><span id="lblinstallmentError" style="color: red"></span></div><div class="form-group col-md-4 required"> <label for="periodicity" class="control-label">Option Value:</label><input autocomplete="off" type="text" class="form-control" name="option_value' + dropdowndivID + '" value=""><span id="lblinstallmentError" style="color: red"></span> </div> <div class="input-group-btn col-md-4"><br><button class="btn btn-danger" type="button" onclick="remove_dropdown_fields_option(' + dropdown_option + ');"><span class="minus">-</span> </button></div></div><div class="clear"></div>';
                    objTo.appendChild(divtest)

                    //   }

                }
                function remove_dropdown_fields_option(rid) {
                    $('.removeclass_option' + rid).remove();
                }


        </script>
    </body>
</html>