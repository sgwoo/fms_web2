package acar.settle_acc;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.cont.*;
import acar.common.*;
import acar.fee.*;
import acar.account.*;
import acar.util.*;
import acar.estimate_mng.*;

public class SettleDatabase
{
	private Connection conn = null;
	public static SettleDatabase s_db;
	
	public static SettleDatabase getInstance()
	{
		if(SettleDatabase.s_db == null)
			SettleDatabase.s_db = new SettleDatabase();
		return SettleDatabase.s_db;	
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

	String standard_dt = "decode(rec_plan_dt, '',decode(dem_dt, '',paid_end_dt, dem_dt), rec_plan_dt)";
	String standard_dt2 = "decode(a.rec_plan_dt, '',decode(a.dem_dt, '',a.paid_end_dt, a.dem_dt), a.rec_plan_dt)";
	String standard_dt_b = "decode(b.rec_plan_dt, '',decode(b.dem_dt, '',b.paid_end_dt, b.dem_dt), b.rec_plan_dt)";


	// 조회 -------------------------------------------------------------------------------------------------

	// 미수금정산 리스트 조회
	public Vector getSettleList(String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String gubun2_query = "to_char(sysdate,'YYYYMMDD')";

		//임의일자
		if(gubun2.equals("6"))	gubun2_query = "to_char(to_date('"+AddUtil.ChangeString(st_dt)+"', 'YYYYMMDD'), 'YYYYMMDD')";

		String query = "";
		query = " select  \n"+
				" a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.firm_nm, a.client_nm, cr.car_no, a.bus_id2, a.mng_id,\n"+
				" a.rent_way, a.brch_id, d.car_name as car_nm, a.use_yn, a.rent_st,\n"+
				" b.fee_su, b.fee_amt, b.pre_su, b.pre_amt, b.fine_su, b.fine_amt, b.serv_su, b.serv_amt, b.accid_su, b.accid_amt, b.cls_su, b.cls_amt\n"+
				" from cont_n_view a, car_reg cr, \n"+ 
				" 	( select a.rent_l_cd,\n"+ 
				"		decode(b.rent_l_cd, '','N', 'Y') fee_st, nvl(fee_su,0) fee_su, nvl(fee_amt,0) fee_amt,\n"+
				"		decode(c.rent_l_cd, '','N', 'Y') pre_st, nvl(pre_su,0) pre_su, nvl(pre_amt,0) pre_amt,\n"+
				"		decode(d.rent_l_cd, '','N', 'Y') fine_st, nvl(d.fine_su,0) fine_su, nvl(d.fine_amt,0) fine_amt,\n"+
				"		decode(e.rent_l_cd, '','N', 'Y') serv_st, nvl(serv_su,0) serv_su, nvl(serv_amt,0) serv_amt,\n"+
				"		decode(f.rent_l_cd, '','N', 'Y') accid_st, nvl(accid_su,0) accid_su, nvl(accid_amt,0) accid_amt,\n"+
				"		decode(g.rent_l_cd, '','N', 'Y') cls_st, nvl(cls_su,0) cls_su, nvl(cls_amt,0) cls_amt\n"+
				"	  from cont a,\n"+ 
				"		( select rent_l_cd, count(0) fee_su, sum(fee_s_amt+fee_v_amt) fee_amt from scd_fee where fee_s_amt > 0 and r_fee_est_dt <= "+gubun2_query+" and rc_dt is null and nvl(bill_yn,'Y')='Y' group by rent_l_cd) b,\n"+
				"		( select a.rent_l_cd, count(0) pre_su, sum(a.ext_s_amt+a.ext_v_amt) pre_amt from scd_ext a, cont b, fee c where a.ext_st in ('0', '1', '2') and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and a.rent_st=c.rent_st and a.ext_s_amt <> 0 and c.rent_start_dt <= "+gubun2_query+" and a.ext_pay_dt is null group by a.rent_l_cd) c,\n"+
				"		( select rent_l_cd, count(0) fine_su, sum(paid_amt) fine_amt from fine where rent_s_cd is null and paid_amt > 0 and "+standard_dt+" <= "+gubun2_query+" and coll_dt is null and nvl(no_paid_yn,'N')<>'Y' and paid_st in ('3','4') and nvl(bill_yn,'Y')='Y' group by rent_l_cd) d,\n"+//proxy_dt is not null and rec_plan_dt fault_st='1' and 
				"		( select a.rent_l_cd, count(0) serv_su, sum(se.ext_s_amt+se.ext_v_amt) serv_amt from scd_ext se, service a, accident b where se.ext_st = '3' and se.rent_mng_id=a.rent_mng_id and se.rent_l_cd = a.rent_l_cd and se.ext_id = a.serv_id and a.car_mng_id=b.car_mng_id(+) and b.rent_s_cd is null and a.accid_id=b.accid_id(+) and (se.ext_s_amt + se.ext_v_amt) > 0 and se.ext_est_dt <= "+gubun2_query+" and se.ext_pay_dt is null and nvl(a.no_dft_yn,'N')<>'Y' and nvl(a.bill_yn,'Y')='Y' group by a.rent_l_cd) e,\n"+		
				"		( select c.rent_l_cd, count(0) accid_su, sum(a.req_amt) accid_amt from my_accid a, cont b, accident c where a.car_mng_id=c.car_mng_id and a.accid_id=c.accid_id and c.rent_mng_id=b.rent_mng_id and c.rent_l_cd=b.rent_l_cd and a.req_amt > 0 and a.req_dt <= "+gubun2_query+" and a.pay_dt is null group by c.rent_l_cd) f,\n"+
				"		( select a.rent_l_cd, count(0) cls_su, sum(a.ext_s_amt+a.ext_v_amt) cls_amt from scd_ext a, cls_cont b where a.ext_st = '4' and nvl(a.bill_yn,'Y')='Y' and (a.ext_s_amt + a.ext_v_amt) > 0 and a.ext_est_dt <= "+gubun2_query+" and a.ext_pay_dt is null and a.rent_l_cd=b.rent_l_cd and b.cls_doc_yn='Y' group by a.rent_l_cd) g\n"+	
				"	  where a.rent_l_cd=b.rent_l_cd(+) and a.rent_l_cd=c.rent_l_cd(+) and a.rent_l_cd=d.rent_l_cd(+) and a.rent_l_cd=e.rent_l_cd(+) and a.rent_l_cd=f.rent_l_cd(+) and a.rent_l_cd=g.rent_l_cd(+)\n"+
				"	) b, car_etc c, car_nm d\n"+
				" where a.car_mng_id = cr.car_mng_id(+) and a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd and a.rent_mng_id=c.rent_mng_id and c.car_id=d.car_id and c.car_seq=d.car_seq\n"+
				" and (b.fee_st='Y' or b.pre_st='Y' or b.fine_st='Y' or b.serv_st='Y' or b.accid_st='Y' or b.cls_st='Y')";

		/*세부조회*/
			
		if(gubun4.equals("1"))		query += " and b.fee_st='Y'";
		else if(gubun4.equals("2"))	query += " and b.pre_st='Y'";
		else if(gubun4.equals("3"))	query += " and b.fine_st='Y'";
		else if(gubun4.equals("4"))	query += " and b.serv_st='Y'";
		else if(gubun4.equals("5"))	query += " and b.accid_st='Y'";
		else if(gubun4.equals("6"))	query += " and b.cls_su='Y'";
		
		/*검색조건*/
			
		if(s_kd.equals("2"))		query += " and nvl(a.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(a.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and nvl(cr.car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	query += " and upper(a.brch_id) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("7"))	query += " and nvl(a.r_site, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("8"))	query += " and a.bus_id2= '"+t_wd+"'\n";
		else if(s_kd.equals("9"))	query += " and nvl(d.car_name, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("10"))	query += " and a.rent_way= '"+t_wd+"'\n";
		else if(s_kd.equals("11"))	query += " and a.mng_id= '"+t_wd+"'\n";		
		else						query += " and nvl(a.firm_nm, '') like '%"+t_wd+"%'\n";			

		query +=" order by a.use_yn desc, a.firm_nm";

	
		try {
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
			System.out.println("[SettleDatabase:getSettleList]\n"+e);
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

	// 미수금정산 리스트 통계 조회
	public Hashtable getSettleListStat(String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String gubun2_query = "to_char(sysdate,'YYYYMMDD')";

		//임의일자
		if(gubun2.equals("6"))	gubun2_query = "to_char(to_date('"+AddUtil.ChangeString(st_dt)+"', 'YYYYMMDD'), 'YYYYMMDD')";

		String sub_query = "";
		sub_query = " select  \n"+
				" a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.firm_nm,  a.client_nm, cr.car_no, a.bus_id2,\n"+
				" a.rent_way, a.brch_id, d.car_name as car_nm, a.use_yn, a.rent_st,\n"+
				" b.fee_su, b.fee_amt, b.pre_su, b.pre_amt, b.fine_su, b.fine_amt, b.serv_su, b.serv_amt, b.accid_su, b.accid_amt, b.cls_su, b.cls_amt\n"+
				" from cont_n_view a, car_reg cr , \n"+ 
				" 	( select a.rent_l_cd,\n"+ 
				"		decode(b.rent_l_cd, '','N', 'Y') fee_st, nvl(fee_su,0) fee_su, nvl(fee_amt,0) fee_amt,\n"+
				"		decode(c.rent_l_cd, '','N', 'Y') pre_st, nvl(pre_su,0) pre_su, nvl(pre_amt,0) pre_amt,\n"+
				"		decode(d.rent_l_cd, '','N', 'Y') fine_st, nvl(fine_su,0) fine_su, nvl(fine_amt,0) fine_amt,\n"+
				"		decode(e.rent_l_cd, '','N', 'Y') serv_st, nvl(serv_su,0) serv_su, nvl(serv_amt,0) serv_amt,\n"+
				"		decode(f.rent_l_cd, '','N', 'Y') accid_st, nvl(accid_su,0) accid_su, nvl(accid_amt,0) accid_amt,\n"+
				"		decode(g.rent_l_cd, '','N', 'Y') cls_st, nvl(cls_su,0) cls_su, nvl(cls_amt,0) cls_amt\n"+
				"	  from cont a,\n"+ 
				"		( select rent_l_cd, count(0) fee_su, sum(fee_s_amt+fee_v_amt) fee_amt from scd_fee where fee_s_amt > 0 and r_fee_est_dt <= "+gubun2_query+" and rc_dt is null and nvl(bill_yn,'Y')='Y' group by rent_l_cd) b,\n"+
				"		( select a.rent_l_cd, count(0) pre_su, sum(a.ext_s_amt+a.ext_v_amt) pre_amt from scd_ext a, cont b, fee c where a.ext_st in ('0', '1', '2') and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and a.rent_st=c.rent_st and a.ext_s_amt <> 0 and c.rent_start_dt <= "+gubun2_query+" and a.ext_pay_dt is null group by a.rent_l_cd) c,\n"+
				"		( select rent_l_cd, count(0) fine_su, sum(paid_amt) fine_amt from fine where paid_amt > 0 and "+standard_dt+" <= "+gubun2_query+" and coll_dt is null and nvl(no_paid_yn,'N')<>'Y' and paid_st in ('3','4') and nvl(bill_yn,'Y')='Y' group by rent_l_cd) d,\n"+//proxy_dt is not null and and fault_st='1' 
				"		( select rent_l_cd, count(0) serv_su, sum(cust_amt) serv_amt from service where nvl(bill_yn,'Y')='Y' and cust_amt > 0 and cust_plan_dt <= "+gubun2_query+" and cust_pay_dt is null and nvl(no_dft_yn,'N')<>'Y'  group by rent_l_cd) e,\n"+		
				"		( select c.rent_l_cd, count(0) accid_su, sum(a.req_amt) accid_amt from my_accid a, cont b, accident c where a.car_mng_id=c.car_mng_id and a.accid_id=c.accid_id and c.rent_mng_id=b.rent_mng_id and c.rent_l_cd=b.rent_l_cd and a.req_amt > 0 and a.req_dt <= "+gubun2_query+" and a.pay_dt is null group by c.rent_l_cd) f,\n"+
				"		( select a.rent_l_cd, count(0) cls_su, sum(a.ext_s_amt+a.ext_v_amt) cls_amt from scd_ext a, cls_cont b where a.ext_st = '4' and nvl(a.bill_yn,'Y')='Y' and a.ext_s_amt > 0 and a.ext_est_dt <= "+gubun2_query+" and a.ext_pay_dt is null and a.rent_l_cd=b.rent_l_cd and b.cls_doc_yn='Y' group by a.rent_l_cd) g\n"+	
				"	  where a.rent_l_cd=b.rent_l_cd(+) and a.rent_l_cd=c.rent_l_cd(+) and a.rent_l_cd=d.rent_l_cd(+)and a.rent_l_cd=e.rent_l_cd(+) and a.rent_l_cd=f.rent_l_cd(+) and a.rent_l_cd=g.rent_l_cd(+)\n"+
				"	) b, car_etc c, car_nm d\n"+
				" where a.car_mng_id = cr.car_mng_id(+) and a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd and a.rent_mng_id=c.rent_mng_id and c.car_id=d.car_id and c.car_seq=d.car_seq\n"+
				" and (b.fee_st='Y' or b.pre_st='Y' or b.fine_st='Y' or b.serv_st='Y' or b.accid_st='Y' or b.cls_st='Y')";

		/*세부조회*/
			
		if(gubun4.equals("1"))		sub_query += " and b.fee_st='Y'";
		else if(gubun4.equals("2"))	sub_query += " and b.pre_st='Y'";
		else if(gubun4.equals("3"))	sub_query += " and b.fine_st='Y'";
		else if(gubun4.equals("4"))	sub_query += " and b.serv_st='Y'";
		else if(gubun4.equals("5"))	sub_query += " and b.accid_st='Y'";
		else if(gubun4.equals("6"))	sub_query += " and b.cls_st='Y'";

		/*검색조건*/
			
		if(s_kd.equals("2"))		sub_query += " and nvl(a.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	sub_query += " and upper(a.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	sub_query += " and nvl(cr.car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	sub_query += " and upper(a.brch_id) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("7"))	sub_query += " and nvl(a.r_site, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("8"))	sub_query += " and a.bus_id2= '"+t_wd+"'\n";
		else if(s_kd.equals("9"))	sub_query += " and nvl(d.car_name, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("10"))	sub_query += " and a.rent_way= '"+t_wd+"'\n";
		else						sub_query += " and nvl(a.firm_nm, '') like '%"+t_wd+"%'\n";			

		String query = "";
		query = " select a.*, b.*, c.*, d.*, e.*, f.*, (fee_su+pre_su+fine_su+serv_su+accid_su+cls_su) tot_su, (fee_amt+pre_amt+fine_amt+serv_amt+accid_amt+cls_amt) tot_amt\n"+
				" from\n"+
					" ( select count(0) fee_su, nvl(sum(fee_amt),0) fee_amt from ("+sub_query+") where fee_amt > 0 ) a,\n"+
					" ( select count(0) pre_su, nvl(sum(pre_amt),0) pre_amt from ("+sub_query+") where pre_amt > 0 ) b,\n"+	
					" ( select count(0) fine_su, nvl(sum(fine_amt),0) fine_amt from ("+sub_query+") where fine_amt > 0 ) c,\n"+
					" ( select count(0) serv_su, nvl(sum(serv_amt),0) serv_amt from ("+sub_query+") where serv_amt > 0 ) d,\n"+
					" ( select count(0) accid_su, nvl(sum(accid_amt),0) accid_amt from ("+sub_query+") where accid_amt > 0 ) e,\n"+	
					" ( select count(0) cls_su, nvl(sum(cls_amt),0) cls_amt from ("+sub_query+") where cls_amt > 0 ) f\n";
	
		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
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
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[SettleDatabase:getSettleListStat]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}

	/**
	 *	미수금 세부내용 - 계약 리스트 : settle_c.jsp
	 */
	public Vector getContList(String client_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select   a.rent_mng_id, a.rent_l_cd, c.car_no, cn.car_name, c.car_nm, a.rent_start_dt, a.rent_end_dt,"+
				" a.rent_way, a.bus_id2, decode(a.use_yn,'Y','대여','해지') use_yn_nm,\n"+
				" nvl2(d.cls_dt, substr(d.cls_dt,1,4)||'-'||substr(d.cls_dt,5,2)||'-'||substr(d.cls_dt,7,2),'') cls_dt"+
				" from cont_n_view a, car_etc b, cls_cont d, car_reg c,  car_nm cn \n"+
				" where client_id='"+client_id+"' "+
				" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd "+
				" and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+)"+
				"	and a.car_mng_id = c.car_mng_id(+)  \n"+
                       		"	and b.car_id=cn.car_id(+)  and    b.car_seq=cn.car_seq(+)  \n"+
				" order by a.use_yn desc";																
		
		try {
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
			System.out.println("[SettleDatabase:getContList]\n"+e);
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

	/**
	 *	미수금 세부내용 - 미수금 정산 : settle_c.jsp
	 */
	public Vector getContAllStat(String m_id, String l_cd, String client_id, String mode, String gubun2, String st_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		//연체료 계산 기준일-현재
		String gubun2_query = "sysdate";
		//연체료 계산 기준일-임의일자
		if(gubun2.equals("6"))	gubun2_query = "to_date('"+AddUtil.ChangeString(st_dt)+"', 'YYYYMMDD')";

		String mode_query = "";
		if(mode.equals("client"))	mode_query = " and a.client_id='"+client_id+"'";
		else						mode_query = " and a.rent_l_cd='"+l_cd+"'";

		String pre_query = " select (b.ext_s_amt+b.ext_v_amt) amt,"+ 
				" (TRUNC(((b.ext_s_amt+b.ext_v_amt)*0.18*TRUNC(TO_DATE(b.ext_est_dt, 'YYYYMMDD')- NVL(TO_DATE(b.ext_pay_dt, 'YYYYMMDD'), "+gubun2_query+")))/365) * -1) as dly_amt"+
				" from cont a, scd_ext b, fee c"+
				" where b.ext_st in ('0', '1', '2') and a.rent_l_cd=b.rent_l_cd and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st"+
				" and c.rent_start_dt <= to_char("+gubun2_query+", 'YYYYMMDD') and b.ext_pay_dt is null "+mode_query;

		String fee_query = " select (b.fee_s_amt+b.fee_v_amt) amt,"+ 
				" (TRUNC(((b.fee_s_amt+b.fee_v_amt)*0.18*TRUNC(TO_DATE(b.fee_est_dt, 'YYYYMMDD')- NVL(TO_DATE(b.rc_dt, 'YYYYMMDD'), "+gubun2_query+")))/365) * -1) as dly_amt"+
				" from cont a, scd_fee b"+
				" where a.rent_l_cd=b.rent_l_cd"+
				" and b.fee_est_dt <= to_char("+gubun2_query+", 'YYYYMMDD') and b.rc_dt is null and nvl(b.bill_yn,'Y')='Y' "+mode_query;

		String fine_query = " select b.paid_amt as amt,"+ 
				" (TRUNC(((b.paid_amt)*0.18*TRUNC(TO_DATE(b.rec_plan_dt, 'YYYYMMDD')- NVL(TO_DATE(b.coll_dt, 'YYYYMMDD'), "+gubun2_query+")))/365) * -1) as dly_amt"+
				" from cont a, fine b"+
				" where a.rent_l_cd=b.rent_l_cd and b.fault_st='1' and b.paid_st in ('3','4')"+//b.proxy_dt is not null and 
				" and b.rec_plan_dt <= to_char("+gubun2_query+", 'YYYYMMDD') and b.coll_dt is null "+mode_query;

		String serv_query = " select b.cust_amt as amt,"+ 
				" (TRUNC(((b.cust_amt)*0.18*TRUNC(TO_DATE(b.cust_plan_dt, 'YYYYMMDD')- NVL(TO_DATE(b.cust_pay_dt, 'YYYYMMDD'), "+gubun2_query+")))/365) * -1) as dly_amt"+
				" from cont a, service b, serv_off c"+
				" where a.rent_l_cd=b.rent_l_cd and b.off_id=c.off_id"+
				" and b.cust_plan_dt <= to_char("+gubun2_query+", 'YYYYMMDD') and b.cust_pay_dt is null "+mode_query;

		String accid_query = " select b.req_amt as amt,"+ 
				" (TRUNC(((b.req_amt)*0.18*TRUNC(TO_DATE(b.req_dt, 'YYYYMMDD')- NVL(TO_DATE(b.pay_dt, 'YYYYMMDD'), "+gubun2_query+")))/365) * -1) as dly_amt"+
				" from cont a, my_accid b, accident c"+
				" where a.rent_l_cd=c.rent_l_cd and c.car_mng_id=b.car_mng_id"+
				" and b.req_dt <= to_char("+gubun2_query+", 'YYYYMMDD') and b.pay_dt is null "+mode_query;

		String cls_query = " select (b.ext_s_amt+b.ext_v_amt) amt,"+ 
				" (TRUNC(((b.ext_s_amt+b.ext_v_amt)*0.18*TRUNC(TO_DATE(b.ext_est_dt, 'YYYYMMDD')- NVL(TO_DATE(b.ext_pay_dt, 'YYYYMMDD'), "+gubun2_query+")))/365) * -1) as dly_amt"+
				" from cont a, scd_ext b, cls_cont c"+
				" where b.ext_st = '4' and nvl(b.bill_yn,'Y')='Y' and a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd and b.ext_s_amt c.cls_doc_yn='Y'"+//and c.cls_dt > '20030531'
				" and b.ext_est_dt <= to_char("+gubun2_query+", 'YYYYMMDD') and b.ext_pay_dt is null "+mode_query;

		String query =  " select '선수금' gubun, count(0) su, sum(amt) amt, sum(dly_amt) dly_amt from ("+pre_query+") where amt > 0"+
						" union all"+
						" select '대여료' gubun, count(0) su, sum(amt) amt, sum(dly_amt) dly_amt from ("+fee_query+") where amt > 0"+
						" union all"+
						" select '과태료' gubun, count(0) su, sum(amt) amt, sum(dly_amt) dly_amt from ("+fine_query+") where amt > 0"+
						" union all"+
						" select '면책금' gubun, count(0) su, sum(amt) amt, sum(dly_amt) dly_amt from ("+serv_query+") where amt > 0"+
						" union all"+
						" select '휴차료' gubun, count(0) su, sum(amt) amt, sum(dly_amt) dly_amt from ("+accid_query+") where amt > 0"+
						" union all"+
						" select '중도해지위약금' gubun, count(0) su, sum(amt) amt, sum(dly_amt) dly_amt from ("+cls_query+") where amt > 0";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			while(rs.next())
			{
				SettleStatBean stat = new SettleStatBean();
				stat.setGubun(rs.getString(1));
				stat.setSu(rs.getInt(2));
				stat.setAmt(rs.getInt(3));
				stat.setDly_amt(rs.getInt(4));
				vt.add(stat);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[SettleDatabase:getContAllStat]"+e);
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
	 *	미수금 세부내용 - 미수금 정산 : settle_c.jsp
	 */
	public Vector getContAllStat_N1(String m_id, String l_cd, String client_id, String mode, String gubun2, String st_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		//연체료 계산 기준일-현재
		String gubun2_query = "sysdate";
		//연체료 계산 기준일-임의일자
		if(gubun2.equals("6"))	gubun2_query = "to_date('"+AddUtil.ChangeString(st_dt)+"', 'YYYYMMDD')";

		String mode_query = "";
		if(mode.equals("client"))	mode_query = " and a.client_id='"+client_id+"'";
		else						mode_query = " and a.rent_l_cd='"+l_cd+"'";

		String pre_query = " select (b.ext_s_amt+b.ext_v_amt) amt"+ 
				" from cont a, scd_ext b, fee c"+
				" where b.ext_st  in ('0', '1', '2') and a.rent_l_cd=b.rent_l_cd and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st"+
				" and c.rent_start_dt >= to_char("+gubun2_query+", 'YYYYMMDD') and b.ext_pay_dt is null "+mode_query;

		String fee_query = " select (b.fee_s_amt+b.fee_v_amt) amt"+ 
				" from cont a, scd_fee b"+
				" where a.rent_l_cd=b.rent_l_cd  "+
				" and b.fee_est_dt >= to_char("+gubun2_query+", 'YYYYMMDD') and b.rc_dt is null and nvl(b.bill_yn,'Y')='Y' "+mode_query;

		String fine_query = " select b.paid_amt as amt"+ 
				" from cont a, fine b"+
				" where a.rent_l_cd=b.rent_l_cd and b.paid_amt>0 and nvl(b.no_paid_yn,'N')<>'Y' and b.paid_st in ('3','4')"+
				" and "+standard_dt_b+" >= to_char("+gubun2_query+", 'YYYYMMDD') and b.coll_dt is null "+mode_query;

		String serv_query = " select b.cust_amt as amt"+ 
				" from cont a, service b, serv_off c"+
				" where a.rent_l_cd=b.rent_l_cd and b.off_id=c.off_id and a.rent_l_cd not like 'RM%' "+
				" and b.cust_plan_dt >= to_char("+gubun2_query+", 'YYYYMMDD') and b.cust_pay_dt is null "+mode_query;

		String accid_query = " select b.req_amt as amt"+ 
				" from cont a, my_accid b, accident c"+
				" where a.rent_l_cd=c.rent_l_cd and c.car_mng_id=b.car_mng_id"+
				" and b.req_dt >= to_char("+gubun2_query+", 'YYYYMMDD') and b.pay_dt is null "+mode_query;

		String cls_query = " select (b.ext_s_amt+b.ext_v_amt) amt"+ 
				" from cont a, scd_ext b, cls_cont c"+
				" where b.ext_st = '4' and nvl(b.bill_yn,'Y')='Y' and a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd and c.cls_doc_yn='Y'"+//c.cls_dt > '20030531'
				" and b.ext_est_dt >= to_char("+gubun2_query+", 'YYYYMMDD') and b.ext_pay_dt is null "+mode_query;

		String query =  " select '선수금' gubun, count(0) su, sum(amt) amt from ("+pre_query+") where amt > 0"+
						" union all"+
						" select '대여료' gubun, count(0) su, sum(amt) amt from ("+fee_query+") where amt > 0"+
						" union all"+
						" select '과태료' gubun, count(0) su, sum(amt) amt from ("+fine_query+") where amt > 0"+
						" union all"+
						" select '면책금' gubun, count(0) su, sum(amt) amt from ("+serv_query+") where amt > 0"+
						" union all"+
						" select '휴차료' gubun, count(0) su, sum(amt) amt from ("+accid_query+") where amt > 0"+
						" union all"+
						" select '중도해지위약금' gubun, count(0) su, sum(amt) amt from ("+cls_query+") where amt > 0";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			while(rs.next())
			{
				SettleStatBean stat = new SettleStatBean();
				stat.setGubun(rs.getString(1));
				stat.setSu(rs.getInt(2));
				stat.setAmt(rs.getInt(3));
//				stat.setDly_amt(rs.getInt(4));
				vt.add(stat);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[SettleDatabase:getContAllStat_N]"+e);
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
	 *	미수금 세부내용 - 미수금 정산 : settle_c.jsp
	 */
	public Vector getContAllStat_N(String m_id, String l_cd, String client_id, String mode, String gubun2, String st_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		//연체료 계산 기준일-현재
		String gubun2_query = "sysdate";
		//연체료 계산 기준일-임의일자
		if(gubun2.equals("6"))	gubun2_query = "to_date('"+AddUtil.ChangeString(st_dt)+"', 'YYYYMMDD')";

		String mode_query = "";
		if(mode.equals("client"))	mode_query = " and a.client_id='"+client_id+"'";
		else						mode_query = " and a.rent_l_cd='"+l_cd+"'";

		String pre_query = " select (b.ext_s_amt+b.ext_v_amt) amt"+ 
				" from cont a, scd_ext b, fee c"+
				" where b.ext_st in ('0', '1', '2') and a.rent_l_cd=b.rent_l_cd and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st"+
//				" and b.pp_est_dt < to_char("+gubun2_query+", 'YYYYMMDD') and b.pp_pay_dt is null "+mode_query;
				" and c.rent_start_dt < to_char("+gubun2_query+", 'YYYYMMDD') and b.ext_pay_dt is null "+mode_query;

		String fee_query = " select (b.fee_s_amt+b.fee_v_amt) amt"+ 
				" from cont a, scd_fee b"+
				" where a.rent_l_cd=b.rent_l_cd"+
				" and b.fee_est_dt < to_char("+gubun2_query+", 'YYYYMMDD') and b.rc_dt is null and nvl(b.bill_yn,'Y')='Y' "+mode_query;

		String fine_query = " select b.paid_amt as amt"+ 
				" from cont a, fine b"+
				" where a.rent_l_cd=b.rent_l_cd and b.paid_amt > 0 and nvl(b.no_paid_yn,'N') <> 'Y' and b.paid_st in ('3','4')"+//b.paid_st='3' b.proxy_dt is not null and b.fault_st='1' and 
				" and "+standard_dt_b+" < to_char("+gubun2_query+", 'YYYYMMDD') and b.coll_dt is null "+mode_query;

		String serv_query = " select b.cust_amt as amt"+ 
				" from cont a, service b, serv_off c"+
				" where a.rent_l_cd=b.rent_l_cd and b.off_id=c.off_id"+
				" and b.cust_plan_dt < to_char("+gubun2_query+", 'YYYYMMDD') and b.cust_pay_dt is null "+mode_query;

		String accid_query = " select b.req_amt as amt"+ 
				" from cont a, my_accid b, accident c"+
				" where a.rent_l_cd=c.rent_l_cd and c.car_mng_id=b.car_mng_id and b.accid_id=c.accid_id"+
				" and b.req_dt < to_char("+gubun2_query+", 'YYYYMMDD') and b.pay_dt is null "+mode_query;

		String cls_query = " select (b.ext_s_amt+b.ext_v_amt) amt"+ 
				" from cont a, scd_ext b, cls_cont c"+
				" where b.ext_st = '4' and nvl(b.bill_yn,'Y')='Y' and a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd and c.cls_doc_yn='Y'"+//c.cls_dt > '20030531'
				" and b.ext_est_dt < to_char("+gubun2_query+", 'YYYYMMDD') and b.ext_pay_dt is null "+mode_query;

		String query =  " select '선수금' gubun, count(0) su, sum(amt) amt from ("+pre_query+") where amt > 0"+
						" union all"+
						" select '대여료' gubun, count(0) su, sum(amt) amt from ("+fee_query+") where amt > 0"+
						" union all"+
						" select '과태료' gubun, count(0) su, sum(amt) amt from ("+fine_query+") where amt > 0"+
						" union all"+
						" select '면책금' gubun, count(0) su, sum(amt) amt from ("+serv_query+") where amt > 0"+
						" union all"+
						" select '휴차료' gubun, count(0) su, sum(amt) amt from ("+accid_query+") where amt > 0"+
						" union all"+
						" select '중도해지위약금' gubun, count(0) su, sum(amt) amt from ("+cls_query+") where amt > 0";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			while(rs.next())
			{
				SettleStatBean stat = new SettleStatBean();
				stat.setGubun(rs.getString(1));
				stat.setSu(rs.getInt(2));
				stat.setAmt(rs.getInt(3));
//				stat.setDly_amt(rs.getInt(4));
				vt.add(stat);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[SettleDatabase:getContAllStat_N]"+e);
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
	 *	미수금 세부내용 - 연체료(계산) 정산 : settle_c.jsp
	 */
	public Vector getContAllStat_D(String m_id, String l_cd, String client_id, String mode, String gubun2, String st_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		//연체료 계산 기준일-현재
		String gubun2_query = "sysdate";
		//연체료 계산 기준일-임의일자
		if(gubun2.equals("6"))	gubun2_query = "to_date('"+AddUtil.ChangeString(st_dt)+"', 'YYYYMMDD')";

		String mode_query = "";
		if(mode.equals("client"))	mode_query = " and a.client_id='"+client_id+"'";
		else						mode_query = " and a.rent_l_cd='"+l_cd+"'";

		String pre_query = " select (TRUNC(((b.ext_s_amt+b.ext_v_amt)*0.18*TRUNC(TO_DATE(b.ext_est_dt, 'YYYYMMDD')- NVL(TO_DATE(b.ext_pay_dt, 'YYYYMMDD'), "+gubun2_query+")))/365) * -1) as dly_amt"+
				" from cont a, scd_ext b, fee c"+
				" where b.ext_st in ( '0', '1', '2' ) and a.rent_l_cd=b.rent_l_cd and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st"+
				" and c.rent_start_dt <= to_char("+gubun2_query+", 'YYYYMMDD') "+mode_query;

		String fee_query = " select (TRUNC(((b.fee_s_amt+b.fee_v_amt)*0.18*TRUNC(TO_DATE(b.fee_est_dt, 'YYYYMMDD')- NVL(TO_DATE(b.rc_dt, 'YYYYMMDD'), "+gubun2_query+")))/365) * -1) as dly_amt"+
				" from cont a, scd_fee b"+
				" where a.rent_l_cd=b.rent_l_cd and nvl(b.bill_yn,'Y')='Y'"+
				" and b.fee_est_dt <= to_char("+gubun2_query+", 'YYYYMMDD') "+mode_query;

		String fine_query = " select (TRUNC(((b.paid_amt)*0.18*TRUNC(TO_DATE(b.rec_plan_dt, 'YYYYMMDD')- NVL(TO_DATE(b.coll_dt, 'YYYYMMDD'), "+gubun2_query+")))/365) * -1) as dly_amt"+
				" from cont a, fine b"+
				" where a.rent_l_cd=b.rent_l_cd and b.fault_st='1' and b.paid_st in ('3','4')"+//b.proxy_dt is not null and 
				" and b.rec_plan_dt <= to_char("+gubun2_query+", 'YYYYMMDD') "+mode_query;

		String serv_query = " select (TRUNC(((b.cust_amt)*0.18*TRUNC(TO_DATE(b.cust_plan_dt, 'YYYYMMDD')- NVL(TO_DATE(b.cust_pay_dt, 'YYYYMMDD'), "+gubun2_query+")))/365) * -1) as dly_amt"+
				" from cont a, service b, serv_off c"+
				" where a.rent_l_cd=b.rent_l_cd and b.off_id=c.off_id"+
				" and b.cust_plan_dt <= to_char("+gubun2_query+", 'YYYYMMDD') "+mode_query;

		String accid_query = " select (TRUNC(((b.req_amt)*0.18*TRUNC(TO_DATE(b.req_dt, 'YYYYMMDD')- NVL(TO_DATE(b.pay_dt, 'YYYYMMDD'), "+gubun2_query+")))/365) * -1) as dly_amt"+
				" from cont a, my_accid b, accident c"+
				" where a.rent_l_cd=c.rent_l_cd and c.car_mng_id=b.car_mng_id and b.accid_id=c.accid_id"+
				" and b.req_dt <= to_char("+gubun2_query+", 'YYYYMMDD') "+mode_query;

		String cls_query = " select (TRUNC(((b.ext_s_amt+b.ext_v_amt)*0.18*TRUNC(TO_DATE(b.ext_est_dt, 'YYYYMMDD')- NVL(TO_DATE(b.pay_dt, 'YYYYMMDD'), "+gubun2_query+")))/365) * -1) as dly_amt"+
				" from cont a, scd_ext b, cls_cont c"+
				" where b.ext_st = '4' and nvl(b.bill_yn,'Y')='Y' and a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd and c.cls_doc_yn='Y'"+//c.cls_dt > '20030531'
				" and b.ext_est_dt <= to_char("+gubun2_query+", 'YYYYMMDD') "+mode_query;

		String query =  " select '선수금' gubun, count(0) su, nvl(sum(dly_amt),0) dly_amt from ("+pre_query+") "+//where dly_amt > 0
						" union all"+
						" select '대여료' gubun, count(0) su, nvl(sum(dly_amt),0) dly_amt from ("+fee_query+") where dly_amt > 0"+
						" union all"+
						" select '과태료' gubun, count(0) su, nvl(sum(dly_amt),0) dly_amt from ("+fine_query+") where dly_amt > 0"+
						" union all"+
						" select '면책금' gubun, count(0) su, nvl(sum(dly_amt),0) dly_amt from ("+serv_query+") where dly_amt > 0"+
						" union all"+
						" select '휴차료' gubun, count(0) su, nvl(sum(dly_amt),0) dly_amt from ("+accid_query+") where dly_amt > 0"+
						" union all"+
						" select '중도해지위약금' gubun, count(0) su, nvl(sum(dly_amt),0) dly_amt from ("+cls_query+") where dly_amt > 0";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			while(rs.next())
			{
				SettleStatBean stat = new SettleStatBean();
				stat.setGubun(rs.getString(1));
				stat.setSu(rs.getInt(2));
//				stat.setAmt(rs.getInt(3));
				stat.setDly_amt(rs.getInt(3));
				vt.add(stat);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[SettleDatabase:getContAllStat_D]"+e);
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
	 *	미수금 세부내용 - 연체료 정산 : settle_c.jsp
	 */
	public Vector getContAllStat_D2(String m_id, String l_cd, String client_id, String mode, String gubun2, String st_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		//연체료 계산 기준일-현재
		String gubun2_query = "sysdate";
		//연체료 계산 기준일-임의일자
		if(gubun2.equals("6"))	gubun2_query = "to_date('"+AddUtil.ChangeString(st_dt)+"', 'YYYYMMDD')";

		String mode_query = "";
		if(mode.equals("client"))	mode_query = " and a.client_id='"+client_id+"'";
		else						mode_query = " and a.rent_l_cd='"+l_cd+"'";

		String pre_query = " select b.dly_amt"+
				" from cont a, scd_ext b"+
				" where a.ext_st in ( '0', '1', '2' ) and a.rent_l_cd=b.rent_l_cd"+
//				" and b.pp_est_dt <= to_char("+gubun2_query+", 'YYYYMMDD') "+mode_query;
				" and a.rent_start_dt <= to_char("+gubun2_query+", 'YYYYMMDD') "+mode_query;

		String fee_query = " select b.dly_fee as dly_amt"+
				" from cont a, scd_fee b"+
				" where a.rent_l_cd=b.rent_l_cd and nvl(b.bill_yn,'Y')='Y'"+
//				" and b.fee_est_dt <= to_char("+gubun2_query+", 'YYYYMMDD') "+mode_query;
				" "+mode_query;

		String dly_query = " select b.pay_amt as dly_pay_amt"+
				" from cont a, scd_dly b"+
				" where a.rent_l_cd=b.rent_l_cd"+
				" and b.pay_dt <= to_char("+gubun2_query+", 'YYYYMMDD') "+mode_query;

		String fine_query = " select b.dly_amt"+
				" from cont a, fine b"+
				" where a.rent_l_cd=b.rent_l_cd and b.paid_amt > 0 and nvl(b.no_paid_yn,'N') <> 'Y' and b.paid_st in ('3','4')"+//b.proxy_dt is not null and and b.fault_st='1' 
				" and "+standard_dt_b+" <= to_char("+gubun2_query+", 'YYYYMMDD') "+mode_query;

		String serv_query = " select b.dly_amt"+
				" from cont a, service b, serv_off c"+
				" where a.rent_l_cd=b.rent_l_cd and b.off_id=c.off_id"+
				" and b.cust_plan_dt <= to_char("+gubun2_query+", 'YYYYMMDD') "+mode_query;

		String accid_query = " select b.dly_amt"+
				" from cont a, my_accid b, accident c"+
				" where a.rent_l_cd=c.rent_l_cd and c.car_mng_id=b.car_mng_id and b.accid_id=c.accid_id"+
				" and b.req_dt <= to_char("+gubun2_query+", 'YYYYMMDD') "+mode_query;

		String cls_query = " select b.dly_amt"+
				" from cont a, scd_ext b, cls_cont c"+
				" where b.ext_st = '4' and nvl(b.bill_yn,'Y')='Y' and a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd and c.cls_doc_yn='Y'"+//c.cls_dt > '20030531'
				" and b.ext_est_dt <= to_char("+gubun2_query+", 'YYYYMMDD') "+mode_query;

		String query =  " select '선수금' gubun, count(0) su, nvl(sum(dly_amt),0) dly_amt from ("+pre_query+") where dly_amt > 0"+
						" union all"+
						" select '대여료' gubun, count(0) su, nvl(sum(dly_amt),0) dly_amt from ("+fee_query+") where dly_amt > 0"+
//						" select '대여료' gubun, count(0) su, nvl(sum(a.dly_amt),0)-nvl(sum(b.dly_pay_amt),0) as dly_amt from ("+fee_query+") a, ("+dly_query+") b where a.rent_l_cd=b.rent_l_cd"+
						" union all"+
						" select '과태료' gubun, count(0) su, nvl(sum(dly_amt),0) dly_amt from ("+fine_query+") where dly_amt > 0"+
						" union all"+
						" select '면책금' gubun, count(0) su, nvl(sum(dly_amt),0) dly_amt from ("+serv_query+") where dly_amt > 0"+
						" union all"+
						" select '휴차료' gubun, count(0) su, nvl(sum(dly_amt),0) dly_amt from ("+accid_query+") where dly_amt > 0"+
						" union all"+
						" select '중도해지위약금' gubun, count(0) su, nvl(sum(dly_amt),0) dly_amt from ("+cls_query+") where dly_amt > 0";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			while(rs.next())
			{
				SettleStatBean stat = new SettleStatBean();
				stat.setGubun(rs.getString(1));
				stat.setSu(rs.getInt(2));
//				stat.setAmt(rs.getInt(3));
				stat.setDly_amt(rs.getInt(3));
				vt.add(stat);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[SettleDatabase:getContAllStat_D]"+e);
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
	 *	미수금 세부내용 - 대손처리 정산 : settle_c.jsp
	 */
	public Vector getContAllStat_C(String m_id, String l_cd, String client_id, String mode, String gubun2, String st_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		//연체료 계산 기준일-현재
		String gubun2_query = "sysdate";
		//연체료 계산 기준일-임의일자
		if(gubun2.equals("6"))	gubun2_query = "to_date('"+AddUtil.ChangeString(st_dt)+"', 'YYYYMMDD')";

		String mode_query = "";
		if(mode.equals("client"))	mode_query = " and a.client_id='"+client_id+"'";
		else						mode_query = " and a.rent_l_cd='"+l_cd+"'";

		String pre_query = " select (b.ext_s_amt+b.ext_v_amt) amt"+ 
				" from cont a, scd_ext b, fee c"+
				" where a.ext_st in ('0', '1', '2' ) and a.rent_l_cd=b.rent_l_cd and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st and nvl(b.bill_yn,'Y')='N'"+
				" "+mode_query;

		String fee_query = " select (b.fee_s_amt+b.fee_v_amt) amt"+ 
				" from cont a, scd_fee b"+
				" where a.rent_l_cd=b.rent_l_cd and nvl(b.bill_yn,'Y')='N'"+
				" "+mode_query;

		String fine_query = " select b.paid_amt as amt"+ 
				" from cont a, fine b"+
				" where a.rent_l_cd=b.rent_l_cd and nvl(b.bill_yn,'Y')='N'"+
				" "+mode_query;

		String serv_query = " select b.cust_amt as amt"+ 
				" from cont a, service b, serv_off c"+
				" where a.rent_l_cd=b.rent_l_cd and b.off_id=c.off_id and nvl(b.bill_yn,'Y')='N'"+
				" "+mode_query;

		String accid_query = " select b.req_amt as amt"+ 
				" from cont a, my_accid b, accident c"+
				" where a.rent_l_cd=c.rent_l_cd and c.car_mng_id=b.car_mng_id and b.accid_id=c.accid_id and nvl(b.bill_yn,'Y')='N'"+
				" "+mode_query;

		String cls_query = " select (b.ext_s_amt+b.ext_v_amt) amt"+ 
				" from cont a, scd_ext b, cls_cont c"+
				" where b.ext_st = '4' and a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd and nvl(b.bill_yn,'Y')='N'"+
				" "+mode_query;

		String query =  " select '선수금' gubun, count(0) su, sum(amt) amt from ("+pre_query+") where amt > 0"+
						" union all"+
						" select '대여료' gubun, count(0) su, sum(amt) amt from ("+fee_query+") where amt > 0"+
						" union all"+
						" select '과태료' gubun, count(0) su, sum(amt) amt from ("+fine_query+") where amt > 0"+
						" union all"+
						" select '면책금' gubun, count(0) su, sum(amt) amt from ("+serv_query+") where amt > 0"+
						" union all"+
						" select '휴차료' gubun, count(0) su, sum(amt) amt from ("+accid_query+") where amt > 0"+
						" union all"+
						" select '중도해지위약금' gubun, count(0) su, sum(amt) amt from ("+cls_query+") where amt > 0";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			while(rs.next())
			{
				SettleStatBean stat = new SettleStatBean();
				stat.setGubun(rs.getString(1));
				stat.setSu(rs.getInt(2));
				stat.setAmt(rs.getInt(3));
//				stat.setDly_amt(rs.getInt(4));
				vt.add(stat);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[SettleDatabase:getContAllStat_C]"+e);
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
	 *	미수금 세부내용 - 대손처리 정산 : settle_c.jsp
	 */
	public int getDlyAmtPay(String m_id, String l_cd, String client_id, String mode)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int dly_pay_amt = 0;


		String mode_query = "";
		if(mode.equals("client"))	mode_query = " and a.client_id='"+client_id+"'";
		else						mode_query = " and a.rent_l_cd='"+l_cd+"'";

		String fee_query = " select sum(b.pay_amt) amt"+ 
				" from cont a, scd_dly b"+
				" where a.rent_l_cd=b.rent_l_cd"+
				" "+mode_query;

		try {
			pstmt = conn.prepareStatement(fee_query);
	    	rs = pstmt.executeQuery();

			if(rs.next())
			{
				dly_pay_amt = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[SettleDatabase:getDlyAmtPay]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return dly_pay_amt;
		}
	}	


	/**
	 *	선수금 미수 스케줄
	 */
	public Vector getPreList(String m_id, String l_cd, String client_id, String mode, String gubun2, String st_dt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		//연체료 계산 기준일-현재
		String gubun2_query = "sysdate";

		//연체료 계산 기준일-임의일자
		if(gubun2.equals("6"))	gubun2_query = "to_date('"+AddUtil.ChangeString(st_dt)+"', 'YYYYMMDD')";

		String query = "";

		query = " select b.rent_mng_id, b.rent_l_cd, b.ext_tm as tm, decode(b.ext_st, '0','보증금','1','선납금','2','개시대여료','5','승계수수료') st, \n"+
				"        decode(b.ext_st,'5',d.rent_suc_dt,c.rent_start_dt) as est_dt, b.ext_s_amt as s_amt, b.ext_v_amt as v_amt, (b.ext_s_amt+b.ext_v_amt) amt, b.dly_days, b.dly_amt,  \n"+ 
				"        b.rent_st, b.ext_st, b.ext_tm, b.ext_id  \n"+
				" from   scd_ext b, cont a, fee c, cont_etc d \n"+
				" where  b.ext_st in ( '0', '1', '2', '5' ) and b.ext_s_amt > 0  \n"+
				"        and b.ext_pay_dt is null \n"+
				"        and b.rent_mng_id =a.rent_mng_id and b.rent_l_cd = a.rent_l_cd  \n"+
				"        and b.rent_mng_id = c.rent_mng_id  and  b.rent_l_cd = c.rent_l_cd and b.rent_st=c.rent_st   \n"+
		        "          and decode(b.ext_st,'5',nvl(d.rent_suc_dt,b.ext_est_dt), \n"+//승계수수료
                "                     decode(a.rent_st||c.rent_st||c.grt_suc_yn||b.ext_st,'3100', \n"+//--대차승계보증금
                "                            decode(b.gubun,'E',b.ext_est_dt, \n"+
                "                                   to_char(to_date(nvl(c.rent_start_dt,to_char(sysdate,'YYYYMMDD')),'YYYYMMDD')+15,'YYYYMMDD') \n"+
                "                            ), \n"+
                "                            nvl(d.rent_suc_dt,c.rent_start_dt) \n"+
                "                     ) \n"+
                "              ) <= to_char("+gubun2_query+", 'YYYYMMDD') \n"+
				"        and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+) \n"+
				" ";

		if(mode.equals("client"))	query += " and a.client_id='"+client_id+"'";
		else						query += " and a.rent_l_cd='"+l_cd+"'";

		try {
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
			System.out.println("[SettleDatabase:getPreList]\n"+e);
			System.out.println("[SettleDatabase:getPreList]\n"+query);
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

	/**
	 *	대여료 미수 스케줄
	 */
	public Vector getFeeList(String m_id, String l_cd, String client_id, String mode, String gubun2, String st_dt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		//연체료 계산 기준일-현재
		String gubun2_query = "sysdate";
		//연체료 계산 기준일-임의일자
		if(gubun2.equals("6"))	gubun2_query = "to_date('"+AddUtil.ChangeString(st_dt)+"', 'YYYYMMDD')";

		String query = "";
		query = " select b.rent_mng_id, b.rent_l_cd, b.rent_st, b.rent_seq, b.fee_tm as tm, b.tm_st1, '대여료' st,"+
				" b.fee_est_dt as est_dt, b.fee_s_amt as s_amt, b.fee_v_amt as v_amt, (b.fee_s_amt+b.fee_v_amt) amt, b.dly_days, b.dly_fee as dly_amt"+ 
				" from cont a, scd_fee b"+
				" where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.fee_s_amt > 0 "+
				" and b.fee_est_dt <= to_char("+gubun2_query+", 'YYYYMMDD') and b.rc_dt is null and nvl(b.bill_yn,'Y')='Y'";

		if(mode.equals("client"))	query += " and a.client_id='"+client_id+"'";
		else						query += " and a.rent_l_cd='"+l_cd+"'";

		query += " order by a.rent_l_cd, b.fee_est_dt";

		try {
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
			System.out.println("[SettleDatabase:getFeeList]\n"+e);
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

	/**
	 *	대여료 연체이자 미수 스케줄
	 */
	public Vector getFeeDlyList(String m_id, String l_cd, String client_id, String mode, String gubun2, String st_dt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select c.rent_mng_id, c.rent_l_cd, '연체이자' st, \n"+
				"        a.rent_mng_id, a.rent_l_cd, c.car_mng_id, c.client_id, DECODE(c.car_st,'4',c.mng_id,c.bus_id2) bus_id2, \n"+
				"        nvl(a.dly_fee,0)-nvl(b.pay_amt,0) dly_amt \n"+
				" from   (select rent_mng_id, rent_l_cd, sum(dly_fee) dly_fee from scd_fee where rent_l_cd not like 'RM%' group by rent_mng_id, rent_l_cd) a, "+
				"        (select rent_mng_id, rent_l_cd, sum(pay_amt) pay_amt from scd_dly where rent_l_cd not like 'RM%' group by rent_mng_id, rent_l_cd) b, cont c, \n"+
                "        (SELECT * FROM CLS_CONT WHERE cls_dt>'20091231' AND cls_st IN ('4','5')) d \n"+
  				" where  a.rent_mng_id=b.rent_mng_id(+) and a.rent_l_cd=b.rent_l_cd(+) and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"+
				"        and nvl(a.dly_fee,0)-nvl(b.pay_amt,0)<>0 and c.rent_l_cd not like 'RM%' \n"+
                "        AND c.rent_mng_id=d.rent_mng_id(+) AND c.rent_l_cd=d.rent_l_cd(+) and DECODE(d.cls_st,'4','Y','5','Y',c.use_yn)='Y' \n"+
				" ";

		if(mode.equals("client"))	query += " and c.client_id='"+client_id+"'";
		else						query += " and c.rent_l_cd='"+l_cd+"'";

		query += " order by c.rent_l_cd ";


		try {
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
			System.out.println("[SettleDatabase:getFeeDlyList]\n"+e);
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

	/**
	 *	과태료 미수 스케줄
	 */
	public Vector getFineList(String m_id, String l_cd, String client_id, String mode, String gubun2, String st_dt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		//연체료 계산 기준일-현재
		String gubun2_query = "sysdate";

		//연체료 계산 기준일-임의일자
		if(gubun2.equals("6"))	gubun2_query = "to_date('"+AddUtil.ChangeString(st_dt)+"', 'YYYYMMDD')";

		String query = "";

		query = " select b.seq_no, b.rent_mng_id, b.rent_l_cd, b.car_mng_id, \n"+
				"	     decode(b.fault_st, '1','고객과실','2','업무상과실('||nvl(f.user_nm,b.fault_nm)||')','3','협력업체과실')||decode(c.rent_st,'1',' 단기대여','9',' 보험대차','2',' 정비대차','3',' 사고대차','10',' 지연대차','4',' 업무대여','5',' 업무대여','12','월렌트') st,  \n"+
				"        substr(b.vio_dt,1,8) vio_dt, b.vio_pla, \n"+
				"        "+standard_dt_b+" as est_dt,  \n"+
				"        b.paid_amt as amt, b.dly_days, b.dly_amt, \n"+ 
				"        b.proxy_dt, b.dem_dt, e.gov_nm, nvl(f.user_nm,b.fault_nm) fault_nm \n"+
				" from   fine b, cont a, rent_cont c, cont d, fine_gov e, users f \n"+
				" where  \n"+
				"        b.paid_amt>0 and b.coll_dt is null \n"+
				"        and nvl(b.bill_yn,'Y')='Y' \n"+
				"        and b.paid_st in ('3','4') \n"+
				"        and nvl(b.no_paid_yn,'N')='N' \n"+
				"        and "+standard_dt_b+" <= to_char("+gubun2_query+", 'YYYYMMDD') \n"+
				"        and b.rent_mng_id=a.rent_mng_id and b.rent_l_cd=a.rent_l_cd \n"+
				"        and b.rent_s_cd=c.rent_s_cd(+) \n"+	//예약시스템-보유차사용 연결
				"        and c.sub_l_cd=d.rent_l_cd(+) \n"+		//예약시스템-대차등 계약연결
				"        and b.pol_sta=e.gov_id(+) \n"+
				"        and b.fault_nm=f.user_id(+) \n"+		
				" ";

		if(mode.equals("client"))	query += " and decode(b.rent_s_cd,'',a.client_id,nvl(d.client_id,a.client_id))='"+client_id+"' \n";
		else						query += " and decode(b.rent_s_cd,'',a.rent_l_cd,nvl(decode(c.rent_st,'12','RM00000'||c.rent_s_cd,d.rent_l_cd),a.rent_l_cd))='"+l_cd+"' \n";

		query += " order by a.rent_l_cd, b.vio_dt";

		try {
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
			System.out.println("[SettleDatabase:getFineList]\n"+e);
			System.out.println("[SettleDatabase:getFineList]\n"+query);
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

	/**
	 *	면책금 미수 스케줄
	 */
	public Vector getServList(String m_id, String l_cd, String client_id, String mode, String gubun2, String st_dt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		//연체료 계산 기준일-현재
		String gubun2_query = "sysdate";

		//연체료 계산 기준일-임의일자
		if(gubun2.equals("6"))	gubun2_query = "to_date('"+AddUtil.ChangeString(st_dt)+"', 'YYYYMMDD')";

		String query = "";

		query = " select se.rent_mng_id, se.rent_l_cd, b.car_mng_id, b.accid_id, b.serv_id, \n"+
				"        decode(e.rent_st,'',decode(b.serv_st, '1','순회점검','2','일반수리','3','보증수리','4','사고수리'),'1','단기대여','9','보험대차','2','정비대차','3','사고대차','10','지연대차','4','업무대여','5','업무대여','12','월렌트') st, \n"+
				"        b.serv_dt, c.off_nm, b.rep_amt, \n"+
				"        se.ext_est_dt as est_dt, (se.ext_s_amt + se.ext_v_amt) as amt, se.dly_days, se.dly_amt,  \n"+
				"        se.ext_s_amt s_amt, se.ext_v_amt v_amt, se.ext_tm, b.cust_amt,  \n"+ 
				"        se.rent_st, se.ext_st, se.ext_tm, se.ext_id "+
				" from   scd_ext se, service b, cont a, serv_off c, accident d, rent_cont e, cont f   \n"+
				" where  se.ext_st = '3'  \n"+
				"        and (se.ext_s_amt + se.ext_v_amt) >0 and se.ext_pay_dt is null and nvl(se.bill_yn,'Y')='Y'  \n"+
				"        and se.ext_est_dt <= to_char("+gubun2_query+", 'YYYYMMDD') \n"+
				"        and nvl(b.no_dft_yn,'N')='N' \n"+
				"        and se.rent_mng_id = b.rent_mng_id and se.rent_l_cd = b.rent_l_cd and se.ext_id = b.serv_id  \n"+
				"        and b.rent_mng_id=a.rent_mng_id and b.rent_l_cd=a.rent_l_cd  \n"+
				"        and b.off_id=c.off_id(+)  \n"+
				"        and b.car_mng_id=d.car_mng_id and b.accid_id=d.accid_id  \n"+
				"        and d.rent_s_cd=e.rent_s_cd(+)  \n"+
				"        and e.sub_l_cd=f.rent_l_cd(+) \n"+
				" ";

		if(mode.equals("client"))	query += " and decode(d.rent_s_cd,'',a.client_id,f.client_id)='"+client_id+"'";
		else						query += " and decode(d.rent_s_cd,'',a.rent_l_cd,f.rent_l_cd)='"+l_cd+"'";

		query += " order by a.rent_l_cd, b.serv_dt";

		try {
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
			System.out.println("[SettleDatabase:getServList]\n"+e);
			System.out.println("[SettleDatabase:getServList]\n"+query);
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

	/**
	 *	휴/대차료 미수 스케줄
	 */
	public Vector getAccidList(String m_id, String l_cd, String client_id, String mode, String gubun2, String st_dt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		//연체료 계산 기준일-현재
		String gubun2_query = "sysdate";

		//연체료 계산 기준일-임의일자
		if(gubun2.equals("6"))	gubun2_query = "to_date('"+AddUtil.ChangeString(st_dt)+"', 'YYYYMMDD')";

		String query = "";

		query = " select a.rent_l_cd, a.rent_mng_id, b.car_mng_id, b.accid_id, b.seq_no, decode(c.accid_st, '1','피해','2','가해','3','쌍방','4','자차사고', '8', '단독',  '6', '수해') st, \n"+
				"        c.our_fault_per, substr(c.accid_dt,1,8) accid_dt, b.ins_com as ot_ins, b.req_dt, b.req_amt, \n"+
				"        d.ext_est_dt as est_dt, d.ext_s_amt s_amt, d.ext_v_amt v_amt, d.ext_s_amt+d.ext_v_amt as amt, "+
				"        b.dly_days, b.dly_amt, decode(b.req_gu,'1','휴차료','2','대차료') ins_req_gu, \n"+ 
				"        d.rent_st, d.ext_st, d.ext_tm, d.ext_id "+
				" from   my_accid b, accident c, cont a,  \n"+
                "        (select * from scd_ext where ext_st='6' and ext_pay_dt is null and (ext_s_amt+ext_v_amt)>0 ) d  \n"+
				" where   \n"+
				"        d.ext_est_dt <= to_char("+gubun2_query+", 'YYYYMMDD')  \n"+
				"        and b.req_amt > 0 and nvl(b.bill_yn,'Y')='Y' \n"+
				"        and b.car_mng_id=c.car_mng_id and b.accid_id=c.accid_id  \n"+
				"        and c.rent_mng_id=a.rent_mng_id and c.rent_l_cd=a.rent_l_cd  \n"+
				"	     and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd  \n"+
				"        and b.accid_id||to_char(b.seq_no)=d.ext_id  \n"+
				" ";

		if(mode.equals("client"))	query += " and a.client_id='"+client_id+"'";
		else						query += " and a.rent_l_cd='"+l_cd+"'";

		query += " order by a.rent_l_cd, c.accid_dt";

		try {
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
			System.out.println("[SettleDatabase:getAccidList]\n"+e);
			System.out.println("[SettleDatabase:getAccidList]\n"+query);
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

	/**
	 *	중도해지위약금 미수 스케줄
	 */
	public Vector getClsList(String m_id, String l_cd, String client_id, String mode, String gubun2, String st_dt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		//연체료 계산 기준일-현재
		String gubun2_query = "sysdate";

		//연체료 계산 기준일-임의일자
		if(gubun2.equals("6"))	gubun2_query = "to_date('"+AddUtil.ChangeString(st_dt)+"', 'YYYYMMDD')";

		String query = "";

		query = " select b.rent_mng_id, b.rent_l_cd, decode(b.ext_tm, '1','위약금','잔액') st, \n"+
				"        c.cls_dt as est_dt, b.ext_s_amt as s_amt, b.ext_v_amt as v_amt, (b.ext_s_amt+b.ext_v_amt) amt, b.dly_days, b.dly_amt, \n"+ 
				"        b.rent_st, b.ext_st, b.ext_tm, b.ext_id "+
				" from   scd_ext b, cls_cont c, cont a \n"+
				" where  b.ext_st = '4'  \n"+
				"        and b.rent_mng_id = c.rent_mng_id and b.rent_l_cd = c.rent_l_cd  \n"+
				"        and b.rent_mng_id = a.rent_mng_id and b.rent_l_cd = a.rent_l_cd  \n"+
				"        and nvl(b.bill_yn,'Y')='Y' and DECODE(a.car_st,'4',ABS(b.ext_s_amt+b.ext_v_amt),(b.ext_s_amt+b.ext_v_amt)) >0  and c.cls_doc_yn='Y' \n"+
				"        and c.cls_dt <= to_char("+gubun2_query+", 'YYYYMMDD')  \n"+
				"        and b.ext_pay_dt is null \n"+
				" ";

		if(mode.equals("client"))	query += " and a.client_id='"+client_id+"'";
		else						query += " and a.rent_l_cd='"+l_cd+"'";

		query += " order by a.rent_l_cd, b.ext_est_dt";

		try {
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
			System.out.println("[SettleDatabase:getClsList]\n"+e);
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

	/**
	 *	예약시스템 정산금 스케줄
	 */
	public Vector getRentCont12List(String c_id, String s_cd, String client_id, String mode, String gubun2, String st_dt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		//연체료 계산 기준일-현재
		String gubun2_query = "sysdate";

		//연체료 계산 기준일-임의일자
		if(gubun2.equals("6"))	gubun2_query = "to_date('"+AddUtil.ChangeString(st_dt)+"', 'YYYYMMDD')";

		String query = "";

		query = " select (b.rent_s_amt+b.rent_v_amt) rent_amt, b.* "+
				" from   scd_rent b, rent_cont a \n"+
				" where  b.rent_s_cd = a.rent_s_cd and a.rent_st='12' \n"+
				"        and nvl(b.bill_yn,'Y')='Y' and b.rent_s_amt > 0 \n"+
				"        and b.est_dt <= to_char("+gubun2_query+", 'YYYYMMDD')  \n"+
				"        and b.pay_dt is null \n"+
				" ";

		if(mode.equals("client"))	query += " and a.cust_id='"+client_id+"'";
		else						query += " and a.rent_s_cd='"+s_cd+"'";

		query += " order by a.rent_s_cd, b.est_dt";

		try {
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
			System.out.println("[SettleDatabase:getRentCont12List]\n"+e);
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



	//사원별미수금현황--------------------------------------------------------------------------------------------------------------

	// 미수금정산 리스트 통계 조회
	public String getStatSettleAmt(String gubun)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		String amt = "0";
		String dt = "to_char(sysdate,'YYYYMMDD')";
		String query = "";
		String sub_query1 = "";//대여료
		String sub_query2 = "";//선수금
		String sub_query3 = "";//과태료
		String sub_query4 = "";//면책금
		String sub_query5 = "";//휴대차료
		String sub_query6 = "";//중도정산금
		String sub_query7 = "";//단기요금

		sub_query1 = "SELECT count(0) fee_su, sum(fee_s_amt+fee_v_amt) fee_amt FROM scd_fee WHERE fee_s_amt <> 0 and rc_dt is null and nvl(bill_yn,'Y')='Y'";

		sub_query2 = "SELECT count(0) pre_su, sum(a.ext_s_amt+a.ext_v_amt) pre_amt FROM scd_ext a, cont b, fee c WHERE a.ext_st in ( '0', '1', '2') and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and a.rent_st=c.rent_st and a.ext_s_amt <> 0 and a.ext_pay_dt is null";

		sub_query3 = "SELECT count(0) fine_su, sum(paid_amt) fine_amt FROM fine WHERE paid_amt <> 0 and coll_dt is null and nvl(no_paid_yn,'N')<>'Y' and paid_st in ('3','4')";//and proxy_dt is not null and fault_st='1' 

		sub_query4 = "SELECT count(0) serv_su, sum(se.ext_s_amt+se.ext_v_amt) serv_amt FROM scd_ext se, service a WHERE  se.ext_st = '4' and se.rent_mng_id = a.rent_mng_id and se.rent_l_cd = a.rent_l_cd and se.ext_id = a.serv_id and se.ext_s_amt > 0 and se.ext_pay_dt is null and nvl(a.no_dft_yn,'N')<>'Y'";

		sub_query5 = "SELECT count(0) accid_su, sum(req_amt) accid_amt FROM my_accid WHERE req_amt <> 0 and pay_dt is null";

		sub_query6 = "SELECT count(0) cls_su, sum(a.ext_s_amt+a.ext_v_amt) cls_amt FROM scd_ext a, cls_cont b WHERE a.ext_st = '4' and a.ext_s_amt > 0 and a.ext_pay_dt is null and nvl(a.bill_yn,'Y')='Y' and b.cls_doc_yn='Y' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd";

		sub_query7 = "SELECT count(0) rent_su, sum(a.rent_s_amt+a.rent_v_amt) rent_amt FROM scd_rent a, rent_cont b WHERE a.rent_s_amt > 0 and a.pay_dt is null and nvl(a.bill_yn,'Y')='Y' and a.rent_s_cd=b.rent_s_cd and b.use_st<>'5'";

		if(gubun.equals("d")){//연체인거
			sub_query1 += " and r_fee_est_dt < "+dt;
//			sub_query2 += " and pp_est_dt < "+dt;
			sub_query2 += " and c.rent_start_dt < "+dt;
			sub_query3 += " and "+standard_dt+" < "+dt;
			sub_query4 += " and cust_plan_dt < "+dt;
			sub_query5 += " and req_dt < "+dt;
			sub_query6 += " and a.ext_est_dt < "+dt;
			sub_query7 += " and a.est_dt < "+dt;
		}

		query = " select nvl(fee_amt,0)+nvl(pre_amt,0)+nvl(fine_amt,0)+nvl(serv_amt,0)+nvl(cls_amt,0)+nvl(rent_amt,0) amt\n"+//nvl(accid_amt,0)+
				" from\n"+ 
				"		( "+sub_query1+" ) a,\n"+
				"		( "+sub_query2+" ) b,\n"+
				"		( "+sub_query3+" ) c,\n"+
				"		( "+sub_query4+" ) d,\n"+
//				"		( "+sub_query5+" ) e,\n"+
				"		( "+sub_query6+" ) f,\n"+
				"		( "+sub_query7+" ) g";

	
		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
    		ResultSetMetaData rsmd = rs.getMetaData(); 
			
			if(rs.next())
			{				
				amt = rs.getString(1);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[SettleDatabase:getStatSettleAmt]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return amt;
		}
	}

	// 미수금정산 리스트 통계 조회
	public float getStatSettleAmt(String brch_id, String dept_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		float per = 0;
		String query = "";
		String sub_qu = "";


			String dt = "to_char(sysdate,'YYYYMMDD')";
			String sub_query1 = "";//대여료
			String sub_query2 = "";//선수금
			String sub_query3 = "";//과태료
			String sub_query4 = "";//면책금
			String sub_query5 = "";//휴대차료
			String sub_query6 = "";//중도정산금	
			String sub_query7 = "";//총받을어음
			String sub_query8 = "";//총연체금액
			sub_query1 = "SELECT b.bus_id2, count(0) fee_su, sum(a.fee_s_amt+a.fee_v_amt) fee_amt FROM scd_fee a, cont b WHERE a.fee_s_amt <> 0 and a.rc_dt is null and nvl(a.bill_yn,'Y')='Y' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd group by b.bus_id2";
			sub_query2 = "SELECT b.bus_id2, count(0) pre_su, sum(a.ext_s_amt+a.ext_v_amt) pre_amt FROM scd_ext a, cont b, fee c WHERE a.ext_st in ('0', '1', '2' ) and a.ext_s_amt <> 0 and a.ext_pay_dt is null and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and a.rent_st=c.rent_st group by b.bus_id2";
			sub_query3 = "SELECT b.bus_id2, count(0) fine_su, sum(a.paid_amt) fine_amt FROM fine a, cont b WHERE a.paid_amt <> 0 and a.coll_dt is null and nvl(a.no_paid_yn,'N')<>'Y' and a.fault_st='1' and a.paid_st in ('3','4') and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd group by b.bus_id2";//a.proxy_dt is not null and 
			sub_query4 = "SELECT b.bus_id2, count(0) serv_su, sum(a.cust_amt) serv_amt FROM service a, cont b WHERE a.cust_amt <> 0 and a.cust_pay_dt is null and nvl(a.no_dft_yn,'N')<>'Y' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd group by b.bus_id2";
			sub_query5 = "SELECT c.bus_id2, count(0) accid_su, sum(a.req_amt) accid_amt FROM my_accid a, accident b, cont c WHERE a.req_amt <> 0 and a.pay_dt is null and a.accid_id=b.accid_id and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd group by c.bus_id2";
			sub_query6 = "SELECT c.bus_id2, count(0) cls_su, sum(a.ext_s_amt+a.ext_v_amt) cls_amt FROM scd_ext a, cls_cont b, cont c WHERE a.ext_st = '4' and a.ext_s_amt > 0 and a.ext_pay_dt is null and nvl(a.bill_yn,'Y')='Y' and b.cls_doc_yn='Y' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd group by c.bus_id2";

			sub_query7 = " select a.bus_id2,"+
					" nvl(fee_su,0)+nvl(pre_su,0)+nvl(fine_su,0)+nvl(serv_su,0)+nvl(cls_su,0) tot_su,\n"+//nvl(accid_su,0)+
					" nvl(fee_amt,0)+nvl(pre_amt,0)+nvl(fine_amt,0)+nvl(serv_amt,0)+nvl(cls_amt,0) tot_amt\n"+//nvl(accid_amt,0)+
					" from\n"+ 
					"		( select bus_id2 from cont group by bus_id2 ) a,"+
					"		( "+sub_query1+" ) b,\n"+
					"		( "+sub_query2+" ) c,\n"+
					"		( "+sub_query3+" ) d,\n"+
					"		( "+sub_query4+" ) e,\n"+
//					"		( "+sub_query5+" ) f,\n"+
					"		( "+sub_query6+" ) g"+
					" where a.bus_id2=b.bus_id2(+) and a.bus_id2=c.bus_id2(+) and a.bus_id2=d.bus_id2(+) and a.bus_id2=e.bus_id2(+) and a.bus_id2=g.bus_id2(+)";//and a.bus_id2=f.bus_id2(+) 

			sub_query1 = "SELECT b.bus_id2, count(0) fee_su, sum(a.fee_s_amt+a.fee_v_amt) fee_amt FROM scd_fee a, cont b WHERE a.r_fee_est_dt < "+dt+" and a.fee_s_amt <> 0 and a.rc_dt is null and nvl(a.bill_yn,'Y')='Y' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd group by b.bus_id2";
			sub_query2 = "SELECT b.bus_id2, count(0) pre_su, sum(a.ext_s_amt+a.ext_v_amt) pre_amt FROM scd_ext a, cont b, fee c WHERE a.ext_st in ('0', '1', '2') and c.rent_start_dt < "+dt+" and a.ext_s_amt <> 0 and a.ext_pay_dt is null and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and a.rent_st=c.rent_st group by b.bus_id2";
			sub_query3 = "SELECT b.bus_id2, count(0) fine_su, sum(a.paid_amt) fine_amt FROM fine a, cont b WHERE "+standard_dt2+" < "+dt+" and a.paid_amt <> 0 and a.coll_dt is null and nvl(a.no_paid_yn,'N')<>'Y' and a.fault_st='1' and a.paid_st in ('3','4') and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd group by b.bus_id2";//and a.proxy_dt is not null 
			sub_query4 = "SELECT b.bus_id2, count(0) serv_su, sum(a.cust_amt) serv_amt FROM service a, cont b WHERE a.cust_plan_dt < "+dt+" and a.cust_amt <> 0 and a.cust_pay_dt is null and nvl(a.no_dft_yn,'N')<>'Y' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd group by b.bus_id2";
			sub_query5 = "SELECT c.bus_id2, count(0) accid_su, sum(a.req_amt) accid_amt FROM my_accid a, accident b, cont c WHERE a.req_dt < "+dt+" and a.req_amt <> 0 and a.pay_dt is null and a.accid_id=b.accid_id and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd group by c.bus_id2";
			sub_query6 = "SELECT c.bus_id2, count(0) cls_su, sum(a.ext_s_amt+a.ext_v_amt) cls_amt FROM scd_ext a, cls_cont b, cont c WHERE a.ext_st = '4' and  a.ext_est_dt < "+dt+" and a.ext_s_amt > 0 and a.ext_pay_dt is null and nvl(a.bill_yn,'Y')='Y' and b.cls_doc_yn='Y' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd group by c.bus_id2";

			sub_query8 = " select a.bus_id2,"+
					" nvl(fee_su,0)+nvl(pre_su,0)+nvl(fine_su,0)+nvl(serv_su,0)+nvl(cls_su,0) su,\n"+//nvl(accid_su,0)+
					" nvl(fee_amt,0)+nvl(pre_amt,0)+nvl(fine_amt,0)+nvl(serv_amt,0)+nvl(cls_amt,0) amt\n"+//nvl(accid_amt,0)+
					" from\n"+ 
					"		(select bus_id2 from cont group by bus_id2) a,"+
					"		( "+sub_query1+" ) b,\n"+
					"		( "+sub_query2+" ) c,\n"+
					"		( "+sub_query3+" ) d,\n"+
					"		( "+sub_query4+" ) e,\n"+
//					"		( "+sub_query5+" ) f,\n"+
					"		( "+sub_query6+" ) g"+
					" where a.bus_id2=b.bus_id2(+) and a.bus_id2=c.bus_id2(+) and a.bus_id2=d.bus_id2(+) and a.bus_id2=e.bus_id2(+) and a.bus_id2=g.bus_id2(+)";//and a.bus_id2=f.bus_id2(+) 


			query = " select "+
					" avg(to_number(nvl(to_char((a.amt/b.tot_amt)*100, 999.999),0))) per1"+
					" from"+ 
					//연체금액	
					"	( "+sub_query8+" ) a, "+
					//받을어음
					"	( "+sub_query7+" ) b, "+
			  		" users c, (select bus_id2 from cont group by bus_id2) d"+
					" where c.use_yn='Y' and c.user_pos='사원' and b.tot_su<>0 and d.bus_id2=a.bus_id2(+) and d.bus_id2=b.bus_id2(+) and d.bus_id2=c.user_id"+
					" and b.bus_id2 is not null";// and c.dept_id in ('0001','0002')
			if(!brch_id.equals("")) query += " and c.br_id='"+brch_id+"'";
			if(!dept_id.equals("")) query += " and c.dept_id='"+dept_id+"'";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			if(rs.next())
			{
				per = rs.getFloat(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[SettleDatabase:getStatSettleAmt]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return per;
		}
	}

	/**
	 *	미수금현황 리스트
	 */
	public Vector getStatSettleList(String brch_id, String dept_id, String save_dt, String eff_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_qu = "";
		String magni = "";//5배할증 *5 -> 20131022 할증해제
//		String eff_dt = "20050706";
		//계산식 변수
//		EstiDatabase e_db = EstiDatabase.getInstance();
//		String var6 = e_db.getEstiSikVarCase("1", "", "dly6");
//		eff_dt = var6;

		if(save_dt.equals("")){

			String dt = "to_char(sysdate,'YYYYMMDD')";
			String sub_query1 = "";//대여료
			String sub_query2 = "";//선수금
			String sub_query3 = "";//과태료
			String sub_query4 = "";//면책금
			String sub_query5 = "";//휴대차료
			String sub_query6 = "";//중도정산금	
			String sub_query7 = "";//총받을어음
			String sub_query8 = "";//총연체금액
			sub_query1 = "SELECT b.bus_id2, count(0) fee_su, sum(a.fee_s_amt+a.fee_v_amt) fee_amt FROM scd_fee a, cont b WHERE a.fee_s_amt <> 0 and a.rc_dt is null and nvl(a.bill_yn,'Y')='Y' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd group by b.bus_id2";
			sub_query2 = "SELECT b.bus_id2, count(0) pre_su, sum(a.ext_s_amt+a.ext_v_amt) pre_amt FROM scd_ext a, cont b WHERE a.ext_st in ( '0', '1', '2') and a.ext_s_amt <> 0 and a.ext_pay_dt is null and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd group by b.bus_id2";
			sub_query3 = "SELECT b.bus_id2, count(0) fine_su, sum(a.paid_amt) fine_amt FROM fine a, cont b WHERE a.paid_amt <> 0 and a.coll_dt is null and nvl(a.no_paid_yn,'N')<>'Y' and a.paid_st in ('3','4') and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd group by b.bus_id2";//a.proxy_dt is not null and a.fault_st='1' and 
			sub_query4 = "SELECT b.bus_id2, count(0) serv_su, sum(a.cust_amt) serv_amt FROM service a, cont b WHERE a.cust_amt <> 0 and a.cust_pay_dt is null and nvl(a.no_dft_yn,'N')<>'Y' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd group by b.bus_id2";
			sub_query5 = "SELECT c.bus_id2, count(0) accid_su, sum(a.req_amt) accid_amt FROM my_accid a, accident b, cont c WHERE a.req_amt <> 0 and a.pay_dt is null and a.accid_id=b.accid_id and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd group by c.bus_id2";
			sub_query6 = "SELECT c.bus_id2, count(0) cls_su, sum(a.ext_s_amt+a.ext_v_amt) cls_amt FROM scd_ext a, cls_cont b, cont c WHERE a.ext_st = '4' and a.ext_s_amt > 0 and a.ext_pay_dt is null and nvl(a.bill_yn,'Y')='Y' and b.cls_doc_yn='Y' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd group by c.bus_id2";

			sub_query7 = " select a.bus_id2,"+
					" nvl(fee_su,0)+nvl(pre_su,0)+nvl(fine_su,0)+nvl(serv_su,0)+nvl(cls_su,0) tot_su,\n"+//nvl(accid_su,0)+
					" nvl(fee_amt,0)+nvl(pre_amt,0)+nvl(fine_amt,0)+nvl(serv_amt,0)+nvl(cls_amt,0) tot_amt\n"+//nvl(accid_amt,0)+
					" from\n"+ 
					"		( select bus_id2 from cont group by bus_id2 ) a,"+
					"		( "+sub_query1+" ) b,\n"+
					"		( "+sub_query2+" ) c,\n"+
					"		( "+sub_query3+" ) d,\n"+
					"		( "+sub_query4+" ) e,\n"+
//					"		( "+sub_query5+" ) f,\n"+
					"		( "+sub_query6+" ) g"+
					" where a.bus_id2=b.bus_id2(+) and a.bus_id2=c.bus_id2(+) and a.bus_id2=d.bus_id2(+) and a.bus_id2=e.bus_id2(+) and a.bus_id2=g.bus_id2(+)";//and a.bus_id2=f.bus_id2(+) 

			sub_query1 = "SELECT b.bus_id2, count(0) fee_su, sum(a.fee_s_amt+a.fee_v_amt) fee_amt FROM scd_fee a, cont b WHERE a.r_fee_est_dt < "+dt+" and a.fee_s_amt <> 0 and a.rc_dt is null and nvl(a.bill_yn,'Y')='Y' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd group by b.bus_id2";
//			sub_query2 = "SELECT b.bus_id2, count(0) pre_su, sum(a.pp_s_amt+a.pp_v_amt) pre_amt FROM scd_pre a, cont b WHERE a.pp_est_dt < "+dt+" and a.pp_s_amt <> 0 and a.pp_pay_dt is null and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd group by b.bus_id2";
			sub_query2 = "SELECT b.bus_id2, count(0) pre_su, sum(a.ext_s_amt+a.ext_v_amt) pre_amt FROM scd_ext a, cont b, fee c WHERE a.ext_st in ('0', '1', '2') and c.rent_start_dt < "+dt+" and a.ext_s_amt <> 0 and a.ext_pay_dt is null and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and a.rent_st=c.rent_st group by b.bus_id2";
			sub_query3 = "SELECT b.bus_id2, count(0) fine_su, sum(a.paid_amt) fine_amt FROM fine a, cont b WHERE "+standard_dt2+" < "+dt+" and a.paid_amt <> 0 and a.coll_dt is null and nvl(a.no_paid_yn,'N')<>'Y' and a.paid_st in ('3','4') and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd group by b.bus_id2";//and a.proxy_dt is not null a.fault_st='1' and 
			sub_query4 = "SELECT b.bus_id2, count(0) serv_su, sum(a.cust_amt) serv_amt FROM service a, cont b WHERE a.cust_plan_dt < "+dt+" and a.cust_amt <> 0 and a.cust_pay_dt is null and nvl(a.no_dft_yn,'N')<>'Y' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd group by b.bus_id2";
			sub_query5 = "SELECT c.bus_id2, count(0) accid_su, sum(a.req_amt) accid_amt FROM my_accid a, accident b, cont c WHERE a.req_dt < "+dt+" and a.req_amt <> 0 and a.pay_dt is null and a.accid_id=b.accid_id and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd group by c.bus_id2";
			sub_query6 = "SELECT c.bus_id2, count(0) cls_su, sum(a.ext_s_amt+a.ext_v_amt) cls_amt FROM scd_ext a, cls_cont b, cont c WHERE a.ext_st = '4' and a.ext_est_dt < "+dt+" and a.ext_s_amt > 0 and a.ext_pay_dt is null and nvl(a.bill_yn,'Y')='Y' and b.cls_doc_yn='Y' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd group by c.bus_id2";

			sub_query8 = " select a.bus_id2,"+
					" nvl(fee_su,0)+nvl(pre_su,0)+nvl(fine_su,0)+nvl(serv_su,0)+nvl(cls_su,0) su,\n"+//nvl(accid_su,0)+
					" nvl(fee_amt,0)+nvl(pre_amt,0)+nvl(fine_amt,0)+nvl(serv_amt,0)+nvl(cls_amt,0)  amt\n"+//nvl(accid_amt,0)+
					" from\n"+ 
					"		(select bus_id2 from cont group by bus_id2) a,"+
					"		( "+sub_query1+" ) b,\n"+
					"		( "+sub_query2+" ) c,\n"+
					"		( "+sub_query3+" ) d,\n"+
					"		( "+sub_query4+" ) e,\n"+
//					"		( "+sub_query5+" ) f,\n"+
					"		( "+sub_query6+" ) g"+
					" where a.bus_id2=b.bus_id2(+) and a.bus_id2=c.bus_id2(+) and a.bus_id2=d.bus_id2(+) and a.bus_id2=e.bus_id2(+) and a.bus_id2=g.bus_id2(+)";//and a.bus_id2=f.bus_id2(+) 


			query = " select b.bus_id2, c.user_nm, c.br_id, c.dept_id, b.tot_su, b.tot_amt, nvl(a.su,0) su, nvl(a.amt,0) amt,"+
					" to_number(nvl(to_char((a.amt/b.tot_amt)*100, 999.99),0)) per1, '' per2, e.per1 as per_0405"+
					" from"+ 
					//연체금액	
					"	( "+sub_query8+" ) a, "+
					//받을어음
					"	( "+sub_query7+" ) b, "+
			  		" users c, (select bus_id2 from cont group by bus_id2) d"+
					" , (select bus_id2, per1 from stat_settle where save_dt='"+eff_dt+"') e"+
					" where c.use_yn='Y' and b.tot_su<>0 and d.bus_id2=a.bus_id2(+) and d.bus_id2=b.bus_id2(+) and d.bus_id2=c.user_id"+//c.br_id='S1' and 
					" and b.bus_id2 is not null and c.user_id=e.bus_id2(+)";// and c.dept_id in ('0001','0002')
			if(!brch_id.equals("")) query += " and c.br_id='"+brch_id+"'";
			if(!dept_id.equals("")) query += " and c.dept_id='"+dept_id+"'";
			sub_qu = "to_number(nvl(to_char((a.amt/b.tot_amt)*100, 999.99),0))";

		}else{
			query = " select a.*, 0 tot_su, c.br_id, c.dept_id, e.per1 as per_0405 from stat_settle a, users c, (select bus_id2, per1 from stat_settle where save_dt='"+eff_dt+"') e where a.bus_id2=c.user_id and a.save_dt='"+save_dt+"' and a.bus_id2=e.bus_id2(+)";
			if(!brch_id.equals("")) query += " and c.br_id='"+brch_id+"'";
			if(!dept_id.equals("")) query += " and c.dept_id='"+dept_id+"'";
			sub_qu = "seq";
		}

		query += " order by "+sub_qu+" , a.amt desc";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			
			while(rs.next())
			{
				IncomingSBean fee = new IncomingSBean();
				fee.setGubun(rs.getString("bus_id2"));
				fee.setBr_id(rs.getString("br_id"));
				fee.setDept_id(rs.getString("dept_id"));
				fee.setTot_su1(rs.getString("tot_su"));
				fee.setTot_amt1(rs.getString("tot_amt"));
				fee.setTot_su2(rs.getString("su"));
				fee.setTot_amt2(rs.getString("amt"));
				fee.setTot_su3(rs.getString("per1"));
				fee.setTot_su4(rs.getString("per2")==null?"":rs.getString("per2"));
				fee.setTot_su5(rs.getString("per_0405")==null?"":rs.getString("per_0405"));
				vt.add(fee);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[SettleDatabase:getStatSettleList]"+e);
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


	//총통화내역(dly_mm, tel_mm)---------------------------------------------------------------------------

	// 미수금정산 리스트 조회
	public Vector getTotalTelList(String m_id, String l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select * from\n"+
				"	    (\n"+
				"       select rent_mng_id, rent_l_cd, '대여료' gubun,\n"+
				"       decode(fee_tm,'A','(전체)','('||fee_tm||'회)') as tm,\n"+
				"       reg_dt, reg_id, content, speaker, reg_dt_time\n"+
				"       from dly_mm where rent_l_cd='"+l_cd+"'\n"+
				"       union all\n"+
				"       select rent_mng_id, rent_l_cd, decode(tm_st, '1','면책금', '2','휴차료', '3','대차료', '4','중도해지', '5','과태료', '6','사고') gubun,\n"+
				"       '' tm,\n"+
				"       reg_dt, reg_id, content, speaker, reg_dt_time\n"+
				"       from tel_mm where rent_l_cd='"+l_cd+"'\n"+
				"       )\n"+
				" order by reg_dt||reg_dt_time desc";
	
		try {
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
			System.out.println("[SettleDatabase:getTotalTelList]\n"+e);
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

	/**
	 *	대여료 연체료 입금액 가져오기
	 */
	public int getDlyPayAmt(String m_id, String l_cd, String client_id, String mode)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int amt = 0;
		String query =  " select sum(b.pay_amt) fee_dly_pay_amt from cont a, scd_dly b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd";

		if(mode.equals("client"))	query += " and a.client_id='"+client_id+"'";
		else						query += " and a.rent_mng_id='"+m_id+"' and a.rent_l_cd='"+l_cd+"'";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
      		
			if(rs.next()){
				amt = rs.getInt("fee_dly_pay_amt");
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[SettleDatabase:getDlyPayAmt]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return amt;
		}				
	}


	//미수금정산 변경 : 보유차 운행중 과태료/면책금/단기요금 포함 -------------------------------------------------------

	String est_amt1 = "(a.ext_s_amt+a.ext_v_amt)";
	String est_amt1_1 = "(a.ext_s_amt+a.ext_v_amt)";  //실제반영 - 승계수수료 
	String est_amt2 = "(a.fee_s_amt+a.fee_v_amt)";
	String est_amt3 = "(a.paid_amt)";
	String est_amt4 = "(se.ext_s_amt+se.ext_v_amt)";
	String est_amt5 = "(a.req_amt)";
	String est_amt5_1 ="(se.ext_s_amt+se.ext_v_amt)";
	String est_amt6 = "(a.ext_s_amt+a.ext_v_amt)";
	String est_amt7 = "(a.rent_s_amt+a.rent_v_amt)";
	String est_amt7_1 = "DECODE(b.RENT_ST||a.rent_st,'123',TRUNC((a.rent_s_amt+a.rent_v_amt)*DECODE(NVL(b.mng_id,b.bus_id),b.bus_id,1,0.2)),'124',TRUNC((a.rent_s_amt+a.rent_v_amt)*DECODE(NVL(b.mng_id,b.bus_id),b.bus_id,1,0.2)),'125',TRUNC((a.rent_s_amt+a.rent_v_amt)*DECODE(NVL(b.mng_id,b.bus_id),b.bus_id,1,0.2)),'128',TRUNC((a.rent_s_amt+a.rent_v_amt)*DECODE(NVL(b.mng_id,b.bus_id),b.bus_id,1,0.2)),(a.rent_s_amt+a.rent_v_amt))";
	String est_amt7_2 = "TRUNC((a.rent_s_amt+a.rent_v_amt)*0.8)";
	
	String est_amt_n2 = "(case when nvl(c.in_cnt,0)>0 then (a.fee_s_amt+a.fee_v_amt)*0.1 else (a.fee_s_amt+a.fee_v_amt)  end)";
	String est_amt_n6 = "(case when d.gi_amt is not null  then (a.ext_s_amt+a.ext_v_amt)-decode(sign(d.gi_amt-a.ext_s_amt+a.ext_v_amt),-1,d.gi_amt,a.ext_s_amt+a.ext_v_amt) else (a.ext_s_amt+a.ext_v_amt)  end)";

	String est_dt1 = "b.rent_start_dt";
//	String est_dt1_1 = "decode(c.rent_st||b.rent_st||b.grt_suc_yn||a.ext_st,'3100',nvl(b.pp_est_dt,a.ext_est_dt),b.rent_start_dt)";
//	String est_dt1_1 = "decode(a.ext_st,'5',a.ext_est_dt,decode(c.rent_st||b.rent_st||b.grt_suc_yn||a.ext_st,'3100',to_char(add_months(to_date(nvl(c.dlv_dt,to_char(sysdate,'YYYYMMDD')),'YYYYMMDD'),1),'YYYYMMDD'),nvl(d.rent_suc_dt,b.rent_start_dt)))";
	String est_dt1_1 =  "decode(a.ext_st,'5',nvl(d.rent_suc_dt,a.ext_est_dt), \n"+//승계수수료
						"       decode(c.rent_st||b.rent_st||b.grt_suc_yn||a.ext_st,'3100', \n"+//--대차승계보증금
						"              decode(a.gubun,'E',a.ext_est_dt, \n"+
						"                     to_char(to_date(nvl(b.rent_start_dt,to_char(sysdate,'YYYYMMDD')),'YYYYMMDD')+15,'YYYYMMDD') \n"+
						"              ), \n"+
//						"              nvl(d.rent_suc_dt,b.rent_start_dt) \n"+
//						"              case when d.rent_suc_dt is not null and d.rent_suc_dt > b.rent_start_dt then d.rent_suc_dt else b.rent_start_dt end \n"+
						"                            case when d.rent_suc_dt is not null and d.rent_suc_dt > b.rent_start_dt then d.rent_suc_dt \n"+
					    "                                                             WHEN d.rent_suc_dt IS NULL AND a.ext_st='5' THEN a.ext_est_dt  \n"+ 
						"                                                             else b.rent_start_dt end \n"+
						"       ) \n"+
						")";
	String est_dt2 = "a.r_fee_est_dt";
	String est_dt3 = "nvl(a.dem_dt,nvl(a.rec_plan_dt,a.paid_end_dt))";
	String est_dt4 = "nvl(se.ext_est_dt, a.cust_plan_dt)";

	String est_dt5 = "a.req_dt";
	String est_dt6 = "nvl2(a.ext_est_dt,b.cls_dt,b.cls_dt)";  //원본 >> nvl(a.ext_est_dt,b.cls_dt)
	String est_dt7 = "a.est_dt";

	String condition1	= "and a.ext_s_amt>0 and a.ext_pay_dt is null";
	String condition2	= "and a.fee_s_amt>0 and a.rc_dt is null and nvl(a.bill_yn,'Y')='Y'";
	
	String condition3	= "and a.paid_amt>0  and ( (a.vio_cont not like  '%통행료%' and a.vio_cont not like  '%주차요금%') or  ( a.vio_cont like  '%통행료%' and a.proxy_dt is not null ) or ( a.vio_cont like  '%주차요금%' and a.proxy_dt is not null )  )  and a.coll_dt is null and decode(a.fault_st,'2','Y',nvl(a.bill_yn,'Y'))='Y' and a.paid_st in ('3','4') and nvl(a.no_paid_yn,'N')='N'";
	String condition3_1	= "and a.paid_amt>0 and ( (a.vio_cont not like  '%통행료%' and a.vio_cont not like  '%주차요금%') or  ( a.vio_cont like  '%통행료%' and a.proxy_dt is not null ) or ( a.vio_cont like  '%주차요금%' and a.proxy_dt is not null )  )  and a.coll_dt is null and decode(a.fault_st,'2','Y',nvl(a.bill_yn,'Y'))='Y' and a.rent_s_cd is null and a.paid_st in ('3','4') and nvl(a.no_paid_yn,'N')='N'";
	String condition3_2 = "and a.paid_amt>0 and ( (a.vio_cont not like  '%통행료%' and a.vio_cont not like  '%주차요금%') or  ( a.vio_cont like  '%통행료%' and a.proxy_dt is not null ) or ( a.vio_cont like  '%주차요금%' and a.proxy_dt is not null )  ) and a.coll_dt is null and decode(a.fault_st,'2','Y',nvl(a.bill_yn,'Y'))='Y' and a.rent_s_cd is not null and a.paid_st in ('3','4') and nvl(a.no_paid_yn,'N')='N'";
   //마스타과실제외 
	String condition3_4	= "and a.paid_amt>0 and a.coll_dt is null and decode(a.fault_st,'2','Y', '3', 'N', nvl(a.bill_yn,'Y'))='Y' and a.paid_st in ('3','4') and nvl(a.no_paid_yn,'N')='N' and ( (a.vio_cont not like  '%통행료%' and a.vio_cont not like  '%주차요금%') or  ( a.vio_cont like  '%통행료%' and a.proxy_dt is not null ) or ( a.vio_cont like  '%주차요금%' and a.proxy_dt is not null )  ) ";
	String condition4	= "and se.ext_s_amt>0 and se.ext_pay_dt is null and nvl(se.bill_yn,'Y')='Y' and nvl(a.no_dft_yn,'N')='N'";
//	String condition4	= "and se.ext_s_amt>0 and se.ext_pay_dt is null and nvl(a.bill_yn,'Y')='Y' and nvl(a.no_dft_yn,'N')='N'";
	String condition4_1	= "and se.ext_s_amt>0 and se.ext_pay_dt is null and nvl(se.bill_yn,'Y')='Y' and b.rent_s_cd is null and nvl(a.no_dft_yn,'N')='N'";
	String condition4_2 = "and se.ext_s_amt>0 and se.ext_pay_dt is null and nvl(se.bill_yn,'Y')='Y' and b.rent_s_cd is not null and nvl(a.no_dft_yn,'N')='N'";
	String condition5	= "and a.req_amt>0 and a.pay_dt is null and nvl(a.bill_yn,'Y')='Y'";
	String condition5_1	= "and a.req_amt>0   and (se.ext_s_amt+se.ext_v_amt) > 0 and se.ext_pay_dt is null and nvl(a.bill_yn,'Y')='Y'";
	String condition6	= "and DECODE(c.car_st,'4',case when b.fdft_amt2 < 0 then 0 else a.ext_s_amt+a.ext_v_amt end,(a.ext_s_amt+a.ext_v_amt)) >0 and a.ext_pay_dt is null and nvl(a.bill_yn,'Y')='Y' and nvl(b.cls_doc_yn,'Y')='Y'";
	String condition7	= "and a.rent_s_amt>0 and a.pay_dt is null and nvl(a.bill_yn,'Y')='Y' and b.use_st<>'5' ";
	String condition7_2	= "and a.rent_s_amt>0 and a.pay_dt is null and nvl(a.bill_yn,'Y')='Y' and b.use_st<>'5' AND b.RENT_ST='12' AND a.rent_st in ('3','4','5') AND b.mng_id IS NOT NULL AND b.mng_id<>b.bus_id";


	String bad_debt1	= "and a.ext_s_amt>0 and a.ext_pay_dt is null and nvl(a.bill_yn,'Y')='N'";
	String bad_debt2	= "and a.fee_s_amt>0 and a.rc_dt is null and nvl(a.bill_yn,'Y')='N'";
	String bad_debt3	= "and a.paid_amt>0 and ( (a.vio_cont not like  '%통행료%' and a.vio_cont not like  '%주차요금%') or  ( a.vio_cont like  '%통행료%' and a.proxy_dt is not null ) or ( a.vio_cont like  '%주차요금%' and a.proxy_dt is not null )  ) and a.coll_dt is null and decode(a.fault_st,'2','Y',nvl(a.bill_yn,'Y'))='N' and a.paid_st in ('3','4') and nvl(a.no_paid_yn,'N')='N'";
	String bad_debt3_1	= "and a.paid_amt>0 and( (a.vio_cont not like  '%통행료%' and a.vio_cont not like  '%주차요금%') or  ( a.vio_cont like  '%통행료%' and a.proxy_dt is not null ) or ( a.vio_cont like  '%주차요금%' and a.proxy_dt is not null )  )  and a.coll_dt is null and decode(a.fault_st,'2','Y',nvl(a.bill_yn,'Y'))='N' and a.rent_s_cd is null and a.paid_st in ('3','4') and nvl(a.no_paid_yn,'N')='N'";
	String bad_debt3_2  = "and a.paid_amt>0 and( (a.vio_cont not like  '%통행료%' and a.vio_cont not like  '%주차요금%') or  ( a.vio_cont like  '%통행료%' and a.proxy_dt is not null ) or ( a.vio_cont like  '%주차요금%' and a.proxy_dt is not null )  )  and a.coll_dt is null and decode(a.fault_st,'2','Y',nvl(a.bill_yn,'Y'))='N' and a.rent_s_cd is not null and a.paid_st in ('3','4') and nvl(a.no_paid_yn,'N')='N'";
	String bad_debt4	= "and se.ext_s_amt>0 and se.ext_pay_dt is null and nvl(a.bill_yn,'Y')='N' and nvl(a.no_dft_yn,'N')='N'";
	String bad_debt4_1	= "and se.ext_s_amt>0 and se.ext_pay_dt is null and nvl(a.bill_yn,'Y')='N' and b.rent_s_cd is null and nvl(a.no_dft_yn,'N')='N'";
	String bad_debt4_2  = "and se.ext_s_amt>0 and se.ext_pay_dt is null and nvl(a.bill_yn,'Y')='N' and b.rent_s_cd is not null and nvl(a.no_dft_yn,'N')='N'";
	String bad_debt5	= "and a.req_amt>0 and a.pay_dt is null and nvl(a.bill_yn,'Y')='N'";
	String bad_debt6	= "and (a.ext_s_amt + a.ext_v_amt) >0 and a.ext_pay_dt is null and nvl(a.bill_yn,'Y')='N' and nvl(cls_doc_yn,'Y')='Y'";
	String bad_debt7	= "and a.rent_s_amt>0 and a.pay_dt is null and nvl(a.bill_yn,'Y')='N' ";


	// 미수금정산 리스트 조회--장기/단기를 분류해서 조회
	public Vector getSettleList2(String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";

		String settle_dt = " < to_char(sysdate,'YYYYMMDD')";
		//임의일자
		if(gubun2.equals("6"))	settle_dt = " < to_char(to_date('"+AddUtil.ChangeString(st_dt)+"', 'YYYYMMDD'), 'YYYYMMDD')";

		query1 = " select"+
				 " '장기' gubun1, a.rent_l_cd, a.client_id, b.firm_nm, c.car_mng_id, c.car_no, a.bus_id2, d.user_nm, a.use_yn, z.gubun2, z.est_amt, '' gubun3"+
				 " from cont a, client b, car_reg c, users d,"+
				 " ( "+
				 "      select '선수금' gubun2, a.rent_l_cd, "+est_amt1+" est_amt from scd_ext a, fee b where a.ext_st in ('0', '1', '2') and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st and "+est_dt1+" "+settle_dt+" "+condition1+"\n"+
				 "      union all"+
				 "      select '대여료' gubun2, a.rent_l_cd, "+est_amt2+" est_amt from scd_fee a where "+est_dt2+" "+settle_dt+" "+condition2+"\n"+
				 "      union all"+
				 "      select '과태료' gubun2, a.rent_l_cd, "+est_amt3+" est_amt from fine a where "+est_dt3+" "+settle_dt+" "+condition3_1+"\n"+
				 "      union all"+
				 "      select '면책금' gubun2, a.rent_l_cd, "+est_amt4+" est_amt from service a, accident b where a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and "+est_dt4+" "+settle_dt+" "+condition4_1+"\n"+
				 "      union all"+
				 "      select '휴차료' gubun2, b.rent_l_cd, "+est_amt5+" est_amt from my_accid a, accident b where a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and "+est_dt5+" "+settle_dt+" "+condition5+"\n"+
				 "      union all"+
				 "      select '위약금' gubun2, a.rent_l_cd, "+est_amt6+" est_amt from scd_ext a, cls_cont b, cont c where a.ext_st = '4' and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and "+est_dt6+" "+settle_dt+" "+condition6+"\n"+
				 " ) z"+
				 " where a.client_id=b.client_id and a.car_mng_id=c.car_mng_id(+) and a.bus_id2=d.user_id(+) and a.rent_l_cd=z.rent_l_cd";

		query2 = " select"+
				 " '단기' gubun1, decode(a.sub_l_cd,'',z.rent_l_cd,f.rent_l_cd) rent_l_cd, d.client_id,"+
				 " decode(a.cust_st,'4',e.user_nm, d.firm_nm)||'('||decode(a.rent_st,'1','단기대여','9','보험대차','2','정비대차','3','사고대차','4','업무대여','5','업무대여','12','월렌트')||')' firm_nm,"+
				 " c.car_mng_id, c.car_no,"+
				 " decode(a.rent_st,'1',a.bus_id,'9',a.bus_id,'2',f.bus_id2,'3',f.bus_id2,'10',f.bus_id2,'4',a.cust_id,'5',a.cust_id) bus_id2,"+
				 " decode(a.rent_st,'1',g.user_nm,'9',g.user_nm,'2',h.user_nm,'3',h.user_nm,'4',e.user_nm,'5',e.user_nm) user_nm,"+
				 " nvl(f.use_yn,'Y') use_yn, z.gubun2, z.est_amt,"+
				 " decode(a.rent_st,'1','단기대여','9','보험대차','2','정비대차','3','사고대차','4','업무대여','5','업무대여','12','월렌트') gubun3"+
				 " from"+
				 " ("+
				 "     select '과태료' gubun2, a.rent_l_cd, a.car_mng_id, a.rent_s_cd, "+est_amt3+" est_amt from fine a where "+est_dt3+" "+settle_dt+" "+condition3_2+"\n"+
				 "     union all"+
				 "     select '면책금' gubun2, a.rent_l_cd, a.car_mng_id, b.rent_s_cd, "+est_amt4+" est_amt from service a, accident b where a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and "+est_dt4+" "+settle_dt+" "+condition4_2+"\n"+
				 " ) z,"+
				 " rent_cont a, car_reg c, client d, users e, cont f, users g, users h"+
				 " where "+
				 " z.rent_s_cd=a.rent_s_cd and z.car_mng_id=c.car_mng_id and a.cust_id=d.client_id(+) and a.cust_id=e.user_id(+)"+
				 " and a.bus_id=g.user_id(+) and f.bus_id2=h.user_id(+) and a.sub_l_cd=f.rent_l_cd(+)";


		query = " select"+
				" use_yn, firm_nm, car_mng_id, car_no, user_nm, rent_l_cd, decode(min(gubun3),'업무대여','','단기대여','','보험대차','','월렌트','',min(client_id)) client_id,"+
				" sum(est_amt) est_amt0,"+
				" sum(decode(gubun2,'선수금',est_amt)) est_amt1,"+
				" sum(decode(gubun2,'대여료',est_amt)) est_amt2,"+
				" sum(decode(gubun2,'과태료',est_amt)) est_amt3,"+
				" sum(decode(gubun2,'면책금',est_amt)) est_amt4,"+
				" sum(decode(gubun2,'휴차료',est_amt)) est_amt5,"+
				" sum(decode(gubun2,'위약금',est_amt)) est_amt6,"+
				" count(firm_nm) est_su0,"+
				" count(decode(gubun2,'선수금',firm_nm)) est_su1,"+
				" count(decode(gubun2,'대여료',firm_nm)) est_su2,"+
				" count(decode(gubun2,'과태료',firm_nm)) est_su3,"+
				" count(decode(gubun2,'면책금',firm_nm)) est_su4,"+
				" count(decode(gubun2,'휴차료',firm_nm)) est_su5,"+
				" count(decode(gubun2,'위약금',firm_nm)) est_su6"+
				" from"+
				"	 ("+query1+" union all "+query2+")"+
				" where est_amt>0";

		if(gubun4.equals("1"))		query += " and gubun2='대여료'";
		else if(gubun4.equals("2"))	query += " and gubun2='선수금'";
		else if(gubun4.equals("3"))	query += " and gubun2='과태료'";
		else if(gubun4.equals("4"))	query += " and gubun2='면책금'";
		else if(gubun4.equals("5"))	query += " and gubun2='휴차료'";
		else if(gubun4.equals("6"))	query += " and gubun2='위약금'";
		
		if(s_kd.equals("1"))		query += " and firm_nm like '%"+t_wd+"%'";
		else if(s_kd.equals("4"))	query += " and car_no like '%"+t_wd+"%'";
		else if(s_kd.equals("8"))	query += " and bus_id2 = '"+t_wd+"'";

		query += " group by use_yn, firm_nm, car_mng_id, car_no, user_nm, rent_l_cd";

		query += " order by use_yn desc, firm_nm";

	
		try {
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
			System.out.println("[SettleDatabase:getSettleList2]\n"+e);
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

	// 미수금정산 리스트 조회--장기/단기를 같이 조회
	public Vector getSettleList3(String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", sub_query = "";

		String settle_dt = " < to_char(sysdate,'YYYYMMDD')";
		//임의일자
		if(gubun2.equals("6"))	settle_dt = " < to_char(to_date('"+AddUtil.ChangeString(st_dt)+"', 'YYYYMMDD'), 'YYYYMMDD')";

		sub_query = " select"+
				 " decode(a.rent_s_cd,'','장기','단기') gubun1,"+
				 " a.gubun2,"+
				 " decode(d.rent_st,'1','단기대여','9','보험대차','2','정비대차','3','사고대차','4','업무대여','5','업무대여','12','월렌트') gubun3,"+
				 " decode(d.sub_l_cd,'',b.rent_l_cd,d.sub_l_cd) rent_l_cd, "+
				 " decode(d.sub_l_cd,'',b.rent_mng_id,g.rent_mng_id) rent_mng_id,"+
				 " nvl(c.car_mng_id,i.car_mng_id) car_mng_id,"+
				 " decode(a.rent_s_cd,'',e.client_id,decode(d.cust_st,'1',f.client_id,h.user_id)) client_id,"+
				 " decode(a.rent_s_cd,'',decode(a.fault_nm,'',b.bus_id2,nvl(a.fault_nm,b.bus_id2)),decode(d.rent_st,'1',d.bus_id,'9',d.bus_id,'12',d.bus_id, '2',nvl(g.bus_id2,d.bus_id),'3',nvl(g.bus_id2,d.bus_id),'10',nvl(g.bus_id2,d.bus_id),'4',d.cust_id,'5',d.cust_id)) bus_id2,"+
				 " decode(a.rent_s_cd,'',e.firm_nm,decode(d.cust_st,'1',f.firm_nm,h.user_nm)) firm_nm,"+
				 " nvl(c.car_no,i.car_no) car_no, nvl(c.car_nm,i.car_nm) car_nm,"+
				 " d.rent_s_cd,"+
				 " a.est_amt,"+
				 " decode(a.rent_s_cd,'',b.use_yn,nvl(g.use_yn,'Y')) use_yn, nvl(j.in_cnt,0) in_cnt"+
				 " from \n"+
				 " ( "+
				 "      select '선수금' gubun2, '' rent_s_cd, a.rent_l_cd, '' fault_st, '' fault_nm, "+est_amt1+" est_amt from scd_ext a, fee b, cont c, cont_etc d where a.ext_st in ('0', '1', '2' ) and nvl(a.bill_yn,'Y')='Y' and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+) and "+est_dt1_1+" "+settle_dt+" "+condition1+" \n"+
				 "      union all"+
				 "      select '대여료' gubun2, '' rent_s_cd, a.rent_l_cd, '' fault_st, '' fault_nm, "+est_amt2+" est_amt from scd_fee a where "+est_dt2+" "+settle_dt+" "+condition2+"\n"+
				 "      union all"+ 
				 "      select '과태료' gubun2, a.rent_s_cd, a.rent_l_cd, a.fault_st, a.fault_nm, "+est_amt3+" est_amt from fine a where "+est_dt3+" "+settle_dt+" "+condition3+"\n"+
				 "      union all"+
				 "      select '면책금' gubun2, b.rent_s_cd, a.rent_l_cd, '' fault_st, '' fault_nm, "+est_amt4+" est_amt from scd_ext se , service a, accident b where se.ext_st = '3' and se.rent_mng_id = a.rent_mng_id and se.rent_l_cd = a.rent_l_cd and se.ext_id = a.serv_id and  a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and "+est_dt4+" "+settle_dt+" "+condition4+"\n"+
				 "      union all"+
				 "      select '휴차료' gubun2, '' rent_s_cd, b.rent_l_cd, '' fault_st, '' fault_nm, "+est_amt5+" est_amt from my_accid a, accident b where a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and "+est_dt5+" "+settle_dt+" "+condition5+"\n"+
				 "      union all"+
				 "      select '위약금' gubun2, '' rent_s_cd, a.rent_l_cd, '' fault_st, '' fault_nm, "+est_amt6+" est_amt from scd_ext a, cls_cont b, cont c where a.ext_st = '4' and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and "+est_dt6+" "+settle_dt+" "+condition6+"\n"+
				 "		union all"+
				 "		select '단기요금' gubun2, a.rent_s_cd, '' rent_l_cd, '' fault_st, '' fault_nm, "+est_amt7+" est_amt from scd_rent a, rent_cont b where a.rent_s_cd=b.rent_s_cd and "+est_dt7+" "+settle_dt+" "+condition7+"\n"+
				 " ) a, "+
				 " cont b, car_reg c, rent_cont d, client e, client f, cont g, users h, car_reg i, "+
			     " (select a.rent_mng_id, a.rent_l_cd, count(0) in_cnt from car_call_in a, cont b where a.out_dt is null and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(b.use_yn,'Y')='Y' and b.car_st<>'4' group by a.rent_mng_id, a.rent_l_cd) j"+
				 " where"+
				 " a.rent_l_cd=b.rent_l_cd(+)"+
				 " and b.car_mng_id=c.car_mng_id(+)"+
				 " and a.rent_s_cd=d.rent_s_cd(+)"+
				 " and b.client_id=e.client_id(+)"+
				 " and d.cust_id=f.client_id(+)"+
				 " and d.sub_l_cd=g.rent_l_cd(+)"+
				 " and d.cust_id=h.user_id(+) and d.car_mng_id=i.car_mng_id(+)"+
				 " and b.rent_mng_id=j.rent_mng_id(+) and b.rent_l_cd=j.rent_l_cd(+)"+
				 " ";

				if(s_kd.equals("1"))		sub_query += " and decode(a.rent_s_cd,'',e.firm_nm,decode(d.cust_st,'1',f.firm_nm,h.user_nm)) like '%"+t_wd+"%'";
				else if(s_kd.equals("4"))	sub_query += " and nvl(c.car_no,i.car_no) like '%"+t_wd+"%'";
				else if(s_kd.equals("8"))	sub_query += " and decode(a.rent_s_cd,'',decode(a.fault_nm,'',b.bus_id2,nvl(a.fault_nm,b.bus_id2)),decode(d.rent_st,'1',d.bus_id,'9',d.bus_id,'12',d.bus_id, '2',nvl(g.bus_id2,d.bus_id),'3',nvl(g.bus_id2,d.bus_id),'10',nvl(g.bus_id2,d.bus_id),'4',d.cust_id,'5',d.cust_id)) = '"+t_wd+"'";


		query = " select"+
				" use_yn, client_id, firm_nm, car_mng_id, car_no, bus_id2, nvl(rent_l_cd,min(rent_s_cd)) rent_l_cd, rent_mng_id, in_cnt,"+
				" min(gubun3) gubun3, min(rent_s_cd) rent_s_cd,"+
				" sum(est_amt) est_amt0,"+
				" sum(decode(gubun2,'선수금',est_amt)) est_amt1,"+
				" sum(decode(gubun2,'대여료',est_amt)) est_amt2,"+
				" sum(decode(gubun2,'과태료',est_amt)) est_amt3,"+
				" sum(decode(gubun2,'면책금',est_amt)) est_amt4,"+
				" sum(decode(gubun2,'휴차료',est_amt)) est_amt5,"+
				" sum(decode(gubun2,'위약금',est_amt)) est_amt6,"+
				" sum(decode(gubun2,'단기요금',est_amt)) est_amt7,"+
				" count(firm_nm) est_su0,"+
				" count(decode(gubun2,'선수금',firm_nm)) est_su1,"+
				" count(decode(gubun2,'대여료',firm_nm)) est_su2,"+
				" count(decode(gubun2,'과태료',firm_nm)) est_su3,"+
				" count(decode(gubun2,'면책금',firm_nm)) est_su4,"+
				" count(decode(gubun2,'휴차료',firm_nm)) est_su5,"+
				" count(decode(gubun2,'위약금',firm_nm)) est_su6,"+
				" count(decode(gubun2,'단기요금',firm_nm)) est_su7"+
				" from"+
				"	 ("+sub_query+")"+
				" where est_amt>0";

		if(gubun4.equals("1"))		query += " and gubun2='대여료'";
		else if(gubun4.equals("2"))	query += " and gubun2='선수금'";
		else if(gubun4.equals("3"))	query += " and gubun2='과태료'";
		else if(gubun4.equals("4"))	query += " and gubun2='면책금'";
		else if(gubun4.equals("5"))	query += " and gubun2='휴차료'";
		else if(gubun4.equals("6"))	query += " and gubun2='위약금'";
		else if(gubun4.equals("7"))	query += " and gubun2='단기요금'";
		
//		if(s_kd.equals("1"))		query += " and firm_nm like '%"+t_wd+"%'";
//		else if(s_kd.equals("4"))	query += " and car_no like '%"+t_wd+"%'";
//		else if(s_kd.equals("8"))	query += " and bus_id2 = '"+t_wd+"'";

		query += " group by use_yn, client_id, firm_nm, car_mng_id, car_no, bus_id2, rent_l_cd, rent_mng_id, in_cnt";

		query += " order by use_yn desc, in_cnt, firm_nm";

	
		try {
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
			System.out.println("[SettleDatabase:getSettleList3]\n"+e);
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


	// 미수금정산 리스트 조회--장기/단기를 같이 조회
	public Vector getSettleList3_fine(String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", sub_query = "";

		String settle_dt = " < to_char(sysdate,'YYYYMMDD')";
		//임의일자
		if(gubun2.equals("6"))	settle_dt = " < to_char(to_date('"+AddUtil.ChangeString(st_dt)+"', 'YYYYMMDD'), 'YYYYMMDD')";

		sub_query = " select"+
				 " decode(a.rent_s_cd,'','장기','단기') gubun1,"+
				 " a.gubun2,"+
				 " decode(d.rent_st,'1','단기대여','9','보험대차','2','정비대차','3','사고대차','4','업무대여','5','업무대여','12','월렌트') gubun3,"+
				 " decode(d.sub_l_cd,'',b.rent_l_cd,d.sub_l_cd) rent_l_cd, "+
				 " decode(d.sub_l_cd,'',b.rent_mng_id,g.rent_mng_id) rent_mng_id,"+
				 " nvl(c.car_mng_id,i.car_mng_id) car_mng_id,"+
				 " decode(a.rent_s_cd,'',e.client_id,decode(d.cust_st,'1',f.client_id,h.user_id)) client_id,"+
				 " decode(a.rent_s_cd,'',b.bus_id2,decode(d.rent_st,'1',d.bus_id,'9',d.bus_id,'12',d.bus_id, '2',nvl(g.bus_id2,d.bus_id),'3',nvl(g.bus_id2,d.bus_id),'10',nvl(g.bus_id2,d.bus_id),'4',d.cust_id,'5',d.cust_id)) bus_id2,"+
				 " decode(a.rent_s_cd,'',e.firm_nm,decode(d.cust_st,'1',f.firm_nm,h.user_nm)) firm_nm,"+
				 " nvl(c.car_no,i.car_no) car_no, nvl(c.car_nm,i.car_nm) car_nm,"+
				 " d.rent_s_cd,"+
				 " a.est_amt,"+
				 " decode(a.rent_s_cd,'',b.use_yn,nvl(g.use_yn,'Y')) use_yn"+
				 " from \n"+
				 " ( "+
				 "      select '선수금' gubun2, '' rent_s_cd, a.rent_l_cd, "+est_amt1+" est_amt from scd_ext a, fee b where a.ext_st in ('0', '1', '2' ) and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st and nvl(a.bill_yn,'Y')='Y' and "+est_dt1+" "+settle_dt+" "+condition1+"\n"+
				 "      union all"+
				 "      select '대여료' gubun2, '' rent_s_cd, a.rent_l_cd, case when r_fee_est_dt "+ settle_dt + " then  (a.fee_s_amt+a.fee_v_amt) else 0 end est_amt from scd_fee a where a.fee_s_amt>0 and a.tm_st2 <> '4' and  a.rc_dt is null and nvl(a.bill_yn,'Y')='Y'\n"+
				 "      union all"+
			//	 "      select '대여료' gubun2, '' rent_s_cd, a.rent_l_cd, "+est_amt2+" est_amt from scd_fee a where "+est_dt2+" "+settle_dt+" "+condition2+"\n"+
			//	 "      union all"+ 
				 "      select '과태료' gubun2, a.rent_s_cd, a.rent_l_cd, "+est_amt3+" est_amt from fine a where "+est_dt3+" "+settle_dt+" "+condition3+"\n"+
				 "      union all"+
				 "      select '면책금' gubun2, b.rent_s_cd, a.rent_l_cd, "+est_amt4+" est_amt from scd_ext se , service a, accident b where se.ext_st = '3' and se.rent_mng_id = a.rent_mng_id and se.rent_l_cd = a.rent_l_cd and se.ext_id = a.serv_id and  a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and "+est_dt4+" "+settle_dt+" "+condition4+"\n"+
				 "      union all"+
				 "      select '휴차료' gubun2, '' rent_s_cd, b.rent_l_cd, "+est_amt5+" est_amt from my_accid a, accident b, cont c where a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and b.rent_l_cd = c.rent_l_cd and b.rent_mng_id = c.rent_mng_id and c.use_yn='N' and "+est_dt5+" "+settle_dt+" "+condition5+"\n"+
				 "      union all"+
				 "      select '위약금' gubun2, '' rent_s_cd, a.rent_l_cd, "+est_amt6+" est_amt from scd_ext a, cls_cont b, cont c where a.ext_st = '4' and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and "+est_dt6+" "+settle_dt+" "+condition6+"\n"+
				 "		union all"+
				 "		select '단기요금' gubun2, a.rent_s_cd, '' rent_l_cd, "+est_amt7+" est_amt from scd_rent a, rent_cont b where a.rent_s_cd=b.rent_s_cd and "+est_dt7+" "+settle_dt+" "+condition7+"\n"+
				 " ) a, cont b, car_reg c, rent_cont d, client e, client f, cont g, users h, car_reg i"+
				 " where"+
				 " b.rent_l_cd=a.rent_l_cd(+)"+
				// " a.rent_l_cd=b.rent_l_cd(+)"+
				 " and b.car_mng_id=c.car_mng_id(+)"+
				 " and a.rent_s_cd=d.rent_s_cd(+)"+
				 " and b.client_id=e.client_id(+)"+
				 " and d.cust_id=f.client_id(+)"+
				 " and d.sub_l_cd=g.rent_l_cd(+)"+
				 " and d.cust_id=h.user_id(+) and d.car_mng_id=i.car_mng_id(+)";

		if(s_kd.equals("1"))		sub_query += " and decode(a.rent_s_cd,'',e.firm_nm,decode(d.cust_st,'1',f.firm_nm,h.user_nm)) like '%"+t_wd+"%'";
		else if(s_kd.equals("4"))	sub_query += " and nvl(c.car_no,i.car_no) like '%"+t_wd+"%'";
		else if(s_kd.equals("8"))	sub_query += " and decode(a.rent_s_cd,'',b.bus_id2,decode(d.rent_st,'1',d.bus_id,'9',d.bus_id,'12',d.bus_id, '2',nvl(g.bus_id2,d.bus_id),'3',nvl(g.bus_id2,d.bus_id),'10',nvl(g.bus_id2,d.bus_id),'4',d.cust_id,'5',d.cust_id)) = '"+t_wd+"'";


		query = " select"+
				" use_yn, client_id, firm_nm, car_mng_id, car_no, bus_id2, nvl(rent_l_cd,min(rent_s_cd)) rent_l_cd, rent_mng_id,"+
				" min(gubun3) gubun3, min(rent_s_cd) rent_s_cd,"+
				" sum(est_amt) est_amt0,"+
				" sum(decode(gubun2,'선수금',est_amt)) est_amt1,"+
				" sum(decode(gubun2,'대여료',est_amt)) est_amt2,"+
				" sum(decode(gubun2,'과태료',est_amt)) est_amt3,"+
				" sum(decode(gubun2,'면책금',est_amt)) est_amt4,"+
				" sum(decode(gubun2,'휴차료',est_amt)) est_amt5,"+
				" sum(decode(gubun2,'위약금',est_amt)) est_amt6,"+
				" sum(decode(gubun2,'단기요금',est_amt)) est_amt7,"+
				" count(firm_nm) est_su0,"+
				" count(decode(gubun2,'선수금',firm_nm)) est_su1,"+
				" count(decode(gubun2,'대여료',firm_nm)) est_su2,"+
				" count(decode(gubun2,'과태료',firm_nm)) est_su3,"+
				" count(decode(gubun2,'면책금',firm_nm)) est_su4,"+
				" count(decode(gubun2,'휴차료',firm_nm)) est_su5,"+
				" count(decode(gubun2,'위약금',firm_nm)) est_su6,"+
				" count(decode(gubun2,'단기요금',firm_nm)) est_su7"+
				" from"+
				"	 ("+sub_query+")"+
				" where  est_amt >=0  ";

		if(gubun4.equals("1"))		query += " and gubun2='대여료'";
		else if(gubun4.equals("2"))	query += " and gubun2='선수금'";
		else if(gubun4.equals("3"))	query += " and gubun2='과태료'";
		else if(gubun4.equals("4"))	query += " and gubun2='면책금'";
		else if(gubun4.equals("5"))	query += " and gubun2='휴차료'";
		else if(gubun4.equals("6"))	query += " and gubun2='위약금'";
		else if(gubun4.equals("7"))	query += " and gubun2='단기요금'";
		
		query += " group by use_yn, client_id, firm_nm, car_mng_id, car_no, bus_id2, rent_l_cd, rent_mng_id";

		query += " order by use_yn desc, firm_nm";
	
		try {
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
			System.out.println("[SettleDatabase:getSettleList3]\n"+e);
			System.out.println("[SettleDatabase:getSettleList3]\n"+query);
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
	
		// 미수금정산 리스트 조회--장기/단기를 같이 조회 _예비배정만)
	public Vector getSettlePreList3(String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", sub_query = "";

		String settle_dt = " < to_char(sysdate,'YYYYMMDD')";
		//임의일자
		if(gubun2.equals("6"))	settle_dt = " < to_char(to_date('"+AddUtil.ChangeString(st_dt)+"', 'YYYYMMDD'), 'YYYYMMDD')";

		sub_query = " select"+
				 " decode(a.rent_s_cd,'','장기','단기') gubun1,"+
				 " a.gubun2,"+
				 " decode(d.rent_st,'1','단기대여','9','보험대차','2','정비대차','3','사고대차','4','업무대여','5','업무대여','12','월렌트') gubun3,"+
				 " decode(d.sub_l_cd,'',b.rent_l_cd,d.sub_l_cd) rent_l_cd, b.rent_mng_id,"+
				 " nvl(c.car_mng_id,i.car_mng_id) car_mng_id,"+
				 " decode(a.rent_s_cd,'',e.client_id,decode(d.cust_st,'1',f.client_id,h.user_id)) client_id,"+
				 " decode(a.rent_s_cd,'',b.mng_id2, b.mng_id2) mng_id2,"+			
				 " decode(a.rent_s_cd,'',e.firm_nm,decode(d.cust_st,'1',f.firm_nm,h.user_nm)) firm_nm,"+
				 " nvl(c.car_no,i.car_no) car_no, nvl(c.car_nm,i.car_nm) car_nm,"+
				 " d.rent_s_cd,"+
				 " a.est_amt,"+
				 " decode(a.rent_s_cd,'',b.use_yn,nvl(g.use_yn,'Y')) use_yn"+
				 " from"+
				 " ( "+
				 "      select '선수금' gubun2, '' rent_s_cd, a.rent_l_cd, "+est_amt1+" est_amt from scd_ext a, fee b where a.ext_st in ('0', '1', '2') and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st and "+est_dt1+" "+settle_dt+" "+condition1+"\n"+
				 "      union all"+
				 "      select '대여료' gubun2, '' rent_s_cd, a.rent_l_cd, "+est_amt2+" est_amt from scd_fee a where "+est_dt2+" "+settle_dt+" "+condition2+"\n"+
				 "      union all"+
				 "      select '과태료' gubun2, a.rent_s_cd, a.rent_l_cd, "+est_amt3+" est_amt from fine a where "+est_dt3+" "+settle_dt+" "+condition3+"\n"+
				 "      union all"+
				 "      select '면책금' gubun2, b.rent_s_cd, a.rent_l_cd, "+est_amt4+" est_amt from service a, accident b,  scd_ext se where  se.ext_st = '3' and se.rent_mng_id = a.rent_mng_id and se.rent_l_cd = a.rent_l_cd and se.ext_id = a.serv_id  and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and "+est_dt4+" "+settle_dt+" "+condition4+"\n"+
				 "      union all"+
				 "      select '휴차료' gubun2, '' rent_s_cd, b.rent_l_cd, "+est_amt5+" est_amt from my_accid a, accident b where a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and "+est_dt5+" "+settle_dt+" "+condition5+"\n"+
				 "      union all"+
				 "      select '위약금' gubun2, '' rent_s_cd, a.rent_l_cd, "+est_amt6+" est_amt from scd_ext a, cls_cont b, cont c where a.ext_st = '4' and a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd and "+est_dt6+" "+settle_dt+" "+condition6+"\n"+
				 "		union all"+
				 "		select '단기요금' gubun2, a.rent_s_cd, '' rent_l_cd, "+est_amt7+" est_amt from scd_rent a, rent_cont b where a.rent_s_cd=b.rent_s_cd and "+est_dt7+" "+settle_dt+" "+condition7+"\n"+
				 " ) a, cont b, car_reg c, rent_cont d, client e, client f, cont g, users h, car_reg i, users h2 "+
				 " where nvl(b.mng_id2, 'xx') <> 'xx' and "+
				 " a.rent_l_cd=b.rent_l_cd(+)"+
				 " and b.car_mng_id=c.car_mng_id(+)"+
				 " and a.rent_s_cd=d.rent_s_cd(+)"+
				 " and b.client_id=e.client_id(+)"+
				 " and d.cust_id=f.client_id(+)"+
				 " and d.sub_l_cd=g.rent_l_cd(+)"+
				 " and d.cust_id=h.user_id(+) and d.car_mng_id=i.car_mng_id(+) and decode(a.rent_s_cd,'',b.mng_id2, b.mng_id2)=h2.user_id ";

		if(s_kd.equals("1"))		sub_query += " and decode(a.rent_s_cd,'',e.firm_nm,decode(d.cust_st,'1',f.firm_nm,h.user_nm)) like '%"+t_wd+"%'";
		else if(s_kd.equals("4"))	sub_query += " and nvl(c.car_no,i.car_no) like '%"+t_wd+"%'";
		else if(s_kd.equals("8"))	sub_query += " and h2.user_nm = '"+t_wd+"'";


		query = " select"+
				" use_yn, client_id, firm_nm, car_mng_id, car_no, mng_id2, nvl(rent_l_cd,min(rent_s_cd)) rent_l_cd, rent_mng_id,"+
				" min(gubun3) gubun3, min(rent_s_cd) rent_s_cd,"+
				" sum(est_amt) est_amt0,"+
				" sum(decode(gubun2,'선수금',est_amt)) est_amt1,"+
				" sum(decode(gubun2,'대여료',est_amt)) est_amt2,"+
				" sum(decode(gubun2,'과태료',est_amt)) est_amt3,"+
				" sum(decode(gubun2,'면책금',est_amt)) est_amt4,"+
				" sum(decode(gubun2,'휴차료',est_amt)) est_amt5,"+
				" sum(decode(gubun2,'위약금',est_amt)) est_amt6,"+
				" sum(decode(gubun2,'단기요금',est_amt)) est_amt7,"+
				" count(firm_nm) est_su0,"+
				" count(decode(gubun2,'선수금',firm_nm)) est_su1,"+
				" count(decode(gubun2,'대여료',firm_nm)) est_su2,"+
				" count(decode(gubun2,'과태료',firm_nm)) est_su3,"+
				" count(decode(gubun2,'면책금',firm_nm)) est_su4,"+
				" count(decode(gubun2,'휴차료',firm_nm)) est_su5,"+
				" count(decode(gubun2,'위약금',firm_nm)) est_su6,"+
				" count(decode(gubun2,'단기요금',firm_nm)) est_su7"+
				" from"+
				"	 ("+sub_query+")"+
				" where est_amt>0";

		if(gubun4.equals("1"))		query += " and gubun2='대여료'";
		else if(gubun4.equals("2"))	query += " and gubun2='선수금'";
		else if(gubun4.equals("3"))	query += " and gubun2='과태료'";
		else if(gubun4.equals("4"))	query += " and gubun2='면책금'";
		else if(gubun4.equals("5"))	query += " and gubun2='휴차료'";
		else if(gubun4.equals("6"))	query += " and gubun2='위약금'";
		else if(gubun4.equals("7"))	query += " and gubun2='단기요금'";
		

		query += " group by use_yn, client_id, firm_nm, car_mng_id, car_no, mng_id2, rent_l_cd, rent_mng_id";

		query += " order by use_yn desc, firm_nm";

	
		try {
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
			System.out.println("[SettleDatabase:getSettlePreList3]\n"+e);
			System.out.println("[SettleDatabase:getSettlePreList3]\n"+query);
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
	
	/**
	 *	미수금 세부내용 - 미수금(미도래포함) & 연체미수금
	 */
	public Hashtable getContSettleCase1(String gubun, String m_id, String l_cd, String client_id, String mode, String gubun2, String st_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "", sub_query = "";
		String settle_dt = "";
		
		if(gubun.equals("1")){
			settle_dt = " >= to_char(sysdate,'YYYYMMDD')";
			if(gubun2.equals("6"))	settle_dt = " >= to_char(to_date('"+AddUtil.ChangeString(st_dt)+"', 'YYYYMMDD'), 'YYYYMMDD')";
		}else if(gubun.equals("2")){
			settle_dt = " < to_char(sysdate,'YYYYMMDD')";
			if(gubun2.equals("6"))	settle_dt = " < to_char(to_date('"+AddUtil.ChangeString(st_dt)+"', 'YYYYMMDD'), 'YYYYMMDD')";
		}

		sub_query = " select"+
				 " decode(a.rent_s_cd,'','장기','단기') gubun1,"+
				 " a.gubun2,"+
				 " decode(d.rent_st,'1','단기대여','9','보험대차','2','정비대차','3','사고대차','10','지연대차','4','업무대여','5','업무대여','12','월렌트') gubun3,"+
				 " decode(d.sub_l_cd,'',b.rent_l_cd,d.sub_l_cd) rent_l_cd,"+
				 " nvl(b.car_mng_id,g.car_mng_id) car_mng_id,"+
				 " decode(a.rent_s_cd,'',e.client_id,decode(d.cust_st,'1',f.client_id,d.cust_id)) client_id,"+
				 " d.rent_s_cd,"+
				 " a.est_amt"+
				 " from"+
				 " ( "+
				 "      select '선수금' gubun2, '' rent_s_cd, a.rent_l_cd, "+est_amt1+" est_amt from scd_ext a, fee b, cont c, cont_etc d where a.ext_st in ('0', '1', '2') and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+) and "+est_dt1_1+" "+settle_dt+" "+condition1+"\n"+
				 "      union all"+
				 "      select '대여료' gubun2, '' rent_s_cd, a.rent_l_cd, "+est_amt2+" est_amt from scd_fee a where "+est_dt2+" "+settle_dt+" "+condition2+"\n"+
				 "      union all"+
				 "      select '과태료' gubun2, a.rent_s_cd, a.rent_l_cd, "+est_amt3+" est_amt from fine a where "+est_dt3+" "+settle_dt+" "+condition3+"\n"+
				 "      union all"+
				 "      select '면책금' gubun2, b.rent_s_cd, a.rent_l_cd, "+est_amt4+" est_amt from service a, accident b, scd_ext se where se.ext_st = '3' and se.rent_mng_id = b.rent_mng_id and se.rent_l_cd=b.rent_l_cd and se.ext_id = a.serv_id and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and "+est_dt4+" "+settle_dt+" "+condition4+"\n"+
				 "      union all"+
			//	 "      select '휴차료'         gubun2, '' rent_s_cd, b.rent_l_cd, "+est_amt5+" est_amt from my_accid a, accident b where a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and "+est_dt5+" "+settle_dt+" "+condition5+"\n"+
				 "      select '휴/대차료'	gubun2, '' rent_s_cd, b.rent_l_cd, "+est_amt5_1+" est_amt from scd_ext se, cont c, my_accid a, accident b where  se.rent_mng_id = c.rent_mng_id and se.rent_l_cd = c.rent_l_cd and se.ext_st = '6' and se.rent_mng_id = b.rent_mng_id and se.rent_l_cd = b.rent_l_cd and substr(se.ext_id,1,6) = a.accid_id  and substr(se.ext_id,7) = to_char(a.seq_no) and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and nvl(a.req_st, '0' ) not in ('0' , '2', '3')   and a.req_dt >= '20100101'    and (se.ext_s_amt+se.ext_v_amt)  >= 30000 and "+est_dt5+" "+settle_dt+" "+condition5_1+"\n"+
				 "      union all"+
				 "      select '위약금' gubun2, '' rent_s_cd, a.rent_l_cd, "+est_amt6+" est_amt from scd_ext a, cls_cont b, cont c where a.ext_st = '4' and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and "+est_dt6+" "+settle_dt+" "+condition6+"\n"+
				 "		union all"+
				 "		select '단기요금' gubun2, a.rent_s_cd, '' rent_l_cd, "+est_amt7+" est_amt from scd_rent a, rent_cont b where a.rent_s_cd=b.rent_s_cd and "+est_dt7+" "+settle_dt+" "+condition7+"\n"+
				 " ) a, cont b, rent_cont d, client e, client f, cont g"+
				 " where"+
				 " a.rent_l_cd=b.rent_l_cd(+)"+
				 " and a.rent_s_cd=d.rent_s_cd(+)"+
				 " and b.client_id=e.client_id(+)"+
				 " and d.cust_id=f.client_id(+)"+
				 " and d.sub_l_cd=g.rent_l_cd(+)";


		query = " select"+
				" sum(est_amt) est_amt0,"+
				" sum(decode(gubun2,'선수금',est_amt)) est_amt1,"+
				" sum(decode(gubun2,'대여료',est_amt)) est_amt2,"+
				" sum(decode(gubun2,'과태료',est_amt)) est_amt3,"+
				" sum(decode(gubun2,'면책금',est_amt)) est_amt4,"+
				" sum(decode(gubun2,'휴/대차료',est_amt)) est_amt5,"+
				" sum(decode(gubun2,'위약금',est_amt)) est_amt6,"+
				" sum(decode(gubun2,'단기요금',est_amt)) est_amt7,"+
				" count(rent_l_cd) est_su0,"+
				" count(decode(gubun2,'선수금',rent_l_cd)) est_su1,"+
				" count(decode(gubun2,'대여료',rent_l_cd)) est_su2,"+
				" count(decode(gubun2,'과태료',rent_l_cd)) est_su3,"+
				" count(decode(gubun2,'면책금',rent_l_cd)) est_su4,"+
				" count(decode(gubun2,'휴/대차료',rent_l_cd)) est_su5,"+
				" count(decode(gubun2,'위약금',rent_l_cd)) est_su6,"+
				" count(decode(gubun2,'단기요금',rent_s_cd)) est_su7"+
				" from"+
				"	 ("+sub_query+")"+
				" where est_amt>0";

		if(mode.equals("client"))	query += " and client_id='"+client_id+"'";
		else						query += " and rent_l_cd='"+l_cd+"'";

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
			System.out.println("[SettleDatabase:getContSettleCase1]"+e);
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
	 *	미수금 세부내용 - 연체료
	 */
	public Hashtable getContSettleCase2(String gubun, String m_id, String l_cd, String client_id, String mode, String gubun2, String st_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "", sub_query = "";
		String settle_dt = "";
		
		settle_dt = " < to_char(sysdate,'YYYYMMDD')";
		if(gubun2.equals("6"))	settle_dt = " < to_char(to_date('"+AddUtil.ChangeString(st_dt)+"', 'YYYYMMDD'), 'YYYYMMDD')";

		sub_query = " select"+
				 " decode(a.rent_s_cd,'','장기','단기') gubun1,"+
				 " a.gubun2,"+
				 " decode(d.rent_st,'1','단기대여','9','보험대차','2','정비대차','3','사고대차','10','지연대차','4','업무대여','5','업무대여','12','월렌트') gubun3,"+
				 " a.rent_mng_id, decode(d.sub_l_cd,'',b.rent_l_cd,d.sub_l_cd) rent_l_cd,"+
				 " nvl(b.car_mng_id,g.car_mng_id) car_mng_id,"+
				 " decode(a.rent_s_cd,'',e.client_id,decode(d.cust_st,'1',f.client_id,d.cust_id)) client_id,"+
				 " d.rent_s_cd,"+
				 " a.est_amt"+
				 " from"+
				 " ( "+
				 "      select '선수금' gubun2, '' rent_s_cd, a.rent_l_cd, a.rent_mng_id, a.dly_amt est_amt from scd_ext a, fee b, cont c where a.ext_st in ('0', '1', '2') and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"+
				 "      union all"+
				 "      select '대여료' gubun2, '' rent_s_cd, a.rent_l_cd, a.rent_mng_id, a.dly_fee est_amt from scd_fee a where a.dly_fee > 0 and nvl(a.bill_yn,'Y')='Y'\n"+// where  
				 "      union all"+
				 "      select '과태료' gubun2, a.rent_s_cd, a.rent_l_cd, a.rent_mng_id,  a.dly_amt est_amt from fine a\n"+
				 "      union all"+
				 "      select '면책금' gubun2, b.rent_s_cd, a.rent_l_cd, a.rent_mng_id,  se.dly_amt est_amt from scd_ext se,  service a, accident b where se.ext_st = '3' and se.rent_mng_id = a.rent_mng_id and se.rent_l_cd= a.rent_l_cd and se.ext_id = a.serv_id and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id\n"+
				 "      union all"+
				 "      select '휴차료' gubun2, '' rent_s_cd, b.rent_l_cd, b.rent_mng_id,  a.dly_amt est_amt from my_accid a, accident b where a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id\n"+
				 "      union all"+
				 "      select '위약금' gubun2, '' rent_s_cd, a.rent_l_cd, a.rent_mng_id,  a.dly_amt est_amt from scd_ext a, cls_cont b where a.ext_st = '4' and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd=b.rent_l_cd\n"+
				 "		union all"+
				 "		select '단기요금' gubun2, a.rent_s_cd, '' rent_l_cd, '' rent_mng_id,  a.dly_amt est_amt from scd_rent a, rent_cont b where a.rent_s_cd=b.rent_s_cd\n"+
				 "      union all"+
				 "      select '연체료' gubun2, '' rent_s_cd, a.rent_l_cd, a.rent_mng_id, a.pay_amt est_amt from scd_dly a\n"+
				 " ) a, cont b, rent_cont d, client e, client f, cont g"+
				 " where"+
				 " a.rent_mng_id=b.rent_mng_id(+) "+
				 " and a.rent_s_cd=d.rent_s_cd(+)"+
				 " and b.client_id=e.client_id(+)"+
				 " and d.cust_id=f.client_id(+)"+
				 " and d.sub_l_cd=g.rent_l_cd(+)";

		if(mode.equals("client"))	sub_query += " and decode(a.rent_s_cd,'',e.client_id,decode(d.cust_st,'1',f.client_id,d.cust_id)) ='"+client_id+"'";
		else						sub_query += " and a.rent_l_cd='"+l_cd+"'";

		query = " select"+
				" sum(est_amt) est_amt0,"+
				" sum(decode(gubun2,'선수금',0)) est_amt1,"+
				" sum(decode(gubun2,'대여료',decode(substr(rent_l_cd,8,1),'S',0,est_amt))) est_amt2,"+
				" sum(decode(gubun2,'과태료',0)) est_amt3,"+
				" sum(decode(gubun2,'면책금',0)) est_amt4,"+
				" sum(decode(gubun2,'휴차료',0)) est_amt5,"+
				" sum(decode(gubun2,'위약금',0)) est_amt6,"+
				" sum(decode(gubun2,'단기요금',0)) est_amt7,"+
				" sum(decode(gubun2,'연체료',decode(substr(rent_l_cd,8,1),'S',0,est_amt))) est_amt8,"+
				" count(rent_l_cd) est_su0,"+
				" count(decode(gubun2,'선수금','')) est_su1,"+
				" count(decode(gubun2,'대여료',rent_l_cd)) est_su2,"+
				" count(decode(gubun2,'과태료','')) est_su3,"+
				" count(decode(gubun2,'면책금','')) est_su4,"+
				" count(decode(gubun2,'휴차료','')) est_su5,"+
				" count(decode(gubun2,'위약금','')) est_su6,"+
				" count(decode(gubun2,'단기요금','')) est_su7,"+
				" count(decode(gubun2,'연체료',decode(substr(rent_l_cd,8,1),'S','',rent_l_cd))) est_su8"+
				" from"+
				"	 ("+sub_query+")"+
				" where est_amt>0";

		

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
			System.out.println("[SettleDatabase:getContSettleCase2]"+e);
			System.out.println("[SettleDatabase:getContSettleCase2]"+query);
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
	 *	미수금 세부내용 - 대손처리
	 */
	public Hashtable getContSettleCase3(String gubun, String m_id, String l_cd, String client_id, String mode, String gubun2, String st_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "", sub_query = "";
		String settle_dt = "";
		
		settle_dt = " < to_char(sysdate,'YYYYMMDD')";
		if(gubun2.equals("6"))	settle_dt = " < to_char(to_date('"+AddUtil.ChangeString(st_dt)+"', 'YYYYMMDD'), 'YYYYMMDD')";

		sub_query = " select \n"+
				 " decode(a.rent_s_cd,'','장기','단기') gubun1, \n"+
				 " a.gubun2, \n"+
				 " decode(d.rent_st,'1','단기대여','9','보험대차','2','정비대차','3','사고대차','10','지연대차','4','업무대여','5','업무대여','12','월렌트') gubun3, \n"+
				 " decode(d.sub_l_cd,'',b.rent_l_cd,d.sub_l_cd) rent_l_cd, \n"+
				 " nvl(b.car_mng_id,g.car_mng_id) car_mng_id, \n"+
				 " decode(a.rent_s_cd,'',e.client_id,decode(d.cust_st,'1',f.client_id,d.cust_id)) client_id, \n"+
				 " d.rent_s_cd, \n"+
				 " a.est_amt \n"+
				 " from \n"+
				 " (  \n"+
				 "      select '선수금' gubun2, '' rent_s_cd, a.rent_l_cd, "+est_amt1+" est_amt from scd_ext a, fee b, cont c, cont_etc d where a.ext_st in ('0', '1', '2') and  a.rent_mng_id = b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+) and "+est_dt1_1+" "+settle_dt+" "+bad_debt1+"\n"+
				 "      union all \n"+
				 "      select '대여료' gubun2, '' rent_s_cd, a.rent_l_cd, "+est_amt2+" est_amt from scd_fee a, cont b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.use_yn='Y' and "+est_dt2+" "+settle_dt+" "+bad_debt2+"\n"+
				 "      union all \n"+
				 "      select '과태료' gubun2, a.rent_s_cd, a.rent_l_cd, "+est_amt3+" est_amt from fine a where "+est_dt3+" "+settle_dt+" "+bad_debt3+"\n"+
				 "      union all \n"+
				 "      select '면책금' gubun2, b.rent_s_cd, a.rent_l_cd, "+est_amt4+" est_amt from service a, accident b , scd_ext se, cont d where se.ext_st = '3' and se.rent_mng_id = a.rent_mng_id and se.rent_l_cd = a.rent_l_cd and se.ext_id = a.serv_id and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd and d.use_yn='Y' and "+est_dt4+" "+settle_dt+" "+bad_debt4+"\n"+
				 "      union all \n"+
				 "      select '휴차료' gubun2, '' rent_s_cd, b.rent_l_cd, "+est_amt5+" est_amt from my_accid a, accident b where a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and "+est_dt5+" "+settle_dt+" "+bad_debt5+"\n"+
				 "      union all \n"+
				 "      select '위약금' gubun2, '' rent_s_cd, a.rent_l_cd, "+est_amt6+" est_amt from scd_ext a, cls_cont b, cont c where a.ext_st = '4'  and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and "+est_dt6+" "+settle_dt+" "+bad_debt6+"\n"+
				 "		union all \n"+
				 "		select '단기요금' gubun2, a.rent_s_cd, '' rent_l_cd, "+est_amt7+" est_amt from scd_rent a, rent_cont b where a.rent_s_cd=b.rent_s_cd and "+est_dt7+" "+settle_dt+" "+bad_debt7+"\n"+
				 " ) a, cont b, rent_cont d, client e, client f, cont g \n"+
				 " where \n"+
				 " a.rent_l_cd=b.rent_l_cd(+) \n"+
				 " and a.rent_s_cd=d.rent_s_cd(+) \n"+
				 " and b.client_id=e.client_id(+) \n"+
				 " and d.cust_id=f.client_id(+) \n"+
				 " and d.sub_l_cd=g.rent_l_cd(+) \n";


		query = " select \n"+
				" sum(est_amt) est_amt0, \n"+
				" sum(decode(gubun2,'선수금',est_amt)) est_amt1, \n"+
				" sum(decode(gubun2,'대여료',est_amt)) est_amt2, \n"+
				" sum(decode(gubun2,'과태료',est_amt)) est_amt3, \n"+
				" sum(decode(gubun2,'면책금',est_amt)) est_amt4, \n"+
				" sum(decode(gubun2,'휴차료',est_amt)) est_amt5, \n"+
				" sum(decode(gubun2,'위약금',est_amt)) est_amt6, \n"+
				" sum(decode(gubun2,'단기요금',est_amt)) est_amt7, \n"+
				" count(rent_l_cd) est_su0, \n"+
				" count(decode(gubun2,'선수금',rent_l_cd)) est_su1, \n"+
				" count(decode(gubun2,'대여료',rent_l_cd)) est_su2, \n"+
				" count(decode(gubun2,'과태료',rent_l_cd)) est_su3, \n"+
				" count(decode(gubun2,'면책금',rent_l_cd)) est_su4, \n"+
				" count(decode(gubun2,'휴차료',rent_l_cd)) est_su5, \n"+
				" count(decode(gubun2,'위약금',rent_l_cd)) est_su6, \n"+
				" count(decode(gubun2,'단기요금',rent_l_cd)) est_su7 \n"+
				" from \n"+
				"	 ("+sub_query+") \n"+
				" where est_amt>0 \n";

		if(mode.equals("client"))	query += " and client_id='"+client_id+"'";
		else						query += " and rent_l_cd='"+l_cd+"'";

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
			System.out.println("[SettleDatabase:getContSettleCase3]"+e);
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
	 *	미수금 세부내용 - 계약정보
	 */
	public Hashtable getContSettleInfo(String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "", sub_query = "";

		query = " select"+
				" a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.bus_id2, a.client_id, b.firm_nm, b.client_nm, a.car_st, "+
				" c.car_no, c.init_reg_dt, c.car_nm, e.car_name,"+
				" decode(g.rent_way,'1','일반식','2','맞춤식','3','기본식') rent_way, g.con_mon, g.rent_st,"+
				" g.rent_start_dt, nvl(i.cls_dt,g.rent_end_dt) rent_end_dt, (f.fee_s_amt+f.fee_v_amt) fee_amt,"+
				" h.pp_amt1, h.pp_amt2, h.pp_amt3, i.cls_cau, i.cls_dt, i.cls_st, "+
			 	" decode(i.cls_st, '1','계약만료','2','중도해지','3','영업소변경','4','차종변경','5','계약승계','6','매각','7','출고전해지','8','매입옵션','9','폐차','10','개시전해지') CLS_ST_NM,"+
				" trunc(months_between( nvl(to_date(i.cls_dt,'YYYY-MM-DD'),sysdate)+1, nvl(to_date(g.rent_start_dt,'YYYY-MM-DD'),sysdate) ),0) u_mon,"+
				" trunc(nvl(to_date(i.cls_dt,'YYYY-MM-DD'),sysdate)+1-add_months(to_date(g.rent_start_dt,'YYYYMMDD'),trunc(months_between( nvl(to_date(i.cls_dt,'YYYY-MM-DD'),sysdate)+1, nvl(to_date(g.rent_start_dt,'YYYY-MM-DD'),sysdate) ),0)),0) u_day"+
				" from cont a, client b, car_reg c, car_etc d, car_nm e, fee f, cls_cont i,"+
				" (select rent_l_cd, max(rent_way) rent_way, sum(con_mon) con_mon, max(to_number(rent_st)) rent_st, min(rent_start_dt) rent_start_dt, max(rent_end_dt) rent_end_dt from fee group by rent_l_cd) g,"+
				" (select rent_l_cd, sum(decode(ext_st,'0',ext_s_amt+ext_v_amt)) pp_amt1, sum(decode(ext_st,'1',ext_s_amt+ext_v_amt)) pp_amt2, sum(decode(ext_st,'2',ext_s_amt+ext_v_amt)) pp_amt3 from scd_ext where ext_st in ('0', '1', '2') and  ext_tm='1' group by rent_l_cd) h"+
				" where "+
				" a.rent_l_cd=?"+
				" and a.client_id=b.client_id and a.car_mng_id=c.car_mng_id(+)"+
				" and a.rent_l_cd=d.rent_l_cd and d.car_id=e.car_id and d.car_seq=e.car_seq"+
				" and a.rent_l_cd=f.rent_l_cd"+
				" and f.rent_l_cd=g.rent_l_cd(+) and f.rent_st=g.rent_st(+)"+
				" and a.rent_l_cd=h.rent_l_cd(+)"+
				" and a.rent_l_cd=i.rent_l_cd(+)";

		try {
			pstmt = conn.prepareStatement(query);
            pstmt.setString(1, rent_l_cd);
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
			System.out.println("[SettleDatabase:getContSettleInfo]"+e);
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
	 * 단기요금 미수 스케줄
	 */
	public Vector getRentList(String m_id, String l_cd, String client_id, String mode, String gubun2, String st_dt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String settle_dt = "";
		
		settle_dt = " < to_char(sysdate,'YYYYMMDD')";
		if(gubun2.equals("6"))	settle_dt = " < to_char(to_date('"+AddUtil.ChangeString(st_dt)+"', 'YYYYMMDD'), 'YYYYMMDD')";

		String query = "";
		query = " select "+
				" a.rent_s_cd rent_l_cd, b.car_mng_id, a.tm, c.car_no, decode(b.rent_st,'1','단기대여','9','보험대차','12','월렌트') st, a.est_dt, a.rent_s_amt s_amt, a.rent_v_amt v_amt, (a.rent_s_amt+a.rent_v_amt) amt, a.dly_days, a.dly_amt"+
				" from scd_rent a, rent_cont b, car_reg c"+
				" where a.rent_s_cd=b.rent_s_cd and b.car_mng_id=c.car_mng_id and "+est_dt7+" "+settle_dt+" "+condition7+"";

		if(mode.equals("client"))	query += " and b.cust_id='"+client_id+"'";
		else						query += " and a.rent_s_cd='"+l_cd+"'";

		query += " order by a.rent_s_cd, a.est_dt";

		try {
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
			System.out.println("[SettleDatabase:getRentList]\n"+e);
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

	/**
	 *	미수금현황 리스트-채권1 )
	 */
	public Vector getStatSettleList2(String brch_id, String dept_id, String save_dt, String eff_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String magni = "";//5배할증 *5 -> 20131021 할증 해제
		String settle_dt = "to_char(sysdate,'YYYYMMDD')";

		if(save_dt.equals("")){

			query = " select "+
					"	b.br_id, b.dept_id, a.bus_id2, c.br_nm, d.nm, b.user_nm, b.user_pos,"+
					"	a.tot_amt, nvl(a.three_amt,0) as three_amt, nvl(a.dly_amt,0) as amt, a.dly_su as su, "+
					"	a.dly_per as per1, '' per2, nvl(e.per1,0) per_0405"+
					" from \n"+
					" ("+
					"	select"+
					"	bus_id2, sum(tot_amt) tot_amt, sum(dly_amt) dly_amt, sum(dly_su) dly_su, sum(three_amt) three_amt,"+
					"	nvl(trunc((sum(dly_amt)/sum(tot_amt)*100),2),0) dly_per"+
					"	from \n"+
					"	("+
					"		select '선수금' gubun2, c.bus_id2, sum("+est_amt1+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt1+",'YYYYMMDD')-sysdate),-1,decode("+est_dt1+","+settle_dt+",0,"+est_amt1+"))) dly_amt, count(decode(sign(to_date("+est_dt1+",'YYYYMMDD')-sysdate),-1,decode("+est_dt1+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_ext a, fee b, cont c"+
					"		where a.ext_st in ('0', '1', '2' ) and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd=c.rent_l_cd "+condition1+""+
					"		group by c.bus_id2 \n"+
					"		union all"+
					"		select '대여료' gubun2, b.bus_id2, sum("+est_amt2+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt2+",'YYYYMMDD')-sysdate),-1,decode("+est_dt2+","+settle_dt+",0,"+est_amt2+"))) dly_amt, count(decode(sign(to_date("+est_dt2+",'YYYYMMDD')-sysdate),-1,decode("+est_dt2+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_fee a, cont b"+
					"		where a.rent_l_cd=b.rent_l_cd "+condition2+""+
					"		group by b.bus_id2 \n"+
//					"		union all"+//부산-직전3개월인 총받을어음
//					"		select '대여료' gubun2, b.bus_id2, 0 tot_amt, sum("+est_amt2+") three_amt, 0 dly_amt, 0 dly_su"+
//					"		from scd_fee a, cont b, users c,"+
//					"			(select a.rent_mng_id, a.rent_l_cd"+
//					"				from scd_fee a, cont b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.fee_tm > decode(sign(to_date('20080514','YYYYMMDD')-to_date(b.rent_dt,'YYYYMMDD')),1,'3','4') and a.rc_yn='0' and a.r_fee_est_dt < to_char(sysdate,'YYYYMMDD')"+//3회차이후연체
//					"				group by a.rent_mng_id, a.rent_l_cd) e,"+
//					"			(select a.rent_mng_id, a.rent_l_cd"+
//					"				from scd_fee a, cont b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.fee_tm = decode(sign(to_date('20080514','YYYYMMDD')-to_date(b.rent_dt,'YYYYMMDD')),1,'3','4') and a.rc_yn='0' and a.r_fee_est_dt >= to_char(sysdate,'YYYYMMDD')"+//3회차 미연체
//					"			    group by a.rent_mng_id, a.rent_l_cd) f"+
//					"		where a.rent_l_cd=b.rent_l_cd and b.bus_id2=c.user_id and c.br_id<>'S1'"+
//					"       and a.rent_l_cd=e.rent_l_cd(+)"+
//					"		and a.rent_l_cd=f.rent_l_cd(+) "+
//					"		and (e.rent_l_cd is not null or f.rent_l_cd is not null) "+
//							condition2+""+
//					"		group by b.bus_id2 \n"+
					"		union all"+
					"		select '과태료' gubun2, decode(a.rent_s_cd,'', decode(a.fault_st,'2',nvl(a.fault_nm,b.bus_id2),b.bus_id2), decode(c.rent_st,'1',c.bus_id,'9',c.bus_id, '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) bus_id2, sum("+est_amt3+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt3+",'YYYYMMDD')-sysdate),-1,decode("+est_dt3+","+settle_dt+",0,"+est_amt3+")))"+magni+" dly_amt, count(decode(sign(to_date("+est_dt3+",'YYYYMMDD')-sysdate),-1,decode("+est_dt1+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from fine a, cont b, rent_cont c, cont d"+
	//				"		where a.rent_l_cd=b.rent_l_cd and a.rent_s_cd=c.rent_s_cd(+) and c.sub_l_cd=d.rent_l_cd(+) 	and nvl(a.rec_plan_dt,nvl(a.dem_dt,a.paid_end_dt))  <= to_char(sysdate,'YYYYMMDD') "+condition3+""+
					"		where a.rent_l_cd=b.rent_l_cd and a.rent_s_cd=c.rent_s_cd(+) and c.sub_l_cd=d.rent_l_cd(+)  "+condition3+""+
					"		group by decode(a.rent_s_cd,'',decode(a.fault_st,'2',nvl(a.fault_nm,b.bus_id2),b.bus_id2), decode(c.rent_st,'1',c.bus_id,'9',c.bus_id, '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) \n"+
					"		union all"+
					"		select '면책금' gubun2, decode(e.rent_s_cd,'',b.bus_id2, decode(c.rent_st,'1',c.bus_id,'9',c.bus_id, '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) bus_id2, sum("+est_amt4+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt4+",'YYYYMMDD')-sysdate),-1,decode("+est_dt4+","+settle_dt+",0,"+est_amt4+")))"+magni+" dly_amt, count(decode(sign(to_date("+est_dt4+",'YYYYMMDD')-sysdate),-1,decode("+est_dt4+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from service a, accident e, cont b, rent_cont c, cont d, scd_ext se"+
					"		where se.ext_st = '3' and se.rent_mng_id = a.rent_mng_id and se.rent_l_cd = a.rent_l_cd and se.ext_id = a.serv_id and a.car_mng_id=e.car_mng_id and a.accid_id=e.accid_id and se.rent_mng_id=b.rent_mng_id and se.rent_l_cd=b.rent_l_cd and e.rent_s_cd=c.rent_s_cd(+) and c.sub_l_cd=d.rent_l_cd(+) "+condition4+""+
					"		group by decode(e.rent_s_cd,'',b.bus_id2, decode(c.rent_st,'1',c.bus_id,'9',c.bus_id, '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) \n"+
//					"		select '면책금' gubun2, decode(e.rent_s_cd,'',b.bus_id2, decode(c.rent_st,'1',c.bus_id,'9',c.bus_id,'2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) bus_id2, sum("+est_amt4+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt4+",'YYYYMMDD')-sysdate),-1,decode("+est_dt4+","+settle_dt+",0,"+est_amt4+")))"+magni+" dly_amt, count(decode(sign(to_date("+est_dt4+",'YYYYMMDD')-sysdate),-1,decode("+est_dt4+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
//					"		from service a, accident e, cont b, rent_cont c, cont d"+
//					"		where a.car_mng_id=e.car_mng_id and a.accid_id=e.accid_id and a.rent_l_cd=b.rent_l_cd and e.rent_s_cd=c.rent_s_cd(+) and c.sub_l_cd=d.rent_l_cd(+) "+condition4+""+
//					"		group by decode(e.rent_s_cd,'',b.bus_id2, decode(c.rent_st,'1',c.bus_id,'9',c.bus_id,'2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id))"+
//							휴차료는 사원별 미수금 관리 제외				
//					"		union all"+
//					"		select '휴차료' gubun2, c.bus_id2, sum("+est_amt5+") tot_amt, sum(decode(sign(to_date("+est_dt5+",'YYYYMMDD')-sysdate),-1,"+est_amt5+")) dly_amt, count(decode(sign(to_date("+est_dt5+",'YYYYMMDD')-sysdate),-1,a.car_mng_id)) dly_su"+
//					" 		from my_accid a, accident b, cont c"+
//					"		where a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and b.rent_l_cd=c.rent_l_cd "+condition5+""+
//					"		group by c.bus_id2"+
					"		union all"+
					"		select '위약금' gubun2, c.bus_id2, sum("+est_amt6+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt6+",'YYYYMMDD')-sysdate),-1,decode("+est_dt6+","+settle_dt+",0,"+est_amt6+"))) dly_amt, count(decode(sign(to_date("+est_dt6+",'YYYYMMDD')-sysdate),-1,decode("+est_dt6+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_ext a, cls_cont b, cont c"+
					"		where a.ext_st = '4' and a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd "+condition6+""+
					"		group by c.bus_id2 \n"+
					"		union all"+
					"		select '단기요금' gubun2, b.bus_id bus_id2, sum("+est_amt7+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt7+",'YYYYMMDD')-sysdate),-1,decode("+est_dt7+","+settle_dt+",0,"+est_amt7+"))) dly_amt, count(decode(sign(to_date("+est_dt7+",'YYYYMMDD')-sysdate),-1,decode("+est_dt7+","+settle_dt+",'',a.rent_s_cd))) dly_su"+
					"		from scd_rent a, rent_cont b"+
					"		where a.rent_s_cd=b.rent_s_cd "+condition7+""+
					"		group by b.bus_id \n"+
					"	)group by bus_id2 \n"+
					" ) a, users b, branch c, (select * from code where c_st='0002') d, (select * from stat_settle where save_dt='"+eff_dt+"') e \n"+
					" where b.user_id <> '000001' and a.bus_id2=b.user_id and b.br_id=c.br_id and b.dept_id=d.code and a.bus_id2=e.bus_id2(+)";

			//if(!brch_id.equals("")) query += " and b.br_id='"+brch_id+"'";
			//if(!dept_id.equals("")) query += " and b.dept_id='"+dept_id+"'";

			//query += " and b.loan_st='1'";

			//query += " and b.enter_dt < '20070101'";
			query += " order by a.dly_per, a.dly_amt";

		}else{

			query = " select a.*, 0 tot_su, c.br_id, c.dept_id, e.per1 as per_0405 from stat_settle a, users c, (select bus_id2, per1 from stat_settle where save_dt='"+eff_dt+"') e where a.bus_id2=c.user_id and a.save_dt='"+save_dt+"' and a.bus_id2=e.bus_id2(+)";

//			if(!brch_id.equals("")) query += " and c.br_id='"+brch_id+"'";
//			if(!dept_id.equals("")) query += " and c.dept_id='"+dept_id+"'";

			//query += " and (c.dept_id='0002' or c.user_id in ('000012','000034'))";

			query += " and c.loan_st='1' and c.user_id not in ('000079')";

//			query += " and c.enter_dt < '20070601'";
			query += " order by a.seq , a.amt desc";
		}

		String query2 = " select '선수금' gubun2, c.bus_id2, sum("+est_amt1+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt1+",'YYYYMMDD')-sysdate),-1,decode("+est_dt1+","+settle_dt+",0,"+est_amt1+"))) dly_amt, count(decode(sign(to_date("+est_dt1+",'YYYYMMDD')-sysdate),-1,decode("+est_dt1+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_ext a, fee b, cont c"+
					"		where a.ext_st in ('0', '1', '2' ) and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd=c.rent_l_cd "+condition1+""+
					"		group by c.bus_id2 \n"+
					"		union all"+
					"		select '대여료' gubun2, b.bus_id2, sum("+est_amt2+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt2+",'YYYYMMDD')-sysdate),-1,decode("+est_dt2+","+settle_dt+",0,"+est_amt2+"))) dly_amt, count(decode(sign(to_date("+est_dt2+",'YYYYMMDD')-sysdate),-1,decode("+est_dt2+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_fee a, cont b"+
					"		where a.rent_l_cd=b.rent_l_cd "+condition2+""+
					"		group by b.bus_id2 \n"+
//					"		union all"+//부산-직전3개월인 총받을어음
//					"		select '대여료' gubun2, b.bus_id2, 0 tot_amt, sum("+est_amt2+") three_amt, 0 dly_amt, 0 dly_su"+
//					"		from scd_fee a, cont b, users c,"+
//					"			(select a.rent_mng_id, a.rent_l_cd"+
//					"				from scd_fee a, cont b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.fee_tm > decode(sign(to_date('20080514','YYYYMMDD')-to_date(b.rent_dt,'YYYYMMDD')),1,'3','4') and a.rc_yn='0' and a.r_fee_est_dt < to_char(sysdate,'YYYYMMDD')"+//3회차이후연체
//					"				group by a.rent_mng_id, a.rent_l_cd) e,"+
//					"			(select a.rent_mng_id, a.rent_l_cd"+
//					"				from scd_fee a, cont b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.fee_tm = decode(sign(to_date('20080514','YYYYMMDD')-to_date(b.rent_dt,'YYYYMMDD')),1,'3','4') and a.rc_yn='0' and a.r_fee_est_dt >= to_char(sysdate,'YYYYMMDD')"+//3회차 미연체
//					"			    group by a.rent_mng_id, a.rent_l_cd) f"+
//					"		where a.rent_l_cd=b.rent_l_cd and b.bus_id2=c.user_id and c.br_id<>'S1'"+
//					"       and a.rent_l_cd=e.rent_l_cd(+)"+
//					"		and a.rent_l_cd=f.rent_l_cd(+) "+
//					"		and (e.rent_l_cd is not null or f.rent_l_cd is not null) "+
//							condition2+""+
//					"		group by b.bus_id2 \n"+
					"		union all"+
					"		select '과태료' gubun2, decode(a.rent_s_cd,'',decode(a.fault_st,'2',nvl(a.fault_nm,b.bus_id2),b.bus_id2), decode(c.rent_st,'1',c.bus_id,'9',c.bus_id, '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) bus_id2, sum("+est_amt3+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt3+",'YYYYMMDD')-sysdate),-1,decode("+est_dt3+","+settle_dt+",0,"+est_amt3+")))"+magni+" dly_amt, count(decode(sign(to_date("+est_dt3+",'YYYYMMDD')-sysdate),-1,decode("+est_dt1+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from fine a, cont b, rent_cont c, cont d"+
					"		where a.rent_l_cd=b.rent_l_cd and a.rent_s_cd=c.rent_s_cd(+) and c.sub_l_cd=d.rent_l_cd(+)  "+condition3+""+
					"		group by decode(a.rent_s_cd,'',decode(a.fault_st,'2',nvl(a.fault_nm,b.bus_id2),b.bus_id2), decode(c.rent_st,'1',c.bus_id,'9',c.bus_id, '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) \n"+
					"		union all"+
					"		select '면책금' gubun2, decode(e.rent_s_cd,'',b.bus_id2, decode(c.rent_st,'1',c.bus_id,'9',c.bus_id, '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) bus_id2, sum("+est_amt4+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt4+",'YYYYMMDD')-sysdate),-1,decode("+est_dt4+","+settle_dt+",0,"+est_amt4+")))"+magni+" dly_amt, count(decode(sign(to_date("+est_dt4+",'YYYYMMDD')-sysdate),-1,decode("+est_dt4+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from service a, accident e, cont b, rent_cont c, cont d, scd_ext se"+
					"		where se.ext_st = '3' and se.rent_mng_id = a.rent_mng_id and se.rent_l_cd = a.rent_l_cd and se.ext_id = a.serv_id and a.car_mng_id=e.car_mng_id and a.accid_id=e.accid_id and se.rent_mng_id=b.rent_mng_id and se.rent_l_cd=b.rent_l_cd and e.rent_s_cd=c.rent_s_cd(+) and c.sub_l_cd=d.rent_l_cd(+) "+condition4+""+
					"		group by decode(e.rent_s_cd,'',b.bus_id2, decode(c.rent_st,'1',c.bus_id,'9',c.bus_id, '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) \n"+
					"		union all"+
					"		select '위약금' gubun2, c.bus_id2, sum("+est_amt6+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt6+",'YYYYMMDD')-sysdate),-1,decode("+est_dt6+","+settle_dt+",0,"+est_amt6+"))) dly_amt, count(decode(sign(to_date("+est_dt6+",'YYYYMMDD')-sysdate),-1,decode("+est_dt6+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_ext a, cls_cont b, cont c"+
					"		where a.ext_st = '4' and a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd "+condition6+""+
					"		group by c.bus_id2 \n"+
					"		union all"+
					"		select '단기요금' gubun2, b.bus_id bus_id2, sum("+est_amt7+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt7+",'YYYYMMDD')-sysdate),-1,decode("+est_dt7+","+settle_dt+",0,"+est_amt7+"))) dly_amt, count(decode(sign(to_date("+est_dt7+",'YYYYMMDD')-sysdate),-1,decode("+est_dt7+","+settle_dt+",'',a.rent_s_cd))) dly_su"+
					"		from scd_rent a, rent_cont b"+
					"		where a.rent_s_cd=b.rent_s_cd "+condition7+""+
					"		group by b.bus_id \n"+
					"	";


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			while(rs.next())
			{
				IncomingSBean fee = new IncomingSBean();
				fee.setGubun(rs.getString("bus_id2"));
				fee.setBr_id(rs.getString("br_id"));
				fee.setDept_id(rs.getString("dept_id"));
				fee.setTot_amt1(rs.getString("tot_amt"));
				fee.setTot_su2(rs.getString("su"));
				fee.setTot_amt2(rs.getString("amt"));
				fee.setTot_su3(rs.getString("per1"));
				fee.setTot_su4(rs.getString("per2")==null?"":rs.getString("per2"));
				fee.setTot_su5(rs.getString("per_0405")==null?"":rs.getString("per_0405"));
				fee.setTot_amt3(rs.getString("three_amt")==null?"":rs.getString("three_amt"));
				vt.add(fee);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[SettleDatabase:getStatSettleList2]"+e);
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
	 *	미수금현황 리스트- 영업부 채권캠페인 받을어음 변수(1억5천)에 따라 캠페인대상조절.
	 *	2006.03.28. Yongsoon Kwon
	 */
	public Vector getStatSettleList3(String brch_id, String dept_id, String save_dt, String eff_dt, String dly_bus7)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String magni = "";//5배할증 *5 -> 20131021 할증해제
		String settle_dt = "to_char(sysdate,'YYYYMMDD')";

		if(save_dt.equals("")){

			query = " select b.br_id, b.dept_id, a.bus_id2, c.br_nm, d.nm, b.user_nm, b.user_pos, a.tot_amt, nvl(a.dly_amt,0) as amt, a.dly_su as su, a.dly_per as per1, '' per2, nvl(e.per1,0) per_0405"+
					" from"+
					" ("+
					"	select"+
					"	bus_id2, sum(tot_amt) tot_amt, sum(dly_amt) dly_amt, sum(dly_su) dly_su,"+
					"	nvl(trunc((sum(dly_amt)/sum(tot_amt)*100),2),0) dly_per"+
					"	from"+
					"	("+
					"		select '선수금' gubun2, c.bus_id2, sum("+est_amt1+") tot_amt, sum(decode(sign(to_date("+est_dt1+",'YYYYMMDD')-sysdate),-1,decode("+est_dt1+","+settle_dt+",0,"+est_amt1+"))) dly_amt, count(decode(sign(to_date("+est_dt1+",'YYYYMMDD')-sysdate),-1,decode("+est_dt1+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_ext a, fee b, cont c"+
					"		where a.ext_st in ('0', '1', '2') and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st and a.rent_l_cd=c.rent_l_cd "+condition1+""+
					"		group by c.bus_id2"+
					"		union all"+
					"		select '대여료' gubun2, b.bus_id2, sum("+est_amt2+") tot_amt, sum(decode(sign(to_date("+est_dt2+",'YYYYMMDD')-sysdate),-1,decode("+est_dt2+","+settle_dt+",0,"+est_amt2+"))) dly_amt, count(decode(sign(to_date("+est_dt2+",'YYYYMMDD')-sysdate),-1,decode("+est_dt2+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_fee a, cont b"+
					"		where a.rent_l_cd=b.rent_l_cd "+condition2+""+
					"		group by b.bus_id2"+
					"		union all"+
					"		select '과태료' gubun2, decode(a.rent_s_cd,'',decode(a.fault_st,'2',nvl(a.fault_nm,b.bus_id2),b.bus_id2), decode(c.rent_st,'1',c.bus_id,'9',c.bus_id,'2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) bus_id2, sum("+est_amt3+") tot_amt, sum(decode(sign(to_date("+est_dt3+",'YYYYMMDD')-sysdate),-1,decode("+est_dt3+","+settle_dt+",0,"+est_amt3+")))"+magni+" dly_amt, count(decode(sign(to_date("+est_dt3+",'YYYYMMDD')-sysdate),-1,decode("+est_dt1+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from fine a, cont b, rent_cont c, cont d"+
					"		where a.rent_l_cd=b.rent_l_cd and a.rent_s_cd=c.rent_s_cd(+) and c.sub_l_cd=d.rent_l_cd(+) "+condition3+""+
					"		group by decode(a.rent_s_cd,'',decode(a.fault_st,'2',nvl(a.fault_nm,b.bus_id2),b.bus_id2), decode(c.rent_st,'1',c.bus_id,'9',c.bus_id,'2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id))"+
					"		union all"+
					"		select '면책금' gubun2, decode(e.rent_s_cd,'',b.bus_id2, decode(c.rent_st,'1',c.bus_id,'9',c.bus_id,'2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) bus_id2, sum("+est_amt4+") tot_amt, sum(decode(sign(to_date("+est_dt4+",'YYYYMMDD')-sysdate),-1,decode("+est_dt4+","+settle_dt+",0,"+est_amt4+")))"+magni+" dly_amt, count(decode(sign(to_date("+est_dt4+",'YYYYMMDD')-sysdate),-1,decode("+est_dt4+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from service a, accident e, cont b, rent_cont c, cont d"+
					"		where a.car_mng_id=e.car_mng_id and a.accid_id=e.accid_id and a.rent_l_cd=b.rent_l_cd and e.rent_s_cd=c.rent_s_cd(+) and c.sub_l_cd=d.rent_l_cd(+) "+condition4+""+
					"		group by decode(e.rent_s_cd,'',b.bus_id2, decode(c.rent_st,'1',c.bus_id,'9',c.bus_id,'2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id))"+
//							휴차료는 사원별 미수금 관리 제외				
//					"		union all"+
//					"		select '휴차료' gubun2, c.bus_id2, sum("+est_amt5+") tot_amt, sum(decode(sign(to_date("+est_dt5+",'YYYYMMDD')-sysdate),-1,"+est_amt5+")) dly_amt, count(decode(sign(to_date("+est_dt5+",'YYYYMMDD')-sysdate),-1,a.car_mng_id)) dly_su"+
//					" 		from my_accid a, accident b, cont c"+
//					"		where a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and b.rent_l_cd=c.rent_l_cd "+condition5+""+
//					"		group by c.bus_id2"+
					"		union all"+
					"		select '위약금' gubun2, c.bus_id2, sum("+est_amt6+") tot_amt, sum(decode(sign(to_date("+est_dt6+",'YYYYMMDD')-sysdate),-1,decode("+est_dt6+","+settle_dt+",0,"+est_amt6+"))) dly_amt, count(decode(sign(to_date("+est_dt6+",'YYYYMMDD')-sysdate),-1,decode("+est_dt6+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_ext a, cls_cont b, cont c"+
					"		where a.ext_st= '4' and a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd "+condition6+""+
					"		group by c.bus_id2"+
					"		union all"+
					"		select '단기요금' gubun2, b.bus_id bus_id2, sum("+est_amt7+") tot_amt, sum(decode(sign(to_date("+est_dt7+",'YYYYMMDD')-sysdate),-1,decode("+est_dt7+","+settle_dt+",0,"+est_amt7+"))) dly_amt, count(decode(sign(to_date("+est_dt7+",'YYYYMMDD')-sysdate),-1,decode("+est_dt7+","+settle_dt+",'',a.rent_s_cd))) dly_su"+
					"		from scd_rent a, rent_cont b"+
					"		where a.rent_s_cd=b.rent_s_cd "+condition7+""+
					"		group by b.bus_id"+
					"	)group by bus_id2"+
					" ) a, users b, branch c, (select * from code where c_st='0002') d, (select * from stat_settle where save_dt='"+eff_dt+"') e"+
					" where a.bus_id2=b.user_id and b.br_id=c.br_id and b.dept_id=d.code and a.bus_id2=e.bus_id2(+) "+
					" and a.tot_amt >= "+dly_bus7;

			if(!brch_id.equals("")) query += " and b.br_id='"+brch_id+"'";
			if(!dept_id.equals("")) query += " and b.dept_id='"+dept_id+"'";

			query += " order by a.dly_per, a.dly_amt";

		}else{

			query = " select a.*, 0 tot_su, c.br_id, c.dept_id, e.per1 as per_0405 from stat_settle a, users c, (select bus_id2, per1 from stat_settle where save_dt='"+eff_dt+"') e where a.bus_id2=c.user_id and a.save_dt='"+save_dt+"' and a.bus_id2=e.bus_id2(+)";

			query += " and a.tot_amt >= "+dly_bus7;

			if(!brch_id.equals("")) query += " and c.br_id='"+brch_id+"'";
			if(!dept_id.equals("")) query += " and c.dept_id='"+dept_id+"'";

			query += " order by a.seq , a.amt desc";
		}



		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			while(rs.next())
			{
				IncomingSBean fee = new IncomingSBean();
				fee.setGubun(rs.getString("bus_id2"));
				fee.setBr_id(rs.getString("br_id"));
				fee.setDept_id(rs.getString("dept_id"));
//				fee.setTot_su1(rs.getString("tot_su"));
				fee.setTot_amt1(rs.getString("tot_amt"));
				fee.setTot_su2(rs.getString("su"));
				fee.setTot_amt2(rs.getString("amt"));
				fee.setTot_su3(rs.getString("per1"));
				fee.setTot_su4(rs.getString("per2")==null?"":rs.getString("per2"));
				fee.setTot_su5(rs.getString("per_0405")==null?"":rs.getString("per_0405"));
				vt.add(fee);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[SettleDatabase:getStatSettleList3]"+e);
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
	 *	미수금현황 리스트- 영업부 채권캠페인 받을어음 변수(1억5천)에 따라 캠페인대상조절.-> 부산지점 기본식 배정 가정 : 미적용
	 *	2006.07.28. jhm
	 */
	public Vector getStatSettleList4(String brch_id, String dept_id, String save_dt, String eff_dt, String dly_bus7)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String magni = "";//5배할증  *5 -> 20131021 할증해제
		String settle_dt = "to_char(sysdate,'YYYYMMDD')";

		if(save_dt.equals("")){

			query = " select b.br_id, b.dept_id, a.bus_id2, c.br_nm, d.nm, b.user_nm, b.user_pos, a.tot_amt, nvl(a.dly_amt,0) as amt, a.dly_su as su, a.dly_per as per1, '' per2, nvl(e.per1,0) per_0405"+
					" from"+
					" ("+
					"	select"+
					"	bus_id2, sum(tot_amt) tot_amt, sum(dly_amt) dly_amt, sum(dly_su) dly_su,"+
					"	nvl(trunc((sum(dly_amt)/sum(tot_amt)*100),2),0) dly_per"+
					"	from"+
					"	("+
					"		select '선수금' gubun2, c.bus_id2, sum("+est_amt1+") tot_amt, sum(decode(sign(to_date("+est_dt1+",'YYYYMMDD')-sysdate),-1,decode("+est_dt1+","+settle_dt+",0,"+est_amt1+"))) dly_amt, count(decode(sign(to_date("+est_dt1+",'YYYYMMDD')-sysdate),-1,decode("+est_dt1+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_ext a, fee b, cont c"+
					"		where a.ext_st in ( '0', '1', '2' ) and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st and a.rent_l_cd=c.rent_l_cd "+condition1+""+
					"		group by c.bus_id2"+
					"		union all"+//본사,부산-일반식
					"		select '대여료' gubun2, b.bus_id2, sum("+est_amt2+") tot_amt, sum(decode(sign(to_date("+est_dt2+",'YYYYMMDD')-sysdate),-1,decode("+est_dt2+","+settle_dt+",0,"+est_amt2+"))) dly_amt, count(decode(sign(to_date("+est_dt2+",'YYYYMMDD')-sysdate),-1,decode("+est_dt2+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_fee a, cont b, users c, fee d"+
					"		where a.rent_l_cd=b.rent_l_cd and b.bus_id2=c.user_id and b.rent_l_cd=d.rent_l_cd and (c.br_id='S1' or (c.br_id='B1' and d.rent_way='1'))"+
							condition2+""+
					"		group by b.bus_id2"+
					"		union all"+//부산-기본식
					"		select '대여료' gubun2, b.bus_id2, sum("+est_amt2+") tot_amt, sum(decode(sign(to_date("+est_dt2+",'YYYYMMDD')-sysdate),-1,decode("+est_dt2+","+settle_dt+",0,"+est_amt2+"))) dly_amt, count(decode(sign(to_date("+est_dt2+",'YYYYMMDD')-sysdate),-1,decode("+est_dt2+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_fee a, cont b, users c, fee d,"+
					"			(select rent_mng_id, rent_l_cd"+
					"				from scd_fee where fee_tm > '3' and rc_yn='0' and r_fee_est_dt < to_char(sysdate,'YYYYMMDD')"+//3회차이후연체
					"				group by rent_mng_id, rent_l_cd) e,"+
					"			(select rent_mng_id, rent_l_cd"+
					"				from scd_fee where fee_tm = '3' and rc_yn='0' and r_fee_est_dt >= to_char(sysdate,'YYYYMMDD')"+//3회차 미연체
					"			    group by rent_mng_id, rent_l_cd) f"+
					"		where a.rent_l_cd=b.rent_l_cd and b.bus_id2=c.user_id and b.rent_l_cd=d.rent_l_cd and c.br_id='B1' and d.rent_way='3'"+
					"       and b.rent_l_cd=e.rent_l_cd(+) and b.rent_l_cd=f.rent_l_cd(+) and (e.rent_l_cd is not null or f.rent_l_cd is not null)"+
							condition2+""+
					"		group by b.bus_id2"+
					"		union all"+
					"		select '과태료' gubun2, decode(a.rent_s_cd,'',decode(a.fault_st,'2',nvl(a.fault_nm,b.bus_id2),b.bus_id2), decode(c.rent_st,'1',c.bus_id,'9',c.bus_id,'2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) bus_id2, sum("+est_amt3+") tot_amt, sum(decode(sign(to_date("+est_dt3+",'YYYYMMDD')-sysdate),-1,decode("+est_dt3+","+settle_dt+",0,"+est_amt3+")))"+magni+" dly_amt, count(decode(sign(to_date("+est_dt3+",'YYYYMMDD')-sysdate),-1,decode("+est_dt1+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from fine a, cont b, rent_cont c, cont d"+
					"		where a.rent_l_cd=b.rent_l_cd and a.rent_s_cd=c.rent_s_cd(+) and c.sub_l_cd=d.rent_l_cd(+) "+condition3+""+
					"		group by decode(a.rent_s_cd,'',decode(a.fault_st,'2',nvl(a.fault_nm,b.bus_id2),b.bus_id2), decode(c.rent_st,'1',c.bus_id,'9',c.bus_id,'2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id))"+
					"		union all"+
					"		select '면책금' gubun2, decode(e.rent_s_cd,'',b.bus_id2, decode(c.rent_st,'1',c.bus_id,'9',c.bus_id,'2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) bus_id2, sum("+est_amt4+") tot_amt, sum(decode(sign(to_date("+est_dt4+",'YYYYMMDD')-sysdate),-1,decode("+est_dt4+","+settle_dt+",0,"+est_amt4+")))"+magni+" dly_amt, count(decode(sign(to_date("+est_dt4+",'YYYYMMDD')-sysdate),-1,decode("+est_dt4+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from service a, accident e, cont b, rent_cont c, cont d"+
					"		where a.car_mng_id=e.car_mng_id and a.accid_id=e.accid_id and a.rent_l_cd=b.rent_l_cd and e.rent_s_cd=c.rent_s_cd(+) and c.sub_l_cd=d.rent_l_cd(+) "+condition4+""+
					"		group by decode(e.rent_s_cd,'',b.bus_id2, decode(c.rent_st,'1',c.bus_id,'9',c.bus_id,'2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id))"+
					"		union all"+
					"		select '위약금' gubun2, c.bus_id2, sum("+est_amt6+") tot_amt, sum(decode(sign(to_date("+est_dt6+",'YYYYMMDD')-sysdate),-1,decode("+est_dt6+","+settle_dt+",0,"+est_amt6+"))) dly_amt, count(decode(sign(to_date("+est_dt6+",'YYYYMMDD')-sysdate),-1,decode("+est_dt6+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_ext a, cls_cont b, cont c"+
					"		where a.ext_st = '4' and a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd "+condition6+""+
					"		group by c.bus_id2"+
					"		union all"+
					"		select '단기요금' gubun2, b.bus_id bus_id2, sum("+est_amt7+") tot_amt, sum(decode(sign(to_date("+est_dt7+",'YYYYMMDD')-sysdate),-1,decode("+est_dt7+","+settle_dt+",0,"+est_amt7+"))) dly_amt, count(decode(sign(to_date("+est_dt7+",'YYYYMMDD')-sysdate),-1,decode("+est_dt7+","+settle_dt+",'',a.rent_s_cd))) dly_su"+
					"		from scd_rent a, rent_cont b"+
					"		where a.rent_s_cd=b.rent_s_cd "+condition7+""+
					"		group by b.bus_id"+
					"	)group by bus_id2"+
					" ) a, users b, branch c, (select * from code where c_st='0002') d, (select * from stat_settle where save_dt='"+eff_dt+"') e"+
					" where a.bus_id2=b.user_id and b.br_id=c.br_id and b.dept_id=d.code and a.bus_id2=e.bus_id2(+) "+
					" and a.tot_amt >= "+dly_bus7;

			if(!brch_id.equals("")) query += " and b.br_id='"+brch_id+"'";
			if(!dept_id.equals("")) query += " and b.dept_id='"+dept_id+"'";

			query += " order by a.dly_per, a.dly_amt";

		}else{

			query = " select a.*, 0 tot_su, c.br_id, c.dept_id, e.per1 as per_0405 from stat_settle a, users c, (select bus_id2, per1 from stat_settle where save_dt='"+eff_dt+"') e where a.bus_id2=c.user_id and a.save_dt='"+save_dt+"' and a.bus_id2=e.bus_id2(+)";

			query += " and a.tot_amt >= "+dly_bus7;

			if(!brch_id.equals("")) query += " and c.br_id='"+brch_id+"'";
			if(!dept_id.equals("")) query += " and c.dept_id='"+dept_id+"'";

			query += " order by a.seq , a.amt desc";
		}



		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			while(rs.next())
			{
				IncomingSBean fee = new IncomingSBean();
				fee.setGubun(rs.getString("bus_id2"));
				fee.setBr_id(rs.getString("br_id"));
				fee.setDept_id(rs.getString("dept_id"));
//				fee.setTot_su1(rs.getString("tot_su"));
				fee.setTot_amt1(rs.getString("tot_amt"));
				fee.setTot_su2(rs.getString("su"));
				fee.setTot_amt2(rs.getString("amt"));
				fee.setTot_su3(rs.getString("per1"));
				fee.setTot_su4(rs.getString("per2")==null?"":rs.getString("per2"));
				fee.setTot_su5(rs.getString("per_0405")==null?"":rs.getString("per_0405"));
				vt.add(fee);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[SettleDatabase:getStatSettleList4]"+e);
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
	 *	미수금현황 리스트- 영업부 채권캠페인 받을어음 변수(1억5천)에 따라 캠페인대상조절.-> 부산지점 3개월만 포상적용 : 미적용
	 *	2006.07.28. jhm
	 */
	public Vector getStatSettleList5(String brch_id, String dept_id, String save_dt, String eff_dt, String dly_bus7)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String magni = "";//5배할증  *5 -> 20131021 할증해제
		String settle_dt = "to_char(sysdate,'YYYYMMDD')";

		if(save_dt.equals("")){

			query = " select b.br_id, b.dept_id, a.bus_id2, c.br_nm, d.nm, b.user_nm, b.user_pos, a.tot_amt, nvl(a.three_amt,0) as three_amt, nvl(a.dly_amt,0) as amt, a.dly_su as su, a.dly_per as per1, '' per2, nvl(e.per1,0) per_0405"+
					" from"+
					" ("+
					"	select"+
					"	bus_id2, sum(tot_amt) tot_amt, sum(three_amt) three_amt, sum(dly_amt) dly_amt, sum(dly_su) dly_su,"+
					"	nvl(trunc((sum(dly_amt)/sum(tot_amt)*100),2),0) dly_per"+
					"	from"+
					"	("+
					"		select '선수금' gubun2, c.bus_id2, sum("+est_amt1+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt1+",'YYYYMMDD')-sysdate),-1,decode("+est_dt1+","+settle_dt+",0,"+est_amt1+"))) dly_amt, count(decode(sign(to_date("+est_dt1+",'YYYYMMDD')-sysdate),-1,decode("+est_dt1+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_ext a, fee b, cont c"+
					"		where a.ext_st in ('0', '1', '2' ) and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st and a.rent_l_cd=c.rent_l_cd "+condition1+""+
					"		group by c.bus_id2"+
					"		union all"+
					"		select '대여료' gubun2, b.bus_id2, sum("+est_amt2+") tot_amt,"+
					"		sum(decode(c.br_id,'S1',0,decode(a.fee_tm,'1',a.fee_s_amt+a.fee_v_amt,'2',a.fee_s_amt+a.fee_v_amt,'3',a.fee_s_amt+a.fee_v_amt,0))) three_amt,"+
					"		sum(decode(sign(to_date("+est_dt2+",'YYYYMMDD')-sysdate),-1,decode("+est_dt2+","+settle_dt+",0,"+est_amt2+"))) dly_amt, count(decode(sign(to_date("+est_dt2+",'YYYYMMDD')-sysdate),-1,decode("+est_dt2+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_fee a, cont b, users c"+
					"		where a.rent_l_cd=b.rent_l_cd and b.bus_id2=c.user_id "+
							condition2+""+
					"		group by b.bus_id2"+
					"		union all"+
					"		select '과태료' gubun2, decode(a.rent_s_cd,'',decode(a.fault_st,'2',nvl(a.fault_nm,b.bus_id2),b.bus_id2), decode(c.rent_st,'1',c.bus_id,'9',c.bus_id,'2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) bus_id2, sum("+est_amt3+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt3+",'YYYYMMDD')-sysdate),-1,decode("+est_dt3+","+settle_dt+",0,"+est_amt3+")))"+magni+" dly_amt, count(decode(sign(to_date("+est_dt3+",'YYYYMMDD')-sysdate),-1,decode("+est_dt1+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from fine a, cont b, rent_cont c, cont d"+
					"		where a.rent_l_cd=b.rent_l_cd and a.rent_s_cd=c.rent_s_cd(+) and c.sub_l_cd=d.rent_l_cd(+) "+condition3+""+
					"		group by decode(a.rent_s_cd,'',decode(a.fault_st,'2',nvl(a.fault_nm,b.bus_id2),b.bus_id2), decode(c.rent_st,'1',c.bus_id,'9',c.bus_id,'2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id))"+
					"		union all"+
					"		select '면책금' gubun2, decode(e.rent_s_cd,'',b.bus_id2, decode(c.rent_st,'1',c.bus_id,'9',c.bus_id,'2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) bus_id2, sum("+est_amt4+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt4+",'YYYYMMDD')-sysdate),-1,decode("+est_dt4+","+settle_dt+",0,"+est_amt4+")))"+magni+" dly_amt, count(decode(sign(to_date("+est_dt4+",'YYYYMMDD')-sysdate),-1,decode("+est_dt4+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from service a, accident e, cont b, rent_cont c, cont d"+
					"		where a.car_mng_id=e.car_mng_id and a.accid_id=e.accid_id and a.rent_l_cd=b.rent_l_cd and e.rent_s_cd=c.rent_s_cd(+) and c.sub_l_cd=d.rent_l_cd(+) "+condition4+""+
					"		group by decode(e.rent_s_cd,'',b.bus_id2, decode(c.rent_st,'1',c.bus_id,'9',c.bus_id,'2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id))"+
					"		union all"+
					"		select '위약금' gubun2, c.bus_id2, sum("+est_amt6+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt6+",'YYYYMMDD')-sysdate),-1,decode("+est_dt6+","+settle_dt+",0,"+est_amt6+"))) dly_amt, count(decode(sign(to_date("+est_dt6+",'YYYYMMDD')-sysdate),-1,decode("+est_dt6+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_ext a, cls_cont b, cont c"+
					"		where a.ext_st = '4' and a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd "+condition6+""+
					"		group by c.bus_id2"+
					"		union all"+
					"		select '단기요금' gubun2, b.bus_id bus_id2, sum("+est_amt7+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt7+",'YYYYMMDD')-sysdate),-1,decode("+est_dt7+","+settle_dt+",0,"+est_amt7+"))) dly_amt, count(decode(sign(to_date("+est_dt7+",'YYYYMMDD')-sysdate),-1,decode("+est_dt7+","+settle_dt+",'',a.rent_s_cd))) dly_su"+
					"		from scd_rent a, rent_cont b"+
					"		where a.rent_s_cd=b.rent_s_cd "+condition7+""+
					"		group by b.bus_id"+
					"	)group by bus_id2"+
					" ) a, users b, branch c, (select * from code where c_st='0002') d, (select * from stat_settle where save_dt='"+eff_dt+"') e"+
					" where a.bus_id2=b.user_id and b.br_id=c.br_id and b.dept_id=d.code and a.bus_id2=e.bus_id2(+) "+
					" and a.tot_amt >= "+dly_bus7;

			if(!brch_id.equals("")) query += " and b.br_id='"+brch_id+"'";
			if(!dept_id.equals("")) query += " and b.dept_id='"+dept_id+"'";

			query += " order by a.dly_per, a.dly_amt";

		}else{

			query = " select a.*, 0 tot_su, 0 three_amt, c.br_id, c.dept_id, e.per1 as per_0405 from stat_settle a, users c, (select bus_id2, per1 from stat_settle where save_dt='"+eff_dt+"') e where a.bus_id2=c.user_id and a.save_dt='"+save_dt+"' and a.bus_id2=e.bus_id2(+)";

			query += " and a.tot_amt >= "+dly_bus7;

			if(!brch_id.equals("")) query += " and c.br_id='"+brch_id+"'";
			if(!dept_id.equals("")) query += " and c.dept_id='"+dept_id+"'";

			query += " order by a.seq , a.amt desc";
		}



		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			while(rs.next())
			{
				IncomingSBean fee = new IncomingSBean();
				fee.setGubun(rs.getString("bus_id2"));
				fee.setBr_id(rs.getString("br_id"));
				fee.setDept_id(rs.getString("dept_id"));
//				fee.setTot_su1(rs.getString("tot_su"));
				fee.setTot_amt1(rs.getString("tot_amt"));
				fee.setTot_su2(rs.getString("su"));
				fee.setTot_amt2(rs.getString("amt"));
				fee.setTot_su3(rs.getString("per1"));
				fee.setTot_su4(rs.getString("per2")==null?"":rs.getString("per2"));
				fee.setTot_su5(rs.getString("per_0405")==null?"":rs.getString("per_0405"));
				fee.setTot_amt3(rs.getString("three_amt"));
				vt.add(fee);
			}
			rs.close();
			pstmt.close();		
		} catch (SQLException e) {
			System.out.println("[SettleDatabase:getStatSettleList5]"+e);
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
	 *	미수금현황 리스트- 영업부 채권캠페인 받을어음 변수(1억5천)에 따라 캠페인대상조절.-> 부산지점은 넘기기 직전 받을어음 : 적용
	 *	2006.08.02. jhm
	 */
	public Vector getStatSettleList6(String brch_id, String dept_id, String save_dt, String eff_dt, String dly_bus7)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String magni = "";//5배할증  *5 -> 20131021 할증해제
		String settle_dt = "to_char(sysdate,'YYYYMMDD')";

		if(save_dt.equals("")){

			query = " select b.br_id, b.dept_id, a.bus_id2, c.br_nm, d.nm, b.user_nm, b.user_pos, a.tot_amt, nvl(a.three_amt,0) as three_amt, nvl(a.dly_amt,0) as amt, a.dly_su as su, a.dly_per as per1, '' per2, nvl(e.per1,0) per_0405"+
					" from"+
					" ("+
					"	select"+
					"	bus_id2, sum(tot_amt) tot_amt, sum(three_amt) three_amt, sum(dly_amt) dly_amt, sum(dly_su) dly_su,"+
					"	nvl(trunc((sum(dly_amt)/sum(tot_amt)*100),2),0) dly_per"+
					"	from"+
					"	("+
					"		select '선수금' gubun2, c.bus_id2, sum("+est_amt1+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt1+",'YYYYMMDD')-sysdate),-1,decode("+est_dt1+","+settle_dt+",0,"+est_amt1+"))) dly_amt, count(decode(sign(to_date("+est_dt1+",'YYYYMMDD')-sysdate),-1,decode("+est_dt1+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_ext a, fee b, cont c"+
					"		where a.ext_st in ('0', '1', '2') and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st and a.rent_l_cd=c.rent_l_cd "+condition1+""+
					"		group by c.bus_id2"+
					"		union all"+//본사,부산 총받을어음
					"		select '대여료' gubun2, b.bus_id2, sum("+est_amt2+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt2+",'YYYYMMDD')-sysdate),-1,decode("+est_dt2+","+settle_dt+",0,"+est_amt2+"))) dly_amt, count(decode(sign(to_date("+est_dt2+",'YYYYMMDD')-sysdate),-1,decode("+est_dt2+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_fee a, cont b"+
					"		where a.rent_l_cd=b.rent_l_cd "+
							condition2+""+
					"		group by b.bus_id2"+
//					"		union all"+//부산-직전3개월인 총받을어음
//					"		select '대여료' gubun2, b.bus_id2, 0 tot_amt, sum("+est_amt2+") three_amt, 0 dly_amt, 0 dly_su"+
//					"		from scd_fee a, cont b, users c,"+
//					"			(select rent_mng_id, rent_l_cd"+
//					"				from scd_fee where fee_tm > '3' and rc_yn='0' and r_fee_est_dt < to_char(sysdate,'YYYYMMDD')"+//3회차이후연체
//					"				group by rent_mng_id, rent_l_cd) e,"+
//					"			(select rent_mng_id, rent_l_cd"+
//					"				from scd_fee where fee_tm = '3' and rc_yn='0' and r_fee_est_dt >= to_char(sysdate,'YYYYMMDD')"+//3회차 미연체
//					"			    group by rent_mng_id, rent_l_cd) f"+
//					"		where a.rent_l_cd=b.rent_l_cd and b.bus_id2=c.user_id and c.br_id='B1'"+
//					"       and a.rent_l_cd=e.rent_l_cd(+)"+
//					"		and a.rent_l_cd=f.rent_l_cd(+) "+
//					"		and (e.rent_l_cd is not null or f.rent_l_cd is not null) "+
//							condition2+""+
//					"		group by b.bus_id2"+
					"		union all"+
					"		select '과태료' gubun2, decode(a.rent_s_cd,'',decode(a.fault_st,'2',nvl(a.fault_nm,b.bus_id2),b.bus_id2), decode(c.rent_st,'1',c.bus_id,'9',c.bus_id,'2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) bus_id2, sum("+est_amt3+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt3+",'YYYYMMDD')-sysdate),-1,decode("+est_dt3+","+settle_dt+",0,"+est_amt3+")))"+magni+" dly_amt, count(decode(sign(to_date("+est_dt3+",'YYYYMMDD')-sysdate),-1,decode("+est_dt1+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from fine a, cont b, rent_cont c, cont d"+
					"		where a.rent_l_cd=b.rent_l_cd and a.rent_s_cd=c.rent_s_cd(+) and c.sub_l_cd=d.rent_l_cd(+) "+condition3+""+
					"		group by decode(a.rent_s_cd,'',decode(a.fault_st,'2',nvl(a.fault_nm,b.bus_id2),b.bus_id2), decode(c.rent_st,'1',c.bus_id,'9',c.bus_id,'2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id))"+
					"		union all"+
					"		select '면책금' gubun2, decode(e.rent_s_cd,'',b.bus_id2, decode(c.rent_st,'1',c.bus_id,'9',c.bus_id,'2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) bus_id2, sum("+est_amt4+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt4+",'YYYYMMDD')-sysdate),-1,decode("+est_dt4+","+settle_dt+",0,"+est_amt4+")))"+magni+" dly_amt, count(decode(sign(to_date("+est_dt4+",'YYYYMMDD')-sysdate),-1,decode("+est_dt4+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from service a, accident e, cont b, rent_cont c, cont d"+
					"		where a.car_mng_id=e.car_mng_id and a.accid_id=e.accid_id and a.rent_l_cd=b.rent_l_cd and e.rent_s_cd=c.rent_s_cd(+) and c.sub_l_cd=d.rent_l_cd(+) "+condition4+""+
					"		group by decode(e.rent_s_cd,'',b.bus_id2, decode(c.rent_st,'1',c.bus_id,'9',c.bus_id,'2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id))"+
					"		union all"+
					"		select '위약금' gubun2, c.bus_id2, sum("+est_amt6+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt6+",'YYYYMMDD')-sysdate),-1,decode("+est_dt6+","+settle_dt+",0,"+est_amt6+"))) dly_amt, count(decode(sign(to_date("+est_dt6+",'YYYYMMDD')-sysdate),-1,decode("+est_dt6+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_ext a, cls_cont b, cont c"+
					"		where a.ext_st = '4' and a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd "+condition6+""+
					"		group by c.bus_id2"+
					"		union all"+
					"		select '단기요금' gubun2, b.bus_id bus_id2, sum("+est_amt7+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt7+",'YYYYMMDD')-sysdate),-1,decode("+est_dt7+","+settle_dt+",0,"+est_amt7+"))) dly_amt, count(decode(sign(to_date("+est_dt7+",'YYYYMMDD')-sysdate),-1,decode("+est_dt7+","+settle_dt+",'',a.rent_s_cd))) dly_su"+
					"		from scd_rent a, rent_cont b"+
					"		where a.rent_s_cd=b.rent_s_cd "+condition7+""+
					"		group by b.bus_id"+
					"	)group by bus_id2"+
					" ) a, users b, branch c, (select * from code where c_st='0002') d, (select * from stat_settle where save_dt='"+eff_dt+"') e"+
					" where a.bus_id2=b.user_id and b.br_id=c.br_id and b.dept_id=d.code and a.bus_id2=e.bus_id2(+) ";
//					" and a.tot_amt >= "+dly_bus7;

//			if(!brch_id.equals("")) query += " and b.br_id='"+brch_id+"'";
//			if(!dept_id.equals("")) query += " and b.dept_id='"+dept_id+"'";

			query += " and b.loan_st='2'";

			//query += " and b.enter_dt < '20070101'";
			query += " order by a.dly_per, a.dly_amt";

		}else{

			query = " select a.*, 0 tot_su, c.br_id, c.dept_id, e.per1 as per_0405 "+
					" from stat_settle a, users c, (select bus_id2, per1 from stat_settle where save_dt='"+eff_dt+"') e"+
					" where a.bus_id2=c.user_id and a.save_dt='"+save_dt+"' and a.bus_id2=e.bus_id2(+)";

//			query += " and a.tot_amt >= "+dly_bus7;

			//if(!brch_id.equals("")) query += " and c.br_id='"+brch_id+"'";
			//if(!dept_id.equals("")) query += " and c.dept_id='"+dept_id+"'";

			query += " and c.loan_st='2'";

//			query += " and c.enter_dt < '20070101'";
			query += " order by a.seq , a.amt desc";
		}



		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			while(rs.next())
			{
				IncomingSBean fee = new IncomingSBean();
				fee.setGubun(rs.getString("bus_id2"));
				fee.setBr_id(rs.getString("br_id"));
				fee.setDept_id(rs.getString("dept_id"));
//				fee.setTot_su1(rs.getString("tot_su"));
				fee.setTot_amt1(rs.getString("tot_amt"));
				fee.setTot_su2(rs.getString("su"));
				fee.setTot_amt2(rs.getString("amt"));
				fee.setTot_su3(rs.getString("per1"));
				fee.setTot_su4(rs.getString("per2")==null?"":rs.getString("per2"));
				fee.setTot_su5(rs.getString("per_0405")==null?"":rs.getString("per_0405"));
				fee.setTot_amt3(rs.getString("three_amt")==null?"0":rs.getString("three_amt"));
				vt.add(fee);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[SettleDatabase:getStatSettleList6]"+e);
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
	 *	미수금현황 리스트-채권1
	 */
	public Vector getStatSettleList7(String brch_id, String dept_id, String save_dt, String eff_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String magni = "";//5배할증  *5 -> 20131021 할증해제
		String settle_dt = "to_char(sysdate,'YYYYMMDD')";

		if(save_dt.equals("")){

			query = " select "+
					"	b.br_id, b.dept_id, a.bus_id2, c.br_nm, d.nm, b.user_nm, b.user_pos,"+
					"	a.tot_amt, nvl(a.three_amt,0) as three_amt, nvl(a.dly_amt,0) as amt, a.dly_su as su, "+
					"	a.dly_per as per1, '' per2, nvl(e.per1,0) per_0405"+
					" from"+
					" ("+
					"	select"+
					"	bus_id2, sum(tot_amt) tot_amt, sum(dly_amt) dly_amt, sum(dly_su) dly_su, sum(three_amt) three_amt,"+
					"	nvl(trunc((sum(dly_amt)/sum(tot_amt)*100),2),0) dly_per"+
					"	from"+
					"	("+
					"		select '선수금' gubun2, c.bus_id2, sum("+est_amt1+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt1+",'YYYYMMDD')-sysdate),-1,decode("+est_dt1+","+settle_dt+",0,"+est_amt1+"))) dly_amt, count(decode(sign(to_date("+est_dt1+",'YYYYMMDD')-sysdate),-1,decode("+est_dt1+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_ext a, fee b, cont c"+
					"		where a.ext_st in ('0', '1', '2') and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st and a.rent_l_cd=c.rent_l_cd "+condition1+""+
					"		group by c.bus_id2"+
					"		union all"+
					"		select '대여료' gubun2, b.bus_id2, sum("+est_amt2+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt2+",'YYYYMMDD')-sysdate),-1,decode("+est_dt2+","+settle_dt+",0,"+est_amt2+"))) dly_amt, count(decode(sign(to_date("+est_dt2+",'YYYYMMDD')-sysdate),-1,decode("+est_dt2+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_fee a, cont b"+
					"		where a.rent_l_cd=b.rent_l_cd "+condition2+""+
					"		group by b.bus_id2"+
//					"		union all"+//부산-직전3개월인 총받을어음
//					"		select '대여료' gubun2, b.bus_id2, 0 tot_amt, sum("+est_amt2+") three_amt, 0 dly_amt, 0 dly_su"+
//					"		from scd_fee a, cont b, users c,"+
//					"			(select rent_mng_id, rent_l_cd"+
//					"				from scd_fee where fee_tm > '3' and rc_yn='0' and r_fee_est_dt < to_char(sysdate,'YYYYMMDD')"+//3회차이후연체
//					"				group by rent_mng_id, rent_l_cd) e,"+
//					"			(select rent_mng_id, rent_l_cd"+
//					"				from scd_fee where fee_tm = '3' and rc_yn='0' and r_fee_est_dt >= to_char(sysdate,'YYYYMMDD')"+//3회차 미연체
//					"			    group by rent_mng_id, rent_l_cd) f"+
//					"		where a.rent_l_cd=b.rent_l_cd and b.bus_id2=c.user_id and c.br_id<>'S1'"+
//					"       and a.rent_l_cd=e.rent_l_cd(+)"+
//					"		and a.rent_l_cd=f.rent_l_cd(+) "+
//					"		and (e.rent_l_cd is not null or f.rent_l_cd is not null) "+
//							condition2+""+
//					"		group by b.bus_id2"+
					"		union all"+
					"		select '과태료' gubun2, decode(a.rent_s_cd,'',decode(a.fault_st,'2',nvl(a.fault_nm,b.bus_id2),b.bus_id2), decode(c.rent_st,'1',c.bus_id,'9',c.bus_id,'2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) bus_id2, sum("+est_amt3+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt3+",'YYYYMMDD')-sysdate),-1,decode("+est_dt3+","+settle_dt+",0,"+est_amt3+")))"+magni+" dly_amt, count(decode(sign(to_date("+est_dt3+",'YYYYMMDD')-sysdate),-1,decode("+est_dt1+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from fine a, cont b, rent_cont c, cont d"+
					"		where a.rent_l_cd=b.rent_l_cd and a.rent_s_cd=c.rent_s_cd(+) and c.sub_l_cd=d.rent_l_cd(+) "+condition3+""+
					"		group by decode(a.rent_s_cd,'',decode(a.fault_st,'2',nvl(a.fault_nm,b.bus_id2),b.bus_id2), decode(c.rent_st,'1',c.bus_id,'9',c.bus_id,'2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id))"+
					"		union all"+
					"		select '면책금' gubun2, decode(e.rent_s_cd,'',b.bus_id2, decode(c.rent_st,'1',c.bus_id,'9',c.bus_id,'2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) bus_id2, sum("+est_amt4+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt4+",'YYYYMMDD')-sysdate),-1,decode("+est_dt4+","+settle_dt+",0,"+est_amt4+")))"+magni+" dly_amt, count(decode(sign(to_date("+est_dt4+",'YYYYMMDD')-sysdate),-1,decode("+est_dt4+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from service a, accident e, cont b, rent_cont c, cont d, scd_ext se "+
					"		where se.ext_st = '3' and se.rent_mng_id = a.rent_mng_id and se.rent_l_cd = a.rent_l_cd and a.car_mng_id=e.car_mng_id and a.accid_id=e.accid_id and se.rent_mng_id = b.rent_mng_id and se.rent_l_cd=b.rent_l_cd and e.rent_s_cd=c.rent_s_cd(+) and c.sub_l_cd=d.rent_l_cd(+) "+condition4+""+
					"		group by decode(e.rent_s_cd,'',b.bus_id2, decode(c.rent_st,'1',c.bus_id,'9',c.bus_id,'2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id))"+
//							휴차료는 사원별 미수금 관리 제외				
//					"		union all"+
//					"		select '휴차료' gubun2, c.bus_id2, sum("+est_amt5+") tot_amt, sum(decode(sign(to_date("+est_dt5+",'YYYYMMDD')-sysdate),-1,"+est_amt5+")) dly_amt, count(decode(sign(to_date("+est_dt5+",'YYYYMMDD')-sysdate),-1,a.car_mng_id)) dly_su"+
//					" 		from my_accid a, accident b, cont c"+
//					"		where a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and b.rent_l_cd=c.rent_l_cd "+condition5+""+
//					"		group by c.bus_id2"+
					"		union all"+
					"		select '위약금' gubun2, c.bus_id2, sum("+est_amt6+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt6+",'YYYYMMDD')-sysdate),-1,decode("+est_dt6+","+settle_dt+",0,"+est_amt6+"))) dly_amt, count(decode(sign(to_date("+est_dt6+",'YYYYMMDD')-sysdate),-1,decode("+est_dt6+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_ext a, cls_cont b, cont c"+
					"		where a.ext_st = '4' and a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd "+condition6+""+
					"		group by c.bus_id2"+
					"		union all"+
					"		select '단기요금' gubun2, b.bus_id bus_id2, sum("+est_amt7+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt7+",'YYYYMMDD')-sysdate),-1,decode("+est_dt7+","+settle_dt+",0,"+est_amt7+"))) dly_amt, count(decode(sign(to_date("+est_dt7+",'YYYYMMDD')-sysdate),-1,decode("+est_dt7+","+settle_dt+",'',a.rent_s_cd))) dly_su"+
					"		from scd_rent a, rent_cont b"+
					"		where a.rent_s_cd=b.rent_s_cd "+condition7+""+
					"		group by b.bus_id"+
					"	)group by bus_id2"+
					" ) a, users b, branch c, (select * from code where c_st='0002') d, (select * from stat_settle where save_dt='"+eff_dt+"') e"+
					" where b.user_id <> '000001' and a.bus_id2=b.user_id and b.br_id=c.br_id and b.dept_id=d.code and a.bus_id2=e.bus_id2(+)";

			if(!brch_id.equals("")) query += " and b.br_id='"+brch_id+"'";
			if(!dept_id.equals("")) query += " and b.dept_id='"+dept_id+"'";

			//query += " and b.enter_dt < '20070101'";
			query += " order by a.dly_per, a.dly_amt";

		}else{

			query = " select a.*, 0 tot_su, c.br_id, c.dept_id, e.per1 as per_0405 from stat_settle a, users c, (select bus_id2, per1 from stat_settle where save_dt='"+eff_dt+"') e where a.bus_id2=c.user_id and a.save_dt='"+save_dt+"' and a.bus_id2=e.bus_id2(+)";

			if(!brch_id.equals("")) query += " and c.br_id='"+brch_id+"'";
			if(!dept_id.equals("")) query += " and c.dept_id='"+dept_id+"'";

//			query += " and (c.dept_id='0002' or c.user_id in ('000012','000034'))";

			query += " and c.enter_dt < '20071101'";
			query += " order by a.seq , a.amt desc";
		}



		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			while(rs.next())
			{
				IncomingSBean fee = new IncomingSBean();
				fee.setGubun(rs.getString("bus_id2"));
				fee.setBr_id(rs.getString("br_id"));
				fee.setDept_id(rs.getString("dept_id"));
//				fee.setTot_su1(rs.getString("tot_su"));
				fee.setTot_amt1(rs.getString("tot_amt"));
				fee.setTot_su2(rs.getString("su"));
				fee.setTot_amt2(rs.getString("amt"));
				fee.setTot_su3(rs.getString("per1"));
				fee.setTot_su4(rs.getString("per2")==null?"":rs.getString("per2"));
				fee.setTot_su5(rs.getString("per_0405")==null?"":rs.getString("per_0405"));
				fee.setTot_amt3(rs.getString("three_amt")==null?"":rs.getString("three_amt"));
				vt.add(fee);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[SettleDatabase:getStatSettleList7]"+e);
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
	 *	미수금현황 리스트- 영업부 채권캠페인 받을어음 변수(1억5천)에 따라 캠페인대상조절.-> 부산지점은 넘기기 직전 받을어음 : 적용
	 *	2006.08.02. jhm
	 */
	 
	public Vector getStatSettleList8(String brch_id, String dept_id, String save_dt, String eff_dt, String dly_bus7)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String magni = "";//5배할증  *5 -> 20131021 할증해제
		String settle_dt = "to_char(sysdate,'YYYYMMDD')";

		if(save_dt.equals("")){

			query = " select b.br_id, b.dept_id, a.bus_id2, c.br_nm, d.nm, b.user_nm, b.user_pos, a.tot_amt, nvl(a.three_amt,0) as three_amt, nvl(a.dly_amt,0) as amt, a.dly_su as su, a.dly_per as per1, '' per2, nvl(e.per1,0) per_0405"+
					" from"+
					" ("+
					"	select"+
					"	bus_id2, sum(tot_amt) tot_amt, sum(three_amt) three_amt, sum(dly_amt) dly_amt, sum(dly_su) dly_su,"+
					"	nvl(trunc((sum(dly_amt)/sum(tot_amt)*100),2),0) dly_per"+
					"	from"+
					"	("+
					"		select '선수금' gubun2, c.bus_id2, sum("+est_amt1+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt1+",'YYYYMMDD')-sysdate),-1,decode("+est_dt1+","+settle_dt+",0,"+est_amt1+"))) dly_amt, count(decode(sign(to_date("+est_dt1+",'YYYYMMDD')-sysdate),-1,decode("+est_dt1+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_ext a, fee b, cont c"+
					"		where a.ext_st in ('0', '1', '2' ) and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st and a.rent_l_cd=c.rent_l_cd "+condition1+""+
					"		group by c.bus_id2"+
					"		union all"+//본사,부산 총받을어음
					"		select '대여료' gubun2, b.bus_id2, sum("+est_amt2+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt2+",'YYYYMMDD')-sysdate),-1,decode("+est_dt2+","+settle_dt+",0,"+est_amt2+"))) dly_amt, count(decode(sign(to_date("+est_dt2+",'YYYYMMDD')-sysdate),-1,decode("+est_dt2+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_fee a, cont b"+
					"		where a.rent_l_cd=b.rent_l_cd "+
							condition2+""+
					"		group by b.bus_id2"+
//					"		union all"+//부산-직전3개월인 총받을어음
//					"		select '대여료' gubun2, b.bus_id2, 0 tot_amt, sum("+est_amt2+") three_amt, 0 dly_amt, 0 dly_su"+
//					"		from scd_fee a, cont b, users c,"+
//					"			(select rent_mng_id, rent_l_cd"+
//					"				from scd_fee where fee_tm > '3' and rc_yn='0' and r_fee_est_dt < to_char(sysdate,'YYYYMMDD')"+//3회차이후연체
//					"				group by rent_mng_id, rent_l_cd) e,"+
//					"			(select rent_mng_id, rent_l_cd"+
//					"				from scd_fee where fee_tm = '3' and rc_yn='0' and r_fee_est_dt >= to_char(sysdate,'YYYYMMDD')"+//3회차 미연체
//					"			    group by rent_mng_id, rent_l_cd) f"+
//					"		where a.rent_l_cd=b.rent_l_cd and b.bus_id2=c.user_id and c.br_id='B1'"+
//					"       and a.rent_l_cd=e.rent_l_cd(+)"+
//					"		and a.rent_l_cd=f.rent_l_cd(+) "+
//					"		and (e.rent_l_cd is not null or f.rent_l_cd is not null) "+
//							condition2+""+
//					"		group by b.bus_id2"+
					"		union all"+
					"		select '과태료' gubun2, decode(a.rent_s_cd,'',decode(a.fault_st,'2',nvl(a.fault_nm,b.bus_id2),b.bus_id2), decode(c.rent_st,'1',c.bus_id,'9',c.bus_id,'2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) bus_id2, sum("+est_amt3+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt3+",'YYYYMMDD')-sysdate),-1,decode("+est_dt3+","+settle_dt+",0,"+est_amt3+")))"+magni+" dly_amt, count(decode(sign(to_date("+est_dt3+",'YYYYMMDD')-sysdate),-1,decode("+est_dt1+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from fine a, cont b, rent_cont c, cont d"+
					"		where a.rent_l_cd=b.rent_l_cd and a.rent_s_cd=c.rent_s_cd(+) and c.sub_l_cd=d.rent_l_cd(+) "+condition3+""+
					"		group by decode(a.rent_s_cd,'',decode(a.fault_st,'2',nvl(a.fault_nm,b.bus_id2),b.bus_id2), decode(c.rent_st,'1',c.bus_id,'9',c.bus_id,'2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id))"+
					"		union all"+
					"		select '면책금' gubun2, decode(e.rent_s_cd,'',b.bus_id2, decode(c.rent_st,'1',c.bus_id,'9',c.bus_id,'2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) bus_id2, sum("+est_amt4+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt4+",'YYYYMMDD')-sysdate),-1,decode("+est_dt4+","+settle_dt+",0,"+est_amt4+")))"+magni+" dly_amt, count(decode(sign(to_date("+est_dt4+",'YYYYMMDD')-sysdate),-1,decode("+est_dt4+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from service a, accident e, cont b, rent_cont c, cont d"+
					"		where a.car_mng_id=e.car_mng_id and a.accid_id=e.accid_id and a.rent_l_cd=b.rent_l_cd and e.rent_s_cd=c.rent_s_cd(+) and c.sub_l_cd=d.rent_l_cd(+) "+condition4+""+
					"		group by decode(e.rent_s_cd,'',b.bus_id2, decode(c.rent_st,'1',c.bus_id,'9',c.bus_id,'2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id))"+
					"		union all"+
					"		select '위약금' gubun2, c.bus_id2, sum("+est_amt6+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt6+",'YYYYMMDD')-sysdate),-1,decode("+est_dt6+","+settle_dt+",0,"+est_amt6+"))) dly_amt, count(decode(sign(to_date("+est_dt6+",'YYYYMMDD')-sysdate),-1,decode("+est_dt6+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_ext a, cls_cont b, cont c"+
					"		where a.ext_st = '4' and a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd "+condition6+""+
					"		group by c.bus_id2"+
					"		union all"+
					"		select '단기요금' gubun2, b.bus_id bus_id2, sum("+est_amt7+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt7+",'YYYYMMDD')-sysdate),-1,decode("+est_dt7+","+settle_dt+",0,"+est_amt7+"))) dly_amt, count(decode(sign(to_date("+est_dt7+",'YYYYMMDD')-sysdate),-1,decode("+est_dt7+","+settle_dt+",'',a.rent_s_cd))) dly_su"+
					"		from scd_rent a, rent_cont b"+
					"		where a.rent_s_cd=b.rent_s_cd "+condition7+""+
					"		group by b.bus_id"+
					"	)group by bus_id2"+
					" ) a, users b, branch c, (select * from code where c_st='0002') d, (select * from stat_settle where save_dt='"+eff_dt+"') e"+
					" where a.bus_id2=b.user_id and b.br_id=c.br_id and b.dept_id=d.code and a.bus_id2=e.bus_id2(+) ";
//					" and a.tot_amt >= "+dly_bus7;

//			if(!brch_id.equals("")) query += " and b.br_id='"+brch_id+"'";
//			if(!dept_id.equals("")) query += " and b.dept_id='"+dept_id+"'";

			query += " and b.loan_st='3'";

			//query += " and b.enter_dt < '20070101'";
			query += " order by a.dly_per, a.dly_amt";

		}else{

			query = " select a.*, 0 tot_su, c.br_id, c.dept_id, e.per1 as per_0405 "+
					" from stat_settle a, users c, (select bus_id2, per1 from stat_settle where save_dt='"+eff_dt+"') e"+
					" where a.bus_id2=c.user_id and a.save_dt='"+save_dt+"' and a.bus_id2=e.bus_id2(+)";

//			query += " and a.tot_amt >= "+dly_bus7;

			//if(!brch_id.equals("")) query += " and c.br_id='"+brch_id+"'";
			//if(!dept_id.equals("")) query += " and c.dept_id='"+dept_id+"'";

			query += " and c.loan_st='3'";

//			query += " and c.enter_dt < '20070101'";
			query += " order by a.seq , a.amt desc";
		}



		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			while(rs.next())
			{
				IncomingSBean fee = new IncomingSBean();
				fee.setGubun(rs.getString("bus_id2"));
				fee.setBr_id(rs.getString("br_id"));
				fee.setDept_id(rs.getString("dept_id"));
//				fee.setTot_su1(rs.getString("tot_su"));
				fee.setTot_amt1(rs.getString("tot_amt"));
				fee.setTot_su2(rs.getString("su"));
				fee.setTot_amt2(rs.getString("amt"));
				fee.setTot_su3(rs.getString("per1"));
				fee.setTot_su4(rs.getString("per2")==null?"":rs.getString("per2"));
				fee.setTot_su5(rs.getString("per_0405")==null?"":rs.getString("per_0405"));
				fee.setTot_amt3(rs.getString("three_amt")==null?"0":rs.getString("three_amt"));
				vt.add(fee);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[SettleDatabase:getStatSettleList6]"+e);
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
	 *	미수금현황 리스트- 영업부 채권캠페인 받을어음 변수(1억5천)에 따라 캠페인대상조절.-> 부산지점은 넘기기 직전 받을어음 : 적용
	 *	2006.08.02. jhm
	 */
	public Vector getStatSettle(String lost_st, String save_dt, String eff_dt, String max_amt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
	
		query = " select a.*, 0 tot_su, c.br_id, c.dept_id, b.user_id as partner_id2, b.user_nm as partner_nm, c.loan_st, \n"+
//				"        e.cmp_per as per_0405"+
//				"        e.add_per as per_0405"+
				"        nvl(e.add_per,c.add_per) as per_0405,  round((a.avg_per -a.per1), 3)  eff_per  "+
				" from   stat_settle a, users c, (select bus_id2, add_per from stat_settle where save_dt='"+eff_dt+"') e, users b \n"+
				" where  a.bus_id2=c.user_id and a.save_dt='"+save_dt+"' and a.bus_id2=e.bus_id2(+) and a.partner_id=b.user_id(+) \n"+
//			"	AND c.user_id NOT IN ('000280' , '000281', '000282' )"+ //일시적 제외 (이길희)
				" ";

		if(!max_amt.equals("") && !max_amt.equals("0")){
			query += " and a.tot_amt >= "+AddUtil.replace(max_amt,",","");
		}

		/*
		if(lost_st.equals("3"))	{
			if(!max_amt.equals("") && !max_amt.equals("0"))		query += " and a.three_amt >= "+AddUtil.replace(max_amt,",","");
		}else{
			if(!max_amt.equals("") && !max_amt.equals("0"))		query += " and a.tot_amt >= "+AddUtil.replace(max_amt,",","");
		}
		*/


		if(!lost_st.equals(""))								query += " and c.loan_st='"+lost_st+"'";

		if(AddUtil.parseInt(save_dt) < 20080107)			query += " and to_number(c.enter_dt) < 20071010";
		

		query += " order by  to_number(a.r_cmp_per), to_number(a.cmp_per), a.amt, (a.per1+a.avg_per) ";

	//	System.out.println("getStatSettle=" + query);
		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			while(rs.next())
			{
				IncomingSBean fee = new IncomingSBean();				
				
				fee.setGubun(rs.getString("bus_id2"));
				fee.setBr_id(rs.getString("br_id"));
				fee.setDept_id(rs.getString("dept_id"));

				fee.setTot_amt1(rs.getString("tot_amt"));
				fee.setTot_amt2(rs.getString("amt"));
				fee.setTot_amt3(rs.getString("three_amt")==null?"0":rs.getString("three_amt"));
				fee.setTot_amt4(rs.getString("amt_out")==null?"0":rs.getString("amt_out"));  
				fee.setTot_amt5(rs.getString("amt_in")==null?"0":rs.getString("amt_in"));
				fee.setTot_amt6(rs.getString("eff_amt_out")==null?"0":rs.getString("eff_amt_out"));
				fee.setTot_amt7(rs.getString("eff_amt_in")==null?"0":rs.getString("eff_amt_in"));
				fee.setTot_amt8(rs.getString("amt_in2")==null?"0":rs.getString("amt_in2"));
				fee.setTot_amt9(rs.getString("amt_in1")==null?"0":rs.getString("amt_in1"));

				fee.setTot_su2(rs.getString("su"));				
				fee.setTot_su3(rs.getString("per1"));	//당일 		
				fee.setTot_su4(rs.getString("per2")==null?"":rs.getString("per2"));
				fee.setTot_su5(rs.getString("per_0405")==null?"":rs.getString("per_0405"));
				fee.setTot_su6(rs.getString("avg_per")==null?"":rs.getString("avg_per")); //평균 
				fee.setTot_su7(rs.getString("cmp_per")==null?"":rs.getString("cmp_per"));  //마감 
			
				fee.setTot_su8(rs.getString("r_cmp_per")==null?"":rs.getString("r_cmp_per"));  //적용 
				fee.setTot_su9(rs.getString("eff_per")==null?"":rs.getString("eff_per"));   //20140714 추가 연체율감소치 
				fee.setTot_su1(rs.getString("r_eff_per")==null?"":rs.getString("r_eff_per"));   //20200924추가 연체율감소치
				
				fee.setPartner_id(rs.getString("partner_id2")==null?"":rs.getString("partner_id2"));
				fee.setPartner_nm(rs.getString("partner_nm")==null?"":rs.getString("partner_nm"));
				fee.setReg_dt(rs.getString("reg_dt")==null?"":rs.getString("reg_dt"));

				if(rs.getString("loan_st").equals("2")){
					if(fee.getTot_su1().equals("0")) fee.setTot_su3("0.000");
					if(fee.getTot_su3().equals("0")) fee.setTot_su3("0.000");
					if(fee.getTot_su4().equals("0")) fee.setTot_su4("0.000");
					if(fee.getTot_su6().equals("0")) fee.setTot_su6("0.000");
					if(fee.getTot_su7().equals("0")) fee.setTot_su7("0.000");
					if(fee.getTot_su8().equals("0")) fee.setTot_su8("0.000");
					if(fee.getTot_su9().equals("0")) fee.setTot_su8("0.000");
				}else{
					if(fee.getTot_su1().equals("0")) fee.setTot_su3("0.00");
					if(fee.getTot_su3().equals("0")) fee.setTot_su3("0.00");
					if(fee.getTot_su4().equals("0")) fee.setTot_su4("0.00");
					if(fee.getTot_su6().equals("0")) fee.setTot_su6("0.00");
					if(fee.getTot_su7().equals("0")) fee.setTot_su7("0.00");
					if(fee.getTot_su8().equals("0")) fee.setTot_su8("0.00");
					if(fee.getTot_su9().equals("0")) fee.setTot_su8("0.00");
				}

				vt.add(fee);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[SettleDatabase:getStatSettle]"+e);
			System.out.println("[SettleDatabase:getStatSettle]"+query);
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
	 *	미수금현황 리스트-채권1 )
	 */
	public Vector getStatSettleList_20080714(String brch_id, String dept_id, String save_dt, String eff_dt, String var3, String var6)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String magni = "";//5배할증  *5 -> 20131021 할증해제
		String magni2 = "*0.1";//0.1배할증
		String settle_dt = "to_char(sysdate,'YYYYMMDD')";

		if(save_dt.equals("")){

			query = " select "+
					"	b.br_id, b.dept_id, a.bus_id2, c.br_nm, d.nm, b.user_nm, b.user_pos,"+
					"	a.tot_amt, nvl(a.three_amt,0) as three_amt, case when nvl(a.dly_amt,0) < 0 then 0 else nvl(a.dly_amt,0) end  as amt, a.dly_su as su, "+
					"	case when 	a.dly_per < 0 then 0 else a.dly_per end as per1, '' per2, nvl(e.per1,0) per_0405"+
					" from \n"+
					" ("+
					"	select"+
					"	bus_id2, sum(tot_amt) tot_amt, sum(dly_amt) dly_amt, sum(dly_su) dly_su, sum(three_amt) three_amt,"+
					"	nvl(trunc((sum(dly_amt)/sum(tot_amt)*100),2),0) dly_per"+
					"	from \n"+
					"	("+
					"		select '선수금' gubun2, c.bus_id2, sum("+est_amt1+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt1+",'YYYYMMDD')-sysdate),-1,decode("+est_dt1+","+settle_dt+",0,"+est_amt1+"))) dly_amt, count(decode(sign(to_date("+est_dt1+",'YYYYMMDD')-sysdate),-1,decode("+est_dt1+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_ext a, fee b, cont c"+
					"		where a.ext_st in ('0', '1', '2' ) and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd=c.rent_l_cd "+condition1+""+
					"		group by c.bus_id2 \n"+
					"		union all"+
					"		select '대여료' gubun2, b.bus_id2, trunc(sum("+est_amt_n2+")) tot_amt, 0 three_amt, trunc( sum(decode(sign(to_date("+est_dt2+",'YYYYMMDD')-sysdate),-1,decode("+est_dt2+","+settle_dt+",0,"+est_amt_n2+")))) dly_amt, count(decode(sign(to_date("+est_dt2+",'YYYYMMDD')-sysdate),-1,decode("+est_dt2+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_fee a, cont b, (select a.rent_mng_id, a.rent_l_cd, count(0) in_cnt from car_call_in a, cont b where a.out_dt is null and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(b.use_yn,'Y')='Y' and b.car_st<>'4' group by a.rent_mng_id, a.rent_l_cd) c "+
					"		where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) "+
					"       "+condition2+""+
					"		group by b.bus_id2 \n"+
//					"		union all"+//부산/대전-직전3,4개월인 총받을어음
//					"		select '대여료' gubun2, b.bus_id2, 0 tot_amt, sum("+est_amt2+") three_amt, 0 dly_amt, 0 dly_su"+
//					"		from scd_fee a, cont b, users c,"+
//					"			(select a.rent_mng_id, a.rent_l_cd"+
//					"				from scd_fee a, cont b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.fee_tm > decode(sign(to_date('20080514','YYYYMMDD')-to_date(b.rent_dt,'YYYYMMDD')),1,'3','4') and a.rc_yn='0' and a.r_fee_est_dt < to_char(sysdate,'YYYYMMDD')"+//3회차이후연체
//					"				group by a.rent_mng_id, a.rent_l_cd) e,"+
//					"			(select a.rent_mng_id, a.rent_l_cd"+
//					"				from scd_fee a, cont b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.fee_tm = decode(sign(to_date('20080514','YYYYMMDD')-to_date(b.rent_dt,'YYYYMMDD')),1,'3','4') and a.rc_yn='0' and a.r_fee_est_dt >= to_char(sysdate,'YYYYMMDD')"+//3회차 미연체
//					"			    group by a.rent_mng_id, a.rent_l_cd) f"+
//					"		where a.rent_l_cd=b.rent_l_cd and b.bus_id2=c.user_id and c.br_id<>'S1'"+
//					"       and a.rent_l_cd=e.rent_l_cd(+)"+
//					"		and a.rent_l_cd=f.rent_l_cd(+) "+
//					"		and (e.rent_l_cd is not null or f.rent_l_cd is not null) "+
//							condition2+""+
//					"		group by b.bus_id2 \n"+
					"		union all"+
					"		select '과태료' gubun2, decode(a.rent_s_cd,'',decode(a.fault_st,'2',nvl(a.fault_nm,b.bus_id2),b.bus_id2), decode(c.rent_st,'1',c.bus_id,'9',c.bus_id, '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) bus_id2, sum("+est_amt3+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt3+",'YYYYMMDD')-sysdate),-1,decode("+est_dt3+","+settle_dt+",0,"+est_amt3+")))"+magni+" dly_amt, count(decode(sign(to_date("+est_dt3+",'YYYYMMDD')-sysdate),-1,decode("+est_dt1+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from fine a, cont b, rent_cont c, cont d"+
					"		where a.rent_l_cd=b.rent_l_cd and a.rent_s_cd=c.rent_s_cd(+) and c.sub_l_cd=d.rent_l_cd(+)  "+condition3+""+
					"		group by decode(a.rent_s_cd,'',decode(a.fault_st,'2',nvl(a.fault_nm,b.bus_id2),b.bus_id2), decode(c.rent_st,'1',c.bus_id,'9',c.bus_id, '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) \n"+
					"		union all"+
					"		select '면책금' gubun2, decode(e.rent_s_cd,'',b.bus_id2, decode(c.rent_st,'1',c.bus_id,'9',c.bus_id, '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) bus_id2, sum("+est_amt4+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt4+",'YYYYMMDD')-sysdate),-1,decode("+est_dt4+","+settle_dt+",0,"+est_amt4+")))"+magni+" dly_amt, count(decode(sign(to_date("+est_dt4+",'YYYYMMDD')-sysdate),-1,decode("+est_dt4+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from service a, accident e, cont b, rent_cont c, cont d, scd_ext se"+
					"		where se.ext_st = '3' and se.rent_mng_id = a.rent_mng_id and se.rent_l_cd = a.rent_l_cd and se.ext_id = a.serv_id and a.car_mng_id=e.car_mng_id and a.accid_id=e.accid_id and se.rent_mng_id=b.rent_mng_id and se.rent_l_cd=b.rent_l_cd and e.rent_s_cd=c.rent_s_cd(+) and c.sub_l_cd=d.rent_l_cd(+) "+condition4+""+
					"		group by decode(e.rent_s_cd,'',b.bus_id2, decode(c.rent_st,'1',c.bus_id,'9',c.bus_id, '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) \n"+
//					"		select '면책금' gubun2, decode(e.rent_s_cd,'',b.bus_id2, decode(c.rent_st,'1',c.bus_id,'9',c.bus_id,'2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) bus_id2, sum("+est_amt4+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt4+",'YYYYMMDD')-sysdate),-1,decode("+est_dt4+","+settle_dt+",0,"+est_amt4+")))"+magni+" dly_amt, count(decode(sign(to_date("+est_dt4+",'YYYYMMDD')-sysdate),-1,decode("+est_dt4+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
//					"		from service a, accident e, cont b, rent_cont c, cont d"+
//					"		where a.car_mng_id=e.car_mng_id and a.accid_id=e.accid_id and a.rent_l_cd=b.rent_l_cd and e.rent_s_cd=c.rent_s_cd(+) and c.sub_l_cd=d.rent_l_cd(+) "+condition4+""+
//					"		group by decode(e.rent_s_cd,'',b.bus_id2, decode(c.rent_st,'1',c.bus_id,'9',c.bus_id,'2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id))"+
//							휴차료는 사원별 미수금 관리 제외				
//					"		union all"+
//					"		select '휴차료' gubun2, c.bus_id2, sum("+est_amt5+") tot_amt, sum(decode(sign(to_date("+est_dt5+",'YYYYMMDD')-sysdate),-1,"+est_amt5+")) dly_amt, count(decode(sign(to_date("+est_dt5+",'YYYYMMDD')-sysdate),-1,a.car_mng_id)) dly_su"+
//					" 		from my_accid a, accident b, cont c"+
//					"		where a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and b.rent_l_cd=c.rent_l_cd "+condition5+""+
//					"		group by c.bus_id2"+
					"		union all"+
					"		select '위약금' gubun2, c.bus_id2, sum("+est_amt_n6+") tot_amt, 0 three_amt, trunc(sum(decode(sign(to_date("+est_dt6+",'YYYYMMDD')-sysdate),-1,decode("+est_dt6+","+settle_dt+",0,"+est_amt_n6+"))) "+magni2+") dly_amt, count(decode(sign(to_date("+est_dt6+",'YYYYMMDD')-sysdate),-1,decode("+est_dt6+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_ext a, cls_cont b, cont c, (select a.* from gua_ins a, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, max(gi_dt) gi_dt from gua_ins group by rent_mng_id, rent_l_cd) b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st and a.gi_dt=b.gi_dt) d"+
					"		where a.ext_st = '4' and a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+) "+condition6+""+
					"		group by c.bus_id2 \n"+
					"		union all"+
					"		select '단기요금' gubun2, b.bus_id bus_id2, sum("+est_amt7+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt7+",'YYYYMMDD')-sysdate),-1,decode("+est_dt7+","+settle_dt+",0,"+est_amt7+"))) dly_amt, count(decode(sign(to_date("+est_dt7+",'YYYYMMDD')-sysdate),-1,decode("+est_dt7+","+settle_dt+",'',a.rent_s_cd))) dly_su"+
					"		from scd_rent a, rent_cont b"+
					"		where a.rent_s_cd=b.rent_s_cd "+condition7+""+
					"		group by b.bus_id \n"+
					"		union all"+
					"		select '휴/대차료-청구' gubun2, c.bus_id2, 0 tot_amt, 0 three_amt, -sum(a.req_amt) dly_amt, 0 dly_su"+
					" 		from my_accid a, accident b, cont c"+
					"		where a.req_dt between '"+var6+"' and '"+var3+"' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd "+
					"		group by c.bus_id2"+
					"		union all"+
					"		select '휴/대차료-입금' gubun2, c.bus_id2, 0 tot_amt, 0 three_amt, -sum(a.pay_amt) dly_amt, 0 dly_su"+
					" 		from my_accid a, accident b, cont c"+
					"		where a.pay_dt between '"+var6+"' and '"+var3+"' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd "+
					"		group by c.bus_id2"+
					"	)group by bus_id2 \n"+
					" ) a, users b, branch c, (select * from code where c_st='0002') d, (select * from stat_settle where save_dt='"+eff_dt+"') e \n"+
					" where b.user_id <> '000001' and a.bus_id2=b.user_id and b.br_id=c.br_id and b.dept_id=d.code and a.bus_id2=e.bus_id2(+)";

			query += " order by a.dly_per, a.dly_amt";

		}else{

			query = " select a.*, 0 tot_su, c.br_id, c.dept_id, e.per1 as per_0405 from stat_settle a, users c, (select bus_id2, per1 from stat_settle where save_dt='"+eff_dt+"') e where a.bus_id2=c.user_id and a.save_dt='"+save_dt+"' and a.bus_id2=e.bus_id2(+)";

			query += " and c.loan_st='1' and c.user_id not in ('000079')";

			query += " order by a.seq , a.amt desc";
		}

		//리스트 확인용
		String query2 = "";

		query2 = " select \n"+
					" * \n"+
					" from \n"+
					" ( \n"+
					"		select '선수금' gubun2, c.bus_id2, sum("+est_amt1+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt1+",'YYYYMMDD')-sysdate),-1,decode("+est_dt1+","+settle_dt+",0,"+est_amt1+"))) dly_amt, count(decode(sign(to_date("+est_dt1+",'YYYYMMDD')-sysdate),-1,decode("+est_dt1+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_ext a, fee b, cont c"+
					"		where a.ext_st in ('0', '1', '2' ) and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd=c.rent_l_cd "+condition1+""+
					"		group by c.bus_id2 \n"+
					"		union all"+
					"		select '대여료' gubun2, b.bus_id2, trunc(sum("+est_amt_n2+")) tot_amt, 0 three_amt, trunc( sum(decode(sign(to_date("+est_dt2+",'YYYYMMDD')-sysdate),-1,decode("+est_dt2+","+settle_dt+",0,"+est_amt_n2+")))) dly_amt, count(decode(sign(to_date("+est_dt2+",'YYYYMMDD')-sysdate),-1,decode("+est_dt2+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_fee a, cont b, (select a.rent_mng_id, a.rent_l_cd, count(0) in_cnt from car_call_in a, cont b where a.out_dt is null and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(b.use_yn,'Y')='Y' and b.car_st<>'4' group by a.rent_mng_id, a.rent_l_cd) c "+
					"		where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) "+
					"       "+condition2+""+
					"		group by b.bus_id2 \n"+
//					"		union all"+//부산/대전-직전3,4개월인 총받을어음
//					"		select '대여료' gubun2, b.bus_id2, 0 tot_amt, sum("+est_amt2+") three_amt, 0 dly_amt, 0 dly_su"+
//					"		from scd_fee a, cont b, users c,"+
//					"			(select a.rent_mng_id, a.rent_l_cd"+
//					"				from scd_fee a, cont b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.fee_tm > decode(sign(to_date('20080514','YYYYMMDD')-to_date(b.rent_dt,'YYYYMMDD')),1,'3','4') and a.rc_yn='0' and a.r_fee_est_dt < to_char(sysdate,'YYYYMMDD')"+//3회차이후연체
//					"				group by a.rent_mng_id, a.rent_l_cd) e,"+
//					"			(select a.rent_mng_id, a.rent_l_cd"+
//					"				from scd_fee a, cont b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.fee_tm = decode(sign(to_date('20080514','YYYYMMDD')-to_date(b.rent_dt,'YYYYMMDD')),1,'3','4') and a.rc_yn='0' and a.r_fee_est_dt >= to_char(sysdate,'YYYYMMDD')"+//3회차 미연체
//					"			    group by a.rent_mng_id, a.rent_l_cd) f"+
//					"		where a.rent_l_cd=b.rent_l_cd and b.bus_id2=c.user_id and c.br_id<>'S1'"+
//					"       and a.rent_l_cd=e.rent_l_cd(+)"+
//					"		and a.rent_l_cd=f.rent_l_cd(+) "+
//					"		and (e.rent_l_cd is not null or f.rent_l_cd is not null) "+
//							condition2+""+
//					"		group by b.bus_id2 \n"+
					"		union all"+
					"		select '과태료' gubun2, decode(a.rent_s_cd,'',decode(a.fault_st,'2',nvl(a.fault_nm,b.bus_id2),b.bus_id2), decode(c.rent_st,'1',c.bus_id,'9',c.bus_id, '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) bus_id2, sum("+est_amt3+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt3+",'YYYYMMDD')-sysdate),-1,decode("+est_dt3+","+settle_dt+",0,"+est_amt3+")))"+magni+" dly_amt, count(decode(sign(to_date("+est_dt3+",'YYYYMMDD')-sysdate),-1,decode("+est_dt1+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from fine a, cont b, rent_cont c, cont d"+
					"		where a.rent_l_cd=b.rent_l_cd and a.rent_s_cd=c.rent_s_cd(+) and c.sub_l_cd=d.rent_l_cd(+)  "+condition3+""+
					"		group by decode(a.rent_s_cd,'',decode(a.fault_st,'2',nvl(a.fault_nm,b.bus_id2),b.bus_id2), decode(c.rent_st,'1',c.bus_id,'9',c.bus_id, '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) \n"+
					"		union all"+
					"		select '면책금' gubun2, decode(e.rent_s_cd,'',b.bus_id2, decode(c.rent_st,'1',c.bus_id,'9',c.bus_id, '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) bus_id2, sum("+est_amt4+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt4+",'YYYYMMDD')-sysdate),-1,decode("+est_dt4+","+settle_dt+",0,"+est_amt4+")))"+magni+" dly_amt, count(decode(sign(to_date("+est_dt4+",'YYYYMMDD')-sysdate),-1,decode("+est_dt4+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from service a, accident e, cont b, rent_cont c, cont d, scd_ext se"+
					"		where se.ext_st = '3' and se.rent_mng_id = a.rent_mng_id and se.rent_l_cd = a.rent_l_cd and se.ext_id = a.serv_id and a.car_mng_id=e.car_mng_id and a.accid_id=e.accid_id and se.rent_mng_id=b.rent_mng_id and se.rent_l_cd=b.rent_l_cd and e.rent_s_cd=c.rent_s_cd(+) and c.sub_l_cd=d.rent_l_cd(+) "+condition4+""+
					"		group by decode(e.rent_s_cd,'',b.bus_id2, decode(c.rent_st,'1',c.bus_id,'9',c.bus_id, '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) \n"+
//					"		select '면책금' gubun2, decode(e.rent_s_cd,'',b.bus_id2, decode(c.rent_st,'1',c.bus_id,'9',c.bus_id,'2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) bus_id2, sum("+est_amt4+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt4+",'YYYYMMDD')-sysdate),-1,decode("+est_dt4+","+settle_dt+",0,"+est_amt4+")))"+magni+" dly_amt, count(decode(sign(to_date("+est_dt4+",'YYYYMMDD')-sysdate),-1,decode("+est_dt4+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
//					"		from service a, accident e, cont b, rent_cont c, cont d"+
//					"		where a.car_mng_id=e.car_mng_id and a.accid_id=e.accid_id and a.rent_l_cd=b.rent_l_cd and e.rent_s_cd=c.rent_s_cd(+) and c.sub_l_cd=d.rent_l_cd(+) "+condition4+""+
//					"		group by decode(e.rent_s_cd,'',b.bus_id2, decode(c.rent_st,'1',c.bus_id,'9',c.bus_id,'2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id))"+
//							휴차료는 사원별 미수금 관리 제외				
//					"		union all"+
//					"		select '휴차료' gubun2, c.bus_id2, sum("+est_amt5+") tot_amt, sum(decode(sign(to_date("+est_dt5+",'YYYYMMDD')-sysdate),-1,"+est_amt5+")) dly_amt, count(decode(sign(to_date("+est_dt5+",'YYYYMMDD')-sysdate),-1,a.car_mng_id)) dly_su"+
//					" 		from my_accid a, accident b, cont c"+
//					"		where a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and b.rent_l_cd=c.rent_l_cd "+condition5+""+
//					"		group by c.bus_id2"+
					"		union all"+
					"		select '위약금' gubun2, c.bus_id2, sum("+est_amt_n6+") tot_amt, 0 three_amt, trunc(sum(decode(sign(to_date("+est_dt6+",'YYYYMMDD')-sysdate),-1,decode("+est_dt6+","+settle_dt+",0,"+est_amt_n6+"))) "+magni2+") dly_amt, count(decode(sign(to_date("+est_dt6+",'YYYYMMDD')-sysdate),-1,decode("+est_dt6+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_ext a, cls_cont b, cont c, (select a.* from gua_ins a, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, max(gi_dt) gi_dt from gua_ins group by rent_mng_id, rent_l_cd) b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st and a.gi_dt=b.gi_dt) d"+
					"		where a.ext_st = '4' and a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+) "+condition6+""+
					"		group by c.bus_id2 \n"+
					"		union all"+
					"		select '단기요금' gubun2, b.bus_id bus_id2, sum("+est_amt7+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt7+",'YYYYMMDD')-sysdate),-1,decode("+est_dt7+","+settle_dt+",0,"+est_amt7+"))) dly_amt, count(decode(sign(to_date("+est_dt7+",'YYYYMMDD')-sysdate),-1,decode("+est_dt7+","+settle_dt+",'',a.rent_s_cd))) dly_su"+
					"		from scd_rent a, rent_cont b"+
					"		where a.rent_s_cd=b.rent_s_cd "+condition7+""+
					"		group by b.bus_id \n"+
					"		union all"+
					"		select '휴/대차료-청구' gubun2, c.bus_id2, 0 tot_amt, 0 three_amt, -sum(a.req_amt) dly_amt, 0 dly_su"+
					" 		from my_accid a, accident b, cont c"+
					"		where a.req_dt between '"+var6+"' and '"+var3+"' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd "+
					"		group by c.bus_id2"+
					"		union all"+
					"		select '휴/대차료-입금' gubun2, c.bus_id2, 0 tot_amt, 0 three_amt, -sum(a.pay_amt) dly_amt, 0 dly_su"+
					" 		from my_accid a, accident b, cont c"+
					"		where a.pay_dt between '"+var6+"' and '"+var3+"' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd "+
					"		group by c.bus_id2"+
					" \n ) "+
					"	";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
	    	
			while(rs.next())
			{
				IncomingSBean fee = new IncomingSBean();
				fee.setGubun(rs.getString("bus_id2"));
				fee.setBr_id(rs.getString("br_id"));
				fee.setDept_id(rs.getString("dept_id"));
				fee.setTot_amt1(rs.getString("tot_amt"));
				fee.setTot_su2(rs.getString("su"));
				fee.setTot_amt2(rs.getString("amt"));
				fee.setTot_su3(rs.getString("per1"));
				fee.setTot_su4(rs.getString("per2")==null?"":rs.getString("per2"));
				fee.setTot_su5(rs.getString("per_0405")==null?"":rs.getString("per_0405"));
				fee.setTot_amt3(rs.getString("three_amt")==null?"":rs.getString("three_amt"));
				vt.add(fee);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[SettleDatabase:getStatSettleList_20080714]"+e);
			System.out.println("[SettleDatabase:getStatSettleList_20080714]"+query);
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
	 *	거래처별매출현황
	 *	2009.01.02. jhm
	 */
	public Vector getClienfSettleLcFee(String ven_code, String st_dt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select '대여료' gubun, \n"+
                "        decode(d.use_yn,'N','해지','대여') use_yn, \n"+
                "        decode(a.bill_yn,'N','대손','-') bill_yn, \n"+
                "        decode(b.tax_no,'','미발행','발행') tax_yn, \n"+
                "		 decode(d.tax_type,'2',decode( TEXT_DECRYPT(f.enp_no, 'pw' ),  '',decode(e.client_st,'2',TEXT_DECRYPT(e.ssn, 'pw' ) ,e.ENP_NO), TEXT_DECRYPT(f.enp_no, 'pw' )  ),  decode(e.client_st,'2',TEXT_DECRYPT(e.ssn, 'pw' ),e.ENP_NO)) enp_no, \n"+
                "		 decode(d.tax_type,'2',decode(f.site_jang,'',decode(e.client_st,'2','',e.client_nm),f.site_jang),decode(e.client_st,'2','',e.client_nm)) client_nm, \n"+
                "		 decode(d.tax_type,'2',decode(f.r_site,   '',e.firm_nm, f.r_site), e.firm_nm ) firm_nm, \n"+
                "		 decode(d.tax_type,'2',decode(f.ven_code, '',e.ven_code, f.ven_code), e.ven_code ) ven_code, \n"+
                "        b.tax_no, b.tax_dt, g.car_no, \n"+
                "        a.rent_l_cd, a.fee_tm, a.fee_est_dt, a.rc_dt, a.tax_out_dt, a.use_s_dt, a.use_e_dt, a.fee_s_amt, a.fee_v_amt, (a.fee_s_amt+a.fee_v_amt) fee_amt, a.rc_amt \n"+
                " from   scd_fee a, \n"+
                "        (select b.tax_no, b.tax_dt, a.* from tax_item_list a, tax b where a.item_id=b.item_id and b.tax_st='O' and a.gubun='1') b, \n"+
                "        cont d, client e, client_site f, car_reg g \n"+
                " where \n"+
                "        a.rent_l_cd=b.rent_l_cd(+) and a.fee_tm=b.tm(+) \n"+
                "        and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd \n"+
                "        and d.client_id=e.client_id \n"+
                "        and d.client_id=f.client_id(+) and d.r_site=f.seq(+) \n"+
				"        and d.car_mng_id=g.car_mng_id(+) \n"+
				"        and decode(d.tax_type,'2',decode(f.ven_code, '',e.ven_code, f.ven_code), e.ven_code )='"+ven_code+"' \n";

		if(!st_dt.equals(""))		query += " and a.fee_est_dt like '"+st_dt+"%'";

        query += " order by a.r_fee_est_dt, d.rent_dt \n";


		try {
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
			System.out.println("[SettleDatabase:getClienfSettleLcFee]\n"+e);
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

	/**
	 *	거래처별매출현황
	 *	2009.01.02. jhm
	 */
	public Vector getClienfSettleLcCls(String ven_code, String st_dt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select '위약금' gubun, \n"+
                "        decode(d.use_yn,'N','해지','대여') use_yn, \n"+
                "        decode(a.bill_yn,'N','대손','-') bill_yn, \n"+
                "        decode(b.rent_l_cd,'','미발행','발행') tax_yn, \n"+
                "		 decode(d.tax_type,'2',decode(TEXT_DECRYPT(f.enp_no, 'pw' ),   '',decode(e.client_st,'2',TEXT_DECRYPT(e.ssn, 'pw' ) ,e.ENP_NO), TEXT_DECRYPT(f.enp_no, 'pw' )),   decode(e.client_st,'2',e.ssn,e.ENP_NO)) enp_no, \n"+
                "		 decode(d.tax_type,'2',decode(f.site_jang,'',decode(e.client_st,'2','',e.client_nm),f.site_jang),decode(e.client_st,'2','',e.client_nm)) client_nm, \n"+
                "		 decode(d.tax_type,'2',decode(f.r_site,   '',e.firm_nm, f.r_site), e.firm_nm ) firm_nm, \n"+
                "		 decode(d.tax_type,'2',decode(f.ven_code, '',e.ven_code, f.ven_code), e.ven_code ) ven_code, \n"+
                "        h.car_no, \n"+
                "        a.rent_l_cd, a.ext_tm, a.ext_est_dt, a.ext_s_amt, a.ext_v_amt, (a.ext_s_amt+a.ext_v_amt) ext_amt, a.ext_pay_dt, a.ext_pay_amt \n"+
                " from   scd_ext a, \n"+
                "        (select b.rent_l_cd from tax b where b.tax_st='O' and b.tax_g like '%해지%' group by b.rent_l_cd) b, \n"+
                "        cont d, client e, client_site f, car_reg h \n"+
                " where \n"+
                "        a.ext_st in ('4') \n"+
                "        and a.ext_s_amt !=0 \n"+
                "        and a.rent_l_cd=b.rent_l_cd(+) \n"+
                "        and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd \n"+
                "        and d.client_id=e.client_id \n"+
                "        and d.client_id=f.client_id(+) and d.r_site=f.seq(+) \n"+
				"        and d.car_mng_id=h.car_mng_id \n"+
				"        and decode(d.tax_type,'2',decode(f.ven_code, '',e.ven_code, f.ven_code), e.ven_code )='"+ven_code+"' \n";


		if(!st_dt.equals(""))		query += " and a.ext_est_dt like '"+st_dt+"%'";

        query += " order by a.ext_est_dt, d.rent_dt \n";


		try {
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
			System.out.println("[SettleDatabase:getClienfSettleLcCls]\n"+e);
			System.out.println("[SettleDatabase:getClienfSettleLcCls]\n"+query);
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

	/**
	 *	거래처별매출현황
	 *	2009.01.02. jhm
	 */
	public Vector getClienfSettleLcPp(String ven_code, String st_dt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select '선수금' gubun, \n"+
                "         decode(d.use_yn,'N','해지','대여') use_yn, \n"+
                "         decode(a.bill_yn,'N','대손','-') bill_yn, \n"+
                "         decode(b.tax_no,'','미발행','발행') tax_yn, \n"+
             "	    	 decode(d.tax_type,'2',decode(TEXT_DECRYPT(f.enp_no, 'pw' ),   '',decode(e.client_st,'2',TEXT_DECRYPT(e.ssn, 'pw' ) ,e.ENP_NO), TEXT_DECRYPT(f.enp_no, 'pw' )),   decode(e.client_st,'2',e.ssn,e.ENP_NO)) enp_no, \n"+
				"         decode(d.tax_type,'2',decode(f.site_jang,'',decode(e.client_st,'2','',e.client_nm),f.site_jang),decode(e.client_st,'2','',e.client_nm)) client_nm, \n"+
				"         decode(d.tax_type,'2',decode(f.r_site,   '',e.firm_nm, f.r_site), e.firm_nm ) firm_nm, \n"+
				"         decode(d.tax_type,'2',decode(f.ven_code, '',e.ven_code, f.ven_code), e.ven_code ) ven_code, \n"+
                "         b.tax_no, b.tax_dt, h.car_no, \n"+
                "         a.rent_l_cd, a.ext_tm, a.ext_est_dt, a.ext_s_amt, a.ext_v_amt, (a.ext_s_amt+a.ext_v_amt) ext_amt, a.ext_pay_dt, a.ext_pay_amt \n"+
                " from    scd_ext a, \n"+
                "         (select b.tax_no, b.tax_dt, a.* from tax_item_list a, tax b where a.item_id=b.item_id and b.tax_st='O' and a.gubun in ('3','4')) b, \n"+
                "         cont d, client e, client_site f, car_reg h \n"+
                " where \n"+
                " a.ext_st in ('1','2') and a.ext_s_amt !=0 \n"+
                " and a.rent_l_cd=b.rent_l_cd(+) and decode(a.ext_st,'1','3','2','4')=b.gubun(+) and a.rent_st=b.tm(+) \n"+
                " and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd \n"+
                " and d.client_id=e.client_id \n"+
                " and d.client_id=f.client_id(+) and d.r_site=f.seq(+) \n"+
				" and d.car_mng_id=h.car_mng_id(+)"+
				" and decode(d.tax_type,'2',decode(f.ven_code, '',e.ven_code, f.ven_code), e.ven_code )='"+ven_code+"' \n";


		if(!st_dt.equals(""))		query += " and a.ext_est_dt like '"+st_dt+"%'";

        query += " order by a.ext_est_dt, d.rent_dt \n";


		try {
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
			System.out.println("[SettleDatabase:getClienfSettleLcPp]\n"+e);
			System.out.println("[SettleDatabase:getClienfSettleLcPp]\n"+query);
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

	/**
	 *	미수금 세부내용 - 계약정보
	 */
	public Hashtable getSettleMyInsAmtStat(String s_kd, String t_wd, String var3, String var6)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "", sub_query = "";

		//청구   20120126 2012년1분기부터 청구일+5일 청구금액에서 청구일+3개월 청구금액 10%로 변경
		//입금   20120126 2012년1분기부터 입금경감은 없음
		//미입금 20120126 2012년1분기부터 청구일 2개월경과 1달동안 경감에서 3개월경과 3달동안으로 변경

		sub_query= 	" select '휴/대차료-청구' gubun2, nvl(a.bus_id2,c.bus_id2) bus_id2, 0 tot_amt, 0 three_amt, 0 dly_su, count(a.accid_id) cnt, \n"+
//					"        -sum(d.ext_s_amt+d.ext_v_amt) dly_amt "+
					" 		 -round(sum((d.ext_s_amt+d.ext_v_amt)*decode(u.loan_st, '1', 0.1, 0.05))) dly_amt "+
					" from   my_accid a, accident b, cont c, users u, (select * from scd_ext where ext_st='6' and ext_tm='1' and (ext_s_amt+ext_v_amt)>0 ) d"+
					" where  "+
					"        to_char(sysdate,'YYYYMMdd') <>  '"+var3+"' "+	                           
					" and    a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd "+
					" and    b.rent_mng_id=d.rent_mng_id and b.rent_l_cd=d.rent_l_cd "+
                    " and    a.accid_id||to_char(a.seq_no)=d.ext_id "+
//					" and    to_char(sysdate,'YYYYMMdd')  between nvl(d.ext_est_dt,a.req_dt) and to_char(to_date(nvl(d.ext_est_dt,a.req_dt)) + 5 , 'yyyymmdd')  \n"+
					" and    to_char(sysdate,'YYYYMMdd')  between nvl(d.ext_est_dt,a.req_dt) and to_char(add_months(to_date(nvl(d.ext_est_dt,a.req_dt)), 1), 'yyyymmdd') \n"+
					" and    nvl(a.bus_id2,c.bus_id2)=u.user_id \n"+
					" group by nvl(a.bus_id2,c.bus_id2) \n"+
/*
					" union all"+

					" select '휴/대차료-입금' gubun2, nvl(a.bus_id2,c.bus_id2) bus_id2, 0 tot_amt, 0 three_amt, 0 dly_su, count(a.accid_id) cnt, \n"+
					"        -sum(d.ext_pay_amt) dly_amt "+
					" from   my_accid a, accident b, cont c, (select * from scd_ext where ext_st='6' and ext_pay_dt is not null ) d"+
					" where  "+
//					"        to_char(sysdate,'YYYYMMdd') <>  '"+var3+"' "+	
					"        a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd "+
					" and    b.rent_mng_id=d.rent_mng_id and b.rent_l_cd=d.rent_l_cd "+
                    " and    a.accid_id||to_char(a.seq_no)=d.ext_id "+
					" and    to_char(sysdate,'YYYYMMdd')  between d.ext_pay_dt  and to_char(to_date(d.ext_pay_dt) + 10 , 'yyyymmdd')  \n"+
					" group by nvl(a.bus_id2,c.bus_id2) \n"+
*/
					" union all"+

					" select '휴/대차료-청구미입금' gubun2, nvl(a.bus_id2,c.bus_id2) bus_id2, 0 tot_amt, 0 three_amt, 0 dly_su, count(a.accid_id) cnt, \n"+
					"        round(sum(a.req_amt*decode(u.loan_st, '1', 0.1, 0.05))) dly_amt "+
					" from   my_accid a, accident b, cont c, users u, (select * from scd_ext where ext_st='6' and ext_tm='1' and ext_pay_dt is null and (ext_s_amt+ext_v_amt)>0 ) d"+
					" where  "+
					"        to_char(sysdate,'YYYYMMdd') <>  '"+var3+"' "+	                           
					" and    a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd "+
					" and    b.rent_mng_id=d.rent_mng_id and b.rent_l_cd=d.rent_l_cd "+
                    " and    a.accid_id||to_char(a.seq_no)=d.ext_id "+
//                  " and    to_char(sysdate,'YYYYMMdd')  between to_char(add_months(to_date(nvl(d.ext_est_dt,a.req_dt)), 2) , 'yyyymmdd') and to_char(add_months(to_date(nvl(d.ext_est_dt,a.req_dt)), 3), 'yyyymmdd') "+
					" and    to_char(sysdate,'YYYYMMdd')  between to_char(add_months(to_date(nvl(d.ext_est_dt,a.req_dt)), 1) , 'yyyymmdd') and to_char(add_months(to_date(nvl(d.ext_est_dt,a.req_dt)), 2), 'yyyymmdd') \n"+
					" and    nvl(a.bus_id2,c.bus_id2)=u.user_id \n"+
					" group by nvl(a.bus_id2,c.bus_id2) \n"+
/*
					" union all"+

					" select '경락손해-입금' gubun2, nvl(a.amor_req_id,c.bus_id2) bus_id2, 0 tot_amt, 0 three_amt, 0 dly_su, count(a.accid_id) cnt, \n"+
					"        -sum(a.amor_pay_amt) dly_amt "+
					" from   ot_accid a, accident b, cont c"+
					" where  "+
					"        a.amor_type='1' AND a.amor_pay_amt>0 AND a.amor_pay_dt IS NOT NULL AND b.SETTLE_ST ='1' \n"+
					" and    a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd "+
					" and    to_char(sysdate,'YYYYMMdd')  between a.amor_pay_dt  and to_char(to_date(a.amor_pay_dt) + 10 , 'yyyymmdd')  \n"+
					" group by nvl(a.amor_req_id,c.bus_id2) \n"+
*/
					" ";

		//입금   20140225 청구가 아닌 입금으로, 입금일+1개월, 1군50% 2군25%

		sub_query= 	" select '휴/대차료-입금' gubun2, nvl(a.bus_id2,c.bus_id2) bus_id2, 0 tot_amt, 0 three_amt, 0 dly_su, count(a.accid_id) cnt, \n"+
					" 		 -round(sum((d.ext_pay_amt)*decode(u.loan_st, '1', 0.5, 0.25))) dly_amt "+
					" from   my_accid a, accident b, cont c, users u, (select * from scd_ext where ext_st='6' and ext_pay_dt is not null) d"+
					" where  "+
					"        to_char(sysdate,'YYYYMMdd') <>  '"+var3+"' "+	                           
					" and    a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd "+
					" and    b.rent_mng_id=d.rent_mng_id and b.rent_l_cd=d.rent_l_cd "+
                    " and    a.accid_id||to_char(a.seq_no)=d.ext_id "+
					" and    to_char(sysdate,'YYYYMMdd') between d.ext_pay_dt  and to_char(add_months(to_date(d.ext_pay_dt), 1) , 'yyyymmdd') \n"+
					" and    nvl(a.bus_id2,c.bus_id2)=u.user_id \n"+
					" group by nvl(a.bus_id2,c.bus_id2) \n"+
					" ";



		query = 	" select sum(cnt) cnt, sum(dly_amt) amt from ("+sub_query+")";

		if(s_kd.equals("8") && !t_wd.equals("")){
			query += " where bus_id2='"+t_wd+"'";
		}


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
			System.out.println("[SettleDatabase:getSettleMyInsAmtStat]"+e);
			System.out.println("[SettleDatabase:getSettleMyInsAmtStat]"+query);
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
	 *	미수금 세부내용 - 계약정보
	 */
	public Hashtable getSettleClsGuaInsAmtStat(String s_kd, String t_wd, String var3, String var6)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "", sub_query = "";

//		query= "select 0 cnt, 0 amt from dual";

		sub_query= 	" 		select '위약금' gubun2, c.bus_id2, count(d.rent_l_cd) cnt, "+
//					"       sum(decode(nvl(d.gi_amt,0),0,0,decode(sign(d.gi_amt-a.ext_s_amt+a.ext_v_amt),-1,d.gi_amt,a.ext_s_amt+a.ext_v_amt))) dly_amt"+
					"       sum((case when d.gi_amt >0  then (a.ext_s_amt+a.ext_v_amt)-decode(sign(d.gi_amt-a.ext_s_amt+a.ext_v_amt),-1,d.gi_amt,a.ext_s_amt+a.ext_v_amt) else (a.ext_s_amt+a.ext_v_amt)  end)) dly_amt"+
					"		from scd_ext a, cls_cont b, cont c, (select a.* from gua_ins a, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, max(gi_dt) gi_dt from gua_ins group by rent_mng_id, rent_l_cd) b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st and a.gi_dt=b.gi_dt) d"+
					"		where a.ext_st = '4' and a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+)"+
					"       "+condition6+""+
					"		group by c.bus_id2 \n";

		query = 	" select sum(cnt) cnt, sum(dly_amt) amt from ("+sub_query+")";

		if(s_kd.equals("8") && !t_wd.equals("")){
			query += " where bus_id2='"+t_wd+"'";
		}



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
			System.out.println("[SettleDatabase:getSettleClsGuaInsAmtStat]"+e);
			System.out.println("[SettleDatabase:getSettleClsGuaInsAmtStat]"+query);
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
	 *	미수금현황 리스트-채권1 ) - 평균연체율 적용
	 */
	public Vector getStatSettleList_20090312(String brch_id, String dept_id, String save_dt, String eff_dt, String var3, String var6, String var8, String var9)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String magni = "";//5배할증  *5 -> 20131021 할증해제
		String magni2 = "*0.1";//0.1배할증
		String settle_dt = "to_char(sysdate,'YYYYMMDD')";

		if(save_dt.equals("")){

			query = " select "+
					"	b.br_id, b.dept_id, a.bus_id2, c.br_nm, d.nm, b.user_nm, b.user_pos,"+
					"	a.tot_amt, nvl(a.three_amt,0) as three_amt, case when nvl(a.dly_amt,0) < 0 then 0 else nvl(a.dly_amt,0) end  as amt, a.dly_su as su, "+
					"	case when 	a.dly_per < 0 then 0 else a.dly_per end as per1, '' per2, nvl(e.per1,0) per_0405,"+
					"   nvl(f.avg_per,0) avg_per, "+
					"   trunc(decode(case when 	a.dly_per < 0 then 0 else a.dly_per end,0,0,'',0,a.dly_per*"+var8+")+decode(f.avg_per,0,0,'',0,f.avg_per*"+var9+"),2) cmp_per"+
					" from \n"+
					" ("+
					"	select"+
					"	bus_id2, sum(tot_amt) tot_amt, sum(dly_amt) dly_amt, sum(dly_su) dly_su, sum(three_amt) three_amt,"+
					"	nvl(trunc((sum(dly_amt)/sum(tot_amt)*100),2),0) dly_per"+
					"	from \n"+
					"	("+
					"		select '선수금' gubun2, c.bus_id2, sum("+est_amt1+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt1+",'YYYYMMDD')-sysdate),-1,decode("+est_dt1+","+settle_dt+",0,"+est_amt1+"))) dly_amt, count(decode(sign(to_date("+est_dt1+",'YYYYMMDD')-sysdate),-1,decode("+est_dt1+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_ext a, fee b, cont c"+
					"		where a.ext_st in ('0', '1', '2' ) and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd=c.rent_l_cd "+condition1+""+
					"		group by c.bus_id2 \n"+
					"		union all"+
					"		select '대여료' gubun2, b.bus_id2, trunc(sum("+est_amt_n2+")) tot_amt, 0 three_amt, trunc( sum(decode(sign(to_date("+est_dt2+",'YYYYMMDD')-sysdate),-1,decode("+est_dt2+","+settle_dt+",0,"+est_amt_n2+")))) dly_amt, count(decode(sign(to_date("+est_dt2+",'YYYYMMDD')-sysdate),-1,decode("+est_dt2+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_fee a, cont b, (select a.rent_mng_id, a.rent_l_cd, count(0) in_cnt from car_call_in a, cont b where a.out_dt is null and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(b.use_yn,'Y')='Y' and b.car_st<>'4' group by a.rent_mng_id, a.rent_l_cd) c "+
					"		where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) "+
					"       "+condition2+""+
					"		group by b.bus_id2 \n"+
//					"		union all"+//부산/대전-직전3,4개월인 총받을어음
//					"		select '대여료' gubun2, b.bus_id2, 0 tot_amt, sum("+est_amt2+") three_amt, 0 dly_amt, 0 dly_su"+
//					"		from scd_fee a, cont b, users c,"+
//					"			(select a.rent_mng_id, a.rent_l_cd"+
//					"				from scd_fee a, cont b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.fee_tm > decode(sign(to_date('20080514','YYYYMMDD')-to_date(b.rent_dt,'YYYYMMDD')),1,'3','4') and a.rc_yn='0' and a.r_fee_est_dt < to_char(sysdate,'YYYYMMDD')"+//3회차이후연체
//					"				group by a.rent_mng_id, a.rent_l_cd) e,"+
//					"			(select a.rent_mng_id, a.rent_l_cd"+
//					"				from scd_fee a, cont b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.fee_tm = decode(sign(to_date('20080514','YYYYMMDD')-to_date(b.rent_dt,'YYYYMMDD')),1,'3','4') and a.rc_yn='0' and a.r_fee_est_dt >= to_char(sysdate,'YYYYMMDD')"+//3회차 미연체
//					"			    group by a.rent_mng_id, a.rent_l_cd) f"+
//					"		where a.rent_l_cd=b.rent_l_cd and b.bus_id2=c.user_id and c.br_id<>'S1'"+
//					"       and a.rent_l_cd=e.rent_l_cd(+)"+
//					"		and a.rent_l_cd=f.rent_l_cd(+) "+
//					"		and (e.rent_l_cd is not null or f.rent_l_cd is not null) "+
//							condition2+""+
//					"		group by b.bus_id2 \n"+
					"		union all"+
					"		select '과태료' gubun2, decode(a.rent_s_cd,'',decode(a.fault_st,'2',nvl(a.fault_nm,b.bus_id2),b.bus_id2), decode(c.rent_st,'1',c.bus_id,'9',c.bus_id, '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) bus_id2, sum("+est_amt3+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt3+",'YYYYMMDD')-sysdate),-1,decode("+est_dt3+","+settle_dt+",0,"+est_amt3+")))"+magni+" dly_amt, count(decode(sign(to_date("+est_dt3+",'YYYYMMDD')-sysdate),-1,decode("+est_dt1+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from fine a, cont b, rent_cont c, cont d"+
					"		where a.rent_l_cd=b.rent_l_cd and a.rent_s_cd=c.rent_s_cd(+) and c.sub_l_cd=d.rent_l_cd(+)  "+condition3+""+
					"		group by decode(a.rent_s_cd,'',decode(a.fault_st,'2',nvl(a.fault_nm,b.bus_id2),b.bus_id2), decode(c.rent_st,'1',c.bus_id,'9',c.bus_id, '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) \n"+
					"		union all"+
					"		select '면책금' gubun2, decode(e.rent_s_cd,'',b.bus_id2, decode(c.rent_st,'1',c.bus_id,'9',c.bus_id, '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) bus_id2, sum("+est_amt4+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt4+",'YYYYMMDD')-sysdate),-1,decode("+est_dt4+","+settle_dt+",0,"+est_amt4+")))"+magni+" dly_amt, count(decode(sign(to_date("+est_dt4+",'YYYYMMDD')-sysdate),-1,decode("+est_dt4+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from service a, accident e, cont b, rent_cont c, cont d, scd_ext se"+
					"		where se.ext_st = '3' and se.rent_mng_id = a.rent_mng_id and se.rent_l_cd = a.rent_l_cd and se.ext_id = a.serv_id and a.car_mng_id=e.car_mng_id and a.accid_id=e.accid_id and se.rent_mng_id=b.rent_mng_id and se.rent_l_cd=b.rent_l_cd and e.rent_s_cd=c.rent_s_cd(+) and c.sub_l_cd=d.rent_l_cd(+) "+condition4+""+
					"		group by decode(e.rent_s_cd,'',b.bus_id2, decode(c.rent_st,'1',c.bus_id,'9',c.bus_id, '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) \n"+
					"		union all"+
					"		select '위약금' gubun2, c.bus_id2, sum("+est_amt_n6+") tot_amt, 0 three_amt, trunc(sum(decode(sign(to_date("+est_dt6+",'YYYYMMDD')-sysdate),-1,decode("+est_dt6+","+settle_dt+",0,"+est_amt_n6+"))) "+magni2+") dly_amt, count(decode(sign(to_date("+est_dt6+",'YYYYMMDD')-sysdate),-1,decode("+est_dt6+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_ext a, cls_cont b, cont c, (select a.* from gua_ins a, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, max(gi_dt) gi_dt from gua_ins group by rent_mng_id, rent_l_cd) b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st and a.gi_dt=b.gi_dt) d"+
					"		where a.ext_st = '4' and a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+) "+condition6+""+
					"		group by c.bus_id2 \n"+
					"		union all"+
					"		select '단기요금' gubun2, b.bus_id bus_id2, sum("+est_amt7+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt7+",'YYYYMMDD')-sysdate),-1,decode("+est_dt7+","+settle_dt+",0,"+est_amt7+"))) dly_amt, count(decode(sign(to_date("+est_dt7+",'YYYYMMDD')-sysdate),-1,decode("+est_dt7+","+settle_dt+",'',a.rent_s_cd))) dly_su"+
					"		from scd_rent a, rent_cont b"+
					"		where a.rent_s_cd=b.rent_s_cd "+condition7+""+
					"		group by b.bus_id \n"+
					"		union all"+
					"		select '휴/대차료-청구' gubun2, c.bus_id2, 0 tot_amt, 0 three_amt, -sum(a.req_amt) dly_amt, 0 dly_su"+
					" 		from my_accid a, accident b, cont c"+
					"		where a.req_dt between '"+var6+"' and '"+var3+"' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd "+
					"		group by c.bus_id2"+
					"		union all"+
					"		select '휴/대차료-입금' gubun2, c.bus_id2, 0 tot_amt, 0 three_amt, -sum(a.pay_amt) dly_amt, 0 dly_su"+
					" 		from my_accid a, accident b, cont c"+
					"		where a.pay_dt between '"+var6+"' and '"+var3+"' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd "+
					"		group by c.bus_id2"+
					"	)group by bus_id2 \n"+
					" ) a, users b, branch c, (select * from code where c_st='0002') d, (select * from stat_settle where save_dt='"+eff_dt+"') e, \n"+
				    "      ( select bus_id2, trunc(avg(per1),2) avg_per"+
				    "        from stat_settle"+
					"        where save_dt between '"+var6+"' and '"+var3+"' "+
					"		 group by bus_id2) f"+
					" where b.user_id <> '000001' and a.bus_id2=b.user_id and b.br_id=c.br_id and b.dept_id=d.code and a.bus_id2=e.bus_id2(+) and a.bus_id2=f.bus_id2(+)";

			query += " order by decode(a.dly_per,0,0,'',0,trunc(a.dly_per*"+var8+",2))+decode(f.avg_per,0,0,'',0,trunc(f.avg_per*"+var9+",2)), a.dly_amt";

		}else{

			query = " select a.*, 0 tot_su, c.br_id, c.dept_id, e.per1 as per_0405 from stat_settle a, users c, (select bus_id2, per1 from stat_settle where save_dt='"+eff_dt+"') e where a.bus_id2=c.user_id and a.save_dt='"+save_dt+"' and a.bus_id2=e.bus_id2(+)";

			query += " and c.loan_st='1' and c.user_id not in ('000079')";

			query += " order by a.seq , a.amt desc";
		}

		//리스트 확인용
		String query2 = "";

		query2 = " select \n"+
					" * \n"+
					" from \n"+
					" ( \n"+
					"		select '선수금' gubun2, c.bus_id2, sum("+est_amt1+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt1+",'YYYYMMDD')-sysdate),-1,decode("+est_dt1+","+settle_dt+",0,"+est_amt1+"))) dly_amt, count(decode(sign(to_date("+est_dt1+",'YYYYMMDD')-sysdate),-1,decode("+est_dt1+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_ext a, fee b, cont c"+
					"		where a.ext_st in ('0', '1', '2' ) and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd=c.rent_l_cd "+condition1+""+
					"		group by c.bus_id2 \n"+
					"		union all"+
					"		select '대여료' gubun2, b.bus_id2, trunc(sum("+est_amt_n2+")) tot_amt, 0 three_amt, trunc( sum(decode(sign(to_date("+est_dt2+",'YYYYMMDD')-sysdate),-1,decode("+est_dt2+","+settle_dt+",0,"+est_amt_n2+")))) dly_amt, count(decode(sign(to_date("+est_dt2+",'YYYYMMDD')-sysdate),-1,decode("+est_dt2+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_fee a, cont b, (select a.rent_mng_id, a.rent_l_cd, count(0) in_cnt from car_call_in a, cont b where a.out_dt is null and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(b.use_yn,'Y')='Y' and b.car_st<>'4' group by a.rent_mng_id, a.rent_l_cd) c "+
					"		where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) "+
					"       "+condition2+""+
					"		group by b.bus_id2 \n"+
//					"		union all"+//부산/대전-직전3,4개월인 총받을어음
//					"		select '대여료' gubun2, b.bus_id2, 0 tot_amt, sum("+est_amt2+") three_amt, 0 dly_amt, 0 dly_su"+
//					"		from scd_fee a, cont b, users c,"+
//					"			(select a.rent_mng_id, a.rent_l_cd"+
//					"				from scd_fee a, cont b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.fee_tm > decode(sign(to_date('20080514','YYYYMMDD')-to_date(b.rent_dt,'YYYYMMDD')),1,'3','4') and a.rc_yn='0' and a.r_fee_est_dt < to_char(sysdate,'YYYYMMDD')"+//3회차이후연체
//					"				group by a.rent_mng_id, a.rent_l_cd) e,"+
//					"			(select a.rent_mng_id, a.rent_l_cd"+
//					"				from scd_fee a, cont b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.fee_tm = decode(sign(to_date('20080514','YYYYMMDD')-to_date(b.rent_dt,'YYYYMMDD')),1,'3','4') and a.rc_yn='0' and a.r_fee_est_dt >= to_char(sysdate,'YYYYMMDD')"+//3회차 미연체
//					"			    group by a.rent_mng_id, a.rent_l_cd) f"+
//					"		where a.rent_l_cd=b.rent_l_cd and b.bus_id2=c.user_id and c.br_id<>'S1'"+
//					"       and a.rent_l_cd=e.rent_l_cd(+)"+
//					"		and a.rent_l_cd=f.rent_l_cd(+) "+
//					"		and (e.rent_l_cd is not null or f.rent_l_cd is not null) "+
//							condition2+""+
//					"		group by b.bus_id2 \n"+
					"		union all"+
					"		select '과태료' gubun2, decode(a.rent_s_cd,'',decode(a.fault_st,'2',nvl(a.fault_nm,b.bus_id2),b.bus_id2), decode(c.rent_st,'1',c.bus_id,'9',c.bus_id, '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) bus_id2, sum("+est_amt3+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt3+",'YYYYMMDD')-sysdate),-1,decode("+est_dt3+","+settle_dt+",0,"+est_amt3+")))"+magni+" dly_amt, count(decode(sign(to_date("+est_dt3+",'YYYYMMDD')-sysdate),-1,decode("+est_dt1+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from fine a, cont b, rent_cont c, cont d"+
					"		where a.rent_l_cd=b.rent_l_cd and a.rent_s_cd=c.rent_s_cd(+) and c.sub_l_cd=d.rent_l_cd(+)  "+condition3+""+
					"		group by decode(a.rent_s_cd,'',decode(a.fault_st,'2',nvl(a.fault_nm,b.bus_id2),b.bus_id2), decode(c.rent_st,'1',c.bus_id,'9',c.bus_id, '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) \n"+
					"		union all"+
					"		select '면책금' gubun2, decode(e.rent_s_cd,'',b.bus_id2, decode(c.rent_st,'1',c.bus_id,'9',c.bus_id, '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) bus_id2, sum("+est_amt4+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt4+",'YYYYMMDD')-sysdate),-1,decode("+est_dt4+","+settle_dt+",0,"+est_amt4+")))"+magni+" dly_amt, count(decode(sign(to_date("+est_dt4+",'YYYYMMDD')-sysdate),-1,decode("+est_dt4+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from service a, accident e, cont b, rent_cont c, cont d, scd_ext se"+
					"		where se.ext_st = '3' and se.rent_mng_id = a.rent_mng_id and se.rent_l_cd = a.rent_l_cd and se.ext_id = a.serv_id and a.car_mng_id=e.car_mng_id and a.accid_id=e.accid_id and se.rent_mng_id=b.rent_mng_id and se.rent_l_cd=b.rent_l_cd and e.rent_s_cd=c.rent_s_cd(+) and c.sub_l_cd=d.rent_l_cd(+) "+condition4+""+
					"		group by decode(e.rent_s_cd,'',b.bus_id2, decode(c.rent_st,'1',c.bus_id,'9',c.bus_id, '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) \n"+
					"		union all"+
					"		select '위약금' gubun2, c.bus_id2, sum("+est_amt_n6+") tot_amt, 0 three_amt, trunc(sum(decode(sign(to_date("+est_dt6+",'YYYYMMDD')-sysdate),-1,decode("+est_dt6+","+settle_dt+",0,"+est_amt_n6+"))) "+magni2+") dly_amt, count(decode(sign(to_date("+est_dt6+",'YYYYMMDD')-sysdate),-1,decode("+est_dt6+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_ext a, cls_cont b, cont c, (select a.* from gua_ins a, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, max(gi_dt) gi_dt from gua_ins group by rent_mng_id, rent_l_cd) b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st and a.gi_dt=b.gi_dt) d"+
					"		where a.ext_st = '4' and a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+) "+condition6+""+
					"		group by c.bus_id2 \n"+
					"		union all"+
					"		select '단기요금' gubun2, b.bus_id bus_id2, sum("+est_amt7+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt7+",'YYYYMMDD')-sysdate),-1,decode("+est_dt7+","+settle_dt+",0,"+est_amt7+"))) dly_amt, count(decode(sign(to_date("+est_dt7+",'YYYYMMDD')-sysdate),-1,decode("+est_dt7+","+settle_dt+",'',a.rent_s_cd))) dly_su"+
					"		from scd_rent a, rent_cont b"+
					"		where a.rent_s_cd=b.rent_s_cd "+condition7+""+
					"		group by b.bus_id \n"+
					"		union all"+
					"		select '휴/대차료-청구' gubun2, c.bus_id2, 0 tot_amt, 0 three_amt, -sum(a.req_amt) dly_amt, 0 dly_su"+
					" 		from my_accid a, accident b, cont c"+
					"		where a.req_dt between '"+var6+"' and '"+var3+"' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd "+
					"		group by c.bus_id2"+
					"		union all"+
					"		select '휴/대차료-입금' gubun2, c.bus_id2, 0 tot_amt, 0 three_amt, -sum(a.pay_amt) dly_amt, 0 dly_su"+
					" 		from my_accid a, accident b, cont c"+
					"		where a.pay_dt between '"+var6+"' and '"+var3+"' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd "+
					"		group by c.bus_id2"+
					" \n ) "+
					"	";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
	    	
			while(rs.next())
			{
				IncomingSBean fee = new IncomingSBean();
				fee.setGubun	(rs.getString("bus_id2"));
				fee.setBr_id	(rs.getString("br_id"));
				fee.setDept_id	(rs.getString("dept_id"));
				fee.setTot_amt1	(rs.getString("tot_amt"));
				fee.setTot_su2	(rs.getString("su"));
				fee.setTot_amt2	(rs.getString("amt"));
				fee.setTot_su3	(rs.getString("per1"));
				fee.setTot_su4	(rs.getString("per2")		==null?"":rs.getString("per2"));
				fee.setTot_su5	(rs.getString("per_0405")	==null?"":rs.getString("per_0405"));
				fee.setTot_amt3	(rs.getString("three_amt")	==null?"":rs.getString("three_amt"));
				fee.setTot_su6	(rs.getString("avg_per")	==null?"":rs.getString("avg_per"));
				fee.setTot_su7	(rs.getString("cmp_per")	==null?"":rs.getString("cmp_per"));
				vt.add(fee);

			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[SettleDatabase:getStatSettleList_20090312]"+e);
			System.out.println("[SettleDatabase:getStatSettleList_20090312]"+query);
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
	 *	미수금현황 리스트-채권1 ) - 평균연체율 적용
	 */
	public Vector getStatSettleList_20090703( String brch_id, String dept_id, String save_dt, String eff_dt, String var1_3, String var1_6, String var1_8, String var1_9, String var2_3, String var2_6, String var2_8, String var2_9)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String magni = "";//5배할증  *5 -> 20131021 할증해제
		String magni2 = "*0.1";//0.1배할증
		String settle_dt = "to_char(sysdate,'YYYYMMDD')";
		
		String var3 = var1_3;
		String var6 = var1_6;
		String var8 = var1_8;
		String var9 = var1_9;

		if(save_dt.equals("")){

			query = " select "+
					"	b.br_id, b.dept_id, a.bus_id2, c.br_nm, d.nm, b.user_nm, b.user_pos,"+
					"	a.tot_amt, nvl(a.three_amt,0) as three_amt, case when nvl(a.dly_amt,0) < 0 then 0 else nvl(a.dly_amt,0) end  as amt, a.dly_su as su, "+
					"	case when 	a.dly_per < 0 then 0 else a.dly_per end as per1, '' per2, nvl(e.per1,0) per_0405,"+
					"   nvl(f.avg_per,0) avg_per, "+
					"   trunc(decode(case when 	a.dly_per < 0 then 0 else a.dly_per end,0,0,'',0,a.dly_per*decode(b.loan_st, '1', "+var1_8+", "+var2_8+"))+decode(f.avg_per,0,0,'',0,f.avg_per*decode(b.loan_st, '1',"+var1_9+ ", "+var2_9+")),2) cmp_per"+
					" from \n"+
					" ("+
					"	select"+
					"	bus_id2, sum(tot_amt) tot_amt, sum(dly_amt) dly_amt, sum(dly_su) dly_su, sum(three_amt) three_amt,"+
					"	nvl(trunc((sum(dly_amt)/sum(tot_amt)*100),2),0) dly_per"+
					"	from \n"+
					"	("+
					"		select '선수금' gubun2, c.bus_id2, sum("+est_amt1+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt1_1+",'YYYYMMDD')-sysdate),-1,decode("+est_dt1_1+","+settle_dt+",0,"+est_amt1+"))) dly_amt, count(decode(sign(to_date("+est_dt1_1+",'YYYYMMDD')-sysdate),-1,decode("+est_dt1_1+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_ext a, fee b, cont c, cont_etc d"+
					"		where a.ext_st in ('0', '1', '2' ) and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+)  "+condition1+""+
					"		group by c.bus_id2 \n"+
					"		union all"+
					"		select '대여료' gubun2, b.bus_id2, trunc(sum("+est_amt_n2+")) tot_amt, 0 three_amt, trunc( sum(decode(sign(to_date("+est_dt2+",'YYYYMMDD')-sysdate),-1,decode("+est_dt2+","+settle_dt+",0,"+est_amt_n2+")))) dly_amt, count(decode(sign(to_date("+est_dt2+",'YYYYMMDD')-sysdate),-1,decode("+est_dt2+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_fee a, cont b, (select a.rent_mng_id, a.rent_l_cd, count(0) in_cnt from car_call_in a, cont b where a.out_dt is null and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(b.use_yn,'Y')='Y' and b.car_st<>'4' group by a.rent_mng_id, a.rent_l_cd) c "+
					"		where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) "+
					"       "+condition2+""+
					"		group by b.bus_id2 \n"+
//					"		union all"+//부산/대전-직전3,4개월인 총받을어음
//					"		select '대여료' gubun2, b.bus_id2, 0 tot_amt, sum("+est_amt2+") three_amt, 0 dly_amt, 0 dly_su"+
//					"		from scd_fee a, cont b, users c,"+
//					"			(select a.rent_mng_id, a.rent_l_cd"+
//					"				from scd_fee a, cont b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.fee_tm > decode(sign(to_date('20080514','YYYYMMDD')-to_date(b.rent_dt,'YYYYMMDD')),1,'3','4') and a.rc_yn='0' and a.r_fee_est_dt < to_char(sysdate,'YYYYMMDD')"+//3회차이후연체
//					"				group by a.rent_mng_id, a.rent_l_cd) e,"+
//					"			(select a.rent_mng_id, a.rent_l_cd"+
//					"				from scd_fee a, cont b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.fee_tm = decode(sign(to_date('20080514','YYYYMMDD')-to_date(b.rent_dt,'YYYYMMDD')),1,'3','4') and a.rc_yn='0' and a.r_fee_est_dt >= to_char(sysdate,'YYYYMMDD')"+//3회차 미연체
//					"			    group by a.rent_mng_id, a.rent_l_cd) f"+
//					"		where a.rent_l_cd=b.rent_l_cd and b.bus_id2=c.user_id and c.br_id<>'S1'"+
//					"       and a.rent_l_cd=e.rent_l_cd(+)"+
//					"		and a.rent_l_cd=f.rent_l_cd(+) "+
//					"		and (e.rent_l_cd is not null or f.rent_l_cd is not null) "+
//							condition2+""+
//					"		group by b.bus_id2 \n"+
					"		union all"+
					"		select '과태료' gubun2, decode(a.rent_s_cd,'',decode(a.fault_st,'2',nvl(a.fault_nm,b.bus_id2),b.bus_id2), decode(c.rent_st,'1',c.bus_id,'9',c.bus_id, '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) bus_id2, sum("+est_amt3+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt3+",'YYYYMMDD')-sysdate),-1,decode("+est_dt3+","+settle_dt+",0,"+est_amt3+")))"+magni+" dly_amt, count(decode(sign(to_date("+est_dt3+",'YYYYMMDD')-sysdate),-1,decode("+est_dt1+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from fine a, cont b, rent_cont c, cont d"+
					"		where a.rent_l_cd=b.rent_l_cd and a.rent_s_cd=c.rent_s_cd(+) and c.sub_l_cd=d.rent_l_cd(+)  "+condition3+""+
					"		group by decode(a.rent_s_cd,'',decode(a.fault_st,'2',nvl(a.fault_nm,b.bus_id2),b.bus_id2), decode(c.rent_st,'1',c.bus_id,'9',c.bus_id, '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) \n"+
					"		union all"+
					"		select '면책금' gubun2, decode(e.rent_s_cd,'',b.bus_id2, decode(c.rent_st,'1',c.bus_id,'9',c.bus_id, '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) bus_id2, sum("+est_amt4+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt4+",'YYYYMMDD')-sysdate),-1,decode("+est_dt4+","+settle_dt+",0,"+est_amt4+")))"+magni+" dly_amt, count(decode(sign(to_date("+est_dt4+",'YYYYMMDD')-sysdate),-1,decode("+est_dt4+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from service a, accident e, cont b, rent_cont c, cont d, scd_ext se"+
					"		where se.ext_st = '3' and se.rent_mng_id = a.rent_mng_id and se.rent_l_cd = a.rent_l_cd and se.ext_id = a.serv_id and a.car_mng_id=e.car_mng_id and a.accid_id=e.accid_id and se.rent_mng_id=b.rent_mng_id and se.rent_l_cd=b.rent_l_cd and e.rent_s_cd=c.rent_s_cd(+) and c.sub_l_cd=d.rent_l_cd(+) "+condition4+""+
					"		group by decode(e.rent_s_cd,'',b.bus_id2, decode(c.rent_st,'1',c.bus_id,'9',c.bus_id, '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) \n"+
					"		union all"+
					"		select '위약금' gubun2, c.bus_id2, sum("+est_amt_n6+") tot_amt, 0 three_amt, trunc(sum(decode(sign(to_date("+est_dt6+",'YYYYMMDD')-sysdate),-1,decode("+est_dt6+","+settle_dt+",0,"+est_amt_n6+"))) "+magni2+") dly_amt, count(decode(sign(to_date("+est_dt6+",'YYYYMMDD')-sysdate),-1,decode("+est_dt6+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_ext a, cls_cont b, cont c, (select a.* from gua_ins a, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, max(gi_dt) gi_dt from gua_ins group by rent_mng_id, rent_l_cd) b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st and a.gi_dt=b.gi_dt) d"+
					"		where a.ext_st = '4' and a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+) "+condition6+""+
					"		group by c.bus_id2 \n"+
					"		union all"+
					"		select '단기요금' gubun2, b.bus_id bus_id2, sum("+est_amt7+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt7+",'YYYYMMDD')-sysdate),-1,decode("+est_dt7+","+settle_dt+",0,"+est_amt7+"))) dly_amt, count(decode(sign(to_date("+est_dt7+",'YYYYMMDD')-sysdate),-1,decode("+est_dt7+","+settle_dt+",'',a.rent_s_cd))) dly_su"+
					"		from scd_rent a, rent_cont b"+
					"		where a.rent_s_cd=b.rent_s_cd "+condition7+""+
					"		group by b.bus_id \n"+
					"		union all"+
					"		select '휴/대차료-청구' gubun2, c.bus_id2, 0 tot_amt, 0 three_amt, -sum(a.req_amt) dly_amt, 0 dly_su"+
					" 		from my_accid a, accident b, cont c, users u "+
					"		where a.req_dt between decode(u.loan_st, '1', '"+var1_6+"', '"+var2_6+"' ) and decode(u.loan_st, '1', '"+var1_3+"', '"+var2_3+"') and c.bus_id2 = u.user_id and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd "+
					"		group by c.bus_id2"+
					"		union all"+
					"		select '휴/대차료-입금' gubun2, c.bus_id2, 0 tot_amt, 0 three_amt, -sum(a.pay_amt) dly_amt, 0 dly_su"+
					" 		from my_accid a, accident b, cont c, users u "+
					"		where a.pay_dt between decode(u.loan_st, '1', '"+var1_6+"', '"+var2_6+"' ) and decode(u.loan_st, '1', '"+var1_3+"', '"+var2_3+"') and c.bus_id2 = u.user_id and  a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd "+
					"		group by c.bus_id2"+
					"	)group by bus_id2 \n"+
					" ) a, users b, branch c, (select * from code where c_st='0002') d, (select * from stat_settle where save_dt='"+eff_dt+"') e, \n"+
				    "      ( select a.bus_id2, trunc(avg(per1),2) avg_per"+
				    "        from stat_settle a, users u "+
					"        where a.save_dt between decode(u.loan_st, '1', '"+var1_6+"', '"+var2_6+"' ) and decode(u.loan_st, '1', '"+var1_3+"', '"+var2_3+"') and a.bus_id2 = u.user_id "+
					"		 group by a.bus_id2) f"+
					" where b.user_id <> '000001' and a.bus_id2=b.user_id and b.br_id=c.br_id and b.dept_id=d.code and a.bus_id2=e.bus_id2(+) and a.bus_id2=f.bus_id2(+)";

			query += " order by decode(a.dly_per,0,0,'',0,trunc(a.dly_per*decode(b.loan_st, '1', "+var1_8+", "+var2_8+"),2))+decode(f.avg_per,0,0,'',0,trunc(f.avg_per*decode(b.loan_st, '1', "+var1_9+", "+var2_9+"),2)), a.dly_amt";

		}else{

			query = " select a.*, 0 tot_su, c.br_id, c.dept_id, e.per1 as per_0405 from stat_settle a, users c, (select bus_id2, per1 from stat_settle where save_dt='"+eff_dt+"') e where a.bus_id2=c.user_id and a.save_dt='"+save_dt+"' and a.bus_id2=e.bus_id2(+)";

			query += " and c.loan_st='1' and c.user_id not in ('000079')";

			query += " order by a.seq , a.amt desc";
		}

		//리스트 확인용
		String query2 = "";

		query2 = " select \n"+
					" * \n"+
					" from \n"+
					" ( \n"+
					"		select '선수금' gubun2, c.bus_id2, sum("+est_amt1+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt1+",'YYYYMMDD')-sysdate),-1,decode("+est_dt1+","+settle_dt+",0,"+est_amt1+"))) dly_amt, count(decode(sign(to_date("+est_dt1+",'YYYYMMDD')-sysdate),-1,decode("+est_dt1+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_ext a, fee b, cont c"+
					"		where a.ext_st in ('0', '1', '2' ) and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd=c.rent_l_cd "+condition1+""+
					"		group by c.bus_id2 \n"+
					"		union all"+
					"		select '대여료' gubun2, b.bus_id2, trunc(sum("+est_amt_n2+")) tot_amt, 0 three_amt, trunc( sum(decode(sign(to_date("+est_dt2+",'YYYYMMDD')-sysdate),-1,decode("+est_dt2+","+settle_dt+",0,"+est_amt_n2+")))) dly_amt, count(decode(sign(to_date("+est_dt2+",'YYYYMMDD')-sysdate),-1,decode("+est_dt2+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_fee a, cont b, (select a.rent_mng_id, a.rent_l_cd, count(0) in_cnt from car_call_in a, cont b where a.out_dt is null and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(b.use_yn,'Y')='Y' and b.car_st<>'4' group by a.rent_mng_id, a.rent_l_cd) c "+
					"		where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) "+
					"       "+condition2+""+
					"		group by b.bus_id2 \n"+
//					"		union all"+//부산/대전-직전3,4개월인 총받을어음
//					"		select '대여료' gubun2, b.bus_id2, 0 tot_amt, sum("+est_amt2+") three_amt, 0 dly_amt, 0 dly_su"+
//					"		from scd_fee a, cont b, users c,"+
//					"			(select a.rent_mng_id, a.rent_l_cd"+
//					"				from scd_fee a, cont b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.fee_tm > decode(sign(to_date('20080514','YYYYMMDD')-to_date(b.rent_dt,'YYYYMMDD')),1,'3','4') and a.rc_yn='0' and a.r_fee_est_dt < to_char(sysdate,'YYYYMMDD')"+//3회차이후연체
//					"				group by a.rent_mng_id, a.rent_l_cd) e,"+
//					"			(select a.rent_mng_id, a.rent_l_cd"+
//					"				from scd_fee a, cont b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.fee_tm = decode(sign(to_date('20080514','YYYYMMDD')-to_date(b.rent_dt,'YYYYMMDD')),1,'3','4') and a.rc_yn='0' and a.r_fee_est_dt >= to_char(sysdate,'YYYYMMDD')"+//3회차 미연체
//					"			    group by a.rent_mng_id, a.rent_l_cd) f"+
//					"		where a.rent_l_cd=b.rent_l_cd and b.bus_id2=c.user_id and c.br_id<>'S1'"+
//					"       and a.rent_l_cd=e.rent_l_cd(+)"+
//					"		and a.rent_l_cd=f.rent_l_cd(+) "+
//					"		and (e.rent_l_cd is not null or f.rent_l_cd is not null) "+
//							condition2+""+
//					"		group by b.bus_id2 \n"+
					"		union all"+
					"		select '과태료' gubun2, decode(a.rent_s_cd,'',decode(a.fault_st,'2',nvl(a.fault_nm,b.bus_id2),b.bus_id2), decode(c.rent_st,'1',c.bus_id,'9',c.bus_id, '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) bus_id2, sum("+est_amt3+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt3+",'YYYYMMDD')-sysdate),-1,decode("+est_dt3+","+settle_dt+",0,"+est_amt3+")))"+magni+" dly_amt, count(decode(sign(to_date("+est_dt3+",'YYYYMMDD')-sysdate),-1,decode("+est_dt1+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from fine a, cont b, rent_cont c, cont d"+
					"		where a.rent_l_cd=b.rent_l_cd and a.rent_s_cd=c.rent_s_cd(+) and c.sub_l_cd=d.rent_l_cd(+)  "+condition3+""+
					"		group by decode(a.rent_s_cd,'',decode(a.fault_st,'2',nvl(a.fault_nm,b.bus_id2),b.bus_id2), decode(c.rent_st,'1',c.bus_id,'9',c.bus_id, '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) \n"+
					"		union all"+
					"		select '면책금' gubun2, decode(e.rent_s_cd,'',b.bus_id2, decode(c.rent_st,'1',c.bus_id,'9',c.bus_id, '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) bus_id2, sum("+est_amt4+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt4+",'YYYYMMDD')-sysdate),-1,decode("+est_dt4+","+settle_dt+",0,"+est_amt4+")))"+magni+" dly_amt, count(decode(sign(to_date("+est_dt4+",'YYYYMMDD')-sysdate),-1,decode("+est_dt4+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from service a, accident e, cont b, rent_cont c, cont d, scd_ext se"+
					"		where se.ext_st = '3' and se.rent_mng_id = a.rent_mng_id and se.rent_l_cd = a.rent_l_cd and se.ext_id = a.serv_id and a.car_mng_id=e.car_mng_id and a.accid_id=e.accid_id and se.rent_mng_id=b.rent_mng_id and se.rent_l_cd=b.rent_l_cd and e.rent_s_cd=c.rent_s_cd(+) and c.sub_l_cd=d.rent_l_cd(+) "+condition4+""+
					"		group by decode(e.rent_s_cd,'',b.bus_id2, decode(c.rent_st,'1',c.bus_id,'9',c.bus_id, '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) \n"+
					"		union all"+
					"		select '위약금' gubun2, c.bus_id2, sum("+est_amt_n6+") tot_amt, 0 three_amt, trunc(sum(decode(sign(to_date("+est_dt6+",'YYYYMMDD')-sysdate),-1,decode("+est_dt6+","+settle_dt+",0,"+est_amt_n6+"))) "+magni2+") dly_amt, count(decode(sign(to_date("+est_dt6+",'YYYYMMDD')-sysdate),-1,decode("+est_dt6+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_ext a, cls_cont b, cont c, (select a.* from gua_ins a, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, max(gi_dt) gi_dt from gua_ins group by rent_mng_id, rent_l_cd) b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st and a.gi_dt=b.gi_dt) d"+
					"		where a.ext_st = '4' and a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+) "+condition6+""+
					"		group by c.bus_id2 \n"+
					"		union all"+
					"		select '단기요금' gubun2, b.bus_id bus_id2, sum("+est_amt7+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt7+",'YYYYMMDD')-sysdate),-1,decode("+est_dt7+","+settle_dt+",0,"+est_amt7+"))) dly_amt, count(decode(sign(to_date("+est_dt7+",'YYYYMMDD')-sysdate),-1,decode("+est_dt7+","+settle_dt+",'',a.rent_s_cd))) dly_su"+
					"		from scd_rent a, rent_cont b"+
					"		where a.rent_s_cd=b.rent_s_cd "+condition7+""+
					"		group by b.bus_id \n"+
					"		union all"+
					"		select '휴/대차료-청구' gubun2, c.bus_id2, 0 tot_amt, 0 three_amt, -sum(a.req_amt) dly_amt, 0 dly_su"+
					" 		from my_accid a, accident b, cont c"+
					"		where a.req_dt between '"+var6+"' and '"+var3+"' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd "+
					"		group by c.bus_id2"+
					"		union all"+
					"		select '휴/대차료-입금' gubun2, c.bus_id2, 0 tot_amt, 0 three_amt, -sum(a.pay_amt) dly_amt, 0 dly_su"+
					" 		from my_accid a, accident b, cont c"+
					"		where a.pay_dt between '"+var6+"' and '"+var3+"' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd "+
					"		group by c.bus_id2"+
					" \n ) "+
					"	";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
	    	
			while(rs.next())
			{
				IncomingSBean fee = new IncomingSBean();
				fee.setGubun	(rs.getString("bus_id2"));
				fee.setBr_id	(rs.getString("br_id"));
				fee.setDept_id	(rs.getString("dept_id"));
				fee.setTot_amt1	(rs.getString("tot_amt"));
				fee.setTot_su2	(rs.getString("su"));
				fee.setTot_amt2	(rs.getString("amt"));
				fee.setTot_su3	(rs.getString("per1"));
				fee.setTot_su4	(rs.getString("per2")		==null?"":rs.getString("per2"));
				fee.setTot_su5	(rs.getString("per_0405")	==null?"":rs.getString("per_0405"));
				fee.setTot_amt3	(rs.getString("three_amt")	==null?"":rs.getString("three_amt"));
				fee.setTot_su6	(rs.getString("avg_per")	==null?"":rs.getString("avg_per"));
				fee.setTot_su7	(rs.getString("cmp_per")	==null?"":rs.getString("cmp_per"));
				vt.add(fee);

			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[SettleDatabase:getStatSettleList_20090703]"+e);
			System.out.println("[SettleDatabase:getStatSettleList_20090703]"+query);
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
	 *	미수금현황 리스트-채권1 ) - 연체이자 포함
	 */
	public Vector getStatSettleList_20091001( String brch_id, String dept_id, String save_dt, String eff_dt, String var1_3, String var1_6, String var1_8, String var1_9, String var2_3, String var2_6, String var2_8, String var2_9)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String magni = "";//5배할증  *5 -> 20131021 할증해제
		String magni2 = "*0.1";//0.1배할증
		String settle_dt = "to_char(sysdate,'YYYYMMDD')";
		
		String var3 = var1_3;
		String var6 = var1_6;
		String var8 = var1_8;
		String var9 = var1_9;

		if(save_dt.equals("")){

			query = " select "+
					"	b.br_id, b.dept_id, a.bus_id2, c.br_nm, d.nm, b.user_nm, b.user_pos,"+
					"	a.tot_amt, nvl(a.three_amt,0) as three_amt, case when nvl(a.dly_amt,0) < 0 then 0 else nvl(a.dly_amt,0) end  as amt, a.dly_su as su, "+
					"	case when 	a.dly_per < 0 then 0 else a.dly_per end as per1, '' per2, nvl(e.per1,0) per_0405,"+
					"   nvl(f.avg_per,0) avg_per, "+
					"   trunc(decode(case when 	a.dly_per < 0 then 0 else a.dly_per end,0,0,'',0,a.dly_per*decode(b.loan_st, '1', "+var1_8+", "+var2_8+"))+decode(f.avg_per,0,0,'',0,f.avg_per*decode(b.loan_st, '1',"+var1_9+ ", "+var2_9+")),2) cmp_per"+
					" from \n"+
					" ("+
					"	select"+
					"	bus_id2, sum(tot_amt) tot_amt, sum(dly_amt) dly_amt, sum(dly_su) dly_su, sum(three_amt) three_amt,"+
					"	nvl(trunc((sum(dly_amt)/sum(tot_amt)*100),2),0) dly_per"+
					"	from \n"+
					"	("+
					"		select '선수금' gubun2, c.bus_id2, sum("+est_amt1+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt1_1+",'YYYYMMDD')-sysdate),-1,decode("+est_dt1_1+","+settle_dt+",0,"+est_amt1+"))) dly_amt, count(decode(sign(to_date("+est_dt1_1+",'YYYYMMDD')-sysdate),-1,decode("+est_dt1_1+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_ext a, fee b, cont c, cont_etc d"+
					"		where a.ext_st in ('0', '1', '2' ) and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+) "+condition1+""+
					"		group by c.bus_id2 \n"+
					"		union all"+
					"		select '대여료' gubun2, b.bus_id2, trunc(sum("+est_amt_n2+")) tot_amt, 0 three_amt, trunc( sum(decode(sign(to_date("+est_dt2+",'YYYYMMDD')-sysdate),-1,decode("+est_dt2+","+settle_dt+",0,"+est_amt_n2+")))) dly_amt, count(decode(sign(to_date("+est_dt2+",'YYYYMMDD')-sysdate),-1,decode("+est_dt2+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_fee a, cont b, (select a.rent_mng_id, a.rent_l_cd, count(0) in_cnt from car_call_in a, cont b where a.out_dt is null and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(b.use_yn,'Y')='Y' and b.car_st<>'4' group by a.rent_mng_id, a.rent_l_cd) c "+
					"		where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) "+
					"       "+condition2+""+
					"		group by b.bus_id2 \n"+
//					"		union all"+//부산/대전-직전3,4개월인 총받을어음
//					"		select '대여료' gubun2, b.bus_id2, 0 tot_amt, sum("+est_amt2+") three_amt, 0 dly_amt, 0 dly_su"+
//					"		from scd_fee a, cont b, users c,"+
//					"			(select a.rent_mng_id, a.rent_l_cd"+
//					"				from scd_fee a, cont b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.fee_tm > decode(sign(to_date('20080514','YYYYMMDD')-to_date(b.rent_dt,'YYYYMMDD')),1,'3','4') and a.rc_yn='0' and a.r_fee_est_dt < to_char(sysdate,'YYYYMMDD')"+//3회차이후연체
//					"				group by a.rent_mng_id, a.rent_l_cd) e,"+
//					"			(select a.rent_mng_id, a.rent_l_cd"+
//					"				from scd_fee a, cont b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.fee_tm = decode(sign(to_date('20080514','YYYYMMDD')-to_date(b.rent_dt,'YYYYMMDD')),1,'3','4') and a.rc_yn='0' and a.r_fee_est_dt >= to_char(sysdate,'YYYYMMDD')"+//3회차 미연체
//					"			    group by a.rent_mng_id, a.rent_l_cd) f"+
//					"		where a.rent_l_cd=b.rent_l_cd and b.bus_id2=c.user_id and c.br_id<>'S1'"+
//					"       and a.rent_l_cd=e.rent_l_cd(+)"+
//					"		and a.rent_l_cd=f.rent_l_cd(+) "+
//					"		and (e.rent_l_cd is not null or f.rent_l_cd is not null) "+
//							condition2+""+
//					"		group by b.bus_id2 \n"+
					"		union all"+
					"		select '과태료' gubun2, decode(a.rent_s_cd,'',decode(a.fault_st,'2',nvl(a.fault_nm,b.bus_id2),b.bus_id2), decode(c.rent_st,'1',c.bus_id,'9',c.bus_id, '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) bus_id2, sum("+est_amt3+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt3+",'YYYYMMDD')-sysdate),-1,decode("+est_dt3+","+settle_dt+",0,"+est_amt3+")))"+magni+" dly_amt, count(decode(sign(to_date("+est_dt3+",'YYYYMMDD')-sysdate),-1,decode("+est_dt1+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from fine a, cont b, rent_cont c, cont d"+
					"		where a.rent_l_cd=b.rent_l_cd and a.rent_s_cd=c.rent_s_cd(+) and c.sub_l_cd=d.rent_l_cd(+)  "+condition3+""+
					"		group by decode(a.rent_s_cd,'',decode(a.fault_st,'2',nvl(a.fault_nm,b.bus_id2),b.bus_id2), decode(c.rent_st,'1',c.bus_id,'9',c.bus_id, '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) \n"+
					"		union all"+
					"		select '면책금' gubun2, decode(e.rent_s_cd,'',b.bus_id2, decode(c.rent_st,'1',c.bus_id,'9',c.bus_id, '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) bus_id2, sum("+est_amt4+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt4+",'YYYYMMDD')-sysdate),-1,decode("+est_dt4+","+settle_dt+",0,"+est_amt4+")))"+magni+" dly_amt, count(decode(sign(to_date("+est_dt4+",'YYYYMMDD')-sysdate),-1,decode("+est_dt4+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from service a, accident e, cont b, rent_cont c, cont d, scd_ext se"+
					"		where se.ext_st = '3' and se.rent_mng_id = a.rent_mng_id and se.rent_l_cd = a.rent_l_cd and se.ext_id = a.serv_id and a.car_mng_id=e.car_mng_id and a.accid_id=e.accid_id and se.rent_mng_id=b.rent_mng_id and se.rent_l_cd=b.rent_l_cd and e.rent_s_cd=c.rent_s_cd(+) and c.sub_l_cd=d.rent_l_cd(+) "+condition4+""+
					"		group by decode(e.rent_s_cd,'',b.bus_id2, decode(c.rent_st,'1',c.bus_id,'9',c.bus_id, '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) \n"+
					"		union all"+
					"		select '위약금' gubun2, c.bus_id2, sum("+est_amt_n6+") tot_amt, 0 three_amt, trunc(sum(decode(sign(to_date("+est_dt6+",'YYYYMMDD')-sysdate),-1,decode("+est_dt6+","+settle_dt+",0,"+est_amt_n6+"))) "+magni2+") dly_amt, count(decode(sign(to_date("+est_dt6+",'YYYYMMDD')-sysdate),-1,decode("+est_dt6+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_ext a, cls_cont b, cont c, (select a.* from gua_ins a, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, max(gi_dt) gi_dt from gua_ins group by rent_mng_id, rent_l_cd) b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st and a.gi_dt=b.gi_dt) d"+
					"		where a.ext_st = '4' and a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+) "+condition6+""+
					"		group by c.bus_id2 \n"+
					"		union all"+
					"		select '단기요금' gubun2, b.bus_id bus_id2, sum("+est_amt7+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt7+",'YYYYMMDD')-sysdate),-1,decode("+est_dt7+","+settle_dt+",0,"+est_amt7+"))) dly_amt, count(decode(sign(to_date("+est_dt7+",'YYYYMMDD')-sysdate),-1,decode("+est_dt7+","+settle_dt+",'',a.rent_s_cd))) dly_su"+
					"		from scd_rent a, rent_cont b"+
					"		where a.rent_s_cd=b.rent_s_cd "+condition7+""+
					"		group by b.bus_id \n"+
					"		union all"+
					"		select '휴/대차료-청구' gubun2, c.bus_id2, 0 tot_amt, 0 three_amt, -sum(a.req_amt) dly_amt, 0 dly_su"+
					" 		from my_accid a, accident b, cont c, users u "+
					"		where a.req_dt between decode(u.loan_st, '1', '"+var1_6+"', '"+var2_6+"' ) and decode(u.loan_st, '1', '"+var1_3+"', '"+var2_3+"') and c.bus_id2 = u.user_id and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd "+
					"		group by c.bus_id2 \n"+
					"		union all"+
					"		select '휴/대차료-입금' gubun2, c.bus_id2, 0 tot_amt, 0 three_amt, -sum(a.pay_amt) dly_amt, 0 dly_su"+
					" 		from my_accid a, accident b, cont c, users u "+
					"		where a.pay_dt between decode(u.loan_st, '1', '"+var1_6+"', '"+var2_6+"' ) and decode(u.loan_st, '1', '"+var1_3+"', '"+var2_3+"') and c.bus_id2 = u.user_id and  a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd "+
					"		group by c.bus_id2 \n"+
					"		union all"+
					"       select '연체이자' gubun2, c.bus_id2, sum(nvl(dly_fee,0)-nvl(pay_amt,0)) tot_amt, 0 three_amt, sum(nvl(dly_fee,0)-nvl(pay_amt,0)) dly_amt, 0 dly_su "+
					"       from (select rent_mng_id, rent_l_cd, sum(dly_fee) dly_fee from scd_fee where rent_l_cd not like 'RM%' group by rent_mng_id, rent_l_cd) a, "+
					"		     (select rent_mng_id, rent_l_cd, sum(pay_amt) pay_amt from scd_dly where rent_l_cd not like 'RM%' group by rent_mng_id, rent_l_cd) b, cont c "+
					"       where a.rent_mng_id=b.rent_mng_id(+) and a.rent_l_cd=b.rent_l_cd(+) and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and nvl(dly_fee,0)-nvl(pay_amt,0)<>0 and c.use_yn='Y' AND c.rent_l_cd not like 'RM%' "+
					"       group by c.bus_id2 \n"+
					"	)group by bus_id2 \n"+
					" ) a, users b, branch c, (select * from code where c_st='0002') d, (select * from stat_settle where save_dt='"+eff_dt+"') e, \n"+
				    "      ( select a.bus_id2, trunc(avg(per1),2) avg_per"+
				    "        from stat_settle a, users u "+
					"        where a.save_dt between decode(u.loan_st, '1', '"+var1_6+"', '"+var2_6+"' ) and decode(u.loan_st, '1', '"+var1_3+"', '"+var2_3+"') and a.bus_id2 = u.user_id "+
					"		 group by a.bus_id2) f"+
					" where a.tot_amt>0 and b.user_id <> '000001' and a.bus_id2=b.user_id and b.br_id=c.br_id and b.dept_id=d.code and a.bus_id2=e.bus_id2(+) and a.bus_id2=f.bus_id2(+)";

			query += " order by decode(a.dly_per,0,0,'',0,trunc(a.dly_per*decode(b.loan_st, '1', "+var1_8+", "+var2_8+"),2))+decode(f.avg_per,0,0,'',0,trunc(f.avg_per*decode(b.loan_st, '1', "+var1_9+", "+var2_9+"),2)), a.dly_amt";

		}else{

			query = " select a.*, 0 tot_su, c.br_id, c.dept_id, e.per1 as per_0405 from stat_settle a, users c, (select bus_id2, per1 from stat_settle where save_dt='"+eff_dt+"') e where a.bus_id2=c.user_id and a.save_dt='"+save_dt+"' and a.bus_id2=e.bus_id2(+)";

			query += " and c.loan_st='1' and c.user_id not in ('000079')";

			query += " order by a.seq , a.amt desc";
		}

		//리스트 확인용
		String query2 = "";

		query2 = " select \n"+
					" * \n"+
					" from \n"+
					" ( \n"+
					"		select '선수금' gubun2, c.bus_id2, sum("+est_amt1+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt1+",'YYYYMMDD')-sysdate),-1,decode("+est_dt1+","+settle_dt+",0,"+est_amt1+"))) dly_amt, count(decode(sign(to_date("+est_dt1+",'YYYYMMDD')-sysdate),-1,decode("+est_dt1+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_ext a, fee b, cont c"+
					"		where a.ext_st in ('0', '1', '2' ) and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd=c.rent_l_cd "+condition1+""+
					"		group by c.bus_id2 \n"+
					"		union all"+
					"		select '대여료' gubun2, b.bus_id2, trunc(sum("+est_amt_n2+")) tot_amt, 0 three_amt, trunc( sum(decode(sign(to_date("+est_dt2+",'YYYYMMDD')-sysdate),-1,decode("+est_dt2+","+settle_dt+",0,"+est_amt_n2+")))) dly_amt, count(decode(sign(to_date("+est_dt2+",'YYYYMMDD')-sysdate),-1,decode("+est_dt2+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_fee a, cont b, (select a.rent_mng_id, a.rent_l_cd, count(0) in_cnt from car_call_in a, cont b where a.out_dt is null and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(b.use_yn,'Y')='Y' and b.car_st<>'4' group by a.rent_mng_id, a.rent_l_cd) c "+
					"		where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) "+
					"       "+condition2+""+
					"		group by b.bus_id2 \n"+
//					"		union all"+//부산/대전-직전3,4개월인 총받을어음
//					"		select '대여료' gubun2, b.bus_id2, 0 tot_amt, sum("+est_amt2+") three_amt, 0 dly_amt, 0 dly_su"+
//					"		from scd_fee a, cont b, users c,"+
//					"			(select a.rent_mng_id, a.rent_l_cd"+
//					"				from scd_fee a, cont b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.fee_tm > decode(sign(to_date('20080514','YYYYMMDD')-to_date(b.rent_dt,'YYYYMMDD')),1,'3','4') and a.rc_yn='0' and a.r_fee_est_dt < to_char(sysdate,'YYYYMMDD')"+//3회차이후연체
//					"				group by a.rent_mng_id, a.rent_l_cd) e,"+
//					"			(select a.rent_mng_id, a.rent_l_cd"+
//					"				from scd_fee a, cont b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.fee_tm = decode(sign(to_date('20080514','YYYYMMDD')-to_date(b.rent_dt,'YYYYMMDD')),1,'3','4') and a.rc_yn='0' and a.r_fee_est_dt >= to_char(sysdate,'YYYYMMDD')"+//3회차 미연체
//					"			    group by a.rent_mng_id, a.rent_l_cd) f"+
//					"		where a.rent_l_cd=b.rent_l_cd and b.bus_id2=c.user_id and c.br_id<>'S1'"+
//					"       and a.rent_l_cd=e.rent_l_cd(+)"+
//					"		and a.rent_l_cd=f.rent_l_cd(+) "+
//					"		and (e.rent_l_cd is not null or f.rent_l_cd is not null) "+
//							condition2+""+
//					"		group by b.bus_id2 \n"+
					"		union all"+
					"		select '과태료' gubun2, decode(a.rent_s_cd,'',decode(a.fault_st,'2',nvl(a.fault_nm,b.bus_id2),b.bus_id2), decode(c.rent_st,'1',c.bus_id,'9',c.bus_id, '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) bus_id2, sum("+est_amt3+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt3+",'YYYYMMDD')-sysdate),-1,decode("+est_dt3+","+settle_dt+",0,"+est_amt3+")))"+magni+" dly_amt, count(decode(sign(to_date("+est_dt3+",'YYYYMMDD')-sysdate),-1,decode("+est_dt1+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from fine a, cont b, rent_cont c, cont d"+
					"		where a.rent_l_cd=b.rent_l_cd and a.rent_s_cd=c.rent_s_cd(+) and c.sub_l_cd=d.rent_l_cd(+)  "+condition3+""+
					"		group by decode(a.rent_s_cd,'',decode(a.fault_st,'2',nvl(a.fault_nm,b.bus_id2),b.bus_id2), decode(c.rent_st,'1',c.bus_id,'9',c.bus_id, '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) \n"+
					"		union all"+
					"		select '면책금' gubun2, decode(e.rent_s_cd,'',b.bus_id2, decode(c.rent_st,'1',c.bus_id,'9',c.bus_id, '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) bus_id2, sum("+est_amt4+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt4+",'YYYYMMDD')-sysdate),-1,decode("+est_dt4+","+settle_dt+",0,"+est_amt4+")))"+magni+" dly_amt, count(decode(sign(to_date("+est_dt4+",'YYYYMMDD')-sysdate),-1,decode("+est_dt4+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from service a, accident e, cont b, rent_cont c, cont d, scd_ext se"+
					"		where se.ext_st = '3' and se.rent_mng_id = a.rent_mng_id and se.rent_l_cd = a.rent_l_cd and se.ext_id = a.serv_id and a.car_mng_id=e.car_mng_id and a.accid_id=e.accid_id and se.rent_mng_id=b.rent_mng_id and se.rent_l_cd=b.rent_l_cd and e.rent_s_cd=c.rent_s_cd(+) and c.sub_l_cd=d.rent_l_cd(+) "+condition4+""+
					"		group by decode(e.rent_s_cd,'',b.bus_id2, decode(c.rent_st,'1',c.bus_id,'9',c.bus_id, '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) \n"+
					"		union all"+
					"		select '위약금' gubun2, c.bus_id2, sum("+est_amt_n6+") tot_amt, 0 three_amt, trunc(sum(decode(sign(to_date("+est_dt6+",'YYYYMMDD')-sysdate),-1,decode("+est_dt6+","+settle_dt+",0,"+est_amt_n6+"))) "+magni2+") dly_amt, count(decode(sign(to_date("+est_dt6+",'YYYYMMDD')-sysdate),-1,decode("+est_dt6+","+settle_dt+",'',a.rent_l_cd))) dly_su"+
					"		from scd_ext a, cls_cont b, cont c, (select a.* from gua_ins a, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, max(gi_dt) gi_dt from gua_ins group by rent_mng_id, rent_l_cd) b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st and a.gi_dt=b.gi_dt) d"+
					"		where a.ext_st = '4' and a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+) "+condition6+""+
					"		group by c.bus_id2 \n"+
					"		union all"+
					"		select '단기요금' gubun2, b.bus_id bus_id2, sum("+est_amt7+") tot_amt, 0 three_amt, sum(decode(sign(to_date("+est_dt7+",'YYYYMMDD')-sysdate),-1,decode("+est_dt7+","+settle_dt+",0,"+est_amt7+"))) dly_amt, count(decode(sign(to_date("+est_dt7+",'YYYYMMDD')-sysdate),-1,decode("+est_dt7+","+settle_dt+",'',a.rent_s_cd))) dly_su"+
					"		from scd_rent a, rent_cont b"+
					"		where a.rent_s_cd=b.rent_s_cd "+condition7+""+
					"		group by b.bus_id \n"+
					"		union all"+
					"		select '휴/대차료-청구' gubun2, c.bus_id2, 0 tot_amt, 0 three_amt, -sum(a.req_amt) dly_amt, 0 dly_su"+
					" 		from my_accid a, accident b, cont c"+
					"		where a.req_dt between '"+var6+"' and '"+var3+"' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd "+
					"		group by c.bus_id2"+
					"		union all"+
					"		select '휴/대차료-입금' gubun2, c.bus_id2, 0 tot_amt, 0 three_amt, -sum(a.pay_amt) dly_amt, 0 dly_su"+
					" 		from my_accid a, accident b, cont c"+
					"		where a.pay_dt between '"+var6+"' and '"+var3+"' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd "+
					"		group by c.bus_id2"+
					"		union all"+
					"       select '연체이자' gubun2, c.bus_id2, sum(nvl(dly_fee,0)-nvl(pay_amt,0)) tot_amt, 0 three_amt, sum(nvl(dly_fee,0)-nvl(pay_amt,0)) dly_amt, 0 dly_su "+
					"       from (select rent_mng_id, rent_l_cd, sum(dly_fee) dly_fee from scd_fee where rent_l_cd not like 'RM%' group by rent_mng_id, rent_l_cd) a, "+
					"		     (select rent_mng_id, rent_l_cd, sum(pay_amt) pay_amt from scd_dly where rent_l_cd not like 'RM%' group by rent_mng_id, rent_l_cd) b, cont c "+
					"       where a.rent_mng_id=b.rent_mng_id(+) and a.rent_l_cd=b.rent_l_cd(+) and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and nvl(dly_fee,0)-nvl(pay_amt,0)<>0 and c.use_yn='Y' AND c.rent_l_cd not like 'RM%' "+
					"       group by c.bus_id2 \n"+
					" \n ) "+
					"	";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
	    	
			while(rs.next())
			{
				IncomingSBean fee = new IncomingSBean();
				fee.setGubun	(rs.getString("bus_id2"));
				fee.setBr_id	(rs.getString("br_id"));
				fee.setDept_id	(rs.getString("dept_id"));
				fee.setTot_amt1	(rs.getString("tot_amt"));
				fee.setTot_su2	(rs.getString("su"));
				fee.setTot_amt2	(rs.getString("amt"));
				fee.setTot_su3	(rs.getString("per1"));
				fee.setTot_su4	(rs.getString("per2")		==null?"":rs.getString("per2"));
				fee.setTot_su5	(rs.getString("per_0405")	==null?"":rs.getString("per_0405"));
				fee.setTot_amt3	(rs.getString("three_amt")	==null?"":rs.getString("three_amt"));
				fee.setTot_su6	(rs.getString("avg_per")	==null?"":rs.getString("avg_per"));
				fee.setTot_su7	(rs.getString("cmp_per")	==null?"":rs.getString("cmp_per"));
				vt.add(fee);

			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[SettleDatabase:getStatSettleList_20091001]"+e);
			System.out.println("[SettleDatabase:getStatSettleList_20091001]"+query2);
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


	//채권관리캠페인 담당자별 세부리스트 :: 20090408
	public Vector getStatSettleSubList(String bus_id2)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";



		query = " select \n"+
				"        a.*, b.car_no, b.car_nm, c.firm_nm, d.user_nm, e.cms_bank, f.cls_dt, "+
				"        decode(g.cbit,'1','신규','2','승인','3','해지신청','4','해지완료','7','임의해지','8','신고에러') cbit, g.ldate, nvl(p.promise_dt,'') promise_dt \n"+
				" from \n"+
				" ( \n"+
				"	 select '1' sort, '선수금' gubun1, decode(a.ext_st,'0','보증금','1','선납금','2','개시대여료', '5', '승계수수료') gubun2, \n"+
				"           a.rent_mng_id, a.rent_l_cd, c.car_mng_id, c.client_id, decode(a.ext_st,'5',NVL(b.ext_agnt,c.bus_id2),decode(b.rent_st,'1',decode(e.rent_l_cd,'',DECODE(c.bus_st,'7',c.bus_id2,c.bus_id),c.bus_id2),c.bus_id2)) bus_id2, c.mng_id2, \n"+
				"           decode(a.ext_st, '5', nvl(d.rent_suc_dt,b.rent_start_dt), nvl(d.rent_suc_dt,b.rent_start_dt)) as est_dt, "+
				"           (a.ext_s_amt+a.ext_v_amt) dly_amt, 0 dly_amt2, c.use_yn, c.rent_start_dt, c.car_st \n"+
				"	 from   scd_ext a, fee b, cont c, cont_etc d, (select * from cls_cont where cls_st in ('4','5')) e \n"+
				"    where  a.ext_st in ('0', '1', '2', '5' ) \n"+
				"          and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st \n"+
				"          and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"+
				"          and a.rent_mng_id = d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+)"+
				"          and c.rent_mng_id=e.rent_mng_id(+) and c.reg_dt=e.reg_dt(+) "+
				"          and a.ext_s_amt>0 and a.ext_pay_dt is null and nvl(a.bill_yn,'Y')='Y' \n"+
//				"          and decode(a.ext_st,'5',a.ext_est_dt,decode(c.rent_st||b.rent_st||b.grt_suc_yn||a.ext_st,'3100', to_char(add_months(to_date(nvl(c.dlv_dt,to_char(sysdate,'YYYYMMDD')),'YYYYMMDD'),1),'YYYYMMDD'), nvl(d.rent_suc_dt,b.rent_start_dt))) < to_char(sysdate,'YYYYMMDD') \n"+
				"          and decode(a.ext_st,'5',nvl(d.rent_suc_dt,a.ext_est_dt), \n"+//승계수수료
                "                     decode(c.rent_st||b.rent_st||b.grt_suc_yn||a.ext_st,'3100', \n"+//--대차승계보증금
                "                            decode(a.gubun,'E',a.ext_est_dt, \n"+
                "                                   to_char(to_date(nvl(b.rent_start_dt,to_char(sysdate,'YYYYMMDD')),'YYYYMMDD')+15,'YYYYMMDD') \n"+
                "                            ), \n"+
//              "                            nvl(d.rent_suc_dt,b.rent_start_dt) \n"+
				"                            case when d.rent_suc_dt is not null and d.rent_suc_dt > b.rent_start_dt then d.rent_suc_dt \n"+
                "                                                             WHEN d.rent_suc_dt IS NULL AND a.ext_st='5' THEN a.ext_est_dt  \n"+ 
                "                                                             else b.rent_start_dt end \n"+
                "                     ) \n"+
                "              ) < to_char(sysdate,'YYYYMMDD') \n"+

				"	 union all		 \n"+
				"    select '2' sort, '대여료' gubun1, a.fee_tm||'회'||decode(a.tm_st1,'0','','(잔액)') gubun2, \n"+
				"          a.rent_mng_id, a.rent_l_cd, b.car_mng_id, b.client_id, DECODE(b.car_st,'4',b.mng_id,b.bus_id2) bus_id2, b.mng_id2, \n"+
				"          a.r_fee_est_dt as est_dt, \n"+
				"          (a.fee_s_amt+a.fee_v_amt) dly_amt, 0 dly_amt2, b.use_yn, b.rent_start_dt, b.car_st \n"+
				"    from  scd_fee a, cont b \n"+
				"    where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				"          and a.fee_s_amt>0 and a.rc_dt is null and nvl(a.bill_yn,'Y')='Y' \n"+
				"          and a.r_fee_est_dt < to_char(sysdate,'YYYYMMDD')            \n"+
                
				"	 union all		 \n"+
                "    select '2_2' sort, '대여료' gubun1, '미청구분+잔가' gubun2,  \n"+
                "           rent_mng_id, rent_l_cd, car_mng_id, client_id, bus_id2, mng_id2, \n"+
                "           bas_end_dt as est_dt, (dly_amt+o_1) dly_amt, 0 dly_amt2, use_yn, rent_start_dt, car_st \n"+
                "           from \n"+
                "           ( select a.use_yn, a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.bus_id2, a.mng_id2, a.rent_start_dt, \n"+
                "                    case when b.rent_end_dt > d.fee_est_dt then b.rent_end_dt else d.fee_est_dt end bas_end_dt, \n"+
                "                    trunc((b.fee_s_amt+b.fee_v_amt)/30*to_number(sysdate-to_date(case when b.rent_end_dt > d.fee_est_dt then b.rent_end_dt else d.fee_est_dt end,'YYYYMMDD')),0) dly_amt, \n"+
                "                    decode(e.fee_opt_amt,0,nvl(e.o_1,0),e.fee_opt_amt) as o_1, a.car_st \n"+
                "             from   cont a, fee b, \n"+
                "                    (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) c, \n"+
                "                    (select rent_mng_id, rent_l_cd, max(use_e_dt) fee_est_dt from scd_fee group by rent_mng_id, rent_l_cd) d, \n"+
                "                    (select * from estimate_sh where est_from='car_janga' and rent_dt=to_char(sysdate,'YYYYMMDD')) e, cls_etc f, \n"+
				"                    ( select * from car_call_in where in_st='3' and out_dt is null ) cc \n"+
                "             where  a.use_yn='Y' and a.car_st in ('1','3') and b.rent_start_dt is not null \n"+
                "             and    a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
                "             and    b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st \n"+
                "             and    a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd \n"+
                "             and    b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd and b.rent_st=e.rent_st \n"+
                "             and    a.rent_mng_id=f.rent_mng_id(+) and a.rent_l_cd=f.rent_l_cd(+) and f.rent_l_cd is null \n"+  
				"             and    a.rent_mng_id=cc.rent_mng_id(+) and a.rent_l_cd=cc.rent_l_cd(+) and cc.rent_l_cd is null \n"+	
//              "             and    sysdate-to_date(case when b.rent_end_dt > d.fee_est_dt then b.rent_end_dt else d.fee_est_dt end,'YYYYMMDD')-2>0 \n"+//--20140729 3일경과일부터 채권에 나오게
                "             and    b.rent_end_dt < to_char(sysdate+3,'YYYYMMDD') and d.fee_est_dt < to_char(sysdate+3,'YYYYMMDD') \n"+//--20140729 3일경과일부터 채권에 나오게
                "           )           \n"+		

				"    union all \n"+
				"    select '3' sort, '과태료' gubun1, substr(a.vio_dt,1,8)||' '||a.vio_cont||'-'||decode(a.fault_st,'1','고객과실','업무상과실') as gubun2, \n"+
				"           a.rent_mng_id, a.rent_l_cd, b.car_mng_id, \n"+
				"           decode(c.rent_s_cd,'',b.client_id, decode(c.cust_st, '4', '000228',  c.cust_id)  ) client_id, \n"+ //업무대여인건 client_id : 아마존카로 처리 -
				"           decode(a.rent_s_cd,'',decode(a.fault_st,'2',nvl(a.fault_nm,b.bus_id2),b.bus_id2), decode(c.rent_st,'1',c.bus_id,'9',c.bus_id,'12',nvl(c.mng_id,c.bus_id), '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id,c.bus_id)) bus_id2, b.mng_id2, \n"+
				"           nvl(a.rec_plan_dt,nvl(a.dem_dt,a.paid_end_dt)) as est_dt, \n"+
				"           a.paid_amt as dly_amt, 0 dly_amt2, decode(c.rent_s_cd,'',b.use_yn,d.use_yn) use_yn, b.rent_start_dt, b.car_st \n"+
				"    from   fine a, cont b, rent_cont c, cont d \n"+
				"    where  a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				"           and a.rent_s_cd=c.rent_s_cd(+)  AND NVL(c.use_st,'0')<>'5' \n"+
				"           and c.sub_l_cd=d.rent_l_cd(+) \n"+
				"           and a.paid_amt>0 and a.coll_dt is null and decode(a.fault_st,'2', 'Y', '3', 'N', nvl(a.bill_yn,'Y'))='Y' \n"+
				"           and a.paid_st in ('3','4') and nvl(a.no_paid_yn,'N')='N' \n"+
//				"           and nvl(c.cust_st,'0')<>'1' \n"+
//				"           and a.vio_cont not like '%통행료%'  \n"+
				"           and ( (a.vio_cont not like  '%통행료%'and a.vio_cont not like  '%주차요금%') or  ( a.vio_cont like  '%통행료%' and a.proxy_dt is not null ) or ( a.vio_cont like  '%주차요금%' and a.proxy_dt is not null )  )"+
				"           and nvl(a.rec_plan_dt,nvl(a.dem_dt,a.paid_end_dt)) < to_char(sysdate,'YYYYMMDD') \n"+
				"	 union all \n"+
				"    select '4' sort, '면책금' gubun1, a.serv_dt||' '||decode(e.accid_st,'1','피해','2','가해','3','쌍방','4','운행자차','5','사고자차', '8', '단독') gubun2, \n"+
				"           a.rent_mng_id, a.rent_l_cd, a.car_mng_id, \n"+
				"           decode(e.rent_s_cd,'',b.client_id,d.client_id) client_id, \n"+
				"           decode(e.rent_s_cd,'',b.bus_id2, decode(c.rent_st,'1',c.bus_id,'9',c.bus_id,'12',nvl(c.mng_id,c.bus_id), '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) bus_id2, b.mng_id2, \n"+
				"           nvl(se.ext_est_dt, a.cust_plan_dt) as est_dt, \n"+
				"           (se.ext_s_amt+se.ext_v_amt) as dly_amt, 0 dly_amt2, decode(e.rent_s_cd,'',b.use_yn,d.use_yn) use_yn, decode(e.rent_s_cd,'',b.rent_start_dt,d.rent_start_dt) rent_start_dt, b.car_st \n"+
				"    from   scd_ext se, service a, accident e, cont b, rent_cont c, cont d \n"+
				"    where  se.ext_st = '3' \n"+
				"           and se.rent_mng_id = a.rent_mng_id and se.rent_l_cd = a.rent_l_cd and se.ext_id = a.serv_id \n"+
				"           and a.car_mng_id=e.car_mng_id and a.accid_id=e.accid_id \n"+
				"           and se.rent_mng_id=b.rent_mng_id and se.rent_l_cd=b.rent_l_cd \n"+
				"           and e.rent_s_cd=c.rent_s_cd(+) \n"+
				"           and c.sub_l_cd=d.rent_l_cd(+) \n"+
				"           and se.ext_s_amt>0 and se.ext_pay_dt is null and nvl(se.bill_yn,'Y')='Y' \n"+
				"           and nvl(a.no_dft_yn,'N')='N' \n"+
				"          and e.car_mng_id||e.accid_id not in ('005938014279')  \n"+  //두바이카 정보제공은 면책금에서 제외
				"           and nvl(se.ext_est_dt, a.cust_plan_dt) < to_char(sysdate,'YYYYMMDD') \n"+
				"	 union all \n"+
				"    select '5' sort, '위약금' gubun1, decode(b.cls_st,'1','계약만료','2','중도해지') gubun2, \n"+
				"           a.rent_mng_id, a.rent_l_cd, c.car_mng_id, c.client_id, c.bus_id2, c.mng_id2, \n"+
				"           b.cls_dt as est_dt, \n"+
				"           (a.ext_s_amt+a.ext_v_amt) as dly_amt, 0 dly_amt2, c.use_yn, c.rent_start_dt, c.car_st \n"+
				"    from   scd_ext a, cls_cont b, cont c \n"+
				"    where  a.ext_st = '4' \n"+
				"           and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				"           and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"+
				"           and DECODE(c.car_st,'4',case when b.fdft_amt2 < 0 then 0 else a.ext_s_amt+a.ext_v_amt end,(a.ext_s_amt+a.ext_v_amt)) >0 and a.ext_pay_dt is null and nvl(a.bill_yn,'Y')='Y' \n"+
				"           and nvl(b.cls_doc_yn,'Y')='Y' \n"+
				"           and b.cls_dt < to_char(sysdate,'YYYYMMDD') \n"+
				"    union all \n"+
				"    select '6' sort, '단기요금' gubun1, decode(b.rent_st,'1','단기대여','9','보험대차','12','월렌트','2','정비대차') gubun2, \n"+
				"           '' rent_mng_id, b.rent_s_cd as rent_l_cd, b.car_mng_id, b.cust_id as client_id, b.bus_id as bus_id2, '' mng_id2, \n"+
				"           a.est_dt, \n"+
				"           DECODE(b.RENT_ST||a.rent_st,'123',TRUNC((a.rent_s_amt+a.rent_v_amt)*0.2),'124',TRUNC((a.rent_s_amt+a.rent_v_amt)*0.2),'125',TRUNC((a.rent_s_amt+a.rent_v_amt)*0.2),'128',TRUNC((a.rent_s_amt+a.rent_v_amt)*0.2),(a.rent_s_amt+a.rent_v_amt)) as dly_amt, "+
				"	        (a.rent_s_amt+a.rent_v_amt) dly_amt2, decode(b.ret_dt,'','Y','N') use_yn, b.ret_dt as rent_start_dt, '0' car_st \n"+
				"    from   scd_rent a, rent_cont b \n"+
				"    where  a.rent_s_cd=b.rent_s_cd and b.use_st<>'5' and a.rent_st not in ('7','2') and b.mng_id <>'000126' \n"+
				"           and a.rent_s_amt>0 and a.pay_dt is null and nvl(a.bill_yn,'Y')='Y' \n"+
				"           and a.est_dt < to_char(sysdate,'YYYYMMDD')  \n"+
				"    union all \n"+
				"    select '6' sort, '단기요금' gubun1, decode(b.rent_st,'1','단기대여','9','보험대차','12','월렌트','2','정비대차') gubun2, \n"+
				"           '' rent_mng_id, b.rent_s_cd as rent_l_cd, b.car_mng_id, b.cust_id as client_id, NVL(b.mng_id,b.bus_id) as bus_id2, '' mng_id2, \n"+
				"           a.est_dt, \n"+
				"           TRUNC((a.rent_s_amt+a.rent_v_amt)*0.8) as dly_amt, (a.rent_s_amt+a.rent_v_amt) dly_amt2, "+
				"		    decode(b.ret_dt,'','Y','N') use_yn, b.ret_dt as rent_start_dt, '0' car_st \n"+
				"    from   scd_rent a, rent_cont b \n"+
				"    where  a.rent_s_cd=b.rent_s_cd and b.use_st<>'5' \n"+
				"           and a.rent_s_amt>0 and a.pay_dt is null and nvl(a.bill_yn,'Y')='Y' \n"+
				"           and a.est_dt < to_char(sysdate,'YYYYMMDD') \n"+
				"           AND b.RENT_ST='12' AND a.rent_st IN ('3','4','5','8') "+		
				"	 union all		 \n"+
				"    select '9' sort, '연체이자' gubun1, '-' gubun2, \n"+
				"          c.rent_mng_id, c.rent_l_cd, c.car_mng_id, c.client_id, DECODE(c.car_st,'4',c.mng_id,c.bus_id2) bus_id2, c.mng_id2, \n"+
				"          '' as est_dt, \n"+
				"          nvl(a.dly_fee,0)-nvl(b.pay_amt,0) dly_amt, 0 dly_amt2, c.use_yn, c.rent_start_dt, '0' car_st \n"+
				"    from  (select rent_mng_id, rent_l_cd, sum(dly_fee) dly_fee from scd_fee where rent_l_cd not like 'RM%' group by rent_mng_id, rent_l_cd) a, "+
				"	       (select rent_mng_id, rent_l_cd, sum(pay_amt) pay_amt from scd_dly where rent_l_cd not like 'RM%' group by rent_mng_id, rent_l_cd) b, "+
				"	       cont c, \n"+
                "          (SELECT * FROM CLS_CONT WHERE cls_dt>'20091231' AND cls_st IN ('4','5')) d \n"+
				"    where a.rent_mng_id=b.rent_mng_id(+) and a.rent_l_cd=b.rent_l_cd(+) "+ 
				"          and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"+
			//	"          and nvl(a.dly_fee,0)-nvl(b.pay_amt,0)<>0 AND c.rent_l_cd not like 'RM%' \n"+ 202012 0보다 큰거
				"          and nvl(a.dly_fee,0)-nvl(b.pay_amt,0)> 0 AND c.rent_l_cd not like 'RM%' \n"+
                "          AND c.rent_mng_id=d.rent_mng_id(+) AND c.rent_l_cd=d.rent_l_cd(+) and DECODE(d.cls_st,'4','Y','5','Y',c.use_yn)='Y' \n"+
				" ) a, car_reg b, client c, users d, "+
				"   	cms_mng e, cls_cont f, (select rent_mng_id, rent_l_cd, max(seq) seq from cms_mng group by rent_mng_id, rent_l_cd) h, cust g, \n"+
				" ( select a.rent_mng_id, a.rent_l_cd, case when a.reg_dt = b.p_reg_dt then a.promise_dt else '' end promise_dt from  \n"+
			    "          ( select rent_mng_id, rent_l_cd, max(reg_dt) reg_dt, max(promise_dt) promise_dt from dly_mm  group by rent_mng_id, rent_l_cd ) a, \n"+
				"          ( select rent_mng_id, rent_l_cd, max(reg_dt) p_reg_dt from dly_mm where promise_dt is not null group by rent_mng_id, rent_l_cd ) b \n"+
				"   where a.rent_mng_id = b.rent_mng_id(+) and a.rent_l_cd = b.rent_l_cd(+)  \n"+
				" ) p \n"+ 

	  //최종등록일에 납부약속일이 없으면 없는것 -  20140915			
          //      "       (select rent_mng_id, rent_l_cd, max(promise_dt) promise_dt from dly_mm where promise_dt is not null group by rent_mng_id, rent_l_cd) p \n"+ 
				" where a.bus_id2='"+bus_id2+"' and a.car_mng_id=b.car_mng_id(+) and a.client_id=c.client_id(+) and a.bus_id2=d.user_id and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+)\n"+
				"       and a.rent_mng_id=f.rent_mng_id(+) and a.rent_l_cd=f.rent_l_cd(+) "+
				"	    and e.rent_mng_id=h.rent_mng_id(+) and e.rent_l_cd=h.rent_l_cd(+) and e.seq=h.seq(+) and e.rent_l_cd=g.code(+) "+
				"       and a.rent_mng_id=p.rent_mng_id(+) and a.rent_l_cd=p.rent_l_cd(+) "+
				" order by a.sort, a.use_yn, a.client_id, a.car_mng_id, a.est_dt "+
				" ";

		 
		try {
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
			System.out.println("[SettleDatabase:getStatSettleSubList]\n"+e);
			System.out.println("[SettleDatabase:getStatSettleSubList]\n"+query);
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


	//연체업체 세부리스트
	public Vector getStatSettleSubListClient(String client_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";



		query = " select \n"+
				"        a.*, b.car_no, b.car_nm, c.firm_nm, d.user_nm, e.cms_bank, f.cls_dt, "+
				"        decode(g.cbit,'1','신규','2','승인','3','해지신청','4','해지완료','7','임의해지','8','신고에러') cbit, g.ldate, nvl(p.promise_dt,'') promise_dt \n"+
				" from \n"+

				" ( \n"+
				"	 select '1' sort, '선수금' gubun1, decode(a.ext_st,'0','보증금','1','선납금','2','개시대여료', '5', '승계수수료') gubun2, \n"+
				"           a.rent_mng_id, a.rent_l_cd, c.car_mng_id, c.client_id, decode(a.ext_st,'5',NVL(b.ext_agnt,c.bus_id2),decode(b.rent_st,'1',decode(e.rent_l_cd,'',DECODE(c.bus_st,'7',c.bus_id2,c.bus_id),c.bus_id2),c.bus_id2)) bus_id2, c.mng_id2, \n"+
				"           decode(a.ext_st, '5', nvl(d.rent_suc_dt,b.rent_start_dt), nvl(d.rent_suc_dt,b.rent_start_dt)) as est_dt, "+
				"           (a.ext_s_amt+a.ext_v_amt) dly_amt, 0 dly_amt2, c.use_yn, c.rent_start_dt, c.car_st \n"+
				"	 from   cont c, scd_ext a, fee b, cont_etc d, (select * from cls_cont where cls_st in ('4','5')) e \n"+
				"    where  c.client_id='"+client_id+"' and a.ext_st in ('0', '1', '2', '5' ) \n"+
				"          and a.ext_s_amt>0 and a.ext_pay_dt is null and nvl(a.bill_yn,'Y')='Y' \n"+
				"          and c.rent_mng_id=a.rent_mng_id and c.rent_l_cd=a.rent_l_cd \n"+
				"          and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st \n"+
				"          and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd=d.rent_l_cd "+
				"          and c.rent_mng_id=e.rent_mng_id(+) and c.reg_dt=e.reg_dt(+) "+
				"          and decode(a.ext_st,'5',nvl(d.rent_suc_dt,a.ext_est_dt), \n"+//승계수수료
                "                     decode(c.rent_st||b.rent_st||b.grt_suc_yn||a.ext_st,'3100', \n"+//--대차승계보증금
                "                            decode(a.gubun,'E',a.ext_est_dt, \n"+
                "                                   to_char(to_date(nvl(b.rent_start_dt,to_char(sysdate,'YYYYMMDD')),'YYYYMMDD')+15,'YYYYMMDD') \n"+
                "                            ), \n"+
				"                            case when d.rent_suc_dt is not null and d.rent_suc_dt > b.rent_start_dt then d.rent_suc_dt \n"+
                "                                                             WHEN d.rent_suc_dt IS NULL AND a.ext_st='5' THEN a.ext_est_dt  \n"+ 
                "                                                             else b.rent_start_dt end \n"+
                "                     ) \n"+
                "              ) < to_char(sysdate,'YYYYMMDD') \n"+

				"	 union all		 \n"+
				"    select '2' sort, '대여료' gubun1, a.fee_tm||'회'||decode(a.tm_st1,'0','','(잔액)') gubun2, \n"+
				"          a.rent_mng_id, a.rent_l_cd, b.car_mng_id, b.client_id, DECODE(b.car_st,'4',b.mng_id,b.bus_id2) bus_id2, b.mng_id2, \n"+
				"          a.r_fee_est_dt as est_dt, \n"+
				"          (a.fee_s_amt+a.fee_v_amt) dly_amt, 0 dly_amt2, b.use_yn, b.rent_start_dt, b.car_st \n"+
				"    from  cont b, scd_fee a \n"+
				"    where b.client_id='"+client_id+"' and b.rent_mng_id=a.rent_mng_id and b.rent_l_cd=a.rent_l_cd \n"+
				"          and a.fee_s_amt>0 and a.rc_dt is null and nvl(a.bill_yn,'Y')='Y' \n"+
				"          and a.r_fee_est_dt < to_char(sysdate,'YYYYMMDD')            \n"+
                
				"    union all \n"+
				"    select '3' sort, '과태료' gubun1, substr(a.vio_dt,1,8)||' '||a.vio_cont||'-'||decode(a.fault_st,'1','고객과실','업무상과실') as gubun2, \n"+
				"           a.rent_mng_id, a.rent_l_cd, b.car_mng_id, \n"+
				"           decode(c.rent_s_cd,'',b.client_id, decode(c.cust_st, '4', '000228',  c.cust_id)  ) client_id, \n"+ //업무대여인건 client_id : 아마존카로 처리 -
				"           decode(a.rent_s_cd,'',decode(a.fault_st,'2',nvl(a.fault_nm,b.bus_id2),b.bus_id2), decode(c.rent_st,'1',c.bus_id,'9',c.bus_id,'12',nvl(c.mng_id,c.bus_id), '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id,c.bus_id)) bus_id2, b.mng_id2, \n"+
				"           nvl(a.rec_plan_dt,nvl(a.dem_dt,a.paid_end_dt)) as est_dt, \n"+
				"           a.paid_amt as dly_amt, 0 dly_amt2, decode(c.rent_s_cd,'',b.use_yn,d.use_yn) use_yn, b.rent_start_dt, b.car_st \n"+
				"    from   fine a, cont b, rent_cont c, cont d \n"+
				"    where  \n"+
				"           a.paid_amt>0 and a.coll_dt is null and decode(a.fault_st,'2', 'Y', '3', 'N', nvl(a.bill_yn,'Y'))='Y' \n"+
				"           and a.paid_st in ('3','4') and nvl(a.no_paid_yn,'N')='N' \n"+
				"           and ( (a.vio_cont not like  '%통행료%'and a.vio_cont not like  '%주차요금%') or  ( a.vio_cont like  '%통행료%' and a.proxy_dt is not null ) or ( a.vio_cont like  '%주차요금%' and a.proxy_dt is not null )  )"+
				"           and nvl(a.rec_plan_dt,nvl(a.dem_dt,a.paid_end_dt)) < to_char(sysdate,'YYYYMMDD') \n"+
				"           and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd  \n"+
				"           and a.rent_s_cd=c.rent_s_cd(+)  AND NVL(c.use_st,'0')<>'5' "+
				"	        and decode(c.rent_s_cd,'',b.client_id, decode(c.cust_st, '4', '000228',  c.cust_id)  )='"+client_id+"' \n"+
				"           and c.sub_l_cd=d.rent_l_cd(+) \n"+

				"	 union all \n"+
				"    select '4' sort, '면책금' gubun1, a.serv_dt||' '||decode(e.accid_st,'1','피해','2','가해','3','쌍방','4','운행자차','5','사고자차', '8', '단독') gubun2, \n"+
				"           a.rent_mng_id, a.rent_l_cd, a.car_mng_id, \n"+
				"           decode(e.rent_s_cd,'',b.client_id,d.client_id) client_id, \n"+
				"           decode(e.rent_s_cd,'',b.bus_id2, decode(c.rent_st,'1',c.bus_id,'9',c.bus_id,'12',nvl(c.mng_id,c.bus_id), '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) bus_id2, b.mng_id2, \n"+
				"           nvl(se.ext_est_dt, a.cust_plan_dt) as est_dt, \n"+
				"           (se.ext_s_amt+se.ext_v_amt) as dly_amt, 0 dly_amt2, decode(e.rent_s_cd,'',b.use_yn,d.use_yn) use_yn, decode(e.rent_s_cd,'',b.rent_start_dt,d.rent_start_dt) rent_start_dt, b.car_st \n"+
				"    from   scd_ext se, service a, accident e, cont b, rent_cont c, cont d \n"+
				"    where  se.ext_st = '3' \n"+
				"           and se.ext_s_amt>0 and se.ext_pay_dt is null and nvl(se.bill_yn,'Y')='Y' \n"+
				"           and nvl(se.ext_est_dt, a.cust_plan_dt) < to_char(sysdate,'YYYYMMDD') \n"+
				"           and se.rent_mng_id = a.rent_mng_id and se.rent_l_cd = a.rent_l_cd and se.ext_id = a.serv_id \n"+
				"           and nvl(a.no_dft_yn,'N')='N' \n"+
				"           and a.car_mng_id=e.car_mng_id and a.accid_id=e.accid_id \n"+
				"           and se.rent_mng_id=b.rent_mng_id and se.rent_l_cd=b.rent_l_cd \n"+
				"           and e.rent_s_cd=c.rent_s_cd(+)  and decode(e.rent_s_cd,'',b.client_id,d.client_id)='"+client_id+"' \n"+
				"           and c.sub_l_cd=d.rent_l_cd(+) \n"+
				"          and e.car_mng_id||e.accid_id not in ('005938014279')  \n"+  //두바이카 정보제공은 면책금에서 제외

				"	 union all \n"+
				"    select '5' sort, '위약금' gubun1, decode(b.cls_st,'1','계약만료','2','중도해지') gubun2, \n"+
				"           a.rent_mng_id, a.rent_l_cd, c.car_mng_id, c.client_id, c.bus_id2, c.mng_id2, \n"+
				"           b.cls_dt as est_dt, \n"+
				"           (a.ext_s_amt+a.ext_v_amt) as dly_amt, 0 dly_amt2, c.use_yn, c.rent_start_dt, c.car_st \n"+
				"    from   cont c, scd_ext a, cls_cont b \n"+
				"    where  c.client_id='"+client_id+"' and a.ext_st = '4' \n"+
				"	        and a.ext_pay_dt is null and nvl(a.bill_yn,'Y')='Y' \n"+
				"           and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				"           and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"+
				"           and DECODE(c.car_st,'4',case when b.fdft_amt2 < 0 then 0 else a.ext_s_amt+a.ext_v_amt end,(a.ext_s_amt+a.ext_v_amt)) >0 "+
				"           and nvl(b.cls_doc_yn,'Y')='Y' \n"+
				"           and b.cls_dt < to_char(sysdate,'YYYYMMDD') \n"+

				"    union all \n"+
				"    select '6' sort, '단기요금' gubun1, decode(b.rent_st,'1','단기대여','9','보험대차','12','월렌트','2','정비대차') gubun2, \n"+
				"           '' rent_mng_id, b.rent_s_cd as rent_l_cd, b.car_mng_id, b.cust_id as client_id, b.bus_id as bus_id2, '' mng_id2, \n"+
				"           a.est_dt, \n"+
				"           DECODE(b.RENT_ST||a.rent_st,'123',TRUNC((a.rent_s_amt+a.rent_v_amt)*0.2),'124',TRUNC((a.rent_s_amt+a.rent_v_amt)*0.2),'125',TRUNC((a.rent_s_amt+a.rent_v_amt)*0.2),'128',TRUNC((a.rent_s_amt+a.rent_v_amt)*0.2),(a.rent_s_amt+a.rent_v_amt)) as dly_amt, "+
				"	        (a.rent_s_amt+a.rent_v_amt) dly_amt2, decode(b.ret_dt,'','Y','N') use_yn, b.ret_dt as rent_start_dt, '0' car_st \n"+
				"    from   rent_cont b, scd_rent a \n"+
				"    where  b.cust_id='"+client_id+"' and b.use_st<>'5' and b.mng_id <>'000126' "+
				"	        and a.rent_s_cd=b.rent_s_cd and a.rent_st not in ('7','2')  \n"+
				"           and a.rent_s_amt>0 and a.pay_dt is null and nvl(a.bill_yn,'Y')='Y' \n"+
				"           and a.est_dt < to_char(sysdate,'YYYYMMDD')  \n"+

				"    union all \n"+
				"    select '6' sort, '단기요금' gubun1, decode(b.rent_st,'1','단기대여','9','보험대차','12','월렌트','2','정비대차') gubun2, \n"+
				"           '' rent_mng_id, b.rent_s_cd as rent_l_cd, b.car_mng_id, b.cust_id as client_id, NVL(b.mng_id,b.bus_id) as bus_id2, '' mng_id2, \n"+
				"           a.est_dt, \n"+
				"           TRUNC((a.rent_s_amt+a.rent_v_amt)*0.8) as dly_amt, (a.rent_s_amt+a.rent_v_amt) dly_amt2, "+
				"		    decode(b.ret_dt,'','Y','N') use_yn, b.ret_dt as rent_start_dt, '0' car_st \n"+
				"    from   rent_cont b, scd_rent a \n"+
				"    where  b.cust_id='"+client_id+"' and b.use_st<>'5' "+
				"           AND b.RENT_ST='12' AND a.rent_st IN ('3','4','5','8') "+		
				"	        and b.rent_s_cd=a.rent_s_cd \n"+
				"           and a.rent_s_amt>0 and a.pay_dt is null and nvl(a.bill_yn,'Y')='Y' \n"+
				"           and a.est_dt < to_char(sysdate,'YYYYMMDD') \n"+

				"	 union all		 \n"+
				"    select '9' sort, '연체이자' gubun1, '-' gubun2, \n"+
				"          c.rent_mng_id, c.rent_l_cd, c.car_mng_id, c.client_id, DECODE(c.car_st,'4',c.mng_id,c.bus_id2) bus_id2, c.mng_id2, \n"+
				"          '' as est_dt, \n"+
				"          nvl(a.dly_fee,0)-nvl(b.pay_amt,0) dly_amt, 0 dly_amt2, c.use_yn, c.rent_start_dt, '0' car_st \n"+
				"    from  cont c, \n"+
				"	       (select rent_mng_id, rent_l_cd, sum(dly_fee) dly_fee from scd_fee where rent_l_cd not like 'RM%' group by rent_mng_id, rent_l_cd) a, \n"+
				"	       (select rent_mng_id, rent_l_cd, sum(pay_amt) pay_amt from scd_dly where rent_l_cd not like 'RM%' group by rent_mng_id, rent_l_cd) b, \n"+
                "          (SELECT * FROM CLS_CONT WHERE cls_dt>'20091231' AND cls_st IN ('4','5')) d \n"+
				"    where c.client_id='"+client_id+"' AND c.rent_l_cd not like 'RM%' \n"+
				"          and c.rent_mng_id=a.rent_mng_id and c.rent_l_cd=a.rent_l_cd \n"+
				"	       and a.rent_mng_id=b.rent_mng_id(+) and a.rent_l_cd=b.rent_l_cd(+) "+ 
				"          and nvl(a.dly_fee,0)-nvl(b.pay_amt,0)<>0 \n"+
                "          AND c.rent_mng_id=d.rent_mng_id(+) AND c.rent_l_cd=d.rent_l_cd(+) "+
				"	       and DECODE(d.cls_st,'4','Y','5','Y',c.use_yn)='Y' \n"+
				" ) a, "+

				"	car_reg b, client c, users d, "+
				"   cms_mng e, cls_cont f, "+
				" ( select rent_mng_id, rent_l_cd, max(seq) seq from cms_mng group by rent_mng_id, rent_l_cd) h, cust g, \n"+
				" ( select a.rent_mng_id, a.rent_l_cd, case when a.reg_dt = b.p_reg_dt then a.promise_dt else '' end promise_dt from  \n"+
			    "          ( select rent_mng_id, rent_l_cd, max(reg_dt) reg_dt, max(promise_dt) promise_dt from dly_mm  group by rent_mng_id, rent_l_cd ) a, \n"+
				"          ( select rent_mng_id, rent_l_cd, max(reg_dt) p_reg_dt from dly_mm where promise_dt is not null group by rent_mng_id, rent_l_cd ) b \n"+
				"   where a.rent_mng_id = b.rent_mng_id(+) and a.rent_l_cd = b.rent_l_cd(+)  \n"+
				" ) p \n"+ 
				" where a.client_id='"+client_id+"' and a.car_mng_id=b.car_mng_id(+) and a.client_id=c.client_id(+) and a.bus_id2=d.user_id and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+)\n"+
				"       and a.rent_mng_id=f.rent_mng_id(+) and a.rent_l_cd=f.rent_l_cd(+) "+
				"	    and e.rent_mng_id=h.rent_mng_id(+) and e.rent_l_cd=h.rent_l_cd(+) and e.seq=h.seq(+) and e.rent_l_cd=g.code(+) "+
				"       and a.rent_mng_id=p.rent_mng_id(+) and a.rent_l_cd=p.rent_l_cd(+) "+
				" order by a.sort, a.use_yn, a.client_id, a.car_mng_id, a.est_dt "+
				" ";

		 
		try {
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
			System.out.println("[SettleDatabase:getStatSettleSubListClient]\n"+e);
			System.out.println("[SettleDatabase:getStatSettleSubListClient]\n"+query);
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

	//채권관리캠페인 담당자별 세부리스트 :: 2군 영업 20140411
	public Vector getStatSettleSubList2Gun(String bus_id2)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		int settle_mon = 12; //채권반영개월수



		query = " select \n"+
				"        a.*, b.car_no, b.car_nm, c.firm_nm, d.user_nm, e.cms_bank, f.cls_dt, "+
				"        decode(g.cbit,'1','신규','2','승인','3','해지신청','4','해지완료','7','임의해지','8','신고에러') cbit, g.ldate, nvl(p.promise_dt,'') promise_dt \n"+
				" from \n"+
				" ( \n"+
				"	 select '1' sort, '선수금' gubun1, decode(a.ext_st,'0','보증금','1','선납금','2','개시대여료', '5', '승계수수료') gubun2, \n"+
				"           a.rent_mng_id, a.rent_l_cd, c.car_mng_id, c.client_id, decode(a.ext_st,'5',NVL(b.ext_agnt,c.bus_id2),decode(b.rent_st,'1',decode(e.rent_l_cd,'',c.bus_id,c.bus_id2),c.bus_id2)) bus_id2, c.bus_id, \n"+
				"           decode(a.ext_st, '5', nvl(d.rent_suc_dt,b.rent_start_dt), nvl(d.rent_suc_dt,b.rent_start_dt)) as est_dt, "+
				"           (a.ext_s_amt+a.ext_v_amt) dly_amt, 0 dly_amt2, c.use_yn, c.rent_start_dt \n"+
				"	 from   scd_ext a, fee b, cont c, cont_etc d, (select * from cls_cont where cls_st in ('4','5')) e \n"+
				"    where  a.ext_st in ('0', '1', '2', '5' ) \n"+
				"          and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st \n"+
				"          and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and c.bus_id='"+bus_id2+"' \n"+
				"          and a.rent_mng_id = d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+)"+
				"          and c.rent_mng_id=e.rent_mng_id(+) and c.reg_dt=e.reg_dt(+) "+
				"          and a.ext_s_amt>0 and a.ext_pay_dt is null and nvl(a.bill_yn,'Y')='Y' \n"+
//				"          and decode(a.ext_st,'5',a.ext_est_dt,decode(c.rent_st||b.rent_st||b.grt_suc_yn||a.ext_st,'3100', to_char(add_months(to_date(nvl(c.dlv_dt,to_char(sysdate,'YYYYMMDD')),'YYYYMMDD'),1),'YYYYMMDD'), nvl(d.rent_suc_dt,b.rent_start_dt))) < to_char(sysdate,'YYYYMMDD') \n"+
				"          and decode(a.ext_st,'5',nvl(d.rent_suc_dt,a.ext_est_dt), \n"+//승계수수료
                "                     decode(c.rent_st||b.rent_st||b.grt_suc_yn||a.ext_st,'3100', \n"+//--대차승계보증금
                "                            decode(a.gubun,'E',a.ext_est_dt, \n"+
                "                                   to_char(to_date(nvl(b.rent_start_dt,to_char(sysdate,'YYYYMMDD')),'YYYYMMDD')+15,'YYYYMMDD') \n"+
                "                            ), \n"+
//              "                            nvl(d.rent_suc_dt,b.rent_start_dt) \n"+
				"                            case when d.rent_suc_dt is not null and d.rent_suc_dt > b.rent_start_dt then d.rent_suc_dt \n"+
                "                                                             WHEN d.rent_suc_dt IS NULL AND a.ext_st='5' THEN a.ext_est_dt  \n"+ 
                "                                                             else b.rent_start_dt end \n"+
                "                     ) \n"+
                "              ) < to_char(sysdate,'YYYYMMDD') \n"+
				"	       AND TO_CHAR(ADD_MONTHS(sysdate,-"+settle_mon+"),'YYYYMMDD') < nvl(c.rent_start_dt,to_char(sysdate,'YYYYMMDD')) \n"+

				"	 union all		 \n"+

				"    select '2' sort, '대여료' gubun1, a.fee_tm||'회'||decode(a.tm_st1,'0','','(잔액)') gubun2, \n"+
				"          a.rent_mng_id, a.rent_l_cd, b.car_mng_id, b.client_id, DECODE(b.car_st,'4',b.mng_id,b.bus_id2) bus_id2, CASE WHEN e.rent_l_cd IS NOT NULL AND e.rent_suc_dt > d.rent_dt THEN NVL(d.ext_agnt,b.bus_id) ELSE b.bus_id end as bus_id, \n"+
				"          a.r_fee_est_dt as est_dt, \n"+
				"          (a.fee_s_amt+a.fee_v_amt) dly_amt, 0 dly_amt2, b.use_yn, b.rent_start_dt \n"+
				"    from  scd_fee a, cont b, FEE d, CONT_ETC e \n"+
				"    where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and CASE WHEN e.rent_l_cd IS NOT NULL AND e.rent_suc_dt > d.rent_dt THEN NVL(d.ext_agnt,b.bus_id) ELSE b.bus_id end='"+bus_id2+"' \n"+
				"          and a.fee_s_amt>0 and a.rc_dt is null and nvl(a.bill_yn,'Y')='Y' \n"+
				"          and a.r_fee_est_dt < to_char(sysdate,'YYYYMMDD')            \n"+
				"	       AND TO_CHAR(ADD_MONTHS(sysdate,-"+settle_mon+"),'YYYYMMDD') < nvl(b.rent_start_dt,to_char(sysdate,'YYYYMMDD')) \n"+
                "          AND a.rent_mng_id=d.rent_mng_id AND a.rent_l_cd=d.rent_l_cd AND a.rent_st=d.rent_st \n"+
                "          AND b.rent_mng_id=e.rent_mng_id AND b.rent_l_cd=e.rent_l_cd \n"+

				"	 union all		 \n"+

                "    select '2_2' sort, '대여료' gubun1, '미청구분+잔가' gubun2,  \n"+
                "           rent_mng_id, rent_l_cd, car_mng_id, client_id, bus_id2, bus_id, \n"+
                "           bas_end_dt as est_dt, (dly_amt+o_1) dly_amt, 0 dly_amt2, use_yn, rent_start_dt \n"+
                "           from \n"+
                "           ( select a.use_yn, a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.bus_id2, a.bus_id, a.rent_start_dt, \n"+
                "                    case when b.rent_end_dt > d.fee_est_dt then b.rent_end_dt else d.fee_est_dt end bas_end_dt, \n"+
                "                    trunc((b.fee_s_amt+b.fee_v_amt)/30*to_number(sysdate-to_date(case when b.rent_end_dt > d.fee_est_dt then b.rent_end_dt else d.fee_est_dt end,'YYYYMMDD')),0) dly_amt, \n"+
                "                    decode(e.fee_opt_amt,0,nvl(e.o_1,0),e.fee_opt_amt) as o_1 \n"+
                "             from   cont a, fee b, \n"+
                "                    (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) c, \n"+
                "                    (select rent_mng_id, rent_l_cd, max(use_e_dt) fee_est_dt from scd_fee group by rent_mng_id, rent_l_cd) d, \n"+
                "                    (select * from estimate_sh where est_from='car_janga' and rent_dt=to_char(sysdate,'YYYYMMDD')) e, cls_etc f, \n"+
				"                    ( select * from car_call_in where in_st='3' and out_dt is null ) cc \n"+
                "             where  a.bus_id='"+bus_id2+"' and a.use_yn='Y' and a.car_st in ('1','3') and b.rent_start_dt is not null \n"+
                "             and    a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
                "             and    b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st \n"+
                "             and    a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd \n"+
                "             and    b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd and b.rent_st=e.rent_st \n"+
                "             and    a.rent_mng_id=f.rent_mng_id(+) and a.rent_l_cd=f.rent_l_cd(+) and f.rent_l_cd is null \n"+  
				"             and    a.rent_mng_id=cc.rent_mng_id(+) and a.rent_l_cd=cc.rent_l_cd(+) and cc.rent_l_cd is null \n"+	
//                "             and    sysdate-to_date(case when b.rent_end_dt > d.fee_est_dt then b.rent_end_dt else d.fee_est_dt end,'YYYYMMDD')>0 \n"+
                "             and    b.rent_end_dt < to_char(sysdate,'YYYYMMDD') and d.fee_est_dt < to_char(sysdate,'YYYYMMDD') \n"+//--20140729 3일경과일부터 채권에 나오게
				"	          AND    TO_CHAR(ADD_MONTHS(sysdate,-"+settle_mon+"),'YYYYMMDD') < nvl(a.rent_start_dt,to_char(sysdate,'YYYYMMDD')) \n"+
                "           )           \n"+		

				"    union all \n"+

				"    select '3' sort, '과태료' gubun1, substr(a.vio_dt,1,8)||' '||a.vio_cont||'-'||decode(a.fault_st,'1','고객과실','업무상과실') as gubun2, \n"+
				"           a.rent_mng_id, a.rent_l_cd, b.car_mng_id, \n"+
				"           decode(c.rent_s_cd,'',b.client_id, decode(c.cust_st, '4', '000228',  c.cust_id)  ) client_id, \n"+ //업무대여인건 client_id : 아마존카로 처리 -
				"           decode(a.rent_s_cd,'',decode(a.fault_st,'2',nvl(a.fault_nm,b.bus_id2),b.bus_id2), decode(c.rent_st,'1',c.bus_id,'9',c.bus_id,'12',nvl(c.mng_id,c.bus_id), '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id,c.bus_id)) bus_id2, \n"+
				"           b.bus_id, \n"+
				"           nvl(a.rec_plan_dt,nvl(a.dem_dt,a.paid_end_dt)) as est_dt, \n"+
				"           a.paid_amt as dly_amt, 0 dly_amt2, decode(c.rent_s_cd,'',b.use_yn,d.use_yn) use_yn, b.rent_start_dt \n"+
				"    from   fine a, cont b, rent_cont c, cont d \n"+
				"    where  a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.bus_id='"+bus_id2+"' \n"+
				"           and a.rent_s_cd=c.rent_s_cd(+)  AND NVL(c.use_st,'0')<>'5' \n"+
				"           and c.sub_l_cd=d.rent_l_cd(+) \n"+
				"           and a.paid_amt>0 and a.coll_dt is null and decode(a.fault_st,'2', 'Y', '3', 'N', nvl(a.bill_yn,'Y'))='Y' \n"+
				"           and a.paid_st in ('3','4') and nvl(a.no_paid_yn,'N')='N' \n"+
//				"           and nvl(c.cust_st,'0')<>'1' \n"+
//				"           and a.vio_cont not like '%통행료%'  \n"+
				"           and ( (a.vio_cont not like  '%통행료%'and a.vio_cont not like  '%주차요금%') or  ( a.vio_cont like  '%통행료%' and a.proxy_dt is not null ) or ( a.vio_cont like  '%주차요금%' and a.proxy_dt is not null )  )"+
				"           and nvl(a.rec_plan_dt,nvl(a.dem_dt,a.paid_end_dt)) < to_char(sysdate,'YYYYMMDD') \n"+
				"	        AND TO_CHAR(ADD_MONTHS(sysdate,-"+settle_mon+"),'YYYYMMDD') < nvl(b.rent_start_dt,to_char(sysdate,'YYYYMMDD')) \n"+

				"	 union all \n"+

				"    select '4' sort, '면책금' gubun1, a.serv_dt||' '||decode(e.accid_st,'1','피해','2','가해','3','쌍방','4','운행자차','5','사고자차', '8', '단독') gubun2, \n"+
				"           a.rent_mng_id, a.rent_l_cd, a.car_mng_id, \n"+
				"           decode(e.rent_s_cd,'',b.client_id,d.client_id) client_id, \n"+
				"           decode(e.rent_s_cd,'',b.bus_id2, decode(c.rent_st,'1',c.bus_id,'9',c.bus_id,'12',nvl(c.mng_id,c.bus_id), '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) bus_id2, \n"+
				"           b.bus_id, \n"+
				"           nvl(se.ext_est_dt, a.cust_plan_dt) as est_dt, \n"+
				"           (se.ext_s_amt+se.ext_v_amt) as dly_amt, 0 dly_amt2, decode(e.rent_s_cd,'',b.use_yn,d.use_yn) use_yn, decode(e.rent_s_cd,'',b.rent_start_dt,d.rent_start_dt) rent_start_dt \n"+
				"    from   scd_ext se, service a, accident e, cont b, rent_cont c, cont d \n"+
				"    where  se.ext_st = '3' \n"+
				"           and se.rent_mng_id = a.rent_mng_id and se.rent_l_cd = a.rent_l_cd and se.ext_id = a.serv_id \n"+
				"           and a.car_mng_id=e.car_mng_id and a.accid_id=e.accid_id \n"+
				"           and se.rent_mng_id=b.rent_mng_id and se.rent_l_cd=b.rent_l_cd and b.bus_id='"+bus_id2+"' \n"+
				"           and e.rent_s_cd=c.rent_s_cd(+) \n"+
				"           and c.sub_l_cd=d.rent_l_cd(+) \n"+
				"           and se.ext_s_amt>0 and se.ext_pay_dt is null and nvl(se.bill_yn,'Y')='Y' \n"+
				"           and nvl(a.no_dft_yn,'N')='N' \n"+
				"           and e.car_mng_id||e.accid_id not in ('005938014279')  \n"+  //두바이카 정보제공은 면책금에서 제외
				"           and nvl(se.ext_est_dt, a.cust_plan_dt) < to_char(sysdate,'YYYYMMDD') \n"+
				"	        AND TO_CHAR(ADD_MONTHS(sysdate,-"+settle_mon+"),'YYYYMMDD') < nvl(b.rent_start_dt,to_char(sysdate,'YYYYMMDD')) \n"+

				"	 union all \n"+

				"    select '5' sort, '위약금' gubun1, decode(b.cls_st,'1','계약만료','2','중도해지') gubun2, \n"+
				"           a.rent_mng_id, a.rent_l_cd, c.car_mng_id, c.client_id, c.bus_id2, c.bus_id, \n"+
				"           b.cls_dt as est_dt, \n"+
				"           (a.ext_s_amt+a.ext_v_amt) as dly_amt, 0 dly_amt2, c.use_yn, c.rent_start_dt \n"+
				"    from   scd_ext a, cls_cont b, cont c \n"+
				"    where  a.ext_st = '4' \n"+
				"           and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				"           and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and c.bus_id='"+bus_id2+"' \n"+
				"           and DECODE(c.car_st,'4',case when b.fdft_amt2 < 0 then 0 else a.ext_s_amt+a.ext_v_amt end,(a.ext_s_amt+a.ext_v_amt)) >0 and a.ext_pay_dt is null and nvl(a.bill_yn,'Y')='Y' \n"+
				"           and nvl(b.cls_doc_yn,'Y')='Y' \n"+
				"           and b.cls_dt < to_char(sysdate,'YYYYMMDD') \n"+
				"	        AND TO_CHAR(ADD_MONTHS(sysdate,-"+settle_mon+"),'YYYYMMDD') < nvl(c.rent_start_dt,to_char(sysdate,'YYYYMMDD')) \n"+  
			//	"	        AND TO_CHAR(ADD_MONTHS(sysdate,-3),'YYYYMMDD') < nvl(b.cls_dt,to_char(sysdate,'YYYYMMDD')) \n"+  //--> 20140725 2군 위약금은 해지일기준 3개월 적용
				"           and DECODE(c.car_st,'4',TO_CHAR(ADD_MONTHS(sysdate,-2),'YYYYMMDD') , TO_CHAR(ADD_MONTHS(sysdate,-3),'YYYYMMDD') )  < nvl(b.cls_dt,to_char(sysdate,'YYYYMMDD'))  \n"+ //  --월렌트는 해지2개월까지 - 20200922수정
				"           AND DECODE(c.car_st||c.mng_id,'4000126','N','Y')='Y' \n"+ //--월렌트이면서 관리담당자가 장혁준일때는 제외

				"    union all \n"+

				"    select '6' sort, '단기요금' gubun1, decode(b.rent_st,'1','단기대여','9','보험대차','12','월렌트','2','정비대차') gubun2, \n"+
				"           '' rent_mng_id, b.rent_s_cd as rent_l_cd, b.car_mng_id, b.cust_id as client_id, b.bus_id as bus_id2, b.bus_id, \n"+
				"           a.est_dt, \n"+
				"           DECODE(b.RENT_ST||a.rent_st,'123',TRUNC((a.rent_s_amt+a.rent_v_amt)*0.2),'124',TRUNC((a.rent_s_amt+a.rent_v_amt)*0.2),'125',TRUNC((a.rent_s_amt+a.rent_v_amt)*0.2),'128',TRUNC((a.rent_s_amt+a.rent_v_amt)*0.2),(a.rent_s_amt+a.rent_v_amt)) as dly_amt, "+
				"	        (a.rent_s_amt+a.rent_v_amt) dly_amt2, decode(b.ret_dt,'','Y','N') use_yn, b.ret_dt as rent_start_dt \n"+
				"    from   scd_rent a, rent_cont b \n"+
				"    where  a.rent_s_cd=b.rent_s_cd and b.bus_id='"+bus_id2+"' and b.use_st<>'5' and a.rent_st not in ('7','2') and b.mng_id <>'000126' \n"+
				"           and a.rent_s_amt>0 and a.pay_dt is null and nvl(a.bill_yn,'Y')='Y' \n"+
				"           and a.est_dt < to_char(sysdate,'YYYYMMDD')  \n"+
				"	        AND TO_CHAR(ADD_MONTHS(sysdate,-"+settle_mon+"),'YYYYMMDD') < nvl(b.rent_start_dt,to_char(sysdate,'YYYYMMDD')) \n"+

				"    union all \n"+

				"    select '6' sort, '단기요금' gubun1, decode(b.rent_st,'1','단기대여','9','보험대차','12','월렌트','2','정비대차') gubun2, \n"+
				"           '' rent_mng_id, b.rent_s_cd as rent_l_cd, b.car_mng_id, b.cust_id as client_id, b.bus_id as bus_id2, b.bus_id, \n"+
				"           a.est_dt, \n"+
				"           TRUNC((a.rent_s_amt+a.rent_v_amt)*0.8) as dly_amt, (a.rent_s_amt+a.rent_v_amt) dly_amt2, "+
				"		    decode(b.ret_dt,'','Y','N') use_yn, b.ret_dt as rent_start_dt \n"+
				"    from   scd_rent a, rent_cont b \n"+
				"    where  a.rent_s_cd=b.rent_s_cd and b.bus_id='"+bus_id2+"' and b.use_st<>'5' \n"+
				"           and a.rent_s_amt>0 and a.pay_dt is null and nvl(a.bill_yn,'Y')='Y' \n"+
				"           and a.est_dt < to_char(sysdate,'YYYYMMDD') \n"+
				"           AND b.RENT_ST='12' AND a.rent_st IN ('3','4','5','8') "+		
				"	        AND TO_CHAR(ADD_MONTHS(sysdate,-"+settle_mon+"),'YYYYMMDD') < nvl(b.rent_start_dt,to_char(sysdate,'YYYYMMDD')) \n"+

				"	 union all		 \n"+

				"    select '9' sort, '연체이자' gubun1, '-' gubun2, \n"+
				"          c.rent_mng_id, c.rent_l_cd, c.car_mng_id, c.client_id, DECODE(c.car_st,'4',c.mng_id,c.bus_id2) bus_id2, CASE WHEN e.rent_l_cd IS NOT NULL AND e.rent_suc_dt > d.rent_dt THEN NVL(d.ext_agnt,c.bus_id) ELSE c.bus_id end bus_id, \n"+
				"          '' as est_dt, \n"+
				"          nvl(a.dly_fee,0)-nvl(b.pay_amt,0) dly_amt, 0 dly_amt2, c.use_yn, c.rent_start_dt \n"+
				"    from  (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, sum(dly_fee) dly_fee from scd_fee where rent_l_cd not like 'RM%' group by rent_mng_id, rent_l_cd) a, "+
				"	       (select rent_mng_id, rent_l_cd, sum(pay_amt) pay_amt from scd_dly where rent_l_cd not like 'RM%' group by rent_mng_id, rent_l_cd) b, "+
				"	       cont c, FEE d, CONT_ETC e, \n"+
                "          (SELECT * FROM CLS_CONT WHERE cls_dt>'20091231' AND cls_st IN ('4','5')) f \n"+
				"    where a.rent_mng_id=b.rent_mng_id(+) and a.rent_l_cd=b.rent_l_cd(+) "+ 
				"          and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and c.bus_id='"+bus_id2+"' \n"+
				"          and nvl(a.dly_fee,0)-nvl(b.pay_amt,0)<>0 AND c.rent_l_cd not like 'RM%' \n"+
				"	       AND TO_CHAR(ADD_MONTHS(sysdate,-"+settle_mon+"),'YYYYMMDD') < nvl(c.rent_start_dt,to_char(sysdate,'YYYYMMDD')) \n"+
                "          AND a.rent_mng_id=d.rent_mng_id AND a.rent_l_cd=d.rent_l_cd AND a.rent_st=d.rent_st \n"+
                "          AND c.rent_mng_id=e.rent_mng_id AND c.rent_l_cd=e.rent_l_cd \n"+
                "          AND c.rent_mng_id=f.rent_mng_id(+) AND c.rent_l_cd=f.rent_l_cd(+) and DECODE(f.cls_st,'4','Y','5','Y',c.use_yn)='Y' \n"+

				" ) a, car_reg b, client c, users d, "+
				"   	cms_mng e, cls_cont f, (select rent_mng_id, rent_l_cd, max(seq) seq from cms_mng group by rent_mng_id, rent_l_cd) h, cust g, \n"+
//                "       (select rent_mng_id, rent_l_cd, max(promise_dt) promise_dt from dly_mm where promise_dt is not null group by rent_mng_id, rent_l_cd) p \n"+ 
				 " (select a.rent_mng_id, a.rent_l_cd, a.promise_dt \n"+
				 "	from   DLY_MM a,  \n"+
				 "         (SELECT /*+ index(DLY_MM, DLY_MM_PK) */ rent_mng_id, rent_l_cd, max(reg_dt||reg_dt_time||seq) KEEP( DENSE_RANK FIRST ORDER BY rent_mng_id, rent_l_cd, reg_dt||reg_dt_time||seq DESC) AS seq \n"+
				 "          FROM   DLY_MM GROUP BY rent_mng_id, rent_l_cd ) b  \n"+
				 "  where  a.rent_mng_id = b.rent_mng_id \n"+
				 "         AND a.rent_l_cd = b.rent_l_cd  \n"+
				 "         AND a.reg_dt||a.reg_dt_time||a.seq = b.seq) p \n"+

				" where a.bus_id='"+bus_id2+"' and a.car_mng_id=b.car_mng_id(+) and a.client_id=c.client_id(+) and a.bus_id2=d.user_id and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+)\n"+
				"       and a.rent_mng_id=f.rent_mng_id(+) and a.rent_l_cd=f.rent_l_cd(+) "+
				"	    and e.rent_mng_id=h.rent_mng_id(+) and e.rent_l_cd=h.rent_l_cd(+) and e.seq=h.seq(+) and e.rent_l_cd=g.code(+) "+
				"       and a.rent_mng_id=p.rent_mng_id(+) and a.rent_l_cd=p.rent_l_cd(+) "+
				" order by a.sort, a.use_yn, a.client_id, a.car_mng_id, a.est_dt "+
				" ";

		 
		try {
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
			System.out.println("[SettleDatabase:getStatSettleSubList2Gun]\n"+e);
			System.out.println("[SettleDatabase:getStatSettleSubList2Gun]\n"+query);
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

	//채권관리캠페인 항목별 세부리스트 :: 20101105
	public Vector getStatSettleSubItemList(String gubun1)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select \n"+
				"        a.*, b.car_no, b.car_nm, c.firm_nm, d.user_nm, e.cms_bank, f.cls_dt, "+
				"        decode(g.cbit,'1','신규','2','승인','3','해지신청','4','해지완료','7','임의해지','8','신고에러') cbit, g.ldate \n"+
				" from \n"+
				" ( \n"+
				"	 select '1' sort, '선수금' gubun1, decode(a.ext_st,'0','보증금','1','선납금','2','개시대여료', '5', '승계수수료') gubun2, \n"+
				"          a.rent_mng_id, a.rent_l_cd, c.car_mng_id, c.client_id, decode(a.ext_st,'5',NVL(b.ext_agnt,c.bus_id2),decode(b.rent_st,'1',decode(e.rent_l_cd,'',DECODE(c.bus_st,'7',c.bus_id2,c.bus_id),c.bus_id2),c.bus_id2)) bus_id2, \n"+
				"          decode(a.ext_st, '5', nvl(d.rent_suc_dt,b.rent_start_dt), nvl(d.rent_suc_dt,b.rent_start_dt)) as est_dt, (a.ext_s_amt+a.ext_v_amt) dly_amt, c.use_yn, c.rent_start_dt \n"+
				"	 from   scd_ext a, fee b, cont c, cont_etc d, (select * from cls_cont where cls_st in ('4','5')) e \n"+
				"    where  a.ext_st in ('0', '1', '2', '5' ) \n"+
				"          and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st \n"+
				"          and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"+
				"          and a.rent_mng_id = d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+)"+
				"          and c.rent_mng_id=e.rent_mng_id(+) and c.reg_dt=e.reg_dt(+) "+
				"          and a.ext_s_amt>0 and a.ext_pay_dt is null and nvl(a.bill_yn,'Y')='Y' \n"+
//				"          and decode(a.ext_st,'5',a.ext_est_dt,decode(c.rent_st||b.rent_st||b.grt_suc_yn||a.ext_st,'3100', to_char(add_months(to_date(nvl(c.dlv_dt,to_char(sysdate,'YYYYMMDD')),'YYYYMMDD'),1),'YYYYMMDD'), nvl(d.rent_suc_dt,b.rent_start_dt))) < to_char(sysdate,'YYYYMMDD') \n"+
				"          and decode(a.ext_st,'5',nvl(d.rent_suc_dt,a.ext_est_dt), \n"+//승계수수료
                "                     decode(c.rent_st||b.rent_st||b.grt_suc_yn||a.ext_st,'3100', \n"+//--대차승계보증금
                "                            decode(a.gubun,'E',a.ext_est_dt, \n"+
                "                                   to_char(to_date(nvl(b.rent_start_dt,to_char(sysdate,'YYYYMMDD')),'YYYYMMDD')+15,'YYYYMMDD') \n"+
                "                            ), \n"+
//              "                            nvl(d.rent_suc_dt,b.rent_start_dt) \n"+
//              "                            case when d.rent_suc_dt is not null and d.rent_suc_dt > b.rent_start_dt then d.rent_suc_dt else b.rent_start_dt end \n"+
				"                            case when d.rent_suc_dt is not null and d.rent_suc_dt > b.rent_start_dt then d.rent_suc_dt \n"+
                "                                                             WHEN d.rent_suc_dt IS NULL AND a.ext_st='5' THEN a.ext_est_dt  \n"+ 
                "                                                             else b.rent_start_dt end \n"+
                "                     ) \n"+
                "              ) < to_char(sysdate,'YYYYMMDD') \n"+
				"	 union all		 \n"+
				"    select '2' sort, '대여료' gubun1, a.fee_tm||'회'||decode(a.tm_st1,'0','','(잔액)') gubun2, \n"+
				"          a.rent_mng_id, a.rent_l_cd, b.car_mng_id, b.client_id, b.bus_id2, \n"+
				"          a.r_fee_est_dt as est_dt, \n"+
				"          (a.fee_s_amt+a.fee_v_amt) dly_amt, b.use_yn, b.rent_start_dt \n"+
				"    from  scd_fee a, cont b \n"+
				"    where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				"          and a.fee_s_amt>0 and a.rc_dt is null and nvl(a.bill_yn,'Y')='Y' \n"+
				"          and a.r_fee_est_dt < to_char(sysdate,'YYYYMMDD')            \n"+

				"	 union all		 \n"+
                "    select '2_2' sort, '대여료' gubun1, '미청구분+잔가' gubun2,  \n"+
                "           rent_mng_id, rent_l_cd, car_mng_id, client_id, bus_id2, \n"+
                "           bas_end_dt as est_dt, (dly_amt+o_1) dly_amt, use_yn, rent_start_dt \n"+
                "           from \n"+
                "           ( select a.use_yn, a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.bus_id2, a.rent_start_dt, \n"+
                "                    case when b.rent_end_dt > d.fee_est_dt then b.rent_end_dt else d.fee_est_dt end bas_end_dt, \n"+
                "                    trunc((b.fee_s_amt+b.fee_v_amt)/30*to_number(sysdate-to_date(case when b.rent_end_dt > d.fee_est_dt then b.rent_end_dt else d.fee_est_dt end,'YYYYMMDD')),0) dly_amt, \n"+
                "                    decode(e.fee_opt_amt,0,nvl(e.o_1,0),e.fee_opt_amt) as o_1 \n"+
                "             from   cont a, fee b, \n"+
                "                    (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) c, \n"+
                "                    (select rent_mng_id, rent_l_cd, max(use_e_dt) fee_est_dt from scd_fee group by rent_mng_id, rent_l_cd) d, \n"+
                "                    (select * from estimate_sh where est_from='car_janga' and rent_dt=to_char(sysdate,'YYYYMMDD')) e, cls_etc f, \n"+
				"                    ( select * from car_call_in where in_st='3' and out_dt is null ) cc \n"+
                "             where  a.use_yn='Y' and a.car_st in ('1','3') \n"+
                "             and    a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
                "             and    b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st \n"+
                "             and    a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd \n"+
                "             and    b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd and b.rent_st=e.rent_st \n"+
                "             and    a.rent_mng_id=f.rent_mng_id(+) and a.rent_l_cd=f.rent_l_cd(+) and f.rent_l_cd is null \n"+  
				"             and    a.rent_mng_id=cc.rent_mng_id(+) and a.rent_l_cd=cc.rent_l_cd(+) and cc.rent_l_cd is null \n"+	
//                "             and    sysdate-to_date(case when b.rent_end_dt > d.fee_est_dt then b.rent_end_dt else d.fee_est_dt end,'YYYYMMDD')>0 \n"+
                "             and    b.rent_end_dt < to_char(sysdate,'YYYYMMDD') and d.fee_est_dt < to_char(sysdate,'YYYYMMDD') \n"+//--20140729 3일경과일부터 채권에 나오게
                "           )           \n"+		

				"    union all \n"+
				"    select '3' sort, '과태료' gubun1, substr(a.vio_dt,1,8)||' '||a.vio_cont||'-'||decode(a.fault_st,'1','고객과실','업무상과실') as gubun2, \n"+
				"           a.rent_mng_id, a.rent_l_cd, b.car_mng_id, \n"+
				"           decode(c.rent_s_cd,'',b.client_id,d.client_id) client_id, \n"+
				"           decode(a.rent_s_cd,'',decode(a.fault_st,'2',nvl(a.fault_nm,b.bus_id2),b.bus_id2), decode(c.rent_st,'1',c.bus_id,'9',c.bus_id, '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) bus_id2, \n"+
				"           nvl(a.rec_plan_dt,nvl(a.dem_dt,a.paid_end_dt)) as est_dt, \n"+
				"           a.paid_amt as dly_amt, decode(c.rent_s_cd,'',b.use_yn,d.use_yn) use_yn, b.rent_start_dt \n"+
				"    from   fine a, cont b, rent_cont c, cont d \n"+
				"    where  a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				"           and a.rent_s_cd=c.rent_s_cd(+)  AND NVL(c.use_st,'0')<>'5' \n"+
				"           and c.sub_l_cd=d.rent_l_cd(+) \n"+
				"           and a.paid_amt>0 and a.coll_dt is null and decode(a.fault_st,'2', 'Y', '3', 'N', nvl(a.bill_yn,'Y'))='Y' \n"+
				"           and a.paid_st in ('3','4') and nvl(a.no_paid_yn,'N')='N' \n"+
//				"           and nvl(c.cust_st,'0')<>'1' \n"+
//				"           and a.vio_cont not like '%통행료%'  \n"+
				"           and ( (a.vio_cont not like  '%통행료%'and a.vio_cont not like  '%주차요금%') or  ( a.vio_cont like  '%통행료%' and a.proxy_dt is not null ) or ( a.vio_cont like  '%주차요금%' and a.proxy_dt is not null )  )"+
				"           and nvl(a.rec_plan_dt,nvl(a.dem_dt,a.paid_end_dt)) < to_char(sysdate,'YYYYMMDD') \n"+
				"	 union all \n"+
				"    select '4' sort, '면책금' gubun1, a.serv_dt||' '||decode(e.accid_st,'1','피해자','2','가해자','3','쌍방','4','운행자차','5','사고자차') gubun2, \n"+
				"           a.rent_mng_id, a.rent_l_cd, a.car_mng_id, \n"+
				"           decode(e.rent_s_cd,'',b.client_id,d.client_id) client_id, \n"+
				"           decode(e.rent_s_cd,'',b.bus_id2, decode(c.rent_st,'1',c.bus_id,'9',c.bus_id, '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) bus_id2, \n"+
				"           nvl(se.ext_est_dt, a.cust_plan_dt) as est_dt, \n"+
				"           (se.ext_s_amt+se.ext_v_amt) as dly_amt, decode(e.rent_s_cd,'',b.use_yn,d.use_yn) use_yn, decode(e.rent_s_cd,'',b.rent_start_dt,d.rent_start_dt) rent_start_dt \n"+
				"    from   scd_ext se, service a, accident e, cont b, rent_cont c, cont d \n"+
				"    where  se.ext_st = '3' \n"+
				"           and se.rent_mng_id = a.rent_mng_id and se.rent_l_cd = a.rent_l_cd and se.ext_id = a.serv_id \n"+
				"           and a.car_mng_id=e.car_mng_id and a.accid_id=e.accid_id \n"+
				"           and se.rent_mng_id=b.rent_mng_id and se.rent_l_cd=b.rent_l_cd \n"+
				"           and e.rent_s_cd=c.rent_s_cd(+) \n"+
				"           and c.sub_l_cd=d.rent_l_cd(+) \n"+
				"           and se.ext_s_amt>0 and se.ext_pay_dt is null and nvl(se.bill_yn,'Y')='Y' \n"+
				"           and nvl(a.no_dft_yn,'N')='N' \n"+
				"           and nvl(se.ext_est_dt, a.cust_plan_dt) < to_char(sysdate,'YYYYMMDD') \n"+
				"	 union all \n"+
				"    select '5' sort, '위약금' gubun1, decode(b.cls_st,'1','계약만료','2','중도해지') gubun2, \n"+
				"           a.rent_mng_id, a.rent_l_cd, c.car_mng_id, c.client_id, c.bus_id2, \n"+
				"           b.cls_dt as est_dt, \n"+
				"           (a.ext_s_amt+a.ext_v_amt) as dly_amt, c.use_yn, c.rent_start_dt \n"+
				"    from   scd_ext a, cls_cont b, cont c \n"+
				"    where  a.ext_st = '4' \n"+
				"           and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				"           and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"+
				"           and DECODE(c.car_st,'4',case when b.fdft_amt2 < 0 then 0 else a.ext_s_amt+a.ext_v_amt end,(a.ext_s_amt+a.ext_v_amt)) >0 and a.ext_pay_dt is null and nvl(a.bill_yn,'Y')='Y' \n"+
				"           and nvl(b.cls_doc_yn,'Y')='Y' \n"+
				"           and b.cls_dt < to_char(sysdate,'YYYYMMDD') \n"+
				"    union all \n"+
				"    select '6' sort, '단기요금' gubun1, decode(b.rent_st,'1','단기대여','보험대차','12','월렌트') gubun2, \n"+
				"           '' rent_mng_id, b.rent_s_cd as rent_l_cd, b.car_mng_id, b.cust_id as client_id, b.bus_id as bus_id2, \n"+
				"           a.est_dt, \n"+
				"           (a.rent_s_amt+a.rent_v_amt) as dly_amt, decode(b.ret_dt,'','Y','N') use_yn, b.ret_dt as rent_start_dt \n"+
				"    from   scd_rent a, rent_cont b \n"+
				"    where  a.rent_s_cd=b.rent_s_cd \n"+
				"           and a.rent_s_amt>0 and a.pay_dt is null and nvl(a.bill_yn,'Y')='Y' \n"+
				"           and a.est_dt < to_char(sysdate,'YYYYMMDD') \n"+
				"	 union all		 \n"+
				"    select '9' sort, '연체이자' gubun1, '-' gubun2, \n"+
				"          a.rent_mng_id, a.rent_l_cd, c.car_mng_id, c.client_id, c.bus_id2, \n"+
				"          '' as est_dt, \n"+
				"          nvl(a.dly_fee,0)-nvl(b.pay_amt,0) dly_amt, c.use_yn, c.rent_start_dt \n"+
				"    from  (select rent_mng_id, rent_l_cd, sum(dly_fee) dly_fee from scd_fee where rent_l_cd not like 'RM%' group by rent_mng_id, rent_l_cd) a, (select rent_mng_id, rent_l_cd, sum(pay_amt) pay_amt from scd_dly where rent_l_cd not like 'RM%' group by rent_mng_id, rent_l_cd) b, cont c, (SELECT * FROM CLS_CONT WHERE cls_dt>'20091231' AND cls_st IN ('4','5')) d  \n"+
				"    where a.rent_mng_id=b.rent_mng_id(+) and a.rent_l_cd=b.rent_l_cd(+) and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"+
				"          and nvl(a.dly_fee,0)-nvl(b.pay_amt,0)<>0 AND c.rent_l_cd not like 'RM%' AND c.rent_mng_id=d.rent_mng_id(+) AND c.rent_l_cd=d.rent_l_cd(+) and DECODE(d.cls_st,'4','Y','5','Y',c.use_yn)='Y'  \n"+
				" ) a, car_reg b, client c, users d, "+
				"   	cms_mng e, cls_cont f, (select rent_mng_id, rent_l_cd, max(seq) seq from cms_mng group by rent_mng_id, rent_l_cd) h, cust g \n"+
				" where a.gubun1='"+gubun1+"' and a.car_mng_id=b.car_mng_id and a.client_id=c.client_id and a.bus_id2=d.user_id and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+)\n"+
				"       and a.rent_mng_id=f.rent_mng_id(+) and a.rent_l_cd=f.rent_l_cd(+) "+
				"	    and e.rent_mng_id=h.rent_mng_id(+) and e.rent_l_cd=h.rent_l_cd(+) and e.seq=h.seq(+) and e.rent_l_cd=g.code(+) "+
				" order by a.sort, a.bus_id2, a.use_yn, a.client_id, a.car_mng_id, a.est_dt "+
				" ";

		try {
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
			System.out.println("[SettleDatabase:getStatSettleSubItemList]\n"+e);
			System.out.println("[SettleDatabase:getStatSettleSubItemList]\n"+query);
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

	// 미수금정산 리스트 조회--연체이자 포함 - 과태료 선납분 포함
	public Vector getSettleList_20091001(String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", sub_query = "";

		String settle_dt = " < to_char(sysdate,'YYYYMMDD')";
		//임의일자
		if(gubun2.equals("6"))	settle_dt = " < to_char(to_date('"+AddUtil.ChangeString(st_dt)+"', 'YYYYMMDD'), 'YYYYMMDD')";

		sub_query = " select \n"+
				 " decode(a.rent_s_cd,'','장기','단기') gubun1, \n"+
				 " a.gubun2, \n"+
				 " decode(d.rent_st,'1','단기대여','9','보험대차','2','정비대차','3','사고대차','4','업무대여','5','업무대여','12','월렌트') gubun3, \n"+
				 " decode(d.sub_l_cd,'',b.rent_l_cd,d.sub_l_cd) rent_l_cd,  \n"+
				 " decode(d.sub_l_cd,'',b.rent_mng_id,g.rent_mng_id) rent_mng_id, \n"+
				 " nvl(c.car_mng_id,i.car_mng_id) car_mng_id, \n"+
				 " decode(a.rent_s_cd,'',e.client_id,decode(d.cust_st,'1',f.client_id,h.user_id)) client_id, \n"+
				 " decode(b.car_st,'4',b.mng_id,decode(a.bus_id2,'',decode(a.rent_s_cd,'',decode(a.fault_nm,'',b.bus_id2,nvl(a.fault_nm,b.bus_id2)),decode(d.rent_st,'1',d.bus_id,'9',d.bus_id,'12',decode(a.gubun2,'단기요금2',d.mng_id,'면책금',d.mng_id,'과태료',d.mng_id,d.bus_id), '2',nvl(g.bus_id2,d.bus_id),'3',nvl(g.bus_id2,d.bus_id),'10',nvl(g.bus_id2,d.bus_id),'4',d.cust_id,'5',d.cust_id)),a.bus_id2)) bus_id2, \n"+
				 " decode(a.rent_s_cd,'',e.firm_nm,decode(d.cust_st,'1',f.firm_nm,h.user_nm)) firm_nm, \n"+
				 " nvl(c.car_no,i.car_no) car_no, nvl(c.car_nm,i.car_nm) car_nm, \n"+
				 " d.rent_s_cd, \n"+
				 " a.est_amt, a.est_amt2, a.est_amt3, \n"+
				 " decode(a.rent_s_cd,'',b.use_yn,decode(d.use_st,'1','Y','2','Y','3','N','4','N','5','N','',nvl(g.use_yn,'Y'))) use_yn, nvl(j.in_cnt,0) in_cnt,  \n"+
//				 " decode(d.rent_st,'12','2',nvl(trunc(months_between(sysdate, to_date(nvl(k.cls_dt,''),'YYYYMMDD')+1)),0)) cls_use_mon,  \n"+
       		     " nvl(trunc(months_between(sysdate, to_date(nvl(decode(d.rent_s_cd,'',decode(b.car_st,'2',b.rent_end_dt,k.cls_dt),substr(d.ret_dt,1,8)),''),'YYYYMMDD')+1)),0) cls_use_mon,  \n"+
				 " nvl(o.rent_l_cd,'') as bad_debt_req, "+
				 " nvl(a.dly_mon,0) dly_mon, "+
                 " nvl(p.promise_dt,'') promise_dt, "+
                 " b.mng_id2, b.car_st "+   
				 " from \n"+
				 " (  \n"+
				 "      select '선수금' gubun2, '' rent_s_cd, a.rent_l_cd, 0 dly_mon, '' fault_st, '' fault_nm, DECODE(c.car_st,'4',c.mng_id,decode(a.ext_st,'5',NVL(b.ext_agnt,c.bus_id2),decode(b.rent_st,'1',decode(e.rent_l_cd,'',DECODE(c.bus_st,'7',c.bus_id2,c.bus_id),c.bus_id),c.bus_id2))) bus_id2, "+est_amt1+" est_amt, 0 est_amt2, 0 est_amt3 from scd_ext a, fee b, cont c, cont_etc d, (select * from cls_cont where cls_st in ('4','5')) e where a.ext_st in ('0', '1', '2' , '5') and nvl(a.bill_yn,'Y')='Y' and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+) and c.rent_mng_id=e.rent_mng_id(+) and c.reg_dt=e.reg_dt(+) and "+est_dt1_1+" "+settle_dt+" "+condition1+" \n"+
				 "      union all \n"+
				 "      select '승계수수료' gubun2, '' rent_s_cd, a.rent_l_cd, 0 dly_mon, '' fault_st, '' fault_nm, DECODE(c.car_st,'4',c.mng_id,decode(a.ext_st,'5',NVL(b.ext_agnt,c.bus_id2),decode(b.rent_st,'1',decode(e.rent_l_cd,'',DECODE(c.bus_st,'7',c.bus_id2,c.bus_id),c.bus_id),c.bus_id2))) bus_id2, "+est_amt1_1+" est_amt, 0 est_amt2, 0 est_amt3 from scd_ext a, fee b, cont c, cont_etc d, (select * from cls_cont where cls_st in ('4','5')) e where a.ext_st in ('5' ) and nvl(a.bill_yn,'Y')='Y' and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+) and c.rent_mng_id=e.rent_mng_id(+) and c.reg_dt=e.reg_dt(+) and "+est_dt1_1+" "+settle_dt+" "+condition1+" \n"+
				 "      union all \n"+
				 "      select '대여료' gubun2, '' rent_s_cd, a.rent_l_cd, trunc(MONTHS_BETWEEN(SYSDATE,TO_DATE(nvl(a.use_s_dt,a.r_fee_est_dt),'YYYYMMDD'))) dly_mon, '' fault_st, '' fault_nm, '' bus_id2, "+est_amt2+" est_amt, decode(b.car_st,'4',"+est_amt2+",0) est_amt2, 0 est_amt3 from scd_fee a, cont b where "+est_dt2+" "+settle_dt+" "+condition2+" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				 "      union all \n"+ 
				 "      select '대여료' gubun2, '' rent_s_cd, rent_l_cd, 0 dly_mon, '' fault_st, '' fault_nm, '' bus_id2, \n"+
                 "              (dly_amt+o_1) est_amt, 0 est_amt2, (dly_amt-dly_amt2+o_1-o_12) est_amt3 \n"+
                 "              from \n"+
                 "              ( select a.use_yn, a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.bus_id2, \n"+
                 "                       case when b.rent_end_dt > d.fee_est_dt then b.rent_end_dt else d.fee_est_dt end bas_end_dt, \n"+
                 "                       trunc((b.fee_s_amt+b.fee_v_amt)/30*to_number(sysdate-to_date(case when b.rent_end_dt > d.fee_est_dt then b.rent_end_dt else d.fee_est_dt end,'YYYYMMDD')),0) dly_amt, \n"+
                 "                       decode(e.fee_opt_amt,0,nvl(e.o_1,0),e.fee_opt_amt) as o_1, \n"+
                 "                       CASE WHEN sysdate-to_date(case when b.rent_end_dt > d.fee_est_dt then b.rent_end_dt else d.fee_est_dt end,'YYYYMMDD')-2>0  \n"+
                 "                                   THEN trunc((b.fee_s_amt+b.fee_v_amt)/30*to_number(sysdate-to_date(case when b.rent_end_dt > d.fee_est_dt then b.rent_end_dt else d.fee_est_dt end,'YYYYMMDD')),0) \n"+
                 "                              ELSE 0 END dly_amt2,      \n"+
                 "                         CASE WHEN sysdate-to_date(case when b.rent_end_dt > d.fee_est_dt then b.rent_end_dt else d.fee_est_dt end,'YYYYMMDD')-2>0  \n"+
                 "                                   THEN decode(e.fee_opt_amt,0,nvl(e.o_1,0),e.fee_opt_amt) \n"+
                 "                              ELSE 0 END o_12      \n"+
                 "                from   cont a, fee b, \n"+
                 "                       (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) c, \n"+
                 "                       (select rent_mng_id, rent_l_cd, max(use_e_dt) fee_est_dt from scd_fee group by rent_mng_id, rent_l_cd) d, \n"+
                 "                       (select * from estimate_sh where est_from='car_janga' and rent_dt=to_char(sysdate,'YYYYMMDD')) e, cls_etc f, \n"+
				 "                       ( select * from car_call_in where in_st='3' and out_dt is null ) cc \n "+
                 "                where  a.use_yn='Y' and a.car_st in ('1','3') and b.rent_start_dt is not null \n"+
                 "                and    a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
                 "                and    b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st \n"+
                 "                and    a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd \n"+
                 "                and    b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd and b.rent_st=e.rent_st \n"+
                 "                and    a.rent_mng_id=f.rent_mng_id(+) and a.rent_l_cd=f.rent_l_cd(+) and f.rent_l_cd is null \n"+
				 "                and    a.rent_mng_id=cc.rent_mng_id(+) and a.rent_l_cd=cc.rent_l_cd(+) and cc.rent_l_cd is null \n"+
//               "                and    sysdate-to_date(case when b.rent_end_dt > d.fee_est_dt then b.rent_end_dt else d.fee_est_dt end,'YYYYMMDD')>0 \n"+
                 "                and    b.rent_end_dt < to_char(sysdate,'YYYYMMDD') and d.fee_est_dt < to_char(sysdate,'YYYYMMDD') \n"+//--20140729 3일경과일부터 채권에 나오게
                 "              ) \n"+
				 "      union all \n"+ 

				 "      select '과태료'		gubun2, a.rent_s_cd, a.rent_l_cd, 0 dly_mon, a.fault_st, a.fault_nm, "+
				 " 	           decode(b.car_st,'4',b.mng_id,decode(a.rent_s_cd,'',decode(a.fault_st,'2',nvl(a.fault_nm,b.bus_id2),b.bus_id2), decode(c.rent_st,'1',c.bus_id,'9',c.bus_id,'12',nvl(c.mng_id,c.bus_id), '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id,c.bus_id))) as  bus_id2, "+
				 "	           "+est_amt3+" est_amt, 0 est_amt2, 0 est_amt3 "+
				 "	    from   fine a, cont b, rent_cont c, cont d "+
				 "	    where  "+est_dt3+" "+settle_dt+" "+condition3_4+"\n"+
				 "             and a.rent_l_cd=b.rent_l_cd and a.rent_s_cd=c.rent_s_cd(+) and c.sub_l_cd=d.rent_l_cd(+) and nvl(c.use_st,'0')<>'5' "+

				 "      union all \n"+
				 "      select '면책금'		gubun2, b.rent_s_cd, a.rent_l_cd, 0 dly_mon, '' fault_st, '' fault_nm, '' bus_id2, "+est_amt4+" est_amt, 0 est_amt2, 0 est_amt3 from scd_ext se , service a, accident b where se.ext_st = '3' and se.rent_mng_id = a.rent_mng_id and se.rent_l_cd = a.rent_l_cd and se.ext_id = a.serv_id and  a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and "+est_dt4+" "+settle_dt+" "+condition4+"\n"+
				 "      union all \n"+  
				 "      select '휴/대차료'	gubun2, '' rent_s_cd, b.rent_l_cd, 0 dly_mon, '' fault_st, '' fault_nm,  decode(c.car_st,'4',c.mng_id,nvl(a.bus_id2,c.bus_id2))  bus_id2, "+est_amt5_1+" est_amt, 0 est_amt2, 0 est_amt3 from scd_ext se, cont c, my_accid a, accident b where  se.rent_mng_id = c.rent_mng_id and se.rent_l_cd = c.rent_l_cd and se.ext_st = '6' and se.ext_tm='1' and se.rent_mng_id = b.rent_mng_id and se.rent_l_cd = b.rent_l_cd and substr(se.ext_id,1,6) = a.accid_id  and substr(se.ext_id,7) = to_char(a.seq_no) and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and nvl(a.req_st, '0' ) not in ( '0',  '2', '3' )  and a.req_dt >= '20100101'   and  (se.ext_s_amt+se.ext_v_amt)  >= 30000  and "+est_dt5+" "+settle_dt+" "+condition5_1+"\n"+
				 "      union all \n"+
				 "      select '위약금'		gubun2, '' rent_s_cd, a.rent_l_cd, 0 dly_mon, '' fault_st, '' fault_nm, '' bus_id2, "+est_amt6+" est_amt, decode(c.car_st,'4',"+est_amt6+",0) est_amt2, 0 est_amt3 from scd_ext a, cls_cont b, cont c where a.ext_st = '4' and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and "+est_dt6+" "+settle_dt+" "+condition6+"\n"+
				 "		union all \n"+
				 "		select '단기요금'	gubun2, a.rent_s_cd, '' rent_l_cd, 0 dly_mon, '' fault_st, '' fault_nm, '' bus_id2, "+est_amt7_1+" est_amt, (a.rent_s_amt+a.rent_v_amt) est_amt2, 0 est_amt3 from scd_rent a, rent_cont b where b.mng_id<>'000126' and a.rent_s_cd=b.rent_s_cd and "+est_dt7+" "+settle_dt+" "+condition7+"\n"+
				 "      union all \n"+
					    //월렌트 관리담당자 부담분
				 "		select '단기요금2'	gubun2, a.rent_s_cd, '' rent_l_cd, 0 dly_mon, '' fault_st, '' fault_nm, '' bus_id2, "+est_amt7_2+" est_amt, (a.rent_s_amt+a.rent_v_amt) est_amt2, 0 est_amt3 from scd_rent a, rent_cont b where a.rent_s_cd=b.rent_s_cd and "+est_dt7+" "+settle_dt+" "+condition7_2+"\n"+
				 "      union all \n"+
				 "      select '연체이자'	gubun2, '' rent_s_cd, c.rent_l_cd, 0 dly_mon, '' fault_st, '' fault_nm, '' bus_id2, (nvl(a.dly_fee,0)-nvl(b.pay_amt,0)) est_amt, 0 est_amt2, 0 est_amt3 from (select rent_mng_id, rent_l_cd, count(0) dly_cnt, sum(dly_fee) dly_fee from scd_fee where rent_l_cd not like 'RM%' group by rent_mng_id, rent_l_cd) a, (select rent_mng_id, rent_l_cd, sum(pay_amt) pay_amt from scd_dly where rent_l_cd not like 'RM%' group by rent_mng_id, rent_l_cd) b, cont c, (SELECT * FROM CLS_CONT WHERE cls_dt>'20091231' AND cls_st IN ('4','5')) d where a.rent_mng_id=b.rent_mng_id(+) and a.rent_l_cd=b.rent_l_cd(+) and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and nvl(a.dly_fee,0)-nvl(b.pay_amt,0)>0 and c.rent_mng_id=d.rent_mng_id(+) and c.rent_l_cd=d.rent_l_cd(+) and decode(d.cls_st,'4','Y','5','Y',c.use_yn)='Y' AND c.rent_l_cd not like 'RM%'\n"+
				 "      union all \n"+
				// "      select '보증보험'	gubun2, '' rent_s_cd, a.rent_l_cd, 0 dly_mon, '' fault_st, '' fault_nm, '' bus_id2, decode(b.fee_rent_st , '1', gi_amt, 0) est_amt, 0 est_amt2, 0 est_amt3 from (select a.* from gua_ins a, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, max(gi_dt) gi_dt from gua_ins group by rent_mng_id, rent_l_cd) b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st and a.gi_dt=b.gi_dt) a, cont_n_view b where a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd  and a.gi_amt > 0 and b.use_yn='N' \n"+
				 "      select '보증보험'	gubun2, '' rent_s_cd, a.rent_l_cd, 0 dly_mon, '' fault_st, '' fault_nm, '' bus_id2,  gi_amt est_amt, 0 est_amt2, 0 est_amt3 from (select a.* from gua_ins a, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, max(gi_dt) gi_dt from gua_ins group by rent_mng_id, rent_l_cd) b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st and a.gi_dt=b.gi_dt) a, cont_n_view b where a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd  and a.gi_amt > 0 and b.use_yn='N' \n"+ 
				" ) a,  \n"+
				 " cont b, car_reg c, rent_cont d, client e, client f, cont g, users h, car_reg i, cls_cont k, \n"+
			     " (select a.rent_mng_id, a.rent_l_cd, count(0) in_cnt from car_call_in a, cont b where a.out_dt is null and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(b.use_yn,'Y')='Y' and b.car_st<>'4' group by a.rent_mng_id, a.rent_l_cd) j, \n"+
                 " (select rent_l_cd from bad_debt_req where nvl(bad_debt_st,'0')<>'3' group by rent_l_cd) o, "+
//				 " (select a.rent_mng_id, a.rent_l_cd, a.promise_dt from DLY_MM a, (SELECT rent_mng_id, rent_l_cd, max(reg_dt||reg_dt_time||seq) seq FROM DLY_MM GROUP BY rent_mng_id, rent_l_cd) b where a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd AND a.reg_dt||a.reg_dt_time||a.seq=b.seq) p "+
				 " (select a.rent_mng_id, a.rent_l_cd, a.promise_dt \n"+
				 "	from   DLY_MM a,  \n"+
				 "         (SELECT /*+ index(DLY_MM, DLY_MM_PK) */ rent_mng_id, rent_l_cd, max(reg_dt||reg_dt_time||seq) KEEP( DENSE_RANK FIRST ORDER BY rent_mng_id, rent_l_cd, reg_dt||reg_dt_time||seq DESC) AS seq \n"+
				 "          FROM   DLY_MM GROUP BY rent_mng_id, rent_l_cd ) b  \n"+
				 "  where  a.rent_mng_id = b.rent_mng_id \n"+
				 "         AND a.rent_l_cd = b.rent_l_cd  \n"+
				 "         AND a.reg_dt||a.reg_dt_time||a.seq = b.seq) p \n"+
				 " where \n"+
				 " a.rent_l_cd=b.rent_l_cd(+) \n"+
				 " and b.car_mng_id=c.car_mng_id(+) \n"+
				 " and a.rent_s_cd=d.rent_s_cd(+) \n"+
				 " and b.client_id=e.client_id(+) \n"+
				 " and d.cust_id=f.client_id(+) \n"+
				 " and d.sub_l_cd=g.rent_l_cd(+) \n"+
				 " and d.cust_id=h.user_id(+) and d.car_mng_id=i.car_mng_id(+) \n"+
				 " and b.rent_mng_id=j.rent_mng_id(+) and b.rent_l_cd=j.rent_l_cd(+) \n"+
				 " and b.rent_mng_id=k.rent_mng_id(+) and b.rent_l_cd=k.rent_l_cd(+) \n"+
				 " and b.rent_l_cd=o.rent_l_cd(+) \n"+
				 " and b.rent_mng_id=p.rent_mng_id(+) and b.rent_l_cd=p.rent_l_cd(+) \n"+
				 " ";

				if(s_kd.equals("8") && t_wd.equals("9999")){
					sub_query += " and decode(b.car_st,'4',b.mng_id,decode(a.bus_id2,'',decode(a.rent_s_cd,'',decode(a.fault_nm,'',b.bus_id2,nvl(a.fault_nm,b.bus_id2)),decode(d.rent_st,'1',d.bus_id,'9',d.bus_id,'12',decode(a.gubun2,'단기요금2',d.mng_id,'면책금',d.mng_id,'과태료',d.mng_id,d.bus_id), '2',nvl(g.bus_id2,d.bus_id),'3',nvl(g.bus_id2,d.bus_id),'10',nvl(g.bus_id2,d.bus_id),'4',d.cust_id,'5',d.cust_id)),a.bus_id2)) in ( select user_id from users where use_yn='N' and dept_id='9999' )";
				}else{
					if(!t_wd.equals("")){	
						if(s_kd.equals("1"))		sub_query += " and decode(a.rent_s_cd,'',e.firm_nm,decode(d.cust_st,'1',f.firm_nm,h.user_nm)) like '%"+t_wd+"%'";
						else if(s_kd.equals("4"))	sub_query += " and nvl(c.car_no,i.car_no) like '%"+t_wd+"%'";
						else if(s_kd.equals("8"))	sub_query += " and decode(b.car_st,'4',b.mng_id,decode(a.bus_id2,'',decode(a.rent_s_cd,'',decode(a.fault_nm,'',b.bus_id2,nvl(a.fault_nm,b.bus_id2)),decode(d.rent_st,'1',d.bus_id,'9',d.bus_id,'12',decode(a.gubun2,'단기요금2',d.mng_id,'면책금',d.mng_id,'과태료',d.mng_id,d.bus_id), '2',nvl(g.bus_id2,d.bus_id),'3',nvl(g.bus_id2,d.bus_id),'10',nvl(g.bus_id2,d.bus_id),'4',d.cust_id,'5',d.cust_id)),a.bus_id2)) = '"+t_wd+"'";
						else if(s_kd.equals("9"))	sub_query += " and decode(d.sub_l_cd,'',b.rent_l_cd,d.sub_l_cd) = '"+t_wd+"'";
						else if(s_kd.equals("12"))	sub_query += " and b.mng_id2 = '"+t_wd+"'";
					}
				}



		query = " select \n"+
				" use_yn, client_id, firm_nm, car_mng_id, car_no, bus_id2, nvl(rent_l_cd,min(rent_s_cd)) rent_l_cd, rent_mng_id, in_cnt, cls_use_mon,  \n"+
				" min(gubun3) gubun3, "+
				" min(rent_s_cd) rent_s_cd, \n"+
				" min(bad_debt_req) bad_debt_req, \n"+
				" max(dly_mon) dly_mon, \n"+
				" max(promise_dt) promise_dt, \n"+
				" max(mng_id2) mng_id2, \n"+
				" sum  (decode(gubun2,'보증보험',	0, '단기요금',est_amt2, '단기요금2',est_amt2, est_amt)) est_amt0, \n"+ //합계
				" sum  (decode(gubun2,'선수금',		est_amt)) est_amt1, \n"+				
				" sum  (decode(gubun2,'대여료',		est_amt)) est_amt2, \n"+
				" sum  (decode(gubun2,'대여료',	    est_amt2)) est_amt2_2, \n"+ //월렌트요금
				" sum  (decode(gubun2,'대여료',	    est_amt3)) est_amt2_3, \n"+ //미청구실적용분
				" sum  (decode(gubun2,'연체이자',	est_amt)) est_amt3, \n"+
				" sum  (decode(gubun2,'과태료',		est_amt)) est_amt4, \n"+
				" sum  (decode(gubun2,'면책금',		est_amt)) est_amt5, \n"+
				" sum  (decode(gubun2,'휴/대차료',	est_amt)) est_amt6, \n"+
				" sum  (decode(gubun2,'위약금',		est_amt)) est_amt7, \n"+
				" sum  (decode(gubun2,'위약금',	    est_amt2)) est_amt7_2, \n"+ //월렌트요금
				" sum  (decode(gubun2,'단기요금',	est_amt2, '단기요금2',	est_amt2)) est_amt8, \n"+
				" sum  (decode(gubun2,'단기요금',	est_amt, '단기요금2',	est_amt)) est_amt8_2, \n"+
				" sum  (decode(gubun2,'보증보험',	est_amt)) est_amt9, \n"+
				" sum  (decode(gubun2,'승계수수료',		est_amt)) est_amt10, \n"+
				" count(decode(gubun2,'보증보험',	'', firm_nm)) est_su0, \n"+
				" count(decode(gubun2,'선수금',		firm_nm)) est_su1, \n"+				
				" count(decode(gubun2,'대여료',		firm_nm)) est_su2, \n"+
				" count(decode(gubun2,'연체이자',	firm_nm)) est_su3, \n"+
				" count(decode(gubun2,'과태료',		firm_nm)) est_su4, \n"+
				" count(decode(gubun2,'면책금',		firm_nm)) est_su5, \n"+
				" count(decode(gubun2,'휴/대차료',	firm_nm)) est_su6, \n"+
				" count(decode(gubun2,'위약금',		firm_nm)) est_su7, \n"+
				" count(decode(gubun2,'단기요금',	firm_nm, '단기요금2',	firm_nm)) est_su8, \n"+
				" count(decode(gubun2,'보증보험',	firm_nm)) est_su9, \n"+
				" count(decode(gubun2,'승계수수료',		firm_nm)) est_su10, \n"+		
				" car_st \n"+
				" from \n"+
				"	 ("+sub_query+") \n"+
//				" where decode(gubun2,'보증보험',	0, est_amt)<>0 \n";
				" where est_amt <>0 \n";

		if(gubun3.equals("5"))		query += " and gubun2<>'연체이자'";
		if(gubun3.equals("6"))		query += " and use_yn='N'";
		if(gubun3.equals("7"))		query += " and gubun2<>'연체이자'";
		if(gubun3.equals("8"))		query += " and use_yn='N' and cls_use_mon >1";

		if(gubun4.equals("1"))		query += " and gubun2='대여료'";
		else if(gubun4.equals("2"))	query += " and gubun2='선수금'";
		else if(gubun4.equals("3"))	query += " and gubun2='과태료'";
		else if(gubun4.equals("4"))	query += " and gubun2='면책금'";
		else if(gubun4.equals("5"))	query += " and gubun2='휴/대차료'";
		else if(gubun4.equals("6"))	query += " and gubun2='위약금'";
		else if(gubun4.equals("7"))	query += " and gubun2 in ('단기요금','단기요금2')";
		else if(gubun4.equals("8"))	query += " and gubun2='연체이자'";
		

//		if(s_kd.equals("8") && t_wd.equals("9999")){
//			query += " and bus_id2 in ( select user_id from users where use_yn='N' and dept_id='9999' )";
//		}else{
//			if(!t_wd.equals("")){	
//				if(s_kd.equals("1"))		query += " and firm_nm like '%"+t_wd+"%'";
//				else if(s_kd.equals("4"))	query += " and car_no like '%"+t_wd+"%'";
//				else if(s_kd.equals("8"))	query += " and bus_id2 = '"+t_wd+"'";
//				else if(s_kd.equals("9"))	query += " and rent_l_cd = '"+t_wd+"'";
//			}
//		}

		query += " \n group by use_yn, client_id, firm_nm, car_mng_id, car_no, bus_id2, rent_l_cd, rent_mng_id, in_cnt, cls_use_mon, car_st";

		query += " \n having sum(decode(gubun2,'보증보험',0,est_amt))<>0";

		if(gubun3.equals("8"))		query += " and sum  (decode(gubun2,'보증보험',	0, '단기요금',est_amt2, '단기요금2',est_amt2, est_amt)) > 0 ";

		if(gubun3.equals("7")){
			query += " and max(dly_mon) >2 ";
			query += " \n order by use_yn desc, bus_id2, firm_nm";
		}else{
			query += " \n order by use_yn desc, in_cnt, firm_nm";
		}


	//	System.out.println("settle = " + query);

	
		try {
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
			System.out.println("[SettleDatabase:getSettleList_20091001]\n"+e);
			System.out.println("[SettleDatabase:getSettleList_20091001]\n"+query);
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

	//채권관리캠페인 담당자별 세부리스트 :: 20090408
	public Vector getStatSettleSubHCList(String bus_id2, String var1_3, String var1_6)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		//청구   20120126 2012년1분기부터 청구일+5일 청구금액에서 청구일+3개월 청구금액 1군10%/2군5%로 변경, 마감당일 제외없음
		//입금   20120126 2012년1분기부터 입금경감은 없음
		//미입금 20120126 2012년1분기부터 청구일 2개월경과 1달동안 경감에서 3개월경과 3달동안 청구금액 1군10%/2군5%로 변경, 마감당일 제외없음
		//입금   20140225 2014년1분기부터 입금일기준 +1개월까지 입금금액 1군50%/2군25% 경감으로 변경
		query = " select \n"+
				"        a.*, b.car_no, b.car_nm, c.firm_nm, d.user_nm, e.cms_bank \n"+
				" from \n"+
				" ( \n"+
				"	 select '7' sort, decode(a.req_gu,'1','휴차료','2','대차료') gubun1, '입금분' gubun2, \n"+
				"           b.rent_mng_id, b.rent_l_cd, b.car_mng_id, c.client_id, nvl(a.bus_id2,c.bus_id2) bus_id2, \n"+
			//	"           nvl(d.ext_est_dt,a.req_dt) as est_dt, \n"+
				"           d.ext_pay_dt  as est_dt, \n"+
//				"           -(d.ext_s_amt+d.ext_v_amt) dly_amt \n"+
			//	"           -round((d.ext_s_amt+d.ext_v_amt)*decode(u.loan_st, '1', 0.1, 0.05)) dly_amt \n"+
				"           -round(d.ext_pay_amt*decode(u.loan_st, '1', 0.5, 0.25)) dly_amt \n"+
				"	 from   my_accid a, accident b, cont c, users u, "+
				"           (select * from scd_ext where ext_st='6' and ext_pay_dt is not null  ) d \n"+
				"    where \n"+
//	            "           to_char(sysdate,'YYYYMMdd') <>  '"+var1_3+"' "+
				"           a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd "+	                           
				"           and b.rent_mng_id=d.rent_mng_id and b.rent_l_cd=d.rent_l_cd and a.accid_id||to_char(a.seq_no)=d.ext_id "+
//				"           and to_char(sysdate,'YYYYMMdd')  between nvl(d.ext_est_dt,a.req_dt) and to_char(to_date(nvl(d.ext_est_dt,a.req_dt)) + 5 , 'yyyymmdd')  \n"+
		//		"   		and to_char(sysdate,'YYYYMMdd')  between nvl(d.ext_est_dt,a.req_dt) and to_char(add_months(to_date(nvl(d.ext_est_dt,a.req_dt)), 1), 'yyyymmdd') \n"+
				"   		and to_char(sysdate,'YYYYMMdd')  between  d.ext_pay_dt and   to_char(add_months(to_date(d.ext_pay_dt), 1) , 'yyyymmdd')  \n"+
				"           and nvl(a.bus_id2,c.bus_id2)=u.user_id \n"+
/*
				"	 union all		 \n"+

				"	 select '8' sort, decode(a.req_gu,'1','휴차료','2','대차료') gubun1, '입금분' gubun2, \n"+
				"           b.rent_mng_id, b.rent_l_cd, b.car_mng_id, c.client_id, nvl(a.bus_id2,c.bus_id2) bus_id2, \n"+
				"           d.ext_pay_dt as est_dt, -d.ext_pay_amt dly_amt \n"+
				"	 from   my_accid a, accident b, cont c, (select * from scd_ext where ext_st='6' and ext_pay_dt is not null) d \n"+
				"    where \n"+
//	            "           to_char(sysdate,'YYYYMMdd') <>  '"+var1_3+"' and 
				"           a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd "+	
				"           and b.rent_mng_id=d.rent_mng_id and b.rent_l_cd=d.rent_l_cd and a.accid_id||to_char(a.seq_no)=d.ext_id "+
				"           and to_char(sysdate,'YYYYMMdd')  between d.ext_pay_dt  and to_char(to_date(d.ext_pay_dt) + 10 , 'yyyymmdd')  \n"+

				"	 union all		 \n"+

				"	 select '9' sort, decode(a.req_gu,'1','휴차료','2','대차료') gubun1, '청구미입금분' gubun2, \n"+
				"           b.rent_mng_id, b.rent_l_cd, b.car_mng_id, c.client_id, nvl(a.bus_id2,c.bus_id2) bus_id2, \n"+
				"           nvl(d.ext_est_dt,a.req_dt) as est_dt, \n"+
				"	        round((d.ext_s_amt+d.ext_v_amt)*decode(u.loan_st, '1', 0.1, 0.05)) dly_amt \n"+
				"	 from   my_accid a, accident b, cont c, users u, (select * from scd_ext where ext_st='6' and ext_tm='1' and ext_pay_dt is null and (ext_s_amt+ext_v_amt)>0 ) d \n"+
				"    where   \n"+
	            "           a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd "+	
				"           and b.rent_mng_id=d.rent_mng_id and b.rent_l_cd=d.rent_l_cd and a.accid_id||to_char(a.seq_no)=d.ext_id "+
//				"           and to_char(sysdate,'YYYYMMdd')  between to_char(add_months(to_date(nvl(d.ext_est_dt,a.req_dt)), 2) , 'yyyymmdd') and to_char(add_months(to_date(nvl(d.ext_est_dt,a.req_dt)), 3), 'yyyymmdd') "+
				"   		and to_char(sysdate,'YYYYMMdd')  between to_char(add_months(to_date(nvl(d.ext_est_dt,a.req_dt)), 1) , 'yyyymmdd') and to_char(add_months(to_date(nvl(d.ext_est_dt,a.req_dt)), 2), 'yyyymmdd') \n"+
				"           and nvl(a.bus_id2,c.bus_id2)=u.user_id \n"+
*/
/*
				"	 union all		 \n"+

				"	 select '10' sort, '경락손해' gubun1, '입금분' gubun2, \n"+
				"           b.rent_mng_id, b.rent_l_cd, b.car_mng_id, c.client_id, nvl(a.amor_req_id,c.bus_id2) bus_id2, \n"+
				"           a.amor_pay_dt as est_dt, -a.amor_pay_amt dly_amt \n"+
				"	 from   ot_accid a, accident b, cont c \n"+
				"    where \n"+
				"           a.amor_type='1' AND a.amor_pay_amt>0 AND a.amor_pay_dt IS NOT NULL AND b.SETTLE_ST ='1' \n"+
				"	        and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd "+	
				"           and to_char(sysdate,'YYYYMMdd')  between a.amor_pay_dt  and to_char(to_date(a.amor_pay_dt) + 10 , 'yyyymmdd')  \n"+
*/

				" ) a, car_reg b, client c, users d, cms_mng e \n"+
				" where a.bus_id2='"+bus_id2+"' and a.car_mng_id=b.car_mng_id and a.client_id=c.client_id and a.bus_id2=d.user_id and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+)\n"+
				" order by a.sort, a.est_dt, a.client_id, a.car_mng_id "+
				" ";

		try {
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
			System.out.println("[SettleDatabase:getStatSettleSubHCList]\n"+e);
			System.out.println("[SettleDatabase:getStatSettleSubHCList]\n"+query);
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

	//채권관리캠페인 담당자별 세부리스트 :: 2군 영업 20140411
	public Vector getStatSettleSubHCList2Gun(String bus_id2, String var1_3, String var1_6)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		int settle_mon = 12; //채권반영개월수

		query = " select \n"+
				"        a.*, b.car_no, b.car_nm, c.firm_nm, d.user_nm, e.cms_bank \n"+
				" from \n"+
				" ( \n"+
				"	 select '7' sort, decode(a.req_gu,'1','휴차료','2','대차료') gubun1, '입금분' gubun2, \n"+
				"           b.rent_mng_id, b.rent_l_cd, b.car_mng_id, c.client_id, c.bus_id, nvl(a.bus_id2,c.bus_id2) bus_id2, \n"+
				"           d.ext_pay_dt  as est_dt, \n"+
				"           -round(d.ext_pay_amt*decode(u.loan_st, '1', 0.5, 0.25)) dly_amt \n"+
				"	 from   my_accid a, accident b, cont c, users u, "+
				"           (select * from scd_ext where ext_st='6' and ext_pay_dt is not null  ) d \n"+
				"    where \n"+
				"           a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd and c.bus_id='"+bus_id2+"'"+	                           
				"           and b.rent_mng_id=d.rent_mng_id and b.rent_l_cd=d.rent_l_cd and a.accid_id||to_char(a.seq_no)=d.ext_id "+
				"   		and to_char(sysdate,'YYYYMMdd')  between  d.ext_pay_dt and   to_char(add_months(to_date(d.ext_pay_dt), 1) , 'yyyymmdd')  \n"+
				"           and nvl(a.bus_id2,c.bus_id2)=u.user_id \n"+
			    "           AND TO_CHAR(ADD_MONTHS(sysdate,-"+settle_mon+"),'YYYYMMDD') < nvl(c.rent_start_dt,to_char(sysdate,'YYYYMMDD')) \n"+
				" ) a, car_reg b, client c, users d, cms_mng e \n"+
				" where a.bus_id='"+bus_id2+"' and a.car_mng_id=b.car_mng_id and a.client_id=c.client_id and a.bus_id2=d.user_id and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+)\n"+
				" order by a.sort, a.est_dt, a.client_id, a.car_mng_id "+
				" ";

		try {
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
			System.out.println("[SettleDatabase:getStatSettleSubHCList2Gun]\n"+e);
			System.out.println("[SettleDatabase:getStatSettleSubHCList2Gun]\n"+query);
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

	//채권관리캠페인 담당자별 평균리스트
	public Vector getStatSettleAvgPerList(String bus_id2, String save_dt, String var1_3, String var1_6)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		query = " select u.user_nm, a.* "+
                " from   stat_settle a, users u "+
                " where  a.bus_id2='"+bus_id2+"' and a.save_dt <> '"+save_dt+"' and a.save_dt between '"+var1_6+"' and '"+var1_3+"' "+
                "        and a.bus_id2 = u.user_id   "+
		"    order by a.save_dt asc  ";


		try {
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
			System.out.println("[SettleDatabase:getStatSettleAvgPerList]\n"+e);
			System.out.println("[SettleDatabase:getStatSettleAvgPerList]\n"+query);
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


	//휴차료/대차료  - 청구대비 입금액이 5만원 이상 차이 발생분 :20100101 부터- 접수번호 없는건 안나오게
	public Vector getInsurHList(String gubun1, String gubun2, String st_dt, String end_dt, String s_kd, String t_wd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select    b.ins_com, b.ins_nm, \n"+
			"        nvl(e.ins_com_f_nm,b.ins_com) ins_f_com, nvl(e.ins_com_id,'') ins_com_id, \n"+	
			"        a.car_mng_id, a.accid_id, b.seq_no, a.rent_mng_id, a.rent_l_cd, c.firm_nm,   \n"+
			"	     cr.car_no, cr.car_nm, \n"+
			"	     decode(a.accid_st, '1','피해자', '2','가해자', '3','쌍방', '4','자차사고') accid_st, nvl(a.ot_ins,'') ot_ins,  \n"+
			"	     decode(b.req_gu, '1','휴차료', '2','대차료') req_gu, \n"+
			"        b.use_day, b.use_hour, b.req_amt, nvl(h.pay_amt,0) pay_amt, c.use_yn, c.mng_id, c.rent_st,  \n"+
			"	     nvl2(a.accid_dt,substr(a.accid_dt,1,4)||'-'||substr(a.accid_dt,5,2)||'-'||substr(a.accid_dt,7,2),'') accid_dt,  \n"+
			"	     nvl2(b.req_dt,substr(b.req_dt,1,4)||'-'||substr(b.req_dt,5,2)||'-'||substr(b.req_dt,7,2),'') req_dt,  \n"+
			"	     nvl2(b.pay_dt,substr(b.pay_dt,1,4)||'-'||substr(b.pay_dt,5,2)||'-'||substr(b.pay_dt,7,2),'') pay_dt,  \n"+
			"        b.req_amt-NVL(h.pay_amt,0) def_amt, \n"+
			"        (TRUNC(((b.req_amt-NVL(h.pay_amt,0))*0.05*TRUNC(TO_DATE(NVL(h.pay_dt,b.req_dt), 'YYYYMMDD')- sysdate))/365) * -1) dly_amt, \n"+
			"        TRUNC(sysdate - TO_DATE(NVL(h.pay_dt,b.req_dt), 'YYYYMMDD')) dly_days \n"+
			" from   my_accid b, accident a, cont_n_view c, ins_com e, car_reg cr, \n"+
			"        (select a.rent_mng_id, a.rent_l_cd, a.ext_id, b.car_mng_id, sum(a.ext_pay_amt) pay_amt, MAX(a.ext_pay_dt) pay_dt \n"+
			"         from   scd_ext a, cont b \n"+
			"         where  a.ext_st='6' \n"+
			"                and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
			"         group by a.rent_mng_id, a.rent_l_cd, a.ext_id, b.car_mng_id \n"+
			"        ) h, \n"+
			"	     ot_accid d \n"+			
			" where  \n"+
			"	     nvl(b.req_st,'0') not in ('0','3') \n"+
			"	     and b.req_amt > 0 \n"+
//			"        and h.pay_amt > 0  and (b.req_amt - h.pay_amt ) >= 50000 and b.req_dt >= '20090101' and nvl(b.bill_yn, 'Y') = 'Y'  \n"+
			         //20111229 변경
//			"        and (b.req_amt - nvl(h.pay_amt,0) ) >= 10000 and b.req_dt >= '20090101' and c.rent_dt >= '2009-06-01' and TRUNC(MONTHS_BETWEEN(SYSDATE,TO_DATE(b.req_dt,'YYYYMMDD'))) >2\n"+
			"        and b.car_mng_id=a.car_mng_id and b.accid_id=a.accid_id  and b.car_mng_id = cr.car_mng_id \n"+
			"        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd  \n"+
			"        and b.ins_com=e.ins_com_nm(+) \n"+
			"        and b.car_mng_id=h.car_mng_id(+) and b.accid_id||b.seq_no=h.ext_id(+) \n"+	
            "        and trunc(NVL(h.pay_amt,0)/b.req_amt*100) < 70 \n"+ //20130409 70%이상 입금은 제외
			"        and b.car_mng_id=d.car_mng_id(+) and b.accid_id=d.accid_id(+) and b.seq_no=d.seq_no(+) \n"+
			"	     and nvl(b.ins_num,d.ot_num) is not null \n"+				
			" ";

	/*	if(t_wd.equals("전국택시공제조합") || t_wd.equals("KB손해보험") ){
			query += " and (b.req_amt - nvl(h.pay_amt,0) ) >= 10000 and b.req_dt >= '20090101' and c.rent_dt >= '2009-06-01' ";			
		}else{
		query += " and (b.req_amt - nvl(h.pay_amt,0) ) >= 10000 and b.req_dt >= '20090101' and c.rent_dt >= '2009-06-01' and TRUNC(MONTHS_BETWEEN(SYSDATE,TO_DATE(b.req_dt,'YYYYMMDD'))) >2 ";
		}
*/
		query += " and (b.req_amt - nvl(h.pay_amt,0) ) >= 10000 and b.req_dt >= '20090101' and c.rent_dt >= '2009-06-01' ";			
	
		if(s_kd.equals("1") && !t_wd.equals(""))		query += " and upper(nvl(e.ins_com_f_nm, ' ')) like upper('%"+t_wd+"%') ";

		if(!st_dt.equals("") && !end_dt.equals(""))		query += " and b.req_dt between replace( '"+st_dt+"','-','') and replace('"+end_dt+"','-','') ";

        query +=   "   order by a.accid_dt, decode(h.pay_amt,0,0,1), b.ins_com  " ;
                
        
        
		try {
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
			System.out.println("[SettleDatabase:getInsurHList]\n"+e);
			System.out.println("[SettleDatabase:getInsurHList]\n"+query);
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

	//휴차료/대차료 
	public Vector getInsurHReqDocList(String gubun1, String dt, String st_dt, String end_dt, String s_kd, String t_wd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.accid_id, a.seq_no, b.car_mng_id, b.rent_s_cd, b.rent_mng_id, b.rent_l_cd, \n"+
				"        a.ins_num, a.ins_com, a.ins_nm, a.ins_addr, a.req_dt, a.req_amt, substr(b.accid_dt,1,8) accid_dt, \n"+
				"        decode(e.cust_st,'1',d2.firm_nm,'4',f.user_nm,d1.firm_nm) firm_nm, \n"+
				"        decode(e.cust_st,'1',d2.enp_no,'4','',d1.enp_no) enp_no, \n"+
				"        decode(e.cust_st,'1',TEXT_DECRYPT(d2.ssn, 'pw' ) ,'4', TEXT_DECRYPT(f.user_ssn, 'pw' ) , TEXT_DECRYPT(d1.ssn, 'pw' ) ) ssn, \n"+
				"        g.car_no, g.car_nm, \n"+
				"        a.use_st, a.use_et, a.use_day, a.use_hour, a.req_amt, h.pay_amt, \n"+
				"        (a.req_amt-nvl(h.pay_amt,0)) jan_amt, \n"+
				"        decode(i.car_mng_id,'','미청구','청구') doc_st, \n"+
				"        nvl(i.cnt,0) doc_cnt, i.reg_dt as max_reg_dt \n"+
				" from   my_accid a, accident b, cont c, client d1, rent_cont e, client d2, users f, \n"+
				"        car_reg g, \n"+
				"        (select a.rent_mng_id, a.rent_l_cd, a.ext_id, b.car_mng_id, sum(a.ext_pay_amt) pay_amt \n"+
				"         from   scd_ext a, cont b \n"+
				"         where  a.ext_st='6' \n"+
				"                and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"         group by a.rent_mng_id, a.rent_l_cd, a.ext_id, b.car_mng_id \n"+
				"        ) h, \n"+
				"        (select car_mng_id, rent_s_cd, var1, count(0) cnt, max(reg_dt) reg_dt \n"+
				"         from   fine_doc_list \n"+
				"         where  substr(doc_id,1,2) in ('법무','손해') \n"+
				"         group by car_mng_id, rent_s_cd, var1 \n"+
				"        ) i \n"+
				" where  a.req_dt is not null \n"+
				"        and a.req_dt >= '20110101' \n"+
				"        and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id \n"+
				"        and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd \n"+
				"        and c.client_id=d1.client_id \n"+
				"        and b.rent_s_cd=e.rent_s_cd(+) and b.car_mng_id=e.car_mng_id(+) \n"+
				"        and e.cust_id=d2.client_id(+) \n"+
				"        and e.cust_id=f.user_id(+) \n"+
				"        and a.car_mng_id=g.car_mng_id(+) \n"+
				"        and a.car_mng_id=h.car_mng_id(+) and a.accid_id||a.seq_no=h.ext_id(+) "+
				"        and (a.req_amt-nvl(h.pay_amt,0)) >0 \n"+
				"        and a.car_mng_id=i.car_mng_id(+) and a.accid_id=i.rent_s_cd(+) and a.seq_no=i.var1(+) "+
				" ";


		if(!t_wd.equals(""))							query += " and a.ins_com like '%"+t_wd+"%'";

		if(gubun1.equals("1"))							query += " and i.car_mng_id is not null ";//청구
		if(gubun1.equals("2"))							query += " and i.car_mng_id is null ";//미청구

		if(dt.equals("2")){
			query += " and a.req_dt like to_char(sysdate,'YYYYMM')||'%'";		
		}else{
			if(!st_dt.equals("") && !end_dt.equals(""))		query += " and a.req_dt between replace( '"+st_dt+"','-','') and replace('"+end_dt+"','-','') ";
			if(!st_dt.equals("") && end_dt.equals(""))		query += " and a.req_dt = replace( '"+st_dt+"','-','') ";
		}

        query +=   "   order by a.ins_com, a.req_dt " ;
		
		try {
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
			System.out.println("[SettleDatabase:getInsurHReqDocList]\n"+e);
			System.out.println("[SettleDatabase:getInsurHReqDocList]\n"+query);
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

	//휴차료/대차료  - 청구대비 입금액이 10만원 이상 차이 발생분 :20100101 부터
	public Vector getInsurHReqInsComList(String gubun1, String gubun2, String st_dt, String end_dt, String s_kd, String t_wd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select   b.ins_com, b.ins_nm, \n"+
				"        nvl(e.ins_com_f_nm,b.ins_com) ins_f_com, nvl(e.ins_com_id,'') ins_com_id, decode(b.ins_addr,'',e.addr,b.ins_addr) ins_addr, e.zip, \n"+	
				"        a.car_mng_id, a.accid_id, b.seq_no, a.rent_mng_id, a.rent_l_cd, c.firm_nm,  \n"+
				"	     cr.car_no, cr.car_nm, \n"+
				"	     decode(a.accid_st, '1','피해자', '2','가해자', '3','쌍방', '4','자차사고') accid_st, nvl(a.ot_ins,'') ot_ins,  \n"+
				"	     decode(b.req_gu, '1','휴차료', '2','대차료') req_gu, \n"+
				"        b.use_day, b.use_hour, b.req_amt, h.pay_amt, c.use_yn, c.mng_id, c.rent_st,  \n"+
				"	     nvl2(a.accid_dt,substr(a.accid_dt,1,4)||'-'||substr(a.accid_dt,5,2)||'-'||substr(a.accid_dt,7,2),'') accid_dt,  \n"+
				"	     nvl2(b.req_dt,substr(b.req_dt,1,4)||'-'||substr(b.req_dt,5,2)||'-'||substr(b.req_dt,7,2),'') req_dt,  \n"+
				"	     nvl2(b.pay_dt,substr(b.pay_dt,1,4)||'-'||substr(b.pay_dt,5,2)||'-'||substr(b.pay_dt,7,2),'') pay_dt  \n"+
				" from   my_accid b, accident a, cont_n_view c, ins_com e, car_reg cr , \n"+
				"        (select a.rent_mng_id, a.rent_l_cd, a.ext_id, b.car_mng_id, sum(a.ext_pay_amt) pay_amt \n"+
				"         from   scd_ext a, cont b \n"+
				"         where  a.ext_st='6' \n"+
				"                and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"         group by a.rent_mng_id, a.rent_l_cd, a.ext_id, b.car_mng_id \n"+
				"        ) h, \n"+
				"        (select car_mng_id, rent_s_cd, var1, count(0) cnt, max(reg_dt) reg_dt \n"+
				"         from   fine_doc_list \n"+
				"         where  substr(doc_id,1,2) in ('법무','손해') \n"+
				"         group by car_mng_id, rent_s_cd, var1 \n"+
				"        ) d \n"+
				" where  b.req_st<>'0' and b.req_amt>0 and h.pay_amt=0 \n"+
				"        and b.req_dt >= '20110201' \n"+
				"        and b.car_mng_id=a.car_mng_id and b.accid_id=a.accid_id and b.car_mng_id = cr.car_mng_id \n"+
				"        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd  \n"+
				"        and b.ins_com=e.ins_com_nm(+) "+
				"        and b.car_mng_id=h.car_mng_id(+) and b.accid_id||b.seq_no=h.ext_id(+) \n"+
				"        and b.car_mng_id=d.car_mng_id(+) and b.accid_id=d.rent_s_cd(+) and b.seq_no=d.var1(+) and d.car_mng_id is null "+
				" ";


		if(!st_dt.equals("") && !end_dt.equals(""))		query += " and b.req_dt between replace( '"+st_dt+"','-','') and replace('"+end_dt+"','-','') ";

        query +=   "   order by decode(h.pay_amt,0,0,1), b.ins_com, a.accid_dt " ;

		
		try {
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
			System.out.println("[SettleDatabase:getInsurHReqInsComList]\n"+e);
			System.out.println("[SettleDatabase:getInsurHReqInsComList]\n"+query);
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

	//대차료 - 청구공문발행요청 조회
	public Vector getInsurHDocReqSearchList(String gubun1, String gubun2, String st_dt, String end_dt, String s_kd, String t_wd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select    b.ins_com, b.ins_nm, \n"+
				"        nvl(e.ins_com_f_nm,b.ins_com) ins_f_com, nvl(e.ins_com_id,'') ins_com_id, "+
				"        b.ins_addr as ins_addr, b.ins_zip as zip, b.app_docs, b.bus_id2, \n"+	
				"        a.car_mng_id, a.accid_id, b.seq_no, a.rent_mng_id, a.rent_l_cd, c.firm_nm,  \n"+
				"	     cr.car_no, cr.car_nm, \n"+
				"	     decode(a.accid_st, '1','피해자', '2','가해자', '3','쌍방', '4','자차사고') accid_st, nvl(a.ot_ins,'') ot_ins,  \n"+
				"	     decode(b.req_gu, '1','휴차료', '2','대차료') req_gu, \n"+
				"        b.doc_req_dt, b.use_st, b.use_et, b.use_day, b.use_hour, b.req_amt, h.pay_amt, c.use_yn, c.mng_id, c.rent_st,  \n"+
				"	     nvl2(a.accid_dt,substr(a.accid_dt,1,4)||'-'||substr(a.accid_dt,5,2)||'-'||substr(a.accid_dt,7,2),'') accid_dt,  \n"+
				"	     nvl2(b.req_dt,substr(b.req_dt,1,4)||'-'||substr(b.req_dt,5,2)||'-'||substr(b.req_dt,7,2),'') req_dt,  \n"+
				"	     nvl2(b.pay_dt,substr(b.pay_dt,1,4)||'-'||substr(b.pay_dt,5,2)||'-'||substr(b.pay_dt,7,2),'') pay_dt  \n"+
				" from   my_accid b, accident a, cont_n_view c, ins_com e, car_reg cr,  \n"+
				"        (select a.rent_mng_id, a.rent_l_cd, a.ext_id, b.car_mng_id, sum(a.ext_pay_amt) pay_amt \n"+
				"         from   scd_ext a, cont b \n"+
				"         where  a.ext_st='6' \n"+
				"                and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"         group by a.rent_mng_id, a.rent_l_cd, a.ext_id, b.car_mng_id \n"+
				"        ) h, \n"+
				"        (select car_mng_id, rent_s_cd, var1, count(0) cnt, max(reg_dt) reg_dt \n"+
				"         from   fine_doc_list \n"+
				"         where  substr(doc_id,1,2) in ('법무','손해') \n"+
				"         group by car_mng_id, rent_s_cd, var1 \n"+
				"        ) d \n"+
				" where  b.doc_req_dt is not null and b.doc_reg_dt is null \n"+
				"        and b.car_mng_id=a.car_mng_id and b.accid_id=a.accid_id  and b.car_mng_id = cr.car_mng_id \n"+
				"        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd  \n"+
				"        and b.ins_com=e.ins_com_nm(+) "+
				"        and b.car_mng_id=h.car_mng_id(+) and b.accid_id||b.seq_no=h.ext_id(+) \n"+
				"        and b.car_mng_id=d.car_mng_id(+) and b.accid_id=d.rent_s_cd(+) and b.seq_no=d.var1(+) and d.car_mng_id is null "+
				" ";


		if(!st_dt.equals("") && !end_dt.equals(""))		query += " and b.doc_req_dt between replace( '"+st_dt+"','-','') and replace('"+end_dt+"','-','') ";

        query +=   "   order by b.ins_com, b.doc_req_dt  " ;

		
		try {
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
			System.out.println("[SettleDatabase:getInsurHDocReqSearchList]\n"+e);
			System.out.println("[SettleDatabase:getInsurHDocReqSearchList]\n"+query);
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

	//휴차료/대차료 
	public Vector getInsurHReqDocHistoryList(String car_mng_id, String accid_id, String seq_no)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select b.*, c.user_nm \n"+
				" from   fine_doc_list a, fine_doc b, users c  \n"+
				" where  substr(a.doc_id,1,2) = '손해' \n"+
				"        and a.car_mng_id='"+car_mng_id+"' and a.rent_s_cd='"+accid_id+"' and a.var1="+seq_no+"  \n"+
				"        and a.doc_id=b.doc_id  \n"+
				"        and b.reg_id=c.user_id(+)  \n"+
				" ";
        query +=   "   order by b.doc_id " ;
		
		try {
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
			System.out.println("[SettleDatabase:getInsurHReqDocHistoryList]\n"+e);
			System.out.println("[SettleDatabase:getInsurHReqDocHistoryList]\n"+query);
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
	 
    //휴/대차료 조회 - 팝업 엑셀 리스트2 (선택리스트)
	public Hashtable getInsurHInfo(String ch_c_id, String ch_a_id, int ch_seq) 
	{
		getConnection();

		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";	
				
	
		query = " select    b.ins_com, b.ins_nm, \n"+
			"        nvl(e.ins_com_f_nm,b.ins_com) ins_f_com, nvl(e.ins_com_id,'') ins_com_id, \n"+	
			"        a.car_mng_id, a.accid_id, b.seq_no, a.rent_mng_id, a.rent_l_cd, c.firm_nm,   \n"+
			"	     cr.car_no, cr.car_nm, \n"+
			"	     decode(a.accid_st, '1','피해자', '2','가해자', '3','쌍방', '4','자차사고') accid_st, nvl(a.ot_ins,'') ot_ins,  \n"+
			"	     decode(b.req_gu, '1','휴차료', '2','대차료') req_gu, \n"+
			"        b.use_day, b.use_hour, b.req_amt, h.pay_amt, c.use_yn, c.mng_id, c.rent_st,  \n"+
			"	     nvl2(a.accid_dt,substr(a.accid_dt,1,4)||'-'||substr(a.accid_dt,5,2)||'-'||substr(a.accid_dt,7,2),'') accid_dt,  \n"+
			"	     nvl2(b.req_dt,substr(b.req_dt,1,4)||'-'||substr(b.req_dt,5,2)||'-'||substr(b.req_dt,7,2),'') req_dt,  \n"+
			"	     nvl2(b.pay_dt,substr(b.pay_dt,1,4)||'-'||substr(b.pay_dt,5,2)||'-'||substr(b.pay_dt,7,2),'') pay_dt,  \n"+
			"        b.req_amt-NVL(h.pay_amt,0) def_amt, \n"+
			"        (TRUNC(((b.req_amt-NVL(h.pay_amt,0))*0.05*TRUNC(TO_DATE(NVL(h.pay_dt,b.req_dt), 'YYYYMMDD')- sysdate))/365) * -1) dly_amt, \n"+
			"        TRUNC(sysdate - TO_DATE(NVL(h.pay_dt,b.req_dt), 'YYYYMMDD')) dly_days \n"+
			" from   my_accid b, accident a, cont_n_view c, ins_com e, car_reg cr,  \n"+
			"        (select a.rent_mng_id, a.rent_l_cd, a.ext_id, b.car_mng_id, sum(a.ext_pay_amt) pay_amt, MAX(a.ext_pay_dt) pay_dt \n"+
			"         from   scd_ext a, cont b \n"+
			"         where  a.ext_st='6' \n"+
			"                and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
			"         group by a.rent_mng_id, a.rent_l_cd, a.ext_id, b.car_mng_id \n"+
			"        ) h \n"+			
			" where  b.req_st<>'0' and b.req_amt > 0 "+
//			" 	     and h.pay_amt > 0  and (b.req_amt - h.pay_amt ) >= 50000 and b.req_dt >= '20090101' and nvl(b.bill_yn, 'Y') = 'Y'  \n"+
			         //20111229 변경
			"        and (b.req_amt - nvl(h.pay_amt,0) ) >= 10000 and b.req_dt >= '20090101' and c.rent_dt >= '2009-06-01' "+
//			"	     and TRUNC(MONTHS_BETWEEN(SYSDATE,TO_DATE(b.req_dt,'YYYYMMDD'))) >2\n"+
			"        and b.car_mng_id=a.car_mng_id and b.accid_id=a.accid_id and b.car_mng_id = cr.car_mng_id  \n"+
			"        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd  \n"+
			"        and b.ins_com=e.ins_com_nm(+) "+
			"        and b.car_mng_id=h.car_mng_id(+) and b.accid_id||b.seq_no=h.ext_id(+) \n"+			
			"  	     and b.car_mng_id = '"+ch_c_id+"' \n"+		
			"        and b.accid_id = '"+ch_a_id+"' \n"+		
			"	     and b.seq_no = "+ch_seq ;
		


		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
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
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[SettleDatabase:getInsurHInfo]\n"+e);
			System.out.println("[SettleDatabase:getInsurHInfo]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}

	//휴차료/대차료 
	public Hashtable getInsurHReqDocInfo(String ch_c_id, String ch_a_id, int ch_seq)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select a.accid_id, a.seq_no, b.car_mng_id, b.rent_s_cd, b.rent_mng_id, b.rent_l_cd, e.rent_s_cd, \n"+
				"        a.ins_num, a.ins_com, a.ins_nm, a.ins_addr, a.req_dt, a.req_amt, substr(b.accid_dt,1,8) accid_dt, \n"+
				"        decode(e.cust_st,'1',d2.firm_nm,'4',f.user_nm,d1.firm_nm) firm_nm, \n"+
				"        decode(e.cust_st,'1',d2.enp_no,'4','',d1.enp_no) enp_no, \n"+
				"        decode(e.cust_st,'1',TEXT_DECRYPT(d2.ssn, 'pw' ) ,'4', TEXT_DECRYPT(f.user_ssn, 'pw' ) , TEXT_DECRYPT(d1.ssn, 'pw' )) ssn, \n"+
				"        g.car_no, g.car_nm, \n"+
				"        a.use_st, a.use_et, a.use_day, a.use_hour, a.req_amt, h.pay_amt, \n"+
				"        (a.req_amt-nvl(h.pay_amt,0)) jan_amt, \n"+
				"        decode(i.car_mng_id,'','미청구','청구') doc_st, \n"+
				"        nvl(i.cnt,0) doc_cnt, i.reg_dt as max_reg_dt, a.pay_dt \n"+
				" from   my_accid a, accident b, cont c, client d1, rent_cont e, client d2, users f, \n"+
				"        car_reg g, \n"+
				"        (select rent_mng_id, rent_l_cd, ext_id, sum(ext_pay_amt) pay_amt \n"+
				"         from   scd_ext \n"+
				"         where ext_st='6' \n"+
				"         group by rent_mng_id, rent_l_cd, ext_id \n"+
				"        ) h, \n"+
				"        (select car_mng_id, rent_s_cd, var1, count(0) cnt, max(reg_dt) reg_dt \n"+
				"         from   fine_doc_list \n"+
				"         where  substr(doc_id,1,2) in ('법무','손해') \n"+
				"         group by car_mng_id, rent_s_cd, var1 \n"+
				"        ) i \n"+
				" where  a.car_mng_id='"+ch_c_id+"' and a.accid_id='"+ch_a_id+"' and a.seq_no="+ch_seq+"  \n"+
				"        and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id \n"+
				"        and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd \n"+
				"        and c.client_id=d1.client_id \n"+
				"        and b.rent_s_cd=e.rent_s_cd(+) and b.car_mng_id=e.car_mng_id(+) \n"+
				"        and e.cust_id=d2.client_id(+) \n"+
				"        and e.cust_id=f.user_id(+) \n"+
				"        and a.car_mng_id=g.car_mng_id(+) \n"+
				"        and b.rent_mng_id=h.rent_mng_id(+) and b.rent_l_cd=h.rent_l_cd(+) \n"+
				"        and a.car_mng_id=i.car_mng_id(+) and a.accid_id=i.rent_s_cd(+) and a.seq_no=i.var1(+) "+
				" ";
		

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
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
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[SettleDatabase:getInsurHReqDocInfo]\n"+e);
			System.out.println("[SettleDatabase:getInsurHReqDocInfo]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}

	/**
	 *	대여료 미청구분+잔가 스케줄
	 */
	public Vector getEndEstList(String m_id, String l_cd, String client_id, String mode, String gubun2, String st_dt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query = "";

		query = "   select '2_2' sort, '대여료' gubun1, '미청구분+잔가' gubun2,  \n"+
                "           rent_mng_id, rent_l_cd, car_mng_id, client_id, bus_id2, \n"+
                "           bas_end_dt as est_dt, dly_days, 0 dly_amt, \n"+
				"           0 s_amt, 0 v_amt, (dly_amt+o_1) amt, use_yn, '미청구분+잔가' tm, '' st \n"+
                "           from \n"+
                "           ( select a.use_yn, a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.bus_id2, \n"+
                "                    case when b.rent_end_dt > d.fee_est_dt then b.rent_end_dt else d.fee_est_dt end bas_end_dt, \n"+
                "                    trunc((b.fee_s_amt+b.fee_v_amt)/30*to_number(sysdate-to_date(case when b.rent_end_dt > d.fee_est_dt then b.rent_end_dt else d.fee_est_dt end,'YYYYMMDD')),0) dly_amt, \n"+
                "                    decode(e.fee_opt_amt,0,nvl(e.o_1,0),e.fee_opt_amt) as o_1, \n"+
				"                    sysdate-to_date(case when b.rent_end_dt > d.fee_est_dt then b.rent_end_dt else d.fee_est_dt end,'YYYYMMDD') dly_days \n"+
                "             from   cont a, fee b, \n"+
                "                    (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) c, \n"+
                "                    (select rent_mng_id, rent_l_cd, max(use_e_dt) fee_est_dt from scd_fee group by rent_mng_id, rent_l_cd) d, \n"+
                "                    (select * from estimate_sh where est_from='car_janga' and rent_dt=to_char(sysdate,'YYYYMMDD')) e, cls_etc f, \n"+
				"                    ( select * from car_call_in where in_st='3' and out_dt is null ) cc \n"+
                "             where  a.use_yn='Y' and a.car_st in ('1','3')\n";

		if(mode.equals("client"))	query += " and a.client_id='"+client_id+"'";
		else						query += " and a.rent_l_cd='"+l_cd+"'";

		query +="             and    a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
                "             and    b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st \n"+
                "             and    a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd \n"+
                "             and    b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd and b.rent_st=e.rent_st \n"+
			    "             and    a.rent_mng_id=f.rent_mng_id(+) and a.rent_l_cd=f.rent_l_cd(+) and f.rent_l_cd is null \n"+
				"             and    a.rent_mng_id=cc.rent_mng_id(+) and a.rent_l_cd=cc.rent_l_cd(+) and cc.rent_l_cd is null \n"+
//              "             and    sysdate-to_date(case when b.rent_end_dt > d.fee_est_dt then b.rent_end_dt else d.fee_est_dt end,'YYYYMMDD')>0 \n"+
                "             and    b.rent_end_dt < to_char(sysdate,'YYYYMMDD') and d.fee_est_dt < to_char(sysdate,'YYYYMMDD') \n"+//--20140729 3일경과일부터 채권에 나오게
                "           )           \n"+		
				" ";

		query += " order by rent_l_cd";

		try {
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
			System.out.println("[SettleDatabase:getEndEstList]\n"+e);
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
	
	/**
	 *	미수금현황 리스트- 켐페인 미적용자
	 *	2010.12.29. jhm
	 */
	public Vector getStatFSettle(String lost_st, String save_dt, String eff_dt, String max_amt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
	
		query = " select a.*, 0 tot_su, c.br_id, c.dept_id, b.user_id as partner_id2, b.user_nm as partner_nm, c.loan_st, "+
//				"        e.cmp_per as per_0405"+
				"        e.add_per as per_0405"+
				" from stat_settle a, users c, (select bus_id2, add_per from stat_settle where save_dt='"+eff_dt+"') e, users b"+
				" where a.bus_id2=c.user_id and a.save_dt='"+save_dt+"' and a.bus_id2=e.bus_id2(+) and a.partner_id=b.user_id(+) and c.use_yn='Y' and a.bus_id2 not in ('000052') ";

		if(!max_amt.equals("") && !max_amt.equals("0")){
			query += " and   a.tot_amt < "+AddUtil.replace(max_amt,",","")+"    ";
		}

		/*
		if(lost_st.equals("3"))	{
			if(!max_amt.equals("") && !max_amt.equals("0"))		query += " and a.three_amt >= "+AddUtil.replace(max_amt,",","");
		}else{
			if(!max_amt.equals("") && !max_amt.equals("0"))		query += " and a.tot_amt >= "+AddUtil.replace(max_amt,",","");
		}
		*/


		if(!lost_st.equals(""))								query += " and c.loan_st='"+lost_st+"'";

		if(AddUtil.parseInt(save_dt) < 20080107)			query += " and to_number(c.enter_dt) < 20071010";
		

		query += " order by to_number(a.r_cmp_per), to_number(a.cmp_per), a.amt, (a.per1+a.avg_per) ";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			while(rs.next())
			{
				IncomingSBean fee = new IncomingSBean();				
				
				fee.setGubun(rs.getString("bus_id2"));
				fee.setBr_id(rs.getString("br_id"));
				fee.setDept_id(rs.getString("dept_id"));

				fee.setTot_amt1(rs.getString("tot_amt"));
				fee.setTot_amt2(rs.getString("amt"));
				fee.setTot_amt3(rs.getString("three_amt")==null?"0":rs.getString("three_amt"));
				fee.setTot_amt4(rs.getString("amt_out")==null?"0":rs.getString("amt_out"));
				fee.setTot_amt5(rs.getString("amt_in")==null?"0":rs.getString("amt_in"));
				fee.setTot_amt6(rs.getString("eff_amt_out")==null?"0":rs.getString("eff_amt_out"));
				fee.setTot_amt7(rs.getString("eff_amt_in")==null?"0":rs.getString("eff_amt_in"));
				fee.setTot_amt8(rs.getString("amt_in2")==null?"0":rs.getString("amt_in2"));
				fee.setTot_amt9(rs.getString("amt_in1")==null?"0":rs.getString("amt_in1"));

				fee.setTot_su2(rs.getString("su"));				
				fee.setTot_su3(rs.getString("per1"));			
				fee.setTot_su4(rs.getString("per2")==null?"":rs.getString("per2"));
				fee.setTot_su5(rs.getString("per_0405")==null?"":rs.getString("per_0405"));
				fee.setTot_su6(rs.getString("avg_per")==null?"":rs.getString("avg_per"));
				fee.setTot_su7(rs.getString("cmp_per")==null?"":rs.getString("cmp_per"));
				fee.setTot_su8(rs.getString("r_cmp_per")==null?"":rs.getString("r_cmp_per"));
				fee.setTot_su1(rs.getString("r_eff_per")==null?"":rs.getString("r_eff_per"));
				
				fee.setPartner_id(rs.getString("partner_id2")==null?"":rs.getString("partner_id2"));
				fee.setPartner_nm(rs.getString("partner_nm")==null?"":rs.getString("partner_nm"));
				fee.setReg_dt(rs.getString("reg_dt")==null?"":rs.getString("reg_dt"));

				if(rs.getString("loan_st").equals("2")){
					if(fee.getTot_su3().equals("0")) fee.setTot_su3("0.000");
					if(fee.getTot_su4().equals("0")) fee.setTot_su4("0.000");
					if(fee.getTot_su6().equals("0")) fee.setTot_su6("0.000");
					if(fee.getTot_su7().equals("0")) fee.setTot_su7("0.000");
				}else{
					if(fee.getTot_su3().equals("0")) fee.setTot_su3("0.00");
					if(fee.getTot_su4().equals("0")) fee.setTot_su4("0.00");
					if(fee.getTot_su6().equals("0")) fee.setTot_su6("0.00");
					if(fee.getTot_su7().equals("0")) fee.setTot_su7("0.00");
				}

				vt.add(fee);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[SettleDatabase:getStatFSettle]"+e);
			System.out.println("[SettleDatabase:getStatFSettle]"+query);
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
	 *	미수금현황 리스트- 켐페인 미적용자 - 에이전트
	 *	2010.12.29. jhm
	 */
	public Vector getStatAgentSettle(String lost_st, String save_dt, String eff_dt, String max_amt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

	
		query = " select a.*, 0 tot_su, c.br_id, c.dept_id, b.user_id as partner_id2, b.user_nm as partner_nm, c.loan_st, "+
				"        e.add_per as per_0405"+
				" from stat_settle a, users c, (select bus_id2, add_per from stat_settle where save_dt='"+eff_dt+"') e, users b"+
				" where a.save_dt='"+save_dt+"' and a.bus_id2=c.user_id and c.dept_id='1000' and a.bus_id2=e.bus_id2(+) and a.partner_id=b.user_id(+) and c.use_yn='Y' ";
		
		query += " order by to_number(a.r_cmp_per), to_number(a.cmp_per), a.amt, (a.per1+a.avg_per) ";



		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			while(rs.next())
			{


				IncomingSBean fee = new IncomingSBean();				
				
				fee.setGubun(rs.getString("bus_id2"));
				fee.setBr_id(rs.getString("br_id"));
				fee.setDept_id(rs.getString("dept_id"));

				fee.setTot_amt1(rs.getString("tot_amt"));
				fee.setTot_amt2(rs.getString("amt"));
				fee.setTot_amt3(rs.getString("three_amt")==null?"0":rs.getString("three_amt"));
				fee.setTot_amt4(rs.getString("amt_out")==null?"0":rs.getString("amt_out"));
				fee.setTot_amt5(rs.getString("amt_in")==null?"0":rs.getString("amt_in"));

				fee.setTot_su2(rs.getString("su"));				
				fee.setTot_su3(rs.getString("per1"));			
				fee.setTot_su4(rs.getString("per2")==null?"":rs.getString("per2"));
				fee.setTot_su5(rs.getString("per_0405")==null?"":rs.getString("per_0405"));
				fee.setTot_su6(rs.getString("avg_per")==null?"":rs.getString("avg_per"));
				fee.setTot_su7(rs.getString("cmp_per")==null?"":rs.getString("cmp_per"));
				fee.setTot_su8(rs.getString("r_cmp_per")==null?"":rs.getString("r_cmp_per"));
				
				fee.setPartner_id(rs.getString("partner_id2")==null?"":rs.getString("partner_id2"));
				fee.setPartner_nm(rs.getString("partner_nm")==null?"":rs.getString("partner_nm"));
				fee.setReg_dt(rs.getString("reg_dt")==null?"":rs.getString("reg_dt"));

				vt.add(fee);

			}
			rs.close();
			pstmt.close();


		} catch (SQLException e) {
			System.out.println("[SettleDatabase:getStatAgentSettle]"+e);
			System.out.println("[SettleDatabase:getStatAgentSettle]"+query);
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
	 *	2개월 경과후에도 기존 영업담당자에게 있는 경우
	 */
	public Hashtable getClsUseMon(String m_id, String l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();

		String query = "";

		query = " select nvl(trunc(months_between(sysdate, to_date(cls_dt,'YYYYMMDD')+1)),0) use_mon \n"+
				" from   cls_cont \n"+
				" where  rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"' \n";


		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
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
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[SettleDatabase:getClsUseMon]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}

	// 소액채권대손처리요청 - scd_fee 대손처리 
	public boolean updateBadDebtFee(String update_id, String rent_mng_id, String rent_l_cd, String rent_st, String rent_seq, String fee_tm, String tm_st1 ){
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;

		String query = "";

		query =  " UPDATE scd_fee SET bill_yn='N', update_dt=to_char(sysdate,'YYYYMMDD'), update_id=? "+
				 " WHERE rent_mng_id=? and rent_l_cd=? and rent_st=? and rent_seq=? and fee_tm=? and tm_st1 = ? ";


		try 
		{
			
			conn.setAutoCommit(false);
			    	
			pstmt1 = conn.prepareStatement(query);
			pstmt1.setString(1, update_id);
			pstmt1.setString(2, rent_mng_id);
			pstmt1.setString(3, rent_l_cd);
			pstmt1.setString(4, rent_st);
			pstmt1.setString(5, rent_seq);
			pstmt1.setString(6, fee_tm);
			pstmt1.setString(7, tm_st1);
		    pstmt1.executeUpdate();
			pstmt1.close();
		    
		    conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddExtDatabase:updateBadDebtFee]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				if(pstmt1 != null)	pstmt1.close();
				conn.setAutoCommit(true);
			}
			catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	// 소액채권대손처리요청 - scd_fee 대손처리 
	public boolean updateBadDebtDlyFee(String update_id, String rent_mng_id, String rent_l_cd, int amt ){
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		PreparedStatement pstmt3 = null;
		ResultSet rs2 = null;
		String seq = "";
		String query = "";
		int chk = 0;

		query = " insert into SCD_DLY (RENT_MNG_ID, RENT_L_CD, SEQ, PAY_DT, PAY_AMT, REG_ID, REG_DT, ETC )"+
				" values (?, ?, ?, to_char(sysdate,'YYYYMMDD'), ?, ?, to_char(sysdate,'YYYYMMDD'), ? )";

		String query_seq = "";
		query_seq = " select nvl(to_char(max(to_number(seq))+1),'1') seq from scd_dly where rent_mng_id=? ";

		//입력체크
		String query2 = "select count(0) from SCD_DLY where rent_mng_id=? and SEQ=?";



		try 
		{
			
			conn.setAutoCommit(false);
			    	
			pstmt1 = conn.prepareStatement(query_seq);
			pstmt1.setString(1, rent_mng_id);
		    rs = pstmt1.executeQuery();
			if(rs.next()){
				seq = rs.getString(1);
			}
			rs.close();
			pstmt1.close();


			pstmt3 = conn.prepareStatement(query2);
			pstmt3.setString(1, rent_mng_id);
			pstmt3.setString(2, seq);
	    	rs2 = pstmt3.executeQuery();
			if(rs2.next()){
				chk = rs2.getInt(1);	
			}
			rs2.close();
			pstmt3.close();

			if(chk==0){
				pstmt2 = conn.prepareStatement(query);
				pstmt2.setString(1, rent_mng_id);
				pstmt2.setString(2, rent_l_cd);
				pstmt2.setString(3, seq);
				pstmt2.setInt   (4, amt);
				pstmt2.setString(5, update_id);
				pstmt2.setString(6, "소액대손처리");
				pstmt2.executeUpdate();
				pstmt2.close();
			}
		    
		    conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[SettleDatabase:updateBadDebtDlyFee]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(rs2 != null )	rs2.close();
				if(pstmt1 != null )	pstmt1.close();
				if(pstmt2 != null )	pstmt2.close();
				if(pstmt3 != null )	pstmt3.close();
				conn.setAutoCommit(true);
			}
			catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	// 소액채권대손처리요청 - scd_ext 대손처리 
	public boolean updateBadDebtExt(String update_id, String rent_mng_id, String rent_l_cd, String rent_st, String ext_st, String ext_tm, String ext_id ){
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;

		String query = "";

		query =  " UPDATE scd_ext SET bill_yn='N', update_dt=to_char(sysdate,'YYYYMMDD'), update_id=? "+
				 " WHERE rent_mng_id=? and rent_l_cd=? and rent_st=? and ext_st=? and ext_tm=? and ext_id = ? ";


		try 
		{
			
			conn.setAutoCommit(false);
			    	
			pstmt1 = conn.prepareStatement(query);
			pstmt1.setString(1, update_id);
			pstmt1.setString(2, rent_mng_id);
			pstmt1.setString(3, rent_l_cd);
			pstmt1.setString(4, rent_st);
			pstmt1.setString(5, ext_st);
			pstmt1.setString(6, ext_tm);
			pstmt1.setString(7, ext_id);
		    pstmt1.executeUpdate();
			pstmt1.close();
		    
		    conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddExtDatabase:updateBadDebtExt]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				if(pstmt1 != null)	pstmt1.close();
				conn.setAutoCommit(true);
			}
			catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	// 소액채권대손처리요청 - fine 대손처리 
	public boolean updateBadDebtFine(String update_id, String rent_mng_id, String rent_l_cd, String car_mng_id, int seq_no ){
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;

		String query = "";

		query =  " UPDATE fine SET bill_yn='N', update_dt=to_char(sysdate,'YYYYMMDD'), update_id=?, no_paid_yn='Y', no_paid_cau='소액채권대손처리' "+
				 " WHERE rent_mng_id=? and rent_l_cd=? and car_mng_id=? and seq_no=? ";

		try 
		{
			
			conn.setAutoCommit(false);
			    	
			pstmt1 = conn.prepareStatement(query);
			pstmt1.setString(1, update_id);
			pstmt1.setString(2, rent_mng_id);
			pstmt1.setString(3, rent_l_cd);
			pstmt1.setString(4, car_mng_id);
			pstmt1.setInt   (5, seq_no);
		    pstmt1.executeUpdate();
			pstmt1.close();
		    
		    conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddExtDatabase:updateBadDebtFine]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				if(pstmt1 != null)	pstmt1.close();
				conn.setAutoCommit(true);
			}
			catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	// 소액채권대손처리요청 - fine 대손처리 
	public boolean updateBadDebtFine_Etc(String update_id, String rent_mng_id, String rent_l_cd, String car_mng_id, int seq_no, String no_paid_cau ){
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;

		String query = "";

		query =  " UPDATE fine SET bill_yn='N', update_dt=to_char(sysdate,'YYYYMMDD'), update_id=?, no_paid_yn='Y', no_paid_cau=no_paid_cau||' '||'"+no_paid_cau+"' "+
				 " WHERE rent_mng_id=? and rent_l_cd=? and car_mng_id=? and seq_no=? ";

		try 
		{
			
			conn.setAutoCommit(false);
			    	
			pstmt1 = conn.prepareStatement(query);
			pstmt1.setString(1, update_id);
			pstmt1.setString(2, rent_mng_id);
			pstmt1.setString(3, rent_l_cd);
			pstmt1.setString(4, car_mng_id);
			pstmt1.setInt   (5, seq_no);
		    pstmt1.executeUpdate();
			pstmt1.close();
		    
		    conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddExtDatabase:updateBadDebtFine_Etc]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				if(pstmt1 != null)	pstmt1.close();
				conn.setAutoCommit(true);
			}
			catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	// 소액채권대손처리요청 - MyAccid 대손처리 
	public boolean updateBadDebtMyAccid(String update_id, String rent_mng_id, String rent_l_cd, String car_mng_id, String e_ext_id ){
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;

		String query = "";

		query =  " UPDATE my_accid SET bill_yn='N', update_dt=to_char(sysdate,'YYYYMMDD'), update_id=?, re_reason='소액채권대손처리' "+
				 " WHERE car_mng_id=? and accid_id||seq_no=? ";

		try 
		{
			
			conn.setAutoCommit(false);
			    	
			pstmt1 = conn.prepareStatement(query);
			pstmt1.setString(1, update_id);
			pstmt1.setString(2, car_mng_id);
			pstmt1.setString(3, e_ext_id);
		    pstmt1.executeUpdate();
			pstmt1.close();
		    
		    conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddExtDatabase:updateBadDebtMyAccid]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				if(pstmt1 != null)	pstmt1.close();
				conn.setAutoCommit(true);
			}
			catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	// 소액채권대손처리요청 - scd_rent 대손처리 
	public boolean updateBadDebtRentCont(String update_id, String rent_s_cd, String rent_st, int tm ){
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;

		String query = "";

		query =  " UPDATE scd_rent SET bill_yn='N', update_dt=to_char(sysdate,'YYYYMMDD'), update_id=? "+
				 " WHERE rent_s_cd=? and rent_st=? and tm=? ";

		try 
		{
			
			conn.setAutoCommit(false);
			    	
			pstmt1 = conn.prepareStatement(query);
			pstmt1.setString(1, update_id);
			pstmt1.setString(2, rent_s_cd);
			pstmt1.setString(3, rent_st);
			pstmt1.setInt   (4, tm);
		    pstmt1.executeUpdate();
			pstmt1.close();
		    
		    conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddExtDatabase:updateBadDebtRentCont]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				if(pstmt1 != null)	pstmt1.close();
				conn.setAutoCommit(true);
			}
			catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	/**
	 *	고객별 계약리스트 조회
	 */
	public Vector getContComplaintList(String client_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.rent_dt, a.use_yn, b.user_nm, "+
				"        decode(a.car_gu,'0','재리스','1','신차') car_gu, decode(c.client_guar_st,'1','입보','2','면제') client_guar_st, decode(c.client_share_st,'1','있다','없다') client_share_st, c.rent_suc_dt, \n"+
				"        e.car_no, e.car_nm, e.init_reg_dt, \n"+
				"        (d.car_cs_amt+d.CAR_CV_AMT+d.OPT_CS_AMT+d.OPT_CV_AMT+d.CLR_CS_AMT+d.CLR_CV_AMT-d.tax_dc_s_amt-d.tax_dc_v_amt) car_amt, \n"+
				"        f.rent_st, f.grt_amt_s, (f.pp_s_amt+f.pp_v_amt) pp_amt, (f.ifee_s_amt+f.ifee_v_amt) ifee_amt, \n"+
				"        f.con_mon, f.rent_start_dt, f.rent_end_dt, f.fee_est_day, (f.fee_s_amt+f.fee_v_amt) fee_amt, \n"+
				"        m.t_cnt, m.t_con_mon, m.t_rent_start_dt, m.t_rent_end_dt, \n"+
				"        g.add_cnt, g.add_rent_start_dt, g.add_rent_end_dt, g.add_tm, \n"+
				"        (h.fee_tm-1) a_fee_tm, h.fee_tm, h.fee_est_dt, h.dly_fee_amt, \n"+
				"        trunc(MONTHS_BETWEEN(SYSDATE,TO_DATE(h.use_s_dt,'YYYYMMDD'))) dly_mon, \n"+
				"        i.doc_dt, i.doc_id, n.title, k.nm as car_comp_nm, NVL(l.sh_amt,0) sh_amt, j.car_name  \n"+
				" FROM   CONT a, USERS b, CONT_ETC c, CAR_ETC d, CAR_REG e, FEE f, \n"+
				"        (select rent_mng_id, rent_l_cd, count(0) t_cnt, max(to_number(rent_st)) rent_st, sum(con_mon) t_con_mon, min(rent_start_dt) t_rent_start_dt, max(rent_end_dt) t_rent_end_dt from fee group by rent_mng_id, rent_l_cd) m, \n"+
				"        (SELECT rent_mng_id, rent_l_cd, count(0) add_cnt, rent_st, MIN(rent_start_dt) add_rent_start_dt, MAX(rent_end_dt) add_rent_end_dt, SUM(add_tm) add_tm FROM FEE_IM GROUP BY rent_mng_id, rent_l_cd, rent_st) g, \n"+
				"        (SELECT rent_mng_id, rent_l_cd, MIN(to_number(rent_st)) rent_st, min(TO_NUMBER(fee_tm)) fee_tm, MIN(fee_est_dt) fee_est_dt, MIN(use_s_dt) use_s_dt, SUM(fee_s_amt+fee_v_amt) dly_fee_amt FROM SCD_FEE WHERE bill_yn='Y' and tm_st2<>'4' AND rc_dt IS NULL AND r_fee_est_dt < TO_CHAR(SYSDATE,'YYYYMMDD') GROUP BY rent_mng_id, rent_l_cd) h, \n"+
				"        (SELECT b.rent_mng_id, b.rent_l_cd, max(a.doc_dt) doc_dt, max(a.doc_id) doc_id FROM FINE_DOC a, FINE_DOC_LIST b WHERE a.doc_id LIKE '채권추심%' AND a.doc_id=b.doc_id GROUP BY b.rent_mng_id, b.rent_l_cd) i, \n"+
				"        car_nm j, (select * from code where c_st='0001') k, fee_etc l, FINE_DOC n \n"+
				" WHERE  a.client_id='"+client_id+"' and a.use_yn='Y' \n"+
				"        AND a.bus_id2=b.user_id \n"+
				"        AND a.rent_mng_id=c.rent_mng_id(+) AND a.rent_l_cd=c.rent_l_cd(+) \n"+
				"        AND a.rent_mng_id=d.rent_mng_id AND a.rent_l_cd=d.rent_l_cd \n"+
				"        AND a.car_mng_id=e.car_mng_id \n"+
				"        AND a.rent_mng_id=f.rent_mng_id AND a.rent_l_cd=f.rent_l_cd  \n"+
				"        AND f.rent_mng_id=m.rent_mng_id AND f.rent_l_cd=m.rent_l_cd AND f.rent_st=m.rent_st \n"+
				"        AND f.rent_mng_id=g.rent_mng_id(+) AND f.rent_l_cd=g.rent_l_cd(+) AND f.rent_st=g.rent_st(+) \n"+
				"        AND f.rent_mng_id=h.rent_mng_id(+) AND f.rent_l_cd=h.rent_l_cd(+) AND f.rent_st=h.rent_st(+) \n"+
				"        AND a.rent_mng_id=i.rent_mng_id(+) AND a.rent_l_cd=i.rent_l_cd(+) \n"+
				"        AND d.car_id=j.car_id and d.car_seq=j.car_seq and j.car_comp_id=k.code \n"+
				"        AND f.rent_mng_id=l.rent_mng_id(+) AND f.rent_l_cd=l.rent_l_cd(+) AND f.rent_st=l.rent_st(+) \n"+
				"        AND i.doc_id=n.doc_id(+)"+
				"        AND decode(a.rent_l_cd,'S112HHLR00070',3,'S113HMCL00024',3,'S113HXAL00021',3,'B110SS7R00030',3,'D112KMOL00020',3,trunc(MONTHS_BETWEEN(SYSDATE,TO_DATE(h.use_s_dt,'YYYYMMDD')))) >= 1 "+
				" ORDER BY a.use_yn DESC, a.rent_dt desc, a.rent_l_cd  ";
		
		try {
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
			System.out.println("[SettleDatabase:getContComplaintList]\n"+e);
			System.out.println("[SettleDatabase:getContComplaintList]\n"+query);
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

	/**
	 *	고객별 계약리스트 조회
	 */
	public Vector getContComplaintList(String client_id, int seq)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.rent_dt, a.use_yn, b.user_nm, "+
				"        decode(a.car_gu,'0','재리스','1','신차') car_gu, decode(c.client_guar_st,'1','입보','2','면제') client_guar_st, decode(c.client_share_st,'1','있다','없다') client_share_st, c.rent_suc_dt, \n"+
				"        e.car_no, e.car_nm, e.init_reg_dt, \n"+
				"        (d.car_cs_amt+d.CAR_CV_AMT+d.OPT_CS_AMT+d.OPT_CV_AMT+d.CLR_CS_AMT+d.CLR_CV_AMT-d.tax_dc_s_amt-d.tax_dc_v_amt) car_amt, \n"+
				"        f.rent_st, f.grt_amt_s, (f.pp_s_amt+f.pp_v_amt) pp_amt, (f.ifee_s_amt+f.ifee_v_amt) ifee_amt, \n"+
				"        f.con_mon, f.rent_start_dt, f.rent_end_dt, f.fee_est_day, (f.fee_s_amt+f.fee_v_amt) fee_amt, \n"+
//				"        m.t_con_mon, m.t_rent_start_dt, m.t_rent_end_dt, \n"+
//				"        g.add_rent_start_dt, g.add_rent_end_dt, g.add_tm, \n"+
//				"        (h.fee_tm-1) a_fee_tm, h.fee_tm, h.fee_est_dt, h.dly_fee_amt, \n"+
//				"        trunc(MONTHS_BETWEEN(SYSDATE,TO_DATE(h.use_s_dt,'YYYYMMDD'))) dly_mon, \n"+
				"        bc.t_con_mon, bc.t_rent_start_dt, bc.t_rent_end_dt, "+
				"        bc.add_tm, bc.add_rent_start_dt, bc.add_rent_end_dt, "+
				"        bc.a_fee_tm, bc.fee_tm, bc.fee_est_dt, bc.dly_mon, bc.dly_fee_amt, "+		
				"        i.doc_id, n.doc_dt, n.title, k.nm as car_comp_nm, NVL(l.sh_amt,0) sh_amt, j.car_name  \n"+
				" FROM   BAD_COMPLAINT_REQ_LIST bc, CONT a, USERS b, CONT_ETC c, CAR_ETC d, CAR_REG e, FEE f, \n"+
				"        (select rent_mng_id, rent_l_cd, count(0) t_cnt, max(to_number(rent_st)) rent_st, sum(con_mon) t_con_mon, min(rent_start_dt) t_rent_start_dt, max(rent_end_dt) t_rent_end_dt from fee group by rent_mng_id, rent_l_cd) m, \n"+
				"        (SELECT rent_mng_id, rent_l_cd, count(0) add_cnt, rent_st, MIN(rent_start_dt) add_rent_start_dt, MAX(rent_end_dt) add_rent_end_dt, SUM(add_tm) add_tm FROM FEE_IM GROUP BY rent_mng_id, rent_l_cd, rent_st) g, \n"+
				"        (SELECT rent_mng_id, rent_l_cd, MIN(to_number(rent_st)) rent_st, min(TO_NUMBER(fee_tm)) fee_tm, MIN(fee_est_dt) fee_est_dt, MIN(use_s_dt) use_s_dt, SUM(fee_s_amt+fee_v_amt) dly_fee_amt FROM SCD_FEE WHERE bill_yn='Y' and tm_st2<>'4' AND rc_dt IS NULL AND r_fee_est_dt < TO_CHAR(SYSDATE,'YYYYMMDD') GROUP BY rent_mng_id, rent_l_cd) h, \n"+
				"        FINE_DOC_LIST i, \n"+
				"        car_nm j, (select * from code where c_st='0001') k, fee_etc l, FINE_DOC n \n"+
				" WHERE  bc.bad_comp_cd='"+client_id+String.valueOf(seq)+"' and bc.rent_mng_id=a.rent_mng_id and bc.rent_l_cd=a.rent_l_cd \n"+
				"        AND a.bus_id2=b.user_id \n"+
				"        AND a.rent_mng_id=c.rent_mng_id(+) AND a.rent_l_cd=c.rent_l_cd(+) \n"+
				"        AND a.rent_mng_id=d.rent_mng_id AND a.rent_l_cd=d.rent_l_cd \n"+
				"        AND a.car_mng_id=e.car_mng_id \n"+
				"        AND a.rent_mng_id=f.rent_mng_id AND a.rent_l_cd=f.rent_l_cd  \n"+
				"        AND f.rent_mng_id=m.rent_mng_id AND f.rent_l_cd=m.rent_l_cd AND f.rent_st=m.rent_st \n"+
				"        AND f.rent_mng_id=g.rent_mng_id(+) AND f.rent_l_cd=g.rent_l_cd(+) AND f.rent_st=g.rent_st(+) \n"+
				"        AND f.rent_mng_id=h.rent_mng_id(+) AND f.rent_l_cd=h.rent_l_cd(+) AND f.rent_st=h.rent_st(+) \n"+
				"        AND bc.rent_mng_id=i.rent_mng_id(+) AND bc.rent_l_cd=i.rent_l_cd(+) and bc.credit_doc_id=i.doc_id(+) \n"+
				"        AND d.car_id=j.car_id and d.car_seq=j.car_seq and j.car_comp_id=k.code \n"+
				"        AND f.rent_mng_id=l.rent_mng_id(+) AND f.rent_l_cd=l.rent_l_cd(+) AND f.rent_st=l.rent_st(+) \n"+
				"        AND i.doc_id=n.doc_id(+)"+
				" ORDER BY bc.seq ";
		
		try {
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
			System.out.println("[SettleDatabase:getContComplaintList]\n"+e);
			System.out.println("[SettleDatabase:getContComplaintList]\n"+query);
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

	//고소장접수요청 한건 조회
	public BadComplaintReqBean getBadComplaintReq(String client_id, int seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		BadComplaintReqBean base = new BadComplaintReqBean();
		String query = "";

		query = " select * from BAD_COMPLAINT_REQ where client_id=? and seq=?";

		try
		{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, client_id	);
			pstmt.setInt   (2, seq			);
		   	rs = pstmt.executeQuery();
		
			if(rs.next())
			{
				base.setClient_id		(rs.getString("client_id")		==null?"":rs.getString("client_id"));
				base.setSeq				(rs.getString("seq")			==null?0 :Integer.parseInt(rs.getString("seq")));
				base.setReg_id			(rs.getString("reg_id")			==null?"":rs.getString("reg_id"));
				base.setReg_dt			(rs.getString("reg_dt")			==null?"":rs.getString("reg_dt"));
				base.setBad_cau			(rs.getString("bad_cau")		==null?"":rs.getString("bad_cau"));
				base.setBad_st			(rs.getString("bad_st")			==null?"":rs.getString("bad_st"));
				base.setReq_dt  		(rs.getString("req_dt")			==null?"":rs.getString("req_dt"));
				base.setCar_call_yn		(rs.getString("car_call_yn")	==null?"":rs.getString("car_call_yn"));
				base.setCancel_dt		(rs.getString("cancel_dt")		==null?"":rs.getString("cancel_dt"));
				base.setEnd_dt			(rs.getString("end_dt")			==null?"":rs.getString("end_dt"));
				base.setReject_cau		(rs.getString("reject_cau")		==null?"":rs.getString("reject_cau"));
				base.setFile_name1		(rs.getString("file_name1")		==null?"":rs.getString("file_name1"));
				base.setFile_name2		(rs.getString("file_name2")		==null?"":rs.getString("file_name2"));
				base.setFile_name3		(rs.getString("file_name3")		==null?"":rs.getString("file_name3"));
				base.setFile_name4		(rs.getString("file_name4")		==null?"":rs.getString("file_name4"));
				base.setFile_gubun1		(rs.getString("file_gubun1")	==null?"":rs.getString("file_gubun1"));
				base.setFile_gubun2		(rs.getString("file_gubun2")	==null?"":rs.getString("file_gubun2"));
				base.setFile_gubun3		(rs.getString("file_gubun3")	==null?"":rs.getString("file_gubun3"));
				base.setFile_gubun4		(rs.getString("file_gubun4")	==null?"":rs.getString("file_gubun4"));
				base.setBad_yn			(rs.getString("bad_yn")			==null?"":rs.getString("bad_yn"));
				base.setId_cng_req_dt	(rs.getString("id_cng_req_dt")	==null?"":rs.getString("id_cng_req_dt"));
				base.setId_cng_dt  		(rs.getString("id_cng_dt")		==null?"":rs.getString("id_cng_dt"));
				base.setPol_place		(rs.getString("pol_place")		==null?"":rs.getString("pol_place"));	//관할 경찰서 추가 
				
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[SettleDatabase:getBadComplaintReq]\n"+e);

	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return base;
		}
	}

	//고소장접수요청 고객별 등록리스트
	public Vector getBadComplaintReqDocList(String client_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select * from BAD_COMPLAINT_REQ where client_id=? order by seq desc";

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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[SettleDatabase:getBadComplaintReqDocList]\n"+e);
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

	//고소장접수요청 메인
	public boolean insertBadComplaintReq(BadComplaintReqBean base)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;

		String query =  " insert into BAD_COMPLAINT_REQ "+
						" ( client_id, seq, bad_cau, reg_id, reg_dt ) values "+
						" ( ?, ?, ?, ?, to_char(sysdate,'YYYYMMDD') )";


		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, base.getClient_id	());
			pstmt.setInt   (2, base.getSeq			());
			pstmt.setString(3, base.getBad_cau		());
			pstmt.setString(4, base.getReg_id		());
														
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[SettleDatabase:insertBadComplaintReq]\n"+e);
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

	//고소장접수요청 아이템 리스트 등록
	public boolean insertBadComplaintReqItem(BadComplaintReqBean base)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;

		String query =  " insert into BAD_COMPLAINT_REQ_LIST "+
						" ( bad_comp_cd, seq, rent_mng_id, rent_l_cd, a_fee_tm, fee_tm, fee_est_dt, dly_mon, etc, "+
						"   t_rent_start_dt, t_rent_end_dt, t_con_mon, add_rent_start_dt, add_rent_end_dt, add_tm, credit_doc_id, dly_fee_amt ) values "+
						" ( ?, ?, ?, ?, ?, ?, replace(?, '-', ''), ?, ?, "+
						"   replace(?, '-', ''), replace(?, '-', ''), ?, replace(?, '-', ''), replace(?, '-', ''), ?, ?, ? )";


		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1 , base.getBad_comp_cd			());
			pstmt.setInt   (2 , base.getSeq					());
			pstmt.setString(3 , base.getRent_mng_id			());
			pstmt.setString(4,  base.getRent_l_cd			());
			pstmt.setString(5,  base.getA_fee_tm			());
			pstmt.setString(6,  base.getFee_tm				());
			pstmt.setString(7,  base.getFee_est_dt			());
			pstmt.setString(8,  base.getDly_mon				());
			pstmt.setString(9,  base.getEtc					());
			pstmt.setString(10, base.getT_rent_start_dt		());
			pstmt.setString(11, base.getT_rent_end_dt		());
			pstmt.setString(12, base.getT_con_mon			());
			pstmt.setString(13, base.getAdd_rent_start_dt	());
			pstmt.setString(14, base.getAdd_rent_end_dt		());
			pstmt.setString(15, base.getAdd_tm				());
			pstmt.setString(16, base.getCredit_doc_id		());
			pstmt.setInt   (17, base.getDly_fee_amt			());
														
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[SettleDatabase:insertBadComplaintReqItem]\n"+e);
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

	//고소장접수요청
	public boolean updateBadComplaintReq(BadComplaintReqBean base)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;

		String query =  " update BAD_COMPLAINT_REQ set "+
						"		 bad_cau=?, bad_st=?, bad_yn=?, reject_cau=?, req_dt=replace(?, '-', ''), car_call_yn=?, id_cng_req_dt=replace(?, '-', ''), id_cng_dt=replace(?, '-', ''), pol_place=? "+
						" where  client_id=? and seq=? ";


		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, base.getBad_cau			());
			pstmt.setString(2, base.getBad_st			());
			pstmt.setString(3, base.getBad_yn			());
			pstmt.setString(4, base.getReject_cau		());
			pstmt.setString(5, base.getReq_dt			());
			pstmt.setString(6, base.getCar_call_yn		());
			pstmt.setString(7, base.getId_cng_req_dt	());
			pstmt.setString(8, base.getId_cng_dt		());
			pstmt.setString(9, base.getPol_place		());	//관할 경찰서 추가
			pstmt.setString(10, base.getClient_id		());
			pstmt.setInt   (11,base.getSeq				());
														
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[SettleDatabase:updateBadComplaintReq]\n"+e);
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

	//고소장접수요청 아이템 리스트 등록
	public boolean updateBadComplaintReqItem(BadComplaintReqBean base)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;

		String query =  " update BAD_COMPLAINT_REQ_LIST set "+
						"		 a_fee_tm=?, fee_tm=?, fee_est_dt=replace(?, '-', ''), dly_mon=?, "+
						"        t_rent_start_dt=replace(?, '-', ''), t_rent_end_dt=replace(?, '-', ''), t_con_mon=?, "+
						"        add_rent_start_dt=replace(?, '-', ''), add_rent_end_dt=replace(?, '-', ''), add_tm=?, credit_doc_id=?, dly_fee_amt=? "+
						" where  bad_comp_cd=? and seq=? ";


		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1,  base.getA_fee_tm			());
			pstmt.setString(2,  base.getFee_tm				());
			pstmt.setString(3,  base.getFee_est_dt			());
			pstmt.setString(4,  base.getDly_mon				());
			pstmt.setString(5,  base.getT_rent_start_dt		());
			pstmt.setString(6,  base.getT_rent_end_dt		());
			pstmt.setString(7,  base.getT_con_mon			());
			pstmt.setString(8,  base.getAdd_rent_start_dt	());
			pstmt.setString(9,  base.getAdd_rent_end_dt		());
			pstmt.setString(10, base.getAdd_tm				());
			pstmt.setString(11, base.getCredit_doc_id		());
			pstmt.setInt   (12, base.getDly_fee_amt			());
			pstmt.setString(13, base.getBad_comp_cd			());
			pstmt.setInt   (14, base.getSeq					());
														
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[SettleDatabase:updateBadComplaintReqItem]\n"+e);
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


	//고소장접수요청
	public boolean deleteBadComplaintReq(BadComplaintReqBean base)
	{
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		boolean flag = true;

		String query =  " delete from BAD_COMPLAINT_REQ "+
						" where  client_id=? and seq=? ";

		String query2 =  " delete from BAD_COMPLAINT_REQ_LIST "+
						" where  bad_comp_cd=? ";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, base.getClient_id		());
			pstmt.setInt   (2, base.getSeq				());														
		    pstmt.executeUpdate();
			pstmt.close();

			pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString(1, base.getClient_id()+""+String.valueOf(base.getSeq()));
		    pstmt2.executeUpdate();
			pstmt2.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[SettleDatabase:deleteBadComplaintReq]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				if(pstmt != null)	pstmt.close();
				if(pstmt2 != null)	pstmt2.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	/**
	 *	미수금현황 리스트- 영업부 채권캠페인 받을어음 변수(1억5천)에 따라 캠페인대상조절.-> 부산지점은 넘기기 직전 받을어음 : 적용
	 *	2006.08.02. jhm
	 */
	public Vector getStatSettleEff(String lost_st, String save_dt, String max_amt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = " select a.*, b.user_nm, (a.avg_per-a.per1) eff_per, c.user_nm as partner_nm "+
				" from   stat_settle a, users b, users c "+
				" where  a.save_dt='"+save_dt+"' and a.bus_id2=b.user_id and a.partner_id=c.user_id(+) ";

		if(!max_amt.equals("") && !max_amt.equals("0")){
			query += " and a.tot_amt >= "+AddUtil.replace(max_amt,",","");
		}

		if(!lost_st.equals(""))								query += " and b.loan_st='"+lost_st+"'";

		query += " order by (a.avg_per-a.per1) desc, a.per1 asc";

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
			System.out.println("[SettleDatabase:getStatSettleEff]"+e);
			System.out.println("[SettleDatabase:getStatSettleEff]"+query);
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
	 *	미수금현황 리스트- 영업부 채권캠페인 받을어음 변수(1억5천)에 따라 캠페인대상조절.-> 부산지점은 넘기기 직전 받을어음 : 적용
	 *	2006.08.02. jhm
	 */
	public Vector getStatSettleEff(String lost_st, String var6, String save_dt, String max_amt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		

		//20141020 
		query = " SELECT a.bus_id2, c.user_nm, trunc(AVG(NVL(d.amt2,0)-a.per1),3) eff_per "+
                " FROM   STAT_SETTLE a, USERS c, (SELECT user_id, amt2 FROM STAT_CMP WHERE save_dt='"+var6+"' AND amt2<>0 AND gubun='1') d "+
                " WHERE  a.save_dt between REPLACE('"+var6+"','-','') and REPLACE('"+save_dt+"','-','') "+
                "        AND a.bus_id2=c.user_id "+
				"        AND c.use_yn='Y' "+
                "        AND a.bus_id2=d.user_id(+) ";

		if(!max_amt.equals("") && !max_amt.equals("0")){
			query += " and a.tot_amt >= "+AddUtil.replace(max_amt,",","");
		}

		if(!lost_st.equals(""))								query += " and c.loan_st='"+lost_st+"'";

		query += " GROUP BY a.bus_id2, c.user_nm  "+        
                 " ORDER BY trunc(AVG(NVL(d.amt2,0)-a.per1),3) desc";

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
			System.out.println("[SettleDatabase:getStatSettleEff(String lost_st, String var6, String save_dt, String max_amt)]"+e);
			System.out.println("[SettleDatabase:getStatSettleEff(String lost_st, String var6, String save_dt, String max_amt)]"+query);
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
	 *	미수금현황 리스트- 영업부 채권캠페인 받을어음 변수(1억5천)에 따라 캠페인대상조절.-> 부산지점은 넘기기 직전 받을어음 : 적용
	 *	2006.08.02. jhm
	 */
	public Vector getStatSettleEffIn(String lost_st, String save_dt, String max_amt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		

		query = " select a.*, b.user_nm, trunc((a.eff_per1*0.8)+(a.eff_per2*0.2),3) rc_eff_per,   c.user_nm as partner_nm "+
				" from   stat_settle a, users b, users c "+
				" where  a.save_dt='"+save_dt+"' and a.bus_id2=b.user_id and a.partner_id=c.user_id ";

		if(!max_amt.equals("") && !max_amt.equals("0")){
			query += " and a.tot_amt >= "+AddUtil.replace(max_amt,",","");
		}

		if(!lost_st.equals(""))								query += " and b.loan_st='"+lost_st+"'";

		query += " order by a.cmp_per asc ,  trunc((a.eff_per1*0.8)+(a.eff_per2*0.2),3) desc";
	
		
		
		//  적용연체율 30%, 변동치 70적용건 
/*
		 
		query = "select a.*, b.user_nm, trunc(((a.eff_per1*0.8)+(a.eff_per2*0.2)*0.7) +(a.cmp_per*0.3),3)  rc_eff_per,   c.user_nm as partner_nm"+
				" from   stat_settle a, users b, users c "+
				" where  a.save_dt='"+save_dt+"' and a.bus_id2=b.user_id and a.partner_id=c.user_id ";

		if(!max_amt.equals("") && !max_amt.equals("0")){
			query += " and a.tot_amt >= "+AddUtil.replace(max_amt,",","");
		}

		if(!lost_st.equals(""))								query += " and b.loan_st='"+lost_st+"'";

		query += " order by trunc(((a.eff_per1*0.8)+(a.eff_per2*0.2)*0.7) +(a.cmp_per*0.3),3) desc";
		*/

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
			System.out.println("[SettleDatabase:getStatSettleEffIn]"+e);
			System.out.println("[SettleDatabase:getStatSettleEffIn]"+query);
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

	 /* sort: 1: 연체율 , 2:적용감소치 ,3: 포상금액) */
	public Vector getStatSettleEffIn(String lost_st, String save_dt, String max_amt, String sort)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		

		query = " select a.*, b.user_nm, trunc((a.eff_per1*0.8)+(a.eff_per2*0.2),4) rc_eff_per,   c.user_nm as partner_nm "+
				" from   stat_settle a, users b, users c "+
				" where  a.save_dt='"+save_dt+"' and a.bus_id2=b.user_id and a.partner_id=c.user_id ";

		if(!max_amt.equals("") && !max_amt.equals("0")){
			query += " and a.tot_amt >= "+AddUtil.replace(max_amt,",","");
		}

		if(!lost_st.equals(""))								query += " and b.loan_st='"+lost_st+"'";

		if ( sort.equals("1")) {
			query += " order by a.r_cmp_per asc ,  trunc((a.eff_per1*0.8)+(a.eff_per2*0.2),4) desc";
		} else if ( sort.equals("2")) {
			query += " order by  trunc((a.eff_per1*0.8)+(a.eff_per2*0.2),4) desc";
		} else {
			query += " order by a.amt_in desc , a.r_cmp_per asc  ";
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
			System.out.println("[SettleDatabase:getStatSettleEffIn]"+e);
			System.out.println("[SettleDatabase:getStatSettleEffIn]"+query);
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
	 *	채권캠페인-영업사원
	 */
	public Vector getStatSettleEmp(String save_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
	
		query = " select a.*, c.emp_id, c.emp_nm, decode(c.agent_id,'','영업사원','에이전트') br_id, DECODE(c.agent_id,'',b.car_off_nm,d.car_off_nm) dept_id, d.work_st  "+
				" from   stat_settle a, car_off_emp c, car_off b, car_off d "+
				" where  a.save_dt='"+save_dt+"' and substr(a.bus_id2,1,1)='E' and substr(a.bus_id2,2)=c.emp_id and c.car_off_id=b.car_off_id and c.agent_id=d.car_off_id(+) "+

				" ";		

		query += " order by decode(c.agent_id,'','2','1'), to_number(a.r_cmp_per), to_number(a.cmp_per), a.amt, (a.per1+a.avg_per), a.tot_amt desc ";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			while(rs.next())
			{
				IncomingSBean fee = new IncomingSBean();				
				
				fee.setGubun(rs.getString("emp_id"));
				fee.setBr_id(rs.getString("br_id"));
				fee.setDept_id(rs.getString("dept_id"));

				fee.setTot_amt1(rs.getString("tot_amt"));
				fee.setTot_amt2(rs.getString("amt"));
				fee.setTot_amt3(rs.getString("three_amt")==null?"0":rs.getString("three_amt"));
				fee.setTot_amt4(rs.getString("amt_out")==null?"0":rs.getString("amt_out"));
				fee.setTot_amt5(rs.getString("amt_in")==null?"0":rs.getString("amt_in"));
				fee.setTot_amt6(rs.getString("eff_amt_out")==null?"0":rs.getString("eff_amt_out"));
				fee.setTot_amt7(rs.getString("eff_amt_in")==null?"0":rs.getString("eff_amt_in"));

				fee.setTot_su2(rs.getString("su"));				
				fee.setTot_su3(rs.getString("per1"));			
				fee.setTot_su4(rs.getString("per2")==null?"":rs.getString("per2"));
//				fee.setTot_su5(rs.getString("per_0405")==null?"":rs.getString("per_0405"));
				fee.setTot_su6(rs.getString("avg_per")==null?"":rs.getString("avg_per"));
				fee.setTot_su7(rs.getString("cmp_per")==null?"":rs.getString("cmp_per"));
				fee.setTot_su8(rs.getString("r_cmp_per")==null?"":rs.getString("r_cmp_per"));
//				fee.setTot_su9(rs.getString("eff_per")==null?"":rs.getString("eff_per"));   //20140714 추가 연체율감소치
				
//				fee.setPartner_id(rs.getString("partner_id2")==null?"":rs.getString("partner_id2"));
//				fee.setPartner_nm(rs.getString("partner_nm")==null?"":rs.getString("partner_nm"));
				fee.setReg_dt(rs.getString("reg_dt")==null?"":rs.getString("reg_dt"));

				if(fee.getTot_su3().equals("0")) fee.setTot_su3("0.000");
				if(fee.getTot_su4().equals("0")) fee.setTot_su4("0.000");
				if(fee.getTot_su6().equals("0")) fee.setTot_su6("0.000");
				if(fee.getTot_su7().equals("0")) fee.setTot_su7("0.000");
				if(fee.getTot_su8().equals("0")) fee.setTot_su8("0.000");
				if(fee.getTot_su9().equals("0")) fee.setTot_su8("0.000");

				fee.setGubun_sub(rs.getString("work_st")==null?"":rs.getString("work_st"));

				vt.add(fee);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[SettleDatabase:getStatSettleEmp]"+e);
			System.out.println("[SettleDatabase:getStatSettleEmp]"+query);
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

	//채권관리캠페인 담당자별 세부리스트 :: 영업사원 20150225
	public Vector getStatSettleSubList3Gun(String bus_id2)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		int settle_mon = 12; //채권반영개월수



		query = " select \n"+
				"        a.*, b.car_no, b.car_nm, c.firm_nm, d.user_nm, e.cms_bank, f.cls_dt, "+
				"        decode(g.cbit,'1','신규','2','승인','3','해지신청','4','해지완료','7','임의해지','8','신고에러') cbit, g.ldate, nvl(p.promise_dt,'') promise_dt \n"+
				" from \n"+
				" ( \n"+
				"	 select '1' sort, '선수금' gubun1, decode(a.ext_st,'0','보증금','1','선납금','2','개시대여료', '5', '승계수수료') gubun2, \n"+
				"           a.rent_mng_id, a.rent_l_cd, c.car_mng_id, c.client_id, decode(a.ext_st,'5',NVL(b.ext_agnt,c.bus_id2),decode(b.rent_st,'1',decode(e.rent_l_cd,'',c.bus_id,c.bus_id2),c.bus_id2)) bus_id2, c.bus_id, \n"+
				"           decode(a.ext_st, '5', nvl(d.rent_suc_dt,b.rent_start_dt), nvl(d.rent_suc_dt,b.rent_start_dt)) as est_dt, "+
				"           (a.ext_s_amt+a.ext_v_amt) dly_amt, 0 dly_amt2, c.use_yn, c.rent_start_dt \n"+
				"	 from   scd_ext a, fee b, cont c, cont_etc d, (select * from cls_cont where cls_st in ('4','5')) e, (select * from commi where agnt_st='1') f \n"+
				"    where  a.ext_st in ('0', '1', '2', '5' ) \n"+
				"          and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st \n"+
                "          and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd \n"+
				"          and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and f.emp_id='"+bus_id2+"' \n"+
				"          and a.rent_mng_id = d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+)"+
				"          and c.rent_mng_id=e.rent_mng_id(+) and c.reg_dt=e.reg_dt(+) "+
				"          and a.ext_s_amt>0 and a.ext_pay_dt is null and nvl(a.bill_yn,'Y')='Y' \n"+
				"          and decode(a.ext_st,'5',nvl(d.rent_suc_dt,a.ext_est_dt), \n"+//승계수수료
                "                     decode(c.rent_st||b.rent_st||b.grt_suc_yn||a.ext_st,'3100', \n"+//--대차승계보증금
                "                            decode(a.gubun,'E',a.ext_est_dt, \n"+
                "                                   to_char(to_date(nvl(b.rent_start_dt,to_char(sysdate,'YYYYMMDD')),'YYYYMMDD')+15,'YYYYMMDD') \n"+
                "                            ), \n"+
				"                            case when d.rent_suc_dt is not null and d.rent_suc_dt > b.rent_start_dt then d.rent_suc_dt \n"+
                "                                                             WHEN d.rent_suc_dt IS NULL AND a.ext_st='5' THEN a.ext_est_dt  \n"+ 
                "                                                             else b.rent_start_dt end \n"+
                "                     ) \n"+
                "              ) < to_char(sysdate,'YYYYMMDD') \n"+
				"	       AND TO_CHAR(ADD_MONTHS(sysdate,-"+settle_mon+"),'YYYYMMDD') < nvl(c.rent_start_dt,to_char(sysdate,'YYYYMMDD')) \n"+

				"	 union all		 \n"+

				"    select '2' sort, '대여료' gubun1, a.fee_tm||'회'||decode(a.tm_st1,'0','','(잔액)') gubun2, \n"+
				"          a.rent_mng_id, a.rent_l_cd, b.car_mng_id, b.client_id, DECODE(b.car_st,'4',b.mng_id,b.bus_id2) bus_id2, CASE WHEN e.rent_l_cd IS NOT NULL AND e.rent_suc_dt > d.rent_dt THEN NVL(d.ext_agnt,b.bus_id) ELSE b.bus_id end as bus_id, \n"+
				"          a.r_fee_est_dt as est_dt, \n"+
				"          (a.fee_s_amt+a.fee_v_amt) dly_amt, 0 dly_amt2, b.use_yn, b.rent_start_dt \n"+
				"    from  scd_fee a, cont b, FEE d, CONT_ETC e, (select * from commi where agnt_st='1') f \n"+
				"    where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd "+
                "          and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd \n"+
				"	       and f.emp_id='"+bus_id2+"' \n"+
				"          and a.fee_s_amt>0 and a.rc_dt is null and nvl(a.bill_yn,'Y')='Y' and a.tm_st2<>'4' \n"+
				"          and a.r_fee_est_dt < to_char(sysdate,'YYYYMMDD')            \n"+
				"	       AND TO_CHAR(ADD_MONTHS(sysdate,-"+settle_mon+"),'YYYYMMDD') < nvl(b.rent_start_dt,to_char(sysdate,'YYYYMMDD')) \n"+
                "          AND a.rent_mng_id=d.rent_mng_id AND a.rent_l_cd=d.rent_l_cd AND a.rent_st=d.rent_st \n"+
                "          AND b.rent_mng_id=e.rent_mng_id AND b.rent_l_cd=e.rent_l_cd \n"+


				"    union all \n"+

				"    select '3' sort, '과태료' gubun1, substr(a.vio_dt,1,8)||' '||a.vio_cont||'-'||decode(a.fault_st,'1','고객과실','업무상과실') as gubun2, \n"+
				"           a.rent_mng_id, a.rent_l_cd, b.car_mng_id, \n"+
				"           decode(c.rent_s_cd,'',b.client_id, decode(c.cust_st, '4', '000228',  c.cust_id)  ) client_id, \n"+ //업무대여인건 client_id : 아마존카로 처리 -
				"           decode(a.rent_s_cd,'',decode(a.fault_st,'2',nvl(a.fault_nm,b.bus_id2),b.bus_id2), decode(c.rent_st,'1',c.bus_id,'9',c.bus_id,'12',nvl(c.mng_id,c.bus_id), '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id,c.bus_id)) bus_id2, \n"+
				"           b.bus_id, \n"+
				"           nvl(a.rec_plan_dt,nvl(a.dem_dt,a.paid_end_dt)) as est_dt, \n"+
				"           a.paid_amt as dly_amt, 0 dly_amt2, decode(c.rent_s_cd,'',b.use_yn,d.use_yn) use_yn, b.rent_start_dt \n"+
				"    from   fine a, cont b, rent_cont c, cont d, (select * from commi where agnt_st='1') f \n"+
				"    where  a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
                "           and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd and f.emp_id='"+bus_id2+"' \n"+
				"           and a.rent_s_cd=c.rent_s_cd(+)  AND NVL(c.use_st,'0')<>'5' \n"+
				"           and c.sub_l_cd=d.rent_l_cd(+) \n"+
				"           and a.paid_amt>0 and a.coll_dt is null and decode(a.fault_st,'2', 'Y', '3', 'N', nvl(a.bill_yn,'Y'))='Y' \n"+
				"           and a.paid_st in ('3','4') and nvl(a.no_paid_yn,'N')='N' \n"+
				"           and ( (a.vio_cont not like  '%통행료%'and a.vio_cont not like  '%주차요금%') or  ( a.vio_cont like  '%통행료%' and a.proxy_dt is not null ) or ( a.vio_cont like  '%주차요금%' and a.proxy_dt is not null )  )"+
				"           and nvl(a.rec_plan_dt,nvl(a.dem_dt,a.paid_end_dt)) < to_char(sysdate,'YYYYMMDD') \n"+
				"	        AND TO_CHAR(ADD_MONTHS(sysdate,-"+settle_mon+"),'YYYYMMDD') < nvl(b.rent_start_dt,to_char(sysdate,'YYYYMMDD')) \n"+

				"	 union all \n"+

				"    select '4' sort, '면책금' gubun1, a.serv_dt||' '||decode(e.accid_st,'1','피해','2','가해','3','쌍방','4','운행자차','5','사고자차', '8', '단독') gubun2, \n"+
				"           a.rent_mng_id, a.rent_l_cd, a.car_mng_id, \n"+
				"           decode(e.rent_s_cd,'',b.client_id,d.client_id) client_id, \n"+
				"           decode(e.rent_s_cd,'',b.bus_id2, decode(c.rent_st,'1',c.bus_id,'9',c.bus_id,'12',nvl(c.mng_id,c.bus_id), '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) bus_id2, \n"+
				"           b.bus_id, \n"+
				"           nvl(se.ext_est_dt, a.cust_plan_dt) as est_dt, \n"+
				"           (se.ext_s_amt+se.ext_v_amt) as dly_amt, 0 dly_amt2, decode(e.rent_s_cd,'',b.use_yn,d.use_yn) use_yn, decode(e.rent_s_cd,'',b.rent_start_dt,d.rent_start_dt) rent_start_dt \n"+
				"    from   scd_ext se, service a, accident e, cont b, rent_cont c, cont d, (select * from commi where agnt_st='1') f \n"+
				"    where  se.ext_st = '3' \n"+
				"           and se.rent_mng_id = a.rent_mng_id and se.rent_l_cd = a.rent_l_cd and se.ext_id = a.serv_id \n"+
				"           and a.car_mng_id=e.car_mng_id and a.accid_id=e.accid_id \n"+
                "           and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd and f.emp_id='"+bus_id2+"' \n"+
				"           and se.rent_mng_id=b.rent_mng_id and se.rent_l_cd=b.rent_l_cd \n"+
				"           and e.rent_s_cd=c.rent_s_cd(+) \n"+
				"           and c.sub_l_cd=d.rent_l_cd(+) \n"+
				"           and se.ext_s_amt>0 and se.ext_pay_dt is null and nvl(se.bill_yn,'Y')='Y' \n"+
				"           and nvl(a.no_dft_yn,'N')='N' \n"+
				"           and e.car_mng_id||e.accid_id not in ('005938014279')  \n"+  //두바이카 정보제공은 면책금에서 제외
				"           and nvl(se.ext_est_dt, a.cust_plan_dt) < to_char(sysdate,'YYYYMMDD') \n"+
				"	        AND TO_CHAR(ADD_MONTHS(sysdate,-"+settle_mon+"),'YYYYMMDD') < nvl(b.rent_start_dt,to_char(sysdate,'YYYYMMDD')) \n"+

				"	 union all \n"+

				"    select '5' sort, '위약금' gubun1, decode(b.cls_st,'1','계약만료','2','중도해지') gubun2, \n"+
				"           a.rent_mng_id, a.rent_l_cd, c.car_mng_id, c.client_id, c.bus_id2, c.bus_id, \n"+
				"           b.cls_dt as est_dt, \n"+
				"           (a.ext_s_amt+a.ext_v_amt) as dly_amt, 0 dly_amt2, c.use_yn, c.rent_start_dt \n"+
				"    from   scd_ext a, cls_cont b, cont c, (select * from commi where agnt_st='1') f \n"+
				"    where  a.ext_st = '4' \n"+
				"           and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
                "           and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd and f.emp_id='"+bus_id2+"' \n"+
				"           and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"+
				"           and DECODE(c.car_st,'4',case when b.fdft_amt2 < 0 then 0 else a.ext_s_amt+a.ext_v_amt end,(a.ext_s_amt+a.ext_v_amt)) >0 and a.ext_pay_dt is null and nvl(a.bill_yn,'Y')='Y' \n"+
				"           and nvl(b.cls_doc_yn,'Y')='Y' \n"+
				"           and b.cls_dt < to_char(sysdate,'YYYYMMDD') \n"+
				"	        AND TO_CHAR(ADD_MONTHS(sysdate,-"+settle_mon+"),'YYYYMMDD') < nvl(c.rent_start_dt,to_char(sysdate,'YYYYMMDD')) \n"+  
				"	        AND TO_CHAR(ADD_MONTHS(sysdate,-3),'YYYYMMDD') < nvl(b.cls_dt,to_char(sysdate,'YYYYMMDD')) \n"+  //--> 20140725 2군 위약금은 해지일기준 3개월 적용
                "           AND DECODE(c.car_st||c.mng_id,'4000126','N','Y')='Y' \n"+ //--월렌트이면서 관리담당자가 장혁준일때는 제외

				"    union all \n"+

				"    select '9' sort, '연체이자' gubun1, '-' gubun2, \n"+
				"          c.rent_mng_id, c.rent_l_cd, c.car_mng_id, c.client_id, DECODE(c.car_st,'4',c.mng_id,c.bus_id2) bus_id2, CASE WHEN e.rent_l_cd IS NOT NULL AND e.rent_suc_dt > d.rent_dt THEN NVL(d.ext_agnt,c.bus_id) ELSE c.bus_id end bus_id, \n"+
				"          '' as est_dt, \n"+
				"          nvl(a.dly_fee,0)-nvl(b.pay_amt,0) dly_amt, 0 dly_amt2, c.use_yn, c.rent_start_dt \n"+
				"    from  (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, sum(dly_fee) dly_fee from scd_fee where rent_l_cd not like 'RM%' and tm_st2<>'4' group by rent_mng_id, rent_l_cd) a, "+
				"	       (select rent_mng_id, rent_l_cd, sum(pay_amt) pay_amt from scd_dly where rent_l_cd not like 'RM%' group by rent_mng_id, rent_l_cd) b, "+
				"	       cont c, FEE d, CONT_ETC e, (select * from commi where agnt_st='1') f, \n"+
                "          (SELECT * FROM CLS_CONT WHERE cls_dt>'20091231' AND cls_st IN ('4','5')) g \n"+
				"    where a.rent_mng_id=b.rent_mng_id(+) and a.rent_l_cd=b.rent_l_cd(+) "+ 
				"          and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"+
				"          and nvl(a.dly_fee,0)-nvl(b.pay_amt,0)<>0 AND c.rent_l_cd not like 'RM%' \n"+
				"	       AND TO_CHAR(ADD_MONTHS(sysdate,-"+settle_mon+"),'YYYYMMDD') < nvl(c.rent_start_dt,to_char(sysdate,'YYYYMMDD')) \n"+
                "          AND a.rent_mng_id=d.rent_mng_id AND a.rent_l_cd=d.rent_l_cd AND a.rent_st=d.rent_st \n"+
                "          AND c.rent_mng_id=e.rent_mng_id AND c.rent_l_cd=e.rent_l_cd \n"+
                "          and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd and f.emp_id='"+bus_id2+"' \n"+
                "          AND c.rent_mng_id=g.rent_mng_id(+) AND c.rent_l_cd=g.rent_l_cd(+) and DECODE(g.cls_st,'4','Y','5','Y',c.use_yn)='Y' \n"+

				" ) a, car_reg b, client c, users d, "+
				"   	cms_mng e, cls_cont f, (select rent_mng_id, rent_l_cd, max(seq) seq from cms_mng group by rent_mng_id, rent_l_cd) h, cust g, \n"+
//                "       (select rent_mng_id, rent_l_cd, max(promise_dt) promise_dt from dly_mm where promise_dt is not null group by rent_mng_id, rent_l_cd) p \n"+ 
				 " (select a.rent_mng_id, a.rent_l_cd, a.promise_dt \n"+
				 "	from   DLY_MM a,  \n"+
				 "         (SELECT /*+ index(DLY_MM, DLY_MM_PK) */ rent_mng_id, rent_l_cd, max(reg_dt||reg_dt_time||seq) KEEP( DENSE_RANK FIRST ORDER BY rent_mng_id, rent_l_cd, reg_dt||reg_dt_time||seq DESC) AS seq \n"+
				 "          FROM   DLY_MM GROUP BY rent_mng_id, rent_l_cd ) b  \n"+
				 "  where  a.rent_mng_id = b.rent_mng_id \n"+
				 "         AND a.rent_l_cd = b.rent_l_cd  \n"+
				 "         AND a.reg_dt||a.reg_dt_time||a.seq = b.seq) p \n"+
				" where a.car_mng_id=b.car_mng_id(+) and a.client_id=c.client_id(+) and a.bus_id2=d.user_id and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+)\n"+
				"       and a.rent_mng_id=f.rent_mng_id(+) and a.rent_l_cd=f.rent_l_cd(+) "+
				"	    and e.rent_mng_id=h.rent_mng_id(+) and e.rent_l_cd=h.rent_l_cd(+) and e.seq=h.seq(+) and e.rent_l_cd=g.code(+) "+
				"       and a.rent_mng_id=p.rent_mng_id(+) and a.rent_l_cd=p.rent_l_cd(+) "+
				" order by a.sort, a.use_yn, a.client_id, a.car_mng_id, a.est_dt "+
				" ";


		 
		try {
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
			System.out.println("[SettleDatabase:getStatSettleSubList3Gun]\n"+e);
			System.out.println("[SettleDatabase:getStatSettleSubList3Gun]\n"+query);
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


    /****************************************************************************************
	*******************************************   smart
    ****************************************************************************************/



		/**
	 *	선수금 수금관리
	 */
	public Vector getGrtList2(String gubun3, String gubun4, String s_kd, String t_wd, String s_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select  "+
				"        b.use_yn, a.rent_mng_id, a.rent_l_cd, b.car_mng_id, a.rent_st, "+
				"        decode(a.ext_st, '0','보증금','1','선납금','2','개시대여료','5','승계수수료') gubun,"+
				"        decode(a.rent_st, '1','','2','(연)') rent_st_nm, a.ext_st, a.ext_tm, "+
				"        decode(a.ext_pay_dt, '',nvl(a.ext_s_amt,0)+nvl(a.ext_v_amt,0), nvl(a.ext_pay_amt,0)) ext_amt,"+
				"        nvl(a.ext_s_amt,0)+nvl(a.ext_v_amt,0) ext_est_amt, a.ext_pay_amt, "+
				"        a.ext_pay_amt, b.firm_nm, b.client_nm, b.rent_way,"+
				"        b.con_mon, a.ext_s_amt, a.ext_v_amt, b.rent_dt, b.rent_start_dt,"+
				"        decode(nvl(a.ext_EST_DT,a.ext_pay_dt), '', '', substr(nvl(a.ext_EST_DT,a.ext_pay_dt), 1, 4) || '-' || substr(nvl(a.ext_EST_DT,a.ext_pay_dt), 5, 2) || '-'||substr(nvl(a.ext_EST_DT,a.ext_pay_dt), 7, 2)) EXT_EST_DT,"+
				"        decode(a.EXT_PAY_DT, '', '', substr(a.EXT_PAY_DT, 1, 4) || '-' || substr(a.ext_PAY_DT, 5, 2) || '-'||substr(a.ext_PAY_DT, 7, 2)) EXT_PAY_DT, c.rent_suc_dt"+
				" from   scd_ext a, cont_n_view b, cont_etc c "+
				" where  "+
				" ";

		if(s_kd.equals("1"))		query += " a.rent_l_cd='"+t_wd+"'\n";

		if(!gubun4.equals(""))		query += " and a.ext_st='"+gubun4+"'";

		if(!s_cd.equals(""))		query += " and a.rent_st||a.rent_seq||a.ext_st||a.ext_id ='"+s_cd+"'";

		query += " and a.ext_st in ('0', '1', '2','5') and a.rent_mng_id=b.rent_mng_id(+) and a.rent_l_cd=b.rent_l_cd(+) and nvl(a.ext_s_amt,0) <> 0 and nvl(a.bill_yn,'Y')='Y' and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+)\n";


		if(gubun3.equals("1"))		query += " and a.ext_pay_dt is not null \n"; //수금
		else if(gubun3.equals("2"))	query += " and a.ext_pay_dt is null \n"; //미수금


		query += " order by a.rent_st, a.ext_st, a.ext_tm";

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
			System.out.println("[SettleDatabase:getGrtList2]\n"+e);
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
	 *	과태료 수금관리
	 */
	public Vector getFineList(String gubun3, String gubun4, String s_kd, String t_wd, String s_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		String standard_dt = "decode(a.rec_plan_dt, '',decode(a.dem_dt, '',a.paid_end_dt, a.dem_dt), a.rec_plan_dt)";
		String s_query = "";
		if(s_kd.equals("17")){
			s_query = " , (select user_id, user_nm from users where user_nm like '"+t_wd+"%') k";
		}

		query = " select  \n"+
				"        a.car_mng_id, a.seq_no, a.rent_mng_id, a.rent_l_cd, nvl(b.firm_nm, b.client_nm) firm_nm, b.client_nm, '' scan_file,\n"+
				"        cr.car_no, cr.first_car_no, cr.car_nm, cn.car_name, decode(a.coll_dt, '','미수금','수금') gubun,\n"+
				"        decode(a.fault_st, '1','고객과실', '2','업무상과실', '3', '외부업체과실') fault_st, a.fault_nm, a.vio_pla, a.vio_cont, a.dly_days,\n"+
				"        decode(a.fault_st, '1', a.paid_amt, '2', decode(nvl(a.fault_amt,0), 0, a.paid_amt, a.fault_amt), '3', decode(nvl(a.fault_amt,0), 0, a.paid_amt, a.fault_amt)) paid_amt,"+
				"        b.use_yn, b.mng_id, b.rent_st, decode(a.paid_st, '2','고객납입','3','회사대납','1','납부자변경','4','수금납입','미정') paid_st,\n"+
				"        nvl2(a.vio_dt,substr(a.vio_dt,1,4)||'-'||substr(a.vio_dt,5,2)||'-'||substr(a.vio_dt,7,2),'') vio_dt,\n"+
				"        nvl2(a.rec_plan_dt,substr(a.rec_plan_dt,1,4)||'-'||substr(a.rec_plan_dt,5,2)||'-'||substr(a.rec_plan_dt,7,2),'') rec_plan_dt,\n"+
				"        nvl2(a.coll_dt,substr(a.coll_dt,1,4)||'-'||substr(a.coll_dt,5,2)||'-'||substr(a.coll_dt,7,2),'') coll_dt,\n"+
				"        nvl2(a.paid_end_dt,substr(a.paid_end_dt,1,4)||'-'||substr(a.paid_end_dt,5,2)||'-'||substr(a.paid_end_dt,7,2),'') paid_end_dt,\n"+
				"        nvl2(a.proxy_dt,substr(a.proxy_dt,1,4)||'-'||substr(a.proxy_dt,5,2)||'-'||substr(a.proxy_dt,7,2),'') proxy_dt,\n"+
				"        nvl2(a.dem_dt,substr(a.dem_dt,1,4)||'-'||substr(a.dem_dt,5,2)||'-'||substr(a.dem_dt,7,2),'') dem_dt,\n"+
				"        decode(g.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기') res_st,"+
				"        decode(g.cust_st,'1',h.firm_nm, '4',i.user_nm) cust_nm,"+
				"        decode(a.rent_s_cd,'',b.bus_id2,decode(g.rent_st,'2',j.bus_id2,'3',j.bus_id2,'1',g.bus_id,'4',g.cust_id,'5',g.cust_id)) bus_id2, a.mng_id as fine_mng_id"+
				" from   fine a, cont_n_view b, car_reg cr,  car_etc ce, car_nm cn, rent_cont g, client h, users i, cont j "+s_query+" \n"+
				" where\n"+
				" ";

		if(s_kd.equals("1"))		query += " a.rent_l_cd='"+t_wd+"'\n";

		if(!s_cd.equals(""))		query += " and a.seq_no ='"+s_cd+"'";

		query += "       and a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"        and a.rent_s_cd=g.rent_s_cd(+) and g.cust_id=h.client_id(+) and g.cust_id=i.user_id(+) and g.sub_l_cd=j.rent_l_cd(+)  \n"+
				"        and a.paid_amt > 0 and nvl(a.no_paid_yn,'N') <> 'Y' and a.paid_st in ('3','4') and decode(a.fault_st,'2','Y',nvl(a.bill_yn,'Y'))='Y'  \n"+ 
				"	and a.car_mng_id = cr.car_mng_id  and a.rent_mng_id = ce.rent_mng_id(+)  and a.rent_l_cd = ce.rent_l_cd(+)  \n"+
                       		"	and ce.car_id=cn.car_id(+)  and    ce.car_seq=cn.car_seq(+) ";

		if(gubun3.equals("1"))		query += " and a.coll_dt is not null \n"; //수금
		else if(gubun3.equals("2"))	query += " and a.coll_dt is null \n"; //미수금


		query += " order by a.vio_dt";

		
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
			System.out.println("[SettleDatabase:getFineList]\n"+e);
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
	 *	면책금 수금관리
	 */
	public Vector getInsurMList(String gubun3, String gubun4, String s_kd, String t_wd, String s_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		String b_dt = "to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')";
/*
		query = " select  "+
				" a.car_mng_id, a.serv_id, a.accid_id, se.rent_mng_id, se.rent_l_cd,  b.firm_nm, b.client_nm,"+
				" cr.car_no, cr.car_nm, cn.car_name, decode(se.ext_pay_dt, '','미수금','수금') gubun,"+
				" decode(a.serv_st, '1','순회점검', '2','일반수리', '3','보증수리', '4','운행자차', '5','사고자차','7','재리스수리') serv_st, a.off_id, c.off_nm,"+
				" a.rep_amt, a.sup_amt, a.add_amt, a.tot_amt, nvl(se.ext_s_amt, 0)+ nvl(se.ext_v_amt,0) cust_amt, a.serv_dt, b.use_yn, b.mng_id, b.rent_st,"+//b.bus_id2, 
				" nvl2(a.cust_req_dt,substr(a.cust_req_dt,1,4)||'-'||substr(a.cust_req_dt,5,2)||'-'||substr(a.cust_req_dt,7,2),'') cust_req_dt,"+
				" nvl2(se.ext_est_dt,substr(se.ext_est_dt,1,4)||'-'||substr(se.ext_est_dt,5,2)||'-'||substr(se.ext_est_dt,7,2),'') cust_plan_dt,"+
				" nvl2(se.ext_pay_dt,substr(se.ext_pay_dt,1,4)||'-'||substr(se.ext_pay_dt,5,2)||'-'||substr(se.ext_pay_dt,7,2),'') cust_pay_dt,"+
				" decode(g.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기') res_st,"+
				" decode(g.cust_st,'1',h.firm_nm, '4',i.user_nm) cust_nm, se.ext_tm, decode(se.ext_tm,'1','','(잔)') tm_st,"+
				" decode(f.rent_s_cd,'',b.bus_id2,decode(g.rent_st,'2',j.bus_id2,'3',j.bus_id2,'1',g.bus_id,'4',g.cust_id,'5',g.cust_id)) bus_id2,"+
				" TRUNC(NVL(TO_DATE(se.ext_pay_dt, 'YYYYMMDD'), "+b_dt+") - TO_DATE(se.ext_est_dt, 'YYYYMMDD')) as dly_days,"+
				" l.tax_dt as ext_dt, se.seqid, se.ext_pay_amt \n"+
				" from service a, cont_n_view b, serv_off c, accident f, rent_cont g, client h, users i, cont j, scd_ext se,  car_reg cr,  car_etc ce, car_nm cn ,  \n"+
				" (select bb.* from tax_item_list aa, tax bb where aa.item_id=bb.item_id and bb.tax_st='O' and aa.gubun ='7' and bb.m_tax_no is null ) l "+
				"        ( select a.m_tax_no, c.rent_l_cd, c.tm, c.rent_st, c.rent_seq "+
				"          from   tax a, tax b, tax_item_list c "+
				"          where  a.tax_supply=-b.tax_supply and a.gubun ='7'"+
				" 	               and a.m_tax_no=b.tax_no and b.item_id=c.item_id "+
				"        ) o "+
				" where"+
				" ";

		if(s_kd.equals("1"))		query += " a.rent_l_cd='"+t_wd+"'\n";

		if(!s_cd.equals(""))		query += " and se.rent_st||se.rent_seq||se.ext_st||se.ext_id ='"+s_cd+"'";

		query += "		and se.ext_st = '3' and se.rent_mng_id=a.rent_mng_id and se.rent_l_cd= a.rent_l_cd and se.ext_id = a.serv_id and  se.rent_mng_id=b.rent_mng_id and se.rent_l_cd=b.rent_l_cd and a.car_mng_id=b.car_mng_id  "+
				 "		and a.off_id=c.off_id(+)"+
				 "		and a.car_mng_id=f.car_mng_id(+) and a.accid_id=f.accid_id(+) and f.rent_s_cd=g.rent_s_cd(+) and g.cust_id=h.client_id(+) and g.cust_id=i.user_id(+) and g.sub_l_cd=j.rent_l_cd(+)"+
				 "		and a.rent_l_cd=l.rent_l_cd(+) and a.serv_id=l.fee_tm(+) "+
				 "		and a.rent_l_cd=o.rent_l_cd(+) and a.serv_id=o.tm(+) "+
				 "		and decode(nvl(o.m_tax_no,'-'),l.tax_no,'N','Y')='Y' "+
				 "		and nvl(se.ext_s_amt,0) > 0 and nvl(se.bill_yn,'Y')='Y' and nvl(a.no_dft_yn,'N') = 'N'   \n"+
			 	"	and a.car_mng_id = cr.car_mng_id  and a.rent_mng_id = ce.rent_mng_id(+)  and a.rent_l_cd = ce.rent_l_cd(+)  \n"+
                       		"	and ce.car_id=cn.car_id(+)  and    ce.car_seq=cn.car_seq(+) ";
*/

		query = " select  "+
				" a.car_mng_id, a.serv_id, a.accid_id, se.rent_mng_id, se.rent_l_cd,  b.firm_nm, b.client_nm,"+
				" cr.car_no, cr.car_nm, cn.car_name, decode(se.ext_pay_dt, '','미수금','수금') gubun,"+
				" decode(a.serv_st, '1','순회점검', '2','일반수리', '3','보증수리', '4','운행자차', '5','사고자차','7','재리스수리') serv_st, a.off_id, c.off_nm,"+
				" a.rep_amt, a.sup_amt, a.add_amt, a.tot_amt, nvl(se.ext_s_amt, 0)+ nvl(se.ext_v_amt,0) cust_amt, a.serv_dt, b.use_yn, b.mng_id, b.rent_st,"+//b.bus_id2, 
				" nvl2(a.cust_req_dt,substr(a.cust_req_dt,1,4)||'-'||substr(a.cust_req_dt,5,2)||'-'||substr(a.cust_req_dt,7,2),'') cust_req_dt,"+
				" nvl2(se.ext_est_dt,substr(se.ext_est_dt,1,4)||'-'||substr(se.ext_est_dt,5,2)||'-'||substr(se.ext_est_dt,7,2),'') cust_plan_dt,"+
				" nvl2(se.ext_pay_dt,substr(se.ext_pay_dt,1,4)||'-'||substr(se.ext_pay_dt,5,2)||'-'||substr(se.ext_pay_dt,7,2),'') cust_pay_dt,"+
				" decode(g.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기') res_st,"+
				" decode(g.cust_st,'1',h.firm_nm, '4',i.user_nm) cust_nm, se.ext_tm, decode(se.ext_tm,'1','','(잔)') tm_st,"+
				" decode(f.rent_s_cd,'',b.bus_id2,decode(g.rent_st,'2',j.bus_id2,'3',j.bus_id2,'1',g.bus_id,'4',g.cust_id,'5',g.cust_id)) bus_id2,"+
				" TRUNC(NVL(TO_DATE(se.ext_pay_dt, 'YYYYMMDD'), "+b_dt+") - TO_DATE(se.ext_est_dt, 'YYYYMMDD')) as dly_days,"+
				" l.tax_dt as ext_dt, se.seqid, se.ext_pay_amt \n"+
				" from service a, cont_n_view b, serv_off c, accident f, rent_cont g, client h, users i, cont j, scd_ext se,  car_reg cr,  car_etc ce, car_nm cn ,  \n"+
				" (select max(bb.tax_dt) tax_dt, aa.rent_l_cd, aa.tm, SUM(bb.tax_supply) tax_supply from tax_item_list aa, tax bb where aa.item_id=bb.item_id and bb.tax_st<>'C' and aa.gubun ='7' GROUP BY aa.RENT_L_CD, aa.tm) l "+
				" where"+
				" ";

		if(s_kd.equals("1"))		query += " a.rent_l_cd='"+t_wd+"'\n";

		if(!s_cd.equals(""))		query += " and se.rent_st||se.rent_seq||se.ext_st||se.ext_id ='"+s_cd+"'";

		query += "		and se.ext_st = '3' and se.rent_mng_id=a.rent_mng_id and se.rent_l_cd= a.rent_l_cd and se.ext_id = a.serv_id and  se.rent_mng_id=b.rent_mng_id and se.rent_l_cd=b.rent_l_cd and a.car_mng_id=b.car_mng_id  "+
				 "		and a.off_id=c.off_id(+)"+
				 "		and a.car_mng_id=f.car_mng_id(+) and a.accid_id=f.accid_id(+) and f.rent_s_cd=g.rent_s_cd(+) and g.cust_id=h.client_id(+) and g.cust_id=i.user_id(+) and g.sub_l_cd=j.rent_l_cd(+)"+
				 "		and se.rent_l_cd=l.rent_l_cd(+) and se.ext_id=l.tm(+)   AND se.ext_s_amt=l.tax_supply(+) "+
				 "		and nvl(se.ext_s_amt,0) > 0 and nvl(se.bill_yn,'Y')='Y' and nvl(a.no_dft_yn,'N') = 'N'   \n"+
			 	 "	    and a.car_mng_id = cr.car_mng_id  and a.rent_mng_id = ce.rent_mng_id  and a.rent_l_cd = ce.rent_l_cd  \n"+
                 "	    and ce.car_id=cn.car_id  and    ce.car_seq=cn.car_seq ";



		if(gubun3.equals("1"))		query += " and se.ext_pay_dt is not null \n"; //수금
		else if(gubun3.equals("2"))	query += " and se.ext_pay_dt is null \n"; //미수금


		query += " order by a.serv_dt, se.ext_id, se.ext_tm";

		
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
			System.out.println("[SettleDatabase:getInsurMList]\n"+e);
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
	 *	면책금 수금관리
	 */
	public Hashtable getInsurMCaseNotNN(String car_mng_id, String accid_id, String serv_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";


		query = " select c.off_nm, a.* "+
				" from   service a, serv_off c "+
				" where  a.car_mng_id='"+car_mng_id+"' and a.accid_id='"+accid_id+"' and a.serv_id<>'"+serv_id+"' "+
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
			System.out.println("[SettleDatabase:getInsurMCaseNotNN]\n"+e);
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
	 *	연체이자 수금관리
	 */
	public Vector getFeeDlyScd(String gubun3, String gubun4, String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select rent_l_cd, seq, pay_amt, etc,"+
				" substr(pay_dt, 1, 4) || '-' || substr(pay_dt, 5, 2) || '-'||substr(pay_dt, 7, 2) pay_dt"+
				" from scd_dly where rent_l_cd='"+t_wd+"'"+
				" order by pay_dt";												

		
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
			System.out.println("[SettleDatabase:getFeeDlyScd]\n"+e);
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
	 *	연체이자 수금관리
	 */
	public Vector getFeeDlyScdList(String gubun3, String gubun4, String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select * "+
				" from scd_fee where rent_l_cd='"+t_wd+"' and dly_fee>0 and tm_st2<>'4' "+
				" order by fee_est_dt, tm_st1";												

		
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
			System.out.println("[SettleDatabase:getFeeDlyScdList]\n"+e);
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
	 *	대여료 수금관리
	 */
	public Vector getFeeList4(String gubun3, String gubun4, String s_kd, String t_wd, String s_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select /*+ leading(A) use_nl(a) index(b CONT_IDX3) index(c CLIENT_PK )*/ "+
			    " b.client_id, nvl(m.firm_nm,c.firm_nm) firm_nm, nvl(m.client_nm,c.client_nm) client_nm, e.r_site, d.car_mng_id, d.car_no, d.car_nm, b.brch_id, f.user_nm as bus_nm2, b.bus_id, b.bus_id2, b.use_yn,"+
				" (a.fee_s_amt+a.fee_v_amt) fee_amt, a.*,"+
				" h.reg_nm, h.speaker, h.content, h.reg_dt, h.reg_dt2,"+
				" o.tax_dt as tax_dt"+
				" from scd_fee a, cont b, client c, car_reg d, client_site e, users f, "+
				" /*dly_mm*/	(select rent_mng_id, rent_l_cd, max(reg_dt||reg_dt_time) reg_dt from dly_mm group by rent_mng_id, rent_l_cd) g,"+
				" /*dly_mm*/	(select a.rent_mng_id, a.rent_l_cd, b.user_nm as reg_nm, a.speaker, a.content, reg_dt||reg_dt_time as reg_dt, reg_dt as reg_dt2 from dly_mm a, users b where a.reg_id=b.user_id) h,"+
				" /*cls_cont*/	(select rent_mng_id, rent_l_cd from cls_cont where cls_st in ('1','2')) i,"+
				" /*scd_fee*/	(select rent_mng_id, rent_l_cd, min(fee_est_dt) fee_est_dt from scd_fee where rc_yn='0' and fee_s_amt>0 and tm_st2<>'4' group by rent_mng_id, rent_l_cd) j,"+
			    " /*scd_fee*/	(select nvl(d.client_id,a.client_id) client_id, min(b.r_fee_est_dt) r_fee_est_dt from cont a, scd_fee b, cls_cont c, fee_rtn d where a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd(+) and b.rent_mng_id=d.rent_mng_id(+) and b.rent_l_cd=d.rent_l_cd(+) and b.rent_st=d.rent_st(+) and b.rent_seq=d.rent_seq(+) and nvl(c.cls_st,'0')<>'2' and b.fee_s_amt>0 and nvl(b.bill_yn,'Y')='Y' and b.rc_yn='0' and b.tm_st2<>'4' group by nvl(d.client_id,a.client_id)) k,"+
						      //세금계산서
					 "        ( select /*+index(tax TAX_IDX7) */ b.rent_l_cd, b.tm, nvl(b.rent_st,'') rent_st, nvl(b.rent_seq,'') rent_seq, "+
					 "	               max(a.tax_no) tax_no, max(a.tax_dt) tax_dt, max(a.reg_dt) reg_dt, max(a.print_dt) print_dt, \n"+
					 "		           max(a.tax_supply) tax_supply, max(a.tax_value) tax_value, \n"+
					 "		           max(c.item_dt) item_dt, max(c.tax_est_dt) tax_est_dt \n"+
					 "	        from   tax a, tax_item_list b, tax_item c \n"+
					 "			where  a.tax_g='대여료' and a.tax_st<>'C' and nvl(a.doctype,'0')='0'\n"+
					 "                 and a.item_id=b.item_id and a.item_id=c.item_id and nvl(c.use_yn,'Y')='Y'\n"+
					 "	        group by b.rent_l_cd, b.tm, b.rent_st, b.rent_seq \n"+
					 "	      ) o, \n"+
				" /*fee_rtn*/	(select a.*, b.firm_nm, c.r_site, b.client_nm, c.site_jang from fee_rtn a, client b, client_site c where a.client_id=b.client_id and a.client_id=c.client_id(+) and a.r_site=c.seq(+)) m"+
				" where  "+
				" ";

		if(s_kd.equals("1"))		query += " a.rent_l_cd='"+t_wd+"'\n";

		if(!s_cd.equals(""))		query += " and a.rent_st||a.rent_seq||a.fee_tm ='"+s_cd+"'";

		query +=" and a.fee_s_amt>0 and a.tm_st2<>'4' and a.rent_l_cd=b.rent_l_cd"+
				" and b.client_id=c.client_id"+
				" and b.car_mng_id=d.car_mng_id"+
				" and b.client_id=e.client_id(+) and b.r_site=e.seq(+)"+
				" and b.bus_id2=f.user_id(+)"+
				" and a.rent_mng_id=g.rent_mng_id(+) and a.rent_l_cd=g.rent_l_cd(+)"+
				" and g.rent_mng_id=h.rent_mng_id(+) and g.rent_l_cd=h.rent_l_cd(+) and g.reg_dt=h.reg_dt(+)"+
				" and a.rent_mng_id=i.rent_mng_id(+) and a.rent_l_cd=i.rent_l_cd(+)"+
				" and a.rent_mng_id=j.rent_mng_id(+) and a.rent_l_cd=j.rent_l_cd(+)"+
				" and decode(a.rent_seq,'1',b.client_id,m.client_id)=k.client_id"+
				" and a.rent_l_cd=o.rent_l_cd(+) and a.fee_tm=o.tm(+) and a.rent_st=o.rent_st(+) and a.rent_seq=o.rent_seq(+)"+
				" and a.rent_mng_id=m.rent_mng_id(+) and a.rent_l_cd=m.rent_l_cd(+) and a.rent_st=m.rent_st(+) and a.rent_seq=m.rent_seq(+)\n"+
//				" and nvl(a.bill_yn,'Y')='Y' "+
				" ";


		if(gubun3.equals("1"))		query += " and a.rc_dt is not null \n"; //수금
		else if(gubun3.equals("2"))	query += " and a.rc_dt is null \n"; //미수금


		query += " order by a.rent_st, a.rent_seq, to_number(a.fee_tm), a.tm_st1";


		
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
			System.out.println("[SettleDatabase:getFeeList4]\n"+e);
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
	 *	단기대여 수금관리
	 */
	public Vector getScdRentMngList_New(String gubun3, String gubun4, String s_kd, String t_wd, String s_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" a.rent_s_cd, a.car_mng_id, decode(a.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','장기대기') rent_st,"+
				" decode(a.cust_st, '4',e.user_nm, d.client_nm) cust_nm,"+
				" decode(a.cust_st, '4','(주)아마존카', d.firm_nm) firm_nm,"+
				" a.rent_dt, a.brch_id, a.bus_id, a.cust_st, a.cust_id, b.rent_tot_amt, c.car_no, c.car_nm, "+
				" decode(j.pay_dt, '','미수금','수금') pay_yn, decode(j.rent_st,'1','보증금','2','선납대여료','3','대여료','4','정산금') s_rent_st,"+
				" j.tm, j.est_dt, j.pay_dt, "+
				" decode(j.pay_amt,0,j.rest_amt,j.pay_amt) amt, "+
				" j.rent_s_amt+nvl(j.rent_v_amt,0) rent_amt, j.pay_amt, j.rest_amt, j.dly_amt, nvl(j.dly_days,'0') dly_days, "+
				" t.tax_dt "+
				" from RENT_CONT a, RENT_FEE b, CAR_REG c, CLIENT d, USERS e, SCD_RENT j, "+
				"      (select a.*, b.tax_dt from tax_item_list a, tax b where a.item_id=b.item_id and b.tax_st<>'C' and a.gubun in ('9','10')) t"+
				" where  "+
				" ";

		if(s_kd.equals("1"))		query += " a.rent_s_cd='"+t_wd+"'\n";
		if(s_kd.equals("2"))		query += " a.car_mng_id='"+t_wd+"'\n";

		if(!s_cd.equals(""))		query += " and j.rent_st||to_char(j.tm) ='"+s_cd+"'";

		query +=" and a.rent_st in ('1','9') and a.rent_s_cd=b.rent_s_cd(+) and a.cust_id=d.client_id(+) and a.cust_id=e.user_id(+)"+
				" and a.car_mng_id=c.car_mng_id"+
				" and a.rent_start_dt >= '20070101' and  nvl(j.bill_yn,'Y')='Y'"+
				" and j.rent_s_cd=t.rent_l_cd(+) and j.tm=t.tm(+) "+
				" and a.rent_s_cd=j.rent_s_cd(+)\n"+
				" ";


		if(gubun3.equals("1"))		query += " and j.pay_dt is not null \n"; //수금
		else if(gubun3.equals("2"))	query += " and j.pay_dt is null \n"; //미수금


		query += " order by a.rent_s_cd, j.est_dt, to_number(j.tm)";

		
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
			System.out.println("[SettleDatabase:getScdRentMngList_New]\n"+e);
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
	 *	해지정산금 수금관리
	 */
	public Vector getClsFeeScdList(String gubun3, String gubun4, String s_kd, String t_wd, String s_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select  \n"+
				" '정산금' cls_gubun, a.rent_mng_id, a.rent_l_cd, b.car_mng_id, b.firm_nm, b.client_nm, b.client_id,\n"+
				" cr.car_no, cr.car_nm, cn.car_name, decode(a.ext_pay_dt, '','미수금','수금') gubun, a.ext_s_amt as s_amt, (nvl(a.ext_s_amt,0)+nvl(a.ext_v_amt,0)) as amt, a.ext_pay_amt, "+
				" a.ext_tm as tm, decode(a.ext_tm,'1','','(잔)') tm_st, a.dly_amt, to_number(a.dly_days) as dly_days, b.bus_id2, b.rent_st, b.r_site, b.mng_id, b.use_yn, \n"+
				" d.cls_dt, d.cls_dt as est_dt, a.ext_pay_dt as pay_dt, \n"+
				" decode(ce.gi_st,'0','면제','1','가입') gi_st, g.gi_amt gi_amt , nvl(t.accid_id, '-') cr_gubun  "+
				" from scd_ext a, cont_n_view b,  cls_cont d, gua_ins g, (select * from tel_mm where tm_st = '9') t ,   car_reg cr,  car_etc ce, car_nm cn \n"+
				" where  "+
				" ";

		if(s_kd.equals("1"))		query += " a.rent_l_cd='"+t_wd+"'\n";

		if(!s_cd.equals(""))		query += " and a.rent_st||a.rent||a.ext_st||a.ext_id ='"+s_cd+"'";

		query +=" and a.ext_st = '4' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				" and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd "+
				" and a.rent_mng_id=g.rent_mng_id(+) and a.rent_l_cd=g.rent_l_cd(+) "+
				" and a.rent_mng_id=t.rent_mng_id(+) and a.rent_l_cd=t.rent_l_cd(+) "+
				" and (a.ext_s_amt+a.ext_v_amt) >0  and nvl(a.bill_yn,'Y')='Y'\n  "+
				" and b.car_mng_id = cr.car_mng_id(+)  and a.rent_mng_id = ce.rent_mng_id(+)  and a.rent_l_cd = ce.rent_l_cd(+)  \n"+
                       		" and ce.car_id=cn.car_id(+)  and   ce.car_seq=cn.car_seq(+) ";

		if(gubun3.equals("1"))		query += " and a.ext_pay_dt is not null \n"; //수금
		else if(gubun3.equals("2"))	query += " and a.ext_pay_dt is null \n"; //미수금


		query += " order by a.rent_st, a.ext_st, a.ext_tm";

		
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
			System.out.println("[SettleDatabase:getClsFeeScdList]\n"+e);
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
	 *	휴/대차료 수금관리
	 */
	public Vector getInsurHList(String gubun3, String gubun4, String s_kd, String t_wd, String s_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select  \n"+
				"		a.car_mng_id, a.accid_id, a.rent_mng_id, a.rent_l_cd, c.firm_nm, c.client_nm,\n"+
				"		cr.car_no, cr.car_nm, cn.car_name, decode(b.pay_dt, '','미수금','수금') gubun, b.ins_com ot_ins2,\n"+
				"		decode(a.accid_st, '1','피해자', '2','가해자', '3','쌍방', '4','자차사고') accid_st, nvl(a.ot_ins,'') ot_ins,\n"+
				"		decode(b.req_gu, '1','휴차료', '2','대차료') req_gu, decode(b.pay_gu, '1','휴차료', '2','대차료') pay_gu, "+
				"		b.mc_s_amt, b.mc_v_amt, b.req_amt, b.pay_amt, b.dly_days, c.use_yn, c.mng_id, c.rent_st,\n"+
				"		nvl2(a.accid_dt,substr(a.accid_dt,1,4)||'-'||substr(a.accid_dt,5,2)||'-'||substr(a.accid_dt,7,2),'') accid_dt,\n"+
				"		nvl2(b.req_dt,substr(b.req_dt,1,4)||'-'||substr(b.req_dt,5,2)||'-'||substr(b.req_dt,7,2),'') req_dt,\n"+
				"		nvl2(b.pay_dt,substr(b.pay_dt,1,4)||'-'||substr(b.pay_dt,5,2)||'-'||substr(b.pay_dt,7,2),'') pay_dt,\n"+
//				"		case when c.mng_id = '' then nvl(b.bus_id2,c.bus_id2) when c.mng_id is null then nvl(b.bus_id2,c.bus_id2) else c.mng_id end bus_id2, \n"+
				"		nvl(b.bus_id2,c.bus_id2) as bus_id2, \n"+
				"		nvl2(j.tax_dt,substr(j.tax_dt,1,4)||'-'||substr(j.tax_dt,5,2)||'-'||substr(j.tax_dt,7,2),' ') ext_dt,"+
				"		c.rent_dt2 \n"+
				" from	accident a, my_accid b, cont_n_view c,  car_reg cr,  car_etc g, car_nm cn ,\n"+
				"		(select bb.tax_dt, aa.* from tax_item_list aa, tax bb where aa.item_id=bb.item_id and bb.tax_st='O' and aa.gubun in ('11','12')) j "+
				" where   "+
				"	 a.car_mng_id = cr.car_mng_id  and a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+)  \n"+
                       		"	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+) ";

		if(s_kd.equals("1"))		query += " a.rent_l_cd='"+t_wd+"'\n";

		if(!s_cd.equals(""))		query += " and b.accid_id||to_char(b.seq_no) ='"+s_cd+"'";


		query +="		and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id\n"+
				"		and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd\n"+
				"		and b.car_mng_id=j.car_mng_id(+) and b.accid_id=j.tm(+) and b.seq_no=j.rent_seq(+)"+
				"		and nvl(b.bill_yn,'Y') = 'Y' "+
				"		and b.req_amt > 0 \n";


		if(gubun3.equals("1"))		query += " and b.pay_dt is not null \n"; //수금
		else if(gubun3.equals("2"))	query += " and b.pay_dt is null \n"; //미수금


		query += " order by a.accid_dt";


		
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
			System.out.println("[SettleDatabase:getInsurHList]\n"+e);
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
	 *	미청구+잔가 수금관리
	 */
	public Vector getEndFeeList(String gubun3, String gubun4, String s_kd, String t_wd, String s_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		query += " "+
                "             select a.use_yn, a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.bus_id2, a.rent_start_dt, b.rent_end_dt, \n"+
                "                    case when b.rent_end_dt > d.fee_est_dt then b.rent_end_dt else d.fee_est_dt end bas_end_dt, \n"+
                "                    trunc((b.fee_s_amt+b.fee_v_amt)/30*to_number(sysdate-to_date(case when b.rent_end_dt > d.fee_est_dt then b.rent_end_dt else d.fee_est_dt end,'YYYYMMDD')),0) dly_amt, \n"+
                "                    decode(e.fee_opt_amt,0,nvl(e.o_1,0),e.fee_opt_amt) as o_1 \n"+
                "             from   cont a, fee b, \n"+
                "                    (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) c, \n"+
                "                    (select rent_mng_id, rent_l_cd, max(use_e_dt) fee_est_dt from scd_fee where tm_st2<>'4' group by rent_mng_id, rent_l_cd) d, \n"+
                "                    (select * from estimate_sh where est_from='car_janga' and rent_dt=to_char(sysdate,'YYYYMMDD')) e, cls_etc f, \n"+
				"                    ( select * from car_call_in where in_st='3' and out_dt is null ) cc \n"+
                "             where  \n";

		if(s_kd.equals("1"))		query += " a.rent_l_cd='"+t_wd+"'\n";


		query += "            and a.use_yn='Y' \n"+
                "             and    a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
                "             and    b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st \n"+
                "             and    a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd \n"+
                "             and    b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd and b.rent_st=e.rent_st \n"+
                "             and    a.rent_mng_id=f.rent_mng_id(+) and a.rent_l_cd=f.rent_l_cd(+) and f.rent_l_cd is null \n"+  
				"             and    a.rent_mng_id=cc.rent_mng_id(+) and a.rent_l_cd=cc.rent_l_cd(+) and cc.rent_l_cd is null \n"+	
//              "             and    sysdate-to_date(case when b.rent_end_dt > d.fee_est_dt then b.rent_end_dt else d.fee_est_dt end,'YYYYMMDD')>0 \n"+
                "             and    b.rent_end_dt < to_char(sysdate,'YYYYMMDD') and d.fee_est_dt < to_char(sysdate,'YYYYMMDD') \n"+//--20140729 3일경과일부터 채권에 나오게
                "                     \n"+		
				" ";

		query += " order by case when b.rent_end_dt > d.fee_est_dt then b.rent_end_dt else d.fee_est_dt end";

		
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
			System.out.println("[SettleDatabase:getEndFeeList]\n"+e);
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

    //채권관리캠페인 항목별 세부리스트 :: 20101109
	public Vector getStatSettleSubItemList(String rent_mng_id, String rent_l_cd, String car_mng_id, String client_id, String site_id, String bus_id2, String gubun1, String gubun2, String mode)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select \n"+
				"        a.*, b.car_no, b.car_nm, c.firm_nm, d.user_nm, e.cms_bank, f.cls_dt, "+
				"        decode(g.cbit,'1','신규','2','승인','3','해지신청','4','해지완료','7','임의해지','8','신고에러') cbit, g.ldate \n"+
				" from \n"+
				" ( \n";

		if(gubun1.equals("선수금") || gubun1.equals("")){				
			query += " "+
				"	 select '1' sort, '선수금' gubun1, decode(a.ext_st,'0','보증금','1','선납금','2','개시대여료', '5', '승계수수료') gubun2, \n"+
				"           a.rent_mng_id, a.rent_l_cd, c.car_mng_id, c.client_id, decode(c.car_st,'4',c.mng_id,c.bus_id2) bus_id2, \n"+
				"           decode(a.ext_st, '5', a.ext_est_dt, nvl(d.rent_suc_dt,b.rent_start_dt)) as est_dt, \n"+
				"           (a.ext_s_amt+a.ext_v_amt) dly_amt, \n"+
				"	        c.use_yn, c.rent_start_dt, \n"+
				"           a.rent_st as s_cd1, a.rent_seq as s_cd2, a.ext_st as s_cd3, a.ext_id as s_cd4, '' as s_cd5 \n"+
				"	 from   scd_ext a, fee b, cont c, cont_etc d, (select * from cls_cont where cls_st in ('4','5')) e \n"+
				"    where  a.ext_st in ('0', '1', '2', '5' ) \n"+
				"          and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st \n"+
				"          and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"+
				"          and a.rent_mng_id = d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+)"+
				"          and c.rent_mng_id=e.rent_mng_id(+) and c.reg_dt=e.reg_dt(+) "+
				"          and a.ext_s_amt>0 and a.ext_pay_dt is null and nvl(a.bill_yn,'Y')='Y' \n"+
				"          and decode(a.ext_st,'5',nvl(d.rent_suc_dt,b.rent_start_dt), \n"+//승계수수료
                "                     decode(c.rent_st||b.rent_st||b.grt_suc_yn||a.ext_st,'3100', \n"+//--대차승계보증금
                "                            decode(a.gubun,'E',a.ext_est_dt, \n"+
                "                                   to_char(to_date(nvl(b.rent_start_dt,to_char(sysdate,'YYYYMMDD')),'YYYYMMDD')+15,'YYYYMMDD') \n"+
                "                            ), \n"+
                "                            case when d.rent_suc_dt is not null and d.rent_suc_dt > b.rent_start_dt then d.rent_suc_dt else b.rent_start_dt end \n"+
                "                     ) \n"+
                "              ) < to_char(sysdate,'YYYYMMDD') \n"+
				" ";
		}

		if(gubun1.equals("")){				
			query += " union all \n";
		}

		if(gubun1.equals("대여료") || gubun1.equals("")){				
			query += " "+
				"    select '2' sort, '대여료' gubun1, a.fee_tm||'회'||decode(a.tm_st1,'0','','(잔액)') gubun2, \n"+
				"          a.rent_mng_id, a.rent_l_cd, b.car_mng_id, b.client_id, decode(b.car_st,'4',b.mng_id,b.bus_id2) bus_id2, \n"+
				"          a.r_fee_est_dt as est_dt, \n"+
				"          (a.fee_s_amt+a.fee_v_amt) dly_amt, \n"+
				"	       b.use_yn, b.rent_start_dt, \n"+
				"           a.rent_st as s_cd1, a.rent_seq as s_cd2, a.fee_tm as s_cd3, '' as s_cd4, '' as s_cd5 \n"+
				"    from  scd_fee a, cont b \n"+
				"    where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				"          and a.fee_s_amt>0 and a.rc_dt is null and nvl(a.bill_yn,'Y')='Y' and a.tm_st2<>'4' \n"+
				"          and a.r_fee_est_dt < to_char(sysdate,'YYYYMMDD')            \n"+
				" ";
		}

		if(gubun1.equals("")){				
			query += " union all \n";
		}

		if(gubun1.equals("미청구+잔가") || gubun1.equals("")){				
			query += " "+
                "    select '2_2' sort, '대여료' gubun1, '미청구+잔가' gubun2,  \n"+
                "           rent_mng_id, rent_l_cd, car_mng_id, client_id, bus_id2, \n"+
                "           bas_end_dt as est_dt, (dly_amt+o_1) dly_amt, use_yn, rent_start_dt, \n"+
				"           '' s_cd1, '' s_cd2, '' s_cd3, '' s_cd4, '' s_cd5 \n"+
                "           from \n"+
                "           ( select a.use_yn, a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.bus_id2, a.rent_start_dt, \n"+
                "                    case when b.rent_end_dt > d.fee_est_dt then b.rent_end_dt else d.fee_est_dt end bas_end_dt, \n"+
                "                    trunc((b.fee_s_amt+b.fee_v_amt)/30*to_number(sysdate-to_date(case when b.rent_end_dt > d.fee_est_dt then b.rent_end_dt else d.fee_est_dt end,'YYYYMMDD')),0) dly_amt, \n"+
                "                    decode(e.fee_opt_amt,0,nvl(e.o_1,0),e.fee_opt_amt) as o_1 \n"+
                "             from   cont a, fee b, \n"+
                "                    (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) c, \n"+
                "                    (select rent_mng_id, rent_l_cd, max(use_e_dt) fee_est_dt from scd_fee where tm_st2<>'4' group by rent_mng_id, rent_l_cd) d, \n"+
                "                    (select * from estimate_sh where est_from='car_janga' and rent_dt=to_char(sysdate,'YYYYMMDD')) e, cls_etc f, \n"+
				"                    ( select * from car_call_in where in_st='3' and out_dt is null ) cc \n"+
                "             where  a.use_yn='Y' AND a.CAR_st NOT IN ('2','4') \n"+
                "             and    a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
                "             and    b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st \n"+
                "             and    a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd \n"+
                "             and    b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd and b.rent_st=e.rent_st \n"+
                "             and    a.rent_mng_id=f.rent_mng_id(+) and a.rent_l_cd=f.rent_l_cd(+) and f.rent_l_cd is null \n"+  
				"             and    a.rent_mng_id=cc.rent_mng_id(+) and a.rent_l_cd=cc.rent_l_cd(+) and cc.rent_l_cd is null \n"+	
//              "             and    sysdate-to_date(case when b.rent_end_dt > d.fee_est_dt then b.rent_end_dt else d.fee_est_dt end,'YYYYMMDD')>0 \n"+
                "             and    b.rent_end_dt < to_char(sysdate,'YYYYMMDD') and d.fee_est_dt < to_char(sysdate,'YYYYMMDD') \n"+//--20140729 3일경과일부터 채권에 나오게
                "           )           \n"+		
				" ";
		}

		if(gubun1.equals("")){				
			query += " union all \n";
		}

		if(gubun1.equals("과태료") || gubun1.equals("")){				
			query += " "+
				"    select '3' sort, '과태료' gubun1, substr(a.vio_dt,1,8)||' '||a.vio_cont||'-'||decode(a.fault_st,'1','고객과실','업무상과실') as gubun2, \n"+
				"           a.rent_mng_id, a.rent_l_cd, b.car_mng_id, \n"+
				"           decode(c.rent_s_cd,'',b.client_id,d.client_id) client_id, \n"+
				"           decode(a.rent_s_cd,'',decode(a.fault_st,'2',nvl(a.fault_nm,b.bus_id2),b.bus_id2), decode(c.rent_st,'1',c.bus_id,'9',c.bus_id, '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) bus_id2, \n"+
				"           nvl(a.rec_plan_dt,nvl(a.dem_dt,a.paid_end_dt)) as est_dt, \n"+
				"           a.paid_amt as dly_amt, decode(c.rent_s_cd,'',b.use_yn,d.use_yn) use_yn, b.rent_start_dt, \n"+
				"           to_char(a.seq_no) as s_cd1, '' s_cd2, '' s_cd3, '' s_cd4, '' s_cd5 \n"+
				"    from   fine a, cont b, rent_cont c, cont d \n"+
				"    where  a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				"           and a.rent_s_cd=c.rent_s_cd(+) AND NVL(c.use_st,'0')<>'5' \n"+
				"           and c.sub_l_cd=d.rent_l_cd(+) \n"+
				"           and a.paid_amt>0 and a.coll_dt is null and decode(a.fault_st,'2', 'Y', '3', 'N', nvl(a.bill_yn,'Y'))='Y' \n"+
				"           and a.paid_st in ('3','4') and nvl(a.no_paid_yn,'N')='N' \n"+
				"           and ( (a.vio_cont not like  '%통행료%'and a.vio_cont not like  '%주차요금%') or  ( a.vio_cont like  '%통행료%' and a.proxy_dt is not null ) or ( a.vio_cont like  '%주차요금%' and a.proxy_dt is not null )  )"+
				"           and nvl(a.rec_plan_dt,nvl(a.dem_dt,a.paid_end_dt)) < to_char(sysdate,'YYYYMMDD') \n"+
				" ";
		}

		if(gubun1.equals("")){				
			query += " union all \n";
		}

		if(gubun1.equals("면책금") || gubun1.equals("")){				
			query += " "+
				"    select '4' sort, '면책금' gubun1, a.serv_dt||' '||decode(e.accid_st,'1','피해자','2','가해자','3','쌍방','4','운행자차','5','사고자차') gubun2, \n"+
				"           a.rent_mng_id, a.rent_l_cd, a.car_mng_id, \n"+
				"           decode(e.rent_s_cd,'',b.client_id,d.client_id) client_id, \n"+
				"           decode(e.rent_s_cd,'',b.bus_id2, decode(c.rent_st,'1',c.bus_id,'9',c.bus_id, '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) bus_id2, \n"+
				"           nvl(se.ext_est_dt, a.cust_plan_dt) as est_dt, \n"+
				"           (se.ext_s_amt+se.ext_v_amt) as dly_amt, decode(e.rent_s_cd,'',b.use_yn,d.use_yn) use_yn, decode(e.rent_s_cd,'',b.rent_start_dt,d.rent_start_dt) rent_start_dt, \n"+
				"           se.rent_st as s_cd1, se.rent_seq as s_cd2, se.ext_st as s_cd3, se.ext_id as s_cd4, '' as s_cd5 \n"+
				"    from   scd_ext se, service a, accident e, cont b, rent_cont c, cont d \n"+
				"    where  se.ext_st = '3' \n"+
				"           and se.rent_mng_id = a.rent_mng_id and se.rent_l_cd = a.rent_l_cd and se.ext_id = a.serv_id \n"+
				"           and a.car_mng_id=e.car_mng_id and a.accid_id=e.accid_id \n"+
				"           and se.rent_mng_id=b.rent_mng_id and se.rent_l_cd=b.rent_l_cd \n"+
				"           and e.rent_s_cd=c.rent_s_cd(+) \n"+
				"           and c.sub_l_cd=d.rent_l_cd(+) \n"+
				"           and se.ext_s_amt>0 and se.ext_pay_dt is null and nvl(se.bill_yn,'Y')='Y' \n"+
				"           and nvl(a.no_dft_yn,'N')='N' \n"+
				"           and nvl(se.ext_est_dt, a.cust_plan_dt) < to_char(sysdate,'YYYYMMDD') \n"+
				" ";
		}

		if(gubun1.equals("")){				
			query += " union all \n";
		}

		if(gubun1.equals("해지정산금") || gubun1.equals("")){				
			query += " "+
				"    select '5' sort, '해지정산금' gubun1, decode(b.cls_st,'1','계약만료','2','중도해지') gubun2, \n"+
				"           a.rent_mng_id, a.rent_l_cd, c.car_mng_id, c.client_id, c.bus_id2, \n"+
				"           b.cls_dt as est_dt, \n"+
				"           (a.ext_s_amt+a.ext_v_amt) as dly_amt, c.use_yn, c.rent_start_dt, \n"+
				"           a.rent_st as s_cd1, a.rent_seq as s_cd2, a.ext_st as s_cd3, a.ext_id as s_cd4, '' as s_cd5 \n"+
				"    from   scd_ext a, cls_cont b, cont c \n"+
				"    where  a.ext_st = '4' \n"+
				"           and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				"           and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"+
				"           and (a.ext_s_amt+a.ext_v_amt) >0 and a.ext_pay_dt is null and nvl(a.bill_yn,'Y')='Y' \n"+
				"           and nvl(b.cls_doc_yn,'Y')='Y' \n"+
				"           and b.cls_dt < to_char(sysdate,'YYYYMMDD') \n"+
				" ";
		}

		if(gubun1.equals("")){				
			query += " union all \n";
		}

		if(gubun1.equals("단기대여료") || gubun1.equals("")){				
			query += " "+
				"    select '6' sort, '단기대여료' gubun1, decode(b.rent_st,'1','단기대여','9','보험대차','12','월렌트') gubun2, \n"+
				"           '' rent_mng_id, b.rent_s_cd as rent_l_cd, b.car_mng_id, b.cust_id as client_id, b.bus_id as bus_id2, \n"+
				"           a.est_dt, \n"+
				"           DECODE(b.RENT_ST||a.rent_st, \n"+
                "                           '123',TRUNC((a.rent_s_amt+a.rent_v_amt)*DECODE(NVL(b.mng_id,b.bus_id),b.bus_id,1,0.2)), \n"+
                "                           '124',TRUNC((a.rent_s_amt+a.rent_v_amt)*DECODE(NVL(b.mng_id,b.bus_id),b.bus_id,1,0.2)), \n"+
                "                           '125',TRUNC((a.rent_s_amt+a.rent_v_amt)*DECODE(NVL(b.mng_id,b.bus_id),b.bus_id,1,0.2)), \n"+
                "                           '128',TRUNC((a.rent_s_amt+a.rent_v_amt)*DECODE(NVL(b.mng_id,b.bus_id),b.bus_id,1,0.2)), \n"+
                "                           (a.rent_s_amt+a.rent_v_amt)) as dly_amt, decode(b.ret_dt,'','Y','N') use_yn, b.ret_dt as rent_start_dt, \n"+
				"           a.rent_st s_cd1, to_char(a.tm) s_cd2, '' s_cd3, '' s_cd4, '' s_cd5 \n"+
				"    from   scd_rent a, rent_cont b \n"+
				"    where  a.rent_s_cd=b.rent_s_cd \n"+
				"           and a.rent_s_amt>0 and a.pay_dt is null and nvl(a.bill_yn,'Y')='Y' AND b.use_st<>'5' AND a.rent_st<>'7'\n"+
				"           and a.est_dt < to_char(sysdate,'YYYYMMDD') \n"+
				" ";

			query += " union all \n";

			query += " "+
				"    select '6' sort, '단기대여료' gubun1, '월렌트' gubun2, \n"+
				"           '' rent_mng_id, b.rent_s_cd as rent_l_cd, b.car_mng_id, b.cust_id as client_id, b.mng_id as bus_id2, \n"+
				"           a.est_dt, \n"+
				"           TRUNC((a.rent_s_amt+a.rent_v_amt)*0.8) as dly_amt, decode(b.ret_dt,'','Y','N') use_yn, b.ret_dt as rent_start_dt, \n"+
				"           a.rent_st s_cd1, to_char(a.tm) s_cd2, '' s_cd3, '' s_cd4, '' s_cd5 \n"+
				"    from   scd_rent a, rent_cont b \n"+
				"    where  a.rent_s_cd=b.rent_s_cd \n"+
				"           and a.rent_s_amt>0 and a.pay_dt is null and nvl(a.bill_yn,'Y')='Y' AND b.use_st<>'5' AND b.RENT_ST='12' AND a.rent_st IN ('3','4','5','8')\n"+
				"           and a.est_dt < to_char(sysdate,'YYYYMMDD') \n"+
				" ";
		
		}

		if(gubun1.equals("")){				
			query += " union all \n";
		}

		if(gubun1.equals("휴/대차료") || gubun1.equals("")){				
			query += " "+
				"    select '7' sort, '휴/대차료' gubun1, decode(a.req_gu,'1','휴차료','2','대차료')||' '||a.ins_com gubun2, \n"+
				"           c.rent_mng_id, c.rent_l_cd, b.car_mng_id, c.client_id, nvl(a.bus_id2,c.bus_id2) bus_id2, \n"+
				"           a.req_dt as est_dt, \n"+
				"           a.req_amt as dly_amt, c.use_yn, c.rent_dt as rent_start_dt, \n"+
				"           a.accid_id s_cd1, to_char(a.seq_no) s_cd2, '' s_cd3, '' s_cd4, '' s_cd5 \n"+
				"    from   my_accid a, accident b, cont c, \n"+
				"           (select * from scd_ext where ext_st='6' and ext_tm='1' and (ext_s_amt+ext_v_amt)>0 ) d "+
				"    where  a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd \n"+
				"           and a.req_amt > 0 and nvl(a.pay_amt, 0) < 1 \n"+
				"           and a.req_dt is not null and a.pay_dt is null \n"+
				"           and b.rent_mng_id=d.rent_mng_id and b.rent_l_cd=d.rent_l_cd  \n"+
                "           and a.accid_id||to_char(a.seq_no)=d.ext_id \n"+
				" ";
		}

		if(gubun1.equals("")){				
			query += " union all \n";
		}

		if(gubun1.equals("연체이자") || gubun1.equals("")){				
			query += " "+
				"    select '9' sort, '연체이자' gubun1, '' gubun2, \n"+
				"          a.rent_mng_id, a.rent_l_cd, c.car_mng_id, c.client_id, DECODE(c.car_st,'4',c.mng_id,c.bus_id2) bus_id2, \n"+
				"          '' as est_dt, \n"+
				"          nvl(a.dly_fee,0)-nvl(b.pay_amt,0) dly_amt, c.use_yn, c.rent_start_dt, \n"+
				"           '' s_cd1, '' s_cd2, '' s_cd3, '' s_cd4, '' s_cd5 \n"+
				"    from  (select rent_mng_id, rent_l_cd, sum(dly_fee) dly_fee from scd_fee where rent_l_cd not like 'RM%' and tm_st2<>'4' group by rent_mng_id, rent_l_cd) a, "+
				"          (select rent_mng_id, rent_l_cd, sum(pay_amt) pay_amt from scd_dly where rent_l_cd not like 'RM%' group by rent_mng_id, rent_l_cd) b, cont c, \n"+
                "          (SELECT * FROM CLS_CONT WHERE cls_dt>'20091231' AND cls_st IN ('4','5')) d \n"+
				"    where a.rent_mng_id=b.rent_mng_id(+) and a.rent_l_cd=b.rent_l_cd(+) and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"+
				"          and nvl(a.dly_fee,0)-nvl(b.pay_amt,0)<>0 and c.rent_l_cd not like 'RM%' \n"+
                "          AND c.rent_mng_id=d.rent_mng_id(+) AND c.rent_l_cd=d.rent_l_cd(+) and DECODE(d.cls_st,'4','Y','5','Y',c.use_yn)='Y' \n"+
				" ";
		}

		query += " "+
				" ) a, car_reg b, client c, users d, "+
				"   	cms_mng e, cls_cont f, (select rent_mng_id, rent_l_cd, max(seq) seq from cms_mng group by rent_mng_id, rent_l_cd) h, cust g \n"+
				" where ";


		if(mode.equals("client"))	query += " a.client_id	='"+client_id+"' ";
		if(mode.equals("car"))		query += " a.car_mng_id	='"+car_mng_id+"' ";
		if(mode.equals("cont"))		query += " a.rent_l_cd	='"+rent_l_cd+"' ";
		if(mode.equals("bus_id2"))	query += " a.bus_id2	='"+bus_id2+"' ";
		if(mode.equals(""))			query += " a.dly_amt>0 ";

		if(!gubun2.equals(""))		query += " and a.gubun2	='"+gubun2+"' ";


		query += " "+	
				"	    and a.car_mng_id=b.car_mng_id and a.client_id=c.client_id and a.bus_id2=d.user_id and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+)\n"+
				"       and a.rent_mng_id=f.rent_mng_id(+) and a.rent_l_cd=f.rent_l_cd(+) "+
				"	    and e.rent_mng_id=h.rent_mng_id(+) and e.rent_l_cd=h.rent_l_cd(+) and e.seq=h.seq(+) and e.rent_l_cd=g.code(+) "+
				" order by a.sort, a.bus_id2, a.use_yn, a.client_id, a.car_mng_id, a.est_dt "+
				" ";

		try {
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
			System.out.println("[SettleDatabase:getStatSettleSubItemList]\n"+e);
			System.out.println("[SettleDatabase:getStatSettleSubItemList]\n"+query);
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

 	//채권관리캠페인 담당자별 세부리스트 :: 20090408
	public Vector getStatSettleSubList(String bus_id2, String rent_l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";



		query = " select \n"+
				"        a.*, b.car_no, b.car_nm, c.firm_nm, d.user_nm, e.cms_bank, f.cls_dt, "+
				"        decode(g.cbit,'1','신규','2','승인','3','해지신청','4','해지완료','7','임의해지','8','신고에러') cbit, g.ldate, nvl(p.promise_dt,'') promise_dt \n"+
				" from \n"+
				" ( \n"+
				"	 select '1' sort, '선수금' gubun1, decode(a.ext_st,'0','보증금','1','선납금','2','개시대여료', '5', '승계수수료') gubun2, \n"+
				"           a.rent_mng_id, a.rent_l_cd, c.car_mng_id, c.client_id, decode(a.ext_st,'5',NVL(b.ext_agnt,c.bus_id2),decode(b.rent_st,'1',decode(e.rent_l_cd,'',DECODE(c.bus_st,'7',c.bus_id2,c.bus_id),c.bus_id2),c.bus_id2)) bus_id2, c.mng_id2, \n"+
				"           decode(a.ext_st, '5', nvl(d.rent_suc_dt,b.rent_start_dt), nvl(d.rent_suc_dt,b.rent_start_dt)) as est_dt, "+
				"           (a.ext_s_amt+a.ext_v_amt) dly_amt, 0 dly_amt2, c.use_yn, c.rent_start_dt \n"+
				"	 from   scd_ext a, fee b, cont c, cont_etc d, (select * from cls_cont where cls_st in ('4','5')) e \n"+
				"    where  a.ext_st in ('0', '1', '2', '5' ) \n"+
				"          and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st \n"+
				"          and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"+
				"          and a.rent_mng_id = d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+)"+
				"          and c.rent_mng_id=e.rent_mng_id(+) and c.reg_dt=e.reg_dt(+) "+
				"          and a.ext_s_amt>0 and a.ext_pay_dt is null and nvl(a.bill_yn,'Y')='Y' \n"+
				"          and decode(a.ext_st,'5',nvl(d.rent_suc_dt,a.ext_est_dt), \n"+//승계수수료
                "                     decode(c.rent_st||b.rent_st||b.grt_suc_yn||a.ext_st,'3100', \n"+//--대차승계보증금
                "                            decode(a.gubun,'E',a.ext_est_dt, \n"+
                "                                   to_char(to_date(nvl(b.rent_start_dt,to_char(sysdate,'YYYYMMDD')),'YYYYMMDD')+15,'YYYYMMDD') \n"+
                "                            ), \n"+
				"                            case when d.rent_suc_dt is not null and d.rent_suc_dt > b.rent_start_dt then d.rent_suc_dt \n"+
                "                                                             WHEN d.rent_suc_dt IS NULL AND a.ext_st='5' THEN a.ext_est_dt  \n"+ 
                "                                                             else b.rent_start_dt end \n"+
                "                     ) \n"+
                "              ) < to_char(sysdate,'YYYYMMDD') \n"+

				"	 union all		 \n"+
				"    select '2' sort, '대여료' gubun1, a.fee_tm||'회'||decode(a.tm_st1,'0','','(잔액)') gubun2, \n"+
				"          a.rent_mng_id, a.rent_l_cd, b.car_mng_id, b.client_id, DECODE(b.car_st,'4',b.mng_id,b.bus_id2) bus_id2, b.mng_id2, \n"+
				"          a.r_fee_est_dt as est_dt, \n"+
				"          (a.fee_s_amt+a.fee_v_amt) dly_amt, 0 dly_amt2, b.use_yn, b.rent_start_dt \n"+
				"    from  scd_fee a, cont b \n"+
				"    where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				"          and a.fee_s_amt>0 and a.rc_dt is null and nvl(a.bill_yn,'Y')='Y' and a.tm_st2<>'4' \n"+
				"          and a.r_fee_est_dt < to_char(sysdate,'YYYYMMDD')            \n"+
                
				"	 union all		 \n"+
                "    select '2_2' sort, '대여료' gubun1, '미청구분+잔가' gubun2,  \n"+
                "           rent_mng_id, rent_l_cd, car_mng_id, client_id, bus_id2, mng_id2, \n"+
                "           bas_end_dt as est_dt, (dly_amt+o_1) dly_amt, 0 dly_amt2, use_yn, rent_start_dt \n"+
                "           from \n"+
                "           ( select a.use_yn, a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.bus_id2, a.mng_id2, a.rent_start_dt, \n"+
                "                    case when b.rent_end_dt > d.fee_est_dt then b.rent_end_dt else d.fee_est_dt end bas_end_dt, \n"+
                "                    trunc((b.fee_s_amt+b.fee_v_amt)/30*to_number(sysdate-to_date(case when b.rent_end_dt > d.fee_est_dt then b.rent_end_dt else d.fee_est_dt end,'YYYYMMDD')),0) dly_amt, \n"+
                "                    decode(e.fee_opt_amt,0,nvl(e.o_1,0),e.fee_opt_amt) as o_1 \n"+
                "             from   cont a, fee b, \n"+
                "                    (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) c, \n"+
                "                    (select rent_mng_id, rent_l_cd, max(use_e_dt) fee_est_dt from scd_fee where tm_st2<>'4' group by rent_mng_id, rent_l_cd) d, \n"+
                "                    (select * from estimate_sh where est_from='car_janga' and rent_dt=to_char(sysdate,'YYYYMMDD')) e, cls_etc f, \n"+
				"                    ( select * from car_call_in where in_st='3' and out_dt is null ) cc \n"+
                "             where  a.use_yn='Y' and a.car_st in ('1','3') and b.rent_start_dt is not null \n"+
                "             and    a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
                "             and    b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st \n"+
                "             and    a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd \n"+
                "             and    b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd and b.rent_st=e.rent_st \n"+
                "             and    a.rent_mng_id=f.rent_mng_id(+) and a.rent_l_cd=f.rent_l_cd(+) and f.rent_l_cd is null \n"+  
				"             and    a.rent_mng_id=cc.rent_mng_id(+) and a.rent_l_cd=cc.rent_l_cd(+) and cc.rent_l_cd is null \n"+	
                "             and    b.rent_end_dt < to_char(sysdate+3,'YYYYMMDD') and d.fee_est_dt < to_char(sysdate+3,'YYYYMMDD') \n"+//--20140729 3일경과일부터 채권에 나오게
                "           )           \n"+		

				"    union all \n"+
				"    select '3' sort, '과태료' gubun1, substr(a.vio_dt,1,8)||' '||a.vio_cont||'-'||decode(a.fault_st,'1','고객과실','업무상과실') as gubun2, \n"+
				"           a.rent_mng_id, a.rent_l_cd, b.car_mng_id, \n"+
				"           decode(c.rent_s_cd,'',b.client_id, decode(c.cust_st, '4', '000228',  c.cust_id)  ) client_id, \n"+ //업무대여인건 client_id : 아마존카로 처리 -
				"           decode(a.rent_s_cd,'',decode(a.fault_st,'2',nvl(a.fault_nm,b.bus_id2),b.bus_id2), decode(c.rent_st,'1',c.bus_id,'9',c.bus_id,'12',nvl(c.mng_id,c.bus_id), '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id,c.bus_id)) bus_id2, b.mng_id2, \n"+
				"           nvl(a.rec_plan_dt,nvl(a.dem_dt,a.paid_end_dt)) as est_dt, \n"+
				"           a.paid_amt as dly_amt, 0 dly_amt2, decode(c.rent_s_cd,'',b.use_yn,d.use_yn) use_yn, b.rent_start_dt \n"+
				"    from   fine a, cont b, rent_cont c, cont d \n"+
				"    where  a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				"           and a.rent_s_cd=c.rent_s_cd(+)  AND NVL(c.use_st,'0')<>'5' \n"+
				"           and c.sub_l_cd=d.rent_l_cd(+) \n"+
				"           and a.paid_amt>0 and a.coll_dt is null and decode(a.fault_st,'2', 'Y', '3', 'N', nvl(a.bill_yn,'Y'))='Y' \n"+
				"           and a.paid_st in ('3','4') and nvl(a.no_paid_yn,'N')='N' \n"+
				"           and ( (a.vio_cont not like  '%통행료%'and a.vio_cont not like  '%주차요금%') or  ( a.vio_cont like  '%통행료%' and a.proxy_dt is not null ) or ( a.vio_cont like  '%주차요금%' and a.proxy_dt is not null )  )"+
				"           and nvl(a.rec_plan_dt,nvl(a.dem_dt,a.paid_end_dt)) < to_char(sysdate,'YYYYMMDD') \n"+
				"	 union all \n"+
				"    select '4' sort, '면책금' gubun1, a.serv_dt||' '||decode(e.accid_st,'1','피해','2','가해','3','쌍방','4','운행자차','5','사고자차', '8', '단독') gubun2, \n"+
				"           a.rent_mng_id, a.rent_l_cd, a.car_mng_id, \n"+
				"           decode(e.rent_s_cd,'',b.client_id,d.client_id) client_id, \n"+
				"           decode(e.rent_s_cd,'',b.bus_id2, decode(c.rent_st,'1',c.bus_id,'9',c.bus_id,'12',nvl(c.mng_id,c.bus_id), '10',c.bus_id, '2',d.bus_id2,'3',d.bus_id2,'4',c.cust_id,'5',c.cust_id)) bus_id2, b.mng_id2, \n"+
				"           nvl(se.ext_est_dt, a.cust_plan_dt) as est_dt, \n"+
				"           (se.ext_s_amt+se.ext_v_amt) as dly_amt, 0 dly_amt2, decode(e.rent_s_cd,'',b.use_yn,d.use_yn) use_yn, decode(e.rent_s_cd,'',b.rent_start_dt,d.rent_start_dt) rent_start_dt \n"+
				"    from   scd_ext se, service a, accident e, cont b, rent_cont c, cont d \n"+
				"    where  se.ext_st = '3' \n"+
				"           and se.rent_mng_id = a.rent_mng_id and se.rent_l_cd = a.rent_l_cd and se.ext_id = a.serv_id \n"+
				"           and a.car_mng_id=e.car_mng_id and a.accid_id=e.accid_id \n"+
				"           and se.rent_mng_id=b.rent_mng_id and se.rent_l_cd=b.rent_l_cd \n"+
				"           and e.rent_s_cd=c.rent_s_cd(+) \n"+
				"           and c.sub_l_cd=d.rent_l_cd(+) \n"+
				"           and se.ext_s_amt>0 and se.ext_pay_dt is null and nvl(se.bill_yn,'Y')='Y' \n"+
				"           and nvl(a.no_dft_yn,'N')='N' \n"+
				"          and e.car_mng_id||e.accid_id not in ('005938014279')  \n"+  //두바이카 정보제공은 면책금에서 제외
				"           and nvl(se.ext_est_dt, a.cust_plan_dt) < to_char(sysdate,'YYYYMMDD') \n"+
				"	 union all \n"+
				"    select '5' sort, '위약금' gubun1, decode(b.cls_st,'1','계약만료','2','중도해지') gubun2, \n"+
				"           a.rent_mng_id, a.rent_l_cd, c.car_mng_id, c.client_id, c.bus_id2, c.mng_id2, \n"+
				"           b.cls_dt as est_dt, \n"+
				"           (a.ext_s_amt+a.ext_v_amt) as dly_amt, 0 dly_amt2, c.use_yn, c.rent_start_dt \n"+
				"    from   scd_ext a, cls_cont b, cont c \n"+
				"    where  a.ext_st = '4' \n"+
				"           and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				"           and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"+
				"           and DECODE(c.car_st,'4',case when b.fdft_amt2 < 0 then 0 else a.ext_s_amt+a.ext_v_amt end,(a.ext_s_amt+a.ext_v_amt)) >0 and a.ext_pay_dt is null and nvl(a.bill_yn,'Y')='Y' \n"+
				"           and nvl(b.cls_doc_yn,'Y')='Y' \n"+
				"           and b.cls_dt < to_char(sysdate,'YYYYMMDD') \n"+
				"    union all \n"+
				"    select '6' sort, '단기요금' gubun1, decode(b.rent_st,'1','단기대여','9','보험대차','12','월렌트','2','정비대차') gubun2, \n"+
				"           '' rent_mng_id, b.rent_s_cd as rent_l_cd, b.car_mng_id, b.cust_id as client_id, b.bus_id as bus_id2, '' mng_id2, \n"+
				"           a.est_dt, \n"+
				"           DECODE(b.RENT_ST||a.rent_st,'123',TRUNC((a.rent_s_amt+a.rent_v_amt)*0.2),'124',TRUNC((a.rent_s_amt+a.rent_v_amt)*0.2),'125',TRUNC((a.rent_s_amt+a.rent_v_amt)*0.2),'128',TRUNC((a.rent_s_amt+a.rent_v_amt)*0.2),(a.rent_s_amt+a.rent_v_amt)) as dly_amt, "+
				"	        (a.rent_s_amt+a.rent_v_amt) dly_amt2, decode(b.ret_dt,'','Y','N') use_yn, b.ret_dt as rent_start_dt \n"+
				"    from   scd_rent a, rent_cont b \n"+
				"    where  a.rent_s_cd=b.rent_s_cd and b.use_st<>'5' and a.rent_st not in ('7','2') and b.mng_id <>'000126' \n"+
				"           and a.rent_s_amt>0 and a.pay_dt is null and nvl(a.bill_yn,'Y')='Y' \n"+
				"           and a.est_dt < to_char(sysdate,'YYYYMMDD')  \n"+
				"    union all \n"+
				"    select '6' sort, '단기요금' gubun1, decode(b.rent_st,'1','단기대여','9','보험대차','12','월렌트','2','정비대차') gubun2, \n"+
				"           '' rent_mng_id, b.rent_s_cd as rent_l_cd, b.car_mng_id, b.cust_id as client_id, NVL(b.mng_id,b.bus_id) as bus_id2, '' mng_id2, \n"+
				"           a.est_dt, \n"+
				"           TRUNC((a.rent_s_amt+a.rent_v_amt)*0.8) as dly_amt, (a.rent_s_amt+a.rent_v_amt) dly_amt2, "+
				"		    decode(b.ret_dt,'','Y','N') use_yn, b.ret_dt as rent_start_dt \n"+
				"    from   scd_rent a, rent_cont b \n"+
				"    where  a.rent_s_cd=b.rent_s_cd and b.use_st<>'5' \n"+
				"           and a.rent_s_amt>0 and a.pay_dt is null and nvl(a.bill_yn,'Y')='Y' \n"+
				"           and a.est_dt < to_char(sysdate,'YYYYMMDD') \n"+
				"           AND b.RENT_ST='12' AND a.rent_st IN ('3','4','5','8') "+		
				"	 union all		 \n"+
				"    select '9' sort, '연체이자' gubun1, '-' gubun2, \n"+
				"          c.rent_mng_id, c.rent_l_cd, c.car_mng_id, c.client_id, DECODE(c.car_st,'4',c.mng_id,c.bus_id2) bus_id2, c.mng_id2, \n"+
				"          '' as est_dt, \n"+
				"          nvl(a.dly_fee,0)-nvl(b.pay_amt,0) dly_amt, 0 dly_amt2, c.use_yn, c.rent_start_dt \n"+
				"    from  (select rent_mng_id, rent_l_cd, sum(dly_fee) dly_fee from scd_fee where rent_l_cd not like 'RM%' and tm_st2<>'4' group by rent_mng_id, rent_l_cd) a, "+
				"	       (select rent_mng_id, rent_l_cd, sum(pay_amt) pay_amt from scd_dly where rent_l_cd not like 'RM%' group by rent_mng_id, rent_l_cd) b, "+
				"	       cont c, \n"+
                "          (SELECT * FROM CLS_CONT WHERE cls_dt>'20091231' AND cls_st IN ('4','5')) d \n"+
				"    where a.rent_mng_id=b.rent_mng_id(+) and a.rent_l_cd=b.rent_l_cd(+) "+ 
				"          and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"+
				"          and nvl(a.dly_fee,0)-nvl(b.pay_amt,0)<>0 AND c.rent_l_cd not like 'RM%' \n"+
                "          AND c.rent_mng_id=d.rent_mng_id(+) AND c.rent_l_cd=d.rent_l_cd(+) and DECODE(d.cls_st,'4','Y','5','Y',c.use_yn)='Y' \n"+
				" ) a, car_reg b, client c, users d, "+
				"   	cms_mng e, cls_cont f, (select rent_mng_id, rent_l_cd, max(seq) seq from cms_mng group by rent_mng_id, rent_l_cd) h, cust g, \n"+
				" ( select a.rent_mng_id, a.rent_l_cd, case when a.reg_dt = b.p_reg_dt then a.promise_dt else '' end promise_dt from  \n"+
			    "          ( select rent_mng_id, rent_l_cd, max(reg_dt) reg_dt, max(promise_dt) promise_dt from dly_mm  group by rent_mng_id, rent_l_cd ) a, \n"+
				"          ( select rent_mng_id, rent_l_cd, max(reg_dt) p_reg_dt from dly_mm where promise_dt is not null group by rent_mng_id, rent_l_cd ) b \n"+
				"   where a.rent_mng_id = b.rent_mng_id(+) and a.rent_l_cd = b.rent_l_cd(+)  \n"+
				" ) p \n"+ 
				" where "+
                " "; 

				if(!bus_id2.equals("")) 	query += "	a.bus_id2='"+bus_id2+"' ";

				if(!bus_id2.equals("") && !rent_l_cd.equals("")) 	query += " and ";

				if(!rent_l_cd.equals("")) 	query += "	a.rent_l_cd='"+rent_l_cd+"' ";


				query += "	and a.car_mng_id=b.car_mng_id(+) and a.client_id=c.client_id(+) and a.bus_id2=d.user_id and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+)\n"+
				"       and a.rent_mng_id=f.rent_mng_id(+) and a.rent_l_cd=f.rent_l_cd(+) "+
				"	    and e.rent_mng_id=h.rent_mng_id(+) and e.rent_l_cd=h.rent_l_cd(+) and e.seq=h.seq(+) and e.rent_l_cd=g.code(+) "+
				"       and a.rent_mng_id=p.rent_mng_id(+) and a.rent_l_cd=p.rent_l_cd(+) "+
				" order by a.sort, a.use_yn, a.client_id, a.car_mng_id, a.est_dt "+
				" ";
		 
		try {
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
			System.out.println("[SettleDatabase:getStatSettleSubList]\n"+e);
			System.out.println("[SettleDatabase:getStatSettleSubList]\n"+query);
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

  
  public Vector getSettleBrList()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

/*
		query = " select DECODE(grouping_id (b.br_id, c.br_nm, b.loan_st), 0, c.br_nm,'3','소계','7','합계') br_nm , b.br_id, DECODE(grouping_id (b.br_id, c.br_nm, b.loan_st), 0, decode(b.loan_st ,'1', '고객지원', '영업' ),'-') loan_nm,  \n" +
					 "		 count(a.bus_id2) p_cnt,  sum(a.tot_amt) tot_amt, sum(a.amt) dly_amt ,  \n " +
					 "   decode(b.br_id, 'S1', 1, 'S3', 1, 'S4', 1 , 2) r_cnt, \n " + 
		
					 "		  trunc(avg(a.per1),3) per1 ,  \n " +
					 "		 trunc(avg(a.avg_per),3) avg_per ,  \n " +
					 "		 trunc(avg(a.cmp_per),3) cmp_per ,  \n " +
					 "		 trunc(avg(a.r_cmp_per),3) r_cmp_per  \n  " +
					"	from stat_settle a, users b , branch c , ( select max(save_dt) save_dt from stat_settle ) d  \n " +
					"		where a.save_dt = d.save_dt  and a.bus_id2 = b.user_id  \n " +
					"		  and b.br_id = c.br_id and b.loan_st in ('1', '2')   \n" +
					"		group by GROUPING sets ((b.br_id, c.br_nm, b.loan_st), (b.br_id) ,() )  \n " +
					"		order by b.br_id, b.loan_st ";	
*/
	
	/*		
			query = " select DECODE(grouping_id (b.br_id, c.br_nm, b.loan_st), 0, c.br_nm,'3','소계','7','합계') br_nm , \n " + 
						 "  	  b.br_id, DECODE(grouping_id (b.br_id, c.br_nm, b.loan_st), 0, decode(b.loan_st ,'1', '고객지원', '영업' ),'-') loan_nm,  \n " + 
						 "		  count(a.bus_id2) p_cnt, \n " + 
						 "	     sum(decode(b.loan_st , '1', a.tot_amt , 0 )) tot_amt, \n " + 
						 "	     sum(decode(b.loan_st, '1', a.amt, 0 )) dly_amt ,  \n " + 
						 "		  decode(b.br_id, 'S1', 1, 'S3', 1, 'S4', 1 , 2) r_cnt, \n " + 
						 "		  trunc(avg(a.per1),3) per1 , \n " + 
						 "		  trunc(avg(a.avg_per),3) avg_per ,   \n " + 
						 "		  trunc(avg(a.cmp_per),3) cmp_per ,   \n " + 
						 "		  trunc(avg(a.r_cmp_per),3) r_cmp_per  \n " + 
						 "	 from stat_settle a, users b , branch c , \n " + 
						 "	     ( select max(save_dt) save_dt from stat_settle ) d  \n " + 
						 "		 	 where a.save_dt = d.save_dt  and a.bus_id2 = b.user_id  \n " + 
						 "	    	    and b.br_id = c.br_id and b.loan_st in ('1', '2')  \n " + 
						 "	           and b.br_id not in ( 'S1' ) \n " + 
						 "		 group by GROUPING sets ((b.br_id, c.br_nm, b.loan_st), (b.br_id) ,() ) \n " + 
						 "	order by b.br_id, b.loan_st ";
*/

					query = " 	select b.br_id,    c.br_nm ,  decode(b.br_id, 'S1', 1, 'S3', 1, 'S4', 1 , 2) r_cnt, \n " + 
						       "	 trunc(avg(a.r_cmp_per),3) r_cmp_per  , \n " + 
					    		 "  	 sum(decode(b.loan_st , '1', 1, 0)) p1_cnt,  sum(decode(b.loan_st , '2', 1, 0)) p2_cnt,  \n " + 
					    			"	 trunc(avg(a.r_cmp_per),3) r_cmp_per  , \n " + 
								 "    	 sum(decode(b.loan_st , '1', a.tot_amt , 0 )) tot_amt,   \n " + 
								 "		 sum(decode(b.loan_st, '1', a.amt, 0 )) dly_amt ,   \n " + 
								 "			 trunc(avg(a.per1),3) per1 ,  \n " + 
								 "			 trunc(avg(a.avg_per),3) avg_per ,   \n " + 
								 "			 trunc(avg(a.cmp_per),3) cmp_per    \n " + 
								 "		 from stat_settle a, users b , branch c ,  \n " + 
								 "		      ( select max(save_dt) save_dt from stat_settle ) d   \n " + 
								 "				where a.save_dt = d.save_dt  and a.bus_id2 = b.user_id   \n " + 
								 "		    	  and b.br_id = c.br_id and b.loan_st in ('1', '2')   \n " + 
								 "		          and b.br_id not in ( 'S1' )	 and b.user_id not in ( '000163' )  \n " + 
								 "		    group by b.br_id  ,    c.br_nm    \n " + 
								 "		order by 4, 3, b.br_id";

		
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
			System.out.println("[SettleDatabase:getSettleBrList]\n"+e);
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

  	public Vector getContList2(String client_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select * from cont where client_id='"+client_id+"' " ;
																		
		
		try {
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
			System.out.println("[SettleDatabase:getContList2]\n"+e);
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

  	/**
	*	채권캠페인 실제 마감데이타 (마감 포상시 생성) 
	*/
	
	public int insertMagamSettle(String save_dt )
	{
			
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = " insert into  STAT_SETTLE_MAGAM   select * from STAT_SETTLE where  save_dt = ? " ;                
		
		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, save_dt);
					
			result = pstmt.executeUpdate();
	
			pstmt.close();
			conn.commit();
	
		}catch(SQLException e){
			System.out.println("[insertMagamSettle]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
	            if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return result;
		}
	}
  	
}

