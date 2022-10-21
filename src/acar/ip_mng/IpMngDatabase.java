/**
 * IP 관리
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.ip_mng;

import java.util.*;
import java.sql.*;
import acar.util.*;
import java.text.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.UnknownDataException;
import acar.exception.DatabaseException;

public class IpMngDatabase {

    private static IpMngDatabase instance;
    private DBConnectionManager connMgr;   
    // Pool로 부터 Connection 객체를 가져올때 사용하는 Pool Name 
    private final String DATA_SOURCE = "acar"; 
 
    // 싱글톤 클래스로 구현 
    // 생성자를 private 로 선언
    public static synchronized IpMngDatabase getInstance() throws DatabaseException {
        if (instance == null)
            instance = new IpMngDatabase();
        return instance;
    }
    
    private IpMngDatabase() throws DatabaseException {
        connMgr = DBConnectionManager.getInstance();
    }
    
    /**
     * 특정 레코드를 Bean에 저장하여 Bean을 리턴하는 메소드
     */
	
	
	/**
     * IP
     */
    private IPBean makeIPBean(ResultSet results) throws DatabaseException {

        try {
            IPBean bean = new IPBean();

		    bean.setUser_id(results.getString("USER_ID"));
		    bean.setUser_nm(results.getString("USER_NM"));
		    bean.setId(results.getString("ID"));
		    bean.setIu(results.getString("IU"));
		    bean.setIp(results.getString("IP"));
		    bean.setIp_auth(results.getString("IP_AUTH"));
		    bean.setLoginout(results.getString("LOGINOUT"));
		    bean.setLogin_dt(results.getString("LOGIN_DT"));
		    bean.setLogout_dt(results.getString("LOGOUT_DT"));
		    bean.setDept_id(results.getString("DEPT_ID"));
		    bean.setDept_nm(results.getString("DEPT_NM"));
		    bean.setUser_m_tel(results.getString("USER_M_TEL"));
		    bean.setUser_pos(results.getString("USER_POS"));
		    
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}
	/**
     * IP Log
     */
    private IPLogBean makeIPLogBean(ResultSet results) throws DatabaseException {

        try {
            IPLogBean bean = new IPLogBean();

		    bean.setUser_id(results.getString("USER_ID"));
		    bean.setUser_nm(results.getString("USER_NM"));
		    bean.setIp(results.getString("IP"));
		    bean.setId(results.getString("ID"));
		    bean.setLogin_dt(results.getString("LOGIN_DT"));
		    bean.setLogout_dt(results.getString("LOGOUT_DT"));
		    
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}
	/**
     * IP 전체조회
     */
    public IPBean [] getIpAll(String gubun, String gubun_nm) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String subQuery = "";
        String query = "";
        
        if(gubun.equals("title"))
        {
        	subQuery = "and a.title like '%" + gubun_nm + "%'\n";
        }else if(gubun.equals("content")){
        	subQuery = "and a.content like '%" + gubun_nm + "%'\n";
        }else if(gubun.equals("reg_dt")){
        	subQuery = "and a.reg_dt >= replace('" + gubun_nm + "','-','')\n";
        }else if(gubun.equals("user_nm")){
        	subQuery = "and b.user_nm like '%" + gubun_nm + "%'\n";
        }        
                
        query = "select a.user_id as USER_ID, a.user_nm as USER_NM, a.dept_id as DEPT_ID, a.id as ID, a.user_m_tel as USER_M_TEL, a.user_pos as USER_POS, decode(b.user_id, null,'i','u') as IU, b.ip as IP, b.ip_auth as IP_AUTH, b.loginout as LOGINOUT, to_char(b.login_dt,'YYYY/MM/DD hh24:mi') as LOGIN_DT, b.logout_dt as LOGOUT_DT, c.nm as DEPT_NM\n"
				+ "from users a, ip_mng b, code c\n"
				+ "where a.user_id=b.user_id\n"
				+ "and c.C_ST = '0002'\n"
				+ "and c.CODE = a.DEPT_ID order by a.user_nm\n";
      
        Collection<IPBean> col = new ArrayList<IPBean>();
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);

            while(rs.next()){
				col.add(makeIPBean(rs));
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (IPBean[])col.toArray(new IPBean[0]);
    }
    /**
     * IP Log전체조회
     */
    public IPLogBean [] getIpLogAll(String ip) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String subQuery = "";
        String query = "";
        
                
        query = "select a.user_id as USER_ID, a.user_nm as USER_NM, a.id as ID, b.ip as IP, to_char(b.login_dt,'YYYY/MM/DD hh24:mi') as LOGIN_DT, to_char(b.logout_dt,'YYYY/MM/DD hh24:mi') as LOGOUT_DT\n"
				+ "from users a, ip_log b\n"
				+ "where a.user_id=b.user_id(+)\n"
				+ "and b.ip='" + ip  + "' order by b.login_dt desc\n";
      
        Collection<IPLogBean> col = new ArrayList<IPLogBean>();
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);

            while(rs.next()){
				col.add(makeIPLogBean(rs));
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (IPLogBean[])col.toArray(new IPLogBean[0]);
    }
 	/**
     * IP 개별 조회
     */    
    public IPBean getIPBean(String user_id, String ip) throws UnknownDataException, DataSourceEmptyException, DatabaseException { 
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null) 
            throw new DataSourceEmptyException("Can't get connection.!!");

        IPBean ib;

        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        query = "select a.user_id as USER_ID, a.user_nm as USER_NM, a.dept_id as DEPT_ID, a.id as ID, a.user_m_tel as USER_M_TEL, a.user_pos as USER_POS, decode(b.user_id, null,'i','u') as IU, b.ip as IP, nvl(b.ip_auth,'R') as IP_AUTH, b.loginout as LOGINOUT, b.login_dt as LOGIN_DT, b.logout_dt as LOGOUT_DT, c.nm as DEPT_NM\n"
				+ "from users a, ip_mng b, code c\n"
				+ "where b.user_id='" + user_id + "' and b.ip='" + ip + "' and a.user_id=b.user_id\n"
				+ "and c.C_ST = '0002'\n"
				+ "and c.CODE = a.DEPT_ID order by a.user_nm\n";
        try {
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
    
            if (rs.next())
                ib = makeIPBean(rs);
            
			else
                throw new UnknownDataException("Could not find Appcode # " + user_id );
 
            rs.close();
            stmt.close();

        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }finally{
            try{
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){} 
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return ib;
    }
    /**
     * IP 등록
     */
    public int insertIp(String user_id, String ip) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
               
        query = "insert into ip_mng(user_id, ip, login_dt)\n"
                        + "values(?,?,sysdate)\n";
 
       try{
            
            con.setAutoCommit(false);
                      
            pstmt = con.prepareStatement(query);
            pstmt.setString(1, user_id.trim());
            pstmt.setString(2, ip.trim());
            
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }
    /**
     * IP 수정
     */
    public int updateIp(String user_id, String ip, String h_user_id, String h_ip) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
               
        query="UPDATE ip_mng\n"
        	+ "SET ip=?,\n"
				+ "user_id=?\n"
            + "WHERE user_id=? and ip=?";

       try{
            
            con.setAutoCommit(false);
                      
            pstmt = con.prepareStatement(query);
            
            pstmt.setString(1, ip.trim());
            pstmt.setString(2, user_id.trim());
            pstmt.setString(3, h_user_id.trim());
            pstmt.setString(4, h_ip.trim());
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(SQLException se){
            try{
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }
	/**
     * IP 삭제
     */
    public int deleteIp(String user_id, String ip) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
               
        query="delete ip_mng\n"
        	+ "WHERE ip=? and user_id=?";
 
       try{
            
            con.setAutoCommit(false);
                      
            pstmt = con.prepareStatement(query);
            
            pstmt.setString(1, ip.trim());
            pstmt.setString(2, user_id.trim());
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(SQLException se){
            try{
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }
}
