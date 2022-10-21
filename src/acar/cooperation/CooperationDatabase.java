
/**
 * 업무협조 게시판
 * @ author : Gill Sun Ryu
 * @ e-mail : gillsun@empal.com
 * @ create date : 2009. 07. 03
 * @ last modify date : 
 */

package acar.cooperation;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.util.*;
import java.text.*;
import acar.database.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.UnknownDataException;
import acar.exception.DatabaseException;

public class CooperationDatabase
{
	private Connection conn = null;
	public static CooperationDatabase db;
	
	public static CooperationDatabase getInstance()
	{
		if(CooperationDatabase.db == null)
			CooperationDatabase.db = new CooperationDatabase();
		return CooperationDatabase.db;
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
     *  일정전체조회
     */
public Vector CooperationList(String in_year, String in_mon, String in_day ) {
		getConnection();
        
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

	      query = " select a.*, decode(a.out_id, '000004','총무팀장','000005','영업팀장','000006','고객지원팀장','000052','대전지점장','000053','부산지점장') as out_nm, b.user_nm, c.user_nm as SUB_NM \n"
        		+ " from cooperation a, users b, users c\n"
				+ " where a.in_id = b.user_id(+) and a.sub_id = c.user_id(+) and substr(a.in_dt, 1, 4) ='"+in_year+"' and substr(a.in_dt, 5, 2) ='"+in_mon+"'  \n" ;//and substr(a.in_dt, 7, 2) ='"+in_day+"'

				query += "order by a.in_dt desc";


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
			System.out.println("[CooperationDatabase:CooperationList]"+e);
			System.out.println("[CooperationDatabase:CooperationList]"+query);
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
     *  업무협조문 입력
     */

	public int insertCooperation(CooperationBean bean) {
		getConnection();

        PreparedStatement pstmt = null;
		ResultSet rs = null;
		Statement stmt = null;
		int count = 0;
		String query = "";
		String query_seq = "";
		int seq = 0;


 	  	query_seq = " select nvl(max(seq)+1, 1) "
				   +" from cooperation ";	
                   
        query = "INSERT INTO cooperation (seq, in_id, in_dt, title, content, out_id, sub_id, \n"
							+ " req_st, client_id, agnt_nm, agnt_m_tel, agnt_email, com_id )\n"
							+ "values( ?, \n"
							+ " ?,\n"
							+ " to_char(sysdate,'YYYYMMDD'), \n"
							+ " ?, \n"
							+ " ?, \n"
							+ " ?, \n"
							+ " ?, \n"
							+ " ?, ?, ?, ?, ?, ? \n"
							+ " )";


	try 
		{			
			conn.setAutoCommit(false);
			
  			stmt = conn.createStatement();
            rs = stmt.executeQuery(query_seq);         
            if(rs.next()){
            	seq = rs.getInt(1);
			}
            rs.close();
			stmt.close();
				
			pstmt = conn.prepareStatement(query);
			pstmt.setInt   (1, seq				);
			pstmt.setString(2, bean.getIn_id()	);
			pstmt.setString(3, bean.getTitle()	);
			pstmt.setString(4, bean.getContent());
			pstmt.setString(5, bean.getOut_id()	);
			pstmt.setString(6, bean.getSub_id()	);
			pstmt.setString(7, bean.getReq_st	());
			pstmt.setString(8, bean.getClient_id());
			pstmt.setString(9, bean.getAgnt_nm	());
			pstmt.setString(10,bean.getAgnt_m_tel());
			pstmt.setString(11,bean.getAgnt_email());
			pstmt.setString(12,bean.getCom_id());

			count = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		} catch (SQLException e) {
			System.out.println("[CooperationDatabase:insertCooperation]\n"+e);
			System.out.println("[CooperationDatabase:insertCooperation]\n"+query);
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
			return seq;
		}
	}
	



	 /**
     *  업무협조 한건조회
     */

public Vector CooperationView(int seq, String in_dt, String in_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

				query =   " select a.*, b.user_nm, c.user_nm SUB_NM "
						+ " from cooperation a, users b, users c"
						+ " where a.in_id = b.user_id and a.sub_id = c.user_id(+) and a.seq = '"+seq+"' ";

				if(!in_dt.equals("")) query += " and a.in_dt = '"+in_dt+"' ";
				if(!in_id.equals("")) query += " and a.in_id = '"+in_id+"' ";


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
			System.out.println("[CooperationDatabase:CooperationView]"+e);
			System.out.println("[CooperationDatabase:CooperationView]"+query);
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
     * 처리 담당자 등록
     */

 public int updateSubid(CooperationBean bean){

		getConnection();

		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";

            query = " update cooperation set \n"+
					" sub_id	= ?  \n"+
					" where seq=? and in_dt=?  ";

		try 
		{			
			conn.setAutoCommit(false);	

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, bean.getSub_id());
			pstmt.setInt   (2, bean.getSeq());
			pstmt.setString(3, bean.getIn_dt());
			count = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		} catch (SQLException e) {
			System.out.println("[CooperationDatabase:updateSubid]\n"+e);
			System.out.println("[CooperationDatabase:updateSubid]\n"+query);
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




		/**
	  *  승인완료일 등록
	  */
	
	 public int updateSubdt(CooperationBean bean) {
			getConnection();
	
			PreparedStatement pstmt = null;
			int count = 0;
			String query = "";
	
	         query = " update cooperation set \n"+
						" sub_dt		= sysdate	\n"+
						" where seq =? and in_id = ? ";
	
		try {		
				conn.setAutoCommit(false);	
				pstmt = conn.prepareStatement(query);
				
				pstmt.setInt   (1, bean.getSeq			());
				pstmt.setString(2, bean.getIn_id		());
	
				count = pstmt.executeUpdate();
				pstmt.close();
				conn.commit();
	
			} catch (SQLException e) {
				System.out.println("[CooperationDatabase:updateSub_dt]\n"+e);
				System.out.println("[CooperationDatabase:updateSub_dt]\n"+query);
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
	/**
     * 처리완료일 등록
     */

    public int updateOutdt(CooperationBean bean) {
		getConnection();

		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";

            query = " update cooperation set \n"+
					" out_content	= ?,		\n"+
					" out_dt		= sysdate,	\n"+
					" agnt_nm		= ?,		\n"+
					" agnt_m_tel	= ?,		\n"+
					" agnt_email	= ?,		\n"+
					" cls_dt		= ?			\n"+
					" where seq =? and in_id = ? ";

	try {		
			conn.setAutoCommit(false);	
			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, bean.getOut_content	());
			pstmt.setString(2, bean.getAgnt_nm		());
			pstmt.setString(3, bean.getAgnt_m_tel	());
			pstmt.setString(4, bean.getAgnt_email	());
			pstmt.setString(5, bean.getCls_dt		());
			pstmt.setInt   (6, bean.getSeq			());
			pstmt.setString(7, bean.getIn_id		());

			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[CooperationDatabase:updateOut_dt]\n"+e);
			System.out.println("[CooperationDatabase:updateOut_dt]\n"+query);
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
    /**
     * 처리완료 취소
     */
    
    public int updateCancel(CooperationBean bean) {
    	getConnection();
    	
    	PreparedStatement pstmt = null;
    	int count = 0;
    	String query = "";
    	
    	query = " update cooperation set \n"+
    			" out_content	= ?,		\n"+
    			" out_dt		= '',	\n"+
    			" agnt_nm		= ?,		\n"+
    			" agnt_m_tel	= ?,		\n"+
    			" agnt_email	= ?			\n"+
    			" where seq =? and in_id = ? ";
    	
    	try {		
    		conn.setAutoCommit(false);	
    		pstmt = conn.prepareStatement(query);
    		
    		pstmt.setString(1, bean.getOut_content	());
    		pstmt.setString(2, bean.getAgnt_nm		());
    		pstmt.setString(3, bean.getAgnt_m_tel	());
    		pstmt.setString(4, bean.getAgnt_email	());
    		pstmt.setInt   (5, bean.getSeq			());
    		pstmt.setString(6, bean.getIn_id		());
    		
    		count = pstmt.executeUpdate();
    		pstmt.close();
    		conn.commit();
    		
    	} catch (SQLException e) {
    		System.out.println("[CooperationDatabase:updateCancel]\n"+e);
    		System.out.println("[CooperationDatabase:updateCancel]\n"+query);
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
    /**
     * 처리완료일 등록
     */
    
    public int updateClsdt(CooperationBean bean) {
    	getConnection();
    	
    	PreparedStatement pstmt = null;
    	int count = 0;
    	String query = "";
    	
    	query = " update cooperation set \n"+
    			" cls_dt		= ?	\n"+
    			" where seq =? and in_id = ? ";
    	
    	try {		
    		conn.setAutoCommit(false);	
    		pstmt = conn.prepareStatement(query);
    		
    		pstmt.setString(1, bean.getCls_dt	());
    		pstmt.setInt   (2, bean.getSeq			());
    		pstmt.setString(3, bean.getIn_id		());
    		
    		count = pstmt.executeUpdate();
    		pstmt.close();
    		conn.commit();
    		
    	} catch (SQLException e) {
    		System.out.println("[CooperationDatabase:updateClsdt]\n"+e);
    		System.out.println("[CooperationDatabase:updateClsdt]\n"+query);
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

	/**
     * 수정
     */

 public int updatecontent(CooperationBean bean){

		getConnection();

		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";

            query = " update cooperation set \n"+
					" title		= ?,  \n"+
					" content	= ?   \n"+
					" where seq=? and in_dt=?  ";

		try 
		{			
		conn.setAutoCommit(false);	
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getTitle	());
			pstmt.setString(2, bean.getContent	());
			pstmt.setInt   (3, bean.getSeq		());
			pstmt.setString(4, bean.getIn_dt	());

			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[CooperationDatabase:updatecontent]\n"+e);
			System.out.println("[CooperationDatabase:updatecontent]\n"+query);
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

	/**
     * 수정
     */

 public int updateCooperation(CooperationBean bean){

		getConnection();

		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";

            query = " update cooperation set \n"+
					" title			= ?,	\n"+
					" content		= ?,	\n"+
					" out_content	= ?,	\n"+
					" agnt_nm		= ?,	\n"+
					" agnt_m_tel	= ?,	\n"+
					" agnt_email	= ?,	\n"+
					" sub_dt		= ?,	\n"+
					" out_dt		= ?		\n"+
					" where seq=?  ";

		try 
		{			
		conn.setAutoCommit(false);	
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getTitle		());
			pstmt.setString(2, bean.getContent		());
			pstmt.setString(3, bean.getOut_content	());
			pstmt.setString(4, bean.getAgnt_nm		());
			pstmt.setString(5, bean.getAgnt_m_tel	());
			pstmt.setString(6, bean.getAgnt_email	());
			pstmt.setString(7, bean.getSub_dt	());
			pstmt.setString(8, bean.getOut_dt	());
			pstmt.setInt   (9, bean.getSeq			());

			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[CooperationDatabase:updateCooperation]\n"+e);
			System.out.println("[CooperationDatabase:updateCooperation]\n"+query);
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

	/**
     * 삭제
     */

    public int delcooperation(CooperationBean bean) {
		getConnection();

		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";

		query = " DELETE  FROM cooperation \n"+
				" where seq=? and in_dt=?";	

	try {		
			conn.setAutoCommit(false);	
			pstmt = conn.prepareStatement(query);
			
			pstmt.setInt(1, bean.getSeq());
			pstmt.setString(2, bean.getIn_dt());

			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[CooperationDatabase:delcooperation]\n"+e);
			System.out.println("[CooperationDatabase:delcooperation]\n"+query);
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

	 /**
     *  일정전체조회
     */
	public Vector CooperationList(String in_year, String in_mon, String in_day, String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String gubun4 ) {
		getConnection();
        
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

	    query = " select a.*, "+
				"        decode(a.out_id, '000004','총무팀장','000005','영업팀장','000006','고객지원팀장','000052','대전지점장','000053','부산지점장') as out_nm, "+
				"        b.user_nm, c.user_nm as SUB_NM \n"+
        		" from   cooperation a, users b, users c\n"+
				" where  a.in_id = b.user_id(+) and a.sub_id = c.user_id(+) and nvl(a.req_st,'1')='1' and title not like '%[IT마케팅팀개발업무%' ";

		if(!in_year.equals("") && !in_mon.equals(""))	query += " and substr(a.in_dt, 1, 4) ='"+in_year+"' and substr(a.in_dt, 5, 2) ='"+in_mon+"'  \n" ;
		if(!in_year.equals("") && in_mon.equals(""))	query += " and substr(a.in_dt, 1, 4) ='"+in_year+"' \n" ;

		if(gubun2.equals("1")) query += " and a.out_dt is not null";
		if(gubun2.equals("2")) query += " and a.out_dt is null";

		if(gubun3.equals("1")) query += " and a.sub_id is not null";
		if(gubun3.equals("2")) query += " and a.sub_id is null";

		String what = "";

		if(s_kd.equals("1"))	what = "upper(nvl(a.title||a.content, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(b.user_nm, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(c.user_nm, ' '))";	
		if(s_kd.equals("4"))	what = "upper(nvl(b.user_nm||c.user_nm, ' '))";	
			
		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	


		query += " order by a.in_dt desc";


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
			System.out.println("[CooperationDatabase:CooperationList]"+e);
			System.out.println("[CooperationDatabase:CooperationList]"+query);
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
     *  고객업무협조 전체조회
     */
	public Vector CooperationCList(String in_year, String in_mon, String in_day, String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String gubun4 ) {
		getConnection();
        
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

	    query = " select a.*, "+
				"        decode(a.out_id, '000004','총무팀장','000005','영업팀장','000006','고객지원팀장','000052','대전지점장','000053','부산지점장') as out_nm, "+
				"        b.user_nm, c.user_nm as SUB_NM, d.firm_nm \n"+
        		" from   cooperation a, users b, users c, client d \n"+
				" where  a.in_id = b.user_id(+) and a.sub_id = c.user_id(+) and nvl(a.req_st,'1')='2' and a.client_id=d.client_id ";

		if(!in_year.equals("") && !in_mon.equals(""))	query += " and substr(a.in_dt, 1, 4) ='"+in_year+"' and substr(a.in_dt, 5, 2) ='"+in_mon+"'  \n" ;
		if(!in_year.equals("") && in_mon.equals(""))	query += " and substr(a.in_dt, 1, 4) ='"+in_year+"' \n" ;

		if(gubun2.equals("1")) query += " and a.out_dt is not null";
		if(gubun2.equals("2")) query += " and a.out_dt is null";

		if(gubun3.equals("1")) query += " and a.sub_id is not null";
		if(gubun3.equals("2")) query += " and a.sub_id is null";

		String what = "";

		if(s_kd.equals("1"))	what = "upper(nvl(a.title||a.content, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(d.firm_nm, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(c.user_nm, ' '))";	
		if(s_kd.equals("4"))	what = "upper(nvl(b.user_nm||c.user_nm, ' '))";	
			
		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	


		query += " order by a.in_dt desc";


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
			System.out.println("[CooperationDatabase:CooperationCList]"+e);
			System.out.println("[CooperationDatabase:CooperationCList]"+query);
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
     *  일정전체조회
     */
	public Vector CooperationPList(String in_year, String in_mon, String in_day, String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String gubun4 ) {
		getConnection();
        
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

	    query = " select a.*, "+
				"        decode(a.out_id, '000004','총무팀장','000005','영업팀장','000026','고객지원팀장','000052','대전지점장','000053','부산지점장','000054','대구지점장','000237','IT마케팅팀팀장','000118','광주지점장') as out_nm, "+
				"        b.user_nm, c.user_nm as SUB_NM \n"+
        		" from   cooperation a, users b, users c\n"+
				" where  a.in_id = b.user_id(+) and a.sub_id = c.user_id(+) and a.req_st ='3' ";

		if(!in_year.equals("") && !in_mon.equals(""))	query += " and substr(a.in_dt, 1, 4) ='"+in_year+"' and substr(a.in_dt, 5, 2) ='"+in_mon+"'  \n" ;
		if(!in_year.equals("") && in_mon.equals(""))	query += " and substr(a.in_dt, 1, 4) ='"+in_year+"' \n" ;

		if(gubun2.equals("1")) query += " and a.out_dt is not null";
		if(gubun2.equals("2")) query += " and a.out_dt is null";

		if(gubun3.equals("1")) query += " and a.sub_id is not null";
		if(gubun3.equals("2")) query += " and a.sub_id is null";

		String what = "";

		if(s_kd.equals("1"))	what = "upper(nvl(a.title||a.content, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(b.user_nm, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(c.user_nm, ' '))";	
		if(s_kd.equals("4"))	what = "upper(nvl(b.user_nm||c.user_nm, ' '))";	
			
		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	


		query += " order by a.in_dt desc";


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
			System.out.println("[CooperationDatabase:CooperationList]"+e);
			System.out.println("[CooperationDatabase:CooperationList]"+query);
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
     *  일정전체조회
     */
	public Vector CooperationITList(String in_year, String in_mon, String in_day, String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String gubun4 ) {
		getConnection();
        
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

	    query = " select a.*, "+
				"        decode(a.out_id, '000004','총무팀장','000005','영업팀장','000026','고객지원팀장','000052','박영규차장','000053','제인학과장','000054','윤영탁과장','000237','IT마케팅팀팀장','000118','이수재대리') as out_nm, "+
				"        b.user_nm, c.user_nm as SUB_NM, d.user_nm AS com_nm \n"+
        		" from   cooperation a, users b, users c, users d\n"+
				" where  a.in_id = b.user_id(+) and a.sub_id = c.user_id(+) AND a.com_id = d.user_id(+) and a.title like '[IT마케팅팀개발업무%' ";

		if(!in_year.equals("") && !in_mon.equals(""))	query += " and substr(a.in_dt, 1, 4) ='"+in_year+"' and substr(a.in_dt, 5, 2) ='"+in_mon+"'  \n" ;
		if(!in_year.equals("") && in_mon.equals(""))	query += " and substr(a.in_dt, 1, 4) ='"+in_year+"' \n" ;

		if(gubun2.equals("1")) query += " and a.out_dt is not null";
		if(gubun2.equals("2")) query += " and a.out_dt is null";

		if(gubun3.equals("1")) query += " and a.sub_id is not null";
		if(gubun3.equals("2")) query += " and a.sub_id is null";

		String what = "";

		if(s_kd.equals("1"))	what = "upper(nvl(a.title||a.content, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(b.user_nm, ' '))";	//등록자
		if(s_kd.equals("3"))	what = "upper(nvl(c.user_nm, ' '))";	//담당자
		if(s_kd.equals("4"))	what = "upper(nvl(b.user_nm||c.user_nm, ' '))";	//등록자+당당자
		if(s_kd.equals("5"))	what = "upper(nvl(b.user_nm||c.user_nm||d.user_nm, ' '))";//등록자+담당자+요청자	
			
		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	


		query += " order by a.in_dt desc";


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
			System.out.println("[CooperationDatabase:CooperationList]"+e);
			System.out.println("[CooperationDatabase:CooperationList]"+query);
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
     *  일정전체조회
     */
	public Vector CooperationNList(String in_year, String in_mon, String in_day, String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String gubun4 ) {
		getConnection();
        
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

	    query = " select a.*, "+
				"        decode(a.out_id, '000004','총무팀장','000005','영업팀장','000006','고객지원팀장','000052','대전지점장','000053','부산지점장') as out_nm, b.user_nm, c.user_nm as SUB_NM \n"+
        		" from   cooperation a, users b, users c\n"+
				" where  a.title like '%[내용증명발송요청]%' "+
				" and    a.in_id = b.user_id(+) and a.sub_id = c.user_id(+) ";

		if(!in_year.equals("") && !in_mon.equals(""))	query += " and substr(a.in_dt, 1, 4) ='"+in_year+"' and substr(a.in_dt, 5, 2) ='"+in_mon+"'  \n" ;
		if(!in_year.equals("") && in_mon.equals(""))	query += " and substr(a.in_dt, 1, 4) ='"+in_year+"' \n" ;

		if(gubun2.equals("1")) query += " and a.out_dt is not null";
		if(gubun2.equals("2")) query += " and a.out_dt is null";

		if(gubun3.equals("1")) query += " and a.sub_id is not null";
		if(gubun3.equals("2")) query += " and a.sub_id is null";

		String what = "";

		if(s_kd.equals("1"))	what = "upper(nvl(a.title||a.content, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(b.user_nm, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(c.user_nm, ' '))";	
		if(s_kd.equals("4"))	what = "upper(nvl(b.user_nm||c.user_nm, ' '))";	
			
		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	


		query += " order by a.in_dt desc";


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
			System.out.println("[CooperationDatabase:CooperationNList]"+e);
			System.out.println("[CooperationDatabase:CooperationNList]"+query);
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
     *  일정전체조회
     */
	public Vector CooperationN2List(String in_year, String in_mon, String in_day, String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String gubun4 ) {
		getConnection();
        
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

	    query = " select a.*, "+
				"        decode(a.out_id, '000004','총무팀장','000005','영업팀장','000006','고객지원팀장','000052','대전지점장','000053','부산지점장') as out_nm, b.user_nm, c.user_nm as SUB_NM \n"+
        		" from   cooperation a, users b, users c\n"+
				" where  a.title like '%[채권추심의뢰요청]%' "+
				" and    a.in_id = b.user_id(+) and a.sub_id = c.user_id(+) ";

		if(!in_year.equals("") && !in_mon.equals(""))	query += " and substr(a.in_dt, 1, 4) ='"+in_year+"' and substr(a.in_dt, 5, 2) ='"+in_mon+"'  \n" ;
		if(!in_year.equals("") && in_mon.equals(""))	query += " and substr(a.in_dt, 1, 4) ='"+in_year+"' \n" ;

		if(gubun2.equals("1")) query += " and a.out_dt is not null";
		if(gubun2.equals("2")) query += " and a.out_dt is null";

		if(gubun3.equals("1")) query += " and a.sub_id is not null";
		if(gubun3.equals("2")) query += " and a.sub_id is null";

		String what = "";

		if(s_kd.equals("1"))	what = "upper(nvl(a.title||a.content, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(b.user_nm, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(c.user_nm, ' '))";	
		if(s_kd.equals("4"))	what = "upper(nvl(b.user_nm||c.user_nm, ' '))";	
			
		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	


		query += " order by a.in_dt desc";


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
			System.out.println("[CooperationDatabase:CooperationN2List]"+e);
			System.out.println("[CooperationDatabase:CooperationN2List]"+query);
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
	 *  일정전체조회
	 */
	public Vector CooperationN3List(String in_year, String in_mon, String in_day, String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String gubun4 ) {
		getConnection();
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = " select a.*, "+
				"        decode(a.out_id, '000004','총무팀장','000005','영업팀장','000006','고객지원팀장','000052','대전지점장','000053','부산지점장') as out_nm, b.user_nm, c.user_nm as SUB_NM \n"+
				" from   cooperation a, users b, users c\n"+
				" where  a.title like '%[채무자주소조회요청]%' "+
				" and    a.in_id = b.user_id(+) and a.sub_id = c.user_id(+) ";
		
		if(!in_year.equals("") && !in_mon.equals(""))	query += " and substr(a.in_dt, 1, 4) ='"+in_year+"' and substr(a.in_dt, 5, 2) ='"+in_mon+"'  \n" ;
		if(!in_year.equals("") && in_mon.equals(""))	query += " and substr(a.in_dt, 1, 4) ='"+in_year+"' \n" ;
		
		if(gubun2.equals("1")) query += " and a.out_dt is not null and a.cls_dt is null";
		if(gubun2.equals("2")) query += " and a.out_dt is null";
		if(gubun2.equals("3")) query += " and a.out_dt is not null and a.cls_dt is not null";
		
		if(gubun3.equals("1")) query += " and a.sub_id is not null";
		if(gubun3.equals("2")) query += " and a.sub_id is null";
		
		String what = "";
		
		if(s_kd.equals("1"))	what = "upper(nvl(a.title||a.content, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(b.user_nm, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(c.user_nm, ' '))";	
		if(s_kd.equals("4"))	what = "upper(nvl(b.user_nm||c.user_nm, ' '))";	
		
		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	
		
		
		query += " order by a.in_dt desc";
		
		
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
			System.out.println("[CooperationDatabase:CooperationN2List]"+e);
			System.out.println("[CooperationDatabase:CooperationN2List]"+query);
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
	 *  일정전체조회
	 */
	public Vector CooperationN4List(String in_year, String in_mon, String in_day, String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String gubun4 ) {
		getConnection();
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = " select a.*, "+
				"        decode(a.out_id, '000004','총무팀장','000005','영업팀장','000006','고객지원팀장','000052','대전지점장','000053','부산지점장') as out_nm, b.user_nm, c.user_nm as SUB_NM \n"+
				" from   cooperation a, users b, users c\n"+
				" where  a.title like '%[운행정지명령신청요청]%' "+
				" and    a.in_id = b.user_id(+) and a.sub_id = c.user_id(+) ";
		
		if(!in_year.equals("") && !in_mon.equals(""))	query += " and substr(a.in_dt, 1, 4) ='"+in_year+"' and substr(a.in_dt, 5, 2) ='"+in_mon+"'  \n" ;
		if(!in_year.equals("") && in_mon.equals(""))	query += " and substr(a.in_dt, 1, 4) ='"+in_year+"' \n" ;
		
		if(gubun2.equals("1")) query += " and a.out_dt is not null";
		if(gubun2.equals("2")) query += " and a.out_dt is null";
		if(gubun2.equals("3")) query += " and a.out_dt is not null and a.out_content = '발송'";
		if(gubun2.equals("4")) query += " and a.out_dt is not null and a.out_content <> '발송'";
		
		if(gubun3.equals("1")) query += " and a.sub_id is not null";
		if(gubun3.equals("2")) query += " and a.sub_id is null";
		
		String what = "";
		
		if(s_kd.equals("1"))	what = "upper(nvl(a.title||a.content, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(b.user_nm, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(c.user_nm, ' '))";	
		if(s_kd.equals("4"))	what = "upper(nvl(b.user_nm||c.user_nm, ' '))";	
		
		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	
		
		
		query += " order by a.in_dt desc, a.sub_dt desc";
		
		
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
			System.out.println("[CooperationDatabase:CooperationN4List]"+e);
			System.out.println("[CooperationDatabase:CooperationN4List]"+query);
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
     *  일정전체조회
     */
	public Vector CooperationNList(String in_year, String in_mon, String in_day ) {
		getConnection();
        
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

	    query = " select a.*, "+
				"        decode(a.out_id, '000004','총무팀장','000005','영업팀장','000006','고객지원팀장','000052','대전지점장','000053','부산지점장') as out_nm, b.user_nm, c.user_nm as SUB_NM \n"+
        		" from   cooperation a, users b, users c\n"+
				" where  a.out_dt is null and a.title like '%[내용증명발송요청]%' "+
				" and    a.in_id = b.user_id(+) and a.sub_id = c.user_id(+) ";

		if(!in_year.equals("") && !in_mon.equals(""))	query += " and substr(a.in_dt, 1, 4) ='"+in_year+"' and substr(a.in_dt, 5, 2) ='"+in_mon+"'  \n" ;
		if(!in_year.equals("") && in_mon.equals(""))	query += " and substr(a.in_dt, 1, 4) ='"+in_year+"' \n" ;

		query += "order by a.in_dt desc";


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
			System.out.println("[CooperationDatabase:CooperationNList]"+e);
			System.out.println("[CooperationDatabase:CooperationNList]"+query);
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
     *  계약점검 업무협조리스트
     */
	public Vector CooperationContChkMList(String rent_l_cd) {
		getConnection();
        
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

	    query = " select a.*, "+
				"        decode(a.out_id, '000004','총무팀장','000005','영업팀장','000006','고객지원팀장','000052','대전지점장','000053','부산지점장') as out_nm, b.user_nm, c.user_nm as SUB_NM \n"+
        		" from   cooperation a, users b, users c\n"+
				" where  a.title like '%[미제출서류]%"+rent_l_cd+"%' "+
				" and    a.in_id = b.user_id(+) and a.sub_id = c.user_id(+) ";

		query += "order by a.in_dt desc";


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
			System.out.println("[CooperationDatabase:CooperationContChkMList]"+e);
			System.out.println("[CooperationDatabase:CooperationContChkMList]"+query);
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
     *  일정전체조회
     */
	public Vector CooperationUserList(String user_id, String gubun ) {
		getConnection();
        
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

	    query = " select a.*, "+
				"        decode(a.out_id, '000004','총무팀장','000005','영업팀장','000026','고객지원팀장','000052','대전지점장','000053','부산지점장','000237','IT마케팅팀장') as out_nm, b.user_nm, c.user_nm as SUB_NM \n"+
        		" from   cooperation a, users b, users c\n"+
				" where  a.in_id = b.user_id and a.sub_id = c.user_id(+) and b.user_id||b.partner_id like '%"+user_id+"%' ";

		if(!gubun.equals(""))	query += " and upper(nvl(a.title||a.content, ' ')) like upper('%"+gubun+"%')";

		query += " order by a.in_dt desc";


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
			System.out.println("[CooperationDatabase:CooperationUserList]"+e);
			System.out.println("[CooperationDatabase:CooperationUserList]"+query);
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
     *  업무협조 한건조회
     */

	public CooperationBean getCooperationBean(int seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		CooperationBean bean = new CooperationBean();

		query =  " select * from cooperation where seq="+seq;

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();	
    			
			if(rs.next())
			{				
				
				bean.setSeq			(rs.getInt   ("seq"));
				bean.setIn_id		(rs.getString("in_id")		==null?"":rs.getString("in_id"));
				bean.setIn_dt		(rs.getString("in_dt")		==null?"":rs.getString("in_dt"));
				bean.setOut_dt		(rs.getString("out_dt")		==null?"":rs.getString("out_dt"));
				bean.setOut_id		(rs.getString("out_id")		==null?"":rs.getString("out_id"));
				bean.setTitle		(rs.getString("title")		==null?"":rs.getString("title"));
				bean.setContent		(rs.getString("content")	==null?"":rs.getString("content"));
				bean.setOut_content	(rs.getString("out_content")==null?"":rs.getString("out_content"));
				bean.setSub_id		(rs.getString("sub_id")		==null?"":rs.getString("sub_id"));				
				bean.setFile_name1	(rs.getString("file_name1")	==null?"":rs.getString("file_name1"));				
				bean.setFile_name2	(rs.getString("file_name2")	==null?"":rs.getString("file_name2"));			
				bean.setReq_st		(rs.getString("req_st")		==null?"":rs.getString("req_st"));								
				bean.setClient_id	(rs.getString("client_id")	==null?"":rs.getString("client_id"));
				bean.setAgnt_nm		(rs.getString("agnt_nm")	==null?"":rs.getString("agnt_nm"));
				bean.setAgnt_m_tel	(rs.getString("agnt_m_tel")	==null?"":rs.getString("agnt_m_tel"));
				bean.setAgnt_email	(rs.getString("agnt_email")	==null?"":rs.getString("agnt_email"));
				bean.setCom_id		(rs.getString("com_id")	==null?"":rs.getString("com_id"));
				bean.setProp_id		(rs.getInt   ("prop_id"));
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[CooperationDatabase:getCooperationBean]"+e);
			System.out.println("[CooperationDatabase:getCooperationBean]"+query);
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

	public int deleteCoopScan(int seq, String idx){

		getConnection();

		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";
		             	
	    if ( idx.equals("1") ) {
               query=" update cooperation set file_name1='' WHERE seq ="+seq ;	
        } else if ( idx.equals("2") ) {
               query=" update cooperation set file_name2='' WHERE seq ="+seq ;		
        } 		


		try 
		{			
			conn.setAutoCommit(false);	
			pstmt = conn.prepareStatement(query);
			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[CooperationDatabase:deleteCoopScan]\n"+e);
			System.out.println("[CooperationDatabase:deleteCoopScan]\n"+query);
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

	public int updateCoopScan(int seq, String idx, String file_name){

		getConnection();

		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";
		             	
	    if ( idx.equals("1") ) {
               query=" update cooperation set file_name1=? WHERE seq =? " ;	
        } else if ( idx.equals("2") ) {
               query=" update cooperation set file_name2=? WHERE seq =? " ;		
        } 		


		try 
		{			
			conn.setAutoCommit(false);	
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1, file_name);
            pstmt.setInt	(2, seq);
			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[CooperationDatabase:updateCoopScan]\n"+e);
			System.out.println("[CooperationDatabase:updateCoopScan]\n"+query);
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

//일련번호 조회
	public String getCooperationSeqNext()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String seq = "";
		String query = "";

		query = " select nvl(max(seq)+1, 1) from cooperation ";

		try {
				pstmt = conn.prepareStatement(query);
			//	pstmt.setString	(1,	cardno);
		    	rs = pstmt.executeQuery();
   	
			if(rs.next())
			{				
				seq = rs.getString(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CooperationDatabase:getCooperationSeqNext]\n"+e);
			System.out.println("[CooperationDatabase:getCooperationSeqNext]\n"+query);
	  		e.printStackTrace();

		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return seq;
		}		
	}


//IT마케팅팀 업무 등록
public int insertCooperationIt(CooperationBean bean) {
		getConnection();

       PreparedStatement pstmt = null;
		int count = 0;
		String query = "";
		String query_seq = "";
		int seq = 0;

                   
        query = "INSERT INTO cooperation (seq, in_id, in_dt, title, content, out_id, sub_id, req_st, com_id , prop_id) \n"
							+ "values( ?, ?, to_char(sysdate,'YYYYMMDD'), ?, ?, ?, ?, ?, ?,?  )";


	try 
		{			
			conn.setAutoCommit(false);
			
	
			pstmt = conn.prepareStatement(query);
			pstmt.setInt   (1, bean.getSeq()	);
			pstmt.setString(2, bean.getIn_id()	);
			pstmt.setString(3, bean.getTitle()	);
			pstmt.setString(4, bean.getContent());
			pstmt.setString(5, bean.getOut_id()	);
			pstmt.setString(6, bean.getSub_id()	);
			pstmt.setString(7, bean.getReq_st	());
			pstmt.setString(8, bean.getCom_id());
			pstmt.setInt(9, bean.getProp_id());

			count = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		} catch (SQLException e) {
			System.out.println("[CooperationDatabase:insertCooperationIt]\n"+e);
			System.out.println("[CooperationDatabase:insertCooperationIt]\n"+query);
			System.out.println("seq =" + bean.getSeq()	);
						
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


	  /**
	 *	제안 count
	 */
	public int getPropCnt(int prop_id) 
	{
	
		getConnection();
			
		Statement stmt = null;
		ResultSet rs = null;
		int count = 0;
		String query = "";

		query = " select count(0) from cooperation where prop_id = "+prop_id;

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
	    	
	   		if(rs.next())
			{				
				count = rs.getInt(1);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[CooperationDatabase:getPropCnt]\n"+e);
			System.out.println("[CooperationDatabase:getPropCnt]\n"+query);
	  		e.printStackTrace();

		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( stmt != null )	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}		
	}
	
	public Vector getAcarAttachFile(String seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query ="SELECT * FROM "+
				"ACAR_ATTACH_FILE " +
				"WHERE SEQ ='"+seq+"'"+
				"";
		
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
					 ht.put(columnName, (rs.getString(columnName))==null?" ":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			//System.out.println("[InsDatabase:getInsComList]"+ e);
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
	
	public Vector getContProofList(String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query ="SELECT * FROM "+
				"FINE_DOC_LIST a, ACAR_ATTACH_FILE b " +
				"WHERE a.DOC_ID = b.CONTENT_SEQ "+
				"AND b.CONTENT_CODE ='FINE_DOC' and b.ISDELETED='N' "+
				"AND rent_l_cd ='"+rent_l_cd+"'"+
				"";
		
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
					ht.put(columnName, (rs.getString(columnName))==null?" ":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			//System.out.println("[InsDatabase:getInsComList]"+ e);
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
		 *	채무자주소조회 관련 내용증명 반송건수  - ho_addr로 조회 
		 */
	public int getCreditResultCnt(String rent_l_cd ) 
	{
		
			getConnection();
				
			Statement stmt = null;
			ResultSet rs = null;
			int count = 0;
			String query = "";

			query = " select count(0)  from fine_doc_list  a, fine_doc b , client c \n "+
					" where a.rent_l_cd = '"+rent_l_cd +"' and a.doc_id = b.doc_id and b.doc_id like '채권추심%'  \n "+
					" and b.gov_id = c.client_id and b.gov_addr = c.ho_addr and  b.f_result = '1' ";
					 
			try {
				stmt = conn.createStatement();
		    	rs = stmt.executeQuery(query);
		    	
		   		if(rs.next())
				{				
					count = rs.getInt(1);
				}
				rs.close();
				stmt.close();
			} catch (SQLException e) {
				System.out.println("[CooperationDatabase:getCreditResultCnt]\n"+e);
				System.out.println("[CooperationDatabase:getCreditResultCnt]\n"+query);
		  		e.printStackTrace();

			} finally {
				try{
					if ( rs != null )		rs.close();
					if ( stmt != null )	stmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return count;
			}		
	}
	 

}