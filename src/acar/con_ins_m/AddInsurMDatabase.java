/*
 * 면책금
 */
package acar.con_ins_m;

import java.util.*;
import java.sql.*;
//import acar.util.*;
//import java.text.*;
//import acar.common.*;
import acar.account.*;
import acar.database.DBConnectionManager;
//import acar.exception.DataSourceEmptyException;
//import acar.exception.UnknownDataException;
//import acar.exception.DatabaseException;

public class AddInsurMDatabase {

	private Connection conn = null;
	public static AddInsurMDatabase aim_db;
	
	public static AddInsurMDatabase getInstance()
	{
		if(AddInsurMDatabase.aim_db == null)
			AddInsurMDatabase.aim_db = new AddInsurMDatabase();
		return AddInsurMDatabase.aim_db;	
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


	// 조회 -------------------------------------------------------------------------------------------------

	// 면책금 리스트 조회
	public Vector getInsurMList(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select /*+  merge(b) */ "+
				"        a.car_mng_id, a.serv_id, a.accid_id, a.rent_mng_id, a.rent_l_cd, b.firm_nm, b.client_nm,"+
				"        cr.car_no, cr.car_nm, cn.car_name, decode(a.cust_pay_dt, '','미수금','수금') gubun,"+
				"        decode(a.serv_st, '1','순회점검', '2','일반수리', '3','보증수리', '4','사고수리') serv_st, a.off_id, c.off_nm,"+
				"        a.rep_amt, a.sup_amt, a.add_amt, a.tot_amt, a.cust_amt, a.serv_dt, a.dly_days, b.use_yn, b.mng_id, b.rent_st,"+
				"        nvl2(a.cust_req_dt,substr(a.cust_req_dt,1,4)||'-'||substr(a.cust_req_dt,5,2)||'-'||substr(a.cust_req_dt,7,2),'') cust_req_dt,"+
				"        nvl2(a.cust_plan_dt,substr(a.cust_plan_dt,1,4)||'-'||substr(a.cust_plan_dt,5,2)||'-'||substr(a.cust_plan_dt,7,2),'') cust_plan_dt,"+
				"        nvl2(a.cust_pay_dt,substr(a.cust_pay_dt,1,4)||'-'||substr(a.cust_pay_dt,5,2)||'-'||substr(a.cust_pay_dt,7,2),'') cust_pay_dt,"+
				"        decode(g.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트') res_st,"+
				"        decode(g.cust_st,'1',h.firm_nm, '4',i.user_nm) cust_nm,"+
				"        decode(f.rent_s_cd,'',b.bus_id2,decode(g.rent_st,'2',j.bus_id2,'3',j.bus_id2,'1',g.bus_id,'4',g.cust_id,'5',g.cust_id)) bus_id2,"+
				"        nvl2(k.tax_dt,substr(k.tax_dt,1,4)||'-'||substr(k.tax_dt,5,2)||'-'||substr(k.tax_dt,7,2),' ') ext_dt"+
				" from   service a, cont_n_view b, serv_off c, accident f, rent_cont g, client h, users i, cont j, car_reg cr,  car_etc gg, car_nm cn \n"+
				"        (select aa.* from tax_item_list aa, tax bb where aa.item_id=bb.item_id and bb.tax_st='O' and aa.gubun ='7') l,"+
				"        (select aa.* from tax aa where aa.tax_st='O' and substr(aa.tax_g,1,3) in ('차량수','면책금') and aa.tax_supply > 0) k"+
				" where "+
				"        a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.car_mng_id=b.car_mng_id"+
				"        and a.off_id=c.off_id"+
				"        and a.car_mng_id=f.car_mng_id(+) and a.accid_id=f.accid_id(+) "+
				"	     and f.rent_s_cd=g.rent_s_cd(+) and g.cust_id=h.client_id(+) and g.cust_id=i.user_id(+) and g.sub_l_cd=j.rent_l_cd(+)"+
				"        and a.rent_l_cd=l.rent_l_cd(+) and a.serv_id=l.tm(+)"+
				"        and a.rent_l_cd=k.rent_l_cd(+) and a.serv_id=k.fee_tm(+)"+
				"        and a.cust_amt > 0 "+
				"        and nvl(a.no_dft_yn,'N') = 'N' and nvl(a.bill_yn,'Y')='Y'" +
				"	and a.car_mng_id = cr.car_mng_id  and a.rent_mng_id = gg.rent_mng_id(+)  and a.rent_l_cd = gg.rent_l_cd(+)  \n"+
                       		"	and gg.car_id=cn.car_id(+)  and    gg.car_seq=cn.car_seq(+) ";

		/*상세조회&&세부조회*/

		//당월-계획
		if(gubun2.equals("1") && gubun3.equals("1")){		query += " and nvl(a.cust_plan_dt,a.cust_req_dt) like to_char(sysdate,'YYYYMM')||'%' ";
		//당월-수금
		}else if(gubun2.equals("1") && gubun3.equals("2")){	query += " and nvl(a.cust_plan_dt,a.cust_req_dt) like to_char(sysdate,'YYYYMM')||'%' and a.cust_pay_dt is not null";
		//당월-미수금
		}else if(gubun2.equals("1") && gubun3.equals("3")){	query += " and nvl(a.cust_plan_dt,a.cust_req_dt) like to_char(sysdate,'YYYYMM')||'%' and a.cust_pay_dt is null";
		//당일-계획
		}else if(gubun2.equals("2") && gubun3.equals("1")){	query += " and nvl(a.cust_plan_dt,a.cust_req_dt) = to_char(sysdate,'YYYYMMDD')";
		//당일-수금
		}else if(gubun2.equals("2") && gubun3.equals("2")){	query += " and nvl(a.cust_plan_dt,a.cust_req_dt) = to_char(sysdate,'YYYYMMDD') and a.cust_pay_dt = to_char(sysdate,'YYYYMMDD')";
		//당일-미수금
		}else if(gubun2.equals("2") && gubun3.equals("3")){	query += " and nvl(a.cust_plan_dt,a.cust_req_dt) = to_char(sysdate,'YYYYMMDD') and a.cust_pay_dt is null";
		//연체-계획
		}else if(gubun2.equals("3") && gubun3.equals("1")){	query += " and nvl(a.cust_plan_dt,a.cust_req_dt) < to_char(sysdate,'YYYYMMDD') and (a.cust_pay_dt is null or a.cust_pay_dt = to_char(sysdate,'YYYYMMDD'))";
		//연체-수금
		}else if(gubun2.equals("3") && gubun3.equals("2")){	query += " and nvl(a.cust_plan_dt,a.cust_req_dt) < to_char(sysdate,'YYYYMMDD') and a.cust_pay_dt = to_char(sysdate,'YYYYMMDD')";
		//연체-미수금
		}else if(gubun2.equals("3") && gubun3.equals("3")){	query += " and nvl(a.cust_plan_dt,a.cust_req_dt) < to_char(sysdate,'YYYYMMDD') and a.cust_pay_dt is null";
		//기간-계획
		}else if(gubun2.equals("4") && gubun3.equals("1")){	query += " and nvl(a.cust_plan_dt,a.cust_req_dt) BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		//기간-수금
		}else if(gubun2.equals("4") && gubun3.equals("2")){	query += " and nvl(a.cust_plan_dt,a.cust_req_dt) BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.cust_pay_dt is not null";
		//기간-미수금
		}else if(gubun2.equals("4") && gubun3.equals("3")){	query += " and nvl(a.cust_plan_dt,a.cust_req_dt) BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.cust_pay_dt is null";
		//당일+연체-계획
		}else if(gubun2.equals("6") && gubun3.equals("1")){	query += " and nvl(a.cust_plan_dt,a.cust_req_dt) <= to_char(sysdate,'YYYYMMDD') and (a.cust_pay_dt is null or a.cust_pay_dt = to_char(sysdate,'YYYYMMDD'))";
		//당일+연체-수금
		}else if(gubun2.equals("6") && gubun3.equals("2")){	query += " and nvl(a.cust_plan_dt,a.cust_req_dt) <= to_char(sysdate,'YYYYMMDD') and a.cust_pay_dt = to_char(sysdate,'YYYYMMDD')";
		//당일+연체-미수금
		}else if(gubun2.equals("6") && gubun3.equals("3")){	query += " and nvl(a.cust_plan_dt,a.cust_req_dt) <= to_char(sysdate,'YYYYMMDD') and a.cust_pay_dt is null";
		//검색
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

		if(s_kd.equals("2"))		query += " and nvl(b.client_nm||h.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(b.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and nvl(cr.car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("5"))	query += " and (a.cust_amt) like '%"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	query += " and upper(b.brch_id) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("7"))	query += " and nvl(b.r_site, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("8"))	query += " and b.mng_id= '"+t_wd+"'\n";
		else if(s_kd.equals("12"))	query += " and decode(f.rent_s_cd,'',b.bus_id2,decode(g.rent_st,'2',j.bus_id2,'3',j.bus_id2,'1',g.bus_id,'4',g.cust_id,'5',g.cust_id))= '"+t_wd+"'\n";
		else if(s_kd.equals("9"))	query += " and cr.car_nm||cn.car_name like '%"+t_wd+"%'\n";
		else if(s_kd.equals("10"))	query += " and nvl(a.serv_dt, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("11"))	query += " and nvl(c.off_nm, '') like '%"+t_wd+"%'\n";
		else						query += " and nvl(b.firm_nm||h.firm_nm||i.user_nm||decode(g.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트'), '') like '%"+t_wd+"%'\n";			

		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		/*정렬조건*/

		if(sort_gubun.equals("0"))		query += " order by decode(b.bus_id2,'000004','1','0'), b.use_yn desc, a.cust_plan_dt "+sort+", a.cust_pay_dt, b.firm_nm";
		else if(sort_gubun.equals("1"))	query += " order by decode(b.bus_id2,'000004','1','0'), b.use_yn desc, b.firm_nm "+sort+", a.cust_pay_dt, a.cust_plan_dt";
		else if(sort_gubun.equals("2"))	query += " order by decode(b.bus_id2,'000004','1','0'), b.use_yn desc, a.cust_pay_dt "+sort+", b.firm_nm, a.cust_plan_dt";
		else if(sort_gubun.equals("3"))	query += " order by decode(b.bus_id2,'000004','1','0'), b.use_yn desc, a.cust_amt "+sort+", a.cust_pay_dt, b.firm_nm, a.cust_plan_dt";
		else if(sort_gubun.equals("4"))	query += " order by decode(b.bus_id2,'000004','1','0'), cr.car_no "+sort+", b.firm_nm, a.cust_plan_dt";
	
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
//			System.out.println("[AddInsurMDatabase:getInsurMList]\n"+query);
		} catch (SQLException e) {
			System.out.println("[AddInsurMDatabase:getInsurMList]\n"+e);

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


	// 면책금 리스트 통계
	public Vector getInsurMStat(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String sub_query = "";
		sub_query = " select /*+  merge(b) */ "+
					"        a.car_mng_id, a.serv_id, a.accid_id, a.rent_mng_id, a.rent_l_cd, b.firm_nm, b.client_nm,"+
					"        cr.car_no, cr.car_nm, decode(a.cust_pay_dt, '','미수금','수금') gubun,"+
					"        decode(a.serv_st, '1','순회점검', '2','일반수리', '3','보증수리', '4','사고수리') serv_st, a.off_id, c.off_nm,"+
					"        a.rep_amt, a.sup_amt, a.add_amt, a.tot_amt, a.cust_amt, a.serv_dt, b.use_yn, b.mng_id, b.rent_st,"+
					"        nvl2(a.cust_req_dt,substr(a.cust_req_dt,1,4)||'-'||substr(a.cust_req_dt,5,2)||'-'||substr(a.cust_req_dt,7,2),'') cust_req_dt,"+
					"        nvl2(a.cust_plan_dt,substr(a.cust_plan_dt,1,4)||'-'||substr(a.cust_plan_dt,5,2)||'-'||substr(a.cust_plan_dt,7,2),'') cust_plan_dt,"+
					"        nvl2(a.cust_pay_dt,substr(a.cust_pay_dt,1,4)||'-'||substr(a.cust_pay_dt,5,2)||'-'||substr(a.cust_pay_dt,7,2),'') cust_pay_dt"+
					" from   service a, cont_n_view b, serv_off c , car_reg cr \n"+
					" where "+
					"        a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.car_mng_id=b.car_mng_id"+
					"        and a.off_id=c.off_id and a.car_mng_id = cr.car_mng_id  \n"+
					"        and a.cust_amt > 0 and nvl(a.no_dft_yn,'N') <> 'Y'";

		/*상세조회&&세부조회*/

		//당월-계획
		if(gubun2.equals("1") && gubun3.equals("1")){		sub_query += " and a.cust_plan_dt like to_char(sysdate,'YYYYMM')||'%'";
		//당월-수금
		}else if(gubun2.equals("1") && gubun3.equals("2")){	sub_query += " and a.cust_plan_dt like to_char(sysdate,'YYYYMM')||'%' and a.cust_pay_dt is not null";
		//당월-미수금
		}else if(gubun2.equals("1") && gubun3.equals("3")){	sub_query += " and a.cust_plan_dt like to_char(sysdate,'YYYYMM')||'%' and a.cust_pay_dt is null";
		//당일-계획
		}else if(gubun2.equals("2") && gubun3.equals("1")){	sub_query += " and a.cust_plan_dt = to_char(sysdate,'YYYYMMDD')";
		//당일-수금
		}else if(gubun2.equals("2") && gubun3.equals("2")){	sub_query += " and a.cust_plan_dt = to_char(sysdate,'YYYYMMDD') and a.cust_pay_dt = to_char(sysdate,'YYYYMMDD')";
		//당일-미수금
		}else if(gubun2.equals("2") && gubun3.equals("3")){	sub_query += " and a.cust_plan_dt = to_char(sysdate,'YYYYMMDD') and a.cust_pay_dt is null";
		//연체-계획
		}else if(gubun2.equals("3") && gubun3.equals("1")){	sub_query += " and a.cust_plan_dt < to_char(sysdate,'YYYYMMDD') and (a.cust_pay_dt is null or a.cust_pay_dt = to_char(sysdate,'YYYYMMDD'))";
		//연체-수금
		}else if(gubun2.equals("3") && gubun3.equals("2")){	sub_query += " and a.cust_plan_dt < to_char(sysdate,'YYYYMMDD') and a.cust_pay_dt = to_char(sysdate,'YYYYMMDD')";
		//연체-미수금
		}else if(gubun2.equals("3") && gubun3.equals("3")){	sub_query += " and a.cust_plan_dt < to_char(sysdate,'YYYYMMDD') and a.cust_pay_dt is null";
		//기간-계획
		}else if(gubun2.equals("4") && gubun3.equals("1")){	sub_query += " and a.cust_plan_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		//기간-수금
		}else if(gubun2.equals("4") && gubun3.equals("2")){	sub_query += " and a.cust_plan_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.cust_pay_dt is not null";
		//기간-미수금
		}else if(gubun2.equals("4") && gubun3.equals("3")){	sub_query += " and a.cust_plan_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.cust_pay_dt is null";
		//당일+연체-계획
		}else if(gubun2.equals("6") && gubun3.equals("1")){	sub_query += " and a.cust_plan_dt <= to_char(sysdate,'YYYYMMDD') and (a.cust_pay_dt is null or a.cust_pay_dt = to_char(sysdate,'YYYYMMDD'))";
		//당일+연체-수금
		}else if(gubun2.equals("6") && gubun3.equals("2")){	sub_query += " and a.cust_plan_dt <= to_char(sysdate,'YYYYMMDD') and a.cust_pay_dt = to_char(sysdate,'YYYYMMDD')";
		//당일+연체-미수금
		}else if(gubun2.equals("6") && gubun3.equals("3")){	sub_query += " and a.cust_plan_dt <= to_char(sysdate,'YYYYMMDD') and a.cust_pay_dt is null";
		//검색
		}

		/*연체조회*/

		if(gubun2.equals("3")){
			if(gubun4.equals("2")){	//일반연체	
				sub_query += " and a.dly_days between 1 and 30";		
			}else if(gubun4.equals("3")){ //부실연체
				sub_query += " and a.dly_days between 1 and 30";
			}else if(gubun4.equals("4")){ //악성연체
				sub_query += " and a.dly_days between 1 and 30";
			}else{}
		}

		/*검색조건*/

		if(s_kd.equals("2"))		sub_query += " and nvl(b.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	sub_query += " and upper(b.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	sub_query += " and nvl(cr.car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("5"))	sub_query += " and (a.cust_amt) like '%"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	sub_query += " and upper(b.brch_id) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("7"))	sub_query += " and nvl(b.r_site, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("8"))	sub_query += " and b.mng_id= '"+t_wd+"'\n";
		else if(s_kd.equals("9"))	sub_query += " and nvl(cr.car_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("10"))	sub_query += " and nvl(a.serv_dt, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("11"))	sub_query += " and nvl(c.off_nm, '') like '%"+t_wd+"%'\n";
		else						sub_query += " and nvl(b.firm_nm, '') like '%"+t_wd+"%'\n";			

		String query = "";
		query = " select '계획' gubun, a.*, b.*, c.*\n"+
				" from\n"+
					" ( select count(*) tot_su1, nvl(sum(cust_amt),0) tot_amt1 from ("+sub_query+") where substr(cust_plan_dt,1,7) = to_char(SYSDATE, 'YYYY-MM') ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(cust_amt),0) tot_amt2 from ("+sub_query+") where cust_plan_dt = to_char(SYSDATE, 'YYYY-MM-DD') ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(cust_amt),0) tot_amt3 from ("+sub_query+") where cust_plan_dt < to_char(SYSDATE, 'YYYY-MM-DD') and (cust_pay_dt is null or cust_pay_dt = to_char(SYSDATE, 'YYYY-MM-DD')) ) c\n"+
				" union all\n"+
				" select '수금' gubun, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(cust_amt),0) tot_amt1 from ("+sub_query+") where substr(cust_plan_dt,1,7) = to_char(SYSDATE, 'YYYY-MM') and cust_pay_dt is not null) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(cust_amt),0) tot_amt2 from ("+sub_query+") where cust_plan_dt = to_char(SYSDATE, 'YYYY-MM-DD') and cust_pay_dt = to_char(SYSDATE, 'YYYY-MM-DD') ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(cust_amt),0) tot_amt3 from ("+sub_query+") where cust_plan_dt < to_char(SYSDATE, 'YYYY-MM-DD') and cust_pay_dt = to_char(SYSDATE, 'YYYY-MM-DD') ) c\n"+
				" union all\n"+
				" select '미수금' gubun, a.*, b.*, c.*\n"+
				" from \n"+
					" ( select count(*) tot_su1, nvl(sum(cust_amt),0) tot_amt1 from ("+sub_query+") where substr(cust_plan_dt,1,7) = to_char(SYSDATE, 'YYYY-MM') and cust_pay_dt is null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(cust_amt),0) tot_amt2 from ("+sub_query+") where cust_plan_dt = to_char(SYSDATE, 'YYYY-MM-DD') and cust_pay_dt is null) b,\n"+
					" ( select count(*) tot_su3, nvl(sum(cust_amt),0) tot_amt3 from ("+sub_query+") where cust_plan_dt < to_char(SYSDATE, 'YYYY-MM-DD') and cust_pay_dt is null ) c\n"+
				" union all\n"+
				" select '비율' gubun, a.*, b.*, c.*\n"+
				" from \n"+
					" ( select decode(a.tot_su1, 0,0, to_number(to_char((b.tot_su1/a.tot_su1)*100, 999.99))) tot_su1, decode(a.tot_amt1, 0,0, to_number(to_char((b.tot_amt1/a.tot_amt1)*100, 999.99))) tot_amt1 from \n"+
						" ( select count(*) tot_su1, nvl(sum(cust_amt),0) tot_amt1 from ("+sub_query+") where substr(cust_plan_dt,1,7) = to_char(SYSDATE, 'YYYY-MM') ) a,\n"+
						" ( select count(*) tot_su1, nvl(sum(cust_amt),0) tot_amt1 from ("+sub_query+") where substr(cust_plan_dt,1,7) = to_char(SYSDATE, 'YYYY-MM') and cust_pay_dt is not null ) b\n"+
					" ) a,\n"+
					" ( select decode(a.tot_su2, 0,0, to_number(to_char((b.tot_su2/a.tot_su2)*100, 999.99))) tot_su2, decode(a.tot_amt2, 0,0, to_number(to_char((b.tot_amt2/a.tot_amt2)*100, 999.99))) tot_amt2 from \n"+
						" ( select count(*) tot_su2, nvl(sum(cust_amt),0) tot_amt2 from ("+sub_query+") where cust_plan_dt = to_char(SYSDATE, 'YYYY-MM-DD') ) a,\n"+
						" ( select count(*) tot_su2, nvl(sum(cust_amt),0) tot_amt2 from ("+sub_query+") where cust_plan_dt = to_char(SYSDATE, 'YYYY-MM-DD') and cust_pay_dt = to_char(SYSDATE, 'YYYY-MM-DD') ) b\n"+
					" ) b,\n"+
					" ( select decode(a.tot_su3, 0,0, to_number(to_char((b.tot_su3/a.tot_su3)*100, 999.99))) tot_su3, decode(a.tot_amt3, 0,0, to_number(to_char((b.tot_amt3/a.tot_amt3)*100, 999.99))) tot_amt3 from \n"+
						" ( select count(*) tot_su3, nvl(sum(cust_amt),0) tot_amt3 from ("+sub_query+") where cust_plan_dt < to_char(SYSDATE, 'YYYY-MM-DD') and (cust_pay_dt is null or cust_pay_dt = to_char(SYSDATE, 'YYYY-MM-DD')) ) a,\n"+
						" ( select count(*) tot_su3, nvl(sum(cust_amt),0) tot_amt3 from ("+sub_query+") where cust_plan_dt < to_char(SYSDATE, 'YYYY-MM-DD') and cust_pay_dt = to_char(SYSDATE, 'YYYY-MM-DD') ) b\n"+
					" ) c";
		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();

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
			System.out.println("[AddInsurMDatabase:getInserMStat]\n"+e);
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

	// 면책금 건별 스케줄 리스트 조회
	public Vector getInsurMScd(String m_id, String l_cd, String c_id, String accid_id, String serv_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select"+
					" a.accid_id, a.serv_id, decode(a.cust_pay_dt, '','미수금','수금') gubun,"+
					" decode(a.serv_st, '1','순회점검', '2','일반수리', '3','보증수리', '4','운행자차', '5','사고자차','7','재리스정비') serv_st,"+
					" a.off_id, f.off_nm,"+
					" a.rep_amt, a.sup_amt, a.add_amt, a.tot_amt, a.cust_amt, a.dly_amt, a.dly_days,"+
					" nvl2(a.cust_req_dt,substr(a.cust_req_dt,1,4)||'-'||substr(a.cust_req_dt,5,2)||'-'||substr(a.cust_req_dt,7,2),' ') cust_req_dt,"+
					" nvl2(a.cust_plan_dt,substr(a.cust_plan_dt,1,4)||'-'||substr(a.cust_plan_dt,5,2)||'-'||substr(a.cust_plan_dt,7,2),' ') cust_plan_dt,"+
					" nvl2(a.cust_pay_dt,substr(a.cust_pay_dt,1,4)||'-'||substr(a.cust_pay_dt,5,2)||'-'||substr(a.cust_pay_dt,7,2),' ') cust_pay_dt,"+
					" nvl2(k.tax_dt,substr(k.tax_dt,1,4)||'-'||substr(k.tax_dt,5,2)||'-'||substr(k.tax_dt,7,2),' ') ext_dt"+
					" from service a, cont c, client d, car_reg e, serv_off f,"+
					" (select aa.* from tax_item_list aa, tax bb where aa.item_id=bb.item_id and bb.tax_st<>'C' and aa.gubun ='7') j,"+
					" (select aa.* from tax aa where aa.tax_st<>'C' and substr(aa.tax_g,1,3) in ('차량수','면책금') and aa.tax_supply > 0) k"+
					" where"+
					" a.rent_mng_id='"+m_id+"' and a.rent_l_cd='"+l_cd+"' and a.car_mng_id='"+c_id+"'"+
					" and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and c.client_id=d.client_id"+
					" and a.car_mng_id=e.car_mng_id and a.off_id=f.off_id"+
					" and a.cust_amt > 0 "+
					" and a.rent_l_cd=j.rent_l_cd(+) and a.serv_id=j.tm(+)"+
					" and a.rent_l_cd=k.rent_l_cd(+) and a.serv_id=k.fee_tm(+)"+
					" ";
	
		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
			while(rs.next())
			{				
	            InsMScdBean bean = new InsMScdBean();

				bean.setRent_mng_id(m_id); 
				bean.setRent_l_cd(l_cd); 
			    bean.setCar_mng_id(c_id); 					
				bean.setServ_id(rs.getString("serv_id")); 
				bean.setAccid_id(rs.getString("accid_id")); 				
				bean.setGubun(rs.getString("gubun")); 
//				bean.setAccid_dt(rs.getString("accid_dt")); 
				bean.setServ_st(rs.getString("serv_st")); 
				bean.setOff_id(rs.getString("off_id"));
				bean.setOff_nm(rs.getString("off_nm")); 
				bean.setRep_amt(rs.getInt("rep_amt")); 
				bean.setSup_amt(rs.getInt("sup_amt")); 
				bean.setAdd_amt(rs.getInt("add_amt")); 
				bean.setTot_amt(rs.getInt("tot_amt")); 
				bean.setCust_amt(rs.getInt("cust_amt")); 
				bean.setDly_amt(rs.getInt("dly_amt")); 
				bean.setDly_days(rs.getString("dly_days")); 
				bean.setCust_req_dt(rs.getString("cust_req_dt").trim());
				bean.setCust_plan_dt(rs.getString("cust_plan_dt").trim()); 
				bean.setCust_pay_dt(rs.getString("cust_pay_dt").trim());
				bean.setExt_dt(rs.getString("ext_dt").trim());
				vt.add(bean);	
			}
			rs.close();
			stmt.close();

		} catch (SQLException e) {
			System.out.println("[AddInsurMDatabase:getInsurMScd]\n"+e);
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

	// 면책금 건별 스케줄 리스트 통계
	public IncomingBean getInsurMScdStat(String m_id, String l_cd, String c_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		IncomingBean ins_m = new IncomingBean();

		String sub_query = "";
		sub_query = " select * from service"+
					" where cust_amt > 0 "+
					" and rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"' and car_mng_id='"+c_id+"'"; // and a.accid_id='"+accid_id+"' and a.serv_id='"+serv_id+"'";

		String query = "";
		query = " select a.*, b.*, c.* from\n"+
					" ( select count(*) tot_su1, nvl(sum(cust_amt),0) tot_amt1 from ("+sub_query+") where cust_pay_dt is null) a, \n"+
					" ( select count(*) tot_su2, nvl(sum(cust_amt),0) tot_amt2 from ("+sub_query+") where cust_pay_dt is not null) b, \n"+
					" ( select count(*) tot_su3, nvl(sum(dly_amt),0) tot_amt3 from ("+sub_query+") where dly_amt > 0) c";
		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{
				ins_m.setTot_su1(rs.getInt(1));
				ins_m.setTot_amt1(rs.getInt(2));
				ins_m.setTot_su2(rs.getInt(3));
				ins_m.setTot_amt2(rs.getInt(4));
				ins_m.setTot_su3(rs.getInt(5));
				ins_m.setTot_amt3(rs.getInt(6));
			}
			rs.close();
			pstmt.close();
			
		} catch (SQLException e) {
			System.out.println("[AddInsurMDatabase:getInsurMScdStat]\n"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ins_m;
		}
	}

	/**
	 *	면책금 건별 스케줄 한회차 면책금 쿼리(한 라인)
	 */
	public InsMScdBean getScd(String m_id, String l_cd, String c_id, String accid_id, String serv_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		InsMScdBean ins_m_scd = new InsMScdBean();
		String query =  " select rep_amt, sup_amt, add_amt, tot_amt, cust_amt, dly_amt, dly_days,"+
						" cust_req_dt, cust_plan_dt, cust_pay_dt from service "+
						" where RENT_MNG_ID=? and RENT_L_CD=? and CAR_MNG_ID=? and ACCID_ID=? and SERV_ID=?";
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, m_id);
			pstmt.setString(2, l_cd);
			pstmt.setString(3, c_id);
			pstmt.setString(4, accid_id);
			pstmt.setString(5, serv_id);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{
				ins_m_scd.setRent_mng_id(m_id); 
				ins_m_scd.setRent_l_cd(l_cd); 
			    ins_m_scd.setCar_mng_id(c_id); 					
				ins_m_scd.setServ_id(serv_id); 
				ins_m_scd.setAccid_id(accid_id); 				
				ins_m_scd.setRep_amt(rs.getInt("rep_amt")); 
				ins_m_scd.setSup_amt(rs.getInt("sup_amt")); 
				ins_m_scd.setAdd_amt(rs.getInt("add_amt")); 
				ins_m_scd.setTot_amt(rs.getInt("tot_amt")); 
				ins_m_scd.setCust_amt(rs.getInt("cust_amt")); 
				ins_m_scd.setDly_amt(rs.getInt("dly_amt")); 
				ins_m_scd.setDly_days(rs.getString("dly_days")); 
				ins_m_scd.setCust_req_dt(rs.getString("cust_req_dt"));
				ins_m_scd.setCust_plan_dt(rs.getString("cust_plan_dt")); 
				ins_m_scd.setCust_pay_dt(rs.getString("cust_pay_dt"));
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AddInsurMDatabase:getScd]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ins_m_scd;
		}				
	}


	// 수정 -------------------------------------------------------------------------------------------------
	
	/**
	 *	면책금 연체료 계산 : ins_m_c.jsp
	 */
	public boolean calDelay(String m_id, String l_cd, String c_id){
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;

		//연체일 있는 경우(입금:입금일>입금예정일, 미입금:현재날자>입금예정일)
		String query1 = "";
		query1= " UPDATE service SET"+
				" dly_days=TRUNC(NVL(TO_DATE(cust_pay_dt, 'YYYYMMDD'), SYSDATE) - TO_DATE(cust_plan_dt, 'YYYYMMDD')),"+
				" dly_amt=(TRUNC(((cust_amt)*0.18*TRUNC(TO_DATE(cust_plan_dt, 'YYYYMMDD')- NVL(TO_DATE(cust_pay_dt, 'YYYYMMDD'), SYSDATE)))/365) * -1)"+
				" WHERE rent_mng_id=? and rent_l_cd=? and car_mng_id=?"+// and accid_id=? and serv_id=?"+
				" and SIGN(TRUNC(NVL(TO_DATE(cust_pay_dt, 'YYYYMMDD'), SYSDATE) - TO_DATE(cust_plan_dt, 'YYYYMMDD'))) > 0";
	
		//연체일 없는 경우(입금:입금일=입금예정일, 입금일<입금예정일(선수), 미입금:현재날짜<입금예정일)
		String query2 = "";
		query2= " UPDATE service set"+
				" dly_days = '0',"+
				" dly_amt = 0"+
				" WHERE rent_mng_id=? and rent_l_cd=? and car_mng_id=?"+// and accid_id=? and serv_id=?"+
				" and SIGN(TRUNC(NVL(TO_DATE(cust_pay_dt, 'YYYYMMDD'), SYSDATE) - TO_DATE(cust_plan_dt, 'YYYYMMDD'))) < 1";
		try 
		{
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query1);
			pstmt1.setString(1, m_id);
			pstmt1.setString(2, l_cd);
			pstmt1.setString(3, c_id);
		    pstmt1.executeUpdate();
			pstmt1.close();

		    pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString(1, m_id);
			pstmt2.setString(2, l_cd);
			pstmt2.setString(3, c_id);
		    pstmt2.executeUpdate();
			pstmt2.close();
		    
		   	conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddInsurMDatabase:calDelay]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{	
                if(pstmt1 != null)	pstmt1.close();
                if(pstmt2 != null)	pstmt2.close();
               	conn.setAutoCommit(true);
			}
			catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	/**
	 *	면책금 스케줄 변동사항 : 입금처리, 입금취소, 청구금액 수정, 입금일자 수정 ins_m_c.jsp
	 */
	public boolean updateInsMScd(InsMScdBean cng_ins_ms, String cmd, String pay_yn){
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		//1.입금처리
		String query1 = " UPDATE service SET cust_pay_dt=replace(?, '-', ''), ext_dt=replace(?, '-', ''), update_dt=to_char(sysdate,'YYYYMMDD'), update_id=?"+
						" WHERE car_mng_id=? and accid_id=? and serv_id=?";//rent_mng_id=? and rent_l_cd=? and 
		//2.입금취소
		String query2 = " UPDATE service SET cust_pay_dt=?, ext_dt=replace(?, '-', ''), update_dt=to_char(sysdate,'YYYYMMDD'), update_id=?"+
						" WHERE car_mng_id=? and accid_id=? and serv_id=?";//rent_mng_id=? and rent_l_cd=? and 
		//3.청구금액 수정
		String query3 = " UPDATE service SET cust_amt=?, ext_dt=replace(?, '-', ''), update_dt=to_char(sysdate,'YYYYMMDD'), update_id=?"+
						" WHERE car_mng_id=? and accid_id=? and serv_id=?";//rent_mng_id=? and rent_l_cd=? and 
		//4.입금일자 수정
		String query4 = " UPDATE service SET cust_pay_dt=replace(?, '-', ''), ext_dt=replace(?, '-', ''), update_dt=to_char(sysdate,'YYYYMMDD'), update_id=?"+
						" WHERE car_mng_id=? and accid_id=? and serv_id=?";//rent_mng_id=? and rent_l_cd=? and 

		try 
		{
			conn.setAutoCommit(false);
		
			if(cmd.equals("p")){			//입금처리
				pstmt = conn.prepareStatement(query1);
				pstmt.setString(1, cng_ins_ms.getCust_pay_dt().trim());
			}else if(cmd.equals("c")){		//입금취소
				pstmt = conn.prepareStatement(query2);
				pstmt.setString(1, "");	
			}else{	
				if(pay_yn.equals("N")){		//미입금수정-입금액
					pstmt = conn.prepareStatement(query3);
					pstmt.setInt(1, cng_ins_ms.getCust_amt());
				}else{						//입금수정-입금일
					pstmt = conn.prepareStatement(query4);
					pstmt.setString(1, cng_ins_ms.getCust_pay_dt().trim());
				}
			}

			pstmt.setString(2, cng_ins_ms.getExt_dt().trim());
			pstmt.setString(3, cng_ins_ms.getUpdate_id().trim());
			pstmt.setString(4, cng_ins_ms.getCar_mng_id().trim());
			pstmt.setString(5, cng_ins_ms.getAccid_id().trim());
			pstmt.setString(6, cng_ins_ms.getServ_id().trim());
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

			if( cmd.equals("p") || (cmd.equals("u")&&pay_yn.equals("Y")) ){
				flag = calDelay(cng_ins_ms.getRent_mng_id().trim(), cng_ins_ms.getRent_l_cd().trim(), cng_ins_ms.getCar_mng_id().trim());
			}

		    
	  	} catch (Exception e) {
			System.out.println("[AddInsurMDatabase:updateInsMScd]\n"+e+",accid_id="+cng_ins_ms.getAccid_id());
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}
			catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

}
