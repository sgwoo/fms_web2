package acar.debt;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.AddUtil;
import acar.cont.*;
import acar.account.*;

public class AddDebtDatabase
{
	private Connection conn = null;
	public static AddDebtDatabase d_db;
	
	public static AddDebtDatabase getInstance()
	{
		if(AddDebtDatabase.d_db == null)
			AddDebtDatabase.d_db = new AddDebtDatabase();
		return AddDebtDatabase.d_db;	
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


	//할부금 납부--------------------------------------------------------------------------------------------

	/**
	 *	지출현황 - 할부금 납부처리를 위한 리스트
	 */
	public Vector getAllotPayList(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select * from debt_pay_view";

		/*상세조회&&세부조회*/

		//당월-계획
		if(gubun2.equals("1") && gubun3.equals("1")){		query += " where substr(r_alt_est_dt,1,7) = to_char(SYSDATE, 'YYYY-MM')";
		//당월-수금
		}else if(gubun2.equals("1") && gubun3.equals("2")){	query += " where substr(r_alt_est_dt,1,7) = to_char(SYSDATE, 'YYYY-MM') and pay_yn='1'";
		//당월-미수금
		}else if(gubun2.equals("1") && gubun3.equals("3")){	query += " where substr(r_alt_est_dt,1,7) = to_char(SYSDATE, 'YYYY-MM') and pay_yn='0'";
		//당일-계획
		}else if(gubun2.equals("2") && gubun3.equals("1")){	query += " where r_alt_est_dt = to_char(SYSDATE, 'YYYY-MM-DD')";
		//당일-수금
		}else if(gubun2.equals("2") && gubun3.equals("2")){	query += " where r_alt_est_dt = to_char(SYSDATE, 'YYYY-MM-DD') and pay_dt = to_char(SYSDATE, 'YYYY-MM-DD')";
		//당일-미수금
		}else if(gubun2.equals("2") && gubun3.equals("3")){	query += " where r_alt_est_dt = to_char(SYSDATE, 'YYYY-MM-DD') and pay_yn='0'";
		//연체-계획
		}else if(gubun2.equals("3") && gubun3.equals("1")){	query += " where r_alt_est_dt < to_char(SYSDATE, 'YYYY-MM-DD') and (pay_dt is null or pay_dt = to_char(SYSDATE, 'YYYY-MM-DD'))";
		//연체-수금
		}else if(gubun2.equals("3") && gubun3.equals("2")){	query += " where r_alt_est_dt < to_char(SYSDATE, 'YYYY-MM-DD') and pay_dt = to_char(SYSDATE, 'YYYY-MM-DD')";
		//연체-미수금
		}else if(gubun2.equals("3") && gubun3.equals("3")){	query += " where r_alt_est_dt < to_char(SYSDATE, 'YYYY-MM-DD') and pay_yn='0'";
		//기간-계획
		}else if(gubun2.equals("4") && gubun3.equals("1")){	query += " where r_alt_est_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		//기간-수금
		}else if(gubun2.equals("4") && gubun3.equals("2")){	query += " where pay_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and pay_yn='1'";
		//기간-미수금
		}else if(gubun2.equals("4") && gubun3.equals("3")){	query += " where r_alt_est_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and pay_yn='0'";
		//검색-수금
		}else if(gubun2.equals("5") && gubun3.equals("2")){	query += " where pay_yn='1'";
		//검색-미수금
		}else if(gubun2.equals("5") && gubun3.equals("3")){	query += " where pay_yn='0'";
		//당일+연체-계획
		}else if(gubun2.equals("6") && gubun3.equals("1")){	query += " where r_alt_est_dt <= to_char(SYSDATE, 'YYYY-MM-DD') and (pay_yn='0' or pay_dt = to_char(SYSDATE, 'YYYY-MM-DD'))";
		//당일+연체-수금
		}else if(gubun2.equals("6") && gubun3.equals("2")){	query += " where r_alt_est_dt <= to_char(SYSDATE, 'YYYY-MM-DD') and pay_dt = to_char(SYSDATE, 'YYYY-MM-DD')";
		//당일+연체-미수금
		}else if(gubun2.equals("6") && gubun3.equals("3")){	query += " where r_alt_est_dt <= to_char(SYSDATE, 'YYYY-MM-DD') and pay_yn='0'";
		}else{												query += " where rent_l_cd=rent_l_cd";
		}
	
		if(!gubun4.equals(""))		query += " and cpt_cd='"+gubun4+"'";
		
		/*검색조건*/
			
		if(s_kd.equals("1"))		query += " and nvl(firm_nm, '') like '%"+t_wd+"%'\n";			
		else if(s_kd.equals("2"))	query += " and nvl(client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and (nvl(car_no, '') like '%"+t_wd+"%' or nvl(first_car_no, '') like '%"+t_wd+"%')\n";
		else if(s_kd.equals("5"))	query += " and alt_amt like '%"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	query += " and substr(rent_l_cd,1,2) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("9"))	query += " and nvl(car_nm, '') like '%"+t_wd+"%'\n";

		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		/*정렬조건*/

		if(sort_gubun.equals("0"))		query += " order by pay_dt "+sort+",  alt_est_dt, firm_nm";
		else if(sort_gubun.equals("1"))	query += " order by firm_nm "+sort+", alt_est_dt, pay_dt";
		else if(sort_gubun.equals("2"))	query += " order by cpt_nm "+sort+", firm_nm, alt_est_dt";
		else if(sort_gubun.equals("3"))	query += " order by alt_amt "+sort+", cpt_cd,     alt_est_dt, firm_nm";
		else if(sort_gubun.equals("5"))	query += " order by car_no "+sort+",  firm_nm,    alt_est_dt";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next()){				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddDebtDatabase:getAllotPayList]"+ e);
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
	 *	 할부금 스케줄 처리를 위한 리스트
	 */
	public Vector getAllotScdList(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select * from debt_scd_view";

		/*상세조회&&세부조회*/

		//기간-전체
		if(gubun2.equals("4") && gubun3.equals("1")){	query += " where lend_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		//기간-등록
		}else if(gubun2.equals("4") && gubun3.equals("2")){	query += " where lend_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and reg_yn='Y'";
		//기간-미등록
		}else if(gubun2.equals("4") && gubun3.equals("3")){	query += " where lend_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and reg_yn='N'";
		//검색-등록
		}else if(gubun2.equals("5") && gubun3.equals("2")){	query += " where reg_yn='Y'";
		//검색-미등록
		}else if(gubun2.equals("5") && gubun3.equals("3")){	query += " where reg_yn='N'";
		}else{												query += " where rent_l_cd=rent_l_cd";
		}
	
		if(!gubun4.equals(""))		query += " and cpt_cd='"+gubun4+"'";
		
		/*검색조건*/
			
		if(s_kd.equals("1"))		query += " and nvl(firm_nm, '') like '%"+t_wd+"%'\n";			
		else if(s_kd.equals("2"))	query += " and nvl(client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and (nvl(car_no, '') like '%"+t_wd+"%' or nvl(first_car_no, '') like '%"+t_wd+"%')\n";
		else if(s_kd.equals("5"))	query += " and alt_amt like '%"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	query += " and substr(rent_l_cd,1,2) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("9"))	query += " and nvl(car_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("10"))	query += " and nvl(car_no, '') like '%"+t_wd+"%' and use_yn='N'\n";
		else if(s_kd.equals("11"))	query += " and nvl(lend_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("12"))	query += " and cpt_cd like '%"+t_wd+"%'\n";
		else if(s_kd.equals("13"))	query += " and LEND_PRN='"+t_wd+"'\n";

		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		/*정렬조건*/

		if(sort_gubun.equals("0"))		query += " order by all_yn desc, lend_dt "+sort+",  firm_nm";
		else if(sort_gubun.equals("1"))	query += " order by all_yn desc, firm_nm "+sort+", lend_dt";
		else if(sort_gubun.equals("2"))	query += " order by all_yn desc, cpt_cd "+sort+", firm_nm, lend_dt";
		else if(sort_gubun.equals("3"))	query += " order by all_yn desc, alt_amt "+sort+", firm_nm";
//		else if(sort_gubun.equals("4"))	query += " order by all_yn desc, dly_day "+sort+", rc_dt, firm_nm, fee_est_dt";
		else if(sort_gubun.equals("5"))	query += " order by all_yn desc, car_no "+sort+",  firm_nm, lend_dt";
		else if(sort_gubun.equals("6"))	query += " order by all_yn desc, lend_no "+sort+",  firm_nm, lend_dt";

//System.out.println("cpt_cd = "+query);    

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next()){				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddDebtDatabase:getAllotScdList]"+ e);
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
	 *	지출현황 - 할부금 납부처리를 위한 리스트 --- 통계
	 */
	public Vector getAllotPayStat(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";

		sub_query = " select alt_prn, alt_int, alt_rest, alt_amt, pay_yn from debt_pay_view ";

		/*상세조회&&세부조회*/

		//당월-계획
		if(gubun2.equals("1") && gubun3.equals("1")){		sub_query += " where substr(r_alt_est_dt,1,7) = to_char(SYSDATE, 'YYYY-MM')";
		//당월-수금
		}else if(gubun2.equals("1") && gubun3.equals("2")){	sub_query += " where substr(r_alt_est_dt,1,7) = to_char(SYSDATE, 'YYYY-MM') and pay_yn='1'";
		//당월-미수금
		}else if(gubun2.equals("1") && gubun3.equals("3")){	sub_query += " where substr(r_alt_est_dt,1,7) = to_char(SYSDATE, 'YYYY-MM') and pay_yn='0'";
		//당일-계획
		}else if(gubun2.equals("2") && gubun3.equals("1")){	sub_query += " where r_alt_est_dt = to_char(SYSDATE, 'YYYY-MM-DD')";
		//당일-수금
		}else if(gubun2.equals("2") && gubun3.equals("2")){	sub_query += " where r_alt_est_dt = to_char(SYSDATE, 'YYYY-MM-DD') and pay_dt = to_char(SYSDATE, 'YYYY-MM-DD')";
		//당일-미수금
		}else if(gubun2.equals("2") && gubun3.equals("3")){	sub_query += " where r_alt_est_dt = to_char(SYSDATE, 'YYYY-MM-DD') and pay_yn='0'";
		//기간-계획
		}else if(gubun2.equals("4") && gubun3.equals("1")){	sub_query += " where r_alt_est_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		//기간-수금
		}else if(gubun2.equals("4") && gubun3.equals("2")){	sub_query += " where r_alt_est_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and pay_yn='1'";
		//기간-미수금
		}else if(gubun2.equals("4") && gubun3.equals("3")){	sub_query += " where r_alt_est_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and pay_yn='0'";
		//검색-수금
		}else if(gubun2.equals("5") && gubun3.equals("2")){	sub_query += " where pay_yn='1'";
		//검색-미수금
		}else if(gubun2.equals("5") && gubun3.equals("3")){	sub_query += " where pay_yn='0'";
		}else{												sub_query += " where rent_l_cd=rent_l_cd";
		}
	
		if(!gubun4.equals(""))		sub_query += " and cpt_cd='"+gubun4+"'";
		
		if(!br_id.equals("S1") && !br_id.equals(""))		sub_query += " and rent_l_cd like '"+br_id+"%'";

		/*검색조건*/
			
		if(s_kd.equals("1"))		sub_query += " and nvl(firm_nm, '') like '%"+t_wd+"%'\n";			
		else if(s_kd.equals("2"))	sub_query += " and nvl(client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	sub_query += " and upper(rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	sub_query += " and nvl(car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("5"))	sub_query += " and alt_amt like '%"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	sub_query += " and substr(rent_l_cd,1,2) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("9"))	sub_query += " and nvl(car_nm, '') like '%"+t_wd+"%'\n";
		
		query = " select '상환' gubun, a.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(alt_prn),0) tot_amt1, nvl(sum(alt_int),0) tot_amt2, nvl(sum(alt_rest),0) tot_amt3, nvl(sum(alt_amt),0) tot_amt4 from ("+sub_query+") where pay_yn='1' ) a\n"+	
				" union all\n"+
				" select '잔액' gubun, a.*\n"+
				" from \n"+
					" ( select count(*) tot_su1, nvl(sum(alt_prn),0) tot_amt1, nvl(sum(alt_int),0) tot_amt2, nvl(sum(alt_rest),0) tot_amt3, nvl(sum(alt_amt),0) tot_amt4 from ("+sub_query+") where pay_yn='0' ) a\n"+
				" union all\n"+
				" select '합계' gubun, a.*\n"+
				" from \n"+
					" ( select count(*) tot_su1, nvl(sum(alt_prn),0) tot_amt1, nvl(sum(alt_int),0) tot_amt2, nvl(sum(alt_rest),0) tot_amt3, nvl(sum(alt_amt),0) tot_amt4 from ("+sub_query+") ) a\n";
		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			while(rs.next())
			{
				IncomingBean debt = new IncomingBean();
				debt.setGubun(rs.getString(1));
				debt.setTot_su1(rs.getInt(2));
				debt.setTot_rate1(rs.getString(3));
				debt.setTot_rate2(rs.getString(4));
				debt.setTot_rate3(rs.getString(5));
				debt.setTot_rate4(rs.getString(6));
				vt.add(debt);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddDebtDatabase:getAllotPayStat]"+ e);
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


	/** 지출현황 - 출금처리
	 *	한 건에 대한 한회차 할부금 스케줄 쿼리 -- 출금처리위한
	 *	car_id : 차량관리번호, alt_tm : 회차
	 */
	public Hashtable getADebtScdPay(String gubun, String car_id, String alt_tm, String lend_id, String rtn_seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = " select /*+ INDEX(SCD_ALT_CASE.SCD_ALT_CASE_PK) */ * from debt_pay_view";

		if(gubun.equals("0"))		query += " where car_mng_id='"+car_id+"' and alt_tm='"+alt_tm+"'";
		else if(gubun.equals("1"))	query += " where alt_tm='"+alt_tm+"' and lend_id='"+lend_id+"'";
		else 						query += " where alt_tm='"+alt_tm+"' and lend_id='"+lend_id+"' and rtn_seq='"+rtn_seq+"'";

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
			System.out.println("[AddDebtDatabase:getADebtScdPay]"+ e);
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
	 *	할부금 납부처리를 위한 리스트
	 */
	public Vector getAllotPayList(String r_est, String r_rc, String s_kd, String t_wd, String t_st_dt, String t_end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select * from debt_pay_view";

		//전체:전체
		if(r_rc.equals("0") && r_est.equals("0"))		query += " where alt_est_dt = alt_est_dt";
		//전체:당일
		else if(r_rc.equals("0") && r_est.equals("1"))	query += " where r_alt_est_dt = to_char(sysdate, 'YYYY-MM-DD')";
		//전체:기간
		else if(r_rc.equals("0") && r_est.equals("2"))	query += " where r_alt_est_dt between '"+t_st_dt+"' and '"+t_end_dt+"'";
		//출금:전체
		else if(r_rc.equals("1") && r_est.equals("0"))	query += " where pay_yn = '1'";
		//출금:당일
		else if(r_rc.equals("1") && r_est.equals("1"))	query += " where pay_yn = '1' and pay_dt = to_char(sysdate, 'YYYY-MM-DD')";
		//출금:기간
//		else if(r_rc.equals("1") && r_est.equals("2"))	query += " where pay_yn = '1' and pay_dt between '"+t_st_dt+"' and '"+t_end_dt+"'";
		else if(r_rc.equals("1") && r_est.equals("2"))	query += " where pay_yn = '1' and r_alt_est_dt between '"+t_st_dt+"' and '"+t_end_dt+"'";
		//미출금:전체
		else if(r_rc.equals("2") && r_est.equals("0"))	query += " where pay_yn = '0'";			
		//미출금:당일
		else if(r_rc.equals("2") && r_est.equals("1"))	query += " where pay_yn = '0' and r_alt_est_dt = to_char(sysdate, 'YYYY-MM-DD')";			
		//미출금:기간
		else if(r_rc.equals("2") && r_est.equals("2"))	query += " where pay_yn = '0' and r_alt_est_dt between '"+t_st_dt+"' and '"+t_end_dt+"'";
		
		if(s_kd.equals("1"))			query += " and firm_nm like '%"+t_wd+"%'";
		else if(s_kd.equals("2"))		query += " and upper(rent_l_cd) like upper('%"+t_wd+"%')";
		else if(s_kd.equals("3"))		query += " and car_no like '%"+t_wd+"%'";
		else if(s_kd.equals("4"))		query += " and cpt_cd = '"+t_wd+"'";
		else if(s_kd.equals("5"))		query += " and ALT_AMT ="+t_wd;

		query += " order by gubun, rent_l_cd, client_id, cpt_cd, rent_mng_id desc, to_number(alt_tm)";


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next()){				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);	
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
	 *	할부금 납부처리를 위한 리스트 --- 통계
	 */
	public Hashtable getAllotPayStat(String r_est, String r_rc, String s_kd, String t_wd, String t_st_dt, String t_end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String in_query = "";
		in_query = " select "+
					" car_mng_id, alt_tm, rent_mng_id, rent_l_cd, firm_nm, client_nm, car_nm, cpt_cd, cpt_nm, car_no, alt_prn,"+
					" alt_int, alt_amt, alt_rest, pay_dt, alt_est_dt, pay_yn, client_id, lend_id, gubun,"+
					//cnt:미출금/출금 alt_prn:할부원금 alt_int:할부이자 alt_rest:잔액
					" decode(pay_yn, '0', 1, 0) N_CNT,"+
					" decode(pay_yn, '1', 1, 0) Y_CNT,"+
					" decode(pay_yn, '0', alt_prn, 0) N_ALT_PRN,"+
					" decode(pay_yn, '1', alt_prn, 0) Y_ALT_PRN,"+
					" decode(pay_yn, '0', alt_int, 0) N_ALT_INT,"+
					" decode(pay_yn, '1', alt_int, 0) Y_ALT_INT,"+
					" decode(pay_yn, '0', (alt_prn+alt_int), 0) N_ALT_AMT,"+
					" decode(pay_yn, '1', (alt_prn+alt_int), 0) Y_ALT_AMT,"+
					" decode(pay_yn, '0', ALT_REST, 0) N_ALT_REST,"+
					" decode(pay_yn, '1', ALT_REST, 0) Y_ALT_REST"+
					" from debt_pay_view";
		//전체:전체
		if(r_rc.equals("0") && r_est.equals("0"))		in_query += " where alt_est_dt = alt_est_dt";
		//전체:당일
		else if(r_rc.equals("0") && r_est.equals("1"))	in_query += " where r_alt_est_dt = to_char(sysdate, 'YYYY-MM-DD')";
		//전체:기간
		else if(r_rc.equals("0") && r_est.equals("2"))	in_query += " where r_alt_est_dt between '"+t_st_dt+"' and '"+t_end_dt+"'";
		//출금:전체
		else if(r_rc.equals("1") && r_est.equals("0"))	in_query += " where pay_yn = '1'";
		//출금:당일
		else if(r_rc.equals("1") && r_est.equals("1"))	in_query += " where pay_yn = '1' and pay_dt = to_char(sysdate, 'YYYY-MM-DD')";
		//출금:기간
//		else if(r_rc.equals("1") && r_est.equals("2"))	in_query += " where pay_yn = '1' and pay_dt between '"+t_st_dt+"' and '"+t_end_dt+"'";
		else if(r_rc.equals("1") && r_est.equals("2"))	in_query += " where pay_yn = '1' and r_alt_est_dt between '"+t_st_dt+"' and '"+t_end_dt+"'";
		//미출금:전체
		else if(r_rc.equals("2") && r_est.equals("0"))	in_query += " where pay_yn = '0'";			
		//미출금:당일
		else if(r_rc.equals("2") && r_est.equals("1"))	in_query += " where pay_yn = '0' and r_alt_est_dt = to_char(sysdate, 'YYYY-MM-DD')";			
		//미출금:기간
		else if(r_rc.equals("2") && r_est.equals("2"))	in_query += " where pay_yn = '0' and r_alt_est_dt between '"+t_st_dt+"' and '"+t_end_dt+"'";
		
		if(s_kd.equals("1"))			in_query += " and firm_nm like '%"+t_wd+"%'";
		else if(s_kd.equals("2"))		in_query += " and upper(rent_l_cd) like upper('%"+t_wd+"%')";
		else if(s_kd.equals("3"))		in_query += " and car_no like '%"+t_wd+"%'";
		else if(s_kd.equals("4"))		in_query += " and cpt_cd = '"+t_wd+"'";
		else if(s_kd.equals("5"))		in_query += " and ALT_AMT ="+t_wd;

		String query = "";
		query = " select"+
				" nvl(SUM(n_cnt), 0) N_CNT, nvl(sum(n_alt_prn), 0) N_ALT_PRN1, nvl(sum(n_alt_int), 0) N_ALT_INT1, nvl(sum(n_alt_amt), 0) N_ALT_AMT1, nvl(sum(n_alt_rest), 0) N_ALT_REST1,"+ 
				" nvl(SUM(y_cnt), 0) Y_CNT, nvl(sum(y_alt_prn), 0) Y_ALT_PRN2, nvl(sum(y_alt_int), 0) Y_ALT_INT2, nvl(sum(y_alt_amt), 0) Y_ALT_AMT2, nvl(sum(y_alt_rest), 0) Y_ALT_REST2,"+ 
				" nvl(SUM(n_cnt+y_cnt), 0) CNT, nvl(sum(n_alt_prn+y_alt_prn), 0) ALT_PRN1, nvl(sum(n_alt_int+y_alt_int), 0) ALT_INT1,"+
				" nvl(sum(n_alt_amt+y_alt_amt), 0) ALT_AMT1, nvl(sum(n_alt_rest+y_alt_rest), 0) ALT_REST1"+ 
				" from"+
				" ( "+in_query+" )";
		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next()){				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));					 
				}
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
			return ht;
		}
	}
	
	/**
	 *	리스트 : 할부금스케줄 리스트
	 *
	 *	--차량등록이 안된경우 할부금스케줄작성 리스트에서 볼수 없다..--
	 *	할부금 등록여부와 함께 계약 건 리스트 리턴
	 *	kd - 1:상호, 2:고객명, 3:금융사, 4:대출일, 5:계약코드
	 *	reg_yn - Y:할부금스케줄등록상태, N:할부금스케줄미등록상태
	 */
	public Vector getAllotListByCase(String s_kd, String t_wd, String r_reg_yn)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "select * from debt_scd_view";

		//기타항목 검색 
		if(s_kd.equals("1"))			query += " where nvl(use_yn,'Y')='Y' and cls_st is null and nvl(firm_nm, ' ') like '%"+t_wd+"%'";
		else if(s_kd.equals("2"))		query += " where nvl(use_yn,'Y')='Y' and cls_st is null and nvl(client_nm, ' ') like '%%"+t_wd+"%'";
		else if(s_kd.equals("3"))
		{
			if(t_wd.equals(""))			query += " where nvl(use_yn,'Y')='Y' and cls_st is null and allot_st = '1'";									//현금구매
			else						query += " where nvl(use_yn,'Y')='Y' and cls_st is null and cpt_cd like '%"+t_wd+"%' and allot_st = '2'";	//일반할부구매
	  	}
	  	else if(s_kd.equals("4"))		query += " where nvl(use_yn,'Y')='Y' and cls_st is null and nvl(lend_dt, ' ') like '%"+t_wd+"%'";
	  	else if(s_kd.equals("5"))		query += " where nvl(use_yn,'Y')='Y' and cls_st is null and upper(rent_l_cd) like upper('%"+t_wd+"%')";
	  	else if(s_kd.equals("6"))		query += " where car_no like '%"+t_wd+"%'";
	  	else if(s_kd.equals("7"))		query += " where use_yn='N' and cls_st='6' and car_no like '%"+t_wd+"%'";
		else							query += " where nvl(use_yn,'Y')='Y' and cls_st is null";
		
		//등록구분 검색
		if(r_reg_yn.equals("Y"))		query += " and car_mng_id is not null and reg_yn='Y'";
		else if(r_reg_yn.equals("N"))	query += " and car_mng_id is null and reg_yn='N'";

		query += " order by lend_dt, rent_mng_id desc";

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
			System.out.println("[AddDebtDatabase:getAllotListByCase]"+e);
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
	
	//재계약 등록 : 할부
	public Hashtable getAllotByCase(String m_id, String l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		query = " select"+
				" R.car_mng_id, nvl(L.firm_nm, L.client_nm) FIRM_NM, nvl(L.enp_no, TEXT_DECRYPT(l.ssn, 'pw' ) ) ENP_NO, N.car_name, C.car_st, "+
				" R.car_no, decode(R.first_car_no, R.car_no,'-', R.first_car_no) first_car_no, R.car_nm, R.dpm, F.con_mon, decode(F.rent_way, '1','일반식', '2','맞춤식') rent_way,"+
			    " ((E.car_cs_amt+E.car_cv_amt)+(E.opt_cs_amt+E.opt_cv_amt)+(E.clr_cs_amt+E.clr_cv_amt)+(E.sd_cs_amt+E.sd_cv_amt)-(E.dc_cs_amt+E.dc_cv_amt)-(E.tax_dc_s_amt+E.tax_dc_v_amt)) car_c_amt,"+
				" ((E.car_fs_amt+E.car_fv_amt)+(E.sd_cs_amt+E.sd_cv_amt)-(E.dc_cs_amt+E.dc_cv_amt)) car_f_amt,"+
				" (F.fee_s_amt+F.fee_v_amt) fee_amt,"+
				" ((F.fee_s_amt+F.fee_v_amt)*F.con_mon) tot_fee_amt,"+
				" F.grt_amt_s as grt_amt,"+
				" (F.pp_s_amt+F.pp_v_amt) pp_amt,"+
				" (F.ifee_s_amt+F.ifee_v_amt) ifee_amt,"+
				" (F.grt_amt_s+(F.pp_s_amt+F.pp_v_amt)+(F.ifee_s_amt+F.ifee_v_amt)) tot_pre_amt,"+
				" decode(R.init_reg_dt, '', '', substr(R.init_reg_dt, 1, 4) || '-' || substr(R.init_reg_dt, 5, 2) || '-'||substr(R.init_reg_dt, 7, 2)) init_reg_dt,"+
				" decode(C.dlv_dt, '', '', substr(C.dlv_dt, 1, 4) || '-' || substr(C.dlv_dt, 5, 2) || '-'||substr(C.dlv_dt, 7, 2)) dlv_dt,"+
				" decode(P.dlv_con_dt, '', '', substr(P.dlv_con_dt, 1, 4) || '-' || substr(P.dlv_con_dt, 5, 2) || '-'||substr(P.dlv_con_dt, 7, 2)) dlv_con_dt,"+
				" decode(F.rent_start_dt, '', '', substr(F.rent_start_dt, 1, 4) || '-' || substr(F.rent_start_dt, 5, 2) || '-'||substr(F.rent_start_dt, 7, 2)) rent_start_dt,"+
				" decode(F.rent_end_dt, '', '', substr(F.rent_end_dt, 1, 4) || '-' || substr(F.rent_end_dt, 5, 2) || '-'||substr(F.rent_end_dt, 7, 2)) rent_end_dt,"+
				" decode(S.cls_dt, '', '', substr(S.cls_dt, 1, 4) || '-' || substr(S.cls_dt, 5, 2) || '-'||substr(S.cls_dt, 7, 2)) cls_dt"+
				" from client L, car_reg R, car_etc E, Fee F, cont C, car_nm N, car_pur P, cls_cont S"+
				" where "+
				" C.client_id=L.client_id and"+
				" C.car_mng_id=R.car_mng_id(+) and"+
				" C.rent_mng_id=E.rent_mng_id and C.rent_l_cd=E.rent_l_cd and"+
				" C.rent_mng_id=F.rent_mng_id and C.rent_l_cd=F.rent_l_cd and"+
				" C.rent_mng_id=P.rent_mng_id and C.rent_l_cd=P.rent_l_cd and"+
				" C.rent_mng_id=S.rent_mng_id(+) and C.rent_l_cd=S.rent_l_cd(+) and"+
				" E.car_id=N.car_id(+) and"+
				" C.rent_mng_id = '"+m_id+"' and C.rent_l_cd = '"+l_cd+"'";
		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
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
			System.out.println("[AddDebtDatabase:getContDebt]\n"+e);
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
	 *	할부금관리 -> 할부 등록 => debt_reg_i_a.jsp에서 호출
	 */
	public boolean updateContDebt(ContDebtBean debt)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		String car_id=debt.getCar_mng_id();
		String imsi_car_id="";
		String imsi_chk="0";

		String query_id = "select nvl(lpad(substr(max(car_mng_id),2,6)+1,5,0), '00001') "+
							" from ALLOT where substr(car_mng_id,1,1)='A'";//imsi_chk='1' and 

		String query = "";
		query = " update ALLOT set "+
				" ALLOT_ST=?, CPT_CD=?,	LEND_INT=?, LEND_PRN=?, ALT_FEE=?,"+
				" RTN_TOT_AMT=?, LOAN_DEBTOR=?,	RTN_CDT=?, RTN_WAY=?, RTN_EST_DT=replace(?,'-',''),"+
				" LEND_NO=?, NTRL_FEE=?, STP_FEE=?, LEND_DT=replace(?,'-',''), LEND_INT_AMT=?,"+
				" ALT_AMT=?, TOT_ALT_TM=?, ALT_START_DT=replace(?,'-',''), ALT_END_DT=replace(?,'-',''), BOND_GET_ST=?,"+
				" FST_PAY_DT=replace(?,'-',''), FST_PAY_AMT=?,"+//22
				" CPT_CD_ST=?, LEND_ID=?, CAR_MNG_ID=?,"+
				" LOAN_ST_DT=replace(?,'-',''), LOAN_SCH_AMT=?, PAY_SCH_AMT=?, DIF_AMT=?, IMSI_CHK=?,"+
				" RTN_SEQ=?, LOAN_ST=?,"+//32
				" BOND_GET_ST_SUB=?, CLS_RTN_DT=replace(?,'-',''), CLS_RTN_AMT=?, CLS_RTN_FEE=?, NOTE=?,"+
				" CLS_RTN_CAU=?, RIMITTER=?,"+	//39	
				" AUTODOC_YN=?, VEN_CODE=?, BANK_CODE=?, DEPOSIT_NO=?, ACCT_CODE=?, "+
				" cls_rtn_fee_int=?, cls_rtn_etc=?, cms_code=?, fund_id=?, alt_etc=?, alt_etc_amt=?, alt_etc_tm=?  "+
				" ";//44

			query += " where RENT_MNG_ID=? and RENT_L_CD=?";
		


		try 
		{
			conn.setAutoCommit(false);

  			pstmt1 = conn.prepareStatement(query_id);
			rs = pstmt1.executeQuery();
			if(rs.next()){
				imsi_car_id = rs.getString(1)==null?"":rs.getString(1);
			}

			if(car_id.equals("")){ //미등록차량일 경우 임시코드로 등록한다.
				car_id = "A"+imsi_car_id;
				imsi_chk = "1";
			}
			rs.close();
			pstmt1.close();

			pstmt2 = conn.prepareStatement(query);
			pstmt2.setString(1, debt.getAllot_st());
			pstmt2.setString(2, debt.getCpt_cd());
			pstmt2.setString(3, debt.getLend_int());
			pstmt2.setInt(4, debt.getLend_prn());
			pstmt2.setInt(5, debt.getAlt_fee());
			pstmt2.setInt(6, debt.getRtn_tot_amt());
			pstmt2.setString(7, debt.getLoan_debtor());
			pstmt2.setString(8, debt.getRtn_cdt());
			pstmt2.setString(9, debt.getRtn_way());
			pstmt2.setString(10, debt.getRtn_est_dt());
			pstmt2.setString(11, debt.getLend_no().trim());
			pstmt2.setInt(12, debt.getNtrl_fee());
			pstmt2.setInt(13, debt.getStp_fee());
			pstmt2.setString(14, debt.getLend_dt());
			pstmt2.setInt(15, debt.getLend_int_amt());
			pstmt2.setInt(16, debt.getAlt_amt());
			pstmt2.setString(17, debt.getTot_alt_tm());
			pstmt2.setString(18, debt.getAlt_start_dt());
			pstmt2.setString(19, debt.getAlt_end_dt());
			pstmt2.setString(20, debt.getBond_get_st());
			pstmt2.setString(21, debt.getFst_pay_dt());
			pstmt2.setInt(22, debt.getFst_pay_amt());
			pstmt2.setString(23, debt.getCpt_cd_st());
			pstmt2.setString(24, debt.getLend_id());
			pstmt2.setString(25, car_id);			
			pstmt2.setString(26, debt.getLoan_st_dt());
			pstmt2.setInt(27, debt.getLoan_sch_amt());
			pstmt2.setInt(28, debt.getPay_sch_amt());
			pstmt2.setInt(29, debt.getDif_amt());
			pstmt2.setString(30, imsi_chk);
			pstmt2.setString(31, debt.getRtn_seq());
			pstmt2.setString(32, debt.getLoan_st());
			pstmt2.setString(33, debt.getBond_get_st_sub());
			pstmt2.setString(34, debt.getCls_rtn_dt());
			pstmt2.setInt(35, debt.getCls_rtn_amt());
			pstmt2.setInt(36, debt.getCls_rtn_fee());
			pstmt2.setString(37, debt.getNote());
			pstmt2.setString(38, debt.getCls_rtn_cau());
			pstmt2.setString(39, debt.getRimitter());
			pstmt2.setString(40, debt.getAutodoc_yn());
			pstmt2.setString(41, debt.getVen_code());
			pstmt2.setString(42, debt.getBank_code());
			pstmt2.setString(43, debt.getDeposit_no());
			pstmt2.setString(44, debt.getAcct_code());
			pstmt2.setString(45, debt.getCls_rtn_fee_int());
			pstmt2.setString(46, debt.getCls_rtn_etc());
			pstmt2.setString(47, debt.getCms_code());
			pstmt2.setString(48, debt.getFund_id());
			
			pstmt2.setString(49, debt.getAlt_etc());
			pstmt2.setInt   (50, debt.getAlt_etc_amt());
			pstmt2.setString(51, debt.getAlt_etc_tm());
			
			pstmt2.setString(52, debt.getRent_mng_id());
			pstmt2.setString(53, debt.getRent_l_cd());
			pstmt2.executeUpdate();
			pstmt2.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddDebtDatabase:updateContDebt]"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(rs != null )		rs.close();
				if(pstmt1 != null )	pstmt1.close();
				if(pstmt2 != null )	pstmt2.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}

	/**
	 *	할부금관리 -> 할부 조회 => debt_reg_u.jsp에서 호출
	 */
	public ContDebtBean getContDebtReg(String m_id, String l_cd)
	{
		getConnection();
		ContDebtBean debt = new ContDebtBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT"+
				"        a.RENT_MNG_ID, a.RENT_L_CD, a.allot_st, a.cpt_cd, a.lend_int, a.lend_prn, a.alt_fee, a.rtn_tot_amt, a.loan_debtor, "+
				"        a.rtn_cdt, a.rtn_way, a.lend_no, a.rtn_est_dt, a.ntrl_fee, a.stp_fee, "+
				"        a.lend_int_amt, a.alt_amt, a.tot_alt_tm,  "+
		 		"        decode(a.lend_dt, '', '', substr(a.lend_dt, 1, 4)||'-'||substr(a.lend_dt, 5, 2)||'-'||substr(a.lend_dt, 7, 2)) lend_dt,"+
		 		"        decode(a.alt_start_dt, '', '', substr(a.alt_start_dt, 1, 4)||'-'||substr(a.alt_start_dt, 5, 2)||'-'||substr(a.alt_start_dt, 7, 2)) alt_start_dt,"+
		 		"        decode(a.alt_end_dt, '', '', substr(a.alt_end_dt, 1, 4)||'-'||substr(a.alt_end_dt, 5, 2)||'-'||substr(a.alt_end_dt, 7, 2)) alt_end_dt,"+
				"        a.bond_get_st, a.bond_st, a.fst_pay_amt, a.bond_get_st_sub, a.cls_rtn_amt, a.cls_rtn_fee, a.note, a.cpt_cd_st, a.lend_id, a.car_mng_id,"+
		 		"        decode(a.fst_pay_dt, '', '', substr(a.fst_pay_dt, 1, 4)||'-'||substr(a.fst_pay_dt, 5, 2)||'-'||substr(a.fst_pay_dt, 7, 2)) fst_pay_dt,"+
		 		"        decode(a.cls_rtn_dt, '', '', substr(a.cls_rtn_dt, 1, 4)||'-'||substr(a.cls_rtn_dt, 5, 2)||'-'||substr(a.cls_rtn_dt, 7, 2)) cls_rtn_dt,"+
		 		"        decode(a.loan_st_dt, '', '', substr(a.loan_st_dt, 1, 4)||'-'||substr(a.loan_st_dt, 5, 2)||'-'||substr(a.loan_st_dt, 7, 2)) loan_st_dt,"+
				"        a.loan_sch_amt, a.pay_sch_amt, a.dif_amt, a.imsi_chk, a.rtn_seq, a.loan_st,"+
				"        a.cls_rtn_cau, a.rimitter, decode(b.cls_rtn_dt,'','N','Y') cls_yn, a.autodoc_yn, a.ven_code, a.acct_code, a.bank_code, a.deposit_no, "+
				"        a.cls_rtn_fee_int, a.cls_rtn_etc, a.file_name, a.file_type, a.cms_code, a.fund_id, "+
				"        a.alt_etc, a.alt_etc_amt, a.alt_etc_tm "+
				" FROM   ALLOT a, CLS_ALLOT b"+
				" WHERE  a.rent_mng_id=b.rent_mng_id(+) and a.rent_l_cd=b.rent_l_cd(+) and a.rent_mng_id=? and a.rent_l_cd=?";
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, m_id);
			pstmt.setString(2, l_cd);
		   	rs = pstmt.executeQuery();
			if(rs.next()){
				debt.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				debt.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				debt.setAllot_st(rs.getString("ALLOT_ST")==null?"":rs.getString("ALLOT_ST"));	
				debt.setCpt_cd(rs.getString("CPT_CD")==null?"":rs.getString("CPT_CD"));	
				debt.setLend_int(rs.getString("LEND_INT")==null?"":rs.getString("LEND_INT"));	
				debt.setLend_prn(rs.getString("LEND_PRN")==null?0:Integer.parseInt(rs.getString("LEND_PRN")));			
				debt.setAlt_fee(rs.getString("ALT_FEE")==null?0:Integer.parseInt(rs.getString("ALT_FEE")));			
				debt.setRtn_tot_amt(rs.getString("RTN_TOT_AMT")==null?0:Integer.parseInt(rs.getString("RTN_TOT_AMT")));		
				debt.setLoan_debtor(rs.getString("LOAN_DEBTOR")==null?"":rs.getString("LOAN_DEBTOR"));
				debt.setRtn_cdt(rs.getString("RTN_CDT")==null?"":rs.getString("RTN_CDT"));	
				debt.setRtn_way(rs.getString("RTN_WAY")==null?"":rs.getString("RTN_WAY"));	
				debt.setRtn_est_dt(rs.getString("RTN_EST_DT")==null?"":rs.getString("RTN_EST_DT"));
				debt.setLend_no(rs.getString("LEND_NO")==null?"":rs.getString("LEND_NO"));			
				debt.setNtrl_fee(rs.getString("NTRL_FEE")==null?0:Integer.parseInt(rs.getString("NTRL_FEE")));			
				debt.setStp_fee(rs.getString("STP_FEE")==null?0:Integer.parseInt(rs.getString("STP_FEE")));			
				debt.setLend_dt(rs.getString("LEND_DT")==null?"":rs.getString("LEND_DT"));	
				debt.setLend_int_amt(rs.getString("LEND_INT_AMT")==null?0:Integer.parseInt(rs.getString("LEND_INT_AMT")));		
				debt.setAlt_amt(rs.getString("ALT_AMT")==null?0:Integer.parseInt(rs.getString("ALT_AMT")));			
				debt.setTot_alt_tm(rs.getString("TOT_ALT_TM")==null?"":rs.getString("TOT_ALT_TM"));
				debt.setAlt_start_dt(rs.getString("ALT_START_DT")==null?"":rs.getString("ALT_START_DT"));
				debt.setAlt_end_dt(rs.getString("ALT_END_DT")==null?"":rs.getString("ALT_END_DT"));
				debt.setBond_get_st(rs.getString("BOND_GET_ST")==null?"":rs.getString("BOND_GET_ST"));
				debt.setFst_pay_dt(rs.getString("FST_PAY_DT")==null?"":rs.getString("FST_PAY_DT"));
				debt.setFst_pay_amt(rs.getString("FST_PAY_AMT")==null?0:Integer.parseInt(rs.getString("FST_PAY_AMT")));
				debt.setBond_get_st_sub(rs.getString("BOND_GET_ST_SUB")==null?"":rs.getString("BOND_GET_ST_SUB"));
				debt.setCls_rtn_dt(rs.getString("CLS_RTN_DT")==null?"":rs.getString("CLS_RTN_DT"));
				debt.setCls_rtn_amt(rs.getString("CLS_RTN_AMT")==null?0:Integer.parseInt(rs.getString("CLS_RTN_AMT")));
				debt.setCls_rtn_fee(rs.getString("CLS_RTN_FEE")==null?0:Integer.parseInt(rs.getString("CLS_RTN_FEE")));
				debt.setNote(rs.getString("NOTE")==null?"":rs.getString("NOTE"));
				debt.setCpt_cd_st(rs.getString("CPT_CD_ST")==null?"":rs.getString("CPT_CD_ST"));
				debt.setLend_id(rs.getString("LEND_ID")==null?"":rs.getString("LEND_ID"));
				debt.setCar_mng_id(rs.getString("CAR_MNG_ID")==null?"":rs.getString("CAR_MNG_ID"));
				debt.setLoan_st_dt(rs.getString("LOAN_ST_DT")==null?"":rs.getString("LOAN_ST_DT"));
				debt.setLoan_sch_amt(rs.getString("LOAN_SCH_AMT")==null?0:Integer.parseInt(rs.getString("LOAN_SCH_AMT")));
				debt.setPay_sch_amt(rs.getString("PAY_SCH_AMT")==null?0:Integer.parseInt(rs.getString("PAY_SCH_AMT")));
				debt.setDif_amt(rs.getString("DIF_AMT")==null?0:Integer.parseInt(rs.getString("DIF_AMT")));
				debt.setImsi_chk(rs.getString("IMSI_CHK")==null?"":rs.getString("IMSI_CHK"));
				debt.setRtn_seq(rs.getString("RTN_SEQ")==null?"":rs.getString("RTN_SEQ"));
				debt.setLoan_st(rs.getString("LOAN_ST")==null?"":rs.getString("LOAN_ST"));
				debt.setCls_rtn_cau(rs.getString("cls_rtn_cau")==null?"":rs.getString("cls_rtn_cau"));
				debt.setRimitter(rs.getString("rimitter")==null?"":rs.getString("rimitter"));
				debt.setCls_yn(rs.getString("cls_yn")==null?"":rs.getString("cls_yn"));
				debt.setAutodoc_yn(rs.getString("autodoc_yn")==null?"":rs.getString("autodoc_yn"));
				debt.setVen_code(rs.getString("ven_code")==null?"":rs.getString("ven_code"));
				debt.setBank_code(rs.getString("bank_code")==null?"":rs.getString("bank_code"));
				debt.setDeposit_no(rs.getString("deposit_no")==null?"":rs.getString("deposit_no"));
				debt.setAcct_code(rs.getString("acct_code")==null?"":rs.getString("acct_code"));
				debt.setCls_rtn_fee_int	(rs.getString("cls_rtn_fee_int")==null?"":rs.getString("cls_rtn_fee_int"));
				debt.setCls_rtn_etc		(rs.getString("cls_rtn_etc")==null?"":rs.getString("cls_rtn_etc"));
				debt.setFile_name		(rs.getString("file_name")==null?"":rs.getString("file_name"));
				debt.setFile_type		(rs.getString("file_type")==null?"":rs.getString("file_type"));
				debt.setCms_code		(rs.getString("cms_code")==null?"":rs.getString("cms_code"));
				debt.setFund_id			(rs.getString("fund_id")==null?"":rs.getString("fund_id"));
				debt.setAlt_etc		(rs.getString("alt_etc")==null?"":rs.getString("alt_etc"));
				debt.setAlt_etc_amt	(rs.getString("alt_etc_amt")==null?0:Integer.parseInt(rs.getString("alt_etc_amt")));
				debt.setAlt_etc_tm	(rs.getString("alt_etc_tm")==null?"":rs.getString("alt_etc_tm"));
				
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddDebtDatabase:getContDebtReg]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return debt;
		}
	}

	/**
	 *	할부금관리 -> 근저당설정 등록 => debt_reg_i_a.jsp에서 호출
	 */
	public boolean insertContCltr(CltrBean cltr)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		String cltr_id="";
		String query_id = "select nvl(ltrim(to_char(max(cltr_id)+1, '00')), '01') ID from cltr\n "+
						  " where rent_mng_id =? and rent_l_cd=?" ;

		String query = "insert into CLTR \n"+
						" (RENT_MNG_ID, RENT_L_CD, CLTR_ID, CLTR_AMT, CLTR_PER_LOAN,\n"+
						" CLTR_EXP_DT, CLTR_SET_DT, REG_TAX, CLTR_DOCS_DT, CLTR_F_AMT,\n"+
						" CLTR_EXP_CAU, MORT_LANK, CLTR_USER, CLTR_OFFICE, CLTR_OFFI_MAN,\n"+
						" CLTR_OFFI_TEL, CLTR_OFFI_FAX, SET_STP_FEE, EXP_TAX, EXP_STP_FEE,\n"+
						" CLTR_ST, CLTR_NUM)\n"+
						" values\n"+
						" (?, ?, ?, ?, ?,"+
						" replace(?,'-',''), replace(?,'-',''), ?, replace(?,'-',''), ?,"+
						" ?, ?, ?, ?, ?,"+
						" ?, ?, ?, ?, ?,"+
						" ?, ?)";//22
		try 
		{
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query_id);
			pstmt1.setString(1, cltr.getRent_mng_id());
			pstmt1.setString(2, cltr.getRent_l_cd());
			rs = pstmt1.executeQuery();
			if(rs.next()){
				cltr_id = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt1.close();

			pstmt2 = conn.prepareStatement(query);
			pstmt2.setString(1, cltr.getRent_mng_id());
			pstmt2.setString(2, cltr.getRent_l_cd());
			pstmt2.setString(3, cltr_id);
			pstmt2.setInt   (4, cltr.getCltr_amt());
			pstmt2.setString(5, cltr.getCltr_per_loan());
			pstmt2.setString(6, cltr.getCltr_exp_dt());
			pstmt2.setString(7, cltr.getCltr_set_dt());
			pstmt2.setInt   (8, cltr.getReg_tax());
			pstmt2.setString(9, cltr.getCltr_docs_dt());
			pstmt2.setInt   (10, cltr.getCltr_f_amt());
			pstmt2.setString(11, cltr.getCltr_exp_cau());
			pstmt2.setString(12, cltr.getMort_lank());
			pstmt2.setString(13, cltr.getCltr_user());
			pstmt2.setString(14, cltr.getCltr_office());
			pstmt2.setString(15, cltr.getCltr_offi_man());
			pstmt2.setString(16, cltr.getCltr_offi_tel());
			pstmt2.setString(17, cltr.getCltr_offi_fax());
			pstmt2.setInt   (18, cltr.getSet_stp_fee());
			pstmt2.setInt   (19, cltr.getExp_tax());
			pstmt2.setInt   (20, cltr.getExp_stp_fee());
			pstmt2.setString(21, cltr.getCltr_st());
			pstmt2.setString(22, cltr.getCltr_num());
			pstmt2.executeUpdate();
			pstmt2.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[AddDebtDatabase:insertContCltr]"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(rs != null )		rs.close();
				if(pstmt1 != null )	pstmt1.close();
				if(pstmt2 != null )	pstmt2.close();
				
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}

	/**
	 *	할부금관리 -> 근저당설정 수정 => debt_reg_u_a.jsp에서 호출
	 */
	public boolean updateContCltr(CltrBean cltr)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "update CLTR set\n"+
						" CLTR_AMT=?, CLTR_PER_LOAN=?, CLTR_EXP_DT=replace(?,'-',''), CLTR_SET_DT=replace(?,'-',''), REG_TAX=?,\n"+
						" CLTR_DOCS_DT=replace(?,'-',''), CLTR_F_AMT=?, CLTR_EXP_CAU=?, MORT_LANK=?, CLTR_USER=?,\n"+
						" CLTR_OFFICE=?, CLTR_OFFI_MAN=?, CLTR_OFFI_TEL=?, CLTR_OFFI_FAX=?, SET_STP_FEE=?,\n"+
						" EXP_TAX=?, EXP_STP_FEE=?, CLTR_ST=?, CLTR_NUM=?\n"+
						" where rent_mng_id=? and rent_l_cd=? and cltr_id=?";//21
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, cltr.getCltr_amt());
			pstmt.setString(2, cltr.getCltr_per_loan());
			pstmt.setString(3, cltr.getCltr_exp_dt());
			pstmt.setString(4, cltr.getCltr_set_dt());
			pstmt.setInt(5, cltr.getReg_tax());
			pstmt.setString(6, cltr.getCltr_docs_dt());
			pstmt.setInt(7, cltr.getCltr_f_amt());
			pstmt.setString(8, cltr.getCltr_exp_cau());
			pstmt.setString(9, cltr.getMort_lank());
			pstmt.setString(10, cltr.getCltr_user());
			pstmt.setString(11, cltr.getCltr_office());
			pstmt.setString(12, cltr.getCltr_offi_man());
			pstmt.setString(13, cltr.getCltr_offi_tel());
			pstmt.setString(14, cltr.getCltr_offi_fax());
			pstmt.setInt(15, cltr.getSet_stp_fee());
			pstmt.setInt(16, cltr.getExp_tax());
			pstmt.setInt(17, cltr.getExp_stp_fee());
			pstmt.setString(18, cltr.getCltr_st());
			pstmt.setString(19, cltr.getCltr_num());
			pstmt.setString(20, cltr.getRent_mng_id());
			pstmt.setString(21, cltr.getRent_l_cd());
			pstmt.setString(22, cltr.getCltr_id());
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddDebtDatabase:updateBankMapping_cltr]"+e);
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
	 *	매핑 테이블 update -> 근저당설정 수정
	 */
	public boolean updateBankMapping_cltr(CltrBean cltr)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "update TEST_CLTR set\n"+
						" CLTR_AMT=?, CLTR_PER_LOAN=?, CLTR_EXP_DT=replace(?,'-',''), CLTR_SET_DT=replace(?,'-',''), REG_TAX=?,\n"+
						" CLTR_DOCS_DT=replace(?,'-',''), CLTR_F_AMT=?, CLTR_EXP_CAU=?, MORT_LANK=?, CLTR_USER=?,\n"+
						" CLTR_OFFICE=?, CLTR_OFFI_MAN=?, CLTR_OFFI_TEL=?, CLTR_OFFI_FAX=?, SET_STP_FEE=?,\n"+
						" EXP_TAX=?, EXP_STP_FEE=?, CLTR_ST=?\n"+
						" where rent_mng_id=? and rent_l_cd=? and cltr_id=?";//21
		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, cltr.getCltr_amt());
			pstmt.setString(2, cltr.getCltr_per_loan());
			pstmt.setString(3, cltr.getCltr_exp_dt());
			pstmt.setString(4, cltr.getCltr_set_dt());
			pstmt.setInt(5, cltr.getReg_tax());
			pstmt.setString(6, cltr.getCltr_docs_dt());
			pstmt.setInt(7, cltr.getCltr_f_amt());
			pstmt.setString(8, cltr.getCltr_exp_cau());
			pstmt.setString(9, cltr.getMort_lank());
			pstmt.setString(10, cltr.getCltr_user());
			pstmt.setString(11, cltr.getCltr_office());
			pstmt.setString(12, cltr.getCltr_offi_man());
			pstmt.setString(13, cltr.getCltr_offi_tel());
			pstmt.setString(14, cltr.getCltr_offi_fax());
			pstmt.setInt(15, cltr.getSet_stp_fee());
			pstmt.setInt(16, cltr.getExp_tax());
			pstmt.setInt(17, cltr.getExp_stp_fee());
			pstmt.setString(18, cltr.getCltr_st());
			pstmt.setString(19, cltr.getRent_mng_id());
			pstmt.setString(20, cltr.getRent_l_cd());
			pstmt.setString(21, cltr.getCltr_id());
			pstmt.executeUpdate();
			pstmt.close();
		    conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddDebtDatabase:updateBankMapping_cltr]"+e);
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
	 *	매핑 테이블 조회 (근저당설정)
	 */
	public CltrBean getBankLend_mapping_cltr(String m_id, String l_cd)
	{
		getConnection();
		CltrBean cltr = new CltrBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		query = " select"+
				" cltr_id, cltr_amt, cltr_per_loan, reg_tax, cltr_f_amt, cltr_exp_cau, mort_lank,"+
				" cltr_user, cltr_office, cltr_offi_man, cltr_offi_tel, cltr_offi_fax,"+
				" set_stp_fee, exp_tax, exp_stp_fee, cltr_st, cltr_num,"+
				" decode(cltr_exp_dt, '', '', substr(cltr_exp_dt, 1, 4) || '-' || substr(cltr_exp_dt, 5, 2) || '-'||substr(cltr_exp_dt, 7, 2)) cltr_exp_dt,"+
				" decode(cltr_set_dt, '', '', substr(cltr_set_dt, 1, 4) || '-' || substr(cltr_set_dt, 5, 2) || '-'||substr(cltr_set_dt, 7, 2)) cltr_set_dt,"+
				" decode(cltr_docs_dt, '', '', substr(cltr_docs_dt, 1, 4) || '-' || substr(cltr_docs_dt, 5, 2) || '-'||substr(cltr_docs_dt, 7, 2)) cltr_docs_dt"+
				" from cltr"+
				" where rent_mng_id=? and rent_l_cd=?";
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, m_id);
			pstmt.setString(2, l_cd);
		   	rs = pstmt.executeQuery();
			if(rs.next()){
				cltr.setCltr_id(rs.getString("CLTR_ID")==null?"":rs.getString("CLTR_ID"));
				cltr.setCltr_amt(rs.getString("CLTR_AMT")==null?0:Integer.parseInt(rs.getString("CLTR_AMT")));
				cltr.setCltr_per_loan(rs.getString("CLTR_PER_LOAN")==null?"":rs.getString("CLTR_PER_LOAN"));
				cltr.setCltr_exp_dt(rs.getString("CLTR_EXP_DT")==null?"":rs.getString("CLTR_EXP_DT"));
				cltr.setCltr_set_dt(rs.getString("CLTR_SET_DT")==null?"":rs.getString("CLTR_SET_DT"));
				cltr.setReg_tax(rs.getString("REG_TAX")==null?0:Integer.parseInt(rs.getString("REG_TAX")));
				cltr.setCltr_docs_dt(rs.getString("CLTR_DOCS_DT")==null?"":rs.getString("CLTR_DOCS_DT"));
				cltr.setCltr_f_amt(rs.getString("CLTR_F_AMT")==null?0:Integer.parseInt(rs.getString("CLTR_F_AMT")));
				cltr.setCltr_exp_cau(rs.getString("CLTR_EXP_CAU")==null?"":rs.getString("CLTR_EXP_CAU"));
				cltr.setMort_lank(rs.getString("MORT_LANK")==null?"":rs.getString("MORT_LANK"));
				cltr.setCltr_user(rs.getString("CLTR_USER")==null?"":rs.getString("CLTR_USER"));
				cltr.setCltr_office(rs.getString("CLTR_OFFICE")==null?"":rs.getString("CLTR_OFFICE"));
				cltr.setCltr_offi_man(rs.getString("CLTR_OFFI_MAN")==null?"":rs.getString("CLTR_OFFI_MAN"));
				cltr.setCltr_offi_tel(rs.getString("CLTR_OFFI_TEL")==null?"":rs.getString("CLTR_OFFI_TEL"));
				cltr.setCltr_offi_fax(rs.getString("CLTR_OFFI_FAX")==null?"":rs.getString("CLTR_OFFI_FAX"));
				cltr.setSet_stp_fee(rs.getString("SET_STP_FEE")==null?0:Integer.parseInt(rs.getString("SET_STP_FEE")));
				cltr.setExp_tax(rs.getString("EXP_TAX")==null?0:Integer.parseInt(rs.getString("EXP_TAX")));
				cltr.setExp_stp_fee(rs.getString("EXP_STP_FEE")==null?0:Integer.parseInt(rs.getString("EXP_STP_FEE")));
				cltr.setCltr_st(rs.getString("CLTR_ST")==null?"":rs.getString("CLTR_ST"));
				cltr.setCltr_num(rs.getString("CLTR_NUM")==null?"":rs.getString("CLTR_NUM"));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddDebtDatabase:getBankLend_mapping_cltr]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return cltr;
		}
	}

	//계약 변경 : 중도해지 조회
	public Hashtable getAllotClsinfo(String m_id, String l_cd, String car_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		query = " select"+
				" a.rent_l_cd, nvl(b.firm_nm, b.client_nm) firm_nm, car_nm, car_no, d.lend_no, d.cpt_cd, d.lend_prn, d.lend_int, e.alt_tm,"+
				" decode(d.lend_dt, '', '', substr(d.lend_dt, 1, 4) || '-' || substr(d.lend_dt, 5, 2) || '-'||substr(d.lend_dt, 7, 2)) lend_dt, d.cls_rtn_fee_int, d.cls_rtn_etc "+
				" from cont a, client b, car_reg c, allot d,"+
				" (select car_mng_id, max(to_number(alt_tm)) alt_tm from scd_alt_case where pay_yn='1' group by car_mng_id) e"+
				" where a.client_id=b.client_id and a.car_mng_id=c.car_mng_id and a.rent_l_cd=d.rent_l_cd and a.car_mng_id=e.car_mng_id"+
				" and a.rent_l_cd='"+l_cd+"' and a.car_mng_id='"+car_id+"'";

		try {
			stmt = conn.createStatement();
		   	rs = stmt.executeQuery(query);
	    	ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
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
			System.out.println("[AddDebtDatabase:getAllotClsinfo]\n"+e);			
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

	//계약 변경 : 중도해지 조회 - 미상환금
	public Hashtable getAllotNalt_rest(String car_id, String alt_tm)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "select a.alt_rest, b.nalt_rest_1, b.nalt_rest_2, "+
						" decode(a.pay_dt, '', '', substr(a.pay_dt, 1, 4) || '-' || substr(a.pay_dt, 5, 2) || '-'||substr(a.pay_dt, 7, 2)) pay_dt"+
						" from scd_alt_case a, "+
						" (select sum(decode(substr(alt_est_dt,1,4),to_char(sysdate,'YYYY'),alt_prn)) nalt_rest_1, "+
                        "         sum(decode(substr(alt_est_dt,1,4),to_char(sysdate,'YYYY'),0,alt_prn)) nalt_rest_2 "+
						"  from scd_alt_case where car_mng_id='"+car_id+"' and pay_yn='0') b "+
						" where a.car_mng_id='"+car_id+"' and a.alt_tm='"+alt_tm+"'";

		try {
			stmt = conn.createStatement();
		   	rs = stmt.executeQuery(query);
	    	ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
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
			System.out.println("[AddDebtDatabase:getAllotNalt_rest]\n"+e);			
			System.out.println("[AddDebtDatabase:getAllotNalt_rest]\n"+query);			
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

	//계약 변경 : 중도해지 조회 - 연체할부금
	public int getAllotDly_alt(String car_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		int dly_alt = 0;
		String query = "select sum(alt_prn+alt_int) dly_alt from scd_alt_case where car_mng_id='"+car_id+"' and pay_yn='0' and alt_est_dt<to_char(sysdate,'yyyymmdd')";

		try {

			stmt = conn.createStatement();
		   	rs = stmt.executeQuery(query);
			if(rs.next()){				
				dly_alt= rs.getInt(1);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddDebtDatabase:getAllotDly_alt]\n"+e);			
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return dly_alt;
		}	
	}

	//계약 변경 : 중도해지 조회 - 선수금
	public int getAllotBe_alt(String car_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		int be_alt = 0;
		String query = "select sum(alt_prn+alt_int) be_alt from scd_alt_case where car_mng_id='"+car_id+"' and pay_yn='1' and alt_est_dt>to_char(sysdate,'yyyymmdd') and alt_est_dt > pay_dt";

		try {

			stmt = conn.createStatement();
		   	rs = stmt.executeQuery(query);
			if(rs.next()){				
				be_alt= rs.getInt(1);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddDebtDatabase:getAllotBe_alt]\n"+e);			
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return be_alt;
		}	
	}

	/**
	 *	금융사별 대출리스트 조회
	 */
	public Vector getBankLendList(String cpt_cd, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select "+
				" d.firm_nm, f.car_nm, e.car_name, c.car_no, a.lend_dt, a.lend_prn,"+
				//" decode(c.car_ext,'1','서울','2','파주','3','부산','4','김해','5','대전','6','포천','7','인천','8','제주','9','광주','10','대구') car_ext, c.car_doc_no"+
				" i.nm car_ext, c.car_doc_no"+
				" from allot a, cont b, car_reg c, client d, car_etc g, car_nm e, car_mng f,"+
				" (select car_mng_id, min(rent_dt||substr(rent_l_cd,1,2)||reg_dt) min_value from cont where car_st<>'4' group by car_mng_id) h,"+
				" (select * from code where c_st='0032') i "+
				" where"+
				" a.cpt_cd='"+cpt_cd+"'"+
				" and a.lend_dt between replace('"+st_dt+"', '-', '') and replace('"+end_dt+"', '-', '')"+
				" and a.rent_l_cd=b.rent_l_cd"+
				" and b.car_mng_id=c.car_mng_id(+)"+
				" and b.client_id=d.client_id"+
				" and a.rent_l_cd=g.rent_l_cd"+
				" and g.car_id=e.car_id and g.car_seq=e.car_seq and e.car_comp_id=f.car_comp_id and e.car_cd=f.code"+
				" and b.car_mng_id=h.car_mng_id(+) and b.rent_dt||substr(b.rent_l_cd,1,2)||b.reg_dt=h.min_value(+)"+
				" and c.car_ext = i.nm_cd"+
				" order by a.lend_dt, c.car_doc_no";
    
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next()){				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AddDebtDatabase:getBankLendList]"+ e);
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
	 *	금융사별 대출리스트 조회
	 */
	public Vector getBankLendList2(String cpt_cd, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select "+
				" d.firm_nm, f.car_nm, e.car_name, c.car_no, c.car_num, a.lend_dt, a.lend_prn,"+
				//" decode(c.car_ext,'1','서울','2','파주','3','부산','4','김해','5','대전','6','포천','7','인천','8','제주','9','광주','10','대구') car_ext, c.car_doc_no, a.lend_no "+
				" i.nm car_ext, c.car_doc_no, a.lend_no "+
				" from allot a, cont b, car_reg c, client d, car_etc g, car_nm e, car_mng f,"+
				" (select car_mng_id, min(rent_dt||substr(rent_l_cd,1,2)||reg_dt) min_value from cont where car_st<>'4' group by car_mng_id) h,"+
				"  (select * from code where c_st='0032') i "+
				" where"+
				" a.cpt_cd='"+cpt_cd+"'"+
				" and a.lend_dt between replace('"+st_dt+"', '-', '') and replace('"+end_dt+"', '-', '')"+
				" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				" and b.car_mng_id=c.car_mng_id"+
				" and b.client_id=d.client_id"+
				" and a.rent_mng_id=g.rent_mng_id and a.rent_l_cd=g.rent_l_cd"+
				" and g.car_id=e.car_id and g.car_seq=e.car_seq and e.car_comp_id=f.car_comp_id and e.car_cd=f.code"+
				" and b.car_mng_id=h.car_mng_id and b.rent_dt||substr(b.rent_l_cd,1,2)||b.reg_dt=h.min_value"+
				" and c.car_ext = i.nm_cd"+
				" order by a.lend_dt, a.lend_no";
    
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next()){				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddDebtDatabase:getBankLendList2]"+ e);
			System.out.println("[AddDebtDatabase:getBankLendList2]"+ query);
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
	 *	근저당설정현황
	 */
	public Vector getCltrRegStatList(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query = " select nvl(a.cltr_st,'N') cltr_st, a.cltr_user, a.cltr_amt, a.cltr_f_amt, a.cltr_set_dt, a.cltr_exp_dt, a.cltr_docs_dt, a.cltr_exp_cau, a.cltr_per_loan, "+
						" b.use_yn, f.cpt_cd, a.rent_mng_id, a.rent_l_cd, b.car_mng_id, e.firm_nm, e.client_nm, c.car_no, c.car_nm, "+
						" f.lend_dt, f.lend_no, f.lend_prn"+
						" from cltr a, cont b, car_reg c, cls_cont d, client e, allot f"+
						" where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd "+
						" and b.car_mng_id=c.car_mng_id"+
						" and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+)"+
						" and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd"+
						" and b.client_id=e.client_id"+
//						" and a.cltr_st='Y'";
						" ";


		/*상세조회&&세부조회*/

		//기간-전체
		if(gubun2.equals("4") && gubun3.equals("1")){		query += " and f.lend_dt BETWEEN replace('"+st_dt+"','-','') AND replace('"+end_dt+"','-','')";
		//기간-등록
		}else if(gubun2.equals("4") && gubun3.equals("2")){	query += " and f.lend_dt BETWEEN replace('"+st_dt+"','-','') AND replace('"+end_dt+"','-','') and nvl(a.cltr_st,'N')='Y'";
		//기간-미등록
		}else if(gubun2.equals("4") && gubun3.equals("3")){	query += " and f.lend_dt BETWEEN replace('"+st_dt+"','-','') AND replace('"+end_dt+"','-','') and nvl(a.cltr_st,'N')='N'";
		//검색-등록
		}else if(gubun2.equals("5") && gubun3.equals("2")){	query += " and nvl(a.cltr_st,'N')='Y'";
		//검색-미등록
		}else if(gubun2.equals("5") && gubun3.equals("3")){	query += " and nvl(a.cltr_st,'N')='N'";
		}
	
		if(!gubun4.equals(""))		query += " and f.cpt_cd='"+gubun4+"'";
		

		/*검색조건*/
			
		if(!t_wd.equals("")){
			if(s_kd.equals("1"))		query += " and nvl(e.firm_nm, '') like '%"+t_wd+"%'\n";			
			else if(s_kd.equals("2"))	query += " and nvl(e.client_nm, '') like '%"+t_wd+"%'\n";
			else if(s_kd.equals("3"))	query += " and upper(b.rent_l_cd) like upper('%"+t_wd+"%')\n";
			else if(s_kd.equals("4"))	query += " and (nvl(c.car_no, '') like '%"+t_wd+"%' or nvl(c.first_car_no, '') like '%"+t_wd+"%')\n";
			else if(s_kd.equals("5"))	query += " and a.cltr_f_amt like '%"+t_wd+"%'\n";
			else if(s_kd.equals("6"))	query += " and substr(b.rent_l_cd,1,2) like upper('%"+t_wd+"%')\n";
			else if(s_kd.equals("9"))	query += " and nvl(c.car_nm, '') like '%"+t_wd+"%'\n";
			else if(s_kd.equals("10"))	query += " and nvl(c.car_no, '') like '%"+t_wd+"%' and b.use_yn='N'\n";
			else if(s_kd.equals("11"))	query += " and nvl(f.lend_no, '') like '%"+t_wd+"%'\n";
		}

		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		/*정렬조건*/

		if(sort_gubun.equals("0"))		query += " order by nvl(a.cltr_st,'N') desc, f.lend_dt "+sort+",  e.firm_nm";
		else if(sort_gubun.equals("1"))	query += " order by nvl(a.cltr_st,'N') desc, e.firm_nm "+sort+", f.lend_dt";
		else if(sort_gubun.equals("2"))	query += " order by nvl(a.cltr_st,'N') desc, f.cpt_cd "+sort+", e.firm_nm, f.lend_dt";
		else if(sort_gubun.equals("3"))	query += " order by nvl(a.cltr_st,'N') desc, a.cltr_f_amt "+sort+", e.firm_nm";
		else if(sort_gubun.equals("5"))	query += " order by nvl(a.cltr_st,'N') desc, c.car_no "+sort+",  e.firm_nm, f.lend_dt";

    
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next()){				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddDebtDatabase:getCltrRegStatList]"+ e);
			System.out.println("[AddDebtDatabase:getCltrRegStatList]"+ query);
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
	 *	유동성부채현황
	 */
	public Vector getDebtSettleList(String gubun1, String gubun2, String gubun3, String gubun4, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select  \n"+
				"        a.cpt_nm, a.cpt_cd, a.gubun, \n"+
				"        decode(a.lend_id,'',b.ven_code, d.ven_code) ven_code, \n"+
				"        decode(a.lend_id,'',b.lend_no, c.lend_no) lend_no, \n"+
				"        decode(a.lend_id,'',b.lend_int, c.lend_int) lend_int, \n"+
				"        a.lend_id, a.rtn_seq, a.car_mng_id, a.rent_l_cd, a.deposit_no||decode(a.gubun,'3','-기타비용') deposit_no, a.car_no, \n"+
				"        decode(a.amt14,0,'납부완료','상환중') st1, \n"+
				"        decode(a.lend_id,'','개별', '묶음') st2, \n"+
				"        decode(a.lend_id,'',b.lend_dt, c.cont_dt) lend_dt, \n"+
				"        decode(a.lend_id,'',e.end_dt, f.end_dt) end_dt, \n"+
				"        nvl(a.amt1,0) amt1, nvl(a.amt2,0) amt2, nvl(a.amt3,0) amt3, nvl(a.amt4,0) amt4, nvl(a.amt5,0) amt5, nvl(a.amt6,0) amt6, "+
				"        nvl(a.amt7,0) amt7, nvl(a.amt8,0) amt8, nvl(a.amt9,0) amt9, nvl(a.amt10,0) amt10, nvl(a.amt11,0) amt11, nvl(a.amt12,0) amt12, nvl(a.amt13,0) amt13, nvl(a.amt14,0) amt14 \n"+
				" from   ( \n"+
				"          select \n"+
				"               cpt_nm, cpt_cd, lend_id, rtn_seq, car_mng_id, rent_l_cd, deposit_no, car_no, gubun, \n"+
				"               sum(decode(substr(alt_est_dt,1,7),'"+gubun2+"-01',alt_prn)) amt1, \n"+
				"               sum(decode(substr(alt_est_dt,1,7),'"+gubun2+"-02',alt_prn)) amt2, \n"+
				"               sum(decode(substr(alt_est_dt,1,7),'"+gubun2+"-03',alt_prn)) amt3, \n"+
				"               sum(decode(substr(alt_est_dt,1,7),'"+gubun2+"-04',alt_prn)) amt4, \n"+
				"               sum(decode(substr(alt_est_dt,1,7),'"+gubun2+"-05',alt_prn)) amt5, \n"+
				"               sum(decode(substr(alt_est_dt,1,7),'"+gubun2+"-06',alt_prn)) amt6, \n"+
				"               sum(decode(substr(alt_est_dt,1,7),'"+gubun2+"-07',alt_prn)) amt7, \n"+
				"               sum(decode(substr(alt_est_dt,1,7),'"+gubun2+"-08',alt_prn)) amt8, \n"+
				"               sum(decode(substr(alt_est_dt,1,7),'"+gubun2+"-09',alt_prn)) amt9, \n"+
				"               sum(decode(substr(alt_est_dt,1,7),'"+gubun2+"-10',alt_prn)) amt10, \n"+
				"               sum(decode(substr(alt_est_dt,1,7),'"+gubun2+"-11',alt_prn)) amt11, \n"+
				"               sum(decode(substr(alt_est_dt,1,7),'"+gubun2+"-12',alt_prn)) amt12, \n"+
				"               sum(decode(substr(alt_est_dt,1,4),'"+gubun2+"',alt_prn)) amt13, \n"+
				"               min(decode(substr(alt_est_dt,1,4),'"+gubun2+"',alt_rest)) amt14 \n"+
				"          from debt_pay_view \n";

		if(gubun1.equals("2")){
			if(gubun3.equals(""))		query += " where alt_est_dt like '"+gubun2+"%' "; 
			if(!gubun3.equals(""))		query += " where alt_est_dt like '"+gubun2+"%' and substr(alt_est_dt,1,7) <= '"+gubun2+"-"+gubun3+"'";  
		}


		query += 		"          group by cpt_nm, cpt_cd, lend_id, rtn_seq, car_mng_id, rent_l_cd, deposit_no, car_no, gubun \n"+
				"        ) a, allot b, lend_bank c, bank_rtn d, \n"+
				"        (select car_mng_id, max(alt_est_dt) end_dt from scd_alt_case group by car_mng_id) e, \n"+
				"        (select lend_id, rtn_seq, max(alt_est_dt) end_dt from scd_bank group by lend_id, rtn_seq) f \n"+
				" where  a.amt13+a.amt14>0 \n"+
				"        and a.car_mng_id=b.car_mng_id(+) and a.rent_l_cd=b.rent_l_cd(+) \n"+
				"        and a.lend_id=c.lend_id(+) \n"+
				"        and a.lend_id=d.lend_id(+) and a.rtn_seq=d.seq(+) \n"+
				"        and a.car_mng_id=e.car_mng_id(+) \n"+
				"        and a.lend_id=f.lend_id(+) and a.rtn_seq=f.rtn_seq(+) \n"+
				"        and substr(decode(a.lend_id,'',b.lend_dt, c.cont_dt),1,4) <= '"+gubun2+"' "+
				" ";

		if(gubun1.equals("1")){
			if(gubun3.equals(""))		query += " and decode(a.lend_id,'',b.lend_dt, c.cont_dt)='"+gubun2+"'";
			if(!gubun3.equals(""))		query += " and decode(a.lend_id,'',b.lend_dt, c.cont_dt)='"+gubun2+""+gubun3+"'";
		}

		if(!gubun4.equals(""))			query += " and a.cpt_cd='"+gubun4+"'";

		if(!t_wd.equals("")){
			if(s_kd.equals("1"))		query += " and a.deposit_no like '%"+t_wd+"%'";
			if(s_kd.equals("2"))		query += " and a.car_no like '%"+t_wd+"%'";
			if(s_kd.equals("3"))		query += " and nvl(decode(a.lend_id,'',b.lend_no, c.lend_no),a.lend_id||a.rent_l_cd) like '%"+t_wd+"%'";
			if(s_kd.equals("4"))		query += " and decode(a.lend_id,'',b.ven_code, d.ven_code) like '%"+t_wd+"%'";
		}

		if(sort_gubun.equals("5")){
			query += " order by decode(a.lend_id,'',b.ven_code, d.ven_code)";
		}else if(sort_gubun.equals("6")){
			query += " order by decode(a.lend_id,'',b.lend_no, c.lend_no)";
		}else{

			query += " order by decode(a.lend_id,'','2', '1')";

			if(sort_gubun.equals("1"))		query += ", a.cpt_nm, decode(a.lend_id,'',b.lend_dt, c.cont_dt)";
			if(sort_gubun.equals("2"))		query += ", a.deposit_no";
			if(sort_gubun.equals("3"))		query += ", a.car_no";
			if(sort_gubun.equals("4"))		query += ", decode(a.lend_id,'',b.lend_dt, c.cont_dt), decode(a.lend_id,'',b.lend_no, c.lend_no)";

		}

		if(!sort_gubun.equals("") && asc.equals("1"))	query += " desc";
    

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next()){				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddDebtDatabase:getDebtSettleList]"+ e);
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
	
	
	//월별 유동성 부채 대체 건 
	public Vector getDebtSettleList1(String gubun1, String gubun2, String gubun3, String gubun4, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
        String s_gubun2 = "";
        
        int m_gubun2= Integer.parseInt(gubun2) -1 ;
        s_gubun2= AddUtil.toString(m_gubun2);
		
		query = " select  \n"+
				"        a.cpt_nm, a.cpt_cd, a.gubun, \n"+
				"        decode(a.lend_id,'',b.ven_code, d.ven_code) ven_code, \n"+
				"        decode(a.lend_id,'',b.lend_no, c.lend_no) lend_no, \n"+
				"        decode(a.lend_id,'',b.lend_int, c.lend_int) lend_int, \n"+
				"        a.lend_id, a.rtn_seq, a.car_mng_id, a.rent_l_cd, a.deposit_no||decode(a.gubun,'3','-기타비용') deposit_no, a.car_no, \n"+
				"        decode(a.amt14,0,'납부완료','상환중') st1, \n"+
				"        decode(a.lend_id,'','개별', '묶음') st2, \n"+
				"        decode(a.lend_id,'',b.lend_dt, c.cont_dt) lend_dt, \n"+
				"        decode(a.lend_id,'',e.end_dt, f.end_dt) end_dt, \n"+
				"        nvl(a.amt1,0) amt1, nvl(a.amt2,0) amt2, nvl(a.amt3,0) amt3, nvl(a.amt4,0) amt4, nvl(a.amt5,0) amt5, nvl(a.amt6,0) amt6, "+
				"        nvl(a.amt7,0) amt7, nvl(a.amt8,0) amt8, nvl(a.amt9,0) amt9, nvl(a.amt10,0) amt10, nvl(a.amt11,0) amt11, nvl(a.amt12,0) amt12, nvl(a.amt13,0) amt13, nvl(a.amt14,0) amt14 , nvl(a.amt15,0) amt15 \n"+
				" from   ( \n"+
				"          select \n"+
				"               cpt_nm, cpt_cd, lend_id, rtn_seq, car_mng_id, rent_l_cd, deposit_no, car_no, gubun, \n"+
				"               nvl(sum(decode(substr(alt_est_dt,1,7),'"+gubun2+"-01',alt_prn)), 0) amt1, \n"+
				"               nvl(sum(decode(substr(alt_est_dt,1,7),'"+gubun2+"-02',alt_prn)), 0) amt2, \n"+
				"               nvl(sum(decode(substr(alt_est_dt,1,7),'"+gubun2+"-03',alt_prn)), 0) amt3, \n"+
				"               nvl(sum(decode(substr(alt_est_dt,1,7),'"+gubun2+"-04',alt_prn)), 0) amt4, \n"+
				"               nvl(sum(decode(substr(alt_est_dt,1,7),'"+gubun2+"-05',alt_prn)), 0) amt5, \n"+
				"               nvl(sum(decode(substr(alt_est_dt,1,7),'"+gubun2+"-06',alt_prn)), 0) amt6, \n"+
				"               nvl(sum(decode(substr(alt_est_dt,1,7),'"+gubun2+"-07',alt_prn)), 0) amt7, \n"+
				"               nvl(sum(decode(substr(alt_est_dt,1,7),'"+gubun2+"-08',alt_prn)), 0) amt8, \n"+
				"               nvl(sum(decode(substr(alt_est_dt,1,7),'"+gubun2+"-09',alt_prn)), 0) amt9, \n"+
				"               nvl(sum(decode(substr(alt_est_dt,1,7),'"+gubun2+"-10',alt_prn)), 0) amt10, \n"+
				"               nvl(sum(decode(substr(alt_est_dt,1,7),'"+gubun2+"-11',alt_prn)), 0) amt11, \n"+
				"               nvl(sum(decode(substr(alt_est_dt,1,7),'"+gubun2+"-12',alt_prn)), 0) amt12, \n"+
				"               nvl(sum(decode(substr(alt_est_dt,1,4),'"+gubun2+"',alt_prn)),  0)   amt13, \n"+
				"               nvl(min(decode(substr(alt_est_dt,1,4),'"+gubun2+"',alt_rest)), 0)   amt14, \n"+
				"               nvl(sum(decode(substr(alt_est_dt,1,4),'"+s_gubun2+"',alt_prn)),0)   amt15 \n"+
				"          from debt_pay_view \n";

		if(gubun1.equals("2")){
			if(gubun3.equals(""))		query += " where alt_est_dt like '"+gubun2+"%' "; 
			if(!gubun3.equals(""))		query += " where ( alt_est_dt like '"+gubun2+"%' or substr(alt_est_dt,1,7) > '"+s_gubun2+"-"+gubun3+"') and substr(alt_est_dt,1,7) <= '"+gubun2+"-"+gubun3+"'";  
		}


		query += 		"          group by cpt_nm, cpt_cd, lend_id, rtn_seq, car_mng_id, rent_l_cd, deposit_no, car_no, gubun \n"+
				"        ) a, allot b, lend_bank c, bank_rtn d, \n"+
				"        (select car_mng_id, max(alt_est_dt) end_dt from scd_alt_case group by car_mng_id) e, \n"+
				"        (select lend_id, rtn_seq, max(alt_est_dt) end_dt from scd_bank group by lend_id, rtn_seq) f \n"+
				" where  a.amt13+a.amt14+a.amt15>0 \n"+
				"        and a.car_mng_id=b.car_mng_id(+) and a.rent_l_cd=b.rent_l_cd(+) \n"+
				"        and a.lend_id=c.lend_id(+) \n"+
				"        and a.lend_id=d.lend_id(+) and a.rtn_seq=d.seq(+) \n"+
				"        and a.car_mng_id=e.car_mng_id(+) \n"+
				"        and a.lend_id=f.lend_id(+) and a.rtn_seq=f.rtn_seq(+) \n"+
				"        and a.amt14 = 0 \n"+
				"        and substr(decode(a.lend_id,'',b.lend_dt, c.cont_dt),1,4) <= '"+gubun2+"' "+
				" ";

		if(gubun1.equals("1")){
			if(gubun3.equals(""))		query += " and decode(a.lend_id,'',b.lend_dt, c.cont_dt)='"+gubun2+"'";
			if(!gubun3.equals(""))		query += " and decode(a.lend_id,'',b.lend_dt, c.cont_dt)='"+gubun2+""+gubun3+"'";
		}

		if(!gubun4.equals(""))			query += " and a.cpt_cd='"+gubun4+"'";

		if(!t_wd.equals("")){
			if(s_kd.equals("1"))		query += " and a.deposit_no like '%"+t_wd+"%'";
			if(s_kd.equals("2"))		query += " and a.car_no like '%"+t_wd+"%'";
			if(s_kd.equals("3"))		query += " and nvl(decode(a.lend_id,'',b.lend_no, c.lend_no),a.lend_id||a.rent_l_cd) like '%"+t_wd+"%'";
			if(s_kd.equals("4"))		query += " and decode(a.lend_id,'',b.ven_code, d.ven_code) like '%"+t_wd+"%'";
		}

		if(sort_gubun.equals("5")){
			query += " order by decode(a.lend_id,'',b.ven_code, d.ven_code)";
		}else if(sort_gubun.equals("6")){
			query += " order by decode(a.lend_id,'',b.lend_no, c.lend_no)";
		}else{

			query += " order by decode(a.lend_id,'','2', '1')";

			if(sort_gubun.equals("1"))		query += ", a.cpt_nm, decode(a.lend_id,'',b.lend_dt, c.cont_dt)";
			if(sort_gubun.equals("2"))		query += ", a.deposit_no";
			if(sort_gubun.equals("3"))		query += ", a.car_no";
			if(sort_gubun.equals("4"))		query += ", decode(a.lend_id,'',b.lend_dt, c.cont_dt), decode(a.lend_id,'',b.lend_no, c.lend_no)";

		}

		if(!sort_gubun.equals("") && asc.equals("1"))	query += " desc";
		
	//	System.out.println("[AddDebtDatabase:getDebtSettleList1]"+ query);

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next()){				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddDebtDatabase:getDebtSettleList1]"+ e);
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
	
	//월별 유동성 부채 대체 건 - 년도 기준 월별 
	public Vector getDebtSettleList1(String gubun1, String gubun2)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Vector vt = new Vector();
			String query = "";
	        String s_gubun1 = "";
	        
	        int m_gubun1= Integer.parseInt(gubun1) + 1 ;
	        s_gubun1= AddUtil.toString(m_gubun1);
			
	    	query = " select  \n"+
	    			"        sum(nvl(a.amt13,0)) amt13, sum(nvl(a.amt14,0)) amt14 , sum(nvl(a.amt15,0)) amt15 \n"+
					" from   ( \n"+
					"          select \n"+
					"               cpt_nm, cpt_cd, lend_id, rtn_seq, car_mng_id, rent_l_cd, deposit_no, car_no, gubun, \n"+				
					"               nvl(sum(decode(substr(alt_est_dt,1,4),'"+s_gubun1+"',alt_prn)),  0)   amt13, \n"+
					"               nvl(min(decode(substr(alt_est_dt,1,4),'"+s_gubun1+"',alt_rest)), 0)   amt14, \n"+
					"               nvl(sum(decode(substr(alt_est_dt,1,4),'"+gubun1+"',alt_prn)),0)   amt15 \n"+
					"          from debt_pay_view \n";
			
			query += " where  substr(alt_est_dt,1,7) > '"+gubun1+"-"+gubun2+"' and substr(alt_est_dt,1,7) <= '"+s_gubun1+"-"+gubun2+"'";//and cls_rtn_dt is null  
			
			query += 		"          group by cpt_nm, cpt_cd, lend_id, rtn_seq, car_mng_id, rent_l_cd, deposit_no, car_no, gubun \n"+
					"        ) a, allot b, lend_bank c, bank_rtn d, \n"+
					"        (select car_mng_id, max(alt_est_dt) end_dt from scd_alt_case group by car_mng_id) e, \n"+
					"        (select lend_id, rtn_seq, max(alt_est_dt) end_dt from scd_bank group by lend_id, rtn_seq) f \n"+
					" where  a.amt13+a.amt14+a.amt15>0 \n"+
					"        and a.car_mng_id=b.car_mng_id(+) and a.rent_l_cd=b.rent_l_cd(+) \n"+
					"        and a.lend_id=c.lend_id(+) \n"+
					"        and a.lend_id=d.lend_id(+) and a.rtn_seq=d.seq(+) \n"+
					"        and a.car_mng_id=e.car_mng_id(+) \n"+
					"        and a.lend_id=f.lend_id(+) and a.rtn_seq=f.rtn_seq(+) \n"+
			  //      "        and a.amt14 = 0 \n"+
					"        and substr(decode(a.lend_id,'',b.lend_dt, c.cont_dt),1,6) <= '"+gubun1+""+gubun2+"' "+
					" ";
		
		//	System.out.println("[AddDebtDatabase:getDebtSettleList1]"+ query);

			try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();    	
				while(rs.next()){				
					Hashtable ht = new Hashtable();
					for(int pos =1; pos <= rsmd.getColumnCount();pos++){
						 String columnName = rsmd.getColumnName(pos);
						 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
					}
					vt.add(ht);	
				}
				rs.close();
				pstmt.close();
			} catch (SQLException e) {
				System.out.println("[AddDebtDatabase:getDebtSettleList1]"+ e);
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
	
	
	//월별 유동성 부채 대체 건 - 년도 기준 월별 
		public Vector getDebtSettleList1Detaiil(String gubun1, String gubun2)
			{
				getConnection();
				PreparedStatement pstmt = null;
				ResultSet rs = null;
				Vector vt = new Vector();
				String query = "";
		        String s_gubun1 = "";
		        
		        int m_gubun1= Integer.parseInt(gubun1) + 1 ;
		        s_gubun1= AddUtil.toString(m_gubun1);
				
		    	query = " select  \n"+		     
		    		    "  a.* , \n"+	
		    		    " decode(a.lend_id,'',b.lend_int, c.lend_int) lend_int, \n"+	
		    		    " decode(a.lend_id,'',b.lend_no, c.lend_no) lend_no ,\n"+	
		    		    " decode(a.lend_id,'',b.lend_dt, c.cont_dt) lend_dt, \n"+	
		    			" decode(a.lend_id,'',e.end_dt, f.end_dt) end_dt\n"+	
						" from   ( \n"+
						"          select \n"+
						"               cpt_nm, cpt_cd, lend_id, rtn_seq, car_mng_id, rent_l_cd, deposit_no, car_no, gubun, \n"+				
						"               nvl(sum(decode(substr(alt_est_dt,1,4),'"+s_gubun1+"',alt_prn)),  0)   amt13, \n"+
						"               nvl(min(decode(substr(alt_est_dt,1,4),'"+s_gubun1+"',alt_rest)), 0)   amt14, \n"+
						"               nvl(sum(decode(substr(alt_est_dt,1,4),'"+gubun1+"',alt_prn)),0)   amt15 \n"+
						"          from debt_pay_view \n";
				
				query += " where  substr(alt_est_dt,1,7) > '"+gubun1+"-"+gubun2+"' and substr(alt_est_dt,1,7) <= '"+s_gubun1+"-"+gubun2+"'";//and cls_rtn_dt is null  
				
				query += 		"          group by cpt_nm, cpt_cd, lend_id, rtn_seq, car_mng_id, rent_l_cd, deposit_no, car_no, gubun \n"+
						"        ) a, allot b, lend_bank c, bank_rtn d, \n"+
						"        (select car_mng_id, max(alt_est_dt) end_dt from scd_alt_case group by car_mng_id) e, \n"+
						"        (select lend_id, rtn_seq, max(alt_est_dt) end_dt from scd_bank group by lend_id, rtn_seq) f \n"+
						" where  a.amt13+a.amt14+a.amt15>0 \n"+
						"        and a.car_mng_id=b.car_mng_id(+) and a.rent_l_cd=b.rent_l_cd(+) \n"+
						"        and a.lend_id=c.lend_id(+) \n"+
						"        and a.lend_id=d.lend_id(+) and a.rtn_seq=d.seq(+) \n"+
						"        and a.car_mng_id=e.car_mng_id(+) \n"+
						"        and a.lend_id=f.lend_id(+) and a.rtn_seq=f.rtn_seq(+) \n"+
				  //      "        and a.amt14 = 0 \n"+
						"        and substr(decode(a.lend_id,'',b.lend_dt, c.cont_dt),1,6) <= '"+gubun1+""+gubun2+"' "+
						" ";
			
			//	System.out.println("[AddDebtDatabase:getDebtSettleList1Detaiil]"+ query);

				try {
					pstmt = conn.prepareStatement(query);
			    	rs = pstmt.executeQuery();
		    		ResultSetMetaData rsmd = rs.getMetaData();    	
					while(rs.next()){				
						Hashtable ht = new Hashtable();
						for(int pos =1; pos <= rsmd.getColumnCount();pos++){
							 String columnName = rsmd.getColumnName(pos);
							 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
						}
						vt.add(ht);	
					}
					rs.close();
					pstmt.close();
				} catch (SQLException e) {
					System.out.println("[AddDebtDatabase:getDebtSettleList1Detaiil]"+ e);
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
		
		
		
	
	//유동성 장기대여 보증금 년도/월 
	public Vector getSettleAccount_list14(String gubun1, String gubun2) 
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String s_gubun1 = "";
	        
	    int m_gubun1= Integer.parseInt(gubun1) + 1 ;
	    s_gubun1= AddUtil.toString(m_gubun1);
		
		query = " select sum( b.grt_amt) grt_amt ,  sum(b.r_grt_amt) r_grt_amt \r\n" +
				" from ( \r\n" +
				" SELECT   \r\n" + 
				"		   case when b.rent_end_dt < h.rent_end_dt then h.rent_end_dt ELSE b.rent_end_dt END rent_end_dt , \r\n" +
		        "           b.grt_amt_s grt_amt , b.grt_amt_s-( b.grt_amt_s-e.pay_amt)  r_grt_amt  \r\n" +  
				"		 FROM   CONT a, CLS_CONT f, FEE b,  \r\n" +
				"		        ( SELECT rent_mng_id, rent_l_cd, MAX(to_number(rent_st)) rent_st  FROM   FEE  GROUP BY rent_mng_id, rent_l_cd   ) c,  CLIENT d, \r\n" +
				"		 		( select rent_mng_id, rent_l_cd, sum(ext_pay_amt) pay_amt, MIN(ext_pay_dt) pay_dt  \r\n" +
				"		 		   from   scd_ext    where  ext_st='0' and ext_pay_amt>0 AND ext_pay_dt < '"+gubun1+""+gubun2+"01' group by rent_mng_id, rent_l_cd  ) e, CAR_REG g , \r\n" +
				" 		        (SELECT rent_mng_id, rent_l_cd, MAX(rent_end_dt) rent_end_dt FROM FEE_IM GROUP BY rent_mng_id, rent_l_cd) h  \r\n" +
				"		 WHERE  a.car_st in ('1','3','4') AND a.rent_l_cd NOT LIKE 'RM%'  \r\n" +
				"		        AND a.rent_mng_id=f.rent_mng_id(+) AND a.rent_l_cd=f.rent_l_cd(+)  \r\n" +
				"		        AND (NVL(a.use_yn,'Y')='Y' OR f.cls_dt >= '"+gubun1+""+gubun2+"01')  \r\n" +                
		        "                AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd \r\n" +
				"		 		AND b.rent_mng_id=c.rent_mng_id AND b.rent_l_cd=c.rent_l_cd AND b.rent_st=c.rent_st \r\n" +
				"		 		AND b.grt_amt_s> 0 	 AND a.client_id=d.client_id  \r\n" +
				"		 		and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd \r\n" +
				"		        AND a.car_mng_id=g.car_mng_id(+)  \r\n" +
				"		        AND a.rent_mng_id=h.rent_mng_id(+) AND a.rent_l_cd=h.rent_l_cd(+) \r\n" +
		       	"         ) b \r\n" +
		        " where   (  b.rent_end_dt like  '%"+s_gubun1+"%' or substr(b.rent_end_dt,1,6) > '"+gubun1+""+gubun2+"') and substr(b.rent_end_dt,1,6) <= '"+s_gubun1+""+gubun2+"'";
		
	//	System.out.println("[AddDebtDatabase:getSettleAccount_list14]"+ query);

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSettleAccount_list14]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}


	/**
	 *	유동성부채현황
	 */
	public Vector getDebtSettleEstList(String gubun1, String gubun2, String gubun3, String gubun4, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select  \n"+
				"        a.cpt_nm, a.cpt_cd, \n"+
				"        decode(a.lend_id,'',b.ven_code, d.ven_code) ven_code, \n"+
				"        decode(a.lend_id,'',b.lend_no, c.lend_no) lend_no, \n"+
				"        decode(a.lend_id,'',b.lend_int, c.lend_int) lend_int, \n"+
				"        a.lend_id, a.rtn_seq, a.car_mng_id, a.rent_l_cd, a.deposit_no||decode(a.gubun,'3','-기타비용') deposit_no, a.car_no, \n"+
				"        decode(a.lend_id,'','개별', '묶음') st2, \n"+
				"        decode(a.lend_id,'',b.lend_dt, c.cont_dt) lend_dt, \n"+
				"        decode(a.lend_id,'',e.end_dt, f.end_dt) end_dt, \n"+
				"        a.amt1, a.amt2, a.amt3, a.amt4, a.amt5, a.amt6, a.amt7, a.amt8, a.amt9, a.amt10, a.amt11, a.amt12, a.amt13 \n"+
				" from   ( \n"+
				"          select \n"+
				"               cpt_nm, cpt_cd, lend_id, rtn_seq, car_mng_id, rent_l_cd, deposit_no, car_no, gubun, \n"+
				"               sum(decode(substr(alt_est_dt,1,4),to_char("+gubun2+"+1),alt_prn)) amt1, \n"+
				"               sum(decode(substr(alt_est_dt,1,4),to_char("+gubun2+"+2),alt_prn)) amt2, \n"+
				"               sum(decode(substr(alt_est_dt,1,4),to_char("+gubun2+"+3),alt_prn)) amt3, \n"+
				"               sum(decode(substr(alt_est_dt,1,4),to_char("+gubun2+"+4),alt_prn)) amt4, \n"+
				"               sum(decode(substr(alt_est_dt,1,4),to_char("+gubun2+"+5),alt_prn)) amt5, \n"+
				"               sum(decode(substr(alt_est_dt,1,4),to_char("+gubun2+"+6),alt_prn)) amt6, \n"+
				"               sum(decode(substr(alt_est_dt,1,4),to_char("+gubun2+"+7),alt_prn)) amt7, \n"+
				"               sum(decode(substr(alt_est_dt,1,4),to_char("+gubun2+"+8),alt_prn)) amt8, \n"+
				"               sum(decode(substr(alt_est_dt,1,4),to_char("+gubun2+"+9),alt_prn)) amt9, \n"+
				"               sum(decode(substr(alt_est_dt,1,4),to_char("+gubun2+"+10),alt_prn)) amt10, \n"+
				"               sum(decode(substr(alt_est_dt,1,4),to_char("+gubun2+"+11),alt_prn)) amt11, \n"+
				"               sum(decode(substr(alt_est_dt,1,4),to_char("+gubun2+"+12),alt_prn)) amt12, \n"+
				"               sum(alt_prn) amt13 \n"+
				"          from debt_pay_view \n"+
				"          where alt_est_dt > '"+gubun2+"-12-31' \n"+
				"          group by cpt_nm, cpt_cd, lend_id, rtn_seq, car_mng_id, rent_l_cd, deposit_no, car_no, gubun \n"+
				"        ) a, allot b, lend_bank c, bank_rtn d, \n"+
				"        (select car_mng_id, max(alt_est_dt) end_dt from scd_alt_case group by car_mng_id) e, \n"+
				"        (select lend_id, rtn_seq, max(alt_est_dt) end_dt from scd_bank group by lend_id, rtn_seq) f \n"+
				" where  a.amt13>0 \n"+
				"        and a.car_mng_id=b.car_mng_id(+) and a.rent_l_cd=b.rent_l_cd(+) \n"+
				"        and a.lend_id=c.lend_id(+) \n"+
				"        and a.lend_id=d.lend_id(+) and a.rtn_seq=d.seq(+) \n"+
				"        and a.car_mng_id=e.car_mng_id(+) \n"+
				"        and a.lend_id=f.lend_id(+) and a.rtn_seq=f.rtn_seq(+) \n"+
				"        and substr(decode(a.lend_id,'',b.lend_dt, c.cont_dt),1,4) <= '"+gubun2+"' "+
				" ";

		if(gubun1.equals("1")){
			if(gubun3.equals(""))		query += " and decode(a.lend_id,'',b.lend_dt, c.cont_dt)='"+gubun2+"'";
			if(!gubun3.equals(""))		query += " and decode(a.lend_id,'',b.lend_dt, c.cont_dt)='"+gubun2+""+gubun3+"'";
		}

		if(!gubun4.equals(""))			query += " and a.cpt_cd='"+gubun4+"'";

		if(!t_wd.equals("")){
			if(s_kd.equals("1"))		query += " and a.deposit_no like '%"+t_wd+"%'";
			if(s_kd.equals("2"))		query += " and a.car_no like '%"+t_wd+"%'";
			if(s_kd.equals("3"))		query += " and decode(a.lend_id,'',b.lend_no, c.lend_no) like '%"+t_wd+"%'";
		}

		if(sort_gubun.equals("5")){
			query += " order by decode(a.lend_id,'',b.ven_code, d.ven_code)";
		}else if(sort_gubun.equals("6")){
			query += " order by decode(a.lend_id,'',b.lend_no, c.lend_no)";
		}else{

			query += " order by decode(a.lend_id,'','2', '1')";

			if(sort_gubun.equals("1"))		query += ", a.cpt_nm, decode(a.lend_id,'',b.lend_dt, c.cont_dt)";
			if(sort_gubun.equals("2"))		query += ", a.deposit_no";
			if(sort_gubun.equals("3"))		query += ", a.car_no";
			if(sort_gubun.equals("4"))		query += ", decode(a.lend_id,'',b.lend_dt, c.cont_dt)";

		}

		if(!sort_gubun.equals("") && asc.equals("1"))	query += " desc";
    
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next()){				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddDebtDatabase:getDebtSettleEstList]"+ e);
			System.out.println("[AddDebtDatabase:getDebtSettleEstList]"+ query);
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
	 *	유동성부채현황
	 */
	public Vector getDebtSettleEstIntList(String gubun1, String gubun2, String gubun3, String gubun4, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select  \n"+
				"        a.cpt_nm, a.cpt_cd, \n"+
				"        decode(a.lend_id,'',b.ven_code, d.ven_code) ven_code, \n"+
				"        decode(a.lend_id,'',b.lend_no, c.lend_no) lend_no, \n"+
				"        decode(a.lend_id,'',b.lend_int, c.lend_int) lend_int, \n"+
				"        a.lend_id, a.rtn_seq, a.car_mng_id, a.rent_l_cd, a.deposit_no||decode(a.gubun,'3','-기타비용') deposit_no, a.car_no, \n"+
				"        decode(a.lend_id,'','개별', '묶음') st2, \n"+
				"        decode(a.lend_id,'',b.lend_dt, c.cont_dt) lend_dt, \n"+
				"        decode(a.lend_id,'',e.end_dt, f.end_dt) end_dt, \n"+
				"        a.amt1, a.amt2, a.amt3, a.amt4, a.amt5, a.amt6, a.amt7, a.amt8, a.amt9, a.amt10, a.amt11, a.amt12, a.amt13 \n"+
				" from   ( \n"+
				"          select \n"+
				"               cpt_nm, cpt_cd, lend_id, rtn_seq, car_mng_id, rent_l_cd, deposit_no, car_no, gubun, \n"+
				"               sum(decode(substr(alt_est_dt,1,4),to_char("+gubun2+"+1),alt_prn+alt_int)) amt1, \n"+
				"               sum(decode(substr(alt_est_dt,1,4),to_char("+gubun2+"+2),alt_prn+alt_int)) amt2, \n"+
				"               sum(decode(substr(alt_est_dt,1,4),to_char("+gubun2+"+3),alt_prn+alt_int)) amt3, \n"+
				"               sum(decode(substr(alt_est_dt,1,4),to_char("+gubun2+"+4),alt_prn+alt_int)) amt4, \n"+
				"               sum(decode(substr(alt_est_dt,1,4),to_char("+gubun2+"+5),alt_prn+alt_int)) amt5, \n"+
				"               sum(decode(substr(alt_est_dt,1,4),to_char("+gubun2+"+6),alt_prn+alt_int)) amt6, \n"+
				"               sum(decode(substr(alt_est_dt,1,4),to_char("+gubun2+"+7),alt_prn+alt_int)) amt7, \n"+
				"               sum(decode(substr(alt_est_dt,1,4),to_char("+gubun2+"+8),alt_prn+alt_int)) amt8, \n"+
				"               sum(decode(substr(alt_est_dt,1,4),to_char("+gubun2+"+9),alt_prn+alt_int)) amt9, \n"+
				"               sum(decode(substr(alt_est_dt,1,4),to_char("+gubun2+"+10),alt_prn+alt_int)) amt10, \n"+
				"               sum(decode(substr(alt_est_dt,1,4),to_char("+gubun2+"+11),alt_prn+alt_int)) amt11, \n"+
				"               sum(decode(substr(alt_est_dt,1,4),to_char("+gubun2+"+12),alt_prn+alt_int)) amt12, \n"+
				"               sum(alt_prn+alt_int) amt13 \n"+
				"          from debt_pay_view \n"+
				"          where alt_est_dt > '"+gubun2+"-12-31' \n"+
				"          group by cpt_nm, cpt_cd, lend_id, rtn_seq, car_mng_id, rent_l_cd, deposit_no, car_no, gubun \n"+
				"        ) a, allot b, lend_bank c, bank_rtn d, \n"+
				"        (select car_mng_id, max(alt_est_dt) end_dt from scd_alt_case group by car_mng_id) e, \n"+
				"        (select lend_id, rtn_seq, max(alt_est_dt) end_dt from scd_bank group by lend_id, rtn_seq) f \n"+
				" where  a.amt13>0 \n"+
				"        and a.car_mng_id=b.car_mng_id(+) and a.rent_l_cd=b.rent_l_cd(+) \n"+
				"        and a.lend_id=c.lend_id(+) \n"+
				"        and a.lend_id=d.lend_id(+) and a.rtn_seq=d.seq(+) \n"+
				"        and a.car_mng_id=e.car_mng_id(+) \n"+
				"        and a.lend_id=f.lend_id(+) and a.rtn_seq=f.rtn_seq(+) \n"+
				"        and substr(decode(a.lend_id,'',b.lend_dt, c.cont_dt),1,4) <= '"+gubun2+"' "+
				" ";

		if(gubun1.equals("1")){
			if(gubun3.equals(""))		query += " and decode(a.lend_id,'',b.lend_dt, c.cont_dt)='"+gubun2+"'";
			if(!gubun3.equals(""))		query += " and decode(a.lend_id,'',b.lend_dt, c.cont_dt)='"+gubun2+""+gubun3+"'";
		}

		if(!gubun4.equals(""))			query += " and a.cpt_cd='"+gubun4+"'";

		if(!t_wd.equals("")){
			if(s_kd.equals("1"))		query += " and a.deposit_no like '%"+t_wd+"%'";
			if(s_kd.equals("2"))		query += " and a.car_no like '%"+t_wd+"%'";
			if(s_kd.equals("3"))		query += " and decode(a.lend_id,'',b.lend_no, c.lend_no) like '%"+t_wd+"%'";
		}

		if(sort_gubun.equals("5")){
			query += " order by decode(a.lend_id,'',b.ven_code, d.ven_code)";
		}else if(sort_gubun.equals("6")){
			query += " order by decode(a.lend_id,'',b.lend_no, c.lend_no)";
		}else{

			query += " order by decode(a.lend_id,'','2', '1')";

			if(sort_gubun.equals("1"))		query += ", a.cpt_nm, decode(a.lend_id,'',b.lend_dt, c.cont_dt)";
			if(sort_gubun.equals("2"))		query += ", a.deposit_no";
			if(sort_gubun.equals("3"))		query += ", a.car_no";
			if(sort_gubun.equals("4"))		query += ", decode(a.lend_id,'',b.lend_dt, c.cont_dt)";

		}

		if(!sort_gubun.equals("") && asc.equals("1"))	query += " desc";
    
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next()){				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddDebtDatabase:getDebtSettleEstIntList]"+ e);
			System.out.println("[AddDebtDatabase:getDebtSettleEstIntList]"+ query);
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
	 *	지출현황 - 할부금 납부처리를 위한 리스트
	 */
	public Hashtable getDebtPayViewCase(String car_mng_id, String lend_id, String rtn_seq, String alt_tm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select * from debt_pay_view where alt_tm='"+alt_tm+"'";

		if(!car_mng_id.equals(""))	query += " and car_mng_id='"+car_mng_id+"'";

		if(!lend_id.equals(""))		query += " and lend_id='"+lend_id+"' and rtn_seq='"+rtn_seq+"'";


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next()){				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddDebtDatabase:getDebtPayViewCase]"+ e);
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
	 *	할부금중도상환현황
	 */
	public Vector getDebtClsList(String gubun1, String gubun2, String gubun3, String gubun4, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select  \n"+
				"        decode(a.lend_id,'',b.ven_code, d.ven_code) ven_code, \n"+
				"        decode(a.lend_id,'',b.lend_no, c.lend_no) lend_no, \n"+
				"        decode(a.lend_id,'','개별', '묶음') st2, \n"+
				"        decode(a.lend_id,'',b.lend_dt, c.cont_dt) lend_dt, \n"+
				"        decode(a.lend_id,'',e.end_dt, f.end_dt) end_dt, \n"+
				"        a.gubun, a.cpt_nm, a.cpt_cd, a.lend_id, a.rtn_seq, a.car_mng_id, a.rent_mng_id, a.rent_l_cd, a.deposit_no, a.car_no, \n"+
				"        a.alt_tm, a.alt_prn, a.alt_int, a.alt_amt, a.alt_rest, a.pay_dt1, a.cls_rtn_dt, \n"+
				"        a.nalt_rest, a.nalt_rest_1, a.nalt_rest_2, a.cls_etc_fee,  \n"+
				"        a.cls_rtn_fee, a.cls_rtn_int_amt, a.dly_alt, a.be_alt, a.cls_rtn_amt \n"+
				" from   ( \n"+
				"          select \n"+
				"                 a.gubun, a.cpt_nm, a.cpt_cd, a.lend_id, a.rtn_seq, a.car_mng_id, a.rent_mng_id, a.rent_l_cd, a.deposit_no, a.car_no, \n"+
				"                 a.alt_tm, a.alt_prn, a.alt_int, a.alt_amt, a.alt_rest, a.pay_dt1, a.cls_rtn_dt, \n"+
				"                 decode(a.lend_id,'',c.nalt_rest,b.nalt_rest) nalt_rest, \n"+
       			"                 decode(a.lend_id,'',c.nalt_rest_1,b.nalt_rest_1) nalt_rest_1, \n"+
       			"                 decode(a.lend_id,'',c.nalt_rest_2,b.nalt_rest_2) nalt_rest_2, \n"+
       			"                 decode(a.lend_id,'',c.cls_rtn_fee,b.cls_rtn_fee) cls_rtn_fee, \n"+
       			"                 decode(a.lend_id,'',c.cls_rtn_int_amt,b.cls_rtn_int_amt) cls_rtn_int_amt, \n"+
       			"                 decode(a.lend_id,'',c.dly_alt,b.dly_alt) dly_alt, \n"+
       			"                 decode(a.lend_id,'',c.be_alt,b.be_alt) be_alt, \n"+
       			"                 decode(a.lend_id,'',c.cls_rtn_amt,b.cls_rtn_amt) cls_rtn_amt, \n"+
       			"                 decode(a.lend_id,'',c.cls_etc_fee,b.cls_etc_fee) cls_etc_fee \n"+
				"          from   debt_pay_view a, cls_bank b, cls_allot c \n"+
				"           \n";

		if(gubun1.equals("1")){
			if(gubun3.equals(""))		query += " where a.cls_rtn_dt like '"+gubun2+"%' ";
			if(!gubun3.equals(""))		query += " where a.cls_rtn_dt like '"+gubun2+""+gubun3+"%' ";
		}


		query += "                and a.lend_id=b.lend_id(+) and a.rtn_seq=b.rtn_seq(+) and a.cls_rtn_dt=b.cls_rtn_dt(+) \n"+
				"                 and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) and a.car_mng_id=c.car_mng_id(+) and a.cls_rtn_dt=c.cls_rtn_dt(+) \n"+
				"        ) a, allot b, lend_bank c, bank_rtn d, \n"+
				"        (select car_mng_id, max(alt_est_dt) end_dt from scd_alt_case group by car_mng_id) e, \n"+
				"        (select lend_id, rtn_seq, max(alt_est_dt) end_dt from scd_bank group by lend_id, rtn_seq) f \n"+
				" where  a.car_mng_id=b.car_mng_id(+) and a.rent_l_cd=b.rent_l_cd(+) \n"+
				"        and a.lend_id=c.lend_id(+) \n"+
				"        and a.lend_id=d.lend_id(+) and a.rtn_seq=d.seq(+) \n"+
				"        and a.car_mng_id=e.car_mng_id(+) \n"+
				"        and a.lend_id=f.lend_id(+) and a.rtn_seq=f.rtn_seq(+) \n"+
				" ";


		if(!gubun4.equals(""))			query += " and a.cpt_cd='"+gubun4+"'";

		if(!t_wd.equals("")){
			if(s_kd.equals("1"))		query += " and a.deposit_no like '%"+t_wd+"%'";
			if(s_kd.equals("2"))		query += " and a.car_no like '%"+t_wd+"%'";
			if(s_kd.equals("3"))		query += " and nvl(decode(a.lend_id,'',b.lend_no, c.lend_no),a.lend_id||a.rent_l_cd) like '%"+t_wd+"%'";
			if(s_kd.equals("4"))		query += " and decode(a.lend_id,'',b.ven_code, d.ven_code) like '%"+t_wd+"%'";
		}

		if(sort_gubun.equals("5")){
			query += " order by decode(a.lend_id,'',b.ven_code, d.ven_code)";
		}else if(sort_gubun.equals("6")){
			query += " order by decode(a.lend_id,'',b.lend_no, c.lend_no)";
		}else{

			query += " order by decode(a.lend_id,'','2', '1')";

			if(sort_gubun.equals("1"))		query += ", a.cpt_nm, decode(a.lend_id,'',b.lend_dt, c.cont_dt)";
			if(sort_gubun.equals("2"))		query += ", a.deposit_no";
			if(sort_gubun.equals("3"))		query += ", a.car_no";
			if(sort_gubun.equals("4"))		query += ", decode(a.lend_id,'',b.lend_dt, c.cont_dt), decode(a.lend_id,'',b.lend_no, c.lend_no)";

		}

		if(!sort_gubun.equals("") && asc.equals("1"))	query += " desc";
    

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next()){				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddDebtDatabase:getDebtClsList]"+ e);
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

	//테스트
	//할부금 조회를 위한 정보를 FETCH
	public Hashtable getAllotScdListWithParam(String car_mng_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " SELECT * FROM debt_scd_view " +
				"  WHERE car_mng_id = '"+car_mng_id+"' AND use_yn = 'Y' " ;
		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
    		if(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddDebtDatabase:getAllotScdListWithParam]"+ e);
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
}
