package acar.insur;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.account.*;

public class AddInsurDatabase
{
	private Connection conn = null;
	public static AddInsurDatabase db;
	
	public static AddInsurDatabase getInstance()
	{
		if(AddInsurDatabase.db == null)
			AddInsurDatabase.db = new AddInsurDatabase();
		return AddInsurDatabase.db;
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


	//지출현황-----------------------------------------------------------------------------------------------


	//보험 납부 리스트 조회 : con_ins_sc_in.jsp
	public Vector getInsPayList(String f_list, String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String est_dt = "e.r_ins_est_dt";
		String pay_dt = "e.pay_dt";

		//만료되지 않은 현재 진행 보험(납부리스트)
		if(f_list.equals("now")){		

			query = " select /*+  merge(b) */ a.car_mng_id, a.ins_st, a.ins_sts, b.rent_mng_id, b.rent_l_cd, b.client_id, b.firm_nm, c.car_no, c.first_car_no, c.car_nm, cn.car_name, b.use_yn,"+
					" (decode(a.air_ds_yn,'Y',1,0)+decode(a.air_as_yn,'Y',1,0)) as air,"+
					" decode(a.age_scp,'1','21세이상','2','26세이상','3','모든운전자') as age_scp,"+
					" a.ins_com_id, d.ins_com_nm, e.ins_tm, e.pay_amt, e.pay_yn,"+
					" DECODE(a.ins_start_dt,'','',SUBSTR(a.ins_start_dt,1,4)||'-'||SUBSTR(a.ins_start_dt,5,2)||'-'||SUBSTR(a.ins_start_dt,7,2)) as ins_start_dt,"+
					" DECODE(a.ins_exp_dt,'','',SUBSTR(a.ins_exp_dt,1,4)||'-'||SUBSTR(a.ins_exp_dt,5,2)||'-'||SUBSTR(a.ins_exp_dt,7,2)) as ins_exp_dt,"+
					" DECODE(e.ins_est_dt,'','',SUBSTR(e.ins_est_dt,1,4)||'-'||SUBSTR(e.ins_est_dt,5,2)||'-'||SUBSTR(e.ins_est_dt,7,2)) as ins_est_dt,"+
					" DECODE(e.pay_dt,'','',SUBSTR(e.pay_dt,1,4)||'-'||SUBSTR(e.pay_dt,5,2)||'-'||SUBSTR(e.pay_dt,7,2)) as pay_dt"+
					" from insur a, cont_n_view b, ins_com d, scd_ins e, (select max(rent_l_cd) rent_l_cd from cont where car_st<>'4' group by car_mng_id) f, car_reg c,  car_etc g, car_nm cn \n"+
					" where a.car_mng_id=e.car_mng_id and a.ins_st=e.ins_st"+
					" and a.ins_com_id=d.ins_com_id"+
					" and a.car_mng_id=b.car_mng_id"+
					" and b.rent_l_cd=f.rent_l_cd "+
					"	and a.car_mng_id = c.car_mng_id  and b.rent_mng_id = g.rent_mng_id(+)  and b.rent_l_cd = g.rent_l_cd(+)  \n"+
                       		"	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+) ";

		//만료된 보험 갱신 대상 리스트(스케줄 내용 필요없다)
		}else if(f_list.equals("renew")){							
			query = " select /*+  merge(b) */ DISTINCT a.car_mng_id, a.ins_st, a.ins_sts, b.rent_mng_id, b.rent_l_cd, b.client_id, b.firm_nm, c.car_no, c.first_car_no, c.car_nm, cn.car_name, b.use_yn,"+
					" (decode(a.air_ds_yn,'Y',1,0)+decode(a.air_as_yn,'Y',1,0)) as air,"+
					" decode(a.age_scp,'1','21세이상','2','26세이상','3','모든운전자') as age_scp,"+
					" a.ins_com_id, d.ins_com_nm, '' as ins_tm, 0 as pay_amt, '' as pay_yn, '' as ins_est_dt, '' as pay_dt,"+
					" DECODE(a.ins_start_dt,'','',SUBSTR(a.ins_start_dt,1,4)||'-'||SUBSTR(a.ins_start_dt,5,2)||'-'||SUBSTR(a.ins_start_dt,7,2)) as ins_start_dt,"+
					" DECODE(a.ins_exp_dt,'','',SUBSTR(a.ins_exp_dt,1,4)||'-'||SUBSTR(a.ins_exp_dt,5,2)||'-'||SUBSTR(a.ins_exp_dt,7,2)) as ins_exp_dt"+
					" from insur a, cont_n_view b, ins_com d, scd_ins e, (select max(rent_l_cd) rent_l_cd from cont where car_st<>'4' group by car_mng_id) f, car_reg c,  car_etc gg, car_nm cn,  \n"+
					" (select car_mng_id, max(ins_st) ins_st from insur group by car_mng_id) g"+
					" where a.car_mng_id=e.car_mng_id(+) and a.ins_st=e.ins_st(+)"+
					" and a.ins_com_id=d.ins_com_id"+
					" and a.car_mng_id=b.car_mng_id and nvl(a.enable_renew,'Y') = 'Y'"+
					" and b.rent_l_cd=f.rent_l_cd "+
					"	and a.car_mng_id = c.car_mng_id  and b.rent_mng_id = gg.rent_mng_id(+)  and b.rent_l_cd = gg.rent_l_cd(+)  \n"+
                       			"	and gg.car_id=cn.car_id(+)  and   gg.car_seq=cn.car_seq(+)   \n"+
					" and a.car_mng_id=g.car_mng_id and a.ins_st=g.ins_st";
					
			query += " and a.ins_exp_dt <= TO_CHAR(SYSDATE+20, 'YYYYMMDD')";
			est_dt = "a.ins_exp_dt";
			pay_dt = est_dt;
		}else{//만료리스트
			query = " select /*+  merge(b) */ DISTINCT a.car_mng_id, a.ins_st, a.ins_sts, b.rent_mng_id, b.rent_l_cd, b.client_id, b.firm_nm, c.car_no, c.first_car_no, c.car_nm, b.use_yn,"+
					" (decode(a.air_ds_yn,'Y',1,0)+decode(a.air_as_yn,'Y',1,0)) as air,"+
					" decode(a.age_scp,'1','21세이상','2','26세이상','3','모든운전자') as age_scp,"+
					" a.ins_com_id, d.ins_com_nm, '' as ins_tm, 0 as pay_amt, '' as pay_yn, '' as ins_est_dt, '' as pay_dt,"+
					" DECODE(a.ins_start_dt,'','',SUBSTR(a.ins_start_dt,1,4)||'-'||SUBSTR(a.ins_start_dt,5,2)||'-'||SUBSTR(a.ins_start_dt,7,2)) as ins_start_dt,"+
					" DECODE(a.ins_exp_dt,'','',SUBSTR(a.ins_exp_dt,1,4)||'-'||SUBSTR(a.ins_exp_dt,5,2)||'-'||SUBSTR(a.ins_exp_dt,7,2)) as ins_exp_dt"+
					" from insur a, cont_n_view b, ins_com d, scd_ins e, (select max(rent_l_cd) rent_l_cd from cont where car_st<>'4' group by car_mng_id) f, car_reg c, \n"+
					" (select car_mng_id, max(ins_st) ins_st from insur group by car_mng_id) g"+
					" where a.car_mng_id=e.car_mng_id(+) and a.ins_st=e.ins_st(+)"+
					" and a.ins_com_id=d.ins_com_id"+
					" and a.car_mng_id=b.car_mng_id and nvl(a.enable_renew,'Y') = 'N'"+//
					" and b.rent_l_cd=f.rent_l_cd "+
					"	and a.car_mng_id = c.car_mng_id   \n"+                      
					" and a.car_mng_id=g.car_mng_id and a.ins_st=g.ins_st";
					
			query += " and a.ins_exp_dt < to_char(sysdate,'YYYYMMDD')";
			est_dt = "a.ins_exp_dt";
			pay_dt = est_dt;

		}

		/*상세조회&&세부조회*/

		//당월-계획
		if(gubun2.equals("1") && gubun3.equals("1")){		query += " and "+est_dt+" like to_char(sysdate,'YYYYMM')||'%'";
		//당월-수금
		}else if(gubun2.equals("1") && gubun3.equals("2")){	query += " and e.r_ins_est_dt like to_char(sysdate,'YYYYMM')||'%' and nvl(e.pay_yn,'0')='1'";
		//당월-미수금
		}else if(gubun2.equals("1") && gubun3.equals("3")){	query += " and e.r_ins_est_dt like to_char(sysdate,'YYYYMM')||'%' and nvl(e.pay_yn,'0')='0'";
		//당일-계획
		}else if(gubun2.equals("2") && gubun3.equals("1")){	query += " and "+est_dt+" = to_char(sysdate,'YYYYMMDD')";
		//당일-수금
		}else if(gubun2.equals("2") && gubun3.equals("2")){	query += " and e.r_ins_est_dt = to_char(sysdate,'YYYYMMDD') and e.pay_dt = to_char(sysdate,'YYYYMMDD')";
		//당일-미수금
		}else if(gubun2.equals("2") && gubun3.equals("3")){	query += " and e.r_ins_est_dt = to_char(sysdate,'YYYYMMDD') and nvl(e.pay_yn,'0')='0'";
		//당일+연체-계획
		}else if(gubun2.equals("6") && gubun3.equals("1")){	query += " and "+est_dt+" <= to_char(sysdate,'YYYYMMDD') and (nvl(e.pay_yn,'0')='0' or e.pay_dt = to_char(sysdate,'YYYYMMDD'))";
		//당일+연체-수금
		}else if(gubun2.equals("6") && gubun3.equals("2")){	query += " and e.r_ins_est_dt <= to_char(sysdate,'YYYYMMDD') and e.pay_dt = to_char(sysdate,'YYYYMMDD')";
		//당일+연체-미수금
		}else if(gubun2.equals("6") && gubun3.equals("3")){	query += " and e.r_ins_est_dt <= to_char(sysdate,'YYYYMMDD') and nvl(e.pay_yn,'0')='0'";
		//기간-계획
		}else if(gubun2.equals("4") && gubun3.equals("1")){	query += " and "+est_dt+" BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		//기간-수금
		}else if(gubun2.equals("4") && gubun3.equals("2")){	query += " and e.r_ins_est_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and nvl(e.pay_yn,'0')='1'";
		//기간-미수금
		}else if(gubun2.equals("4") && gubun3.equals("3")){	query += " and e.r_ins_est_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and nvl(e.pay_yn,'0')='0'";
		//검색-수금
		}else if(gubun2.equals("5") && gubun3.equals("2")){	query += " and nvl(e.pay_yn,'0')='1'";
		//검색-미수금
		}else if(gubun2.equals("5") && gubun3.equals("3")){	query += " and nvl(e.pay_yn,'0')='0'";
		}
	
		if(!gubun4.equals(""))		query += " and a.ins_com_id='"+gubun4+"'";
		
		/*검색조건*/
			
		if(s_kd.equals("1"))		query += " and nvl(b.firm_nm, '') like '%"+t_wd+"%'\n";			
		else if(s_kd.equals("2"))	query += " and nvl(b.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(b.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and (nvl(b.car_no, '') like '%"+t_wd+"%' or nvl(b.first_car_no, '') like '%"+t_wd+"%')\n";
		else if(s_kd.equals("6"))	query += " and upper(b.brch_id) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("9"))	query += " and b.car_nm||b.car_name like '%"+t_wd+"%'\n";
		else if(s_kd.equals("10"))	query += " and nvl(a.ins_start_dt, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("11"))	query += " and nvl(a.ins_exp_dt, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("12"))	query += " and nvl(e.pay_dt, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("13"))	query += " and nvl(e.ins_tm, '') like '%"+t_wd+"%'\n";

		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		/*정렬조건*/

		if(sort_gubun.equals("0"))		query += " order by b.use_yn desc, e.pay_dt "+sort+",  e.ins_est_dt, b.firm_nm";
		else if(sort_gubun.equals("1"))	query += " order by b.use_yn desc, b.firm_nm "+sort+" ";
		else if(sort_gubun.equals("2"))	query += " order by b.use_yn desc, a.ins_com_id "+sort+", b.firm_nm";
		else if(sort_gubun.equals("3"))	query += " order by b.use_yn desc, a.ins_start_dt "+sort+", a.ins_com_id, b.firm_nm";
		else if(sort_gubun.equals("5"))	query += " order by b.use_yn desc, b.car_no "+sort+", b.firm_nm";		
		
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
			System.out.println("[AddInsurDatabase:getInsPayList]"+ e);
			System.out.println("[AddInsurDatabase:getInsPayList]"+ query);
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

	//보험 납부 검색통계 조회 : con_ins_sc.jsp
	public Vector getInsPayStat(String f_list, String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String sub_query = "";
		String est_dt = "e.ins_est_dt";
		String pay_dt = "e.pay_dt";

		//만료되지 않은 현재 진행 보험
		if(f_list.equals("now")){		

			sub_query = " select /*+  merge(b) */ a.car_mng_id, a.ins_st, b.rent_mng_id, b.rent_l_cd, b.client_id, b.firm_nm, c.car_no, c.car_nm, b.use_yn,"+
					" (decode(a.air_ds_yn,'Y',1,0)+decode(a.air_as_yn,'Y',1,0)) as air,"+
					" decode(a.age_scp,'1','21세이상','2','26세이상','3','모든운전자') as age_scp,"+
					" a.ins_com_id, d.ins_com_nm, e.ins_tm, e.pay_amt, e.pay_yn,"+
					" DECODE(a.ins_start_dt,'','',SUBSTR(a.ins_start_dt,1,4)||'-'||SUBSTR(a.ins_start_dt,5,2)||'-'||SUBSTR(a.ins_start_dt,7,2)) as ins_start_dt,"+
					" DECODE(a.ins_exp_dt,'','',SUBSTR(a.ins_exp_dt,1,4)||'-'||SUBSTR(a.ins_exp_dt,5,2)||'-'||SUBSTR(a.ins_exp_dt,7,2)) as ins_exp_dt,"+
					" DECODE(e.ins_est_dt,'','',SUBSTR(e.ins_est_dt,1,4)||'-'||SUBSTR(e.ins_est_dt,5,2)||'-'||SUBSTR(e.ins_est_dt,7,2)) as ins_est_dt,"+
					" DECODE(e.pay_dt,'','',SUBSTR(e.pay_dt,1,4)||'-'||SUBSTR(e.pay_dt,5,2)||'-'||SUBSTR(e.pay_dt,7,2)) as pay_dt"+
					" from insur a, cont_n_view b, ins_com d, scd_ins e, car_reg c "+
					" where a.car_mng_id=e.car_mng_id and a.ins_st=e.ins_st"+
					" and a.ins_com_id=d.ins_com_id and a.car_mng_id = c.car_mng_id "+
					" and a.car_mng_id=b.car_mng_id ";
					

		//만료된 보험 갱신 대상 리스트(스케줄 내용 필요없다)
		}else{							
			sub_query = " select /*+  merge(b) */ a.car_mng_id, a.ins_st, b.rent_mng_id, b.rent_l_cd, b.client_id, b.firm_nm, c.car_no, c.car_nm, b.use_yn,"+
					" (decode(a.air_ds_yn,'Y',1,0)+decode(a.air_as_yn,'Y',1,0)) as air,"+
					" decode(a.age_scp,'1','21세이상','2','26세이상','3','모든운전자') as age_scp,"+
					" a.ins_com_id, d.ins_com_nm, '' as ins_tm, 0 as pay_amt, '' as pay_yn, '' as ins_est_dt, '' as pay_dt,"+
					" DECODE(a.ins_start_dt,'','',SUBSTR(a.ins_start_dt,1,4)||'-'||SUBSTR(a.ins_start_dt,5,2)||'-'||SUBSTR(a.ins_start_dt,7,2)) as ins_start_dt,"+
					" DECODE(a.ins_exp_dt,'','',SUBSTR(a.ins_exp_dt,1,4)||'-'||SUBSTR(a.ins_exp_dt,5,2)||'-'||SUBSTR(a.ins_exp_dt,7,2)) as ins_exp_dt"+
					" from insur a, cont_n_view b, ins_com d, car_reg c "+
					" (select car_mng_id, max(ins_st) ins_st from insur group by car_mng_id) e"+
					" where a.car_mng_id=e.car_mng_id and a.ins_st=e.ins_st"+
					" and a.ins_com_id=d.ins_com_id"+
					" and a.car_mng_id=b.car_mng_id and a.car_mng_id = c.car_mng_id ";
					
			sub_query += " and a.ins_exp_dt <= to_char(sysdate,'YYYYMMDD')";
			est_dt = "a.ins_exp_dt";
			pay_dt = est_dt;
		}

		/*상세조회&&세부조회*/

		//당월-계획
		if(gubun2.equals("1") && gubun3.equals("1")){		sub_query += " and "+est_dt+" like to_char(sysdate,'YYYYMM')||'%'";
		//당월-수금
		}else if(gubun2.equals("1") && gubun3.equals("2")){	sub_query += " and e.ins_est_dt like to_char(sysdate,'YYYYMM')||'%' and nvl(e.pay_yn,'0')='1'";
		//당월-미수금
		}else if(gubun2.equals("1") && gubun3.equals("3")){	sub_query += " and e.ins_est_dt like to_char(sysdate,'YYYYMM')||'%' and nvl(e.pay_yn,'0')='0'";
		//당일-계획
		}else if(gubun2.equals("2") && gubun3.equals("1")){	sub_query += " and "+est_dt+" = to_char(sysdate,'YYYYMMDD')";
		//당일-수금
		}else if(gubun2.equals("2") && gubun3.equals("2")){	sub_query += " and e.ins_est_dt = to_char(sysdate,'YYYYMMDD') and e.pay_dt = to_char(sysdate,'YYYYMMDD')";
		//당일-미수금
		}else if(gubun2.equals("2") && gubun3.equals("3")){	sub_query += " and e.ins_est_dt = to_char(sysdate,'YYYYMMDD') and nvl(e.pay_yn,'0')='0'";
		//기간-계획
		}else if(gubun2.equals("4") && gubun3.equals("1")){	sub_query += " and "+est_dt+" BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		//기간-수금
		}else if(gubun2.equals("4") && gubun3.equals("2")){	sub_query += " and e.ins_est_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and nvl(e.pay_yn,'0')='1'";
		//기간-미수금
		}else if(gubun2.equals("4") && gubun3.equals("3")){	sub_query += " and e.ins_est_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and nvl(e.pay_yn,'0')='0'";
		//검색-수금
		}else if(gubun2.equals("5") && gubun3.equals("2")){	sub_query += " and nvl(e.pay_yn,'0')='1'";
		//검색-미수금
		}else if(gubun2.equals("5") && gubun3.equals("3")){	sub_query += " and nvl(e.pay_yn,'0')='0'";
		}
	
		if(!gubun4.equals(""))		sub_query += " and a.ins_com_id='"+gubun4+"'";
		
		if(!br_id.equals("S1") && !br_id.equals(""))	sub_query += " and nvl(b.brch_id, '')='"+br_id+"'";

		/*검색조건*/
			
		if(s_kd.equals("1"))		sub_query += " and nvl(b.firm_nm, '') like '%"+t_wd+"%'\n";			
		else if(s_kd.equals("2"))	sub_query += " and nvl(b.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	sub_query += " and upper(b.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	sub_query += " and nvl(b.car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	sub_query += " and upper(b.brch_id) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("9"))	sub_query += " and nvl(b.car_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("10"))	sub_query += " and nvl(a.ins_start_dt, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("11"))	sub_query += " and nvl(a.ins_exp_dt, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("12"))	sub_query += " and nvl(e.pay_dt, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("13"))	sub_query += " and nvl(e.ins_tm, '') like '%"+t_wd+"%'\n";

		String query = "";
		query = " select '계획' gubun, 'N' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+
					" ( select count(*) tot_su1, nvl(sum(pay_amt),0) tot_amt1 from ("+sub_query+") where ins_est_dt like to_char(SYSDATE, 'YYYY-MM')||'%' ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(pay_amt),0) tot_amt2 from ("+sub_query+") where ins_est_dt = to_char(SYSDATE, 'YYYY-MM-DD') ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(pay_amt),0) tot_amt3 from ("+sub_query+") where ins_est_dt < to_char(SYSDATE, 'YYYY-MM-DD') and (pay_dt is null or pay_dt = to_char(SYSDATE, 'YYYY-MM-DD')) ) c\n"+
				" union all\n"+
				" select '지출' gubun, 'N' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(pay_amt),0) tot_amt1 from ("+sub_query+") where ins_est_dt like to_char(SYSDATE, 'YYYY-MM')||'%' and pay_dt is not null) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(pay_amt),0) tot_amt2 from ("+sub_query+") where ins_est_dt = to_char(SYSDATE, 'YYYY-MM-DD') and pay_dt = to_char(SYSDATE, 'YYYY-MM-DD') ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(pay_amt),0) tot_amt3 from ("+sub_query+") where ins_est_dt < to_char(SYSDATE, 'YYYY-MM-DD') and pay_dt = to_char(SYSDATE, 'YYYY-MM-DD') ) c\n"+
				" union all\n"+
				" select '미지출' gubun, 'N' gubun_sub, a.*, b.*, c.*\n"+
				" from \n"+
					" ( select count(*) tot_su1, nvl(sum(pay_amt),0) tot_amt1 from ("+sub_query+") where ins_est_dt like to_char(SYSDATE, 'YYYY-MM')||'%' and pay_dt is null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(pay_amt),0) tot_amt2 from ("+sub_query+") where ins_est_dt = to_char(SYSDATE, 'YYYY-MM-DD') and pay_dt is null) b,\n"+
					" ( select count(*) tot_su3, nvl(sum(pay_amt),0) tot_amt3 from ("+sub_query+") where ins_est_dt < to_char(SYSDATE, 'YYYY-MM-DD') and pay_dt is null ) c\n"+
				" union all\n"+
				" select '비율' gubun, 'N' gubun_sub, a.*, b.*, c.*\n"+
				" from \n"+
					" ( select decode(a.tot_su1, 0,0, to_number(to_char((b.tot_su1/a.tot_su1)*100, 999.99))) tot_su1, decode(a.tot_amt1, 0,0, to_number(to_char((b.tot_amt1/a.tot_amt1)*100, 999.99))) tot_amt1 from \n"+
						" ( select count(*) tot_su1, nvl(sum(pay_amt),0) tot_amt1 from ("+sub_query+") where substr(ins_est_dt,1,7) = to_char(SYSDATE, 'YYYY-MM') ) a,\n"+
						" ( select count(*) tot_su1, nvl(sum(pay_amt),0) tot_amt1 from ("+sub_query+") where substr(ins_est_dt,1,7) = to_char(SYSDATE, 'YYYY-MM') and pay_dt is not null ) b\n"+
					" ) a,\n"+
					" ( select decode(a.tot_su2, 0,0, to_number(to_char((b.tot_su2/a.tot_su2)*100, 999.99))) tot_su2, decode(a.tot_amt2, 0,0, to_number(to_char((b.tot_amt2/a.tot_amt2)*100, 999.99))) tot_amt2 from \n"+
						" ( select count(*) tot_su2, nvl(sum(pay_amt),0) tot_amt2 from ("+sub_query+") where ins_est_dt = to_char(SYSDATE, 'YYYY-MM-DD') ) a,\n"+
						" ( select count(*) tot_su2, nvl(sum(pay_amt),0) tot_amt2 from ("+sub_query+") where ins_est_dt = to_char(SYSDATE, 'YYYY-MM-DD') and pay_dt = to_char(SYSDATE, 'YYYY-MM-DD') ) b\n"+
					" ) b,\n"+
					" ( select decode(a.tot_su3, 0,0, to_number(to_char((b.tot_su3/a.tot_su3)*100, 999.99))) tot_su3, decode(a.tot_amt3, 0,0, to_number(to_char((b.tot_amt3/a.tot_amt3)*100, 999.99))) tot_amt3 from \n"+
						" ( select count(*) tot_su3, nvl(sum(pay_amt),0) tot_amt3 from ("+sub_query+") where ins_est_dt < to_char(SYSDATE, 'YYYY-MM-DD') and (pay_dt is null or pay_dt = to_char(SYSDATE, 'YYYY-MM-DD')) ) a,\n"+
						" ( select count(*) tot_su3, nvl(sum(pay_amt),0) tot_amt3 from ("+sub_query+") where ins_est_dt < to_char(SYSDATE, 'YYYY-MM-DD') and pay_dt = to_char(SYSDATE, 'YYYY-MM-DD') ) b\n"+
					" ) c";
		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{
				IncomingBean fee = new IncomingBean();
				fee.setGubun(rs.getString(1));
				fee.setGubun_sub(rs.getString(2));
				fee.setTot_su1(rs.getInt(3));
				fee.setTot_amt1(rs.getInt(4));
				fee.setTot_su2(rs.getInt(5));
				fee.setTot_amt2(rs.getInt(6));
				fee.setTot_su3(rs.getInt(7));
				fee.setTot_amt3(rs.getInt(8));
				vt.add(fee);
			}
            rs.close();
            pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AddInsurDatabase:getInsPayStat]"+ e);
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


	//보험관리 리스트 조회
	public Vector getInsList(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select /*+  merge(c) */ a.car_mng_id, c.rent_mng_id, c.rent_l_cd, c.firm_nm, c.use_yn,\n"+
				" cr.car_no, e.car_nm, d.car_name,\n"+
				" f.ins_com_nm, a.ins_st, a.ins_start_dt, a.ins_exp_dt,\n"+ 
				" (decode(a.air_ds_yn,'Y',1,0)+decode(a.air_as_yn,'Y',1,0)) as air,\n"+
				" decode(a.age_scp,'1','21세이상','2','26세이상','3','모든운전자') as age_scp,\n"+
				" decode(a.ins_kd,'2','책임보험', '종합보험') as ins_kd,\n"+
				" decode(a.ins_sts,'1','유효', '2','만료', '3','중도해지') as ins_sts\n"+
				" from insur a, (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where car_st<>'4' group by car_mng_id) b, cont_n_view c,\n"+
				" car_nm d, car_mng e, ins_com f,  car_reg cr , car_etc ce \n"+
				" where\n"+
				" b.car_mng_id=a.car_mng_id(+)\n"+
				" and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd and a.car_mng_id = c.car_mng_id \n"+
				"	and  b.rent_mng_id = ce.rent_mng_id(+)  and b.rent_l_cd = ce.rent_l_cd(+)  \n"+
				" and ce.car_id=d.car_id(+) and ce.car_seq=d.car_seq(+) \n"+
				" and d.car_comp_id=e.car_comp_id and d.car_cd=e.code\n"+
				" and a.ins_com_id=f.ins_com_id";

		if(!st_dt.equals("") && gubun2.equals("1"))		query += " and a.ins_start_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		if(!st_dt.equals("") && gubun2.equals("2"))		query += " and a.ins_exp_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";

		if(gubun3.equals("1"))							query += " and nvl(a.ins_kd,'1') ='"+gubun3+"'";
		if(gubun3.equals("2"))							query += " and nvl(a.ins_kd,'1') ='"+gubun3+"'";
		if(gubun3.equals("3"))							query += " and a.car_mng_id =''";

		if(!gubun4.equals(""))							query += " and nvl(a.ins_sts,'1') ='"+gubun4+"'";

		if(!br_id.equals("S1") && !br_id.equals(""))	query += " and nvl(c.brch_id, '')='"+br_id+"'";

			
		if(!t_wd.equals("")){
			if(s_kd.equals("1"))			query += " and nvl(c.firm_nm,c.client_nm) like '%"+t_wd+"%'\n";			
			else if(s_kd.equals("2"))		query += " and upper(c.rent_l_cd) like upper('%"+t_wd+"%')\n";
			else if(s_kd.equals("3"))		query += " and (cr.car_no like '%"+t_wd+"%' or c.first_car_no like '%"+t_wd+"%')\n";
			else if(s_kd.equals("4"))		query += " and e.car_nm||d.car_name like '%"+t_wd+"%'\n";
			else if(s_kd.equals("5"))		query += " and upper(cr.car_num) like upper('%"+t_wd+"%')\n";
		}

		if(sort.equals("1"))		query += " order by c.use_yn desc, a.ins_start_dt "+asc;
		else if(sort.equals("6"))	query += " order by c.use_yn desc, a.ins_exp_dt "+asc;
		else if(sort.equals("2"))	query += " order by c.use_yn desc, nvl(c.firm_nm,c.client_nm) "+asc;
		else if(sort.equals("3"))	query += " order by c.use_yn desc, cr.car_no "+asc;
		else if(sort.equals("4"))	query += " order by c.use_yn desc, e.car_nm||d.car_name "+asc;
		else if(sort.equals("5"))	query += " order by c.use_yn desc, f.ins_com_nm "+asc;

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
			
			System.out.println("[AddInsurDatabase:getInsList]"+ e);
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

	//보험현황-갱신예정리스트
	public Vector getInsStatList1(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select /*+  merge(c) */ a.car_mng_id, c.rent_mng_id, c.rent_l_cd, c.firm_nm, c.use_yn,\n"+
				" cr.car_no, e.car_nm, d.car_name,\n"+
				" f.ins_com_nm, a.ins_st, a.ins_start_dt, a.ins_exp_dt,\n"+ 
				" (decode(a.air_ds_yn,'Y',1,0)+decode(a.air_as_yn,'Y',1,0)) as air,\n"+
				" decode(a.age_scp,'1','21세이상','2','26세이상','3','모든운전자') as age_scp,\n"+
				" decode(a.ins_kd,'2','책임보험', '종합보험') as ins_kd,\n"+
				" decode(a.ins_sts,'1','유효', '2','만료', '3','중도해지') as ins_sts\n"+
				" from insur a, (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where car_st<>'4' group by car_mng_id) b, cont_n_view c,\n"+
				" car_nm d, car_mng e, ins_com f,  car_reg cr , car_etc ce \n"+
				" where a.ins_sts='1'\n"+
				" and b.car_mng_id=a.car_mng_id(+)\n"+
				" and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd and a.car_mng_id = c.car_mng_id \n"+
				"	and  b.rent_mng_id = ce.rent_mng_id(+)  and b.rent_l_cd = ce.rent_l_cd(+)  \n"+
				" and ce.car_id=d.car_id(+) and ce.car_seq=d.car_seq(+)\n"+
				" and d.car_comp_id=e.car_comp_id and d.car_cd=e.code\n"+
				" and a.ins_com_id=f.ins_com_id";


		if(gubun2.equals("1"))							query += " and a.ins_exp_dt < to_char(sysdate,'YYYYMMDD')";
		if(gubun2.equals("2"))							query += " and a.ins_exp_dt < to_char(sysdate-30,'YYYYMMDD')";


		if(gubun3.equals("1"))							query += " and nvl(a.ins_kd,'1') ='"+gubun3+"'";
		if(gubun3.equals("2"))							query += " and nvl(a.ins_kd,'1') ='"+gubun3+"'";
		if(gubun3.equals("3"))							query += " and a.car_mng_id =''";

		if(!gubun4.equals(""))							query += " and nvl(a.ins_sts,'1') ='"+gubun4+"'";

		if(!br_id.equals("S1") && !br_id.equals(""))	query += " and nvl(c.brch_id, '')='"+br_id+"'";

			
		if(!t_wd.equals("")){
			if(s_kd.equals("1"))			query += " and nvl(c.firm_nm,c.client_nm) like '%"+t_wd+"%'\n";			
			else if(s_kd.equals("2"))		query += " and upper(c.rent_l_cd) like upper('%"+t_wd+"%')\n";
			else if(s_kd.equals("3"))		query += " and (cr.car_no like '%"+t_wd+"%' or c.first_car_no like '%"+t_wd+"%')\n";
			else if(s_kd.equals("4"))		query += " and e.car_nm||d.car_name like '%"+t_wd+"%'\n";
			else if(s_kd.equals("5"))		query += " and upper(c.car_num) like upper('%"+t_wd+"%')\n";
		}

		if(sort.equals("1"))		query += " order by c.use_yn desc, a.ins_start_dt "+asc;
		else if(sort.equals("6"))	query += " order by c.use_yn desc, a.ins_exp_dt "+asc;
		else if(sort.equals("2"))	query += " order by c.use_yn desc, nvl(c.firm_nm,c.client_nm) "+asc;
		else if(sort.equals("3"))	query += " order by c.use_yn desc, cr.car_no "+asc;
		else if(sort.equals("4"))	query += " order by c.use_yn desc, e.car_nm||d.car_name "+asc;
		else if(sort.equals("5"))	query += " order by c.use_yn desc, f.ins_com_nm "+asc;

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
			
			System.out.println("[AddInsurDatabase:getInsStatList1]"+ e);
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



	//보험관리-----------------------------------------------------------------------------------------------

	/**
	 *	보험료 조회 : con_ins_u.jsp
	 */
	public InsurBean getIns(String c_id, String ins_st)
	{
		getConnection();
		InsurBean ins = new InsurBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	"";
		query = " select /*+  merge(C) */ \n"+
				"        I.CAR_MNG_ID, I.INS_ST, I.INS_STS, I.AGE_SCP,\n"+
				"        I.CAR_USE, I.INS_COM_ID, I.INS_CON_NO,\n"+
				"        I.CONR_NM, I.INS_START_DT, I.INS_EXP_DT,\n"+
				"        DECODE(I.INS_START_DT, '', '', SUBSTR(I.INS_START_DT, 1, 4)||'-'||SUBSTR(I.INS_START_DT, 5, 2)||'-'||SUBSTR(I.INS_START_DT, 7, 2)) INS_START_DT2,\n"+
				"        DECODE(I.INS_EXP_DT, '', '', SUBSTR(I.INS_EXP_DT, 1, 4)||'-'||SUBSTR(I.INS_EXP_DT, 5, 2)||'-'||SUBSTR(I.INS_EXP_DT, 7, 2)) INS_EXP_DT2,\n"+
				"        I.RINS_PCP_AMT, I.VINS_PCP_AMT, I.VINS_PCP_KD,\n"+
				"        I.VINS_GCP_AMT, I.VINS_GCP_KD, I.VINS_BACDT_AMT, I.VINS_BACDT_KD, I.VINS_CACDT_AMT,\n"+
				"        I.VINS_BACDT_KC2, I.VINS_SPE, I.VINS_SPE_AMT,\n"+
				"        I.vins_canoisr_amt, I.vins_cacdt_car_amt, I.vins_cacdt_me_amt, I.vins_cacdt_cm_amt,\n"+
				"        I.PAY_TM,\n"+
				"        DECODE(I.CHANGE_DT, '', '', SUBSTR(I.CHANGE_DT, 1, 4)||'-'||SUBSTR(I.CHANGE_DT, 5, 2)||'-'||SUBSTR(I.CHANGE_DT, 7, 2)) CHANGE_DT,\n"+
				"        I.CHANGE_CAU, I.CHANGE_ITM_KD1,\n"+
				"        I.CHANGE_ITM_AMT1, I.CHANGE_ITM_KD2,\n"+
				"        I.CHANGE_ITM_AMT2, I.CHANGE_ITM_KD3,\n"+
				"        I.CHANGE_ITM_AMT3, I.CHANGE_ITM_KD4,\n"+
				"        I.CHANGE_ITM_AMT4, CHANGE_ITM_AMT4, I.CAR_RATE, I.INS_RATE,\n"+
				"        I.EXT_RATE, I.AIR_DS_YN, I.AIR_AS_YN, I.AGNT_NM,\n"+
				"        I.AGNT_TEL, nvl(I.AGNT_IMGN_TEL, M.AGNT_IMGN_TEL) AGNT_IMGN_TEL, I.AGNT_FAX,\n"+
				"        DECODE(I.EXP_DT, '', '', SUBSTR(I.EXP_DT, 1, 4)||'-'||SUBSTR(I.EXP_DT, 5, 2)||'-'||SUBSTR(I.EXP_DT, 7, 2)) EXP_DT,\n"+
				"        I.EXP_CAU, I.RTN_AMT,\n"+
				"        (I.CHANGE_ITM_AMT1+I.CHANGE_ITM_AMT2+I.CHANGE_ITM_AMT3+I.CHANGE_ITM_AMT4) change_amt,\n"+
				"        I.CON_F_NM, I.AGNT_DEPT, nvl(I.ACC_TEL, M.ACC_TEL) ACC_TEL, I.RTN_DT, I.enable_renew, I.scan_file, I.update_id, I.update_dt,\n"+
				"        DECODE(SIGN(TRUNC(TO_DATE(I.ins_exp_dt, 'YYYYMMDD')-SYSDATE)), -1, 'N', 'Y') use_yn,\n"+	//Y:유효, N:만료
				"        C.FIRM_NM, C.CLIENT_NM, cr.car_num, cn.CAR_NAME,\n"+
				"        C.RENT_L_CD, C.car_ja, cr.car_no, cr.car_nm, M.ins_com_nm,\n"+
				"        I.CHANGE_DT1, I.CHANGE_DT2, I.CHANGE_DT3, I.CHANGE_DT4,"+
				"        I.CHANGE_INS_NO1, I.CHANGE_INS_NO2, I.CHANGE_INS_NO3, I.CHANGE_INS_NO4,"+
				"        I.CHANGE_INS_START_DT1, I.CHANGE_INS_START_DT2, I.CHANGE_INS_START_DT3, I.CHANGE_INS_START_DT4,"+
				"        I.CHANGE_INS_EXP_DT1, I.CHANGE_INS_EXP_DT2, I.CHANGE_INS_EXP_DT3, I.CHANGE_INS_EXP_DT4, i.com_emp_yn \n"+
				" from   insur I, cont_n_view C, INS_COM M, (select max(rent_l_cd) rent_l_cd from cont where car_st<>'4' group by car_mng_id) E, car_reg cr,  car_etc g, car_nm cn \n"+
				" where  I.car_mng_id = C.car_mng_id and\n"+
				"        C.rent_l_cd = E.rent_l_cd and\n"+
				"        I.ins_com_id = M.ins_com_id \n"+
				"	and i.car_mng_id = cr.car_mng_id  and c.rent_mng_id = g.rent_mng_id(+)  and c.rent_l_cd = g.rent_l_cd(+)  \n"+
                       		"	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+)  \n"+
				"       and  I.CAR_MNG_ID = ? and I.INS_ST = ? \n";
		try{
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, c_id);
				pstmt.setString(2, ins_st);
		    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				ins.setCar_mng_id(rs.getString("CAR_MNG_ID")==null?"":rs.getString("CAR_MNG_ID"));
				ins.setIns_st(rs.getString("INS_ST")==null?"":rs.getString("INS_ST"));
				ins.setIns_sts(rs.getString("INS_STS")==null?"":rs.getString("INS_STS"));
				ins.setAge_scp(rs.getString("AGE_SCP")==null?"":rs.getString("AGE_SCP"));
				ins.setCar_use(rs.getString("CAR_USE")==null?"":rs.getString("CAR_USE"));
				ins.setIns_com_id(rs.getString("INS_COM_ID")==null?"":rs.getString("INS_COM_ID"));
				ins.setIns_con_no(rs.getString("INS_CON_NO")==null?"":rs.getString("INS_CON_NO"));
				ins.setConr_nm(rs.getString("CONR_NM")==null?"":rs.getString("CONR_NM"));
				ins.setIns_start_dt(rs.getString("INS_START_DT")==null?"":rs.getString("INS_START_DT"));
				ins.setIns_exp_dt(rs.getString("INS_EXP_DT")==null?"":rs.getString("INS_EXP_DT"));
				ins.setRins_pcp_amt(rs.getInt("RINS_PCP_AMT"));
				ins.setVins_pcp_kd(rs.getString("VINS_PCP_KD")==null?"":rs.getString("VINS_PCP_KD"));
				ins.setVins_pcp_amt(rs.getInt("VINS_PCP_AMT"));
				ins.setVins_gcp_kd(rs.getString("VINS_GCP_KD")==null?"":rs.getString("VINS_GCP_KD"));
				ins.setVins_gcp_amt(rs.getInt("VINS_GCP_AMT"));
				ins.setVins_bacdt_kd(rs.getString("VINS_BACDT_KD")==null?"":rs.getString("VINS_BACDT_KD"));
				ins.setVins_bacdt_amt(rs.getInt("VINS_BACDT_AMT"));
				ins.setVins_cacdt_amt(rs.getInt("VINS_CACDT_AMT"));
				ins.setVins_canoisr_amt(rs.getInt("VINS_CANOISR_AMT"));
				ins.setVins_cacdt_car_amt(rs.getInt("VINS_CACDT_CAR_AMT"));
				ins.setVins_cacdt_me_amt(rs.getInt("VINS_CACDT_ME_AMT"));
				ins.setVins_cacdt_cm_amt(rs.getInt("VINS_CACDT_CM_AMT"));
				ins.setPay_tm(rs.getString("PAY_TM")==null?"":rs.getString("PAY_TM"));
				ins.setChange_dt(rs.getString("CHANGE_DT")==null?"":rs.getString("CHANGE_DT"));
				ins.setChange_cau(rs.getString("CHANGE_CAU")==null?"":rs.getString("CHANGE_CAU"));
				ins.setChange_itm_kd1(rs.getString("CHANGE_ITM_KD1")==null?"":rs.getString("CHANGE_ITM_KD1"));
				ins.setChange_itm_amt1(rs.getInt("CHANGE_ITM_AMT1"));
				ins.setChange_itm_kd2(rs.getString("CHANGE_ITM_KD2")==null?"":rs.getString("CHANGE_ITM_KD2"));
				ins.setChange_itm_amt2(rs.getInt("CHANGE_ITM_AMT2"));
				ins.setChange_itm_kd3(rs.getString("CHANGE_ITM_KD3")==null?"":rs.getString("CHANGE_ITM_KD3"));
				ins.setChange_itm_amt3(rs.getInt("CHANGE_ITM_AMT3"));
				ins.setChange_itm_kd4(rs.getString("CHANGE_ITM_KD4")==null?"":rs.getString("CHANGE_ITM_KD4"));
				ins.setChange_itm_amt4(rs.getInt("CHANGE_ITM_AMT4"));
				ins.setCar_rate(rs.getString("CAR_RATE")==null?"":rs.getString("CAR_RATE"));
				ins.setIns_rate(rs.getString("INS_RATE")==null?"":rs.getString("INS_RATE"));
				ins.setExt_rate(rs.getString("EXT_RATE")==null?"":rs.getString("EXT_RATE"));
				ins.setAir_ds_yn(rs.getString("AIR_DS_YN")==null?"":rs.getString("AIR_DS_YN"));
				ins.setAir_as_yn(rs.getString("AIR_AS_YN")==null?"":rs.getString("AIR_AS_YN"));
				ins.setAgnt_nm(rs.getString("AGNT_NM")==null?"":rs.getString("AGNT_NM"));
				ins.setAgnt_tel(rs.getString("AGNT_TEL")==null?"":rs.getString("AGNT_TEL"));
				ins.setAgnt_imgn_tel(rs.getString("AGNT_IMGN_TEL")==null?"":rs.getString("AGNT_IMGN_TEL"));
				ins.setAgnt_fax(rs.getString("AGNT_FAX")==null?"":rs.getString("AGNT_FAX"));
				ins.setExp_dt(rs.getString("EXP_DT")==null?"":rs.getString("EXP_DT"));
				ins.setExp_cau(rs.getString("EXP_CAU")==null?"":rs.getString("EXP_CAU"));
				ins.setRtn_amt(rs.getInt("RTN_AMT"));
				ins.setRtn_dt(rs.getString("RTN_DT")==null?"":rs.getString("RTN_DT"));
				ins.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				ins.setFirm_nm(rs.getString("FIRM_NM")==null?"":rs.getString("FIRM_NM"));
				ins.setCar_num(rs.getString("CAR_NUM")==null?"":rs.getString("CAR_NUM"));
				ins.setClient_nm(rs.getString("CLIENT_NM")==null?"":rs.getString("CLIENT_NM"));
				ins.setCar_no(rs.getString("CAR_NO")==null?"":rs.getString("CAR_NO"));
				ins.setCar_nm(rs.getString("CAR_NM")==null?"":rs.getString("CAR_NM"));
				ins.setCar_name(rs.getString("CAR_NAME")==null?"":rs.getString("CAR_NAME"));
				ins.setChange_amt(rs.getInt("CHANGE_AMT"));
				ins.setIns_com_nm(rs.getString("INS_COM_NM")==null?"":rs.getString("INS_COM_NM"));
				ins.setIns_start_dt2(rs.getString("INS_START_DT2")==null?"":rs.getString("INS_START_DT2"));
				ins.setIns_exp_dt2(rs.getString("INS_EXP_DT2")==null?"":rs.getString("INS_EXP_DT2"));				
				ins.setUse_yn(rs.getString("USE_YN")==null?"":rs.getString("USE_YN"));
				ins.setEnable_renew(rs.getString("ENABLE_RENEW")==null?"":rs.getString("ENABLE_RENEW"));				
				ins.setCon_f_nm(rs.getString("CON_F_NM")==null?"":rs.getString("CON_F_NM"));
				ins.setAcc_tel(rs.getString("ACC_TEL")==null?"":rs.getString("ACC_TEL"));
				ins.setAgnt_dept(rs.getString("AGNT_DEPT")==null?"":rs.getString("AGNT_DEPT"));
				ins.setVins_bacdt_kc2(rs.getString("VINS_BACDT_KC2")==null?"":rs.getString("VINS_BACDT_KC2"));
				ins.setVins_spe(rs.getString("VINS_SPE")==null?"":rs.getString("VINS_SPE"));
				ins.setVins_spe_amt(rs.getInt("VINS_SPE_AMT"));
				ins.setCar_ja(rs.getInt("CAR_JA"));
				ins.setScan_file(rs.getString("SCAN_FILE")==null?"":rs.getString("SCAN_FILE"));
				ins.setUpdate_id(rs.getString("UPDATE_ID")==null?"":rs.getString("UPDATE_ID"));
				ins.setUpdate_dt(rs.getString("UPDATE_DT")==null?"":rs.getString("UPDATE_DT"));
				ins.setChange_dt1(rs.getString("CHANGE_DT1")==null?"":rs.getString("CHANGE_DT1"));
				ins.setChange_dt2(rs.getString("CHANGE_DT2")==null?"":rs.getString("CHANGE_DT2"));
				ins.setChange_dt3(rs.getString("CHANGE_DT3")==null?"":rs.getString("CHANGE_DT3"));
				ins.setChange_dt4(rs.getString("CHANGE_DT4")==null?"":rs.getString("CHANGE_DT4"));
				ins.setChange_ins_no1(rs.getString("CHANGE_INS_NO1")==null?"":rs.getString("CHANGE_INS_NO1"));
				ins.setChange_ins_no2(rs.getString("CHANGE_INS_NO2")==null?"":rs.getString("CHANGE_INS_NO2"));
				ins.setChange_ins_no3(rs.getString("CHANGE_INS_NO3")==null?"":rs.getString("CHANGE_INS_NO3"));
				ins.setChange_ins_no4(rs.getString("CHANGE_INS_NO4")==null?"":rs.getString("CHANGE_INS_NO4"));
				ins.setChange_ins_start_dt1(rs.getString("CHANGE_INS_START_DT1")==null?"":rs.getString("CHANGE_INS_START_DT1"));
				ins.setChange_ins_start_dt2(rs.getString("CHANGE_INS_START_DT2")==null?"":rs.getString("CHANGE_INS_START_DT2"));
				ins.setChange_ins_start_dt3(rs.getString("CHANGE_INS_START_DT3")==null?"":rs.getString("CHANGE_INS_START_DT3"));
				ins.setChange_ins_start_dt4(rs.getString("CHANGE_INS_START_DT4")==null?"":rs.getString("CHANGE_INS_START_DT4"));
				ins.setChange_ins_exp_dt1(rs.getString("CHANGE_INS_EXP_DT1")==null?"":rs.getString("CHANGE_INS_EXP_DT1"));
				ins.setChange_ins_exp_dt2(rs.getString("CHANGE_INS_EXP_DT2")==null?"":rs.getString("CHANGE_INS_EXP_DT2"));
				ins.setChange_ins_exp_dt3(rs.getString("CHANGE_INS_EXP_DT3")==null?"":rs.getString("CHANGE_INS_EXP_DT3"));
				ins.setChange_ins_exp_dt4(rs.getString("CHANGE_INS_EXP_DT4")==null?"":rs.getString("CHANGE_INS_EXP_DT4"));
				ins.setCom_emp_yn(rs.getString("com_emp_yn")==null?"":rs.getString("com_emp_yn"));

			}
            rs.close();
            pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AddInsurDatabase:getIns]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
		                if(rs != null )		rs.close();
                		if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ins;
		}
	}

	/**
	 *	보험료 조회 : con_ins_u.jsp
	 */
	public InsurBean getInsCase(String c_id, String ins_st)
	{
		getConnection();
		InsurBean ins = new InsurBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	"";
		query = "select * from insur where car_mng_id=? and ins_st=?";
		try{
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, c_id);
				pstmt.setString(2, ins_st);
		    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				ins.setCar_mng_id(rs.getString("CAR_MNG_ID")==null?"":rs.getString("CAR_MNG_ID"));
				ins.setIns_st(rs.getString("INS_ST")==null?"":rs.getString("INS_ST"));
				ins.setIns_sts(rs.getString("INS_STS")==null?"":rs.getString("INS_STS"));
				ins.setAge_scp(rs.getString("AGE_SCP")==null?"":rs.getString("AGE_SCP"));
				ins.setCar_use(rs.getString("CAR_USE")==null?"":rs.getString("CAR_USE"));
				ins.setIns_com_id(rs.getString("INS_COM_ID")==null?"":rs.getString("INS_COM_ID"));
				ins.setIns_con_no(rs.getString("INS_CON_NO")==null?"":rs.getString("INS_CON_NO"));
				ins.setConr_nm(rs.getString("CONR_NM")==null?"":rs.getString("CONR_NM"));
				ins.setIns_start_dt(rs.getString("INS_START_DT")==null?"":rs.getString("INS_START_DT"));
				ins.setIns_exp_dt(rs.getString("INS_EXP_DT")==null?"":rs.getString("INS_EXP_DT"));
				ins.setRins_pcp_amt(rs.getInt("RINS_PCP_AMT"));
				ins.setVins_pcp_kd(rs.getString("VINS_PCP_KD")==null?"":rs.getString("VINS_PCP_KD"));
				ins.setVins_pcp_amt(rs.getInt("VINS_PCP_AMT"));
				ins.setVins_gcp_kd(rs.getString("VINS_GCP_KD")==null?"":rs.getString("VINS_GCP_KD"));
				ins.setVins_gcp_amt(rs.getInt("VINS_GCP_AMT"));
				ins.setVins_bacdt_kd(rs.getString("VINS_BACDT_KD")==null?"":rs.getString("VINS_BACDT_KD"));
				ins.setVins_bacdt_amt(rs.getInt("VINS_BACDT_AMT"));
				ins.setVins_cacdt_amt(rs.getInt("VINS_CACDT_AMT"));
				ins.setPay_tm(rs.getString("PAY_TM")==null?"":rs.getString("PAY_TM"));
				ins.setChange_dt(rs.getString("CHANGE_DT")==null?"":rs.getString("CHANGE_DT"));
				ins.setChange_cau(rs.getString("CHANGE_CAU")==null?"":rs.getString("CHANGE_CAU"));
				ins.setChange_itm_kd1(rs.getString("CHANGE_ITM_KD1")==null?"":rs.getString("CHANGE_ITM_KD1"));
				ins.setChange_itm_amt1(rs.getInt("CHANGE_ITM_AMT1"));
				ins.setChange_itm_kd2(rs.getString("CHANGE_ITM_KD2")==null?"":rs.getString("CHANGE_ITM_KD2"));
				ins.setChange_itm_amt2(rs.getInt("CHANGE_ITM_AMT2"));
				ins.setChange_itm_kd3(rs.getString("CHANGE_ITM_KD3")==null?"":rs.getString("CHANGE_ITM_KD3"));
				ins.setChange_itm_amt3(rs.getInt("CHANGE_ITM_AMT3"));
				ins.setChange_itm_kd4(rs.getString("CHANGE_ITM_KD4")==null?"":rs.getString("CHANGE_ITM_KD4"));
				ins.setChange_itm_amt4(rs.getInt("CHANGE_ITM_AMT4"));
				ins.setCar_rate(rs.getString("CAR_RATE")==null?"":rs.getString("CAR_RATE"));
				ins.setIns_rate(rs.getString("INS_RATE")==null?"":rs.getString("INS_RATE"));
				ins.setExt_rate(rs.getString("EXT_RATE")==null?"":rs.getString("EXT_RATE"));
				ins.setAir_ds_yn(rs.getString("AIR_DS_YN")==null?"":rs.getString("AIR_DS_YN"));
				ins.setAir_as_yn(rs.getString("AIR_AS_YN")==null?"":rs.getString("AIR_AS_YN"));
				ins.setAgnt_nm(rs.getString("AGNT_NM")==null?"":rs.getString("AGNT_NM"));
				ins.setAgnt_tel(rs.getString("AGNT_TEL")==null?"":rs.getString("AGNT_TEL"));
				ins.setAgnt_imgn_tel(rs.getString("AGNT_IMGN_TEL")==null?"":rs.getString("AGNT_IMGN_TEL"));
				ins.setAgnt_fax(rs.getString("AGNT_FAX")==null?"":rs.getString("AGNT_FAX"));
				ins.setExp_dt(rs.getString("EXP_DT")==null?"":rs.getString("EXP_DT"));
				ins.setExp_cau(rs.getString("EXP_CAU")==null?"":rs.getString("EXP_CAU"));
				ins.setRtn_amt(rs.getInt("RTN_AMT"));
				ins.setRtn_dt(rs.getString("RTN_DT")==null?"":rs.getString("RTN_DT"));
				ins.setEnable_renew(rs.getString("ENABLE_RENEW")==null?"":rs.getString("ENABLE_RENEW"));				
				ins.setCon_f_nm(rs.getString("CON_F_NM")==null?"":rs.getString("CON_F_NM"));
				ins.setAcc_tel(rs.getString("ACC_TEL")==null?"":rs.getString("ACC_TEL"));
				ins.setAgnt_dept(rs.getString("AGNT_DEPT")==null?"":rs.getString("AGNT_DEPT"));
				ins.setVins_canoisr_amt(rs.getInt("VINS_CANOISR_AMT"));
				ins.setVins_cacdt_car_amt(rs.getInt("VINS_CACDT_CAR_AMT"));
				ins.setVins_cacdt_me_amt(rs.getInt("VINS_CACDT_ME_AMT"));
				ins.setVins_cacdt_cm_amt(rs.getInt("VINS_CACDT_CM_AMT"));
				ins.setVins_bacdt_kc2(rs.getString("VINS_BACDT_KC2")==null?"":rs.getString("VINS_BACDT_KC2"));
				ins.setVins_spe(rs.getString("VINS_SPE")==null?"":rs.getString("VINS_SPE"));
				ins.setVins_spe_amt(rs.getInt("VINS_SPE_AMT"));
				ins.setScan_file(rs.getString("SCAN_FILE")==null?"":rs.getString("SCAN_FILE"));
				ins.setUpdate_id(rs.getString("UPDATE_ID")==null?"":rs.getString("UPDATE_ID"));
				ins.setUpdate_dt(rs.getString("UPDATE_DT")==null?"":rs.getString("UPDATE_DT"));
				ins.setChange_dt1(rs.getString("CHANGE_DT1")==null?"":rs.getString("CHANGE_DT1"));
				ins.setChange_dt2(rs.getString("CHANGE_DT2")==null?"":rs.getString("CHANGE_DT2"));
				ins.setChange_dt3(rs.getString("CHANGE_DT3")==null?"":rs.getString("CHANGE_DT3"));
				ins.setChange_dt4(rs.getString("CHANGE_DT4")==null?"":rs.getString("CHANGE_DT4"));
				ins.setChange_ins_no1(rs.getString("CHANGE_INS_NO1")==null?"":rs.getString("CHANGE_INS_NO1"));
				ins.setChange_ins_no2(rs.getString("CHANGE_INS_NO2")==null?"":rs.getString("CHANGE_INS_NO2"));
				ins.setChange_ins_no3(rs.getString("CHANGE_INS_NO3")==null?"":rs.getString("CHANGE_INS_NO3"));
				ins.setChange_ins_no4(rs.getString("CHANGE_INS_NO4")==null?"":rs.getString("CHANGE_INS_NO4"));
				ins.setChange_ins_start_dt1(rs.getString("CHANGE_INS_START_DT1")==null?"":rs.getString("CHANGE_INS_START_DT1"));
				ins.setChange_ins_start_dt2(rs.getString("CHANGE_INS_START_DT2")==null?"":rs.getString("CHANGE_INS_START_DT2"));
				ins.setChange_ins_start_dt3(rs.getString("CHANGE_INS_START_DT3")==null?"":rs.getString("CHANGE_INS_START_DT3"));
				ins.setChange_ins_start_dt4(rs.getString("CHANGE_INS_START_DT4")==null?"":rs.getString("CHANGE_INS_START_DT4"));
				ins.setChange_ins_exp_dt1(rs.getString("CHANGE_INS_EXP_DT1")==null?"":rs.getString("CHANGE_INS_EXP_DT1"));
				ins.setChange_ins_exp_dt2(rs.getString("CHANGE_INS_EXP_DT2")==null?"":rs.getString("CHANGE_INS_EXP_DT2"));
				ins.setChange_ins_exp_dt3(rs.getString("CHANGE_INS_EXP_DT3")==null?"":rs.getString("CHANGE_INS_EXP_DT3"));
				ins.setChange_ins_exp_dt4(rs.getString("CHANGE_INS_EXP_DT4")==null?"":rs.getString("CHANGE_INS_EXP_DT4"));
				ins.setIns_kd(rs.getString("INS_KD")==null?"":rs.getString("INS_KD"));
			}
            rs.close();
            pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AddInsurDatabase:getInsCase]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
		                if(rs != null )		rs.close();
                		if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ins;
		}
	}

	/**
	 * 보험료 INSERT
	 */
	public boolean insertIns(InsurBean ins)
	{
		getConnection();
		boolean flag = true;
		String query = "insert into insur (CAR_MNG_ID, INS_ST, INS_STS, AGE_SCP, CAR_USE, INS_COM_ID, INS_CON_NO, CONR_NM,"+
						" INS_START_DT, INS_EXP_DT, RINS_PCP_AMT, VINS_PCP_KD, VINS_PCP_AMT, VINS_GCP_KD, VINS_GCP_AMT,"+
						" VINS_BACDT_KD, VINS_BACDT_AMT, VINS_CACDT_AMT, PAY_TM, CHANGE_DT, CHANGE_CAU, CHANGE_ITM_KD1,"+
						" CHANGE_ITM_AMT1, CHANGE_ITM_KD2, CHANGE_ITM_AMT2, CHANGE_ITM_KD3, CHANGE_ITM_AMT3, CHANGE_ITM_KD4,"+
						" CHANGE_ITM_AMT4, CAR_RATE, INS_RATE, EXT_RATE, AIR_DS_YN, AIR_AS_YN, AGNT_NM, AGNT_TEL, AGNT_IMGN_TEL,"+
						" AGNT_FAX, EXP_DT, EXP_CAU, RTN_AMT, RTN_DT, ENABLE_RENEW, CON_F_NM, AGNT_DEPT, ACC_TEL,"+
						" VINS_BACDT_KC2, VINS_SPE, VINS_SPE_AMT, SCAN_FILE, REG_ID, REG_DT, UPDATE_ID, UPDATE_DT,"+//추가
						" VINS_CANOISR_AMT, VINS_CACDT_CAR_AMT, VINS_CACDT_ME_AMT, VINS_CACDT_CM_AMT,"+//추가
						" INS_KD"+
						" ) values("+
						" ?, ?, ?, ?, ?, ?, ?, ?, replace(?, '-', ''), replace(?, '-', ''),"+
						" ?, ?, ?, ?, ?, ?, ?, ?, ?, replace(?, '-', ''),"+
						" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
						" ?, ?, ?, ?, ?, ?, ?, ?, replace(?, '-', ''), ?,"+
						" ?, replace(?, '-', ''), ?, ?, ?, ?,"+
						" ?, ?, ?, ?, ?, to_char(sysdate,'YYYYMMDD'), ?, to_char(sysdate,'YYYYMMDD'),"+
						" ?, ?, ?, ?, ?)";
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);	
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, ins.getCar_mng_id());
			pstmt.setString(2, ins.getIns_st());
		    pstmt.setString(3, ins.getIns_sts());
			pstmt.setString(4, ins.getAge_scp());
			pstmt.setString(5, ins.getCar_use());
			pstmt.setString(6, ins.getIns_com_id());
			pstmt.setString(7, ins.getIns_con_no());
			pstmt.setString(8, ins.getConr_nm());
			pstmt.setString(9, ins.getIns_start_dt());
			pstmt.setString(10, ins.getIns_exp_dt());
			pstmt.setInt(11, ins.getRins_pcp_amt());
			pstmt.setString(12, ins.getVins_pcp_kd());
			pstmt.setInt(13, ins.getVins_pcp_amt());
			pstmt.setString(14, ins.getVins_gcp_kd());
			pstmt.setInt(15, ins.getVins_gcp_amt());
			pstmt.setString(16, ins.getVins_bacdt_kd());
			pstmt.setInt(17, ins.getVins_bacdt_amt());
			pstmt.setInt(18, ins.getVins_cacdt_amt());
			pstmt.setString(19, ins.getPay_tm());
			pstmt.setString(20, ins.getChange_dt());
			pstmt.setString(21, ins.getChange_cau());
			pstmt.setString(22, ins.getChange_itm_kd1());
			pstmt.setInt(23, ins.getChange_itm_amt1());
			pstmt.setString(24, ins.getChange_itm_kd2());
			pstmt.setInt(25, ins.getChange_itm_amt2());
			pstmt.setString(26, ins.getChange_itm_kd3());
			pstmt.setInt(27, ins.getChange_itm_amt3());
			pstmt.setString(28, ins.getChange_itm_kd4());
			pstmt.setInt(29, ins.getChange_itm_amt4());
			pstmt.setString(30, ins.getCar_rate());
			pstmt.setString(31, ins.getIns_rate());
			pstmt.setString(32, ins.getExt_rate());
			pstmt.setString(33, ins.getAir_ds_yn());
			pstmt.setString(34, ins.getAir_as_yn());
			pstmt.setString(35, ins.getAgnt_nm());
			pstmt.setString(36, ins.getAgnt_tel());
			pstmt.setString(37, ins.getAgnt_imgn_tel());
			pstmt.setString(38, ins.getAgnt_fax());
			pstmt.setString(39, ins.getExp_dt());
			pstmt.setString(40, ins.getExp_cau());
			pstmt.setInt(41, ins.getRtn_amt());
			pstmt.setString(42, ins.getRtn_dt());
			pstmt.setString(43, ins.getEnable_renew());
			pstmt.setString(44, ins.getCon_f_nm());
			pstmt.setString(45, ins.getAcc_tel());	
			pstmt.setString(46, ins.getAgnt_dept());
			//추가
			pstmt.setString(47, ins.getVins_bacdt_kc2());
			pstmt.setString(48, ins.getVins_spe());
			pstmt.setInt(49, ins.getVins_spe_amt());
			pstmt.setString(50, ins.getScan_file());
			pstmt.setString(51, ins.getReg_id());
			pstmt.setString(52, ins.getReg_id());
			pstmt.setInt(53, ins.getVins_canoisr_amt());
			pstmt.setInt(54, ins.getVins_cacdt_car_amt());
			pstmt.setInt(55, ins.getVins_cacdt_me_amt());
			pstmt.setInt(56, ins.getVins_cacdt_cm_amt());
			pstmt.setString(57, ins.getIns_kd());

			pstmt.executeUpdate();
			pstmt.close();
			
			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddInsurDatabase:insertIns]"+ e);
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
	 * 보험료 UPDATE
	 */
	public boolean updateIns(InsurBean ins)
	{
		getConnection();
		boolean flag = true;
		String query = "update insur set"+
							" INS_STS = ?,"+
							" AGE_SCP = ?,"+
							" CAR_USE = ?,"+
							" INS_COM_ID = ?,"+
							" INS_CON_NO = ?,"+
							" CONR_NM = ?,"+
							" INS_START_DT = replace(?, '-', ''),"+
							" INS_EXP_DT = replace(?, '-', ''),"+
							" RINS_PCP_AMT = ?,"+
							" VINS_PCP_KD = ?,"+
							" VINS_PCP_AMT = ?,"+
							" VINS_GCP_KD = ?,"+
							" VINS_GCP_AMT = ?,"+
							" VINS_BACDT_KD = ?,"+
							" VINS_BACDT_KC2 = ?,"+
							" VINS_BACDT_AMT = ?,"+
							" VINS_CACDT_AMT = ?,"+
							" PAY_TM = ?,"+
							" CHANGE_DT = replace(?, '-', ''),"+
							" CHANGE_CAU = ?,"+
							" CHANGE_ITM_KD1 = ?,"+
							" CHANGE_ITM_AMT1 = ?,"+
							" CHANGE_ITM_KD2 = ?,"+
							" CHANGE_ITM_AMT2 = ?,"+
							" CHANGE_ITM_KD3 = ?,"+
							" CHANGE_ITM_AMT3 = ?,"+
							" CHANGE_ITM_KD4 = ?,"+
							" CHANGE_ITM_AMT4 = ?,"+
							" CAR_RATE = ?,"+
							" INS_RATE = ?,"+
							" EXT_RATE = ?,"+
							" AIR_DS_YN = ?,"+
							" AIR_AS_YN = ?,"+
							" AGNT_NM = ?,"+
							" AGNT_TEL = ?,"+
							" AGNT_IMGN_TEL = ?,"+
							" AGNT_FAX = ?,"+
							" EXP_DT = replace(?, '-', ''),"+
							" EXP_CAU = ?,"+
							" RTN_AMT = ?,"+
							" RTN_DT = replace(?, '-', ''),"+
//							" USE_YN = ?,"+
							" ENABLE_RENEW = ?,"+
							" CON_F_NM = ?,"+
							" AGNT_DEPT = ?,"+
							" ACC_TEL = ?,"+
							" VINS_SPE = ?,"+
							" VINS_SPE_AMT = ?,"+
							" SCAN_FILE = ?,"+
							" UPDATE_ID = ?,"+
							" UPDATE_DT = to_char(sysdate,'YYYYMMDD'),"+
							" VINS_CANOISR_AMT = ?,"+
							" VINS_CACDT_CAR_AMT = ?,"+
							" VINS_CACDT_ME_AMT = ?,"+
							" VINS_CACDT_CM_AMT = ?,"+	
							" CHANGE_DT1 = replace(?, '-', ''),"+
							" CHANGE_DT2 = replace(?, '-', ''),"+
							" CHANGE_DT3 = replace(?, '-', ''),"+
							" CHANGE_DT4 = replace(?, '-', ''),"+
							" CHANGE_INS_NO1 = ?,"+
							" CHANGE_INS_NO2 = ?,"+
							" CHANGE_INS_NO3 = ?,"+
							" CHANGE_INS_NO4 = ?,"+								
							" CHANGE_INS_START_DT1 = replace(?, '-', ''),"+
							" CHANGE_INS_START_DT2 = replace(?, '-', ''),"+
							" CHANGE_INS_START_DT3 = replace(?, '-', ''),"+
							" CHANGE_INS_START_DT4 = replace(?, '-', ''),"+
							" CHANGE_INS_EXP_DT1 = replace(?, '-', ''),"+
							" CHANGE_INS_EXP_DT2 = replace(?, '-', ''),"+
							" CHANGE_INS_EXP_DT3 = replace(?, '-', ''),"+
							" CHANGE_INS_EXP_DT4 = replace(?, '-', ''),"+
							" INS_KD = ?"+
							" where CAR_MNG_ID = ? and INS_ST = ?";
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, ins.getIns_sts());
			pstmt.setString(2, ins.getAge_scp());
			pstmt.setString(3, ins.getCar_use());
			pstmt.setString(4, ins.getIns_com_id());
			pstmt.setString(5, ins.getIns_con_no());
			pstmt.setString(6, ins.getConr_nm());
			pstmt.setString(7, ins.getIns_start_dt());
			pstmt.setString(8, ins.getIns_exp_dt());
			pstmt.setInt(9, ins.getRins_pcp_amt());
			pstmt.setString(10, ins.getVins_pcp_kd());
			pstmt.setInt(11, ins.getVins_pcp_amt());
			pstmt.setString(12, ins.getVins_gcp_kd());
			pstmt.setInt(13, ins.getVins_gcp_amt());
			pstmt.setString(14, ins.getVins_bacdt_kd());
			pstmt.setString(15, ins.getVins_bacdt_kc2());
			pstmt.setInt(16, ins.getVins_bacdt_amt());
			pstmt.setInt(17, ins.getVins_cacdt_amt());
			pstmt.setString(18, ins.getPay_tm());
			pstmt.setString(19, ins.getChange_dt());
			pstmt.setString(20, ins.getChange_cau());
			pstmt.setString(21, ins.getChange_itm_kd1());
			pstmt.setInt(22, ins.getChange_itm_amt1());
			pstmt.setString(23, ins.getChange_itm_kd2());
			pstmt.setInt(24, ins.getChange_itm_amt2());
			pstmt.setString(25, ins.getChange_itm_kd3());
			pstmt.setInt(26, ins.getChange_itm_amt3());
			pstmt.setString(27, ins.getChange_itm_kd4());
			pstmt.setInt(28, ins.getChange_itm_amt4());
			pstmt.setString(29, ins.getCar_rate());
			pstmt.setString(30, ins.getIns_rate());
			pstmt.setString(31, ins.getExt_rate());
			pstmt.setString(32, ins.getAir_ds_yn());
			pstmt.setString(33, ins.getAir_as_yn());
			pstmt.setString(34, ins.getAgnt_nm());
			pstmt.setString(35, ins.getAgnt_tel());
			pstmt.setString(36, ins.getAgnt_imgn_tel());
			pstmt.setString(37, ins.getAgnt_fax());
			pstmt.setString(38, ins.getExp_dt());
			pstmt.setString(39, ins.getExp_cau());
			pstmt.setInt(40, ins.getRtn_amt());
			pstmt.setString(41, ins.getRtn_dt());
//			pstmt.setString(41, ins.getUse_yn());
			pstmt.setString(42, ins.getEnable_renew());
			pstmt.setString(43, ins.getCon_f_nm());
			pstmt.setString(44, ins.getAgnt_dept());
			pstmt.setString(45, ins.getAcc_tel());
			pstmt.setString(46, ins.getVins_spe());
			pstmt.setInt(47, ins.getVins_spe_amt());
			pstmt.setString(48, ins.getScan_file());
			pstmt.setString(49, ins.getUpdate_id());
			pstmt.setInt(50, ins.getVins_canoisr_amt());
			pstmt.setInt(51, ins.getVins_cacdt_car_amt());
			pstmt.setInt(52, ins.getVins_cacdt_me_amt());
			pstmt.setInt(53, ins.getVins_cacdt_cm_amt());
			pstmt.setString(54, ins.getChange_dt1());
			pstmt.setString(55, ins.getChange_dt2());
			pstmt.setString(56, ins.getChange_dt3());
			pstmt.setString(57, ins.getChange_dt4());
			pstmt.setString(58, ins.getChange_ins_no1());
			pstmt.setString(59, ins.getChange_ins_no2());
			pstmt.setString(60, ins.getChange_ins_no3());
			pstmt.setString(61, ins.getChange_ins_no4());
			pstmt.setString(62, ins.getChange_ins_start_dt1());
			pstmt.setString(63, ins.getChange_ins_start_dt2());
			pstmt.setString(64, ins.getChange_ins_start_dt3());
			pstmt.setString(65, ins.getChange_ins_start_dt4());
			pstmt.setString(66, ins.getChange_ins_exp_dt1());
			pstmt.setString(67, ins.getChange_ins_exp_dt2());
			pstmt.setString(68, ins.getChange_ins_exp_dt3());
			pstmt.setString(69, ins.getChange_ins_exp_dt4());
			pstmt.setString(70, ins.getIns_kd());
			pstmt.setString(71, ins.getCar_mng_id());
			pstmt.setString(72, ins.getIns_st());

		    pstmt.executeUpdate();
			pstmt.close();
		    conn.commit();
	  	} catch (Exception e) {
			System.out.println("[AddInsurDatabase:updateIns]"+ e);
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

	//차량별 계약 이력 리스트 : car_ins_list.jsp
	public Vector getRentHistoryList(String c_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select /*+  merge(a) */ a.rent_l_cd, decode(a.use_yn,'Y','대여','해지') use_yn,"+
				" a.firm_nm, decode(a.car_st,'1','렌트','3','리스','2','보유차','4','월렌트','5','업무대여') car_st,"+
				" a.rent_start_dt, a.rent_end_dt,"+
				" DECODE(b.rent_start_dt,'','',SUBSTR(b.rent_start_dt,1,4)||'-'||SUBSTR(b.rent_start_dt,5,2)||'-'||SUBSTR(b.rent_start_dt,7,2)) as rent_start_dt2,"+
				" DECODE(b.rent_end_dt,'','',SUBSTR(b.rent_end_dt,1,4)||'-'||SUBSTR(b.rent_end_dt,5,2)||'-'||SUBSTR(b.rent_end_dt,7,2)) as rent_end_dt2"+
				" from cont_n_view a, fee b"+
				" where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_st='1'"+
				" and a.car_mng_id='"+c_id+"'"+
				" order by a.use_yn, a.rent_dt, a.reg_dt";			
		
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
			System.out.println("[AddInsurDatabase:getRentHistoryList]"+ e);
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

	//차량별 계약 이력 리스트 : car_ins_list.jsp
	public Vector getRentHisList(String c_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.rent_mng_id, a.rent_l_cd,"+
				" decode(a.use_yn,'Y','대여','N','해지') use_yn, a.firm_nm, "+
				" a.rent_start_dt, a.rent_end_dt, c.cls_dt, decode(a.car_st,'1','렌트','2','예비차','3','리스','4','월렌트','5','업무대여') car_st, a.rent_way"+
				" from cont_n_view a, cls_cont c  where a.rent_mng_id = c.rent_mng_id(+) and a.rent_l_cd = c.rent_l_cd(+) and  a.car_mng_id='"+c_id+"' order by nvl(a.rent_start_dt, a.reg_dt)";			
		
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
			System.out.println("[AddInsurDatabase:getRentHistoryList]"+ e);
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

	//차량별 보험 이력 리스트 : car_ins_list.jsp
	public Vector getInsHistoryList(String c_id, String ins_sts)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		if(ins_sts.equals("")){
			query = " select decode(a.vins_pcp_amt, 0, '책임보험','종합보험') gubun, decode(a.ins_st,'0','신규','갱신('||a.ins_st||')') ins_st,"+
					" decode(a.ins_sts,'1','유효','2','만료','3','중도해지','4','오프리스') ins_sts, b.ins_com_nm,"+
					" DECODE(a.ins_start_dt,'','',SUBSTR(a.ins_start_dt,1,4)||'-'||SUBSTR(a.ins_start_dt,5,2)||'-'||SUBSTR(a.ins_start_dt,7,2)) as ins_start_dt,"+
					" DECODE(a.ins_exp_dt,'','',SUBSTR(a.ins_exp_dt,1,4)||'-'||SUBSTR(a.ins_exp_dt,5,2)||'-'||SUBSTR(a.ins_exp_dt,7,2)) as ins_exp_dt,"+
					" (a.rins_pcp_amt+a.vins_pcp_amt+a.vins_gcp_amt+a.vins_bacdt_amt+a.vins_canoisr_amt+a.vins_cacdt_cm_amt+a.change_itm_amt1+a.change_itm_amt2+a.change_itm_amt2+a.change_itm_amt4) ins_amt"+//+vins_cacdt_amt
					" from insur a, ins_com b"+
					" where a.ins_com_id=b.ins_com_id"+
					" and a.car_mng_id='"+c_id+"'"+
					" order by a.ins_st";			
		}else{//오프리스
			query = " select decode(a.ins_type, '1','책임보험','종합보험') gubun, '오프리스' ins_st,"+
					" '유효' ins_sts, b.ins_com_nm,"+
					" DECODE(a.ins_st_dt,'','',SUBSTR(a.ins_st_dt,1,4)||'-'||SUBSTR(a.ins_st_dt,5,2)||'-'||SUBSTR(a.ins_st_dt,7,2)) as ins_start_dt,"+
					" DECODE(a.ins_ed_dt,'','',SUBSTR(a.ins_ed_dt,1,4)||'-'||SUBSTR(a.ins_ed_dt,5,2)||'-'||SUBSTR(a.ins_ed_dt,7,2)) as ins_exp_dt,"+
					" a.pay_pr ins_amt"+
					" from offls_ins a, ins_com b"+
					" where a.ins_com_id=b.ins_com_id"+
					" and a.car_mng_id='"+c_id+"'"+
					" order by a.ins_st_dt";			
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
			System.out.println("[AddInsurDatabase:getInsHistoryList]"+ e);
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

	//차량별 보험 이력 리스트 : car_ins_list.jsp
	public Vector getInsHisList1(String c_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select decode(a.vins_pcp_amt, 0, '책임보험','종합보험') gubun,"+
					" decode(a.ins_sts,'1','유효','2','만료','3','중도해지','4','오프리스') ins_sts, b.ins_com_nm, a.exp_cau,"+
					" DECODE(a.ins_start_dt,'','',SUBSTR(a.ins_start_dt,1,4)||'-'||SUBSTR(a.ins_start_dt,5,2)||'-'||SUBSTR(a.ins_start_dt,7,2)) as ins_start_dt,"+
					" DECODE(a.ins_exp_dt,'','',SUBSTR(a.ins_exp_dt,1,4)||'-'||SUBSTR(a.ins_exp_dt,5,2)||'-'||SUBSTR(a.ins_exp_dt,7,2)) as ins_exp_dt,"+
					" (a.rins_pcp_amt+a.vins_pcp_amt+a.vins_gcp_amt+a.vins_bacdt_amt+a.vins_canoisr_amt+a.vins_cacdt_cm_amt+a.change_itm_amt1+a.change_itm_amt2+a.change_itm_amt2+a.change_itm_amt4) ins_amt, a.rtn_amt"+//+vins_cacdt_amt
					" from insur a, ins_com b"+
					" where a.ins_com_id=b.ins_com_id"+
					" and a.car_mng_id='"+c_id+"'"+
					" order by a.ins_st";			
		
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
			System.out.println("[AddInsurDatabase:getInsHistoryList]"+ e);
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

	//차량별 보험 이력 리스트 : car_ins_list.jsp
	public Vector getInsHisList2(String c_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select decode(a.ins_type, '1','책임보험','종합보험') gubun, '오프리스' ins_st,"+
					" '유효' ins_sts, b.ins_com_nm,"+
					" DECODE(a.ins_st_dt,'','',SUBSTR(a.ins_st_dt,1,4)||'-'||SUBSTR(a.ins_st_dt,5,2)||'-'||SUBSTR(a.ins_st_dt,7,2)) as ins_start_dt,"+
					" DECODE(a.ins_ed_dt,'','',SUBSTR(a.ins_ed_dt,1,4)||'-'||SUBSTR(a.ins_ed_dt,5,2)||'-'||SUBSTR(a.ins_ed_dt,7,2)) as ins_exp_dt,"+
					" a.pay_pr ins_amt, 0 rtn_amt, '' exp_cau"+
					" from offls_ins a, ins_com b"+
					" where a.ins_com_id=b.ins_com_id"+
					" and a.car_mng_id='"+c_id+"'"+
					" order by a.ins_st_dt";			
	
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
			System.out.println("[AddInsurDatabase:getInsHisList2]"+ e);
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

	//계약별 최종 보험회사명
	public String getInsComNm(String c_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String ins_com = "";
		String query = "";

		query = " select b.ins_com_nm from insur a, ins_com b"+
				" where a.ins_com_id=b.ins_com_id and a.car_mng_id='"+c_id+"'"+
				" order by ins_st desc";
		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next()){				
				ins_com = rs.getString(1);
			}
            rs.close();
            pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AddInsurDatabase:getInsComNm]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
		                if(rs != null )		rs.close();
                		if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ins_com;
		}
	}	

	//계약별 최종 보험 구분
	public String getInsSt(String c_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String ins_st = "";
		String query = "";

		query = " select max(ins_st) from insur where car_mng_id='"+c_id+"'";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next()){				
				ins_st = rs.getString(1);
			}
            rs.close();
            pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AddInsurDatabase:getInsSt]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
		                if(rs != null )		rs.close();
                		if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ins_st;
		}
	}	

	//보험스케줄---------------------------------------------------------------------------------------------

	/**
	 *	보험계약별 스케줄 리스트 조회 : con_ins_u.jsp
	 */
	public Vector getInsScds(String c_id, String ins_st)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	" select"+
							" CAR_MNG_ID, INS_TM, INS_ST, PAY_AMT,"+
							" decode(INS_EST_DT, '', '', substr(INS_EST_DT, 1, 4) || '-' || substr(INS_EST_DT, 5, 2) || '-'||substr(INS_EST_DT, 7, 2)) INS_EST_DT,"+
							" decode(PAY_DT, '', '', substr(PAY_DT, 1, 4) || '-' || substr(PAY_DT, 5, 2) || '-'||substr(PAY_DT, 7, 2)) PAY_DT,"+
							" PAY_YN"+
							" from scd_ins "+
							" where CAR_MNG_ID = ? and INS_ST = ? order by ins_est_dt";
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, c_id);
				pstmt.setString(2, ins_st);
		    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				InsurScdBean scd = new InsurScdBean();
				scd.setCar_mng_id(rs.getString("CAR_MNG_ID")==null?"":rs.getString("CAR_MNG_ID"));
				scd.setIns_tm(rs.getString("INS_TM")==null?"":rs.getString("INS_TM"));
				scd.setIns_st(rs.getString("INS_ST")==null?"":rs.getString("INS_ST"));
				scd.setIns_est_dt(rs.getString("INS_EST_DT")==null?"":rs.getString("INS_EST_DT"));
				scd.setPay_amt(rs.getInt("PAY_AMT"));
				scd.setPay_yn(rs.getString("PAY_YN")==null?"":rs.getString("PAY_YN"));
				scd.setPay_dt(rs.getString("PAY_DT")==null?"":rs.getString("PAY_DT"));
				vt.add(scd);
			}
            rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddInsurDatabase:getInsScds]"+ e);
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
	 *	보험계약별 스케줄 리스트 조회 : con_ins_u.jsp
	 */
	public InsurScdBean getInsScd(String c_id, String ins_st, String ins_tm)
	{
		getConnection();
		InsurScdBean scd = new InsurScdBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	" select"+
							" CAR_MNG_ID, INS_TM, INS_ST, PAY_AMT,"+
							" decode(INS_EST_DT, '', '', substr(INS_EST_DT, 1, 4) || '-' || substr(INS_EST_DT, 5, 2) || '-'||substr(INS_EST_DT, 7, 2)) INS_EST_DT,"+
							" decode(PAY_DT, '', '', substr(PAY_DT, 1, 4) || '-' || substr(PAY_DT, 5, 2) || '-'||substr(PAY_DT, 7, 2)) PAY_DT,"+
							" PAY_YN"+
							" from scd_ins "+
							" where CAR_MNG_ID = ? and INS_ST = ? and INS_TM = ?";
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, c_id);
			pstmt.setString(2, ins_st);
			pstmt.setString(3, ins_tm);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{
				scd.setCar_mng_id(rs.getString("CAR_MNG_ID")==null?"":rs.getString("CAR_MNG_ID"));
				scd.setIns_tm(rs.getString("INS_TM")==null?"":rs.getString("INS_TM"));
				scd.setIns_st(rs.getString("INS_ST")==null?"":rs.getString("INS_ST"));
				scd.setIns_est_dt(rs.getString("INS_EST_DT")==null?"":rs.getString("INS_EST_DT"));
				scd.setPay_amt(rs.getInt("PAY_AMT"));
				scd.setPay_yn(rs.getString("PAY_YN")==null?"":rs.getString("PAY_YN"));
				scd.setPay_dt(rs.getString("PAY_DT")==null?"":rs.getString("PAY_DT"));
			}
            rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddInsurDatabase:getInsScd]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
		                if(rs != null )		rs.close();
                		if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return scd;
		}
	}	
	
	/**
	 *	보험료 출금처리 위해 보험 조회 : ins_pay_p.jsp
	 */
	public InsurBean getInsPay(String c_id, String ins_st, String ins_tm)
	{
		getConnection();
		InsurBean ins = new InsurBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	"";
		query = " select /*+  merge(b) */ "+
				" a.car_mng_id, a.ins_st, b.rent_mng_id, b.rent_l_cd, b.firm_nm, c.pay_amt, c.ins_est_dt, c.r_ins_est_dt"+
				" from insur a, cont_n_view b, scd_ins c"+
				" where a.car_mng_id=c.car_mng_id and a.ins_st=c.ins_st and a.car_mng_id=b.car_mng_id"+
				" and a.car_mng_id=? and a.ins_st=? and c.ins_tm=?";
//			
		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, c_id);
			pstmt.setString(2, ins_st);
			pstmt.setString(3, ins_tm);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{
				ins.setCar_mng_id(rs.getString("CAR_MNG_ID")==null?"":rs.getString("CAR_MNG_ID"));
				ins.setIns_st(rs.getString("INS_ST")==null?"":rs.getString("INS_ST"));
				ins.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				ins.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				ins.setFirm_nm(rs.getString("FIRM_NM")==null?"":rs.getString("FIRM_NM"));
				ins.setPay_amt(rs.getInt("PAY_AMT"));
				ins.setIns_est_dt(rs.getString("INS_EST_DT")==null?"":rs.getString("INS_EST_DT"));
				ins.setR_ins_est_dt(rs.getString("R_INS_EST_DT")==null?"":rs.getString("R_INS_EST_DT"));
			}
            rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddInsurDatabase:getInsPay]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
		                if(rs != null )		rs.close();
                		if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ins;
		}
	}

	/**
	 *	보험료스케줄생성 - 추가보험료 : ins_u_a.jsp
	 */
	public boolean insertInsScd(InsurScdBean scd)
	{
		getConnection();
		boolean flag = true;
		String query = "insert into scd_ins (CAR_MNG_ID, INS_TM, INS_ST, INS_EST_DT, PAY_AMT, PAY_YN, PAY_DT, R_INS_EST_DT) values"+
						" (?, ?, ?, replace(?, '-', ''), ?, ?, replace(?, '-', ''), replace(?, '-', ''))";
		PreparedStatement pstmt = null;
		try 
		{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, scd.getCar_mng_id());
			pstmt.setString(2, scd.getIns_tm());
			pstmt.setString(3, scd.getIns_st());
			pstmt.setString(4, scd.getIns_est_dt());
			pstmt.setInt(5, scd.getPay_amt());
			pstmt.setString(6, scd.getPay_yn());
			pstmt.setString(7, scd.getPay_dt());
			pstmt.setString(8, scd.getR_ins_est_dt());
		    pstmt.executeUpdate();
			pstmt.close();
		    conn.commit();

	  	} catch (Exception e) {
			System.out.println("[AddInsurDatabase:insertInsScd]"+ e);
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
	 *	보험료스케줄생성 - 추가보험료 : ins_u_a.jsp
	 */
	public boolean updateInsScd(InsurScdBean scd)
	{
		getConnection();
		boolean flag = true;
		String query = " update scd_ins set"+
						" INS_EST_DT=replace(?, '-', ''), PAY_AMT=?, PAY_YN=?, PAY_DT=replace(?, '-', ''), R_INS_EST_DT=replace(?, '-', '')"+
						" where CAR_MNG_ID=? and INS_TM=? and INS_ST=?";

		PreparedStatement pstmt = null;
		try 
		{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, scd.getIns_est_dt());
			pstmt.setInt(2, scd.getPay_amt());
			pstmt.setString(3, scd.getPay_yn());
			pstmt.setString(4, scd.getPay_dt());
			pstmt.setString(5, scd.getR_ins_est_dt());
			pstmt.setString(6, scd.getCar_mng_id());
			pstmt.setString(7, scd.getIns_tm());
			pstmt.setString(8, scd.getIns_st());
		    pstmt.executeUpdate();
			pstmt.close();
		    conn.commit();

	  	} catch (Exception e) {
			System.out.println("[AddInsurDatabase:updateInsScd]"+ e);
			e.printStackTrace();
	  		flag = false;
		} finally {
			try{	
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}

	/**
	 *	중도해지 -> 보험료스케줄 삭제 : cancel_u_a.jsp
	 */
	public boolean dropInsScd(String c_id, String ins_st, String ins_tm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query =  " delete from scd_ins"+
						" where car_mng_id = ? and ins_st = ? and ins_tm = ?";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, c_id);
			pstmt.setString(2, ins_st);
			pstmt.setString(3, ins_tm);
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
	  		
			System.out.println("[AddInsurDatabase:dropInsScd]"+ e);
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
	 *	중도해지 -> 미납 보험료스케줄 삭제 : cancel_u_a.jsp
	 */
	public boolean dropInsScd(String c_id, String ins_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query =  " delete from scd_ins"+
						" where car_mng_id = ? and ins_st = ? and pay_yn='0'";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, c_id);
			pstmt.setString(2, ins_st);
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddInsurDatabase:dropInsScd2]"+ e);
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
	 * 보험스케줄 확인
	 */
	public boolean getInsScdYn(String c_id, String int_st, int ins_tm)
	{
		getConnection();
		boolean flag = true;
		String query = "select count(*) from scd_ins where car_mng_id='"+c_id+"' and ins_st='"+int_st+"' and ins_tm='"+Integer.toString(ins_tm)+"'";
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count =0;
		try 
		{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			if(rs.next()){
				count = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
			if(count == 0) flag = false;
			
	  	} catch (Exception e) {
			System.out.println("[AddInsurDatabase:getInsScdYn]"+ e);
	  		e.printStackTrace();
	  		flag = false;
		} finally {
			try{	
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}


	//보험사 ------------------------------------------------------------------------------------------------

	//보험사리스트 조회 : ins_com_sh.jsp
	public Vector getInsComList()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select * from ins_com order by ins_com_id";
		
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
					 ht.put(columnName, (rs.getString(columnName))==null?" ":rs.getString(columnName).trim().trim());
				}
				vt.add(ht);	
			}
            rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddInsurDatabase:getInsComList]"+ e);
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
	 * 보험사 INSERT
	 */
	public boolean insertInsCom(InsurComBean ins)
	{
		getConnection();
		boolean flag = true;
		String query = "insert into ins_com (INS_COM_ID, INS_COM_NM, CAR_RATE, INS_RATE, EXT_DATE,"+
						" AGNT_TEL, AGNT_FAX, AGNT_IMGN_TEL, ACC_TEL)"+
						" values("+
							" (select ltrim(to_char(to_number(MAX(INS_COM_ID))+1, '0000')) from ins_com), ?, ?, ?, ?,"+
							" ?, ?, ?, ?"+
						")";
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, ins.getIns_com_nm());
			pstmt.setString(2, ins.getCar_rate());
		    pstmt.setString(3, ins.getIns_rate());
			pstmt.setString(4, ins.getExt_date());
			pstmt.setString(5, ins.getAgnt_tel());
			pstmt.setString(6, ins.getAgnt_fax());
			pstmt.setString(7, ins.getAgnt_imgn_tel());
			pstmt.setString(8, ins.getAcc_tel());
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddInsurDatabase:insertInsCom]"+ e);
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
	 * 보험사 UPDATE
	 */
	public boolean updateInsCom(InsurComBean ins)
	{
		getConnection();
		boolean flag = true;
		String query = "update ins_com set"+
							" INS_COM_NM	= ?,"+
							" CAR_RATE		= ?,"+
							" INS_RATE		= ?,"+
							" EXT_DATE		= ?,"+
							" AGNT_TEL		= ?,"+
							" AGNT_FAX		= ?,"+
							" AGNT_IMGN_TEL = ?,"+
							" ACC_TEL		= ?,"+
							" ZIP			= ?,"+
							" ADDR			= ?,"+
							" INS_COM_F_NM	= ? "+
							" where INS_COM_ID = ?";
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try 
		{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, ins.getIns_com_nm());
			pstmt.setString(2, ins.getCar_rate());
		    pstmt.setString(3, ins.getIns_rate());
			pstmt.setString(4, ins.getExt_date());
			pstmt.setString(5, ins.getAgnt_tel());
			pstmt.setString(6, ins.getAgnt_fax());
			pstmt.setString(7, ins.getAgnt_imgn_tel());
			pstmt.setString(8, ins.getAcc_tel());
			pstmt.setString(9, ins.getZip());
			pstmt.setString(10,ins.getAddr());
			pstmt.setString(11,ins.getIns_com_f_nm());
			pstmt.setString(12, ins.getIns_com_id());
		    pstmt.executeUpdate();
			pstmt.close();
		   	conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddInsurDatabase:updateInsCom]"+ e);
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

	//보험 현황 리스트
	public Vector getInsStatList()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select /*+  merge(a) */ "+ 
				" a.rent_l_cd, a.firm_nm, a.client_nm, cr.car_no, cr.car_nm, decode(b.ins_st,'0','신규','갱신') ins_st, d.ins_com_nm, b.ins_start_dt, b.ins_exp_dt, nvl(a.bus_id2,' ') bus_id2, nvl(a.mng_id,' ') mng_id"+ 
				" from cont_n_view a, insur b, car_reg cr, "+ 
				" (select car_mng_id, max(ins_st) ins_st from insur group by car_mng_id) c,"+ 
				" ins_com d"+ 
				" where a.car_mng_id=b.car_mng_id and nvl(a.use_yn,'Y')='Y'"+ 
				" and a.car_mng_id=c.car_mng_id and b.ins_st=c.ins_st and b.car_mng_id = cr.car_mng_id "+ 
				" and b.ins_com_id=d.ins_com_id"+
				" order by a.firm_nm";
//				" and a.client_id not in ('000231', '000228')		

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
			
			System.out.println("[AddInsurDatabase:getInsStatList]"+ e);
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


	//2회 분납예정일 체크-------------------------------------------------------------------------------------------------------

	/**
	 *	argument로 넘어온 날짜로 주일 및 공휴일을 건너뛰어 가장 가까운 평일 날짜를 리턴
	 */
	public String getValidDt(String dt)
	{	
		String sysdate = dt;
		boolean s_flag = false;
		boolean h_flag = false;
		String c_sysdate = "";
		String c_hol = "";
		while((!s_flag) || (!h_flag))
		{
			/* 요일체크로 리턴된 날짜가 원래의 날짜와 다르다면 */
			c_sysdate = checkSunday(sysdate);
			if(!c_sysdate.equals(sysdate))				sysdate = c_sysdate;
			else										s_flag = true;
			
			if(s_flag && h_flag)	return sysdate;
				
			/* 휴일체크로 리턴된 날짜가 원래의 날짜와 다르다면 */
			c_sysdate = checkHday(sysdate);
			if(!c_sysdate.equals(sysdate))				sysdate = c_sysdate;
			else										h_flag = true;
		}
		return sysdate;
	}
	

	/**
	 *	(요일체크)args로 넘어온 날짜가 일요일인지 체크해서 일요일인경우 +1 날짜를 리턴
	 */
	private String checkSunday(String dt)
	{
		getConnection();
		boolean flag = false;
		String sysdate = dt;
		String query;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String rtnStr = "";
					
		query = "select decode(to_char(to_date(?,'YYYY-MM-DD'),'D'),"+
					" '1',to_char(to_date(?,'YYYY-MM-DD')-2,'YYYY-MM-DD'), '7',to_char(to_date(?,'YYYY-MM-DD')-1,'YYYY-MM-DD'), 'N')"+
					" from dual";
		try{

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, sysdate);
			pstmt.setString(2, sysdate);
			pstmt.setString(3, sysdate);
		    rs = pstmt.executeQuery();			
			while(rs.next())
			{
				rtnStr = rs.getString(1)==null?"":rs.getString(1);
			}
            rs.close();
            pstmt.close();

			/* 일요일,토요일인 경우 하루나 이틀을 더해준다 */
			if(!rtnStr.equals("N"))		sysdate = rtnStr;

		}catch (SQLException e){
			System.out.println("[AddInsurDatabase:checkSunday]\n"+e);
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
	 *	(휴일체크)args로 넘어온 날짜가 휴일인경우 하루씩 더해서 가장 가까운 평일날짜를 리턴
	 */
	private String checkHday(String dt)
	{
		getConnection();
		boolean flag = false;
		String sysdate = dt;
		String query;
		String rStr;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String rtnStr = "";

		query = "select decode(count(*), 0, 'N', to_char(to_date(?,'YYYY-MM-DD')-1,'YYYY-MM-DD')) "+
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
		        rs.close();
	            pstmt.close();

				if(!rtnStr.equals("N"))	sysdate = rtnStr;		/* 휴일인경우 하루를 더하고 다시 한번 휴일인지 확인 */
				else					flag = true;			/*  휴일이 아닌경우 loop를 빠져나온다. */
			}
		}catch (SQLException e)
		{
			System.out.println("[AddInsurDatabase:checkHday]\n"+e);
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


	//보험변경사항---------------------------------------------------------------------------------------------

	/**
	 *	보험변경사항 리스트 조회
	 */
	public Vector getInsChanges(String c_id, String ins_st)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	" select * from ins_change "+
						" where CAR_MNG_ID = ? and INS_ST = ? order by ch_dt";
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, c_id);
				pstmt.setString(2, ins_st);
		    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				InsurChangeBean bean = new InsurChangeBean();
				bean.setCar_mng_id(rs.getString("CAR_MNG_ID")==null?"":rs.getString("CAR_MNG_ID"));
				bean.setIns_st(rs.getString("INS_ST")==null?"":rs.getString("INS_ST"));
				bean.setCh_tm(rs.getString("CH_TM")==null?"":rs.getString("CH_TM"));
				bean.setCh_dt(rs.getString("CH_DT")==null?"":rs.getString("CH_DT"));
				bean.setCh_item(rs.getString("CH_ITEM")==null?"":rs.getString("CH_ITEM"));
				bean.setCh_before(rs.getString("CH_BEFORE")==null?"":rs.getString("CH_BEFORE"));
				bean.setCh_after(rs.getString("CH_AFTER")==null?"":rs.getString("CH_AFTER"));
				bean.setCh_amt(rs.getInt("CH_AMT"));
				bean.setReg_id(rs.getString("REG_ID")==null?"":rs.getString("REG_ID"));
				bean.setReg_dt(rs.getString("REG_DT")==null?"":rs.getString("REG_DT"));
				bean.setUpdate_id(rs.getString("UPDATE_ID")==null?"":rs.getString("UPDATE_ID"));
				bean.setUpdate_dt(rs.getString("UPDATE_DT")==null?"":rs.getString("UPDATE_DT"));
				vt.add(bean);
			}
            rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddInsurDatabase:getInsChanges]"+ e);
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
	 *	보험료스케줄생성 - 추가보험료 : ins_u_a.jsp
	 */
	public boolean insertInsChange(InsurChangeBean bean)
	{
		getConnection();
		boolean flag = true;
		String query =  " insert into ins_change"+
						" (CAR_MNG_ID, INS_ST, CH_TM, CH_DT, CH_ITEM, CH_BEFORE, CH_AFTER, CH_AMT, REG_ID, REG_DT) values"+
						" (?, ?, ?, replace(?, '-', ''), ?, ?, ?, ?, ?, to_char(sysdate,'YYYYMMDD'))";
		PreparedStatement pstmt = null;
		try 
		{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, bean.getCar_mng_id());
			pstmt.setString(2, bean.getIns_st());
			pstmt.setString(3, bean.getCh_tm());
			pstmt.setString(4, bean.getCh_dt());
			pstmt.setString(5, bean.getCh_item());
			pstmt.setString(6, bean.getCh_before());
			pstmt.setString(7, bean.getCh_after());
			pstmt.setInt(8, bean.getCh_amt());
			pstmt.setString(9, bean.getUpdate_id());
		    pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[AddInsurDatabase:insertInsChange]"+ e);
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
	 *	보험료스케줄생성 - 추가보험료 : ins_u_a.jsp
	 */
	public boolean updateInsChange(InsurChangeBean bean)
	{
		getConnection();
		boolean flag = true;
		String query = " update ins_change set"+
						" CH_DT=replace(?, '-', ''), CH_ITEM=?, CH_BEFORE=?, CH_AFTER=?, CH_AMT=?,"+
						" UPDATE_ID=?, UPDATE_DT=to_char(sysdate,'YYYYMMDD')"+
						" where CAR_MNG_ID=? and INS_ST=? and CH_TM=? ";

		PreparedStatement pstmt = null;
		try 
		{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, bean.getCh_dt());
			pstmt.setString(2, bean.getCh_item());
			pstmt.setString(3, bean.getCh_before());
			pstmt.setString(4, bean.getCh_after());
			pstmt.setInt(5, bean.getCh_amt());
			pstmt.setString(6, bean.getUpdate_id());
			pstmt.setString(7, bean.getCar_mng_id());
			pstmt.setString(8, bean.getIns_st());
			pstmt.setString(9, bean.getCh_tm());
		    pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
				
	  	} catch (Exception e) {
			System.out.println("[AddInsurDatabase:updateInsChange]"+ e);
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
	 *	중도해지 -> 보험료스케줄 삭제 : cancel_u_a.jsp
	 */
	public boolean dropInsChange(String c_id, String ins_st, String ch_tm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query =  " delete from ins_change"+
						" where car_mng_id = ? and ins_st = ? and ch_tm = ?";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, c_id);
			pstmt.setString(2, ins_st);
			pstmt.setString(3, ch_tm);
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddInsurDatabase:dropInsChange]"+ e);
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

}
