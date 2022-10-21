package cust.board;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.client.*;
import acar.common.*;
import acar.cont.*;

public class BoardDatabase
{
	private Connection conn = null;
	public static BoardDatabase db;
	
	public static BoardDatabase getInstance()
	{
		if(BoardDatabase.db == null)
			BoardDatabase.db = new BoardDatabase();
		return BoardDatabase.db;	
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



	//공지사항---------------------------------------------------------------------------------------------------------


	//공지사항 갯수
	public int getBoardListCnt(String member_id, String gubun, String s_yy, String s_mm, String s_dd, String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int r_cnt = 0;
		String query = "";	

		query = " select count(0)"+
				" from board a, users b, member c, client d"+
				" where a.bbs_st='"+gubun+"'"+
				" and a.reg_id=b.user_id(+) and a.reg_id=c.member_id(+) and c.client_id=d.client_id(+)";

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
			System.out.println("[BoardDatabase:getBoardList]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return r_cnt;
		}
    }
    
    
    	//공지사항 리스트
	public Vector getBoardList(String member_id, String gubun, String s_yy, String s_mm, String s_dd, String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";	

		query = " select a.*, nvl(b.user_nm,'') user_nm, nvl(d.firm_nm,d.client_nm) firm_nm"+
				" from board a, users b, member c, client d"+
				" where a.bbs_st='"+gubun+"'"+
				" and a.reg_id=b.user_id(+) and a.reg_id=c.member_id(+) and c.client_id=d.client_id(+)";

		if(!member_id.equals(""))	query += " and (a.target = 'A' or a.target='"+member_id+"')";

		if(!s_yy.equals("") && !s_mm.equals(""))		query += " and a.reg_dt like '"+s_yy+s_mm+"%'";
		else if(!s_yy.equals("") && s_mm.equals(""))	query += " and a.reg_dt like '"+s_yy+"%'";

		if(!t_wd.equals("") && s_kd.equals("1")){		query += " and a.title||a.content like '%"+t_wd+"%'";
		}else if(!t_wd.equals("") && s_kd.equals("2")){	query += " and a.title like '%"+t_wd+"%'";
		}else if(!t_wd.equals("") && s_kd.equals("3")){	query += " and a.content like '%"+t_wd+"%'";
		}

		query += " ORDER BY a.ref desc";	

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
			System.out.println("[BoardDatabase:getBoardList]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }
    

	  	//공지사항 리스트
	public Vector getBoardList(String member_id, String gubun, String s_yy, String s_mm, String s_dd, String s_kd, String t_wd, int p_start, int p_page)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";	
		String query1 = "";	
      
		query1 = " select a.*, nvl(b.user_nm,'') user_nm, nvl(d.firm_nm,d.client_nm) firm_nm"+
				" from board a, users b, member c, client d"+
				" where a.bbs_st='"+gubun+"'"+
				" and a.reg_id=b.user_id(+) and a.reg_id=c.member_id(+) and c.client_id=d.client_id(+)";

		if(!member_id.equals(""))	query1 += " and (a.target = 'A' or a.target='"+member_id+"')";

		if(!s_yy.equals("") && !s_mm.equals(""))		query1 += " and a.reg_dt like '"+s_yy+s_mm+"%'";
		else if(!s_yy.equals("") && s_mm.equals(""))	query1 += " and a.reg_dt like '"+s_yy+"%'";

		if(!t_wd.equals("") && s_kd.equals("1")){		query1 += " and a.title||a.content like '%"+t_wd+"%'";
		}else if(!t_wd.equals("") && s_kd.equals("2")){	query1 += " and a.title like '%"+t_wd+"%'";
		}else if(!t_wd.equals("") && s_kd.equals("3")){	query1 += " and a.content like '%"+t_wd+"%'";
		}

		query1 += " ORDER BY a.ref desc  ";	
		
		query = " SELECT * FROM ( SELECT * FROM ( " + query1+ ") WHERE ROWNUM <=" + p_start + " ORDER BY ref DESC) WHERE ROWNUM <=" + p_page;

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
			System.out.println("[BoardDatabase:getBoardList]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }
    
    
	//건의함 관련글 리스트
	public Vector getBoardList(String bbs_st, int ref)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";	

		query = " select a.*, nvl(b.user_nm,'') user_nm, nvl(d.firm_nm,d.client_nm) firm_nm"+
				" from board a, users b, member c, client d"+
				" where a.bbs_st='"+bbs_st+"' and a.ref="+ref+
				" and a.reg_id=b.user_id(+) and a.reg_id=c.member_id(+) and c.client_id=d.client_id(+)";


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
			System.out.println("[BoardDatabase:getBoardList]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }

	//상세내역
	public BoardBean getBoardCase(String bbs_st, String bbs_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		BoardBean bean = new BoardBean();

		String query = "";	

		query = " select a.*, nvl(b.user_nm,'') user_nm, nvl(d.firm_nm,d.client_nm) firm_nm"+
				" from board a, users b, member c, client d"+
				" where a.bbs_st='"+bbs_st+"' and a.bbs_id='"+bbs_id+"'"+
				" and a.reg_id=b.user_id(+) and a.reg_id=c.member_id(+) and c.client_id=d.client_id(+)";
			
		try 
		{
			pstmt = conn.prepareStatement(query);
		    rs = pstmt.executeQuery();
            if(rs.next())
            {
			    bean.setBbs_st(rs.getString("bbs_st"));
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
			System.out.println("[BoardDatabase:getBoardCase]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}
    }

	//조회수 증가
    public void getHitAdd(String bbs_st, String bbs_id)
	{
		getConnection();
        
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
		query = " update board set hit=hit+1"+
				" where bbs_st='"+bbs_st+"' and bbs_id='"+bbs_id+"'";

        try{
            conn.setAutoCommit(false);
            pstmt = conn.prepareStatement(query);
            count = pstmt.executeUpdate();
			pstmt.close();
	  	} catch (Exception e) {
			System.out.println("[BoardDatabase:getHitAdd]\n"+e);
			e.printStackTrace();
		} finally {
			try{	
                if(pstmt != null) pstmt.close();
		        conn.commit();
			}catch(Exception ignore){}
			closeConnection();
		}
    }

	//board 등록
    public int insertBoard(BoardBean bean)
	{
		getConnection();
        
        PreparedStatement pstmt = null;
        PreparedStatement pstmt1 = null;
        ResultSet rs = null;
        String query = "";
        String query1 = "";
        String query2 = "";
		int bbs_id = 0;
        int count = 0;
                
		query = " insert into board (bbs_st, bbs_id, target, reg_id, reg_dt, email, title, content, hit, ref, re_level, re_step)"+
				" values (?, ?, ?, ?, to_char(sysdate,'YYYYMMDD'), ?, ?, ?, ?, ?, ?, ?)";

        query1 = " select nvl(max(bbs_id)+1,1) from board where bbs_st=?";
		
        try{
            conn.setAutoCommit(false);

			if(bean.getBbs_id() == 0){
				pstmt1 = conn.prepareStatement(query1);
				pstmt1.setString(1, bean.getBbs_st().trim());
				rs = pstmt1.executeQuery();
				if(rs.next())
				{
					bbs_id = rs.getInt(1);
			    }
				rs.close();
				pstmt1.close();
			}else{
				bbs_id = bean.getBbs_id();
			}

            pstmt = conn.prepareStatement(query);
			pstmt.setString(1, bean.getBbs_st().trim());
			pstmt.setInt(2, bbs_id);
			pstmt.setString(3, bean.getTarget().trim());
			pstmt.setString(4, bean.getReg_id().trim());
			pstmt.setString(5, bean.getEmail().trim());
			pstmt.setString(6, bean.getTitle().trim());
			pstmt.setString(7, bean.getContent().trim());
			pstmt.setInt(8, bean.getHit());
			if(bean.getRef() == 0){
				pstmt.setInt(9, bbs_id);
			}else{
				pstmt.setInt(9, bean.getRef());
			}
			pstmt.setInt(10, bean.getRe_level());
			pstmt.setInt(11, bean.getRe_step());
            count = pstmt.executeUpdate();
			pstmt.close();

	  	} catch (Exception e) {
			System.out.println("[BoardDatabase:insertBoard]\n"+e);
			e.printStackTrace();
		} finally {
			try{	
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
                if(pstmt1 != null) pstmt1.close();
		        conn.commit();
			}catch(Exception ignore){}
			closeConnection();
			return bbs_id;
		}
    }

	//board 수정
    public int updateBoard(BoardBean bean)
	{
		getConnection();
        
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
		query = " update board set email=?, title=?, content=? where bbs_st=? and bbs_id=?";
		
        try{
            conn.setAutoCommit(false);
            pstmt = conn.prepareStatement(query);
			pstmt.setString(1, bean.getEmail().trim());
			pstmt.setString(2, bean.getTitle().trim());
			pstmt.setString(3, bean.getContent().trim());
			pstmt.setString(4, bean.getBbs_st().trim());
			pstmt.setInt(5, bean.getBbs_id());
            count = pstmt.executeUpdate();
			pstmt.close();

	  	} catch (Exception e) {
			System.out.println("[BoardDatabase:updateBoard]\n"+e);
			e.printStackTrace();
		} finally {
			try{	
                if(pstmt != null) pstmt.close();
		        conn.commit();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
    }

	//board 순서 미루기
    public int changeSeq(String bbs_st, String bbs_id, int n_step, int n_seq)
	{
		getConnection();
        
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
		query = " update board set seq=seq+1 where bbs_st='"+bbs_st+"' and bbs_id="+bbs_id+" and seq >= "+n_seq+"";
		
		try{
            conn.setAutoCommit(false);
            pstmt = conn.prepareStatement(query);
            count = pstmt.executeUpdate();
			pstmt.close();

	  	} catch (Exception e) {
			System.out.println("[BoardDatabase:changeSeq]\n"+e);
			e.printStackTrace();
		} finally {
			try{	
                if(pstmt != null) pstmt.close();
		        conn.commit();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
    }
	//board 순서 미루기
    public int changeSeq(int ref, int re_step)
	{
		getConnection();
        
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
		query = " UPDATE board SET re_step=re_step+1 WHERE ref="+ref+" and re_step > "+re_step;
		
		try{
            conn.setAutoCommit(false);
            pstmt = conn.prepareStatement(query);
            count = pstmt.executeUpdate();
			pstmt.close();

	  	} catch (Exception e) {
			System.out.println("[BoardDatabase:changeSeq2]\n"+e);
			e.printStackTrace();
		} finally {
			try{	
                if(pstmt != null) pstmt.close();
		        conn.commit();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
    }

	//board 마지막 순서
    public int getMaxSeq(String bbs_st, String bbs_id, int step)
	{
		getConnection();
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
		int seq = 0;
                
        query = " select nvl(max(seq)+1,1) from board where bbs_st='"+bbs_st+"' and bbs_id="+bbs_id+" and step="+step;

        try{
            conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			if(rs.next())
			{
				seq = rs.getInt(1);
		    }
			rs.close();
			pstmt.close();
	  	} catch (Exception e) {
			System.out.println("[BoardDatabase:getMaxSeq]\n"+e);
			e.printStackTrace();
		} finally {
			try{	
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
		        conn.commit();
			}catch(Exception ignore){}
			closeConnection();
			return seq;
		}
    }
}
