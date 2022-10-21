/**
 * 고객제안함
 * @ author : Gill Sun Ryu
 * @ e-mail : gillsun@empal.com
 * @ create date : 2010. 06. 01
 * @ last modify date : 
 */

package acar.m_bbs;

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

public class M_bbs_Database
{
	private Connection conn = null;
	public static M_bbs_Database db;
	
	public static M_bbs_Database getInstance()
	{
		if(M_bbs_Database.db == null)
			M_bbs_Database.db = new M_bbs_Database();
		return M_bbs_Database.db;
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



 	//공지사항 리스트
	public Vector getM_bbs_List(String member_id, String gubun, String s_yy, String s_mm, String s_dd, String s_kd, String t_wd, int p_start, int p_page)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";	
		String query1 = "";	
      
		query = " select a.*, nvl(b.user_nm,'') user_nm, nvl(d.firm_nm,d.client_nm) firm_nm"+
				" from m_bbs a, users b, member c, client d"+
				" where a.reg_id=b.user_id(+) and a.reg_id=c.member_id(+) and a.reg_id=d.client_id(+)";

		if(!member_id.equals(""))	query += " and (a.target = 'A' or a.target='"+member_id+"')";

		if(!s_yy.equals("") && !s_mm.equals(""))				query += " and a.reg_dt like '"+s_yy+s_mm+"%'";
		else if(!s_yy.equals("") && s_mm.equals(""))			query += " and a.reg_dt like '"+s_yy+"%'";

		if(!t_wd.equals("") && s_kd.equals("1")){				query += " and a.title||a.content like '%"+t_wd+"%'";
		}else if(!t_wd.equals("") && s_kd.equals("2")){			query += " and a.title like '%"+t_wd+"%'";
		}else if(!t_wd.equals("") && s_kd.equals("3")){			query += " and a.content like '%"+t_wd+"%'";
		}else if(s_kd.equals("c_year")){						query += " and a.reg_dt like to_char(sysdate,'YYYY')||'%'";
		}else if(s_kd.equals("c_mon")){							query += " and a.reg_dt like to_char(sysdate,'YYYYMM')||'%'";
		}else if(!t_wd.equals("") && s_kd.equals("title")){		query += " and a.title||a.content like '%"+t_wd+"%'";
		}else if(!t_wd.equals("") && s_kd.equals("name")){		query += " and b.user_nm like '%"+t_wd+"%'";
		}else if(!t_wd.equals("") && s_kd.equals("reg_dt")){	query += " and a.reg_dt like replace('"+t_wd+"','-','')||'%'";
		}

		query += " ORDER BY a.ref desc  ";	
		
		try 
		{
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
			System.out.println("[M_bbs_Database:getM_bbs_List]\n"+e);
			System.out.println("[M_bbs_Database:getM_bbs_List]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )			rs.close();
				if(pstmt != null )		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }
    	
//공지사항 갯수
	public int getM_bbs_cnt(String member_id, String gubun, String s_yy, String s_mm, String s_dd, String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int r_cnt = 0;
		String query = "";	

		query = " select count(0)"+
				" from m_bbs_comment a, users b, member c, client d"+
				" where a.reg_id=b.user_id(+) and a.reg_id=c.member_id(+) and c.client_id=d.client_id(+)";

		if(!member_id.equals(""))	query += " and (a.target = 'A' or a.target='"+member_id+"')";

		if(!s_yy.equals("") && !s_mm.equals(""))		query += " and a.reg_dt like '"+s_yy+s_mm+"%'";
		else if(!s_yy.equals("") && s_mm.equals(""))	query += " and a.reg_dt like '"+s_yy+"%'";

		if(!t_wd.equals("") && s_kd.equals("1")){		query += " and a.title||a.content like '%"+t_wd+"%'";
		}else if(!t_wd.equals("") && s_kd.equals("2")){	query += " and a.title like '%"+t_wd+"%'";
		}else if(!t_wd.equals("") && s_kd.equals("3")){	query += " and a.content like '%"+t_wd+"%'";
		}

		
		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		if(rs.next())
			{
				r_cnt = rs.getInt(1);
		    }
			rs.close();
			pstmt.close();
		    
		} catch (SQLException e) {
			System.out.println("[M_bbs_Database:getM_bbs_cnt]\n"+e);
			System.out.println("[M_bbs_Database:getM_bbs_cnt]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )			rs.close();
				if(pstmt != null )		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return r_cnt;
		}
    }

	 /**
     *   한건조회
     */

	public M_bbsBean getM_bbs_view(String bbs_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		M_bbsBean bean = new M_bbsBean();

		String query = "";	

		query = " select a.*, nvl(b.user_nm,'') user_nm, nvl(d.firm_nm,d.client_nm) firm_nm, b.user_email, d.CLIENT_NM, d.FIRM_NM, d.HOMEPAGE as email "+
				" from m_bbs a, users b, member c, client d"+
				" where  a.bbs_id="+bbs_id+
				" and a.reg_id=b.user_id(+) and a.reg_id=c.member_id(+) and a.REG_ID = d.client_id(+)";
			

		try 
		{
			pstmt = conn.prepareStatement(query);
		    rs = pstmt.executeQuery();
            if(rs.next())
            {
				bean.setBbs_id(rs.getInt("bbs_id"));
				bean.setTarget(rs.getString("target"));
				bean.setReg_id(rs.getString("reg_id"));
				bean.setReg_dt(rs.getString("reg_dt"));
				bean.setEmail(rs.getString("email")==null?"":rs.getString("email"));
			    bean.setTitle(rs.getString("title"));
			    bean.setContent(rs.getString("content"));
			    bean.setHit(rs.getInt("hit"));
			    bean.setUser_nm(rs.getString("user_nm")==null?"":rs.getString("user_nm"));
				bean.setFirm_nm(rs.getString("firm_nm")==null?"":rs.getString("firm_nm"));
				bean.setRef(rs.getInt("ref"));
				bean.setRe_level(rs.getInt("re_level"));
				bean.setRe_step(rs.getInt("re_step"));
            }
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[BoardDatabase:getBoardCase]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )			rs.close();
				if(pstmt != null )		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}
    }



	/**
     *  등록
     */

  public int insertM_bbs(M_bbsBean bean)
 	{
		getConnection();
        
        PreparedStatement pstmt = null;
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        ResultSet rs = null;
        String query = "";
        String query1 = "";
        String query2 = "";
		int bbs_id = 0;
        int count = 0;
                
		query = " insert into m_bbs ( bbs_id, target, reg_id, reg_dt, email, title, content, hit, ref, re_level, re_step)"+
				" values ( ?, ?, ?, to_char(sysdate,'YYYYMMDD'), ?, ?, ?, ?, ?, ?, ?)";

        query1 = " select nvl(max(bbs_id)+1,1) from m_bbs";
		
        try{
            conn.setAutoCommit(false);

			if(bean.getBbs_id() == 0){
				pstmt1 = conn.prepareStatement(query1);
				rs = pstmt1.executeQuery();
				if(rs.next())
				{
					bbs_id = rs.getInt(1);
			    }
			}else{
				bbs_id = bean.getBbs_id();
			}

            pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, bbs_id);
			pstmt.setString(2, bean.getTarget().trim());
			pstmt.setString(3, bean.getReg_id().trim());
			pstmt.setString(4, bean.getEmail().trim());
			pstmt.setString(5, bean.getTitle().trim());
			pstmt.setString(6, bean.getContent().trim());
			pstmt.setInt(7, bean.getHit());
			if(bean.getRef() == 0){
				pstmt.setInt(8, bbs_id);
			}else{
				pstmt.setInt(8, bean.getRef());
			}
			pstmt.setInt(9, bean.getRe_level());
			pstmt.setInt(10, bean.getRe_step());
            count = pstmt.executeUpdate();

			rs.close();
			pstmt1.close();
			pstmt.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[M_bbs_Database:insertBoard]\n"+e);
			System.out.println("[M_bbs_Database:insertBoard]\n"+query);
			e.printStackTrace();
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(rs != null)	rs.close();
				if(pstmt1 != null)	pstmt1.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bbs_id;
		}
    }

	 /**
     *   리플조회
     */

public Vector getM_bbs_cmt(String bbs_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";	

		query = " select a.reg_id, a.reg_dt, a.reply_content as content, nvl(b.user_nm,'') user_nm, nvl(d.firm_nm,d.client_nm) firm_nm"+
				" from m_bbs_comment a, users b, member c, client d"+
				" where a.bbs_id= '"+bbs_id+"' "+
				" and a.reg_id=b.user_id(+) and a.reg_id=c.member_id(+) and c.client_id=d.client_id(+)";

		query += " ORDER BY a.bbs_seq ";	


		try 
		{
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
		} catch (SQLException e) {
			System.out.println("[M_bbs_Database:getM_bbs_cmt]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				rs.close();
				pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }


	/**
     * 지식인 리플 등록
     */

  public int insertM_bbs_Rp(M_bbs_ReplyBean bean) {
		getConnection();

        PreparedStatement pstmt = null;
		ResultSet rs = null;
		Statement stmt = null;
		int count = 0;
		String query = "";
		String query_seq = "";
		int bbs_seq = 0;


 	  	query_seq = " select nvl(max(bbs_seq)+1, 1) "
				   +" from M_BBS_COMMENT where bbs_id = '"+bean.getBbs_id()+"' ";	
                   
            query="INSERT INTO M_BBS_COMMENT (bbs_id, bbs_seq, reg_id, reg_dt, reply_content)\n"
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
            	bbs_seq = rs.getInt(1);
            rs.close();
			stmt.close();
				
			pstmt = conn.prepareStatement(query);

			pstmt.setInt   (1, bean.getBbs_id()	);
			pstmt.setInt   (2, bbs_seq				);
			pstmt.setString(3, bean.getReg_id()		);
			pstmt.setString(4, bean.getReply_content()	);


			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		} catch (SQLException e) {
			System.out.println("[M_bbs_Database:insertM_bbs_Rp]\n"+e);
			System.out.println("[M_bbs_Database:insertM_bbs_Rp]\n"+query);
			System.out.println("[bean.getBbs_id()		]\n"+bean.getBbs_id()		);
			System.out.println("[bbs_seq				]\n"+bbs_seq				);
			System.out.println("[bean.getReg_id()			]\n"+bean.getReg_id()			);
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
     * 지식 삭제 
	*/

    public int DeleteM_bbs_Rp(M_bbs_ReplyBean bean) {
		getConnection();

		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";

		query = " DELETE  FROM m_bbs_comment \n"+
				" where bbs_id=? and reg_id=? and bbs_seq =?  ";

	try {		
			conn.setAutoCommit(false);	
			pstmt = conn.prepareStatement(query);
			
			pstmt.setInt(1, bean.getBbs_id());
			pstmt.setString(2, bean.getReg_id());
			pstmt.setInt(3, bean.getBbs_seq());

			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[M_bbs_Database:DeleteKnow_how]\n"+e);
			System.out.println("[M_bbs_Database:DeleteKnow_how]\n"+query);
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


//조회수 증가
    public void getHitAdd(String bbs_id)
	{
		getConnection();
        
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
		query = " update m_bbs set hit=hit+1"+
				" where bbs_id='"+bbs_id+"'";

        try{
			conn.setAutoCommit(false);

            pstmt = conn.prepareStatement(query);
            count = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[M_bbs_Database:getHitAdd]\n"+e);
			System.out.println("[M_bbs_Database:getHitAdd]\n"+query);
			e.printStackTrace();
//			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
		}
    }




}
