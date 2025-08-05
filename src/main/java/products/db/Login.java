package products.db;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
@WebServlet("/login")
public class Login extends HttpServlet{

	public void service(HttpServletRequest r,HttpServletResponse r2) throws IOException
	{
	
		
		try {
			Connection con=DBUtil.getConnection();
			PreparedStatement s=con.prepareStatement("select * from users");
			
		
		
			ResultSet set=	s.executeQuery();
			String name=r.getParameter("username");
			String password=r.getParameter("password");
			System.out.println(name);
			while(set.next())
			{
			if(name.equals(set.getString("name") ) && password.equals(set.getString("password")))
			{
                int userId = set.getInt("id");

                // ✅ Set user ID and name in session
                HttpSession session = r.getSession();
                session.setAttribute("userId", userId);
                session.setAttribute("username", name);

                r2.sendRedirect("page1.jsp");

			}
			}
			r2.getWriter().print("Invalid");
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			r2.getWriter().print(e);
			e.printStackTrace();
		}
	}
}
