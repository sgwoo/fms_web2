/**
 * 당직근무
 * @ author : Gill Sun Ryu
 * @ e-mail : gillsun@empal.com
 * @ create date : 2009. 06. 23
 * @ last modify date : 
 */

package acar.watch;

import java.sql.*;
import java.util.*;
import acar.util.*;
import acar.database.*;

public class WatchDatabase
{
	private Connection conn = null;
	public static WatchDatabase db;
	
	public static WatchDatabase getInstance()
	{
		if(WatchDatabase.db == null)
			WatchDatabase.db = new WatchDatabase();
		return WatchDatabase.db;
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
 	
//당직일지 관리(20090617)---------------------------------------------------------------------------------------------------------------------------------

    /**
     * 일정세부조회
     */

	public Vector WatchSche(String start_year, String start_mon, String start_day, String member_id) {
		getConnection();

       PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


	  	  query = " select a.*, to_char(a.watch_time_st, 'hh24mm') as time, b.user_nm as member_nm, "
				+ " decode(to_char( to_date('"+start_year+"'||'"+start_mon+"'||'"+start_day+"'), 'd'), '1', '일요일', '2', '월요일', '3', '화요일', '4', '수요일', '5', '목요일', '6', '금요일', '7', '토요일' ) day_nm "
        		+ " from sch_watch a, users b \n"
				+ " where a.start_year='"+start_year+"' and a.start_mon='"+start_mon+"' and a.start_day='"+start_day+"' and a.member_id = '" + member_id + "' \n"
				+ "	and a.member_id=b.user_id(+) ";
	

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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[WatchDatabase:WatchSche]"+e);
			System.out.println("[WatchDatabase:WatchSche]"+query);
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
     * 월렌트 당직일지 보기
     */

	public Vector WatchScheMon(String start_year, String start_mon, String start_day, String member_id, String no, String watch_type) {
		getConnection();

        PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


	  	  query = " select a.*, to_char(a.watch_time_st, 'hh24mm') as time, b.user_nm as member_nm, "
				+ " decode(to_char( to_date('"+start_year+"'||'"+start_mon+"'||'"+start_day+"'), 'd'), '1', '일요일', '2', '월요일', '3', '화요일', '4', '수요일', '5', '목요일', '6', '금요일', '7', '토요일' ) day_nm "
        		+ " from sch_watch a, users b \n"
				+ " where a.start_year='"+start_year+"' and a.start_mon='"+start_mon+"' and a.start_day='"+start_day+"' and a.member_id"+no+" = '" + member_id + "' and a.watch_type = '" + watch_type + "' \n"
				+ "	and a.member_id"+no+"=b.user_id(+) ";
	

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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[WatchDatabase:WatchScheMon]"+e);
			System.out.println("[WatchDatabase:WatchScheMon]"+query);
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
	
/*********************************************/

    /**
     *  일정전체조회
     */
	public Vector WatchScheAll(String start_year, String start_mon, String watch_type) {
		getConnection();
        
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

        query = " select b.user_m_tel as user_m_tel, c.user_m_tel as user_m_tel2, d.user_m_tel as user_m_tel3, e.user_m_tel as user_m_tel4, b.in_tel as in_tel, c.in_tel as in_tel2, d.in_tel as in_tel3, e.in_tel as in_tel4, a.*, b.user_nm as member_nm, a.watch_ch_nm, c.user_nm as member_nm2, d.user_nm as member_nm3, e.user_nm as member_nm4, \n"
				+" f.user_m_tel AS user_m_tel5, f.in_tel AS in_tel5, f.user_nm AS member_nm5, g.user_m_tel AS user_m_tel6, g.in_tel AS in_tel6, g.user_nm AS member_nm6, h.user_nm AS member_nm7, h.user_m_tel AS user_m_tel7, i.user_nm AS member_nm8, i.user_m_tel AS user_m_tel8 \n"
        		+ " from sch_watch a, users b, users c, users d, users e, users f, users g, users h, users i \n"
				+ " where a.start_year='"+start_year+"' and a.start_mon='"+start_mon+"' and a.watch_type = '"+ watch_type + "' \n"
				+ "	and a.member_id=b.user_id(+) and a.member_id2=c.user_id(+) and a.member_id3=d.user_id(+) and a.member_id4=e.user_id(+)  AND a.member_id5=f.user_id(+) AND a.member_id6=g.user_id(+) AND a.member_id7=h.user_id(+) AND a.member_id8=i.user_id(+) ORDER BY a.start_day " ;


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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[WatchDatabase:WatchScheAll]"+e);
			System.out.println("[WatchDatabase:WatchScheAll]"+query);
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


/*******************************************************/

	/**
     * 스케쥴등록
     */

  public int insertWatchSche(WatchScheBean bean) {
		getConnection();

        PreparedStatement pstmt = null;
		ResultSet rs = null;
		Statement stmt = null;
		int count = 0;
		String query = "";
		String query_seq = "";
		
		String doc_no = "";

 	  	query_seq = " select to_char(sysdate,'YYYYMMDD')||nvl(ltrim(to_char(to_number(max(substr(doc_no,9,3))+1), '000')), '001') doc_no "//11자리
				   +" from sch_watch where substr(doc_no,1,8)=to_char(sysdate,'YYYYMMDD') and watch_type = '1' ";	
                   
            query="INSERT INTO sch_watch (DOC_NO, START_YEAR, START_MON, START_DAY, WATCH_TYPE, REG_DT)\n"
                + "values( \n"
            	+ " ?,\n"
            	+ " ?,\n"
            	+ " ?,\n"
            	+ " ?,\n"
            	+ " '1',\n"
            	+ " to_char(sysdate,'YYYYMMDD') \n"
				+ " )\n";

	try 
		{			
			conn.setAutoCommit(false);	

			stmt = conn.createStatement();
            rs = stmt.executeQuery(query_seq);
         
            if(rs.next())
				doc_no = rs.getString(1)==null?"":rs.getString(1);
            rs.close();
			stmt.close();
		
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  doc_no);
			pstmt.setString(2, bean.getStart_year());
			pstmt.setString(3, bean.getStart_mon());
			pstmt.setString(4, bean.getStart_day());

			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		} catch (SQLException e) {
			System.out.println("[WatchDatabase:insertWatchSche]\n"+e);
			System.out.println("[WatchDatabase:insertWatchSche]\n"+query);
	  		e.printStackTrace();
	  		count = 0;
			conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(rs != null) rs.close();
                if(stmt != null) stmt.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}


/**************************************************/
	/**
     * 스케쥴등록 
     */

  public int insertWatchSche(WatchScheBean bean, String watch_type) {
		getConnection();

        PreparedStatement pstmt = null;
		ResultSet rs = null;
		Statement stmt = null;
		int count = 0;
		String query = "";
		String query_seq = "";
		
		String doc_no = "";

 	  	query_seq = " select to_char(sysdate,'YYYYMMDD')||nvl(ltrim(to_char(to_number(max(substr(doc_no,9,3))+1), '000')), '001') doc_no "//11자리
				   +" from sch_watch where substr(doc_no,1,8)=to_char(sysdate,'YYYYMMDD') and watch_type = '"+ watch_type + "'";	
                   
            query="INSERT INTO sch_watch (DOC_NO, START_YEAR, START_MON, START_DAY, WATCH_TYPE, WATCH_AMT, REG_DT)\n"
                + "values( \n"
            	+ " ?,\n"
            	+ " ?,\n"
            	+ " ?,\n"
            	+ " ?,\n"
            	+ " ?,\n"
				+ " ?,\n"
            	+ " to_char(sysdate,'YYYYMMDD') \n"
				+ " )\n";


	try 
		{			
			conn.setAutoCommit(false);	

			stmt = conn.createStatement();
            rs = stmt.executeQuery(query_seq);
         
            if(rs.next())
				doc_no = rs.getString(1)==null?"":rs.getString(1);
            rs.close();
			stmt.close();
		
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  doc_no);
			pstmt.setString(2, bean.getStart_year());
			pstmt.setString(3, bean.getStart_mon());
			pstmt.setString(4, bean.getStart_day());
			pstmt.setString(5, watch_type);
			pstmt.setInt(6, bean.getWatch_amt());

			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		} catch (SQLException e) {
			System.out.println("[WatchDatabase:insertWatchSche]\n"+e);
			System.out.println("[WatchDatabase:insertWatchSche]\n"+query);
	  		e.printStackTrace();
	  		count = 0;
			conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(rs != null) rs.close();
                if(stmt != null) stmt.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	
/*************************************************/

	/**
     * 당직 스케쥴 수정/삭제
     */

    public int updateWatchSche(WatchScheBean bean){

		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";

            query = " update sch_watch set \n"+
					" watch_time_st	= ?, \n"+				
					" watch_ot		= ?, \n"+
					" watch_time_ed	= ?, \n"+
					" watch_gtext	= ?, \n"+
					" watch_ch_nm	= ?, \n"+
					" member_id		= ?, \n"+
					" member_dt	=replace(?,'-','') \n"+				
					" where start_year=? and start_mon=? and start_day=? and watch_type = '1' ";

		try 
		{		
			conn.setAutoCommit(false);	
		
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getWatch_time_st());			

			pstmt.setString(2, bean.getWatch_ot());
			pstmt.setString(3, bean.getWatch_time_ed());
			pstmt.setString(4, bean.getWatch_gtext());
			pstmt.setString(5, bean.getWatch_ch_nm());
			
			pstmt.setString(6, bean.getMember_id());
			pstmt.setString(7, bean.getMember_dt());
		
			pstmt.setString(8, bean.getStart_year());
			pstmt.setString(9, bean.getStart_mon());
			pstmt.setString(10, bean.getStart_day());


			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[WatchDatabase:updateWatchSche]\n"+e);
			System.out.println("[WatchDatabase:updateWatchSche]\n"+query);
	  		e.printStackTrace();
	  		count = 0;
			conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

/*****************************************************/
	/**
     * 당직자 등록 
     */

    public int updateWatchSche(WatchScheBean bean, String watch_type){

		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";

            query = " update sch_watch set \n"+
					" watch_time_st	= ?, \n"+				
					" watch_ot		= ?, \n"+
					" watch_time_ed	= ?, \n"+
					" watch_gtext	= ?, \n"+
					" watch_ch_nm	= ?, \n"+
					" member_id		= ?, \n"+
					" member_dt	=replace(?,'-','') \n"+				
					" where start_year=? and start_mon=? and start_day=? and watch_type = ? ";

		try 
		{		
			conn.setAutoCommit(false);	
		
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getWatch_time_st());			

			pstmt.setString(2, bean.getWatch_ot());
			pstmt.setString(3, bean.getWatch_time_ed());
			pstmt.setString(4, bean.getWatch_gtext());
			pstmt.setString(5, bean.getWatch_ch_nm());
			
			pstmt.setString(6, bean.getMember_id());
			pstmt.setString(7, bean.getMember_dt());
		
			pstmt.setString(8, bean.getStart_year());
			pstmt.setString(9, bean.getStart_mon());
			pstmt.setString(10, bean.getStart_day());
			pstmt.setString(11,	watch_type);

			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[WatchDatabase:updateWatchSche]\n"+e);
			System.out.println("[WatchDatabase:updateWatchSche]\n"+query);
	  		e.printStackTrace();
	  		count = 0;
			conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	//주간 영업당직자 등록
	public int updateSaleWatchSche(WatchScheBean bean, String watch_type, String no){

		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";

            query = " update sch_watch set \n"+
					" member_id"+no+"	= ? \n"+
					" where start_year=? and start_mon=? and start_day=? and watch_type = ? ";

		try 
		{		
			conn.setAutoCommit(false);	
		
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getMember_id());
			pstmt.setString(2, bean.getStart_year());
			pstmt.setString(3, bean.getStart_mon());
			pstmt.setString(4, bean.getStart_day());
			pstmt.setString(5,	watch_type);
			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[WatchDatabase:updateWatchSche]\n"+e);
			System.out.println("[WatchDatabase:updateWatchSche]\n"+query);
	  		e.printStackTrace();
	  		count = 0;
			conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	public int updateWatchScheMB(WatchScheBean bean, String watch_type){

		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";

            query = " update sch_watch set \n"+
					" watch_time_st	= ?, \n"+				
					" watch_ot		= ?, \n"+
					" watch_time_ed	= ?, \n"+
					" watch_gtext	= ?, \n"+
					" watch_ch_nm	= ?, \n"+
					" member_id		= ?, \n"+
					" member_id2	= ?, \n"+
					" member_dt	=replace(?,'-','') \n"+				
					" where start_year=? and start_mon=? and start_day=? and watch_type = ? ";

		try 
		{		
			conn.setAutoCommit(false);	
		
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getWatch_time_st());			

			pstmt.setString(2, bean.getWatch_ot());
			pstmt.setString(3, bean.getWatch_time_ed());
			pstmt.setString(4, bean.getWatch_gtext());
			pstmt.setString(5, bean.getWatch_ch_nm());
			
			pstmt.setString(6, bean.getMember_id());
			pstmt.setString(7, bean.getMember_id2());
			pstmt.setString(8, bean.getMember_dt());
		
			pstmt.setString(9, bean.getStart_year());
			pstmt.setString(10, bean.getStart_mon());
			pstmt.setString(11, bean.getStart_day());
			pstmt.setString(12,	watch_type);

			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[WatchDatabase:updateWatchScheMB]\n"+e);
			System.out.println("[WatchDatabase:updateWatchScheMB]\n"+query);
	  		e.printStackTrace();
	  		count = 0;
			conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}
/*****************************************************/

	/**
     * 당직시작 시간 등록
     */

    public int updateInst(WatchScheBean bean){

		getConnection();

		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";

            query = " update sch_watch set \n"+
					" watch_time_st	= sysdate, \n"+
					" watch_amt = ? \n"+
					" where start_year=? and start_mon=? and start_day=? and watch_type = '1' ";

		try 
		{		
			conn.setAutoCommit(false);	
		
			pstmt = conn.prepareStatement(query);
			
			pstmt.setInt(1, bean.getWatch_amt());
			pstmt.setString(2, bean.getStart_year());
			pstmt.setString(3, bean.getStart_mon());
			pstmt.setString(4, bean.getStart_day());


			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[WatchDatabase:updateInst]\n"+e);
			System.out.println("[WatchDatabase:updateInst]\n"+query);
	  		e.printStackTrace();
	  		count = 0;
			conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	/***************************************************************/
	/**
     * 당직시작 시간 등록 - 
     */

    public int updateInst(WatchScheBean bean, String watch_type){

		getConnection();

		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";

            query = " update sch_watch set \n"+
					" watch_time_st	= sysdate, \n"+
					" watch_amt = ? \n"+
					" where start_year=? and start_mon=? and start_day=? and watch_type = ? ";

		try 
		{		
			conn.setAutoCommit(false);	
		
			pstmt = conn.prepareStatement(query);
			
			pstmt.setInt(1, bean.getWatch_amt());
			pstmt.setString(2, bean.getStart_year());
			pstmt.setString(3, bean.getStart_mon());
			pstmt.setString(4, bean.getStart_day());
			pstmt.setString(5, watch_type);

			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[WatchDatabase:updateInst]\n"+e);
			System.out.println("[WatchDatabase:updateInst]\n"+query);
	  		e.printStackTrace();
	  		count = 0;
			conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}


	/***************************************************************/


	/**
     * 당직종료 시간 등록
     */

    public int updateInet(WatchScheBean bean){

		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";

            query = " update sch_watch set \n"+
					" watch_time_ed	= sysdate  \n"+
					" where start_year=? and start_mon=? and start_day=? and watch_type= '1' ";

		try 
		{		
			conn.setAutoCommit(false);	
		
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getStart_year());
			pstmt.setString(2, bean.getStart_mon());
			pstmt.setString(3, bean.getStart_day());


			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[WatchDatabase:updateInet]\n"+e);
			System.out.println("[WatchDatabase:updateInet]\n"+query);
	  		e.printStackTrace();
	  		count = 0;
			conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

/********************************************************/
/**
     * 당직종료 시간 등록  
     */

    public int updateInet(WatchScheBean bean, String watch_type){

		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";

            query = " update sch_watch set \n"+
					" watch_time_ed	= sysdate  \n"+
					" where start_year=? and start_mon=? and start_day=? and watch_type= ? ";

		try 
		{		
			conn.setAutoCommit(false);	
		
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getStart_year());
			pstmt.setString(2, bean.getStart_mon());
			pstmt.setString(3, bean.getStart_day());
			pstmt.setString(4, watch_type);


			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[WatchDatabase:updateInet]\n"+e);
			System.out.println("[WatchDatabase:updateInet]\n"+query);
	  		e.printStackTrace();
	  		count = 0;
			conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	/********************************************************/
	/**
     * 당직일지 작성
     */

    public int updateWatchReg(WatchScheBean bean){

		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";

            query = " update sch_watch set \n"+				
					" watch_ot		= ?,  \n"+
					" watch_gtext	= ?,  \n"+
					" watch_ch_nm	= ?	\n"+
	
					" where start_year=? and start_mon=? and start_day=? and watch_type = '1' ";


		try 
		{	
			conn.setAutoCommit(false);	
		
			pstmt = conn.prepareStatement(query);

		

			pstmt.setString(1, bean.getWatch_ot());
			pstmt.setString(2, bean.getWatch_gtext());
			pstmt.setString(3, bean.getWatch_ch_nm());

			pstmt.setString(4, bean.getStart_year());
			pstmt.setString(5, bean.getStart_mon());
			pstmt.setString(6, bean.getStart_day());
			
			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[WatchDatabase:updateWatchReg]\n"+e);
			System.out.println("[WatchDatabase:updateWatchReg]\n"+query);
	  		e.printStackTrace();
	  		count = 0;
			conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	/**************************************************************/
	/**
     * 당직일지 작성 - watch_type : 1->본사, 3-> 부산, 4-> 대전
   */

    public int updateWatchReg(WatchScheBean bean, String watch_type){
    	
    	//System.out.println("##### uwr");
    	//System.out.println(bean.getWatch_ot());

		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";

            query = " update sch_watch set \n"+				
					" watch_ot		= ?,  \n"+
					" watch_gtext	= ?,  \n"+
					" watch_ch_nm	= ?	\n"+
	
					" where start_year=? and start_mon=? and start_day=? and watch_type = ? ";



		try 
		{	
			conn.setAutoCommit(false);	
		
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getWatch_ot());
			pstmt.setString(2, bean.getWatch_gtext());
			pstmt.setString(3, bean.getWatch_ch_nm());
			pstmt.setString(4, bean.getStart_year());
			pstmt.setString(5, bean.getStart_mon());
			pstmt.setString(6, bean.getStart_day());
			pstmt.setString(7, watch_type);

			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[WatchDatabase:updateWatchReg]\n"+e);
			System.out.println("[WatchDatabase:updateWatchReg]\n"+query);
	  		e.printStackTrace();
	  		count = 0;
			conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}
	

	/**************************************************************/
	/**
     * 당직결재
     */

    public int updateSign(WatchScheBean bean){

		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";

            query = " update sch_watch set \n"+
					" watch_sign = sysdate  \n"+
					" where start_year=? and start_mon=? and start_day=? and watch_type = '1' ";

		try 
		{		
			conn.setAutoCommit(false);	
		
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getStart_year());
			pstmt.setString(2, bean.getStart_mon());
			pstmt.setString(3, bean.getStart_day());


			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[WatchDatabase:updateSign]\n"+e);
			System.out.println("[WatchDatabase:updateSign]\n"+query);
	  		e.printStackTrace();
	  		count = 0;
			conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

/*************************************************************/
	/**
     * 당직결재 -
     */

    public int updateSign(WatchScheBean bean, String watch_type){

		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";

            query = " update sch_watch set \n"+
					" watch_sign = sysdate  \n"+
					" where start_year=? and start_mon=? and start_day=? and watch_type = ? ";

		try 
		{		
			conn.setAutoCommit(false);	
		
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getStart_year());
			pstmt.setString(2, bean.getStart_mon());
			pstmt.setString(3, bean.getStart_day());
			pstmt.setString(4, watch_type);
			
			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[WatchDatabase:updateSign]\n"+e);
			System.out.println("[WatchDatabase:updateSign]\n"+query);
	  		e.printStackTrace();
	  		count = 0;
			conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	
	/*************************************************************/
	/**
     * 스케쥴삭제
     */
    public int deleteWatchSche(WatchScheBean bean) {
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";

		query = "delete from sch_watch where START_YEAR=? and START_MON=? and START_DAY=? and watch_type = '1'"+
			    "and member_id is null \n";
                   
      try 
		{		
			conn.setAutoCommit(false);	
		
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getStart_year());
			pstmt.setString(2, bean.getStart_mon());
			pstmt.setString(3, bean.getStart_day());


			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[WatchDatabase:deleteWatchSche]\n"+e);
			System.out.println("[WatchDatabase:deleteWatchSche]\n"+query);
	  		e.printStackTrace();
	  		count = 0;
			conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}


	/***********************************************************************/
	/**
     * 스케쥴삭제 -
     */
    public int deleteWatchSche(WatchScheBean bean, String watch_type) {
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";

		query = "delete from sch_watch where START_YEAR= ? and START_MON= ? and START_DAY= ? and watch_type = ? "+
			    "and member_id is null \n";
                   
      try 
		{		
			conn.setAutoCommit(false);	
		
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getStart_year());
			pstmt.setString(2, bean.getStart_mon());
			pstmt.setString(3, bean.getStart_day());
			pstmt.setString(4, watch_type);

			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[WatchDatabase:deleteWatchSche]\n"+e);
			System.out.println("[WatchDatabase:deleteWatchSche]\n"+query);
	  		e.printStackTrace();
	  		count = 0;
			conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	
	/***********************************************************************/
	//스케쥴 조회 

	public  WatchScheBean getWatchSche(String start_year, String start_mon, String start_day, String watch_type){
		getConnection();        

        WatchScheBean wc_bean = new WatchScheBean();
        Statement stmt = null;
        ResultSet rs = null;
        String query = "";

		query = "select a.*, b.user_nm as member_nm \n"+			
				"from sch_watch a, users b \n"+			
				"where a.start_year = "+start_year+" and a.start_mon = "+start_mon+" and a.start_day = "+start_day+" \n"+
				"and a.MEMBER_ID = b.USER_ID(+) and a.watch_type = '" + watch_type + "'";
			
		try{
            stmt = conn.createStatement();
            rs = stmt.executeQuery(query);
			if(rs.next()){
			    wc_bean.setStart_year(rs.getString("START_YEAR"));
			    wc_bean.setStart_mon(rs.getString("START_MON"));		    
			    wc_bean.setStart_day(rs.getString("START_DAY"));		    
			    wc_bean.setMember_id3(rs.getString("MEMBER_ID3"));

			}
			rs.close();
			stmt.close();

        }catch(SQLException e){
			System.out.println("[WatchDatabase:getWatchSche]"+e);
			System.out.println("[WatchDatabase:getWatchSche]"+query);
	  		e.printStackTrace();
        }finally{
            try{
				if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
			closeConnection();
        }
        return wc_bean;
    }

	/****************************************************************/
	//스케쥴 조회 - 담당자별

	public  WatchScheBean getWatchScheMemberId(String start_year, String start_mon, String start_day, String member_id){
		getConnection();        

        WatchScheBean wc_bean = new WatchScheBean();
        Statement stmt = null;
        ResultSet rs = null;
        String query = "";

		query = "select a.*, b.user_nm as member_nm \n"+			
				"from sch_watch a, users b \n"+			
				"where a.start_year = "+start_year+" and a.start_mon = "+start_mon+" and a.start_day = "+start_day+" \n"+
				"and a.MEMBER_ID = b.USER_ID(+) and a.member_id = '"+ member_id + "'";
			
		try{
            stmt = conn.createStatement();
            rs = stmt.executeQuery(query);
			if(rs.next()){
			    wc_bean.setStart_year(rs.getString("START_YEAR"));
			    wc_bean.setStart_mon(rs.getString("START_MON"));		    
			    wc_bean.setStart_day(rs.getString("START_DAY"));		    

			}
			rs.close();
			stmt.close();

        }catch(SQLException e){
			System.out.println("[WatchDatabase:getWatchSche]"+e);
			System.out.println("[WatchDatabase:getWatchSche]"+query);
	  		e.printStackTrace();
        }finally{
            try{
				if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
			closeConnection();
        }
        return wc_bean;
    }


	/****************************************************************/
    /**
	 *	영업팀 인터넷 당직 금액 구하기 
	 */	 
	
	public int getSale_Watch(String user_id, String s_year, String s_mon, String s_day){
		getConnection();       
		
            
		String query = "select  nvl(watch_amt, 0)   from sch_watch \n"+		
					 " where member_id = '"+user_id+"' and watch_type = '2'\n"+	
					 " and start_year = '"+s_year+"' and start_mon = '"+s_mon+"' and start_day = '"+s_day+ "'";


		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int rtn = 0;
		try {
			    pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
   	
			if(rs.next())
			{				
				 rtn = rs.getInt(1);
			}
			rs.close();
            pstmt.close();
            
         }catch(SQLException e){
			System.out.println("[WatchDatabase:getSale_Watch]"+e);
			System.out.println("[WatchDatabase:getSale_Watch]"+query);
	  		e.printStackTrace();
        }finally{
            try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			closeConnection();
        }
        return rtn;
    } 
  
	/**
     * 영업팀 인터넷 당직자 변경(s_year, s_mon, s_day, member_id, watch_amt );
     */
    public int updateSaleWatchMember(String s_year, String s_mon, String s_day, String member_id, String user_nm,  String watch_gtext ){

		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";

            query = " update sch_watch set \n"+
					" member_id = ?,  \n"+
					" watch_gtext=?  \n"+
					" where start_year=? and start_mon=? and start_day=? and watch_type = '2' ";

		try 
		{		
			conn.setAutoCommit(false);	
		
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, member_id);
			pstmt.setString(2, watch_gtext + "( " + user_nm + " 당직자 변경 )" );
			pstmt.setString(3, s_year);
			pstmt.setString(4, s_mon);
			pstmt.setString(5, s_day);
		

			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[WatchDatabase:updateSaleWatchMember]\n"+e);
			System.out.println("[WatchDatabase:updateSaleWatchMember]\n"+query);
	  		e.printStackTrace();
	  		count = 0;
			conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}
	
	
	//당직자 구하기 
	public  String  getWatchScheWho(String start_year, String start_mon, String start_day, String watch_type){
		getConnection();        

        WatchScheBean wc_bean = new WatchScheBean();
        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        String user_nm = "";

		query = "select b.user_nm \n"+			
				"from sch_watch a, users b \n"+			
				"where a.start_year = "+start_year+" and a.start_mon = "+start_mon+" and a.start_day = "+start_day+" \n"+
				"and a.MEMBER_ID = b.USER_ID(+) and a.watch_type = '"+ watch_type + "' ";
			
		try{
            stmt = conn.createStatement();
            rs = stmt.executeQuery(query);
			if(rs.next()){
			     user_nm = rs.getString(1);			 		    

			}
			rs.close();
			stmt.close();

        }catch(SQLException e){
			System.out.println("[WatchDatabase:getWatchScheWho]"+e);
			System.out.println("[WatchDatabase:getWatchScheWho]"+query);
	  		e.printStackTrace();
        }finally{
            try{
				if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
			closeConnection();
        }
        return user_nm;
    }

 /**
     *  일정전체조회
     */
	public Vector WatchScheMB(String start_year, String start_mon2, String start_mon, String watch_type) {
		getConnection();
        
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

			query =	" SELECT a.dt, SUBSTR(TO_CHAR(a.dt, 'yyyymmdd'), 0,4) AS year, SUBSTR(a.dt, 4,2) AS mon, SUBSTR(a.dt, 7,2) AS day \n"+
					" , TO_CHAR(a.dt, 'dy') dy \n"+
					" , a.hday_nm \n"+
					" , b.user_id \n"+
					" , c.user_nm \n"+
					" , a.dept_id \n"+
					" , CASE WHEN TO_CHAR(a.dt, 'd') IN ('1','7') OR a.hday_nm IS NOT NULL \n"+
					"        THEN 3000 ELSE 2000 END watch_amt, sw.* \n"+
					"  FROM ( \n"+
					"  SELECT dt \n"+
					"     , hday_nm \n"+
					"      , dept_id \n"+
					"      , DENSE_RANK() OVER(PARTITION BY dept_id ORDER BY gb1, gb2) dr \n"+
					"    FROM ( \n"+
					"         SELECT dt \n"+
					"             , hday_nm \n"+
					"             , dept_id \n"+
					"             , dt - ROW_NUMBER() OVER(PARTITION BY dept_id ORDER BY dt) gb1 \n"+
					"             , DECODE(dept_id, '0001', dt) gb2 \n"+
					"          FROM (SELECT s.dt \n"+
					"                     , h.hday_nm \n"+
					"                     , CASE WHEN TO_CHAR(s.dt, 'd') IN ('1','6','7') \n"+
					"                               OR h.hday IS NOT NULL  OR LEAD(h.hday) OVER(ORDER BY s.dt) IS NOT NULL \n"+
					"                            THEN '0002' ELSE '0001' END dept_id \n"+
					"                  FROM (SELECT TO_DATE('"+start_year+""+start_mon+"', 'yyyymm') + LEVEL - 1 dt \n"+
					"                          FROM dual \n"+
					"                         CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('"+start_year+""+start_mon+"', 'yyyymm')), 'dd') \n"+
					"                        ) s \n"+
					"                       , holiday h \n"+
					"                   WHERE h.hday(+) = TO_CHAR(s.dt, 'yyyymmdd') \n"+
					"                ) \n"+
					"        ) \n"+
					"    ) a \n"+
					"  , ( \n"+
					"    SELECT x.dept_id, x.user_id, z.gubun \n"+
					"         , ROW_NUMBER() OVER(PARTITION BY x.dept_id \n"+
					"           ORDER BY CASE WHEN x.num > y.num THEN 1 \n"+
					"                         WHEN x.dept_id = '0002' AND gubun = 2 AND x.num = y.num THEN 1 \n"+
					"                        ELSE 2 END \n"+
					"                  , x.num) rn \n"+
					"       , COUNT(*) OVER(PARTITION BY x.dept_id) cnt \n"+
					"    FROM  watch_mb x \n"+
					"       , (SELECT m.dept_id \n"+
					"               , MAX(m.num) KEEP(DENSE_RANK LAST ORDER BY s.start_day) num \n"+
					"            FROM sch_watch s \n"+
					"               , watch_mb m \n"+
					"           WHERE s.start_year = '"+start_year+"' \n"+ // WHERE s.start_year = '2012' \n"+
					"             AND s.start_mon  = '"+start_mon2+"' \n"+ // AND s.start_mon  = '12' \n"+
					"             AND s.watch_type = '"+watch_type+"' \n"+ // AND s.watch_type = '1' \n"+
					"             AND s.member_id = m.user_id \n"+
					"           GROUP BY m.dept_id \n"+
					"          ) y \n"+
					"       , (SELECT COUNT(CASE WHEN TO_CHAR(c.dt, 'd') IN ('1','6','7') \n"+
					"                               OR d.hday IS NOT NULL \n"+
					"                           THEN 1 END) gubun \n"+
					"           FROM (SELECT TO_DATE('"+start_year+""+start_mon+"', 'yyyymm') - LEVEL + 1 dt \n"+
					"                   FROM dual \n"+
					"                  CONNECT BY LEVEL <= 2 \n"+
					"                 ) c \n"+
					"               , holiday d \n"+
					"          WHERE d.hday(+) = TO_CHAR(c.dt, 'yyyymmdd') \n"+
					"         ) z \n"+
					"  WHERE x.dept_id = y.dept_id    \n"+     
					" ) b, users c, SCH_WATCH sw \n"+
					" WHERE a.dept_id = b.dept_id \n"+
					" AND b.user_id = c.user_id  \n"+
					" AND sw.start_year = SUBSTR(TO_CHAR(a.dt, 'yyyymmdd'), 0,4) \n"+
					" AND sw.start_mon = SUBSTR(a.dt, 4,2)  \n"+
					" AND sw.start_day = SUBSTR(a.dt, 7,2) \n"+
					" AND sw.watch_type = '"+watch_type+"' \n"+
					"   AND MOD(a.dr - 1, b.cnt) + 1 = b.rn \n"+
					" ORDER BY dt";



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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[WatchDatabase:WatchScheMB]"+e);
			System.out.println("[WatchDatabase:WatchScheMB]"+query);
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
	

	/****************************************************************************************
	*******************************************   smart
    ****************************************************************************************/
	
		//당직현황
	public Vector WatchScheStat() {
		getConnection();
        
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

        query = " select decode(a.watch_type,'1','본사','3','부산지점','4','대전지점','5','강남지점','6','광주지점','7','대구지점') br_st, \n"+
				"        min(decode(a.start_year||a.start_mon||a.start_day,to_char(sysdate+0,'YYYYMMDD'),b.user_m_tel)) user_m_tel, \n"+
				"        min(decode(a.start_year||a.start_mon||a.start_day,to_char(sysdate-1,'YYYYMMDD'),b.user_nm)) user_nm1, \n"+
				"        min(decode(a.start_year||a.start_mon||a.start_day,to_char(sysdate+0,'YYYYMMDD'),b.user_nm)) user_nm2, \n"+
				"        min(decode(a.start_year||a.start_mon||a.start_day,to_char(sysdate+1,'YYYYMMDD'),b.user_nm)) user_nm3, \n"+
				"        min(decode(a.start_year||a.start_mon||a.start_day,to_char(sysdate+2,'YYYYMMDD'),b.user_nm)) user_nm4  \n"+
				" from   sch_watch a, users b \n"+
				" where  a.start_year||a.start_mon||a.start_day between to_char(sysdate-1,'YYYYMMDD') and to_char(sysdate+2,'YYYYMMDD') \n"+
				"        and a.member_id=b.user_id(+) \n"+
				"        and a.watch_type in ('1','3','4','6','7') \n"+
				" group by a.watch_type \n"+
				" order by a.watch_type";


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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[WatchDatabase:WatchScheStat]"+e);
			System.out.println("[WatchDatabase:WatchScheStat]"+query);
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

	//당직일지 일괄결제 리스트(20190115)
	public Hashtable getDangjikSettleList(String start_year, String start_mon, String start_day, String watch_type) {
		getConnection();

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
        String query = "";

        query = " select a.*, to_char(a.watch_time_st, 'hh24mm') as time, b.user_nm as member_nm, " +
				" decode(to_char( to_date('"+start_year+"'||'"+start_mon+"'||'"+start_day+"'), 'd'), '1', '일요일', '2', '월요일', '3', '화요일', '4', '수요일', '5', '목요일', '6', '금요일', '7', '토요일' ) day_nm " +
        		" from sch_watch a, users b \n" +
				" where a.start_year='"+start_year+"' and a.start_mon='"+start_mon+"' and a.start_day='"+start_day+"' and a.watch_type = '" + watch_type + "' \n" +
				"	and a.member_id=b.user_id(+) ";
			
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next()){	
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}	
			}
            rs.close();
            pstmt.close();

		}catch(SQLException e){
       			System.out.println("[WatchDatabase:getDangjikSettleList]="+e);
       			System.out.println("[WatchDatabase:getDangjikSettleList]="+query);
       			e.printStackTrace();
        }finally{
            try{             
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(Exception ignore){}
            closeConnection();
            return ht;
        }
    }
	
	/**
		야간 당직자 등록(DB에 해당 일자에 대한 당직 근무 레코드가 없는 경우)
	*/
	public int insertWatchMember(WatchScheBean bean, String watch_type){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Statement stmt = null;
		String doc_no = "";
		
		int count = 0;
		String query = "";
		String query_seq = " select to_char(sysdate,'YYYYMMDD')||nvl(ltrim(to_char(to_number(max(substr(doc_no,9,3))+1), '000')), '001') doc_no "//11자리
				   +" from sch_watch where substr(doc_no,1,8)=to_char(sysdate,'YYYYMMDD') and watch_type = '"+ watch_type + "'";
		
		query="INSERT INTO sch_watch (DOC_NO, START_YEAR, START_MON, START_DAY, WATCH_TYPE, WATCH_AMT, REG_DT, MEMBER_ID)\n"
                + "values( \n"
            	+ " ?,\n"
            	+ " ?,\n"
            	+ " ?,\n"
            	+ " ?,\n"
            	+ " ?,\n"
				+ " ?,\n"
            	+ " to_char(sysdate,'YYYYMMDD'), \n"
            	+ " ? \n"
				+ " )\n";
		
		try{
			conn.setAutoCommit(false);
			
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query_seq);
			if(rs.next()) doc_no = rs.getString(1) == null ? "" : rs.getString(1);
            rs.close();
			stmt.close();
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  doc_no);
			pstmt.setString(2, bean.getStart_year());
			pstmt.setString(3, bean.getStart_mon());
			pstmt.setString(4, bean.getStart_day());
			pstmt.setString(5, watch_type);
			pstmt.setInt(6, bean.getWatch_amt());
			pstmt.setString(7, bean.getMember_id());
			
			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
		} catch(Exception e){
			System.out.println("[WatchDatabase: insertWatch]\n"+e);
			System.out.println("[WatchDatabase: insertWatch]\n"+query);
			e.printStackTrace();
	  		count = 0;
			conn.rollback();
		} finally{
			try{
				conn.setAutoCommit(true);
				if(rs != null) rs.close();
                if(stmt != null) stmt.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){ }
			closeConnection();
			return count;
		}
	} 
	
	/****************************************************************************************
	*******************************************   당직수당현황
    ****************************************************************************************/
	
		//사원별당직현황
		public String ArsCallStatBaseDay() {
			getConnection();
	        
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Vector vt = new Vector();
			String query = "";
			String day_cnt = "";

	        query = " SELECT COUNT(distinct call_dt) cnt \r\n" + 
	        		"FROM ARS_CALL_stat\r\n" + 
	        		"where call_dt BETWEEN TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM')||'25' and TO_CHAR(SYSDATE,'YYYYMM')||'24' ";
	        
	 	try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();   
	    			
				if(rs.next())
				{				
					day_cnt = rs.getString("cnt");
				}
				rs.close();
				pstmt.close();

			} catch (SQLException e) {
				System.out.println("[WatchDatabase:ArsCallStatBase]"+e);
				System.out.println("[WatchDatabase:ArsCallStatBase]"+query);
				e.printStackTrace();
			} finally {
				try{
	                if(rs != null )		rs.close();
	                if(pstmt != null)	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return day_cnt;
			}
		}	
		
	//사원별당직현황
	public Vector ArsCallStatBase(String s_yy, String s_mm, String sort) {
		getConnection();
        
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String s_query = "";
		
       	s_query +=" doc_dt like '"+s_yy+""+s_mm+"%' \r\n" ;
       	
       	query = "SELECT DECODE(b.bank_nm,'신한은행','88',c.cms_bk) AS cms_bk, REPLACE(b.bank_no,'-','') bank_no, b.id, b.user_id, b.user_nm, \r\n"
       			+ "       a.call_dt, a.doc_dt, a.pay_dt, a.call_count, a.call_amt, a.call_time, a.th, a.tm, a.ts,       \r\n"
       			+ "       CASE when ROUND((TO_DATE(a.doc_dt,'YYYYMMDD')-TO_DATE(b.enter_dt,'YYYYMMDD'))/365,0) < 5 THEN 1  \r\n"
       			+ "            when ROUND((TO_DATE(a.doc_dt,'YYYYMMDD')-TO_DATE(b.enter_dt,'YYYYMMDD'))/365,0) > 10 THEN 3\r\n"
       			+ "            ELSE 2 END section\r\n"
       			+ "FROM   ( SELECT user_id, doc_dt, pay_dt, min(call_dt) call_dt, \r\n"
       			+ "                sum(call_count) call_count, sum(call_amt) call_amt, sum(nvl(call_amt1,0)) call_amt1, sum(nvl(call_amt2,0)) call_amt2, \r\n"
       			+ "                sum(call_time) call_time, SUM(substr(call_time,1,2)) th, SUM(substr(call_time,4,2)) tm, SUM(SUBSTR(call_time,7,2)) ts          \r\n"
       			+ "         FROM   ars_call_stat\r\n"
       			+ "         WHERE  \r\n" + s_query  
       			+ "         GROUP BY user_id, doc_dt, pay_dt \r\n"
       			+ "        ) a, users b, code c\r\n"
       			+ "WHERE  a.user_id=b.user_id and b.loan_st='1'\r\n"
       			+ "       and b.bank_nm=c.nm and c.c_st='0003'";

        if(sort.equals("2")) {
        	query += " order by b.user_nm ";
        }else if(sort.equals("3")) {
        	query += " order by a.call_count desc";
        }else if(sort.equals("4")) {
        	query += " order by a.call_amt desc";
        }else {
        	query += " order by b.id ASC";  
        }
        
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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[WatchDatabase:ArsCallStatBase]"+e);
			System.out.println("[WatchDatabase:ArsCallStatBase]"+query);
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
	
	//사원별당직현황
	public Vector ArsCallStatBaseList(String s_yy, String s_mm, String s_dd, String user_id) {
		getConnection();
        
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

        query = " SELECT b.user_nm, d.firm_nm, a.call_dt, a.doc_dt, c.* \r\n" + 
        		"FROM   ars_call_stat a, users b, "+
        		"       (SELECT user_id, user_type, cid, redirect_number, hangup_time, bill_duration, call_status, client_id, car_no, "+
        		"               info_type, decode(info_type,'ACCIDENT','사고','SOS','긴급출동','MAINT','정비') info_type_nm, replace(substr(hangup_time,1,10),'-','') AS hangup_time2 "+
        		"        FROM   ars_call_log WHERE cid<>'01041889665' AND cid<>'01086534000' and user_id='"+user_id+"') c, "+
        		"       client d \r\n" + 
        		"WHERE  a.user_id='"+user_id+"' AND a.user_id=b.user_id and a.user_id=c.user_id and a.call_dt=c.hangup_time2 and c.client_id=d.client_id ";
        
        //if(s_dd.equals("")) {
        //	query +="and a.pay_dt is null  \r\n" ; //and a.call_dt BETWEEN TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM')||'25' and TO_CHAR(SYSDATE,'YYYYMM')||'24'
        //}else {
        	query +="and a.doc_dt like '"+s_yy+""+s_mm+""+s_dd+"%' \r\n" ;
        //}
        
        query +=" order by a.call_dt ";
        
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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[WatchDatabase:ArsCallStatBaseList]"+e);
			System.out.println("[WatchDatabase:ArsCallStatBaseList]"+query);
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

    public int UpdateArsCallAmt(String user_id, String user_nm, String base_call_amt){

		getConnection();
		PreparedStatement pstmt = null;  
		int count = 0;
		String query = ""; 

        query = " update ars_call_stat set \n"+
        		" call_amt	= ROUND(call_count*?,-1), \n"+				
				" doc_dt	= to_char(sysdate,'YYYYMMDD') \n"+
				" where user_id=? and user_nm=? and pay_dt is null    ";
        
        //call_dt BETWEEN TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM')||'25' and TO_CHAR(SYSDATE,'YYYYMM')||'24' 

		try 
		{		
			conn.setAutoCommit(false);	
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, base_call_amt);			
			pstmt.setString(2, user_id);
			pstmt.setString(3, user_nm);
			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[WatchDatabase:UpdateArsCallAmt]\n"+e);
			System.out.println("[WatchDatabase:UpdateArsCallAmt]\n"+query);
	  		e.printStackTrace();
	  		count = 0;
			conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}
    
    public int UpdateArsCallAmt(String user_id, String user_nm, String doc_dt, String base_call_amt){

		getConnection();
		PreparedStatement pstmt = null;  
		int count = 0;
		String query = ""; 

        query = " update ars_call_stat set \n"+
        		" call_amt1	= ROUND(call_count*?,-1) \n"+				
				" where user_id=? and doc_dt=?  ";

		try 
		{		
			conn.setAutoCommit(false);	
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, base_call_amt);			
			pstmt.setString(2, user_id);			
			pstmt.setString(3, doc_dt);
			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[WatchDatabase:UpdateArsCallAmt]\n"+e);
			System.out.println("[WatchDatabase:UpdateArsCallAmt]\n"+query);
	  		e.printStackTrace();
	  		count = 0;
			conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}
    
    public int UpdateArsCallAmt2(String user_id, String doc_dt, String call_dt, String section, String base_call_amt2){

		getConnection();
		PreparedStatement pstmt = null;  
		int count = 0;
		String query = ""; 

        query = " update ars_call_stat set \n"+
        		" section	= ?, \n"+        
        		" call_amt2	= ROUND(?*?,-1) \n"+
				" where user_id=? and doc_dt=? and call_dt=?  ";

		try 
		{		
			conn.setAutoCommit(false);	
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, section);			
			pstmt.setString(2, section);
			pstmt.setString(3, base_call_amt2);
			pstmt.setString(4, user_id);			
			pstmt.setString(5, doc_dt);
			pstmt.setString(6, call_dt);
			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[WatchDatabase:UpdateArsCallAmt2]\n"+e);
			System.out.println("[WatchDatabase:UpdateArsCallAmt2]\n"+query);
	  		e.printStackTrace();
	  		count = 0;
			conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}
    
    public int UpdateArsCallAmtSum(String doc_dt){

		getConnection();
		PreparedStatement pstmt = null;  
		int count = 0;
		String query = ""; 

        query = " update ars_call_stat set \n"+
        		" call_amt	= nvl(call_amt1,0)+nvl(call_amt2,0) \n"+
				" where doc_dt=? ";

		try 
		{		
			conn.setAutoCommit(false);	
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, doc_dt);
			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[WatchDatabase:UpdateArsCallAmtSum]\n"+e);
			System.out.println("[WatchDatabase:UpdateArsCallAmtSum]\n"+query);
	  		e.printStackTrace();
	  		count = 0;
			conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}
        
    
	//사원별당직현황
	public Vector ArsCallStatMon(String s_yy) {
		getConnection();
        
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

        query = " SELECT b.id, b.user_id, b.user_nm, \r\n" + 
        		"       SUM(a.call_amt) amt,\r\n" ; 
        		
		for (int i = 1 ; i <= 12 ; i++){
			query +=" sum(DECODE(substr(doc_dt,5,2),'"+AddUtil.addZero2(i)+"',call_amt)) amt_"+i+", \r\n" ;
		}        
		
		query +="       '' etc  \r\n" + 
        		"FROM   ars_call_stat a, users b \r\n" + 
        		"WHERE  a.doc_dt LIKE '"+s_yy+"%' \r\n" + 
        		"       AND a.user_id=b.user_id \r\n" + 
        		"GROUP BY b.id, b.user_id, b.user_nm \r\n" + 
        		"order by SUM(a.call_amt) desc, b.id ";
        
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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[WatchDatabase:ArsCallStatMon]"+e);
			System.out.println("[WatchDatabase:ArsCallStatMon]"+query);
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
	
	//사원별당직현황
	public Vector ArsCallStatMonList(String s_yy, String s_mm) {
		getConnection();
        
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

        query = " SELECT b.id, b.user_id, b.user_nm, sum(a.call_count) call_count, sum(a.call_time) call_time, SUM(substr(a.call_time,1,2)) th, SUM(substr(a.call_time,4,2)) tm, SUM(SUBSTR(a.call_time,7,2)) ts, sum(a.call_amt) call_amt \r\n" + 
        		"FROM   ars_call_stat a, users b \r\n" + 
        		"WHERE  a.doc_dt like '"+s_yy+""+s_mm+"%' \r\n" + 
        		"       AND a.user_id=b.user_id \r\n" +
        		"GROUP BY b.id, b.user_id, b.user_nm ";
        
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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[WatchDatabase:ArsCallStatMonList]"+e);
			System.out.println("[WatchDatabase:ArsCallStatMonList]"+query);
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
	
	//사원별당직현황
	public Vector ArsCallStatSDay(String gubun1, String gubun2, String gubun3, String st_dt, String end_dt) {
		getConnection();
        
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = ""; 

        query = " select d2.br_nm as access_nm, d.br_nm, b.user_nm, b.loan_st, c.firm_nm, decode(a.info_type,'ACCIDENT','사고','SOS','긴급출동','MAINT','정비') info_type_nm,\r\n" +
        		"             DECODE(a.info_type,'','','ETC','',DECODE(a.bill_duration,0,'',a.bill_duration||'초')) stat1,\r\n" + 
        		"             DECODE(a.info_type,'','','ETC','',DECODE(a.bill_duration,0,SUBSTR(a.hangup_time,DECODE(LENGTH(a.hangup_time),19,12,14),5))) stat2,\r\n" + 
        		"             DECODE(a.info_type,'ETC',DECODE(a.cid,a.redirect_number,'O')) stat3,\r\n" +        		
        		"             DECODE(a.info_type,'','O','ETC',decode(a.redirect_number,'','O')) stat4,\r\n" + 
        		"             DECODE(a.info_type,'ACCIDENT','O') stat6,  \r\n" + 
        		"             DECODE(a.info_type,'SOS','O') stat7,\r\n" + 
        		"             DECODE(a.info_type,'MAINT','O') stat8,\r\n" + 
        		"             DECODE(a.info_type,'ETC','O') stat9,\r\n" + 
        		"             DECODE(a.info_type,'','O') stat10,\r\n" + 
        		//"           DECODE(a.info_type,'','',DECODE(a.bill_duration,0,'',DECODE(b.loan_st,'1',DECODE(b.user_nm,c.firm_nm,'','O')))) stat11,\r\n" +
        		"             decode(a.cost_yn,'Y','O') as stat11, "+
        		"             SUBSTR(a.hangup_time,DECODE(LENGTH(a.hangup_time),19,12,14),5) TIME, SUBSTR(a.hangup_time,1,10) call_dt, a.* \r\n" + 
        		"FROM   ars_call_log a, users b, client c, BRANCH d, (select replace(access_number,'-','') access_number, br_id, br_nm from BRANCH) d2 \r\n" + 
        		"WHERE  a.cid<>'01041889665' AND a.cid<>'01086534000' AND SUBSTR(a.hangup_time,1,10) > '2020-02-09' "+
        		"       and a.user_id=b.user_id(+) AND a.client_id=c.client_id(+) AND b.br_id=d.br_id(+) and a.access_number=d2.access_number(+) \r\n" + 
        		" ";  
        
        if(gubun1.equals("4"))			query += " and a.hangup_time like to_char(sysdate,'YYYY-MM')||'%' ";				//당월
		else if(gubun1.equals("5"))		query += " and a.hangup_time like TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYY-MM')||'%' ";	//전월
		else if(gubun1.equals("1"))		query += " and a.hangup_time like to_char(sysdate,'YYYY-MM-DD')||'%' ";				//당일
		else if(gubun1.equals("2"))		query += " and a.hangup_time like to_char(sysdate-1,'YYYY-MM-DD')||'%' ";			//전일
		else if(gubun1.equals("3"))		query += " and a.hangup_time like to_char(sysdate-2,'YYYY-MM-DD')||'%' ";			//그저께
		else if(gubun1.equals("7"))		query += " and a.hangup_time like to_char(sysdate-3,'YYYY-MM-DD')||'%' ";			//그끄저께
		//else if(gubun1.equals("3"))		query += " and SUBSTR(a.hangup_time,1,10) between to_char(sysdate-1,'YYYY-MM-DD') and to_char(sysdate,'YYYY-MM-DD') ";//2일-그저께로 변경		
		else if(gubun1.equals("6")){
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and SUBSTR(a.hangup_time,1,10) between '"+st_dt+"' and '"+end_dt+"'";
		}
        
        if(gubun2.equals("6"))			query += " and a.info_type='ACCIDENT' ";	//사고
		else if(gubun2.equals("7"))		query += " and a.info_type='SOS' ";			//긴급출동
		else if(gubun2.equals("8"))		query += " and a.info_type='MAINT' ";		//정비
		else if(gubun2.equals("9"))		query += " and a.info_type='ETC' ";			//기타
		else if(gubun2.equals("10"))	query += " and a.info_type is null ";		//알수없음

		else if(gubun2.equals("1"))		query += " and a.info_type in ('ACCIDENT','SOS','MAINT') and a.bill_duration>0 ";	//통화
		else if(gubun2.equals("2"))		query += " and a.info_type in ('ACCIDENT','SOS','MAINT') and a.bill_duration=0 ";	//안내문
		else if(gubun2.equals("3"))		query += " and a.info_type='ETC' and a.cid=a.redirect_number ";		//상담요청
		else if(gubun2.equals("4"))		query += " and (a.info_type is null or (a.info_type='ETC' and a.redirect_number is null)) ";			//연결실패
		else if(gubun2.equals("11"))	query += " and a.cost_yn ='Y' ";		//당직대상
		else if(gubun2.equals("12"))	query += " and a.cost_yn ='N' ";		//당직비대상
        
        if(!gubun3.equals(""))			query += " and b.br_id='"+gubun3+"' ";	//지점
        
        
        query +=" order by a.hangup_time ";
        
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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
			
		} catch (SQLException e) {
			System.out.println("[WatchDatabase:ArsCallStatSDay]"+e);
			System.out.println("[WatchDatabase:ArsCallStatSDay]"+query);
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
	
	//ARS수신월간현황
	public Vector ArsCallStatSMon(String s_yy, String s_mm) {
		getConnection();
        
		PreparedStatement pstmt = null;
		ResultSet rs = null; 
		Vector vt = new Vector();
		String query = ""; 

        query = " select a.*, (a.cnt1+a.cnt2+a.cnt3+a.cnt4) as cnt5, nvl(b.call_amt,0) call_amt "+
        		" from (SELECT substr(REPLACE(SUBSTR(a.hangup_time,1,10),'-',''),7,2) call_dt, TO_CHAR(TO_DATE(REPLACE(SUBSTR(a.hangup_time,1,10),'-',''),'YYYYMMDD'),'DY','NLS_DATE_LANGUAGE=korean') day_nm,\r\n" + 
        		"             COUNT(0) cnt0,\r\n" + 
        		"             COUNT(DECODE(a.info_type,'','','ETC','',DECODE(a.bill_duration,0,'',a.id))) cnt1,\r\n" + 
        		"             COUNT(DECODE(a.info_type,'','','ETC','',DECODE(a.bill_duration,0,a.id))) cnt2,\r\n" + 
        		"             COUNT(DECODE(a.info_type,'ETC',DECODE(a.cid,a.redirect_number,a.id))) cnt3,\r\n" +        		
        		"             COUNT(DECODE(a.info_type,'',a.id,'ETC',decode(a.redirect_number,'',a.id))) cnt4,\r\n" + 
        		"             COUNT(DECODE(a.info_type,'ACCIDENT',a.id)) cnt6,  \r\n" + 
        		"             COUNT(DECODE(a.info_type,'SOS',a.id)) cnt7,\r\n" + 
        		"             COUNT(DECODE(a.info_type,'MAINT',a.id)) cnt8,\r\n" + 
        		"             COUNT(DECODE(a.info_type,'ETC',a.id)) cnt9,\r\n" + 
        		"             COUNT(DECODE(a.info_type,'',a.id)) cnt10,\r\n" + 
//        		"             COUNT(DECODE(a.info_type,'','',DECODE(a.bill_duration,0,'',DECODE(b.loan_st,'1',DECODE(b.user_nm,c.firm_nm,'',a.id))))) cnt11,\r\n" + 
//        		"             COUNT(0)-COUNT(DECODE(a.info_type,'','',DECODE(a.bill_duration,0,'',DECODE(b.loan_st,'1',DECODE(b.user_nm,c.firm_nm,'',a.id))))) cnt12 \r\n" + 
        		"             COUNT(decode(a.cost_yn,'Y',a.id)) cnt11,\r\n" + 
        		"             COUNT(0)-COUNT(decode(a.cost_yn,'N',a.id)) cnt12 \r\n" +  
        		"      FROM   ars_call_log a, users b, client c\r\n" + 
        		"      where  SUBSTR(a.hangup_time,1,10) LIKE '"+s_yy+"-"+s_mm+"%' \r\n" + 
        		"             AND SUBSTR(a.hangup_time,1,10) > '2020-02-09'\r\n" + 
        		"             AND a.cid<>'01086534000' AND a.cid<>'01041889665' --테스트제외\r\n" + 
        		"             AND a.user_id=b.user_id(+)\r\n" + 
        		"             AND a.client_id=c.client_id(+)\r\n" + 
        		"      GROUP BY REPLACE(SUBSTR(a.hangup_time,1,10),'-','')\r\n" +
        		" ) a, (select SUBSTR(call_dt,7,2) call_dt, sum(call_amt) call_amt from ars_call_stat where call_dt LIKE '"+s_yy+""+s_mm+"%' group by SUBSTR(call_dt,7,2) ) b"+
        		" where a.call_dt=b.call_dt(+) "+
        		" ORDER BY a.call_dt \r\n" + 
        		" ";
                
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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
			
		} catch (SQLException e) {
			System.out.println("[WatchDatabase:ArsCallStatSMon]"+e);
			System.out.println("[WatchDatabase:ArsCallStatSMon]"+query);
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
	
	//ARS수신월간현황
	public Vector ArsCallStatSYear(String s_yy) {
		getConnection();
        
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector(); 
		String query = ""; 

        query = " select a.*, (a.cnt1+a.cnt2+a.cnt3+a.cnt4) as cnt5, nvl(b.call_amt,0) call_amt \r\n" + 
        		" from (SELECT substr(REPLACE(SUBSTR(a.hangup_time,1,7),'-',''),5,2) call_dt, \r\n" + 
        		"             COUNT(0) cnt0,\r\n" + 
        		"             COUNT(DECODE(a.info_type,'','','ETC','',DECODE(a.bill_duration,0,'',a.id))) cnt1,\r\n" + 
        		"             COUNT(DECODE(a.info_type,'','','ETC','',DECODE(a.bill_duration,0,a.id))) cnt2,\r\n" + 
        		"             COUNT(DECODE(a.info_type,'ETC',DECODE(a.cid,a.redirect_number,a.id))) cnt3,\r\n" +        		
        		"             COUNT(DECODE(a.info_type,'',a.id,'ETC',decode(a.redirect_number,'',a.id))) cnt4,\r\n" + 
        		"             COUNT(DECODE(a.info_type,'ACCIDENT',a.id)) cnt6,  \r\n" + 
        		"             COUNT(DECODE(a.info_type,'SOS',a.id)) cnt7,\r\n" + 
        		"             COUNT(DECODE(a.info_type,'MAINT',a.id)) cnt8,\r\n" + 
        		"             COUNT(DECODE(a.info_type,'ETC',a.id)) cnt9,\r\n" + 
        		"             COUNT(DECODE(a.info_type,'',a.id)) cnt10,\r\n" + 
//        		"             COUNT(DECODE(a.info_type,'','',DECODE(a.bill_duration,0,'',DECODE(b.loan_st,'1',DECODE(b.user_nm,c.firm_nm,'',a.id))))) cnt11,\r\n" + 
//        		"             COUNT(0)-COUNT(DECODE(a.info_type,'','',DECODE(a.bill_duration,0,'',DECODE(b.loan_st,'1',DECODE(b.user_nm,c.firm_nm,'',a.id))))) cnt12 \r\n" +
        		"             COUNT(decode(a.cost_yn,'Y',a.id)) cnt11,\r\n" + 
        		"             COUNT(0)-COUNT(decode(a.cost_yn,'N',a.id)) cnt12 \r\n" +         		
        		"      FROM   ars_call_log a, users b, client c\r\n" + 
        		"      where  a.hangup_time LIKE '"+s_yy+"%' \r\n" + 
        		"             AND SUBSTR(a.hangup_time,1,10) > '2020-02-09'\r\n" + 
        		"             AND a.cid<>'01086534000' AND a.cid<>'01041889665' --테스트제외\r\n" + 
        		"             AND a.user_id=b.user_id(+)\r\n" + 
        		"             AND a.client_id=c.client_id(+)\r\n" + 
        		"      GROUP BY REPLACE(SUBSTR(a.hangup_time,1,7),'-','')\r\n" + 
        		" ) a, (select substr(call_dt,5,2) call_dt, sum(call_amt) call_amt from ars_call_stat where call_dt LIKE '"+s_yy+"%' group by substr(call_dt,5,2)) b"+
        		" where a.call_dt=b.call_dt(+) "+
        		" ORDER BY a.call_dt \r\n" +         		
        		" ";
                
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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[WatchDatabase:ArsCallStatSYear]"+e);
			System.out.println("[WatchDatabase:ArsCallStatSYear]"+query);
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
	
	//ARS수신월간현황
	public Hashtable ArsCallStatLogUsers(String id) {
		getConnection();
        
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = ""; 

        query = " SELECT b.firm_nm, a.car_no, e1.ars_group, replace(SUBSTR(a.hangup_time,1,10),'-','') call_dt, \r\n" + 
        		"       f1.br_nm AS br_nm1, e1.user_id AS user_id1, e1.user_nm AS user_nm1, e1.user_m_tel AS user_m_tel1, \r\n" + 
        		"       f2.br_nm AS br_nm2, e2.user_id AS user_id2, e2.user_nm AS user_nm2, e2.user_m_tel AS user_m_tel2, \r\n" + 
        		"       f3.br_nm AS br_nm3, e3.user_id AS user_id3, e3.user_nm AS user_nm3, e3.user_m_tel AS user_m_tel3  \r\n" + 
        		"FROM   ars_call_log a, client b, car_reg c, cont d, users e1, BRANCH f1, users e2, BRANCH f2, users e3, BRANCH f3\r\n" + 
        		"WHERE  a.id="+id+" \r\n" + 
        		"       AND a.client_id=b.client_id \r\n" + 
        		"       AND a.car_no=c.car_no\r\n" + 
        		"       AND c.car_mng_id=d.car_mng_id\r\n" + 
        		"       AND a.client_id=d.client_id\r\n" + 
        		"       AND d.bus_id2=e1.user_id\r\n" + 
        		"       AND e1.br_id=f1.br_id \r\n" + 
        		"       AND substr(e1.ars_group,1,6)=e2.user_id(+)\r\n" + 
        		"       AND substr(e1.ars_group,8,6)=e3.user_id(+)\r\n" + 
        		"       AND e2.br_id=f2.br_id(+)\r\n" + 
        		"       AND e3.br_id=f3.br_id(+) \r\n" +         		
        		" ";
                
 	try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();   
    			
			if(rs.next())
			{								
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[WatchDatabase:ArsCallStatLogUsers]"+e);
			System.out.println("[WatchDatabase:ArsCallStatLogUsers]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}				
	
	/*
	 *	프로시져 호출 P_ARS_CALL_STAT
	*/
	public String call_sp_ars_call_stat()
	{
    	getConnection();
    	
    	String query = "{CALL P_ARS_CALL_STAT }";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
			cstmt = conn.prepareCall(query);						
			cstmt.execute();
			cstmt.close();
						
		} catch (SQLException e) {
			System.out.println("[WatchDatabase:call_sp_ars_call_stat]\n"+e);
			e.printStackTrace();
		} finally {
			try{
			     if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}	
}
