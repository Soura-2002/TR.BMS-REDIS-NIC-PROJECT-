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
import java.sql.CallableStatement;
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

/**
 *
 * @author Administrator
 */
@WebServlet(name = "saveFinalData", urlPatterns = {"/saveFinalData"})
public class saveFinalData extends HttpServlet {

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
            throws ServletException, IOException, Exception {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        try ( PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            Common.CommonMethod cm = new CommonMethod();
            errorlog log = new errorlog();
            Connection con = null;
            PreparedStatement ps = null;
            PreparedStatement ps1 = null;
            ResultSet rs = null;
            int status = 0;
            String reference_id_final = "";

            CallableStatement cs = null;

            if (request.getParameter("reference_id_final") != null && !"".equals(request.getParameter("reference_id_final"))) {
                reference_id_final = SecurityClass.killchar(request.getParameter("reference_id_final")).trim();
            }

            try {
                con = new DBCon.DBSource().connectToDynamicDB();
                cs = con.prepareCall("{call insert_final_data(?)}");
                cs.setString(1, reference_id_final);

                if (cs.execute()) {
                    status = 1;

                } else {
                    status = 0;
                }

            } catch (SQLException e) {
                e.printStackTrace();
                int error_log_insert = log.InsertErrorLog(this.getClass().getSimpleName(), e.getMessage());
            } finally {
                if (con != null) {
                    try {
                        con.close();
                    } catch (SQLException ex) {
                    }
                    con = null;
                }
                if (ps != null) {
                    try {
                        ps.close();
                    } catch (SQLException ex) {
                    }
                }
                if (ps1 != null) {
                    try {
                        ps1.close();
                    } catch (SQLException ex) {
                    }
                }
            }

            if (status > 0) {
                out.print(reference_id_final);
            } else {
                out.print(0);
            }

            out.flush();
            out.close();
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
        } catch (Exception ex) {
            Logger.getLogger(saveFinalData.class.getName()).log(Level.SEVERE, null, ex);
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
        } catch (Exception ex) {
            Logger.getLogger(saveFinalData.class.getName()).log(Level.SEVERE, null, ex);
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
