package acar.client;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.client.*;
import acar.common.*;
import acar.cont.*;

public class AddClientDatabase
{
	private Connection conn = null;
	public static AddClientDatabase db;
	
	public static AddClientDatabase getInstance()
	{
		if(AddClientDatabase.db == null)
			AddClientDatabase.db = new AddClientDatabase();
		return AddClientDatabase.db;	
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

	//고객 리스트 조회 (gubun - 1:상호, 2:계약자명, 3: 전화번호, 4:휴대폰, 5: 주소, 6:사업자번호)
	public Vector getClientList(String gubun, String kwd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query +="select C.CLIENT_ID, C.CLIENT_ST, C.CLIENT_NM, nvl(C.FIRM_NM, C.client_nm) FIRM_NM,"+
				" decode(C.CLIENT_ST, '1', '법인', '2', '개인', '3', '개인사업자(일반과세)', '4', '개인사업자(간이과세)', '5', '개인사업자(면세사업자)') CLIENT_ST_NM,"+
				" C.CON_AGNT_NM, C.O_TEL, C.M_TEL, C.HOMEPAGE, "+
				" C.FAX, C.O_ZIP, C.O_ADDR, nvl(C.enp_no, TEXT_DECRYPT(c.ssn, 'pw' )  ) enp_no,  TEXT_DECRYPT(c.ssn, 'pw' ) ssn, C.lic_no, C.con_agnt_email "+
				"from CLIENT C ";
		
		if(gubun.equals("1"))			query += "where nvl(C.firm_nm, ' ') like '%"+kwd+"%'";
		else if(gubun.equals("2"))		query += "where nvl(C.client_nm, ' ') like '%"+kwd+"%'";
		else if(gubun.equals("3"))		query += "where nvl(C.o_tel, ' ')  like '%"+kwd+"%'";
		else if(gubun.equals("4"))		query += "where nvl(C.m_tel, ' ')  like '%"+kwd+"%'";
		else if(gubun.equals("5"))		query += "where nvl(C.o_addr, ' ')  like '%"+kwd+"%'";
		else if(gubun.equals("6"))		query += "where nvl(C.enp_no, TEXT_DECRYPT(c.ssn, 'pw' )  )  like '%"+kwd+"%'";

		
		query += " order by C.firm_nm";
		
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
			System.out.println("[AddClientDatabase:getClientList]\n"+e);
			System.out.println("[AddClientDatabase:getClientList]\n"+query);
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
	 *	gubun - 1: 상호 2: 계약자, 3:담당자, 4: 전화번호, 5:휴대폰, 6:주소
	 *	asc - 1 : 내림차순, 0: 오름차순
	 */	
	public Vector getClientList(String s_kd, String t_wd, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select /*+ RULE */ \n"+
				"        C.CLIENT_ID, C.CLIENT_ST, C.CLIENT_NM, nvl(C.FIRM_NM, C.client_nm) FIRM_NM, \n"+
				"        decode(C.CLIENT_ST, '1', '법인', '2', '개인', '3', '일반과세자', '4', '간이과세자','5','면세사업자','6','경매장') CLIENT_ST_NM, \n"+
				"        C.CON_AGNT_NM, C.O_TEL, C.M_TEL, C.HOMEPAGE, \n"+
				"        C.FAX, C.O_ZIP, C.O_ADDR, C.enp_no, TEXT_DECRYPT(c.ssn, 'pw' ) ssn, C.lic_no, \n"+
				"        CASE WHEN NVL(D.lt_cnt,0)+NVL(E.st_cnt,0)+NVL(F.ot_cnt,0)=0 THEN 'N' ELSE 'Y' END use_yn, \n"+
		        "        NVL(D.lt_cnt,0) lt_cnt, NVL(D.l_use_cnt,0) l_use_cnt, D.rent_dt, D.f_rent_dt, nvl(D.bus_id2,D.max_bus_id2) bus_id2, \n"+
                "        NVL(E.st_cnt,0) st_cnt, NVL(E.s_use_cnt,0) s_use_cnt, NVL(F.ot_cnt,0) ot_cnt \n"+
				" from   client C, \n"+
				"        (select client_id, count(*) lt_cnt, count(decode(nvl(use_yn,'Y'),'Y',rent_l_cd)) l_use_cnt, min(decode(nvl(use_yn,'Y'),'Y',rent_dt)) rent_dt, min(rent_dt) f_rent_dt, max(decode(nvl(use_yn,'Y'),'Y',bus_id2)) bus_id2, max(bus_id2) max_bus_id2 from cont where rent_l_cd not like 'RM%' and car_st not in ( '4')  group by client_id) D, \n"+
	//			"        (select cust_id AS client_id, count(*) st_cnt, count(decode(nvl(use_st,'0'),'1',rent_s_cd,'2',rent_s_cd)) s_use_cnt, min(decode(nvl(use_st,'0'),'1',rent_dt,'2',rent_dt)) rent_dt from rent_cont where rent_st='12' and cust_st='1' group by cust_id) E, \n"+
				"        (select client_id, count(*) st_cnt, count(decode(nvl(use_yn,'Y'),'Y',rent_l_cd)) s_use_cnt, min(decode(nvl(use_yn,'Y'),'Y',rent_dt)) rent_dt from cont where rent_l_cd  not  like 'RM%' and car_st  in ( '4')  group by client_id) E, \n"+
				"        (select client_id, count(*) ot_cnt, min(cont_dt) rent_dt from sui where client_id IS NOT NULL AND cont_dt IS NOT NULL group by client_id) F \n"+
				" where  ";
		
		if(s_kd.equals("client_id") && !t_wd.equals("")){
			query += " C.client_id='"+t_wd+"' and ";
		}

		query += " C.client_id=D.client_id(+) AND C.client_id=E.client_id(+) AND C.client_id=F.client_id(+) \n";


		if(s_kd.equals("9") && !t_wd.equals("")){
			query += " and D.rent_dt like '"+t_wd+"%' ";
		}
		if(s_kd.equals("10") && !t_wd.equals("")){
			query += " and E.rent_dt like '"+t_wd+"%' ";
		}
		if(s_kd.equals("11") && !t_wd.equals("")){
			query += " and F.rent_dt like '"+t_wd+"%' ";
		}

		if(s_kd.equals("2"))		query += " and nvl(C.client_nm, ' ') like '%"+t_wd+"%'		order by decode(D.client_id,'','N','Y') desc, C.firm_nm";
		else if(s_kd.equals("3"))	query += " and nvl(C.CON_AGNT_NM, ' ') like '%"+t_wd+"%'	order by decode(D.client_id,'','N','Y') desc, C.CON_AGNT_NM";
		else if(s_kd.equals("4"))	query += " and nvl(C.o_tel, ' ')  like '%"+t_wd+"%'			order by decode(D.client_id,'','N','Y') desc, C.o_tel";
		else if(s_kd.equals("5"))	query += " and nvl(C.m_tel, ' ')  like '%"+t_wd+"%'			order by decode(D.client_id,'','N','Y') desc, C.m_tel";
		else if(s_kd.equals("6"))	query += " and nvl(C.o_addr, ' ')  like '%"+t_wd+"%'		order by decode(D.client_id,'','N','Y') desc, C.o_addr";
		else if(s_kd.equals("7"))	query += " and nvl(C.enp_no||TEXT_DECRYPT(c.ssn, 'pw' ) , ' ')  like '%"+t_wd+"%' order by decode(D.client_id,'','N','Y') desc, C.client_st, C.enp_no||TEXT_DECRYPT(c.ssn, 'pw' ) ";
		else if(s_kd.equals("8"))	query += " and C.client_st='6'								order by decode(D.client_id,'','N','Y') desc, nvl(C.firm_nm, C.client_nm) ";
		else if(s_kd.equals("9"))	query += " and NVL(D.l_use_cnt,0) > 0						order by nvl(C.firm_nm, C.client_nm) ";
		else if(s_kd.equals("10"))	query += " and NVL(E.st_cnt,0) > 0							order by nvl(C.firm_nm, C.client_nm) ";
		else if(s_kd.equals("11"))	query += " and NVL(F.ot_cnt,0) > 0							order by nvl(C.firm_nm, C.client_nm) ";
		else if(s_kd.equals("12"))	query += " and C.client_id='"+t_wd+"'						order by C.client_id ";
		else if(s_kd.equals("13"))	query += " and C.item_mail_yn='N'							order by nvl(C.firm_nm, C.client_nm) ";
		else if(s_kd.equals("14"))	query += " and C.reg_dt like '"+t_wd+"%'					order by C.reg_dt ";
		else						query += " and nvl(C.firm_nm, ' ') like '%"+t_wd+"%'		order by decode(D.client_id,'','N','Y') desc, nvl(C.firm_nm, C.client_nm)";



		if(asc.equals("0"))		query += " asc";
		else if(asc.equals("1"))	query += " desc";



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
			System.out.println("[AddClientDatabase:getClientList]\n"+e);
			System.out.println("[AddClientDatabase:getClientList]\n"+query);
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
		
	public Hashtable getClientListCase(String client_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select /*+ RULE */ \n"+
				"        C.CLIENT_ID, C.CLIENT_ST, C.CLIENT_NM, nvl(C.FIRM_NM, C.client_nm) FIRM_NM, \n"+
				"        decode(C.CLIENT_ST, '1', '법인', '2', '개인', '3', '일반과세자', '4', '간이과세자','5','면세사업자','6','경매장') CLIENT_ST_NM, \n"+
				"        C.CON_AGNT_NM, C.O_TEL, C.M_TEL, C.HOMEPAGE, \n"+
				"        C.FAX, C.O_ZIP, C.O_ADDR, C.enp_no, TEXT_DECRYPT(c.ssn, 'pw' ) ssn, \n"+
				"        CASE WHEN NVL(D.lt_cnt,0)+NVL(E.st_cnt,0)+NVL(F.ot_cnt,0)=0 THEN 'N' ELSE 'Y' END use_yn, \n"+
		        "        NVL(D.lt_cnt,0) lt_cnt, NVL(D.l_use_cnt,0) l_use_cnt, D.rent_dt, \n"+
                "        NVL(E.st_cnt,0) st_cnt, NVL(E.s_use_cnt,0) s_use_cnt, NVL(F.ot_cnt,0) ot_cnt \n"+
				" from   client C, \n"+
				"        (select client_id, count(*) lt_cnt, count(decode(nvl(use_yn,'Y'),'Y',rent_l_cd)) l_use_cnt, min(decode(nvl(use_yn,'Y'),'Y',rent_dt)) rent_dt from cont  where rent_l_cd not like 'RM%'  group by client_id) D, \n"+
				"        (select cust_id AS client_id, count(*) st_cnt, count(decode(nvl(use_st,'0'),'1',rent_s_cd,'2',rent_s_cd)) s_use_cnt, min(decode(nvl(use_st,'0'),'1',rent_dt,'2',rent_dt)) rent_dt from rent_cont where rent_st='12' and cust_st='1' group by cust_id) E, \n"+
				"        (select client_id, count(*) ot_cnt, min(cont_dt) rent_dt from sui where client_id IS NOT NULL AND cont_dt IS NOT NULL group by client_id) F \n"+
				" where  C.client_id='"+client_id+"' and C.client_id=D.client_id(+) AND C.client_id=E.client_id(+) AND C.client_id=F.client_id(+)";
		

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
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
			pstmt.close();
			
			
		} catch (SQLException e) {
			System.out.println("[AddClientDatabase:getClientListCase]\n"+e);
			System.out.println("[AddClientDatabase:getClientListCase]\n"+query);
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

	/**
	 *	gubun - 1: 상호 2: 대표자 3:차량번호
	 *	asc - 1 : 내림차순, 0: 오름차순
	 *      웰렌트 포함 - 20120621
	 */	
	public Vector getClientList(String s_kd, String t_wd, String asc, String t_wd_chk)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		
		
		query= " select distinct a.client_id, a.client_nm, a.firm_nm, a.client_st_nm , a.con_agnt_nm, a.ven_code ,  \n  "+
					"	  CASE WHEN NVL(D.lt_cnt,0)+NVL(E.st_cnt,0)=0 THEN 'N' ELSE 'Y' END use_yn,   \n  "+
		      		"         NVL(D.lt_cnt,0) lt_cnt, NVL(D.l_use_cnt,0) l_use_cnt, D.rent_dt,   \n  "+
     				"		   NVL(E.st_cnt,0) st_cnt, NVL(E.s_use_cnt,0) s_use_cnt  \n  "+
		 		"  from ( \n" +
				" select  b.car_mng_id, C.CLIENT_ID CLIENT_ID, C.CLIENT_ST CLIENT_ST, C.CLIENT_NM CLIENT_NM, nvl(C.FIRM_NM, C.client_nm) FIRM_NM,  \n  "+
				" decode(C.CLIENT_ST, '1', '법인', '2', '개인', '3', '일반과세자', '4', '간이과세자') CLIENT_ST_NM , \n  "+
				" C.CON_AGNT_NM CON_AGNT_NM, C.O_TEL O_TEL, C.M_TEL M_TEL, C.HOMEPAGE HOMEPAGE, \n  "+
				" C.FAX FAX, C.O_ZIP, C.O_ADDR O_ADDR, decode(a.client_id, '','N','Y') use_yn, C.enp_no, TEXT_DECRYPT(c.ssn, 'pw' ) ssn , c.ven_code \n  "+
				" from client c, cont a, car_reg b,  fee f \n  "+
				" where a.client_id = C.client_id and a.car_mng_id = b.car_mng_id(+)  and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd   \n  "+

				" union all \n  "+

				" select  b.car_mng_id, C.CLIENT_ID CLIENT_ID, C.CLIENT_ST CLIENT_ST, C.CLIENT_NM CLIENT_NM, nvl(C.FIRM_NM, C.client_nm) FIRM_NM,  \n  "+
				" decode(C.CLIENT_ST, '1', '법인', '2', '개인', '3', '일반과세자', '4', '간이과세자') CLIENT_ST_NM , \n  "+
				" C.CON_AGNT_NM CON_AGNT_NM, C.O_TEL O_TEL, C.M_TEL M_TEL, C.HOMEPAGE HOMEPAGE, \n  "+
				" C.FAX FAX, C.O_ZIP, C.O_ADDR O_ADDR, decode(a.cust_id, '','N','Y') use_yn, C.enp_no, TEXT_DECRYPT(c.ssn, 'pw' ) ssn , c.ven_code \n  "+
				" from client c, rent_cont a, car_reg b \n  "+
				" where a.cust_id = C.client_id and a.car_mng_id = b.car_mng_id(+) \n  "+
              "  )  a ,  car_reg b , \n  "+
             "        (select client_id, count(*) lt_cnt, count(decode(nvl(use_yn,'Y'),'Y',rent_l_cd)) l_use_cnt, min(decode(nvl(use_yn,'Y'),'Y',rent_dt)) rent_dt from cont  where rent_l_cd not like 'RM%'  group by client_id) D,   \n  "+
		      "  (  select client_id , sum(st_cnt) st_cnt, sum(s_use_cnt) s_use_cnt, rent_dt from ( \n  "+
             "            select client_id, count(*) st_cnt, count(decode(nvl(use_yn,'Y'),'Y',rent_l_cd)) s_use_cnt, max(decode(nvl(use_yn,'Y'),'Y',rent_dt)) rent_dt from cont  where rent_l_cd not like 'RM%' and car_st = '4'  group by client_id \n  "+
             "            union \n  "+
             "            select cust_id AS client_id, count(*) st_cnt, count(decode(nvl(use_st,'0'),'1',rent_s_cd,'2',rent_s_cd)) s_use_cnt, max(decode(nvl(use_st,'0'),'1',rent_dt,'2',rent_dt)) rent_dt from rent_cont where rent_st='12' and cust_st='1' group by cust_id \n  "+
             "            ) group by client_id, rent_dt \n  "+
             "  ) e \n  "+
             " where  a.car_mng_id = b.car_mng_id(+)  \n  "+
				"	   and a.client_id=D.client_id(+) AND a.client_id=E.client_id(+)    \n ";
	/*			
		query = " select distinct C.CLIENT_ID CLIENT_ID, C.CLIENT_ST CLIENT_ST, C.CLIENT_NM CLIENT_NM, nvl(C.FIRM_NM, C.client_nm) FIRM_NM,"+
				" decode(C.CLIENT_ST, '1', '법인', '2', '개인', '3', '일반과세자', '4', '간이과세자') CLIENT_ST_NM,"+
				" C.CON_AGNT_NM CON_AGNT_NM, C.O_TEL O_TEL, C.M_TEL M_TEL, C.HOMEPAGE HOMEPAGE, "+
				" C.FAX FAX, C.O_ZIP, C.O_ADDR O_ADDR, decode(a.client_id, '','N','Y') use_yn, C.enp_no, C.ssn "+
				" from client c, cont a, car_reg b "+
				" where a.client_id = C.client_id and a.car_mng_id = b.car_mng_id(+) ";


		if(s_kd.equals("1")) {	
			if (t_wd.equals("대한의사") && t_wd_chk.equals("Y")) {
				query += " and C.client_id in ('002102', '001190', '001705', '001187' , '001696', '001686') ";
			} else {
			query += " and nvl(C.firm_nm, ' ') like '%"+t_wd+"%'" ;
			}
		}	
		if(s_kd.equals("2"))		query += " and nvl(c.client_nm, ' ') like '%"+t_wd+"%'";
		if(s_kd.equals("3"))		query += " and b.car_no  like '%"+t_wd+"%'";
				
		query+=" order by decode(a.client_id,'','N','Y') desc, nvl(C.firm_nm, C.client_nm)";
*/
		
		if(s_kd.equals("1")) {	
			if (t_wd.equals("대한의사") && t_wd_chk.equals("Y")) {
				query += " and  a.client_id in ('002102', '001190', '001705', '001187' , '001696', '001686') ";
			} else {
			query += " and  nvl(a.firm_nm, ' ') like '%"+t_wd+"%'" ;
			}
		}	
		if(s_kd.equals("2"))		query += " and  nvl(a.client_nm, ' ') like '%"+t_wd+"%'";
		if(s_kd.equals("3"))		query += " and  b.car_no  like '%"+t_wd+"%'";
				
		query+=" order by decode(a.client_id,'','N','Y') desc, 9 DESC, 12 DESC,  nvl(a.firm_nm, a.client_nm)";
		
		if(asc.equals("0"))		query += " asc";
		else if(asc.equals("1"))	query += " desc";

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
			System.out.println("[AddClientDatabase:getClientList]\n"+e);
			System.out.println("[AddClientDatabase:getClientList]\n"+query);
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
	
	public Vector getClientEcarList(String s_kd, String t_wd, String asc, String t_wd_chk , String t_ecar_chk)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		
		
		query= " select distinct a.client_id, a.client_nm, a.firm_nm, a.client_st_nm , a.con_agnt_nm, a.ven_code ,  \n  "+
					"	  CASE WHEN NVL(D.lt_cnt,0)+NVL(E.st_cnt,0)=0 THEN 'N' ELSE 'Y' END use_yn,   \n  "+
		      		"         NVL(D.lt_cnt,0) lt_cnt, NVL(D.l_use_cnt,0) l_use_cnt, D.rent_dt,   \n  "+
     				"		   NVL(E.st_cnt,0) st_cnt, NVL(E.s_use_cnt,0) s_use_cnt  \n  "+
		 		"  from ( \n" +
				" select  b.car_mng_id, C.CLIENT_ID CLIENT_ID, C.CLIENT_ST CLIENT_ST, C.CLIENT_NM CLIENT_NM, nvl(C.FIRM_NM, C.client_nm) FIRM_NM,  \n  "+
				" decode(C.CLIENT_ST, '1', '법인', '2', '개인', '3', '일반과세자', '4', '간이과세자') CLIENT_ST_NM , \n  "+
				" C.CON_AGNT_NM CON_AGNT_NM, C.O_TEL O_TEL, C.M_TEL M_TEL, C.HOMEPAGE HOMEPAGE, \n  "+
				" C.FAX FAX, C.O_ZIP, C.O_ADDR O_ADDR, decode(a.client_id, '','N','Y') use_yn, C.enp_no, TEXT_DECRYPT(c.ssn, 'pw' ) ssn , c.ven_code \n  "+
				" from client c, cont a, car_reg b,  fee f , scd_ext se \n  "+
				" where a.client_id = C.client_id and a.car_mng_id = b.car_mng_id(+)  and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd   \n  "+
				"     and a.rent_start_dt is not null   \n  "+
             "      and a.rent_mng_id = se.rent_mng_id and a.rent_l_cd = se.rent_l_cd and se.ext_st = '7' and se.ext_pay_amt = 0  \n  "+		
		//		" union all \n  "+
		//		" select  b.car_mng_id, C.CLIENT_ID CLIENT_ID, C.CLIENT_ST CLIENT_ST, C.CLIENT_NM CLIENT_NM, nvl(C.FIRM_NM, C.client_nm) FIRM_NM,  \n  "+
		//		" decode(C.CLIENT_ST, '1', '법인', '2', '개인', '3', '일반과세자', '4', '간이과세자') CLIENT_ST_NM , \n  "+
		//		" C.CON_AGNT_NM CON_AGNT_NM, C.O_TEL O_TEL, C.M_TEL M_TEL, C.HOMEPAGE HOMEPAGE, \n  "+
		//		" C.FAX FAX, C.O_ZIP, C.O_ADDR O_ADDR, decode(a.cust_id, '','N','Y') use_yn, C.enp_no, TEXT_DECRYPT(c.ssn, 'pw' ) ssn , c.ven_code \n  "+
		//		" from client c, rent_cont a, car_reg b \n  "+
		//		" where a.cust_id = C.client_id and a.car_mng_id = b.car_mng_id(+) \n  "+
              "  )  a ,  car_reg b , \n  "+
             "        (select client_id, count(*) lt_cnt, count(decode(nvl(use_yn,'Y'),'Y',rent_l_cd)) l_use_cnt, min(decode(nvl(use_yn,'Y'),'Y',rent_dt)) rent_dt from cont  where rent_l_cd not like 'RM%'  group by client_id) D,   \n  "+
		      "  (  select client_id , sum(st_cnt) st_cnt, sum(s_use_cnt) s_use_cnt, rent_dt from ( \n  "+
             "            select client_id, count(*) st_cnt, count(decode(nvl(use_yn,'Y'),'Y',rent_l_cd)) s_use_cnt, max(decode(nvl(use_yn,'Y'),'Y',rent_dt)) rent_dt from cont  where rent_l_cd not like 'RM%' and car_st = '4'  group by client_id \n  "+
             "            union \n  "+
             "            select cust_id AS client_id, count(*) st_cnt, count(decode(nvl(use_st,'0'),'1',rent_s_cd,'2',rent_s_cd)) s_use_cnt, max(decode(nvl(use_st,'0'),'1',rent_dt,'2',rent_dt)) rent_dt from rent_cont where rent_st='12' and cust_st='1' group by cust_id \n  "+
             "            ) group by client_id, rent_dt \n  "+
             "  ) e \n  "+
             " where  a.car_mng_id = b.car_mng_id(+)  \n  "+
				"	   and a.client_id=D.client_id(+) AND a.client_id=E.client_id(+)    \n ";
	/*			
		query = " select distinct C.CLIENT_ID CLIENT_ID, C.CLIENT_ST CLIENT_ST, C.CLIENT_NM CLIENT_NM, nvl(C.FIRM_NM, C.client_nm) FIRM_NM,"+
				" decode(C.CLIENT_ST, '1', '법인', '2', '개인', '3', '일반과세자', '4', '간이과세자') CLIENT_ST_NM,"+
				" C.CON_AGNT_NM CON_AGNT_NM, C.O_TEL O_TEL, C.M_TEL M_TEL, C.HOMEPAGE HOMEPAGE, "+
				" C.FAX FAX, C.O_ZIP, C.O_ADDR O_ADDR, decode(a.client_id, '','N','Y') use_yn, C.enp_no, C.ssn "+
				" from client c, cont a, car_reg b "+
				" where a.client_id = C.client_id and a.car_mng_id = b.car_mng_id(+) ";


		if(s_kd.equals("1")) {	
			if (t_wd.equals("대한의사") && t_wd_chk.equals("Y")) {
				query += " and C.client_id in ('002102', '001190', '001705', '001187' , '001696', '001686') ";
			} else {
			query += " and nvl(C.firm_nm, ' ') like '%"+t_wd+"%'" ;
			}
		}	
		if(s_kd.equals("2"))		query += " and nvl(c.client_nm, ' ') like '%"+t_wd+"%'";
		if(s_kd.equals("3"))		query += " and b.car_no  like '%"+t_wd+"%'";
				
		query+=" order by decode(a.client_id,'','N','Y') desc, nvl(C.firm_nm, C.client_nm)";
*/
		
		if(s_kd.equals("1")) {	
			if (t_wd.equals("대한의사") && t_wd_chk.equals("Y")) {
				query += " and  a.client_id in ('002102', '001190', '001705', '001187' , '001696', '001686') ";
			} else {
			query += " and  nvl(a.firm_nm, ' ') like '%"+t_wd+"%'" ;
			}
		}	
		if(s_kd.equals("2"))		query += " and  nvl(a.client_nm, ' ') like '%"+t_wd+"%'";
		if(s_kd.equals("3"))		query += " and  b.car_no  like '%"+t_wd+"%'";
				
		query+=" order by decode(a.client_id,'','N','Y') desc, 9 DESC, 12 DESC,  nvl(a.firm_nm, a.client_nm)";
		
		if(asc.equals("0"))		query += " asc";
		else if(asc.equals("1"))	query += " desc";

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
			System.out.println("[AddClientDatabase:getClientList]\n"+e);
			System.out.println("[AddClientDatabase:getClientList]\n"+query);
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
	
	
	//고객 조회
	public ClientBean getClient(String client_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ClientBean client = new ClientBean();

		String query = " select CLIENT_ID, CLIENT_ST, CLIENT_NM, FIRM_NM,"+
						" substr(TEXT_DECRYPT(ssn, 'pw' ), 1, 6) SSN1, substr(TEXT_DECRYPT(ssn, 'pw' ), 7, 7) SSN2,"+
						" substr(ENP_NO, 1, 3) ENP_NO1, substr(ENP_NO, 4, 2) ENP_NO2, substr(ENP_NO, 6, 5)  ENP_NO3,"+
		 				" H_TEL, O_TEL, M_TEL, HOMEPAGE, FAX,"+
						" BUS_CDT, BUS_ITM, HO_ADDR, HO_ZIP, O_ADDR, O_ZIP, REPRE_ZIP, REPRE_ADDR, COM_NM, DEPT, TITLE,"+
						" CAR_USE, CON_AGNT_NM, CON_AGNT_O_TEL, CON_AGNT_M_TEL, CON_AGNT_FAX, CON_AGNT_EMAIL, CON_AGNT_DEPT,"+
						" CON_AGNT_TITLE, ETC, FIRM_PRICE, FIRM_PRICE_Y, FIRM_PRICE_B,"+
						" decode(OPEN_YEAR, '', '', substr(OPEN_YEAR, 1, 4) || '-' || substr(OPEN_YEAR, 5, 2) || '-'||substr(OPEN_YEAR, 7, 2)) OPEN_YEAR, "+
						" decode(FIRM_DAY, '', '', substr(FIRM_DAY, 1, 4) || '-' || substr(FIRM_DAY, 5, 2) || '-'||substr(FIRM_DAY, 7, 2)) FIRM_DAY, "+
						" decode(FIRM_DAY_Y, '', '', substr(FIRM_DAY_Y, 1, 4) || '-' || substr(FIRM_DAY_Y, 5, 2) || '-'||substr(FIRM_DAY_Y, 7, 2)) FIRM_DAY_Y, "+
						" decode(FIRM_DAY_B, '', '', substr(FIRM_DAY_B, 1, 4) || '-' || substr(FIRM_DAY_B, 5, 2) || '-'||substr(FIRM_DAY_B, 7, 2)) FIRM_DAY_B, "+
						" reg_id, reg_dt, update_id, update_dt, ven_code, print_st, etax_not_cau, bank_code, deposit_no, taxregno, nvl(tm_print_yn,'Y') tm_print_yn, "+
						" print_car_st,  "+
						" CON_AGNT_NM2, CON_AGNT_O_TEL2, CON_AGNT_M_TEL2, CON_AGNT_FAX2, CON_AGNT_EMAIL2, CON_AGNT_DEPT2, CON_AGNT_TITLE2 "+
					   " from CLIENT where CLIENT_ID = ? ";
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, client_id);
		    	rs = pstmt.executeQuery();
		
			while(rs.next())
			{
				client.setClient_id		(rs.getString("CLIENT_ID")==null?"":rs.getString("CLIENT_ID"));
				client.setClient_st		(rs.getString("CLIENT_ST")==null?"":rs.getString("CLIENT_ST"));
				client.setClient_nm		(rs.getString("CLIENT_NM")==null?"":rs.getString("CLIENT_NM"));
				client.setFirm_nm		(rs.getString("FIRM_NM")==null?"":rs.getString("FIRM_NM"));
				client.setSsn1			(rs.getString("SSN1")==null?"":rs.getString("SSN1"));
				client.setSsn2			(rs.getString("SSN2")==null?"":rs.getString("SSN2"));
				client.setEnp_no1		(rs.getString("ENP_NO1")==null?"":rs.getString("ENP_NO1"));
				client.setEnp_no2		(rs.getString("ENP_NO2")==null?"":rs.getString("ENP_NO2"));
				client.setEnp_no3		(rs.getString("ENP_NO3")==null?"":rs.getString("ENP_NO3"));
				client.setH_tel			(rs.getString("H_TEL")==null?"":rs.getString("H_TEL"));
				client.setO_tel			(rs.getString("O_TEL")==null?"":rs.getString("O_TEL"));
				client.setM_tel			(rs.getString("M_TEL")==null?"":rs.getString("M_TEL"));
				client.setHomepage		(rs.getString("HOMEPAGE")==null?"":rs.getString("HOMEPAGE"));
				client.setFax			(rs.getString("FAX")==null?"":rs.getString("FAX"));
				client.setBus_cdt		(rs.getString("BUS_CDT")==null?"":rs.getString("BUS_CDT"));
				client.setBus_itm		(rs.getString("BUS_ITM")==null?"":rs.getString("BUS_ITM"));
				client.setHo_addr		(rs.getString("HO_ADDR")==null?"":rs.getString("HO_ADDR"));
				client.setHo_zip		(rs.getString("HO_ZIP")==null?"":rs.getString("HO_ZIP"));
				client.setO_addr		(rs.getString("O_ADDR")==null?"":rs.getString("O_ADDR"));
				client.setO_zip			(rs.getString("O_ZIP")==null?"":rs.getString("O_ZIP"));
				client.setRepre_addr	(rs.getString("REPRE_ADDR")==null?"":rs.getString("REPRE_ADDR"));
				client.setRepre_zip		(rs.getString("REPRE_ZIP")==null?"":rs.getString("REPRE_ZIP"));
				client.setCom_nm		(rs.getString("COM_NM")==null?"":rs.getString("COM_NM"));
				client.setDept			(rs.getString("DEPT")==null?"":rs.getString("DEPT"));
				client.setTitle			(rs.getString("TITLE")==null?"":rs.getString("TITLE"));
				client.setCar_use		(rs.getString("CAR_USE")==null?"":rs.getString("CAR_USE"));
				client.setCon_agnt_nm	(rs.getString("CON_AGNT_NM")==null?"":rs.getString("CON_AGNT_NM"));
				client.setCon_agnt_o_tel(rs.getString("CON_AGNT_O_TEL")==null?"":rs.getString("CON_AGNT_O_TEL"));
				client.setCon_agnt_m_tel(rs.getString("CON_AGNT_M_TEL")==null?"":rs.getString("CON_AGNT_M_TEL"));
				client.setCon_agnt_fax	(rs.getString("CON_AGNT_FAX")==null?"":rs.getString("CON_AGNT_FAX"));
				client.setCon_agnt_email(rs.getString("CON_AGNT_EMAIL")==null?"":rs.getString("CON_AGNT_EMAIL"));
				client.setCon_agnt_dept	(rs.getString("CON_AGNT_DEPT")==null?"":rs.getString("CON_AGNT_DEPT"));
				client.setCon_agnt_title(rs.getString("CON_AGNT_TITLE")==null?"":rs.getString("CON_AGNT_TITLE"));
				client.setEtc			(rs.getString("ETC")==null?"":rs.getString("ETC"));
				client.setOpen_year		(rs.getString("OPEN_YEAR")==null?"":rs.getString("OPEN_YEAR"));
				client.setFirm_price	(rs.getString("FIRM_PRICE")==null?0:Float.parseFloat(rs.getString("FIRM_PRICE")));
				client.setFirm_price_y	(rs.getString("FIRM_PRICE_Y")==null?0:Float.parseFloat(rs.getString("FIRM_PRICE_Y")));
				client.setFirm_price_b	(rs.getString("FIRM_PRICE_B")==null?0:Float.parseFloat(rs.getString("FIRM_PRICE_B")));
				client.setFirm_day		(rs.getString("FIRM_DAY")==null?"":rs.getString("FIRM_DAY"));
				client.setFirm_day_y	(rs.getString("FIRM_DAY_Y")==null?"":rs.getString("FIRM_DAY_Y"));
				client.setFirm_day_b	(rs.getString("FIRM_DAY_B")==null?"":rs.getString("FIRM_DAY_B"));
				client.setReg_id		(rs.getString("reg_id")==null?"":rs.getString("reg_id"));
				client.setReg_dt		(rs.getString("reg_dt")==null?"":rs.getString("reg_dt"));
				client.setUpdate_id		(rs.getString("update_id")==null?"":rs.getString("update_id"));
				client.setUpdate_dt		(rs.getString("update_dt")==null?"":rs.getString("update_dt"));
				client.setVen_code		(rs.getString("ven_code")==null?"":rs.getString("ven_code"));
				client.setPrint_st		(rs.getString("print_st")==null?"":rs.getString("print_st"));
				client.setEtax_not_cau	(rs.getString("etax_not_cau")==null?"":rs.getString("etax_not_cau"));
				client.setBank_code		(rs.getString("bank_code")==null?"":rs.getString("bank_code"));
				client.setDeposit_no	(rs.getString("deposit_no")==null?"":rs.getString("deposit_no"));
				client.setTaxregno		(rs.getString("taxregno")==null?"":rs.getString("taxregno"));
				client.setTm_print_yn	(rs.getString("tm_print_yn")==null?"":rs.getString("tm_print_yn"));
				client.setPrint_car_st	(rs.getString("print_car_st")==null?"":rs.getString("print_car_st"));
				client.setCon_agnt_nm2	(rs.getString("CON_AGNT_NM2")==null?"":rs.getString("CON_AGNT_NM2"));
				client.setCon_agnt_o_tel2(rs.getString("CON_AGNT_O_TEL2")==null?"":rs.getString("CON_AGNT_O_TEL2"));
				client.setCon_agnt_m_tel2(rs.getString("CON_AGNT_M_TEL2")==null?"":rs.getString("CON_AGNT_M_TEL2"));
				client.setCon_agnt_fax2	(rs.getString("CON_AGNT_FAX2")==null?"":rs.getString("CON_AGNT_FAX2"));
				client.setCon_agnt_email2(rs.getString("CON_AGNT_EMAIL2")==null?"":rs.getString("CON_AGNT_EMAIL2"));
				client.setCon_agnt_dept2(rs.getString("CON_AGNT_DEPT2")==null?"":rs.getString("CON_AGNT_DEPT2"));
				client.setCon_agnt_title2(rs.getString("CON_AGNT_TITLE2")==null?"":rs.getString("CON_AGNT_TITLE2"));

			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AddClientDatabase:getClient]\n"+e);
	  		e.printStackTrace();
	  		client = null;
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return client;
		}
	}

	//고객 등록 중보체크-법인/주민등록번호로
	public int checkSSN(String ssn)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;

		String query = "select count(*) from client where  TEXT_DECRYPT(ssn, 'pw' ) =replace('"+ssn+"','-','')";

		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next()){
				count = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		    
	  	} catch (Exception e) {
			System.out.println("[AddClientDatabase:checkSSN]"+e);
			e.printStackTrace();
		} finally {
			try{	
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}			
	}

	//고객 등록 중보체크-법인/주민등록번호와 사업자등록번호로
	public int checkSSN(String ssn, String enp_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;

		String query = "select count(*) from client where  TEXT_DECRYPT(ssn, 'pw' ) =replace('"+ssn+"','-','') and enp_no=replace('"+enp_no+"','-','')";

		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next()){
				count = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		    
	  	} catch (Exception e) {
			System.out.println("[AddClientDatabase:checkSSN(String ssn, String enp_no)]"+e);
			e.printStackTrace();
		} finally {
			try{	
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}			
	}

	//고객 삽입
	public ClientBean insertClient(ClientBean client)
	{
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		String id_sql = " select ltrim(to_char(to_number(MAX(client_id))+1, '000000')) ID from CLIENT ";
		String c_id="";
		try{
				pstmt1 = conn.prepareStatement(id_sql);
		    	rs = pstmt1.executeQuery();
		    	if(rs.next())
		    	{
		    		c_id=rs.getString(1)==null?"":rs.getString(1);
		    	}
				rs.close();
				pstmt1.close();

		} catch (SQLException e) {
	  		e.printStackTrace();
	  	} catch (Exception e) {
	  		e.printStackTrace();
	  	}
	  	
		if(c_id.equals(""))	c_id = "000001";
		client.setClient_id(c_id);
		
		String query = " insert into CLIENT ( CLIENT_ID, CLIENT_ST, CLIENT_NM, FIRM_NM, SSN, ENP_NO, H_TEL, O_TEL, M_TEL, "+
						" HOMEPAGE, FAX, BUS_CDT, BUS_ITM, HO_ADDR, HO_ZIP, O_ADDR, O_ZIP, COM_NM, DEPT, TITLE, CAR_USE, "+
						" CON_AGNT_NM, CON_AGNT_O_TEL, CON_AGNT_M_TEL, CON_AGNT_FAX, CON_AGNT_EMAIL, CON_AGNT_DEPT, "+
						" CON_AGNT_TITLE, ETC, OPEN_YEAR, FIRM_PRICE, FIRM_PRICE_Y, FIRM_PRICE_B, FIRM_DAY, FIRM_DAY_Y, FIRM_DAY_B,"+
						" REG_ID, REG_DT, PRINT_ST, ETAX_NOT_CAU) values ("+
						" ?, ?, ?, ?,  TEXT_ENCRYPT(?, 'pw' ) ,   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
						" ?, to_char(sysdate,'YYYYMMDD'), ?, ?)";		
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  client.getClient_id()	);
			pstmt.setString(2,  client.getClient_st()	);
			pstmt.setString(3,  client.getClient_nm()	);
			pstmt.setString(4,  client.getFirm_nm()		);
			pstmt.setString(5,  client.getSsn1()+client.getSsn2());
			pstmt.setString(6,  client.getEnp_no1()+client.getEnp_no2()+client.getEnp_no3());
			pstmt.setString(7,  client.getH_tel()		);
			pstmt.setString(8,  client.getO_tel()		);
			pstmt.setString(9,  client.getM_tel()		);
			pstmt.setString(10, client.getHomepage()	);
			pstmt.setString(11, client.getFax()			);
			pstmt.setString(12, client.getBus_cdt()		);
			pstmt.setString(13, client.getBus_itm()		);
			pstmt.setString(14, client.getHo_addr()		);
			pstmt.setString(15, client.getHo_zip()		);
			pstmt.setString(16, client.getO_addr()		);
			pstmt.setString(17, client.getO_zip()		);
			pstmt.setString(18, client.getCom_nm()		);
			pstmt.setString(19, client.getDept()		);
			pstmt.setString(20, client.getTitle()		);
			pstmt.setString(21, client.getCar_use()		);
			pstmt.setString(22, client.getCon_agnt_nm()	);
			pstmt.setString(23, client.getCon_agnt_o_tel());
			pstmt.setString(24, client.getCon_agnt_m_tel());
			pstmt.setString(25, client.getCon_agnt_fax());
			pstmt.setString(26, client.getCon_agnt_email());
			pstmt.setString(27, client.getCon_agnt_dept());
			pstmt.setString(28, client.getCon_agnt_title());
			pstmt.setString(29, client.getEtc()			);
		    pstmt.setString(30, client.getOpen_year()	);
		    pstmt.setFloat (31,  client.getFirm_price()	);
		    pstmt.setFloat (32,  client.getFirm_price_y());
		    pstmt.setFloat (33,  client.getFirm_price_b());
		    pstmt.setString(34, client.getFirm_day()	);
		    pstmt.setString(35, client.getFirm_day_y()	);
		    pstmt.setString(36, client.getFirm_day_b()	);
		    pstmt.setString(37, client.getReg_id()		);
		    pstmt.setString(38, client.getPrint_st().trim());
		    pstmt.setString(39, client.getEtax_not_cau());
		    pstmt.executeUpdate();
			pstmt.close();

		    conn.commit();
		} catch (SQLException e) {
		  	System.out.println("[AddClientDatabase:insertClient]\n"+e);
			e.printStackTrace();
			conn.rollback();
	  	} catch (Exception e) {
		  	System.out.println("[AddClientDatabase:insertClient]\n"+e);
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
                if(pstmt1 != null)	pstmt1.close();
			}catch(Exception ignore){}
			closeConnection();
			return client;
		}
	}

	//고객 사업자등록증 이력 삽입
	public boolean insertClientEnp(ClientBean client, String seq,  String cng_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;		
		String query = " insert into CLIENT_ENP_H"+
						" ( CLIENT_ID, SEQ, CLIENT_NM, FIRM_NM, SSN, ENP_NO, BUS_CDT, BUS_ITM,"+//8
						"   HO_ADDR, HO_ZIP, O_ADDR, O_ZIP, CNG_DT, REG_ID, REG_DT, taxregno )"+//15
						" values ("+
						" ?, ?, ?, ?,  TEXT_ENCRYPT(?, 'pw' ) ,  ?, ?, ?,   ?, ?,  ?, ?, replace(?,'-',''), ?, to_char(sysdate,'YYYYMMDD'), ?)";		
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, client.getClient_id	());
			pstmt.setString(2, seq					  );
			pstmt.setString(3, client.getClient_nm	());
			pstmt.setString(4, client.getFirm_nm	());
			pstmt.setString(5, client.getSsn1()+client.getSsn2());
			pstmt.setString(6, client.getEnp_no1()+client.getEnp_no2()+client.getEnp_no3());
			pstmt.setString(7,  client.getBus_cdt	());
			pstmt.setString(8,  client.getBus_itm	());
			pstmt.setString(9,  client.getHo_addr	());
			pstmt.setString(10, client.getHo_zip	());
			pstmt.setString(11, client.getO_addr	());
			pstmt.setString(12, client.getO_zip		());
			pstmt.setString(13, cng_dt                );
		    pstmt.setString(14, client.getReg_id	());
		    pstmt.setString(15, client.getTaxregno	());
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
		} catch (SQLException e) {
			System.out.println("[AddClientDatabase:insertClientEnp]\n"+e);
			System.out.println("[client.getClient_id	()]\n"+client.getClient_id	());
			System.out.println("[seq					  ]\n"+seq					  );
			System.out.println("[client.getClient_nm	()]\n"+client.getClient_nm	());
			System.out.println("[client.getFirm_nm		()]\n"+client.getFirm_nm	());
			System.out.println("[client.getSsn			()]\n"+client.getSsn1()+client.getSsn2());
			System.out.println("[client.getEnp_no		()]\n"+client.getEnp_no1()+client.getEnp_no2()+client.getEnp_no3());
			System.out.println("[client.getBus_cdt		()]\n"+client.getBus_cdt	());
			System.out.println("[client.getBus_itm		()]\n"+client.getBus_itm	());
			System.out.println("[client.getHo_addr		()]\n"+client.getHo_addr	());
			System.out.println("[client.getHo_zip		()]\n"+client.getHo_zip		());
			System.out.println("[client.getO_addr		()]\n"+client.getO_addr		());
			System.out.println("[client.getO_zip		()]\n"+client.getO_zip		());
			System.out.println("[cng_dt                   ]\n"+cng_dt                 );
			System.out.println("[client.getReg_id		()]\n"+client.getReg_id		());
			System.out.println("[client.getTaxregno		()]\n"+client.getTaxregno	());

	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
	  	} catch (Exception e) {
		  	System.out.println("[AddClientDatabase:insertClientEnp]\n"+e);
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//고객 수정
	public boolean updateClient(ClientBean client)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		
		String query = " update CLIENT set "+
						" CLIENT_ST = ?, "+
						" CLIENT_NM = ?, "+
						" FIRM_NM = ?, "+
						" SSN =  TEXT_ENCRYPT(?, 'pw' ), "+
						" ENP_NO = ?, "+
						" H_TEL = ?, "+
						" O_TEL = ?, "+
						" M_TEL = ?, "+
						" HOMEPAGE = ?, "+
						" FAX = ?, "+
						" BUS_CDT = ?, "+
						" BUS_ITM = ?, "+
						" HO_ADDR = ?, "+
						" HO_ZIP = ?, "+
						" O_ADDR = ?, "+
						" O_ZIP = ?, "+
						" COM_NM = ?, "+
						" DEPT = ?, "+
						" TITLE = ?, "+
						" CAR_USE = ?, "+
						" CON_AGNT_NM = ?, "+
						" CON_AGNT_O_TEL = ?, "+
						" CON_AGNT_M_TEL = ?, "+
						" CON_AGNT_FAX = ?, "+
						" CON_AGNT_EMAIL = ?, "+
						" CON_AGNT_DEPT = ?, "+
						" CON_AGNT_TITLE = ?, "+
						" ETC = ?, "+
						" OPEN_YEAR = replace(?,'-',''), "+
						" FIRM_PRICE = ?, "+
						" FIRM_PRICE_Y = ?, "+
						" FIRM_PRICE_B = ?, "+
						" FIRM_DAY = replace(?,'-',''), "+
						" FIRM_DAY_Y = replace(?,'-',''), "+
						" FIRM_DAY_B = replace(?,'-',''), "+
						" UPDATE_ID = ?, "+
						" UPDATE_DT = to_char(sysdate,'YYYYMMDD'),"+
						" print_st=?, "+
						" ven_code=?, "+
						" etax_not_cau=? "+
						" where CLIENT_ID = ?";
		
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, client.getClient_st());
			pstmt.setString(2, client.getClient_nm());
			pstmt.setString(3, client.getFirm_nm());
			pstmt.setString(4, client.getSsn1()+client.getSsn2());
			pstmt.setString(5, client.getEnp_no1()+client.getEnp_no2()+client.getEnp_no3());
			pstmt.setString(6, client.getH_tel());
			pstmt.setString(7, client.getO_tel());
			pstmt.setString(8, client.getM_tel());
			pstmt.setString(9,  client.getHomepage());
			pstmt.setString(10, client.getFax());
			pstmt.setString(11, client.getBus_cdt());
			pstmt.setString(12, client.getBus_itm());
			pstmt.setString(13, client.getHo_addr());
			pstmt.setString(14, client.getHo_zip());
			pstmt.setString(15, client.getO_addr());
			pstmt.setString(16, client.getO_zip());
			pstmt.setString(17, client.getCom_nm());
			pstmt.setString(18, client.getDept());
			pstmt.setString(19, client.getTitle());
			pstmt.setString(20, client.getCar_use());
			pstmt.setString(21, client.getCon_agnt_nm());
			pstmt.setString(22, client.getCon_agnt_o_tel());
			pstmt.setString(23, client.getCon_agnt_m_tel());
			pstmt.setString(24, client.getCon_agnt_fax());
			pstmt.setString(25, client.getCon_agnt_email());
			pstmt.setString(26, client.getCon_agnt_dept());
			pstmt.setString(27, client.getCon_agnt_title());
			pstmt.setString(28, client.getEtc());
		    pstmt.setString(29, client.getOpen_year());
		    pstmt.setFloat (30, client.getFirm_price());
		    pstmt.setFloat (31, client.getFirm_price_y());
		    pstmt.setFloat (32, client.getFirm_price_b());
		    pstmt.setString(33, client.getFirm_day());
		    pstmt.setString(34, client.getFirm_day_y());
		    pstmt.setString(35, client.getFirm_day_b());
		    pstmt.setString(36, client.getUpdate_id());
		    pstmt.setString(37, client.getPrint_st());
		    pstmt.setString(38, client.getVen_code());
		    pstmt.setString(39, client.getEtax_not_cau());
			pstmt.setString(40, client.getClient_id());
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
		} catch (SQLException e) {
			System.out.println("[AddClientDatabase:updateClient]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
	  	} catch (Exception e) {
			System.out.println("[AddClientDatabase:updateClient]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}	

	//고객 수정
	public boolean updateClient2(ClientBean client)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		
		String query = " update CLIENT set "+
						" H_TEL = ?, "+
						" O_TEL = ?, "+
						" M_TEL = ?, "+
						" HOMEPAGE = ?, "+
						" FAX = ?, "+
						" COM_NM = ?, "+
						" DEPT = ?, "+
						" TITLE = ?, "+
						" CAR_USE = ?, "+
						" CON_AGNT_NM = ?, "+
						" CON_AGNT_O_TEL = ?, "+
						" CON_AGNT_M_TEL = ?, "+
						" CON_AGNT_FAX = ?, "+
						" CON_AGNT_EMAIL = ?, "+
						" CON_AGNT_DEPT = ?, "+
						" CON_AGNT_TITLE = ?, "+
						" ETC = ?, "+
						" FIRM_PRICE = ?, "+
						" FIRM_PRICE_Y = ?, "+
						" FIRM_DAY = replace(?,'-',''), "+
						" FIRM_DAY_Y = replace(?,'-',''), "+
						" UPDATE_ID = ?, "+
						" UPDATE_DT = to_char(sysdate,'YYYYMMDD'),"+
						" print_st=?, "+
						" ven_code=?, "+
						" etax_not_cau=?, "+
						" bank_code=?, "+
						" deposit_no=? "+
						" where CLIENT_ID = ?";		
		try 
		{

			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  client.getH_tel());
			pstmt.setString(2,  client.getO_tel());
			pstmt.setString(3,  client.getM_tel());
			pstmt.setString(4,  client.getHomepage());
			pstmt.setString(5,  client.getFax());
			pstmt.setString(6,  client.getCom_nm());
			pstmt.setString(7,  client.getDept());
			pstmt.setString(8,  client.getTitle());
			pstmt.setString(9,  client.getCar_use());
			pstmt.setString(10, client.getCon_agnt_nm());
			pstmt.setString(11, client.getCon_agnt_o_tel());
			pstmt.setString(12, client.getCon_agnt_m_tel());
			pstmt.setString(13, client.getCon_agnt_fax());
			pstmt.setString(14, client.getCon_agnt_email());
			pstmt.setString(15, client.getCon_agnt_dept());
			pstmt.setString(16, client.getCon_agnt_title());
			pstmt.setString(17, client.getEtc());
		    pstmt.setFloat (18, client.getFirm_price());
		    pstmt.setFloat (19, client.getFirm_price_y());
		    pstmt.setString(20, client.getFirm_day());
		    pstmt.setString(21, client.getFirm_day_y());
		    pstmt.setString(22, client.getUpdate_id());
		    pstmt.setString(23, client.getPrint_st());
		    pstmt.setString(24, client.getVen_code());
		    pstmt.setString(25, client.getEtax_not_cau());
		    pstmt.setString(26, client.getBank_code());
		    pstmt.setString(27, client.getDeposit_no());
			pstmt.setString(28, client.getClient_id());
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

	  	} catch (SQLException e) {
			System.out.println("[AddClientDatabase:updateClient2]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
	  	} catch (Exception e) {
			System.out.println("[AddClientDatabase:updateClient2]\n"+e);
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

	//고객 수정
	public boolean updateClient3(ClientBean client)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		
		String query = " update CLIENT set "+
						" CLIENT_ST = ?, "+
						" CLIENT_NM = ?, "+
						" FIRM_NM = ?, "+
						" SSN =  TEXT_ENCRYPT(?, 'pw' ), "+
						" ENP_NO = ?, "+
						" BUS_CDT = ?, "+
						" BUS_ITM = ?, "+
						" HO_ADDR = ?, "+
						" HO_ZIP = ?, "+
						" O_ADDR = ?, "+
						" O_ZIP = ?, "+
						" OPEN_YEAR = replace(?,'-',''), "+
						" VEN_CODE = ?, "+
						" UPDATE_ID = ?, "+
						" UPDATE_DT = to_char(sysdate,'YYYYMMDD'),"+
						" taxregno = ? "+
						" where CLIENT_ID = ?";
		
		try 
		{

			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, client.getClient_st());
			pstmt.setString(2, client.getClient_nm());
			pstmt.setString(3, client.getFirm_nm());
			pstmt.setString(4, client.getSsn1()+client.getSsn2());
			pstmt.setString(5, client.getEnp_no1()+client.getEnp_no2()+client.getEnp_no3());
			pstmt.setString(6, client.getBus_cdt());
			pstmt.setString(7, client.getBus_itm());
			pstmt.setString(8, client.getHo_addr());
			pstmt.setString(9, client.getHo_zip());
			pstmt.setString(10, client.getO_addr());
			pstmt.setString(11, client.getO_zip());
		    pstmt.setString(12, client.getOpen_year());
		    pstmt.setString(13, client.getVen_code());
		    pstmt.setString(14, client.getUpdate_id());
		    pstmt.setString(15, client.getTaxregno());
			pstmt.setString(16, client.getClient_id());
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
		} catch (SQLException e) {
			System.out.println("[AddClientDatabase:updateClient3]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
	  	} catch (Exception e) {
			System.out.println("[AddClientDatabase:updateClient3]\n"+e);
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

	//고객 특이사항 수정
	public boolean updateClient_etc(String client_id, String etc)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "update CLIENT set ETC=? where CLIENT_ID=?";
		try 
		{
			conn.setAutoCommit(false);

				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, etc);
				pstmt.setString(2, client_id);
			    pstmt.executeUpdate();
				pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddClientDatabase:updateClient_etc]"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}

	//고객 특이사항 수정
	public boolean updateClient_etc(String client_id, String etc, String user_id)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "update CLIENT set ETC=?, update_dt=to_char(sysdate,'YYYYMMDD'), update_id=? where CLIENT_ID=?";
		try 
		{
			conn.setAutoCommit(false);

				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, etc);
				pstmt.setString(2, user_id);
				pstmt.setString(3, client_id);
			    pstmt.executeUpdate();
				pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddClientDatabase:updateClient_etc]"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}

	/**
	 *	거래처별 사용본거지 리스트
	 */
	public Vector getClientSites(String client_id)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	" select"+
							" CLIENT_ID, REG_ID, R_SITE, SEQ,"+
							" decode(REG_DT, '', '', substr(REG_DT, 1, 4)||'-'||substr(REG_DT, 5, 2)||'-'||substr(REG_DT, 7, 2)) REG_DT"+
							" from client_site "+
							" where CLIENT_ID = ? order by r_site";
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, client_id);
		    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				ClientSiteBean c_site = new ClientSiteBean();
				c_site.setClient_id(rs.getString("CLIENT_ID")==null?"":rs.getString("CLIENT_ID"));
				c_site.setReg_id(rs.getString("REG_ID")==null?"":rs.getString("REG_ID"));
				c_site.setR_site(rs.getString("R_SITE")==null?"":rs.getString("R_SITE"));
				c_site.setReg_dt(rs.getString("REG_DT")==null?"":rs.getString("REG_DT"));
				c_site.setSeq(rs.getString("SEQ")==null?"":rs.getString("SEQ"));
				vt.add(c_site);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println(e);
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
	 *	거래처별 사용본거지 리스트
	 */
	public Vector getClientSiteList(String client_id, String t_wd)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	" select client_id, seq, r_site, reg_dt, reg_id, site_st, site_jang, addr, zip,"+
									"   TEXT_DECRYPT(enp_no, 'pw' ) enp_no, bus_cdt, bus_itm, open_year, tel, fax, ven_code, upd_dt, upd_id, agnt_nm, agnt_tel, "+
									"   agnt_m_tel, agnt_email , agnt_dept, agnt_title, agnt_fax, bigo_value, taxregno "+				
								   " from client_site "+
							      " where CLIENT_ID = '"+client_id+"' ";

		if(!t_wd.equals(""))	query += " and r_site like '%"+t_wd+"%'";

		query += " order by r_site";

		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				ClientSiteBean c_site = new ClientSiteBean();
				c_site.setClient_id(rs.getString("CLIENT_ID")==null?"":rs.getString("CLIENT_ID"));
				c_site.setSeq(rs.getString("SEQ")==null?"":rs.getString("SEQ"));
				c_site.setR_site(rs.getString("R_SITE")==null?"":rs.getString("R_SITE"));
				c_site.setReg_dt(rs.getString("REG_DT")==null?"":rs.getString("REG_DT"));
				c_site.setReg_id(rs.getString("REG_ID")==null?"":rs.getString("REG_ID"));
				c_site.setSite_st(rs.getString("SITE_ST")==null?"":rs.getString("SITE_ST"));
				c_site.setSite_jang(rs.getString("SITE_JANG")==null?"":rs.getString("SITE_JANG"));
				c_site.setAddr(rs.getString("ADDR")==null?"":rs.getString("ADDR"));
				c_site.setZip(rs.getString("ZIP")==null?"":rs.getString("ZIP"));
				c_site.setEnp_no(rs.getString("ENP_NO")==null?"":rs.getString("ENP_NO"));
				c_site.setBus_cdt(rs.getString("BUS_CDT")==null?"":rs.getString("BUS_CDT"));
				c_site.setBus_itm(rs.getString("BUS_ITM")==null?"":rs.getString("BUS_ITM"));
				c_site.setOpen_year(rs.getString("OPEN_YEAR")==null?"":rs.getString("OPEN_YEAR"));
				c_site.setTel(rs.getString("TEL")==null?"":rs.getString("TEL"));
				c_site.setFax(rs.getString("FAX")==null?"":rs.getString("FAX"));
				c_site.setVen_code(rs.getString("VEN_CODE")==null?"":rs.getString("VEN_CODE"));
				c_site.setUpd_dt(rs.getString("UPD_DT")==null?"":rs.getString("UPD_DT"));
				c_site.setUpd_id(rs.getString("UPD_ID")==null?"":rs.getString("UPD_ID"));
				c_site.setAgnt_nm(rs.getString("AGNT_NM")==null?"":rs.getString("AGNT_NM"));
				c_site.setAgnt_tel(rs.getString("AGNT_TEL")==null?"":rs.getString("AGNT_TEL"));
				c_site.setAgnt_m_tel(rs.getString("agnt_m_tel")==null?"":rs.getString("agnt_m_tel"));
				c_site.setAgnt_email(rs.getString("agnt_email")==null?"":rs.getString("agnt_email"));
				c_site.setAgnt_dept(rs.getString("agnt_dept")==null?"":rs.getString("agnt_dept"));
				c_site.setAgnt_title(rs.getString("agnt_title")==null?"":rs.getString("agnt_title"));
				c_site.setAgnt_fax(rs.getString("agnt_fax")==null?"":rs.getString("agnt_fax"));
				c_site.setBigo_value(rs.getString("bigo_value")==null?"":rs.getString("bigo_value"));
				c_site.setTaxregno(rs.getString("taxregno")==null?"":rs.getString("taxregno"));
				

				vt.add(c_site);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println(e);
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
	 *	거래처별 사용본거지 리스트
	 */
	public ClientSiteBean getClientSite(String client_id, String site_id)
	{
		getConnection();
		ClientSiteBean c_site = new ClientSiteBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
				
		String query = 	" select client_id, seq, r_site, reg_dt, reg_id, site_st, site_jang, addr, zip,"+
						"        TEXT_DECRYPT(enp_no, 'pw' ) enp_no, bus_cdt, bus_itm, open_year, tel, fax, ven_code, upd_dt, upd_id, "+
						"        agnt_nm, agnt_tel, agnt_m_tel, agnt_email , agnt_dept, agnt_title, agnt_fax, "+
						"        taxregno,  bigo_value, "+				
						"        agnt_nm2, agnt_tel2, agnt_m_tel2, agnt_email2 , agnt_dept2, agnt_title2, agnt_fax2 "+
						" from client_site "+
						" where CLIENT_ID = '"+client_id+"' and seq = '"+site_id+"' ";

		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{
				c_site.setClient_id(rs.getString("CLIENT_ID")==null?"":rs.getString("CLIENT_ID"));
				c_site.setSeq(rs.getString("SEQ")==null?"":rs.getString("SEQ"));
				c_site.setR_site(rs.getString("R_SITE")==null?"":rs.getString("R_SITE"));
				c_site.setReg_dt(rs.getString("REG_DT")==null?"":rs.getString("REG_DT"));
				c_site.setReg_id(rs.getString("REG_ID")==null?"":rs.getString("REG_ID"));
				c_site.setSite_st(rs.getString("SITE_ST")==null?"":rs.getString("SITE_ST"));
				c_site.setSite_jang(rs.getString("SITE_JANG")==null?"":rs.getString("SITE_JANG"));
				c_site.setAddr(rs.getString("ADDR")==null?"":rs.getString("ADDR"));
				c_site.setZip(rs.getString("ZIP")==null?"":rs.getString("ZIP"));
				c_site.setEnp_no(rs.getString("ENP_NO")==null?"":rs.getString("ENP_NO"));
				c_site.setBus_cdt(rs.getString("BUS_CDT")==null?"":rs.getString("BUS_CDT"));
				c_site.setBus_itm(rs.getString("BUS_ITM")==null?"":rs.getString("BUS_ITM"));
				c_site.setOpen_year(rs.getString("OPEN_YEAR")==null?"":rs.getString("OPEN_YEAR"));
				c_site.setTel(rs.getString("TEL")==null?"":rs.getString("TEL"));
				c_site.setFax(rs.getString("FAX")==null?"":rs.getString("FAX"));
				c_site.setAgnt_nm(rs.getString("AGNT_NM")==null?"":rs.getString("AGNT_NM"));
				c_site.setAgnt_tel(rs.getString("AGNT_TEL")==null?"":rs.getString("AGNT_TEL"));
				c_site.setVen_code(rs.getString("VEN_CODE")==null?"":rs.getString("VEN_CODE"));
				c_site.setUpd_dt(rs.getString("UPD_DT")==null?"":rs.getString("UPD_DT"));
				c_site.setUpd_id(rs.getString("UPD_ID")==null?"":rs.getString("UPD_ID"));
				c_site.setAgnt_m_tel(rs.getString("AGNT_M_TEL")==null?"":rs.getString("AGNT_M_TEL"));
				c_site.setAgnt_fax	(rs.getString("AGNT_FAX")==null?"":rs.getString("AGNT_FAX"));
				c_site.setAgnt_email(rs.getString("AGNT_EMAIL")==null?"":rs.getString("AGNT_EMAIL"));
				c_site.setAgnt_dept	(rs.getString("AGNT_DEPT")==null?"":rs.getString("AGNT_DEPT"));
				c_site.setAgnt_title(rs.getString("AGNT_TITLE")==null?"":rs.getString("AGNT_TITLE"));
				c_site.setTaxregno(rs.getString("taxregno")==null?"":rs.getString("taxregno"));
				c_site.setBigo_value(rs.getString("bigo_value")==null?"":rs.getString("bigo_value"));
				c_site.setAgnt_nm2(rs.getString("AGNT_NM2")==null?"":rs.getString("AGNT_NM2"));
				c_site.setAgnt_tel2(rs.getString("AGNT_TEL2")==null?"":rs.getString("AGNT_TEL2"));
				c_site.setAgnt_m_tel2(rs.getString("AGNT_M_TEL2")==null?"":rs.getString("AGNT_M_TEL2"));
				c_site.setAgnt_fax2(rs.getString("AGNT_FAX2")==null?"":rs.getString("AGNT_FAX2"));
				c_site.setAgnt_email2(rs.getString("AGNT_EMAIL2")==null?"":rs.getString("AGNT_EMAIL2"));
				c_site.setAgnt_dept2(rs.getString("AGNT_DEPT2")==null?"":rs.getString("AGNT_DEPT2"));
				c_site.setAgnt_title2(rs.getString("AGNT_TITLE2")==null?"":rs.getString("AGNT_TITLE2"));

			
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println(e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return c_site;
		}
	}

	/**
	 *	거래처별 사용본거지 조회
	 */
	public String getClientSiteNm(String client_id, String r_site)
	{
		getConnection();
		String r_site_nm = "";
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	" select R_SITE from client_site where CLIENT_ID=? and SEQ=? ";
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, client_id);
			pstmt.setString(2, r_site);
			rs = pstmt.executeQuery();
    	
			if(rs.next()){
				r_site_nm = rs.getString(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println(e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return r_site_nm;
		}
	}


	/**
	 *	거래처 사용본거지 INSERT
	 */
	public boolean insertClientSite(ClientSiteBean c_site)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		String seq="";

		String id_sql = " select nvl(ltrim(to_char(to_number(MAX(seq))+1, '00')), '01') ID from CLIENT_SITE where CLIENT_ID=?";

		String query  = " insert into CLIENT_SITE (CLIENT_ID, REG_ID, R_SITE, REG_DT, SEQ,"+
						" site_st, site_jang, enp_no, zip, addr, bus_cdt, bus_itm, open_year, tel, fax, agnt_nm, agnt_tel,"+
						" agnt_m_tel, agnt_fax, agnt_email, agnt_dept, agnt_title, taxregno, bigo_value, ven_code,"+
						" agnt_nm2, agnt_tel2, agnt_m_tel2, agnt_fax2, agnt_email2, agnt_dept2, agnt_title2 ) "+
						" values (?, ?, ?, to_char(sysdate,'YYYYMMDD'), ?,"+
						" ?, ?,   TEXT_ENCRYPT(replace(?,'-','') , 'pw' ) ,   ?, ?, ?, ?, replace(?,'-',''), ?, ?, ?, ?,"+
						" ?, ?, ?, ?, ?, ?, ?, ?, "+
						" ?, ?, ?, ?, ?, ?, ? )";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(id_sql);
			pstmt.setString(1, c_site.getClient_id());
		   	rs = pstmt.executeQuery();
		   	if(rs.next())
		   	{
		   		seq=rs.getString(1)==null?"":rs.getString(1);
		   	}
			rs.close();
			pstmt.close();

		    c_site.setSeq(seq);

			pstmt1 = conn.prepareStatement(query);
			pstmt1.setString(1,  c_site.getClient_id());
			pstmt1.setString(2,  c_site.getReg_id());
			pstmt1.setString(3,  c_site.getR_site());
			pstmt1.setString(4,  c_site.getSeq());
			pstmt1.setString(5,  c_site.getSite_st());
			pstmt1.setString(6,  c_site.getSite_jang());
			pstmt1.setString(7,  c_site.getEnp_no());
			pstmt1.setString(8,  c_site.getZip());
			pstmt1.setString(9, c_site.getAddr());
			pstmt1.setString(10, c_site.getBus_cdt());
			pstmt1.setString(11, c_site.getBus_itm());
			pstmt1.setString(12, c_site.getOpen_year());
			pstmt1.setString(13, c_site.getTel());
			pstmt1.setString(14, c_site.getFax());
			pstmt1.setString(15, c_site.getAgnt_nm());
			pstmt1.setString(16, c_site.getAgnt_tel());
			pstmt1.setString(17, c_site.getAgnt_m_tel());
			pstmt1.setString(18, c_site.getAgnt_fax());
			pstmt1.setString(19, c_site.getAgnt_email());
			pstmt1.setString(20, c_site.getAgnt_dept());
			pstmt1.setString(21, c_site.getAgnt_title());
			pstmt1.setString(22, c_site.getTaxregno());
			pstmt1.setString(23, c_site.getBigo_value());
			pstmt1.setString(24, c_site.getVen_code());
			pstmt1.setString(25, c_site.getAgnt_nm2());
			pstmt1.setString(26, c_site.getAgnt_tel2());
			pstmt1.setString(27, c_site.getAgnt_m_tel2());
			pstmt1.setString(28, c_site.getAgnt_fax2());
			pstmt1.setString(29, c_site.getAgnt_email2());
			pstmt1.setString(30, c_site.getAgnt_dept2());
			pstmt1.setString(31, c_site.getAgnt_title2());
	        pstmt1.executeUpdate();
	        pstmt1.close();

			conn.commit();

		} catch (SQLException e) {
			System.out.println(e);
			flag = false;
	  		e.printStackTrace();
			conn.rollback();
	  	} catch (Exception e) {
			System.out.println(e);
	  		flag = false;
	  		e.printStackTrace();
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
	 *	거래처 사용본거지 UPDATE
	 */
	public boolean updateClientSite(ClientSiteBean c_site)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query  = " update CLIENT_SITE set"+
						" upd_id=?,"+
						" upd_dt=to_char(sysdate,'YYYYMMDD'),"+
						" r_site=?,"+
						" site_st=?,"+
						" site_jang=?,"+
						" enp_no=TEXT_ENCRYPT(replace(?,'-',''), 'pw' ) ,"+
						" zip=?,"+
						" addr=?,"+
						" bus_cdt=?,"+
						" bus_itm=?,"+
						" open_year=replace(?,'-',''),"+
						" tel=?,"+
						" fax=?,"+
						" agnt_nm=?,"+
						" agnt_tel=?,"+
						" ven_code=?,"+
						" agnt_m_tel=?, agnt_fax=?, agnt_email=?, agnt_dept=?, agnt_title=?, taxregno=?, bigo_value=?,"+
						" agnt_nm2=?, agnt_tel2=?, agnt_m_tel2=?, agnt_fax2=?, agnt_email2=?, agnt_dept2=?, agnt_title2=? "+
						" where CLIENT_ID=? and SEQ=?";

		try
		{
			conn.setAutoCommit(false);
				
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1,  c_site.getUpd_id());
			pstmt.setString(2,  c_site.getR_site());
			pstmt.setString(3,  c_site.getSite_st());
			pstmt.setString(4,  c_site.getSite_jang());
			pstmt.setString(5,  c_site.getEnp_no());
			pstmt.setString(6,  c_site.getZip());
			pstmt.setString(7,  c_site.getAddr());
			pstmt.setString(8,  c_site.getBus_cdt());
			pstmt.setString(9,  c_site.getBus_itm());
			pstmt.setString(10, c_site.getOpen_year());
			pstmt.setString(11, c_site.getTel());
			pstmt.setString(12, c_site.getFax());
			pstmt.setString(13, c_site.getAgnt_nm());
			pstmt.setString(14, c_site.getAgnt_tel());
			pstmt.setString(15, c_site.getVen_code());
			pstmt.setString(16, c_site.getAgnt_m_tel());
			pstmt.setString(17, c_site.getAgnt_fax());
			pstmt.setString(18, c_site.getAgnt_email());
			pstmt.setString(19, c_site.getAgnt_dept());
			pstmt.setString(20, c_site.getAgnt_title());
			pstmt.setString(21, c_site.getTaxregno());
			pstmt.setString(22, c_site.getBigo_value());
			pstmt.setString(23, c_site.getAgnt_nm2());
			pstmt.setString(24, c_site.getAgnt_tel2());
			pstmt.setString(25, c_site.getAgnt_m_tel2());
			pstmt.setString(26, c_site.getAgnt_fax2());
			pstmt.setString(27, c_site.getAgnt_email2());
			pstmt.setString(28, c_site.getAgnt_dept2());
			pstmt.setString(29, c_site.getAgnt_title2());
			pstmt.setString(30, c_site.getClient_id());
			pstmt.setString(31, c_site.getSeq());
		    pstmt.executeUpdate();
		    
		    pstmt.close();
		    conn.commit();

		} catch (SQLException e) {
			System.out.println(e);
			flag = false;
	  		e.printStackTrace();
	  		conn.rollback();
	  	} catch (Exception e) {
			System.out.println(e);
	  		flag = false;
	  		e.printStackTrace();
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	/**
	 *	거래처 사용본거지 DELETE
	 */
	public boolean deleteClientSite(String client_id, String del[])
	{
		getConnection();
		boolean flag = true;
		Statement stmt = null;
		String query  = " delete from CLIENT_SITE where CLIENT_ID='"+client_id+"' and SEQ in (";

		try
		{
			conn.setAutoCommit(false);

			for(int i=0 ; i<del.length ; i++){
				if(i == (del.length -1))	query +=del[i];
				else						query +=del[i]+", ";
			}
			query+=")";
		
			stmt = conn.createStatement();
			stmt.executeUpdate(query);
			
			stmt.close();
			conn.commit();

	  	} catch (Exception e) {
			System.out.println(e);
	  		flag = false;
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
                if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	/**
	 *	고객 USER ID
	 */
	public ClientUserBean getClientUser(String client_id)
	{
		getConnection();
		ClientUserBean c_user = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	" select"+
							" rtrim(USER_ID) USER_ID, USER_PSD, CLIENT_ID"+
							" from CL_USER"+
							" where CLIENT_ID = ?";
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, client_id);
		    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				c_user = new ClientUserBean();
				c_user.setUser_id(rs.getString("USER_ID")==null?"":rs.getString("USER_ID"));
				c_user.setUser_psd(rs.getString("USER_PSD")==null?"":rs.getString("USER_PSD"));
				c_user.setClient_id(rs.getString("CLIENT_ID")==null?"":rs.getString("CLIENT_ID"));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return c_user;
		}
	}	

	//고객메일수집---------------------------------------------------------------------------------------------------------------

	public Vector getClientMgrList(String client_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" a.rent_dt, a.use_yn, a.rent_l_cd, a.rent_mng_id, a.use_yn, a.p_zip, nvl(a.p_addr,'미등록') p_addr, a.tax_agnt, a.tax_type, b.firm_nm, c.cnt, b.client_nm, nvl(b.o_tel,nvl(b.m_tel,b.h_tel)) tel,"+
				" g.car_no,"+
				" d.mgr_id as mgr_id1, nvl(d.mgr_nm,'미등록')||' '||d.mgr_title as mgr_nm1, nvl(d.mgr_m_tel,d.mgr_tel) mgr_tel1, d.mgr_email as mgr_email1, d.lic_no AS mgr_lic_no1,"+
				" e.mgr_id as mgr_id2, nvl(e.mgr_nm,'미등록')||' '||e.mgr_title as mgr_nm2, nvl(e.mgr_m_tel,e.mgr_tel) mgr_tel2, e.mgr_email as mgr_email2, e.lic_no AS mgr_lic_no2,"+
				" f.mgr_id as mgr_id3, nvl(f.mgr_nm,'미등록')||' '||f.mgr_title as mgr_nm3, nvl(f.mgr_m_tel,f.mgr_tel) mgr_tel3, f.mgr_email as mgr_email3, f.lic_no AS mgr_lic_no3,"+
				" nvl(a.lic_no,'미등록') AS lic_no, nvl(a.mgr_lic_no,'') AS mgr_lic_no, a.mgr_lic_emp, a.mgr_lic_rel "+		
				" from cont a, client b,"+
				" (select client_id, count(0) cnt from cont where nvl(use_yn,'Y')='Y' and car_st in ('1','3','4') group by client_id) c,"+
				" (select * from car_mgr where mgr_st='차량이용자') d,"+
				" (select * from car_mgr where mgr_st='차량관리자') e,"+
				" (select * from car_mgr where mgr_st='회계관리자') f,"+
				" car_reg g"+
				" where a.client_id='"+client_id+"' and a.car_st in ('1','3','4') "+
				" and a.client_id=b.client_id "+
				" and a.client_id=c.client_id(+)"+
				" and a.rent_l_cd=d.rent_l_cd(+)"+
				" and a.rent_l_cd=e.rent_l_cd(+)"+
				" and a.rent_l_cd=f.rent_l_cd(+)"+
				" and a.car_mng_id=g.car_mng_id(+) ";

		query += " order by a.use_yn desc, g.car_no";
		
		
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
			System.out.println("[AddClientDatabase:getClientMgrList]\n"+e);
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
	 *	한거래처 관계자 동일인물 이메일주소 자동입력
	 */
	public boolean updateClientMgrEmail(String client_id, String mgr_nm, String mgr_email, String email_yn)
	{
		getConnection();
		boolean flag = true;
		Statement stmt = null;
		String query  = " update car_mgr set mgr_email='"+mgr_email+"', email_yn='"+email_yn+"'"+
						" where mgr_nm='"+mgr_nm+"' and mgr_email is null and rent_l_cd in (select rent_l_cd from cont where client_id='"+client_id+"' and nvl(use_yn,'Y')='Y')";

		try
		{
			conn.setAutoCommit(false);
			
			stmt = conn.createStatement();
			stmt.executeUpdate(query);
			
			stmt.close();
			conn.commit();
	  	} catch (Exception e) {
			System.out.println(e);
	  		flag = false;
	  		e.printStackTrace();
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
                if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//거래처별 담당자 이메일
	public Vector getClientMgrEmailList(String client_id, String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select mgr_st, mgr_nm, mgr_email from cont a, car_mgr b"+
				" where a.rent_l_cd=b.rent_l_cd and a.client_id='"+client_id+"'";

		if(!rent_l_cd.equals(""))	query += " and a.rent_l_cd='"+rent_l_cd+"'";
		else						query += " and b.mgr_email is not null and b.mgr_email like '%@%'";

		query += " group by mgr_st, mgr_nm, mgr_email order by mgr_st, mgr_nm, mgr_email";		
		
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
			System.out.println("[AddClientDatabase:getClientMgrEmailList]\n"+e);
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

	//사원별 이메일 등록 현황
	public Vector getClientMgrEmailStat(String gubun2, String dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String where = "";		
		String who = "bus_id2";

		if(gubun2.equals("1"))	who = "bus_id";

		if(dt.equals("1"))	where = " and a.rent_dt = to_char(sysdate,'YYYYMMDD')";
		if(dt.equals("2"))	where = " and a.rent_dt like to_char(sysdate,'YYYYMM')||'%'";
	

		query = " select"+
				" ff.br_nm,  co.nm  dept_nm,"+
				" ee.user_nm, ee.user_id, aa.cont_cnt, bb.client_cnt, cc.*, dd.*,"+
				" trunc(((cc.mgr_e_yy_cnt1+cc.mgr_e_yy_cnt2+cc.mgr_e_yy_cnt3+dd.emp_e_yy_cnt1+dd.emp_e_yy_cnt2)/(cc.mgr_cnt1+cc.mgr_cnt2+cc.mgr_cnt3+dd.emp_cnt1+dd.emp_cnt2 -cc.mgr_e_n_cnt1-cc.mgr_e_n_cnt2-cc.mgr_e_n_cnt3-dd.emp_e_n_cnt1-dd.emp_e_n_cnt2)*100),0) reg_per,"+
				" (cc.mgr_cnt1+cc.mgr_cnt2+cc.mgr_cnt3+dd.emp_cnt1+dd.emp_cnt2 -cc.mgr_e_n_cnt1-cc.mgr_e_n_cnt2-cc.mgr_e_n_cnt3-dd.emp_e_n_cnt1-dd.emp_e_n_cnt2) tot_cnt, (cc.mgr_e_yy_cnt1+cc.mgr_e_yy_cnt2+cc.mgr_e_yy_cnt3+dd.emp_e_yy_cnt1+dd.emp_e_yy_cnt2) reg_cnt"+
				" from"+
				" (select a."+who+", count(*) cont_cnt from cont a where nvl(a.use_yn,'Y')='Y' "+where+" and a.car_st in ('1','3') group by a."+who+") aa,"+
				" (select a."+who+", count(*) client_cnt from (select a."+who+", a.client_id, count(*) cnt from cont a where nvl(a.use_yn,'Y')='Y' "+where+" and a.car_st in ('1','3') group by a."+who+", a.client_id, a.r_site) a group by a."+who+") bb,"+
				" (select"+
				" a."+who+","+
				" count(decode(b.mgr_st,'차량이용자',b.mgr_nm)) mgr_cnt1,"+
				" count(decode(b.mgr_st,'차량이용자',decode(b.email_yn,'N',b.mgr_nm))) mgr_e_n_cnt1,"+
				" count(decode(b.mgr_st,'차량이용자',decode(nvl(b.email_yn,'Y'),'Y',decode(b.mgr_email,'','',b.mgr_email)))) mgr_e_yy_cnt1,"+
				" count(decode(b.mgr_st,'차량이용자',decode(nvl(b.email_yn,'Y'),'Y',decode(b.mgr_email,'',b.mgr_nm)))) mgr_e_yn_cnt1,"+
				" count(decode(b.mgr_st,'차량관리자',b.mgr_nm)) mgr_cnt2,"+
				" count(decode(b.mgr_st,'차량관리자',decode(b.email_yn,'N',b.mgr_nm))) mgr_e_n_cnt2,"+
				" count(decode(b.mgr_st,'차량관리자',decode(nvl(b.email_yn,'Y'),'Y',decode(b.mgr_email,'','',b.mgr_email)))) mgr_e_yy_cnt2,"+
				" count(decode(b.mgr_st,'차량관리자',decode(nvl(b.email_yn,'Y'),'Y',decode(b.mgr_email,'',b.mgr_nm)))) mgr_e_yn_cnt2,"+
				" count(decode(b.mgr_st,'회계관리자',b.mgr_nm)) mgr_cnt3,"+
				" count(decode(b.mgr_st,'회계관리자',decode(b.email_yn,'N',b.mgr_nm))) mgr_e_n_cnt3,"+
				" count(decode(b.mgr_st,'회계관리자',decode(nvl(b.email_yn,'Y'),'Y',decode(b.mgr_email,'','',b.mgr_email)))) mgr_e_yy_cnt3,"+
				" count(decode(b.mgr_st,'회계관리자',decode(nvl(b.email_yn,'Y'),'Y',decode(b.mgr_email,'',b.mgr_nm)))) mgr_e_yn_cnt3"+
				" from cont a, car_mgr b"+
				" where nvl(a.use_yn,'Y')='Y' and a.car_st <>'2' "+where+""+
				" and a.rent_l_cd=b.rent_l_cd and b.mgr_nm is not null"+
				" group by a."+who+") cc,"+
				" (select"+
				" a."+who+","+
				" count(decode(b.agnt_st,'1',b.emp_id)) emp_cnt1,"+
				" count(decode(b.agnt_st,'1',decode(c.use_yn,'N',b.emp_id))) emp_e_n_cnt1,"+
				" count(decode(b.agnt_st,'1',decode(nvl(c.use_yn,'Y'),'Y',decode(c.emp_email,'','',b.emp_id)))) emp_e_yy_cnt1,"+
				" count(decode(b.agnt_st,'1',decode(nvl(c.use_yn,'Y'),'Y',decode(c.emp_email,'',b.emp_id)))) emp_e_yn_cnt1,"+
				" count(decode(b.agnt_st,'2',b.emp_id)) emp_cnt2,"+
				" count(decode(b.agnt_st,'2',decode(c.use_yn,'N',b.emp_id))) emp_e_n_cnt2,"+
				" count(decode(b.agnt_st,'2',decode(nvl(c.use_yn,'Y'),'Y',decode(c.emp_email,'','',b.emp_id)))) emp_e_yy_cnt2,"+
				" count(decode(b.agnt_st,'2',decode(nvl(c.use_yn,'Y'),'Y',decode(c.emp_email,'',b.emp_id)))) emp_e_yn_cnt2"+
				" from cont a, commi b, car_off_emp c"+
				" where nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3','4') "+where+""+
				" and a.rent_l_cd=b.rent_l_cd"+
				" and b.emp_id=c.emp_id"+
				" group by a."+who+") dd,"+
				" users ee, branch ff,  ( select  * from code where c_st='0002' and code<>'0000' ) co  "+
				" where aa."+who+"=bb."+who+"(+)"+
				" and aa."+who+"=cc."+who+"(+)"+
				" and aa."+who+"=dd."+who+"(+) and ee.dept_id = co.code "+
				" and aa."+who+"=ee.user_id and ee.br_id=ff.br_id"+
//				" order by decode(ee.br_id,'S1',1,'K1',2,'B1',3), ee.dept_id, decode(ee.user_pos,'대리',1,'사원',2,0), ee.enter_dt";
				" order by "+
				" trunc(((cc.mgr_e_yy_cnt1+cc.mgr_e_yy_cnt2+cc.mgr_e_yy_cnt3+dd.emp_e_yy_cnt1+dd.emp_e_yy_cnt2)/(cc.mgr_cnt1+cc.mgr_cnt2+cc.mgr_cnt3+dd.emp_cnt1+dd.emp_cnt2 -cc.mgr_e_n_cnt1-cc.mgr_e_n_cnt2-cc.mgr_e_n_cnt3-dd.emp_e_n_cnt1-dd.emp_e_n_cnt2)*100),0) desc";
		
		try {
			
			//   System.out.println("query=" + query);
			   
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
				     		         
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"0":rs.getString(columnName));
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AddClientDatabase:getClientMgrEmailStat]\n"+e);
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

	public Vector getClientMgrEmailList(String dt, String gubun2, String gubun3, String gubun4, String gubun5, String sort)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String where = "";		
		String who = "bus_id2";

		if(gubun2.equals("1"))	who = "bus_id";

		if(dt.equals("1"))	where = " and a.rent_dt = to_char(sysdate,'YYYYMMDD')";
		if(dt.equals("2"))	where = " and a.rent_dt like to_char(sysdate,'YYYYMM')||'%'";

		query = " select"+
				" b.firm_nm, a.client_id, c.car_no, nvl(c.car_nm,f.car_nm) car_nm, a.st, a.gubun, a.name, a.dept, a.title, a.email, decode(a.email_yn,'N','수신거부') email_yn"+
				" from"+
				" ("+
				" select a.rent_l_cd, a.bus_id, a.bus_id2, a.client_id, a.car_mng_id, a.use_yn, a.car_st, 'MGR' st, b.mgr_st gubun, b.mgr_nm name, b.mgr_dept dept, b.mgr_title title, b.mgr_email email, b.email_yn from cont a, car_mgr b where a.rent_l_cd=b.rent_l_cd and b.mgr_nm is not null "+where+""+
				" union all"+
				" select a.rent_l_cd, a.bus_id, a.bus_id2, a.client_id, a.car_mng_id, a.use_yn, a.car_st, 'EMP' st, decode(b.agnt_st,'1','영업담당자','출고담당자') gubun, c.emp_nm name, e.nm||' '||d.car_off_nm dept, c.emp_pos title, c.emp_email email, c.use_yn as email_yn from cont a, commi b, car_off_emp c, car_off d, code e where a.rent_l_cd=b.rent_l_cd and b.emp_id=c.emp_id and c.car_off_id=d.car_off_id and d.car_comp_id=e.code and e.c_st='0001' "+where+""+
				" ) a, client b, car_reg c, car_etc d, car_nm e, car_mng f"+
				" where"+
				" nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3','4') "+
				" and a.client_id=b.client_id and a.car_mng_id=c.car_mng_id(+) and a.rent_l_cd=d.rent_l_cd and d.car_id=e.car_id and d.car_seq=e.car_seq and e.car_comp_id=f.car_comp_id and e.car_cd=f.code";

		if(gubun2.equals("1") && !gubun3.equals(""))	query += " and a.bus_id='"+gubun3+"'";
		if(gubun2.equals("2") && !gubun3.equals(""))	query += " and a.bus_id2='"+gubun3+"'";

		if(!gubun4.equals(""))	query += " and a.gubun='"+gubun4+"'";

		if(gubun5.equals("1"))	query += " and a.email is not null and a.email not in ('@','無')";
		if(gubun5.equals("2"))	query += " and nvl(a.email_yn,'Y')='Y' and a.email is null and a.email in ('@','無')";
		if(gubun5.equals("3"))	query += " and a.email_yn='N'";

		
		query += " order by a.st desc, b.firm_nm, a.name";
		
		
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
			System.out.println("[AddClientDatabase:getClientMgrEmailList]\n"+e);
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

	public Vector getClientContStat(String dt, String ref_dt1, String ref_dt2, String gubun2, String gubun3, String gubun4, String gubun5, String sort)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String where = "";		

		if(dt.equals("1"))	where = " and a.rent_dt = to_char(sysdate,'YYYYMMDD')";
		if(dt.equals("2"))	where = " and a.rent_dt like to_char(sysdate,'YYYYMM')||'%' ";
		if(dt.equals("4"))	where = " and a.rent_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')";

		query = " select "+
				"        decode(a.client_st,'1','법인','2','개인','개인사업자') client_st, a.firm_nm, a.client_nm, a.client_id, b.cont_cnt, e.user_nm bus_nm, f.user_nm bus_nm2"+
				" from"+
				"        client a,"+
				"        (select client_id, count(0) cont_cnt from cont a where nvl(use_yn,'Y')='Y' and car_st in ('1','3') "+where+" group by client_id) b,"+
				"        (select client_id, max(rent_l_cd) rent_l_cd from cont a where nvl(use_yn,'Y')='Y' and car_st in ('1','3') group by client_id) c,"+
				"        cont d, users e, users f"+
				" where  a.client_id=b.client_id and a.client_id<>'000228' "+
				"        and a.client_id=c.client_id and c.rent_l_cd=d.rent_l_cd"+
				"        and d.bus_id=e.user_id(+) and d.bus_id2=f.user_id(+)";

		if(gubun3.equals("1"))	query += " and a.client_st='1'";
		if(gubun3.equals("2"))	query += " and a.client_st='2'";
		if(gubun3.equals("3"))	query += " and a.client_st not in ('1','2')";
	
		query += " order by b.cont_cnt desc, a.firm_nm";
		
		
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
			System.out.println("[AddClientDatabase:getClientContStat]\n"+e);
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
	 *	고객별 계약리스트
	 */
	public Vector getContList(String client_id, String dt, String ref_dt1, String ref_dt2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String where = "";		

		if(dt.equals("1"))	where = " and C.rent_dt = to_char(sysdate,'YYYYMMDD')";
		if(dt.equals("2"))	where = " and C.rent_dt like to_char(sysdate,'YYYYMM')||'%' ";
		if(dt.equals("4"))	where = " and C.rent_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')";

		query = " select rent_mng_id, rent_l_cd, car_no, user_nm, rent_start_dt, rent_end_dt,\n"+
				"        is_run, is_run_num, rent_dt, CAR_NM, CAR_NAME, rent_way\n"+
				" from\n"+
				"       (\n"+
				"         SELECT C.rent_mng_id RENT_MNG_ID, C.rent_l_cd RENT_L_CD, R.car_no CAR_NO, U.user_nm USER_NM,\n"+
								" decode(F.rent_start_dt, '', '', substr(F.rent_start_dt, 1, 4)||'-'||substr(F.rent_start_dt, 5, 2)||'-'||substr(F.rent_start_dt, 7, 2)) RENT_START_DT,\n"+
								" decode(F.rent_end_dt, '', '', substr(F.rent_end_dt, 1, 4)||'-'||substr(F.rent_end_dt, 5, 2)||'-'||substr(F.rent_end_dt, 7, 2)) RENT_END_DT,\n"+ 
								" decode(C.use_yn, 'N', '해약', decode(F.rent_start_dt, '', '신규', '대여')) IS_RUN, decode(C.use_yn, 'N', '2', decode(F.rent_start_dt, '', '1', '0')) IS_RUN_NUM,\n"+
								" decode(C.rent_dt, '', '', substr(C.rent_dt, 1, 4)||'-'||substr(C.rent_dt, 5, 2)||'-'||substr(C.rent_dt, 7, 2)) rent_dt,\n"+ 
								" M.CAR_NM, N.car_NAME, DECODE(F.rent_way, '1', '일반식', '기본식') rent_way\n"+
						" FROM CONT C, CLIENT L, CAR_REG R, FEE F, USERS U,"+
					    "      CAR_ETC E, CAR_NM N, CAR_MNG M, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) F2 "+
						" where C.client_id =? and nvl(C.use_yn,'Y')='Y' and C.car_st in ('1','3') and C.client_id = L.client_id "+where+" AND  "+
							  " C.car_mng_id = R.car_mng_id(+) AND"+
							  " C.rent_l_cd = F.rent_l_cd AND"+
							  " C.rent_mng_id = F.rent_mng_id AND"+
							  " C.bus_id2 = U.user_id AND"+
							  " C.rent_mng_id=E.rent_mng_id and C.rent_l_cd=E.rent_l_cd and E.car_id=N.car_id and E.car_seq=N.car_seq"+
							  " and N.car_comp_id=M.car_comp_id and N.car_cd=M.code "+
							  " and F.rent_mng_id=F2.rent_mng_id and F.rent_l_cd=F2.rent_l_cd and F.rent_st=F2.rent_st "+
							  " order by C.rent_start_dt"+
					")\n"+
					"order by is_run_num";
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, client_id);
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
			System.out.println("[AddClientDatabase:getContList]\n"+e);
			System.out.println("[AddClientDatabase:getContList]\n"+query);
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

	//미확인입금자 조회
	public Vector getClientSearch(String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select '1' as st, '고객' gubun, a.use_yn, a.rent_mng_id, a.rent_l_cd, a.client_id, b.firm_nm, b.client_nm, "+
				"        b.con_agnt_nm||b.CON_AGNT_TITLE as agnt_nm, b.con_agnt_m_tel as m_tel, "+
				"        nvl(b.update_dt,b.reg_dt)||' '||b.etc||' '||b.con_agnt_nm||' '||b.con_agnt_m_tel||' '||b.con_agnt_email as etc, b.update_dt as reg_dt"+
				" from   cont a, client b"+
				" where  a.client_id=b.client_id "+
				"        and b.firm_nm||b.client_nm||b.con_agnt_nm||b.etc||b.con_agnt_m_tel||b.con_agnt_email||b.h_tel||b.o_tel||b.m_tel||b.fax||b.enp_no||TEXT_DECRYPT(b.ssn, 'pw' ) like '%"+t_wd+"%'"+

				" union all"+

				" select '2' as st, '지점' gubun, a.use_yn, a.rent_mng_id, a.rent_l_cd, a.client_id, b.r_site as firm_nm, b.site_jang as client_nm, "+
				"	     b.agnt_nm||' '||b.agnt_title as agnt_nm, b.agnt_m_tel as m_tel, "+
				"	     nvl(b.upd_dt,b.reg_dt)||' '||b.agnt_m_tel||' '||b.agnt_email as etc, b.upd_dt as reg_dt "+
				" from   cont a, client_site b"+
				" where  a.client_id=b.client_id "+
				"	     and a.r_site=b.seq and b.r_site||b.site_jang||b.agnt_nm||b.agnt_m_tel||b.agnt_email||TEXT_DECRYPT(b.enp_no, 'pw' )  like '%"+t_wd+"%'"+

				" union all"+

				" select '3' as st, c.mgr_st as gubun, a.use_yn, a.rent_mng_id, a.rent_l_cd, a.client_id, b.firm_nm, b.client_nm, "+
				"		 c.mgr_nm||c.mgr_title as agnt_nm, c.mgr_m_tel as m_tel, "+
				"	     a.reg_dt||' '||c.mgr_dept||' '||c.mgr_tel||' '||c.mgr_m_tel||' '||c.mgr_email as etc, a.reg_dt "+
				" from   cont a, client b, car_mgr c"+
				" where  a.client_id=b.client_id and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd "+
				"	     and c.mgr_nm||c.mgr_title||c.mgr_dept||c.mgr_tel||c.mgr_m_tel||c.mgr_email like '%"+t_wd+"%'"+

				" union all"+

				" select '4' as st, '이력' as gubun, a.use_yn, a.rent_mng_id, a.rent_l_cd, a.client_id, b.firm_nm, b.client_nm, "+
				"	     '' as agnt_nm, '' as mtel, "+
				"	     b.reg_dt||' '||'현재는'||c.firm_nm||', 변경일자 : '||b.cng_dt as etc, b.reg_dt "+
				" from   cont a, client_enp_h b, client c, cls_cont d"+
				" where  a.client_id=b.client_id and a.client_id=c.client_id "+
				"	     and b.firm_nm||b.client_nm like '%"+t_wd+"%'"+
				"        and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+) "+
				"        and b.CNG_DT between a.rent_dt and nvl(d.cls_dt,a.rent_end_dt) "+

				" union all"+

				" select '5' as st, '통화' as gubun, a.use_yn, a.rent_mng_id, a.rent_l_cd, a.client_id, b.firm_nm, b.client_nm, "+
				"	     c.speaker as agnt_nm, '' as m_tel, "+
				"	     c.reg_dt||' '||c.content as etc, c.reg_dt "+
				" from   cont a, client b, dly_mm c"+
				" where  a.client_id=b.client_id and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd "+
				"	     and c.content||c.speaker like '%"+t_wd+"%'"+

				" union all"+

				" select '6' as st, '통화' as gubun, a.use_yn, a.rent_mng_id, a.rent_l_cd, a.client_id, b.firm_nm, b.client_nm, "+
				"	     c.speaker as agnt_nm, '' as m_tel, "+
				"	     c.reg_dt||' '||c.content as etc, c.reg_dt "+
				" from   cont a, client b, tel_mm c"+
				" where  a.client_id=b.client_id and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd "+
				"	     and c.content||c.speaker like '%"+t_wd+"%'";

		String query2 = " select * from ("+query+") order by st, reg_dt ";
		
		
		try {
				pstmt = conn.prepareStatement(query2);
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
			System.out.println("[AddClientDatabase:getClientSearch]\n"+e);
			System.out.println("[AddClientDatabase:getClientSearch]\n"+query);
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

	//업그레이드 20071013 적용------------------------------------------------------------------------------

    //new Client - 20070710

	//거래처 insert
	public ClientBean insertNewClient(ClientBean client)
	{
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		String id_sql = " select ltrim(to_char(to_number(MAX(client_id))+1, '000000')) ID from CLIENT ";
		String c_id="";
		try{
				pstmt1 = conn.prepareStatement(id_sql);
		    	rs = pstmt1.executeQuery();
		    	if(rs.next())
		    	{
		    		c_id=rs.getString(1)==null?"":rs.getString(1);
		    	}
				rs.close();
				pstmt1.close();

		} catch (SQLException e) {
	  		e.printStackTrace();
	  	} catch (Exception e) {
	  		e.printStackTrace();
	  	}
	  	
		if(c_id.equals(""))	c_id = "000001";
		client.setClient_id(c_id);
		
		String query = " insert into CLIENT ( CLIENT_ID, CLIENT_ST, CLIENT_NM, FIRM_NM, SSN, ENP_NO, H_TEL, O_TEL, M_TEL, "+  //9
						" HOMEPAGE, FAX, BUS_CDT, BUS_ITM, HO_ADDR, HO_ZIP, O_ADDR, O_ZIP, COM_NM, DEPT, TITLE, CAR_USE, "+
						" CON_AGNT_NM, CON_AGNT_O_TEL, CON_AGNT_M_TEL, CON_AGNT_FAX, CON_AGNT_EMAIL, CON_AGNT_DEPT, "+
						" CON_AGNT_TITLE, ETC, OPEN_YEAR, FIRM_PRICE, FIRM_PRICE_Y, FIRM_PRICE_B, FIRM_DAY, FIRM_DAY_Y, FIRM_DAY_B,"+
						" REG_ID, REG_DT, PRINT_ST, ETAX_NOT_CAU, " +
						" FIRM_ST, ENP_YN, ENP_NM, FIRM_TYPE, FOUND_YEAR, " +
						" REPRE_ST, REPRE_NO, REPRE_ADDR, REPRE_ZIP, REPRE_EMAIL, JOB, PAY_ST, PAY_TYPE, COMM_ADDR, COMM_ZIP, VEN_CODE, WK_YEAR, DLY_SMS, ETC_CMS, FINE_YN, " +
						" item_mail_yn, tax_mail_yn, taxregno, print_car_st, nationality, etax_item_st, dly_yn, REPRE_NM, "+
						" CON_AGNT_NM2, CON_AGNT_O_TEL2, CON_AGNT_M_TEL2, CON_AGNT_FAX2, CON_AGNT_EMAIL2, CON_AGNT_DEPT2, CON_AGNT_TITLE2, "+
                        " LIC_NO, CMS_SMS "+ 
						" ) values ("+
						" ?, ?, ?, ?, TEXT_ENCRYPT(?, 'pw' ) ,    ?, ?, ?, ?,      ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, replace(?, '-', ''), ?, ?, ?, ?, ?, ?,"+
						" ?, to_char(sysdate,'YYYYMMDD'), ?, ?, " +
						" ?, ?, ?, ?, replace(?, '-', ''), " +
						" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? , ?, ?, " +
						" ?, ?, ?, ?, ?, ?, ?, ?,  "+
						" ?, ?, ?, ?, ?, ?, ?, "+		
                        " ?, ? "+
						")";
								
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  client.getClient_id()	);
			pstmt.setString(2,  client.getClient_st()	);
			pstmt.setString(3,  client.getClient_nm()	);
			pstmt.setString(4,  client.getFirm_nm()		);
			pstmt.setString(5,  client.getSsn1()+client.getSsn2());
			pstmt.setString(6,  client.getEnp_no1()+client.getEnp_no2()+client.getEnp_no3());
			pstmt.setString(7,  client.getH_tel()		);
			pstmt.setString(8,  client.getO_tel()		);
			pstmt.setString(9,  client.getM_tel()		);
			
			pstmt.setString(10, client.getHomepage()	);
			pstmt.setString(11, client.getFax()			);
			pstmt.setString(12, client.getBus_cdt()		);
			pstmt.setString(13, client.getBus_itm()		);
			pstmt.setString(14, client.getHo_addr()		);
			pstmt.setString(15, client.getHo_zip()		);
			pstmt.setString(16, client.getO_addr()		);
			pstmt.setString(17, client.getO_zip()		);
			pstmt.setString(18, client.getCom_nm()		);
			pstmt.setString(19, client.getDept()		);
			pstmt.setString(20, client.getTitle()		);
			pstmt.setString(21, client.getCar_use()		);
			pstmt.setString(22, client.getCon_agnt_nm()	);
			pstmt.setString(23, client.getCon_agnt_o_tel());
			pstmt.setString(24, client.getCon_agnt_m_tel());
			pstmt.setString(25, client.getCon_agnt_fax());
			pstmt.setString(26, client.getCon_agnt_email());
			pstmt.setString(27, client.getCon_agnt_dept());
			pstmt.setString(28, client.getCon_agnt_title());
			pstmt.setString(29, client.getEtc()			);
		    pstmt.setString(30, client.getOpen_year()	);
		    pstmt.setFloat (31, client.getFirm_price()	);
		    pstmt.setFloat (32, client.getFirm_price_y());
		    pstmt.setFloat (33, client.getFirm_price_b());
		    pstmt.setString(34, client.getFirm_day()	);
		    pstmt.setString(35, client.getFirm_day_y()	);
		    pstmt.setString(36, client.getFirm_day_b()	);
		    pstmt.setString(37, client.getReg_id()		);
		    pstmt.setString(38, client.getPrint_st().trim());
		    pstmt.setString(39, client.getEtax_not_cau());
		    
		    pstmt.setString(40, client.getFirm_st()		);
		    pstmt.setString(41, client.getEnp_yn()		);
		    pstmt.setString(42, client.getEnp_nm()		);
		    pstmt.setString(43, client.getFirm_type()	);
		    pstmt.setString(44, client.getFound_year()	);
		    pstmt.setString(45, client.getRepre_st()	);
		    pstmt.setString(46, client.getRepre_ssn1()+ client.getRepre_ssn2()	);
		    pstmt.setString(47, client.getRepre_addr()	);
		    pstmt.setString(48, client.getRepre_zip()	);
		    pstmt.setString(49, client.getRepre_email()	);
		    pstmt.setString(50, client.getJob()			);
		    pstmt.setString(51, client.getPay_st()		); 
		    pstmt.setString(52, client.getPay_type()	);
		    pstmt.setString(53, client.getComm_addr()	);
		    pstmt.setString(54, client.getComm_zip()	);
		    pstmt.setString(55, client.getVen_code()	);
		    pstmt.setString(56, client.getWk_year()		);
		    pstmt.setString(57, client.getDly_sms()		);
		    pstmt.setString(58, client.getEtc_cms()		);
		    pstmt.setString(59, client.getFine_yn()		);
		    pstmt.setString(60, client.getItem_mail_yn());
		    pstmt.setString(61, client.getTax_mail_yn()	);
		    pstmt.setString(62, client.getTaxregno()	);
		    pstmt.setString(63, client.getPrint_car_st());
		    pstmt.setString(64, client.getNationality()	);
		    pstmt.setString(65, client.getEtax_item_st());
		    pstmt.setString(66, client.getDly_yn());
		    pstmt.setString(67, client.getRepre_nm()	);					
			pstmt.setString(68, client.getCon_agnt_nm2());
			pstmt.setString(69, client.getCon_agnt_o_tel2());
			pstmt.setString(70, client.getCon_agnt_m_tel2());
			pstmt.setString(71, client.getCon_agnt_fax2());
			pstmt.setString(72, client.getCon_agnt_email2());
			pstmt.setString(73, client.getCon_agnt_dept2());
			pstmt.setString(74, client.getCon_agnt_title2());
		    pstmt.setString(75, client.getLic_no()		);
		    pstmt.setString(76, client.getCms_sms()		);

		    pstmt.executeUpdate();
			pstmt.close();

		    conn.commit();
		} catch (SQLException e) {
		  	System.out.println("[AddClientDatabase:insertNewClient]\n"+e);
			e.printStackTrace();
			conn.rollback();
	  	} catch (Exception e) {
		  	System.out.println("[AddClientDatabase:insertNewClient]\n"+e);
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
                if(pstmt1 != null)	pstmt1.close();
			}catch(Exception ignore){}
			closeConnection();
			return client;
		}
	}
	
	//거래처자산 insert
	public boolean insertClientAssest(ClientAssestBean client_assest)
	{
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		boolean flag = true;
		String id_sql = " select ltrim(to_char(to_number(MAX(a_seq))+1, '0000')) ID from CLIENT_ASSEST where client_id = ? ";
		String a_seq="";
		try{
				pstmt1 = conn.prepareStatement(id_sql);
				pstmt1.setString(1, client_assest.getClient_id());
		       	rs = pstmt1.executeQuery();
		    	if(rs.next())
		    	{
		    		a_seq=rs.getString(1)==null?"":rs.getString(1);
		    	}
				rs.close();
				pstmt1.close();
		} catch (SQLException e) {
	  		e.printStackTrace();
	  	} catch (Exception e) {
	  		e.printStackTrace();
	  	}
	  	
		if(a_seq.equals(""))	a_seq = "0001";
		client_assest.setA_seq(a_seq);
		
		String query = " insert into CLIENT_ASSEST ( CLIENT_ID, A_SEQ, C_ASS1_TYPE, C_ASS1_ADDR, C_ASS1_ZIP, C_ASS2_TYPE, C_ASS2_ADDR, C_ASS2_ZIP, " +
		                " R_ASS1_TYPE, R_ASS1_ADDR, R_ASS1_ZIP, R_ASS2_TYPE, R_ASS2_ADDR, R_ASS2_ZIP " +
						" ) values ("+
						" ?, ?, ?, ?, ?, ?, ?, ?,"+
					    " ?, ?, ?, ?, ?, ? " +
						")";
								
		try 
		{
			conn.setAutoCommit(false);

			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  client_assest.getClient_id()	);
			pstmt.setString(2,  client_assest.getA_seq()	);
			pstmt.setString(3,  client_assest.getC_ass1_type()	);
			pstmt.setString(4,  client_assest.getC_ass1_addr()	);
			pstmt.setString(5,  client_assest.getC_ass1_zip()	);
			pstmt.setString(6,  client_assest.getC_ass2_type()	);
			pstmt.setString(7,  client_assest.getC_ass2_addr()	);
			pstmt.setString(8,  client_assest.getC_ass2_zip()	);
			pstmt.setString(9,  client_assest.getR_ass1_type()	);
			pstmt.setString(10, client_assest.getR_ass1_addr()	);
			pstmt.setString(11, client_assest.getR_ass1_zip()	);
			pstmt.setString(12, client_assest.getR_ass2_type()	);
			pstmt.setString(13, client_assest.getR_ass2_addr()	);
			pstmt.setString(14, client_assest.getR_ass2_zip()	);
			
		    pstmt.executeUpdate();
			pstmt.close();

		    conn.commit();
		} catch (SQLException e) {
		  	System.out.println("[AddClientDatabase:insertClientAssest]\n"+e);
			e.printStackTrace();
			flag = false;
			conn.rollback();
	  	} catch (Exception e) {
		  	System.out.println("[AddClientDatabase:insertClientAssest]\n"+e);
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

		//거래처재무제표 insert
	public boolean insertClientFin(ClientFinBean client_fin)
	{
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		boolean flag = true;
		String id_sql = " select ltrim(to_char(to_number(MAX(f_seq))+1, '0000')) ID from CLIENT_FIN where client_id = ? ";
		String f_seq="";
		try{
				pstmt1 = conn.prepareStatement(id_sql);
				pstmt1.setString(1, client_fin.getClient_id());
		       	rs = pstmt1.executeQuery();
		    	if(rs.next())
		    	{
		    		f_seq=rs.getString(1)==null?"":rs.getString(1);
		    	}
				rs.close();
				pstmt1.close();
		} catch (SQLException e) {
	  		e.printStackTrace();
	  	} catch (Exception e) {
	  		e.printStackTrace();
	  	}
	  	
		if(f_seq.equals(""))	f_seq = "0001";
		client_fin.setF_seq(f_seq);
		
		String query = " insert into CLIENT_FIN ( CLIENT_ID, F_SEQ, C_KISU, C_BA_YEAR, C_ASSET_TOT, C_CAP, C_CAP_TOT, C_SALE, " +
		                " F_KISU, F_BA_YEAR, F_ASSET_TOT, F_CAP, F_CAP_TOT, F_SALE, C_PROFIT, F_PROFIT, C_BA_YEAR_S, F_BA_YEAR_S " +
						" ) values ("+
						" ?, ?, ?, ?, ?, ?, ?, ?,"+
					    " ?, ?, ?, ?, ?, ?, ?, ?, " +
						" replace(?, '-', ''), replace(?, '-', ''))";
								
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  client_fin.getClient_id()	);
			pstmt.setString(2,  client_fin.getF_seq()		);
			pstmt.setString(3,  client_fin.getC_kisu()		);
			pstmt.setString(4,  client_fin.getC_ba_year()	);
			pstmt.setFloat (5,  client_fin.getC_asset_tot()	);
			pstmt.setFloat (6,  client_fin.getC_cap()		);
			pstmt.setFloat (7,  client_fin.getC_cap_tot()	);
			pstmt.setFloat (8,  client_fin.getC_sale()		);			
			pstmt.setString(9,  client_fin.getF_kisu()		);
			pstmt.setString(10, client_fin.getF_ba_year()	);
			pstmt.setFloat (11, client_fin.getF_asset_tot()	);
			pstmt.setFloat (12, client_fin.getF_cap()		);
			pstmt.setFloat (13, client_fin.getF_cap_tot()	);
			pstmt.setFloat (14, client_fin.getF_sale()		);
			pstmt.setFloat (15, client_fin.getC_profit()	);
			pstmt.setFloat (16, client_fin.getF_profit()	);
			pstmt.setString(17,  client_fin.getC_ba_year_s());
			pstmt.setString(18,  client_fin.getF_ba_year_s());
			
		    pstmt.executeUpdate();
			pstmt.close();

		    conn.commit();
		} catch (SQLException e) {
		  	System.out.println("[AddClientDatabase:insertClientFin]\n"+e);
			System.out.println("[client_fin.getClient_id()		]"+client_fin.getClient_id()	);
			System.out.println("[client_fin.getF_seq()			]"+client_fin.getF_seq()		);
			System.out.println("[client_fin.getC_kisu()			]"+client_fin.getC_kisu()		);
			System.out.println("[client_fin.getC_ba_year()		]"+client_fin.getC_ba_year()	);
			System.out.println("[client_fin.getC_asset_tot()	]"+client_fin.getC_asset_tot()	);
			System.out.println("[client_fin.getC_cap()			]"+client_fin.getC_cap()		);
			System.out.println("[client_fin.getC_cap_tot()		]"+client_fin.getC_cap_tot()	);
			System.out.println("[client_fin.getC_sale()			]"+client_fin.getC_sale()		);
			System.out.println("[client_fin.getF_kisu()			]"+client_fin.getF_kisu()		);
			System.out.println("[client_fin.getF_ba_year()		]"+client_fin.getF_ba_year()	);
			System.out.println("[client_fin.getF_asset_tot()	]"+client_fin.getF_asset_tot()	);
			System.out.println("[client_fin.getF_cap()			]"+client_fin.getF_cap()		);
			System.out.println("[client_fin.getF_cap_tot()		]"+client_fin.getF_cap_tot()	);
			System.out.println("[client_fin.getF_sale()			]"+client_fin.getF_sale()		);
			System.out.println("[client_fin.getC_profit()		]"+client_fin.getC_profit()		);
			System.out.println("[client_fin.getF_profit()		]"+client_fin.getF_profit()		);
			System.out.println("[ client_fin.getC_ba_year_s()	]"+ client_fin.getC_ba_year_s()	);
			System.out.println("[ client_fin.getF_ba_year_s()	]"+ client_fin.getF_ba_year_s()	);

			e.printStackTrace();
			flag = false;
			conn.rollback();
	  	} catch (Exception e) {
		  	System.out.println("[AddClientDatabase:insertClientFin]\n"+e);
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
	
		//고객 조회
	public ClientBean getNewClient(String client_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ClientBean client = new ClientBean();

		String query = " select CLIENT_ID, CLIENT_ST, CLIENT_NM, FIRM_NM,"+
						" substr( TEXT_DECRYPT(ssn, 'pw' ), 1, 6) SSN1, substr( TEXT_DECRYPT(ssn, 'pw' ), 7, 7) SSN2,"+
						" substr(ENP_NO, 1, 3) ENP_NO1, substr(ENP_NO, 4, 2) ENP_NO2, substr(ENP_NO, 6, 5)  ENP_NO3,"+
		 				" H_TEL, O_TEL, M_TEL, HOMEPAGE, FAX,"+
						" BUS_CDT, BUS_ITM, HO_ADDR, HO_ZIP, O_ADDR, O_ZIP, COM_NM, DEPT, TITLE,"+
						" CAR_USE, CON_AGNT_NM, CON_AGNT_O_TEL, CON_AGNT_M_TEL, CON_AGNT_FAX, CON_AGNT_EMAIL, CON_AGNT_DEPT, CON_AGNT_TITLE, "+
						" ETC, FIRM_PRICE, FIRM_PRICE_Y, FIRM_PRICE_B,"+
						" decode(OPEN_YEAR, '', '', substr(OPEN_YEAR, 1, 4) || '-' || substr(OPEN_YEAR, 5, 2) || '-'||substr(OPEN_YEAR, 7, 2)) OPEN_YEAR, "+
						" decode(FIRM_DAY, '', '', substr(FIRM_DAY, 1, 4) || '-' || substr(FIRM_DAY, 5, 2) || '-'||substr(FIRM_DAY, 7, 2)) FIRM_DAY, "+
						" decode(FIRM_DAY_Y, '', '', substr(FIRM_DAY_Y, 1, 4) || '-' || substr(FIRM_DAY_Y, 5, 2) || '-'||substr(FIRM_DAY_Y, 7, 2)) FIRM_DAY_Y, "+
						" decode(FIRM_DAY_B, '', '', substr(FIRM_DAY_B, 1, 4) || '-' || substr(FIRM_DAY_B, 5, 2) || '-'||substr(FIRM_DAY_B, 7, 2)) FIRM_DAY_B, "+
						" reg_id, reg_dt, update_id, update_dt, ven_code, print_st, etax_not_cau, bank_code, deposit_no,"+
						" firm_st, enp_yn, enp_nm, firm_type, decode(found_year, '', '', substr(found_year, 1, 4) || '-' || substr(found_year, 5, 2) || '-'||substr(found_year, 7, 2)) found_year, " +
						" repre_st, substr(repre_no, 1, 6) repre_ssn1, substr(repre_no, 7, 7) repre_ssn2,"+
						" repre_addr, repre_zip, repre_email, job, pay_st, pay_type, comm_addr, comm_zip, wk_year, bigo_yn, dly_sms, etc_cms, fine_yn, item_mail_yn, tax_mail_yn, taxregno, "+
						" im_print_st, tm_print_yn, bigo_value1, bigo_value2, pubform, print_car_st, nationality, etax_item_st , dly_yn, repre_nm, "+
						" CON_AGNT_NM2, CON_AGNT_O_TEL2, CON_AGNT_M_TEL2, CON_AGNT_FAX2, CON_AGNT_EMAIL2, CON_AGNT_DEPT2, CON_AGNT_TITLE2, lic_no, cms_sms, "+
						" repre_st2, substr(repre_no2, 1, 6) repre_ssn2_1, substr(repre_no2, 7, 7) repre_ssn2_2, repre_addr2, repre_zip2, repre_email2, repre_nm2 "+
					   " from CLIENT where CLIENT_ID = ? ";
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, client_id);
		    	rs = pstmt.executeQuery();
		
			while(rs.next())
			{
				client.setClient_id		(rs.getString("CLIENT_ID")==null?"":rs.getString("CLIENT_ID"));
				client.setClient_st		(rs.getString("CLIENT_ST")==null?"":rs.getString("CLIENT_ST"));
				client.setClient_nm		(rs.getString("CLIENT_NM")==null?"":rs.getString("CLIENT_NM"));
				client.setFirm_nm		(rs.getString("FIRM_NM")==null?"":rs.getString("FIRM_NM"));
				client.setSsn1			(rs.getString("SSN1")==null?"":rs.getString("SSN1"));
				client.setSsn2			(rs.getString("SSN2")==null?"":rs.getString("SSN2"));
				client.setEnp_no1		(rs.getString("ENP_NO1")==null?"":rs.getString("ENP_NO1"));
				client.setEnp_no2		(rs.getString("ENP_NO2")==null?"":rs.getString("ENP_NO2"));
				client.setEnp_no3		(rs.getString("ENP_NO3")==null?"":rs.getString("ENP_NO3"));
				client.setH_tel			(rs.getString("H_TEL")==null?"":rs.getString("H_TEL"));
				client.setO_tel			(rs.getString("O_TEL")==null?"":rs.getString("O_TEL"));
				client.setM_tel			(rs.getString("M_TEL")==null?"":rs.getString("M_TEL"));
				client.setHomepage		(rs.getString("HOMEPAGE")==null?"":rs.getString("HOMEPAGE"));
				client.setFax			(rs.getString("FAX")==null?"":rs.getString("FAX"));
				client.setBus_cdt		(rs.getString("BUS_CDT")==null?"":rs.getString("BUS_CDT"));
				client.setBus_itm		(rs.getString("BUS_ITM")==null?"":rs.getString("BUS_ITM"));
				client.setHo_addr		(rs.getString("HO_ADDR")==null?"":rs.getString("HO_ADDR"));
				client.setHo_zip		(rs.getString("HO_ZIP")==null?"":rs.getString("HO_ZIP"));
				client.setO_addr		(rs.getString("O_ADDR")==null?"":rs.getString("O_ADDR"));
				client.setO_zip			(rs.getString("O_ZIP")==null?"":rs.getString("O_ZIP"));
				client.setCom_nm		(rs.getString("COM_NM")==null?"":rs.getString("COM_NM"));
				client.setDept			(rs.getString("DEPT")==null?"":rs.getString("DEPT"));
				client.setTitle			(rs.getString("TITLE")==null?"":rs.getString("TITLE"));
				client.setCar_use		(rs.getString("CAR_USE")==null?"":rs.getString("CAR_USE"));
				client.setCon_agnt_nm	(rs.getString("CON_AGNT_NM")==null?"":rs.getString("CON_AGNT_NM"));
				client.setCon_agnt_o_tel(rs.getString("CON_AGNT_O_TEL")==null?"":rs.getString("CON_AGNT_O_TEL"));
				client.setCon_agnt_m_tel(rs.getString("CON_AGNT_M_TEL")==null?"":rs.getString("CON_AGNT_M_TEL"));
				client.setCon_agnt_fax	(rs.getString("CON_AGNT_FAX")==null?"":rs.getString("CON_AGNT_FAX"));
				client.setCon_agnt_email(rs.getString("CON_AGNT_EMAIL")==null?"":rs.getString("CON_AGNT_EMAIL"));
				client.setCon_agnt_dept	(rs.getString("CON_AGNT_DEPT")==null?"":rs.getString("CON_AGNT_DEPT"));
				client.setCon_agnt_title(rs.getString("CON_AGNT_TITLE")==null?"":rs.getString("CON_AGNT_TITLE"));
				client.setEtc			(rs.getString("ETC")==null?"":rs.getString("ETC"));
				client.setOpen_year		(rs.getString("OPEN_YEAR")==null?"":rs.getString("OPEN_YEAR"));
				client.setFirm_price	(rs.getString("FIRM_PRICE")==null?0:Float.parseFloat(rs.getString("FIRM_PRICE")));
				client.setFirm_price_y	(rs.getString("FIRM_PRICE_Y")==null?0:Float.parseFloat(rs.getString("FIRM_PRICE_Y")));
				client.setFirm_price_b	(rs.getString("FIRM_PRICE_B")==null?0:Float.parseFloat(rs.getString("FIRM_PRICE_B")));
				client.setFirm_day		(rs.getString("FIRM_DAY")==null?"":rs.getString("FIRM_DAY"));
				client.setFirm_day_y	(rs.getString("FIRM_DAY_Y")==null?"":rs.getString("FIRM_DAY_Y"));
				client.setFirm_day_b	(rs.getString("FIRM_DAY_B")==null?"":rs.getString("FIRM_DAY_B"));
				client.setReg_id		(rs.getString("reg_id")==null?"":rs.getString("reg_id"));
				client.setReg_dt		(rs.getString("reg_dt")==null?"":rs.getString("reg_dt"));
				client.setUpdate_id		(rs.getString("update_id")==null?"":rs.getString("update_id"));
				client.setUpdate_dt		(rs.getString("update_dt")==null?"":rs.getString("update_dt"));
				client.setVen_code		(rs.getString("ven_code")==null?"":rs.getString("ven_code"));
				client.setPrint_st		(rs.getString("print_st")==null?"":rs.getString("print_st"));
				client.setEtax_not_cau	(rs.getString("etax_not_cau")==null?"":rs.getString("etax_not_cau"));
				client.setBank_code		(rs.getString("bank_code")==null?"":rs.getString("bank_code"));
				client.setDeposit_no	(rs.getString("deposit_no")==null?"":rs.getString("deposit_no"));
				
				client.setFirm_st		(rs.getString("firm_st")==null?"":rs.getString("firm_st"));
		    	client.setEnp_yn		(rs.getString("enp_yn")==null?"":rs.getString("enp_yn"));
		    	client.setEnp_nm		(rs.getString("enp_nm")==null?"":rs.getString("enp_nm"));
		    	client.setFirm_type		(rs.getString("firm_type")==null?"":rs.getString("firm_type"));
		    	client.setFound_year	(rs.getString("found_year")==null?"":rs.getString("found_year"));
		    	client.setRepre_st		(rs.getString("repre_st")==null?"":rs.getString("repre_st"));
		    	client.setRepre_ssn1	(rs.getString("repre_ssn1")==null?"":rs.getString("repre_ssn1"));
		    	client.setRepre_ssn2	(rs.getString("repre_ssn2")==null?"":rs.getString("repre_ssn2"));
		    	client.setRepre_addr	(rs.getString("repre_addr")==null?"":rs.getString("repre_addr"));
		    	client.setRepre_zip		(rs.getString("repre_zip")==null?"":rs.getString("repre_zip"));
		    	client.setRepre_email	(rs.getString("repre_email")==null?"":rs.getString("repre_email"));
		    	client.setJob			(rs.getString("job")==null?"":rs.getString("job"));
		    	client.setPay_st		(rs.getString("pay_st")==null?"":rs.getString("pay_st"));
		    	client.setPay_type		(rs.getString("pay_type")==null?"":rs.getString("pay_type"));
		    	client.setComm_addr		(rs.getString("comm_addr")==null?"":rs.getString("comm_addr"));
		    	client.setComm_zip		(rs.getString("comm_zip")==null?"":rs.getString("comm_zip"));
		    	client.setWk_year		(rs.getString("wk_year")==null?"":rs.getString("wk_year"));
		    	client.setBigo_yn		(rs.getString("bigo_yn")==null?"":rs.getString("bigo_yn"));
		    	client.setDly_sms		(rs.getString("dly_sms")==null?"":rs.getString("dly_sms"));
		    	client.setEtc_cms		(rs.getString("etc_cms")==null?"":rs.getString("etc_cms"));
		    	client.setFine_yn		(rs.getString("fine_yn")==null?"":rs.getString("fine_yn"));
		    	client.setItem_mail_yn	(rs.getString("item_mail_yn")==null?"":rs.getString("item_mail_yn"));
		    	client.setTax_mail_yn	(rs.getString("tax_mail_yn")==null?"":rs.getString("tax_mail_yn"));
				client.setTaxregno		(rs.getString("taxregno")==null?"":rs.getString("taxregno"));
				client.setIm_print_st	(rs.getString("im_print_st")==null?"":rs.getString("im_print_st"));
				client.setTm_print_yn	(rs.getString("tm_print_yn")==null?"":rs.getString("tm_print_yn"));
		    	client.setBigo_value1	(rs.getString("bigo_value1")==null?"":rs.getString("bigo_value1"));
		    	client.setBigo_value2	(rs.getString("bigo_value2")==null?"":rs.getString("bigo_value2"));
		    	client.setPubform		(rs.getString("pubform")==null?"":rs.getString("pubform"));
				client.setPrint_car_st	(rs.getString("print_car_st")==null?"":rs.getString("print_car_st"));
				client.setNationality	(rs.getString("nationality")==null?"":rs.getString("nationality"));
				client.setEtax_item_st	(rs.getString("etax_item_st")==null?"":rs.getString("etax_item_st"));
				client.setDly_yn		(rs.getString("dly_yn")==null?"":rs.getString("dly_yn"));
		    	client.setRepre_nm		(rs.getString("repre_nm")==null?"":rs.getString("repre_nm"));

				client.setCon_agnt_nm2	(rs.getString("CON_AGNT_NM2")==null?"":rs.getString("CON_AGNT_NM2"));
				client.setCon_agnt_o_tel2(rs.getString("CON_AGNT_O_TEL2")==null?"":rs.getString("CON_AGNT_O_TEL2"));
				client.setCon_agnt_m_tel2(rs.getString("CON_AGNT_M_TEL2")==null?"":rs.getString("CON_AGNT_M_TEL2"));
				client.setCon_agnt_fax2	(rs.getString("CON_AGNT_FAX2")==null?"":rs.getString("CON_AGNT_FAX2"));
				client.setCon_agnt_email2(rs.getString("CON_AGNT_EMAIL2")==null?"":rs.getString("CON_AGNT_EMAIL2"));
				client.setCon_agnt_dept2(rs.getString("CON_AGNT_DEPT2")==null?"":rs.getString("CON_AGNT_DEPT2"));
				client.setCon_agnt_title2(rs.getString("CON_AGNT_TITLE2")==null?"":rs.getString("CON_AGNT_TITLE2"));

				client.setLic_no		(rs.getString("lic_no")==null?"":rs.getString("lic_no"));
				client.setCms_sms		(rs.getString("cms_sms")==null?"":rs.getString("cms_sms"));

				client.setRepre_st2		(rs.getString("repre_st2")==null?"":rs.getString("repre_st2"));
		    	client.setRepre_ssn2_1	(rs.getString("repre_ssn2_1")==null?"":rs.getString("repre_ssn2_1"));
		    	client.setRepre_ssn2_2	(rs.getString("repre_ssn2_2")==null?"":rs.getString("repre_ssn2_2"));
		    	client.setRepre_addr2	(rs.getString("repre_addr2")==null?"":rs.getString("repre_addr2"));
		    	client.setRepre_zip2		(rs.getString("repre_zip2")==null?"":rs.getString("repre_zip2"));
		    	client.setRepre_email2	(rs.getString("repre_email2")==null?"":rs.getString("repre_email2"));
				client.setRepre_nm2		(rs.getString("repre_nm2")==null?"":rs.getString("repre_nm2"));
				
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddClientDatabase:getNewClient]\n"+e);
	  		e.printStackTrace();
	  		client = null;
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return client;
		}
	}
	
		//고객자산 조회
	public ClientAssestBean getClientAssest(String client_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		String seq = "";
		ClientAssestBean client_assest = new ClientAssestBean();


		String id_sql = " select ltrim(MAX(a_seq)) ID from CLIENT_ASSEST where CLIENT_ID=?";
			
		String query = " select CLIENT_ID, A_SEQ, "+
						" C_ASS1_TYPE, C_ASS1_ADDR, C_ASS1_ZIP, C_ASS2_TYPE, C_ASS2_ADDR, C_ASS2_ZIP, "+
						" R_ASS1_TYPE, R_ASS1_ADDR, R_ASS1_ZIP, R_ASS2_TYPE, R_ASS2_ADDR, R_ASS2_ZIP "+
					    " from CLIENT_ASSEST where CLIENT_ID = ? and A_SEQ = ? ";
		try {
				pstmt1 = conn.prepareStatement(id_sql);
				pstmt1.setString(1, client_id);
			   	rs1 = pstmt1.executeQuery();
			   	if(rs1.next())
			   	{
			   		seq=rs1.getString(1)==null?"":rs1.getString(1);
			   	}
				rs1.close();
				pstmt1.close();
			   	
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, client_id);
				pstmt.setString(2, seq);
		    	rs = pstmt.executeQuery();
		
				while(rs.next())
				{
					client_assest.setClient_id		(rs.getString("CLIENT_ID")==null?"":rs.getString("CLIENT_ID"));
					client_assest.setA_seq			(rs.getString("A_SEQ")==null?"":rs.getString("A_SEQ"));
					client_assest.setC_ass1_type	(rs.getString("C_ASS1_TYPE")==null?"":rs.getString("C_ASS1_TYPE"));
					client_assest.setC_ass1_addr	(rs.getString("C_ASS1_ADDR")==null?"":rs.getString("C_ASS1_ADDR"));
					client_assest.setC_ass1_zip		(rs.getString("C_ASS1_ZIP")==null?"":rs.getString("C_ASS1_ZIP"));
					client_assest.setC_ass2_type	(rs.getString("C_ASS2_TYPE")==null?"":rs.getString("C_ASS2_TYPE"));
					client_assest.setC_ass2_addr	(rs.getString("C_ASS2_ADDR")==null?"":rs.getString("C_ASS2_ADDR"));
					client_assest.setC_ass2_zip		(rs.getString("C_ASS2_ZIP")==null?"":rs.getString("C_ASS2_ZIP"));
					client_assest.setR_ass1_type	(rs.getString("R_ASS1_TYPE")==null?"":rs.getString("R_ASS1_TYPE"));
					client_assest.setR_ass1_addr	(rs.getString("R_ASS1_ADDR")==null?"":rs.getString("R_ASS1_ADDR"));
					client_assest.setR_ass1_zip		(rs.getString("R_ASS1_ZIP")==null?"":rs.getString("R_ASS1_ZIP"));
					client_assest.setR_ass2_type	(rs.getString("R_ASS2_TYPE")==null?"":rs.getString("R_ASS2_TYPE"));
					client_assest.setR_ass2_addr	(rs.getString("R_ASS2_ADDR")==null?"":rs.getString("R_ASS2_ADDR"));
					client_assest.setR_ass2_zip		(rs.getString("R_ASS2_ZIP")==null?"":rs.getString("R_ASS2_ZIP"));					
					
				}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AddClientDatabase:getClientAssest]\n"+e);
	  		e.printStackTrace();
	  		client_assest = null;
		} finally {
			try{
                if(rs != null )		rs.close();
                if(rs1 != null )	rs1.close();
                if(pstmt != null)	pstmt.close();
                if(pstmt1 != null)	pstmt1.close();
			}catch(Exception ignore){}
			closeConnection();
			return client_assest;
		}
	}
	
		//고객재무제표 조회
	public ClientFinBean getClientFin (String client_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		String seq = "";
		
		ClientFinBean client_fin = new ClientFinBean();
	
		String id_sql = " select ltrim(MAX(f_seq)) ID from CLIENT_FIN where CLIENT_ID=?";

		String query = " select CLIENT_ID, F_SEQ, "+
						" C_KISU, decode(C_BA_YEAR, '', '', substr(C_BA_YEAR, 1, 4) || '-' || substr(C_BA_YEAR, 5, 2) || '-'||substr(C_BA_YEAR, 7, 2)) C_BA_YEAR, " +
						"  decode(C_BA_YEAR_S, '', '', substr(C_BA_YEAR_S, 1, 4) || '-' || substr(C_BA_YEAR_S, 5, 2) || '-'||substr(C_BA_YEAR_S, 7, 2)) C_BA_YEAR_S, C_ASSET_TOT, C_CAP, C_CAP_TOT, C_SALE, C_PROFIT,"+
						" F_KISU, decode(F_BA_YEAR, '', '', substr(F_BA_YEAR, 1, 4) || '-' || substr(F_BA_YEAR, 5, 2) || '-'||substr(F_BA_YEAR, 7, 2)) F_BA_YEAR, " +
						" decode(F_BA_YEAR_S, '', '', substr(F_BA_YEAR_S, 1, 4) || '-' || substr(F_BA_YEAR_S, 5, 2) || '-'||substr(F_BA_YEAR_S, 7, 2)) F_BA_YEAR_S, F_ASSET_TOT, F_CAP, F_CAP_TOT, F_SALE, F_PROFIT  "+
					    " from CLIENT_FIN where CLIENT_ID = ? and F_SEQ = ? ";
		try {
			
				pstmt1 = conn.prepareStatement(id_sql);
				pstmt1.setString(1, client_id);
			   	rs1 = pstmt1.executeQuery();
			   	if(rs1.next())
			   	{
			   		seq=rs1.getString(1)==null?"":rs1.getString(1);
			   	}
				rs1.close();
				pstmt1.close();
			 			
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, client_id);
				pstmt.setString(2, seq);
		    	rs = pstmt.executeQuery();
		
				while(rs.next())
				{
					client_fin.setClient_id		(rs.getString("CLIENT_ID")==null?"":rs.getString("CLIENT_ID"));
					client_fin.setF_seq			(rs.getString("F_SEQ")==null?"":rs.getString("F_SEQ"));
					client_fin.setC_kisu		(rs.getString("C_KISU")==null?"":rs.getString("C_KISU"));
					client_fin.setC_ba_year		(rs.getString("C_BA_YEAR")==null?"":rs.getString("C_BA_YEAR"));
					client_fin.setC_asset_tot	(rs.getString("C_ASSET_TOT")==null?0:Float.parseFloat(rs.getString("C_ASSET_TOT")));
					client_fin.setC_cap			(rs.getString("C_CAP")==null?0:Float.parseFloat(rs.getString("C_CAP")));
					client_fin.setC_cap_tot		(rs.getString("C_CAP_TOT")==null?0:Float.parseFloat(rs.getString("C_CAP_TOT")));
					client_fin.setC_sale		(rs.getString("C_SALE")==null?0:Float.parseFloat(rs.getString("C_SALE")));
					client_fin.setF_kisu		(rs.getString("F_KISU")==null?"":rs.getString("F_KISU"));
					client_fin.setF_ba_year		(rs.getString("F_BA_YEAR")==null?"":rs.getString("F_BA_YEAR"));
					client_fin.setF_asset_tot	(rs.getString("F_ASSET_TOT")==null?0:Float.parseFloat(rs.getString("F_ASSET_TOT")));
					client_fin.setF_cap			(rs.getString("F_CAP")==null?0:Float.parseFloat(rs.getString("F_CAP")));
					client_fin.setF_cap_tot		(rs.getString("F_CAP_TOT")==null?0:Float.parseFloat(rs.getString("F_CAP_TOT")));
					client_fin.setF_sale		(rs.getString("F_SALE")==null?0:Float.parseFloat(rs.getString("F_SALE")));	
					client_fin.setC_ba_year_s	(rs.getString("C_BA_YEAR_S")==null?"":rs.getString("C_BA_YEAR_S"));
					client_fin.setF_ba_year_s	(rs.getString("F_BA_YEAR_S")==null?"":rs.getString("F_BA_YEAR_S"));
					client_fin.setC_profit		(rs.getString("C_PROFIT")==null?0:Float.parseFloat(rs.getString("C_PROFIT")));
					client_fin.setF_profit		(rs.getString("F_PROFIT")==null?0:Float.parseFloat(rs.getString("F_PROFIT")));					
				}
				rs.close();
				pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AddClientDatabase:getClientFin]\n"+e);
	  		e.printStackTrace();
	  		client_fin = null;
		} finally {
			try{
                if(rs != null )		rs.close();
                if(rs1 != null )	rs1.close();
                if(pstmt != null)	pstmt.close();
                if(pstmt1 != null)	pstmt1.close();
			}catch(Exception ignore){}
			closeConnection();
			return client_fin;
		}
	}
	
	
		//고객 수정
	public boolean updateNewClient2(ClientBean client)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		
		String query = " update CLIENT set "+
						" H_TEL = ?, "+
						" O_TEL = ?, "+
						" M_TEL = ?, "+
						" HOMEPAGE = ?, "+
						" FAX = ?, "+
						" COM_NM = ?, "+
						" DEPT = ?, "+
						" TITLE = ?, "+
						" CAR_USE = ?, "+
						" CON_AGNT_NM = ?, "+
						" CON_AGNT_O_TEL = ?, "+
						" CON_AGNT_M_TEL = ?, "+
						" CON_AGNT_FAX = ?, "+
						" CON_AGNT_EMAIL = ?, "+
						" CON_AGNT_DEPT = ?, "+
						" CON_AGNT_TITLE = ?, "+
						" ETC = ?, "+
						" UPDATE_ID = ?, "+
						" UPDATE_DT = to_char(sysdate,'YYYYMMDD'),"+
						" print_st=?, "+
						" ven_code=?, "+
						" etax_not_cau=?, "+
						" bank_code=?, "+
						" deposit_no=?,"+
						" firm_st = ?, "+
						" enp_yn = ?, " +
						" enp_nm = ?, " +
						" firm_type = ?, "+
						" found_year= replace(?, '-', ''), " +
						" repre_st = ?, " +
						" repre_no = ?, " +
						" repre_addr = ?, " +
						" repre_zip = ?, " +
						" repre_email = ?, " +
						" job			= ?, " +
						" pay_st		= ?, " +
						" pay_type		= ?, " +
						" comm_addr		= ?, " +
						" comm_zip		= ?, " +         
						" wk_year		= ?, " +         
						" bigo_yn		= ?, " +         
						" dly_sms		= ?, " +    
						" etc_cms		= ?, " +    
						" fine_yn		= ?, " +              
						" item_mail_yn	= ?, " +              
						" tax_mail_yn	= ?, " +              
						" im_print_st	= ?, " +
						" tm_print_yn	= ?, " +
						" bigo_value1	= ?, " +              
						" bigo_value2	= ?, " +
						" print_car_st	= ?,  "+
						" pubform		= ?,  " +
						" nationality	= ?,  " +
						" etax_item_st	= ?,   " +
						" dly_yn		= ?,   " +
						" repre_nm		= ?, "+
						" CON_AGNT_NM2	= ?, "+
						" CON_AGNT_O_TEL2 = ?, "+
						" CON_AGNT_M_TEL2 = ?, "+
						" CON_AGNT_FAX2 = ?, "+
						" CON_AGNT_EMAIL2 = ?, "+
						" CON_AGNT_DEPT2 = ?, "+
						" CON_AGNT_TITLE2 = ?, " +         
						" lic_no		= ?, " +    
						" cms_sms		= ?,  " +
						" repre_no2 = ?, " +
						" repre_nm2 = ?, " +
						" repre_addr2 = ?, " +
						" repre_zip2 = ?, " +
						" repre_email2 = ? " +
						" where CLIENT_ID = ?";		
		try 
		{
			
		
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  client.getH_tel());
			pstmt.setString(2,  client.getO_tel());
			pstmt.setString(3,  client.getM_tel());
			pstmt.setString(4,  client.getHomepage());
			pstmt.setString(5,  client.getFax());
			pstmt.setString(6,  client.getCom_nm());
			pstmt.setString(7,  client.getDept());
			pstmt.setString(8,  client.getTitle());
			pstmt.setString(9,  client.getCar_use());
			pstmt.setString(10, client.getCon_agnt_nm());
			pstmt.setString(11, client.getCon_agnt_o_tel());
			pstmt.setString(12, client.getCon_agnt_m_tel());
			pstmt.setString(13, client.getCon_agnt_fax());
			pstmt.setString(14, client.getCon_agnt_email());
			pstmt.setString(15, client.getCon_agnt_dept());
			pstmt.setString(16, client.getCon_agnt_title());
			pstmt.setString(17, client.getEtc()			);
		    pstmt.setString(18, client.getUpdate_id()	);
		    pstmt.setString(19, client.getPrint_st()	);
		    pstmt.setString(20, client.getVen_code()	);
		    pstmt.setString(21, client.getEtax_not_cau());
		    pstmt.setString(22, client.getBank_code()	);
		    pstmt.setString(23, client.getDeposit_no()	);
		    pstmt.setString(24, client.getFirm_st()		);
		    pstmt.setString(25, client.getEnp_yn()		);
		    pstmt.setString(26, client.getEnp_nm()		);
		    pstmt.setString(27, client.getFirm_type()	);
		    pstmt.setString(28, client.getFound_year()	);
		    pstmt.setString(29, client.getRepre_st()	);
		    pstmt.setString(30, client.getRepre_ssn1()+ client.getRepre_ssn2()	);
		    pstmt.setString(31, client.getRepre_addr()	);
		    pstmt.setString(32, client.getRepre_zip()	);
		    pstmt.setString(33, client.getRepre_email()	);
		    pstmt.setString(34, client.getJob()			);
		    pstmt.setString(35, client.getPay_st()		); 
		    pstmt.setString(36, client.getPay_type()	);
		    pstmt.setString(37, client.getComm_addr()	);
		    pstmt.setString(38, client.getComm_zip()	);
		    pstmt.setString(39, client.getWk_year()		);
		    pstmt.setString(40, client.getBigo_yn()		);
		    pstmt.setString(41, client.getDly_sms()		);
		    pstmt.setString(42, client.getEtc_cms()		);
		    pstmt.setString(43, client.getFine_yn()		);
		    pstmt.setString(44, client.getItem_mail_yn());
		    pstmt.setString(45, client.getTax_mail_yn()	);
			pstmt.setString(46, client.getIm_print_st()	);
			pstmt.setString(47, client.getTm_print_yn()	);
		    pstmt.setString(48, client.getBigo_value1()	);
			pstmt.setString(49, client.getBigo_value2()	);
		    pstmt.setString(50, client.getPrint_car_st());
			pstmt.setString(51, client.getPubform	 ()	);
			pstmt.setString(52, client.getNationality ());
			pstmt.setString(53, client.getEtax_item_st ());
			pstmt.setString(54, client.getDly_yn	());
		    pstmt.setString(55, client.getRepre_nm	());
			pstmt.setString(56, client.getCon_agnt_nm2());
			pstmt.setString(57, client.getCon_agnt_o_tel2());
			pstmt.setString(58, client.getCon_agnt_m_tel2());
			pstmt.setString(59, client.getCon_agnt_fax2());
			pstmt.setString(60, client.getCon_agnt_email2());
			pstmt.setString(61, client.getCon_agnt_dept2());
			pstmt.setString(62, client.getCon_agnt_title2());
			pstmt.setString(63, client.getLic_no	());
			pstmt.setString(64, client.getCms_sms	());
			pstmt.setString(65, client.getRepre_ssn2_1()+ client.getRepre_ssn2_2()	);
			pstmt.setString(66, client.getRepre_nm2()	);
		    pstmt.setString(67, client.getRepre_addr2()	);
		    pstmt.setString(68, client.getRepre_zip2()	);
		    pstmt.setString(69, client.getRepre_email2()	);
		    pstmt.setString(70, client.getClient_id	());
		    		  
		    pstmt.executeUpdate();
		
		    pstmt.close();
		    conn.commit();

	  	} catch (SQLException e) {
			System.out.println("[AddClientDatabase:updateNewClient2]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
	  	} catch (Exception e) {
			System.out.println("[AddClientDatabase:updateNewClient2]\n"+e);
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
	
	
	/**
	 *	거래처별 자산현황 리스트
	 */
	public Vector getClientAssestList(String client_id)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	" select * from client_assest "+
							" where CLIENT_ID = '"+client_id+"' ";

		query += " order by a_seq ";

		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				ClientAssestBean c_assest = new ClientAssestBean();
				c_assest.setClient_id(rs.getString("CLIENT_ID")==null?"":rs.getString("CLIENT_ID"));
				c_assest.setA_seq(rs.getString("A_SEQ")==null?"":rs.getString("A_SEQ"));
				c_assest.setC_ass1_type(rs.getString("C_ASS1_TYPE")==null?"":rs.getString("C_ASS1_TYPE"));
				c_assest.setC_ass1_addr(rs.getString("C_ASS1_ADDR")==null?"":rs.getString("C_ASS1_ADDR"));
				c_assest.setC_ass1_zip(rs.getString("C_ASS1_ZIP")==null?"":rs.getString("C_ASS1_ZIP"));
				c_assest.setC_ass2_type(rs.getString("C_ASS2_TYPE")==null?"":rs.getString("C_ASS2_TYPE"));
				c_assest.setC_ass2_addr(rs.getString("C_ASS2_ADDR")==null?"":rs.getString("C_ASS2_ADDR"));
				c_assest.setC_ass2_zip(rs.getString("C_ASS2_ZIP")==null?"":rs.getString("C_ASS2_ZIP"));
				c_assest.setR_ass1_type(rs.getString("R_ASS1_TYPE")==null?"":rs.getString("R_ASS1_TYPE"));
				c_assest.setR_ass1_addr(rs.getString("R_ASS1_ADDR")==null?"":rs.getString("R_ASS1_ADDR"));
				c_assest.setR_ass1_zip(rs.getString("R_ASS1_ZIP")==null?"":rs.getString("R_ASS1_ZIP"));
				c_assest.setR_ass2_type(rs.getString("R_ASS2_TYPE")==null?"":rs.getString("R_ASS2_TYPE"));
				c_assest.setR_ass2_addr(rs.getString("R_ASS2_ADDR")==null?"":rs.getString("R_ASS2_ADDR"));
				c_assest.setR_ass2_zip(rs.getString("R_ASS2_ZIP")==null?"":rs.getString("R_ASS2_ZIP"));
				vt.add(c_assest);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AddClientDatabase:getClientAssestList]\n"+e);
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
	 *	거래처별 자산 리스트
	 */
	public ClientAssestBean getClientAssest(String client_id, String seq)
	{
		getConnection();
		ClientAssestBean c_assest = new ClientAssestBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	" select * from client_assest "+
							" where CLIENT_ID = '"+client_id+"' and a_seq = '"+seq+"' ";

		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{
				c_assest.setClient_id(rs.getString("CLIENT_ID")==null?"":rs.getString("CLIENT_ID"));
				c_assest.setA_seq(rs.getString("A_SEQ")==null?"":rs.getString("A_SEQ"));
				c_assest.setC_ass1_type(rs.getString("C_ASS1_TYPE")==null?"":rs.getString("C_ASS1_TYPE"));
				c_assest.setC_ass1_addr(rs.getString("C_ASS1_ADDR")==null?"":rs.getString("C_ASS1_ADDR"));
				c_assest.setC_ass1_zip(rs.getString("C_ASS1_ZIP")==null?"":rs.getString("C_ASS1_ZIP"));
				c_assest.setC_ass2_type(rs.getString("C_ASS1_TYPE")==null?"":rs.getString("C_ASS2_TYPE"));
				c_assest.setC_ass2_addr(rs.getString("C_ASS1_ADDR")==null?"":rs.getString("C_ASS2_ADDR"));
				c_assest.setC_ass2_zip(rs.getString("C_ASS1_ZIP")==null?"":rs.getString("C_ASS2_ZIP"));
				c_assest.setR_ass1_type(rs.getString("R_ASS1_TYPE")==null?"":rs.getString("R_ASS1_TYPE"));
				c_assest.setR_ass1_addr(rs.getString("R_ASS1_ADDR")==null?"":rs.getString("R_ASS1_ADDR"));
				c_assest.setR_ass1_zip(rs.getString("R_ASS1_ZIP")==null?"":rs.getString("R_ASS1_ZIP"));
				c_assest.setR_ass2_type(rs.getString("R_ASS2_TYPE")==null?"":rs.getString("R_ASS2_TYPE"));
				c_assest.setR_ass2_addr(rs.getString("R_ASS2_ADDR")==null?"":rs.getString("R_ASS2_ADDR"));
				c_assest.setR_ass2_zip(rs.getString("R_ASS2_ZIP")==null?"":rs.getString("R_ASS2_ZIP"));													
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println(e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return c_assest;
		}
	}
	
	
	/**
	 *	거래처 자산 UPDATE
	 */
	public boolean updateClientAssest(ClientAssestBean c_assest)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query  = " update CLIENT_ASSEST set "+
						" c_ass1_type=?, "+
						" c_ass1_addr=?, "+
						" c_ass1_zip=?, "+
						" c_ass2_type=?, "+
						" c_ass2_addr=?, "+
						" c_ass2_zip=?, "+
						" r_ass1_type=?, "+
						" r_ass1_addr=?, "+
						" r_ass1_zip=?, "+
						" r_ass2_type=?, "+
						" r_ass2_addr=?, "+
						" r_ass2_zip=? "+
						" where CLIENT_ID=? and A_SEQ=? ";

		try
		{
			conn.setAutoCommit(false);
				
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1,  c_assest.getC_ass1_type());
			pstmt.setString(2,  c_assest.getC_ass1_addr());
			pstmt.setString(3,  c_assest.getC_ass1_zip());
			pstmt.setString(4,  c_assest.getC_ass2_type());
			pstmt.setString(5,  c_assest.getC_ass2_addr());
			pstmt.setString(6,  c_assest.getC_ass2_zip());
			pstmt.setString(7,  c_assest.getR_ass1_type());
			pstmt.setString(8,  c_assest.getR_ass1_addr());
			pstmt.setString(9,  c_assest.getR_ass1_zip());
			pstmt.setString(10,  c_assest.getR_ass2_type());
			pstmt.setString(11,  c_assest.getR_ass2_addr());
			pstmt.setString(12,  c_assest.getR_ass2_zip());
			pstmt.setString(13, c_assest.getClient_id());
			pstmt.setString(14, c_assest.getA_seq());
		    pstmt.executeUpdate();
		    
		    pstmt.close();
		    conn.commit();

		} catch (SQLException e) {
			System.out.println(e);
			flag = false;
	  		e.printStackTrace();
	  		conn.rollback();
	  	} catch (Exception e) {
			System.out.println(e);
	  		flag = false;
	  		e.printStackTrace();
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	/**
	 *	거래처별 재무제표현황 리스트
	 */
	public Vector getClientFinList(String client_id)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query =	" select CLIENT_ID, F_SEQ, C_KISU, " +
						" decode(C_BA_YEAR, '', '', substr(C_BA_YEAR, 1, 4) || '-' || substr(C_BA_YEAR, 5, 2) || '-'||substr(C_BA_YEAR, 7, 2)) C_BA_YEAR, "+ 
						" decode(C_BA_YEAR_S, '', '', substr(C_BA_YEAR_S, 1, 4) || '-' || substr(C_BA_YEAR_S, 5, 2) || '-'||substr(C_BA_YEAR_S, 7, 2)) C_BA_YEAR_S, "+ 
						" C_ASSET_TOT, C_CAP, C_CAP_TOT, C_SALE, F_KISU, " + 
						" decode(F_BA_YEAR, '', '', substr(F_BA_YEAR, 1, 4) || '-' || substr(F_BA_YEAR, 5, 2) || '-'||substr(F_BA_YEAR, 7, 2)) F_BA_YEAR, "+
						" decode(F_BA_YEAR_S, '', '', substr(F_BA_YEAR_S, 1, 4) || '-' || substr(F_BA_YEAR_S, 5, 2) || '-'||substr(F_BA_YEAR_S, 7, 2)) F_BA_YEAR_S, "+
						" F_ASSET_TOT, F_CAP, F_CAP_TOT, F_SALE,"+
						" C_PROFIT, F_PROFIT"+
						" from client_fin "+
						" where CLIENT_ID = '"+client_id+"' ";

		query += " order by f_seq ";

		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				ClientFinBean c_fin = new ClientFinBean();
				c_fin.setClient_id	(rs.getString("CLIENT_ID")==null?"":rs.getString("CLIENT_ID"));
				c_fin.setF_seq		(rs.getString("F_SEQ")==null?"":rs.getString("F_SEQ"));
				c_fin.setC_kisu		(rs.getString("C_KISU")==null?"":rs.getString("C_KISU"));
				c_fin.setC_ba_year	(rs.getString("C_BA_YEAR")==null?"":rs.getString("C_BA_YEAR"));
				c_fin.setC_ba_year_s(rs.getString("C_BA_YEAR_S")==null?"":rs.getString("C_BA_YEAR_S"));
				c_fin.setC_asset_tot(rs.getString("C_ASSET_TOT")==null?0:Float.parseFloat(rs.getString("C_ASSET_TOT")));
				c_fin.setC_cap		(rs.getString("C_CAP")==null?0:Float.parseFloat(rs.getString("C_CAP")));
				c_fin.setC_cap_tot	(rs.getString("C_CAP_TOT")==null?0:Float.parseFloat(rs.getString("C_CAP_TOT")));
				c_fin.setC_sale		(rs.getString("C_SALE")==null?0:Float.parseFloat(rs.getString("C_SALE")));
				c_fin.setF_kisu		(rs.getString("F_KISU")==null?"":rs.getString("F_KISU"));
				c_fin.setF_ba_year	(rs.getString("F_BA_YEAR")==null?"":rs.getString("F_BA_YEAR"));
				c_fin.setF_ba_year_s(rs.getString("F_BA_YEAR_S")==null?"":rs.getString("F_BA_YEAR_S"));
				c_fin.setF_asset_tot(rs.getString("F_ASSET_TOT")==null?0:Float.parseFloat(rs.getString("F_ASSET_TOT")));
				c_fin.setF_cap		(rs.getString("F_CAP")==null?0:Float.parseFloat(rs.getString("F_CAP")));
				c_fin.setF_cap_tot	(rs.getString("F_CAP_TOT")==null?0:Float.parseFloat(rs.getString("F_CAP_TOT")));
				c_fin.setF_sale		(rs.getString("F_SALE")==null?0:Float.parseFloat(rs.getString("F_SALE")));
				c_fin.setC_profit	(rs.getString("C_PROFIT")==null?0:Float.parseFloat(rs.getString("C_PROFIT")));
				c_fin.setF_profit	(rs.getString("F_PROFIT")==null?0:Float.parseFloat(rs.getString("F_PROFIT")));
				vt.add(c_fin);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println(e);
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
	 *	거래처 약식재무제표 리스트
	 */
	public ClientFinBean getClientFin(String client_id, String seq)
	{
		getConnection();
		ClientFinBean c_fin = new ClientFinBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	" select CLIENT_ID, F_SEQ, C_KISU, " +
						" decode(C_BA_YEAR, '', '', substr(C_BA_YEAR, 1, 4) || '-' || substr(C_BA_YEAR, 5, 2) || '-'||substr(C_BA_YEAR, 7, 2)) C_BA_YEAR, "+ 
						" decode(C_BA_YEAR_S, '', '', substr(C_BA_YEAR_S, 1, 4) || '-' || substr(C_BA_YEAR_S, 5, 2) || '-'||substr(C_BA_YEAR_S, 7, 2)) C_BA_YEAR_S, "+ 
						" C_ASSET_TOT, C_CAP, C_CAP_TOT, C_SALE, F_KISU, " + 
						" decode(F_BA_YEAR, '', '', substr(F_BA_YEAR, 1, 4) || '-' || substr(F_BA_YEAR, 5, 2) || '-'||substr(F_BA_YEAR, 7, 2)) F_BA_YEAR, "+
						" decode(F_BA_YEAR_S, '', '', substr(F_BA_YEAR_S, 1, 4) || '-' || substr(F_BA_YEAR_S, 5, 2) || '-'||substr(F_BA_YEAR_S, 7, 2)) F_BA_YEAR_S, "+
						" F_ASSET_TOT, F_CAP, F_CAP_TOT, F_SALE, C_PROFIT, F_PROFIT "+
						" from client_fin "+
						" where CLIENT_ID = '"+client_id+"' and f_seq = '"+seq+"'";

		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{
							
				c_fin.setClient_id(rs.getString("CLIENT_ID")==null?"":rs.getString("CLIENT_ID"));
				c_fin.setF_seq(rs.getString("F_SEQ")==null?"":rs.getString("F_SEQ"));
				c_fin.setC_kisu(rs.getString("C_KISU")==null?"":rs.getString("C_KISU"));
				c_fin.setC_ba_year(rs.getString("C_BA_YEAR")==null?"":rs.getString("C_BA_YEAR"));
				c_fin.setC_asset_tot(rs.getString("C_ASSET_TOT")==null?0:Float.parseFloat(rs.getString("C_ASSET_TOT")));
				c_fin.setC_cap(rs.getString("C_CAP")==null?0:Float.parseFloat(rs.getString("C_CAP")));
				c_fin.setC_cap_tot(rs.getString("C_CAP_TOT")==null?0:Float.parseFloat(rs.getString("C_CAP_TOT")));
				c_fin.setC_sale(rs.getString("C_SALE")==null?0:Float.parseFloat(rs.getString("C_SALE")));
				c_fin.setF_kisu(rs.getString("F_KISU")==null?"":rs.getString("F_KISU"));
				c_fin.setF_ba_year(rs.getString("F_BA_YEAR")==null?"":rs.getString("F_BA_YEAR"));
				c_fin.setF_asset_tot(rs.getString("F_ASSET_TOT")==null?0:Float.parseFloat(rs.getString("F_ASSET_TOT")));
				c_fin.setF_cap(rs.getString("F_CAP")==null?0:Float.parseFloat(rs.getString("F_CAP")));
				c_fin.setF_cap_tot(rs.getString("F_CAP_TOT")==null?0:Float.parseFloat(rs.getString("F_CAP_TOT")));
				c_fin.setF_sale(rs.getString("F_SALE")==null?0:Float.parseFloat(rs.getString("F_SALE")));
				c_fin.setC_profit	(rs.getString("C_PROFIT")==null?0:Float.parseFloat(rs.getString("C_PROFIT")));
				c_fin.setF_profit	(rs.getString("F_PROFIT")==null?0:Float.parseFloat(rs.getString("F_PROFIT")));
				c_fin.setC_ba_year_s(rs.getString("C_BA_YEAR_S")==null?"":rs.getString("C_BA_YEAR_S"));
				c_fin.setF_ba_year_s(rs.getString("F_BA_YEAR_S")==null?"":rs.getString("F_BA_YEAR_S"));
			
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
		  	System.out.println("[AddClientDatabase:getClientFin]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return c_fin;
		}
	}
		
	/**
	 *	거래처 약식재무제표 리스트
	 */
	public String getClientFinSeq(String client_id, String c_kisu, String c_ba_year)
	{
		getConnection();
		String f_seq = "";
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String query = 	" select F_SEQ from client_fin where CLIENT_ID=? and c_kisu =? and c_ba_year=replace(?, '-', '')";

		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, client_id);
				pstmt.setString(2, c_kisu);
				pstmt.setString(3, c_ba_year);
		    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{
				f_seq = rs.getString("F_SEQ")==null?"":rs.getString("F_SEQ");
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println(e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return f_seq;
		}
	}

	/**
	 *	거래처 재무제표 UPDATE
	 */
	public boolean updateClientFin(ClientFinBean c_fin)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query  = " update CLIENT_FIN set "+
						" c_kisu		=?,	"+
						" c_ba_year		=?, "+
						" c_asset_tot	=?, "+
						" c_cap			=?, "+
						" c_cap_tot		=?, "+
						" c_sale		=?, "+
						" f_kisu		=?, "+
						" f_ba_year		=?, "+
						" f_asset_tot	=?, "+
						" f_cap			=?, "+
						" f_cap_tot		=?, "+
						" f_sale		=?, "+
						" c_profit		=?, "+
						" f_profit		=?, "+
						" c_ba_year_s	=replace(?, '-', ''), "+
						" f_ba_year_s	=replace(?, '-', '')  "+
						" where CLIENT_ID=? and F_SEQ=? ";

		try
		{
			conn.setAutoCommit(false);
				
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1,  c_fin.getC_kisu());
			pstmt.setString(2,  c_fin.getC_ba_year());
			pstmt.setFloat(3,   c_fin.getC_asset_tot());
			pstmt.setFloat(4,   c_fin.getC_cap());
			pstmt.setFloat(5,   c_fin.getC_cap_tot());
			pstmt.setFloat(6,   c_fin.getC_sale());
			pstmt.setString(7,  c_fin.getF_kisu());
			pstmt.setString(8,  c_fin.getF_ba_year());
			pstmt.setFloat(9,   c_fin.getF_asset_tot());
			pstmt.setFloat(10,  c_fin.getF_cap());
			pstmt.setFloat(11,  c_fin.getF_cap_tot());
			pstmt.setFloat(12,  c_fin.getF_sale());
			pstmt.setFloat(13,  c_fin.getC_profit());
			pstmt.setFloat(14,  c_fin.getF_profit());
			pstmt.setString(15, c_fin.getC_ba_year_s());
			pstmt.setString(16, c_fin.getF_ba_year_s());
			pstmt.setString(17, c_fin.getClient_id());
			pstmt.setString(18, c_fin.getF_seq());
		    pstmt.executeUpdate();
		    
		    pstmt.close();
		    conn.commit();

		} catch (SQLException e) {
			System.out.println(e);
			flag = false;
	  		e.printStackTrace();
	  		conn.rollback();
	  	} catch (Exception e) {
			System.out.println(e);
	  		flag = false;
	  		e.printStackTrace();
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//거래처구분 현황
	public Vector getClientStStat()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.client_st, \n"+
				"        decode(a.client_st,'1','법인','2','개인','3','개인사업자(일반과세)','4','개인사업자(간이과세)','5','개인사업자(면세사업자)') client_st_nm, \n"+
				"        count(*) cnt \n"+
				" from   client a, (select client_id from cont where car_st <> '4' and use_yn='Y' group by client_id) b \n"+
				" where  a.client_id=b.client_id \n"+
				" group by a.client_st \n"+
				" order by decode(a.client_st,'1',0,'3',1,'4',2,'5',3,'2',4)"+
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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AddClientDatabase:getClientStStat]\n"+e);
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

	//법인형태 현황
	public Vector getFirmTypeStat()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select nvl(a.firm_type,'5') firm_type, \n"+
				"        decode(nvl(a.firm_type,'5'),'1','유가증권시장','2','코스닥시장','3','외감법인','4','벤처기업','5','일반법인','6','국가','7','지방자치단체','8','정부투자기관','9','정부출연연구기관', '10', '비영리법인' ) firm_type_nm, \n"+
				"        count(*) cnt \n"+
				" from   client a, (select client_id from cont where car_st <> '4' and  use_yn='Y' group by client_id) b \n"+
				" where  a.client_st='1' and a.client_id=b.client_id \n"+
				" group by nvl(a.firm_type,'5') \n"+
				" order by nvl(a.firm_type,'5')"+
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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AddClientDatabase:getFirmTypeStat]\n"+e);
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

	//부가세환급대상차량 여부
	public Hashtable getTaxPrintCarStChk(String client_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select b.client_id, b.firm_nm, count(*) tax_cnt, min(e.cnt) tot_cnt \n"+
				" from cont a, client b, car_etc c, car_nm d, (select client_id, count(*) cnt from cont where client_id='"+client_id+"' and nvl(use_yn,'Y')='Y' group by client_id) e \n"+
				" where a.client_id='"+client_id+"' and nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3','4') \n"+
				" and a.client_id=b.client_id \n"+
				" and a.rent_l_cd=c.rent_l_cd and a.car_st <> '4' \n"+
				" and c.car_id=d.car_id and c.car_seq=d.car_seq \n"+
				" and d.s_st in ('100','409','101','601','602','700','701','702','801','802','803','811','821') \n"+
				" and b.print_st not in ('1','9') \n"+
				" and nvl(b.print_car_st,'0')<>'1' \n"+
				" and a.client_id=e.client_id \n"+
				" and a.car_mng_id is not null \n"+
				" group by b.client_id, b.firm_nm \n"+
				" having count(*)>0 and count(*) < min(e.cnt) \n"+
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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AddClientDatabase:getTaxPrintCarStChk]\n"+e);
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
	


	/**
	 *	
	 *	거래처별 좌표 가져오기 
	 */	
	public Vector getClientListXY()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select * from client_xy where x_gps is not null AND reg_id in ('000212','000144','000130') ";
		
//System.out.println("[AddClientDatabase:getClientListXY]\n"+query);

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
			System.out.println("[AddClientDatabase:getClientListXY]\n"+e);
			System.out.println("[AddClientDatabase:getClientListXY]\n"+query);
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

	// agent > 고객관리 > 거래처계약현황 

	public Vector getClientContStat(String dt, String ref_dt1, String ref_dt2, String gubun2, String gubun3, String gubun4, String gubun5, String sort, String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String where = "";		

		if(dt.equals("1"))	where = " and rent_dt = to_char(sysdate,'YYYYMMDD')";
		if(dt.equals("2"))	where = " and rent_dt like to_char(sysdate,'YYYYMM')||'%' ";
		if(dt.equals("4"))	where = " and rent_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')";

		query = " SELECT decode(b.client_st,'1','법인','2','개인','개인사업자') client_st, b.firm_nm, b.client_nm, b.client_id, a.cont_cnt\r\n" + 
				"FROM (\r\n" + 
				"SELECT client_id, COUNT(0) cont_cnt, MAX(rent_mng_id||rent_l_cd) max_rent_id\r\n" + 
				"FROM   cont  \r\n" + 
				"WHERE  BUS_ID='"+user_id+"' AND (use_yn IS NULL OR use_yn='Y') and car_st in ('1','3') "+where+" \r\n" + 
				"GROUP BY client_id\r\n" + 
				") a, client b\r\n" + 
				"WHERE a.client_id=b.client_id";
				
		if(gubun3.equals("1"))	query += " and b.client_st='1'";
		if(gubun3.equals("2"))	query += " and b.client_st='2'";
		if(gubun3.equals("3"))	query += " and b.client_st not in ('1','2')";
	
		query += " order by a.cont_cnt desc, b.firm_nm";

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
			System.out.println("[AddClientDatabase:getClientContStat]\n"+e);
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


	//fms검색 - 상호명, 대표자명
	public Vector getFmsSearchClientList(String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select C.CLIENT_ID, C.CLIENT_ST, C.CLIENT_NM, nvl(C.FIRM_NM, C.client_nm) FIRM_NM, \n"+
				"        decode(C.CLIENT_ST, '1', '법인', '2', '개인', '3', '개인사업자', '4', '개인사업자', '5','개인사업자') CLIENT_ST_NM, \n"+
				"        C.CON_AGNT_NM, C.O_TEL, C.M_TEL, C.HOMEPAGE,  \n"+
				"        C.FAX, C.O_ZIP, C.O_ADDR, C.enp_no,  TEXT_DECRYPT(c.ssn, 'pw' ) ssn,  \n"+
				"        decode(nvl(D.use_cnt,0),0,'N','Y') use_yn,  \n"+
				"        nvl(D.use_cnt,0) use_cnt,  \n"+
				"        nvl(D.cont_cnt,0) cont_cnt,  \n"+
				"        D.car_mng_id, D.rent_mng_id, D.rent_l_cd, D.car_no, D.y_car_no, D.rent_way, D.y_rent_way, D.rent_way_1_cnt, D.rent_way_2_cnt  \n"+
				" from   client C,  \n"+
				"        ( select client_id,  \n"+
				"                 max(a.car_mng_id) car_mng_id, \n"+
				"                 max(b.car_no) car_no, \n"+
				"                 max(decode(nvl(a.use_yn,'Y'),'Y',b.car_no)) y_car_no, \n"+
				"                 max(a.rent_way) rent_way, \n"+
				"                 max(decode(nvl(a.use_yn,'Y'),'Y',a.rent_way)) y_rent_way, \n"+
				"                 max(a.rent_mng_id) rent_mng_id, \n"+
				"                 max(a.rent_l_cd) rent_l_cd,  \n"+
				"                 count(decode(nvl(a.use_yn,'Y'),'Y',a.rent_l_cd)) as use_cnt,  \n"+
				"                 count(a.rent_l_cd) as cont_cnt,  \n"+
				"                 count(decode(nvl(a.use_yn,'Y'),'Y',decode(a.RENT_WAY_CD,'1',a.rent_l_cd))) as rent_way_1_cnt,  \n"+
				"                 count(decode(nvl(a.use_yn,'Y'),'Y',decode(a.RENT_WAY_CD,'1','',a.rent_l_cd))) as rent_way_2_cnt  \n"+
				"          from   cont_n_view a, car_reg b where a.car_mng_id = b.car_mng_id(+)  \n"+
				"          group by a.client_id \n"+
				"        ) D \n"+
				" where  \n"+
				" ";
		
		if(s_kd.equals("1"))		query += " upper(nvl(C.firm_nm, ' '))		like upper('%"+t_wd+"%') \n";
		if(s_kd.equals("3"))		query += " upper(nvl(C.client_nm, ' '))	    like upper('%"+t_wd+"%') \n";

		query += "       and C.client_id=d.client_id(+) \n"+
				 " order by decode(nvl(D.use_cnt,0),0,'N','Y') desc, C.firm_nm";


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
			System.out.println("[AddClientDatabase:getFmsSearchClientList]\n"+e);
			System.out.println("[AddClientDatabase:getFmsSearchClientList]\n"+query);
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


	//fms검색 - 전화번호
	public Vector getFmsSearchTelList(String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select distinct \n"+
				"        C.CLIENT_ID, C.CLIENT_ST, C.CLIENT_NM, nvl(C.FIRM_NM, C.client_nm) FIRM_NM, \n"+
				"        decode(C.CLIENT_ST, '1', '법인', '2', '개인', '3', '개인사업자', '4', '개인사업자', '5','개인사업자') CLIENT_ST_NM, \n"+
				"        C.CON_AGNT_NM, C.O_TEL, C.M_TEL, C.H_TEL, C.HOMEPAGE, \n"+
				"        C.FAX, C.O_ZIP, C.O_ADDR, C.enp_no,  TEXT_DECRYPT(c.ssn, 'pw' ) ssn, \n"+
				"        decode(nvl(D.use_cnt,0),0,'N','Y') use_yn, \n"+
				"        nvl(D.use_cnt,0) use_cnt, \n"+
				"        nvl(D.cont_cnt,0) cont_cnt, \n"+
				"        D.car_mng_id, D.rent_mng_id, D.rent_l_cd \n"+
//				"        decode(C.o_tel,'','','| (사무실)'||C.o_tel||'<br>')||"+
//				"        decode(C.m_tel,'','','| (휴대폰)'||C.m_tel||'<br>')||"+
//				"        decode(C.h_tel,'','','| (자  택)'||C.h_tel||'<br>')||"+
//				"        decode(C.fax,  '','','| (F A X) &nbsp;'||C.fax)        as client_h_tel \n"+
//				"        decode(C.con_agnt_m_tel,'','','(계산서담당)'||C.con_agnt_m_tel||' '||C.con_agnt_o_tel||' '||C.con_agnt_fax)||' '||E.h_mgr_tel2 as mgr_h_tel \n"+
				" from   client C, \n"+
				"        ( select client_id, \n"+
				"                 min(car_mng_id) car_mng_id, min(rent_mng_id) rent_mng_id, min(rent_l_cd) rent_l_cd, \n"+
				"                 count(decode(nvl(use_yn,'Y'),'Y',rent_l_cd)) as use_cnt, \n"+
				"                 count(rent_l_cd) as cont_cnt \n"+
				"          from   cont \n"+
				"          group by client_id \n"+
				"        ) D, \n"+
				"        ( select a.client_id, \n"+
				"                 d.mgr_m_tel||d.mgr_tel||e.mgr_m_tel||e.mgr_tel||f.mgr_m_tel||f.mgr_tel||h.mgr_m_tel||h.mgr_tel as h_mgr_tel \n"+
//				"                 ' (차량이용자)'||d.mgr_m_tel||' '||d.mgr_tel||' '||"+
//				"                 ' (차량관리자)'||e.mgr_m_tel||' '||e.mgr_tel||' '||"+
//				"                 ' (회계관리자)'||f.mgr_m_tel||' '||f.mgr_tel||' '||"+
//				"                 ' (계약담당자)'||h.mgr_m_tel||' '||h.mgr_tel          as h_mgr_tel2 \n"+
				" 		   from   cont a, \n"+
				" 				  (select * from car_mgr where mgr_st='차량이용자') d, \n"+
				" 				  (select * from car_mgr where mgr_st='차량관리자') e, \n"+
				" 				  (select * from car_mgr where mgr_st='회계관리자') f, \n"+
				" 				  (select * from car_mgr where mgr_st='계약담당자') h  \n"+
				" 		   where   \n"+
				" 				  a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd(+) \n"+
				" 				  and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd(+) \n"+
				" 				  and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd(+) \n"+
				" 				  and a.rent_mng_id=h.rent_mng_id and a.rent_l_cd=h.rent_l_cd(+) \n"+
				" 				  and replace(d.mgr_m_tel||d.mgr_tel||e.mgr_m_tel||e.mgr_tel||f.mgr_m_tel||f.mgr_tel||h.mgr_m_tel||h.mgr_tel,'-','') like replace('%"+t_wd+"%','-','') \n"+
				"        ) E \n"+
				" where  C.client_id=d.client_id(+) and C.client_id=E.client_id(+)\n";

		query += " and nvl(replace(C.o_tel||C.m_tel||C.h_tel||C.fax||C.con_agnt_m_tel||C.con_agnt_o_tel||C.con_agnt_fax||E.h_mgr_tel,'-',''), ' ') like replace('%"+t_wd+"%','-','') \n";

		query += " order by decode(nvl(D.use_cnt,0),0,'N','Y') desc,nvl(C.FIRM_NM, C.client_nm)";


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
			System.out.println("[AddClientDatabase:getFmsSearchTelList]\n"+e);
			System.out.println("[AddClientDatabase:getFmsSearchTelList]\n"+query);
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

   
	public Vector getClientMgrList(String client_id, String site_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select "+
				"        a.rent_l_cd, a.rent_mng_id, a.use_yn, a.p_zip, nvl(a.p_addr,'미등록') p_addr, "+
				"        a.tax_agnt, a.tax_type, b.firm_nm, c.cnt, b.client_nm, nvl(b.o_tel,nvl(b.m_tel,b.h_tel)) tel, "+
				"        g.car_no, c.cnt, decode(a.use_yn,'Y','대여','N','해지','미결') use_yn_nm, "+
				"        d.mgr_id as mgr_id1, nvl(d.mgr_nm,'미등록')||' '||d.mgr_title as mgr_nm1, nvl(d.mgr_m_tel,d.mgr_tel) mgr_tel1, d.mgr_email as mgr_email1, "+
				"        e.mgr_id as mgr_id2, nvl(e.mgr_nm,'미등록')||' '||e.mgr_title as mgr_nm2, nvl(e.mgr_m_tel,e.mgr_tel) mgr_tel2, e.mgr_email as mgr_email2, "+
				"        f.mgr_id as mgr_id3, nvl(f.mgr_nm,'미등록')||' '||f.mgr_title as mgr_nm3, nvl(f.mgr_m_tel,f.mgr_tel) mgr_tel3, f.mgr_email as mgr_email3, "+
				"        h.mgr_id as mgr_id4, nvl(h.mgr_nm,'미등록')||' '||h.mgr_title as mgr_nm4, nvl(h.mgr_m_tel,h.mgr_tel) mgr_tel4, h.mgr_email as mgr_email4  "+
				" from   cont a, client b, "+
				"        (select client_id, count(decode(nvl(use_yn,'Y'),'Y',rent_l_cd)) cnt from cont group by client_id) c, "+
				"        (select * from car_mgr where mgr_st='차량이용자') d, "+
				"        (select * from car_mgr where mgr_st='차량관리자') e, "+
				"        (select * from car_mgr where mgr_st='회계관리자') f, "+
				"        (select * from car_mgr where mgr_st='회계관리자') h, "+
				"        car_reg g "+
				" where  a.client_id='"+client_id+"' "+
				" and a.client_id=b.client_id and a.client_id=c.client_id"+
				" and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd(+)"+
				" and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd(+)"+
				" and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd(+)"+
				" and a.rent_mng_id=h.rent_mng_id and a.rent_l_cd=h.rent_l_cd(+)"+
				" and a.car_mng_id=g.car_mng_id ";

		if(!site_id.equals("")){
			if(site_id.equals("00"))	query += " and a.r_site is null ";
			else						query += " and a.r_site='"+site_id+"'";

			query += " and nvl(a.use_yn,'Y')='Y' ";
		}

		query += " order by a.use_yn desc, g.car_no";
		
		
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
			System.out.println("[AddClientDatabase:getClientMgrList]\n"+e);
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
	 *	gubun - 1: 상호 2: 계약자, 3:담당자, 4: 전화번호, 5:휴대폰, 6:주소
	 *	asc - 1 : 내림차순, 0: 오름차순
	 */	
	public Vector getClientList(String s_kd, String t_wd, String asc, String ck_acar_id, String sa_code)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select \n"+
				"        C.CLIENT_ID, C.CLIENT_ST, C.CLIENT_NM, nvl(C.FIRM_NM, C.client_nm) FIRM_NM, \n"+
				"        decode(C.CLIENT_ST, '1', '법인', '2', '개인', '3', '일반과세자', '4', '간이과세자','5','면세사업자','6','경매장') CLIENT_ST_NM, \n"+
				"        C.CON_AGNT_NM, C.O_TEL, C.M_TEL, C.HOMEPAGE, \n"+
				"        C.FAX, C.O_ZIP, C.O_ADDR, C.enp_no, TEXT_DECRYPT(c.ssn, 'pw' ) ssn, C.lic_no, \n"+
				"        CASE WHEN NVL(D.lt_cnt,0)=0 THEN 'N' ELSE 'Y' END use_yn, \n"+
		        "        NVL(D.lt_cnt,0) lt_cnt \n"+
				" from   client C, \n"+
			    "        ( select a.client_id, count(0) lt_cnt "+
				"          from   cont a, fee b, commi c, cont_etc d, cont a2 "+
				"          where  a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.RENT_L_CD(+) "+
				"                 and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd "+
				"                 and d.rent_suc_m_id=a2.rent_mng_id(+) and d.rent_suc_l_cd=a2.rent_l_cd(+) "+
				"                 and (a.bus_id='"+ck_acar_id+"' or b.ext_agnt='"+ck_acar_id+"' or c.emp_id='"+sa_code+"' or nvl(a2.bus_id,'')='"+ck_acar_id+"') "+
				"          group by a.client_id "+
				"        ) D "+
				" where  ";
		
		if(s_kd.equals("client_id") && !t_wd.equals("")){
			query += " C.client_id='"+t_wd+"' and ";
		}

		query += " C.client_id=D.client_id(+) and ( C.reg_id ='"+ck_acar_id+"' or C.update_id='"+ck_acar_id+"' or D.client_id is not null ) \n";


		if(s_kd.equals("2"))		query += " and nvl(C.client_nm, ' ') like '%"+t_wd+"%'		order by decode(D.client_id,'','N','Y') desc, C.firm_nm";
		else if(s_kd.equals("3"))	query += " and nvl(C.CON_AGNT_NM, ' ') like '%"+t_wd+"%'	order by decode(D.client_id,'','N','Y') desc, C.CON_AGNT_NM";
		else if(s_kd.equals("4"))	query += " and nvl(C.o_tel, ' ')  like '%"+t_wd+"%'			order by decode(D.client_id,'','N','Y') desc, C.o_tel";
		else if(s_kd.equals("5"))	query += " and nvl(C.m_tel, ' ')  like '%"+t_wd+"%'			order by decode(D.client_id,'','N','Y') desc, C.m_tel";
		else if(s_kd.equals("6"))	query += " and nvl(C.o_addr, ' ')  like '%"+t_wd+"%'		order by decode(D.client_id,'','N','Y') desc, C.o_addr";
		else if(s_kd.equals("7"))	query += " and nvl(C.enp_no||TEXT_DECRYPT(c.ssn, 'pw' ) , ' ')  like '%"+t_wd+"%' order by decode(D.client_id,'','N','Y') desc, C.client_st, C.enp_no||TEXT_DECRYPT(c.ssn, 'pw' ) ";
		else if(s_kd.equals("8"))	query += " and C.client_st='6'								order by decode(D.client_id,'','N','Y') desc, nvl(C.firm_nm, C.client_nm) ";
		else if(s_kd.equals("12"))	query += " and C.client_id='"+t_wd+"'						order by C.client_id ";
		else if(s_kd.equals("13"))	query += " and C.item_mail_yn='N'							order by nvl(C.firm_nm, C.client_nm) ";
		else						query += " and nvl(C.firm_nm, ' ') like '%"+t_wd+"%'		order by decode(D.client_id,'','N','Y') desc, nvl(C.firm_nm, C.client_nm)";



		if(asc.equals("0"))		query += " asc";
		else if(asc.equals("1"))	query += " desc";



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
			System.out.println("[AddClientDatabase:getClientList]\n"+e);
			System.out.println("[AddClientDatabase:getClientList]\n"+query);
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
	 *	불량임차인 체크
	 */
	public Vector getClientRentCheck(String firm_nm, String nm, String ent_no, String lic_no, String m_tel, String h_tel, String o_tel, String email, String fax)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

        query = " SELECT * FROM client "+
				" where ( REPLACE(REPLACE(REPLACE(firm_nm,' ',''),'(주)',''),'주식회사','') like REPLACE(REPLACE(REPLACE('%"+firm_nm+"%',' ',''),'(주)',''),'주식회사','') \n"+
			    " ";

		if(!nm.equals(""))			query +=" OR REPLACE(REPLACE(client_nm,' ',''),'-','') = REPLACE(REPLACE('"+nm+"',' ',''),'-','') ";
		if(!ent_no.equals(""))		query +=" OR REPLACE(REPLACE(substr(text_decrypt(user_psd, 'pw'),1,6),' ',''),'-','') = REPLACE(REPLACE('"+ent_no+"',' ',''),'-','') ";
		if(!ent_no.equals(""))		query +=" OR REPLACE(REPLACE(enp_no,' ',''),'-','') = REPLACE(REPLACE('"+ent_no+"',' ',''),'-','') ";
		if(!lic_no.equals(""))		query +=" OR REPLACE(REPLACE(lic_no,' ',''),'-','') = REPLACE(REPLACE('"+lic_no+"',' ',''),'-','') ";
		if(!m_tel.equals(""))		query +=" OR REPLACE(REPLACE(m_tel,' ',''),'-','')  = REPLACE(REPLACE('"+m_tel+"',' ',''),'-','') ";
		if(!h_tel.equals(""))		query +=" OR REPLACE(REPLACE(h_tel,' ',''),'-','')  = REPLACE(REPLACE('"+h_tel+"',' ',''),'-','') ";
		if(!o_tel.equals(""))		query +=" OR REPLACE(REPLACE(o_tel,' ',''),'-','')  = REPLACE(REPLACE('"+o_tel+"',' ',''),'-','') ";
		if(!email.equals(""))		query +=" OR REPLACE(REPLACE(con_agnt_email,' ',''),'-','')  = REPLACE(REPLACE('"+email+"',' ',''),'-','') ";
		if(!fax.equals(""))			query +=" OR REPLACE(REPLACE(fax,' ',''),'-','')    = REPLACE(REPLACE('"+fax+"',' ',''),'-','') ";

		query +=" ) ";

		query += " order by reg_dt desc ";

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

			//System.out.println("[AddClientDatabase:getClientRentCheck]"+query);

		} catch (SQLException e) {
			System.out.println("[AddClientDatabase:getClientRentCheck]"+e);
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
	
	//고객 1건 조회(20181204)
	public Hashtable getClientOne(String client_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select client_id, client_st, client_nm, firm_nm, enp_no, h_tel, o_tel, m_tel, homepage, fax, bus_cdt, bus_itm, ho_addr, ho_zip, o_addr, o_zip, \n"+
				" 		 com_nm, dept, title, car_use, con_agnt_nm, con_agnt_o_tel, con_agnt_m_tel, con_agnt_fax, con_agnt_email, con_agnt_dept, con_agnt_title, etc, open_year, 	\n"+
				" 		 firm_price, firm_price_y, firm_price_b, firm_day, firm_day_y, firm_day_b, reg_id, update_dt, update_id, rank, first_vst_dt, cycle_vst, tot_vst, ven_code, 	\n"+
				" 		 print_st, etax_yn, etax_not_cau, app_yn, deposit_no, bank_code, firm_st, enp_yn, enp_nm, firm_type, found_year, repre_st, repre_no, repre_addr, repre_zip, repre_email, \n"+
				" 		 job, pay_st, pay_type, comm_addr, comm_zip, wk_year, bigo_yn, main_client, dly_sms, fine_yn, item_mail_yn, tax_mail_yn, taxregno, im_print_st, tm_print_yn, \n"+
				" 		 bigo_value1, bigo_value2, pubform, print_car_st, nationality, etax_item_st, dly_yn, repre_nm, con_agnt_nm2, con_agnt_o_tel2, con_agnt_m_tel2,  \n"+
				" 		 con_agnt_fax2, con_agnt_email2, con_agnt_dept2, con_agnt_title2, lic_no, cms_sms, \n"+
				" 		 decode(client_st,'2',text_decrypt(ssn, 'pw'),'') as ssn \n"+
				"   from client where client_id='"+client_id+"' ";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
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
			pstmt.close();
			
			
		} catch (SQLException e) {
			System.out.println("[AddClientDatabase:getClientOne]\n"+e);
			System.out.println("[AddClientDatabase:getClientOne]\n"+query);
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
	
	/**
	 *	고객피보험자 고객확인
	 */
	public Vector getClientInsurFnmList(String client_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

        query = " SELECT a.car_mng_id, a.ins_start_dt, a.ins_exp_dt, a.con_f_nm, a.firm_emp_nm, a.enp_no, c.car_no \r\n"
        		+ "FROM   insur a, cont b, car_reg c \r\n"
        		+ "WHERE\r\n"
        		+ "a.ins_sts='1' AND a.con_f_nm NOT LIKE '%아마존카%'  \r\n"
        		+ "AND TO_CHAR(SYSDATE,'YYYYMMDD') BETWEEN a.ins_start_dt AND TO_CHAR(TO_DATE(a.ins_exp_dt,'YYYYMMDD')+1,'YYYYMMDD')\r\n"
        		+ "AND a.car_mng_id=b.car_mng_id AND (b.use_yn='Y' OR b.use_yn IS null) and a.car_mng_id=c.car_mng_id \r\n"
        		+ "AND b.client_id='"+client_id+"' ";


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
			System.out.println("[AddClientDatabase:getClientInsurFnmList]"+e);
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
	
		//거래처별 담당자 이메일
		public Vector getClientEdocList(String send_type, String client_id, String rent_l_cd)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Vector vt = new Vector();
			String query = "";

			query = " SELECT MAX(st) st, emp_nm, m_tel, email\r\n"
					+ "FROM (\r\n"
					+ "SELECT '계산서' st, con_agnt_nm AS emp_nm, con_agnt_m_tel AS m_tel, con_agnt_email AS email FROM client WHERE client_id='"+client_id+"' AND con_agnt_email IS NOT NULL\r\n"
					+ "UNION all\r\n"
					+ "SELECT mgr_st st, mgr_nm AS emp_nm, mgr_m_tel AS m_tel, mgr_email AS email FROM car_mgr WHERE  rent_l_cd='"+rent_l_cd+"' AND mgr_email IS NOT NULL\r\n"
					+ ")\r\n"
					+ "GROUP BY emp_nm, m_tel, email\r\n"
					+ "ORDER BY 1";		
			
			if(send_type.equals("m_tel")) {
				query = " SELECT MAX(st) st, emp_nm, m_tel, email\r\n"
						+ "FROM (\r\n"
						+ "SELECT '계산서' st, con_agnt_nm AS emp_nm, con_agnt_m_tel AS m_tel, con_agnt_email AS email FROM client WHERE client_id='"+client_id+"' AND con_agnt_m_tel IS NOT NULL\r\n"
						+ "UNION all\r\n"
						+ "SELECT mgr_st st, mgr_nm AS emp_nm, mgr_m_tel AS m_tel, mgr_email AS email FROM car_mgr WHERE rent_l_cd='"+rent_l_cd+"' AND mgr_m_tel IS NOT NULL\r\n"
						+ ")\r\n"
						+ "GROUP BY emp_nm, m_tel, email\r\n"
						+ "ORDER BY 1";	
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
						 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
					}
					vt.add(ht);	
				}
				rs.close();
				pstmt.close();

			} catch (SQLException e) {
				System.out.println("[AddClientDatabase:getClientMgrEmailList]\n"+e);
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
	
}
