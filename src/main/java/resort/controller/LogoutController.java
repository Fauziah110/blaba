package resort.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class LogoutController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // ✅ Retrieve session
        HttpSession session = request.getSession(false); // Avoid creating a new session if it doesn't exist

        if (session != null) {
            System.out.println("✅ DEBUG: Logging out user: " + session.getAttribute("customerName"));
            session.invalidate(); // ✅ Invalidate session
        }

        // ✅ Redirect to login page
        response.sendRedirect("login.jsp");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
