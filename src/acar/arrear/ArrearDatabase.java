package acar.arrear;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.cont.*;
import acar.util.*;
import acar.account.*;


public class ArrearDatabase
{
	private Connection conn = null;
	public static ArrearDatabase f_db;
	
	public static ArrearDatabase getInstance()
	{
		if(ArrearDatabase.f_db == null)
			ArrearDatabase.f_db = new ArrearDatabase();
		return ArrearDatabase.f_db;	
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


	
	public Vector getFeeScdSumk(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String query1 = "";
		
		if(gubun2.equals("3")){
			if(gubun4.equals("1")){	//일반연체		
				query1 = " and to_number(b.dly_days) between 1 and 30  ";
			}else if(gubun4.equals("2")){ //악성연체
				query1 = "  ";
			}else if(gubun4.equals("3")){ //악성연체
				query1 = "  ";
			}else if(gubun4.equals("4")){ //악성연체
				query1 = " ";		
			}else{}
		}
		
		

			query = " select dept_id, enter_dt, br_id, bus_id2, bus_nm2,  count(rent_l_cd) as tot_d_cnt , sum(fee_amt) as tot_d_amt , 0 as tot_h_cnt, 0 as tot_h_amt  from  ( " +
				" select  dept_id, enter_dt, br_id, bus_id2, credit_method,  bus_nm2, rent_l_cd, sum(fee_amt) fee_amt from ( "+
			    " select f.dept_id, f.enter_dt, f.br_id, ar.credit_method, f.user_nm as bus_nm2, b.bus_id2,  (a.fee_s_amt+a.fee_v_amt) fee_amt, a.rent_l_cd  "+
				" from scd_fee a, cont b, client c, car_reg d, client_site e, users f,  "+
				" (select rent_l_cd from cls_cont where cls_st='2') i,"+
				" (select rent_l_cd, max(credit_method) credit_method from arrear where arr_type='1' group by rent_l_cd ) ar,"+
				" (select rent_l_cd, min(fee_est_dt) fee_est_dt from scd_fee where rc_yn='0' and tm_st2<>'4' group by rent_l_cd) j,"+
			    " (select a.client_id, min(b.r_fee_est_dt) r_fee_est_dt from cont a, scd_fee b, cls_cont c where a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd(+) and nvl(c.cls_st,'0') <> '2' and nvl(b.bill_yn,'Y')='Y'  and b.tm_st2<>'4' and b.rc_yn='0' " + query1+ " group by a.client_id) k, "+
			    " (select b.rent_l_cd , max(to_number(b.dly_days))  max_dly_days from cont a, scd_fee b, cls_cont c where a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd(+) and nvl(c.cls_st,'0') <> '2' and nvl(b.bill_yn,'Y')='Y'  and b.tm_st2<>'4' and b.rc_yn='0' group by b.rent_l_cd) mm "+
				" where"+
				" nvl(a.bill_yn,'Y')='Y' and a.tm_st2<>'4' and a.rent_l_cd=b.rent_l_cd"+
				" and b.client_id=c.client_id"+
				" and b.car_mng_id=d.car_mng_id"+
				" and b.client_id=e.client_id(+) and b.r_site=e.seq(+)"+
				" and b.bus_id2=f.user_id(+)"+
				" and f.br_id = '" + br_id + "'" +
				" and a.rent_l_cd=i.rent_l_cd(+) and i.rent_l_cd is null"+
				" and a.rent_l_cd=j.rent_l_cd(+)"+
				" and a.rent_l_cd=ar.rent_l_cd(+)"+
				" and b.client_id=k.client_id(+)";
				
		String fee_mon	= "substr(a.r_fee_est_dt,1,6)";
		String now_mon	= "to_char(sysdate,'YYYYMM')";
		String rc_mon	= "substr(a.rc_dt,1,6)";
		String fee_dt	= "a.r_fee_est_dt";
		String rc_dt	= "a.rc_dt";
		String now_dt	= "to_char(sysdate,'YYYYMMDD')";

		
		//연체------------------------------------------------------------------------------------------------------------
		//미수금
		if(gubun2.equals("3") && gubun3.equals("3")){	query += " and "+fee_dt+"<"+now_dt+" and a.rc_yn='0'";
		//당일+연체------------------------------------------------------------------------------------------------------------
		//미수금
		}else if(gubun2.equals("6") && gubun3.equals("3")){	query += " and "+fee_dt+"<="+now_dt+" and a.rc_yn='0'";
		}

	

		/*연체조회*/
		if(gubun2.equals("3")){
				if(gubun4.equals("1")){	//관심연체	
					query += " and dly_days between 1 and 30 ";
				}else if(gubun4.equals("2")){ //주의연체
					query += " and dly_days between 31 and 90 ";
				}else if(gubun4.equals("3")){ //경고연체
					query += " and dly_days between 91 and 120 ";
				}else if(gubun4.equals("4")){ //악성연체
					query += " and dly_days > 120 ";				
				}	
		}
		/*검색조건*/
			
		if(s_kd.equals("1"))		query += " and nvl(c.firm_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("2"))	query += " and nvl(c.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(a.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and nvl(d.car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("8"))	query += " and b.BUS_ID2= '"+t_wd+"'\n";
		
		
		query +=" ) aa  group by enter_dt, credit_method,  rent_l_cd ,  bus_nm2 ,  br_id , bus_id2 , dept_id ) bb group by dept_id, enter_dt, br_id, bus_id2, bus_nm2 ";
 
 
		String query2 = "";

		query2 =	" select /*+  merge(b) */ \n"+
					"        f.dept_id, f.enter_dt, f.br_id, f.user_nm as bus_nm2 , nvl(ar.credit_method,'') as credit_method, a.rent_mng_id, a.rent_l_cd,  \n"+
					"        a.ext_s_amt as s_amt, (nvl(a.ext_s_amt,0)+nvl(a.ext_v_amt,0)) as amt,"+
					"        a.dly_amt, to_number(trim(nvl(a.dly_days,'0')))  as dly_days, b.bus_id2, b.rent_st, b.use_yn, \n"+
					"        nvl2(d.cls_dt,substr(d.cls_dt,1,4)||'-'||substr(d.cls_dt,5,2)||'-'||substr(d.cls_dt,7,2),'') cls_dt,\n"+
					"        nvl2(a.ext_est_dt,substr(a.ext_est_dt,1,4)||'-'||substr(a.ext_est_dt,5,2)||'-'||substr(a.ext_cls_est_dt,7,2),'') est_dt,\n"+
					"        nvl2(a.ext_pay_dt,substr(a.ext_pay_dt,1,4)||'-'||substr(a.ext-pay_dt,5,2)||'-'||substr(a.ext_pay_dt,7,2),'') pay_dt\n"+
					" from   scd_ext a, cont_n_view b, cls_cont d, arrear ar, users f \n"+
					" where\n"+
					"        a.ext_st = '4' "+
					"        and a.ext_s_amt is not null and d.cls_doc_yn='Y' and nvl(a.bill_yn,'Y')='Y'"+
					"        and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd "+
					"        and a.rent_l_cd = ar.rent_l_cd(+) and a.rent_mng_id = ar.rent_mng_id(+) "+
					"        and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd "+
					"        and b.bus_id2 = f.user_id "+
					"        and f.br_id = '" + br_id + "'"+
					" ";
		//해지대여료
		String query3 = "";
		query3 =	" select /*+  merge(c) */ "+
					"        f.dept_id, f.enter_dt, f.br_id, f.user_nm  as bus_nm2, nvl(ar.credit_method,'') as credit_method, a.rent_mng_id, a.rent_l_cd, "+
					"        a.fee_s_amt as s_amt, a.fee_amt as amt,"+
					"        0 dly_amt, a.dly_day as dly_days, a.bus_id2, a.rent_st,  c.use_yn,"+
					"        nvl2(b.cls_dt,substr(b.cls_dt,1,4)||'-'||substr(b.cls_dt,5,2)||'-'||substr(b.cls_dt,7,2),'') cls_dt,\n"+
					"        a.fee_est_dt as est_dt, a.rc_dt as pay_dt"+
					" from   fee_view a, cls_cont b, cont_n_view c, arrear ar, users f "+
					" where  "+
					"        a.use_yn='N' and nvl(a.bill_yn,'Y')='Y'"+
					"        and b.cls_st ='2' "+
					"        and a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd "+
					"        and a.rent_l_cd = ar.rent_l_cd(+) "+
					"        and c.bus_id2 = f.user_id and f.br_id = '" + br_id + "'"+
					" ";

		//합체
		String query4 = " select dept_id, enter_dt, br_id, bus_id2, bus_nm2, 0 as tot_d_cnt, 0 as tot_d_amt, count(rent_l_cd) as tot_h_cnt, sum (amt) tot_h_amt from ( \n"+query2+"\n union all \n"+query3+"\n ) where rent_l_cd is not null ";		


		/*상세조회&&세부조회*/

	
		//연체-계획
		if(gubun2.equals("3") && gubun3.equals("1")){	query4 += " and est_dt < to_char(SYSDATE, 'YYYY-MM-DD') and (pay_dt is null or pay_dt = to_char(SYSDATE, 'YYYY-MM-DD'))";
		//연체-수금
		}else if(gubun2.equals("3") && gubun3.equals("2")){	query4 += " and est_dt < to_char(SYSDATE, 'YYYY-MM-DD') and pay_dt = to_char(SYSDATE, 'YYYY-MM-DD')";
		//연체-미수금
		}else if(gubun2.equals("3") && gubun3.equals("3")){	query4 += " and est_dt < to_char(SYSDATE, 'YYYY-MM-DD') and pay_dt is null";
			
		}
		

		/*연체조회*/
		if(gubun2.equals("3")){
				if(gubun4.equals("1")){	//관심연체	
					query4 += " and dly_days between 1 and 30 ";
				}else if(gubun4.equals("2")){ //주의연체
					query4 += " and dly_days between 31 and 90 ";
				}else if(gubun4.equals("3")){ //경고연체
					query4 += " and dly_days between 91 and 120 ";
				}else if(gubun4.equals("4")){ //악성연체
					query4 += " and dly_days > 120 ";				
				}	
		}

		query4 += "  group by enter_dt, br_id, bus_id2, bus_nm2, dept_id "; 
 
 		String query5 =" select dept_id, enter_dt, br_id, bus_id2, bus_nm2, sum(tot_d_cnt) as tot_d_cnt, sum(tot_d_amt) as tot_d_amt, sum(tot_h_cnt) as tot_h_cnt, sum(tot_h_amt) as tot_h_amt from  ( "+ query + " union all ( "+ query4 + " )) group by enter_dt, br_id, bus_id2, bus_nm2, dept_id  order by br_id, dept_id, bus_nm2";
 		               
 		
		
		try {
			
		//	System.out.println(query5);
			
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query5);
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
			System.out.println("[ArrearDatabase:getFeeScdSumk]\n"+e);
			System.out.println("[ArrearDatabase:getFeeScdSumk]\n"+query);
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
	
	
	public Vector getFeeScdSum(String br_id, String gubun1, String gubun2, String gubun3, String gubun4)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String query1 = "";
		String query_dept = "";
		
		/*연체조회*/
		if(gubun2.equals("3")){
			if(gubun4.equals("1")){	//일반연체		
				query1 = " and to_number(b.dly_days) between 1 and 30  ";
			}else if(gubun4.equals("2")){ //악성연체
				query1 = " and to_number(b.dly_days) between 31 and 60 ";
			}else if(gubun4.equals("3")){ //악성연체
				query1 = " and to_number(b.dly_days) between 91 and 180 ";
			}else if(gubun4.equals("4")){ //악성연체
				query1 = " ";		
			}else{}
		}
		
		if (br_id.equals("9999"))
			query_dept = " and f.dept_id in ('0003', '9999', '0004') "; 
		else 	    
			query_dept = " and f.dept_id = '" + br_id + "'" ; 

		query = " select dept_id, enter_dt, br_id, bus_id2, bus_nm2,  count(rent_l_cd) as tot_d_cnt , sum(fee_amt) as tot_d_amt , 0 as tot_h_cnt, 0 as tot_h_amt  from  ( \n" +
				" select  dept_id, enter_dt, br_id, bus_id2, bus_nm2, rent_l_cd, sum(fee_amt) fee_amt from (  \n" +
			    " select f.dept_id, f.enter_dt, f.br_id, f.user_nm as bus_nm2, b.bus_id2,  (a.fee_s_amt+a.fee_v_amt) fee_amt, a.rent_l_cd  \n" +
				" from scd_fee a, cont b, client c, client_site e, users f,   \n" +
				" (select rent_l_cd from cls_cont where cls_st='2') i,  \n" +
				" (select rent_l_cd, min(fee_est_dt) fee_est_dt from scd_fee where rc_yn='0' and tm_st2<>'4'  group by rent_l_cd) j,  \n" +
			    " (select a.client_id, min(b.r_fee_est_dt) r_fee_est_dt from cont a, scd_fee b, cls_cont c where a.rent_mng_id = b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd(+) and nvl(c.cls_st,'0') <> '2' and nvl(b.bill_yn,'Y')='Y' and b.tm_st2<>'4'  and b.rc_yn='0' " + query1+ " group by a.client_id) k,  \n" +
			    " (select b.rent_l_cd , max(to_number(b.dly_days))  max_dly_days from cont a, scd_fee b, cls_cont c where a.rent_mng_id = b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd(+) and nvl(c.cls_st,'0') <> '2' and nvl(b.bill_yn,'Y')='Y' and b.tm_st2<>'4'  and b.rc_yn='0' group by b.rent_l_cd) mm  \n" +
				" where  \n" +
				" nvl(a.bill_yn,'Y')='Y' and a.tm_st2<>'4'  and  a.rent_mng_id = b.rent_mng_id and a.rent_l_cd=b.rent_l_cd  \n" +
				" and b.client_id=c.client_id  \n" +
				" and b.client_id=e.client_id(+) and b.r_site=e.seq(+)  \n" +
				" and b.bus_id2=f.user_id(+)" + query_dept +
				" and a.rent_l_cd=i.rent_l_cd(+) and i.rent_l_cd is null \n" +
				" and a.rent_l_cd=j.rent_l_cd(+)  \n" +
				" and b.client_id=k.client_id(+)";
				
		String fee_mon	= "substr(a.r_fee_est_dt,1,6)";
		String now_mon	= "to_char(sysdate,'YYYYMM')";
		String rc_mon	= "substr(a.rc_dt,1,6)";
		String fee_dt	= "a.r_fee_est_dt";
		String rc_dt	= "a.rc_dt";
		String now_dt	= "to_char(sysdate,'YYYYMMDD')";

		
		//연체------------------------------------------------------------------------------------------------------------
		//미수금
		if(gubun2.equals("3") && gubun3.equals("3")){	query += " and "+fee_dt+"<"+now_dt+" and a.rc_yn='0' \n";
		//당일+연체------------------------------------------------------------------------------------------------------------
		//미수금
		}else if(gubun2.equals("6") && gubun3.equals("3")){	query += " and "+fee_dt+"<="+now_dt+" and a.rc_yn='0' \n";
		}

		
		/*연체조회*/
		
		if(gubun2.equals("3")){
			if(gubun4.equals("1")){	//관심연체		
				query += " and mm.max_dly_days  between 1 and 30 and a.rent_l_cd in ( mm.rent_l_cd )  \n";
			}else if(gubun4.equals("2")){ //주의연체
				query += " and  mm.max_dly_days  between 31 and 60 and a.rent_l_cd in ( mm.rent_l_cd ) \n";
			}else if(gubun4.equals("3")){ //경고연체
				query += " and  mm.max_dly_days  between 91 and 180 and a.rent_l_cd in ( mm.rent_l_cd ) \n";
			}else if(gubun4.equals("4")){ //악성연체
				query += " and  mm.max_dly_days > 180 and a.rent_l_cd in ( mm.rent_l_cd ) \n";	
			}else{}
		}
			
		
		query +=" ) aa  group by enter_dt, rent_l_cd ,  bus_nm2 ,  br_id , bus_id2 , dept_id ) bb group by dept_id, enter_dt, br_id, bus_id2, bus_nm2 \n";
 
 
		String query2 = "";

		query2 =	" select /*+ index(a SCD_EXT_IDX6 )  no_merge(b) */ "+
					"        f.dept_id, f.enter_dt, f.br_id, f.user_nm as bus_nm2 , a.rent_mng_id, a.rent_l_cd,  \n"+
					"        a.ext_s_amt as s_amt, (nvl(a.ext_s_amt,0)+nvl(a.ext_v_amt,0)) as amt,  \n" +
					"        a.dly_amt, to_number(trim(nvl(a.dly_days,'0')))  as dly_days, b.bus_id2, b.use_yn, \n"+
					"        nvl2(d.cls_dt,substr(d.cls_dt,1,4)||'-'||substr(d.cls_dt,5,2)||'-'||substr(d.cls_dt,7,2),'') cls_dt,\n"+
					"        nvl2(a.ext_est_dt,substr(a.ext_est_dt,1,4)||'-'||substr(a.ext_est_dt,5,2)||'-'||substr(a.ext_est_dt,7,2),'') est_dt,\n"+
					"        nvl2(a.ext_pay_dt,substr(a.ext_pay_dt,1,4)||'-'||substr(a.ext_pay_dt,5,2)||'-'||substr(a.ext_pay_dt,7,2),'') pay_dt\n"+
					" from   scd_ext a, cont_n_view b,  users f , cls_cont d \n"+
					" where\n"+
					"        a.ext_st = '4' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_mng_id = d.rent_mng_id and b.rent_l_cd = d.rent_l_cd  \n" +
					"        and b.bus_id2 = f.user_id  " + query_dept + 
					"        and (nvl(a.ext_s_amt,0)+nvl(a.ext_v_amt,0)) > 0 and nvl(a.bill_yn,'Y')='Y'";
		//해지대여료
		String query3 = "";
		query3 =	" select /*+  no_merge(a) */ "+
					"        f.dept_id, f.enter_dt, f.br_id, f.user_nm  as bus_nm2, a.rent_mng_id, a.rent_l_cd,  \n" +
					"        a.fee_s_amt as s_amt, a.fee_amt as amt,  \n" +
					"        0 dly_amt, a.dly_day as dly_days, a.bus_id2, c.use_yn,"+
					"        nvl2(b.cls_dt,substr(b.cls_dt,1,4)||'-'||substr(b.cls_dt,5,2)||'-'||substr(b.cls_dt,7,2),'') cls_dt,\n"+
					"        a.fee_est_dt as est_dt, a.rc_dt as pay_dt  \n" +
					" from   fee_view a, cls_cont b, cont c,  users f  \n" +
					" where  b.rent_mng_id = a.rent_mng_id and b.rent_l_cd=a.rent_l_cd and b.rent_mng_id = c.rent_mng_id and  b.rent_l_cd=c.rent_l_cd and a.use_yn='N' and nvl(a.bill_yn,'Y')='Y'  \n" +
					"        and c.bus_id2 = f.user_id " + query_dept + 
					"        and b.cls_st ='2' ";

		//합체
		String query4 = " select dept_id, enter_dt, br_id, bus_id2, bus_nm2, 0 as tot_d_cnt, 0 as tot_d_amt, count(rent_l_cd) as tot_h_cnt, sum (amt) tot_h_amt from ( \n"+query2+"\n union all \n"+query3+"\n ) where rent_l_cd is not null ";		


		/*상세조회&&세부조회*/

	
		//연체-계획
		if(gubun2.equals("3") && gubun3.equals("1")){	query4 += " and est_dt < to_char(SYSDATE, 'YYYY-MM-DD') and (pay_dt is null or pay_dt = to_char(SYSDATE, 'YYYY-MM-DD'))";
		//연체-수금
		}else if(gubun2.equals("3") && gubun3.equals("2")){	query4 += " and est_dt < to_char(SYSDATE, 'YYYY-MM-DD') and pay_dt = to_char(SYSDATE, 'YYYY-MM-DD')";
		//연체-미수금
		}else if(gubun2.equals("3") && gubun3.equals("3")){	query4 += " and est_dt < to_char(SYSDATE, 'YYYY-MM-DD') and pay_dt is null";
			
		}
		

		/*연체조회*/
		if(gubun2.equals("3")){
				if(gubun4.equals("1")){	//관심연체	
					query4 += " and dly_days between 1 and 30 ";
				}else if(gubun4.equals("2")){ //주의연체
					query4 += " and dly_days between 31 and 60 ";
				}else if(gubun4.equals("3")){ //경고연체
					query4 += " and dly_days between 91 and 180 ";
				}else if(gubun4.equals("4")){ //악성연체
					query4 += " and dly_days > 180 ";				
				}	
		}

		query4 += "  group by enter_dt, br_id, bus_id2, bus_nm2, dept_id "; 
 
 		String query5 =" select dept_id, enter_dt, br_id, bus_id2, bus_nm2, sum(tot_d_cnt) as tot_d_cnt, sum(tot_d_amt) as tot_d_amt, sum(tot_h_cnt) as tot_h_cnt, sum(tot_h_amt) as tot_h_amt \n from  ( "+ query + " \n union all \n ( "+ query4 + " )) group by enter_dt, br_id, bus_id2, bus_nm2, dept_id  order by br_id, dept_id, bus_nm2";
 		               
 		
		
		try {
			
				
			stmt = conn.createStatement();
			  				
			
	    	rs = stmt.executeQuery(query5);
	    				
//		System.out.println(query5);
			
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
			System.out.println("[ArrearDatabase:getFeeScdSum]\n"+e);
			System.out.println("[ArrearDatabase:getFeeScdSum]\n"+query5);
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
	 *	대여료 연체관리 집계 - arrear/short_arrear.jsp
	 *
	 *	입금예정일 : E(0:당일이전, 1:당일, 2:예정)--> 단순하게 입금예정일과 당일 비교
	 *	수금일 : R(0:당일이전, 1:당일, 2:예정) --> 단순하게 수금일과 당일 비교
	 *	연체구분 : D(1:연체, 0:연체아님) 	--> 수금인경우 수금일 > 입금예정일, 미수금인경우 현재날짜 > 입금예정일
	 *	선수구분 : F(1:선수, 0:선수아님)	--> 수금인경우 수금일 < 입금예정일
	 *	수금상태 : RC_YN(0:미수, 1: 수금)	--> Y/N로 표시
	 */
	public Vector getFeeSum1(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String query1 = "";
		
		if(gubun2.equals("3")){
			if(gubun4.equals("1")){	//관심연체		
				query1 = " and to_number(b.dly_days) between 1 and 30  ";
			}else if(gubun4.equals("2")){ //주의연체
				query1 = "  ";
			}else if(gubun4.equals("3")){ //경고연체
				query1 = "  ";
			}else if(gubun4.equals("4")){ //악성연체
				query1 = " ";		
			}else{}
		}

		
		/*
		
		query = " select enter_dt, br_id, bus_id2, bus_nm2,  count(rent_l_cd) as tot_d_cnt , sum(fee_amt) as tot_d_amt , 0 as tot_h_cnt, 0 as tot_h_amt  from  ( " +
				" select enter_dt, br_id, bus_id2, credit_method, brch_id, rent_mng_id, rent_l_cd , firm_nm , car_mng_id, car_nm, car_no , bus_nm2 , use_yn , rent_st, min(fee_est_dt) fee_est_dt, sum(fee_amt) fee_amt, max(to_number(dly_days)) dly_days from ( "+
			    " select f.enter_dt, f.br_id, ar.credit_method, e.client_id, c.firm_nm, c.client_nm, e.r_site, d.car_mng_id, d.car_no, d.car_nm, b.brch_id, f.user_nm as bus_nm2, b.bus_id, b.bus_id2, b.use_yn,"+
				" (a.fee_s_amt+a.fee_v_amt) fee_amt, a.rent_mng_id, a.rent_l_cd , a.fee_est_dt, a.dly_chk, a.dly_days , a.bill_yn, a.r_fee_est_dt , a.rc_yn , a.rent_st "+
				" from scd_fee a, cont b, client c, car_reg d, client_site e, users f,  "+
				" (select rent_l_cd from cls_cont where cls_st='2') i,"+
				" (select rent_l_cd, max(credit_method) credit_method from arrear where arr_type='1' group by rent_l_cd ) ar,"+
				" (select rent_l_cd, min(fee_est_dt) fee_est_dt from scd_fee where rc_yn='0' group by rent_l_cd) j,"+
			    " (select a.client_id, min(b.r_fee_est_dt) r_fee_est_dt from cont a, scd_fee b, cls_cont c where a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd(+) and nvl(c.cls_st,'0') <> '2' and nvl(b.bill_yn,'Y')='Y' and b.rc_yn='0' " + query1+ " group by a.client_id) k, "+
			    " (select b.rent_l_cd , max(to_number(b.dly_days))  max_dly_days from cont a, scd_fee b, cls_cont c where a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd(+) and nvl(c.cls_st,'0') <> '2' and nvl(b.bill_yn,'Y')='Y' and b.rc_yn='0' group by b.rent_l_cd) mm "+
				" where"+
				" nvl(a.bill_yn,'Y')='Y' and a.rent_l_cd=b.rent_l_cd"+
				" and b.client_id=c.client_id"+
				" and b.car_mng_id=d.car_mng_id"+
				" and b.client_id=e.client_id(+) and b.r_site=e.seq(+)"+
				" and b.bus_id2=f.user_id(+)"+
				" and f.br_id = '" + br_id + "'" +
				" and a.rent_l_cd=i.rent_l_cd(+) and i.rent_l_cd is null"+
				" and a.rent_l_cd=j.rent_l_cd(+)"+
				" and a.rent_l_cd=ar.rent_l_cd(+)"+
				" and b.client_id=k.client_id(+)";
*/

			query = " select enter_dt, br_id, bus_id2, bus_nm2,  count(rent_l_cd) as tot_d_cnt , sum(fee_amt) as tot_d_amt , 0 as tot_h_cnt, 0 as tot_h_amt  from  ( " +
				" select  enter_dt, br_id, bus_id2, credit_method,  bus_nm2, rent_l_cd, sum(fee_amt) fee_amt from ( "+
			    " select f.enter_dt, f.br_id, ar.credit_method, f.user_nm as bus_nm2, b.bus_id2,  (a.fee_s_amt+a.fee_v_amt) fee_amt, a.rent_l_cd  "+
				" from scd_fee a, cont b, client c, car_reg d, client_site e, users f,  "+
				" (select rent_l_cd from cls_cont where cls_st='2') i,"+
				" (select rent_l_cd, max(credit_method) credit_method from arrear where arr_type='1' group by rent_l_cd ) ar,"+
				" (select rent_l_cd, min(fee_est_dt) fee_est_dt from scd_fee where rc_yn='0' and tm_st2<>'4'  group by rent_l_cd) j,"+
			    " (select a.client_id, min(b.r_fee_est_dt) r_fee_est_dt from cont a, scd_fee b, cls_cont c where a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd(+) and nvl(c.cls_st,'0') <> '2' and nvl(b.bill_yn,'Y')='Y' and b.tm_st2<>'4'  and b.rc_yn='0' " + query1+ " group by a.client_id) k, "+
			    " (select b.rent_l_cd , max(to_number(b.dly_days))  max_dly_days from cont a, scd_fee b, cls_cont c where a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd(+) and nvl(c.cls_st,'0') <> '2' and nvl(b.bill_yn,'Y')='Y' and b.tm_st2<>'4'  and b.rc_yn='0' group by b.rent_l_cd) mm "+
				" where"+
				" nvl(a.bill_yn,'Y')='Y' and a.tm_st2<>'4'  and a.rent_l_cd=b.rent_l_cd"+
				" and b.client_id=c.client_id"+
				" and b.car_mng_id=d.car_mng_id"+
				" and b.client_id=e.client_id(+) and b.r_site=e.seq(+)"+
				" and b.bus_id2=f.user_id(+)"+
				" and f.br_id = '" + br_id + "'" +
				" and a.rent_l_cd=i.rent_l_cd(+) and i.rent_l_cd is null"+
				" and a.rent_l_cd=j.rent_l_cd(+)"+
				" and a.rent_l_cd=ar.rent_l_cd(+)"+
				" and b.client_id=k.client_id(+)";
				
		String fee_mon	= "substr(a.r_fee_est_dt,1,6)";
		String now_mon	= "to_char(sysdate,'YYYYMM')";
		String rc_mon	= "substr(a.rc_dt,1,6)";
		String fee_dt	= "a.r_fee_est_dt";
		String rc_dt	= "a.rc_dt";
		String now_dt	= "to_char(sysdate,'YYYYMMDD')";

		
		//연체------------------------------------------------------------------------------------------------------------
		//미수금
		if(gubun2.equals("3") && gubun3.equals("3")){	query += " and "+fee_dt+"<"+now_dt+" and a.rc_yn='0'";
		//당일+연체------------------------------------------------------------------------------------------------------------
		//미수금
		}else if(gubun2.equals("6") && gubun3.equals("3")){	query += " and "+fee_dt+"<="+now_dt+" and a.rc_yn='0'";
		}

	
	/*연체조회*/
		if(gubun2.equals("3")){
				if(gubun4.equals("1")){	//관심연체	
					query += " and dly_days between 1 and 30 ";
				}else if(gubun4.equals("2")){ //주의연체
					query += " and dly_days between 31 and 90 ";
				}else if(gubun4.equals("3")){ //경고연체
					query += " and dly_days between 91 and 120 ";
				}else if(gubun4.equals("4")){ //악성연체
					query += " and dly_days > 120 ";				
				}	
		}

		/*검색조건*/
			
		if(s_kd.equals("1"))		query += " and nvl(c.firm_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("2"))	query += " and nvl(c.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(a.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and nvl(d.car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("8"))	query += " and b.BUS_ID2= '"+t_wd+"'\n";
		
		
		query +=" ) aa  group by enter_dt, credit_method,  rent_l_cd ,  bus_nm2 ,  br_id , bus_id2   ) bb group by enter_dt, br_id, bus_id2, bus_nm2 ";
 
						
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
			System.out.println("[ArrearDatabase:getFeeSum1]\n"+e);
			System.out.println("[ArrearDatabase:getFeeList1]\n"+query);
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
	 *	대여료 연체관리 리스트 - arrear/arrear_sc_in.jsp
	 *
	 *	입금예정일 : E(0:당일이전, 1:당일, 2:예정)--> 단순하게 입금예정일과 당일 비교
	 *	수금일 : R(0:당일이전, 1:당일, 2:예정) --> 단순하게 수금일과 당일 비교
	 *	연체구분 : D(1:연체, 0:연체아님) 	--> 수금인경우 수금일 > 입금예정일, 미수금인경우 현재날짜 > 입금예정일
	 *	선수구분 : F(1:선수, 0:선수아님)	--> 수금인경우 수금일 < 입금예정일
	 *	수금상태 : RC_YN(0:미수, 1: 수금)	--> Y/N로 표시
	 */
	public Vector getFeeList1(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String query1 = "";
		
		if(gubun2.equals("3")){
			if(gubun4.equals("1")){	//관심연체		
				query1 = " and to_number(b.dly_days) between 1 and 30  ";
			}else if(gubun4.equals("2")){ //주의연체
				query1 = "  and to_number(b.dly_days) between 31 and 90  ";
			}else if(gubun4.equals("3")){ //경고연체
				query1 = "  and to_number(b.dly_days) between 91 and 120  ";
			}else if(gubun4.equals("4")){ //악성연체
				query1 = " ";		
			}else{}
		}
	
		
		query = " select '' credit_method, brch_id, rent_mng_id, rent_l_cd , firm_nm , car_mng_id, car_nm, car_no , bus_nm2 , use_yn , rent_st, min(fee_est_dt) fee_est_dt, sum(fee_amt) fee_amt,  max(to_number(dly_days))  dly_days from (  \n "+
			    " select  c.client_id, c.firm_nm, c.client_nm, e.r_site, d.car_mng_id, d.car_no, d.car_nm, b.brch_id, f.user_nm as bus_nm2, b.bus_id, b.bus_id2, nvl(b.use_yn,'Y') use_yn ,  \n "+
				" (a.fee_s_amt+a.fee_v_amt) fee_amt, a.rent_mng_id, a.rent_l_cd , a.fee_est_dt, a.dly_chk, nvl(a.dly_days,'0') dly_days , a.bill_yn, a.r_fee_est_dt , a.rc_yn , a.rent_st  \n "+
				" from scd_fee a, cont b, client c, car_reg d, client_site e, users f,  \n "+
		//	" /*cls_cont*/	(select rent_mng_id, rent_l_cd from cls_cont where cls_st in ('1','2')) i, \n "+
			" /*scd_fee*/	(select rent_mng_id, rent_l_cd, min(fee_est_dt) fee_est_dt from scd_fee where rc_yn='0' and tm_st2<>'4'  and fee_s_amt>0 group by rent_mng_id, rent_l_cd) j, \n "+			
			    " (select a.client_id, min(b.r_fee_est_dt) r_fee_est_dt from cont a, scd_fee b, cls_cont c where a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd(+) and nvl(c.cls_st,'0') <> '2' and nvl(b.bill_yn,'Y')='Y' and b.tm_st2<>'4'  and b.rc_yn='0' " + query1+ " group by a.client_id) k,  \n "+
			    " (select b.rent_l_cd , max(to_number(b.dly_days))  max_dly_days from cont a, scd_fee b, cls_cont c where a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd(+) and nvl(c.cls_st,'0') <> '2' and nvl(b.bill_yn,'Y')='Y' and b.tm_st2<>'4'  and b.rc_yn='0' group by b.rent_l_cd) mm \n "+
				" where \n "+
				" nvl(a.bill_yn,'Y')='Y' and a.tm_st2<>'4'  and a.fee_s_amt>0 and a.rent_l_cd=b.rent_l_cd and b.car_st<>'4' and b.use_yn = 'Y' \n "+
				" and b.client_id=c.client_id \n "+
				" and b.car_mng_id=d.car_mng_id \n "+
				" and b.client_id=e.client_id(+) and b.r_site=e.seq(+) \n "+
				" and b.bus_id2=f.user_id(+) \n "+
			//	" and a.rent_mng_id=i.rent_mng_id(+) and a.rent_l_cd=i.rent_l_cd(+) and i.rent_l_cd is null \n "+
				" and a.rent_mng_id=j.rent_mng_id(+) and a.rent_l_cd=j.rent_l_cd(+) \n "+
				" and b.client_id=k.client_id(+)  and a.rent_l_cd in ( mm.rent_l_cd )  ";

/*

		query = " select"+
			    " ar.credit_method, e.client_id, c.firm_nm, c.client_nm, e.r_site, d.car_mng_id, d.car_no, d.car_nm, b.brch_id, f.user_nm as bus_nm2, b.bus_id, b.bus_id2, b.use_yn,"+
				" (a.fee_s_amt+a.fee_v_amt) fee_amt, a.*,"+
				" h.*"+
				" from scd_fee a, cont b, client c, car_reg d, client_site e, users f,  "+
				" (select rent_l_cd, max(reg_dt||reg_dt_time) reg_dt from dly_mm group by rent_l_cd) g,"+
				" (select a.rent_l_cd, b.user_nm as reg_nm, a.speaker, a.content, reg_dt||reg_dt_time as reg_dt, reg_dt as reg_dt2 from dly_mm a, users b where a.reg_id=b.user_id) h,"+
				" (select rent_l_cd from cls_cont where cls_st='2') i,"+
				" (select rent_l_cd, max(credit_method) credit_method from arrear where arr_type='1' group by rent_l_cd ) ar,"+
				" (select rent_l_cd, min(fee_est_dt) fee_est_dt from scd_fee where rc_yn='0' group by rent_l_cd) j,"+
			    " (select a.client_id, min(b.r_fee_est_dt) r_fee_est_dt from cont a, scd_fee b, cls_cont c where a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd(+) and nvl(c.cls_st,'0') <> '2' and nvl(b.bill_yn,'Y')='Y' and b.rc_yn='0' " + query1+ " group by a.client_id) k, "+
			    " (select b.rent_l_cd , max(to_number(b.dly_days))  max_dly_days from cont a, scd_fee b, cls_cont c where a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd(+) and nvl(c.cls_st,'0') <> '2' and nvl(b.bill_yn,'Y')='Y' and b.rc_yn='0' group by b.rent_l_cd) mm "+
				" where"+
				" nvl(a.bill_yn,'Y')='Y' and a.rent_l_cd=b.rent_l_cd"+
				" and b.client_id=c.client_id"+
				" and b.car_mng_id=d.car_mng_id"+
				" and b.client_id=e.client_id(+) and b.r_site=e.seq(+)"+
				" and b.bus_id2=f.user_id(+)"+
				" and a.rent_l_cd=g.rent_l_cd(+)"+
				" and g.rent_l_cd=h.rent_l_cd(+) and g.reg_dt=h.reg_dt(+)"+
				" and a.rent_l_cd=i.rent_l_cd(+) and i.rent_l_cd is null"+
				" and a.rent_l_cd=j.rent_l_cd(+)"+
				" and a.rent_l_cd=ar.rent_l_cd(+)"+
				" and b.client_id=k.client_id(+)";
*/

		String fee_mon	= "substr(a.r_fee_est_dt,1,6)";
		String now_mon	= "to_char(sysdate,'YYYYMM')";
		String rc_mon	= "substr(a.rc_dt,1,6)";
		String fee_dt	= "a.r_fee_est_dt";
		String rc_dt	= "a.rc_dt";
		String now_dt	= "to_char(sysdate,'YYYYMMDD')";
	

		/*상세조회&&세부조회*/
		//당월------------------------------------------------------------------------------------------------------------
		//계획
		if(gubun2.equals("1") && gubun3.equals("1")){		query += " and "+fee_mon+"="+now_mon+" ";
		//수금
		}else if(gubun2.equals("1") && gubun3.equals("2")){	query += " and "+fee_mon+"="+now_mon+" and a.rc_yn='1'";
		//미수금
		}else if(gubun2.equals("1") && gubun3.equals("3")){	query += " and "+fee_mon+"="+now_mon+" and a.rc_yn='0'";
		//선수금
		}else if(gubun2.equals("1") && gubun3.equals("4")){	query += " and "+fee_mon+"="+now_mon+" and "+fee_dt+">"+rc_dt+" ";
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
			if(gubun4.equals("1")){	//관심연체		
				query += " and mm.max_dly_days  between 1 and 30   ";
			} else if(gubun4.equals("2")){	//주의연체		
				query += " and mm.max_dly_days  between 31 and 90   ";
			} else if(gubun4.equals("3")){	//경고연체		
				query += " and mm.max_dly_days  between 91 and 120   ";		
			}else if(gubun4.equals("4")){ //악성연체
				query += " and  mm.max_dly_days > 120 ";
			}else{
			}
		}

		/*검색조건*/
			
		if(s_kd.equals("1"))		query += " and nvl(c.firm_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("2"))	query += " and nvl(c.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(a.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and nvl(d.car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("8"))	query += " and b.BUS_ID2= '"+t_wd+"'\n";
		
		
		query +=" ) aa  group by  brch_id, rent_mng_id, rent_l_cd , firm_nm , car_mng_id, car_no , car_nm, bus_nm2 , use_yn , rent_st ";
						
		query += " order by use_yn desc, to_number(dly_days) desc ,   firm_nm ";//a.rc_dt, 

		
		try {
		//	System.out.println("gubun2=" +gubun2);
		//	System.out.println("getFeeList1 query=" + query);
			
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
			System.out.println("[ArrearDatabase:getFeeList1]\n"+e);
			System.out.println("[ArrearDatabase:getFeeList1]\n"+query);
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
	 *	대여료 채권추심 리스트 - arrear/arrear_sc_in.jsp
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
		String query = "";
		String query1 = "";
		
	
		query = " select credit_method, brch_id, rent_mng_id, rent_l_cd , firm_nm , car_mng_id, car_nm, car_no , bus_nm2 , use_yn , rent_st, min(fee_est_dt) fee_est_dt, sum(fee_amt) fee_amt, max(to_number(dly_days)) dly_days from ( "+
		        " select ar.credit_method, e.client_id, c.firm_nm, c.client_nm, e.r_site, d.car_mng_id, d.car_no, d.car_nm, b.brch_id, f.user_nm as bus_nm2, b.bus_id, b.bus_id2, b.use_yn,"+
				" (a.fee_s_amt+a.fee_v_amt) fee_amt, a.rent_mng_id, a.rent_l_cd , a.fee_est_dt, a.dly_chk, a.dly_days , a.bill_yn, a.r_fee_est_dt , a.rc_yn , a.rent_st " +
				" from scd_fee a, cont b, client c, car_reg d, client_site e, users f,   "+
				" (select rent_l_cd from cls_cont where cls_st='2') i,"+
				" (select rent_l_cd, max(credit_method) credit_method from arrear where arr_type='1' group by rent_l_cd ) ar,"+
				" (select rent_l_cd, min(fee_est_dt) fee_est_dt from scd_fee where rc_yn='0' and tm_st2<>'4'  group by rent_l_cd) j,"+
			    " (select a.client_id, min(b.r_fee_est_dt) r_fee_est_dt from cont a, scd_fee b, cls_cont c where a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd(+) and nvl(c.cls_st,'0') <> '2' and nvl(b.bill_yn,'Y')='Y' and b.tm_st2<>'4'  and b.rc_yn='0' group by a.client_id) k, "+
			    " (select b.rent_l_cd , max(to_number(b.dly_days))  max_dly_days from cont a, scd_fee b, cls_cont c where a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd(+) and nvl(c.cls_st,'0') <> '2' and nvl(b.bill_yn,'Y')='Y' and b.tm_st2<>'4'  and b.rc_yn='0' group by b.rent_l_cd) mm "+
				" where"+
				" nvl(a.bill_yn,'Y')='Y' and a.tm_st2<>'4'  and a.rent_l_cd=b.rent_l_cd"+
				" and b.client_id=c.client_id"+
				" and b.car_mng_id=d.car_mng_id"+
				" and b.client_id=e.client_id(+) and b.r_site=e.seq(+)"+
				" and b.bus_id2=f.user_id(+)"+
				" and a.rent_l_cd=i.rent_l_cd(+) and i.rent_l_cd is null"+
				" and a.rent_l_cd=j.rent_l_cd(+)"+
				" and a.rent_l_cd in (ar.rent_l_cd )"+
				" and b.client_id=k.client_id(+)";

		String fee_mon	= "substr(a.r_fee_est_dt,1,6)";
		String now_mon	= "to_char(sysdate,'YYYYMM')";
		String rc_mon	= "substr(a.rc_dt,1,6)";
		String fee_dt	= "a.r_fee_est_dt";
		String rc_dt	= "a.rc_dt";
		String now_dt	= "to_char(sysdate,'YYYYMMDD')";

		
		//연체------------------------------------------------------------------------------------------------------------
		//미수금
		if(gubun2.equals("3") && gubun3.equals("3")){	query += " and "+fee_dt+"<"+now_dt+" and a.rc_yn='0'";
		//당일+연체------------------------------------------------------------------------------------------------------------
		//미수금
		}else if(gubun2.equals("6") && gubun3.equals("3")){	query += " and "+fee_dt+"<="+now_dt+" and a.rc_yn='0'";
		}

		/*연체조회*/

		if(gubun2.equals("3")){
			if(gubun4.equals("2")){	//일반연체		
				query += " and mm.max_dly_days  between 1 and 120 and a.rent_l_cd in ( mm.rent_l_cd )  ";
			}else if(gubun4.equals("3")){ //악성연체
				query += " and  mm.max_dly_days > 120 and a.rent_l_cd in ( mm.rent_l_cd ) ";
			}else{}
		}

		/*검색조건*/
			
		if(s_kd.equals("1"))		query += " and nvl(c.firm_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("2"))	query += " and nvl(c.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(a.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and nvl(d.car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("8"))	query += " and b.BUS_ID2= '"+t_wd+"'\n";
		
		query +=" ) aa  group by credit_method, brch_id, rent_mng_id, rent_l_cd , firm_nm , car_mng_id, car_no , car_nm, bus_nm2 , use_yn , rent_st ";
						
		query += " order by use_yn desc, to_number(dly_days) desc , firm_nm ";
		

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
			System.out.println("[AddFeeDatabase:getFeeList5]\n"+e);
			System.out.println("[AddFeeDatabase:getFeeList5]\n"+query);
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

		//과태료 리스트 조회(수금현황)
	public Vector getFineList(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc) 
	{
      	getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String standard_dt = "decode(a.rec_plan_dt, '',decode(a.dem_dt, '',a.paid_end_dt, a.dem_dt), a.rec_plan_dt)";
		String query = "";

		query = " select /*+  merge(b) */ \n"+
				"        a.car_mng_id, a.seq_no, a.rent_mng_id, a.rent_l_cd, b.firm_nm, b.client_nm, '' scan_file,\n"+
				"        c.car_no, c.first_car_no, c.car_nm, '' car_name, decode(a.coll_dt, '','미수금','수금') gubun,\n"+
				"        decode(a.fault_st, '1','고객과실', '2','업무상과실') fault_st, a.vio_pla, a.vio_cont, a.dly_days,\n"+
				"        decode(a.fault_st, '1', a.paid_amt, '2', decode(nvl(a.fault_amt,0), 0, a.paid_amt, a.fault_amt)) paid_amt,"+
				"        b.use_yn, b.mng_id, b.rent_st, decode(a.paid_st, '2','고객납입','3','회사대납','1','납부자변경','4','수금납입','미정') paid_st,\n"+
				"        nvl2(a.vio_dt,substr(a.vio_dt,1,4)||'-'||substr(a.vio_dt,5,2)||'-'||substr(a.vio_dt,7,2),'') vio_dt,\n"+
				"        nvl2(a.rec_plan_dt,substr(a.rec_plan_dt,1,4)||'-'||substr(a.rec_plan_dt,5,2)||'-'||substr(a.rec_plan_dt,7,2),'') rec_plan_dt,\n"+
				"        nvl2(a.coll_dt,substr(a.coll_dt,1,4)||'-'||substr(a.coll_dt,5,2)||'-'||substr(a.coll_dt,7,2),'') coll_dt,\n"+
				"        nvl2(a.paid_end_dt,substr(a.paid_end_dt,1,4)||'-'||substr(a.paid_end_dt,5,2)||'-'||substr(a.paid_end_dt,7,2),'') paid_end_dt,\n"+
				"        nvl2(a.proxy_dt,substr(a.proxy_dt,1,4)||'-'||substr(a.proxy_dt,5,2)||'-'||substr(a.proxy_dt,7,2),'') proxy_dt,\n"+
				"        nvl2(a.dem_dt,substr(a.dem_dt,1,4)||'-'||substr(a.dem_dt,5,2)||'-'||substr(a.dem_dt,7,2),'') dem_dt,\n"+
				"        decode(g.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트') res_st,"+
				"        decode(g.cust_st,'1',h.firm_nm, '4',i.user_nm) cust_nm,"+
				"        decode(a.rent_s_cd,'',b.bus_id2,decode(g.rent_st,'2',j.bus_id2,'3',j.bus_id2,'1',g.bus_id,'4',g.cust_id,'5',g.cust_id)) bus_id2"+
				" from   fine a, cont_n_view b, car_reg c, rent_cont g, client h, users i, cont j\n"+
				" where\n"+
				"        a.paid_amt > 0 and nvl(a.no_paid_yn,'N') <> 'Y' and a.paid_st in ('3','4') and nvl(a.bill_yn,'Y')='Y'"+
				"        and a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"        and a.rent_s_cd=g.rent_s_cd(+) and g.cust_id=h.client_id(+) and g.cust_id=i.user_id(+) and g.sub_l_cd=j.rent_l_cd(+) and a.car_mng_id = c.car_mng_id "+
				" ";
				//and a.proxy_dt is not null 

		/*상세조회&&세부조회*/

		//당월-계획
		if(gubun2.equals("1") && gubun3.equals("1")){		query += " and "+standard_dt+" like to_char(sysdate,'YYYYMM')||'%'";
		//당월-수금
		}else if(gubun2.equals("1") && gubun3.equals("2")){	query += " and "+standard_dt+" like to_char(sysdate,'YYYYMM')||'%' and a.coll_dt is not null";
		//당월-미수금
		}else if(gubun2.equals("1") && gubun3.equals("3")){	query += " and "+standard_dt+" like to_char(sysdate,'YYYYMM')||'%' and a.coll_dt is null";
		//당일-계획
		}else if(gubun2.equals("2") && gubun3.equals("1")){	query += " and "+standard_dt+" = to_char(sysdate,'YYYYMMDD')";
		//당일-수금
		}else if(gubun2.equals("2") && gubun3.equals("2")){	query += " and "+standard_dt+" = to_char(sysdate,'YYYYMMDD') and (a.coll_dt is not null or a.coll_dt = to_char(sysdate,'YYYYMMDD'))";
		//당일-미수금
		}else if(gubun2.equals("2") && gubun3.equals("3")){	query += " and "+standard_dt+" = to_char(sysdate,'YYYYMMDD') and a.coll_dt is null";
		//연체-계획
		}else if(gubun2.equals("3") && gubun3.equals("1")){	query += " and "+standard_dt+" < to_char(sysdate,'YYYYMMDD') and (a.coll_dt is null or a.coll_dt = to_char(sysdate,'YYYYMMDD'))";
		//연체-수금
		}else if(gubun2.equals("3") && gubun3.equals("2")){	query += " and "+standard_dt+" < to_char(sysdate,'YYYYMMDD') and a.coll_dt = to_char(sysdate,'YYYYMMDD')";
		//연체-미수금
		}else if(gubun2.equals("3") && gubun3.equals("3")){	query += " and "+standard_dt+" < to_char(sysdate,'YYYYMMDD') and a.coll_dt is null";
		//기간-계획
		}else if(gubun2.equals("4") && gubun3.equals("1")){	query += " and "+standard_dt+" BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		//기간-수금
		}else if(gubun2.equals("4") && gubun3.equals("2")){	query += " and "+standard_dt+" BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.coll_dt is not null";
		//기간-미수금
		}else if(gubun2.equals("4") && gubun3.equals("3")){	query += " and "+standard_dt+" BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.coll_dt is null";
		//당일+연체-계획
		}else if(gubun2.equals("6") && gubun3.equals("1")){	query += " and "+standard_dt+" <= to_char(sysdate,'YYYYMMDD') and (a.coll_dt is null or a.coll_dt = to_char(sysdate,'YYYYMMDD'))";
		//당일+연체-수금
		}else if(gubun2.equals("6") && gubun3.equals("2")){	query += " and "+standard_dt+" <= to_char(sysdate,'YYYYMMDD') and a.coll_dt = to_char(sysdate,'YYYYMMDD')";
		//당일+연체-미수금
		}else if(gubun2.equals("6") && gubun3.equals("3")){	query += " and "+standard_dt+" <= to_char(sysdate,'YYYYMMDD') and a.coll_dt is null";
		//검색-수금
		}else if(gubun2.equals("5") && gubun3.equals("2")){	query += " and a.coll_dt is not null";
		//검색-미수금
		}else if(gubun2.equals("5") && gubun3.equals("3")){	query += " and a.coll_dt is null";
		}


		if(gubun5.equals("3"))			query += " and a.fault_st='1'";//고객과실
		else if(gubun5.equals("5"))		query += " and a.fault_st='2'";//업무상과실

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
			
		if(s_kd.equals("1"))		query += " and nvl(b.firm_nm||h.firm_nm||i.user_nm||decode(g.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트'), '') like '%"+t_wd+"%'\n";			
		else if(s_kd.equals("2"))	query += " and nvl(b.client_nm||h.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(b.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and nvl(c.car_no, '')||nvl(c.first_car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("5"))	query += " and a.paid_amt like '%"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	query += " and upper(b.brch_id) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("7"))	query += " and nvl(b.r_site, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("8"))	query += " and nvl(b.mng_id,b.bus_id2)= '"+t_wd+"'\n";
		else if(s_kd.equals("14"))	query += " and decode(a.rent_s_cd,'',b.bus_id2,decode(g.rent_st,'2',j.bus_id2,'3',j.bus_id2,'1',g.bus_id,'4',g.cust_id,'5',g.cust_id))= '"+t_wd+"'\n";

		else if(s_kd.equals("9"))	query += " and c.car_nm like '%"+t_wd+"%'\n";
		else if(s_kd.equals("10"))	query += " and nvl(a.vio_dt, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("11"))	query += " and nvl(a.vio_pla, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("12"))	query += " and upper(a.paid_no) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("13"))	query += " and a.pol_sta like '%"+t_wd+"%'\n";
		else if(s_kd.equals("15"))	query += " and nvl(a.vio_cont, '') like '%"+t_wd+"%'\n";

		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		/*정렬조건*/

		if(sort_gubun.equals("0"))		query += " order by b.use_yn desc, a.rec_plan_dt "+sort+", a.coll_dt, b.firm_nm";
		else if(sort_gubun.equals("1"))	query += " order by b.use_yn desc, b.firm_nm "+sort+", a.coll_dt, a.rec_plan_dt";
		else if(sort_gubun.equals("2"))	query += " order by b.use_yn desc, a.pay_dt "+sort+", b.firm_nm, a.rec_plan_dt";
		else if(sort_gubun.equals("3"))	query += " order by b.use_yn desc, a.paid_amt "+sort+", a.coll_dt, b.firm_nm, a.rec_plan_dt";
		else if(sort_gubun.equals("4"))	query += " order by b.use_yn desc, c.car_no "+sort+", b.firm_nm, a.rec_plan_dt";
	
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
			System.out.println("[ArrearDatabase:getFineList]\n"+e);
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

	// 조회 -------------------------------------------------------------------------------------------------

	// 면책금 리스트 조회
	public Vector getInsurMList(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query =		" select /*+  merge(b) */ "+
					"        a.car_mng_id, a.serv_id, a.accid_id, a.rent_mng_id, a.rent_l_cd, b.firm_nm, b.client_nm,"+
					"        cc.car_no, cc.car_nm, '' car_name, decode(a.cust_pay_dt, '','미수금','수금') gubun,"+
					"        decode(a.serv_st, '1','순회점검', '2','일반수리', '3','보증수리', '4','사고수리') serv_st, a.off_id, c.off_nm,"+
					"        a.rep_amt, a.sup_amt, a.add_amt, a.tot_amt, a.cust_amt, a.serv_dt, a.dly_days, b.use_yn, b.mng_id, b.rent_st,"+//b.bus_id2, 
					"        nvl2(a.cust_req_dt,substr(a.cust_req_dt,1,4)||'-'||substr(a.cust_req_dt,5,2)||'-'||substr(a.cust_req_dt,7,2),'') cust_req_dt,"+
					"        nvl2(se.ext_ext_dt,substr(se.ext_ext_dt,1,4)||'-'||substr(se.ext_ext_dt,5,2)||'-'||substr(se.ext_ext_dt,7,2),'') cust_plan_dt,"+
					"        nvl2(se.ext_pay_dt,substr(se.ext_pay_dt,1,4)||'-'||substr(se.ext_pay_dt,5,2)||'-'||substr(se.ext_pay_dt,7,2),'') cust_pay_dt,"+
					"        decode(g.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트') res_st,"+
					"        decode(g.cust_st,'1',h.firm_nm, '4',i.user_nm) cust_nm,"+
					"        decode(f.rent_s_cd,'',b.bus_id2,decode(g.rent_st,'2',j.bus_id2,'3',j.bus_id2,'1',g.bus_id,'4',g.cust_id,'5',g.cust_id)) bus_id2"+
					" from   scd_ext se, service a, cont_n_view b, car_reg cc,  serv_off c, accident f, rent_cont g, client h, users i, cont j "+
					" where"+
					"        se.ext_st = '3' "+
					"        and (se.ext_s_amt + se.ext_v_amt )> 0 and nvl(a.no_dft_yn,'N') <> 'Y' and nvl(se.bill_yn,'Y')='Y'"+
					"		 and se.rent_mng_id = a.rent_mng_id and se.rent_l_cd = a.rent_l_cd and se.ext_id = a.serv_id "+
					"	     and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.car_mng_id=b.car_mng_id and b.car_mng_id = cc.car_mng_id "+
					"        and a.off_id=c.off_id"+
					"        and a.car_mng_id=f.car_mng_id(+) and a.accid_id=f.accid_id(+) "+
					"	     and f.rent_s_cd=g.rent_s_cd(+) and g.cust_id=h.client_id(+) and g.cust_id=i.user_id(+) and g.sub_l_cd=j.rent_l_cd(+)"+
					" ";

		/*상세조회&&세부조회*/

		//당월-계획
		if(gubun2.equals("1") && gubun3.equals("1")){		query += " and nvl(se.ext_est_dt,a.cust_req_dt) like to_char(sysdate,'YYYYMM')||'%'";
		//당월-수금
		}else if(gubun2.equals("1") && gubun3.equals("2")){	query += " and nvl(se.ext_est_dt,a.cust_req_dt) like to_char(sysdate,'YYYYMM')||'%' and se.ext_pay_dt is not null";
		//당월-미수금
		}else if(gubun2.equals("1") && gubun3.equals("3")){	query += " and nvl(se.ext_est_dt,a.cust_req_dt) like to_char(sysdate,'YYYYMM')||'%' and se.ext_pay_dt is null";
		//당일-계획
		}else if(gubun2.equals("2") && gubun3.equals("1")){	query += " and nvl(se.ext_est_dt,a.cust_req_dt) = to_char(sysdate,'YYYYMMDD')";
		//당일-수금
		}else if(gubun2.equals("2") && gubun3.equals("2")){	query += " and nvl(se.ext_est_dt,a.cust_req_dt) = to_char(sysdate,'YYYYMMDD') and se.ext_pay_dt = to_char(sysdate,'YYYYMMDD')";
		//당일-미수금
		}else if(gubun2.equals("2") && gubun3.equals("3")){	query += " and nvl(se.ext_est_dt,a.cust_req_dt) = to_char(sysdate,'YYYYMMDD') and se.ext_pay_dt is null";
		//연체-계획
		}else if(gubun2.equals("3") && gubun3.equals("1")){	query += " and nvl(se.ext_est_dt,a.cust_req_dt) < to_char(sysdate,'YYYYMMDD') and (se.ext_pay_dt is null or se.ext_pay_dt = to_char(sysdate,'YYYYMMDD'))";
		//연체-수금
		}else if(gubun2.equals("3") && gubun3.equals("2")){	query += " and nvl(se.ext_est_dt,a.cust_req_dt) < to_char(sysdate,'YYYYMMDD') and se.ext_pay_dt = to_char(sysdate,'YYYYMMDD')";
		//연체-미수금
		}else if(gubun2.equals("3") && gubun3.equals("3")){	query += " and nvl(se.ext_est_dt,a.cust_req_dt) < to_char(sysdate,'YYYYMMDD') and se.extt_pay_dt is null";
		//기간-계획
		}else if(gubun2.equals("4") && gubun3.equals("1")){	query += " and nvl(se.ext_est_dt,a.cust_req_dt) BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		//기간-수금
		}else if(gubun2.equals("4") && gubun3.equals("2")){	query += " and nvl(se.ext_est_dt,a.cust_req_dt) BETWEEN '"+st_dt+"' AND '"+end_dt+"' and se.ext_pay_dt is not null";
		//기간-미수금
		}else if(gubun2.equals("4") && gubun3.equals("3")){	query += " and nvl(se.ext_est_dt,a.cust_req_dt) BETWEEN '"+st_dt+"' AND '"+end_dt+"' and se.ext_pay_dt is null";
		//당일+연체-계획
		}else if(gubun2.equals("6") && gubun3.equals("1")){	query += " and nvl(se.ext_est_dt,a.cust_req_dt) <= to_char(sysdate,'YYYYMMDD') and (se.ext_pay_dt is null or se.ext_pay_dt = to_char(sysdate,'YYYYMMDD'))";
		//당일+연체-수금
		}else if(gubun2.equals("6") && gubun3.equals("2")){	query += " and nvl(se.ext_est_dt,a.cust_req_dt) <= to_char(sysdate,'YYYYMMDD') and se.ext_pay_dt = to_char(sysdate,'YYYYMMDD')";
		//당일+연체-미수금
		}else if(gubun2.equals("6") && gubun3.equals("3")){	query += " and nvl(se.ext_est_dt,a.cust_req_dt) <= to_char(sysdate,'YYYYMMDD') and se.ext_pay_dt is null";
		//검색
		}

		/*연체조회*/

		if(gubun2.equals("3")){
			if(gubun4.equals("2")){	//일반연체		
				query += " and se.dly_days between 1 and 30";
			}else if(gubun4.equals("3")){ //부실연체
				query += " and se.dly_days between 31 and 60";
			}else if(gubun4.equals("4")){ //악성연체
				query += " and se.dly_days between 61 and 1000";
			}else{}
		}

		/*검색조건*/

		if(s_kd.equals("2"))		query += " and nvl(b.client_nm||h.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(b.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and nvl(cc.car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("5"))	query += " and (se.ext_s_amt + se.ext_v_amt ) like '%"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	query += " and upper(b.brch_id) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("7"))	query += " and nvl(b.r_site, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("8"))	query += " and b.mng_id= '"+t_wd+"'\n";
		else if(s_kd.equals("12"))	query += " and decode(f.rent_s_cd,'',b.bus_id2,decode(g.rent_st,'2',j.bus_id2,'3',j.bus_id2,'1',g.bus_id,'4',g.cust_id,'5',g.cust_id))= '"+t_wd+"'\n";
		else if(s_kd.equals("9"))	query += " and cc.car_nm like '%"+t_wd+"%'\n";
		else if(s_kd.equals("10"))	query += " and nvl(a.serv_dt, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("11"))	query += " and nvl(c.off_nm, '') like '%"+t_wd+"%'\n";
		else						query += " and nvl(b.firm_nm||h.firm_nm||i.user_nm||decode(g.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트'), '') like '%"+t_wd+"%'\n";			

		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		/*정렬조건*/

		if(sort_gubun.equals("0"))		query += " order by decode(b.bus_id2,'000004','1','0'), b.use_yn desc, se.ext_est_dt "+sort+", se.ext_pay_dt, b.firm_nm";
		else if(sort_gubun.equals("1"))	query += " order by decode(b.bus_id2,'000004','1','0'), b.use_yn desc, b.firm_nm "+sort+", se.ext_pay_dt, se.ext_est_dt";
		else if(sort_gubun.equals("2"))	query += " order by decode(b.bus_id2,'000004','1','0'), b.use_yn desc, se.ext_pay_dt "+sort+", b.firm_nm, se.ext_est_dt";
		else if(sort_gubun.equals("3"))	query += " order by decode(b.bus_id2,'000004','1','0'), b.use_yn desc, (se.ext_s_amt + se.ext_v_amt) "+sort+", se.ext_pay_dt, b.firm_nm, se.ext_est_dt";
		else if(sort_gubun.equals("4"))	query += " order by decode(b.bus_id2,'000004','1','0'), cc.car_no "+sort+", b.firm_nm, se.ext_est_dt";
	
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

	
	// 조회 -------------------------------------------------------------------------------------------------

	// 휴차료/대차료 리스트 조회
	public Vector getInsurHList(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select /*+  merge(c) */ \n"+
				"        a.car_mng_id, a.accid_id, a.rent_mng_id, a.rent_l_cd, c.firm_nm, c.client_nm,\n"+
				"        cc.car_no, cc.car_nm, '' car_name, decode(b.pay_dt, '','미수금','수금') gubun,\n"+
				"        decode(a.accid_st, '1','피해자', '2','가해자', '3','쌍방', '4','자차사고') accid_st, nvl(a.ot_ins,'') ot_ins,\n"+
				"        decode(b.req_gu, '1','휴차료', '2','대차료') req_gu, b.req_amt, b.pay_amt, b.dly_days, c.use_yn, c.mng_id, c.rent_st,\n"+
				"        nvl2(a.accid_dt,substr(a.accid_dt,1,4)||'-'||substr(a.accid_dt,5,2)||'-'||substr(a.accid_dt,7,2),'') accid_dt,\n"+
				"        nvl2(b.req_dt,substr(b.req_dt,1,4)||'-'||substr(b.req_dt,5,2)||'-'||substr(b.req_dt,7,2),'') req_dt,\n"+
				"        nvl2(b.pay_dt,substr(b.pay_dt,1,4)||'-'||substr(b.pay_dt,5,2)||'-'||substr(b.pay_dt,7,2),'') pay_dt\n"+
				" from   accident a, my_accid b, cont_n_view c, car_reg cc \n"+
				" where\n"+
				"        b.req_amt > 0 "+
				"        and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id\n"+
				"        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and a.car_mng_id = cc.car_mng_id \n"+
				" ";

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
		else if(s_kd.equals("4"))	query += " and nvl(cc.car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("5"))	query += " and b.req_amt like '%"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	query += " and upper(c.brch_id) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("7"))	query += " and nvl(c.r_site, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("8"))	query += " and c.mng_id= '"+t_wd+"'\n";
		else if(s_kd.equals("12"))	query += " and c.bus_id2= '"+t_wd+"'\n";
		else if(s_kd.equals("9"))	query += " and cc.car_nm like '%"+t_wd+"%'\n";
		else if(s_kd.equals("10"))	query += " and nvl(a.accid_dt, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("11"))	query += " and nvl(a.ot_ins, '') like '%"+t_wd+"%'\n";


		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		/*정렬조건*/

		if(sort_gubun.equals("0"))		query += " order by c.use_yn desc, b.req_dt "+sort+", b.pay_dt, c.firm_nm";
		else if(sort_gubun.equals("1"))	query += " order by c.use_yn desc, c.firm_nm "+sort+", b.pay_dt, b.req_dt";
		else if(sort_gubun.equals("2"))	query += " order by c.use_yn desc, b.pay_dt "+sort+", c.firm_nm, b.req_dt";
		else if(sort_gubun.equals("3"))	query += " order by c.use_yn desc, b.req_amt "+sort+", b.pay_dt, c.firm_nm, b.req_dt";
		else if(sort_gubun.equals("5"))	query += " order by cc.car_no "+sort+", c.firm_nm, b.req_dt";
	
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
	

		
	// 해지위약금 리스트 조회 + 해지대여료 포함(gubun5 추가)
	public Vector getClsFeeScdSum(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		//정산금
		String query1 = "";

		query1 =	" select /*+  merge(b) */ \n"+
					"        f.enter_dt, f.br_id, f.user_nm as bus_nm2 , nvl(ar.credit_method,'') as credit_method,  a.rent_mng_id, a.rent_l_cd,  \n"+
					"        a.cls_s_amt as s_amt, (nvl(a.ext_s_amt,0)+nvl(a.ext_v_amt,0)) as amt,"+
					"        a.dly_amt, to_number(a.dly_days) as dly_days, b.bus_id2, b.rent_st, b.use_yn, \n"+
					"        nvl2(d.cls_dt,substr(d.cls_dt,1,4)||'-'||substr(d.cls_dt,5,2)||'-'||substr(d.cls_dt,7,2),'') cls_dt,\n"+
					"        nvl2(a.ext_est_dt,substr(a.ext_est_dt,1,4)||'-'||substr(a.ext_est_dt,5,2)||'-'||substr(a.ext_est_dt,7,2),'') est_dt,\n"+
					"        nvl2(a.ext_pay_dt,substr(a.ext_pay_dt,1,4)||'-'||substr(a.ext_pay_dt,5,2)||'-'||substr(a.ext_pay_dt,7,2),'') pay_dt\n"+
					" from   scd_ext a, cont_n_view b, cls_cont d, arrear ar, users f \n"+
					" where\n"+
					"        a.ext_st = '4' "+
					"        and a.ext_s_amt is not null and d.cls_doc_yn='Y' and nvl(a.bill_yn,'Y')='Y'"+
					"        and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_l_cd = ar.rent_l_cd(+) and a.rent_mng_id = ar.rent_mng_id(+) "+
					"        and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd and b.bus_id2 = f.user_id and f.br_id = '" + br_id + "'"+
					" ";

		//해지대여료
		String query2 = "";
		query2 =	" select /*+  merge(c) */ "+
					"        f.enter_dt, f.br_id, f.user_nm  as bus_nm2, nvl(ar.credit_method,'') as credit_method, a.rent_mng_id, a.rent_l_cd, "+
					"        a.fee_s_amt as s_amt, a.fee_amt as amt,"+
					"        0 dly_amt, a.dly_day as dly_days, a.bus_id2, a.rent_st,  c.use_yn,"+
					"        nvl2(b.cls_dt,substr(b.cls_dt,1,4)||'-'||substr(b.cls_dt,5,2)||'-'||substr(b.cls_dt,7,2),'') cls_dt,\n"+
					"        a.fee_est_dt as est_dt, a.rc_dt as pay_dt"+
					" from   fee_view a, cls_cont b, cont_n_view c, arrear ar , users f "+
					" where  a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd and a.use_yn='N' and nvl(a.bill_yn,'Y')='Y'"+
					"        and c.bus_id2 = f.user_id and f.br_id = '" + br_id + "'"+
					"        and b.cls_st ='2' and a.rent_l_cd = ar.rent_l_cd(+) ";

		//합체
		String query = " select enter_dt, br_id, bus_id2, bus_nm2, 0 as tot_d_cnt, 0 as tot_d_amt, count(rent_l_cd) as tot_h_cnt, sum (amt) tot_h_amt from ( \n"+query1+"\n union all \n"+query2+"\n ) where rent_l_cd is not null ";		


		/*상세조회&&세부조회*/

	
		//연체-계획
		if(gubun2.equals("3") && gubun3.equals("1")){	query += " and est_dt < to_char(SYSDATE, 'YYYY-MM-DD') and (pay_dt is null or pay_dt = to_char(SYSDATE, 'YYYY-MM-DD'))";
		//연체-수금
		}else if(gubun2.equals("3") && gubun3.equals("2")){	query += " and est_dt < to_char(SYSDATE, 'YYYY-MM-DD') and pay_dt = to_char(SYSDATE, 'YYYY-MM-DD')";
		//연체-미수금
		}else if(gubun2.equals("3") && gubun3.equals("3")){	query += " and est_dt < to_char(SYSDATE, 'YYYY-MM-DD') and pay_dt is null";
			
		}
		

		/*연체조회*/
		if(gubun2.equals("3")){
				if(gubun4.equals("1")){	//일반연체	
					query += " and dly_days between 1 and 120 ";
			}else if(gubun4.equals("2")){ //악성연체
					query += " and dly_days > 120 ";
			}	
		}

	
		String sort = asc.equals("0")?" asc":" desc";

		query += "  group by enter_dt, br_id, bus_id2, bus_nm2 ";
		
		
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
			System.out.println("[ArrearDatabase:getClsFeeScdSum]\n"+e);
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
	
	
	// 해지위약금 리스트 조회 + 해지대여료 포함(gubun5 추가)
	public Vector getClsFeeScdList(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		//정산금
		String query1 = "";

		query1 =	" select /*+  merge(b) */ \n"+
					"        nvl(ar.credit_method,'') as credit_method, '정산금' cls_gubun, a.rent_mng_id, a.rent_l_cd, b.car_mng_id, b.firm_nm, b.client_nm, b.client_id,\n"+
					"        cc.car_no, cc.car_nm, '' car_name, decode(a.ext_pay_dt, '','미수금','수금') gubun, a.ext_s_amt as s_amt, (nvl(a.ext_s_amt,0)+nvl(a.ext_v_amt,0)) as amt,"+
					"        a.ext_tm as tm, decode(a.ext_tm,'1','','(잔)') tm_st, a.dly_amt, to_number(trim(nvl(a.dly_days,'0')))  as dly_days, b.bus_id2, b.rent_st, b.r_site, b.mng_id, b.use_yn, \n"+
					"        nvl2(d.cls_dt,substr(d.cls_dt,1,4)||'-'||substr(d.cls_dt,5,2)||'-'||substr(d.cls_dt,7,2),'') cls_dt,\n"+
					"        nvl2(a.ext_est_dt,substr(a.ext_est_dt,1,4)||'-'||substr(a.ext_est_dt,5,2)||'-'||substr(a.ext_est_dt,7,2),'') est_dt,\n"+
					"        nvl2(a.ext_pay_dt,substr(a.ext_pay_dt,1,4)||'-'||substr(a.ext_pay_dt,5,2)||'-'||substr(a.ext_pay_dt,7,2),'') pay_dt\n"+
					" from   scd_ext a, cont_n_view b, cls_cont d, arrear ar, car_reg cc  \n"+
					" where\n"+
					"        a.ext_st = '4' "+
					"        and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_l_cd = ar.rent_l_cd(+) and a.rent_mng_id = ar.rent_mng_id(+) "+
					"        and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd and b.car_mng_id = cc.car_mng_id "+
					"        and (nvl(a.ext_s_amt,0)+nvl(a.ext_v_amt,0)) > 0 and d.cls_doc_yn='Y' and nvl(a.bill_yn,'Y')='Y'";
		//해지대여료
		String query2 = "";
		query2 =	" select /*+  merge(c) */ "+
					"        nvl(ar.credit_method,'') as credit_method,'대여료' cls_gubun, a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.firm_nm, a.client_nm, '' client_id,"+
					"        cc.car_no, cc.car_nm, ''  car_name, decode(a.rc_yn, '1', '수금','미수금') gubun, a.fee_s_amt as s_amt, a.fee_amt as amt,"+
					"        a.fee_tm as tm, decode(a.tm_st1,'0','','(잔)') tm_st, 0 dly_amt, a.dly_day as dly_days, a.bus_id2, a.rent_st, c.r_site, c.mng_id, c.use_yn,"+
					"        nvl2(b.cls_dt,substr(b.cls_dt,1,4)||'-'||substr(b.cls_dt,5,2)||'-'||substr(b.cls_dt,7,2),'') cls_dt,\n"+
					"        a.fee_est_dt as est_dt, a.rc_dt as pay_dt"+
					" from   fee_view a, cls_cont b, cont_n_view c, arrear ar,  car_reg cc  \n"+
					" where  a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd and a.rent_l_cd = ar.rent_l_cd(+) and a.rent_mng_id = ar.rent_mng_id(+) "+
					"        and a.use_yn='N' and nvl(a.bill_yn,'Y')='Y' and c.car_mng_id = cc.car_mng_id \n"+
					"        and b.cls_st ='2' and a.rent_l_cd = ar.rent_l_cd(+) ";

		//합체
		String query = " select * from ( \n"+query1+"\n union all \n"+query2+"\n ) where rent_l_cd is not null ";		


		/*상세조회&&세부조회*/

	
		//연체-계획
		if(gubun2.equals("3") && gubun3.equals("1")){		query += " and est_dt < to_char(SYSDATE, 'YYYY-MM-DD') and (pay_dt is null or pay_dt = to_char(SYSDATE, 'YYYY-MM-DD'))";
		//연체-수금
		}else if(gubun2.equals("3") && gubun3.equals("2")){	query += " and est_dt < to_char(SYSDATE, 'YYYY-MM-DD') and pay_dt = to_char(SYSDATE, 'YYYY-MM-DD')";
		//연체-미수금
		}else if(gubun2.equals("3") && gubun3.equals("3")){	query += " and est_dt < to_char(SYSDATE, 'YYYY-MM-DD') and pay_dt is null";
			
		}
		

		/*연체조회*/
		if(gubun2.equals("3")){
			if(gubun4.equals("1")){	//관심연체	
					query += " and dly_days between 1 and 30 ";
			}else if(gubun4.equals("2")){	//주의연체	
					query += " and dly_days between 31 and 90 ";
			}else if(gubun4.equals("3")){	//경고연체	
					query += " and dly_days between 91 and 120 ";
			}else if(gubun4.equals("4")){ //악성연체
					query += " and dly_days > 120 ";
			}	
		}
					

		/*검색조건*/
			
		if(s_kd.equals("2"))		query += " and nvl(client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and nvl(car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	query += " and substr(rent_l_cd,1,2) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("8"))	query += " and bus_id2= '"+t_wd+"'\n";
		else if(s_kd.equals("10"))	query += " and nvl(cls_dt, '') like '%"+t_wd+"%'\n";
		else						query += " and nvl(firm_nm, '') like '%"+t_wd+"%'\n";			

		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		/*정렬조건*/

		if(sort_gubun.equals("0"))		query += " order by est_dt "+sort+", pay_dt, firm_nm";
		else if(sort_gubun.equals("1"))	query += " order by firm_nm "+sort+", pay_dt, est_dt";
		else if(sort_gubun.equals("3"))	query += " order by amt "+sort+", pay_dt, firm_nm, est_dt";

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
			System.out.println("[ArrearDatabase:getClsFeeScdList]\n"+e);
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
	 *	//acms 테이블에서 입금미반영, 출금금액이 있는 출금의뢰일 조회하기
	 */
	public Vector getACmsDateList(String adate)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" c.rent_mng_id, c.rent_l_cd, d.firm_nm, e.car_no, a.acode, a.aamt, a.aoutamt, nvl(b.rc_amt,0) rc_amt, a.aoutamt-nvl(b.rc_amt,0) def_amt"+
				" from acms a, (select rent_l_cd, sum(rc_amt) rc_amt from scd_fee where adate='"+adate+"' and rc_amt>0 and tm_st2<>'4'  group by rent_l_cd) b,"+
				" cont c, client d, car_reg e"+
				" where a.acode=b.rent_l_cd(+)"+
				" and a.acode=c.rent_l_cd and c.client_id=d.client_id and c.car_mng_id=e.car_mng_id"+
				" and a.adate='"+adate+"'"+
				" and a.aoutamt>0 order by decode(a.aoutamt-nvl(b.rc_amt,0),0,1), d.firm_nm";

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
	 *	채권추심방식 insert
	 */
	
	public boolean insertArrear(ArrearBean arrear)
	{
		getConnection();
		boolean flag = true;
		Statement stmt = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String s_seq = "";
		String query_id = " select nvl(ltrim(to_char(to_number(MAX(seq))+1, '000000')), '000001') ID from arrear";

		String query =  " insert into arrear ("+
						" RENT_MNG_ID, RENT_L_CD, SEQ, USER_ID, REG_DT, CREDIT_METHOD, CREDIT_DESC, ARR_TYPE)"+
						" values ( ?, ?, ?, ?, replace(?, '-', ''), ?, ?, ?)";
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
			pstmt.setString(1, arrear.getRent_mng_id());
			pstmt.setString(2, arrear.getRent_l_cd());
			pstmt.setString(3, s_seq);
			pstmt.setString(4, arrear.getUser_id());
			pstmt.setString(5, arrear.getReg_dt());
			pstmt.setString(6, arrear.getCredit_method());
			pstmt.setString(7, arrear.getCredit_desc().trim());
			pstmt.setString(8, arrear.getArr_type());
										
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[ArrearDatabase:insertArrear]\n"+e);
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
	 *	추심메모
	 */
	public Vector getArrearMemo(String m_id, String l_cd, String arr_type)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String where = "";

	
		query = " select * from "+
				"	( select"+
						" RENT_MNG_ID, RENT_L_CD, SEQ,  USER_ID, CREDIT_METHOD, CREDIT_DESC, ARR_TYPE,"+
						" substr(REG_DT, 1, 4) || '-' || substr(REG_DT, 5, 2) || '-'||substr(REG_DT, 7, 2) REG_DT"+
						" from arrear "+
						" where RENT_MNG_ID = '"+m_id+"'"+
						" and RENT_L_CD = '"+l_cd+"'"+
						" and ARR_TYPE = '"+arr_type+"'"+
				"	) order by REG_DT desc, SEQ desc ";		

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
	    	
			while(rs.next())
			{
				ArrearBean mm = new ArrearBean();
				mm.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				mm.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				mm.setSeq(rs.getString("SEQ")==null?"":rs.getString("SEQ"));
				mm.setUser_id(rs.getString("USER_ID")==null?"":rs.getString("USER_ID"));
				mm.setReg_dt(rs.getString("REG_DT")==null?"":rs.getString("REG_DT"));
				mm.setCredit_method(rs.getString("CREDIT_METHOD")==null?"":rs.getString("CREDIT_METHOD"));
				mm.setCredit_desc(rs.getString("CREDIT_DESC")==null?"":rs.getString("CREDIT_DESC"));
				mm.setArr_type(rs.getString("ARR_TYPE")==null?"":rs.getString("ARR_TYPE"));
			
				vt.add(mm);
			}
            rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ArrearDatabase:getArrearMemo]\n"+e);
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
	
		//미수금정산 변경 : 보유차 운행중 과태료/면책금/단기요금 포함 -------------------------------------------------------

	String est_amt1 = "(a.ext_s_amt+a.ext_v_amt)";
	String est_amt2 = "(a.fee_s_amt+a.fee_v_amt)";
	String est_amt3 = "(a.paid_amt)";
	String est_amt4 = "(se.ext_s_amt+se.ext_v_amt)";
	String est_amt5 = "(a.req_amt)";
	String est_amt6 = "(a.ext_s_amt+a.ext_v_amt)";
	String est_amt7 = "(a.rent_s_amt+a.rent_v_amt)";

	String est_dt1 = "b.rent_start_dt";
	String est_dt2 = "a.r_fee_est_dt";
	String est_dt3 = "nvl(a.rec_plan_dt,nvl(a.dem_dt,a.paid_end_dt))";
	String est_dt4 = "se.ext_est_dt";
	String est_dt5 = "a.req_dt";
	String est_dt6 = "nvl(a.ext_est_dt,b.cls_dt)";
	String est_dt7 = "a.est_dt";

	String condition1	= "and a.ext_s_amt>0 and a.ext_pay_dt is null";
	String condition2	= "and a.fee_s_amt>0 and a.rc_dt is null and nvl(a.bill_yn,'Y')='Y' and a.tm_st2<>'4'";
	String condition3	= "and a.paid_amt>0 and a.vio_cont not like '%통행료%' and a.coll_dt is null and nvl(a.bill_yn,'Y')='Y' and a.paid_st in ('3','4') and nvl(a.no_paid_yn,'N')='N'";
	String condition3_1	= "and a.paid_amt>0 and a.vio_cont not like '%통행료%' and a.coll_dt is null and nvl(a.bill_yn,'Y')='Y' and a.rent_s_cd is null and a.paid_st in ('3','4') and nvl(a.no_paid_yn,'N')='N'";
	String condition3_2 = "and a.paid_amt>0 and a.vio_cont not like '%통행료%' and a.coll_dt is null and nvl(a.bill_yn,'Y')='Y' and a.rent_s_cd is not null and a.paid_st in ('3','4') and nvl(a.no_paid_yn,'N')='N'";
	String condition4	= "and se.ext_s_amt>0 and se.ext_pay_dt is null and nvl(a.bill_yn,'Y')='Y' and nvl(a.no_dft_yn,'N')='N'";
	String condition4_1	= "and se.ext_s_amt>0 and se.ext_pay_dt is null and nvl(a.bill_yn,'Y')='Y' and b.rent_s_cd is null and nvl(a.no_dft_yn,'N')='N'";
	String condition4_2 = "and se.ext_s_amt>0 and se.ext_pay_dt is null and nvl(a.bill_yn,'Y')='Y' and b.rent_s_cd is not null and nvl(a.no_dft_yn,'N')='N'";
	String condition5	= "and a.req_amt>0 and a.pay_dt is null";
	String condition6	= "and a.ext_s_amt>0 and a.ext_pay_dt is null and nvl(a.bill_yn,'Y')='Y' and nvl(cls_doc_yn,'Y')='Y'";
	String condition7	= "and a.rent_s_amt>0 and a.pay_dt is null and nvl(a.bill_yn,'Y')='Y'";


	String bad_debt1	= "and a.ext_s_amt>0 and a.ext_pay_dt is null and nvl(a.bill_yn,'Y')='N' and a.tm_st2<>'4'";
	String bad_debt2	= "and a.fee_s_amt>0 and a.rc_dt is null and nvl(a.bill_yn,'Y')='N'";
	String bad_debt3	= "and a.paid_amt>0 and a.vio_cont not like '%통행료%' and a.coll_dt is null and nvl(a.bill_yn,'Y')='N' and a.paid_st in ('3','4') and nvl(a.no_paid_yn,'N')='N'";
	String bad_debt3_1	= "and a.paid_amt>0 and a.vio_cont not like '%통행료%' and a.coll_dt is null and nvl(a.bill_yn,'Y')='N' and a.rent_s_cd is null and a.paid_st in ('3','4') and nvl(a.no_paid_yn,'N')='N'";
	String bad_debt3_2  = "and a.paid_amt>0 and a.vio_cont not like '%통행료%' and a.coll_dt is null and nvl(a.bill_yn,'Y')='N' and a.rent_s_cd is not null and a.paid_st in ('3','4') and nvl(a.no_paid_yn,'N')='N'";
	String bad_debt4	= "and se.ext_s_amt>0 and se.ext_pay_dt is null and nvl(a.bill_yn,'Y')='N' and nvl(a.no_dft_yn,'N')='N'";
	String bad_debt4_1	= "and se.ext_s_amt>0 and se.ext_pay_dt is null and nvl(a.bill_yn,'Y')='N' and b.rent_s_cd is null and nvl(a.no_dft_yn,'N')='N'";
	String bad_debt4_2  = "and se.ext_s_amt>0 and se.ext_pay_dt is null and nvl(a.bill_yn,'Y')='N' and b.rent_s_cd is not null and nvl(a.no_dft_yn,'N')='N'";
	String bad_debt5	= "and a.req_amt>0 and a.pay_dt is null and nvl(a.bill_yn,'Y')='N'";
	String bad_debt6	= "and a.ext_s_amt>0 and a.ext_pay_dt is null and nvl(a.bill_yn,'Y')='N' and nvl(cls_doc_yn,'Y')='Y'";
	String bad_debt7	= "and a.rent_s_amt>0 and a.pay_dt is null and nvl(a.bill_yn,'Y')='N'";

	
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
				 " decode(d.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트') gubun3,"+
				 " decode(d.sub_l_cd,'',b.rent_l_cd,d.sub_l_cd) rent_l_cd, b.rent_mng_id,"+
				 " nvl(c.car_mng_id,i.car_mng_id) car_mng_id,"+
				 " decode(a.rent_s_cd,'',e.client_id,decode(d.cust_st,'1',f.client_id,h.user_id)) client_id,"+
				 " decode(a.rent_s_cd,'',b.bus_id2,decode(d.rent_st,'1',d.bus_id,'9',d.bus_id,'2',g.bus_id2,'3',g.bus_id2,'10',g.bus_id2,'4',d.cust_id,'5',d.cust_id)) bus_id2,"+
				 " decode(a.rent_s_cd,'',e.firm_nm,decode(d.cust_st,'1',f.firm_nm,h.user_nm)) firm_nm,"+
				 " nvl(c.car_no,i.car_no) car_no, nvl(c.car_nm,i.car_nm) car_nm,"+
				 " d.rent_s_cd,"+
				 " a.est_amt,"+
				 " decode(a.rent_s_cd,'',b.use_yn,nvl(g.use_yn,'Y')) use_yn , nvl(ar.credit_method, '') as credit_method "+
				 " from"+
				 " ( "+
				 "      select '선수금' gubun2, '' rent_s_cd, a.rent_l_cd, "+est_amt1+" est_amt from scd_ext a, fee b, arrear ar where a.ext_st in ('0', '1', '2' ) and b.rent_l_cd=ar.rent_l_cd and  a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st and "+est_dt1+" "+settle_dt+" "+condition1+"\n"+
				 "      union all"+
				 "      select '대여료' gubun2, '' rent_s_cd, a.rent_l_cd, "+est_amt2+" est_amt from scd_fee a, arrear ar where a.rent_l_cd = ar.rent_l_cd and  "+est_dt2+" "+settle_dt+" "+condition2+"\n"+
				 "      union all"+
				 "      select '과태료' gubun2, a.rent_s_cd, a.rent_l_cd, "+est_amt3+" est_amt from fine a  where "+est_dt3+" "+settle_dt+" "+condition3+"\n"+
				 "      union all"+
				 "      select '면책금' gubun2, b.rent_s_cd, a.rent_l_cd, "+est_amt4+" est_amt from service a, accident b , scd_ext se where se.ext_st = '3' and se.rent_mng_id = a.rent_mng_id and se.rent_l_cd = a.rent_l_cd and se.ext_id = a.serv_id and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and "+est_dt4+" "+settle_dt+" "+condition4+"\n"+
				 "      union all"+
				 "      select '휴차료' gubun2, '' rent_s_cd, b.rent_l_cd, "+est_amt5+" est_amt from my_accid a, accident b where a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and "+est_dt5+" "+settle_dt+" "+condition5+"\n"+
				 "      union all"+
				 "      select '위약금' gubun2, '' rent_s_cd, a.rent_l_cd, "+est_amt6+" est_amt from scd_ext a, cls_cont b , arrear ar  where a.ext_st = '4' a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd and  b.rent_l_cd = ar.rent_l_cd and a.rent_l_cd=b.rent_l_cd and "+est_dt6+" "+settle_dt+" "+condition6+"\n"+
				 "		union all"+
				 "		select '단기요금' gubun2, a.rent_s_cd, '' rent_l_cd, "+est_amt7+" est_amt from scd_rent a, rent_cont b where a.rent_s_cd=b.rent_s_cd and "+est_dt7+" "+settle_dt+" "+condition7+"\n"+
				 " ) a, cont b, car_reg c, rent_cont d, client e, client f, cont g, users h, car_reg i, arrear ar "+
				 " where"+
				 " a.rent_l_cd=b.rent_l_cd(+)"+
				 " and b.car_mng_id=c.car_mng_id(+)"+
				 " and a.rent_s_cd=d.rent_s_cd(+)"+
				 " and b.client_id=e.client_id(+)"+
				 " and d.cust_id=f.client_id(+)"+
				 " and d.sub_l_cd=g.rent_l_cd(+)"+
				 " and a.rent_l_cd=ar.rent_l_cd "+
				 " and d.cust_id=h.user_id(+) and d.car_mng_id=i.car_mng_id(+)";


		query = " select"+
				" use_yn, client_id, firm_nm, car_mng_id, car_no, bus_id2, nvl(rent_l_cd,min(rent_s_cd)) rent_l_cd, rent_mng_id,"+
				" min(gubun3) gubun3, min(rent_s_cd) rent_s_cd, credit_method,"+
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
		
		if(s_kd.equals("1"))		query += " and firm_nm like '%"+t_wd+"%'";
		else if(s_kd.equals("4"))	query += " and car_no like '%"+t_wd+"%'";
		else if(s_kd.equals("8"))	query += " and bus_id2 = '"+t_wd+"'";

		query += " group by use_yn, client_id, firm_nm, car_mng_id, car_no, bus_id2, rent_l_cd, rent_mng_id, credit_method ";

		query += " order by use_yn desc, credit_method , firm_nm";

	
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
			System.out.println("[ArrearDatabase:getSettleList3]\n"+e);
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
	
	
}
