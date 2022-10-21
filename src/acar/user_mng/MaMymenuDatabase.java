package acar.user_mng;


import java.io.*;
import java.util.*;
import java.sql.*;
import acar.util.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.UnknownDataException;
import acar.exception.DatabaseException;


public class MaMymenuDatabase
{
	private static MaMymenuDatabase instance;
    private DBConnectionManager connMgr;   
    // Pool로 부터 Connection 객체를 가져올때 사용하는 Pool Name 
    private final String DATA_SOURCE = "acar"; 
 
    // 싱글톤 클래스로 구현 
    // 생성자를 private 로 선언
    public static synchronized MaMymenuDatabase getInstance() throws DatabaseException {
        if (instance == null)
            instance = new MaMymenuDatabase();
        return instance;
    }
    
    private MaMymenuDatabase() throws DatabaseException {
        connMgr = DBConnectionManager.getInstance();
    }
  
  
	//마이메뉴 리스트 조회
	public Vector getMyMenuList(String user_id) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.*, b.m_nm, b.url, b.note, c.bm_nm, d.mm_nm, e.auth_rw "+
				" from ma_mymenu a, ma_menu b, "+
				" (select m_st, m_nm as bm_nm from ma_menu where m_st2='00' and m_cd='00') c,"+
				" (select m_st, m_st2, m_nm as mm_nm from ma_menu where m_cd='00') d, us_ma_me e"+
				" where a.user_id='"+user_id+"' and a.m_st=b.m_st and a.m_st2=b.m_st2 and a.m_cd=b.m_cd and a.m_st=c.m_st and a.m_st=d.m_st and a.m_st2=d.m_st2"+
				" and a.user_id=e.user_id and a.m_st=e.m_st and a.m_st2=e.m_st2 and a.m_cd=e.m_cd"+
				" order by a.sort";

		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);	
			}
			
  			rs.close();
            stmt.close();
   		} catch (SQLException e) {
			System.out.println("[MaMymenuDatabase:getMyMenuList]\n"+e);
	  		throw new DatabaseException();
	    }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
      return vt;
    }

	//마이메뉴생성시 메뉴코드 조회
	public int getMyMenuCnt(String m_st, String m_st2, String m_cd, String user_id)throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		Statement stmt = null;
		ResultSet rs = null;
		int count = 0;
		String query = "";

		query = " select count(*) from ma_mymenu where user_id='"+user_id+"' and m_st='"+m_st+"' and m_st2='"+m_st2+"' and m_cd='"+m_cd+"'";

		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);

			if(rs.next()){				
				 count = rs.getInt(1);
			}
		  rs.close();
          stmt.close();
        }catch(SQLException se){
          	 System.out.println("[MaMymenuDatabase:getMyMenuCnt]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
			return count;
		
	}

	//마이메뉴생성시 메뉴코드 조회
	public int getMyNaxtNum(String user_id)throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		Statement stmt = null;
		ResultSet rs = null;
		int seq = 1;
		String query = "";

		query = " select nvl(max(seq)+1,1) from ma_mymenu where user_id='"+user_id+"'";

		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);

			if(rs.next()){				
				 seq = rs.getInt(1);
			}
		  rs.close();
          stmt.close();
        }catch(SQLException se){
        	 System.out.println("[MaMymenuDatabase:getMyNaxtNum]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
			return seq;
		
	}

	//마이메뉴삽입
	public int insertMyMenu(MaMymenuBean bean)  throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
        PreparedStatement pstmt = null;
        PreparedStatement pstmt2 = null;
		String query = "";
		String query2 = "";
		int count = 0;

		query2 = " update ma_mymenu set sort=sort+1 where user_id=? and sort >= ?";

		query = " insert into ma_mymenu values"+
		" (?, ?, ?, ?, ?, ?)";


		try {

			con.setAutoCommit(false);
						 
			pstmt2 = con.prepareStatement(query2);
			pstmt2.setString(1 , bean.getUser_id());
			pstmt2.setInt(2 , bean.getSort());
			count = pstmt2.executeUpdate();

			pstmt = con.prepareStatement(query);
			pstmt.setString(1 , bean.getUser_id());
			pstmt.setInt(2 , bean.getSeq());
			pstmt.setString(3 , bean.getM_st());
			pstmt.setString(4 , bean.getM_st2());
			pstmt.setString(5 , bean.getM_cd());
			pstmt.setInt(6 , bean.getSort());
			count = pstmt.executeUpdate();

			pstmt.close();
			pstmt2.close();
            con.commit();
            
		}catch(SQLException se){
            try{
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException(Util.getStackTrace(se));
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
                if(pstmt2 != null) pstmt2.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
    
			return count;
		
	}
	

	//마이메뉴수정
	public int updateMyMenu(String user_id, int seq, int sort) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
        PreparedStatement pstmt = null;
		String query = "";
		int count = 0;

		query = " update ma_mymenu set sort=? where user_id=? and seq=?";

		try {
			
			con.setAutoCommit(false);
				
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1 , sort);
			pstmt.setString(2 , user_id);
			pstmt.setInt(3 , seq);

			count = pstmt.executeUpdate();

			pstmt.close();
            con.commit();
            
  		}catch(SQLException se){
            try{
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException(Util.getStackTrace(se));
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
 //마이메뉴수정
    public int updateMyMenuByMenuCode(String user_id, String m_st, String m_st2, String m_cd, int sort) throws DatabaseException, DataSourceEmptyException
    {
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;

        query = " update xml_ma_mymenu set sort=? where user_id=? and m_st=? and m_st2=? and m_cd=?";

        try {
            
            con.setAutoCommit(false);
                
            pstmt = con.prepareStatement(query);
            pstmt.setInt(1 , sort);
            pstmt.setString(2 , user_id);
            pstmt.setString(3 , m_st);
            pstmt.setString(4 , m_st2);
            pstmt.setString(5 , m_cd);

            count = pstmt.executeUpdate();

            pstmt.close();
            con.commit();
            
        }catch(SQLException se){
            try{
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException(Util.getStackTrace(se));
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


	//마이메뉴삭제
	public int deleteMyMenu(String user_id, int seq, int my_sort) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
        PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;

		String query1 = "";
		String query2 = "";
		int count = 0;

		query1 = " delete from ma_mymenu where user_id='"+user_id+"' and seq="+seq+"";
		query2 = " update ma_mymenu set sort=sort-1 where user_id='"+user_id+"' and sort > "+my_sort+"";

		try {
			con.setAutoCommit(false);
			  
			pstmt1 = con.prepareStatement(query1);
			count = pstmt1.executeUpdate();

			pstmt2 = con.prepareStatement(query2);
			count = pstmt2.executeUpdate();
			
			pstmt1.close();
            pstmt2.close();
            con.commit();

	    }catch(SQLException se){
            try{
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException(Util.getStackTrace(se));
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt1 != null) pstmt1.close();
                if(pstmt2 != null) pstmt2.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
    
		return count;
		
	}

	//마이메뉴삭제
	public void deleteMyMenu(String user_id, String m_st, String m_st2, String m_cd) throws DatabaseException, DataSourceEmptyException, UnknownDataException
	{
	 	Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
        PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		Statement stmt = null;
		ResultSet rs = null;
		String query1 = "";
		String query2 = "";
		String query3 = "";
		int seq = 0;
		int sort = 0;
		int count = 0;

		query1 = " select nvl(seq,0), nvl(sort,0) from ma_mymenu where user_id='"+user_id+"' and m_st='"+m_st+"' and m_st2='"+m_st2+"' and m_cd='"+m_cd+"'";

		try {
					
			 	
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query1);

			if(rs.next()){				
				 seq = rs.getInt(1);
				 sort = rs.getInt(2);
			}
			rs.close();
            stmt.close();
			
			con.setAutoCommit(false);
			
			if(seq > 0 && sort > 0){
				query2 = " delete from ma_mymenu where user_id='"+user_id+"' and seq="+seq+"";
				query3 = " update ma_mymenu set sort=sort-1 where user_id='"+user_id+"' and sort > "+sort+"";

				pstmt1 = con.prepareStatement(query2);
				count = pstmt1.executeUpdate();

				pstmt2 = con.prepareStatement(query3);
				count = pstmt2.executeUpdate();
			}
			
			pstmt1.close();
            pstmt2.close();
            con.commit();
            
		 }catch(SQLException se){
            try{
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException(Util.getStackTrace(se));
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt1 != null) pstmt1.close();
                if(pstmt2 != null) pstmt2.close();
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
    }
    
	//마이메뉴 리스트 조회
	public Vector getXmlMyMenuList(String user_id) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.M_ST, a.m_st2, a.m_cd, b.url, b.M_NM, d.m_nm as m_nm1, e.m_nm as m_nm2, c.auth_rw "+
				" from   xml_ma_mymenu a, xml_menu b, (select user_id, m_st, m_st2, m_cd, auth_rw from xml_ma_me where user_id='"+user_id+"' and auth_rw<>'0') c, "+
				"        (select m_st, m_nm from xml_menu where m_st2='00' and m_cd='00') d, "+
				"        (select m_st, m_st2, m_nm from xml_menu where m_st2<>'00' and m_cd='00') e "+
				" where  a.user_id='"+user_id+"' "+
				"        and a.m_st=b.m_st and a.m_st2=b.m_st2 and a.m_cd=b.m_cd "+
				"        and a.m_st=c.m_st and a.m_st2=c.m_st2 and a.m_cd=c.m_cd "+  
				"        and a.m_st=d.m_st "+
				"        and a.m_st=e.m_st and a.m_st2=e.m_st2 "+
				" order by a.sort ";

		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);	
			}
			
  			rs.close();
            stmt.close();
   		} catch (SQLException e) {
			System.out.println("[MaMymenuDatabase:getXmlMyMenuList]\n"+e);
	  		throw new DatabaseException();
	    }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
      return vt;
    }

	//마이메뉴삽입
	public int insertXmlMyMenu(String user_id, String m_st, String m_st2, String m_cd)  throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
        PreparedStatement pstmt = null;
		String query = "";
		int count = 0;

		query = " insert into xml_ma_mymenu (user_id, seq, m_st, m_st2, m_cd, sort) "+
			    " select '"+user_id+"', nvl(max(seq),0)+1, '"+m_st+"', '"+m_st2+"', '"+m_cd+"', nvl(max(sort),0)+1 "+
		        " from   xml_ma_mymenu where user_id='"+user_id+"' ";

		try {

			con.setAutoCommit(false);
						 
			pstmt = con.prepareStatement(query);
			count = pstmt.executeUpdate();
			pstmt.close();
            con.commit();
            
		}catch(SQLException se){
            try{
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException(Util.getStackTrace(se));
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

	//마이메뉴삭제
	public int deleteXmlMyMenu(String user_id, String m_st, String m_st2, String m_cd) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
        PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;

		String query1 = "";
		String query2 = "";
		int count = 0;

		query1 = " update xml_ma_mymenu set sort=sort-1 where user_id='"+user_id+"' and sort > (select max(sort) sort  from xml_ma_mymenu where user_id='"+user_id+"' and m_st='"+m_st+"' and m_st2='"+m_st2+"' and m_cd='"+m_cd+"' ) ";

		query2 = " delete from xml_ma_mymenu where user_id='"+user_id+"' and m_st='"+m_st+"' and m_st2='"+m_st2+"' and m_cd='"+m_cd+"' ";


		try {
			con.setAutoCommit(false);
			  
			pstmt1 = con.prepareStatement(query1);
			count = pstmt1.executeUpdate();

			pstmt2 = con.prepareStatement(query2);
			count = pstmt2.executeUpdate();
			
			pstmt1.close();
            pstmt2.close();
            con.commit();

	    }catch(SQLException se){
            try{
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException(Util.getStackTrace(se));
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt1 != null) pstmt1.close();
                if(pstmt2 != null) pstmt2.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
    
		return count;
		
	}

}