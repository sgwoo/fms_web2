/*
 * 휴차료/대차료
 */
package acar.con_ins_h;

import java.util.*;
import java.sql.*;
import acar.util.*;
import java.text.*;
import acar.common.*;
import acar.account.*;
import acar.con_ins_m.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.UnknownDataException;
import acar.exception.DatabaseException;

public class AddInsurHDatabase {

	private Connection conn = null;
	public static AddInsurHDatabase aim_db;
	
	public static AddInsurHDatabase getInstance()
	{
		if(AddInsurHDatabase.aim_db == null)
			AddInsurHDatabase.aim_db = new AddInsurHDatabase();
		return AddInsurHDatabase.aim_db;	
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

	// 휴차료/대차료 리스트 조회
	public Vector getInsurHList(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		Statement stmt = null;
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
				"		case when c.mng_id = '' then c.bus_id2 when c.mng_id is null then c.bus_id2 else c.mng_id end bus_id2, \n"+
				"		nvl2(j.tax_dt,substr(j.tax_dt,1,4)||'-'||substr(j.tax_dt,5,2)||'-'||substr(j.tax_dt,7,2),' ') ext_dt,"+
				"		c.rent_dt2  \n"+
				" from	accident a, my_accid b, cont_n_view c,  car_reg cr,  car_etc g, car_nm cn ,\n"+
				"		(select bb.tax_dt, aa.* from tax_item_list aa, tax bb where aa.item_id=bb.item_id and bb.tax_st='O' and aa.gubun in ('11','12')) j"+
				" where\n"+
				"		a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id\n"+
				"		and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd\n"+
				"		and b.car_mng_id=j.car_mng_id(+) and b.accid_id=j.tm(+) and b.seq_no=j.rent_seq(+)"+
				"		and nvl(b.bill_yn,'Y') = 'Y' and b.req_amt > 0  \n"+
				"	and a.car_mng_id = cr.car_mng_id  and a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+)  \n"+
                       		"	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+) ";

		/*상세조회&&세부조회*/

		//당월-계획
		if(gubun2.equals("1") && gubun3.equals("1")){		query += " and b.req_dt like to_char(sysdate,'YYYYMM')||'%'";
		//당월-수금
		}else if(gubun2.equals("1") && gubun3.equals("2")){	query += " and b.req_dt like to_char(sysdate,'YYYYMM')||'%' and b.pay_dt is not null";
		//당월-미수금
		}else if(gubun2.equals("1") && gubun3.equals("3")){	query += " and b.req_dt like to_char(sysdate,'YYYYMM')||'%' and b.pay_dt is null";
		//당일-계획
		}else if(gubun2.equals("2") && gubun3.equals("1")){	query += " and b.req_dt = to_char(sysdate,'YYYYMMDD')";
		//당일-수금
		}else if(gubun2.equals("2") && gubun3.equals("2")){	query += " and b.req_dt = to_char(sysdate,'YYYYMMDD') and b.pay_dt = to_char(sysdate,'YYYYMMDD')";
		//당일-미수금
		}else if(gubun2.equals("2") && gubun3.equals("3")){	query += " and b.req_dt = to_char(sysdate,'YYYYMMDD') and b.pay_dt is null";
		//연체-계획
		}else if(gubun2.equals("3") && gubun3.equals("1")){	query += " and b.req_dt < to_char(sysdate,'YYYYMMDD') and (b.pay_dt is null or b.pay_dt = to_char(sysdate,'YYYYMMDD'))";
		//연체-수금
		}else if(gubun2.equals("3") && gubun3.equals("2")){	query += " and b.req_dt < to_char(sysdate,'YYYYMMDD') and b.pay_dt = to_char(sysdate,'YYYYMMDD')";
		//연체-미수금
		}else if(gubun2.equals("3") && gubun3.equals("3")){	query += " and b.req_dt < to_char(sysdate,'YYYYMMDD') and b.pay_dt is null";
		//기간-계획
		}else if(gubun2.equals("4") && gubun3.equals("1")){	query += " and b.req_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		//기간-수금
		}else if(gubun2.equals("4") && gubun3.equals("2")){	query += " and b.pay_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and b.pay_dt is not null";
		//기간-미수금
		}else if(gubun2.equals("4") && gubun3.equals("3")){	query += " and b.req_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and b.pay_dt is null";
		//당일+연체-계획
		}else if(gubun2.equals("6") && gubun3.equals("1")){	query += " and b.req_dt <= to_char(sysdate,'YYYYMMDD') and (b.pay_dt is null or b.pay_dt = to_char(sysdate,'YYYYMMDD'))";
		//당일+연체-수금
		}else if(gubun2.equals("6") && gubun3.equals("2")){	query += " and b.req_dt <= to_char(sysdate,'YYYYMMDD') and b.pay_dt = to_char(sysdate,'YYYYMMDD')";
		//당일+연체-미수금
		}else if(gubun2.equals("6") && gubun3.equals("3")){	query += " and b.req_dt <= to_char(sysdate,'YYYYMMDD') and b.pay_dt is null";
		//검색
		}

		/*연체조회*/

		if(gubun2.equals("3")){
			if(gubun4.equals("2")){	//일반연체		
				query += " and b.dly_days between 1 and 30";
			}else if(gubun4.equals("3")){ //부실연체
				query += " and b.dly_days between 31 and 60";
			}else if(gubun4.equals("4")){ //악성연체
				query += " and b.dly_days between 61 and 1000";
			}else{}
		}

		/*검색조건*/
			
		if(s_kd.equals("1"))		query += " and nvl(c.firm_nm, '') like '%"+t_wd+"%'\n";			
		else if(s_kd.equals("2"))	query += " and nvl(c.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(c.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and nvl(cr.car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("5"))	query += " and b.req_amt like '%"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	query += " and upper(c.brch_id) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("7"))	query += " and nvl(c.r_site, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("8"))	query += " and case when c.mng_id = '' then c.bus_id2 when c.mng_id is null then c.bus_id2 else c.mng_id end = '"+t_wd+"'\n";
		else if(s_kd.equals("9"))	query += " and cr.car_nm||cn.car_name like '%"+t_wd+"%'\n";
		else if(s_kd.equals("10"))	query += " and nvl(a.accid_dt, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("11"))	query += " and nvl(a.ot_ins, '') like '%"+t_wd+"%'\n";


		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		/*정렬조건*/

		if(sort_gubun.equals("0"))		query += " order by c.use_yn desc, b.req_dt "+sort+", b.pay_dt, c.firm_nm";
		else if(sort_gubun.equals("1"))	query += " order by c.use_yn desc, c.firm_nm "+sort+", b.pay_dt, b.req_dt";
		else if(sort_gubun.equals("2"))	query += " order by c.use_yn desc, b.pay_dt "+sort+", c.firm_nm, b.req_dt";
		else if(sort_gubun.equals("3"))	query += " order by c.use_yn desc, b.req_amt "+sort+", b.pay_dt, c.firm_nm, b.req_dt";
//		else if(sort_gubun.equals("4"))	query += " order by c.use_yn desc, dly_day "+sort+", rc_dt, firm_nm, fee_est_dt";
		else if(sort_gubun.equals("5"))	query += " order by cr.car_no "+sort+", c.firm_nm, b.req_dt";

//System.out.println("getInsurHList: "+query);	

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
			System.out.println("[AddInsurHDatabase:getInsurHList]\n"+e);
			System.out.println("[AddInsurHDatabase:getInsurHList]\n"+query);
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


	// 휴차료/대차료 리스트 통계
	public Vector getInsurHStat(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String sub_query = "";
		sub_query = " select  \n"+
					"        a.car_mng_id, a.accid_id, a.rent_mng_id, a.rent_l_cd, c.firm_nm, c.client_nm,\n"+
					"        cr.car_no, cr.car_nm, decode(b.pay_dt, '','미수금','수금') gubun,\n"+
					"        decode(a.accid_st, '1','피해자', '2','가해자', '3','쌍방', '4','자차사고') accid_st, nvl(a.ot_ins,'') ot_ins,\n"+
					"        decode(b.req_gu, '1','휴차료', '2','대차료') req_gu, b.req_amt, b.pay_amt, c.use_yn, c.mng_id, c.rent_st,\n"+
					"        nvl2(a.accid_dt,substr(a.accid_dt,1,4)||'-'||substr(a.accid_dt,5,2)||'-'||substr(a.accid_dt,7,2),'') accid_dt,\n"+
					"        nvl2(b.req_dt,substr(b.req_dt,1,4)||'-'||substr(b.req_dt,5,2)||'-'||substr(b.req_dt,7,2),'') req_dt,\n"+
					"        nvl2(b.pay_dt,substr(b.pay_dt,1,4)||'-'||substr(b.pay_dt,5,2)||'-'||substr(b.pay_dt,7,2),'') pay_dt\n"+
					" from   accident a, my_accid b, cont_n_view c, car_reg cr \n"+
					" where\n"+
					"        a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id\n"+
					"        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd\n"+
					"        and b.req_st <> '0' and b.req_amt > 0  \n" +
					"       and a.car_mng_id = cr.car_mng_id";

		/*상세조회&&세부조회*/

		//당월-계획
		if(gubun2.equals("1") && gubun3.equals("1")){		sub_query += " and b.req_dt like to_char(sysdate,'YYYYMM')||'%'";
		//당월-수금
		}else if(gubun2.equals("1") && gubun3.equals("2")){	sub_query += " and b.req_dt like to_char(sysdate,'YYYYMM')||'%' and b.pay_dt is not null";
		//당월-미수금
		}else if(gubun2.equals("1") && gubun3.equals("3")){	sub_query += " and b.req_dt like to_char(sysdate,'YYYYMM')||'%' and b.pay_dt is null";
		//당일-계획
		}else if(gubun2.equals("2") && gubun3.equals("1")){	sub_query += " and b.req_dt = to_char(sysdate,'YYYYMMDD')";
		//당일-수금
		}else if(gubun2.equals("2") && gubun3.equals("2")){	sub_query += " and b.req_dt = to_char(sysdate,'YYYYMMDD') and b.pay_dt = to_char(sysdate,'YYYYMMDD')";
		//당일-미수금
		}else if(gubun2.equals("2") && gubun3.equals("3")){	sub_query += " and b.req_dt = to_char(sysdate,'YYYYMMDD') and b.pay_dt is null";
		//연체-계획
		}else if(gubun2.equals("3") && gubun3.equals("1")){	sub_query += " and b.req_dt < to_char(sysdate,'YYYYMMDD') and (b.pay_dt is null or b.pay_dt = to_char(sysdate,'YYYYMMDD'))";
		//연체-수금
		}else if(gubun2.equals("3") && gubun3.equals("2")){	sub_query += " and b.req_dt < to_char(sysdate,'YYYYMMDD') and b.pay_dt = to_char(sysdate,'YYYYMMDD')";
		//연체-미수금
		}else if(gubun2.equals("3") && gubun3.equals("3")){	sub_query += " and b.req_dt < to_char(sysdate,'YYYYMMDD') and b.pay_dt is null";
		//기간-계획
		}else if(gubun2.equals("4") && gubun3.equals("1")){	sub_query += " and b.req_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		//기간-수금
		}else if(gubun2.equals("4") && gubun3.equals("2")){	sub_query += " and b.req_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and b.pay_dt not null";
		//기간-미수금
		}else if(gubun2.equals("4") && gubun3.equals("3")){	sub_query += " and b.req_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and b.pay_dt is null";
		//당일+연체-계획
		}else if(gubun2.equals("6") && gubun3.equals("1")){	sub_query += " and b.req_dt <= to_char(sysdate,'YYYYMMDD') and (b.pay_dt is null or b.pay_dt = to_char(sysdate,'YYYYMMDD'))";
		//당일+연체-수금
		}else if(gubun2.equals("6") && gubun3.equals("2")){	sub_query += " and b.req_dt <= to_char(sysdate,'YYYYMMDD') and b.pay_dt = to_char(sysdate,'YYYYMMDD')";
		//당일+연체-미수금
		}else if(gubun2.equals("6") && gubun3.equals("3")){	sub_query += " and b.req_dt <= to_char(sysdate,'YYYYMMDD') and b.pay_dt is null";
		//검색
		}

		/*연체조회*/

		if(gubun2.equals("3")){
			if(gubun4.equals("2")){	//일반연체		
				sub_query += " and b.dly_days between 1 and 30";
			}else if(gubun4.equals("3")){ //부실연체
				sub_query += " and b.dly_days between 31 and 60";
			}else if(gubun4.equals("4")){ //악성연체
				sub_query += " and b.dly_days between 61 and 1000";
			}else{}
		}

		if(!br_id.equals("S1") && !br_id.equals(""))		sub_query += " and c.brch_id='"+br_id+"'";

		/*검색조건*/

		if(s_kd.equals("2"))		sub_query += " and nvl(c.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	sub_query += " and upper(c.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	sub_query += " and nvl(cr.car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("5"))	sub_query += " and b.req_amt like '%"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	sub_query += " and upper(c.brch_id) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("7"))	sub_query += " and nvl(c.r_site, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("8"))	sub_query += " and c.mng_id= '"+t_wd+"'\n";
		else if(s_kd.equals("9"))	sub_query += " and nvl(cr.car_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("10"))	sub_query += " and nvl(a.accid_dt, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("11"))	sub_query += " and nvl(a.ot_ins, '') like '%"+t_wd+"%'\n";
		else						sub_query += " and nvl(c.firm_nm, '') like '%"+t_wd+"%'\n";			
			
		String query = "";
		query = " select '계획' gubun, a.*, b.*, c.*\n"+
				" from\n"+
					" ( select count(*) tot_su1, nvl(sum(req_amt),0) tot_amt1 from ("+sub_query+") where substr(req_dt,1,7) = to_char(SYSDATE, 'YYYY-MM') ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(req_amt),0) tot_amt2 from ("+sub_query+") where req_dt = to_char(SYSDATE, 'YYYY-MM-DD') ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(req_amt),0) tot_amt3 from ("+sub_query+") where req_dt < to_char(SYSDATE, 'YYYY-MM-DD') and (pay_dt is null or pay_dt = to_char(SYSDATE, 'YYYY-MM-DD')) ) c\n"+
				" union all\n"+
				" select '수금' gubun, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(req_amt),0) tot_amt1 from ("+sub_query+") where substr(req_dt,1,7) = to_char(SYSDATE, 'YYYY-MM') and pay_dt is not null) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(req_amt),0) tot_amt2 from ("+sub_query+") where req_dt = to_char(SYSDATE, 'YYYY-MM-DD') and pay_dt = to_char(SYSDATE, 'YYYY-MM-DD') ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(req_amt),0) tot_amt3 from ("+sub_query+") where req_dt < to_char(SYSDATE, 'YYYY-MM-DD') and pay_dt = to_char(SYSDATE, 'YYYY-MM-DD') ) c\n"+
				" union all\n"+
				" select '미수금' gubun, a.*, b.*, c.*\n"+
				" from \n"+
					" ( select count(*) tot_su1, nvl(sum(req_amt),0) tot_amt1 from ("+sub_query+") where substr(req_dt,1,7) = to_char(SYSDATE, 'YYYY-MM') and pay_dt is null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(req_amt),0) tot_amt2 from ("+sub_query+") where req_dt = to_char(SYSDATE, 'YYYY-MM-DD') and pay_dt is null) b,\n"+
					" ( select count(*) tot_su3, nvl(sum(req_amt),0) tot_amt3 from ("+sub_query+") where req_dt < to_char(SYSDATE, 'YYYY-MM-DD') and pay_dt is null ) c\n"+
				" union all\n"+
				" select '비율' gubun, a.*, b.*, c.*\n"+
				" from \n"+
					" ( select decode(a.tot_su1, 0,0, to_number(to_char((b.tot_su1/a.tot_su1)*100, 999.99))) tot_su1, decode(a.tot_amt1, 0,0, to_number(to_char((b.tot_amt1/a.tot_amt1)*100, 999.99))) tot_amt1 from \n"+
						" ( select count(*) tot_su1, nvl(sum(req_amt),0) tot_amt1 from ("+sub_query+") where substr(req_dt,1,7) = to_char(SYSDATE, 'YYYY-MM') ) a,\n"+
						" ( select count(*) tot_su1, nvl(sum(req_amt),0) tot_amt1 from ("+sub_query+") where substr(req_dt,1,7) = to_char(SYSDATE, 'YYYY-MM') and pay_dt is not null ) b\n"+
					" ) a,\n"+
					" ( select decode(a.tot_su2, 0,0, to_number(to_char((b.tot_su2/a.tot_su2)*100, 999.99))) tot_su2, decode(a.tot_amt2, 0,0, to_number(to_char((b.tot_amt2/a.tot_amt2)*100, 999.99))) tot_amt2 from \n"+
						" ( select count(*) tot_su2, nvl(sum(req_amt),0) tot_amt2 from ("+sub_query+") where req_dt = to_char(SYSDATE, 'YYYY-MM-DD') ) a,\n"+
						" ( select count(*) tot_su2, nvl(sum(req_amt),0) tot_amt2 from ("+sub_query+") where req_dt = to_char(SYSDATE, 'YYYY-MM-DD') and pay_dt = to_char(SYSDATE, 'YYYY-MM-DD') ) b\n"+
					" ) b,\n"+
					" ( select decode(a.tot_su3, 0,0, to_number(to_char((b.tot_su3/a.tot_su3)*100, 999.99))) tot_su3, decode(a.tot_amt3, 0,0, to_number(to_char((b.tot_amt3/a.tot_amt3)*100, 999.99))) tot_amt3 from \n"+
						" ( select count(*) tot_su3, nvl(sum(req_amt),0) tot_amt3 from ("+sub_query+") where req_dt < to_char(SYSDATE, 'YYYY-MM-DD') and (pay_dt is null or pay_dt = to_char(SYSDATE, 'YYYY-MM-DD')) ) a,\n"+
						" ( select count(*) tot_su3, nvl(sum(req_amt),0) tot_amt3 from ("+sub_query+") where req_dt < to_char(SYSDATE, 'YYYY-MM-DD') and pay_dt = to_char(SYSDATE, 'YYYY-MM-DD') ) b\n"+
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
			System.out.println("[AddInsurHDatabase:getInsurHStat]\n"+e);
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

	// 휴차료/대차료 건별 스케줄 리스트 조회
	public Vector getInsurHScd(String m_id, String l_cd, String c_id, String accid_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select\n"+
					" a.accid_id, b.seq_no, decode(b.pay_dt, '','미수금','수금') gubun,\n"+
					" decode(a.accid_st, '1','피해자', '2','가해자', '3','쌍방', '4','자차사고') accid_st, b.ins_com ot_ins,\n"+
					" decode(b.req_gu, '1','휴차료', '2','대차료') req_gu, "+
					" decode(b.pay_gu,'',decode(b.pay_dt,'',b.req_gu,b.pay_gu),b.pay_gu) pay_gu,"+
					" b.req_amt, b.pay_amt, b.dly_amt, b.dly_days,\n"+
					" nvl2(a.accid_dt,substr(a.accid_dt,1,4)||'-'||substr(a.accid_dt,5,2)||'-'||substr(a.accid_dt,7,2),'') accid_dt,\n"+
					" nvl2(b.req_dt,substr(b.req_dt,1,4)||'-'||substr(b.req_dt,5,2)||'-'||substr(b.req_dt,7,2),'') req_dt,\n"+
					" nvl2(b.pay_dt,substr(b.pay_dt,1,4)||'-'||substr(b.pay_dt,5,2)||'-'||substr(b.pay_dt,7,2),' ') pay_dt,\n"+
					" nvl2(j.tax_dt,substr(j.tax_dt,1,4)||'-'||substr(j.tax_dt,5,2)||'-'||substr(j.tax_dt,7,2),' ') ext_dt\n"+
					" from accident a, my_accid b,\n"+
					" (select bb.tax_dt, aa.* from tax_item_list aa, tax bb where aa.item_id=bb.item_id and bb.tax_st='O' and aa.gubun in ('11','12')) j\n"+
					" where\n"+
					" a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id\n"+
					" and b.car_mng_id=j.car_mng_id(+) and b.accid_id=j.tm(+) and b.seq_no=j.rent_seq(+)\n"+
					" and b.req_st <> '0' and b.req_amt > 0 \n"+	
					" and a.rent_mng_id='"+m_id+"' and a.rent_l_cd='"+l_cd+"' and a.car_mng_id='"+c_id+"'";
	
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			while(rs.next())
			{				
	            InsHScdBean bean = new InsHScdBean();

				bean.setRent_mng_id	(m_id); 
				bean.setRent_l_cd	(l_cd); 
			    bean.setCar_mng_id	(c_id); 					
				bean.setAccid_id	(rs.getString("accid_id")); 				
				bean.setGubun		(rs.getString("gubun")); 
				bean.setAccid_dt	(rs.getString("accid_dt")); 
				bean.setAccid_st	(rs.getString("accid_st")); 
				bean.setOt_ins		(rs.getString("ot_ins")==null?"":rs.getString("ot_ins"));
				bean.setReq_gu		(rs.getString("req_gu")); 
				bean.setReq_amt		(rs.getInt   ("req_amt")); 
				bean.setPay_amt		(rs.getInt   ("pay_amt")); 
				bean.setDly_amt		(rs.getInt   ("dly_amt")); 
				bean.setDly_days	(rs.getString("dly_days")); 
				bean.setReq_dt		(rs.getString("req_dt").trim());
				bean.setPay_dt		(rs.getString("pay_dt")==null?"":rs.getString("pay_dt").trim());
				bean.setExt_dt		(rs.getString("ext_dt")==null?"":rs.getString("ext_dt").trim());
				bean.setSeq_no		(rs.getInt   ("seq_no")); 
				bean.setPay_gu		(rs.getString("pay_gu")==null?"":rs.getString("pay_gu")); 
				vt.add(bean);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddInsurHDatabase:getInsurHScd]\n"+e);
			System.out.println("[AddInsurHDatabase:getInsurHScd]\n"+query);
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

	// 휴차료/대차료 건별 스케줄 리스트 통계
	public IncomingBean getInsurHScdStat(String m_id, String l_cd, String c_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		IncomingBean ins_m = new IncomingBean();

		String sub_query = "";
		sub_query = " select a.* from my_accid a, accident b"+
					" where a.req_amt > 0 and a.req_st <> '0' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id"+
					" and b.rent_mng_id='"+m_id+"' and b.rent_l_cd='"+l_cd+"' and b.car_mng_id='"+c_id+"'"; // and a.accid_id='"+accid_id+"' and a.serv_id='"+serv_id+"'";

		String query = "";
		query = " select a.*, b.*, c.* from\n"+
					" ( select count(*) tot_su1, nvl(sum(req_amt),0) tot_amt1 from ("+sub_query+") where pay_dt is null) a, \n"+
					" ( select count(*) tot_su2, nvl(sum(req_amt),0) tot_amt2 from ("+sub_query+") where pay_dt is not null) b, \n"+
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
			System.out.println("[AddInsurHDatabase:getInsurHScdStat]\n"+e);
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
	 *	휴차료/대차료 건별 스케줄 한회차 면책금 쿼리(한 라인)
	 */
	public InsHScdBean getScd(String m_id, String l_cd, String c_id, String accid_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		InsHScdBean ins_h_scd = new InsHScdBean();
		String query =  " select a.req_amt, a.pay_amt, a.dly_amt, a.dly_days,"+
						" a.req_dt, a.pay_dt from my_accid a, accident b"+
						" where a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id "+
						" and b.RENT_MNG_ID=? and b.RENT_L_CD=? and b.CAR_MNG_ID=? and b.ACCID_ID=?";
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, m_id);
			pstmt.setString(2, l_cd);
			pstmt.setString(3, c_id);
			pstmt.setString(4, accid_id);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{
				ins_h_scd.setRent_mng_id(m_id); 
				ins_h_scd.setRent_l_cd(l_cd); 
			    ins_h_scd.setCar_mng_id(c_id); 					
				ins_h_scd.setAccid_id(accid_id); 				
				ins_h_scd.setReq_amt(rs.getInt("req_amt")); 
				ins_h_scd.setPay_amt(rs.getInt("pay_amt")); 
				ins_h_scd.setDly_amt(rs.getInt("dly_amt")); 
				ins_h_scd.setDly_days(rs.getString("dly_days")); 
				ins_h_scd.setReq_dt(rs.getString("req_dt"));
				ins_h_scd.setPay_dt(rs.getString("pay_dt"));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddInsurHDatabase:getScd]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ins_h_scd;
		}				
	}


	// 수정 -------------------------------------------------------------------------------------------------
	
	/**
	 *	휴차료/대차료 연체료 계산 : ins_h_c.jsp
	 */
	public boolean calDelay(String c_id){
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;

		//연체일 있는 경우(입금:입금일>입금예정일, 미입금:현재날자>입금예정일)
		String query1 = "";
		query1= " UPDATE MY_ACCID SET"+
				" dly_days=TRUNC(NVL(TO_DATE(pay_dt, 'YYYYMMDD'), SYSDATE) - TO_DATE(req_dt, 'YYYYMMDD')),"+
				" dly_amt=(TRUNC(((req_amt)*0.18*TRUNC(TO_DATE(req_dt, 'YYYYMMDD')- NVL(TO_DATE(pay_dt, 'YYYYMMDD'), SYSDATE)))/365) * -1)"+
				" WHERE car_mng_id=? "+//and accid_id=?//rent_mng_id=? and rent_l_cd=? and +// and serv_id=?"+
				" and SIGN(TRUNC(NVL(TO_DATE(pay_dt, 'YYYYMMDD'), SYSDATE) - TO_DATE(req_dt, 'YYYYMMDD'))) > 0";
	
		//연체일 없는 경우(입금:입금일=입금예정일, 입금일<입금예정일(선수), 미입금:현재날짜<입금예정일)
		String query2 = "";
		query2= " UPDATE MY_ACCID set"+
				" dly_days = '0',"+
				" dly_amt = 0"+
				" WHERE car_mng_id=? "+//and accid_id=?//rent_mng_id=? and rent_l_cd=? and +// and serv_id=?"+
				" and SIGN(TRUNC(NVL(TO_DATE(pay_dt, 'YYYYMMDD'), SYSDATE) - TO_DATE(req_dt, 'YYYYMMDD'))) < 1";
		try 
		{
			conn.setAutoCommit(false);
			
			pstmt1 = conn.prepareStatement(query1);
			pstmt1.setString(1, c_id);
		    pstmt1.executeUpdate();
			pstmt1.close();

		    pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString(1, c_id);
		    pstmt2.executeUpdate();
			pstmt2.close();
		    
		    conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddInsurHDatabase:calDelay]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{	
                if(pstmt1 != null )		pstmt1.close();
                if(pstmt2 != null)		pstmt2.close();
                conn.setAutoCommit(true);
			}
			catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	/**
	 *	휴차료/대차료 스케줄 변동사항 : 입금처리, 입금취소, 청구금액 수정, 입금일자 수정 ins_m_c.jsp
	 */
	public boolean updateInsHScd(InsHScdBean cng_ins_hs, String cmd, String pay_yn){
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		//1.입금처리
		String query1 = " UPDATE MY_ACCID SET pay_dt=replace(?, '-', ''), ext_dt=replace(?, '-', ''), pay_amt=?, update_dt=to_char(sysdate,'YYYYMMDD'), update_id=?"+
						" WHERE car_mng_id=? and accid_id=?";
		//2.입금취소
		String query2 = " UPDATE MY_ACCID SET pay_dt=?, ext_dt=replace(?, '-', ''), pay_amt=0, update_dt=to_char(sysdate,'YYYYMMDD'), update_id=?"+
						" WHERE car_mng_id=? and accid_id=?";
		//3.청구금액 수정
		String query3 = " UPDATE MY_ACCID SET req_amt=?, ext_dt=replace(?, '-', ''), update_dt=to_char(sysdate,'YYYYMMDD'), update_id=?"+
						" WHERE car_mng_id=? and accid_id=?";
		//4.입금일자 수정
		String query4 = " UPDATE MY_ACCID SET pay_dt=replace(?, '-', ''), ext_dt=replace(?, '-', ''), pay_amt=?, update_dt=to_char(sysdate,'YYYYMMDD'), update_id=?"+
						" WHERE car_mng_id=? and accid_id=?";

		try 
		{
			conn.setAutoCommit(false);
		
			if(cmd.equals("p")){			//입금처리
				pstmt = conn.prepareStatement(query1);
				pstmt.setString(1, cng_ins_hs.getPay_dt().trim());
				pstmt.setString(2, cng_ins_hs.getExt_dt().trim());
				pstmt.setInt(3, cng_ins_hs.getPay_amt());
				pstmt.setString(4, cng_ins_hs.getUpdate_id().trim());
				pstmt.setString(5, cng_ins_hs.getCar_mng_id().trim());
				pstmt.setString(6, cng_ins_hs.getAccid_id().trim());

			}else if(cmd.equals("c")){		//입금취소
				pstmt = conn.prepareStatement(query2);
				pstmt.setString(1, "");	
				pstmt.setString(2, cng_ins_hs.getExt_dt().trim());
				pstmt.setString(3, cng_ins_hs.getUpdate_id().trim());
				pstmt.setString(4, cng_ins_hs.getCar_mng_id().trim());
				pstmt.setString(5, cng_ins_hs.getAccid_id().trim());

			}else{	
				if(pay_yn.equals("N")){		//미입금수정-입금액
					pstmt = conn.prepareStatement(query3);
					pstmt.setInt(1, cng_ins_hs.getReq_amt());
					pstmt.setString(2, cng_ins_hs.getExt_dt().trim());
					pstmt.setString(3, cng_ins_hs.getUpdate_id().trim());
					pstmt.setString(4, cng_ins_hs.getCar_mng_id().trim());
					pstmt.setString(5, cng_ins_hs.getAccid_id().trim());

				}else{						//입금수정-입금일
					pstmt = conn.prepareStatement(query4);
					pstmt.setString(1, cng_ins_hs.getPay_dt().trim());
					pstmt.setString(2, cng_ins_hs.getExt_dt().trim());
					pstmt.setInt(3, cng_ins_hs.getPay_amt());
					pstmt.setString(4, cng_ins_hs.getUpdate_id().trim());
					pstmt.setString(5, cng_ins_hs.getCar_mng_id().trim());
					pstmt.setString(6, cng_ins_hs.getAccid_id().trim());

				}
			}

		    pstmt.executeUpdate();

			if( cmd.equals("p") || (cmd.equals("u")&&pay_yn.equals("Y")) ){
				flag = calDelay(cng_ins_hs.getCar_mng_id().trim());
			}
			pstmt.close();
			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddInsurHDatabase:updateInsHScd]\n"+e);
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

	// 휴차료/대차료 건별 스케줄 리스트 조회
	public Vector getInsurHScd_20090507(String m_id, String l_cd, String c_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select\n"+
					" a.accid_id, b.seq_no, decode(b.pay_dt, '','미수금','수금') gubun,\n"+
					" decode(a.accid_st, '1','피해자', '2','가해자', '3','쌍방', '4','자차사고') accid_st, b.ins_com ot_ins,\n"+
					" decode(b.req_gu, '1','휴차료', '2','대차료') req_gu, "+
					" decode(b.pay_gu,'',decode(b.pay_dt,'',b.req_gu,b.pay_gu),b.pay_gu) pay_gu,"+
					" b.req_amt, b.pay_amt, b.dly_amt, b.dly_days,\n"+
					" nvl2(a.accid_dt,substr(a.accid_dt,1,4)||'-'||substr(a.accid_dt,5,2)||'-'||substr(a.accid_dt,7,2),'') accid_dt,\n"+
					" nvl2(b.req_dt,substr(b.req_dt,1,4)||'-'||substr(b.req_dt,5,2)||'-'||substr(b.req_dt,7,2),'') req_dt,\n"+
					" nvl2(b.pay_dt,substr(b.pay_dt,1,4)||'-'||substr(b.pay_dt,5,2)||'-'||substr(b.pay_dt,7,2),' ') pay_dt,\n"+
					" nvl2(j.tax_dt,substr(j.tax_dt,1,4)||'-'||substr(j.tax_dt,5,2)||'-'||substr(j.tax_dt,7,2),' ') ext_dt\n"+
					" from accident a, my_accid b,\n"+
					" (select bb.tax_dt, aa.* from tax_item_list aa, tax bb where aa.item_id=bb.item_id and bb.tax_st='O' and aa.gubun in ('11','12')) j\n"+
					" where\n"+
					" a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id\n"+
					" and b.car_mng_id=j.car_mng_id(+) and b.accid_id=j.tm(+) and b.seq_no=j.rent_seq(+)\n"+
					" and b.req_st <> '0' "+
					" and b.req_amt > 0 \n"+	
					" and a.rent_mng_id='"+m_id+"' and a.rent_l_cd='"+l_cd+"' and a.car_mng_id='"+c_id+"'";
	
//				System.out.println("[AddInsurHDatabase:getInsurHScd_20090507]\n"+query);

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			int cnt = 0;
			while(rs.next())
			{				

				cnt++;

				InsHScdBean bean = new InsHScdBean();

				bean.setRent_mng_id	(m_id); 
				bean.setRent_l_cd	(l_cd); 
			    bean.setCar_mng_id	(c_id); 	

				bean.setAccid_id	(rs.getString("accid_id")); 				
				bean.setGubun		(rs.getString("gubun")); 
				bean.setAccid_dt	(rs.getString("accid_dt")); 
				bean.setAccid_st	(rs.getString("accid_st")); 
				bean.setOt_ins		(rs.getString("ot_ins")==null?"":rs.getString("ot_ins").trim());
				bean.setReq_gu		(rs.getString("req_gu")==null?"":rs.getString("req_gu").trim()); 
				bean.setReq_amt		(rs.getInt   ("req_amt")); 
				bean.setPay_amt		(rs.getInt   ("pay_amt")); 
				bean.setDly_amt		(rs.getInt   ("dly_amt")); 
				bean.setDly_days	(rs.getString("dly_days")==null?"":rs.getString("dly_days").trim()); 
				bean.setReq_dt		(rs.getString("req_dt")==null?"":rs.getString("req_dt").trim());
				bean.setPay_dt		(rs.getString("pay_dt")==null?"":rs.getString("pay_dt").trim());
				bean.setExt_dt		(rs.getString("ext_dt")==null?"":rs.getString("ext_dt").trim());
				bean.setSeq_no		(rs.getInt   ("seq_no")); 
				bean.setPay_gu		(rs.getString("pay_gu")==null?"":rs.getString("pay_gu")); 

				vt.add(bean);	
			}

			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddInsurHDatabase:getInsurHScd_20090507]\n"+e);
			System.out.println("[AddInsurHDatabase:getInsurHScd_20090507]\n"+query);
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
