package cust.member;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.client.*;
import acar.common.*;
import acar.cont.*;

public class MemberDatabase
{
	private Connection conn = null;
	public static MemberDatabase db;
	
	public static MemberDatabase getInstance()
	{
		if(MemberDatabase.db == null)
			MemberDatabase.db = new MemberDatabase();
		return MemberDatabase.db;	
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
		}		
	}

	//영업담당자 리스트
	public Vector getUserList(String br_id, String gubun, String use_yn)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";	
		String sub_qu = "";

		if(!use_yn.equals("")) sub_qu += " where use_yn='"+use_yn+"'";
		if(!br_id.equals("S1") && !br_id.equals("")) sub_qu += " and brch_id='"+br_id+"'";
		
		query = " select b.user_id, b.user_nm from"+ 
				" (select "+gubun+", count(0) from cont "+sub_qu+" group by "+gubun+") a, users b where a."+gubun+"=b.user_id"+ 
				" order by b.dept_id, b.user_id";


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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim()/**/);
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[MemberDatabase:getUserList]\n"+e);
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
	
//계약현황 상세내역-고객아이디로 조회
	public MemberBean getMemberCase(String member_id, String pw)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		MemberBean bean = new MemberBean();
		String query = "";		

		query = "select * from member WHERE member_id = '" + member_id.trim() + "' and text_decrypt(pwd, 'pw') = '" + pw.trim() + "'";

		try 
		{
			pstmt = conn.prepareStatement(query);
		 	   rs = pstmt.executeQuery();
		            if(rs.next())
		            {
						bean.setClient_id(rs.getString("CLIENT_ID"));
						bean.setR_site(rs.getString("R_SITE"));
						bean.setMember_id(member_id);
				
		            }
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[MemberDatabase:getNoMemberCase]\n"+e);
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
    
    
	//계약현황 상세내역-고객아이디로 조회
	public MemberBean getMemberCase(String client_id, String r_site, String member_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		MemberBean bean = new MemberBean();
		String query = "";		

       	query = " select "
       			+ " a.IDX,\n"
    			+ " a.CLIENT_ID,\n"
    			+ " a.R_SITE,\n"
    			+ " a.MEMBER_ID,\n"
    			+ " text_decrypt(a.PWD, 'pw') PWD,\n"
    			+ " a.USE_YN,\n"
    			+ " a.EMAIL,\n"
    			+ " a.REG_DT,\n"
    			+ " a.UPDATE_DT,\n"
    			+ " b.firm_nm, b.client_nm, c.r_site as r_site_nm"+
				" from member a, client b, client_site c"+
				" where a.client_id=b.client_id and a.client_id=c.client_id(+) and a.r_site=c.seq(+) and a.use_yn='Y'";
		
		if(!client_id.equals(""))	query += " and a.client_id='"+client_id+"'";
		if(!member_id.equals(""))	query += " and a.member_id='"+member_id+"'";

		try 
		{
			pstmt = conn.prepareStatement(query);
		    rs = pstmt.executeQuery();
            if(rs.next())
            {
			    bean.setIdx(rs.getString("IDX"));
				bean.setClient_id(rs.getString("CLIENT_ID"));
				bean.setR_site(rs.getString("R_SITE"));
				bean.setMember_id(rs.getString("MEMBER_ID"));
				bean.setPwd(rs.getString("PWD"));
				bean.setUse_yn(rs.getString("USE_YN"));
				bean.setEmail(rs.getString("EMAIL")==null?"":rs.getString("EMAIL"));
			    bean.setReg_dt(rs.getString("REG_DT"));
			    bean.setUpdate_dt(rs.getString("UPDATE_DT"));
			    bean.setFirm_nm(rs.getString("FIRM_NM"));
			    bean.setClient_nm(rs.getString("CLIENT_NM"));
				bean.setR_site_nm(rs.getString("R_SITE_NM")==null?"":rs.getString("R_SITE_NM"));
            }
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[MemberDatabase:getMemberCase]\n"+e);
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

	//계약현황 상세내역-고객아이디로 조회
	public MemberBean getNoMemberCase(String client_id, String r_site, String member_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		MemberBean bean = new MemberBean();
		String query = "";		

       	query = " select b.client_id, c.seq r_site, b.firm_nm, b.client_nm, c.r_site as r_site_nm,"+
//				" decode(b.client_st,'2', substr(TEXT_DECRYPT(b.ssn, 'pw' ) ,7)||substr(TEXT_DECRYPT(b.ssn, 'pw' ) ,1,6), b.enp_no) pw"+
				" decode(b.client_st,'2', b.firm_nm||substr(text_decrypt(b.ssn, 'pw') ,0, 6), b.enp_no) pw"+
				" from client b, client_site c"+
				" where b.client_id=c.client_id(+)";
		
		if(!client_id.equals(""))	query += " and b.client_id='"+client_id+"'";
		if(!r_site.equals(""))		query += " and c.seq='"+r_site+"'";

		try 
		{
			pstmt = conn.prepareStatement(query);
		    rs = pstmt.executeQuery();
            if(rs.next())
            {
				bean.setClient_id(rs.getString("CLIENT_ID"));
				bean.setR_site(rs.getString("R_SITE"));
				bean.setMember_id(member_id);
			    bean.setFirm_nm(rs.getString("FIRM_NM"));
			    bean.setClient_nm(rs.getString("CLIENT_NM"));
				bean.setR_site_nm(rs.getString("R_SITE_NM")==null?"":rs.getString("R_SITE_NM"));
				bean.setPwd(rs.getString("pw")==null?"":rs.getString("pw"));
            }
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[MemberDatabase:getNoMemberCase]\n"+e);
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


	//로그인 아이디 중복 체크
    public int checkMemberId(String member_id)
	{
		getConnection();
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        int count = 0;
                
		query = " select count(0) from member where member_id='"+member_id+"'";
		
        try{
			pstmt = conn.prepareStatement(query);
		    rs = pstmt.executeQuery();
            if(rs.next())
            {
			    count = rs.getInt(1);
            }
			rs.close();
			pstmt.close();
	  	} catch (Exception e) {
			System.out.println("[MemberDatabase:checkMemberId]\n"+e);
			e.printStackTrace();
		} finally {
			try{	
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
		        conn.commit();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
    }

	//회원 실명확인
    public int checkMemberSsn(String name, String ssn)
	{
		getConnection();
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        int count = 0;
                
		query = " select count(0) from client"+
				" where (firm_nm like '%"+name+"%' or client_nm like '%"+name+"%') and (TEXT_DECRYPT(ssn, 'pw' )  like '%"+ssn+"%' or enp_no like '%"+ssn+"%')";
		
        try{
			pstmt = conn.prepareStatement(query);
		    rs = pstmt.executeQuery();
            if(rs.next())
            {
			    count = rs.getInt(1);
            }
			rs.close();
			pstmt.close();
	  	} catch (Exception e) {
			System.out.println("[MemberDatabase:checkMemberSsn]\n"+e);
			e.printStackTrace();
		} finally {
			try{	
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
		        conn.commit();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
    }

	//회원정보 수정
    public int updateMember(MemberBean bean)
	{
		getConnection();
        
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;

        query = " UPDATE member SET member_id=?, pwd=text_encrypt(?, 'pw'), email=?, update_dt=to_char(sysdate,'YYYYMMDD')"+
				" WHERE idx=? and client_id=?";

        try{
            conn.setAutoCommit(false);
            pstmt = conn.prepareStatement(query);
			pstmt.setString(1, bean.getMember_id().trim());
			pstmt.setString(2, bean.getPwd().trim());
			pstmt.setString(3, bean.getEmail().trim());
			pstmt.setString(4, bean.getIdx());
			pstmt.setString(5, bean.getClient_id().trim());
            count = pstmt.executeUpdate();
			pstmt.close();
            conn.commit();
            
	  	} catch (Exception e) {
			System.out.println("[MemberDatabase:updateMember]\n"+e);
			e.printStackTrace();
			conn.rollback();
		} finally {
			try{	
	            if(pstmt != null) pstmt.close();
		        conn.setAutoCommit(true);	
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
    }


	//회원관리 리스트
	public Vector getMemberList(String s_gubun1, String s_gubun2, String s_gubun3, String s_gubun4)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";	

		query = " select a.client_id, decode(a.client_st,'1','법인','2','개인','개인사업자') client_st,"+
				" a.client_nm, nvl(a.firm_nm,a.client_nm) firm_nm, c.r_site r_site_nm,"+
				" b.r_site, b.member_id, text_decrypt(b.pwd, 'pw') pwd, b.email, nvl(d.y_cnt,0) y_cnt, nvl(e.n_cnt,0) n_cnt,"+
				" decode(a.client_st,'2', substr(TEXT_DECRYPT(a.ssn, 'pw' ) ,7), substr(a.enp_no,6)) pw"+
				" from client a, member b, client_site c,"+
				" (select client_id, count(0) y_cnt from cont where use_yn='Y' group by client_id) d,"+
				" (select client_id, count(0) n_cnt from cont where use_yn='N' group by client_id) e"+
				" where a.client_id=b.client_id(+)"+
				" and b.client_id=c.client_id(+) and b.r_site=c.seq(+)"+
				" and a.client_id=d.client_id(+) and a.client_id=e.client_id(+)";

		if(s_gubun1.equals("Y"))		query += " and nvl(d.y_cnt,0) > 0";
		else if(s_gubun1.equals("N"))	query += " and nvl(d.y_cnt,0) = 0 and nvl(e.n_cnt,0) > 0";

		if(s_gubun2.equals("1"))		query += " and a.client_st='1'";
		else if(s_gubun2.equals("2"))	query += " and a.client_st='2'";
		else if(s_gubun2.equals("3"))	query += " and a.client_st in ('3','4','5')";

		if(!s_gubun3.equals(""))		query += " and a.firm_nm||a.client_nm like '%"+s_gubun3+"%'";

		if(!s_gubun4.equals(""))		query += " and c.r_site like '%"+s_gubun4+"%'";

		query += " ORDER BY decode(a.client_st,'1','1','2','2','3'), a.firm_nm||a.client_nm";	

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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim()/**/);
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[MemberDatabase:getMemberList]\n"+e);
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

	//회원관리 리스트
	public Vector getMemberList(String s_gubun1, String s_gubun2, String s_gubun3, String s_gubun4, String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_qu = "";
		
		if(s_gubun3.equals("")){

			query = " select a.client_id, decode(a.client_st,'1','법인','2','개인','개인사업자') client_st, \n"+
					" nvl(a.firm_nm,a.client_nm) firm_nm, a.client_nm, nvl(c.r_site,'-') as r_site_nm, b.r_site, b.member_id, text_decrypt(b.pwd, 'pw') pwd, b.email, \n"+
					" decode(c.r_site,'',nvl(d.y_cnt,'0'),nvl(e.y_cnt,'0')) y_cnt, \n"+
					" decode(a.client_st,'2', substr(TEXT_DECRYPT(a.ssn, 'pw' ) ,7), a.enp_no) pw, '' bus_id2 , b.use_yn , b.idx  \n"+
					" from client a, member b, client_site c, \n"+
					" (select client_id, count(0) y_cnt from cont where use_yn='Y' group by client_id) d, \n"+
					" (select client_id, r_site, count(0) y_cnt from cont where use_yn='Y' group by client_id, r_site) e  \n"+
					" where a.client_id=b.client_id(+) \n"+
					" and b.client_id=c.client_id(+) and b.r_site=c.seq(+) \n"+
					" and a.client_id=d.client_id(+)  \n"+
					" and b.client_id=e.client_id(+) and b.r_site=e.r_site(+) and a.firm_nm not like '%아마존%'";
		}else{

			if(!s_gubun1.equals("")) sub_qu += " where use_yn='"+s_gubun1+"'";
		
			query = " select a.client_id, decode(a.client_st,'1','법인','2','개인','개인사업자') client_st, \n"+
					" nvl(a.firm_nm,a.client_nm) firm_nm, a.client_nm, nvl(c.r_site,'-') as r_site_nm, b.r_site, b.member_id, text_decrypt(b.pwd, 'pw') pwd, b.email,  \n"+
					" decode(c.r_site,'',nvl(d.y_cnt,'0'),nvl(e.y_cnt,'0')) y_cnt, \n"+
					" decode(a.client_st,'2', substr(a.ssn,7), substr(a.enp_no,6)) pw, f.bus_id2, b.use_yn , b.idx  \n"+
					" from client a, member b, client_site c, \n"+
					" (select client_id, count(0) y_cnt from cont where use_yn='Y' group by client_id) d,"+
					" (select client_id, r_site, count(0) y_cnt from cont where use_yn='Y' group by client_id, r_site) e, \n"+
					" (select client_id, bus_id2 from cont "+sub_qu+" group by client_id, bus_id2) f  \n"+
					" where a.client_id=b.client_id(+)  \n"+
					" and b.client_id=c.client_id(+) and b.r_site=c.seq(+)  \n"+
					" and a.client_id=d.client_id(+) \n"+
					" and b.client_id=e.client_id(+) and b.r_site=e.r_site(+) \n"+
					" and b.client_id=f.client_id(+) and a.firm_nm not like '%아마존%' \n"+
					" and f.bus_id2='"+s_gubun3+"'";
		}

		if(s_gubun1.equals("Y"))		query += " and decode(c.r_site,'',nvl(d.y_cnt,'0'),nvl(e.y_cnt,'0')) <> '0'";
		else if(s_gubun1.equals("N"))	query += " and decode(c.r_site,'',nvl(d.y_cnt,'0'),nvl(e.y_cnt,'0')) = '0'";

		if(s_gubun2.equals("1"))		query += " and a.client_st='1'";
		else if(s_gubun2.equals("2"))	query += " and a.client_st='2'";
		else if(s_gubun2.equals("3"))	query += " and a.client_st in ('3','4','5')";

		if(s_kd.equals("1"))		query += " and a.firm_nm||a.client_nm like '%"+t_wd+"%'";
		else if(s_kd.equals("2"))	query += " and a.client_nm like '%"+t_wd+"%'";
		else if(s_kd.equals("3"))	query += " and b.member_id like '%"+t_wd+"%'";

		query +=" ORDER BY decode(b.member_id,'','3','amazoncar','2','1'), decode(a.client_st,'1','1','2','2','3'), a.firm_nm||a.client_nm, b.idx";


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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim()/**/);
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[MemberDatabase:getMemberList]\n"+e);
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

	//회원관리 등록
    public void insertMember(String client_id, String r_site, String member_id, String pw)
	{
		getConnection();
        
        PreparedStatement pstmt = null;
        PreparedStatement pstmt1 = null;
        ResultSet rs = null;
        String query = "";
        String query1 = "";
		int idx = 0;
        int count = 0;
		if(member_id.equals("")) member_id="amazoncar";
                
		query = " insert into member(idx, client_id, r_site, member_id, pwd, use_yn, reg_dt)"+
				" values (?,?,?,?,text_encrypt(?, 'pw'),?,to_char(sysdate,'YYYYMMDD'))";

        query1 = " select nvl(max(idx)+1,1) from member";
		
        try{
            conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query1);
			rs = pstmt1.executeQuery();
            if(rs.next())
			{
				idx = rs.getInt(1);
            }
			rs.close();
			pstmt1.close();

            pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, idx);
			pstmt.setString(2, client_id.trim());
			pstmt.setString(3, r_site.trim());
			pstmt.setString(4, member_id.trim());
			pstmt.setString(5, pw.trim());
			pstmt.setString(6, "Y");
            count = pstmt.executeUpdate();
			pstmt.close();

		    conn.commit();
		}catch(Exception se){
            try{
				System.out.println("[MemberDatabase:insertMember]\n"+se);
               conn.rollback();
           }catch(SQLException _ignored){}
      	  
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
                if(pstmt1 != null)	pstmt1.close();
					      
			}catch(Exception ignore){}
			closeConnection();
		}
    }

	//회원관리 등록
    public int insertMember(String client_id, String r_site, String member_id, String pw, String email)
	{
		getConnection();
        
        PreparedStatement pstmt = null;
        PreparedStatement pstmt1 = null;
        ResultSet rs = null;
        String query = "";
        String query1 = "";
		int idx = 0;
        int count = 0;
		if(member_id.equals("")) member_id="amazoncar";
                
		query = " insert into member(idx, client_id, r_site, member_id, pwd, use_yn, reg_dt)"+
				" values (?,?,?,?,text_encrypt(?, 'pw'),?,to_char(sysdate,'YYYYMMDD'))";

        query1 = " select nvl(max(idx)+1,1) from member";
		
        try{
            conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query1);
			rs = pstmt1.executeQuery();
            if(rs.next())
			{
				idx = rs.getInt(1);
            }
			rs.close();
			pstmt1.close();

            pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, idx);
			pstmt.setString(2, client_id.trim());
			pstmt.setString(3, r_site.trim());
			pstmt.setString(4, member_id.trim());
			pstmt.setString(5, pw.trim());
			pstmt.setString(6, "Y");
            count = pstmt.executeUpdate();
			pstmt.close();

  			conn.commit();
  		} catch(Exception se){
            try{
				System.out.println("[MemberDatabase:insertMember]\n"+se);
               conn.rollback();
           }catch(SQLException _ignored){}
     
		} finally {
			try{	
				if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
                if(pstmt1 != null)	pstmt1.close();
            			
		     	conn.setAutoCommit(true);	
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
    }


	//회원관리 등록
    public void updateMember(String client_id, String r_site, String member_id)
	{
		getConnection();
        
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
		query = " insert into c_ip_log(client_id, r_site, member_id, ip, login_dt)"+
				" values (?,?,?,?,to_date(?, 'YYYYMMDDHH24MISS'))";
		
        try{
            conn.setAutoCommit(false);

            pstmt = conn.prepareStatement(query);
			pstmt.setString(1, client_id.trim());
			pstmt.setString(2, r_site.trim());
			pstmt.setString(3, member_id.trim());
			pstmt.setString(4, "");
			pstmt.setString(5, "");
            count = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		} catch(Exception se){
            try{
				System.out.println("[MemberDatabase:insertLoginLog]\n"+se);
               conn.rollback();
           }catch(SQLException _ignored){}
		} finally {
			try{	
				conn.setAutoCommit(true);	
	            if(pstmt != null)	pstmt.close();
		       
			}catch(Exception ignore){}
			closeConnection();
		}
    }

	//로그 관리---------------------------------------------------------------------------------------------------------------------


	//로그 등록
    public void insertLoginLog(String client_id, String r_site, String member_id, String ip, String login_time)
	{
		getConnection();
        
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
		query = " insert into c_ip_log(client_id, r_site, member_id, ip, login_dt)"+
				" values (?,?,?,?,to_date(?, 'YYYYMMDDHH24MISS'))";
		
        try{
            conn.setAutoCommit(false);

            pstmt = conn.prepareStatement(query);
			pstmt.setString(1, client_id.trim());
			pstmt.setString(2, r_site.trim());
			pstmt.setString(3, member_id.trim());
			pstmt.setString(4, ip.trim());
			pstmt.setString(5, login_time.trim());
            count = pstmt.executeUpdate();
			pstmt.close();
		    conn.commit();
		} catch(Exception se){
            try{
				System.out.println("[MemberDatabase:insertLoginLog]\n"+se);
               conn.rollback();
           }catch(SQLException _ignored){}
      
		} finally {
			try{	
				conn.setAutoCommit(true);	
	            if(pstmt != null)	pstmt.close();
		        
			}catch(Exception ignore){}
			closeConnection();
		}
    }

	//로그 수정
    public void updateLogoutLog(String client_id, String r_site, String member_id, String ip, String login_time)
	{
		getConnection();
        
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;

        query = " UPDATE c_ip_log SET logout_dt=sysdate"+
				" WHERE client_id='"+client_id+"' and member_id='"+member_id+"' and ip='"+ip+"'";

		if(!login_time.equals("")) query += " and login_dt=to_date('"+login_time+"','YYYYMMDDHH24MISS')";

		if(!r_site.equals(""))	query += " and r_site='"+r_site+"'";
		
        try{
            conn.setAutoCommit(false);
            pstmt = conn.prepareStatement(query);
            count = pstmt.executeUpdate();
			pstmt.close();
            conn.commit();
       	} catch(Exception se){
            try{
				System.out.println("[MemberDatabase:updateLogoutLog]\n"+se);
               conn.rollback();
           }catch(SQLException _ignored){}
	
		} finally {
			try{
				conn.setAutoCommit(true);	
	            if(pstmt != null)	pstmt.close();
		       
			}catch(Exception ignore){}
			closeConnection();
		}
    }

	//회원로그 리스트
	public Vector getLogList(String s_gubun1, String s_gubun2, String s_gubun3, String s_gubun4, String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_qu = "";
		
		if(s_gubun3.equals("")){

			query = " select a.client_id, a.r_site, a.member_id,"+ 
					" decode(b.client_st,'1','법인','2','개인','개인사업자') client_st,"+ 
					" nvl(b.firm_nm,b.client_nm) firm_nm, b.client_nm, c.r_site as r_site_nm,"+ 
					" d.ip, to_char(d.login_dt,'YYYYMMDDHH24MI') login_dt, d.logout_dt, nvl(f.y_cnt,'0') y_cnt"+ 
					" from member a, client b, client_site c,"+ 
					" (select client_id||r_site as client_id, member_id, ip, login_dt, logout_dt from c_ip_log) d,"+ 
					" (select client_id||r_site as client_id, max(login_dt) login_dt from c_ip_log group by client_id||r_site) e,"+ 
					" (select client_id, count(0) y_cnt from cont where use_yn='Y' group by client_id) f"+ 
					" where a.client_id=b.client_id and b.firm_nm not like '%아마존%'"+ 
					" and a.client_id=c.client_id(+) and a.r_site=c.seq(+)"+ 
					" and a.client_id||a.r_site=e.client_id(+)"+ 
					" and e.client_id=d.client_id(+) and e.login_dt=d.login_dt(+)"+ 
					" and b.client_id=f.client_id(+)";
		}else{

			query = " select a.client_id, a.r_site, a.member_id,"+ 
					" decode(b.client_st,'1','법인','2','개인','개인사업자') client_st,"+ 
					" nvl(b.firm_nm,b.client_nm) firm_nm, b.client_nm, c.r_site as r_site_nm,"+ 
					" d.ip, to_char(d.login_dt,'YYYYMMDDHH24MI') login_dt, d.logout_dt, nvl(f.y_cnt,'0') y_cnt"+ 
					" from member a, client b, client_site c,"+ 
					" (select client_id||r_site as client_id, member_id, ip, login_dt, logout_dt from c_ip_log) d,"+ 
					" (select client_id||r_site as client_id, max(login_dt) login_dt from c_ip_log group by client_id||r_site) e,"+ 
					" (select client_id, count(0) y_cnt from cont where use_yn='Y' group by client_id) f,"+ 
					" (select client_id from cont where bus_id2='"+s_gubun3+"' group by client_id) g"+
					" where a.client_id=b.client_id and b.firm_nm not like '%아마존%'"+ 
					" and a.client_id=c.client_id(+) and a.r_site=c.seq(+)"+ 
					" and a.client_id||a.r_site=e.client_id(+)"+ 
					" and e.client_id=d.client_id(+) and e.login_dt=d.login_dt(+)"+ 
					" and b.client_id=f.client_id(+)"+
					" and b.client_id=g.client_id(+)";

		}

		if(s_gubun1.equals("Y"))		query += " and nvl(f.y_cnt,'0') <> '0'";
		else if(s_gubun1.equals("N"))	query += " and nvl(f.y_cnt,'0') = '0'";

		if(s_gubun2.equals("1"))		query += " and b.client_st='1'";
		else if(s_gubun2.equals("2"))	query += " and b.client_st='2'";
		else if(s_gubun2.equals("3"))	query += " and b.client_st in ('3','4','5')";

		if(s_kd.equals("1"))		query += " and b.firm_nm||b.client_nm like '%"+t_wd+"%'";
		else if(s_kd.equals("2"))	query += " and b.client_nm like '%"+t_wd+"%'";
		else if(s_kd.equals("3"))	query += " and a.member_id like '%"+t_wd+"%'";

		if(s_gubun4.equals("Y"))		query += " and d.ip is not null";
		else if(s_gubun4.equals("N"))	query += " and d.ip is null";

		query +=" ORDER BY decode(b.client_st,'1','1','2','2','3'), b.firm_nm||b.client_nm, nvl(c.r_site,'0')";

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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim()/**/);
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[MemberDatabase:getLogList]\n"+e);
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

	//회원로그 리스트
	public Vector getLogListCase(String client_id, String r_site, String member_id, String s_yy, String s_mm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_qu = "";
		
		query = " select ip, to_char(login_dt,'YYYYMMDDHH24MI') login_dt, decode(logout_dt,'','-',to_char(logout_dt,'YYYYMMDDHH24MI')) logout_dt"+
				" from c_ip_log where client_id='"+client_id+"'";

		if(!r_site.equals(""))		query += " and r_site='"+r_site+"'";

		if(!s_yy.equals("") && !s_mm.equals(""))		query += " and to_char(login_dt,'YYYYMM')='"+s_yy+s_mm+"'";
		else if(!s_yy.equals("") && s_mm.equals(""))	query += " and to_char(login_dt,'YYYY')='"+s_yy+"'";

		query +=" ORDER BY login_dt desc";

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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim()/**/);
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[MemberDatabase:getLogListCase]\n"+e);
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

	//로그인 아이디 중복 체크
    public int checkMemberIdPwd(String member_id, String pwd)
	{
		getConnection();
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        int count = 0;
                
		query = " select count(0) from member where member_id='"+member_id+"' and text_decrypt(pwd, 'pw') ='"+pwd+"'";
		
        try{
			pstmt = conn.prepareStatement(query);
		    rs = pstmt.executeQuery();
            if(rs.next())
            {
			    count = rs.getInt(1);
            }
			rs.close();
			pstmt.close();
	  	} catch (Exception e) {
			System.out.println("[MemberDatabase:checkMemberIdPwd]\n"+e);
			e.printStackTrace();
		} finally {
			try{	
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
		        conn.commit();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
    }

	//회원정보 - 사용가능하도록 수정
    public int updateMemberUseYN(String idx, String client_id)
	{
		getConnection();
        
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
        
        int i_idx = Integer.parseInt(idx);

        query = " UPDATE member SET use_yn ='Y',  update_dt=to_char(sysdate,'YYYYMMDD') "+
				" WHERE idx=? and client_id=?";

        try{
            conn.setAutoCommit(false);
            pstmt = conn.prepareStatement(query);		
			pstmt.setInt(1, i_idx);
			pstmt.setString(2, client_id);
            count = pstmt.executeUpdate();
			pstmt.close();
            conn.commit();
            
	  	} catch (Exception e) {
			System.out.println("[MemberDatabase:updateMemberUseYN]\n"+e);
			e.printStackTrace();
			conn.rollback();
		} finally {
			try{	
	            if(pstmt != null) pstmt.close();
		        conn.setAutoCommit(true);	
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
    }

	//회원정보 - 사용가능하도록 수정
    public int updateMemberUseYN(String client_id)
	{
		getConnection();
        
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
             
        query = " UPDATE member SET use_yn ='Y',  update_dt=to_char(sysdate,'YYYYMMDD') "+
				" WHERE  client_id=?  ";
      
        try{
            conn.setAutoCommit(false);
            pstmt = conn.prepareStatement(query);		
			pstmt.setString(1, client_id);
            count = pstmt.executeUpdate();
			pstmt.close();
            conn.commit();
            
	  	} catch (Exception e) {
			System.out.println("[MemberDatabase:updateMemberUseYN]\n"+e);
			e.printStackTrace();
			conn.rollback();
		} finally {
			try{	
	            if(pstmt != null) pstmt.close();
		        conn.setAutoCommit(true);	
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
    }
    
}
