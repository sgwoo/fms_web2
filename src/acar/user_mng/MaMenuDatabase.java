package acar.user_mng;


import java.io.*;
import java.util.*;
import java.sql.*;
import acar.util.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.UnknownDataException;
import acar.exception.DatabaseException;

public class MaMenuDatabase
{
	private static MaMenuDatabase instance;
    private DBConnectionManager connMgr;   
    // Pool로 부터 Connection 객체를 가져올때 사용하는 Pool Name 
    private final String DATA_SOURCE = "acar"; 
 
    // 싱글톤 클래스로 구현 
    // 생성자를 private 로 선언
    public static synchronized MaMenuDatabase getInstance() throws DatabaseException {
        if (instance == null)
            instance = new MaMenuDatabase();
        return instance;
    }
    
    private MaMenuDatabase() throws DatabaseException {
        connMgr = DBConnectionManager.getInstance();
    }
  

	//대메뉴 리스트 조회
	public Vector getLMenuList(String m_st, String m_st2, String m_cd) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT * FROM ma_menu WHERE m_st2='00' AND m_cd='00' ORDER BY seq";

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
			System.out.println("[MaMenuDatabase:getLMenuList]\n"+e);
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
		
	//중메뉴 리스트 조회
	public Vector getMMenuList(String m_st, String m_st2, String m_cd) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT * FROM ma_menu WHERE m_st='"+m_st+"' AND m_st2<>'00' AND m_cd='00' ORDER BY seq";

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
			System.out.println("[MaMenuDatabase:getMMenuList]\n"+e);
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

	//중메뉴 리스트 조회-기본페이지 정보 가져오기
	public Vector getMMenuList2(String m_st, String m_st2, String m_cd) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.*, b.url as s_url"+
				" FROM ma_menu a, (select * from ma_menu where base='Y' and m_st='"+m_st+"') b"+
				" WHERE a.m_st='"+m_st+"' AND a.m_st2<>'00' AND a.m_cd='00'"+
				" AND a.m_st=b.m_st(+) AND a.m_st2=b.m_st2(+)"+
				" ORDER BY a.seq";

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
			System.out.println("[MaMenuDatabase:getMMenuList]\n"+e);
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


	//소메뉴 리스트 조회
	public Vector getSMenuList(String m_st, String m_st2, String m_cd) throws DatabaseException, DataSourceEmptyException
	{
		
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT * FROM ma_menu WHERE m_st='"+m_st+"' AND m_st2='"+m_st2+"' AND m_cd<>'00' ORDER BY seq";

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
			System.out.println("[MaMenuDatabase:getSMenuList]\n"+e);
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

	//메뉴 리스트 조회
	public Vector getMenuList(String m_st, String m_st2, String m_cd, String gubun) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null) 
            throw new DataSourceEmptyException("Can't get connection.!!");
            
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		if(gubun.equals("1")){//대메뉴
			query = " SELECT * FROM ma_menu WHERE m_st='"+m_st+"' AND m_st2='00' AND m_cd='00'";
		}else if(gubun.equals("2")){//중메뉴
			query = " SELECT * FROM ma_menu WHERE m_st='"+m_st+"' AND m_st2='"+m_st2+"' AND m_cd='00' AND m_st<>'00'";
		}else if(gubun.equals("4")){//모든메뉴
			query = " SELECT * FROM ma_menu";
		}else{//소메뉴
			query = " SELECT * FROM ma_menu WHERE m_st='"+m_st+"' AND m_st2='"+m_st2+"' AND m_cd='"+m_cd+"' AND m_st<>'00' AND m_st2<>'00'";
		}

		query += " ORDER BY m_st, m_st2, seq";

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
			System.out.println("[MaMenuDatabase:getSMenuList]\n"+e);
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

	//메뉴 한건 조회
	public MaMenuBean getMenuCase(String m_st, String m_st2, String m_cd) throws UnknownDataException, DataSourceEmptyException, DatabaseException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null) 
            throw new DataSourceEmptyException("Can't get connection.!!");
                    
		Statement stmt = null;
		ResultSet rs = null;
		MaMenuBean bean = new MaMenuBean();
		String query = "";

		query = " SELECT * FROM ma_menu WHERE m_st='"+m_st+"' AND m_st2='"+m_st2+"' AND m_cd='"+m_cd+"'";

		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);

			if(rs.next())
			{	
				bean.setM_st	(rs.getString(1));
				bean.setM_st2	(rs.getString(2));
				bean.setM_cd	(rs.getString(3));
				bean.setM_nm	(rs.getString(4));
				bean.setUrl		(rs.getString(5));
				bean.setNote	(rs.getString(6));
				bean.setSeq		(rs.getInt(7));
				bean.setBase	(rs.getString(8));
			}
			rs.close();
            stmt.close();
            
	    }catch (SQLException e) {
	    	System.out.println("[MaMenuDatabase:getMenuCase]\n"+e);
            throw new DatabaseException(e.getMessage());
        }finally{
            try{
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){} 
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
			return bean;
	
	}


	//메뉴명 조회
	public String getMenuNm(String m_st, String m_st2, String m_cd) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		Statement stmt = null;
		ResultSet rs = null;
		String nm = "";
		String query = "";

		query = " SELECT m_nm FROM ma_menu WHERE m_st='"+m_st+"' AND m_st2='"+m_st2+"' AND m_cd='"+m_cd+"' ORDER BY seq";

		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);

			if(rs.next()){				
				 nm = rs.getString(1);
			}
			
			rs.close();
            stmt.close();
			
	    }catch(SQLException se){
	    	System.out.println("[MaMenuDatabase:getMenuNm]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
			return nm;
		
	}

	//메뉴 URL 조회
	public String getMenuUrl(String m_st, String m_st2, String m_cd) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		Statement stmt = null;
		ResultSet rs = null;
		String nm = "";
		String query = "";

		query = " SELECT url FROM ma_menu WHERE m_st='"+m_st+"' AND m_st2='"+m_st2+"' AND m_cd='"+m_cd+"' ORDER BY seq";

		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);
						
			if(rs.next()){				
				 nm = rs.getString(1);
			}
			rs.close();
            stmt.close();
		}catch(SQLException se){
			System.out.println("[MaMenuDatabase:getMenuUrl]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
			return nm;
		
	}

	//메뉴생성시 메뉴코드 조회
	public String getNaxtNum(String m_st, String m_st2, String m_cd, String gubun) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		Statement stmt = null;
		ResultSet rs = null;
		String nm = "";
		String query = "";

		if(gubun.equals("1")){
			query = " select nvl(lpad(max(m_st)+1,2,'0'),'01') from ma_menu where m_st<>'99'";
		}else if(gubun.equals("2")){
			query = " select nvl(lpad(max(m_st2)+1,2,'0'),'01') from ma_menu where m_st='"+m_st+"'";
		}else{
			query = " select nvl(lpad(max(m_cd)+1,2,'0'),'01') from ma_menu where m_st='"+m_st+"' and m_st2='"+m_st2+"'";
		}

		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);

			if(rs.next()){				
				 nm = rs.getString(1)==null?"":rs.getString(1);
			}
	      rs.close();
          stmt.close();
        }catch(SQLException se){
        	System.out.println("[MaMenuDatabase:getNaxtNum]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
		
			return nm;
		
	}

	//메뉴생성시 메뉴코드 조회
	public int getMenuCnt(String m_st, String m_st2, String m_cd, String gubun) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		Statement stmt = null;
		ResultSet rs = null;
		int count = 0;
		String query = "";

		query = " select count(*) from ma_menu";

		if(gubun.equals("1")){
			query += " where m_st='"+m_st+"' and m_st2<>'00'";
		}else if(gubun.equals("2")){
			query += " where m_st='"+m_st+"' and m_st2='"+m_st2+"' and m_cd<>'00'";
		}else{
		}

		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);

			if(rs.next()){				
				 count = rs.getInt(1);
			}
			
		  rs.close();
          stmt.close();
        }catch(SQLException se){
        	System.out.println("[MaMenuDatabase:getMenuCnt]\n"+se);
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

	//메뉴삽입
	public int insertMenu(MaMenuBean bean) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
        PreparedStatement pstmt = null;
		String query = "";
		int count = 0;

		query = " insert into ma_menu values"+
				" (?, ?, ?, ?, ?, ?, ?, ?)";

		try {

			con.setAutoCommit(false);
			
			pstmt = con.prepareStatement(query);
			pstmt.setString(1 , bean.getM_st());
			pstmt.setString(2 , bean.getM_st2());
			pstmt.setString(3 , bean.getM_cd());
			pstmt.setString(4 , bean.getM_nm());
			pstmt.setString(5 , bean.getUrl());
			pstmt.setString(6 , bean.getNote());
			pstmt.setInt(7 , bean.getSeq());
			pstmt.setString(8 , bean.getBase());
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

	//메뉴수정
	public int updateMenu(MaMenuBean bean) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
        PreparedStatement pstmt = null;
		String query = "";
		int count = 0;

		query = " update ma_menu set m_nm=?, url=?, note=?, seq=?, base=?"+
				" where m_st=? and m_st2=? and m_cd=?";

		try {

			con.setAutoCommit(false);
			
			pstmt = con.prepareStatement(query);
			pstmt.setString(1 , bean.getM_nm());
			pstmt.setString(2 , bean.getUrl());
			pstmt.setString(3 , bean.getNote());
			pstmt.setInt(4 , bean.getSeq());
			pstmt.setString(5 , bean.getBase());
			pstmt.setString(6 , bean.getM_st());
			pstmt.setString(7 , bean.getM_st2());
			pstmt.setString(8 , bean.getM_cd());
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

	//메뉴삭제
	public int deleteMenu(MaMenuBean bean) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
        PreparedStatement pstmt = null;
		String query = "";
		int count = 0;

		query = " delete from ma_menu "+
				" where m_st=? and m_st2=? and m_cd=?";

		try {

			con.setAutoCommit(false);
				
			pstmt = con.prepareStatement(query);
			pstmt.setString(1 , bean.getM_st());
			pstmt.setString(2 , bean.getM_st2());
			pstmt.setString(3 , bean.getM_cd());
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

	//업무별권한제한 사용자 조회
	public boolean getWorkAuthUser(String w_nm, String user_id) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
            
		Statement stmt = null;
		ResultSet rs = null;
		boolean flag = false;
		String query = "";

		query = " SELECT * FROM us_me_w WHERE w_nm='"+w_nm+"' AND user_id like '%"+user_id+"%'";


		
		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);

			if(rs.next()){				
				 flag = true;
			}
			rs.close();
            stmt.close();
        }catch(SQLException se){
			System.out.println("[MaMenuDatabase:getWorkAuthUser]"+se);
			throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }	
			return flag;		
	}

	
	//바로가기메뉴
	public Vector getQLinkList(String user_id) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" decode(a.m_st,'','',a.m_st||' '||a.m_st2||' '||a.m_cd||' '||c.auth_rw||' '||b.url||' '||a.sub_page) url, a.m_nm"+
				" from q_link a, ma_menu b, (select * from us_ma_me where user_id='"+user_id+"') c"+
				" where"+
				" nvl(a.m_st,'00')=b.m_st(+) and nvl(a.m_st2,'00')=b.m_st2(+) and nvl(a.m_cd,'00')=b.m_cd(+)"+
				" and nvl(a.m_st,'00')=c.m_st(+) and nvl(a.m_st2,'00')=c.m_st2(+) and nvl(a.m_cd,'00')=c.m_cd(+)"+
//				" and decode(a.m_st,'','1',c.auth_rw) is not null order by a.seq";
				" and decode(a.m_st,'','1',c.auth_rw) <>'0' order by a.seq";

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
        }catch(SQLException se){
			System.out.println("[MaMenuDatabase:getQLinkList]"+se);
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

	//대메뉴별 대표메뉴 조회
	public Hashtable getBMenuLink(String user_id) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable rtn = new Hashtable();
		String query = "";
		String hashtableName = "";

		query = " select b.M_ST, b.M_ST2, b.M_CD, b.M_NM, b.URL, c.AUTH_RW"+
				" from"+
				"     ( select a.m_st, min(a.m_st2||a.m_cd) m_cd"+
				"     from us_ma_me a, ma_menu b"+
				"     where a.user_id='"+user_id+"' and a.auth_rw<>'0'"+
				"     and a.m_st2<>'00' and a.m_cd <>'00'"+
				"     and a.m_st=b.m_st and a.m_st2=b.m_st2 and a.m_cd=b.m_cd"+
				"     and b.url is not null group by a.m_st"+
				"     ) a, ma_menu b, us_ma_me c"+
				"     where a.m_st=b.m_st and a.m_cd=b.m_st2||b.m_cd"+
				"     and c.user_id='"+user_id+"' and a.m_st=c.m_st and a.m_cd=c.m_st2||c.m_cd";

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
					 
					 if(columnName.equals("M_ST")) hashtableName = rs.getString(columnName);
				}
				rtn.put(hashtableName, ht);
			}
			rs.close();
            stmt.close();
        }catch(SQLException se){
			System.out.println("[MaMenuDatabase:getBMenuLink]"+se);
			throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
      return rtn;
    }
			

	//대메뉴별 대표메뉴 조회
	public Hashtable getBMenuLink(String user_id, String m_st) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		String hashtableName = "";

		query = " select b.M_ST, b.M_ST2, b.M_CD, b.M_NM, b.URL, c.AUTH_RW"+
				" from"+
				"     ( select a.m_st, min(a.m_st2||a.m_cd) m_cd"+
				"     from us_ma_me a, ma_menu b"+
				"     where a.user_id='"+user_id+"' and a.auth_rw<>'0'"+
				"     and a.m_st='"+m_st+"' and a.m_st2<>'00' and a.m_cd <>'00'"+
				"     and a.m_st=b.m_st and a.m_st2=b.m_st2 and a.m_cd=b.m_cd"+
				"     and b.url is not null group by a.m_st"+
				"     ) a, ma_menu b, us_ma_me c"+
				"     where a.m_st=b.m_st and a.m_cd=b.m_st2||b.m_cd"+
				"     and c.user_id='"+user_id+"' and a.m_st=c.m_st and a.m_cd=c.m_st2||c.m_cd";

		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next())
			{								
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}	
			rs.close();
            stmt.close();
        }catch(SQLException se){
			System.out.println("[MaMenuDatabase:getBMenuLink]"+se);
			throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
      return ht;
    }

	//메뉴 한건 조회
	public MaMenuBean getMenuCase(String url) throws UnknownDataException, DataSourceEmptyException, DatabaseException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null) 
            throw new DataSourceEmptyException("Can't get connection.!!");
                    
		Statement stmt = null;
		ResultSet rs = null;
		MaMenuBean bean = new MaMenuBean();
		String query = "";

		query = " SELECT * FROM ma_menu WHERE url='"+url+"'";

		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);

			if(rs.next())
			{	
				bean.setM_st	(rs.getString(1));
				bean.setM_st2	(rs.getString(2));
				bean.setM_cd	(rs.getString(3));
				bean.setM_nm	(rs.getString(4));
				bean.setUrl		(rs.getString(5));
				bean.setNote	(rs.getString(6));
				bean.setSeq		(rs.getInt(7));
				bean.setBase	(rs.getString(8));
			}
			rs.close();
            stmt.close();
            
	    }catch (SQLException e) {
	    	System.out.println("[MaMenuDatabase:getMenuCase(String url)]\n"+e);
            throw new DatabaseException(e.getMessage());
        }finally{
            try{
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){} 
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
			return bean;
	
	}
	

	//권한별 사용자정보 가져오기
	public String getWorkAuthUser(String w_nm) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		Statement stmt = null;
		ResultSet rs = null;
		String users = "";
		String query = "";

		query = " SELECT * FROM us_me_w WHERE w_nm='"+w_nm+"' and w_st='solo'";


		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);

    		if(rs.next()){				
				 users = rs.getString("user_id")==null?"":rs.getString("user_id");
			}

			rs.close();
            stmt.close();
        }catch(SQLException se){
			System.out.println("[MaMenuDatabase:getWorkAuthUser(String w_nm)]"+se);
			System.out.println("[MaMenuDatabase:getWorkAuthUser(String w_nm)]"+query);
			throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
      return users;
    }

	//리뉴얼메뉴
	public Vector getXmlMenuList(String user_id) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = "  select  "+
				"            a.M_ST, a.M_ST2, a.M_CD, e.seq as seq1, a.SEQ as seq2, a.M_NM, a.url, decode(c.m_cd,'','N','Y') mymenu_yn, b.auth_rw   "+
				"  from   xml_menu a, (select user_id, m_st, m_st2, m_cd, auth_rw from xml_ma_me where user_id='"+user_id+"' and auth_rw <> '0') b,  "+
			    "         (select m_st, m_st2, m_cd from xml_ma_mymenu where user_id='"+user_id+"' ) c ,"+
			    "     	(select m_st, m_st2, m_nm, seq from xml_menu where m_st2<>'00' and m_cd='00') e  "+
				"  where  a.M_ST2 <> '00' and a.m_st=b.m_st and a.m_st2=b.m_st2 and a.m_cd=b.m_cd  "+
				"        and a.m_st=c.m_st(+) and a.m_st2=c.m_st2(+) and a.m_cd=c.m_cd(+)  "+	
			    "   and a.m_st=e.m_st and a.m_st2=e.m_st2      "+
			    " union "+
                " select m_st, m_st2, m_cd, seq as seq1, 0 as seq2, m_nm, url, '' mymenu_yn, '' auth_rw from xml_menu where m_st2<>'00' and m_cd='00' "+
                "     order by 1, 4, 5  ";

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
        }catch(SQLException se){
			System.out.println("[MaMenuDatabase:getXmlMenuList]"+se);
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
	


	//바로가기메뉴
	public Vector getXmlQLinkList(String user_id) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select decode(a.m_st,'','',a.m_st||' '||a.m_st2||' '||a.m_cd||' '||c.auth_rw||' '||b.url||' '||a.sub_page) url, a.m_nm, a.seq, d.m_nm as m_nm1, e.m_nm as m_nm2, f.m_nm as m_nm3 "+
				" from   xml_q_link a, xml_menu b, (select * from xml_ma_me where user_id='"+user_id+"' and auth_rw<>'0') c, "+
				"        (select m_st, m_nm from xml_menu where m_st2='00' and m_cd='00') d, "+
				"        (select m_st, m_st2, m_nm from xml_menu where m_st2<>'00' and m_cd='00') e, "+
				"        (select m_st, m_st2, m_cd, m_nm from xml_menu where m_st2<>'00' and m_cd<>'00') f "+
				" where  a.m_st=b.m_st and a.m_st2=b.m_st2 and a.m_cd=b.M_CD "+
				"        and a.m_st=c.m_st and a.m_st2=c.m_st2 and a.m_cd=c.M_CD "+
				"        and a.m_st=d.m_st and a.m_st=e.m_st and a.m_st2=e.m_st2 "+
				"        and a.m_st=f.m_st and a.m_st2=f.m_st2 and a.m_cd=f.m_cd "+
				" union all  "+
				" select ''  url, m_nm, seq, '','','' "+
				" from   xml_q_link "+
				" where  m_st is null "+         
				" order by 3 ";

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
        }catch(SQLException se){
			System.out.println("[MaMenuDatabase:getXmlQLinkList]"+se);
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



	//바로가기메뉴
	public String getMenuCaseNm(String url) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String nm = "";

		query = "   SELECT d.m_nm ||' > ' || e.m_nm ||' > '|| f.m_nm AS m_nm  FROM xml_menu a, \n"+
			    "   (select m_st, m_nm from xml_menu where m_st2='00' and m_cd='00') d,   \n"+
				"   (select m_st, m_st2, m_nm from xml_menu where m_st2<>'00' and m_cd='00') e,  \n"+
				"   (select m_st, m_st2, m_cd, m_nm from xml_menu where m_st2<>'00' and m_cd<>'00') f  \n"+
				"   WHERE a.url='"+url+"' \n"+
				"   and a.m_st=d.m_st and a.m_st=e.m_st and a.m_st2=e.m_st2   \n"+
				"   and a.m_st=f.m_st and a.m_st2=f.m_st2 and a.m_cd=f.m_cd   \n"+
				"   AND ROWNUM<=1  ";

		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);
						
			if(rs.next()){				
				 nm = rs.getString(1);
			}
			rs.close();
            stmt.close();
		}catch(SQLException se){
			System.out.println("[MaMenuDatabase:getMenuCaseNm]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
			return nm;
    }

    //대메뉴 리스트 조회
    public Vector getXmlUpperMenuList(String user_id) throws DatabaseException, DataSourceEmptyException
    {
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
        Statement stmt = null;
        ResultSet rs = null;
        Vector vt = new Vector();
        String query = "";

        query = " select "+
                "        distinct a.M_ST"+
                " from   xml_menu a, (select user_id, m_st, m_st2, m_cd, auth_rw from xml_ma_me where user_id='"+user_id+"' and auth_rw <> '0') b "+
			    " where  a.m_st=b.m_st and a.m_st2=b.m_st2 and a.m_cd=b.m_cd "+
                " order by a.M_ST";

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
        }catch(SQLException se){
            System.out.println("[MaMenuDatabase:getXmlMenuList]"+se);
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

	//리뉴얼메뉴
	public Vector getXmlMenuSearchList(String user_id, String t_wd) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select "+
				"        a.M_ST, a.M_ST2, a.M_CD, a.M_NM, a.url, b.auth_rw, e.m_nm as m_nm1, f.m_nm as m_nm2, a.m_nm as m_nm3 "+
				" from   xml_menu a, (select user_id, m_st, m_st2, m_cd, auth_rw from xml_ma_me where user_id='"+user_id+"' and auth_rw <> '0') b, "+
				"        (select m_st, m_nm from xml_menu where m_st2='00' and m_cd='00') e, "+ //대메뉴명
				"        (select m_st, m_st2, m_nm from xml_menu where m_st2<>'00' and m_cd='00') f "+ //중메뉴명
				" where  a.M_ST2 <> '00' and a.m_st=b.m_st and a.m_st2=b.m_st2 and a.m_cd=b.m_cd ";

		if(!t_wd.equals("")) query += " and a.M_NM like '%"+t_wd+"%'";

		query += " and a.m_st=e.m_st and a.m_st=f.m_st and a.m_st2=f.m_st2 ";

        query += " order by 1, 2, 3 ";

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
        }catch(SQLException se){
			System.out.println("[MaMenuDatabase:getXmlMenuSearchList]"+se);
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

	//메뉴 한건 조회
	public MaMenuBean getXmlMenuCase(String m_st, String m_st2, String m_cd) throws UnknownDataException, DataSourceEmptyException, DatabaseException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null) 
            throw new DataSourceEmptyException("Can't get connection.!!");
                    
		Statement stmt = null;
		ResultSet rs = null;
		MaMenuBean bean = new MaMenuBean();
		String query = "";

		query = " SELECT * FROM xml_menu WHERE m_st='"+m_st+"' AND m_st2='"+m_st2+"' AND m_cd='"+m_cd+"'";

		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);

			if(rs.next())
			{	
				bean.setM_st	(rs.getString(1));
				bean.setM_st2	(rs.getString(2));
				bean.setM_cd	(rs.getString(3));
				bean.setM_nm	(rs.getString(4));
				bean.setUrl		(rs.getString(5));
				bean.setNote	(rs.getString(6));
				bean.setSeq		(rs.getInt(7));
				bean.setBase	(rs.getString(8));
			}
			rs.close();
            stmt.close();
            
	    }catch (SQLException e) {
	    	System.out.println("[MaMenuDatabase:getMenuCase]\n"+e);
            throw new DatabaseException(e.getMessage());
        }finally{
            try{
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){} 
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
			return bean;
	
	}
//test
}