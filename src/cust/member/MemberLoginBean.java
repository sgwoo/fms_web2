package cust.member;

import acar.database.*;
import java.io.*;
import java.net.*;
import java.sql.*;
import javax.servlet.http.*;
import acar.util.*;

public class MemberLoginBean
{
	private String id;
	private String password;	 
	static private MemberLoginBean instance = null;

	private MemberLoginBean()
	{
		
	}
	static synchronized public MemberLoginBean getInstance() 
	{
		if (instance == null) 
		{
			instance = new MemberLoginBean();
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
	
	public int getLoginCust(String name, String passwd, HttpServletResponse res)
	{	
		DBConnectionManager connMgr = null;
		Connection conn = null;
		Statement stmt = null; 
		ResultSet rs = null;
		String query = null;
		String member_id = "";
		String client_id = "";
		String r_site = "";
		int result = 0;
		try
		{	
			connMgr = DBConnectionManager.getInstance();
			conn = connMgr.getConnection("acar");
			query= "SELECT * from member WHERE member_id = '" + name.trim() + "' and pwd = '" + passwd.trim() + "'";

			stmt = conn.createStatement();
			rs = stmt.executeQuery(query); 			

			if(rs.next())
			{
				member_id = rs.getString("member_id")==null?"":rs.getString("member_id").trim();
				client_id = rs.getString("client_id")==null?"":rs.getString("client_id").trim();
				r_site = rs.getString("r_site")==null?"":rs.getString("r_site").trim();
//System.out.println(member_id);
				setLoginCookie(member_id, client_id, r_site, "", res);				
				result = 1;
			}
		}
		catch(Exception e)
		{
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
			}
			catch(Exception se)
			{
			}
		return result;
		}
	}
	
	//세금계산서 fms 로그인
	public int getLoginCustPW(String client_id, String r_site, String passwd, HttpServletResponse res)
	{	
		DBConnectionManager connMgr = null;
		Connection conn = null;
		Statement stmt = null; 
		ResultSet rs = null;
		String query = null;
		String member_id = "";
		int result = 0;
		try
		{	
			connMgr = DBConnectionManager.getInstance();
			conn = connMgr.getConnection("acar");

			query= "SELECT * from member WHERE client_id ='"+client_id+"' and pwd='"+passwd+"'";

			if(!r_site.equals("")) query += " and r_site='"+r_site+"'";

			stmt = conn.createStatement();
			rs = stmt.executeQuery(query); 			

			if(rs.next())
			{
				member_id = rs.getString("member_id")==null?"":rs.getString("member_id").trim();
				setLoginCookie(member_id, client_id, r_site, "" , res);				
				result = 1;
			}
		}
		catch(Exception e)
		{
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
			}
			catch(Exception se)
			{
			}
		return result;
		}
	}

	//세금계산서 fms 로그인
	public int getLoginCustPW(String client_id, String r_site, String name, String passwd, HttpServletResponse res)
	{	
		DBConnectionManager connMgr = null;
		Connection conn = null;
		Statement stmt = null; 
		ResultSet rs = null;
		String query = null;
		String member_id = "";
		int result = 0;
		try
		{	
			connMgr = DBConnectionManager.getInstance();
			conn = connMgr.getConnection("acar");

			query= "SELECT * from member WHERE client_id ='"+client_id+"' and pwd='"+passwd+"' and member_id='"+name+"'";

			if(!r_site.equals("")) query += " and r_site='"+r_site+"'";

			stmt = conn.createStatement();
			rs = stmt.executeQuery(query); 			

			if(rs.next())
			{
				member_id = rs.getString("member_id")==null?"":rs.getString("member_id").trim();
				setLoginCookie(member_id, client_id, r_site, "", res);				
				result = 1;
			}
		}
		catch(Exception e)
		{
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
			}
			catch(Exception se)
			{
			}
		return result;
		}
	}

	//세금계산서 사업자/주민등록번호 로그인
	public int getLoginCustSsn(String client_id, String r_site, String ssn, HttpServletResponse res)
	{	
		DBConnectionManager connMgr = null;
		Connection conn = null;
		Statement stmt = null; 
		ResultSet rs = null;
		String query = null;
		String member_id = "";
		String enp_no = AddUtil.replace(ssn, "-", "");
		int result = 0;
		try
		{	
			connMgr = DBConnectionManager.getInstance();
			conn = connMgr.getConnection("acar");

			query = " SELECT b.client_id FROM client b, client_site c WHERE b.client_id ='"+client_id+"'"+
					" and b.client_id=c.client_id(+)";

			if(enp_no.length() == 10) query += " and (b.enp_no='"+enp_no+"' or TEXT_DECRYPT(c.enp_no, 'pw' )   ='"+enp_no+"')";

			if(enp_no.length() == 13) query += " and (TEXT_DECRYPT(b.ssn, 'pw' ) ='"+enp_no+"' or TEXT_DECRYPT(c.enp_no, 'pw' )  ='"+enp_no+"')";

			if(!r_site.equals("")) query += " and c.seq='"+r_site+"'";

			stmt = conn.createStatement();
			rs = stmt.executeQuery(query); 			

			if(rs.next())
			{
				member_id = "amazoncar";
				setLoginCookie(member_id, client_id, r_site, "",   res);				
				result = 1;
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
			result = 2;
			System.out.println(query);
		}
		finally
		{
			try
			{
				if(rs != null) rs.close();
				if(stmt != null) stmt.close();
				if(conn != null) connMgr.freeConnection("acar", conn);
			}
			catch(Exception se)
			{
			}
		return result;
		}
	}
	
	//세금계산서 사업자/주민등록번호 로그인
	public int getLoginCustMail(String client_id, String rent_mng_id, String rent_l_cd, String ssn, HttpServletResponse res)
	{	
		DBConnectionManager connMgr = null;
		Connection conn = null;
		Statement stmt = null; 
		ResultSet rs = null;
		String query = null;
		String member_id = "";
		String enp_no = AddUtil.replace(ssn, "-", ""); 
		int result = 0;
		try
		{	
			connMgr = DBConnectionManager.getInstance();
			conn = connMgr.getConnection("acar");

			query = " SELECT a.client_id FROM client a, cont b WHERE a.client_id ='"+client_id+"' and a.client_id=b.client_id and b.rent_mng_id='"+rent_mng_id+"' and b.rent_l_cd='"+rent_l_cd+"' ";

			if(enp_no.length() == 10) query += " and a.enp_no='"+enp_no+"' ";

			if(enp_no.length() == 6) query += " and substr(TEXT_DECRYPT(a.ssn, 'pw' ),1,6) ='"+enp_no+"' ";

			if(enp_no.length() == 10 || enp_no.length() == 6) {
				stmt = conn.createStatement();
				rs = stmt.executeQuery(query); 			
				if(rs.next())
				{									
					result = 1;
				}
			}
			
			if(result == 0) {
				result = 2;
			}
			
		}
		catch(Exception e)
		{
			e.printStackTrace();
			result = 2;
			System.out.println(query);
		}
		finally
		{
			try
			{
				if(rs != null) rs.close();
				if(stmt != null) stmt.close();
				if(conn != null) connMgr.freeConnection("acar", conn);
			}
			catch(Exception se)
			{
			}
		return result;
		}
	}	

	public boolean hasCookie(HttpServletRequest req, String cookieName)
	{
		Cookie[] cookies = req.getCookies();
		if(cookies!=null){
			for( int i = 0; i < cookies.length; i++ ){
				Cookie thisCookie =  cookies[i];				
				if((cookieName.equals(thisCookie.getName())) && (thisCookie.getValue() != null)){
					return true;
				}
			}
		}
		return false;
	}
	
	public String getCookieValue(HttpServletRequest req, String cookieName)
	{
		String value = null;
		Cookie[] cookies = req.getCookies();
		if(cookies!=null){
			for( int i = 0; i < cookies.length; i++ ){
				Cookie thisCookie =  cookies[i];
				if(cookieName.equals(thisCookie.getName())){
					value = thisCookie.getValue();
				}
			}
		}
		return value;
	}
	
	public void setCookieValue(HttpServletRequest req, String cookieName, String value)
	{
		Cookie[] cookies = req.getCookies();
		if(cookies!=null){
			for( int i = 0; i < cookies.length; i++ ){
				Cookie thisCookie =  cookies[i];
				if(cookieName.equals(thisCookie.getName())){
					thisCookie.setValue(value);
				}
			}
		}
	}

	public String getAcarName(HttpServletRequest req, String cookieName)
	{
		String value = null;
		Cookie[] cookies = req.getCookies();
		if(cookies!=null){
			for( int i = 0; i < cookies.length; i++ ){
				Cookie thisCookie =  cookies[i];
				if(cookieName.equals(thisCookie.getName())){
					value = thisCookie.getValue();
				}
			}
		}
		DBConnectionManager connMgr = null;
		Connection conn = null;
		Statement stmt = null; 
		ResultSet rs = null;
		String name = "error";
		String query = "SELECT nvl(firm_nm,client_nm) FROM client WHERE client_id = '" + value + "'";
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
			}
			catch(Exception se)
			{
			}
		return name;
		}
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
			}
			catch(Exception se)
			{
			}
		return name;
		}
	}
	
	public void setLoginCookie(String member_id, String client_id, String r_site, String email ,  HttpServletResponse res)
	{
		String id = URLEncoder.encode(member_id);
//		Cookie cookie1 = new Cookie("member_id", id);
		Cookie cookie1 = new Cookie("member_id", member_id);
		res.addCookie(cookie1);
		cookie1.setPath("/");

		Cookie cookie2 = new Cookie("client_id", client_id);
		res.addCookie(cookie2);
		cookie2.setPath("/");

		Cookie cookie3 = new Cookie("r_site", r_site);
		res.addCookie(cookie3);
		cookie3.setPath("/");
		
		Cookie cookie4 = new Cookie("email", email);
		res.addCookie(cookie4);
		cookie4.setPath("/");
	}

	public void delCookie(HttpServletRequest req, HttpServletResponse res, String cookieName)
	{
		Cookie[] cookies = req.getCookies();
		if(cookies!=null){
			for( int i = 0; i < cookies.length; i++ ){
				Cookie thisCookie =  cookies[i];
				if((cookieName.equals(thisCookie.getName())) && (thisCookie.getValue() != null)){				
					thisCookie.setMaxAge(0);
					thisCookie.setPath("/");                    //쿠키 접근 경로 지정
					setLoginCookie("", "",  "", "",  res);
					res.addCookie(thisCookie);
				}
			}
		}
	}

	public String getAuth(HttpServletRequest request, int norder)
	{

		String authority = getCookieValue(request, "auth");		
		String auth = authority.substring(norder-1,norder);		
		return auth;
	}


		/*     -------------------------------------------------            Mobile Fms      ---------------------------------------------------------------                 */	
	
	public int getLoginMobileCust(String name, String passwd, HttpServletResponse res)
	{	
		DBConnectionManager connMgr = null;
		Connection conn = null;
		Statement stmt = null; 
		ResultSet rs = null;
		String query = null;
		String member_id = "";
		String client_id = "";
		String r_site = "";
		String email = "";
		int result = 0;  
		try
		{	
			connMgr = DBConnectionManager.getInstance();
			conn = connMgr.getConnection("acar");
			
			query= "SELECT * from mobile_member WHERE email = '" + name.trim() + "' and  text_decrypt(passwd, 'pw')   = '" + passwd.trim() + "' and use_yn = 'Y' ";

			stmt = conn.createStatement();
			rs = stmt.executeQuery(query); 			

			if(rs.next())
			{
				email = rs.getString("email")==null?"":rs.getString("email").trim();
				member_id = rs.getString("fms_id")==null?"":rs.getString("fms_id").trim();
				client_id = rs.getString("client_id")==null?"":rs.getString("client_id").trim();
				r_site = rs.getString("r_site")==null?"":rs.getString("r_site").trim();
				
			//	r_site = rs.getString("r_site")==null?"":rs.getString("r_site").trim();
			//	System.out.println("java=" + member_id);
				setLoginCookie(member_id, client_id, r_site, email , res);				
				result = 1;
			}
		}
		catch(Exception e)
		{
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
			}
			catch(Exception se)
			{
			}
		return result;
		}
	}
	
	public int getLoginCustPw(String name,  String member_id, HttpServletResponse res)
	{	
		DBConnectionManager connMgr = null;
		Connection conn = null;
		Statement stmt = null; 
		ResultSet rs = null;
		String query = null;

		String client_id = "";
		String r_site = "";
		int result = 0;
		try
		{	
			connMgr = DBConnectionManager.getInstance();
			conn = connMgr.getConnection("acar");
			query= "SELECT * from mobile_member WHERE email = '" + name.trim() + "' and fms_id = '" + member_id.trim() + "' and use_yn = 'Y' ";

			stmt = conn.createStatement();
			rs = stmt.executeQuery(query); 			

			if(rs.next())
			{
				
				client_id = rs.getString("client_id")==null?"":rs.getString("client_id").trim();
				r_site = rs.getString("r_site")==null?"":rs.getString("r_site").trim();
//System.out.println(member_id);
				setLoginCookie(member_id, client_id, r_site, "", res);				
				result = 1;
			}
		}
		catch(Exception e)
		{
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
			}
			catch(Exception se)
			{
			}
		return result;
		}
	}
	
	
}