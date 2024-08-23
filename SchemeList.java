/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dynamic_form_info;

import Common.CommonMethod;
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
import org.json.JSONArray;
import org.json.JSONObject;

/**
 *
 * @author acer
 */
@WebServlet(name = "SchemeList", urlPatterns = {"/SchemeList"})
public class SchemeList extends HttpServlet {

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
            throws ServletException, IOException, SQLException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();

        int update;
        Connection con = null;
        PreparedStatement ps = null;
        PreparedStatement ps1 = null;
        ResultSet rs = null;

        int deptId = 0, schemeId = 0, roleId = 0, officeId = 0;
        String dept_name = "", txtBatchId = "", schemecode = "", schemename = "";
        Common.CommonMethod cm = new CommonMethod();
        try {
            con = new DBCon.DBSource().connectToDynamicDB();
            String sql="SELECT scheme_name,reference_id FROM  public.additional_info Group by scheme_name,reference_id";
            JSONArray jsarr = null;
            JSONObject jsobj = new JSONObject();
            try {
                jsarr = cm.getResultJSON(sql, con);
                jsobj.put("aaData", jsarr);
            } catch (Exception ex) {
                Logger.getLogger(SchemeList.class.getName()).log(Level.SEVERE, null, ex);
            }
            out.print(jsobj);
            out.flush();
            out.close();
        } catch (Exception ex) {
            Logger.getLogger(SchemeList.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            out.flush();
            con.close();
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
        } catch (SQLException ex) {
            Logger.getLogger(SchemeList.class.getName()).log(Level.SEVERE, null, ex);
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
        } catch (SQLException ex) {
            Logger.getLogger(SchemeList.class.getName()).log(Level.SEVERE, null, ex);
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
