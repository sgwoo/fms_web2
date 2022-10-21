
package acar.mrent_bbs;

import java.util.*;
import java.sql.*;
import acar.util.*;
import java.text.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.UnknownDataException;
import acar.exception.DatabaseException;


public class Mrent_BbsDatabase
{
	private Connection conn = null;
	public static Mrent_BbsDatabase db;
	public static Mrent_BbsDatabase getInstance()
	{
		if(Mrent_BbsDatabase.db == null)
			Mrent_BbsDatabase.db = new Mrent_BbsDatabase();
		return Mrent_BbsDatabase.db;
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



public int insertMbbs(MrentBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";

		query = " insert into MRENT_BBS \n"+
				" (bbs_id, reg_nm, tel, reg_dt, title, content, bbs_st \n"+
				" ) values ("+
				" (SELECT nvl(max(BBS_ID)+1,1) FROM mrent_bbs), ?, ?, replace(?,'-',''), ?, ?, ?"+
				" )";		


		try 
		{			
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getReg_nm());
			pstmt.setString(2, bean.getTel());
			pstmt.setString(3, bean.getReg_dt());
			pstmt.setString(4, bean.getTitle());
			pstmt.setString(5, bean.getContent());
			pstmt.setString(6, bean.getBbs_st());
			
			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[Mrent_BbsDatabase:insertMbbs]\n"+e);
			System.out.println("[Mrent_BbsDatabase:1]\n"+bean.getReg_nm());
			System.out.println("[Mrent_BbsDatabase:2]\n"+bean.getTel());
			System.out.println("[Mrent_BbsDatabase:3]\n"+bean.getReg_dt());
			System.out.println("[Mrent_BbsDatabase:4]\n"+bean.getTitle());
			System.out.println("[Mrent_BbsDatabase:5]\n"+bean.getContent());
			System.out.println("[Mrent_BbsDatabase:6]\n"+bean.getBbs_st());
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
	 *	고객별 call 허용리스트- 정비 (홈페이지)
	 */

	public Vector ViewListAll()
    {
       	getConnection();
        
        Statement stmt = null;
        ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";
   		
        query = " select bbs_id, substr(reg_nm, 1, 1) || '****' as user_nm, reg_dt, tel, title, content, bbs_st from mrent_bbs order by reg_dt desc ";				
				
        try{
            stmt = conn.createStatement();
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
			System.out.println("[Mrent_BbsDatabase:getContCallAll]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}
	

//공지사항 갯수
	public int getMrent_bbs_cnt(String member_id, String gubun, String s_yy, String s_mm, String s_dd, String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int r_cnt = 0;
		String query = "";	

		query = " select count(0)"+
				" from mrent_bbs_comment a, users b, member c, client d"+
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
			System.out.println("[Mrent_BbsDatabase:getMrent_bbs_cnt]\n"+e);
			System.out.println("[Mrent_BbsDatabase:getMrent_bbs_cnt]\n"+query);
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

	public MrentBean getM_bbs_view(String bbs_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		MrentBean bean = new MrentBean();

		String query = "";	

		query = " select * "+
				" from mrent_bbs"+
				" where  bbs_id='"+bbs_id+"' ";
			
		try 
		{
			pstmt = conn.prepareStatement(query);
		    rs = pstmt.executeQuery();
            if(rs.next())
            {
				bean.setBbs_id(rs.getInt("bbs_id"));
				bean.setReg_nm(rs.getString("reg_nm"));
				bean.setReg_dt(rs.getString("reg_dt"));
				bean.setTel(rs.getString("tel"));
			    bean.setTitle(rs.getString("title"));
			    bean.setContent(rs.getString("content"));
				bean.setBbs_st(rs.getString("bbs_st"));
            }
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[Mrent_BbsDatabase:getM_bbs_view]\n"+e);
			System.out.println("[Mrent_BbsDatabase:getM_bbs_view]\n"+query);
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


public Vector getM_bbs_cmt(String bbs_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";	

		query = " select a.BBS_ID, a.REG_ID, a.REG_DT, a.BBS_ST, a.CONTENT, a.COM_ST, a.SEQ, nvl(b.user_nm,'') user_nm "+
				" from mrent_bbs_comment a, users b"+
				" where a.bbs_id= '"+bbs_id+"' "+
				" and a.reg_id=b.user_id(+) ";

		query += " ORDER BY a.seq ";	

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
			System.out.println("[Mrent_BbsDatabase:getM_bbs_cmt]\n"+e);
			System.out.println("[Mrent_BbsDatabase:getM_bbs_cmt]\n"+query);
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

/**
     * 지식인 리플 등록
     */

  public int insertM_bbs_Rp(Mrent_BbsCommentBean bean) {
		getConnection();

        PreparedStatement pstmt = null;
		ResultSet rs = null;
		Statement stmt = null;
		int count = 0;
		String query = "";
		String query_seq = "";
		int seq = 0;


 	  	query_seq = " select nvl(max(seq)+1, 1) "
				   +" from MRENT_BBS_COMMENT where bbs_id = '"+bean.getBbs_id()+"' ";	
                   
            query="INSERT INTO MRENT_BBS_COMMENT (bbs_id, seq, reg_id, reg_dt, content, bbs_st, com_st)\n"
                + "values( ?, \n"
            	+ " ?,\n"
            	+ " ?,\n"
            	+ " to_char(sysdate,'YYYYMMDD'), \n"
            	+ " ?, \n"
            	+ " ?, \n"
            	+ " ? \n"
				+ " )";

try 
		{			
			conn.setAutoCommit(false);
			
  			stmt = conn.createStatement();
            rs = stmt.executeQuery(query_seq);
         
            if(rs.next())
            	seq = rs.getInt(1);
            rs.close();
			stmt.close();
				
			pstmt = conn.prepareStatement(query);

			pstmt.setInt   (1, bean.getBbs_id()	);
			pstmt.setInt   (2, seq				);
			pstmt.setString(3, bean.getReg_id()		);
			pstmt.setString(4, bean.getContent()	);
			pstmt.setString(5, bean.getBbs_st()	);
			pstmt.setString(6, bean.getCom_st()	);


			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		} catch (SQLException e) {
			System.out.println("[M_bbs_Database:insertM_bbs_Rp]\n"+e);
			System.out.println("[M_bbs_Database:insertM_bbs_Rp]\n"+query);
			System.out.println("[bean.getBbs_id()		]\n"+bean.getBbs_id()		);
			System.out.println("[bbs_seq				]\n"+seq				);
			System.out.println("[bean.getReg_id()			]\n"+bean.getReg_id()			);
			System.out.println("[bean.getReply_content()	]\n"+bean.getContent()	);

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









}
