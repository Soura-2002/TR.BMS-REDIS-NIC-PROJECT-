/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dynamic_form_info;

import Common.CommonMethod;
import Security.SecurityClass;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import log.errorlog;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import redis.clients.jedis.Jedis;

/**
 *
 * @author Administrator
 */
@WebServlet(name = "SpecificInfoHtml", urlPatterns = {"/SpecificInfoHtml"})
public class SpecificInfoHtml extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, ClassNotFoundException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            Common.CommonMethod cm = new CommonMethod();
            String result = "";
            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            int reference_id = 0;
            String radis_ip = "";
            int radis_port = 0;
            radis_ip = "localhost";
            radis_port = 6379;
            JSONObject jsobj = null;
            JSONArray scheme_data_array = new JSONArray();
            int scheme_data_array_length = 0;
            errorlog log = new errorlog();
            if (request.getParameter("reference_id") != null && !"".equals(request.getParameter("reference_id"))) {
                reference_id = Integer.parseInt(SecurityClass.killcharNumber(request.getParameter("reference_id")));
            }
            try{
            Jedis jedis = new Jedis(radis_ip, radis_port);
            if (jedis.get("scheme_" + reference_id).length() > 0) {
                String scheme_data_json = jedis.get("scheme_" + reference_id);
                scheme_data_array = new JSONArray(scheme_data_json);
                scheme_data_array_length = scheme_data_array.length();
                int cnt = 0;
                int count = 1;
                int option_counter_count = 0;
                for (int n = 0; n < scheme_data_array_length; n++) {
                    jsobj = scheme_data_array.getJSONObject(n);
                    String field_type = jsobj.getString("field_type");
                    String scheme_name = jsobj.getString("scheme_name");

                    if ("textbox".equals(field_type)) {
                        String textbox_json = jsobj.getString("field_json");
                        int id = jsobj.getInt("sl_no");
                        try {
                            JSONObject jsonObj = new JSONObject(textbox_json);
                            JSONArray details = new JSONArray(jsonObj.get("textbox_json_array").toString());

                            for (int j = 0; j < details.length(); j++) {
                                JSONObject tmpOBJ = new JSONObject(details.getJSONObject(j).toString());
                                String label = tmpOBJ.optString("label");
                                String maximum_length = tmpOBJ.optString("maximum_length");
                                String required = tmpOBJ.optString("required");
                                String num_valid = tmpOBJ.optString("num_valid");
                                String valid = "", is_number = "";
                                if (required.equals("1")) {
                                    valid = "required";
                                }

                                result += " <div class=\"form-group col-md-6 " + valid + "\">";
                                result += "<label for=\"code\" class=\"control-label\">" + label + " :</label>";
                                result += "<input type=\"hidden\" name=textboxlabel_" + id + "  value='" + label + "' />";
                                if (num_valid.equals("2")) {
                                    is_number = "number";
                                    result += "<input type=\"text\" " + valid + " name=textbox_" + id + "  maxlength=" + maximum_length + " class=\"form-control\" onkeypress=\"return IsNumeric(event);\" />";

                                } else if (num_valid.equals("3")) {
                                    is_number = "decimal";
                                    result += "<input type=\"text\" " + valid + " name=textbox_" + id + "  maxlength=" + maximum_length + " class=\"form-control\" onkeypress=\"return IsDecimal(event);\" />";
                                } else {
                                    result += "<input type=\"text\" " + valid + " name=textbox_" + id + "  maxlength=" + maximum_length + " class=\"form-control\"/>";
                                }
                                result += "</div>";
                            }

                        } catch (JSONException e) {
                            e.printStackTrace();
                            int error_log_insert = log.InsertErrorLog(this.getClass().getSimpleName(), e.getMessage());
                        }
                    } else if ("datefield".equals(field_type)) {
                        String datefield_json = jsobj.getString("field_json");
                        int id = jsobj.getInt("sl_no");
                        try {
                            JSONObject jsonObj = new JSONObject(datefield_json);
                            JSONArray details = new JSONArray(jsonObj.get("datefield_json_array").toString());

                            for (int j = 0; j < details.length(); j++) {
                                JSONObject tmpOBJ = new JSONObject(details.getJSONObject(j).toString());
                                String label = tmpOBJ.optString("label");
                                String required = tmpOBJ.optString("required");
                                String valid = "";
                                if (required.equals("1")) {
                                    valid = "required";
                                }
                                result += " <div class=\"form-group col-md-6 " + valid + "\">";
                                result += "<label for=\"code\" class=\"control-label\">" + label + " :</label>";
                                result += "<input type=\"hidden\" name=datefieldlabel_" + id + "  value='" + label + "' />";
                                result += "<input type=\"date\" name=datefield_" + id + "  class=\"form-control\" />";
                                result += "</div>";
                            }

                        } catch (JSONException e) {
                            e.printStackTrace();
                            int error_log_insert = log.InsertErrorLog(this.getClass().getSimpleName(), e.getMessage());
                        }
                    } else if ("Dropdown".equals(field_type)) {
                        String dropdown_json = jsobj.getString("field_json");
                        int id = jsobj.getInt("sl_no");

                        try {
                            JSONObject jsonObj = new JSONObject(dropdown_json);
                            JSONArray details = new JSONArray(jsonObj.get("dropdown_json_array").toString());
                            for (int j = 0; j < details.length(); j++) {
                                option_counter_count++;
                                JSONObject tmpOBJ = new JSONObject(details.getJSONObject(j).toString());
                                String label = tmpOBJ.optString("label");
                                String required = tmpOBJ.optString("required");
                                JSONArray option_counter = new JSONArray(tmpOBJ.optString("option_counter"));
                                String valid = "";
                                if (required.equals("1")) {
                                    valid = "required";
                                }
                                result += " <div class=\"form-group col-md-6 " + valid + "\">";
                                result += "<label for=\"code\" class=\"control-label\">" + label + " :</label>";
                                result += "<input type=\"hidden\" name=dropdownlabel_" + id + "  value='" + label + "' />";
                                result += "<select name=dropdown_" + id + "  " + valid + " class=\"form-select mr-sm-2\" >";
                                result += "<option value=''>Please Select</option>";
                                for (int k = 0; k < option_counter.length(); k++) {

                                    JSONObject option_counterobj = new JSONObject(option_counter.getJSONObject(k).toString());
                                    result += "<option value='" + option_counterobj.optString("option_value" + k) + "'>'" + option_counterobj.optString("option_name" + k) + "'</option>";
                                }
                                result += "</select></div>";
                            }
                        } catch (JSONException e) {
                            e.printStackTrace();
                            int error_log_insert = log.InsertErrorLog(this.getClass().getSimpleName(), e.getMessage());
                        }
                    } else {
                        String dropdown_json = jsobj.getString("field_json");
                        String field_value = "";
                        int id = jsobj.getInt("sl_no");

                        try {
                            JSONObject jsonObj = new JSONObject(dropdown_json);
                            JSONArray details = new JSONArray(jsonObj.get("dropdown_json_array").toString());
                            for (int j = 0; j < details.length(); j++) {
                                option_counter_count++;
                                JSONObject tmpOBJ = new JSONObject(details.getJSONObject(j).toString());
                                String label = tmpOBJ.optString("label");
                                String required = tmpOBJ.optString("required");
                                JSONArray option_counter = new JSONArray(tmpOBJ.optString("option_counter"));
                                String valid = "";
                                if (required.equals("1")) {
                                    valid = "required";
                                }
                                result += " <div class=\"form-group col-md-6 " + valid + "\">";
                                result += "<label for=\"scheme_code\" class=\"control-label  font-weight-bold\">" + label + " :</label>";
                                result += "<input type=\"hidden\" name=dropdownlabel_" + id + "  value='" + label + "' />";
                                result += "<select name=dropdown_" + id + "  " + valid + " class=\"custom-select mr-sm-2\" >";
                                result += "<option value=''>Please Select</option>";
                                for (int k = 0; k < option_counter.length(); k++) {

                                    JSONObject option_counterobj = new JSONObject(option_counter.getJSONObject(k).toString());

                                    result += "<option value='" + option_counterobj.optString("option_value" + k) + "~prefilled'>" + option_counterobj.optString("option_name" + k) + "</option>";

                                }
                                result += "</select></div>";
                            }
                        } catch (JSONException e) {
                            int error_log_insert = log.InsertErrorLog(this.getClass().getSimpleName(), e.getMessage());
                            e.printStackTrace();
                        }
                    }
                    count++;
                }
                result += "</div>";
            } 
            }catch(Exception ex2) {

                String tabNamedata = "additional_info_draft";

                try {
                    int cnt = 0;
                    int count = 1;
                    int option_counter_count = 0;
                    con = new DBCon.DBSource().connectToDynamicDB();
                    String query = "SELECT * from " + tabNamedata + " WHERE reference_id = '" + reference_id + "' order by priority,field_id";
                    ps = con.prepareStatement(query);
                    rs = ps.executeQuery();

                    result += " <div class=\"form-row\">";

                    while (rs.next()) {

                        if ("textbox".equals(rs.getString("field_type"))) {
                            String textbox_json = rs.getString("field_json");
                            int id = rs.getInt("sl_no");
                            try {
                                JSONObject jsonObj = new JSONObject(textbox_json);
                                JSONArray details = new JSONArray(jsonObj.get("textbox_json_array").toString());

                                for (int j = 0; j < details.length(); j++) {
                                    JSONObject tmpOBJ = new JSONObject(details.getJSONObject(j).toString());
                                    String label = tmpOBJ.optString("label");
                                    String maximum_length = tmpOBJ.optString("maximum_length");
                                    String required = tmpOBJ.optString("required");
                                    String num_valid = tmpOBJ.optString("num_valid");
                                    String valid = "", is_number = "";
                                    if (required.equals("1")) {
                                        valid = "required";
                                    }

                                    result += " <div class=\"form-group col-md-6 " + valid + "\">";
                                    result += "<label for=\"code\" class=\"control-label\">" + label + " :</label>";
                                    result += "<input type=\"hidden\" name=textboxlabel_" + id + "  value='" + label + "' />";
                                    if (num_valid.equals("2")) {
                                        is_number = "number";
                                        result += "<input type=\"text\" " + valid + " name=textbox_" + id + "  maxlength=" + maximum_length + " class=\"form-control\" onkeypress=\"return IsNumeric(event);\" />";

                                    } else if (num_valid.equals("3")) {
                                        is_number = "decimal";
                                        result += "<input type=\"text\" " + valid + " name=textbox_" + id + "  maxlength=" + maximum_length + " class=\"form-control\" onkeypress=\"return IsDecimal(event);\" />";
                                    } else {
                                        result += "<input type=\"text\" " + valid + " name=textbox_" + id + "  maxlength=" + maximum_length + " class=\"form-control\"/>";
                                    }
                                    result += "</div>";
                                }

                            } catch (JSONException e) {
                                e.printStackTrace();
                                int error_log_insert = log.InsertErrorLog(this.getClass().getSimpleName(), e.getMessage());
                            }
                        } else if ("datefield".equals(rs.getString("field_type"))) {
                            String datefield_json = rs.getString("field_json");
                            int id = rs.getInt("sl_no");
                            try {
                                JSONObject jsonObj = new JSONObject(datefield_json);
                                JSONArray details = new JSONArray(jsonObj.get("datefield_json_array").toString());

                                for (int j = 0; j < details.length(); j++) {
                                    JSONObject tmpOBJ = new JSONObject(details.getJSONObject(j).toString());
                                    String label = tmpOBJ.optString("label");
                                    String required = tmpOBJ.optString("required");
                                    String valid = "";
                                    if (required.equals("1")) {
                                        valid = "required";
                                    }
                                    result += " <div class=\"form-group col-md-6 " + valid + "\">";
                                    result += "<label for=\"code\" class=\"control-label\">" + label + " :</label>";
                                    result += "<input type=\"hidden\" name=datefieldlabel_" + id + "  value='" + label + "' />";
                                    result += "<input type=\"date\" name=datefield_" + id + "  class=\"form-control\" />";
                                    result += "</div>";
                                }

                            } catch (JSONException e) {
                                e.printStackTrace();
                                int error_log_insert = log.InsertErrorLog(this.getClass().getSimpleName(), e.getMessage());
                            }
                        } else if ("Dropdown".equals(rs.getString("field_type"))) {
                            String dropdown_json = rs.getString("field_json");
                            int id = rs.getInt("sl_no");

                            try {
                                JSONObject jsonObj = new JSONObject(dropdown_json);
                                JSONArray details = new JSONArray(jsonObj.get("dropdown_json_array").toString());
                                for (int j = 0; j < details.length(); j++) {
                                    option_counter_count++;
                                    JSONObject tmpOBJ = new JSONObject(details.getJSONObject(j).toString());
                                    String label = tmpOBJ.optString("label");
                                    String required = tmpOBJ.optString("required");
                                    JSONArray option_counter = new JSONArray(tmpOBJ.optString("option_counter"));
                                    String valid = "";
                                    if (required.equals("1")) {
                                        valid = "required";
                                    }
                                    result += " <div class=\"form-group col-md-6 " + valid + "\">";
                                    result += "<label for=\"code\" class=\"control-label\">" + label + " :</label>";
                                    result += "<input type=\"hidden\" name=dropdownlabel_" + id + "  value='" + label + "' />";
                                    result += "<select name=dropdown_" + id + "  " + valid + " class=\"form-select mr-sm-2\" >";
                                    result += "<option value=''>Please Select</option>";
                                    for (int k = 0; k < option_counter.length(); k++) {

                                        JSONObject option_counterobj = new JSONObject(option_counter.getJSONObject(k).toString());
                                        result += "<option value='" + option_counterobj.optString("option_value" + k) + "'>'" + option_counterobj.optString("option_name" + k) + "'</option>";
                                    }
                                    result += "</select></div>";
                                }
                            } catch (JSONException e) {
                                e.printStackTrace();
                                int error_log_insert = log.InsertErrorLog(this.getClass().getSimpleName(), e.getMessage());
                            }
                        } else {
                            String dropdown_json = rs.getString("field_json");
                            String field_value = "";
                            int id = rs.getInt("sl_no");

                            try {
                                JSONObject jsonObj = new JSONObject(dropdown_json);
                                JSONArray details = new JSONArray(jsonObj.get("dropdown_json_array").toString());
                                for (int j = 0; j < details.length(); j++) {
                                    option_counter_count++;
                                    JSONObject tmpOBJ = new JSONObject(details.getJSONObject(j).toString());
                                    String label = tmpOBJ.optString("label");
                                    String required = tmpOBJ.optString("required");
                                    JSONArray option_counter = new JSONArray(tmpOBJ.optString("option_counter"));
                                    String valid = "";
                                    if (required.equals("1")) {
                                        valid = "required";
                                    }
                                    result += " <div class=\"form-group col-md-6 " + valid + "\">";
                                    result += "<label for=\"scheme_code\" class=\"control-label  font-weight-bold\">" + label + " :</label>";
                                    result += "<input type=\"hidden\" name=dropdownlabel_" + id + "  value='" + label + "' />";
                                    result += "<select name=dropdown_" + id + "  " + valid + " class=\"custom-select mr-sm-2\" >";
                                    result += "<option value=''>Please Select</option>";
                                    for (int k = 0; k < option_counter.length(); k++) {

                                        JSONObject option_counterobj = new JSONObject(option_counter.getJSONObject(k).toString());

                                        result += "<option value='" + option_counterobj.optString("option_value" + k) + "~prefilled'>" + option_counterobj.optString("option_name" + k) + "</option>";

                                    }
                                    result += "</select></div>";
                                }
                            } catch (JSONException e) {
                                int error_log_insert = log.InsertErrorLog(this.getClass().getSimpleName(), e.getMessage());
                                e.printStackTrace();
                            }
                        }
                        count++;
                    }
                    result += "</div>";
                } catch (SQLException ex) {
                    Logger.getLogger(CommonMethod.class.getName()).log(Level.SEVERE, null, ex);
                    int error_log_insert = log.InsertErrorLog(this.getClass().getSimpleName(), ex.getMessage());
                } finally {
                    try {
                        if (rs != null) {
                            rs.close();
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    };
                    try {
                        if (ps != null) {
                            ps.close();
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    };
                    try {
                        if (con != null) {
                            con.close();
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    };
                }
            }
            //  return result;
            out.print(result);
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(SpecificInfoHtml.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(SpecificInfoHtml.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
