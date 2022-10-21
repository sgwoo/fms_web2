package acar.account;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;

public class AccountDatabase
{
	private Connection conn = null;
	public static AccountDatabase db;
	
	public static AccountDatabase getInstance()
	{
		if(AccountDatabase.db == null)
			AccountDatabase.db = new AccountDatabase();
		return AccountDatabase.db;
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
	

	//수금현황-----------------------------------------------------------------------------------------------

	/**
	 *	수금현황-대여료
	 */
	public Vector getFeeStat(String br_id, String search_kd, String brch_id, String bus_id2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";
		String dt1 = "to_char(sysdate,'YYYYMM')";
		String dt2 = "to_char(sysdate,'YYYYMMDD')";

		sub_query = "select a.fee_est_dt, a.r_fee_est_dt, a.rc_yn, a.rc_dt, decode(a.rc_yn, '0', a.fee_s_amt+a.fee_v_amt, a.rc_amt) fee_amt from scd_fee a, cont b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.bill_yn,'Y')='Y' and a.tm_st2<>'4' and a.fee_s_amt>0 and b.car_st in ('1','3') ";// and nvl(b.use_yn,'Y')='Y'

		if(search_kd.equals("1"))		sub_query += " and b.brch_id='"+brch_id+"'";
		else if(search_kd.equals("2"))	sub_query += " and b.bus_id2='"+bus_id2+"'";

		query = " select '계획' gubun, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(fee_amt),0) tot_amt1 from ("+sub_query+") where r_fee_est_dt like "+dt1+"||'%' ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(fee_amt),0) tot_amt2 from ("+sub_query+") where (r_fee_est_dt = "+dt2+" and (rc_yn='0' or rc_dt = "+dt2+") or (r_fee_est_dt >= "+dt2+" and rc_dt = "+dt2+")) ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(fee_amt),0) tot_amt3 from ("+sub_query+") where r_fee_est_dt < "+dt2+" and (rc_yn='0' or rc_dt = "+dt2+") ) c\n"+
				" union all\n"+
				" select '수금' gubun, a.*, b.*, c.*\n"+
				" from\n"+
					" ( select count(*) tot_su1, nvl(sum(fee_amt),0) tot_amt1 from ("+sub_query+") where r_fee_est_dt like "+dt1+"||'%' and rc_yn='1' ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(fee_amt),0) tot_amt2 from ("+sub_query+") where r_fee_est_dt >= "+dt2+" and rc_dt = "+dt2+" ) b,\n"+ 
					" ( select count(*) tot_su3, nvl(sum(fee_amt),0) tot_amt3 from ("+sub_query+") where r_fee_est_dt < "+dt2+" and rc_dt = "+dt2+" ) c\n"+
				" union all\n"+
				" select '미수금' gubun, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(fee_amt),0) tot_amt1 from ("+sub_query+") where r_fee_est_dt like "+dt1+"||'%' and r_fee_est_dt <= "+dt2+" and rc_yn='0' ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(fee_amt),0) tot_amt2 from ("+sub_query+") where r_fee_est_dt = "+dt2+" and rc_yn = '0' ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(fee_amt),0) tot_amt3 from ("+sub_query+") where r_fee_est_dt < "+dt2+" and rc_yn = '0' ) c\n"+
				" union all\n"+
				" select '수금율' gubun, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select decode(a.tot_su1, 0,0, to_number(to_char((b.tot_su1/a.tot_su1)*100, 999.99))) tot_su1, decode(a.tot_amt1, 0,0, to_number(to_char((b.tot_amt1/a.tot_amt1)*100, 999.99))) tot_amt1 from\n"+ 
						" ( select count(*) tot_su1, nvl(sum(fee_amt),0) tot_amt1 from ("+sub_query+") where r_fee_est_dt like "+dt1+"||'%' ) a,\n"+
						" ( select count(*) tot_su1, nvl(sum(fee_amt),0) tot_amt1 from ("+sub_query+") where r_fee_est_dt like "+dt1+"||'%' and rc_yn='1' ) b\n"+
					" ) a,\n"+
					" ( select decode(a.tot_su2, 0,0, to_number(to_char((b.tot_su2/a.tot_su2)*100, 999.99))) tot_su2, decode(a.tot_amt2, 0,0, to_number(to_char((b.tot_amt2/a.tot_amt2)*100, 999.99))) tot_amt2 from\n"+ 
						" ( select count(*) tot_su2, nvl(sum(fee_amt),0) tot_amt2 from ("+sub_query+") where (r_fee_est_dt = "+dt2+" and (rc_yn='0' or rc_dt = "+dt2+") or (r_fee_est_dt >= "+dt2+" and rc_dt = "+dt2+")) ) a,\n"+	
						" ( select count(*) tot_su2, nvl(sum(fee_amt),0) tot_amt2 from ("+sub_query+") where r_fee_est_dt >= "+dt2+" and rc_dt = "+dt2+" ) b\n"+ 
					" ) b,\n"+
					" ( select decode(a.tot_su3, 0,0, to_number(to_char((b.tot_su3/a.tot_su3)*100, 999.99))) tot_su3, decode(a.tot_amt3, 0,0, to_number(to_char((b.tot_amt3/a.tot_amt3)*100, 999.99))) tot_amt3 from\n"+ 
						" ( select count(*) tot_su3, nvl(sum(fee_amt),0) tot_amt3 from ("+sub_query+") where r_fee_est_dt < "+dt2+" and (rc_yn='0' or rc_dt = "+dt2+") ) a,\n"+
						" ( select count(*) tot_su3, nvl(sum(fee_amt),0) tot_amt3 from ("+sub_query+") where r_fee_est_dt < "+dt2+" and rc_dt = "+dt2+" ) b\n"+
					" ) c"+
				" union all\n"+
				" select '예정' gubun, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(fee_amt),0) tot_amt1 from ("+sub_query+") where r_fee_est_dt like "+dt1+"||'%' and r_fee_est_dt > "+dt2+" and rc_yn='0' ) a,\n"+
					" ( select 0 tot_su2, 0 tot_amt2 from dual ) b,\n"+	
					" ( select 0 tot_su3, 0 tot_amt3 from dual ) c\n"+
                " "; 

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			while(rs.next())
			{
				IncomingSBean fee = new IncomingSBean();
				fee.setGubun(rs.getString(1));
				fee.setTot_su1(rs.getString(2));
				fee.setTot_amt1(rs.getString(3));
				fee.setTot_su2(rs.getString(4));
				fee.setTot_amt2(rs.getString(5));
				fee.setTot_su3(rs.getString(6));
				fee.setTot_amt3(rs.getString(7));
				vt.add(fee);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AccountDatabase:getFeeStat]"+e);
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
	 *	수금현황-대여료 연체율
	 */
	public Vector getFeeStat_Dlyper(String br_id, String search_kd, String brch_id, String bus_id2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";
		String dt1 = "to_char(sysdate,'YYYYMM')";
		String dt2 = "to_char(sysdate,'YYYYMMDD')";
		
		sub_query = " select a.* "+
					" from scd_fee a, cont b"+ 
					" where a.fee_s_amt>0 and nvl(a.bill_yn,'Y')='Y' and a.tm_st2<>'4' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd "+ 
					" and b.car_st in ('1','3')"; 

		if(search_kd.equals("1"))		sub_query += " and b.brch_id='"+brch_id+"'";
		else if(search_kd.equals("2"))	sub_query += " and b.bus_id2='"+bus_id2+"'";

		query = " select nvl(a.tot_amt,0) tot_amt, nvl(b.dly_amt,0) dly_amt, decode(nvl(b.dly_amt,0),0,0, to_number(to_char((b.dly_amt/a.tot_amt)*100, 999.99))) dly_per from"+
				"	( select sum(fee_s_amt+fee_v_amt) tot_amt from ("+sub_query+") where rc_yn='0' ) a,"+
				"	( select sum(fee_s_amt+fee_v_amt) dly_amt from ("+sub_query+") where rc_yn='0' and r_fee_est_dt < "+dt2+" ) b";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			while(rs.next())
			{
				IncomingSBean fee = new IncomingSBean();
				fee.setTot_amt1(rs.getString(1));
				fee.setTot_amt2(rs.getString(2));
				fee.setTot_su1(rs.getString(3));
				vt.add(fee);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AccountDatabase:getFeeStat_Dlyper]"+e);
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
	 *	수금현황-대여료 연체율
	 */
	public Vector getFeeStat_Dlyper(String br_id, String search_kd, String brch_id, String bus_id2, String dept_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";
		String dt1 = "to_char(sysdate,'YYYYMM')";
		String dt2 = "to_char(sysdate,'YYYYMMDD')";
		
		sub_query = " select a.* "+
					" from scd_fee a, cont b, users d"+ 
					" where a.fee_s_amt>0 and nvl(a.bill_yn,'Y')='Y' and a.tm_st2<>'4' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd "+ 
					" and b.bus_id2=d.user_id(+)"+
					" and b.car_st in ('1','3')"; 

		if(search_kd.equals("1"))		sub_query += " and b.brch_id='"+brch_id+"'";
		else if(search_kd.equals("2"))	sub_query += " and b.bus_id2='"+bus_id2+"'";

		if(!dept_id.equals(""))		sub_query += " and d.dept_id='"+dept_id+"'";

		query = " select nvl(a.tot_amt,0) tot_amt, nvl(b.dly_amt,0) dly_amt, decode(nvl(b.dly_amt,0),0,0, to_number(to_char((b.dly_amt/a.tot_amt)*100, 999.99))) dly_per from"+
				"	( select sum(fee_s_amt+fee_v_amt) tot_amt from ("+sub_query+") where rc_yn='0' ) a,"+
				"	( select sum(fee_s_amt+fee_v_amt) dly_amt from ("+sub_query+") where rc_yn='0' and r_fee_est_dt < "+dt2+" ) b";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			while(rs.next())
			{
				IncomingSBean fee = new IncomingSBean();
				fee.setTot_amt1(rs.getString(1));
				fee.setTot_amt2(rs.getString(2));
				fee.setTot_su1(rs.getString(3));
				vt.add(fee);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AccountDatabase:getFeeStat_Dlyper2]"+e);
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
	 *	수금현황-대여료 연체율
	 */
	public IncomingSBean getFeeStat_DlyperDept(String br_id, String search_kd, String brch_id, String bus_id2, String dept_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		IncomingSBean fee = new IncomingSBean();
		String query = "";
		String sub_query = "";
		String dt1 = "to_char(sysdate,'YYYYMM')";
		String dt2 = "to_char(sysdate,'YYYYMMDD')";
		
		sub_query = " select a.* "+
					" from scd_fee a, cont b, cls_cont c, users d"+
					" where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_l_cd=c.rent_l_cd(+)"+
					" and b.bus_id2=d.user_id and nvl(a.bill_yn,'Y')='Y' and a.tm_st2<>'4' "+
					" and nvl(c.cls_st,'0')<>'2' and d.user_pos='사원'";

		if(search_kd.equals("1"))		sub_query += " and b.brch_id='"+brch_id+"'";
		else if(search_kd.equals("2"))	sub_query += " and b.bus_id2='"+bus_id2+"'";

		if(!dept_id.equals(""))		sub_query += " and d.dept_id='"+dept_id+"'";

		query = " select nvl(a.tot_amt,0) tot_amt, nvl(b.dly_amt,0) dly_amt, decode(nvl(b.dly_amt,0),0,0, to_number(to_char((b.dly_amt/a.tot_amt)*100, 999.99))) dly_per from"+
				"	( select sum(fee_s_amt+fee_v_amt) tot_amt from ("+sub_query+") where rc_yn='0' ) a,"+
				"	( select sum(fee_s_amt+fee_v_amt) dly_amt from ("+sub_query+") where rc_yn='0' and r_fee_est_dt < "+dt2+" ) b";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			if(rs.next())
			{
				fee.setTot_amt1(rs.getString(1));
				fee.setTot_amt2(rs.getString(2));
				fee.setTot_su1(rs.getString(3));
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AccountDatabase:getFeeStat_DlyperDept]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return fee;
		}
	}	

	/**
	 *	수금현황-선수금
	 */
	public Vector getPreStat(String br_id, String search_kd, String brch_id, String bus_id2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";
		String dt1 = "to_char(sysdate,'YYYYMM')";
		String dt2 = "to_char(sysdate,'YYYYMMDD')";
		
		sub_query = " select a.*, b.dlv_dt from scd_pre a, cont b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
					" and nvl(b.use_yn,'Y')='Y' and a.pp_s_amt > 0 and nvl(a.bill_yn,'Y')='Y'";

		if(search_kd.equals("1"))		sub_query += " and b.brch_id='"+brch_id+"'";
		else if(search_kd.equals("2"))	sub_query += " and b.bus_id2='"+bus_id2+"'";

		query = " select '계획' gubun, '선납금' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(decode(pp_pay_amt,0,pp_s_amt+pp_v_amt,pp_pay_amt)),0) tot_amt1 from ("+sub_query+") where pp_st='1' and pp_est_dt like "+dt1+"||'%' ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(decode(pp_pay_amt,0,pp_s_amt+pp_v_amt,pp_pay_amt)),0) tot_amt2 from ("+sub_query+") where pp_st='1' and (pp_est_dt = "+dt2+" or pp_pay_dt = "+dt2+") ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(decode(pp_pay_amt,0,pp_s_amt+pp_v_amt,pp_pay_amt)),0) tot_amt3 from ("+sub_query+") where pp_st='1' and pp_est_dt < "+dt2+" and (pp_pay_dt is null or pp_pay_dt = "+dt2+") ) c\n"+
				" union all\n"+
				" select '계획' gubun, '보증금' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(decode(pp_pay_amt,0,pp_s_amt+pp_v_amt,pp_pay_amt)),0) tot_amt1 from ("+sub_query+") where pp_st='0' and pp_est_dt like "+dt1+"||'%' ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(decode(pp_pay_amt,0,pp_s_amt+pp_v_amt,pp_pay_amt)),0) tot_amt2 from ("+sub_query+") where pp_st='0' and (pp_est_dt = "+dt2+" or pp_pay_dt = "+dt2+") ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(decode(pp_pay_amt,0,pp_s_amt+pp_v_amt,pp_pay_amt)),0) tot_amt3 from ("+sub_query+") where pp_st='0' and pp_est_dt < "+dt2+" and (pp_pay_dt is null or pp_pay_dt = "+dt2+") ) c\n"+
				" union all\n"+
				" select '계획' gubun, '개시대여료' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(decode(pp_pay_amt,0,pp_s_amt+pp_v_amt,pp_pay_amt)),0) tot_amt1 from ("+sub_query+") where pp_st='2' and pp_est_dt like "+dt1+"||'%' ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(decode(pp_pay_amt,0,pp_s_amt+pp_v_amt,pp_pay_amt)),0) tot_amt2 from ("+sub_query+") where pp_st='2' and (pp_est_dt = "+dt2+" or pp_pay_dt = "+dt2+") ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(decode(pp_pay_amt,0,pp_s_amt+pp_v_amt,pp_pay_amt)),0) tot_amt3 from ("+sub_query+") where pp_st='2' and pp_est_dt < "+dt2+" and (pp_pay_dt is null or pp_pay_dt = "+dt2+") ) c\n"+
				" union all\n"+								
				" select '소계' gubun, 'N' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(decode(pp_pay_amt,0,pp_s_amt+pp_v_amt,pp_pay_amt)),0) tot_amt1 from ("+sub_query+") where pp_est_dt like "+dt1+"||'%' ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(decode(pp_pay_amt,0,pp_s_amt+pp_v_amt,pp_pay_amt)),0) tot_amt2 from ("+sub_query+") where (pp_est_dt = "+dt2+" or pp_pay_dt = "+dt2+") ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(decode(pp_pay_amt,0,pp_s_amt+pp_v_amt,pp_pay_amt)),0) tot_amt3 from ("+sub_query+") where pp_est_dt < "+dt2+" and (pp_pay_dt is null or pp_pay_dt = "+dt2+") ) c\n"+
				" union all\n"+								
				" select '수금' gubun, '선납금' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(pp_pay_amt),0) tot_amt1 from ("+sub_query+") where pp_st='1' and pp_est_dt like "+dt1+"||'%' and pp_pay_dt is not null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(pp_pay_amt),0) tot_amt2 from ("+sub_query+") where pp_st='1' and pp_pay_dt = "+dt2+" ) b,\n"+	//pp_est_dt = to_char(sysdate,'YYYYMMDD') and 
					" ( select count(*) tot_su3, nvl(sum(pp_pay_amt),0) tot_amt3 from ("+sub_query+") where pp_st='1' and pp_est_dt < "+dt2+" and pp_pay_dt = "+dt2+" ) c\n"+
				" union all\n"+
				" select '수금' gubun, '보증금' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(pp_pay_amt),0) tot_amt1 from ("+sub_query+") where pp_st='0' and pp_est_dt like "+dt1+"||'%' and pp_pay_dt is not null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(pp_pay_amt),0) tot_amt2 from ("+sub_query+") where pp_st='0' and pp_pay_dt = "+dt2+" ) b,\n"+	//pp_est_dt = to_char(sysdate,'YYYYMMDD') and 
					" ( select count(*) tot_su3, nvl(sum(pp_pay_amt),0) tot_amt3 from ("+sub_query+") where pp_st='0' and pp_est_dt < "+dt2+" and pp_pay_dt = "+dt2+" ) c\n"+
				" union all\n"+
				" select '수금' gubun, '개시대여료' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(pp_pay_amt),0) tot_amt1 from ("+sub_query+") where pp_st='2' and pp_est_dt like "+dt1+"||'%' and pp_pay_dt is not null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(pp_pay_amt),0) tot_amt2 from ("+sub_query+") where pp_st='2' and pp_pay_dt = "+dt2+" ) b,\n"+	//pp_est_dt = to_char(sysdate,'YYYYMMDD') and 
					" ( select count(*) tot_su3, nvl(sum(pp_pay_amt),0) tot_amt3 from ("+sub_query+") where pp_st='2' and pp_est_dt < "+dt2+" and pp_pay_dt = "+dt2+" ) c\n"+
				" union all\n"+				
				" select '소계' gubun, 'N' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(pp_pay_amt),0) tot_amt1 from ("+sub_query+") where pp_est_dt like "+dt1+"||'%' and pp_pay_dt is not null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(pp_pay_amt),0) tot_amt2 from ("+sub_query+") where pp_pay_dt = "+dt2+" ) b,\n"+	//pp_est_dt = to_char(sysdate,'YYYYMMDD') and 
					" ( select count(*) tot_su3, nvl(sum(pp_pay_amt),0) tot_amt3 from ("+sub_query+") where pp_est_dt < "+dt2+" and pp_pay_dt = "+dt2+" ) c\n"+
				" union all\n"+				
				" select '미수금' gubun, '선납금' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(pp_s_amt+pp_v_amt),0) tot_amt1 from ("+sub_query+") where pp_st='1' and pp_est_dt like "+dt1+"||'%' and pp_pay_dt is null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(pp_s_amt+pp_v_amt),0) tot_amt2 from ("+sub_query+") where pp_st='1' and pp_est_dt = "+dt2+" and pp_pay_dt is null ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(pp_s_amt+pp_v_amt),0) tot_amt3 from ("+sub_query+") where pp_st='1' and pp_est_dt < "+dt2+" and pp_pay_dt is null ) c\n"+
				" union all\n"+
				" select '미수금' gubun, '보증금' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(pp_s_amt+pp_v_amt),0) tot_amt1 from ("+sub_query+") where pp_st='0' and pp_est_dt like "+dt1+"||'%' and pp_pay_dt is null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(pp_s_amt+pp_v_amt),0) tot_amt2 from ("+sub_query+") where pp_st='0' and pp_est_dt = "+dt2+" and pp_pay_dt is null ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(pp_s_amt+pp_v_amt),0) tot_amt3 from ("+sub_query+") where pp_st='0' and pp_est_dt < "+dt2+" and pp_pay_dt is null ) c\n"+
				" union all\n"+
				" select '미수금' gubun, '개시대여료' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(pp_s_amt+pp_v_amt),0) tot_amt1 from ("+sub_query+") where pp_st='2' and pp_est_dt like "+dt1+"||'%' and pp_pay_dt is null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(pp_s_amt+pp_v_amt),0) tot_amt2 from ("+sub_query+") where pp_st='2' and pp_est_dt = "+dt2+" and pp_pay_dt is null ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(pp_s_amt+pp_v_amt),0) tot_amt3 from ("+sub_query+") where pp_st='2' and pp_est_dt < "+dt2+" and pp_pay_dt is null ) c\n"+
				" union all\n"+								
				" select '소계' gubun, 'N' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(pp_s_amt+pp_v_amt),0) tot_amt1 from ("+sub_query+") where pp_est_dt like "+dt1+"||'%' and pp_pay_dt is null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(pp_s_amt+pp_v_amt),0) tot_amt2 from ("+sub_query+") where pp_est_dt = "+dt2+" and pp_pay_dt is null ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(pp_s_amt+pp_v_amt),0) tot_amt3 from ("+sub_query+") where pp_est_dt < "+dt2+" and pp_pay_dt is null ) c\n"+
				" union all\n"+								
				" select '비율' gubun, 'N' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select decode(a.tot_su1, 0,0, to_number(to_char((b.tot_su1/a.tot_su1)*100, 999.99))) tot_su1, decode(a.tot_amt1, 0,0, to_number(to_char((b.tot_amt1/a.tot_amt1)*100, 999.99))) tot_amt1 from\n"+ 
						" ( select count(*) tot_su1, nvl(sum(pp_s_amt+pp_v_amt),0) tot_amt1 from ("+sub_query+") where pp_est_dt like "+dt1+"||'%' ) a,\n"+
						" ( select count(*) tot_su1, nvl(sum(pp_s_amt+pp_v_amt),0) tot_amt1 from ("+sub_query+") where pp_est_dt like "+dt1+"||'%' and pp_pay_dt is not null ) b\n"+
					" ) a,\n"+ 
					" ( select decode(a.tot_su2, 0,0, to_number(to_char((b.tot_su2/a.tot_su2)*100, 999.99))) tot_su2, decode(a.tot_amt2, 0,0, to_number(to_char((b.tot_amt2/a.tot_amt2)*100, 999.99))) tot_amt2 from \n"+
						" ( select count(*) tot_su2, nvl(sum(pp_s_amt+pp_v_amt),0) tot_amt2 from ("+sub_query+") where (pp_est_dt = "+dt2+" or pp_pay_dt = "+dt2+") ) a,\n"+	
						" ( select count(*) tot_su2, nvl(sum(pp_s_amt+pp_v_amt),0) tot_amt2 from ("+sub_query+") where pp_pay_dt = "+dt2+" ) b\n"+	 
					" ) b,\n"+ 
					" ( select decode(a.tot_su3, 0,0, to_number(to_char((b.tot_su3/a.tot_su3)*100, 999.99))) tot_su3, decode(a.tot_amt3, 0,0, to_number(to_char((b.tot_amt3/a.tot_amt3)*100, 999.99))) tot_amt3 from \n"+
						" ( select count(*) tot_su3, nvl(sum(pp_s_amt+pp_v_amt),0) tot_amt3 from ("+sub_query+") where pp_est_dt < "+dt2+" and (pp_pay_dt is null or pp_pay_dt = "+dt2+") ) a,\n"+
						" ( select count(*) tot_su3, nvl(sum(pp_s_amt+pp_v_amt),0) tot_amt3 from ("+sub_query+") where pp_est_dt < "+dt2+" and pp_pay_dt = "+dt2+" ) b\n"+
					" ) c";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			while(rs.next())
			{
				IncomingSBean pre = new IncomingSBean();
				pre.setGubun(rs.getString(1));
				pre.setGubun_sub(rs.getString(2));
				pre.setTot_su1(rs.getString(3));
				pre.setTot_amt1(rs.getString(4));
				pre.setTot_su2(rs.getString(5));
				pre.setTot_amt2(rs.getString(6));
				pre.setTot_su3(rs.getString(7));
				pre.setTot_amt3(rs.getString(8));
				vt.add(pre);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AccountDatabase:getPreStat]"+e);
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
	 *	수금현황-선수금 : 대여개시여부에 따른 연체 관리
	 */
	public Vector getPreStat2(String br_id, String search_kd, String brch_id, String bus_id2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";
		String dt1 = "to_char(sysdate,'YYYYMM')";
		String dt2 = "to_char(sysdate,'YYYYMMDD')";
		
		sub_query = " select a.*, b.dlv_dt, decode(a.ext_st,'5',e.rent_suc_dt,c.rent_start_dt) rent_start_dt "+
					" from   scd_ext a, cont b, fee c, cont_etc e "+
					" where  a.ext_st in ('0', '1', '2', '5' ) and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and a.rent_st=c.rent_st"+
					"        and b.rent_mng_id=e.rent_mng_id(+) and b.rent_l_cd=e.rent_l_cd(+)"+
					"        and a.ext_s_amt <> 0 and nvl(a.bill_yn,'Y')='Y'"; 

		query = " select '계획' gubun, '선납금' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(decode(ext_pay_amt,0,ext_s_amt+ext_v_amt,ext_pay_amt)),0) tot_amt1 from ("+sub_query+") where ext_st='1' and nvl(nvl(ext_est_dt,ext_pay_dt),to_char(sysdate,'YYYYMM')) like "+dt1+"||'%' ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(decode(ext_pay_amt,0,ext_s_amt+ext_v_amt,ext_pay_amt)),0) tot_amt2 from ("+sub_query+") where ext_st='1' and nvl(ext_est_dt,ext_pay_dt) = "+dt2+") b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(decode(ext_pay_amt,0,ext_s_amt+ext_v_amt,ext_pay_amt)),0) tot_amt3 from ("+sub_query+") where ext_st='1' and rent_start_dt < "+dt2+" and (ext_pay_dt is null or ext_pay_dt = "+dt2+") ) c\n"+
				" union all\n"+
				" select '계획' gubun, '보증금' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(decode(ext_pay_amt,0,ext_s_amt+ext_v_amt,ext_pay_amt)),0) tot_amt1 from ("+sub_query+") where ext_st='0' and nvl(nvl(ext_est_dt,ext_pay_dt),to_char(sysdate,'YYYYMM')) like "+dt1+"||'%' ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(decode(ext_pay_amt,0,ext_s_amt+ext_v_amt,ext_pay_amt)),0) tot_amt2 from ("+sub_query+") where ext_st='0' and nvl(ext_est_dt,ext_pay_dt) = "+dt2+" ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(decode(ext_pay_amt,0,ext_s_amt+ext_v_amt,ext_pay_amt)),0) tot_amt3 from ("+sub_query+") where ext_st='0' and rent_start_dt < "+dt2+" and (ext_pay_dt is null or ext_pay_dt = "+dt2+") ) c\n"+
				" union all\n"+
				" select '계획' gubun, '개시대여료' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(decode(ext_pay_amt,0,ext_s_amt+ext_v_amt,ext_pay_amt)),0) tot_amt1 from ("+sub_query+") where ext_st='2' and nvl(nvl(ext_est_dt,ext_pay_dt),to_char(sysdate,'YYYYMM')) like "+dt1+"||'%' ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(decode(ext_pay_amt,0,ext_s_amt+ext_v_amt,ext_pay_amt)),0) tot_amt2 from ("+sub_query+") where ext_st='2' and nvl(ext_est_dt,ext_pay_dt) = "+dt2+") b,\n"+
					" ( select count(*) tot_su3, nvl(sum(decode(ext_pay_amt,0,ext_s_amt+ext_v_amt,ext_pay_amt)),0) tot_amt3 from ("+sub_query+") where ext_st='2' and rent_start_dt < "+dt2+" and (ext_pay_dt is null or ext_pay_dt = "+dt2+") ) c\n"+
				" union all\n"+								
				" select '계획' gubun, '승계수수료' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(decode(ext_pay_amt,0,ext_s_amt+ext_v_amt,ext_pay_amt)),0) tot_amt1 from ("+sub_query+") where ext_st='5' and nvl(nvl(ext_est_dt,ext_pay_dt),to_char(sysdate,'YYYYMM')) like "+dt1+"||'%' ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(decode(ext_pay_amt,0,ext_s_amt+ext_v_amt,ext_pay_amt)),0) tot_amt2 from ("+sub_query+") where ext_st='5' and nvl(ext_est_dt,ext_pay_dt) = "+dt2+") b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(decode(ext_pay_amt,0,ext_s_amt+ext_v_amt,ext_pay_amt)),0) tot_amt3 from ("+sub_query+") where ext_st='5' and rent_start_dt < "+dt2+" and (ext_pay_dt is null or ext_pay_dt = "+dt2+") ) c\n"+
				" union all\n"+								
				" select '소계' gubun, 'N' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(decode(ext_pay_amt,0,ext_s_amt+ext_v_amt,ext_pay_amt)),0) tot_amt1 from ("+sub_query+") where nvl(nvl(ext_est_dt,ext_pay_dt),to_char(sysdate,'YYYYMM')) like "+dt1+"||'%' ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(decode(ext_pay_amt,0,ext_s_amt+ext_v_amt,ext_pay_amt)),0) tot_amt2 from ("+sub_query+") where nvl(ext_est_dt,ext_pay_dt) = "+dt2+" ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(decode(ext_pay_amt,0,ext_s_amt+ext_v_amt,ext_pay_amt)),0) tot_amt3 from ("+sub_query+") where rent_start_dt < "+dt2+" and (ext_pay_dt is null or ext_pay_dt = "+dt2+") ) c\n"+
				" union all\n"+								
				" select '수금' gubun, '선납금' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(ext_pay_amt),0) tot_amt1 from ("+sub_query+") where ext_st='1' and nvl(nvl(ext_est_dt,ext_pay_dt),to_char(sysdate,'YYYYMM')) like "+dt1+"||'%' and ext_pay_dt is not null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(ext_pay_amt),0) tot_amt2 from ("+sub_query+") where ext_st='1' and ext_pay_dt is not null and nvl(ext_est_dt,ext_pay_dt) = "+dt2+" ) b,\n"+	 
					" ( select count(*) tot_su3, nvl(sum(ext_pay_amt),0) tot_amt3 from ("+sub_query+") where ext_st='1' and rent_start_dt < "+dt2+" and ext_pay_dt = "+dt2+" ) c\n"+
				" union all\n"+
				" select '수금' gubun, '보증금' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(ext_pay_amt),0) tot_amt1 from ("+sub_query+") where ext_st='0' and nvl(nvl(ext_est_dt,ext_pay_dt),to_char(sysdate,'YYYYMM')) like "+dt1+"||'%' and ext_pay_dt is not null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(ext_pay_amt),0) tot_amt2 from ("+sub_query+") where ext_st='0' and ext_pay_dt is not null and nvl(ext_est_dt,ext_pay_dt) = "+dt2+" ) b,\n"+	 
					" ( select count(*) tot_su3, nvl(sum(ext_pay_amt),0) tot_amt3 from ("+sub_query+") where ext_st='0' and rent_start_dt < "+dt2+" and ext_pay_dt = "+dt2+" ) c\n"+
				" union all\n"+
				" select '수금' gubun, '개시대여료' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(ext_pay_amt),0) tot_amt1 from ("+sub_query+") where ext_st='2' and nvl(nvl(ext_est_dt,ext_pay_dt),to_char(sysdate,'YYYYMM')) like "+dt1+"||'%' and ext_pay_dt is not null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(ext_pay_amt),0) tot_amt2 from ("+sub_query+") where ext_st='2' and ext_pay_dt is not null and nvl(ext_est_dt,ext_pay_dt) = "+dt2+" ) b,\n"+	 
					" ( select count(*) tot_su3, nvl(sum(ext_pay_amt),0) tot_amt3 from ("+sub_query+") where ext_st='2' and rent_start_dt < "+dt2+" and ext_pay_dt = "+dt2+" ) c\n"+
				" union all\n"+				
				" select '수금' gubun, '승계수수료' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(ext_pay_amt),0) tot_amt1 from ("+sub_query+") where ext_st='5' and nvl(nvl(ext_est_dt,ext_pay_dt),to_char(sysdate,'YYYYMM')) like "+dt1+"||'%' and ext_pay_dt is not null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(ext_pay_amt),0) tot_amt2 from ("+sub_query+") where ext_st='5' and ext_pay_dt is not null and nvl(ext_est_dt,ext_pay_dt) = "+dt2+" ) b,\n"+	 
					" ( select count(*) tot_su3, nvl(sum(ext_pay_amt),0) tot_amt3 from ("+sub_query+") where ext_st='5' and rent_start_dt < "+dt2+" and ext_pay_dt = "+dt2+" ) c\n"+
				" union all\n"+				
				" select '소계' gubun, 'N' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(ext_pay_amt),0) tot_amt1 from ("+sub_query+") where nvl(nvl(ext_est_dt,ext_pay_dt),to_char(sysdate,'YYYYMM')) like "+dt1+"||'%' and ext_pay_dt is not null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(ext_pay_amt),0) tot_amt2 from ("+sub_query+") where ext_pay_dt is not null and nvl(ext_est_dt,ext_pay_dt) = "+dt2+" ) b,\n"+	 
					" ( select count(*) tot_su3, nvl(sum(ext_pay_amt),0) tot_amt3 from ("+sub_query+") where rent_start_dt < "+dt2+" and ext_pay_dt = "+dt2+" ) c\n"+
				" union all\n"+				
				" select '미수금' gubun, '선납금' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt1 from ("+sub_query+") where ext_st='1' and nvl(nvl(ext_est_dt,ext_pay_dt),to_char(sysdate,'YYYYMM')) like "+dt1+"||'%' and ext_pay_dt is null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt2 from ("+sub_query+") where ext_st='1' and nvl(ext_est_dt,ext_pay_dt) = "+dt2+" and ext_pay_dt is null ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt3 from ("+sub_query+") where ext_st='1' and rent_start_dt < "+dt2+" and ext_pay_dt is null ) c\n"+
				" union all\n"+
				" select '미수금' gubun, '보증금' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt1 from ("+sub_query+") where ext_st='0' and nvl(nvl(ext_est_dt,ext_pay_dt),to_char(sysdate,'YYYYMM')) like "+dt1+"||'%' and ext_pay_dt is null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt2 from ("+sub_query+") where ext_st='0' and nvl(ext_est_dt,ext_pay_dt) = "+dt2+" and ext_pay_dt is null ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt3 from ("+sub_query+") where ext_st='0' and rent_start_dt < "+dt2+" and ext_pay_dt is null ) c\n"+
				" union all\n"+
				" select '미수금' gubun, '개시대여료' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt1 from ("+sub_query+") where ext_st='2' and nvl(nvl(ext_est_dt,ext_pay_dt),to_char(sysdate,'YYYYMM')) like "+dt1+"||'%' and ext_pay_dt is null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt2 from ("+sub_query+") where ext_st='2' and nvl(ext_est_dt,ext_pay_dt) = "+dt2+" and ext_pay_dt is null ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt3 from ("+sub_query+") where ext_st='2' and rent_start_dt < "+dt2+" and ext_pay_dt is null ) c\n"+
				" union all\n"+								
				" select '미수금' gubun, '승계수수료' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt1 from ("+sub_query+") where ext_st='5' and nvl(nvl(ext_est_dt,ext_pay_dt),to_char(sysdate,'YYYYMM')) like "+dt1+"||'%' and ext_pay_dt is null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt2 from ("+sub_query+") where ext_st='5' and nvl(ext_est_dt,ext_pay_dt) = "+dt2+" and ext_pay_dt is null ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt3 from ("+sub_query+") where ext_st='5' and rent_start_dt < "+dt2+" and ext_pay_dt is null ) c\n"+
				" union all\n"+								
				" select '소계' gubun, 'N' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt1 from ("+sub_query+") where nvl(nvl(ext_est_dt,ext_pay_dt),to_char(sysdate,'YYYYMM')) like "+dt1+"||'%' and ext_pay_dt is null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt2 from ("+sub_query+") where nvl(ext_est_dt,ext_pay_dt) = "+dt2+" and ext_pay_dt is null ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt3 from ("+sub_query+") where rent_start_dt < "+dt2+" and ext_pay_dt is null ) c\n"+
				" union all\n"+								
				" select '수금율' gubun, 'N' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select decode(a.tot_su1, 0,0, to_number(to_char((b.tot_su1/a.tot_su1)*100, 999.99))) tot_su1, decode(a.tot_amt1, 0,0, to_number(to_char((b.tot_amt1/a.tot_amt1)*100, 999.99))) tot_amt1 from\n"+ 
						" ( select count(*) tot_su1, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt1 from ("+sub_query+") where nvl(nvl(ext_est_dt,ext_pay_dt),to_char(sysdate,'YYYYMM')) like "+dt1+"||'%' ) a,\n"+
						" ( select count(*) tot_su1, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt1 from ("+sub_query+") where nvl(nvl(ext_est_dt,ext_pay_dt),to_char(sysdate,'YYYYMM')) like "+dt1+"||'%' and ext_pay_dt is not null ) b\n"+
					" ) a,\n"+ 
					" ( select decode(a.tot_su2, 0,0, to_number(to_char((b.tot_su2/a.tot_su2)*100, 999.99))) tot_su2, decode(a.tot_amt2, 0,0, to_number(to_char((b.tot_amt2/a.tot_amt2)*100, 999.99))) tot_amt2 from \n"+
						" ( select count(*) tot_su2, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt2 from ("+sub_query+") where (nvl(ext_est_dt,ext_pay_dt) = "+dt2+" or ext_pay_dt = "+dt2+") ) a,\n"+	
						" ( select count(*) tot_su2, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt2 from ("+sub_query+") where ext_pay_dt = "+dt2+" ) b\n"+	 
					" ) b,\n"+ 
					" ( select decode(a.tot_su3, 0,0, to_number(to_char((b.tot_su3/a.tot_su3)*100, 999.99))) tot_su3, decode(a.tot_amt3, 0,0, to_number(to_char((b.tot_amt3/a.tot_amt3)*100, 999.99))) tot_amt3 from \n"+
						" ( select count(*) tot_su3, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt3 from ("+sub_query+") where rent_start_dt < "+dt2+" and (ext_pay_dt is null or ext_pay_dt = "+dt2+") ) a,\n"+
						" ( select count(*) tot_su3, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt3 from ("+sub_query+") where rent_start_dt < "+dt2+" and ext_pay_dt = "+dt2+" ) b\n"+
					" ) c";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			while(rs.next())
			{
				IncomingSBean pre = new IncomingSBean();
				pre.setGubun(rs.getString(1));
				pre.setGubun_sub(rs.getString(2));
				pre.setTot_su1(rs.getString(3));
				pre.setTot_amt1(rs.getString(4));
				pre.setTot_su2(rs.getString(5));
				pre.setTot_amt2(rs.getString(6));
				pre.setTot_su3(rs.getString(7));
				pre.setTot_amt3(rs.getString(8));
				vt.add(pre);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AccountDatabase:getPreStat2]"+e);
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
	 *	수금현황-선수금
	 */
	public Vector getPreStatShot(String br_id, String search_kd, String brch_id, String bus_id2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";

		sub_query = " select a.*, b.dlv_dt from scd_pre a, cont b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
					" and nvl(b.use_yn,'Y')='Y' and a.pp_s_amt > 0 and nvl(a.bill_yn,'Y')='Y'";

		if(search_kd.equals("1"))		sub_query += " and b.brch_id='"+brch_id+"'";
		else if(search_kd.equals("2"))	sub_query += " and b.bus_id2='"+bus_id2+"'";

		query = "select '계획' gubun, 'N' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(decode(pp_pay_amt,0,pp_s_amt+pp_v_amt,pp_pay_amt)),0) tot_amt1 from ("+sub_query+") where pp_est_dt like to_char(sysdate,'YYYYMM')||'%' ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(decode(pp_pay_amt,0,pp_s_amt+pp_v_amt,pp_pay_amt)),0) tot_amt2 from ("+sub_query+") where pp_est_dt = to_char(sysdate,'YYYYMMDD') ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(decode(pp_pay_amt,0,pp_s_amt+pp_v_amt,pp_pay_amt)),0) tot_amt3 from ("+sub_query+") where pp_est_dt < to_char(sysdate,'YYYYMMDD') and (pp_pay_dt is null or pp_pay_dt = to_char(sysdate,'YYYYMMDD')) ) c\n"+
				" union all\n"+								
				" select '수금' gubun, 'N' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(pp_pay_amt),0) tot_amt1 from ("+sub_query+") where pp_est_dt like to_char(sysdate,'YYYYMM')||'%' and pp_pay_dt is not null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(pp_pay_amt),0) tot_amt2 from ("+sub_query+") where pp_est_dt = to_char(sysdate,'YYYYMMDD') and pp_pay_dt = to_char(sysdate,'YYYYMMDD') ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(pp_pay_amt),0) tot_amt3 from ("+sub_query+") where pp_est_dt < to_char(sysdate,'YYYYMMDD') and pp_pay_dt = to_char(sysdate,'YYYYMMDD') ) c\n"+
				" union all\n"+				
				" select '미수금' gubun, 'N' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(pp_s_amt+pp_v_amt),0) tot_amt1 from ("+sub_query+") where pp_est_dt like to_char(sysdate,'YYYYMM')||'%' and pp_pay_dt is null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(pp_s_amt+pp_v_amt),0) tot_amt2 from ("+sub_query+") where pp_est_dt = to_char(sysdate,'YYYYMMDD') and pp_pay_dt is null ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(pp_s_amt+pp_v_amt),0) tot_amt3 from ("+sub_query+") where pp_est_dt < to_char(sysdate,'YYYYMMDD') and pp_pay_dt is null ) c\n"+
				" union all\n"+								
				" select '비율' gubun, 'N' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select decode(a.tot_su1, 0,0, to_number(to_char((b.tot_su1/a.tot_su1)*100, 999.99))) tot_su1, decode(a.tot_amt1, 0,0, to_number(to_char((b.tot_amt1/a.tot_amt1)*100, 999.99))) tot_amt1 from\n"+ 
						" ( select count(*) tot_su1, nvl(sum(pp_s_amt+pp_v_amt),0) tot_amt1 from ("+sub_query+") where pp_est_dt like to_char(sysdate,'YYYYMM')||'%' ) a,\n"+
						" ( select count(*) tot_su1, nvl(sum(pp_s_amt+pp_v_amt),0) tot_amt1 from ("+sub_query+") where pp_est_dt like to_char(sysdate,'YYYYMM')||'%' and pp_pay_dt is not null ) b\n"+
					" ) a,\n"+ 
					" ( select decode(a.tot_su2, 0,0, to_number(to_char((b.tot_su2/a.tot_su2)*100, 999.99))) tot_su2, decode(a.tot_amt2, 0,0, to_number(to_char((b.tot_amt2/a.tot_amt2)*100, 999.99))) tot_amt2 from \n"+
						" ( select count(*) tot_su2, nvl(sum(pp_s_amt+pp_v_amt),0) tot_amt2 from ("+sub_query+") where pp_est_dt = to_char(sysdate,'YYYYMMDD') ) a,\n"+	
						" ( select count(*) tot_su2, nvl(sum(pp_s_amt+pp_v_amt),0) tot_amt2 from ("+sub_query+") where pp_est_dt = to_char(sysdate,'YYYYMMDD') and pp_pay_dt = to_char(sysdate,'YYYYMMDD') ) b\n"+	
					" ) b,\n"+ 
					" ( select decode(a.tot_su3, 0,0, to_number(to_char((b.tot_su3/a.tot_su3)*100, 999.99))) tot_su3, decode(a.tot_amt3, 0,0, to_number(to_char((b.tot_amt3/a.tot_amt3)*100, 999.99))) tot_amt3 from \n"+
						" ( select count(*) tot_su3, nvl(sum(pp_s_amt+pp_v_amt),0) tot_amt3 from ("+sub_query+") where pp_est_dt < to_char(sysdate,'YYYYMMDD') and (pp_pay_dt is null or pp_pay_dt = to_char(sysdate,'YYYYMMDD')) ) a,\n"+
						" ( select count(*) tot_su3, nvl(sum(pp_s_amt+pp_v_amt),0) tot_amt3 from ("+sub_query+") where pp_est_dt < to_char(sysdate,'YYYYMMDD') and pp_pay_dt = to_char(sysdate,'YYYYMMDD') ) b\n"+
					" ) c";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			while(rs.next())
			{
				IncomingSBean pre = new IncomingSBean();
				pre.setGubun(rs.getString(1));
				pre.setGubun_sub(rs.getString(2));
				pre.setTot_su1(rs.getString(3));
				pre.setTot_amt1(rs.getString(4));
				pre.setTot_su2(rs.getString(5));
				pre.setTot_amt2(rs.getString(6));
				pre.setTot_su3(rs.getString(7));
				pre.setTot_amt3(rs.getString(8));
				vt.add(pre);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AccountDatabase:getPreStat]"+e);
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
	 *	수금현황-선수금 : 대여개시여부에 따른 연체료 계산
	 */
	public Vector getPreStatShot2(String br_id, String search_kd, String brch_id, String bus_id2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";

		sub_query = " select a.*, b.dlv_dt, c.rent_start_dt from scd_ext a, cont b, fee c where a.ext_st in ('0', '1', '2') and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and a.rent_st=c.rent_st"+
					" and a.ext_s_amt <> 0 and nvl(a.bill_yn,'Y')='Y'"; 

		if(search_kd.equals("1"))		sub_query += " and b.brch_id='"+brch_id+"'";
		else if(search_kd.equals("2"))	sub_query += " and b.bus_id2='"+bus_id2+"'";

		query = "select '계획' gubun, 'N' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(decode(ext_pay_amt,0,ext_s_amt+ext_v_amt,ext_pay_amt)),0) tot_amt1 from ("+sub_query+") where nvl(nvl(ext_est_dt,ext_pay_dt),to_char(sysdate,'YYYYMM')) like to_char(sysdate,'YYYYMM')||'%' ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(decode(ext_pay_amt,0,ext_s_amt+ext_v_amt,ext_pay_amt)),0) tot_amt2 from ("+sub_query+") where nvl(ext_est_dt,ext_pay_dt) = to_char(sysdate,'YYYYMMDD') ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(decode(ext_pay_amt,0,ext_s_amt+ext_v_amt,ext_pay_amt)),0) tot_amt3 from ("+sub_query+") where rent_start_dt < to_char(sysdate,'YYYYMMDD') and (ext_pay_dt is null or ext_pay_dt = to_char(sysdate,'YYYYMMDD')) ) c\n"+
				" union all\n"+								
				" select '수금' gubun, 'N' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(ext_pay_amt),0) tot_amt1 from ("+sub_query+") where nvl(nvl(ext_est_dt,ext_pay_dt),to_char(sysdate,'YYYYMM')) like to_char(sysdate,'YYYYMM')||'%' and ext_pay_dt is not null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(ext_pay_amt),0) tot_amt2 from ("+sub_query+") where nvl(ext_est_dt,ext_pay_dt) = to_char(sysdate,'YYYYMMDD') and ext_pay_dt is not null ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(ext_pay_amt),0) tot_amt3 from ("+sub_query+") where rent_start_dt < to_char(sysdate,'YYYYMMDD') and ext_pay_dt = to_char(sysdate,'YYYYMMDD') ) c\n"+
				" union all\n"+				
				" select '미수금' gubun, 'N' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt1 from ("+sub_query+") where nvl(nvl(ext_est_dt,ext_pay_dt),to_char(sysdate,'YYYYMM')) like to_char(sysdate,'YYYYMM')||'%' and ext_pay_dt is null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt2 from ("+sub_query+") where nvl(ext_est_dt,ext_pay_dt) = to_char(sysdate,'YYYYMMDD') and ext_pay_dt is null ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt3 from ("+sub_query+") where rent_start_dt < to_char(sysdate,'YYYYMMDD') and ext_pay_dt is null ) c\n"+
				" union all\n"+								
				" select '비율' gubun, 'N' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select decode(a.tot_su1, 0,0, to_number(to_char((b.tot_su1/a.tot_su1)*100, 999.99))) tot_su1, decode(a.tot_amt1, 0,0, to_number(to_char((b.tot_amt1/a.tot_amt1)*100, 999.99))) tot_amt1 from\n"+ 
						" ( select count(*) tot_su1, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt1 from ("+sub_query+") where nvl(nvl(ext_est_dt,ext_pay_dt),to_char(sysdate,'YYYYMM')) like to_char(sysdate,'YYYYMM')||'%' ) a,\n"+
						" ( select count(*) tot_su1, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt1 from ("+sub_query+") where nvl(nvl(ext_est_dt,ext_pay_dt),to_char(sysdate,'YYYYMM')) like to_char(sysdate,'YYYYMM')||'%' and ext_pay_dt is not null ) b\n"+
					" ) a,\n"+ 
					" ( select decode(a.tot_su2, 0,0, to_number(to_char((b.tot_su2/a.tot_su2)*100, 999.99))) tot_su2, decode(a.tot_amt2, 0,0, to_number(to_char((b.tot_amt2/a.tot_amt2)*100, 999.99))) tot_amt2 from \n"+
						" ( select count(*) tot_su2, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt2 from ("+sub_query+") where nvl(ext_est_dt,ext_pay_dt) = to_char(sysdate,'YYYYMMDD') ) a,\n"+	
						" ( select count(*) tot_su2, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt2 from ("+sub_query+") where nvl(ext_est_dt,ext_pay_dt) = to_char(sysdate,'YYYYMMDD') and ext_pay_dt = to_char(sysdate,'YYYYMMDD') ) b\n"+	
					" ) b,\n"+ 
					" ( select decode(a.tot_su3, 0,0, to_number(to_char((b.tot_su3/a.tot_su3)*100, 999.99))) tot_su3, decode(a.tot_amt3, 0,0, to_number(to_char((b.tot_amt3/a.tot_amt3)*100, 999.99))) tot_amt3 from \n"+
						" ( select count(*) tot_su3, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt3 from ("+sub_query+") where rent_start_dt < to_char(sysdate,'YYYYMMDD') and (ext_pay_dt is null or ext_pay_dt = to_char(sysdate,'YYYYMMDD')) ) a,\n"+
						" ( select count(*) tot_su3, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt3 from ("+sub_query+") where rent_start_dt < to_char(sysdate,'YYYYMMDD') and ext_pay_dt = to_char(sysdate,'YYYYMMDD') ) b\n"+
					" ) c";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			while(rs.next())
			{
				IncomingSBean pre = new IncomingSBean();
				pre.setGubun(rs.getString(1));
				pre.setGubun_sub(rs.getString(2));
				pre.setTot_su1(rs.getString(3));
				pre.setTot_amt1(rs.getString(4));
				pre.setTot_su2(rs.getString(5));
				pre.setTot_amt2(rs.getString(6));
				pre.setTot_su3(rs.getString(7));
				pre.setTot_amt3(rs.getString(8));
				vt.add(pre);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AccountDatabase:getPreStatShot2]"+e);
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
	 *	수금현황-과태료
	 */
	public Vector getFineStat(String br_id, String search_kd, String brch_id, String bus_id2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";
		String standard_dt = "decode(rec_plan_dt, '',decode(dem_dt, '',paid_end_dt, dem_dt), rec_plan_dt)";

		sub_query = " select decode(a.fault_st, '1', a.paid_amt, '2', decode(nvl(a.fault_amt,0), 0, a.paid_amt, a.fault_amt)) paid_amt,"+
					" a.rec_plan_dt, a.coll_dt, a.dem_dt, a.paid_end_dt "+
					" from fine a, cont b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.car_mng_id=b.car_mng_id"+
					" and a.paid_amt > 0 and nvl(a.no_paid_yn,'N') <> 'Y' and a.paid_st in ('3','4') and nvl(a.bill_yn,'Y')='Y' ";

		query = " select '계획' gubun, 'N' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+
					" ( select count(*) tot_su1, nvl(sum(paid_amt),0) tot_amt1 from ("+sub_query+") where "+standard_dt+" like to_char(sysdate,'YYYYMM')||'%' ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(paid_amt),0) tot_amt2 from ("+sub_query+") where "+standard_dt+" = to_char(sysdate,'YYYYMMDD') ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(paid_amt),0) tot_amt3 from ("+sub_query+") where "+standard_dt+" < to_char(sysdate,'YYYYMMDD') and (coll_dt is null or coll_dt = to_char(sysdate,'YYYYMMDD')) ) c\n"+
				" union all\n"+
				" select '수금' gubun, 'N' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(paid_amt),0) tot_amt1 from ("+sub_query+") where "+standard_dt+" like to_char(sysdate,'YYYYMM')||'%' and coll_dt is not null) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(paid_amt),0) tot_amt2 from ("+sub_query+") where "+standard_dt+" = to_char(sysdate,'YYYYMMDD') and (coll_dt is not null or coll_dt = to_char(sysdate,'YYYYMMDD')) ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(paid_amt),0) tot_amt3 from ("+sub_query+") where "+standard_dt+" < to_char(sysdate,'YYYYMMDD') and coll_dt = to_char(sysdate,'YYYYMMDD') ) c\n"+
				" union all\n"+
				" select '미수금' gubun, 'N' gubun_sub, a.*, b.*, c.*\n"+
				" from \n"+
					" ( select count(*) tot_su1, nvl(sum(paid_amt),0) tot_amt1 from ("+sub_query+") where "+standard_dt+" like to_char(sysdate,'YYYYMM')||'%' and coll_dt is null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(paid_amt),0) tot_amt2 from ("+sub_query+") where "+standard_dt+" = to_char(sysdate,'YYYYMMDD') and coll_dt is null) b,\n"+
					" ( select count(*) tot_su3, nvl(sum(paid_amt),0) tot_amt3 from ("+sub_query+") where "+standard_dt+" < to_char(sysdate,'YYYYMMDD') and coll_dt is null ) c\n"+
				" union all\n"+
				" select '수금율' gubun, 'N' gubun_sub, a.*, b.*, c.*\n"+
				" from \n"+
					" ( select decode(a.tot_su1, 0,0, to_number(to_char((b.tot_su1/a.tot_su1)*100, 999.99))) tot_su1, decode(a.tot_amt1, 0,0, to_number(to_char((b.tot_amt1/a.tot_amt1)*100, 999.99))) tot_amt1 from \n"+
						" ( select count(*) tot_su1, nvl(sum(paid_amt),0) tot_amt1 from ("+sub_query+") where "+standard_dt+" like to_char(sysdate,'YYYYMM')||'%' ) a,\n"+
						" ( select count(*) tot_su1, nvl(sum(paid_amt),0) tot_amt1 from ("+sub_query+") where "+standard_dt+" like to_char(sysdate,'YYYYMM')||'%' and coll_dt is not null ) b\n"+
					" ) a,\n"+
					" ( select decode(a.tot_su2, 0,0, to_number(to_char((b.tot_su2/a.tot_su2)*100, 999.99))) tot_su2, decode(a.tot_amt2, 0,0, to_number(to_char((b.tot_amt2/a.tot_amt2)*100, 999.99))) tot_amt2 from \n"+
						" ( select count(*) tot_su2, nvl(sum(paid_amt),0) tot_amt2 from ("+sub_query+") where "+standard_dt+" = to_char(sysdate,'YYYYMMDD') ) a,\n"+
						" ( select count(*) tot_su2, nvl(sum(paid_amt),0) tot_amt2 from ("+sub_query+") where "+standard_dt+" = to_char(sysdate,'YYYYMMDD') and coll_dt = to_char(sysdate,'YYYYMMDD') ) b\n"+
					" ) b,\n"+
					" ( select decode(a.tot_su3, 0,0, to_number(to_char((b.tot_su3/a.tot_su3)*100, 999.99))) tot_su3, decode(a.tot_amt3, 0,0, to_number(to_char((b.tot_amt3/a.tot_amt3)*100, 999.99))) tot_amt3 from \n"+
						" ( select count(*) tot_su3, nvl(sum(paid_amt),0) tot_amt3 from ("+sub_query+") where "+standard_dt+" < to_char(sysdate,'YYYYMMDD') and (coll_dt is null or coll_dt = to_char(sysdate,'YYYYMMDD')) ) a,\n"+
						" ( select count(*) tot_su3, nvl(sum(paid_amt),0) tot_amt3 from ("+sub_query+") where "+standard_dt+" < to_char(sysdate,'YYYYMMDD') and coll_dt = to_char(sysdate,'YYYYMMDD') ) b\n"+
					" ) c";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			while(rs.next())
			{
				IncomingSBean fine = new IncomingSBean();
				fine.setGubun(rs.getString(1));
				fine.setGubun_sub(rs.getString(2));
				fine.setTot_su1(rs.getString(3));
				fine.setTot_amt1(rs.getString(4));
				fine.setTot_su2(rs.getString(5));
				fine.setTot_amt2(rs.getString(6));
				fine.setTot_su3(rs.getString(7));
				fine.setTot_amt3(rs.getString(8));
				vt.add(fine);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AccountDatabase:getFineStat]"+e);
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
	 *	수금현황-면책금
	 */
	public Vector getInsMStat(String br_id, String search_kd, String brch_id, String bus_id2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";

		sub_query = " select se.*, decode(se.ext_pay_dt,'',se.ext_s_amt+se.ext_v_amt,se.ext_pay_amt) amt, nvl(se.ext_est_dt,a.cust_req_dt) est_dt, se.ext_pay_dt as pay_dt "+
					" from scd_ext se, service a, cont b "+
					" where se.ext_st = '3' and se.rent_mng_id = a.rent_mng_id and se.rent_l_cd = a.rent_l_cd and se.ext_id = a.serv_id and se.rent_mng_id=b.rent_mng_id and se.rent_l_cd=b.rent_l_cd"+
					" and se.ext_s_amt > 0 and nvl(a.no_dft_yn,'N') <> 'Y' and nvl(se.bill_yn,'Y')='Y'";

		if(search_kd.equals("1"))		sub_query += " and b.brch_id='"+brch_id+"'";
		else if(search_kd.equals("2"))	sub_query += " and b.bus_id2='"+bus_id2+"'";

		query = " select '계획' gubun, a.*, b.*, c.*\n"+
				" from\n"+
					" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where ext_est_dt like to_char(sysdate,'YYYYMM')||'%' ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where (est_dt = to_char(sysdate,'YYYYMMDD') and (pay_dt is null or pay_dt = to_char(sysdate,'YYYYMMDD')) or (est_dt >= to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD')))  ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt  < to_char(sysdate,'YYYYMMDD') and (pay_dt is null or pay_dt = to_char(sysdate,'YYYYMMDD')) ) c\n"+
				" union all\n"+
				" select '수금' gubun, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where ext_est_dt like to_char(sysdate,'YYYYMM')||'%' and pay_dt is not null) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt  >= to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD') ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt  < to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD') ) c\n"+
				" union all\n"+
				" select '미수금' gubun, a.*, b.*, c.*\n"+
				" from \n"+
					" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where ext_est_dt like to_char(sysdate,'YYYYMM')||'%' and pay_dt is null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt  = to_char(sysdate,'YYYYMMDD') and pay_dt is null) b,\n"+
					" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt < to_char(sysdate,'YYYYMMDD') and pay_dt is null ) c\n"+
				" union all\n"+
				" select '수금율' gubun, a.*, b.*, c.*\n"+
				" from \n"+
					" ( select decode(a.tot_su1, 0,0, to_number(to_char((b.tot_su1/a.tot_su1)*100, 999.99))) tot_su1, decode(a.tot_amt1, 0,0, to_number(to_char((b.tot_amt1/a.tot_amt1)*100, 999.99))) tot_amt1 from \n"+
						" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where ext_est_dt like to_char(sysdate,'YYYYMM')||'%' ) a,\n"+
						" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where ext_est_dt like to_char(sysdate,'YYYYMM')||'%' and pay_dt is not null ) b\n"+
					" ) a,\n"+
					" ( select decode(a.tot_su2, 0,0, to_number(to_char((b.tot_su2/a.tot_su2)*100, 999.99))) tot_su2, decode(a.tot_amt2, 0,0, to_number(to_char((b.tot_amt2/a.tot_amt2)*100, 999.99))) tot_amt2 from \n"+
						" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt  = to_char(sysdate,'YYYYMMDD') ) a,\n"+
						" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt  = to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD') ) b\n"+
					" ) b,\n"+
					" ( select decode(a.tot_su3, 0,0, to_number(to_char((b.tot_su3/a.tot_su3)*100, 999.99))) tot_su3, decode(a.tot_amt3, 0,0, to_number(to_char((b.tot_amt3/a.tot_amt3)*100, 999.99))) tot_amt3 from \n"+
						" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt  < to_char(sysdate,'YYYYMMDD') and (pay_dt is null or pay_dt = to_char(sysdate,'YYYYMMDD')) ) a,\n"+
						" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt < to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD') ) b\n"+
					" ) c";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			while(rs.next())
			{
				IncomingSBean fee = new IncomingSBean();
				fee.setGubun(rs.getString(1));
				fee.setTot_su1(rs.getString(2));
				fee.setTot_amt1(rs.getString(3));
				fee.setTot_su2(rs.getString(4));
				fee.setTot_amt2(rs.getString(5));
				fee.setTot_su3(rs.getString(6));
				fee.setTot_amt3(rs.getString(7));
				vt.add(fee);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AccountDatabase:getInsMStat]"+e);
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
	 *	수금현황-휴차료/대차료
	 */
	public Vector getInsHStat(String br_id, String search_kd, String brch_id, String bus_id2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";

		sub_query = " select  se.*, decode(se.ext_pay_dt, '', se.ext_s_amt+se.ext_v_amt, se.ext_pay_amt) amt "+
					" from    scd_ext se, my_accid a, cont b, accident c"+
					" where   se.ext_st = '6' "+
					"         and se.rent_mng_id = c.rent_mng_id and se.rent_l_cd = c.rent_l_cd and substr(se.ext_id,1,6) = c.accid_id "+
					"         and se.rent_mng_id=b.rent_mng_id and se.rent_l_cd=b.rent_l_cd "+
					"         and c.car_mng_id=a.car_mng_id and substr(se.ext_id,1,6)= a.accid_id and substr(se.ext_id,7)= to_char(a.seq_no) "+
					"         and a.car_mng_id=b.car_mng_id and b.rent_l_cd=c.rent_l_cd and b.rent_mng_id=c.rent_mng_id "+
					"         and se.ext_s_amt > 0  and nvl(a.bill_yn,'Y')='Y'";	 

		if(search_kd.equals("1"))		sub_query += " and b.brch_id='"+brch_id+"'";
		else if(search_kd.equals("2"))	sub_query += " and b.bus_id2='"+bus_id2+"'";

		query = " select '계획' gubun, a.*, b.*, c.*\n"+
				" from\n"+
					" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where ext_est_dt like to_char(sysdate,'YYYYMM')||'%' ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where ext_est_dt = to_char(sysdate,'YYYYMMDD') ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where ext_est_dt < to_char(sysdate,'YYYYMMDD') and (ext_pay_dt is null or ext_pay_dt = to_char(sysdate,'YYYYMMDD')) ) c\n"+
				" union all\n"+
				" select '수금' gubun, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where ext_est_dt like to_char(sysdate,'YYYYMM')||'%' and ext_pay_dt is not null) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where ext_est_dt = to_char(sysdate,'YYYYMMDD') and ext_pay_dt = to_char(sysdate,'YYYYMMDD') ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where ext_est_dt < to_char(sysdate,'YYYYMMDD') and ext_pay_dt = to_char(sysdate,'YYYYMMDD') ) c\n"+
				" union all\n"+
				" select '미수금' gubun, a.*, b.*, c.*\n"+
				" from \n"+
					" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where ext_est_dt like to_char(sysdate,'YYYYMM')||'%' and ext_pay_dt is null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where ext_est_dt = to_char(sysdate,'YYYYMMDD') and ext_pay_dt is null) b,\n"+
					" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where ext_est_dt < to_char(sysdate,'YYYYMMDD') and ext_pay_dt is null ) c\n"+
				" union all\n"+
				" select '수금율' gubun, a.*, b.*, c.*\n"+
				" from \n"+
					" ( select decode(a.tot_su1, 0,0, to_number(to_char((b.tot_su1/a.tot_su1)*100, 999.99))) tot_su1, decode(a.tot_amt1, 0,0, to_number(to_char((b.tot_amt1/a.tot_amt1)*100, 999.99))) tot_amt1 from \n"+
						" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where ext_est_dt like to_char(sysdate,'YYYYMM')||'%' ) a,\n"+
						" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where ext_est_dt like to_char(sysdate,'YYYYMM')||'%' and ext_pay_dt is not null ) b\n"+
					" ) a,\n"+
					" ( select decode(a.tot_su2, 0,0, to_number(to_char((b.tot_su2/a.tot_su2)*100, 999.99))) tot_su2, decode(a.tot_amt2, 0,0, to_number(to_char((b.tot_amt2/a.tot_amt2)*100, 999.99))) tot_amt2 from \n"+
						" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where ext_est_dt = to_char(sysdate,'YYYYMMDD') ) a,\n"+
						" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where ext_est_dt = to_char(sysdate,'YYYYMMDD') and ext_pay_dt = to_char(sysdate,'YYYYMMDD') ) b\n"+
					" ) b,\n"+
					" ( select decode(a.tot_su3, 0,0, to_number(to_char((b.tot_su3/a.tot_su3)*100, 999.99))) tot_su3, decode(a.tot_amt3, 0,0, to_number(to_char((b.tot_amt3/a.tot_amt3)*100, 999.99))) tot_amt3 from \n"+
						" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where ext_est_dt < to_char(sysdate,'YYYYMMDD') and (ext_pay_dt is null or ext_pay_dt = to_char(sysdate,'YYYYMMDD')) ) a,\n"+
						" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where ext_est_dt < to_char(sysdate,'YYYYMMDD') and ext_pay_dt = to_char(sysdate,'YYYYMMDD') ) b\n"+
					" ) c";
				
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			while(rs.next())
			{
				IncomingSBean fee = new IncomingSBean();
				fee.setGubun(rs.getString(1));
				fee.setTot_su1(rs.getString(2));
				fee.setTot_amt1(rs.getString(3));
				fee.setTot_su2(rs.getString(4));
				fee.setTot_amt2(rs.getString(5));
				fee.setTot_su3(rs.getString(6));
				fee.setTot_amt3(rs.getString(7));
				vt.add(fee);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AccountDatabase:getInsHStat]"+e);
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
	 *	수금현황-중도해지 (위약금+대여료)
	 */
	public Vector getClsStat2(String br_id, String search_kd, String brch_id, String bus_id2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		//중도해지위약금
		String sub_query1 = "";
		sub_query1 = " select b.rent_l_cd, decode(a.ext_pay_dt, '', a.ext_s_amt+a.ext_v_amt, a.ext_pay_amt) amt, a.ext_est_dt as est_dt, a.ext_est_dt as r_est_dt, a.ext_pay_dt as pay_dt, b.brch_id, b.bus_id2"+
					" from scd_ext a, cont b, cls_cont c"+
					" where a.ext_st = '4' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd"+
					" and (a.ext_s_amt+a.ext_v_amt) >0 and c.cls_doc_yn='Y' and nvl(a.bill_yn,'Y')='Y'";
		//대여료
		String sub_query2 = "";
		sub_query2 = " select b.rent_l_cd, decode(a.rc_yn, '0', a.fee_s_amt+a.fee_v_amt, a.rc_amt) amt, a.fee_est_dt as est_dt, a.r_fee_est_dt as r_est_dt, a.rc_dt pay_dt, b.brch_id, b.bus_id2"+
					" from scd_fee a, cont b, cls_cont c"+
					" where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd"+
					" and b.use_yn='N' and nvl(a.bill_yn,'Y')='Y' and a.tm_st2<>'4' and c.cls_st in ('1','2')";
		//합체
		String sub_query3 = "";		
		sub_query3 = " select * from ( "+sub_query1+" ) where amt > 0";		


		if(!br_id.equals("S1") && !br_id.equals(""))	sub_query3 += " and rent_l_cd like '"+br_id+"%'";

		if(search_kd.equals("1"))						sub_query3 += " and rent_l_cd like '"+brch_id+"%'";
		else if(search_kd.equals("2"))					sub_query3 += " and bus_id2='"+bus_id2+"'";

		query = " select '계획' gubun, a.*, b.*, c.*\n"+
				" from\n"+
					" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query3+") where est_dt like to_char(sysdate,'YYYYMM')||'%' ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query3+") where r_est_dt = to_char(sysdate,'YYYYMMDD') ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query3+") where r_est_dt < to_char(sysdate,'YYYYMMDD') and (pay_dt is null or pay_dt = to_char(sysdate,'YYYYMMDD')) ) c\n"+
				" union all\n"+
				" select '수금' gubun, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query3+") where est_dt like to_char(sysdate,'YYYYMM')||'%' and pay_dt is not null) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query3+") where r_est_dt = to_char(sysdate,'YYYYMMDD') and pay_dt is not null ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query3+") where r_est_dt < to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD') ) c\n"+
				" union all\n"+
				" select '미수금' gubun, a.*, b.*, c.*\n"+
				" from \n"+
					" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query3+") where est_dt like to_char(sysdate,'YYYYMM')||'%' and pay_dt is null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query3+") where r_est_dt = to_char(sysdate,'YYYYMMDD') and pay_dt is null) b,\n"+
					" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query3+") where r_est_dt < to_char(sysdate,'YYYYMMDD') and pay_dt is null ) c\n"+
				" union all\n"+
				" select '수금율' gubun, a.*, b.*, c.*\n"+
				" from \n"+
					" ( select decode(a.tot_su1, 0,0, to_number(to_char((b.tot_su1/a.tot_su1)*100, 999.99))) tot_su1, decode(a.tot_amt1, 0,0, to_number(to_char((b.tot_amt1/a.tot_amt1)*100, 999.99))) tot_amt1 from \n"+
						" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query3+") where est_dt like to_char(sysdate,'YYYYMM')||'%' ) a,\n"+
						" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query3+") where est_dt like to_char(sysdate,'YYYYMM')||'%' and pay_dt is not null ) b\n"+
					" ) a,\n"+
					" ( select decode(a.tot_su2, 0,0, to_number(to_char((b.tot_su2/a.tot_su2)*100, 999.99))) tot_su2, decode(a.tot_amt2, 0,0, to_number(to_char((b.tot_amt2/a.tot_amt2)*100, 999.99))) tot_amt2 from \n"+
						" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query3+") where r_est_dt = to_char(sysdate,'YYYYMMDD') ) a,\n"+
						" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query3+") where r_est_dt = to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD') ) b\n"+
					" ) b,\n"+
					" ( select decode(a.tot_su3, 0,0, to_number(to_char((b.tot_su3/a.tot_su3)*100, 999.99))) tot_su3, decode(a.tot_amt3, 0,0, to_number(to_char((b.tot_amt3/a.tot_amt3)*100, 999.99))) tot_amt3 from \n"+
						" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query3+") where r_est_dt < to_char(sysdate,'YYYYMMDD') and (pay_dt is null or pay_dt = to_char(sysdate,'YYYYMMDD')) ) a,\n"+
						" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query3+") where r_est_dt < to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD') ) b\n"+
					" ) c";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			while(rs.next())
			{
				IncomingSBean fee = new IncomingSBean();
				fee.setGubun(rs.getString(1));
				fee.setTot_su1(rs.getString(2));
				fee.setTot_amt1(rs.getString(3));
				fee.setTot_su2(rs.getString(4));
				fee.setTot_amt2(rs.getString(5));
				fee.setTot_su3(rs.getString(6));
				fee.setTot_amt3(rs.getString(7));
				vt.add(fee);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AccountDatabase:getClsStat2]"+e);
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


	//지출현황-----------------------------------------------------------------------------------------------

	/**
	 *	지출현황-할부금
	 */
	public Vector getDebtStat(String br_id, String search_kd, String brch_id, String bus_id2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";

		sub_query = "SELECT  * from "+
			" ( select b.brch_id, (a.alt_prn+a.alt_int) as amt, a.r_alt_est_dt as est_dt, a.pay_dt, a.alt_est_dt as est_dt2"+
			"	from SCD_ALT_CASE a, CONT b, (select max(rent_l_cd) rent_l_cd from cont where car_st<>'4' group by car_mng_id) c"+
			"	where a.car_mng_id = b.car_mng_id AND b.rent_l_cd = c.rent_l_cd"+
			"	union all"+
			"	select 'S1' brch_id, (alt_prn_amt+alt_int_amt) as amt, r_alt_est_dt as est_dt, pay_dt, alt_est_dt as est_dt2"+
			"	from scd_bank"+
			" ) where amt > 0 ";
			
		if(search_kd.equals("1"))		sub_query += " and nvl(brch_id,'S1')='"+brch_id+"'";		//은행대출 영업소코드 'S1'으로

		query = " select '계획' gubun, 0 st, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where est_dt2 like to_char(sysdate,'YYYYMM')||'%' ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt = to_char(sysdate,'YYYYMMDD') ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt < to_char(sysdate,'YYYYMMDD') and (pay_dt is null or pay_dt = to_char(sysdate,'YYYYMMDD')) ) c\n"+
				" union all\n"+
				" select '지출' gubun, 0 st, a.*, b.*, c.*\n"+
				" from\n"+
					" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where est_dt2 like to_char(sysdate,'YYYYMM')||'%' and pay_dt is not null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt = to_char(sysdate,'YYYYMMDD') and (pay_dt is not null or pay_dt = to_char(sysdate,'YYYYMMDD')) ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt < to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD') ) c\n"+
				" union all\n"+
				" select '잔액' gubun, 0 st, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where est_dt2 like to_char(sysdate,'YYYYMM')||'%' and pay_dt is null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt = to_char(sysdate,'YYYYMMDD') and pay_dt is null ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt < to_char(sysdate,'YYYYMMDD') and pay_dt is null ) c\n"+
				" union all\n"+
				" select '비율' gubun, 1 st, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select decode(a.tot_su1, 0,0, to_number(to_char((b.tot_su1/a.tot_su1)*100, 999.99))) tot_su1, decode(a.tot_amt1, 0,0, to_number(to_char((b.tot_amt1/a.tot_amt1)*100, 999.99))) tot_amt1 from\n"+ 
						" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where est_dt2 like to_char(sysdate,'YYYYMM')||'%' ) a,\n"+
						" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where est_dt2 like to_char(sysdate,'YYYYMM')||'%' and pay_dt is not null ) b\n"+
					" ) a,\n"+
					" ( select decode(a.tot_su2, 0,0, to_number(to_char((b.tot_su2/a.tot_su2)*100, 999.99))) tot_su2, decode(a.tot_amt2, 0,0, to_number(to_char((b.tot_amt2/a.tot_amt2)*100, 999.99))) tot_amt2 from\n"+ 
						" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt = to_char(sysdate,'YYYYMMDD') ) a,\n"+	
						" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt = to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD') ) b\n"+	
					" ) b,\n"+
					" ( select decode(a.tot_su3, 0,0, to_number(to_char((b.tot_su3/a.tot_su3)*100, 999.99))) tot_su3, decode(a.tot_amt3, 0,0, to_number(to_char((b.tot_amt3/a.tot_amt3)*100, 999.99))) tot_amt3 from\n"+ 
						" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt < to_char(sysdate,'YYYYMMDD') and (pay_dt is null or pay_dt = to_char(sysdate,'YYYYMMDD')) ) a,\n"+
						" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt < to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD') ) b\n"+
					" ) c";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			while(rs.next())
			{
				IncomingSBean fee = new IncomingSBean();
				fee.setGubun(rs.getString(1));
				fee.setSt(rs.getInt(2));
				fee.setTot_su1(rs.getString(3));
				fee.setTot_amt1(rs.getString(4));
				fee.setTot_su2(rs.getString(5));
				fee.setTot_amt2(rs.getString(6));
				fee.setTot_su3(rs.getString(7));
				fee.setTot_amt3(rs.getString(8));
				vt.add(fee);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AccountDatabase:getDebtStat]"+e);
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
	 *	지출현황-보험료
	 */
	public Vector getInsStat(String br_id, String search_kd, String brch_id, String bus_id2, String gubun)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";

		sub_query += "select /*+  merge(b) */ e.pay_amt as amt, nvl(e.r_ins_est_dt,e.ins_est_dt) as est_dt, e.pay_dt, e.pay_yn"+
					" from   insur a, cont_n_view b, scd_ins e, (select max(rent_l_cd) rent_l_cd from cont where car_st<>'4' group by car_mng_id) f"+
					" where  e.ins_tm2<>'2' and e.pay_amt > 0 "+
					"        and a.car_mng_id=e.car_mng_id and a.ins_st=e.ins_st"+
					"        and a.car_mng_id=b.car_mng_id"+
					"        and b.rent_l_cd=f.rent_l_cd ";

		if(search_kd.equals("1"))		sub_query += " and b.brch_id='"+brch_id+"'";	
		else if(search_kd.equals("2"))	sub_query += " and b.bus_id2='"+bus_id2+"'";
		
		//환급보험료 제외
		if(gubun.equals("")){
			sub_query += " and e.ins_tm2<>'2' and e.pay_amt > 0";
		}else{
			sub_query += " and (e.ins_tm2='2' or e.pay_amt <0 ) ";
		}

		query = " select '계획' gubun, 0 st, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where est_dt like to_char(sysdate,'YYYYMM')||'%' ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt = to_char(sysdate,'YYYYMMDD') ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt < to_char(sysdate,'YYYYMMDD') and (nvl(pay_yn,'0')='0' or pay_dt = to_char(sysdate,'YYYYMMDD')) ) c\n"+
				" union all\n"+
				" select '지출' gubun, 0 st, a.*, b.*, c.*\n"+
				" from\n"+
					" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where est_dt like to_char(sysdate,'YYYYMM')||'%' and pay_dt is not null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt = to_char(sysdate,'YYYYMMDD') and (pay_dt is not null or pay_dt = to_char(sysdate,'YYYYMMDD')) ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt < to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD') ) c\n"+
				" union all\n"+
				" select '잔액' gubun, 0 st, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where est_dt like to_char(sysdate,'YYYYMM')||'%' and pay_dt is null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt = to_char(sysdate,'YYYYMMDD') and pay_dt is null ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt < to_char(sysdate,'YYYYMMDD') and nvl(pay_yn,'0')='0' ) c\n"+
				" union all\n"+
				" select '비율' gubun, 1 st, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select decode(a.tot_su1, 0,0, to_number(to_char((b.tot_su1/a.tot_su1)*100, 999.99))) tot_su1, decode(a.tot_amt1, 0,0, to_number(to_char((b.tot_amt1/a.tot_amt1)*100, 999.99))) tot_amt1 from\n"+ 
						" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where est_dt like to_char(sysdate,'YYYYMM')||'%' ) a,\n"+
						" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where est_dt like to_char(sysdate,'YYYYMM')||'%' and pay_dt is not null ) b\n"+
					" ) a,\n"+
					" ( select decode(a.tot_su2, 0,0, to_number(to_char((b.tot_su2/a.tot_su2)*100, 999.99))) tot_su2, decode(a.tot_amt2, 0,0, to_number(to_char((b.tot_amt2/a.tot_amt2)*100, 999.99))) tot_amt2 from\n"+ 
						" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt = to_char(sysdate,'YYYYMMDD') ) a,\n"+	
						" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt = to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD') ) b\n"+	
					" ) b,\n"+
					" ( select decode(a.tot_su3, 0,0, to_number(to_char((b.tot_su3/a.tot_su3)*100, 999.99))) tot_su3, decode(a.tot_amt3, 0,0, to_number(to_char((b.tot_amt3/a.tot_amt3)*100, 999.99))) tot_amt3 from\n"+ 
						" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt < to_char(sysdate,'YYYYMMDD') and (pay_dt is null or pay_dt = to_char(sysdate,'YYYYMMDD')) ) a,\n"+
						" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt < to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD') ) b\n"+
					" ) c";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			while(rs.next())
			{
				IncomingSBean fee = new IncomingSBean();
				fee.setGubun(rs.getString(1));
				fee.setSt(rs.getInt(2));
				fee.setTot_su1(rs.getString(3));
				fee.setTot_amt1(rs.getString(4));
				fee.setTot_su2(rs.getString(5));
				fee.setTot_amt2(rs.getString(6));
				fee.setTot_su3(rs.getString(7));
				fee.setTot_amt3(rs.getString(8));
				vt.add(fee);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AccountDatabase:getInsStat]"+e);
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
	 *	지출현황-과태료
	 */
	public Vector getFineExpStat(String br_id, String search_kd, String brch_id, String bus_id2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String standard_dt = "decode(proxy_est_dt, '',paid_end_dt, proxy_est_dt)";
		String sub_query = "";

		sub_query = "select a.paid_amt as amt, decode(proxy_est_dt, '',paid_end_dt, proxy_est_dt) as est_dt, a.proxy_dt as pay_dt from fine a, cont b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.car_mng_id=b.car_mng_id and a.paid_st='3'";//and a.paid_st='3'// and (a.proxy_dt is not null or a.dem_dt is not null)

		if(search_kd.equals("1"))		sub_query += " and b.brch_id='"+brch_id+"'";	
		else if(search_kd.equals("2"))	sub_query += " and b.bus_id2='"+bus_id2+"'";	

		query = " select '계획' gubun, 0 st, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where est_dt like to_char(sysdate,'YYYYMM')||'%' ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt = to_char(sysdate,'YYYYMMDD') ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt < to_char(sysdate,'YYYYMMDD') and (pay_dt is null or pay_dt = to_char(sysdate,'YYYYMMDD')) ) c\n"+
				" union all\n"+
				" select '지출' gubun, 0 st, a.*, b.*, c.*\n"+
				" from\n"+
					" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where est_dt like to_char(sysdate,'YYYYMM')||'%' and pay_dt is not null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt = to_char(sysdate,'YYYYMMDD') and (pay_dt is not null or pay_dt = to_char(sysdate,'YYYYMMDD')) ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt < to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD') ) c\n"+
				" union all\n"+
				" select '잔액' gubun, 0 st, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where est_dt like to_char(sysdate,'YYYYMM')||'%' and pay_dt is null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt = to_char(sysdate,'YYYYMMDD') and pay_dt is null ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt < to_char(sysdate,'YYYYMMDD') and pay_dt is null ) c\n"+
				" union all\n"+
				" select '비율' gubun, 1 st, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select decode(a.tot_su1, 0,0, to_number(to_char((b.tot_su1/a.tot_su1)*100, 999.99))) tot_su1, decode(a.tot_amt1, 0,0, to_number(to_char((b.tot_amt1/a.tot_amt1)*100, 999.99))) tot_amt1 from\n"+ 
						" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where est_dt like to_char(sysdate,'YYYYMM')||'%' ) a,\n"+
						" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where est_dt like to_char(sysdate,'YYYYMM')||'%' and pay_dt is not null ) b\n"+
					" ) a,\n"+
					" ( select decode(a.tot_su2, 0,0, to_number(to_char((b.tot_su2/a.tot_su2)*100, 999.99))) tot_su2, decode(a.tot_amt2, 0,0, to_number(to_char((b.tot_amt2/a.tot_amt2)*100, 999.99))) tot_amt2 from\n"+ 
						" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt = to_char(sysdate,'YYYYMMDD') ) a,\n"+	
						" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt = to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD') ) b\n"+	
					" ) b,\n"+
					" ( select decode(a.tot_su3, 0,0, to_number(to_char((b.tot_su3/a.tot_su3)*100, 999.99))) tot_su3, decode(a.tot_amt3, 0,0, to_number(to_char((b.tot_amt3/a.tot_amt3)*100, 999.99))) tot_amt3 from\n"+ 
						" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt < to_char(sysdate,'YYYYMMDD') and (pay_dt is null or pay_dt = to_char(sysdate,'YYYYMMDD')) ) a,\n"+
						" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt < to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD') ) b\n"+
					" ) c";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			while(rs.next())
			{
				IncomingSBean fee = new IncomingSBean();
				fee.setGubun(rs.getString(1));
				fee.setSt(rs.getInt(2));
				fee.setTot_su1(rs.getString(3));
				fee.setTot_amt1(rs.getString(4));
				fee.setTot_su2(rs.getString(5));
				fee.setTot_amt2(rs.getString(6));
				fee.setTot_su3(rs.getString(7));
				fee.setTot_amt3(rs.getString(8));
				vt.add(fee);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AccountDatabase:getFineExpStat]"+e);
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
	 *	지출현황-지급수수료
	 */
	public Vector getCommiStat(String br_id, String search_kd, String brch_id, String bus_id2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";

		sub_query = "select a.commi as amt, a.sup_dt as est_dt, a.sup_dt as pay_dt from commi a, cont b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.commi > 0";

		if(search_kd.equals("1"))		sub_query += " and b.brch_id='"+brch_id+"'";	
		else if(search_kd.equals("2"))	sub_query += " and b.bus_id2='"+bus_id2+"'";	

		query = " select '계획' gubun, 0 st, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where est_dt like to_char(sysdate,'YYYYMM')||'%' ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt = to_char(sysdate,'YYYYMMDD') ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt < to_char(sysdate,'YYYYMMDD') and (pay_dt is null or pay_dt = to_char(sysdate,'YYYYMMDD')) ) c\n"+
				" union all\n"+
				" select '지출' gubun, 0 st, a.*, b.*, c.*\n"+
				" from\n"+
					" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where est_dt like to_char(sysdate,'YYYYMM')||'%' and pay_dt is not null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt = to_char(sysdate,'YYYYMMDD') and (pay_dt is not null or pay_dt = to_char(sysdate,'YYYYMMDD')) ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt < to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD') ) c\n"+
				" union all\n"+
				" select '잔액' gubun, 0 st, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where est_dt like to_char(sysdate,'YYYYMM')||'%' and pay_dt is null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt = to_char(sysdate,'YYYYMMDD') and pay_dt is null ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt < to_char(sysdate,'YYYYMMDD') and pay_dt is null ) c\n"+
				" union all\n"+
				" select '비율' gubun, 1 st, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select decode(a.tot_su1, 0,0, to_number(to_char((b.tot_su1/a.tot_su1)*100, 999.99))) tot_su1, decode(a.tot_amt1, 0,0, to_number(to_char((b.tot_amt1/a.tot_amt1)*100, 999.99))) tot_amt1 from\n"+ 
						" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where est_dt like to_char(sysdate,'YYYYMM')||'%' ) a,\n"+
						" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where est_dt like to_char(sysdate,'YYYYMM')||'%' and pay_dt is not null ) b\n"+
					" ) a,\n"+
					" ( select decode(a.tot_su2, 0,0, to_number(to_char((b.tot_su2/a.tot_su2)*100, 999.99))) tot_su2, decode(a.tot_amt2, 0,0, to_number(to_char((b.tot_amt2/a.tot_amt2)*100, 999.99))) tot_amt2 from\n"+ 
						" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt = to_char(sysdate,'YYYYMMDD') ) a,\n"+	
						" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt = to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD') ) b\n"+	
					" ) b,\n"+
					" ( select decode(a.tot_su3, 0,0, to_number(to_char((b.tot_su3/a.tot_su3)*100, 999.99))) tot_su3, decode(a.tot_amt3, 0,0, to_number(to_char((b.tot_amt3/a.tot_amt3)*100, 999.99))) tot_amt3 from\n"+ 
						" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt < to_char(sysdate,'YYYYMMDD') and (pay_dt is null or pay_dt = to_char(sysdate,'YYYYMMDD')) ) a,\n"+
						" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt < to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD') ) b\n"+
					" ) c";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			while(rs.next())
			{
				IncomingSBean fee = new IncomingSBean();
				fee.setGubun(rs.getString(1));
				fee.setSt(rs.getInt(2));
				fee.setTot_su1(rs.getString(3));
				fee.setTot_amt1(rs.getString(4));
				fee.setTot_su2(rs.getString(5));
				fee.setTot_amt2(rs.getString(6));
				fee.setTot_su3(rs.getString(7));
				fee.setTot_amt3(rs.getString(8));
				vt.add(fee);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AccountDatabase:getCommiStat]"+e);
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
	 *	지출현황-매출비용
	 */
	public Vector getExpStat(String br_id, String search_kd, String brch_id, String bus_id2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";

		sub_query = "select  /*+  merge(a) */ a.* from exp_view a, cont b where a.rent_l_cd=b.rent_l_cd";

		if(search_kd.equals("1"))		sub_query += " and b.brch_id='"+brch_id+"'";	
		else if(search_kd.equals("2"))	sub_query += " and b.bus_id2='"+bus_id2+"'";	

		query = " select '계획' gubun, 0 st, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where est_dt like to_char(sysdate,'YYYYMM')||'%' ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt = to_char(sysdate,'YYYYMMDD') ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt < to_char(sysdate,'YYYYMMDD') and (pay_dt is null or pay_dt = to_char(sysdate,'YYYYMMDD')) ) c\n"+
				" union all\n"+
				" select '지출' gubun, 0 st, a.*, b.*, c.*\n"+
				" from\n"+
					" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where est_dt like to_char(sysdate,'YYYYMM')||'%' and pay_dt is not null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt = to_char(sysdate,'YYYYMMDD') and (pay_dt is not null or pay_dt = to_char(sysdate,'YYYYMMDD')) ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt < to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD') ) c\n"+
				" union all\n"+
				" select '잔액' gubun, 0 st, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where est_dt like to_char(sysdate,'YYYYMM')||'%' and pay_dt is null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt = to_char(sysdate,'YYYYMMDD') and pay_dt is null ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt < to_char(sysdate,'YYYYMMDD') and pay_dt is null ) c\n"+
				" union all\n"+
				" select '비율' gubun, 1 st, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select decode(a.tot_su1, 0,0, to_number(to_char((b.tot_su1/a.tot_su1)*100, 999.99))) tot_su1, decode(a.tot_amt1, 0,0, to_number(to_char((b.tot_amt1/a.tot_amt1)*100, 999.99))) tot_amt1 from\n"+ 
						" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where est_dt like to_char(sysdate,'YYYYMM')||'%' ) a,\n"+
						" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where est_dt like to_char(sysdate,'YYYYMM')||'%' and pay_dt is not null ) b\n"+
					" ) a,\n"+
					" ( select decode(a.tot_su2, 0,0, to_number(to_char((b.tot_su2/a.tot_su2)*100, 999.99))) tot_su2, decode(a.tot_amt2, 0,0, to_number(to_char((b.tot_amt2/a.tot_amt2)*100, 999.99))) tot_amt2 from\n"+ 
						" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt = to_char(sysdate,'YYYYMMDD') ) a,\n"+	
						" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt = to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD') ) b\n"+	
					" ) b,\n"+
					" ( select decode(a.tot_su3, 0,0, to_number(to_char((b.tot_su3/a.tot_su3)*100, 999.99))) tot_su3, decode(a.tot_amt3, 0,0, to_number(to_char((b.tot_amt3/a.tot_amt3)*100, 999.99))) tot_amt3 from\n"+ 
						" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt < to_char(sysdate,'YYYYMMDD') and (pay_dt is null or pay_dt = to_char(sysdate,'YYYYMMDD')) ) a,\n"+
						" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt < to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD') ) b\n"+
					" ) c";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();


			while(rs.next())
			{
				IncomingSBean fee = new IncomingSBean();
				fee.setGubun(rs.getString(1));
				fee.setSt(rs.getInt(2));
				fee.setTot_su1(rs.getString(3));
				fee.setTot_amt1(rs.getString(4));
				fee.setTot_su2(rs.getString(5));
				fee.setTot_amt2(rs.getString(6));
				fee.setTot_su3(rs.getString(7));
				fee.setTot_amt3(rs.getString(8));
				vt.add(fee);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AccountDatabase:getExpStat]"+e);
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
	 *	지출현황-특소세
	 */
	public Vector getTaxStat(String br_id, String search_kd, String brch_id, String bus_id2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";

		sub_query = "select (a.spe_tax_amt+a.edu_tax_amt) as amt, a.est_dt, a.pay_dt from car_tax a, cont b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.spe_tax_amt > 0";

		if(search_kd.equals("1"))		sub_query += " and b.brch_id='"+brch_id+"'";	
		else if(search_kd.equals("2"))	sub_query += " and b.bus_id2='"+bus_id2+"'";	

		query = " select '계획' gubun, 0 st, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where est_dt like to_char(sysdate,'YYYYMM')||'%' ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt = to_char(sysdate,'YYYYMMDD') ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt < to_char(sysdate,'YYYYMMDD') and (pay_dt is null or pay_dt = to_char(sysdate,'YYYYMMDD')) ) c\n"+
				" union all\n"+
				" select '지출' gubun, 0 st, a.*, b.*, c.*\n"+
				" from\n"+
					" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where est_dt like to_char(sysdate,'YYYYMM')||'%' and pay_dt is not null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt = to_char(sysdate,'YYYYMMDD') and (pay_dt is not null or pay_dt = to_char(sysdate,'YYYYMMDD')) ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt < to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD') ) c\n"+
				" union all\n"+
				" select '잔액' gubun, 0 st, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where est_dt like to_char(sysdate,'YYYYMM')||'%' and pay_dt is null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt = to_char(sysdate,'YYYYMMDD') and pay_dt is null ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt < to_char(sysdate,'YYYYMMDD') and pay_dt is null ) c\n"+
				" union all\n"+
				" select '비율' gubun, 1 st, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select decode(a.tot_su1, 0,0, to_number(to_char((b.tot_su1/a.tot_su1)*100, 999.99))) tot_su1, decode(a.tot_amt1, 0,0, to_number(to_char((b.tot_amt1/a.tot_amt1)*100, 999.99))) tot_amt1 from\n"+ 
						" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where est_dt like to_char(sysdate,'YYYYMM')||'%' ) a,\n"+
						" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where est_dt like to_char(sysdate,'YYYYMM')||'%' and pay_dt is not null ) b\n"+
					" ) a,\n"+
					" ( select decode(a.tot_su2, 0,0, to_number(to_char((b.tot_su2/a.tot_su2)*100, 999.99))) tot_su2, decode(a.tot_amt2, 0,0, to_number(to_char((b.tot_amt2/a.tot_amt2)*100, 999.99))) tot_amt2 from\n"+ 
						" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt = to_char(sysdate,'YYYYMMDD') ) a,\n"+	
						" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt = to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD') ) b\n"+	
					" ) b,\n"+
					" ( select decode(a.tot_su3, 0,0, to_number(to_char((b.tot_su3/a.tot_su3)*100, 999.99))) tot_su3, decode(a.tot_amt3, 0,0, to_number(to_char((b.tot_amt3/a.tot_amt3)*100, 999.99))) tot_amt3 from\n"+ 
						" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt < to_char(sysdate,'YYYYMMDD') and (pay_dt is null or pay_dt = to_char(sysdate,'YYYYMMDD')) ) a,\n"+
						" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt < to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD') ) b\n"+
					" ) c";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			while(rs.next())
			{
				IncomingSBean fee = new IncomingSBean();
				fee.setGubun(rs.getString(1));
				fee.setSt(rs.getInt(2));
				fee.setTot_su1(rs.getString(3));
				fee.setTot_amt1(rs.getString(4));
				fee.setTot_su2(rs.getString(5));
				fee.setTot_amt2(rs.getString(6));
				fee.setTot_su3(rs.getString(7));
				fee.setTot_amt3(rs.getString(8));
				vt.add(fee);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AccountDatabase:getTaxStat]"+e);
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
	 *	지출현황-정비비
	 */
	public Vector getServiceStat(String br_id, String search_kd, String brch_id, String bus_id2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";

		sub_query = " select a.tot_amt as amt, a.serv_dt as est_dt, a.set_dt as pay_dt"+
					" from service a, cont b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.car_mng_id=b.car_mng_id and a.tot_amt > 0";

		if(search_kd.equals("1"))		sub_query += " and b.brch_id='"+brch_id+"'";	
		else if(search_kd.equals("2"))	sub_query += " and b.bus_id2='"+bus_id2+"'";	

		query = " select '계획' gubun, 0 st, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where est_dt like to_char(sysdate,'YYYYMM')||'%' ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt = to_char(sysdate,'YYYYMMDD') ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt < to_char(sysdate,'YYYYMMDD') and (pay_dt is null or pay_dt = to_char(sysdate,'YYYYMMDD')) ) c\n"+
				" union all\n"+
				" select '지출' gubun, 0 st, a.*, b.*, c.*\n"+
				" from\n"+
					" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where est_dt like to_char(sysdate,'YYYYMM')||'%' and pay_dt is not null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt = to_char(sysdate,'YYYYMMDD') and (pay_dt is not null or pay_dt = to_char(sysdate,'YYYYMMDD')) ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt < to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD') ) c\n"+
				" union all\n"+
				" select '잔액' gubun, 0 st, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where est_dt like to_char(sysdate,'YYYYMM')||'%' and pay_dt is null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt = to_char(sysdate,'YYYYMMDD') and pay_dt is null ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt < to_char(sysdate,'YYYYMMDD') and pay_dt is null ) c\n"+
				" union all\n"+
				" select '비율' gubun, 1 st, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select decode(a.tot_su1, 0,0, to_number(to_char((b.tot_su1/a.tot_su1)*100, 999.99))) tot_su1, decode(a.tot_amt1, 0,0, to_number(to_char((b.tot_amt1/a.tot_amt1)*100, 999.99))) tot_amt1 from\n"+ 
						" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where est_dt like to_char(sysdate,'YYYYMM')||'%' ) a,\n"+
						" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where est_dt like to_char(sysdate,'YYYYMM')||'%' and pay_dt is not null ) b\n"+
					" ) a,\n"+
					" ( select decode(a.tot_su2, 0,0, to_number(to_char((b.tot_su2/a.tot_su2)*100, 999.99))) tot_su2, decode(a.tot_amt2, 0,0, to_number(to_char((b.tot_amt2/a.tot_amt2)*100, 999.99))) tot_amt2 from\n"+ 
						" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt = to_char(sysdate,'YYYYMMDD') ) a,\n"+	
						" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt = to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD') ) b\n"+	
					" ) b,\n"+
					" ( select decode(a.tot_su3, 0,0, to_number(to_char((b.tot_su3/a.tot_su3)*100, 999.99))) tot_su3, decode(a.tot_amt3, 0,0, to_number(to_char((b.tot_amt3/a.tot_amt3)*100, 999.99))) tot_amt3 from\n"+ 
						" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt < to_char(sysdate,'YYYYMMDD') and (pay_dt is null or pay_dt = to_char(sysdate,'YYYYMMDD')) ) a,\n"+
						" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt < to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD') ) b\n"+
					" ) c";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			while(rs.next())
			{
				IncomingSBean fee = new IncomingSBean();
				fee.setGubun(rs.getString(1));
				fee.setSt(rs.getInt(2));
				fee.setTot_su1(rs.getString(3));
				fee.setTot_amt1(rs.getString(4));
				fee.setTot_su2(rs.getString(5));
				fee.setTot_amt2(rs.getString(6));
				fee.setTot_su3(rs.getString(7));
				fee.setTot_amt3(rs.getString(8));
				vt.add(fee);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AccountDatabase:getServiceStat]"+e);
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
	 *	휴차료/대차료 현황
	 */
	public Vector getInsHStat()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
	
		String sub_query1 = "";
		String sub_query2 = "";
		
		sub_query1=	" select  /*+  merge(b) */ distinct c.* "+
					" from    accident c, my_accid a, cont_n_view b, cont_etc e , car_reg cr "+
					" where   nvl(a.req_st, '0')  = '0' "+
					"         and c.accid_st in ('1','3') and (100-c.our_fault_per)>0 "+
					"         and c.car_mng_id=a.car_mng_id(+) and c.accid_id=a.accid_id(+) "+
					"         and c.rent_l_cd=b.rent_l_cd and c.rent_mng_id=b.rent_mng_id "+
					"         and b.rent_l_cd=e.rent_l_cd and b.rent_mng_id=e.rent_mng_id  and c.car_mng_id = cr.car_mng_id "+
					" ";
				   
		sub_query2= " select DISTINCT a.* "+
					" from   my_accid a, cont b, accident c, cont_etc e"+
				    " where  a.req_amt > 0  and nvl(a.bill_yn,'Y')='Y' "+
					"        and a.car_mng_id=b.car_mng_id and b.rent_l_cd=c.rent_l_cd and b.rent_mng_id=c.rent_mng_id  "+
				    "        and b.rent_l_cd=e.rent_l_cd and b.rent_mng_id=e.rent_mng_id "+
					" ";
	


			query = " 	select '1' mm, '휴차료' g_nm, '미청구' gubun, a.*, b.*, c.*\n"+
					" from\n"+
					" ( select count(*) tot_su0, 0 tot_amt0 from ( "+sub_query1+ " and decode(a.req_gu, '1','1','2','2', decode(cr.car_use, '1','1','2')) = '1' and nvl(e.mng_br_id, b.brch_id) in ('S1' , 'S2', 'I1', 'K1', ',K2') and a.req_dt is  null and a.pay_dt is  null ) where accid_dt like to_char(sysdate,'YYYYMM')||'%'   ) a,\n"+
					" ( select count(*) tot_su1, 0 tot_amt1 from ( "+sub_query1+ " and decode(a.req_gu, '1','1','2','2', decode(cr.car_use, '1','1','2')) = '1' and nvl(e.mng_br_id, b.brch_id) in ('B1' , 'N1')  and a.req_dt is  null and a.pay_dt is  null ) where accid_dt like to_char(sysdate,'YYYYMM')||'%'  ) b,\n"+
					" ( select count(*) tot_su2, 0 tot_amt2 from ( "+sub_query1+ " and decode(a.req_gu, '1','1','2','2', decode(cr.car_use, '1','1','2')) = '1' and nvl(e.mng_br_id, b.brch_id) in ('D1' ) and a.req_dt is  null and a.pay_dt is  null ) where accid_dt like to_char(sysdate,'YYYYMM')||'%' ) c\n"+
					" union all\n"+
					"  select '1' mm, '휴차료' g_nm, '수금' gubun, a.*, b.*, c.*\n"+
					" from\n"+
					" ( select count(*) tot_su0, nvl(sum(req_amt),0) tot_amt0 from ( "+sub_query2+ " and a.req_gu='1' and nvl(e.mng_br_id, b.brch_id) in ('S1' , 'S2', 'I1', 'K1', ',K2') ) where req_dt like to_char(sysdate,'YYYYMM')||'%' and pay_dt is not null) a,\n"+
					" ( select count(*) tot_su1, nvl(sum(req_amt),0) tot_amt1 from ( "+sub_query2+ " and a.req_gu='1' and nvl(e.mng_br_id, b.brch_id) in ('B1' , 'N1') ) where req_dt like to_char(sysdate,'YYYYMM')||'%' and pay_dt is not null ) b,\n"+
					" ( select count(*) tot_su2, nvl(sum(req_amt),0) tot_amt2 from ( "+sub_query2+ " and a.req_gu='1' and nvl(e.mng_br_id, b.brch_id) in ('D1' ) ) where req_dt like to_char(sysdate,'YYYYMM')||'%' and pay_dt is not null ) c\n"+
					" union all\n"+
					"  select '1' mm, '휴차료' g_nm, '미수금' gubun, a.*, b.*, c.*\n"+
					" from\n"+
					" ( select count(*) tot_su0, nvl(sum(req_amt),0) tot_amt0 from ( "+sub_query2+ " and a.req_gu='1' and nvl(e.mng_br_id, b.brch_id) in ('S1' , 'S2', 'I1', 'K1', ',K2') ) where req_dt like to_char(sysdate,'YYYYMM')||'%' and pay_dt is null) a,\n"+
					" ( select count(*) tot_su1, nvl(sum(req_amt),0) tot_amt1 from ( "+sub_query2+ " and a.req_gu='1' and nvl(e.mng_br_id, b.brch_id) in ('B1' , 'N1') ) where req_dt like to_char(sysdate,'YYYYMM')||'%' and pay_dt is null ) b,\n"+
					" ( select count(*) tot_su2, nvl(sum(req_amt),0) tot_amt2 from ( "+sub_query2+ " and a.req_gu='1' and nvl(e.mng_br_id, b.brch_id) in ('D1' ) ) where req_dt like to_char(sysdate,'YYYYMM')||'%' and pay_dt is  null ) c\n"+
					" union all\n"+
					" select '1' mm, '대차료' g_nm, '미청구' gubun, a.*, b.*, c.*\n"+
					" from\n"+
					" ( select count(*) tot_su0, 0 tot_amt0 from ( "+sub_query1+ " and decode(a.req_gu, '1','1','2','2', decode(cr.car_use, '1','1','2')) = '2' and nvl(e.mng_br_id, b.brch_id) in ('S1' , 'S2', 'I1', 'K1', ',K2') and a.req_dt is  null and a.pay_dt is  null ) where accid_dt like to_char(sysdate,'YYYYMM')||'%'   ) a,\n"+
					" ( select count(*) tot_su1, 0 tot_amt1 from ( "+sub_query1+ " and decode(a.req_gu, '1','1','2','2', decode(cr.car_use, '1','1','2')) = '2' and nvl(e.mng_br_id, b.brch_id) in ('B1' , 'N1')  and a.req_dt is  null and a.pay_dt is  null ) where accid_dt like to_char(sysdate,'YYYYMM')||'%'  ) b,\n"+
					" ( select count(*) tot_su2, 0 tot_amt2 from ( "+sub_query1+ " and decode(a.req_gu, '1','1','2','2', decode(cr.car_use, '1','1','2')) = '2' and nvl(e.mng_br_id, b.brch_id) in ('D1' ) and a.req_dt is  null and a.pay_dt is  null ) where accid_dt like to_char(sysdate,'YYYYMM')||'%' ) c\n"+
					" union all\n"+
					"  select '1' mm, '대차료' g_nm, '수금' gubun, a.*, b.*, c.*\n"+
					" from\n"+
					" ( select count(*) tot_su0, nvl(sum(req_amt),0) tot_amt0 from ( "+sub_query2+ " and a.req_gu='2' and nvl(e.mng_br_id, b.brch_id) in ('S1' , 'S2', 'I1', 'K1', ',K2') ) where req_dt like to_char(sysdate,'YYYYMM')||'%' and pay_dt is not null) a,\n"+
					" ( select count(*) tot_su1, nvl(sum(req_amt),0) tot_amt1 from ( "+sub_query2+ " and a.req_gu='2' and nvl(e.mng_br_id, b.brch_id) in ('B1' , 'N1') ) where req_dt like to_char(sysdate,'YYYYMM')||'%' and pay_dt is not null ) b,\n"+
					" ( select count(*) tot_su2, nvl(sum(req_amt),0) tot_amt2 from ( "+sub_query2+ " and a.req_gu='2' and nvl(e.mng_br_id, b.brch_id) in ('D1' ) ) where req_dt like to_char(sysdate,'YYYYMM')||'%' and pay_dt is not null ) c\n"+
					" union all\n"+
					"  select '1' mm, '대차료' g_nm, '미수금' gubun, a.*, b.*, c.*\n"+
					" from\n"+
					" ( select count(*) tot_su0, nvl(sum(req_amt),0) tot_amt0 from ( "+sub_query2+ " and a.req_gu='2' and nvl(e.mng_br_id, b.brch_id) in ('S1' , 'S2', 'I1', 'K1', ',K2') ) where req_dt like to_char(sysdate,'YYYYMM')||'%' and pay_dt is null) a,\n"+
					" ( select count(*) tot_su1, nvl(sum(req_amt),0) tot_amt1 from ( "+sub_query2+ " and a.req_gu='2' and nvl(e.mng_br_id, b.brch_id) in ('B1' , 'N1') ) where req_dt like to_char(sysdate,'YYYYMM')||'%' and pay_dt is null ) b,\n"+
					" ( select count(*) tot_su2, nvl(sum(req_amt),0) tot_amt2 from ( "+sub_query2+ " and a.req_gu='2' and nvl(e.mng_br_id, b.brch_id) in ('D1' ) ) where req_dt like to_char(sysdate,'YYYYMM')||'%' and pay_dt is  null ) c\n"+
					" union all\n"+
					"  select '2' mm, '휴차료' g_nm, '미청구' gubun, a.*, b.*, c.*\n"+
					" from\n"+
					" ( select count(*) tot_su0, 0 tot_amt0 from ( "+sub_query1+ " and decode(a.req_gu, '1','1','2','2', decode(cr.car_use, '1','1','2')) = '1'  and nvl(e.mng_br_id, b.brch_id) in ('S1' , 'S2', 'I1', 'K1', ',K2') and a.req_dt is  null and a.pay_dt is  null ) where accid_dt >= '20080101' and  substr(accid_dt,1,6) < to_char(sysdate,'YYYYMM')   ) a,\n"+
					" ( select count(*) tot_su1, 0 tot_amt1 from ( "+sub_query1+ " and decode(a.req_gu, '1','1','2','2', decode(cr.car_use, '1','1','2')) = '1'  and nvl(e.mng_br_id, b.brch_id) in ('B1' , 'N1')  and a.req_dt is  null and a.pay_dt is  null ) where accid_dt >= '20080101' and  substr(accid_dt,1,6) < to_char(sysdate,'YYYYMM')  ) b,\n"+
					" ( select count(*) tot_su2, 0 tot_amt2 from ( "+sub_query1+ " and decode(a.req_gu, '1','1','2','2', decode(cr.car_use, '1','1','2')) = '1'  and nvl(e.mng_br_id, b.brch_id) in ('D1' ) and a.req_dt is  null and a.pay_dt is  null ) where accid_dt >= '20080101' and  substr(accid_dt,1,6) < to_char(sysdate,'YYYYMM') ) c\n"+
					" union all\n"+
					"  select '2' mm, '휴차료' g_nm, '수금' gubun, a.*, b.*, c.*\n"+
					" from\n"+
					" ( select count(*) tot_su0, nvl(sum(req_amt),0) tot_amt0 from ("+sub_query2+ " and a.req_gu='1' and nvl(e.mng_br_id, b.brch_id) in ('S1' , 'S2', 'I1', 'K1', ',K2') ) where substr(req_dt,1,6) < to_char(sysdate,'YYYYMM') and pay_dt is not null) a,\n"+
					" ( select count(*) tot_su1, nvl(sum(req_amt),0) tot_amt1 from ("+sub_query2+ " and a.req_gu='1' and nvl(e.mng_br_id, b.brch_id) in ('B1' , 'N1') ) where substr(req_dt,1,6) < to_char(sysdate,'YYYYMM') and pay_dt is not null ) b,\n"+
					" ( select count(*) tot_su2, nvl(sum(req_amt),0) tot_amt2 from ("+sub_query2+ " and a.req_gu='1' and nvl(e.mng_br_id, b.brch_id) in ('D1' ) ) where substr(req_dt,1,6) < to_char(sysdate,'YYYYMM') and pay_dt is not null ) c\n"+
					" union all\n"+
					"  select '2' mm, '휴차료' g_nm, '미수금' gubun, a.*, b.*, c.*\n"+
					" from\n"+
					" ( select count(*) tot_su0, nvl(sum(req_amt),0) tot_amt0 from ( "+sub_query2+ " and a.req_gu='1' and nvl(e.mng_br_id, b.brch_id) in ('S1' , 'S2', 'I1', 'K1', ',K2') ) where substr(req_dt,1,6) < to_char(sysdate,'YYYYMM') and pay_dt is null) a,\n"+
					" ( select count(*) tot_su1, nvl(sum(req_amt),0) tot_amt1 from ( "+sub_query2+ " and a.req_gu='1' and nvl(e.mng_br_id, b.brch_id) in ('B1' , 'N1') ) where substr(req_dt,1,6) < to_char(sysdate,'YYYYMM') and pay_dt is null ) b,\n"+
					" ( select count(*) tot_su2, nvl(sum(req_amt),0) tot_amt2 from ( "+sub_query2+ " and a.req_gu='1' and nvl(e.mng_br_id, b.brch_id) in ('D1' ) ) where substr(req_dt,1,6) < to_char(sysdate,'YYYYMM') and pay_dt is  null ) c\n"+
					" union all\n"+
					"   select '2' mm, '대차료' g_nm, '미청구' gubun, a.*, b.*, c.*\n"+
					" from\n"+
					" ( select count(*) tot_su0, 0 tot_amt0 from ( "+sub_query1+ " and decode(a.req_gu, '1','1','2','2', decode(cr.car_use, '1','1','2')) = '2'  and nvl(e.mng_br_id, b.brch_id) in ('S1' , 'S2', 'I1', 'K1', ',K2') and a.req_dt is  null and a.pay_dt is  null ) where accid_dt >= '20080101' and substr(accid_dt,1,6) < to_char(sysdate,'YYYYMM')   ) a,\n"+
					" ( select count(*) tot_su1, 0 tot_amt1 from ( "+sub_query1+ " and decode(a.req_gu, '1','1','2','2', decode(cr.car_use, '1','1','2')) = '2'  and nvl(e.mng_br_id, b.brch_id) in ('B1' , 'N1')  and a.req_dt is  null and a.pay_dt is  null ) where accid_dt >= '20080101' and   substr(accid_dt,1,6) < to_char(sysdate,'YYYYMM')  ) b,\n"+
					" ( select count(*) tot_su2, 0 tot_amt2 from ( "+sub_query1+ " and decode(a.req_gu, '1','1','2','2', decode(cr.car_use, '1','1','2')) = '2'  and nvl(e.mng_br_id, b.brch_id) in ('D1' ) and a.req_dt is  null and a.pay_dt is  null ) where accid_dt >= '20080101' and  substr(accid_dt,1,6) < to_char(sysdate,'YYYYMM') ) c\n"+
					"  union all\n"+
					"  select '2' mm, '대차료' g_nm, '수금' gubun, a.*, b.*, c.*\n"+
					" from\n"+
					" ( select count(*) tot_su0, nvl(sum(req_amt),0) tot_amt0 from ( "+sub_query2+ " and a.req_gu='2' and nvl(e.mng_br_id, b.brch_id) in ('S1' , 'S2', 'I1', 'K1', ',K2') ) where substr(req_dt,1,6) < to_char(sysdate,'YYYYMM') and pay_dt is not null) a,\n"+
					" ( select count(*) tot_su1, nvl(sum(req_amt),0) tot_amt1 from ( "+sub_query2+ " and a.req_gu='2' and nvl(e.mng_br_id, b.brch_id) in ('B1' , 'N1') ) where substr(req_dt,1,6) < to_char(sysdate,'YYYYMM') and pay_dt is not null ) b,\n"+
					" ( select count(*) tot_su2, nvl(sum(req_amt),0) tot_amt2 from ( "+sub_query2+ " and a.req_gu='2' and nvl(e.mng_br_id, b.brch_id) in ('D1' ) ) where substr(req_dt,1,6) < to_char(sysdate,'YYYYMM') and pay_dt is not null ) c\n"+
					" union all\n"+
					"  select '2' mm, '대차료' g_nm, '미수금' gubun, a.*, b.*, c.*\n"+
					" from\n"+
					" ( select count(*) tot_su0, nvl(sum(req_amt),0) tot_amt0 from ( "+sub_query2+ " and a.req_gu='2' and nvl(e.mng_br_id, b.brch_id) in ('S1' , 'S2', 'I1', 'K1', ',K2') ) where substr(req_dt,1,6) < to_char(sysdate,'YYYYMM') and pay_dt is null) a,\n"+
					" ( select count(*) tot_su1, nvl(sum(req_amt),0) tot_amt1 from ( "+sub_query2+ " and a.req_gu='2' and nvl(e.mng_br_id, b.brch_id) in ('B1' , 'N1') ) where substr(req_dt,1,6) < to_char(sysdate,'YYYYMM') and pay_dt is null ) b,\n"+
					" ( select count(*) tot_su2, nvl(sum(req_amt),0) tot_amt2 from ( "+sub_query2+ " and a.req_gu='2' and nvl(e.mng_br_id, b.brch_id) in ('D1' ) ) where substr(req_dt,1,6) < to_char(sysdate,'YYYYMM') and pay_dt is  null ) c";
					
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
			System.out.println("[AccountDatabase:getInsHStat]"+e);
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
	 *	선납(예정)현황-과태료
	 */
	public Vector getFinePreExpStat(String br_id, String search_kd, String brch_id, String bus_id2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String standard_dt = "decode(dem_dt, '',paid_end_dt, dem_dt)";
		String sub_query = "";

		sub_query = "select a.paid_amt as amt, decode(dem_dt, '',paid_end_dt, dem_dt) as est_dt, a.proxy_dt as pay_dt from fine a, cont b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.car_mng_id=b.car_mng_id and a.paid_st='3'";//and a.paid_st='3'// and (a.proxy_dt is not null or a.dem_dt is not null)

		if(search_kd.equals("1"))		sub_query += " and b.brch_id='"+brch_id+"'";	
		else if(search_kd.equals("2"))	sub_query += " and b.bus_id2='"+bus_id2+"'";	

		query = " select '계획' gubun, 0 st, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where est_dt like to_char(sysdate,'YYYYMM')||'%' ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt = to_char(sysdate,'YYYYMMDD') ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt < to_char(sysdate,'YYYYMMDD') and (pay_dt is null or pay_dt = to_char(sysdate,'YYYYMMDD')) ) c\n"+
				" union all\n"+
				" select '지출' gubun, 0 st, a.*, b.*, c.*\n"+
				" from\n"+
					" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where est_dt like to_char(sysdate,'YYYYMM')||'%' and pay_dt is not null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt = to_char(sysdate,'YYYYMMDD') and (pay_dt is not null or pay_dt = to_char(sysdate,'YYYYMMDD')) ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt < to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD') ) c\n"+
				" union all\n"+
				" select '잔액' gubun, 0 st, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where est_dt like to_char(sysdate,'YYYYMM')||'%' and pay_dt is null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt = to_char(sysdate,'YYYYMMDD') and pay_dt is null ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt < to_char(sysdate,'YYYYMMDD') and pay_dt is null ) c\n"+
				" union all\n"+
				" select '비율' gubun, 1 st, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select decode(a.tot_su1, 0,0, to_number(to_char((b.tot_su1/a.tot_su1)*100, 999.99))) tot_su1, decode(a.tot_amt1, 0,0, to_number(to_char((b.tot_amt1/a.tot_amt1)*100, 999.99))) tot_amt1 from\n"+ 
						" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where est_dt like to_char(sysdate,'YYYYMM')||'%' ) a,\n"+
						" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where est_dt like to_char(sysdate,'YYYYMM')||'%' and pay_dt is not null ) b\n"+
					" ) a,\n"+
					" ( select decode(a.tot_su2, 0,0, to_number(to_char((b.tot_su2/a.tot_su2)*100, 999.99))) tot_su2, decode(a.tot_amt2, 0,0, to_number(to_char((b.tot_amt2/a.tot_amt2)*100, 999.99))) tot_amt2 from\n"+ 
						" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt = to_char(sysdate,'YYYYMMDD') ) a,\n"+	
						" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt = to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD') ) b\n"+	
					" ) b,\n"+
					" ( select decode(a.tot_su3, 0,0, to_number(to_char((b.tot_su3/a.tot_su3)*100, 999.99))) tot_su3, decode(a.tot_amt3, 0,0, to_number(to_char((b.tot_amt3/a.tot_amt3)*100, 999.99))) tot_amt3 from\n"+ 
						" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt < to_char(sysdate,'YYYYMMDD') and (pay_dt is null or pay_dt = to_char(sysdate,'YYYYMMDD')) ) a,\n"+
						" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt < to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD') ) b\n"+
					" ) c";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
	    	
			while(rs.next())
			{
				IncomingSBean fee = new IncomingSBean();
				fee.setGubun(rs.getString(1));
				fee.setSt(rs.getInt(2));
				fee.setTot_su1(rs.getString(3));
				fee.setTot_amt1(rs.getString(4));
				fee.setTot_su2(rs.getString(5));
				fee.setTot_amt2(rs.getString(6));
				fee.setTot_su3(rs.getString(7));
				fee.setTot_amt3(rs.getString(8));
				vt.add(fee);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AccountDatabase:getFineExpStat]"+e);
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

/*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*/
	/**
	 *	수금현황-월마감
	 */
	public Vector getFeeStat_mon(String br_id, String search_kd, String brch_id, String bus_id2, String st_dt, String ed_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";
		String dt1 = st_dt;
		String dt2 = ed_dt;

		sub_query = "select a.fee_est_dt, a.r_fee_est_dt, a.rc_yn, a.rc_dt, decode(a.rc_yn, '0', a.fee_s_amt+a.fee_v_amt, a.rc_amt) fee_amt from scd_fee a, cont b, cls_cont c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_l_cd=c.rent_l_cd(+) and nvl(c.cls_st,'0') not in ('1','2') and nvl(a.bill_yn,'Y')='Y' and a.tm_st2<>'4' and a.fee_s_amt>0";// and nvl(b.use_yn,'Y')='Y'

		if(search_kd.equals("1"))		sub_query += " and b.brch_id='"+brch_id+"'";
		else if(search_kd.equals("2"))	sub_query += " and b.bus_id2='"+bus_id2+"'";

		query = " select '계획' gubun, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(fee_amt),0) tot_amt1 from ("+sub_query+") where fee_est_dt like '"+dt1+"'||'%' ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(fee_amt),0) tot_amt2 from ("+sub_query+") where (r_fee_est_dt = '"+dt2+"' and (rc_yn='0' or rc_dt = '"+dt2+"') or (r_fee_est_dt >= '"+dt2+"' and rc_dt = '"+dt2+"')) ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(fee_amt),0) tot_amt3 from ("+sub_query+") where r_fee_est_dt < '"+dt2+"' and (rc_yn='0' or rc_dt = '"+dt2+"') ) c\n"+
				" union all\n"+
				" select '수금' gubun, a.*, b.*, c.*\n"+
				" from\n"+
					" ( select count(*) tot_su1, nvl(sum(fee_amt),0) tot_amt1 from ("+sub_query+") where fee_est_dt like '"+dt1+"'||'%' and rc_yn='1' ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(fee_amt),0) tot_amt2 from ("+sub_query+") where r_fee_est_dt >= '"+dt2+"' and rc_dt = '"+dt2+"' ) b,\n"+	//r_fee_est_dt = to_char(sysdate,'YYYYMMDD') and 
					" ( select count(*) tot_su3, nvl(sum(fee_amt),0) tot_amt3 from ("+sub_query+") where r_fee_est_dt < '"+dt2+"' and rc_dt = '"+dt2+"' ) c\n"+
				" union all\n"+
				" select '미수금' gubun, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(fee_amt),0) tot_amt1 from ("+sub_query+") where fee_est_dt like '"+dt1+"'||'%' and rc_yn='0' ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(fee_amt),0) tot_amt2 from ("+sub_query+") where r_fee_est_dt = '"+dt2+"' and rc_yn = '0' ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(fee_amt),0) tot_amt3 from ("+sub_query+") where r_fee_est_dt < '"+dt2+"' and rc_yn = '0' ) c\n"+
				" union all\n"+
				" select '비율' gubun, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select decode(a.tot_su1, 0,0, to_number(to_char((b.tot_su1/a.tot_su1)*100, 999.99))) tot_su1, decode(a.tot_amt1, 0,0, to_number(to_char((b.tot_amt1/a.tot_amt1)*100, 999.99))) tot_amt1 from\n"+ 
						" ( select count(*) tot_su1, nvl(sum(fee_amt),0) tot_amt1 from ("+sub_query+") where fee_est_dt like '"+dt1+"'||'%' ) a,\n"+
						" ( select count(*) tot_su1, nvl(sum(fee_amt),0) tot_amt1 from ("+sub_query+") where fee_est_dt like '"+dt1+"'||'%' and rc_yn='1' ) b\n"+
					" ) a,\n"+
					" ( select decode(a.tot_su2, 0,0, to_number(to_char((b.tot_su2/a.tot_su2)*100, 999.99))) tot_su2, decode(a.tot_amt2, 0,0, to_number(to_char((b.tot_amt2/a.tot_amt2)*100, 999.99))) tot_amt2 from\n"+ 
						" ( select count(*) tot_su2, nvl(sum(fee_amt),0) tot_amt2 from ("+sub_query+") where (r_fee_est_dt = '"+dt2+"' and (rc_yn='0' or rc_dt = '"+dt2+"') or (r_fee_est_dt >= '"+dt2+"' and rc_dt = '"+dt2+"')) ) a,\n"+	
						" ( select count(*) tot_su2, nvl(sum(fee_amt),0) tot_amt2 from ("+sub_query+") where r_fee_est_dt >= '"+dt2+"' and rc_dt = '"+dt2+"' ) b\n"+	//r_fee_est_dt = to_char(sysdate,'YYYYMMDD') and 
					" ) b,\n"+
					" ( select decode(a.tot_su3, 0,0, to_number(to_char((b.tot_su3/a.tot_su3)*100, 999.99))) tot_su3, decode(a.tot_amt3, 0,0, to_number(to_char((b.tot_amt3/a.tot_amt3)*100, 999.99))) tot_amt3 from\n"+ 
						" ( select count(*) tot_su3, nvl(sum(fee_amt),0) tot_amt3 from ("+sub_query+") where r_fee_est_dt < '"+dt2+"' and (rc_yn='0' or rc_dt = '"+dt2+"') ) a,\n"+
						" ( select count(*) tot_su3, nvl(sum(fee_amt),0) tot_amt3 from ("+sub_query+") where r_fee_est_dt < '"+dt2+"' and rc_dt = '"+dt2+"' ) b\n"+
					" ) c";

//System.out.println("[AccountDatabase:getFeeStat]"+query);

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			while(rs.next())
			{
				IncomingSBean fee = new IncomingSBean();
				fee.setGubun(rs.getString(1));
				fee.setTot_su1(rs.getString(2));
				fee.setTot_amt1(rs.getString(3));
				fee.setTot_su2(rs.getString(4));
				fee.setTot_amt2(rs.getString(5));
				fee.setTot_su3(rs.getString(6));
				fee.setTot_amt3(rs.getString(7));
				vt.add(fee);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AccountDatabase:getFeeStat]"+e);
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
	 *	수금현황-대여료 연체율
	 */
	public Vector getFeeStat_Dlyper_mon(String br_id, String search_kd, String brch_id, String bus_id2, String st_dt, String ed_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";
		String dt1 = st_dt;
		String dt2 = ed_dt;
		
		sub_query = " select a.* "+
					" from scd_fee a, cont b, cls_cont c"+
					" where nvl(a.bill_yn,'Y')='Y' and a.tm_st2<>'4' and a.fee_s_amt>0 and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_l_cd=c.rent_l_cd(+)"+
					" and nvl(c.cls_st,'0') not in ('1','2')";


		if(search_kd.equals("1"))		sub_query += " and b.brch_id='"+brch_id+"'";
		else if(search_kd.equals("2"))	sub_query += " and b.bus_id2='"+bus_id2+"'";

		query = " select nvl(a.tot_amt,0) tot_amt, nvl(b.dly_amt,0) dly_amt, decode(nvl(b.dly_amt,0),0,0, to_number(to_char((b.dly_amt/a.tot_amt)*100, 999.99))) dly_per from"+
				"	( select sum(fee_s_amt+fee_v_amt) tot_amt from ("+sub_query+") where rc_yn='0' ) a,"+
				"	( select sum(fee_s_amt+fee_v_amt) dly_amt from ("+sub_query+") where rc_yn='0' and r_fee_est_dt < '"+dt2+"' ) b";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			while(rs.next())
			{
				IncomingSBean fee = new IncomingSBean();
				fee.setTot_amt1(rs.getString(1));
				fee.setTot_amt2(rs.getString(2));
				fee.setTot_su1(rs.getString(3));
				vt.add(fee);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AccountDatabase:getFeeStat_Dlyper]"+e);
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
	 *	수금현황-선수금 : 대여개시여부에 따른 연체 관리
	 */
	public Vector getPreStat2_mon(String br_id, String search_kd, String brch_id, String bus_id2, String st_dt, String ed_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";
		String dt1 = st_dt;
		String dt2 = ed_dt;
		
		sub_query = " select a.*, b.dlv_dt, c.rent_start_dt from scd_ext a, cont b, fee c where a.ext_st in ('0', '1', '2' ) and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and a.rent_st=c.rent_st"+
					" and a.ext_s_amt <> 0 and nvl(a.bill_yn,'Y')='Y'"; 

		if(search_kd.equals("1"))		sub_query += " and b.brch_id='"+brch_id+"'";
		else if(search_kd.equals("2"))	sub_query += " and b.bus_id2='"+bus_id2+"'";

		query = " select '계획' gubun, '선납금' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(decode(ext_pay_amt,0,ext_s_amt+ext_v_amt,ext_pay_amt)),0) tot_amt1 from ("+sub_query+") where ext_st='1' and nvl(nvl(ext_est_dt,ext_pay_dt),to_char(sysdate,'YYYYMM')) like '"+dt1+"'||'%' ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(decode(ext_pay_amt,0,ext_s_amt+ext_v_amt,ext_pay_amt)),0) tot_amt2 from ("+sub_query+") where ext_st='1' and nvl(ext_est_dt,ext_pay_dt) = '"+dt2+"') b,\n"+	// or ext_pay_dt = "+dt2+")
					" ( select count(*) tot_su3, nvl(sum(decode(ext_pay_amt,0,ext_s_amt+ext_v_amt,ext_pay_amt)),0) tot_amt3 from ("+sub_query+") where ext_st='1' and rent_start_dt < '"+dt2+"' and (ext_pay_dt is null or ext_pay_dt = '"+dt2+"') ) c\n"+
				" union all\n"+
				" select '계획' gubun, '보증금' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(decode(ext_pay_amt,0,ext_s_amt+ext_v_amt,ext_pay_amt)),0) tot_amt1 from ("+sub_query+") where ext_st='0' and nvl(nvl(ext_est_dt,ext_pay_dt),to_char(sysdate,'YYYYMM')) like '"+dt1+"'||'%' ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(decode(ext_pay_amt,0,ext_s_amt+ext_v_amt,ext_pay_amt)),0) tot_amt2 from ("+sub_query+") where ext_st='0' and nvl(ext_est_dt,ext_pay_dt) = '"+dt2+"' ) b,\n"+	// or ext_pay_dt = "+dt2+")
					" ( select count(*) tot_su3, nvl(sum(decode(ext_pay_amt,0,ext_s_amt+ext_v_amt,ext_pay_amt)),0) tot_amt3 from ("+sub_query+") where ext_st='0' and rent_start_dt < '"+dt2+"' and (ext_pay_dt is null or ext_pay_dt = '"+dt2+"') ) c\n"+
				" union all\n"+
				" select '계획' gubun, '개시대여료' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(decode(ext_pay_amt,0,ext_s_amt+ext_v_amt,ext_pay_amt)),0) tot_amt1 from ("+sub_query+") where ext_st='2' and nvl(nvl(ext_est_dt,ext_pay_dt),to_char(sysdate,'YYYYMM')) like '"+dt1+"'||'%' ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(decode(ext_pay_amt,0,ext_s_amt+ext_v_amt,ext_pay_amt)),0) tot_amt2 from ("+sub_query+") where ext_st='2' and nvl(ext_est_dt,ext_pay_dt) = '"+dt2+"') b,\n"+// or ext_pay_dt = "+dt2+") 	
					" ( select count(*) tot_su3, nvl(sum(decode(ext_pay_amt,0,ext_s_amt+ext_v_amt,ext_pay_amt)),0) tot_amt3 from ("+sub_query+") where ext_st='2' and rent_start_dt < '"+dt2+"' and (ext_pay_dt is null or ext_pay_dt = '"+dt2+"') ) c\n"+
				" union all\n"+								
				" select '소계' gubun, 'N' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(decode(ext_pay_amt,0,ext_s_amt+ext_v_amt,ext_pay_amt)),0) tot_amt1 from ("+sub_query+") where nvl(nvl(ext_est_dt,ext_pay_dt),to_char(sysdate,'YYYYMM')) like '"+dt1+"'||'%' ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(decode(ext_pay_amt,0,ext_s_amt+ext_v_amt,ext_pay_amt)),0) tot_amt2 from ("+sub_query+") where nvl(ext_est_dt,ext_pay_dt) = '"+dt2+"' ) b,\n"+	// or ext_pay_dt = "+dt2+")
					" ( select count(*) tot_su3, nvl(sum(decode(ext_pay_amt,0,ext_s_amt+ext_v_amt,ext_pay_amt)),0) tot_amt3 from ("+sub_query+") where rent_start_dt < '"+dt2+"' and (ext_pay_dt is null or ext_pay_dt = '"+dt2+"') ) c\n"+
				" union all\n"+								
				" select '수금' gubun, '선납금' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(ext_pay_amt),0) tot_amt1 from ("+sub_query+") where ext_st='1' and nvl(nvl(ext_est_dt,ext_pay_dt),to_char(sysdate,'YYYYMM')) like "+dt1+"||'%' and ext_pay_dt is not null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(ext_pay_amt),0) tot_amt2 from ("+sub_query+") where ext_st='1' and ext_pay_dt is not null and nvl(ext_est_dt,ext_pay_dt) = "+dt2+" ) b,\n"+	//ext_est_dt = to_char(sysdate,'YYYYMMDD') and 
					" ( select count(*) tot_su3, nvl(sum(ext_pay_amt),0) tot_amt3 from ("+sub_query+") where ext_st='1' and rent_start_dt < '"+dt2+"' and ext_pay_dt = '"+dt2+"' ) c\n"+
				" union all\n"+
				" select '수금' gubun, '보증금' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(ext_pay_amt),0) tot_amt1 from ("+sub_query+") where ext_st='0' and nvl(nvl(ext_est_dt,ext_pay_dt),to_char(sysdate,'YYYYMM')) like '"+dt1+"'||'%' and ext_pay_dt is not null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(ext_pay_amt),0) tot_amt2 from ("+sub_query+") where ext_st='0' and ext_pay_dt is not null and nvl(ext_est_dt,ext_pay_dt) = '"+dt2+"' ) b,\n"+	//ext_est_dt = to_char(sysdate,'YYYYMMDD') and 
					" ( select count(*) tot_su3, nvl(sum(ext_pay_amt),0) tot_amt3 from ("+sub_query+") where ext_st='0' and rent_start_dt < '"+dt2+"' and ext_pay_dt = '"+dt2+"' ) c\n"+
				" union all\n"+
				" select '수금' gubun, '개시대여료' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(ext_pay_amt),0) tot_amt1 from ("+sub_query+") where ext_st='2' and nvl(nvl(ext_est_dt,ext_pay_dt),to_char(sysdate,'YYYYMM')) like "+dt1+"||'%' and ext_pay_dt is not null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(ext_pay_amt),0) tot_amt2 from ("+sub_query+") where ext_st='2' and ext_pay_dt is not null and nvl(ext_est_dt,ext_pay_dt) = '"+dt2+"' ) b,\n"+	//ext_est_dt = to_char(sysdate,'YYYYMMDD') and 
					" ( select count(*) tot_su3, nvl(sum(ext_pay_amt),0) tot_amt3 from ("+sub_query+") where ext_st='2' and rent_start_dt < '"+dt2+"' and ext_pay_dt = '"+dt2+"' ) c\n"+
				" union all\n"+				
				" select '소계' gubun, 'N' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(ext_pay_amt),0) tot_amt1 from ("+sub_query+") where nvl(nvl(ext_est_dt,ext_pay_dt),to_char(sysdate,'YYYYMM')) like '"+dt1+"'||'%' and ext_pay_dt is not null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(ext_pay_amt),0) tot_amt2 from ("+sub_query+") where ext_pay_dt is not null and nvl(ext_est_dt,ext_pay_dt) = '"+dt2+"' ) b,\n"+	//ext_est_dt = to_char(sysdate,'YYYYMMDD') and 
					" ( select count(*) tot_su3, nvl(sum(ext_pay_amt),0) tot_amt3 from ("+sub_query+") where rent_start_dt < "+dt2+" and ext_pay_dt = '"+dt2+"' ) c\n"+
				" union all\n"+				
				" select '미수금' gubun, '선납금' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt1 from ("+sub_query+") where ext_st='1' and nvl(nvl(ext_est_dt,ext_pay_dt),to_char(sysdate,'YYYYMM')) like '"+dt1+"'||'%' and ext_pay_dt is null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt2 from ("+sub_query+") where ext_st='1' and nvl(ext_est_dt,ext_pay_dt) = '"+dt2+"' and ext_pay_dt is null ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt3 from ("+sub_query+") where ext_st='1' and rent_start_dt < '"+dt2+"' and ext_pay_dt is null ) c\n"+
				" union all\n"+
				" select '미수금' gubun, '보증금' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt1 from ("+sub_query+") where ext_st='0' and nvl(nvl(ext_est_dt,ext_pay_dt),to_char(sysdate,'YYYYMM')) like '"+dt1+"'||'%' and ext_pay_dt is null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt2 from ("+sub_query+") where ext_st='0' and nvl(ext_est_dt,ext_pay_dt) = '"+dt2+"' and ext_pay_dt is null ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt3 from ("+sub_query+") where ext_st='0' and rent_start_dt < '"+dt2+"' and ext_pay_dt is null ) c\n"+
				" union all\n"+
				" select '미수금' gubun, '개시대여료' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt1 from ("+sub_query+") where ext_st='2' and nvl(nvl(ext_est_dt,ext_pay_dt),to_char(sysdate,'YYYYMM')) like '"+dt1+"'||'%' and ext_pay_dt is null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt2 from ("+sub_query+") where ext_st='2' and nvl(ext_est_dt,ext_pay_dt) = '"+dt2+"' and ext_pay_dt is null ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt3 from ("+sub_query+") where ext_st='2' and rent_start_dt < '"+dt2+"' and ext_pay_dt is null ) c\n"+
				" union all\n"+								
				" select '소계' gubun, 'N' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt1 from ("+sub_query+") where nvl(nvl(ext_est_dt,ext_pay_dt),to_char(sysdate,'YYYYMM')) like '"+dt1+"'||'%' and ext_pay_dt is null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt2 from ("+sub_query+") where nvl(ext_est_dt,ext_pay_dt) = '"+dt2+"' and ext_pay_dt is null ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt3 from ("+sub_query+") where rent_start_dt < '"+dt2+"' and ext_pay_dt is null ) c\n"+
				" union all\n"+								
				" select '비율' gubun, 'N' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select decode(a.tot_su1, 0,0, to_number(to_char((b.tot_su1/a.tot_su1)*100, 999.99))) tot_su1, decode(a.tot_amt1, 0,0, to_number(to_char((b.tot_amt1/a.tot_amt1)*100, 999.99))) tot_amt1 from\n"+ 
						" ( select count(*) tot_su1, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt1 from ("+sub_query+") where nvl(nvl(ext_est_dt,ext_pay_dt),to_char(sysdate,'YYYYMM')) like '"+dt1+"'||'%' ) a,\n"+
						" ( select count(*) tot_su1, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt1 from ("+sub_query+") where nvl(nvl(ext_est_dt,ext_pay_dt),to_char(sysdate,'YYYYMM')) like '"+dt1+"'||'%' and ext_pay_dt is not null ) b\n"+
					" ) a,\n"+ 
					" ( select decode(a.tot_su2, 0,0, to_number(to_char((b.tot_su2/a.tot_su2)*100, 999.99))) tot_su2, decode(a.tot_amt2, 0,0, to_number(to_char((b.tot_amt2/a.tot_amt2)*100, 999.99))) tot_amt2 from \n"+
						" ( select count(*) tot_su2, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt2 from ("+sub_query+") where (nvl(ext_est_dt,ext_pay_dt) = '"+dt2+"' or ext_pay_dt = '"+dt2+"') ) a,\n"+	
						" ( select count(*) tot_su2, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt2 from ("+sub_query+") where ext_pay_dt = '"+dt2+"' ) b\n"+	//ext_est_dt = to_char(sysdate,'YYYYMMDD') and 
					" ) b,\n"+ 
					" ( select decode(a.tot_su3, 0,0, to_number(to_char((b.tot_su3/a.tot_su3)*100, 999.99))) tot_su3, decode(a.tot_amt3, 0,0, to_number(to_char((b.tot_amt3/a.tot_amt3)*100, 999.99))) tot_amt3 from \n"+
						" ( select count(*) tot_su3, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt3 from ("+sub_query+") where rent_start_dt < '"+dt2+"' and (ext_pay_dt is null or ext_pay_dt = '"+dt2+"') ) a,\n"+
						" ( select count(*) tot_su3, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt3 from ("+sub_query+") where rent_start_dt < '"+dt2+"' and ext_pay_dt = '"+dt2+"' ) b\n"+
					" ) c";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			while(rs.next())
			{
				IncomingSBean pre = new IncomingSBean();
				pre.setGubun(rs.getString(1));
				pre.setGubun_sub(rs.getString(2));
				pre.setTot_su1(rs.getString(3));
				pre.setTot_amt1(rs.getString(4));
				pre.setTot_su2(rs.getString(5));
				pre.setTot_amt2(rs.getString(6));
				pre.setTot_su3(rs.getString(7));
				pre.setTot_amt3(rs.getString(8));
				vt.add(pre);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AccountDatabase:getPreStat2]"+e);
			System.out.println("[AccountDatabase:getPreStat2]"+query);
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
	 *	마감수금현황 조회
	 */
	public Vector getStatIncomPay(String gubun_nm, String gubun_st, String save_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select * \n"+
				" from   stat_incom_pay \n"+
				" where  save_dt=replace('"+save_dt+"','-','') \n";

		if(!gubun_nm.equals(""))			query += " and gubun_nm='"+gubun_nm+"'";

		if(gubun_st.equals("I"))			query += " and gubun_st like '%수금%'";
		else if(gubun_st.equals("P"))		query += " and gubun_st not like '%수금%'";

		query += " order by seq";

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
			System.out.println("[AccountDatabase:getStatIncomPay]"+e);
			System.out.println("[AccountDatabase:getStatIncomPay]"+query);
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
	 *	마감수금현황 조회
	 */
	public Hashtable getStatIncomPayDlyList(int mode, String s_yymm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		//디폴트 연체율
		String b_query			= "SELECT save_dt, TRUNC(dly_amt/est_amt*100,2) AS amt FROM STAT_INCOM_PAY WHERE save_dt like '"+s_yymm+"'||'%' AND gubun_nm='대여료' AND gubun_st='미수금'";

		//1개월이내 건수
		if(mode == 1)	b_query = "SELECT save_dt, nvl(dly_cnt2,0) AS amt         FROM STAT_INCOM_PAY WHERE save_dt like '"+s_yymm+"'||'%' AND gubun_nm='대여료' AND gubun_st='미수금'";
		//1개월이내 금액
		if(mode == 2)	b_query = "SELECT save_dt, nvl(dly_amt2,0) AS amt         FROM STAT_INCOM_PAY WHERE save_dt like '"+s_yymm+"'||'%' AND gubun_nm='대여료' AND gubun_st='미수금'";

		//1~2개월 건수
		if(mode == 3)	b_query = "SELECT save_dt, nvl(dly_cnt3,0) AS amt         FROM STAT_INCOM_PAY WHERE save_dt like '"+s_yymm+"'||'%' AND gubun_nm='대여료' AND gubun_st='미수금'";
		//1~2개월 금액
		if(mode == 4)	b_query = "SELECT save_dt, nvl(dly_amt3,0) AS amt         FROM STAT_INCOM_PAY WHERE save_dt like '"+s_yymm+"'||'%' AND gubun_nm='대여료' AND gubun_st='미수금'";

		//3~4개월 건수
		if(mode == 5)	b_query = "SELECT save_dt, nvl(dly_cnt4,0) AS amt         FROM STAT_INCOM_PAY WHERE save_dt like '"+s_yymm+"'||'%' AND gubun_nm='대여료' AND gubun_st='미수금'";
		//3~4개월 금액
		if(mode == 6)	b_query = "SELECT save_dt, nvl(dly_amt4,0) AS amt         FROM STAT_INCOM_PAY WHERE save_dt like '"+s_yymm+"'||'%' AND gubun_nm='대여료' AND gubun_st='미수금'";

		//4개월이상 건수
		if(mode == 7)	b_query = "SELECT save_dt, dly_cnt-nvl(dly_cnt2,0)-nvl(dly_cnt3,0)-nvl(dly_cnt4,0) AS amt FROM STAT_INCOM_PAY WHERE save_dt like '"+s_yymm+"'||'%' AND gubun_nm='대여료' AND gubun_st='미수금'";
		//4개월이상 금액
		if(mode == 8)	b_query = "SELECT save_dt, dly_amt-nvl(dly_amt2,0)-nvl(dly_amt3,0)-nvl(dly_amt4,0) AS amt FROM STAT_INCOM_PAY WHERE save_dt like '"+s_yymm+"'||'%' AND gubun_nm='대여료' AND gubun_st='미수금'";

		//소계 건수
		if(mode == 9)	b_query = "SELECT save_dt, dly_cnt AS amt                 FROM STAT_INCOM_PAY WHERE save_dt like '"+s_yymm+"'||'%' AND gubun_nm='대여료' AND gubun_st='미수금'";
		//소계 금액
		if(mode == 10)	b_query = "SELECT save_dt, dly_amt AS amt                 FROM STAT_INCOM_PAY WHERE save_dt like '"+s_yymm+"'||'%' AND gubun_nm='대여료' AND gubun_st='미수금'";

		//총대여료
		if(mode == 11)	b_query = "SELECT save_dt, est_amt AS amt                 FROM STAT_INCOM_PAY WHERE save_dt like '"+s_yymm+"'||'%' AND gubun_nm='대여료' AND gubun_st='미수금'";

		//그래프용
		if(mode == 12)	b_query = "SELECT save_dt, round(dly_amt/est_amt*100*100) AS amt FROM STAT_INCOM_PAY WHERE save_dt like '"+s_yymm+"'||'%' AND gubun_nm='대여료' AND gubun_st='미수금'";


		query = " SELECT \n"+
				"        SUM(DECODE(SUBSTR(save_dt,7,2),'01',nvl(amt,0))) amt_01, \n"+
				"        SUM(DECODE(SUBSTR(save_dt,7,2),'02',nvl(amt,0))) amt_02, \n"+
				"        SUM(DECODE(SUBSTR(save_dt,7,2),'03',nvl(amt,0))) amt_03, \n"+
				"        SUM(DECODE(SUBSTR(save_dt,7,2),'04',nvl(amt,0))) amt_04, \n"+
				"        SUM(DECODE(SUBSTR(save_dt,7,2),'05',nvl(amt,0))) amt_05, \n"+
				"        SUM(DECODE(SUBSTR(save_dt,7,2),'06',nvl(amt,0))) amt_06, \n"+
				"        SUM(DECODE(SUBSTR(save_dt,7,2),'07',nvl(amt,0))) amt_07, \n"+
				"        SUM(DECODE(SUBSTR(save_dt,7,2),'08',nvl(amt,0))) amt_08, \n"+
				"        SUM(DECODE(SUBSTR(save_dt,7,2),'09',nvl(amt,0))) amt_09, \n"+
				"        SUM(DECODE(SUBSTR(save_dt,7,2),'10',nvl(amt,0))) amt_10, \n"+
				"        SUM(DECODE(SUBSTR(save_dt,7,2),'11',nvl(amt,0))) amt_11, \n"+
				"        SUM(DECODE(SUBSTR(save_dt,7,2),'12',nvl(amt,0))) amt_12, \n"+
				"        SUM(DECODE(SUBSTR(save_dt,7,2),'13',nvl(amt,0))) amt_13, \n"+
				"        SUM(DECODE(SUBSTR(save_dt,7,2),'14',nvl(amt,0))) amt_14, \n"+
				"        SUM(DECODE(SUBSTR(save_dt,7,2),'15',nvl(amt,0))) amt_15, \n"+
				"        SUM(DECODE(SUBSTR(save_dt,7,2),'16',nvl(amt,0))) amt_16, \n"+
				"        SUM(DECODE(SUBSTR(save_dt,7,2),'17',nvl(amt,0))) amt_17, \n"+
				"        SUM(DECODE(SUBSTR(save_dt,7,2),'18',nvl(amt,0))) amt_18, \n"+
				"        SUM(DECODE(SUBSTR(save_dt,7,2),'19',nvl(amt,0))) amt_19, \n"+
				"        SUM(DECODE(SUBSTR(save_dt,7,2),'20',nvl(amt,0))) amt_20, \n"+
				"        SUM(DECODE(SUBSTR(save_dt,7,2),'21',nvl(amt,0))) amt_21, \n"+
				"        SUM(DECODE(SUBSTR(save_dt,7,2),'22',nvl(amt,0))) amt_22, \n"+
				"        SUM(DECODE(SUBSTR(save_dt,7,2),'23',nvl(amt,0))) amt_23, \n"+
				"        SUM(DECODE(SUBSTR(save_dt,7,2),'24',nvl(amt,0))) amt_24, \n"+
				"        SUM(DECODE(SUBSTR(save_dt,7,2),'25',nvl(amt,0))) amt_25, \n"+
				"        SUM(DECODE(SUBSTR(save_dt,7,2),'26',nvl(amt,0))) amt_26, \n"+
				"        SUM(DECODE(SUBSTR(save_dt,7,2),'27',nvl(amt,0))) amt_27, \n"+
				"        SUM(DECODE(SUBSTR(save_dt,7,2),'28',nvl(amt,0))) amt_28, \n"+
				"        SUM(DECODE(SUBSTR(save_dt,7,2),'29',nvl(amt,0))) amt_29, \n"+
				"        SUM(DECODE(SUBSTR(save_dt,7,2),'30',nvl(amt,0))) amt_30, \n"+  
				"        SUM(DECODE(SUBSTR(save_dt,7,2),'31',nvl(amt,0))) amt_31  \n"+
				" FROM \n"+     
				"        ("+b_query+") \n"+  
				" ";

//System.out.println("[AccountDatabase:getStatIncomPayDlyList]"+query);

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

    		ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"0":rs.getString(columnName));
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AccountDatabase:getStatIncomPayDlyList]"+e);
			System.out.println("[AccountDatabase:getStatIncomPayDlyList]"+query);
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
	 *	수금현황-대여료 에이전트
	 */
	public Vector getAgentFeeStat()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		

		query = " select         car_off_nm, car_off_id, MIN(rent_start_dt) min_rent_dt, \n"+
				//" 			         --영업현황 \n"+
				"                COUNT(rent_l_cd) cnt1, \n"+
				"                sum  (est_amt) amt1, \n"+
				//"                --연체율 \n"+
				"                DECODE(sum  (dly_amt),0,0,TRUNC(sum(dly_amt)/sum(est_amt)*100,2)) dly_per, \n"+
				//"                --1개월이내 연체 \n"+
				"                count(case when dly_amt >0 AND mon=0 then rent_l_cd else ''  end) cnt2, \n"+
				"                sum  (case when dly_amt >0 AND mon=0 then dly_amt    else 0   end) amt2, \n"+
				//"                --1개월이상 연체 \n"+
				"                count(case when dly_amt >0 AND mon=1 then rent_l_cd else ''  end) cnt3, \n"+
				"                sum  (case when dly_amt >0 AND mon=1 then dly_amt    else 0   end) amt3, \n"+
				//"                --2개월이상 연체 \n"+
				"                count(case when dly_amt >0 AND mon=2 then rent_l_cd else ''  end) cnt4, \n"+
				"                sum  (case when dly_amt >0 AND mon=2 then dly_amt    else 0   end) amt4, \n"+
				//"                --3개월이상 연체 \n"+
				"                count(case when dly_amt >0 AND mon>2 then rent_l_cd else ''  end) cnt5, \n"+
				"                sum  (case when dly_amt >0 AND mon>2 then dly_amt    else 0   end) amt5, \n"+
				//" 			   --총연체 \n"+
				"                count(case when dly_amt >0 then rent_l_cd else ''  end) cnt6, \n"+
				"                sum  (case when dly_amt >0 then dly_amt    else 0   end) amt6 \n"+
				"         from \n"+
				"                (select f.car_off_id, f.car_off_nm, b.rent_l_cd, d.user_nm, d.enter_dt, b.bus_id, b.rent_start_dt, b.rent_dt, \n"+ 
				"                        a.est_amt, a.dly_amt, DECODE(a.dly_amt,0,'',a.min_est_dt) est_dt, \n"+
				"                        DECODE(a.dly_amt,0,0,TRUNC(months_between(SYSDATE,TO_DATE(a.min_est_dt,'YYYYMMDD')))) mon \n"+
				"                 from   cont b, cls_cont c, USERS d, \n"+
				"                        ( SELECT rent_mng_id, rent_l_cd,  \n"+
				"                                 sum(case when rc_yn='0' then fee_s_amt+fee_v_amt else 0  end) est_amt, \n"+
				"                                 sum(case when r_fee_est_dt < to_char(sysdate,'YYYYMMDD') and rc_yn='0' then fee_s_amt+fee_v_amt else 0  end) dly_amt, \n"+
				"                                 MIN(case when rc_yn='0' then r_fee_est_dt else ''  end) min_est_dt  \n"+
				"                          FROM   SCD_FEE  \n"+
				"                          WHERE  nvl(bill_yn,'Y')='Y' and tm_st2<>'4' AND fee_s_amt>0 GROUP BY rent_mng_id, rent_l_cd   \n"+
				"                        ) a, car_off_emp e, car_off f \n"+
				"                 where  b.bus_st='7'  \n"+
				"                        AND b.rent_mng_id=c.rent_mng_id(+) and b.rent_l_cd=c.rent_l_cd(+) \n"+
				"                        and nvl(c.cls_st,'0') not in ('1','2') \n"+
				"                        AND b.BUS_ID=d.user_id \n"+
				"                        AND d.dept_id='1000' AND d.use_yn='Y' \n"+
				"                        and b.rent_mng_id=a.rent_mng_id and b.rent_l_cd=a.rent_l_cd \n"+
                "                        and d.sa_code=e.emp_id and e.agent_id=f.car_off_id "+
				" 				 ) \n"+
				"         GROUP BY car_off_nm, car_off_id \n"+
				"         ORDER BY min(enter_dt), min(rent_start_dt) ";

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
			System.out.println("[AccountDatabase:getAgentFeeStat]"+e);
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
	 *	수금현황-대여료 에이전트
	 */
	public Vector getAgentFeeStatList(String car_off_id, String gubun)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		

		query = "                 select b.rent_l_cd, d.user_nm, d.enter_dt, b.bus_id, b.rent_dt, b.rent_start_dt, e.firm_nm, f.car_no, f.car_nm, \n"+ 
				"                        a.est_amt, a.dly_amt, DECODE(a.dly_amt,0,'',a.min_est_dt) est_dt, \n"+
				"                        DECODE(a.dly_amt,0,0,TRUNC(months_between(SYSDATE,TO_DATE(a.min_est_dt,'YYYYMMDD')))) mon \n"+
				"                 from   cont b, cls_cont c, USERS d, \n"+
				"                        ( SELECT rent_mng_id, rent_l_cd,  \n"+
				"                                 sum(case when rc_yn='0' then fee_s_amt+fee_v_amt else 0  end) est_amt, \n"+
				"                                 sum(case when r_fee_est_dt < to_char(sysdate,'YYYYMMDD') and rc_yn='0' then fee_s_amt+fee_v_amt else 0  end) dly_amt, \n"+
				"                                 MIN(case when rc_yn='0' then r_fee_est_dt else ''  end) min_est_dt  \n"+
				"                          FROM   SCD_FEE  \n"+
				"                          WHERE  nvl(bill_yn,'Y')='Y' and tm_st2<>'4' AND fee_s_amt>0 GROUP BY rent_mng_id, rent_l_cd   \n"+
				"                        ) a, \n"+
				"                        client e, car_reg f, car_off_emp g, car_off i "+
				"                 where  b.bus_st='7'  \n"+
				"                        AND b.rent_mng_id=c.rent_mng_id(+) and b.rent_l_cd=c.rent_l_cd(+) \n"+
				"                        and nvl(c.cls_st,'0') not in ('1','2') \n"+
				"                        AND b.BUS_ID=d.user_id \n"+
				"                        AND d.dept_id='1000' AND d.use_yn='Y' \n"+
				"                        and b.rent_mng_id=a.rent_mng_id and b.rent_l_cd=a.rent_l_cd \n"+
				"                        and b.client_id=e.client_id and b.car_mng_id=f.car_mng_id "+
				"                        and d.sa_code=g.emp_id and g.agent_id=i.car_off_id and i.car_off_id='"+car_off_id+"' "+
				" 				  \n";

		//영업현황누적
		if(gubun.equals("1")){

			query += " order by b.rent_start_dt ";

		}else{

			//연체1월이내
			if(gubun.equals("2")) query += " and a.dly_amt >0 AND DECODE(a.dly_amt,0,0,TRUNC(months_between(SYSDATE,TO_DATE(a.min_est_dt,'YYYYMMDD'))))=0";

			//연체1월이상
			if(gubun.equals("3")) query += " and a.dly_amt >0 AND DECODE(a.dly_amt,0,0,TRUNC(months_between(SYSDATE,TO_DATE(a.min_est_dt,'YYYYMMDD'))))=1";

			//연체2월이상
			if(gubun.equals("4")) query += " and a.dly_amt >0 AND DECODE(a.dly_amt,0,0,TRUNC(months_between(SYSDATE,TO_DATE(a.min_est_dt,'YYYYMMDD'))))=2";

			//연체3월이상
			if(gubun.equals("5")) query += " and a.dly_amt >0 AND DECODE(a.dly_amt,0,0,TRUNC(months_between(SYSDATE,TO_DATE(a.min_est_dt,'YYYYMMDD'))))>2";

			//연체
			if(gubun.equals("6")) query += " and a.dly_amt >0 ";
	
			query += " order by DECODE(a.dly_amt,0,'',a.min_est_dt) ";
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
			System.out.println("[AccountDatabase:getAgentFeeStatList]"+e);
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
	 *	마감수금현황 조회
	 */
	public String getAgentFirstRentDt(String car_off_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String first_dt = "";
		String query = "";

		query = " SELECT MIN(c.rent_dt) rent_dt "+ 
				" FROM   car_off_emp a, COMMI b, CONT c "+ 
				" WHERE  a.agent_id='"+car_off_id+"' and a.emp_id=b.emp_id and b.agnt_st='1' AND b.rent_mng_id=c.rent_mng_id AND b.rent_l_cd=c.rent_l_cd \n";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

    		if(rs.next())
			{				
				 first_dt = rs.getString("rent_dt")==null?"":rs.getString("rent_dt");
			}

			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AccountDatabase:getAgentFirstRentDt]"+e);
			System.out.println("[AccountDatabase:getAgentFirstRentDt]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return first_dt;
		}
	}	

	/**
	 *	수금현황-대여료
	 */
	public Vector getFeeRmStat(String br_id, String search_kd, String brch_id, String bus_id2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";
		String dt1 = "to_char(sysdate,'YYYYMM')";
		String dt2 = "to_char(sysdate,'YYYYMMDD')";

		sub_query = "select a.fee_est_dt, a.r_fee_est_dt, a.rc_yn, a.rc_dt, decode(a.rc_yn, '0', a.fee_s_amt+a.fee_v_amt, a.rc_amt) fee_amt from scd_fee a, cont b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.bill_yn,'Y')='Y' and a.tm_st2<>'4' and a.fee_s_amt>0 and b.car_st='4' ";// and nvl(b.use_yn,'Y')='Y'

		if(search_kd.equals("1"))		sub_query += " and b.brch_id='"+brch_id+"'";
		else if(search_kd.equals("2"))	sub_query += " and b.bus_id2='"+bus_id2+"'";

		query = " select '계획' gubun, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(fee_amt),0) tot_amt1 from ("+sub_query+") where r_fee_est_dt like "+dt1+"||'%' ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(fee_amt),0) tot_amt2 from ("+sub_query+") where (r_fee_est_dt = "+dt2+" and (rc_yn='0' or rc_dt = "+dt2+") or (r_fee_est_dt >= "+dt2+" and rc_dt = "+dt2+")) ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(fee_amt),0) tot_amt3 from ("+sub_query+") where r_fee_est_dt < "+dt2+" and (rc_yn='0' or rc_dt = "+dt2+") ) c\n"+
				" union all\n"+
				" select '수금' gubun, a.*, b.*, c.*\n"+
				" from\n"+
					" ( select count(*) tot_su1, nvl(sum(fee_amt),0) tot_amt1 from ("+sub_query+") where r_fee_est_dt like "+dt1+"||'%' and rc_yn='1' ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(fee_amt),0) tot_amt2 from ("+sub_query+") where r_fee_est_dt >= "+dt2+" and rc_dt = "+dt2+" ) b,\n"+ 
					" ( select count(*) tot_su3, nvl(sum(fee_amt),0) tot_amt3 from ("+sub_query+") where r_fee_est_dt < "+dt2+" and rc_dt = "+dt2+" ) c\n"+
				" union all\n"+
				" select '미수금' gubun, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(fee_amt),0) tot_amt1 from ("+sub_query+") where r_fee_est_dt like "+dt1+"||'%' and rc_yn='0' ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(fee_amt),0) tot_amt2 from ("+sub_query+") where r_fee_est_dt = "+dt2+" and rc_yn = '0' ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(fee_amt),0) tot_amt3 from ("+sub_query+") where r_fee_est_dt < "+dt2+" and rc_yn = '0' ) c\n"+
				" union all\n"+
				" select '수금율' gubun, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select decode(a.tot_su1, 0,0, to_number(to_char((b.tot_su1/a.tot_su1)*100, 999.99))) tot_su1, decode(a.tot_amt1, 0,0, to_number(to_char((b.tot_amt1/a.tot_amt1)*100, 999.99))) tot_amt1 from\n"+ 
						" ( select count(*) tot_su1, nvl(sum(fee_amt),0) tot_amt1 from ("+sub_query+") where r_fee_est_dt like "+dt1+"||'%' ) a,\n"+
						" ( select count(*) tot_su1, nvl(sum(fee_amt),0) tot_amt1 from ("+sub_query+") where r_fee_est_dt like "+dt1+"||'%' and rc_yn='1' ) b\n"+
					" ) a,\n"+
					" ( select decode(a.tot_su2, 0,0, to_number(to_char((b.tot_su2/a.tot_su2)*100, 999.99))) tot_su2, decode(a.tot_amt2, 0,0, to_number(to_char((b.tot_amt2/a.tot_amt2)*100, 999.99))) tot_amt2 from\n"+ 
						" ( select count(*) tot_su2, nvl(sum(fee_amt),0) tot_amt2 from ("+sub_query+") where (r_fee_est_dt = "+dt2+" and (rc_yn='0' or rc_dt = "+dt2+") or (r_fee_est_dt >= "+dt2+" and rc_dt = "+dt2+")) ) a,\n"+	
						" ( select count(*) tot_su2, nvl(sum(fee_amt),0) tot_amt2 from ("+sub_query+") where r_fee_est_dt >= "+dt2+" and rc_dt = "+dt2+" ) b\n"+ 
					" ) b,\n"+
					" ( select decode(a.tot_su3, 0,0, to_number(to_char((b.tot_su3/a.tot_su3)*100, 999.99))) tot_su3, decode(a.tot_amt3, 0,0, to_number(to_char((b.tot_amt3/a.tot_amt3)*100, 999.99))) tot_amt3 from\n"+ 
						" ( select count(*) tot_su3, nvl(sum(fee_amt),0) tot_amt3 from ("+sub_query+") where r_fee_est_dt < "+dt2+" and (rc_yn='0' or rc_dt = "+dt2+") ) a,\n"+
						" ( select count(*) tot_su3, nvl(sum(fee_amt),0) tot_amt3 from ("+sub_query+") where r_fee_est_dt < "+dt2+" and rc_dt = "+dt2+" ) b\n"+
					" ) c"+
                " "; 

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			while(rs.next())
			{
				IncomingSBean fee = new IncomingSBean();
				fee.setGubun(rs.getString(1));
				fee.setTot_su1(rs.getString(2));
				fee.setTot_amt1(rs.getString(3));
				fee.setTot_su2(rs.getString(4));
				fee.setTot_amt2(rs.getString(5));
				fee.setTot_su3(rs.getString(6));
				fee.setTot_amt3(rs.getString(7));
				vt.add(fee);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AccountDatabase:getFeeRmStat]"+e);
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
	 *	수금현황-정비대차
	 */
	public Vector getCarSRent2Stat(String br_id, String search_kd, String brch_id, String bus_id2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";

		sub_query = " select '9' st, '정비대차' gubun_nm, "+
                    "        se.est_dt as est_dt, se.est_dt as r_est_dt, "+
                    "        decode(se.pay_dt,'','0','1') as pay_yn, se.pay_dt as pay_dt, "+
                    "        decode(se.pay_dt, '', se.rent_s_amt+se.rent_v_amt, se.pay_amt) amt, 0 mon "+
                    " from   scd_rent se, RENT_CONT a, cont b "+
                    " where  se.rent_s_amt > 0 and nvl(se.bill_yn,'Y')='Y' "+
                    "        and se.rent_s_cd = a.rent_s_cd AND a.rent_st='2' AND a.use_st<>'5' "+
                    "        and a.sub_c_id=b.car_mng_id and a.sub_l_cd=b.rent_l_cd";

		if(search_kd.equals("1"))		sub_query += " and b.brch_id='"+brch_id+"'";
		else if(search_kd.equals("2"))	sub_query += " and b.bus_id2='"+bus_id2+"'";

		query = " select '계획' gubun, a.*, b.*, c.*\n"+
				" from\n"+
					" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where est_dt like to_char(sysdate,'YYYYMM')||'%' ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt = to_char(sysdate,'YYYYMMDD') ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt < to_char(sysdate,'YYYYMMDD') and (pay_dt is null or pay_dt = to_char(sysdate,'YYYYMMDD')) ) c\n"+
				" union all\n"+
				" select '수금' gubun, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where est_dt like to_char(sysdate,'YYYYMM')||'%' and pay_dt is not null) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt = to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD') ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt < to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD') ) c\n"+
				" union all\n"+
				" select '미수금' gubun, a.*, b.*, c.*\n"+
				" from \n"+
					" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where est_dt like to_char(sysdate,'YYYYMM')||'%' and pay_dt is null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt = to_char(sysdate,'YYYYMMDD') and pay_dt is null) b,\n"+
					" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt < to_char(sysdate,'YYYYMMDD') and pay_dt is null ) c\n"+
				" union all\n"+
				" select '수금율' gubun, a.*, b.*, c.*\n"+
				" from \n"+
					" ( select decode(a.tot_su1, 0,0, to_number(to_char((b.tot_su1/a.tot_su1)*100, 999.99))) tot_su1, decode(a.tot_amt1, 0,0, to_number(to_char((b.tot_amt1/a.tot_amt1)*100, 999.99))) tot_amt1 from \n"+
						" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where est_dt like to_char(sysdate,'YYYYMM')||'%' ) a,\n"+
						" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where est_dt like to_char(sysdate,'YYYYMM')||'%' and pay_dt is not null ) b\n"+
					" ) a,\n"+
					" ( select decode(a.tot_su2, 0,0, to_number(to_char((b.tot_su2/a.tot_su2)*100, 999.99))) tot_su2, decode(a.tot_amt2, 0,0, to_number(to_char((b.tot_amt2/a.tot_amt2)*100, 999.99))) tot_amt2 from \n"+
						" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt = to_char(sysdate,'YYYYMMDD') ) a,\n"+
						" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where est_dt = to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD') ) b\n"+
					" ) b,\n"+
					" ( select decode(a.tot_su3, 0,0, to_number(to_char((b.tot_su3/a.tot_su3)*100, 999.99))) tot_su3, decode(a.tot_amt3, 0,0, to_number(to_char((b.tot_amt3/a.tot_amt3)*100, 999.99))) tot_amt3 from \n"+
						" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt < to_char(sysdate,'YYYYMMDD') and (pay_dt is null or pay_dt = to_char(sysdate,'YYYYMMDD')) ) a,\n"+
						" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where est_dt < to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD') ) b\n"+
					" ) c";
				
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			while(rs.next())
			{
				IncomingSBean fee = new IncomingSBean();
				fee.setGubun(rs.getString(1));
				fee.setTot_su1(rs.getString(2));
				fee.setTot_amt1(rs.getString(3));
				fee.setTot_su2(rs.getString(4));
				fee.setTot_amt2(rs.getString(5));
				fee.setTot_su3(rs.getString(6));
				fee.setTot_amt3(rs.getString(7));
				vt.add(fee);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AccountDatabase:getCarSRent2Stat]"+e);
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
