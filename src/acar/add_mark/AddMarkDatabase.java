package acar.add_mark;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;
import acar.common.*;


public class AddMarkDatabase
{
	private Connection conn = null;
	public static AddMarkDatabase db;
	
	public static AddMarkDatabase getInstance()
	{
		if(AddMarkDatabase.db == null)
			AddMarkDatabase.db = new AddMarkDatabase();
		return AddMarkDatabase.db;
	}	
	

 	private DBConnectionManager connMgr = null;

    private void getConnection()
    {
    	try
    	{
	    	if(connMgr == null)
				connMgr = DBConnectionManager.getInstance();
			if(conn == null)
	        	conn = connMgr.getConnection("acar");				
	    }catch(Exception e){
	    	System.out.println(" i can't get a connection........");
	    }
	}
	
	private void closeConnection()
	{
		if ( conn != null ) 
		{
			connMgr.freeConnection("acar", conn);
			conn = null;
		}		
	}

	/**
	 *	가산점관리 리스트 조회
	 */
	public Vector getAddMarkList(String br_id, String dept_id, String start_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.seq, a.br_id, b.br_nm, a.dept_id, c.nm as dept_nm, a.mng_st, decode(a.mng_st,'1','단독','2','공동') as mng_st_nm, a.mng_way, d.nm as mng_way_nm, a.marks, a.start_dt, a.end_dt"+
				" from add_mark a, branch b, code c, code d"+
				" where a.br_id=b.br_id and a.dept_id=c.code and c.c_st='0002' and c.code<>'0000' and a.mng_way=d.nm_cd and d.c_st='0005' and d.code<>'0000'";

		if(!br_id.equals(""))		query += " and a.br_id='"+br_id+"'";
		if(!dept_id.equals(""))		query += " and a.dept_id='"+dept_id+"'";
		if(!start_dt.equals(""))	query += " and a.start_dt=replace('"+start_dt+"', '-', '')";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
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
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AddMarkDatabase:getAddMarkList]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}	

	/**
	 *	가산점관리 리스트 조회
	 */
	public Vector getAddMarkList(String br_id, String dept_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.br_id, b.br_nm, a.dept_id, c.nm as dept_nm, a.seq, a.start_dt, a.end_dt"+
				" from "+
				" (select br_id, dept_id, min(seq) seq, max(start_dt) start_dt, max(end_dt) end_dt from add_mark group by br_id, dept_id) a, "+
				" branch b, code c"+
				" where a.br_id=b.br_id and a.dept_id=c.code and c_st='0002' and code<>'0000'";

		if(!br_id.equals(""))		query += " and a.br_id='"+br_id+"'";
		if(!dept_id.equals(""))		query += " and a.dept_id='"+dept_id+"'";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
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
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AddMarkDatabase:getAddMarkList]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}	

	/**
	 *	가산점관리 리스트 조회
	 */
	public Vector getAddMarkList2(String s_br_id, String s_dept_id, String s_gubun, String s_mng_who)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select * from add_mark "+
				" where br_id like '%"+s_br_id+"%'";

		if(!s_dept_id.equals(""))	query += " and dept_id='"+s_dept_id+"'";
		if(!s_gubun.equals(""))		query += " and gubun='"+s_gubun+"'";
		if(!s_mng_who.equals(""))	query += " and mng_who='"+s_mng_who+"'";

		query += " order by start_dt, br_id, dept_id, gubun, mng_who, mng_way, mng_st";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
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
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AddMarkDatabase:getAddMarkList2]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}	


	/**
	 *	가산점 조회
	 */
	public String getMarks(String br_id, String dept_id, String start_dt, String mng_st, String mng_way)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String marks = "";
		String query = "";

		query = " select marks from add_mark where seq is not null";

		if(!br_id.equals(""))		query += " and br_id='"+br_id+"'";
		if(!dept_id.equals(""))		query += " and dept_id='"+dept_id+"'";
		if(!start_dt.equals(""))	query += " and start_dt='"+start_dt+"'";
		if(!mng_st.equals(""))		query += " and mng_st='"+mng_st+"'";
		if(!mng_way.equals(""))		query += " and mng_way='"+mng_way+"'";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{				
				marks = rs.getString(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AddMarkDatabase:getMarks]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return marks;
		}
	}	

	/**
	 *	가산점 조회
	 */
	public String getMarks(String br_id, String dept_id, String mng_st, String mng_way)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String marks = "";
		String query = "";

		query = " select a.marks from add_mark a, (select br_id, max(start_dt) start_dt from add_mark group by br_id) b"+
				" where a.br_id=b.br_id and a.start_dt=b.start_dt"+
				" and a.br_id='"+br_id+"' and a.dept_id='"+dept_id+"'"+
				" and a.mng_st='"+mng_st+"' and a.mng_way='"+mng_way+"'";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{				
				marks = rs.getString(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AddMarkDatabase:getMarks]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return marks;
		}
	}	

	/**
	 *	가산점 조회
	 */
	public String getMarks(String br_id, String dept_id, String mng_st, String mng_way, String gubun, String mng_who)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String marks = "";
		String query = "";

		query = " select a.marks "+
				" from add_mark a, (select br_id, dept_id, mng_st, max(start_dt) start_dt from add_mark group by br_id, dept_id, mng_st) b"+
				" where a.br_id=b.br_id and a.dept_id=b.dept_id and a.start_dt=b.start_dt";

		if(!br_id.equals(""))		query += " and a.br_id='"+br_id+"'";
		if(!dept_id.equals(""))		query += " and a.dept_id='"+dept_id+"'";

		if(!mng_st.equals(""))		query += " and a.mng_st='"+mng_st+"'";
		if(!mng_way.equals(""))		query += " and a.mng_way='"+mng_way+"'";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{				
				marks = rs.getString(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AddMarkDatabase:getMarks]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return marks;
		}
	}	

	/**
	 *	가산점 조회
	 */
	public AddMarkBean getAddMarks(String br_id, String dept_id, String start_dt, String mng_st, String mng_way)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		AddMarkBean bean = new AddMarkBean();
		String query = "";

		query = " select * from add_mark"+
				" where br_id='"+br_id+"' and dept_id='"+dept_id+"' and start_dt='"+start_dt+"'"+
				" and mng_st='"+mng_st+"' and mng_way='"+mng_way+"'";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{				
				bean.setSeq(rs.getString(1)==null?"":rs.getString(1));
				bean.setBr_id(rs.getString(2)==null?"":rs.getString(2));
				bean.setDept_id(rs.getString(3)==null?"":rs.getString(3));
				bean.setMng_st(rs.getString(4)==null?"":rs.getString(4));
				bean.setMng_way(rs.getString(5)==null?"":rs.getString(5));
				bean.setMarks(rs.getString(6)==null?"":rs.getString(6));
				bean.setStart_dt(rs.getString(7)==null?"":rs.getString(7));
				bean.setEnd_dt(rs.getString(8)==null?"":rs.getString(8));
				bean.setReg_id(rs.getString(9)==null?"":rs.getString(9));
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AddMarkDatabase:getAddMarks]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}
	}	

	/**
	 *	가산점 조회-사원별 관리현황에서 도움말
	 */
	public Vector getAddMarks(String br_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.seq, a.br_id, b.br_nm, a.dept_id, c.nm as dept_nm, a.mng_st,"+
				" decode(a.mng_st,'1','단독','2','공동') as mng_st_nm, a.mng_way, nvl(d.nm,'업체') as mng_way_nm,"+
				" a.marks, a.start_dt, a.end_dt"+
				" from add_mark a, branch b, code c, code d,"+
				" (select br_id, dept_id, mng_st, max(start_dt) start_dt from add_mark group by br_id, dept_id, mng_st) e"+ 
				" where "+
				" a.br_id=b.br_id and a.dept_id=c.code and c.c_st='0002' and c.code<>'0000'"+
				" and a.mng_way=d.nm_cd(+) and (d.nm_cd is null or (d.nm_cd is not null and d.c_st='0005' and d.code<>'0000'))"+
				" and a.br_id=e.br_id and a.br_id=e.br_id and a.mng_st=e.mng_st and a.start_dt=e.start_dt"+
				" order by a.br_id, a.dept_id, a.mng_way";

		if(!br_id.equals("")) query += "and a.br_id='"+br_id+"'";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
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
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AddMarkDatabase:getAddMarks(br_id)]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}	

	/**
	 *	가산점 조회-사원별 관리현황에서 도움말
	 */
	public Vector getAddMarks(String br_id, String dept_id, String gubun, String mng_who)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.seq, a.br_id, a.dept_id, a.mng_st, a.mng_way, a.marks, a.start_dt, a.end_dt, a.gubun, a.mng_who"+
				" from add_mark a, "+
				" (select br_id, dept_id, mng_st, max(start_dt) start_dt from add_mark group by br_id, dept_id, mng_st) e"+ 
				" where "+
				" a.br_id=e.br_id and a.br_id=e.br_id and a.mng_st=e.mng_st and a.start_dt=e.start_dt";

		if(!br_id.equals(""))	query += " and a.br_id='"+br_id+"'";
		if(!dept_id.equals("")) query += " and a.dept_id='"+dept_id+"'";
		if(!gubun.equals(""))	query += " and a.gubun='"+gubun+"'";
		if(!mng_who.equals("")) query += " and a.mng_who='"+mng_who+"'";

		query += " order by a.br_id, a.dept_id, a.mng_way, to_number(a.mng_st)";



		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
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
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AddMarkDatabase:getAddMarks(br_id)]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}	

	/**
	 *	가산점 등록
	 */
	public boolean insertAddMarks(AddMarkBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		String seq_sql = "select nvl(ltrim(to_char(to_number(MAX(seq))+1, '00')), '00') seq from add_mark";
		String seq="";

		String query = "insert into add_mark values (?, ?, ?, ?, ?, ?, replace(?, '-', ''), replace(?, '-', ''), ?, to_char(sysdate,'YYYYMMDD'), 'Y', ?, ?)";			

		try 
		{
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(seq_sql);
	    	rs = pstmt1.executeQuery();
	    	if(rs.next())
	    	{
	    		seq=rs.getString(1);
	    	}
			rs.close();
			pstmt1.close();

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, seq);		
			pstmt.setString(2, bean.getBr_id());	
			pstmt.setString(3, bean.getDept_id());
			pstmt.setString(4, bean.getMng_st());
			pstmt.setString(5, bean.getMng_way());
			pstmt.setString(6, bean.getMarks());
			pstmt.setString(7, bean.getStart_dt());
			pstmt.setString(8, bean.getEnd_dt());
			pstmt.setString(9, bean.getReg_id());		
			pstmt.setString(10, bean.getMng_who());		
			pstmt.setString(11, bean.getGubun());		
		    pstmt.executeUpdate();
			pstmt.close();
		    
			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[AddMarkDatabase:insertAddMarks]"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
                if(pstmt1 != null)	pstmt1.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}

	/**
	 *	가산점 수정
	 */
	public boolean updateAddMarks(AddMarkBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = " update add_mark set marks=?, end_dt=replace(?, '-', '')"+
						" where seq=?";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, bean.getMarks());
			pstmt.setString(2, bean.getEnd_dt());
			pstmt.setString(3, bean.getSeq());		
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddMarkDatabase:updateAddMarks]"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
                if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}

	
	//관리현황 적용 :: 코드관리 --------------------------------------------------------------------------------

	/**
     * 코드 입력
     */
    public boolean insertCode(CodeBean bean)
	{
		getConnection();
        PreparedStatement pstmt = null;
        PreparedStatement pstmt1 = null;
        ResultSet rs = null;
		boolean flag = true;       
        String code_sql = "";
        String query = "";
		String code = "";

		code_sql="select nvl(ltrim(to_char(to_number(MAX(code))+1, '0000')), '0001') code from code where c_st=?";
        
        query = "insert into code (c_st, code, nm_cd, nm, app_st) values (?, ?, ?, ?, ?)";

        try{
			conn.setAutoCommit(false);

            pstmt1 = conn.prepareStatement(code_sql);
			pstmt1.setString(1, bean.getC_st());
	    	rs = pstmt1.executeQuery();
	    	if(rs.next())
	    	{
	    		code=rs.getString(1);
	    	}
            rs.close();
            pstmt1.close();

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, bean.getC_st());		
			pstmt.setString(2, code);	
			pstmt.setString(3, bean.getNm_cd());
			pstmt.setString(4, bean.getNm());
			pstmt.setString(5, bean.getApp_st());
		    pstmt.executeUpdate();
            pstmt.close();

			conn.commit();

        }catch(Exception e){
			System.out.println("[AddMarkDatabase:insertCode]"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
        }finally{
			try{
				conn.setAutoCommit(true);
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
                if(pstmt1 != null)	pstmt1.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
        }
    }

	/**
     * 코드 수정
     */
    public boolean updateCode(CodeBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;       
        String query = "";
       
        query = " update code set"+
				" nm_cd=?, nm=?, app_st=? where c_st=? and code=?";

        try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, bean.getNm_cd());
			pstmt.setString(2, bean.getNm());
			pstmt.setString(3, bean.getApp_st());
			pstmt.setString(4, bean.getC_st());		
			pstmt.setString(5, bean.getCode());	
		    pstmt.executeUpdate();
            pstmt.close();

			conn.commit();

        }catch(Exception e){
			System.out.println("[AddMarkDatabase:updateCode]"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
        }finally{
			try{	
                if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
	    }
	}	
	
}

