package acar.fee;

import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;
import acar.account.*;


public class AddFeeDatabase
{
	private Connection conn = null;
	public static AddFeeDatabase f_db;
	
	public static AddFeeDatabase getInstance()
	{
		if(AddFeeDatabase.f_db == null)
			AddFeeDatabase.f_db = new AddFeeDatabase();
		return AddFeeDatabase.f_db;	
	}	

 	private DBConnectionManager connMgr = null;

    private void getConnection()
    {
    	try
    	{
	    	if(connMgr == null)
				connMgr = DBConnectionManager.getInstance();
			if(conn == null)
			{
	        	conn = connMgr.getConnection("acar");				
	        }
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

	

	// 수금현황 :: 대여료 관리-------------------------------------------------------------------------------


	/**
	 *	대여료 스케줄 리스트 - con_fee/fee_sc_in.jsp
	 *
	 *	입금예정일 : E(0:당일이전, 1:당일, 2:예정)--> 단순하게 입금예정일과 당일 비교
	 *	수금일 : R(0:당일이전, 1:당일, 2:예정) --> 단순하게 수금일과 당일 비교
	 *	연체구분 : D(1:연체, 0:연체아님) 	--> 수금인경우 수금일 > 입금예정일, 미수금인경우 현재날짜 > 입금예정일
	 *	선수구분 : F(1:선수, 0:선수아님)	--> 수금인경우 수금일 < 입금예정일
	 *	수금상태 : RC_YN(0:미수, 1: 수금)	--> Y/N로 표시
	 */
	public Vector getFeeList2(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = " select * from fee_view where nvl(cls_st,'0') <> '2' and nvl(bill_yn,'Y')='Y'";

		/*상세조회&&세부조회*/

		//당월-계획
		if(gubun2.equals("1") && gubun3.equals("1")){		query += " and fee_est_dt like to_char(sysdate,'YYYYMM')||'%'";
		//당월-수금
		}else if(gubun2.equals("1") && gubun3.equals("2")){	query += " and fee_est_dt like to_char(sysdate,'YYYYMM')||'%' and rc_yn='1'";
		//당월-미수금
		}else if(gubun2.equals("1") && gubun3.equals("3")){	query += " and fee_est_dt like to_char(sysdate,'YYYYMM')||'%' and rc_yn='0'";
		//당월-선수금
		}else if(gubun2.equals("1") && gubun3.equals("4")){	query += " and r_fee_est_dt like to_char(sysdate,'YYYYMM')||'%' and fee_est_dt > rc_dt and rc_yn='1'";
		//당일-계획
		}else if(gubun2.equals("2") && gubun3.equals("1")){	query += " and (r_fee_est_dt = to_char(sysdate,'YYYYMMDD') and (rc_yn='0' or rc_dt=to_char(sysdate,'YYYYMMDD')) or r_fee_est_dt >= to_char(sysdate,'YYYYMMDD') and rc_dt=to_char(sysdate,'YYYYMMDD'))";
		//당일-수금
		}else if(gubun2.equals("2") && gubun3.equals("2")){	query += " and r_fee_est_dt >= to_char(sysdate,'YYYYMMDD') and rc_dt=to_char(sysdate,'YYYYMMDD') ";//r_fee_est_dt = to_char(sysdate,'YYYYMMDD') and 
		//당일-미수금
		}else if(gubun2.equals("2") && gubun3.equals("3")){	query += " and r_fee_est_dt = to_char(sysdate,'YYYYMMDD') and rc_yn='0'";
		//연체-계획
		}else if(gubun2.equals("3") && gubun3.equals("1")){	query += " and r_fee_est_dt < to_char(sysdate,'YYYYMMDD') and (rc_yn='0' or rc_dt=to_char(sysdate,'YYYYMMDD'))";
		//연체-수금
		}else if(gubun2.equals("3") && gubun3.equals("2")){	query += " and r_fee_est_dt < to_char(sysdate,'YYYYMMDD') and rc_dt=to_char(sysdate,'YYYYMMDD')";
		//연체-미수금
		}else if(gubun2.equals("3") && gubun3.equals("3")){	query += " and r_fee_est_dt < to_char(sysdate,'YYYYMMDD') and rc_yn='0'";
		//기간-계획
		}else if(gubun2.equals("4") && gubun3.equals("1")){	query += " and fee_est_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		//기간-수금
		}else if(gubun2.equals("4") && gubun3.equals("2")){	query += " and rc_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and rc_yn='1'";
		//기간-미수금
		}else if(gubun2.equals("4") && gubun3.equals("3")){	query += " and fee_est_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and rc_yn='0'";
		//당일+연체-계획
		}else if(gubun2.equals("6") && gubun3.equals("1")){	query += " and (r_fee_est_dt <= to_char(sysdate,'YYYYMMDD') and (rc_yn='0' or rc_dt=to_char(sysdate,'YYYYMMDD')) or rc_dt=to_char(sysdate,'YYYYMMDD'))";
		//당일+연체-수금
		}else if(gubun2.equals("6") && gubun3.equals("2")){	query += " and (r_fee_est_dt <= to_char(sysdate,'YYYYMMDD') and rc_dt=to_char(sysdate,'YYYYMMDD') or rc_dt=to_char(sysdate,'YYYYMMDD')) ";
		//당일+연체-미수금
		}else if(gubun2.equals("6") && gubun3.equals("3")){	query += " and r_fee_est_dt <= to_char(sysdate,'YYYYMMDD') and rc_yn='0'";
		//검색-수금
		}else if(gubun2.equals("5") && gubun3.equals("2")){	query += " and fee_tm = min_fee_tm and rc_yn='1'";
		//검색-미수금
		}else if(gubun2.equals("5") && gubun3.equals("3")){	query += " and fee_tm = min_fee_tm and rc_yn='0'";
		}else{
			query += " and fee_tm = min_fee_tm ";
		}

		/*연체조회*/

		if(gubun2.equals("3")){
			if(gubun4.equals("2")){	//일반연체		
				query += " and dly_day between 1 and 30";
			}else if(gubun4.equals("3")){ //부실연체
				query += " and dly_day between 31 and 60";
			}else if(gubun4.equals("4")){ //악성연체
				query += " and dly_day between 61 and 1000";
			}else{}
		}

		/*검색조건*/
			
		if(s_kd.equals("1"))		query += " and nvl(firm_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("2"))	query += " and nvl(client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and nvl(car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("5"))	query += " and fee_amt like '%"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	query += " and upper(brch_id) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("7"))	query += " and nvl(R_SITE, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("8"))	query += " and BUS_ID2= '"+t_wd+"'\n";
		else if(s_kd.equals("10"))	query += " and BUS_ID= '"+t_wd+"'\n";
		else if(s_kd.equals("9"))	query += " and car_nm||car_name like '%"+t_wd+"%'\n";


		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		/*정렬조건*/

		if(sort_gubun.equals("0"))		query += " order by use_yn desc, dly_chk desc, fee_est_dt "+sort+", rc_dt, firm_nm";
		else if(sort_gubun.equals("1"))	query += " order by use_yn desc, dly_chk desc, firm_nm "+sort+", rc_dt, fee_est_dt";
		else if(sort_gubun.equals("2"))	query += " order by use_yn desc, dly_chk desc, rc_dt "+sort+", firm_nm, fee_est_dt";
		else if(sort_gubun.equals("3"))	query += " order by use_yn desc, dly_chk desc, fee_amt "+sort+", rc_dt, firm_nm, fee_est_dt";
		else if(sort_gubun.equals("4"))	query += " order by use_yn desc, dly_chk desc, dly_day "+sort+", rc_dt, firm_nm, fee_est_dt";
		else if(sort_gubun.equals("5"))	query += " order by car_no "+sort+", firm_nm, fee_est_dt";

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
			System.out.println("[AddFeeDatabase:getFeeList2]\n"+e);
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
	 *	대여료 스케줄 리스트 - con_fee/fee_sc_in.jsp
	 *
	 *	입금예정일 : E(0:당일이전, 1:당일, 2:예정)--> 단순하게 입금예정일과 당일 비교
	 *	수금일 : R(0:당일이전, 1:당일, 2:예정) --> 단순하게 수금일과 당일 비교
	 *	연체구분 : D(1:연체, 0:연체아님) 	--> 수금인경우 수금일 > 입금예정일, 미수금인경우 현재날짜 > 입금예정일
	 *	선수구분 : F(1:선수, 0:선수아님)	--> 수금인경우 수금일 < 입금예정일
	 *	수금상태 : RC_YN(0:미수, 1: 수금)	--> Y/N로 표시
	 */
	public Vector getFeeList3(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
			    " e.client_id, c.firm_nm, c.client_nm, e.r_site, d.car_mng_id, d.car_no, d.car_nm, b.brch_id, f.user_nm as bus_nm2, b.bus_id, b.bus_id2, b.use_yn,"+
				" (a.fee_s_amt+a.fee_v_amt) fee_amt, a.*,"+
				" h.*"+
				" from scd_fee a, cont b, client c, car_reg d, client_site e, users f,"+
				" (select rent_l_cd, max(reg_dt||reg_dt_time) reg_dt from dly_mm group by rent_l_cd) g,"+
				" (select a.rent_l_cd, b.user_nm as reg_nm, a.speaker, a.content, reg_dt||reg_dt_time as reg_dt, reg_dt as reg_dt2 from dly_mm a, users b where a.reg_id=b.user_id) h,"+
				" (select rent_l_cd from cls_cont where cls_st='2') i,"+
				" (select rent_l_cd, min(fee_est_dt) fee_est_dt from scd_fee where rc_yn='0' group by rent_l_cd) j"+
				" where"+
				" nvl(a.bill_yn,'Y')='Y' and a.rent_l_cd=b.rent_l_cd"+
				" and b.client_id=c.client_id"+
				" and b.car_mng_id=d.car_mng_id"+
				" and b.client_id=e.client_id(+) and b.r_site=e.seq(+)"+
				" and b.bus_id2=f.user_id(+)"+
				" and a.rent_l_cd=g.rent_l_cd(+)"+
				" and g.rent_l_cd=h.rent_l_cd(+) and g.reg_dt=h.reg_dt(+)"+
				" and a.rent_l_cd=i.rent_l_cd(+) and i.rent_l_cd is null"+
				" and a.rent_l_cd=j.rent_l_cd(+)";

		String fee_mon	= "substr(a.r_fee_est_dt,1,6)";
		String now_mon	= "to_char(sysdate,'YYYYMM')";
		String fee_dt	= "a.r_fee_est_dt";
		String rc_dt	= "a.rc_dt";
		String now_dt	= "to_char(sysdate,'YYYYMMDD')";

		
		/*상세조회&&세부조회*/
		//당월------------------------------------------------------------------------------------------------------------
		//계획
		if(gubun2.equals("1") && gubun3.equals("1")){		query += " and "+fee_dt+" like "+now_mon+"||'%' ";
		//수금
		}else if(gubun2.equals("1") && gubun3.equals("2")){	query += " and "+fee_dt+" like "+now_mon+"||'%' and a.rc_yn='1'";
		//미수금
		}else if(gubun2.equals("1") && gubun3.equals("3")){	query += " and "+fee_dt+" like "+now_mon+"||'%' and a.rc_yn='0'";
		//선수금
		}else if(gubun2.equals("1") && gubun3.equals("4")){	query += " and "+fee_dt+" like "+now_mon+"||'%' and "+fee_dt+">"+rc_dt+" ";
		//당일------------------------------------------------------------------------------------------------------------
		//계획
		}else if(gubun2.equals("2") && gubun3.equals("1")){	query += " and ("+rc_dt+"="+now_dt+" or ("+fee_dt+"="+now_dt+" and a.rc_yn='0'))";
		//수금
		}else if(gubun2.equals("2") && gubun3.equals("2")){	query += " and  "+rc_dt+"="+now_dt+" ";
		//미수금
		}else if(gubun2.equals("2") && gubun3.equals("3")){	query += " and  "+fee_dt+"="+now_dt+" and a.rc_yn='0'";
		//연체------------------------------------------------------------------------------------------------------------
		//계획
		}else if(gubun2.equals("3") && gubun3.equals("1")){	query += " and "+fee_dt+"<"+now_dt+" and (a.rc_yn='0' or "+rc_dt+"="+now_dt+")";
		//수금
		}else if(gubun2.equals("3") && gubun3.equals("2")){	query += " and "+fee_dt+"<"+now_dt+" and "+rc_dt+"="+now_dt+"";
		//미수금
		}else if(gubun2.equals("3") && gubun3.equals("3")){	query += " and "+fee_dt+"<"+now_dt+" and a.rc_yn='0'";
		//당일+연체------------------------------------------------------------------------------------------------------------
		//계획
		}else if(gubun2.equals("6") && gubun3.equals("1")){	query += " and "+fee_dt+"<="+now_dt+" and (a.rc_yn='0' or "+rc_dt+"="+now_dt+")";
		//수금
		}else if(gubun2.equals("6") && gubun3.equals("2")){	query += " and "+fee_dt+"<="+now_dt+" and "+rc_dt+"="+now_dt+"";
		//미수금
		}else if(gubun2.equals("6") && gubun3.equals("3")){	query += " and "+fee_dt+"<="+now_dt+" and a.rc_yn='0'";
		//기간------------------------------------------------------------------------------------------------------------
		//계획
		}else if(gubun2.equals("4") && gubun3.equals("1")){	query += " and "+fee_dt+" BETWEEN replace('"+st_dt+"', '-', '') AND replace('"+end_dt+"', '-', '')";
		//수금
		}else if(gubun2.equals("4") && gubun3.equals("2")){	query += " and "+rc_dt+"  BETWEEN replace('"+st_dt+"', '-', '') AND replace('"+end_dt+"', '-', '')";
		//미수금
		}else if(gubun2.equals("4") && gubun3.equals("3")){	query += " and "+fee_dt+" BETWEEN replace('"+st_dt+"', '-', '') AND replace('"+end_dt+"', '-', '') and a.rc_yn='0'";
		//검색------------------------------------------------------------------------------------------------------------
		//검색-수금
		}else if(gubun2.equals("5") && gubun3.equals("2")){	query += " and a.rc_yn='1'";
		//검색-미수금
		}else if(gubun2.equals("5") && gubun3.equals("3")){	query += " and a.rc_yn='0'";
		}else{												query += " and a.fee_est_dt=j.fee_est_dt";	
		}

		/*연체조회*/

		if(gubun2.equals("3")){
			if(gubun4.equals("2")){	//일반연체		
				query += " and a.dly_day between 1 and 30";
			}else if(gubun4.equals("3")){ //부실연체
				query += " and a.dly_day between 31 and 60";
			}else if(gubun4.equals("4")){ //악성연체
				query += " and a.dly_day between 61 and 1000";
			}else{}
		}

		/*검색조건*/
			
		if(s_kd.equals("1"))		query += " and nvl(c.firm_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("2"))	query += " and nvl(c.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(a.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and nvl(d.car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("5"))	query += " and (a.fee_s_amt+a.fee_v_amt) = "+t_wd+"\n";
		else if(s_kd.equals("6"))	query += " and upper(b.brch_id) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("7"))	query += " and nvl(e.r_site, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("8"))	query += " and b.BUS_ID2= '"+t_wd+"'\n";
		else if(s_kd.equals("10"))	query += " and b.BUS_ID= '"+t_wd+"'\n";
		else if(s_kd.equals("9"))	query += " and d.car_nm like '%"+t_wd+"%'\n";


		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		/*정렬조건*/

		if(sort_gubun.equals("0"))		query += " order by b.use_yn desc, a.dly_chk desc, a.fee_est_dt "+sort+", a.rc_dt, c.firm_nm";
		else if(sort_gubun.equals("1"))	query += " order by b.use_yn desc, a.dly_chk desc, c.firm_nm "+sort+", a.rc_dt, a.fee_est_dt";
		else if(sort_gubun.equals("2"))	query += " order by b.use_yn desc, a.dly_chk desc, a.rc_dt "+sort+", c.firm_nm, a.fee_est_dt";
		else if(sort_gubun.equals("3"))	query += " order by b.use_yn desc, a.dly_chk desc, a.fee_s_amt "+sort+", a.rc_dt, c.firm_nm, a.fee_est_dt";
		else if(sort_gubun.equals("4"))	query += " order by b.use_yn desc, a.dly_chk desc, a.dly_day "+sort+", a.rc_dt, c.firm_nm, a.fee_est_dt";
		else if(sort_gubun.equals("5"))	query += " order by d.car_no "+sort+", c.firm_nm, a.fee_est_dt";


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
			System.out.println("[AddFeeDatabase:getFeeList3]\n"+e);
			System.out.println("[AddFeeDatabase:getFeeList3]\n"+query);
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
	 *	대여료 스케줄 리스트 - con_fee/fee_sc_in.jsp
	 *
	 *	입금예정일 : E(0:당일이전, 1:당일, 2:예정)--> 단순하게 입금예정일과 당일 비교
	 *	수금일 : R(0:당일이전, 1:당일, 2:예정) --> 단순하게 수금일과 당일 비교
	 *	연체구분 : D(1:연체, 0:연체아님) 	--> 수금인경우 수금일 > 입금예정일, 미수금인경우 현재날짜 > 입금예정일
	 *	선수구분 : F(1:선수, 0:선수아님)	--> 수금인경우 수금일 < 입금예정일
	 *	수금상태 : RC_YN(0:미수, 1: 수금)	--> Y/N로 표시
	 */
	public Vector getFeeList4(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select /*+ leading(A H O) index(a SCD_FEE_IDX5)  index(b CONT_IDX3) index(c CLIENT_PK )*/ "+ 
			    "       b.client_id, c.firm_nm, c.client_nm, d.car_mng_id, d.car_no, d.car_nm, b.brch_id, f.user_nm as bus_nm2, b.bus_id, b.bus_id2, b.use_yn,"+
				"       (a.fee_s_amt+a.fee_v_amt) fee_amt, a.*,"+
				"       h.reg_nm, h.speaker, h.content, h.reg_dt, h.reg_dt2,"+
				"       o.tax_dt as tax_dt \n "+
				" from  scd_fee a, cont b, client c, car_reg d, users f, "+
				"       (select rent_mng_id, rent_l_cd, max(reg_dt||reg_dt_time) reg_dt from dly_mm group by rent_mng_id, rent_l_cd) g,"+
				"       (select a.rent_mng_id, a.rent_l_cd, b.user_nm as reg_nm, a.speaker, a.content, reg_dt||reg_dt_time as reg_dt, reg_dt as reg_dt2 from dly_mm a, users b where a.reg_id=b.user_id) h,"+
				"       (select rent_mng_id, rent_l_cd, min(fee_est_dt) fee_est_dt from scd_fee where rc_yn='0' and fee_s_amt>0 group by rent_mng_id, rent_l_cd) j,"+
			    "       (select nvl(d.client_id,a.client_id) client_id, min(b.r_fee_est_dt) r_fee_est_dt from cont a, scd_fee b, cls_cont c, fee_rtn d where a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd(+) and b.rent_mng_id=d.rent_mng_id(+) and b.rent_l_cd=d.rent_l_cd(+) and b.rent_st=d.rent_st(+) and b.rent_seq=d.rent_seq(+) and nvl(c.cls_st,'0')<>'2' and b.fee_s_amt>0 and nvl(b.bill_yn,'Y')='Y' and b.rc_yn='0' group by nvl(d.client_id,a.client_id)) k,"+
				"       (select /*+index(tax TAX_IDX10) */ "+
				"               b.rent_l_cd, b.tm, nvl(b.rent_st,'') rent_st, nvl(b.rent_seq,'') rent_seq, max(a.tax_dt) tax_dt, sum(b.item_supply) item_supply \n"+
				"	     from   tax a, tax_item_list b \n"+
				"		 where  a.gubun='1' and a.tax_st<>'C' and a.item_id=b.item_id \n"+
				"	     group by b.rent_l_cd, b.tm, b.rent_st, b.rent_seq \n"+
                "        having sum(b.item_supply) >0 "+
		  	    "	    ) o \n"+
				" where  \n "+
				" a.bill_yn='Y' and a.fee_s_amt>0 and a.rent_l_cd=b.rent_l_cd and b.car_st<>'4' and b.use_yn='Y' "+
				" and b.client_id=c.client_id"+
				" and b.car_mng_id=d.car_mng_id"+
				" and b.bus_id2=f.user_id"+
				" and a.rent_mng_id=g.rent_mng_id(+) and a.rent_l_cd=g.rent_l_cd(+)"+
				" and g.rent_mng_id=h.rent_mng_id(+) and g.rent_l_cd=h.rent_l_cd(+) and g.reg_dt=h.reg_dt(+)"+
				" and a.rent_mng_id=j.rent_mng_id(+) and a.rent_l_cd=j.rent_l_cd(+)"+
				" and b.client_id=k.client_id"+ 
				" and a.rent_l_cd=o.rent_l_cd(+) and a.fee_tm=o.tm(+) and a.rent_st=o.rent_st(+) and a.rent_seq=o.rent_seq(+) "+
				" ";
			
		String fee_mon	= "substr(a.r_fee_est_dt,1,6)";
		String now_mon	= "to_char(sysdate,'YYYYMM')";
		String fee_dt	= "a.r_fee_est_dt";
		String rc_dt	= "a.rc_dt";
		String now_dt	= "to_char(sysdate,'YYYYMMDD')";

		
		/*상세조회&&세부조회*/
		//당월------------------------------------------------------------------------------------------------------------
		//계획
		if(gubun2.equals("1") && gubun3.equals("1")){		query += " and "+fee_dt+" like "+now_mon+"||'%' ";
		//수금
		}else if(gubun2.equals("1") && gubun3.equals("2")){	query += " and "+fee_dt+" like "+now_mon+"||'%' and a.rc_yn='1'";
		//미수금
		}else if(gubun2.equals("1") && gubun3.equals("3")){	query += " and "+fee_dt+" like "+now_mon+"||'%' and a.rc_yn='0'";
		//선수금
		}else if(gubun2.equals("1") && gubun3.equals("4")){	query += " and "+fee_dt+" like "+now_mon+"||'%' and "+fee_dt+">"+rc_dt+" ";
		//당일------------------------------------------------------------------------------------------------------------
		//계획
		}else if(gubun2.equals("2") && gubun3.equals("1")){	query += " and ("+rc_dt+"="+now_dt+" or ("+fee_dt+"="+now_dt+" and a.rc_yn='0'))";
		//수금
		}else if(gubun2.equals("2") && gubun3.equals("2")){	query += " and  "+rc_dt+"="+now_dt+" ";
		//미수금
		}else if(gubun2.equals("2") && gubun3.equals("3")){	query += " and  "+fee_dt+"="+now_dt+" and a.rc_yn='0'";
		//연체------------------------------------------------------------------------------------------------------------
		//계획
		}else if(gubun2.equals("3") && gubun3.equals("1")){	query += " and "+fee_dt+"<"+now_dt+" and (a.rc_yn='0' or "+rc_dt+"="+now_dt+")";
		//수금
		}else if(gubun2.equals("3") && gubun3.equals("2")){	query += " and "+fee_dt+"<"+now_dt+" and "+rc_dt+"="+now_dt+"";
		//미수금
		}else if(gubun2.equals("3") && gubun3.equals("3")){	query += " and "+fee_dt+"<"+now_dt+" and a.rc_yn='0'";
		//당일+연체------------------------------------------------------------------------------------------------------------
		//계획
		}else if(gubun2.equals("6") && gubun3.equals("1")){	query += " and "+fee_dt+"<="+now_dt+" and (a.rc_yn='0' or "+rc_dt+"="+now_dt+")";
		//수금
		}else if(gubun2.equals("6") && gubun3.equals("2")){	query += " and "+fee_dt+"<="+now_dt+" and "+rc_dt+"="+now_dt+"";
		//미수금
		}else if(gubun2.equals("6") && gubun3.equals("3")){	query += " and "+fee_dt+"<="+now_dt+" and a.rc_yn='0'";
		//기간------------------------------------------------------------------------------------------------------------
		//계획
		}else if(gubun2.equals("4") && gubun3.equals("1")){	query += " and "+fee_dt+" BETWEEN replace('"+st_dt+"', '-', '') AND replace('"+end_dt+"', '-', '')";
		//수금
		}else if(gubun2.equals("4") && gubun3.equals("2")){	query += " and "+rc_dt+"  BETWEEN replace('"+st_dt+"', '-', '') AND replace('"+end_dt+"', '-', '')";
		//미수금
		}else if(gubun2.equals("4") && gubun3.equals("3")){	query += " and "+fee_dt+" BETWEEN replace('"+st_dt+"', '-', '') AND replace('"+end_dt+"', '-', '') and a.rc_yn='0'";
		//검색------------------------------------------------------------------------------------------------------------
		//검색-수금
		}else if(gubun2.equals("5") && gubun3.equals("2")){	query += " and a.rc_yn='1'";
		//검색-미수금
		}else if(gubun2.equals("5") && gubun3.equals("3")){	query += " and a.rc_yn='0'";
		}else{												query += " and a.fee_est_dt=j.fee_est_dt";	
		}

		/*연체조회*/

		if(gubun2.equals("3")){
			if(gubun4.equals("2")){	//일반연체		
				query += " and a.dly_days between 1 and 30";
			}else if(gubun4.equals("3")){ //부실연체
				query += " and a.dly_days between 31 and 60";
			}else if(gubun4.equals("4")){ //악성연체
				query += " and a.dly_days between 61 and 1000";
			}else{}
		}



		/*검색조건*/
			
		if(s_kd.equals("1"))		query += " and c.firm_nm like '%"+t_wd+"%'\n";
		else if(s_kd.equals("2"))	query += " and c.client_nm like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and a.rent_l_cd like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and d.car_no like '%"+t_wd+"%'\n";
		else if(s_kd.equals("5"))	query += " and (a.fee_s_amt+a.fee_v_amt) = to_number(replace('"+t_wd+"',',',''))\n";
		else if(s_kd.equals("6"))	query += " and b.brch_id like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("8"))	query += " and b.BUS_ID2= '"+t_wd+"'\n";
		else if(s_kd.equals("10"))	query += " and b.BUS_ID= '"+t_wd+"'\n";
		else if(s_kd.equals("9"))	query += " and d.car_nm like '%"+t_wd+"%'\n";


		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		/*정렬조건*/

		if(sort_gubun.equals("0"))		query += " order by b.use_yn desc, a.dly_chk desc, k.r_fee_est_dt "+sort+", c.firm_nm, a.r_fee_est_dt, b.rent_start_dt, b.rent_mng_id";
		else if(sort_gubun.equals("1"))	query += " order by b.use_yn desc, a.dly_chk desc, c.firm_nm "+sort+", a.rc_dt, a.fee_est_dt";
		else if(sort_gubun.equals("2"))	query += " order by b.use_yn desc, a.dly_chk desc, a.rc_dt "+sort+", c.firm_nm, a.fee_est_dt";
		else if(sort_gubun.equals("3"))	query += " order by b.use_yn desc, a.dly_chk desc, a.fee_s_amt "+sort+", a.rc_dt, c.firm_nm, a.fee_est_dt";
		else if(sort_gubun.equals("4"))	query += " order by b.use_yn desc, a.dly_chk desc, a.dly_days "+sort+", a.rc_dt, c.firm_nm, a.fee_est_dt";
		else if(sort_gubun.equals("5"))	query += " order by d.car_no "+sort+", c.firm_nm, a.fee_est_dt";


		
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
			System.out.println("[AddFeeDatabase:getFeeList4]\n"+e);
			System.out.println("[AddFeeDatabase:getFeeList4]\n"+query);
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
	 *	대여료 스케줄 관리 - con_fee/fee_scd_in.jsp
	 */
	public Vector getFeeScdList(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select "+
				" a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.r_site, a.use_yn, a.rent_dt,"+
				" nvl(b.car_no,'미등록') car_no, b.init_reg_dt, g.car_nm, f.car_name, "+
				" c.firm_nm, "+
				" a.rent_st, d.rent_start_dt, d.fee_s_amt, d.fee_v_amt, (d.fee_s_amt+d.fee_v_amt) fee_amt, d.con_mon, d.rent_way,"+
				" nvl(h.scd_cnt,0) scd_cnt,"+
				" nvl(i.pay_cnt,0) pay_cnt"+
				" from cont a, car_reg b, client c, fee d, car_etc e, car_nm f, car_mng g, "+
				" (select rent_mng_id, rent_l_cd, count(0) scd_cnt from scd_fee where tm_st1='0' group by rent_mng_id, rent_l_cd) h,"+
				" (select rent_mng_id, rent_l_cd, count(0) pay_cnt from scd_fee where nvl(bill_yn,'Y')='Y' and rc_yn='0' group by rent_mng_id, rent_l_cd) i"+
				" where "+
				" a.car_mng_id=b.car_mng_id(+)"+
				" and a.client_id=c.client_id"+
				" and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd and d.rent_st='1'"+
				" and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd"+
				" and e.car_id=f.car_id and e.car_seq=f.car_seq "+
				" and f.car_comp_id=g.car_comp_id and f.car_cd=g.code"+
				" and d.rent_mng_id=h.rent_mng_id(+) and d.rent_l_cd=h.rent_l_cd(+)"+
				" and d.rent_mng_id=i.rent_mng_id(+) and d.rent_l_cd=i.rent_l_cd(+)"+
				" and a.car_st<>'2'";


		if(t_wd.equals("")){

			if(gubun3.equals("2"))	query += " and h.scd_cnt is not null";
			if(gubun3.equals("3"))	query += " and h.scd_cnt is null and nvl(a.use_yn,'Y')='Y'";

			if(gubun2.equals("1"))	query += " and d.rent_start_dt like to_char(sysdate,'YYYYMM')||'%'";
			if(gubun2.equals("2"))	query += " and d.rent_start_dt = to_char(sysdate,'YYYYMMDD')";
			if(gubun2.equals("3"))	query += " and d.rent_start_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";

		}else{

			/*검색조건*/			
			if(s_kd.equals("1"))		query += " and nvl(c.firm_nm, '') like '%"+t_wd+"%'\n";
			else if(s_kd.equals("2"))	query += " and upper(a.rent_l_cd) like upper('%"+t_wd+"%')\n";
			else if(s_kd.equals("3"))	query += " and nvl(b.car_no, '') like '%"+t_wd+"%'\n";

		}

		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		/*정렬조건*/

		if(sort_gubun.equals("0"))		query += " order by a.use_yn desc, nvl(d.rent_start_dt, '00000000') "+sort+", b.init_reg_dt, a.rent_dt";
		else if(sort_gubun.equals("1"))	query += " order by a.use_yn desc, c.firm_nm "+sort;
		else if(sort_gubun.equals("2"))	query += " order by b.car_no "+sort;

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
			System.out.println("[AddFeeDatabase:getFeeScdList]\n"+e);
			System.out.println("[AddFeeDatabase:getFeeScdList]\n"+query);
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
	 *	대여료 스케줄 관리 - con_fee/fee_scd_in.jsp
	 */
	public Vector getFeeScdListAll(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String query1 = "";
		String query2 = "";
		String query3 = "";

		query1 = " select  "+
				 "        '지연' gubun, g.cng_dt, a.bus_id, a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.r_site, a.use_yn, a.rent_dt, \n"+
				 "        a.firm_nm, nvl(cr.car_no,'미등록') car_no, cr.init_reg_dt, cr.car_nm, a.rent_st as cont_st, '1' rent_st, \n"+
				 "        b.car_rent_st as rent_start_dt, b.car_rent_et as rent_end_dt, b.car_rent_tm as con_mon, \n"+
				 "        decode(c.rent_l_cd,'','미등록',decode(sign(2-(to_date(nvl(e.use_s_dt,to_char(sysdate,'YYYYMMDD')),'YYYYMMDD')-to_date(c.use_e_dt,'YYYYMMDD'))),-1,'미등록','등록')) reg_yn, "+
				 "        nvl(c.pay_cnt,0), c.dly_amt, \n"+
				 "        decode(c.rent_l_cd,'','-',decode(sign(2-(to_date(nvl(e.use_s_dt,to_char(sysdate,'YYYYMMDD')),'YYYYMMDD')-to_date(c.use_e_dt,'YYYYMMDD'))),-1,'진행','종료')) end_yn, "+
				 "        c.use_e_dt, decode(a.car_gu,'0','(재)','') car_gu_nm, \n"+
				 "        decode(d.rent_start_dt,'','','신차개시') start_yn,"+
				 "        trunc(months_between(sysdate, to_date(b.car_rent_st,'YYYYMMDD')),0) use_mon "+
				 " from   cont_n_view a, taecha b, fee d, car_reg cr, \n"+
				 "        (select rent_mng_id, rent_l_cd, sum(decode(rc_yn,'1',0,fee_s_amt)) dly_amt, count(0) pay_cnt, max(use_e_dt) use_e_dt from scd_fee where nvl(bill_yn,'Y')='Y' and tm_st2='2' group by rent_mng_id, rent_l_cd) c, \n"+
				 "        (select rent_mng_id, rent_l_cd, min(fee_tm) fee_tm, min(use_s_dt) use_s_dt from scd_fee where nvl(bill_yn,'Y')='Y' and tm_st2='0' and tm_st1='0' group by rent_mng_id, rent_l_cd) e, \n"+
				 "        cont_etc f, (SELECT * FROM (SELECT rent_mng_id, rent_l_cd, '20'||REPLACE(SUBSTR(cng_dt, 0,10),'/','') as cng_dt, rank() over(partition BY rent_mng_id, rent_l_cd ORDER BY cng_dt desc) AS ranks  FROM SCD_FEE_CNG  )  WHERE ranks = '1') g,  \n"+
			     "	      ( select * from cls_cont where cls_st in ('4')) y \n"+
				 " where  a.car_st in ('1','3') and a.rent_mng_id=b.rent_mng_id and nvl(a.use_yn,'Y')='Y' and b.rent_fee>0 and nvl(d.fee_chk,'0')<>'1' \n"+
				 "        and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) and a.car_mng_id = cr.car_mng_id(+) \n"+
				 "        and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+) and nvl(e.fee_tm,'1')='1' \n "+
				 "        and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd and d.rent_st='1' "+
				 "        and d.prv_dlv_yn='Y' and nvl(b.req_st,'1')='1' and nvl(b.tae_st,'1')='1' \n"+
				 "        and a.rent_mng_id=f.rent_mng_id(+) and a.rent_l_cd=f.rent_l_cd(+) AND a.rent_mng_id=g.rent_mng_id(+) AND a.rent_l_cd=g.rent_l_cd(+) "+
				 "        and a.rent_mng_id=y.rent_mng_id(+) and a.reg_dt=y.reg_dt(+) \n"+
				 "	      and d.rent_dt >= nvl(decode(y.rent_mng_id,'',f.rent_suc_dt,y.cls_dt),d.rent_dt) "+	
				 " "	 ;

		query2 = " select  "+
				 "        '신차' gubun, g.cng_dt, a.bus_id, a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.r_site, a.use_yn, a.rent_dt, \n"+
				 "        a.firm_nm, nvl(cr.car_no,'미등록') car_no, cr.init_reg_dt, cr.car_nm, a.rent_st as cont_st, '1' rent_st, \n"+
				 "        b.rent_start_dt, b.rent_end_dt, b.con_mon, \n "+
				 "        decode(c.rent_l_cd,'','미등록','등록') reg_yn, nvl(c.pay_cnt,0), c.dly_amt, \n "+
				 "        decode(c.rent_l_cd,'','-',decode(nvl(c.dly_amt,0),0,'종료','진행')) end_yn, c.use_e_dt, decode(a.car_gu,'0','(재)','') car_gu_nm, \n"+
				 "        decode(b.rent_start_dt,'',decode(cr.init_reg_dt,'미등록','','차량등록'),'신차개시') start_yn, \n"+
				 "        decode(nvl(b.rent_start_dt,replace(replace(decode(a.car_gu,0,a.rent_dt,cr.init_reg_dt),'미등록',''),'-','')),'',0,trunc(months_between(sysdate, to_date(nvl(b.rent_start_dt,replace(replace(decode(a.car_gu,0,a.rent_dt,cr.init_reg_dt),'미등록',''),'-','')),'YYYYMMDD')),0)) use_mon \n"+
				 " from   cont_n_view a, fee b, car_reg cr,  \n"+
				 "        (select rent_mng_id, rent_l_cd, sum(decode(rc_yn,'1',0,fee_s_amt)) dly_amt, count(0) pay_cnt, max(use_e_dt) use_e_dt from scd_fee where nvl(bill_yn,'Y')='Y' and rent_st='1' and tm_st2<>'2' and tm_st1='0' group by rent_mng_id, rent_l_cd) c, \n"+
			     "        cont_etc d, (SELECT * FROM (SELECT rent_mng_id, rent_l_cd, '20'||REPLACE(SUBSTR(cng_dt, 0,10),'/','') as cng_dt, rank() over(partition BY rent_mng_id, rent_l_cd ORDER BY cng_dt desc) AS ranks  FROM SCD_FEE_CNG  )  WHERE ranks = '1') g, \n"+
			     "	      ( select * from cls_cont where cls_st in ('4')) y \n"+
				 " where  b.fee_s_amt >0  and a.car_st in ('1','3') "+
				 "        and b.rent_st='1' "+
				 "        and nvl(b.fee_chk,'0')='0' "+	//매월납입
				 "        and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				 "        and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) \n"+
				 "        and (b.con_mon-nvl(b.pere_r_mth,0))>0"+ //개시대여료가 총개월수랑 같을 경우 제외
				 "        and a.car_mng_id is not null and a.car_mng_id = cr.car_mng_id(+) \n"+	//차량연결분
				 "        and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+) AND a.rent_mng_id=g.rent_mng_id(+) AND a.rent_l_cd=g.rent_l_cd(+) "+
				 "        and a.rent_mng_id=y.rent_mng_id(+) and a.reg_dt=y.reg_dt(+) \n"+
				 "	      and b.rent_dt >= nvl(decode(y.rent_mng_id,'',d.rent_suc_dt,y.cls_dt),b.rent_dt) "+	
				 " ";


		//월렌트 대여료스케줄관리는 별도로 한다.


		if(!t_wd.equals("")){
			query2 += " and a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd(+)";	
		}else{
			query2 += " and nvl(a.use_yn,'Y')='Y' ";					
		}

		query3 = " select  "+
				 "        '연장('||to_char(to_number(b.rent_st)-1)||')' gubun, g.cng_dt, a.bus_id, a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.r_site, a.use_yn, a.rent_dt, \n"+
				 "        a.firm_nm, nvl(cr.car_no,'미등록') car_no, cr.init_reg_dt, cr.car_nm, a.rent_st as cont_st, b.rent_st, \n"+
				 "        b.rent_start_dt, b.rent_end_dt, b.con_mon, \n"+
				 "        decode(c.rent_l_cd,'','미등록','등록') reg_yn, nvl(c.pay_cnt,0), c.dly_amt, \n "+
				 "        decode(c.rent_l_cd,'','-',decode(nvl(c.dly_amt,0),0,'종료','진행')) end_yn, c2.use_e_dt, decode(a.car_gu,'0','(재)','') car_gu_nm, '' start_yn,\n"+
				 "        decode(nvl(b.rent_start_dt,replace(replace(cr.init_reg_dt,'미등록',''),'-','')),'',0,trunc(months_between(sysdate, to_date(nvl(b.rent_start_dt,replace(replace(cr.init_reg_dt,'미등록',''),'-','')),'YYYYMMDD')),0)) use_mon \n"+
				 " from   cont_n_view a, fee b, car_reg cr, \n "+
				 "        (select rent_mng_id, rent_l_cd, rent_st, sum(decode(rc_yn,'1',0,fee_s_amt)) dly_amt, count(0) pay_cnt, max(use_e_dt) use_e_dt from scd_fee where nvl(bill_yn,'Y')='Y' and rent_st<>'1' and tm_st2<>'2' and tm_st1='0' group by rent_mng_id, rent_l_cd, rent_st) c, \n"+
				 "        cont_etc d, (SELECT * FROM (SELECT rent_mng_id, rent_l_cd, '20'||REPLACE(SUBSTR(cng_dt, 0,10),'/','') as cng_dt, rank() over(partition BY rent_mng_id, rent_l_cd ORDER BY cng_dt desc) AS ranks  FROM SCD_FEE_CNG  )  WHERE ranks = '1') g, \n"+
				 "        (select rent_mng_id, rent_l_cd, max(use_e_dt) use_e_dt from scd_fee where nvl(bill_yn,'Y')='Y' group by rent_mng_id, rent_l_cd) c2, \n"+
			     "	      ( select * from cls_cont where cls_st in ('4')) y \n"+
				 " where  b.fee_s_amt >0 and a.car_st in ('1','3') and nvl(a.use_yn,'Y')='Y' and b.rent_st<>'1' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n "+
				 "        and b.rent_mng_id=c.rent_mng_id(+) and b.rent_l_cd=c.rent_l_cd(+) and b.rent_st=c.rent_st(+) \n "+
				 "        and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+) AND a.rent_mng_id=g.rent_mng_id(+) AND a.rent_l_cd=g.rent_l_cd(+) and a.car_mng_id = cr.car_mng_id(+) "+
				 "        and (b.con_mon-nvl(b.pere_r_mth,0))>0"+ //개시대여료가 총개월수랑 같을 경우 제외
				 "        and nvl(b.fee_chk,'0')='0'"+	//매월납입
				 "        and a.rent_mng_id=y.rent_mng_id(+) and a.reg_dt=y.reg_dt(+) \n"+
				 //"	  and b.rent_dt >= nvl(decode(y.rent_mng_id,'',d.rent_suc_dt,y.cls_dt),b.rent_dt) "+
				 "        and b.rent_dt >= DECODE(b.rent_st,d.suc_rent_st,TO_CHAR(TO_DATE(d.rent_suc_dt,'YYYYMMDD')-30,'YYYYMMDD'),b.rent_dt) \r\n"+
				 "        AND (d.rent_suc_dt IS NULL OR (d.rent_suc_dt IS NOT NULL AND b.rent_st >=d.suc_rent_st)) \n"+
				 "        and b.rent_mng_id=c2.rent_mng_id(+) and b.rent_l_cd=c2.rent_l_cd(+) \n "+
				 " ";
		
		
		query = " select * from ( "+query1+" union all "+query2+" union all "+query3+" )";


		if(t_wd.equals("")){


			if(gubun4.equals("2"))	query = " select * from ( "+query1+" )";
			if(gubun4.equals("3"))	query = " select * from ( "+query2+" )";
			if(gubun4.equals("4"))	query = " select * from ( "+query3+" )";

			if(gubun3.equals("1"))	query += " where nvl(use_yn,'Y')='Y'";
			if(gubun3.equals("2"))	query += " where reg_yn='등록'";
			if(gubun3.equals("3"))	query += " where reg_yn='미등록' and nvl(use_yn,'Y')='Y'";
			
			if(gubun3.equals("4") && gubun2.equals("1")){
				query += " where cng_dt is not null and rent_start_dt like to_char(sysdate,'YYYYMM')||'%' ";
			}else if(gubun3.equals("4") && gubun2.equals("2")){ 
				query += " where cng_dt is not NULL and rent_start_dt = to_char(sysdate,'YYYYMMDD') ";
			}else if(gubun3.equals("4") && gubun2.equals("3")){	
				query += " where cng_dt is not null and cng_dt BETWEEN replace('"+st_dt+"','-','') AND replace('"+end_dt+"','-','')";
			}
						
			if(gubun3.equals("1")||gubun3.equals("2")||gubun3.equals("3")){
				if(gubun2.equals("1"))	query += " and rent_start_dt like to_char(sysdate,'YYYYMM')||'%'";
				if(gubun2.equals("2"))	query += " and rent_start_dt = to_char(sysdate,'YYYYMMDD')";
				if(gubun2.equals("3"))	query += " and rent_start_dt BETWEEN replace('"+st_dt+"','-','') AND replace('"+end_dt+"','-','')";
			}

		}else{

			/*검색조건*/			
			if(s_kd.equals("1"))		query += " where nvl(firm_nm, '') like '%"+t_wd+"%'\n";
			else if(s_kd.equals("2"))	query += " where upper(rent_l_cd) like upper('%"+t_wd+"%')\n";
			else if(s_kd.equals("3"))	query += " where nvl(car_no, '') like '%"+t_wd+"%'\n";

		}

		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		/*정렬조건*/

		if(sort_gubun.equals("0"))		query += " order by nvl(use_yn,'Y') desc, decode(gubun,'지연','1','신차','2','연장','3'), decode(gubun,'지연',rent_dt,'99999999'), nvl(rent_start_dt, '00000000') "+sort+", init_reg_dt, rent_dt";
		else if(sort_gubun.equals("1"))	query += " order by nvl(use_yn,'Y') desc, firm_nm "+sort;
		else if(sort_gubun.equals("2"))	query += " order by nvl(use_yn,'Y') desc, car_no "+sort;
		else if(sort_gubun.equals("3"))	query += " and cng_dt BETWEEN replace('"+st_dt+"','-','') AND replace('"+end_dt+"','-','') order by cng_dt "+sort;

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
			System.out.println("[AddFeeDatabase:getFeeScdListAll]\n"+e);
			System.out.println("[AddFeeDatabase:getFeeScdListAll]\n"+query);
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
	 *	대여료 스케줄 관리 - con_fee/fee_scd_in.jsp
	 */
	public Vector getFeeScdListRmAll(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String query2 = "";
		String query3 = "";


		query2 = " select   "+
				 "        '신차' gubun, g.cng_dt, a.bus_id, a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.r_site, a.use_yn, a.rent_dt, \n"+
				 "        a.firm_nm, nvl(cr.car_no,'미등록') car_no, cr.init_reg_dt, cr.car_nm, a.rent_st as cont_st, '1' rent_st, \n"+
				 "        b.rent_start_dt, b.rent_end_dt, b.con_mon, f.con_day,  \n "+
				 "        decode(c.rent_l_cd,'','미등록','등록') reg_yn, nvl(c.pay_cnt,0), c.dly_amt, \n "+
				 "        decode(c.rent_l_cd,'','-',decode(nvl(c.dly_amt,0),0,'종료','진행')) end_yn, c.use_e_dt, decode(a.car_gu,'0','(재)','') car_gu_nm, \n"+
				 "        decode(b.rent_start_dt,'',decode(cr.init_reg_dt,'미등록','','차량등록'),'신차개시') start_yn, \n"+
				 "        decode(nvl(b.rent_start_dt,replace(replace(decode(a.car_gu,0,a.rent_dt,3,a.rent_dt,cr.init_reg_dt),'미등록',''),'-','')),'',0,trunc(months_between(sysdate, to_date(nvl(b.rent_start_dt,replace(replace(decode(a.car_gu,0,a.rent_dt,3,a.rent_dt,cr.init_reg_dt),'미등록',''),'-','')),'YYYYMMDD')),0)) use_mon \n"+
				 " from   cont_n_view a, fee b, car_reg cr,  \n"+
				 "        (select rent_mng_id, rent_l_cd, sum(decode(rc_yn,'1',0,fee_s_amt)) dly_amt, count(0) pay_cnt, max(use_e_dt) use_e_dt from scd_fee where nvl(bill_yn,'Y')='Y' and rent_st='1' and tm_st2<>'2' and tm_st1='0' group by rent_mng_id, rent_l_cd) c, \n"+
			     "        cont_etc d, (SELECT * FROM (SELECT rent_mng_id, rent_l_cd, '20'||REPLACE(SUBSTR(cng_dt, 0,10),'/','') as cng_dt, rank() over(partition BY rent_mng_id, rent_l_cd ORDER BY cng_dt desc) AS ranks  FROM SCD_FEE_CNG  )  WHERE ranks = '1') g, \n"+
				 "        fee_rm e, fee_etc f "+
				 " where  b.fee_s_amt >0  and a.car_st in ('4') "+
				 "        and b.rent_st='1' "+
				 "        and nvl(b.fee_chk,'0')='0' "+	//매월납입
				 "        and a.rent_mng_id=b.rent_mng_id \n"+
				 "        and a.rent_mng_id=c.rent_mng_id(+) \n"+
				 "        and (b.con_mon-nvl(b.pere_r_mth,0))>0"+ //개시대여료가 총개월수랑 같을 경우 제외
				 "        and a.car_mng_id is not null and a.car_mng_id = cr.car_mng_id(+) \n"+	//차량연결분
				 "        and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+) AND a.rent_mng_id=g.rent_mng_id(+) AND a.rent_l_cd=g.rent_l_cd(+) "+
				 "        and b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd and b.rent_st=e.rent_st "+		
				 "        and b.rent_mng_id=f.rent_mng_id and b.rent_l_cd=f.rent_l_cd and b.rent_st=f.rent_st "+						  
//				 "	      and b.rent_dt >= nvl(d.rent_suc_dt,b.rent_dt) "+	
				 " ";

		if(!t_wd.equals("")){
			query2 += " and a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd(+)";	
		}else{
			query2 += " and nvl(a.use_yn,'Y')='Y' ";					
		}

		query3 = " select  "+
				 "        '연장('||to_char(to_number(b.rent_st)-1)||')' gubun, g.cng_dt, a.bus_id, a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.r_site, a.use_yn, a.rent_dt, \n"+
				 "        a.firm_nm, nvl(cr.car_no,'미등록') car_no, cr.init_reg_dt, cr.car_nm, a.rent_st as cont_st, b.rent_st, \n"+
				 "        b.rent_start_dt, b.rent_end_dt, b.con_mon, f.con_day, \n"+
				 "        decode(c.rent_l_cd,'','미등록','등록') reg_yn, nvl(c.pay_cnt,0), c.dly_amt, \n "+
				 "        decode(c.rent_l_cd,'','-',decode(nvl(c.dly_amt,0),0,'종료','진행')) end_yn, c.use_e_dt, decode(a.car_gu,'0','(재)','') car_gu_nm, '' start_yn,\n"+
				 "        decode(nvl(b.rent_start_dt,replace(replace(cr.init_reg_dt,'미등록',''),'-','')),'',0,trunc(months_between(sysdate, to_date(nvl(b.rent_start_dt,replace(replace(cr.init_reg_dt,'미등록',''),'-','')),'YYYYMMDD')),0)) use_mon \n"+
				 " from   cont_n_view a, fee b, car_reg cr, \n "+
				 "        (select rent_mng_id, rent_l_cd, rent_st, sum(decode(rc_yn,'1',0,fee_s_amt)) dly_amt, count(0) pay_cnt, max(use_e_dt) use_e_dt from scd_fee where nvl(bill_yn,'Y')='Y' and rent_st<>'1' and tm_st2<>'2' and tm_st1='0' group by rent_mng_id, rent_l_cd, rent_st) c, \n"+
				 "        cont_etc d, (SELECT * FROM (SELECT rent_mng_id, rent_l_cd, '20'||REPLACE(SUBSTR(cng_dt, 0,10),'/','') as cng_dt, rank() over(partition BY rent_mng_id, rent_l_cd ORDER BY cng_dt desc) AS ranks  FROM SCD_FEE_CNG  )  WHERE ranks = '1') g, \n"+
				 "        fee_rm e, fee_etc f"+
				 " where  b.fee_s_amt >0 and a.car_st in ('4') and nvl(a.use_yn,'Y')='Y' and b.rent_st<>'1' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n "+
				 "        and b.rent_mng_id=c.rent_mng_id(+) and b.rent_l_cd=c.rent_l_cd(+) and b.rent_st=c.rent_st(+) \n "+
				 "        and b.rent_l_cd||b.rent_st not in ('B106HRTR001522','S107HB4L000812','S107HB4L000813','S107HTGR001421','S107HTGR001422') \n"+ //게약승계 미이관분
				 "        and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+) "+
				 "	      AND a.rent_mng_id=g.rent_mng_id(+) AND a.rent_l_cd=g.rent_l_cd(+) "+
				 "	      and a.car_mng_id = cr.car_mng_id(+) "+
				 "        and (b.con_mon-nvl(b.pere_r_mth,0))>0"+ //개시대여료가 총개월수랑 같을 경우 제외
				 "        and nvl(b.fee_chk,'0')='0'"+	//매월납입
				 "	      and b.rent_dt >= nvl(d.rent_suc_dt,b.rent_dt) "+	
				 "        and b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd and b.rent_st=e.rent_st "+		
				 "        and b.rent_mng_id=f.rent_mng_id and b.rent_l_cd=f.rent_l_cd and b.rent_st=f.rent_st "+						  
				 " ";
		
		query = " select * from ( "+query2+" union all "+query3+" )";


		if(t_wd.equals("")){


			if(gubun4.equals("3"))	query = " select * from ( "+query2+" )";
			if(gubun4.equals("4"))	query = " select * from ( "+query3+" )";

			if(gubun3.equals("1"))	query += " where nvl(use_yn,'Y')='Y'";
			if(gubun3.equals("2"))	query += " where reg_yn='등록'";
			if(gubun3.equals("3"))	query += " where reg_yn='미등록' and nvl(use_yn,'Y')='Y'";

			if(gubun3.equals("4") && gubun2.equals("1")){
				query += " where cng_dt is not null and rent_start_dt like to_char(sysdate,'YYYYMM')||'%' ";
			}else if(gubun3.equals("4") && gubun2.equals("2")){ 
				query += " where cng_dt is not NULL and rent_start_dt = to_char(sysdate,'YYYYMMDD') ";
			}else if(gubun3.equals("4") && gubun2.equals("3")){	
				query += " where cng_dt is not null and cng_dt BETWEEN replace('"+st_dt+"','-','') AND replace('"+end_dt+"','-','')";
			}
						
			if(gubun3.equals("1")||gubun3.equals("2")||gubun3.equals("3")){
				if(gubun2.equals("1"))	query += " and rent_start_dt like to_char(sysdate,'YYYYMM')||'%'";
				if(gubun2.equals("2"))	query += " and rent_start_dt = to_char(sysdate,'YYYYMMDD')";
				if(gubun2.equals("3"))	query += " and rent_start_dt BETWEEN replace('"+st_dt+"','-','') AND replace('"+end_dt+"','-','')";
			}


		}else{

			/*검색조건*/			
			if(s_kd.equals("1"))		query += " where nvl(firm_nm, '') like '%"+t_wd+"%'\n";
			else if(s_kd.equals("2"))	query += " where upper(rent_l_cd) like upper('%"+t_wd+"%')\n";
			else if(s_kd.equals("3"))	query += " where nvl(car_no, '') like '%"+t_wd+"%'\n";

		}

		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		/*정렬조건*/

		if(sort_gubun.equals("0"))		query += " order by nvl(use_yn,'Y') desc, decode(gubun,'지연','1','신차','2','연장','3'), decode(gubun,'지연',rent_dt,'99999999'), nvl(rent_start_dt, '00000000') "+sort+", init_reg_dt, rent_dt";
		else if(sort_gubun.equals("1"))	query += " order by nvl(use_yn,'Y') desc, firm_nm "+sort;
		else if(sort_gubun.equals("2"))	query += " order by nvl(use_yn,'Y') desc, car_no "+sort;
		else if(sort_gubun.equals("3"))	query += " and cng_dt BETWEEN replace('"+st_dt+"','-','') AND replace('"+end_dt+"','-','') order by cng_dt "+sort;

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
			System.out.println("[AddFeeDatabase:getFeeScdListRmAll]\n"+e);
			System.out.println("[AddFeeDatabase:getFeeScdListRmAll]\n"+query);
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
	 *	대여료 스케줄 관리 - con_fee/fee_search_in.jsp
	 */
	public Vector getFeeSearchListAll(String s_kd, String t_wd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.rent_mng_id, a.rent_l_cd, f.rent_st, b.firm_nm, c.car_mng_id, c.car_no, c.car_nm, d.rent_start_dt, d.con_mon, (f.fee_s_amt+f.fee_v_amt) fee_amt, a.use_yn \n"+
				" from   cont a, client b, car_reg c, fee f,\n"+
				"        (select rent_l_cd, min(rent_start_dt) rent_start_dt, max(rent_end_dt) rent_end_dt, sum(con_mon) con_mon, max(to_number(rent_st)) rent_st  from fee group by rent_l_cd) d \n"+
				" ";

		query += " where a.client_id=b.client_id  \n"+
				" and a.car_mng_id=c.car_mng_id\n"+
				" and a.rent_l_cd=f.rent_l_cd\n"+				
				" and f.rent_l_cd=d.rent_l_cd\n"+
				" and f.rent_st=d.rent_st";

		if(!t_wd.equals("")){
			/*검색조건*/			
			if(s_kd.equals("1"))		query += " and nvl(b.firm_nm, '') like '%"+t_wd+"%'\n";
			else if(s_kd.equals("2"))	query += " and upper(a.rent_l_cd) like upper('%"+t_wd+"%')\n";
			else if(s_kd.equals("3"))	query += " and nvl(c.car_no, '') like '%"+t_wd+"%'\n";
		}


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
			System.out.println("[AddFeeDatabase:getFeeSearchListAll]\n"+e);
			System.out.println("[AddFeeDatabase:getFeeSearchListAll]\n"+query);
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
	 *	대여료 스케줄 리스트 통계 - con_fee/fee_sc.jsp	
	 *
	 *	입금예정일 : E(0:당일이전, 1:당일, 2:예정)--> 단순하게 입금예정일과 당일 비교
	 *	수금일 : R(0:당일이전, 1:당일, 2:예정) --> 단순하게 수금일과 당일 비교
	 *	연체구분 : D(1:연체, 0:연체아님) 	--> 수금인경우 수금일 > 입금예정일, 미수금인경우 현재날짜 > 입금예정일
	 *	선수구분 : F(1:선수, 0:선수아님)	--> 수금인경우 수금일 < 입금예정일
	 *	수금상태 : RC_YN(0:미수, 1: 수금)	--> Y/N로 표시
	 */
	public Vector getFeeStat2(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String sub_query = " select fee_s_amt, fee_v_amt, r_fee_est_dt, rc_yn, rc_dt from fee_view where ";

		/*상세조회&&세부조회*/

		//당월-계획
		if(gubun2.equals("1") && gubun3.equals("1")){		sub_query += " fee_est_dt like to_char(sysdate,'YYYYMM')||'%'";
		//당월-수금
		}else if(gubun2.equals("1") && gubun3.equals("2")){	sub_query += " fee_est_dt like to_char(sysdate,'YYYYMM')||'%' and rc_yn='1'";
		//당월-미수금
		}else if(gubun2.equals("1") && gubun3.equals("3")){	sub_query += " fee_est_dt like to_char(sysdate,'YYYYMM')||'%' and rc_yn='0'";
		//당일-계획
		}else if(gubun2.equals("2") && gubun3.equals("1")){	sub_query += " r_fee_est_dt = to_char(sysdate,'YYYYMMDD')";
		//당일-수금
		}else if(gubun2.equals("2") && gubun3.equals("2")){	sub_query += " r_fee_est_dt = to_char(sysdate,'YYYYMMDD') and rc_dt=to_char(sysdate,'YYYYMMDD')";
		//당일-미수금
		}else if(gubun2.equals("2") && gubun3.equals("3")){	sub_query += " r_fee_est_dt = to_char(sysdate,'YYYYMMDD') and rc_yn='0'";
		//연체-계획
		}else if(gubun2.equals("3") && gubun3.equals("1")){	sub_query += " r_fee_est_dt < to_char(sysdate,'YYYYMMDD') and (rc_yn='0' or rc_dt=to_char(sysdate,'YYYYMMDD'))";
		//연체-수금
		}else if(gubun2.equals("3") && gubun3.equals("2")){	sub_query += " r_fee_est_dt < to_char(sysdate,'YYYYMMDD') and rc_dt=to_char(SYSDATE, 'YYYY-MM-DD')";
		//연체-미수금
		}else if(gubun2.equals("3") && gubun3.equals("3")){	sub_query += " r_fee_est_dt < to_char(sysdate,'YYYYMMDD') and rc_yn='0'";
		//기간-계획
		}else if(gubun2.equals("4") && gubun3.equals("1")){	sub_query += " fee_est_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		//기간-수금
		}else if(gubun2.equals("4") && gubun3.equals("2")){	sub_query += " fee_est_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and rc_yn='1'";
		//기간-미수금
		}else if(gubun2.equals("4") && gubun3.equals("3")){	sub_query += " fee_est_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and rc_yn='0'";
		//당일+연체-계획
		}else if(gubun2.equals("6") && gubun3.equals("1")){	sub_query += " r_fee_est_dt <= to_char(sysdate,'YYYYMMDD') and (rc_yn='0' or rc_dt=to_char(sysdate,'YYYYMMDD'))";
		//당일+연체-수금
		}else if(gubun2.equals("6") && gubun3.equals("2")){	sub_query += " (r_fee_est_dt <= to_char(sysdate,'YYYYMMDD') or r_fee_est_dt > to_char(sysdate,'YYYYMMDD'))  and rc_dt=to_char(sysdate,'YYYYMMDD')";
		//당일+연체-미수금
		}else if(gubun2.equals("6") && gubun3.equals("3")){	sub_query += " r_fee_est_dt <= to_char(sysdate,'YYYYMMDD') and rc_yn='0'";
		//검색
		}else{ 
			sub_query += " FEE_TM = min_fee_tm";
		}

		if(gubun2.equals("3")){
			if(gubun4.equals("2")){	//일반연체		
				sub_query += " and dly_day between 1 and 30";
			}else if(gubun4.equals("3")){ //부실연체
				sub_query += " and dly_day between 31 and 60";
			}else if(gubun4.equals("4")){ //악성연체
				sub_query += " and dly_day between 61 and 1000";
			}else{}
		}

		if(!br_id.equals("S1"))		sub_query += " and brch_id='"+br_id+"'";

		/*검색조건*/
			
		if(s_kd.equals("2"))		sub_query += " and nvl(client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	sub_query += " and upper(rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	sub_query += " and nvl(car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("5"))	sub_query += " and fee_amt like '%"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	sub_query += " and upper(brch_id) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("7"))	sub_query += " and nvl(R_SITE, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("8"))	sub_query += " and BUS_ID2= '"+t_wd+"'\n";
		else if(s_kd.equals("9"))	sub_query += " and nvl(CAR_NM, '') like '%"+t_wd+"%'\n";
		else						sub_query += " and nvl(firm_nm, '') like '%"+t_wd+"%'\n";			

		String compar_dt = "to_char(sysdate,'YYYYMMDD')";
		String compar_mon = "to_char(sysdate,'YYYYMM')";
		if(gubun2.equals("4") && st_dt.equals(end_dt))
		{
			compar_dt = "'"+AddUtil.ChangeString(st_dt)+"'";
			compar_mon = "'"+compar_dt.substring(1,7)+"'";
		}

		String query = "";

		query = " select '계획' gubun, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(0) tot_su1, nvl(sum(fee_s_amt+fee_v_amt),0) tot_amt1 from ("+sub_query+") where r_fee_est_dt like "+compar_mon+"||'%' ) a,\n"+
					" ( select count(0) tot_su2, nvl(sum(fee_s_amt+fee_v_amt),0) tot_amt2 from ("+sub_query+") where r_fee_est_dt = "+compar_dt+" ) b,\n"+	
					" ( select count(0) tot_su3, nvl(sum(fee_s_amt+fee_v_amt),0) tot_amt3 from ("+sub_query+") where r_fee_est_dt < "+compar_dt+" and (rc_yn='0' or rc_dt = "+compar_dt+") ) c\n"+
				" union all\n"+
				" select '수금' gubun, a.*, b.*, c.*\n"+
				" from\n"+
					" ( select count(0) tot_su1, nvl(sum(fee_s_amt+fee_v_amt),0) tot_amt1 from ("+sub_query+") where r_fee_est_dt like "+compar_mon+"||'%' and rc_yn='1' ) a,\n"+
					" ( select count(0) tot_su2, nvl(sum(fee_s_amt+fee_v_amt),0) tot_amt2 from ("+sub_query+") where r_fee_est_dt = "+compar_dt+" and (rc_yn = '1' or rc_dt = "+compar_dt+") ) b,\n"+	
					" ( select count(0) tot_su3, nvl(sum(fee_s_amt+fee_v_amt),0) tot_amt3 from ("+sub_query+") where r_fee_est_dt < "+compar_dt+" and rc_dt = "+compar_dt+" ) c\n"+
				" union all\n"+
				" select '미수금' gubun, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(0) tot_su1, nvl(sum(fee_s_amt+fee_v_amt),0) tot_amt1 from ("+sub_query+") where r_fee_est_dt like "+compar_mon+"||'%' and rc_yn='0' ) a,\n"+
					" ( select count(0) tot_su2, nvl(sum(fee_s_amt+fee_v_amt),0) tot_amt2 from ("+sub_query+") where r_fee_est_dt = "+compar_dt+" and rc_yn = '0' ) b,\n"+	
					" ( select count(0) tot_su3, nvl(sum(fee_s_amt+fee_v_amt),0) tot_amt3 from ("+sub_query+") where r_fee_est_dt < "+compar_dt+" and rc_yn = '0' ) c\n"+
				" union all\n"+
				" select '비율' gubun, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select decode(a.tot_su1, 0,0, to_number(to_char((b.tot_su1/a.tot_su1)*100, 999.99))) tot_su1, decode(a.tot_amt1, 0,0, to_number(to_char((b.tot_amt1/a.tot_amt1)*100, 999.99))) tot_amt1 from\n"+ 
						" ( select count(0) tot_su1, nvl(sum(fee_s_amt+fee_v_amt),0) tot_amt1 from ("+sub_query+") where r_fee_est_dt like "+compar_mon+"||'%' ) a,\n"+
						" ( select count(0) tot_su1, nvl(sum(fee_s_amt+fee_v_amt),0) tot_amt1 from ("+sub_query+") where r_fee_est_dt like "+compar_mon+"||'%' and rc_yn='1' ) b\n"+
					" ) a,\n"+
					" ( select decode(a.tot_su2, 0,0, to_number(to_char((b.tot_su2/a.tot_su2)*100, 999.99))) tot_su2, decode(a.tot_amt2, 0,0, to_number(to_char((b.tot_amt2/a.tot_amt2)*100, 999.99))) tot_amt2 from\n"+ 
						" ( select count(0) tot_su2, nvl(sum(fee_s_amt+fee_v_amt),0) tot_amt2 from ("+sub_query+") where r_fee_est_dt = "+compar_dt+" ) a,\n"+	
						" ( select count(0) tot_su2, nvl(sum(fee_s_amt+fee_v_amt),0) tot_amt2 from ("+sub_query+") where r_fee_est_dt = "+compar_dt+" and rc_dt = "+compar_dt+" ) b\n"+	
					" ) b,\n"+
					" ( select decode(a.tot_su3, 0,0, to_number(to_char((b.tot_su3/a.tot_su3)*100, 999.99))) tot_su3, decode(a.tot_amt3, 0,0, to_number(to_char((b.tot_amt3/a.tot_amt3)*100, 999.99))) tot_amt3 from\n"+ 
						" ( select count(0) tot_su3, nvl(sum(fee_s_amt+fee_v_amt),0) tot_amt3 from ("+sub_query+") where r_fee_est_dt < "+compar_dt+" and (rc_yn='0' or rc_dt = "+compar_dt+") ) a,\n"+
						" ( select count(0) tot_su3, nvl(sum(fee_s_amt+fee_v_amt),0) tot_amt3 from ("+sub_query+") where r_fee_est_dt < "+compar_dt+" and rc_dt = "+compar_dt+" ) b\n"+
					" ) c";
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			
			while(rs.next())
			{
				IncomingBean fee = new IncomingBean();
				fee.setGubun(rs.getString(1));
				fee.setTot_su1(rs.getInt(2));
				fee.setTot_amt1(rs.getInt(3));
				fee.setTot_su2(rs.getInt(4));
				fee.setTot_amt2(rs.getInt(5));
				fee.setTot_su3(rs.getInt(6));
				fee.setTot_amt3(rs.getInt(7));
				vt.add(fee);
			}
			rs.close();
			pstmt.close();
			
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getFeeStat2]\n"+e);
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
	 *	회차 연장 : 한회차 대여료 insert /con_fee/ext_scd_i_a.jsp 
	 *
	 *  20071123 수정
	 */
	public boolean insertFeeScdAdd(FeeScdBean fee_scd)
	{
		getConnection();
		boolean flag = true;
		String query = "";
		query = " insert into SCD_FEE (RENT_MNG_ID, RENT_L_CD, FEE_TM, RENT_ST, TM_ST1,"+
				" TM_ST2, FEE_EST_DT, FEE_S_AMT, FEE_V_AMT, RC_YN,"+
				" RC_DT, RC_AMT, DLY_DAYS, DLY_FEE, PAY_CNG_DT,"+
				" PAY_CNG_CAU, R_FEE_EST_DT, UPDATE_DT, UPDATE_ID, BILL_YN,"+
				" USE_S_DT, USE_E_DT, REQ_DT, R_REQ_DT, TAX_OUT_DT, RENT_SEQ ) values ("+
				" ?, ?, ?, ?, ?,"+
				" ?, replace(?, '-', ''), ?, ?, ?,"+
				" replace(?, '-', ''), ?, ?, ?, replace(?, '-', ''),"+
				" ?, replace(?, '-', ''), to_char(sysdate,'YYYYMMDD'), ?, ?,"+
				" replace(?, '-', ''), replace(?, '-', ''), replace(?, '-', ''), replace(?, '-', ''), replace(?, '-', ''), ?)";

		PreparedStatement pstmt = null;
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, fee_scd.getRent_mng_id());
			pstmt.setString(2, fee_scd.getRent_l_cd());
			pstmt.setString(3, fee_scd.getFee_tm());
			pstmt.setString(4, fee_scd.getRent_st());
			pstmt.setString(5, fee_scd.getTm_st1());
			pstmt.setString(6, fee_scd.getTm_st2());
			pstmt.setString(7, fee_scd.getFee_est_dt());
			pstmt.setInt   (8, fee_scd.getFee_s_amt());
			pstmt.setInt   (9, fee_scd.getFee_v_amt());
			pstmt.setString(10, fee_scd.getRc_yn());
			pstmt.setString(11, fee_scd.getRc_dt());
			pstmt.setInt   (12, fee_scd.getRc_amt());
			pstmt.setString(13, fee_scd.getDly_days());
			pstmt.setInt   (14, fee_scd.getDly_fee());
			pstmt.setString(15, fee_scd.getPay_cng_dt());
			pstmt.setString(16, fee_scd.getPay_cng_cau());
			pstmt.setString(17, fee_scd.getR_fee_est_dt());
			pstmt.setString(18, fee_scd.getUpdate_id());
			pstmt.setString(19, fee_scd.getBill_yn());
			pstmt.setString(20, fee_scd.getUse_s_dt());
			pstmt.setString(21, fee_scd.getUse_e_dt());
			pstmt.setString(22, fee_scd.getReq_dt());
			pstmt.setString(23, fee_scd.getR_req_dt());
			pstmt.setString(24, fee_scd.getTax_out_dt());
			pstmt.setString(25, fee_scd.getRent_seq());
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
	  		System.out.println("[AddFeeDatabase:insertFeeScdAdd]\n"+e);
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
	 *	계약수정에서 대여스케줄 등록선택시 : 한회차 대여료 insert
	 */
	public boolean insertFeeScd(FeeScdBean fee_scd)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
		query = " insert into SCD_FEE (RENT_MNG_ID, RENT_L_CD, FEE_TM, RENT_ST, TM_ST1,"+
				" TM_ST2, FEE_EST_DT, FEE_S_AMT, FEE_V_AMT, RC_YN,"+
				" RC_DT, RC_AMT, DLY_DAYS, DLY_FEE, PAY_CNG_DT,"+
				" PAY_CNG_CAU, R_FEE_EST_DT, TAE_NO, BILL_YN, UPDATE_DT,"+
				" UPDATE_ID, USE_S_DT, USE_E_DT, REQ_DT, R_REQ_DT,"+
				" TAX_OUT_DT, RENT_SEQ, PAY_ST, cng_dt, cng_id, etc, taecha_no) values ("+// 
				" ?, ?, ?, ?, ?,"+
				" ?, replace(?, '-', ''), ?, ?, ?,"+
				" replace(?, '-', ''), ?, ?, ?, replace(?, '-', ''),"+
				" ?, replace(?, '-', ''), ?, nvl(?,'Y'), to_char(sysdate,'YYYYMMDD'),"+
				" ?,"+
				" replace(?, '-', ''), replace(?, '-', ''), replace(?, '-', ''), replace(?, '-', ''), replace(?, '-', ''), ?, ?, to_char(sysdate,'YYYYMMDD'), ?, ?, ? "+//
				" )";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, fee_scd.getRent_mng_id()		);
			pstmt.setString(2, fee_scd.getRent_l_cd()		);
			pstmt.setString(3, fee_scd.getFee_tm()			);
			pstmt.setString(4, fee_scd.getRent_st()			);
			pstmt.setString(5, fee_scd.getTm_st1()			);
			pstmt.setString(6, fee_scd.getTm_st2()			);
			pstmt.setString(7, fee_scd.getFee_est_dt()		);
			pstmt.setInt   (8, fee_scd.getFee_s_amt()		);
			pstmt.setInt   (9, fee_scd.getFee_v_amt()		);
			pstmt.setString(10, fee_scd.getRc_yn()			);
			pstmt.setString(11, fee_scd.getRc_dt()			);
			pstmt.setInt   (12, fee_scd.getRc_amt()			);
			pstmt.setString(13, fee_scd.getDly_days()		);
			pstmt.setInt   (14, fee_scd.getDly_fee()		);
			pstmt.setString(15, fee_scd.getPay_cng_dt()		);
			pstmt.setString(16, fee_scd.getPay_cng_cau()	);
			pstmt.setString(17, fee_scd.getR_fee_est_dt()	);
			pstmt.setString(18, fee_scd.getTae_no()			);
			pstmt.setString(19, fee_scd.getBill_yn()		);
			pstmt.setString(20, fee_scd.getUpdate_id()		);
			pstmt.setString(21, fee_scd.getUse_s_dt()		);
			pstmt.setString(22, fee_scd.getUse_e_dt()		);
			pstmt.setString(23, fee_scd.getReq_dt()			);
			pstmt.setString(24, fee_scd.getR_req_dt()		);
			pstmt.setString(25, fee_scd.getTax_out_dt()		);
			pstmt.setString(26, fee_scd.getRent_seq()		);
			pstmt.setString(27, fee_scd.getPay_st()			);
			pstmt.setString(28, fee_scd.getUpdate_id()		);
			pstmt.setString(29, fee_scd.getEtc()			);
			pstmt.setString(30, fee_scd.getTaecha_no()			);

			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[AddFeeDatabase:insertFeeScd]\n"+e);
			System.out.println("[AddFeeDatabase:fee_scd.getRent_mng_id()	]\n"+fee_scd.getRent_mng_id()	);
			System.out.println("[AddFeeDatabase:fee_scd.getRent_l_cd()		]\n"+fee_scd.getRent_l_cd()		);
			System.out.println("[AddFeeDatabase:fee_scd.getFee_tm()		]\n"+fee_scd.getFee_tm()		);
			System.out.println("[AddFeeDatabase:fee_scd.getRent_st()		]\n"+fee_scd.getRent_st()		);
			System.out.println("[AddFeeDatabase:fee_scd.getTm_st1()		]\n"+fee_scd.getTm_st1()		);
			System.out.println("[AddFeeDatabase:fee_scd.getTm_st2()		]\n"+fee_scd.getTm_st2()		);
			System.out.println("[AddFeeDatabase:fee_scd.getFee_est_dt()	]\n"+fee_scd.getFee_est_dt()	);
			System.out.println("[AddFeeDatabase:fee_scd.getFee_s_amt()		]\n"+fee_scd.getFee_s_amt()		);
			System.out.println("[AddFeeDatabase:fee_scd.getFee_v_amt()		]\n"+fee_scd.getFee_v_amt()		);
			System.out.println("[AddFeeDatabase:fee_scd.getRc_yn()			]\n"+fee_scd.getRc_yn()			);
			System.out.println("[AddFeeDatabase:fee_scd.getRc_dt()			]\n"+fee_scd.getRc_dt()			);
			System.out.println("[AddFeeDatabase:fee_scd.getRc_amt()		]\n"+fee_scd.getRc_amt()		);
			System.out.println("[AddFeeDatabase:fee_scd.getDly_days()		]\n"+fee_scd.getDly_days()		);
			System.out.println("[AddFeeDatabase:fee_scd.getDly_fee()		]\n"+fee_scd.getDly_fee()		);
			System.out.println("[AddFeeDatabase:fee_scd.getPay_cng_dt()	]\n"+fee_scd.getPay_cng_dt()	);
			System.out.println("[AddFeeDatabase:fee_scd.getPay_cng_cau()	]\n"+fee_scd.getPay_cng_cau()	);
			System.out.println("[AddFeeDatabase:fee_scd.getR_fee_est_dt()	]\n"+fee_scd.getR_fee_est_dt()	);
			System.out.println("[AddFeeDatabase:fee_scd.getTae_no()		]\n"+fee_scd.getTae_no()		);
			System.out.println("[AddFeeDatabase:fee_scd.getUpdate_id()		]\n"+fee_scd.getUpdate_id()		);
			System.out.println("[AddFeeDatabase:fee_scd.getUse_s_dt()		]\n"+fee_scd.getUse_s_dt()		);
			System.out.println("[AddFeeDatabase:fee_scd.getUse_e_dt()		]\n"+fee_scd.getUse_e_dt()		);
			System.out.println("[AddFeeDatabase:fee_scd.getReq_dt()		]\n"+fee_scd.getReq_dt()		);
			System.out.println("[AddFeeDatabase:fee_scd.getR_req_dt()		]\n"+fee_scd.getR_req_dt()		);
			System.out.println("[AddFeeDatabase:fee_scd.getTax_out_dt()	]\n"+fee_scd.getTax_out_dt()	);
			System.out.println("[AddFeeDatabase:fee_scd.getRent_seq()		]\n"+fee_scd.getRent_seq()		);
			System.out.println("[AddFeeDatabase:fee_scd.getPay_st()		]\n"+fee_scd.getPay_st()		);

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
	 *	대여스케줄 변경이력 등록
	 */
	public boolean insertFeeScdCng(FeeScdCngBean scd_cng)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
		query = " insert into SCD_FEE_CNG (RENT_MNG_ID, RENT_L_CD, FEE_TM, ALL_ST, GUBUN,"+
				" B_VALUE, A_VALUE, CNG_DT, CNG_CAU, CNG_ID )"+
				" values ("+
				" ?, ?, ?, ?, ?,"+
				" ?, ?, sysdate, ?, ?)";
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, scd_cng.getRent_mng_id()	);
			pstmt.setString(2, scd_cng.getRent_l_cd()	);
			pstmt.setString(3, scd_cng.getFee_tm()		);
			pstmt.setString(4, scd_cng.getAll_st()		);
			pstmt.setString(5, scd_cng.getGubun()		);
			pstmt.setString(6, scd_cng.getB_value()		);
			pstmt.setString(7, scd_cng.getA_value()		);
			pstmt.setString(8, scd_cng.getCng_cau()		);
			pstmt.setString(9, scd_cng.getCng_id()		);

			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[AddFeeDatabase:insertFeeScdCng]\n"+e);

			System.out.println("[scd_cng.getRent_mng_id()	]\n"+scd_cng.getRent_mng_id()	);
			System.out.println("[scd_cng.getRent_l_cd()		]\n"+scd_cng.getRent_l_cd()		);
			System.out.println("[scd_cng.getFee_tm()		]\n"+scd_cng.getFee_tm()		);
			System.out.println("[scd_cng.getAll_st()		]\n"+scd_cng.getAll_st()		);
			System.out.println("[scd_cng.getGubun()			]\n"+scd_cng.getGubun()			);
			System.out.println("[scd_cng.getB_value()		]\n"+scd_cng.getB_value()		);
			System.out.println("[scd_cng.getA_value()		]\n"+scd_cng.getA_value()		);
			System.out.println("[scd_cng.getCng_cau()		]\n"+scd_cng.getCng_cau()		);
			System.out.println("[scd_cng.getCng_id()		]\n"+scd_cng.getCng_id()		);

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
	 *	대여료메모 insert
	 *	해당 고객 관련 계약 전체 insert (관련 계약 코드를 query해온 후, 가장 최근의 연체미수 라인에 메모를 추가한다)
	 */
	public boolean insertFeeMemoAll(FeeMemoBean fee_mm)
	{
		getConnection();
		boolean flag = true;
		Statement stmt = null;
		ResultSet rs = null;
		String query = "";
		query = " SELECT B.rent_mng_id, B.rent_l_cd, B.rent_st, B.fee_tm, B.tm_st1"+
				" FROM"+
				" ("+
					" SELECT C.rent_mng_id, C.rent_l_cd, F.rent_st"+
					" FROM CONT C, FEE F, CLIENT L"+
					" WHERE C.rent_mng_id = F.rent_mng_id AND"+
					" C.rent_l_cd = F.rent_l_cd AND"+
					" C.client_id = L.client_id AND"+
					" L.client_id = "+
					" ("+
						" SELECT client_id FROM CONT WHERE rent_mng_id='"+fee_mm.getRent_mng_id()+"' and rent_l_cd='"+fee_mm.getRent_l_cd()+"'"+
					" )"+
				" )A,"+
				" ("+	/* 회차: minimun값, 회차 안의 잔액회차: maximum값 */
					" SELECT rent_mng_id, rent_l_cd, rent_st, MIN(fee_tm) fee_tm, MAX(tm_st1) tm_st1"+
					" FROM SCD_FEE"+
					" WHERE NVL(TO_NUMBER(dly_days), 0) > 0"+
					" AND rc_yn='0' "+
					" and rent_mng_id != '"+fee_mm.getRent_mng_id()+"'"+
					" and rent_l_cd != '"+fee_mm.getRent_l_cd()+"'"+
					" GROUP BY rent_mng_id, rent_l_cd, rent_st"+
				" )B "+
				" WHERE A.rent_mng_id = B.rent_mng_id AND"+
				" A.rent_l_cd = B.rent_l_cd AND"+
				" A.rent_st = B.rent_st";
		try
		{						
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);		    
			while(rs.next())
			{
				fee_mm.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_mm.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_mm.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_mm.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_mm.setTm_st1(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				insertFeeMemo_IN(fee_mm);
			}
			rs.close();
			stmt.close();

	  	} catch (Exception e) {
			System.out.println("[AddFeeDatabase:insertFeeMemoAll]\n"+e);
			e.printStackTrace();
	  		flag = false;
		} finally {
			try{	
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}	
	
	/**
	 *	대여료 메모 INSERT (내부메소드)
	 */
	private boolean insertFeeMemo_IN(FeeMemoBean fee_mm)
	{
		boolean flag = true;
		Statement stmt = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String s_seq = "";
		String query_id = " select nvl(ltrim(to_char(to_number(MAX(seq))+1, '000000')), '000001') ID from dly_mm";

		String query =  " insert into dly_mm ("+
						" RENT_MNG_ID, RENT_L_CD, RENT_ST, TM_ST1, SEQ, FEE_TM, REG_ID, REG_DT, CONTENT, SPEAKER, REG_DT_TIME)"+
						" values ( ?, ?, ?, ?, ?, ?, ?, replace(?, '-', ''), ?, ?, ?)";
		try {
			conn.setAutoCommit(false);

			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query_id);
			if(rs.next())
			{
				s_seq = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			stmt.close();

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, fee_mm.getRent_mng_id());
			pstmt.setString(2, fee_mm.getRent_l_cd());
			pstmt.setString(3, fee_mm.getRent_st());
			pstmt.setString(4, fee_mm.getTm_st1());
			pstmt.setString(5, s_seq);
			pstmt.setString(6, fee_mm.getFee_tm());
			pstmt.setString(7, fee_mm.getReg_id());
			pstmt.setString(8, fee_mm.getReg_dt());
			pstmt.setString(9, fee_mm.getContent());
			pstmt.setString(10, fee_mm.getSpeaker());
			pstmt.setString(11, s_seq);
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddFeeDatabase:insertFeeMemo_IN]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
                if(pstmt != null) pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			return flag;
		}
	}	
	
	/**	
	 *	대여료메모 insert
	 */
	public boolean insertFeeMemo(FeeMemoBean fee_mm)
	{
		getConnection();
		boolean flag = true;
		Statement stmt = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String s_seq = "";
		String query_id = " select nvl(ltrim(to_char(to_number(MAX(seq))+1, '000000')), '000001') ID from dly_mm";

		String query =  " insert into dly_mm ("+
						" RENT_MNG_ID, RENT_L_CD, RENT_ST, TM_ST1, SEQ, FEE_TM, REG_ID, REG_DT, CONTENT, SPEAKER, REG_DT_TIME, promise_dt, mm_st)"+
						" values ( ?, ?, ?, ?, ?, ?, ?, replace(?, '-', ''), ?, ?, to_char(sysdate, 'hh24miss') , replace(?, '-', ''), ?)";
		try {
			conn.setAutoCommit(false);

			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query_id);
			if(rs.next())
			{
				s_seq = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			stmt.close();

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, fee_mm.getRent_mng_id());
			pstmt.setString(2, fee_mm.getRent_l_cd());
			pstmt.setString(3, fee_mm.getRent_st());
			pstmt.setString(4, fee_mm.getTm_st1());
			pstmt.setString(5, s_seq);
			pstmt.setString(6, fee_mm.getFee_tm());
			pstmt.setString(7, fee_mm.getReg_id());
			pstmt.setString(8, fee_mm.getReg_dt());
			pstmt.setString(9, fee_mm.getContent());
			pstmt.setString(10, fee_mm.getSpeaker());
	//		if(fee_mm.getReg_dt_time().equals("")){
	//			pstmt.setString(11, s_seq);
	//		}else{
	//			pstmt.setString(11, fee_mm.getReg_dt_time());
	//		}
			pstmt.setString(11, fee_mm.getPromise_dt());
			pstmt.setString(12, fee_mm.getMm_st2());
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddFeeDatabase:insertFeeMemo]\n"+e);
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
                if(pstmt != null) pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}	

	/**	
	 *	연체료 수금스케줄 등록
	 */
	public boolean insertFeeDlyScd(FeeDlyScdBean fee_scd)
	{
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

		query = " insert into SCD_DLY (RENT_MNG_ID, RENT_L_CD, SEQ, PAY_DT, PAY_AMT, REG_ID, REG_DT, ETC, INCOM_DT, INCOM_SEQ )"+
				" values (?, ?, ?, replace(?, '-', ''), ?, ?, to_char(sysdate,'YYYYMMDD'), ?, replace(?, '-', ''), ? )";

		String query_seq = "";
		query_seq = " select nvl(to_char(max(to_number(seq))+1),'1') seq from scd_dly where rent_mng_id=? ";//and rent_l_cd=?

		//입력체크
		String query2 = "select count(0) from SCD_DLY where rent_mng_id=? and SEQ=?";//and rent_l_cd=? 

		try 
		{
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query_seq);
			pstmt1.setString(1, fee_scd.getRent_mng_id());
//			pstmt1.setString(2, fee_scd.getRent_l_cd());
		    rs = pstmt1.executeQuery();
			if(rs.next()){
				seq = rs.getString(1);
			}
			rs.close();
			pstmt1.close();


			pstmt3 = conn.prepareStatement(query2);
			pstmt3.setString(1, fee_scd.getRent_mng_id());
//			pstmt3.setString(2, fee_scd.getRent_l_cd());
			pstmt3.setString(2, seq);
	    	rs2 = pstmt3.executeQuery();
			if(rs2.next()){
				chk = rs2.getInt(1);	
			}
			rs2.close();
			pstmt3.close();

			if(chk==0){
				pstmt2 = conn.prepareStatement(query);
				pstmt2.setString(1, fee_scd.getRent_mng_id());
				pstmt2.setString(2, fee_scd.getRent_l_cd());
				pstmt2.setString(3, seq);
				pstmt2.setString(4, fee_scd.getPay_dt());
				pstmt2.setInt(5, fee_scd.getPay_amt());
				pstmt2.setString(6, fee_scd.getReg_id());
				pstmt2.setString(7, fee_scd.getEtc());
				pstmt2.setString(8, fee_scd.getIncom_dt());
				pstmt2.setInt(9, fee_scd.getIncom_seq());
				pstmt2.executeUpdate();
				pstmt2.close();
			}

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddFeeDatabase:insertFeeDlyScd]\n"+e);
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
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	/**	
	 *	연체료 수금스케줄 수정
	 */
	public boolean updateFeeDlyScd(FeeDlyScdBean fee_scd)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
		query = " update SCD_DLY set PAY_DT=replace(?, '-', ''), PAY_AMT=?, ETC=?, REG_DT=to_char(sysdate,'YYYYMMDD'), REG_ID=?"+
				" where rent_mng_id=? and rent_l_cd=? and seq=?";
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, fee_scd.getPay_dt());
			pstmt.setInt(2, fee_scd.getPay_amt());
			pstmt.setString(3, fee_scd.getEtc());
			pstmt.setString(4, fee_scd.getReg_id());
			pstmt.setString(5, fee_scd.getRent_mng_id());
			pstmt.setString(6, fee_scd.getRent_l_cd());
			pstmt.setString(7, fee_scd.getSeq());
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddFeeDatabase:updateFeeDlyScd]\n"+e);
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
	 *	한회차 대여료 update
	 */
	public boolean updateFeeScd(FeeScdBean fee_scd)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = " update scd_fee set "+
						" TM_ST2 = ?, "+
						" FEE_EST_DT = replace(?, '-', ''), "+
						" FEE_S_AMT = ?, "+
						" FEE_V_AMT = ?, "+
						" RC_YN = ?, "+
						" RC_DT = replace(?, '-', ''), "+
						" RC_AMT = ?, "+
						" DLY_DAYS = ?, "+
						" DLY_FEE = ?, "+
						" PAY_CNG_DT = replace(?, '-', ''), "+
						" PAY_CNG_CAU = ?, "+
						" R_FEE_EST_DT = replace(?, '-', ''), "+
						" EXT_DT = replace(?, '-', ''),"+
						" UPDATE_DT = to_char(sysdate,'YYYYMMDD'),"+
						" UPDATE_ID = ?,"+
						" REQ_DT = replace(?, '-', ''), "+
						" R_REQ_DT = replace(?, '-', ''), "+
						" TAX_OUT_DT = replace(?, '-', ''), "+
						" USE_S_DT = replace(?, '-', ''), "+
						" USE_E_DT = replace(?, '-', ''), "+
						" ADATE = replace(?, '-', ''), "+
						" INCOM_DT = replace(?, '-', ''), "+
						" INCOM_SEQ = ?, "+
						" etc = ? "+ 
						" where "+
						" RENT_MNG_ID = ? and"+
						" RENT_L_CD = ? and"+
						" FEE_TM = ? and"+
						" RENT_ST = ? and"+
						" RENT_SEQ = ? and"+
						" TM_ST1 = ? and TM_ST2 = ? ";
		
		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1 , fee_scd.getTm_st2());
			pstmt.setString(2 , fee_scd.getFee_est_dt());
			pstmt.setInt(3 , fee_scd.getFee_s_amt());
			pstmt.setInt(4 , fee_scd.getFee_v_amt());
			pstmt.setString(5 , fee_scd.getRc_yn());
			pstmt.setString(6 , fee_scd.getRc_dt());
			pstmt.setInt(7 , fee_scd.getRc_amt());
			pstmt.setString(8 , fee_scd.getDly_days());
			pstmt.setInt(9 , fee_scd.getDly_fee());
			pstmt.setString(10, fee_scd.getPay_cng_dt());
			pstmt.setString(11, fee_scd.getPay_cng_cau());
			pstmt.setString(12, fee_scd.getR_fee_est_dt());
			pstmt.setString(13, fee_scd.getExt_dt());
			pstmt.setString(14, fee_scd.getUpdate_id());

			pstmt.setString(15, fee_scd.getReq_dt());
			pstmt.setString(16, fee_scd.getR_req_dt());
			pstmt.setString(17, fee_scd.getTax_out_dt());
			pstmt.setString(18, fee_scd.getUse_s_dt());
			pstmt.setString(19, fee_scd.getUse_e_dt());
			pstmt.setString(20, fee_scd.getAdate());
			
			pstmt.setString(21, fee_scd.getIncom_dt());
			pstmt.setInt(22,    fee_scd.getIncom_seq());
			pstmt.setString(23, fee_scd.getEtc());

			pstmt.setString(24, fee_scd.getRent_mng_id());
			pstmt.setString(25, fee_scd.getRent_l_cd());
			pstmt.setString(26, fee_scd.getFee_tm());
			pstmt.setString(27, fee_scd.getRent_st());
			pstmt.setString(28, fee_scd.getRent_seq());
			pstmt.setString(29, fee_scd.getTm_st1());
			pstmt.setString(30, fee_scd.getTm_st2());
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
				
	  	} catch (Exception e) {
			System.out.println("[AddFeeDatabase:updateFeeScd]\n"+e);
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
	 *	한회차 대여료 update  -- 재계약
	 */
	public boolean updateFeeScd(FeeScdBean fee_scd, String old_rent_l_cd)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = " update scd_fee set"+
						" rent_mng_id=?,"+
						" rent_l_cd=?,"+
						" TM_ST2 = ?, "+
						" FEE_EST_DT = replace(?, '-', ''),"+
						" FEE_S_AMT = ?,"+
						" FEE_V_AMT = ?,"+
						" RC_YN = ?, "+
						" RC_DT = replace(?, '-', ''),"+
						" RC_AMT = ?,"+
						" DLY_DAYS = ?,"+
						" DLY_FEE = ?,"+
						" PAY_CNG_DT = replace(?, '-', ''),"+
						" PAY_CNG_CAU = ?,"+
						" R_FEE_EST_DT = replace(?, '-', '')"+
						" where"+
						" RENT_MNG_ID = ? and"+
						" RENT_L_CD = ? and"+
						" FEE_TM = ? and"+
						" RENT_ST = ? and"+
						" TM_ST1 = ? ";	
		try {
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1 , fee_scd.getRent_mng_id());
			pstmt.setString(2 , fee_scd.getRent_l_cd());
			pstmt.setString(3 , fee_scd.getTm_st2());
			pstmt.setString(4 , fee_scd.getFee_est_dt());
			pstmt.setInt   (5 , fee_scd.getFee_s_amt());
			pstmt.setInt   (6 , fee_scd.getFee_v_amt());
			pstmt.setString(7 , fee_scd.getRc_yn());
			pstmt.setString(8 , fee_scd.getRc_dt());
			pstmt.setInt   (9 , fee_scd.getRc_amt());
			pstmt.setString(10 , fee_scd.getDly_days());
			pstmt.setInt   (11 , fee_scd.getDly_fee());
			pstmt.setString(12, fee_scd.getPay_cng_dt());
			pstmt.setString(13, fee_scd.getPay_cng_cau());
			pstmt.setString(14, fee_scd.getR_fee_est_dt());
			pstmt.setString(15, fee_scd.getRent_mng_id());
			pstmt.setString(16, old_rent_l_cd);
			pstmt.setString(17, fee_scd.getFee_tm());
			pstmt.setString(18, fee_scd.getRent_st());
			pstmt.setString(19, fee_scd.getTm_st1());
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[AddFeeDatabase:updateFeeScd]\n"+e);
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
	 *	연장회차 삭제 : 한회차 대여료 delete /con_fee/ext_scd_i_a.jsp
	 */
	public boolean dropFeeScd(String m_id, String l_cd, String r_st, String fee_tm, String tm_st1)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;

		String query1 = " delete from scd_fee"+
						" where RENT_MNG_ID=? and RENT_L_CD=? and RENT_ST=?and FEE_TM=? and TM_ST1=?";

		String query2 = " update scd_fee set fee_tm=fee_tm-1"+
						" where RENT_MNG_ID=? and RENT_L_CD=? and FEE_TM>?";
		try {
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query1);
			pstmt1.setString(1 , m_id);
			pstmt1.setString(2 , l_cd);
			pstmt1.setString(3 , r_st);
			pstmt1.setString(4 , fee_tm);
			pstmt1.setString(5 , tm_st1);
			pstmt1.executeUpdate();
			pstmt1.close();
		    
			pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString(1 , m_id);
			pstmt2.setString(2 , l_cd);
			pstmt2.setString(3 , fee_tm);
			pstmt2.executeUpdate();
			pstmt2.close();

			conn.commit();

		} catch (Exception e) {
			System.out.println("[AddFeeDatabase:dropFeeScd]\n"+e);
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt1 != null)	pstmt1.close();
				if(pstmt2 != null)	pstmt2.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
		
	/**
	 *	한회차 대여료 쿼리(한 라인)
	 */
	public FeeScdBean getScd(String m_id, String r_st, String fee_tm, String tm_st1)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		FeeScdBean fee_scd = new FeeScdBean();
		String query = "";
		query = " select RENT_MNG_ID, RENT_L_CD, FEE_TM, RENT_ST, TM_ST1, TM_ST2,"+
				" decode(fee_est_dt, '','', substr(FEE_EST_DT, 1, 4) || '-' || substr(FEE_EST_DT, 5, 2) || '-'||substr(FEE_EST_DT, 7, 2)) FEE_EST_DT,"+
				" FEE_S_AMT, FEE_V_AMT, RC_YN,"+
				" decode(RC_DT, '', '', substr(RC_DT, 1, 4) || '-' || substr(RC_DT, 5, 2) || '-'||substr(RC_DT, 7, 2)) RC_DT,"+
				" RC_AMT, DLY_DAYS, DLY_FEE,"+
				" decode(PAY_CNG_DT, '', '', substr(PAY_CNG_DT, 1, 4) || '-' || substr(PAY_CNG_DT, 5, 2) || '-'||substr(PAY_CNG_DT, 7, 2)) PAY_CNG_DT,"+
				" PAY_CNG_CAU,"+
				" substr(R_FEE_EST_DT, 1, 4) || '-' || substr(R_FEE_EST_DT, 5, 2) || '-'||substr(R_FEE_EST_DT, 7, 2) R_FEE_EST_DT,"+
				" bill_yn, dly_chk, req_dt, r_req_dt, tax_out_dt, use_s_dt, use_e_dt, rent_seq, adate, pay_st, incom_dt, incom_seq "+
				" from scd_fee"+
				" where RENT_MNG_ID = '"+m_id+"'"+
				" and RENT_ST = '"+r_st+"'"+
				" and FEE_TM = '"+fee_tm+"'"+
				" and TM_ST1 = '"+tm_st1+"'";
		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			while(rs.next())
			{
				fee_scd.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_scd.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_scd.setRent_seq(rs.getString("RENT_SEQ")==null?"":rs.getString("RENT_SEQ"));
				fee_scd.setTm_st1(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				fee_scd.setTm_st2(rs.getString("TM_ST2")==null?"":rs.getString("TM_ST2"));
				fee_scd.setFee_est_dt(rs.getString("FEE_EST_DT")==null?"":rs.getString("FEE_EST_DT"));
				fee_scd.setFee_s_amt(rs.getString("FEE_S_AMT")==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee_scd.setFee_v_amt(rs.getString("FEE_V_AMT")==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee_scd.setRc_yn(rs.getString("RC_YN")==null?"":rs.getString("RC_YN"));
				fee_scd.setRc_dt(rs.getString("RC_DT")==null?"":rs.getString("RC_DT"));
				fee_scd.setRc_amt(rs.getString("RC_AMT")==null?0:Integer.parseInt(rs.getString("RC_AMT")));
				fee_scd.setDly_days(rs.getString("DLY_DAYS")==null?"":rs.getString("DLY_DAYS"));
				fee_scd.setDly_fee(rs.getString("DLY_FEE")==null?0:Integer.parseInt(rs.getString("DLY_FEE")));
				fee_scd.setPay_cng_dt(rs.getString("PAY_CNG_DT")==null?"":rs.getString("PAY_CNG_DT"));
				fee_scd.setPay_cng_cau(rs.getString("PAY_CNG_CAU")==null?"":rs.getString("PAY_CNG_CAU"));
				fee_scd.setR_fee_est_dt(rs.getString("R_FEE_EST_DT")==null?"":rs.getString("R_FEE_EST_DT"));
				fee_scd.setBill_yn(rs.getString("bill_yn"));
				fee_scd.setDly_chk(rs.getString("dly_chk"));
				fee_scd.setReq_dt(rs.getString("req_dt"));
				fee_scd.setR_req_dt(rs.getString("r_req_dt"));
				fee_scd.setTax_out_dt(rs.getString("tax_out_dt"));
				fee_scd.setUse_s_dt(rs.getString("use_s_dt"));
				fee_scd.setUse_e_dt(rs.getString("use_e_dt"));
				fee_scd.setAdate(rs.getString("adate")==null?"":rs.getString("adate"));
				fee_scd.setPay_st(rs.getString("pay_st")==null?"":rs.getString("pay_st"));
				fee_scd.setIncom_dt(rs.getString("incom_dt")==null?"":rs.getString("incom_dt"));
				fee_scd.setIncom_seq(rs.getString("incom_seq")==null?0:Integer.parseInt(rs.getString("incom_seq")));
			}
			rs.close();
			stmt.close();

		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getScd]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return fee_scd;
		}				
	}

	/**
	 *	한회차 대여료 쿼리(한 라인)
	 */
	public FeeScdBean getScd(String m_id, String l_cd, String r_st, String fee_tm, String tm_st1)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		FeeScdBean fee_scd = new FeeScdBean();
		String query = "";
		query = " select RENT_MNG_ID, RENT_L_CD, FEE_TM, RENT_ST, TM_ST1, TM_ST2, RENT_SEQ,"+
				" decode(fee_est_dt, '','', substr(FEE_EST_DT, 1, 4) || '-' || substr(FEE_EST_DT, 5, 2) || '-'||substr(FEE_EST_DT, 7, 2)) FEE_EST_DT,"+
				" FEE_S_AMT, FEE_V_AMT, RC_YN,"+
				" decode(RC_DT, '', '', substr(RC_DT, 1, 4) || '-' || substr(RC_DT, 5, 2) || '-'||substr(RC_DT, 7, 2)) RC_DT,"+
				" RC_AMT, DLY_DAYS, DLY_FEE,"+
				" decode(PAY_CNG_DT, '', '', substr(PAY_CNG_DT, 1, 4) || '-' || substr(PAY_CNG_DT, 5, 2) || '-'||substr(PAY_CNG_DT, 7, 2)) PAY_CNG_DT,"+
				" PAY_CNG_CAU,"+
				" substr(R_FEE_EST_DT, 1, 4) || '-' || substr(R_FEE_EST_DT, 5, 2) || '-'||substr(R_FEE_EST_DT, 7, 2) R_FEE_EST_DT,"+
				" substr(REQ_DT, 1, 4) || '-' || substr(REQ_DT, 5, 2) || '-'||substr(REQ_DT, 7, 2) REQ_DT,"+
				" substr(R_REQ_DT, 1, 4) || '-' || substr(R_REQ_DT, 5, 2) || '-'||substr(R_REQ_DT, 7, 2) R_REQ_DT,"+
				" substr(TAX_OUT_DT, 1, 4) || '-' || substr(TAX_OUT_DT, 5, 2) || '-'||substr(TAX_OUT_DT, 7, 2) TAX_OUT_DT,"+
				" substr(USE_S_DT, 1, 4) || '-' || substr(USE_S_DT, 5, 2) || '-'||substr(USE_S_DT, 7, 2) USE_S_DT,"+
				" substr(USE_E_DT, 1, 4) || '-' || substr(USE_E_DT, 5, 2) || '-'||substr(USE_E_DT, 7, 2) USE_E_DT, adate, pay_st, incom_dt, incom_seq "+
				" from scd_fee"+
				" where RENT_MNG_ID = '"+m_id+"'"+
				" and RENT_L_CD = '"+l_cd+"'"+
				" and RENT_ST = '"+r_st+"'"+
				" and FEE_TM = '"+fee_tm+"'"+
				" and TM_ST1 = '"+tm_st1+"'";
		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			while(rs.next())
			{
				fee_scd.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_scd.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_scd.setRent_seq(rs.getString("RENT_SEQ")==null?"":rs.getString("RENT_SEQ"));
				fee_scd.setTm_st1(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				fee_scd.setTm_st2(rs.getString("TM_ST2")==null?"":rs.getString("TM_ST2"));
				fee_scd.setFee_est_dt(rs.getString("FEE_EST_DT")==null?"":rs.getString("FEE_EST_DT"));
				fee_scd.setFee_s_amt(rs.getString("FEE_S_AMT")==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee_scd.setFee_v_amt(rs.getString("FEE_V_AMT")==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee_scd.setRc_yn(rs.getString("RC_YN")==null?"":rs.getString("RC_YN"));
				fee_scd.setRc_dt(rs.getString("RC_DT")==null?"":rs.getString("RC_DT"));
				fee_scd.setRc_amt(rs.getString("RC_AMT")==null?0:Integer.parseInt(rs.getString("RC_AMT")));
				fee_scd.setDly_days(rs.getString("DLY_DAYS")==null?"":rs.getString("DLY_DAYS"));
				fee_scd.setDly_fee(rs.getString("DLY_FEE")==null?0:Integer.parseInt(rs.getString("DLY_FEE")));
				fee_scd.setPay_cng_dt(rs.getString("PAY_CNG_DT")==null?"":rs.getString("PAY_CNG_DT"));
				fee_scd.setPay_cng_cau(rs.getString("PAY_CNG_CAU")==null?"":rs.getString("PAY_CNG_CAU"));
				fee_scd.setR_fee_est_dt(rs.getString("R_FEE_EST_DT")==null?"":rs.getString("R_FEE_EST_DT"));
				fee_scd.setReq_dt(rs.getString("REQ_DT")==null?"":rs.getString("REQ_DT"));
				fee_scd.setR_req_dt(rs.getString("R_REQ_DT")==null?"":rs.getString("R_REQ_DT"));
				fee_scd.setTax_out_dt(rs.getString("TAX_OUT_DT")==null?"":rs.getString("TAX_OUT_DT"));
				fee_scd.setUse_s_dt(rs.getString("USE_S_DT")==null?"":rs.getString("USE_S_DT"));
				fee_scd.setUse_e_dt(rs.getString("USE_E_DT")==null?"":rs.getString("USE_E_DT"));
				fee_scd.setAdate(rs.getString("adate")==null?"":rs.getString("adate"));
				fee_scd.setPay_st(rs.getString("pay_st")==null?"":rs.getString("pay_st"));
				fee_scd.setIncom_dt(rs.getString("incom_dt")==null?"":rs.getString("incom_dt"));
				fee_scd.setIncom_seq(rs.getString("incom_seq")==null?0:Integer.parseInt(rs.getString("incom_seq")));
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getScd]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return fee_scd;
		}				
	}

	/**
	 *	한회차 대여료 쿼리(한 라인)
	 */
	public FeeScdBean getScd(String m_id, String l_cd, String r_st, String fee_tm, String tm_st1, String bill_yn)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		FeeScdBean fee_scd = new FeeScdBean();
		String query = "";
		query = " select RENT_MNG_ID, RENT_L_CD, FEE_TM, RENT_ST, TM_ST1, TM_ST2, RENT_SEQ,"+
				" decode(fee_est_dt, '','', substr(FEE_EST_DT, 1, 4) || '-' || substr(FEE_EST_DT, 5, 2) || '-'||substr(FEE_EST_DT, 7, 2)) FEE_EST_DT,"+
				" FEE_S_AMT, FEE_V_AMT, RC_YN,"+
				" decode(RC_DT, '', '', substr(RC_DT, 1, 4) || '-' || substr(RC_DT, 5, 2) || '-'||substr(RC_DT, 7, 2)) RC_DT,"+
				" RC_AMT, DLY_DAYS, DLY_FEE,"+
				" decode(PAY_CNG_DT, '', '', substr(PAY_CNG_DT, 1, 4) || '-' || substr(PAY_CNG_DT, 5, 2) || '-'||substr(PAY_CNG_DT, 7, 2)) PAY_CNG_DT,"+
				" PAY_CNG_CAU,"+
				" substr(R_FEE_EST_DT, 1, 4) || '-' || substr(R_FEE_EST_DT, 5, 2) || '-'||substr(R_FEE_EST_DT, 7, 2) R_FEE_EST_DT,"+
				" substr(REQ_DT, 1, 4) || '-' || substr(REQ_DT, 5, 2) || '-'||substr(REQ_DT, 7, 2) REQ_DT,"+
				" substr(R_REQ_DT, 1, 4) || '-' || substr(R_REQ_DT, 5, 2) || '-'||substr(R_REQ_DT, 7, 2) R_REQ_DT,"+
				" substr(TAX_OUT_DT, 1, 4) || '-' || substr(TAX_OUT_DT, 5, 2) || '-'||substr(TAX_OUT_DT, 7, 2) TAX_OUT_DT,"+
				" substr(USE_S_DT, 1, 4) || '-' || substr(USE_S_DT, 5, 2) || '-'||substr(USE_S_DT, 7, 2) USE_S_DT,"+
				" substr(USE_E_DT, 1, 4) || '-' || substr(USE_E_DT, 5, 2) || '-'||substr(USE_E_DT, 7, 2) USE_E_DT, adate, pay_st, incom_dt, incom_seq "+
				" from scd_fee"+
				" where RENT_MNG_ID = '"+m_id+"'"+
				" and RENT_L_CD = '"+l_cd+"'"+
				" and RENT_ST = '"+r_st+"'"+
				" and FEE_TM = '"+fee_tm+"'"+
				" and TM_ST1 = '"+tm_st1+"'";

		if(bill_yn.equals(""))	query += " and nvl(bill_yn,'Y')='"+bill_yn+"'";

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			while(rs.next())
			{
				fee_scd.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_scd.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_scd.setRent_seq(rs.getString("RENT_SEQ")==null?"":rs.getString("RENT_SEQ"));
				fee_scd.setTm_st1(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				fee_scd.setTm_st2(rs.getString("TM_ST2")==null?"":rs.getString("TM_ST2"));
				fee_scd.setFee_est_dt(rs.getString("FEE_EST_DT")==null?"":rs.getString("FEE_EST_DT"));
				fee_scd.setFee_s_amt(rs.getString("FEE_S_AMT")==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee_scd.setFee_v_amt(rs.getString("FEE_V_AMT")==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee_scd.setRc_yn(rs.getString("RC_YN")==null?"":rs.getString("RC_YN"));
				fee_scd.setRc_dt(rs.getString("RC_DT")==null?"":rs.getString("RC_DT"));
				fee_scd.setRc_amt(rs.getString("RC_AMT")==null?0:Integer.parseInt(rs.getString("RC_AMT")));
				fee_scd.setDly_days(rs.getString("DLY_DAYS")==null?"":rs.getString("DLY_DAYS"));
				fee_scd.setDly_fee(rs.getString("DLY_FEE")==null?0:Integer.parseInt(rs.getString("DLY_FEE")));
				fee_scd.setPay_cng_dt(rs.getString("PAY_CNG_DT")==null?"":rs.getString("PAY_CNG_DT"));
				fee_scd.setPay_cng_cau(rs.getString("PAY_CNG_CAU")==null?"":rs.getString("PAY_CNG_CAU"));
				fee_scd.setR_fee_est_dt(rs.getString("R_FEE_EST_DT")==null?"":rs.getString("R_FEE_EST_DT"));
				fee_scd.setReq_dt(rs.getString("REQ_DT")==null?"":rs.getString("REQ_DT"));
				fee_scd.setR_req_dt(rs.getString("R_REQ_DT")==null?"":rs.getString("R_REQ_DT"));
				fee_scd.setTax_out_dt(rs.getString("TAX_OUT_DT")==null?"":rs.getString("TAX_OUT_DT"));
				fee_scd.setUse_s_dt(rs.getString("USE_S_DT")==null?"":rs.getString("USE_S_DT"));
				fee_scd.setUse_e_dt(rs.getString("USE_E_DT")==null?"":rs.getString("USE_E_DT"));
				fee_scd.setAdate(rs.getString("adate")==null?"":rs.getString("adate"));
				fee_scd.setPay_st(rs.getString("pay_st")==null?"":rs.getString("pay_st"));
				fee_scd.setIncom_dt(rs.getString("incom_dt")==null?"":rs.getString("incom_dt"));
				fee_scd.setIncom_seq(rs.getString("incom_seq")==null?0:Integer.parseInt(rs.getString("incom_seq")));
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getScd]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return fee_scd;
		}				
	}

	/**
	 *	한회차 대여료 쿼리(한 라인) : 수금스케줄에서
	 */
	public FeeScdBean getScd2(String m_id, String l_cd, String rent_st, String fee_tm)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		FeeScdBean fee_scd = new FeeScdBean();

		if(rent_st.equals("")) rent_st = "1";

		String query = "";
		query = " select RENT_MNG_ID, RENT_L_CD, FEE_TM, RENT_ST, TM_ST1, TM_ST2, RENT_SEQ,"+
				" decode(fee_est_dt, '','', substr(FEE_EST_DT, 1, 4) || '-' || substr(FEE_EST_DT, 5, 2) || '-'||substr(FEE_EST_DT, 7, 2)) FEE_EST_DT,"+
				" FEE_S_AMT, FEE_V_AMT, RC_YN,"+
				" decode(RC_DT, '', '', substr(RC_DT, 1, 4) || '-' || substr(RC_DT, 5, 2) || '-'||substr(RC_DT, 7, 2)) RC_DT,"+
				" RC_AMT, DLY_DAYS, DLY_FEE,"+
				" decode(PAY_CNG_DT, '', '', substr(PAY_CNG_DT, 1, 4) || '-' || substr(PAY_CNG_DT, 5, 2) || '-'||substr(PAY_CNG_DT, 7, 2)) PAY_CNG_DT,"+
				" PAY_CNG_CAU,"+
				" substr(R_FEE_EST_DT, 1, 4) || '-' || substr(R_FEE_EST_DT, 5, 2) || '-'||substr(R_FEE_EST_DT, 7, 2) R_FEE_EST_DT,"+
				" substr(REQ_DT, 1, 4) || '-' || substr(REQ_DT, 5, 2) || '-'||substr(REQ_DT, 7, 2) REQ_DT,"+
				" substr(R_REQ_DT, 1, 4) || '-' || substr(R_REQ_DT, 5, 2) || '-'||substr(R_REQ_DT, 7, 2) R_REQ_DT,"+
				" substr(TAX_OUT_DT, 1, 4) || '-' || substr(TAX_OUT_DT, 5, 2) || '-'||substr(TAX_OUT_DT, 7, 2) TAX_OUT_DT,"+
				" substr(USE_S_DT, 1, 4) || '-' || substr(USE_S_DT, 5, 2) || '-'||substr(USE_S_DT, 7, 2) USE_S_DT,"+
				" substr(USE_E_DT, 1, 4) || '-' || substr(USE_E_DT, 5, 2) || '-'||substr(USE_E_DT, 7, 2) USE_E_DT, adate, pay_st, incom_dt, incom_seq "+
				" from scd_fee"+
				" where RENT_MNG_ID = '"+m_id+"' and RENT_L_CD = '"+l_cd+"'"+
				" and RENT_ST = '"+rent_st+"'"+
				" and FEE_TM = '"+fee_tm+"'";

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			while(rs.next())
			{
				fee_scd.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_scd.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_scd.setRent_seq(rs.getString("RENT_SEQ")==null?"":rs.getString("RENT_SEQ"));
				fee_scd.setTm_st1(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				fee_scd.setTm_st2(rs.getString("TM_ST2")==null?"":rs.getString("TM_ST2"));
				fee_scd.setFee_est_dt(rs.getString("FEE_EST_DT")==null?"":rs.getString("FEE_EST_DT"));
				fee_scd.setFee_s_amt(rs.getString("FEE_S_AMT")==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee_scd.setFee_v_amt(rs.getString("FEE_V_AMT")==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee_scd.setRc_yn(rs.getString("RC_YN")==null?"":rs.getString("RC_YN"));
				fee_scd.setRc_dt(rs.getString("RC_DT")==null?"":rs.getString("RC_DT"));
				fee_scd.setRc_amt(rs.getString("RC_AMT")==null?0:Integer.parseInt(rs.getString("RC_AMT")));
				fee_scd.setDly_days(rs.getString("DLY_DAYS")==null?"":rs.getString("DLY_DAYS"));
				fee_scd.setDly_fee(rs.getString("DLY_FEE")==null?0:Integer.parseInt(rs.getString("DLY_FEE")));
				fee_scd.setPay_cng_dt(rs.getString("PAY_CNG_DT")==null?"":rs.getString("PAY_CNG_DT"));
				fee_scd.setPay_cng_cau(rs.getString("PAY_CNG_CAU")==null?"":rs.getString("PAY_CNG_CAU"));
				fee_scd.setR_fee_est_dt(rs.getString("R_FEE_EST_DT")==null?"":rs.getString("R_FEE_EST_DT"));
				fee_scd.setReq_dt(rs.getString("REQ_DT")==null?"":rs.getString("REQ_DT"));
				fee_scd.setR_req_dt(rs.getString("R_REQ_DT")==null?"":rs.getString("R_REQ_DT"));
				fee_scd.setTax_out_dt(rs.getString("TAX_OUT_DT")==null?"":rs.getString("TAX_OUT_DT"));
				fee_scd.setUse_s_dt(rs.getString("USE_S_DT")==null?"":rs.getString("USE_S_DT"));
				fee_scd.setUse_e_dt(rs.getString("USE_E_DT")==null?"":rs.getString("USE_E_DT"));
				fee_scd.setAdate(rs.getString("adate")==null?"":rs.getString("adate"));
				fee_scd.setPay_st(rs.getString("pay_st")==null?"":rs.getString("pay_st"));
				fee_scd.setIncom_dt(rs.getString("incom_dt")==null?"":rs.getString("incom_dt"));
				fee_scd.setIncom_seq(rs.getString("incom_seq")==null?0:Integer.parseInt(rs.getString("incom_seq")));

			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getScd]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return fee_scd;
		}				
	}

	/**
	 *	한회차 대여료 쿼리(한 라인) : 수금스케줄에서
	 */
	public FeeScdBean getScd2(String m_id, String l_cd, String rent_st, String fee_tm, String tm_st1)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		FeeScdBean fee_scd = new FeeScdBean();
		String query = "";
		query = " select RENT_MNG_ID, RENT_L_CD, FEE_TM, RENT_ST, TM_ST1, TM_ST2, RENT_SEQ,"+
				" decode(fee_est_dt, '','', substr(FEE_EST_DT, 1, 4) || '-' || substr(FEE_EST_DT, 5, 2) || '-'||substr(FEE_EST_DT, 7, 2)) FEE_EST_DT,"+
				" FEE_S_AMT, FEE_V_AMT, RC_YN,"+
				" decode(RC_DT, '', '', substr(RC_DT, 1, 4) || '-' || substr(RC_DT, 5, 2) || '-'||substr(RC_DT, 7, 2)) RC_DT,"+
				" RC_AMT, DLY_DAYS, DLY_FEE,"+
				" decode(PAY_CNG_DT, '', '', substr(PAY_CNG_DT, 1, 4) || '-' || substr(PAY_CNG_DT, 5, 2) || '-'||substr(PAY_CNG_DT, 7, 2)) PAY_CNG_DT,"+
				" PAY_CNG_CAU,"+
				" substr(R_FEE_EST_DT, 1, 4) || '-' || substr(R_FEE_EST_DT, 5, 2) || '-'||substr(R_FEE_EST_DT, 7, 2) R_FEE_EST_DT,"+
				" substr(REQ_DT, 1, 4) || '-' || substr(REQ_DT, 5, 2) || '-'||substr(REQ_DT, 7, 2) REQ_DT,"+
				" substr(R_REQ_DT, 1, 4) || '-' || substr(R_REQ_DT, 5, 2) || '-'||substr(R_REQ_DT, 7, 2) R_REQ_DT,"+
				" substr(TAX_OUT_DT, 1, 4) || '-' || substr(TAX_OUT_DT, 5, 2) || '-'||substr(TAX_OUT_DT, 7, 2) TAX_OUT_DT,"+
				" substr(USE_S_DT, 1, 4) || '-' || substr(USE_S_DT, 5, 2) || '-'||substr(USE_S_DT, 7, 2) USE_S_DT,"+
				" substr(USE_E_DT, 1, 4) || '-' || substr(USE_E_DT, 5, 2) || '-'||substr(USE_E_DT, 7, 2) USE_E_DT, adate, pay_st, incom_dt, incom_seq "+
				" from scd_fee"+
				" where RENT_MNG_ID = '"+m_id+"' and rent_l_cd='"+l_cd+"'"+
				" and RENT_ST = '"+rent_st+"'"+
				" and FEE_TM = '"+fee_tm+"'"+
				" and tm_st1 = '"+tm_st1+"'";

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			while(rs.next())
			{
				fee_scd.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_scd.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_scd.setRent_seq(rs.getString("RENT_SEQ")==null?"":rs.getString("RENT_SEQ"));
				fee_scd.setTm_st1(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				fee_scd.setTm_st2(rs.getString("TM_ST2")==null?"":rs.getString("TM_ST2"));
				fee_scd.setFee_est_dt(rs.getString("FEE_EST_DT")==null?"":rs.getString("FEE_EST_DT"));
				fee_scd.setFee_s_amt(rs.getString("FEE_S_AMT")==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee_scd.setFee_v_amt(rs.getString("FEE_V_AMT")==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee_scd.setRc_yn(rs.getString("RC_YN")==null?"":rs.getString("RC_YN"));
				fee_scd.setRc_dt(rs.getString("RC_DT")==null?"":rs.getString("RC_DT"));
				fee_scd.setRc_amt(rs.getString("RC_AMT")==null?0:Integer.parseInt(rs.getString("RC_AMT")));
				fee_scd.setDly_days(rs.getString("DLY_DAYS")==null?"":rs.getString("DLY_DAYS"));
				fee_scd.setDly_fee(rs.getString("DLY_FEE")==null?0:Integer.parseInt(rs.getString("DLY_FEE")));
				fee_scd.setPay_cng_dt(rs.getString("PAY_CNG_DT")==null?"":rs.getString("PAY_CNG_DT"));
				fee_scd.setPay_cng_cau(rs.getString("PAY_CNG_CAU")==null?"":rs.getString("PAY_CNG_CAU"));
				fee_scd.setR_fee_est_dt(rs.getString("R_FEE_EST_DT")==null?"":rs.getString("R_FEE_EST_DT"));
				fee_scd.setReq_dt(rs.getString("REQ_DT")==null?"":rs.getString("REQ_DT"));
				fee_scd.setR_req_dt(rs.getString("R_REQ_DT")==null?"":rs.getString("R_REQ_DT"));
				fee_scd.setTax_out_dt(rs.getString("TAX_OUT_DT")==null?"":rs.getString("TAX_OUT_DT"));
				fee_scd.setUse_s_dt(rs.getString("USE_S_DT")==null?"":rs.getString("USE_S_DT"));
				fee_scd.setUse_e_dt(rs.getString("USE_E_DT")==null?"":rs.getString("USE_E_DT"));
				fee_scd.setAdate(rs.getString("adate")==null?"":rs.getString("adate"));
				fee_scd.setPay_st(rs.getString("pay_st")==null?"":rs.getString("pay_st"));
				fee_scd.setIncom_dt(rs.getString("incom_dt")==null?"":rs.getString("incom_dt"));
				fee_scd.setIncom_seq(rs.getString("incom_seq")==null?0:Integer.parseInt(rs.getString("incom_seq")));

			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getScd]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return fee_scd;
		}				
	}

	
	/**
	 *	입금변경을 위한 쿼리(한회에 속한 대여료 및 잔액 모두 포함 or 해당회차 이후의 모든 대여료 및 잔액 리턴)
	 *  gubun - ONE : 해당 회차에 속한 대여료 및 잔액만 리턴, ALL : 해당회차를 포함해 그 이후의 모든 대여료 및 잔액을 리턴
	 */
	public Vector getScdGroup(String m_id, String fee_tm, String gubun)
	{
		getConnection();
		Vector vt = new Vector();
		Statement stmt = null;
		ResultSet rs = null;
		String query = "";
		query = " select"+
				" RENT_MNG_ID, RENT_L_CD, FEE_TM, RENT_ST, TM_ST1, TM_ST2, RENT_SEQ,"+
				" substr(FEE_EST_DT, 1, 4) || '-' || substr(FEE_EST_DT, 5, 2) || '-'||substr(FEE_EST_DT, 7, 2) FEE_EST_DT,"+
				" FEE_S_AMT, FEE_V_AMT, RC_YN,"+
				" substr(RC_DT, 1, 4) || '-' || substr(RC_DT, 5, 2) || '-'||substr(RC_DT, 7, 2) RC_DT,"+
				" RC_AMT, DLY_DAYS, DLY_FEE,"+
				" substr(PAY_CNG_DT, 1, 4) || '-' || substr(PAY_CNG_DT, 5, 2) || '-'||substr(PAY_CNG_DT, 7, 2) PAY_CNG_DT,"+
				" PAY_CNG_CAU,"+
				" substr(R_FEE_EST_DT, 1, 4) || '-' || substr(R_FEE_EST_DT, 5, 2) || '-'||substr(R_FEE_EST_DT, 7, 2) R_FEE_EST_DT,"+
				" substr(REQ_DT, 1, 4) || '-' || substr(REQ_DT, 5, 2) || '-'||substr(REQ_DT, 7, 2) REQ_DT,"+
				" substr(R_REQ_DT, 1, 4) || '-' || substr(R_REQ_DT, 5, 2) || '-'||substr(R_REQ_DT, 7, 2) R_REQ_DT,"+
				" substr(TAX_OUT_DT, 1, 4) || '-' || substr(TAX_OUT_DT, 5, 2) || '-'||substr(TAX_OUT_DT, 7, 2) TAX_OUT_DT,"+
				" substr(USE_S_DT, 1, 4) || '-' || substr(USE_S_DT, 5, 2) || '-'||substr(USE_S_DT, 7, 2) USE_S_DT,"+
				" substr(USE_E_DT, 1, 4) || '-' || substr(USE_E_DT, 5, 2) || '-'||substr(USE_E_DT, 7, 2) USE_E_DT, adate, pay_st, incom_dt, incom_seq "+
				" from scd_fee"+
				" where RENT_MNG_ID = '"+m_id+"'"+
				" and rc_yn = '0'";

		if(gubun.equals("ALL"))	query += " and to_number(FEE_TM) >= '"+fee_tm+"'";
		else					query += " and FEE_TM = '"+fee_tm+"'";
				
		query += " order by to_number(fee_tm)";

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
   			int i = 0;
			while(rs.next())
			{
				FeeScdBean fee_scd = new FeeScdBean();				
				fee_scd.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_scd.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_scd.setRent_seq(rs.getString("RENT_SEQ")==null?"":rs.getString("RENT_SEQ"));
				fee_scd.setTm_st1(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				fee_scd.setTm_st2(rs.getString("TM_ST2")==null?"":rs.getString("TM_ST2"));
				fee_scd.setFee_est_dt(rs.getString("FEE_EST_DT")==null?"":rs.getString("FEE_EST_DT"));
				fee_scd.setFee_s_amt(rs.getString("FEE_S_AMT")==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee_scd.setFee_v_amt(rs.getString("FEE_V_AMT")==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee_scd.setRc_yn(rs.getString("RC_YN")==null?"":rs.getString("RC_YN"));
				fee_scd.setRc_dt(rs.getString("RC_DT")==null?"":rs.getString("RC_DT"));
				fee_scd.setRc_amt(rs.getString("RC_AMT")==null?0:Integer.parseInt(rs.getString("RC_AMT")));
				fee_scd.setDly_days(rs.getString("DLY_DAYS")==null?"":rs.getString("DLY_DAYS"));
				fee_scd.setDly_fee(rs.getString("DLY_FEE")==null?0:Integer.parseInt(rs.getString("DLY_FEE")));
				fee_scd.setPay_cng_dt(rs.getString("PAY_CNG_DT")==null?"":rs.getString("PAY_CNG_DT"));
				fee_scd.setPay_cng_cau(rs.getString("PAY_CNG_CAU")==null?"":rs.getString("PAY_CNG_CAU"));
				fee_scd.setR_fee_est_dt(rs.getString("R_FEE_EST_DT")==null?"":rs.getString("R_FEE_EST_DT"));
				fee_scd.setReq_dt(rs.getString("REQ_DT")==null?"":rs.getString("REQ_DT"));
				fee_scd.setR_req_dt(rs.getString("R_REQ_DT")==null?"":rs.getString("R_REQ_DT"));
				fee_scd.setTax_out_dt(rs.getString("TAX_OUT_DT")==null?"":rs.getString("TAX_OUT_DT"));
				fee_scd.setUse_s_dt(rs.getString("USE_S_DT")==null?"":rs.getString("USE_S_DT"));
				fee_scd.setUse_e_dt(rs.getString("USE_E_DT")==null?"":rs.getString("USE_E_DT"));
				fee_scd.setAdate(rs.getString("adate")==null?"":rs.getString("adate"));
				fee_scd.setPay_st(rs.getString("pay_st")==null?"":rs.getString("pay_st"));
				fee_scd.setIncom_dt(rs.getString("incom_dt")==null?"":rs.getString("incom_dt"));
				fee_scd.setIncom_seq(rs.getString("incom_seq")==null?0:Integer.parseInt(rs.getString("incom_seq")));
				
				vt.add(i, fee_scd);
				i++;
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getScdGroup]\n"+e);
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
	 *	입금변경을 위한 쿼리(한회에 속한 대여료 및 잔액 모두 포함 or 해당회차 이후의 모든 대여료 및 잔액 리턴)
	 *  gubun - ONE : 해당 회차에 속한 대여료 및 잔액만 리턴, ALL : 해당회차를 포함해 그 이후의 모든 대여료 및 잔액을 리턴
	 */
	public Vector getScdGroup(String m_id, String l_cd, String fee_tm, String gubun)
	{
		getConnection();
		Vector vt = new Vector();
		Statement stmt = null;
		ResultSet rs = null;
		String query = "";
		query = " select"+
				" RENT_MNG_ID, RENT_L_CD, FEE_TM, RENT_ST, TM_ST1, TM_ST2, RENT_SEQ,"+
				" substr(FEE_EST_DT, 1, 4) || '-' || substr(FEE_EST_DT, 5, 2) || '-'||substr(FEE_EST_DT, 7, 2) FEE_EST_DT,"+
				" FEE_S_AMT, FEE_V_AMT, RC_YN,"+
				" substr(RC_DT, 1, 4) || '-' || substr(RC_DT, 5, 2) || '-'||substr(RC_DT, 7, 2) RC_DT,"+
				" RC_AMT, DLY_DAYS, DLY_FEE,"+
				" substr(PAY_CNG_DT, 1, 4) || '-' || substr(PAY_CNG_DT, 5, 2) || '-'||substr(PAY_CNG_DT, 7, 2) PAY_CNG_DT,"+
				" PAY_CNG_CAU,"+
				" substr(R_FEE_EST_DT, 1, 4) || '-' || substr(R_FEE_EST_DT, 5, 2) || '-'||substr(R_FEE_EST_DT, 7, 2) R_FEE_EST_DT,"+
				" substr(REQ_DT, 1, 4) || '-' || substr(REQ_DT, 5, 2) || '-'||substr(REQ_DT, 7, 2) REQ_DT,"+
				" substr(R_REQ_DT, 1, 4) || '-' || substr(R_REQ_DT, 5, 2) || '-'||substr(R_REQ_DT, 7, 2) R_REQ_DT,"+
				" substr(TAX_OUT_DT, 1, 4) || '-' || substr(TAX_OUT_DT, 5, 2) || '-'||substr(TAX_OUT_DT, 7, 2) TAX_OUT_DT,"+
				" substr(USE_S_DT, 1, 4) || '-' || substr(USE_S_DT, 5, 2) || '-'||substr(USE_S_DT, 7, 2) USE_S_DT,"+
				" substr(USE_E_DT, 1, 4) || '-' || substr(USE_E_DT, 5, 2) || '-'||substr(USE_E_DT, 7, 2) USE_E_DT, adate, pay_st, incom_dt, incom_seq "+
				" from scd_fee"+
				" where RENT_MNG_ID = '"+m_id+"' and RENT_L_CD = '"+l_cd+"'"+
				" and rc_yn = '0'";

		if(gubun.equals("ALL"))	query += " and to_number(FEE_TM) >= '"+fee_tm+"'";
		else					query += " and FEE_TM = '"+fee_tm+"'";
				
		query += " order by to_number(fee_tm)";


		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
   			int i = 0;
			while(rs.next())
			{
				FeeScdBean fee_scd = new FeeScdBean();				
				fee_scd.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_scd.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_scd.setRent_seq(rs.getString("RENT_SEQ")==null?"":rs.getString("RENT_SEQ"));
				fee_scd.setTm_st1(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				fee_scd.setTm_st2(rs.getString("TM_ST2")==null?"":rs.getString("TM_ST2"));
				fee_scd.setFee_est_dt(rs.getString("FEE_EST_DT")==null?"":rs.getString("FEE_EST_DT"));
				fee_scd.setFee_s_amt(rs.getString("FEE_S_AMT")==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee_scd.setFee_v_amt(rs.getString("FEE_V_AMT")==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee_scd.setRc_yn(rs.getString("RC_YN")==null?"":rs.getString("RC_YN"));
				fee_scd.setRc_dt(rs.getString("RC_DT")==null?"":rs.getString("RC_DT"));
				fee_scd.setRc_amt(rs.getString("RC_AMT")==null?0:Integer.parseInt(rs.getString("RC_AMT")));
				fee_scd.setDly_days(rs.getString("DLY_DAYS")==null?"":rs.getString("DLY_DAYS"));
				fee_scd.setDly_fee(rs.getString("DLY_FEE")==null?0:Integer.parseInt(rs.getString("DLY_FEE")));
				fee_scd.setPay_cng_dt(rs.getString("PAY_CNG_DT")==null?"":rs.getString("PAY_CNG_DT"));
				fee_scd.setPay_cng_cau(rs.getString("PAY_CNG_CAU")==null?"":rs.getString("PAY_CNG_CAU"));
				fee_scd.setR_fee_est_dt(rs.getString("R_FEE_EST_DT")==null?"":rs.getString("R_FEE_EST_DT"));
				fee_scd.setReq_dt(rs.getString("REQ_DT")==null?"":rs.getString("REQ_DT"));
				fee_scd.setR_req_dt(rs.getString("R_REQ_DT")==null?"":rs.getString("R_REQ_DT"));
				fee_scd.setTax_out_dt(rs.getString("TAX_OUT_DT")==null?"":rs.getString("TAX_OUT_DT"));
				fee_scd.setUse_s_dt(rs.getString("USE_S_DT")==null?"":rs.getString("USE_S_DT"));
				fee_scd.setUse_e_dt(rs.getString("USE_E_DT")==null?"":rs.getString("USE_E_DT"));
				fee_scd.setAdate(rs.getString("adate")==null?"":rs.getString("adate"));
				fee_scd.setPay_st(rs.getString("pay_st")==null?"":rs.getString("pay_st"));
				fee_scd.setIncom_dt(rs.getString("incom_dt")==null?"":rs.getString("incom_dt"));
				fee_scd.setIncom_seq(rs.getString("incom_seq")==null?0:Integer.parseInt(rs.getString("incom_seq")));
				
				vt.add(i, fee_scd);
				i++;
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getScdGroup]\n"+e);
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
	 *	입금변경을 위한 쿼리(한회에 속한 대여료 및 잔액 모두 포함 or 해당회차 이후의 모든 대여료 및 잔액 리턴)
	 *  gubun - ONE : 해당 회차에 속한 대여료 및 잔액만 리턴, ALL : 해당회차를 포함해 그 이후의 모든 대여료 및 잔액을 리턴
	 */
	public Vector getScdGroupCng(String m_id, String l_cd, String fee_tm, String gubun)
	{
		getConnection();
		Vector vt = new Vector();
		Statement stmt = null;
		ResultSet rs = null;
		String query = "";
		query = " select"+
				" RENT_MNG_ID, RENT_L_CD, FEE_TM, RENT_ST, TM_ST1, TM_ST2, RENT_SEQ,"+
				" substr(FEE_EST_DT, 1, 4) || '-' || substr(FEE_EST_DT, 5, 2) || '-'||substr(FEE_EST_DT, 7, 2) FEE_EST_DT,"+
				" FEE_S_AMT, FEE_V_AMT, RC_YN,"+
				" substr(RC_DT, 1, 4) || '-' || substr(RC_DT, 5, 2) || '-'||substr(RC_DT, 7, 2) RC_DT,"+
				" RC_AMT, DLY_DAYS, DLY_FEE,"+
				" substr(PAY_CNG_DT, 1, 4) || '-' || substr(PAY_CNG_DT, 5, 2) || '-'||substr(PAY_CNG_DT, 7, 2) PAY_CNG_DT,"+
				" PAY_CNG_CAU,"+
				" substr(R_FEE_EST_DT, 1, 4) || '-' || substr(R_FEE_EST_DT, 5, 2) || '-'||substr(R_FEE_EST_DT, 7, 2) R_FEE_EST_DT,"+
				" substr(REQ_DT, 1, 4) || '-' || substr(REQ_DT, 5, 2) || '-'||substr(REQ_DT, 7, 2) REQ_DT,"+
				" substr(R_REQ_DT, 1, 4) || '-' || substr(R_REQ_DT, 5, 2) || '-'||substr(R_REQ_DT, 7, 2) R_REQ_DT,"+
				" substr(TAX_OUT_DT, 1, 4) || '-' || substr(TAX_OUT_DT, 5, 2) || '-'||substr(TAX_OUT_DT, 7, 2) TAX_OUT_DT,"+
				" substr(USE_S_DT, 1, 4) || '-' || substr(USE_S_DT, 5, 2) || '-'||substr(USE_S_DT, 7, 2) USE_S_DT,"+
				" substr(USE_E_DT, 1, 4) || '-' || substr(USE_E_DT, 5, 2) || '-'||substr(USE_E_DT, 7, 2) USE_E_DT, adate, pay_st, incom_dt, incom_seq "+
				" from scd_fee"+
				" where RENT_MNG_ID = '"+m_id+"' and RENT_L_CD = '"+l_cd+"'";
//				" and rc_yn = '0'";

		if(gubun.equals("ALL"))	query += " and to_number(FEE_TM) >= '"+fee_tm+"'";
		else					query += " and FEE_TM = '"+fee_tm+"'";
				
		query += " order by to_number(fee_tm)";


		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
   			int i = 0;
			while(rs.next())
			{
				FeeScdBean fee_scd = new FeeScdBean();				
				fee_scd.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_scd.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_scd.setRent_seq(rs.getString("RENT_SEQ")==null?"":rs.getString("RENT_SEQ"));
				fee_scd.setTm_st1(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				fee_scd.setTm_st2(rs.getString("TM_ST2")==null?"":rs.getString("TM_ST2"));
				fee_scd.setFee_est_dt(rs.getString("FEE_EST_DT")==null?"":rs.getString("FEE_EST_DT"));
				fee_scd.setFee_s_amt(rs.getString("FEE_S_AMT")==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee_scd.setFee_v_amt(rs.getString("FEE_V_AMT")==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee_scd.setRc_yn(rs.getString("RC_YN")==null?"":rs.getString("RC_YN"));
				fee_scd.setRc_dt(rs.getString("RC_DT")==null?"":rs.getString("RC_DT"));
				fee_scd.setRc_amt(rs.getString("RC_AMT")==null?0:Integer.parseInt(rs.getString("RC_AMT")));
				fee_scd.setDly_days(rs.getString("DLY_DAYS")==null?"":rs.getString("DLY_DAYS"));
				fee_scd.setDly_fee(rs.getString("DLY_FEE")==null?0:Integer.parseInt(rs.getString("DLY_FEE")));
				fee_scd.setPay_cng_dt(rs.getString("PAY_CNG_DT")==null?"":rs.getString("PAY_CNG_DT"));
				fee_scd.setPay_cng_cau(rs.getString("PAY_CNG_CAU")==null?"":rs.getString("PAY_CNG_CAU"));
				fee_scd.setR_fee_est_dt(rs.getString("R_FEE_EST_DT")==null?"":rs.getString("R_FEE_EST_DT"));
				fee_scd.setReq_dt(rs.getString("REQ_DT")==null?"":rs.getString("REQ_DT"));
				fee_scd.setR_req_dt(rs.getString("R_REQ_DT")==null?"":rs.getString("R_REQ_DT"));
				fee_scd.setTax_out_dt(rs.getString("TAX_OUT_DT")==null?"":rs.getString("TAX_OUT_DT"));
				fee_scd.setUse_s_dt(rs.getString("USE_S_DT")==null?"":rs.getString("USE_S_DT"));
				fee_scd.setUse_e_dt(rs.getString("USE_E_DT")==null?"":rs.getString("USE_E_DT"));
				fee_scd.setAdate(rs.getString("adate")==null?"":rs.getString("adate"));
				fee_scd.setPay_st(rs.getString("pay_st")==null?"":rs.getString("pay_st"));
				fee_scd.setIncom_dt(rs.getString("incom_dt")==null?"":rs.getString("incom_dt"));
				fee_scd.setIncom_seq(rs.getString("incom_seq")==null?0:Integer.parseInt(rs.getString("incom_seq")));
				
				vt.add(i, fee_scd);
				i++;
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getScdGroup]\n"+e);
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
	 *	입금변경을 위한 쿼리(한회에 속한 대여료 및 잔액 모두 포함 or 해당회차 이후의 모든 대여료 및 잔액 리턴)
	 *  gubun - ONE : 해당 회차에 속한 대여료 및 잔액만 리턴, ALL : 해당회차를 포함해 그 이후의 모든 대여료 및 잔액을 리턴
	 */
	public Vector getScdGroupCng2(String m_id, String l_cd, String fee_tm, String gubun)
	{
		getConnection();
		Vector vt = new Vector();
		Statement stmt = null;
		ResultSet rs = null;
		String query = "";
		query = " select"+
				" RENT_MNG_ID, RENT_L_CD, FEE_TM, RENT_ST, TM_ST1, TM_ST2, RENT_SEQ,"+
				" substr(FEE_EST_DT, 1, 4) || '-' || substr(FEE_EST_DT, 5, 2) || '-'||substr(FEE_EST_DT, 7, 2) FEE_EST_DT,"+
				" FEE_S_AMT, FEE_V_AMT, RC_YN,"+
				" substr(RC_DT, 1, 4) || '-' || substr(RC_DT, 5, 2) || '-'||substr(RC_DT, 7, 2) RC_DT,"+
				" RC_AMT, DLY_DAYS, DLY_FEE,"+
				" substr(PAY_CNG_DT, 1, 4) || '-' || substr(PAY_CNG_DT, 5, 2) || '-'||substr(PAY_CNG_DT, 7, 2) PAY_CNG_DT,"+
				" PAY_CNG_CAU,"+
				" substr(R_FEE_EST_DT, 1, 4) || '-' || substr(R_FEE_EST_DT, 5, 2) || '-'||substr(R_FEE_EST_DT, 7, 2) R_FEE_EST_DT,"+
				" substr(REQ_DT, 1, 4) || '-' || substr(REQ_DT, 5, 2) || '-'||substr(REQ_DT, 7, 2) REQ_DT,"+
				" substr(R_REQ_DT, 1, 4) || '-' || substr(R_REQ_DT, 5, 2) || '-'||substr(R_REQ_DT, 7, 2) R_REQ_DT,"+
				" substr(TAX_OUT_DT, 1, 4) || '-' || substr(TAX_OUT_DT, 5, 2) || '-'||substr(TAX_OUT_DT, 7, 2) TAX_OUT_DT,"+
				" substr(USE_S_DT, 1, 4) || '-' || substr(USE_S_DT, 5, 2) || '-'||substr(USE_S_DT, 7, 2) USE_S_DT,"+
				" substr(USE_E_DT, 1, 4) || '-' || substr(USE_E_DT, 5, 2) || '-'||substr(USE_E_DT, 7, 2) USE_E_DT, adate, pay_st, incom_dt, incom_seq "+
				" from scd_fee"+
				" where RENT_MNG_ID = '"+m_id+"' and RENT_L_CD = '"+l_cd+"' and tm_st1='0'";
//				" and rc_yn = '0'";

		if(gubun.equals("ALL"))	query += " and to_number(FEE_TM) >= '"+fee_tm+"'";
		else					query += " and FEE_TM = '"+fee_tm+"'";
				
		query += " order by to_number(fee_tm)";


		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
   			int i = 0;
			while(rs.next())
			{
				FeeScdBean fee_scd = new FeeScdBean();				
				fee_scd.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_scd.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_scd.setRent_seq(rs.getString("RENT_SEQ")==null?"":rs.getString("RENT_SEQ"));
				fee_scd.setTm_st1(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				fee_scd.setTm_st2(rs.getString("TM_ST2")==null?"":rs.getString("TM_ST2"));
				fee_scd.setFee_est_dt(rs.getString("FEE_EST_DT")==null?"":rs.getString("FEE_EST_DT"));
				fee_scd.setFee_s_amt(rs.getString("FEE_S_AMT")==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee_scd.setFee_v_amt(rs.getString("FEE_V_AMT")==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee_scd.setRc_yn(rs.getString("RC_YN")==null?"":rs.getString("RC_YN"));
				fee_scd.setRc_dt(rs.getString("RC_DT")==null?"":rs.getString("RC_DT"));
				fee_scd.setRc_amt(rs.getString("RC_AMT")==null?0:Integer.parseInt(rs.getString("RC_AMT")));
				fee_scd.setDly_days(rs.getString("DLY_DAYS")==null?"":rs.getString("DLY_DAYS"));
				fee_scd.setDly_fee(rs.getString("DLY_FEE")==null?0:Integer.parseInt(rs.getString("DLY_FEE")));
				fee_scd.setPay_cng_dt(rs.getString("PAY_CNG_DT")==null?"":rs.getString("PAY_CNG_DT"));
				fee_scd.setPay_cng_cau(rs.getString("PAY_CNG_CAU")==null?"":rs.getString("PAY_CNG_CAU"));
				fee_scd.setR_fee_est_dt(rs.getString("R_FEE_EST_DT")==null?"":rs.getString("R_FEE_EST_DT"));
				fee_scd.setReq_dt(rs.getString("REQ_DT")==null?"":rs.getString("REQ_DT"));
				fee_scd.setR_req_dt(rs.getString("R_REQ_DT")==null?"":rs.getString("R_REQ_DT"));
				fee_scd.setTax_out_dt(rs.getString("TAX_OUT_DT")==null?"":rs.getString("TAX_OUT_DT"));
				fee_scd.setUse_s_dt(rs.getString("USE_S_DT")==null?"":rs.getString("USE_S_DT"));
				fee_scd.setUse_e_dt(rs.getString("USE_E_DT")==null?"":rs.getString("USE_E_DT"));
				fee_scd.setAdate(rs.getString("adate")==null?"":rs.getString("adate"));
				fee_scd.setPay_st(rs.getString("pay_st")==null?"":rs.getString("pay_st"));
				fee_scd.setIncom_dt(rs.getString("incom_dt")==null?"":rs.getString("incom_dt"));
				fee_scd.setIncom_seq(rs.getString("incom_seq")==null?0:Integer.parseInt(rs.getString("incom_seq")));
				
				vt.add(i, fee_scd);
				i++;
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getScdGroup2]\n"+e);
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
	 *	한 건에 대한 대여료 스케줄 쿼리
	 */
	public Vector getFeeScd(String l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select  /*+use_hash(a b j)*/ "+
				" A.RENT_MNG_ID, A.RENT_L_CD, A.FEE_TM, A.RENT_ST, A.TM_ST1, A.TM_ST2, A.FEE_EST_DT, A.FEE_S_AMT, A.RENT_SEQ,"+
				" A.FEE_V_AMT, A.RC_YN, A.RC_DT, A.RC_AMT, A.DLY_DAYS, A.DLY_FEE, A.PAY_CNG_DT, A.PAY_CNG_CAU,"+
				" A.R_FEE_EST_DT, A.EXT_DT, decode(sign(B.tm-A.tm_st1), -1,'', 0,'Y') ISLAST, A.use_s_dt, A.use_e_dt"+
				" from"+
				"("+
					"select RENT_MNG_ID, RENT_L_CD, FEE_TM, RENT_ST, TM_ST1, TM_ST2, RENT_SEQ,"+
					" substr(FEE_EST_DT, 1, 4) || '-' || substr(FEE_EST_DT, 5, 2) || '-'||substr(FEE_EST_DT, 7, 2) FEE_EST_DT,"+
					" FEE_S_AMT, FEE_V_AMT, RC_YN,"+
					" substr(RC_DT, 1, 4) || '-' || substr(RC_DT, 5, 2) || '-'||substr(RC_DT, 7, 2) RC_DT,"+
					" RC_AMT, DLY_DAYS, DLY_FEE,"+
					" substr(PAY_CNG_DT, 1, 4) || '-' || substr(PAY_CNG_DT, 5, 2) || '-'||substr(PAY_CNG_DT, 7, 2) PAY_CNG_DT,"+
					" PAY_CNG_CAU,"+
					" substr(R_FEE_EST_DT, 1, 4) || '-' || substr(R_FEE_EST_DT, 5, 2) || '-'||substr(R_FEE_EST_DT, 7, 2) R_FEE_EST_DT,"+
					" decode(EXT_DT,'','',substr(EXT_DT, 1, 4) || '-' || substr(EXT_DT, 5, 2) || '-'||substr(EXT_DT, 7, 2)) EXT_DT, use_s_dt, use_e_dt"+
					" from scd_fee"+
					" where nvl(bill_yn,'Y')='Y' and tm_st1='0' and RENT_L_CD = '"+l_cd+"' order by FEE_TM"+
				" ) A,"+
				" ("+
					" select max(rent_mng_id) RENT_MNG_ID, max(rent_l_cd) RENT_L_CD, max(fee_tm) FEE_TM,"+
					" max(to_number(rent_st)) RENT_ST, max(tm_st1) TM_ST1, max(tm_st1) TM"+
					" from scd_fee"+
					" where nvl(bill_yn,'Y')='Y' and RENT_L_CD = '"+l_cd+"' and rc_yn = '1' "+
					" group by fee_tm"+
				" ) B"+
				" where"+
				" A.rent_mng_id = B.rent_mng_id(+) and"+
				" A.rent_l_cd = B.rent_l_cd(+) and"+
				" A.rent_st = B.rent_st(+) and"+
				" A.fee_tm = B.fee_tm(+)"+
				" order by to_number(FEE_TM), to_number(TM_ST1)";												
		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			while(rs.next())
			{
				FeeScdBean fee_scd = new FeeScdBean();
				fee_scd.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_scd.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_scd.setRent_seq(rs.getString("RENT_SEQ")==null?"":rs.getString("RENT_SEQ"));
				fee_scd.setTm_st1(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				fee_scd.setTm_st2(rs.getString("TM_ST2")==null?"":rs.getString("TM_ST2"));
				fee_scd.setFee_est_dt(rs.getString("FEE_EST_DT")==null?"":rs.getString("FEE_EST_DT"));
				fee_scd.setFee_s_amt(rs.getString("FEE_S_AMT")==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee_scd.setFee_v_amt(rs.getString("FEE_V_AMT")==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee_scd.setRc_yn(rs.getString("RC_YN")==null?"":rs.getString("RC_YN"));
				fee_scd.setRc_dt(rs.getString("RC_DT")==null?"":rs.getString("RC_DT"));
				fee_scd.setRc_amt(rs.getString("RC_AMT")==null?0:Integer.parseInt(rs.getString("RC_AMT")));
				fee_scd.setDly_days(rs.getString("DLY_DAYS")==null?"":rs.getString("DLY_DAYS"));
				fee_scd.setDly_fee(rs.getString("DLY_FEE")==null?0:Integer.parseInt(rs.getString("DLY_FEE")));
				fee_scd.setPay_cng_dt(rs.getString("PAY_CNG_DT")==null?"":rs.getString("PAY_CNG_DT"));
				fee_scd.setPay_cng_cau(rs.getString("PAY_CNG_CAU")==null?"":rs.getString("PAY_CNG_CAU"));
				fee_scd.setR_fee_est_dt(rs.getString("R_FEE_EST_DT")==null?"":rs.getString("R_FEE_EST_DT"));
				fee_scd.setIslast(rs.getString("ISLAST")==null?"":rs.getString("ISLAST"));
				fee_scd.setExt_dt(rs.getString("EXT_DT")==null?"":rs.getString("EXT_DT"));
				fee_scd.setUse_s_dt(rs.getString("use_s_dt")==null?"":rs.getString("use_s_dt"));
				fee_scd.setUse_e_dt(rs.getString("use_e_dt")==null?"":rs.getString("use_e_dt"));
				
				vt.add(fee_scd);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getFeeScd]\n"+e);
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
	 *	한 건에 대한 대여료 스케줄 쿼리
	 */
	public Vector getFeeScdMail(String l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select /*+use_hash(a b j)*/ "+
				" A.RENT_MNG_ID, A.RENT_L_CD, A.FEE_TM, A.RENT_ST, A.TM_ST1, A.TM_ST2, A.FEE_EST_DT, A.FEE_S_AMT, A.RENT_SEQ,"+
				" A.FEE_V_AMT, A.RC_YN, A.RC_DT, A.RC_AMT, A.DLY_DAYS, A.DLY_FEE, A.PAY_CNG_DT, A.PAY_CNG_CAU,"+
				" A.R_FEE_EST_DT, A.EXT_DT, decode(sign(B.tm-A.tm_st1), -1,'', 0,'Y') ISLAST, A.use_s_dt, A.use_e_dt"+
				" from"+
				"("+
					"select RENT_MNG_ID, RENT_L_CD, FEE_TM, RENT_ST, TM_ST1, TM_ST2, RENT_SEQ,"+
					" substr(FEE_EST_DT, 1, 4) || '-' || substr(FEE_EST_DT, 5, 2) || '-'||substr(FEE_EST_DT, 7, 2) FEE_EST_DT,"+
					" FEE_S_AMT, FEE_V_AMT, RC_YN,"+
					" substr(RC_DT, 1, 4) || '-' || substr(RC_DT, 5, 2) || '-'||substr(RC_DT, 7, 2) RC_DT,"+
					" RC_AMT, DLY_DAYS, DLY_FEE,"+
					" substr(PAY_CNG_DT, 1, 4) || '-' || substr(PAY_CNG_DT, 5, 2) || '-'||substr(PAY_CNG_DT, 7, 2) PAY_CNG_DT,"+
					" PAY_CNG_CAU,"+
					" substr(R_FEE_EST_DT, 1, 4) || '-' || substr(R_FEE_EST_DT, 5, 2) || '-'||substr(R_FEE_EST_DT, 7, 2) R_FEE_EST_DT,"+
					" decode(EXT_DT,'','',substr(EXT_DT, 1, 4) || '-' || substr(EXT_DT, 5, 2) || '-'||substr(EXT_DT, 7, 2)) EXT_DT, use_s_dt, use_e_dt"+
					" from scd_fee"+
					" where tm_st1='0' and nvl(bill_yn,'Y')='Y' and RENT_L_CD = '"+l_cd+"' order by FEE_TM"+
				" ) A,"+
				" ("+
					" select max(rent_mng_id) RENT_MNG_ID, max(rent_l_cd) RENT_L_CD, max(fee_tm) FEE_TM,"+
					" max(to_number(rent_st)) RENT_ST, max(tm_st1) TM_ST1, max(tm_st1) TM"+
					" from scd_fee"+
					" where nvl(bill_yn,'Y')='Y' and RENT_L_CD = '"+l_cd+"' and rc_yn = '1' "+
					" group by fee_tm"+
				" ) B"+
				" where"+
				" A.rent_mng_id = B.rent_mng_id(+) and"+
				" A.rent_l_cd = B.rent_l_cd(+) and"+
				" A.rent_st = B.rent_st(+) and"+
				" A.fee_tm = B.fee_tm(+)"+
				" order by to_number(FEE_TM), to_number(TM_ST1)";												
		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			while(rs.next())
			{
				FeeScdBean fee_scd = new FeeScdBean();
				fee_scd.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_scd.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_scd.setRent_seq(rs.getString("RENT_SEQ")==null?"":rs.getString("RENT_SEQ"));
				fee_scd.setTm_st1(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				fee_scd.setTm_st2(rs.getString("TM_ST2")==null?"":rs.getString("TM_ST2"));
				fee_scd.setFee_est_dt(rs.getString("FEE_EST_DT")==null?"":rs.getString("FEE_EST_DT"));
				fee_scd.setFee_s_amt(rs.getString("FEE_S_AMT")==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee_scd.setFee_v_amt(rs.getString("FEE_V_AMT")==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee_scd.setRc_yn(rs.getString("RC_YN")==null?"":rs.getString("RC_YN"));
				fee_scd.setRc_dt(rs.getString("RC_DT")==null?"":rs.getString("RC_DT"));
				fee_scd.setRc_amt(rs.getString("RC_AMT")==null?0:Integer.parseInt(rs.getString("RC_AMT")));
				fee_scd.setDly_days(rs.getString("DLY_DAYS")==null?"":rs.getString("DLY_DAYS"));
				fee_scd.setDly_fee(rs.getString("DLY_FEE")==null?0:Integer.parseInt(rs.getString("DLY_FEE")));
				fee_scd.setPay_cng_dt(rs.getString("PAY_CNG_DT")==null?"":rs.getString("PAY_CNG_DT"));
				fee_scd.setPay_cng_cau(rs.getString("PAY_CNG_CAU")==null?"":rs.getString("PAY_CNG_CAU"));
				fee_scd.setR_fee_est_dt(rs.getString("R_FEE_EST_DT")==null?"":rs.getString("R_FEE_EST_DT"));
				fee_scd.setIslast(rs.getString("ISLAST")==null?"":rs.getString("ISLAST"));
				fee_scd.setExt_dt(rs.getString("EXT_DT")==null?"":rs.getString("EXT_DT"));
				fee_scd.setUse_s_dt(rs.getString("use_s_dt")==null?"":rs.getString("use_s_dt"));
				fee_scd.setUse_e_dt(rs.getString("use_e_dt")==null?"":rs.getString("use_e_dt"));
				vt.add(fee_scd);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getFeeScdMail]\n"+e);
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
	 *	한 건에 대한 대여료 스케줄 쿼리
	 */
	public Vector getFeeScdPrint(String l_cd, String asc)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select /*+use_hash(a b j)*/ USE_DAY, "+
				" A.RENT_MNG_ID, A.RENT_L_CD, A.FEE_TM, A.RENT_ST, A.TM_ST1, A.TM_ST2, A.FEE_EST_DT, A.FEE_S_AMT, A.RENT_SEQ,"+
				" A.FEE_V_AMT, A.RC_YN, A.RC_DT, A.RC_AMT, A.DLY_DAYS, A.DLY_FEE, A.PAY_CNG_DT, A.PAY_CNG_CAU,"+
				" A.R_FEE_EST_DT, "+
				" decode(sign(B.tm-A.tm_st1), -1,'', 0,'Y') ISLAST, bill_yn,"+
				" j.tax_dt as EXT_DT, A.USE_S_DT, A.USE_E_DT "+
				" from"+
				"("+
					"select RENT_MNG_ID, RENT_L_CD, FEE_TM, RENT_ST, TM_ST1, TM_ST2, bill_yn,  RENT_SEQ,"+
					" substr(FEE_EST_DT, 1, 4) || '-' || substr(FEE_EST_DT, 5, 2) || '-'||substr(FEE_EST_DT, 7, 2) FEE_EST_DT,"+
					" FEE_S_AMT, FEE_V_AMT, RC_YN,"+
					" substr(RC_DT, 1, 4) || '-' || substr(RC_DT, 5, 2) || '-'||substr(RC_DT, 7, 2) RC_DT,"+
					" RC_AMT, DLY_DAYS, DLY_FEE,"+
					" substr(PAY_CNG_DT, 1, 4) || '-' || substr(PAY_CNG_DT, 5, 2) || '-'||substr(PAY_CNG_DT, 7, 2) PAY_CNG_DT,"+
					" PAY_CNG_CAU,"+
					" substr(R_FEE_EST_DT, 1, 4) || '-' || substr(R_FEE_EST_DT, 5, 2) || '-'||substr(R_FEE_EST_DT, 7, 2) R_FEE_EST_DT,"+
					" decode(EXT_DT,'','',substr(EXT_DT, 1, 4) || '-' || substr(EXT_DT, 5, 2) || '-'||substr(EXT_DT, 7, 2)) EXT_DT,"+
					" to_date( use_e_dt, 'yyyymmdd' ) + 1 - to_date( use_s_dt, 'yyyymmdd' ) as USE_DAY, "+
					" substr(USE_S_DT, 1, 4) || '-' || substr(USE_S_DT, 5, 2) || '-'||substr(USE_S_DT, 7, 2) USE_S_DT,"+
					" substr(USE_E_DT, 1, 4) || '-' || substr(USE_E_DT, 5, 2) || '-'||substr(USE_E_DT, 7, 2) USE_E_DT"+
					" from scd_fee"+
					" where RENT_L_CD = '"+l_cd+"' order by FEE_TM"+ 
				" ) A,"+
				" ("+
					" select max(rent_mng_id) RENT_MNG_ID, max(rent_l_cd) RENT_L_CD, max(fee_tm) FEE_TM,"+
					" max(to_number(rent_st)) RENT_ST, max(tm_st1) TM_ST1, max(tm_st1) TM"+
					" from scd_fee"+
					" where RENT_L_CD = '"+l_cd+"' and rc_yn = '1' "+ 
					" group by fee_tm"+
				" ) B, "+

							  //20110309 거래명세서&세금계산서
					 "        ( select a.rent_l_cd, a.rent_st, a.rent_seq, a.tm as fee_tm, sum(item_supply) fee_s_amt, \n"+
					 "                 max(b.item_id) item_id, max(b.item_dt) item_dt, max(b.tax_est_dt) tax_est_dt, \n"+
					 "                 decode(sum(c.tax_supply),0,'',max(c.tax_no)) tax_no, "+
					 "		           decode(sum(c.tax_supply),0,'',max(c.tax_dt)) tax_dt, "+
					 "	               decode(sum(c.tax_supply),0,'',max(c.reg_dt)) reg_dt, "+
					 "	               decode(sum(c.tax_supply),0,'',max(c.print_dt)) print_dt \n"+
					 "          from   tax_item_list a, tax_item b, tax c \n"+
					 "          where  a.RENT_L_CD = '"+l_cd+"' and a.gubun='1' \n"+
					 "                 and a.item_id=b.item_id and a.item_id=c.item_id(+) and nvl(c.tax_st,'O')<>'C' \n"+
					 "          group by a.rent_l_cd, a.rent_st, a.rent_seq, a.tm \n"+
					 "          having sum(item_supply) > 0 "+			
					 "	      ) j \n"+


				" where"+
				" A.rent_mng_id = B.rent_mng_id(+) and"+
				" A.rent_l_cd = B.rent_l_cd(+) and"+
				" A.rent_st = B.rent_st(+) and"+
				" A.fee_tm = B.fee_tm(+)"+
				" and A.rent_l_cd=j.rent_l_cd(+) and A.fee_tm=j.fee_tm(+) and A.rent_st=j.rent_st(+) and A.rent_seq=j.rent_seq(+)"+
				" order by rent_seq, to_number(FEE_TM) "+asc+", to_number(TM_ST1) "+asc+" ";
		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	

			while(rs.next())
			{
				FeeScdBean fee_scd = new FeeScdBean();
				fee_scd.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_scd.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_scd.setRent_seq(rs.getString("RENT_SEQ")==null?"":rs.getString("RENT_SEQ"));
				fee_scd.setTm_st1(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				fee_scd.setTm_st2(rs.getString("TM_ST2")==null?"":rs.getString("TM_ST2"));
				fee_scd.setFee_est_dt(rs.getString("FEE_EST_DT")==null?"":rs.getString("FEE_EST_DT"));
				fee_scd.setFee_s_amt(rs.getString("FEE_S_AMT")==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee_scd.setFee_v_amt(rs.getString("FEE_V_AMT")==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee_scd.setRc_yn(rs.getString("RC_YN")==null?"":rs.getString("RC_YN"));
				fee_scd.setRc_dt(rs.getString("RC_DT")==null?"":rs.getString("RC_DT"));
				fee_scd.setRc_amt(rs.getString("RC_AMT")==null?0:Integer.parseInt(rs.getString("RC_AMT")));
				fee_scd.setDly_days(rs.getString("DLY_DAYS")==null?"":rs.getString("DLY_DAYS"));
				fee_scd.setDly_fee(rs.getString("DLY_FEE")==null?0:Integer.parseInt(rs.getString("DLY_FEE")));
				fee_scd.setPay_cng_dt(rs.getString("PAY_CNG_DT")==null?"":rs.getString("PAY_CNG_DT"));
				fee_scd.setPay_cng_cau(rs.getString("PAY_CNG_CAU")==null?"":rs.getString("PAY_CNG_CAU"));
				fee_scd.setR_fee_est_dt(rs.getString("R_FEE_EST_DT")==null?"":rs.getString("R_FEE_EST_DT"));
				fee_scd.setIslast(rs.getString("ISLAST")==null?"":rs.getString("ISLAST"));
				fee_scd.setExt_dt(rs.getString("EXT_DT")==null?"":rs.getString("EXT_DT"));
				fee_scd.setBill_yn(rs.getString("bill_yn")==null?"":rs.getString("bill_yn"));
				fee_scd.setUse_day(rs.getString("USE_DAY")==null?"":rs.getString("USE_DAY"));

				vt.add(fee_scd);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getFeeScd]\n"+e);
			System.out.println("[AddFeeDatabase:getFeeScd]\n"+query);
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
	 *	한 건에 대한 대여료 스케줄 쿼리
	 */
	public Vector getFeeScdPrintAll(String m_id, String asc)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select /*+use_hash(a b j)*/ "+
				" A.RENT_MNG_ID, A.RENT_L_CD, A.FEE_TM, A.RENT_ST, A.TM_ST1, A.TM_ST2, A.FEE_EST_DT, A.FEE_S_AMT, A.RENT_SEQ,"+
				" A.FEE_V_AMT, A.RC_YN, A.RC_DT, A.RC_AMT, A.DLY_DAYS, A.DLY_FEE, A.PAY_CNG_DT, A.PAY_CNG_CAU,"+
				" A.R_FEE_EST_DT, j.tax_dt as EXT_DT, decode(sign(B.tm-A.tm_st1), -1,'', 0,'Y') ISLAST, bill_yn"+
				" from"+
				"("+
					"select RENT_MNG_ID, RENT_L_CD, FEE_TM, RENT_ST, TM_ST1, TM_ST2, bill_yn,  RENT_SEQ,"+
					" substr(FEE_EST_DT, 1, 4) || '-' || substr(FEE_EST_DT, 5, 2) || '-'||substr(FEE_EST_DT, 7, 2) FEE_EST_DT,"+
					" FEE_S_AMT, FEE_V_AMT, RC_YN,"+
					" substr(RC_DT, 1, 4) || '-' || substr(RC_DT, 5, 2) || '-'||substr(RC_DT, 7, 2) RC_DT,"+
					" RC_AMT, DLY_DAYS, DLY_FEE,"+
					" substr(PAY_CNG_DT, 1, 4) || '-' || substr(PAY_CNG_DT, 5, 2) || '-'||substr(PAY_CNG_DT, 7, 2) PAY_CNG_DT,"+
					" PAY_CNG_CAU,"+
					" substr(R_FEE_EST_DT, 1, 4) || '-' || substr(R_FEE_EST_DT, 5, 2) || '-'||substr(R_FEE_EST_DT, 7, 2) R_FEE_EST_DT,"+
					" decode(EXT_DT,'','',substr(EXT_DT, 1, 4) || '-' || substr(EXT_DT, 5, 2) || '-'||substr(EXT_DT, 7, 2)) EXT_DT"+
					" from scd_fee"+
					" where RENT_MNG_ID = '"+m_id+"' order by FEE_TM"+ 
				" ) A,"+
				" ("+
					" select max(rent_mng_id) RENT_MNG_ID, max(rent_l_cd) RENT_L_CD, max(fee_tm) FEE_TM,"+
					" max(to_number(rent_st)) RENT_ST, max(tm_st1) TM_ST1, max(tm_st1) TM"+
					" from scd_fee"+
					" where RENT_MNG_ID = '"+m_id+"' and rc_yn = '1' "+ 
					" group by fee_tm"+
				" ) B,"+
				" (select bb.tax_dt, aa.* from tax_item_list aa, tax bb where aa.rent_l_cd in (select rent_l_cd from cont where rent_mng_id='"+m_id+"') and aa.item_id=bb.item_id and bb.tax_st='O' and aa.gubun ='1') j"+
				" where"+
				" A.rent_mng_id = B.rent_mng_id(+) and"+
				" A.rent_l_cd = B.rent_l_cd(+) and"+
				" A.rent_st = B.rent_st(+) and"+
				" A.fee_tm = B.fee_tm(+)"+
				" and A.rent_l_cd=j.rent_l_cd(+) and A.fee_tm=j.tm(+) and A.RENT_ST=j.RENT_ST(+) and A.RENT_SEQ=j.RENT_SEQ(+)"+
				" order by to_number(FEE_TM) "+asc+", to_number(TM_ST1)";												
		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			while(rs.next())
			{
				FeeScdBean fee_scd = new FeeScdBean();
				fee_scd.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_scd.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_scd.setRent_seq(rs.getString("RENT_SEQ")==null?"":rs.getString("RENT_SEQ"));
				fee_scd.setTm_st1(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				fee_scd.setTm_st2(rs.getString("TM_ST2")==null?"":rs.getString("TM_ST2"));
				fee_scd.setFee_est_dt(rs.getString("FEE_EST_DT")==null?"":rs.getString("FEE_EST_DT"));
				fee_scd.setFee_s_amt(rs.getString("FEE_S_AMT")==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee_scd.setFee_v_amt(rs.getString("FEE_V_AMT")==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee_scd.setRc_yn(rs.getString("RC_YN")==null?"":rs.getString("RC_YN"));
				fee_scd.setRc_dt(rs.getString("RC_DT")==null?"":rs.getString("RC_DT"));
				fee_scd.setRc_amt(rs.getString("RC_AMT")==null?0:Integer.parseInt(rs.getString("RC_AMT")));
				fee_scd.setDly_days(rs.getString("DLY_DAYS")==null?"":rs.getString("DLY_DAYS"));
				fee_scd.setDly_fee(rs.getString("DLY_FEE")==null?0:Integer.parseInt(rs.getString("DLY_FEE")));
				fee_scd.setPay_cng_dt(rs.getString("PAY_CNG_DT")==null?"":rs.getString("PAY_CNG_DT"));
				fee_scd.setPay_cng_cau(rs.getString("PAY_CNG_CAU")==null?"":rs.getString("PAY_CNG_CAU"));
				fee_scd.setR_fee_est_dt(rs.getString("R_FEE_EST_DT")==null?"":rs.getString("R_FEE_EST_DT"));
				fee_scd.setIslast(rs.getString("ISLAST")==null?"":rs.getString("ISLAST"));
				fee_scd.setExt_dt(rs.getString("EXT_DT")==null?"":rs.getString("EXT_DT"));
				fee_scd.setBill_yn(rs.getString("bill_yn")==null?"":rs.getString("bill_yn"));
				vt.add(fee_scd);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getFeeScdPrintAll]\n"+e);
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
	 *	한 건에 대한 대여료 스케줄 쿼리
	 */
	public Vector getFeeScdRentst(String l_cd, String rent_st)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String where = "";
		if(rent_st.equals(""))	where = " and tm_st2='2'";
		else 					where = " and rent_st='"+rent_st+"' and tm_st2<>'2'";

		query = " select /*+use_hash(a b j)*/ "+
				" A.RENT_MNG_ID, A.RENT_L_CD, A.FEE_TM, A.RENT_ST, A.TM_ST1, A.TM_ST2, A.FEE_EST_DT, A.FEE_S_AMT, A.RENT_SEQ,"+
				" A.FEE_V_AMT, A.RC_YN, A.RC_DT, A.RC_AMT, A.DLY_DAYS, A.DLY_FEE, A.PAY_CNG_DT, A.PAY_CNG_CAU,"+
				" A.R_FEE_EST_DT, A.EXT_DT, decode(sign(B.tm-A.tm_st1), -1,'', 0,'Y') ISLAST"+
				" from"+
				"("+
					"select RENT_MNG_ID, RENT_L_CD, FEE_TM, RENT_ST, TM_ST1, TM_ST2, RENT_SEQ,"+
					" substr(FEE_EST_DT, 1, 4) || '-' || substr(FEE_EST_DT, 5, 2) || '-'||substr(FEE_EST_DT, 7, 2) FEE_EST_DT,"+
					" FEE_S_AMT, FEE_V_AMT, RC_YN,"+
					" substr(RC_DT, 1, 4) || '-' || substr(RC_DT, 5, 2) || '-'||substr(RC_DT, 7, 2) RC_DT,"+
					" RC_AMT, DLY_DAYS, DLY_FEE,"+
					" substr(PAY_CNG_DT, 1, 4) || '-' || substr(PAY_CNG_DT, 5, 2) || '-'||substr(PAY_CNG_DT, 7, 2) PAY_CNG_DT,"+
					" PAY_CNG_CAU,"+
					" substr(R_FEE_EST_DT, 1, 4) || '-' || substr(R_FEE_EST_DT, 5, 2) || '-'||substr(R_FEE_EST_DT, 7, 2) R_FEE_EST_DT,"+
					" decode(EXT_DT,'','',substr(EXT_DT, 1, 4) || '-' || substr(EXT_DT, 5, 2) || '-'||substr(EXT_DT, 7, 2)) EXT_DT"+
					" from scd_fee"+
					" where nvl(bill_yn,'Y')='Y' and RENT_L_CD = '"+l_cd+"' "+where+" order by FEE_TM"+
				" ) A,"+
				" ("+
					" select max(rent_mng_id) RENT_MNG_ID, max(rent_l_cd) RENT_L_CD, max(fee_tm) FEE_TM,"+
					" max(to_number(rent_st)) RENT_ST, max(tm_st1) TM_ST1, max(tm_st1) TM"+
					" from scd_fee"+
					" where nvl(bill_yn,'Y')='Y' and RENT_L_CD = '"+l_cd+"' "+where+" and rc_yn = '1' "+
					" group by fee_tm"+
				" ) B"+
				" where"+
				" A.rent_mng_id = B.rent_mng_id(+) and"+
				" A.rent_l_cd = B.rent_l_cd(+) and"+
				" A.rent_st = B.rent_st(+) and"+
				" A.fee_tm = B.fee_tm(+)"+
				" order by to_number(FEE_TM), to_number(TM_ST1)";												
		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			while(rs.next())
			{
				FeeScdBean fee_scd = new FeeScdBean();
				fee_scd.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_scd.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_scd.setRent_seq(rs.getString("RENT_SEQ")==null?"":rs.getString("RENT_SEQ"));
				fee_scd.setTm_st1(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				fee_scd.setTm_st2(rs.getString("TM_ST2")==null?"":rs.getString("TM_ST2"));
				fee_scd.setFee_est_dt(rs.getString("FEE_EST_DT")==null?"":rs.getString("FEE_EST_DT"));
				fee_scd.setFee_s_amt(rs.getString("FEE_S_AMT")==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee_scd.setFee_v_amt(rs.getString("FEE_V_AMT")==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee_scd.setRc_yn(rs.getString("RC_YN")==null?"":rs.getString("RC_YN"));
				fee_scd.setRc_dt(rs.getString("RC_DT")==null?"":rs.getString("RC_DT"));
				fee_scd.setRc_amt(rs.getString("RC_AMT")==null?0:Integer.parseInt(rs.getString("RC_AMT")));
				fee_scd.setDly_days(rs.getString("DLY_DAYS")==null?"":rs.getString("DLY_DAYS"));
				fee_scd.setDly_fee(rs.getString("DLY_FEE")==null?0:Integer.parseInt(rs.getString("DLY_FEE")));
				fee_scd.setPay_cng_dt(rs.getString("PAY_CNG_DT")==null?"":rs.getString("PAY_CNG_DT"));
				fee_scd.setPay_cng_cau(rs.getString("PAY_CNG_CAU")==null?"":rs.getString("PAY_CNG_CAU"));
				fee_scd.setR_fee_est_dt(rs.getString("R_FEE_EST_DT")==null?"":rs.getString("R_FEE_EST_DT"));
				fee_scd.setIslast(rs.getString("ISLAST")==null?"":rs.getString("ISLAST"));
				fee_scd.setExt_dt(rs.getString("EXT_DT")==null?"":rs.getString("EXT_DT"));
				vt.add(fee_scd);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getFeeScd]\n"+e);
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
	 *	한 건에 대한 대여료 스케줄 쿼리
	 */
	public Vector getFeeScdRentst(String l_cd, String rent_st, String prv_mon_yn)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String where = "";

		if(prv_mon_yn.equals("0"))	where = " and tm_st2<>'2'";

		query = " select /*+use_hash(a b j)*/ "+
				" A.RENT_MNG_ID, A.RENT_L_CD, A.FEE_TM, A.RENT_ST, A.TM_ST1, A.TM_ST2, A.FEE_EST_DT, A.FEE_S_AMT, A.RENT_SEQ,"+
				" A.FEE_V_AMT, A.RC_YN, A.RC_DT, A.RC_AMT, A.DLY_DAYS, A.DLY_FEE, A.PAY_CNG_DT, A.PAY_CNG_CAU,"+
				" A.R_FEE_EST_DT, A.EXT_DT, decode(sign(B.tm-A.tm_st1), -1,'', 0,'Y') ISLAST, A.use_s_dt, A.use_e_dt"+
				" from"+
				"("+
					"select RENT_MNG_ID, RENT_L_CD, FEE_TM, RENT_ST, TM_ST1, TM_ST2, RENT_SEQ,"+
					" substr(FEE_EST_DT, 1, 4) || '-' || substr(FEE_EST_DT, 5, 2) || '-'||substr(FEE_EST_DT, 7, 2) FEE_EST_DT,"+
					" FEE_S_AMT, FEE_V_AMT, RC_YN,"+
					" substr(RC_DT, 1, 4) || '-' || substr(RC_DT, 5, 2) || '-'||substr(RC_DT, 7, 2) RC_DT,"+
					" RC_AMT, DLY_DAYS, DLY_FEE,"+
					" substr(PAY_CNG_DT, 1, 4) || '-' || substr(PAY_CNG_DT, 5, 2) || '-'||substr(PAY_CNG_DT, 7, 2) PAY_CNG_DT,"+
					" PAY_CNG_CAU,"+
					" substr(R_FEE_EST_DT, 1, 4) || '-' || substr(R_FEE_EST_DT, 5, 2) || '-'||substr(R_FEE_EST_DT, 7, 2) R_FEE_EST_DT,"+
					" decode(EXT_DT,'','',substr(EXT_DT, 1, 4) || '-' || substr(EXT_DT, 5, 2) || '-'||substr(EXT_DT, 7, 2)) EXT_DT, use_s_dt, use_e_dt"+
					" from scd_fee"+
					" where nvl(bill_yn,'Y')='Y' and tm_st1='0' and RENT_L_CD = '"+l_cd+"' and rent_st='"+rent_st+"' "+where+" order by FEE_TM"+
				" ) A,"+
				" ("+
					" select max(rent_mng_id) RENT_MNG_ID, max(rent_l_cd) RENT_L_CD, max(fee_tm) FEE_TM,"+
					" max(to_number(rent_st)) RENT_ST, max(tm_st1) TM_ST1, max(tm_st1) TM"+
					" from scd_fee"+
					" where nvl(bill_yn,'Y')='Y' and RENT_L_CD = '"+l_cd+"' and rent_st='"+rent_st+"' "+where+" and rc_yn = '1' "+
					" group by fee_tm"+
				" ) B"+
				" where"+
				" A.rent_mng_id = B.rent_mng_id(+) and"+
				" A.rent_l_cd = B.rent_l_cd(+) and"+
				" A.rent_st = B.rent_st(+) and"+
				" A.fee_tm = B.fee_tm(+)"+
				" order by to_number(FEE_TM), to_number(TM_ST1)";												
		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			while(rs.next())
			{
				FeeScdBean fee_scd = new FeeScdBean();
				fee_scd.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_scd.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_scd.setRent_seq(rs.getString("RENT_SEQ")==null?"":rs.getString("RENT_SEQ"));
				fee_scd.setTm_st1(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				fee_scd.setTm_st2(rs.getString("TM_ST2")==null?"":rs.getString("TM_ST2"));
				fee_scd.setFee_est_dt(rs.getString("FEE_EST_DT")==null?"":rs.getString("FEE_EST_DT"));
				fee_scd.setFee_s_amt(rs.getString("FEE_S_AMT")==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee_scd.setFee_v_amt(rs.getString("FEE_V_AMT")==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee_scd.setRc_yn(rs.getString("RC_YN")==null?"":rs.getString("RC_YN"));
				fee_scd.setRc_dt(rs.getString("RC_DT")==null?"":rs.getString("RC_DT"));
				fee_scd.setRc_amt(rs.getString("RC_AMT")==null?0:Integer.parseInt(rs.getString("RC_AMT")));
				fee_scd.setDly_days(rs.getString("DLY_DAYS")==null?"":rs.getString("DLY_DAYS"));
				fee_scd.setDly_fee(rs.getString("DLY_FEE")==null?0:Integer.parseInt(rs.getString("DLY_FEE")));
				fee_scd.setPay_cng_dt(rs.getString("PAY_CNG_DT")==null?"":rs.getString("PAY_CNG_DT"));
				fee_scd.setPay_cng_cau(rs.getString("PAY_CNG_CAU")==null?"":rs.getString("PAY_CNG_CAU"));
				fee_scd.setR_fee_est_dt(rs.getString("R_FEE_EST_DT")==null?"":rs.getString("R_FEE_EST_DT"));
				fee_scd.setIslast(rs.getString("ISLAST")==null?"":rs.getString("ISLAST"));
				fee_scd.setExt_dt(rs.getString("EXT_DT")==null?"":rs.getString("EXT_DT"));
				fee_scd.setUse_s_dt(rs.getString("use_s_dt")==null?"":rs.getString("use_s_dt"));
				fee_scd.setUse_e_dt(rs.getString("use_e_dt")==null?"":rs.getString("use_e_dt"));
				vt.add(fee_scd);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getFeeScd]\n"+e);
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
	 *	한 건에 대한 대여료 스케줄 쿼리
	 */
	public Vector getFeeScdEmailRentst(String l_cd, String rent_st, String prv_mon_yn)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String where = "";
		if(prv_mon_yn.equals("0"))	where = " and tm_st2<>'2'";

		query = " select /*+use_hash(a b j)*/ "+
				" A.RENT_MNG_ID, A.RENT_L_CD, A.FEE_TM, A.RENT_ST, A.TM_ST1, A.TM_ST2, A.FEE_EST_DT, A.FEE_S_AMT, A.RENT_SEQ,"+
				" A.FEE_V_AMT, A.RC_YN, A.RC_DT, A.RC_AMT, A.DLY_DAYS, A.DLY_FEE, A.PAY_CNG_DT, A.PAY_CNG_CAU,"+
				" A.R_FEE_EST_DT, A.EXT_DT, decode(sign(B.tm-A.tm_st1), -1,'', 0,'Y') ISLAST, A.use_s_dt, A.use_e_dt"+
				" from"+
				"("+
					"select RENT_MNG_ID, RENT_L_CD, FEE_TM, RENT_ST, TM_ST1, TM_ST2, RENT_SEQ,"+
					" substr(FEE_EST_DT, 1, 4) || '-' || substr(FEE_EST_DT, 5, 2) || '-'||substr(FEE_EST_DT, 7, 2) FEE_EST_DT,"+
					" FEE_S_AMT, FEE_V_AMT, RC_YN,"+
					" substr(RC_DT, 1, 4) || '-' || substr(RC_DT, 5, 2) || '-'||substr(RC_DT, 7, 2) RC_DT,"+
					" RC_AMT, DLY_DAYS, DLY_FEE,"+
					" substr(PAY_CNG_DT, 1, 4) || '-' || substr(PAY_CNG_DT, 5, 2) || '-'||substr(PAY_CNG_DT, 7, 2) PAY_CNG_DT,"+
					" PAY_CNG_CAU,"+
					" substr(R_FEE_EST_DT, 1, 4) || '-' || substr(R_FEE_EST_DT, 5, 2) || '-'||substr(R_FEE_EST_DT, 7, 2) R_FEE_EST_DT,"+
					" decode(EXT_DT,'','',substr(EXT_DT, 1, 4) || '-' || substr(EXT_DT, 5, 2) || '-'||substr(EXT_DT, 7, 2)) EXT_DT, use_s_dt, use_e_dt"+
					" from scd_fee"+
					" where tm_st1='0' and nvl(bill_yn,'Y')='Y' and RENT_L_CD = '"+l_cd+"' and rent_st='"+rent_st+"' "+where+" order by FEE_TM"+
				" ) A,"+
				" ("+
					" select max(rent_mng_id) RENT_MNG_ID, max(rent_l_cd) RENT_L_CD, max(fee_tm) FEE_TM,"+
					" max(to_number(rent_st)) RENT_ST, max(tm_st1) TM_ST1, max(tm_st1) TM"+
					" from scd_fee"+
					" where nvl(bill_yn,'Y')='Y' and RENT_L_CD = '"+l_cd+"' and rent_st='"+rent_st+"' "+where+" and rc_yn = '1' "+
					" group by fee_tm"+
				" ) B"+
				" where"+
				" A.rent_mng_id = B.rent_mng_id(+) and"+
				" A.rent_l_cd = B.rent_l_cd(+) and"+
				" A.rent_st = B.rent_st(+) and"+
				" A.fee_tm = B.fee_tm(+)"+
				" order by to_number(FEE_TM), to_number(TM_ST1)";
		
		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			while(rs.next())
			{
				FeeScdBean fee_scd = new FeeScdBean();
				fee_scd.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_scd.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_scd.setRent_seq(rs.getString("RENT_SEQ")==null?"":rs.getString("RENT_SEQ"));
				fee_scd.setTm_st1(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				fee_scd.setTm_st2(rs.getString("TM_ST2")==null?"":rs.getString("TM_ST2"));
				fee_scd.setFee_est_dt(rs.getString("FEE_EST_DT")==null?"":rs.getString("FEE_EST_DT"));
				fee_scd.setFee_s_amt(rs.getString("FEE_S_AMT")==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee_scd.setFee_v_amt(rs.getString("FEE_V_AMT")==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee_scd.setRc_yn(rs.getString("RC_YN")==null?"":rs.getString("RC_YN"));
				fee_scd.setRc_dt(rs.getString("RC_DT")==null?"":rs.getString("RC_DT"));
				fee_scd.setRc_amt(rs.getString("RC_AMT")==null?0:Integer.parseInt(rs.getString("RC_AMT")));
				fee_scd.setDly_days(rs.getString("DLY_DAYS")==null?"":rs.getString("DLY_DAYS"));
				fee_scd.setDly_fee(rs.getString("DLY_FEE")==null?0:Integer.parseInt(rs.getString("DLY_FEE")));
				fee_scd.setPay_cng_dt(rs.getString("PAY_CNG_DT")==null?"":rs.getString("PAY_CNG_DT"));
				fee_scd.setPay_cng_cau(rs.getString("PAY_CNG_CAU")==null?"":rs.getString("PAY_CNG_CAU"));
				fee_scd.setR_fee_est_dt(rs.getString("R_FEE_EST_DT")==null?"":rs.getString("R_FEE_EST_DT"));
				fee_scd.setIslast(rs.getString("ISLAST")==null?"":rs.getString("ISLAST"));
				fee_scd.setExt_dt(rs.getString("EXT_DT")==null?"":rs.getString("EXT_DT"));
				fee_scd.setUse_s_dt(rs.getString("use_s_dt")==null?"":rs.getString("use_s_dt"));
				fee_scd.setUse_e_dt(rs.getString("use_e_dt")==null?"":rs.getString("use_e_dt"));
				vt.add(fee_scd);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getFeeScdEmailRentst]\n"+e);
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
	 *	한 건에 대한 대여료 스케줄 쿼리
	 */
	public Vector getFeeScdEmailRentst2(String l_cd, String rent_st, String prv_mon_yn)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String where = "";
		if(prv_mon_yn.equals("0"))	where = " and tm_st2<>'2'";

		query = " select /*+use_hash(a b j)*/ "+
				" A.RENT_MNG_ID, A.RENT_L_CD, A.FEE_TM, A.RENT_ST, A.TM_ST1, A.TM_ST2, A.FEE_EST_DT, A.FEE_S_AMT, A.RENT_SEQ,"+
				" A.FEE_V_AMT, A.RC_YN, A.RC_DT, A.RC_AMT, A.DLY_DAYS, A.DLY_FEE, A.PAY_CNG_DT, A.PAY_CNG_CAU,"+
				" A.R_FEE_EST_DT, j.tax_dt AS EXT_DT, decode(sign(B.tm-A.tm_st1), -1,'', 0,'Y') ISLAST, A.use_s_dt, A.use_e_dt"+ //A.EXT_DT,
				" from"+
				"("+
					"select RENT_MNG_ID, RENT_L_CD, FEE_TM, RENT_ST, TM_ST1, TM_ST2, RENT_SEQ,"+
					" substr(FEE_EST_DT, 1, 4) || '-' || substr(FEE_EST_DT, 5, 2) || '-'||substr(FEE_EST_DT, 7, 2) FEE_EST_DT,"+
					" FEE_S_AMT, FEE_V_AMT, RC_YN,"+
					" substr(RC_DT, 1, 4) || '-' || substr(RC_DT, 5, 2) || '-'||substr(RC_DT, 7, 2) RC_DT,"+
					" RC_AMT, DLY_DAYS, DLY_FEE,"+
					" substr(PAY_CNG_DT, 1, 4) || '-' || substr(PAY_CNG_DT, 5, 2) || '-'||substr(PAY_CNG_DT, 7, 2) PAY_CNG_DT,"+
					" PAY_CNG_CAU,"+
					" substr(R_FEE_EST_DT, 1, 4) || '-' || substr(R_FEE_EST_DT, 5, 2) || '-'||substr(R_FEE_EST_DT, 7, 2) R_FEE_EST_DT,"+
					" decode(EXT_DT,'','',substr(EXT_DT, 1, 4) || '-' || substr(EXT_DT, 5, 2) || '-'||substr(EXT_DT, 7, 2)) EXT_DT, use_s_dt, use_e_dt"+
					" from scd_fee"+
					" where tm_st1='0' and nvl(bill_yn,'Y')='Y' and RENT_L_CD = '"+l_cd+"'  "+where+" order by FEE_TM"+//and rent_st='"+rent_st+"'
				" ) A,"+
				" ("+
					" select max(rent_mng_id) RENT_MNG_ID, max(rent_l_cd) RENT_L_CD, max(fee_tm) FEE_TM,"+
					" max(to_number(rent_st)) RENT_ST, max(tm_st1) TM_ST1, max(tm_st1) TM"+
					" from scd_fee"+
					" where nvl(bill_yn,'Y')='Y' and RENT_L_CD = '"+l_cd+"'  "+where+" and rc_yn = '1' "+ //and rent_st='"+rent_st+"'
					" group by fee_tm"+
				" ) B,"+
					
					"        ( select a.rent_l_cd, a.rent_st, a.rent_seq, a.tm as fee_tm, sum(item_supply) fee_s_amt, \n"+
					"                 max(b.item_id) item_id, max(b.item_dt) item_dt, max(b.tax_est_dt) tax_est_dt, \n"+
					"                 decode(sum(c.tax_supply),0,'',max(c.tax_no)) tax_no, "+
					"		           decode(sum(c.tax_supply),0,'',max(c.tax_dt)) tax_dt, "+
					"	               decode(sum(c.tax_supply),0,'',max(c.reg_dt)) reg_dt, "+
					"	               decode(sum(c.tax_supply),0,'',max(c.print_dt)) print_dt \n"+
					"          from   tax_item_list a, tax_item b, tax c \n"+
					"          where  a.rent_l_cd='"+l_cd+"' and a.gubun='1' \n"+
					"                 and a.item_id=b.item_id and a.item_id=c.item_id(+) and nvl(c.tax_st,'O')<>'C' \n"+
					"          group by a.rent_l_cd, a.rent_st, a.rent_seq, a.tm \n"+
					"          having sum(item_supply) > 0 "+			
					"	      ) j "+
				
				" where"+
				" A.rent_mng_id = B.rent_mng_id(+) and"+
				" A.rent_l_cd = B.rent_l_cd(+) and"+
				" A.rent_st = B.rent_st(+) and"+
				" A.fee_tm = B.fee_tm(+)"+
				" and A.rent_l_cd=j.rent_l_cd(+) and A.fee_tm=j.fee_tm(+) and A.rent_st=j.rent_st(+) and A.rent_seq=j.rent_seq(+) " +
				" order by to_number(FEE_TM), to_number(TM_ST1)";	
//System.out.println("getFeeScdEmailRentst::"+query);
		
		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			while(rs.next())
			{
				FeeScdBean fee_scd = new FeeScdBean();
				fee_scd.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_scd.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_scd.setRent_seq(rs.getString("RENT_SEQ")==null?"":rs.getString("RENT_SEQ"));
				fee_scd.setTm_st1(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				fee_scd.setTm_st2(rs.getString("TM_ST2")==null?"":rs.getString("TM_ST2"));
				fee_scd.setFee_est_dt(rs.getString("FEE_EST_DT")==null?"":rs.getString("FEE_EST_DT"));
				fee_scd.setFee_s_amt(rs.getString("FEE_S_AMT")==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee_scd.setFee_v_amt(rs.getString("FEE_V_AMT")==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee_scd.setRc_yn(rs.getString("RC_YN")==null?"":rs.getString("RC_YN"));
				fee_scd.setRc_dt(rs.getString("RC_DT")==null?"":rs.getString("RC_DT"));
				fee_scd.setRc_amt(rs.getString("RC_AMT")==null?0:Integer.parseInt(rs.getString("RC_AMT")));
				fee_scd.setDly_days(rs.getString("DLY_DAYS")==null?"":rs.getString("DLY_DAYS"));
				fee_scd.setDly_fee(rs.getString("DLY_FEE")==null?0:Integer.parseInt(rs.getString("DLY_FEE")));
				fee_scd.setPay_cng_dt(rs.getString("PAY_CNG_DT")==null?"":rs.getString("PAY_CNG_DT"));
				fee_scd.setPay_cng_cau(rs.getString("PAY_CNG_CAU")==null?"":rs.getString("PAY_CNG_CAU"));
				fee_scd.setR_fee_est_dt(rs.getString("R_FEE_EST_DT")==null?"":rs.getString("R_FEE_EST_DT"));
				fee_scd.setIslast(rs.getString("ISLAST")==null?"":rs.getString("ISLAST"));
				fee_scd.setExt_dt(rs.getString("EXT_DT")==null?"":rs.getString("EXT_DT"));
				fee_scd.setUse_s_dt(rs.getString("use_s_dt")==null?"":rs.getString("use_s_dt"));
				fee_scd.setUse_e_dt(rs.getString("use_e_dt")==null?"":rs.getString("use_e_dt"));
				vt.add(fee_scd);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getFeeScdEmailRentst]\n"+e);
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
	 *	한 건에 대한 대여료 수금 연체료 스케줄 쿼리
	 */
	public Vector getFeeDlyScd(String m_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select rent_l_cd, seq, pay_amt, etc,"+
				" substr(pay_dt, 1, 4) || '-' || substr(pay_dt, 5, 2) || '-'||substr(pay_dt, 7, 2) pay_dt"+
				" from scd_dly where rent_mng_id='"+m_id+"'"+
				" order by pay_dt";												
		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			while(rs.next())
			{
				FeeDlyScdBean fee_scd = new FeeDlyScdBean();
				fee_scd.setRent_l_cd(rs.getString("rent_l_cd")==null?"":rs.getString("rent_l_cd"));
				fee_scd.setSeq(rs.getString("seq")==null?"":rs.getString("seq"));
				fee_scd.setPay_amt(rs.getString("pay_amt")==null?0:Integer.parseInt(rs.getString("pay_amt")));
				fee_scd.setPay_dt(rs.getString("pay_dt")==null?"":rs.getString("pay_dt"));
				fee_scd.setEtc(rs.getString("etc")==null?"":rs.getString("etc"));
				vt.add(fee_scd);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getFeeDlyScd]\n"+e);
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
	 *	한 건에 대한 대여료 수금 연체료 스케줄 쿼리
	 */
	public Vector getFeeDlyScd(String m_id, String l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select rent_l_cd, seq, pay_amt, etc,"+
				" substr(pay_dt, 1, 4) || '-' || substr(pay_dt, 5, 2) || '-'||substr(pay_dt, 7, 2) pay_dt"+
				" from scd_dly where rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"'"+
				" order by pay_dt";												
		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			while(rs.next())
			{
				FeeDlyScdBean fee_scd = new FeeDlyScdBean();
				fee_scd.setRent_l_cd(rs.getString("rent_l_cd")==null?"":rs.getString("rent_l_cd"));
				fee_scd.setSeq(rs.getString("seq")==null?"":rs.getString("seq"));
				fee_scd.setPay_amt(rs.getString("pay_amt")==null?0:Integer.parseInt(rs.getString("pay_amt")));
				fee_scd.setPay_dt(rs.getString("pay_dt")==null?"":rs.getString("pay_dt"));
				fee_scd.setEtc(rs.getString("etc")==null?"":rs.getString("etc"));
				vt.add(fee_scd);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getFeeDlyScd]\n"+e);
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
	 *	한 건에 대한 대여료 스케줄 쿼리
	 */
	public Vector getFeeScd(String l_cd, String bill_yn)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select /*+use_hash(a b j)*/ "+
				" A.RENT_MNG_ID, A.RENT_L_CD, A.FEE_TM, A.RENT_ST, A.TM_ST1, A.TM_ST2, A.FEE_EST_DT, A.FEE_S_AMT, A.RENT_SEQ,"+
				" A.FEE_V_AMT, A.RC_YN, A.RC_DT, A.RC_AMT, A.DLY_DAYS, A.DLY_FEE, A.PAY_CNG_DT, A.PAY_CNG_CAU,"+
				" A.R_FEE_EST_DT, A.EXT_DT, decode(sign(B.tm-A.tm_st1), -1,'', 0,'Y') ISLAST, bill_yn"+
				" from"+
				"("+
					"select RENT_MNG_ID, RENT_L_CD, FEE_TM, RENT_ST, TM_ST1, TM_ST2, RENT_SEQ,"+
					" substr(FEE_EST_DT, 1, 4) || '-' || substr(FEE_EST_DT, 5, 2) || '-'||substr(FEE_EST_DT, 7, 2) FEE_EST_DT,"+
					" FEE_S_AMT, FEE_V_AMT, RC_YN,"+
					" substr(RC_DT, 1, 4) || '-' || substr(RC_DT, 5, 2) || '-'||substr(RC_DT, 7, 2) RC_DT,"+
					" RC_AMT, DLY_DAYS, DLY_FEE,"+
					" substr(PAY_CNG_DT, 1, 4) || '-' || substr(PAY_CNG_DT, 5, 2) || '-'||substr(PAY_CNG_DT, 7, 2) PAY_CNG_DT,"+
					" PAY_CNG_CAU, bill_yn,"+
					" substr(R_FEE_EST_DT, 1, 4) || '-' || substr(R_FEE_EST_DT, 5, 2) || '-'||substr(R_FEE_EST_DT, 7, 2) R_FEE_EST_DT,"+
					" decode(EXT_DT,'','',substr(EXT_DT, 1, 4) || '-' || substr(EXT_DT, 5, 2) || '-'||substr(EXT_DT, 7, 2)) EXT_DT"+
					" from scd_fee"+
					" where RENT_L_CD = '"+l_cd+"' order by FEE_TM"+
				" ) A,"+
				" ("+
					" select max(rent_mng_id) RENT_MNG_ID, max(rent_l_cd) RENT_L_CD, max(fee_tm) FEE_TM,"+
					" max(to_number(rent_st)) RENT_ST, max(tm_st1) TM_ST1, max(tm_st1) TM"+
					" from scd_fee"+
					" where RENT_L_CD = '"+l_cd+"' and rc_yn = '1' "+
					" group by fee_tm"+
				" ) B, cls_cont C"+
				" where"+
				" A.rent_mng_id = B.rent_mng_id(+) and"+
				" A.rent_l_cd = B.rent_l_cd(+) and"+
				" A.rent_st = B.rent_st(+) and"+
				" A.fee_tm = B.fee_tm(+) and nvl(A.bill_yn,'Y')='Y' and "+
				" A.rent_mng_id = C.rent_mng_id and A.rent_l_cd = C.rent_l_cd and C.cls_st = '2'"+
				" order by to_number(FEE_TM) desc, to_number(TM_ST1) desc";												
		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			while(rs.next())
			{
				FeeScdBean fee_scd = new FeeScdBean();
				fee_scd.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_scd.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_scd.setRent_seq(rs.getString("RENT_SEQ")==null?"":rs.getString("RENT_SEQ"));
				fee_scd.setTm_st1(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				fee_scd.setTm_st2(rs.getString("TM_ST2")==null?"":rs.getString("TM_ST2"));
				fee_scd.setFee_est_dt(rs.getString("FEE_EST_DT")==null?"":rs.getString("FEE_EST_DT"));
				fee_scd.setFee_s_amt(rs.getString("FEE_S_AMT")==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee_scd.setFee_v_amt(rs.getString("FEE_V_AMT")==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee_scd.setRc_yn(rs.getString("RC_YN")==null?"":rs.getString("RC_YN"));
				fee_scd.setRc_dt(rs.getString("RC_DT")==null?"":rs.getString("RC_DT"));
				fee_scd.setRc_amt(rs.getString("RC_AMT")==null?0:Integer.parseInt(rs.getString("RC_AMT")));
				fee_scd.setDly_days(rs.getString("DLY_DAYS")==null?"":rs.getString("DLY_DAYS"));
				fee_scd.setDly_fee(rs.getString("DLY_FEE")==null?0:Integer.parseInt(rs.getString("DLY_FEE")));
				fee_scd.setPay_cng_dt(rs.getString("PAY_CNG_DT")==null?"":rs.getString("PAY_CNG_DT"));
				fee_scd.setPay_cng_cau(rs.getString("PAY_CNG_CAU")==null?"":rs.getString("PAY_CNG_CAU"));
				fee_scd.setR_fee_est_dt(rs.getString("R_FEE_EST_DT")==null?"":rs.getString("R_FEE_EST_DT"));
				fee_scd.setIslast(rs.getString("ISLAST")==null?"":rs.getString("ISLAST"));
				fee_scd.setExt_dt(rs.getString("EXT_DT")==null?"":rs.getString("EXT_DT"));
				vt.add(fee_scd);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getFeeScd]\n"+e);
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
	 *	한 건에 대한 대여료 스케줄 쿼리
	 */
	public Vector getFeeScdCng(String l_cd, String rent_st, String rc_yn)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select * from scd_fee where rent_l_cd='"+l_cd+"'";// and tm_st1='0'

		if(rc_yn.equals("0"))	query += " and rc_yn='0'";

//		if(rent_st.equals(""))	query += " and tm_st2='2'";

		if(!rent_st.equals(""))	query += " and tm_st2<>'2' and rent_st='"+rent_st+"'";

		query += " order by to_number(FEE_TM), to_number(TM_ST1)";												

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			while(rs.next())
			{
				FeeScdBean fee_scd = new FeeScdBean();
				fee_scd.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_scd.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_scd.setRent_seq(rs.getString("RENT_SEQ")==null?"":rs.getString("RENT_SEQ"));
				fee_scd.setTm_st1(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				fee_scd.setTm_st2(rs.getString("TM_ST2")==null?"":rs.getString("TM_ST2"));
				fee_scd.setFee_est_dt(rs.getString("FEE_EST_DT")==null?"":rs.getString("FEE_EST_DT"));
				fee_scd.setFee_s_amt(rs.getString("FEE_S_AMT")==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee_scd.setFee_v_amt(rs.getString("FEE_V_AMT")==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee_scd.setRc_yn(rs.getString("RC_YN")==null?"":rs.getString("RC_YN"));
				fee_scd.setRc_dt(rs.getString("RC_DT")==null?"":rs.getString("RC_DT"));
				fee_scd.setRc_amt(rs.getString("RC_AMT")==null?0:Integer.parseInt(rs.getString("RC_AMT")));
				fee_scd.setDly_days(rs.getString("DLY_DAYS")==null?"":rs.getString("DLY_DAYS"));
				fee_scd.setDly_fee(rs.getString("DLY_FEE")==null?0:Integer.parseInt(rs.getString("DLY_FEE")));
				fee_scd.setPay_cng_dt(rs.getString("PAY_CNG_DT")==null?"":rs.getString("PAY_CNG_DT"));
				fee_scd.setPay_cng_cau(rs.getString("PAY_CNG_CAU")==null?"":rs.getString("PAY_CNG_CAU"));
				fee_scd.setR_fee_est_dt(rs.getString("R_FEE_EST_DT")==null?"":rs.getString("R_FEE_EST_DT"));
				fee_scd.setReq_dt(rs.getString("REQ_DT")==null?"":rs.getString("REQ_DT"));
				fee_scd.setR_req_dt(rs.getString("R_REQ_DT")==null?"":rs.getString("R_REQ_DT"));
				fee_scd.setTax_out_dt(rs.getString("TAX_OUT_DT")==null?"":rs.getString("TAX_OUT_DT"));
				fee_scd.setUse_s_dt(rs.getString("USE_S_DT")==null?"":rs.getString("USE_S_DT"));
				fee_scd.setUse_e_dt(rs.getString("USE_E_DT")==null?"":rs.getString("USE_E_DT"));
				fee_scd.setAdate(rs.getString("adate")==null?"":rs.getString("adate"));
				fee_scd.setPay_st(rs.getString("pay_st")==null?"":rs.getString("pay_st"));
				fee_scd.setIncom_dt(rs.getString("incom_dt")==null?"":rs.getString("incom_dt"));
				fee_scd.setIncom_seq(rs.getString("incom_seq")==null?0:Integer.parseInt(rs.getString("incom_seq")));

				vt.add(fee_scd);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getFeeScd]\n"+e);
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
	 *	스케줄 변경이력 리스트
	 */
	public Vector getFeeScdCngList(String m_id, String l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select rent_mng_id, rent_l_cd, fee_tm, all_st, gubun, b_value, a_value,"+
//				" to_char(cng_dt,'YYYYMMDD') cng_dt, "+
				" to_char(cng_dt,'YYYYMMDDhh24miss') cng_dt, "+
//				" cng_dt, "+
				" cng_cau, cng_id"+
				" from scd_fee_cng where rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"' order by cng_dt desc";



		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			while(rs.next())
			{
				FeeScdCngBean fee_scd = new FeeScdCngBean();
				fee_scd.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_scd.setAll_st(rs.getString("all_st")==null?"":rs.getString("all_st"));
				fee_scd.setGubun(rs.getString("gubun")==null?"":rs.getString("gubun"));
				fee_scd.setB_value(rs.getString("b_value")==null?"":rs.getString("b_value"));
				fee_scd.setA_value(rs.getString("a_value")==null?"":rs.getString("a_value"));
				fee_scd.setCng_dt(rs.getString("cng_dt")==null?"":rs.getString("cng_dt"));
				fee_scd.setCng_cau(rs.getString("cng_cau")==null?"":rs.getString("cng_cau"));
				fee_scd.setCng_id(rs.getString("cng_id")==null?"":rs.getString("cng_id"));
				vt.add(fee_scd);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getFeeScdCngList]\n"+e);
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
	 *	스케줄 계산서발행 일시중지 리스트
	 */
	public int getFeeScdDlyCnt(String m_id, String l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		int cnt = 0;
		String query = "";
		query = " select count(0) "+
				" from scd_fee where rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"' and rc_yn='0' and fee_est_dt < to_char(sysdate,'YYYYMMDD')";

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			if(rs.next())
			{
				cnt = rs.getInt(1);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getFeeScdDlyCnt]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return cnt;
		}
	}

	/**
	 *	스케줄 계산서발행 일시중지 리스트
	 */
	public int getFeeScdDlyClientCnt(String client_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		int cnt = 0;
		String query = "";
		query = " select count(0) "+
				" from scd_fee a, cont b where a.rc_yn='0' and a.fee_est_dt < to_char(sysdate,'YYYYMMDD') and a.bill_yn='Y'"+
				" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.client_id='"+client_id+"'";

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			if(rs.next())
			{
				cnt = rs.getInt(1);
			}
			rs.close();
			stmt.close();

		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getFeeScdDlyClientCnt]\n"+e);
			System.out.println("[AddFeeDatabase:getFeeScdDlyClientCnt]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return cnt;
		}
	}

	/**
	 *	계약해지후 재등록을 위해 장래미납대여료스케줄만 쿼리(연체인 스케줄)
	 */
	public Vector getFeeScdDly(String m_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select"+
				" RENT_MNG_ID, RENT_L_CD, FEE_TM, RENT_ST, TM_ST1, TM_ST2, RENT_SEQ,"+
				" substr(FEE_EST_DT, 1, 4) || '-' || substr(FEE_EST_DT, 5, 2) || '-'||substr(FEE_EST_DT, 7, 2) FEE_EST_DT,"+
				" FEE_S_AMT, FEE_V_AMT, RC_YN,"+
				" substr(RC_DT, 1, 4) || '-' || substr(RC_DT, 5, 2) || '-'||substr(RC_DT, 7, 2) RC_DT,"+
				" RC_AMT, DLY_DAYS, DLY_FEE,"+
				" substr(PAY_CNG_DT, 1, 4) || '-' || substr(PAY_CNG_DT, 5, 2) || '-'||substr(PAY_CNG_DT, 7, 2) PAY_CNG_DT,"+
				" PAY_CNG_CAU,"+
				" substr(R_FEE_EST_DT, 1, 4) || '-' || substr(R_FEE_EST_DT, 5, 2) || '-'||substr(R_FEE_EST_DT, 7, 2) R_FEE_EST_DT"+
				" from scd_fee"+
				" where rent_mng_id='"+m_id+"'"+
				" and rc_yn ='0'"+
				" and dly_days !='0'"+
				" order by to_number(fee_tm), to_number(tm_st1)";						
		try {
			stmt = conn.createStatement();
		   	rs = stmt.executeQuery(query);    	
			while(rs.next())
			{
				FeeScdBean fee_scd = new FeeScdBean();
				fee_scd.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_scd.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_scd.setRent_seq(rs.getString("RENT_SEQ")==null?"":rs.getString("RENT_SEQ"));
				fee_scd.setTm_st1(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				fee_scd.setTm_st2(rs.getString("TM_ST2")==null?"":rs.getString("TM_ST2"));
				fee_scd.setFee_est_dt(rs.getString("FEE_EST_DT")==null?"":rs.getString("FEE_EST_DT"));
				fee_scd.setFee_s_amt(rs.getString("FEE_S_AMT")==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee_scd.setFee_v_amt(rs.getString("FEE_V_AMT")==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee_scd.setRc_yn(rs.getString("RC_YN")==null?"":rs.getString("RC_YN"));
				fee_scd.setRc_dt(rs.getString("RC_DT")==null?"":rs.getString("RC_DT"));
				fee_scd.setRc_amt(rs.getString("RC_AMT")==null?0:Integer.parseInt(rs.getString("RC_AMT")));
				fee_scd.setDly_days(rs.getString("DLY_DAYS")==null?"":rs.getString("DLY_DAYS"));
				fee_scd.setDly_fee(rs.getString("DLY_FEE")==null?0:Integer.parseInt(rs.getString("DLY_FEE")));
				fee_scd.setPay_cng_dt(rs.getString("PAY_CNG_DT")==null?"":rs.getString("PAY_CNG_DT"));
				fee_scd.setPay_cng_cau(rs.getString("PAY_CNG_CAU")==null?"":rs.getString("PAY_CNG_CAU"));
				fee_scd.setR_fee_est_dt(rs.getString("R_FEE_EST_DT")==null?"":rs.getString("R_FEE_EST_DT"));
				vt.add(fee_scd);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getFeeScdDly]\n"+e);
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
	 *	계약해지후 재등록을 위해 장래미납대여료스케줄만 쿼리(연체아니면서 미수금인 스케줄)
	 */
	public Vector getFeeScdForward(String m_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select"+
				" RENT_MNG_ID, RENT_L_CD, FEE_TM, RENT_ST, TM_ST1, TM_ST2, RENT_SEQ,"+
				" substr(FEE_EST_DT, 1, 4) || '-' || substr(FEE_EST_DT, 5, 2) || '-'||substr(FEE_EST_DT, 7, 2) FEE_EST_DT,"+
				" FEE_S_AMT, FEE_V_AMT, RC_YN,"+
				" substr(RC_DT, 1, 4) || '-' || substr(RC_DT, 5, 2) || '-'||substr(RC_DT, 7, 2) RC_DT,"+
				" RC_AMT, DLY_DAYS, DLY_FEE,"+
				" substr(PAY_CNG_DT, 1, 4) || '-' || substr(PAY_CNG_DT, 5, 2) || '-'||substr(PAY_CNG_DT, 7, 2) PAY_CNG_DT,"+
				" PAY_CNG_CAU,"+
				" substr(R_FEE_EST_DT, 1, 4) || '-' || substr(R_FEE_EST_DT, 5, 2) || '-'||substr(R_FEE_EST_DT, 7, 2) R_FEE_EST_DT,"+
				" bill_yn, dly_chk, req_dt, r_req_dt, tax_out_dt, use_s_dt, use_e_dt, adate, pay_st, incom_dt, incom_seq "+
				" from scd_fee"+
				" where rent_mng_id='"+m_id+"'"+
				" and sign(trunc(to_date(r_fee_est_dt, 'YYYYMMDD')-sysdate))!= -1"+
				" and rc_yn ='0'"+
				" order by to_number(fee_tm), to_number(tm_st1)";						
		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			while(rs.next())
			{
				FeeScdBean fee_scd = new FeeScdBean();
				fee_scd.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_scd.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_scd.setRent_seq(rs.getString("RENT_SEQ")==null?"":rs.getString("RENT_SEQ"));
				fee_scd.setTm_st1(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				fee_scd.setTm_st2(rs.getString("TM_ST2")==null?"":rs.getString("TM_ST2"));
				fee_scd.setFee_est_dt(rs.getString("FEE_EST_DT")==null?"":rs.getString("FEE_EST_DT"));
				fee_scd.setFee_s_amt(rs.getString("FEE_S_AMT")==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee_scd.setFee_v_amt(rs.getString("FEE_V_AMT")==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee_scd.setRc_yn(rs.getString("RC_YN")==null?"":rs.getString("RC_YN"));
				fee_scd.setRc_dt(rs.getString("RC_DT")==null?"":rs.getString("RC_DT"));
				fee_scd.setRc_amt(rs.getString("RC_AMT")==null?0:Integer.parseInt(rs.getString("RC_AMT")));
				fee_scd.setDly_days(rs.getString("DLY_DAYS")==null?"":rs.getString("DLY_DAYS"));
				fee_scd.setDly_fee(rs.getString("DLY_FEE")==null?0:Integer.parseInt(rs.getString("DLY_FEE")));
				fee_scd.setPay_cng_dt(rs.getString("PAY_CNG_DT")==null?"":rs.getString("PAY_CNG_DT"));
				fee_scd.setPay_cng_cau(rs.getString("PAY_CNG_CAU")==null?"":rs.getString("PAY_CNG_CAU"));
				fee_scd.setR_fee_est_dt(rs.getString("R_FEE_EST_DT")==null?"":rs.getString("R_FEE_EST_DT"));
				fee_scd.setBill_yn(rs.getString("bill_yn"));
				fee_scd.setDly_chk(rs.getString("dly_chk"));
				fee_scd.setReq_dt(rs.getString("req_dt"));
				fee_scd.setR_req_dt(rs.getString("r_req_dt"));
				fee_scd.setTax_out_dt(rs.getString("tax_out_dt"));
				fee_scd.setUse_s_dt(rs.getString("use_s_dt"));
				fee_scd.setUse_e_dt(rs.getString("use_e_dt"));
				fee_scd.setAdate(rs.getString("adate")==null?"":rs.getString("adate"));
				fee_scd.setPay_st(rs.getString("pay_st")==null?"":rs.getString("pay_st"));
				fee_scd.setIncom_dt(rs.getString("incom_dt")==null?"":rs.getString("incom_dt"));
				fee_scd.setIncom_seq(rs.getString("incom_seq")==null?0:Integer.parseInt(rs.getString("incom_seq")));
				vt.add(fee_scd);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getFeeScdForward]\n"+e);
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
	 *	계약해지후 재등록을 위해 장래미납대여료스케줄만 쿼리(연체아니면서 미수금인 스케줄)
	 */
	public Vector getFeeScdForward(String m_id, String fee_fst_dt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select"+
				" RENT_MNG_ID, RENT_L_CD, FEE_TM, RENT_ST, TM_ST1, TM_ST2, RENT_SEQ,"+
				" substr(FEE_EST_DT, 1, 4) || '-' || substr(FEE_EST_DT, 5, 2) || '-'||substr(FEE_EST_DT, 7, 2) FEE_EST_DT,"+
				" FEE_S_AMT, FEE_V_AMT, RC_YN,"+
				" substr(RC_DT, 1, 4) || '-' || substr(RC_DT, 5, 2) || '-'||substr(RC_DT, 7, 2) RC_DT,"+
				" RC_AMT, DLY_DAYS, DLY_FEE,"+
				" substr(PAY_CNG_DT, 1, 4) || '-' || substr(PAY_CNG_DT, 5, 2) || '-'||substr(PAY_CNG_DT, 7, 2) PAY_CNG_DT,"+
				" PAY_CNG_CAU,"+
				" substr(R_FEE_EST_DT, 1, 4) || '-' || substr(R_FEE_EST_DT, 5, 2) || '-'||substr(R_FEE_EST_DT, 7, 2) R_FEE_EST_DT,"+
				" bill_yn, dly_chk, req_dt, r_req_dt, tax_out_dt, use_s_dt, use_e_dt, adate, pay_st, incom_dt, incom_seq "+
				" from scd_fee"+
				" where rent_mng_id='"+m_id+"'"+
				" and fee_est_dt >= '"+fee_fst_dt+"'"+
				" and rc_yn ='0'"+
				" order by to_number(fee_tm), to_number(tm_st1)";						
		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			while(rs.next())
			{
				FeeScdBean fee_scd = new FeeScdBean();
				fee_scd.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_scd.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_scd.setRent_seq(rs.getString("RENT_SEQ")==null?"":rs.getString("RENT_SEQ"));
				fee_scd.setTm_st1(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				fee_scd.setTm_st2(rs.getString("TM_ST2")==null?"":rs.getString("TM_ST2"));
				fee_scd.setFee_est_dt(rs.getString("FEE_EST_DT")==null?"":rs.getString("FEE_EST_DT"));
				fee_scd.setFee_s_amt(rs.getString("FEE_S_AMT")==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee_scd.setFee_v_amt(rs.getString("FEE_V_AMT")==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee_scd.setRc_yn(rs.getString("RC_YN")==null?"":rs.getString("RC_YN"));
				fee_scd.setRc_dt(rs.getString("RC_DT")==null?"":rs.getString("RC_DT"));
				fee_scd.setRc_amt(rs.getString("RC_AMT")==null?0:Integer.parseInt(rs.getString("RC_AMT")));
				fee_scd.setDly_days(rs.getString("DLY_DAYS")==null?"":rs.getString("DLY_DAYS"));
				fee_scd.setDly_fee(rs.getString("DLY_FEE")==null?0:Integer.parseInt(rs.getString("DLY_FEE")));
				fee_scd.setPay_cng_dt(rs.getString("PAY_CNG_DT")==null?"":rs.getString("PAY_CNG_DT"));
				fee_scd.setPay_cng_cau(rs.getString("PAY_CNG_CAU")==null?"":rs.getString("PAY_CNG_CAU"));
				fee_scd.setR_fee_est_dt(rs.getString("R_FEE_EST_DT")==null?"":rs.getString("R_FEE_EST_DT"));
				fee_scd.setBill_yn(rs.getString("bill_yn"));
				fee_scd.setDly_chk(rs.getString("dly_chk"));
				fee_scd.setReq_dt(rs.getString("req_dt"));
				fee_scd.setR_req_dt(rs.getString("r_req_dt"));
				fee_scd.setTax_out_dt(rs.getString("tax_out_dt"));
				fee_scd.setUse_s_dt(rs.getString("use_s_dt"));
				fee_scd.setUse_e_dt(rs.getString("use_e_dt"));
				fee_scd.setAdate(rs.getString("adate")==null?"":rs.getString("adate"));
				fee_scd.setPay_st(rs.getString("pay_st")==null?"":rs.getString("pay_st"));
				fee_scd.setIncom_dt(rs.getString("incom_dt")==null?"":rs.getString("incom_dt"));
				fee_scd.setIncom_seq(rs.getString("incom_seq")==null?0:Integer.parseInt(rs.getString("incom_seq")));
				
				vt.add(fee_scd);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getFeeScdForward(String m_id, String fee_fst_dt)]\n"+e);
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
	 *	해지-재계약인 경우, 대여료 스케줄의 미납스케줄을 신규계약번호로 세팅한다.
	 *	(영업소 변경)
	 */
	public boolean updateReconFeeScd(String rent_mng_id, String old_rent_l_cd, String new_rent_l_cd)
	{
		int flag = 0;
		Vector scds = getFeeScdForward(rent_mng_id);
		int scd_size = scds.size();
		for(int i = 0 ; i < scd_size ; i++)
		{
			FeeScdBean scd = (FeeScdBean)scds.elementAt(i);
			scd.setRent_l_cd(new_rent_l_cd);
		
			if(!updateFeeScd(scd, old_rent_l_cd))	flag += 1;
		}
		if(flag == 0)	return true;
		else			return false;
	}	
	
	//계약수정시 대여스케줄 등록시 : 연장대여료 아이디 조회
	public String getFeeTotTm(String m_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		String rtnStr = "";
		String query = "select max(to_number(nvl(fee_tm, '0'))) TOT_TM from scd_fee where rent_mng_id = '"+m_id+"'";
		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
			while(rs.next())
			{
				rtnStr = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getFeeTotTm]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return rtnStr;
		}				
	}
	
	/**
	 *	한 건에 대한 대여료 스케줄 중 회차만 쿼리
	 */
	public Vector getFeeScdTm(String m_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = 	" select fee_tm from scd_fee"+
						" where rc_yn = '0' and tm_st1 ='0' and rent_mng_id = '"+m_id+"'"+
						" order by to_number(fee_tm)";
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
			System.out.println("[AddFeeDatabase:getFeeScdTm]\n"+e);
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
	 *	대여료스케줄 통계(건별)
	 */
	//public Hashtable getFeeScdStat(String m_id, String l_cd)
	public Hashtable getFeeScdStat(String m_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		query = " select"+
				" max(NC) NC, max(NS) NS, max(NV) NV, max(NS)+max(NV) N,"+
				" max(RC) RC, max(RS) RS, max(RV) RV, max(RS)+max(RV) R,"+
				" max(DC) DC, max(DT) DT, max(NC)+ max(RC) TC, max(NS)+ max(RS) TS, max(NV)+ max(RV) TV,"+
				" max(NS)+ max(RS)+max(NV)+ max(RV) TOT"+
				" from"+
				" ("+
					" select count(0) NC, sum(fee_s_amt) NS, sum(fee_v_amt) NV, 0 RC, 0 RS, 0 RV, 0 DC, 0 DT"+
					" from scd_fee"+
					" where rc_yn = '0' and"+
					" rent_mng_id = '"+m_id+"'"+
					" union"+
					" select 0 NC, 0 NS, 0 NV, count(0) RC, sum(trunc(rc_amt/1.1)) RS, sum(rc_amt-trunc(rc_amt/1.1)) RV, 0 DC, 0 DT"+
					" from scd_fee"+
					" where rc_yn = '1' and"+
					" rent_mng_id = '"+m_id+"'"+
					" union"+
					" select 0 NC, 0 NS, 0 NV, 0 RC, 0 RS, 0 RV, count(0) DC, sum(dly_fee) DT"+
					" from scd_fee"+
					" where rent_mng_id = '"+m_id+"' and"+
					" nvl(to_number(dly_days), 0) > 0 "+
				" )";
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
			System.out.println("[AddFeeDatabase:getFeeScdStat]\n"+e);
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
	 *	대여료스케줄 통계(건별)
	 */
	public Hashtable getFeeScdStat(String m_id, String l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		query = " select"+
				" max(NC) NC, max(NS) NS, max(NV) NV, max(NS)+max(NV) N,"+//미수금
				" max(RC) RC, max(RS) RS, max(RV) RV, max(RS)+max(RV) R,"+//수금
				" max(MC) MC, max(MS) MS, max(MV) MV, max(MS)+max(MV) M,"+//미도래분
				" max(DC) DC, max(DT) DT, "+//연체
				" max(NC)+ max(RC)+max(MC) TC, max(NS)+ max(RS)+max(MS) TS, max(NV)+ max(RV)+max(MV) TV,"+
				" max(NS)+ max(RS)+max(MS)+max(NV)+ max(RV)+max(MV) TOT"+//합계
				" from"+
				" ("+
					//미수금
					" select count(0) NC, sum(fee_s_amt) NS, sum(fee_v_amt) NV, 0 RC, 0 RS, 0 RV, 0 MC, 0 MS, 0 MV, 0 DC, 0 DT"+
					" from scd_fee"+
					" where rc_yn = '0' and r_fee_est_dt <= to_char(sysdate,'YYYYMMDD') and "+
					" rent_mng_id = '"+m_id+"' and rent_l_cd='"+l_cd+"'"+
					" union"+
					//수금
					" select 0 NC, 0 NS, 0 NV, count(0) RC, sum(trunc(rc_amt/1.1)) RS, sum(rc_amt-trunc(rc_amt/1.1)) RV, 0 MC, 0 MS, 0 MV, 0 DC, 0 DT"+
					" from scd_fee"+
					" where rc_yn = '1' and"+
					" rent_mng_id = '"+m_id+"' and rent_l_cd='"+l_cd+"'"+
					" union"+
					//미도래분
					" select 0 NC, 0 NS, 0 NV, 0 RC, 0 RS, 0 RV, count(0) MC, sum(fee_s_amt) MS, sum(fee_v_amt) MV, 0 DC, 0 DT"+
					" from scd_fee"+
					" where rc_yn = '0' and r_fee_est_dt > to_char(sysdate,'YYYYMMDD') and "+
					" rent_mng_id = '"+m_id+"' and rent_l_cd='"+l_cd+"'"+
					" union"+
					//연체료
					" select 0 NC, 0 NS, 0 NV, 0 RC, 0 RS, 0 RV, 0 MC, 0 MS, 0 MV, count(0) DC, sum(dly_fee) DT"+
					" from scd_fee"+
					" where rent_mng_id = '"+m_id+"' and rent_l_cd='"+l_cd+"' and"+
					" nvl(to_number(dly_days), 0) > 0 "+
				" )";
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
			System.out.println("[AddFeeDatabase:getFeeScdStat]\n"+e);
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
	 *	대여료스케줄 통계(건별) - 연체료 수금 포함(2003-07-25)
	 */
	public Hashtable getFeeScdStat2(String m_id, String l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		query = " select"+
				" max(NC) NC, max(NS) NS, max(NV) NV,"+//미수금
				" max(RC) RC, max(RS) RS, max(RV) RV,"+//수금
				" max(MC) MC, max(MS) MS, max(MV) MV,"+//미도래분
				" sum(DC) DC, sum(DT) DT, "+//연체
				" max(DT2) DT2"+//연체-수금
				" from"+
				" ("+
					//미수금
					" select count(0) NC, sum(fee_s_amt) NS, sum(fee_v_amt) NV, 0 RC, 0 RS, 0 RV, 0 MC, 0 MS, 0 MV, 0 DC, 0 DT, 0 DT2"+
					" from scd_fee"+
					" where nvl(bill_yn,'Y')='Y' and rc_yn = '0' and r_fee_est_dt <= to_char(sysdate,'YYYYMMDD') and "+
					" rent_mng_id = '"+m_id+"' and rent_l_cd='"+l_cd+"'"+
					" union"+
					//수금
					" select 0 NC, 0 NS, 0 NV, count(0) RC, sum(trunc(rc_amt/1.1)) RS, sum(rc_amt-trunc(rc_amt/1.1)) RV, 0 MC, 0 MS, 0 MV, 0 DC, 0 DT, 0 DT2"+
					" from scd_fee"+
					" where nvl(bill_yn,'Y')='Y' and rc_yn = '1' and"+
					" rent_mng_id = '"+m_id+"' and rent_l_cd='"+l_cd+"'"+
					" union"+
					//미도래분
					" select 0 NC, 0 NS, 0 NV, 0 RC, 0 RS, 0 RV, count(0) MC, sum(fee_s_amt) MS, sum(fee_v_amt) MV, 0 DC, 0 DT, 0 DT2"+
					" from scd_fee"+
					" where nvl(bill_yn,'Y')='Y' and rc_yn = '0' and r_fee_est_dt > to_char(sysdate,'YYYYMMDD') and "+
					" rent_mng_id = '"+m_id+"' and rent_l_cd='"+l_cd+"'"+
					" union"+
					//연체료
					" select 0 NC, 0 NS, 0 NV, 0 RC, 0 RS, 0 RV, 0 MC, 0 MS, 0 MV, count(0) DC, sum(dly_fee) DT, 0 DT2"+
					" from scd_fee"+
					" where nvl(bill_yn,'Y')='Y' and rent_mng_id = '"+m_id+"' and rent_l_cd='"+l_cd+"' and"+
					" nvl(to_number(dly_days), 0) > 0 "+
					" union"+
					//연체료-수금
					" select 0 NC, 0 NS, 0 NV, 0 RC, 0 RS, 0 RV, 0 MC, 0 MS, 0 MV, 0 DC, 0 DT, sum(pay_amt) DT2"+
					" from scd_dly"+
					" where rent_mng_id = '"+m_id+"' and rent_l_cd='"+l_cd+"' "+
				" )";

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
			System.out.println("[AddFeeDatabase:getFeeScdStat2]\n"+e);
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
	 *	대여료스케줄 통계(건별) - 연체료 수금 포함(2003-07-25)
	 */
	public Hashtable getFeeScdStatPrint(String m_id, String l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		query = " select"+
				" max(NC) NC, max(NS) NS, max(NV) NV,"+//미수금
				" max(RC) RC, max(RS) RS, max(RV) RV,"+//수금
				" max(MC) MC, max(MS) MS, max(MV) MV,"+//미도래분
				" max(DC) DC, max(DT) DT, "+//연체
				" max(DT2) DT2"+//연체-수금
				" from"+
				" ("+
					//미수금
					" select count(0) NC, sum(fee_s_amt) NS, sum(fee_v_amt) NV, 0 RC, 0 RS, 0 RV, 0 MC, 0 MS, 0 MV, 0 DC, 0 DT, 0 DT2"+
					" from scd_fee"+
					" where rc_yn = '0' and r_fee_est_dt <= to_char(sysdate,'YYYYMMDD') and "+//nvl(bill_yn,'Y')='Y' and 
					" rent_mng_id = '"+m_id+"' and rent_l_cd='"+l_cd+"' and tm_st2 != 4"+
					" union"+
					//수금
					" select 0 NC, 0 NS, 0 NV, count(0) RC, sum(trunc(rc_amt/1.1)) RS, sum(rc_amt-trunc(rc_amt/1.1)) RV, 0 MC, 0 MS, 0 MV, 0 DC, 0 DT, 0 DT2"+
					" from scd_fee"+
					" where rc_yn = '1' and"+//nvl(bill_yn,'Y')='Y' and 
					" rent_mng_id = '"+m_id+"' and rent_l_cd='"+l_cd+"' and tm_st2 != 4"+
					" union"+
					//미도래분
					" select 0 NC, 0 NS, 0 NV, 0 RC, 0 RS, 0 RV, count(0) MC, sum(fee_s_amt) MS, sum(fee_v_amt) MV, 0 DC, 0 DT, 0 DT2"+
					" from scd_fee"+
					" where rc_yn = '0' and r_fee_est_dt > to_char(sysdate,'YYYYMMDD') and "+//nvl(bill_yn,'Y')='Y' and 
					" rent_mng_id = '"+m_id+"' and rent_l_cd='"+l_cd+"' and tm_st2 != 4"+
					" union"+
					//연체료
					" select 0 NC, 0 NS, 0 NV, 0 RC, 0 RS, 0 RV, 0 MC, 0 MS, 0 MV, count(0) DC, sum(dly_fee) DT, 0 DT2"+
					" from scd_fee"+
					" where rent_mng_id = '"+m_id+"' and rent_l_cd='"+l_cd+"' and tm_st2 != 4 "+
					" and dly_fee > 0 "+
					" union"+
					//연체료-수금
					" select 0 NC, 0 NS, 0 NV, 0 RC, 0 RS, 0 RV, 0 MC, 0 MS, 0 MV, 0 DC, 0 DT, sum(pay_amt) DT2"+
					" from scd_dly"+
					" where rent_mng_id = '"+m_id+"' and rent_l_cd='"+l_cd+"'"+
				" )";
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
			System.out.println("[AddFeeDatabase:getFeeScdStat2]\n"+e);
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
	 *	대여료스케줄 통계(건별) - 연체료 수금 포함(2003-07-25)
	 */
	public Hashtable getFeeScdStatPrintAll(String m_id, String l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		query = " select"+
				" max(NC) NC, max(NS) NS, max(NV) NV,"+//미수금
				" max(RC) RC, max(RS) RS, max(RV) RV,"+//수금
				" max(MC) MC, max(MS) MS, max(MV) MV,"+//미도래분
				" max(DC) DC, max(DT) DT, "+//연체
				" max(DT2) DT2"+//연체-수금
				" from"+
				" ("+
					//미수금
					" select count(0) NC, sum(fee_s_amt) NS, sum(fee_v_amt) NV, 0 RC, 0 RS, 0 RV, 0 MC, 0 MS, 0 MV, 0 DC, 0 DT, 0 DT2"+
					" from scd_fee"+
					" where rc_yn = '0' and r_fee_est_dt <= to_char(sysdate,'YYYYMMDD') and "+//nvl(bill_yn,'Y')='Y' and 
					" rent_mng_id = '"+m_id+"'"+// and rent_l_cd='"+l_cd+"'
					" union"+
					//수금
					" select 0 NC, 0 NS, 0 NV, count(0) RC, sum(trunc(rc_amt/1.1)) RS, sum(rc_amt-trunc(rc_amt/1.1)) RV, 0 MC, 0 MS, 0 MV, 0 DC, 0 DT, 0 DT2"+
					" from scd_fee"+
					" where rc_yn = '1' and"+//nvl(bill_yn,'Y')='Y' and 
					" rent_mng_id = '"+m_id+"'"+// and rent_l_cd='"+l_cd+"'
					" union"+
					//미도래분
					" select 0 NC, 0 NS, 0 NV, 0 RC, 0 RS, 0 RV, count(0) MC, sum(fee_s_amt) MS, sum(fee_v_amt) MV, 0 DC, 0 DT, 0 DT2"+
					" from scd_fee"+
					" where rc_yn = '0' and r_fee_est_dt > to_char(sysdate,'YYYYMMDD') and "+//nvl(bill_yn,'Y')='Y' and 
					" rent_mng_id = '"+m_id+"'"+// and rent_l_cd='"+l_cd+"'
					" union"+
					//연체료
					" select 0 NC, 0 NS, 0 NV, 0 RC, 0 RS, 0 RV, 0 MC, 0 MS, 0 MV, count(0) DC, sum(dly_fee) DT, 0 DT2"+
					" from scd_fee"+
					" where rent_mng_id = '"+m_id+"'and"+// and rent_l_cd='"+l_cd+"' nvl(bill_yn,'Y')='Y' and  
					" nvl(to_number(dly_days), 0) > 0 "+
					" union"+
					//연체료-수금
					" select 0 NC, 0 NS, 0 NV, 0 RC, 0 RS, 0 RV, 0 MC, 0 MS, 0 MV, 0 DC, 0 DT, sum(pay_amt) DT2"+
					" from scd_dly"+
					" where rent_mng_id = '"+m_id+"'"+// and rent_l_cd='"+l_cd+"'
				" )";
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
			System.out.println("[AddFeeDatabase:getFeeScdStatPrintAll]\n"+e);
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
	 *	대여료스케줄 통계(건별) - 중도해지된 대여료의 통계
	 */
	public Hashtable getFeeScdStat(String m_id, String l_cd, String cls_st)
	//public Hashtable getFeeScdStat(String m_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		query = " select"+
				" max(NC) NC, max(NS) NS, max(NV) NV, max(NS)+max(NV) N,"+//미수금
				" max(RC) RC, max(RS) RS, max(RV) RV, max(RS)+max(RV) R,"+//수금
				" max(MC) MC, max(MS) MS, max(MV) MV, max(MS)+max(MV) M,"+//미도래분
				" max(DC) DC, max(DT) DT, "+//연체
				" max(NC)+ max(RC)+max(MC) TC, max(NS)+ max(RS)+max(MS) TS, max(NV)+ max(RV)+max(MV) TV,"+
				" max(NS)+ max(RS)+max(MS)+max(NV)+ max(RV)+max(MV) TOT"+//합계
				" from"+
				" ("+
					//미수금
					" select count(0) NC, sum(a.fee_s_amt) NS, sum(a.fee_v_amt) NV, 0 RC, 0 RS, 0 RV, 0 MC, 0 MS, 0 MV, 0 DC, 0 DT"+
					" from scd_fee a, cls_cont b"+
					" where nvl(a.bill_yn,'Y')='Y' and b.cls_st='2' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rc_yn = '0' and a.r_fee_est_dt <= to_char(sysdate,'YYYYMMDD') and "+
					" a.rent_mng_id = '"+m_id+"' and a.rent_l_cd='"+l_cd+"'"+
					" union"+
					//수금
					" select 0 NC, 0 NS, 0 NV, count(0) RC, sum(trunc(a.rc_amt/1.1)) RS, sum(a.rc_amt-trunc(a.rc_amt/1.1)) RV, 0 MC, 0 MS, 0 MV, 0 DC, 0 DT"+
					" from scd_fee a, cls_cont b"+
					" where nvl(a.bill_yn,'Y')='Y' and b.cls_st='2' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rc_yn = '1' and"+
					" a.rent_mng_id = '"+m_id+"' and a.rent_l_cd='"+l_cd+"'"+
					" union"+
					//미도래분
					" select 0 NC, 0 NS, 0 NV, 0 RC, 0 RS, 0 RV, count(0) MC, sum(a.fee_s_amt) MS, sum(a.fee_v_amt) MV, 0 DC, 0 DT"+
					" from scd_fee a, cls_cont b"+
					" where nvl(a.bill_yn,'Y')='Y' and b.cls_st='2' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rc_yn = '0' and a.r_fee_est_dt > to_char(sysdate,'YYYYMMDD') and "+
					" a.rent_mng_id = '"+m_id+"' and a.rent_l_cd='"+l_cd+"'"+
					" union"+
					//연체료
					" select 0 NC, 0 NS, 0 NV, 0 RC, 0 RS, 0 RV, 0 MC, 0 MS, 0 MV, count(0) DC, sum(a.dly_fee) DT"+
					" from scd_fee a, cls_cont b"+
					" where nvl(a.bill_yn,'Y')='Y' and b.cls_st='2' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(to_number(a.dly_days), 0) > 0 and "+
					" a.rent_mng_id = '"+m_id+"' and a.rent_l_cd='"+l_cd+"'"+
				" )";
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
			System.out.println("[AddFeeDatabase:getFeeScdStat]\n"+e);
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
	 *	대여료 리스트
	 *	구분1:전체(0), 선수(1), 수금(2), 미수(3), 연체(4), 검색(5)
	 *	구분2:당일(0), 연체(1), 기간(2), 당일+연체(3), 검색(0)
	 *	st_dt, end_dt: 기간구분중 일정기간 선택일 경우 시작-종료기간
	 *  kd	  : 기타검색조건 구분(1:상호, 2: 계약자, 3:계약코드, 4:차량번호, 5:월대여료, 6:영업소코드, 7:사용본거지)
	 *  wd	  : 기타검색조건 검색어
	 *	sort_gubun : 정렬조건 (0:상호, 1:입금예정일, 2:수금일자, 3:월대여료)
  	 *   상호를 선택시 정렬순서는 "order by 상호, 수금일자, 입금예정일" 으로 한다.
     *  입금예정일을 선택시 정렬순서는 "order by 입금예정일, 수금일자, 상호" 으로 한다.
     *  수금일자을 선택시 정렬순서는 "order by 수금일자, 상호, 입금예정일" 으로 한다.
     *  월대여료를 선택시 정렬순서는 "order by 월대여료, 수금일자, 상호, 입금예정일" 으로 한다.
	 *	asc		: (0: 오름차순, 1:내림차순)
	 *
	 *	(구분1 & 2 매칭 가능 경우)
	 *	구분1	:	구분2
	 *	0		:	0, 2
	 *	1		:	0
	 *	2		:	0, 1, 2, 3
	 *	3		:	0, 1, 2, 3
	 *	4		:	0, 2
	 *  5       :   0
	 *
	 **	QUERY 정보 ***
	 *	subquery 임시 칼럼 값 ( where절에서 조건 구분에 쓰임)
	 *	입금예정일 : E(0:당일이전, 1:당일, 2:예정)--> 단순하게 입금예정일과 당일 비교
	 *	수금일 : R(0:당일이전, 1:당일, 2:예정) --> 단순하게 수금일과 당일 비교
	 *	연체구분 : D(1:연체, 0:연체아님) 	--> 수금인경우 수금일 > 입금예정일, 미수금인경우 현재날짜 > 입금예정일
	 *	선수구분 : F(1:선수, 0:선수아님)	--> 수금인경우 수금일 < 입금예정일
	 *	수금상태 : RC_YN(0:미수, 1: 수금)	--> Y/N로 표시
	 *	수정할일 있을 때 참고하세요.
	 *	getFeeList와 getFeeScdStat는 값이 일치해야 하므로 같은 조건을 줘야 한다.
	 */
	public Vector getFeeList(String gubun1, String gubun2, String st_dt, String end_dt, String kd, String wd, String sort_gubun, String asc)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
	
		query="select * from fee_view where ";

		//전체-당일((E:1 && F:0)|| (D:1 && R:1) || (D:1 && N))	입금예정일이 당일이고 선수가 아닌 데이터) & 연체된 데이타(연체수금:당일, 연체미수))	
		if(gubun1.equals("0") && gubun2.equals("0")) 
			query += " ((E = 1 AND F = 0) OR (D = 1 AND R = 1) OR (D = 1 AND RC_YN = '0'))";
		//전체-기간
		else if(gubun1.equals("0") && gubun2.equals("2"))		
			query += " fee_est_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";	
		//선수-당일(F:1, R:1, Y)
		else if(gubun1.equals("1") && gubun2.equals("0")) 		
			query += " F = 1 AND R = 1";
		// 수금-당일(E:1, 2, R:1, Y)	수금일이 당일이고 입금예정일이 당일이거나 예정인것
		else if(gubun1.equals("2") && gubun2.equals("0"))
			query += " (E = 1 OR E = 2) AND R = 1";
		// 수금-연체(D:1, R:1, Y)	수금일이 당일이고 연체된것
		else if(gubun1.equals("2") && gubun2.equals("1"))
			query += " D = 1 AND R = 1";
		//수금-기간
		else if(gubun1.equals("2") && gubun2.equals("2"))
			query += " RC_YN='1' AND RC_DT BETWEEN '"+st_dt+"' AND '"+end_dt+"'";	
		//수금-당일+연체((D:1, E:1, 2,  R:1, Y)
		else if(gubun1.equals("2") && gubun2.equals("3"))
			query += " ((E = 1 OR E = 2) OR D = 1) AND R = 1";
		//미수-당일(E:1, N)
		else if(gubun1.equals("3") && gubun2.equals("0"))
			query += " E = 1 AND RC_YN = '0'";
		//미수-연체(D:1, N)
		else if(gubun1.equals("3") && gubun2.equals("1"))
			query += " D = 1 AND RC_YN = '0'";
		//미수-기간
		else if(gubun1.equals("3") && gubun2.equals("2"))
			query += " RC_YN='0' AND FEE_EST_DT BETWEEN '"+st_dt+"' AND '"+end_dt+"'";	
		//미수-당일+연체(E:0, 1,  N)
		else if(gubun1.equals("3") && gubun2.equals("3"))
			query += " (E = 1 OR D = 1) AND RC_YN = '0'";
		//연체-당일(E : 1)
		else if(gubun1.equals("4") && gubun2.equals("0"))
			query += " E = 0 AND RC_YN = '0' ";		
		//연체-기간
		else if(gubun1.equals("4") && gubun2.equals("2"))
			query += " E = 0 AND FEE_EST_DT BETWEEN '"+st_dt+"' AND '"+end_dt+"' AND RC_YN = '0' ";	
		//검색
		else
//			query += " FEE_TM = '1' ";
			query += " FEE_TM = min_fee_tm ";
			
		if(kd.equals("2"))		query += " and nvl(client_nm, ' ') like '%"+wd+"%'";
		else if(kd.equals("3"))	query += " and upper(rent_l_cd) like upper('%"+wd+"%')";
		else if(kd.equals("4"))	query += " and nvl(car_no, ' ') like '%"+wd+"%'";
		else if(kd.equals("5"))	query += " and fee_amt like '%"+wd+"%'";
		else if(kd.equals("6"))	query += " and upper(brch_id) like upper('%"+wd+"%')";
		else if(kd.equals("7"))	query += " and nvl(R_SITE, ' ') like '%"+wd+"%'";
		else if(kd.equals("8"))	query += " and nvl(BUS_ID2, ' ') like '%"+wd+"%'";
		else					query += " and nvl(firm_nm, ' ') like '%"+wd+"%'";

//		if(!gubun1.equals("5"))	query+= " and use_yn='Y' ";

		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

			if(sort_gubun.equals("0"))		query += " order by use_yn desc, fee_est_dt "+sort+", rc_dt, firm_nm";
			else if(sort_gubun.equals("1"))	query += " order by use_yn desc, firm_nm "+sort+", rc_dt, fee_est_dt";
			else if(sort_gubun.equals("2"))	query += " order by use_yn desc, rc_dt "+sort+", firm_nm, fee_est_dt";
			else if(sort_gubun.equals("3"))	query += " order by use_yn desc, fee_amt "+sort+", rc_dt, firm_nm, fee_est_dt";
			else if(sort_gubun.equals("4"))	query += " order by use_yn desc, dly_day "+sort+", rc_dt, firm_nm, fee_est_dt";
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
			System.out.println("[AddFeeDatabase:getFeeList]\n"+e);
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

	// 담당자별 현황 - 대여료 수금현황
	public Vector getMDfeeList()
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_guery="";

		sub_guery += " nvl(tot3,0) + nvl(tot4,0) + nvl(tot5,0) "; //수금현황합계

		query = " select"+
				" U.user_nm, "+
				" nvl(tot1,0) tot1, "+
				" nvl(tot2,0) tot2, "+
				" nvl(tot3,0) tot3, "+
				" nvl(tot4,0) tot4, "+
				" nvl(tot5,0) tot5, "+
				" nvl(tot6,0) tot6, "+
				" nvl(tot7,0) tot7, "+
				" DECODE(nvl(tot6,0), 0,0, ROUND((decode("+sub_guery+",0,1,"+sub_guery+")/nvl(tot6,1))*1000, 0)) tot6_rate,"+
				" DECODE(nvl(tot7,0), 0,0, ROUND((decode("+sub_guery+",'',1,"+sub_guery+")/nvl(tot7,1))*1000, 0)) tot7_rate\n"+
				" from"+
				" ( \n"+
					" select user_nm from users a, cont b "+
					" where b.bus_id2 = a.user_id and a.user_pos like '%사원%' group by user_nm"+
				" ) U,"+ //사원명
				" (\n"+
					" select user_nm, sum(a.fee_s_amt+a.fee_v_amt) tot1 from scd_fee a, cont b, users c\n"+
					" where r_fee_est_dt = to_char(sysdate,'YYYYMMDD') and a.rent_l_cd = b.rent_l_cd and b.bus_id2 = c.user_id\n"+
					" group by user_nm"+
				" ) Z,"+ //당일=실입금에정일(당일수금계획)
				" (\n"+
					" select user_nm, sum(a.fee_s_amt+a.fee_v_amt) tot2 from scd_fee a, cont b, users c\n"+
					" where (a.rc_yn = '0' and a.r_fee_est_dt < to_char(sysdate,'YYYYMMDD')) and a.rent_l_cd = b.rent_l_cd and\n"+
					" b.bus_id2 = c.user_id group by user_nm "+ //미수금중 당일>실입금예정일(연체수금계획)
				") X,"+
				" (\n"+
					" select user_nm, sum(a.rc_amt) tot3 from scd_fee a, cont b, users c\n"+
					" where a.rc_dt = to_char(sysdate,'YYYYMMDD') and a.r_fee_est_dt > to_char(sysdate,'YYYYMMDD') and a.rent_l_cd = b.rent_l_cd and\n"+
					" b.bus_id2 = c.user_id group by user_nm "+ //당일=수금일 and 당일<실입금예정일(선수수금현황)
				") Y,"+
				" (\n"+
					" select user_nm, sum(a.rc_amt) tot4 from scd_fee a, cont b, users c\n"+
					" where a.rc_dt = to_char(sysdate,'YYYYMMDD') and a.r_fee_est_dt = to_char(sysdate,'YYYYMMDD') and a.rent_l_cd = b.rent_l_cd and\n"+
					" b.bus_id2 = c.user_id group by user_nm "+ //당일=수금일 and 당일=실입금예정일(당일수금현황)
				") T,"+
				" (\n"+
					" select user_nm, sum(a.rc_amt) tot5 from scd_fee a, cont b, users c\n"+
					" where a.rc_dt = to_char(sysdate,'YYYYMMDD') and a.r_fee_est_dt < to_char(sysdate,'YYYYMMDD') and a.rent_l_cd = b.rent_l_cd and\n"+
					" b.bus_id2 = c.user_id group by user_nm "+ //당일=수금일 and 당일>실입금예정일(연체수금현황)
				") S,"+
				" (\n"+
					" select user_nm, sum(a.rc_amt) tot6 from scd_fee a, cont b, users c\n"+
					" where a.rc_dt = to_char(SYSDATE-1, 'YYYYMMDD') and a.rent_l_cd = b.rent_l_cd and\n"+
					" b.bus_id2 = c.user_id group by user_nm "+ //전일=수금일(전일수금)
				") R,"+
				" (\n"+
					" select user_nm, sum(a.rc_amt) tot7 from scd_fee a, cont b, users c\n"+
					" where a.rc_dt = to_char(add_months(SYSDATE,-1), 'YYYYMMDD') and a.rent_l_cd = b.rent_l_cd and\n"+
					" b.bus_id2 = c.user_id group by user_nm "+ //전월=수금일(전월수금)
				") E"+
				" where "+
				" U.user_nm = X.user_nm(+) and "+
				" U.user_nm = Z.user_nm(+) and "+
				" U.user_nm = T.user_nm(+) and "+
				" U.user_nm = Y.user_nm(+) and "+
				" U.user_nm = S.user_nm(+) and "+
				" U.user_nm = R.user_nm(+) and "+
				" U.user_nm = E.user_nm(+) "  ;

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
    		while(rs.next())
			{				
				FeeScdBean fee_scd = new FeeScdBean();
				fee_scd.setUser_nm(rs.getString("USER_NM"));
				fee_scd.setTot1(rs.getLong("TOT1"));
				fee_scd.setTot2(rs.getLong("TOT2"));
				fee_scd.setTot3(rs.getLong("TOT3"));
				fee_scd.setTot4(rs.getLong("TOT4"));
				fee_scd.setTot5(rs.getLong("TOT5"));
				fee_scd.setTot6(rs.getLong("TOT6"));
				fee_scd.setTot7(rs.getLong("TOT7"));
				fee_scd.setTot6_rate(rs.getInt("TOT6_RATE"));
				fee_scd.setTot7_rate(rs.getInt("TOT7_RATE"));
				vt.add(fee_scd);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getMfeeList]\n"+e);
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

	// 담당자별 현황 - 대여료 연체현황
	public Vector getMYfeeList()
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_guery="";

		sub_guery += " nvl(tot3,0) + nvl(tot4,0) + nvl(tot5,0) "; //수금현황합계

		query = " select"+
				" U.user_nm, "+
				" nvl(tot1,0) tot1, nvl(tot2,0) tot2, nvl(tot3,0) tot3, nvl(tot4,0) tot4, nvl(tot5,0) tot5, nvl(tot6,0) tot6, nvl(tot7,0) tot7,\n"+
				" DECODE(nvl(tot6,0), 0, 0, "+
				"						 ROUND((decode("+sub_guery+",0,1,"+sub_guery+")/nvl(tot6,1))*1000, 0))"+
				" tot6_rate,\n"+
				" DECODE(nvl(tot7,0), 0, 0, "+
				"						 ROUND((decode("+sub_guery+",'',1,"+sub_guery+")/nvl(tot7,1))*1000, 0))"+
				" tot7_rate\n"+
				" from"+
				" ( \n"+
					" select user_nm from users a, cont b "+
					" where b.bus_id2 = a.user_id and a.user_pos like '%사원%' group by user_nm"+
				" ) U,"+ //사원명
				" (\n"+
					" select user_nm, sum(a.fee_s_amt+a.fee_v_amt) tot1 from scd_fee a, cont b, users c\n"+
					" where r_fee_est_dt = to_char(sysdate,'YYYYMMDD') and a.rent_l_cd = b.rent_l_cd and b.bus_id2 = c.user_id\n"+
					" group by user_nm"+
				" ) Z,"+ //당일=실입금에정일(당일수금계획)
				" (\n"+
					" select user_nm, sum(a.fee_s_amt+a.fee_v_amt) tot2 from scd_fee a, cont b, users c\n"+
					" where (a.rc_yn = '0' and a.r_fee_est_dt < to_char(sysdate,'YYYYMMDD')) and a.rent_l_cd = b.rent_l_cd and\n"+
					" b.bus_id2 = c.user_id group by user_nm "+ //미수금중 당일>실입금예정일(연체수금계획)
				") X,"+
				" (\n"+
					" select user_nm, sum(a.rc_amt) tot3 from scd_fee a, cont b, users c\n"+
					" where a.rc_dt = to_char(sysdate,'YYYYMMDD') and a.r_fee_est_dt > to_char(sysdate,'YYYYMMDD') and a.rent_l_cd = b.rent_l_cd and\n"+
					" b.bus_id2 = c.user_id group by user_nm "+ //당일=수금일 and 당일<실입금예정일(선수수금현황)
				") Y,"+
				" (\n"+
					" select user_nm, sum(a.rc_amt) tot4 from scd_fee a, cont b, users c\n"+
					" where a.rc_dt = to_char(sysdate,'YYYYMMDD') and a.r_fee_est_dt = to_char(sysdate,'YYYYMMDD') and a.rent_l_cd = b.rent_l_cd and\n"+
					" b.bus_id2 = c.user_id group by user_nm "+ //당일=수금일 and 당일=실입금예정일(당일수금현황)
				") T,"+
				" (\n"+
					" select user_nm, sum(a.rc_amt) tot5 from scd_fee a, cont b, users c\n"+
					" where a.rc_dt = to_char(sysdate,'YYYYMMDD') and a.r_fee_est_dt < to_char(sysdate,'YYYYMMDD') and a.rent_l_cd = b.rent_l_cd and\n"+
					" b.bus_id2 = c.user_id group by user_nm "+ //당일=수금일 and 당일>실입금예정일(연체수금현황)
				") S,"+
				" (\n"+
					" select user_nm, sum(a.rc_amt) tot6 from scd_fee a, cont b, users c\n"+
					" where a.rc_dt = to_char(SYSDATE-1, 'YYYYMMDD') and a.rent_l_cd = b.rent_l_cd and\n"+
					" b.bus_id2 = c.user_id group by user_nm "+ //전일=수금일(전일수금)
				") R,"+
				" (\n"+
					" select user_nm, sum(a.rc_amt) tot7 from scd_fee a, cont b, users c\n"+
					" where a.rc_dt = to_char(add_months(SYSDATE,-1), 'YYYYMMDD') and a.rent_l_cd = b.rent_l_cd and\n"+
					" b.bus_id2 = c.user_id group by user_nm "+ //전월=수금일(전월수금)
				") E"+
				" where "+
				" U.user_nm = X.user_nm(+) and "+
				" U.user_nm = Z.user_nm(+) and "+
				" U.user_nm = T.user_nm(+) and "+
				" U.user_nm = Y.user_nm(+) and "+
				" U.user_nm = S.user_nm(+) and "+
				" U.user_nm = R.user_nm(+) and "+
				" U.user_nm = E.user_nm(+) "  ;

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
    		while(rs.next())
			{				
				FeeScdBean fee_scd = new FeeScdBean();
				fee_scd.setUser_nm(rs.getString("USER_NM"));
				fee_scd.setTot1(rs.getLong("TOT1"));
				fee_scd.setTot2(rs.getLong("TOT2"));
				fee_scd.setTot3(rs.getLong("TOT3"));
				fee_scd.setTot4(rs.getLong("TOT4"));
				fee_scd.setTot5(rs.getLong("TOT5"));
				fee_scd.setTot6(rs.getLong("TOT6"));
				fee_scd.setTot7(rs.getLong("TOT7"));
				fee_scd.setTot6_rate(rs.getInt("TOT6_RATE"));
				fee_scd.setTot7_rate(rs.getInt("TOT7_RATE"));
				vt.add(fee_scd);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getMfeeList]\n"+e);
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

	// 대여료현황(수금,연체)
	public Vector getDfeeList(String t_wd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select"+//선수금
				" '선수금' user_nm,"+
				" nvl(tot1,0) tot1,"+
				" nvl(tot2,0) tot2, to_char(0,999999990.09) tot2_rate,"+
				" nvl(tot3,0) tot3, to_char(decode(decode(tot3, '',1, 0,1, tot3),1,0, round((nvl(tot2,0)/tot3)*100,2)),999999990.09) tot3_rate,"+
				" nvl(tot4,0) tot4, to_char(decode(decode(tot4, '',1, 0,1, tot4),1,0, round((nvl(tot2,0)/tot4)*100,2)),999999990.09) tot4_rate,"+
				" nvl(tot5,0) tot5, to_char(decode(decode(tot5, '',1, 0,1, tot5),1,0, round((nvl(tot2,0)/tot5)*100,2)),999999990.09) tot5_rate,"+
				" nvl(tot6,0) tot6, to_char(decode(decode(tot6, '',1, 0,1, tot6),1,0, round((nvl(tot2,0)/tot6)*100,2)),999999990.09) tot6_rate,"+
				" nvl(tot7,0) tot7, to_char(decode(decode(tot7, '',1, 0,1, tot7),1,0, round((nvl(tot2,0)/tot7)*100,2)),999999990.09) tot7_rate"+
				" from "+
					" (select sum(rc_amt) tot1 from scd_fee where rc_dt = '0') R,"+ //금일수금계획
					" (select sum(rc_amt) as tot2 from scd_fee where rc_dt = to_char(sysdate,'YYYYMMDD') and r_fee_est_dt > to_char(sysdate,'YYYYMMDD') ) Z, "+ //금일수금
					" (select sum(rc_amt) as tot3 from scd_fee where rc_dt = to_char(SYSDATE-1, 'YYYYMMDD') and r_fee_est_dt > to_char(SYSDATE-1, 'YYYYMMDD') ) X,"+ //전일수금
					" (select sum(rc_amt) as tot5 from scd_fee where rc_dt = to_char(add_months(SYSDATE,-1), 'YYYYMMDD') and r_fee_est_dt > to_char(add_months(SYSDATE,-1), 'YYYYMMDD') ) Y,"+ //전월동일
					" (select sum(rc_amt) as tot4 from scd_fee where rc_dt = to_char(add_months(SYSDATE,-2), 'YYYYMMDD') and r_fee_est_dt > to_char(add_months(SYSDATE,-2), 'YYYYMMDD') ) T,"+ //전전월동일
					" (select sum(rc_amt) as tot6 from scd_fee where rc_dt = to_char(add_months(SYSDATE,-12), 'YYYYMMDD') and r_fee_est_dt > to_char(add_months(SYSDATE,-12), 'YYYYMMDD')  ) S,"+ //전년도동일
					" (select sum(rc_amt) as tot7 from scd_fee where rc_dt = '"+t_wd+"' and r_fee_est_dt > '"+t_wd+"'  ) E\n"+ //전년도동일
				" union all\n "+
				" select"+//당일도래분
				" '당일도래분' user_nm,"+
				" nvl(tot1,0) tot1,"+
				" nvl(tot2,0) tot2, to_char(decode(decode(tot2, '',0, 0,0, tot2), 0,0, round((tot2/tot1)*100,2)),999999990.09) tot2_rate,"+
				" nvl(tot3,0) tot3, to_char(decode(decode(tot3, '',1, 0,1, tot3), 1,0, round((nvl(tot2,0)/tot3)*100,2)),999999990.09) tot3_rate,"+
				" nvl(tot4,0) tot4, to_char(decode(decode(tot4, '',1, 0,1, tot4), 1,0, round((nvl(tot2,0)/tot4)*100,2)),999999990.09) tot4_rate,"+
				" nvl(tot5,0) tot5, to_char(decode(decode(tot5, '',1, 0,1, tot5), 1,0, round((nvl(tot2,0)/tot5)*100,2)),999999990.09) tot5_rate,"+
				" nvl(tot6,0) tot6, to_char(decode(decode(tot6, '',1, 0,1, tot6), 1,0, round((nvl(tot2,0)/tot6)*100,2)),999999990.09) tot6_rate,"+
				" nvl(tot7,0) tot7, to_char(decode(decode(tot7, '',1, 0,1, tot7), 1,0, round((nvl(tot2,0)/tot7)*100,2)),999999990.09) tot7_rate"+
				" from "+
					" (select sum(fee_s_amt+fee_v_amt) as tot1 from scd_fee where r_fee_est_dt = to_char(sysdate,'YYYYMMDD')) R,"+ //오늘=수금일 and 오늘=실입금에정일(금일 당일수금)
					" (select sum(rc_amt) as tot2 from scd_fee where rc_dt = to_char(sysdate,'YYYYMMDD') and r_fee_est_dt = to_char(sysdate,'YYYYMMDD')) Z,"+ //전일 당일수금
					" (select sum(rc_amt) as tot3 from scd_fee where rc_dt = to_char(SYSDATE-1, 'YYYYMMDD') and r_fee_est_dt = to_char(SYSDATE-1, 'YYYYMMDD')) X,"+//전월 당일수금
					" (select sum(rc_amt) as tot5 from scd_fee where rc_dt = to_char(add_months(SYSDATE,-1), 'YYYYMMDD') and r_fee_est_dt = to_char(add_months(SYSDATE,-1), 'YYYYMMDD')) Y,"+//전전월 당일수금
					" (select sum(rc_amt) as tot4 from scd_fee where rc_dt = to_char(add_months(SYSDATE,-2), 'YYYYMMDD') and r_fee_est_dt = to_char(add_months(SYSDATE,-2), 'YYYYMMDD')) T,"+//전년도 당일수금
					" (select sum(rc_amt) as tot6 from scd_fee where rc_dt = to_char(add_months(SYSDATE,-12), 'YYYYMMDD') and r_fee_est_dt = to_char(add_months(SYSDATE,-12), 'YYYYMMDD')) S,"+
					" (select sum(rc_amt) as tot7 from scd_fee where rc_dt = '"+t_wd+"' and r_fee_est_dt = '"+t_wd+"') E\n"+
				" union all\n "+
				" select "+//연체분
				" '연체분' user_nm,"+
				" nvl(tot1,0) tot1,"+
				" nvl(tot2,0) tot2, to_char(decode(decode(tot2,'',0,0,0,tot2),0,0,round((tot2/tot1)*100,2)),999999990.09) tot2_rate,"+
				" nvl(tot3,0) tot3, to_char(decode(decode(tot3,'',1,0,1,tot3),1,0,round((nvl(tot2,0)/tot3)*100,2)),999999990.09) tot3_rate,"+
				" nvl(tot4,0) tot4, to_char(decode(decode(tot4,'',1,0,1,tot4),1,0,round((nvl(tot2,0)/tot4)*100,2)),999999990.09) tot4_rate,"+
				" nvl(tot5,0) tot5, to_char(decode(decode(tot5,'',1,0,1,tot5),1,0,round((nvl(tot2,0)/tot5)*100,2)),999999990.09) tot5_rate,"+
				" nvl(tot6,0) tot6, to_char(decode(decode(tot6,'',1,0,1,tot6),1,0,round((nvl(tot2,0)/tot6)*100,2)),999999990.09) tot6_rate,"+
				" nvl(tot7,0) tot7, to_char(decode(decode(tot7,'',1,0,1,tot7),1,0,round((nvl(tot2,0)/tot7)*100,2)),999999990.09) tot7_rate"+
				" from "+
					" (select sum(fee_s_amt+fee_v_amt) as tot1 from scd_fee where rc_yn='0' and r_fee_est_dt < to_char(sysdate,'YYYYMMDD') or (rc_dt =  to_char(sysdate,'YYYYMMDD') and r_fee_est_dt < to_char(sysdate,'YYYYMMDD')) ) R,"+
					" (select sum(rc_amt) as tot2 from scd_fee where rc_dt = to_char(sysdate,'YYYYMMDD') and r_fee_est_dt < to_char(sysdate,'YYYYMMDD')) Z,"+
					" (select sum(rc_amt) as tot3 from scd_fee where rc_dt = to_char(SYSDATE-1, 'YYYYMMDD') and r_fee_est_dt < to_char(SYSDATE-1, 'YYYYMMDD')) X,"+
					" (select sum(rc_amt) as tot5 from scd_fee where rc_dt = to_char(add_months(SYSDATE,-1), 'YYYYMMDD') and r_fee_est_dt < to_char(add_months(SYSDATE,-1), 'YYYYMMDD')) Y,"+
					" (select sum(rc_amt) as tot4 from scd_fee where rc_dt = to_char(add_months(SYSDATE,-2), 'YYYYMMDD') and r_fee_est_dt < to_char(add_months(SYSDATE,-2), 'YYYYMMDD')) T,"+
					" (select sum(rc_amt) as tot6 from scd_fee where rc_dt = to_char(add_months(SYSDATE,-12), 'YYYYMMDD') and r_fee_est_dt < to_char(add_months(SYSDATE,-12), 'YYYYMMDD')) S,"+
					" (select sum(rc_amt) as tot7 from scd_fee where rc_dt = '"+t_wd+"' and r_fee_est_dt < '"+t_wd+"') E\n"+
				" union all\n "+
				" select "+//받을어음 연체현황	
				" '받을어음계' user_nm,"+
				" nvl(tot1,0) tot1, "+
				" nvl(tot2,0) tot2, to_char(decode(decode(tot2, '',0, 0,0, tot2), 0,0, round((tot2/tot1)*100,2)),999999990.09) tot2_rate,"+
				" nvl(tot3,0) tot3, to_char(0,999999990.09) tot3_rate,"+
				" nvl(tot4,0) tot4,	to_char(0,999999990.09) tot4_rate,"+
				" nvl(tot5,0) tot5,	to_char(0,999999990.09) tot5_rate,"+
				" nvl(tot6,0) tot6,	to_char(0,999999990.09) tot6_rate,"+
				" nvl(tot7,0) tot7,	to_char(0,999999990.09) tot7_rate"+
				" from "+
					" (select sum(fee_s_amt+fee_v_amt) as tot1 from scd_fee where r_fee_est_dt = to_char(sysdate,'YYYYMMDD')) R,"+
					" (select sum(rc_amt) as tot2 from scd_fee where rc_dt = to_char(sysdate,'YYYYMMDD') and r_fee_est_dt = to_char(sysdate,'YYYYMMDD')) Z,"+
					" (select sum(rc_amt) as tot3 from scd_fee where rc_dt = to_char(SYSDATE-1, 'YYYYMMDD') and r_fee_est_dt = to_char(SYSDATE-1, 'YYYYMMDD')) X,"+
					" (select sum(rc_amt) as tot5 from scd_fee where rc_dt = to_char(add_months(SYSDATE,-1), 'YYYYMMDD') and r_fee_est_dt = to_char(add_months(SYSDATE,-1), 'YYYYMMDD')) Y,"+
					" (select sum(rc_amt) as tot4 from scd_fee where rc_dt = to_char(add_months(SYSDATE,-2), 'YYYYMMDD') and r_fee_est_dt = to_char(add_months(SYSDATE,-2), 'YYYYMMDD')) T,"+
					" (select sum(rc_amt) as tot6 from scd_fee where rc_dt = to_char(add_months(SYSDATE,-12), 'YYYYMMDD') and r_fee_est_dt = to_char(add_months(SYSDATE,-12), 'YYYYMMDD')) S,"+
					" (select sum(rc_amt) as tot7 from scd_fee where rc_dt = '"+t_wd+"' and r_fee_est_dt = '"+t_wd+"') E\n"+
				" union all\n "+
				" select "+//연체금액 연체현황
				" '연체금액' user_nm,"+
				" nvl(tot1,0) tot1, "+
				" nvl(tot2,0) tot2, to_char(decode(decode(tot2,'',0,0,0,tot2),0,0,round((tot2/tot1)*100,2)),999999990.09) tot2_rate,"+
				" nvl(tot3,0) tot3, to_char(decode(decode(tot3,'',1,0,1,tot3),1,0,round((nvl(tot2,0)/tot3)*100,2)),999999990.09) tot3_rate,"+
				" nvl(tot4,0) tot4, to_char(decode(decode(tot4,'',1,0,1,tot4),1,0,round((nvl(tot2,0)/tot4)*100,2)),999999990.09) tot4_rate,"+
				" nvl(tot5,0) tot5, to_char(decode(decode(tot5,'',1,0,1,tot5),1,0,round((nvl(tot2,0)/tot5)*100,2)),999999990.09) tot5_rate,"+
				" nvl(tot6,0) tot6, to_char(decode(decode(tot6,'',1,0,1,tot6),1,0,round((nvl(tot2,0)/tot6)*100,2)),999999990.09) tot6_rate,"+
				" nvl(tot7,0) tot7, to_char(decode(decode(tot7,'',1,0,1,tot7),1,0,round((nvl(tot2,0)/tot7)*100,2)),999999990.09) tot7_rate"+
				" from"+
					" (select sum(fee_s_amt+fee_v_amt) as tot1 from scd_fee where rc_yn='0' and r_fee_est_dt < to_char(sysdate,'YYYYMMDD') or (rc_dt =  to_char(sysdate,'YYYYMMDD') and r_fee_est_dt < to_char(sysdate,'YYYYMMDD')) ) R,"+
					" (select sum(rc_amt) as tot2 from scd_fee where rc_dt = to_char(sysdate,'YYYYMMDD') and r_fee_est_dt < to_char(sysdate,'YYYYMMDD')) Z,"+
					" (select sum(rc_amt) as tot3 from scd_fee where rc_dt = to_char(SYSDATE-1, 'YYYYMMDD') and r_fee_est_dt < to_char(SYSDATE-1, 'YYYYMMDD')) X,"+
					" (select sum(rc_amt) as tot5 from scd_fee where rc_dt = to_char(add_months(SYSDATE,-1), 'YYYYMMDD') and r_fee_est_dt < to_char(add_months(SYSDATE,-1), 'YYYYMMDD')) Y,"+
					" (select sum(rc_amt) as tot4 from scd_fee where rc_dt = to_char(add_months(SYSDATE,-2), 'YYYYMMDD') and r_fee_est_dt < to_char(add_months(SYSDATE,-2), 'YYYYMMDD')) T,"+
					" (select sum(rc_amt) as tot6 from scd_fee where rc_dt = to_char(add_months(SYSDATE,-12), 'YYYYMMDD') and r_fee_est_dt < to_char(add_months(SYSDATE,-12), 'YYYYMMDD')) S,"+
					" (select sum(rc_amt) as tot7 from scd_fee where rc_dt = '"+t_wd+"' and r_fee_est_dt < '"+t_wd+"') E\n"+
				" union all \n"+
				" select "+//연체율 연체현황
				" '연체율' user_nm,"+
				" 0 tot1, "+
				" nvl(tot2,0) tot2, to_char(decode(decode(tot2,'',0,0,0,tot2),0,0,round((tot2/tot1)*100,2)),999999990.09) tot2_rate,"+
				" nvl(tot3,0) tot3, to_char(0,999999990.09) tot3_rate,"+
				" nvl(tot4,0) tot4, to_char(0,999999990.09) tot4_rate,"+
				" nvl(tot5,0) tot5, to_char(0,999999990.09) tot5_rate,"+
				" nvl(tot6,0) tot6, to_char(0,999999990.09) tot6_rate, "+
				" nvl(tot7,0) tot7, to_char(0,999999990.09) tot7_rate "+
				" from "+
				" (select sum(fee_s_amt+fee_v_amt) as tot1 from scd_fee where rc_yn='0' or (rc_dt =  to_char(sysdate,'YYYYMMDD') and r_fee_est_dt = to_char(sysdate,'YYYYMMDD')) ) R,"+
					" (select sum(fee_s_amt+fee_v_amt) as tot2 from scd_fee where rc_yn = '0' and r_fee_est_dt <  to_char(sysdate,'YYYYMMDD')) Z,"+
					" (select sum(fee_s_amt+fee_v_amt) as tot3 from scd_fee where rc_yn = '2' ) X,"+
					" (select sum(fee_s_amt+fee_v_amt) as tot4 from scd_fee where rc_yn = '2' ) T,"+
					" (select sum(fee_s_amt+fee_v_amt) as tot5 from scd_fee where rc_yn = '2' ) Y,"+
					" (select sum(fee_s_amt+fee_v_amt) as tot6 from scd_fee where rc_yn = '2' ) S,"+
					" (select sum(fee_s_amt+fee_v_amt) as tot7 from scd_fee where rc_yn = '2' ) E\n"+
				" union all \n"+
				" select "+//악성율 연체현황
				" '악성율' user_nm,"+
				" nvl(tot1,0) tot1, "+
				" nvl(tot2,0) tot2, to_char(decode(decode(tot2,'',0,0,0,tot2),0,0,round((tot2/tot1)*100,2)),999999990.09) tot2_rate,"+
				" nvl(tot3,0) tot3, to_char(0,999999990.09) tot3_rate,"+
				" nvl(tot4,0) tot4, to_char(0,999999990.09) tot4_rate,"+
				" nvl(tot5,0) tot5, to_char(0,999999990.09) tot5_rate,"+
				" nvl(tot6,0) tot6, to_char(0,999999990.09) tot6_rate,"+
				" nvl(tot7,0) tot7, to_char(0,999999990.09) tot7_rate"+
				" from "+
					" (select sum(fee_s_amt+fee_v_amt) as tot1 from scd_fee where rc_yn='0' and r_fee_est_dt < to_char(sysdate,'YYYYMMDD') ) R,"+
					" (select sum(fee_s_amt+fee_v_amt) as tot2 from scd_fee where rc_yn = '0' and r_fee_est_dt < to_char(SYSDATE-60, 'YYYYMMDD')) Z,"+
					" (select sum(fee_s_amt+fee_v_amt) as tot3 from scd_fee where rc_yn = '2' ) X,"+
				 	" (select sum(fee_s_amt+fee_v_amt) as tot4 from scd_fee where rc_yn = '2' ) T,"+
			 		" (select sum(fee_s_amt+fee_v_amt) as tot5 from scd_fee where rc_yn = '2' ) Y,"+
					" (select sum(fee_s_amt+fee_v_amt) as tot6 from scd_fee where rc_yn = '2' ) S,"+
					" (select sum(fee_s_amt+fee_v_amt) as tot7 from scd_fee where rc_yn = '2' ) E";
		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
    		while(rs.next())
			{								
				FeeScdBean fee_scd = new FeeScdBean();
				fee_scd.setUser_nm(rs.getString("USER_NM"));
				fee_scd.setTot1(Long.parseLong(rs.getString("TOT1")));
				fee_scd.setTot2(Long.parseLong(rs.getString("TOT2")));
				fee_scd.setTot3(Long.parseLong(rs.getString("TOT3")));
				fee_scd.setTot4(Long.parseLong(rs.getString("TOT4")));
				fee_scd.setTot5(Long.parseLong(rs.getString("TOT5")));
				fee_scd.setTot6(Long.parseLong(rs.getString("TOT6")));
				fee_scd.setTot7(Long.parseLong(rs.getString("TOT7")));
				fee_scd.setFTot2_rate(rs.getFloat("TOT2_RATE"));
				fee_scd.setFTot3_rate(rs.getFloat("TOT3_RATE"));
				fee_scd.setFTot4_rate(rs.getFloat("TOT4_RATE"));
				fee_scd.setFTot5_rate(rs.getFloat("TOT5_RATE"));
				fee_scd.setFTot6_rate(rs.getFloat("TOT6_RATE"));
				fee_scd.setFTot7_rate(rs.getFloat("TOT7_RATE"));
				vt.add(fee_scd);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getDfeeList]\n"+e);
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

	//수정본추가 끝

	/**
	 *	대여료스케줄 통계(전체)
	 *	R : 수금, N:미수금, T:당일, D:연체, CNT:건수, SUM:금액합계 
	 *
	 *	구분1:전체(0), 선수(1), 수금(2), 미수(3), 연체(4)
	 *	구분2:당일(0), 연체(1), 기간(2), 당일+연체(3)
	 *	st_dt, end_dt: 기간구분중 일정기간 선택일 경우 시작-종료기간
	 *  kd	  : 기타검색조건 구분(1:상호, 2: 계약자, 3:계약코드, 4:차량번호, 5:월대여료, 6:영업소코드, 7:사용본거지)
	 *  wd	  : 기타검색조건 검색어
	 *
	 *	(구분1 & 2 매칭 가능 경우)
	 *	구분1	:	구분2
	 *	0		:	0, 2
	 *	1		:	0
	 *	2		:	0, 1, 2, 3
	 *	3		:	0, 1, 2, 3
	 *	4		:	0, 2
	 *
	 **	QUERY 정보 ***
	 *	subquery 임시 칼럼 값 ( where절에서 조건 구분에 쓰임)
	 *	입금예정일 : E(0:당일이전, 1:당일, 2:예정)--> 단순하게 입금예정일과 당일 비교
	 *	수금일 : R(0:당일이전, 1:당일, 2:예정) --> 단순하게 수금일과 당일 비교
	 *	연체구분 : D(1:연체, 0:연체아님) 	--> 수금인경우 수금일 > 입금예정일, 미수금인경우 현재날짜 > 입금예정일
	 *	선수구분 : F(1:선수, 0:선수아님)	--> 수금인경우 수금일 < 입금예정일
	 *	수금상태 : RC_YN(0:미수, 1: 수금)	--> Y/N로 표시
	 *	수정할일 있을 때 참고하세요.
	 *	getFeeList와 getFeeScdStat는 값이 일치해야 하므로 같은 조건을 줘야 한다.							 	
	 */
	public Hashtable getFeeStat(String gubun1, String gubun2, String st_dt, String end_dt, String kd, String wd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();


		String inner_query = "";
		String inner_query2 =" where ";
		inner_query = "select * from fee_view where";

		//전체-당일((E:1 && F:0)|| (D:1 && R:1) || (D:1 && N))	입금예정일이 당일이고 선수가 아닌 데이터) & 연체된 데이타(연체수금:당일, 연체미수))
		if(gubun1.equals("0") && gubun2.equals("0"))
			inner_query += " ((E = 1 AND F = 0) OR (D = 1 AND R = 1) OR (D = 1 AND RC_YN = '0'))\n";
		//전체-기간
		else if(gubun1.equals("0") && gubun2.equals("2"))	
			inner_query += " fee_est_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'\n";	
		//선수-당일(F:1, R:1, Y)
		else if(gubun1.equals("1") && gubun2.equals("0"))		
			inner_query += " F = 1 AND R = 1\n";
		// 수금-당일(E:1, 2, R:1, Y)	수금일이 당일이고 입금예정일이 당일이거나 예정인것
		else if(gubun1.equals("2") && gubun2.equals("0"))
			inner_query += " (E = 1 OR E = 2) AND R = 1\n";
		// 수금-연체(D:1, R:1, Y)	수금일이 당일이고 연체된것
		else if(gubun1.equals("2") && gubun2.equals("1"))
			inner_query += " D = 1 AND R = 1\n";
		//수금-기간
		else if(gubun1.equals("2") && gubun2.equals("2"))
			inner_query += " RC_YN='1' AND RC_DT BETWEEN '"+st_dt+"' AND '"+end_dt+"'\n";	
		//수금-당일+연체((D:1, E:1, 2,  R:1, Y)
		else if(gubun1.equals("2") && gubun2.equals("3"))
			inner_query += " ((E = 1 OR E = 2) OR D = 1) AND R = 1\n";
		//미수-당일(E:1, N)
		else if(gubun1.equals("3") && gubun2.equals("0"))
			inner_query += " E = 1 AND RC_YN = '0'\n";
		//미수-연체(D:1, N)
		else if(gubun1.equals("3") && gubun2.equals("1"))
			inner_query += " D = 1 AND RC_YN = '0'\n";
		//미수-기간
		else if(gubun1.equals("3") && gubun2.equals("2"))
			inner_query += " RC_YN='0' AND FEE_EST_DT BETWEEN '"+st_dt+"' AND '"+end_dt+"'\n";	
		//미수-당일+연체(E:0, 1,  N)
		else if(gubun1.equals("3") && gubun2.equals("3"))
			inner_query += " (E = 1 OR D = 1) AND RC_YN = '0'\n";
		//연체-당일(E : 1)
		else if(gubun1.equals("4") && gubun2.equals("0"))
			inner_query += " E = 0 AND RC_YN = '0' \n";					
		//연체-기간
		else if(gubun1.equals("4") && gubun2.equals("2"))
			inner_query += " E = 1 AND FEE_EST_DT BETWEEN '"+st_dt+"' AND '"+end_dt+"' AND RC_YN = '0'\n";
		else			
//			inner_query += " FEE_TM = '1' \n";
			inner_query += " FEE_TM = min_fee_tm \n";

//		if(!gubun1.equals("5")) inner_query += " and use_yn='Y'";			
			
		if(kd.equals("2"))		inner_query += " and nvl(client_nm, ' ') like '%"+wd+"%'\n";
		else if(kd.equals("3"))	inner_query += " and upper(rent_l_cd) like upper('%"+wd+"%')\n";
		else if(kd.equals("4"))	inner_query += " and nvl(car_no, ' ') like '%"+wd+"%'\n";
		else if(kd.equals("5"))	inner_query += " and fee_amt like '%"+wd+"%'\n";
		else if(kd.equals("6"))	inner_query += " and upper(brch_id) like upper('%"+wd+"%')\n";
		else if(kd.equals("7"))	inner_query += " and nvl(R_SITE, ' ') like '%"+wd+"%'\n";
		else if(kd.equals("8"))	{
			inner_query += " and BUS_ID2= '"+wd+"'\n";
			inner_query2 += " cont.bus_id2 = '"+wd+"' and cont.rent_mng_id = scd_fee.rent_mng_id and ";
			}
		else					inner_query += " and nvl(firm_nm, ' ') like '%"+wd+"%'\n";			

		String query = "";

		query = " SELECT\n"+
				" T_CNT, T_AMT, D_CNT, D_AMT, F_CNT, F_AMT, R_CNT, R_AMT, N_CNT, N_AMT, CNT, AMT,\n"+
				" RF_CNT, RT_CNT, RF_AMT, RT_AMT, RD_CNT, RD_AMT, NT_CNT, NT_AMT, ND_CNT, ND_AMT,\n"+
				" G.C_FTOT , G.C_MTOT, DECODE(G.C_MTOT, 0, 0, ROUND((G.C_MTOT/G.C_FTOT)*100, 2)) C_TTOT\n"+
				" FROM\n"+
				" (\n"+
					" SELECT\n"+
					" (RT_CNT+NT_CNT) T_CNT, (RT_AMT+NT_AMT) T_AMT, (RD_CNT+ND_CNT) D_CNT, (RD_AMT+ND_AMT) D_AMT,\n"+
					" RF_CNT F_CNT, RF_AMT F_AMT, (RF_CNT+RT_CNT+RD_CNT) R_CNT, (RF_AMT+RT_AMT+RD_AMT) R_AMT,\n"+
				 	" (NT_CNT+ND_CNT) N_CNT, (NT_AMT+ND_AMT) N_AMT, (RF_CNT+RT_CNT+NT_CNT+RD_CNT+ND_CNT) CNT,\n"+
				 	" (RF_AMT+RT_AMT+NT_AMT+RD_AMT+ND_AMT) AMT, RF_CNT, RT_CNT, RF_AMT, RT_AMT, RD_CNT, RD_AMT,\n"+
					" NT_CNT, NT_AMT, ND_CNT, ND_AMT\n"+
					" FROM\n"+
					" (\n"+
					 	" SELECT MAX(RF_CNT) RF_CNT, MAX(RT_CNT) RT_CNT, MAX(RF_AMT) RF_AMT, MAX(RT_AMT) RT_AMT,\n"+
						" MAX(RD_CNT) RD_CNT, MAX(RD_AMT) RD_AMT, MAX(NT_CNT) NT_CNT,  MAX(NT_AMT) NT_AMT,\n"+
			 			" MAX(ND_CNT) ND_CNT, MAX(ND_AMT) ND_AMT\n"+
					 	" FROM\n"+
					 	" (\n"+
					 		" (\n"+ 
					 			" SELECT COUNT(0) RF_CNT, 0 RT_CNT, SUM(fee_amt) RF_AMT, 0 RT_AMT, 0 RD_CNT,\n"+
								" 0 RD_AMT, 0 NT_CNT, 0 NT_AMT, 0 ND_CNT, 0 ND_AMT\n"+
					 			" FROM\n"+
					 			" ("+ inner_query+")\n"+
					 			" WHERE F = 1\n"+//선수
					 		" )\n"+
					 		" UNION ALL\n"+						 	
					 		" (\n"+ 
					 			" SELECT 0 RF_CNT, COUNT(0) RT_CNT, 0 RF_AMT, SUM(fee_amt) RT_AMT, 0 RD_CNT,\n"+
								" 0 RD_AMT, 0 NT_CNT, 0 NT_AMT, 0 ND_CNT, 0 ND_AMT\n"+
					 			" FROM\n"+
					 			" ("+ inner_query+")\n"+
					 			" WHERE F = 0 AND R = 1 AND E = 1\n"+
					 		" )\n"+
					 		" UNION ALL\n"+
					 		" (\n"+
					 			" SELECT 0 RF_CNT, 0 RT_CNT, 0 RF_AMT, 0 RT_AMT, COUNT(0) RD_CNT, SUM(fee_amt) RD_AMT,\n"+
								" 0 NT_CNT, 0 NT_AMT, 0 ND_CNT, 0 ND_AMT\n"+
					 			" FROM\n"+
					 			" ("+inner_query+")\n"+
								" WHERE D = 1 AND RC_YN = '1'\n"+
					 		" )\n"+
					 		" UNION ALL\n"+
					 		" (\n"+
					 			" SELECT 0 RF_CNT, 0 RT_CNT, 0 RF_AMT, 0 RT_AMT, 0 RD_CNT, 0 RD_AMT, COUNT(0) NT_CNT,\n"+
								" SUM(fee_amt) NT_AMT, 0 ND_CNT, 0 ND_AMT\n"+
					 			" FROM\n"+
					 			" ("+inner_query+")\n"+
					 			" WHERE E = 1 AND RC_YN = '0'\n"+
					 		" )\n"+
					 		" UNION ALL\n"+
					 		" (\n"+
					 			" SELECT 0 RF_CNT, 0 RT_CNT, 0 RF_AMT, 0 RT_AMT, 0 RD_CNT, 0 RD_AMT, 0 NT_CNT,\n"+
								" 0 NT_AMT, COUNT(0) ND_CNT, SUM(fee_amt) ND_AMT\n"+
					 			" FROM\n"+
					 			" ("+inner_query+")\n"+
								" WHERE D = 1 AND RC_YN = '0'\n"+
					 		" )\n"+
					 	" )\n"+
					" )\n"+
				" ) K,\n"+
				" (\n"+
					" select C_FTOT, C_MTOT \n"+
					" from \n" +
					"( " ;
					if(kd.equals("8")) {
					query +=	" select sum(fee_s_amt+fee_v_amt) C_FTOT from scd_fee, cont " +inner_query2+ " rc_yn = '0' \n" +
					" ) Z,\n"+
					" (\n"+
						" select sum(fee_s_amt+fee_v_amt) C_MTOT from scd_fee, cont " +inner_query2+
						" rc_yn = '0' and r_fee_est_dt < to_char(sysdate,'yyyymmdd') \n"+
					" ) T) G";
					}else{
					query +=	" select sum(fee_s_amt+fee_v_amt) C_FTOT from scd_fee where rc_yn = '0' \n" +
					" ) Z,\n"+
					" (\n"+
						" select sum(fee_s_amt+fee_v_amt) C_MTOT from scd_fee where rc_yn = '0' and r_fee_est_dt < to_char(sysdate,'yyyymmdd') \n"+
					" ) T) G";
					}
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
			System.out.println("[AddFeeDatabase:getFeeStat]\n"+e);
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
	

	
	public Hashtable getFeeStat()
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " SELECT"+
				" (RT_CNT+NT_CNT) T_CNT, (RT_AMT+NT_AMT) T_AMT, (RD_CNT+ND_CNT) D_CNT, (RD_AMT+ND_AMT) D_AMT,"+
				" (RT_CNT+RD_CNT) R_CNT, (RT_AMT+RD_AMT) R_AMT, (NT_CNT+ND_CNT) N_CNT, (NT_AMT+ND_AMT) N_AMT,"+
				" (RT_CNT+NT_CNT+RD_CNT+ND_CNT) CNT, (RT_AMT+NT_AMT+RD_AMT+ND_AMT) AMT, RT_CNT, RT_AMT, RD_CNT,"+
				" RD_AMT, NT_CNT, NT_AMT, ND_CNT, ND_AMT"+
				" FROM"+
				" ("+
					" SELECT"+
					" MAX(RT_CNT) RT_CNT, MAX(RT_AMT) RT_AMT, MAX(RD_CNT) RD_CNT, MAX(RD_AMT) RD_AMT,"+
					" MAX(NT_CNT) NT_CNT,  MAX(NT_AMT) NT_AMT, MAX(ND_CNT) ND_CNT, MAX(ND_AMT) ND_AMT"+
					" FROM"+
					" ("+
						" ("+
							" SELECT"+
							" COUNT(0) RT_CNT, SUM(fee_amt) RT_AMT, 0 RD_CNT, 0 RD_AMT, 0 NT_CNT, 0 NT_AMT,"+
							" 0 ND_CNT, 0 ND_AMT"+
							" FROM"+
							" ("+
						  		" SELECT"+
								" DECODE(rc_yn,'0',DECODE(sign(TRUNC(TO_DATE(r_fee_est_dt, 'YYYYMMDD')) - TRUNC(SYSDATE)), -1, '00', 0, '01', '02'), '1',DECODE(sign(TRUNC(TO_DATE(r_fee_est_dt, 'YYYYMMDD')) - TRUNC(SYSDATE)), -1, '10', 0, '11', '12')) GUBUN,"+
								" rc_yn, rc_dt, (fee_s_amt+fee_v_amt) FEE_AMT"+
							  	" FROM SCD_FEE"+
							" )"+
							" WHERE (gubun = '11' OR gubun = '12')"+
							" AND rc_dt = to_char(sysdate,'YYYYMMDD')"+//수금당일
						" )"+
						" UNION ALL"+
						" ("+
							" SELECT"+
							" 0 RT_CNT, 0 RT_AMT, COUNT(0) RD_CNT, SUM(fee_amt) RD_AMT, 0 NT_CNT, 0 NT_AMT,"+
							" 0 ND_CNT, 0 ND_AMT"+
							" FROM"+
						 	" ("+
								" SELECT"+
								" DECODE(rc_yn,'0',DECODE(sign(TRUNC(TO_DATE(r_fee_est_dt, 'YYYYMMDD')) - TRUNC(SYSDATE)), -1, '00', 0, '01', '02'), '1',DECODE(sign(TRUNC(TO_DATE(r_fee_est_dt, 'YYYYMMDD')) - TRUNC(SYSDATE)), -1, '10', 0, '11', '12')) GUBUN,"+
								" rc_yn, rc_dt, (fee_s_amt+fee_v_amt) FEE_AMT"+
						 		" FROM SCD_FEE"+
							" )"+
							" WHERE gubun = '10' AND rc_dt = to_char(sysdate,'YYYYMMDD')"+//수금연체
						" )"+
						" UNION ALL"+
						" ("+
							" SELECT"+
							" 0 RT_CNT, 0 RT_AMT, 0 RD_CNT, 0 RD_AMT, COUNT(0) NT_CNT, SUM(fee_amt) NT_AMT,"+
							" 0 ND_CNT, 0 ND_AMT"+
							" FROM"+
							" ("+
								" SELECT"+
								" DECODE(rc_yn,'0',DECODE(sign(TRUNC(TO_DATE(r_fee_est_dt, 'YYYYMMDD')) - TRUNC(SYSDATE)), -1, '00', 0, '01', '02'), '1',DECODE(sign(TRUNC(TO_DATE(r_fee_est_dt, 'YYYYMMDD')) - TRUNC(SYSDATE)), -1, '10', 0, '11', '12')) GUBUN,"+
								" rc_yn, rc_dt, (fee_s_amt+fee_v_amt) FEE_AMT"+
						   		" FROM SCD_FEE"+
								" WHERE rc_yn='0' AND fee_est_dt = to_char(sysdate,'YYYYMMDD')"+
						 	" )"+
						 	" WHERE gubun = '01'"+
						" )"+//당일미수
						" UNION ALL"+
						" ("+
							" SELECT"+
							" 0 RT_CNT, 0 RT_AMT, 0 RD_CNT, 0 RD_AMT, 0 NT_CNT, 0 NT_AMT, COUNT(0) ND_CNT,"+
							" SUM(fee_amt) ND_AMT"+
						 	" FROM"+
							" ("+
								" SELECT"+
								" DECODE(rc_yn,'0',DECODE(sign(TRUNC(TO_DATE(r_fee_est_dt, 'YYYYMMDD')) - TRUNC(SYSDATE)), -1, '00', 0, '01', '02'), '1',DECODE(sign(TRUNC(TO_DATE(r_fee_est_dt, 'YYYYMMDD')) - TRUNC(SYSDATE)), -1, '10', 0, '11', '12')) GUBUN,"+
								" rc_yn, rc_dt, (fee_s_amt+fee_v_amt) FEE_AMT"+
					 			" FROM SCD_FEE"+
							" )"+
						 	" WHERE gubun = '00'"+
						" )"+//연체미수
					" )"+
				" )";

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
			System.out.println("[AddFeeDatabase:getFeeStat]\n"+e);
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
	 *	대여료메모
	 */
	public Vector getFeeMemo(String m_id, String l_cd, String r_st, String fee_tm, String tm_st1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String where = "";

		if(tm_st1.equals("7")) where = " and tm_st1='7'";
		if(tm_st1.equals("8")) where = " and tm_st1='8'";
		if(tm_st1.equals("9")) where = " and tm_st1='9'";

		query = " select * from "+
				"	( select"+
						" RENT_MNG_ID, RENT_L_CD, RENT_ST, TM_ST1, SEQ, FEE_TM, REG_ID, CONTENT, SPEAKER,"+
						" substr(REG_DT, 1, 4) || '-' || substr(REG_DT, 5, 2) || '-'||substr(REG_DT, 7, 2) REG_DT"+
						" from dly_mm"+
						" where RENT_MNG_ID = '"+m_id+"'"+
						" and RENT_L_CD = '"+l_cd+"'"+where+
				"	) order by REG_DT desc, SEQ desc ";		

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
	    	
			while(rs.next())
			{
				FeeMemoBean fee_mm = new FeeMemoBean();
				fee_mm.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_mm.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_mm.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_mm.setTm_st1(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				fee_mm.setSeq(rs.getString("SEQ")==null?"":rs.getString("SEQ"));
				fee_mm.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_mm.setReg_id(rs.getString("REG_ID")==null?"":rs.getString("REG_ID"));
				fee_mm.setReg_dt(rs.getString("REG_DT")==null?"":rs.getString("REG_DT"));
				fee_mm.setContent(rs.getString("CONTENT")==null?"":rs.getString("CONTENT"));
				fee_mm.setSpeaker(rs.getString("SPEAKER")==null?"":rs.getString("SPEAKER"));
				vt.add(fee_mm);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getFeeMemo]\n"+e);
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
	 *	대여료메모
	 */
	public Vector getFeeMemoClient(String m_id, String l_cd, String client_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select * "+
				" from ( "+
						" select 'dly_mm' mm_st, RENT_MNG_ID, RENT_L_CD, RENT_ST, TM_ST1, SEQ, FEE_TM, REG_ID, CONTENT, SPEAKER, decode(mm_st,'','채권','settle','채권','dist','초과운행','etc','기타') as mm_st2, "+
						"        substr(REG_DT, 1, 4) || '-' || substr(REG_DT, 5, 2) || '-'||substr(REG_DT, 7, 2) REG_DT, REG_DT_TIME, promise_dt "+
						" from dly_mm"+
						" ";

		if(client_id.equals("")){
			query += " where RENT_MNG_ID = '"+m_id+"' and RENT_L_CD = '"+l_cd+"'";
		}else{
			query += " where (RENT_MNG_ID, RENT_L_CD) in (select rent_mng_id, rent_l_cd from cont where client_id='"+client_id+"')";
		}

		query += "       union all"+
						" select 'tel_mm' mm_st, RENT_MNG_ID, RENT_L_CD, '' RENT_ST, '' TM_ST1, '' SEQ, '' FEE_TM, REG_ID, CONTENT, SPEAKER, '' as mm_st2, "+
						"        substr(REG_DT, 1, 4) || '-' || substr(REG_DT, 5, 2) || '-'||substr(REG_DT, 7, 2) REG_DT, REG_DT_TIME, promise_dt "+
						" from tel_mm"+
						" ";

		if(client_id.equals("")){
			query += " where RENT_MNG_ID = '"+m_id+"' and RENT_L_CD = '"+l_cd+"'";
		}else{
			query += " where (RENT_MNG_ID, RENT_L_CD) in (select rent_mng_id, rent_l_cd from cont where client_id='"+client_id+"')";
		}

		query += " ) order by REG_DT desc, REG_DT_TIME desc";


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
	    	
			while(rs.next())
			{
				FeeMemoBean fee_mm = new FeeMemoBean();
				fee_mm.setRent_mng_id	(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_mm.setRent_l_cd		(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_mm.setRent_st		(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_mm.setTm_st1		(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				fee_mm.setSeq			(rs.getString("SEQ")==null?"":rs.getString("SEQ"));
				fee_mm.setFee_tm		(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_mm.setReg_id		(rs.getString("REG_ID")==null?"":rs.getString("REG_ID"));
				fee_mm.setReg_dt		(rs.getString("REG_DT")==null?"":rs.getString("REG_DT"));
				fee_mm.setContent		(rs.getString("CONTENT")==null?"":rs.getString("CONTENT"));
				fee_mm.setSpeaker		(rs.getString("SPEAKER")==null?"":rs.getString("SPEAKER"));
				fee_mm.setMm_st			(rs.getString("mm_st")==null?"":rs.getString("mm_st"));
				fee_mm.setReg_dt_time	(rs.getString("reg_dt_time")==null?"":rs.getString("reg_dt_time"));
				fee_mm.setPromise_dt	(rs.getString("promise_dt")==null?"":rs.getString("promise_dt"));
				fee_mm.setMm_st2		(rs.getString("mm_st2")==null?"":rs.getString("mm_st2"));
				vt.add(fee_mm);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getFeeMemo]\n"+e);
			System.out.println("[AddFeeDatabase:getFeeMemo]\n"+query);
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
	 *	cms메모
	 */
	 
	public Vector getCmsMemo(String m_id, String l_cd, String r_st, String fee_tm, String tm_st1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String where = "";

		if(tm_st1.equals("7")) where = " and tm_st1='7'";
		if(tm_st1.equals("8")) where = " and tm_st1='8'";
		if(tm_st1.equals("9")) where = " and tm_st1='9'";

		query = " select * from "+
				"	( select"+
						" RENT_MNG_ID, RENT_L_CD, RENT_ST, TM_ST1, SEQ, FEE_TM, REG_ID, CONTENT, SPEAKER,"+
						" substr(REG_DT, 1, 4) || '-' || substr(REG_DT, 5, 2) || '-'||substr(REG_DT, 7, 2) REG_DT"+
						" from cms_mm"+
						" where RENT_MNG_ID = '"+m_id+"'"+
						" and RENT_L_CD = '"+l_cd+"'"+where+
				"	) order by REG_DT desc, SEQ desc ";		

		try {
			pstmt = conn.prepareStatement(query);

	    	rs = pstmt.executeQuery();
			while(rs.next())
			{
				FeeMemoBean fee_mm = new FeeMemoBean();
				fee_mm.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_mm.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_mm.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_mm.setTm_st1(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				fee_mm.setSeq(rs.getString("SEQ")==null?"":rs.getString("SEQ"));
				fee_mm.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_mm.setReg_id(rs.getString("REG_ID")==null?"":rs.getString("REG_ID"));
				fee_mm.setReg_dt(rs.getString("REG_DT")==null?"":rs.getString("REG_DT"));
				fee_mm.setContent(rs.getString("CONTENT")==null?"":rs.getString("CONTENT"));
				fee_mm.setSpeaker(rs.getString("SPEAKER")==null?"":rs.getString("SPEAKER"));
				vt.add(fee_mm);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getCmsMemo]\n"+e);
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
	 *	cms메모
	 */
	 
	public Vector getCmsMemoOneMon(String m_id, String l_cd, String r_st, String fee_tm, String tm_st1, String client_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
						" RENT_MNG_ID, RENT_L_CD, RENT_ST, TM_ST1, SEQ, FEE_TM, REG_ID, CONTENT, SPEAKER,"+
						" substr(REG_DT, 1, 4) || '-' || substr(REG_DT, 5, 2) || '-'||substr(REG_DT, 7, 2) REG_DT"+
						" from cms_mm"+
						" where reg_dt > to_char(sysdate-30,'YYYYMMDD') ";

		if(client_id.equals("")){
			query += " and RENT_MNG_ID = '"+m_id+"' and RENT_L_CD = '"+l_cd+"'";
		}else{
			query += " and (RENT_MNG_ID, RENT_L_CD) in (select rent_mng_id, rent_l_cd from cont where client_id='"+client_id+"')";
		}

		query += " order by REG_DT desc, SEQ desc";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			while(rs.next())
			{
				FeeMemoBean fee_mm = new FeeMemoBean();
				fee_mm.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_mm.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_mm.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_mm.setTm_st1(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				fee_mm.setSeq(rs.getString("SEQ")==null?"":rs.getString("SEQ"));
				fee_mm.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_mm.setReg_id(rs.getString("REG_ID")==null?"":rs.getString("REG_ID"));
				fee_mm.setReg_dt(rs.getString("REG_DT")==null?"":rs.getString("REG_DT"));
				fee_mm.setContent(rs.getString("CONTENT")==null?"":rs.getString("CONTENT"));
				fee_mm.setSpeaker(rs.getString("SPEAKER")==null?"":rs.getString("SPEAKER"));
				vt.add(fee_mm);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getCmsMemoOneMon]\n"+e);
			System.out.println("[AddFeeDatabase:getCmsMemoOneMon]\n"+query);
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
	
	private String getSysDate()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "select to_char(sysdate, 'YYYY-MM-DD') from dual";
		String sysdate = "";
		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			while(rs.next())
			{
				sysdate = rs.getString(1)==null?"":rs.getString(1);
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
			return sysdate;
		}
	}
	
	/**
	 *	현재날짜로 주일 및 공휴일을 건너뛰어 가장 가까운 평일 날짜를 리턴
	 */
	public String getValidDt()
	{
		String sysdate = getSysDate();
		boolean s_flag = false;
		boolean h_flag = false;
		String c_sysdate = "";
		while((!s_flag) || (!h_flag))
		{
			c_sysdate = checkSunday(sysdate);
			/* 요일체크로 리턴된 날짜가 원래의 날짜와 다르다면 */
			if(!c_sysdate.equals(sysdate))	sysdate = c_sysdate;
			else							s_flag = true;
			
			if(s_flag && h_flag)	return sysdate;
				
			c_sysdate = checkHday(sysdate);

			/* 휴일체크로 리턴된 날짜가 원래의 날짜와 다르다면 */
			if(!c_sysdate.equals(sysdate))	sysdate = c_sysdate;
			else							h_flag = true;
		}
		return sysdate;
	}
	
	/**
	 *	argument로 넘어온 날짜로 주일 및 공휴일을 건너뛰어 가장 가까운 평일 날짜를 리턴
	 */
	public String getValidDt(String dt)
	{	
		String sysdate = dt;
		boolean s_flag = false;
		boolean h_flag = false;
		String c_sysdate = "";
		while((!s_flag) || (!h_flag))
		{
			c_sysdate = checkSunday(sysdate);
			if(!c_sysdate.equals(sysdate))	/* 요일체크로 리턴된 날짜가 원래의 날짜와 다르다면 */
				sysdate = c_sysdate;
			else
				s_flag = true;
			
			if(s_flag && h_flag)	return sysdate;
				
			c_sysdate = checkHday(sysdate);
			if(!c_sysdate.equals(sysdate))	/* 휴일체크로 리턴된 날짜가 원래의 날짜와 다르다면 */
				sysdate = c_sysdate;
			else
				h_flag = true;
		}
		return sysdate;
	}
	

	/**
	 *	args로 넘어온 날짜가 일요일인지 체크해서 일요일인경우 +1 날짜를 리턴
	 */
	public String checkSunday(String dt)
	{
		getConnection();
		String sysdate = dt;
		String query;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String rtnStr = "";
					
		query = "select decode(to_char(to_date(?, 'YYYY-MM-DD'), 'D'),"+
					" '1', to_char(to_date(?, 'YYYY-MM-DD')+1,'YYYY-MM-DD'),'7', to_char(to_date(?, 'YYYY-MM-DD')+2, 'YYYY-MM-DD'), 'N')"+
					" from dual";
		try{
			if(AddUtil.checkDate(sysdate)){	
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, sysdate);
				pstmt.setString(2, sysdate);
				pstmt.setString(3, sysdate);
			    rs = pstmt.executeQuery();			
				while(rs.next())
				{
					rtnStr = rs.getString(1)==null?"":rs.getString(1);
				}
				if(!rtnStr.equals("N"))	/* 일요일,토요일인 경우 하루나 이틀을 더해준다 */
				sysdate = rtnStr;

				rs.close();
				pstmt.close();
			}
		}catch (SQLException e){
			System.out.println("[AddFeeDatabase:checkSunday]\n"+e);
			System.out.println("[AddFeeDatabase:checkSunday]\n"+dt);
			System.out.println("[AddFeeDatabase:checkSunday]\n"+query);
	  		e.printStackTrace();
		}finally{
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sysdate;
		}
	}
	
	/**
	 *	args로 넘어온 날짜가 휴일인경우 하루씩 더해서 가장 가까운 평일날짜를 리턴
	 */
	public String checkHday(String dt)
	{
		getConnection();
		boolean flag = false;
		String sysdate = dt;
		String query;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String rtnStr = "";

		query = "select decode(count(0), 0, 'N', to_char(to_date(?, 'YYYY-MM-DD')+1, 'YYYY-MM-DD')) "+
				" from holiday "+
				" where hday = replace(?, '-', '')";
		try
		{

			while(!flag)
			{
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, sysdate);
				pstmt.setString(2, sysdate);
		    	rs = pstmt.executeQuery();
				while(rs.next())
				{
					rtnStr = rs.getString(1)==null?"":rs.getString(1);
				}
				if(!rtnStr.equals("N"))	sysdate = rtnStr;		/* 휴일인경우 하루를 더하고 다시 한번 휴일인지 확인 */
				else					flag = true;			/*  휴일이 아닌경우 loop를 빠져나온다. */

				rs.close();
				pstmt.close();

			}
		}catch (SQLException e)
		{
			System.out.println("[AddFeeDatabase:checkHday]\n"+e);
	  		e.printStackTrace();
		}
		finally
		{
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sysdate;
		}
	}	
	
	//한건 대여료 현황 조회
	public Hashtable getFeebase(String m_id, String l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		query = " select"+
				" rent_l_cd, nvl(firm_nm, client_nm) firm_nm, client_nm, car_nm, fee_est_day, pp_amt, ex_pp_amt,"+
				" ifee_amt, ex_ifee_amt, grt_amt, ex_grt_amt, fee_amt, ex_fee_amt, con_mon, ex_con_mon,"+
				" rent_way, rent_start_dt, rent_end_dt, init_reg_dt, ex_rent_start_dt, ex_rent_end_dt, rent_st,"+
				" car_no, fee_req_day, con_mon+ex_con_mon tot_con_mon, (fee_amt*con_mon)+(ex_fee_amt*ex_con_mon) tot_fee_amt,"+
				" trunc(((fee_amt*con_mon)+(ex_fee_amt*ex_con_mon))/(con_mon+ex_con_mon)) avg_fee_amt,"+
				" decode(sign(sysdate - to_date(rent_start_dt, 'YYYY-MM-DD')), -1, '0', trunc(months_between(sysdate, to_date(rent_start_dt, 'YYYY-MM-DD')))) r_mon,"+
				" decode(sign(sysdate - to_date(rent_start_dt, 'YYYY-MM-DD')), -1, '0', trunc(sysdate-add_months(to_date(rent_start_dt, 'YYYY-MM-DD'), trunc(months_between(sysdate, to_date(rent_start_dt, 'YYYY-MM-DD')))))) r_day,"+
				" brch_id, fee_chk, etc, client_id, prv_mon_yn, gi_st, bus_id, bus_id2, mng_id, rent_dt, fee_cdt"+
				" from"+
				" ("+
					" select"+
					" max(rent_l_cd) rent_l_cd, max(firm_nm) firm_nm, max(client_nm) client_nm,"+
					" max(car_nm) car_nm, max(fee_est_day) fee_est_day, max(rent_way) rent_way,"+ 
					" max(pp_amt) pp_amt, max(ex_pp_amt) ex_pp_amt,"+ 
					" max(ifee_amt) ifee_amt, max(ex_ifee_amt) ex_ifee_amt,"+ 
					" max(grt_amt) grt_amt, max(ex_grt_amt) ex_grt_amt,"+ 
					" max(fee_amt) fee_amt, max(ex_fee_amt) ex_fee_amt,"+ 
					" max(con_mon) con_mon, max(ex_con_mon) ex_con_mon,"+ 
					" decode(max(rent_start_dt), '', '', substr(max(rent_start_dt), 1, 4) || '-' || substr(max(rent_start_dt), 5, 2) || '-'||substr(max(rent_start_dt), 7, 2)) RENT_START_DT,"+
					" decode(max(rent_end_dt), '', '', substr(max(rent_end_dt), 1, 4) || '-' || substr(max(rent_end_dt), 5, 2) || '-'||substr(max(rent_end_dt), 7, 2)) RENT_END_DT,"+
					" decode(max(init_reg_dt), '', '', substr(max(init_reg_dt), 1, 4) || '-' || substr(max(init_reg_dt), 5, 2) || '-'||substr(max(init_reg_dt), 7, 2)) INIT_REG_DT,"+
					" decode(max(ex_rent_start_dt), '', '', substr(max(ex_rent_start_dt), 1, 4) || '-' || substr(max(ex_rent_start_dt), 5, 2) || '-'||substr(max(ex_rent_start_dt), 7, 2)) EX_RENT_START_DT,"+
					" decode(max(ex_rent_end_dt), '', '', substr(max(ex_rent_end_dt), 1, 4) || '-' || substr(max(ex_rent_end_dt), 5, 2) || '-'||substr(max(ex_rent_end_dt), 7, 2)) EX_RENT_END_DT,"+
					" max(to_number(rent_st)) rent_st, max(car_no) car_no, max(fee_req_day) fee_req_day,"+
					" max(brch_id) brch_id, max(fee_chk) fee_chk, max(etc) etc, max(client_id) client_id, max(prv_mon_yn) prv_mon_yn, max(gi_st) gi_st, "+
					" max(bus_id) bus_id, max(bus_id2) bus_id2, max(mng_id) mng_id, max(rent_dt) rent_dt, max(fee_cdt) fee_cdt "+
					" from"+
					" ("+
						" select"+
						" decode(rent_st, 1, rent_l_cd, '') rent_l_cd,"+
						" decode(rent_st, 1, firm_nm, '') firm_nm,"+
						" decode(rent_st, 1, client_nm, '') client_nm,"+
						" decode(rent_st, 1, car_nm, '') car_nm,"+
						" decode(rent_st, 1, fee_est_day, '') fee_est_day,"+
						" decode(rent_st, 1, pp_amt, 0) pp_amt,"+
						" decode(rent_st, 1, ifee_amt, 0) ifee_amt,"+
						" decode(rent_st, 1, grt_amt, 0) grt_amt,"+
						" decode(rent_st, 1, rent_way, '') rent_way,"+
						" decode(rent_st, 1, rent_start_dt, '') rent_start_dt,"+
						" decode(rent_st, 1, rent_end_dt, '') rent_end_dt,"+
						" decode(rent_st, 1, fee_amt, 0) fee_amt,"+
						" decode(rent_st, 1, init_reg_dt, '') INIT_REG_DT,"+
						" decode(rent_st, 1, car_no, '') car_no,"+
						" decode(rent_st, 1, fee_req_day, '') fee_req_day,"+
						" decode(rent_st, 1, con_mon, 0) con_mon,"+
						" decode(rent_st, 1, fee_cdt, '') fee_cdt,"+
						" decode(rent_st, 2, con_mon, 0) ex_con_mon,"+
						" decode(rent_st, 2, rent_start_dt, '') ex_rent_start_dt,"+
						" decode(rent_st, 2, rent_end_dt, '') ex_rent_end_dt,"+
						" decode(rent_st, 2, fee_amt, 0) ex_fee_amt,"+
						" decode(rent_st, 2, pp_amt, 0) ex_pp_amt,"+
						" decode(rent_st, 2, ifee_amt, 0) ex_ifee_amt,"+
						" decode(rent_st, 2, grt_amt, 0) ex_grt_amt,"+
						" rent_st, brch_id, fee_chk, etc, client_id, prv_mon_yn, gi_st, bus_id, bus_id2, mng_id, rent_dt"+
						" from"+
						" ("+
							" select"+
							"		F.rent_l_cd, F.fee_st, F.con_mon, F.fee_req_day, F.fee_est_day, F.rent_way,"+
							"		F.rent_start_dt, F.rent_end_dt, F.rent_st, F.fee_chk, F.prv_mon_yn,"+
							"		F.pp_s_amt+F.pp_v_amt PP_AMT,"+
							"		F.ifee_s_amt+F.ifee_v_amt IFEE_AMT,"+
							"		F.grt_amt_s grt_amt,"+
							"		F.fee_s_amt+F.fee_v_amt FEE_AMT,"+
							"		L.firm_nm, L.client_nm,"+
							"		R.car_nm, R.car_no, R.init_reg_dt,"+
							"		C.brch_id, L.etc, L.client_id, decode(E.gi_st,'1','보험','신용') gi_st, C.bus_id, C.bus_id2, C.mng_id,"+
							"		nvl(F.rent_dt,C.rent_dt) rent_dt, F.fee_cdt"+
							" from  fee F, cont C, client L, car_reg R, car_etc E "+
							" where F.rent_mng_id = C.rent_mng_id and F.rent_l_cd = C.rent_l_cd and"+
							"		C.client_id = L.client_id and"+
							"		C.car_mng_id = R.car_mng_id(+) and"+
							"		C.rent_mng_id = E.rent_mng_id and C.rent_l_cd = E.rent_l_cd and"+
							"		F.rent_l_cd = '"+l_cd+"'"+//F.rent_mng_id ='"+m_id+"' and 
						" )"+ 
					" )"+
				" )";
		
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
			System.out.println("[AddFeeDatabase:getFeebase]\n"+e);			
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

	//한건 대여료 현황 조회
	public Hashtable getFeebaseNew(String m_id, String l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		query = " select"+
				" rent_l_cd, nvl(firm_nm, client_nm) firm_nm, client_nm, car_nm, fee_est_day, pp_amt, "+
				" ifee_amt, grt_amt, fee_amt, con_mon, "+
				" rent_way, rent_start_dt, rent_end_dt, init_reg_dt, rent_st,"+
				" car_no, fee_req_day, tot_mon as tot_con_mon, "+
				" 0 tot_fee_amt, 0 avg_fee_amt,"+
				" decode(sign(sysdate - to_date(start_dt, 'YYYYMMDD')), -1, '0', trunc(months_between(sysdate, to_date(start_dt, 'YYYYMMDD')))) r_mon,"+
				" decode(sign(sysdate - to_date(start_dt, 'YYYYMMDD')), -1, '0', trunc(sysdate-add_months(to_date(start_dt, 'YYYYMMDD'), trunc(months_between(sysdate, to_date(start_dt, 'YYYYMMDD')))))) r_day,"+
				" brch_id, fee_chk, etc, client_id, prv_mon_yn, gi_st, bus_id, bus_id2, mng_id, rent_dt, fee_cdt"+
				" from"+
				" ("+
							" select"+
							"		F.rent_l_cd, F.fee_st, F.con_mon, F.fee_req_day, F.fee_est_day, F.rent_way,"+
							"		F.rent_start_dt, F.rent_end_dt, F.rent_st, F.fee_chk, F.prv_mon_yn,"+
							"		F.pp_s_amt+F.pp_v_amt PP_AMT,"+
							"		F.ifee_s_amt+F.ifee_v_amt IFEE_AMT,"+
							"		F.grt_amt_s grt_amt,"+
							"		F.fee_s_amt+F.fee_v_amt FEE_AMT,"+
							"		L.firm_nm, L.client_nm,"+
							"		R.car_nm, R.car_no, R.init_reg_dt,"+
							"		C.brch_id, L.etc, L.client_id, decode(E.gi_st,'1','보험','신용') gi_st, C.bus_id, C.bus_id2, C.mng_id,"+
							"		nvl(F.rent_dt,C.rent_dt) rent_dt, F.fee_cdt, "+
							"       F2.start_dt, F2.end_dt, F2.tot_mon "+
							" from  fee F, cont C, client L, car_reg R, car_etc E, "+
							"       ( select rent_mng_id, rent_l_cd,"+
                            "                max(to_number(rent_st)) rent_st, min(rent_start_dt) start_dt, max(rent_end_dt) end_dt, sum(con_mon) tot_mon"+
                            "         from   fee "+
							"         group by rent_mng_id, rent_l_cd) F2 "+
							" where F.rent_l_cd = '"+l_cd+"' and "+
							"       F.rent_mng_id = C.rent_mng_id and F.rent_l_cd = C.rent_l_cd and"+
							"		C.client_id = L.client_id and"+
							"		C.car_mng_id = R.car_mng_id(+) and"+
							"		C.rent_mng_id = E.rent_mng_id and C.rent_l_cd = E.rent_l_cd and"+
							"       F.rent_mng_id = F2.rent_mng_id and F.rent_l_cd = F2.rent_l_cd and F.rent_st=F2.rent_st "+
				" )";
		//System.out.println("|"+m_id);
		//System.out.println("|"+l_cd);
		//System.out.println("|"+query);
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
			System.out.println("[AddFeeDatabase:getFeebaseNew]\n"+e);			
			System.out.println("[AddFeeDatabase:getFeebaseNew]\n"+query);			
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


	//계약 변경 : 중도해지 조회
	public Hashtable getFeebasecls2(String m_id, String l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		query = " select"+
				" rent_l_cd, nvl(firm_nm, client_nm) firm_nm, client_nm, client_id, car_no, car_nm, rent_way, rent_start_dt,"+
				" rent_end_dt, init_reg_dt, pp_pay_amt, pp_amt, ex_pp_amt, ifee_amt, ex_ifee_amt,"+
				" grt_amt, ex_grt_amt, fee_amt, ex_fee_amt, con_mon, ex_con_mon, ex_rent_start_dt, ex_rent_end_dt,"+
				" rent_st, con_mon+ex_con_mon tot_con_mon,"+
				" (fee_amt*con_mon)+(ex_fee_amt*ex_con_mon)+(pp_amt) tot_fee_amt,"+
				" trunc(((fee_amt*con_mon)+(ex_fee_amt*ex_con_mon)+(pp_amt))/(con_mon+ex_con_mon)) avg_fee_amt,"+
				" decode( sign(sysdate - to_date(rent_start_dt, 'YYYY-MM-DD')), -1, '0', trunc(months_between(sysdate, to_date(rent_start_dt, 'YYYY-MM-DD')))) r_mon,"+
				" decode( sign(sysdate - to_date(rent_start_dt, 'YYYY-MM-DD')), -1, '0', trunc(sysdate-add_months(to_date(rent_start_dt, 'YYYY-MM-DD'), trunc(months_between(sysdate, to_date(rent_start_dt, 'YYYY-MM-DD')))))) r_day,"+
				" brch_id, car_mng_id, s_mon, s_day, fee_chk"+
				" from"+
				" ("+
					" select"+
					" max(rent_l_cd) rent_l_cd, max(firm_nm) firm_nm, max(client_id) client_id, max(client_nm) client_nm,"+
					" max(car_no) car_no, max(car_nm) car_nm, max(rent_way) rent_way,"+
					" max(rent_start_dt) rent_start_dt, max(rent_end_dt) rent_end_dt,"+
					" max(init_reg_dt) init_reg_dt, max(to_number(rent_st)) rent_st,"+
					" max(pp_amt) pp_amt, max(ex_pp_amt) ex_pp_amt,"+ 
					" max(ifee_amt) ifee_amt, max(ex_ifee_amt) ex_ifee_amt,"+ 
					" max(pp_pay_amt) pp_pay_amt, max(ex_pp_pay_amt) ex_pp_pay_amt,"+ 
					" max(grt_amt) grt_amt, max(ex_grt_amt) ex_grt_amt,"+ 
					" max(fee_amt) fee_amt, max(ex_fee_amt) ex_fee_amt,"+ 
					" max(con_mon) con_mon, max(ex_con_mon) ex_con_mon,"+ 
					" max(ex_rent_start_dt) ex_rent_start_dt, max(ex_rent_end_dt) ex_rent_end_dt,"+
					" max(brch_id) brch_id, max(car_mng_id) car_mng_id, max(fee_chk) fee_chk,"+
					" max(s_mon) s_mon, max(s_day) s_day"+
					" from"+
					" ("+
						" select"+
						" rent_st,"+
						" decode(rent_st, 1, rent_l_cd, '') rent_l_cd,"+
						" decode(rent_st, 1, firm_nm, '') firm_nm,"+
						" decode(rent_st, 1, client_id, '') client_id,"+						
						" decode(rent_st, 1, client_nm, '') client_nm,"+
						" decode(rent_st, 1, car_no, '') car_no,"+
						" decode(rent_st, 1, car_nm, '') car_nm,"+
						" decode(rent_st, 1, rent_way, '') rent_way,"+
						" decode(rent_st, 1, rent_start_dt, '') rent_start_dt,"+
						" decode(rent_st, 1, rent_end_dt, '') rent_end_dt,"+
						" decode(rent_st, 1, con_mon, 0) con_mon,"+
						" decode(rent_st, 1, fee_amt, 0) fee_amt,"+
						" decode(rent_st, 1, grt_amt, 0) grt_amt,"+
						" decode(rent_st, 1, pp_amt, 0) pp_amt,"+
						" decode(rent_st, 1, ifee_amt, 0) ifee_amt,"+
						" decode(rent_st, 1, pp_pay_amt, 0) pp_pay_amt,"+
						" decode(rent_st, 1, init_reg_dt, '') INIT_REG_DT,"+
						" decode(rent_st, 2, rent_start_dt, '') ex_rent_start_dt,"+
						" decode(rent_st, 2, rent_end_dt, '') ex_rent_end_dt,"+
						" decode(rent_st, 2, con_mon, 0) ex_con_mon,"+
						" decode(rent_st, 2, fee_amt, 0) ex_fee_amt,"+
						" decode(rent_st, 2, grt_amt, 0) ex_grt_amt,"+
						" decode(rent_st, 2, pp_amt, 0) ex_pp_amt,"+
						" decode(rent_st, 2, ifee_amt, 0) ex_ifee_amt,"+
						" decode(rent_st, 2, pp_pay_amt, 0) ex_pp_pay_amt,"+
						" brch_id, car_mng_id, s_mon, s_day, fee_chk"+
						" from"+
						" ("+
							" select"+
							" F.rent_l_cd, F.con_mon, F.rent_way, F.fee_chk,"+
							" decode(F.rent_end_dt, '','', substr(F.rent_end_dt,1,4)||'-'||substr(F.rent_end_dt,5,2)||'-'||substr(F.rent_end_dt,7,2)) rent_end_dt,"+
							" F.pp_s_amt+F.pp_v_amt as pp_amt, F.ifee_s_amt+F.ifee_v_amt as ifee_amt,"+
							" F.grt_amt_s as grt_amt, F.fee_s_amt+F.fee_v_amt as fee_amt, F.rent_st,"+
							" decode(F.rent_start_dt, '','', substr(F.rent_start_dt,1,4)||'-'||substr(F.rent_start_dt,5,2)||'-'||substr(F.rent_start_dt,7,2)) rent_start_dt,"+
							" C.brch_id, C.car_mng_id, L.client_id, L.firm_nm, L.client_nm, R.car_nm, R.car_no,"+
							" decode(R.init_reg_dt, '','', substr(R.init_reg_dt,1,4)||'-'||substr(R.init_reg_dt,5,2)||'-'||substr(R.init_reg_dt,7,2)) init_reg_dt,"+
							" S.s_mon, S.s_day, P.pp_pay_amt"+
							" from fee F, cont C, client L, car_reg R,"+
							" ("+
								" select"+
								" count(0) as s_mon, decode(max(fee_est_dt), '', 0, trunc(sysdate-add_months(to_date(max(fee_est_dt), 'YYYYMMDD'), trunc(months_between(sysdate, to_date(max(fee_est_dt), 'YYYYMMDD')))))) as s_day"+
								" from scd_fee"+
								" where rent_l_cd='"+l_cd+"'"+
								" and fee_est_dt < to_char(sysdate,'YYYYMMDD')"+
								" and rc_amt = 0"+
								" and tm_st1 = 0"+
							" ) S,"+
							" ("+
								" select sum(ext_pay_amt) as pp_pay_amt from scd_ext where ext_st in ('1', '2' ) and rent_mng_id ='"+m_id+"' and rent_l_cd='"+l_cd+"'"+
							" ) P"+
							" where F.rent_mng_id = C.rent_mng_id and"+
							" F.rent_l_cd = C.rent_l_cd and"+
							" C.client_id = L.client_id and"+
							" C.car_mng_id = R.car_mng_id(+) and"+
							" F.rent_mng_id ='"+m_id+"' and F.rent_l_cd = '"+l_cd+"'"+
						" )"+ 
					" )"+
				" )";		

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
			System.out.println("[AddFeeDatabase:getFeebasecls2]\n"+e);			
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
	
	//계약 변경 : 중도해지 조회
	public Hashtable getFeebasecls3(String m_id, String l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		query = " select"+
				" rent_l_cd, nvl(firm_nm, client_nm) firm_nm, client_nm, car_no, car_nm, rent_way, rent_start_dt,"+
				" rent_end_dt, init_reg_dt, pp_pay_amt, pp_amt, ex_pp_amt, ifee_amt, ex_ifee_amt,"+
				" grt_amt, ex_grt_amt, fee_amt, ex_fee_amt, con_mon, ex_con_mon, ex_rent_start_dt, ex_rent_end_dt,"+
				" rent_st, con_mon+ex_con_mon tot_con_mon,"+
				" (fee_amt*con_mon)+(ex_fee_amt*ex_con_mon)+(pp_amt) tot_fee_amt,"+
				" trunc(((fee_amt*con_mon)+(ex_fee_amt*ex_con_mon)+(pp_amt))/(con_mon+ex_con_mon)) avg_fee_amt,"+
				" decode( sign(sysdate - to_date(rent_start_dt, 'YYYY-MM-DD')), -1, '0', trunc(months_between(sysdate+1, to_date(rent_start_dt, 'YYYY-MM-DD')))) r_mon,"+
				" decode( sign(sysdate - to_date(rent_start_dt, 'YYYY-MM-DD')), -1, '0', trunc(sysdate+1-add_months(to_date(rent_start_dt, 'YYYY-MM-DD'), trunc(months_between(sysdate+1, to_date(rent_start_dt, 'YYYY-MM-DD')))))) r_day,"+
				" brch_id, car_mng_id, s_mon, s_day, fee_chk, tax_type"+
				" from"+
				" ("+
					" select"+
					" max(rent_l_cd) rent_l_cd, max(firm_nm) firm_nm, max(client_nm) client_nm,"+
					" max(car_no) car_no, max(car_nm) car_nm, max(rent_way) rent_way,"+
					" max(rent_start_dt) rent_start_dt, max(rent_end_dt) rent_end_dt,"+
					" max(init_reg_dt) init_reg_dt, max(to_number(rent_st)) rent_st,"+
					" max(pp_amt) pp_amt, max(ex_pp_amt) ex_pp_amt,"+ 
					" max(ifee_amt) ifee_amt, max(ex_ifee_amt) ex_ifee_amt,"+ 
					" max(pp_pay_amt) pp_pay_amt, max(ex_pp_pay_amt) ex_pp_pay_amt,"+ 
					" max(grt_amt) grt_amt, max(ex_grt_amt) ex_grt_amt,"+ 
					" max(fee_amt) fee_amt, max(ex_fee_amt) ex_fee_amt,"+ 
					" max(con_mon) con_mon, max(ex_con_mon) ex_con_mon,"+ 
					" max(ex_rent_start_dt) ex_rent_start_dt, max(ex_rent_end_dt) ex_rent_end_dt,"+
					" max(brch_id) brch_id, max(car_mng_id) car_mng_id, max(fee_chk) fee_chk,"+
					" max(s_mon) s_mon, max(s_day) s_day, max(tax_type) tax_type"+
					" from"+
					" ("+
						" select"+
						" rent_st,"+
						" decode(rent_st, 1, rent_l_cd, '') rent_l_cd,"+
						" decode(rent_st, 1, firm_nm, '') firm_nm,"+
						" decode(rent_st, 1, client_nm, '') client_nm,"+
						" decode(rent_st, 1, car_no, '') car_no,"+
						" decode(rent_st, 1, car_nm, '') car_nm,"+
						" decode(rent_st, 1, rent_way, '') rent_way,"+
						" decode(rent_st, 1, rent_start_dt, '') rent_start_dt,"+
						" decode(rent_st, 1, rent_end_dt, '') rent_end_dt,"+
						" decode(rent_st, 1, con_mon, 0) con_mon,"+
						" decode(rent_st, 1, fee_amt, 0) fee_amt,"+
						" decode(rent_st, 1, grt_amt, 0) grt_amt,"+
						" decode(rent_st, 1, pp_amt, 0) pp_amt,"+
						" decode(rent_st, 1, ifee_amt, 0) ifee_amt,"+
						" decode(rent_st, 1, pp_pay_amt, 0) pp_pay_amt,"+
						" decode(rent_st, 1, init_reg_dt, '') INIT_REG_DT,"+
						" decode(rent_st, 1,'', rent_start_dt) ex_rent_start_dt,"+
						" decode(rent_st, 1,'', rent_end_dt) ex_rent_end_dt,"+
						" decode(rent_st, 1,0, con_mon) ex_con_mon,"+
						" decode(rent_st, 1,0, fee_amt) ex_fee_amt,"+
						" decode(rent_st, 1,0, grt_amt) ex_grt_amt,"+
						" decode(rent_st, 1,0, pp_amt) ex_pp_amt,"+
						" decode(rent_st, 1,0, ifee_amt) ex_ifee_amt,"+
						" decode(rent_st, 1,0, pp_pay_amt) ex_pp_pay_amt,"+
						" brch_id, car_mng_id, s_mon, s_day, fee_chk, tax_type"+
						" from"+
						" ("+
							" select"+
							" F.rent_l_cd, F.con_mon, F.rent_way, F.fee_chk,"+
							" decode(F.rent_end_dt, '','', substr(F.rent_end_dt,1,4)||'-'||substr(F.rent_end_dt,5,2)||'-'||substr(F.rent_end_dt,7,2)) rent_end_dt,"+
							" F.pp_s_amt as pp_amt, F.ifee_s_amt as ifee_amt,"+
							" F.grt_amt_s as grt_amt, F.fee_s_amt as fee_amt, F.rent_st,"+
							" decode(F.rent_start_dt, '','', substr(F.rent_start_dt,1,4)||'-'||substr(F.rent_start_dt,5,2)||'-'||substr(F.rent_start_dt,7,2)) rent_start_dt,"+
							" C.brch_id, C.car_mng_id, L.firm_nm, L.client_nm, R.car_nm, R.car_no,"+
							" decode(R.init_reg_dt, '','', substr(R.init_reg_dt,1,4)||'-'||substr(R.init_reg_dt,5,2)||'-'||substr(R.init_reg_dt,7,2)) init_reg_dt,"+
							" S.s_mon, S.s_day, P.pp_pay_amt, C.tax_type"+
							" from fee F, cont C, client L, car_reg R,"+
							" ("+
								" select"+
								" count(0) as s_mon, decode(max(fee_est_dt), '', 0, trunc(sysdate-add_months(to_date(max(fee_est_dt), 'YYYYMMDD'), trunc(months_between(sysdate, to_date(max(fee_est_dt), 'YYYYMMDD')))))) as s_day"+
								" from scd_fee"+
								" where rent_l_cd='"+l_cd+"'"+
								" and fee_est_dt < to_char(sysdate,'YYYYMMDD')"+
								" and rc_amt = 0"+
								" and tm_st1 = 0"+
							" ) S,"+
							" ("+
								" select sum(ext_pay_amt) as pp_pay_amt from scd_ext where ext_st in ('1','2') and rent_mng_id ='"+m_id+"' and rent_l_cd='"+l_cd+"'"+
							" ) P"+
							" where F.rent_mng_id = C.rent_mng_id and"+
							" F.rent_l_cd = C.rent_l_cd and"+
							" C.client_id = L.client_id and"+
							" C.car_mng_id = R.car_mng_id(+) and"+
							" F.rent_mng_id ='"+m_id+"' and F.rent_l_cd = '"+l_cd+"'"+
						" )"+ 
					" )"+
				" )";		

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
			System.out.println("[AddFeeDatabase:getFeebasecls3]\n"+e);			
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
	 *	납부된 대여료,선납금,초기대여료
	 */			
	public Hashtable getPayedFee(String m_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		query = " select"+
				" A.sum fee_sum, A.cnt fee_cnt, B.sum pp_sum, B.cnt pp_cnt, C.sum ifee_sum, C.cnt ifee_cnt"+
				" from"+
				" ("+
					" select sum(rc_amt) sum, count(0) cnt"+
					" from scd_fee"+
					" where rent_mng_id='"+m_id+"' and"+
					" rc_yn='1'"+
				" ) A,"+
				" ("+
					" select sum(ext_pay_amt) sum, count(0) cnt"+
					" from scd_ext"+
					" where rent_mng_id='"+m_id+"' and"+
					" ext_st='1' and ext_pay_amt <> 0"+
				" ) B,"+
				" ("+
					" select sum(ext_pay_amt) sum, count(0) cnt"+
					" from scd_ext"+
					" where rent_mng_id='"+m_id+"' and"+
					" ext_st='2' and ext_pay_amt <> 0"+
				" ) C";

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
			System.out.println("[AddFeeDatabase:getPayedFee]\n"+e);			
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
	 *	대여료스케줄 조회 화면 펼쳐질때 호출. 연체료/일 계산.
	 */
	public boolean calDelay(String m_id, String l_cd)
	{
		getConnection();
		boolean flag = true;
		Statement stmt1 = null;
		Statement stmt2 = null;
		Statement stmt3 = null;

		//연체일 있는 경우(입금:입금일>입금예정일, 미입금:현재날자>입금예정일)
		String query1 = " UPDATE SCD_FEE SET"+
						" dly_days = TRUNC(NVL(TO_DATE(rc_dt, 'YYYYMMDD'), SYSDATE) - TO_DATE(r_fee_est_dt, 'YYYYMMDD')),"+
						" dly_fee = (TRUNC(((decode(rc_amt,0,fee_s_amt+fee_v_amt,rc_amt))*0.24*TRUNC(TO_DATE(r_fee_est_dt, 'YYYYMMDD')- NVL(TO_DATE(rc_dt, 'YYYYMMDD'), SYSDATE)))/365) * -1)"+
						" WHERE bill_yn='Y' and rent_mng_id = '"+m_id+"' and rent_l_cd = '"+l_cd+"'"+
						" and nvl(rc_dt,to_char(sysdate,'YYYYMMDD')) > r_fee_est_dt"+
						" and (rent_l_cd, rent_mng_id, rent_st) in (select a.rent_l_cd, a.rent_mng_id, a.rent_st from fee a, cont b, cont_etc c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and decode(c.rent_suc_dt,'',decode(a.rent_st,'1',b.rent_dt,a.rent_dt),c.rent_suc_dt) < '20220101')" ;

	
		//연체일 있는 경우(입금:입금일>입금예정일, 미입금:현재날자>입금예정일)
		String query2 = " UPDATE SCD_FEE SET"+
						" dly_days = TRUNC(NVL(TO_DATE(rc_dt, 'YYYYMMDD'), SYSDATE) - TO_DATE(r_fee_est_dt, 'YYYYMMDD')),"+
						" dly_fee = (TRUNC(((decode(rc_amt,0,fee_s_amt+fee_v_amt,rc_amt))*0.20*TRUNC(TO_DATE(r_fee_est_dt, 'YYYYMMDD')- NVL(TO_DATE(rc_dt, 'YYYYMMDD'), SYSDATE)))/365) * -1)"+
						" WHERE bill_yn='Y' and rent_mng_id = '"+m_id+"' and rent_l_cd = '"+l_cd+"'"+
						" and nvl(rc_dt,to_char(sysdate,'YYYYMMDD')) > r_fee_est_dt"+
						" and (rent_l_cd, rent_mng_id, rent_st) in (select a.rent_l_cd, a.rent_mng_id, a.rent_st from fee a, cont b, cont_etc c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and decode(c.rent_suc_dt,'',decode(a.rent_st,'1',b.rent_dt,a.rent_dt),c.rent_suc_dt) >= '20220101')" ;

		//연체일 없는 경우(입금:입금일=입금예정일, 입금일<입금예정일(선수), 미입금:현재날짜<입금예정일)
		String query3 = " UPDATE SCD_FEE set"+
						" dly_days = '0',"+
						" dly_fee = 0"+
						" WHERE bill_yn='Y' and rent_mng_id = '"+m_id+"' and rent_l_cd = '"+l_cd+"'"+
						" and nvl(rc_dt,to_char(sysdate,'YYYYMMDD')) <= r_fee_est_dt";

		try 
		{
			conn.setAutoCommit(false);

			stmt1 = conn.createStatement();
		    stmt1.executeUpdate(query1);
			stmt1.close();

			stmt2 = conn.createStatement();
		    stmt2.executeUpdate(query2);
			stmt2.close();

			stmt3 = conn.createStatement();
		    stmt3.executeUpdate(query3);
			stmt3.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddFeeDatabase:calDelay]\n"+e);			
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(stmt1 != null)	stmt1.close();
				if(stmt2 != null)	stmt2.close();
				if(stmt3 != null)	stmt3.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	/**
	 *	대여료스케줄 조회 화면 펼쳐질때 호출. 연체료/일 계산.
	 */
	public boolean calDelay(String l_cd)
	{
		getConnection();
		boolean flag = true;
		Statement stmt1 = null;
		Statement stmt2 = null;
		Statement stmt3 = null;

		//연체일 있는 경우(입금:입금일>입금예정일, 미입금:현재날자>입금예정일)
		String query1 = " UPDATE SCD_FEE SET"+
						" dly_days = TRUNC(NVL(TO_DATE(rc_dt, 'YYYYMMDD'), SYSDATE) - TO_DATE(r_fee_est_dt, 'YYYYMMDD')),"+
						" dly_fee = (TRUNC(((decode(rc_amt,0,fee_s_amt+fee_v_amt,rc_amt))*0.24*TRUNC(TO_DATE(r_fee_est_dt, 'YYYYMMDD')- NVL(TO_DATE(rc_dt, 'YYYYMMDD'), SYSDATE)))/365) * -1)"+
						" WHERE bill_yn='Y' and rent_l_cd = '"+l_cd+"'"+
						" and nvl(rc_dt,to_char(sysdate,'YYYYMMDD')) > r_fee_est_dt"+
						" and (rent_l_cd, rent_mng_id, rent_st) in (select a.rent_l_cd, a.rent_mng_id, a.rent_st from fee a, cont b, cont_etc c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and decode(c.rent_suc_dt,'',decode(a.rent_st,'1',b.rent_dt,a.rent_dt),c.rent_suc_dt) < '20220101')" ;
						
		//연체일 있는 경우(입금:입금일>입금예정일, 미입금:현재날자>입금예정일)
		String query2 = " UPDATE SCD_FEE SET"+
						" dly_days = TRUNC(NVL(TO_DATE(rc_dt, 'YYYYMMDD'), SYSDATE) - TO_DATE(r_fee_est_dt, 'YYYYMMDD')),"+
						" dly_fee = (TRUNC(((decode(rc_amt,0,fee_s_amt+fee_v_amt,rc_amt))*0.20*TRUNC(TO_DATE(r_fee_est_dt, 'YYYYMMDD')- NVL(TO_DATE(rc_dt, 'YYYYMMDD'), SYSDATE)))/365) * -1)"+
						" WHERE bill_yn='Y' and rent_l_cd = '"+l_cd+"'"+
						" and nvl(rc_dt,to_char(sysdate,'YYYYMMDD')) > r_fee_est_dt"+
						" and (rent_l_cd, rent_mng_id, rent_st) in (select a.rent_l_cd, a.rent_mng_id, a.rent_st from fee a, cont b, cont_etc c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and decode(c.rent_suc_dt,'',decode(a.rent_st,'1',b.rent_dt,a.rent_dt),c.rent_suc_dt) >= '20220101')" ;

		//연체일 없는 경우(입금:입금일=입금예정일, 입금일<입금예정일(선수), 미입금:현재날짜<입금예정일)
		String query3 = " UPDATE SCD_FEE set"+
						" dly_days = '0',"+
						" dly_fee = 0"+
						" WHERE bill_yn='Y' and rent_l_cd = '"+l_cd+"'"+
						" and nvl(rc_dt,to_char(sysdate,'YYYYMMDD')) <= r_fee_est_dt";

		try 
		{
			conn.setAutoCommit(false);

			stmt1 = conn.createStatement();
		    stmt1.executeUpdate(query1);
			stmt1.close();

			stmt2 = conn.createStatement();
		    stmt2.executeUpdate(query2);
			stmt2.close();

			stmt3 = conn.createStatement();
		    stmt3.executeUpdate(query3);
			stmt3.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddFeeDatabase:calDelay]\n"+e);			
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(stmt1 != null)	stmt1.close();
				if(stmt2 != null)	stmt2.close();
				if(stmt3 != null)	stmt3.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	/**
	 *	대여료스케줄 조회 화면 펼쳐질때 호출. 연체료/일 계산.
	 */
	public boolean calDelayPrint(String m_id, String l_cd, String cls_dt)
	{
		getConnection();
		boolean flag = true;
		Statement stmt1 = null;
		Statement stmt2 = null;
		Statement stmt3 = null;

		String today = "to_char(sysdate,'YYYYMMDD')";
		//if(!cls_dt.equals("")) today = "replace('"+cls_dt+"','-','')";
		String today2 = "SYSDATE";
		//if(!cls_dt.equals("")) today2 = "TO_DATE(replace('"+cls_dt+"','-',''), 'YYYYMMDD')";
		
		

		//연체일 있는 경우(입금:입금일>입금예정일, 미입금:현재날자>입금예정일)
		String query1 = " UPDATE SCD_FEE SET"+
						" dly_days = TRUNC(NVL(TO_DATE(rc_dt, 'YYYYMMDD'), "+today2+") - TO_DATE(r_fee_est_dt, 'YYYYMMDD')),"+
						" dly_fee = (TRUNC(((decode(rc_amt,0,fee_s_amt+fee_v_amt,rc_amt))*0.24*TRUNC(TO_DATE(r_fee_est_dt, 'YYYYMMDD')- NVL(TO_DATE(rc_dt, 'YYYYMMDD'), "+today2+")))/365) * -1)"+
						" WHERE bill_yn='Y' and rent_mng_id = '"+m_id+"'"+// and rent_l_cd = '"+l_cd+"'
						" and nvl(rc_dt,"+today+") > r_fee_est_dt"+
						" and (rent_l_cd, rent_mng_id, rent_st) in (select a.rent_l_cd, a.rent_mng_id, a.rent_st from fee a, cont b, cont_etc c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and decode(c.rent_suc_dt,'',decode(a.rent_st,'1',b.rent_dt,a.rent_dt),c.rent_suc_dt) < '20220101')" ;

		//연체일 있는 경우(입금:입금일>입금예정일, 미입금:현재날자>입금예정일)
		String query2 = " UPDATE SCD_FEE SET"+
						" dly_days = TRUNC(NVL(TO_DATE(rc_dt, 'YYYYMMDD'), "+today2+") - TO_DATE(r_fee_est_dt, 'YYYYMMDD')),"+
						" dly_fee = (TRUNC(((decode(rc_amt,0,fee_s_amt+fee_v_amt,rc_amt))*0.20*TRUNC(TO_DATE(r_fee_est_dt, 'YYYYMMDD')- NVL(TO_DATE(rc_dt, 'YYYYMMDD'), "+today2+")))/365) * -1)"+
						" WHERE bill_yn='Y' and rent_mng_id = '"+m_id+"'"+// and rent_l_cd = '"+l_cd+"'
						" and nvl(rc_dt,"+today+") > r_fee_est_dt"+
						" and (rent_l_cd, rent_mng_id, rent_st) in (select a.rent_l_cd, a.rent_mng_id, a.rent_st from fee a, cont b, cont_etc c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and decode(c.rent_suc_dt,'',decode(a.rent_st,'1',b.rent_dt,a.rent_dt),c.rent_suc_dt) >= '20220101')" ;

		//연체일 없는 경우(입금:입금일=입금예정일, 입금일<입금예정일(선수), 미입금:현재날짜<입금예정일)
		String query3 = " UPDATE SCD_FEE set"+
						" dly_days = '0',"+
						" dly_fee = 0"+
						" WHERE bill_yn='Y' and rent_mng_id = '"+m_id+"'"+// and rent_l_cd = '"+l_cd+"'
						" and nvl(rc_dt,"+today+") <= r_fee_est_dt";


		try 
		{
			conn.setAutoCommit(false);

			stmt1 = conn.createStatement();
		    stmt1.executeUpdate(query1);
			stmt1.close();

			stmt2 = conn.createStatement();
		    stmt2.executeUpdate(query2);
			stmt2.close();

			stmt3 = conn.createStatement();
		    stmt3.executeUpdate(query3);
			stmt3.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddFeeDatabase:calDelayPrint]\n"+e);			
			System.out.println("[AddFeeDatabase:calDelayPrint]\n"+query1);			
			System.out.println("[AddFeeDatabase:calDelayPrint]\n"+query2);			
			System.out.println("[AddFeeDatabase:calDelayPrint]\n"+query3);			
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(stmt1 != null)	stmt1.close();
				if(stmt2 != null)	stmt2.close();
				if(stmt3 != null)	stmt3.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	

	/**
	 *	연체료/일 계산. -- 개별 row
	 */
	public boolean calDelay(String m_id, String l_cd, String fee_tm)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;

		String query = " UPDATE SCD_FEE SET"+
						" dly_days = DECODE(SIGN(TRUNC(NVL(TO_DATE(rc_dt, 'YYYYMMDD'), SYSDATE) - TO_DATE(r_fee_est_dt, 'YYYYMMDD'))) , 1, TRUNC(NVL(TO_DATE(rc_dt, 'YYYYMMDD'), SYSDATE) - TO_DATE(r_fee_est_dt, 'YYYYMMDD')), '0'),"+
						" dly_fee = DECODE(SIGN(TRUNC(NVL(TO_DATE(rc_dt, 'YYYYMMDD'), SYSDATE) - TO_DATE(r_fee_est_dt, 'YYYYMMDD'))) , 1, (TRUNC(((fee_s_amt+fee_v_amt)*0.24*TRUNC(TO_DATE(r_fee_est_dt, 'YYYYMMDD')- NVL(TO_DATE(rc_dt, 'YYYYMMDD'), SYSDATE)))/365) * -1), '0')"+
						" WHERE bill_yn='Y' and rent_mng_id=? AND"+
					  	" rent_l_cd=? AND"+
					  	" fee_tm=?"+
						" and (rent_l_cd, rent_mng_id, rent_st) in (select a.rent_l_cd, a.rent_mng_id, a.rent_st from fee a, cont b, cont_etc c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=c.rent_l_cd and decode(c.rent_suc_dt,'',nvl(a.rent_dt,b.rent_dt),c.rent_suc_dt) < '20220101')" ;

		String query2 = " UPDATE SCD_FEE SET"+
						" dly_days = DECODE(SIGN(TRUNC(NVL(TO_DATE(rc_dt, 'YYYYMMDD'), SYSDATE) - TO_DATE(r_fee_est_dt, 'YYYYMMDD'))) , 1, TRUNC(NVL(TO_DATE(rc_dt, 'YYYYMMDD'), SYSDATE) - TO_DATE(r_fee_est_dt, 'YYYYMMDD')), '0'),"+
						" dly_fee = DECODE(SIGN(TRUNC(NVL(TO_DATE(rc_dt, 'YYYYMMDD'), SYSDATE) - TO_DATE(r_fee_est_dt, 'YYYYMMDD'))) , 1, (TRUNC(((fee_s_amt+fee_v_amt)*0.20*TRUNC(TO_DATE(r_fee_est_dt, 'YYYYMMDD')- NVL(TO_DATE(rc_dt, 'YYYYMMDD'), SYSDATE)))/365) * -1), '0')"+
						" WHERE bill_yn='Y' and rent_mng_id=? AND"+
					  	" rent_l_cd=? AND"+
					  	" fee_tm=?"+
						" and (rent_l_cd, rent_mng_id, rent_st) in (select a.rent_l_cd, a.rent_mng_id, a.rent_st from fee a, cont b, cont_etc c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=c.rent_l_cd and decode(c.rent_suc_dt,'',nvl(a.rent_dt,b.rent_dt),c.rent_suc_dt) >= '20220101')" ;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, m_id);
			pstmt.setString(2, l_cd);
			pstmt.setString(3, fee_tm);
		    pstmt.executeUpdate();
			pstmt.close();

			pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString(1, m_id);
			pstmt2.setString(2, l_cd);
			pstmt2.setString(3, fee_tm);
		    pstmt2.executeUpdate();
			pstmt2.close();

			conn.commit();

	  	} catch (Exception e) {
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
				if(pstmt2 != null)	pstmt2.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	/**
	 *	대여료스케줄 일괄 연체료 셋팅
	 */
	public boolean calDelayAll()
	{
		getConnection();
		boolean flag = true;
		Statement stmt1 = null;
		Statement stmt2 = null;
		String today = "to_char(sysdate,'YYYYMMDD')";
		String today2 = "SYSDATE";

		//연체일 있는 경우(입금:입금일>입금예정일, 미입금:현재날자>입금예정일)
		String query1 = " UPDATE SCD_FEE SET"+
						" dly_days = TRUNC("+today2+" - TO_DATE(r_fee_est_dt, 'YYYYMMDD')),"+
						" dly_fee = (TRUNC(((decode(rc_amt,0,fee_s_amt+fee_v_amt,rc_amt))*0.24*TRUNC(TO_DATE(r_fee_est_dt, 'YYYYMMDD')- "+today2+"))/365) * -1)"+
						" WHERE bill_yn='Y' and rc_dt is null and r_fee_est_dt < "+today+""+
						" and (rent_l_cd, rent_mng_id, rent_st) in (select a.rent_l_cd, a.rent_mng_id, a.rent_st from fee a, cont b, cont_etc c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and decode(c.rent_suc_dt,'',decode(a.rent_st,'1',b.rent_dt,a.rent_dt),c.rent_suc_dt) < '20220101')" ;

		//연체일 있는 경우(입금:입금일>입금예정일, 미입금:현재날자>입금예정일)
		String query2 = " UPDATE SCD_FEE SET"+
						" dly_days = TRUNC("+today2+" - TO_DATE(r_fee_est_dt, 'YYYYMMDD')),"+
						" dly_fee = (TRUNC(((decode(rc_amt,0,fee_s_amt+fee_v_amt,rc_amt))*0.20*TRUNC(TO_DATE(r_fee_est_dt, 'YYYYMMDD')- "+today2+"))/365) * -1)"+
						" WHERE bill_yn='Y' and rc_dt is null and r_fee_est_dt < "+today+""+
						" and (rent_l_cd, rent_mng_id, rent_st) in (select a.rent_l_cd, a.rent_mng_id, a.rent_st from fee a, cont b, cont_etc c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and decode(c.rent_suc_dt,'',decode(a.rent_st,'1',b.rent_dt,a.rent_dt),c.rent_suc_dt) >= '20220101')" ;

		try 
		{
			conn.setAutoCommit(false);

			stmt1 = conn.createStatement();
		    stmt1.executeUpdate(query1);
			stmt1.close();

			stmt2 = conn.createStatement();
		    stmt2.executeUpdate(query2);
			stmt2.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddFeeDatabase:calDelayAll]\n"+e);			
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(stmt1 != null)	stmt1.close();
				if(stmt2 != null)	stmt2.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	/**
	 * 건별 대여료 스케줄 : 대여료 변경 /con_fee/cng_ext_amt_i_a.jsp
	 */
	public int changeFeeamt(FeeScdBean ext_fee, int fee_tm)
	{
		getConnection();
		int flag = 0;
		PreparedStatement pstmt = null;

		String query = " UPDATE SCD_FEE SET"+
						" fee_s_amt = ?, fee_v_amt=?, update_dt=to_char(sysdate,'YYYYMMDD'), update_id=?,"+
						" pay_cng_dt=to_char(sysdate,'YYYYMMDD'), pay_cng_cau=pay_cng_cau||'/'||?"+
						" WHERE rent_mng_id=? AND rent_l_cd=? AND to_number(fee_tm) >=?";
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, ext_fee.getFee_s_amt());
			pstmt.setInt(2, ext_fee.getFee_v_amt());
			pstmt.setString(3, ext_fee.getUpdate_id());
			pstmt.setString(4, ext_fee.getPay_cng_cau());
			pstmt.setString(5, ext_fee.getRent_mng_id());
			pstmt.setString(6, ext_fee.getRent_l_cd());
			pstmt.setInt(7, fee_tm);
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[AddFeeDatabase:changeFeeamt]"+e);
	  		e.printStackTrace();
			flag = 1;
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
	 *	납부된 대여료,선납금,초기대여료
	 */			
	public int getTaeCnt(String m_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		int tae_cnt = 0;
		String query = "";
		query = " select count(0) from scd_fee where rent_mng_id='"+m_id+"' and tm_st2='2'";

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
			if(rs.next())
			{				
				tae_cnt = rs.getInt(1);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getTaeCnt]\n"+e);			
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return tae_cnt;
		}	
	}

	/**
	 *	납부된 대여료,선납금,초기대여료
	 */			
	public int getTaeCnt_lcd(String l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		int tae_cnt = 0;
		String query = "";
		query = " select count(0) from scd_fee where rent_l_cd='"+l_cd+"' and tm_st2='2'";

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
			if(rs.next())
			{				
				tae_cnt = rs.getInt(1);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getTaeCnt_lcd]\n"+e);			
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return tae_cnt;
		}	
	}

	/**
	 *	납부된 대여료,선납금,초기대여료
	 */			
	public int getFeeScdCnt_lcd(String l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		int tae_cnt = 0;
		String query = "";
		query = " select count(0) from scd_fee where rent_l_cd='"+l_cd+"'";

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
			if(rs.next())
			{				
				tae_cnt = rs.getInt(1);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getFeeScdCnt_lcd]\n"+e);			
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return tae_cnt;
		}	
	}

	/**
	 *	납부된 대여료,선납금,초기대여료
	 */			
	public String getMaxMemo(String m_id, String l_cd, String tm_st1)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		String memo = "";
		String query = "";
		String where = "";

		if(tm_st1.equals("7")) where = " and tm_st1='7'";
		if(tm_st1.equals("8")) where = " and tm_st1='8'";
		if(tm_st1.equals("9")) where = " and tm_st1='9'";

		query = " select substr(a.reg_dt,1,4)||'-'||substr(a.reg_dt,5,2)||'-'||substr(a.reg_dt,7,2)||'  ['||b.user_nm||' --> '||a.speaker|| ']  '||a.content"+
				" from dly_mm a, users b"+
				" where a.rent_l_cd='"+l_cd+"' "+where+
				" and a.reg_dt||a.reg_dt_time = (select max(reg_dt||reg_dt_time) max_dt from dly_mm where rent_l_cd='"+l_cd+"'"+where+")"+//rent_mng_id='"+m_id+"' and 
				" and a.reg_id=b.user_id";//rent_mng_id='"+m_id+"' and 

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
			if(rs.next())
			{				
				memo = rs.getString(1);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getMaxMemo]\n"+e);			
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return memo;
		}	
	}

	/**
	 *	대여카운터
	 */			
	public int getFeeCount(String l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		int tae_cnt = 0;
		String query = "";
		query = " select count(0) from fee where rent_l_cd='"+l_cd+"'";

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
			if(rs.next())
			{				
				tae_cnt = rs.getInt(1);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getFeeCount]\n"+e);			
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return tae_cnt;
		}	
	}

	/**
	 *	현재 진행중인 대여조회
	 */			
	public FeeScdBean getFeeScdIngCase(String m_id, String l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		FeeScdBean fee_scd = new FeeScdBean();
		String query = "";

		query = " select * from scd_fee where rent_l_cd='"+l_cd+"' and rc_yn='0' and tm_st1='0'"+ 
				" and (fee_tm, rent_st) = (select min(fee_tm) fee_tm, min(to_number(rent_st)) rent_st from scd_fee where rent_l_cd='"+l_cd+"' and rc_yn='0' and tm_st1='0' )";
	

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
			if(rs.next())
			{							
				fee_scd.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_scd.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_scd.setRent_seq(rs.getString("RENT_SEQ")==null?"":rs.getString("RENT_SEQ"));
				fee_scd.setTm_st1(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				fee_scd.setTm_st2(rs.getString("TM_ST2")==null?"":rs.getString("TM_ST2"));
				fee_scd.setFee_est_dt(rs.getString("FEE_EST_DT")==null?"":rs.getString("FEE_EST_DT"));
				fee_scd.setFee_s_amt(rs.getString("FEE_S_AMT")==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee_scd.setFee_v_amt(rs.getString("FEE_V_AMT")==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee_scd.setRc_yn(rs.getString("RC_YN")==null?"":rs.getString("RC_YN"));
				fee_scd.setRc_dt(rs.getString("RC_DT")==null?"":rs.getString("RC_DT"));
				fee_scd.setRc_amt(rs.getString("RC_AMT")==null?0:Integer.parseInt(rs.getString("RC_AMT")));
				fee_scd.setDly_days(rs.getString("DLY_DAYS")==null?"":rs.getString("DLY_DAYS"));
				fee_scd.setDly_fee(rs.getString("DLY_FEE")==null?0:Integer.parseInt(rs.getString("DLY_FEE")));
				fee_scd.setPay_cng_dt(rs.getString("PAY_CNG_DT")==null?"":rs.getString("PAY_CNG_DT"));
				fee_scd.setPay_cng_cau(rs.getString("PAY_CNG_CAU")==null?"":rs.getString("PAY_CNG_CAU"));
				fee_scd.setR_fee_est_dt(rs.getString("R_FEE_EST_DT")==null?"":rs.getString("R_FEE_EST_DT"));
				fee_scd.setExt_dt(rs.getString("EXT_DT")==null?"":rs.getString("EXT_DT"));
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getFeeCount]\n"+e);			
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return fee_scd;
		}	
	}

	//세금계산서 발행 일시중지 관리---------------------------------------------------------------------

	/**
	 *	스케줄 계산서발행 일시중지 리스트
	 */
	public Vector getFeeScdStopList(String m_id, String l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select * from scd_fee_stop where rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"' order by stop_s_dt, stop_e_dt";

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			while(rs.next())
			{
				FeeScdStopBean fee_scd = new FeeScdStopBean();
				fee_scd.setRent_mng_id	(rs.getString(1)==null?"":rs.getString(1));
				fee_scd.setRent_l_cd	(rs.getString(2)==null?"":rs.getString(2));
				fee_scd.setSeq 			(rs.getString(3)==null?"":rs.getString(3));
				fee_scd.setStop_st 		(rs.getString(4)==null?"":rs.getString(4));
				fee_scd.setStop_s_dt	(rs.getString(5)==null?"":rs.getString(5));
				fee_scd.setStop_e_dt	(rs.getString(6)==null?"":rs.getString(6));
				fee_scd.setStop_cau 	(rs.getString(7)==null?"":rs.getString(7));
				fee_scd.setStop_doc_dt 	(rs.getString(8)==null?"":rs.getString(8));
				fee_scd.setStop_doc		(rs.getString(9)==null?"":rs.getString(9));
				fee_scd.setStop_tax_dt	(rs.getString(10)==null?"":rs.getString(10));			
				fee_scd.setReg_dt 		(rs.getString(11)==null?"":rs.getString(11));
				fee_scd.setReg_id 		(rs.getString(12)==null?"":rs.getString(12));
				fee_scd.setCancel_dt	(rs.getString(13)==null?"":rs.getString(13));
				fee_scd.setCancel_id	(rs.getString(14)==null?"":rs.getString(14));
				fee_scd.setDoc_id		(rs.getString(15)==null?"":rs.getString(15));
				fee_scd.setRent_seq 	(rs.getString(16)==null?"":rs.getString(16));
				vt.add(fee_scd);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getFeeScdStopList]\n"+e);
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
	 *	세금계산서 발행 일시중지 쿼리
	 */
	public FeeScdStopBean getFeeScdStop(String m_id, String l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		FeeScdStopBean fee_scd = new FeeScdStopBean();
		String query = "";
		query = " select * from scd_fee_stop where rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"'"+
				" and decode(stop_st,'1',nvl(cancel_dt,'99999999'),stop_e_dt) >= to_char(sysdate,'YYYYMMDD')";

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			if(rs.next())
			{				
				fee_scd.setRent_mng_id	(rs.getString(1)==null?"":rs.getString(1));
				fee_scd.setRent_l_cd	(rs.getString(2)==null?"":rs.getString(2));
				fee_scd.setSeq 			(rs.getString(3)==null?"":rs.getString(3));
				fee_scd.setStop_st 		(rs.getString(4)==null?"":rs.getString(4));
				fee_scd.setStop_s_dt	(rs.getString(5)==null?"":rs.getString(5));
				fee_scd.setStop_e_dt	(rs.getString(6)==null?"":rs.getString(6));
				fee_scd.setStop_cau 	(rs.getString(7)==null?"":rs.getString(7));
				fee_scd.setStop_doc_dt 	(rs.getString(8)==null?"":rs.getString(8));
				fee_scd.setStop_doc		(rs.getString(9)==null?"":rs.getString(9));
				fee_scd.setStop_tax_dt	(rs.getString(10)==null?"":rs.getString(10));			
				fee_scd.setReg_dt 		(rs.getString(11)==null?"":rs.getString(11));
				fee_scd.setReg_id 		(rs.getString(12)==null?"":rs.getString(12));
				fee_scd.setCancel_dt	(rs.getString(13)==null?"":rs.getString(13));
				fee_scd.setCancel_id	(rs.getString(14)==null?"":rs.getString(14));
				fee_scd.setDoc_id		(rs.getString(15)==null?"":rs.getString(15));
				fee_scd.setRent_seq		(rs.getString(16)==null?"":rs.getString(16));
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getFeeScdStop]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return fee_scd;
		}
	}

	/**
	 *	세금계산서 발행 일시중지 쿼리
	 */
	public FeeScdStopBean getFeeScdStopRtn(String m_id, String l_cd, String rent_seq)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		FeeScdStopBean fee_scd = new FeeScdStopBean();
		String query = "";
		query = " select * from scd_fee_stop where rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"' and rent_seq='"+rent_seq+"'"+
				" and decode(stop_st,'1',nvl(cancel_dt,'99999999'),stop_e_dt) >= to_char(sysdate,'YYYYMMDD')";

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			if(rs.next())
			{				
				fee_scd.setRent_mng_id	(rs.getString(1)==null?"":rs.getString(1));
				fee_scd.setRent_l_cd	(rs.getString(2)==null?"":rs.getString(2));
				fee_scd.setSeq 			(rs.getString(3)==null?"":rs.getString(3));
				fee_scd.setStop_st 		(rs.getString(4)==null?"":rs.getString(4));
				fee_scd.setStop_s_dt	(rs.getString(5)==null?"":rs.getString(5));
				fee_scd.setStop_e_dt	(rs.getString(6)==null?"":rs.getString(6));
				fee_scd.setStop_cau 	(rs.getString(7)==null?"":rs.getString(7));
				fee_scd.setStop_doc_dt 	(rs.getString(8)==null?"":rs.getString(8));
				fee_scd.setStop_doc		(rs.getString(9)==null?"":rs.getString(9));
				fee_scd.setStop_tax_dt	(rs.getString(10)==null?"":rs.getString(10));			
				fee_scd.setReg_dt 		(rs.getString(11)==null?"":rs.getString(11));
				fee_scd.setReg_id 		(rs.getString(12)==null?"":rs.getString(12));
				fee_scd.setCancel_dt	(rs.getString(13)==null?"":rs.getString(13));
				fee_scd.setCancel_id	(rs.getString(14)==null?"":rs.getString(14));
				fee_scd.setDoc_id		(rs.getString(15)==null?"":rs.getString(15));
				fee_scd.setRent_seq		(rs.getString(16)==null?"":rs.getString(16));
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getFeeScdStopRtn]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return fee_scd;
		}
	}

	/**
	 *	세금계산서 발행 일시중지 쿼리
	 */
	public FeeScdStopBean getFeeScdStop(String m_id, String l_cd, String seq)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		FeeScdStopBean fee_scd = new FeeScdStopBean();
		String query = "";
		query = " select * from scd_fee_stop where rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"' and seq='"+seq+"'";

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			if(rs.next())
			{				
				fee_scd.setRent_mng_id	(rs.getString(1)==null?"":rs.getString(1));
				fee_scd.setRent_l_cd	(rs.getString(2)==null?"":rs.getString(2));
				fee_scd.setSeq 			(rs.getString(3)==null?"":rs.getString(3));
				fee_scd.setStop_st 		(rs.getString(4)==null?"":rs.getString(4));
				fee_scd.setStop_s_dt	(rs.getString(5)==null?"":rs.getString(5));
				fee_scd.setStop_e_dt	(rs.getString(6)==null?"":rs.getString(6));
				fee_scd.setStop_cau 	(rs.getString(7)==null?"":rs.getString(7));
				fee_scd.setStop_doc_dt 	(rs.getString(8)==null?"":rs.getString(8));
				fee_scd.setStop_doc		(rs.getString(9)==null?"":rs.getString(9));
				fee_scd.setStop_tax_dt	(rs.getString(10)==null?"":rs.getString(10));			
				fee_scd.setReg_dt 		(rs.getString(11)==null?"":rs.getString(11));
				fee_scd.setReg_id 		(rs.getString(12)==null?"":rs.getString(12));
				fee_scd.setCancel_dt	(rs.getString(13)==null?"":rs.getString(13));
				fee_scd.setCancel_id	(rs.getString(14)==null?"":rs.getString(14));
				fee_scd.setDoc_id		(rs.getString(15)==null?"":rs.getString(15));
				fee_scd.setRent_seq		(rs.getString(16)==null?"":rs.getString(16));
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getFeeScdStop]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return fee_scd;
		}
	}

	/**	
	 *	대여스케줄 발행 일시중지 등록
	 */
	public boolean insertFeeScdStop(FeeScdStopBean scd_stop)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
		query = " insert into scd_fee_stop (RENT_MNG_ID, RENT_L_CD, SEQ, STOP_ST, STOP_S_DT, STOP_E_DT,"+
				" STOP_CAU, STOP_DOC_DT, STOP_DOC, STOP_TAX_DT, REG_DT, REG_ID, CANCEL_DT, CANCEL_ID, doc_id, rent_seq )"+
				" values ("+
				" ?, ?, ?, ?, replace(?, '-', ''), replace(?, '-', ''), "+
				" ?, replace(?, '-', ''), ?, replace(?, '-', ''), to_char(sysdate,'YYYYMMDD'), ?, replace(?, '-', ''), ?, ?, ?)";
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  scd_stop.getRent_mng_id	());
			pstmt.setString(2,  scd_stop.getRent_l_cd	());
			pstmt.setString(3,  scd_stop.getSeq 		());
			pstmt.setString(4,  scd_stop.getStop_st 	());
			pstmt.setString(5,  scd_stop.getStop_s_dt	());
			pstmt.setString(6,  scd_stop.getStop_e_dt	());
			pstmt.setString(7,  scd_stop.getStop_cau	());
			pstmt.setString(8,  scd_stop.getStop_doc_dt	());
			pstmt.setString(9,  scd_stop.getStop_doc	());
			pstmt.setString(10, scd_stop.getStop_tax_dt	());
			pstmt.setString(11, scd_stop.getReg_id 		());
			pstmt.setString(12, scd_stop.getCancel_dt	());
			pstmt.setString(13, scd_stop.getCancel_id	());
			pstmt.setString(14, scd_stop.getDoc_id		());
			pstmt.setString(15, scd_stop.getRent_seq	());

			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[AddFeeDatabase:insertFeeScdStop]\n"+e);
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
	 *	대여스케줄 발행 일시중지 등록
	 */
	public boolean updateFeeScdStop(FeeScdStopBean scd_stop)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
		query = " update scd_fee_stop set "+
				" STOP_S_DT=replace(?, '-', ''), STOP_E_DT=replace(?, '-', ''),"+
				" STOP_CAU=?, STOP_DOC_DT=replace(?, '-', ''), STOP_DOC=?,"+
				" STOP_TAX_DT=replace(?, '-', ''), CANCEL_DT=replace(?, '-', ''), CANCEL_ID=?, doc_id=?, rent_seq=?"+
				" where rent_mng_id=? and rent_l_cd=? and seq=?";
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  scd_stop.getStop_s_dt	());
			pstmt.setString(2,  scd_stop.getStop_e_dt	());
			pstmt.setString(3,  scd_stop.getStop_cau	());
			pstmt.setString(4,  scd_stop.getStop_doc_dt	());
			pstmt.setString(5,  scd_stop.getStop_doc	());
			pstmt.setString(6,  scd_stop.getStop_tax_dt	());
			pstmt.setString(7,  scd_stop.getCancel_dt	());
			pstmt.setString(8,  scd_stop.getCancel_id	());
			pstmt.setString(9,  scd_stop.getDoc_id		());
			pstmt.setString(10, scd_stop.getRent_seq	());
			pstmt.setString(11, scd_stop.getRent_mng_id ());
			pstmt.setString(12, scd_stop.getRent_l_cd	());
			pstmt.setString(13, scd_stop.getSeq 		());

			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[AddFeeDatabase:updateFeeScdStop]\n"+e);
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
	 *	마지막 연장번호 구하기
	 */
	public int getMaxRentSt(String m_id, String l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		String query = "";
		int rent_st = 0;

		query = " select max(to_number(rent_st)) rent_st from fee where rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"'";

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			if(rs.next())
			{				
				rent_st	= rs.getInt(1);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getMaxRentSt]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return rent_st;
		}
	}

	/**
	 *	신차 첫회차 찾기
	 */
	public int getFMinFeeTm(String m_id, String l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		String query = "";
		int fee_tm = 0;

		query = " select min(to_number(fee_tm)) fee_tm from scd_fee where rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"' and rent_st='1' and tm_st2='0' ";

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			if(rs.next())
			{				
				fee_tm	= rs.getInt(1);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getFMinFeeTm]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return fee_tm;
		}
	}
	
	/**
	 *	신차 첫회차 찾기
	 */
	public int getFMinFeeTm(String m_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		String query = "";
		int fee_tm = 0;

		query = " select min(to_number(fee_tm)) fee_tm from scd_fee where rent_mng_id='"+m_id+"' and rent_st='1' and tm_st2='0' ";

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			if(rs.next())
			{				
				fee_tm	= rs.getInt(1);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getFMinFeeTm]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return fee_tm;
		}
	}	

	//자동이체 자동입금처리------------------------------------------------------------------------------------------------

	/**
	 *	//acms 테이블에서 입금미반영, 출금금액이 있는 출금의뢰일 조회하기
	 */
	public Vector getACmsDate()
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

	//	query = " select adate from acms where abit > '2' and aoutamt > 0 and aipbit='1' group by adate";
		query = " select adate from cms.file_ea21  where pross = '3' and amount - r_amount  > 0  and aipbit='1' group by adate";

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
			System.out.println("[AddFeeDatabase:getACmsDate]\n"+e);
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
	 *	//acms 테이블에서 출금의뢰일로 자동이체 결과 조회
	 */
	public Vector getACmsList(String adate, String aipbit)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select * from acms where adate=replace('"+adate+"', '-', '') and abit > '2' and aoutamt > 0 and aipbit='"+aipbit+"' order by substr(acode,1 , 2), acnt ";

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
			System.out.println("[AddFeeDatabase:getACmsList]\n"+e);
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
	 *	자동이체 미반영된 대여료 미입금 스케줄 조회
	 */
	public Vector getScdFeeCmsList(String acode, String adate)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.*, c.client_id, c.client_st, "+
				" decode(b.tax_type,'2',nvl(f.r_site,c.firm_nm),c.firm_nm) as firm_nm, "+
				" decode(b.tax_type,'2',nvl(TEXT_DECRYPT(f.enp_no, 'pw' ), TEXT_DECRYPT(c.ssn, 'pw' )),TEXT_DECRYPT(c.ssn, 'pw' )) as ssn, "+
				" decode(b.tax_type,'2',nvl(TEXT_DECRYPT(f.enp_no, 'pw' ),c.enp_no),c.enp_no) as enp_no, "+
				" decode(b.TAX_TYPE,'2',nvl(f.ven_code,c.ven_code),c.ven_code) ven_code, "+
				" d.car_no, nvl(e.rc_amt,0) cms_rc_amt"+
				" from scd_fee a, cont b, client c, car_reg d, client_site f,"+
				" (select rent_l_cd, sum(rc_amt) rc_amt from scd_fee where adate = replace(?, '-', '') and rc_dt between to_char(to_date(replace(?, '-', ''),'YYYYMMDD')-1,'YYYYMMDD') and replace(?, '-', '') group by rent_l_cd) e"+
				" where a.rc_yn='0' and nvl(a.bill_yn,'Y')='Y'"+// and a.adate is null
				" and a.rent_l_cd=? and a.fee_est_dt <= replace(?, '-', '')"+
				" and a.rent_l_cd=b.rent_l_cd and b.client_id=c.client_id and b.car_mng_id=d.car_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+) and b.client_id=f.client_id(+) and b.r_site=f.seq(+)"+
				" order by a.fee_est_dt, a.rent_st, to_number(a.fee_tm), to_number(a.tm_st1), to_number(a.tm_st2)";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		adate);
			pstmt.setString	(2,		adate);
			pstmt.setString	(3,		adate);
			pstmt.setString	(4,		acode);
			pstmt.setString	(5,		adate);

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
			System.out.println("[AddFeeDatabase:getScdFeeCmsList]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 자동전표 처리후 네오엠거래처 코드 FMS 거래처 코드에 수정하기
	 */
	public void updateClientVenCode(String client_id, String ven_code)
	{
		getConnection();
		PreparedStatement pstmt = null;
		String query = " UPDATE client SET"+
						" ven_code = ?"+
						" WHERE client_id=?";
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, ven_code);
			pstmt.setString(2, client_id);
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		
		} catch(Exception se){
            try{
				System.out.println("[AddContDatabase:updateClientVenCode]\n"+se);
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

	/**
	 * 자동전표 처리후 네오엠거래처 코드 FMS 거래처 코드에 수정하기
	 */
	public void updateACmsBit(String aipbit, String acode, String adate)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = " UPDATE acms SET"+
						" aipbit = ?, aipdate=to_char(sysdate,'YYYYMMDD')"+
						" WHERE acode=? and adate=?";
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, aipbit);
			pstmt.setString(2, acode);
			pstmt.setString(3, adate);
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		
		} catch(Exception se){
            try{
				System.out.println("[AddContDatabase:updateACmsBit]\n"+se);
				flag = false;
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
	/**
	 *	//acms 테이블에서 입금미반영, 출금금액이 있는 출금의뢰일 조회하기
	 */
	public Vector getAOutCmsDate()
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select adate from acms group by adate order by adate desc";

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
			System.out.println("[AddFeeDatabase:getAOutCmsDate]\n"+e);
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
	 *	//acms 테이블에서 입금미반영, 출금금액이 있는 출금의뢰일 조회하기
	 */
	public Vector getACmsDateList(String adate, String incom_dt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" c.rent_mng_id, c.rent_l_cd, d.firm_nm, e.car_no, a.acode, a.aamt, a.aoutamt, nvl(b.rc_amt,0) + nvl(se.car_ja_amt, 0)+ nvl(f.paid_amt, 0) rc_amt, a.aoutamt-nvl(b.rc_amt,0)-nvl(se.car_ja_amt, 0)- nvl(f.paid_amt, 0) def_amt "+
				" from acms a, (select rent_l_cd, sum(rc_amt) rc_amt from scd_fee where adate='"+adate+"' and rc_amt>0 group by rent_l_cd) b,"+
				" cont c, client d, car_reg e, (select rent_l_cd , sum(ext_pay_amt) car_ja_amt from scd_ext where ext_st = '3' and  incom_dt = replace('"+incom_dt+"', '-', '') group by rent_l_cd ) se, "+
				" (select rent_l_cd , sum(paid_amt) paid_amt from fine where  incom_dt = replace('"+incom_dt+"', '-', '') group by rent_l_cd ) f "+
				" where a.acode=b.rent_l_cd(+) and a.acode = se.rent_l_cd(+)  and a.acode = f.rent_l_cd(+)"+
				" and a.acode=c.rent_l_cd and c.client_id=d.client_id and c.car_mng_id=e.car_mng_id(+)"+
				" and a.adate='"+adate+"'"+
				" and a.aoutamt>0 "+
				" order by decode(a.aoutamt-nvl(b.rc_amt,0),0,1), substr(a.acode,1, 2), acnt ";
		//		" and a.aoutamt>0 order by decode(a.aoutamt-nvl(b.rc_amt,0),0,1),  substr(a.acode,1 , 2), d.firm_nm";

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
			System.out.println("[AddFeeDatabase:getACmsDateList]\n"+e);
			System.out.println("[AddFeeDatabase:getACmsDateList]\n"+query);
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
	 *	대여스케줄 발행 일시중지 등록
	 */
	public boolean updateScdFeeCng(String rent_mng_id, String rent_l_cd, String fee_tm, String new_rent_l_cd)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
		query = " update scd_fee set "+
				" rent_l_cd=?"+
				" where rent_mng_id=? and rent_l_cd=? and to_number(fee_tm)>=to_number(?)";
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  new_rent_l_cd);
			pstmt.setString(2,  rent_mng_id);
			pstmt.setString(3,  rent_l_cd);
			pstmt.setString(4,  fee_tm);

			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[AddFeeDatabase:updateScdFeeCng]\n"+e);
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
	 *	대여스케줄 변경/이관
	 */
	public boolean updateScdFeeCng2(String rent_mng_id, String rent_l_cd, String fee_tm, String new_rent_l_cd, String cng_cau)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
		query = " update scd_fee set "+
				" rent_l_cd=?, cng_dt=to_char(sysdate,'YYYYMMDD'), cng_cau=? "+
				" where rent_mng_id=? and rent_l_cd=? and to_number(fee_tm)>=to_number(?)";
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  new_rent_l_cd);
			pstmt.setString(2,  cng_cau);
			pstmt.setString(3,  rent_mng_id);
			pstmt.setString(4,  rent_l_cd);
			pstmt.setString(5,  fee_tm);

			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[AddFeeDatabase:updateScdFeeCng2]\n"+e);
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
	 *	//acms 테이블에서 입금미반영, 출금금액이 있는 출금의뢰일 조회하기
	 */
	public Vector getACmsDateContList(String acode)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" a.*, c.rent_mng_id, c.rent_l_cd, d.firm_nm, e.car_no, b.nm"+
				" from acms a, (select * from code where c_st='0003') b,"+
				" cont c, client d, car_reg e"+
				" where a.acode='"+acode+"'"+
				" and a.abnk=b.cms_bk(+) and a.acode=c.rent_l_cd and c.client_id=d.client_id and c.car_mng_id=e.car_mng_id(+)"+
				" order by a.adate";


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
			System.out.println("[AddFeeDatabase:getACmsDateContList]\n"+e);
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

	//분할청구----------------------------------------------------------------------------------------------------

	/**	
	 *	분할청구정보 등록
	 */
	public boolean insertFeeRtn(FeeRtnBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
		query = " insert into fee_rtn "+
				" (RENT_MNG_ID, RENT_L_CD, RENT_ST, RENT_SEQ, CLIENT_ID, R_SITE, RTN_EST_DT, RTN_AMT, RTN_MOVE_ST, UPDATE_ID, UPDATE_DT, RTN_TYPE)"+
				" values ("+
				" ?, ?, ?, ?, ?, ?, replace(?, '-', ''), ?, ?, ?, to_char(sysdate,'YYYYMMDD'), ?)";
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  bean.getRent_mng_id	());
			pstmt.setString(2,  bean.getRent_l_cd	());
			pstmt.setString(3,  bean.getRent_st		());
			pstmt.setString(4,  bean.getRent_seq	());
			pstmt.setString(5,  bean.getClient_id	());
			pstmt.setString(6,  bean.getR_site		());
			pstmt.setString(7,  bean.getRtn_est_dt	());
			pstmt.setInt   (8,  bean.getRtn_amt		());
			pstmt.setString(9,  bean.getRtn_move_st	());
			pstmt.setString(10, bean.getUpdate_id	());
			pstmt.setString(11, bean.getRtn_type	());

			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[AddFeeDatabase:insertFeeRtn]\n"+e);
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
	 *	분할청구정보 수정
	 */
	public boolean updateFeeRtn(FeeRtnBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
		
		query = " update fee_rtn set rtn_amt=? where rent_mng_id=? and rent_l_cd=? and rent_st=? and rent_seq=? ";
		
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setInt   (1,  bean.getRtn_amt		());
			pstmt.setString(2,  bean.getRent_mng_id	());
			pstmt.setString(3,  bean.getRent_l_cd	());
			pstmt.setString(4,  bean.getRent_st		());
			pstmt.setString(5,  bean.getRent_seq	());

			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[AddFeeDatabase:updateFeeRtn]\n"+e);
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
	 *	분할청구 조회
	 */
	public FeeRtnBean getFeeRtn(String m_id, String l_cd, String client_id, String r_site, int rtn_amt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		FeeRtnBean bean = new FeeRtnBean();
		String query = "";
		query = " select * from fee_rtn where rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"' and client_id='"+client_id+"'";

		if(!r_site.equals(""))	query += " and r_site = '"+r_site+"'";

		if(rtn_amt > 0)			query += " and rtn_amt = "+rtn_amt;

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			if(rs.next())
			{				
				bean.setRent_mng_id	(rs.getString(1) ==null?"":rs.getString(1));
				bean.setRent_l_cd	(rs.getString(2) ==null?"":rs.getString(2));
				bean.setRent_st		(rs.getString(3) ==null?"":rs.getString(3));
				bean.setRent_seq	(rs.getString(4) ==null?"":rs.getString(4));
				bean.setClient_id	(rs.getString(5) ==null?"":rs.getString(5));
				bean.setR_site		(rs.getString(6) ==null?"":rs.getString(6));
				bean.setRtn_est_dt	(rs.getString(7) ==null?"":rs.getString(7));
				bean.setRtn_amt		(rs.getInt(8));
				bean.setRtn_move_st	(rs.getString(9) ==null?"":rs.getString(9));
				bean.setUpdate_dt	(rs.getString(10)==null?"":rs.getString(10));			
				bean.setUpdate_id	(rs.getString(11)==null?"":rs.getString(11));
				bean.setRtn_type	(rs.getString(12)==null?"":rs.getString(12));
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getFeeRtn]\n"+e);
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
	 *	분할청구 조회
	 */
	public FeeRtnBean getFeeRtn(String m_id, String l_cd, String rent_st, String rent_seq, String client_id, String r_site, int rtn_amt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		FeeRtnBean bean = new FeeRtnBean();
		String query = "";
		query = " select * from fee_rtn where rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"' and rent_st='"+rent_st+"' and rent_seq='"+rent_seq+"' and client_id='"+client_id+"'";

		if(!r_site.equals(""))	query += " and r_site = '"+r_site+"'";

		if(rtn_amt > 0)			query += " and rtn_amt = "+rtn_amt;

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			if(rs.next())
			{				
				bean.setRent_mng_id	(rs.getString(1) ==null?"":rs.getString(1));
				bean.setRent_l_cd	(rs.getString(2) ==null?"":rs.getString(2));
				bean.setRent_st		(rs.getString(3) ==null?"":rs.getString(3));
				bean.setRent_seq	(rs.getString(4) ==null?"":rs.getString(4));
				bean.setClient_id	(rs.getString(5) ==null?"":rs.getString(5));
				bean.setR_site		(rs.getString(6) ==null?"":rs.getString(6));
				bean.setRtn_est_dt	(rs.getString(7) ==null?"":rs.getString(7));
				bean.setRtn_amt		(rs.getInt(8));
				bean.setRtn_move_st	(rs.getString(9) ==null?"":rs.getString(9));
				bean.setUpdate_dt	(rs.getString(10)==null?"":rs.getString(10));			
				bean.setUpdate_id	(rs.getString(11)==null?"":rs.getString(11));
				bean.setRtn_type	(rs.getString(12)==null?"":rs.getString(12));
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getFeeRtn]\n"+e);
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
	 *	분할청구 조회
	 */
	public FeeRtnBean getFeeRtn(String m_id, String l_cd, String rent_st, String rent_seq)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		FeeRtnBean bean = new FeeRtnBean();
		String query = "";
		query = " select * from fee_rtn where rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"' and rent_st='"+rent_st+"' and rent_seq='"+rent_seq+"'";


		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			if(rs.next())
			{				
				bean.setRent_mng_id	(rs.getString(1) ==null?"":rs.getString(1));
				bean.setRent_l_cd	(rs.getString(2) ==null?"":rs.getString(2));
				bean.setRent_st		(rs.getString(3) ==null?"":rs.getString(3));
				bean.setRent_seq	(rs.getString(4) ==null?"":rs.getString(4));
				bean.setClient_id	(rs.getString(5) ==null?"":rs.getString(5));
				bean.setR_site		(rs.getString(6) ==null?"":rs.getString(6));
				bean.setRtn_est_dt	(rs.getString(7) ==null?"":rs.getString(7));
				bean.setRtn_amt		(rs.getInt(8));
				bean.setRtn_move_st	(rs.getString(9) ==null?"":rs.getString(9));
				bean.setUpdate_dt	(rs.getString(10)==null?"":rs.getString(10));			
				bean.setUpdate_id	(rs.getString(11)==null?"":rs.getString(11));
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:(FeeRtnBean)getFeeRtn]\n"+e);
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
	 *	분할청구정보조회
	 */
	public Hashtable getFeeRtnCase(String m_id, String l_cd, String rent_st, String rent_seq)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();

		String query = "";
		query = " select a.*, "+
				" decode(a.r_site,'',b.firm_nm, c.r_site) firm_nm, "+
				" decode(a.r_site,'',b.ven_code, c.ven_code) ven_code "+
				" from fee_rtn a, client b, client_site c "+
				" where a.rent_mng_id='"+m_id+"' and a.rent_l_cd='"+l_cd+"' and a.rent_st='"+rent_st+"' and a.rent_seq='"+rent_seq+"'"+
				" and a.client_id=b.client_id and a.client_id=c.client_id(+) and a.r_site=c.seq(+)";


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
			System.out.println("[AddFeeDatabase:(Hashtable)getFeeRtn]\n"+e);
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
	 *	분할청구정보조회
	 */
	public Vector getFeeRtnList(String m_id, String l_cd, String rent_st)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();


		String query = "";

		query = " select a.*, decode(a.r_site,'',b.firm_nm, c.r_site) firm_nm "+
				" from   fee_rtn a, client b, client_site c "+
				" where  a.rent_mng_id='"+m_id+"' and a.rent_l_cd='"+l_cd+"' and a.rent_st='"+rent_st+"'"+
				"        and a.client_id=b.client_id and a.client_id=c.client_id(+) and a.r_site=c.seq(+) "+
				" order by a.rent_seq ";


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
			System.out.println("[AddFeeDatabase:getFeeRtnList]\n"+e);
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
	 *	분할청구정보조회
	 */
	public Vector im_rent_cont(String m_id, String l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();


		String query = "";

		query = " select * from fee where  rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"'  ";


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
			System.out.println("[AddFeeDatabase:im_rent_cont]\n"+e);
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
	 *	분할청구정보조회
	 */
	public Vector im_rent_cont(String m_id, String l_cd, String rent_st)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();


		String query = "";

		query = " select * from fee where  rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"'  ";

		if(!rent_st.equals("")) query += " and rent_st='"+rent_st+"' ";


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
			System.out.println("[AddFeeDatabase:im_rent_cont]\n"+e);
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
	 *	한 건에 대한 대여료 스케줄 쿼리
	 */
	public Vector getFeeScdCngNew(String l_cd, String rent_st, String rent_seq, String rc_yn)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select * from scd_fee where rent_l_cd='"+l_cd+"' and tm_st1='0'";

		if(rc_yn.equals("0"))		query += " and rc_yn='0'";
	
		if(rent_st.equals(""))		query += " and tm_st2='2'";
		if(!rent_st.equals(""))		query += " and tm_st2<>'2' and rent_st='"+rent_st+"'";


		if(rent_seq.equals(""))		query += " and nvl(rent_seq,'1')='1'";
		if(!rent_seq.equals(""))	query += " and nvl(rent_seq,'1')='"+rent_seq+"'";

		query += " order by to_number(FEE_TM), to_number(TM_ST1)";												

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			while(rs.next())
			{
				FeeScdBean fee_scd = new FeeScdBean();
				fee_scd.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_scd.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_scd.setRent_seq(rs.getString("RENT_SEQ")==null?"":rs.getString("RENT_SEQ"));
				fee_scd.setTm_st1(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				fee_scd.setTm_st2(rs.getString("TM_ST2")==null?"":rs.getString("TM_ST2"));
				fee_scd.setFee_est_dt(rs.getString("FEE_EST_DT")==null?"":rs.getString("FEE_EST_DT"));
				fee_scd.setFee_s_amt(rs.getString("FEE_S_AMT")==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee_scd.setFee_v_amt(rs.getString("FEE_V_AMT")==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee_scd.setRc_yn(rs.getString("RC_YN")==null?"":rs.getString("RC_YN"));
				fee_scd.setRc_dt(rs.getString("RC_DT")==null?"":rs.getString("RC_DT"));
				fee_scd.setRc_amt(rs.getString("RC_AMT")==null?0:Integer.parseInt(rs.getString("RC_AMT")));
				fee_scd.setDly_days(rs.getString("DLY_DAYS")==null?"":rs.getString("DLY_DAYS"));
				fee_scd.setDly_fee(rs.getString("DLY_FEE")==null?0:Integer.parseInt(rs.getString("DLY_FEE")));
				fee_scd.setPay_cng_dt(rs.getString("PAY_CNG_DT")==null?"":rs.getString("PAY_CNG_DT"));
				fee_scd.setPay_cng_cau(rs.getString("PAY_CNG_CAU")==null?"":rs.getString("PAY_CNG_CAU"));
				fee_scd.setR_fee_est_dt(rs.getString("R_FEE_EST_DT")==null?"":rs.getString("R_FEE_EST_DT"));
				fee_scd.setReq_dt(rs.getString("REQ_DT")==null?"":rs.getString("REQ_DT"));
				fee_scd.setR_req_dt(rs.getString("R_REQ_DT")==null?"":rs.getString("R_REQ_DT"));
				fee_scd.setTax_out_dt(rs.getString("TAX_OUT_DT")==null?"":rs.getString("TAX_OUT_DT"));
				fee_scd.setUse_s_dt(rs.getString("USE_S_DT")==null?"":rs.getString("USE_S_DT"));
				fee_scd.setUse_e_dt(rs.getString("USE_E_DT")==null?"":rs.getString("USE_E_DT"));
				fee_scd.setAdate(rs.getString("adate")==null?"":rs.getString("adate"));
				fee_scd.setPay_st(rs.getString("pay_st")==null?"":rs.getString("pay_st"));
				fee_scd.setIncom_dt(rs.getString("incom_dt")==null?"":rs.getString("incom_dt"));
				fee_scd.setIncom_seq(rs.getString("incom_seq")==null?0:Integer.parseInt(rs.getString("incom_seq")));

				vt.add(fee_scd);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getFeeScdCngNew]\n"+e);
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
	 *	한회차 대여료 쿼리(한 라인) : 수금스케줄에서
	 */
	public FeeScdBean getScdNew(String m_id, String l_cd, String rent_st, String rent_seq, String fee_tm)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		FeeScdBean fee_scd = new FeeScdBean();

		if(rent_st.equals("")) rent_st = "1";

		String query = "";
		query = " select RENT_MNG_ID, RENT_L_CD, FEE_TM, RENT_ST, RENT_SEQ, TM_ST1, TM_ST2,"+
				" decode(fee_est_dt, '','', substr(FEE_EST_DT, 1, 4) || '-' || substr(FEE_EST_DT, 5, 2) || '-'||substr(FEE_EST_DT, 7, 2)) FEE_EST_DT,"+
				" FEE_S_AMT, FEE_V_AMT, RC_YN,"+
				" decode(RC_DT, '', '', substr(RC_DT, 1, 4) || '-' || substr(RC_DT, 5, 2) || '-'||substr(RC_DT, 7, 2)) RC_DT,"+
				" RC_AMT, DLY_DAYS, DLY_FEE,"+
				" decode(PAY_CNG_DT, '', '', substr(PAY_CNG_DT, 1, 4) || '-' || substr(PAY_CNG_DT, 5, 2) || '-'||substr(PAY_CNG_DT, 7, 2)) PAY_CNG_DT,"+
				" PAY_CNG_CAU,"+
				" substr(R_FEE_EST_DT, 1, 4) || '-' || substr(R_FEE_EST_DT, 5, 2) || '-'||substr(R_FEE_EST_DT, 7, 2) R_FEE_EST_DT,"+
				" substr(REQ_DT, 1, 4) || '-' || substr(REQ_DT, 5, 2) || '-'||substr(REQ_DT, 7, 2) REQ_DT,"+
				" substr(R_REQ_DT, 1, 4) || '-' || substr(R_REQ_DT, 5, 2) || '-'||substr(R_REQ_DT, 7, 2) R_REQ_DT,"+
				" substr(TAX_OUT_DT, 1, 4) || '-' || substr(TAX_OUT_DT, 5, 2) || '-'||substr(TAX_OUT_DT, 7, 2) TAX_OUT_DT,"+
				" substr(USE_S_DT, 1, 4) || '-' || substr(USE_S_DT, 5, 2) || '-'||substr(USE_S_DT, 7, 2) USE_S_DT,"+
				" substr(USE_E_DT, 1, 4) || '-' || substr(USE_E_DT, 5, 2) || '-'||substr(USE_E_DT, 7, 2) USE_E_DT,"+
				" adate, pay_st, incom_dt, incom_seq, ETC, cng_dt, cng_cau "+
				" from scd_fee"+
				" where RENT_MNG_ID = '"+m_id+"' and RENT_L_CD = '"+l_cd+"'"+
				" and RENT_ST = '"+rent_st+"'"+
				" and nvl(RENT_SEQ,'1') = '"+rent_seq+"'"+
				" and FEE_TM = '"+fee_tm+"'";

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			while(rs.next())
			{
				fee_scd.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_scd.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_scd.setRent_seq(rs.getString("RENT_SEQ")==null?"":rs.getString("RENT_SEQ"));
				fee_scd.setTm_st1(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				fee_scd.setTm_st2(rs.getString("TM_ST2")==null?"":rs.getString("TM_ST2"));
				fee_scd.setFee_est_dt(rs.getString("FEE_EST_DT")==null?"":rs.getString("FEE_EST_DT"));
				fee_scd.setFee_s_amt(rs.getString("FEE_S_AMT")==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee_scd.setFee_v_amt(rs.getString("FEE_V_AMT")==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee_scd.setRc_yn(rs.getString("RC_YN")==null?"":rs.getString("RC_YN"));
				fee_scd.setRc_dt(rs.getString("RC_DT")==null?"":rs.getString("RC_DT"));
				fee_scd.setRc_amt(rs.getString("RC_AMT")==null?0:Integer.parseInt(rs.getString("RC_AMT")));
				fee_scd.setDly_days(rs.getString("DLY_DAYS")==null?"":rs.getString("DLY_DAYS"));
				fee_scd.setDly_fee(rs.getString("DLY_FEE")==null?0:Integer.parseInt(rs.getString("DLY_FEE")));
				fee_scd.setPay_cng_dt(rs.getString("PAY_CNG_DT")==null?"":rs.getString("PAY_CNG_DT"));
				fee_scd.setPay_cng_cau(rs.getString("PAY_CNG_CAU")==null?"":rs.getString("PAY_CNG_CAU"));
				fee_scd.setR_fee_est_dt(rs.getString("R_FEE_EST_DT")==null?"":rs.getString("R_FEE_EST_DT"));
				fee_scd.setReq_dt(rs.getString("REQ_DT")==null?"":rs.getString("REQ_DT"));
				fee_scd.setR_req_dt(rs.getString("R_REQ_DT")==null?"":rs.getString("R_REQ_DT"));
				fee_scd.setTax_out_dt(rs.getString("TAX_OUT_DT")==null?"":rs.getString("TAX_OUT_DT"));
				fee_scd.setUse_s_dt(rs.getString("USE_S_DT")==null?"":rs.getString("USE_S_DT"));
				fee_scd.setUse_e_dt(rs.getString("USE_E_DT")==null?"":rs.getString("USE_E_DT"));
				fee_scd.setAdate(rs.getString("ADATE")==null?"":rs.getString("ADATE"));
				fee_scd.setPay_st(rs.getString("PAY_ST")==null?"":rs.getString("PAY_ST"));
				fee_scd.setIncom_dt(rs.getString("incom_dt")==null?"":rs.getString("incom_dt"));
				fee_scd.setIncom_seq(rs.getString("incom_seq")==null?0:Integer.parseInt(rs.getString("incom_seq")));
				fee_scd.setEtc(rs.getString("ETC")==null?"":rs.getString("ETC"));
				fee_scd.setCng_cau(rs.getString("CNG_CAU")==null?"":rs.getString("CNG_CAU"));
				fee_scd.setCng_dt(rs.getString("CNG_DT")==null?"":rs.getString("CNG_DT"));

			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getScdNew]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return fee_scd;
		}				
	}

	/**
	 *	한회차 대여료 쿼리(한 라인) : 수금스케줄에서
	 */
	public FeeScdBean getScdNew(String m_id, String l_cd, String rent_st, String rent_seq, String fee_tm, String tm_st1)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		FeeScdBean fee_scd = new FeeScdBean();

		if(rent_st.equals("")) rent_st = "1";

		String query = "";
		query = " select RENT_MNG_ID, RENT_L_CD, FEE_TM, RENT_ST, RENT_SEQ, TM_ST1, TM_ST2,"+
				"        decode(fee_est_dt, '','', substr(FEE_EST_DT, 1, 4) || '-' || substr(FEE_EST_DT, 5, 2) || '-'||substr(FEE_EST_DT, 7, 2)) FEE_EST_DT,"+
				"        FEE_S_AMT, FEE_V_AMT, RC_YN,"+
				"        decode(RC_DT, '', '', substr(RC_DT, 1, 4) || '-' || substr(RC_DT, 5, 2) || '-'||substr(RC_DT, 7, 2)) RC_DT,"+
				"        RC_AMT, DLY_DAYS, DLY_FEE,"+
				"        decode(PAY_CNG_DT, '', '', substr(PAY_CNG_DT, 1, 4) || '-' || substr(PAY_CNG_DT, 5, 2) || '-'||substr(PAY_CNG_DT, 7, 2)) PAY_CNG_DT,"+
				"        PAY_CNG_CAU,"+
				"        substr(R_FEE_EST_DT, 1, 4) || '-' || substr(R_FEE_EST_DT, 5, 2) || '-'||substr(R_FEE_EST_DT, 7, 2) R_FEE_EST_DT,"+
				"        substr(REQ_DT, 1, 4) || '-' || substr(REQ_DT, 5, 2) || '-'||substr(REQ_DT, 7, 2) REQ_DT,"+
				"        substr(R_REQ_DT, 1, 4) || '-' || substr(R_REQ_DT, 5, 2) || '-'||substr(R_REQ_DT, 7, 2) R_REQ_DT,"+
				"        substr(TAX_OUT_DT, 1, 4) || '-' || substr(TAX_OUT_DT, 5, 2) || '-'||substr(TAX_OUT_DT, 7, 2) TAX_OUT_DT,"+
				"        substr(USE_S_DT, 1, 4) || '-' || substr(USE_S_DT, 5, 2) || '-'||substr(USE_S_DT, 7, 2) USE_S_DT,"+
				"        substr(USE_E_DT, 1, 4) || '-' || substr(USE_E_DT, 5, 2) || '-'||substr(USE_E_DT, 7, 2) USE_E_DT, adate, pay_st, incom_dt, incom_seq, "+
				"        ETC, bill_yn, cng_dt, cng_cau, taecha_no "+
				" from   scd_fee"+
				" where  RENT_MNG_ID = '"+m_id+"' and rent_l_cd='"+l_cd+"'"+
				"        and RENT_ST = '"+rent_st+"'"+
				"        and nvl(RENT_SEQ,'1') = '"+rent_seq+"'"+
				"        and FEE_TM = '"+fee_tm+"'"+
				"        and tm_st1 = '"+tm_st1+"'";

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			while(rs.next())
			{
				fee_scd.setRent_mng_id	(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd	(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm		(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_scd.setRent_st		(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_scd.setRent_seq		(rs.getString("RENT_SEQ")==null?"":rs.getString("RENT_SEQ"));
				fee_scd.setTm_st1		(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				fee_scd.setTm_st2		(rs.getString("TM_ST2")==null?"":rs.getString("TM_ST2"));
				fee_scd.setFee_est_dt	(rs.getString("FEE_EST_DT")==null?"":rs.getString("FEE_EST_DT"));
				fee_scd.setFee_s_amt	(rs.getString("FEE_S_AMT")==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee_scd.setFee_v_amt	(rs.getString("FEE_V_AMT")==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee_scd.setRc_yn		(rs.getString("RC_YN")==null?"":rs.getString("RC_YN"));
				fee_scd.setRc_dt		(rs.getString("RC_DT")==null?"":rs.getString("RC_DT"));
				fee_scd.setRc_amt		(rs.getString("RC_AMT")==null?0:Integer.parseInt(rs.getString("RC_AMT")));
				fee_scd.setDly_days		(rs.getString("DLY_DAYS")==null?"":rs.getString("DLY_DAYS"));
				fee_scd.setDly_fee		(rs.getString("DLY_FEE")==null?0:Integer.parseInt(rs.getString("DLY_FEE")));
				fee_scd.setPay_cng_dt	(rs.getString("PAY_CNG_DT")==null?"":rs.getString("PAY_CNG_DT"));
				fee_scd.setPay_cng_cau	(rs.getString("PAY_CNG_CAU")==null?"":rs.getString("PAY_CNG_CAU"));
				fee_scd.setR_fee_est_dt	(rs.getString("R_FEE_EST_DT")==null?"":rs.getString("R_FEE_EST_DT"));
				fee_scd.setReq_dt		(rs.getString("REQ_DT")==null?"":rs.getString("REQ_DT"));
				fee_scd.setR_req_dt		(rs.getString("R_REQ_DT")==null?"":rs.getString("R_REQ_DT"));
				fee_scd.setTax_out_dt	(rs.getString("TAX_OUT_DT")==null?"":rs.getString("TAX_OUT_DT"));
				fee_scd.setUse_s_dt		(rs.getString("USE_S_DT")==null?"":rs.getString("USE_S_DT"));
				fee_scd.setUse_e_dt		(rs.getString("USE_E_DT")==null?"":rs.getString("USE_E_DT"));
				fee_scd.setAdate		(rs.getString("ADATE")==null?"":rs.getString("ADATE"));
				fee_scd.setPay_st		(rs.getString("PAY_ST")==null?"":rs.getString("PAY_ST"));
				fee_scd.setIncom_dt		(rs.getString("incom_dt")==null?"":rs.getString("incom_dt"));
				fee_scd.setIncom_seq	(rs.getString("incom_seq")==null?0:Integer.parseInt(rs.getString("incom_seq")));
				fee_scd.setEtc			(rs.getString("ETC")==null?"":rs.getString("ETC"));
				fee_scd.setBill_yn		(rs.getString("BILL_YN")==null?"":rs.getString("BILL_YN"));
				fee_scd.setCng_dt		(rs.getString("CNG_DT")==null?"":rs.getString("CNG_DT"));
				fee_scd.setCng_cau		(rs.getString("CNG_CAU")==null?"":rs.getString("CNG_CAU"));
				fee_scd.setTaecha_no	(rs.getString("taecha_no")==null?"":rs.getString("taecha_no"));

			}
			rs.close();
			stmt.close();

		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getScdNew]\n"+e);
			System.out.println("[AddFeeDatabase:getScdNew]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return fee_scd;
		}				
	}
	
	/**
	 *	한회차 대여료 쿼리(한 라인) : 수금스케줄에서
	 */
	public FeeScdBean getScdNew(String m_id, String l_cd, String rent_st, String rent_seq, String fee_tm, String tm_st1, String tm_st2)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		FeeScdBean fee_scd = new FeeScdBean();

		if(rent_st.equals("")) rent_st = "1";

		String query = "";
		query = " select RENT_MNG_ID, RENT_L_CD, FEE_TM, RENT_ST, RENT_SEQ, TM_ST1, TM_ST2,"+
				"        decode(fee_est_dt, '','', substr(FEE_EST_DT, 1, 4) || '-' || substr(FEE_EST_DT, 5, 2) || '-'||substr(FEE_EST_DT, 7, 2)) FEE_EST_DT,"+
				"        FEE_S_AMT, FEE_V_AMT, RC_YN,"+
				"        decode(RC_DT, '', '', substr(RC_DT, 1, 4) || '-' || substr(RC_DT, 5, 2) || '-'||substr(RC_DT, 7, 2)) RC_DT,"+
				"        RC_AMT, DLY_DAYS, DLY_FEE,"+
				"        decode(PAY_CNG_DT, '', '', substr(PAY_CNG_DT, 1, 4) || '-' || substr(PAY_CNG_DT, 5, 2) || '-'||substr(PAY_CNG_DT, 7, 2)) PAY_CNG_DT,"+
				"        PAY_CNG_CAU,"+
				"        substr(R_FEE_EST_DT, 1, 4) || '-' || substr(R_FEE_EST_DT, 5, 2) || '-'||substr(R_FEE_EST_DT, 7, 2) R_FEE_EST_DT,"+
				"        substr(REQ_DT, 1, 4) || '-' || substr(REQ_DT, 5, 2) || '-'||substr(REQ_DT, 7, 2) REQ_DT,"+
				"        substr(R_REQ_DT, 1, 4) || '-' || substr(R_REQ_DT, 5, 2) || '-'||substr(R_REQ_DT, 7, 2) R_REQ_DT,"+
				"        substr(TAX_OUT_DT, 1, 4) || '-' || substr(TAX_OUT_DT, 5, 2) || '-'||substr(TAX_OUT_DT, 7, 2) TAX_OUT_DT,"+
				"        substr(USE_S_DT, 1, 4) || '-' || substr(USE_S_DT, 5, 2) || '-'||substr(USE_S_DT, 7, 2) USE_S_DT,"+
				"        substr(USE_E_DT, 1, 4) || '-' || substr(USE_E_DT, 5, 2) || '-'||substr(USE_E_DT, 7, 2) USE_E_DT, adate, pay_st, incom_dt, incom_seq, "+
				"        ETC, bill_yn, cng_dt, cng_cau "+
				" from   scd_fee"+
				" where  RENT_MNG_ID = '"+m_id+"' and rent_l_cd='"+l_cd+"'"+
				"        and RENT_ST = '"+rent_st+"'"+
				"        and nvl(RENT_SEQ,'1') = '"+rent_seq+"'"+
				"        and FEE_TM = '"+fee_tm+"'"+
				"        and tm_st1 = '"+tm_st1+"' and tm_st2 = '"+tm_st2+"' ";

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			while(rs.next())
			{
				fee_scd.setRent_mng_id	(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd	(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm		(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_scd.setRent_st		(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_scd.setRent_seq		(rs.getString("RENT_SEQ")==null?"":rs.getString("RENT_SEQ"));
				fee_scd.setTm_st1		(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				fee_scd.setTm_st2		(rs.getString("TM_ST2")==null?"":rs.getString("TM_ST2"));
				fee_scd.setFee_est_dt	(rs.getString("FEE_EST_DT")==null?"":rs.getString("FEE_EST_DT"));
				fee_scd.setFee_s_amt	(rs.getString("FEE_S_AMT")==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee_scd.setFee_v_amt	(rs.getString("FEE_V_AMT")==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee_scd.setRc_yn		(rs.getString("RC_YN")==null?"":rs.getString("RC_YN"));
				fee_scd.setRc_dt		(rs.getString("RC_DT")==null?"":rs.getString("RC_DT"));
				fee_scd.setRc_amt		(rs.getString("RC_AMT")==null?0:Integer.parseInt(rs.getString("RC_AMT")));
				fee_scd.setDly_days		(rs.getString("DLY_DAYS")==null?"":rs.getString("DLY_DAYS"));
				fee_scd.setDly_fee		(rs.getString("DLY_FEE")==null?0:Integer.parseInt(rs.getString("DLY_FEE")));
				fee_scd.setPay_cng_dt	(rs.getString("PAY_CNG_DT")==null?"":rs.getString("PAY_CNG_DT"));
				fee_scd.setPay_cng_cau	(rs.getString("PAY_CNG_CAU")==null?"":rs.getString("PAY_CNG_CAU"));
				fee_scd.setR_fee_est_dt	(rs.getString("R_FEE_EST_DT")==null?"":rs.getString("R_FEE_EST_DT"));
				fee_scd.setReq_dt		(rs.getString("REQ_DT")==null?"":rs.getString("REQ_DT"));
				fee_scd.setR_req_dt		(rs.getString("R_REQ_DT")==null?"":rs.getString("R_REQ_DT"));
				fee_scd.setTax_out_dt	(rs.getString("TAX_OUT_DT")==null?"":rs.getString("TAX_OUT_DT"));
				fee_scd.setUse_s_dt		(rs.getString("USE_S_DT")==null?"":rs.getString("USE_S_DT"));
				fee_scd.setUse_e_dt		(rs.getString("USE_E_DT")==null?"":rs.getString("USE_E_DT"));
				fee_scd.setAdate		(rs.getString("ADATE")==null?"":rs.getString("ADATE"));
				fee_scd.setPay_st		(rs.getString("PAY_ST")==null?"":rs.getString("PAY_ST"));
				fee_scd.setIncom_dt		(rs.getString("incom_dt")==null?"":rs.getString("incom_dt"));
				fee_scd.setIncom_seq	(rs.getString("incom_seq")==null?0:Integer.parseInt(rs.getString("incom_seq")));
				fee_scd.setEtc			(rs.getString("ETC")==null?"":rs.getString("ETC"));
				fee_scd.setBill_yn		(rs.getString("BILL_YN")==null?"":rs.getString("BILL_YN"));
				fee_scd.setCng_dt		(rs.getString("CNG_DT")==null?"":rs.getString("CNG_DT"));
				fee_scd.setCng_cau		(rs.getString("CNG_CAU")==null?"":rs.getString("CNG_CAU"));

			}
			rs.close();
			stmt.close();

		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getScdNew]\n"+e);
			System.out.println("[AddFeeDatabase:getScdNew]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return fee_scd;
		}				
	}	

	/**
	 *	입금변경을 위한 쿼리(한회에 속한 대여료 및 잔액 모두 포함 or 해당회차 이후의 모든 대여료 및 잔액 리턴)
	 *  gubun - ONE : 해당 회차에 속한 대여료 및 잔액만 리턴, ALL : 해당회차를 포함해 그 이후의 모든 대여료 및 잔액을 리턴
	 */
	public Vector getScdGroupCngNew(String m_id, String l_cd, String rent_seq, String fee_tm, String gubun)
	{
		getConnection();
		Vector vt = new Vector();
		Statement stmt = null;
		ResultSet rs = null;
		String query = "";
		query = " select"+
				" RENT_MNG_ID, RENT_L_CD, FEE_TM, RENT_ST, RENT_SEQ, TM_ST1, TM_ST2,"+
				" substr(FEE_EST_DT, 1, 4) || '-' || substr(FEE_EST_DT, 5, 2) || '-'||substr(FEE_EST_DT, 7, 2) FEE_EST_DT,"+
				" FEE_S_AMT, FEE_V_AMT, RC_YN,"+
				" substr(RC_DT, 1, 4) || '-' || substr(RC_DT, 5, 2) || '-'||substr(RC_DT, 7, 2) RC_DT,"+
				" RC_AMT, DLY_DAYS, DLY_FEE,"+
				" substr(PAY_CNG_DT, 1, 4) || '-' || substr(PAY_CNG_DT, 5, 2) || '-'||substr(PAY_CNG_DT, 7, 2) PAY_CNG_DT,"+
				" PAY_CNG_CAU,"+
				" substr(R_FEE_EST_DT, 1, 4) || '-' || substr(R_FEE_EST_DT, 5, 2) || '-'||substr(R_FEE_EST_DT, 7, 2) R_FEE_EST_DT,"+
				" substr(REQ_DT, 1, 4) || '-' || substr(REQ_DT, 5, 2) || '-'||substr(REQ_DT, 7, 2) REQ_DT,"+
				" substr(R_REQ_DT, 1, 4) || '-' || substr(R_REQ_DT, 5, 2) || '-'||substr(R_REQ_DT, 7, 2) R_REQ_DT,"+
				" substr(TAX_OUT_DT, 1, 4) || '-' || substr(TAX_OUT_DT, 5, 2) || '-'||substr(TAX_OUT_DT, 7, 2) TAX_OUT_DT,"+
				" substr(USE_S_DT, 1, 4) || '-' || substr(USE_S_DT, 5, 2) || '-'||substr(USE_S_DT, 7, 2) USE_S_DT,"+
				" substr(USE_E_DT, 1, 4) || '-' || substr(USE_E_DT, 5, 2) || '-'||substr(USE_E_DT, 7, 2) USE_E_DT,"+
				" ADATE, PAY_ST, EXT_DT, incom_dt, incom_seq "+
				" from scd_fee"+
				" where RENT_MNG_ID = '"+m_id+"' and RENT_L_CD = '"+l_cd+"' and tm_st1='0'"+
				" and nvl(RENT_SEQ,'1') = '"+rent_seq+"'"+
				" ";
//				" and rc_yn = '0'";

		if(gubun.equals("ALL"))			query += " and to_number(FEE_TM) >= '"+fee_tm+"'";
		else if(gubun.equals("ONE"))	query += " and to_number(FEE_TM) = '"+fee_tm+"'";
		else							query += " and to_number(FEE_TM) between '"+fee_tm+"' and '"+gubun+"'";
				
		query += " order by to_number(fee_tm)";



		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
   			int i = 0;
			while(rs.next())
			{

				FeeScdBean fee_scd = new FeeScdBean();				
				fee_scd.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_scd.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_scd.setRent_seq(rs.getString("RENT_SEQ")==null?"":rs.getString("RENT_SEQ"));
				fee_scd.setTm_st1(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				fee_scd.setTm_st2(rs.getString("TM_ST2")==null?"":rs.getString("TM_ST2"));
				fee_scd.setFee_est_dt(rs.getString("FEE_EST_DT")==null?"":rs.getString("FEE_EST_DT"));
				fee_scd.setFee_s_amt(rs.getString("FEE_S_AMT")==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee_scd.setFee_v_amt(rs.getString("FEE_V_AMT")==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee_scd.setRc_yn(rs.getString("RC_YN")==null?"":rs.getString("RC_YN"));
				fee_scd.setRc_dt(rs.getString("RC_DT")==null?"":rs.getString("RC_DT"));
				fee_scd.setRc_amt(rs.getString("RC_AMT")==null?0:Integer.parseInt(rs.getString("RC_AMT")));
				fee_scd.setDly_days(rs.getString("DLY_DAYS")==null?"":rs.getString("DLY_DAYS"));
				fee_scd.setDly_fee(rs.getString("DLY_FEE")==null?0:Integer.parseInt(rs.getString("DLY_FEE")));
				fee_scd.setPay_cng_dt(rs.getString("PAY_CNG_DT")==null?"":rs.getString("PAY_CNG_DT"));
				fee_scd.setPay_cng_cau(rs.getString("PAY_CNG_CAU")==null?"":rs.getString("PAY_CNG_CAU"));
				fee_scd.setR_fee_est_dt(rs.getString("R_FEE_EST_DT")==null?"":rs.getString("R_FEE_EST_DT"));
				fee_scd.setExt_dt(rs.getString("EXT_DT")==null?"":rs.getString("EXT_DT"));
				fee_scd.setReq_dt(rs.getString("REQ_DT")==null?"":rs.getString("REQ_DT"));
				fee_scd.setR_req_dt(rs.getString("R_REQ_DT")==null?"":rs.getString("R_REQ_DT"));
				fee_scd.setTax_out_dt(rs.getString("TAX_OUT_DT")==null?"":rs.getString("TAX_OUT_DT"));
				fee_scd.setUse_s_dt(rs.getString("USE_S_DT")==null?"":rs.getString("USE_S_DT"));
				fee_scd.setUse_e_dt(rs.getString("USE_E_DT")==null?"":rs.getString("USE_E_DT"));
				fee_scd.setAdate(rs.getString("ADATE")==null?"":rs.getString("ADATE"));
				fee_scd.setPay_st(rs.getString("PAY_ST")==null?"":rs.getString("PAY_ST"));
				fee_scd.setIncom_dt(rs.getString("INCOM_DT")==null?"":rs.getString("INCOM_DT"));
				fee_scd.setIncom_seq(rs.getString("INCOM_SEQ")==null?0:Integer.parseInt(rs.getString("INCOM_SEQ")));

				vt.add(i, fee_scd);
				i++;
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getScdGroupCngNew]\n"+e);
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
	 *	입금변경을 위한 쿼리(한회에 속한 대여료 및 잔액 모두 포함 or 해당회차 이후의 모든 대여료 및 잔액 리턴)
	 *  gubun - ONE : 해당 회차에 속한 대여료 및 잔액만 리턴, ALL : 해당회차를 포함해 그 이후의 모든 대여료 및 잔액을 리턴
	 */
	public Vector getScdGroupCngNew(String m_id, String l_cd, String rent_st, String rent_seq, String fee_tm, String gubun)
	{
		getConnection();
		Vector vt = new Vector();
		Statement stmt = null;
		ResultSet rs = null;
		String query = "";
		query = " select"+
				" RENT_MNG_ID, RENT_L_CD, FEE_TM, RENT_ST, RENT_SEQ, TM_ST1, TM_ST2,"+
				" substr(FEE_EST_DT, 1, 4) || '-' || substr(FEE_EST_DT, 5, 2) || '-'||substr(FEE_EST_DT, 7, 2) FEE_EST_DT,"+
				" FEE_S_AMT, FEE_V_AMT, RC_YN,"+
				" substr(RC_DT, 1, 4) || '-' || substr(RC_DT, 5, 2) || '-'||substr(RC_DT, 7, 2) RC_DT,"+
				" RC_AMT, DLY_DAYS, DLY_FEE,"+
				" substr(PAY_CNG_DT, 1, 4) || '-' || substr(PAY_CNG_DT, 5, 2) || '-'||substr(PAY_CNG_DT, 7, 2) PAY_CNG_DT,"+
				" PAY_CNG_CAU,"+
				" substr(R_FEE_EST_DT, 1, 4) || '-' || substr(R_FEE_EST_DT, 5, 2) || '-'||substr(R_FEE_EST_DT, 7, 2) R_FEE_EST_DT,"+
				" substr(REQ_DT, 1, 4) || '-' || substr(REQ_DT, 5, 2) || '-'||substr(REQ_DT, 7, 2) REQ_DT,"+
				" substr(R_REQ_DT, 1, 4) || '-' || substr(R_REQ_DT, 5, 2) || '-'||substr(R_REQ_DT, 7, 2) R_REQ_DT,"+
				" substr(TAX_OUT_DT, 1, 4) || '-' || substr(TAX_OUT_DT, 5, 2) || '-'||substr(TAX_OUT_DT, 7, 2) TAX_OUT_DT,"+
				" substr(USE_S_DT, 1, 4) || '-' || substr(USE_S_DT, 5, 2) || '-'||substr(USE_S_DT, 7, 2) USE_S_DT,"+
				" substr(USE_E_DT, 1, 4) || '-' || substr(USE_E_DT, 5, 2) || '-'||substr(USE_E_DT, 7, 2) USE_E_DT,"+
				" ADATE, PAY_ST, EXT_DT, incom_dt, incom_seq "+
				" from scd_fee"+
				" where RENT_MNG_ID = '"+m_id+"' and RENT_L_CD = '"+l_cd+"' and tm_st1='0'"+
				" and RENT_ST = '"+rent_st+"'"+
				" and RENT_SEQ = '"+rent_seq+"'"+
				" ";
//				" and rc_yn = '0'";

		if(gubun.equals("ALL"))			query += " and to_number(FEE_TM) >= '"+fee_tm+"'";
		else if(gubun.equals("ONE"))	query += " and to_number(FEE_TM) = '"+fee_tm+"'";
		else							query += " and to_number(FEE_TM) between '"+fee_tm+"' and '"+gubun+"'";
				
		query += " order by to_number(fee_tm)";



		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
   			int i = 0;
			while(rs.next())
			{

				FeeScdBean fee_scd = new FeeScdBean();				
				fee_scd.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_scd.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_scd.setRent_seq(rs.getString("RENT_SEQ")==null?"":rs.getString("RENT_SEQ"));
				fee_scd.setTm_st1(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				fee_scd.setTm_st2(rs.getString("TM_ST2")==null?"":rs.getString("TM_ST2"));
				fee_scd.setFee_est_dt(rs.getString("FEE_EST_DT")==null?"":rs.getString("FEE_EST_DT"));
				fee_scd.setFee_s_amt(rs.getString("FEE_S_AMT")==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee_scd.setFee_v_amt(rs.getString("FEE_V_AMT")==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee_scd.setRc_yn(rs.getString("RC_YN")==null?"":rs.getString("RC_YN"));
				fee_scd.setRc_dt(rs.getString("RC_DT")==null?"":rs.getString("RC_DT"));
				fee_scd.setRc_amt(rs.getString("RC_AMT")==null?0:Integer.parseInt(rs.getString("RC_AMT")));
				fee_scd.setDly_days(rs.getString("DLY_DAYS")==null?"":rs.getString("DLY_DAYS"));
				fee_scd.setDly_fee(rs.getString("DLY_FEE")==null?0:Integer.parseInt(rs.getString("DLY_FEE")));
				fee_scd.setPay_cng_dt(rs.getString("PAY_CNG_DT")==null?"":rs.getString("PAY_CNG_DT"));
				fee_scd.setPay_cng_cau(rs.getString("PAY_CNG_CAU")==null?"":rs.getString("PAY_CNG_CAU"));
				fee_scd.setR_fee_est_dt(rs.getString("R_FEE_EST_DT")==null?"":rs.getString("R_FEE_EST_DT"));
				fee_scd.setExt_dt(rs.getString("EXT_DT")==null?"":rs.getString("EXT_DT"));
				fee_scd.setReq_dt(rs.getString("REQ_DT")==null?"":rs.getString("REQ_DT"));
				fee_scd.setR_req_dt(rs.getString("R_REQ_DT")==null?"":rs.getString("R_REQ_DT"));
				fee_scd.setTax_out_dt(rs.getString("TAX_OUT_DT")==null?"":rs.getString("TAX_OUT_DT"));
				fee_scd.setUse_s_dt(rs.getString("USE_S_DT")==null?"":rs.getString("USE_S_DT"));
				fee_scd.setUse_e_dt(rs.getString("USE_E_DT")==null?"":rs.getString("USE_E_DT"));
				fee_scd.setAdate(rs.getString("ADATE")==null?"":rs.getString("ADATE"));
				fee_scd.setPay_st(rs.getString("PAY_ST")==null?"":rs.getString("PAY_ST"));
				fee_scd.setIncom_dt(rs.getString("INCOM_DT")==null?"":rs.getString("INCOM_DT"));
				fee_scd.setIncom_seq(rs.getString("INCOM_SEQ")==null?0:Integer.parseInt(rs.getString("INCOM_SEQ")));

				vt.add(i, fee_scd);
				i++;
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getScdGroupCngNew]\n"+e);
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
	 *	한 건에 대한 대여료 스케줄 쿼리
	 */
	public Vector getFeeScdNew(String m_id, String l_cd, String b_dt, String mode, String bill_yn)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";

		if(b_dt.equals("")){
			b_dt = "to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')";
		}else{
			b_dt = "to_date(replace('"+b_dt+"','-',''),'YYYYMMDD')";
		}

		if(mode.equals("ALL")){
			sub_query = " a.rent_mng_id='"+m_id+"'";
		}else{
			sub_query = " a.rent_mng_id='"+m_id+"' and a.rent_l_cd='"+l_cd+"'";
		}
			
		if(!bill_yn.equals("")){
			sub_query += " and nvl(a.bill_yn,'Y')='"+bill_yn+"'";
		}

		query = " select"+
				" rent_mng_id, rent_l_cd, fee_tm, rent_st, rent_seq, tm_st1, tm_st2,"+
				" use_s_dt, use_e_dt, fee_est_dt, r_fee_est_dt, fee_s_amt, fee_v_amt, (fee_s_amt+fee_v_amt) fee_amt,"+
				" rc_yn, rc_dt, rc_amt, decode(sign(dly_day),-1,0,dly_day) dly_days, decode(sign(dly_day),-1,0,dly_amt) dly_fee,"+
				" bill_yn, tax_dt, tax_out_dt, req_dt, adate, pay_st"+
				" from"+
				"     ("+
				"         select"+
				"         a.*, b.tax_dt,"+
				"         TRUNC(NVL(TO_DATE(a.rc_dt, 'YYYYMMDD'), "+b_dt+") - TO_DATE(a.r_fee_est_dt, 'YYYYMMDD')) as dly_day,"+
				"         (TRUNC(((decode(a.rc_amt,0,a.fee_s_amt+a.fee_v_amt,a.rc_amt))*decode(sign(decode(c.rent_suc_dt,'',d.rent_dt,c.rent_suc_dt)-'20220101'),-1,0.24,0.20)*TRUNC(TO_DATE(a.r_fee_est_dt, 'YYYYMMDD')- NVL(TO_DATE(a.rc_dt, 'YYYYMMDD'), "+b_dt+")))/365) * -1) as dly_amt"+
				"         from scd_fee a,"+
							  //20110309 거래명세서&세금계산서
					 "        ( select a.rent_l_cd, a.rent_st, a.rent_seq, a.tm as fee_tm, sum(item_supply) fee_s_amt, \n"+
					 "                 max(b.item_id) item_id, max(b.item_dt) item_dt, max(b.tax_est_dt) tax_est_dt, \n"+
					 "                 decode(sum(c.tax_supply),0,'',max(c.tax_no)) tax_no, "+
					 "		           decode(sum(c.tax_supply),0,'',max(c.tax_dt)) tax_dt, "+
					 "	               decode(sum(c.tax_supply),0,'',max(c.reg_dt)) reg_dt, "+
					 "	               decode(sum(c.tax_supply),0,'',max(c.print_dt)) print_dt \n"+
					 "          from   tax_item_list a, tax_item b, tax c \n"+
					 "          where  a.rent_l_cd='"+l_cd+"' and a.gubun='1' \n"+
					 "                 and a.item_id=b.item_id and a.item_id=c.item_id(+) and nvl(c.tax_st,'O')<>'C' \n"+
					 "          group by a.rent_l_cd, a.rent_st, a.rent_seq, a.tm \n"+
					 "          having sum(item_supply) > 0 "+			
					 "	      ) b, \n"+
				"         fee d, cont_etc c"+
				"         where "+sub_query+
				"         and a.rent_l_cd=b.rent_l_cd(+) and a.fee_tm=b.fee_tm(+) and a.rent_st=b.rent_st(+) and a.rent_seq=b.rent_seq(+)"+
				"         and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd and a.rent_st=d.rent_st and a.rent_l_cd=c.rent_l_cd "+
				"     )"+
				" order by to_number(fee_tm), to_number(tm_st1)"+
				" ";

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    
	    	

			while(rs.next())
			{
				FeeScdBean fee_scd = new FeeScdBean();
				fee_scd.setRent_mng_id	(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd	(rs.getString("RENT_L_CD")	==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm		(rs.getString("FEE_TM")		==null?"":rs.getString("FEE_TM"));
				fee_scd.setRent_st		(rs.getString("RENT_ST")	==null?"":rs.getString("RENT_ST"));
				fee_scd.setTm_st1		(rs.getString("TM_ST1")		==null?"":rs.getString("TM_ST1"));
				fee_scd.setTm_st2		(rs.getString("TM_ST2")		==null?"":rs.getString("TM_ST2"));
				fee_scd.setFee_est_dt	(rs.getString("FEE_EST_DT")	==null?"":rs.getString("FEE_EST_DT"));
				fee_scd.setFee_s_amt	(rs.getString("FEE_S_AMT")	==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee_scd.setFee_v_amt	(rs.getString("FEE_V_AMT")	==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee_scd.setRc_yn		(rs.getString("RC_YN")		==null?"":rs.getString("RC_YN"));
				fee_scd.setRc_dt		(rs.getString("RC_DT")		==null?"":rs.getString("RC_DT"));
				fee_scd.setRc_amt		(rs.getString("RC_AMT")		==null?0:Integer.parseInt(rs.getString("RC_AMT")));
				fee_scd.setDly_days		(rs.getString("DLY_DAYS")	==null?"":rs.getString("DLY_DAYS"));
				fee_scd.setDly_fee		(rs.getString("DLY_FEE")	==null?0:Integer.parseInt(rs.getString("DLY_FEE")));
				fee_scd.setR_fee_est_dt	(rs.getString("R_FEE_EST_DT")==null?"":rs.getString("R_FEE_EST_DT"));
				fee_scd.setExt_dt		(rs.getString("TAX_DT")		==null?"":rs.getString("TAX_DT"));
				fee_scd.setBill_yn		(rs.getString("bill_yn")	==null?"":rs.getString("bill_yn"));
				fee_scd.setUse_s_dt		(rs.getString("USE_S_DT")	==null?"":rs.getString("USE_S_DT"));
				fee_scd.setUse_e_dt		(rs.getString("USE_E_DT")	==null?"":rs.getString("USE_E_DT"));
				vt.add(fee_scd);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getFeeScdNew]\n"+e);
			System.out.println("[AddFeeDatabase:getFeeScdNew]\n"+query);
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
	 *	한 건에 대한 대여료 스케줄 쿼리
	 */
	public Vector getFeeScdNew(String m_id, String l_cd, String rent_st, String b_dt, String mode, String bill_yn)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";

		if(b_dt.equals("")){
			b_dt = "to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')";
		}else{
			b_dt = "to_date(replace('"+b_dt+"','-',''),'YYYYMMDD')";
		}

		if(mode.equals("ALL")){
			sub_query = " a.rent_mng_id='"+m_id+"'";
		}else{
			sub_query = " a.rent_mng_id='"+m_id+"' and a.rent_l_cd='"+l_cd+"'";
		}

		//출고지연대차
		if(rent_st.equals("0")){
			sub_query += " and a.tm_st2='2'";
		}else{
			if(!rent_st.equals("")){
				sub_query += " and a.rent_st='"+rent_st+"' and a.tm_st2<>'2'";
			}
		}

			
		if(!bill_yn.equals("")){
			sub_query += " and nvl(a.bill_yn,'Y')='"+bill_yn+"'";
		}

		query = " select"+
				" rent_mng_id, rent_l_cd, fee_tm, rent_st, rent_seq, tm_st1, tm_st2,"+
				" use_s_dt, use_e_dt, fee_est_dt, r_fee_est_dt, fee_s_amt, fee_v_amt, (fee_s_amt+fee_v_amt) fee_amt,"+
				" rc_yn, rc_dt, rc_amt, decode(sign(dly_day),-1,0,dly_day) dly_days, decode(sign(dly_day),-1,0,dly_amt) dly_fee,"+
				" bill_yn, tax_dt, tax_out_dt, req_dt, adate, pay_st"+
				" from"+
				"     ("+
				"         select"+
				"         a.*, b.tax_dt,"+
				"         TRUNC(NVL(TO_DATE(a.rc_dt, 'YYYYMMDD'), "+b_dt+") - TO_DATE(a.r_fee_est_dt, 'YYYYMMDD')) as dly_day,"+
				"         (TRUNC(((decode(a.rc_amt,0,a.fee_s_amt+a.fee_v_amt,a.rc_amt))*decode(sign(decode(c.rent_suc_dt,'',d.rent_dt,c.rent_suc_dt)-'20220101'),-1,0.24,0.20)*TRUNC(TO_DATE(a.r_fee_est_dt, 'YYYYMMDD')- NVL(TO_DATE(a.rc_dt, 'YYYYMMDD'), "+b_dt+")))/365) * -1) as dly_amt"+
				"         from scd_fee a,"+
							  //20110309 거래명세서&세금계산서
					 "        ( select a.rent_l_cd, a.rent_st, a.rent_seq, a.tm as fee_tm, sum(item_supply) fee_s_amt, \n"+
					 "                 max(b.item_id) item_id, max(b.item_dt) item_dt, max(b.tax_est_dt) tax_est_dt, \n"+
					 "                 decode(sum(c.tax_supply),0,'',max(c.tax_no)) tax_no, "+
					 "		           decode(sum(c.tax_supply),0,'',max(c.tax_dt)) tax_dt, "+
					 "	               decode(sum(c.tax_supply),0,'',max(c.reg_dt)) reg_dt, "+
					 "	               decode(sum(c.tax_supply),0,'',max(c.print_dt)) print_dt \n"+
					 "          from   tax_item_list a, tax_item b, tax c \n"+
					 "          where  a.rent_l_cd='"+l_cd+"' and a.gubun='1' \n"+
					 "                 and a.item_id=b.item_id and a.item_id=c.item_id(+) and nvl(c.tax_st,'O')<>'C' \n"+
					 "          group by a.rent_l_cd, a.rent_st, a.rent_seq, a.tm \n"+
					 "          having sum(item_supply) > 0 "+			
					 "	      ) b, \n"+

				"         fee d, cont_etc c"+
				"         where "+sub_query+
				"         and a.rent_l_cd=b.rent_l_cd(+) and a.fee_tm=b.fee_tm(+) and a.rent_st=b.rent_st(+) and a.rent_seq=b.rent_seq(+)"+
				"         and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd and a.rent_st=d.rent_st and a.rent_l_cd=c.rent_l_cd "+
				"     )"+
				" order by to_number(fee_tm), to_number(tm_st1)"+
				" ";

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    
	    	

			while(rs.next())
			{
				FeeScdBean fee_scd = new FeeScdBean();
				fee_scd.setRent_mng_id	(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd	(rs.getString("RENT_L_CD")	==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm		(rs.getString("FEE_TM")		==null?"":rs.getString("FEE_TM"));
				fee_scd.setRent_st		(rs.getString("RENT_ST")	==null?"":rs.getString("RENT_ST"));
				fee_scd.setTm_st1		(rs.getString("TM_ST1")		==null?"":rs.getString("TM_ST1"));
				fee_scd.setTm_st2		(rs.getString("TM_ST2")		==null?"":rs.getString("TM_ST2"));
				fee_scd.setFee_est_dt	(rs.getString("FEE_EST_DT")	==null?"":rs.getString("FEE_EST_DT"));
				fee_scd.setFee_s_amt	(rs.getString("FEE_S_AMT")	==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee_scd.setFee_v_amt	(rs.getString("FEE_V_AMT")	==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee_scd.setRc_yn		(rs.getString("RC_YN")		==null?"":rs.getString("RC_YN"));
				fee_scd.setRc_dt		(rs.getString("RC_DT")		==null?"":rs.getString("RC_DT"));
				fee_scd.setRc_amt		(rs.getString("RC_AMT")		==null?0:Integer.parseInt(rs.getString("RC_AMT")));
				fee_scd.setDly_days		(rs.getString("DLY_DAYS")	==null?"":rs.getString("DLY_DAYS"));
				fee_scd.setDly_fee		(rs.getString("DLY_FEE")	==null?0:Integer.parseInt(rs.getString("DLY_FEE")));
				fee_scd.setR_fee_est_dt	(rs.getString("R_FEE_EST_DT")==null?"":rs.getString("R_FEE_EST_DT"));
				fee_scd.setExt_dt		(rs.getString("TAX_DT")		==null?"":rs.getString("TAX_DT"));
				fee_scd.setBill_yn		(rs.getString("bill_yn")	==null?"":rs.getString("bill_yn"));
				fee_scd.setUse_s_dt		(rs.getString("USE_S_DT")	==null?"":rs.getString("USE_S_DT"));
				fee_scd.setUse_e_dt		(rs.getString("USE_E_DT")	==null?"":rs.getString("USE_E_DT"));
				vt.add(fee_scd);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getFeeScdNew]\n"+e);
			System.out.println("[AddFeeDatabase:getFeeScdNew]\n"+query);
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
	 *	대여료스케줄 통계(건별)
	 */
	public Hashtable getFeeScdStatNew(String m_id, String l_cd, String b_dt, String mode, String bill_yn)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();

		String sub_query = "";
		String sub_query2 = "";

		if(b_dt.equals("")){
			b_dt = "to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')";
		}else{
			b_dt = "to_date(replace('"+b_dt+"','-',''),'YYYYMMDD')";
		}

		if(mode.equals("ALL")){
			sub_query = " rent_mng_id='"+m_id+"'";
		}else{
			sub_query = " rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"'";
		}

		sub_query2 = sub_query;
			
		if(!bill_yn.equals("")){
			sub_query += " and nvl(bill_yn,'Y')='"+bill_yn+"'";
		}

		String query = "";
		query = " select"+
				" max(NC) NC, max(NS) NS, max(NV) NV,"+//미수금
				" max(RC) RC, max(RS) RS, max(RV) RV,"+//수금
				" max(MC) MC, max(MS) MS, max(MV) MV,"+//미도래분
				" sum(DC) DC, sum(DT) DT, "+//연체
				" max(DT2) DT2"+//연체-수금
				" from"+
				" ( \n"+
					//미수금
					" select count(0) NC, sum(fee_s_amt) NS, sum(fee_v_amt) NV, 0 RC, 0 RS, 0 RV, 0 MC, 0 MS, 0 MV, 0 DC, 0 DT, 0 DT2"+
					" from scd_fee"+
					" where rc_yn = '0' and r_fee_est_dt <= to_char(sysdate,'YYYYMMDD') and "+sub_query+
					"  \n union \n"+
					//수금
					" select 0 NC, 0 NS, 0 NV, count(0) RC, sum(trunc(rc_amt/1.1)) RS, sum(rc_amt-trunc(rc_amt/1.1)) RV, 0 MC, 0 MS, 0 MV, 0 DC, 0 DT, 0 DT2"+
					" from scd_fee"+
					" where rc_yn = '1' and "+sub_query+
					"  \n union \n"+
					//미도래분
					" select 0 NC, 0 NS, 0 NV, 0 RC, 0 RS, 0 RV, count(0) MC, sum(fee_s_amt) MS, sum(fee_v_amt) MV, 0 DC, 0 DT, 0 DT2"+
					" from scd_fee"+
					" where rc_yn = '0' and r_fee_est_dt > to_char(sysdate,'YYYYMMDD') and "+sub_query+
					"  \n union \n"+
					//연체료 0.18
					" select 0 NC, 0 NS, 0 NV, 0 RC, 0 RS, 0 RV, 0 MC, 0 MS, 0 MV, count(0) DC, sum(decode(bill_yn,'Y',(TRUNC(((decode(rc_amt,0,fee_s_amt+fee_v_amt,rc_amt))*0.24*TRUNC(TO_DATE(r_fee_est_dt, 'YYYYMMDD')- NVL(TO_DATE(rc_dt, 'YYYYMMDD'), "+b_dt+")))/365) * -1),dly_fee)) DT, 0 DT2"+
					" from scd_fee"+
					" where "+sub_query+" and"+
					" nvl(to_number(dly_days), 0) > 0 "+
					" and (rent_l_cd, rent_mng_id, rent_st) in (select a.rent_l_cd, a.rent_mng_id, a.rent_st from fee a, cont b, cont_etc c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and decode(c.rent_suc_dt,'',decode(a.rent_st,'1',b.rent_dt,a.rent_dt),c.rent_suc_dt) < '20220101')"+
					"  \n union \n"+
					//연체료 0.24
					" select 0 NC, 0 NS, 0 NV, 0 RC, 0 RS, 0 RV, 0 MC, 0 MS, 0 MV, count(0) DC, sum(decode(bill_yn,'Y',(TRUNC(((decode(rc_amt,0,fee_s_amt+fee_v_amt,rc_amt))*0.20*TRUNC(TO_DATE(r_fee_est_dt, 'YYYYMMDD')- NVL(TO_DATE(rc_dt, 'YYYYMMDD'), "+b_dt+")))/365) * -1),dly_fee)) DT, 0 DT2"+
					" from scd_fee"+
					" where "+sub_query+" and"+
					" nvl(to_number(dly_days), 0) > 0 "+
					" and (rent_l_cd, rent_mng_id, rent_st) in (select a.rent_l_cd, a.rent_mng_id, a.rent_st from fee a, cont b, cont_etc c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and decode(c.rent_suc_dt,'',decode(a.rent_st,'1',b.rent_dt,a.rent_dt),c.rent_suc_dt) >= '20220101')"+
					"  \n union \n"+
					//연체료-수금
					" select 0 NC, 0 NS, 0 NV, 0 RC, 0 RS, 0 RV, 0 MC, 0 MS, 0 MV, 0 DC, 0 DT, sum(pay_amt) DT2"+
					" from scd_dly"+
					" where "+sub_query2+
				" \n )";
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
			System.out.println("[AddFeeDatabase:getFeeScdStatNew]\n"+e);
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
	 *	연장회차 삭제 : 한회차 대여료 delete /con_fee/ext_scd_i_a.jsp (20071123 수정)
	 */ 
	public boolean dropFeeScdNew(String m_id, String l_cd, String r_st, String rent_seq, String fee_tm, String tm_st1)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;

		String query1 = " delete from scd_fee"+
						" where RENT_MNG_ID=? and RENT_L_CD=? and RENT_ST=? and FEE_TM=? and TM_ST1=? and RENT_SEQ=?";

		String query2 = " update scd_fee set fee_tm=fee_tm-1"+
						" where RENT_MNG_ID=? and RENT_L_CD=? and to_number(FEE_TM)>? and rent_seq=? "+
						" and   (select count(0) from scd_fee where rent_mng_id=? and rent_l_cd=? and fee_tm=?) = 0 ";
		try {
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query1);
			pstmt1.setString(1 , m_id		);
			pstmt1.setString(2 , l_cd		);
			pstmt1.setString(3 , r_st		);
			pstmt1.setString(4 , fee_tm		);
			pstmt1.setString(5 , tm_st1		);
			pstmt1.setString(6 , rent_seq	);
			pstmt1.executeUpdate();
			pstmt1.close();
		    
			pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString(1 , m_id);
			pstmt2.setString(2 , l_cd);
			pstmt2.setString(3 , fee_tm);
			pstmt2.setString(4 , rent_seq);
			pstmt2.setString(5 , m_id);
			pstmt2.setString(6 , l_cd);
			pstmt2.setString(7 , fee_tm);
			pstmt2.executeUpdate();
			pstmt2.close();


			conn.commit();

		} catch (Exception e) {
			System.out.println("[AddFeeDatabase:dropFeeScdNew]\n"+e);
			System.out.println("[m_id		]\n"+m_id		);
			System.out.println("[l_cd		]\n"+l_cd		);
			System.out.println("[r_st		]\n"+r_st		);
			System.out.println("[fee_tm		]\n"+fee_tm		);
			System.out.println("[tm_st1		]\n"+tm_st1		);
			System.out.println("[rent_seq	]\n"+rent_seq	);

	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt1 != null)	pstmt1.close();
				if(pstmt2 != null)	pstmt2.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	/**
	 *	연장회차 삭제 : 한회차 대여료 delete /con_fee/ext_scd_i_a.jsp (20071123 수정)
	 */ 
	public boolean dropFeeScdNew(String m_id, String l_cd, String r_st, String rent_seq, String fee_tm, String tm_st1, String tm_st2)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;

		String query1 = " delete from scd_fee"+
						" where RENT_MNG_ID=? and RENT_L_CD=? and RENT_ST=? and FEE_TM=? and TM_ST1=? and TM_ST2=? and RENT_SEQ=?";

		String query2 = " update scd_fee set fee_tm=fee_tm-1"+
						" where RENT_MNG_ID=? and RENT_L_CD=? and to_number(FEE_TM)>? and rent_st=? and rent_seq=? and TM_ST2=? "+
						" and   (select count(0) from scd_fee where rent_mng_id=? and rent_l_cd=? and rent_st=? and rent_seq=? and fee_tm=? and TM_ST2=?) = 0 ";
		try {
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query1);
			pstmt1.setString(1 , m_id		);
			pstmt1.setString(2 , l_cd		);
			pstmt1.setString(3 , r_st		);
			pstmt1.setString(4 , fee_tm		);
			pstmt1.setString(5 , tm_st1		);
			pstmt1.setString(6 , tm_st2		);
			pstmt1.setString(7 , rent_seq	);
			pstmt1.executeUpdate();
			pstmt1.close();
		    /*
			pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString(1 , m_id		);
			pstmt2.setString(2 , l_cd		);
			pstmt2.setString(3 , fee_tm		);
			pstmt2.setString(4 , r_st		);
			pstmt2.setString(5 , rent_seq	);
			pstmt2.setString(6 , tm_st2		);
			pstmt2.setString(7 , m_id		);
			pstmt2.setString(8 , l_cd		);
			pstmt2.setString(9 , r_st		);
			pstmt2.setString(10, rent_seq	);
			pstmt2.setString(11, fee_tm		);
			pstmt2.setString(12, tm_st2		);
			pstmt2.executeUpdate();
			pstmt2.close();
			*/

			conn.commit();

		} catch (Exception e) {
			System.out.println("[AddFeeDatabase:dropFeeScdNew]\n"+e);
			System.out.println("[m_id		]\n"+m_id		);
			System.out.println("[l_cd		]\n"+l_cd		);
			System.out.println("[r_st		]\n"+r_st		);
			System.out.println("[fee_tm		]\n"+fee_tm		);
			System.out.println("[tm_st1		]\n"+tm_st1		);
			System.out.println("[tm_st2		]\n"+tm_st2		);
			System.out.println("[rent_seq	]\n"+rent_seq	);

	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt1 != null)	pstmt1.close();
				if(pstmt2 != null)	pstmt2.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}	


	/**
	 *	// 만기대여된 계약 스케쥴 자동 연장 : + 1개월씩 증가
	 */
	public Vector getEndContList()
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.rent_mng_id, a.rent_l_cd,  b.rent_st, sf.rent_seq, sf.fee_tm, sf.fee_est_dt "+
  				" from cont a,"+
  				" (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, max(rent_end_dt) rent_end_dt from fee where rent_end_dt is not null group by rent_mng_id, rent_l_cd) b,"+
  				" (select rent_mng_id, rent_l_cd, rent_seq, max(fee_est_dt) fee_est_dt , max(to_number(fee_tm)) fee_tm  from scd_fee group by rent_mng_id, rent_l_cd, rent_seq ) sf"+
   				"	where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd "+
    	//		"	and  a.rent_mng_id=sf.rent_mng_id and a.rent_l_cd=sf.rent_l_cd  and a.rent_l_cd = 'S104HJML00007' "+
    			"	and  a.rent_mng_id=sf.rent_mng_id and a.rent_l_cd=sf.rent_l_cd  "+
    			"	and to_date(b.rent_end_dt)  + 15 < sysdate  and a.use_yn = 'Y' and a.car_st<>'2' order by 5 ";

	
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
			System.out.println("[AddFeeDatabase:getEndContList]\n"+e);
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
	 *	선납개시대여료  _스켸쥴 자동생성시 선납개시대여료가 있는 경우 일단 생성하지 못하도록 함.(기간이 ???)
	 */
	public int getScdExtPreAmt(String m_id, String l_cd, String r_st, String rent_seq)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		String query = "";
		int rent_st = 0;

		query = " select count(0) rent_st from scd_ext where rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"' and rent_st = '" + r_st + "' and rent_seq='" + rent_seq + "' and ext_st = '2'";

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			if(rs.next())
			{				
				rent_st	= rs.getInt(1);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getScdExtPreAmt]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return rent_st;
		}
	}

   //재무회계 - 입금처리전관련 입금처리시
	public FeeScdBean getScdIncom(String m_id, String l_cd, String exp_dt, String ext_tm, int exp_amt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		FeeScdBean fee_scd = new FeeScdBean();

		String query = "";
		query = " select RENT_MNG_ID, RENT_L_CD, FEE_TM, RENT_ST, RENT_SEQ, TM_ST1, TM_ST2,"+
				" decode(fee_est_dt, '','', substr(FEE_EST_DT, 1, 4) || '-' || substr(FEE_EST_DT, 5, 2) || '-'||substr(FEE_EST_DT, 7, 2)) FEE_EST_DT,"+
				" FEE_S_AMT, FEE_V_AMT, RC_YN,"+
				" decode(RC_DT, '', '', substr(RC_DT, 1, 4) || '-' || substr(RC_DT, 5, 2) || '-'||substr(RC_DT, 7, 2)) RC_DT,"+
				" RC_AMT, DLY_DAYS, DLY_FEE,"+
				" decode(PAY_CNG_DT, '', '', substr(PAY_CNG_DT, 1, 4) || '-' || substr(PAY_CNG_DT, 5, 2) || '-'||substr(PAY_CNG_DT, 7, 2)) PAY_CNG_DT,"+
				" PAY_CNG_CAU,"+
				" substr(R_FEE_EST_DT, 1, 4) || '-' || substr(R_FEE_EST_DT, 5, 2) || '-'||substr(R_FEE_EST_DT, 7, 2) R_FEE_EST_DT,"+
				" substr(REQ_DT, 1, 4) || '-' || substr(REQ_DT, 5, 2) || '-'||substr(REQ_DT, 7, 2) REQ_DT,"+
				" substr(R_REQ_DT, 1, 4) || '-' || substr(R_REQ_DT, 5, 2) || '-'||substr(R_REQ_DT, 7, 2) R_REQ_DT,"+
				" substr(TAX_OUT_DT, 1, 4) || '-' || substr(TAX_OUT_DT, 5, 2) || '-'||substr(TAX_OUT_DT, 7, 2) TAX_OUT_DT,"+
				" substr(USE_S_DT, 1, 4) || '-' || substr(USE_S_DT, 5, 2) || '-'||substr(USE_S_DT, 7, 2) USE_S_DT,"+
				" substr(USE_E_DT, 1, 4) || '-' || substr(USE_E_DT, 5, 2) || '-'||substr(USE_E_DT, 7, 2) USE_E_DT, adate, pay_st, incom_dt, incom_seq"+
				" from scd_fee "+
				" where RENT_MNG_ID = '"+m_id+"' and rent_l_cd='"+l_cd+"'"+
				" and   R_FEE_EST_DT = '"+exp_dt+"' and FEE_TM ='"+ext_tm+"'"+
				" and   FEE_S_AMT + FEE_V_AMT = " + exp_amt ;
			

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			while(rs.next())
			{
				fee_scd.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_scd.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_scd.setRent_seq(rs.getString("RENT_SEQ")==null?"":rs.getString("RENT_SEQ"));
				fee_scd.setTm_st1(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				fee_scd.setTm_st2(rs.getString("TM_ST2")==null?"":rs.getString("TM_ST2"));
				fee_scd.setFee_est_dt(rs.getString("FEE_EST_DT")==null?"":rs.getString("FEE_EST_DT"));
				fee_scd.setFee_s_amt(rs.getString("FEE_S_AMT")==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee_scd.setFee_v_amt(rs.getString("FEE_V_AMT")==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee_scd.setRc_yn(rs.getString("RC_YN")==null?"":rs.getString("RC_YN"));
				fee_scd.setRc_dt(rs.getString("RC_DT")==null?"":rs.getString("RC_DT"));
				fee_scd.setRc_amt(rs.getString("RC_AMT")==null?0:Integer.parseInt(rs.getString("RC_AMT")));
				fee_scd.setDly_days(rs.getString("DLY_DAYS")==null?"":rs.getString("DLY_DAYS"));
				fee_scd.setDly_fee(rs.getString("DLY_FEE")==null?0:Integer.parseInt(rs.getString("DLY_FEE")));
				fee_scd.setPay_cng_dt(rs.getString("PAY_CNG_DT")==null?"":rs.getString("PAY_CNG_DT"));
				fee_scd.setPay_cng_cau(rs.getString("PAY_CNG_CAU")==null?"":rs.getString("PAY_CNG_CAU"));
				fee_scd.setR_fee_est_dt(rs.getString("R_FEE_EST_DT")==null?"":rs.getString("R_FEE_EST_DT"));
				fee_scd.setReq_dt(rs.getString("REQ_DT")==null?"":rs.getString("REQ_DT"));
				fee_scd.setR_req_dt(rs.getString("R_REQ_DT")==null?"":rs.getString("R_REQ_DT"));
				fee_scd.setTax_out_dt(rs.getString("TAX_OUT_DT")==null?"":rs.getString("TAX_OUT_DT"));
				fee_scd.setUse_s_dt(rs.getString("USE_S_DT")==null?"":rs.getString("USE_S_DT"));
				fee_scd.setUse_e_dt(rs.getString("USE_E_DT")==null?"":rs.getString("USE_E_DT"));
				fee_scd.setAdate(rs.getString("ADATE")==null?"":rs.getString("ADATE"));
				fee_scd.setPay_st(rs.getString("PAY_ST")==null?"":rs.getString("PAY_ST"));
				fee_scd.setIncom_dt(rs.getString("INCOM_DT")==null?"":rs.getString("INCOM_DT"));
				fee_scd.setIncom_seq(rs.getString("INCOM_SEQ")==null?0:Integer.parseInt(rs.getString("INCOM_SEQ")));

			}
			rs.close();
			stmt.close();
			
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getScdIncom]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return fee_scd;
		}				
	}
	
	/**
	 *	대여료스케줄 조회 화면 펼쳐질때 호출. 연체료/일 계산 : 20081010->20220101기준 연체료 변경 적용
	 */
	public boolean calDelayDt(String m_id, String l_cd, String rent_dt)
	{
		getConnection();
		boolean flag = true;
		Statement stmt1 = null;
		Statement stmt2 = null;
		Statement stmt3 = null;
		String dly_per = "0.24";

		//연체일 있는 경우(입금:입금일>입금예정일, 미입금:현재날자>입금예정일)
		String query1 = " UPDATE SCD_FEE SET"+
						" dly_days = TRUNC(NVL(TO_DATE(rc_dt, 'YYYYMMDD'), SYSDATE) - TO_DATE(r_fee_est_dt, 'YYYYMMDD')),"+
						" dly_fee = (TRUNC(((decode(rc_amt,0,fee_s_amt+fee_v_amt,rc_amt))*"+dly_per+"*TRUNC(TO_DATE(r_fee_est_dt, 'YYYYMMDD')- NVL(TO_DATE(rc_dt, 'YYYYMMDD'), SYSDATE)))/365) * -1)"+
						" WHERE bill_yn='Y' and rent_mng_id = '"+m_id+"' and rent_l_cd = '"+l_cd+"'"+
						" and nvl(rc_dt,to_char(sysdate,'YYYYMMDD')) > r_fee_est_dt"+
						" and (rent_l_cd, rent_mng_id, rent_st) in (select a.rent_l_cd, a.rent_mng_id, a.rent_st from fee a, cont b, cont_etc c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and decode(c.rent_suc_dt,'',decode(a.rent_st,'1',b.rent_dt,a.rent_dt),c.rent_suc_dt) < '20220101')" ;

		dly_per = "0.20";

		//연체일 있는 경우(입금:입금일>입금예정일, 미입금:현재날자>입금예정일)
		String query2 = " UPDATE SCD_FEE SET"+
						" dly_days = TRUNC(NVL(TO_DATE(rc_dt, 'YYYYMMDD'), SYSDATE) - TO_DATE(r_fee_est_dt, 'YYYYMMDD')),"+
						" dly_fee = (TRUNC(((decode(rc_amt,0,fee_s_amt+fee_v_amt,rc_amt))*"+dly_per+"*TRUNC(TO_DATE(r_fee_est_dt, 'YYYYMMDD')- NVL(TO_DATE(rc_dt, 'YYYYMMDD'), SYSDATE)))/365) * -1)"+
						" WHERE bill_yn='Y' and rent_mng_id = '"+m_id+"' and rent_l_cd = '"+l_cd+"'"+
						" and nvl(rc_dt,to_char(sysdate,'YYYYMMDD')) > r_fee_est_dt"+
						" and (rent_l_cd, rent_mng_id, rent_st) in (select a.rent_l_cd, a.rent_mng_id, a.rent_st from fee a, cont b, cont_etc c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and decode(c.rent_suc_dt,'',decode(a.rent_st,'1',b.rent_dt,a.rent_dt),c.rent_suc_dt) >= '20220101')" ;

		//연체일 없는 경우(입금:입금일=입금예정일, 입금일<입금예정일(선수), 미입금:현재날짜<입금예정일)
		String query3 = " UPDATE SCD_FEE set"+
						" dly_days = '0',"+
						" dly_fee = 0"+
						" WHERE bill_yn='Y' and rent_mng_id = '"+m_id+"' and rent_l_cd = '"+l_cd+"'"+
						" and nvl(rc_dt,to_char(sysdate,'YYYYMMDD')) <= r_fee_est_dt";


		try 
		{
			conn.setAutoCommit(false);

			stmt1 = conn.createStatement();
		    stmt1.executeUpdate(query1);
			stmt1.close();

			stmt2 = conn.createStatement();
		    stmt2.executeUpdate(query2);
			stmt2.close();

			stmt3 = conn.createStatement();
		    stmt3.executeUpdate(query3);
			stmt3.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddFeeDatabase:calDelayDt]\n"+e);			
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(stmt1 != null)	stmt1.close();
				if(stmt2 != null)	stmt2.close();
				if(stmt3 != null)	stmt3.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	/**
	 *	대여료스케줄 조회 화면 펼쳐질때 호출. 연체료/일 계산 : 20081010->20220101기준 연체료 변경 적용
	 */
	public boolean calDelayDtPrint(String m_id, String l_cd, String cls_dt, String rent_dt)
	{
		getConnection();
		boolean flag = true;
		Statement stmt1 = null;
		Statement stmt2 = null;
		Statement stmt3 = null;

		String today = "to_char(sysdate,'YYYYMMDD')";
		String today2 = "SYSDATE";
		
		// 0.18 : 개업 ~ 20081009
		// 0.24 : 20081010 ~ 20211231
		// 0.20 : 20220101 ~
		// 20211214 기준 최소 계약일 20110719 로 2008년 계약없음. 바로 0.24, 0.2로 변경
		
		String dly_per = "0.24";


		//연체일 있는 경우(입금:입금일>입금예정일, 미입금:현재날자>입금예정일)
		String query1 = " UPDATE SCD_FEE SET"+
						"        dly_days = TRUNC(NVL(TO_DATE(rc_dt, 'YYYYMMDD'), "+today2+") - TO_DATE(r_fee_est_dt, 'YYYYMMDD')),"+
						"        dly_fee = (TRUNC(((decode(rc_amt,0,fee_s_amt+fee_v_amt,rc_amt))*"+dly_per+"*TRUNC(TO_DATE(r_fee_est_dt, 'YYYYMMDD')- NVL(TO_DATE(rc_dt, 'YYYYMMDD'), "+today2+")))/365) * -1)"+
						" WHERE bill_yn='Y' and fee_s_amt>0 and rent_mng_id = '"+m_id+"' and rent_l_cd = '"+l_cd+"' "+
						" and nvl(rc_dt,"+today+") > r_fee_est_dt"+
						" and (rent_l_cd, rent_mng_id, rent_st) in (select a.rent_l_cd, a.rent_mng_id, a.rent_st from fee a, cont b, cont_etc c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and decode(c.rent_suc_dt,'',decode(a.rent_st,'1',b.rent_dt,a.rent_dt),c.rent_suc_dt) < '20220101')" ;

		dly_per = "0.20";

		//연체일 있는 경우(입금:입금일>입금예정일, 미입금:현재날자>입금예정일)
		String query2 = " UPDATE SCD_FEE SET"+
						"        dly_days = TRUNC(NVL(TO_DATE(rc_dt, 'YYYYMMDD'), "+today2+") - TO_DATE(r_fee_est_dt, 'YYYYMMDD')),"+
						"        dly_fee = (TRUNC(((decode(rc_amt,0,fee_s_amt+fee_v_amt,rc_amt))*"+dly_per+"*TRUNC(TO_DATE(r_fee_est_dt, 'YYYYMMDD')- NVL(TO_DATE(rc_dt, 'YYYYMMDD'), "+today2+")))/365) * -1)"+
						" WHERE bill_yn='Y' and fee_s_amt>0 and rent_mng_id = '"+m_id+"' and rent_l_cd = '"+l_cd+"' "+
						" and nvl(rc_dt,"+today+") > r_fee_est_dt"+
						" and (rent_l_cd, rent_mng_id, rent_st) in (select a.rent_l_cd, a.rent_mng_id, a.rent_st from fee a, cont b, cont_etc c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and decode(c.rent_suc_dt,'',decode(a.rent_st,'1',b.rent_dt,a.rent_dt),c.rent_suc_dt) >= '20220101')" ;

		//연체일 없는 경우(입금:입금일=입금예정일, 입금일<입금예정일(선수), 미입금:현재날짜<입금예정일)
		String query3 = " UPDATE SCD_FEE set"+
						" dly_days = '0',"+
						" dly_fee = 0"+
						" WHERE bill_yn='Y' and rent_mng_id = '"+m_id+"' and rent_l_cd = '"+l_cd+"' "+
						" and nvl(rc_dt,"+today+") <= r_fee_est_dt";

		try 
		{
			conn.setAutoCommit(false);

			stmt1 = conn.createStatement();
		    stmt1.executeUpdate(query1);
			stmt1.close();

			stmt2 = conn.createStatement();
		    stmt2.executeUpdate(query2);
			stmt2.close();

			stmt3 = conn.createStatement();
		    stmt3.executeUpdate(query3);
			stmt3.close();

			conn.commit();
		    

		} catch (Exception e) {
			System.out.println("[AddFeeDatabase:calDelayDtPrint]\n"+e);			
			System.out.println("[AddFeeDatabase:calDelayDtPrint]\n"+query1);			
			System.out.println("[AddFeeDatabase:calDelayDtPrint]\n"+query2);			
			System.out.println("[AddFeeDatabase:calDelayDtPrint]\n"+query3);			
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(stmt1 != null)	stmt1.close();
				if(stmt2 != null)	stmt2.close();
				if(stmt3 != null)	stmt3.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	/**
	 *	대여료스케줄 일괄 연체료 셋팅
	 */
	public boolean calDelayDtAll()
	{
		getConnection();
		boolean flag = true;
		Statement stmt1 = null;
		Statement stmt2 = null;
		String today = "to_char(sysdate,'YYYYMMDD')";
		String today2 = "SYSDATE";

		//연체일 있는 경우(입금:입금일>입금예정일, 미입금:현재날자>입금예정일) : 20220101이전계약
		String query1 = " UPDATE SCD_FEE SET"+
						" dly_days = TRUNC("+today2+" - TO_DATE(r_fee_est_dt, 'YYYYMMDD')),"+
						" dly_fee = (TRUNC(((decode(rc_amt,0,fee_s_amt+fee_v_amt,rc_amt))*0.24*TRUNC(TO_DATE(r_fee_est_dt, 'YYYYMMDD')- "+today2+"))/365) * -1)"+
						" WHERE bill_yn='Y' and rc_dt is null and r_fee_est_dt < "+today+" "+
						" and (rent_l_cd, rent_mng_id, rent_st) in (select a.rent_l_cd, a.rent_mng_id, a.rent_st from fee a, cont b, cont_etc c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and decode(c.rent_suc_dt,'',decode(a.rent_st,'1',b.rent_dt,a.rent_dt),c.rent_suc_dt) < '20220101')" ;

		//연체일 있는 경우(입금:입금일>입금예정일, 미입금:현재날자>입금예정일) : 20220101이후계약
		String query2 = " UPDATE SCD_FEE SET"+
						" dly_days = TRUNC("+today2+" - TO_DATE(r_fee_est_dt, 'YYYYMMDD')),"+
						" dly_fee = (TRUNC(((decode(rc_amt,0,fee_s_amt+fee_v_amt,rc_amt))*0.20*TRUNC(TO_DATE(r_fee_est_dt, 'YYYYMMDD')- "+today2+"))/365) * -1)"+
						" WHERE bill_yn='Y' and rc_dt is null and r_fee_est_dt < "+today+" "+
						" and (rent_l_cd, rent_mng_id, rent_st) in (select a.rent_l_cd, a.rent_mng_id, a.rent_st from fee a, cont b, cont_etc c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and decode(c.rent_suc_dt,'',decode(a.rent_st,'1',b.rent_dt,a.rent_dt),c.rent_suc_dt) >= '20220101')" ;

		try 
		{
			conn.setAutoCommit(false);

			stmt1 = conn.createStatement();
		    stmt1.executeUpdate(query1);
			stmt1.close();

			stmt2 = conn.createStatement();
		    stmt2.executeUpdate(query2);
			stmt2.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddFeeDatabase:calDelayDtAll]\n"+e);			
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(stmt1 != null)	stmt1.close();
				if(stmt2 != null)	stmt2.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	/**
	 *	연장계약 기준일자 변경
	 */
	public Vector getFeeEtcBaseDtUpdateList()
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select "+
				" a.rent_start_dt, "+
				" to_date(a.rent_start_dt,'YYYYMMDD')-to_date(b.sh_day_bas_dt,'YYYYMMDD') day, "+
				" b.* "+
				" from fee a, fee_etc b "+
				" where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st "+
				" and b.rent_st<>'1' and sh_day_bas_dt is not null "+
				" and to_date(a.rent_start_dt,'YYYYMMDD')-to_date(b.sh_day_bas_dt,'YYYYMMDD') > 5 "+
				" order by to_date(a.rent_start_dt,'YYYYMMDD')-to_date(b.sh_day_bas_dt,'YYYYMMDD') "+
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
			System.out.println("[AddFeeDatabase:getFeeEtcBaseDtUpdateList]\n"+e);
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
	 *	계산서 발행중지관리
	 */
	public Vector getFeeScdStopList(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select "+
				"        c.firm_nm, f.car_no, nvl(d.cnt,0) cnt, d.use_e_dt as rent_end_dt, e.tax_dt, "+
				"        decode(a.stop_st,'1','연체','2','고객요청') stop_st_nm, "+
				"        decode(a.reg_id,'system','system',h.user_nm) reg_nm, "+
				"        a.* "+
				" from   scd_fee_stop a, cont b, client c, car_reg f, users h, "+
				"        ( "+
				"             select   rent_mng_id, rent_l_cd, count(0) cnt, min(to_number(rent_st)) rent_st, min(tm_st1) tm_st1, min(fee_tm) fee_tm, "+
				"                      sum(fee_s_amt+fee_v_amt) fee_amt, min(fee_est_dt) fee_est_dt, max(use_e_dt) use_e_dt "+
				"             from     scd_fee "+
				"             where    bill_yn='Y' and rc_dt is null and r_fee_est_dt <=to_char(sysdate,'YYYYMMDD') "+
				"             group by rent_mng_id, rent_l_cd "+
				"        ) d , "+

				"        ( "+
				"             select /*+ leading(a b) index(b tax_idx5) */ a.rent_l_cd, max(b.tax_dt) tax_dt "+
				"             from   tax_item_list a, tax b "+
				"             where  a.gubun='1' and a.item_id=b.item_id and b.tax_st='O' "+
				"             group by a.rent_l_cd "+
				"        ) e "+

				" where  a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.use_yn='Y' ";

			if(gubun4.equals("2"))			query += " and a.stop_st='1'";
			else if(gubun4.equals("3"))		query += " and a.stop_st='2'";

			if(gubun3.equals("2"))			query += " and a.cancel_dt is null";
			else if(gubun3.equals("3"))		query += " and a.cancel_dt is not null";

			query += 	"        and b.client_id=c.client_id "+
				"        and b.car_mng_id=f.car_mng_id "+
				"        and a.reg_id=h.user_id(+) "+
				"        and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+) "+
				"        and a.rent_l_cd=e.rent_l_cd(+) "+
				" ";


		if(!t_wd.equals("")){
			/*검색조건*/			
			if(s_kd.equals("1"))		query += " and c.firm_nm like '%"+t_wd+"%'\n";
			else if(s_kd.equals("2"))	query += " and a.rent_l_cd like upper('%"+t_wd+"%')\n";
			else if(s_kd.equals("3"))	query += " and f.car_no like '%"+t_wd+"%'\n";

		}

		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		/*정렬조건*/

		if(sort_gubun.equals("0"))		query += " order by nvl(d.cnt,0)";
		else if(sort_gubun.equals("1"))	query += " order by c.firm_nm "+sort;
		else if(sort_gubun.equals("2"))	query += " order by f.car_no "+sort;


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
			System.out.println("[AddFeeDatabase:getFeeScdStopList]\n"+e);
			System.out.println("[AddFeeDatabase:getFeeScdStopList]\n"+query);
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
	 *	세금계산서 발행 일시중지 쿼리
	 */
	public FeeScdStopBean getCarCallInFeeStop(String m_id, String l_cd, String seq)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		FeeScdStopBean fee_scd = new FeeScdStopBean();
		String query = "";
		query = " select * from car_call_in where rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"' and seq='"+seq+"'";

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			if(rs.next())
			{				
				fee_scd.setRent_mng_id	(rs.getString(1)==null?"":rs.getString(1));
				fee_scd.setRent_l_cd	(rs.getString(2)==null?"":rs.getString(2));
				fee_scd.setSeq 			(rs.getString(3)==null?"":rs.getString(3));
				fee_scd.setStop_st 		(rs.getString(4)==null?"":rs.getString(4));
				fee_scd.setStop_s_dt	(rs.getString(5)==null?"":rs.getString(5));
				fee_scd.setStop_cau 	(rs.getString(6)==null?"":rs.getString(6));
				fee_scd.setReg_dt 		(rs.getString(7)==null?"":rs.getString(7));
				fee_scd.setReg_id 		(rs.getString(8)==null?"":rs.getString(8));
				fee_scd.setCancel_dt	(rs.getString(9)==null?"":rs.getString(9));
				fee_scd.setCancel_id	(rs.getString(10)==null?"":rs.getString(10));
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getCarCallInFeeStop]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return fee_scd;
		}
	}

	/**	
	 *	대여스케줄 발행 일시중지 등록
	 */
	public boolean insertCarCallInFeeScdStop(FeeScdStopBean scd_stop)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
		query = " insert into car_call_in (RENT_MNG_ID, RENT_L_CD, SEQ, IN_ST, IN_DT, "+
				" IN_CAU, REG_DT, REG_ID, OUT_DT, OUT_ID )"+
				" values ("+
				" ?, ?, ?, ?, replace(?, '-', ''), ?, to_char(sysdate,'YYYYMMDD'), ?, replace(?, '-', ''), ?)";
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  scd_stop.getRent_mng_id	());
			pstmt.setString(2,  scd_stop.getRent_l_cd	());
			pstmt.setString(3,  scd_stop.getSeq 		());
			pstmt.setString(4,  scd_stop.getStop_st 	());
			pstmt.setString(5,  scd_stop.getStop_s_dt	());
			pstmt.setString(6,  scd_stop.getStop_cau	());
			pstmt.setString(7, scd_stop.getReg_id 		());
			pstmt.setString(8, scd_stop.getCancel_dt	());
			pstmt.setString(9, scd_stop.getCancel_id	());

			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[AddFeeDatabase:insertCarCallInFeeScdStop]\n"+e);
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
	 *	대여스케줄 발행 일시중지 등록
	 */
	public boolean updateCarCallInFeeScdStop(FeeScdStopBean scd_stop)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";

		query = " update car_call_in set "+
				" IN_ST		=?, "+
				" IN_DT		=replace(?, '-', ''), "+
				" IN_CAU	=?, "+
				" OUT_DT	=replace(?, '-', ''), "+
				" OUT_ID	=?"+
				" where rent_mng_id=? and rent_l_cd=? and seq=?";
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  scd_stop.getStop_st		());
			pstmt.setString(2,  scd_stop.getStop_s_dt	());
			pstmt.setString(3,  scd_stop.getStop_cau	());
			pstmt.setString(4,  scd_stop.getCancel_dt	());
			pstmt.setString(5,  scd_stop.getCancel_id	());
			pstmt.setString(6,  scd_stop.getRent_mng_id	());
			pstmt.setString(7,  scd_stop.getRent_l_cd	());
			pstmt.setString(8,  scd_stop.getSeq 		());

			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[AddFeeDatabase:updateCarCallInFeeScdStop]\n"+e);
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
	 *	마지막 연장번호 구하기
	 */
	public int getYnCarCallIn(String m_id, String l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		String query = "";
		int cnt = 0;

		query = " select count(0) cnt from car_call_in where out_dt is null and rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"'";

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			if(rs.next())
			{				
				cnt	= rs.getInt(1);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getYnCarCallIn]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return cnt;
		}
	}

	/**
	 *	대여료일괄입금처리리스트
	 */
	public Vector getFeeScdSettleList(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.*, (a.fee_s_amt+a.fee_v_amt) fee_amt, decode(a.tm_st1,'0','대여료','잔액') tm_st1_nm "+
				" from   scd_fee a "+
				" where  a.rent_mng_id='"+rent_mng_id+"' and a.rent_l_cd='"+rent_l_cd+"' and a.rc_dt is null and a.bill_yn='Y'"+
				" order by a.fee_est_dt "+
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
			System.out.println("[AddFeeDatabase:getFeeScdSettleList]\n"+e);
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
	 *	대여료합
	 */
	public Hashtable getFeeScdDlySettleSum(String m_id, String l_cd){
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		query = " SELECT SUM(( a.fee_s_amt + a.fee_v_amt )) AS fee_amt FROM scd_fee a WHERE  a.rent_mng_id = '"+m_id+"' " +
				" AND a.rent_l_cd = '"+l_cd+"' " +
				" AND a.rc_dt IS NULL " +
				" AND a.bill_yn = 'Y' " +
				" AND a.r_fee_est_dt <= to_char(sysdate,'YYYYMMDD') ";
		
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
			System.out.println("[AddFeeDatabase:getFeeScdDlySettleSum]\n"+e);
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
	 *	대여료일괄입금처리리스트
	 */
	public Vector getFeeScdDlySettleList(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.*, (a.fee_s_amt+a.fee_v_amt) fee_amt, decode(a.tm_st1,'0','대여료','잔액') tm_st1_nm "+
				" from   scd_fee a "+
				" where  a.rent_mng_id='"+rent_mng_id+"' and a.rent_l_cd='"+rent_l_cd+"' and a.rc_dt is null and a.bill_yn='Y' and a.r_fee_est_dt <= to_char(sysdate,'YYYYMMDD')"+
				" order by a.fee_est_dt "+
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
			System.out.println("[AddFeeDatabase:getFeeScdDlySettleList]\n"+e);
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
	 *	대여료일괄입금처리리스트
	 */
	public Vector getFeeScdSettleClientList(String client_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.*, (a.fee_s_amt+a.fee_v_amt) fee_amt, decode(a.tm_st1,'0','대여료','대여료 잔액') tm_st1_nm, c.car_no, c.car_nm, c.car_mng_id, f.firm_nm, f.client_id "+
				" from   scd_fee a, cont b, car_reg c, fee d, fee_rtn e, client f "+
				" where  "+
				" a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.car_mng_id=c.car_mng_id(+)"+
				" and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd and a.rent_st=d.rent_st"+
				" and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+) and a.rent_st=e.rent_st(+) and a.rent_seq=e.rent_seq(+)"+
				" and e.client_id=f.client_id(+)"+
				" and b.client_id='"+client_id+"' "+
				" and a.rc_dt is null and a.bill_yn='Y'"+
				" order by a.fee_est_dt, nvl(d.rent_dt,b.rent_dt) "+
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
			System.out.println("[AddFeeDatabase:getFeeScdSettleClientList]\n"+e);
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
	 *	대여료일괄입금처리리스트
	 */
	public Vector getFeeScdDlySettleClientList(String client_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.*, (a.fee_s_amt+a.fee_v_amt) fee_amt, decode(a.tm_st1,'0','대여료','대여료 잔액') tm_st1_nm, c.car_no, c.car_nm, c.car_mng_id,a.fee_s_amt,a.fee_v_amt "+
				" from   scd_fee a, cont b, car_reg c, fee d "+
				" where  "+
				" a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.car_mng_id=c.car_mng_id(+)"+
				" and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd and a.rent_st=d.rent_st"+
				" and b.client_id='"+client_id+"' "+
				" and a.rc_dt is null and a.bill_yn='Y'"+
				" and a.r_fee_est_dt <= to_char(sysdate+5,'YYYYMMDD')"+
				" order by a.fee_est_dt, nvl(d.rent_dt,b.rent_dt) "+
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
			System.out.println("[AddFeeDatabase:getFeeScdSettleClientList]\n"+e);
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
	 *	대여료일괄입금처리리스트 ARS결재요청에서는 실입금예정일-5 가 아닌 입금예정일로 
	 */
	public Vector getFeeScdDlySettleClientArsList(String client_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.*, (a.fee_s_amt+a.fee_v_amt) fee_amt, decode(a.tm_st1,'0','대여료','대여료 잔액') tm_st1_nm, c.car_no, c.car_nm, c.car_mng_id,a.fee_s_amt,a.fee_v_amt "+
				" from   scd_fee a, cont b, car_reg c, fee d "+
				" where  "+
				" a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.car_mng_id=c.car_mng_id(+)"+
				" and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd and a.rent_st=d.rent_st"+
				" and b.client_id='"+client_id+"' "+
				" and a.rc_dt is null and a.bill_yn='Y'"+
				" and a.fee_est_dt <= to_char(sysdate+5,'YYYYMMDD')"+
				" order by a.fee_est_dt, nvl(d.rent_dt,b.rent_dt) "+
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
			System.out.println("[AddFeeDatabase:getFeeScdSettleClientList]\n"+e);
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
	 *	대여료일괄입금처리리스트
	 */
	public Vector getFeeScdDlyStatClient(String client_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.rent_mng_id, a.rent_l_cd, c.dly_fee, d.pay_amt, (nvl(c.dly_fee,0)-nvl(d.pay_amt,0)) jan_amt, b.car_no, b.car_nm, b.car_mng_id, '' firm_nm, '' client_id"+
				" from   cont a, car_reg b, "+
				"        (select rent_mng_id, rent_l_cd, sum(dly_fee) dly_fee from scd_fee where bill_yn='Y' group by rent_mng_id, rent_l_cd) c,"+
				"        (select rent_mng_id, rent_l_cd, sum(pay_amt) pay_amt from scd_dly group by rent_mng_id, rent_l_cd) d"+
				" where  a.car_mng_id=b.car_mng_id(+)"+
				"        and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) "+
				"        and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+) "+
				"        and (nvl(c.dly_fee,0)-nvl(d.pay_amt,0))>0"+
				"        and a.client_id='"+client_id+"'"+
				" order by a.reg_dt"+
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
			System.out.println("[AddFeeDatabase:getFeeScdDlyStatClient]\n"+e);
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
	 *	면책금일괄입금처리리스트
	 */
	public Vector getServScdStatClient(String client_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.*, (a.ext_s_amt+a.ext_v_amt) ext_amt, decode(a.ext_tm,'1','면책금','면책금 잔액') tm_st1_nm, c.car_no, c.car_nm, c.car_mng_id, d.accid_id, d.serv_id "+
				" from   scd_ext a, cont b, car_reg c, service d "+
				" where  "+
				" a.ext_st='3' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.car_mng_id=c.car_mng_id(+)"+
				" and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd and a.ext_id=d.serv_id"+
				" and b.client_id='"+client_id+"' "+
				" and a.ext_pay_dt is null and a.bill_yn='Y'"+
				" order by a.ext_est_dt, b.rent_dt"+
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
			System.out.println("[AddFeeDatabase:getServScdStatClient]\n"+e);
			System.out.println("[AddFeeDatabase:getServScdStatClient]\n"+query);
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
	 *	해지정산금일괄입금처리리스트
	 */
	public Vector getClsScdStatClient(String client_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.*, (a.ext_s_amt+a.ext_v_amt) ext_amt, decode(a.ext_tm,'1','해지정산금','해지정산금 잔액') tm_st1_nm, c.car_no, c.car_nm, c.car_mng_id, d.cls_dt, d.cls_st "+
				" from   scd_ext a, cont b, car_reg c, cls_cont d "+
				" where  "+
				" a.ext_st='4' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.car_mng_id=c.car_mng_id(+)"+
				" and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd "+
				" and b.client_id='"+client_id+"' "+
				" and a.ext_pay_dt is null and a.bill_yn='Y' and (a.ext_s_amt+a.ext_v_amt)>0"+
				" order by a.ext_est_dt, b.rent_dt"+
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
			System.out.println("[AddFeeDatabase:getClsScdStatClient]\n"+e);
			System.out.println("[AddFeeDatabase:getClsScdStatClient]\n"+query);
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
	 *	과태료일괄입금처리리스트
	 */
	public Vector getFineScdStatClient(String client_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		query = " select a.*, (a.paid_amt) ext_amt, c.car_no, c.car_nm, c.car_mng_id "+
				" from   fine a, cont b, car_reg c, client d, rent_cont g, client h, cont j\n"+
				" where\n"+
				"        a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"        and b.car_mng_id=c.car_mng_id \n"+
				"        and b.client_id=d.client_id \n"+
				"        and a.rent_s_cd=g.rent_s_cd(+) "+
				"        and g.cust_id=h.client_id(+) "+
				"        and g.sub_l_cd=j.rent_l_cd(+) "+
				"        and nvl(h.client_id,d.client_id)='"+client_id+"'"+
				"        and a.paid_amt > 0 and nvl(a.no_paid_yn,'N') <> 'Y' "+
				"        and a.paid_st in ('3','4') and decode(a.fault_st,'2','Y',nvl(a.bill_yn,'Y'))='Y' "+
				"        and decode(a.rec_plan_dt, '',decode(a.dem_dt, '',a.paid_end_dt, a.dem_dt), a.rec_plan_dt) <= to_char(sysdate,'YYYYMMDD') and a.coll_dt is null"+
				" order by a.vio_dt"+
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
			System.out.println("[AddFeeDatabase:getFineScdStatClient]\n"+e);
			System.out.println("[AddFeeDatabase:getFineScdStatClient]\n"+query);
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
	 *	대여료일괄입금처리리스트
	 */
	public Vector getFeeScdStopList2(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.*, decode(a.stop_st,'1','연체','2','고객요청') stop_st_nm "+
				" from   scd_fee_stop a "+
				" where  a.rent_mng_id='"+rent_mng_id+"' and a.rent_l_cd='"+rent_l_cd+"' and a.cancel_dt is null "+
				" order by a.stop_s_dt "+
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
			System.out.println("[AddFeeDatabase:getFeeScdStopList2]\n"+e);
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
	 *	대여료일괄입금처리리스트
	 */
	public Vector getFeeScdStopClientList(String client_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.*, decode(a.stop_st,'1','연체','2','고객요청') stop_st_nm, c.car_no, c.car_nm "+
				" from   scd_fee_stop a, cont b, car_reg c "+
				" where "+
				" a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.car_mng_id=c.car_mng_id(+)"+
				" and b.client_id='"+client_id+"' and a.cancel_dt is null "+
				" order by a.stop_s_dt "+
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
			System.out.println("[AddFeeDatabase:getFeeScdStopClientList]\n"+e);
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
	 *	거래명세서 rent_st, rent_seq 채우기
	 */
	public void getTaxItemListScdFeeRentstUpdate()
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
        PreparedStatement pstmt2 = null;

		String query = "";

		query = " select "+
				"	b.rent_st, b.rent_seq, a.item_id, a.item_seq "+
				"	from tax_item_list a, scd_fee b "+
				"	where a.gubun='1' and a.rent_st is null "+
				"	and a.rent_l_cd=b.rent_l_cd and a.tm=b.fee_tm "+
				"	order by a.item_id "+
				" ";

		String query2 = " update tax_item_list set rent_st=?, rent_seq=? where item_id=? and item_seq=?";
	
		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);

			pstmt2 = conn.prepareStatement(query2);

			while(rs.next())
			{				
				pstmt2.setString(1, rs.getString("rent_st")==null?"":rs.getString("rent_st"));
				pstmt2.setString(2, rs.getString("rent_seq")==null?"":rs.getString("rent_seq"));
				pstmt2.setString(3, rs.getString("item_id")==null?"":rs.getString("item_id"));
				pstmt2.setString(4, rs.getString("item_seq")==null?"":rs.getString("item_seq"));
				pstmt2.executeUpdate();

			}
			pstmt2.close();

			rs.close();
			stmt.close();

		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getTaxItemListScdFeeRentstUpdate]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
				if(pstmt2 != null)	pstmt2.close();
			}catch(Exception ignore){}
			closeConnection();
		}
	}	

	
	//입금원장관련 new cms 처리 - 인출의뢰일 현재 연체금액
		
	public Hashtable getACmsIncomList(String adate, String acode)
	{
		getConnection();
	
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";		
 	
    	query = " select \n"+
         		" c.code, replace('"+adate+"', '-', '') adate, b.fee_amt , l.fine_amt, case when n.car_ja_amt < 5000 then 0 else n.car_ja_amt end car_ja_amt , case when ( nvl(j.dly_fee,0)-nvl(k.pay_amt,0)) < 5000 then 0 else ( nvl(j.dly_fee,0)-nvl(k.pay_amt,0)) end  dly_amt \n"+
   				" from cont a, cust c, \n"+
      			"  (select rent_mng_id, rent_l_cd, sum(fee_s_amt+fee_v_amt) fee_amt  from scd_fee \n"+
     			"   where  rc_yn='0'  and nvl(bill_yn,'Y')='Y' and fee_est_dt <= replace('"+adate+"', '-', '') group by rent_mng_id, rent_l_cd) b,  \n"+
      			"  (select a.rent_mng_id, sum((TRUNC(((decode(nvl(a.rc_amt,0),0,a.fee_s_amt+a.fee_v_amt,a.rc_amt))*(case when decode(c.rent_suc_dt,'',nvl(f.rent_dt,b.rent_dt),c.rent_suc_dt) > '20220101' then 0.20 else 0.24 end)*TRUNC(TO_DATE(a.r_fee_est_dt, 'YYYYMMDD')- NVL(TO_DATE(a.rc_dt, 'YYYYMMDD'), sysdate)))/365) * -1)) dly_fee from scd_fee a, cont b, fee f, cont_etc c WHERE a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd  and  a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_st = f.rent_st and a.rent_l_cd=c.rent_l_cd and nvl(a.rc_dt,to_char(sysdate,'YYYYMMDD')) > a.r_fee_est_dt group by a.rent_mng_id) j,  \n"+
     			"  (select rent_mng_id,   sum(pay_amt) pay_amt from scd_dly group by rent_mng_id) k,  \n"+
  				"  (SELECT rent_mng_id, rent_l_cd,  sum(paid_amt) fine_amt FROM fine WHERE paid_amt >= 10000  and  coll_dt is null and nvl(no_paid_yn,'N')<>'Y' and nvl(fault_st,'1')='1' and paid_st in ('3','4') group by rent_mng_id, rent_l_cd) l,   \n"+
  				"  (SELECT se.rent_mng_id, se.rent_l_cd, sum(se.ext_s_amt + se.ext_v_amt) car_ja_amt FROM service a, scd_ext se WHERE se.ext_st = '3' and se.rent_mng_id = a.rent_mng_id and se.rent_l_cd = a.rent_l_cd and se.ext_id = a.serv_id and (se.ext_s_amt + se.ext_v_amt)  <> 0 and se.ext_pay_dt is null and nvl(a.no_dft_yn,'N')<>'Y' and nvl(se.bill_yn, 'Y') = 'Y' group by se.rent_mng_id, se.rent_l_cd) n  \n"+       
  				"  where a.rent_mng_id=b.rent_mng_id(+)  and a.rent_l_cd=b.rent_l_cd(+)  \n"+
     			"   and a.rent_mng_id=j.rent_mng_id(+) and a.rent_mng_id=k.rent_mng_id(+)  \n"+
    			"   and a.rent_mng_id=n.rent_mng_id(+) and a.rent_l_cd=n.rent_l_cd(+) \n"+
   				"   and a.rent_mng_id=l.rent_mng_id(+) and a.rent_l_cd=l.rent_l_cd(+)  \n"+
    			"   and a.rent_l_cd=c.code and c.cbit = '2' and nvl(a.use_yn, 'Y') = 'Y' and c.code = '" + acode + "'";     
      
       
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
			System.out.println("[AddFeeDatabase:getACmsIncomList]\n"+e);			
			System.out.println("[AddFeeDatabase:getACmsIncomList]\n"+query);			
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
	 *	한 건에 대한 대여료 스케줄 쿼리
	 */
	public Vector getFeeScd_S106HTLR00091(String m_id, String l_cd, String b_dt, String mode, String bill_yn)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		String scd_fee = " select * from "+
						"         (select '1' gubun, rent_mng_id, rent_l_cd, fee_tm, rent_st, rent_seq, tm_st1, tm_st2, fee_est_dt, r_fee_est_dt, fee_s_amt, fee_v_amt, rc_yn, rc_dt, rc_amt, dly_days, dly_fee, pay_cng_dt, use_s_dt, use_e_dt, tax_out_dt, 'Y' bill_yn, req_dt, adate, pay_st from scd_fee where rent_l_cd='"+l_cd+"' and fee_est_dt <= '20080720' "+
						"          union all"+
			            "          select '2' gubun, rent_mng_id, rent_l_cd, fee_tm, rent_st, rent_seq, tm_st1, tm_st2, fee_est_dt, r_fee_est_dt, fee_s_amt, fee_v_amt, '0' rc_yn, '' rc_dt, 0 rc_amt, dly_days, dly_fee, pay_cng_dt, use_s_dt, use_e_dt, tax_out_dt, 'N' bill_yn, req_dt, adate, pay_st from scd_fee where rent_l_cd='"+l_cd+"' and fee_est_dt between '20080820' and '20090420' and tm_st1='0' "+
						"          union all"+
			            "          select '3' gubun, rent_mng_id, rent_l_cd, fee_tm, rent_st, rent_seq, tm_st1, tm_st2, fee_est_dt, r_fee_est_dt, fee_s_amt, fee_v_amt, '0' rc_yn, '' rc_dt, 0 rc_amt, dly_days, dly_fee, pay_cng_dt, use_s_dt, use_e_dt, tax_out_dt, 'N' bill_yn, req_dt, adate, pay_st from scd_fee where rent_l_cd='"+l_cd+"' and fee_est_dt > '20090420' and tm_st1='0'"+
						"         ) ";

		String sub_query = "";

		if(b_dt.equals("")){
			b_dt = "to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')";
		}else{
			b_dt = "to_date(replace('"+b_dt+"','-',''),'YYYYMMDD')";
		}

		if(mode.equals("ALL")){
			sub_query = " a.rent_mng_id='"+m_id+"'";
		}else{
			sub_query = " a.rent_mng_id='"+m_id+"' and a.rent_l_cd='"+l_cd+"'";
		}
			
		if(!bill_yn.equals("")){
			sub_query += " and nvl(a.bill_yn,'Y')='"+bill_yn+"'";
		}

		query = " select"+
				" rent_mng_id, rent_l_cd, fee_tm, rent_st, rent_seq, tm_st1, tm_st2,"+
				" use_s_dt, use_e_dt, fee_est_dt, r_fee_est_dt, fee_s_amt, fee_v_amt, (fee_s_amt+fee_v_amt) fee_amt,"+
				" rc_yn, rc_dt, rc_amt, decode(sign(dly_day),-1,0,dly_day) dly_days, decode(sign(dly_day),-1,0,dly_amt) dly_fee,"+
				" bill_yn, tax_dt, tax_out_dt, req_dt, adate, pay_st"+
				" from"+
				"     ("+
				"         select"+
				"         a.*, b.tax_dt,"+
				"         TRUNC(NVL(TO_DATE(a.rc_dt, 'YYYYMMDD'), "+b_dt+") - TO_DATE(a.r_fee_est_dt, 'YYYYMMDD')) as dly_day,"+
				"         (TRUNC(((decode(a.rc_amt,0,a.fee_s_amt+a.fee_v_amt,a.rc_amt))*decode(sign(decode(c.rent_suc_dt,'',d.rent_dt,c.rent_suc_dt)-'20220101'),-1,0.20,0.20)*TRUNC(TO_DATE(a.r_fee_est_dt, 'YYYYMMDD')- NVL(TO_DATE(a.rc_dt, 'YYYYMMDD'), "+b_dt+")))/365) * -1) as dly_amt"+
				"         from "+
				"         ("+scd_fee+") a,"+
				"         (select b.rent_l_cd, b.tm, b.rent_st, b.rent_seq, a.tax_dt from tax a, tax_item_list b where b.rent_l_cd='S106HTLR00091' and a.item_id=b.item_id and a.tax_st='O' and b.gubun='1') b,"+
				"         fee d, cont_etc c "+
				"         where "+sub_query+
				"         and a.rent_l_cd=b.rent_l_cd(+) and a.fee_tm=b.tm(+) and a.rent_st=b.rent_st(+) and a.rent_seq=b.rent_seq(+)"+
				"         and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd and a.rent_st=d.rent_st and a.rent_l_cd=c.rent_l_cd "+
				"     )"+
				" order by to_number(fee_tm), to_number(tm_st1)"+
				" ";

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    
	    	

			while(rs.next())
			{
				FeeScdBean fee_scd = new FeeScdBean();
				fee_scd.setRent_mng_id	(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd	(rs.getString("RENT_L_CD")	==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm		(rs.getString("FEE_TM")		==null?"":rs.getString("FEE_TM"));
				fee_scd.setRent_st		(rs.getString("RENT_ST")	==null?"":rs.getString("RENT_ST"));
				fee_scd.setTm_st1		(rs.getString("TM_ST1")		==null?"":rs.getString("TM_ST1"));
				fee_scd.setTm_st2		(rs.getString("TM_ST2")		==null?"":rs.getString("TM_ST2"));
				fee_scd.setFee_est_dt	(rs.getString("FEE_EST_DT")	==null?"":rs.getString("FEE_EST_DT"));
				fee_scd.setFee_s_amt	(rs.getString("FEE_S_AMT")	==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee_scd.setFee_v_amt	(rs.getString("FEE_V_AMT")	==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee_scd.setRc_yn		(rs.getString("RC_YN")		==null?"":rs.getString("RC_YN"));
				fee_scd.setRc_dt		(rs.getString("RC_DT")		==null?"":rs.getString("RC_DT"));
				fee_scd.setRc_amt		(rs.getString("RC_AMT")		==null?0:Integer.parseInt(rs.getString("RC_AMT")));
				fee_scd.setDly_days		(rs.getString("DLY_DAYS")	==null?"":rs.getString("DLY_DAYS"));
				fee_scd.setDly_fee		(rs.getString("DLY_FEE")	==null?0:Integer.parseInt(rs.getString("DLY_FEE")));
				fee_scd.setR_fee_est_dt	(rs.getString("R_FEE_EST_DT")==null?"":rs.getString("R_FEE_EST_DT"));
				fee_scd.setExt_dt		(rs.getString("TAX_DT")		==null?"":rs.getString("TAX_DT"));
				fee_scd.setBill_yn		(rs.getString("bill_yn")	==null?"":rs.getString("bill_yn"));
				fee_scd.setUse_s_dt		(rs.getString("USE_S_DT")	==null?"":rs.getString("USE_S_DT"));
				fee_scd.setUse_e_dt		(rs.getString("USE_E_DT")	==null?"":rs.getString("USE_E_DT"));
				vt.add(fee_scd);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getFeeScd_S106HTLR00091]\n"+e);
			System.out.println("[AddFeeDatabase:getFeeScd_S106HTLR00091]\n"+query);
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
	 *	대여료스케줄 통계(건별)
	 */
	public Hashtable getFeeScdStat_S106HTLR00091(String m_id, String l_cd, String b_dt, String mode, String bill_yn)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();

		String scd_fee = " select * from "+
						"         (select '1' gubun, rent_mng_id, rent_l_cd, fee_tm, rent_st, rent_seq, tm_st1, tm_st2, fee_est_dt, r_fee_est_dt, fee_s_amt, fee_v_amt, rc_yn, rc_dt, rc_amt, dly_days, dly_fee, pay_cng_dt, use_s_dt, use_e_dt, tax_out_dt, 'Y' bill_yn, req_dt, adate, pay_st from scd_fee where rent_l_cd='"+l_cd+"' and fee_est_dt <= '20080720' "+
						"          union all"+
			            "          select '2' gubun, rent_mng_id, rent_l_cd, fee_tm, rent_st, rent_seq, tm_st1, tm_st2, fee_est_dt, r_fee_est_dt, fee_s_amt, fee_v_amt, '0' rc_yn, '' rc_dt, 0 rc_amt, dly_days, dly_fee, pay_cng_dt, use_s_dt, use_e_dt, tax_out_dt, 'N' bill_yn, req_dt, adate, pay_st from scd_fee where rent_l_cd='"+l_cd+"' and fee_est_dt between '20080820' and '20090420' and tm_st1='0' "+
						"          union all"+
			            "          select '3' gubun, rent_mng_id, rent_l_cd, fee_tm, rent_st, rent_seq, tm_st1, tm_st2, fee_est_dt, r_fee_est_dt, fee_s_amt, fee_v_amt, '0' rc_yn, '' rc_dt, 0 rc_amt, dly_days, dly_fee, pay_cng_dt, use_s_dt, use_e_dt, tax_out_dt, 'N' bill_yn, req_dt, adate, pay_st from scd_fee where rent_l_cd='"+l_cd+"' and fee_est_dt > '20090420' and tm_st1='0'"+
						"         ) ";
		
		String sub_query = "";


		if(b_dt.equals("")){
			b_dt = "to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')";
		}else{
			b_dt = "to_date(replace('"+b_dt+"','-',''),'YYYYMMDD')";
		}

		if(mode.equals("ALL")){
			sub_query = " rent_mng_id='"+m_id+"'";
		}else{
			sub_query = " rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"'";
		}
			
		if(!bill_yn.equals("")){
			sub_query += " and nvl(bill_yn,'Y')='"+bill_yn+"'";
		}

		String query = "";
		query = " select"+
				" max(NC) NC, max(NS) NS, max(NV) NV,"+//미수금
				" max(RC) RC, max(RS) RS, max(RV) RV,"+//수금
				" max(MC) MC, max(MS) MS, max(MV) MV,"+//미도래분
				" sum(DC) DC, sum(DT) DT, "+//연체
				" max(DT2) DT2"+//연체-수금
				" from"+
				" ( \n"+
					//미수금
					" select count(0) NC, sum(fee_s_amt) NS, sum(fee_v_amt) NV, 0 RC, 0 RS, 0 RV, 0 MC, 0 MS, 0 MV, 0 DC, 0 DT, 0 DT2"+
					" from ("+scd_fee+")"+
					" where gubun='2' and "+sub_query+
					"  \n union \n"+
					//수금
					" select 0 NC, 0 NS, 0 NV, count(0) RC, sum(trunc(rc_amt/1.1)) RS, sum(rc_amt-trunc(rc_amt/1.1)) RV, 0 MC, 0 MS, 0 MV, 0 DC, 0 DT, 0 DT2"+
					" from ("+scd_fee+")"+
					" where gubun='1' and "+sub_query+
					"  \n union \n"+
					//미도래분
					" select 0 NC, 0 NS, 0 NV, 0 RC, 0 RS, 0 RV, count(0) MC, sum(fee_s_amt) MS, sum(fee_v_amt) MV, 0 DC, 0 DT, 0 DT2"+
					" from ("+scd_fee+")"+
					" where gubun='3' and "+sub_query+
					"  \n union \n"+
					//연체료 0.24
					" select 0 NC, 0 NS, 0 NV, 0 RC, 0 RS, 0 RV, 0 MC, 0 MS, 0 MV, count(0) DC, "+
					"	     sum("+
				    "               (TRUNC(((decode(rc_amt,0,fee_s_amt+fee_v_amt,rc_amt))*0.24*TRUNC(TO_DATE(r_fee_est_dt, 'YYYYMMDD')- NVL(TO_DATE(rc_dt, 'YYYYMMDD'), "+b_dt+")))/365) * -1) "+
					"        ) DT, 0 DT2"+
					" from ("+scd_fee+")"+
					" where rent_mng_id = '"+m_id+"' "+
					" and TRUNC(NVL(TO_DATE(rc_dt, 'YYYYMMDD'), "+b_dt+") - TO_DATE(r_fee_est_dt, 'YYYYMMDD')) > 0 "+
					" and (rent_l_cd, rent_mng_id, rent_st) in (select a.rent_l_cd, a.rent_mng_id, a.rent_st from fee a, cont b, cont_etc c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and decode(c.rent_suc_dt,'',decode(a.rent_st,'1',b.rent_dt,a.rent_dt),c.rent_suc_dt) < '20220101')"+
					"  \n union \n"+
					//연체료 0.20
					" select 0 NC, 0 NS, 0 NV, 0 RC, 0 RS, 0 RV, 0 MC, 0 MS, 0 MV, count(0) DC, "+
					" 	     sum("+
				    "               (TRUNC(((decode(rc_amt,0,fee_s_amt+fee_v_amt,rc_amt))*0.20*TRUNC(TO_DATE(r_fee_est_dt, 'YYYYMMDD')- NVL(TO_DATE(rc_dt, 'YYYYMMDD'), "+b_dt+")))/365) * -1) "+
					"	     ) DT, 0 DT2"+
					" from ("+scd_fee+")"+
					" where rent_mng_id = '"+m_id+"' "+
					" and TRUNC(NVL(TO_DATE(rc_dt, 'YYYYMMDD'), "+b_dt+") - TO_DATE(r_fee_est_dt, 'YYYYMMDD')) > 0 "+
					" and (rent_l_cd, rent_mng_id, rent_st) in (select a.rent_l_cd, a.rent_mng_id, a.rent_st from fee a, cont b, cont_etc c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and decode(c.rent_suc_dt,'',decode(a.rent_st,'1',b.rent_dt,a.rent_dt),c.rent_suc_dt) >= '20220101')"+
					"  \n union \n"+
					//연체료-수금
					" select 0 NC, 0 NS, 0 NV, 0 RC, 0 RS, 0 RV, 0 MC, 0 MS, 0 MV, 0 DC, 0 DT, sum(pay_amt) DT2"+
					" from scd_dly"+
					" where rent_mng_id = '"+m_id+"'"+
				" \n )";
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
			System.out.println("[AddFeeDatabase:getFeeScdStat_S106HTLR00091]\n"+e);
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
	 *	한회차 대여료 update
	 */
	public boolean updateFeeScdTaxoutdt(FeeScdBean fee_scd)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = " update scd_fee set "+
						" TAX_OUT_DT = replace(?, '-', '') "+
						" where "+
						" RENT_MNG_ID = ? and"+
						" RENT_L_CD = ? and"+
						" FEE_TM = ? and"+
						" RENT_ST = ? and"+
						" RENT_SEQ = ? ";

		
		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, fee_scd.getTax_out_dt());
			pstmt.setString(2, fee_scd.getRent_mng_id());
			pstmt.setString(3, fee_scd.getRent_l_cd());
			pstmt.setString(4, fee_scd.getFee_tm());
			pstmt.setString(5, fee_scd.getRent_st());
			pstmt.setString(6, fee_scd.getRent_seq());
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
				
	  	} catch (Exception e) {
			System.out.println("[AddFeeDatabase:updateFeeScdTaxoutdt]\n"+e);
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
	 *	한회차 대여료 update
	 */
	public boolean updateFeeScdReqdt(FeeScdBean fee_scd)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = " update scd_fee set "+
						" REQ_DT	= replace(?, '-', ''), "+
						" R_REQ_DT	= replace(?, '-', '') "+
						" where "+
						" RENT_MNG_ID = ? and"+
						" RENT_L_CD = ? and"+
						" FEE_TM = ? and"+
						" RENT_ST = ? and"+
						" RENT_SEQ = ? ";

		
		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, fee_scd.getReq_dt());
			pstmt.setString(2, fee_scd.getR_req_dt());
			pstmt.setString(3, fee_scd.getRent_mng_id());
			pstmt.setString(4, fee_scd.getRent_l_cd());
			pstmt.setString(5, fee_scd.getFee_tm());
			pstmt.setString(6, fee_scd.getRent_st());
			pstmt.setString(7, fee_scd.getRent_seq());
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
				
	  	} catch (Exception e) {
			System.out.println("[AddFeeDatabase:updateFeeScdReqdt]\n"+e);
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
	 *	기발행 계산서 여부
	 */			
	public int getTaxDtChk(String rent_l_cd, String rent_st, String rent_seq, String fee_tm)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		int chk_cnt = 0;
		String query = "";

		query = " select count(0) "+
				" from tax_item_list a, tax b "+
				" where a.rent_l_cd='"+rent_l_cd+"' and a.rent_st='"+rent_st+"' and a.rent_seq='"+rent_seq+"' and a.tm='"+fee_tm+"' "+
				" and a.item_id=b.item_id and b.tax_st<>'C' ";

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
			if(rs.next())
			{				
				chk_cnt = rs.getInt(1);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getTaxChk]\n"+e);			
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return chk_cnt;
		}	
	}

	/**
	 *	기발행 계산서 여부
	 */			
	public String getTaxItemDtChk(String rent_l_cd, String rent_st, String rent_seq, String fee_tm)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		String item_id = "";
		String query = "";

		query = " select a.item_id from tax_item_list a, tax_item b where a.rent_l_cd='"+rent_l_cd+"' and a.rent_st='"+rent_st+"' and a.rent_seq='"+rent_seq+"' and a.tm='"+fee_tm+"' and a.item_id=b.item_id and nvl(b.use_yn,'Y')='Y' ";

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
			if(rs.next())
			{				
				item_id = rs.getString("item_id")==null?"":rs.getString("item_id");
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getTaxItemDtChk]\n"+e);			
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return item_id;
		}	
	}

	/**	
	 *	대여료메모 delete
	 */
	public boolean deleteFeeMemo(FeeMemoBean fee_mm)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query =  " delete from dly_mm where rent_mng_id=? and rent_l_cd=? and rent_st=? and tm_st1=? and seq=? and fee_tm=?";

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, fee_mm.getRent_mng_id());
			pstmt.setString(2, fee_mm.getRent_l_cd	());
			pstmt.setString(3, fee_mm.getRent_st	());
			pstmt.setString(4, fee_mm.getTm_st1		());
			pstmt.setString(5, fee_mm.getSeq		());
			pstmt.setString(6, fee_mm.getFee_tm		());
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddFeeDatabase:deleteFeeMemo]\n"+e);
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
                if(pstmt != null) pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}	

	/**
	 *	분할청구정보조회
	 */
	public Vector getScdFeeCngContList(String m_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query = " select rent_l_cd from scd_fee where rent_mng_id='"+m_id+"' group by rent_l_cd order by rent_l_cd ";


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
			System.out.println("[AddFeeDatabase:getScdFeeCngContList]\n"+e);
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
	 *	분할청구정보조회
	 */
	public Hashtable getScdFeeCngContA(String m_id, String l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();

		String query =  " select a.cls_st, a.cls_dt, c.firm_nm, d.rent_suc_dt, b.* "+
						" from   cls_cont a, "+
						"        cont b, "+
						"        client c, "+
						"        cont_etc d "+
						" where  a.rent_mng_id='"+m_id+"' and a.rent_l_cd='"+l_cd+"' "+
						" and    a.cls_st in ('4','5') and b.car_st<>'2' "+
						" and    a.rent_mng_id=b.rent_mng_id and a.reg_dt=b.reg_dt "+
						" and    b.client_id=c.client_id"+
						" and    b.rent_mng_id=d.rent_mng_id and b.rent_l_cd=d.rent_l_cd "+
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
			System.out.println("[AddFeeDatabase:getScdFeeCngContA]\n"+e);
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
	 *	한회차 대여료 update  -- 재계약
	 */
	public boolean updateFeeScdCng(FeeScdBean fee_scd, String cng_choice, String cng_rent_l_cd, String cng_rent_st, String cng_tm_st2)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;

		String query = " update scd_fee set ";

		if(cng_choice.equals("1"))		query += " rent_l_cd	='"+cng_rent_l_cd+"'";
		else if(cng_choice.equals("2")) query += " rent_st		='"+cng_rent_st+"'";
		else if(cng_choice.equals("3")) query += " tm_st2		='"+cng_tm_st2+"',		rent_st		='"+cng_rent_st+"'";
		else if(cng_choice.equals("4")) query += " rent_mng_id  ='"+cng_rent_l_cd+"',   rent_l_cd	='"+cng_rent_st+"',     fee_tm	='"+cng_tm_st2+"', rent_st ='1', rent_seq='1', tm_st2='2' ";

		query += 		" where"+
						" RENT_MNG_ID = ? and"+
						" RENT_L_CD = ? and"+
						" FEE_TM = ? and"+
						" RENT_ST = ? and"+		
		                " RENT_SEQ = ? ";		
		                //and"+
						//" TM_ST1 = ? ";	

		String query2 = " update tax_item_list set ";

		if(cng_choice.equals("1"))		query2 += " rent_l_cd	='"+cng_rent_l_cd+"'";
		else if(cng_choice.equals("2")) query2 += " rent_st		='"+cng_rent_st+"'";
		else if(cng_choice.equals("3")) query2 += " rent_st		='"+cng_rent_st+"'";
		else if(cng_choice.equals("4")) query2 += " rent_l_cd	='"+cng_rent_st+"',     tm	='"+cng_tm_st2+"',		rent_st ='1', rent_seq='1'";

		query2 += 		" where"+
						" GUBUN = '1' and"+
						" RENT_L_CD = ? and"+
						" TM = ? and"+
						" RENT_ST = ? and"+
						" RENT_SEQ = ? ";	

		String query3 = " update tax set ";

		if(cng_choice.equals("1"))		query3 += " rent_l_cd	='"+cng_rent_l_cd+"'";
		else if(cng_choice.equals("4")) query3 += " rent_l_cd	='"+cng_rent_st+"',     fee_tm	='"+cng_tm_st2+"' ";

		query3 += 		" where"+
						" GUBUN = '1' and"+
						" RENT_L_CD = ? and"+
						" fee_tm = ? ";


		try {
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, fee_scd.getRent_mng_id());
			pstmt.setString(2, fee_scd.getRent_l_cd());
			pstmt.setString(3, fee_scd.getFee_tm());
			pstmt.setString(4, fee_scd.getRent_st());
			pstmt.setString(5, fee_scd.getRent_seq());
			pstmt.executeUpdate();
			pstmt.close();

			pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString(1, fee_scd.getRent_l_cd());
			pstmt2.setString(2, fee_scd.getFee_tm());
			pstmt2.setString(3, fee_scd.getRent_st());
			pstmt2.setString(4, fee_scd.getRent_seq());
			pstmt2.executeUpdate();
			pstmt2.close();

			if(cng_choice.equals("1") || cng_choice.equals("4")){
				pstmt3 = conn.prepareStatement(query3);
				pstmt3.setString(1, fee_scd.getRent_l_cd());
				pstmt3.setString(2, fee_scd.getFee_tm());
				pstmt3.executeUpdate();
				pstmt3.close();
			}

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[AddFeeDatabase:updateFeeScdCng]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
				if(pstmt2 != null)	pstmt2.close();
				if(pstmt3 != null)	pstmt3.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	/**
	 *	한회차 대여료 update  -- 재계약
	 */
	public boolean updateFeeScdCng(FeeScdBean fee_scd, String cng_choice, String cng_rent_mng_id, String cng_rent_l_cd, String cng_rent_st, String cng_tm_st2)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;

		String query = " update scd_fee set ";

		if(cng_choice.equals("1"))		query += " rent_mng_id	='"+cng_rent_mng_id+"', rent_l_cd	='"+cng_rent_l_cd+"'";
		else if(cng_choice.equals("2")) query += " rent_st		='"+cng_rent_st+"'";
		else if(cng_choice.equals("3")) query += " tm_st2		='"+cng_tm_st2+"',		rent_st		='"+cng_rent_st+"'";
		else if(cng_choice.equals("4")) query += " rent_mng_id  ='"+cng_rent_l_cd+"',   rent_l_cd	='"+cng_rent_st+"',     fee_tm	='"+cng_tm_st2+"', rent_st ='1', rent_seq='1', tm_st2='2' ";

		query += 		" where"+
						" RENT_MNG_ID = ? and"+
						" RENT_L_CD = ? and"+
						" FEE_TM = ? and"+
						" RENT_ST = ? and"+		
		                " RENT_SEQ = ? ";		
		                //and"+
						//" TM_ST1 = ? ";	

		String query2 = " update tax_item_list set ";

		if(cng_choice.equals("1"))		query2 += " rent_l_cd	='"+cng_rent_l_cd+"'";
		else if(cng_choice.equals("2")) query2 += " rent_st		='"+cng_rent_st+"'";
		else if(cng_choice.equals("3")) query2 += " rent_st		='"+cng_rent_st+"'";
		else if(cng_choice.equals("4")) query2 += " rent_l_cd	='"+cng_rent_st+"',     tm	='"+cng_tm_st2+"',		rent_st ='1', rent_seq='1'";

		query2 += 		" where"+
						" GUBUN = '1' and"+
						" RENT_L_CD = ? and"+
						" TM = ? and"+
						" RENT_ST = ? and"+
						" RENT_SEQ = ? ";	

		String query3 = " update tax set ";

		if(cng_choice.equals("1"))		query3 += " rent_l_cd	='"+cng_rent_l_cd+"'";
		else if(cng_choice.equals("4")) query3 += " rent_l_cd	='"+cng_rent_st+"',     fee_tm	='"+cng_tm_st2+"' ";

		query3 += 		" where"+
						" GUBUN = '1' and"+
						" RENT_L_CD = ? and"+
						" fee_tm = ? ";


		try {
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, fee_scd.getRent_mng_id());
			pstmt.setString(2, fee_scd.getRent_l_cd());
			pstmt.setString(3, fee_scd.getFee_tm());
			pstmt.setString(4, fee_scd.getRent_st());
			pstmt.setString(5, fee_scd.getRent_seq());
			pstmt.executeUpdate();
			pstmt.close();

			pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString(1, fee_scd.getRent_l_cd());
			pstmt2.setString(2, fee_scd.getFee_tm());
			pstmt2.setString(3, fee_scd.getRent_st());
			pstmt2.setString(4, fee_scd.getRent_seq());
			pstmt2.executeUpdate();
			pstmt2.close();

			if(cng_choice.equals("1") || cng_choice.equals("4")){
				pstmt3 = conn.prepareStatement(query3);
				pstmt3.setString(1, fee_scd.getRent_l_cd());
				pstmt3.setString(2, fee_scd.getFee_tm());
				pstmt3.executeUpdate();
				pstmt3.close();
			}

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[AddFeeDatabase:updateFeeScdCng]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
				if(pstmt2 != null)	pstmt2.close();
				if(pstmt3 != null)	pstmt3.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	/**
	 *	한회차 대여료 update  -- 재계약
	 */
	public boolean updateFeeScdCng2(FeeScdBean fee_scd, String cng_choice, String cng_rent_l_cd, String cng_rent_st, String cng_tm_st2, String cng_cau)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;

		String query = " update scd_fee set ";

		if(cng_choice.equals("1"))		query += " rent_l_cd	='"+cng_rent_l_cd+"'";
		else if(cng_choice.equals("2")) query += " rent_st		='"+cng_rent_st+"'";
		else if(cng_choice.equals("3")) query += " tm_st2		='"+cng_tm_st2+"',		rent_st		='"+cng_rent_st+"'";
		else if(cng_choice.equals("4")) query += " rent_mng_id  ='"+cng_rent_l_cd+"',   rent_l_cd	='"+cng_rent_st+"',     fee_tm	='"+cng_tm_st2+"', rent_st ='1', rent_seq='1', tm_st2='2', taecha_no='0' ";
		
		query += " , cng_dt=to_char(sysdate,'YYYYMMDD'), cng_cau='"+cng_cau+"' ";

		query += 		" where"+
						" RENT_MNG_ID = ? and"+
						" RENT_L_CD = ? and"+
						" FEE_TM = ? and"+
						" RENT_ST = ? and"+
						" TM_ST1 = ? ";	



		String query2 = " update tax_item_list set ";

		if(cng_choice.equals("1"))		query2 += " rent_l_cd	='"+cng_rent_l_cd+"'";
		else if(cng_choice.equals("2")) query2 += " rent_st		='"+cng_rent_st+"'";
		else if(cng_choice.equals("3")) query2 += " rent_st		='"+cng_rent_st+"'";
		else if(cng_choice.equals("4")) query2 += " rent_l_cd	='"+cng_rent_st+"',     tm	='"+cng_tm_st2+"',		rent_st ='1', rent_seq='1'";

		query2 += 		" where"+
						" GUBUN = '1' and"+
						" RENT_L_CD = ? and"+
						" TM = ? and"+
						" RENT_ST = ? and"+
						" RENT_SEQ = ? ";	

		String query3 = " update tax set ";

		if(cng_choice.equals("1"))		query3 += " rent_l_cd	='"+cng_rent_l_cd+"'";
		else if(cng_choice.equals("4")) query3 += " rent_l_cd	='"+cng_rent_st+"',     fee_tm	='"+cng_tm_st2+"' ";

		query3 += 		" where"+
						" GUBUN = '1' and"+
						" RENT_L_CD = ? and"+
						" fee_tm = ? ";


		try {
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, fee_scd.getRent_mng_id());
			pstmt.setString(2, fee_scd.getRent_l_cd());
			pstmt.setString(3, fee_scd.getFee_tm());
			pstmt.setString(4, fee_scd.getRent_st());
			pstmt.setString(5, fee_scd.getTm_st1());
			pstmt.executeUpdate();
			pstmt.close();

			pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString(1, fee_scd.getRent_l_cd());
			pstmt2.setString(2, fee_scd.getFee_tm());
			pstmt2.setString(3, fee_scd.getRent_st());
			pstmt2.setString(4, fee_scd.getRent_seq());
			pstmt2.executeUpdate();
			pstmt2.close();

			if(cng_choice.equals("1") || cng_choice.equals("4")){
				pstmt3 = conn.prepareStatement(query3);
				pstmt3.setString(1, fee_scd.getRent_l_cd());
				pstmt3.setString(2, fee_scd.getFee_tm());
				pstmt3.executeUpdate();
				pstmt3.close();
			}

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[AddFeeDatabase:updateFeeScdCng]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
				if(pstmt2 != null)	pstmt2.close();
				if(pstmt3 != null)	pstmt3.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}	

	/**
	 *	회차번호 늘리기
	 */
	public boolean updateFeeScdTmAdd(FeeScdBean fee_scd)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query = " update scd_fee set fee_tm=to_number(fee_tm)+1 ";
		query += 		" where"+
						" RENT_MNG_ID		= '"+fee_scd.getRent_mng_id()+"'"+
						" and RENT_L_CD		= '"+fee_scd.getRent_l_cd()+"'	"+
						" and FEE_TM		>= "+fee_scd.getFee_tm()+"		"+
						" ";	

		try {
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[AddFeeDatabase:updateFeeScdTmAdd]\n"+e);
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
	 *	대여스케줄 임의연장 등록
	 */
	public String insertFeeIm(FeeImBean im)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		Statement stmt = null;
		ResultSet rs = null;
		String s_seq = "";
		String query = "";

		String query_id = " select nvl(ltrim(to_char(to_number(MAX(im_seq))+1, '00')), '01') ID from FEE_IM where rent_mng_id='"+im.getRent_mng_id()+"' and rent_l_cd='"+im.getRent_l_cd()+"' and rent_st='"+im.getRent_st()+"'";

		query = " insert into FEE_IM (RENT_MNG_ID, RENT_L_CD, RENT_ST, IM_SEQ, ADD_TM, "+
				"                     RENT_START_DT, RENT_END_DT, F_USE_START_DT, F_USE_END_DT, "+
				"                     F_REQ_DT, F_TAX_DT, F_EST_DT, REG_ID, REG_DT, fee_s_amt, fee_v_amt )"+
				" values ("+
				" ?, ?, ?, ?, ?,"+
				" replace(?, '-', ''), replace(?, '-', ''), replace(?, '-', ''), replace(?, '-', ''), "+
				" replace(?, '-', ''), replace(?, '-', ''), replace(?, '-', ''), ?, to_char(sysdate,'YYYYMMDD'), ?, ? )";
		try 
		{
			conn.setAutoCommit(false);

			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query_id);
			if(rs.next())
			{
				s_seq = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			stmt.close();


			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, im.getRent_mng_id	());
			pstmt.setString(2, im.getRent_l_cd		());
			pstmt.setString(3, im.getRent_st		());
			pstmt.setString(4, s_seq				  );
			pstmt.setString(5, im.getAdd_tm			());
			pstmt.setString(6, im.getRent_start_dt	());
			pstmt.setString(7, im.getRent_end_dt	());
			pstmt.setString(8, im.getF_use_start_dt	());
			pstmt.setString(9, im.getF_use_end_dt	());
			pstmt.setString(10,im.getF_req_dt		());
			pstmt.setString(11,im.getF_tax_dt		());
			pstmt.setString(12,im.getF_est_dt		());
			pstmt.setString(13,im.getReg_id			());
			pstmt.setInt   (14,im.getFee_s_amt		());
			pstmt.setInt   (15,im.getFee_v_amt		());

			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[AddFeeDatabase:insertFeeIm]\n"+e);

			System.out.println("[im.getRent_mng_id		()]\n"+im.getRent_mng_id	());
			System.out.println("[im.getRent_l_cd		()]\n"+im.getRent_l_cd		());
			System.out.println("[im.getRent_st			()]\n"+im.getRent_st		());
			System.out.println("[s_seq					  ]\n"+s_seq				  );
			System.out.println("[im.getAdd_tm			()]\n"+im.getAdd_tm			());
			System.out.println("[im.getRent_start_dt	()]\n"+im.getRent_start_dt	());
			System.out.println("[im.getRent_end_dt		()]\n"+im.getRent_end_dt	());
			System.out.println("[im.getF_use_start_dt	()]\n"+im.getF_use_start_dt	());
			System.out.println("[im.getF_use_end_dt		()]\n"+im.getF_use_end_dt	());
			System.out.println("[im.getF_req_dt			()]\n"+im.getF_req_dt		());
			System.out.println("[im.getF_tax_dt			()]\n"+im.getF_tax_dt		());
			System.out.println("[im.getF_est_dt			()]\n"+im.getF_est_dt		());
			System.out.println("[im.getReg_id			()]\n"+im.getReg_id			());

			e.printStackTrace();
	  		flag = false;
			s_seq = "";
			conn.rollback();
		} finally {
			try{	
				if(rs != null)	rs.close();
				if(stmt != null)	stmt.close();
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return s_seq;
		}
	}

	/**
	 *	임의연장 조회
	 */
	public FeeImBean getFeeIm(String doc_no)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		FeeImBean bean = new FeeImBean();
		String query = "";

		query = " select * from fee_im where rent_l_cd||rent_st||im_seq='"+doc_no+"' ";


		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			if(rs.next())
			{				
				bean.setRent_mng_id		(rs.getString(1) ==null?"":rs.getString(1));
				bean.setRent_l_cd		(rs.getString(2) ==null?"":rs.getString(2));
				bean.setRent_st			(rs.getString(3) ==null?"":rs.getString(3));
				bean.setIm_seq			(rs.getString(4) ==null?"":rs.getString(4));
				bean.setAdd_tm			(rs.getString(5) ==null?"":rs.getString(5));
				bean.setRent_start_dt	(rs.getString(6) ==null?"":rs.getString(6));
				bean.setRent_end_dt		(rs.getString(7) ==null?"":rs.getString(7));
				bean.setF_use_start_dt	(rs.getString(8) ==null?"":rs.getString(8));
				bean.setF_use_end_dt	(rs.getString(9) ==null?"":rs.getString(9));			
				bean.setF_req_dt		(rs.getString(10)==null?"":rs.getString(10));
				bean.setF_tax_dt		(rs.getString(11)==null?"":rs.getString(11));
				bean.setF_est_dt		(rs.getString(12)==null?"":rs.getString(12));			
				bean.setReg_dt			(rs.getString(13)==null?"":rs.getString(13));
				bean.setReg_id			(rs.getString(14)==null?"":rs.getString(14));
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getFeeIm]\n"+e);
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
	 *	임의연장 조회 백터
	 */
	public Vector getFeeImVector(String rent_mng_id, String rent_l_cd, String rent_st, String im_seq)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();


		String query = "";

		query = "select a.* from fee_im a, (SELECT rent_mng_id, rent_l_cd, MAX(im_seq) AS im_seq FROM fee_im where rent_mng_id='"+rent_mng_id+"' and rent_l_cd='"+rent_l_cd+"' GROUP BY rent_mng_id, rent_l_cd ) b where a.im_seq = b.im_seq(+) and a.rent_mng_id='"+rent_mng_id+"' and a.rent_l_cd='"+rent_l_cd+"'  order by a.im_seq ";


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
			System.out.println("[AddFeeDatabase:getFeeImVector]\n"+e);
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
	 *	임의연장 조회
	 */
	public FeeImBean getFeeIm(String rent_mng_id, String rent_l_cd, String rent_st, String im_seq)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		FeeImBean bean = new FeeImBean();
		String query = "";

//		query = " select * from fee_im where rent_mng_id='"+rent_mng_id+"' and rent_l_cd='"+rent_l_cd+"' /* and rent_st='"+rent_st+"'  and im_seq='"+im_seq+"' */ ";

		query = "select a.* from fee_im a, (SELECT rent_mng_id, rent_l_cd, MAX(im_seq) AS im_seq FROM fee_im where rent_mng_id='"+rent_mng_id+"' and rent_l_cd='"+rent_l_cd+"' GROUP BY rent_mng_id, rent_l_cd ) b where a.im_seq = b.im_seq(+) and a.rent_mng_id='"+rent_mng_id+"' and a.rent_l_cd='"+rent_l_cd+"' ";



		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			if(rs.next())
			{				
				bean.setRent_mng_id		(rs.getString(1) ==null?"":rs.getString(1));
				bean.setRent_l_cd		(rs.getString(2) ==null?"":rs.getString(2));
				bean.setRent_st			(rs.getString(3) ==null?"":rs.getString(3));
				bean.setIm_seq			(rs.getString(4) ==null?"":rs.getString(4));
				bean.setAdd_tm			(rs.getString(5) ==null?"":rs.getString(5));
				bean.setRent_start_dt	(rs.getString(6) ==null?"":rs.getString(6));
				bean.setRent_end_dt		(rs.getString(7) ==null?"":rs.getString(7));
				bean.setF_use_start_dt	(rs.getString(8) ==null?"":rs.getString(8));
				bean.setF_use_end_dt	(rs.getString(9) ==null?"":rs.getString(9));			
				bean.setF_req_dt		(rs.getString(10)==null?"":rs.getString(10));
				bean.setF_tax_dt		(rs.getString(11)==null?"":rs.getString(11));
				bean.setF_est_dt		(rs.getString(12)==null?"":rs.getString(12));			
				bean.setReg_dt			(rs.getString(13)==null?"":rs.getString(13));
				bean.setReg_id			(rs.getString(14)==null?"":rs.getString(14));
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getFeeIm(String rent_mng_id, String rent_l_cd, String rent_st, String im_seq)]\n"+e);
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
	 *	임의연장스케줄 청구 정상처리
	 */
	public boolean updateFeeImScdBillYn(String doc_no)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query =  " update scd_fee set bill_yn='Y' where pay_cng_cau like '%임의연장"+doc_no+"%' and bill_yn='I'";

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
		} catch (Exception e) {
			System.out.println("[AddFeeDatabase:updateFeeImScdBillYn]\n"+e);
			System.out.println("[AddFeeDatabase:updateFeeImScdBillYn]\n"+query);
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
                if(pstmt != null) pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}	

	/**
	 *	사용일수 구하기
	 */
	public Hashtable getUseMonDay(String e_dt, String s_dt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();

		String query = "SELECT "+
					" decode( sign(to_date(substr(replace('"+ e_dt +"','-',''),1,8), 'YYYYMMDD') - to_date(substr(replace('"+ s_dt +"','-',''),1,8), 'YYYYMMDD')), -1, '0', trunc(months_between(to_date(substr(replace('"+ e_dt +"','-',''),1,8), 'YYYYMMDD')+1, to_date(substr(replace('"+ s_dt +"','-',''),1,8), 'YYYYMMDD')))) u_mon, "+
					" decode( sign(to_date(substr(replace('"+ e_dt +"','-',''),1,8), 'YYYYMMDD') - to_date(substr(replace('"+ s_dt +"','-',''),1,8), 'YYYYMMDD')), -1, '0', trunc(to_date(substr(replace('"+ e_dt +"','-',''),1,8), 'YYYYMMDD')+1-add_months(to_date(substr(replace('"+ s_dt +"','-',''),1,8), 'YYYYMMDD'), trunc(months_between(to_date(substr(replace('"+ e_dt +"','-',''),1,8), 'YYYYMMDD')+1, to_date(substr(replace('"+ s_dt +"','-',''),1,8), 'YYYYMMDD')))))) u_day "+
					" FROM DUAL ";

		try {

			if(AddUtil.checkDate(e_dt) && AddUtil.checkDate(s_dt)){
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
			}
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getUseMonDay]\n"+e);
			System.out.println("[AddFeeDatabase:getUseMonDay]\n"+query);
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
	 *	사용일수 구하기
	 */
	public Hashtable getUseMonDay2(String e_dt, String s_dt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();

		String query = "SELECT "+
					" decode( sign(to_date(substr(replace('"+ e_dt +"','-',''),1,8), 'YYYYMMDD') - to_date(substr(replace('"+ s_dt +"','-',''),1,8), 'YYYYMMDD')), -1, '0', trunc(months_between(to_date(substr(replace('"+ e_dt +"','-',''),1,8), 'YYYYMMDD'), to_date(substr(replace('"+ s_dt +"','-',''),1,8), 'YYYYMMDD')))) u_mon, "+
					" decode( sign(to_date(substr(replace('"+ e_dt +"','-',''),1,8), 'YYYYMMDD') - to_date(substr(replace('"+ s_dt +"','-',''),1,8), 'YYYYMMDD')), -1, '0', trunc(to_date(substr(replace('"+ e_dt +"','-',''),1,8), 'YYYYMMDD')-add_months(to_date(substr(replace('"+ s_dt +"','-',''),1,8), 'YYYYMMDD'), trunc(months_between(to_date(substr(replace('"+ e_dt +"','-',''),1,8), 'YYYYMMDD'), to_date(substr(replace('"+ s_dt +"','-',''),1,8), 'YYYYMMDD')))))) u_day "+
					" FROM DUAL ";

		try {

			if(AddUtil.checkDate(e_dt) && AddUtil.checkDate(s_dt)){
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
			}
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getUseMonDay2]\n"+e);
			System.out.println("[AddFeeDatabase:getUseMonDay2]\n"+query);
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
	 *	임의연장조회
	 */
	public Vector getFeeImList(String rent_mng_id, String rent_l_cd, String rent_st)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query =  " select b.user_nm, a.* "+
						" from   fee_im a, users b "+
						" where  a.rent_mng_id='"+rent_mng_id+"' and a.rent_l_cd='"+rent_l_cd+"' "+
						" and    a.reg_id=b.USER_ID ";

		if(!rent_st.equals(""))		query += " and a.rent_st='"+rent_st+"' ";

		query += " order by a.reg_dt ";


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
			System.out.println("[AddFeeDatabase:getFeeImList]\n"+e);
			System.out.println("[AddFeeDatabase:getFeeImList]\n"+query);
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

	//차량대금 지출문서관리 리스트 조회
	public Vector getFeeScdCngMngList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select c.firm_nm, d.car_no, d.car_mng_id, e.user_nm, f.rent_st, f.rent_seq, e2.user_nm as bus_nm2, a.* \n"+
				" from   scd_fee_cng a, cont b, client c, car_reg d, users e, (select * from scd_fee where tm_st1='0') f, users e2 \n"+
				" where  \n"+ 
				"        a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				" and    b.client_id=c.client_id \n"+
				" and    b.car_mng_id=d.car_mng_id(+) \n"+
				" and    a.cng_id=e.user_id  \n"+
				" and    b.bus_id2=e2.user_id  \n"+
				" and    a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd and a.fee_tm=f.fee_tm "+
				" ";
			

		String what = "";
		String dt1 = "";
		String dt2 = "";

		dt1 = "to_char(a.cng_dt,'YYYYMM')";
		dt2 = "to_char(a.cng_dt,'YYYYMMDD')";


		if(gubun2.equals("1"))			query += " and "+dt1+" = to_char(sysdate,'YYYYMM')";
		else if(gubun2.equals("3"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("4"))		query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";
		else if(gubun2.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		if(s_kd.equals("1"))	what = "upper(nvl(c.firm_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(d.car_no, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(a.rent_l_cd, ' '))";	
		if(s_kd.equals("4"))	what = "upper(nvl(e2.user_nm, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(e.user_nm, ' '))";	
		if(s_kd.equals("6"))	what = "upper(nvl(a.gubun, ' '))";	
		if(s_kd.equals("7"))	what = "upper(nvl(a.cng_cau, ' '))";	
			
		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}else{

		}	
		
		query += " order by a.cng_dt";

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
			System.out.println("[AddFeeDatabase:getFeeScdCngMngList]\n"+e);
			System.out.println("[AddFeeDatabase:getFeeScdCngMngList]\n"+query);
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
	 *	공급가계산하기
	 */			
	public int getAccountSamt(int fee_amt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		int s_amt = 0;
		String query = "";

		query = " select trunc("+fee_amt+"/1.1) amt from dual";

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
			if(rs.next())
			{				
				s_amt = rs.getInt(1);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getAccountSamt]\n"+e);			
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return s_amt;
		}	
	}

	/**
	 *	스케줄 변경이력 리스트
	 */
	public FeeScdCngBean getFeeScdCngCase(String m_id, String l_cd, String cng_dt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		FeeScdCngBean fee_scd = new FeeScdCngBean();
		String query = "";

		query = " select rent_mng_id, rent_l_cd, fee_tm, all_st, gubun, b_value, a_value,"+
				"        to_char(cng_dt,'YYYYMMDDhh24miss') cng_dt, "+
				"        cng_cau, cng_id"+
				" from   scd_fee_cng where rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"' "+
				"        and to_char(cng_dt,'YYYYMMDDhh24miss')='"+cng_dt+"' "+
				" ";

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			if(rs.next())
			{				
				fee_scd.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_scd.setAll_st(rs.getString("all_st")==null?"":rs.getString("all_st"));
				fee_scd.setGubun(rs.getString("gubun")==null?"":rs.getString("gubun"));
				fee_scd.setB_value(rs.getString("b_value")==null?"":rs.getString("b_value"));
				fee_scd.setA_value(rs.getString("a_value")==null?"":rs.getString("a_value"));
				fee_scd.setCng_dt(rs.getString("cng_dt")==null?"":rs.getString("cng_dt"));
				fee_scd.setCng_cau(rs.getString("cng_cau")==null?"":rs.getString("cng_cau"));
				fee_scd.setCng_id(rs.getString("cng_id")==null?"":rs.getString("cng_id"));
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getFeeScdCngCase]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return fee_scd;
		}
	}

	/**
	 *	스케줄 변경이력 리스트
	 */
	public FeeScdCngBean getFeeScdCngCase(String m_id, String l_cd, String cng_dt, String cng_cau)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		FeeScdCngBean fee_scd = new FeeScdCngBean();
		String query = "";

		query = " select rent_mng_id, rent_l_cd, fee_tm, all_st, gubun, b_value, a_value,"+
				"        to_char(cng_dt,'YYYYMMDDhh24miss') cng_dt, "+
				"        cng_cau, cng_id"+
				" from   scd_fee_cng where rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"' "+
				"        and cng_cau='"+cng_cau+"' "+
				" ";

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			if(rs.next())
			{				
				fee_scd.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_scd.setAll_st(rs.getString("all_st")==null?"":rs.getString("all_st"));
				fee_scd.setGubun(rs.getString("gubun")==null?"":rs.getString("gubun"));
				fee_scd.setB_value(rs.getString("b_value")==null?"":rs.getString("b_value"));
				fee_scd.setA_value(rs.getString("a_value")==null?"":rs.getString("a_value"));
				fee_scd.setCng_dt(rs.getString("cng_dt")==null?"":rs.getString("cng_dt"));
				fee_scd.setCng_cau(rs.getString("cng_cau")==null?"":rs.getString("cng_cau"));
				fee_scd.setCng_id(rs.getString("cng_id")==null?"":rs.getString("cng_id"));
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getFeeScdCngCase]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return fee_scd;
		}
	}

	/**
	 *	스케줄변경이력 삭제
	 */ 
	public boolean dropFeeScdCngCase(String m_id, String l_cd, String cng_dt)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query = " delete from scd_fee_cng"+
						" where RENT_MNG_ID=? and RENT_L_CD=? and to_char(cng_dt,'YYYYMMDDhh24miss')=? ";

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1 , m_id		);
			pstmt.setString(2 , l_cd		);
			pstmt.setString(3 , cng_dt		);
			pstmt.executeUpdate();
			pstmt.close();
		    
			conn.commit();

		} catch (Exception e) {
			System.out.println("[AddFeeDatabase:dropFeeScdCngCase]\n"+e);
			System.out.println("[m_id		]\n"+m_id		);
			System.out.println("[l_cd		]\n"+l_cd		);
			System.out.println("[cng_dt		]\n"+cng_dt		);
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
	 *	대여스케줄 변경이력 등록
	 */
	public boolean updateFeeScdCngCase(FeeScdCngBean scd_cng)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";

		query = " update SCD_FEE_CNG set CNG_CAU=? where RENT_MNG_ID=? and RENT_L_CD=? and to_char(cng_dt,'YYYYMMDDhh24miss')=? ";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, scd_cng.getCng_cau()		);
			pstmt.setString(2, scd_cng.getRent_mng_id()	);
			pstmt.setString(3, scd_cng.getRent_l_cd()	);
			pstmt.setString(4, scd_cng.getCng_dt()		);
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[AddFeeDatabase:updateFeeScdCngCase]\n"+e);

			System.out.println("[scd_cng.getRent_mng_id()	]\n"+scd_cng.getRent_mng_id()	);
			System.out.println("[scd_cng.getRent_l_cd()		]\n"+scd_cng.getRent_l_cd()		);
			System.out.println("[scd_cng.getCng_cau()		]\n"+scd_cng.getCng_cau()		);
			System.out.println("[scd_cng.getCng_dt()		]\n"+scd_cng.getCng_dt()		);

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
	 *	스케줄 변경시 잔액분 조회
	 */
	public Vector getScdScdBalance(FeeScdBean o_fee_scd)
	{
		getConnection();
		Vector vt = new Vector();
		Statement stmt = null;
		ResultSet rs = null;
		String query = "";
		query = " select"+
				" RENT_MNG_ID, RENT_L_CD, FEE_TM, RENT_ST, RENT_SEQ, TM_ST1, TM_ST2,"+
				" substr(FEE_EST_DT, 1, 4) || '-' || substr(FEE_EST_DT, 5, 2) || '-'||substr(FEE_EST_DT, 7, 2) FEE_EST_DT,"+
				" FEE_S_AMT, FEE_V_AMT, RC_YN,"+
				" substr(RC_DT, 1, 4) || '-' || substr(RC_DT, 5, 2) || '-'||substr(RC_DT, 7, 2) RC_DT,"+
				" RC_AMT, DLY_DAYS, DLY_FEE,"+
				" substr(PAY_CNG_DT, 1, 4) || '-' || substr(PAY_CNG_DT, 5, 2) || '-'||substr(PAY_CNG_DT, 7, 2) PAY_CNG_DT,"+
				" PAY_CNG_CAU,"+
				" substr(R_FEE_EST_DT, 1, 4) || '-' || substr(R_FEE_EST_DT, 5, 2) || '-'||substr(R_FEE_EST_DT, 7, 2) R_FEE_EST_DT,"+
				" substr(REQ_DT, 1, 4) || '-' || substr(REQ_DT, 5, 2) || '-'||substr(REQ_DT, 7, 2) REQ_DT,"+
				" substr(R_REQ_DT, 1, 4) || '-' || substr(R_REQ_DT, 5, 2) || '-'||substr(R_REQ_DT, 7, 2) R_REQ_DT,"+
				" substr(TAX_OUT_DT, 1, 4) || '-' || substr(TAX_OUT_DT, 5, 2) || '-'||substr(TAX_OUT_DT, 7, 2) TAX_OUT_DT,"+
				" substr(USE_S_DT, 1, 4) || '-' || substr(USE_S_DT, 5, 2) || '-'||substr(USE_S_DT, 7, 2) USE_S_DT,"+
				" substr(USE_E_DT, 1, 4) || '-' || substr(USE_E_DT, 5, 2) || '-'||substr(USE_E_DT, 7, 2) USE_E_DT,"+
				" ADATE, PAY_ST, EXT_DT, incom_dt, incom_seq "+
				" from   scd_fee "+
				" where  tm_st1<>'0' "+
				"        and RENT_MNG_ID	= '"+o_fee_scd.getRent_mng_id()+"'	"+
				"        and RENT_L_CD		= '"+o_fee_scd.getRent_l_cd()+"'	"+
				"        and fee_tm			= '"+o_fee_scd.getFee_tm()+"'		"+
//				"        and tm_st2			= '"+o_fee_scd.getTm_st2()+"'		"+
				"        and rent_st		= '"+o_fee_scd.getRent_st()+"'		"+
				"        and rent_seq		= '"+o_fee_scd.getRent_seq()+"'		"+
				" ";
				
		query += " order by to_number(tm_st1)";


		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
   			int i = 0;
			while(rs.next())
			{
				FeeScdBean fee_scd = new FeeScdBean();				
				fee_scd.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_scd.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_scd.setRent_seq(rs.getString("RENT_SEQ")==null?"":rs.getString("RENT_SEQ"));
				fee_scd.setTm_st1(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				fee_scd.setTm_st2(rs.getString("TM_ST2")==null?"":rs.getString("TM_ST2"));
				fee_scd.setFee_est_dt(rs.getString("FEE_EST_DT")==null?"":rs.getString("FEE_EST_DT"));
				fee_scd.setFee_s_amt(rs.getString("FEE_S_AMT")==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee_scd.setFee_v_amt(rs.getString("FEE_V_AMT")==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee_scd.setRc_yn(rs.getString("RC_YN")==null?"":rs.getString("RC_YN"));
				fee_scd.setRc_dt(rs.getString("RC_DT")==null?"":rs.getString("RC_DT"));
				fee_scd.setRc_amt(rs.getString("RC_AMT")==null?0:Integer.parseInt(rs.getString("RC_AMT")));
				fee_scd.setDly_days(rs.getString("DLY_DAYS")==null?"":rs.getString("DLY_DAYS"));
				fee_scd.setDly_fee(rs.getString("DLY_FEE")==null?0:Integer.parseInt(rs.getString("DLY_FEE")));
				fee_scd.setPay_cng_dt(rs.getString("PAY_CNG_DT")==null?"":rs.getString("PAY_CNG_DT"));
				fee_scd.setPay_cng_cau(rs.getString("PAY_CNG_CAU")==null?"":rs.getString("PAY_CNG_CAU"));
				fee_scd.setR_fee_est_dt(rs.getString("R_FEE_EST_DT")==null?"":rs.getString("R_FEE_EST_DT"));
				fee_scd.setExt_dt(rs.getString("EXT_DT")==null?"":rs.getString("EXT_DT"));
				fee_scd.setReq_dt(rs.getString("REQ_DT")==null?"":rs.getString("REQ_DT"));
				fee_scd.setR_req_dt(rs.getString("R_REQ_DT")==null?"":rs.getString("R_REQ_DT"));
				fee_scd.setTax_out_dt(rs.getString("TAX_OUT_DT")==null?"":rs.getString("TAX_OUT_DT"));
				fee_scd.setUse_s_dt(rs.getString("USE_S_DT")==null?"":rs.getString("USE_S_DT"));
				fee_scd.setUse_e_dt(rs.getString("USE_E_DT")==null?"":rs.getString("USE_E_DT"));
				fee_scd.setAdate(rs.getString("ADATE")==null?"":rs.getString("ADATE"));
				fee_scd.setPay_st(rs.getString("PAY_ST")==null?"":rs.getString("PAY_ST"));
				fee_scd.setIncom_dt(rs.getString("INCOM_DT")==null?"":rs.getString("INCOM_DT"));
				fee_scd.setIncom_seq(rs.getString("INCOM_SEQ")==null?0:Integer.parseInt(rs.getString("INCOM_SEQ")));

				vt.add(i, fee_scd);
				i++;
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getScdGroupCngNew]\n"+e);
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
	 *	대여료스케줄 조회 화면 펼쳐질때 호출. 연체료/일 계산 : 20220101기준 연체료 변경 적용
	 */
	public boolean calDelayDtPrintError(String m_id, String l_cd, String cls_dt, String rent_dt)
	{
		getConnection();
		boolean flag = true;
		Statement stmt1 = null;
		Statement stmt2 = null;
		Statement stmt3 = null;

		String today = "to_char(sysdate,'YYYYMMDD')";
		//if(!cls_dt.equals("")) today = "replace('"+cls_dt+"','-','')";

		String today2 = "SYSDATE";
		//if(!cls_dt.equals("")) today2 = "TO_DATE(replace('"+cls_dt+"','-',''), 'YYYYMMDD')";

		String dly_per = "0.24";


		//연체일 있는 경우(입금:입금일>입금예정일, 미입금:현재날자>입금예정일)
		String query1 = " UPDATE SCD_FEE SET"+
						" dly_days = TRUNC(NVL(TO_DATE(rc_dt, 'YYYYMMDD'), "+today2+") - TO_DATE(r_fee_est_dt, 'YYYYMMDD')),"+
						" dly_fee = (TRUNC(((decode(rc_amt,0,fee_s_amt+fee_v_amt,rc_amt))*"+dly_per+"*TRUNC(TO_DATE(r_fee_est_dt, 'YYYYMMDD')- NVL(TO_DATE(rc_dt, 'YYYYMMDD'), "+today2+")))/365) * -1)"+
						" WHERE rent_mng_id = '"+m_id+"' "+
						" and nvl(rc_dt,"+today+") > r_fee_est_dt and fee_s_amt>0 and bill_yn='Y' "+
						" and (rent_l_cd, rent_mng_id, rent_st) in (select a.rent_l_cd, a.rent_mng_id, a.rent_st from fee a, cont b, cont_etc c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and decode(c.rent_suc_dt,'',decode(a.rent_st,'1',b.rent_dt,a.rent_dt),c.rent_suc_dt) < '20220101')" ;

		dly_per = "0.20";

		//연체일 있는 경우(입금:입금일>입금예정일, 미입금:현재날자>입금예정일)
		String query2 = " UPDATE SCD_FEE SET"+
						" dly_days = TRUNC(NVL(TO_DATE(rc_dt, 'YYYYMMDD'), "+today2+") - TO_DATE(r_fee_est_dt, 'YYYYMMDD')),"+
						" dly_fee = (TRUNC(((decode(rc_amt,0,fee_s_amt+fee_v_amt,rc_amt))*"+dly_per+"*TRUNC(TO_DATE(r_fee_est_dt, 'YYYYMMDD')- NVL(TO_DATE(rc_dt, 'YYYYMMDD'), "+today2+")))/365) * -1)"+
						" WHERE rent_mng_id = '"+m_id+"' "+
						" and nvl(rc_dt,"+today+") > r_fee_est_dt and fee_s_amt>0 and bill_yn='Y'  "+
						" and (rent_l_cd, rent_mng_id, rent_st) in (select a.rent_l_cd, a.rent_mng_id, a.rent_st from fee a, cont b, cont_etc c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and decode(c.rent_suc_dt,'',decode(a.rent_st,'1',b.rent_dt,a.rent_dt),c.rent_suc_dt) >= '20220101')" ;

		//연체일 없는 경우(입금:입금일=입금예정일, 입금일<입금예정일(선수), 미입금:현재날짜<입금예정일)
		String query3 = " UPDATE SCD_FEE set"+
						" dly_days = '0',"+
						" dly_fee = 0"+
						" WHERE rent_mng_id = '"+m_id+"' "+
						" and nvl(rc_dt,"+today+") <= r_fee_est_dt";

		try 
		{
			conn.setAutoCommit(false);

			stmt1 = conn.createStatement();
		    stmt1.executeUpdate(query1);
			stmt1.close();

			stmt2 = conn.createStatement();
		    stmt2.executeUpdate(query2);
			stmt2.close();

			stmt3 = conn.createStatement();
		    stmt3.executeUpdate(query3);
			stmt3.close();

			conn.commit();
		    

		} catch (Exception e) {
			System.out.println("[AddFeeDatabase:calDelayDtPrintError]\n"+e);			
			System.out.println("[AddFeeDatabase:calDelayDtPrintError]\n"+query1);			
			System.out.println("[AddFeeDatabase:calDelayDtPrintError]\n"+query2);			
			System.out.println("[AddFeeDatabase:calDelayDtPrintError]\n"+query3);			
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(stmt1 != null)	stmt1.close();
				if(stmt2 != null)	stmt2.close();
				if(stmt3 != null)	stmt3.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	/**
	 *	합계금액으로 공급가 구하기
	 */
	public int getAccountSupplyAmt(int h_amt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		String query = "";
		int s_amt = 0;

		query = " SELECT trunc("+h_amt+"/1.1) as s_amt FROM dual ";

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			if(rs.next())
			{				
				s_amt	= rs.getInt(1);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getAccountSupplyAmt]\n"+e);
			System.out.println("[AddFeeDatabase:getAccountSupplyAmt]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return s_amt;
		}
	}

	/**
	 *	대여료 채권문자발송에서 고객별 계약리스트조회 - 연체료세팅관련
	 */
	public Vector getFeeDlyContViewClientList(String client_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.rent_mng_id, a.rent_l_cd, a.rent_dt, nvl(b.cls_dt,to_char(sysdate,'YYYYMMDD')) cls_dt "+
				" from   cont a, cls_cont b"+
				" where  a.client_id='"+client_id+"' and a.use_yn='Y' and a.rent_mng_id=b.rent_mng_id(+) and a.rent_l_cd=b.rent_l_cd(+) "+
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
			System.out.println("[AddFeeDatabase:getFeeDlyContViewClientList]\n"+e);
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
	 *	대여스케줄 - 계약승계시 일자계산 발생할 경우 회차추가 준비
	 */
	public boolean updateFeeScdTmAddCase(FeeScdBean scd_fee)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";

		query = " update scd_fee set fee_tm=fee_tm+1"+
						" where rent_mng_id=? and rent_l_cd=? and rent_st=? and rent_seq=? and tm_st1=? and to_number(fee_tm) > to_number(?)";



		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, scd_fee.getRent_mng_id	());
			pstmt.setString(2, scd_fee.getRent_l_cd		());
			pstmt.setString(3, scd_fee.getRent_st		());
			pstmt.setString(4, scd_fee.getRent_seq		());
			pstmt.setString(5, scd_fee.getTm_st1		());
			pstmt.setString(6, scd_fee.getFee_tm		());
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[AddFeeDatabase:updateFeeScdTmAddCase]\n"+e);
			System.out.println("[scd_fee.getRent_mng_id		()]\n"+scd_fee.getRent_mng_id	());
			System.out.println("[scd_fee.getRent_l_cd		()]\n"+scd_fee.getRent_l_cd		());
			System.out.println("[scd_fee.getRent_st			()]\n"+scd_fee.getRent_st		());
			System.out.println("[scd_fee.getRent_seq		()]\n"+scd_fee.getRent_seq		());
			System.out.println("[scd_fee.getTm_st1			()]\n"+scd_fee.getTm_st1		());
			System.out.println("[scd_fee.getFee_tm			()]\n"+scd_fee.getFee_tm		());

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
	 *	회차별 잔액여부 구하기
	 */
	public int getFeeTmJanAmt(String rent_mng_id, String rent_l_cd, String rent_st, String rent_seq, String fee_tm)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		String query = "";
		int s_amt = 0;

		query = " SELECT fee_s_amt FROM scd_fee "+
				" where  rent_mng_id='"+rent_mng_id+"' and rent_l_cd='"+rent_l_cd+"' and rent_st='"+rent_st+"' and rent_seq='"+rent_seq+"' and fee_tm='"+fee_tm+"' "+
				"        and tm_st1<>'0' and rc_dt is null";

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			if(rs.next())
			{				
				s_amt	= rs.getInt(1);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getFeeTmJanAmt]\n"+e);
			System.out.println("[AddFeeDatabase:getFeeTmJanAmt]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return s_amt;
		}
	}

public Hashtable sklist(String m_id, String l_cd, String c_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		String query = "";
		Hashtable ht = new Hashtable();
	
		query = " select b.car_doc_no, a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.firm_nm, b.car_no from cont_n_view a, car_reg b  where  a.car_mng_id = b.car_mng_id and a.rent_mng_id = '"+m_id+"' and a.rent_l_cd = '"+l_cd+"' and a.car_mng_id = '"+c_id+"'";
		

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
			System.out.println("[AddFeeDatabase:sklist]\n"+e);
			System.out.println("[AddFeeDatabase:sklist]\n"+query);			
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
	 *	스케쥴 생성 후 계약서에 붙일 라벨출력 - 2012.07.17 최종수정.
	 */
	public Vector Label_fee_scd_list(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = " SELECT a.*, b.car_mng_id, cr.CAR_DOC_NO, b.FIRM_NM, cr.CAR_NO, b.rent_start_dt, b.rent_dt, b.rent_end_dt, cr.car_nm, TO_CHAR(a.CNG_DT, 'YYYYMMDD') AS cngdt  "+
				"  FROM SCD_FEE_CNG a, CONT_N_VIEW b, car_reg cr,  (SELECT * FROM SCD_FEE WHERE tm_st1='0' ) c "+
				" WHERE a.RENT_MNG_ID = b.RENT_MNG_ID(+)  AND a.RENT_L_CD = b.RENT_L_CD(+) AND a.RENT_L_CD = c.rent_l_cd(+)  and b.car_mng_id = cr.car_mng_id and  a.RENT_MNG_ID = c.rent_mng_id(+)  AND a.FEE_TM = c.fee_tm(+)  ";
			
			if(gubun3.equals("4") && gubun2.equals("1")){
				query += " and TO_CHAR(a.CNG_DT, 'YYYYMM') = to_char(sysdate,'YYYYMM') ";
			}else if(gubun3.equals("4") && gubun2.equals("2")){ 
				query += " and  TO_CHAR(a.CNG_DT, 'YYYYMMDD') = to_char(sysdate,'YYYYMMDD') ";
			}else if(gubun3.equals("4") && gubun2.equals("5")){ 
				query += " and  TO_CHAR(a.CNG_DT, 'YYYYMMDD') = to_char(sysdate,'YYYYMMDD')-1 ";
			}else if(gubun3.equals("4") && gubun2.equals("3")){	
				query += "AND  TO_CHAR(a.CNG_DT, 'YYYYMMDD') BETWEEN replace('"+st_dt+"','-','') AND replace('"+end_dt+"','-','')";
			}
		
		if(gubun4.equals("2")){
			query += " and a.GUBUN in( '신규생성','발행예정일') AND a.cng_id = '"+t_wd+"' and b.brch_id in ('S1','S2','I1','K3','S3','S4','S5','S6') ";
		}else{

		if(t_wd.equals("000058")){
			query += " and a.GUBUN in( '신규생성','발행예정일') AND a.cng_id = '"+t_wd+"'and b.brch_id in ('S1','S2','I1','K3','S3','S4','S5','S6') ";
		}else if(t_wd.equals("000131")){
			query += " AND (a.GUBUN ='신규생성' or ( a.ALL_ST = 'Y' and a.GUBUN IS NULL ))  and  a.cng_id = '"+t_wd+"' ";
		}else{
			query += " AND a.CNG_CAU NOT LIKE '%일자계산%' and a.cng_id not in  ('000058','000131') ";
		}

		}

		query += " order by a.cng_dt "+asc+" ";



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
			System.out.println("[AddFeeDatabase:getFeeScdListAll]\n"+e);
			System.out.println("[AddFeeDatabase:getFeeScdListAll]\n"+query);
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
	 *	월렌트 대여료 스케줄 리스트 - con_fee/fee_rm_sc_in.jsp
	 *
	 *	입금예정일 : E(0:당일이전, 1:당일, 2:예정)--> 단순하게 입금예정일과 당일 비교
	 *	수금일 : R(0:당일이전, 1:당일, 2:예정) --> 단순하게 수금일과 당일 비교
	 *	연체구분 : D(1:연체, 0:연체아님) 	--> 수금인경우 수금일 > 입금예정일, 미수금인경우 현재날짜 > 입금예정일
	 *	선수구분 : F(1:선수, 0:선수아님)	--> 수금인경우 수금일 < 입금예정일
	 *	수금상태 : RC_YN(0:미수, 1: 수금)	--> Y/N로 표시
	 */
	public Vector getFeeRmList(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select /*+ leading(A H O) index(a SCD_FEE_IDX5)  index(b CONT_IDX3) index(c CLIENT_PK )*/ "+
			    " b.client_id, nvl(m.firm_nm,c.firm_nm) firm_nm, nvl(m.client_nm,c.client_nm) client_nm, e.r_site, d.car_mng_id, d.car_no, d.car_nm, b.brch_id, f.user_nm as bus_nm2, b.bus_id, b.bus_id2, b.use_yn,"+
				" (a.fee_s_amt+a.fee_v_amt) fee_amt, a.*,"+
				" h.reg_nm, h.speaker, h.content, h.reg_dt, h.reg_dt2,"+
				" o.tax_dt as tax_dt"+
				" from scd_fee a, cont b, client c, car_reg d, client_site e, users f, "+
				" /*dly_mm*/	(select rent_mng_id, rent_l_cd, max(reg_dt||reg_dt_time) reg_dt from dly_mm group by rent_mng_id, rent_l_cd) g,"+
				" /*dly_mm*/	(select a.rent_mng_id, a.rent_l_cd, b.user_nm as reg_nm, a.speaker, a.content, reg_dt||reg_dt_time as reg_dt, reg_dt as reg_dt2 from dly_mm a, users b where a.reg_id=b.user_id) h,"+
				" /*cls_cont*/	(select rent_mng_id, rent_l_cd from cls_cont where cls_st in ('1','2')) i,"+
				" /*scd_fee*/	(select rent_mng_id, rent_l_cd, min(fee_est_dt) fee_est_dt from scd_fee where rc_yn='0' and fee_s_amt>0 group by rent_mng_id, rent_l_cd) j,"+
			    " /*scd_fee*/	(select nvl(d.client_id,a.client_id) client_id, min(b.r_fee_est_dt) r_fee_est_dt from cont a, scd_fee b, cls_cont c, fee_rtn d where a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd(+) and b.rent_mng_id=d.rent_mng_id(+) and b.rent_l_cd=d.rent_l_cd(+) and b.rent_st=d.rent_st(+) and b.rent_seq=d.rent_seq(+) and nvl(c.cls_st,'0')<>'2' and b.fee_s_amt>0 and nvl(b.bill_yn,'Y')='Y' and b.rc_yn='0' group by nvl(d.client_id,a.client_id)) k,"+
						      //세금계산서
					 "        ( select /*+index(tax TAX_IDX10) */ b.rent_l_cd, b.tm, nvl(b.rent_st,'') rent_st, nvl(b.rent_seq,'') rent_seq, "+
					 "	               max(a.tax_no) tax_no, max(a.tax_dt) tax_dt, max(a.reg_dt) reg_dt, max(a.print_dt) print_dt, \n"+
					 "		           max(a.tax_supply) tax_supply, max(a.tax_value) tax_value, \n"+
					 "		           max(c.item_dt) item_dt, max(c.tax_est_dt) tax_est_dt \n"+
					 "	        from   tax a, tax_item_list b, tax_item c \n"+
					 "			where  a.gubun='1' and a.item_id=b.item_id and a.item_id=c.item_id and a.tax_st<>'C' and nvl(a.doctype,'0')='0' and nvl(c.use_yn,'Y')='Y'\n"+
					 "	        group by b.rent_l_cd, b.tm, b.rent_st, b.rent_seq \n"+
					 "	      ) o, \n"+
				" /*fee_rtn*/	(select a.*, b.firm_nm, c.r_site, b.client_nm, c.site_jang from fee_rtn a, client b, client_site c where a.client_id=b.client_id and a.client_id=c.client_id(+) and a.r_site=c.seq(+)) m"+
				" where"+
				" nvl(a.bill_yn,'Y')='Y' and a.fee_s_amt>0 "+
				" and a.rent_l_cd=b.rent_l_cd and b.car_st='4' "+
				" and b.client_id=c.client_id"+
				" and b.car_mng_id=d.car_mng_id"+
				" and b.client_id=e.client_id(+) and b.r_site=e.seq(+)"+
				" and b.mng_id=f.user_id(+)"+
				" and a.rent_mng_id=g.rent_mng_id(+) and a.rent_l_cd=g.rent_l_cd(+)"+
				" and g.rent_mng_id=h.rent_mng_id(+) and g.rent_l_cd=h.rent_l_cd(+) and g.reg_dt=h.reg_dt(+)"+
				" and a.rent_mng_id=i.rent_mng_id(+) and a.rent_l_cd=i.rent_l_cd(+) "+
				" and a.rent_mng_id=j.rent_mng_id(+) and a.rent_l_cd=j.rent_l_cd(+)"+
				" and decode(a.rent_seq,'1',b.client_id,m.client_id)=k.client_id"+ 
				" and a.rent_l_cd=o.rent_l_cd(+) and a.fee_tm=o.tm(+) and a.rent_st=o.rent_st(+) and a.rent_seq=o.rent_seq(+)"+
				" and a.rent_mng_id=m.rent_mng_id(+) and a.rent_l_cd=m.rent_l_cd(+) and a.rent_st=m.rent_st(+) and a.rent_seq=m.rent_seq(+)"+
				" ";

		String fee_mon	= "substr(a.r_fee_est_dt,1,6)";
		String now_mon	= "to_char(sysdate,'YYYYMM')";
		String fee_dt	= "a.r_fee_est_dt";
		String rc_dt	= "a.rc_dt";
		String now_dt	= "to_char(sysdate,'YYYYMMDD')";

		
		/*상세조회&&세부조회*/
		//당월------------------------------------------------------------------------------------------------------------
		//계획
		if(gubun2.equals("1") && gubun3.equals("1")){		query += " and "+fee_dt+" like "+now_mon+"||'%' ";
		//수금
		}else if(gubun2.equals("1") && gubun3.equals("2")){	query += " and "+fee_dt+" like "+now_mon+"||'%' and a.rc_yn='1'";
		//미수금
		}else if(gubun2.equals("1") && gubun3.equals("3")){	query += " and "+fee_dt+" like "+now_mon+"||'%' and a.rc_yn='0'";
		//선수금
		}else if(gubun2.equals("1") && gubun3.equals("4")){	query += " and "+fee_dt+" like "+now_mon+"||'%' and "+fee_dt+">"+rc_dt+" ";
		//당일------------------------------------------------------------------------------------------------------------
		//계획
		}else if(gubun2.equals("2") && gubun3.equals("1")){	query += " and ("+rc_dt+"="+now_dt+" or ("+fee_dt+"="+now_dt+" and a.rc_yn='0'))";
		//수금
		}else if(gubun2.equals("2") && gubun3.equals("2")){	query += " and  "+rc_dt+"="+now_dt+" ";
		//미수금
		}else if(gubun2.equals("2") && gubun3.equals("3")){	query += " and  "+fee_dt+"="+now_dt+" and a.rc_yn='0'";
		//연체------------------------------------------------------------------------------------------------------------
		//계획
		}else if(gubun2.equals("3") && gubun3.equals("1")){	query += " and "+fee_dt+"<"+now_dt+" and (a.rc_yn='0' or "+rc_dt+"="+now_dt+")";
		//수금
		}else if(gubun2.equals("3") && gubun3.equals("2")){	query += " and "+fee_dt+"<"+now_dt+" and "+rc_dt+"="+now_dt+"";
		//미수금
		}else if(gubun2.equals("3") && gubun3.equals("3")){	query += " and "+fee_dt+"<"+now_dt+" and a.rc_yn='0'";
		//당일+연체------------------------------------------------------------------------------------------------------------
		//계획
		}else if(gubun2.equals("6") && gubun3.equals("1")){	query += " and "+fee_dt+"<="+now_dt+" and (a.rc_yn='0' or "+rc_dt+"="+now_dt+")";
		//수금
		}else if(gubun2.equals("6") && gubun3.equals("2")){	query += " and "+fee_dt+"<="+now_dt+" and "+rc_dt+"="+now_dt+"";
		//미수금
		}else if(gubun2.equals("6") && gubun3.equals("3")){	query += " and "+fee_dt+"<="+now_dt+" and a.rc_yn='0'";
		//기간------------------------------------------------------------------------------------------------------------
		//계획
		}else if(gubun2.equals("4") && gubun3.equals("1")){	query += " and "+fee_dt+" BETWEEN replace('"+st_dt+"', '-', '') AND replace('"+end_dt+"', '-', '')";
		//수금
		}else if(gubun2.equals("4") && gubun3.equals("2")){	query += " and "+rc_dt+"  BETWEEN replace('"+st_dt+"', '-', '') AND replace('"+end_dt+"', '-', '')";
		//미수금
		}else if(gubun2.equals("4") && gubun3.equals("3")){	query += " and "+fee_dt+" BETWEEN replace('"+st_dt+"', '-', '') AND replace('"+end_dt+"', '-', '') and a.rc_yn='0'";
		//검색------------------------------------------------------------------------------------------------------------
		//검색-수금
		}else if(gubun2.equals("5") && gubun3.equals("2")){	query += " and a.rc_yn='1'";
		//검색-미수금
		}else if(gubun2.equals("5") && gubun3.equals("3")){	query += " and a.rc_yn='0'";
		}else{												query += " and a.fee_est_dt=j.fee_est_dt";	
		}

		/*연체조회*/

		if(gubun2.equals("3")){
			if(gubun4.equals("2")){	//일반연체		
				query += " and a.dly_days between 1 and 30";
			}else if(gubun4.equals("3")){ //부실연체
				query += " and a.dly_days between 31 and 60";
			}else if(gubun4.equals("4")){ //악성연체
				query += " and a.dly_days between 61 and 1000";
			}else{}
		}



		/*검색조건*/
			
		if(s_kd.equals("1"))		query += " and nvl(nvl(m.firm_nm,c.firm_nm), '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("2"))	query += " and nvl(nvl(m.client_nm,c.client_nm), '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(a.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and nvl(d.car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("5"))	query += " and (a.fee_s_amt+a.fee_v_amt) = to_number(replace('"+t_wd+"',',',''))\n";
		else if(s_kd.equals("6"))	query += " and upper(b.brch_id) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("7"))	query += " and nvl(e.r_site, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("8"))	query += " and b.BUS_ID2= '"+t_wd+"'\n";
		else if(s_kd.equals("10"))	query += " and b.BUS_ID= '"+t_wd+"'\n";
		else if(s_kd.equals("9"))	query += " and d.car_nm like '%"+t_wd+"%'\n";


		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		/*정렬조건*/

		if(sort_gubun.equals("0"))		query += " order by nvl(b.use_yn,'Y') desc, nvl(a.dly_chk,'0') desc, nvl(k.r_fee_est_dt,a.fee_est_dt) "+sort+", nvl(m.firm_nm,c.firm_nm), a.r_fee_est_dt, b.rent_start_dt, b.rent_mng_id";//a.rc_dt, 
		else if(sort_gubun.equals("1"))	query += " order by nvl(b.use_yn,'Y') desc, nvl(a.dly_chk,'0') desc, nvl(m.firm_nm,c.firm_nm) "+sort+", a.rc_dt, a.fee_est_dt";
		else if(sort_gubun.equals("2"))	query += " order by nvl(b.use_yn,'Y') desc, nvl(a.dly_chk,'0') desc, a.rc_dt "+sort+", c.firm_nm, a.fee_est_dt";
		else if(sort_gubun.equals("3"))	query += " order by nvl(b.use_yn,'Y') desc, nvl(a.dly_chk,'0') desc, a.fee_s_amt "+sort+", a.rc_dt, nvl(m.firm_nm,c.firm_nm), a.fee_est_dt";
		else if(sort_gubun.equals("4"))	query += " order by nvl(b.use_yn,'Y') desc, nvl(a.dly_chk,'0') desc, a.dly_days "+sort+", a.rc_dt, nvl(m.firm_nm,c.firm_nm), a.fee_est_dt";
		else if(sort_gubun.equals("5"))	query += " order by d.car_no "+sort+", nvl(m.firm_nm,c.firm_nm), a.fee_est_dt";


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
			System.out.println("[AddFeeDatabase:getFeeRmList]\n"+e);
			System.out.println("[AddFeeDatabase:getFeeRmList]\n"+query);
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
	 *	보증금일괄입금처리리스트
	 */
	public Vector getGrtScdStatClient(String client_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.*, (a.ext_s_amt+a.ext_v_amt) ext_amt, decode(a.ext_st,'0','보증금','1','선납금','2','개시대여료','5','승계수수료')||decode(a.ext_tm,'1','','잔액') tm_st1_nm, c.car_no, c.car_nm, c.car_mng_id "+
				" from   scd_ext a, cont b, car_reg c "+
				" where  "+
				" a.ext_st in ('0','1','2','5') and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.car_mng_id=c.car_mng_id(+)"+
				" and b.client_id='"+client_id+"' "+
				" and a.ext_pay_dt is null and a.bill_yn='Y' and (a.ext_s_amt+a.ext_v_amt)>0"+
				" order by a.ext_est_dt, b.rent_dt"+
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
			System.out.println("[AddFeeDatabase:getGrtScdStatClient]\n"+e);
			System.out.println("[AddFeeDatabase:getGrtScdStatClient]\n"+query);
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
	 *	분할청구정보조회
	 */
	public Vector getFeeRtnClientList(String client_id, String m_id, String l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();


		String query = "";

		query = " select a.client_id, nvl(a.r_site,'00') seq, "+
			    "        DECODE(a.r_site,'',DECODE(b.client_id,'2',TEXT_DECRYPT(b.ssn, 'pw' ) ,b.enp_no),  TEXT_DECRYPT(c.enp_no, 'pw' )  ) enp_no, "+
                "        DECODE(a.r_site,'',b.firm_nm,c.r_site) firm_nm, "+
                "        DECODE(a.r_site,'',b.client_nm,c.site_jang) client_nm, "+
                "        DECODE(a.r_site,'',b.o_addr,c.addr) o_addr, "+
                "        DECODE(a.r_site,'',b.bus_cdt,c.bus_cdt) bus_cdt, "+
                "        DECODE(a.r_site,'',b.bus_itm,c.bus_itm) bus_itm, "+
                "        DECODE(a.r_site,'',b.taxregno,c.taxregno) taxregno, "+
			    "        DECODE(a.r_site,'',b.con_agnt_email,c.agnt_email) con_agnt_email "+
				" from   fee_rtn a, client b, client_site c "+
				" where  a.rent_mng_id='"+m_id+"' and a.rent_l_cd='"+l_cd+"' "+
				"        and a.client_id=b.client_id "+
				"        and a.client_id=c.client_id(+) and a.r_site=c.seq(+) "+
			    "        and a.client_id<>'"+client_id+"'"+
				" order by a.rent_seq ";


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
			System.out.println("[AddFeeDatabase:getFeeRtnClientList]\n"+e);
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

//대여기간 + 임의연장 포함하여 계약가간 산출
public Hashtable getfee_minmax(String m_id, String l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		String query = "";
		Hashtable ht = new Hashtable();
	
		query = " SELECT a.rent_mng_id, a.rent_l_cd, CASE WHEN a.min_sdt >= b.min_sdt THEN b.min_sdt ELSE a.min_sdt END min_sdt, "+
				" CASE WHEN a.max_edt <= b.max_edt THEN b.max_edt ELSE a.max_edt END max_edt FROM "+
				" (SELECT rent_mng_id, rent_l_cd, min(rent_start_dt) min_sdt, MAX(rent_end_dt) max_edt FROM FEE "+
				" WHERE rent_mng_id='"+m_id+"' AND rent_l_cd='"+l_cd+"' GROUP BY rent_mng_id, rent_l_cd ) a, "+
				" (SELECT rent_mng_id, rent_l_cd, min(rent_start_dt) min_sdt, MAX(rent_end_dt) max_edt FROM FEE_IM "+
				" WHERE rent_mng_id='"+m_id+"' AND rent_l_cd='"+l_cd+"' GROUP BY rent_mng_id, rent_l_cd )b "+
				" WHERE a.rent_l_cd = b.rent_l_cd(+) AND a.rent_mng_id = b.rent_mng_id(+)  ";
		

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
			System.out.println("[AddFeeDatabase:getfee_minmax]\n"+e);
			System.out.println("[AddFeeDatabase:getfee_minmax]\n"+query);			
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

	
	/****************************************************************************************
	*******************************************   smart
    ****************************************************************************************/


/**
	 *	최고장발행
	 */
	public Vector getFineDocLists(String id_st, String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String dt_query = "";
		String dt = "a.doc_dt";//시행일자

		//일자조회
		if(gubun2.equals("1"))		dt_query = " and "+dt+"=to_char(sysdate-2,'YYYYMMDD')";
		if(gubun2.equals("2"))		dt_query = " and "+dt+"=to_char(sysdate-1,'YYYYMMDD')";
		if(gubun2.equals("3"))		dt_query = " and "+dt+"=to_char(sysdate,'YYYYMMDD')";
		if(gubun2.equals("4"))		dt_query = " and "+dt+" like to_char(sysdate,'YYYYMM')||'%'";
		if(gubun2.equals("5"))		dt_query = " and "+dt+" between replace(nvl('"+st_dt+"','00000000'), '-', '') and replace(nvl('"+end_dt+"','99999999'), '-', '')";

	
		if(id_st.equals("총무")){ 
			if ( gubun4.equals("L")) { //대출 공문
				
				query = " SELECT"+
						" a.doc_id, a.doc_dt, a.gov_id, a.mng_dept, a.print_dt, a.reg_id, a.reg_dt, a.upd_id, a.upd_dt, a.gov_st, a.mng_nm, a.mng_pos, a.h_mng_id, a.b_mng_id, a.app_doc3, a.app_doc1, a.app_doc2, a.app_doc4, a.print_id,"+
						" b.nm as gov_nm, c.cnt, a.app_doc5, a.end_dt "+
						" from fine_doc a, (select * from code where c_st = '0003') b, (select doc_id, count(0) cnt from fine_doc_list group by doc_id) c"+
						" where"+
						" a.gov_id=b.code and a.doc_id=c.doc_id and a.doc_id like '%총무%'"+dt_query;
	
					if(!gubun1.equals(""))		query += " and b.code ='"+gubun1+"'";
	
				//검색어가 있을때...
				if(!t_wd.equals("")){
					query = " select"+ 
							" DISTINCT  a.*, b.nm as gov_nm, c.cnt  "+ 
							" from fine_doc a, fine_doc_list d, (select * from code where c_st = '0003') b,  (select doc_id, count(0) cnt from fine_doc_list group by doc_id) c , car_reg i "+ 
							" where "+ 
							" a.gov_id=b.code"+ 
							" and a.doc_id=c.doc_id(+)"+ 
							" and a.doc_id=d.doc_id(+)"+ 	
							" and d.car_mng_id=i.car_mng_id"; 
							 		
					if(s_kd.equals("2"))	query += " and i.car_no like '%"+t_wd+"%'";				
					if(s_kd.equals("3"))	query += " and b.code ='"+t_wd+"'";
				
	
				}

		   } else { //해지공문
		   		query = " SELECT"+
						" a.doc_id, a.doc_dt, a.gov_id, a.mng_dept, a.print_dt, a.reg_id, a.reg_dt, a.upd_id, a.upd_dt, a.gov_st, a.mng_nm, a.mng_pos, a.h_mng_id, a.b_mng_id, a.app_doc3, a.app_doc1, a.app_doc2, a.app_doc4, a.print_id,"+
						" b.ins_com_nm as gov_nm, c.cnt"+
						" from fine_doc a, ins_com b, (select doc_id, count(0) cnt from ins_doc_list group by doc_id) c"+
						" where"+
						" a.gov_id=b.ins_com_id and a.doc_id=c.doc_id and a.doc_id like '%총무%'"+dt_query;
	
					if(!gubun1.equals(""))		query += " and b.ins_com_id='"+gubun1+"'";
	
				//검색어가 있을때...
				if(!t_wd.equals("")){
					query = " select"+ 
							" DISTINCT  a.*, b.ins_com_nm as gov_nm, j.cnt"+ 
							" from fine_doc a, ins_com b, ins_doc_list c, insur d, ins_cls e, car_reg i,"+ 
							" (select doc_id, count(0) cnt from ins_doc_list group by doc_id) j"+ 
							" where "+ 
							" a.gov_id=b.ins_com_id"+ 
							" and a.doc_id=c.doc_id"+ 
							" and c.car_mng_id=d.car_mng_id and c.ins_st=d.ins_st"+ 
							" and c.car_mng_id=e.car_mng_id and c.ins_st=e.ins_st"+ 
							" and c.car_mng_id=i.car_mng_id"+ 
							" and a.doc_id=j.doc_id";
	
					if(s_kd.equals("2"))	query += " and c.car_no_b||c.car_no_a||i.car_no like '%"+t_wd+"%'";
					if(s_kd.equals("5"))	query += " and e.req_dt like '"+t_wd+"%'";
					if(s_kd.equals("6"))	query += " and e.exp_dt like '"+t_wd+"%'";
	
				}
		   	
		   }	
		
		}else if(id_st.equals("구매")){//자동차구매요청공문

			query = " SELECT"+
					" a.doc_id, a.doc_dt, a.gov_id, a.mng_dept, a.print_dt, a.reg_id, a.reg_dt, a.upd_id, a.upd_dt, a.gov_st, a.mng_nm, a.mng_pos, a.h_mng_id, a.b_mng_id, a.app_doc3, a.app_doc1, a.app_doc2, a.app_doc4, a.print_id,"+
					" e.nm||' '||d.car_off_nm||'장' as gov_nm, c.cnt"+
					" from fine_doc a, car_off_emp b, (select doc_id, count(0) cnt from car_pur_doc_list group by doc_id) c, car_off d, code e"+
					" where"+
					" a.gov_id=b.emp_id"+
					" and b.car_off_id=d.car_off_id(+)"+
					" and a.doc_id=c.doc_id and d.car_comp_id=e.code and e.c_st='0001'"+
					" and a.doc_id like '%구매%'"+dt_query;

				if(!gubun1.equals(""))		query += " and e.nm||b.emp_nm||d.car_off_nm like '%"+gubun1+"%'";

			//검색어가 있을때...
			if(!t_wd.equals("")){
				query = " select"+ 
						" DISTINCT  a.*, h.nm||' '||d.car_off_nm||'장' as gov_nm, j.cnt"+ 
						" from fine_doc a, car_off_emp b, car_pur_doc_list c, car_off d, cont e, car_reg i,"+ 
						" (select doc_id, count(0) cnt from car_pur_doc_list group by doc_id) j, code h"+ 
						" where "+ 
						" a.gov_id=b.emp_id"+ 
						" and a.doc_id=c.doc_id"+ 
						" and b.car_off_id=d.car_off_id"+ 
						" and c.rent_mng_id=e.rent_mng_id and c.rent_l_cd=e.rent_l_cd"+ 
						" and e.car_mng_id=i.car_mng_id"+ 
						" and a.doc_id=j.doc_id and d.car_comp_id=h.code and h.c_st='0001'";

				if(s_kd.equals("1"))	query += " and c.rent_l_cd like '%"+t_wd+"%'";
				if(s_kd.equals("2"))	query += " and i.first_car_no||' '||i.car_no like '%"+t_wd+"%'";

			}

		}else if(id_st.equals("채권추심")){//최고장

			query = " SELECT '1' id_st,"+
					" a.*, c.cnt, decode(a.f_reason, '1', '이사감', '2', '수취인부재', '3', '폐문부재', '4', '수취거절', '5', '주소불명', '6', '수취인불명', '') f_reason_nm "+
					" from fine_doc a, client b, (select doc_id, count(0) cnt from fine_doc_list group by doc_id) c"+
					" where"+
					" a.gov_id=b.client_id and a.doc_id=c.doc_id(+)  and a.doc_id like '%채권추심%'"+dt_query;


			//검색어가 있을때...
			if(!t_wd.equals("")){
				query = " select  "+ 
						" DISTINCT '1' id_st,  a.*, j.cnt,  decode(a.f_reason, '1', '이사감', '2', '수취인부재', '3', '폐문부재', '4', '수취거절', '5', '주소불명', '6', '수취인불명', '') f_reason_nm "+ 
						" from fine_doc a, client b, fine_doc_list c, "+ 
						" (select doc_id, count(0) cnt from fine_doc_list group by doc_id) j"+ 
						" where "+ 
						" a.gov_id=b.client_id"+ 
						" and a.doc_id=c.doc_id(+)"+ 
						" and a.doc_id=j.doc_id(+)";

				if(s_kd.equals("1"))	query += " and a.gov_nm like '%"+t_wd+"%'";
				if(s_kd.equals("2"))	query += " and c.car_no like '%"+t_wd+"%'";
				if(s_kd.equals("3"))	query += " and c.rent_l_cd like '%"+t_wd+"%'";


			}
		
		}else if(id_st.equals("법무")){//최고장

			query = " SELECT '2' id_st, "+
					" a.*, c.cnt, decode(a.f_reason, '1', '이사감', '2', '수취인부재', '3', '폐문부재', '4', '수취거절', '5', '주소불명', '6', '수취인불명', '') f_reason_nm "+
					" from fine_doc a, ins_com b, (select doc_id, count(0) cnt from fine_doc_list group by doc_id) c"+
					" where"+
					" a.gov_id=b.ins_com_id and a.doc_id=c.doc_id(+)  and a.doc_id like '%법무%'"+dt_query;


			//검색어가 있을때...
			if(!t_wd.equals("")){
				query = " select "+ 
						" DISTINCT  '2' id_st,  a.*, j.cnt,  decode(a.f_reason, '1', '이사감', '2', '수취인부재', '3', '폐문부재', '4', '수취거절', '5', '주소불명', '6', '수취인불명', '') f_reason_nm "+ 
						" from fine_doc a, client b, fine_doc_list c, "+ 
						" (select doc_id, count(0) cnt from fine_doc_list group by doc_id) j"+ 
						" where "+ 
						" a.gov_id=b.client_id"+ 
						" and a.doc_id=c.doc_id(+)"+ 
						" and a.doc_id=j.doc_id(+)";

				if(s_kd.equals("1"))	query += " and a.gov_nm like '%"+t_wd+"%'";
				if(s_kd.equals("2"))	query += " and c.car_no like '%"+t_wd+"%'";
				if(s_kd.equals("3"))	query += " and c.rent_l_cd like '%"+t_wd+"%'";
			}
	
		}else{//과태료 이의신청공문

			query = " SELECT"+
					" a.doc_id, a.doc_dt, a.gov_id, a.mng_dept, a.print_dt, a.reg_id, a.reg_dt, a.upd_id, a.upd_dt, a.gov_st, a.mng_nm, a.mng_pos, a.h_mng_id, a.b_mng_id, a.app_doc3, a.app_doc1, a.app_doc2, a.app_doc4, a.print_id,"+
					" b.gov_nm, c.cnt"+
					" from fine_doc a, fine_gov b, (select doc_id, count(0) cnt from fine_doc_list group by doc_id) c"+
					" where"+
					" a.gov_id=b.gov_id and a.doc_id=c.doc_id and a.doc_id like '%관리%'"+dt_query;

				if(!gubun1.equals(""))		query += " and b.gov_id='"+gubun1+"'";

			//검색어가 있을때...
			if(!t_wd.equals("")){
				query = " select"+ 
						" DISTINCT "+
						" a.doc_id, a.doc_dt, a.gov_id, a.mng_dept, a.print_dt, a.reg_id, a.reg_dt, a.upd_id, a.upd_dt, a.gov_st, a.mng_nm, a.mng_pos, a.h_mng_id, a.b_mng_id, a.app_doc3, a.app_doc1, a.app_doc2, a.app_doc4, a.print_id,"+
						" b.gov_nm, j.cnt"+ 
						" from fine_doc a, fine_gov b, fine_doc_list c, fine d, cont e, client f, rent_cont g, rent_cust h, car_reg i,"+ 
						" (select doc_id, count(0) cnt from fine_doc_list group by doc_id) j, users l"+ 
						" where "+ 
						" a.gov_id=b.gov_id"+ 
						" and a.doc_id=c.doc_id and a.doc_id like '%관리%'"+dt_query + 
						" and c.car_mng_id=d.car_mng_id and c.seq_no=d.seq_no and c.rent_mng_id=d.rent_mng_id and c.rent_l_cd=d.rent_l_cd"+ 
						" and c.rent_mng_id=e.rent_mng_id and c.rent_l_cd=e.rent_l_cd"+ 
						" and e.client_id=f.client_id"+ 
						" and c.rent_s_cd=g.rent_s_cd(+)"+ 
						" and g.cust_id=h.cust_id(+)"+ 
						" and c.car_mng_id=i.car_mng_id"+ 
						" and a.doc_id=j.doc_id"+
						" and a.reg_id=l.user_id"+
						" ";

				if(s_kd.equals("1"))	query += " and nvl(f.firm_nm,f.client_nm)||h.cust_nm like '%"+t_wd+"%'";
				if(s_kd.equals("2"))	query += " and i.car_no like '%"+t_wd+"%'";
				if(s_kd.equals("3"))	query += " and d.paid_no like '%"+t_wd+"%'";
				if(s_kd.equals("4"))	query += " and d.vio_dt like '"+t_wd+"%'";
				if(s_kd.equals("5"))	query += " and l.user_nm like '%"+t_wd+"%'";

			}
		
		}

		query += " ORDER BY a.doc_id desc";

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
			System.out.println("[getFineDocLists:getFineSearchLists]\n"+e);
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
	 *	계약수정에서 대여스케줄 등록선택시 : 한회차 대여료 insert
	 */
	public boolean insertFeeScdEst(FeeScdBean fee_scd, String doc_no)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";

		query = " insert into SCD_FEE_EST ( RENT_MNG_ID, RENT_L_CD, FEE_TM, RENT_ST, TM_ST1,"+
				"                           TM_ST2, FEE_EST_DT, FEE_S_AMT, FEE_V_AMT, "+
				"                           R_FEE_EST_DT, UPDATE_DT,"+
				"                           UPDATE_ID, USE_S_DT, USE_E_DT, REQ_DT, R_REQ_DT,"+
				"                           TAX_OUT_DT, RENT_SEQ, doc_no, etc) values ("+
				"                           ?, ?, ?, ?, ?,"+
				"                           ?, replace(?, '-', ''), ?, ?, "+
				"                           replace(?, '-', ''), to_char(sysdate,'YYYYMMDD'),"+
				"                           ?, replace(?, '-', ''), replace(?, '-', ''), replace(?, '-', ''), replace(?, '-', ''), replace(?, '-', ''), ?, ?, ? "+
				"                         )";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, fee_scd.getRent_mng_id()		);
			pstmt.setString(2, fee_scd.getRent_l_cd()		);
			pstmt.setString(3, fee_scd.getFee_tm()			);
			pstmt.setString(4, fee_scd.getRent_st()			);
			pstmt.setString(5, fee_scd.getTm_st1()			);
			pstmt.setString(6, fee_scd.getTm_st2()			);
			pstmt.setString(7, fee_scd.getFee_est_dt()		);
			pstmt.setInt   (8, fee_scd.getFee_s_amt()		);
			pstmt.setInt   (9, fee_scd.getFee_v_amt()		);
			pstmt.setString(10, fee_scd.getR_fee_est_dt()	);
			pstmt.setString(11, fee_scd.getUpdate_id()		);
			pstmt.setString(12, fee_scd.getUse_s_dt()		);
			pstmt.setString(13, fee_scd.getUse_e_dt()		);
			pstmt.setString(14, fee_scd.getReq_dt()			);
			pstmt.setString(15, fee_scd.getR_req_dt()		);
			pstmt.setString(16, fee_scd.getTax_out_dt()		);
			pstmt.setString(17, fee_scd.getRent_seq()		);
			pstmt.setString(18, doc_no);
			pstmt.setString(19, fee_scd.getEtc()			);

			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[AddFeeDatabase:insertFeeScdEst]\n"+e);
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
	 *	한회차 대여료 update
	 */
	public boolean updateFeeScdEst(FeeScdBean fee_scd)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = " update scd_fee_est set "+
						" TM_ST2		= ?, "+
						" FEE_EST_DT	= replace(?, '-', ''), "+
						" FEE_S_AMT		= ?, "+
						" FEE_V_AMT		= ?, "+
						" R_FEE_EST_DT	= replace(?, '-', ''), "+
						" REQ_DT		= replace(?, '-', ''), "+
						" R_REQ_DT		= replace(?, '-', ''), "+
						" TAX_OUT_DT	= replace(?, '-', ''), "+
						" USE_S_DT		= replace(?, '-', ''), "+
						" USE_E_DT		= replace(?, '-', ''), "+
						" etc			= ? "+
						" where "+
						" RENT_MNG_ID = ? and"+
						" RENT_L_CD = ? and"+
						" FEE_TM = ? and"+
						" RENT_ST = ? and"+
						" RENT_SEQ = ? and"+
						" TM_ST1 = ? ";
		
		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  fee_scd.getTm_st2		());
			pstmt.setString(2,  fee_scd.getFee_est_dt	());
			pstmt.setInt   (3,  fee_scd.getFee_s_amt	());
			pstmt.setInt   (4,  fee_scd.getFee_v_amt	());
			pstmt.setString(5,  fee_scd.getR_fee_est_dt	());
			pstmt.setString(6,  fee_scd.getReq_dt		());
			pstmt.setString(7,  fee_scd.getR_req_dt		());
			pstmt.setString(8,  fee_scd.getTax_out_dt	());
			pstmt.setString(9,  fee_scd.getUse_s_dt		());
			pstmt.setString(10, fee_scd.getUse_e_dt		());
			pstmt.setString(11, fee_scd.getEtc			());
			pstmt.setString(12, fee_scd.getRent_mng_id	());
			pstmt.setString(13, fee_scd.getRent_l_cd	());
			pstmt.setString(14, fee_scd.getFee_tm		());
			pstmt.setString(15, fee_scd.getRent_st		());
			pstmt.setString(16, fee_scd.getRent_seq		());
			pstmt.setString(17, fee_scd.getTm_st1		());
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
				
	  	} catch (Exception e) {
			System.out.println("[AddFeeDatabase:updateFeeScdEst]\n"+e);
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
	 *	예비대여료스케줄 리스트
	 */
	public Vector getScdFeeEstList(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();


		String query = "";

		query = " select * from scd_fee_est  "+
				" where  rent_mng_id='"+rent_mng_id+"' and rent_l_cd='"+rent_l_cd+"' "+
				" order by to_number(fee_tm) ";


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
			System.out.println("[AddFeeDatabase:getScdFeeEstList]\n"+e);
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
	 *	한회차 대여료 쿼리(한 라인)
	 */
	public FeeScdBean getScdFeeEst(String m_id, String l_cd, String rent_st, String rent_seq, String fee_tm, String tm_st1)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		FeeScdBean fee_scd = new FeeScdBean();

		if(rent_st.equals("")) rent_st = "1";

		String query = "";
		query = " select RENT_MNG_ID, RENT_L_CD, FEE_TM, RENT_ST, RENT_SEQ, TM_ST1, TM_ST2,"+
				"        decode(fee_est_dt, '','', substr(FEE_EST_DT, 1, 4) || '-' || substr(FEE_EST_DT, 5, 2) || '-'||substr(FEE_EST_DT, 7, 2)) FEE_EST_DT,"+
				"        FEE_S_AMT, FEE_V_AMT, "+
				"        substr(R_FEE_EST_DT, 1, 4) || '-' || substr(R_FEE_EST_DT, 5, 2) || '-'||substr(R_FEE_EST_DT, 7, 2) R_FEE_EST_DT,"+
				"        substr(REQ_DT, 1, 4) || '-' || substr(REQ_DT, 5, 2) || '-'||substr(REQ_DT, 7, 2) REQ_DT,"+
				"        substr(R_REQ_DT, 1, 4) || '-' || substr(R_REQ_DT, 5, 2) || '-'||substr(R_REQ_DT, 7, 2) R_REQ_DT,"+
				"        substr(TAX_OUT_DT, 1, 4) || '-' || substr(TAX_OUT_DT, 5, 2) || '-'||substr(TAX_OUT_DT, 7, 2) TAX_OUT_DT,"+
				"        substr(USE_S_DT, 1, 4) || '-' || substr(USE_S_DT, 5, 2) || '-'||substr(USE_S_DT, 7, 2) USE_S_DT,"+
				"        substr(USE_E_DT, 1, 4) || '-' || substr(USE_E_DT, 5, 2) || '-'||substr(USE_E_DT, 7, 2) USE_E_DT, ETC "+
				" from   scd_fee_est"+
				" where  RENT_MNG_ID = '"+m_id+"' and rent_l_cd='"+l_cd+"'"+
				"        and RENT_ST = '"+rent_st+"'"+
				"        and nvl(RENT_SEQ,'1') = '"+rent_seq+"'"+
				"        and FEE_TM = '"+fee_tm+"'"+
				"        and tm_st1 = '"+tm_st1+"'";

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			while(rs.next())
			{
				fee_scd.setRent_mng_id	(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd	(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm		(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_scd.setRent_st		(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_scd.setRent_seq		(rs.getString("RENT_SEQ")==null?"":rs.getString("RENT_SEQ"));
				fee_scd.setTm_st1		(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				fee_scd.setTm_st2		(rs.getString("TM_ST2")==null?"":rs.getString("TM_ST2"));
				fee_scd.setFee_est_dt	(rs.getString("FEE_EST_DT")==null?"":rs.getString("FEE_EST_DT"));
				fee_scd.setFee_s_amt	(rs.getString("FEE_S_AMT")==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee_scd.setFee_v_amt	(rs.getString("FEE_V_AMT")==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee_scd.setR_fee_est_dt	(rs.getString("R_FEE_EST_DT")==null?"":rs.getString("R_FEE_EST_DT"));
				fee_scd.setReq_dt		(rs.getString("REQ_DT")==null?"":rs.getString("REQ_DT"));
				fee_scd.setR_req_dt		(rs.getString("R_REQ_DT")==null?"":rs.getString("R_REQ_DT"));
				fee_scd.setTax_out_dt	(rs.getString("TAX_OUT_DT")==null?"":rs.getString("TAX_OUT_DT"));
				fee_scd.setUse_s_dt		(rs.getString("USE_S_DT")==null?"":rs.getString("USE_S_DT"));
				fee_scd.setUse_e_dt		(rs.getString("USE_E_DT")==null?"":rs.getString("USE_E_DT"));
				fee_scd.setEtc			(rs.getString("ETC")==null?"":rs.getString("ETC"));
			}
			rs.close();
			stmt.close();

		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getScdFeeEst]\n"+e);
			System.out.println("[AddFeeDatabase:getScdFeeEst]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return fee_scd;
		}				
	}

	/**
	 *	한 건에 대한 대여료 스케줄 쿼리
	 */
	public Vector getFeeScdCngEst(String l_cd, String rent_st)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select * from scd_fee_est where rent_l_cd='"+l_cd+"' and tm_st1='0'";

		if(rent_st.equals(""))		query += " and tm_st2='2'";
		if(!rent_st.equals(""))		query += " and tm_st2<>'2' and rent_st='"+rent_st+"'";

		query += " order by to_number(FEE_TM), to_number(TM_ST1)";												

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			while(rs.next())
			{
				FeeScdBean fee_scd = new FeeScdBean();
				fee_scd.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_scd.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_scd.setRent_seq(rs.getString("RENT_SEQ")==null?"":rs.getString("RENT_SEQ"));
				fee_scd.setTm_st1(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				fee_scd.setTm_st2(rs.getString("TM_ST2")==null?"":rs.getString("TM_ST2"));
				fee_scd.setFee_est_dt(rs.getString("FEE_EST_DT")==null?"":rs.getString("FEE_EST_DT"));
				fee_scd.setFee_s_amt(rs.getString("FEE_S_AMT")==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee_scd.setFee_v_amt(rs.getString("FEE_V_AMT")==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee_scd.setR_fee_est_dt(rs.getString("R_FEE_EST_DT")==null?"":rs.getString("R_FEE_EST_DT"));
				fee_scd.setReq_dt(rs.getString("REQ_DT")==null?"":rs.getString("REQ_DT"));
				fee_scd.setR_req_dt(rs.getString("R_REQ_DT")==null?"":rs.getString("R_REQ_DT"));
				fee_scd.setTax_out_dt(rs.getString("TAX_OUT_DT")==null?"":rs.getString("TAX_OUT_DT"));
				fee_scd.setUse_s_dt(rs.getString("USE_S_DT")==null?"":rs.getString("USE_S_DT"));
				fee_scd.setUse_e_dt(rs.getString("USE_E_DT")==null?"":rs.getString("USE_E_DT"));

				vt.add(fee_scd);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getFeeScdCngEst]\n"+e);
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

	public Vector getScdGroupCngEst(String m_id, String l_cd, String rent_st, String rent_seq, String fee_tm, String gubun)
	{
		getConnection();
		Vector vt = new Vector();
		Statement stmt = null;
		ResultSet rs = null;
		String query = "";
		query = " select"+
				" RENT_MNG_ID, RENT_L_CD, FEE_TM, RENT_ST, RENT_SEQ, TM_ST1, TM_ST2,"+
				" substr(FEE_EST_DT, 1, 4) || '-' || substr(FEE_EST_DT, 5, 2) || '-'||substr(FEE_EST_DT, 7, 2) FEE_EST_DT,"+
				" FEE_S_AMT, FEE_V_AMT, "+
				" substr(R_FEE_EST_DT, 1, 4) || '-' || substr(R_FEE_EST_DT, 5, 2) || '-'||substr(R_FEE_EST_DT, 7, 2) R_FEE_EST_DT,"+
				" substr(REQ_DT, 1, 4) || '-' || substr(REQ_DT, 5, 2) || '-'||substr(REQ_DT, 7, 2) REQ_DT,"+
				" substr(R_REQ_DT, 1, 4) || '-' || substr(R_REQ_DT, 5, 2) || '-'||substr(R_REQ_DT, 7, 2) R_REQ_DT,"+
				" substr(TAX_OUT_DT, 1, 4) || '-' || substr(TAX_OUT_DT, 5, 2) || '-'||substr(TAX_OUT_DT, 7, 2) TAX_OUT_DT,"+
				" substr(USE_S_DT, 1, 4) || '-' || substr(USE_S_DT, 5, 2) || '-'||substr(USE_S_DT, 7, 2) USE_S_DT,"+
				" substr(USE_E_DT, 1, 4) || '-' || substr(USE_E_DT, 5, 2) || '-'||substr(USE_E_DT, 7, 2) USE_E_DT,"+
				" ETC "+
				" from scd_fee_est "+
				" where RENT_MNG_ID = '"+m_id+"' and RENT_L_CD = '"+l_cd+"' and tm_st1='0'"+
				" and RENT_ST = '"+rent_st+"'"+
				" and RENT_SEQ = '"+rent_seq+"'"+
				" ";


		if(gubun.equals("ALL"))			query += " and to_number(FEE_TM) >= '"+fee_tm+"'";
		else if(gubun.equals("ONE"))	query += " and to_number(FEE_TM) = '"+fee_tm+"'";
		else							query += " and to_number(FEE_TM) between '"+fee_tm+"' and '"+gubun+"'";
				
		query += " order by to_number(fee_tm)";


		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
   			int i = 0;
			while(rs.next())
			{

				FeeScdBean fee_scd = new FeeScdBean();				
				fee_scd.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_scd.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_scd.setRent_seq(rs.getString("RENT_SEQ")==null?"":rs.getString("RENT_SEQ"));
				fee_scd.setTm_st1(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				fee_scd.setTm_st2(rs.getString("TM_ST2")==null?"":rs.getString("TM_ST2"));
				fee_scd.setFee_est_dt(rs.getString("FEE_EST_DT")==null?"":rs.getString("FEE_EST_DT"));
				fee_scd.setFee_s_amt(rs.getString("FEE_S_AMT")==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee_scd.setFee_v_amt(rs.getString("FEE_V_AMT")==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee_scd.setR_fee_est_dt(rs.getString("R_FEE_EST_DT")==null?"":rs.getString("R_FEE_EST_DT"));
				fee_scd.setReq_dt(rs.getString("REQ_DT")==null?"":rs.getString("REQ_DT"));
				fee_scd.setR_req_dt(rs.getString("R_REQ_DT")==null?"":rs.getString("R_REQ_DT"));
				fee_scd.setTax_out_dt(rs.getString("TAX_OUT_DT")==null?"":rs.getString("TAX_OUT_DT"));
				fee_scd.setUse_s_dt(rs.getString("USE_S_DT")==null?"":rs.getString("USE_S_DT"));
				fee_scd.setUse_e_dt(rs.getString("USE_E_DT")==null?"":rs.getString("USE_E_DT"));
				fee_scd.setEtc(rs.getString("ETC")==null?"":rs.getString("ETC"));

				vt.add(i, fee_scd);
				i++;
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getScdGroupCngEst]\n"+e);
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
	 *	금액 계산
	 */
	public int getSupAmt(int amt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		String query = "";
		int s_amt = 0;

		query = " SELECT round("+amt+"/1.1) FROM dual ";

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			if(rs.next())
			{				
				s_amt	= rs.getInt(1);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getSupAmt]\n"+e);
			System.out.println("[AddFeeDatabase:getSupAmt]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return s_amt;
		}
	}

	/**
	 *	금액 계산
	 */
	public int getVatAmt(int amt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		String query = "";
		int s_amt = 0;

		query = " SELECT trunc("+amt+"*0.1) FROM dual ";

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			if(rs.next())
			{				
				s_amt	= rs.getInt(1);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getVatAmt]\n"+e);
			System.out.println("[AddFeeDatabase:getVatAmt]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return s_amt;
		}
	}

	/**
	 *	금액 계산
	 */
	public int getUseMonDayAmt(int amt, int u_mon, int u_day)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		String query = "";
		int s_amt = 0;

		query = " SELECT round(("+amt+"*"+u_mon+")+("+amt+"/30*"+u_day+")) FROM dual ";

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			if(rs.next())
			{				
				s_amt	= rs.getInt(1);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getUseMonDayAmt]\n"+e);
			System.out.println("[AddFeeDatabase:getUseMonDayAmt]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return s_amt;
		}
	}

	/**
	 *	연장회차 삭제 : 한회차 대여료 delete /con_fee/ext_scd_i_a.jsp (20071123 수정)
	 */ 
	public boolean dropFeeScdEst(String m_id, String l_cd, String r_st, String rent_seq, String fee_tm, String tm_st1)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;

		String query1 = " delete from scd_fee_est "+
						" where RENT_MNG_ID=? and RENT_L_CD=? and RENT_ST=? and FEE_TM=? and TM_ST1=? and RENT_SEQ=?";

		String query2 = " update scd_fee_est set fee_tm=fee_tm-1"+
						" where RENT_MNG_ID=? and RENT_L_CD=? and to_number(FEE_TM)>? and rent_seq=? "+
						" and   (select count(0) from scd_fee_est where rent_mng_id=? and rent_l_cd=? and fee_tm=?) = 0 ";
		try {
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query1);
			pstmt1.setString(1 , m_id		);
			pstmt1.setString(2 , l_cd		);
			pstmt1.setString(3 , r_st		);
			pstmt1.setString(4 , fee_tm		);
			pstmt1.setString(5 , tm_st1		);
			pstmt1.setString(6 , rent_seq	);
			pstmt1.executeUpdate();
			pstmt1.close();
		    
			pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString(1 , m_id);
			pstmt2.setString(2 , l_cd);
			pstmt2.setString(3 , fee_tm);
			pstmt2.setString(4 , rent_seq);
			pstmt2.setString(5 , m_id);
			pstmt2.setString(6 , l_cd);
			pstmt2.setString(7 , fee_tm);

			pstmt2.executeUpdate();
			pstmt2.close();


			conn.commit();

		} catch (Exception e) {
			System.out.println("[AddFeeDatabase:dropFeeScdEst]\n"+e);
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt1 != null)	pstmt1.close();
				if(pstmt2 != null)	pstmt2.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//계약수정 : 출고전대차 스케줄 납입횟수 최고값 조회
	public int getMax_fee_tmEst(String m_id, String l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int fee_tm_count = 0;

		String query =" select max(TO_NUMBER(fee_tm)) from scd_fee_est "+
						" where rent_mng_id=?";



		try
		{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, m_id);
			rs = pstmt.executeQuery();
			if(rs.next())
			{
				fee_tm_count = Integer.parseInt(rs.getString(1)==null?"0":rs.getString(1));
			}
			rs.close();
			pstmt.close();
    	
		} catch (SQLException e) {
			System.out.println("[AddContDatabase:getMax_fee_tmEst]\n"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return fee_tm_count;
		}
	}

	/**
	 *	기발행 계산서 여부
	 */			
	public String getScdfeeDayMoreYn(String rent_mng_id, String rent_l_cd, String rent_st, String rent_seq, String fee_tm, String tm_st1, String tm_st2)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		String day_more_yn = "";
		String min_fee_tm = "";
		String query = "";

		query = " select c.min_fee_tm "+
				" from   cont a, fee b, "+
				"        (select rent_mng_id, rent_l_cd, rent_st, rent_seq, tm_st2, min(use_s_dt) min_use_s_dt, min(fee_tm) min_fee_tm "+
				"         from   scd_fee "+
				"         group by rent_mng_id, rent_l_cd, rent_st, rent_seq, tm_st2"+
				"        ) c, "+
				"        taecha d "+
				" where  a.rent_mng_id='"+rent_mng_id+"' and a.rent_l_cd='"+rent_l_cd+"' "+
				"        and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_st='1' "+
				"        and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st "+
				"        and c.rent_st='"+rent_st+"' and c.rent_seq='"+rent_seq+"' "+
				"        and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+) and nvl(d.no,'0')='0'  "+
				"        and c.min_use_s_dt >= '20170421' "+
				"        and (c.min_use_s_dt=b.rent_start_dt or c.min_use_s_dt=d.car_rent_st ) "+
				" ";

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
			if(rs.next())
			{				
				min_fee_tm = rs.getString("min_fee_tm")==null?"":rs.getString("min_fee_tm");
			}

			if(min_fee_tm.equals(fee_tm)){
				day_more_yn = "Y";
			}

			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getScdfeeDayMoreYn]\n"+e);			
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return day_more_yn;
		}	
	}
	
	/**
	 * 확인서 계약일자, 이용기간	조회	2018.1.3
	 * query1 : scd_fee 테이블에서 use_e_dt 가장 큰 값이 존재할 경우 fee 테이블의  rent_end_dt와 일치하는 row의 계약일자(rent_dt), 이용기간(con_mon) 반환
	 * query2 : query1의 값이 null 인 경우 fee 테이블에서 rent_dt가 가장 최근의 계약일자, 이용기간 반환
	 */
	public Vector getRentDtConMon(String rent_mng_id, String rent_l_cd, int gubun) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();


		String query = "";
		String query1 = "";
		String query2 = "";
		
		query = "";

		query1 =	" select rent_dt, rent_start_dt, rent_end_dt from fee where rent_mng_id='"+ rent_mng_id + "' and rent_l_cd='" + rent_l_cd +
					"' and rent_end_dt = (select max(use_e_dt) from scd_fee where rent_mng_id='" +rent_mng_id+"' and rent_l_cd='" + rent_l_cd + "' and bill_yn='Y')";
		
		query2 = " select rent_dt, rent_start_dt, rent_end_dt from fee where rent_mng_id='"+rent_mng_id+"' and rent_l_cd='"+rent_l_cd+"' and rent_dt="+
					"(select max(rent_dt) from fee where rent_mng_id='"+rent_mng_id+"' and rent_l_cd='"+rent_l_cd+"')";
		
		if(gubun == 0){
			query = query1;
		}else {
			query = query2;
		}
		
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
			System.out.println("[AddFeeDatabase:getRentDtConMon]\n"+e);
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
	 *	계약승계 시작일 처리	2018.01.11
	 */			
	public String getRentSucDt(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		String query = "";
		String result = "";

		query = " select rent_suc_dt "+
				" from cont_etc "+
				" where rent_mng_id='"+rent_mng_id+"' and rent_l_cd='"+rent_l_cd+"' "+
				" ";

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
			if(rs.next())
			{				
				result = rs.getString("rent_suc_dt")==null?"":rs.getString("rent_suc_dt");
			}

			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getRentSucDt]\n"+e);			
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return result;
		}	
	}

	/**
	 *	한 건에 대한 대여료 스케줄 쿼리 수정
	 * 제안함 : 스케줄 안내문에 대여료와 선납금 균등발행권 구분요청
	 * 2018.04.13
	 */
	public Vector getFeeScdEmailRentst2(String l_cd, String rent_st, String prv_mon_yn, boolean sun_nap)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String where = "";
		if(prv_mon_yn.equals("0"))	where = " and tm_st2<>'2'";

		query = " select /*+use_hash(a b j)*/ "+
				" A.RENT_MNG_ID, A.RENT_L_CD, A.FEE_TM, A.RENT_ST, A.TM_ST1, A.TM_ST2, A.FEE_EST_DT, A.FEE_S_AMT, A.RENT_SEQ,"+
				" A.FEE_V_AMT, A.RC_YN, A.RC_DT, A.RC_AMT, A.DLY_DAYS, A.DLY_FEE, A.PAY_CNG_DT, A.PAY_CNG_CAU,"+
				" A.R_FEE_EST_DT, A.EXT_DT, decode(sign(B.tm-A.tm_st1), -1,'', 0,'Y') ISLAST, A.use_s_dt, A.use_e_dt, A.tax_out_dt"+
				" from"+
				"("+
					"select RENT_MNG_ID, RENT_L_CD, FEE_TM, RENT_ST, TM_ST1, TM_ST2, RENT_SEQ,"+
					" substr(FEE_EST_DT, 1, 4) || '-' || substr(FEE_EST_DT, 5, 2) || '-'||substr(FEE_EST_DT, 7, 2) FEE_EST_DT,"+
					" FEE_S_AMT, FEE_V_AMT, RC_YN,"+
					" substr(RC_DT, 1, 4) || '-' || substr(RC_DT, 5, 2) || '-'||substr(RC_DT, 7, 2) RC_DT,"+
					" RC_AMT, DLY_DAYS, DLY_FEE,"+
					" substr(PAY_CNG_DT, 1, 4) || '-' || substr(PAY_CNG_DT, 5, 2) || '-'||substr(PAY_CNG_DT, 7, 2) PAY_CNG_DT,"+
					" PAY_CNG_CAU,"+
					" substr(R_FEE_EST_DT, 1, 4) || '-' || substr(R_FEE_EST_DT, 5, 2) || '-'||substr(R_FEE_EST_DT, 7, 2) R_FEE_EST_DT,"+
					" decode(EXT_DT,'','',substr(EXT_DT, 1, 4) || '-' || substr(EXT_DT, 5, 2) || '-'||substr(EXT_DT, 7, 2)) EXT_DT, use_s_dt, use_e_dt, tax_out_dt"+
					" from scd_fee"+
					" where tm_st1='0' and nvl(bill_yn,'Y')='Y' and RENT_L_CD = '"+l_cd+"' and rent_st='"+rent_st+"' "+where+" order by FEE_TM"+
				" ) A,"+
				" ("+
					" select max(rent_mng_id) RENT_MNG_ID, max(rent_l_cd) RENT_L_CD, max(fee_tm) FEE_TM,"+
					" max(to_number(rent_st)) RENT_ST, max(tm_st1) TM_ST1, max(tm_st1) TM"+
					" from scd_fee"+
					" where nvl(bill_yn,'Y')='Y' and RENT_L_CD = '"+l_cd+"' and rent_st='"+rent_st+"' "+where+" and rc_yn = '1' "+
					" group by fee_tm"+
				" ) B"+
				" where"+
				" A.rent_mng_id = B.rent_mng_id(+) and"+
				" A.rent_l_cd = B.rent_l_cd(+) and"+
				" A.rent_st = B.rent_st(+) and"+
				" A.fee_tm = B.fee_tm(+)";
		if(sun_nap){
				query += " and A.TM_ST2 = 4";
		}else{
				query += " and A.TM_ST2 != 4";
		}
				query += " order by to_number(FEE_TM), to_number(TM_ST1)";
		//System.out.println(" "+query);
		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			while(rs.next())
			{
				FeeScdBean fee_scd = new FeeScdBean();
				fee_scd.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_scd.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_scd.setRent_seq(rs.getString("RENT_SEQ")==null?"":rs.getString("RENT_SEQ"));
				fee_scd.setTm_st1(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				fee_scd.setTm_st2(rs.getString("TM_ST2")==null?"":rs.getString("TM_ST2"));
				fee_scd.setFee_est_dt(rs.getString("FEE_EST_DT")==null?"":rs.getString("FEE_EST_DT"));
				fee_scd.setFee_s_amt(rs.getString("FEE_S_AMT")==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee_scd.setFee_v_amt(rs.getString("FEE_V_AMT")==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee_scd.setRc_yn(rs.getString("RC_YN")==null?"":rs.getString("RC_YN"));
				fee_scd.setRc_dt(rs.getString("RC_DT")==null?"":rs.getString("RC_DT"));
				fee_scd.setRc_amt(rs.getString("RC_AMT")==null?0:Integer.parseInt(rs.getString("RC_AMT")));
				fee_scd.setDly_days(rs.getString("DLY_DAYS")==null?"":rs.getString("DLY_DAYS"));
				fee_scd.setDly_fee(rs.getString("DLY_FEE")==null?0:Integer.parseInt(rs.getString("DLY_FEE")));
				fee_scd.setPay_cng_dt(rs.getString("PAY_CNG_DT")==null?"":rs.getString("PAY_CNG_DT"));
				fee_scd.setPay_cng_cau(rs.getString("PAY_CNG_CAU")==null?"":rs.getString("PAY_CNG_CAU"));
				fee_scd.setR_fee_est_dt(rs.getString("R_FEE_EST_DT")==null?"":rs.getString("R_FEE_EST_DT"));
				fee_scd.setIslast(rs.getString("ISLAST")==null?"":rs.getString("ISLAST"));
				fee_scd.setExt_dt(rs.getString("EXT_DT")==null?"":rs.getString("EXT_DT"));
				fee_scd.setUse_s_dt(rs.getString("use_s_dt")==null?"":rs.getString("use_s_dt"));
				fee_scd.setUse_e_dt(rs.getString("use_e_dt")==null?"":rs.getString("use_e_dt"));
				fee_scd.setTax_out_dt(rs.getString("tax_out_dt")==null?"":rs.getString("tax_out_dt"));
				vt.add(fee_scd);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getFeeScdEmailRentst2]\n"+e);
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
	 *	한 건에 대한 대여료 스케줄 쿼리 수정
	 * 제안함 : 스케줄 안내문에 대여료와 선납금 균등발행권 구분요청
	 * 2018.04.13
	 */
	public Vector getFeeScdMail2(String l_cd, boolean sun_nap)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select /*+use_hash(a b j)*/ "+
				" A.RENT_MNG_ID, A.RENT_L_CD, A.FEE_TM, A.RENT_ST, A.TM_ST1, A.TM_ST2, A.FEE_EST_DT, A.FEE_S_AMT, A.RENT_SEQ,"+
				" A.FEE_V_AMT, A.RC_YN, A.RC_DT, A.RC_AMT, A.DLY_DAYS, A.DLY_FEE, A.PAY_CNG_DT, A.PAY_CNG_CAU,"+
				" A.R_FEE_EST_DT, A.EXT_DT, decode(sign(B.tm-A.tm_st1), -1,'', 0,'Y') ISLAST, A.use_s_dt, A.use_e_dt, A.tax_out_dt"+
				" from"+
				"("+
					"select RENT_MNG_ID, RENT_L_CD, FEE_TM, RENT_ST, TM_ST1, TM_ST2, RENT_SEQ,"+
					" substr(FEE_EST_DT, 1, 4) || '-' || substr(FEE_EST_DT, 5, 2) || '-'||substr(FEE_EST_DT, 7, 2) FEE_EST_DT,"+
					" FEE_S_AMT, FEE_V_AMT, RC_YN,"+
					" substr(RC_DT, 1, 4) || '-' || substr(RC_DT, 5, 2) || '-'||substr(RC_DT, 7, 2) RC_DT,"+
					" RC_AMT, DLY_DAYS, DLY_FEE,"+
					" substr(PAY_CNG_DT, 1, 4) || '-' || substr(PAY_CNG_DT, 5, 2) || '-'||substr(PAY_CNG_DT, 7, 2) PAY_CNG_DT,"+
					" PAY_CNG_CAU,"+
					" substr(R_FEE_EST_DT, 1, 4) || '-' || substr(R_FEE_EST_DT, 5, 2) || '-'||substr(R_FEE_EST_DT, 7, 2) R_FEE_EST_DT,"+
					" decode(EXT_DT,'','',substr(EXT_DT, 1, 4) || '-' || substr(EXT_DT, 5, 2) || '-'||substr(EXT_DT, 7, 2)) EXT_DT, use_s_dt, use_e_dt, tax_out_dt"+
					" from scd_fee"+
					" where tm_st1='0' and nvl(bill_yn,'Y')='Y' and RENT_L_CD = '"+l_cd+"' order by FEE_TM"+
				" ) A,"+
				" ("+
					" select max(rent_mng_id) RENT_MNG_ID, max(rent_l_cd) RENT_L_CD, max(fee_tm) FEE_TM,"+
					" max(to_number(rent_st)) RENT_ST, max(tm_st1) TM_ST1, max(tm_st1) TM"+
					" from scd_fee"+
					" where nvl(bill_yn,'Y')='Y' and RENT_L_CD = '"+l_cd+"' and rc_yn = '1' "+
					" group by fee_tm"+
				" ) B"+
				" where"+
				" A.rent_mng_id = B.rent_mng_id(+) and"+
				" A.rent_l_cd = B.rent_l_cd(+) and"+
				" A.rent_st = B.rent_st(+) and"+
				" A.fee_tm = B.fee_tm(+)";
				if(sun_nap){
					query += " and A.TM_ST2 = 4";
				}else{
					query += " and A.TM_ST2 != 4";
				}
				query += " order by to_number(FEE_TM), to_number(TM_ST1)";
		
		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			while(rs.next())
			{
				FeeScdBean fee_scd = new FeeScdBean();
				fee_scd.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_scd.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_scd.setRent_seq(rs.getString("RENT_SEQ")==null?"":rs.getString("RENT_SEQ"));
				fee_scd.setTm_st1(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				fee_scd.setTm_st2(rs.getString("TM_ST2")==null?"":rs.getString("TM_ST2"));
				fee_scd.setFee_est_dt(rs.getString("FEE_EST_DT")==null?"":rs.getString("FEE_EST_DT"));
				fee_scd.setFee_s_amt(rs.getString("FEE_S_AMT")==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee_scd.setFee_v_amt(rs.getString("FEE_V_AMT")==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee_scd.setRc_yn(rs.getString("RC_YN")==null?"":rs.getString("RC_YN"));
				fee_scd.setRc_dt(rs.getString("RC_DT")==null?"":rs.getString("RC_DT"));
				fee_scd.setRc_amt(rs.getString("RC_AMT")==null?0:Integer.parseInt(rs.getString("RC_AMT")));
				fee_scd.setDly_days(rs.getString("DLY_DAYS")==null?"":rs.getString("DLY_DAYS"));
				fee_scd.setDly_fee(rs.getString("DLY_FEE")==null?0:Integer.parseInt(rs.getString("DLY_FEE")));
				fee_scd.setPay_cng_dt(rs.getString("PAY_CNG_DT")==null?"":rs.getString("PAY_CNG_DT"));
				fee_scd.setPay_cng_cau(rs.getString("PAY_CNG_CAU")==null?"":rs.getString("PAY_CNG_CAU"));
				fee_scd.setR_fee_est_dt(rs.getString("R_FEE_EST_DT")==null?"":rs.getString("R_FEE_EST_DT"));
				fee_scd.setIslast(rs.getString("ISLAST")==null?"":rs.getString("ISLAST"));
				fee_scd.setExt_dt(rs.getString("EXT_DT")==null?"":rs.getString("EXT_DT"));
				fee_scd.setUse_s_dt(rs.getString("use_s_dt")==null?"":rs.getString("use_s_dt"));
				fee_scd.setUse_e_dt(rs.getString("use_e_dt")==null?"":rs.getString("use_e_dt"));
				fee_scd.setTax_out_dt(rs.getString("tax_out_dt")==null?"":rs.getString("tax_out_dt"));
				vt.add(fee_scd);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getFeeScdMail2]\n"+e);
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
	 *	선납금 분리 작업 실시 2018.04.16
	 */
	public Vector getFeeScdPrint2(String l_cd, String asc, boolean sun_nap)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select /*+use_hash(a b j)*/ USE_DAY, "+
				" A.RENT_MNG_ID, A.RENT_L_CD, A.FEE_TM, A.RENT_ST, A.TM_ST1, A.TM_ST2, A.FEE_EST_DT, A.FEE_S_AMT, A.RENT_SEQ,"+
				" A.FEE_V_AMT, A.RC_YN, A.RC_DT, A.RC_AMT, A.DLY_DAYS, A.DLY_FEE, A.PAY_CNG_DT, A.PAY_CNG_CAU,"+
				" A.R_FEE_EST_DT, "+
				" decode(sign(B.tm-A.tm_st1), -1,'', 0,'Y') ISLAST, bill_yn,"+
				" j.tax_dt as EXT_DT, A.USE_S_DT, A.USE_E_DT, A.TAX_OUT_DT "+
				" from"+
				"("+
					"select RENT_MNG_ID, RENT_L_CD, FEE_TM, RENT_ST, TM_ST1, TM_ST2, bill_yn,  RENT_SEQ,"+
					" substr(FEE_EST_DT, 1, 4) || '-' || substr(FEE_EST_DT, 5, 2) || '-'||substr(FEE_EST_DT, 7, 2) FEE_EST_DT,"+
					" FEE_S_AMT, FEE_V_AMT, RC_YN,"+
					" substr(RC_DT, 1, 4) || '-' || substr(RC_DT, 5, 2) || '-'||substr(RC_DT, 7, 2) RC_DT,"+
					" RC_AMT, DLY_DAYS, DLY_FEE,"+
					" substr(PAY_CNG_DT, 1, 4) || '-' || substr(PAY_CNG_DT, 5, 2) || '-'||substr(PAY_CNG_DT, 7, 2) PAY_CNG_DT,"+
					" PAY_CNG_CAU,"+
					" substr(R_FEE_EST_DT, 1, 4) || '-' || substr(R_FEE_EST_DT, 5, 2) || '-'||substr(R_FEE_EST_DT, 7, 2) R_FEE_EST_DT,"+
					" decode(EXT_DT,'','',substr(EXT_DT, 1, 4) || '-' || substr(EXT_DT, 5, 2) || '-'||substr(EXT_DT, 7, 2)) EXT_DT,"+
					" to_date( use_e_dt, 'yyyymmdd' ) + 1 - to_date( use_s_dt, 'yyyymmdd' ) as USE_DAY, "+
					" substr(USE_S_DT, 1, 4) || '-' || substr(USE_S_DT, 5, 2) || '-'||substr(USE_S_DT, 7, 2) USE_S_DT,"+
					" substr(USE_E_DT, 1, 4) || '-' || substr(USE_E_DT, 5, 2) || '-'||substr(USE_E_DT, 7, 2) USE_E_DT,"+
					" substr(TAX_OUT_DT, 1, 4) || '-' || substr(TAX_OUT_DT, 5, 2) || '-'||substr(TAX_OUT_DT, 7, 2) TAX_OUT_DT"+
					" from scd_fee"+
					" where RENT_L_CD = '"+l_cd+"' order by FEE_TM"+//nvl(bill_yn,'Y')='Y' and 
				" ) A,"+
				" ("+
					" select max(rent_mng_id) RENT_MNG_ID, max(rent_l_cd) RENT_L_CD, max(fee_tm) FEE_TM,"+
					" max(to_number(rent_st)) RENT_ST, max(tm_st1) TM_ST1, max(tm_st1) TM"+
					" from scd_fee"+
					" where RENT_L_CD = '"+l_cd+"' and rc_yn = '1' "+//nvl(bill_yn,'Y')='Y' and 
					" group by fee_tm"+
				" ) B, "+
					 "        ( select a.rent_l_cd, a.rent_st, a.rent_seq, a.tm as fee_tm, sum(item_supply) fee_s_amt, \n"+
					 "                 max(b.item_id) item_id, max(b.item_dt) item_dt, max(b.tax_est_dt) tax_est_dt, \n"+
					 "                 decode(sum(c.tax_supply),0,'',max(c.tax_no)) tax_no, "+
					 "		           decode(sum(c.tax_supply),0,'',max(c.tax_dt)) tax_dt, "+
					 "	               decode(sum(c.tax_supply),0,'',max(c.reg_dt)) reg_dt, "+
					 "	               decode(sum(c.tax_supply),0,'',max(c.print_dt)) print_dt \n"+
					 "          from   tax_item_list a, tax_item b, tax c \n"+
					 "          where  a.rent_l_cd='"+l_cd+"' and a.gubun='1' \n"+
					 "                 and a.item_id=b.item_id and a.item_id=c.item_id(+) and nvl(c.tax_st,'O')<>'C' \n"+
					 "          group by a.rent_l_cd, a.rent_st, a.rent_seq, a.tm \n"+
					 "          having sum(item_supply) > 0 "+			
					 "	      ) j \n"+


				" where"+
				" A.rent_mng_id = B.rent_mng_id(+) and"+
				" A.rent_l_cd = B.rent_l_cd(+) and"+
				" A.rent_st = B.rent_st(+) and"+
				" A.fee_tm = B.fee_tm(+)"+
				" and A.rent_l_cd=j.rent_l_cd(+) and A.fee_tm=j.fee_tm(+) and A.rent_st=j.rent_st(+) and A.rent_seq=j.rent_seq(+)";
				if(sun_nap){
					query += " and A.TM_ST2 = 4";
				}else{
					query += " and A.TM_ST2 != 4";
				}
				query += " order by rent_seq, to_number(FEE_TM) "+asc+", to_number(TM_ST1) "+asc+" ";
		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	

			while(rs.next())
			{
				FeeScdBean fee_scd = new FeeScdBean();
				fee_scd.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_scd.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_scd.setRent_seq(rs.getString("RENT_SEQ")==null?"":rs.getString("RENT_SEQ"));
				fee_scd.setTm_st1(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				fee_scd.setTm_st2(rs.getString("TM_ST2")==null?"":rs.getString("TM_ST2"));
				fee_scd.setFee_est_dt(rs.getString("FEE_EST_DT")==null?"":rs.getString("FEE_EST_DT"));
				fee_scd.setFee_s_amt(rs.getString("FEE_S_AMT")==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee_scd.setFee_v_amt(rs.getString("FEE_V_AMT")==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee_scd.setRc_yn(rs.getString("RC_YN")==null?"":rs.getString("RC_YN"));
				fee_scd.setRc_dt(rs.getString("RC_DT")==null?"":rs.getString("RC_DT"));
				fee_scd.setRc_amt(rs.getString("RC_AMT")==null?0:Integer.parseInt(rs.getString("RC_AMT")));
				fee_scd.setDly_days(rs.getString("DLY_DAYS")==null?"":rs.getString("DLY_DAYS"));
				fee_scd.setDly_fee(rs.getString("DLY_FEE")==null?0:Integer.parseInt(rs.getString("DLY_FEE")));
				fee_scd.setPay_cng_dt(rs.getString("PAY_CNG_DT")==null?"":rs.getString("PAY_CNG_DT"));
				fee_scd.setPay_cng_cau(rs.getString("PAY_CNG_CAU")==null?"":rs.getString("PAY_CNG_CAU"));
				fee_scd.setR_fee_est_dt(rs.getString("R_FEE_EST_DT")==null?"":rs.getString("R_FEE_EST_DT"));
				fee_scd.setIslast(rs.getString("ISLAST")==null?"":rs.getString("ISLAST"));
				fee_scd.setExt_dt(rs.getString("EXT_DT")==null?"":rs.getString("EXT_DT"));
				fee_scd.setBill_yn(rs.getString("bill_yn")==null?"":rs.getString("bill_yn"));
				fee_scd.setUse_day(rs.getString("USE_DAY")==null?"":rs.getString("USE_DAY"));
				fee_scd.setTax_out_dt(rs.getString("TAX_OUT_DT")==null?"":rs.getString("TAX_OUT_DT"));
				vt.add(fee_scd);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getFeeScd2]\n"+e);
			System.out.println("[AddFeeDatabase:getFeeScd2]\n"+query);
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
	 *	대여료스케줄 통계(건별) - 연체료 수금 포함(2003-07-25)
	 * 선납금 제외 2018.04.16
	 */
	public Hashtable getFeeScdStatPrint2(String m_id, String l_cd){
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		query = " select"+
				" max(NC) NC, max(NS) NS, max(NV) NV,"+//미수금
				" max(RC) RC, max(RS) RS, max(RV) RV,"+//수금
				" max(MC) MC, max(MS) MS, max(MV) MV,"+//미도래분
				" max(DC) DC, max(DT) DT, "+//연체
				" max(DT2) DT2"+//연체-수금
				" from"+
				" ("+
					//미수금
					" select count(0) NC, sum(fee_s_amt) NS, sum(fee_v_amt) NV, 0 RC, 0 RS, 0 RV, 0 MC, 0 MS, 0 MV, 0 DC, 0 DT, 0 DT2"+
					" from scd_fee"+
					" where rc_yn = '0' and r_fee_est_dt <= to_char(sysdate,'YYYYMMDD') and "+//nvl(bill_yn,'Y')='Y' and 
					" rent_mng_id = '"+m_id+"' and rent_l_cd='"+l_cd+"' and tm_st2 != 4"+
					" union"+
					//수금
					" select 0 NC, 0 NS, 0 NV, count(0) RC, sum(trunc(rc_amt/1.1)) RS, sum(rc_amt-trunc(rc_amt/1.1)) RV, 0 MC, 0 MS, 0 MV, 0 DC, 0 DT, 0 DT2"+
					" from scd_fee"+
					" where rc_yn = '1' and"+//nvl(bill_yn,'Y')='Y' and 
					" rent_mng_id = '"+m_id+"' and rent_l_cd='"+l_cd+"' and tm_st2 != 4"+
					" union"+
					//미도래분
					" select 0 NC, 0 NS, 0 NV, 0 RC, 0 RS, 0 RV, count(0) MC, sum(fee_s_amt) MS, sum(fee_v_amt) MV, 0 DC, 0 DT, 0 DT2"+
					" from scd_fee"+
					" where rc_yn = '0' and r_fee_est_dt > to_char(sysdate,'YYYYMMDD') and "+//nvl(bill_yn,'Y')='Y' and 
					" rent_mng_id = '"+m_id+"' and rent_l_cd='"+l_cd+"' and tm_st2 != 4"+
					" union"+
					//연체료
					" select 0 NC, 0 NS, 0 NV, 0 RC, 0 RS, 0 RV, 0 MC, 0 MS, 0 MV, count(0) DC, sum(dly_fee) DT, 0 DT2"+
					" from scd_fee"+
					" where rent_mng_id = '"+m_id+"' and rent_l_cd='"+l_cd+"' and "+
					" dly_fee > 0 and tm_st2 != 4"+
					" union"+
					//연체료-수금
					" select 0 NC, 0 NS, 0 NV, 0 RC, 0 RS, 0 RV, 0 MC, 0 MS, 0 MV, 0 DC, 0 DT, sum(pay_amt) DT2"+
					" from scd_dly"+
					" where rent_mng_id = '"+m_id+"' and rent_l_cd='"+l_cd+"'"+
				" )";
		
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
			System.out.println("[AddFeeDatabase:getFeeScdStatPrint2]\n"+e);
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
	 *	한 건에 대한 대여료 스케줄 쿼리
	 * 선납금 분할 작업 2018.04.16
	 */
	public Vector getFeeScdNew2(String m_id, String l_cd, String b_dt, String mode, String bill_yn, boolean sun_nap){
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";

		if(b_dt.equals("")){
			b_dt = "to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')";
		}else{
			b_dt = "to_date(replace('"+b_dt+"','-',''),'YYYYMMDD')";
		}

		if(mode.equals("ALL")){
			sub_query = " a.rent_mng_id='"+m_id+"'";
		}else{
			sub_query = " a.rent_mng_id='"+m_id+"' and a.rent_l_cd='"+l_cd+"'";
		}
			
		if(!bill_yn.equals("")){
			sub_query += " and nvl(a.bill_yn,'Y')='"+bill_yn+"'";
		}

		query = " select"+
				" rent_mng_id, rent_l_cd, fee_tm, rent_st, rent_seq, tm_st1, tm_st2,"+
				" use_s_dt, use_e_dt, fee_est_dt, r_fee_est_dt, fee_s_amt, fee_v_amt, (fee_s_amt+fee_v_amt) fee_amt,"+
				" rc_yn, rc_dt, rc_amt, decode(sign(dly_day),-1,0,dly_day) dly_days, decode(sign(dly_day),-1,0,dly_amt) dly_fee,"+
				" bill_yn, tax_dt, tax_out_dt, req_dt, adate, pay_st"+
				" from"+
				"     ("+
				"         select"+
				"         a.*, b.tax_dt,"+
				"         TRUNC(NVL(TO_DATE(a.rc_dt, 'YYYYMMDD'), "+b_dt+") - TO_DATE(a.r_fee_est_dt, 'YYYYMMDD')) as dly_day,"+
				"         (TRUNC(((decode(a.rc_amt,0,a.fee_s_amt+a.fee_v_amt,a.rc_amt))*decode(sign(decode(c.rent_suc_dt,'',d.rent_dt,c.rent_suc_dt)-'20220101'),-1,0.24,0.20)*TRUNC(TO_DATE(a.r_fee_est_dt, 'YYYYMMDD')- NVL(TO_DATE(a.rc_dt, 'YYYYMMDD'), "+b_dt+")))/365) * -1) as dly_amt"+
				"         from scd_fee a,"+
					 "        ( select a.rent_l_cd, a.rent_st, a.rent_seq, a.tm as fee_tm, sum(item_supply) fee_s_amt, \n"+
					 "                 max(b.item_id) item_id, max(b.item_dt) item_dt, max(b.tax_est_dt) tax_est_dt, \n"+
					 "                 decode(sum(c.tax_supply),0,'',max(c.tax_no)) tax_no, "+
					 "		           decode(sum(c.tax_supply),0,'',max(c.tax_dt)) tax_dt, "+
					 "	               decode(sum(c.tax_supply),0,'',max(c.reg_dt)) reg_dt, "+
					 "	               decode(sum(c.tax_supply),0,'',max(c.print_dt)) print_dt \n"+
					 "          from   tax_item_list a, tax_item b, tax c \n"+
					 "          where  a.rent_l_cd='"+l_cd+"' and a.gubun='1' \n"+
					 "                 and a.item_id=b.item_id and a.item_id=c.item_id(+) and nvl(c.tax_st,'O')<>'C' \n"+
					 "          group by a.rent_l_cd, a.rent_st, a.rent_seq, a.tm \n"+
					 "          having sum(item_supply) > 0 "+			
					 "	      ) b, \n"+
				"         fee d, cont_etc c "+
				"         where "+sub_query+
				"         and a.rent_l_cd=b.rent_l_cd(+) and a.fee_tm=b.fee_tm(+) and a.rent_st=b.rent_st(+) and a.rent_seq=b.rent_seq(+)"+
				"         and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd and a.rent_st=d.rent_st and a.rent_l_cd=c.rent_l_cd ";
				if(sun_nap){
					query += " and a.tm_st2 = 4";
				}else{
					query += " and a.tm_st2 != 4";
				}
				query += "     ) order by to_number(fee_tm), to_number(tm_st1) ";
		//System.out.println("[[" + query);
		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    
	    	
			while(rs.next())
			{
				FeeScdBean fee_scd = new FeeScdBean();
				fee_scd.setRent_mng_id	(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd	(rs.getString("RENT_L_CD")	==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm		(rs.getString("FEE_TM")		==null?"":rs.getString("FEE_TM"));
				fee_scd.setRent_st		(rs.getString("RENT_ST")	==null?"":rs.getString("RENT_ST"));
				fee_scd.setTm_st1		(rs.getString("TM_ST1")		==null?"":rs.getString("TM_ST1"));
				fee_scd.setTm_st2		(rs.getString("TM_ST2")		==null?"":rs.getString("TM_ST2"));
				fee_scd.setFee_est_dt	(rs.getString("FEE_EST_DT")	==null?"":rs.getString("FEE_EST_DT"));
				fee_scd.setFee_s_amt	(rs.getString("FEE_S_AMT")	==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee_scd.setFee_v_amt	(rs.getString("FEE_V_AMT")	==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee_scd.setRc_yn		(rs.getString("RC_YN")		==null?"":rs.getString("RC_YN"));
				fee_scd.setRc_dt		(rs.getString("RC_DT")		==null?"":rs.getString("RC_DT"));
				fee_scd.setRc_amt		(rs.getString("RC_AMT")		==null?0:Integer.parseInt(rs.getString("RC_AMT")));
				fee_scd.setDly_days		(rs.getString("DLY_DAYS")	==null?"":rs.getString("DLY_DAYS"));
				fee_scd.setDly_fee		(rs.getString("DLY_FEE")	==null?0:Integer.parseInt(rs.getString("DLY_FEE")));
				fee_scd.setR_fee_est_dt	(rs.getString("R_FEE_EST_DT")==null?"":rs.getString("R_FEE_EST_DT"));
				fee_scd.setExt_dt		(rs.getString("TAX_DT")		==null?"":rs.getString("TAX_DT"));
				fee_scd.setBill_yn		(rs.getString("bill_yn")	==null?"":rs.getString("bill_yn"));
				fee_scd.setUse_s_dt		(rs.getString("USE_S_DT")	==null?"":rs.getString("USE_S_DT"));
				fee_scd.setUse_e_dt		(rs.getString("USE_E_DT")	==null?"":rs.getString("USE_E_DT"));
				fee_scd.setTax_out_dt	(rs.getString("TAX_OUT_DT")==null?"":rs.getString("TAX_OUT_DT"));
				vt.add(fee_scd);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getFeeScdNew2]\n"+e);
			System.out.println("[AddFeeDatabase:getFeeScdNew2]\n"+query);
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
	 * 계약사항 : 대여료 - 이메일 - 대여료스케줄안내문 팝업에서 연장 구분을 선택한 경우 rent_st로 case를 구분
	 * 2018.04.24
	 */
	public Vector getFeeScdNew3(String m_id, String l_cd, String b_dt, String mode, String bill_yn, String rent_st, boolean sun_nap){
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";
		String sub_query2 = "";

		if(b_dt.equals("")){
			b_dt = "to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')";
		}else{
			b_dt = "to_date(replace('"+b_dt+"','-',''),'YYYYMMDD')";
		}

		if(mode.equals("ALL")){
			sub_query = " a.rent_mng_id='"+m_id+"'";
		}else{
			sub_query = " a.rent_mng_id='"+m_id+"' and a.rent_l_cd='"+l_cd+"'";
		}
			
		if(!bill_yn.equals("")){
			sub_query += " and nvl(a.bill_yn,'Y')='"+bill_yn+"'";
		}
//System.out.println(" "+rent_st);
		if(rent_st.equals("all")){
			sub_query2 = " "; 
		}else{
			sub_query2 = " and a.rent_st = "+rent_st;
		}

		query = " select"+
				" rent_mng_id, rent_l_cd, fee_tm, rent_st, rent_seq, tm_st1, tm_st2,"+
				" use_s_dt, use_e_dt, fee_est_dt, r_fee_est_dt, fee_s_amt, fee_v_amt, (fee_s_amt+fee_v_amt) fee_amt,"+
				" rc_yn, rc_dt, rc_amt, decode(sign(dly_day),-1,0,dly_day) dly_days, decode(sign(dly_day),-1,0,dly_amt) dly_fee,"+
				" bill_yn, tax_dt, tax_out_dt, req_dt, adate, pay_st"+
				" from"+
				"     ("+
				"         select"+
				"         a.*, b.tax_dt,"+
				"         TRUNC(NVL(TO_DATE(a.rc_dt, 'YYYYMMDD'), "+b_dt+") - TO_DATE(a.r_fee_est_dt, 'YYYYMMDD')) as dly_day,"+
				"         (TRUNC(((decode(a.rc_amt,0,a.fee_s_amt+a.fee_v_amt,a.rc_amt))*decode(sign(decode(c.rent_suc_dt,'',d.rent_dt,c.rent_suc_dt)-'20220101'),-1,0.24,0.20)*TRUNC(TO_DATE(a.r_fee_est_dt, 'YYYYMMDD')- NVL(TO_DATE(a.rc_dt, 'YYYYMMDD'), "+b_dt+")))/365) * -1) as dly_amt"+
				"         from scd_fee a,"+
					 "        ( select a.rent_l_cd, a.rent_st, a.rent_seq, a.tm as fee_tm, sum(item_supply) fee_s_amt, \n"+
					 "                 max(b.item_id) item_id, max(b.item_dt) item_dt, max(b.tax_est_dt) tax_est_dt, \n"+
					 "                 decode(sum(c.tax_supply),0,'',max(c.tax_no)) tax_no, "+
					 "		           decode(sum(c.tax_supply),0,'',max(c.tax_dt)) tax_dt, "+
					 "	               decode(sum(c.tax_supply),0,'',max(c.reg_dt)) reg_dt, "+
					 "	               decode(sum(c.tax_supply),0,'',max(c.print_dt)) print_dt \n"+
					 "          from   tax_item_list a, tax_item b, tax c \n"+
					 "          where  a.rent_l_cd='"+l_cd+"' and a.gubun='1' \n"+
					 "                 and a.item_id=b.item_id and a.item_id=c.item_id(+) and nvl(c.tax_st,'O')<>'C' \n"+
					 "          group by a.rent_l_cd, a.rent_st, a.rent_seq, a.tm \n"+
					 "          having sum(item_supply) > 0 "+			
					 "	      ) b, \n"+
				"         fee d, cont_etc c "+
				"         where "+sub_query+
				"         and a.rent_l_cd=b.rent_l_cd(+) and a.fee_tm=b.fee_tm(+) and a.rent_st=b.rent_st(+) and a.rent_seq=b.rent_seq(+)"+
				"         and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd and a.rent_st=d.rent_st and a.rent_l_cd=c.rent_l_cd "+sub_query2;
				if(sun_nap){
					query += " and a.tm_st2 = 4";
				}else{
					query += " and a.tm_st2 != 4";
				}
				query += "     ) order by to_number(fee_tm), to_number(tm_st1) ";
		//System.out.println("[[" + query);
		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    
	    	
			while(rs.next())
			{
				FeeScdBean fee_scd = new FeeScdBean();
				fee_scd.setRent_mng_id	(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd	(rs.getString("RENT_L_CD")	==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm		(rs.getString("FEE_TM")		==null?"":rs.getString("FEE_TM"));
				fee_scd.setRent_st		(rs.getString("RENT_ST")	==null?"":rs.getString("RENT_ST"));
				fee_scd.setTm_st1		(rs.getString("TM_ST1")		==null?"":rs.getString("TM_ST1"));
				fee_scd.setTm_st2		(rs.getString("TM_ST2")		==null?"":rs.getString("TM_ST2"));
				fee_scd.setFee_est_dt	(rs.getString("FEE_EST_DT")	==null?"":rs.getString("FEE_EST_DT"));
				fee_scd.setFee_s_amt	(rs.getString("FEE_S_AMT")	==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee_scd.setFee_v_amt	(rs.getString("FEE_V_AMT")	==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee_scd.setRc_yn		(rs.getString("RC_YN")		==null?"":rs.getString("RC_YN"));
				fee_scd.setRc_dt		(rs.getString("RC_DT")		==null?"":rs.getString("RC_DT"));
				fee_scd.setRc_amt		(rs.getString("RC_AMT")		==null?0:Integer.parseInt(rs.getString("RC_AMT")));
				fee_scd.setDly_days		(rs.getString("DLY_DAYS")	==null?"":rs.getString("DLY_DAYS"));
				fee_scd.setDly_fee		(rs.getString("DLY_FEE")	==null?0:Integer.parseInt(rs.getString("DLY_FEE")));
				fee_scd.setR_fee_est_dt	(rs.getString("R_FEE_EST_DT")==null?"":rs.getString("R_FEE_EST_DT"));
				fee_scd.setExt_dt		(rs.getString("TAX_DT")		==null?"":rs.getString("TAX_DT"));
				fee_scd.setBill_yn		(rs.getString("bill_yn")	==null?"":rs.getString("bill_yn"));
				fee_scd.setUse_s_dt		(rs.getString("USE_S_DT")	==null?"":rs.getString("USE_S_DT"));
				fee_scd.setUse_e_dt		(rs.getString("USE_E_DT")	==null?"":rs.getString("USE_E_DT"));
				fee_scd.setTax_out_dt	(rs.getString("TAX_OUT_DT")==null?"":rs.getString("TAX_OUT_DT"));
				vt.add(fee_scd);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getFeeScdNew3]\n"+e);
			System.out.println("[AddFeeDatabase:getFeeScdNew3]\n"+query);
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
	 *	대여료스케줄 통계(건별)
	 * 2018.04.24
	 * 계약관리 - 대여료 - 대여료스케줄안내문 팝업에서 연장 구분으로 선택하여 미리보기 할 경우 
	 * 장기대여 스케줄 안내문 하단 대여료 통계의 연체료가 해당하는 연장 건에만 출력되도록 한다
	 */
	public Hashtable getFeeScdStatNew2(String m_id, String l_cd, String b_dt, String mode, String bill_yn, String rent_st)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();

		String sub_query = "";
		String sub_query2 = "";
		String sub_query3 = "";

		if(b_dt.equals("")){
			b_dt = "to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')";
		}else{
			b_dt = "to_date(replace('"+b_dt+"','-',''),'YYYYMMDD')";
		}

		if(mode.equals("ALL")){
			sub_query = " rent_mng_id='"+m_id+"'";
		}else{
			sub_query = " rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"'";
		}

		sub_query2 = sub_query;
			
		if(!bill_yn.equals("")){
			sub_query += " and nvl(bill_yn,'Y')='"+bill_yn+"'";
		}
		
		if(rent_st.equals("all")||rent_st.equals("")){
			sub_query3 = "";
		}else{
			sub_query3 = "and a.rent_st = "+rent_st;
		}
		
		String query = "";
		query = " select"+
				" max(NC) NC, max(NS) NS, max(NV) NV,"+//미수금
				" max(RC) RC, max(RS) RS, max(RV) RV,"+//수금
				" max(MC) MC, max(MS) MS, max(MV) MV,"+//미도래분
				" sum(DC) DC, sum(DT) DT, "+//연체
				" max(DT2) DT2"+//연체-수금
				" from"+
				" ( \n"+
					//미수금
					" select count(0) NC, sum(fee_s_amt) NS, sum(fee_v_amt) NV, 0 RC, 0 RS, 0 RV, 0 MC, 0 MS, 0 MV, 0 DC, 0 DT, 0 DT2"+
					" from scd_fee"+
					" where rc_yn = '0' and r_fee_est_dt <= to_char(sysdate,'YYYYMMDD') and "+sub_query+
					"  \n union \n"+
					//수금
					" select 0 NC, 0 NS, 0 NV, count(0) RC, sum(trunc(rc_amt/1.1)) RS, sum(rc_amt-trunc(rc_amt/1.1)) RV, 0 MC, 0 MS, 0 MV, 0 DC, 0 DT, 0 DT2"+
					" from scd_fee"+
					" where rc_yn = '1' and "+sub_query+
					"  \n union \n"+
					//미도래분
					" select 0 NC, 0 NS, 0 NV, 0 RC, 0 RS, 0 RV, count(0) MC, sum(fee_s_amt) MS, sum(fee_v_amt) MV, 0 DC, 0 DT, 0 DT2"+
					" from scd_fee"+
					" where rc_yn = '0' and r_fee_est_dt > to_char(sysdate,'YYYYMMDD') and "+sub_query+
					"  \n union \n"+
					//연체료 0.18
					" select 0 NC, 0 NS, 0 NV, 0 RC, 0 RS, 0 RV, 0 MC, 0 MS, 0 MV, count(0) DC, sum(decode(bill_yn,'Y',(TRUNC(((decode(rc_amt,0,fee_s_amt+fee_v_amt,rc_amt))*0.24*TRUNC(TO_DATE(r_fee_est_dt, 'YYYYMMDD')- NVL(TO_DATE(rc_dt, 'YYYYMMDD'), "+b_dt+")))/365) * -1),dly_fee)) DT, 0 DT2"+
					" from scd_fee"+
					" where "+sub_query+" and"+
					" nvl(to_number(dly_days), 0) > 0 "+
					" and (rent_l_cd, rent_mng_id, rent_st) in (select a.rent_l_cd, a.rent_mng_id, a.rent_st from fee a, cont b, cont_etc c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and decode(c.rent_suc_dt,'',decode(a.rent_st,'1',b.rent_dt,a.rent_dt),c.rent_suc_dt) < '20220101')"+
					"  \n union \n"+
					//연체료 0.24
					" select 0 NC, 0 NS, 0 NV, 0 RC, 0 RS, 0 RV, 0 MC, 0 MS, 0 MV, count(0) DC, sum(decode(bill_yn,'Y',(TRUNC(((decode(rc_amt,0,fee_s_amt+fee_v_amt,rc_amt))*0.20*TRUNC(TO_DATE(r_fee_est_dt, 'YYYYMMDD')- NVL(TO_DATE(rc_dt, 'YYYYMMDD'), "+b_dt+")))/365) * -1),dly_fee)) DT, 0 DT2"+
					" from scd_fee"+
					" where "+sub_query+" and"+
					" nvl(to_number(dly_days), 0) > 0 "+
					" and (rent_l_cd, rent_mng_id, rent_st) in (select a.rent_l_cd, a.rent_mng_id, a.rent_st from fee a, cont b, cont_etc c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and decode(c.rent_suc_dt,'',decode(a.rent_st,'1',b.rent_dt,a.rent_dt),c.rent_suc_dt) >= '20220101' "+sub_query3+")"+
					"  \n union \n"+
					//연체료-수금
					" select 0 NC, 0 NS, 0 NV, 0 RC, 0 RS, 0 RV, 0 MC, 0 MS, 0 MV, 0 DC, 0 DT, sum(pay_amt) DT2"+
					" from scd_dly"+
					" where "+sub_query2+
				" \n )";

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
			System.out.println("[AddFeeDatabase:getFeeScdStatNew2]\n"+e);
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
	 *	//acms 테이블에서 입금미반영, 출금금액이 있는 출금의뢰일 조회하기
	 */
	public Vector getACmsDateClientList(String client_id, String r_site, String s_yy, String s_mm)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String search_dt = "";

		query = " select "+
				"        a.*, c.rent_mng_id, c.rent_l_cd, d.firm_nm, e.car_no, b.nm"+
				" from   cms.file_ea21  a, (select * from code where c_st='0003') b,"+
				"        cont c, client d, car_reg e"+
				" where  a.user_no in (select rent_l_cd from cont where client_id='"+client_id+"') "+
				"        and a.bank_code=b.cms_bk(+) and a.user_no=c.rent_l_cd and c.client_id=d.client_id and c.car_mng_id=e.car_mng_id(+)";

		if(!r_site.equals(""))		query += " and c.r_site='"+r_site+"'";

		search_dt = "a.adate";

		if(!s_yy.equals("") && !s_mm.equals(""))	query += " and "+search_dt+" like '%"+s_yy+s_mm+"%'";
		if(!s_yy.equals("") && s_mm.equals(""))		query += " and "+search_dt+" like '%"+s_yy+"%'";


		query += " order by a.adate";


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
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getACmsDateClientList]\n"+e);
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
	 *	거래처별 스케줄 최근 리스트
	 */
	public Vector getClientContScdList(String client_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT c.t_use_s_dt, c.t_use_e_dt, c.t_fee_s_amt, c.t_fee_v_amt, d.car_no, d.car_nm, b.* \n"+
				" FROM   cont a, scd_fee b, car_reg d,  \n"+
				"        (SELECT rent_mng_id, rent_l_cd, min(TO_NUMBER(fee_tm)) fee_tm,  \n"+
				"                min(use_s_dt) t_use_s_dt, MAX(use_e_dt) t_use_e_dt,  \n"+
				"                SUM(fee_s_amt) t_fee_s_amt, SUM(fee_v_amt) t_fee_v_amt \n"+
				"         FROM   scd_fee  \n"+
				"         where  bill_yn='Y' AND tm_st1='0' AND rc_yn='0' \n"+
				"         GROUP BY rent_mng_id, rent_l_cd) c \n"+
				" WHERE  a.client_id='"+client_id+"' AND a.use_yn='Y'  \n"+
				"        AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd \n"+
				"        AND b.rent_mng_id=c.rent_mng_id AND b.rent_l_cd=c.rent_l_cd AND b.fee_tm=c.fee_tm \n"+
				"        and a.car_mng_id=d.car_mng_id "+
				" ORDER BY b.rent_seq, b.fee_est_dt, a.rent_dt  ";


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
		} catch (SQLException e) {
			System.out.println("[AddFeeDatabase:getClientContScdList]\n"+e);
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
	 *	한회차 대여료 update
	 */
	public boolean updateFeeScdBill(FeeScdBean fee_scd)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = " update scd_fee set "+
						" BILL_YN = ? "+
						" where "+
						" RENT_MNG_ID = ? and"+
						" RENT_L_CD = ? and"+
						" FEE_TM = ? and"+
						" RENT_ST = ? and"+
						" RENT_SEQ = ? and"+
						" TM_ST1 = ? ";
		
		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1 , fee_scd.getBill_yn());
			pstmt.setString(2, fee_scd.getRent_mng_id());
			pstmt.setString(3, fee_scd.getRent_l_cd());
			pstmt.setString(4, fee_scd.getFee_tm());
			pstmt.setString(5, fee_scd.getRent_st());
			pstmt.setString(6, fee_scd.getRent_seq());
			pstmt.setString(7, fee_scd.getTm_st1());
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
				
	  	} catch (Exception e) {
			System.out.println("[AddFeeDatabase:updateFeeScdBill]\n"+e);
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
	
	public Hashtable getFeeScdSunNapStat(String m_id, String l_cd){
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		query = "SELECT  \n " +
			" MAX(PC) PC,     MAX(PS) PS,     MAX(PV) PV, \n " + // 발행
			" MAX(NPC) NPC, MAX(NPS) NPS, MAX(NPV) NPV \n " + // 미발행
			" FROM ( \n " + //  발행
			"	SELECT COUNT(0) PC, SUM(A.FEE_S_AMT) PS, SUM(A.FEE_V_AMT) PV, 0 NPC, 0 NPS, 0 NPV \n " +
			"	FROM \n " +
			" 	( \n " +
			" 		SELECT *  \n " +
			" 		FROM SCD_FEE  \n " +
			" 		WHERE RENT_L_CD = '"+l_cd+"' \n " +
			" 		AND RENT_MNG_ID = '"+m_id+"' \n " +
			" 		AND TM_ST2 = 4 \n " +
			" ) A,  \n " +
			" ( \n " +
			" SELECT a.rent_l_cd, a.rent_st, a.rent_seq, a.tm as fee_tm,  \n " +
            "     decode(sum(c.tax_supply),0,'',max(c.tax_dt)) tax_dt \n " +
            " FROM tax_item_list a, tax_item b, tax c \n " +
            " WHERE a.rent_l_cd='"+l_cd+"' and a.gubun='1'  \n " +
            " AND a.item_id=b.item_id  \n " +
            " AND a.item_id=c.item_id(+)  \n " +
            " AND nvl(c.tax_st,'O')<>'C'  \n " +
            " GROUP BY a.rent_l_cd, a.rent_st, a.rent_seq, a.tm  \n " +
            " HAVING sum(item_supply) > 0   \n " +
            " ) j \n " +
            " WHERE A.rent_l_cd=j.rent_l_cd(+)  \n " +
            " AND A.fee_tm=j.fee_tm(+)  \n " +
            " AND A.rent_st=j.rent_st(+)  \n " +
            " AND A.rent_seq=j.rent_seq(+) \n " +
            " AND j.tax_dt <= to_char(sysdate,'YYYYMMDD') \n " +
            " UNION \n " +
     		" SELECT 0 PC, 0 PS, 0 PV, COUNT(0) NPC, SUM(A.FEE_S_AMT) NPS, SUM(A.FEE_V_AMT) NPV \n " + // 미발행
     		"	FROM  \n " +
     		"	( \n " +
		    "      SELECT *  \n " +
		    "        FROM SCD_FEE  \n " +
		    "        WHERE RENT_L_CD = '"+l_cd+"' \n " +
		    " 		 AND RENT_MNG_ID = '"+m_id+"' \n " +
		    "        AND TM_ST2 = 4 \n " +
		    "    ) A,  \n " +
		    "    ( \n " +
		    "      SELECT a.rent_l_cd, a.rent_st, a.rent_seq, a.tm as fee_tm,  \n " +
		    "               decode(sum(c.tax_supply),0,'',max(c.tax_dt)) tax_dt \n " +
		    "           FROM tax_item_list a, tax_item b, tax c \n " +
		    "           WHERE a.rent_l_cd='"+l_cd+"' and a.gubun='1'  \n " +
		    "           AND a.item_id=b.item_id  \n " +
		    "           AND a.item_id=c.item_id(+)  \n " +
		    "           AND nvl(c.tax_st,'O')<>'C'  \n " +
		    "           GROUP BY a.rent_l_cd, a.rent_st, a.rent_seq, a.tm  \n " +
		    "           HAVING sum(item_supply) > 0   \n " +
		    "    ) j \n " +
		    "  WHERE A.rent_l_cd=j.rent_l_cd(+)  \n " +
		    "   AND A.fee_tm=j.fee_tm(+)  \n " +
		    "   AND A.rent_st=j.rent_st(+)  \n " +
		    "   AND A.rent_seq=j.rent_seq(+) \n " +
		    "   AND j.tax_dt IS NULL \n " +
		    " ) ";
		
		try{
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
	    	ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next()){				
				for(int pos = 1; pos <= rsmd.getColumnCount(); pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
			}
			rs.close();
			stmt.close();
		}catch(SQLException  e){
			System.out.println("[AddFeeDatabase: getFeeScdSunNapStat]: " + e);
	  		e.printStackTrace();
		} finally{
			try {
				if(rs != null)		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}
	
		//대여료스케줄 엑셀처리
		public String call_sp_scd_fee_cng(String reg_code)
		{
			getConnection();

			CallableStatement cstmt = null;
			String sResult = "";
	        
	    	String query1 = "{CALL P_SCD_FEE_CNG     (?)}";
			
			try {

				//회계처리 프로시저1 호출(조회등록)
				cstmt = conn.prepareCall(query1);				
				cstmt.setString(1, reg_code);
				cstmt.execute();
				cstmt.close();

			} catch (SQLException e) {
				System.out.println("[AddFeeDatabase:call_sp_scd_fee_cng]"+ e);
		  		e.printStackTrace();
			} finally {
				try{
			                if(cstmt != null)	cstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return sResult;
			}
		}	
		
		/**
		 *	스케줄변경이력 삭제
		 */ 
		public boolean dropFeeScdAllCase(String m_id, String l_cd, String rent_st, String rent_seq)
		{
			getConnection();
			boolean flag = true;
			PreparedStatement pstmt = null;

			String query = " delete from scd_fee"+
							" where RENT_MNG_ID=? and RENT_L_CD=? and rent_st=? and rent_seq=? ";

			try {
				conn.setAutoCommit(false);

				pstmt = conn.prepareStatement(query);
				pstmt.setString(1 , m_id		);
				pstmt.setString(2 , l_cd		);
				pstmt.setString(3 , rent_st		);
				pstmt.setString(4 , rent_seq	);
				pstmt.executeUpdate();
				pstmt.close();
			    
				conn.commit();

			} catch (Exception e) {
				System.out.println("[AddFeeDatabase:dropFeeScdAllCase]\n"+e);
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
		
		//계약수정 : 출고전대차 스케줄 납입횟수 최고값 조회
		public int getMin_fee_tm(String m_id, String l_cd, String rent_st, String rent_seq)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			int fee_tm_count = 0;

			String query =" select min(TO_NUMBER(fee_tm)) from scd_fee "+
							" where RENT_MNG_ID=? and RENT_L_CD=? and rent_st=? and rent_seq=?";


			try
			{
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1 , m_id		);
				pstmt.setString(2 , l_cd		);
				pstmt.setString(3 , rent_st		);
				pstmt.setString(4 , rent_seq	);
				rs = pstmt.executeQuery();
				if(rs.next())
				{
					fee_tm_count = Integer.parseInt(rs.getString(1)==null?"0":rs.getString(1));
				}
				rs.close();
				pstmt.close();
	    	
			} catch (SQLException e) {
				System.out.println("[AddContDatabase:getMin_fee_tm]\n"+e);
				e.printStackTrace();
			} finally {
				try{
	                if(rs != null )		rs.close();
	                if(pstmt != null)	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return fee_tm_count;
			}
		}	
		
		public String getCardValidDt(String cardno, String est_dt)
		{
			getConnection();
			String sysdate = est_dt;
			String query;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String rtnStr = "";
						
			query = "select F_getCardRtnDay(?, ?) "+
						" from dual";
			try{
				if(AddUtil.checkDate(sysdate)){	
					pstmt = conn.prepareStatement(query);
					pstmt.setString(1, cardno);
					pstmt.setString(2, est_dt);
				    rs = pstmt.executeQuery();			
					if(rs.next())
					{
						rtnStr = rs.getString(1)==null?"":rs.getString(1);
					}
					if(!rtnStr.equals("")) {
						sysdate = rtnStr;
					}	
					rs.close();
					pstmt.close();
				}
			}catch (SQLException e){
				System.out.println("[AddFeeDatabase:getCardValidDt]\n"+e);				
				System.out.println("[AddFeeDatabase:getCardValidDt]\n"+query);
		  		e.printStackTrace();
			}finally{
				try{
	                if(rs != null )		rs.close();
	                if(pstmt != null)	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return sysdate;
			}
		}	
		
		/**
		 *	대여료스케줄 조회 화면 펼쳐질때 호출. 연체료/일 계산.
		 */
		public boolean calDelayCls(String m_id, String l_cd, String cls_dt)
		{
			getConnection();
			boolean flag = true;
			Statement stmt1 = null;
			Statement stmt2 = null;
			Statement stmt3 = null;
			Statement stmt4 = null;
			
			String today = "to_char(sysdate,'YYYYMMDD')";
			if(!cls_dt.equals("")) today = "replace('"+cls_dt+"','-','')";
			String today2 = "SYSDATE";
			if(!cls_dt.equals("")) today2 = "TO_DATE(replace('"+cls_dt+"','-',''), 'YYYYMMDD')";
			
			// 0.18 : 개업 ~ 20081009
			// 0.24 : 20081010 ~ 20211231
			// 0.20 : 20220101 ~
			// 20211214 기준 최소 계약일 20110719 로 2008년 계약없음. 바로 0.24, 0.2로 변경
			
			String dly_per = "0.18";


			//연체일 있는 경우(입금:입금일>입금예정일, 미입금:현재날자>입금예정일)
			String query1 = " UPDATE SCD_FEE SET"+
							"        dly_days = TRUNC(NVL(TO_DATE(rc_dt, 'YYYYMMDD'), "+today2+") - TO_DATE(r_fee_est_dt, 'YYYYMMDD')),"+
							"        dly_fee = (TRUNC(((decode(rc_amt,0,fee_s_amt+fee_v_amt,rc_amt))*"+dly_per+"*TRUNC(TO_DATE(r_fee_est_dt, 'YYYYMMDD')- NVL(TO_DATE(rc_dt, 'YYYYMMDD'), "+today2+")))/365) * -1)"+
							" WHERE fee_s_amt>0 and rent_mng_id = '"+m_id+"' and rent_l_cd = '"+l_cd+"' "+ 
							" and nvl(rc_dt,"+today+") > r_fee_est_dt"+
							" and (rent_l_cd, rent_mng_id, rent_st) in (select a.rent_l_cd, a.rent_mng_id, a.rent_st from fee a, cont b, cont_etc c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and decode(c.rent_suc_dt,'',decode(a.rent_st,'1',b.rent_dt,a.rent_dt),c.rent_suc_dt) < '20081010' )" ;
			
			dly_per = "0.24";


			//연체일 있는 경우(입금:입금일>입금예정일, 미입금:현재날자>입금예정일)
			String query2 = " UPDATE SCD_FEE SET"+
							"        dly_days = TRUNC(NVL(TO_DATE(rc_dt, 'YYYYMMDD'), "+today2+") - TO_DATE(r_fee_est_dt, 'YYYYMMDD')),"+
							"        dly_fee = (TRUNC(((decode(rc_amt,0,fee_s_amt+fee_v_amt,rc_amt))*"+dly_per+"*TRUNC(TO_DATE(r_fee_est_dt, 'YYYYMMDD')- NVL(TO_DATE(rc_dt, 'YYYYMMDD'), "+today2+")))/365) * -1)"+
							" WHERE fee_s_amt>0 and rent_mng_id = '"+m_id+"' and rent_l_cd = '"+l_cd+"' "+  
							" and nvl(rc_dt,"+today+") > r_fee_est_dt"+
							" and (rent_l_cd, rent_mng_id, rent_st) in (select a.rent_l_cd, a.rent_mng_id, a.rent_st from fee a, cont b, cont_etc c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and decode(c.rent_suc_dt,'',decode(a.rent_st,'1',b.rent_dt,a.rent_dt),c.rent_suc_dt) < '20220101' and decode(c.rent_suc_dt,'',nvl(a.rent_dt,b.rent_dt),c.rent_suc_dt) >= '20081010')" ;

			dly_per = "0.20";

			//연체일 있는 경우(입금:입금일>입금예정일, 미입금:현재날자>입금예정일)
			String query3 = " UPDATE SCD_FEE SET"+
							"        dly_days = TRUNC(NVL(TO_DATE(rc_dt, 'YYYYMMDD'), "+today2+") - TO_DATE(r_fee_est_dt, 'YYYYMMDD')),"+
							"        dly_fee = (TRUNC(((decode(rc_amt,0,fee_s_amt+fee_v_amt,rc_amt))*"+dly_per+"*TRUNC(TO_DATE(r_fee_est_dt, 'YYYYMMDD')- NVL(TO_DATE(rc_dt, 'YYYYMMDD'), "+today2+")))/365) * -1)"+
							" WHERE fee_s_amt>0 and rent_mng_id = '"+m_id+"' and rent_l_cd = '"+l_cd+"' "+   
							" and nvl(rc_dt,"+today+") > r_fee_est_dt"+
							" and (rent_l_cd, rent_mng_id, rent_st) in (select a.rent_l_cd, a.rent_mng_id, a.rent_st from fee a, cont b, cont_etc c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and decode(c.rent_suc_dt,'',decode(a.rent_st,'1',b.rent_dt,a.rent_dt),c.rent_suc_dt) >= '20220101')" ;

			//연체일 없는 경우(입금:입금일=입금예정일, 입금일<입금예정일(선수), 미입금:현재날짜<입금예정일)
			String query4 = " UPDATE SCD_FEE set"+
							" dly_days = '0',"+
							" dly_fee = 0"+
							" WHERE rent_mng_id = '"+m_id+"' and rent_l_cd = '"+l_cd+"' "+  
							" and (nvl(rc_dt,"+today+") <= r_fee_est_dt or fee_s_amt=0)";
			

			try 
			{
				conn.setAutoCommit(false); 

				stmt1 = conn.createStatement();
			    stmt1.executeUpdate(query1);
				stmt1.close();

				stmt2 = conn.createStatement();
			    stmt2.executeUpdate(query2);
				stmt2.close();

				stmt3 = conn.createStatement();
			    stmt3.executeUpdate(query3);
				stmt3.close();
				
				stmt4 = conn.createStatement();
			    stmt4.executeUpdate(query4);
				stmt4.close();

				conn.commit();
			    
		  	} catch (Exception e) {
				System.out.println("[AddFeeDatabase:calDelayCls]\n"+e);			
				System.out.println("[AddFeeDatabase:calDelayCls]\n"+query1);			
				System.out.println("[AddFeeDatabase:calDelayCls]\n"+query2);			
				System.out.println("[AddFeeDatabase:calDelayCls]\n"+query3);			
				System.out.println("[AddFeeDatabase:calDelayCls]\n"+query4);
		  		e.printStackTrace();
		  		flag = false;
				conn.rollback();
			} finally {
				try{	
					conn.setAutoCommit(true);
					if(stmt1 != null)	stmt1.close();
					if(stmt2 != null)	stmt2.close();
					if(stmt3 != null)	stmt3.close();
				}catch(Exception ignore){}
				closeConnection();
				return flag;
			}
		}	
		
		/**	
		 *	출고전대차 스케줄 회차변경 0회차 변경
		 */
		public boolean updateScdFeeTaeTmCng1(String rent_l_cd, String fee_tm, String cng_fee_tm)
		{
			getConnection();
			boolean flag = true;
			PreparedStatement pstmt = null;
			String query = "";
			
			query = " update scd_fee set "+
					" fee_tm=? "+
					" where rent_l_cd=? and rent_st='1' and rent_seq='1' and tm_st2='2' and fee_tm=?";
				
			try 
			{
				conn.setAutoCommit(false);

				pstmt = conn.prepareStatement(query);
				pstmt.setString(1 , cng_fee_tm);				
				pstmt.setString(2 , rent_l_cd);	
				pstmt.setString(3 , fee_tm);				
				pstmt.executeUpdate();
				pstmt.close();

				conn.commit();

		  	} catch (Exception e) {
				System.out.println("[AddFeeDatabase:updateScdFeeTaeTmCng1]\n"+e);
				System.out.println("[AddFeeDatabase:updateScdFeeTaeTmCng1]rent_l_cd="+rent_l_cd);
				System.out.println("[AddFeeDatabase:updateScdFeeTaeTmCng1]cng_fee_tm="+cng_fee_tm);
				System.out.println("[AddFeeDatabase:updateScdFeeTaeTmCng1]fee_tm="+fee_tm);
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
		 *	출고전대차 스케줄 회차변경
		 */
		public boolean updateScdFeeTaeTmCng2(String rent_l_cd, String fee_tm, String cng_fee_tm)
		{
			getConnection();
			boolean flag = true;
			PreparedStatement pstmt1 = null;
			PreparedStatement pstmt2 = null;
			PreparedStatement pstmt3 = null;
			PreparedStatement pstmt4 = null;
			String query1 = "";
			String query2 = "";
			String query3 = "";
			String query4 = "";
			
			query1 = " update scd_fee set "+
					" fee_tm=to_number(fee_tm)+1 "+
					" where rent_l_cd=? and rent_seq='1' and to_number(fee_tm) >="+cng_fee_tm+"";

			query2 = " update tax_item_list set "+
					" tm=to_number(tm)+1 "+
					" where rent_l_cd=? and rent_seq='1' and gubun='1' and to_number(tm) >="+cng_fee_tm+"";

			query3 = " update tax set "+
					" fee_tm=to_number(fee_tm)+1 "+
					" where rent_l_cd=? and gubun='1' and tax_g='대여료' and to_number(fee_tm) >="+cng_fee_tm+"";
			
			query4 = " update scd_fee set "+
					" fee_tm='"+cng_fee_tm+"' "+
					" where rent_l_cd=? and rent_st='1' and rent_seq='1' and tm_st2='2' and to_number(fee_tm)-1 ='"+fee_tm+"'";

				
			try 
			{
				conn.setAutoCommit(false);
				
				//선택회차 이후거 먼저 변경(대여료스케줄,거래명세서,계산서)
				pstmt1 = conn.prepareStatement(query1);
				pstmt1.setString(1 , rent_l_cd);				
				pstmt1.executeUpdate();
				pstmt1.close();
				pstmt2 = conn.prepareStatement(query2);
				pstmt2.setString(1 , rent_l_cd);				
				pstmt2.executeUpdate();
				pstmt2.close();
				pstmt3 = conn.prepareStatement(query3);
				pstmt3.setString(1 , rent_l_cd);				
				pstmt3.executeUpdate();
				pstmt3.close();
				//선택회차 수정
				pstmt4 = conn.prepareStatement(query4);
				pstmt4.setString(1 , rent_l_cd);				
				pstmt4.executeUpdate();
				pstmt4.close();


				conn.commit();

		  	} catch (Exception e) {
				System.out.println("[AddFeeDatabase:updateScdFeeTaeTmCng2]\n"+e);
				System.out.println("[AddFeeDatabase:updateScdFeeTaeTmCng2]rent_l_cd="+rent_l_cd);
				System.out.println("[AddFeeDatabase:updateScdFeeTaeTmCng2]cng_fee_tm="+cng_fee_tm);
				System.out.println("[AddFeeDatabase:updateScdFeeTaeTmCng2]fee_tm="+fee_tm);
				
				e.printStackTrace();
		  		flag = false;
				conn.rollback();
			} finally {
				try{	
					conn.setAutoCommit(true);
					if(pstmt1 != null)	pstmt1.close();
					if(pstmt2 != null)	pstmt2.close();
					if(pstmt3 != null)	pstmt3.close();
					if(pstmt4 != null)	pstmt4.close();
				}catch(Exception ignore){}
				closeConnection();
				return flag;
			}
		}				
	
}
