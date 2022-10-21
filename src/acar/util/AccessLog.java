package acar.util;

import java.util.*;
import java.sql.*;
import acar.util.*;
import java.text.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.UnknownDataException;
import acar.exception.DatabaseException;

public class AccessLog
{

    private static AccessLog instance;
    private DBConnectionManager connMgr;   
    // Pool로 부터 Connection 객체를 가져올때 사용하는 Pool Name 
    private final String DATA_SOURCE = "acar"; 
 
    // 싱글톤 클래스로 구현 
    // 생성자를 private 로 선언
    public static synchronized AccessLog getInstance() throws DatabaseException {
        if (instance == null)
            instance = new AccessLog();
        return instance;
    }
    
    private AccessLog() throws DatabaseException {
        connMgr = DBConnectionManager.getInstance();
    }
    
    public void insertAccessLog(String m_st, String m_st2, String m_cd, String user_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        Statement pstmt = null;
        String query = "";
        int count = 0;
               
       try{
            
	       query="insert into LOG_ACCESS (m_st, m_st2, m_cd, user_id, access_dt) values ('"+m_st+"', '"+m_st2+"', '"+m_cd+"', '"+user_id+"', sysdate)";

            con.setAutoCommit(false);
            pstmt = con.createStatement();
            count = pstmt.executeUpdate(query);
                      
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
    }
    
    
    public void insertAccessLog(String m_st, String m_st2, String m_cd, String user_id, String ip, String url) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        Statement pstmt = null;
        String query = "";
        int count = 0;
               
       try{
            
	       query="insert into LOG_ACCESS (m_st, m_st2, m_cd, user_id, access_dt, ip, url) values ('"+m_st+"', '"+m_st2+"', '"+m_cd+"', '"+user_id+"', sysdate, '"+ip+"', '"+url+"')";

            con.setAutoCommit(false);
            pstmt = con.createStatement();
            count = pstmt.executeUpdate(query);
                      
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
    }    


}