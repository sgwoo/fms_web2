package acar.util;

import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import acar.database.DBConnectionManager;

public class LoginBean
{
	private String id;
	private String password;	 
	static private LoginBean instance = null;

	public LoginBean()
	{
		
	}
	static synchronized public LoginBean getInstance() 
	{
		if (instance == null) 
		{
			instance = new LoginBean();
		}
		return instance;
	}

	public String getId()
	{
		return this.id;
	}

	public String getPassword()
	{
		return this.password;
	}

	public void setId(String id)
	{
		this.id = id;
	}

	public void setPassword(String pass)
	{
		this.password = pass;
	}
	
	public String getName(String id)
	{
		return "no name";	
	}
	
	public int getLogin(String name, String passwd, HttpServletResponse res, HttpServletRequest req)
	{	
		DBConnectionManager connMgr = null;
		Connection conn = null;
		Statement stmt = null; 
		ResultSet rs = null;
		String query = null;
		int result = 0;
		try
		{	
			connMgr = DBConnectionManager.getInstance();
			conn = connMgr.getConnection("acar");
			
			
			query= "SELECT USER_ID,\n"//1
					+ "BR_ID,\n"//2
					+ "USER_NM,\n" 
					+ "ID,\n"
					+ "text_decrypt(user_psd, 'pw') USER_PSD,\n"			
					+ "USER_CD,\n"
					+ "USER_SSN,\n"
					+ "DEPT_ID,\n"
					+ "USER_H_TEL,\n"
					+ "USER_M_TEL,\n"
					+ "USER_POS,\n"
					+ "USER_AUT\n"//12
					+ "FROM USERS\n"
					+ "WHERE use_yn='Y' and ID = '" + name.trim() + "' and text_decrypt(user_psd, 'pw') = '" + passwd.trim() + "'";

			stmt = conn.createStatement();
			rs = stmt.executeQuery(query); 		

			while(rs.next())
			{
				//setLoginCookie(rs.getString(1), rs.getString(2), rs.getString(12), res);
				setLoginMemberSession(rs, req);
				result = 1;
			}
		}
		catch(Exception e)
		{
			//System.out.println("======================= ex : " + e.getMessage());
			e.printStackTrace();
			result = 2;
		}
		finally
		{
			try
			{
				if(rs != null) rs.close();
				if(stmt != null) stmt.close();
				if(conn != null) connMgr.freeConnection("acar", conn);
				conn = null;
			}
			catch(Exception se)
			{
			}
		return result;
		}
	}
	
	public int getKakaoLogin(String name, HttpServletResponse res, HttpServletRequest req)
	{	
		DBConnectionManager connMgr = null;
		Connection conn = null;
		Statement stmt = null; 
		ResultSet rs = null;
		String query = null;
		int result = 0;
		try
		{	
			connMgr = DBConnectionManager.getInstance();
			conn = connMgr.getConnection("acar");
			
			
			query= "SELECT USER_ID,\n"//1
					+ "BR_ID,\n"//2
					+ "USER_NM,\n" 
					+ "ID,\n"
					+ "text_decrypt(user_psd, 'pw') USER_PSD,\n"			
					+ "USER_CD,\n"
					+ "USER_SSN,\n"
					+ "DEPT_ID,\n"
					+ "USER_H_TEL,\n"
					+ "USER_M_TEL,\n"
					+ "USER_POS,\n"
					+ "USER_AUT\n"//12
					+ "FROM USERS\n"
					+ "WHERE use_yn='Y' and ID = '" + name.trim() + "'";
			
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query); 		
			
			while(rs.next())
			{
				//setLoginCookie(rs.getString(1), rs.getString(2), rs.getString(12), res);
				setLoginMemberSession(rs, req);
				result = 1;
			}
		}
		catch(Exception e)
		{
			//System.out.println("======================= ex : " + e.getMessage());
			e.printStackTrace();
			result = 2;
		}
		finally
		{
			try
			{
				if(rs != null) rs.close();
				if(stmt != null) stmt.close();
				if(conn != null) connMgr.freeConnection("acar", conn);
				conn = null;
			}
			catch(Exception se)
			{
			}
			return result;
		}
	}
	
	/**
	 * ���� ��Ű���� ���θ� üũ�ϴ����� ���� �α��� ���η� ��ü
	 * @author Dev.ywkim
	 * @since 2015. 04. 21
	 * @param req
	 * @param cookieName
	 * @return
	 */
	public boolean hasCookie(HttpServletRequest req, String cookieName)
	{
		/*
		Cookie[] cookies = req.getCookies();
		if(cookies!=null)
		{
			for( int i = 0; i < cookies.length; i++ )
			{
				Cookie thisCookie =  cookies[i];
				
				if((cookieName.equals(thisCookie.getName())) && (thisCookie.getValue() != null))
				{
					return true;
				}
			}
		}
		return false;
		*/
		
		return isLogin(req);
	}
	
	public String getCookieValue(HttpServletRequest req, String cookieName)
	{
		if( cookieName.equals("acar_id") ){
			cookieName = "USER_ID";
		}else if( cookieName.equals("") ){
			cookieName = "BR_ID";
		}
	
	   String value = null;
	   
	   	if( cookieName.equals("fmsCookie") ){
	   			Cookie[] cookies = req.getCookies();
				for( int i = 0; i < cookies.length; i++ )
				{
					Cookie thisCookie =  cookies[i];
					if(cookieName.equals(thisCookie.getName()))
					{
						value = thisCookie.getValue();
					}
				}
	   	} else {
	   	   	
		  value = getSessionValue(req, cookieName);
		}
		
		/*
		Cookie[] cookies = req.getCookies();
		for( int i = 0; i < cookies.length; i++ )
		{
			Cookie thisCookie =  cookies[i];
			if(cookieName.equals(thisCookie.getName()))
			{
				value = thisCookie.getValue();
			}
		}
		*/
		return value;
	}
	
	
	public String getAcarName(HttpServletRequest req, String cookieName)
	{
		String value = getSessionValue(req, "USER_NM");
		
		/*
		DBConnectionManager connMgr = null;
		Connection conn = null;
		Statement stmt = null; 
		ResultSet rs = null;
		String name = "error";
		String query = "SELECT USER_NM FROM USERS WHERE USER_ID = '" + value + "'";
		try
		{	
			connMgr = DBConnectionManager.getInstance();
			conn = connMgr.getConnection("acar");
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query); 
			if(rs.next())
			{
				name = rs.getString(1);
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
			name = "db error";
			System.out.println(value);
		}
		finally
		{
			try
			{
				if(rs != null) rs.close();
				if(stmt != null) stmt.close();
				if(conn != null) connMgr.freeConnection("acar", conn);
				conn = null;
			}
			catch(Exception se)
			{
			}
		
		return name;
		}
		
		*/
		
		return value;
	}

	public String getAcarName(String id)
	{
		
		DBConnectionManager connMgr = null;
		Connection conn = null;
		Statement stmt = null; 
		ResultSet rs = null;
		String name = "error";
		String query = "SELECT USER_NM FROM USERS WHERE USER_ID = '" + id + "'";
		try
		{	
			connMgr = DBConnectionManager.getInstance();
			conn = connMgr.getConnection("acar");
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query); 
			if(rs.next())
			{
				name = rs.getString(1);
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
			name = "db error";
		}
		finally
		{
			try
			{
				if(rs != null) rs.close();
				if(stmt != null) stmt.close();
				if(conn != null) connMgr.freeConnection("acar", conn);
				conn = null;
			}
			catch(Exception se)
			{
			}
		return name;
		}
	}
	
	public String getAcarName2(String id)
	{
		
		DBConnectionManager connMgr = null;
		Connection conn = null;
		Statement stmt = null; 
		ResultSet rs = null;
		String name = "error";
		
		String query = 	" 	SELECT USER_NM FROM USERS WHERE USER_ID='" + id + "'\r\n" + 
						"	UNION ALL\r\n" + 
						" 	SELECT REPLACE(OFF_NM,'�ֽ�ȸ�� ','') USER_NM FROM CONSIGNMENT \r\n" + 
						" 	WHERE OFF_ID='" + id + "' and rownum = 1";
	try
		{	
			connMgr = DBConnectionManager.getInstance();
			conn = connMgr.getConnection("acar");
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query); 
			if(rs.next())
			{
				name = rs.getString(1);
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
			name = "db error";
		}
		finally
		{
			try
			{
				if(rs != null) rs.close();
				if(stmt != null) stmt.close();
				if(conn != null) connMgr.freeConnection("acar", conn);
				conn = null;
			}
			catch(Exception se)
			{
			}
			return name;
		}
	}
	
	
	public String getDeptId(String id)
	{
		
		DBConnectionManager connMgr = null;
		Connection conn = null;
		Statement stmt = null; 
		ResultSet rs = null;
		String name = "error";
		String query = "SELECT dept_id FROM USERS WHERE USER_ID = '" + id + "'";
		try
		{	
			connMgr = DBConnectionManager.getInstance();
			conn = connMgr.getConnection("acar");
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query); 
			if(rs.next())
			{
				name = rs.getString(1);
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
			name = "db error";
		}
		finally
		{
			try
			{
				if(rs != null) rs.close();
				if(stmt != null) stmt.close();
				if(conn != null) connMgr.freeConnection("acar", conn);
				conn = null;
			}
			catch(Exception se)
			{
			}
		return name;
		}
	}
	
	public String getEndDt(HttpServletRequest req, String cookieName)
	{
		String value = null;
		Cookie[] cookies = req.getCookies();
		for( int i = 0; i < cookies.length; i++ )
		{
			Cookie thisCookie =  cookies[i];
			
			if(cookieName.equals(thisCookie.getName()))
			{
				value = thisCookie.getValue();
			}
		}
		DBConnectionManager connMgr = null;
		Connection conn = null;
		Statement stmt = null; 
		ResultSet rs = null;
		String end_dt = "error";
		String query = "SELECT END_DT FROM USERS WHERE USER_ID = '" + value + "'";
		try
		{	
			connMgr = DBConnectionManager.getInstance();
			conn = connMgr.getConnection("acar");
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query); 
			if(rs.next())
			{
				end_dt = rs.getString(1);
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
			end_dt = "db error";
		}
		finally
		{
			try
			{
				if(rs != null) rs.close();
				if(stmt != null) stmt.close();
				if(conn != null) connMgr.freeConnection("acar", conn);
				conn = null;
			}
			catch(Exception se)
			{
			}
		return end_dt;
		}
	}
	public void setLoginCookie(String name, String br_id, String auth, HttpServletResponse res)
	{
		Cookie cookie1 = new Cookie("acar_id", name);
		res.addCookie(cookie1);
		cookie1.setPath("/");

		Cookie cookie2 = new Cookie("acar_br", br_id);
		res.addCookie(cookie2);
		cookie2.setPath("/");
	}

	public void delCookie(HttpServletRequest req, HttpServletResponse res, String cookieName)
	{
		Cookie[] cookies = req.getCookies();

		for( int i = 0; i < cookies.length; i++ )
		{
			Cookie thisCookie =  cookies[i];
			if((cookieName.equals(thisCookie.getName())) && (thisCookie.getValue() != null))
			{
				
				thisCookie.setMaxAge(0);
				setLoginCookie("", "",  "", res);
				res.addCookie(thisCookie);
			}
			
		}
	}

	public String getAuth(HttpServletRequest request, int norder)
	{

		/*
		String authority = getCookieValue(request, "auth");
		
		String auth = authority.substring(norder-1,norder);
		*/
		
		
		String authority = getSessionValue(request, "USER_AUT");
		
		String auth = authority.substring(norder-1,norder);		
		
		return auth;
	}

	//�����Ǳ���
	public String getIPAuth(String ip, String user_id)
	{
		DBConnectionManager connMgr = null;
		Connection conn = null;
		Statement stmt = null; 
		ResultSet rs = null;
		String query = null;
		String ip_auth="R";
		try
		{	
			connMgr = DBConnectionManager.getInstance();
			conn = connMgr.getConnection("acar");
			
			query= "select ip_auth from ip_mng where ip='" + ip.trim() + "' and user_id='" + user_id.trim() + "'";

			stmt = conn.createStatement();
			rs = stmt.executeQuery(query); 

			
			if(rs.next())
			{
				ip_auth=rs.getString(1);
			}else{
				ip_auth="R";
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		finally
		{
			try
			{
				if(rs != null) rs.close();
				if(stmt != null) stmt.close();
				if(conn != null) connMgr.freeConnection("acar", conn);
				conn = null;
			}
			catch(Exception se)
			{
			}
		return ip_auth;
		}
	}
	/*
	*	�μ�id�������� -2003.06.17.Tue.
	*/
	public String getDept_id(String id)
	{
		
		DBConnectionManager connMgr = null;
		Connection conn = null;
		Statement stmt = null; 
		ResultSet rs = null;
		String dept_id = "error";
		String query = "SELECT dept_id FROM users WHERE user_id = '" + id + "'";
		try
		{	
			connMgr = DBConnectionManager.getInstance();
			conn = connMgr.getConnection("acar");
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query); 
			if(rs.next())
			{
				dept_id = rs.getString(1)==null?"":rs.getString(1);
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
			dept_id = "db error";
		}
		finally
		{
			try
			{
				if(rs != null) rs.close();
				if(stmt != null) stmt.close();
				if(conn != null) connMgr.freeConnection("acar", conn);
				conn = null;
			}
			catch(Exception se)
			{
			}
		return dept_id;
		}
	}
	
	/*
	*	�μ�id�������� -2003.06.17.Tue.
	*/
	public String getLoan_st(String id)
	{
		
		DBConnectionManager connMgr = null;
		Connection conn = null;
		Statement stmt = null; 
		ResultSet rs = null;
		String loan_st = "error";
		String query = "SELECT nvl(loan_st, '3')  FROM users WHERE user_id = '" + id + "'";
		try
		{	
			connMgr = DBConnectionManager.getInstance();
			conn = connMgr.getConnection("acar");
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query); 
			if(rs.next())
			{
				loan_st = rs.getString(1)==null?"":rs.getString(1);
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
			loan_st = "db error";
		}
		finally
		{
			try
			{
				if(rs != null) rs.close();
				if(stmt != null) stmt.close();
				if(conn != null) connMgr.freeConnection("acar", conn);
				conn = null;
			}
			catch(Exception se)
			{
			}
		return loan_st;
		}
	}
	
	
	//�α����� ��� �ڵ�����������. ������ ��¿��� secondhand/setpbystep_print.jsp
	public String getUser_m_tel(HttpServletRequest req, String cookieName)
	{
		String value = null;
		Cookie[] cookies = req.getCookies();
		for( int i = 0; i < cookies.length; i++ )
		{
			Cookie thisCookie =  cookies[i];
			if(cookieName.equals(thisCookie.getName()))
			{
				value = thisCookie.getValue();
			}
		}
		DBConnectionManager connMgr = null;
		Connection conn = null;
		Statement stmt = null; 
		ResultSet rs = null;
		String name = "error";
		String query = "SELECT USER_M_TEL FROM USERS WHERE USER_ID = '" + value + "'";
		try
		{	
			connMgr = DBConnectionManager.getInstance();
			conn = connMgr.getConnection("acar");
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query); 
			if(rs.next())
			{	
				name = rs.getString(1);
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
			name = "db error";
		}
		finally
		{
			try
			{
				if(rs != null) rs.close();
				if(stmt != null) stmt.close();
				if(conn != null) connMgr.freeConnection("acar", conn);
				conn = null;
			}
			catch(Exception se)
			{
			}
		return name;
		}
	}
	


		//�α��� ��Ű ����
	public void setDisplayCookie(String width, String height, HttpServletResponse res)
	{
		Cookie cookie1 = new Cookie("s_width", width);
		cookie1.setPath("/");
		res.addCookie(cookie1);

		Cookie cookie2 = new Cookie("s_height", height);
		cookie2.setPath("/");
		res.addCookie(cookie2);
	}
	
	
	/*
	*	2006.05.17. Yongsoon Kwon.
	*	id�� �ڵ�����ȣ ��������. ������ ���Ϲ߼ۿ��� /acar/apply/setpbystep4_mail.jsp���� 
	*	���Ϲ߼۽� <%@ include file="/acar/cookies.jsp" %>�κ��� ������ ������ ����� �߼� �ȵ�.
	*/
	public String getUser_m_tel(String id)
	{
		
		DBConnectionManager connMgr = null;
		Connection conn = null;
		Statement stmt = null; 
		ResultSet rs = null;
		String user_m_tel = "error";
		String query = "SELECT user_m_tel FROM users WHERE user_id = '" + id + "'";
		try
		{	
			connMgr = DBConnectionManager.getInstance();
			conn = connMgr.getConnection("acar");
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query); 
			if(rs.next())
			{
				user_m_tel = rs.getString(1);
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
			user_m_tel = "db error";
		}
		finally
		{
			try
			{
				if(rs != null) rs.close();
				if(stmt != null) stmt.close();
				if(conn != null) connMgr.freeConnection("acar", conn);
				conn = null;
			}
			catch(Exception se)
			{
			}
		return user_m_tel;
		}
	}

	/*
	*	�μ�id�������� -2003.06.17.Tue.
	*/
	public String getDept_id2(String name)
	{
		
		DBConnectionManager connMgr = null;
		Connection conn = null;
		Statement stmt = null; 
		ResultSet rs = null;
		String dept_id = "error";
		String query = "SELECT dept_id FROM users WHERE id = '" + name + "'";
		try
		{	
			connMgr = DBConnectionManager.getInstance();
			conn = connMgr.getConnection("acar");
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query); 
			if(rs.next())
			{
				dept_id = rs.getString(1)==null?"":rs.getString(1);
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
			dept_id = "db error";
		}
		finally
		{
			try
			{
				if(rs != null) rs.close();
				if(stmt != null) stmt.close();
				if(conn != null) connMgr.freeConnection("acar", conn);
				conn = null;
			}
			catch(Exception se)
			{
			}
		return dept_id;
		}
	}

	/**
	 * ȸ������ ���� ����
	 * @author Dev.ywkim
	 * @since 2015. 04. 17
	 * @param rs : ResultSet ��ü
	 * @param req : HttpServletRequest ��ü
	 */
	public void setLoginMemberSession( ResultSet rs, HttpServletRequest req ){
		HttpSession session = req.getSession();
		ResultSetMetaData metaData = null;
		SecurityUtil securityUtil = new SecurityUtil();
		
		try {
			metaData = rs.getMetaData();
			
			for( int i=0; i<metaData.getColumnCount(); i++ ){
				String value = rs.getString(i+1);
				
				if(value != null && value.length() > 0){
					value = securityUtil.encodeAES(value);
				}
				
				session.setAttribute(metaData.getColumnName(i+1) , value);
			}	
			
		} catch (SQLException e) {} 
		catch (InvalidKeyException e) {}
		catch (IllegalBlockSizeException e) {}
		catch (BadPaddingException e) {}
		catch (NoSuchAlgorithmException e) {}
		catch (NoSuchPaddingException e) {}
		
	}

	/**
	 * ���� ������ ������ ��ȯ�Ѵ�.
	 * @param req : HttpServletRequest
	 * @param sessionName : ����( ���̺���̶� ���� ) ���� �̸�
	 * @return
	 */
	public String getSessionValue( HttpServletRequest req, String sessionName ){
		
		String sessionValue = "";
		HttpSession session = req.getSession();
		SecurityUtil securityUtil = new SecurityUtil();
		
		if( sessionName != null && sessionName.length() > 0 ){
			sessionValue = (String) session.getAttribute(sessionName);
			
			if( sessionValue != null && sessionValue.length() > 0 ){
				sessionValue = securityUtil.decodeAES(sessionValue);
			}
		}
		
		if( sessionValue == null ) sessionValue = "";
		
		return sessionValue;
	}
	
	/**
	 * �α��� ���θ� ��ȯ�Ѵ�.
	 * @param req : HttpServletRequest
	 * @return �α��� ���� : true or false
	 */
	public boolean isLogin( HttpServletRequest req ){
		
		HttpSession session = req.getSession();
		
		if( session.getAttribute("USER_ID") != null && session.getAttribute("USER_ID").toString().length() > 0 ){
			return true;
		}else{
			return false;	
		}
	}
	
	/**
	 * �α׾ƿ��Ѵ�.
	 * @param req : HttpServletRequest
	 */
	public void setLogout( HttpServletRequest req ){
		
		HttpSession session = req.getSession();
		
		if( session != null && isLogin(req) ){
			session.invalidate();
		}
		
	}
	
	public String getEndDt(String user_id)
	{		
		DBConnectionManager connMgr = null;
		Connection conn = null;
		Statement stmt = null; 
		ResultSet rs = null;
		String end_dt = "error";
		String query = "SELECT END_DT FROM USERS WHERE USER_ID = '" + user_id + "'";
		try
		{	
			connMgr = DBConnectionManager.getInstance();
			conn = connMgr.getConnection("acar");
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query); 
			if(rs.next())
			{
				end_dt = rs.getString(1);
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
			end_dt = "db error";
		}
		finally
		{
			try
			{
				if(rs != null) rs.close();
				if(stmt != null) stmt.close();
				if(conn != null) connMgr.freeConnection("acar", conn);
				conn = null;
			}
			catch(Exception se)
			{
			}
		return end_dt;
		}
	}
	
	//temp

}