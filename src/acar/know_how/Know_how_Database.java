/**
 * 당직근무
 * @ author : Gill Sun Ryu
 * @ e-mail : gillsun@empal.com
 * @ create date : 2009. 07. 07
 * @ last modify date : 
 */

package acar.know_how;

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

public class Know_how_Database
{
	private Connection conn = null;
	public static Know_how_Database db;
	
	public static Know_how_Database getInstance()
	{
		if(Know_how_Database.db == null)
			Know_how_Database.db = new Know_how_Database();
		return Know_how_Database.db;
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


//아마존카 지식인---------------------------------------------------------------------------------------------------------------------------------

     /**
     *  지식전체조회
     */
public Vector Know_how_AllList(String gubun, String gubun_nm, String gubun1) {
		getConnection();
        
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String subQuery = "";
		String query = "";

		if(!gubun1.equals(""))			    query += " and a.know_how_st= '" + gubun1 + "'";
			
        if(gubun.equals("title"))			subQuery = " and a.title like '%" + gubun_nm + "%'\n";
        else if(gubun.equals("content"))	subQuery = " and a.content like '%" + gubun_nm + "%'\n";
        else if(gubun.equals("reg_dt"))		subQuery = " and a.reg_dt >= replace('" + gubun_nm + "','-','')\n";
        else if(gubun.equals("user_nm"))	subQuery = " and b.user_nm like '%" + gubun_nm + "%'\n";
        else if(gubun.equals("all"))	    subQuery = "";
        else	                            subQuery = "";
        
		if(gubun1.equals("1")){	

				query = " select a.*, b.user_nm, c.reply_cnt \n"
						+ " from know_how a, users b,(select know_how_id, count(0) as reply_cnt from KNOW_HOW_REPLY group by know_how_id) c \n"
						+ " where a.user_id=b.user_id(+) and a.know_how_st='1' \n"
						+ subQuery
						+ " and a.know_how_id=c.know_how_id(+)\n";

		}else if(gubun1.equals("2")){

				query = " select a.*, b.user_nm, c.reply_cnt \n"
						+ " from know_how a, users b,(select know_how_id, count(0) as reply_cnt from KNOW_HOW_REPLY group by know_how_id) c \n"
						+ " where a.user_id=b.user_id(+) and a.know_how_st='2' \n"
						+ subQuery
						+ " and a.know_how_id=c.know_how_id(+)\n";

		}else{

				query = " select a.*, b.user_nm, c.reply_cnt \n"
						+ " from know_how a, users b,(select know_how_id, count(0) as reply_cnt from KNOW_HOW_REPLY group by know_how_id) c \n"
						+ " where a.user_id=b.user_id(+) \n"
						+ subQuery
						+ " and a.know_how_id=c.know_how_id(+)\n";

		}

	    query = query  + " order by  a.reg_dt desc , a.KNOW_HOW_ID desc ";
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
			System.out.println("[Know_how_Database:Know_how_AllList]"+e);
			System.out.println("[Know_how_Database:Know_how_AllList]"+query);
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
	
	//공개범위에 따라   - agent : 1000 , 협력업체:8888
	public Vector Know_how_AllList(String gubun, String gubun_nm, String gubun1, String dept_id) {
		getConnection();
	    
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String subQuery = "";
		String query = "";
	
	    if(gubun.equals("title"))			subQuery = " and a.title like '%" + gubun_nm + "%'\n";
	    else if(gubun.equals("content"))	subQuery = " and a.content like '%" + gubun_nm + "%'\n";
	    else if(gubun.equals("current_month"))		subQuery = " AND a.reg_dt like to_char(sysdate,'YYYYMM')||'%' \n";
	    else if(gubun.equals("reg_dt"))		subQuery = " and a.reg_dt >= replace('" + gubun_nm + "','-','')\n";
	    else if(gubun.equals("user_nm"))	subQuery = " and b.user_nm like '%" + gubun_nm + "%'\n";
	    else if(gubun.equals("all"))	    subQuery = " AND a.reg_dt||a.title||a.content||b.user_nm LIKE '%" + gubun_nm + "%'\n ";
	    else	                            subQuery = "";
	    
	    query = " select a.*, b.user_nm, c.reply_cnt \n"
				+ " from know_how a, users b,(select know_how_id, count(0) as reply_cnt from KNOW_HOW_REPLY group by know_how_id) c \n"
				+ " where a.user_id=b.user_id(+) \n"
				+ subQuery
				+ " and a.know_how_id=c.know_how_id(+)\n";
	    
	    // 1:지식Q&A, 2:오픈지식 
	    if(!gubun1.equals("")) {
	    	if(gubun1.equals("1")) query += "  and a.know_how_st = '1' ";
    		if(gubun1.equals("2")) query += "  and (a.know_how_st = '2' or a.know_how_st IS NULL) ";
	    }
	    
	    //공개권한에 
	    if ( dept_id.equals("1000") ) { 
	    	query += "  and a.p_view in ( 'A', 'J' ) ";
	    } else if ( dept_id.equals("8888") ) { //협력업체
	    	query += "  and a.p_view in ( 'Y', 'J' ) ";
	    } 
	    
	    query += " order by  a.reg_dt desc , a.KNOW_HOW_ID desc ";
	    
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
			System.out.println("[Know_how_Database:Know_how_AllList]"+e);
			System.out.println("[Know_how_Database:Know_how_AllList]"+query);
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
     *  지식인 한건조회
     */

public Vector Know_how_View(int know_how_id, String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

				query =   " select a.*, b.user_nm "
						+ " from know_how a, users b"
						+ " where a.user_id = b.user_id and a.know_how_id = '"+know_how_id+"' and a.user_id = '"+user_id+"' ";

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
			System.out.println("[Know_how_Database:Know_how_View]"+e);
			System.out.println("[Know_how_Database:Know_how_View]"+query);
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

   
     public Know_howBean getKnowHowBean(int know_how_id) 
     {
        getConnection();
          
        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
         
       Know_howBean bean = new Know_howBean();         
      
        query =   " select a.* "
						+ " from know_how a"
						+ " where  a.know_how_id = '"+know_how_id+"' ";

        try {
            stmt = conn.createStatement();
            rs = stmt.executeQuery(query);
		
            if (rs.next()) {
	             bean.setKnow_how_id(rs.getInt("know_how_id"));
				    bean.setUser_id(rs.getString("user_id"));
				    bean.setReg_dt(rs.getString("reg_dt"));
				    bean.setTitle(rs.getString("title"));
				    bean.setContent(rs.getString("content"));
				    bean.setRead_chk(rs.getString("read_chk"));
				    bean.setKnow_how_st(rs.getString("know_how_st"));		
				    bean.setP_view(rs.getString("p_view"));		
 		     }
 		     
 			rs.close();
         stmt.close();
      	} catch (SQLException e) {
			System.out.println("[Know_how_Database:getKnowHowBean]"+e);
			System.out.println("[Know_how_Database:getKnowHowBean]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}
	}

    

	/**
     * 지식인 등록
     */

  public int insertKnow_how(Know_howBean bean) {
		getConnection();

        PreparedStatement pstmt = null;
		ResultSet rs = null;
		Statement stmt = null;
		int count = 0;
		String query = "";
		String query_seq = "";
		int know_how_id = 0;


 	  	query_seq = " select nvl(max(know_how_id)+1, 1) "
				   +" from know_how ";	
                   
            query="INSERT INTO know_how (know_how_id, user_id, reg_dt, title, content, know_how_st, p_view ) \n"
                + "values( ?, \n"
            	+ " ?,\n"
            	+ " to_char(sysdate,'YYYYMMDD'), \n"
            	+ " ?,\n"
            	+ " '"+bean.getContent().trim()+"',\n"
            	+ " ?, ? \n"
				+ " )";

try 
		{			
			conn.setAutoCommit(false);
			
  			stmt = conn.createStatement();
            rs = stmt.executeQuery(query_seq);
         
            if(rs.next())
            	know_how_id = rs.getInt(1);
            	
            rs.close();
			stmt.close();
				
			pstmt = conn.prepareStatement(query);

			pstmt.setInt   (1, know_how_id				);
			pstmt.setString(2, bean.getUser_id()		);
			pstmt.setString(3, bean.getTitle().trim()	);
			pstmt.setString(4, bean.getKnow_how_st()	);
			pstmt.setString(5, bean.getP_view()	); //공개범위

			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		} catch (SQLException e) {
			System.out.println("[Know_how_Database:insertKnow_how]\n"+e);
			System.out.println("[Know_how_Database:insertKnow_how]\n"+query);

			System.out.println("[know_how_id			]\n"+know_how_id			);
			System.out.println("[bean.getUser_id()		]\n"+bean.getUser_id()		);
			System.out.println("[bean.getTitle()		]\n"+bean.getTitle()		);
			System.out.println("[bean.getContent()		]\n"+bean.getContent()		);
			System.out.println("[bean.getKnow_how_st()	]\n"+bean.getKnow_how_st()	);

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

	 /**
     *  지식인 리플조회
     */

public Vector Know_how_RpView(int know_how_id, int know_how_seq, String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

				query =   " select a.*, b.user_nm "
						+ " from know_how_reply a, users b"
						+ " where a.user_id = b.user_id and a.know_how_id = '"+know_how_id+"'";

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
			System.out.println("[Know_how_Database:Know_how_RpView]"+e);
			System.out.println("[Know_how_Database:Know_how_RpView]"+query);
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
     * 지식인 리플 등록
     */

  public int insertKnow_howRp(Know_how_ReplyBean bean) {
		getConnection();

        PreparedStatement pstmt = null;
		ResultSet rs = null;
		Statement stmt = null;
		int count = 0;
		String query = "";
		String query_seq = "";
		int know_how_seq = 0;


 	  	query_seq = " select nvl(max(know_how_seq)+1, 1) "
				   +" from know_how_reply ";	
                   
            query="INSERT INTO know_how_reply (know_how_id, know_how_seq, user_id, reg_dt, reply_content)\n"
                + "values( ?, \n"
            	+ " ?,\n"
            	+ " ?,\n"
            	+ " to_char(sysdate,'YYYYMMDD'), \n"
            	+ " ? \n"
				+ " )";

try 
		{			
			conn.setAutoCommit(false);
			
  			stmt = conn.createStatement();
            rs = stmt.executeQuery(query_seq);
         
            if(rs.next())
            	know_how_seq = rs.getInt(1);
            rs.close();
			stmt.close();
				
			pstmt = conn.prepareStatement(query);

			pstmt.setInt   (1, bean.getKnow_how_id()	);
			pstmt.setInt   (2, know_how_seq				);
			pstmt.setString(3, bean.getUser_id()		);
			pstmt.setString(4, bean.getReply_content()	);


			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		} catch (SQLException e) {
			System.out.println("[Know_how_Database:insertKnow_howRp]\n"+e);
			System.out.println("[Know_how_Database:insertKnow_howRp]\n"+query);

			System.out.println("[bean.getKnow_how_id()		]\n"+bean.getKnow_how_id()		);
			System.out.println("[know_how_seq				]\n"+know_how_seq				);
			System.out.println("[bean.getUser_id()			]\n"+bean.getUser_id()			);
			System.out.println("[bean.getReply_content()	]\n"+bean.getReply_content()	);

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


	/**
     * 노하우 수정/삭제
     */

	public int UpdateKnow_how(Know_howBean bean){

		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";

            query = " update know_how set \n"+				
					" title	= ?,  \n"+
					" content	= '"+bean.getContent().trim()+"',  \n"+
					" know_how_st = ? , p_view = ? "+
					" where know_how_id=? and user_id=?  ";

		try 
		{		
			conn.setAutoCommit(false);	
		
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getTitle());
			pstmt.setString(2, bean.getKnow_how_st());
			pstmt.setString(3, bean.getP_view());
			pstmt.setInt(4, bean.getKnow_how_id());
			pstmt.setString(5, bean.getUser_id());

			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[Know_how_Database:UpdateKnow_how]\n"+e);
			System.out.println("[Know_how_Database:UpdateKnow_how]\n"+query);
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
     * 지식 삭제 
	*/

    public int DeleteKnow_how(Know_howBean bean) {
		getConnection();

		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";

		query = " DELETE  FROM know_how \n"+
				" where know_how_id=? and user_id=?  ";

	try {		
			conn.setAutoCommit(false);	
			pstmt = conn.prepareStatement(query);
			
			pstmt.setInt(1, bean.getKnow_how_id());
			pstmt.setString(2, bean.getUser_id());

			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[Know_how_Database:DeleteKnow_how]\n"+e);
			System.out.println("[Know_how_Database:DeleteKnow_how]\n"+query);
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

	/****************************************************************************************
	*******************************************   smart
    ****************************************************************************************/
	
	 /**
     *  지식인 한건조회
     */

public Vector Know_how_View(int know_how_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

				query =   " select a.*, b.user_nm, decode(b.dept_id, '0001', '영업팀', '0002', '고객지원팀', '0003', '총무팀', '0007', '부산지점', '0008', '대전지점') dept_nm "
						+ " from know_how a, users b"
						+ " where a.user_id = b.user_id and a.know_how_id = '"+know_how_id+"' ";


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
			System.out.println("[Know_how_Database:Know_how_View]"+e);
			System.out.println("[Know_how_Database:Know_how_View]"+query);
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


	public int getKnowHowCount()
	{
		getConnection();
		int count = 0;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
	
		query = " select nvl(max(know_how_id)+1, 1) " + 
				" from know_how ";
	
	
		try {
			pstmt = conn.prepareStatement(query);
	
	    	rs = pstmt.executeQuery();
		
			if(rs.next())
			{
				count = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
	
		} catch (SQLException e) {
			System.out.println("[Know_how_Database:getKnowHowCount()]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
	            if(rs != null)		rs.close();
	            if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}	
}
