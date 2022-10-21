/**
 * 인사카드
 * @ author : Gill Sun Ryu
 * @ e-mail : gillsun@empal.com
 * @ create date : 2008. 11. 24
 * @ last modify date : 
 */

package acar.biz_tel_mng;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.exception.DatabaseException;
import acar.exception.DataSourceEmptyException;


public class BiztelDatabase
{
	private Connection conn = null;
	public static BiztelDatabase db;
	
	public static BiztelDatabase getInstance()
	{
		if(BiztelDatabase.db == null)
			BiztelDatabase.db = new BiztelDatabase();
		return BiztelDatabase.db;
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
	 *	협력업체 등록하기
	 */
	
public int insertBiz_tel_mng(Biztel_Bean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Statement stmt = null;
		int count = 0;
		String query = "";
		String userQuery = "";
		String tel_mng_id = "";

		int seq = 0;

 	  	query = " insert into BIZ_TEL \n"+
				" (tel_mng_id, reg_id, reg_dt, tel_gubun, tel_time,\n"+
				" tel_car, tel_car_gubun, tel_car_st, tel_car_mng, tel_firm_nm, "+
				" tel_firm_mng, tel_firm_tel, tel_est_yn, tel_yp_gubun, tel_yp_nm,"+
				" tel_note"+
				" ) values ("+
				" ?, ?, sysdate, ?, ?, "+ 
				" ?, ?, ?, ?, ?, "+
				" ?, ?, ?, ?, ?, "+
				" ? "+
				" )";		

		userQuery = "select nvl(lpad(max(tel_mng_id)+1,6,'0'),'000001') from BIZ_TEL";


		try 
		{			
			conn.setAutoCommit(false);
			
  			stmt = conn.createStatement();
            rs = stmt.executeQuery(userQuery);
			if(rs.next())
            	tel_mng_id = rs.getString(1).trim();
            rs.close();
			stmt.close();
				
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, tel_mng_id.trim());
			pstmt.setString(2, bean.getReg_id());
			pstmt.setString(3, bean.getTel_gubun());
			pstmt.setString(4, bean.getTel_time());
			pstmt.setString(5, bean.getTel_car());
			pstmt.setString(6, bean.getTel_car_gubun());
			pstmt.setString(7, bean.getTel_car_st());
			pstmt.setString(8, bean.getTel_car_mng());
			pstmt.setString(9, bean.getTel_firm_nm());
			pstmt.setString(10, bean.getTel_firm_mng());
			pstmt.setString(11, bean.getTel_firm_tel());
			pstmt.setString(12, bean.getTel_est_yn());
			pstmt.setString(13, bean.getTel_yp_gubun());
			pstmt.setString(14, bean.getTel_yp_nm());
			pstmt.setString(15, bean.getTel_note());
			
			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[BiztelDatabase:insertBiz_tel_mng]\n"+e);
			System.out.println("[BiztelDatabase:insertBiz_tel_mng]\n"+query);
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

//수정
	public int updateBiz_tel_mng(Biztel_Bean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";


		query = " update BIZ_TEL set\n"+
				" tel_gubun = ?, \n"+
				" tel_car = ?, \n"+ 
				" tel_car_gubun = ?, \n"+ 
				" tel_car_st = ?, \n"+
				" tel_car_mng = ?, \n"+
				" tel_firm_nm = ?, \n"+ 
				" tel_firm_mng = ?, \n"+ 
				" tel_firm_tel = ?, \n"+ 
				" tel_est_yn = ?, \n"+ 
				" tel_yp_gubun = ?, \n"+ 
				" tel_yp_nm = ?, \n"+ 
				" tel_note = ?, \n"+ 
				" tel_esty_yn = ?, \n"+ 
				" tel_esty_dt = replace(?, '-', '') \n"+ 
				" where tel_mng_id=? ";		

		try 
		{		
			conn.setAutoCommit(false);	
		
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getTel_gubun());
			pstmt.setString(2, bean.getTel_car());
			pstmt.setString(3, bean.getTel_car_gubun());
			pstmt.setString(4, bean.getTel_car_st());
			pstmt.setString(5, bean.getTel_car_mng());
			pstmt.setString(6, bean.getTel_firm_nm());
			pstmt.setString(7, bean.getTel_firm_mng());
			pstmt.setString(8, bean.getTel_firm_tel());
			pstmt.setString(9, bean.getTel_est_yn());
			pstmt.setString(10, bean.getTel_yp_gubun());
			pstmt.setString(11, bean.getTel_yp_nm());
			pstmt.setString(12, bean.getTel_note());
			pstmt.setString(13, bean.getTel_esty_yn());
			pstmt.setString(14, bean.getTel_esty_dt());
			pstmt.setString(15, bean.getTel_mng_id());

			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[BiztelDatabase:updateBiz_tel_mng]\n"+e);
			System.out.println("[BiztelDatabase:updateBiz_tel_mng]\n"+query);
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
	 *	 한건 삭제
	 */

public int deleteBiz_tel_mng(Biztel_Bean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";

		query = " DELETE  FROM BIZ_TEL \n"+
				" where tel_mng_id=?";		

		try 
		{	
			conn.setAutoCommit(false);		
		
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, bean.getTel_mng_id());
			count = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		} catch (SQLException e) {
			System.out.println("[BiztelDatabase:deleteBiz_tel_mng]\n"+e);
			System.out.println("[BiztelDatabase:deleteBiz_tel_mng]\n"+query);
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
	 *	협력업체 전체조회 
	 */
	public Vector Biz_tel_mng_list(String gubun, String s_dt, String e_dt, String s_kd, String t_wd, String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

				 query = " Select SUBSTR(A.TEL_TIME, 12,5 ) AS TIME, b.USER_NM, decode(b.BR_ID, 'S1','본사', 'B1','부산지점', 'D1','대전지점', 'S2','강남지점', 'J1','광주지점', 'G1','대구지점') as br_nm, a.tel_time, "+
						 " a.TEL_MNG_ID, a.REG_DT, a.TEL_GUBUN, a.TEL_CAR, "+
						 " decode(a.TEL_CAR_GUBUN,'1','신차','2','재리스','3','신차 및 재리스','4','기타') as TEL_CAR_GUBUN, "+
						 " decode(a.TEL_CAR_ST,'1','렌트','2','리스','3','렌트 및 리스','4','기타') as TEL_CAR_ST, "+
						 " decode(a.TEL_CAR_MNG,'1','기본식','2','일반식','3','기본식 및 일반식','4','기타') as TEL_CAR_MNG, "+
						 " a.TEL_FIRM_NM, a.TEL_FIRM_MNG, a.TEL_FIRM_TEL, "+
						 " decode(a.TEL_EST_YN,'1','기타','2','상','3','중','4','하') as TEL_EST_YN, "+
						 " decode(a.TEL_YP_GUBUN,'1','고객','2','자동차영업사원','3','리스에이전트','4','영업사원 또는 에이전트','5','기타') as TEL_YP_GUBUN, "+
					     " a.TEL_YP_NM, a.TEL_NOTE, "+
						 " decode(a.TEL_ESTY_YN,'1','미확정','2','계약체결','3','계약미체결') as TEL_ESTY_YN, a.TEL_ESTY_DT "+
						 " from biz_tel a, users b where a.REG_ID = b.USER_ID ";



				if(gubun.equals("1")) query += " and (to_char(a.reg_dt,'YYYYMM')=to_char(sysdate,'YYYYMM')  or a.reg_dt is null )";
				if(gubun.equals("4")) query += " and (to_char(a.reg_dt,'YYYYMM')=to_char(sysdate,'YYYYMM')-1  or a.reg_dt is null )";
				if(gubun.equals("2")) query += " and to_char(a.reg_dt,'YYYYMMDD')=to_char(sysdate,'YYYYMMDD') ";
				if(gubun.equals("3")) query += " and to_char(a.reg_dt,'YYYYMMDD') between replace('"+s_dt+"','-','') and replace('"+e_dt+"','-','')";

				if(s_kd.equals("1")) query += " and upper(a.tel_car) like upper('%"+ t_wd +"%')";
				if(s_kd.equals("2")) query += " and a.reg_id like '%"+t_wd+"%'";
				if(s_kd.equals("3")) query += " and decode(b.BR_ID, 'S1','본사', 'B1','부산지점', 'D1','대전지점', 'S2','강남지점', 'J1','광주지점', 'G1','대구지점') like '%"+t_wd+"%'";
				if(s_kd.equals("4")) query += " and decode(a.TEL_CAR_GUBUN,'1','신차','2','재리스','3','신차 및 재리스','4','기타') like '%"+t_wd+"%'";
				if(s_kd.equals("5")) query += " and decode(a.TEL_CAR_ST,'1','렌트','2','리스','3','렌트 및 리스','4','기타') like '%"+t_wd+"%'";
				if(s_kd.equals("6")) query += " and decode(a.TEL_CAR_MNG,'1','기본식','2','일반식','3','기본식 및 일반식','4','기타') like '%"+t_wd+"%'";
				if(s_kd.equals("7")) query += " and (a.tel_firm_nm || a.tel_firm_mng) like '%"+t_wd+"%'";
				if(s_kd.equals("8")) query += " and decode(a.TEL_EST_YN,'1','기타','2','상','3','중','4','하') like '%"+t_wd+"%'";
				if(s_kd.equals("9")) query += " and decode(a.TEL_YP_GUBUN,'1','고객','2','자동차영업사원','3','리스에이전트','4','영업사원 또는 에이전트','5','기타') like '%"+t_wd+"%'";
				if(s_kd.equals("10")) query += " and decode(a.TEL_ESTY_YN,'1','미확정','2','계약체결','3','계약미체결') like '%"+t_wd+"%'";

				query += "order by a.tel_mng_id desc";

//System.out.println("Biz_tel_mng_list="+query);

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
			System.out.println("[BiztelDatabase:Biz_tel_mng_list]"+e);
			System.out.println("[BiztelDatabase:Biz_tel_mng_list]"+query);
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


	//한건조회
public Hashtable Biz_tel_mng_1st(String tel_mng_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

				 query = " Select SUBSTR(A.TEL_TIME, 12,5 ) AS TIME, b.USER_NM, decode(b.BR_ID, 'S1','본사', 'B1','부산지점', 'D1','대전지점', 'S2','강남지점', 'J1','광주지점', 'G1','대구지점') as br_nm, a.tel_time, "+
						 " a.TEL_MNG_ID, a.REG_DT, a.TEL_GUBUN, a.TEL_CAR, "+
						 " decode(a.TEL_CAR_GUBUN,'1','신차','2','재리스','3','신차 및 재리스','4','기타') as TEL_CAR_GUBUN, "+
						 " decode(a.TEL_CAR_ST,'1','렌트','2','리스','3','렌트 및 리스','4','기타') as TEL_CAR_ST, "+
						 " decode(a.TEL_CAR_MNG,'1','기본식','2','일반식','3','기본식 및 일반식','4','기타') as TEL_CAR_MNG, "+
						 " a.TEL_FIRM_NM, a.TEL_FIRM_MNG, a.TEL_FIRM_TEL, "+
						 " decode(a.TEL_EST_YN,'1','기타','2','상','3','중','4','하') as TEL_EST_YN, "+
						 " decode(a.TEL_YP_GUBUN,'1','고객','2','자동차영업사원','3','리스에이전트','4','영업사원 또는 에이전트','5','기타') as TEL_YP_GUBUN, "+
					     " a.TEL_YP_NM, a.TEL_NOTE, "+
						 " decode(a.TEL_ESTY_YN,'1','미확정','2','계약체결','3','계약미체결') as TEL_ESTY_YN, a.TEL_ESTY_DT "+
						 " from biz_tel a, users b where a.REG_ID = b.USER_ID and tel_mng_id = '"+tel_mng_id+"' ";

//System.out.println("Biz_tel_mng_1st="+query);

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
			System.out.println("[BiztelDatabase:Biz_tel_mng_1st]"+e);
			System.out.println("[BiztelDatabase:Biz_tel_mng_1st]"+query);
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

	
	//리스트 
	public Vector inout_list()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

				 query = "SELECT a.USER_ID,\n"
        				+ "a.BR_ID,\n"
        				+ "b.BR_NM,\n"
        				+ "a.USER_NM,\n"
        				+ "a.ID,\n"
        				+ "a.DEPT_ID,\n"
        				+ "c.NM AS DEPT_NM,\n"
        				+ "a.USER_POS,a.use_yn\n"
		        		+ "FROM USERS a, BRANCH b, (select * from CODE where c_st='0002') c, mail_mng d\n"
						+ "where a.BR_ID = b.BR_ID and a.mail_id=d.userid(+)\n"
        				+ "and a.DEPT_ID = c.CODE(+) and a.user_pos in ('대표이사','팀장','과장','대리','사원','인턴사원')\n";
					
				query += "  and nvl(a.use_yn,'Y')='Y' and a.m_io = 'Y' ";

				query += "order by decode(a.user_pos,'대표이사',1,'팀장',3,4), a.dept_id, decode(a.user_pos,'과장',1,'대리',2,3), a.user_id  ";

	
		//System.out.println("inout_list="+query);

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
			System.out.println("[BiztelDatabase:inout_list]"+e);
			System.out.println("[BiztelDatabase:inout_list]"+query);
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

	//등록
	public int insertM_io(String m_io, String user_id)
	{
		getConnection();
	 
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query=" UPDATE USERS SET m_io='"+m_io+"' WHERE USER_ID='"+user_id+"' ";
 
      	try 
		{			
		
			conn.setAutoCommit(false);
				
			pstmt = conn.prepareStatement(query);
			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[BiztelDatabase:insertM_io]\n"+e);
			System.out.println("[BiztelDatabase:insertM_io]\n"+query);
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

	//등록해제
	public int deleteM_io(String m_io, String user_id)
	{
		getConnection();
	 
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query=" UPDATE USERS SET m_io='"+m_io+"' WHERE USER_ID='"+user_id+"' ";
 
      	try 
		{			
		
			conn.setAutoCommit(false);
				
			pstmt = conn.prepareStatement(query);
			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[BiztelDatabase:deleteM_io]\n"+e);
			System.out.println("[BiztelDatabase:deleteM_io]\n"+query);
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


} // 마지막 괄호