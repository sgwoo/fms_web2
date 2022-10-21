package acar.insur;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.account.*;
import acar.beans.AttachedFile;
import acar.common.*;
import acar.util.*;
import acar.mng_exp.*;
import acar.cont.*;

import org.json.simple.JSONObject;
import org.json.simple.JSONArray;

public class InsDatabase
{
	private Connection conn = null;
	public static InsDatabase db;
	
	public static InsDatabase getInstance()
	{
		if(InsDatabase.db == null)
			InsDatabase.db = new InsDatabase();
		return InsDatabase.db;
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


	//보험료관리 리스트
	public Vector getInsScdList(String br_id, String gubun0, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String gubun7, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String est_dt = "e.r_ins_est_dt";

		query = " select /*+  merge(b) */ a.car_mng_id, a.ins_st, a.ins_sts, b.rent_mng_id, b.rent_l_cd, b.client_id,  b.firm_nm,"+
				"        c.car_no, c.first_car_no, c.car_nm, cn.car_name, b.use_yn,"+
				"        a.ins_com_id, d.ins_com_nm, e.ins_tm, e.pay_amt,"+
				"        decode(e.pay_yn, '1','지출', '미지출' ) pay_yn,"+
				"        decode(e.ins_tm2, '1','추가보험료', '2','해지보험료', '당초납입보험료') ins_tm2,"+
				"        decode(e.ins_tm, '1', decode(e.ins_st,'0','신규','갱신'), '분납') ins_tm3,"+
				"        DECODE(a.ins_start_dt,'','',SUBSTR(a.ins_start_dt,1,4)||'-'||SUBSTR(a.ins_start_dt,5,2)||'-'||SUBSTR(a.ins_start_dt,7,2)) as ins_start_dt,"+
				"        DECODE(a.ins_exp_dt,'','',SUBSTR(a.ins_exp_dt,1,4)||'-'||SUBSTR(a.ins_exp_dt,5,2)||'-'||SUBSTR(a.ins_exp_dt,7,2)) as ins_exp_dt,"+
				"        DECODE(e.ins_est_dt,'','',SUBSTR(e.ins_est_dt,1,4)||'-'||SUBSTR(e.ins_est_dt,5,2)||'-'||SUBSTR(e.ins_est_dt,7,2)) as ins_est_dt,"+
				"        DECODE(e.pay_dt,'','',SUBSTR(e.pay_dt,1,4)||'-'||SUBSTR(e.pay_dt,5,2)||'-'||SUBSTR(e.pay_dt,7,2)) as pay_dt"+
				" from   insur a, cont_n_view b, ins_com d, scd_ins e,  car_reg c,  car_etc g, car_nm cn , \n"+
				"        (select max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) f"+
				" where a.car_mng_id=e.car_mng_id and a.ins_st=e.ins_st"+
				"        and a.ins_com_id=d.ins_com_id"+
				"        and a.car_mng_id=b.car_mng_id"+
				"        and b.rent_l_cd=f.rent_l_cd \n"+
				"	and a.car_mng_id = c.car_mng_id(+)  and b.rent_mng_id = g.rent_mng_id(+)  and b.rent_l_cd = g.rent_l_cd(+)  \n"+
                       		"	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+) ";


		/*상세조회&&세부조회*/

		//당월-계획
		if(gubun2.equals("1") && gubun6.equals("1")){		query += " and "+est_dt+" like to_char(sysdate,'YYYYMM')||'%'";
		//당월-수금
		}else if(gubun2.equals("1") && gubun6.equals("2")){	query += " and "+est_dt+" like to_char(sysdate,'YYYYMM')||'%' and nvl(e.pay_yn,'0')='1'";
		//당월-미수금
		}else if(gubun2.equals("1") && gubun6.equals("3")){	query += " and "+est_dt+" like to_char(sysdate,'YYYYMM')||'%' and nvl(e.pay_yn,'0')='0'";
		//당일-계획
		}else if(gubun2.equals("2") && gubun6.equals("1")){	query += " and "+est_dt+" = to_char(sysdate,'YYYYMMDD')";
		//당일-수금
		}else if(gubun2.equals("2") && gubun6.equals("2")){	query += " and "+est_dt+" = to_char(sysdate,'YYYYMMDD') and e.pay_dt = to_char(sysdate,'YYYYMMDD')";
		//당일-미수금
		}else if(gubun2.equals("2") && gubun6.equals("3")){	query += " and "+est_dt+" = to_char(sysdate,'YYYYMMDD') and nvl(e.pay_yn,'0')='0'";
		//당일+연체-계획
		}else if(gubun2.equals("6") && gubun6.equals("1")){	query += " and "+est_dt+" <= to_char(sysdate,'YYYYMMDD') and (nvl(e.pay_yn,'0')='0' or e.pay_dt = to_char(sysdate,'YYYYMMDD'))";
		//당일+연체-수금
		}else if(gubun2.equals("6") && gubun6.equals("2")){	query += " and "+est_dt+" <= to_char(sysdate,'YYYYMMDD') and e.pay_dt = to_char(sysdate,'YYYYMMDD')";
		//당일+연체-미수금
		}else if(gubun2.equals("6") && gubun6.equals("3")){	query += " and "+est_dt+" <= to_char(sysdate,'YYYYMMDD') and nvl(e.pay_yn,'0')='0'";
		//기간-계획
		}else if(gubun2.equals("4") && gubun6.equals("1")){	query += " and "+est_dt+" BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		//기간-수금
		}else if(gubun2.equals("4") && gubun6.equals("2")){	query += " and "+est_dt+" BETWEEN '"+st_dt+"' AND '"+end_dt+"' and nvl(e.pay_yn,'0')='1'";
		//기간-미수금
		}else if(gubun2.equals("4") && gubun6.equals("3")){	query += " and "+est_dt+" BETWEEN '"+st_dt+"' AND '"+end_dt+"' and nvl(e.pay_yn,'0')='0'";
		//검색-수금
		}else if(gubun2.equals("5") && gubun6.equals("2")){	query += " and nvl(e.pay_yn,'0')='1'";
		//검색-미수금
		}else if(gubun2.equals("5") && gubun6.equals("3")){	query += " and nvl(e.pay_yn,'0')='0'";
		}

		if(!brch_id.equals(""))		query += " and nvl(b.brch_id, '')='"+br_id+"'";
		
		if(gubun0.equals("1"))							query += " and a.car_use='1'";
		if(gubun0.equals("2"))							query += " and a.car_use<>'1'";

		if(!gubun3.equals(""))							query += " and nvl(e.ins_tm2,'0') = '"+gubun3+"'";

		if(gubun4.equals("1"))							query += " and e.ins_tm='1' and e.ins_st='0'";
		if(gubun4.equals("2"))							query += " and e.ins_tm='1' and e.ins_st>'0'";
		if(gubun4.equals("3"))							query += " and e.ins_tm>'1'";

		if(!gubun5.equals(""))							query += " and nvl(a.ins_kd,'1') ='"+gubun5+"'";

		if(!gubun7.equals(""))		query += " and a.ins_com_id='"+gubun4+"'";
		
		/*검색조건*/		
		if(s_kd.equals("1"))		query += " and nvl(b.firm_nm, '') like '%"+t_wd+"%'\n";			
		else if(s_kd.equals("4"))	query += " and upper(b.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("2"))	query += " and (nvl(c.car_no, '') like '%"+t_wd+"%' or nvl(c.first_car_no, '') like '%"+t_wd+"%')\n";
		else if(s_kd.equals("3"))	query += " and upper(c.car_num) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("5"))	query += " and c.car_nm||cn.car_name like '%"+t_wd+"%'\n";

		/*정렬조건*/
		if(sort.equals("1"))		query += " order by b.use_yn desc, e.ins_est_dt "+asc+"";
		else if(sort.equals("2"))	query += " order by b.use_yn desc, b.firm_nm "+asc+" ";
		else if(sort.equals("3"))	query += " order by b.use_yn desc, c.car_no "+asc+"";		
		else if(sort.equals("4"))	query += " order by b.use_yn desc, c.car_nm||cn.car_name "+asc+"";
		else if(sort.equals("5"))	query += " order by b.use_yn desc, a.ins_com_id "+asc+"";
		
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
			System.out.println("[InsDatabase:getInsScdList]"+ e);
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

	//보험료관리 리스트2
	public Vector getInsScdList(String br_id, String gubun0, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String gubun7, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc, String s_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String est_dt = "e.r_ins_est_dt";

		query = " select /*+  merge(b) */ a.car_mng_id, a.ins_st, a.ins_sts, b.rent_mng_id, b.rent_l_cd, b.client_id, b.firm_nm,"+
				"        c.car_no, c.first_car_no, c.car_nm, cn.car_name, b.use_yn,"+
				"        a.ins_com_id, d.ins_com_nm, e.ins_tm, e.pay_amt,"+
				"        decode(e.pay_yn, '1','지출', '미지출' ) pay_yn,"+
				"        decode(e.ins_tm2, '1','추가보험료', '2','해지보험료', '당초납입보험료') ins_tm2,"+
				"        decode(e.ins_tm, '1', decode(e.ins_st,'0','신규','갱신'), '분납') ins_tm3,"+
				"        DECODE(a.ins_start_dt,'','',SUBSTR(a.ins_start_dt,1,4)||'-'||SUBSTR(a.ins_start_dt,5,2)||'-'||SUBSTR(a.ins_start_dt,7,2)) as ins_start_dt,"+
				"        DECODE(a.ins_exp_dt,'','',SUBSTR(a.ins_exp_dt,1,4)||'-'||SUBSTR(a.ins_exp_dt,5,2)||'-'||SUBSTR(a.ins_exp_dt,7,2)) as ins_exp_dt,"+
				"        DECODE(e.ins_est_dt,'','',SUBSTR(e.ins_est_dt,1,4)||'-'||SUBSTR(e.ins_est_dt,5,2)||'-'||SUBSTR(e.ins_est_dt,7,2)) as ins_est_dt,"+
				"        DECODE(e.pay_dt,'','',SUBSTR(e.pay_dt,1,4)||'-'||SUBSTR(e.pay_dt,5,2)||'-'||SUBSTR(e.pay_dt,7,2)) as pay_dt"+
				" from insur a, cont_n_view b, ins_com d, scd_ins e, car_reg c,  car_etc g, car_nm cn , \n"+
				"        (select max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) f"+
				" where a.car_mng_id=e.car_mng_id and a.ins_st=e.ins_st"+
				"        and a.ins_com_id=d.ins_com_id"+
				"        and a.car_mng_id=b.car_mng_id"+
				"        and b.rent_l_cd=f.rent_l_cd \n"+
				"	and a.car_mng_id = c.car_mng_id  and b.rent_mng_id = g.rent_mng_id(+)  and b.rent_l_cd = g.rent_l_cd(+)  \n"+
                       		"	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+) ";

		if(s_st.equals("1")){

			if(gubun1.equals("1"))		query += " and a.car_use='1'"; 
			if(gubun1.equals("2"))		query += " and a.car_use<>'1'";

			if(gubun2.equals("1"))		query += " and e.r_ins_est_dt = to_char(sysdate,'YYYYMMDD')";
			else if(gubun2.equals("2"))	query += " and e.r_ins_est_dt like to_char(sysdate,'YYYYMM')||'%'";
			else if(gubun2.equals("3"))	query += " and e.r_ins_est_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
			else if(gubun2.equals("4"))	query += " and e.r_ins_est_dt like '"+AddUtil.getDate(1)+"%'";
			else if(gubun2.equals("5"))	query += " and e.r_ins_est_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

			if(!brch_id.equals("S1") && !brch_id.equals(""))		query += " and b.brch_id = '"+brch_id+"'"; 
			if(brch_id.equals("S1"))								query += " and b.brch_id in ('S1','K1')"; 

		}else if(s_st.equals("2")){

			if(gubun3.equals("0"))			query += " and nvl(e.pay_yn,'0')='0'";
			else if(gubun3.equals("1"))		query += " and nvl(e.pay_yn,'0')='1'";
			else if(gubun3.equals("2"))		query += " and nvl(e.pay_yn,'0')='0' and e.ins_est_dt < to_char(sysdate,'YYYYMMDD')";

			if(!gubun4.equals(""))	query += " and nvl(e.ins_tm2,'0')='"+gubun4+"'";

		}else{

			if(!t_wd.equals("")){
				if(s_kd.equals("1"))		query += " and nvl(b.firm_nm, '') like '%"+t_wd+"%'\n";			
				else if(s_kd.equals("4"))	query += " and upper(b.rent_l_cd) like upper('%"+t_wd+"%')\n";
				else if(s_kd.equals("2"))	query += " and (nvl(c.car_no, '') like '%"+t_wd+"%' or nvl(c.first_car_no, '') like '%"+t_wd+"%')\n";
				else if(s_kd.equals("3"))	query += " and upper(c.car_num) like upper('%"+t_wd+"%')\n";
				else if(s_kd.equals("5"))	query += " and c.car_nm||cn.car_name like '%"+t_wd+"%'\n";
				else if(s_kd.equals("6"))	query += " and d.ins_com_nm like '%"+t_wd+"%'\n";
			}

		}

		if(sort.equals("1"))		query += " order by e.ins_est_dt "+asc+"";
		else if(sort.equals("2"))	query += " order by b.firm_nm "+asc+"";
		else if(sort.equals("3"))	query += " order by c.car_no "+asc+"";		
		else if(sort.equals("4"))	query += " order by c.car_nm||cn.car_name "+asc+"";
		else if(sort.equals("5"))	query += " order by a.ins_com_nm "+asc+"";		

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
			System.out.println("[InsDatabase:getInsScdList]"+ e);
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
						"        (decode(a.air_ds_yn,'Y',1,0)+decode(a.air_as_yn,'Y',1,0)) as air,"+
						"        decode(a.age_scp,'1','21세이상','2','26세이상','3','모든운전자','4','24세이상','5','30세이상','6','35세이상','7','43세이상','8','48세이상',,'9','22세이상','10','28세이상이상','11','35세이상~49세이하') as age_scp,"+
						"        a.ins_com_id, d.ins_com_nm, e.ins_tm, e.pay_amt, e.pay_yn,"+
						"        DECODE(a.ins_start_dt,'','',SUBSTR(a.ins_start_dt,1,4)||'-'||SUBSTR(a.ins_start_dt,5,2)||'-'||SUBSTR(a.ins_start_dt,7,2)) as ins_start_dt,"+
						"        DECODE(a.ins_exp_dt,'','',SUBSTR(a.ins_exp_dt,1,4)||'-'||SUBSTR(a.ins_exp_dt,5,2)||'-'||SUBSTR(a.ins_exp_dt,7,2)) as ins_exp_dt,"+
						"        DECODE(e.ins_est_dt,'','',SUBSTR(e.ins_est_dt,1,4)||'-'||SUBSTR(e.ins_est_dt,5,2)||'-'||SUBSTR(e.ins_est_dt,7,2)) as ins_est_dt,"+
						"        DECODE(e.pay_dt,'','',SUBSTR(e.pay_dt,1,4)||'-'||SUBSTR(e.pay_dt,5,2)||'-'||SUBSTR(e.pay_dt,7,2)) as pay_dt"+
						" from   insur a, cont_n_view b, ins_com d, scd_ins e, car_reg c \n"+
						" where  a.car_mng_id=e.car_mng_id and a.ins_st=e.ins_st \n"+
						"        and a.ins_com_id=d.ins_com_id"+
						"        and a.car_mng_id=b.car_mng_id and a.car_mng_id = c.car_mng_id(+) ";

		//만료된 보험 갱신 대상 리스트(스케줄 내용 필요없다)
		}else{							
			sub_query = " select /*+  merge(b) */ a.car_mng_id, a.ins_st, b.rent_mng_id, b.rent_l_cd, b.client_id, b.firm_nm, c.car_no, c.car_nm, b.use_yn,"+
						"        (decode(a.air_ds_yn,'Y',1,0)+decode(a.air_as_yn,'Y',1,0)) as air,"+
						"        decode(a.age_scp,'1','21세이상','2','26세이상','3','모든운전자','4','24세이상','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하') as age_scp,"+
						"        a.ins_com_id, d.ins_com_nm, '' as ins_tm, 0 as pay_amt, '' as pay_yn, '' as ins_est_dt, '' as pay_dt,"+
						"        DECODE(a.ins_start_dt,'','',SUBSTR(a.ins_start_dt,1,4)||'-'||SUBSTR(a.ins_start_dt,5,2)||'-'||SUBSTR(a.ins_start_dt,7,2)) as ins_start_dt,"+
						"        DECODE(a.ins_exp_dt,'','',SUBSTR(a.ins_exp_dt,1,4)||'-'||SUBSTR(a.ins_exp_dt,5,2)||'-'||SUBSTR(a.ins_exp_dt,7,2)) as ins_exp_dt"+
						" from   insur a, cont_n_view b, ins_com d, car_reg c, "+
						"        (select car_mng_id, max(TO_NUMBER(ins_st)) ins_st from insur group by car_mng_id) e \n"+
						" where  a.car_mng_id=e.car_mng_id and a.ins_st=e.ins_st"+
						"        and a.ins_com_id=d.ins_com_id"+
						"        and a.car_mng_id=b.car_mng_id and a.car_mng_id = c.car_mng_id(+) ";

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
		else if(s_kd.equals("4"))	sub_query += " and nvl(c.car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	sub_query += " and upper(b.brch_id) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("9"))	sub_query += " and nvl(c.car_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("10"))	sub_query += " and nvl(a.ins_start_dt, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("11"))	sub_query += " and nvl(a.ins_exp_dt, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("12"))	sub_query += " and nvl(e.pay_dt, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("13"))	sub_query += " and nvl(e.ins_tm, '') like '%"+t_wd+"%'\n";

		String query = "";
		query = " select '계획' gubun, 'N' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+
					" ( select count(*) tot_su1, nvl(sum(pay_amt),0) tot_amt1 from ("+sub_query+") where substr(ins_est_dt,1,7) = to_char(SYSDATE, 'YYYY-MM') ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(pay_amt),0) tot_amt2 from ("+sub_query+") where ins_est_dt = to_char(SYSDATE, 'YYYY-MM-DD') ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(pay_amt),0) tot_amt3 from ("+sub_query+") where ins_est_dt < to_char(SYSDATE, 'YYYY-MM-DD') and (pay_dt is null or pay_dt = to_char(SYSDATE, 'YYYY-MM-DD')) ) c\n"+
				" union all\n"+
				" select '지출' gubun, 'N' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(pay_amt),0) tot_amt1 from ("+sub_query+") where substr(ins_est_dt,1,7) = to_char(SYSDATE, 'YYYY-MM') and pay_dt is not null) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(pay_amt),0) tot_amt2 from ("+sub_query+") where ins_est_dt = to_char(SYSDATE, 'YYYY-MM-DD') and pay_dt = to_char(SYSDATE, 'YYYY-MM-DD') ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(pay_amt),0) tot_amt3 from ("+sub_query+") where ins_est_dt < to_char(SYSDATE, 'YYYY-MM-DD') and pay_dt = to_char(SYSDATE, 'YYYY-MM-DD') ) c\n"+
				" union all\n"+
				" select '미지출' gubun, 'N' gubun_sub, a.*, b.*, c.*\n"+
				" from \n"+
					" ( select count(*) tot_su1, nvl(sum(pay_amt),0) tot_amt1 from ("+sub_query+") where substr(ins_est_dt,1,7) = to_char(SYSDATE, 'YYYY-MM') and pay_dt is null ) a,\n"+
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
			System.out.println("[InsDatabase:getInsPayStat]"+ e);
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
	public Vector getInsList(String br_id, String gubun0, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		if(gubun2.equals("4")){

			query = " select /*+  merge(c) */ a.car_mng_id, c.rent_mng_id, c.rent_l_cd, c.firm_nm, c.use_yn,\n"+
					"        cr.car_no, cr.car_nm, cn.car_name,\n"+
					"        f.ins_com_nm, a.ins_st, a.ins_start_dt, a.ins_exp_dt, a.ins_con_no,\n"+ 
					"        (decode(a.air_ds_yn,'Y',1,0)+decode(a.air_as_yn,'Y',1,0)) as air,\n"+
					"        decode(a.age_scp,'1','21세이상','2','26세이상','3','모든운전자','4','24세이상','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하') as age_scp,\n"+
					"        decode(a.ins_kd,'2','책임보험', '종합보험') as ins_kd,\n"+
					"        decode(a.ins_sts,'1','유효', '2','만료', '3','중도해지','5','승계') as ins_sts\n"+
					" from   insur a, (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) b, cont_n_view c,  car_reg cr,  car_etc ce, car_nm cn , \n"+
					"        ins_com f, ins_change g\n"+
					" where\n"+
					"        b.car_mng_id=a.car_mng_id(+)\n"+
					"        and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd\n"+
					"	and a.car_mng_id = cr.car_mng_id(+)  and c.rent_mng_id = ce.rent_mng_id(+)  and c.rent_l_cd = ce.rent_l_cd(+)  \n"+
                       			"	and ce.car_id=cn.car_id(+)  and    ce.car_seq=cn.car_seq(+)  \n"+
					"        and a.ins_com_id=f.ins_com_id\n"+
					"        and a.car_mng_id=g.car_mng_id and a.ins_st=g.ins_st";

			if(!st_dt.equals("") && gubun2.equals("3"))		query += " and a.ch_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";

		}else{

			query = " select /*+  merge(c) */ a.car_mng_id, c.rent_mng_id, c.rent_l_cd,  c.firm_nm, c.use_yn,\n"+
					" cr.car_no, cr.car_nm, cn.car_name,\n"+
					" f.ins_com_nm, a.ins_st, a.ins_start_dt, a.ins_exp_dt, a.ins_con_no,\n"+ 
					" (decode(a.air_ds_yn,'Y',1,0)+decode(a.air_as_yn,'Y',1,0)) as air,\n"+
					" decode(a.age_scp,'1','21세이상','2','26세이상','3','모든운전자','4','24세이상','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하') as age_scp,\n"+
					" decode(a.ins_kd,'2','책임보험', '종합보험') as ins_kd,\n"+
					" decode(a.ins_sts,'1','유효', '2','만료', '3','중도해지','5','승계') as ins_sts\n"+
					" from insur a, (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) b, cont_n_view c, car_reg cr,  car_etc g, car_nm cn, \n"+
					" ins_com f\n"+
					" where\n"+
					" b.car_mng_id=a.car_mng_id(+)\n"+
					" and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd\n"+
					"	and a.car_mng_id = cr.car_mng_id(+)  and c.rent_mng_id = g.rent_mng_id(+)  and c.rent_l_cd = g.rent_l_cd(+)  \n"+
                       			"	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+)   \n"+
					" and a.ins_com_id=f.ins_com_id";

			if(!st_dt.equals("") && gubun2.equals("1"))		query += " and a.ins_start_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
			if(!st_dt.equals("") && gubun2.equals("2"))		query += " and a.ins_exp_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
			if(!st_dt.equals("") && gubun2.equals("3"))		query += " and a.exp_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";

		}

		if(gubun0.equals("1"))							query += " and a.car_use='1'";
		if(gubun0.equals("2"))							query += " and a.car_use<>'1'";

		if(gubun3.equals("1")){
			query += " and a.ins_st = '0'";
			if(!gubun4.equals(""))						query += " and nvl(a.reg_cau,'1') ='"+gubun4+"'";
		}else if(gubun3.equals("2")){
			query += " and a.ins_st > '0'";
			if(!gubun4.equals(""))						query += " and nvl(a.reg_cau,'1') ='"+gubun4+"'";
		}else if(gubun3.equals("3")){
			query += " and a.ins_sts = '3'";
			if(!gubun4.equals(""))						query += " and nvl(a.exp_st,'1') ='"+gubun4+"'";
		}else if(gubun3.equals("4")){
			query += " and a.car_mng_id = ''";
		}

		if(gubun5.equals("1"))							query += " and nvl(a.ins_kd,'1') ='"+gubun5+"'";
		if(gubun5.equals("2"))							query += " and nvl(a.ins_kd,'1') ='"+gubun5+"'";

		if(!gubun6.equals(""))							query += " and nvl(a.ins_sts,'1') ='"+gubun6+"'";

		if(!br_id.equals("S1") && !br_id.equals(""))	query += " and nvl(c.brch_id, '')='"+br_id+"'";
			
		if(!t_wd.equals("")){
			if(s_kd.equals("1"))			query += " and nvl(c.firm_nm,c.client_nm) like '%"+t_wd+"%'\n";			
			else if(s_kd.equals("4"))		query += " and upper(c.rent_l_cd) like upper('%"+t_wd+"%')\n";
			else if(s_kd.equals("2"))		query += " and (cr.car_no like '%"+t_wd+"%' or c.first_car_no like '%"+t_wd+"%')\n";
			else if(s_kd.equals("3"))		query += " and upper(cr.car_num) like upper('%"+t_wd+"%')\n";
			else if(s_kd.equals("5"))		query += " and cr.car_nm||cn.car_name like '%"+t_wd+"%'\n";
			else if(s_kd.equals("6"))		query += " and f.ins_com_nm like '%"+t_wd+"%'\n";
		}

		if(asc.equals("0") || asc.equals("") ) asc = "asc";
		if(asc.equals("1")) asc = "desc";

		if(sort.equals("1"))		query += " order by c.use_yn desc, a.ins_start_dt "+asc;
		else if(sort.equals("6"))	query += " order by c.use_yn desc, a.ins_exp_dt "+asc;
		else if(sort.equals("2"))	query += " order by c.use_yn desc, nvl(c.firm_nm,c.client_nm) "+asc;
		else if(sort.equals("3"))	query += " order by c.use_yn desc, cr.car_no "+asc;
		else if(sort.equals("4"))	query += " order by c.use_yn desc, cr.car_nm||cn.car_name "+asc;
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
			System.out.println("[InsDatabase:getInsList]"+ e);
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
	public Vector getInsList(String br_id, String gubun0, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc, String s_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select /*+  merge(c) */ a.car_mng_id, c.rent_mng_id, c.rent_l_cd, c.firm_nm, c.use_yn,\n"+
				" cr.car_no, cr.car_nm, cn.car_name,\n"+
				" f.ins_com_nm, a.ins_st, a.ins_start_dt, a.ins_exp_dt,\n"+ 
				" (decode(a.air_ds_yn,'Y',1,0)+decode(a.air_as_yn,'Y',1,0)) as air,\n"+
				" decode(a.age_scp,'1','21세이상','2','26세이상','3','모든운전자','4','24세이상','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하') as age_scp,\n"+
				" decode(a.ins_kd,'2','책임보험', '종합보험') as ins_kd,\n"+
				" decode(a.ins_sts,'1','유효', '2','만료', '3','중도해지','5','승계') as ins_sts, '' ch_dt\n"+
				" from insur a, (select car_mng_id, max(rent_dt) rent_dt from cont where rent_l_cd not like 'RM%' group by car_mng_id) b, cont_n_view c, car_reg cr,  car_etc ce, car_nm cn, \n"+
				" ins_com f, ins_cls g\n"+
				" where\n"+
				" b.car_mng_id=a.car_mng_id(+)\n"+
				" and b.car_mng_id=c.car_mng_id and b.rent_dt=replace(c.rent_dt, '-', '')\n"+
				" and a.ins_com_id=f.ins_com_id"+
				"	and a.car_mng_id = cr.car_mng_id(+)  and c.rent_mng_id = ce.rent_mng_id(+)  and c.rent_l_cd = ce.rent_l_cd(+)  \n"+
                       		"	and ce.car_id=cn.car_id(+)  and    ce.car_seq=cn.car_seq(+) \n"+
				" and a.car_mng_id=g.car_mng_id(+) and a.ins_st=g.ins_st(+)";

		if(s_st.equals("1")){

			if(gubun1.equals("1"))		query += " and a.car_use='1'"; 
			if(gubun1.equals("2"))		query += " and a.car_use<>'1'";

			if(gubun2.equals("1"))		query += " and a.ins_start_dt = to_char(sysdate,'YYYYMMDD')";
			else if(gubun2.equals("2"))	query += " and a.ins_start_dt like to_char(sysdate,'YYYYMM')||'%'";
			else if(gubun2.equals("3"))	query += " and a.ins_start_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
			else if(gubun2.equals("4"))	query += " and a.ins_start_dt like '"+AddUtil.getDate(1)+"%'";
			else if(gubun2.equals("5"))	query += " and a.ins_start_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

			if(!brch_id.equals("S1") && !brch_id.equals(""))		query += " and c.brch_id = '"+brch_id+"'"; 
			if(brch_id.equals("S1"))								query += " and c.brch_id in ('S1','K1')"; 

		}else if(s_st.equals("2")){

			if(gubun3.equals("1")){
				query += " and a.ins_st = '0'";
				if(!gubun4.equals(""))						query += " and nvl(a.reg_cau,'1') ='"+gubun4+"'";
			}else if(gubun3.equals("2")){
				query += " and a.ins_st > '0'";
				if(!gubun4.equals(""))						query += " and nvl(a.reg_cau,'1') ='"+gubun4+"'";
			}else if(gubun3.equals("3")){
				query += " and a.ins_sts = '3'";
				if(!gubun4.equals(""))						query += " and nvl(g.exp_aim,'1') ='"+gubun4+"'";
			}else if(gubun3.equals("4")){
				query = " select /*+  merge(c) */ a.car_mng_id, c.rent_mng_id, c.rent_l_cd, c.firm_nm, c.use_yn,\n"+
						" cr.car_no, cr.car_nm, cn.car_name,\n"+
						" f.ins_com_nm, a.ins_st, a.ins_start_dt, a.ins_exp_dt,\n"+ 
						" (decode(a.air_ds_yn,'Y',1,0)+decode(a.air_as_yn,'Y',1,0)) as air,\n"+
						" decode(a.age_scp,'1','21세이상','2','26세이상','3','모든운전자','4','24세이상','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하') as age_scp,\n"+
						" decode(a.ins_kd,'2','책임보험', '종합보험') as ins_kd,\n"+
						" decode(a.ins_sts,'1','유효', '2','만료', '3','중도해지','5','승계') as ins_sts, g.ch_dt\n"+
						" from insur a, (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) b, cont_n_view c, car_reg cr,  car_etc ce, car_nm cn, \n"+
						" ins_com f, ins_change g\n"+
						" where\n"+
						" b.car_mng_id=a.car_mng_id(+)\n"+
						" and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd\n"+
						"	and a.car_mng_id = cr.car_mng_id(+)  and c.rent_mng_id = ce.rent_mng_id(+)  and c.rent_l_cd = ce.rent_l_cd(+)  \n"+
                       				"	and ce.car_id=cn.car_id(+)  and    ce.car_seq=cn.car_seq(+) \n"+
						" and a.ins_com_id=f.ins_com_id\n"+
						" and a.car_mng_id=g.car_mng_id and a.ins_st=g.ins_st";
			}else if(gubun3.equals("5")){
				query += " and a.car_mng_id = ''";			
			}

			if(!gubun5.equals(""))							query += " and nvl(a.ins_kd,'1') ='"+gubun5+"'";

			if(!gubun6.equals(""))							query += " and nvl(a.ins_sts,'1') ='"+gubun6+"'";

		}else{

			if(!t_wd.equals("")){
				if(s_kd.equals("1"))			query += " and nvl(c.firm_nm,c.client_nm) like '%"+t_wd+"%'\n";			
				else if(s_kd.equals("4"))		query += " and upper(c.rent_l_cd) like upper('%"+t_wd+"%')\n";
				else if(s_kd.equals("2"))		query += " and (cr.car_no like '%"+t_wd+"%' or cr.first_car_no like '%"+t_wd+"%')\n";
				else if(s_kd.equals("3"))		query += " and upper(cr.car_num) like upper('%"+t_wd+"%')\n";
				else if(s_kd.equals("5"))		query += " and cr.car_nm||cn.car_name like '%"+t_wd+"%'\n";
				else if(s_kd.equals("6"))		query += " and f.ins_com_nm like '%"+t_wd+"%'\n";
			}

		}

		if(sort.equals("1"))		query += " order by a.ins_start_dt "+asc;
		else if(sort.equals("6"))	query += " order by a.ins_exp_dt "+asc;
		else if(sort.equals("2"))	query += " order by nvl(c.firm_nm,c.client_nm) "+asc;
		else if(sort.equals("3"))	query += " order by cr.car_no "+asc;
		else if(sort.equals("4"))	query += " order by cr.car_nm||cn.car_name "+asc;
		else if(sort.equals("5"))	query += " order by f.ins_com_nm "+asc;

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
			
			System.out.println("[InsDatabase:getInsList]"+ e);
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

	//보험관리 리스트 조회 - 차량구분(렌트,리스) 없음
	public Hashtable getInsStat(String br_id, String gubun)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
        String query = "";
		String sub_query = "";

		if(gubun.equals("1")){
			query = " select su1, su2, su3, su4, (su1+su2+su3+su4) tot_su from"+
					" (select count(0) su1 from insur where ins_start_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%' and ins_st='0') a,"+
					" (select count(0) su2 from insur where ins_start_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%' and ins_st>'0') b,"+
					" (select count(0) su3 from ins_change where ch_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%') c,"+
					" (select count(0) su4 from insur where exp_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%') d";
		}else if(gubun.equals("2")){
			query = " select su1, su2, su3, su4, (su1+su2+su3+su4) tot_su from"+
					" (select count(0) su1 from insur where ins_start_dt like to_char(sysdate,'YYYYMM')||'%' and ins_st='0') a,"+
					" (select count(0) su2 from insur where ins_start_dt like to_char(sysdate,'YYYYMM')||'%' and ins_st>'0') b,"+
					" (select count(0) su3 from ins_change where ch_dt like to_char(sysdate,'YYYYMM')||'%') c,"+
					" (select count(0) su4 from insur where exp_dt like to_char(sysdate,'YYYYMM')||'%') d";
		}else{
			query = " select su1, su2, su3, su4, (su1+su2+su3+su4) tot_su from"+
					" (select count(0) su1 from insur where ins_start_dt = to_char(sysdate,'YYYYMMDD') and ins_st='0') a,"+
					" (select count(0) su2 from insur where ins_start_dt = to_char(sysdate,'YYYYMMDD') and ins_st>'0') b,"+
					" (select count(0) su3 from ins_change where ch_dt = to_char(sysdate,'YYYYMMDD')) c,"+
					" (select count(0) su4 from insur where exp_dt = to_char(sysdate,'YYYYMMDD')) d";
		}

		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
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
			pstmt.close();

		} catch (SQLException e) {
			
			System.out.println("[InsDatabase:getInsStat]"+ e);
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

	//보험관리 리스트 조회 - 차량구분(렌트,리스) 추가
	public Hashtable getInsStat(String br_id, String gubun, String car_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
        String query = "";
		String sub_query = "";

		if(car_st.equals("1"))	sub_query += " and b.car_use='1'"; 
		if(car_st.equals("2"))	sub_query += " and b.car_use<>'1'"; 

		if(gubun.equals("1")){
			query = " select su1, su2, su3, su4, (su1+su2+su3+su4) tot_su from"+
					" (select count(0) su1 from insur a, car_reg b where a.ins_start_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%' and a.ins_st='0' and a.car_mng_id=b.car_mng_id "+sub_query+") a,"+
					" (select count(0) su2 from insur a, car_reg b where a.ins_start_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%' and a.ins_st>'0' and a.car_mng_id=b.car_mng_id "+sub_query+") b,"+
					" (select count(0) su3 from ins_change a, car_reg b where a.ch_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%' and a.car_mng_id=b.car_mng_id "+sub_query+") c,"+
					" (select count(0) su4 from insur a, car_reg b where a.exp_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%' and a.car_mng_id=b.car_mng_id "+sub_query+") d";
		}else if(gubun.equals("2")){
			query = " select su1, su2, su3, su4, (su1+su2+su3+su4) tot_su from"+
					" (select count(0) su1 from insur a, car_reg b where a.ins_start_dt like to_char(sysdate,'YYYYMM')||'%' and a.ins_st='0' and a.car_mng_id=b.car_mng_id "+sub_query+") a,"+
					" (select count(0) su2 from insur a, car_reg b where a.ins_start_dt like to_char(sysdate,'YYYYMM')||'%' and a.ins_st>'0' and a.car_mng_id=b.car_mng_id "+sub_query+") b,"+
					" (select count(0) su3 from ins_change a, car_reg b where a.ch_dt like to_char(sysdate,'YYYYMM')||'%' and a.car_mng_id=b.car_mng_id "+sub_query+") c,"+
					" (select count(0) su4 from insur a, car_reg b where a.exp_dt like to_char(sysdate,'YYYYMM')||'%' and a.car_mng_id=b.car_mng_id "+sub_query+") d";
		}else{
			query = " select su1, su2, su3, su4, (su1+su2+su3+su4) tot_su from"+
					" (select count(0) su1 from insur a, car_reg b where a.ins_start_dt = to_char(sysdate,'YYYYMMDD') and a.ins_st='0' and a.car_mng_id=b.car_mng_id "+sub_query+") a,"+
					" (select count(0) su2 from insur a, car_reg b where a.ins_start_dt = to_char(sysdate,'YYYYMMDD') and a.ins_st>'0' and a.car_mng_id=b.car_mng_id "+sub_query+") b,"+
					" (select count(0) su3 from ins_change a, car_reg b where a.ch_dt = to_char(sysdate,'YYYYMMDD') and a.car_mng_id=b.car_mng_id "+sub_query+") c,"+
					" (select count(0) su4 from insur a, car_reg b where a.exp_dt = to_char(sysdate,'YYYYMMDD') and a.car_mng_id=b.car_mng_id "+sub_query+") d";
		}

		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
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
			pstmt.close();

		} catch (SQLException e) {
			
			System.out.println("[InsDatabase:getInsStat]"+ e);
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

	//보험관리 - 보험현황- 신규
	public Vector getInsStatList_in1(String br_id, String brch_id, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select /*+  merge(c) */ a.car_mng_id, c.rent_mng_id, c.rent_l_cd, c.firm_nm, c.use_yn,\n"+
				" cr.init_reg_dt, cr.car_no, cr.car_nm, cn.car_name,\n"+
				" f.ins_com_nm, a.ins_st, a.ins_start_dt, a.ins_exp_dt,\n"+ 
				" (decode(a.air_ds_yn,'Y',1,0)+decode(a.air_as_yn,'Y',1,0)) as air,\n"+
				" decode(a.age_scp,'1','21세이상','2','26세이상','3','모든운전자','4','24세이상','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하') as age_scp,\n"+
				" decode(a.ins_kd,'2','책임보험', '종합보험') as ins_kd,\n"+
				" decode(a.ins_sts,'1','유효', '2','만료', '3','중도해지','5','승계') as ins_sts,\n"+
				" decode(a.reg_cau, '2','용도변경', '3','담보변경', '4','만기', '신차') as reg_cau,\n"+
				" decode(decode(a.car_use,'3',cr.car_use,a.car_use),'1','렌트','2','리스') car_st,"+
				" (a.rins_pcp_amt+a.vins_pcp_amt+a.vins_gcp_amt+a.vins_bacdt_amt+a.vins_canoisr_amt+a.vins_share_extra_amt+a.vins_cacdt_cm_amt+a.change_itm_amt1+a.change_itm_amt2+a.change_itm_amt2+a.change_itm_amt4) ins_amt"+//-a.vins_blackbox_amt
				" from insur a, (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) b, cont_n_view c, car_reg cr,  car_etc g, car_nm cn ,\n"+
				" ins_com f\n"+
				" where a.ins_st='0' \n"+
				" and b.car_mng_id=a.car_mng_id(+)\n"+
				" and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd\n"+
				"	and a.car_mng_id = cr.car_mng_id(+)  and b.rent_mng_id = g.rent_mng_id(+)  and b.rent_l_cd = g.rent_l_cd(+)  \n"+
                       		"	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+) \n"+
				" and a.ins_com_id=f.ins_com_id";

		if(!st_dt.equals(""))		query += " and a.ins_start_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";


		query += " order by a.ins_start_dt";

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
			
			System.out.println("[InsDatabase:getInsStatList_in1]"+ e);
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

	//보험관리 - 보험현황- 신규
	public Vector getInsStatList_in1(String br_id, String brch_id, String st_dt, String end_dt, String gubun1, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.car_mng_id, c.rent_mng_id, c.rent_l_cd, c.firm_nm, nvl(cl.enp_no, substr(TEXT_DECRYPT(cl.ssn, 'pw' ),1,7) ) enp_no, c.use_yn,\n"+
				"        cr.init_reg_dt, cr.car_no, cr.car_nm, cr.car_num, cn.car_name,\n"+
				"        f.ins_com_nm, a.ins_st, a.ins_con_no, a.ins_start_dt, a.ins_exp_dt,\n"+ 
				"        (decode(a.air_ds_yn,'Y',1,0)+decode(a.air_as_yn,'Y',1,0)) as air,\n"+
				"        decode(a.age_scp,'1','21세이상','2','26세이상','3','모든운전자','4','24세이상','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하') as age_scp,\n"+
				"        decode(a.ins_kd,'2','책임보험', '종합보험') as ins_kd,\n"+
				"        decode(a.ins_sts,'1','유효', '2','만료', '3','중도해지','5','승계') as ins_sts,\n"+
				"        decode(a.reg_cau, '2','용도변경', '3','담보변경', '4','만기', '5','오프리스', '신차') as reg_cau,\n"+
				"        decode(decode(a.car_use,'3',cr.car_use,a.car_use),'1','렌트','2','리스') car_st, g.ins_amt, c.RENT_START_DT, c.RENT_END_DT,"+
				"        r2.com_nm b_com_nm, r2.model_nm as b_model_nm, r2.serial_no as b_serial_no, r2.tint_amt as b_amt,jg_code \n"+
				" from   insur a, (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) b, cont_n_view c, car_reg cr,  car_etc ce, car_nm cn, \n"+
				"        ins_com f, (select car_mng_id, ins_st, sum(pay_amt) ins_amt from scd_ins group by car_mng_id, ins_st) g, client cl, \n"+
				"        (SELECT * FROM CAR_TINT WHERE tint_st='3' AND tint_yn='Y') r2 \n"+
				" where  a.ins_st='0' and\n"+
				"        b.car_mng_id=a.car_mng_id(+)\n"+
				"        and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd\n"+
				"	     and a.car_mng_id = cr.car_mng_id(+)  and c.rent_mng_id = ce.rent_mng_id(+)  and c.rent_l_cd = ce.rent_l_cd(+)  \n"+
                "	     and ce.car_id=cn.car_id(+)  and    ce.car_seq=cn.car_seq(+) \n"+
				"        and a.ins_com_id=f.ins_com_id"+
				"        and a.car_mng_id=g.car_mng_id and a.ins_st=g.ins_st and c.client_id = cl.client_id"+
				"        and c.rent_mng_id=r2.rent_mng_id(+) and c.rent_l_cd=r2.rent_l_cd(+) \n"+
				" ";


		if(gubun1.equals("1"))		query += " and decode(a.car_use,'3',cr.car_use,a.car_use) = '1'"; 
		if(gubun1.equals("2"))		query += " and decode(a.car_use,'3',cr.car_use,a.car_use) = '2'";

		if(gubun2.equals("1"))		query += " and a.ins_start_dt = to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("2"))	query += " and a.ins_start_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))	query += " and a.ins_start_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
		else if(gubun2.equals("4"))	query += " and a.ins_start_dt like '"+AddUtil.getDate(1)+"%'";
		else if(gubun2.equals("5"))	query += " and a.ins_start_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		if(!brch_id.equals("S1") && !brch_id.equals(""))	query += " and c.brch_id = '"+brch_id+"'"; 
		if(brch_id.equals("S1"))							query += " and c.brch_id in ('S1','K1')"; 

		query += " order by a.ins_start_dt";


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
			
			System.out.println("[InsDatabase:getInsStatList_in1]"+ e);
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

	//보험관리 - 보험현황- 갱신
	public Vector getInsStatList_in2(String br_id, String brch_id, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select /*+  merge(c) */ a.car_mng_id, c.rent_mng_id, c.rent_l_cd, c.firm_nm, c.use_yn,\n"+
				" cr.init_reg_dt, cr.car_no, cr.car_nm, cn.car_name,\n"+
				" f.ins_com_nm, a.ins_st, a.ins_start_dt, a.ins_exp_dt,\n"+ 
				" (decode(a.air_ds_yn,'Y',1,0)+decode(a.air_as_yn,'Y',1,0)) as air,\n"+
				" decode(a.age_scp,'1','21세이상','2','26세이상','3','모든운전자','4','24세이상','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하') as age_scp,\n"+
				" decode(a.ins_kd,'2','책임보험', '종합보험') as ins_kd,\n"+
				" decode(a.ins_sts,'1','유효', '2','만료', '3','중도해지','5','승계') as ins_sts,\n"+
				" decode(a.reg_cau, '2','용도변경', '3','담보변경', '4','만기', '신차') as reg_cau,\n"+
				" decode(decode(a.car_use,'3',cr.car_use,a.car_use),'1','렌트','2','리스') car_st,"+
				" (a.rins_pcp_amt+a.vins_pcp_amt+a.vins_gcp_amt+a.vins_bacdt_amt+a.vins_canoisr_amt+a.vins_share_extra_amt+a.vins_cacdt_cm_amt+a.change_itm_amt1+a.change_itm_amt2+a.change_itm_amt2+a.change_itm_amt4) ins_amt"+//-a.vins_blackbox_amt
				" from insur a, (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) b, cont_n_view c,  car_reg cr,  car_etc g, car_nm cn, \n"+
				" ins_com f\n"+
				" where a.ins_st>'0' and\n"+
				" b.car_mng_id=a.car_mng_id(+)\n"+
				" and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd\n"+
				"	and a.car_mng_id = cr.car_mng_id(+)  and c.rent_mng_id = g.rent_mng_id(+)  and c.rent_l_cd = g.rent_l_cd(+)  \n"+
                       		"	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+)   \n"+
				" and a.ins_com_id=f.ins_com_id";

		if(!st_dt.equals(""))		query += " and a.ins_start_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";

		query += " order by a.ins_start_dt";

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
			System.out.println("[InsDatabase:getInsStatList_in2]"+ e);
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

	//보험관리 - 보험현황- 갱신
	public Vector getInsStatList_in2(String br_id, String brch_id, String st_dt, String end_dt, String gubun1, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select /*+  merge(c) */ a.car_mng_id, c.rent_mng_id, c.rent_l_cd, c.firm_nm, c.use_yn,\n"+
				" cr.init_reg_dt, cr.car_no, cr.car_nm, cn.car_name,\n"+
				" f.ins_com_nm, a.ins_st, a.ins_start_dt, a.ins_exp_dt,\n"+ 
				" (decode(a.air_ds_yn,'Y',1,0)+decode(a.air_as_yn,'Y',1,0)) as air,\n"+
				" decode(a.age_scp,'1','21세이상','2','26세이상','3','모든운전자','4','24세이상','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하') as age_scp,\n"+
				" decode(a.ins_kd,'2','책임보험', '종합보험') as ins_kd,\n"+
				" decode(a.ins_sts,'1','유효', '2','만료', '3','중도해지','5','승계') as ins_sts,\n"+
				" decode(a.reg_cau, '2','용도변경', '3','담보변경', '1','신차', '5','오프리스', '만기') as reg_cau,\n"+
				" decode(decode(a.car_use,'3',cr.car_use,a.car_use),'1','렌트','2','리스') car_st, g.ins_amt, jg_code"+
				" from insur a, (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) b, cont_n_view c,  car_reg cr,  car_etc ce, car_nm cn,  \n"+
				" ins_com f, (select car_mng_id, ins_st, sum(decode(ins_tm2,'2',-pay_amt,pay_amt)) ins_amt from scd_ins group by car_mng_id, ins_st) g\n"+
				" where a.ins_st>'0'\n"+
				" and b.car_mng_id=a.car_mng_id(+)\n"+
				" and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd\n"+
				"	and a.car_mng_id = cr.car_mng_id(+)  and c.rent_mng_id = ce.rent_mng_id(+)  and c.rent_l_cd = ce.rent_l_cd(+)  \n"+
                       		"	and ce.car_id=cn.car_id(+)  and    ce.car_seq=cn.car_seq(+)   \n"+
				" and a.ins_com_id=f.ins_com_id"+
				" and a.car_mng_id=g.car_mng_id and a.ins_st=g.ins_st";

		if(gubun1.equals("1"))		query += " and a.car_use='1'"; 
		if(gubun1.equals("2"))		query += " and a.car_use<>'1'";

		if(gubun2.equals("1"))		query += " and a.ins_start_dt = to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("2"))	query += " and a.ins_start_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))	query += " and a.ins_start_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
		else if(gubun2.equals("4"))	query += " and a.ins_start_dt like '"+AddUtil.getDate(1)+"%'";
		else if(gubun2.equals("5"))	query += " and a.ins_start_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		if(!brch_id.equals("S1") && !brch_id.equals(""))	query += " and c.brch_id = '"+brch_id+"'"; 
		if(brch_id.equals("S1"))							query += " and c.brch_id in ('S1','K1')"; 

		query += " order by a.ins_start_dt";

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

//			System.out.println("[InsDatabase:getInsStatList_in2]"+ query);
		} catch (SQLException e) {
			System.out.println("[InsDatabase:getInsStatList_in2]"+ e);
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


	//보험관리 - 보험현황- 계약변경
	public Vector getInsStatList_in3(String br_id, String brch_id, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select /*+  merge(c) */ a.car_mng_id, c.rent_mng_id, c.rent_l_cd, c.firm_nm, c.use_yn,\n"+
				" cr.init_reg_dt, cr.car_no, cr.car_nm, cn.car_name,\n"+
				" f.ins_com_nm, a.ins_st, a.ins_start_dt, a.ins_exp_dt,\n"+ 
				" (decode(a.air_ds_yn,'Y',1,0)+decode(a.air_as_yn,'Y',1,0)) as air,\n"+
				" decode(a.age_scp,'1','21세이상','2','26세이상','3','모든운전자','4','24세이상','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하') as age_scp,\n"+
				" decode(a.ins_kd,'2','책임보험', '종합보험') as ins_kd,\n"+
				" decode(a.ins_sts,'1','유효', '2','만료', '3','중도해지','5','승계') as ins_sts,\n"+
				" decode(a.reg_cau, '2','용도변경', '3','담보변경', '4','만기', '신차') as reg_cau,\n"+
				" decode(decode(a.car_use,'3',cr.car_use,a.car_use),'1','렌트','2','리스') car_st,"+
				" (a.rins_pcp_amt+a.vins_pcp_amt+a.vins_gcp_amt+a.vins_bacdt_amt+a.vins_canoisr_amt+a.vins_share_extra_amt+a.vins_cacdt_cm_amt+a.change_itm_amt1+a.change_itm_amt2+a.change_itm_amt2+a.change_itm_amt4) ins_amt,"+//-a.vins_blackbox_amt
				" g.ch_dt, g.ch_amt, g.ch_after,"+
				" decode(g.ch_item, '1','대물가입금액','2','자기신체사고가입금액(사망/장애)','3','무보험차상해특약','4','자기차량손해가입금액','5','연령변경','6','애니카특약','7','대물+자기신체사고가입금액', '8','차종변경','9','자기차량손해자기부담금', '13','기타','10','대인2가입금액', '11','차량대체', '12','자기신체사고가입금액(부상)','14','임직원한전운전특약','15','피보험자변경','16','고객피보험자 보험갱신','17','블랙박스','18','견인고리') ch_item"+
				" from insur a, (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) b, cont_n_view c, car_reg cr,  car_etc ce, car_nm cn ,\n"+
				" ins_com f, ins_change g\n"+
				" where \n"+
				" b.car_mng_id=a.car_mng_id(+)\n"+
				" and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd\n"+
				"	and a.car_mng_id = cr.car_mng_id(+)  and c.rent_mng_id = ce.rent_mng_id(+)  and c.rent_l_cd = ce.rent_l_cd(+)  \n"+
                       		"	and ce.car_id=cn.car_id(+)  and    ce.car_seq=cn.car_seq(+)   \n"+
				" and a.ins_com_id=f.ins_com_id"+
				" and a.car_mng_id=g.car_mng_id and a.ins_st=g.ins_st";

		if(!st_dt.equals(""))		query += " and g.ch_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";

		query += " order by a.ch_dt";

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
			
			System.out.println("[InsDatabase:getInsStatList_in3]"+ e);
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

	//보험관리 - 보험현황- 계약변경
	public Vector getInsStatList_in3(String br_id, String brch_id, String st_dt, String end_dt, String gubun1, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select /*+  merge(c) */ a.car_mng_id, c.rent_mng_id, c.rent_l_cd, c.firm_nm, c.use_yn,\n"+
				" cr.init_reg_dt, cr.car_no, cr.car_nm, cn.car_name,\n"+
				" f.ins_com_nm, a.ins_st, a.ins_start_dt, a.ins_exp_dt,\n"+ 
				" (decode(a.air_ds_yn,'Y',1,0)+decode(a.air_as_yn,'Y',1,0)) as air,\n"+
				" decode(a.age_scp,'1','21세이상','2','26세이상','3','모든운전자','4','24세이상','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하') as age_scp,\n"+
				" decode(a.ins_kd,'2','책임보험', '종합보험') as ins_kd,\n"+
				" decode(a.ins_sts,'1','유효', '2','만료', '3','중도해지','5','승계') as ins_sts,\n"+
				" decode(a.reg_cau, '2','용도변경', '3','담보변경', '4','만기', '신차') as reg_cau,\n"+
				" decode(decode(a.car_use,'3',cr.car_use,a.car_use),'1','렌트','2','리스') car_st,"+
				" (a.rins_pcp_amt+a.vins_pcp_amt+a.vins_gcp_amt+a.vins_bacdt_amt+a.vins_canoisr_amt+a.vins_share_extra_amt+a.vins_cacdt_cm_amt+a.change_itm_amt1+a.change_itm_amt2+a.change_itm_amt2+a.change_itm_amt4) ins_amt,"+//-a.vins_blackbox_amt
				" g.ch_dt, g.ch_amt, g.ch_after, jg_code,"+
				" decode(g.ch_item, '1','대물가입금액','2','자기신체사고가입금액(사망/장애)','3','무보험차상해특약','4','자기차량손해가입금액','5','연령변경','6','애니카특약','7','대물+자기신체사고가입금액','8','차종변경','9','자기차량손해자기부담금','13','기타','10','대인2가입금액', '11','차량대체', '12','자기신체사고가입금액(부상)','14','임직원한전운전특약','15','피보험자변경','16','고객피보험자 보험갱신','17','블랙박스','18','견인고리') ch_item"+
				" from insur a, (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) b, cont_n_view c, car_reg cr,  car_etc ce, car_nm cn , \n"+
				" ins_com f, ins_change g\n"+
				" where \n"+
				" b.car_mng_id=a.car_mng_id(+)\n"+
				" and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd\n"+
				"	and a.car_mng_id = cr.car_mng_id(+)  and c.rent_mng_id = ce.rent_mng_id(+)  and c.rent_l_cd = ce.rent_l_cd(+)  \n"+
                       		"	and ce.car_id=cn.car_id(+)  and    ce.car_seq=cn.car_seq(+)  \n"+
				" and a.ins_com_id=f.ins_com_id"+
				" and a.car_mng_id=g.car_mng_id and a.ins_st=g.ins_st";

		if(gubun1.equals("1"))		query += " and a.car_use='1'"; 
		if(gubun1.equals("2"))		query += " and a.car_use<>'1'";

		if(gubun2.equals("1"))		query += " and g.ch_dt = to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("2"))	query += " and g.ch_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))	query += " and g.ch_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
		else if(gubun2.equals("4"))	query += " and g.ch_dt like '"+AddUtil.getDate(1)+"%'";
		else if(gubun2.equals("5"))	query += " and g.ch_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		if(!brch_id.equals("S1") && !brch_id.equals(""))	query += " and c.brch_id = '"+brch_id+"'"; 
		if(brch_id.equals("S1"))							query += " and c.brch_id in ('S1','K1')"; 

		query += " order by g.ch_dt";

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
			
			System.out.println("[InsDatabase:getInsStatList_in3]"+ e);
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

	//보험관리 - 보험현황- 계약변경
	public Vector getInsStatList_in4(String br_id, String brch_id, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select /*+  merge(c) */ a.car_mng_id, c.rent_mng_id, c.rent_l_cd, c.firm_nm, c.use_yn,\n"+
				" cr.init_reg_dt, cr.car_no, cr.car_nm, cn.car_name,\n"+
				" f.ins_com_nm, a.ins_st, a.ins_start_dt, a.ins_exp_dt,\n"+ 
				" (decode(a.air_ds_yn,'Y',1,0)+decode(a.air_as_yn,'Y',1,0)) as air,\n"+
				" decode(a.age_scp,'1','21세이상','2','26세이상','3','모든운전자','4','24세이상','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하') as age_scp,\n"+
				" decode(a.ins_kd,'2','책임보험', '종합보험') as ins_kd,\n"+
				" decode(a.ins_sts,'1','유효', '2','만료', '3','중도해지','5','승계') as ins_sts,\n"+
				" decode(a.reg_cau, '2','용도변경', '3','담보변경', '4','만기', '신차') as reg_cau,\n"+
				" decode(decode(a.car_use,'3',cr.car_use,a.car_use),'1','렌트','2','리스') car_st,"+
				" (a.rins_pcp_amt+a.vins_pcp_amt+a.vins_gcp_amt+a.vins_bacdt_amt+a.vins_canoisr_amt+a.vins_share_extra_amt+a.vins_cacdt_cm_amt+a.change_itm_amt1+a.change_itm_amt2+a.change_itm_amt2+a.change_itm_amt4) ins_amt,"+//-a.vins_blackbox_amt
				" decode(a.exp_st, '2','매각', '3','폐차', '용도변경') as exp_st, a.exp_dt, a.rtn_dt, a.rtn_amt\n"+
				" from insur a, (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) b, cont_n_view c,\n"+
				" ins_com f , car_reg cr,  car_etc ce, car_nm cn \n"+
				" where \n"+
				" b.car_mng_id=a.car_mng_id(+)\n"+
				" and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd\n"+
				"	and a.car_mng_id = cr.car_mng_id(+)  and c.rent_mng_id = ce.rent_mng_id(+)  and c.rent_l_cd = ce.rent_l_cd(+)  \n"+
                       		"	and ce.car_id=cn.car_id(+)  and    ce.car_seq=cn.car_seq(+) \n"+
				" and a.ins_com_id=f.ins_com_id";

		if(!st_dt.equals(""))		query += " and a.exp_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";


		query += " order by a.exp_dt";

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
			
			System.out.println("[InsDatabase:getInsStatList_in4]"+ e);
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

	//보험관리 - 보험현황- 계약해지
	public Vector getInsStatList_in4(String br_id, String brch_id, String st_dt, String end_dt, String gubun1, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select /*+  merge(c) */ a.car_mng_id, c.rent_mng_id, c.rent_l_cd, c.firm_nm, c.use_yn,\n"+
				" cr.init_reg_dt, cr.car_no, cr.car_nm, cn.car_name,\n"+
				" f.ins_com_nm, a.ins_st, a.ins_start_dt, a.ins_exp_dt, jg_code,\n"+ 
				" (decode(a.air_ds_yn,'Y',1,0)+decode(a.air_as_yn,'Y',1,0)) as air,\n"+
				" decode(a.age_scp,'1','21세이상','2','26세이상','3','모든운전자','4','24세이상','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하') as age_scp,\n"+
				" decode(a.ins_kd,'2','책임보험', '종합보험') as ins_kd,\n"+
				" decode(a.ins_sts,'1','유효', '2','만료', '3','중도해지','5','승계') as ins_sts,\n"+
				" decode(a.reg_cau, '2','용도변경', '3','담보변경', '4','만기', '신차') as reg_cau,\n"+
				" decode(decode(a.car_use,'3',cr.car_use,a.car_use),'1','렌트','2','리스') car_st,"+
				" (a.rins_pcp_amt+a.vins_pcp_amt+a.vins_gcp_amt+a.vins_bacdt_amt+a.vins_canoisr_amt+a.vins_share_extra_amt+a.vins_cacdt_cm_amt+a.change_itm_amt1+a.change_itm_amt2+a.change_itm_amt2+a.change_itm_amt4) ins_amt,"+//-a.vins_blackbox_amt
				" g.exp_st, decode(g.exp_aim, '1','재리스','2','Self', '3','매각', '4','말소','5','폐차') as exp_aim, g.exp_dt, g.req_dt, h.pay_dt as rtn_dt, ABS(h.pay_amt) as rtn_amt\n"+
				" from   insur a, (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) b, cont_n_view c, car_reg cr,  car_etc ce, car_nm cn , \n"+
				"        ins_com f, ins_cls g, (select car_mng_id, ins_st, sum(pay_amt) pay_amt, max(pay_dt) pay_dt from scd_ins where ins_tm2='2' group by car_mng_id, ins_st) h\n"+
				" where \n"+
				" b.car_mng_id=a.car_mng_id(+)\n"+
				" and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd\n"+
				"	and a.car_mng_id = cr.car_mng_id(+)  and c.rent_mng_id = ce.rent_mng_id(+)  and c.rent_l_cd = ce.rent_l_cd(+)  \n"+
                       		"	and ce.car_id=cn.car_id(+)  and    ce.car_seq=cn.car_seq(+)  \n"+
				" and a.ins_com_id=f.ins_com_id"+
				" and a.car_mng_id=g.car_mng_id and a.ins_st=g.ins_st\n"+
				" and a.car_mng_id=h.car_mng_id and a.ins_st=h.ins_st\n";

		if(gubun1.equals("1"))		query += " and a.car_use='1'"; 
		if(gubun1.equals("2"))		query += " and a.car_use<>'1'";

		String when = "g.req_dt";

		if(gubun2.equals("1"))		query += " and "+when+" = to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("2"))	query += " and "+when+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))	query += " and "+when+" like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
		else if(gubun2.equals("4"))	query += " and "+when+" like '"+AddUtil.getDate(1)+"%'";
		else if(gubun2.equals("5"))	query += " and "+when+" between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		if(!brch_id.equals("S1") && !brch_id.equals(""))	query += " and c.brch_id = '"+brch_id+"'"; 
		if(brch_id.equals("S1"))							query += " and c.brch_id in ('S1','K1')"; 

		query += " order by g.exp_dt";

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
			
			System.out.println("[InsDatabase:getInsStatList_in4]"+ e);
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
				" i.car_no, i.car_nm, cn.car_name,\n"+
				" f.ins_com_nm, a.ins_st, a.ins_start_dt, a.ins_exp_dt,\n"+ 
				" (decode(a.air_ds_yn,'Y',1,0)+decode(a.air_as_yn,'Y',1,0)) as air,\n"+
				" decode(a.age_scp,'1','21세이상','2','26세이상','3','모든운전자','4','24세이상','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하') as age_scp,\n"+
				" decode(a.ins_kd,'2','책임보험', '종합보험') as ins_kd,\n"+
				" decode(a.ins_sts,'1','유효', '2','만료', '3','중도해지','5','승계') as ins_sts\n"+
				" from insur a, (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) b, cont_n_view c,  car_etc g, car_nm cn, \n"+
				" ins_com f, car_reg i\n"+
				" where a.ins_sts='1'\n"+
				" and b.car_mng_id=a.car_mng_id(+)\n"+
				" and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd\n"+
				" and c.rent_mng_id = g.rent_mng_id(+)  and c.rent_l_cd = g.rent_l_cd(+)  \n"+
                " and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+)  \n"+
				" and a.ins_com_id=f.ins_com_id and a.car_mng_id=i.car_mng_id and nvl(i.prepare,'0')<>'4'";

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
			else if(s_kd.equals("3"))		query += " and (i.car_no like '%"+t_wd+"%' or i.first_car_no like '%"+t_wd+"%')\n";
			else if(s_kd.equals("4"))		query += " and i.car_nm||cn.car_name like '%"+t_wd+"%'\n";
			else if(s_kd.equals("5"))		query += " and upper(i.car_num) like upper('%"+t_wd+"%')\n";
		}

		if(sort.equals("1"))		query += " order by c.use_yn desc, a.ins_start_dt "+asc;
		else if(sort.equals("6"))	query += " order by c.use_yn desc, a.ins_exp_dt "+asc;
		else if(sort.equals("2"))	query += " order by c.use_yn desc, nvl(c.firm_nm,c.client_nm) "+asc;
		else if(sort.equals("3"))	query += " order by c.use_yn desc, i.car_no "+asc;
		else if(sort.equals("4"))	query += " order by c.use_yn desc, i.car_nm||cn.car_name "+asc;
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
			
			System.out.println("[InsDatabase:getInsStatList1]"+ e);
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
	public Vector getInsStatList1(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc, String s_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select /*+ use_nl(a c)  merge(c) */ "+
				" nvl(t.enp_no, nvl(TEXT_DECRYPT(t.ssn, 'pw' ),1,7) ) as enp_no,  c.rent_start_dt, c.rent_end_dt, a.car_mng_id, c.rent_mng_id, c.rent_l_cd, c.firm_nm, c.use_yn, a.con_f_nm, \n"+
				" i.car_no, i.car_nm, d.car_name, i.car_num, i.init_reg_dt, \n"+
				" f.ins_com_nm, a.ins_st, a.ins_con_no, a.ins_start_dt, a.ins_exp_dt, h.migr_dt, decode(cc.cls_st,'8',cc.cls_dt) cls_dt, \n"+ 
				" (decode(a.air_ds_yn,'Y',1,0)+decode(a.air_as_yn,'Y',1,0)) as air,\n"+
				" decode(a.auto_yn,'Y',1,0) as auto,\n"+
				" decode(a.abs_yn,'Y',1,0) as abs,\n"+
				" decode(a.blackbox_yn,'Y',1,0) as blackbox,\n"+
				" decode(a.age_scp,'1','21세이상','2','26세이상','3','모든운전자','4','24세이상','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하') as age_scp,\n"+
				" decode(a.ins_kd,'2','책임보험', '종합보험') as ins_kd,\n"+
				" decode(a.ins_sts,'1','유효', '2','만료', '3','중도해지','5','승계') as ins_sts,\n"+
				" decode(a.car_use,'1','영업용','2','업무용','3','개인용') car_use,"+
				" decode(a.vins_gcp_kd,'1','3000만원','2','1500만원','3','1억원','4','5000만원','5','1000만원','6','5억원', '7','2억원', '8','3억원','9','10억원') vins_gcp_kd,"+
				" decode(a.vins_bacdt_kd,'1','3억원','2','1억5천만원','3','3000만원','4','1500만원','5','5000만원','6','1억원') vins_bacdt_kd,"+
				" decode(a.vins_bacdt_kc2,'1','3억원','2','1억5천만원','3','3000만원','4','1500만원','5','5000만원','6','1억원') vins_bacdt_kc2,"+
				" decode(a.vins_canoisr_amt,0,'미가입','가입') vins_canoisr,"+
				" decode(a.vins_share_extra_amt,0,'미가입','가입') vins_share_extra,"+
				" decode(a.vins_cacdt_cm_amt,0,'미가입','가입') vins_cacdt,"+
				" decode(a.vins_spe_amt,0,'미가입','가입') vins_spe,"+
				" decode(a.vins_canoisr_amt,0,'N','Y') vins_canoisr2,"+
				" decode(a.vins_share_extra_amt,0,'N','Y') vins_share_extra2,"+
				" decode(a.vins_cacdt_cm_amt,0,'N','Y') vins_cacdt2,"+
				" decode(a.vins_spe_amt,0,'N','Y') vins_spe2, \n"+
			    " b.nm as car_kd, "+
				" i.taking_p, a.blackbox_nm, a.blackbox_amt, a.blackbox_no, a.blackbox_dt "+
				" from (select * from insur where (car_mng_id, ins_st) in (select car_mng_id, max(TO_NUMBER(ins_st)) ins_st from insur where ins_sts='1' group by car_mng_id)) a,  \n"+
				"      cont_n_view c, cls_cont cc,  car_etc ce, \n"+
				"      ins_com f, sui h, car_reg i, ins_cls l, car_nm d, client t, \n"+
				"      (select * from code where c_st='0041') b "+
				" where \n"+
				" a.car_mng_id=c.car_mng_id(+)\n"+
				" and decode(c.use_yn,'Y','Y','','Y',decode(cc.cls_st,'8','Y','N'))='Y'\n"+//살아있거나 매입옵션 명의이전인 차량
				" and a.ins_com_id=f.ins_com_id"+
				" and a.car_mng_id=h.car_mng_id(+) and a.car_mng_id=i.car_mng_id(+) "+
				" and nvl(i.prepare,'0')<>'4'"+ //말소차량제외
				" and a.car_mng_id=l.car_mng_id(+) and a.ins_st=l.ins_st(+) "+
				" and c.rent_mng_id = ce.rent_mng_id(+) and c.rent_l_cd =ce.rent_l_cd(+)  \n"+
				" and ce.car_id=d.car_id(+) and ce.car_seq=d.car_seq(+) and c.client_id = t.client_id "+
				" and c.rent_mng_id = cc.rent_mng_id(+) and c.rent_l_cd =cc.rent_l_cd(+) and i.car_kd=b.nm_cd \n"+
				" ";
		
			if(gubun2.equals("6")){
				query += " and a.ins_start_dt like to_char(sysdate,'YYYYMM')||'%'";
			}else{
				query += " and l.car_mng_id is null"; 
				query += " and nvl(h.migr_dt,a.ins_exp_dt) >= a.ins_exp_dt"; 
			}

			if(gubun1.equals("1"))		query += " and a.car_use='1'"; 
			if(gubun1.equals("2"))		query += " and a.car_use<>'1'";

			if(gubun2.equals("1"))		query += " and a.ins_exp_dt < to_char(sysdate,'YYYYMMDD')";
			if(gubun2.equals("2"))		query += " and a.ins_exp_dt between to_char(sysdate-30,'YYYYMMDD') and to_char(sysdate+30,'YYYYMMDD')";
			if(gubun2.equals("3"))		query += " and a.ins_exp_dt like to_char(sysdate,'YYYYMM')||'%'";
			if(gubun2.equals("4"))		query += " and a.ins_exp_dt like to_char(add_months(sysdate,1), 'YYYYMM')||'%'";

			if(!brch_id.equals("S1") && !brch_id.equals(""))		query += " and c.brch_id = '"+brch_id+"'"; 
			if(brch_id.equals("S1"))								query += " and c.brch_id in ('S1','K1','K2')"; 

			if(gubun3.equals("1"))		query += " and i.car_kd in ('1','2','3','9') and to_number(i.dpm) between 801 and 1000 ";
			if(gubun3.equals("2"))		query += " and i.car_kd in ('1','2','3','9') and to_number(i.dpm) between 1501 and 1600 ";
			if(gubun3.equals("3"))		query += " and i.car_kd in ('1','2','3','9') and to_number(i.dpm) between 1901 and 2000 ";
			if(gubun3.equals("4"))		query += " and i.car_kd in ('1','2','3','9') and to_number(i.dpm) between 2001 and 2800 ";
			if(gubun3.equals("5"))		query += " and i.car_kd in ('1','2','3','9') and to_number(i.dpm) >= 2801 ";
			if(gubun3.equals("6"))		query += " and i.taking_p=7";
			if(gubun3.equals("7"))		query += " and i.taking_p between 8 and 10";
			if(gubun3.equals("8"))		query += " and i.taking_p=11";
			if(gubun3.equals("9"))		query += " and i.taking_p=12";
			if(gubun3.equals("10"))		query += " and i.car_kd in ('6','7','8') and i.car_nm||d.car_name like '%밴%'";
			if(gubun3.equals("11"))		query += " and i.car_kd in ('6','7','8') and i.car_nm||d.car_name not like '%밴%'";
			if(gubun3.equals("01"))		query += " and a.con_f_nm like '%아마존카%'";
			if(gubun3.equals("02"))		query += " and a.con_f_nm not like '%아마존카%'";

			if(gubun3.length()==3)		query += " and d.s_st='"+gubun3+"'";



			if(!t_wd.equals("")){
				if(s_kd.equals("1"))			query += " and nvl(c.firm_nm,c.client_nm) like '%"+t_wd+"%'\n";			
				else if(s_kd.equals("4"))		query += " and upper(c.rent_l_cd) like upper('%"+t_wd+"%')\n";
				else if(s_kd.equals("2"))		query += " and (i.car_no like '%"+t_wd+"%' or i.first_car_no like '%"+t_wd+"%')\n";
				else if(s_kd.equals("5"))		query += " and i.car_nm||d.car_name like '%"+t_wd+"%'\n";
				else if(s_kd.equals("3"))		query += " and upper(i.car_num) like upper('%"+t_wd+"%')\n";
				else if(s_kd.equals("6"))		query += " and b.nm like upper('%"+t_wd+"%')\n";
				else if(s_kd.equals("7"))		query += " and a.ins_exp_dt like '"+t_wd+"%'\n";
				
			}



		if(sort.equals("1"))		query += " order by nvl(c.use_yn,'Y') desc, a.ins_start_dt "+asc;
		else if(sort.equals("2"))	query += " order by nvl(c.use_yn,'Y') desc, nvl(c.firm_nm,c.client_nm) "+asc;
		else if(sort.equals("3"))	query += " order by nvl(c.use_yn,'Y') desc, i.car_no "+asc;
		else if(sort.equals("4"))	query += " order by nvl(c.use_yn,'Y') desc, i.car_nm||d.car_name "+asc;
		else if(sort.equals("5"))	query += " order by nvl(c.use_yn,'Y') desc, f.ins_com_nm "+asc;
		else if(sort.equals("6"))	query += " order by nvl(c.use_yn,'Y') desc, a.ins_exp_dt "+asc;
		else if(sort.equals("7"))	query += " order by nvl(c.use_yn,'Y') desc, decode(i.car_kd,'1','3','2','2','3','1','9','1','4','5','5','4','6','6','7','7','8','8') "+asc;

		
		
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


		//	System.out.println("[InsDatabase:getInsStatList1]"+ query);

		} catch (SQLException e) {
			
			System.out.println("[InsDatabase:getInsStatList1]"+ e);
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
	public Vector getInsStatList1(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc, String s_st, String mod_st)
	{
	//	System.out.println("getInsStatList1:"+ gubun2);
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select nvl(t.enp_no, substr(TEXT_DECRYPT(t.ssn, 'pw' ),1,7) ) as enp_no,  c.rent_start_dt, c.rent_end_dt, a.car_mng_id, c.rent_mng_id, c.rent_l_cd, c.firm_nm, c.use_yn, a.con_f_nm, \n"+
				" i.car_no, i.car_nm, d.car_name, i.car_num, i.init_reg_dt, \n"+
				" f.ins_com_nm, a.ins_st, a.ins_con_no, a.ins_start_dt, a.ins_exp_dt, h.migr_dt, decode(cc.cls_st,'8',cc.cls_dt) cls_dt, \n"+ 
				" (decode(a.air_ds_yn,'Y',1,0)+decode(a.air_as_yn,'Y',1,0)) as air,\n"+
				" decode(a.auto_yn,'Y',1,0) as auto,\n"+
				" decode(a.abs_yn,'Y',1,0) as abs,\n"+
				" decode(a.blackbox_yn,'Y',1,0) as blackbox,\n"+
				" decode(a.age_scp,'1','21세이상','2','26세이상','3','모든운전자','4','24세이상','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하') as age_scp,\n"+
				" decode(a.ins_kd,'2','책임보험', '종합보험') as ins_kd,\n"+
				" decode(a.ins_sts,'1','유효', '2','만료', '3','중도해지','5','승계') as ins_sts,\n"+
				" decode(a.car_use,'1','영업용','2','업무용','3','개인용') car_use,"+
				" decode(a.vins_gcp_kd,'1','3000만원','2','1500만원','3','1억원','4','5000만원','5','1000만원','6','5억원', '7','2억원', '8','3억원','9','10억원') vins_gcp_kd,"+
				" decode(a.vins_bacdt_kd,'1','3억원','2','1억5천만원','3','3000만원','4','1500만원','5','5000만원','6','1억원') vins_bacdt_kd,"+
				" decode(a.vins_bacdt_kc2,'1','3억원','2','1억5천만원','3','3000만원','4','1500만원','5','5000만원','6','1억원') vins_bacdt_kc2,"+
				" decode(a.vins_canoisr_amt,0,'미가입','가입') vins_canoisr,"+
				" decode(a.vins_share_extra_amt,0,'미가입','가입') vins_share_extra,"+
				" decode(a.vins_cacdt_cm_amt,0,'미가입','가입') vins_cacdt,"+
				" decode(a.vins_spe_amt,0,'미가입','가입') vins_spe,"+
				" decode(a.vins_canoisr_amt,0,'N','Y') vins_canoisr2,"+
				" decode(a.vins_share_extra_amt,0,'N','Y') vins_share_extra2,"+
				" decode(a.vins_cacdt_cm_amt,0,'N','Y') vins_cacdt2,"+
				" decode(a.vins_spe_amt,0,'N','Y') vins_spe2, \n"+
			    " b.nm as car_kd, "+
				" i.taking_p, mod(ROWNUM,"+mod_st+") mod_st, "+
				" decode(a.com_emp_yn,'Y','가입','N','미가입','') com_emp_yn, a.blackbox_nm, a.blackbox_amt, a.blackbox_no, a.blackbox_dt, d.JG_CODE  "+
				" from (select * from insur where (car_mng_id, ins_st) in (select car_mng_id, max(TO_NUMBER(ins_st)) ins_st from insur where ins_sts='1' group by car_mng_id)) a,  \n"+
				"      cont_n_view c, cls_cont cc,  car_etc ce, \n"+
				"      ins_com f, sui h, car_reg i, ins_cls l, car_nm d, client t, \n"+
				"      (select * from code where c_st='0041') b "+
				" where \n"+
				" a.car_mng_id=c.car_mng_id(+)\n"+
				" and decode(c.use_yn,'Y','Y','','Y',decode(cc.cls_st,'8','Y','N'))='Y'\n"+//살아있거나 매입옵션 명의이전인 차량
				" and a.ins_com_id=f.ins_com_id"+
				" and a.car_mng_id=h.car_mng_id(+) and a.car_mng_id=i.car_mng_id(+) "+
				" and nvl(i.prepare,'0')<>'4'"+ //말소차량제외
				" and a.car_mng_id=l.car_mng_id(+) and a.ins_st=l.ins_st(+) "+
				" and c.rent_mng_id = ce.rent_mng_id(+) and c.rent_l_cd =ce.rent_l_cd(+)  \n"+
				" and ce.car_id=d.car_id(+) and ce.car_seq=d.car_seq(+) and c.client_id = t.client_id "+
				" and c.rent_mng_id = cc.rent_mng_id(+) and c.rent_l_cd =cc.rent_l_cd(+) and i.car_kd=b.nm_cd \n"+
				" ";

			if(gubun2.equals("6")){
				query += " and a.ins_start_dt like to_char(sysdate,'YYYYMM')||'%'";
			}else{
				query += " and l.car_mng_id is null"; 
				query += " and nvl(h.migr_dt,a.ins_exp_dt) >= a.ins_exp_dt"; 
			}
			
			if(gubun1.equals("1"))		query += " and a.car_use='1'"; 
			if(gubun1.equals("2"))		query += " and a.car_use<>'1'";

			if(gubun2.equals("1"))		query += " and a.ins_exp_dt < to_char(sysdate,'YYYYMMDD')";
			if(gubun2.equals("2"))		query += " and a.ins_exp_dt between to_char(sysdate-30,'YYYYMMDD') and to_char(sysdate+30,'YYYYMMDD')";
			if(gubun2.equals("3"))		query += " and a.ins_exp_dt like to_char(sysdate,'YYYYMM')||'%'";
			if(gubun2.equals("4"))		query += " and a.ins_exp_dt like to_char(add_months(sysdate,1), 'YYYYMM')||'%'";
			if(gubun2.equals("5"))		query += " and a.ins_exp_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";
			if(gubun2.equals("7"))		query += " and a.ins_exp_dt = to_char(sysdate+1,'YYYYMMDD')";

			if(!brch_id.equals("S1") && !brch_id.equals(""))		query += " and c.brch_id = '"+brch_id+"'"; 
			if(brch_id.equals("S1"))								query += " and c.brch_id in ('S1','K1','K2')"; 

			if(gubun3.equals("1"))		query += " and i.car_kd in ('1','2','3','9') and to_number(i.dpm) between 801 and 1000 ";
			if(gubun3.equals("2"))		query += " and i.car_kd in ('1','2','3','9') and to_number(i.dpm) between 1501 and 1600 ";
			if(gubun3.equals("3"))		query += " and i.car_kd in ('1','2','3','9') and to_number(i.dpm) between 1901 and 2000 ";
			if(gubun3.equals("4"))		query += " and i.car_kd in ('1','2','3','9') and to_number(i.dpm) between 2001 and 2800 ";
			if(gubun3.equals("5"))		query += " and i.car_kd in ('1','2','3','9') and to_number(i.dpm) >= 2801 ";
			if(gubun3.equals("6"))		query += " and i.taking_p=7";
			if(gubun3.equals("7"))		query += " and i.taking_p between 8 and 10";
			if(gubun3.equals("8"))		query += " and i.taking_p=11";
			if(gubun3.equals("9"))		query += " and i.taking_p=12";
			if(gubun3.equals("10"))		query += " and i.car_kd in ('6','7','8') and i.car_nm||d.car_name like '%밴%'";
			if(gubun3.equals("11"))		query += " and i.car_kd in ('6','7','8') and i.car_nm||d.car_name not like '%밴%'";
			if(gubun3.equals("01"))		query += " and a.con_f_nm like '%아마존카%'";
			if(gubun3.equals("02"))		query += " and a.con_f_nm not like '%아마존카%'";
			if(gubun3.equals("0008") || gubun3.equals("0038")){
				query += " AND CASE WHEN a.car_use IN ('2','3') THEN '0008' WHEN a.car_use='1' AND t.client_st='1' AND d.s_st IN ('400','401','402','501','502','601','602','300','301','302') THEN '0008' ELSE '0038' end ='"+gubun3+"' ";
			}
			
			if(gubun3.length()==3)		query += " and d.s_st='"+gubun3+"'";



			if(!t_wd.equals("")){
				if(s_kd.equals("1"))			query += " and nvl(c.firm_nm,c.client_nm) like '%"+t_wd+"%'\n";			
				else if(s_kd.equals("4"))		query += " and upper(c.rent_l_cd) like upper('%"+t_wd+"%')\n";
				else if(s_kd.equals("2"))		query += " and (i.car_no like '%"+t_wd+"%' or i.first_car_no like '%"+t_wd+"%')\n";
				else if(s_kd.equals("5"))		query += " and i.car_nm||d.car_name like '%"+t_wd+"%'\n";
				else if(s_kd.equals("3"))		query += " and upper(i.car_num) like upper('%"+t_wd+"%')\n";
				else if(s_kd.equals("6"))		query += " and b.nm like upper('%"+t_wd+"%')\n";
				else if(s_kd.equals("7"))		query += " and a.ins_exp_dt like '"+t_wd+"%'\n";
				else if(s_kd.equals("8"))		query += " and f.ins_com_nm like '%"+t_wd+"%'\n";
				else if(s_kd.equals("9"))		query += " and a.ins_start_dt like '"+t_wd+"%'\n";
			}

			query += " order by nvl(c.use_yn,'Y') desc ";

			
		    if(!mod_st.equals("")){
				query += " , mod(ROWNUM,"+mod_st+") ";
			}
		    
			if(sort.equals("1"))		query += " , a.ins_start_dt "+asc;
			else if(sort.equals("2"))	query += " , nvl(c.firm_nm,c.client_nm) "+asc;
			else if(sort.equals("3"))	query += " , i.car_no "+asc;
			else if(sort.equals("4"))	query += " , i.car_nm||d.car_name "+asc;
			else if(sort.equals("5"))	query += " , f.ins_com_nm "+asc;
			else if(sort.equals("6"))	query += " , a.ins_exp_dt "+asc;
			else if(sort.equals("7"))	query += " , decode(i.car_kd,'1','3','2','2','3','1','9','1','4','5','5','4','6','6','7','7','8','8') "+asc;


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


//			System.out.println("[InsDatabase:getInsStatList1]"+ query);

		} catch (SQLException e) {
			
			System.out.println("[InsDatabase:getInsStatList1]"+ e);
			System.out.println("[InsDatabase:getInsStatList1]"+ query);
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

	//보험현황-경과보험료관리리스트
	public Vector getInsStatList3_in1(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";
		String sub_query2 = "";
		String dt = "pay_dt";

		//지출스케줄에서
		sub_query = " select /*+  merge(b) */ substr(d.pay_dt,1,6) "+dt+", d.pay_amt,\n"+
					" decode(a.car_use,'1','렌트','리스') car_st,\n"+
					" a.ins_st, a.pay_tm, d.ins_tm, nvl(d.ins_tm2,'1') ins_tm2\n"+
					" from insur a, cont_n_view b, (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) c, scd_ins d, car_reg cr \n"+
					" where d.pay_yn='1' and a.car_mng_id=d.car_mng_id and a.ins_st=d.ins_st and a.car_mng_id=b.car_mng_id and a.car_mng_id= cr.car_mng_id(+) \n"+
					" and a.car_mng_id=b.car_mng_id and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd";

		if(!st_dt.equals("") && !end_dt.equals(""))		sub_query += " and d.pay_dt between '"+st_dt+"' and '"+end_dt+"'";
		if(!brch_id.equals(""))							sub_query += " and b.brch_id = '"+brch_id+"'";

		//보험스케줄에서
		sub_query2 = " select /*+  merge(b) */ substr(a.ins_start_dt,1,6) "+dt+",\n"+
					 " decode(a.car_use,'1','렌트','리스') car_st,\n"+
					 " trunc((e.car_cs_amt+e.car_cv_amt+e.opt_cs_amt+e.opt_cv_amt+e.clr_cs_amt+e.clr_cv_amt-e.sd_cs_amt-e.sd_cv_amt-e.tax_dc_s_amt-e.tax_dc_v_amt)*g.g_4/100,0) car_amt"+//추가
					 " from insur a, cont_n_view b, car_reg cr, (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) c, \n"+
					 " car_etc e, car_nm f, esti_car_var g, (select a_e, a_a, max(seq) seq from esti_car_var group by a_e, a_a) h"+//추가
					 " where \n"+
					 " a.car_mng_id=b.car_mng_id and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd and a.car_mng_id = cr.car_mng_id(+) "+
					 " and b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd and e.car_id=f.car_id and e.car_seq=f.car_seq"+//추가
					 " and g.a_e=h.a_e and g.a_a=h.a_a and g.seq=h.seq and f.s_st=g.a_e and g.a_a='1'";//추가

		if(!st_dt.equals("") && !end_dt.equals(""))		sub_query2 += " and a.ins_start_dt between '"+st_dt+"' and '"+end_dt+"'";
		if(!brch_id.equals(""))							sub_query2 += " and b.brch_id = '"+brch_id+"'";
		if(!br_id.equals("S1") && !br_id.equals(""))	sub_query2 += " and b.brch_id = '"+br_id+"'"; 

		query = " select\n"+ 
				" substr(a."+dt+",5,2) "+dt+", a.car_st, a.tot_su,\n"+  
				" nvl(b.su1,0) su1, nvl(c.su2,0) su2, nvl(d.su3,0) su3, (nvl(b.su1,0)+nvl(c.su2,0)-nvl(d.su3,0)) su4, nvl(e.su4,0) su5,\n"+ 
				" nvl(b.amt1,0) amt1, nvl(c.amt2,0) amt2, nvl(d.amt3,0) amt3, (nvl(b.amt1,0)+nvl(c.amt2,0)-nvl(d.amt3,0)) amt4, nvl(e.amt4,0) amt5\n"+ 
				" from\n"+ 
				" ( select "+dt+", car_st, count(0) tot_su from ("+sub_query+") group by "+dt+", car_st ) a,\n"+//월별
				" ( select "+dt+", car_st, count(0) su1, nvl(sum(pay_amt),0) amt1 from ("+sub_query+") where ins_tm2 ='1' group by "+dt+", car_st ) b,\n"+//당초
				" ( select "+dt+", car_st, count(0) su2, nvl(sum(pay_amt),0) amt2 from ("+sub_query+") where ins_tm2 ='2' group by "+dt+", car_st ) c,\n"+//추가
				" ( select "+dt+", car_st, count(0) su3, nvl(sum(pay_amt),0) amt3 from ("+sub_query+") where ins_tm2 ='3' group by "+dt+", car_st ) d,\n"+//해지
				" ( select "+dt+", car_st, count(0) su4, nvl(sum(car_amt),0) amt4 from ("+sub_query2+") group by "+dt+", car_st ) e\n"+//자차보험료적립
				" where \n"+ 
				" a."+dt+"=b."+dt+"(+) and a.car_st=b.car_st(+)\n"+
				" and a."+dt+"=c."+dt+"(+) and a.car_st=c.car_st(+)\n"+
				" and a."+dt+"=d."+dt+"(+) and a.car_st=d.car_st(+)"+
				" and a."+dt+"=e."+dt+"(+) and a.car_st=e.car_st(+)";


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
			
			System.out.println("[InsDatabase:getInsStatList3_in1]"+ e);
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

	//보험현황-경과보험료관리리스트2
	public Vector getInsStatList3_in1(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc, String s_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";
		String sub_query2 = "";
		String dt = "pay_dt";

		//지출스케줄에서
		sub_query = " select /*+  merge(b) */ substr(d.pay_dt,1,6) "+dt+", d.pay_amt,\n"+
					" decode(a.car_use,'1','렌트','리스') car_st,\n"+
					" a.ins_st, a.pay_tm, d.ins_tm, nvl(d.ins_tm2,'1') ins_tm2\n"+
					" from insur a, cont_n_view b, (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) c, scd_ins d, car_reg cr \n"+
					" where d.pay_yn='1' and a.car_mng_id=d.car_mng_id and a.ins_st=d.ins_st and a.car_mng_id=b.car_mng_id and a.car_mng_id= cr.car_mng_id(+) \n"+
					" and a.car_mng_id=b.car_mng_id and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd";

		if(gubun2.equals("1"))		sub_query += " and d.pay_dt = to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("2"))	sub_query += " and d.pay_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))	sub_query += " and d.pay_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
		else if(gubun2.equals("4"))	sub_query += " and d.pay_dt like '"+AddUtil.getDate(1)+"%'";
		else if(gubun2.equals("5"))	sub_query += " and d.pay_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		if(!brch_id.equals("S1") && !brch_id.equals(""))	sub_query += " and b.brch_id = '"+brch_id+"'"; 
		if(brch_id.equals("S1"))							sub_query += " and b.brch_id in ('S1','K1')"; 
		if(!br_id.equals("S1") && !br_id.equals(""))		sub_query += " and b.brch_id = '"+br_id+"'"; 


		//보험스케줄에서
		sub_query2 = " select /*+  merge(b) */ substr(a.ins_start_dt,1,6) "+dt+",\n"+
					" decode(a.car_use,'1','렌트','리스') car_st,\n"+
					" trunc((e.car_cs_amt+e.car_cv_amt+e.opt_cs_amt+e.opt_cv_amt+e.clr_cs_amt+e.clr_cv_amt-e.sd_cs_amt-e.sd_cv_amt-e.tax_dc_s_amt-e.tax_dc_v_amt)*g.g_4/100,0) car_amt"+//추가
					" from insur a, cont_n_view b, car_reg cr,  (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) c, \n"+
					" car_etc e, car_nm f, esti_car_var g, (select a_e, a_a, max(seq) seq from esti_car_var group by a_e, a_a) h"+//추가
					" where \n"+
					" a.car_mng_id=b.car_mng_id and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd and a.car_mng_id = cr.car_mng_id(+)"+
					" and b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd and e.car_id=f.car_id and e.car_seq=f.car_seq"+//추가
					" and g.a_e=h.a_e and g.a_a=h.a_a and g.seq=h.seq and f.s_st=g.a_e and g.a_a='1'";//추가

		if(gubun2.equals("1"))		sub_query2 += " and a.ins_start_dt = to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("2"))	sub_query2 += " and a.ins_start_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))	sub_query2 += " and a.ins_start_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
		else if(gubun2.equals("4"))	sub_query2 += " and a.ins_start_dt like '"+AddUtil.getDate(1)+"%'";
		else if(gubun2.equals("5"))	sub_query2 += " and a.ins_start_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		if(!brch_id.equals("S1") && !brch_id.equals(""))	sub_query2 += " and b.brch_id = '"+brch_id+"'"; 
		if(brch_id.equals("S1"))							sub_query2 += " and b.brch_id in ('S1','K1')"; 
		if(!br_id.equals("S1") && !br_id.equals(""))		sub_query2 += " and b.brch_id = '"+br_id+"'"; 

		query = " select\n"+ 
				" substr(a."+dt+",5,2) "+dt+", a.car_st, a.tot_su,\n"+  
				" nvl(b.su1,0) su1, nvl(c.su2,0) su2, nvl(d.su3,0) su3, (nvl(b.su1,0)+nvl(c.su2,0)-nvl(d.su3,0)) su4, nvl(e.su4,0) su5,\n"+ 
				" nvl(b.amt1,0) amt1, nvl(c.amt2,0) amt2, nvl(d.amt3,0) amt3, (nvl(b.amt1,0)+nvl(c.amt2,0)-nvl(d.amt3,0)) amt4, nvl(e.amt4,0) amt5\n"+ 
				" from\n"+ 
				" ( select "+dt+", car_st, count(*) tot_su from ("+sub_query+") group by "+dt+", car_st ) a,\n"+//월별
				" ( select "+dt+", car_st, count(*) su1, nvl(sum(pay_amt),0) amt1 from ("+sub_query+") where ins_tm2 ='0' group by "+dt+", car_st ) b,\n"+//당초
				" ( select "+dt+", car_st, count(*) su2, nvl(sum(pay_amt),0) amt2 from ("+sub_query+") where ins_tm2 ='1' group by "+dt+", car_st ) c,\n"+//추가
				" ( select "+dt+", car_st, count(*) su3, nvl(sum(pay_amt),0) amt3 from ("+sub_query+") where ins_tm2 ='2' group by "+dt+", car_st ) d,\n"+//해지
				" ( select "+dt+", car_st, count(*) su4, nvl(sum(car_amt),0) amt4 from ("+sub_query2+") group by "+dt+", car_st ) e\n"+//자차보험료적립
				" where \n"+ 
				" a."+dt+"=b."+dt+"(+) and a.car_st=b.car_st(+)\n"+
				" and a."+dt+"=c."+dt+"(+) and a.car_st=c.car_st(+)\n"+
				" and a."+dt+"=d."+dt+"(+) and a.car_st=d.car_st(+)"+
				" and a."+dt+"=e."+dt+"(+) and a.car_st=e.car_st(+)";


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
			
			System.out.println("[InsDatabase:getInsStatList3_in1]"+ e);
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

	//보험현황-경과보험료관리(렌트/리스)리스트
	public Vector getInsStatList3_in3(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";
		String dt = "pay_dt";

		//지출스케줄에서
		sub_query = " select /*+  merge(b) */ substr(d.pay_dt,1,6) "+dt+", d.pay_amt,\n"+
					" decode(a.car_use,'1','렌트','리스') car_st,\n"+
					" a.ins_st, a.pay_tm, d.ins_tm, nvl(d.ins_tm2,'1') ins_tm2,\n"+
					" decode(d.ins_tm2, '2',decode(d.ins_st,'0','신규','갱신'), '3',decode(d.ins_st,'0','신규','갱신'),\n"+
					"	decode(d.ins_tm, '1',decode(d.ins_st,'0','신규','갱신'), '분납')) ins_st_nm\n"+
					" from insur a, cont_n_view b, (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) c, scd_ins d, car_reg cr  \n"+
					" where d.pay_yn='1' and a.car_mng_id=d.car_mng_id and a.ins_st=d.ins_st and a.car_mng_id=b.car_mng_id and a.car_jmng_id = cr.car_mng_id(+)  \n"+
					" and a.car_mng_id=b.car_mng_id and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd";

		if(!st_dt.equals("") && !end_dt.equals(""))		sub_query += " and d.pay_dt between '"+st_dt+"' and '"+end_dt+"'";
		if(!brch_id.equals(""))							sub_query += " and b.brch_id = '"+brch_id+"'";

		query = " select\n"+ 
				" substr(a."+dt+",5,2) "+dt+", a.ins_st_nm, a.tot_su,\n"+  
				" nvl(b.su1,0) su1, nvl(c.su2,0) su2, nvl(d.su3,0) su3, (nvl(b.su1,0)+nvl(c.su2,0)-nvl(d.su3,0)) su4,\n"+ 
				" nvl(b.amt1,0) amt1, nvl(c.amt2,0) amt2, nvl(d.amt3,0) amt3, (nvl(b.amt1,0)+nvl(c.amt2,0)-nvl(d.amt3,0)) amt4\n"+ 
				" from\n"+ 
				" ( select "+dt+", ins_st_nm, count(*) tot_su from ("+sub_query+") group by "+dt+", ins_st_nm ) a,\n"+//월별
				" ( select "+dt+", ins_st_nm, count(*) su1, nvl(sum(pay_amt),0) amt1 from ("+sub_query+") where car_st='렌트' and ins_tm2 ='1' group by "+dt+", ins_st_nm ) b,\n"+//당초
				" ( select "+dt+", ins_st_nm, count(*) su2, nvl(sum(pay_amt),0) amt2 from ("+sub_query+") where car_st='렌트' and ins_tm2 ='2' group by "+dt+", ins_st_nm ) c,\n"+//추가
				" ( select "+dt+", ins_st_nm, count(*) su3, nvl(sum(pay_amt),0) amt3 from ("+sub_query+") where car_st='렌트' and ins_tm2 ='3' group by "+dt+", ins_st_nm ) d\n"+//해지
				" where \n"+ 
				" a."+dt+"=b."+dt+"(+) and a.ins_st_nm=b.ins_st_nm(+)\n"+
				" and a."+dt+"=c."+dt+"(+) and a.ins_st_nm=c.ins_st_nm(+)\n"+
				" and a."+dt+"=d."+dt+"(+) and a.ins_st_nm=d.ins_st_nm(+)";


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
			
			System.out.println("[InsDatabase:getInsStatList3_in3]"+ e);
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

	//보험현황-경과보험료관리(렌트)리스트
	public Hashtable getInsStatList3_in3(String pay_dt, String pay_st, String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		String sub_query = "";
		String dt = "pay_dt";

		//지출스케줄에서
		sub_query = " select /*+  merge(b) */  substr(d.pay_dt,1,6) "+dt+", d.pay_amt,\n"+
					" decode(a.car_use,'1','렌트','리스') car_st,\n"+
					" a.ins_st, a.pay_tm, d.ins_tm, nvl(d.ins_tm2,'1') ins_tm2,\n"+
					" decode(d.ins_tm2, '2',decode(d.ins_st,'0','신규','갱신'), '3',decode(d.ins_st,'0','신규','갱신'),\n"+
					"	decode(d.ins_tm, '1',decode(d.ins_st,'0','신규','갱신'), '분납')) ins_st_nm\n"+
					" from insur a, cont_n_view b, (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) c, scd_ins d, car_reg cr  \n"+
					" where d.pay_yn='1' and a.car_mng_id=d.car_mng_id and a.ins_st=d.ins_st and a.car_mng_id=b.car_mng_id and a.car_mng_id = cr.car_mng_id(+) \n"+
					" and a.car_mng_id=b.car_mng_id and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd"+
					" and a.car_use='1'";

		if(!st_dt.equals("") && !end_dt.equals(""))		sub_query += " and d.pay_dt like '"+pay_dt+"%'";
		if(!brch_id.equals(""))							sub_query += " and b.brch_id = '"+brch_id+"'";

		query = " select\n"+ 
				" substr(a."+dt+",5,2) "+dt+", a.tot_su,\n"+  
				" nvl(b.su1,0) su1, nvl(c.su2,0) su2, nvl(d.su3,0) su3, (nvl(b.su1,0)+nvl(c.su2,0)-nvl(d.su3,0)) su4,\n"+ 
				" nvl(b.amt1,0) amt1, nvl(c.amt2,0) amt2, nvl(d.amt3,0) amt3, (nvl(b.amt1,0)+nvl(c.amt2,0)-nvl(d.amt3,0)) amt4\n"+ 
				" from\n"+ 
				" ( select "+dt+", count(*) tot_su from ("+sub_query+") group by "+dt+" ) a,\n"+//월별
				" ( select "+dt+", count(*) su1, nvl(sum(pay_amt),0) amt1 from ("+sub_query+") where ins_tm2 ='0' and ins_st_nm='"+pay_st+"' group by "+dt+" ) b,\n"+//당초
				" ( select "+dt+", count(*) su2, nvl(sum(pay_amt),0) amt2 from ("+sub_query+") where ins_tm2 ='1' and ins_st_nm='"+pay_st+"' group by "+dt+" ) c,\n"+//추가
				" ( select "+dt+", count(*) su3, nvl(sum(pay_amt),0) amt3 from ("+sub_query+") where ins_tm2 ='2' and ins_st_nm='"+pay_st+"' group by "+dt+" ) d\n"+//해지
				" where \n"+ 
				" a."+dt+"=b."+dt+"(+)\n"+
				" and a."+dt+"=c."+dt+"(+)\n"+
				" and a."+dt+"=d."+dt+"(+)";


		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
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
			pstmt.close();

			
		} catch (SQLException e) {
			
			System.out.println("[InsDatabase:getInsStatList3_in3]"+ e);
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

	//보험현황-경과보험료관리(렌트)리스트
	public InsStatBean getInsStatList3_in3_bean(String pay_dt, String pay_st, String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		InsStatBean bean = new InsStatBean();
		String query = "";
		String sub_query = "";
		String sub_query2 = "";
		String dt = "pay_dt";

		//지출스케줄에서
		sub_query = " select /*+  merge(b) */ substr(d.pay_dt,1,6) "+dt+", d.pay_amt,\n"+
					" decode(a.car_use,'1','렌트','리스') car_st,\n"+
					" a.ins_st, a.pay_tm, d.ins_tm, nvl(d.ins_tm2,'1') ins_tm2,\n"+
					" decode(d.ins_tm2, '2',decode(d.ins_st,'0','신규','갱신'), '3',decode(d.ins_st,'0','신규','갱신'),\n"+
					"	decode(d.ins_tm, '1',decode(d.ins_st,'0','신규','갱신'), '분납')) ins_st_nm\n"+
					" from insur a, cont_n_view b, (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) c, scd_ins d, car_reg cr  \n"+
					" where d.pay_yn='1' and a.car_mng_id=d.car_mng_id and a.ins_st=d.ins_st and a.car_mng_id=b.car_mng_id and a.car_mng_id = cr.car_mng_id(+)  \n"+
					" and a.car_mng_id=b.car_mng_id and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd"+
					" and a.car_use='1'";

		if(!st_dt.equals("") && !end_dt.equals(""))		sub_query += " and d.pay_dt like '"+pay_dt+"%'";
		if(!brch_id.equals(""))							sub_query += " and b.brch_id = '"+brch_id+"'";

		//보험스케줄에서
		sub_query2 = " select /*+  merge(b) */ substr(a.ins_start_dt,1,6) "+dt+",\n"+
					" decode(a.car_use,'1','렌트','리스') car_st,\n"+
					" decode(a.ins_st,'0','신규','갱신') ins_st_nm,"+
					" trunc((e.car_cs_amt+e.car_cv_amt+e.opt_cs_amt+e.opt_cv_amt+e.clr_cs_amt+e.clr_cv_amt-e.sd_cs_amt-e.sd_cv_amt-e.tax_dc_s_amt-e.tax_dc_v_amt)*g.g_4/100,0) car_amt"+//추가
					" from insur a, cont_n_view b,  car_reg cr, (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) c, \n"+
					" car_etc e, car_nm f, esti_car_var g, (select a_e, a_a, max(seq) seq from esti_car_var group by a_e, a_a) h"+//추가
					" where \n"+
					" a.car_mng_id=b.car_mng_id and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd and a.car_mng_id = cr.car_mng_id(+) "+
					" and b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd and e.car_id=f.car_id and e.car_seq=f.car_seq"+//추가
					" and g.a_e=h.a_e and g.a_a=h.a_a and g.seq=h.seq and f.s_st=g.a_e and g.a_a='1'"+//추가
					" and a.car_use='1'";

		if(!st_dt.equals("") && !end_dt.equals(""))		sub_query2 += " and a.ins_start_dt like '%"+pay_dt+"%'";
		if(!brch_id.equals(""))							sub_query2 += " and b.brch_id = '"+brch_id+"'";
		if(!br_id.equals("S1") && !br_id.equals(""))	sub_query2 += " and b.brch_id = '"+br_id+"'"; 


		query = " select\n"+ 
				" substr(a."+dt+",5,2) "+dt+", a.tot_su,\n"+  
				" nvl(b.su1,0) su1, nvl(c.su2,0) su2, nvl(d.su3,0) su3, (nvl(b.su1,0)+nvl(c.su2,0)-nvl(d.su3,0)) su4, nvl(e.su4,0) su5,\n"+ 
				" nvl(b.amt1,0) amt1, nvl(c.amt2,0) amt2, nvl(d.amt3,0) amt3, (nvl(b.amt1,0)+nvl(c.amt2,0)-nvl(d.amt3,0)) amt4, nvl(e.amt4,0) amt5\n"+ 
				" from\n"+ 
				" ( select "+dt+", count(*) tot_su from ("+sub_query+") group by "+dt+" ) a,\n"+//월별
				" ( select "+dt+", count(*) su1, nvl(sum(pay_amt),0) amt1 from ("+sub_query+") where ins_tm2 ='0' and ins_st_nm='"+pay_st+"' group by "+dt+" ) b,\n"+//당초
				" ( select "+dt+", count(*) su2, nvl(sum(pay_amt),0) amt2 from ("+sub_query+") where ins_tm2 ='1' and ins_st_nm='"+pay_st+"' group by "+dt+" ) c,\n"+//추가
				" ( select "+dt+", count(*) su3, nvl(sum(pay_amt),0) amt3 from ("+sub_query+") where ins_tm2 ='2' and ins_st_nm='"+pay_st+"' group by "+dt+" ) d,\n"+//해지
				" ( select "+dt+", count(*) su4, nvl(sum(car_amt),0) amt4 from ("+sub_query2+") where ins_st_nm='"+pay_st+"' group by "+dt+" ) e\n"+//자차보험적립
				" where \n"+ 
				" a."+dt+"=b."+dt+"(+)\n"+
				" and a."+dt+"=c."+dt+"(+)\n"+
				" and a."+dt+"=d."+dt+"(+)"+
				" and a."+dt+"=e."+dt+"(+)";


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{				
				bean.setDt(rs.getString(1));
				bean.setSt(pay_st);
				bean.setTot_su(rs.getInt(2));
				bean.setSu1(rs.getInt(3));
				bean.setSu2(rs.getInt(4));
				bean.setSu3(rs.getInt(5));
				bean.setSu4(rs.getInt(6));
				bean.setSu5(rs.getInt(7));
				bean.setAmt1(rs.getLong(8));
				bean.setAmt2(rs.getLong(9));
				bean.setAmt3(rs.getLong(10));
				bean.setAmt4(rs.getLong(11));
				bean.setAmt5(rs.getLong(12));
			}
			rs.close();
			pstmt.close();

			
		} catch (SQLException e) {
			
			System.out.println("[InsDatabase:getInsStatList3_in3(bean)]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
		                if(rs != null )		rs.close();
                		if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}
	}	

	//보험현황-경과보험료관리(렌트)리스트2
	public InsStatBean getInsStatList3_in3_bean(String pay_dt, String pay_st, String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc, String s_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		InsStatBean bean = new InsStatBean();
		String query = "";
		String sub_query = "";
		String sub_query2 = "";
		String dt = "pay_dt";

		//지출스케줄에서
		sub_query = " select /*+  merge(b) */ substr(d.pay_dt,1,6) "+dt+", d.pay_amt,\n"+
					" decode(a.car_use,'1','렌트','리스') car_st,\n"+
					" a.ins_st, a.pay_tm, d.ins_tm, nvl(d.ins_tm2,'1') ins_tm2,\n"+
					" decode(d.ins_tm2, '2',decode(d.ins_st,'0','신규','갱신'), '3',decode(d.ins_st,'0','신규','갱신'),\n"+
					"	decode(d.ins_tm, '1',decode(d.ins_st,'0','신규','갱신'), '분납')) ins_st_nm\n"+
					" from insur a, cont_n_view b, (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) c, scd_ins d , car_reg cr \n"+
					" where d.pay_yn='1' and a.car_mng_id=d.car_mng_id and a.ins_st=d.ins_st and a.car_mng_id=b.car_mng_id  and a.car_mng_id = cr.car_mng_id(+) \n"+
					" and a.car_mng_id=b.car_mng_id and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd"+
					" and a.car_use='1'";

		if(gubun2.equals("1"))		sub_query += " and d.pay_dt = to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("2"))	sub_query += " and d.pay_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))	sub_query += " and d.pay_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
		else if(gubun2.equals("4"))	sub_query += " and d.pay_dt like '"+AddUtil.getDate(1)+"%'";
		else if(gubun2.equals("5"))	sub_query += " and d.pay_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		if(!brch_id.equals("S1") && !brch_id.equals(""))	sub_query += " and b.brch_id = '"+brch_id+"'"; 
		if(brch_id.equals("S1"))							sub_query += " and b.brch_id in ('S1','K1')"; 
		if(!br_id.equals("S1") && !br_id.equals(""))		sub_query += " and b.brch_id = '"+br_id+"'"; 


		//보험스케줄에서
		sub_query2 = " select /*+  merge(b) */ substr(a.ins_start_dt,1,6) "+dt+",\n"+
					" decode(a.car_use,'1','렌트','리스') car_st,\n"+
					" decode(a.ins_st,'0','신규','갱신') ins_st_nm,"+
					" trunc((e.car_cs_amt+e.car_cv_amt+e.opt_cs_amt+e.opt_cv_amt+e.clr_cs_amt+e.clr_cv_amt-e.sd_cs_amt-e.sd_cv_amt-e.tax_dc_s_amt-e.tax_dc_v_amt)*g.g_4/100,0) car_amt"+//추가
					" from insur a, cont_n_view b,  car_reg cr, (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) c, \n"+
					" car_etc e, car_nm f, esti_car_var g, (select a_e, a_a, max(seq) seq from esti_car_var group by a_e, a_a) h"+//추가
					" where \n"+
					" a.car_mng_id=b.car_mng_id and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd and a.car_mng_id = cr.car_mng_id(+) "+
					" and b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd and e.car_id=f.car_id and e.car_seq=f.car_seq"+//추가
					" and g.a_e=h.a_e and g.a_a=h.a_a and g.seq=h.seq and f.s_st=g.a_e and g.a_a='1'"+//추가
					" and a.car_use='1'";

		if(gubun2.equals("1"))		sub_query2 += " and a.ins_start_dt = to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("2"))	sub_query2 += " and a.ins_start_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))	sub_query2 += " and a.ins_start_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
		else if(gubun2.equals("4"))	sub_query2 += " and a.ins_start_dt like '"+AddUtil.getDate(1)+"%'";
		else if(gubun2.equals("5"))	sub_query2 += " and a.ins_start_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		if(!brch_id.equals("S1") && !brch_id.equals(""))	sub_query2 += " and b.brch_id = '"+brch_id+"'"; 
		if(brch_id.equals("S1"))							sub_query2 += " and b.brch_id in ('S1','K1')"; 
		if(!br_id.equals("S1") && !br_id.equals(""))		sub_query2 += " and b.brch_id = '"+br_id+"'"; 


		query = " select\n"+ 
				" substr(a."+dt+",5,2) "+dt+", a.tot_su,\n"+  
				" nvl(b.su1,0) su1, nvl(c.su2,0) su2, nvl(d.su3,0) su3, (nvl(b.su1,0)+nvl(c.su2,0)-nvl(d.su3,0)) su4, nvl(e.su4,0) su5,\n"+ 
				" nvl(b.amt1,0) amt1, nvl(c.amt2,0) amt2, nvl(d.amt3,0) amt3, (nvl(b.amt1,0)+nvl(c.amt2,0)-nvl(d.amt3,0)) amt4, nvl(e.amt4,0) amt5\n"+ 
				" from\n"+ 
				" ( select "+dt+", count(0) tot_su from ("+sub_query+") group by "+dt+" ) a,\n"+//월별
				" ( select "+dt+", count(0) su1, nvl(sum(pay_amt),0) amt1 from ("+sub_query+") where ins_tm2 ='0' and ins_st_nm='"+pay_st+"' group by "+dt+" ) b,\n"+//당초
				" ( select "+dt+", count(0) su2, nvl(sum(pay_amt),0) amt2 from ("+sub_query+") where ins_tm2 ='1' and ins_st_nm='"+pay_st+"' group by "+dt+" ) c,\n"+//추가
				" ( select "+dt+", count(0) su3, nvl(sum(pay_amt),0) amt3 from ("+sub_query+") where ins_tm2 ='2' and ins_st_nm='"+pay_st+"' group by "+dt+" ) d,\n"+//해지
				" ( select "+dt+", count(0) su4, nvl(sum(car_amt),0) amt4 from ("+sub_query2+") where ins_st_nm='"+pay_st+"' group by "+dt+" ) e\n"+//자차보험적립
				" where \n"+ 
				" a."+dt+"=b."+dt+"(+)\n"+
				" and a."+dt+"=c."+dt+"(+)\n"+
				" and a."+dt+"=d."+dt+"(+)"+
				" and a."+dt+"=e."+dt+"(+)";


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{				
				bean.setDt(rs.getString(1));
				bean.setSt(pay_st);
				bean.setTot_su(rs.getInt(2));
				bean.setSu1(rs.getInt(3));
				bean.setSu2(rs.getInt(4));
				bean.setSu3(rs.getInt(5));
				bean.setSu4(rs.getInt(6));
				bean.setSu5(rs.getInt(7));
				bean.setAmt1(rs.getLong(8));
				bean.setAmt2(rs.getLong(9));
				bean.setAmt3(rs.getLong(10));
				bean.setAmt4(rs.getLong(11));
				bean.setAmt5(rs.getLong(12));
			}
			rs.close();
			pstmt.close();

			
		} catch (SQLException e) {
			
			System.out.println("[InsDatabase:getInsStatList3_in3(bean)]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
		                if(rs != null )		rs.close();
                		if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}
	}	


	//보험현황-경과보험료관리(리스)리스트
	public InsStatBean getInsStatList3_in4_bean(String pay_dt, String pay_st, String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		InsStatBean bean = new InsStatBean();
		String query = "";
		String sub_query = "";
		String sub_query2 = "";
		String dt = "pay_dt";

		//지출스케줄에서
		sub_query = " select /*+  merge(b) */ substr(d.pay_dt,1,6) "+dt+", d.pay_amt,\n"+
					" decode(a.car_use,'1','렌트','리스') car_st,\n"+
					" a.ins_st, a.pay_tm, d.ins_tm, nvl(d.ins_tm2,'1') ins_tm2,\n"+
					" decode(d.ins_tm2, '2',decode(d.ins_st,'0','신규','갱신'), '3',decode(d.ins_st,'0','신규','갱신'),\n"+
					"	decode(d.ins_tm, '1',decode(d.ins_st,'0','신규','갱신'), '분납')) ins_st_nm\n"+
					" from insur a, cont_n_view b,  car_reg cr, (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) c, scd_ins d \n"+
					" where d.pay_yn='1' and a.car_mng_id=d.car_mng_id and a.ins_st=d.ins_st and a.car_mng_id=b.car_mng_id and a.car_mng_id = cr.car_mng_id(+) \n"+
					" and a.car_mng_id=b.car_mng_id and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd"+
					" and a.car_use<>'1'";

		if(!st_dt.equals("") && !end_dt.equals(""))		sub_query += " and d.pay_dt like '"+pay_dt+"%'";
		if(!brch_id.equals(""))							sub_query += " and b.brch_id = '"+brch_id+"'";

		//보험스케줄에서
		sub_query2 = " select /*+  merge(b) */ substr(a.ins_start_dt,1,6) "+dt+",\n"+
					" decode(a.car_use,'1','렌트','리스') car_st,\n"+
					" decode(a.ins_st,'0','신규','갱신') ins_st_nm,"+
					" trunc((e.car_cs_amt+e.car_cv_amt+e.opt_cs_amt+e.opt_cv_amt+e.clr_cs_amt+e.clr_cv_amt-e.sd_cs_amt-e.sd_cv_amt-e.tax_dc_s_amt-e.tax_dc_v_amt)*g.g_4/100,0) car_amt"+//추가
					" from insur a, cont_n_view b, car_reg cr ,  (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) c, \n"+
					" car_etc e, car_nm f, esti_car_var g, (select a_e, a_a, max(seq) seq from esti_car_var group by a_e, a_a) h"+//추가
					" where \n"+
					" a.car_mng_id=b.car_mng_id and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd and a.car_mng_id = cr.car_mng_id(+) "+
					" and b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd and e.car_id=f.car_id and e.car_seq=f.car_seq"+//추가
					" and g.a_e=h.a_e and g.a_a=h.a_a and g.seq=h.seq and f.s_st=g.a_e and g.a_a='1'"+//추가
					" and a.car_use<>'1'";

		if(!st_dt.equals("") && !end_dt.equals(""))		sub_query2 += " and a.ins_start_dt like '"+pay_dt+"%'";
		if(!brch_id.equals(""))							sub_query2 += " and b.brch_id = '"+brch_id+"'";
		if(!br_id.equals("S1") && !br_id.equals(""))	sub_query2 += " and b.brch_id = '"+br_id+"'"; 

		query = " select\n"+ 
				" substr(a."+dt+",5,2) "+dt+", a.tot_su,\n"+  
				" nvl(b.su1,0) su1, nvl(c.su2,0) su2, nvl(d.su3,0) su3, (nvl(b.su1,0)+nvl(c.su2,0)-nvl(d.su3,0)) su4, nvl(e.su4,0) su5,\n"+ 
				" nvl(b.amt1,0) amt1, nvl(c.amt2,0) amt2, nvl(d.amt3,0) amt3, (nvl(b.amt1,0)+nvl(c.amt2,0)-nvl(d.amt3,0)) amt4, nvl(e.amt4,0) amt5\n"+ 
				" from\n"+ 
				" ( select "+dt+", count(*) tot_su from ("+sub_query+") group by "+dt+" ) a,\n"+//월별
				" ( select "+dt+", count(*) su1, nvl(sum(pay_amt),0) amt1 from ("+sub_query+") where ins_tm2 ='0' and ins_st_nm='"+pay_st+"' group by "+dt+" ) b,\n"+//당초
				" ( select "+dt+", count(*) su2, nvl(sum(pay_amt),0) amt2 from ("+sub_query+") where ins_tm2 ='1' and ins_st_nm='"+pay_st+"' group by "+dt+" ) c,\n"+//추가
				" ( select "+dt+", count(*) su3, nvl(sum(pay_amt),0) amt3 from ("+sub_query+") where ins_tm2 ='2' and ins_st_nm='"+pay_st+"' group by "+dt+" ) d,\n"+//해지
				" ( select "+dt+", count(*) su4, nvl(sum(car_amt),0) amt4 from ("+sub_query2+") where ins_st_nm='"+pay_st+"' group by "+dt+" ) e\n"+//자차보험적립
				" where \n"+ 
				" a."+dt+"=b."+dt+"(+)\n"+
				" and a."+dt+"=c."+dt+"(+)\n"+
				" and a."+dt+"=d."+dt+"(+)"+
				" and a."+dt+"=e."+dt+"(+)";


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{				
				bean.setDt(rs.getString(1));
				bean.setSt(pay_st);
				bean.setTot_su(rs.getInt(2));
				bean.setSu1(rs.getInt(3));
				bean.setSu2(rs.getInt(4));
				bean.setSu3(rs.getInt(5));
				bean.setSu4(rs.getInt(6));
				bean.setSu5(rs.getInt(7));
				bean.setAmt1(rs.getLong(8));
				bean.setAmt2(rs.getLong(9));
				bean.setAmt3(rs.getLong(10));
				bean.setAmt4(rs.getLong(11));
				bean.setAmt5(rs.getLong(12));
			}
			rs.close();
			pstmt.close();

			
		} catch (SQLException e) {
			
			System.out.println("[InsDatabase:getInsStatList3_in3(bean)]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
		                if(rs != null )		rs.close();
                		if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}
	}	

	//보험현황-경과보험료관리(리스)리스트2
	public InsStatBean getInsStatList3_in4_bean(String pay_dt, String pay_st, String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc, String s_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		InsStatBean bean = new InsStatBean();
		String query = "";
		String sub_query = "";
		String sub_query2 = "";
		String dt = "pay_dt";

		//지출스케줄에서
		sub_query = " select /*+  merge(b) */ substr(d.pay_dt,1,6) "+dt+", d.pay_amt,\n"+
					" decode(a.car_use,'1','렌트','리스') car_st,\n"+
					" a.ins_st, a.pay_tm, d.ins_tm, nvl(d.ins_tm2,'1') ins_tm2,\n"+
					" decode(d.ins_tm2, '2',decode(d.ins_st,'0','신규','갱신'), '3',decode(d.ins_st,'0','신규','갱신'),\n"+
					"	decode(d.ins_tm, '1',decode(d.ins_st,'0','신규','갱신'), '분납')) ins_st_nm\n"+
					" from insur a, cont_n_view b, car_reg cr,  (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) c, scd_ins d \n"+
					" where d.pay_yn='1' and a.car_mng_id=d.car_mng_id and a.ins_st=d.ins_st and a.car_mng_id=b.car_mng_id and a.car_mng_id =cr.car_mng_id(+) \n"+
					" and a.car_mng_id=b.car_mng_id and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd"+
					" and a.car_use<>'1'";

		if(gubun2.equals("1"))		sub_query += " and d.pay_dt = to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("2"))	sub_query += " and d.pay_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))	sub_query += " and d.pay_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
		else if(gubun2.equals("4"))	sub_query += " and d.pay_dt like '"+AddUtil.getDate(1)+"%'";
		else if(gubun2.equals("5"))	sub_query += " and d.pay_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		if(!brch_id.equals("S1") && !brch_id.equals(""))	sub_query += " and b.brch_id = '"+brch_id+"'"; 
		if(brch_id.equals("S1"))							sub_query += " and b.brch_id in ('S1','K1')"; 
		if(!br_id.equals("S1") && !br_id.equals(""))		sub_query += " and b.brch_id = '"+br_id+"'"; 


		//보험스케줄에서
		sub_query2 = " select /*+  merge(b) */ substr(a.ins_start_dt,1,6) "+dt+",\n"+
					" decode(a.car_use,'1','렌트','리스') car_st,\n"+
					" decode(a.ins_st,'0','신규','갱신') ins_st_nm,"+
					" trunc((e.car_cs_amt+e.car_cv_amt+e.opt_cs_amt+e.opt_cv_amt+e.clr_cs_amt+e.clr_cv_amt-e.sd_cs_amt-e.sd_cv_amt-e.tax_dc_s_amt-e.tax_dc_v_amt)*g.g_4/100,0) car_amt"+//추가
					" from insur a, cont_n_view b, car_reg cr,  (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) c,  \n"+
					" car_etc e, car_nm f, esti_car_var g, (select a_e, a_a, max(seq) seq from esti_car_var group by a_e, a_a) h"+//추가
					" where \n"+
					" a.car_mng_id=b.car_mng_id and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd and a.car_mng_id = cr.car_mng_id(+) "+
					" and b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd and e.car_id=f.car_id and e.car_seq=f.car_seq"+//추가
					" and g.a_e=h.a_e and g.a_a=h.a_a and g.seq=h.seq and f.s_st=g.a_e and g.a_a='1'"+//추가
					" and a.car_use<>'1'";

		if(gubun2.equals("1"))		sub_query2 += " and a.ins_start_dt = to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("2"))	sub_query2 += " and a.ins_start_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))	sub_query2 += " and a.ins_start_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
		else if(gubun2.equals("4"))	sub_query2 += " and a.ins_start_dt like '"+AddUtil.getDate(1)+"%'";
		else if(gubun2.equals("5"))	sub_query2 += " and a.ins_start_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		if(!brch_id.equals("S1") && !brch_id.equals(""))	sub_query2 += " and b.brch_id = '"+brch_id+"'"; 
		if(brch_id.equals("S1"))							sub_query2 += " and b.brch_id in ('S1','K1')"; 
		if(!br_id.equals("S1") && !br_id.equals(""))		sub_query2 += " and b.brch_id = '"+br_id+"'"; 


		query = " select\n"+ 
				" substr(a."+dt+",5,2) "+dt+", a.tot_su,\n"+  
				" nvl(b.su1,0) su1, nvl(c.su2,0) su2, nvl(d.su3,0) su3, (nvl(b.su1,0)+nvl(c.su2,0)-nvl(d.su3,0)) su4, nvl(e.su4,0) su5,\n"+ 
				" nvl(b.amt1,0) amt1, nvl(c.amt2,0) amt2, nvl(d.amt3,0) amt3, (nvl(b.amt1,0)+nvl(c.amt2,0)-nvl(d.amt3,0)) amt4, nvl(e.amt4,0) amt5\n"+ 
				" from\n"+ 
				" ( select "+dt+", count(*) tot_su from ("+sub_query+") group by "+dt+" ) a,\n"+//월별
				" ( select "+dt+", count(*) su1, nvl(sum(pay_amt),0) amt1 from ("+sub_query+") where ins_tm2 ='0' and ins_st_nm='"+pay_st+"' group by "+dt+" ) b,\n"+//당초
				" ( select "+dt+", count(*) su2, nvl(sum(pay_amt),0) amt2 from ("+sub_query+") where ins_tm2 ='1' and ins_st_nm='"+pay_st+"' group by "+dt+" ) c,\n"+//추가
				" ( select "+dt+", count(*) su3, nvl(sum(pay_amt),0) amt3 from ("+sub_query+") where ins_tm2 ='2' and ins_st_nm='"+pay_st+"' group by "+dt+" ) d,\n"+//해지
				" ( select "+dt+", count(*) su4, nvl(sum(car_amt),0) amt4 from ("+sub_query2+") where ins_st_nm='"+pay_st+"' group by "+dt+" ) e\n"+//자차보험적립
				" where \n"+ 
				" a."+dt+"=b."+dt+"(+)\n"+
				" and a."+dt+"=c."+dt+"(+)\n"+
				" and a."+dt+"=d."+dt+"(+)"+
				" and a."+dt+"=e."+dt+"(+)";


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{				
				bean.setDt(rs.getString(1));
				bean.setSt(pay_st);
				bean.setTot_su(rs.getInt(2));
				bean.setSu1(rs.getInt(3));
				bean.setSu2(rs.getInt(4));
				bean.setSu3(rs.getInt(5));
				bean.setSu4(rs.getInt(6));
				bean.setSu5(rs.getInt(7));
				bean.setAmt1(rs.getLong(8));
				bean.setAmt2(rs.getLong(9));
				bean.setAmt3(rs.getLong(10));
				bean.setAmt4(rs.getLong(11));
				bean.setAmt5(rs.getLong(12));
			}
			rs.close();
			pstmt.close();

			
		} catch (SQLException e) {
			
			System.out.println("[InsDatabase:getInsStatList3_in3(bean)]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
		                if(rs != null )		rs.close();
                		if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}
	}	

	//보험현황-경과보험료관리리스트
	public Vector getInsStatList3_in3_sub1(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		//지출스케줄에서
		query = " select /*+  merge(b) */ substr(d.pay_dt,1,6) pay_dt"+
					" from insur a, cont_n_view b, (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) c, scd_ins d \n"+
					" where d.pay_yn='1' and a.car_mng_id=d.car_mng_id and a.ins_st=d.ins_st and a.car_mng_id=b.car_mng_id \n"+
					" and a.car_mng_id=b.car_mng_id and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd";

		if(!st_dt.equals("") && !end_dt.equals(""))		query += " and d.pay_dt between '"+st_dt+"' and '"+end_dt+"'";
		if(!brch_id.equals(""))							query += " and b.brch_id = '"+brch_id+"'";
		if(!br_id.equals("S1") && !br_id.equals(""))	query += " and b.brch_id = '"+br_id+"'"; 

		query += " group by substr(d.pay_dt,1,6) order by substr(d.pay_dt,1,6)";

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
			
			System.out.println("[InsDatabase:getInsStatList3_in3_sub1]"+ e);
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

	//보험현황-경과보험료관리리스트
	public Vector getInsStatList3_in3_sub1(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc, String s_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		//지출스케줄에서
		query = " select /*+  merge(b) */ substr(d.pay_dt,1,6) pay_dt"+
					" from insur a, cont_n_view b, (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) c, scd_ins d \n"+
					" where d.pay_yn='1' and a.car_mng_id=d.car_mng_id and a.ins_st=d.ins_st and a.car_mng_id=b.car_mng_id \n"+
					" and a.car_mng_id=b.car_mng_id and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd";

		if(gubun2.equals("1"))		query += " and d.pay_dt = to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("2"))	query += " and d.pay_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))	query += " and d.pay_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
		else if(gubun2.equals("4"))	query += " and d.pay_dt like '"+AddUtil.getDate(1)+"%'";
		else if(gubun2.equals("5"))	query += " and d.pay_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		if(!brch_id.equals("S1") && !brch_id.equals(""))	query += " and b.brch_id = '"+brch_id+"'"; 
		if(brch_id.equals("S1"))							query += " and b.brch_id in ('S1','K1')"; 

		query += " group by substr(d.pay_dt,1,6) order by substr(d.pay_dt,1,6)";

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
			
			System.out.println("[InsDatabase:getInsStatList3_in3_sub1]"+ e);
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

	//사고현황-사고율관리리스트
	public Vector getAccidStatList7_in1(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";
		String sub_query2 = "";
		String sub_query3 = "";
		String sub_query4 = "";
		String sub_query5 = "";
		String dt = "pay_dt";

		//보험-지출스케줄에서
		sub_query = " select /*+  merge(b) */ substr(d.pay_dt,1,6) "+dt+", d.pay_amt,\n"+
					" decode(a.car_use,'1','렌트','리스') car_st,\n"+
					" a.ins_st, a.pay_tm, d.ins_tm, nvl(d.ins_tm2,'1') ins_tm2\n"+
					" from insur a, cont_n_view b, car_reg cr,  (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) c, scd_ins d \n"+
					" where d.pay_yn='1' and a.car_mng_id=d.car_mng_id and a.ins_st=d.ins_st and a.car_mng_id=b.car_mng_id and a.car_mng_id = cr.car_mng_id(+)  \n"+
					" and a.car_mng_id=b.car_mng_id and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd";

		if(!st_dt.equals("") && !end_dt.equals(""))		sub_query += " and d.pay_dt between '"+st_dt+"' and '"+end_dt+"'";
		if(!brch_id.equals(""))							sub_query += " and b.brch_id = '"+brch_id+"'";

		//사고-대인보상금
		sub_query2 = " select /*+  merge(b) */ substr(a.hum_end_dt,1,6) "+dt+", a.hum_amt,\n"+
					" decode(cr.car_use,'1','렌트','리스') car_st\n"+
					" from accident a, cont_n_view b, car_reg cr \n"+
					" where a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.car_mng_id = cr.car_mng_id(+) ";

		if(!st_dt.equals("") && !end_dt.equals(""))		sub_query2 += " and a.hum_end_dt between '"+st_dt+"' and '"+end_dt+"'";
		if(!brch_id.equals(""))							sub_query2 += " and b.brch_id = '"+brch_id+"'";
		if(!br_id.equals("S1") && !br_id.equals(""))	sub_query2 += " and b.brch_id = '"+br_id+"'"; 

		//사고-대인보상금
		sub_query3 = " select /*+  merge(b) */ substr(a.mat_end_dt,1,6) "+dt+", a.mat_amt,\n"+
					" decode(cr.car_use,'1','렌트','리스') car_st\n"+
					" from accident a, cont_n_view b, car_reg cr \n"+
					" where a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.car_mng_id = cr.car_mng_id(+) ";

		if(!st_dt.equals("") && !end_dt.equals(""))		sub_query3 += " and a.mat_end_dt between '"+st_dt+"' and '"+end_dt+"'";
		if(!brch_id.equals(""))							sub_query3 += " and b.brch_id = '"+brch_id+"'";
		if(!br_id.equals("S1") && !br_id.equals(""))	sub_query3 += " and b.brch_id = '"+br_id+"'"; 

		//사고-자손보상금
		sub_query4 = " select /*+  merge(b) */ substr(a.one_end_dt,1,6) "+dt+", a.one_amt,\n"+
					" decode(cr.car_use,'1','렌트','리스') car_st\n"+
					" from accident a, cont_n_view b, car_reg cr \n"+
					" where a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.car_mng_id = cr.car_mng_id(+) ";

		if(!st_dt.equals("") && !end_dt.equals(""))		sub_query4 += " and a.one_end_dt between '"+st_dt+"' and '"+end_dt+"'";
		if(!brch_id.equals(""))							sub_query4 += " and b.brch_id = '"+brch_id+"'";
		if(!br_id.equals("S1") && !br_id.equals(""))	sub_query4 += " and b.brch_id = '"+br_id+"'"; 

		//사고-자손보상금
		sub_query5 = " select /*+  merge(b) */ substr(c.set_dt,1,6) "+dt+", c.tot_amt,\n"+
					" decode(cr.car_use,'1','렌트','리스') car_st\n"+
					" from accident a, cont_n_view b, service c, car_reg cr \n"+
					" where a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.car_mng_id  = cr.car_mng_id(+) \n"+
					" and a.car_mng_id=c.car_mng_id and a.accid_id=c.accid_id";

		if(!st_dt.equals("") && !end_dt.equals(""))		sub_query5 += " and c.set_dt between '"+st_dt+"' and '"+end_dt+"'";
		if(!brch_id.equals(""))							sub_query5 += " and b.brch_id = '"+brch_id+"'";
		if(!br_id.equals("S1") && !br_id.equals(""))	sub_query5 += " and b.brch_id = '"+br_id+"'"; 

		query = " select\n"+ 
				" substr(a."+dt+",5,2) "+dt+", a.car_st, a.tot_su,\n"+  
				" (nvl(b.su1,0)+nvl(c.su2,0)-nvl(d.su3,0)) su1,\n"+ 
				" nvl(e.su4,0) su2, nvl(f.su5,0) su3, nvl(g.su6,0) su4, nvl(h.su7,0) su5,\n"+
				" (nvl(e.su4,0)+nvl(f.su5,0)+nvl(g.su6,0)+nvl(h.su7,0)) su6,"+
				" (nvl(b.amt1,0)+nvl(c.amt2,0)-nvl(d.amt3,0)) amt1,\n"+ 
				" nvl(e.amt4,0) amt2, nvl(f.amt5,0) amt3, nvl(g.amt6,0) amt4, nvl(h.amt7,0) amt5,\n"+
				" (nvl(e.amt4,0)+nvl(f.amt5,0)+nvl(g.amt6,0)+nvl(h.amt7,0)) amt6,\n"+
				" decode(nvl(h.amt7,0),0,0,nvl(h.amt7,0)/(nvl(b.amt1,0)+nvl(c.amt2,0)-nvl(d.amt3,0))) per1,"+
				" decode((nvl(e.amt4,0)+nvl(f.amt5,0)+nvl(g.amt6,0)),0,0,(nvl(e.amt4,0)+nvl(f.amt5,0)+nvl(g.amt6,0))/(nvl(b.amt1,0)+nvl(c.amt2,0)-nvl(d.amt3,0))) per2"+
				" from\n"+ 
				" ( select "+dt+", car_st, count(*) tot_su from ("+sub_query+") group by "+dt+", car_st ) a,\n"+//월별
				" ( select "+dt+", car_st, count(*) su1, nvl(sum(pay_amt),0) amt1 from ("+sub_query+") where ins_tm2 ='1' group by "+dt+", car_st ) b,\n"+//당초
				" ( select "+dt+", car_st, count(*) su2, nvl(sum(pay_amt),0) amt2 from ("+sub_query+") where ins_tm2 ='2' group by "+dt+", car_st ) c,\n"+//추가
				" ( select "+dt+", car_st, count(*) su3, nvl(sum(pay_amt),0) amt3 from ("+sub_query+") where ins_tm2 ='3' group by "+dt+", car_st ) d,\n"+//해지
				" ( select "+dt+", car_st, count(*) su4, nvl(sum(hum_amt),0) amt4 from ("+sub_query2+") where hum_amt>0 group by "+dt+", car_st ) e,\n"+//대인
				" ( select "+dt+", car_st, count(*) su5, nvl(sum(mat_amt),0) amt5 from ("+sub_query3+") where mat_amt>0 group by "+dt+", car_st ) f,\n"+//대물
				" ( select "+dt+", car_st, count(*) su6, nvl(sum(one_amt),0) amt6 from ("+sub_query4+") where one_amt>0 group by "+dt+", car_st ) g,\n"+//자손
				" ( select "+dt+", car_st, count(*) su7, nvl(sum(tot_amt),0) amt7 from ("+sub_query5+") where tot_amt>0 group by "+dt+", car_st ) h\n"+//자차
				" where \n"+ 
				" a."+dt+"=b."+dt+"(+) and a.car_st=b.car_st(+)\n"+
				" and a."+dt+"=c."+dt+"(+) and a.car_st=c.car_st(+)\n"+
				" and a."+dt+"=d."+dt+"(+) and a.car_st=d.car_st(+)\n"+
				" and a."+dt+"=e."+dt+"(+) and a.car_st=e.car_st(+)\n"+
				" and a."+dt+"=f."+dt+"(+) and a.car_st=f.car_st(+)\n"+
				" and a."+dt+"=g."+dt+"(+) and a.car_st=g.car_st(+)\n"+
				" and a."+dt+"=h."+dt+"(+) and a.car_st=h.car_st(+)";

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
			
			System.out.println("[InsDatabase:getAccidStatList7_in1]"+ e);
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

	//사고현황-사고율관리리스트
	public Vector getAccidStatList7_in1(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc, String s_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";
		String sub_query2 = "";
		String sub_query3 = "";
		String sub_query4 = "";
		String sub_query5 = "";
		String dt = "pay_dt";

		//보험-지출스케줄에서
		sub_query = " select /*+  merge(b) */ substr(d.pay_dt,1,6) "+dt+", d.pay_amt,\n"+
					" decode(a.car_use,'1','렌트','리스') car_st,\n"+
					" a.ins_st, a.pay_tm, d.ins_tm, nvl(d.ins_tm2,'1') ins_tm2\n"+
					" from insur a, cont_n_view b, car_reg cr, (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) c, scd_ins d \n"+
					" where d.pay_yn='1' and a.car_mng_id=d.car_mng_id and a.ins_st=d.ins_st and a.car_mng_id=b.car_mng_id and a.car_mng_id = cr.car_mng_id(+) \n"+
					" and a.car_mng_id=b.car_mng_id and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd";

		if(gubun1.equals("1"))		sub_query += " and a.car_use='1'"; 
		if(gubun1.equals("2"))		sub_query += " and a.car_use<>'1'";

		if(gubun2.equals("1"))		sub_query += " and d.pay_dt = to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("2"))	sub_query += " and d.pay_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))	sub_query += " and d.pay_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
		else if(gubun2.equals("4"))	sub_query += " and d.pay_dt like '"+AddUtil.getDate(1)+"%'";
		else if(gubun2.equals("5"))	sub_query += " and d.pay_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		if(!brch_id.equals("S1") && !brch_id.equals(""))	sub_query += " and b.brch_id = '"+brch_id+"'"; 
		if(brch_id.equals("S1"))							sub_query += " and b.brch_id in ('S1','K1')"; 
		if(!br_id.equals("S1") && !br_id.equals(""))		sub_query += " and b.brch_id = '"+br_id+"'"; 


		//사고-대인보상금
		sub_query2 = " select /*+  merge(b) */  substr(a.hum_end_dt,1,6) "+dt+", a.hum_amt,\n"+
					" decode(cr.car_use,'1','렌트','리스') car_st\n"+
					" from accident a, cont_n_view b , car_reg cr \n"+
					" where a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.car_mng_id = cr.car_mng_id(+) ";

		if(gubun1.equals("1"))		sub_query2 += " and cr.car_use='1'"; 
		if(gubun1.equals("2"))		sub_query2 += " and cr.car_use<>'1'";

		if(gubun2.equals("1"))		sub_query2 += " and a.hum_end_dt = to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("2"))	sub_query2 += " and a.hum_end_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))	sub_query2 += " and a.hum_end_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
		else if(gubun2.equals("4"))	sub_query2 += " and a.hum_end_dt like '"+AddUtil.getDate(1)+"%'";
		else if(gubun2.equals("5"))	sub_query2 += " and a.hum_end_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		if(!brch_id.equals("S1") && !brch_id.equals(""))	sub_query2 += " and b.brch_id = '"+brch_id+"'"; 
		if(brch_id.equals("S1"))							sub_query2 += " and b.brch_id in ('S1','K1')"; 
		if(!br_id.equals("S1") && !br_id.equals(""))		sub_query2 += " and b.brch_id = '"+br_id+"'"; 


		//사고-대인보상금
		sub_query3 = " select /*+  merge(b) */ substr(a.mat_end_dt,1,6) "+dt+", a.mat_amt,\n"+
					" decode(cr.car_use,'1','렌트','리스') car_st\n"+
					" from accident a, cont_n_view b , car_reg cr \n"+
					" where a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.car_mng_id = cr.car_mng_id(+) ";

		if(gubun1.equals("1"))		sub_query3 += " and cr.car_use='1'"; 
		if(gubun1.equals("2"))		sub_query3 += " and cr.car_use<>'1'";

		if(gubun2.equals("1"))		sub_query3 += " and a.mat_end_dt = to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("2"))	sub_query3 += " and a.mat_end_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))	sub_query3 += " and a.mat_end_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
		else if(gubun2.equals("4"))	sub_query3 += " and a.mat_end_dt like '"+AddUtil.getDate(1)+"%'";
		else if(gubun2.equals("5"))	sub_query3 += " and a.mat_end_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		if(!brch_id.equals("S1") && !brch_id.equals(""))	sub_query3 += " and b.brch_id = '"+brch_id+"'"; 
		if(brch_id.equals("S1"))							sub_query3 += " and b.brch_id in ('S1','K1')"; 
		if(!br_id.equals("S1") && !br_id.equals(""))		sub_query3 += " and b.brch_id = '"+br_id+"'"; 


		//사고-자손보상금
		sub_query4 = " select /*+  merge(b) */  substr(a.one_end_dt,1,6) "+dt+", a.one_amt,\n"+
					" decode(cr.car_use,'1','렌트','리스') car_st\n"+
					" from accident a, cont_n_view b, car_reg cr \n"+
					" where a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.car_mng_id = cr.car_mng_id(+)";

		if(gubun1.equals("1"))		sub_query4 += " and cr.car_use='1'"; 
		if(gubun1.equals("2"))		sub_query4 += " and cr.car_use<>'1'";

		if(gubun2.equals("1"))		sub_query4 += " and a.one_end_dt = to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("2"))	sub_query4 += " and a.one_end_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))	sub_query4 += " and a.one_end_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
		else if(gubun2.equals("4"))	sub_query4 += " and a.one_end_dt like '"+AddUtil.getDate(1)+"%'";
		else if(gubun2.equals("5"))	sub_query4 += " and a.one_end_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		if(!brch_id.equals("S1") && !brch_id.equals(""))	sub_query4 += " and b.brch_id = '"+brch_id+"'"; 
		if(brch_id.equals("S1"))							sub_query4 += " and b.brch_id in ('S1','K1')"; 
		if(!br_id.equals("S1") && !br_id.equals(""))		sub_query4 += " and b.brch_id = '"+br_id+"'"; 


		//사고-자손보상금
		sub_query5 = " select /*+  merge(b) */ substr(c.set_dt,1,6) "+dt+", c.tot_amt,\n"+
					" decode(cr.car_use,'1','렌트','리스') car_st\n"+
					" from accident a, cont_n_view b, service c , car_reg cr \n"+
					" where a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.car_mng_id = cr.car_mng_id(+) \n"+
					" and a.car_mng_id=c.car_mng_id and a.accid_id=c.accid_id";

		if(gubun1.equals("1"))		sub_query5 += " and cr.car_use='1'"; 
		if(gubun1.equals("2"))		sub_query5 += " and cr.car_use<>'1'";

		if(gubun2.equals("1"))		sub_query5 += " and c.set_dt = to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("2"))	sub_query5 += " and c.set_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))	sub_query5 += " and c.set_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
		else if(gubun2.equals("4"))	sub_query5 += " and c.set_dt like '"+AddUtil.getDate(1)+"%'";
		else if(gubun2.equals("5"))	sub_query5 += " and c.set_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		if(!brch_id.equals("S1") && !brch_id.equals(""))	sub_query5 += " and b.brch_id = '"+brch_id+"'"; 
		if(brch_id.equals("S1"))							sub_query5 += " and b.brch_id in ('S1','K1')"; 
		if(!br_id.equals("S1") && !br_id.equals(""))		sub_query5 += " and b.brch_id = '"+br_id+"'"; 


		query = " select\n"+ 
				" substr(a."+dt+",5,2) "+dt+", a.car_st, a.tot_su,\n"+  
				" (nvl(b.su1,0)+nvl(c.su2,0)-nvl(d.su3,0)) su1,\n"+ 
				" nvl(e.su4,0) su2, nvl(f.su5,0) su3, nvl(g.su6,0) su4, nvl(h.su7,0) su5,\n"+
				" (nvl(e.su4,0)+nvl(f.su5,0)+nvl(g.su6,0)+nvl(h.su7,0)) su6,"+
				" (nvl(b.amt1,0)+nvl(c.amt2,0)-nvl(d.amt3,0)) amt1,\n"+ 
				" nvl(e.amt4,0) amt2, nvl(f.amt5,0) amt3, nvl(g.amt6,0) amt4, nvl(h.amt7,0) amt5,\n"+
				" (nvl(e.amt4,0)+nvl(f.amt5,0)+nvl(g.amt6,0)+nvl(h.amt7,0)) amt6\n"+
				" from\n"+ 
				" ( select "+dt+", car_st, count(0) tot_su from ("+sub_query+") group by "+dt+", car_st ) a,\n"+//월별
				" ( select "+dt+", car_st, count(0) su1, nvl(sum(pay_amt),0) amt1 from ("+sub_query+") where ins_tm2 ='1' group by "+dt+", car_st ) b,\n"+//당초
				" ( select "+dt+", car_st, count(0) su2, nvl(sum(pay_amt),0) amt2 from ("+sub_query+") where ins_tm2 ='2' group by "+dt+", car_st ) c,\n"+//추가
				" ( select "+dt+", car_st, count(0) su3, nvl(sum(pay_amt),0) amt3 from ("+sub_query+") where ins_tm2 ='3' group by "+dt+", car_st ) d,\n"+//해지
				" ( select "+dt+", car_st, count(0) su4, nvl(sum(hum_amt),0) amt4 from ("+sub_query2+") where hum_amt>0 group by "+dt+", car_st ) e,\n"+//대인
				" ( select "+dt+", car_st, count(0) su5, nvl(sum(mat_amt),0) amt5 from ("+sub_query3+") where mat_amt>0 group by "+dt+", car_st ) f,\n"+//대물
				" ( select "+dt+", car_st, count(0) su6, nvl(sum(one_amt),0) amt6 from ("+sub_query4+") where one_amt>0 group by "+dt+", car_st ) g,\n"+//자손
				" ( select "+dt+", car_st, count(0) su7, nvl(sum(tot_amt),0) amt7 from ("+sub_query5+") where tot_amt>0 group by "+dt+", car_st ) h\n"+//자차
				" where \n"+ 
				" a."+dt+"=b."+dt+"(+) and a.car_st=b.car_st(+)\n"+
				" and a."+dt+"=c."+dt+"(+) and a.car_st=c.car_st(+)\n"+
				" and a."+dt+"=d."+dt+"(+) and a.car_st=d.car_st(+)\n"+
				" and a."+dt+"=e."+dt+"(+) and a.car_st=e.car_st(+)\n"+
				" and a."+dt+"=f."+dt+"(+) and a.car_st=f.car_st(+)\n"+
				" and a."+dt+"=g."+dt+"(+) and a.car_st=g.car_st(+)\n"+
				" and a."+dt+"=h."+dt+"(+) and a.car_st=h.car_st(+)";

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
			
			System.out.println("[InsDatabase:getAccidStatList7_in1]"+ e);
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

	//보험현황-기간별리스트
	public Vector getInsStatList4(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";
		String sub_query2 = "";
		String sub_query3 = "";

		//신규,갱신
		sub_query = " select /*+  merge(b) */ substr(a.ins_start_dt,1,6) ins_start_dt,\n"+
					" decode(a.car_use,'1','렌트','리스') car_st,\n"+
					" a.ins_st, substr(a.exp_dt,1,6) exp_dt, decode(a.ins_kd, '', decode(a.vins_pcp_amt,0,'1','2'), a.ins_kd) ins_kd\n"+
					" from insur a, cont_n_view b, car_reg cr,  (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) c \n"+
					" where a.car_mng_id=b.car_mng_id  and a.car_mng_id = cr.car_mng_id(+) \n"+
					" and a.car_mng_id=b.car_mng_id and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd";

		if(!st_dt.equals("") && !end_dt.equals(""))		sub_query += " and a.ins_start_dt between '"+st_dt+"' and '"+end_dt+"'";
		if(!brch_id.equals(""))							sub_query += " and b.brch_id = '"+brch_id+"'";

		//해지
		sub_query2 = " select /*+  merge(b) */ substr(a.exp_dt,1,6) ins_start_dt,\n"+
					" decode(a.car_use,'1','렌트','리스') car_st,\n"+
					" a.ins_st, substr(a.exp_dt,1,6) exp_dt, nvl(a.ins_kd,'1') ins_kd\n"+
					" from insur a, cont_n_view b,  car_reg cr, (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) c \n"+
					" where a.car_mng_id=b.car_mng_id and a.car_mng_id = cr.car_mng_id(+)  \n"+
					" and a.car_mng_id=b.car_mng_id and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd";

		if(!st_dt.equals("") && !end_dt.equals(""))		sub_query2 += " and a.exp_dt between '"+st_dt+"' and '"+end_dt+"'";
		if(!brch_id.equals(""))							sub_query2 += " and b.brch_id = '"+brch_id+"'";
		if(!br_id.equals("S1") && !br_id.equals(""))	sub_query2 += " and b.brch_id = '"+br_id+"'"; 

		//변경
		sub_query3 = " select /*+  merge(b) */ substr(a.ch_dt,1,6) ins_start_dt,\n"+
					" decode(cr.car_use,'1','렌트','리스') car_st\n"+
					" from ins_change a, cont_n_view b, car_reg cr,  (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) c\n"+
					" where \n"+
					" a.car_mng_id=b.car_mng_id and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd and a.car_mng_id = cr.car_mng_id(+) ";

		if(!st_dt.equals("") && !end_dt.equals(""))		sub_query3 += " and a.ch_dt between '"+st_dt+"' and '"+end_dt+"'";
		if(!brch_id.equals(""))							sub_query3 += " and b.brch_id = '"+brch_id+"'";
		if(!br_id.equals("S1") && !br_id.equals(""))	sub_query3 += " and b.brch_id = '"+br_id+"'"; 


		query = " select\n"+ 
				" a.ins_start_dt, a.car_st, a.tot_su,\n"+  
				" nvl(b.su1,0) su1, nvl(c.su2,0) su2, nvl(d.su3,0) su3, nvl(e.su4,0) su4, nvl(f.su5,0) su5, nvl(g.su6,0) su6\n"+ 
				" from\n"+ 
				" ( select ins_start_dt, car_st, count(*) tot_su from ("+sub_query+") group by ins_start_dt, car_st ) a,\n"+//월별
				" ( select ins_start_dt, car_st, count(*) su1 from ("+sub_query+") where ins_st='0' group by ins_start_dt, car_st ) b,\n"+//신규 
				" ( select ins_start_dt, car_st, count(*) su2 from ("+sub_query+") where ins_st>'0' group by ins_start_dt, car_st ) c,\n"+//갱신 
				" ( select ins_start_dt, car_st, count(*) su3 from ("+sub_query3+") group by ins_start_dt, car_st ) d,\n"+//변경 
				" ( select ins_start_dt, car_st, count(*) su4 from ("+sub_query2+") group by ins_start_dt, car_st ) e,\n"+//해지 
				" ( select ins_start_dt, car_st, count(*) su5 from ("+sub_query+") where ins_kd='1' group by ins_start_dt, car_st ) f,\n"+//전담보 
				" ( select ins_start_dt, car_st, count(*) su6 from ("+sub_query+") where ins_kd='2' group by ins_start_dt, car_st ) g\n"+//책임보험 
				" where \n"+ 
				" a.ins_start_dt=b.ins_start_dt(+) and a.car_st=b.car_st(+)\n"+
				" and a.ins_start_dt=c.ins_start_dt(+) and a.car_st=c.car_st(+)\n"+
				" and a.ins_start_dt=d.ins_start_dt(+) and a.car_st=d.car_st(+)\n"+
				" and a.ins_start_dt=e.ins_start_dt(+) and a.car_st=e.car_st(+)\n"+
				" and a.ins_start_dt=f.ins_start_dt(+) and a.car_st=f.car_st(+)\n"+
				" and a.ins_start_dt=g.ins_start_dt(+) and a.car_st=g.car_st(+)";


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
			
			System.out.println("[InsDatabase:getInsStatList4]"+ e);
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

	//보험현황-기간별리스트2
	public Vector getInsStatList4(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc, String s_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";
		String sub_query2 = "";
		String sub_query3 = "";

		//신규,갱신
		sub_query = " select /*+  merge(b) */ substr(a.ins_start_dt,1,6) ins_start_dt,\n"+
					" decode(a.car_use,'1','렌트','리스') car_st,\n"+
					" a.ins_st, substr(a.exp_dt,1,6) exp_dt, decode(a.ins_kd, '', decode(a.vins_pcp_amt,0,'1','2'), a.ins_kd) ins_kd\n"+
					" from insur a, cont_n_view b, car_reg cr,  (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) c \n"+
					" where a.car_mng_id=b.car_mng_id  and a.car_mng_id = cr.car_mng_id(+) \n"+
					" and a.car_mng_id=b.car_mng_id and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd";

		if(gubun2.equals("1"))		sub_query += " and a.ins_start_dt = to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("2"))	sub_query += " and a.ins_start_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))	sub_query += " and a.ins_start_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
		else if(gubun2.equals("4"))	sub_query += " and a.ins_start_dt like '"+AddUtil.getDate(1)+"%'";
		else if(gubun2.equals("5"))	sub_query += " and a.ins_start_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		if(!brch_id.equals("S1") && !brch_id.equals(""))	sub_query += " and b.brch_id = '"+brch_id+"'"; 
		if(brch_id.equals("S1"))							sub_query += " and b.brch_id in ('S1','K1')"; 
		if(!br_id.equals("S1") && !br_id.equals(""))		sub_query += " and b.brch_id = '"+br_id+"'"; 


		//해지
		sub_query2 = " select /*+  merge(b) */ substr(a.exp_dt,1,6) ins_start_dt,\n"+
					" decode(a.car_use,'1','렌트','리스') car_st,\n"+
					" a.ins_st, substr(a.exp_dt,1,6) exp_dt, nvl(a.ins_kd,'1') ins_kd\n"+
					" from insur a, cont_n_view b, car_reg cr,  (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) c \n"+
					" where a.car_mng_id=b.car_mng_id and a.car_mng_id = cr.car_mng_id(+) \n"+
					" and a.car_mng_id=b.car_mng_id and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd";

		if(gubun2.equals("1"))		sub_query2 += " and a.exp_dt = to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("2"))	sub_query2 += " and a.exp_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))	sub_query2 += " and a.exp_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
		else if(gubun2.equals("4"))	sub_query2 += " and a.exp_dt like '"+AddUtil.getDate(1)+"%'";
		else if(gubun2.equals("5"))	sub_query2 += " and a.exp_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		if(!brch_id.equals("S1") && !brch_id.equals(""))	sub_query2 += " and b.brch_id = '"+brch_id+"'"; 
		if(brch_id.equals("S1"))							sub_query2 += " and b.brch_id in ('S1','K1')"; 
		if(!br_id.equals("S1") && !br_id.equals(""))		sub_query2 += " and b.brch_id = '"+br_id+"'"; 


		//변경
		sub_query3 = " select /*+  merge(b) */ substr(a.ch_dt,1,6) ins_start_dt,\n"+
					" decode(cr.car_use,'1','렌트','리스') car_st\n"+
					" from ins_change a, cont_n_view b, car_reg cr,  (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) c\n"+
					" where \n"+
					" a.car_mng_id=b.car_mng_id and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd and a.car_mng_id = cr.car_mng_id(+) ";

		if(gubun2.equals("1"))		sub_query3 += " and a.ch_dt = to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("2"))	sub_query3 += " and a.ch_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))	sub_query3 += " and a.ch_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
		else if(gubun2.equals("4"))	sub_query3 += " and a.ch_dt like '"+AddUtil.getDate(1)+"%'";
		else if(gubun2.equals("5"))	sub_query3 += " and a.ch_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		if(!brch_id.equals("S1") && !brch_id.equals(""))	sub_query3 += " and b.brch_id = '"+brch_id+"'"; 
		if(brch_id.equals("S1"))							sub_query3 += " and b.brch_id in ('S1','K1')"; 
		if(!br_id.equals("S1") && !br_id.equals(""))		sub_query3 += " and b.brch_id = '"+br_id+"'"; 


		query = " select\n"+ 
				" a.ins_start_dt, a.car_st, a.tot_su,\n"+  
				" nvl(b.su1,0) su1, nvl(c.su2,0) su2, nvl(d.su3,0) su3, nvl(e.su4,0) su4, nvl(f.su5,0) su5, nvl(g.su6,0) su6\n"+ 
				" from\n"+ 
				" ( select ins_start_dt, car_st, count(0) tot_su from ("+sub_query+") group by ins_start_dt, car_st ) a,\n"+//월별
				" ( select ins_start_dt, car_st, count(0) su1 from ("+sub_query+") where ins_st='0' group by ins_start_dt, car_st ) b,\n"+//신규 
				" ( select ins_start_dt, car_st, count(0) su2 from ("+sub_query+") where ins_st>'0' group by ins_start_dt, car_st ) c,\n"+//갱신 
				" ( select ins_start_dt, car_st, count(0) su3 from ("+sub_query3+") group by ins_start_dt, car_st ) d,\n"+//변경 
				" ( select ins_start_dt, car_st, count(0) su4 from ("+sub_query2+") group by ins_start_dt, car_st ) e,\n"+//해지 
				" ( select ins_start_dt, car_st, count(0) su5 from ("+sub_query+") where ins_kd='1' group by ins_start_dt, car_st ) f,\n"+//전담보 
				" ( select ins_start_dt, car_st, count(0) su6 from ("+sub_query+") where ins_kd='2' group by ins_start_dt, car_st ) g\n"+//책임보험 
				" where \n"+ 
				" a.ins_start_dt=b.ins_start_dt(+) and a.car_st=b.car_st(+)\n"+
				" and a.ins_start_dt=c.ins_start_dt(+) and a.car_st=c.car_st(+)\n"+
				" and a.ins_start_dt=d.ins_start_dt(+) and a.car_st=d.car_st(+)\n"+
				" and a.ins_start_dt=e.ins_start_dt(+) and a.car_st=e.car_st(+)\n"+
				" and a.ins_start_dt=f.ins_start_dt(+) and a.car_st=f.car_st(+)\n"+
				" and a.ins_start_dt=g.ins_start_dt(+) and a.car_st=g.car_st(+)";


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
			
			System.out.println("[InsDatabase:getInsStatList4]"+ e);
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

	//보험현황-보험사별리스트
	public Vector getInsStatList5(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";
		String sub_query2 = "";
		String sub_query3 = "";

		//신규,갱신
		sub_query = " select /*+  merge(b) */ a.ins_com_id,\n"+
					" decode(a.car_use,'1','렌트','리스') car_st,\n"+
					" a.ins_st, substr(a.exp_dt,1,6) exp_dt, decode(a.ins_kd, '', decode(a.vins_pcp_amt,0,'1','2'), a.ins_kd) ins_kd\n"+
					" from insur a, cont_n_view b, car_reg cr,  (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) c \n"+
					" where a.car_mng_id=b.car_mng_id and a.car_mng_id = cr.car_mng_id(+) \n"+
					" and a.car_mng_id=b.car_mng_id and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd";

		if(!st_dt.equals("") && !end_dt.equals(""))		sub_query += " and a.ins_start_dt between '"+st_dt+"' and '"+end_dt+"'";
		if(!brch_id.equals(""))							sub_query += " and b.brch_id = '"+brch_id+"'";

		//해지
		sub_query2 = " select /*+  merge(b) */ a.ins_com_id,\n"+
					" decode(a.car_use,'1','렌트','리스') car_st,\n"+
					" a.ins_st, substr(a.exp_dt,1,6) exp_dt, nvl(a.ins_kd,'1') ins_kd\n"+
					" from insur a, cont_n_view b, car_reg cr,  (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) c \n"+
					" where a.car_mng_id=b.car_mng_id  and a.car_mng_id = cr.car_mng_id(+) \n"+
					" and a.car_mng_id=b.car_mng_id and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd";

		if(!st_dt.equals("") && !end_dt.equals(""))		sub_query2 += " and a.exp_dt between '"+st_dt+"' and '"+end_dt+"'";
		if(!brch_id.equals(""))							sub_query2 += " and b.brch_id = '"+brch_id+"'";
		if(!br_id.equals("S1") && !br_id.equals(""))	sub_query2 += " and b.brch_id = '"+br_id+"'"; 

		//변경
		sub_query3 = " select /*+  merge(b) */ d.ins_com_id,\n"+
					" decode(cr.car_use,'1','렌트','리스') car_st\n"+
					" from ins_change a, cont_n_view b, car_reg cr, (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) c, insur d\n"+
					" where a.car_mng_id=d.car_mng_id and a.ins_st=d.ins_st and a.car_mng_id = cr.car_mng_id(+) \n"+
					" and a.car_mng_id=b.car_mng_id and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd";

		if(!st_dt.equals("") && !end_dt.equals(""))		sub_query3 += " and a.ch_dt between '"+st_dt+"' and '"+end_dt+"'";
		if(!brch_id.equals(""))							sub_query3 += " and b.brch_id = '"+brch_id+"'";
		if(!br_id.equals("S1") && !br_id.equals(""))	sub_query3 += " and b.brch_id = '"+br_id+"'"; 


		query = " select\n"+ 
				" a.ins_com_id, h.ins_com_nm, a.car_st, a.tot_su,\n"+  
				" nvl(b.su1,0) su1, nvl(c.su2,0) su2, nvl(d.su3,0) su3, nvl(e.su4,0) su4, nvl(f.su5,0) su5, nvl(g.su6,0) su6\n"+ 
				" from\n"+ 
				" ( select ins_com_id, car_st, count(*) tot_su from ("+sub_query+") group by ins_com_id, car_st ) a,\n"+//월별
				" ( select ins_com_id, car_st, count(*) su1 from ("+sub_query+") where ins_st='0' group by ins_com_id, car_st ) b,\n"+//신규 
				" ( select ins_com_id, car_st, count(*) su2 from ("+sub_query+") where ins_st>'0' group by ins_com_id, car_st ) c,\n"+//갱신 
				" ( select ins_com_id, car_st, count(*) su3 from ("+sub_query3+") group by ins_com_id, car_st ) d,\n"+//변경 
				" ( select ins_com_id, car_st, count(*) su4 from ("+sub_query2+") group by ins_com_id, car_st ) e,\n"+//해지 
				" ( select ins_com_id, car_st, count(*) su5 from ("+sub_query+") where ins_kd='1' group by ins_com_id, car_st ) f,\n"+//전담보 
				" ( select ins_com_id, car_st, count(*) su6 from ("+sub_query+") where ins_kd='2' group by ins_com_id, car_st ) g, ins_com h\n"+//책임보험 
				" where \n"+ 
				" a.ins_com_id=h.ins_com_id and a.ins_com_id=b.ins_com_id(+) and a.car_st=b.car_st(+)\n"+
				" and a.ins_com_id=c.ins_com_id(+) and a.car_st=c.car_st(+)\n"+
				" and a.ins_com_id=d.ins_com_id(+) and a.car_st=d.car_st(+)\n"+
				" and a.ins_com_id=e.ins_com_id(+) and a.car_st=e.car_st(+)\n"+
				" and a.ins_com_id=f.ins_com_id(+) and a.car_st=f.car_st(+)\n"+
				" and a.ins_com_id=g.ins_com_id(+) and a.car_st=g.car_st(+)";

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
			
			System.out.println("[InsDatabase:getInsStatList5]"+ e);
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

	//보험현황-보험사별리스트2
	public Vector getInsStatList5(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc, String s_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";
		String sub_query2 = "";
		String sub_query3 = "";

		//신규,갱신
		sub_query = " select a.ins_com_id,\n"+
					" decode(a.car_use,'1','렌트','리스') car_st,\n"+
					" a.ins_st, substr(a.exp_dt,1,6) exp_dt, decode(a.ins_kd, '', decode(a.vins_pcp_amt,0,'1','2'), a.ins_kd) ins_kd, d.ins_amt\n"+
					" from insur a, cont b, car_reg e, "+
					" (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) c, \n"+
					" (select car_mng_id, ins_st, sum(pay_amt) ins_amt from scd_ins group by car_mng_id, ins_st) d \n"+
					" where a.car_mng_id=b.car_mng_id and a.car_mng_id=e.car_mng_id \n"+
					" and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd and a.car_mng_id=d.car_mng_id(+) and a.ins_st=d.ins_st(+)";

		if(gubun2.equals("1"))		sub_query += " and a.ins_start_dt = to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("2"))	sub_query += " and a.ins_start_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))	sub_query += " and a.ins_start_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
		else if(gubun2.equals("4"))	sub_query += " and a.ins_start_dt like '"+AddUtil.getDate(1)+"%'";
		else if(gubun2.equals("5"))	sub_query += " and a.ins_start_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		if(!brch_id.equals("S1") && !brch_id.equals(""))	sub_query += " and b.brch_id = '"+brch_id+"'"; 
		if(brch_id.equals("S1"))							sub_query += " and b.brch_id in ('S1','K1')"; 
		if(!br_id.equals("S1") && !br_id.equals(""))		sub_query += " and b.brch_id = '"+br_id+"'"; 


		//해지
		sub_query2 = " select /*+  merge(b) */ a.ins_com_id,\n"+
					" decode(a.car_use,'1','렌트','리스') car_st,\n"+
					" a.ins_st, substr(a.exp_dt,1,6) exp_dt, nvl(a.ins_kd,'1') ins_kd, 0 ins_amt\n"+
					" from insur a, cont_n_view b, (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) c \n"+
					" where a.car_mng_id=b.car_mng_id \n"+
					" and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd";

		if(gubun2.equals("1"))		sub_query2 += " and a.exp_dt = to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("2"))	sub_query2 += " and a.exp_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))	sub_query2 += " and a.exp_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
		else if(gubun2.equals("4"))	sub_query2 += " and a.exp_dt like '"+AddUtil.getDate(1)+"%'";
		else if(gubun2.equals("5"))	sub_query2 += " and a.exp_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		if(!brch_id.equals("S1") && !brch_id.equals(""))	sub_query2 += " and b.brch_id = '"+brch_id+"'"; 
		if(brch_id.equals("S1"))							sub_query2 += " and b.brch_id in ('S1','K1')"; 
		if(!br_id.equals("S1") && !br_id.equals(""))		sub_query2 += " and b.brch_id = '"+br_id+"'"; 


		//변경
		sub_query3 = " select /*+  merge(b) */ d.ins_com_id,\n"+
					" decode(cr.car_use,'1','렌트','리스') car_st, 0 ins_amt\n"+
					" from ins_change a, cont_n_view b, car_reg cr,  (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) c, insur d\n"+
					" where a.car_mng_id=d.car_mng_id and a.ins_st=d.ins_st and a.car_mng_id =  cr.car_mng_id(+) \n"+
					" and a.car_mng_id=b.car_mng_id and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd";

		if(gubun2.equals("1"))		sub_query3 += " and a.ch_dt = to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("2"))	sub_query3 += " and a.ch_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))	sub_query3 += " and a.ch_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
		else if(gubun2.equals("4"))	sub_query3 += " and a.ch_dt like '"+AddUtil.getDate(1)+"%'";
		else if(gubun2.equals("5"))	sub_query3 += " and a.ch_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		if(!brch_id.equals("S1") && !brch_id.equals(""))	sub_query3 += " and b.brch_id = '"+brch_id+"'"; 
		if(brch_id.equals("S1"))							sub_query3 += " and b.brch_id in ('S1','K1')"; 
		if(!br_id.equals("S1") && !br_id.equals(""))		sub_query3 += " and b.brch_id = '"+br_id+"'"; 


		query = " select\n"+ 
				" a.ins_com_id, h.ins_com_nm, a.car_st, a.tot_su, a.tot_amt,\n"+  
				" nvl(b.su1,0) su1, nvl(c.su2,0) su2, nvl(d.su3,0) su3, nvl(e.su4,0) su4, nvl(f.su5,0) su5, nvl(g.su6,0) su6\n"+ 
				" from\n"+ 
				" ( select ins_com_id, car_st, count(0) tot_su, nvl(sum(ins_amt),0) tot_amt from ("+sub_query+") group by ins_com_id, car_st ) a,\n"+//월별
				" ( select ins_com_id, car_st, count(0) su1,    nvl(sum(ins_amt),0) amt1    from ("+sub_query+") where ins_st='0' group by ins_com_id, car_st ) b,\n"+//신규 
				" ( select ins_com_id, car_st, count(0) su2,    nvl(sum(ins_amt),0) amt2    from ("+sub_query+") where ins_st>'0' group by ins_com_id, car_st ) c,\n"+//갱신 
				" ( select ins_com_id, car_st, count(0) su3,    nvl(sum(ins_amt),0) amt3    from ("+sub_query3+") group by ins_com_id, car_st ) d,\n"+//변경 
				" ( select ins_com_id, car_st, count(0) su4,    nvl(sum(ins_amt),0) amt4    from ("+sub_query2+") group by ins_com_id, car_st ) e,\n"+//해지 
				" ( select ins_com_id, car_st, count(0) su5,    nvl(sum(ins_amt),0) amt5    from ("+sub_query+") where ins_kd='1' group by ins_com_id, car_st ) f,\n"+//전담보 
				" ( select ins_com_id, car_st, count(0) su6,    nvl(sum(ins_amt),0) amt6    from ("+sub_query+") where ins_kd='2' group by ins_com_id, car_st ) g, ins_com h\n"+//책임보험 
				" where \n"+ 
				" a.ins_com_id=h.ins_com_id and a.ins_com_id=b.ins_com_id(+) and a.car_st=b.car_st(+)\n"+
				" and a.ins_com_id=c.ins_com_id(+) and a.car_st=c.car_st(+)\n"+
				" and a.ins_com_id=d.ins_com_id(+) and a.car_st=d.car_st(+)\n"+
				" and a.ins_com_id=e.ins_com_id(+) and a.car_st=e.car_st(+)\n"+
				" and a.ins_com_id=f.ins_com_id(+) and a.car_st=f.car_st(+)\n"+
				" and a.ins_com_id=g.ins_com_id(+) and a.car_st=g.car_st(+)";

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
			
			System.out.println("[InsDatabase:getInsStatList5]"+ e);
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

	//보험현황-차량별리스트
	public Vector getInsStatList6(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";
		String sub_query2 = "";
		String sub_query3 = "";

		//신규,갱신
		sub_query = " select /*+  merge(b) */ a.car_mng_id,\n"+
					" decode(a.car_use,'1','렌트','리스') car_st,\n"+
					" a.ins_st, substr(a.exp_dt,1,6) exp_dt, decode(a.ins_kd, '', decode(a.vins_pcp_amt,0,'1','2'), a.ins_kd) ins_kd\n"+
					" from insur a, cont_n_view b, car_reg cr,  (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) c \n"+
					" where a.car_mng_id=b.car_mng_id  and a.car_mng_id = cr.car_mng_id(+) \n"+
					" and a.car_mng_id=b.car_mng_id and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd";

		if(!st_dt.equals("") && !end_dt.equals(""))		sub_query += " and a.ins_start_dt between '"+st_dt+"' and '"+end_dt+"'";
		if(!brch_id.equals(""))							sub_query += " and b.brch_id = '"+brch_id+"'";

		//해지
		sub_query2 = " select /*+  merge(b) */ a.car_mng_id,\n"+
					" decode(a.car_use,'1','렌트','리스') car_st,\n"+
					" a.ins_st, substr(a.exp_dt,1,6) exp_dt, nvl(a.ins_kd,'1') ins_kd\n"+
					" from insur a, cont_n_view b,  car_reg cr, (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) c \n"+
					" where a.car_mng_id=b.car_mng_id and a.car_mng_id = cr.car_mng_id(+) \n"+
					" and a.car_mng_id=b.car_mng_id and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd";

		if(!st_dt.equals("") && !end_dt.equals(""))		sub_query2 += " and a.exp_dt between '"+st_dt+"' and '"+end_dt+"'";
		if(!brch_id.equals(""))							sub_query2 += " and b.brch_id = '"+brch_id+"'";
		if(!br_id.equals("S1") && !br_id.equals(""))	sub_query2 += " and b.brch_id = '"+br_id+"'"; 

		//변경
		sub_query3 = " select /*+  merge(b) */ a.car_mng_id,\n"+
					" decode(cr.car_use,'1','렌트','리스') car_st\n"+
					" from ins_change a, cont_n_view b, car_reg cr,  (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) c, insur d\n"+
					" where a.car_mng_id=d.car_mng_id and a.ins_st=d.ins_st and a.car_mng_id = cr.car_mng_id(+) \n"+
					" and a.car_mng_id=b.car_mng_id and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd";

		if(!st_dt.equals("") && !end_dt.equals(""))		sub_query3 += " and a.ch_dt between '"+st_dt+"' and '"+end_dt+"'";
		if(!brch_id.equals(""))							sub_query3 += " and b.brch_id = '"+brch_id+"'";
		if(!br_id.equals("S1") && !br_id.equals(""))	sub_query3 += " and b.brch_id = '"+br_id+"'"; 


		query = " select\n"+ 
				" a.car_mng_id, h.car_no, a.tot_su,\n"+  
				" nvl(b.su1,0) su1, nvl(c.su2,0) su2, nvl(d.su3,0) su3, nvl(e.su4,0) su4, nvl(f.su5,0) su5, nvl(g.su6,0) su6\n"+ 
				" from\n"+ 
				" ( select car_mng_id, count(*) tot_su from ("+sub_query+") group by car_mng_id ) a,\n"+//월별
				" ( select car_mng_id, count(*) su1 from ("+sub_query+") where ins_st='0' group by car_mng_id ) b,\n"+//신규 
				" ( select car_mng_id, count(*) su2 from ("+sub_query+") where ins_st>'0' group by car_mng_id ) c,\n"+//갱신 
				" ( select car_mng_id, count(*) su3 from ("+sub_query3+") group by car_mng_id ) d,\n"+//변경 
				" ( select car_mng_id, count(*) su4 from ("+sub_query2+") group by car_mng_id ) e,\n"+//해지 
				" ( select car_mng_id, count(*) su5 from ("+sub_query+") where ins_kd='1' group by car_mng_id ) f,\n"+//전담보 
				" ( select car_mng_id, count(*) su6 from ("+sub_query+") where ins_kd='2' group by car_mng_id ) g, car_reg h\n"+//책임보험 
				" where \n"+ 
				" a.car_mng_id=h.car_mng_id and a.car_mng_id=b.car_mng_id(+)\n"+
				" and a.car_mng_id=c.car_mng_id(+)\n"+
				" and a.car_mng_id=d.car_mng_id(+)\n"+
				" and a.car_mng_id=e.car_mng_id(+)\n"+
				" and a.car_mng_id=f.car_mng_id(+)\n"+
				" and a.car_mng_id=g.car_mng_id(+)";

		if(sort.equals("1"))		query += " order by h.car_no "+asc;
		if(sort.equals("2"))		query += " order by a.tot_su "+asc+", h.car_no";
		if(sort.equals("3"))		query += " order by nvl(b.su1,0) "+asc+", h.car_no";
		if(sort.equals("4"))		query += " order by nvl(c.su2,0) "+asc+", h.car_no";
		if(sort.equals("5"))		query += " order by nvl(d.su3,0) "+asc+", h.car_no";
		if(sort.equals("6"))		query += " order by nvl(e.su4,0) "+asc+", h.car_no";
		if(sort.equals("7"))		query += " order by nvl(f.su5,0) "+asc+", h.car_no";
		if(sort.equals("8"))		query += " order by nvl(g.su6,0) "+asc+", h.car_no";

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
			
			System.out.println("[InsDatabase:getInsStatList6]"+ e);
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

	//보험현황-차량별리스트2
	public Vector getInsStatList6(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc, String s_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";
		String sub_query2 = "";
		String sub_query3 = "";

		//신규,갱신
		sub_query = " select /*+  merge(b) */ a.car_mng_id,\n"+
					" decode(cr.car_use,'1','렌트','리스') car_st,\n"+
					" a.ins_st, substr(a.exp_dt,1,6) exp_dt, decode(a.ins_kd, '', decode(a.vins_pcp_amt,0,'1','2'), a.ins_kd) ins_kd\n"+
					" from insur a, cont_n_view b, car_reg cr,  (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) c \n"+
					" where a.car_mng_id=b.car_mng_id and a.car_mng_id = cr.car_mng_id(+)  \n"+
					" and a.car_mng_id=b.car_mng_id and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd";

		if(gubun1.equals("1"))		sub_query += " and a.car_use='1'"; 
		if(gubun1.equals("2"))		sub_query += " and a.car_use<>'1'";

		if(gubun2.equals("1"))		sub_query += " and a.ins_start_dt = to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("2"))	sub_query += " and a.ins_start_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))	sub_query += " and a.ins_start_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
		else if(gubun2.equals("4"))	sub_query += " and a.ins_start_dt like '"+AddUtil.getDate(1)+"%'";
		else if(gubun2.equals("5"))	sub_query += " and a.ins_start_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		if(!brch_id.equals("S1") && !brch_id.equals(""))	sub_query += " and b.brch_id = '"+brch_id+"'"; 
		if(brch_id.equals("S1"))							sub_query += " and b.brch_id in ('S1','K1')"; 
		if(!br_id.equals("S1") && !br_id.equals(""))		sub_query += " and b.brch_id = '"+br_id+"'"; 

		
		//해지
		sub_query2 = " select /*+  merge(b) */ a.car_mng_id,\n"+
					" decode(a.car_use,'1','렌트','리스') car_st,\n"+
					" a.ins_st, substr(a.exp_dt,1,6) exp_dt, nvl(a.ins_kd,'1') ins_kd\n"+
					" from insur a, cont_n_view b, car_reg cr,  (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) c \n"+
					" where a.car_mng_id=b.car_mng_id  and a.car_mng_id = cr.car_mng_id(+) \n"+
					" and a.car_mng_id=b.car_mng_id and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd";

		if(gubun1.equals("1"))		sub_query2 += " and a.car_use='1'"; 
		if(gubun1.equals("2"))		sub_query2 += " and a.car_use<>'1'";

		if(gubun2.equals("1"))		sub_query2 += " and a.exp_dt = to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("2"))	sub_query2 += " and a.exp_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))	sub_query2 += " and a.exp_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
		else if(gubun2.equals("4"))	sub_query2 += " and a.exp_dt like '"+AddUtil.getDate(1)+"%'";
		else if(gubun2.equals("5"))	sub_query2 += " and a.exp_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		if(!brch_id.equals("S1") && !brch_id.equals(""))	sub_query2 += " and b.brch_id = '"+brch_id+"'"; 
		if(brch_id.equals("S1"))							sub_query2 += " and b.brch_id in ('S1','K1')"; 
		if(!br_id.equals("S1") && !br_id.equals(""))		sub_query2 += " and b.brch_id = '"+br_id+"'"; 


		//변경
		sub_query3 = " select /*+  merge(b) */ a.car_mng_id,\n"+
					" decode(cr.car_use,'1','렌트','리스') car_st\n"+
					" from ins_change a, cont_n_view b,  car_reg cr, (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) c, insur d\n"+
					" where a.car_mng_id=d.car_mng_id and a.ins_st=d.ins_st and a.car_mng_id = cr.car_mng_id(+) \n"+
					" and a.car_mng_id=b.car_mng_id and b.car_mng_id=c.car_mng_id and b.rent_l_cd=c.rent_l_cd";

		if(gubun1.equals("1"))		sub_query3 += " and cr.car_use='1'"; 
		if(gubun1.equals("2"))		sub_query3 += " and cr.car_use<>'1'";

		if(gubun2.equals("1"))		sub_query3 += " and a.ch_dt = to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("2"))	sub_query3 += " and a.ch_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))	sub_query3 += " and a.ch_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
		else if(gubun2.equals("4"))	sub_query3 += " and a.ch_dt like '"+AddUtil.getDate(1)+"%'";
		else if(gubun2.equals("5"))	sub_query3 += " and a.ch_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		if(!brch_id.equals("S1") && !brch_id.equals(""))	sub_query3 += " and b.brch_id = '"+brch_id+"'"; 
		if(brch_id.equals("S1"))							sub_query3 += " and b.brch_id in ('S1','K1')"; 
		if(!br_id.equals("S1") && !br_id.equals(""))		sub_query3 += " and b.brch_id = '"+br_id+"'"; 


		query = " select\n"+ 
				" a.car_mng_id, h.car_no, a.tot_su,\n"+  
				" nvl(b.su1,0) su1, nvl(c.su2,0) su2, nvl(d.su3,0) su3, nvl(e.su4,0) su4, nvl(f.su5,0) su5, nvl(g.su6,0) su6\n"+ 
				" from\n"+ 
				" ( select car_mng_id, count(0) tot_su from ("+sub_query+") group by car_mng_id ) a,\n"+//월별
				" ( select car_mng_id, count(0) su1 from ("+sub_query+") where ins_st='0' group by car_mng_id ) b,\n"+//신규 
				" ( select car_mng_id, count(0) su2 from ("+sub_query+") where ins_st>'0' group by car_mng_id ) c,\n"+//갱신 
				" ( select car_mng_id, count(0) su3 from ("+sub_query3+") group by car_mng_id ) d,\n"+//변경 
				" ( select car_mng_id, count(0) su4 from ("+sub_query2+") group by car_mng_id ) e,\n"+//해지 
				" ( select car_mng_id, count(0) su5 from ("+sub_query+") where ins_kd='1' group by car_mng_id ) f,\n"+//전담보 
				" ( select car_mng_id, count(0) su6 from ("+sub_query+") where ins_kd='2' group by car_mng_id ) g, car_reg h\n"+//책임보험 
				" where \n"+ 
				" a.car_mng_id=h.car_mng_id and a.car_mng_id=b.car_mng_id(+)\n"+
				" and a.car_mng_id=c.car_mng_id(+)\n"+
				" and a.car_mng_id=d.car_mng_id(+)\n"+
				" and a.car_mng_id=e.car_mng_id(+)\n"+
				" and a.car_mng_id=f.car_mng_id(+)\n"+
				" and a.car_mng_id=g.car_mng_id(+)";

		if(sort.equals("1"))		query += " order by h.car_no "+asc;
		if(sort.equals("2"))		query += " order by a.tot_su "+asc+", h.car_no";
		if(sort.equals("3"))		query += " order by nvl(b.su1,0) "+asc+", h.car_no";
		if(sort.equals("4"))		query += " order by nvl(c.su2,0) "+asc+", h.car_no";
		if(sort.equals("5"))		query += " order by nvl(d.su3,0) "+asc+", h.car_no";
		if(sort.equals("6"))		query += " order by nvl(e.su4,0) "+asc+", h.car_no";
		if(sort.equals("7"))		query += " order by nvl(f.su5,0) "+asc+", h.car_no";
		if(sort.equals("8"))		query += " order by nvl(g.su6,0) "+asc+", h.car_no";
//System.out.println("[InsDatabase:getInsStatList6]"+ query);
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
			
			System.out.println("[InsDatabase:getInsStatList6]"+ e);
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
		query = "select /*+  merge(C) */ \n"+
				" I.CAR_MNG_ID, I.INS_ST, I.INS_STS, I.AGE_SCP,\n"+
				" I.CAR_USE, I.INS_COM_ID, I.INS_CON_NO,\n"+
				" I.CONR_NM, I.INS_START_DT, I.INS_EXP_DT,\n"+
				" DECODE(I.INS_START_DT, '', '', SUBSTR(I.INS_START_DT, 1, 4)||'-'||SUBSTR(I.INS_START_DT, 5, 2)||'-'||SUBSTR(I.INS_START_DT, 7, 2)) INS_START_DT2,\n"+
				" DECODE(I.INS_EXP_DT, '', '', SUBSTR(I.INS_EXP_DT, 1, 4)||'-'||SUBSTR(I.INS_EXP_DT, 5, 2)||'-'||SUBSTR(I.INS_EXP_DT, 7, 2)) INS_EXP_DT2,\n"+
				" I.RINS_PCP_AMT, I.VINS_PCP_AMT, I.VINS_PCP_KD,\n"+
				" I.VINS_GCP_AMT, I.VINS_GCP_KD, I.VINS_BACDT_AMT, I.VINS_BACDT_KD, I.VINS_CACDT_AMT,\n"+
				" I.VINS_BACDT_KC2, I.VINS_SPE, I.VINS_SPE_AMT,\n"+
				" I.vins_canoisr_amt, I.vins_cacdt_car_amt, I.vins_cacdt_me_amt, I.vins_cacdt_cm_amt, I.vins_share_extra_amt, \n"+
				" I.PAY_TM,\n"+
				" DECODE(I.CHANGE_DT, '', '', SUBSTR(I.CHANGE_DT, 1, 4)||'-'||SUBSTR(I.CHANGE_DT, 5, 2)||'-'||SUBSTR(I.CHANGE_DT, 7, 2)) CHANGE_DT,\n"+
				" I.CHANGE_CAU, I.CHANGE_ITM_KD1,\n"+
				" I.CHANGE_ITM_AMT1, I.CHANGE_ITM_KD2,\n"+
				" I.CHANGE_ITM_AMT2, I.CHANGE_ITM_KD3,\n"+
				" I.CHANGE_ITM_AMT3, I.CHANGE_ITM_KD4,\n"+
				" I.CHANGE_ITM_AMT4, CHANGE_ITM_AMT4, I.CAR_RATE, I.INS_RATE,\n"+
				" I.EXT_RATE, I.AIR_DS_YN, I.AIR_AS_YN, I.AGNT_NM,\n"+
				" I.AGNT_TEL, nvl(I.AGNT_IMGN_TEL, M.AGNT_IMGN_TEL) AGNT_IMGN_TEL, I.AGNT_FAX,\n"+
				" DECODE(I.EXP_DT, '', '', SUBSTR(I.EXP_DT, 1, 4)||'-'||SUBSTR(I.EXP_DT, 5, 2)||'-'||SUBSTR(I.EXP_DT, 7, 2)) EXP_DT,\n"+
				" I.EXP_CAU, I.RTN_AMT,\n"+
				" (I.CHANGE_ITM_AMT1+I.CHANGE_ITM_AMT2+I.CHANGE_ITM_AMT3+I.CHANGE_ITM_AMT4) change_amt,\n"+
				" I.CON_F_NM, I.AGNT_DEPT, nvl(I.ACC_TEL, M.ACC_TEL) ACC_TEL, I.RTN_DT, I.enable_renew, I.scan_file, I.update_id, I.update_dt,\n"+
				" DECODE(SIGN(TRUNC(TO_DATE(I.ins_exp_dt, 'YYYYMMDD')-SYSDATE)), -1, 'N', 'Y') use_yn,\n"+	//Y:유효, N:만료
				" C.FIRM_NM, C.CLIENT_NM, cr.car_num, CN.CAR_NAME,\n"+
				" C.RENT_L_CD, C.car_ja, cr.car_no, cr.car_nm, M.ins_com_nm,\n"+
				" I.CHANGE_DT1, I.CHANGE_DT2, I.CHANGE_DT3, I.CHANGE_DT4,"+
				" I.CHANGE_INS_NO1, I.CHANGE_INS_NO2, I.CHANGE_INS_NO3, I.CHANGE_INS_NO4,"+
				" I.CHANGE_INS_START_DT1, I.CHANGE_INS_START_DT2, I.CHANGE_INS_START_DT3, I.CHANGE_INS_START_DT4,"+
				" I.CHANGE_INS_EXP_DT1, I.CHANGE_INS_EXP_DT2, I.CHANGE_INS_EXP_DT3, I.CHANGE_INS_EXP_DT4,"+
				" I.ins_kd, I.reg_cau, I.exp_st, I.auto_yn, I.abs_yn, I.blackbox_yn, I.vins_blackbox_amt, I.vins_blackbox_per, I.com_emp_yn, "+
                " I.blackbox_nm, I.blackbox_amt, I.blackbox_no, I.blackbox_dt, I.enp_no, I.lkas_yn, I.ldws_yn, I.aeb_yn, I.fcw_yn, I.ev_yn, I.others, I.others_device "+
				" from insur I, cont_n_view C, car_reg cr,   car_etc g, car_nm cn, INS_COM M, (select max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) E\n"+
				" where I.car_mng_id = C.car_mng_id and\n"+				
				" 	C.rent_l_cd = E.rent_l_cd\n"+
				"	and I.car_mng_id = cr.car_mng_id(+)  and c.rent_mng_id = g.rent_mng_id(+)  and c.rent_l_cd = g.rent_l_cd(+)  \n"+
                       		"	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+) \n"+
				"        and I.ins_com_id = M.ins_com_id and\n"+
				"      I.CAR_MNG_ID = ? and I.INS_ST = ? \n";
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
				ins.setIns_kd(rs.getString("INS_KD")==null?"":rs.getString("INS_KD"));
				ins.setReg_cau(rs.getString("REG_CAU")==null?"":rs.getString("REG_CAU"));
				ins.setExp_st(rs.getString("EXP_ST")==null?"":rs.getString("EXP_ST"));
				ins.setAuto_yn(rs.getString("AUTO_YN")==null?"":rs.getString("AUTO_YN"));
				ins.setAbs_yn(rs.getString("ABS_YN")==null?"":rs.getString("ABS_YN"));
				ins.setBlackbox_yn(rs.getString("blackbox_yn")==null?"":rs.getString("blackbox_yn"));
				ins.setVins_share_extra_amt(rs.getInt("vins_share_extra_amt"));
				ins.setVins_blackbox_amt(rs.getInt("vins_blackbox_amt"));
				ins.setVins_blackbox_per(rs.getString("vins_blackbox_per")==null?"":rs.getString("vins_blackbox_per"));
				ins.setCom_emp_yn(rs.getString("com_emp_yn")==null?"":rs.getString("com_emp_yn"));
				ins.setBlackbox_nm(rs.getString("blackbox_nm")==null?"":rs.getString("blackbox_nm"));
				ins.setBlackbox_amt(rs.getInt("blackbox_amt"));
				ins.setBlackbox_no(rs.getString("blackbox_no")==null?"":rs.getString("blackbox_no"));
				ins.setBlackbox_dt(rs.getString("blackbox_dt")==null?"":rs.getString("blackbox_dt"));
				ins.setEnp_no(rs.getString("enp_no")==null?"":rs.getString("enp_no"));
				ins.setLkas_yn(rs.getString("lkas_yn")==null?"":rs.getString("lkas_yn"));
				ins.setLdws_yn(rs.getString("ldws_yn")==null?"":rs.getString("ldws_yn"));
				ins.setAeb_yn(rs.getString("aeb_yn")==null?"":rs.getString("aeb_yn"));
				ins.setFcw_yn(rs.getString("fcw_yn")==null?"":rs.getString("fcw_yn"));
				ins.setEv_yn(rs.getString("ev_yn")==null?"":rs.getString("ev_yn"));
				ins.setOthers(rs.getString("others")==null?"":rs.getString("others"));
				ins.setOthers_device(rs.getString("others_device")==null?"":rs.getString("others_device"));

			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[InsDatabase:getIns]"+ e);
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
				ins.setReg_id(rs.getString("REG_ID")==null?"":rs.getString("REG_ID"));
				ins.setReg_dt(rs.getString("REG_DT")==null?"":rs.getString("REG_DT"));
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
				ins.setReg_cau(rs.getString("REG_CAU")==null?"":rs.getString("REG_CAU"));
				ins.setExp_st(rs.getString("EXP_ST")==null?"":rs.getString("EXP_ST"));
				ins.setAuto_yn(rs.getString("AUTO_YN")==null?"":rs.getString("AUTO_YN"));
				ins.setAbs_yn(rs.getString("ABS_YN")==null?"":rs.getString("ABS_YN"));
				ins.setIns_rent_dt(rs.getString("INS_RENT_DT")==null?"":rs.getString("INS_RENT_DT"));
				ins.setVins_cacdt_memin_amt(rs.getInt("VINS_CACDT_MEMIN_AMT"));
				ins.setVins_cacdt_mebase_amt(rs.getInt("VINS_CACDT_MEBASE_AMT"));
				ins.setBlackbox_yn(rs.getString("BLACKBOX_YN")==null?"":rs.getString("BLACKBOX_YN"));
				ins.setVins_share_extra_amt(rs.getInt("vins_share_extra_amt"));
				ins.setVins_blackbox_amt(rs.getInt("vins_blackbox_amt"));
				ins.setVins_blackbox_per(rs.getString("vins_blackbox_per")==null?"":rs.getString("vins_blackbox_per"));
				ins.setCom_emp_yn(rs.getString("com_emp_yn")==null?"":rs.getString("com_emp_yn"));
				ins.setFirm_emp_nm(rs.getString("firm_emp_nm")==null?"":rs.getString("firm_emp_nm"));
				ins.setLong_emp_yn(rs.getString("long_emp_yn")==null?"":rs.getString("long_emp_yn"));
				ins.setBlackbox_nm(rs.getString("blackbox_nm")==null?"":rs.getString("blackbox_nm"));
				ins.setBlackbox_amt(rs.getInt("blackbox_amt"));
				ins.setBlackbox_no(rs.getString("blackbox_no")==null?"":rs.getString("blackbox_no"));
				ins.setBlackbox_dt(rs.getString("blackbox_dt")==null?"":rs.getString("blackbox_dt"));
				ins.setEnp_no(rs.getString("enp_no")==null?"":rs.getString("enp_no"));
				ins.setLkas_yn(rs.getString("lkas_yn")==null?"":rs.getString("lkas_yn"));
				ins.setLdws_yn(rs.getString("ldws_yn")==null?"":rs.getString("ldws_yn"));
				ins.setAeb_yn(rs.getString("aeb_yn")==null?"":rs.getString("aeb_yn"));
				ins.setFcw_yn(rs.getString("fcw_yn")==null?"":rs.getString("fcw_yn"));
				ins.setEv_yn(rs.getString("ev_yn")==null?"":rs.getString("ev_yn"));
				ins.setOthers(rs.getString("OTHERS")==null?"":rs.getString("OTHERS"));
				ins.setOthers_device(rs.getString("OTHERS_DEVICE")==null?"":rs.getString("OTHERS_DEVICE"));
				ins.setHook_yn(rs.getString("HOOK_YN")==null?"":rs.getString("HOOK_YN"));
				ins.setLegal_yn(rs.getString("LEGAL_YN")==null?"":rs.getString("LEGAL_YN"));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[InsDatabase:getInsCase]"+ e);
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
		String query = "insert into insur ("+ 
				" CAR_MNG_ID, INS_ST, INS_STS, AGE_SCP, CAR_USE, INS_COM_ID, INS_CON_NO, CONR_NM, INS_START_DT, INS_EXP_DT,"+
				" RINS_PCP_AMT, VINS_PCP_KD, VINS_PCP_AMT, VINS_GCP_KD, VINS_GCP_AMT, VINS_BACDT_KD, VINS_BACDT_AMT, VINS_CACDT_AMT, PAY_TM, CHANGE_DT,"+
				" CHANGE_CAU, CHANGE_ITM_KD1, CHANGE_ITM_AMT1, CHANGE_ITM_KD2, CHANGE_ITM_AMT2, CHANGE_ITM_KD3, CHANGE_ITM_AMT3, CHANGE_ITM_KD4, CHANGE_ITM_AMT4, CAR_RATE,"+
				" INS_RATE, EXT_RATE, AIR_DS_YN, AIR_AS_YN, AGNT_NM, AGNT_TEL, AGNT_IMGN_TEL, AGNT_FAX, EXP_DT, EXP_CAU,"+
				" RTN_AMT, RTN_DT, ENABLE_RENEW, CON_F_NM, AGNT_DEPT, ACC_TEL, VINS_BACDT_KC2, VINS_SPE, VINS_SPE_AMT, SCAN_FILE,"+
				" REG_ID, REG_DT, UPDATE_ID, UPDATE_DT, VINS_CANOISR_AMT, VINS_CACDT_CAR_AMT, VINS_CACDT_ME_AMT, VINS_CACDT_CM_AMT, INS_KD, REG_CAU,"+
				" AUTO_YN, ABS_YN, INS_RENT_DT, VINS_CACDT_MEMIN_AMT, VINS_CACDT_MEBASE_AMT, blackbox_yn, vins_share_extra_amt, vins_blackbox_amt, vins_blackbox_per, com_emp_yn,"+//추가
				" FIRM_EMP_NM , LONG_EMP_YN, blackbox_nm, blackbox_amt, blackbox_no, blackbox_dt, enp_no , lkas_yn, ldws_yn, aeb_yn,"+//추가
				" fcw_yn, ev_yn, others, others_device, com_emp_start_dt, com_emp_exp_dt, hook_yn, legal_yn "+
				" ) values("+
				" ?, ?, ?, ?, ?, ?, ?, ?, replace(?, '-', ''), replace(?, '-', ''),"+
				" ?, ?, ?, ?, ?, ?, ?, ?, ?, replace(?, '-', ''),"+
				" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				" ?, ?, ?, ?, ?, ?, ?, ?, replace(?, '-', ''), ?,"+
				" ?, replace(?, '-', ''), ?, ?, ?, ?, ?, ?, ?, ?,"+
				" ?, to_char(sysdate,'YYYYMMDD'), ?, to_char(sysdate,'YYYYMMDD'), ?, ?, ?, ?, ?, ?,"+
				" ?, ?, replace(?, '-', ''), ?, ?, ?, ?, ?, ?, ?,"+
				" ?, ?, ?, ?, ?, replace(?, '-', ''), ?, ?, ?, ?," +
				" ?, ?, ?, ?, replace(?, '-', ''),replace(?, '-', ''), ?, ?"+ 
				" )";

		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,  ins.getCar_mng_id()			);
			pstmt.setString	(2,  ins.getIns_st()				);
		    pstmt.setString	(3,  ins.getIns_sts()				);
			pstmt.setString	(4,  ins.getAge_scp()				);
			pstmt.setString	(5,  ins.getCar_use()				);
			pstmt.setString	(6,  ins.getIns_com_id()			);
			pstmt.setString	(7,  ins.getIns_con_no()			);
			pstmt.setString	(8,  ins.getConr_nm()				);
			pstmt.setString	(9,  ins.getIns_start_dt()			);
			pstmt.setString	(10, ins.getIns_exp_dt()			);
			pstmt.setInt	(11, ins.getRins_pcp_amt()			);
			pstmt.setString	(12, ins.getVins_pcp_kd()			);
			pstmt.setInt	(13, ins.getVins_pcp_amt()			);
			pstmt.setString	(14, ins.getVins_gcp_kd()			);
			pstmt.setInt	(15, ins.getVins_gcp_amt()			);
			pstmt.setString	(16, ins.getVins_bacdt_kd()			);
			pstmt.setInt	(17, ins.getVins_bacdt_amt()		);
			pstmt.setInt	(18, ins.getVins_cacdt_amt()		);
			pstmt.setString	(19, ins.getPay_tm()				);
			pstmt.setString	(20, ins.getChange_dt()				);
			pstmt.setString	(21, ins.getChange_cau()			);
			pstmt.setString	(22, ins.getChange_itm_kd1()		);
			pstmt.setInt	(23, ins.getChange_itm_amt1()		);
			pstmt.setString	(24, ins.getChange_itm_kd2()		);
			pstmt.setInt	(25, ins.getChange_itm_amt2()		);
			pstmt.setString	(26, ins.getChange_itm_kd3()		);
			pstmt.setInt	(27, ins.getChange_itm_amt3()		);
			pstmt.setString	(28, ins.getChange_itm_kd4()		);
			pstmt.setInt	(29, ins.getChange_itm_amt4()		);
			pstmt.setString	(30, ins.getCar_rate()				);
			pstmt.setString	(31, ins.getIns_rate()				);
			pstmt.setString	(32, ins.getExt_rate()				);
			pstmt.setString	(33, ins.getAir_ds_yn()				);
			pstmt.setString	(34, ins.getAir_as_yn()				);
			pstmt.setString	(35, ins.getAgnt_nm()				);
			pstmt.setString	(36, ins.getAgnt_tel()				);
			pstmt.setString	(37, ins.getAgnt_imgn_tel()			);
			pstmt.setString	(38, ins.getAgnt_fax()				);
			pstmt.setString	(39, ins.getExp_dt()				);
			pstmt.setString	(40, ins.getExp_cau()				);
			pstmt.setInt	(41, ins.getRtn_amt()				);
			pstmt.setString	(42, ins.getRtn_dt()				);
			pstmt.setString	(43, ins.getEnable_renew()			);
			pstmt.setString	(44, ins.getCon_f_nm()				);
			pstmt.setString	(45, ins.getAcc_tel()				);	
			pstmt.setString	(46, ins.getAgnt_dept()				);
			pstmt.setString	(47, ins.getVins_bacdt_kc2()		);
			pstmt.setString	(48, ins.getVins_spe()				);
			pstmt.setInt	(49, ins.getVins_spe_amt()			);
			pstmt.setString	(50, ins.getScan_file()				);
			pstmt.setString	(51, ins.getReg_id()				);
			pstmt.setString	(52, ins.getReg_id()				);
			pstmt.setInt	(53, ins.getVins_canoisr_amt()		);
			pstmt.setInt	(54, ins.getVins_cacdt_car_amt()	);
			pstmt.setInt	(55, ins.getVins_cacdt_me_amt()		);
			pstmt.setInt	(56, ins.getVins_cacdt_cm_amt()		);
			pstmt.setString	(57, ins.getIns_kd()				);
			pstmt.setString	(58, ins.getReg_cau()				);
			pstmt.setString	(59, ins.getAuto_yn()				);
			pstmt.setString	(60, ins.getAbs_yn()				);
			pstmt.setString	(61, ins.getIns_rent_dt()			);
			pstmt.setInt	(62, ins.getVins_cacdt_memin_amt()	);
			pstmt.setInt	(63, ins.getVins_cacdt_mebase_amt()	);
			pstmt.setString	(64, ins.getBlackbox_yn()			);
			pstmt.setInt	(65, ins.getVins_share_extra_amt()	);
			pstmt.setInt	(66, ins.getVins_blackbox_amt()		);
			pstmt.setString	(67, ins.getVins_blackbox_per()		);
			pstmt.setString	(68, ins.getCom_emp_yn()			);
			pstmt.setString	(69, ins.getFirm_emp_nm()			);
			pstmt.setString	(70, ins.getLong_emp_yn()			);
			pstmt.setString	(71, ins.getBlackbox_nm()			);
			pstmt.setInt	(72, ins.getBlackbox_amt()			);
			pstmt.setString	(73, ins.getBlackbox_no()			);
			pstmt.setString	(74, ins.getBlackbox_dt()			);

			pstmt.setString	(75, ins.getEnp_no()			);
			pstmt.setString	(76, ins.getLkas_yn()			);
			pstmt.setString	(77, ins.getLdws_yn()			);
			pstmt.setString	(78, ins.getAeb_yn()			);
			pstmt.setString	(79, ins.getFcw_yn()			);
			pstmt.setString	(80, ins.getEv_yn()				);
			pstmt.setString	(81, ins.getOthers()			);
			pstmt.setString	(82, ins.getOthers_device()		);
			pstmt.setString	(83, ins.getCom_emp_start_dt()	);
			pstmt.setString	(84, ins.getCom_emp_exp_dt()	);
			pstmt.setString	(85, ins.getHook_yn()			);
			pstmt.setString	(86, ins.getLegal_yn()			);
			

			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[InsDatabase:insertIns]"+ e);

/*			System.out.println("[pstmt.setString	(1,  ins.getCar_mng_id()			)]"+ ins.getCar_mng_id()			);
			System.out.println("[pstmt.setString	(2,  ins.getIns_st()				)]"+ ins.getIns_st()				);
			System.out.println("[pstmt.setString	(3,  ins.getIns_sts()				)]"+ ins.getIns_sts()				);
			System.out.println("[pstmt.setString	(4,  ins.getAge_scp()				)]"+ ins.getAge_scp()				);
			System.out.println("[pstmt.setString	(5,  ins.getCar_use()				)]"+ ins.getCar_use()				);
			System.out.println("[pstmt.setString	(6,  ins.getIns_com_id()			)]"+ ins.getIns_com_id()			);
			System.out.println("[pstmt.setString	(7,  ins.getIns_con_no()			)]"+ ins.getIns_con_no()			);
			System.out.println("[pstmt.setString	(8,  ins.getConr_nm()				)]"+ ins.getConr_nm()				);
			System.out.println("[pstmt.setString	(9,  ins.getIns_start_dt()			)]"+ ins.getIns_start_dt()			);
			System.out.println("[pstmt.setString	(10, ins.getIns_exp_dt()			)]"+ ins.getIns_exp_dt()			);
			System.out.println("[pstmt.setInt		(11, ins.getRins_pcp_amt()			)]"+ ins.getRins_pcp_amt()			);
			System.out.println("[pstmt.setString	(12, ins.getVins_pcp_kd()			)]"+ ins.getVins_pcp_kd()			);
			System.out.println("[pstmt.setInt		(13, ins.getVins_pcp_amt()			)]"+ ins.getVins_pcp_amt()			);
			System.out.println("[pstmt.setString	(14, ins.getVins_gcp_kd()			)]"+ ins.getVins_gcp_kd()			);
			System.out.println("[pstmt.setInt		(15, ins.getVins_gcp_amt()			)]"+ ins.getVins_gcp_amt()			);
			System.out.println("[pstmt.setString	(16, ins.getVins_bacdt_kd()			)]"+ ins.getVins_bacdt_kd()			);
			System.out.println("[pstmt.setInt		(17, ins.getVins_bacdt_amt()		)]"+ ins.getVins_bacdt_amt()		);
			System.out.println("[pstmt.setInt		(18, ins.getVins_cacdt_amt()		)]"+ ins.getVins_cacdt_amt()		);
			System.out.println("[pstmt.setString	(19, ins.getPay_tm()				)]"+ ins.getPay_tm()				);
			System.out.println("[pstmt.setString	(20, ins.getChange_dt()				)]"+ ins.getChange_dt()				);
			System.out.println("[pstmt.setString	(21, ins.getChange_cau()			)]"+ ins.getChange_cau()			);
			System.out.println("[pstmt.setString	(22, ins.getChange_itm_kd1()		)]"+ ins.getChange_itm_kd1()		);
			System.out.println("[pstmt.setInt		(23, ins.getChange_itm_amt1()		)]"+ ins.getChange_itm_amt1()		);
			System.out.println("[pstmt.setString	(24, ins.getChange_itm_kd2()		)]"+ ins.getChange_itm_kd2()		);
			System.out.println("[pstmt.setInt		(25, ins.getChange_itm_amt2()		)]"+ ins.getChange_itm_amt2()		);
			System.out.println("[pstmt.setString	(26, ins.getChange_itm_kd3()		)]"+ ins.getChange_itm_kd3()		);
			System.out.println("[pstmt.setInt		(27, ins.getChange_itm_amt3()		)]"+ ins.getChange_itm_amt3()		);
			System.out.println("[pstmt.setString	(28, ins.getChange_itm_kd4()		)]"+ ins.getChange_itm_kd4()		);
			System.out.println("[pstmt.setInt		(29, ins.getChange_itm_amt4()		)]"+ ins.getChange_itm_amt4()		);
			System.out.println("[pstmt.setString	(30, ins.getCar_rate()				)]"+ ins.getCar_rate()				);
			System.out.println("[pstmt.setString	(31, ins.getIns_rate()				)]"+ ins.getIns_rate()				);
			System.out.println("[pstmt.setString	(32, ins.getExt_rate()				)]"+ ins.getExt_rate()				);
			System.out.println("[pstmt.setString	(33, ins.getAir_ds_yn()				)]"+ ins.getAir_ds_yn()				);
			System.out.println("[pstmt.setString	(34, ins.getAir_as_yn()				)]"+ ins.getAir_as_yn()				);
			System.out.println("[pstmt.setString	(35, ins.getAgnt_nm()				)]"+ ins.getAgnt_nm()				);
			System.out.println("[pstmt.setString	(36, ins.getAgnt_tel()				)]"+ ins.getAgnt_tel()				);
			System.out.println("[pstmt.setString	(37, ins.getAgnt_imgn_tel()			)]"+ ins.getAgnt_imgn_tel()			);
			System.out.println("[pstmt.setString	(38, ins.getAgnt_fax()				)]"+ ins.getAgnt_fax()				);
			System.out.println("[pstmt.setString	(39, ins.getExp_dt()				)]"+ ins.getExp_dt()				);
			System.out.println("[pstmt.setString	(40, ins.getExp_cau()				)]"+ ins.getExp_cau()				);
			System.out.println("[pstmt.setInt		(41, ins.getRtn_amt()				)]"+ ins.getRtn_amt()				);
			System.out.println("[pstmt.setString	(42, ins.getRtn_dt()				)]"+ ins.getRtn_dt()				);
			System.out.println("[pstmt.setString	(43, ins.getEnable_renew()			)]"+ ins.getEnable_renew()			);
			System.out.println("[pstmt.setString	(44, ins.getCon_f_nm()				)]"+ ins.getCon_f_nm()				);
			System.out.println("[pstmt.setString	(45, ins.getAcc_tel()				)]"+ ins.getAcc_tel()				);
			System.out.println("[pstmt.setString	(46, ins.getAgnt_dept()				)]"+ ins.getAgnt_dept()				);
			System.out.println("[pstmt.setString	(47, ins.getVins_bacdt_kc2()		)]"+ ins.getVins_bacdt_kc2()		);
			System.out.println("[pstmt.setString	(48, ins.getVins_spe()				)]"+ ins.getVins_spe()				);
			System.out.println("[pstmt.setInt		(49, ins.getVins_spe_amt()			)]"+ ins.getVins_spe_amt()			);
			System.out.println("[pstmt.setString	(50, ins.getScan_file()				)]"+ ins.getScan_file()				);
			System.out.println("[pstmt.setString	(51, ins.getReg_id()				)]"+ ins.getReg_id()				);
			System.out.println("[pstmt.setString	(52, ins.getReg_id()				)]"+ ins.getReg_id()				);
			System.out.println("[pstmt.setInt		(53, ins.getVins_canoisr_amt()		)]"+ ins.getVins_canoisr_amt()		);
			System.out.println("[pstmt.setInt		(54, ins.getVins_cacdt_car_amt()	)]"+ ins.getVins_cacdt_car_amt()	);
			System.out.println("[pstmt.setInt		(55, ins.getVins_cacdt_me_amt()		)]"+ ins.getVins_cacdt_me_amt()		);
			System.out.println("[pstmt.setInt		(56, ins.getVins_cacdt_cm_amt()		)]"+ ins.getVins_cacdt_cm_amt()		);
			System.out.println("[pstmt.setString	(57, ins.getIns_kd()				)]"+ ins.getIns_kd()				);
			System.out.println("[pstmt.setString	(58, ins.getReg_cau()				)]"+ ins.getReg_cau()				);
			System.out.println("[pstmt.setString	(59, ins.getAuto_yn()				)]"+ ins.getAuto_yn()				);
			System.out.println("[pstmt.setString	(60, ins.getAbs_yn()				)]"+ ins.getAbs_yn()				);
			System.out.println("[pstmt.setString	(61, ins.getIns_rent_dt()			)]"+ ins.getIns_rent_dt()			);
			System.out.println("[pstmt.setInt		(62, ins.getVins_cacdt_memin_amt()	)]"+ ins.getVins_cacdt_memin_amt()	);
			System.out.println("[pstmt.setInt		(63, ins.getVins_cacdt_mebase_amt()	)]"+ ins.getVins_cacdt_mebase_amt()	);
			System.out.println("[pstmt.setString	(64, ins.getBlackbox_yn()			)]"+ ins.getBlackbox_yn()			);
			System.out.println("[pstmt.setString	(75, ins.getEnp_no()			) ]"+ ins.getEnp_no()				);
			System.out.println("[pstmt.setString	(76, ins.getLkas_yn()			) ]"+ ins.getLkas_yn()				);
			System.out.println("[pstmt.setString	(77, ins.getLdws_yn()			) ]"+ ins.getLdws_yn()				);
			System.out.println("[pstmt.setString	(78, ins.getAeb_yn()			) ]"+ ins.getAeb_yn()				);
			System.out.println("[pstmt.setString	(79, ins.getFcw_yn()			) ]"+ ins.getFcw_yn()				);
			System.out.println("[pstmt.setString	(80, ins.getEv_yn()				) ]"+ ins.getEv_yn()					);
			System.out.println("[pstmt.setString	(81, ins.getOthers()			) ]"+ ins.getOthers()				);
	  		e.printStackTrace();*/
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
	 * 보험 com_emp_yn 히스토리
	 */
	public boolean insertInsComEmpInfo(InsurBean ins)
	{
		int count = 0;
		count = getInsComEmpInfoCnt(ins.getCar_mng_id(),ins.getIns_st());	
		
		getConnection();
		boolean flag = true;
		String query = "insert into INS_COM_EMP_INFO ("+ 
				" COM_EMP_ID, CAR_MNG_ID, INS_ST, CLIENT_ID, COM_EMP_START_DT, UPDATE_ID, UPDATE_DT, REG_DT, INS_START_DT, INS_EXP_DT  "+
				" ) values("+
				" ?, ?, ?, ?, replace(?, '-', ''), ?, to_char(sysdate,'YYYYMMDD'), to_char(sysdate,'YYYYMMDD'), replace(?, '-', ''), replace(?, '-', '') "+
				" )";
		
		
		PreparedStatement pstmt = null;
		
		try 
		{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
			pstmt.setInt	(1,  count							);
			pstmt.setString	(2,  ins.getCar_mng_id()			);
			pstmt.setString	(3,  ins.getIns_st()				);
			pstmt.setString	(4,  ins.getClient_nm()				);
			pstmt.setString	(5,  ins.getCom_emp_start_dt()		);
			pstmt.setString	(6,  ins.getReg_id()				);
			pstmt.setString	(7,  ins.getIns_start_dt()			);
			pstmt.setString	(8,  ins.getIns_exp_dt()			);
			
			
			pstmt.executeUpdate();
			pstmt.close();
			
			conn.commit();
			
		} catch (Exception e) {
			System.out.println("[InsDatabase:insertInsComEmpInfo]"+ e);
			
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
	 * 보험 com_emp_yn 만료건 날자처리
	 */
	public boolean updateInsComEmpInfo(String car_mng_id, String ins_st, String com_emp_exp_dt, String reg_id)
	{
		getConnection();
		boolean flag = true;
		String query = "update INS_COM_EMP_INFO set"+
							" COM_EMP_EXP_DT = ?,"+
							" UPDATE_DT = to_char(SYSDATE,'YYYYMMDD'), "+
							" UPDATE_ID = ? "+
							" where CAR_MNG_ID = ? and INS_ST = ?"+
							" and COM_EMP_ID = (SELECT MAX(COM_EMP_ID) KEEP (DENSE_RANK FIRST ORDER BY COM_EMP_ID DESC) "+
							" 			   FROM INS_COM_EMP_INFO WHERE car_mng_id=? AND ins_st=? )";
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, com_emp_exp_dt	);
			pstmt.setString(2, reg_id			);
			pstmt.setString(3, car_mng_id		);
			pstmt.setString(4, ins_st			);
			pstmt.setString(5, car_mng_id		);
			pstmt.setString(6, ins_st			);
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[InsDatabase:updateInsComEmpInfo]"+ e);
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
	 * 보험 com_emp_yn 히스토리 카운트
	 */
	public int getInsComEmpInfoCnt(String car_mng_id, String ins_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		String query = "";
		
		query = "select count(0) from INS_COM_EMP_INFO "+ 
				"where car_mng_id='"+car_mng_id+"' and ins_st='"+ins_st+"' ";
		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			if(rs.next())
			{				
				count = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[InsDatabase:getInsComEmpInfoCnt(String car_no, String ins_con_no)]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null)		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
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
							" INS_KD = ?, REG_CAU=?, exp_st=?,"+
							" AUTO_YN = ?,"+
							" ABS_YN = ?,"+
							" INS_RENT_DT = replace(?, '-', ''),"+
							" VINS_CACDT_MEMIN_AMT = ?, "+
							" VINS_CACDT_MEBASE_AMT = ?, "+
							" blackbox_yn = ?, "+
							" vins_share_extra_amt	= ?, "+
							" vins_blackbox_amt		= ?, "+
							" vins_blackbox_per		= ?, "+
                            " com_emp_yn = ?, "+
							" firm_emp_nm = ?, "+
							" long_emp_yn = ?, "+
							" blackbox_nm = ?, "+
							" blackbox_amt = ?, "+
							" blackbox_no = ?, "+
							" blackbox_dt = ?, "+
							" enp_no = ?, "+
							" lkas_yn = ?, "+
							" ldws_yn = ?, "+
							" aeb_yn = ?, "+
							" fcw_yn = ?, "+
							" ev_yn = ?, "+
							" others = ?, "+
							" others_device = ?, "+
							" hook_yn = ?, "+
							" legal_yn = ? "+
							" where CAR_MNG_ID = ? and INS_ST = ?";
		PreparedStatement pstmt = null;

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
			pstmt.setString(71, ins.getReg_cau());
			pstmt.setString(72, ins.getExp_st());
			pstmt.setString(73, ins.getAuto_yn());
			pstmt.setString(74, ins.getAbs_yn());
			pstmt.setString(75, ins.getIns_rent_dt());
			pstmt.setInt   (76, ins.getVins_cacdt_memin_amt());
			pstmt.setInt   (77, ins.getVins_cacdt_mebase_amt());
			pstmt.setString(78, ins.getBlackbox_yn());
			pstmt.setInt   (79, ins.getVins_share_extra_amt());
			pstmt.setInt   (80, ins.getVins_blackbox_amt());
			pstmt.setString(81, ins.getVins_blackbox_per());
			pstmt.setString(82, ins.getCom_emp_yn());
			pstmt.setString(83, ins.getFirm_emp_nm());
			pstmt.setString(84, ins.getLong_emp_yn());
			pstmt.setString(85, ins.getBlackbox_nm());
			pstmt.setInt   (86, ins.getBlackbox_amt());
			pstmt.setString(87, ins.getBlackbox_no());
			pstmt.setString(88, ins.getBlackbox_dt());
			pstmt.setString(89, ins.getEnp_no());
			pstmt.setString(90, ins.getLkas_yn());
			pstmt.setString(91, ins.getLdws_yn());
			pstmt.setString(92, ins.getAeb_yn());
			pstmt.setString(93, ins.getFcw_yn());
			pstmt.setString(94, ins.getEv_yn());
			pstmt.setString(95, ins.getOthers());
			pstmt.setString(96, ins.getOthers_device());
			pstmt.setString(97, ins.getHook_yn());
			pstmt.setString(98, ins.getLegal_yn());

			pstmt.setString(99, ins.getCar_mng_id());
			pstmt.setString(100, ins.getIns_st());

		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[InsDatabase:updateIns]"+ e);
			System.out.println("[Car_mng_id		]"+ ins.getCar_mng_id	());
			System.out.println("[Ins_st			]"+ ins.getIns_st		());
			System.out.println("[Ins_start_dt	]"+ ins.getIns_start_dt	());
			System.out.println("[Ins_com_id		]"+ ins.getIns_com_id	());
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
	 * 보험상태 변경 : 전보험 만료처리 등
	 */
	public boolean changeInsSts(String c_id, int ins_st, String ins_sts)
	{
		getConnection();
		boolean flag = true;
		String query = "update insur set"+
							" INS_STS = ?"+
							" where CAR_MNG_ID = ? and INS_ST = ?";
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, ins_sts);
			pstmt.setString(2, c_id);
			pstmt.setString(3, Integer.toString(ins_st));
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[InsDatabase:changeInsSts]"+ e);
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

		query = " select a.rent_l_cd, decode(a.use_yn,'Y','대여','해지') use_yn,"+
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
			System.out.println("[InsDatabase:getRentHistoryList]"+ e);
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

		query = " select a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id,"+
				"        decode(a.use_yn,'Y','대여','N','해지') use_yn, a.firm_nm,"+
				"        a.rent_start_dt, a.rent_end_dt, c.cls_dt, decode(a.car_st,'1','렌트','2','예비차','3','2','리스','4','월렌트','5','업무대여') car_st, a.rent_way, decode(c.cls_st,'6','매각','8','매입옵션') cls_st \n "+
				" from cont_n_view a, cls_cont c  where a.rent_mng_id = c.rent_mng_id(+) and a.rent_l_cd= c.rent_l_cd(+) and  a.car_mng_id='"+c_id+"' order by a.reg_dt, a.rent_start_dt, a.rent_l_cd";			
		
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
			System.out.println("[InsDatabase:getRentHisList]"+ e);
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
					" decode(a.ins_sts,'1','유효','2','만료','3','중도해지','4','오프리스','5','승계') ins_sts, b.ins_com_nm,"+
					" DECODE(a.ins_start_dt,'','',SUBSTR(a.ins_start_dt,1,4)||'-'||SUBSTR(a.ins_start_dt,5,2)||'-'||SUBSTR(a.ins_start_dt,7,2)) as ins_start_dt,"+
					" DECODE(a.ins_exp_dt,'','',SUBSTR(a.ins_exp_dt,1,4)||'-'||SUBSTR(a.ins_exp_dt,5,2)||'-'||SUBSTR(a.ins_exp_dt,7,2)) as ins_exp_dt,"+
					" (a.rins_pcp_amt+a.vins_pcp_amt+a.vins_gcp_amt+a.vins_bacdt_amt+a.vins_canoisr_amt+a.vins_share_extra_amt+a.vins_cacdt_cm_amt+a.change_itm_amt1+a.change_itm_amt2+a.change_itm_amt2+a.change_itm_amt4) ins_amt"+//+vins_cacdt_amt//-a.vins_blackbox_amt
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
			System.out.println("[InsDatabase:getInsHistoryList]"+ e);
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

	//차량별 보험 이력 리스트 : car_ins_list.jsp  - 보험만료일로 변경
	public Vector getInsHisList1(String c_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		/*query = ""+
				"SELECT e.CAR_NO, e.CAR_NM, DECODE(a.car_st,'5','(주)아마존카/')||d.firm_nm AS firm_nm,\r\n" + 
				"		 CASE WHEN a.car_st='5' THEN '1288147957' WHEN d.client_st='2' THEN SUBSTR(text_decrypt(d.ssn, 'pw'),0,6) ELSE d.enp_no END AS enp_no,\r\n" + 
				"b.INS_CON_NO, b.CAR_MNG_ID, b.INS_ST, b.INS_STS, b.COM_EMP_YN, INS_START_DT, INS_EXP_DT, c.COM_EMP_START_DT, c.COM_EMP_EXP_DT \r\n" + 
				"FROM cont a, insur b, INS_COM_EMP_INFO c, client d, CAR_REG e\r\n" + 
				"WHERE a.CAR_MNG_ID = b.CAR_MNG_ID \r\n" + 
				"AND b.CAR_MNG_ID  = c.CAR_MNG_ID\r\n" + 
				"AND b.INS_ST = c.INS_ST\r\n" + 
				"AND c.CLIENT_ID = d.CLIENT_ID\r\n" + 
				"AND b.CAR_MNG_ID = e.CAR_MNG_ID "+
				"AND a.CAR_MNG_ID = '"+c_id+"' "+
				"";*/
		
		query = " select a.ins_st, decode(a.vins_pcp_amt, 0, '책임보험','종합보험') gubun,"+
				" decode(a.ins_sts,'1','유효','2','만료','3','중도해지','4','오프리스','5','승계') ins_sts, b.ins_com_nm, a.exp_cau,"+
				" DECODE(a.ins_start_dt,'','',SUBSTR(a.ins_start_dt,1,4)||'-'||SUBSTR(a.ins_start_dt,5,2)||'-'||SUBSTR(a.ins_start_dt,7,2)) as ins_start_dt,"+
				" DECODE(a.ins_exp_dt,'','',SUBSTR(a.ins_exp_dt,1,4)||'-'||SUBSTR(a.ins_exp_dt,5,2)||'-'||SUBSTR(a.ins_exp_dt,7,2)) as ins_exp_dt,"+
				" c.ins_amt, c.rtn_amt,"+
				" decode(a.reg_cau, '2','용도변경', '3','담보변경', '4','만기', '5','오프리스', '신차') as reg_cau"+
				" from insur a, ins_com b, (select car_mng_id, ins_st, sum(decode(ins_tm2,'2','',pay_amt)) ins_amt, sum(decode(ins_tm2,'2',pay_amt)) rtn_amt from scd_ins group by car_mng_id, ins_st) c, ins_cls d \n"+
				" where a.ins_com_id=b.ins_com_id and a.car_mng_id=c.car_mng_id and a.ins_st=c.ins_st  \n"+
				"  and  a.car_mng_id = d.car_mng_id(+) and a.ins_st = d.ins_st(+) \n"+
			//	" and a.car_mng_id='"+c_id+"'"+
			//	" and a.car_mng_id='"+c_id+"' and  to_char(sysdate,'YYYYMMDD')  between to_char(to_date(a.ins_start_dt) + 1 , 'yyyymmdd')  and a.ins_exp_dt and ins_sts <> '3'   \n"+
				" and a.car_mng_id ='"+c_id+"' and  to_char(sysdate,'YYYYMMDD')  between to_char(to_date(a.ins_start_dt) + DECODE(a.INS_ST,'0', 0, 1) , 'yyyymmdd')  and decode(d.car_mng_id, null, a.ins_exp_dt, d.exp_dt)  \n"+
				" order by a.ins_start_dt, a.ins_st";			
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
			System.out.println("[InsDatabase:getInsHistoryList]"+ e);
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
			System.out.println("[InsDatabase:getInsHisList2]"+ e);
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

	//계약별 최종 보험회사명 - 보험만기일 기준으로 변경 - 20120703
	public String getInsComNm(String c_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String ins_com = "";
		String query = "";

		query = " select b.ins_com_nm from insur a, ins_com b \n"+
				" where a.ins_com_id=b.ins_com_id and a.car_mng_id='"+c_id+"'  \n"+
				" and to_char(sysdate,'YYYYMMDD')  between to_char(to_date(a.ins_start_dt) + DECODE(a.INS_ST,'0', 0, 1) , 'yyyymmdd')  and a.ins_exp_dt and a.ins_sts <> '3'  \n"+
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
			System.out.println("[InsDatabase:getInsComNm]"+ e);
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

	//계약별 최종 보험회사명
	public String getInsComNm(String c_id, String ins_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String ins_com = "";
		String query = "";

		query = " select b.ins_com_nm from insur a, ins_com b"+
				" where a.ins_com_id=b.ins_com_id and a.car_mng_id='"+c_id+"' and a.ins_st='"+ins_st+"'"+
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
			System.out.println("[InsDatabase:getInsComNm]"+ e);
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


	//계약별 최종 보험 구분 - 보험만기일을 기준으로 변경 - 20120703
	public String getInsStReg(String c_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String ins_st = "";
		String query = "";

		query = " select max(TO_NUMBER(ins_st)) from insur where car_mng_id='"+c_id+"'  ";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next()){				
				ins_st = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[InsDatabase:getInsStReg]"+ e);
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

	//계약별 최종 보험 구분 - 보험만기일을 기준으로 변경 - 20120703
	public String getInsSt(String c_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String ins_st = "";
		String query = "";
		// *****************테스트 완료 후 주석 변경 필수 *********************
	//	System.out.println(c_id);
//		query = " select max(ins_st) from insur where car_mng_id='"+c_id+"'  ";
	//	query = " select max(ins_st) from insur where car_mng_id='"+c_id+"'   and ins_sts <> '3'  and to_char(sysdate,'YYYYMMDD')  between to_char(to_date(ins_start_dt,'yyyymmdd') + 1 , 'yyyymmdd')  and ins_exp_dt ";
		query = " select max(TO_NUMBER(a.ins_st)) ins_st  from insur a, ins_cls b  where  a.car_mng_id = b.car_mng_id(+) and  a.ins_st = b.ins_st(+)   and  a.car_mng_id='"+c_id+"'  and to_char(sysdate,'YYYYMMDD')  between to_char(to_date(a.ins_start_dt, 'yyyymmdd') + 1 , 'yyyymmdd')  and  decode(b.car_mng_id, null, a.ins_exp_dt, b.exp_dt)   ";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next()){				
				ins_st = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[InsDatabase:getInsSt]"+ e);
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

	//계약별 최종 보험 구분
	public String getInsStNow(String c_id, String b_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String ins_st = "";
		String query = "";

		query = " select max(TO_NUMBER(ins_st)) ins_st from insur where car_mng_id='"+c_id+"' and substr(replace('"+b_dt+"','-',''),1,8) between ins_start_dt and ins_exp_dt";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next()){				
				ins_st = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[InsDatabase:getInsStNow]"+ e);
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

	//계약별 최종 보험 구분
	public String getInsStNext(String c_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String ins_st = "";
		String query = "";

		query = " select decode(count(*),0,0,max(TO_NUMBER(ins_st))+1) ins_st from insur where car_mng_id='"+c_id+"'";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next()){				
				ins_st = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[InsDatabase:getInsStNext]"+ e);
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
							" decode(R_INS_EST_DT, '', '', substr(R_INS_EST_DT, 1, 4) || '-' || substr(R_INS_EST_DT, 5, 2) || '-'||substr(R_INS_EST_DT, 7, 2)) R_INS_EST_DT,"+
							" decode(PAY_DT, '', '', substr(PAY_DT, 1, 4) || '-' || substr(PAY_DT, 5, 2) || '-'||substr(PAY_DT, 7, 2)) PAY_DT,"+
							" PAY_YN, INS_TM2, CH_TM, EXCEL_CHK"+
							" from scd_ins "+
							" where CAR_MNG_ID = ? and INS_ST = ? order by to_number(ins_st), to_number(ins_tm), ins_est_dt";
		try {
				
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, c_id);
				pstmt.setString(2, ins_st);
		    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				InsurScdBean scd = new InsurScdBean();
				scd.setCar_mng_id	(rs.getString("CAR_MNG_ID")==null?"":rs.getString("CAR_MNG_ID"));
				scd.setIns_tm		(rs.getString("INS_TM")==null?"":rs.getString("INS_TM"));
				scd.setIns_st		(rs.getString("INS_ST")==null?"":rs.getString("INS_ST"));
				scd.setIns_est_dt	(rs.getString("INS_EST_DT")==null?"":rs.getString("INS_EST_DT"));
				scd.setR_ins_est_dt	(rs.getString("R_INS_EST_DT")==null?"":rs.getString("R_INS_EST_DT"));
				scd.setPay_amt		(rs.getInt("PAY_AMT"));
				scd.setPay_yn		(rs.getString("PAY_YN")==null?"":rs.getString("PAY_YN"));
				scd.setPay_dt		(rs.getString("PAY_DT")==null?"":rs.getString("PAY_DT"));
				scd.setIns_tm2		(rs.getString("INS_TM2")==null?"":rs.getString("INS_TM2"));
				scd.setCh_tm		(rs.getString("CH_TM")==null?"":rs.getString("CH_TM"));
				scd.setExcel_chk	(rs.getString("EXCEL_CHK")==null?"":rs.getString("EXCEL_CHK"));
				vt.add(scd);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[InsDatabase:getInsScds]"+ e);
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
	public Vector getInsScds(String c_id, String ins_st, String pay_yn)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	" select"+
							" CAR_MNG_ID, INS_TM, INS_ST, PAY_AMT,"+
							" decode(INS_EST_DT, '', '', substr(INS_EST_DT, 1, 4) || '-' || substr(INS_EST_DT, 5, 2) || '-'||substr(INS_EST_DT, 7, 2)) INS_EST_DT,"+
							" decode(PAY_DT, '', '', substr(PAY_DT, 1, 4) || '-' || substr(PAY_DT, 5, 2) || '-'||substr(PAY_DT, 7, 2)) PAY_DT,"+
							" PAY_YN, INS_TM2, EXCEL_CHK"+
							" from scd_ins "+
							" where CAR_MNG_ID = ? and INS_ST = ? and pay_yn=? order by ins_st, ins_tm, ins_est_dt";
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, c_id);
				pstmt.setString(2, ins_st);
				pstmt.setString(3, pay_yn);
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
				scd.setIns_tm2(rs.getString("INS_TM2")==null?"":rs.getString("INS_TM2"));
				scd.setExcel_chk(rs.getString("EXCEL_CHK")==null?"":rs.getString("EXCEL_CHK"));
				vt.add(scd);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[InsDatabase:getInsScds]"+ e);
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
							" PAY_YN, R_INS_EST_DT, INS_TM2, "+
							" CH_TM, EXCEL_CHK "+
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
				scd.setCar_mng_id	(rs.getString("CAR_MNG_ID")==null?"":rs.getString("CAR_MNG_ID"));
				scd.setIns_tm		(rs.getString("INS_TM")==null?"":rs.getString("INS_TM"));
				scd.setIns_st		(rs.getString("INS_ST")==null?"":rs.getString("INS_ST"));
				scd.setIns_est_dt	(rs.getString("INS_EST_DT")==null?"":rs.getString("INS_EST_DT"));
				scd.setPay_amt		(rs.getInt("PAY_AMT"));
				scd.setPay_yn		(rs.getString("PAY_YN")==null?"":rs.getString("PAY_YN"));
				scd.setPay_dt		(rs.getString("PAY_DT")==null?"":rs.getString("PAY_DT"));
				scd.setR_ins_est_dt	(rs.getString("R_INS_EST_DT")==null?"":rs.getString("R_INS_EST_DT"));
				scd.setIns_tm2		(rs.getString("INS_TM2")==null?"":rs.getString("INS_TM2"));
				scd.setCh_tm		(rs.getString("CH_TM")==null?"":rs.getString("CH_TM"));
				scd.setExcel_chk	(rs.getString("EXCEL_CHK")==null?"":rs.getString("EXCEL_CHK"));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[InsDatabase:getInsScd]"+ e);
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
				" a.car_mng_id, a.ins_st, b.rent_l_cd, b.firm_nm, c.pay_amt"+
				" from insur a, cont_n_view b, scd_ins c"+
				" where a.car_mng_id=c.car_mng_id and a.ins_st=c.ins_st and a.car_mng_id=b.car_mng_id"+
				" and a.car_mng_id=? and a.ins_st=? and c.ins_tm=?";
			
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
				ins.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				ins.setFirm_nm(rs.getString("FIRM_NM")==null?"":rs.getString("FIRM_NM"));
				ins.setPay_amt(rs.getInt("PAY_AMT"));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[InsDatabase:getInsPay]"+ e);
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
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;

		//String query2 = "select nvl(to_char(max(ins_tm)+1),'1') ins_tm from scd_ins where car_mng_id=? and ins_st=?";
		String query2 = "select nvl(to_char(max(TO_NUMBER(ins_tm))+1),'1') ins_tm from scd_ins where car_mng_id=? and ins_st=?";

		String query = "insert into scd_ins (CAR_MNG_ID, INS_TM, INS_ST, INS_EST_DT, PAY_AMT, PAY_YN, PAY_DT, R_INS_EST_DT, INS_TM2, CH_TM) values"+
						" (?, ?, ?, replace(?, '-', ''), ?, ?, replace(?, '-', ''), replace(?, '-', ''), ?, ?)";

		try 
		{
			conn.setAutoCommit(false);

			pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString(1, scd.getCar_mng_id());
			pstmt2.setString(2, scd.getIns_st());
	    	rs = pstmt2.executeQuery();
    	
			if(rs.next())
			{
				scd.setIns_tm(rs.getString("ins_tm")==null?"":rs.getString("ins_tm"));
			}
			rs.close();
			pstmt2.close();

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, scd.getCar_mng_id	());
			pstmt.setString(2, scd.getIns_tm		());
			pstmt.setString(3, scd.getIns_st		());
			pstmt.setString(4, scd.getIns_est_dt	());
			pstmt.setInt   (5, scd.getPay_amt		());
			pstmt.setString(6, scd.getPay_yn		());
			pstmt.setString(7, scd.getPay_dt		());
			pstmt.setString(8, scd.getR_ins_est_dt	());
			pstmt.setString(9, scd.getIns_tm2		());
			pstmt.setString(10,scd.getCh_tm			());
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

	  	} catch (Exception e) {
			/*System.out.println("[InsDatabase:insertInsScd]"+ e);
			System.out.println("[scd.getCar_mng_id		()]"+ scd.getCar_mng_id		());
			System.out.println("[scd.getIns_tm			()]"+ scd.getIns_tm			());
			System.out.println("[scd.getIns_st			()]"+ scd.getIns_st			());
			System.out.println("[scd.getIns_est_dt		()]"+ scd.getIns_est_dt		());
			System.out.println("[scd.getPay_amt			()]"+ scd.getPay_amt		());
			System.out.println("[scd.getPay_yn			()]"+ scd.getPay_yn			());
			System.out.println("[scd.getPay_dt			()]"+ scd.getPay_dt			());
			System.out.println("[scd.getR_ins_est_dt	()]"+ scd.getR_ins_est_dt	());
			System.out.println("[scd.getIns_tm2			()]"+ scd.getIns_tm2		());
			System.out.println("[scd.getCh_tm			()]"+ scd.getCh_tm			());*/
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(rs != null)		rs.close();
				if(pstmt2 != null)	pstmt2.close();
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
		String query = " update scd_ins set							"+
						"       INS_EST_DT=replace(?, '-', ''),		"+
						"       PAY_AMT=?,							"+
						"       PAY_YN=?,							"+
						"       PAY_DT=replace(?, '-', ''),			"+
						"       R_INS_EST_DT=replace(?, '-', ''),	"+
						"       INS_TM2=?,							"+
						"       excel_chk=?,						"+
						"       ch_tm=?								"+
						" where CAR_MNG_ID=? and INS_TM=? and INS_ST=?";

		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);
					
			pstmt = conn.prepareStatement(query);
			//set
			pstmt.setString(1, scd.getIns_est_dt());
			pstmt.setInt   (2, scd.getPay_amt());
			pstmt.setString(3, scd.getPay_yn());
			pstmt.setString(4, scd.getPay_dt());
			pstmt.setString(5, scd.getR_ins_est_dt());
			pstmt.setString(6, scd.getIns_tm2());
			pstmt.setString(7, scd.getExcel_chk());
			pstmt.setString(8, scd.getCh_tm());
			//where
			pstmt.setString(9, scd.getCar_mng_id());
			pstmt.setString(10, scd.getIns_tm());
			pstmt.setString(11, scd.getIns_st());
		    pstmt.executeUpdate();
			pstmt.close();
		    
		    conn.commit();
		} catch (Exception e) {
			System.out.println("[InsDatabase:updateInsScd]"+ e);
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
			System.out.println("[InsDatabase:dropInsScd]"+ e);
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
						" where car_mng_id = ? and ins_st = ? and pay_yn='0' and ins_tm<>'1'";

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
			System.out.println("[InsDatabase:dropInsScd2]"+ e);
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
			if(count == 0) flag = false;
			rs.close();
			pstmt.close();
			
	  	} catch (Exception e) {
			System.out.println("[InsDatabase:getInsScdYn]"+ e);
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
					 ht.put(columnName, (rs.getString(columnName))==null?" ":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[InsDatabase:getInsComList]"+ e);
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
			System.out.println("[InsDatabase:insertInsCom]"+ e);
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
		String query = "update ins_com set "+
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
			pstmt.setString(12,ins.getIns_com_id());
		    pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[InsDatabase:updateInsCom]"+ e);
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
				" from cont_n_view a, insur b, car_reg cr, " + 
				" (select car_mng_id, max(TO_NUMBER(ins_st)) ins_st from insur group by car_mng_id) c,"+ 
				" ins_com d"+ 
				" where a.car_mng_id=b.car_mng_id and nvl(a.use_yn,'Y')='Y' and a.car_mng_id = cr.car_mng_id(+) "+ 
				" and a.car_mng_id=c.car_mng_id and b.ins_st=c.ins_st"+ 
				" and b.ins_com_id=d.ins_com_id"+
				" order by a.firm_nm";

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
			
			System.out.println("[InsDatabase:getInsStatList]"+ e);
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
	 *	argument로 넘어온 날짜로 주일 및 공휴일을 건너뛰어 가장 가까운 평일 날짜를 리턴
	 */
	public String getValidDt2(String dt)
	{	
		String sysdate = dt;
		boolean s_flag = false;
		boolean h_flag = false;
		String c_sysdate = "";
		String c_hol = "";
		while((!s_flag) || (!h_flag))
		{
			/* 요일체크로 리턴된 날짜가 원래의 날짜와 다르다면 */
			c_sysdate = checkSunday2(sysdate);
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
					
		query = "select decode(to_char(to_date(?,'YYYY-MM-DD'),'DY'),"+
					" '일',to_char(to_date(?,'YYYY-MM-DD')-2,'YYYY-MM-DD'), '토',to_char(to_date(?,'YYYY-MM-DD')-1,'YYYY-MM-DD'), 'N')"+
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

			/* 일요일,토요일인 경우 하루나 이틀을 더해준다 */
			if(!rtnStr.equals("N"))		sysdate = rtnStr;

			rs.close();
			pstmt.close();

		}catch (SQLException e){
			System.out.println("[InsDatabase:checkSunday]\n"+e);
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
	 *	(요일체크)args로 넘어온 날짜가 일요일인지 체크해서 일요일인경우 +1 날짜를 리턴
	 */
	private String checkSunday2(String dt)
	{
		getConnection();
		boolean flag = false;
		String query;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String rtnStr = "";

		String sysdate = dt;

		query = "select decode(to_char(to_date('"+dt+"','YYYY-MM-DD'),'DY'),"+
					" '일',to_char(to_date('"+dt+"','YYYY-MM-DD')-1,'YYYY-MM-DD'), 'N')"+
					" from dual";

		if(dt.equals("") || dt.equals("--")){
			sysdate = "to_char(sysdate,'YYYY-MM-DD')";
					
			query = "select decode(to_char(to_date(to_char(sysdate,'YYYY-MM-DD'),'YYYY-MM-DD'),'DY'),"+
						" '일',to_char(to_date(to_char(sysdate,'YYYY-MM-DD'),'YYYY-MM-DD')-1,'YYYY-MM-DD'), 'N')"+
						" from dual";
		}

		try{

			pstmt = conn.prepareStatement(query);
		    rs = pstmt.executeQuery();			
			while(rs.next())
			{
				rtnStr = rs.getString(1)==null?"":rs.getString(1);
			}

			/* 일요일,토요일인 경우 하루나 이틀을 더해준다 */
			if(!rtnStr.equals("N"))		sysdate = rtnStr;

			rs.close();
			pstmt.close();

		}catch (SQLException e){
			System.out.println("[InsDatabase:checkSunday2]\n"+e);
			System.out.println("[InsDatabase:checkSunday2]\n"+query);
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

				if(!rtnStr.equals("N"))	sysdate = rtnStr;		/* 휴일인경우 하루를 더하고 다시 한번 휴일인지 확인 */
				else					flag = true;			/*  휴일이 아닌경우 loop를 빠져나온다. */
			}

			rs.close();
			pstmt.close();

		}catch (SQLException e)
		{
			System.out.println("[InsDatabase:checkHday]\n"+e);
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
			System.out.println("[InsDatabase:getInsChanges]"+ e);
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
			System.out.println("[InsDatabase:insertInsChange]"+ e);
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
			System.out.println("[InsDatabase:updateInsChange]"+ e);
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
	public boolean updateInsScdSucc(String b_car_mng_id, String b_ins_st, String f_car_mng_id, String f_ins_st)
	{
		getConnection();
		boolean flag = true;
		String query1 = " update ins_change set"+
						" CAR_MNG_ID=?, INS_ST=?"+
						" where CAR_MNG_ID=? and INS_ST=? ";

		String query2 = " update scd_ins set"+
						" CAR_MNG_ID=?, INS_ST=?"+
						" where CAR_MNG_ID=? and INS_ST=? ";

		String query3 = " update precost set"+
						" CAR_MNG_ID=?, COST_ID=?"+
						" where CAR_MNG_ID=? and COST_ID=? and COST_ST='2' ";

		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt1 = conn.prepareStatement(query1);
			pstmt1.setString(1, f_car_mng_id);
			pstmt1.setString(2, f_ins_st);
			pstmt1.setString(3, b_car_mng_id);
			pstmt1.setString(4, b_ins_st);
		    pstmt1.executeUpdate();
			pstmt1.close();

			pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString(1, f_car_mng_id);
			pstmt2.setString(2, f_ins_st);
			pstmt2.setString(3, b_car_mng_id);
			pstmt2.setString(4, b_ins_st);
		    pstmt2.executeUpdate();
			pstmt2.close();

			pstmt3 = conn.prepareStatement(query3);
			pstmt3.setString(1, f_car_mng_id);
			pstmt3.setString(2, f_ins_st);
			pstmt3.setString(3, b_car_mng_id);
			pstmt3.setString(4, b_ins_st);
		    pstmt3.executeUpdate();
			pstmt3.close();

			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[InsDatabase:updateInsScdSucc]"+ e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);	
				if(pstmt1 != null)	pstmt1.close();
				if(pstmt2 != null)	pstmt2.close();
				if(pstmt3 != null)	pstmt3.close();
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
			System.out.println("[InsDatabase:dropInsChange]"+ e);
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

	//계약현황 상세내역-차량번호로 조회
	public RentListBean getLongRentCase(String c_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		RentListBean bean = new RentListBean();
		String query = "";		
       	
		query = " select /*+  merge(a) */ a.*, c.car_no, c.car_nm, cn.car_name , c.init_reg_dt,  c.car_num , g.car_id  , cc.cls_st,  a.rent_way,  '' cpt_cd,  \n" +
			      " decode(c.init_reg_dt, null, 'id', 'ud') as  reg_gubun,  cp.rpt_no,   decode(cp.reg_ext_dt, '', '', substr(cp.reg_ext_dt, 1, 4) || '-' || substr(cp.reg_ext_dt, 5, 2) || '-'||substr(cp.reg_ext_dt, 7, 2)) REG_EXT_DT,  '' scan_file  \n" +
			     "  from cont_n_view a ,  car_reg c,  car_etc g, car_nm cn , cls_cont cc , car_pur cp , ( select car_mng_id, max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%' group by car_mng_id) b"+
			     "	where a.car_mng_id='"+ c_id  +"' and a.rent_l_cd=b.rent_l_cd and a.car_mng_id=b.car_mng_id\n" +
			     "	and a.car_mng_id = c.car_mng_id  and a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+)  \n"+
                       	     "	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+) \n"+
                       	       "	and a.rent_mng_id = cc.rent_mng_id(+)  and a.rent_l_cd = cc.rent_l_cd(+)  \n"+
                       	       "	and a.rent_mng_id = cp.rent_mng_id(+)  and a.rent_l_cd = cp.rent_l_cd(+)  \n"+
			     " order by a.use_yn desc, a.rent_dt, a.rent_mng_id";		     
			    			     
		try 
		{
			pstmt = conn.prepareStatement(query);
		    rs = pstmt.executeQuery();
            if(rs.next())
            {
			    bean.setRent_mng_id(rs.getString("RENT_MNG_ID"));		//계약관리ID
			    bean.setRent_l_cd(rs.getString("RENT_L_CD"));			//계약코드
			    bean.setRent_dt(rs.getString("RENT_DT"));				//계약일자
			    bean.setDlv_dt(rs.getString("DLV_DT"));					//출고일자
			    bean.setClient_id(rs.getString("CLIENT_ID"));					//고객ID
			    bean.setClient_nm(rs.getString("CLIENT_NM"));					//고객 대표자명
			    bean.setFirm_nm(rs.getString("FIRM_NM"));						//상호
			    bean.setBr_id(rs.getString("BRCH_ID"));						//상호
			    bean.setCar_mng_id(rs.getString("CAR_MNG_ID"));					//자동차관리ID
			    bean.setInit_reg_dt(rs.getString("INIT_REG_DT"));					//최초등록일
			    bean.setReg_gubun(rs.getString("REG_GUBUN"));					//최초등록일
			    bean.setCar_no(rs.getString("CAR_NO"));						//차량번호
			    bean.setCar_num(rs.getString("CAR_NUM"));						//차대번호
			    bean.setRent_way(rs.getString("RENT_WAY"));					//대여방식
			    bean.setCon_mon(rs.getString("CON_MON"));						//대여개월
			    bean.setCar_id(rs.getString("CAR_ID"));						//차명ID
			    bean.setRent_start_dt(rs.getString("RENT_START_DT"));				//대여개시일
			    bean.setRent_end_dt(rs.getString("RENT_END_DT"));					//대여종료일
			    bean.setReg_ext_dt(rs.getString("REG_EXT_DT"));					//등록예정일?
			    bean.setRpt_no(rs.getString("RPT_NO"));						//계출번호
			    bean.setCpt_cd(rs.getString("CPT_CD"));						//은행코드
			    bean.setBus_id2(rs.getString("BUS_ID2"));					
			    bean.setMng_id(rs.getString("MNG_ID"));					
				bean.setUse_yn(rs.getString("USE_YN"));					
				bean.setRent_st(rs.getString("RENT_ST"));					
				bean.setCls_st(rs.getString("CLS_ST"));					
				bean.setCar_st(rs.getString("CAR_ST"));					
				bean.setScan_file(rs.getString("SCAN_FILE"));					
            }
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[InsDatabase:getLongRentCase]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
		                if(rs != null )		rs.close();
                		if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}
    }

	/**
	 *	보험료스케줄수정 - 실입금예정일 삽입
	 */
	public void getRInsDtValidDt()
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
       	query = " select car_mng_id, ins_st, ins_tm, ins_est_dt from scd_ins where r_ins_est_dt is null";

		try 
		{

			pstmt = conn.prepareStatement(query);
		    rs = pstmt.executeQuery();
            while(rs.next())
            {
				updateRInsEstDt(rs.getString("CAR_MNG_ID"), rs.getString("INS_ST"), rs.getString("INS_TM"), rs.getString("INS_EST_DT"));		
			}
			rs.close();
			pstmt.close();
	  	} catch (Exception e) {
			System.out.println("[InsDatabase:getRInsDtValidDt]"+ e);
			e.printStackTrace();
		} finally {
			try{	
				if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
		}			
	}

	/**
	 *	보험료스케줄수정 - 실입금예정일 삽입
	 */
	public void updateRInsEstDt(String c_id, String ins_st, String ins_tm, String ins_est_dt)
	{
		getConnection();
		PreparedStatement pstmt2 = null;
		String query = "";

		query = " update scd_ins set r_ins_est_dt=replace(?, '-', '') where car_mng_id=? and ins_st=? and ins_tm=? and ins_est_dt=?";

		try 
		{
			conn.setAutoCommit(false);
			pstmt2 = conn.prepareStatement(query);
			pstmt2.setString(1, getValidDt(ins_est_dt));
			pstmt2.setString(2, c_id);
			pstmt2.setString(3, ins_st);
			pstmt2.setString(4, ins_tm);
			pstmt2.setString(5, ins_est_dt);
		    pstmt2.executeUpdate();	
			pstmt2.close();
		    
		    conn.commit();
		
		 }catch(Exception se){
           try{
				System.out.println("[InsDatabase:updateRInsEstDt]"+se);
				se.printStackTrace();
                conn.rollback();
            }catch(SQLException _ignored){}
	
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt2 != null)	pstmt2.close();
			}catch(Exception ignore){}
			closeConnection();
		}			
	}	

	//보험해지-------------------------------------------------------------------------------------------------------------------------------------

	//보험관리 리스트 조회
	public Vector getInsList(String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select  /*+  merge(c) */ a.car_mng_id, c.rent_mng_id, c.rent_l_cd,  c.firm_nm, c.use_yn,\n"+
				"        cr.car_no, cr.first_car_no, e.car_nm, d.car_name,\n"+
				"        f.ins_com_nm, a.ins_st, a.ins_start_dt, a.ins_exp_dt, a.ins_con_no,\n"+ 
				"        (decode(a.air_ds_yn,'Y',1,0)+decode(a.air_as_yn,'Y',1,0)) as air,\n"+
				"        decode(a.age_scp,'1','21세이상','2','26세이상','3','모든운전자','4','24세이상','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하') as age_scp,\n"+
				"        decode(a.ins_kd,'2','책임보험', '종합보험') as ins_kd,\n"+
				"        decode(a.car_use,'1','영업용', '업무용') as car_use,\n"+
				"        decode(a.ins_sts,'1','유효', '2','만료', '3','중도해지','5','승계') as ins_sts, '' ch_dt, h.exp_dt\n"+
				" from   cont_n_view c, car_reg cr,  insur a, (select car_mng_id, max(rent_mng_id||reg_dt) rent_l_cd from cont group by car_mng_id) b, \n"+
				"        car_nm d, car_mng e, ins_com f, ins_cls h, car_etc ce,  \n"+
				"        (select car_mng_id, car_no from car_change group by car_mng_id, car_no) g \n"+
				" where\n"+
				"        c.car_mng_id=b.car_mng_id and c.rent_mng_id||c.reg_dt=b.rent_l_cd \n"+
				"        and c.car_mng_id=a.car_mng_id(+)\n"+	
				"	and c.car_mng_id = cr.car_mng_id(+) and c.rent_mng_id = ce.rent_mng_id(+)  and c.rent_l_cd = ce.rent_l_cd(+)  \n"+
                       		"	and ce.car_id=d.car_id(+)  and    ce.car_seq=d.car_seq(+) \n"+	
				"        and d.car_comp_id=e.car_comp_id and d.car_cd=e.code\n"+
				"        and a.ins_com_id=f.ins_com_id(+) "+
				"        and a.car_mng_id=h.car_mng_id(+) and a.ins_st=h.ins_st(+) "+
				"        and c.car_mng_id=g.car_mng_id";
						

			if(!t_wd.equals("")){
				if(s_kd.equals("1"))			query += " and c.firm_nm like '%"+t_wd+"%'\n";
				else if(s_kd.equals("2"))		query += " and nvl(cr.car_no,g.car_no) like '%"+t_wd+"%'\n";
				else if(s_kd.equals("3"))		query += " and upper(cr.car_num) like upper('%"+t_wd+"%')\n";
				else if(s_kd.equals("4"))		query += " and replace(a.INS_CON_NO,'-','' )like '%"+t_wd+"%'\n";
			}

		query += " order by a.ins_start_dt asc";

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
			
			System.out.println("[InsDatabase:getInsList]"+ e);
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
	 *	차회보험료 조회
	 */
	public int getNopayAmt(String c_id, String ins_st)
	{
		getConnection();
		int nopay_amt = 0;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

       	query = " select sum(pay_amt) from scd_ins where car_mng_id=? and ins_st=? and pay_yn='0'";

		try 
		{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, c_id);
			pstmt.setString(2, ins_st);
		    rs = pstmt.executeQuery();
            if(rs.next())
            {
				nopay_amt = rs.getInt(1);
			}
			rs.close();
			pstmt.close();

	  	} catch (Exception e) {
			System.out.println("[InsDatabase:getNopayAmt]"+ e);
			e.printStackTrace();
		} finally {
			try{	
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return nopay_amt;
		}			
	}

	/**
	 *	담보변경일 조회
	 */
	public String getChInsDt(String c_id, String ins_st, String st_dt, String ch_item)
	{
		getConnection();
		String ch_dt = "";
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

       	query = " select ch_dt from ins_change where car_mng_id=? and ins_st=? and ch_item=?";

		try 
		{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, c_id);
			pstmt.setString(2, ins_st);
			pstmt.setString(3, ch_item);
		    rs = pstmt.executeQuery();
            if(rs.next())
            {
				ch_dt = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt.close();

			if(ch_dt.equals("")) ch_dt = st_dt;

	  	} catch (Exception e) {
			System.out.println("[InsDatabase:getChInsDt]"+ e);
			e.printStackTrace();
		} finally {
			try{	
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ch_dt;
		}			
	}

	/**
	 *	보험기간 일수조회
	 */
	public String getTotInsDays(String c_id, String ins_st)
	{
		getConnection();
		String days = "";
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

       	query = " select to_date(ins_exp_dt,'YYYYMMDD')-to_date(ins_start_dt,'YYYYMMDD') from insur where car_mng_id=? and ins_st=?";

		try 
		{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, c_id);
			pstmt.setString(2, ins_st);
		    rs = pstmt.executeQuery();
            if(rs.next())
            {
				days = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt.close();

	  	} catch (Exception e) {
			System.out.println("[InsDatabase:getTotInsDays]"+ e);
			e.printStackTrace();
		} finally {
			try{	
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return days;
		}			
	}

	/**
	 *	해지보험료 구하기
	 */
	public int getInsurScdAmt(String c_id, String ins_st, String ins_tm2)
	{
		getConnection();
		int amt = 0;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

       	query = " select sum(pay_amt) from scd_ins where car_mng_id=? and ins_st=? and ins_tm2=?";

		try 
		{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, c_id);
			pstmt.setString(2, ins_st);
			pstmt.setString(3, ins_tm2);
		    rs = pstmt.executeQuery();
            if(rs.next())
            {
				amt = rs.getInt(1);
			}
			rs.close();
			pstmt.close();

	  	} catch (Exception e) {
			System.out.println("[InsDatabase:getInsurScdAmt]"+ e);
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


	/**
	 * 보험해지 생성
	 */
	public boolean insertInsCls(InsurClsBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";

		query = " insert into ins_cls values"+
				" (?, ?, ?, ?, replace(?, '-', ''),"+
				"  replace(?, '-', ''), ?, ?, ?, ?,"+//10
				"  ?, ?, ?, ?, ?,"+
				"  ?, ?, ?, ?, ?,"+//20
				"  ?, ?, ?, ?, ?,"+
				"  ?, ?, ?, ?, ?,"+//30
				"  ?, ?, replace(?, '-', ''), ?, ?,"+
				"  ?, to_char(sysdate,'YYYYMMDD'), ?, ?, ?)";


		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString (1,  bean.getCar_mng_id().trim());
			pstmt.setString (2,  bean.getIns_st().trim());
			pstmt.setString (3,  bean.getExp_st().trim());
			pstmt.setString (4,  bean.getExp_aim().trim());
			pstmt.setString (5,  bean.getExp_dt().trim());
			pstmt.setString (6,  bean.getReq_dt().trim());
			pstmt.setInt	(7,  bean.getUse_day1());
			pstmt.setInt	(8,  bean.getUse_day2());
			pstmt.setInt	(9,  bean.getUse_day3());
			pstmt.setInt	(10, bean.getUse_day4());
			pstmt.setInt	(11, bean.getUse_day5());
			pstmt.setInt	(12, bean.getUse_day6());
			pstmt.setInt	(13, bean.getUse_day7());
			pstmt.setInt	(14, bean.getUse_amt1());
			pstmt.setInt	(15, bean.getUse_amt2());
			pstmt.setInt	(16, bean.getUse_amt3());
			pstmt.setInt	(17, bean.getUse_amt4());
			pstmt.setInt	(18, bean.getUse_amt5());
			pstmt.setInt	(19, bean.getUse_amt6());
			pstmt.setInt	(20, bean.getUse_amt7());
			pstmt.setString (21, bean.getExp_yn1().trim());
			pstmt.setString (22, bean.getExp_yn2().trim());
			pstmt.setString (23, bean.getExp_yn3().trim());
			pstmt.setString (24, bean.getExp_yn4().trim());
			pstmt.setString (25, bean.getExp_yn5().trim());
			pstmt.setString (26, bean.getExp_yn6().trim());
			pstmt.setString (27, bean.getExp_yn7().trim());
			pstmt.setInt	(28, bean.getTot_ins_amt());
			pstmt.setInt	(29, bean.getTot_use_amt());
			pstmt.setInt	(30, bean.getNopay_amt());
			pstmt.setInt	(31, bean.getRtn_est_amt());
			pstmt.setInt	(32, bean.getRtn_amt());
			pstmt.setString	(33, bean.getRtn_dt().trim());
			pstmt.setInt	(34, bean.getDif_amt());
			pstmt.setString	(35, bean.getDif_cau().trim());
			pstmt.setString	(36, bean.getReg_id().trim());
			pstmt.setString	(37, bean.getUpd_id().trim());
			pstmt.setString	(38, bean.getUpd_dt());
			pstmt.setString	(39, bean.getCls_st());

		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[InsDatabase:insertInsCls]"+ e);
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
	public boolean updateInsCls(InsurClsBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";

		query = " update ins_cls set"+
					" exp_st		=?,"+
					" exp_aim		=?,"+
					" exp_dt		=replace(?, '-', ''),"+
					" req_dt		=replace(?, '-', ''),"+
					" use_day1		=?,"+
					" use_day2		=?,"+
					" use_day3		=?,"+
					" use_day4		=?,"+
					" use_day5		=?,"+
					" use_day6		=?,"+
					" use_day7		=?,"+
					" use_amt1		=?,"+
					" use_amt2		=?,"+
					" use_amt3		=?,"+
					" use_amt4		=?,"+
					" use_amt5		=?,"+
					" use_amt6		=?,"+
					" use_amt7		=?,"+
					" exp_yn1		=?,"+
					" exp_yn2		=?,"+
					" exp_yn3		=?,"+
					" exp_yn4		=?,"+
					" exp_yn5		=?,"+
					" exp_yn6		=?,"+
					" exp_yn7		=?,"+
					" tot_ins_amt	=?,"+
					" tot_use_amt	=?,"+
					" nopay_amt		=?,"+
					" rtn_est_amt	=?,"+
					" rtn_amt		=?,"+
					" rtn_dt		=replace(?, '-', ''),"+
					" dif_amt		=?,"+
					" dif_cau		=?,"+
					" upd_id		=?,"+
					" upd_dt		=to_char(sysdate,'YYYYMMDD'),"+
					" cls_st		=? "+
					" where CAR_MNG_ID=? and INS_ST=?";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString (1,  bean.getExp_st		());
			pstmt.setString (2,  bean.getExp_aim	());
			pstmt.setString (3,  bean.getExp_dt		());
			pstmt.setString (4,  bean.getReq_dt		());
			pstmt.setInt	(5,  bean.getUse_day1	());
			pstmt.setInt	(6,  bean.getUse_day2	());
			pstmt.setInt	(7,  bean.getUse_day3	());
			pstmt.setInt	(8,  bean.getUse_day4	());
			pstmt.setInt	(9,  bean.getUse_day5	());
			pstmt.setInt	(10, bean.getUse_day6	());
			pstmt.setInt	(11, bean.getUse_day7	());
			pstmt.setInt	(12, bean.getUse_amt1	());
			pstmt.setInt	(13, bean.getUse_amt2	());
			pstmt.setInt	(14, bean.getUse_amt3	());
			pstmt.setInt	(15, bean.getUse_amt4	());
			pstmt.setInt	(16, bean.getUse_amt5	());
			pstmt.setInt	(17, bean.getUse_amt6	());
			pstmt.setInt	(18, bean.getUse_amt7	());
			pstmt.setString (19, bean.getExp_yn1	());
			pstmt.setString (20, bean.getExp_yn2	());
			pstmt.setString (21, bean.getExp_yn3	());
			pstmt.setString (22, bean.getExp_yn4	());
			pstmt.setString (23, bean.getExp_yn5	());
			pstmt.setString (24, bean.getExp_yn6	());
			pstmt.setString (25, bean.getExp_yn7	());
			pstmt.setInt	(26, bean.getTot_ins_amt());
			pstmt.setInt	(27, bean.getTot_use_amt());
			pstmt.setInt	(28, bean.getNopay_amt	());
			pstmt.setInt	(29, bean.getRtn_est_amt());
			pstmt.setInt	(30, bean.getRtn_amt	());
			pstmt.setString	(31, bean.getRtn_dt		());
			pstmt.setInt	(32, bean.getDif_amt	());
			pstmt.setString	(33, bean.getDif_cau	());
			pstmt.setString	(34, bean.getUpd_id		());
			pstmt.setString	(35, bean.getCls_st		());
			pstmt.setString (36, bean.getCar_mng_id	());
			pstmt.setString (37, bean.getIns_st		());
		    pstmt.executeUpdate();
			pstmt.close();
		    
		    conn.commit();

	  	} catch (Exception e) {
			System.out.println("[InsDatabase:updateInsCls]"+ e);
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

	//차량번호변경(용도변경) 현황
	public Vector getCarNoCng(String c_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select * from car_change where car_mng_id=? and cha_cau='2'";

		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString (1, c_id);
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
			
			System.out.println("[InsDatabase:getCarNoCng]"+ e);
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

	//해지보험 조회
	public InsurClsBean getInsurClsCase(String c_id, String ins_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		InsurClsBean bean = new InsurClsBean();
		String query = "";		
       	query = " select * from ins_cls where car_mng_id=? and ins_st=?";
	
		try 
		{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, c_id);
			pstmt.setString(2, ins_st);
		    rs = pstmt.executeQuery();
            if(rs.next())
            {
			    bean.setCar_mng_id	(rs.getString(1)==null?"":rs.getString(1));
			    bean.setIns_st		(rs.getString(2)==null?"":rs.getString(2));
			    bean.setExp_st		(rs.getString(3)==null?"":rs.getString(3));
			    bean.setExp_aim		(rs.getString(4)==null?"":rs.getString(4));
			    bean.setExp_dt		(rs.getString(5)==null?"":rs.getString(5));
			    bean.setReq_dt		(rs.getString(6)==null?"":rs.getString(6));
			    bean.setUse_day1	(rs.getInt   (7));		
			    bean.setUse_day2	(rs.getInt   (8));		
			    bean.setUse_day3	(rs.getInt   (9));		
			    bean.setUse_day4	(rs.getInt   (10));		
			    bean.setUse_day5	(rs.getInt   (11));		
			    bean.setUse_day6	(rs.getInt   (12));		
			    bean.setUse_day7	(rs.getInt   (13));		
			    bean.setUse_amt1	(rs.getInt   (14));		
			    bean.setUse_amt2	(rs.getInt   (15));		
			    bean.setUse_amt3	(rs.getInt   (16));		
			    bean.setUse_amt4	(rs.getInt   (17));		
			    bean.setUse_amt5	(rs.getInt   (18));		
			    bean.setUse_amt6	(rs.getInt   (19));		
			    bean.setUse_amt7	(rs.getInt   (20));		
			    bean.setExp_yn1		(rs.getString(21)==null?"":rs.getString(21));
			    bean.setExp_yn2		(rs.getString(22)==null?"":rs.getString(22));
			    bean.setExp_yn3		(rs.getString(23)==null?"":rs.getString(23));
				bean.setExp_yn4		(rs.getString(24)==null?"":rs.getString(24));
				bean.setExp_yn5		(rs.getString(25)==null?"":rs.getString(25));
				bean.setExp_yn6		(rs.getString(26)==null?"":rs.getString(26));
				bean.setExp_yn7		(rs.getString(27)==null?"":rs.getString(27));
				bean.setTot_ins_amt	(rs.getInt   (28));		
			    bean.setTot_use_amt	(rs.getInt   (29));		
			    bean.setNopay_amt	(rs.getInt   (30));		
			    bean.setRtn_est_amt	(rs.getInt   (31));		
			    bean.setRtn_amt		(rs.getInt   (32));		
			    bean.setRtn_dt		(rs.getString(33)==null?"":rs.getString(33));
			    bean.setDif_amt		(rs.getInt   (34));		
			    bean.setDif_cau		(rs.getString(35)==null?"":rs.getString(35));
			    bean.setReg_id		(rs.getString(36)==null?"":rs.getString(36));
			    bean.setReg_dt		(rs.getString(37)==null?"":rs.getString(37));
			    bean.setUpd_id		(rs.getString(38)==null?"":rs.getString(38));
			    bean.setUpd_dt		(rs.getString(39)==null?"":rs.getString(39));
			    bean.setCls_st		(rs.getString(40)==null?"":rs.getString(40));
            }
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[InsDatabase:getInsurClsCase]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
		                if(rs != null )		rs.close();
                		if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}
    }

	//보험현황 - 1.보험가입현황
	public Hashtable getInsStat1(int idx)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
        String query = "";
		String s_dt = "ins_start_dt";
		String t_dt = "to_char(sysdate,'YYYYMMDD')";
		String s_amt = "(rins_pcp_amt+vins_pcp_amt+vins_gcp_amt+vins_bacdt_amt+vins_canoisr_amt+vins_share_extra_amt+vins_cacdt_cm_amt+vins_spe_amt)";//-vins_blackbox_amt

		if(idx == 1){//당월/당일 가입
			query = " select"+
					" count(decode(reg_cau,'1',reg_cau)) MC1,"+
					" count(decode(reg_cau,'2',reg_cau)) MC2,"+
					" count(decode(reg_cau,'3',reg_cau,'4',reg_cau)) MC3,"+
					" count(decode("+s_dt+","+t_dt+",decode(reg_cau,'1',reg_cau))) DC1,"+
					" count(decode("+s_dt+","+t_dt+",decode(reg_cau,'2',reg_cau))) DC2,"+
					" count(decode("+s_dt+","+t_dt+",decode(reg_cau,'3',reg_cau,'4',reg_cau))) DC3,"+
					" sum(decode(reg_cau,'1',"+s_amt+")) MA1,"+
					" sum(decode(reg_cau,'2',"+s_amt+")) MA2,"+
					" sum(decode(reg_cau,'3',"+s_amt+",'4',"+s_amt+")) MA3,"+
					" sum(decode("+s_dt+","+t_dt+",decode(reg_cau,'1',"+s_amt+"))) DA1,"+
					" sum(decode("+s_dt+","+t_dt+",decode(reg_cau,'2',"+s_amt+"))) DA2,"+
					" sum(decode("+s_dt+","+t_dt+",decode(reg_cau,'3',"+s_amt+",'4',"+s_amt+"))) DA3"+
					" from insur where "+s_dt+" like to_char(sysdate,'YYYYMM')||'%'";
		}else if(idx == 2){//미가입
			query = " select a.NC1, b.NC2, c.NC3 from"+
					" (select count(*) as NC1 from cont a, car_reg c, insur b where a.car_mng_id=c.car_mng_id and a.car_mng_id=b.car_mng_id(+) and nvl(a.use_yn,'Y')='Y' and a.rent_l_cd not like 'RM%' and a.car_mng_id >0 and nvl(b.car_mng_id,'N')='N') a,"+
					" (SELECT sum(count(*)) as NC2 "+
					"  FROM   CAR_CHANGE a, CONT b, "+
					"         (SELECT a.car_mng_id, nvl(b.exp_dt,a.ins_exp_dt) exp_dt FROM INSUR a, INS_CLS b WHERE a.car_mng_id=b.car_mng_id(+) AND a.ins_st=b.ins_st(+)) c "+
					"  WHERE  a.cha_cau='2' and a.cha_dt > '20041231' "+
					"         AND a.car_mng_id=b.car_mng_id AND nvl(b.use_yn,'Y')='Y' and b.rent_l_cd not like 'RM%' "+
					"         AND a.car_mng_id=c.car_mng_id(+) AND a.cha_dt=c.exp_dt(+) AND c.car_mng_id IS null "+
					"  group by a.car_mng_id"+
					" ) b,"+
					" (select count(*) as NC3"+
					"		from insur a, cont b, sui c, car_reg d, cls_cont e "+
					"		where a.ins_sts='1' "+
					"       and a.car_mng_id=b.car_mng_id "+
					"       and b.rent_mng_id=e.rent_mng_id(+) and b.rent_l_cd=e.rent_l_cd(+) "+
//					"       and nvl(b.use_yn,'Y')='Y' "+
					"       and decode(b.use_yn,'Y','Y','','Y',decode(e.cls_st,'8','Y','N'))='Y' and b.rent_l_cd not like 'RM%' \n"+//살아있거나 매입옵션 명의이전인 차량
					"       and a.car_mng_id=c.car_mng_id(+) and nvl(c.migr_dt,'N')='N'"+
					"		and a.ins_st=(select max(TO_NUMBER(ins_st)) from insur where car_mng_id=a.car_mng_id and ins_sts='1')"+
					"		and a.car_mng_id=d.car_mng_id(+) and nvl(d.prepare,'0')<>'4'"+
					"		and a.ins_exp_dt<="+t_dt+
					" ) c";

		}else if(idx == 3){//기타
			query = " SELECT sum(count(*)) kcount FROM  (   \n"+
					" SELECT a.car_mng_id , NVL(b.scount,0) AS scount ,d.migr_dt,c.car_no, decode(e.ins_kd,'2','책임보험', '종합보험') as ins_kd, a.rent_l_cd, a.rent_mng_id, c.car_num, \n"+
					"  decode(e.ins_sts,'1','유효', '2','만료', '3','중도해지','5','승계') as ins_sts ,decode(e.car_use,'1','영업용', '업무용') as car_use, h.exp_dt, g.ins_com_nm,  \n "+
					"   e.ins_st, e.ins_start_dt, e.ins_exp_dt, e.ins_rent_dt, e.ins_con_no, c.car_nm,  (decode(e.air_ds_yn,'Y',1,0)+decode(e.air_as_yn,'Y',1,0)) as air, \n "+
					"  decode(e.age_scp,'1','21세이상','2','26세이상','4','24세이상','3','모든운전자','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하') as age_scp, '현재 보험가입 등록이 안되어 있음' as cont  \n"+
					" FROM cont a, (SELECT car_mng_id, ins_sts, count(car_mng_id) AS scount FROM insur  GROUP BY car_mng_id,ins_sts HAVING ins_sts =1) b, car_reg c,  \n "+
					"  sui d , insur e, (SELECT car_mng_id,MAX(TO_NUMBER(ins_st)) AS ins_st FROM insur GROUP BY car_mng_id) f, ins_com g, ins_cls h   \n "+
					"  WHERE a.CAR_MNG_ID = b.car_mng_id(+)   \n "+
					"  AND nvl(a.use_yn,'Y')='Y' \n"+
					"  AND a.car_mng_id = c.car_mng_id(+)  \n"+
					"  AND a.car_mng_id IS NOT NULL  \n"+
					"	AND NVL(c.prepare,'0') NOT IN('4','9')  \n "+
					"	 AND c.off_ls<>'5'   \n "+
					"  AND c.car_mng_id = d.car_mng_id(+)  \n "+
					"   AND migr_dt IS null   \n "+
					"   AND a.car_mng_id = e.car_mng_id  \n "+
					"   AND e.car_mng_id = f.car_mng_id  \n "+
					"  AND e.ins_com_id = g.ins_com_id   \n "+
					" AND e.car_mng_id = h.car_mng_id   \n "+
					"  AND e.ins_st = h.ins_st   \n "+
					"   AND e.ins_st = f.ins_st    \n "+
					"  ) z   \n "+
					"  where z.scount = 0   \n "+
					"   group BY z.car_mng_id";

		}



		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
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
			pstmt.close();
		} catch (SQLException e) {
			
			System.out.println("[InsDatabase:getInsStat1]"+ e);
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

	//보험현황 - 2.납입보험료
	public Hashtable getInsStat2(int idx)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
        String query = "";
		String s_dt = "b.r_ins_est_dt";
		String t_dt = "to_char(sysdate,'YYYYMMDD')";
		String s_amt = "b.pay_amt";

		if(idx == 1){//당월/당일 지출/잔액
			query = " select"+
					" count(decode(b.pay_yn,'1',decode(a.reg_cau,'1',a.reg_cau))) MC1,"+
					" count(decode(b.pay_yn,'1',decode(a.reg_cau,'2',a.reg_cau))) MC2,"+
					" count(decode(b.pay_yn,'1',decode(a.reg_cau,'3',a.reg_cau,'4',a.reg_cau))) MC3,"+
					" count(decode(b.pay_yn,'0',decode(a.reg_cau,'1',a.reg_cau))) MC4,"+
					" count(decode(b.pay_yn,'0',decode(a.reg_cau,'2',a.reg_cau))) MC5,"+
					" count(decode(b.pay_yn,'0',decode(a.reg_cau,'3',a.reg_cau,'4',a.reg_cau))) MC6,"+
					" count(decode(b.pay_yn,'1',decode("+s_dt+","+t_dt+",decode(a.reg_cau,'1',a.reg_cau)))) DC1,"+
					" count(decode(b.pay_yn,'1',decode("+s_dt+","+t_dt+",decode(a.reg_cau,'2',a.reg_cau)))) DC2,"+
					" count(decode(b.pay_yn,'1',decode("+s_dt+","+t_dt+",decode(a.reg_cau,'3',a.reg_cau,'4',a.reg_cau)))) DC3,"+
					" count(decode(b.pay_yn,'0',decode("+s_dt+","+t_dt+",decode(a.reg_cau,'1',a.reg_cau)))) DC4,"+
					" count(decode(b.pay_yn,'0',decode("+s_dt+","+t_dt+",decode(a.reg_cau,'2',a.reg_cau)))) DC5,"+
					" count(decode(b.pay_yn,'0',decode("+s_dt+","+t_dt+",decode(a.reg_cau,'3',a.reg_cau,'4',a.reg_cau)))) DC6,"+
					" sum(decode(b.pay_yn,'1',decode(a.reg_cau,'1',("+s_amt+")))) MA1,"+
					" sum(decode(b.pay_yn,'1',decode(a.reg_cau,'2',("+s_amt+")))) MA2,"+
					" sum(decode(b.pay_yn,'1',decode(a.reg_cau,'3',("+s_amt+"),'4',("+s_amt+")))) MA3,"+
					" sum(decode(b.pay_yn,'0',decode(a.reg_cau,'1',("+s_amt+")))) MA4,"+
					" sum(decode(b.pay_yn,'0',decode(a.reg_cau,'2',("+s_amt+")))) MA5,"+
					" sum(decode(b.pay_yn,'0',decode(a.reg_cau,'3',("+s_amt+"),'4',("+s_amt+")))) MA6,"+
					" sum(decode(b.pay_yn,'1',decode("+s_dt+","+t_dt+",decode(a.reg_cau,'1',("+s_amt+"))))) DA1,"+
					" sum(decode(b.pay_yn,'1',decode("+s_dt+","+t_dt+",decode(a.reg_cau,'2',("+s_amt+"))))) DA2,"+
					" sum(decode(b.pay_yn,'1',decode("+s_dt+","+t_dt+",decode(a.reg_cau,'3',("+s_amt+"),'4',("+s_amt+"))))) DA3,"+
					" sum(decode(b.pay_yn,'0',decode("+s_dt+","+t_dt+",decode(a.reg_cau,'1',("+s_amt+"))))) DA4,"+
					" sum(decode(b.pay_yn,'0',decode("+s_dt+","+t_dt+",decode(a.reg_cau,'2',("+s_amt+"))))) DA5,"+
					" sum(decode(b.pay_yn,'0',decode("+s_dt+","+t_dt+",decode(a.reg_cau,'3',("+s_amt+"),'4',("+s_amt+"))))) DA6"+
					" from insur a, scd_ins b where b.ins_tm2<>'2' and a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st and "+s_dt+" like to_char(sysdate,'YYYYMM')||'%'";
		}else if(idx == 2){//기일경과 지출/잔액
			query = " select"+
					" count(decode(b.pay_yn,'1',decode(b.pay_dt,"+t_dt+",decode(a.reg_cau,'1',a.reg_cau)))) NC1,"+
					" count(decode(b.pay_yn,'1',decode(b.pay_dt,"+t_dt+",decode(a.reg_cau,'2',a.reg_cau)))) NC2,"+
					" count(decode(b.pay_yn,'1',decode(b.pay_dt,"+t_dt+",decode(a.reg_cau,'3',a.reg_cau,'4',a.reg_cau)))) NC3,"+
					" count(decode(b.pay_yn,'0',decode(a.reg_cau,'1',a.reg_cau))) NC4,"+
					" count(decode(b.pay_yn,'0',decode(a.reg_cau,'2',a.reg_cau))) NC5,"+
					" count(decode(b.pay_yn,'0',decode(a.reg_cau,'3',a.reg_cau,'4',a.reg_cau))) NC6,"+
					" sum(decode(b.pay_yn,'1',decode(b.pay_dt,"+t_dt+",decode(a.reg_cau,'1',("+s_amt+"))))) NA1,"+
					" sum(decode(b.pay_yn,'1',decode(b.pay_dt,"+t_dt+",decode(a.reg_cau,'2',("+s_amt+"))))) NA2,"+
					" sum(decode(b.pay_yn,'1',decode(b.pay_dt,"+t_dt+",decode(a.reg_cau,'3',("+s_amt+"),'4',("+s_amt+"))))) NA3,"+
					" sum(decode(b.pay_yn,'0',decode(a.reg_cau,'1',("+s_amt+")))) NA4,"+
					" sum(decode(b.pay_yn,'0',decode(a.reg_cau,'2',("+s_amt+")))) NA5,"+
					" sum(decode(b.pay_yn,'0',decode(a.reg_cau,'3',("+s_amt+"),'4',("+s_amt+")))) NA6"+
					" from insur a, scd_ins b where b.ins_tm2<>'2' and a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st and (b.pay_yn='0' or b.pay_dt="+t_dt+") and "+s_dt+" < "+t_dt+"";
		}
		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
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
			pstmt.close();
		} catch (SQLException e) {
			
			System.out.println("[InsDatabase:getInsStat2]"+ e);
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

	//보험현황 - 3.보험사항변경현황
	public Hashtable getInsStat3(int idx)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
        String query = "";
		String s_dt = "exp_dt";
		String t_dt = "to_char(sysdate,'YYYYMMDD')";
		String s_amt = "(nvl(rtn_amt,rtn_est_amt))";

		if(idx == 1){//당월/당일
			query = " select"+
					" count(decode(exp_st,'1',exp_st)) MC1,"+
					" count(decode(exp_st,'2',exp_st)) MC2,"+
					" count(decode(exp_aim,'3',exp_aim)) MC3,"+
					" count(decode(exp_aim,'4',exp_aim)) MC4,"+
					" count(decode(exp_aim,'5',exp_aim)) MC5,"+
					" count(decode("+s_dt+","+t_dt+",decode(exp_st,'1',exp_st))) DC1,"+
					" count(decode("+s_dt+","+t_dt+",decode(exp_st,'2',exp_st))) DC2,"+
					" count(decode("+s_dt+","+t_dt+",decode(exp_aim,'3',exp_aim))) DC3,"+
					" count(decode("+s_dt+","+t_dt+",decode(exp_aim,'4',exp_aim))) DC4,"+
					" count(decode("+s_dt+","+t_dt+",decode(exp_aim,'5',exp_aim))) DC5,"+
					" ABS(sum(decode(exp_st,'1',"+s_amt+"))) MA1,"+
					" ABS(sum(decode(exp_st,'2',"+s_amt+"))) MA2,"+
					" ABS(sum(decode(exp_aim,'3',"+s_amt+"))) MA3,"+
					" ABS(sum(decode(exp_aim,'4',"+s_amt+"))) MA4,"+
					" ABS(sum(decode(exp_aim,'5',"+s_amt+"))) MA5,"+
					" ABS(sum(decode("+s_dt+","+t_dt+",decode(exp_st,'1',"+s_amt+")))) DA1,"+
					" ABS(sum(decode("+s_dt+","+t_dt+",decode(exp_st,'2',"+s_amt+")))) DA2,"+
					" ABS(sum(decode("+s_dt+","+t_dt+",decode(exp_aim,'3',"+s_amt+")))) DA3,"+
					" ABS(sum(decode("+s_dt+","+t_dt+",decode(exp_aim,'4',"+s_amt+")))) DA4,"+
					" ABS(sum(decode("+s_dt+","+t_dt+",decode(exp_aim,'5',"+s_amt+")))) DA5"+
					" from ins_cls where "+s_dt+" like to_char(sysdate,'YYYYMM')||'%'";
		}else if(idx == 2){
		}

		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
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
			pstmt.close();
		} catch (SQLException e) {
			
			System.out.println("[InsDatabase:getInsStat3]"+ e);
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

	//보험현황 - 4.보험해지현황
	public Hashtable getInsStat4(int idx)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
        String query = "";
		String s_dt = "a.req_dt";
		String t_dt = "to_char(sysdate,'YYYYMMDD')";
		String s_amt = "(nvl(a.rtn_amt,a.rtn_est_amt))";

		if(idx == 1){//당월/당일
			query = " select"+
					" count(decode(nvl(b.car_use,'1'),'1',nvl(b.car_use,'1'))) MC1,"+
					" count(decode(b.car_use,'2',decode(b.ins_kd,'1',decode(a.exp_yn1,'N',a.exp_yn1)))) MC2,"+
					" count(decode(b.car_use,'2',decode(b.ins_kd,'1',decode(a.exp_yn1,'Y',a.exp_yn1)))) MC3,"+
					" count(decode(b.car_use,'2',decode(b.ins_kd,'2',b.ins_kd))) MC4,"+
					" count(decode("+s_dt+","+t_dt+",decode(b.car_use,'1',nvl(b.car_use,'1')))) DC1,"+
					" count(decode("+s_dt+","+t_dt+",decode(b.car_use,'2',decode(nvl(b.car_use,'1'),'1',decode(a.exp_yn1,'N',a.exp_yn1))))) DC2,"+
					" count(decode("+s_dt+","+t_dt+",decode(b.car_use,'2',decode(b.ins_kd,'1',decode(a.exp_yn1,'Y',a.exp_yn1))))) DC3,"+
					" count(decode("+s_dt+","+t_dt+",decode(b.car_use,'2',decode(b.ins_kd,'2',b.ins_kd)))) DC4,"+
					" ABS(sum(decode(nvl(b.car_use,'1'),'1',"+s_amt+"))) MA1,"+
					" ABS(sum(decode(b.car_use,'2',decode(b.ins_kd,'1',decode(a.exp_yn1,'N',"+s_amt+"))))) MA2,"+
					" ABS(sum(decode(b.car_use,'2',decode(b.ins_kd,'1',decode(a.exp_yn1,'Y',"+s_amt+"))))) MA3,"+
					" ABS(sum(decode(b.car_use,'2',decode(b.ins_kd,'2',"+s_amt+")))) MA4,"+
					" ABS(sum(decode("+s_dt+","+t_dt+",decode(b.car_use,'1',"+s_amt+")))) DA1,"+
					" ABS(sum(decode("+s_dt+","+t_dt+",decode(b.car_use,'2',decode(nvl(b.car_use,'1'),'1',decode(a.exp_yn1,'N',"+s_amt+")))))) DA2,"+
					" ABS(sum(decode("+s_dt+","+t_dt+",decode(b.car_use,'2',decode(b.ins_kd,'1',decode(a.exp_yn1,'Y',"+s_amt+")))))) DA3,"+
					" ABS(sum(decode("+s_dt+","+t_dt+",decode(b.car_use,'2',decode(b.ins_kd,'2',"+s_amt+"))))) DA4"+
					" from ins_cls a, insur b where "+s_dt+" like to_char(sysdate,'YYYYMM')||'%' and a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st";
		}else if(idx == 2){
			query = " select"+
					" count(decode(d.cha_cau,'2',decode(c.migr_dt,'',decode(nvl(a.car_use,'1'),'1',decode(a.car_use,'1','',nvl(a.car_use,'1')))))) NC1,"+
					" count(decode(d.cha_cau,'2',decode(c.migr_dt,'',decode(nvl(a.car_use,'1'),'2',decode(a.car_use,'1',nvl(a.car_use,'1')))))) NC2,"+
					" count(decode(nvl(a.car_use,'1'),'1',decode(c.migr_dt,'','',c.migr_dt))) NC3,"+
					" count(decode(nvl(a.car_use,'1'),'2',decode(c.migr_dt,'','',c.migr_dt))) NC4"+
					" from insur a, car_reg b, sui c, car_change d where a.ins_sts='1' and a.car_mng_id=b.car_mng_id and a.car_mng_id=c.car_mng_id(+) and a.car_mng_id=d.car_mng_id(+) "+
					" and (d.cha_cau='2' or c.migr_dt is not null) ";
		}

		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
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
			pstmt.close();
		} catch (SQLException e) {
			
			System.out.println("[InsDatabase:getInsStat4]"+ e);
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

	//보험현황 - 5.보험료환급현황
	public Hashtable getInsStat5(int idx)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
        String query = "";
		String s_dt = "r_ins_est_dt";
		String t_dt = "to_char(sysdate,'YYYYMMDD')";
		String s_amt = "pay_amt";

		if(idx == 1){//당월
			query = " select"+
					" count(decode(pay_yn,'1',pay_yn)) MC1,"+
					" count(decode(pay_yn,'0',pay_yn)) MC2,"+
					" ABS(sum(decode(pay_yn,'1',"+s_amt+"))) MA1,"+
					" ABS(sum(decode(pay_yn,'0',"+s_amt+"))) MA2"+
					" from scd_ins where ins_tm2='2' and "+s_dt+" like to_char(sysdate,'YYYYMM')||'%'";
		}else if(idx == 2){//당일
			query = " select"+
					" count(decode(pay_yn,'1',pay_yn)) DC1,"+
					" count(decode(pay_yn,'0',pay_yn)) DC2,"+
					" ABS(sum(decode(pay_yn,'1',"+s_amt+"))) DA1,"+
					" ABS(sum(decode(pay_yn,'0',"+s_amt+"))) DA2"+
					" from scd_ins where ins_tm2='2' and "+s_dt+" between to_char(sysdate-5,'YYYYMMDD') and "+t_dt+"";
		}else if(idx == 3){//연체
			query = " select"+
					" count(decode(pay_dt,"+t_dt+",pay_yn)) NC1,"+
					" count(decode(pay_yn,'0',pay_yn)) NC2,"+
					" ABS(sum(decode(pay_dt,"+t_dt+","+s_amt+"))) NA1,"+
					" ABS(sum(decode(pay_yn,'0',"+s_amt+"))) NA2"+
					" from scd_ins where ins_tm2='2' and "+s_dt+" < to_char(sysdate-5,'YYYYMMDD') and (pay_yn='0' or pay_dt = "+t_dt+")";
		}
		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
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
			pstmt.close();
		} catch (SQLException e) {
			
			System.out.println("[InsDatabase:getInsStat5]"+ e);
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

	//보험관리 리스트 조회
	public Vector getInsMngList(String br_id, String gubun0, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String gubun7, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String s_dt = "";
	
		if(t_wd.equals("")){
			if(gubun3.equals("") || gubun3.equals("1") || gubun3.equals("2")){//전체, 신규, 갱신
				query = " select\n"+
						"        decode(a.ins_kd,'2','책임보험', '종합보험') as ins_kd,\n"+
						"        decode(a.ins_sts,'1','유효', '2','만료', '3','중도해지','5','승계') as ins_sts,\n"+
						"        a.car_mng_id, a.ins_st, c.car_no, c.car_nm, b.ins_com_nm, d.rent_mng_id, d.rent_l_cd,\n"+
						"        decode(a.car_use,'1','영업용', '업무용') as car_use,\n"+
						"        a.ins_start_dt, a.ins_exp_dt, a.ins_rent_dt, \n"+
						"        decode(a.age_scp,'1','21세이상','2','26세이상','4','24세이상','3','모든운전자','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하') as age_scp,\n"+
						"        (decode(a.air_ds_yn,'Y',1,0)+decode(a.air_as_yn,'Y',1,0)) as air,\n"+
						"        decode(e.migr_dt,'','Y','N') as use_yn, e.migr_dt, f.exp_dt, f.req_dt, a.ins_con_no\n"+
						" from   insur a, ins_com b, car_reg c, cont d, sui e, ins_cls f \n"+
						" where  a.ins_com_id=b.ins_com_id and a.car_mng_id=c.car_mng_id"+
						"        and a.car_mng_id=d.car_mng_id and d.reg_dt||d.rent_l_cd=(select max(reg_dt||rent_l_cd) from cont where rent_l_cd not like 'RM%' and car_mng_id=a.car_mng_id)"+
						"        and a.car_mng_id=e.car_mng_id(+)"+
						"        and a.car_mng_id=f.car_mng_id(+) and a.ins_st=f.ins_st(+)"+
						" ";
	
				s_dt = "a.ins_start_dt";
		
		
				if(gubun3.equals("1") && gubun4.equals("1"))			query += " and nvl(a.reg_cau,'1') = '1'";
				else if(gubun3.equals("1") && gubun4.equals("2"))		query += " and nvl(a.reg_cau,'1') = '2'";
				else if(gubun3.equals("1") && gubun4.equals(""))		query += " and nvl(a.reg_cau,'1') in ('1','2')";
				else if(gubun3.equals("2") && gubun4.equals("3"))		query += " and nvl(a.reg_cau,'1') = '3'";
				else if(gubun3.equals("2") && gubun4.equals("4"))		query += " and nvl(a.reg_cau,'1') = '4'";
				else if(gubun3.equals("2") && gubun4.equals(""))		query += " and nvl(a.reg_cau,'1') in ('3','4')";
	
		
			}else if(gubun3.equals("4")){//추가
				query = " select\n"+
						" decode(a.ins_kd,'2','책임보험', '종합보험') as ins_kd,\n"+
						" decode(a.ins_sts,'1','유효', '2','만료', '3','중도해지','5','승계') as ins_sts,\n"+
						" a.car_mng_id, a.ins_st, c.car_no, c.car_nm, b.ins_com_nm, d.rent_mng_id, d.rent_l_cd,\n"+
						" decode(a.car_use,'1','영업용', '업무용') as car_use,\n"+
						" a.ins_start_dt, a.ins_exp_dt, a.ins_rent_dt, \n"+
						" f.ch_dt, f.ch_item, f.ch_before, f.ch_after,"+
						" decode(e.migr_dt,'','Y','N') as use_yn, e.migr_dt, a.ins_con_no\n"+
						" from insur a, ins_com b, car_reg c, cont d, sui e, ins_change f\n"+
						" where a.ins_com_id=b.ins_com_id and a.car_mng_id=c.car_mng_id"+
						" and a.car_mng_id=d.car_mng_id and d.rent_l_cd=(select max(rent_l_cd) from cont where rent_l_cd not like 'RM%' and car_mng_id=a.car_mng_id)"+
						" and a.car_mng_id=e.car_mng_id(+)"+
						" and a.car_mng_id=f.car_mng_id and a.ins_st=f.ins_st";
				s_dt = "f.ch_dt";
	
			}else if(gubun3.equals("3") || gubun3.equals("7")){//해지 && 변경
				query = " select\n"+
						" decode(a.ins_kd,'2','책임보험', '종합보험') as ins_kd,\n"+
						" decode(a.ins_sts,'1','유효', '2','만료', '3','중도해지','5','승계') as ins_sts,\n"+
						" a.car_mng_id, a.ins_st, c.car_no, c.car_nm, b.ins_com_nm, d.rent_mng_id, d.rent_l_cd,\n"+
						" decode(a.car_use,'1','영업용', '업무용') as car_use,\n"+
						" a.ins_start_dt, a.ins_exp_dt, a.ins_rent_dt, \n"+
						" decode(f.exp_st,'1','R->L', '2','L->R','없음') as exp_st,\n"+
						" decode(f.exp_aim,'1','재리스', '2','Self', '3','매각', '4','말소', '5','폐차') as exp_aim,\n"+
						" f.exp_dt, f.req_dt,"+
						" decode(e.migr_dt,'','Y','N') as use_yn, e.migr_dt, a.ins_con_no\n"+
						" from insur a, ins_com b, car_reg c, cont d, sui e, ins_cls f\n"+
						" where a.ins_com_id=b.ins_com_id and a.car_mng_id=c.car_mng_id"+
						" and a.car_mng_id=d.car_mng_id and d.rent_l_cd=(select max(rent_l_cd) from cont where rent_l_cd not like 'RM%' and car_mng_id=a.car_mng_id)"+
						" and a.car_mng_id=e.car_mng_id(+)"+
						" and a.car_mng_id=f.car_mng_id and a.ins_st=f.ins_st";
				if(gubun3.equals("3")){
					s_dt = "f.exp_dt";
					if(gubun4.equals("1"))									query += " and f.exp_st='1'";
					if(gubun4.equals("2"))									query += " and f.exp_st='2'";
					if(gubun4.equals("3"))									query += " and f.exp_aim='3'";
					if(gubun4.equals("4"))									query += " and f.exp_aim='4'";
					if(gubun4.equals("5"))									query += " and f.exp_aim='5'";
	
				}else if(gubun3.equals("7")){
					s_dt = "f.req_dt";
					if(gubun5.equals("1"))									query += " and nvl(a.ins_kd,'1') ='1' and f.exp_yn1='N'";
					if(gubun5.equals("2"))									query += " and nvl(a.ins_kd,'1') ='2' ";
					if(gubun5.equals("3"))									query += " and nvl(a.ins_kd,'1') ='1' and f.exp_yn1='Y'";
					gubun5 = "";
				}
					if(gubun1.equals("1"))									query += " and nvl(a.car_use,'1') ='1'";
					if(gubun1.equals("2"))									query += " and nvl(a.car_use,'1') ='2'";
					gubun1 = "";
	
			}else if(gubun3.equals("5")){//미가입
				query = " select\n"+
						" c.car_mng_id, d.rent_mng_id, d.rent_l_cd, d.cau, d.cont, d.dt, d.brch_id, c.car_no, c.car_nm, c.car_num, c.car_use \n"+
						" from car_reg c,\n"+
						"	(	select /*+  merge(a) */  a.car_mng_id, a.rent_mng_id, a.rent_l_cd, '신차' as cau, '(차량등록일)현재 보험가입 등록이 안되어 있음' as cont, c.init_reg_dt as dt, a.brch_id from cont_n_view a, insur b , car_reg c  where a.car_mng_id=b.car_mng_id(+) and a.car_mng_id = c.car_mng_id(+) and nvl(a.use_yn,'Y')='Y' and a.car_mng_id >0 and nvl(b.car_mng_id,'N')='N'"+
						"		union all"+
						"		select  "+
						"			a.car_mng_id, b.rent_mng_id, b.rent_l_cd, '용도변경' as cau, '(용도변경일)현재 보유중인 차량으로 용도변경일 기준 앞뒤 3일동안 가입한 보험이 없음, '||a.cha_cau_sub as cont, a.cha_dt as dt, b.brch_id"+
						"			from CAR_CHANGE a, CONT b,"+
						"                (SELECT a.car_mng_id, nvl(b.exp_dt,a.ins_exp_dt) exp_dt FROM INSUR a, INS_CLS b WHERE a.car_mng_id=b.car_mng_id(+) AND a.ins_st=b.ins_st(+)) c "+
						"			where a.cha_cau='2' and a.cha_dt > '20041231' "+
						"			AND a.car_mng_id=b.car_mng_id "+
						"           AND nvl(b.use_yn,'Y')='Y' and b.rent_l_cd not like 'RM%' "+
						"			AND a.car_mng_id=c.car_mng_id(+) AND a.cha_dt=c.exp_dt(+) AND c.car_mng_id IS null"+
						"		union all"+
						"		select"+
						"			a.car_mng_id, b.rent_mng_id, b.rent_l_cd, '갱신' as cau, '(보험만료일)현재 보유중인 차량으로 보험기간이 지났음' as cont, a.ins_exp_dt as dt, b.brch_id"+
						"			from insur a, cont b, sui c, cls_cont e"+
						"			where a.car_mng_id=b.car_mng_id "+
						"			AND b.rent_mng_id=e.rent_mng_id(+) and b.rent_l_cd=e.rent_l_cd(+) "+
	//							"	        and nvl(b.use_yn,'Y')='Y' and b.rent_l_cd not like 'RM%' "+
					    "           and decode(b.use_yn,'Y','Y','','Y',decode(e.cls_st,'8','Y','N'))='Y' and b.rent_l_cd not like 'RM%' \n"+//살아있거나 매입옵션 명의이전인 차량
						"	        and a.ins_sts='1' and a.car_mng_id=c.car_mng_id(+) and c.migr_dt is null"+
						"			and a.ins_st=(select max(TO_NUMBER(ins_st)) from insur where car_mng_id=a.car_mng_id and ins_sts='1')"+
						"			and a.ins_exp_dt<=to_char(sysdate,'YYYYMMDD')  "+
						"		union all"+
						"		select"+
						"			a.car_mng_id, b.rent_mng_id, b.rent_l_cd, '갱신' as cau, '(보험만료일)계약은 진행 중이나 보험상태는 진행건이 아님' as cont, a.ins_exp_dt as dt, b.brch_id"+
						"			from insur a, cont b, sui c, cls_cont e"+
						"			where a.car_mng_id=b.car_mng_id "+
						"			AND b.rent_mng_id=e.rent_mng_id(+) and b.rent_l_cd=e.rent_l_cd(+) "+
						"           and decode(b.use_yn,'Y','Y','','Y',decode(e.cls_st,'8','Y','N'))='Y' and b.rent_l_cd not like 'RM%' \n"+//살아있거나 매입옵션 명의이전인 차량
						"	        and a.ins_sts<>'1' and a.car_mng_id=c.car_mng_id(+) and c.migr_dt is null"+
						"			and a.ins_st=(select max(to_number(ins_st)) from insur where car_mng_id=a.car_mng_id)"+
						"			and a.ins_exp_dt<=to_char(sysdate,'YYYYMMDD') and a.ins_exp_dt >= 20100101 ";
				if(gubun1.equals("1") )									query += " and a.car_use='1'  "; 
				if(gubun1.equals("2") )									query += " and a.car_use<>'1'  "; 
				query += "	) d"+
						" where c.car_mng_id=d.car_mng_id" +
						" and nvl(c.PREPARE,0) <> 4" ;
	
				if(gubun4.equals("1"))									query += " and d.cau='신차'";
				if(gubun4.equals("2"))									query += " and d.cau='용도변경'";
				if(gubun4.equals("3"))									query += " and d.cau='갱신' and nvl(c.prepare,'0')<>'4'";
	
				gubun2 = "";
				gubun5 = "";
				gubun6 = "";
				if(s_kd.equals("4"))	s_kd = "";
				sort = "";
	
				//query += " order by decode(d.cau,'신차','1','용도변경','2','갱신','3'), d.dt";
	
			}else if(gubun3.equals("6")){//미해지
				query = " select\n"+
						" decode(a.ins_kd,'2','책임보험', '종합보험') as ins_kd,\n"+
						" decode(a.ins_sts,'1','유효', '2','만료', '3','중도해지','5','승계') as ins_sts,\n"+
						" a.car_mng_id, a.ins_st, c.car_no, c.car_nm, b.ins_com_nm, d.rent_mng_id, d.rent_l_cd, decode(a.car_use,'1','1','2') car_st,\n"+
						" decode(a.car_use,'1','영업용', '업무용') as car_use,\n"+
						" a.ins_start_dt, a.ins_exp_dt, a.ins_rent_dt, \n"+
						" decode(a.age_scp,'1','21세이상','2','26세이상','4','24세이상','3','모든운전자','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하') as age_scp,\n"+
						" (decode(a.air_ds_yn,'Y',1,0)+decode(a.air_as_yn,'Y',1,0)) as air,\n"+
						" decode(e.migr_dt,'','Y','N') as use_yn, e.migr_dt, f.cha_dt, a.ins_con_no\n"+
						" from insur a, ins_com b, car_reg c, cont d, sui e, car_change f\n"+
						" where a.ins_sts='1' and a.ins_com_id=b.ins_com_id and a.car_mng_id=c.car_mng_id"+
						" and a.car_mng_id=d.car_mng_id and d.rent_l_cd=(select max(rent_l_cd) from cont where rent_l_cd not like 'RM%' and car_mng_id=a.car_mng_id)"+
						" and a.car_mng_id=e.car_mng_id(+)"+
						" and a.car_mng_id=f.car_mng_id(+) and (f.cha_cau='2' or e.migr_dt is not null) ";				
	
				if(gubun1.equals("1"))									query += " and nvl(a.car_use,'1') ='1'";
				if(gubun1.equals("2"))									query += " and nvl(a.car_use,'1') ='2'";
				gubun1 = "";
	
				String type1 = "e.migr_dt is null and nvl(a.car_use,'1')<>decode(c.car_use,'1','1','2')";
				String type2 = "e.migr_dt is not null ";
		
				if(gubun4.equals("1"))			query += " and "+type1;
				else if(gubun4.equals("2"))		query += " and "+type2;
				else if(gubun4.equals(""))		query += " and (("+type1+") or ("+type2+"))";
	
	
				gubun1 = "";
				gubun2 = "";
				gubun5 = "";
				gubun6 = "";
				sort = "";
	
			}else if(gubun3.equals("8")){//기타
				query = " SELECT z.* FROM  (  \n"+
						"  SELECT a.car_mng_id , NVL(b.scount,0) AS scount ,d.migr_dt,c.car_no, decode(e.ins_kd,'2','책임보험', '종합보험') as ins_kd, a.rent_l_cd, a.rent_mng_id, c.car_num, \n"+
						" decode(e.ins_sts,'1','유효', '2','만료', '3','중도해지','5','승계') as ins_sts ,decode(e.car_use,'1','영업용', '업무용') as car_use, h.exp_dt, g.ins_com_nm, \n"+
						" e.ins_st, e.ins_start_dt, e.ins_exp_dt, e.ins_rent_dt, e.ins_con_no, c.car_nm,  (decode(e.air_ds_yn,'Y',1,0)+decode(e.air_as_yn,'Y',1,0)) as air, \n"+
						"  decode(e.age_scp,'1','21세이상','2','26세이상','4','24세이상','3','모든운전자','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하') as age_scp, '현재 보험가입 등록이 안되어 있음' as cont \n"+
						" FROM cont a, \n"+
						"  (SELECT car_mng_id, ins_sts, count(car_mng_id) AS scount FROM insur  GROUP BY car_mng_id,ins_sts HAVING ins_sts =1) b, car_reg c,  \n"+
						"  sui d , insur e, (SELECT car_mng_id,MAX(TO_NUMBER(ins_st)) AS ins_st FROM insur GROUP BY car_mng_id) f, ins_com g, ins_cls h  \n"+
						" WHERE a.CAR_MNG_ID = b.car_mng_id(+)  \n"+
						"  AND nvl(a.use_yn,'Y')='Y' \n"+
						" AND a.car_mng_id = c.car_mng_id(+) \n "+
						"  AND a.car_mng_id IS NOT NULL \n "+
						"  AND NVL(c.prepare,'0') NOT IN('4','9') \n "+
						" 	 AND c.off_ls<>'5'  \n "+
						"  AND c.car_mng_id = d.car_mng_id(+)  \n "+
						" AND migr_dt IS null  \n "+
						"  AND a.car_mng_id = e.car_mng_id \n "+
						"  AND e.car_mng_id = f.car_mng_id \n "+
						"  AND e.ins_com_id = g.ins_com_id \n "+
						"  AND e.car_mng_id = h.car_mng_id \n "+
						"  AND e.ins_st = h.ins_st \n "+
						"  AND e.ins_st = f.ins_st  "+
						"   ) z   "+
						" where z.scount = 0 ";			
	
	
				gubun1 = "";
				gubun2 = "";
				gubun5 = "";
				gubun6 = "";
				sort = "";
	
			}
	
				if(!brch_id.equals("S1") && !brch_id.equals(""))		query += " and d.brch_id = '"+brch_id+"'"; 
				if(brch_id.equals("S1"))								query += " and d.brch_id in ('S1','K1')"; 
	
				if(gubun1.equals("1"))									query += " and a.car_use='1'"; 
				if(gubun1.equals("2"))									query += " and a.car_use<>'1'"; 
	
				if(gubun2.equals("1"))									query += " and "+s_dt+" = to_char(sysdate,'YYYYMMDD')";
				else if(gubun2.equals("2") )							query += " and "+s_dt+" like to_char(sysdate,'YYYYMM')||'%'";
				else if(gubun2.equals("3"))								query += " and "+s_dt+" like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
				else if(gubun2.equals("4"))								query += " and "+s_dt+" like '"+AddUtil.getDate(1)+"%'";
				else if(gubun2.equals("5"))								query += " and "+s_dt+" between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";
	
				if(!gubun5.equals(""))									query += " and nvl(a.ins_kd,'1') ='"+gubun5+"'";
				if(!gubun6.equals(""))									query += " and nvl(a.ins_sts,'1') ='"+gubun6+"'";
	
				if(!t_wd.equals("")){
					if(s_kd.equals("1"))								query += " and (c.car_no like '%"+t_wd+"%' or c.first_car_no like '%"+t_wd+"%')\n";
					else if(s_kd.equals("2"))							query += " and upper(c.car_num) like upper('%"+t_wd+"%')\n";
					else if(s_kd.equals("3"))							query += " and c.car_nm like '%"+t_wd+"%'\n";
					else if(s_kd.equals("4"))							query += " and b.ins_com_nm like '%"+t_wd+"%'\n";
					else if(s_kd.equals("5"))							query += " and replace(a.ins_con_no,'-','') like '%"+t_wd+"%'\n";
				}
	
				if(asc.equals("0"))	asc = "asc";
				if(asc.equals("1"))	asc = "desc";
	
				if(sort.equals("1"))									query += " order by a.ins_sts, e.migr_dt desc, c.car_no "+asc;
				else if(sort.equals("2"))								query += " order by a.ins_sts, e.migr_dt desc, a.ins_start_dt "+asc;
				else if(sort.equals("3"))								query += " order by a.ins_sts, e.migr_dt desc, a.ins_exp_dt "+asc;
				
				
		}else{
			if(s_kd.equals("1") || s_kd.equals("2") || s_kd.equals("5")){
				query = " select\n"+
						"        decode(a.ins_kd,'2','책임보험', '종합보험') as ins_kd,\n"+
						"        decode(a.ins_sts,'1','유효', '2','만료', '3','중도해지','5','승계') as ins_sts,\n"+
						"        a.car_mng_id, a.ins_st, c.car_no, c.car_nm, b.ins_com_nm, d.rent_mng_id, d.rent_l_cd,\n"+
						"        decode(a.car_use,'1','영업용', '업무용') as car_use,\n"+
						"        a.ins_start_dt, a.ins_exp_dt, a.ins_rent_dt, \n"+
						"        decode(a.age_scp,'1','21세이상','2','26세이상','4','24세이상','3','모든운전자','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하') as age_scp,\n"+
						"        (decode(a.air_ds_yn,'Y',1,0)+decode(a.air_as_yn,'Y',1,0)) as air,\n"+
						"        decode(e.migr_dt,'','Y','N') as use_yn, e.migr_dt, g.exp_dt, a.ins_con_no \n"+
						" from   insur a, ins_com b, car_reg c, cont d, sui e, ins_cls g \n"+
	//							"        (select car_mng_id, car_no from car_change group by car_mng_id, car_no) f, ins_cls g \n"+
						" where   a.ins_com_id=b.ins_com_id and a.car_mng_id=c.car_mng_id "+
	//							"	     and a.car_mng_id=f.car_mng_id"+
						"        and a.car_mng_id=d.car_mng_id and d.reg_dt||d.rent_l_cd=(select max(reg_dt||rent_l_cd) from cont where rent_l_cd not like 'RM%' and car_mng_id=a.car_mng_id)"+
						"        and a.car_mng_id=e.car_mng_id(+)"+
						"        and a.car_mng_id=g.car_mng_id(+) and a.ins_st=g.ins_st(+)"+
						" ";
	
				if(!t_wd.equals("")){
					if(s_kd.equals("1"))								query += " and (c.car_no like '%"+t_wd+"%' or c.first_car_no like '%"+t_wd+"%')\n";	
	//						if(s_kd.equals("1"))								query += " and c.car_no||' '||f.car_no like '%"+t_wd+"%' \n";
					else if(s_kd.equals("2"))							query += " and upper(c.car_num) like upper('%"+t_wd+"%')\n";
					else if(s_kd.equals("3"))							query += " and c.car_nm like '%"+t_wd+"%'\n";
					else if(s_kd.equals("4"))							query += " and b.ins_com_nm like '%"+t_wd+"%'\n";
					else if(s_kd.equals("5"))							query += " and replace(a.ins_con_no,'-','') like '%"+t_wd+"%'\n";
	
					query += " order by a.car_mng_id, a.ins_start_dt, a.ins_st \n";
				}   
	
					
	
			}else{
				query = " select\n"+
						"        decode(a.ins_kd,'2','책임보험', '종합보험') as ins_kd,\n"+
						"        decode(a.ins_sts,'1','유효', '2','만료', '3','중도해지','5','승계') as ins_sts,\n"+
						"        a.car_mng_id, a.ins_st, c.car_no, c.car_nm, b.ins_com_nm, d.rent_mng_id, d.rent_l_cd,\n"+
						"        decode(a.car_use,'1','영업용', '업무용') as car_use,\n"+
						"        a.ins_start_dt, a.ins_exp_dt, a.ins_rent_dt, \n"+
						"        decode(a.age_scp,'1','21세이상','2','26세이상','4','24세이상','3','모든운전자','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하') as age_scp,\n"+
						"        (decode(a.air_ds_yn,'Y',1,0)+decode(a.air_as_yn,'Y',1,0)) as air,\n"+
						"        decode(e.migr_dt,'','Y','N') as use_yn, e.migr_dt, f.exp_dt, a.ins_con_no\n"+
						" from insur a, ins_com b, car_reg c, cont d, sui e, ins_cls f \n"+
						" where a.ins_com_id=b.ins_com_id and a.car_mng_id=c.car_mng_id"+
						"        and a.car_mng_id=d.car_mng_id and d.reg_dt||d.rent_l_cd=(select max(reg_dt||rent_l_cd) from cont where rent_l_cd not like 'RM%' and car_mng_id=a.car_mng_id)"+
						"        and a.car_mng_id=e.car_mng_id(+)"+
						"        and a.car_mng_id=f.car_mng_id(+) and a.ins_st=f.ins_st(+)"+
						" ";
	
				if(!brch_id.equals("S1") && !brch_id.equals(""))		query += " and d.brch_id = '"+brch_id+"'"; 
				if(brch_id.equals("S1"))								query += " and d.brch_id in ('S1','K1')"; 
	
				if(gubun1.equals("1") && !gubun3.equals("5"))									query += " and a.car_use='1'"; 
				if(gubun1.equals("2") && !gubun3.equals("5"))									query += " and a.car_use<>'1'"; 
	
				s_dt = "a.ins_start_dt";
	
				if(gubun2.equals("1"))									query += " and "+s_dt+" = to_char(sysdate,'YYYYMMDD')";
				else if(gubun2.equals("2"))								query += " and "+s_dt+" like to_char(sysdate,'YYYYMM')||'%'";
				else if(gubun2.equals("3"))								query += " and "+s_dt+" like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
				else if(gubun2.equals("4"))								query += " and "+s_dt+" like '"+AddUtil.getDate(1)+"%'";
				else if(gubun2.equals("5"))								query += " and "+s_dt+" between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";
	
				if(!gubun5.equals(""))									query += " and nvl(a.ins_kd,'1') ='"+gubun5+"'";
				if(!gubun6.equals(""))									query += " and nvl(a.ins_sts,'1') ='"+gubun6+"'";
	
	
				if(!t_wd.equals("")){
					if(s_kd.equals("1"))								query += " and (c.car_no like '%"+t_wd+"%' or c.first_car_no like '%"+t_wd+"%')\n";
					else if(s_kd.equals("2"))							query += " and upper(c.car_num) like upper('%"+t_wd+"%')\n";
					else if(s_kd.equals("3"))							query += " and c.car_nm like '%"+t_wd+"%'\n";
					else if(s_kd.equals("4"))							query += " and b.ins_com_nm like '%"+t_wd+"%'\n";
					else if(s_kd.equals("5"))							query += " and replace(a.ins_con_no,'-','') like '%"+t_wd+"%'\n";
				}   
	
	
			}
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
	
	
	//				System.out.println("[InsDatabase:getInsMngList]"+ gubun3);
	//				System.out.println("[InsDatabase:getInsMngList]"+ query);
	
		} catch (SQLException e) {			
			System.out.println("[InsDatabase:getInsMngList]"+ e);
			System.out.println("[InsDatabase:getInsMngList]"+ query);
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

	//보험료관리 리스트 조회
	public Vector getInsAmtList(String br_id, String gubun0, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String gubun7, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String s_dt = "h.r_ins_est_dt";
		String t_dt = "to_char(sysdate,'YYYYMMDD')";


			query = " select"+
					" decode(h.pay_yn, '1','지출', '미지출' ) pay_yn,"+
					" decode(a.ins_kd,'2','책임보험', '종합보험') as ins_kd,"+
					" decode(a.ins_sts,'1','유효', '2','만료', '3','중도해지','5','승계') as ins_sts,"+
					" a.car_mng_id, a.ins_st, d.rent_mng_id, d.rent_l_cd, c.car_no, c.car_nm, b.ins_com_nm,"+
					" decode(h.ins_tm2,'2','해지', decode(h.ins_st,'0','신규','갱신')) tm1,"+
					" decode(nvl(h.ins_tm2,'0'), '0', decode(h.ins_tm,'1','당초납입보험료','분납보험료'), '1','추가보험료', '2','환급보험료') tm2,"+
					" h.ins_tm, h.r_ins_est_dt, decode(h.ins_tm2,'2',-h.pay_amt,h.pay_amt) pay_amt, h.pay_dt,"+
					" decode(e.migr_dt,'','Y','N') as use_yn, e.migr_dt, a.ins_con_no "+
					" from insur a, ins_com b, car_reg c, cont d, sui e, ins_cls f, scd_ins h"+
					" where a.ins_com_id=b.ins_com_id and a.car_mng_id=c.car_mng_id"+
					" and a.car_mng_id=d.car_mng_id and d.rent_l_cd=(select max(rent_l_cd) from cont where rent_l_cd not like 'RM%' and car_mng_id=a.car_mng_id)"+
					" and a.car_mng_id=e.car_mng_id(+)"+
					" and a.car_mng_id=f.car_mng_id(+) and a.ins_st=f.ins_st(+)"+				
					" and a.car_mng_id=h.car_mng_id and a.ins_st=h.ins_st";

				if(!br_id.equals("S1") && !br_id.equals(""))			query += " and d.brch_id = '"+br_id+"'"; 
				if(!brch_id.equals("S1") && !brch_id.equals(""))		query += " and d.brch_id = '"+brch_id+"'"; 
				if(brch_id.equals("S1"))								query += " and d.brch_id in ('S1','K1')"; 

				if(gubun1.equals("1"))									query += " and a.car_use='1'"; 
				if(gubun1.equals("2"))									query += " and a.car_use<>'1'"; 
	
				if(gubun2.equals("1"))									query += " and "+s_dt+" = "+t_dt+"";
				else if(gubun2.equals("2"))								query += " and "+s_dt+" like to_char(sysdate,'YYYYMM')||'%'";
				else if(gubun2.equals("3"))								query += " and "+s_dt+" like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
				else if(gubun2.equals("4"))								query += " and "+s_dt+" like '"+AddUtil.getDate(1)+"%'";
				else if(gubun2.equals("5") && !st_dt.equals("") && !end_dt.equals(""))	query += " and "+s_dt+" between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

				if(gubun3.equals("0"))									query += " and h.pay_yn='0'"; 
				if(gubun3.equals("1"))									query += " and h.pay_yn='1'"; 
				if(gubun3.equals("2"))									query += " and "+s_dt+"<"+t_dt+" and (h.pay_yn='0' or h.pay_dt="+t_dt+")"; 

				if(gubun4.equals("0"))									query += " and h.ins_tm2 not in ('1','2') "; 
				if(gubun4.equals("1"))									query += " and h.ins_tm2='1'"; 
				if(gubun4.equals("2"))									query += " and h.ins_tm2='2'"; 

				if(gubun4.equals("0") && gubun5.equals("1"))			query += " and nvl(a.reg_cau,'1') = '1'";
				else if(gubun4.equals("0") && gubun5.equals("2"))		query += " and nvl(a.reg_cau,'1') = '2'";
				else if(gubun4.equals("0") && gubun5.equals("3"))		query += " and nvl(a.reg_cau,'1') in ('3','4')";

				if(!t_wd.equals("")){
					if(s_kd.equals("1"))								query += " and (c.car_no like '%"+t_wd+"%' or c.first_car_no like '%"+t_wd+"%')\n";
					else if(s_kd.equals("2"))							query += " and upper(c.car_num) like upper('%"+t_wd+"%')\n";
					else if(s_kd.equals("3"))							query += " and c.car_nm like '%"+t_wd+"%'\n";
					else if(s_kd.equals("4"))							query += " and b.ins_com_id ='"+t_wd+"'\n";
				}

				if(sort.equals("1"))									query += " order by a.ins_sts, e.migr_dt desc, h.r_ins_est_dt "+asc;
				else if(sort.equals("2"))								query += " order by a.ins_sts, e.migr_dt desc, h.pay_dt "+asc;
				else if(sort.equals("3"))								query += " order by a.ins_sts, e.migr_dt desc, c.car_no "+asc;



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
			
			System.out.println("[InsDatabase:getInsAmtList]"+ e);
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
	public Vector getInsClsMngList(String br_id, String gubun0, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String gubun7, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
			query = " select * from "+
					" ( "+
					//용도변경
					"	select "+
					"	       f.car_mng_id, f.ins_st, a.car_no, a.car_nm, '1' as gubun1, '용도변경' as cau,"+
					"	       c.car_no as be_car_no, c.cha_seq as be_seq, b.car_no as af_car_no, b.cha_seq as af_seq, "+
					"	       REPLACE(b.cha_dt,'-','') as ch_dt, '' migr_dt, '' udt_dt, REPLACE(h.ins_con_no,'-','') ins_con_no, "+
					"	       b.cha_cau_sub as ch_sub,"+
					"	       d.exp_st, d.exp_aim, d.exp_dt, d.req_dt, d.rtn_est_amt, d.rtn_amt, d.rtn_dt, e.pay_dt, e.pay_amt,"+
					"	       '' as stat, decode(f.ins_st,'','미가입','가입') ins_stat, i.ins_com_nm  "+
					"	from   car_reg a, car_change b, car_change c, (select * from ins_cls where exp_st in ('1','2') and exp_aim in ('1','2','4','9')) d, "+ //20170124 말소조건추가
					"		   (select car_mng_id, ins_st, pay_dt, pay_amt from scd_ins where ins_tm2='2') e, "+
					"	       (select car_mng_id, to_char(max(TO_NUMBER(ins_st))) ins_st from insur group by car_mng_id) f, INSUR h, INS_COM i "+
					"	where "+
					"	       a.car_mng_id=b.car_mng_id and b.cha_cau='2' "+
					"	       and b.car_mng_id=c.car_mng_id and c.cha_seq=b.cha_seq-1 "+
					"	       and b.car_mng_id=d.car_mng_id(+) "+
					"	       and b.cha_dt=d.exp_dt(+) "+
					"	       and d.car_mng_id=e.car_mng_id(+) and d.ins_st=e.ins_st(+) "+
					"	       and a.car_mng_id=f.car_mng_id"+
                    "          AND f.car_mng_id=h.car_mng_id AND f.ins_st=h.ins_st AND h.ins_com_id=i.ins_com_id "+  
					"          and h.ins_start_dt > '20141231' "+		
					"	union all"+
					//매각
				/*	"	select "+
					"	       g.car_mng_id, g.ins_st, c.car_no, c.car_nm, decode(b.cls_st,'6','2','8','3','9','4') gubun1, decode(b.cls_st,'6','매각','8','매입옵션','9','폐차') cau, "+
					"	       ''  as be_car_no, '' as be_seq, '' as af_car_no, '' as af_seq, "+
					"	       NVL(d.migr_dt,nvl(d.cont_dt,b.cls_dt)) ch_dt, d.migr_dt, d.udt_dt, h.ins_con_no, "+
					"	       decode(d.migr_dt, '', decode(d.cont_dt,'', '해지일', '계약일'), '명의이전일') ch_sub,"+
					"	       e.exp_st, e.exp_aim, e.exp_dt, e.req_dt, e.rtn_est_amt, e.rtn_amt, e.rtn_dt, f.pay_dt, f.pay_amt,"+
					"	       decode(d.car_mng_id,'','미등록','등록') stat, decode(g.ins_st,'','미가입','가입') ins_stat, i.ins_com_nm "+
					"	from   cont a, cls_cont b, car_reg c, sui d,  "+
					"	       (select car_mng_id, ins_st, pay_dt, pay_amt from scd_ins where ins_tm2='2') f, "+
					"	       (select car_mng_id, max(ins_st) ins_st from insur group by car_mng_id) g, INSUR h, INS_COM i, "+
                    "          ins_cls e "+  
					"	where "+
					"	       a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.cls_st in ('6','8','9') "+
					"	       and a.car_mng_id=c.car_mng_id "+
					"	       and a.car_mng_id=d.car_mng_id(+) "+
					"	       and e.car_mng_id=f.car_mng_id(+) and e.ins_st=f.ins_st(+) "+
					"	       and a.car_mng_id=g.car_mng_id"+
                    "          AND g.car_mng_id=h.car_mng_id AND g.ins_st=h.ins_st AND h.ins_com_id=i.ins_com_id and h.ins_com_id<>'0031' "+  
                    "          AND (NVL(d.migr_dt,nvl(d.cont_dt,b.cls_dt)) > h.ins_start_dt or h.INS_STS = '1') "+ 
                    "		   AND NVL(d.migr_dt,nvl(d.cont_dt,b.cls_dt)) < h.ins_exp_dt "+
					"          and h.ins_start_dt > '20091231' "+		
					"	       and h.car_mng_id=e.car_mng_id(+) and h.ins_st=e.ins_st(+) "+*/
					
					// 20171011 보험 마지막 건 뿐 아니라 다른 건에서도 보험기간에 해지일이 포함되면 해지리스트에 나오게 끔 수정(고영은씨 요청/ jhChoi)
					"	select "+
					"	       h.car_mng_id, h.ins_st, c.car_no, c.car_nm, decode(b.cls_st,'6','2','8','3','9','4') gubun1, decode(b.cls_st,'6','매각','8','매입옵션','9','폐차') cau, "+
					"	       ''  as be_car_no, '' as be_seq, '' as af_car_no, '' as af_seq, "+
					"	       (CASE WHEN B.CLS_ST = '8' AND I.INS_COM_ID = '0007' THEN REPLACE(NVL(J.CLS_DT, NVL(d.cont_dt, nvl(d.migr_dt, b.cls_dt))), '-', '') ELSE REPLACE(NVL(d.migr_dt, nvl(d.cont_dt, b.cls_dt)), '-', '') END) AS CH_DT, d.migr_dt, d.udt_dt, REPLACE(h.ins_con_no,'-','') ins_con_no, "+
					"	       decode(d.migr_dt, '', decode(d.cont_dt,'', '해지일', '계약일'), '명의이전일') ch_sub,"+
					"	       e.exp_st, e.exp_aim, e.exp_dt, e.req_dt, e.rtn_est_amt, e.rtn_amt, e.rtn_dt, f.pay_dt, f.pay_amt,"+
					"	       decode(d.car_mng_id,'','미등록','등록') stat, decode(h.ins_st,'','미가입','가입') ins_stat, i.ins_com_nm "+
					"	from   cont a, cls_cont b, car_reg c, sui d,  "+
					"	       (select car_mng_id, ins_st, pay_dt, pay_amt from scd_ins where ins_tm2='2') f, "+
					//"	       (select car_mng_id, max(ins_st) ins_st from insur group by car_mng_id) g,  "+
                    "          INSUR h, INS_COM i, ins_cls e, cls_etc j  "+  
					"	where "+
					"	       a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.cls_st in ('6','8','9') "+
					"	       and a.car_mng_id=c.car_mng_id "+
					"	       and a.car_mng_id=d.car_mng_id(+) "+
					"	       and e.car_mng_id=f.car_mng_id(+) and e.ins_st=f.ins_st(+) "+
					"	       and a.car_mng_id=h.car_mng_id"+
                    //"          AND g.car_mng_id=h.car_mng_id AND g.ins_st=h.ins_st"+  
                    "          AND h.ins_com_id=i.ins_com_id and h.ins_com_id<>'0031'"+  
                    "          AND (NVL(d.migr_dt,nvl(d.cont_dt,b.cls_dt)) > h.ins_start_dt or h.INS_STS = '1') "+ 
                    "		   AND NVL(d.migr_dt,nvl(d.cont_dt,b.cls_dt)) < h.ins_exp_dt "+
					"          and h.ins_start_dt > '20141231' "+		
					"	       and h.car_mng_id=e.car_mng_id(+) and h.ins_st=e.ins_st(+) and a.RENT_L_CD = j.rent_l_cd(+) "+
					" )"+
					" where car_mng_id is not null";

			if(!gubun1.equals(""))									query += " and gubun1='"+gubun1+"'";

			if(gubun2.equals("1"))									query += " and req_dt is not null";
			if(gubun2.equals("2"))									query += " and req_dt is null";

			if(gubun3.equals("1"))									query += " and pay_dt is not null";
			if(gubun3.equals("2"))									query += " and pay_dt is null";
			
			if(gubun4.equals("1")){
				query += " order by ch_dt desc";
			}
			if(gubun4.equals("2")){
				query += " order by ins_com_nm,ch_dt desc";
			}
			if(gubun4.equals("3")){
				query += " ORDER BY ins_com_nm , udt_dt,  migr_dt DESC nulls last";
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
			
			System.out.println("[InsDatabase:getInsClsMngList]"+ e);
			System.out.println("[InsDatabase:getInsClsMngList]"+ query);
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
//보험관리 리스트 조회엑셀
	public Vector getInsClsMngList2(String br_id, String gubun0, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String gubun7, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
			query = " select * from "+
					" ( "+
					//용도변경
					"	select "+
					"	       f.car_mng_id, f.ins_st, a.car_no, a.car_nm, '1' as gubun1, '용도변경' as cau,"+
					"	       c.car_no as be_car_no, c.cha_seq as be_seq, b.car_no as af_car_no, b.cha_seq as af_seq, "+
					"	       b.cha_dt as ch_dt, '' migr_dt, '' udt_dt, h.ins_con_no, "+
					"	       b.cha_cau_sub as ch_sub,"+
					"	       d.exp_st, d.exp_aim, d.exp_dt, d.req_dt, d.rtn_est_amt, d.rtn_amt, d.rtn_dt, e.pay_dt, e.pay_amt,"+
					"	       '' as stat, decode(f.ins_st,'','미가입','가입') ins_stat, i.ins_com_nm "+
					"	from   car_reg a, car_change b, car_change c, (select * from ins_cls where exp_st in ('1','2') and exp_aim in ('1','2','9')) d, "+
					"		   (select car_mng_id, ins_st, pay_dt, pay_amt from scd_ins where ins_tm2='2') e, "+
					"	       (select car_mng_id, max(TO_NUMBER(ins_st)) ins_st from insur group by car_mng_id) f, INSUR h, INS_COM i "+
					"	where "+
					"	       a.car_mng_id=b.car_mng_id and b.cha_cau='2' "+
					"	       and b.car_mng_id=c.car_mng_id and c.cha_seq=b.cha_seq-1 "+
					"	       and b.car_mng_id=d.car_mng_id(+) "+
					"	       and b.cha_dt=d.exp_dt(+) "+
					"	       and d.car_mng_id=e.car_mng_id(+) and d.ins_st=e.ins_st(+) "+
					"	       and a.car_mng_id=f.car_mng_id"+
                    "          AND f.car_mng_id=h.car_mng_id AND f.ins_st=h.ins_st AND h.ins_com_id=i.ins_com_id "+  
					"          and h.ins_start_dt > '20091231' "+		
					"	union all"+
					//매각
					"	select "+
					"	       g.car_mng_id, g.ins_st, c.car_no, c.car_nm, decode(b.cls_st,'6','2','8','3','9','4') gubun1, decode(b.cls_st,'6','매각','8','매입옵션','9','폐차') cau, "+
					"	       ''  as be_car_no, '' as be_seq, '' as af_car_no, '' as af_seq, "+
					"	       NVL(d.migr_dt,nvl(d.cont_dt,b.cls_dt)) ch_dt, d.migr_dt, d.udt_dt,  h.ins_con_no, "+
					"	       decode(d.migr_dt, '', decode(d.cont_dt,'', '해지일', '계약일'), '명의이전일') ch_sub,"+
					"	       e.exp_st, e.exp_aim, e.exp_dt, e.req_dt, e.rtn_est_amt, e.rtn_amt, e.rtn_dt, f.pay_dt, f.pay_amt,"+
					"	       decode(d.car_mng_id,'','미등록','등록') stat, decode(g.ins_st,'','미가입','가입') ins_stat, i.ins_com_nm "+
					"	from   cont a, cls_cont b, car_reg c, sui d,  "+
					"	       (select car_mng_id, ins_st, pay_dt, pay_amt from scd_ins where ins_tm2='2') f, "+
					"	       (select car_mng_id, max(TO_NUMBER(ins_st)) ins_st from insur group by car_mng_id) g, INSUR h, INS_COM i, "+
                    "          ins_cls e "+  
					"	where "+
					"	       a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.cls_st in ('6','8','9') "+
					"	       and a.car_mng_id=c.car_mng_id "+
					"	       and a.car_mng_id=d.car_mng_id(+) "+
					"	       and e.car_mng_id=f.car_mng_id(+) and e.ins_st=f.ins_st(+) "+
					"	       and a.car_mng_id=g.car_mng_id"+
                    "          AND g.car_mng_id=h.car_mng_id AND g.ins_st=h.ins_st AND h.ins_com_id=i.ins_com_id and h.ins_com_id<>'0031' "+  
                    "          AND NVL(d.migr_dt,nvl(d.cont_dt,b.cls_dt)) > h.ins_start_dt AND NVL(d.migr_dt,nvl(d.cont_dt,b.cls_dt)) < h.ins_exp_dt "+
					"          and h.ins_start_dt > '20091231' "+		
					"	       and h.car_mng_id=e.car_mng_id(+) and h.ins_st=e.ins_st(+) "+
					" )"+
					" where car_mng_id is not null";

			if(!gubun1.equals(""))									query += " and gubun1='"+gubun1+"'";

			if(gubun2.equals("1"))									query += " and req_dt is not null";
			if(gubun2.equals("2"))									query += " and req_dt is null";

			if(gubun3.equals("1"))									query += " and pay_dt is not null";
			if(gubun3.equals("2"))									query += " and pay_dt is null";
			query += " and migr_dt is not null and to_number(migr_dt)>=20150101 order by ins_com_nm,udt_dt,migr_dt desc nulls last ";
		
			


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
			
			System.out.println("[InsDatabase:getInsClsMngList]"+ e);
			System.out.println("[InsDatabase:getInsClsMngList]"+ query);
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
	//해지보험관리 리스트 조회 - 해지보험공문 작성시 조회
	public Vector getInsClsMngList(String t_wd, String gubun1, String gubun2, String st_dt, String end_dt, String car_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", sub_query = "";
		String dt = "";
					
			query = " select * from"+ 
					" ( select a.car_mng_id, d.ins_st, h.ins_com_id, h.ins_con_no, a.car_no, a.car_nm, '1' as gubun1, '용도변경' as cau, "+ 
					"  c.car_no as be_car_no, c.cha_seq as be_seq, b.car_no as af_car_no, b.cha_seq as af_seq, b.cha_dt as ch_dt, '' migr_dt, b.cha_cau_sub as ch_sub, "+ 
					"  d.exp_st, d.exp_aim, d.exp_dt, d.req_dt, d.rtn_est_amt, d.rtn_amt, d.rtn_dt, e.pay_dt, e.pay_amt, '' as stat, decode(f.ins_st,'','미가입','가입') ins_stat, i.doc_id, j.doc_dt "+ 
					"  from car_reg a, car_change b, car_change c, ins_cls d,"+
					"		(select car_mng_id, ins_st, pay_dt, pay_amt from scd_ins where ins_tm2='2') e,"+
					"		(select car_mng_id, max(TO_NUMBER(ins_st)) ins_st from insur group by car_mng_id) f, insur h, ins_doc_list i, fine_doc j "+ 
					"  where a.car_mng_id=b.car_mng_id and b.cha_cau='2' and b.car_mng_id=c.car_mng_id(+) and c.cha_seq=b.cha_seq-1 and b.car_mng_id=d.car_mng_id(+) and b.cha_dt=d.exp_dt(+) and d.car_mng_id=e.car_mng_id(+) and d.ins_st=e.ins_st(+) and a.car_mng_id=f.car_mng_id(+) "+ 
					"  and f.car_mng_id=h.car_mng_id and f.ins_st=h.ins_st"+ 
					"  and h.car_mng_id=i.car_mng_id(+) and h.ins_st=i.ins_st(+) and i.doc_id=j.doc_id(+)"+ 
					"  union all "+ 
					"  select a.car_mng_id, e.ins_st, h.ins_com_id, h.ins_con_no, c.car_no, c.car_nm, decode(b.cls_st,'6','2','8','3') gubun1, decode(b.cls_st,'6','매각','8','매입옵션','9','폐차') cau,"+ 
					"  '' as be_car_no, '' as be_seq, '' as af_car_no, '' as af_seq, nvl(d.migr_dt,nvl(d.cont_dt,b.cls_dt)) ch_dt, d.migr_dt, decode(d.migr_dt, '', decode(d.cont_dt,'', '해지일', '계약일'), '명의이전일') ch_sub, "+ 
					"  e.exp_st, e.exp_aim, e.exp_dt, e.req_dt, e.rtn_est_amt, e.rtn_amt, e.rtn_dt, f.pay_dt, f.pay_amt, decode(d.car_mng_id,'','미등록','등록') stat, decode(g.ins_st,'','미가입','가입') ins_stat, i.doc_id, j.doc_dt  "+ 
					"  from cont a, cls_cont b, car_reg c, sui d, ins_cls e,"+
					"		(select car_mng_id, ins_st, pay_dt, pay_amt from scd_ins where ins_tm2='2') f,"+
					"		(select car_mng_id, max(TO_NUMBER(ins_st)) ins_st from insur group by car_mng_id) g, insur h, ins_doc_list i, fine_doc j "+ 
					"  where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.cls_st in ('6','8','9') and a.car_mng_id=c.car_mng_id and a.car_mng_id=e.car_mng_id(+) and e.car_mng_id=d.car_mng_id(+) and e.exp_dt=d.migr_dt(+) and e.car_mng_id=f.car_mng_id(+) and e.ins_st=f.ins_st(+) and a.car_mng_id=g.car_mng_id(+) "+ 
					"  and g.car_mng_id=h.car_mng_id(+) and g.ins_st=h.ins_st(+) "+ 
					"  and h.car_mng_id=i.car_mng_id(+) and h.ins_st=i.ins_st(+) and i.doc_id=j.doc_id(+)  "+ 
					" ) "+ 
					"where req_dt is not null";


			if(!t_wd.equals(""))									query += " and ins_com_id='"+t_wd+"'";

			if(!car_no.equals(""))									query += " and car_no like '%"+car_no+"%'";

			if(gubun1.equals("1"))									query += " and doc_dt is not null";
			if(gubun1.equals("2"))									query += " and req_dt > '20050831' and doc_dt is null";

			if(gubun2.equals("1"))		dt = "req_dt";
			if(gubun2.equals("2"))		dt = "exp_dt";

			if(!st_dt.equals("") && !end_dt.equals(""))				query += " and "+dt+" between '"+st_dt+"' and '"+end_dt+"'";
			if(!st_dt.equals("") && end_dt.equals(""))				query += " and "+dt+" like '%"+st_dt+"%'";


			query += " order by car_no, req_dt";


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
			
			System.out.println("[InsDatabase:getInsClsMngList(String t_wd, String gubun1, String gubun2, String st_dt, String end_dt)]"+ e);
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

	//해지보험관리 리스트 조회 - 해지보험공문 작성시 조회
	public Vector getInsClsMngList_200704(String t_wd, String gubun1, String gubun2, String st_dt, String end_dt, String car_no, String sort)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", sub_query = "";
		String dt = "";
					
			query = " select"+
					" a.car_mng_id, a.ins_st, h.ins_com_id, h.ins_con_no,"+
					" decode(d.migr_dt,'',decode(c.cha_dt,'',decode(f.car_mng_id,'',decode(g.cls_st,'6','매각','8','매입옵션'),'기타'),'용도변경'),decode(g.cls_st,'6','매각','8','매입옵션')) cau,"+
					" c.be_car_no, nvl(c.af_car_no,e.car_no) car_no, e.car_nm, a.exp_dt, a.req_dt"+
					" from ins_cls a, ins_doc_list b, sui d, car_reg e, insur h,"+
					" (select a.car_mng_id, a.cha_dt, a.car_no as af_car_no, b.car_no as be_car_no from car_change a, car_change b where a.cha_cau='2' and a.car_mng_id=b.car_mng_id and b.cha_seq=a.cha_seq-1) c,"+
					" (select car_mng_id from cont where nvl(use_yn,'Y')='Y' and rent_l_cd not like 'RM%' group by car_mng_id) f,"+
					" (select a.car_mng_id, b.cls_st from cont a, cls_cont b where a.rent_l_cd=b.rent_l_cd and b.cls_st in ('6','8') group by a.car_mng_id, b.cls_st) g"+
					" where a.req_dt >'20050831' and nvl(a.cls_st,'1')='1' and"+
					" a.car_mng_id=b.car_mng_id(+) and a.ins_st=b.ins_st(+)"+// and b.car_mng_id is null
					" and a.car_mng_id=c.car_mng_id(+) and a.exp_dt=c.cha_dt(+)"+
					" and a.car_mng_id=d.car_mng_id(+) and a.exp_dt=d.migr_dt(+)"+
					" and a.car_mng_id=e.car_mng_id"+
					" and a.car_mng_id=f.car_mng_id(+)"+
					" and a.car_mng_id=g.car_mng_id(+)"+
					" and a.car_mng_id=h.car_mng_id and a.ins_st=h.ins_st";


			if(!t_wd.equals(""))									query += " and h.ins_com_id='"+t_wd+"'";

			if(!car_no.equals(""))									query += " and nvl(c.af_car_no,e.car_no) like '%"+car_no+"%'";

			if(gubun1.equals("1"))									query += " and b.doc_id is not null";
			if(gubun1.equals("2"))									query += " and a.req_dt > '20050831' and b.doc_id is null";

			if(gubun2.equals("1"))		dt = "a.req_dt";
			if(gubun2.equals("2"))		dt = "a.exp_dt";

			if(!st_dt.equals("") && !end_dt.equals(""))				query += " and "+dt+" between '"+st_dt+"' and '"+end_dt+"'";
			if(!st_dt.equals("") && end_dt.equals(""))				query += " and "+dt+" like '%"+st_dt+"%'";

			if(sort.equals("1"))									query += " order by nvl(c.af_car_no,e.car_no), a.exp_dt";
			if(sort.equals("2"))									query += " order by a.req_dt, nvl(c.af_car_no,e.car_no), a.exp_dt";

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
			
			System.out.println("[InsDatabase:getInsClsMngList_200704(String t_wd, String gubun1, String gubun2, String st_dt, String end_dt)]"+ e);
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

	//해지보험관리 리스트 조회 - 해지보험공문 작성시 조회
	public Hashtable getInsClsMngListCast(String car_mng_id, String ins_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "", sub_query = "";
		String dt = "";
					
			query = " select * from"+ 
					" ( select a.car_mng_id, d.ins_st, h.ins_com_id, h.ins_con_no, a.car_no, a.car_nm, '1' as gubun1, '용도변경' as cau, "+ 
					"  c.car_no as be_car_no, c.cha_seq as be_seq, b.car_no as af_car_no, b.cha_seq as af_seq, b.cha_dt as ch_dt, '' migr_dt, b.cha_cau_sub as ch_sub, "+ 
					"  d.exp_st, d.exp_aim, d.exp_dt, d.req_dt, d.rtn_est_amt, d.rtn_amt, d.rtn_dt, e.pay_dt, e.pay_amt, '' as stat, decode(f.ins_st,'','미가입','가입') ins_stat, i.doc_id, j.doc_dt "+ 
					"  from car_reg a, car_change b, car_change c, ins_cls d,"+
					"		(select car_mng_id, ins_st, pay_dt, pay_amt from scd_ins where ins_tm2='2') e,"+
					"		(select car_mng_id, max(TO_NUMBER(ins_st)) ins_st from insur group by car_mng_id) f, insur h, ins_doc_list i, fine_doc j "+ 
					"  where a.car_mng_id=b.car_mng_id and b.cha_cau='2' and b.car_mng_id=c.car_mng_id(+) and c.cha_seq=b.cha_seq-1 and b.car_mng_id=d.car_mng_id(+) and b.cha_dt=d.exp_dt(+) and d.car_mng_id=e.car_mng_id(+) and d.ins_st=e.ins_st(+) and a.car_mng_id=f.car_mng_id(+) "+ 
					"  and d.car_mng_id=h.car_mng_id and d.ins_st=h.ins_st"+ 
					"  and h.car_mng_id=i.car_mng_id(+) and h.ins_st=i.ins_st(+) and i.doc_id=j.doc_id(+)"+ 
					"  union all "+ 
					"  select a.car_mng_id, e.ins_st, h.ins_com_id, h.ins_con_no, c.car_no, c.car_nm, decode(b.cls_st,'6','2','8','3','9','4') gubun1, decode(b.cls_st,'9','폐차','매각') cau,"+ //decode(b.cls_st,'6','매각','8','매입옵션')
					"  '' as be_car_no, '' as be_seq, '' as af_car_no, '' as af_seq, nvl(d.migr_dt,nvl(d.cont_dt,b.cls_dt)) ch_dt, d.migr_dt, decode(d.migr_dt, '', decode(d.cont_dt,'', '해지일', '계약일'), '명의이전일') ch_sub, "+ 
					"  e.exp_st, e.exp_aim, e.exp_dt, e.req_dt, e.rtn_est_amt, e.rtn_amt, e.rtn_dt, f.pay_dt, f.pay_amt, decode(d.car_mng_id,'','미등록','등록') stat, decode(g.ins_st,'','미가입','가입') ins_stat, i.doc_id, j.doc_dt  "+ 
					"  from cont a, cls_cont b, car_reg c, sui d, ins_cls e,"+
					"		(select car_mng_id, ins_st, pay_dt, pay_amt from scd_ins where ins_tm2='2') f,"+
					"		(select car_mng_id, max(TO_NUMBER(ins_st)) ins_st from insur group by car_mng_id) g, insur h, ins_doc_list i, fine_doc j "+ 
					"  where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.cls_st in ('6','8','9') and a.car_mng_id=c.car_mng_id and a.car_mng_id=e.car_mng_id(+) and e.car_mng_id=d.car_mng_id(+) and e.exp_dt=d.migr_dt(+) and e.car_mng_id=f.car_mng_id(+) and e.ins_st=f.ins_st(+) and a.car_mng_id=g.car_mng_id(+) "+ 
					"  and e.car_mng_id=e.car_mng_id and e.ins_st=e.ins_st "+ 
					"  and h.car_mng_id=i.car_mng_id(+) and h.ins_st=i.ins_st(+) and i.doc_id=j.doc_id(+)  "+ 
					" ) "+ 
					"where req_dt is not null and car_mng_id='"+car_mng_id+"' and ins_st='"+ins_st+"'";


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
			
			System.out.println("[InsDatabase:getInsClsMngListCast(String car_mng_id, String ins_st)]"+ e);
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

	//해지보험관리 리스트 조회 - 해지보험공문 작성시 조회
	public Hashtable getInsClsMngListCase_200704(String car_mng_id, String ins_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "", sub_query = "";
		String dt = "";
					
			query = " select"+
					" a.car_mng_id, a.ins_st, h.ins_com_id, h.ins_con_no,"+
					" decode(d.migr_dt,'',decode(c.cha_dt,'',decode(f.car_mng_id,'',decode(g.cls_st,'6','매각','8','매입옵션'),'기타'),'용도변경'),decode(g.cls_st,'6','매각','8','매입옵션')) cau,"+
					" c.be_car_no, nvl(c.af_car_no,e.car_no) car_no, e.car_nm, a.exp_dt, a.req_dt"+
					" from ins_cls a, ins_doc_list b, sui d, car_reg e, insur h,"+
					" (select a.car_mng_id, a.cha_dt, a.car_no as af_car_no, b.car_no as be_car_no from car_change a, car_change b where a.cha_cau='2' and a.car_mng_id=b.car_mng_id and b.cha_seq=a.cha_seq-1) c,"+
					" (select car_mng_id from cont where nvl(use_yn,'Y')='Y' and rent_l_cd not like 'RM%' group by car_mng_id) f,"+
					" (select a.car_mng_id, b.cls_st from cont a, cls_cont b where a.rent_l_cd=b.rent_l_cd and b.cls_st in ('6','8') group by a.car_mng_id, b.cls_st) g"+
					" where a.req_dt >'20050831' and a.car_mng_id='"+car_mng_id+"' and a.ins_st='"+ins_st+"'"+
					" and a.car_mng_id=b.car_mng_id(+) and a.ins_st=b.ins_st(+)"+
					" and a.car_mng_id=c.car_mng_id(+) and a.exp_dt=c.cha_dt(+)"+
					" and a.car_mng_id=d.car_mng_id(+) and a.exp_dt=d.migr_dt(+)"+
					" and a.car_mng_id=e.car_mng_id"+
					" and a.car_mng_id=f.car_mng_id(+)"+
					" and a.car_mng_id=g.car_mng_id(+)"+
					" and a.car_mng_id=h.car_mng_id and a.ins_st=h.ins_st";


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
			
			System.out.println("[InsDatabase:getInsClsMngListCase_200704(String car_mng_id, String ins_st)]"+ e);
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

	//해지보험관리 리스트 조회 - 해지보험공문 작성시 조회
	public Hashtable getInsClsDocCasc(String car_mng_id, String ins_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "", sub_query = "";
		String dt = "";
					
			query = " select a.*, b.doc_dt from ins_doc_list a, fine_doc b"+
					" where a.doc_id=b.doc_id"+ 
					" and a.car_mng_id='"+car_mng_id+"' and a.ins_st='"+ins_st+"'";

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
			
			System.out.println("[InsDatabase:getInsClsDocCasc(String car_mng_id, String ins_st)]"+ e);
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

	//해지현황
	public Hashtable getInsClsStat(int idx)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
        String query = "";

		if(idx == 1){//용도변경
			query = " select"+
					" count(decode(d.req_dt,'','', a.car_mng_id)) C1,"+
					" count(decode(d.req_dt,'',    a.car_mng_id)) C2,"+
					" count(decode(d.req_dt,'','',decode(e.pay_dt,'','', a.car_mng_id))) C3,"+
					" count(decode(d.req_dt,'','',decode(e.pay_dt,'',    a.car_mng_id))) C4,"+
					" sum(decode(e.pay_dt,'',0, e.pay_amt)) A1,"+
					" sum(decode(e.pay_dt,'',   nvl(e.pay_amt,d.rtn_est_amt))) A2"+
					" from car_reg a, car_change b, car_change c, ins_cls d, (select car_mng_id, ins_st, pay_dt, pay_amt from scd_ins where ins_tm2='2') e, (select car_mng_id, max(TO_NUMBER(ins_st)) ins_st from insur where ins_com_id='0007' group by car_mng_id) f"+
					" where "+
					" a.car_mng_id=b.car_mng_id and b.cha_cau='2' and b.car_mng_id=c.car_mng_id(+) and c.cha_seq=b.cha_seq-1 and b.car_mng_id=d.car_mng_id(+) and b.cha_dt=d.exp_dt(+) and d.car_mng_id=e.car_mng_id(+) and d.ins_st=e.ins_st(+) and a.car_mng_id=f.car_mng_id";
		}else if(idx == 2){//매각
			query = " select"+
					" count(decode(e.req_dt,'','', a.car_mng_id)) C1,"+
					" count(decode(e.req_dt,'',    a.car_mng_id)) C2,"+
					" count(decode(e.req_dt,'','', decode(f.pay_dt,'','', a.car_mng_id))) C3,"+
					" count(decode(e.req_dt,'','', decode(f.pay_dt,'',    a.car_mng_id))) C4,"+
					" sum(decode(f.pay_dt,'',0, f.pay_amt)) A1,"+
					" sum(decode(f.pay_dt,'',   nvl(f.pay_amt,e.rtn_est_amt))) A2"+
					" from cont a, cls_cont b, car_reg c, sui d, ins_cls e, (select car_mng_id, ins_st, pay_dt, pay_amt from scd_ins where ins_tm2='2') f, (select car_mng_id, max(TO_NUMBER(ins_st)) ins_st from insur where ins_com_id='0007' group by car_mng_id) g"+
					" where"+
					" a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.cls_st in ('6','8') and a.car_mng_id=c.car_mng_id and a.car_mng_id=d.car_mng_id(+) and d.car_mng_id=e.car_mng_id(+) and d.migr_dt=e.exp_dt(+) and e.car_mng_id=f.car_mng_id(+) and e.ins_st=f.ins_st(+) and a.car_mng_id=g.car_mng_id";
		}

		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
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
			pstmt.close();
		} catch (SQLException e) {
			
			System.out.println("[InsDatabase:getInsClsStat]"+ e);
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

	//해지보험공문---------------------------------------------------------------------------------------------------------


	//해지보험공문 한건 등록
	public boolean insertInsDocList(InsDocListBean bean, String doc_dt)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " INSERT INTO ins_doc_list VALUES"+
					" ( ?, ?, ?, ?, replace(?, '-', ''),    ?, ?, ?, ?, ?, to_char(sysdate,'YYYYMMDD'), '', '', ?)";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getDoc_id 		());
			pstmt.setString	(2,		bean.getCar_mng_id	());
			pstmt.setString	(3,		bean.getIns_st		());
			pstmt.setString	(4,		bean.getExp_st		());
			pstmt.setString	(5,		bean.getExp_dt		());

			pstmt.setString	(6,		bean.getCar_no_b	());
			pstmt.setString	(7,		bean.getCar_no_a	());
			pstmt.setString	(8,		bean.getCar_nm		());
			pstmt.setString	(9,		bean.getApp_st		());
			pstmt.setString	(10,	bean.getReg_id		());
			pstmt.setString	(11,	bean.getIns_con_no	());

			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[InsDatabase:insertInsDocList]\n"+e);
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

	//해지보험요청공문 리스트조회 : 공문별
	public Vector getInsDocLists(String doc_id)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT a.*, decode(a.ins_con_no,b.ins_con_no,b.ins_con_no,b.ins_con_no) ins_no FROM ins_doc_list a, insur b WHERE a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st and a.doc_id=? order by a.exp_dt";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, doc_id);
			rs = pstmt.executeQuery();

			while(rs.next()){
				InsDocListBean bean = new InsDocListBean();
				bean.setDoc_id 			(rs.getString(1));
				bean.setCar_mng_id		(rs.getString(2));
				bean.setIns_st			(rs.getString(3));
				bean.setExp_st			(rs.getString(4));
				bean.setExp_dt			(rs.getString(5));
				bean.setCar_no_b		(rs.getString(6));
				bean.setCar_no_a		(rs.getString(7));
				bean.setCar_nm			(rs.getString(8));
				bean.setApp_st			(rs.getString(9));
				bean.setReg_id			(rs.getString(10));
				bean.setReg_dt			(rs.getString(11));
				bean.setUpd_id			(rs.getString(12));
				bean.setUpd_dt			(rs.getString(13));
				bean.setIns_con_no		(rs.getString("ins_no"));
				vt.add(bean);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[InsDatabase:getInsDocLists]\n"+e);
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

	//보험사리스트 조회 : ins_com_sh.jsp
	public Hashtable getInsCom(String ins_com_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		query = " select * from ins_com where ins_com_id='"+ins_com_id+"'";
		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			if(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?" ":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[InsDatabase:getInsCom]"+ e);
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


	//엑셀파일을 이용한 보험갱신 등록----------------------------------------------------------------------------------------------------


	//중복입력 체크
	public int getCheckOverIns(String car_no, String ins_con_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		String query = "";

		query = " select count(*) cnt from insur"+
				" where car_mng_id in ( select car_mng_id from car_reg where car_no||' '||car_num like '%"+car_no+"%' )"+
				" and replace(ins_con_no,'-','')=replace('"+ins_con_no+"','-','')";
		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			if(rs.next())
			{				
				count = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[InsDatabase:getCheckOverIns(String car_no, String ins_con_no)]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null)		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}	


	//중복입력 체크_변경
	public int getCheckOverIns(String ins_con_no, String ch_amt, String ch_dt, String ch_item)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		String query = "";

		query = " SELECT COUNT(a.car_mng_id) FROM ins_change a, insur b  "+
				"  WHERE a.CH_AMT = '"+ch_amt+"' and a.ch_dt = '"+ch_dt+"' "+
				" AND DECODE(a.ch_item,'5','연령한정특약','14','임직원운전자','17','블랙박스','11','차량대체','1','대물배상')='"+ch_item+"' "+
				" AND b.ins_con_no='"+ins_con_no+"' AND a.car_mng_id=b.CAR_MNG_ID  ";
		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			if(rs.next())
			{				
				count = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[InsDatabase:getCheckOverIns(String ins_con_no, String ch_amt, String ch_dt, String ch_item)]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null)		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}	
	
	//중복입력 체크
	public int getCheckOverIns(String ins_con_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		String query = "";

		query = " SELECT COUNT(b.car_mng_id) FROM insur a , ins_cls b "+
				"  WHERE a.ins_con_no= '"+ins_con_no+"'  "+
				"  AND a.car_mng_id=b.CAR_MNG_ID AND a.ins_st = b.ins_st   ";
		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			if(rs.next())
			{				
				count = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[InsDatabase:getCheckOverIns(String car_no, String ins_con_no)]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null)		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}	

	//중복입력 체크
	public int getCheckOverIns2(String car_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		String query = "";

		query = " SELECT COUNT(car_mng_id) FROM car_reg  "+
				"  WHERE car_no= '"+car_no+"'  ";
		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			if(rs.next())
			{				
				count = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[InsDatabase:getCheckOverIns2(String car_no)]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null)		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}	
	
	/**
	 *	보험료 조회
	 */
	public InsurBean getInsExcelCase(String car_no)
	{
		getConnection();
		InsurBean ins = new InsurBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	"";

		query = " select a.*,\n"+
				" a.ins_exp_dt as ins_start_dt2, to_char(add_months(to_date(a.ins_exp_dt,'YYYYMMDD'),12),'YYYYMMDD') as ins_exp_dt2\n"+
				" from insur a, car_reg b, (select car_mng_id, max(TO_NUMBER(ins_st)) ins_st from insur group by car_mng_id) c \n"+
				" where a.car_mng_id=b.car_mng_id and a.car_mng_id=c.car_mng_id and a.ins_st=c.ins_st \n"+
				" and b.car_no||' '||b.car_num like '"+car_no+"%'";
		try{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{
				ins.setCar_mng_id(rs.getString("CAR_MNG_ID")==null?"":rs.getString("CAR_MNG_ID"));
				ins.setIns_st(rs.getString("INS_ST")==null?"":rs.getString("INS_ST"));
				ins.setIns_sts(rs.getString("INS_STS")==null?"":rs.getString("INS_STS"));
				ins.setAge_scp(rs.getString("AGE_SCP")==null?"":rs.getString("AGE_SCP"));
				ins.setCar_use(rs.getString("CAR_USE")==null?"":rs.getString("CAR_USE"));
				ins.setIns_com_id(rs.getString("INS_COM_ID")==null?"":rs.getString("INS_COM_ID"));
				ins.setIns_con_no(rs.getString("INS_CON_NO")==null?"":rs.getString("INS_CON_NO"));
				ins.setConr_nm(rs.getString("CONR_NM")==null?"":rs.getString("CONR_NM"));
				ins.setIns_start_dt(rs.getString("INS_START_DT2")==null?"":rs.getString("INS_START_DT2"));
				ins.setIns_exp_dt(rs.getString("INS_EXP_DT2")==null?"":rs.getString("INS_EXP_DT2"));
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
				ins.setReg_cau(rs.getString("REG_CAU")==null?"":rs.getString("REG_CAU"));
				ins.setAuto_yn(rs.getString("AUTO_YN")==null?"":rs.getString("AUTO_YN"));
				ins.setAbs_yn(rs.getString("ABS_YN")==null?"":rs.getString("ABS_YN"));
				ins.setIns_rent_dt(rs.getString("INS_RENT_DT")==null?"":rs.getString("INS_RENT_DT"));
				ins.setVins_cacdt_memin_amt(rs.getInt("VINS_CACDT_MEMIN_AMT"));
				ins.setVins_cacdt_mebase_amt(rs.getInt("VINS_CACDT_MEBASE_AMT"));
				ins.setBlackbox_yn(rs.getString("blackbox_yn")==null?"":rs.getString("blackbox_yn"));
				ins.setVins_share_extra_amt(rs.getInt("vins_share_extra_amt"));
				ins.setVins_blackbox_amt(rs.getInt("vins_blackbox_amt"));
				ins.setVins_blackbox_per(rs.getString("vins_blackbox_per")==null?"":rs.getString("vins_blackbox_per"));
				ins.setCom_emp_yn(rs.getString("com_emp_yn")==null?"":rs.getString("com_emp_yn"));
				ins.setBlackbox_nm(rs.getString("blackbox_nm")==null?"":rs.getString("blackbox_nm"));
				ins.setBlackbox_amt(rs.getInt("blackbox_amt"));
				ins.setBlackbox_no(rs.getString("blackbox_no")==null?"":rs.getString("blackbox_no"));
				ins.setBlackbox_dt(rs.getString("blackbox_dt")==null?"":rs.getString("blackbox_dt"));

			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[InsDatabase:getInsExcelCase]"+ e);
			System.out.println("[InsDatabase:getInsExcelCase]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null)		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ins;
		}
	}

	/**
	 *	보험계약별 스케줄 리스트 조회 : con_ins_u.jsp
	 */
	public InsurScdBean getInsExcelScd(String car_no, String ins_con_no, String ins_tm)
	{
		getConnection();
		InsurScdBean scd = new InsurScdBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " select d.*"+
				" from insur a, car_reg b, (select car_mng_id, max(TO_NUMBER(ins_st)) ins_st from insur group by car_mng_id) c, scd_ins d"+
				" where a.car_mng_id=b.car_mng_id and a.car_mng_id=c.car_mng_id and a.ins_st=c.ins_st and a.car_mng_id=d.car_mng_id and a.ins_st=d.ins_st"+
				" and d.pay_yn='0' and b.car_no=replace(?,' ','') and replace(a.ins_con_no,'-','')=replace(?,'-','') and d.ins_tm=?";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_no);
			pstmt.setString(2, ins_con_no);
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
			System.out.println("[InsDatabase:getInsExcelScd]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null)		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return scd;
		}
	}	

	//보험관리 중복입력 리스트 조회
	public Vector getInsDoubleList()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.car_mng_id,\n"+
				" c.car_no, c.first_car_no, c.car_nm,\n"+
				" f.ins_com_nm, a.ins_st, a.ins_start_dt, a.ins_exp_dt, a.ins_con_no, d.exp_dt,\n"+ 
				" (decode(a.air_ds_yn,'Y',1,0)+decode(a.air_as_yn,'Y',1,0)) as air,\n"+
				" decode(a.age_scp,'1','21세이상','2','26세이상','3','모든운전자','4','24세이상','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하') as age_scp,\n"+
				" decode(a.ins_kd,'2','책임보험', '종합보험') as ins_kd,\n"+
				" decode(a.car_use,'1','영업용', '업무용') as car_use,\n"+
				" decode(a.ins_sts,'1','유효', '2','만료', '3','중도해지','5','승계') as ins_sts, '' ch_dt\n"+
				" from insur a, (select car_mng_id, ins_start_dt, ins_exp_dt, count(*) from insur group by car_mng_id, ins_start_dt, ins_exp_dt having count(*)>1) b,\n"+
				" car_reg c, ins_com f, ins_cls d\n"+
				" where\n"+
				" a.car_mng_id=b.car_mng_id and a.ins_start_dt=b.ins_start_dt and a.ins_exp_dt=b.ins_exp_dt"+
				" and a.car_mng_id=c.car_mng_id\n"+
				" and a.ins_com_id=f.ins_com_id"+
				" and a.car_mng_id=d.car_mng_id(+) and a.ins_st=d.ins_st(+)"+
				" order by c.car_no, a.ins_start_dt, a.ins_st";

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
			
			System.out.println("[InsDatabase:getInsDoubleList]"+ e);
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

	//보험승계관리 리스트 조회
	public Vector getInsClsSuccList(String br_id, String gubun0, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String gubun7, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
				
		

		query = " select \n"+
				" a.*, \n"+
				" decode(b.f_car_no,a.b_car_no,'',b.f_car_no) f_car_no, \n"+
				" decode(b.f_car_no,a.b_car_no,'',b.f_car_nm) f_car_nm, \n"+
				" decode(b.f_car_no,a.b_car_no,'',b.reg_dt) reg_dt \n"+
				" from \n"+
				" ( \n"+
				"     select \n"+
				"     d.ins_com_nm, replace(ins_con_no,'-','') ins_con_no, decode(c.car_use,'1','영업용','2','업무용') car_use, \n"+
				"     c.ins_start_dt, c.ins_exp_dt, c.ins_sts, \n"+
				"     e.nm as car_kd, \n"+
				"     a.car_mng_id, a.ins_st, a.exp_dt, a.req_dt, b.car_no as b_car_no, b.car_nm as b_car_nm \n"+
				"     from ins_cls a, car_reg b, insur c, ins_com d, \n"+
				"          (select * from code where c_st='0041') e "+
				"     where a.cls_st='2' and a.car_mng_id=b.car_mng_id \n"+
				"     and a.car_mng_id=c.car_mng_id and a.ins_st=c.ins_st and c.ins_com_id=d.ins_com_id and b.car_kd=e.nm_cd \n"+
				" ) a, \n"+
				" ( \n"+
				"     select \n"+
				"     a.ins_con_no, c.car_no as f_car_no, c.car_nm as f_car_nm, b.reg_dt \n"+
				"     from \n"+
				"     (select replace(ins_con_no,'-','') ins_con_no, max(reg_dt) reg_dt from insur group by replace(ins_con_no,'-','')) a, \n"+
				"     (select replace(ins_con_no,'-','') ins_con_no, reg_dt, car_mng_id from insur) b, car_reg c \n"+
				"     where a.ins_con_no=b.ins_con_no(+) and a.reg_dt=b.reg_dt(+) and b.car_mng_id=c.car_mng_id \n"+
				" ) b \n"+
				" where a.ins_con_no=b.ins_con_no(+) \n";

			//1번이상 승계로 리스트에서 강제로 빼기
			query += " and a.car_mng_id not in ('026154')  \n";
			
			//미승계
			if(gubun1.equals("1"))				query += " and decode(b.f_car_no,a.b_car_no,'',b.f_car_no) is null \n";
			//승계
			else if(gubun1.equals("2"))			query += " and decode(b.f_car_no,a.b_car_no,'',b.f_car_no) is not null \n";
			

			query += " order by reg_dt desc";


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
			System.out.println("[InsDatabase:getInsClsSuccList]"+ e);
			System.out.println("[InsDatabase:getInsClsSuccList]"+ query);
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



	//선급비용처리-(20071206~)--------------------------------------------------------------------------------------------------

	//선급비용 미처리 리스트 조회
	public Vector getInsurPrecostNoRegList()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " select"+
				" d.car_use, d.car_no, a.car_mng_id, a.ins_st, a.ins_start_dt, a.ins_exp_dt,"+
				" to_date(a.ins_exp_dt,'YYYYMMDD')-to_date(a.ins_start_dt,'YYYYMMDD') as tot_days,"+
				" (a.rins_pcp_amt+a.vins_pcp_amt+a.vins_gcp_amt+a.vins_bacdt_amt+a.vins_canoisr_amt+a.vins_share_extra_amt+a.vins_cacdt_cm_amt+a.vins_spe_amt) tot_amt"+//-a.vins_blackbox_amt
				" from insur a,"+
				"      (select car_mng_id, cost_id from precost where cost_st='2' group by car_mng_id, cost_id) b,"+
				"      (select car_mng_id from cont where nvl(use_yn,'Y')='Y' and rent_l_cd not like 'RM%' group by car_mng_id) c, car_reg d"+
				" where a.ins_sts='1' and a.ins_start_dt >= '20100101'"+
				" and a.car_mng_id=b.car_mng_id(+) and a.ins_st=b.cost_id(+)"+
				" and a.car_mng_id=c.car_mng_id(+)"+
				" and a.car_mng_id=d.car_mng_id and nvl(d.prepare,'1') not in ('4','5')"+
				" and (a.rins_pcp_amt+a.vins_pcp_amt+a.vins_gcp_amt+a.vins_bacdt_amt+a.vins_canoisr_amt+a.vins_share_extra_amt+a.vins_cacdt_cm_amt+a.vins_spe_amt)>0 "+//-a.vins_blackbox_amt
				" and b.car_mng_id is null";

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
			
			System.out.println("[InsDatabase:getInsurPrecostNoRegList]"+ e);
			System.out.println("[InsDatabase:getInsurPrecostNoRegList]"+ query);
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

	//선급비용 미처리 리스트 조회
	public Vector getInsurPrecostNoRegList2()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
/*					
		query = " select"+
				" d.car_use, d.car_no, a.car_mng_id, a.ins_st, a.ins_start_dt, a.ins_exp_dt,"+
				" to_date(a.ins_exp_dt,'YYYYMMDD')-to_date(a.ins_start_dt,'YYYYMMDD') as tot_days,"+
				" (a.rins_pcp_amt+a.vins_pcp_amt+a.vins_gcp_amt+a.vins_bacdt_amt+a.vins_canoisr_amt+a.vins_cacdt_cm_amt+a.vins_spe_amt) tot_amt"+
				" from insur a,"+
				"      (select car_mng_id, cost_id from precost where cost_st='2' group by car_mng_id, cost_id) b,"+
				"      (select car_mng_id from cont where nvl(use_yn,'Y')='Y' and rent_l_cd not like 'RM%' group by car_mng_id) c, car_reg d"+
				" where a.ins_sts='1' and a.ins_start_dt >= '20070101'"+
				" and a.car_mng_id=b.car_mng_id(+) and a.ins_st=b.cost_id(+)"+
				" and a.car_mng_id=c.car_mng_id(+)"+
				" and a.car_mng_id=d.car_mng_id and nvl(d.prepare,'1') not in ('4','5')"+
				" and b.car_mng_id is null";
*/
		query = " select e.car_use, e.car_no, e.car_mng_id, a.ins_st, "+
				"        b.ins_start_dt, decode(d.exp_dt,'',b.ins_exp_dt, to_char(add_months(to_date(b.ins_start_dt,'YYYYMMDD'),12),'YYYYMMDD')) ins_exp_dt, d.exp_dt,"+
				"        365 as tot_days,"+
				"        a.ins_tm, a.ins_tm2, a.ch_tm,"+
				"        a.pay_dt, a.pay_amt as tot_amt,"+
				"        c.cost_amt,"+
				"        c.ch1_cost_amt,"+
				"        (a.pay_amt-c.cost_amt) cha_amt"+
				" from   scd_ins a, insur b, ins_cls d, car_reg e,"+
				"        ( select car_mng_id, cost_id, sum(decode(cost_tm,'1',cost_amt+rest_amt,0)) ch1_cost_amt, sum(cost_amt) cost_amt"+
				"          from   precost"+
				"          where  cost_st='2'"+
				"          group by car_mng_id, cost_id) c"+
				" where  a.ins_tm2='0'"+
				"        and a.pay_dt like '200902%'"+
				"        and a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st"+
				"        and a.car_mng_id=d.car_mng_id(+) and a.ins_st=d.ins_st(+)"+
				"        and a.car_mng_id=c.car_mng_id(+) and a.ins_st=c.cost_id(+)"+
				"        and a.car_mng_id=e.car_mng_id"+
				"        and (a.pay_amt-nvl(c.cost_amt,0))<>0"+
//				"        and nvl(c.cost_amt,0)=0"+
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
			
			System.out.println("[InsDatabase:getInsurPrecostNoRegList2]"+ e);
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

	//선급비용 미처리 리스트 조회
	public Vector getInsurPrecostNoSettleList()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " select"+
				" a.car_mng_id, a.ins_st, a.ins_start_dt, a.ins_exp_dt,"+
				" to_date(a.ins_exp_dt,'YYYYMMDD')-to_date(a.ins_start_dt,'YYYYMMDD') as tot_days,"+
				" (a.rins_pcp_amt+a.vins_pcp_amt+a.vins_gcp_amt+a.vins_bacdt_amt+a.vins_canoisr_amt+a.vins_share_extra_amt+a.vins_cacdt_cm_amt+a.vins_spe_amt) tot_amt,"+//-a.vins_blackbox_amt
				" f.pay_dt, f.pay_amt"+
				" from insur a,"+
				"      (select car_mng_id, cost_id, max(to_number(cost_ym)) cost_ym from precost where cost_st='2' group by car_mng_id, cost_id) b,"+
				"      (select car_mng_id from cont where nvl(use_yn,'Y')='Y' and rent_l_cd not like 'RM%' group by car_mng_id) c, car_reg d, precost e,"+
				"      (select * from scd_ins where ins_tm2='2' and pay_dt is not null) f "+
				" where a.ins_sts<>'1' "+ 
				" and a.ins_start_dt >= '20080101'"+
				" and a.car_mng_id=b.car_mng_id and a.ins_st=b.cost_id"+
				" and a.car_mng_id=c.car_mng_id(+)"+
				" and a.car_mng_id=f.car_mng_id and a.ins_st=f.ins_st"+
				" and a.car_mng_id=d.car_mng_id and nvl(d.prepare,'1') not in ('4','5')"+
				" and b.car_mng_id=e.car_mng_id and b.cost_id=e.cost_id and b.cost_ym=e.cost_ym and e.cost_st='2'"+
				" and (substr(a.ins_exp_dt,1,6)<>b.cost_ym or e.rest_amt>0)";

		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			int cnt = 0;
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);	

				if(cnt == 0){
//					System.out.println("[InsDatabase:getInsurPrecostNoSettleList]"+ query);
				}

				cnt++;
			}
			rs.close();
			pstmt.close();

//			System.out.println("[InsDatabase:getInsurPrecostNoSettleList]"+ query);
		} catch (SQLException e) {			
			System.out.println("[InsDatabase:getInsurPrecostNoSettleList]"+ e);
			System.out.println("[InsDatabase:getInsurPrecostNoSettleList]"+ query);
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

	//선급비용 미처리 리스트 조회
	public Vector getInsurPrecostNoSettleList_2009()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
/*					
		query = " select"+
				" a.car_mng_id, a.ins_st, a.ins_start_dt, a.ins_exp_dt,"+
				" to_date(a.ins_exp_dt,'YYYYMMDD')-to_date(a.ins_start_dt,'YYYYMMDD') as tot_days,"+
				" (a.rins_pcp_amt+a.vins_pcp_amt+a.vins_gcp_amt+a.vins_bacdt_amt+a.vins_canoisr_amt+a.vins_cacdt_cm_amt+a.vins_spe_amt) tot_amt,"+
				" f.pay_dt, f.pay_amt"+
				" from insur a,"+
				"      (select car_mng_id, cost_id, max(to_number(cost_ym)) cost_ym from precost where cost_st='2' group by car_mng_id, cost_id) b,"+
				"      (select car_mng_id from cont where nvl(use_yn,'Y')='Y' and rent_l_cd not like 'RM%' group by car_mng_id) c, car_reg d, precost e,"+
				"      (select * from scd_ins where ins_tm2='2' and pay_dt is not null) f "+
				" where a.ins_sts<>'1' "+ 
				" and a.ins_start_dt >= '20080101'"+
				" and a.car_mng_id=b.car_mng_id and a.ins_st=b.cost_id"+
				" and a.car_mng_id=c.car_mng_id(+)"+
				" and a.car_mng_id=f.car_mng_id and a.ins_st=f.ins_st"+
				" and a.car_mng_id=d.car_mng_id and nvl(d.prepare,'1') not in ('4','5')"+
				" and b.car_mng_id=e.car_mng_id and b.cost_id=e.cost_id and b.cost_ym=e.cost_ym and e.cost_st='2'"+
				" and (substr(a.ins_exp_dt,1,6)<>b.cost_ym or e.rest_amt>0)";
*/

		query += " select \n"+
				 "        d.car_no, b.car_mng_id, b.ins_st, b.pay_amt, b.pay_dt, a.ins_start_dt, a.ins_exp_dt, \n"+
				 "        to_char(sysdate,'YYYYMM') sys_ym, to_char(sysdate,'YYYYMMDD') sys_day,\n"+
                 "        a.tot_amt, \n"+
                 "        (a.tot_amt-b.pay_amt) r_tot_amt, \n"+
//                 "        (a.tot_amt-b.pay_amt-c.cost_amt) c_tot_amt, \n"+
				 "        (b2.pay_amt-b.pay_amt-c.cost_amt) c_tot_amt, \n"+ 	
                 "        c.cost_amt, c.cost_tm, c.cost_ym, c.rest_amt \n"+
                 " from \n"+
                 "        (select * from scd_ins where ins_tm2='2' and pay_dt is not null) b, \n"+
				 "        (select car_mng_id, ins_st, sum(pay_amt) pay_amt from scd_ins where ins_tm2<>'2' and pay_dt is not null group by car_mng_id, ins_st) b2, \n"+
                 "        (select a.*, (a.rins_pcp_amt+a.vins_pcp_amt+a.vins_gcp_amt+a.vins_bacdt_amt+a.vins_canoisr_amt+a.vins_share_extra_amt+a.vins_cacdt_cm_amt+a.vins_spe_amt) tot_amt from insur a) a, \n"+//-a.vins_blackbox_amt
				 "        car_reg d, \n"+
                 "        (select car_mng_id, cost_id, sum(cost_amt) cost_amt, max(cost_tm) cost_tm, max(cost_ym) cost_ym, min(rest_amt) rest_amt from precost where cost_st='2' group by car_mng_id, cost_id) c \n"+
                 " where \n"+
                 "        b.car_mng_id=a.car_mng_id and b.ins_st=a.ins_st \n"+
				 "        and b.car_mng_id=b2.car_mng_id and b.ins_st=b2.ins_st \n"+
                 "        and a.ins_start_dt >= '20080101' \n"+
                 "        and b.car_mng_id=c.car_mng_id and b.ins_st=c.cost_id \n"+
                 "        and a.car_mng_id=d.car_mng_id \n"+
//               "        and (a.tot_amt-b.pay_amt-c.cost_amt)<>0 \n"+
//			     "        and (b.pay_amt+(a.tot_amt-b.pay_amt-c.cost_amt))<>0 \n"+
				 "        and (b2.pay_amt-b.pay_amt-c.cost_amt)<>0 \n"+
                 "        and c.cost_ym > '200812'";

		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			int cnt = 0;
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);	

				if(cnt == 0){
//					System.out.println("[InsDatabase:getInsurPrecostNoSettleList]"+ query);
				}

				cnt++;
			}
			rs.close();
			pstmt.close();

//			System.out.println("[InsDatabase:getInsurPrecostNoSettleList]"+ query);
		} catch (SQLException e) {			
			System.out.println("[InsDatabase:getInsurPrecostNoSettleList_2009]"+ e);
			System.out.println("[InsDatabase:getInsurPrecostNoSettleList_2009]"+ query);
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

	//선납자동차세 선급비용 미처리 리스트 조회
	public Vector getExpPrecostNoRegList()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " select"+
				" d.car_use, d.car_no, a.car_mng_id, a.exp_est_dt, a.exp_start_dt, nvl(a.exp_end_dt,a.rtn_dt) exp_end_dt,"+
				" to_date(nvl(a.exp_end_dt,a.rtn_dt),'YYYYMMDD')-to_date(a.exp_start_dt,'YYYYMMDD') as tot_days,"+
				" (a.exp_amt-nvl(a.rtn_amt,0)) tot_amt"+
				" from gen_exp a,"+
				"      (select car_mng_id, cost_id from precost where cost_st='1' group by car_mng_id, cost_id) b,"+
				"      (select car_mng_id from cont where nvl(use_yn,'Y')='Y' and rent_l_cd not like 'RM%' group by car_mng_id) c, car_reg d"+
				" where a.exp_st='3' and a.exp_start_dt >='20090101'"+
				" and a.car_mng_id=b.car_mng_id(+) and a.exp_est_dt=b.cost_id(+)"+
				" and a.car_mng_id=c.car_mng_id(+)"+
				" and a.car_mng_id=d.car_mng_id and nvl(d.prepare,'1') not in ('4','5')"+
				" and b.car_mng_id is null";

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

			//System.out.println("[InsDatabase:getExpPrecostNoRegList]"+ query);
		} catch (SQLException e) {
			
			System.out.println("[InsDatabase:getExpPrecostNoRegList]"+ e);
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

	//선납자동차세 선급비용 미정산 리스트 조회
	public Vector getExpPrecostNoSettleList()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " select"+
				" a.car_mng_id, a.exp_est_dt, a.exp_start_dt, nvl(a.exp_end_dt,a.rtn_dt) exp_end_dt,"+
				" to_date(nvl(a.exp_end_dt,a.rtn_dt),'YYYYMMDD')-to_date(a.exp_start_dt,'YYYYMMDD') as tot_days,"+
				" (a.exp_amt-nvl(a.rtn_amt,0)) tot_amt"+
				" from gen_exp a,"+
				"      (select car_mng_id, cost_id, max(cost_ym) cost_ym from precost where cost_st='1' group by car_mng_id, cost_id) b,"+
				"      (select car_mng_id from cont where nvl(use_yn,'Y')='Y' and rent_l_cd not like 'RM%' group by car_mng_id) c, car_reg d"+
				" where a.exp_st='3' and a.exp_start_dt >='20070101' and a.rtn_dt is not null"+
				" and a.car_mng_id=b.car_mng_id(+) and a.exp_est_dt=b.cost_id(+)"+
				" and a.car_mng_id=c.car_mng_id(+)"+
				" and a.car_mng_id=d.car_mng_id and nvl(d.prepare,'1') not in ('4','5')"+
				" and substr(a.rtn_cau_dt,1,6)<>b.cost_ym";

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
			
			System.out.println("[InsDatabase:getExpPrecostNoSettleList]"+ e);
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

	//선급비용 미처리 리스트 조회
	public Hashtable getInsurPrecost(String car_mng_id, String cost_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
					
		query = " select"+
				" a.car_mng_id, a.ins_st, a.ins_start_dt, a.ins_exp_dt,a.ins_rent_dt,"+
				" to_date(a.ins_exp_dt,'YYYYMMDD')-to_date(a.ins_start_dt,'YYYYMMDD') as tot_days,"+
				" (NVL(a.rins_pcp_amt,0)+NVL(a.vins_pcp_amt,0)+NVL(a.vins_gcp_amt,0)+NVL(a.vins_bacdt_amt,0)+NVL(a.vins_canoisr_amt,0)+NVL(a.vins_share_extra_amt,0)+NVL(a.vins_cacdt_cm_amt,0)+NVL(a.vins_spe_amt,0)) tot_amt, e.pay_amt"+//-a.vins_blackbox_amt
				" from insur a,"+
				"      (select car_mng_id, cost_id from precost where cost_st='2' group by car_mng_id, cost_id) b,"+
				"      (select car_mng_id from cont where nvl(use_yn,'Y')='Y' and rent_l_cd not like 'RM%' group by car_mng_id) c, car_reg d,"+
				"      (select car_mng_id, ins_st, pay_amt from scd_ins where ins_tm2='0') e"+
				" where a.ins_start_dt >= '20070101'"+//a.ins_sts='1' and 
				" and a.car_mng_id=b.car_mng_id(+) and a.ins_st=b.cost_id(+)"+
				" and a.car_mng_id=c.car_mng_id(+)"+
				" and a.car_mng_id=d.car_mng_id and nvl(d.prepare,'1') not in ('4','5')"+
				" and a.car_mng_id=e.car_mng_id and a.ins_st=e.ins_st"+
				" and a.car_mng_id='"+car_mng_id+"' and a.ins_st='"+cost_id+"'";

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
			
			System.out.println("[InsDatabase:getInsurPrecost]"+ e);
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

	//선급비용 미처리 리스트 조회
	public PrecostBean getInsurPrecostCase(String cost_st, String car_mng_id, String cost_id, String cost_ym)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PrecostBean bean = new PrecostBean();
		String query = "";
					
		query = " select * from precost "+
				" where cost_st='"+cost_st+"' and car_mng_id='"+car_mng_id+"' and cost_id='"+cost_id+"'"+
				" and cost_ym=substr(replace('"+cost_ym+"','-',''),1,6)";

		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{				

			    bean.setCar_mng_id	(rs.getString("CAR_MNG_ID"));		
			    bean.setCost_st		(rs.getString("COST_ST"));		
			    bean.setCost_id		(rs.getString("COST_ID"));			
			    bean.setCost_tm		(rs.getString("COST_TM"));			
			    bean.setCost_ym		(rs.getString("COST_YM"));		
			    bean.setCost_day	(rs.getInt   ("COST_DAY"));		
			    bean.setCost_amt	(rs.getInt   ("COST_AMT"));			
			    bean.setRest_day	(rs.getInt   ("REST_DAY"));			
			    bean.setRest_amt	(rs.getInt   ("REST_AMT"));		
			    bean.setUpdate_id	(rs.getString("UPDATE_ID"));		
				bean.setUpdate_dt	(rs.getString("UPDATE_DT"));		
				bean.setCar_use		(rs.getString("CAR_USE"));		
				bean.setCar_use		(rs.getString("CAR_USE"));		
				bean.setCar_no		(rs.getString("CAR_NO"));		
				bean.setCost_tm2	(rs.getString("COST_TM2"));		

			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			
			System.out.println("[InsDatabase:getInsurPrecost(String car_mng_id, String cost_id, String cost_ym)]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
		                if(rs != null )		rs.close();
                		if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}
	}	

	/**
	 *	보험료스케줄생성 - 추가보험료 : ins_u_a.jsp
	 */
	public boolean insertPrecost(PrecostBean bean)
	{
		getConnection();
		boolean flag = true;

		String query =  " insert into precost "+
						" (CAR_MNG_ID, COST_ST, COST_ID, COST_TM, COST_YM, COST_DAY, COST_AMT, REST_DAY, REST_AMT, UPDATE_ID, UPDATE_DT, car_use, car_no, COST_TM2) values"+
						" (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, to_char(sysdate,'YYYYMMDD'), ?, ?, ?)";

		PreparedStatement pstmt = null;
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  bean.getCar_mng_id	());
			pstmt.setString(2,  bean.getCost_st		());
			pstmt.setString(3,  bean.getCost_id		());
			pstmt.setString(4,  bean.getCost_tm		());
			pstmt.setString(5,  bean.getCost_ym		());
			pstmt.setFloat (6,  bean.getCost_day	());
			pstmt.setFloat (7,  bean.getCost_amt	());
			pstmt.setFloat (8,  bean.getRest_day	());
			pstmt.setFloat (9,  bean.getRest_amt	());
			pstmt.setString(10, bean.getUpdate_id	());
			pstmt.setString(11, bean.getCar_use		());
			pstmt.setString(12, bean.getCar_no		());
			pstmt.setString(13, bean.getCost_tm2	());
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[InsDatabase:insertPrecost]"+ e);
			System.out.println("[bean.getCar_mng_id	()]"+ bean.getCar_mng_id());
			System.out.println("[bean.getCost_st	()]"+ bean.getCost_st	());
			System.out.println("[bean.getCost_id	()]"+ bean.getCost_id	());
			System.out.println("[bean.getUpdate_id	()]"+ bean.getUpdate_id	());
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
	public boolean updatePrecost(PrecostBean bean)
	{
		getConnection();
		boolean flag = true;

		String query =  " update precost set"+
						" COST_YM=?, COST_DAY=?, COST_AMT=?, REST_DAY=?, REST_AMT=?, UPDATE_ID=?, UPDATE_DT=to_char(sysdate,'YYYYMMDD')"+
						" where car_mng_id=? and cost_st=? and cost_id=? and cost_tm=?";

		PreparedStatement pstmt = null;
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  bean.getCost_ym		());
			pstmt.setFloat (2,  bean.getCost_day	());
			pstmt.setFloat (3,  bean.getCost_amt	());
			pstmt.setFloat (4,  bean.getRest_day	());
			pstmt.setFloat (5,  bean.getRest_amt	());
			pstmt.setString(6,  bean.getUpdate_id	());
			pstmt.setString(7,  bean.getCar_mng_id	());
			pstmt.setString(8,  bean.getCost_st		());
			pstmt.setString(9,  bean.getCost_id		());
			pstmt.setString(10, bean.getCost_tm		());

		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[InsDatabase:updatePrecost]"+ e);
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
	public boolean deletePrecost(PrecostBean bean)
	{
		getConnection();
		boolean flag = true;

		String query =  " delete from precost where car_mng_id=? and cost_st=? and cost_id=?";


		PreparedStatement pstmt = null;
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  bean.getCar_mng_id	());
			pstmt.setString(2,  bean.getCost_st		().trim());
			pstmt.setString(3,  bean.getCost_id		().trim());
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[InsDatabase:deletePrecost]"+ e);
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
	public boolean deletePrecostCase(PrecostBean bean)
	{
		getConnection();
		boolean flag = true;

		String query =  " delete from precost where car_mng_id=? and cost_st=? and cost_id=? and cost_tm=?";

		PreparedStatement pstmt = null;
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  bean.getCar_mng_id	());
			pstmt.setString(2,  bean.getCost_st		());
			pstmt.setString(3,  bean.getCost_id		());
			pstmt.setString(4,  bean.getCost_tm		());
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[InsDatabase:deletePrecost]"+ e);
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
	 *	보험료스케줄생성 - 기간비용 이후 삭제 : ins_u_a.jsp
	 */
	public boolean deleteNextPrecostCase(PrecostBean bean)
	{
		getConnection();
		boolean flag = true;

		String query =  " delete from precost where car_mng_id=? and cost_st=? and cost_id=? and cost_ym>=?";

		PreparedStatement pstmt = null;
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  bean.getCar_mng_id	());
			pstmt.setString(2,  bean.getCost_st		());
			pstmt.setString(3,  bean.getCost_id		());
			pstmt.setString(4,  bean.getCost_ym		());
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[InsDatabase:deletePrecost]"+ e);
			System.out.println("[bean.getCar_mng_id		()]"+ bean.getCar_mng_id	());
			System.out.println("[bean.getCost_st		()]"+ bean.getCost_st		());
			System.out.println("[bean.getCost_id		()]"+ bean.getCost_id		());
			System.out.println("[bean.getCost_ym		()]"+ bean.getCost_ym		());
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
	 *	해지로 인한 기간비용 정리하기
	 */
	public boolean deleteNextPrecostClsInsAct(String car_mng_id, String ins_id, String cls_dt, int ins_amt)
	{
		getConnection();
		boolean flag = true;

		String query1 = " update precost set cost_amt =(cost_amt+rest_amt-?), rest_day=0, rest_amt=0, cost_tm2='2' "+
						" where  car_mng_id=? and cost_id=? and cost_st='2' and cost_ym=substr(replace(?,'-',''),1,6)";

		String query2 = " delete from precost "+
						" where  car_mng_id=? and cost_id=? and cost_st='2' and cost_ym>substr(replace(?,'-',''),1,6)";

		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query1);
			pstmt.setInt   (1,  ins_amt);
			pstmt.setString(2,  car_mng_id);
			pstmt.setString(3,  ins_id);
			pstmt.setString(4,  cls_dt);
		    pstmt.executeUpdate();
			pstmt.close();

			pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString(1,  car_mng_id);
			pstmt2.setString(2,  ins_id);
			pstmt2.setString(3,  cls_dt);
		    pstmt2.executeUpdate();
			pstmt2.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[InsDatabase:deleteNextPrecostClsInsAct]"+ e);
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
	 *	해지로 인한 기간비용 정리하기 - 기간비용 이후일 때 추가
	 */
	public boolean deleteNextPrecostClsInsAct2(String car_mng_id, String ins_id, String cls_dt, int ins_amt)
	{
		getConnection();
		boolean flag = true;

		String query1 = " update precost set cost_amt =(cost_amt+rest_amt-?), rest_day=0, rest_amt=0, cost_tm2='2' "+
						" where  car_mng_id=? and cost_id=? and cost_st='2' and cost_ym=substr(replace(?,'-',''),1,6)";

		String query2 = " delete from precost "+
						" where  car_mng_id=? and cost_id=? and cost_st='2' and cost_ym>substr(replace(?,'-',''),1,6)";

		String query3 = " insert into precost "+
						" ( car_mng_id, cost_st, cost_id, cost_tm, cost_ym, cost_day , cost_amt, rest_day, rest_amt, car_use, car_no ) values  "+
						" ( ?, '2' , ?, ? , substr(replace(?,'-',''),1,6) , 0, ?, 0, 0, ?, ? )  " ;
	
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		ResultSet rs = null;
		int check_ym = 0;
		int check_dt =  Integer.parseInt( cls_dt.replace("-","").substring(0, 6) );
		String cost_tm = "";

		String query = "";
		
		query = "  SELECT a.cost_ym , a.cost_tm, a.car_use, a.car_no FROM precost a, (SELECT max(cost_ym) AS cost_ym  FROM  precost WHERE car_mng_id=? AND cost_id=? and cost_st='2' ) b  "+
			    "  where a.car_mng_id=? and a.cost_id=? AND a.cost_ym = b.cost_ym  ";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query2);
			pstmt.setString(1,  car_mng_id);
			pstmt.setString(2,  ins_id);
			pstmt.setString(3,  cls_dt);
		    pstmt.executeUpdate();
			pstmt.close();

			pstmt2 = conn.prepareStatement(query);
			pstmt2.setString(1, car_mng_id);
			pstmt2.setString(2, ins_id);
			pstmt2.setString(3, car_mng_id);
			pstmt2.setString(4, ins_id);
			rs = pstmt2.executeQuery();
			if(rs.next())
			{
				check_ym = rs.getInt("COST_YM");
				if(check_ym < check_dt){

					pstmt3 = conn.prepareStatement(query3);
					pstmt3.setString(1,  car_mng_id);
					pstmt3.setString(2,  ins_id);
					pstmt3.setInt(3,  rs.getInt("COST_TM")+1);
					pstmt3.setString(4,  cls_dt);
					pstmt3.setInt(5,  ins_amt*(-1));
					pstmt3.setString(6,  rs.getString("CAR_USE"));
					pstmt3.setString(7,  rs.getString("CAR_NO"));
					pstmt3.executeUpdate();
					pstmt3.close();

				}else{

					pstmt3 = conn.prepareStatement(query1);
					pstmt3.setInt   (1,  ins_amt);
					pstmt3.setString(2,  car_mng_id);
					pstmt3.setString(3,  ins_id);
					pstmt3.setString(4,  cls_dt);
					pstmt3.executeUpdate();
					pstmt3.close();
				}
			}
			rs.close();
			pstmt2.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[InsDatabase:deleteNextPrecostClsInsAct]"+ e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt2 != null)	pstmt2.close();
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
				if(pstmt3 != null)	pstmt3.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}


	/**
	 *	보험계약별 스케줄 리스트 조회 : con_ins_u.jsp
	 */
	public InsurScdBean getInsExcelScd(String car_no, String ins_con_no, String ins_est_dt, int pay_amt)
	{
		getConnection();
		InsurScdBean scd = new InsurScdBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " select d.*"+
				" from insur a, car_reg b, scd_ins d"+
				" where a.car_mng_id=b.car_mng_id and a.car_mng_id=d.car_mng_id and a.ins_st=d.ins_st"+
				" and d.pay_yn='0' "+
				" and b.car_no=replace(?,' ','') and replace(a.ins_con_no,'-','')=replace(?,'-','') and d.ins_est_dt=replace(?,'-','') and d.pay_amt=?";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_no);
			pstmt.setString(2, ins_con_no);
			pstmt.setString(3, ins_est_dt);
			pstmt.setInt   (4, pay_amt);

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
				scd.setIns_tm2(rs.getString("INS_TM2")==null?"":rs.getString("INS_TM2"));
				scd.setR_ins_est_dt(rs.getString("R_INS_EST_DT")==null?"":rs.getString("R_INS_EST_DT"));
				scd.setCh_tm(rs.getString("CH_TM")==null?"":rs.getString("CH_TM"));
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[InsDatabase:getInsExcelScd]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null)		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return scd;
		}
	}	


	/**
	 *	보험계약별 스케줄 리스트 조회 : con_ins_u.jsp
	 */
	public int getInsPrecostSearch(String car_mng_id, String ins_st)
	{
		getConnection();
		int count = 0;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " select count(*) cnt"+
				" from insur a, (select car_mng_id, cost_id, sum(cost_amt) cost_amt, min(cost_ym) cost_ym from precost where cost_st='2' group by car_mng_id, cost_id) b"+
				" where a.car_mng_id=? and a.ins_st=?"+
				" and a.car_mng_id=b.car_mng_id and a.ins_st=b.cost_id"+
				" and (a.rins_pcp_amt+a.vins_pcp_amt+a.vins_gcp_amt+a.vins_bacdt_amt+a.vins_canoisr_amt+a.vins_share_extra_amt+a.vins_cacdt_cm_amt+a.vins_spe_amt) = b.cost_amt";//-a.vins_blackbox_amt


		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
			pstmt.setString(2, ins_st);

	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{
				count = 1;
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[InsDatabase:getInsPrecostSearch]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null)		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}	

	/**
	 *	기간비용리스트
	 */
	public Vector getPrecosts(String car_mng_id, String cost_id, String cost_st)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	" select * from precost where car_mng_id = '"+car_mng_id+"' and cost_id = '"+cost_id+"' and cost_st='"+cost_st+"' order by cost_ym";
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
			System.out.println("[InsDatabase:getPrecosts]"+ e);
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

	//기간비용 월별 현황
	public Vector getInsurPrecostStat(String brch_id, String gubun1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " select"+
				" a.cost_ym as ym,"+
				" count(decode(decode(b.car_use,'3','2',b.car_use),'1',a.car_mng_id)) cnt1,"+
				" sum(decode(decode(b.car_use,'3','2',b.car_use),'1',a.cost_amt)) amt1,"+
				" count(decode(decode(b.car_use,'3','2',b.car_use),'2',a.car_mng_id)) cnt2,"+
				" sum(decode(decode(b.car_use,'3','2',b.car_use),'2',a.cost_amt)) amt2"+
				" from precost a, insur b, car_reg c"+
				" where a.cost_st='2' and a.cost_amt>0"+
				" and a.car_mng_id=b.car_mng_id and a.cost_id=b.ins_st"+
				" and a.car_mng_id=c.car_mng_id";

		if(brch_id.equals("S1"))	query += " and c.car_ext in ('1','2','6','7','8')";
		if(brch_id.equals("B1"))	query += " and c.car_ext in ('3','4')";
		if(brch_id.equals("D1"))	query += " and c.car_ext in ('5')";

		if(!gubun1.equals(""))		query += " and a.cost_ym like '%"+gubun1+"%'";

		query += " group by a.cost_ym order by a.cost_ym";

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
			
			System.out.println("[InsDatabase:getInsurPrecostStat]"+ e);
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

	//기간비용 월별 현황
	public Vector getInsurPrecostStat2(String brch_id, String gubun1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " select"+

				" a.cost_ym as ym,"+
				" count(a.car_mng_id) cnt0,"+
				" sum  (a.cost_amt  ) amt0,"+

				" count(decode(b.ins_com_id,'0007',a.car_mng_id)) cnt1,"+
				" sum  (decode(b.ins_com_id,'0007',a.cost_amt  )) amt1,"+
				" count(decode(b.ins_com_id,'0007',decode(decode(b.car_use,'3','2',b.car_use),'1',a.car_mng_id))) cnt2,"+
				" sum  (decode(b.ins_com_id,'0007',decode(decode(b.car_use,'3','2',b.car_use),'1',a.cost_amt  ))) amt2,"+
				" count(decode(b.ins_com_id,'0007',decode(decode(b.car_use,'3','2',b.car_use),'2',a.car_mng_id))) cnt3,"+
				" sum  (decode(b.ins_com_id,'0007',decode(decode(b.car_use,'3','2',b.car_use),'2',a.cost_amt  ))) amt3,"+
				" sum  (decode(b.ins_com_id,'0007',a.rest_amt  )) amt4,"+
	
				" count(decode(b.ins_com_id,'0008',a.car_mng_id)) cnt5,"+
				" sum  (decode(b.ins_com_id,'0008',a.cost_amt  )) amt5,"+
				" count(decode(b.ins_com_id,'0008',decode(decode(b.car_use,'3','2',b.car_use),'1',a.car_mng_id))) cnt6,"+
				" sum  (decode(b.ins_com_id,'0008',decode(decode(b.car_use,'3','2',b.car_use),'1',a.cost_amt  ))) amt6,"+
				" count(decode(b.ins_com_id,'0008',decode(decode(b.car_use,'3','2',b.car_use),'2',a.car_mng_id))) cnt7,"+
				" sum  (decode(b.ins_com_id,'0008',decode(decode(b.car_use,'3','2',b.car_use),'2',a.cost_amt  ))) amt7,"+
				" sum  (decode(b.ins_com_id,'0008',a.rest_amt  )) amt8"+

				" from precost a, insur b, car_reg c, ins_com d"+
				" where a.cost_st='2' and a.cost_amt>0"+
				" and a.car_mng_id=b.car_mng_id and a.cost_id=b.ins_st"+
				" and a.car_mng_id=c.car_mng_id and b.ins_com_id=d.ins_com_id";

		if(brch_id.equals("S1"))	query += " and c.car_ext in ('1','2','6','7','8')";
		if(brch_id.equals("B1"))	query += " and c.car_ext in ('3','4')";
		if(brch_id.equals("D1"))	query += " and c.car_ext in ('5')";

		if(!gubun1.equals(""))		query += " and a.cost_ym like '%"+gubun1+"%'";

		query += " group by a.cost_ym order by a.cost_ym";

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
			
			System.out.println("[InsDatabase:getInsurPrecostStat2]"+ e);
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

	//기간비용 월별 현황
	public Vector getInsurPrecostStat3(String brch_id, String gubun1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " select"+

				" a.cost_ym as ym, substr(a.cost_ym,5,2) as mm,"+
				" count(a.car_mng_id) cnt0,"+
				" sum  (a.cost_amt  ) amt1,"+
				" sum  (a.rest_amt  ) amt2,"+

				" count(decode(b.ins_com_id,'0007',a.car_mng_id)) cnt1,"+
				" sum  (decode(b.ins_com_id,'0007',a.cost_amt  )) amt3,"+
				" sum  (decode(b.ins_com_id,'0007',a.rest_amt  )) amt4,"+

				" count(decode(b.ins_com_id,'0007',decode(decode(b.car_use,'3','2',b.car_use),'1',a.car_mng_id))) cnt2,"+
				" sum  (decode(b.ins_com_id,'0007',decode(decode(b.car_use,'3','2',b.car_use),'1',a.cost_amt  ))) amt5,"+
				" sum  (decode(b.ins_com_id,'0007',decode(decode(b.car_use,'3','2',b.car_use),'1',a.rest_amt  ))) amt6,"+

				" count(decode(b.ins_com_id,'0007',decode(decode(b.car_use,'3','2',b.car_use),'2',a.car_mng_id))) cnt3,"+
				" sum  (decode(b.ins_com_id,'0007',decode(decode(b.car_use,'3','2',b.car_use),'2',a.cost_amt  ))) amt7,"+
				" sum  (decode(b.ins_com_id,'0007',decode(decode(b.car_use,'3','2',b.car_use),'2',a.rest_amt  ))) amt8,"+
	
				" count(decode(b.ins_com_id,'0008',a.car_mng_id)) cnt4,"+
				" sum  (decode(b.ins_com_id,'0008',a.cost_amt  )) amt9,"+
				" sum  (decode(b.ins_com_id,'0008',a.rest_amt  )) amt10,"+

				" count(decode(b.ins_com_id,'0008',decode(decode(b.car_use,'3','2',b.car_use),'1',a.car_mng_id))) cnt5,"+
				" sum  (decode(b.ins_com_id,'0008',decode(decode(b.car_use,'3','2',b.car_use),'1',a.cost_amt  ))) amt11,"+
				" sum  (decode(b.ins_com_id,'0008',decode(decode(b.car_use,'3','2',b.car_use),'1',a.rest_amt  ))) amt12,"+

				" count(decode(b.ins_com_id,'0008',decode(decode(b.car_use,'3','2',b.car_use),'2',a.car_mng_id))) cnt6,"+
				" sum  (decode(b.ins_com_id,'0008',decode(decode(b.car_use,'3','2',b.car_use),'2',a.cost_amt  ))) amt13,"+
				" sum  (decode(b.ins_com_id,'0008',decode(decode(b.car_use,'3','2',b.car_use),'2',a.rest_amt  ))) amt14,"+

				" count(decode(b.ins_com_id,'0007','','0008','',a.car_mng_id)) cnt7,"+
				" sum  (decode(b.ins_com_id,'0007',0, '0008',0,a.cost_amt  )) amt15,"+
				" sum  (decode(b.ins_com_id,'0007',0, '0008',0,a.rest_amt  )) amt16,"+

				" count(decode(b.ins_com_id,'0007','','0008','',decode(decode(b.car_use,'3','2',b.car_use),'1',a.car_mng_id))) cnt8,"+
				" sum  (decode(b.ins_com_id,'0007',0,'0008',0,  decode(decode(b.car_use,'3','2',b.car_use),'1',a.cost_amt  ))) amt17,"+
				" sum  (decode(b.ins_com_id,'0007',0,'0008',0,  decode(decode(b.car_use,'3','2',b.car_use),'1',a.rest_amt  ))) amt18,"+

				" count(decode(b.ins_com_id,'0007','','0008','',decode(decode(b.car_use,'3','2',b.car_use),'2',a.car_mng_id))) cnt9,"+
				" sum  (decode(b.ins_com_id,'0007',0,'0008',0,decode(decode(b.car_use,'3','2',b.car_use),'2',a.cost_amt  ))) amt19,"+
				" sum  (decode(b.ins_com_id,'0007',0,'0008',0,decode(decode(b.car_use,'3','2',b.car_use),'2',a.rest_amt  ))) amt20,"+

				" count(decode(decode(b.car_use,'3','2',b.car_use),'1',a.car_mng_id)) s_cnt1,"+
				" sum  (decode(decode(b.car_use,'3','2',b.car_use),'1',a.cost_amt  )) s_amt1,"+
				" sum  (decode(decode(b.car_use,'3','2',b.car_use),'1',a.rest_amt  )) s_amt2,"+

				" count(decode(decode(b.car_use,'3','2',b.car_use),'2',a.car_mng_id)) s_cnt2,"+
				" sum  (decode(decode(b.car_use,'3','2',b.car_use),'2',a.cost_amt  )) s_amt3,"+
				" sum  (decode(decode(b.car_use,'3','2',b.car_use),'2',a.rest_amt  )) s_amt4"+

				" from precost a, insur b, car_reg c, ins_com d"+
				" where a.cost_st='2' "+//and (a.cost_amt+a.rest_amt)>0
				" and a.car_mng_id=b.car_mng_id and a.cost_id=b.ins_st"+
				" and a.car_mng_id=c.car_mng_id and b.ins_com_id=d.ins_com_id  ";

		if(brch_id.equals("S1"))	query += " and c.car_ext in ('1','2','6','7','8')";
		if(brch_id.equals("B1"))	query += " and c.car_ext in ('3','4')";
		if(brch_id.equals("D1"))	query += " and c.car_ext in ('5')";

		if(!gubun1.equals(""))		query += " and a.cost_ym like '"+gubun1+"%'";

		query += " group by a.cost_ym order by a.cost_ym";

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
			
			System.out.println("[InsDatabase:getInsurPrecostStat3]"+ e);
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

	//납부보험료 월별 현황
	public Vector getInsurScdPayAmtStat3(String brch_id, String gubun1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " select"+
				" substr(a.pay_dt,1,6) ym, substr(substr(a.pay_dt,1,6),5,2) mm, "+

				" count(a.car_mng_id) s_cnt1, "+
				" sum  (decode(a.ins_tm2,'2',0,decode(sign(a.pay_amt),-1,0,a.pay_amt))) s_amt1, "+
				" sum  (decode(a.ins_tm2,'2',a.pay_amt,'1',decode(sign(a.pay_amt),-1,-a.pay_amt),0)) s_amt2, "+
				" sum  (decode(a.ins_tm2,'2',-a.pay_amt,a.pay_amt)) s_amt3, "+

				" count(decode(decode(b.car_use,'3','2',b.car_use),'1',a.car_mng_id)) s_cnt2, "+
				" sum  (decode(decode(b.car_use,'3','2',b.car_use),'1',decode(a.ins_tm2,'2',0,decode(sign(a.pay_amt),-1,0,a.pay_amt)))) s_amt4, "+
				" sum  (decode(decode(b.car_use,'3','2',b.car_use),'1',decode(a.ins_tm2,'2',a.pay_amt,'1',decode(sign(a.pay_amt),-1,-a.pay_amt),0))) s_amt5, "+
				" sum  (decode(decode(b.car_use,'3','2',b.car_use),'1',decode(a.ins_tm2,'2',-a.pay_amt,a.pay_amt))) s_amt6, "+


				" count(decode(decode(b.car_use,'3','2',b.car_use),'2',a.car_mng_id)) s_cnt3, "+
				" sum  (decode(decode(b.car_use,'3','2',b.car_use),'2',decode(a.ins_tm2,'2',0,decode(sign(a.pay_amt),-1,0,a.pay_amt)))) s_amt7, "+
				" sum  (decode(decode(b.car_use,'3','2',b.car_use),'2',decode(a.ins_tm2,'2',a.pay_amt,'1',decode(sign(a.pay_amt),-1,-a.pay_amt),0))) s_amt8, "+
				" sum  (decode(decode(b.car_use,'3','2',b.car_use),'2',decode(a.ins_tm2,'2',-a.pay_amt,a.pay_amt))) s_amt9, "+

				" count(decode(b.ins_com_id,'0038','','0008','',a.car_mng_id))  cnt1, "+
				" sum  (decode(b.ins_com_id,'0038',0,'0008',0,decode(a.ins_tm2,'2',0,decode(sign(a.pay_amt),-1,0,a.pay_amt)))) amt1, "+
				" sum  (decode(b.ins_com_id,'0038',0,'0008',0,decode(a.ins_tm2,'2',a.pay_amt,'1',decode(sign(a.pay_amt),-1,-a.pay_amt),0))) amt2, "+
				" sum  (decode(b.ins_com_id,'0038',0,'0008',0,decode(a.ins_tm2,'2',-a.pay_amt,a.pay_amt))) amt3, "+

				" count(decode(b.ins_com_id,'0038','','0008','',decode(decode(b.car_use,'3','2',b.car_use),'1',a.car_mng_id))) cnt2, "+
				" sum  (decode(b.ins_com_id,'0038',0,'0008',0,decode(decode(b.car_use,'3','2',b.car_use),'1',decode(a.ins_tm2,'2',0,decode(sign(a.pay_amt),-1,0,a.pay_amt))))) amt4, "+
				" sum  (decode(b.ins_com_id,'0038',0,'0008',0,decode(decode(b.car_use,'3','2',b.car_use),'1',decode(a.ins_tm2,'2',a.pay_amt,'1',decode(sign(a.pay_amt),-1,-a.pay_amt),0)))) amt5, "+
				" sum  (decode(b.ins_com_id,'0038',0,'0008',0,decode(decode(b.car_use,'3','2',b.car_use),'1',decode(a.ins_tm2,'2',-a.pay_amt,a.pay_amt)))) amt6, "+


				" count(decode(b.ins_com_id,'0038','','0008','',decode(decode(b.car_use,'3','2',b.car_use),'2',a.car_mng_id))) cnt3, "+
				" sum  (decode(b.ins_com_id,'0038',0,'0008',0,decode(decode(b.car_use,'3','2',b.car_use),'2',decode(a.ins_tm2,'2',0,decode(sign(a.pay_amt),-1,0,a.pay_amt))))) amt7, "+
				" sum  (decode(b.ins_com_id,'0038',0,'0008',0,decode(decode(b.car_use,'3','2',b.car_use),'2',decode(a.ins_tm2,'2',a.pay_amt,'1',decode(sign(a.pay_amt),-1,-a.pay_amt),0)))) amt8, "+
				" sum  (decode(b.ins_com_id,'0038',0,'0008',0,decode(decode(b.car_use,'3','2',b.car_use),'2',decode(a.ins_tm2,'2',-a.pay_amt,a.pay_amt)))) amt9, "+

				" count(decode(b.ins_com_id,'0008',a.car_mng_id)) cnt4, "+
				" sum  (decode(b.ins_com_id,'0008',decode(a.ins_tm2,'2',0,decode(sign(a.pay_amt),-1,0,a.pay_amt)))) amt10, "+
				" sum  (decode(b.ins_com_id,'0008',decode(a.ins_tm2,'2',a.pay_amt,'1',decode(sign(a.pay_amt),-1,-a.pay_amt),0))) amt11, "+
				" sum  (decode(b.ins_com_id,'0008',decode(a.ins_tm2,'2',-a.pay_amt,a.pay_amt))) amt12, "+

				" count(decode(b.ins_com_id,'0008',decode(decode(b.car_use,'3','2',b.car_use),'1',a.car_mng_id))) cnt5, "+
				" sum  (decode(b.ins_com_id,'0008',decode(decode(b.car_use,'3','2',b.car_use),'1',decode(a.ins_tm2,'2',0,decode(sign(a.pay_amt),-1,0,a.pay_amt))))) amt13, "+
				" sum  (decode(b.ins_com_id,'0008',decode(decode(b.car_use,'3','2',b.car_use),'1',decode(a.ins_tm2,'2',a.pay_amt,'1',decode(sign(a.pay_amt),-1,-a.pay_amt),0)))) amt14, "+
				" sum  (decode(b.ins_com_id,'0008',decode(decode(b.car_use,'3','2',b.car_use),'1',decode(a.ins_tm2,'2',-a.pay_amt,a.pay_amt)))) amt15, "+


				" count(decode(b.ins_com_id,'0008',decode(decode(b.car_use,'3','2',b.car_use),'2',a.car_mng_id))) cnt6, "+
				" sum  (decode(b.ins_com_id,'0008',decode(decode(b.car_use,'3','2',b.car_use),'2',decode(a.ins_tm2,'2',0,decode(sign(a.pay_amt),-1,0,a.pay_amt))))) amt16, "+
				" sum  (decode(b.ins_com_id,'0008',decode(decode(b.car_use,'3','2',b.car_use),'2',decode(a.ins_tm2,'2',a.pay_amt,'1',decode(sign(a.pay_amt),-1,-a.pay_amt),0)))) amt17, "+
				" sum  (decode(b.ins_com_id,'0008',decode(decode(b.car_use,'3','2',b.car_use),'2',decode(a.ins_tm2,'2',-a.pay_amt,a.pay_amt)))) amt18, "+

				" count(decode(b.ins_com_id,'0038',a.car_mng_id)) cnt7, "+
				" sum  (decode(b.ins_com_id,'0038',decode(a.ins_tm2,'2',0,decode(sign(a.pay_amt),-1,0,a.pay_amt))))  amt19, "+
				" sum  (decode(b.ins_com_id,'0038',decode(a.ins_tm2,'2',a.pay_amt,'1',decode(sign(a.pay_amt),-1,-a.pay_amt),0))) amt20, "+
				" sum  (decode(b.ins_com_id,'0038',decode(a.ins_tm2,'2',-a.pay_amt,a.pay_amt))) amt21, "+

				" count(decode(b.ins_com_id,'0038',decode(decode(b.car_use,'3','2',b.car_use),'1',a.car_mng_id))) cnt8, "+
				" sum  (decode(b.ins_com_id,'0038',decode(decode(b.car_use,'3','2',b.car_use),'1',decode(a.ins_tm2,'2',0,decode(sign(a.pay_amt),-1,0,a.pay_amt))))) amt22, "+
				" sum  (decode(b.ins_com_id,'0038',decode(decode(b.car_use,'3','2',b.car_use),'1',decode(a.ins_tm2,'2',a.pay_amt,'1',decode(sign(a.pay_amt),-1,-a.pay_amt),0)))) amt23, "+
				" sum  (decode(b.ins_com_id,'0038',decode(decode(b.car_use,'3','2',b.car_use),'1',decode(a.ins_tm2,'2',-a.pay_amt,a.pay_amt)))) amt24, "+


				" count(decode(b.ins_com_id,'0038',decode(decode(b.car_use,'3','2',b.car_use),'2',a.car_mng_id))) cnt9, "+
				" sum  (decode(b.ins_com_id,'0038',decode(decode(b.car_use,'3','2',b.car_use),'2',decode(a.ins_tm2,'2',0,decode(sign(a.pay_amt),-1,0,a.pay_amt))))) amt25, "+
				" sum  (decode(b.ins_com_id,'0038',decode(decode(b.car_use,'3','2',b.car_use),'2',decode(a.ins_tm2,'2',a.pay_amt,'1',decode(sign(a.pay_amt),-1,-a.pay_amt),0)))) amt26, "+
				" sum  (decode(b.ins_com_id,'0038',decode(decode(b.car_use,'3','2',b.car_use),'2',decode(a.ins_tm2,'2',-a.pay_amt,a.pay_amt)))) amt27 "+


				" from scd_ins a, insur b, car_reg c"+
				" where "+
				" a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st"+
				" and a.car_mng_id=c.car_mng_id";

		if(brch_id.equals("S1"))	query += " and c.car_ext in ('1','2','6','7','8')";
		if(brch_id.equals("B1"))	query += " and c.car_ext in ('3','4')";
		if(brch_id.equals("D1"))	query += " and c.car_ext in ('5')";

		if(!gubun1.equals(""))		query += " and a.pay_dt like '"+gubun1+"%'";

		query += " group by substr(a.pay_dt,1,6) order by substr(a.pay_dt,1,6)";

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
			
			System.out.println("[InsDatabase:getInsurScdPayAmtStat3]"+ e);
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

	//발생보험료 월별 현황
	public Vector getInsurScdReqAmtStat(String brch_id, String gubun1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		//보험시작일
		String pay_dt = "decode(a.ins_tm2,'0',b.ins_start_dt,'1',nvl(d.ch_dt,a.pay_dt), '2',nvl(e.req_dt,a.pay_dt), a.pay_dt)";

		//보험가입일	
		if(AddUtil.parseInt(gubun1) > 2016){
			pay_dt = "decode(a.ins_tm2,'0',nvl(b.ins_rent_dt,b.ins_start_dt),'1',nvl(d.ch_dt,a.pay_dt), '2',nvl(e.req_dt,a.pay_dt), a.pay_dt)";
		}
					
		query = " select"+
				" substr("+pay_dt+",1,6) ym, substr(substr("+pay_dt+",1,6),5,2) mm, "+

				" count(a.car_mng_id) s_cnt1, "+
				" sum  (decode(a.ins_tm2,'2',0,decode(sign(a.pay_amt),-1,0,a.pay_amt))) s_amt1, "+
				" sum  (decode(a.ins_tm2,'2',a.pay_amt,'1',decode(sign(a.pay_amt),-1,-a.pay_amt),0)) s_amt2, "+
				" sum  (decode(a.ins_tm2,'2',-a.pay_amt,a.pay_amt)) s_amt3, "+

				" count(decode(decode(b.car_use,'3','2',b.car_use),'1',a.car_mng_id)) s_cnt2, "+
				" sum  (decode(decode(b.car_use,'3','2',b.car_use),'1',decode(a.ins_tm2,'2',0,decode(sign(a.pay_amt),-1,0,a.pay_amt)))) s_amt4, "+
				" sum  (decode(decode(b.car_use,'3','2',b.car_use),'1',decode(a.ins_tm2,'2',a.pay_amt,'1',decode(sign(a.pay_amt),-1,-a.pay_amt),0))) s_amt5, "+
				" sum  (decode(decode(b.car_use,'3','2',b.car_use),'1',decode(a.ins_tm2,'2',-a.pay_amt,a.pay_amt))) s_amt6, "+


				" count(decode(decode(b.car_use,'3','2',b.car_use),'2',a.car_mng_id)) s_cnt3, "+
				" sum  (decode(decode(b.car_use,'3','2',b.car_use),'2',decode(a.ins_tm2,'2',0,decode(sign(a.pay_amt),-1,0,a.pay_amt)))) s_amt7, "+
				" sum  (decode(decode(b.car_use,'3','2',b.car_use),'2',decode(a.ins_tm2,'2',a.pay_amt,'1',decode(sign(a.pay_amt),-1,-a.pay_amt),0))) s_amt8, "+
				" sum  (decode(decode(b.car_use,'3','2',b.car_use),'2',decode(a.ins_tm2,'2',-a.pay_amt,a.pay_amt))) s_amt9, "+

				"  count(decode(b.ins_com_id,'0038','','0008','',a.car_mng_id)) cnt1, "+
				"  sum  (decode(b.ins_com_id,'0038',0,'0008',0,decode(a.ins_tm2,'2',0,decode(sign(a.pay_amt),-1,0,a.pay_amt)))) amt1, "+
				" sum  (decode(b.ins_com_id,'0038',0,'0008',0,decode(a.ins_tm2,'2',a.pay_amt,'1',decode(sign(a.pay_amt),-1,-a.pay_amt),0))) amt2, "+
				" sum  (decode(b.ins_com_id,'0038',0,'0008',0,decode(a.ins_tm2,'2',-a.pay_amt,a.pay_amt))) amt3, "+

				" count(decode(b.ins_com_id,'0038','','0008','',decode(decode(b.car_use,'3','2',b.car_use),'1',a.car_mng_id))) cnt2, "+
				" sum  (decode(b.ins_com_id,'0038',0,'0008',0,decode(decode(b.car_use,'3','2',b.car_use),'1',decode(a.ins_tm2,'2',0,decode(sign(a.pay_amt),-1,0,a.pay_amt))))) amt4, "+
				" sum  (decode(b.ins_com_id,'0038',0,'0008',0,decode(decode(b.car_use,'3','2',b.car_use),'1',decode(a.ins_tm2,'2',a.pay_amt,'1',decode(sign(a.pay_amt),-1,-a.pay_amt),0)))) amt5, "+
				" sum  (decode(b.ins_com_id,'0038',0,'0008',0,decode(decode(b.car_use,'3','2',b.car_use),'1',decode(a.ins_tm2,'2',-a.pay_amt,a.pay_amt)))) amt6, "+


				" count(decode(b.ins_com_id,'0038','','0008','',decode(decode(b.car_use,'3','2',b.car_use),'2',a.car_mng_id))) cnt3, "+
				" sum  (decode(b.ins_com_id,'0038',0,'0008',0,decode(decode(b.car_use,'3','2',b.car_use),'2',decode(a.ins_tm2,'2',0,decode(sign(a.pay_amt),-1,0,a.pay_amt))))) amt7, "+
				" sum  (decode(b.ins_com_id,'0038',0,'0008',0,decode(decode(b.car_use,'3','2',b.car_use),'2',decode(a.ins_tm2,'2',a.pay_amt,'1',decode(sign(a.pay_amt),-1,-a.pay_amt),0)))) amt8, "+
				" sum  (decode(b.ins_com_id,'0038',0,'0008',0,decode(decode(b.car_use,'3','2',b.car_use),'2',decode(a.ins_tm2,'2',-a.pay_amt,a.pay_amt)))) amt9, "+

				" count(decode(b.ins_com_id,'0008',a.car_mng_id)) cnt4, "+
				" sum  (decode(b.ins_com_id,'0008',decode(a.ins_tm2,'2',0,decode(sign(a.pay_amt),-1,0,a.pay_amt)))) amt10, "+
				" sum  (decode(b.ins_com_id,'0008',decode(a.ins_tm2,'2',a.pay_amt,'1',decode(sign(a.pay_amt),-1,-a.pay_amt),0))) amt11, "+
				" sum  (decode(b.ins_com_id,'0008',decode(a.ins_tm2,'2',-a.pay_amt,a.pay_amt))) amt12, "+

				" count(decode(b.ins_com_id,'0008',decode(decode(b.car_use,'3','2',b.car_use),'1',a.car_mng_id))) cnt5, "+
				" sum  (decode(b.ins_com_id,'0008',decode(decode(b.car_use,'3','2',b.car_use),'1',decode(a.ins_tm2,'2',0,decode(sign(a.pay_amt),-1,0,a.pay_amt))))) amt13, "+
				" sum  (decode(b.ins_com_id,'0008',decode(decode(b.car_use,'3','2',b.car_use),'1',decode(a.ins_tm2,'2',a.pay_amt,'1',decode(sign(a.pay_amt),-1,-a.pay_amt),0)))) amt14, "+
				" sum  (decode(b.ins_com_id,'0008',decode(decode(b.car_use,'3','2',b.car_use),'1',decode(a.ins_tm2,'2',-a.pay_amt,a.pay_amt)))) amt15, "+


				" count(decode(b.ins_com_id,'0008',decode(decode(b.car_use,'3','2',b.car_use),'2',a.car_mng_id))) cnt6, "+
				" sum  (decode(b.ins_com_id,'0008',decode(decode(b.car_use,'3','2',b.car_use),'2',decode(a.ins_tm2,'2',0,decode(sign(a.pay_amt),-1,0,a.pay_amt))))) amt16, "+
				" sum  (decode(b.ins_com_id,'0008',decode(decode(b.car_use,'3','2',b.car_use),'2',decode(a.ins_tm2,'2',a.pay_amt,'1',decode(sign(a.pay_amt),-1,-a.pay_amt),0)))) amt17, "+
				" sum  (decode(b.ins_com_id,'0008',decode(decode(b.car_use,'3','2',b.car_use),'2',decode(a.ins_tm2,'2',-a.pay_amt,a.pay_amt)))) amt18, "+

				" count(decode(b.ins_com_id,'0038',a.car_mng_id)) cnt7, "+
				" sum  (decode(b.ins_com_id,'0038',decode(a.ins_tm2,'2',0,decode(sign(a.pay_amt),-1,0,a.pay_amt)))) amt19, "+
				" sum  (decode(b.ins_com_id,'0038',decode(a.ins_tm2,'2',a.pay_amt,'1',decode(sign(a.pay_amt),-1,-a.pay_amt),0))) amt20, "+
				" sum  (decode(b.ins_com_id,'0038',decode(a.ins_tm2,'2',-a.pay_amt,a.pay_amt))) amt21, "+

				" count(decode(b.ins_com_id,'0038',decode(decode(b.car_use,'3','2',b.car_use),'1',a.car_mng_id))) cnt8, "+
				" sum  (decode(b.ins_com_id,'0038',decode(decode(b.car_use,'3','2',b.car_use),'1',decode(a.ins_tm2,'2',0,decode(sign(a.pay_amt),-1,0,a.pay_amt))))) amt22, "+
				" sum  (decode(b.ins_com_id,'0038',decode(decode(b.car_use,'3','2',b.car_use),'1',decode(a.ins_tm2,'2',a.pay_amt,'1',decode(sign(a.pay_amt),-1,-a.pay_amt),0)))) amt23, "+
				" sum  (decode(b.ins_com_id,'0038',decode(decode(b.car_use,'3','2',b.car_use),'1',decode(a.ins_tm2,'2',-a.pay_amt,a.pay_amt)))) amt24, "+


				" count(decode(b.ins_com_id,'0038',decode(decode(b.car_use,'3','2',b.car_use),'2',a.car_mng_id))) cnt9, "+
				" sum  (decode(b.ins_com_id,'0038',decode(decode(b.car_use,'3','2',b.car_use),'2',decode(a.ins_tm2,'2',0,decode(sign(a.pay_amt),-1,0,a.pay_amt))))) amt25, "+
				" sum  (decode(b.ins_com_id,'0038',decode(decode(b.car_use,'3','2',b.car_use),'2',decode(a.ins_tm2,'2',a.pay_amt,'1',decode(sign(a.pay_amt),-1,-a.pay_amt),0)))) amt26, "+
				" sum  (decode(b.ins_com_id,'0038',decode(decode(b.car_use,'3','2',b.car_use),'2',decode(a.ins_tm2,'2',-a.pay_amt,a.pay_amt)))) amt27 "+


				" from scd_ins a, insur b, car_reg c, ins_change d, INS_CLS e "+
				" where "+
				" a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st"+
				" and a.car_mng_id=c.car_mng_id"+
				" AND a.car_mng_id=d.car_mng_id(+) AND a.ins_st=d.ins_st(+) AND a.ch_tm=d.CH_TM(+) "+
				" AND a.car_mng_id=e.car_mng_id(+) AND a.ins_st=e.ins_st(+)"+
				" ";

		if(brch_id.equals("S1"))	query += " and c.car_ext in ('1','2','6','7','8')";
		if(brch_id.equals("B1"))	query += " and c.car_ext in ('3','4')";
		if(brch_id.equals("D1"))	query += " and c.car_ext in ('5')";

		if(!gubun1.equals(""))		query += " and "+pay_dt+" like '"+gubun1+"%'";

//		query += " and b.ins_com_id='0007'";



		query += " group by substr("+pay_dt+",1,6) order by substr("+pay_dt+",1,6)";

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
			
			System.out.println("[InsDatabase:getInsurScdReqAmtStat]"+ e);
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

	//기간비용 월별 현황
	public Vector getExpPrecostStat(String brch_id, String gubun1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " select"+
				" a.cost_ym as ym,"+
				" count(decode(c.car_use,'1',a.car_mng_id)) cnt1,"+
				" sum(decode(c.car_use,'1',a.cost_amt)) amt1,"+
				" count(decode(c.car_use,'2',a.car_mng_id)) cnt2,"+
				" sum(decode(c.car_use,'2',a.cost_amt)) amt2"+
				" from precost a, gen_exp b, car_reg c"+
				" where a.cost_st='1' and a.cost_amt>0 and b.exp_st='3'"+
				" and a.car_mng_id=b.car_mng_id and a.cost_id=b.exp_est_dt"+
				" and a.car_mng_id=c.car_mng_id";

		if(brch_id.equals("S1"))	query += " and c.car_ext in ('1','2','6','7','8')";
		if(brch_id.equals("B1"))	query += " and c.car_ext in ('3','4')";
		if(brch_id.equals("D1"))	query += " and c.car_ext in ('5')";

		if(!gubun1.equals(""))		query += " and a.cost_ym like '%"+gubun1+"%'";

		query += " group by a.cost_ym order by a.cost_ym";

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
			
			System.out.println("[InsDatabase:getExpPrecostStat]"+ e);
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

	//납부보험료 월별 현황
	public Vector getInsurScdPayAmtStat(String brch_id, String gubun1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " select"+
				" substr(a.pay_dt,1,6) ym,"+
				" count(decode(decode(b.car_use,'3','2',b.car_use),'1',a.car_mng_id)) cnt1,"+
				" sum(decode(decode(b.car_use,'3','2',b.car_use),'1',decode(a.ins_tm2,'2',-a.pay_amt,a.pay_amt))) amt1,"+
				" count(decode(decode(b.car_use,'3','2',b.car_use),'2',a.car_mng_id)) cnt2,"+
				" sum(decode(decode(b.car_use,'3','2',b.car_use),'2',decode(a.ins_tm2,'2',-a.pay_amt,a.pay_amt))) amt2"+
				" from scd_ins a, insur b, car_reg c"+
				" where "+
				" a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st"+
				" and a.car_mng_id=c.car_mng_id";

		if(brch_id.equals("S1"))	query += " and c.car_ext in ('1','2','6','7','8')";
		if(brch_id.equals("B1"))	query += " and c.car_ext in ('3','4')";
		if(brch_id.equals("D1"))	query += " and c.car_ext in ('5')";

		if(!gubun1.equals(""))		query += " and a.pay_dt like '"+gubun1+"%'";

		query += " group by substr(a.pay_dt,1,6) order by substr(a.pay_dt,1,6)";

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
			
			System.out.println("[InsDatabase:getInsurScdPayAmtStat]"+ e);
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

	//납부보험료 월별 현황
	public Vector getInsurScdPayAmtStat2(String brch_id, String gubun1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " select"+
				" substr(a.pay_dt,1,6) ym, substr(substr(a.pay_dt,1,6),5,2) mm, "+

				" count(a.car_mng_id) cnt1, "+
				" sum  (decode(a.ins_tm2,'2',0,a.pay_amt)) amt1, "+
				" sum  (decode(a.ins_tm2,'2',a.pay_amt,0)) amt2, "+
				" sum  (decode(a.ins_tm2,'2',-a.pay_amt,a.pay_amt)) amt3, "+

				" count(decode(decode(b.car_use,'3','2',b.car_use),'1',a.car_mng_id)) cnt2, "+
				" sum  (decode(decode(b.car_use,'3','2',b.car_use),'1',decode(a.ins_tm2,'2',0,a.pay_amt))) amt4, "+
				" sum  (decode(decode(b.car_use,'3','2',b.car_use),'1',decode(a.ins_tm2,'2',a.pay_amt,0))) amt5, "+
				" sum  (decode(decode(b.car_use,'3','2',b.car_use),'1',decode(a.ins_tm2,'2',-a.pay_amt,a.pay_amt))) amt6, "+


				" count(decode(decode(b.car_use,'3','2',b.car_use),'2',a.car_mng_id)) cnt3, "+
				" sum  (decode(decode(b.car_use,'3','2',b.car_use),'2',decode(a.ins_tm2,'2',0,a.pay_amt))) amt7, "+
				" sum  (decode(decode(b.car_use,'3','2',b.car_use),'2',decode(a.ins_tm2,'2',a.pay_amt,0))) amt8, "+
				" sum  (decode(decode(b.car_use,'3','2',b.car_use),'2',decode(a.ins_tm2,'2',-a.pay_amt,a.pay_amt))) amt9 "+

				" from scd_ins a, insur b, car_reg c"+
				" where "+
				" a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st"+
				" and a.car_mng_id=c.car_mng_id";

		if(brch_id.equals("S1"))	query += " and c.car_ext in ('1','2','6','7','8')";
		if(brch_id.equals("B1"))	query += " and c.car_ext in ('3','4')";
		if(brch_id.equals("D1"))	query += " and c.car_ext in ('5')";

		if(!gubun1.equals(""))		query += " and a.pay_dt like '"+gubun1+"%'";

//		query += " and b.ins_com_id='0007'";

		query += " group by substr(a.pay_dt,1,6) order by substr(a.pay_dt,1,6)";

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
			
			System.out.println("[InsDatabase:getInsurScdPayAmtStat2]"+ e);
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


	//납부자동차세 월별 현황
	public Vector getExpScdPayAmtStat(String brch_id, String gubun1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " select"+
				" substr(a.exp_dt,1,6) ym,"+
				" count(decode(c.car_use,'1',a.car_mng_id)) cnt1,"+
				" sum(decode(c.car_use,'1',a.exp_amt)) amt1,"+
				" count(decode(c.car_use,'2',a.car_mng_id)) cnt2,"+
				" sum(decode(c.car_use,'2',a.exp_amt)) amt2"+
				" from gen_exp a, car_reg c"+
				" where a.exp_st='3'"+
				" and a.car_mng_id=c.car_mng_id and a.exp_dt is not null";

		if(brch_id.equals("S1"))	query += " and c.car_ext in ('1','2','6','7','8')";
		if(brch_id.equals("B1"))	query += " and c.car_ext in ('3','4')";
		if(brch_id.equals("D1"))	query += " and c.car_ext in ('5')";

		if(!gubun1.equals(""))		query += " and a.exp_dt like '"+gubun1+"%'";

		query += " group by substr(a.exp_dt,1,6) order by substr(a.exp_dt,1,6)";

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
			
			System.out.println("[InsDatabase:getExpScdPayAmtStat]"+ e);
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

	//납부예정보험료 월별현황
	public Vector getInsurScdEstAmtStat(String brch_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " select"+
				" substr(a.ins_est_dt,1,6) ym,"+
				" count(decode(b.car_use,'1',a.car_mng_id)) cnt1,"+
				" sum(decode(b.car_use,'1',decode(a.ins_tm2,'2',-a.pay_amt,a.pay_amt))) amt1,"+
				" count(decode(b.car_use,'2',a.car_mng_id)) cnt2,"+
				" sum(decode(b.car_use,'2',decode(a.ins_tm2,'2',-a.pay_amt,a.pay_amt))) amt2"+
				" from scd_ins a, insur b, car_reg c"+
				" where a.pay_dt is null"+
				" and a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st"+
				" and a.car_mng_id=c.car_mng_id";

		if(brch_id.equals("S1"))	query += " and c.car_ext in ('1','2','6','7','8')";
		if(brch_id.equals("B1"))	query += " and c.car_ext in ('3','4')";
		if(brch_id.equals("D1"))	query += " and c.car_ext in ('5')";

		query += " group by substr(a.ins_est_dt,1,6) order by substr(a.ins_est_dt,1,6)";

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
			
			System.out.println("[InsDatabase:getInsurScdEstAmtStat]"+ e);
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

	//납부예정자동차세 월별현황
	public Vector getExpScdEstAmtStat(String brch_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " select"+
				" d.nm as car_ext_nm,"+
				" c.car_ext,"+
				" count(decode(c.car_use,'1',a.car_mng_id)) cnt1,"+
				" sum(decode(c.car_use,'1',a.exp_amt)) amt1,"+
				" count(decode(c.car_use,'2',a.car_mng_id)) cnt2,"+
				" sum(decode(c.car_use,'2',a.exp_amt)) amt2"+
				" from gen_exp a, car_reg c, code d"+
				" where a.exp_st='3' and a.exp_dt is null"+
				" AND a.CAR_EXT = d.NM_CD "+
				" AND d.C_ST ='0032' "+
				" and a.car_mng_id=c.car_mng_id";

		if(brch_id.equals("S1"))	query += " and c.car_ext in ('1','2','6','7','8')";
		if(brch_id.equals("B1"))	query += " and c.car_ext in ('3','4')";
		if(brch_id.equals("D1"))	query += " and c.car_ext in ('5')";
		
		query += " group by d.nm, c.car_ext order by d.nm"; 

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
			
			System.out.println("[InsDatabase:getExpScdEstAmtStat]"+ e);
			System.out.println("[InsDatabase:getExpScdEstAmtStat]"+ query);
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

	//환급예정자동차세 월별현황
	public Vector getExpRtnScdEstAmtStat(String brch_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

query = " select"+
//				" a.car_ext, decode(a.car_ext,'1','서울','2','파주','3','부산','4','김해','5','대전','6','포천','7','인천','8','제주','9','광주','10','대구') car_ext_nm,"+
				" d.nm car_ext_nm,"+
				" a.car_ext,"+
				" count(decode(a.rtn_req_dt,'','',a.car_mng_id)) cnt1,"+
				" sum(decode(a.rtn_req_dt,'',0,a.rtn_est_amt)) amt1,"+
				" count(decode(a.rtn_req_dt,'',a.car_mng_id)) cnt2,"+
				" sum(decode(a.rtn_req_dt,'',a.rtn_est_amt)) amt2"+
				" from gen_exp a, car_reg c, code d"+
				" where a.exp_st='3' and a.rtn_est_amt>0 and a.rtn_amt=0 and a.rtn_dt is null"+
				" AND a.CAR_EXT = d.NM_CD "+
				" AND d.C_ST ='0032' "+
				" and a.car_mng_id=c.car_mng_id";

		if(brch_id.equals("S1"))	query += " and c.car_ext in ('1','2','6','7','8')";
		if(brch_id.equals("B1"))	query += " and c.car_ext in ('3','4')";
		if(brch_id.equals("D1"))	query += " and c.car_ext in ('5')";

		query += " group by d.nm, a.car_ext order by d.nm";


//System.out.println("getExpRtnScdEstAmtStat= "+query);

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
			
			System.out.println("[InsDatabase:getExpRtnScdEstAmtStat]"+ e);
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

	//자동차세 미등록 현황
	public Vector getExpScdNonRegStat(String brch_id, String gubun1, String mode, String car_use)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String sub_query = "";
		String query = "";
					
		sub_query = " select"+
				" decode(f.car_mng_id,'','','매각') sui_st,"+
				" b.car_mng_id, b.car_no, b.car_nm, b.init_reg_dt, b.car_ext, g.nm, b.car_use, b.car_kd, b.taking_p, b.dpm, b.dpm_tax1, b.dpm_tax2, b.days, nvl(d.exp_amt,0) exp_amt, d.exp_dt, d.rtn_cau_dt,"+
				" decode(b.taking_p_st,1,'7-9인승',decode(b.car_kd_st,1,'승용',2,'화물',3,'승합')) car_st, "+
				" decode(b.taking_p_st,1,to_char(round(b.dpm_tax1*b.dpm/365*b.days,-1)),decode(b.car_kd_st,1,to_char(round(b.dpm_tax1*b.dpm/365*b.days,-1)),2,to_char(round(6600/365*b.days,-1)), 3,to_char(round(25000/365*b.days,-1))))-nvl(d.exp_amt,0) car_tax1,/*영업용-렌트*/"+   //round(b.dpm_tax1*b.dpm/365*b.days*0.84,-1)
				" decode(b.taking_p_st,1,to_char(round(b.dpm_tax2*b.dpm/365*b.days,-1)),decode(b.car_kd_st,1,to_char(round(b.dpm_tax2*b.dpm/365*b.days,-1)),2,to_char(round(28500/365*b.days,-1)),3,to_char(round(65000/365*b.days,-1))))-nvl(d.exp_amt,0) car_tax2/*비영업용-리스*/"+	//*0.84
				" from cont a,"+
				" (select car_mng_id, car_no, car_nm, dpm, init_reg_dt, car_use, car_ext, car_kd, taking_p,"+
				"    decode(sign(dpm-800)+sign(dpm-1000)+sign(dpm-1600)+sign(dpm-2000),-4,18,-2,18,0,19,2,19,4,24) dpm_tax1,"+
//				"    decode(sign(dpm-800)+sign(dpm-1000)+sign(dpm-1600)+sign(dpm-2000),-4,80,-2,100,0,140,2,200,4,220) dpm_tax2,"+
				"    decode(sign(dpm-800)+sign(dpm-1000)+sign(dpm-1600)+sign(dpm-2000),-4,80,-2,80,0,140,2,140,4,200) dpm_tax2,"+
				"    decode(car_kd,'1',1,'2',1,'3',1,'9',1,'6',2,'7',2,'8',2,'4',3,'5',3,0) car_kd_st,"+
				"    decode(taking_p,'7',1,'9',1,'10',1,0) taking_p_st,"+
				"    decode(substr(init_reg_dt,1,4),'"+gubun1+"',to_date('"+gubun1+"1231','YYYYMMDD')-to_date(init_reg_dt,'YYYYMMDD')+1,365) days"+
				"    from car_reg"+
				"    where nvl(prepare,'1') not in ('4','5')"+
//				"    and init_reg_dt between '"+(AddUtil.parseInt(gubun1)-1)+"1201' and '"+gubun1+"1130'"+
				"    and init_reg_dt < '"+gubun1+"1231'"+
				" ) b,"+
				" (select car_mng_id from gen_exp where exp_st='3' and nvl(rtn_cau_dt,exp_end_dt)='"+gubun1+"1231') c,"+
				" (select car_mng_id, sum(exp_amt)-sum(nvl(rtn_amt,0)) exp_amt, max(exp_dt) exp_dt, max(rtn_cau_dt) rtn_cau_dt  from gen_exp where exp_st='3' and exp_end_dt like '"+gubun1+"%' group by car_mng_id) d,"+
				" sui f, code g"+
				" where"+
				" nvl(a.use_yn,'Y')='Y' and a.rent_l_cd not like 'RM%' "+
				" and g.c_st ='0032' "+
				" and a.car_mng_id=b.car_mng_id"+
				" and a.car_mng_id=c.car_mng_id(+) and c.car_mng_id is null"+
				" and a.car_mng_id=d.car_mng_id(+)"+
				" and a.car_mng_id=f.car_mng_id(+)" +
				" and b.car_ext = g.nm_cd ";

		if(brch_id.equals("S1"))	sub_query += " and b.car_ext in ('1','2','6','7','8')";
		if(brch_id.equals("B1"))	sub_query += " and b.car_ext in ('3','4')";
		if(brch_id.equals("D1"))	sub_query += " and b.car_ext in ('5')";

		if(brch_id.equals("1"))		sub_query += " and b.car_ext = '1'";
		if(brch_id.equals("2"))		sub_query += " and b.car_ext = '2'";
		if(brch_id.equals("3"))		sub_query += " and b.car_ext = '3'";
		if(brch_id.equals("4"))		sub_query += " and b.car_ext = '4'";
		if(brch_id.equals("5"))		sub_query += " and b.car_ext = '5'";
		if(brch_id.equals("6"))		sub_query += " and b.car_ext = '6'";
		if(brch_id.equals("7"))		sub_query += " and b.car_ext = '7'";
		if(brch_id.equals("8"))		sub_query += " and b.car_ext = '8'";
		if(brch_id.equals("9"))		sub_query += " and b.car_ext = '9'";
		if(brch_id.equals("10"))	sub_query += " and b.car_ext = '10'";

		if(car_use.equals("1"))		sub_query += " and b.car_use = '1'";
		if(car_use.equals("2"))		sub_query += " and b.car_use = '2'";

		if(mode.equals("stat")){
			query = 
					//" select car_ext, decode(car_ext,'1','서울','2','파주','3','부산','4','김해','5','대전','6','포천','7','인천','8','제주','9','광주','10','대구') car_ext_nm, "+
					" select car_ext, nm car_ext_nm, "+
					" count(decode(car_use,'1',car_mng_id)) cnt1,"+
					" sum(decode(car_use,'1',car_tax1-exp_amt)) amt1,"+
					" count(decode(car_use,'2',car_mng_id)) cnt2,"+
					" sum(decode(car_use,'2',car_tax2+decode(car_st,'승합',0,'화물',0,(round(car_tax2*0.3,-1)))-exp_amt)) amt2"+									
					" from ("+sub_query+") where car_tax2>0 group by car_ext,nm order by car_ext";
		}else{
			query = " select sui_st, car_mng_id, car_no, car_nm, init_reg_dt, car_st, dpm, exp_amt, exp_dt, rtn_cau_dt,"+
					//"        decode(car_ext,'1','서울','2','파주','3','부산','4','김해','5','대전','6','포천','7','인천','8','제주','9','광주','10','대구') car_ext,"+
					"        nm car_ext,"+
					"		 decode(car_use,'1','영업용','2','자가용') car_use,"+
					"		 decode(car_use,'1',car_tax1,'2',car_tax2) car_tax,"+
					"		 decode(car_use,'1',0,'2',decode(car_st,'승합',0,'화물',0,round(car_tax2*0.3,-1))) edu_tax,"+
					"		 decode(car_use,'1',car_tax1,'2',car_tax2+decode(car_st,'승합',0,'화물',0,round(car_tax2*0.3,-1))) tot_tax"+
					" from ("+sub_query+") where car_tax2>0 order by nm, car_use, taking_p, init_reg_dt";

		}

//System.out.println("[InsDatabase:getExpScdNonRegStat]"+ query);

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
			System.out.println("[InsDatabase:getExpScdNonRegStat]"+ e);
			System.out.println("[InsDatabase:getExpScdNonRegStat]"+ query);
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

	//자동차세 당월 예상 현황
	public Vector getExpScdMonEst(String car_use, String mode, String mon)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String sub_query = "";
		String query = "";
		String s_day = "sysdate";
		String s_mon = "to_char(sysdate,'YYYYMM')";
		String when = "to_char(sysdate,'YYYYMM')";

		if(!mon.equals("")){
			s_day = "to_date('"+mon+"01"+"','YYYYMMDD')";
			s_mon = mon;
		}
					
		sub_query = " select"+
				" b.car_mng_id, b.car_no, b.car_nm, b.init_reg_dt, b.car_ext, c.nm, b.car_use, b.car_kd, b.taking_p, b.dpm, b.dpm_tax1, b.dpm_tax2, b.days, "+
				" decode(b.taking_p_st,1,'7-9인승',decode(b.car_kd_st,1,'승용',2,'화물',3,'승합')) car_st, "+
				" decode(b.taking_p_st,1,to_char(round(b.dpm_tax1*b.dpm/365*b.days,-1)),decode(b.car_kd_st,1,to_char(round(b.dpm_tax1*b.dpm/365*b.days,-1)),2,to_char(round(6600/365*b.days,-1)), 3,to_char(round(25000/365*b.days,-1)))) car_tax1,/*영업용-렌트*/"+ //round(b.dpm_tax1*b.dpm/365*b.days*0.84,-1)
				" decode(b.taking_p_st,1,to_char(round(b.dpm_tax2*b.dpm/365*b.days,-1)),decode(b.car_kd_st,1,to_char(round(b.dpm_tax2*b.dpm/365*b.days,-1)),2,to_char(round(28500/365*b.days,-1)),3,to_char(round(65000/365*b.days,-1)))) car_tax2/*비영업용-리스*/"+
				" from cont a,"+
				" (select car_mng_id, car_no, car_nm, dpm, init_reg_dt, car_use, car_ext, car_kd, taking_p,"+
				"    decode(sign(dpm-800)+sign(dpm-1000)+sign(dpm-1600)+sign(dpm-2000),-4,18,-2,18,0,19,2,19,4,24) dpm_tax1,"+
//				"    decode(sign(dpm-800)+sign(dpm-1000)+sign(dpm-1600)+sign(dpm-2000),-4,80,-2,100,0,140,2,200,4,220) dpm_tax2,"+
				"    decode(sign(dpm-800)+sign(dpm-1000)+sign(dpm-1600)+sign(dpm-2000),-4,80,-2,80,0,140,2,140,4,200) dpm_tax2,"+
				"    decode(car_kd,'1',1,'2',1,'3',1,'9',1,'6',2,'7',2,'8',2,'4',3,'5',3,0) car_kd_st,"+
				"    decode(taking_p,'7',1,'9',1,'10',1,0) taking_p_st,"+
				"    trunc(last_day("+s_day+")-to_date(decode(substr(init_reg_dt,1,6),"+s_mon+",init_reg_dt,"+s_mon+"||'01'),'YYYYMMDD')+1,0) days"+
				"    from car_reg"+
				"    where nvl(prepare,'1') not in ('4','5') and car_use='"+car_use+"'"+
				" ) b, code c "+
				" where"+
				" nvl(a.use_yn,'Y')='Y' and a.rent_l_cd not like 'RM%' and c.c_st ='0032' "+
				" b.car_ext = c.nm_cd "+
				" and a.car_mng_id=b.car_mng_id";

		if(!mon.equals("")) sub_query += " and substr(b.init_reg_dt,1,6) <= "+mon;

		if(mode.equals("stat")){
			query = 
					//" select car_ext, decode(car_ext,'1','서울','2','파주','3','부산','4','김해','5','대전','6','포천','7','인천','8','제주','9','광주','10','대구') car_ext_nm, "+
					" select car_ext, nm car_ext_nm, "+
					" count(decode(car_use,'1',car_mng_id)) cnt1,"+
					" sum(decode(car_use,'1',car_tax1)) amt1,"+
					" count(decode(car_use,'2',car_mng_id)) cnt2,"+
					" sum(decode(car_use,'2',car_tax2+decode(car_st,'승합',0,'화물',0,(round(car_tax2*0.3,-1))))) amt2"+									
					" from ("+sub_query+") group by car_ext, nm order by car_ext";
		}else{
			query = " select car_mng_id, car_no, car_nm, init_reg_dt, car_st, dpm, days,"+
					//"        decode(car_ext,'1','서울','2','파주','3','부산','4','김해','5','대전','6','포천','7','인천','8','제주','9','광주','10','대구') car_ext,"+
					"        nm car_ext,"+
					"		 decode(car_use,'1','영업용','2','자가용') car_use,"+
					"		 decode(car_use,'1',car_tax1,'2',car_tax2) car_tax,"+
					"		 decode(car_use,'1',0,'2',decode(car_st,'승합',0,'화물',0,round(car_tax2*0.3,-1))) edu_tax,"+
					"		 decode(car_use,'1',car_tax1,'2',car_tax2+decode(car_st,'승합',0,'화물',0,round(car_tax2*0.3,-1))) tot_tax"+
					" from ("+sub_query+") order by init_reg_dt";
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
			System.out.println("[InsDatabase:getExpScdMonEst]"+ e);
			System.out.println("[InsDatabase:getExpScdMonEst]"+ query);
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
	 *	기간비용정산
	 */
	public boolean settleInsurPrecost(InsurBean bean, String pay_dt, int pay_amt)
	{
		getConnection();
		boolean flag = true;

		String query1 =  " delete from precost where car_mng_id=? and cost_st='2' and cost_id=? and cost_ym > substr(?,1,6)";
		String query2 =  " update precost set "+
						 "		cost_day=0, cost_amt=0, rest_day=0, rest_amt=0 "+
						 " where car_mng_id=? and cost_st='2' and cost_id=? and cost_ym=substr(?,1,6)";

		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query1);
			pstmt1.setString(1,  bean.getCar_mng_id	());
			pstmt1.setString(2,  bean.getIns_st		());
			pstmt1.setString(3,  pay_dt);
		    pstmt1.executeUpdate();
			pstmt1.close();

			pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString(1,  bean.getCar_mng_id	());
			pstmt2.setString(2,  bean.getIns_st		());
			pstmt2.setString(3,  pay_dt);
		    pstmt2.executeUpdate();
			pstmt2.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[InsDatabase:settleInsurPrecost]"+ e);
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
	 *	기간비용정산
	 */
	public boolean settleExpPrecost(GenExpBean bean)
	{
		getConnection();
		boolean flag = true;

		String query1 =  " delete from precost where car_mng_id=? and cost_st='1' and cost_id=replace(?,'-','') and cost_ym > substr(replace(?,'-',''),1,6)";
		String query2 =  " update precost set "+
						 "		cost_day=to_date(replace(?,'-',''),'YYYYMMDD')-to_date(substr(replace(?,'-',''),1,6)||'01','YYYYMMDD')+1,"+
						 "		cost_amt=cost_amt/cost_day*(to_date(replace(?,'-',''),'YYYYMMDD')-to_date(substr(replace(?,'-',''),1,6)||'01','YYYYMMDD')+1), "+
						 "		rest_day=0, rest_amt=0 "+
						 " where car_mng_id=? and cost_st='1' and cost_id=replace(?,'-','') and cost_tm=substr(replace(?,'-',''),1,6)";

		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query1);
			pstmt1.setString(1,  bean.getCar_mng_id	());
			pstmt1.setString(2,  bean.getExp_est_dt	());
			pstmt1.setString(3,  bean.getRtn_cau_dt	());
		    pstmt1.executeUpdate();
			pstmt1.close();

			pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString(1,  bean.getRtn_cau_dt	());
			pstmt2.setString(2,  bean.getRtn_cau_dt	());
			pstmt2.setString(3,  bean.getRtn_cau_dt	());
			pstmt2.setString(4,  bean.getRtn_cau_dt	());
			pstmt2.setString(5,  bean.getCar_mng_id	());
			pstmt2.setString(6,  bean.getExp_est_dt	());
			pstmt2.setString(7,  bean.getRtn_cau_dt	());
		    pstmt2.executeUpdate();
			pstmt2.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[InsDatabase:settleExpPrecost]"+ e);
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

	//기간비용 월별리스트
	public Vector getInsurPrecostYmList(String cost_ym, String cost_st, String car_use)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " select"+
				" c.car_no, decode(c.first_car_no,c.car_no,'',c.first_car_no) first_car_no, b.ins_start_dt, b.ins_exp_dt, b.tot_days, b.tot_amt,"+
//				" (b.tot_days-a.rest_day-a.cost_day) bm_day, (b.tot_amt-a.rest_amt-a.cost_amt) bm_amt,"+
				" nvl(d.rest_day,0) as bm_day, nvl(d.rest_amt,0) as bm_amt,"+
				" a.cost_day, a.cost_amt, a.rest_day, a.rest_amt, e.ins_com_nm, b.ins_com_id"+
				" from precost a, car_reg c,"+
				" (select car_mng_id, ins_st, ins_start_dt, ins_exp_dt, car_use, ins_com_id, "+
				"     to_date(ins_exp_dt,'YYYYMMDD')-to_date(ins_start_dt,'YYYYMMDD') as tot_days,"+
				"     (rins_pcp_amt+vins_pcp_amt+vins_gcp_amt+vins_bacdt_amt+vins_canoisr_amt+vins_share_extra_amt+vins_cacdt_cm_amt+vins_spe_amt) tot_amt"+//-vins_blackbox_amt
				"     from insur) b,"+
				" (select car_mng_id, cost_id, rest_day, rest_amt from precost where cost_st='2' and cost_ym = to_char(to_date('"+cost_ym+"','YYYYMM')-1,'YYYYMM')) d,"+
				" ins_com e"+		
				" where "+
				" a.cost_st='2' and a.cost_amt>0"+
				" and a.car_mng_id=c.car_mng_id"+
				" and a.car_mng_id=b.car_mng_id and a.cost_id=b.ins_st"+
				" and a.car_mng_id=d.car_mng_id(+) and a.cost_id=d.cost_id(+) and b.ins_com_id=e.ins_com_id"+
				" and a.cost_ym='"+cost_ym+"' and b.ins_start_dt > '20091201'" ;

		if(!car_use.equals("")) query += " and decode(b.car_use,'3','2',b.car_use)='"+car_use+"'";

		//query += " order by b.ins_start_dt, a.car_mng_id";


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

			//System.out.println("[InsDatabase:getInsurPrecostYmList]"+ query);
		} catch (SQLException e) {
			
			System.out.println("[InsDatabase:getInsurPrecostYmList]"+ e);
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

	//기간비용 월별리스트
	public Vector getInsurPrecostYmList2(String cost_ym, String cost_st, String car_use, String com_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " select \n"+
				"        nvl(a.car_no,c.car_no) car_no, decode(a.car_no,c.car_no,decode(c.first_car_no,c.car_no,'',c.first_car_no),'') first_car_no, \n"+
				"        b.ins_start_dt, b.ins_exp_dt, b.tot_days, b.tot_amt as o_tot_amt, \n"+
				"        a.cost_day, a.cost_amt, a.rest_day, a.rest_amt, e.ins_com_nm, e.ins_com_id, \n"+
				"        decode(b.ins_exp_dt,f.exp_dt,f.exp_dt,b.ins_exp_dt) o_ins_exp_dt, nvl(g.pay_amt,b.tot_amt) as tot_amt, "+
				"	     f.req_dt \n"+
				" from   precost a, car_reg c, \n"+
				"        ( select car_mng_id, ins_st, ins_start_dt, ins_exp_dt, car_use, ins_com_id, \n"+
				"                 to_date(ins_exp_dt,'YYYYMMDD')-to_date(ins_start_dt,'YYYYMMDD') as tot_days, \n"+
				"                (rins_pcp_amt+vins_pcp_amt+vins_gcp_amt+vins_bacdt_amt+vins_canoisr_amt+vins_share_extra_amt+vins_cacdt_cm_amt+vins_spe_amt) tot_amt \n"+//-vins_blackbox_amt
				"          from  insur \n"+
				"	     ) b, \n"+
				"        ( select a.car_mng_id, a.cost_id, a.cost_ym,  \n"+
				"	              a.cost_day  \n"+
//				"                 to_char(to_date(a.cost_ym||decode(length(decode(a.cost_day,0,1,a.cost_day)),1,'0')||decode(a.cost_day,0,1,a.cost_day),'YYYYMMDD')+1,'YYYYMMDD') as o_ins_exp_dt \n"+
				"	       from   precost a, (select car_mng_id, cost_id, max(to_number(cost_tm)) cost_tm from precost where cost_st='2' and cost_amt<>0 group by car_mng_id, cost_id) b  \n"+
				"          where  a.cost_st='2' and a.car_mng_id=b.car_mng_id and a.cost_id=b.cost_id and a.cost_tm=b.cost_tm  \n"+
				"        ) d,  \n"+
                "        ins_com e, ins_cls f,  \n"+
				"        ( select car_mng_id, ins_st, sum(pay_amt) pay_amt from scd_ins where ins_tm2='0' group by car_mng_id, ins_st) g \n"+
				" where  \n"+
				"        a.cost_ym='"+cost_ym+"' \n"+
				"        and a.cost_st='2' \n"+
				"        and a.car_mng_id=c.car_mng_id \n"+
				"        and a.car_mng_id=b.car_mng_id and a.cost_id=b.ins_st \n"+
				"        and a.car_mng_id=d.car_mng_id and a.cost_id=d.cost_id \n"+
				"        and b.ins_com_id=e.ins_com_id \n"+
				"        and a.car_mng_id=f.car_mng_id(+) and a.cost_id=f.ins_st(+) \n"+		
				"        and a.car_mng_id=g.car_mng_id(+) and a.cost_id=g.ins_st(+) \n"+		
				" ";

		if(!car_use.equals("")) query += " and decode(b.car_use,'3','2',b.car_use)='"+car_use+"' \n";

		if(!com_id.equals("")) query += " and b.ins_com_id='"+com_id+"' \n";

		query += " order by b.ins_start_dt, a.cost_day, a.rest_day, a.car_mng_id";


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

//System.out.println("[InsDatabase:getInsurPrecostYmList2]"+ query);
		} catch (SQLException e) {
			
			System.out.println("[InsDatabase:getInsurPrecostYmList2]"+ e);
			System.out.println("[InsDatabase:getInsurPrecostYmList2]"+ query);
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

	//기간비용 월별리스트
	public Vector getExpPrecostYmList(String cost_ym, String cost_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " select"+
				" c.car_no, nvl(b.car_no,decode(c.first_car_no,c.car_no,'',c.first_car_no)) first_car_no, b.exp_start_dt, b.exp_end_dt, b.tot_days, b.tot_amt,"+
//				" (b.tot_days-a.rest_day-a.cost_day) bm_day, (b.tot_amt-a.rest_amt-a.cost_amt) bm_amt,"+
				" nvl(d.rest_day,0) as bm_day, nvl(d.rest_amt,0) as bm_amt,"+
				" a.cost_day, a.cost_amt, a.rest_day, a.rest_amt"+
				" from precost a, car_reg c,"+
				" (select car_mng_id, exp_est_dt, exp_start_dt, exp_end_dt, car_no,"+
				"     to_date(exp_end_dt,'YYYYMMDD')-to_date(exp_start_dt,'YYYYMMDD') as tot_days,"+
				"     (exp_amt) tot_amt"+
				"     from gen_exp where exp_st='3') b,"+
				" (select car_mng_id, cost_id, rest_day, rest_amt from precost where cost_st='1' and cost_ym = to_char(to_date('"+cost_ym+"','YYYYMM')-1,'YYYYMM')) d"+
				" where "+
				" a.cost_st='1' and a.cost_amt>0"+
				" and a.car_mng_id=c.car_mng_id"+
				" and a.car_mng_id=b.car_mng_id and a.cost_id=b.exp_est_dt"+
				" and a.car_mng_id=d.car_mng_id(+) and a.cost_id=d.cost_id(+)"+
				" and a.cost_ym='"+cost_ym+"'";

		query += " order by b.exp_start_dt, a.car_mng_id";

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
			
			System.out.println("[InsDatabase:getExpPrecostYmList]"+ e);
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

	//보험료 리스트
	public Vector getInsurScdYmList(String cost_ym, String pay_yn)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " select"+
				" c.car_no, decode(c.first_car_no,c.car_no,'',c.first_car_no) first_car_no, b.ins_start_dt, b.ins_exp_dt, b.tot_days, b.tot_amt,"+
				" a.ins_est_dt, a.pay_dt, decode(a.ins_tm2,'2',-a.pay_amt,a.pay_amt) pay_amt, a.ins_tm, "+
				" decode(a.ins_tm2,'0','당초','1','추가','2','환급') ins_tm2, d.ins_com_nm"+
				" from scd_ins a, car_reg c,"+
				" (select car_mng_id, ins_st, ins_com_id, ins_start_dt, ins_exp_dt,"+
				"     to_date(ins_exp_dt,'YYYYMMDD')-to_date(ins_start_dt,'YYYYMMDD') as tot_days,"+
				"     (rins_pcp_amt+vins_pcp_amt+vins_gcp_amt+vins_bacdt_amt+vins_canoisr_amt+vins_share_extra_amt+vins_cacdt_cm_amt+vins_spe_amt) tot_amt"+//-vins_blackbox_amt
				"     from insur) b, ins_com d"+
				" where "+
				" a.car_mng_id=c.car_mng_id"+//nvl(a.ins_tm2,'0')<>'2' and 
				" and a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st and b.ins_com_id=d.ins_com_id";

		if(pay_yn.equals("0"))	query += " and a.pay_yn='0' and a.ins_est_dt like '"+cost_ym+"%'";
		if(pay_yn.equals("1"))	query += " and a.pay_yn='1' and a.pay_dt like '"+cost_ym+"%'";

		query += " order by d.ins_com_nm, a.ins_tm2, b.ins_start_dt, a.car_mng_id";

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
			
			System.out.println("[InsDatabase:getInsurScdYmList]"+ e);
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

	//보험료 리스트
	public Vector getInsurScdYmList2(String cost_ym, String pay_yn, String car_use, String tm_st1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " select"+
				" c.car_no, decode(c.first_car_no,c.car_no,'',c.first_car_no) first_car_no, b.ins_start_dt, b.ins_exp_dt, b.tot_days, b.tot_amt,"+
				" a.ins_est_dt, a.pay_dt, decode(a.ins_tm2,'2',-a.pay_amt,a.pay_amt) pay_amt, a.ins_tm, "+
				" decode(a.ins_tm2,'0','당초','1','추가','2','환급') ins_tm2, d.ins_com_nm"+
				" from scd_ins a, car_reg c,"+
				" (select car_mng_id, ins_st, ins_com_id, ins_start_dt, ins_exp_dt, car_use,"+
				"     to_date(ins_exp_dt,'YYYYMMDD')-to_date(ins_start_dt,'YYYYMMDD') as tot_days,"+
				"     (rins_pcp_amt+vins_pcp_amt+vins_gcp_amt+vins_bacdt_amt+vins_canoisr_amt+vins_share_extra_amt+vins_cacdt_cm_amt+vins_spe_amt) tot_amt"+//-vins_blackbox_amt
				"     from insur) b, ins_com d"+
				" where "+
				" a.car_mng_id=c.car_mng_id"+//nvl(a.ins_tm2,'0')<>'2' and 
				" and a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st and b.ins_com_id=d.ins_com_id";

		if(pay_yn.equals("0"))	query += " and a.pay_yn='0' and a.ins_est_dt like '"+cost_ym+"%'";
		if(pay_yn.equals("1"))	query += " and a.pay_yn='1' and a.pay_dt like '"+cost_ym+"%'";

		if(!car_use.equals("")) query += " and decode(b.car_use,'3','2',b.car_use)='"+car_use+"'";

		if(tm_st1.equals("1"))	query += " and nvl(a.ins_tm2,'1')<>'2'";
		if(tm_st1.equals("2"))	query += " and nvl(a.ins_tm2,'1')='2'";


		query += " order by d.ins_com_nm, a.ins_tm2, b.ins_start_dt, a.car_mng_id";

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
			
			System.out.println("[InsDatabase:getInsurScdYmList2]"+ e);
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

	//보험료 리스트 현황
	public Vector getInsurScdYmStat(String cost_ym, String pay_yn)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String query2 = "";
					
		query = " select"+
				" c.car_no, decode(c.first_car_no,c.car_no,'',c.first_car_no) first_car_no, b.ins_start_dt, b.ins_exp_dt, b.tot_days, b.tot_amt,"+
				" a.ins_est_dt, a.pay_dt, decode(a.ins_tm2,'2',-a.pay_amt,a.pay_amt) pay_amt, a.ins_tm, "+
				" decode(a.ins_tm2,'0','당초','1','추가','2','환급') ins_tm2, d.ins_com_nm"+
				" from scd_ins a, car_reg c,"+
				" (select car_mng_id, ins_st, ins_com_id, ins_start_dt, ins_exp_dt,"+
				"     to_date(ins_exp_dt,'YYYYMMDD')-to_date(ins_start_dt,'YYYYMMDD') as tot_days,"+
				"     (rins_pcp_amt+vins_pcp_amt+vins_gcp_amt+vins_bacdt_amt+vins_canoisr_amt+vins_share_extra_amt+vins_cacdt_cm_amt+vins_spe_amt) tot_amt"+//-vins_blackbox_amt
				"     from insur) b, ins_com d"+
				" where "+
				" a.car_mng_id=c.car_mng_id"+//nvl(a.ins_tm2,'0')<>'2' and 
				" and a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st and b.ins_com_id=d.ins_com_id";

		if(pay_yn.equals("0"))	query += " and a.pay_yn='0' and a.ins_est_dt like '"+cost_ym+"%'";
		if(pay_yn.equals("1"))	query += " and a.pay_yn='1' and a.pay_dt like '"+cost_ym+"%'";

		query += " order by d.ins_com_nm, a.ins_tm2, b.ins_start_dt, a.car_mng_id";

		query2 = " select ins_com_nm, count(*) cnt0, sum(pay_amt) amt0,"+
				 " count(decode(ins_tm2,'환급','',car_no)) cnt1, count(decode(ins_tm2,'환급',car_no)) cnt2,"+
				 " sum(decode(ins_tm2,'환급','',pay_amt)) amt1, sum(decode(ins_tm2,'환급',pay_amt)) amt2"+
				 " from ("+query+") group by ins_com_nm  order by ins_com_nm ";

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
			System.out.println("[InsDatabase:getInsurScdYmStat]"+ e);
			System.out.println("[InsDatabase:getInsurScdYmStat]"+ query2);
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

	//보험료 리스트 현황
	public Vector getInsurScdYmStat2(String cost_ym, String pay_yn, String car_use, String tm_st1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String query2 = "";
					
		query = " select"+
				" c.car_no, decode(c.first_car_no,c.car_no,'',c.first_car_no) first_car_no, b.ins_start_dt, b.ins_exp_dt, b.tot_days, b.tot_amt,"+
				" a.ins_est_dt, a.pay_dt, decode(a.ins_tm2,'2',-a.pay_amt,a.pay_amt) pay_amt, a.ins_tm, "+
				" decode(a.ins_tm2,'0','당초','1','추가','2','환급') ins_tm2, d.ins_com_nm"+
				" from scd_ins a, car_reg c,"+
				" (select car_mng_id, ins_st, ins_com_id, ins_start_dt, ins_exp_dt, car_use, "+
				"     to_date(ins_exp_dt,'YYYYMMDD')-to_date(ins_start_dt,'YYYYMMDD') as tot_days,"+
				"     (rins_pcp_amt+vins_pcp_amt+vins_gcp_amt+vins_bacdt_amt+vins_canoisr_amt+vins_share_extra_amt+vins_cacdt_cm_amt+vins_spe_amt) tot_amt"+//-vins_blackbox_amt
				"     from insur) b, ins_com d"+
				" where "+
				" a.car_mng_id=c.car_mng_id"+//nvl(a.ins_tm2,'0')<>'2' and 
				" and a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st and b.ins_com_id=d.ins_com_id";

		if(pay_yn.equals("0"))	query += " and a.pay_yn='0' and a.ins_est_dt like '"+cost_ym+"%'";
		if(pay_yn.equals("1"))	query += " and a.pay_yn='1' and a.pay_dt like '"+cost_ym+"%'";

		if(!car_use.equals("")) query += " and decode(b.car_use,'3','2',b.car_use)='"+car_use+"'";

		if(tm_st1.equals("1"))	query += " and nvl(a.ins_tm2,'1')<>'2'";
		if(tm_st1.equals("2"))	query += " and nvl(a.ins_tm2,'1')='2'";


		query += " order by d.ins_com_nm, a.ins_tm2, b.ins_start_dt, a.car_mng_id";

		query2 = " select ins_com_nm, count(*) cnt0, sum(pay_amt) amt0,"+
				 " count(decode(ins_tm2,'환급','',car_no)) cnt1, count(decode(ins_tm2,'환급',car_no)) cnt2,"+
				 " sum(decode(ins_tm2,'환급','',pay_amt)) amt1, sum(decode(ins_tm2,'환급',pay_amt)) amt2"+
				 " from ("+query+") group by ins_com_nm  order by ins_com_nm ";

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
			System.out.println("[InsDatabase:getInsurScdYmStat2]"+ e);
			System.out.println("[InsDatabase:getInsurScdYmStat2]"+ query2);
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

	//자동차세 리스트
	public Vector getExpScdYmList(String cost_ym, String pay_yn, String car_ext)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " select"+
				" a.car_mng_id, nvl(a.car_no,c.car_no) as exp_car_no, c.car_no, decode(c.first_car_no,c.car_no,'',c.first_car_no) first_car_no, a.exp_start_dt, a.exp_end_dt, a.rtn_cau_dt, a.exp_amt, a.rtn_dt, nvl(a.rtn_amt,0) rtn_amt,"+
				" a.exp_est_dt, a.exp_dt, (a.exp_amt-nvl(a.rtn_amt,0)) r_exp_amt, a.rtn_req_dt, b.client_id, "+
				" d.nm car_ext_nm "+
				" from gen_exp a, car_reg c, sui b, code d "+
				" where "+
				" a.exp_st='3' and d.c_st ='0032' and a.car_mng_id=c.car_mng_id and a.car_mng_id=b.car_mng_id(+) " +
				" and nvl(a.car_ext,c.car_ext) = d.nm_cd ";

		if(pay_yn.equals("0"))	query += " and a.exp_dt is null and a.exp_est_dt like '"+cost_ym+"%'";
		if(pay_yn.equals("1"))	query += " and a.exp_dt like '"+cost_ym+"%'";

		if(!car_ext.equals(""))	query += " and a.car_ext='"+car_ext+"'";

		query += " order by c.init_reg_dt, a.car_mng_id";

//System.out.println("[InsDatabase:getExpScdYmList]"+ query);

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
			
			System.out.println("[InsDatabase:getExpScdYmList]"+ e);
			System.out.println("[InsDatabase:getExpScdYmList]"+ query);
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

	//환급자동차세 리스트
	public Vector getExpRtnScdYmList(String req_yn, String rtn_yn, String car_ext)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " select"+
				" a.car_mng_id, nvl(a.car_no,c.car_no) as exp_car_no, c.car_no, decode(c.first_car_no,c.car_no,'',c.first_car_no) first_car_no, a.exp_start_dt, a.exp_end_dt, a.rtn_cau_dt, a.exp_amt, a.rtn_dt, nvl(a.rtn_est_amt,0) rtn_amt,"+
				//" a.exp_est_dt, a.exp_dt, (a.exp_amt-nvl(a.rtn_est_amt,0)) r_exp_amt, a.rtn_req_dt, decode(nvl(a.car_ext,c.car_ext),'1','서울','2','파주','3','부산','4','경남','5','대전','6','포천','7','인천','8','제주','9','광주','10','대구') car_ext_nm, b.client_id"+
				" a.exp_est_dt, a.exp_dt, (a.exp_amt-nvl(a.rtn_est_amt,0)) r_exp_amt, a.rtn_req_dt, d.nm car_ext_nm, b.client_id"+
				" from gen_exp a, car_reg c, sui b, code d"+
				" where "+
				" a.exp_st='3' and d.c_st ='0032' and a.rtn_est_amt>0 and a.car_mng_id=c.car_mng_id and a.car_mng_id=b.car_mng_id(+)"+
				" and nvl(a.car_ext,c.car_ext) = d.nm_cd " ;

		if(req_yn.equals("0"))	query += " and a.rtn_req_dt is null and exp_dt is not null";
		if(req_yn.equals("1"))	query += " and a.rtn_req_dt is not null";

		if(rtn_yn.equals("0"))	query += " and a.rtn_dt is null and exp_dt is not null";
		if(rtn_yn.equals("1"))	query += " and a.rtn_dt is not null";

		if(!car_ext.equals(""))	query += " and a.car_ext='"+car_ext+"'";

		query += " order by c.init_reg_dt, a.car_mng_id";

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
			
			System.out.println("[InsDatabase:getExpRtnScdYmList]"+ e);
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

	//환급자동차세 리스트    20100211-  and a.rtn_amt = 0  >> and a.rtn_amt is null
	public Vector getExpRtnScdReqList(String car_ext)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " select"+
				" a.car_mng_id, a.exp_st,a.exp_est_dt, a.exp_dt, a.car_ext, "+
				" a.car_no, b.car_nm, b.init_reg_dt,"+ 
				" decode(e.cha_dt,'','',e.cha_dt||'[용도변경]-'||e.cha_cau_sub) cha_cont,"+
				" decode(c.migr_dt,'','',c.migr_dt||'[매각]-'||d.firm_nm) sui_cont"+
				" from gen_exp a, car_reg b, sui c, client d, car_change e, car_change f, "+
				"	(select car_mng_id from cont where use_yn='Y' and car_st in ('1','3')) g"+
				" where a.exp_st='3' and substr(a.exp_end_dt,5,4)='1231' and a.rtn_est_amt>0 and a.rtn_amt=0 and a.rtn_req_dt is null and a.rtn_dt is null and a.exp_est_dt<>a.exp_end_dt"+
				" and a.car_mng_id=b.car_mng_id"+
				" and a.car_mng_id=c.car_mng_id(+)"+
				" and c.client_id=d.client_id(+)"+
				" and a.car_mng_id=e.car_mng_id(+) and a.rtn_cau_dt=e.cha_dt(+)"+
				" and e.car_mng_id=f.car_mng_id(+) and e.cha_seq-1=f.cha_seq(+)"+
				" and a.car_mng_id=g.car_mng_id(+)";

		if(!car_ext.equals(""))	query += " and a.car_ext='"+car_ext+"'";

		query += " order by a.rtn_cau, a.rtn_cau_dt";

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
			
			System.out.println("[InsDatabase:getExpRtnScdReqList]"+ e);
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

	//자동차세 이력 리스트
	public Vector getExpCarList(String car_mng_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " select"+
				" exp_start_dt, exp_end_dt, exp_amt, nvl(exp_dt,exp_est_dt) exp_dt, car_no, rtn_cau, rtn_cau_dt, rtn_req_dt, nvl(nvl(rtn_amt,rtn_est_amt),0) rtn_amt, rtn_dt, "+
				" b.nm car_ext_nm,"+
				" decode(rtn_cau,'1','용도변경','2','매각','3','폐차','기타') rtn_cau_nm"+
				" from gen_exp a, code b"+
				" where "+
				" exp_st='3' and a.car_ext = b.nm_cd  and b.c_st='0032' and car_mng_id='"+car_mng_id+"' order by exp_est_dt";



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
			
			System.out.println("[InsDatabase:getExpCarList]"+ e);
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

	//자동차세 등록 점검리스트
	public Vector getExpCheckList(String brch_id, String gubun1, String mode)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String sub_query = "";
		String query = "";
			
		//고지서미접수분
		if(mode.equals("N")){

			sub_query = " select b.car_ext, b.car_no as exp_car_no, b.car_mng_id, 0 as exp_amt, "+
						"			   decode(substr(b.init_reg_dt,1,4),'"+gubun1+"',b.init_reg_dt,'"+gubun1+"0101') as exp_start_dt, "+
						"			   '"+gubun1+"1231' as exp_end_dt,"+
						"			   '"+gubun1+"0131' as exp_est_dt,"+
						"              1 as s_st,"+
						"			   2 e_st,"+
						"			   to_date('"+gubun1+"1231','YYYYMMDD')-to_date(decode(substr(b.init_reg_dt,1,4),'"+gubun1+"',b.init_reg_dt,'"+gubun1+"0101'),'YYYYMMDD')+1 day1,"+
						"			   to_date(substr(decode(substr(b.init_reg_dt,1,4),'"+gubun1+"',b.init_reg_dt,'"+gubun1+"0101'),1,4)||'0630','YYYYMMDD')-to_date(decode(substr(b.init_reg_dt,1,4),'"+gubun1+"',b.init_reg_dt,'"+gubun1+"0101'),'YYYYMMDD')+1 day2,"+
						"			   to_date('"+gubun1+"1231','YYYYMMDD')-to_date(substr(decode(substr(b.init_reg_dt,1,4),'2008',b.init_reg_dt,'"+gubun1+"0101'),1,4)||'0701','YYYYMMDD')+1 day3"+
						"			   from car_reg b, cont c, "+
						"			   (SELECT car_mng_id FROM   gen_exp WHERE  exp_st = '3' AND nvl(rtn_cau_dt,exp_end_dt)='"+gubun1+"1231' GROUP  BY car_mng_id) a, "+  // 20181221 추가
						"			   (select car_mng_id, sum(exp_amt)-sum(nvl(rtn_amt,0)) exp_amt, max(exp_dt) exp_dt, max(rtn_cau_dt) rtn_cau_dt  from gen_exp where exp_st='3' and exp_end_dt like '"+gubun1+"%' group by car_mng_id) d "+  // 20181221 추가
						"			   where"+
						"			   b.car_mng_id=c.car_mng_id and nvl(c.use_yn,'Y')='Y' and c.rent_l_cd not like 'RM%' and nvl(b.prepare,'1') not in ('4','5')"+
						"			   and b.car_mng_id=a.car_mng_id(+)  " +
						"			   AND b.car_mng_id = d.car_mng_id(+) " + // 20181221 추가
						"			   and a.car_mng_id is null ";
		//고지서접수분
		}else{

			sub_query = " select a.car_ext, a.car_no as exp_car_no, a.car_mng_id, a.exp_amt, a.exp_start_dt, a.exp_end_dt, a.exp_est_dt,"+
						" 			   decode(sign(6-to_number(substr(a.exp_start_dt,5,2))),-1,2,1) s_st,"+
						" 			   decode(sign(6-to_number(substr(a.exp_end_dt,5,2))),-1,2,1) e_st,"+
						" 			   to_date(a.exp_end_dt,'YYYYMMDD')-to_date(a.exp_start_dt,'YYYYMMDD')+1 day1,"+
						" 			   to_date(substr(a.exp_start_dt,1,4)||'0630','YYYYMMDD')-to_date(a.exp_start_dt,'YYYYMMDD')+1 day2,"+
						" 			   to_date(a.exp_end_dt,'YYYYMMDD')-to_date(substr(a.exp_start_dt,1,4)||'0701','YYYYMMDD')+1 day3"+
						" 			   from gen_exp a"+
						" 			   where a.exp_st='3' and a.exp_end_dt like '"+gubun1+"%'"+
						"              and a.exp_est_dt is not null and a.exp_dt is null ";

		}


		query = " select"+
				" exp_car_no, client_id, car_mng_id, car_no, car_nm, car_doc_no, init_reg_dt, car_ext, decode(car_use,'1','영업용','자가용') car_use, car_kd, taking_p, dpm, max_kg, car_st, bac_tax,"+
				" r_day1, r_day2, car_per, pay_per,"+
				" car_tax, edu_tax, tot_tax, dlf_tax,"+
				" exp_amt, exp_start_dt, exp_end_dt, exp_est_dt, next_exp_start_dt,"+
				" (to_date(exp_start_dt,'YYYYMMDD')-to_date(next_exp_start_dt,'YYYYMMDD')) dlf_dt,"+
				" decode(sign(to_date(exp_start_dt,'YYYYMMDD')-to_date(next_exp_start_dt,'YYYYMMDD')),-1,'초과',1,'부족') dt_chk"+
				" from"+
				" ("+
				" 	select"+
				" 	exp_car_no, client_id, car_mng_id, car_no, car_nm, car_doc_no, init_reg_dt, car_ext, car_use, car_kd, taking_p, dpm, max_kg, car_st, bac_tax,"+
				" 	r_day1, r_day2, decode(car_use,'2',car_per,0) car_per, pay_per,"+
				" 	trunc(trunc(trunc(account_tax1+account_tax2,-1)*decode(car_use,'2',car_per/100,1),-1)*pay_per/100,-1) as car_tax,"+
				" 	decode(car_use,1,0,decode(car_st,'승합',0,'화물',0,trunc(trunc(trunc(trunc(account_tax1+account_tax2,-1)*decode(car_use,'2',car_per/100,1),-1)*pay_per/100,-1)*0.3,-1))) as edu_tax,"+
				" 	trunc(trunc(trunc(account_tax1+account_tax2,-1)*decode(car_use,'2',car_per/100,1),-1)*pay_per/100,-1)+decode(car_use,1,0,decode(car_st,'승합',0,'화물',0,trunc(trunc(trunc(trunc(account_tax1+account_tax2,-1)*decode(car_use,'2',car_per/100,1),-1)*pay_per/100,-1)*0.3,-1))) as tot_tax,"+
				" 	trunc(trunc(trunc(account_tax1+account_tax2,-1)*decode(car_use,'2',car_per/100,1),-1)*pay_per/100,-1)+decode(car_use,1,0,decode(car_st,'승합',0,'화물',0,trunc(trunc(trunc(trunc(account_tax1+account_tax2,-1)*decode(car_use,'2',car_per/100,1),-1)*pay_per/100,-1)*0.3,-1)))-exp_amt as dlf_tax,"+
				" 	exp_amt, exp_start_dt, exp_end_dt, exp_est_dt, next_exp_start_dt"+
				" 	from"+
				" 	("+
				" 		select"+
				" 		exp_car_no, client_id, car_mng_id, car_no, car_nm, car_doc_no, init_reg_dt, car_ext, car_use, car_kd, taking_p, dpm, max_kg, car_st, bac_tax,"+
				" 		exp_amt, exp_start_dt, exp_end_dt, exp_est_dt, nvl(next_exp_start_dt,init_reg_dt) next_exp_start_dt,"+
				" 		r_day1, r_day2, car_per, pay_per,"+
				" 		decode(car_ext,'1',bac_tax/2/181*r_day1, decode(r_day1,181,bac_tax/2, bac_tax/365*r_day1)) account_tax1,"+
				" 		decode(car_ext,'1',bac_tax/2/184*r_day2, decode(r_day2,184,bac_tax/2, bac_tax/365*r_day2)) account_tax2"+
				" 		from"+
				" 		("+
				" 			select"+
				" 			c.exp_car_no, d.client_id, b.car_mng_id, b.car_no, b.car_nm, b.car_doc_no, b.init_reg_dt, nvl(c.car_ext,b.car_ext) car_ext, b.car_use, b.car_kd, b.taking_p, b.dpm, b.max_kg,"+
				" 			decode(b.taking_p_st,1,'7-9인승',decode(b.car_kd_st,1,'승용',2,'화물',3,'승합')) car_st,"+
				" 			decode(b.car_use,"+
				"				'1', b.dpm*dpm_tax1,"+
				"				'2', decode(b.taking_p_st,"+
				"						1, b.dpm*dpm_tax2*84/100, "+
				"						0, decode(b.car_kd_st,"+
				"								1, b.dpm*dpm_tax2, "+
				"								2, decode(sign(b.max_kg-1000)+sign(b.max_kg-2000)+sign(b.max_kg-3000)+sign(b.max_kg-4000),-4,28500,-3,28500,-2,34500,0,48000,2,63000,4,79500), 3, 65000))) bac_tax,"+
				" 			c.exp_amt, c.exp_start_dt, c.exp_end_dt, c.exp_est_dt,"+
				" 			decode(c.s_st||c.e_st,11, day1, 12, day2, 22, 0   ) r_day1,"+
				" 			decode(c.s_st||c.e_st,11, 0,    12, day3, 22, day1) r_day2,"+
				" 			decode(trunc((to_date(c.exp_end_dt,'YYYYMMDD')-to_date(b.init_reg_dt,'YYYYMMDD'))/365,0),0,100,1,100,2,95,3,90,4,85,5,80,6,75,7,70,8,65,9,60,10,55,11,50,50)  car_per,"+
				" 			decode(c.exp_end_dt,'"+gubun1+"1231',decode(substr(c.exp_est_dt,1,6),'"+gubun1+"01',90,'"+gubun1+"03',92.5,'"+gubun1+"06',95,'"+gubun1+"09',97.5,100),100) pay_per,"+
				"			a.next_exp_start_dt"+
				" 			from"+
				" 			("+sub_query+") c,"+
				" 			(select car_mng_id, car_no, car_nm, dpm, car_doc_no, init_reg_dt, car_use, car_ext, car_kd, taking_p, max_kg,"+
				" 			   decode(sign(dpm-1000)+sign(dpm-1600)+sign(dpm-2000)+sign(dpm-2500),-4,18,-2,18,0,19,2,19,4,24) dpm_tax1,"+
//				" 			   decode(sign(dpm-800)+sign(dpm-1000)+sign(dpm-1600)+sign(dpm-2000),-4,80,-2,100,0,140,2,200,4,220) dpm_tax2,"+
				" 			   decode(sign(dpm-800)+sign(dpm-1000)+sign(dpm-1600)+sign(dpm-2000),-4,80,-2,80,0,140,2,140,4,200) dpm_tax2,"+
				" 			   decode(car_kd,'1',1,'2',1,'3',1,'9',1,'6',2,'7',2,'8',2,'4',3,'5',3,0) car_kd_st,"+
				" 			   decode(taking_p,'7',1,'9',1,'10',1,0) taking_p_st"+
				" 			   from car_reg"+
				" 			) b,"+
				"			(select a.car_mng_id, nvl(a.rtn_cau_dt,to_char(to_date(a.exp_end_dt,'YYYYMMDD')+1,'YYYYMMDD')) next_exp_start_dt"+
				"			   from gen_exp a, (select car_mng_id, max(exp_est_dt) exp_est_dt from gen_exp where exp_st='3' and exp_dt is not null group by car_mng_id) b"+
				"			   where a.exp_st='3' and a.car_mng_id=b.car_mng_id and a.exp_est_dt=b.exp_est_dt"+
				"			) a, sui d"+
				" 			where"+
				" 			c.car_mng_id=b.car_mng_id"+
				" 			and c.car_mng_id=a.car_mng_id(+)"+
				" 			and c.car_mng_id=d.car_mng_id(+)"+
				" 		)"+
				" 	)"+
				" )";

		if(brch_id.equals("S1"))	query += " where car_ext in ('1','2','6','7','8')";
		if(brch_id.equals("B1"))	query += " where car_ext in ('3','4')";
		if(brch_id.equals("D1"))	query += " where car_ext in ('5')";

		if(brch_id.equals("1"))		query += " where car_ext = '1'";
		if(brch_id.equals("2"))		query += " where car_ext = '2'";
		if(brch_id.equals("3"))		query += " where car_ext = '3'";
		if(brch_id.equals("4"))		query += " where car_ext = '4'";
		if(brch_id.equals("5"))		query += " where car_ext = '5'";
		if(brch_id.equals("6"))		query += " where car_ext = '6'";
		if(brch_id.equals("7"))		query += " where car_ext = '7'";
		if(brch_id.equals("8"))		query += " where car_ext = '8'";
		if(brch_id.equals("9"))		query += " where car_ext = '9'";
		if(brch_id.equals("10"))	query += " where car_ext = '10'";

		query += " order by car_ext, car_use, decode(car_st,'승용',1,'7-9인승',2,'승합',3,'화물',4), dpm, max_kg, init_reg_dt";

//System.out.println("getExpCheckList="+sub_query);
//System.out.println("getExpCheckList="+query);

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
			System.out.println("[InsDatabase:getExpCheckList]"+ e);
			System.out.println("[InsDatabase:getExpCheckList]"+ query);
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
	 *	증권번호로 보험료 조회
	 */
	public InsurBean getInsConNoExcelCase(String ins_con_no)
	{
		getConnection();
		InsurBean ins = new InsurBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	"";

		query = " select a.*, b.car_no,\n"+
				" a.ins_exp_dt as ins_start_dt2, to_char(add_months(to_date(a.ins_exp_dt,'YYYYMMDD'),12),'YYYYMMDD') as ins_exp_dt2\n"+
				" from insur a, car_reg b \n"+
				" where \n"+
				" replace(replace(a.ins_con_no,'-',''),' ','')=? and a.car_mng_id=b.car_mng_id";
		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, ins_con_no);
	    	rs = pstmt.executeQuery();
    	
//			System.out.println("[InsDatabase:getInsConNoExcelCase]"+ query);
//			System.out.println("[InsDatabase:getInsConNoExcelCase]"+ ins_con_no);

			if(rs.next())
			{
				ins.setCar_no(rs.getString("CAR_NO")==null?"":rs.getString("CAR_NO"));
				ins.setCar_mng_id(rs.getString("CAR_MNG_ID")==null?"":rs.getString("CAR_MNG_ID"));
				ins.setIns_st(rs.getString("INS_ST")==null?"":rs.getString("INS_ST"));
				ins.setIns_sts(rs.getString("INS_STS")==null?"":rs.getString("INS_STS"));
				ins.setAge_scp(rs.getString("AGE_SCP")==null?"":rs.getString("AGE_SCP"));
				ins.setCar_use(rs.getString("CAR_USE")==null?"":rs.getString("CAR_USE"));
				ins.setIns_com_id(rs.getString("INS_COM_ID")==null?"":rs.getString("INS_COM_ID"));
				ins.setIns_con_no(rs.getString("INS_CON_NO")==null?"":rs.getString("INS_CON_NO"));
				ins.setConr_nm(rs.getString("CONR_NM")==null?"":rs.getString("CONR_NM"));
				ins.setIns_start_dt(rs.getString("INS_START_DT2")==null?"":rs.getString("INS_START_DT2"));
				ins.setIns_exp_dt(rs.getString("INS_EXP_DT2")==null?"":rs.getString("INS_EXP_DT2"));
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
				ins.setReg_cau(rs.getString("REG_CAU")==null?"":rs.getString("REG_CAU"));
				ins.setExp_st(rs.getString("EXP_ST")==null?"":rs.getString("EXP_ST"));
				ins.setAuto_yn(rs.getString("AUTO_YN")==null?"":rs.getString("AUTO_YN"));
				ins.setAbs_yn(rs.getString("ABS_YN")==null?"":rs.getString("ABS_YN"));
				ins.setBlackbox_yn(rs.getString("blackbox_yn")==null?"":rs.getString("blackbox_yn"));
				ins.setVins_share_extra_amt(rs.getInt("vins_share_extra_amt"));
				ins.setVins_blackbox_amt(rs.getInt("vins_blackbox_amt"));
				ins.setVins_blackbox_per(rs.getString("vins_blackbox_per")==null?"":rs.getString("vins_blackbox_per"));
				ins.setCom_emp_yn(rs.getString("com_emp_yn")==null?"":rs.getString("com_emp_yn"));
				ins.setBlackbox_nm(rs.getString("blackbox_nm")==null?"":rs.getString("blackbox_nm"));
				ins.setBlackbox_amt(rs.getInt("blackbox_amt"));
				ins.setBlackbox_no(rs.getString("blackbox_no")==null?"":rs.getString("blackbox_no"));
				ins.setBlackbox_dt(rs.getString("blackbox_dt")==null?"":rs.getString("blackbox_dt"));

			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[InsDatabase:getInsConNoExcelCase]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null)		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ins;
		}
	}

	/**
	 *	증권번호로 보험료 조회
	 */
	public InsurBean getInsConNoExcelCase(String ins_con_no, String car_no)
	{
		getConnection();
		InsurBean ins = new InsurBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	"";

		query = " select a.*, b.car_no,\n"+
				" a.ins_exp_dt as ins_start_dt2, to_char(add_months(to_date(a.ins_exp_dt,'YYYYMMDD'),12),'YYYYMMDD') as ins_exp_dt2\n"+
				" from insur a, car_reg b \n"+
				" where \n"+
				" replace(replace(a.ins_con_no,'-',''),' ','')=? and a.car_mng_id=b.car_mng_id and b.car_no=? ";
		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, ins_con_no);
			pstmt.setString(2, car_no);
	    	rs = pstmt.executeQuery();
    	
//			System.out.println("[InsDatabase:getInsConNoExcelCase]"+ query);
//			System.out.println("[InsDatabase:getInsConNoExcelCase]"+ ins_con_no);

			if(rs.next())
			{
				ins.setCar_no(rs.getString("CAR_NO")==null?"":rs.getString("CAR_NO"));
				ins.setCar_mng_id(rs.getString("CAR_MNG_ID")==null?"":rs.getString("CAR_MNG_ID"));
				ins.setIns_st(rs.getString("INS_ST")==null?"":rs.getString("INS_ST"));
				ins.setIns_sts(rs.getString("INS_STS")==null?"":rs.getString("INS_STS"));
				ins.setAge_scp(rs.getString("AGE_SCP")==null?"":rs.getString("AGE_SCP"));
				ins.setCar_use(rs.getString("CAR_USE")==null?"":rs.getString("CAR_USE"));
				ins.setIns_com_id(rs.getString("INS_COM_ID")==null?"":rs.getString("INS_COM_ID"));
				ins.setIns_con_no(rs.getString("INS_CON_NO")==null?"":rs.getString("INS_CON_NO"));
				ins.setConr_nm(rs.getString("CONR_NM")==null?"":rs.getString("CONR_NM"));
				ins.setIns_start_dt(rs.getString("INS_START_DT2")==null?"":rs.getString("INS_START_DT2"));
				ins.setIns_exp_dt(rs.getString("INS_EXP_DT2")==null?"":rs.getString("INS_EXP_DT2"));
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
				ins.setReg_cau(rs.getString("REG_CAU")==null?"":rs.getString("REG_CAU"));
				ins.setExp_st(rs.getString("EXP_ST")==null?"":rs.getString("EXP_ST"));
				ins.setAuto_yn(rs.getString("AUTO_YN")==null?"":rs.getString("AUTO_YN"));
				ins.setAbs_yn(rs.getString("ABS_YN")==null?"":rs.getString("ABS_YN"));
				ins.setBlackbox_yn(rs.getString("blackbox_yn")==null?"":rs.getString("blackbox_yn"));
				ins.setVins_share_extra_amt(rs.getInt("vins_share_extra_amt"));
				ins.setVins_blackbox_amt(rs.getInt("vins_blackbox_amt"));
				ins.setVins_blackbox_per(rs.getString("vins_blackbox_per")==null?"":rs.getString("vins_blackbox_per"));
				ins.setCom_emp_yn(rs.getString("com_emp_yn")==null?"":rs.getString("com_emp_yn"));
				ins.setBlackbox_nm(rs.getString("blackbox_nm")==null?"":rs.getString("blackbox_nm"));
				ins.setBlackbox_amt(rs.getInt("blackbox_amt"));
				ins.setBlackbox_no(rs.getString("blackbox_no")==null?"":rs.getString("blackbox_no"));
				ins.setBlackbox_dt(rs.getString("blackbox_dt")==null?"":rs.getString("blackbox_dt"));

			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[InsDatabase:getInsConNoExcelCase]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null)		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ins;
		}
	}

	/**
	 *	보험료 조회
	 */
	public InsurBean getInsChkExcelCase(String car_no)
	{
		getConnection();
		InsurBean ins = new InsurBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	"";

		query = " select a.*, b.car_no\n"+
				" from insur a, car_reg b, (select car_mng_id, max(TO_NUMBER(ins_st)) ins_st from insur group by car_mng_id) c \n"+
				" where a.car_mng_id=b.car_mng_id and a.car_mng_id=c.car_mng_id and a.ins_st=c.ins_st \n"+
				" and b.car_no||' '||b.car_num like '%"+car_no+"%'";
		try{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				ins.setCar_no(rs.getString("CAR_NO")==null?"":rs.getString("CAR_NO"));
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
				ins.setReg_cau(rs.getString("REG_CAU")==null?"":rs.getString("REG_CAU"));
				ins.setExp_st(rs.getString("EXP_ST")==null?"":rs.getString("EXP_ST"));
				ins.setAuto_yn(rs.getString("AUTO_YN")==null?"":rs.getString("AUTO_YN"));
				ins.setAbs_yn(rs.getString("ABS_YN")==null?"":rs.getString("ABS_YN"));
				ins.setBlackbox_yn(rs.getString("blackbox_yn")==null?"":rs.getString("blackbox_yn"));
				ins.setVins_share_extra_amt(rs.getInt("vins_share_extra_amt"));
				ins.setVins_blackbox_amt(rs.getInt("vins_blackbox_amt"));
				ins.setVins_blackbox_per(rs.getString("vins_blackbox_per")==null?"":rs.getString("vins_blackbox_per"));
				ins.setCom_emp_yn(rs.getString("com_emp_yn")==null?"":rs.getString("com_emp_yn"));
				ins.setBlackbox_nm(rs.getString("blackbox_nm")==null?"":rs.getString("blackbox_nm"));
				ins.setBlackbox_amt(rs.getInt("blackbox_amt"));
				ins.setBlackbox_no(rs.getString("blackbox_no")==null?"":rs.getString("blackbox_no"));
				ins.setBlackbox_dt(rs.getString("blackbox_dt")==null?"":rs.getString("blackbox_dt"));

			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[InsDatabase:getInsChkExcelCase]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null)		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ins;
		}
	}

	//중복입력 체크
	public int getCheckInsExcelInsTask(InsurExcelBean ins)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		String query = "";

		query = " select count(*) cnt from ins_excel"+
				" where value01 = ?"+
				" and value07 = ?"+
				" and value08 = ?"+
				" and value09 = ?"+
				" and value10 = ?"+
				" and value11 = ?"+
				" and value12 = ?"+
				" and gubun is null";
				
		
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, ins.getValue01());
			pstmt.setString(2, ins.getValue07());
			pstmt.setString(3, ins.getValue08());
			pstmt.setString(4, ins.getValue09());
			pstmt.setString(5, ins.getValue10());
			pstmt.setString(6, ins.getValue11());
			pstmt.setString(7, ins.getValue12());
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			if(rs.next())
			{				
				count = rs.getInt(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[InsDatabase:getCheckInsExcelInsTask(InsurExcelBean ins)]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null)		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}	
	
	//중복입력 체크
	public int getCheckOverInsDt(String car_no, String ins_start_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		String query = "";

		query = " select count(*) cnt from insur"+
				" where car_mng_id in ( select car_mng_id from car_reg where car_no||' '||car_num like '%"+car_no+"%' )"+
				" and ins_sts='1' and replace(ins_start_dt,'-','')=replace('"+ins_start_dt+"','-','')";
		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			if(rs.next())
			{				
				count = rs.getInt(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[InsDatabase:getCheckOverInsDt(String car_no, String ins_start_dt)]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null)		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}	

	//보험가입현황
	public Vector getInsureStatList(String s_kd, String t_wd, String gubun1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" c.car_no 차량번호,"+
				" e.s_st 차종소분류, e.JG_CODE 현차종코드, e.sh_code 구차종코드,"+
				" c.car_nm 차명, "+
				" DECODE(c.init_reg_dt,  '','',SUBSTR(c.init_reg_dt,1,4)||'-'||SUBSTR(c.init_reg_dt,5,2)||'-'||SUBSTR(c.init_reg_dt,7,2)) as 최초등록일,"+
				" decode(b.air_ds_yn,'Y',1,0)+decode(b.air_as_yn,'Y',1,0) 에어백,"+
				" b.con_f_nm 피보험자,"+
				" decode(b.car_use,'1','영업용','2','업무용','3','개인용') 보험종류,"+
				" decode(b.age_scp,'1','21세이상','2','26세이상','3','모든운전자','4','24세이상','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하') 연령범위,"+
				" decode(b.vins_gcp_kd,'1','3000만원','2','1500만원',  '3','1억원',   '4','5000만원','5','1000만원','6','5억원', '7','2억원', '8','3억원','9','10억원','미가입') 대물배상,"+
				" decode(b.vins_bacdt_kd,'1','3억원',   '2','1억5천만원','3','3000만원','4','1500만원','5','5000만원','6','1억원','미가입') 자기신체사고_사망장애,"+
				" decode(b.vins_bacdt_kc2,'1','3억원',   '2','1억5천만원','3','3000만원','4','1500만원','5','5000만원','6','1억원','미가입') 자기신체사고_부상,"+
				" decode(b.vins_cacdt_car_amt,0,'',b.vins_cacdt_car_amt||'만원') 자차차량,"+
				" decode(b.vins_cacdt_me_amt,0,'',b.vins_cacdt_me_amt||'만원') 자차자기부담금,"+
				" DECODE(b.ins_start_dt,'','',SUBSTR(b.ins_start_dt,1,4)||'-'||SUBSTR(b.ins_start_dt,5,2)||'-'||SUBSTR(b.ins_start_dt,7,2)) as 보험시작일,"+
				" DECODE(b.ins_exp_dt,  '','',SUBSTR(b.ins_exp_dt,1,4)||'-'||SUBSTR(b.ins_exp_dt,5,2)||'-'||SUBSTR(b.ins_exp_dt,7,2)) as 보험만료일,"+
				" b.rins_pcp_amt 대인1,"+
				" b.vins_pcp_amt 대인2,"+
				" b.vins_gcp_amt 대물,"+
				" b.vins_bacdt_amt 자손,"+
				" b.vins_canoisr_amt 무보험,"+
				" b.vins_share_extra_amt 분담금,"+
				" b.vins_cacdt_cm_amt 자차,"+
				" b.vins_spe_amt 특약,"+
				" (b.rins_pcp_amt+b.vins_pcp_amt+b.vins_gcp_amt+b.vins_bacdt_amt+b.vins_canoisr_amt+b.vins_share_extra_amt+b.vins_cacdt_cm_amt+b.vins_spe_amt) 총보험료"+//-b.vins_blackbox_amt
				" from"+
				"     (select * from cont    where nvl(use_yn,'Y')='Y' and rent_l_cd not like 'RM%'                       ) a,"+
				"     (select * from car_reg where nvl(prepare,'0')<>'4'                                     ) c,"+
				"     (select * from insur   where ins_sts='1' and ins_exp_dt>= to_char(sysdate,'YYYYMMDD')  ) b,"+
				"     car_etc d, car_nm e"+
				" where"+
				" a.car_mng_id=c.car_mng_id"+
				" and a.car_mng_id=b.car_mng_id(+)"+
				" and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd"+
				" and d.car_id=e.car_id and d.car_seq=e.car_seq";

		String search = "";
		String what = "";

		if(gubun1.equals("1"))		query += " and b.car_use='1'";
		else if(gubun1.equals("2"))	query += " and b.car_use='2'";


		if(s_kd.equals("1"))	what = "upper(nvl(c.car_nm||e.car_name, ' '))";
			
		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	
		
		query += " order by b.ins_exp_dt";

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
			System.out.println("[InsDatabase:getInsureStatList]\n"+e);
			System.out.println("[InsDatabase:getInsureStatList]\n"+query);
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

	//보험사별보험료 월별 현황
	public Vector getInsurScdComAmtStat(String brch_id, String gubun1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " select"+
				" substr(dt,5,2) as ym, ins_com_id,"+
				" sum(reg_cnt) reg_cnt0,"+
				" sum(reg_amt) reg_amt0,"+
				" sum(decode(car_use,'1',reg_cnt)) reg_cnt1,"+
				" sum(decode(car_use,'1',reg_amt)) reg_amt1,"+
				" sum(decode(car_use,'1',0,reg_cnt)) reg_cnt2,"+
				" nvl(sum(decode(car_use,'1',0,reg_amt)),0) reg_amt2,"+
				" sum(scd_amt) scd_amt0,"+
				" sum(decode(car_use,'1',scd_amt)) scd_amt1,"+
				" nvl(sum(decode(car_use,'1',0,scd_amt)),0) scd_amt2,"+
				" sum(pay_amt) pay_amt0,"+
				" sum(decode(car_use,'1',pay_amt)) pay_amt1,"+
				" nvl(sum(decode(car_use,'1',0,pay_amt)),0) pay_amt2"+
				" from"+
				" ("+                                           //count(decode(a.ins_tm,'1',a.ins_st,'')) reg_cnt -> count(0) reg_cnt
				"     select '1' st, b.ins_com_id, substr(nvl(b.ins_rent_dt,b.ins_start_dt),1,6) as dt, b.car_use, count(0) reg_cnt, 0 scd_cnt,        sum(decode(a.ins_tm2,'2',-a.pay_amt,a.pay_amt)) reg_amt, 0 pay_amt, 0 scd_amt from scd_ins a, insur b where a.ins_tm2='0' and a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st and nvl(b.ins_rent_dt,b.ins_start_dt) like '"+gubun1+"%' group by b.ins_com_id, substr(nvl(b.ins_rent_dt,b.ins_start_dt),1,6), b.car_use"+
				"     union"+
				"     select '1' st, b.ins_com_id, substr(nvl(c.ch_dt,a.pay_dt),1,6)             as dt, b.car_use, count(0) reg_cnt, 0 scd_cnt,        sum(decode(a.ins_tm2,'2',-a.pay_amt,a.pay_amt)) reg_amt, 0 pay_amt, 0 scd_amt from scd_ins a, insur b, ins_change c      where a.ins_tm2='1' and a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st and a.car_mng_id=c.car_mng_id(+) and a.ins_st=c.ins_st(+) and a.ch_tm=c.ch_tm(+) and nvl(c.ch_dt,a.pay_dt) like '"+gubun1+"%' group by b.ins_com_id, substr(nvl(c.ch_dt,a.pay_dt),1,6), b.car_use"+
				"     union"+
				"     select '1' st, b.ins_com_id, substr(nvl(c.req_dt,a.pay_dt),1,6)            as dt, b.car_use, count(0) reg_cnt, 0 scd_cnt,        sum(decode(a.ins_tm2,'2',-a.pay_amt,a.pay_amt)) reg_amt, 0 pay_amt, 0 scd_amt from scd_ins a, insur b, ins_cls c         where a.ins_tm2='2' and a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st and a.car_mng_id=c.car_mng_id(+) and a.ins_st=c.ins_st(+)                     and nvl(c.req_dt,a.pay_dt) like '"+gubun1+"%' group by b.ins_com_id, substr(nvl(c.req_dt,a.pay_dt),1,6), b.car_use"+
				"     union"+
				"     select '2' st, b.ins_com_id, substr(a.pay_dt,1,6)                          as dt, b.car_use, 0 reg_cnt,        count(0) scd_cnt, 0 reg_amt, sum(decode(a.ins_tm2,'2',-a.pay_amt,a.pay_amt)) pay_amt, 0 scd_amt                                from scd_ins a, insur b                    where a.pay_dt is not null and a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st and a.pay_dt like '"+gubun1+"%' group by b.ins_com_id, substr(a.pay_dt,1,6), b.car_use"+
				"     union"+
				"     select '3' st, b.ins_com_id, substr(a.ins_est_dt,1,6)                      as dt, b.car_use, 0 reg_cnt,        count(0) scd_cnt, 0 reg_amt, 0 pay_amt, sum(decode(a.ins_tm2,'2',-a.pay_amt,a.pay_amt)) scd_amt                                from scd_ins a, insur b                    where a.pay_dt is null and a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st and a.ins_est_dt like '"+gubun1+"%' group by b.ins_com_id, substr(a.ins_est_dt,1,6), b.car_use"+
				" )"+
				" group by dt, ins_com_id"+
				" order by dt, decode(ins_com_id,'0038','1','0008','2','0007','3','4')";

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
			
			System.out.println("[InsDatabase:getInsurScdComAmtStat]"+ e);
			System.out.println("[InsDatabase:getInsurScdComAmtStat]"+ query);
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

	//조건별 보험가입현황
	public Vector getInsureStatSearchList(String mode)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String query2 = "";
		if(mode.equals("cust")) {query2 = "  b.conr_nm 계약자, \n  ";}
		query = " select \n"+
				" c.car_no 차량번호, \n"+
				" e.s_st 차종소분류, e.JG_CODE 현차종코드, e.sh_code 구차종코드, \n"+
				" c.car_nm 차명,  \n"+
				" DECODE(c.init_reg_dt,  '','',SUBSTR(c.init_reg_dt,1,4)||'-'||SUBSTR(c.init_reg_dt,5,2)||'-'||SUBSTR(c.init_reg_dt,7,2)) as 최초등록일, \n"+
				" decode(b.air_ds_yn,'Y',1,0)+decode(b.air_as_yn,'Y',1,0) 에어백, \n"+
				" b.con_f_nm 피보험자, \n"+query2+
				" decode(b.car_use,'1','영업용','2','업무용','3','개인용') 보험종류, \n"+
				" decode(b.age_scp,'1','21세이상','2','26세이상','3','모든운전자','4','24세이상','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하') 연령범위, \n"+
				" decode(b.vins_gcp_kd,'1','3000만원','2','1500만원',  '3','1억원',   '4','5000만원','5','1000만원','6','5억원', '7','2억원', '8','3억원','9','10억원', '미가입') 대물배상, \n"+
				" decode(b.vins_bacdt_kd,'1','3억원',   '2','1억5천만원','3','3000만원','4','1500만원','5','5000만원','6','1억원','미가입') 자기신체사고_사망장애, \n"+
				" decode(b.vins_bacdt_kc2,'1','3억원',   '2','1억5천만원','3','3000만원','4','1500만원','5','5000만원','6','1억원','미가입') 자기신체사고_부상, \n"+
				" decode(b.vins_cacdt_car_amt,0,'',b.vins_cacdt_car_amt||'만원') 자차차량, \n"+
				" decode(b.vins_cacdt_me_amt,0,'',b.vins_cacdt_me_amt||'만원') 자차자기부담금, \n"+
				" DECODE(b.ins_start_dt,'','',SUBSTR(b.ins_start_dt,1,4)||'-'||SUBSTR(b.ins_start_dt,5,2)||'-'||SUBSTR(b.ins_start_dt,7,2)) as 보험시작일, \n"+
				" DECODE(b.ins_exp_dt,  '','',SUBSTR(b.ins_exp_dt,1,4)||'-'||SUBSTR(b.ins_exp_dt,5,2)||'-'||SUBSTR(b.ins_exp_dt,7,2)) as 보험만료일, \n"+
				" b.rins_pcp_amt 대인1, \n"+
				" b.vins_pcp_amt 대인2, \n"+
				" b.vins_gcp_amt 대물, \n"+
				" b.vins_bacdt_amt 자손, \n"+
				" b.vins_canoisr_amt 무보험, \n"+
				" b.vins_share_extra_amt 분담금,"+
				" b.vins_cacdt_cm_amt 자차, \n"+
				" b.vins_spe_amt 특약, \n"+
				" b.vins_blackbox_amt 블랙박스할인, \n"+
				" (b.rins_pcp_amt+b.vins_pcp_amt+b.vins_gcp_amt+b.vins_bacdt_amt+b.vins_canoisr_amt+b.vins_share_extra_amt+b.vins_cacdt_cm_amt+b.vins_spe_amt) 총보험료, \n"+//-b.vins_blackbox_amt
				" f.ins_com_nm 보험사, \n"+
				" g.user_nm 담당자, \n"+
				" h.cont_dt 매매일자, \n"+
				" c.taking_p, b.age_scp, e.s_st  \n"+
				" from \n"+
				"     (select * from cont    where nvl(use_yn,'Y')='Y' and rent_l_cd not like 'RM%'                       ) a, \n"+
				"     (select * from car_reg where nvl(prepare,'0')<>'4'                                     ) c, \n"+
				"     (select * from insur   where ins_sts='1' and ins_exp_dt>= to_char(sysdate,'YYYYMMDD')  ) b, \n"+
				"     car_etc d, car_nm e, ins_com f, users g, sui h,  \n"+
				"     (select car_mng_id, min(cust_id) cust_id from rent_cont where use_st='2' and rent_st='4' and cust_st='4' group by car_mng_id ) i \n"+
				" where \n"+
				" a.car_mng_id=c.car_mng_id \n"+
				" and a.car_mng_id=b.car_mng_id(+) \n"+
				" and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd \n"+
				" and d.car_id=e.car_id and d.car_seq=e.car_seq and b.ins_com_id=f.ins_com_id \n"+
				" and decode('"+mode+"','scar',i.cust_id,nvl(a.mng_id,a.bus_id2))=g.user_id  \n"+
				" and a.car_mng_id=h.car_mng_id(+)  \n"+
				" and a.car_mng_id=i.car_mng_id(+)  \n"+
				" ";

		if(mode.equals("ins_kd_2")) 		query += " and b.ins_kd='2'";

		if(mode.equals("ins_age_21")) 		query += " and b.age_scp='1'";

		if(mode.equals("ins_age_24")) 		query += " and b.age_scp='4'";

		if(mode.equals("cust")) 			query += " and b.con_f_nm not like '%아마존카%'";

		if(mode.equals("cacdt")) 			query += " and b.vins_cacdt_cm_amt > 0";

		if(mode.equals("spe")) 				query += " and b.vins_spe_amt > 0";

		if(mode.equals("scar")) 			query += " and i.car_mng_id is not null";

		if(mode.equals("ins_gcp")) 			query += " and b.vins_gcp_kd in ('6','7','8')";

		if(mode.equals("ins_age_taking")){

			String b_query = query;	

			b_query += " and c.car_use='1' ";

			query = " select DECODE(sign(taking_p-6),1,1,0) taking, age_scp age, COUNT(*) cnt \n"+
					" from   ("+b_query+") \n"+
					" GROUP BY DECODE(sign(taking_p-6),1,1,0), age_scp \n"+
					" ORDER BY DECODE(sign(taking_p-6),1,1,0), age_scp \n";

		}else if(mode.equals("ins_age_taking2")){

			String b_query = query;	
			String b_query2 = "";	

			b_query += " and c.car_use='2' ";


			b_query2 = " select "+
					"        case when s_st in ('100','101','409') then '경승용' when s_st in ('801','802','803','811','821') then '화물' else '승용' end as s_st,  \n"+
 				    "        DECODE(sign(taking_p-6),1,1,0) taking, "+
					"        decode(age_scp,'1','21세이상','2','26세이상','3','모든운전자','4','24세이상','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하') age, "+
                    "        COUNT(*) cnt "+
					" from   ("+b_query+") \n"+
					" GROUP BY "+
					"          case when s_st in ('100','101','409') then '경승용' when s_st in ('801','802','803','811','821') then '화물' else '승용' end, "+
					"          DECODE(sign(taking_p-6),1,1,0), "+
					"          decode(age_scp,'1','21세이상','2','26세이상','3','모든운전자','4','24세이상','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하') \n"+
					" ";

			query = " select * \n"+
					" from   ("+b_query2+") \n"+
					" ORDER BY s_st \n";


		}else{
			query += " order by b.ins_exp_dt";
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

//			System.out.println("[InsDatabase:getInsureStatKd2List]\n"+query);
		} catch (SQLException e) {
			System.out.println("[InsDatabase:getInsureStatKd2List]\n"+e);
			System.out.println("[InsDatabase:getInsureStatKd2List]\n"+query);
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

	//자동차 특소세 이력 리스트
	public Vector getTaxLcCarList(String car_mng_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " select decode(a.car_st,'1','렌트','2','예비','3','리스','4','월렌트','5','업무대여') car_st, a.firm_nm, a.dlv_dt, a.rent_start_dt, a.rent_end_dt, c.cls_dt,"+
				" decode(a.car_st,'2',0,trunc(months_between(to_date(nvl(c.cls_dt,to_char(sysdate,'YYYY-MM-DD')),'YYYY-MM-DD'),(to_date(nvl(a.rent_start_dt,dlv_dt),'YYYY-MM-DD')+1)),0)) mon"+
				" from cont_n_view a , cls_cont c "+
				" where a.rent_mng_id = c.rent_mng_id(+) and a.rent_l_cd= c.rent_l_cd(+) and a.car_mng_id='"+car_mng_id+"' order by a.reg_dt";


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
			
			System.out.println("[InsDatabase:getTaxLcCarList]"+ e);
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

	//자동차 특소세 이력 리스트
	public Vector getTaxScCarList(String car_mng_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " select"+
				" decode(a.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','장기대기','12','월렌트') rent_st,"+
				" decode(a.cust_st,'1',b.firm_nm,c.user_nm) firm_nm, a.deli_dt, a.ret_dt,"+
				" trunc(to_date(substr(a.ret_dt,1,8),'YYYYMMDD')-(to_date(substr(a.deli_dt,1,8),'YYYYMMDD')+1),0) day"+
				" from rent_cont a, client b, users c"+
				" where a.car_mng_id='"+car_mng_id+"' and a.ret_dt is not null and a.use_st<>'5'"+
				" and a.cust_id=b.client_id(+)"+
				" and a.cust_id=c.user_id(+)"+
				" order by a.deli_dt";


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
			
			System.out.println("[InsDatabase:getTaxScCarList]"+ e);
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

	//기간비용 월별리스트
	public Vector getInsurPrecostYmChkList(String cost_ym, String cost_st, String car_use, String com_id, String chk_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					

		query = " select \n"+
				"        c.car_no, decode(c.first_car_no,c.car_no,'',c.first_car_no) first_car_no, b.ins_start_dt, b.ins_exp_dt, b.tot_days, b.tot_amt, \n"+
				"        (b.tot_days-a.rest_day-a.cost_day) bm_day, \n"+
				"        (b.tot_amt-a.rest_amt-a.cost_amt) bm_amt, \n"+
				"        a.cost_day, a.cost_amt, a.rest_day, a.rest_amt, e.ins_com_nm,\n"+
				"        to_date(b.ins_exp_dt,'YYYYMMDD')-to_date(a.cost_ym||to_char(last_day(to_date(a.cost_ym,'YYYYMM')),'DD'),'YYYYMMDD')-1 as chk_rest_day, \n"+
				"        trunc(b.tot_amt/b.tot_days*(to_date(b.ins_exp_dt,'YYYYMMDD')-to_date(a.cost_ym||to_char(last_day(to_date(a.cost_ym,'YYYYMM')),'DD'),'YYYYMMDD')-1),0) as chk_rest_amt, \n"+
				"        a.rest_amt-trunc(b.tot_amt/b.tot_days*(to_date(b.ins_exp_dt,'YYYYMMDD')-to_date(a.cost_ym||to_char(last_day(to_date(a.cost_ym,'YYYYMM')),'DD'),'YYYYMMDD')-1),0) as chk_rest_cha_amt \n"+
				" from   precost a, car_reg c, \n"+
				"        (  select car_mng_id, ins_st, ins_start_dt, ins_exp_dt, car_use, ins_com_id, \n"+
				"                  to_date(ins_exp_dt,'YYYYMMDD')-to_date(ins_start_dt,'YYYYMMDD') as tot_days, \n"+
				"                  (rins_pcp_amt+vins_pcp_amt+vins_gcp_amt+vins_bacdt_amt+vins_canoisr_amt+vins_share_extra_amt+vins_cacdt_cm_amt+vins_spe_amt) tot_amt \n"+//-vins_blackbox_amt
				"           from insur) b, \n"+
				"        ins_com e"+
				" where \n"+
				"        a.cost_st='2' and a.cost_amt>0 \n"+
				"        and a.car_mng_id=c.car_mng_id \n"+
				"        and a.car_mng_id=b.car_mng_id and a.cost_id=b.ins_st and b.ins_com_id=e.ins_com_id\n"+
				"        and a.cost_ym='"+cost_ym+"' \n"+
				"        and rest_amt>0 \n";

		if(chk_st.equals("1")){
			query +="        /*당월해지*/ \n"+
					"        and b.ins_exp_dt like ,1,6)=a.cost_ym \n";
		}else if(chk_st.equals("2")){
			query +="        /*해지일자 경과*/ \n"+
					"        and substr(b.ins_exp_dt,1,6)<a.cost_ym \n";
		}else if(chk_st.equals("3")){
			query +="        /*정상적인 경우*/ \n"+
					"        and substr(b.ins_exp_dt,1,6)>a.cost_ym \n"+
					"        and (a.rest_amt-trunc(b.tot_amt/b.tot_days*(to_date(b.ins_exp_dt,'YYYYMMDD')-to_date(a.cost_ym||to_char(last_day(to_date(a.cost_ym,'YYYYMM')),'DD'),'YYYYMMDD')-1),0)) > 10000 \n"+
//					"        and (b.tot_amt-(b.tot_amt-a.rest_amt-a.cost_amt)-a.cost_amt-a.rest_amt) > 0 \n"+
					"        --and a.rest_day-(to_date(b.ins_exp_dt,'YYYYMMDD')-to_date(a.cost_ym||to_char(last_day(to_date(a.cost_ym,'YYYYMM')),'DD'),'YYYYMMDD')-1) > 2 \n"+
					" ";
		}

		if(!car_use.equals("")) query += " and decode(b.car_use,'3','2',b.car_use)='"+car_use+"'";

		if(!com_id.equals("")) query += " and b.ins_com_id='"+com_id+"'";

		query += " order by b.ins_exp_dt";


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
			System.out.println("[InsDatabase:getInsurPrecostYmChkList]"+ e);
			System.out.println("[InsDatabase:getInsurPrecostYmChkList]"+ query);
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
	 *	보험삭제
	 */
	public boolean deleteInsur(String c_id, String ins_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		PreparedStatement pstmt4 = null;
		PreparedStatement pstmt5 = null;
		boolean flag = true;

		String query1 = " delete from insur      where car_mng_id=? and ins_st=?";
		String query2 = " delete from ins_change where car_mng_id=? and ins_st=?";
		String query3 = " delete from ins_cls    where car_mng_id=? and ins_st=?";
		String query4 = " delete from scd_ins    where car_mng_id=? and ins_st=?";
		String query5 = " delete from precost    where car_mng_id=? and cost_id=? and cost_st='2'";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query1);
			pstmt.setString(1, c_id);
			pstmt.setString(2, ins_st);
		    pstmt.executeUpdate();
			pstmt.close();

			pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString(1, c_id);
			pstmt2.setString(2, ins_st);
		    pstmt2.executeUpdate();
			pstmt2.close();

			pstmt3 = conn.prepareStatement(query3);
			pstmt3.setString(1, c_id);
			pstmt3.setString(2, ins_st);
		    pstmt3.executeUpdate();
			pstmt3.close();

			pstmt4 = conn.prepareStatement(query4);
			pstmt4.setString(1, c_id);
			pstmt4.setString(2, ins_st);
		    pstmt4.executeUpdate();
			pstmt4.close();

			pstmt5 = conn.prepareStatement(query5);
			pstmt5.setString(1, c_id);
			pstmt5.setString(2, ins_st);
		    pstmt5.executeUpdate();
			pstmt5.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[InsDatabase:deleteInsur]"+ e);
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();			
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
				if(pstmt2 != null)	pstmt2.close();
				if(pstmt3 != null)	pstmt3.close();
				if(pstmt4 != null)	pstmt4.close();
				if(pstmt5 != null)	pstmt5.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}	

	//기간비용 월별리스트
	public Vector getInsurPrecostYmSettleChkList(String cost_ym, String cost_st, String car_use, String com_id, String chk_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " select"+
				"        c.car_no, c.FIRST_CAR_NO, b.car_mng_id, b.ins_st, b.ins_start_dt, b.ins_exp_dt,"+
				"        (b.rins_pcp_amt+b.vins_pcp_amt+b.vins_gcp_amt+b.vins_bacdt_amt+b.vins_canoisr_amt+b.vins_share_extra_amt+b.vins_cacdt_cm_amt+b.vins_spe_amt) tot_amt,"+//-b.vins_blackbox_amt
				"        d.cost_amt as t_cost_amt,"+
				"        (b.rins_pcp_amt+b.vins_pcp_amt+b.vins_gcp_amt+b.vins_bacdt_amt+b.vins_canoisr_amt+b.vins_share_extra_amt+b.vins_cacdt_cm_amt+b.vins_spe_amt-a.pay_amt) chk_amt1,"+//-b.vins_blackbox_amt
				"        (b.rins_pcp_amt+b.vins_pcp_amt+b.vins_gcp_amt+b.vins_bacdt_amt+b.vins_canoisr_amt+b.vins_share_extra_amt+b.vins_cacdt_cm_amt+b.vins_spe_amt-a.pay_amt-d.cost_amt) chk_amt2,"+//-b.vins_blackbox_amt
				"        a.pay_dt, a.pay_amt,"+
				"        e.*"+
				" from   scd_ins a, insur b, car_reg c,"+
				"        (select car_mng_id, cost_id, sum(cost_amt) cost_amt from precost where cost_st='2' group by car_mng_id, cost_id) d,"+
				"        (select * from precost where cost_st='2') e"+
				" where  a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st"+
				"        and a.car_mng_id=c.car_mng_id"+
				"        and a.car_mng_id=d.car_mng_id and a.ins_st=d.cost_id"+
				"        and a.car_mng_id=e.car_mng_id and a.ins_st=e.cost_id and substr(b.ins_exp_dt,1,6)=e.cost_ym"+
				"        and a.ins_tm2='2' and a.pay_dt is not null"+
				"        and b.INS_EXP_DT like '"+cost_ym+"%' \n"+
				" order by a.pay_dt";


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
			System.out.println("[InsDatabase:getInsurPrecostYmSettleChkList]"+ e);
			System.out.println("[InsDatabase:getInsurPrecostYmSettleChkList]"+ query);
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

	//기간비용 월별리스트
	public Vector getInsurPrecostYmCngChkList(String cost_ym, String cost_st, String car_use, String com_id, String chk_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " 		select"+
				"        c.car_no, c.FIRST_CAR_NO, b.ins_st, b.ins_start_dt, b.ins_exp_dt,"+
				"        (b.rins_pcp_amt+b.vins_pcp_amt+b.vins_gcp_amt+b.vins_bacdt_amt+b.vins_canoisr_amt+b.vins_share_extra_amt+b.vins_cacdt_cm_amt+b.vins_spe_amt) tot_amt,"+//-b.vins_blackbox_amt
				"        d.ch_amt, d.ch_dt,"+
				"        f.cost_amt as t_cost_amt,"+
				"        (b.rins_pcp_amt+b.vins_pcp_amt+b.vins_gcp_amt+b.vins_bacdt_amt+b.vins_canoisr_amt+b.vins_share_extra_amt+b.vins_cacdt_cm_amt+b.vins_spe_amt+a.pay_amt) chk_amt1,"+//-b.vins_blackbox_amt
				"        (b.rins_pcp_amt+b.vins_pcp_amt+b.vins_gcp_amt+b.vins_bacdt_amt+b.vins_canoisr_amt+b.vins_share_extra_amt+b.vins_cacdt_cm_amt+b.vins_spe_amt-f.cost_amt) chk_amt2,"+//-b.vins_blackbox_amt
				"        a.pay_dt, a.pay_amt,"+
				"        e.*"+
				" from   scd_ins a, insur b, car_reg c, ins_change d,"+
				"        (select * from precost where cost_st='2') e,"+
				"        (select car_mng_id, cost_id, sum(cost_amt) cost_amt from precost where cost_st='2' group by car_mng_id, cost_id) f"+
				" where  a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st"+
				"        and a.car_mng_id=c.car_mng_id"+
				"        and a.car_mng_id=d.car_mng_id and a.ins_st=d.ins_st"+
				"        and a.car_mng_id=e.car_mng_id and a.ins_st=e.cost_id and substr(d.ch_dt,1,6)=e.cost_ym"+
				"        and a.ch_tm=d.ch_tm"+
				"        and a.car_mng_id=f.car_mng_id and a.ins_st=f.cost_id"+
				"        and d.ch_dt like '"+cost_ym+"%'"+
				"        and substr(b.ins_start_dt,5,4)=substr(b.ins_exp_dt,5,4) \n";


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
			System.out.println("[InsDatabase:getInsurPrecostYmCngChkList]"+ e);
			System.out.println("[InsDatabase:getInsurPrecostYmCngChkList]"+ query);
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
	public InsurScdBean getInsExcelScdCase(String ins_con_no, String ins_est_dt, int pay_amt)
	{
		getConnection();
		InsurScdBean scd = new InsurScdBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " select b.*"+
				" from insur a, scd_ins b"+
				" where replace(replace(a.ins_con_no,'-',''),' ','')=? and b.pay_yn='0'"+
				" and a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st"+
				" and b.ins_est_dt=replace(?,'-','') and decode(b.ins_tm2,'2',-b.pay_amt,b.pay_amt)=?"+
				"  ";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, ins_con_no);
			pstmt.setString(2, ins_est_dt);
			pstmt.setInt   (3, pay_amt);

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
				scd.setIns_tm2(rs.getString("INS_TM2")==null?"":rs.getString("INS_TM2"));
				scd.setR_ins_est_dt(rs.getString("R_INS_EST_DT")==null?"":rs.getString("R_INS_EST_DT"));
				scd.setCh_tm(rs.getString("CH_TM")==null?"":rs.getString("CH_TM"));
				scd.setExcel_chk(rs.getString("EXCEL_CHK")==null?"":rs.getString("EXCEL_CHK"));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[InsDatabase:getInsExcelScdCase]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null)		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return scd;
		}
	}	

	/**
	 *	보험계약별 스케줄 리스트 조회 : con_ins_u.jsp
	 */
	public InsurScdBean getInsExcelScdPayCase(String ins_con_no, String pay_dt, int pay_amt)
	{
		getConnection();
		InsurScdBean scd = new InsurScdBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " select b.*"+
				" from insur a, scd_ins b"+
				" where replace(replace(a.ins_con_no,'-',''),' ','')=? "+
				" and a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st"+
				" and b.pay_dt=replace(?,'-','') and decode(b.ins_tm2,'2',-b.pay_amt,b.pay_amt)=?"+
				"  ";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, ins_con_no);
			pstmt.setString(2, pay_dt);
			pstmt.setInt   (3, pay_amt);

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
				scd.setIns_tm2(rs.getString("INS_TM2")==null?"":rs.getString("INS_TM2"));
				scd.setR_ins_est_dt(rs.getString("R_INS_EST_DT")==null?"":rs.getString("R_INS_EST_DT"));
				scd.setCh_tm(rs.getString("CH_TM")==null?"":rs.getString("CH_TM"));
				scd.setExcel_chk(rs.getString("EXCEL_CHK")==null?"":rs.getString("EXCEL_CHK"));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[InsDatabase:getInsExcelScdPayCase]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null)		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return scd;
		}
	}	

	/**
	 *	보험계약별 스케줄 리스트 조회 : con_ins_u.jsp
	 */
	public InsurScdBean getInsExcelScdAmtCase(String ins_con_no, String ins_est_dt)
	{
		getConnection();
		InsurScdBean scd = new InsurScdBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " select sum(decode(b.ins_tm2,'2',-b.pay_amt,b.pay_amt)) pay_amt"+
				" from insur a, scd_ins b"+
				" where replace(replace(a.ins_con_no,'-',''),' ','')=?"+
				" and a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st"+
				" and b.ins_est_dt=replace(?,'-','') "+
				"  ";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, ins_con_no);
			pstmt.setString(2, ins_est_dt);

	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{
				scd.setPay_amt(rs.getInt("PAY_AMT"));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[InsDatabase:getInsExcelScdAmtCase]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null)		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return scd;
		}
	}	

	//납부보험료 일별 리스트
	public Vector getInsurPrecostYmChkDayList(String cost_ym, String car_use, String com_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		String sub_query = "";

		if(car_use.equals("1")) sub_query += " and b.car_use ='1' ";
		if(car_use.equals("2")) sub_query += " and b.car_use in ('2','3') ";

		if(!com_id.equals(""))	sub_query += " and b.ins_com_id='"+com_id+"' ";

					
		query = " select ins_com_id, b_dt2, \n"+
				"        decode(ins_com_id,'0007','삼성화재','0008','동부화재','0010','KB손해','0038','렌터카공제조합') com_nm, \n"+
				"        sum(decode(ins_tm2,'0',1,0)) cnt1, \n"+
				"        sum(decode(ins_tm2,'1',1,0)) cnt2, \n"+
				"        sum(decode(ins_tm2,'2',1,0)) cnt3, \n"+
				"        sum(decode(ins_tm2,'3',1,0)) cnt4, \n"+
				"        sum(decode(ins_tm2,'0',pay_amt,0)) amt1, \n"+
				"        sum(decode(ins_tm2,'1',pay_amt,0)) amt2, \n"+
				"        sum(decode(ins_tm2,'2',pay_amt,0)) amt3, \n"+
				"        sum(decode(ins_tm2,'3',pay_amt,0)) amt4  \n"+
				" from ( \n"+
						//가입
				"		select  '1' seq, a.ins_tm2, b.ins_com_id, a.pay_dt, a.pay_amt, b.ins_con_no, b.ins_start_dt, c.car_no, c.car_nm, \n"+
				"               to_char(to_date(b.ins_start_dt,'YYYYMMDD')+decode(to_char(to_date(b.ins_start_dt,'YYYYMMDD'),'DY'),'토',-1,'일',-2,0),'YYYYMMDD') b_dt2 \n"+
				"		from    scd_ins a, car_reg c, insur b \n"+
				"		where \n"+
				"		        a.car_mng_id=c.car_mng_id \n"+
				"		        and a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st \n"+
				"		        and a.pay_dt like '"+cost_ym+"%' \n"+sub_query+
				"		        and a.ins_tm2='0' \n"+
				"		union all \n"+
						//추가
				"		select  '1' seq, a.ins_tm2, b.ins_com_id, a.pay_dt, a.pay_amt, b.ins_con_no, b.ins_start_dt, c.car_no, c.car_nm,  \n"+
				"               to_char(to_date(d.ch_dt,'YYYYMMDD')+decode(to_char(to_date(d.ch_dt,'YYYYMMDD'),'DY'),'토',-1,'일',-2,0),'YYYYMMDD') b_dt2 \n"+
				"		from    scd_ins a, car_reg c, insur b, ins_change d \n"+
				"		where \n"+
				"		        a.car_mng_id=c.car_mng_id \n"+
				"		        and a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st \n"+
				"		        and a.pay_dt like '"+cost_ym+"%' \n"+sub_query+
				"		        and a.ins_tm2='1' and a.pay_amt>0\n"+
				"		        and a.car_mng_id=d.car_mng_id(+) and a.ins_st=d.ins_st(+) and a.ch_tm=d.ch_tm(+) \n"+
				"		union all \n"+
						//추가환급
				"		select  '2' seq, '3' ins_tm2, b.ins_com_id, a.pay_dt, -a.pay_amt, b.ins_con_no, b.ins_start_dt, c.car_no, c.car_nm,  a.pay_dt b_dt2 \n"+//
				"		from    scd_ins a, car_reg c, insur b, ins_change d \n"+
				"		where \n"+
				"		        a.car_mng_id=c.car_mng_id \n"+
				"		        and a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st \n"+
				"		        and a.pay_dt like '"+cost_ym+"%' \n"+sub_query+
				"		        and a.ins_tm2='1' and a.pay_amt<0 \n"+
				"		        and a.car_mng_id=d.car_mng_id(+) and a.ins_st=d.ins_st(+) and a.ch_tm=d.ch_tm(+) \n"+
				"		union all \n"+
						//해지환급
				"		select  '2' seq, a.ins_tm2, b.ins_com_id, a.pay_dt, a.pay_amt, b.ins_con_no, b.ins_start_dt, c.car_no, c.car_nm,  a.pay_dt b_dt2 \n"+// d.exp_dt
				"		from    scd_ins a, car_reg c, insur b, ins_cls d \n"+
				"		where \n"+
				"		        a.car_mng_id=c.car_mng_id \n"+
				"		        and a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st \n"+
				"		        and a.car_mng_id=d.car_mng_id and a.ins_st=d.ins_st \n"+
				"		        and a.pay_dt like '"+cost_ym+"%' \n"+sub_query+
				"		        and a.ins_tm2='2' \n"+
				" )"+
				" group by ins_com_id, seq, b_dt2"+
				" order by decode(ins_com_id,'0007','3','0008','2','0038','1','3'), seq, b_dt2"+
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

//			System.out.println("[InsDatabase:getInsurPrecostYmChkDayList]"+ query);
		} catch (SQLException e) {			
			System.out.println("[InsDatabase:getInsurPrecostYmChkDayList]"+ e);
			System.out.println("[InsDatabase:getInsurPrecostYmChkDayList]"+ query);
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

	//납부보험료 일별 리스트
	public Vector getInsurPrecostYmChkDayList4(String cost_ym, String car_use, String com_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		String sub_query = "";

		if(car_use.equals("1")) sub_query += " and b.car_use ='1' ";
		if(car_use.equals("2")) sub_query += " and b.car_use in ('2','3') ";


		if(!com_id.equals("")){
			if(com_id.equals("9999"))	sub_query += " and b.ins_com_id not in ('0007','0008') ";
			else						sub_query += " and b.ins_com_id='"+com_id+"' ";
		}


		query = " select b_dt2, \n";
		
		if(!com_id.equals("")){
			query += " ins_com_id, decode(ins_com_id,'0007','삼성화재','0008','동부화재','0010','KB손해','0038','렌터카공제조합') com_nm, \n";
		}

		query +="        sum(decode(ins_tm2,'0',1,0)) cnt1, \n"+
				"        sum(decode(ins_tm2,'1',1,0)) cnt2, \n"+
				"        sum(decode(ins_tm2,'2',1,0)) cnt3, \n"+
				"        sum(decode(ins_tm2,'3',1,0)) cnt4, \n"+
				"        sum(decode(ins_tm2,'0',pay_amt,0)) amt1, \n"+
				"        sum(decode(ins_tm2,'1',pay_amt,0)) amt2, \n"+
				"        sum(decode(ins_tm2,'2',pay_amt,0)) amt3, \n"+
				"        sum(decode(ins_tm2,'3',pay_amt,0)) amt4  \n"+
				" from ( \n"+
						//가입
				"		select  '1' seq, a.ins_tm2, b.ins_com_id, b.ins_start_dt pay_dt, a.pay_amt, b.ins_con_no, b.ins_start_dt, c.car_no, c.car_nm, \n"+
				"               b.ins_start_dt b_dt2 \n"+
				"		from    scd_ins a, car_reg c, insur b \n"+
				"		where \n"+
				"		        a.car_mng_id=c.car_mng_id \n"+
				"		        and a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st \n"+
				"		        and b.ins_start_dt like '"+cost_ym+"%' \n"+sub_query+
				"		        and a.ins_tm2='0' \n"+
				"		union all \n"+
						//추가
				"		select  '1' seq, a.ins_tm2, b.ins_com_id, nvl(d.ch_dt,a.pay_dt) pay_dt, a.pay_amt, b.ins_con_no, b.ins_start_dt, c.car_no, c.car_nm,  \n"+
				"               nvl(d.ch_dt,a.pay_dt) b_dt2 \n"+
				"		from    scd_ins a, car_reg c, insur b, ins_change d \n"+
				"		where \n"+
				"		        a.car_mng_id=c.car_mng_id \n"+
				"		        and a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st \n"+
				"		        and a.ins_tm2='1' and a.pay_amt>0\n"+
				"		        and a.car_mng_id=d.car_mng_id(+) and a.ins_st=d.ins_st(+) and a.ch_tm=d.ch_tm(+) \n"+
				"		        and nvl(d.ch_dt,a.pay_dt) like '"+cost_ym+"%' \n"+sub_query+
				"		union all \n"+
						//추가환급
				"		select  '2' seq, '3' ins_tm2, b.ins_com_id, nvl(d.ch_dt,a.pay_dt) pay_dt, -a.pay_amt, b.ins_con_no, b.ins_start_dt, c.car_no, c.car_nm,  nvl(d.ch_dt,a.pay_dt) b_dt2 \n"+
				"		from    scd_ins a, car_reg c, insur b, ins_change d \n"+
				"		where \n"+
				"		        a.car_mng_id=c.car_mng_id \n"+
				"		        and a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st \n"+
				"		        and a.ins_tm2='1' and a.pay_amt<0 \n"+
				"		        and a.car_mng_id=d.car_mng_id(+) and a.ins_st=d.ins_st(+) and a.ch_tm=d.ch_tm(+) \n"+
				"		        and nvl(d.ch_dt,a.pay_dt) like '"+cost_ym+"%' \n"+sub_query+
				"		union all \n"+
						//해지환급
				"		select  '2' seq, a.ins_tm2, b.ins_com_id, nvl(d.req_dt,a.pay_dt) pay_dt, a.pay_amt, b.ins_con_no, b.ins_start_dt, c.car_no, c.car_nm,  nvl(d.req_dt,a.pay_dt) b_dt2 \n"+
				"		from    scd_ins a, car_reg c, insur b, ins_cls d \n"+
				"		where \n"+
				"		        a.car_mng_id=c.car_mng_id \n"+
				"		        and a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st \n"+
				"		        and a.car_mng_id=d.car_mng_id and a.ins_st=d.ins_st \n"+
				"		        and nvl(d.req_dt,a.pay_dt) like '"+cost_ym+"%' \n"+sub_query+
				"		        and a.ins_tm2='2' \n"+
				" )"+
				" group by b_dt2";

				if(!com_id.equals(""))	query += ", ins_com_id order by b_dt2, ins_com_id ";
				else					query += " order by b_dt2 ";


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

//			System.out.println("[InsDatabase:getInsurPrecostYmChkDayList4]"+ query);
		} catch (SQLException e) {			
			System.out.println("[InsDatabase:getInsurPrecostYmChkDayList4]"+ e);
			System.out.println("[InsDatabase:getInsurPrecostYmChkDayList4]"+ query);
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


	//납부보험료 일별 리스트
	public Vector getInsurPrecostYmChkDayList5(String cost_ym, String car_use, String com_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		String sub_query = "";

		if(car_use.equals("1")) sub_query += " and b.car_use ='1' ";
		if(car_use.equals("2")) sub_query += " and b.car_use in ('2','3') ";

		if(!com_id.equals("")){
			if(com_id.equals("9999"))	sub_query += " and b.ins_com_id not in ('0007','0008') ";
			else						sub_query += " and b.ins_com_id='"+com_id+"' ";
		}


		query = " select b_dt2, \n";
		
		if(!com_id.equals("")){
			query += " ins_com_id, decode(ins_com_id,'0007','삼성화재','0008','동부화재','0010','KB손해','0038','렌터카공제조합') com_nm, \n";
		}

		query +="        sum(decode(ins_tm2,'0',1,0)) cnt1, \n"+
				"        sum(decode(ins_tm2,'1',1,0)) cnt2, \n"+
				"        sum(decode(ins_tm2,'2',1,0)) cnt3, \n"+
				"        sum(decode(ins_tm2,'3',1,0)) cnt4, \n"+
				"        sum(decode(ins_tm2,'0',pay_amt,0)) amt1, \n"+
				"        sum(decode(ins_tm2,'1',pay_amt,0)) amt2, \n"+
				"        sum(decode(ins_tm2,'2',pay_amt,0)) amt3, \n"+
				"        sum(decode(ins_tm2,'3',pay_amt,0)) amt4  \n"+
				" from ( \n"+
						//가입
				"		select  '1' seq, a.ins_tm2, b.ins_com_id, b.ins_start_dt pay_dt, a.pay_amt, b.ins_con_no, b.ins_start_dt, c.car_no, c.car_nm, \n"+
				"               b.ins_rent_dt b_dt2 \n"+
				"		from    scd_ins a, car_reg c, insur b \n"+
				"		where \n"+
				"		        a.car_mng_id=c.car_mng_id \n"+
				"		        and a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st \n"+
				"		        and b.ins_rent_dt like '"+cost_ym+"%' \n"+sub_query+
				"		        and a.ins_tm2='0' \n"+
				"		union all \n"+
						//추가
				"		select  '1' seq, a.ins_tm2, b.ins_com_id, nvl(d.ch_dt,a.pay_dt) pay_dt, a.pay_amt, b.ins_con_no, b.ins_start_dt, c.car_no, c.car_nm,  \n"+
				"               nvl(d.ch_dt,a.pay_dt) b_dt2 \n"+
				"		from    scd_ins a, car_reg c, insur b, ins_change d \n"+
				"		where \n"+
				"		        a.car_mng_id=c.car_mng_id \n"+
				"		        and a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st \n"+
				"		        and a.ins_tm2='1' and a.pay_amt>0\n"+
				"		        and a.car_mng_id=d.car_mng_id(+) and a.ins_st=d.ins_st(+) and a.ch_tm=d.ch_tm(+) \n"+
				"		        and nvl(d.ch_dt,a.pay_dt) like '"+cost_ym+"%' \n"+sub_query+
				"		union all \n"+
						//추가환급
				"		select  '2' seq, '3' ins_tm2, b.ins_com_id, nvl(d.ch_dt,a.pay_dt) pay_dt, -a.pay_amt, b.ins_con_no, b.ins_start_dt, c.car_no, c.car_nm,  nvl(d.ch_dt,a.pay_dt) b_dt2 \n"+
				"		from    scd_ins a, car_reg c, insur b, ins_change d \n"+
				"		where \n"+
				"		        a.car_mng_id=c.car_mng_id \n"+
				"		        and a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st \n"+
				"		        and a.ins_tm2='1' and a.pay_amt<0 \n"+
				"		        and a.car_mng_id=d.car_mng_id(+) and a.ins_st=d.ins_st(+) and a.ch_tm=d.ch_tm(+) \n"+
				"		        and nvl(d.ch_dt,a.pay_dt) like '"+cost_ym+"%' \n"+sub_query+
				"		union all \n"+
						//해지환급
				"		select  '2' seq, a.ins_tm2, b.ins_com_id, nvl(d.req_dt,a.pay_dt) pay_dt, a.pay_amt, b.ins_con_no, b.ins_start_dt, c.car_no, c.car_nm,  nvl(d.req_dt,a.pay_dt) b_dt2 \n"+
				"		from    scd_ins a, car_reg c, insur b, ins_cls d \n"+
				"		where \n"+
				"		        a.car_mng_id=c.car_mng_id \n"+
				"		        and a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st \n"+
				"		        and a.car_mng_id=d.car_mng_id and a.ins_st=d.ins_st \n"+
				"		        and nvl(d.req_dt,a.pay_dt) like '"+cost_ym+"%' \n"+sub_query+
				"		        and a.ins_tm2='2' \n"+
				" )"+
				" group by b_dt2";

				if(!com_id.equals(""))	query += ", ins_com_id order by b_dt2, ins_com_id ";
				else					query += " order by b_dt2 ";


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

//			System.out.println("[InsDatabase:getInsurPrecostYmChkDayList4]"+ query);
		} catch (SQLException e) {			
			System.out.println("[InsDatabase:getInsurPrecostYmChkDayList5]"+ e);
			System.out.println("[InsDatabase:getInsurPrecostYmChkDayList5]"+ query);
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


	//납부보험료 일별 세부 리스트
	public Vector getInsurPrecostYmChkDayListSub(String cost_ym, String car_use, String com_id, String pay_dt, String pay_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		String sub_query = "";

		if(car_use.equals("1")) sub_query += " and b.car_use ='1' ";
		if(car_use.equals("2")) sub_query += " and b.car_use in ('2','3') ";

					
		query = " select * \n"+
				" from ( \n"+
						//가입
				"		select  '1' seq, a.ins_tm2, b.ins_com_id, a.pay_dt, a.pay_amt, b.ins_con_no, b.ins_start_dt, c.car_no, c.car_nm, b.car_use, \n"+
				"               to_char(to_date(b.ins_start_dt,'YYYYMMDD')+decode(to_char(to_date(b.ins_start_dt,'YYYYMMDD'),'DY'),'토',-1,'일',-2,0),'YYYYMMDD') b_dt2 \n"+
				"		from    scd_ins a, car_reg c, insur b \n"+
				"		where \n"+
				"		        a.car_mng_id=c.car_mng_id \n"+
				"		        and a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st \n"+
				"		        and a.pay_dt like '"+cost_ym+"%' \n"+sub_query+
				"		        and to_char(to_date(b.ins_start_dt,'YYYYMMDD')+decode(to_char(to_date(b.ins_start_dt,'YYYYMMDD'),'DY'),'토',-1,'일',-2,0),'YYYYMMDD') like '"+pay_dt+"%' \n"+
				"		        and b.ins_com_id like '"+com_id+"%' \n"+
				"		        and a.ins_tm2='0' \n"+
				"		union all \n"+
						//추가
				"		select  '1' seq, a.ins_tm2, b.ins_com_id, a.pay_dt, a.pay_amt, b.ins_con_no, b.ins_start_dt, c.car_no, c.car_nm, b.car_use,  \n"+
				"               to_char(to_date(d.ch_dt,'YYYYMMDD')+decode(to_char(to_date(d.ch_dt,'YYYYMMDD'),'DY'),'토',-1,'일',-2,0),'YYYYMMDD') b_dt2 \n"+
				"		from    scd_ins a, car_reg c, insur b, ins_change d \n"+
				"		where \n"+
				"		        a.car_mng_id=c.car_mng_id \n"+
				"		        and a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st \n"+
				"		        and a.pay_dt like '"+cost_ym+"%' \n"+sub_query+
				"		        and to_char(to_date(d.ch_dt,'YYYYMMDD')+decode(to_char(to_date(d.ch_dt,'YYYYMMDD'),'DY'),'토',-1,'일',-2,0),'YYYYMMDD') like '"+pay_dt+"%' \n"+
				"		        and b.ins_com_id like '"+com_id+"%' \n"+
				"		        and a.ins_tm2='1' and a.pay_amt>0\n"+
				"		        and a.car_mng_id=d.car_mng_id(+) and a.ins_st=d.ins_st(+) and a.ch_tm=d.ch_tm(+) \n"+
				"		union all \n"+
						//추가환급
				"		select  '2' seq, '3' ins_tm2, b.ins_com_id, a.pay_dt, -a.pay_amt, b.ins_con_no, b.ins_start_dt, c.car_no, c.car_nm,  b.car_use, a.pay_dt b_dt2 \n"+//
				"		from    scd_ins a, car_reg c, insur b, ins_change d \n"+
				"		where \n"+
				"		        a.car_mng_id=c.car_mng_id \n"+
				"		        and a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st \n"+
				"		        and a.pay_dt like '"+cost_ym+"%' \n"+sub_query+
				"		        and a.pay_dt like '"+pay_dt+"%' \n"+
				"		        and b.ins_com_id like '"+com_id+"%' \n"+
				"		        and a.ins_tm2='1' and a.pay_amt<0 \n"+
				"		        and a.car_mng_id=d.car_mng_id(+) and a.ins_st=d.ins_st(+) and a.ch_tm=d.ch_tm(+) \n"+
				"		union all \n"+
						//해지환급
				"		select  '2' seq, a.ins_tm2, b.ins_com_id, a.pay_dt, a.pay_amt, b.ins_con_no, b.ins_start_dt, c.car_no, c.car_nm,  b.car_use, a.pay_dt b_dt2 \n"+// d.exp_dt
				"		from    scd_ins a, car_reg c, insur b, ins_cls d \n"+
				"		where \n"+
				"		        a.car_mng_id=c.car_mng_id \n"+
				"		        and a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st \n"+
				"		        and a.car_mng_id=d.car_mng_id and a.ins_st=d.ins_st \n"+
				"		        and a.pay_dt like '"+cost_ym+"%' \n"+sub_query+
				"		        and a.pay_dt like '"+pay_dt+"%' \n"+
				"		        and b.ins_com_id like '"+com_id+"%' \n"+
				"		        and a.ins_tm2='2' \n"+
				" )"+
				" ";


			if(!pay_st.equals("")) query += " where ins_tm2='"+pay_st+"'";


			query += " order by seq, car_use ";



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

//			System.out.println("[InsDatabase:getInsurPrecostYmChkDayListSub]"+ query);
		} catch (SQLException e) {			
			System.out.println("[InsDatabase:getInsurPrecostYmChkDayListSub]"+ e);
			System.out.println("[InsDatabase:getInsurPrecostYmChkDayListSub]"+ query);
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

	//납부보험료 일별 세부 리스트
	public Vector getInsurPrecostYmChkDayListSub4(String cost_ym, String car_use, String com_id, String pay_dt, String pay_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		String sub_query = "";

		if(car_use.equals("1")) sub_query += " and b.car_use ='1' ";
		if(car_use.equals("2")) sub_query += " and b.car_use in ('2','3') ";

				


		query = " select * \n"+
				" from ( \n"+
						//가입
				"		select  '1' seq, a.ins_tm2, b.ins_com_id, a.pay_dt, a.pay_amt, b.ins_con_no, b.ins_start_dt, c.car_no, c.car_nm, b.car_use, \n"+
//				"               to_char(to_date(b.ins_start_dt,'YYYYMMDD')+decode(to_char(to_date(b.ins_start_dt,'YYYYMMDD'),'DY'),'토',-1,'일',-2,0),'YYYYMMDD') b_dt2 \n"+
				"               b.ins_start_dt b_dt2 \n"+
				"		from    scd_ins a, car_reg c, insur b \n"+
				"		where \n"+
				"		        a.car_mng_id=c.car_mng_id \n"+
				"		        and a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st \n"+
				"		        and b.ins_start_dt like '"+cost_ym+"%' \n"+sub_query+
//				"		        and to_char(to_date(b.ins_start_dt,'YYYYMMDD')+decode(to_char(to_date(b.ins_start_dt,'YYYYMMDD'),'DY'),'토',-1,'일',-2,0),'YYYYMMDD') like '"+pay_dt+"%' \n"+
				"		        and b.ins_start_dt like '"+pay_dt+"%' \n"+
				"		        and b.ins_com_id like '"+com_id+"%' \n"+
				"		        and a.ins_tm2='0' \n"+
				"		union all \n"+
						//추가
				"		select  '1' seq, a.ins_tm2, b.ins_com_id, a.pay_dt, a.pay_amt, b.ins_con_no, b.ins_start_dt, c.car_no, c.car_nm, b.car_use,  \n"+
//				"               to_char(to_date(nvl(d.ch_dt,a.pay_dt),'YYYYMMDD')+decode(to_char(to_date(nvl(d.ch_dt,a.pay_dt),'YYYYMMDD'),'DY'),'토',-1,'일',-2,0),'YYYYMMDD') b_dt2 \n"+
				"               nvl(d.ch_dt,a.pay_dt) b_dt2 \n"+
				"		from    scd_ins a, car_reg c, insur b, ins_change d \n"+
				"		where \n"+
				"		        a.car_mng_id=c.car_mng_id \n"+
				"		        and a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st \n"+
				"		        and nvl(d.ch_dt,a.pay_dt) like '"+cost_ym+"%' \n"+sub_query+
//				"		        and to_char(to_date(nvl(d.ch_dt,a.pay_dt),'YYYYMMDD')+decode(to_char(to_date(nvl(d.ch_dt,a.pay_dt),'YYYYMMDD'),'DY'),'토',-1,'일',-2,0),'YYYYMMDD') like '"+pay_dt+"%' \n"+
				"		        and nvl(d.ch_dt,a.pay_dt) like '"+pay_dt+"%' \n"+
				"		        and b.ins_com_id like '"+com_id+"%' \n"+
				"		        and a.ins_tm2='1' and a.pay_amt>0\n"+
				"		        and a.car_mng_id=d.car_mng_id(+) and a.ins_st=d.ins_st(+) and a.ch_tm=d.ch_tm(+) \n"+
				"		union all \n"+
						//추가환급
				"		select  '2' seq, '3' ins_tm2, b.ins_com_id, a.pay_dt, -a.pay_amt, b.ins_con_no, b.ins_start_dt, c.car_no, c.car_nm,  b.car_use, nvl(d.ch_dt,a.pay_dt) b_dt2 \n"+//
				"		from    scd_ins a, car_reg c, insur b, ins_change d \n"+
				"		where \n"+
				"		        a.car_mng_id=c.car_mng_id \n"+
				"		        and a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st \n"+
				"		        and nvl(d.ch_dt,a.pay_dt) like '"+cost_ym+"%' \n"+sub_query+
				"		        and nvl(d.ch_dt,a.pay_dt) like '"+pay_dt+"%' \n"+
				"		        and b.ins_com_id like '"+com_id+"%' \n"+
				"		        and a.ins_tm2='1' and a.pay_amt<0 \n"+
				"		        and a.car_mng_id=d.car_mng_id(+) and a.ins_st=d.ins_st(+) and a.ch_tm=d.ch_tm(+) \n"+
				"		union all \n"+
						//해지환급
				"		select  '2' seq, a.ins_tm2, b.ins_com_id, a.pay_dt, a.pay_amt, b.ins_con_no, b.ins_start_dt, c.car_no, c.car_nm,  b.car_use, nvl(d.req_dt,a.pay_dt) b_dt2 \n"+// d.exp_dt
				"		from    scd_ins a, car_reg c, insur b, ins_cls d \n"+
				"		where \n"+
				"		        a.car_mng_id=c.car_mng_id \n"+
				"		        and a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st \n"+
				"		        and a.car_mng_id=d.car_mng_id and a.ins_st=d.ins_st \n"+
				"		        and nvl(d.req_dt,a.pay_dt) like '"+cost_ym+"%' \n"+sub_query+
				"		        and nvl(d.req_dt,a.pay_dt) like '"+pay_dt+"%' \n"+
				"		        and b.ins_com_id like '"+com_id+"%' \n"+
				"		        and a.ins_tm2='2' \n"+
				" )"+
				" ";


			if(!pay_st.equals("")) query += " where ins_tm2='"+pay_st+"'";


			query += " order by seq, car_use, pay_dt ";



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

//			System.out.println("[InsDatabase:getInsurPrecostYmChkDayListSub4]"+ query);
		} catch (SQLException e) {			
			System.out.println("[InsDatabase:getInsurPrecostYmChkDayListSub4]"+ e);
			System.out.println("[InsDatabase:getInsurPrecostYmChkDayListSub4]"+ query);
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



	//납부보험료 일별 세부 리스트
	public Vector getInsurPrecostYmChkDayListSub5(String cost_ym, String car_use, String com_id, String pay_dt, String pay_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		String sub_query = "";

		if(car_use.equals("1")) sub_query += " and b.car_use ='1' ";
		if(car_use.equals("2")) sub_query += " and b.car_use in ('2','3') ";

				


		query = " select * \n"+
				" from ( \n"+
						//가입
				"		select  '1' seq, a.ins_tm2, b.ins_com_id, a.pay_dt, a.pay_amt, b.ins_con_no, b.ins_start_dt, c.car_no, c.car_nm, b.car_use, \n"+
				"               b.ins_rent_dt b_dt2 \n"+
				"		from    scd_ins a, car_reg c, insur b \n"+
				"		where \n"+
				"		        a.car_mng_id=c.car_mng_id \n"+
				"		        and a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st \n"+
				"		        and b.ins_rent_dt like '"+pay_dt+"%' \n"+sub_query+
				"		        and b.ins_com_id like '"+com_id+"%' \n"+
				"		        and a.ins_tm2='0' \n"+
				"		union all \n"+
						//추가
				"		select  '1' seq, a.ins_tm2, b.ins_com_id, a.pay_dt, a.pay_amt, b.ins_con_no, b.ins_start_dt, c.car_no, c.car_nm, b.car_use,  \n"+
				"               nvl(d.ch_dt,a.pay_dt) b_dt2 \n"+
				"		from    scd_ins a, car_reg c, insur b, ins_change d \n"+
				"		where \n"+
				"		        a.car_mng_id=c.car_mng_id \n"+
				"		        and a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st \n"+
				"		        and nvl(d.ch_dt,a.pay_dt) like '"+pay_dt+"%' \n"+sub_query+
				"		        and b.ins_com_id like '"+com_id+"%' \n"+
				"		        and a.ins_tm2='1' and a.pay_amt>0\n"+
				"		        and a.car_mng_id=d.car_mng_id(+) and a.ins_st=d.ins_st(+) and a.ch_tm=d.ch_tm(+) \n"+
				"		union all \n"+
						//추가환급
				"		select  '2' seq, '3' ins_tm2, b.ins_com_id, a.pay_dt, -a.pay_amt, b.ins_con_no, b.ins_start_dt, c.car_no, c.car_nm,  b.car_use, nvl(d.ch_dt,a.pay_dt) b_dt2 \n"+//
				"		from    scd_ins a, car_reg c, insur b, ins_change d \n"+
				"		where \n"+
				"		        a.car_mng_id=c.car_mng_id \n"+
				"		        and a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st \n"+
				"		        and nvl(d.ch_dt,a.pay_dt) like '"+pay_dt+"%' \n"+sub_query+
				"		        and b.ins_com_id like '"+com_id+"%' \n"+
				"		        and a.ins_tm2='1' and a.pay_amt<0 \n"+
				"		        and a.car_mng_id=d.car_mng_id(+) and a.ins_st=d.ins_st(+) and a.ch_tm=d.ch_tm(+) \n"+
				"		union all \n"+
						//해지환급
				"		select  '2' seq, a.ins_tm2, b.ins_com_id, a.pay_dt, a.pay_amt, b.ins_con_no, b.ins_start_dt, c.car_no, c.car_nm,  b.car_use, nvl(d.req_dt,a.pay_dt) b_dt2 \n"+// d.exp_dt
				"		from    scd_ins a, car_reg c, insur b, ins_cls d \n"+
				"		where \n"+
				"		        a.car_mng_id=c.car_mng_id \n"+
				"		        and a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st \n"+
				"		        and a.car_mng_id=d.car_mng_id and a.ins_st=d.ins_st \n"+
				"		        and nvl(d.req_dt,a.pay_dt) like '"+pay_dt+"%' \n"+sub_query+
				"		        and b.ins_com_id like '"+com_id+"%' \n"+
				"		        and a.ins_tm2='2' \n"+
				" )"+
				" ";


			if(!pay_st.equals("")) query += " where ins_tm2='"+pay_st+"'";


			query += " order by seq, car_use, pay_dt ";



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

//			System.out.println("[InsDatabase:getInsurPrecostYmChkDayListSub4]"+ query);
		} catch (SQLException e) {			
			System.out.println("[InsDatabase:getInsurPrecostYmChkDayListSub5]"+ e);
			System.out.println("[InsDatabase:getInsurPrecostYmChkDayListSub5]"+ query);
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




	//자동차세 당월 예상 현황
	public Vector getExpScdMonEstStat()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String sub_query = "";
		String query = "";

		String s_day = "sysdate";
		String s_mon = "to_char(sysdate,'YYYYMM')";
		String when = "to_char(sysdate,'YYYYMM')";

					
		sub_query = " select"+
				" b.car_mng_id, b.car_no, b.car_nm, b.init_reg_dt, b.car_ext, c.nm, b.car_use, b.car_kd, b.taking_p, b.dpm, b.dpm_tax1, b.dpm_tax2, b.days, "+
				" decode(b.taking_p_st,1,'7-9인승',decode(b.car_kd_st,1,'승용',2,'화물',3,'승합')) car_st, "+
				" decode(b.taking_p_st,1,to_char(round(b.dpm_tax1*b.dpm/365*b.days*0.84,-1)),decode(b.car_kd_st,1,to_char(round(b.dpm_tax1*b.dpm/365*b.days,-1)),2,to_char(round(6600/365*b.days,-1)), 3,to_char(round(25000/365*b.days,-1)))) car_tax1,/*영업용-렌트*/"+
				" decode(b.taking_p_st,1,to_char(round(b.dpm_tax2*b.dpm/365*b.days*0.84,-1)),decode(b.car_kd_st,1,to_char(round(b.dpm_tax2*b.dpm/365*b.days,-1)),2,to_char(round(28500/365*b.days,-1)),3,to_char(round(65000/365*b.days,-1)))) car_tax2/*비영업용-리스*/"+
				" from cont a,"+
				" (select car_mng_id, car_no, car_nm, dpm, init_reg_dt, car_use, car_ext, car_kd, taking_p,"+
				"    decode(sign(dpm-800)+sign(dpm-1000)+sign(dpm-1600)+sign(dpm-2000),-4,18,-2,18,0,19,2,19,4,24) dpm_tax1,"+
//				"    decode(sign(dpm-800)+sign(dpm-1000)+sign(dpm-1600)+sign(dpm-2000),-4,80,-2,100,0,140,2,200,4,220) dpm_tax2,"+
				"    decode(sign(dpm-800)+sign(dpm-1000)+sign(dpm-1600)+sign(dpm-2000),-4,80,-2,80,0,140,2,140,4,200) dpm_tax2,"+
				"    decode(car_kd,'1',1,'2',1,'3',1,'9',1,'6',2,'7',2,'8',2,'4',3,'5',3,0) car_kd_st,"+
				"    decode(taking_p,'7',1,'9',1,'10',1,0) taking_p_st,"+
				"    trunc(last_day("+s_day+")-to_date(decode(substr(init_reg_dt,1,6),"+s_mon+",init_reg_dt,"+s_mon+"||'01'),'YYYYMMDD')+1,0) days"+
				"    from car_reg"+
				"    where nvl(prepare,'1') not in ('4','5')"+
				" ) b, code c"+
				" where"+
				" nvl(a.use_yn,'Y')='Y' and a.rent_l_cd not like 'RM%' and c.c_st='0032' "+
				" and a.car_mng_id=b.car_mng_id"+
				" and b.car_ext = c.nm_cd";


			query = " select car_ext, nm car_ext_nm, "+
					"        count(decode(car_use,'1',car_mng_id)) cnt1,"+
					"        sum(decode(car_use,'1',car_tax1)) amt1,"+
					"        count(decode(car_use,'2',car_mng_id)) cnt2,"+
					"        sum(decode(car_use,'2',car_tax2+decode(car_st,'승합',0,'화물',0,(round(car_tax2*0.3,-1))))) amt2"+									
					" from ("+sub_query+") group by car_ext,nm order by car_ext";

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
			System.out.println("[InsDatabase:getExpScdMonEstStat]"+ e);
			System.out.println("[InsDatabase:getExpScdMonEstStat]"+ query);
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
	 *	기간비용정산
	 */
	public boolean settleInsurPrecost_ClsRtn(String car_mng_id, String ins_st, String pay_dt, int pay_amt)
	{
		getConnection();
		boolean flag = true;

		String query1 =  " delete from precost where car_mng_id=? and cost_id=? and cost_ym>substr(replace(?,'-',''),1,6) and cost_st='2' ";

		String query2 =  " update precost set "+
						 "		cost_amt=(cost_amt+rest_amt-?), rest_day=0, rest_amt=0 "+
						 " where car_mng_id=? and cost_id=? and cost_ym=substr(replace(?,'-',''),1,6) and cost_st='2' ";

		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query1);
			pstmt1.setString(1,  car_mng_id);
			pstmt1.setString(2,  ins_st);
			pstmt1.setString(3,  pay_dt);
		    pstmt1.executeUpdate();
			pstmt1.close();

			pstmt2 = conn.prepareStatement(query2);
			pstmt2.setInt   (1,  pay_amt);
			pstmt2.setString(2,  car_mng_id);
			pstmt2.setString(3,  ins_st);
			pstmt2.setString(4,  pay_dt);
		    pstmt2.executeUpdate();
			pstmt2.close();

			conn.commit();


	  	} catch (Exception e) {
			System.out.println("[InsDatabase:settleInsurPrecost_ClsRtn]"+ e);
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
	 *	기간비용정산
	 */
	public boolean settleInsurPrecost_InsCng(String car_mng_id, String ins_st, String pay_dt, int pay_amt)
	{
		getConnection();
		boolean flag = true;

		String query2 =  " update precost set "+
						 "		cost_amt=(cost_amt+?), cost_tm2='1' "+
						 " where car_mng_id=? and cost_id=? and cost_ym=substr(replace(?,'-',''),1,6) and cost_st='2' ";

		PreparedStatement pstmt2 = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt2 = conn.prepareStatement(query2);
			pstmt2.setInt   (1,  pay_amt);
			pstmt2.setString(2,  car_mng_id);
			pstmt2.setString(3,  ins_st);
			pstmt2.setString(4,  pay_dt);
		    pstmt2.executeUpdate();
			pstmt2.close();

			conn.commit();


	  	} catch (Exception e) {
			System.out.println("[InsDatabase:settleInsurPrecost_InsCng]"+ e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt2 != null)	pstmt2.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}


//환급자동차세 리스트    20100211-  and a.rtn_amt = 0  >> and a.rtn_amt is null
	public Vector getExpRtnScdReqList_a(String car_ext)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " select"+
				" a.car_mng_id, a.exp_st,a .exp_est_dt,"+
				" a.car_no, b.car_nm, b.init_reg_dt,"+ 
				" decode(e.cha_dt,'','',e.cha_dt||'[용도변경]-'||e.cha_cau_sub) cha_cont,"+
				" decode(c.migr_dt,'','',c.migr_dt||'[매각]-'||d.firm_nm) sui_cont"+
				" from gen_exp a, car_reg b, sui c, client d, car_change e, car_change f, "+
				"	(select car_mng_id from cont where use_yn='Y' and car_st in ('1','3')) g"+
				" where a.exp_st='3' and substr(a.exp_end_dt,5,4)='1231' and a.rtn_est_amt>0 and a.rtn_amt = 0 /*and a.rtn_req_dt is null */and a.rtn_dt is null and a.exp_est_dt<>a.exp_end_dt"+
				" and a.car_mng_id=b.car_mng_id"+
				" and a.car_mng_id=c.car_mng_id(+)"+
				" and c.client_id=d.client_id(+)"+
				" and a.car_mng_id=e.car_mng_id(+) and a.rtn_cau_dt=e.cha_dt(+)"+
				" and e.car_mng_id=f.car_mng_id(+) and e.cha_seq-1=f.cha_seq(+)"+
				" and a.car_mng_id=g.car_mng_id(+)"+
				" and (c.migr_dt is not null or (c.migr_dt is null and e.cha_dt is not null and g.car_mng_id is not null and substr(a.exp_dt,1,6)||'00' < e.cha_dt))";

		if(!car_ext.equals(""))	query += " and a.car_ext='"+car_ext+"'";

		query += " order by a.rtn_cau, a.rtn_cau_dt";

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
			
			System.out.println("[InsDatabase:getExpRtnScdReqList_a]"+ e);
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


	//환급자동차세 리스트    20100211-  and a.rtn_amt = 0  >> and a.rtn_amt is null
	public Vector getExpRtnScdReqList_s(String car_ext)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " select"+
				" a.car_mng_id, a.exp_st,a .exp_est_dt,"+
				" a.car_no, b.car_nm, b.init_reg_dt,"+ 
				" decode(e.cha_dt,'','',e.cha_dt||'[용도변경]-'||e.cha_cau_sub) cha_cont,"+
				" decode(c.migr_dt,'','',c.migr_dt||'[매각]-'||d.firm_nm) sui_cont"+
				" from gen_exp a, car_reg b, sui c, client d, car_change e, car_change f, "+
				"	(select car_mng_id from cont where use_yn='Y' and car_st in ('1','3')) g"+
				" where a.exp_st='3' and substr(a.exp_end_dt,5,4)='1231' and a.rtn_est_amt>0 and a.rtn_amt = 0 and a.rtn_req_dt is not null and a.rtn_dt is null and a.exp_est_dt<>a.exp_end_dt"+
				" and a.car_mng_id=b.car_mng_id"+
				" and a.car_mng_id=c.car_mng_id(+)"+
				" and c.client_id=d.client_id(+)"+
				" and a.car_mng_id=e.car_mng_id(+) and a.rtn_cau_dt=e.cha_dt(+)"+
				" and e.car_mng_id=f.car_mng_id(+) and e.cha_seq-1=f.cha_seq(+)"+
				" and a.car_mng_id=g.car_mng_id(+)"+
				" and (c.migr_dt is not null or (c.migr_dt is null and e.cha_dt is not null and g.car_mng_id is not null and substr(a.exp_dt,1,6)||'00' < e.cha_dt))";

		if(!car_ext.equals(""))	query += " and a.car_ext='"+car_ext+"'";

		query += " order by a.rtn_cau, a.rtn_cau_dt";

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
			
			System.out.println("[InsDatabase:getExpRtnScdReqList_s]"+ e);
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

	//20100420 삼성화재 감사대비 장기대여자료보완대상 세부리스트
	public Vector getInsExcelComReq20100420(String gubun, String ins_start_dt, String ins_exp_dt, String ins_con_no, String car_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		if(gubun.equals("1")){
			query = " select b.car_no, a.ins_start_dt, a.ins_exp_dt, replace(a.ins_con_no,'-','') ins_con_no, \n"+
					"        d.rent_l_cd, f.firm_nm, b.car_num, b.car_nm, b.init_reg_dt, e.rent_start_dt, e.rent_end_dt, g.cls_dt \n"+
					" from   insur a, car_reg b, "+
					"        cont d, \n"+
					"        (select rent_mng_id, rent_l_cd, min(rent_start_dt) rent_start_dt, max(rent_end_dt) rent_end_dt from fee group by rent_mng_id, rent_l_cd) e, \n"+
					"        client f, cls_cont g \n"+
					" where  a.ins_com_id='0007' and a.ins_start_dt >= '20071214'\n"+
					"        and replace(a.ins_con_no,'-','') = replace('"+ins_con_no+"','-','') \n"+
					"        and a.car_mng_id=b.car_mng_id \n"+
					"        and a.car_mng_id=d.car_mng_id \n"+
					"        and d.rent_mng_id=e.rent_mng_id and d.rent_l_cd=e.rent_l_cd \n"+
					"        and d.client_id=f.client_id \n"+
					"        and d.rent_mng_id=g.rent_mng_id(+) and d.rent_l_cd=g.rent_l_cd(+) \n"+
					"        and d.car_st in ('1','3') and nvl(g.cls_st,'0') not in ('4','5')\n"+
				    "        and a.ins_start_dt between to_char(to_date(e.rent_start_dt,'YYYYMMDD')-10,'YYYYMMDD') and e.rent_end_dt \n"+
					" ";

		}else if(gubun.equals("2")){
			query = " select b.car_no, a.ins_start_dt, a.ins_exp_dt, replace(a.ins_con_no,'-','') ins_con_no, \n"+
					"        d.rent_l_cd, f.firm_nm, b.car_num, b.car_nm, b.init_reg_dt, e.rent_start_dt, e.rent_end_dt, g.cls_dt \n"+
					" from   insur a, car_reg b, "+
					"        cont d, \n"+
					"        (select rent_mng_id, rent_l_cd, min(rent_start_dt) rent_start_dt, max(rent_end_dt) rent_end_dt from fee group by rent_mng_id, rent_l_cd) e, \n"+
					"        client f, cls_cont g \n"+
					" where  a.ins_com_id='0007' and a.ins_start_dt >= '20071214'\n"+
					"        and replace(a.ins_con_no,'-','') = replace('"+ins_con_no+"','-','') \n"+
					"        and a.car_mng_id=b.car_mng_id \n"+
					"        and a.car_mng_id=d.car_mng_id \n"+
					"        and d.rent_mng_id=e.rent_mng_id and d.rent_l_cd=e.rent_l_cd \n"+
					"        and d.client_id=f.client_id \n"+
					"        and d.rent_mng_id=g.rent_mng_id(+) and d.rent_l_cd=g.rent_l_cd(+) \n"+
					"        and d.car_st in ('1','3') and nvl(g.cls_st,'0') not in ('4','5')\n"+
					" ";

		}

		query += " order by a.ins_start_dt, e.rent_start_dt ";
		
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
			System.out.println("[InsDatabase:getInsExcelComReq20100420]"+ e);
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

	//보험료 기간비용 리스트 조회
	public Vector getInsMngCostList(String br_id, String gubun0, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String gubun7, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String s_dt = "";


				query = " select\n"+
						"        decode(a.ins_kd,'2','책임보험', '종합보험') as ins_kd,\n"+
						"        decode(a.ins_sts,'1','유효', '2','만료', '3','중도해지','5','승계') as ins_sts,\n"+
						"        a.car_mng_id, a.ins_st, c.car_no, c.car_nm, b.ins_com_nm, d.rent_mng_id, d.rent_l_cd,\n"+
						"        decode(a.car_use,'1','영업용', '업무용') as car_use,\n"+
						"        a.ins_start_dt, a.ins_exp_dt, a.ins_rent_dt, \n"+
						"        decode(a.age_scp,'1','21세이상','2','26세이상','4','24세이상','3','모든운전자','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하') as age_scp,\n"+
						"        (decode(a.air_ds_yn,'Y',1,0)+decode(a.air_as_yn,'Y',1,0)) as air,\n"+
						"        decode(e.migr_dt,'','Y','N') as use_yn, e.migr_dt, g.exp_dt, nvl(h.cls_dt,g.req_dt) req_dt, h.pay_amt, i.cost_amt, (i.cost_amt-h.pay_amt) as cha_amt, i.cost_ym, \n"+
						"        j.ch_amt, j.ch_dt, decode(h.cls_amt,0,g.rtn_est_amt,h.cls_amt) rtn_amt \n"+
						" from   insur a, ins_com b, car_reg c, cont d, sui e,\n"+
						"        (select car_mng_id, car_no from car_change group by car_mng_id, car_no) f, ins_cls g, \n"+
						"        (select car_mng_id, ins_st, sum(decode(ins_tm2,'2',-pay_amt,pay_amt)) pay_amt, sum(decode(ins_tm2,'2',pay_amt)) cls_amt, max(decode(ins_tm2,'2',pay_dt)) cls_dt from scd_ins group by car_mng_id, ins_st ) h,"+
						"        (select car_mng_id, cost_id, sum(cost_amt) cost_amt, max(cost_ym) cost_ym from precost where cost_st='2' group by car_mng_id, cost_id) i,";


				if(s_kd.equals("4")){				

					query += " (select car_mng_id, ins_st, 1 cng_cnt, ch_dt, ch_amt from ins_change where ch_dt like '"+t_wd+"%' and nvl(ch_amt,0)<>0 ) j\n";

				}else{

					query += " (select car_mng_id, ins_st, count(*) cng_cnt, max(ch_dt) ch_dt, sum(ch_amt) ch_amt from ins_change group by car_mng_id, ins_st) j \n";

				}


				query +=" where  a.ins_start_dt >= to_char(sysdate-600,'YYYYMMDD') "+
						"        and a.ins_com_id=b.ins_com_id and a.car_mng_id=c.car_mng_id and a.car_mng_id=f.car_mng_id"+
						"        and a.car_mng_id=d.car_mng_id and d.reg_dt||d.rent_l_cd=(select max(reg_dt||rent_l_cd) from cont where rent_l_cd not like 'RM%' and car_mng_id=a.car_mng_id)"+
						"        and a.car_mng_id=e.car_mng_id(+)"+
						"        and a.car_mng_id=g.car_mng_id(+) and a.ins_st=g.ins_st(+)"+
						"        and a.car_mng_id=h.car_mng_id(+) and a.ins_st=h.ins_st(+)"+
						"        and a.car_mng_id=i.car_mng_id(+) and a.ins_st=i.cost_id(+)"+
						"        and a.car_mng_id=j.car_mng_id(+) and a.ins_st=j.ins_st(+)"+
						" ";

				if(gubun1.equals("1"))				query += " and a.car_use = '1' \n";
				if(gubun1.equals("2"))				query += " and a.car_use in ('2','3') \n";

				if(s_kd.equals("1"))				query += " and nvl(f.car_no,c.car_no) like '%"+t_wd+"%'		order by a.car_mng_id, a.ins_start_dt, a.ins_st\n";
				if(s_kd.equals("2"))				query += " and g.req_dt like '"+t_wd+"%'					order by g.req_dt \n";
				if(s_kd.equals("3"))				query += " and g.exp_dt like '"+t_wd+"%'					order by g.exp_dt  \n";
				if(s_kd.equals("4"))				query += " and nvl(j.cng_cnt,0)>0							order by j.ch_dt  \n";
				if(s_kd.equals("5"))				query += " and a.ins_start_dt like '"+t_wd+"%'				order by a.ins_start_dt, a.car_mng_id  \n";
				if(s_kd.equals("6")){
					query += " and (i.cost_amt-h.pay_amt)<>0 and a.ins_exp_dt > '20101231' \n";

					if(sort.equals("1"))				query += " order by c.car_no  \n";
					if(sort.equals("2"))				query += " order by a.ins_start_dt, a.car_mng_id  \n";
					if(sort.equals("3"))				query += " order by a.ins_exp_dt, a.car_mng_id  \n";
					if(sort.equals("4"))				query += " order by g.req_dt, a.car_mng_id  \n";
					if(sort.equals("5"))				query += " order by g.exp_dt, a.car_mng_id  \n";
					if(sort.equals("6"))				query += " order by j.ch_dt, a.car_mng_id  \n";
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
			System.out.println("[InsDatabase:getInsMngCostList]"+ e);
			System.out.println("[InsDatabase:getInsMngCostList]"+ query);
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

	//납부년간현황
	public Vector getInsurPrecostPrint_2_amt(String cost_ym)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " select "+
				"        b.ins_com_id, decode(b.car_use,'3','2',b.car_use) car_use, "+
				"        count(*) t_cnt, "+
				"        '' t1, "+
				"        '' t2, "+
				"        count(decode(nvl(a.ins_tm2,'0'),'0',decode(a.ins_tm,'1',a.car_mng_id))) cnt1, "+
				"        sum  (decode(nvl(a.ins_tm2,'0'),'0',decode(a.ins_tm,'1',a.pay_amt))) amt1, "+
				"        count(decode(nvl(a.ins_tm2,'0'),'0',decode(a.ins_tm,'1','',a.car_mng_id))) cnt2, "+
				"        sum  (decode(nvl(a.ins_tm2,'0'),'0',decode(a.ins_tm,'1',0,a.pay_amt))) amt2, "+
				"        count(decode(nvl(a.ins_tm2,'0'),'1',a.car_mng_id)) cnt3, "+
				"        sum  (decode(nvl(a.ins_tm2,'0'),'1',a.pay_amt)) amt3, "+
				"        '' c, '' a, "+
				"        count(decode(nvl(a.ins_tm2,'0'),'2',a.car_mng_id)) cnt4, "+
				"        sum  (decode(nvl(a.ins_tm2,'0'),'2',a.pay_amt)) amt4 "+
				" from   scd_ins a, car_reg c, insur b "+
				" where "+
				"        a.car_mng_id=c.car_mng_id "+
				" and    a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st "+
				" and    a.pay_dt like '"+cost_ym+"%' "+
				" group by b.ins_com_id, decode(b.car_use,'3','2',b.car_use) "+
				" order by b.ins_com_id, decode(b.car_use,'3','2',b.car_use)  ";

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
			System.out.println("[InsDatabase:getInsurPrecostPrint_2_amt]"+ e);
			System.out.println("[InsDatabase:getInsurPrecostPrint_2_amt]"+ query);
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

	//납부년간현황
	public Vector getInsurPrecostPrint_2_cnt(String cost_ym)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " select "+
				"        b.ins_com_id, decode(b.car_use,'3','2',b.car_use) car_use, "+
				"        count(*) cnt, sum(a.pay_amt) amt"+
				" from   (select car_mng_id, ins_st, sum(decode(nvl(ins_tm2,'0'),'2',-pay_amt,pay_amt)) pay_amt from scd_ins "+
				"         where pay_dt like '"+cost_ym+"%' group by car_mng_id, ins_st) a, "+
				"        insur b, car_reg c "+
				" where  a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st "+
				" and    a.car_mng_id=c.car_mng_id "+
				" group by b.ins_com_id, decode(b.car_use,'3','2',b.car_use) "+
				" order by b.ins_com_id, decode(b.car_use,'3','2',b.car_use)  ";

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
			System.out.println("[InsDatabase:getInsurPrecostPrint_2_cnt]"+ e);
			System.out.println("[InsDatabase:getInsurPrecostPrint_2_cnt]"+ query);
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
	public boolean insertInsChangeDoc(InsurChangeBean bean)
	{
		getConnection();
		boolean flag = true;

		String query =  " insert into ins_change_doc"+
						" (INS_DOC_NO, CAR_MNG_ID, INS_ST, CH_DT, CH_ETC, REG_ID, REG_DT, rent_mng_id, rent_l_cd, rent_st, o_fee_amt, doc_st, n_fee_amt, d_fee_amt, ch_st, ch_s_dt, ch_e_dt, "+
			            "  o_opt_amt, n_opt_amt, o_cls_per, n_cls_per, r_fee_est_dt, o_rtn_run_amt, n_rtn_run_amt, o_over_run_amt, n_over_run_amt "+
						" ) values"+
						" (?, ?, ?, replace(?, '-', ''), ?, ?, to_char(sysdate,'YYYYMMDD'), ?, ?, ?, ?, ?, ?, ?, ?, replace(?, '-', ''), replace(?, '-', ''), "+
			            "  ?, ?, ?, ?, ?, ?, ?, ?, ? "+
                        " )";
		
		PreparedStatement pstmt = null;
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, bean.getIns_doc_no());
			pstmt.setString(2, bean.getCar_mng_id());
			pstmt.setString(3, bean.getIns_st());
			pstmt.setString(4, bean.getCh_dt());
			pstmt.setString(5, bean.getCh_etc());
			pstmt.setString(6, bean.getUpdate_id());
			pstmt.setString(7, bean.getRent_mng_id());
			pstmt.setString(8, bean.getRent_l_cd());
			pstmt.setString(9, bean.getRent_st());
			pstmt.setInt   (10,bean.getO_fee_amt());
			pstmt.setString(11,bean.getDoc_st());
			pstmt.setInt   (12,bean.getN_fee_amt());
			pstmt.setInt   (13,bean.getD_fee_amt());
			pstmt.setString(14,bean.getCh_st());
			pstmt.setString(15,bean.getCh_s_dt());
			pstmt.setString(16,bean.getCh_e_dt());
			pstmt.setInt   (17,bean.getO_opt_amt());
			pstmt.setInt   (18,bean.getN_opt_amt());
			pstmt.setFloat (19,bean.getO_cls_per());
			pstmt.setFloat (20,bean.getN_cls_per());
			pstmt.setString (21,bean.getR_fee_est_dt());
			pstmt.setInt   (22,bean.getO_rtn_run_amt());
			pstmt.setInt   (23,bean.getN_rtn_run_amt());
			pstmt.setInt   (24,bean.getO_over_run_amt());
			pstmt.setInt   (25,bean.getN_over_run_amt());
			

			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[InsDatabase:insertInsChangeDoc]"+ e);
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
	public boolean updateInsChangeDoc(InsurChangeBean bean)
	{
		getConnection();
		boolean flag = true;

		String query =  " update ins_change_doc set "+
						"        CH_DT		=replace(?,'-',''), "+
						"        CH_ETC		=?, "+
						"        UPDATE_ID	=?, "+
						"        UPDATE_DT	=to_char(sysdate,'YYYYMMDD'), "+
						"        o_fee_amt	=?, "+
						"        n_fee_amt	=?, "+
						"        d_fee_amt	=?, "+
						"        ins_doc_st	=?, "+
						"        reject_cau	=?, "+
						"        CH_ST		=?, "+
						"        CH_S_DT	=replace(?,'-',''), "+
						"        CH_E_DT	=replace(?,'-',''), "+
						"        o_opt_amt	=?, "+
						"        n_opt_amt	=?, "+
						"        o_cls_per	=?, "+
						"        n_cls_per	=?, "+
						"        r_fee_est_dt =?,  "+
						"        o_rtn_run_amt	=?, "+
						"        n_rtn_run_amt	=?, "+
						"        o_over_run_amt	=?, "+
						"        n_over_run_amt	=?  "+
						" where ins_doc_no	=?";
		
		PreparedStatement pstmt = null;
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1,  bean.getCh_dt		());
			pstmt.setString(2,  bean.getCh_etc		());
			pstmt.setString(3,  bean.getUpdate_id	());
			pstmt.setInt   (4,  bean.getO_fee_amt	());
			pstmt.setInt   (5,  bean.getN_fee_amt	());
			pstmt.setInt   (6,  bean.getD_fee_amt	());
			pstmt.setString(7,  bean.getIns_doc_st	());
			pstmt.setString(8,  bean.getReject_cau	());
			pstmt.setString(9,  bean.getCh_st		());
			pstmt.setString(10, bean.getCh_s_dt		());
			pstmt.setString(11, bean.getCh_e_dt		());
			pstmt.setInt   (12, bean.getO_opt_amt	());
			pstmt.setInt   (13, bean.getN_opt_amt	());
			pstmt.setFloat (14, bean.getO_cls_per	());
			pstmt.setFloat (15, bean.getN_cls_per	());
			pstmt.setString (16, bean.getR_fee_est_dt	());			
			pstmt.setInt   (17, bean.getO_rtn_run_amt	());
			pstmt.setInt   (18, bean.getN_rtn_run_amt	());
			pstmt.setInt   (19, bean.getO_over_run_amt	());
			pstmt.setInt   (20, bean.getN_over_run_amt	());			
			pstmt.setString(21, bean.getIns_doc_no	());

		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[InsDatabase:updateInsChangeDoc]"+ e);
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
	public boolean insertInsChangeDocList(InsurChangeBean bean)
	{
		getConnection();
		boolean flag = true;
//		String query =  " insert into ins_change_doc_list"+
//						" (INS_DOC_NO, CAR_MNG_ID, INS_ST, CH_TM, CH_DT, CH_ITEM, CH_BEFORE, CH_AFTER, CH_AMT, REG_ID, REG_DT, rent_mng_id, rent_l_cd) values"+
//						" (?, ?, ?, ?, replace(?, '-', ''), ?, ?, ?, ?, ?, to_char(sysdate,'YYYYMMDD'), ?, ?)";

		String query =  " insert into ins_change_doc_list"+
						" (INS_DOC_NO, CH_TM, CH_ITEM, CH_BEFORE, CH_AFTER, CH_AMT) values"+
						" (?, ?, ?, ?, ?, ?)";
		
		PreparedStatement pstmt = null;
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, bean.getIns_doc_no());
//			pstmt.setString(2, bean.getCar_mng_id());
//			pstmt.setString(3, bean.getIns_st());
			pstmt.setString(2, bean.getCh_tm());
//			pstmt.setString(5, bean.getCh_dt());
			pstmt.setString(3, bean.getCh_item());
			pstmt.setString(4, bean.getCh_before());
			pstmt.setString(5, bean.getCh_after());
			pstmt.setInt   (6, bean.getCh_amt());
//			pstmt.setString(10,bean.getUpdate_id());
//			pstmt.setString(11,bean.getRent_mng_id());
//			pstmt.setString(12,bean.getRent_l_cd());
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[InsDatabase:insertInsChangeDocList]"+ e);
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
	public boolean updateInsChangeDocList(InsurChangeBean bean)
	{
		getConnection();
		boolean flag = true;

		String query =  " update ins_change_doc_list set "+
						"        CH_BEFORE	=?, "+
						"        CH_AFTER	=?, "+
						"        CH_amt		=?  "+
						" where ins_doc_no	=? and ch_tm = ? ";
		
		PreparedStatement pstmt = null;
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getCh_before	());
			pstmt.setString(2, bean.getCh_after		());
			pstmt.setInt   (3, bean.getCh_amt		());
			pstmt.setString(4, bean.getIns_doc_no	());
			pstmt.setString(5, bean.getCh_tm		());

		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[InsDatabase:updateInsChangeDocList]"+ e);
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
	 *	보험변경문서 삭제
	 */
	public boolean deleteInsChangeDoc(InsurChangeBean bean)
	{
		getConnection();
		boolean flag = true;

		String query1 =  " delete from ins_change_doc where ins_doc_no = ?";
		String query2 =  " delete from ins_change_doc_list where ins_doc_no = ?";
		String query3 =  " delete from doc_settle where doc_st='47' and doc_id  = ?";
		
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query1);
			pstmt.setString(1, bean.getIns_doc_no());
		    pstmt.executeUpdate();
			pstmt.close();

			pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString(1, bean.getIns_doc_no());
		    pstmt2.executeUpdate();
			pstmt2.close();

			pstmt3 = conn.prepareStatement(query3);
			pstmt3.setString(1, bean.getIns_doc_no());
		    pstmt3.executeUpdate();
			pstmt3.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[InsDatabase:deleteInsChangeDoc]"+ e);
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
	 *	보험변경문서 삭제
	 */
	public boolean deleteInsChangeDoc3(InsurChangeBean bean)
	{
		getConnection();
		boolean flag = true;

		String query1 =  " delete from ins_change_doc where ins_doc_no = ? and doc_st = '3'";
		String query3 =  " delete from doc_settle where doc_st='33' and doc_id  = ?";
		
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query1);
			pstmt.setString(1, bean.getIns_doc_no());
		    pstmt.executeUpdate();
			pstmt.close();

			pstmt2 = conn.prepareStatement(query3);
			pstmt2.setString(1, bean.getIns_doc_no());
		    pstmt2.executeUpdate();
			pstmt2.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[InsDatabase:deleteInsChangeDoc3]"+ e);
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
	 *	보험변경사항 리스트 조회
	 */
	public Vector getInsChangeDocList(String ins_doc_no)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	" select * from ins_change_doc_list "+
						" where ins_doc_no = ? order by ch_tm";
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, ins_doc_no);
		    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{				
				InsurChangeBean bean = new InsurChangeBean();
				bean.setIns_doc_no	(rs.getString("INS_DOC_NO")==null?"":rs.getString("INS_DOC_NO"));
//				bean.setCar_mng_id	(rs.getString("CAR_MNG_ID")==null?"":rs.getString("CAR_MNG_ID"));
//				bean.setIns_st		(rs.getString("INS_ST")==null?"":rs.getString("INS_ST"));
				bean.setCh_tm		(rs.getString("CH_TM")==null?"":rs.getString("CH_TM"));
//				bean.setCh_dt		(rs.getString("CH_DT")==null?"":rs.getString("CH_DT"));
				bean.setCh_item		(rs.getString("CH_ITEM")==null?"":rs.getString("CH_ITEM"));
				bean.setCh_before	(rs.getString("CH_BEFORE")==null?"":rs.getString("CH_BEFORE"));
				bean.setCh_after	(rs.getString("CH_AFTER")==null?"":rs.getString("CH_AFTER"));
				bean.setCh_amt		(rs.getInt("CH_AMT"));
//				bean.setReg_id		(rs.getString("REG_ID")==null?"":rs.getString("REG_ID"));
//				bean.setReg_dt		(rs.getString("REG_DT")==null?"":rs.getString("REG_DT"));
//				bean.setUpdate_id	(rs.getString("UPDATE_ID")==null?"":rs.getString("UPDATE_ID"));
//				bean.setUpdate_dt	(rs.getString("UPDATE_DT")==null?"":rs.getString("UPDATE_DT"));
//				bean.setRent_mng_id	(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
//				bean.setRent_l_cd	(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				vt.add(bean);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[InsDatabase:getInsChangeDocList]"+ e);
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


	public InsurChangeBean getInsChangeDoc(String ins_doc_no)
	{
		getConnection();
		InsurChangeBean bean = new InsurChangeBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	" select * from ins_change_doc "+
						" where ins_doc_no = ? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, ins_doc_no);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{
				bean.setIns_doc_no	(rs.getString("INS_DOC_NO")==null?"":rs.getString("INS_DOC_NO"));
				bean.setCar_mng_id	(rs.getString("CAR_MNG_ID")==null?"":rs.getString("CAR_MNG_ID"));
				bean.setIns_st		(rs.getString("INS_ST")==null?"":rs.getString("INS_ST"));
				bean.setCh_dt		(rs.getString("CH_DT")==null?"":rs.getString("CH_DT"));
				bean.setCh_etc		(rs.getString("CH_ETC")==null?"":rs.getString("CH_ETC"));
				bean.setO_fee_amt	(rs.getInt("O_FEE_AMT"));
				bean.setN_fee_amt	(rs.getInt("N_FEE_AMT"));
				bean.setD_fee_amt	(rs.getInt("D_FEE_AMT"));
				bean.setReg_id		(rs.getString("REG_ID")==null?"":rs.getString("REG_ID"));
				bean.setReg_dt		(rs.getString("REG_DT")==null?"":rs.getString("REG_DT"));
				bean.setUpdate_id	(rs.getString("UPDATE_ID")==null?"":rs.getString("UPDATE_ID"));
				bean.setUpdate_dt	(rs.getString("UPDATE_DT")==null?"":rs.getString("UPDATE_DT"));
				bean.setRent_mng_id	(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				bean.setRent_l_cd	(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				bean.setRent_st		(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				bean.setIns_doc_st	(rs.getString("INS_DOC_ST")==null?"":rs.getString("INS_DOC_ST"));
				bean.setReject_cau	(rs.getString("REJECT_CAU")==null?"":rs.getString("REJECT_CAU"));
				bean.setCh_st		(rs.getString("CH_ST")==null?"":rs.getString("CH_ST"));
				bean.setCh_s_dt		(rs.getString("CH_S_DT")==null?"":rs.getString("CH_S_DT"));
				bean.setCh_e_dt		(rs.getString("CH_E_DT")==null?"":rs.getString("CH_E_DT"));
				bean.setO_opt_amt	(rs.getInt("O_OPT_AMT"));
				bean.setN_opt_amt	(rs.getInt("N_OPT_AMT"));
				bean.setO_cls_per	(rs.getString("o_cls_per")==null?0:AddUtil.parseFloat(rs.getString("o_cls_per")));
				bean.setN_cls_per	(rs.getString("n_cls_per")==null?0:AddUtil.parseFloat(rs.getString("n_cls_per")));
				bean.setR_fee_est_dt(rs.getString("r_fee_est_dt")==null?"":rs.getString("r_fee_est_dt"));
				bean.setO_rtn_run_amt		(rs.getString("O_RTN_RUN_AMT")			==null?0:Integer.parseInt(rs.getString("O_RTN_RUN_AMT")));
				bean.setN_rtn_run_amt		(rs.getString("N_RTN_RUN_AMT")			==null?0:Integer.parseInt(rs.getString("N_RTN_RUN_AMT")));
				bean.setO_over_run_amt		(rs.getString("O_OVER_RUN_AMT")			==null?0:Integer.parseInt(rs.getString("O_OVER_RUN_AMT")));
				bean.setN_over_run_amt		(rs.getString("N_OVER_RUN_AMT")			==null?0:Integer.parseInt(rs.getString("N_OVER_RUN_AMT")));
				
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[InsDatabase:getInsChangeDoc]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
		                if(rs != null )		rs.close();
                		if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}
	}

	public InsurChangeBean getInsChangeDoc(String ins_doc_no, String doc_st)
	{
		getConnection();
		InsurChangeBean bean = new InsurChangeBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	" select * from ins_change_doc "+
						" where ins_doc_no = ? and doc_st = ? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, ins_doc_no);
			pstmt.setString(2, doc_st);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{
				bean.setIns_doc_no	(rs.getString("INS_DOC_NO")==null?"":rs.getString("INS_DOC_NO"));
				bean.setCar_mng_id	(rs.getString("CAR_MNG_ID")==null?"":rs.getString("CAR_MNG_ID"));
				bean.setIns_st		(rs.getString("INS_ST")==null?"":rs.getString("INS_ST"));
				bean.setCh_dt		(rs.getString("CH_DT")==null?"":rs.getString("CH_DT"));
				bean.setCh_etc		(rs.getString("CH_ETC")==null?"":rs.getString("CH_ETC"));
				bean.setO_fee_amt	(rs.getInt("O_FEE_AMT"));
				bean.setN_fee_amt	(rs.getInt("N_FEE_AMT"));
				bean.setD_fee_amt	(rs.getInt("D_FEE_AMT"));
				bean.setReg_id		(rs.getString("REG_ID")==null?"":rs.getString("REG_ID"));
				bean.setReg_dt		(rs.getString("REG_DT")==null?"":rs.getString("REG_DT"));
				bean.setUpdate_id	(rs.getString("UPDATE_ID")==null?"":rs.getString("UPDATE_ID"));
				bean.setUpdate_dt	(rs.getString("UPDATE_DT")==null?"":rs.getString("UPDATE_DT"));
				bean.setRent_mng_id	(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				bean.setRent_l_cd	(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				bean.setRent_st		(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				bean.setIns_doc_st	(rs.getString("INS_DOC_ST")==null?"":rs.getString("INS_DOC_ST"));
				bean.setReject_cau	(rs.getString("REJECT_CAU")==null?"":rs.getString("REJECT_CAU"));
				bean.setCh_st		(rs.getString("CH_ST")==null?"":rs.getString("CH_ST"));
				bean.setCh_s_dt		(rs.getString("CH_S_DT")==null?"":rs.getString("CH_S_DT"));
				bean.setCh_e_dt		(rs.getString("CH_E_DT")==null?"":rs.getString("CH_E_DT"));
				bean.setO_opt_amt	(rs.getInt("O_OPT_AMT"));
				bean.setN_opt_amt	(rs.getInt("N_OPT_AMT"));
				bean.setO_cls_per	(rs.getString("o_cls_per")==null?0:AddUtil.parseFloat(rs.getString("o_cls_per")));
				bean.setN_cls_per	(rs.getString("n_cls_per")==null?0:AddUtil.parseFloat(rs.getString("n_cls_per")));

			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[InsDatabase:getInsChangeDoc]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
		                if(rs != null )		rs.close();
                		if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}
	}

	public InsurChangeBean getInsChangeChk(InsurChangeBean d_bean, InsurChangeBean l_bean)
	{
		getConnection();
		InsurChangeBean bean = new InsurChangeBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String query = 	" select * from ins_change "+
						" where car_mng_id=? and ins_st=? and ch_dt=replace(?,'-','') and ch_item=? and ch_amt=?";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, d_bean.getCar_mng_id	());
			pstmt.setString(2, d_bean.getIns_st		());
			pstmt.setString(3, d_bean.getCh_dt		());
			pstmt.setString(4, l_bean.getCh_item	());
			pstmt.setInt   (5, l_bean.getCh_amt		());

	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{
				bean.setCar_mng_id	(rs.getString("CAR_MNG_ID")==null?"":rs.getString("CAR_MNG_ID"));
				bean.setIns_st		(rs.getString("INS_ST")==null?"":rs.getString("INS_ST"));
				bean.setCh_tm		(rs.getString("CH_TM")==null?"":rs.getString("CH_TM"));
				bean.setCh_dt		(rs.getString("CH_DT")==null?"":rs.getString("CH_DT"));
				bean.setCh_etc		(rs.getString("CH_ETC")==null?"":rs.getString("CH_ETC"));
				bean.setCh_item		(rs.getString("CH_ITEM")==null?"":rs.getString("CH_ITEM"));
				bean.setCh_before	(rs.getString("CH_BEFORE")==null?"":rs.getString("CH_BEFORE"));
				bean.setCh_after	(rs.getString("CH_AFTER")==null?"":rs.getString("CH_AFTER"));
				bean.setCh_amt		(rs.getInt("CH_AMT"));
				bean.setReg_id		(rs.getString("REG_ID")==null?"":rs.getString("REG_ID"));
				bean.setReg_dt		(rs.getString("REG_DT")==null?"":rs.getString("REG_DT"));
				bean.setUpdate_id	(rs.getString("UPDATE_ID")==null?"":rs.getString("UPDATE_ID"));
				bean.setUpdate_dt	(rs.getString("UPDATE_DT")==null?"":rs.getString("UPDATE_DT"));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[InsDatabase:getInsChangeChk]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
		                if(rs != null )		rs.close();
                		if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}
	}

	public InsurChangeBean getInsChange(String car_mng_id, String ins_st, String ch_tm)
	{
		getConnection();
		InsurChangeBean bean = new InsurChangeBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String query = 	" select * from ins_change "+
						" where car_mng_id=? and ins_st=? and ch_tm=? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
			pstmt.setString(2, ins_st);
			pstmt.setString(3, ch_tm);

	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{
				bean.setCar_mng_id	(rs.getString("CAR_MNG_ID")==null?"":rs.getString("CAR_MNG_ID"));
				bean.setIns_st		(rs.getString("INS_ST")==null?"":rs.getString("INS_ST"));
				bean.setCh_tm		(rs.getString("CH_TM")==null?"":rs.getString("CH_TM"));
				bean.setCh_dt		(rs.getString("CH_DT")==null?"":rs.getString("CH_DT"));
				//bean.setCh_etc		(rs.getString("CH_ETC")==null?"":rs.getString("CH_ETC"));
				bean.setCh_item		(rs.getString("CH_ITEM")==null?"":rs.getString("CH_ITEM"));
				bean.setCh_before	(rs.getString("CH_BEFORE")==null?"":rs.getString("CH_BEFORE"));
				bean.setCh_after	(rs.getString("CH_AFTER")==null?"":rs.getString("CH_AFTER"));
				bean.setCh_amt		(rs.getInt("CH_AMT"));
				bean.setReg_id		(rs.getString("REG_ID")==null?"":rs.getString("REG_ID"));
				bean.setReg_dt		(rs.getString("REG_DT")==null?"":rs.getString("REG_DT"));
				bean.setUpdate_id	(rs.getString("UPDATE_ID")==null?"":rs.getString("UPDATE_ID"));
				bean.setUpdate_dt	(rs.getString("UPDATE_DT")==null?"":rs.getString("UPDATE_DT"));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[InsDatabase:getInsChange]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
		                if(rs != null )		rs.close();
                		if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}
	}
	
	//procedure 실행
	
	
	//용도별 보험 갱신 기준 리스트
	public Vector getJipInsureCarUseList(String s_day, String car_use)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = " select a.* , b.car_no, b.car_num, a.car_cnt  * a.ins_amt ins_t_amt  from JIP_INSUR_CAR_USE a, car_reg b "+	
				" where a.car_mng_id = b.car_mng_id(+) and a.save_dt = '"+ s_day + "' and a.car_use ='"+car_use+"' order by a.s_st";


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
			
			System.out.println("[InsDatabase:getJipInsureCarUseList]"+ e);
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
     * 프로시져 호출
     */
    public String call_sp_jip_insur_car_use(String s_dt, String s_use) 
	{
		getConnection();

		CallableStatement cstmt = null;
		String sResult = "";
        

    	String query1 = "{CALL P_JIP_INSUR_CAR_USE     (?,?,?)}";

	    try{

			//회계처리 프로시저1 호출(조회등록)
			cstmt = conn.prepareCall(query1);				
			cstmt.setString(1, s_dt);
			cstmt.setString(2, s_use);
			cstmt.registerOutParameter(3, java.sql.Types.VARCHAR );
			cstmt.execute();
			sResult = cstmt.getString(3); // 결과값

			cstmt.close();

	  	} catch (Exception e) {
			System.out.println("[InsDatabase:call_sp_jip_insur_car_use]\n"+e);
			e.printStackTrace();
		} finally {
			try{
				if ( cstmt != null )	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}

	//보험관리 리스트 조회
	public Vector getInsRegExcelErrorList(String ins_start_dt, String car_use)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


			query = " SELECT a.car_mng_id, a.ins_st, a.ins_con_no, a.ins_start_dt, c.car_no, (a.rins_pcp_amt+a.vins_pcp_amt+a.vins_gcp_amt+a.vins_bacdt_amt+a.vins_canoisr_amt+a.vins_share_extra_amt+a.vins_cacdt_cm_amt+a.vins_spe_amt) tot_amt "+//-a.vins_blackbox_amt
					" FROM   INSUR a, SCD_INS b, CAR_REG c "+
					" WHERE  a.ins_start_dt='"+ins_start_dt+"' AND a.car_use='"+car_use+"' AND a.INS_ST<>'0' "+
					" AND a.car_mng_id=b.car_mng_id(+) AND a.INS_ST=b.ins_st(+) and b.car_mng_id is null  "+
					" AND a.car_mng_id=c.car_mng_id "+
					" ORDER BY a.ins_con_no "+
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
			System.out.println("[InsDatabase:getInsRegExcelErrorList]"+ e);
			System.out.println("[InsDatabase:getInsRegExcelErrorList]"+ query);
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
	 * 보험갱신 엑셀등록
	 */
	public boolean insertInsExcel(InsurExcelBean ins)
	{
		getConnection();
		boolean flag = true;
		String query = "insert into ins_excel (reg_code, seq, gubun,  "+
						" value01, value02, value03, value04, value05, value06, value07, value08, value09, value10, "+
						" value11, value12, value13, value14, value15, value16, value17, value18, value19, value20,  "+
			            " reg_id, reg_dt "+
						" ) values("+
						" ?, ?, ?, "+
						" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
						" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
						" ?, to_char(sysdate,'YYYYMMDD')  "+
						" )";

		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,  ins.getReg_code());
			pstmt.setInt	(2,  ins.getSeq		());
		    pstmt.setString	(3,  ins.getGubun	());
			pstmt.setString	(4,  ins.getValue01	());
			pstmt.setString	(5,  ins.getValue02	());
			pstmt.setString	(6,  ins.getValue03	());
			pstmt.setString	(7,  ins.getValue04	());
			pstmt.setString	(8,  ins.getValue05	());
			pstmt.setString	(9,  ins.getValue06	());
			pstmt.setString	(10, ins.getValue07	());
			pstmt.setString	(11, ins.getValue08	());
			pstmt.setString	(12, ins.getValue09	());
			pstmt.setString	(13, ins.getValue10	());
			pstmt.setString	(14, ins.getValue11	());
			pstmt.setString	(15, ins.getValue12	());
			pstmt.setString	(16, ins.getValue13	());
			pstmt.setString	(17, ins.getValue14	());
			pstmt.setString	(18, ins.getValue15	());
			pstmt.setString	(19, ins.getValue16	());
			pstmt.setString	(20, ins.getValue17	());
			pstmt.setString	(21, ins.getValue18	());
			pstmt.setString	(22, ins.getValue19	());
			pstmt.setString	(23, ins.getValue20	());			
			pstmt.setString	(24, ins.getReg_id	());			

			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[InsDatabase:insertInsExcel]"+ e);
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
	 * 보험변경 엑셀등록
	 */
	public boolean insertInsExcel2(InsurExcelBean ins)
	{
		getConnection();
		boolean flag = true;
		String query = "insert into ins_excel (reg_code, seq, gubun,  "+
						" value01, value02, value03, value04, value05, value06, value07, value08, value09, value10, "+
						" value11, value12, value13, value14, value15, value16, value17, value18, value19, value20,  "+
						" value21, value22, value23, value24, value25, value26, value27, value28, value29, value30,  "+
			            " reg_id, reg_dt "+
						" ) values("+
						" ?, ?, ?, "+
						" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
						" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
						" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
						" ?, to_char(sysdate,'YYYYMMDD')  "+
						" )";

		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,  ins.getReg_code());
			pstmt.setInt	(2,  ins.getSeq		());
		    pstmt.setString	(3,  ins.getGubun	());
			pstmt.setString	(4,  ins.getValue01	());
			pstmt.setString	(5,  ins.getValue02	());
			pstmt.setString	(6,  ins.getValue03	());
			pstmt.setString	(7,  ins.getValue04	());
			pstmt.setString	(8,  ins.getValue05	());
			pstmt.setString	(9,  ins.getValue06	());
			pstmt.setString	(10, ins.getValue07	());
			pstmt.setString	(11, ins.getValue08	());
			pstmt.setString	(12, ins.getValue09	());
			pstmt.setString	(13, ins.getValue10	());
			pstmt.setString	(14, ins.getValue11	());
			pstmt.setString	(15, ins.getValue12	());
			pstmt.setString	(16, ins.getValue13	());
			pstmt.setString	(17, ins.getValue14	());
			pstmt.setString	(18, ins.getValue15	());
			pstmt.setString	(19, ins.getValue16	());
			pstmt.setString	(20, ins.getValue17	());
			pstmt.setString	(21, ins.getValue18	());
			pstmt.setString	(22, ins.getValue19	());
			pstmt.setString	(23, ins.getValue20	());
			pstmt.setString	(24, ins.getValue21	());
			pstmt.setString	(25, ins.getValue22	());
			pstmt.setString	(26, ins.getValue23	());
			pstmt.setString	(27, ins.getValue24	());
			pstmt.setString	(28, ins.getValue25	());
			pstmt.setString	(29, ins.getValue26	());
			pstmt.setString	(30, ins.getValue27	());
			pstmt.setString	(31, ins.getValue28	());
			pstmt.setString	(32, ins.getValue29	());
			pstmt.setString	(33, ins.getValue30	());
			pstmt.setString	(34, ins.getReg_id	());			

			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[InsDatabase:insertInsExcel2]"+ e);
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

	//조건별 보험가입현황
	public Vector getInsureStatSearchList(String gubun1, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT car_use, con_f_nm,  "+
				"        DECODE(s_st_cd,'100, 101','승용소형A','102, 112','승용소형B','103','승용중형','104, 105','승용대형', "+
				"                       '400','5~6인승 짚 1600cc 이하','401','5~6인승 짚 2000cc 이하','402','5~6인승 짚 2000cc 초과', "+
				"                       '501','7인승 2000cc 이하','502','7인승 2000cc 초과', "+
				"                       '601, 602','9인승','700','11인승 승합','701','12인승 승합','702','경승합', "+
				"                       '803','1톤이하 밴형','801','1톤이하 일반형','802','경화물','811','2.5톤이하 화물','821','5톤이하 화물') gubun, "+
				"        DECODE(s_st_cd,'100, 101','올뉴모닝','102, 112','올뉴프라이드','103','K5','104, 105','제네시스', "+
				"                       '400','티볼리','401','투싼','402','싼타페2.2', "+
				"                       '501','싼타페2.0','502','모하비3.0', "+
				"                       '601, 602','카니발','700','카니발11','701','스타렉스12','702','다마스', "+
				"                       '803','그랜드스타렉스밴','801','포터','802','라보','811','마이티 2.5톤','821','메가트록 5톤') car, "+
				"        s_st_cd, "+
				"        COUNT(*) cnt, "+
				"        COUNT(DECODE(age_scp,'21세',car_use)) age_21_cnt, "+
				"        COUNT(DECODE(age_scp,'22세',car_use)) age_22_cnt, "+
				"        COUNT(DECODE(age_scp,'24세',car_use)) age_24_cnt, "+
				"        COUNT(DECODE(age_scp,'26세',car_use)) age_26_cnt, "+
				"        COUNT(DECODE(age_scp,'28세',car_use)) age_28_cnt, "+
				"        COUNT(DECODE(age_scp,'30세',car_use)) age_30_cnt, "+
				"        COUNT(DECODE(age_scp,'35세',car_use)) age_35_cnt, "+
				"        COUNT(DECODE(age_scp,'35~49세',car_use)) age_3549_cnt, "+
				"        COUNT(DECODE(age_scp,'43세',car_use)) age_43_cnt, "+
				"        COUNT(DECODE(age_scp,'48세',car_use)) age_48_cnt, "+
				"        COUNT(DECODE(age_scp,'기타',car_use)) age_etc_cnt, "+     
//				"        MAX(g_2) g_2, "+
//				"        trunc(AVG(DECODE(age_scp,'26세',g_2))) g_2, "+
//				"        trunc(AVG(DECODE(age_scp,'26세',case when car_use='1' and ins_start_dt >= to_char(sysdate-30,'YYYYMMDD') then g_2 when car_use='2' and ins_start_dt>= to_char(sysdate-90,'YYYYMMDD') then g_2 end))) g_2, "+
				"        MIN(car_nm)||' '||DECODE(MIN(car_nm),MAX(car_nm),'',Max(car_nm)) car_nm "+
				" FROM  "+
				" ( "+
				" SELECT b.car_use, B.CAR_NM,  "+
				"        DECODE(c.con_f_nm,'아마존카','아마존카','고객')  con_f_nm, "+
				"        decode(c.age_scp,'1','21세','2','26세','3','기타','4','24세','5','30세','6','35세','7','43세','8','48세','9','22세','10','28세','11','35~49세','기타') age_scp,         "+
				"        e.s_st,  "+
				"        DECODE(e.s_st,'100','100, 101','101','100, 101','409','100, 101','112','102, 112','102','102, 112','104','104, 105','105','104, 105','601','601, 602','602','601, 602','300','102, 112','301','103','302','104, 105',e.s_st) s_st_cd, \n"+
//				"        DECODE(b.car_use,'1',f2.g_2,f1.g_2) g_2 "+
//			    "        TRUNC((NVL(c.rins_pcp_amt,0)+NVL(c.vins_pcp_amt,0)+NVL(c.vins_gcp_amt,0)+NVL(c.vins_bacdt_amt,0)+NVL(c.vins_canoisr_amt,0)+NVL(c.vins_share_extra_amt,0)+NVL(c.vins_spe_amt,0))/TRUNC(TO_DATE(c.INS_EXP_DT,'YYYYMMDD')-TO_DATE(c.INS_START_DT,'YYYYMMDD'))*365) g_2 \n"+
			    "        CASE WHEN TRUNC(TO_DATE(c.INS_EXP_DT,'YYYYMMDD')-TO_DATE(c.INS_START_DT,'YYYYMMDD')) IN (366,365) THEN TRUNC((NVL(c.rins_pcp_amt,0)+NVL(c.vins_pcp_amt,0)+NVL(c.vins_gcp_amt,0)+NVL(c.vins_bacdt_amt,0)+NVL(c.vins_canoisr_amt,0)+NVL(c.vins_share_extra_amt,0)+NVL(c.vins_spe_amt,0))) \n"+
                "             ELSE TRUNC((NVL(c.rins_pcp_amt,0)+NVL(c.vins_pcp_amt,0)+NVL(c.vins_gcp_amt,0)+NVL(c.vins_bacdt_amt,0)+NVL(c.vins_canoisr_amt,0)+NVL(c.vins_share_extra_amt,0)+NVL(c.vins_spe_amt,0))/TRUNC(TO_DATE(c.INS_EXP_DT,'YYYYMMDD')-TO_DATE(c.INS_START_DT,'YYYYMMDD'))*365) \n"+
                "        END g_2, \n"+
				"        c.ins_start_dt "+
				" FROM   CONT a, CAR_REG b, INSUR c, CAR_ETC d, CAR_NM e  "+
//				"        (SELECT aa.* FROM ESTI_CAR_VAR aa, (SELECT a_e, a_a, max(seq) seq FROM ESTI_CAR_VAR WHERE a_a='1' GROUP BY a_e, a_a) bb WHERE aa.a_a='1' AND aa.a_e=bb.a_e AND aa.a_a=bb.a_a AND aa.seq=bb.seq) f1, "+
//				"        (SELECT aa.* FROM ESTI_CAR_VAR aa, (SELECT a_e, a_a, max(seq) seq FROM ESTI_CAR_VAR WHERE a_a='2' GROUP BY a_e, a_a) bb WHERE aa.a_a='2' AND aa.a_e=bb.a_e AND aa.a_a=bb.a_a AND aa.seq=bb.seq) f2 "+
				" WHERE  nvl(a.use_yn,'Y')='Y' and a.rent_l_cd not like 'RM%' "+
				"        AND a.car_mng_id=b.car_mng_id AND nvl(b.prepare,'0')<>'4' "+
				"        AND b.car_mng_id=c.car_mng_id AND c.ins_sts='1' and c.ins_exp_dt>= to_char(sysdate,'YYYYMMDD') and c.rins_pcp_amt > 0 "+
				" ";

		if(!gubun1.equals(""))			query += " and b.car_use='"+gubun1+"' ";

		if(gubun2.equals("1"))			query += " and c.con_f_nm like '%아마존카%'";
		if(gubun2.equals("2"))			query += " and c.con_f_nm not like '%아마존카%'";


		query +="        AND a.rent_mng_id=d.rent_mng_id AND a.rent_l_cd=d.rent_l_cd "+
				"        AND d.car_id=e.car_id AND d.car_seq=e.car_seq  "+
//				"        AND e.s_st=f1.a_e "+
//				"        AND e.s_st=f2.a_e "+
				" ) "+
				" GROUP BY car_use, con_f_nm, s_st_cd "+
				" ORDER BY car_use, con_f_nm, s_st_cd  \n"+
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

//			System.out.println("[InsDatabase:getInsureStatSearchList]\n"+query);
		} catch (SQLException e) {
			System.out.println("[InsDatabase:getInsureStatSearchList]\n"+e);
			System.out.println("[InsDatabase:getInsureStatSearchList]\n"+query);
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

	//조건별 보험가입현황
	public Vector getInsureStatSearchList(String gubun1, String gubun2, String s_st, String age_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT b.car_no, b.car_use, B.CAR_NM,  "+
				"        DECODE(c.con_f_nm,'아마존카','아마존카','고객')  con_f_nm, c.conr_nm, f.ins_com_nm, "+
				"        decode(c.age_scp,'1','21세','2','26세','3','기타','4','24세','5','30세','6','35세','7','43세','8','48세','9','22세','10','28세','11','35~49세','기타') age_scp,         "+
				"        e.s_st,  "+
				"        DECODE(e.s_st,'100','100, 101','101','100, 101','409','100, 101','112','102, 112','102','102, 112','104','104, 105','105','104, 105','601','601, 602','602','601, 602','300','102, 112','301','103','302','104, 105',e.s_st) s_st_cd, \n"+
			    "        CASE WHEN TRUNC(TO_DATE(c.INS_EXP_DT,'YYYYMMDD')-TO_DATE(c.INS_START_DT,'YYYYMMDD')) IN (366,365) THEN NVL(c.rins_pcp_amt,0)+NVL(c.vins_pcp_amt,0)+NVL(c.vins_gcp_amt,0)+NVL(c.vins_bacdt_amt,0)+NVL(c.vins_canoisr_amt,0)+NVL(c.vins_share_extra_amt,0)+NVL(c.vins_spe_amt,0) \n"+
                "             ELSE TRUNC((NVL(c.rins_pcp_amt,0)+NVL(c.vins_pcp_amt,0)+NVL(c.vins_gcp_amt,0)+NVL(c.vins_bacdt_amt,0)+NVL(c.vins_canoisr_amt,0)+NVL(c.vins_share_extra_amt,0)+NVL(c.vins_spe_amt,0))/TRUNC(TO_DATE(c.INS_EXP_DT,'YYYYMMDD')-TO_DATE(c.INS_START_DT,'YYYYMMDD'))*365) \n"+
                "        END g_2, \n"+
                "        c.INS_START_DT, c.INS_EXP_DT, \n"+
				"        TRUNC(TO_DATE(c.INS_EXP_DT,'YYYYMMDD')-TO_DATE(c.INS_START_DT,'YYYYMMDD')) as ins_days, "+
				"        NVL(c.rins_pcp_amt,0)+NVL(c.vins_pcp_amt,0)+NVL(c.vins_gcp_amt,0)+NVL(c.vins_bacdt_amt,0)+NVL(c.vins_canoisr_amt,0)+NVL(c.vins_share_extra_amt,0)+NVL(c.vins_spe_amt,0) as ins_amt "+
				" FROM   CONT a, CAR_REG b, INSUR c, CAR_ETC d, CAR_NM e, ins_com f  "+
				" WHERE  nvl(a.use_yn,'Y')='Y' and a.rent_l_cd not like 'RM%' "+
				"        AND a.car_mng_id=b.car_mng_id AND nvl(b.prepare,'0')<>'4' "+
				"        AND b.car_mng_id=c.car_mng_id AND c.ins_sts='1' and c.ins_exp_dt>= to_char(sysdate,'YYYYMMDD') and c.rins_pcp_amt > 0 "+
				" ";

		if(!gubun1.equals(""))			query += " and b.car_use='"+gubun1+"' ";

		if(gubun2.equals("1"))			query += " and c.con_f_nm like '%아마존카%'";
		if(gubun2.equals("2"))			query += " and c.con_f_nm not like '%아마존카%'";

		if(!s_st.equals(""))			query += " and DECODE(e.s_st,'100','100, 101','101','100, 101','409','100, 101','112','102, 112','102','102, 112','104','104, 105','105','104, 105','601','601, 602','602','601, 602','300','102, 112','301','103','302','104, 105',e.s_st)='"+s_st+"'";

		if(!age_st.equals(""))			query += " and c.age_scp='"+age_st+"' ";


		query +="        AND a.rent_mng_id=d.rent_mng_id AND a.rent_l_cd=d.rent_l_cd "+
				"        AND d.car_id=e.car_id AND d.car_seq=e.car_seq and c.ins_com_id=f.ins_com_id  "+
				" ORDER BY f.ins_com_nm, c.ins_start_dt  \n"+
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

//			System.out.println("[InsDatabase:getInsureStatSearchList]\n"+query);
		} catch (SQLException e) {
			System.out.println("[InsDatabase:getInsureStatSearchList]\n"+e);
			System.out.println("[InsDatabase:getInsureStatSearchList]\n"+query);
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


	//차량별 블랙박스 정보
	public Hashtable getCarBlackBox(String car_mng_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
					
		query = " SELECT DISTINCT a.car_mng_id, b.tint_no, b.com_nm, b.model_nm, b.serial_no, b.sup_dt "+
				" FROM   CONT a, CAR_TINT b "+
				" WHERE  a.car_mng_id='"+car_mng_id+"' "+
				"        AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd= b.rent_l_cd  "+
				"        AND b.tint_st='3' and b.tint_yn='Y'  "+
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
			System.out.println("[InsDatabase:getCarBlackBox]"+ e);
			System.out.println("[InsDatabase:getCarBlackBox]"+ query);
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




	//보험갱신 엑셀등록
	public String call_sp_ins_excel(String reg_code)
	{
		getConnection();

		CallableStatement cstmt = null;
		String sResult = "";
        
    	String query1 = "{CALL P_INS_EXCEL     (?)}";
		
		try {

			//회계처리 프로시저1 호출(조회등록)
			cstmt = conn.prepareCall(query1);				
			cstmt.setString(1, reg_code);
			cstmt.execute();
			cstmt.close();

		} catch (SQLException e) {
			System.out.println("[InsDatabase:call_sp_ins_excel]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
		                if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}	
	//보험변경 엑셀등록
	public String call_sp_ins_excel_change(String reg_code)
	{
		getConnection();

		CallableStatement cstmt = null;
		String sResult = "";
        
    	String query1 = "{CALL P_INS_EXCEL_CHANGE     (?)}";
		
		try {

			//회계처리 프로시저1 호출(조회등록)
			cstmt = conn.prepareCall(query1);				
			cstmt.setString(1, reg_code);
			cstmt.execute();
			cstmt.close();

		} catch (SQLException e) {
			System.out.println("[InsDatabase:call_sp_ins_excel_change]"+ e);
	  		e.printStackTrace();
	  		sResult="fail";
		} finally {
			try{
		                if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}	

	//보험변경 엑셀등록
	public String call_sp_ins_excel_change_new(String reg_code)
	{
		getConnection();

		CallableStatement cstmt = null;
		String sResult = "";
        
    	String query1 = "{CALL P_INS_EXCEL_CHANGE_NEW     (?)}";
		
		try {

			//회계처리 프로시저1 호출(조회등록)
			cstmt = conn.prepareCall(query1);				
			cstmt.setString(1, reg_code);
			cstmt.execute();
			cstmt.close();

		} catch (SQLException e) {
			System.out.println("[InsDatabase:call_sp_ins_excel_change_new]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
		                if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}	
	//보험신규 엑셀등록
	public String call_sp_ins_excel_new(String reg_code)
	{
		getConnection();

		CallableStatement cstmt = null;
		String sResult = "";
        
    	String query1 = "{CALL P_INS_EXCEL_NEW     (?)}";
		
		try {

			//회계처리 프로시저1 호출(조회등록)
			cstmt = conn.prepareCall(query1);				
			cstmt.setString(1, reg_code);
			cstmt.execute();
			cstmt.close();

		} catch (SQLException e) {
			System.out.println("[InsDatabase:call_sp_ins_excel_new]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
		                if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}	

	//보험해지 엑셀등록
	public String call_sp_ins_excel_cls(String reg_code)
	{
		getConnection();

		CallableStatement cstmt = null;
		String sResult = "";
        
    	String query1 = "{CALL P_INS_EXCEL_CLS     (?)}";
		
		try {

			//회계처리 프로시저1 호출(조회등록)
			cstmt = conn.prepareCall(query1);				
			cstmt.setString(1, reg_code);
			cstmt.execute();
			cstmt.close();

		} catch (SQLException e) {
			System.out.println("[InsDatabase:call_sp_ins_excel_cls]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
		                if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}	


	//보험관리 리스트 조회
	public Vector getInsClsMngList(String car_mng_id, String ins_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
			query = " select * from "+
					" ( "+
					//용도변경
					"	select "+
					"	       f.car_mng_id, f.ins_st, a.car_no, a.car_nm, '1' as gubun1, '용도변경' as cau,"+
					"	       c.car_no as be_car_no, c.cha_seq as be_seq, b.car_no as af_car_no, b.cha_seq as af_seq, "+
					"	       b.cha_dt as ch_dt, '' migr_dt,"+
					"	       b.cha_cau_sub as ch_sub,"+
					"	       d.exp_st, d.exp_aim, d.exp_dt, d.req_dt, d.rtn_est_amt, d.rtn_amt, d.rtn_dt, e.pay_dt, e.pay_amt,"+
					"	       '' as stat, decode(f.ins_st,'','미가입','가입') ins_stat, i.ins_com_nm "+
					"	from   car_reg a, car_change b, car_change c, (select * from ins_cls where exp_st in ('1','2') and exp_aim in ('1','2','9')) d, "+
					"		   (select car_mng_id, ins_st, pay_dt, pay_amt from scd_ins where ins_tm2='2') e, "+
					"	       (select car_mng_id, max(TO_NUMBER(ins_st)) ins_st from insur group by car_mng_id) f, INSUR h, INS_COM i "+
					"	where "+
					"	       a.car_mng_id='"+car_mng_id+"' and a.car_mng_id=b.car_mng_id and b.cha_cau='2' "+
					"	       and b.car_mng_id=c.car_mng_id and c.cha_seq=b.cha_seq-1 "+
					"	       and b.car_mng_id=d.car_mng_id(+) "+
					"	       and b.cha_dt=d.exp_dt(+) "+
					"	       and d.car_mng_id=e.car_mng_id(+) and d.ins_st=e.ins_st(+) "+
					"	       and a.car_mng_id=f.car_mng_id"+
                    "          AND f.car_mng_id=h.car_mng_id AND f.ins_st=h.ins_st AND h.ins_com_id=i.ins_com_id "+  
					"          and h.car_mng_id='"+car_mng_id+"' and h.ins_st='"+ins_st+"' "+
					"	union all"+
					//매각
					"	select "+
					"	       g.car_mng_id, g.ins_st, c.car_no, c.car_nm, decode(b.cls_st,'6','2','8','3','9','4') gubun1, decode(b.cls_st,'6','매각','8','매입옵션','9','폐차') cau, "+
					"	       ''  as be_car_no, '' as be_seq, '' as af_car_no, '' as af_seq, "+
					"	       NVL(d.migr_dt,nvl(d.cont_dt,b.cls_dt)) ch_dt, d.migr_dt,"+
					"	       decode(d.migr_dt, '', decode(d.cont_dt,'', '해지일', '계약일'), '명의이전일') ch_sub,"+
					"	       e.exp_st, e.exp_aim, e.exp_dt, e.req_dt, e.rtn_est_amt, e.rtn_amt, e.rtn_dt, f.pay_dt, f.pay_amt,"+
					"	       decode(d.car_mng_id,'','미등록','등록') stat, decode(g.ins_st,'','미가입','가입') ins_stat, i.ins_com_nm "+
					"	from   cont a, cls_cont b, car_reg c, sui d, (select * from ins_cls where exp_st='3' and exp_aim in ('3','5')) e, "+
					"	       (select car_mng_id, ins_st, pay_dt, pay_amt from scd_ins where ins_tm2='2') f, "+
					"	       (select car_mng_id, max(TO_NUMBER(ins_st)) ins_st from insur group by car_mng_id) g, INSUR h, INS_COM i "+
					"	where "+
					"	       a.car_mng_id='"+car_mng_id+"' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.cls_st in ('6','8','9') "+
					"	       and a.car_mng_id=c.car_mng_id "+
					"	       and a.car_mng_id=e.car_mng_id(+) "+
					"	       and a.car_mng_id=d.car_mng_id(+) "+
					"	       and e.car_mng_id=f.car_mng_id(+) and e.ins_st=f.ins_st(+) "+
					"	       and a.car_mng_id=g.car_mng_id"+
                    "          AND g.car_mng_id=h.car_mng_id AND g.ins_st=h.ins_st AND h.ins_com_id=i.ins_com_id and h.ins_com_id<>'0031' "+  
                    "          AND NVL(d.migr_dt,nvl(d.cont_dt,b.cls_dt)) > h.ins_start_dt AND NVL(d.migr_dt,nvl(d.cont_dt,b.cls_dt)) < h.ins_exp_dt "+
					"          and h.car_mng_id='"+car_mng_id+"' and h.ins_st='"+ins_st+"' "+
					" )"+
					" ";

			query += " order by ch_dt desc";


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
			System.out.println("[InsDatabase:getInsClsMngList(String car_mng_id, String ins_st)]"+ e);
			System.out.println("[InsDatabase:getInsClsMngList(String car_mng_id, String ins_st)]"+ query);
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

	//고객피보험자 고객동의 처리 메시지 발송 및 전자문서 등록
	public String call_sp_ins_day_msg()
	{
		getConnection();

		CallableStatement cstmt = null;
		String sResult = "";
        
    	String query1 = "{CALL P_INS_DAY_MSG }";
		
		try {

			//회계처리 프로시저1 호출(조회등록)
			cstmt = conn.prepareCall(query1);				
			cstmt.execute();
			cstmt.close();

		} catch (SQLException e) {
			System.out.println("[InsDatabase:call_sp_ins_day_msg]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
		                if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}
	


	//임직원 전용 자동차 보험 가입 요청서에서 정보가져오기
	public Vector getIjwList(String client_id, String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = "   SELECT d.car_no, D.CAR_NM, c.car_name, g.client_id, g.firm_nm, g.client_nm user_nm, l.ins_exp_dt, l.com_emp_yn, nvl(g.enp_no,'') AS enp_no \r\n" + 
				"	FROM   cont b, car_reg d, car_etc e, car_nm c, client g, (select * from insur where ins_sts='1') l, CONT_ETC h  \r\n" + 
				"	WHERE nvl(b.use_yn,'Y')='Y' AND b.car_st IN ('1','3','4','5') AND b.client_id<>'000228' \r\n" + 
				"	and ((to_number(replace(d.dpm,' ','')) > 1000 ) OR d.fuel_kd IN ('7','8','9','10')) \r\n" + 
				"	and d.taking_p < 9 \r\n" + 
				"	and c.car_name not like '%9인승%' \r\n" + 
				"	and c.s_st < '600' \r\n" + 
				//"	AND nvl(h.COM_EMP_YN,'N') ='N'\r\n" + 
				"	and b.car_mng_id=d.car_mng_id \r\n" + 
				"	and b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd \r\n" + 
				"	and e.car_id=c.CAR_ID and e.car_seq=c.car_seq \r\n" + 
				"	AND b.rent_mng_id=h.rent_mng_id and b.rent_l_cd=h.rent_l_cd\r\n" + 
				"	and b.client_id=g.client_id \r\n" + 
				"	and l.ins_exp_dt >= to_char(sysdate,'YYYYMMDD') \r\n" + 
				"	and b.car_mng_id=l.car_mng_id \r\n"+
				"   and g.client_id <> '055862' \r\n";
				

		query += " and g.client_id='"+client_id+"'";
		if(!rent_l_cd.equals("")) {
			query += " and b.rent_l_cd='"+rent_l_cd+"'";	
		}
		query += " order by l.ins_exp_dt";

		

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
			System.out.println("[InsDatabase:getIjwList(String client_id)]"+ e);
			System.out.println("[InsDatabase:getIjwList(String client_id)]"+ query);
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
	
	//임직원 전용 자동차 보험 가입 요청서에서 정보가져오기
		public Vector getIjwList2(String client_id, String car_mng_id, String com_emp_yn, String rent_l_cd)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Vector vt = new Vector();
			String query = "";

			query = "   SELECT d.car_no, D.CAR_NM, c.car_name, g.client_id, g.firm_nm, g.client_nm user_nm, nvl(g.enp_no,'') AS enp_no, nvl(g.firm_nm,'') AS firm_nm, l.ins_exp_dt, l.com_emp_yn \r\n" + 
					"	FROM   cont b, car_reg d, car_etc e, car_nm c, client g, (select * from insur where ins_sts='1') l, CONT_ETC h  \r\n" + 
					"	WHERE nvl(b.use_yn,'Y')='Y' AND b.car_st IN ('1','3','4','5') AND b.client_id<>'000228' \r\n" + 
					"	and ((to_number(replace(d.dpm,' ','')) > 1000 ) OR d.fuel_kd IN ('7','8','9','10')) \r\n" + 
					"	and d.taking_p < 9 \r\n" + 
					"	and c.car_name not like '%9인승%' \r\n" + 
					"	and c.s_st < '600' \r\n" + 
					//"	AND nvl(h.COM_EMP_YN,'N') ='N'\r\n" + 
					"	and b.car_mng_id=d.car_mng_id \r\n" + 
					"	and b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd \r\n" + 
					"	and e.car_id=c.CAR_ID and e.car_seq=c.car_seq \r\n" + 
					"	AND b.rent_mng_id=h.rent_mng_id and b.rent_l_cd=h.rent_l_cd\r\n" + 
					"	and b.client_id=g.client_id \r\n" + 
					"	and l.ins_exp_dt >= to_char(sysdate,'YYYYMMDD') \r\n" + 
					"	and b.car_mng_id=l.car_mng_id  \r\n"+
					"   and g.client_id <> '055862' \r\n";
					
			
			query += " and g.client_id='"+client_id+"'";
			
			if(!car_mng_id.equals("")) {
				query += " and d.car_mng_id='"+car_mng_id+"'";
			}
			
			if(!com_emp_yn.equals("")) {
				query += "  AND nvl(h.COM_EMP_YN,'N') ='"+com_emp_yn+"'";
			}
			if(!rent_l_cd.equals("")) {
				query += " and b.rent_l_cd='"+rent_l_cd+"'";	
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
				System.out.println("[InsDatabase:getIjwList(String client_id)]"+ e);
				System.out.println("[InsDatabase:getIjwList(String client_id)]"+ query);
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
	public Vector getInsStatList1_excel(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc, String s_st, String mod_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String r_query = "";

		query = " select a.ins_start_dt, a.ins_exp_dt, i.taking_p, nvl(t.enp_no, TEXT_DECRYPT(t.ssn, 'pw' ) ) as enp_no,  c.rent_start_dt, c.rent_end_dt, a.car_mng_id, c.rent_mng_id, c.rent_l_cd, c.firm_nm, c.use_yn, a.con_f_nm, \n"+
				" i.car_no, i.car_nm, d.car_name, i.car_num, i.init_reg_dt, \n"+
				" f.ins_com_nm, a.ins_st, a.ins_con_no, h.migr_dt, decode(cc.cls_st,'8',cc.cls_dt) cls_dt, \n"+ 
				" (decode(a.air_ds_yn,'Y',1,0)+decode(a.air_as_yn,'Y',1,0)) as air,\n"+
				" decode(a.auto_yn,'Y',1,0) as auto,\n"+
				" decode(a.abs_yn,'Y',1,0) as abs,\n"+
				" decode(a.blackbox_yn,'Y',1,0) as blackbox,\n"+
				" decode(a.age_scp,'1','21세이상','2','26세이상','3','모든운전자','4','24세이상','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하') as age_scp,\n"+
				" decode(a.ins_kd,'2','책임보험', '종합보험') as ins_kd,\n"+
				" decode(a.ins_sts,'1','유효', '2','만료', '3','중도해지','5','승계') as ins_sts,\n"+
				" decode(a.car_use,'1','영업용','2','업무용','3','개인용') car_use,"+
				" decode(a.vins_gcp_kd,'1','3000만원','2','1500만원','3','1억원','4','5000만원','5','1000만원','6','5억원', '7','2억원', '8','3억원','9','10억원') vins_gcp_kd,"+
				" decode(a.vins_bacdt_kd,'1','3억원','2','1억5천만원','3','3000만원','4','1500만원','5','5000만원','6','1억원') vins_bacdt_kd,"+
				" decode(a.vins_bacdt_kc2,'1','3억원','2','1억5천만원','3','3000만원','4','1500만원','5','5000만원','6','1억원') vins_bacdt_kc2,"+
				" decode(a.vins_canoisr_amt,0,'미가입','가입') vins_canoisr,"+
				" decode(a.vins_share_extra_amt,0,'미가입','가입') vins_share_extra,"+
				" decode(a.vins_cacdt_cm_amt,0,'미가입','가입') vins_cacdt,"+
				" decode(a.vins_spe_amt,0,'미가입','가입') vins_spe,"+
				" decode(a.vins_canoisr_amt,0,'N','Y') vins_canoisr2,"+
				" decode(a.vins_share_extra_amt,0,'N','Y') vins_share_extra2,"+
				" decode(a.vins_cacdt_cm_amt,0,'N','Y') vins_cacdt2,"+
				" decode(a.vins_spe_amt,0,'N','Y') vins_spe2, \n"+
			    " b.nm as car_kd, "+
				" mod(ROWNUM,"+mod_st+") mod_st, "+
				" decode(a.com_emp_yn,'Y','가입','N','미가입','') com_emp_yn "+
				" from (select * from insur where (car_mng_id, ins_st) in (select car_mng_id, max(TO_NUMBER(ins_st)) ins_st from insur where ins_sts='1' group by car_mng_id)) a,  \n"+
				"      cont_n_view c, cls_cont cc,  car_etc ce, \n"+
				"      ins_com f, sui h, car_reg i, ins_cls l, car_nm d, client t, \n"+
				"      (select * from code where c_st='0041') b \n"+
				" where \n"+
				" a.car_mng_id=c.car_mng_id(+)\n"+
				" and decode(c.use_yn,'Y','Y','','Y',decode(cc.cls_st,'8','Y','N'))='Y'\n"+//살아있거나 매입옵션 명의이전인 차량
				" and a.ins_com_id=f.ins_com_id"+
				" and a.car_mng_id=h.car_mng_id(+) and a.car_mng_id=i.car_mng_id(+) "+
				" and nvl(i.prepare,'0')<>'4'"+ //말소차량제외
				" and a.car_mng_id=l.car_mng_id(+) and a.ins_st=l.ins_st(+) "+
				" and c.rent_mng_id = ce.rent_mng_id(+) and c.rent_l_cd =ce.rent_l_cd(+)  \n"+
				" and ce.car_id=d.car_id(+) and ce.car_seq=d.car_seq(+) and c.client_id = t.client_id "+
				" and c.rent_mng_id = cc.rent_mng_id(+) and c.rent_l_cd =cc.rent_l_cd(+) and i.car_kd=b.nm_cd \n"+
				" ";

			if(gubun2.equals("6")){
				query += " and a.ins_start_dt like to_char(sysdate,'YYYYMM')||'%'";
			}else{
				query += " and l.car_mng_id is null"; 
				query += " and nvl(h.migr_dt,a.ins_exp_dt) >= a.ins_exp_dt"; 
			}


			if(gubun1.equals("1"))		query += " and a.car_use='1'"; 
			if(gubun1.equals("2"))		query += " and a.car_use<>'1'";

			if(gubun2.equals("1"))		query += " and a.ins_exp_dt < to_char(sysdate,'YYYYMMDD')";
			if(gubun2.equals("2"))		query += " and a.ins_exp_dt between to_char(sysdate-30,'YYYYMMDD') and to_char(sysdate+30,'YYYYMMDD')";
			if(gubun2.equals("3"))		query += " and a.ins_exp_dt like to_char(sysdate,'YYYYMM')||'%'";
			if(gubun2.equals("4"))		query += " and a.ins_exp_dt like to_char(add_months(sysdate,1), 'YYYYMM')||'%'";

			if(!brch_id.equals("S1") && !brch_id.equals(""))		query += " and c.brch_id = '"+brch_id+"'"; 
			if(brch_id.equals("S1"))								query += " and c.brch_id in ('S1','K1','K2')"; 

			if(gubun3.equals("1"))		query += " and i.car_kd in ('1','2','3','9') and to_number(i.dpm) between 801 and 1000 ";
			if(gubun3.equals("2"))		query += " and i.car_kd in ('1','2','3','9') and to_number(i.dpm) between 1501 and 1600 ";
			if(gubun3.equals("3"))		query += " and i.car_kd in ('1','2','3','9') and to_number(i.dpm) between 1901 and 2000 ";
			if(gubun3.equals("4"))		query += " and i.car_kd in ('1','2','3','9') and to_number(i.dpm) between 2001 and 2800 ";
			if(gubun3.equals("5"))		query += " and i.car_kd in ('1','2','3','9') and to_number(i.dpm) >= 2801 ";
			if(gubun3.equals("6"))		query += " and i.taking_p=7";
			if(gubun3.equals("7"))		query += " and i.taking_p between 8 and 10";
			if(gubun3.equals("8"))		query += " and i.taking_p=11";
			if(gubun3.equals("9"))		query += " and i.taking_p=12";
			if(gubun3.equals("10"))		query += " and i.car_kd in ('6','7','8') and i.car_nm||d.car_name like '%밴%'";
			if(gubun3.equals("11"))		query += " and i.car_kd in ('6','7','8') and i.car_nm||d.car_name not like '%밴%'";
			if(gubun3.equals("01"))		query += " and a.con_f_nm like '%아마존카%'";
			if(gubun3.equals("02"))		query += " and a.con_f_nm not like '%아마존카%'";

			if(gubun3.length()==3)		query += " and d.s_st='"+gubun3+"'";



			if(!t_wd.equals("")){
				if(s_kd.equals("1"))			query += " and nvl(c.firm_nm,c.client_nm) like '%"+t_wd+"%'\n";			
				else if(s_kd.equals("4"))		query += " and upper(c.rent_l_cd) like upper('%"+t_wd+"%')\n";
				else if(s_kd.equals("2"))		query += " and (i.car_no like '%"+t_wd+"%' or i.first_car_no like '%"+t_wd+"%')\n";
				else if(s_kd.equals("5"))		query += " and i.car_nm||d.car_name like '%"+t_wd+"%'\n";
				else if(s_kd.equals("3"))		query += " and upper(i.car_num) like upper('%"+t_wd+"%')\n";
				else if(s_kd.equals("6"))		query += " and b.nm like upper('%"+t_wd+"%')\n";
				else if(s_kd.equals("7"))		query += " and a.ins_exp_dt like '"+t_wd+"%'\n";
			}

			query += " ORDER BY 1, 2, 4 \n";

			
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

		//	System.out.println("[InsDatabase:getInsStatList1_excel]"+ query);

		} catch (SQLException e) {
			
			System.out.println("[InsDatabase:getInsStatList1_excel]"+ e);
			System.out.println("[InsDatabase:getInsStatList1_excel]"+ query);
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
	public Vector getInsComempNotStatList(String s_kd, String t_wd, String gubun1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String r_query = "";

		query = " --임직원운전한정특약 대상 계약 리스트 - 법인고객 \n"+
                " SELECT \n"+
                "        '1' st, b.rent_mng_id, b.rent_l_cd, b.rent_start_dt, b.rent_end_dt, d.car_no, m.car_nm, c.car_name, \n"+
				"        g.enp_no, g.client_id, g.firm_nm, j.user_nm bus_nm, k.user_nm bus_nm2, b.bus_id, b.bus_id2, \n"+
				"        l.ins_start_dt, l.ins_exp_dt, g.con_agnt_email, n.ins_com_nm, \n"+
				"        decode(a.com_emp_yn,'Y','가입','N','미가입','') cont_com_emp_yn,  \n"+
				"        decode(l.com_emp_yn,'Y','가입','N','미가입','') ins_com_emp_yn  \n"+
				" from   cont b, car_reg d, car_etc e, car_nm c, client g, sui i, users j, users k, (select * from insur where ins_sts='1') l, cont_etc a, car_mng m, ins_com n \n"+
				" where \n"+
				"        nvl(b.use_yn,'Y')='Y' AND b.car_st IN ('1','3') \n"+
				"        and to_number(replace(d.dpm,' ','')) > 1000 \n"+
                "        and d.taking_p < 9 \n"+
                "        and c.car_name not like '%9인승%' \n"+
				"        and c.s_st < '600' \n"+
                "        AND g.client_st='1' and nvl(g.firm_type,'0')<>'10' \n"+
				"        and b.car_mng_id=d.car_mng_id \n"+
				"        and b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd \n"+
				"        and e.car_id=c.CAR_ID and e.car_seq=c.car_seq and c.car_comp_id=m.car_comp_id and c.car_cd=m.code \n"+
				"        and b.client_id=g.client_id \n"+
				"        and b.car_mng_id=i.car_mng_id(+) and i.car_mng_id is NULL \n"+
				"        and b.bus_id=j.user_id and b.bus_id2=k.user_id \n"+
				"        and d.car_mng_id=l.car_mng_id \n"+
			    "        AND l.ins_com_id=n.ins_com_id(+) \n"+
				"        and b.rent_mng_id=a.rent_mng_id and b.rent_l_cd=a.rent_l_cd \n"+
				"        and nvl(l.com_emp_yn,'N')='N' \n"+
                " UNION all \n"+
                " --보유차 업무대여 - 아마존카 임직원 \n"+
                " SELECT \n"+
                "        '2' st, b.rent_mng_id, b.rent_l_cd, substr(f.deli_dt,1,8) rent_start_dt, '' rent_end_dt, d.car_no, d.car_nm, c.car_name, \n"+
				"        g.enp_no, g.client_id, g.firm_nm||':'||h.user_nm firm_nm, h.user_nm bus_nm, h.user_nm bus_nm2, h.user_id bus_id, h.user_id bus_id2, \n"+
				"        l.ins_start_dt, l.ins_exp_dt, '' con_agnt_email, n.ins_com_nm, \n"+
				"        decode(a.com_emp_yn,'Y','가입','N','미가입','') cont_com_emp_yn,  \n"+
				"        decode(l.com_emp_yn,'Y','가입','N','미가입','') ins_com_emp_yn  \n"+
				" from   cont b, car_reg d, car_etc e, car_nm c, client g, sui i, \n"+
                "        (select car_mng_id, cust_id, deli_dt from rent_cont where  rent_st='4' and cust_st='4' and use_st='2') f, USERS h, (select * from insur where ins_sts='1') l, cont_etc a, ins_com n \n"+
				" where \n"+
				"        nvl(b.use_yn,'Y')='Y' AND b.car_st='2' \n"+
				"        and to_number(replace(d.dpm,' ','')) > 1000 \n"+
                "        and d.taking_p < 9 \n"+
                "        and c.car_name not like '%9인승%' \n"+
				"        and c.s_st < '600' \n"+
                "        AND g.client_st='1' \n"+ 
				"        and b.car_mng_id=d.car_mng_id \n"+
				"        and b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd \n"+
				"        and e.car_id=c.CAR_ID and e.car_seq=c.car_seq \n"+
				"        and b.client_id=g.client_id \n"+
				"        and b.car_mng_id=i.car_mng_id(+) and i.car_mng_id is NULL \n"+
                "        AND b.car_mng_id=f.car_mng_id \n"+
                "        AND f.cust_id=h.user_id \n"+
				"        and d.car_mng_id=l.car_mng_id \n"+
			    "        AND l.ins_com_id=n.ins_com_id \n"+
				"        and b.rent_mng_id=a.rent_mng_id and b.rent_l_cd=a.rent_l_cd \n"+
				"        and nvl(l.com_emp_yn,'N')='N' \n"+
				" ";

			r_query = " select a.* from ("+query+") a \n";

			
			if(gubun1.equals("1"))		r_query += " where a.ins_exp_dt between to_char(sysdate-30,'YYYYMMDD') and to_char(sysdate+30,'YYYYMMDD') \n";
			if(gubun1.equals("2"))		r_query += " where a.ins_exp_dt like to_char(sysdate,'YYYYMM')||'%' \n";
			if(gubun1.equals("3"))		r_query += " where a.ins_exp_dt like to_char(add_months(sysdate,1), 'YYYYMM')||'%' \n";
			if(gubun1.equals("4"))		r_query += " where a.ins_exp_dt between to_char(sysdate-15,'YYYYMMDD') and to_char(sysdate+15,'YYYYMMDD') \n";
			if(gubun1.equals("5"))		r_query += " where a.ins_exp_dt like to_char(sysdate, 'YYYY')||'%' \n";


			if(gubun1.equals("") && !t_wd.equals(""))	r_query += " where ";
			if(!gubun1.equals("") && !t_wd.equals(""))	r_query += " and ";


			if(!t_wd.equals("")){
				if(s_kd.equals("1"))			r_query += " a.firm_nm like '%"+t_wd+"%' \n";
				else if(s_kd.equals("2"))		r_query += " a.enp_no like '%"+t_wd+"%' \n";
				else if(s_kd.equals("3"))		r_query += " upper(a.rent_l_cd) like upper('%"+t_wd+"%') \n";
				else if(s_kd.equals("4"))		r_query += " a.car_no like '%"+t_wd+"%' \n";
				else if(s_kd.equals("5"))		r_query += " a.car_nm||a.car_name like '%"+t_wd+"%'\n";
				else if(s_kd.equals("6"))		r_query += " a.bus_nm like '%"+t_wd+"%'\n";
				else if(s_kd.equals("7"))		r_query += " a.bus_nm2 like '%"+t_wd+"%'\n";
			}

			r_query += " ORDER BY decode(a.rent_l_cd,'',0,1), a.ins_exp_dt, a.firm_nm \n";

			
		try {
				pstmt = conn.prepareStatement(r_query);
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

//			System.out.println("[InsDatabase:getInsComempNotStatList]"+ r_query);

		} catch (SQLException e) {
			
			System.out.println("[InsDatabase:getInsComempNotStatList]"+ e);
			System.out.println("[InsDatabase:getInsComempNotStatList]"+ r_query);
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
	
	
	//임직원 전용 자동차보험 관련 메일링

	public Vector getIjwListmailing(String client_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = "       SELECT  b.rent_mng_id, b.rent_l_cd, b.bus_id2, l.ins_exp_dt, M.CAR_NM, c.car_name, d.car_no, c.s_st, \r\n" + 
				"        CASE WHEN  (to_number(replace(d.dpm,' ','')) > 1000  OR d.fuel_kd IN ('7','8','9','10') )  and d.taking_p < 9 and c.car_name not like '%9인승%' AND c.s_st > '101' AND c.s_st < '600' THEN 'O' ELSE 'X' END com_emp_yn \r\n" + 
				"		 from    cont b, car_reg d, car_etc e, car_nm c, client g, (select * from insur where ins_sts='1') l, car_mng m, CONT_ETC h  \r\n" + 
				"		 where nvl(b.use_yn,'Y')='Y' AND b.car_st IN ('1','3','4','5')  AND b.client_id<>'000228'\r\n" + 
				"		 AND (to_number(replace(d.dpm,' ','')) > 1000  OR d.fuel_kd IN ('7','8','9','10') ) \r\n" + 
				"		 AND d.taking_p < 9\r\n" + 
				//"		 AND nvl(h.COM_EMP_YN,'N') ='N'\r\n" + 
				"        AND c.car_name not like '%9인승%'\r\n" + 
				"        AND c.s_st < '600'\r\n" + 
				"        AND g.client_st NOT iN ('1','2')\r\n" + 
				"		 AND b.car_mng_id=d.car_mng_id \r\n" + 
				"		 AND b.rent_mng_id=e.rent_mng_id AND b.rent_l_cd=e.rent_l_cd \r\n" + 
				"		 AND e.car_id=c.CAR_ID AND e.car_seq=c.car_seq AND c.car_comp_id=m.car_comp_id AND c.car_cd=m.code \r\n" + 
				"		 AND b.client_id=g.client_id \r\n" + 
				"		 AND d.car_mng_id=l.car_mng_id \r\n"+
				"		 AND b.rent_mng_id=h.rent_mng_id and b.rent_l_cd=h.rent_l_cd\r\n" + 
				"        AND g.client_id <> '055862' \n";
                

		query += " and b.client_id='"+client_id+"'";
        query += " ORDER BY l.ins_exp_dt ";
		

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
			System.out.println("[InsDatabase:getIjwList(String client_id)]"+ e);
			System.out.println("[InsDatabase:getIjwList(String client_id)]"+ query);
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

	public Vector getIjwListmailing2(String client_id, String car_mng_id, String com_emp_yn)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = "      SELECT  b.rent_mng_id, b.rent_l_cd, b.bus_id2, l.ins_exp_dt, M.CAR_NM, c.car_name, d.car_no, c.s_st, \r\n" + 
				"        CASE WHEN  (to_number(replace(d.dpm,' ','')) > 1000  OR d.fuel_kd IN ('7','8','9','10') ) and d.taking_p < 9 and c.car_name not like '%9인승%' AND c.s_st > '101' AND c.s_st < '600' THEN 'O' ELSE 'X' END com_emp_yn \r\n" + 
				"		 from    cont b, car_reg d, car_etc e, car_nm c, client g, (select * from insur where ins_sts='1') l, car_mng m , CONT_ETC h \r\n" + 
				"		 where nvl(b.use_yn,'Y')='Y' AND b.car_st IN ('1','3','4','5')  AND b.client_id<>'000228'\r\n" + 
				"		 AND (to_number(replace(d.dpm,' ','')) > 1000  OR d.fuel_kd IN ('7','8','9','10') ) \r\n" + 
				"		 AND d.taking_p < 9\r\n" + 
				"        AND c.car_name not like '%9인승%'\r\n" + 
				"        AND c.s_st < '600'\r\n" + 
				"        AND g.client_st NOT iN ('1','2')\r\n" + 
				"		 AND b.car_mng_id=d.car_mng_id \r\n" + 
				"		 AND b.rent_mng_id=e.rent_mng_id AND b.rent_l_cd=e.rent_l_cd \r\n" + 
				"		 AND e.car_id=c.CAR_ID AND e.car_seq=c.car_seq AND c.car_comp_id=m.car_comp_id AND c.car_cd=m.code \r\n" + 
				"		 AND b.client_id=g.client_id \r\n" + 
				"		 AND d.car_mng_id=l.car_mng_id \r\n" + 
				"		 AND b.rent_mng_id=h.rent_mng_id and b.rent_l_cd=h.rent_l_cd\r\n" + 
				"		 AND g.client_id <> '055862'";
                

		query += " and b.client_id='"+client_id+"'";
		
		if(!car_mng_id.equals("")) {
			query += " and d.car_mng_id='"+car_mng_id+"'";
		}
		
		if(!com_emp_yn.equals("")) {
			query += "  AND nvl(h.COM_EMP_YN,'N') ='"+com_emp_yn+"'";
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
			System.out.println("[InsDatabase:getIjwList(String client_id)]"+ e);
			System.out.println("[InsDatabase:getIjwList(String client_id)]"+ query);
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

	//20160706 보험일괄변경 조회화면 그리드용
	public Vector getInsChangeList(String dt, String ref_dt1, String ref_dt2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
   	
		String f_date1="";
		String t_date1="";
	
		String s_year = Integer.toString(AddUtil.getDate2(1));	
		String s_month =Integer.toString(AddUtil.getDate2(2));	
		s_month = AddUtil.addZero(s_month);

		if(dt.equals("0")) {
			f_date1 = "to_char(sysdate-1,'YYYYMMDD')";
			t_date1 = "to_char(sysdate-1,'YYYYMMDD')";
		}

		if(dt.equals("1")) {
			f_date1 = "to_char(sysdate,'YYYYMMDD')";
			t_date1 = "to_char(sysdate,'YYYYMMDD')";
		}

		if(dt.equals("2")) {
			f_date1 = "'"+s_year+ s_month + "01'";
			t_date1 = "'"+s_year+ s_month + "31'";
		}
		
		if(dt.equals("3")) {
			f_date1 = "'"+s_year+ "0101'";
			t_date1 = "'"+s_year+ "1231'";
		}
		
		if(dt.equals("4")) {
			f_date1=  "'"+ref_dt1+ "'";
			t_date1=  "'"+ref_dt2+ "'";
		}
		
		query = " SELECT b.car_no, d.INS_COM_nm,a.reg_dt,c.ins_con_no,a.ch_item,a.ch_before,a.ch_after,a.ch_amt, e.i_su, a.car_mng_id,a.ins_st,f.rent_l_cd,f.RENT_MNG_ID, c.ins_start_dt, c.ins_exp_dt, \n" +
				"	DECODE(g.BLACKBOX_YN,'Y','장착','N','미장착',g.BLACKBOX_YN) AS blackbox_yn , DECODE(g.com_emp_yn,'Y','가입','N','미가입',g.com_emp_yn) AS com_emp_yn,  \n" +
				"	DECODE(f.DRIVING_AGE,'0','26세이상','1','21세이상','2','제한없음','3','24세이상','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하') AS driving_age,  \n" +
				"	DECODE(f.gcp_kd,'1','5000만원','2','1억원','3','5억원','4','2억원','8','3억원','9','10억원') AS gcp_kd  \n" +
				"	    FROM ins_change a, car_reg b, insur c, ins_com d, cont f,  cont_etc g, \n" +  
				"	    (SELECT SUM(rins_pcp_amt+vins_pcp_amt+vins_gcp_amt+vins_bacdt_amt+vins_canoisr_amt+vins_share_extra_amt) AS i_su, car_mng_id,ins_st FROM insur group BY car_mng_id,ins_st) e \n" +  
				" 		WHERE a.CAR_MNG_ID = b.CAR_MNG_ID \n" +
				"		AND a.CAR_MNG_ID = c.CAR_MNG_ID \n"+
				"		AND a.ins_st = c.INS_ST  \n" +
				"		AND a.CAR_MNG_ID = f.car_mng_id(+)  \n" +
				"		and f.reg_dt||f.rent_l_cd=(select max(reg_dt||rent_l_cd) from cont where rent_l_cd not like 'RM%' and car_mng_id=a.car_mng_id)  \n" +
				"		AND f.rent_mng_id = g.rent_mng_id(+)  \n" +		
				"		AND f.rent_l_cd = g.rent_l_cd(+)  \n" +		
				"		AND c.INS_COM_ID = d.ins_com_id  \n" +		
				"		AND a.CAR_MNG_ID = e.car_mng_id \n" +				
				"		AND a.ins_st = e.ins_st \n" +
				"		AND c.ins_sts not in('2','3') \n" +
				"       and a.reg_dt >= "+f_date1+" and a.reg_dt <= "+t_date1+"" ;
		
		query +="  ORDER BY a.REG_Dt, d.ins_com_nm,a.ch_item DESC ";
			
//     System.out.println("getInsChangeList="+query);	
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
			System.out.println("[InsDatabase:getInsChangeList]\n"+e);
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
	
	//20160906 보험 변경예정 조회화면 그리드용
	public Vector getInsChangeList2()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		        //임직원가입
		query = " select a.car_mng_id,d.car_no,d.car_nm,c.firm_nm, \n" +
				"	     CASE WHEN c.client_st='2'  THEN SUBSTR(text_decrypt(c.ssn, 'pw'),0,6) ELSE c.enp_no END AS enp_no ,"+
				"        a.rent_start_dt,a.rent_end_dt, decode(b.COM_EMP_YN,'Y','가입') AS com_emp_yn, e.ins_com_nm,  \n" +
				"	     b.ins_start_dt, b.ins_exp_dt, '미가입' AS com_emp_yn_after, '임직원' AS ch_item, '가입' AS ch_item_before ,'미가입' AS ch_item_after, ' ', b.ins_con_no,''  \n" +  
				" FROM   cont a , insur b, client c, car_reg d, ins_com e, (select car_mng_id, cust_id from rent_cont where rent_st='10' and use_st in ('2')) f, client c2 "+
				" WHERE  a.car_mng_id= b.car_mng_id  \n" +  
				" 	     AND a.CLIENT_ID = c.CLIENT_ID AND a.car_mng_id = d.car_mng_id AND b.ins_com_id = e.ins_com_id AND NVL(a.use_yn,'Y') = 'Y' AND b.COM_EMP_YN='Y' AND b.ins_sts='1' \n" +
				"	     AND ((a.car_st NOT IN ('5') AND c.client_st NOT IN ('1')) OR c.firm_nm = '(주)아마존카') "+
				"        AND a.car_mng_id=f.car_mng_id(+) and f.cust_id=c2.client_id(+) and nvl(c2.client_st,'0')<>'1' "+ //지연대차 법인은 제외
				//연령 26세 아닌
			/*	" UNION ALL  \n"+
				" select a.car_mng_id,d.car_no,d.car_nm,c.firm_nm, "+
				"        CASE WHEN c.client_st='2'  THEN SUBSTR(text_decrypt(c.ssn, 'pw'),0,6)  ELSE c.enp_no END AS enp_no, "+
				"        a.rent_start_dt,a.rent_end_dt, decode(b.age_scp,'1','21세','2','26세','3','모든운전자','4','24세','5','30세','6','35세','7','43세','48세') AS com_emp_yn, e.ins_com_nm,  \n" +
				"	     b.ins_start_dt, b.ins_exp_dt, '26세' AS com_emp_yn_after, '연령' AS ch_item, decode(b.age_scp,'1','21세','2','26세','3','모든운전자','4','24세','5','30세','6','35세','7','43세','48세') AS ch_item_before ,'26세' AS ch_item_after, ' ', b.ins_con_no,'' \n" +
				" FROM   cont a , insur b, client c, car_reg d, ins_com e, (select car_mng_id, sub_l_cd from rent_cont where rent_st in ('2','3','10') and use_st in ('2')) f, cont a2 "+
				" WHERE  a.car_mng_id= b.car_mng_id  \n" +
				"	     AND a.CLIENT_ID = c.CLIENT_ID AND a.car_mng_id = d.car_mng_id AND b.ins_com_id = e.ins_com_id AND NVL(a.use_yn,'Y') = 'Y' AND b.COM_EMP_YN='Y' AND b.ins_sts='1'   \n" +
				"	     AND ((a.car_st NOT IN ('5') AND c.client_st NOT IN ('1')) OR c.firm_nm = '(주)아마존카') "+
				"        AND b.age_scp NOT IN ('2') "+
				"        AND a.car_mng_id=f.car_mng_id(+) and f.sub_l_cd=a2.rent_l_cd(+) and nvl(a2.driving_age,'0')='0' "+ //대차 원계약 26세 아닌거 제외
                //대물1억원 아닌
				" UNION ALL  \n" +
				" select a.car_mng_id,d.car_no,d.car_nm,c.firm_nm, "+
				"        CASE  WHEN c.client_st='2'  THEN SUBSTR(text_decrypt(c.ssn, 'pw'),0,6) ELSE c.enp_no END AS enp_no, "+
				"        a.rent_start_dt,a.rent_end_dt, decode(b.vins_gcp_kd,'1','3500만원','2','1500만원','3','1억원','4','5000만원','5','1000만원') AS com_emp_yn, e.ins_com_nm,  \n" +
				"	     b.ins_start_dt, b.ins_exp_dt, '1억원' AS com_emp_yn_after, '대물변경' AS ch_item, decode(b.vins_gcp_kd,'1','3500만원','2','1500만원','3','1억원','4','5000만원','5','1000만원') AS ch_item_before ,'1억원' AS ch_item_after, ' ', b.ins_con_no,''  \n" +
				" FROM   cont a , insur b, client c, car_reg d, ins_com e, (select car_mng_id, sub_l_cd from rent_cont where rent_st in ('2','3','10') and use_st in ('2')) f, cont a2  \n" +
				" WHERE  a.car_mng_id= b.car_mng_id "+
				"        AND a.CLIENT_ID = c.CLIENT_ID  AND a.car_mng_id = d.car_mng_id AND b.ins_com_id = e.ins_com_id  AND NVL(a.use_yn,'Y') = 'Y'  AND b.COM_EMP_YN='Y' AND b.ins_sts='1' \n" +
				"	     AND ((a.car_st NOT IN ('5') AND c.client_st NOT IN ('1')) OR c.firm_nm = '(주)아마존카') \n" +
				"	     AND b.vins_gcp_kd NOT IN ('3')  \n"+
				"        AND a.car_mng_id=f.car_mng_id(+) and f.sub_l_cd=a2.rent_l_cd(+) and nvl(a2.gcp_kd,'2')='2' "+ //대차 원계약 대물1억 아닌거 제외
*/				//임차인
				" UNION ALL  \n" +
				" SELECT  c.CAR_MNG_ID, b.CAR_NO,   b.CAR_NM, d.FIRM_NM, \n" +
				" 		  CASE WHEN d.CLIENT_nm = d.FIRM_NM THEN substr(TEXT_DECRYPT(d.ssn, 'pw' ),1,6) ELSE DECODE(d.ENP_NO,NULL,substr(TEXT_DECRYPT(d.ssn, 'pw' ),1,6),d.ENP_NO) END AS ENP_NO, \n" +
                " 		  c.RENT_START_DT, c.RENT_END_DT,  CASE		WHEN CLIENT_ST = '1'  AND JG_CODE > '1999999' AND JG_CODE < '7000000' THEN 'Y'  ELSE NVL(e.COM_EMP_YN,'N') END AS COM_EMP_YN, h.INS_COM_NM, \n" +
                "         a.INS_START_DT, a.INS_EXP_DT, d.FIRM_NM AS com_emp_yn_after , '임차인' AS ch_item, a.FIRM_EMP_NM AS ch_item_before, d.FIRM_NM AS ch_item_after, ' ', a.INS_CON_NO, ' ' \n" +
                " FROM    insur a, car_reg b, cont c, client d, cont_etc e, car_etc f, car_nm g, ins_com h \n" +
                " WHERE   a.CAR_MNG_ID = b.CAR_MNG_ID AND a.CAR_MNG_ID = c.CAR_MNG_ID AND c.CLIENT_ID = d.CLIENT_ID \n" +
                "         AND c.RENT_L_CD = e.rent_L_CD AND c.RENT_MNG_ID = f.RENT_MNG_ID AND c.RENT_L_CD = f.RENT_L_CD \n" +
			    "         AND f.CAR_ID = g.CAR_ID  AND f.CAR_SEQ = g.CAR_SEQ AND a.INS_COM_ID = h.INS_COM_ID \n" +
			    "         AND ins_con_no IS NOT NULL  AND  NVL(c.use_yn,'Y') ='Y' AND a.INS_STS = 1 AND a.INS_START_DT >= 20171001 \n" +
			    "         AND REPLACE(REPLACE(NVL(d.FIRM_NM,'미지정'),' ',''),'(주)','')	<> REPLACE(REPLACE(NVL(a.FIRM_EMP_NM,'미지정'),' ',''),'(주)','') \n" +
			    "         AND REPLACE(REPLACE(NVL(d.FIRM_NM,'미지정'),' ',''),'(주)','') NOT LIKE '%' || REPLACE(REPLACE(NVL(a.FIRM_EMP_NM,'미지정'),' ',''),'(주)','') || '%' \n" +
			    "         AND REPLACE(REPLACE(NVL(a.FIRM_EMP_NM,'미지정'),' ',''),'(주)','') NOT LIKE '%'|| REPLACE(REPLACE(NVL(d.FIRM_NM,'미지정'),' ',''),'(주)','') ||'%' \n" +
			    " ";
		
		query +="  ORDER BY ins_com_nm, car_no ";
			
//     System.out.println("getInsChangeList2="+query);	
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
			System.out.println("[InsDatabase:getInsChangeList2]\n"+e);
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
	
	
	//20161010 보험 변경예정 조회화면 그리드용2
	public Vector getInsChangeList3(String dt, String ref_dt1, String ref_dt2, String gubun1, String gubun2, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query="";
		String sub_query2="";
		
		String f_date1="";
		String t_date1="";
	
		String s_year = Integer.toString(AddUtil.getDate2(1));	
		String s_month =Integer.toString(AddUtil.getDate2(2));	
		s_month = AddUtil.addZero(s_month);
		
		if(dt.equals("2")) {
			f_date1 = s_year+ s_month + "01";
			t_date1 = s_year+ s_month + "31";
		}
		
		if(dt.equals("3")) {//기본조건
			f_date1 = s_year+ "0101"; 
			t_date1 = s_year+ "1231";
		}
		
		if(dt.equals("4")) {
			f_date1=  ref_dt1;
			t_date1=  ref_dt2;
		}
		if(gubun1.equals("Y")) {
			sub_query = " and nvl(a.gubun,'N') = 'Y' \n";
		}
		if(gubun1.equals("N")) {//기본조건
			sub_query = " and nvl(a.gubun,'N') = 'N' \n";
			sub_query2 = " AND SUBSTR(nvl(g.deli_dt,g.deli_plan_dt),1,8) BETWEEN TO_CHAR(SYSDATE-1,'YYYYMMDD') AND TO_CHAR(SYSDATE+1,'YYYYMMDD')";
		}
		if(gubun2.equals("")){//기본조건
			sub_query +=  "   and a.reg_dt >= '"+f_date1+"' and a.reg_dt <= '"+t_date1+"'  \n";
		}
		if(gubun2.equals("1") && !t_wd.equals("")) {
			sub_query += " and c.car_no like '%"+t_wd+"%' \n";
		}
		if(gubun2.equals("2") && !t_wd.equals("")) {
			sub_query += " and f.ins_com_nm like '%"+t_wd+"%' \n";
		}
		if(gubun2.equals("3") && !t_wd.equals("")) {
			sub_query += " and d.ins_con_no = '"+t_wd+"' \n";
		}
		if(gubun2.equals("4") && !t_wd.equals("")) {
			sub_query += " and a.value01 like '%"+t_wd+"%' \n";
		}
		if(gubun2.equals("5") && !t_wd.equals("")) {
			sub_query += " and a.value06 like '%"+t_wd+"%' \n";
		}
		if(gubun2.equals("6") && !t_wd.equals("")) {
			sub_query += " and upper(c.car_nm) like '%'||upper('"+t_wd+"')||'%' \n";
		}


        //a.value03 = b.rent_l_cd 대여
		query = " SELECT decode(a.gubun,'N','0','Y','1','0') as gubun , decode(d.com_emp_yn,'Y','가입','N','미가입') as com_emp_yn,  "+
			    "   decode(d.age_scp,'1','21세이상','2','26세이상','3','모든운전자','4','24세이상','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하') as age_scp, "+
			    "   d.firm_emp_nm, decode(d.vins_gcp_kd,'3','1억원','7','2억원','8','3억원','6','5억원','9','10억원') as vins_gcp_kd, d.blackbox_yn, d.blackbox_nm, d.blackbox_no, "+
			    "   a.reg_code, a.seq, a.value01, d.ins_con_no, DECODE(b.car_st,'5','(주)아마존카/')||e.firm_nm AS firm_nm, c.car_no, c.car_nm, CASE WHEN b.car_st='5' THEN '1288147957' WHEN e.client_st='2'  THEN SUBSTR(text_decrypt(e.ssn, 'pw'),0,6)  ELSE e.enp_no END AS enp_no , d.ins_start_dt, d.ins_exp_dt, a.value06, a.value07, a.value08, a.value05,f.INS_COM_NM , \n" +
				"	b.rent_l_cd, b.rent_mng_id, d.car_mng_id, d.ins_st, d.enp_no as INS_ENP_NO, b.rent_start_dt, b.USE_YN, b.car_st, b.rent_dt, e.client_st, (select ch_dt from ins_change_doc aa where aa.rent_mng_id = b.rent_mng_id and aa.rent_l_cd = b.rent_l_cd and aa.car_mng_id = d.car_mng_id and aa.ins_doc_no = a.value04) as ch_dt, '' ins_change_flag  "+
				" 	FROM ins_excel a , cont b , car_reg c , insur d, client e, ins_com f     \n" +
				"	WHERE a.reg_code LIKE '%ICQ%'     \n" +
				"	and a.value06 IS NOT null  and a.value01 not in ('대차등록','매각 명의이전일 등록') \n" +//'대차등록',
				"	AND a.value03 = b.rent_l_cd  \n" +  
				"	AND b.car_mng_id = c.car_mng_id  \n" +  
				" 	AND b.car_mng_id = d.car_mng_id \n" +
				"	AND d.ins_sts='1'  \n"+
				"   AND d.INS_COM_ID = f.INS_COM_ID  \n"+
				"	AND b.CLIENT_ID = e.CLIENT_ID   \n" + sub_query +
				"	UNION all   \n" +
		//a.value03 = b.car_mng_id 대차 : 대차등로제외
				"	SELECT decode(a.gubun,'N','0','Y','1','0') as gubun, decode(d.com_emp_yn,'Y','가입','N','미가입') as com_emp_yn, "+
			    "   decode(d.age_scp,'1','21세이상','2','26세이상','3','모든운전자','4','24세이상','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하') as age_scp, "+
				"   d.firm_emp_nm, decode(d.vins_gcp_kd,'3','1억원','7','2억원','8','3억원','6','5억원','9','10억원') as vins_gcp_kd, d.blackbox_yn, d.blackbox_nm, d.blackbox_no, "+
			    "   a.reg_code, a.seq, a.value01, d.ins_con_no, decode(h.cust_id,'',e.firm_nm,e2.firm_nm) firm_nm, c.car_no, c.car_nm, "+
				"	CASE WHEN h.cust_id is null and e.client_st='2' THEN SUBSTR(text_decrypt(e.ssn, 'pw'),0,6) WHEN h.cust_id is null and e.client_st<>'2' THEN e.enp_no WHEN h.cust_id is not null and e2.client_st='2' THEN SUBSTR(text_decrypt(e2.ssn, 'pw'),0,6) WHEN h.cust_id is not null and e2.client_st<>'2' THEN e2.enp_no ELSE e.enp_no END AS enp_no, "+
				"	d.ins_start_dt, d.ins_exp_dt, a.value06, a.value07, a.value08, a.value05,f.INS_COM_NM , \n" +
				"	b.rent_l_cd, b.rent_mng_id, d.car_mng_id, d.ins_st,d.enp_no as INS_ENP_NO, b.rent_start_dt, b.USE_YN, b.car_st, b.rent_dt, e.client_st, '' as ch_dt, h.ins_change_flag   "+
				"	FROM ins_excel a , cont b , car_reg c , insur d, client e, ins_com f,    \n"+
                "   (SELECT car_mng_id, MAX(rent_mng_id) rent_mng_id, MAX(reg_dt) reg_dt FROM cont GROUP BY car_mng_Id) g, rent_cont h, client e2 \n"+
				"	WHERE a.reg_code LIKE '%ICQ%'    \n" +
				"	and a.value06 IS NOT null  and a.value01 not in ('대차등록','매각 명의이전일 등록') \n" +
				"	AND a.value03 = b.car_mng_id    \n" +
//				"	AND NVL(b.use_yn,'Y') ='Y'  \n" +
				"	AND b.car_mng_id = c.car_mng_id  \n" +
				"   AND b.car_mng_id = d.car_mng_id  \n" +
				"	AND d.ins_sts='1'  \n" +
				"   AND d.INS_COM_ID = f.INS_COM_ID  \n"+
				"	AND b.CLIENT_ID = e.CLIENT_ID   \n"+ sub_query +
				"   AND b.car_mng_id=g.car_mng_id AND b.rent_mng_id=g.rent_mng_id AND b.reg_dt=g.reg_dt AND a.value02=h.rent_s_cd(+) AND a.value03=h.car_mng_id(+) AND h.cust_id=e2.client_id(+) \n"+
				"	UNION all   \n" +
		//a.value03 = b.car_mng_id 대차등록만
				"	SELECT decode(a.gubun,'N','0','Y','1','0') as gubun, decode(d.com_emp_yn,'Y','가입','N','미가입') as com_emp_yn, "+
			    "   decode(d.age_scp,'1','21세이상','2','26세이상','3','모든운전자','4','24세이상','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하') as age_scp, "+
				"   d.firm_emp_nm, decode(d.vins_gcp_kd,'3','1억원','7','2억원','8','3억원','6','5억원','9','10억원') as vins_gcp_kd, d.blackbox_yn, d.blackbox_nm, d.blackbox_no, "+
			    "   a.reg_code, a.seq, a.value01, d.ins_con_no, "+
//				"	decode(h.cust_id,'',e.firm_nm,e2.firm_nm) firm_nm, "+
				"   '(주)아마존카' firm_nm, "+ //대차는 아마존카로 한다.
				"	c.car_no, c.car_nm, "+
//				"	CASE WHEN h.cust_id is null and e.client_st='2' THEN SUBSTR(text_decrypt(e.ssn, 'pw'),0,6) WHEN h.cust_id is null and e.client_st<>'2' THEN e.enp_no WHEN h.cust_id is not null and e2.client_st='2' THEN SUBSTR(text_decrypt(e2.ssn, 'pw'),0,6) WHEN h.cust_id is not null and e2.client_st<>'2' THEN e2.enp_no ELSE e.enp_no END AS enp_no, "+
				"   e.enp_no, "+
				"	d.ins_start_dt, d.ins_exp_dt, a.value06, a.value07, a.value08, a.value05,f.INS_COM_NM , \n" +
				"	b.rent_l_cd, b.rent_mng_id, d.car_mng_id, d.ins_st, d.enp_no as INS_ENP_NO, b.rent_start_dt, b.USE_YN, b.car_st, b.rent_dt, e.client_st, '' as ch_dt, h.ins_change_flag   "+
				"	FROM ins_excel a , cont b , car_reg c , insur d, client e, ins_com f,    \n"+
                "   (SELECT car_mng_id, MAX(rent_mng_id) rent_mng_id, MAX(reg_dt) reg_dt FROM cont GROUP BY car_mng_Id) g, rent_cont h, client e2 \n"+
				"	WHERE a.reg_code LIKE '%ICQ%'    \n" +
				"	and a.value06 IS NOT null  and a.value01 in ('대차등록') and a.value06 in ('연령범위','대물배상') \n" +
				"	AND a.value03 = b.car_mng_id    \n" +
//				"	AND NVL(b.use_yn,'Y') ='Y'  \n" +
				"	AND b.car_mng_id = c.car_mng_id  \n" +
				"   AND b.car_mng_id = d.car_mng_id  \n" +
				"	AND d.ins_sts='1'  \n" +
				"   AND d.INS_COM_ID = f.INS_COM_ID  \n"+
				"	AND b.CLIENT_ID = e.CLIENT_ID   \n"+ sub_query +
				"   AND b.car_mng_id=g.car_mng_id AND b.rent_mng_id=g.rent_mng_id AND b.reg_dt=g.reg_dt AND a.value02=h.rent_s_cd(+) AND a.value03=h.car_mng_id(+) AND h.cust_id=e2.client_id(+) \n"+
                "   and a.reg_dt > '20170331' \n"+
				"	UNION all   \n" +
		//a.value03 = b.car_mng_id 차량번호 변경만
				"	SELECT decode(a.gubun,'N','0','Y','1','0') as gubun, decode(d.com_emp_yn,'Y','가입','N','미가입') as com_emp_yn, "+
			    "   decode(d.age_scp,'1','21세이상','2','26세이상','3','모든운전자','4','24세이상','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하') as age_scp, "+
				"   d.firm_emp_nm, decode(d.vins_gcp_kd,'3','1억원','7','2억원','8','3억원','6','5억원','9','10억원') as vins_gcp_kd, d.blackbox_yn, d.blackbox_nm, d.blackbox_no, "+
			    "   a.reg_code, a.seq, a.value01, d.ins_con_no, e.firm_nm, c.car_no, c.car_nm, "+
				"	decode(e.client_st,'2',SUBSTR(text_decrypt(e.ssn, 'pw'),0,6),e.enp_no) AS enp_no, "+
				"	d.ins_start_dt, d.ins_exp_dt, a.value06, a.value07, a.value08, a.value05,f.INS_COM_NM , \n" +
				"	b.rent_l_cd, b.rent_mng_id, d.car_mng_id, d.ins_st,d.enp_no as INS_ENP_NO, b.rent_start_dt, b.USE_YN, b.car_st, b.rent_dt, e.client_st, '' as ch_dt, '' ins_change_flag  "+
				"	FROM ins_excel a , cont b , car_reg c , insur d, client e, ins_com f \n"+
				"	WHERE a.reg_code LIKE '%ICQ%'    \n" +
				"	and a.value06 IS NOT null  and a.value01 in ('차량번호 변경') \n" +
				"	AND a.value03 = b.car_mng_id    \n" +
				"	AND NVL(b.use_yn,'Y') ='Y'  \n" +
				"	AND b.car_mng_id = c.car_mng_id  \n" +
				"   AND b.car_mng_id = d.car_mng_id  \n" +
				"	AND d.ins_sts='1'  \n" +
				"   AND d.INS_COM_ID = f.INS_COM_ID  \n"+
				"	AND b.CLIENT_ID = e.CLIENT_ID   \n"+ sub_query +
                "   and a.reg_dt > '20170331' \n"+
                  "	UNION all   \n" +
          //a.value03 = b.car_mng_id  보험변경예정조회 관련 내용(임직원, 연령, 대물변경, 임차인)
				"   SELECT decode(a.gubun,'N','0','Y','1','0') as gubun , decode(d.com_emp_yn,'Y','가입','N','미가입') as com_emp_yn , "+
				"   decode(d.age_scp,'1','21세이상','2','26세이상','3','모든운전자','4','24세이상','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하') as age_scp, "+
				"   d.firm_emp_nm, decode(d.vins_gcp_kd,'3','1억원','7','2억원','8','3억원','6','5억원','9','10억원') as vins_gcp_kd, d.blackbox_yn, d.blackbox_nm, d.blackbox_no, "+
				"   a.reg_code, a.seq, a.value01, d.ins_con_no,  DECODE(b.car_st,'5','(주)아마존카/')||e.firm_nm AS firm_nm, c.car_no, c.car_nm, CASE WHEN b.car_st='5' THEN '1288147957' WHEN e.client_st='2'  THEN SUBSTR(text_decrypt(e.ssn, 'pw'),0,6)  ELSE e.enp_no END AS enp_no , d.ins_start_dt, d.ins_exp_dt, a.value06, a.value07, a.value08, a.value05,f.INS_COM_NM , \n" +
				"	b.rent_l_cd, b.rent_mng_id, d.car_mng_id, d.ins_st, d.enp_no as INS_ENP_NO, b.rent_start_dt, b.USE_YN, b.car_st, b.rent_dt, e.client_st, '' as ch_dt, '' ins_change_flag   "+
				"	FROM ins_excel a , cont b , car_reg c , insur d, client e, ins_com f     \n" +
				"	WHERE a.reg_code LIKE '%BASE%'   \n" +
				"	AND a.value06 IS NOT null  \n" +
				"	AND a.value06 NOT IN ('첨단산업')  \n" +
				"	AND a.value03= b.rent_l_cd  \n" +  
				"	AND b.car_mng_id = c.car_mng_id  \n" +  
				" 	AND b.car_mng_id = d.car_mng_id \n" +
				"	AND d.ins_sts='1'  \n"+
				"   AND d.INS_COM_ID = f.INS_COM_ID  \n"+
				"	AND b.CLIENT_ID = e.CLIENT_ID   \n" + sub_query +
				
                  "	UNION all   \n" +
          //a.value03 = b.car_mng_id  보험변경예정조회 관련 내용(임직원, 연령, 대물변경, 임차인)                  
				"   SELECT decode(a.gubun,'N','0','Y','1','0') as gubun , decode(d.com_emp_yn,'Y','가입','N','미가입') as com_emp_yn , "+
				"   decode(d.age_scp,'1','21세이상','2','26세이상','3','모든운전자','4','24세이상','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하') as age_scp, "+
				"   d.firm_emp_nm, decode(d.vins_gcp_kd,'3','1억원','7','2억원','8','3억원','6','5억원','9','10억원') as vins_gcp_kd, d.blackbox_yn, d.blackbox_nm, d.blackbox_no, "+
				"   a.reg_code, a.seq, a.value01, d.ins_con_no,  DECODE(b.car_st,'5','(주)아마존카/')||e2.firm_nm AS firm_nm, c.car_no, c.car_nm, CASE WHEN b.car_st='5' THEN '1288147957' WHEN e2.client_st='2'  THEN SUBSTR(text_decrypt(e2.ssn, 'pw'),0,6)  ELSE e2.enp_no END AS enp_no , d.ins_start_dt, d.ins_exp_dt, a.value06, a.value07, a.value08, a.value05,f.INS_COM_NM , \n" +
				"	b.rent_l_cd, b.rent_mng_id, d.car_mng_id, d.ins_st, d.enp_no as INS_ENP_NO, b.rent_start_dt, b.USE_YN, b.car_st, b.rent_dt, e2.client_st, '' as ch_dt, g.ins_change_flag   "+
				"	FROM ins_excel a , cont b , car_reg c , insur d, client e, ins_com f, rent_cont g, client e2     \n" +
				"	WHERE a.reg_code LIKE '%BASE%'   \n" +
				"	AND a.value06 IS NOT null  \n" +
				"	AND a.value06 NOT IN ('첨단산업')   and a.value01 in ('변경1 정비대차', '변경1 사고대차','변경1 지연대차')  \n" +
				"	AND a.value10 = b.rent_l_cd  \n" +
				"	AND a.value03 = g.car_mng_id  \n" +
				"	AND a.value02 = g.rent_s_cd  \n" +
				"	AND b.car_mng_id = c.car_mng_id  \n" +  
				" 	AND b.car_mng_id = d.car_mng_id \n" +
				"	AND d.ins_sts='1'  \n"+
				"   AND d.INS_COM_ID = f.INS_COM_ID  \n"+
				"	AND b.CLIENT_ID = e.CLIENT_ID AND g.cust_id = e2.CLIENT_ID   \n" + sub_query + sub_query2 +  //20220224 이블록 다시 살리고 전일부터익일 기준 추가 
								
                " ";
		
		query +="  ORDER BY car_no ASC, value05 DESC    ";
			

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
			System.out.println("[InsDatabase:getInsChangeList3]\n"+e);
			System.out.println("[InsDatabase:getInsChangeList3]\n"+query);
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
	
	//20170918 보험 변경예정조회1 배서목록 가져오기
		public Vector getInsChangeList4()
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Vector vt = new Vector();
			String query = "";
		

	        //a.value03 = b.car_mng_id 대여
			query = " SELECT decode(a.gubun,'N','0','Y','1','0') as gubun, decode(d.com_emp_yn,'Y','가입','N','미가입') as com_emp_yn, "+
				    "        decode(d.age_scp,'1','21세이상','2','26세이상','3','모든운전자','4','24세이상','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하') as age_scp, "+
				    "        d.firm_emp_nm, decode(d.vins_gcp_kd,'3','1억원','7','2억원','8','3억원','6','5억원','9','10억원') as vins_gcp_kd, "+
				    "        a.reg_code, a.seq, a.value01, d.ins_con_no, e.firm_nm, c.car_no, c.car_nm, CASE WHEN e.client_st='2'  THEN SUBSTR(text_decrypt(e.ssn, 'pw'),0,6)  ELSE e.enp_no END AS enp_no , "+
				    "        d.ins_start_dt, d.ins_exp_dt, a.value06, a.value07, a.value08, a.value05,f.INS_COM_NM , "+
					"        b.rent_l_cd, b.rent_mng_id, d.car_mng_id, d.ins_st "+
					" FROM   INS_EXCEL a, cont b, car_reg c, insur d, client e, ins_com f "+
					" WHERE  a.value03 = b.CAR_MNG_ID AND b.CAR_MNG_ID = c.CAR_MNG_ID "+
					"        AND b.CAR_MNG_ID = d.CAR_MNG_ID AND b.CLIENT_ID = e.CLIENT_ID "+
					"        AND d.INS_COM_ID = f.INS_COM_ID AND b.CAR_ST NOT IN ('5') "+
					"        AND NVL(b.use_yn,'Y') = 'Y' AND d.COM_EMP_YN='Y' "+
					"        AND d.ins_sts='1' AND a.VALUE04 ='보험예정조회1' "+
					"        AND substr(a.VALUE05,1,8) = TO_CHAR(SYSDATE,'YYYYMMDD') ";
					

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
				System.out.println("[InsDatabase:getInsChangeList4]\n"+e);
				System.out.println("[InsDatabase:getInsChangeList4]\n"+query);
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
	
	//20161010 보험 변경예정 조회화면 그리드용2 업데이트연동
	public boolean changeInsExcel(String reg_code, String seq, String gubun)
	{
		getConnection();
		boolean flag = true;
		String query = "update ins_excel set"+
							" gubun = ?"+
							" where reg_code = ? and seq = ?";
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, gubun);
			pstmt.setString(2, reg_code);
			pstmt.setString(3, seq);
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[InsDatabase:changeInsExcel]"+ e);
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


	//해지보험관리 리스트 조회 - 해지보험공문 작성시 조회
	public Hashtable getInsClsCoolMsg(String car_mng_id, String ins_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "", sub_query = "";
		String dt = "";
					
			query = " select d.car_no, d.car_nm, c.firm_nm, \n"+
					" CASE \n"+ 
					" WHEN c.client_st='2'  \n"+
					" THEN SUBSTR(text_decrypt(c.ssn, 'pw'),0,6)  \n"+
					" ELSE c.enp_no \n"+
					" END AS enp_no, \n"+
					" a.rent_start_dt, a.rent_end_dt, DECODE(b.COM_EMP_YN,'Y','가입','N','미가입','') AS com_emp_yn, e.ins_com_nm, b.INS_START_DT, b.ins_exp_dt,b.ins_con_no \n"+
					" FROM cont a , insur b, client c, car_reg d, ins_com e \n"+
					" WHERE \n"+
					" a.car_mng_id= b.car_mng_id \n"+
					" AND a.CLIENT_ID = c.CLIENT_ID \n"+
					" AND a.car_mng_id = d.car_mng_id \n"+
					" AND b.ins_com_id = e.ins_com_id \n"+
					" and a.car_mng_id='"+car_mng_id+"' and b.ins_st='"+ins_st+"'";

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
			
			System.out.println("[InsDatabase:getInsClsCoolMsg(String car_mng_id, String ins_st)]"+ e);
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

	//조건별 보험가입현황
	public int getInsureStatSearchListAmt(String gubun1, String gubun2, String s_st, String age_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs2 = null;
		int ins_amt = 0;
		String query = "";

		query = " SELECT "+
//				"        trunc(avg(NVL(c.rins_pcp_amt,0)+NVL(c.vins_pcp_amt,0)+NVL(c.vins_gcp_amt,0)+NVL(c.vins_bacdt_amt,0)+NVL(c.vins_canoisr_amt,0)+NVL(c.vins_share_extra_amt,0)+NVL(c.vins_spe_amt,0))) as ins_amt "+
			    "        trunc(avg(CASE WHEN TRUNC(TO_DATE(c.INS_EXP_DT,'YYYYMMDD')-TO_DATE(c.INS_START_DT,'YYYYMMDD')) IN (366,365) THEN NVL(c.rins_pcp_amt,0)+NVL(c.vins_pcp_amt,0)+NVL(c.vins_gcp_amt,0)+NVL(c.vins_bacdt_amt,0)+NVL(c.vins_canoisr_amt,0)+NVL(c.vins_share_extra_amt,0)+NVL(c.vins_spe_amt,0) \n"+
                "             ELSE TRUNC((NVL(c.rins_pcp_amt,0)+NVL(c.vins_pcp_amt,0)+NVL(c.vins_gcp_amt,0)+NVL(c.vins_bacdt_amt,0)+NVL(c.vins_canoisr_amt,0)+NVL(c.vins_share_extra_amt,0)+NVL(c.vins_spe_amt,0))/TRUNC(TO_DATE(c.INS_EXP_DT,'YYYYMMDD')-TO_DATE(c.INS_START_DT,'YYYYMMDD'))*365) \n"+
                "        END)) g_2 \n"+
				" FROM   CONT a, CAR_REG b, INSUR c, CAR_ETC d, CAR_NM e, ins_com f  "+
				" WHERE  (a.use_yn='Y' or a.use_yn is null) and a.rent_l_cd not like 'RM%' "+
				"        AND a.car_mng_id=b.car_mng_id AND nvl(b.prepare,'0')<>'4' "+
				"        AND b.car_mng_id=c.car_mng_id AND c.ins_sts='1' and c.ins_exp_dt>= to_char(sysdate,'YYYYMMDD') and c.rins_pcp_amt > 0 "+
				" ";

		if(!gubun1.equals(""))			query += " and b.car_use='"+gubun1+"' ";

		if(gubun1.equals("1"))			query += " and c.ins_start_dt >= to_char(sysdate-30,'YYYYMMDD') ";	
		if(gubun1.equals("2"))			query += " and c.ins_start_dt >= to_char(sysdate-90,'YYYYMMDD') ";	

		if(gubun2.equals("1"))			query += " and c.con_f_nm like '%아마존카%'";
		if(gubun2.equals("2"))			query += " and c.con_f_nm not like '%아마존카%'";

		if(!s_st.equals(""))			query += " and DECODE(e.s_st,'100','100, 101','101','100, 101','409','100, 101','112','102, 112','102','102, 112','104','104, 105','105','104, 105','601','601, 602','602','601, 602','300','102, 112','301','103','302','104, 105',e.s_st)='"+s_st+"'";

		if(!age_st.equals(""))			query += " and c.age_scp='"+age_st+"' ";


		query +="        AND a.rent_mng_id=d.rent_mng_id AND a.rent_l_cd=d.rent_l_cd "+
				"        AND d.car_id=e.car_id AND d.car_seq=e.car_seq and c.ins_com_id=f.ins_com_id  "+
				" ";


		try {
				
			pstmt = conn.prepareStatement(query);
		    rs = pstmt.executeQuery();
    	
			if(rs.next())
			{	
				ins_amt = Integer.parseInt(rs.getString(1)==null?"0":rs.getString(1));
			}
			rs.close();
			pstmt.close();

			if(ins_amt==0){

				query = " SELECT "+
//						"        trunc(avg(NVL(c.rins_pcp_amt,0)+NVL(c.vins_pcp_amt,0)+NVL(c.vins_gcp_amt,0)+NVL(c.vins_bacdt_amt,0)+NVL(c.vins_canoisr_amt,0)+NVL(c.vins_share_extra_amt,0)+NVL(c.vins_spe_amt,0))) as ins_amt "+
					    "        trunc(avg(CASE WHEN TRUNC(TO_DATE(c.INS_EXP_DT,'YYYYMMDD')-TO_DATE(c.INS_START_DT,'YYYYMMDD')) IN (366,365) THEN NVL(c.rins_pcp_amt,0)+NVL(c.vins_pcp_amt,0)+NVL(c.vins_gcp_amt,0)+NVL(c.vins_bacdt_amt,0)+NVL(c.vins_canoisr_amt,0)+NVL(c.vins_share_extra_amt,0)+NVL(c.vins_spe_amt,0) \n"+
				        "             ELSE TRUNC((NVL(c.rins_pcp_amt,0)+NVL(c.vins_pcp_amt,0)+NVL(c.vins_gcp_amt,0)+NVL(c.vins_bacdt_amt,0)+NVL(c.vins_canoisr_amt,0)+NVL(c.vins_share_extra_amt,0)+NVL(c.vins_spe_amt,0))/TRUNC(TO_DATE(c.INS_EXP_DT,'YYYYMMDD')-TO_DATE(c.INS_START_DT,'YYYYMMDD'))*365) \n"+
						"        END)) g_2 \n"+
						" FROM   CONT a, CAR_REG b, INSUR c, CAR_ETC d, CAR_NM e, ins_com f  "+
						" WHERE  (a.use_yn='Y' or a.use_yn is null) and a.rent_l_cd not like 'RM%' "+
						"        AND a.car_mng_id=b.car_mng_id AND nvl(b.prepare,'0')<>'4' "+
						"        AND b.car_mng_id=c.car_mng_id AND c.ins_sts='1' and c.ins_exp_dt>= to_char(sysdate,'YYYYMMDD') and c.rins_pcp_amt > 0 "+
						" ";

				if(!gubun1.equals(""))			query += " and b.car_use='"+gubun1+"' ";

				if(gubun2.equals("1"))			query += " and c.con_f_nm like '%아마존카%'";
				if(gubun2.equals("2"))			query += " and c.con_f_nm not like '%아마존카%'";

				if(!s_st.equals(""))			query += " and DECODE(e.s_st,'100','100, 101','101','100, 101','409','100, 101','112','102, 112','102','102, 112','104','104, 105','105','104, 105','601','601, 602','602','601, 602','300','102, 112','301','103','302','104, 105',e.s_st)='"+s_st+"'";

				if(!age_st.equals(""))			query += " and c.age_scp='"+age_st+"' ";


				query +="        AND a.rent_mng_id=d.rent_mng_id AND a.rent_l_cd=d.rent_l_cd "+
						"        AND d.car_id=e.car_id AND d.car_seq=e.car_seq and c.ins_com_id=f.ins_com_id  "+
						" order by c.ins_start_dt desc ";

				pstmt2 = conn.prepareStatement(query);
			    rs2 = pstmt2.executeQuery();
  		
				if(rs2.next())
				{								
					 ins_amt = Integer.parseInt(rs2.getString(1)==null?"0":rs2.getString(1));
				}
				rs2.close();
				pstmt2.close();


			}

		} catch (SQLException e) {
			System.out.println("[InsDatabase:getInsureStatSearchListAmt]\n"+e);
			System.out.println("[InsDatabase:getInsureStatSearchListAmt]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
                if(rs2 != null )	rs2.close();
                if(pstmt2 != null)	pstmt2.close();
			}catch(Exception ignore){}
			closeConnection();
			return ins_amt;
		}		
	}

	//보험관리 리스트 조회엑셀
	public Hashtable getInsClsMng(String car_mng_id, String ins_st)
	{
		
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
					
			query = " select * from "+
					" ( "+
					//용도변경
					"	select "+
					"	       f.car_mng_id, f.ins_st, a.car_no, a.car_nm, '1' as gubun1, '용도변경' as cau,"+
					"	       c.car_no as be_car_no, c.cha_seq as be_seq, b.car_no as af_car_no, b.cha_seq as af_seq, "+
					"	       b.cha_dt as ch_dt, '' migr_dt, '' udt_dt, REPLACE(h.ins_con_no,'-','') ins_con_no, "+
					"	       b.cha_cau_sub as ch_sub,"+
					"	       d.exp_st, d.exp_aim, d.exp_dt, d.req_dt, d.rtn_est_amt, d.rtn_amt, d.rtn_dt, e.pay_dt, e.pay_amt,"+
					"	       '' as stat, decode(f.ins_st,'','미가입','가입') ins_stat, i.ins_com_nm, i.ins_com_id "+
					"	from   car_reg a, car_change b, car_change c, (select * from ins_cls where exp_st in ('1','2') and exp_aim in ('1','2','9')) d, "+
					"		   (select car_mng_id, ins_st, pay_dt, pay_amt from scd_ins where ins_tm2='2') e, "+
					"	       (select car_mng_id, to_char(max(TO_NUMBER(ins_st))) ins_st from insur group by car_mng_id) f, INSUR h, INS_COM i "+
					"	where  a.car_mng_id='"+car_mng_id+"' "+
					"	       and a.car_mng_id=b.car_mng_id and b.cha_cau='2' "+
					"	       and b.car_mng_id=c.car_mng_id and c.cha_seq=b.cha_seq-1 "+
					"	       and b.car_mng_id=d.car_mng_id(+) "+
					"	       and b.cha_dt=d.exp_dt(+) "+
					"	       and d.car_mng_id=e.car_mng_id(+) and d.ins_st=e.ins_st(+) "+
					"	       and a.car_mng_id=f.car_mng_id"+
                    "          AND f.car_mng_id=h.car_mng_id AND f.ins_st=h.ins_st AND h.ins_com_id=i.ins_com_id "+  
					"          and h.ins_start_dt > '20141231' "+		
					"	union all"+
					//매각
					/*"	select "+
					"	       g.car_mng_id, g.ins_st, c.car_no, c.car_nm, decode(b.cls_st,'6','2','8','3','9','4') gubun1, decode(b.cls_st,'6','매각','8','매입옵션','9','폐차') cau, "+
					"	       ''  as be_car_no, '' as be_seq, '' as af_car_no, '' as af_seq, "+
					"	       NVL(d.migr_dt,nvl(d.cont_dt,b.cls_dt)) ch_dt, d.migr_dt, d.udt_dt,  h.ins_con_no, "+
					"	       decode(d.migr_dt, '', decode(d.cont_dt,'', '해지일', '계약일'), '명의이전일') ch_sub,"+
					"	       e.exp_st, e.exp_aim, e.exp_dt, e.req_dt, e.rtn_est_amt, e.rtn_amt, e.rtn_dt, f.pay_dt, f.pay_amt,"+
					"	       decode(d.car_mng_id,'','미등록','등록') stat, decode(g.ins_st,'','미가입','가입') ins_stat, i.ins_com_nm, i.ins_com_id "+
					"	from   cont a, cls_cont b, car_reg c, sui d,  "+
					"	       (select car_mng_id, ins_st, pay_dt, pay_amt from scd_ins where ins_tm2='2') f, "+
					"	       (select car_mng_id, max(ins_st) ins_st from insur group by car_mng_id) g, INSUR h, INS_COM i, "+
                    "          ins_cls e "+  
					"	where  a.car_mng_id='"+car_mng_id+"'"+
					"	       and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.cls_st in ('6','8','9') "+
					"	       and a.car_mng_id=c.car_mng_id "+
					"	       and a.car_mng_id=d.car_mng_id(+) "+
					"	       and e.car_mng_id=f.car_mng_id(+) and e.ins_st=f.ins_st(+) "+
					"	       and a.car_mng_id=g.car_mng_id"+
                    "          AND g.car_mng_id=h.car_mng_id AND g.ins_st=h.ins_st AND h.ins_com_id=i.ins_com_id and h.ins_com_id<>'0031' "+  
                    "          AND (NVL(d.migr_dt,nvl(d.cont_dt,b.cls_dt)) > h.ins_start_dt or h.INS_STS = '1') "+ 
                    "		   AND NVL(d.migr_dt,nvl(d.cont_dt,b.cls_dt)) < h.ins_exp_dt "+
					"          and h.ins_start_dt > '20091231'  "+		
					"	       and h.car_mng_id=e.car_mng_id(+) and h.ins_st=e.ins_st(+) "+*/
					// 20171011 보험 마지막 건 뿐 아니라 다른 건에서도 보험기간에 해지일이 포함되면 해지리스트에 나오게 끔 수정(고영은씨 요청/ jhChoi)
					"  select "+
					"	       h.car_mng_id, h.ins_st, c.car_no, c.car_nm, decode(b.cls_st,'6','2','8','3','9','4') gubun1, decode(b.cls_st,'6','매각','8','매입옵션','9','폐차') cau, "+
					"	       ''  as be_car_no, '' as be_seq, '' as af_car_no, '' as af_seq, "+
					"	       (CASE WHEN B.CLS_ST = '8' AND I.INS_COM_ID = '0007' THEN NVL(d.cont_dt, nvl(d.migr_dt, b.cls_dt)) ELSE NVL(d.migr_dt, nvl(d.cont_dt, b.cls_dt)) END) AS CH_DT, d.migr_dt, d.udt_dt,  REPLACE(h.ins_con_no,'-','') ins_con_no, "+
					"	       decode(d.migr_dt, '', decode(d.cont_dt,'', '해지일', '계약일'), '명의이전일') ch_sub,"+
					"	       e.exp_st, e.exp_aim, e.exp_dt, e.req_dt, e.rtn_est_amt, e.rtn_amt, e.rtn_dt, f.pay_dt, f.pay_amt,"+
					"	       decode(d.car_mng_id,'','미등록','등록') stat, decode(h.ins_st,'','미가입','가입') ins_stat, i.ins_com_nm, i.ins_com_id "+
					"	from   cont a, cls_cont b, car_reg c, sui d,  "+
					"	       (select car_mng_id, ins_st, pay_dt, pay_amt from scd_ins where ins_tm2='2') f, "+
			//		"	       (select car_mng_id, max(ins_st) ins_st from insur group by car_mng_id) g, "+
                    "          INSUR h, INS_COM i,ins_cls e "+  
					"	where  a.car_mng_id='"+car_mng_id+"'"+
					"	       and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.cls_st in ('6','8','9') "+
					"	       and a.car_mng_id=c.car_mng_id "+
					"	       and a.car_mng_id=d.car_mng_id(+) "+
					"	       and e.car_mng_id=f.car_mng_id(+) and e.ins_st=f.ins_st(+) "+
					"	       and a.car_mng_id=h.car_mng_id"+
                //    "          AND g.car_mng_id=h.car_mng_id AND g.ins_st=h.ins_st "+  
                    "          AND h.ins_com_id=i.ins_com_id and h.ins_com_id<>'0031' "+  
                    "          AND (NVL(d.migr_dt,nvl(d.cont_dt,b.cls_dt)) > h.ins_start_dt or h.INS_STS = '1') "+ 
                    "		   AND NVL(d.migr_dt,nvl(d.cont_dt,b.cls_dt)) < h.ins_exp_dt "+
					"          and h.ins_start_dt > '20141231'  "+		
					"	       and h.car_mng_id=e.car_mng_id(+) and h.ins_st=e.ins_st(+) "+
					" )"+
					" where car_mng_id='"+car_mng_id+"' and ins_st='"+ins_st+"' ";

			query += " and req_dt is null";

			query += " and ch_dt is not null and to_number(ch_dt)>=20150101 ";
//			query += " and d.migr_dt is not null and to_number(d.migr_dt)>=20150101 ";
		
			
			

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
			
			System.out.println("[InsDatabase:getInsClsMng]"+ e);
			System.out.println("[InsDatabase:getInsClsMng]"+ query);
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
	//낙찰현황 매각 처리에 대한 
	public Hashtable getInsClsMng2(String car_mng_id, String ins_st)
	{
		
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		
		query =		"  select "+
					"	       h.car_mng_id, h.ins_st, c.car_no, c.car_nm, decode(b.cls_st,'6','2','8','3','9','4') gubun1, decode(b.cls_st,'6','매각','8','매입옵션','9','폐차') cau, "+
					"	       ''  as be_car_no, '' as be_seq, '' as af_car_no, '' as af_seq, "+
					"	       NVL(d.migr_dt,nvl(d.cont_dt,b.cls_dt)) ch_dt, d.migr_dt, d.udt_dt,  h.ins_con_no, "+
					"	       decode(d.migr_dt, '', decode(d.cont_dt,'', '해지일', '계약일'), '명의이전일') ch_sub,"+
					"	       e.exp_st, e.exp_aim, e.exp_dt, e.req_dt, e.rtn_est_amt, e.rtn_amt, e.rtn_dt, f.pay_dt, f.pay_amt,"+
					"	       decode(d.car_mng_id,'','미등록','등록') stat, decode(h.ins_st,'','미가입','가입') ins_stat, i.ins_com_nm, i.ins_com_id "+
					"	from   cont a, cls_cont b, car_reg c, sui d,  "+
					"	       (select car_mng_id, ins_st, pay_dt, pay_amt from scd_ins where ins_tm2='2') f, "+
					"          INSUR h, INS_COM i,ins_cls e "+  
					"	where  a.car_mng_id='"+car_mng_id+"'"+
					"	       and a.rent_mng_id=b.rent_mng_id(+) and a.rent_l_cd=b.rent_l_cd(+) and (b.cls_st in ('6','8','9') OR USE_YN = 'Y')  "+
					"	       and a.car_mng_id=c.car_mng_id "+
					"	       and a.car_mng_id=d.car_mng_id(+) "+
					"	       and e.car_mng_id=f.car_mng_id(+) and e.ins_st=f.ins_st(+) "+
					"	       and a.car_mng_id=h.car_mng_id"+
					"          AND h.ins_com_id=i.ins_com_id and h.ins_com_id<>'0031' "+  
					"          AND (NVL(d.migr_dt,nvl(d.cont_dt,b.cls_dt)) > h.ins_start_dt or h.INS_STS = '1') "+ 
					"		   AND NVL(d.migr_dt,nvl(d.cont_dt,b.cls_dt)) < h.ins_exp_dt "+
					"          and h.ins_start_dt > '20141231'  "+		
					"	       and h.car_mng_id=e.car_mng_id(+) and h.ins_st=e.ins_st(+) "+
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
			
			System.out.println("[InsDatabase:getInsClsMng2]"+ e);
			System.out.println("[InsDatabase:getInsClsMng2]"+ query);
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
	
		//보험관리 고객 사업자명 가져오기
		public Hashtable getClientInfo(String INS_CON_NO)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Hashtable ht = new Hashtable();
			String query = "", sub_query = "";
			String dt = "";
						

			query = " SELECT a.INS_CON_NO, SUBSTR(d.FIRM_NM,1,17) FIRM_NM, "+
					" CASE "+
					" WHEN d.CLIENT_nm = d.FIRM_NM THEN substr(TEXT_DECRYPT(d.ssn, 'pw' ),1,6) "+
					" ELSE DECODE(d.ENP_NO,NULL,substr(TEXT_DECRYPT(d.ssn, 'pw' ),1,6),d.ENP_NO) "+
					" END AS ENP_NO,"+
				    " b.CAR_NO"+
					" FROM insur a, car_reg b, cont c, client d "+
					" WHERE INS_CON_NO =  '"+ INS_CON_NO +"'  "+ 
					" AND  a.CAR_MNG_ID = b.CAR_MNG_ID"+
					" AND a.CAR_MNG_ID = c.CAR_MNG_ID"+
					" AND c.CLIENT_ID = d.CLIENT_ID"+
					" AND ins_con_no IS NOT NULL"+
					" AND  NVL(use_yn,'Y') ='Y' ";              
			
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
				
				System.out.println("[InsDatabase:getClientInfo(String INS_CON_NO)]"+ e);
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
		//보험관리 고객 사업자명 가져오기(EXCEL)
		public Hashtable getClientInfoExcel(String INS_CON_NO)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Hashtable ht = new Hashtable();
			String query = "", sub_query = "";
			String dt = "";
			
			
			query = " SELECT a.INS_CON_NO, d.FIRM_NM , "+
					" CASE "+
					" WHEN d.CLIENT_nm = d.FIRM_NM THEN substr(TEXT_DECRYPT(d.ssn, 'pw' ),1,6) "+
					" ELSE DECODE(d.ENP_NO,NULL,substr(TEXT_DECRYPT(d.ssn, 'pw' ),1,6),d.ENP_NO) "+
					" END AS ENP_NO,"+
					" b.CAR_NO, b.CAR_NUM, a.INS_START_DT, a.INS_EXP_DT, "+
					" DECODE(c.DRIVING_AGE,'0','26세','1','21세','3','24세') AGE,  "+
					" CASE  "+
					"  			WHEN CLIENT_ST = '1'  AND JG_CODE > '1999999' AND JG_CODE < '7000000' THEN 'Y' "+
					"       ELSE NVL(e.COM_EMP_YN,'N') "+
					"       END AS COM_EMP_YN ,RENT_START_DT, RENT_END_DT, e.CAR_DELI_DT, e.RENT_SUC_DT "+
					"  FROM insur a, car_reg b, cont c, client d, cont_etc e, car_etc f, car_nm g "+
					"  WHERE ins_con_no ='"+ INS_CON_NO +"'  "+
			        "  AND a.CAR_MNG_ID = b.CAR_MNG_ID "+
			        "  AND a.CAR_MNG_ID = c.CAR_MNG_ID "+
			        "  AND c.CLIENT_ID = d.CLIENT_ID "+
			        "  AND c.RENT_L_CD = e.rent_L_CD "+
			        "  AND c.RENT_MNG_ID = f.RENT_MNG_ID "+
			        "  AND c.RENT_L_CD = f.RENT_L_CD "+
			        "  AND f.CAR_ID = g.CAR_ID  "+
			        "  AND f.CAR_SEQ = g.CAR_SEQ "+
			        "  AND ins_con_no IS NOT NULL "+
			        "  AND  NVL(c.use_yn,'Y') ='Y' ";
			
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
				
				System.out.println("[InsDatabase:getClientInfo(String INS_CON_NO)]"+ e);
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
		
		//증권번호로 보험정보 가져오기
		public Hashtable getClientInfoExcel2(String ins_con_no)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Hashtable ht = new Hashtable();
			String query = "", sub_query = "";
			String dt = "";
			
			
			query = " SELECT NVL(ins_con_no,'없음') ins_con_no, NVL(firm_emp_nm,'없음') firm_emp_nm, NVL(enp_no,'없음') enp_no, "+
					" decode(age_scp,'','21세이상','1','21세이상','2','26세이상','3','모든운전자','4','24세이상','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하') as age_scp, "+
					" decode(vins_gcp_kd,'','1억원','3','1억원','7','2억원','8','3억원','6','5억원','9','10억원') as vins_gcp_kd, "+
					" decode(COM_EMP_YN,'Y','가입','N','미가입','미가입')  as com_emp_yn "+
					" FROM INSUR "+
					" WHERE INS_CON_NO = '"+ins_con_no+"' ";
			
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
				
				System.out.println("[InsDatabase:getClientInfoExcel2(String ins_con_no)]"+ e);
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
		 *	보험동기화 (EXCEL)
		 */
		public boolean updateClientInfo(String ins_con_no,String firm_emp_nm,String enp_no,String ins_start_dt,String ins_exp_dt,String age_scp,String com_emp_yn)
		{
			getConnection();
			boolean flag = true;
			String query = " update insur set			"+
							"       FIRM_EMP_NM=?,		"+
							"       ENP_NO=?,			"+
							"       INS_START_DT=?,		"+
							"       INS_EXP_DT=?,		"+
							"       AGE_SCP=?,			"+
							"       COM_EMP_YN=?		"+
							" where INS_CON_NO=? ";

			PreparedStatement pstmt = null;

			try 
			{
				conn.setAutoCommit(false);
						
				pstmt = conn.prepareStatement(query);
				//set
				pstmt.setString(1, firm_emp_nm);
				pstmt.setString(2, enp_no);
				pstmt.setString(3, ins_start_dt);
				pstmt.setString(4, ins_exp_dt);
				pstmt.setString(5, age_scp);
				pstmt.setString(6, com_emp_yn);
				//where
				pstmt.setString(7, ins_con_no);
			    pstmt.executeUpdate();
				pstmt.close();
			    
			    conn.commit();
			} catch (Exception e) {
				System.out.println("[InsDatabase:updateClientInfo]"+ e);
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
		
		//보험관리 고객 사업자명 가져오기(2017-11-07)-변경될건들만
				public Hashtable getClientInsInfo(String car_no)
				{
					getConnection();
					PreparedStatement pstmt = null;
					ResultSet rs = null;
					Hashtable ht = new Hashtable();
					String query = "", sub_query = "";
					String dt = "";
								

					query = //대여차량 
							"SELECT * FROM ( 																																															\n"+
							"SELECT a.rent_mng_id, a.rent_l_cd, a.car_mng_id, b.ins_st, f.rent_s_cd, f.sub_l_cd,                                                                                           \n"+
							"       d.car_no, d.car_nm,                                                                                                                                                    \n"+
							"       '대여차량' car_st,                                                                                                                                                         \n"+
							"       REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(DECODE(a.car_st,'5','(주)아마존카/')||c.firm_nm,' ',''),'(주)',''),'주식회사',''),'㈜',''),'주)',''),'(주','') as firm_nm,          \n"+
							"       CASE WHEN a.car_st='5' THEN '1288147957' WHEN c.client_st='2' THEN SUBSTR(text_decrypt(c.ssn, 'pw'),0,6) ELSE c.enp_no END AS enp_no,                                  \n"+
							"       DECODE(a.car_st,'5','(주)아마존카/')||c.firm_nm AS r_firm_nm,                                                                                                               \n"+
							"       CASE WHEN a.car_st='5' THEN '1288147957' WHEN c.client_st='2'  THEN SUBSTR(text_decrypt(c.ssn, 'pw'),0,6) ELSE c.enp_no END AS r_enp_no,                               \n"+
							"       REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(NVL(c2.firm_nm,'없음'),' ',''),'(주)',''),'주식회사',''),'㈜',''),'주)',''),'(주','') AS firm_nm2,                               \n"+
							"       NVL(CASE WHEN c2.client_st='2'  THEN SUBSTR(text_decrypt(c2.ssn, 'pw'),0,6) ELSE c2.enp_no END,'없음') AS enp_no2,                                                       \n"+
							"       NVL(c2.firm_nm,'없음') AS r_firm_nm2,                                                                                                                                    \n"+
							"       NVL(CASE WHEN c2.client_st='2'  THEN SUBSTR(text_decrypt(c2.ssn, 'pw'),0,6) ELSE c2.enp_no END,'없음') AS r_enp_no2,                                                     \n"+
							"			 DECODE(g.rent_suc_dt,'',a.rent_start_dt,g.rent_suc_dt) AS rent_start_dt,                                                                                          \n"+
							"       CASE WHEN h.use_e_dt IS NULL THEN a.rent_end_dt WHEN h.use_e_dt IS NOT NULL AND h.use_e_dt > a.rent_end_dt THEN h.use_e_dt ELSE a.rent_end_dt END rent_end_dt,         \n"+
							"       decode(a.driving_age,'0','26세이상','3','24세이상','1','21세이상','2','모든운전자','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하') a_age_scp,                                       \n"+
							"       decode(a.GCP_KD,'1','5천만원','2','1억원','3','5억원','4','2억원','8','3억원','9','10억원') a_GCP_KD,                                                                                          \n"+
							"       decode(g.COM_EMP_YN,'Y','가입','N','미가입',decode(b.COM_EMP_YN,'Y','가입','N','미가입','미가입')) a_COM_EMP_YN,                                                                    \n"+
							"       REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(NVL(b.firm_emp_nm,'없음'),' ',''),'(주)',''),'주식회사',''),'㈜',''),'주)',''),'(주','') AS firm_emp_nm,                         \n"+
							"       NVL(b.enp_no,'없음') b_enp_no,                                                                                                                                           \n"+
							"       NVL(b.firm_emp_nm,'없음') r_firm_emp_nm,                                                                                                                                 \n"+
							"       NVL(b.enp_no,'없음') r_b_enp_no,                                                                                                                                         \n"+
							"       e.ins_com_id, e.ins_com_nm,                                                                                                                                            \n"+
							"			 b.ins_start_dt, b.ins_exp_dt,                                                                                                                                     \n"+
							"       decode(b.age_scp,'2','26세이상','4','24세이상','1','21세이상','3','모든운전자','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하') b_age_scp,                                           \n"+
							"       decode(b.vins_gcp_kd,'4','5천만원','3','1억원','6','5억원','7','2억원','8','3억원','9','10억원','그외') b_GCP_KD,                                                                                \n"+
							"       decode(b.COM_EMP_YN,'Y','가입','N','미가입','미가입') b_COM_EMP_YN,                                                                                                            \n"+
							"       c.client_st, j.s_st                                                                                                                                                    \n"+
							"FROM   cont a, insur b, client c, car_reg d, ins_com e,                                                                                                                       \n"+
							"       (select car_mng_id, rent_s_cd, sub_l_cd, rent_st, cust_id from rent_cont where rent_st IN ('2','3','10') and use_st='2') f, client c2,                                 \n"+
							"       cont_etc g,                                                                                                                                                            \n"+
							"       (SELECT rent_mng_id, rent_l_cd, max(use_e_dt) use_e_dt FROM scd_fee WHERE bill_yn='Y' GROUP BY rent_mng_id, rent_l_cd) h,                                              \n"+
							"       car_etc i, car_nm j                                                                                                                                                    \n"+
							"WHERE  NVL(a.use_yn,'Y')='Y'                                                                                                                                                  \n"+
							"       AND a.car_st<>'2'                                                                                                                                                      \n"+
							"       AND a.car_mng_id=b.car_mng_id AND b.ins_sts='1'                                                                                                                        \n"+
							"       AND a.client_id=c.client_id                                                                                                                                            \n"+
							"       AND a.car_mng_id=d.car_mng_id                                                                                                                                          \n"+
							"       AND b.ins_com_id=e.ins_com_id                                                                                                                                          \n"+
							"       AND a.car_mng_id=f.car_mng_id(+) AND f.rent_s_cd IS null                                                                                                               \n"+
							"       AND f.cust_id=c2.client_id(+)                                                                                                                                          \n"+
							"       AND b.ins_com_id='0038'                                                                                                                                                \n"+
							"       AND a.rent_mng_id=g.rent_mng_id AND a.rent_l_cd=g.rent_l_cd                                                                                                            \n"+
							"       AND a.rent_mng_id=h.rent_mng_id(+) AND a.rent_l_cd=h.rent_l_cd(+)                                                                                                      \n"+
							"       AND a.rent_mng_id=i.rent_mng_id AND a.rent_l_cd=i.rent_l_cd                                                                                                            \n"+
							"       AND i.car_id=j.car_id AND i.car_seq=j.car_seq                                                                                                                          \n"+
							"       AND DECODE(g.rent_suc_dt,'',a.rent_start_dt,g.rent_suc_dt) <= TO_CHAR(SYSDATE,'YYYYMMDD')                                                                              \n"+
							"       AND TO_CHAR(SYSDATE,'YYYYMMDD') BETWEEN b.ins_start_dt AND b.ins_exp_dt                                                                                                \n"+
							"       AND (  (INSTR(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(DECODE(a.car_st,'5','(주)아마존카/')||c.firm_nm,' ',''),'(주)',''),'주식회사',''),'㈜',''),'주)',''),'(주',''),   "+
							"				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(NVL(b.firm_emp_nm,'없음'),' ',''),'(주)',''),'주식회사',''),'㈜',''),'주)',''),'(주',''))=0                           "+
							"				AND REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(NVL(b.firm_emp_nm,'없음'),' ',''),'(주)',''),'주식회사',''),'㈜',''),'주)',''),'(주','')                          "+
							"				<>REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(DECODE(a.car_st,'5','(주)아마존카/')||c.firm_nm,' ',''),'(주)',''),'주식회사',''),'㈜',''),'주)',''),'(주','')) or    \n"+
							"               (NVL(b.enp_no,'없음')<>CASE WHEN c.client_st='2'  THEN SUBSTR(text_decrypt(c.ssn, 'pw'),0,6) ELSE c.enp_no END) OR                                               \n"+
							"               (decode(b.age_scp,'2','26세이상','4','24세이상','1','21세이상','3','모든운전자','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하')                                          "+
							"				<>decode(a.driving_age,'0','26세이상','3','24세이상','1','21세이상','2','모든운전자','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하')) OR                                 \n"+
							"               (decode(b.vins_gcp_kd,'4','5천만원','3','1억원','6','5억원','7','2억원','8','3억원','9','10억원','그외')<>decode(a.GCP_KD,'1','5천만원','2','1억원','3','5억원','4','2억원','8','3억원','9','10억원')) OR      \n"+
							"               (decode(b.COM_EMP_YN,'Y','가입','N','미가입','미가입')<>decode(g.COM_EMP_YN,'Y','가입','N','미가입',decode(b.COM_EMP_YN,'Y','가입','N','미가입','미가입')))                       "+
							"           )                                                                                                                                                                \n"+
							"UNION ALL                                                                                                                                                                   \n"+
							//지연대차                                                                                                                                                                   
							"SELECT a.rent_mng_id, a.rent_l_cd, a.car_mng_id, b.ins_st, f.rent_s_cd, f.sub_l_cd,                                                                                         \n"+
							"       d.car_no, d.car_nm,                                                                                                                                                  \n"+
							"       DECODE(a.car_st,'2',DECODE(f.rent_st,'2','정비대차','3','사고대차','10','지연대차','보유차'),'대여차량') car_st,                                                                        \n"+
							"       REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(DECODE(a.car_st,'5','(주)아마존카/')||c.firm_nm,' ',''),'(주)',''),'주식회사',''),'㈜',''),'주)',''),'(주','') as firm_nm,        \n"+
							"       CASE WHEN c.client_st='2'  THEN SUBSTR(text_decrypt(c.ssn, 'pw'),0,6) ELSE c.enp_no END AS enp_no,                                                                   \n"+
							"       DECODE(a.car_st,'5','(주)아마존카/')||c.firm_nm AS r_firm_nm,                                                                                                             \n"+
							"       CASE WHEN c.client_st='2'  THEN SUBSTR(text_decrypt(c.ssn, 'pw'),0,6) ELSE c.enp_no END AS r_enp_no,                                                                 \n"+
							"       REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(NVL(c2.firm_nm,'없음'),' ',''),'(주)',''),'주식회사',''),'㈜',''),'주)',''),'(주','') AS firm_nm2,                             \n"+
							"       NVL(CASE WHEN c2.client_st='2'  THEN SUBSTR(text_decrypt(c2.ssn, 'pw'),0,6) ELSE c2.enp_no END,'없음') AS enp_no2,                                                     \n"+
							"       NVL(c2.firm_nm,'없음') AS r_firm_nm2,                                                                                                                                  \n"+
							"       NVL(CASE WHEN c2.client_st='2'  THEN SUBSTR(text_decrypt(c2.ssn, 'pw'),0,6) ELSE c2.enp_no END,'없음') AS r_enp_no2,                                                   \n"+
							"			 SUBSTR(f.deli_dt,1,8) AS rent_start_dt, SUBSTR(f.ret_plan_dt,1,8) AS rent_end_dt,                                                                               \n"+
							"       decode(a2.driving_age,'0','26세이상','3','24세이상','1','21세이상','2','모든운전자','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하') a_age_scp,                                    \n"+
							"       decode(a2.GCP_KD,'1','5천만원','2','1억원','3','5억원','4','2억원','8','3억원','9','10억원') a_GCP_KD,                                                                                       \n"+
							"       decode(NVL(g2.com_emp_yn,f.COM_EMP_YN),'Y','가입','N','미가입',decode(b.COM_EMP_YN,'Y','가입','N','미가입','미가입')) a_COM_EMP_YN,                                               \n"+
							"       REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(NVL(b.firm_emp_nm,'없음'),' ',''),'(주)',''),'주식회사',''),'㈜',''),'주)',''),'(주','') AS firm_emp_nm,                       \n"+
							"       NVL(b.enp_no,'없음') b_enp_no,                                                                                                                                         \n"+
							"       NVL(b.firm_emp_nm,'없음') r_firm_emp_nm,                                                                                                                                        \n"+
							"       NVL(b.enp_no,'없음') r_b_enp_no,                                                                                                                                                \n"+
							"       e.ins_com_id, e.ins_com_nm,                                                                                                                                                   \n"+
							"			 b.ins_start_dt, b.ins_exp_dt,                                                                                                                                            \n"+
							"       decode(b.age_scp,'2','26세이상','4','24세이상','1','21세이상','3','모든운전자','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하') b_age_scp,                                                  \n"+
							"       decode(b.vins_gcp_kd,'4','5천만원','3','1억원','6','5억원','7','2억원','8','3억원','9','10억원','그외') b_GCP_KD,                                                                                       \n"+
							"       decode(b.COM_EMP_YN,'Y','가입','N','미가입','미가입') b_COM_EMP_YN,                                                                                                                   \n"+
							"       c2.client_st, j.s_st                                                                                                                                                          \n"+
							"FROM   cont a, insur b, client c, car_reg d, ins_com e,                                                                                                                              \n"+
							"       (select car_mng_id, rent_s_cd, sub_l_cd, rent_st, cust_id, deli_dt, ret_plan_dt, com_emp_yn from rent_cont where rent_st IN ('10') and use_st='2') f, client c2,              \n"+
							"       cont_etc g, cont a2, cont_etc g2,                                                                                                                                             \n"+
							"       car_etc i, car_nm j                                                                                                                                                           \n"+
							"WHERE  a.use_yn='Y'                                                                                                                                                                  \n"+
							"       AND a.car_st='2'                                                                                                                                                              \n"+
							"       AND a.car_mng_id=b.car_mng_id AND b.ins_sts='1'                                                                                                                               \n"+
							"       AND a.client_id=c.client_id                                                                                                                                                   \n"+
							"       AND a.car_mng_id=d.car_mng_id                                                                                                                                                 \n"+
							"       AND b.ins_com_id=e.ins_com_id                                                                                                                                                 \n"+
							"       AND a.car_mng_id=f.car_mng_id                                                                                                                                                 \n"+
							"       AND f.cust_id=c2.client_id(+)                                                                                                                                                 \n"+
							"       AND b.ins_com_id='0038'                                                                                                                                                       \n"+
							"       AND a.rent_mng_id=g.rent_mng_id AND a.rent_l_cd=g.rent_l_cd                                                                                                                   \n"+
							"       AND f.sub_l_cd=a2.rent_l_cd(+)                                                                                                                                                \n"+
							"       AND a2.rent_mng_id=g2.rent_mng_id(+) AND a2.rent_l_cd=g2.rent_l_cd(+)                                                                                                         \n"+
							"       AND a.rent_mng_id=i.rent_mng_id AND a.rent_l_cd=i.rent_l_cd                                                                                                                   \n"+
							"       AND i.car_id=j.car_id AND i.car_seq=j.car_seq                                                                                                                                 \n"+
							"       AND SUBSTR(f.deli_dt,1,8) <= TO_CHAR(SYSDATE,'YYYYMMDD')                                                                                                                      \n"+
							"       AND TO_CHAR(SYSDATE,'YYYYMMDD') BETWEEN b.ins_start_dt AND b.ins_exp_dt                                                                                                       \n"+
							"       AND ((INSTR(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(c2.firm_nm,' ',''),'(주)',''),'주식회사',''),'㈜',''),'주)',''),'(주',''),                                                                                                                                                                            "+
							"            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(NVL(b.firm_emp_nm,'없음'),' ',''),'(주)',''),'주식회사',''),'㈜',''),'주)',''),'(주',''))=0                                    "+
							"			 AND REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(NVL(b.firm_emp_nm,'없음'),' ',''),'(주)',''),'주식회사',''),'㈜',''),'주)',''),'(주','') 	                              "+
							"			 <>REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(c2.firm_nm,' ',''),'(주)',''),'주식회사',''),'㈜',''),'주)',''),'(주','')) or      	                                      "+
							"			 (NVL(b.enp_no,'없음')<>CASE WHEN c2.client_st='2'  THEN SUBSTR(text_decrypt(c2.ssn, 'pw'),0,6) ELSE c2.enp_no END) OR	                                                \n"+
							"            (f.sub_l_cd IS NOT NULL AND decode(b.age_scp,'2','26세이상','4','24세이상','1','21세이상','3','모든운전자','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하')                 "+
							"            <>decode(a2.driving_age,'0','26세이상','3','24세이상','1','21세이상','2','모든운전자','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하')) OR                                \n"+
							"            (decode(b.COM_EMP_YN,'Y','가입','N','미가입','미가입')<>decode(NVL(g2.com_emp_yn,f.COM_EMP_YN),'Y','가입','N','미가입',decode(b.COM_EMP_YN,'Y','가입','N','미가입','미가입')))       "+
							"           )                                                                                                                                                                         \n"+
							"UNION ALL                                                                                                                                                                            \n"+
							//정비대차,사고대차                                                                                                                                                                          																		/
							"SELECT a.rent_mng_id, a.rent_l_cd, a.car_mng_id, b.ins_st, f.rent_s_cd, f.sub_l_cd,                                                                                                  \n"+
							"       d.car_no, d.car_nm,                                                                                                                                                           \n"+
							"       DECODE(a.car_st,'2',DECODE(f.rent_st,'2','정비대차','3','사고대차','10','지연대차','보유차'),'대여차량') car_st,                                                                                 \n"+
							"       REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(DECODE(a.car_st,'5','(주)아마존카/')||c.firm_nm,' ',''),'(주)',''),'주식회사',''),'㈜',''),'주)',''),'(주','') as firm_nm,                 \n"+
							"       CASE WHEN c.client_st='2'  THEN SUBSTR(text_decrypt(c.ssn, 'pw'),0,6) ELSE c.enp_no END AS enp_no,                                                                            \n"+
							"       DECODE(a.car_st,'5','(주)아마존카/')||c.firm_nm AS r_firm_nm,                                                                                                                      \n"+
							"       CASE WHEN c.client_st='2'  THEN SUBSTR(text_decrypt(c.ssn, 'pw'),0,6) ELSE c.enp_no END AS r_enp_no,                                                                          \n"+
							"       REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(NVL(c2.firm_nm,'없음'),' ',''),'(주)',''),'주식회사',''),'㈜',''),'주)',''),'(주','') AS firm_nm2,                                      \n"+
							"       NVL(CASE WHEN c2.client_st='2'  THEN SUBSTR(text_decrypt(c2.ssn, 'pw'),0,6) ELSE c2.enp_no END,'없음') AS enp_no2,                                                              \n"+
							"       NVL(c2.firm_nm,'없음') AS r_firm_nm2,                                                                                                                                           \n"+
							"       NVL(CASE WHEN c2.client_st='2'  THEN SUBSTR(text_decrypt(c2.ssn, 'pw'),0,6) ELSE c2.enp_no END,'없음') AS r_enp_no2,                                                            \n"+
							"       SUBSTR(f.deli_dt,1,8) AS rent_start_dt, SUBSTR(f.ret_plan_dt,1,8) AS rent_end_dt,                                                                                             \n"+
							"       decode(a2.driving_age,'0','26세이상','3','24세이상','1','21세이상','2','모든운전자','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하') a_age_scp,                                             \n"+
							"       decode(a2.GCP_KD,'1','5천만원','2','1억원','3','5억원','4','2억원','8','3억원','9','10억원') a_GCP_KD,                                                                                                \n"+
							"       decode(g2.COM_EMP_YN,'Y','가입','N','미가입',decode(b.COM_EMP_YN,'Y','가입','N','미가입','미가입')) a_COM_EMP_YN,                                                                          \n"+
							"       REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(NVL(b.firm_emp_nm,'없음'),' ',''),'(주)',''),'주식회사',''),'㈜',''),'주)',''),'(주','') AS firm_emp_nm,                                \n"+
							"       NVL(b.enp_no,'없음') b_enp_no,                                                                                                                                                   \n"+
							"       NVL(b.firm_emp_nm,'없음') r_firm_emp_nm,                                                                                                                                         \n"+
							"       NVL(b.enp_no,'없음') r_b_enp_no,                                                                                                                                                 \n"+
							"       e.ins_com_id, e.ins_com_nm,                                                                                                                                                    \n"+
							"			 b.ins_start_dt, b.ins_exp_dt,                                                                                                                                             \n"+
							"       decode(b.age_scp,'2','26세이상','4','24세이상','1','21세이상','3','모든운전자','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하') b_age_scp,                                                   \n"+
							"       decode(b.vins_gcp_kd,'4','5천만원','3','1억원','6','5억원','7','2억원','8','3억원','9','10억원','그외') b_GCP_KD,                                                                                        \n"+
							"       decode(b.COM_EMP_YN,'Y','가입','N','미가입','미가입') b_COM_EMP_YN,                                                                                                                    \n"+
							"       '' client_st, '' s_st                                                                                                                                                          \n"+
							"FROM   cont a, insur b, client c, car_reg d, ins_com e,                                                                                                                               \n"+
							"       (select car_mng_id, rent_s_cd, sub_l_cd, rent_st, cust_id, deli_dt, ret_plan_dt from rent_cont where rent_st IN ('2','3') and use_st='2') f, client c2,                        \n"+
							"       cont_etc g, cont a2, cont_etc g2                                                                                                                                               \n"+
							"WHERE  a.use_yn='Y'                                                                                                                                                                   \n"+
							"       AND a.car_st='2'                                                                                                                                                               \n"+
							"       AND a.car_mng_id=b.car_mng_id AND b.ins_sts='1'                                                                                                                                \n"+
							"       AND a.client_id=c.client_id                                                                                                                                                    \n"+
							"       AND a.car_mng_id=d.car_mng_id                                                                                                                                                  \n"+
							"       AND b.ins_com_id=e.ins_com_id                                                                                                                                                  \n"+
							"       AND a.car_mng_id=f.car_mng_id(+)                                                                                                                                               \n"+
							"       AND f.cust_id=c2.client_id(+)                                                                                                                                                  \n"+
							"       AND b.ins_com_id='0038'                                                                                                                                                        \n"+
							"       AND a.rent_mng_id=g.rent_mng_id AND a.rent_l_cd=g.rent_l_cd                                                                                                                    \n"+
							"       AND f.sub_l_cd=a2.rent_l_cd                                                                                                                                                    \n"+
							"       AND a2.rent_mng_id=g2.rent_mng_id AND a2.rent_l_cd=g2.rent_l_cd                                                                                                                \n"+
							"       AND SUBSTR(f.deli_dt,1,8) <= TO_CHAR(SYSDATE,'YYYYMMDD')                                                                                                                       \n"+
							"       AND TO_CHAR(SYSDATE,'YYYYMMDD') BETWEEN b.ins_start_dt AND b.ins_exp_dt                                                                                                        \n"+
							"       AND ((decode(b.age_scp,'2','26세이상','4','24세이상','1','21세이상','3','모든운전자','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하')                                             "+
							"            <>decode(a2.driving_age,'0','26세이상','3','24세이상','1','21세이상','2','모든운전자','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하'))                                      "+
							"           )                                                                                                                                                                          \n"+
							"UNION ALL                                                                                                                                                                             \n"+
							//보유차                                                                                                                                                                                 																			
							"SELECT a.rent_mng_id, a.rent_l_cd, a.car_mng_id, b.ins_st, f.rent_s_cd, f.sub_l_cd,                                                                                                   \n"+
							"       d.car_no, d.car_nm,                                                                                                                                                            \n"+
							"       DECODE(a.car_st,'2',DECODE(f.rent_st,'2','정비대차','3','사고대차','10','지연대차','보유차'),'대여차량') car_st,                                                                                  \n"+
							"       REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(DECODE(a.car_st,'5','(주)아마존카/')||c.firm_nm,' ',''),'(주)',''),'주식회사',''),'㈜',''),'주)',''),'(주','') as firm_nm,             \n"+
							"       CASE WHEN c.client_st='2'  THEN SUBSTR(text_decrypt(c.ssn, 'pw'),0,6) ELSE c.enp_no END AS enp_no,                                                                        \n"+
							"       DECODE(a.car_st,'5','(주)아마존카/')||c.firm_nm AS r_firm_nm,                                                                                                                  \n"+
							"       CASE WHEN c.client_st='2'  THEN SUBSTR(text_decrypt(c.ssn, 'pw'),0,6) ELSE c.enp_no END AS r_enp_no,                                                                      \n"+
							"       REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(NVL(c2.firm_nm,'없음'),' ',''),'(주)',''),'주식회사',''),'㈜',''),'주)',''),'(주','') AS firm_nm2,                                  \n"+
							"       NVL(CASE WHEN c2.client_st='2'  THEN SUBSTR(text_decrypt(c2.ssn, 'pw'),0,6) ELSE c2.enp_no END,'없음') AS enp_no2,                                                          \n"+
							"       NVL(c2.firm_nm,'없음') AS r_firm_nm2,                                                                                                                                       \n"+
							"       NVL(CASE WHEN c2.client_st='2'  THEN SUBSTR(text_decrypt(c2.ssn, 'pw'),0,6) ELSE c2.enp_no END,'없음') AS r_enp_no2,                                                        \n"+
							"			 a.rent_start_dt,a.rent_end_dt,                                                                                                                                       \n"+
							"       decode(a.driving_age,'0','26세이상','3','24세이상','1','21세이상','2','모든운전자','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하') a_age_scp,                                          \n"+
							"       decode(a.GCP_KD,'1','5천만원','2','1억원','3','5억원','4','2억원','8','3억원','9','10억원') a_GCP_KD,                                                                                             \n"+
							"       decode(g.COM_EMP_YN,'Y','가입','N','미가입',decode(b.COM_EMP_YN,'Y','가입','N','미가입','미가입')) a_COM_EMP_YN,                                                                       \n"+
							"       REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(NVL(b.firm_emp_nm,'없음'),' ',''),'(주)',''),'주식회사',''),'㈜',''),'주)',''),'(주','') AS firm_emp_nm,                            \n"+
							"       NVL(b.enp_no,'없음') b_enp_no,                                                                                                                                              \n"+
							"       NVL(b.firm_emp_nm,'없음') r_firm_emp_nm,                                                                                                                                    \n"+
							"       NVL(b.enp_no,'없음') r_b_enp_no,                                                                                                                                            \n"+
							"       e.ins_com_id, e.ins_com_nm,                                                                                                                                               \n"+
							"			 b.ins_start_dt, b.ins_exp_dt,                                                                                                                                        \n"+
							"       decode(b.age_scp,'2','26세이상','4','24세이상','1','21세이상','3','모든운전자','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하') b_age_scp,                                              \n"+
							"       decode(b.vins_gcp_kd,'4','5천만원','3','1억원','6','5억원','7','2억원','8','3억원','9','10억원','그외') b_GCP_KD,                                                                                   \n"+
							"       decode(b.COM_EMP_YN,'Y','가입','N','미가입','미가입') b_COM_EMP_YN,                                                                                                               \n"+
							"       '' client_st, '' s_st                                                                                                                                                     \n"+
							"FROM   cont a, insur b, client c, car_reg d, ins_com e,                                                                                                                          \n"+
							"       (select car_mng_id, rent_s_cd, sub_l_cd, rent_st, cust_id from rent_cont where rent_st IN ('2','3','10') and use_st='2') f, client c2,                                    \n"+
							"       cont_etc g                                                                                                                                                                \n"+
							"WHERE  a.use_yn='Y'                                                                                                                                                              \n"+
							"       AND a.car_st='2'                                                                                                                                                          \n"+
							"       AND a.car_mng_id=b.car_mng_id AND b.ins_sts='1'                                                                                                                           \n"+
							"       AND a.client_id=c.client_id                                                                                                                                               \n"+
							"       AND a.car_mng_id=d.car_mng_id                                                                                                                                             \n"+
							"       AND b.ins_com_id=e.ins_com_id                                                                                                                                             \n"+
							"       AND a.car_mng_id=f.car_mng_id(+) AND f.rent_s_cd IS null                                                                                                                  \n"+
							"       AND f.cust_id=c2.client_id(+)                                                                                                                                             \n"+
							"       AND b.ins_com_id='0038'                                                                                                                                                   \n"+
							"       AND a.rent_mng_id=g.rent_mng_id AND a.rent_l_cd=g.rent_l_cd                                                                                                               \n"+
							"       AND a.reg_dt <= TO_CHAR(SYSDATE,'YYYYMMDD')                                                                                                                               \n"+
							"       AND TO_CHAR(SYSDATE,'YYYYMMDD') BETWEEN b.ins_start_dt AND b.ins_exp_dt                                                                                                   \n"+
							"       AND ((b.firm_emp_nm IS NOT NULL AND REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(NVL(b.firm_emp_nm,'없음'),' ',''),'(주)',''),'주식회사',''),'㈜',''),'주)',''),'(주','')<>'아마존카') or	\n"+					
							"            (b.enp_no IS NOT NULL AND NVL(b.enp_no,'없음')<>'1288147957') OR                                                                                                                    \n"+
							"            (decode(b.age_scp,'2','26세이상','4','24세이상','1','21세이상','3','모든운전자','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하')<>'26세이상') OR                                       \n"+
							"            (decode(b.vins_gcp_kd,'4','5천만원','3','1억원','6','5억원','7','2억원','8','3억원','9','10억원','그외')<>'1억원') OR                                                                                   \n"+
							"            (decode(b.COM_EMP_YN,'Y','가입','N','미가입','미가입')<>'미가입')                                                                                                                         "+
							"           )                                                                                                                                                                                  \n"+
					        ") WHERE car_no ='"+car_no+"'"  ; 
					
						
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
						
						System.out.println("[InsDatabase:getClientInsInfo(String car_no)]"+ e);
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
				
			//보험관리 고객 사업자명 가져오기(2017-11-07)-변경될건들만
			public Hashtable getClientInsInfo2(String s_kd, String search_text)
			{
				getConnection();
				PreparedStatement pstmt = null;
				ResultSet rs = null;
				Hashtable ht = new Hashtable();
				String query = "", sub_query = "";
				String dt = "";
							

				query =	""+
						" SELECT b.firm_emp_nm,b.enp_no,                                                                                                                  \r\n" + 
						" 		decode(b.age_scp,'2','26세이상','4','24세이상','1','21세이상','3','모든운전자',\r\n" + 
						" 				'5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상',\r\n" + 
						" 				'10','28세이상','11','35세이상~49세이하') age_scp,    \r\n" + 
						"        decode(b.vins_gcp_kd,'4','5천만원','3','1억원','6','5억원','7','2억원','8','3억원','9','10억원','그외') GCP_KD,                                               \r\n" + 
						"        decode(b.COM_EMP_YN,'Y','가입','N','미가입','미가입') COM_EMP_YN,                                                                             \r\n" + 
						"        b.INS_START_DT,c.RENT_MNG_ID,c.RENT_L_CD,c.CAR_MNG_ID,                                                                                     \r\n" + 
						"        b.OTHERS_DEVICE, b.INS_CON_NO, decode(b.LEGAL_YN ,'Y','가입','N','미가입','미가입') LEGAL_YN                                                                                    \r\n" + 
						" FROM car_reg a, insur b,cont c                                                                                                                  \r\n" + 
						" WHERE 1=1\r\n" + 
						" AND a.CAR_MNG_ID = b.CAR_MNG_ID                                                                                                                 \r\n" + 
						" AND b.CAR_MNG_ID = c.CAR_MNG_ID                                                                                                                 \r\n" + 
						" AND NVL(c.use_yn,'Y')='Y'                                                                                                                       \r\n" + 
						" AND ins_con_no IS NOT NULL                                                                                                                      \r\n" + 
						" AND b.INS_STS='1' ";
 
					if(s_kd.equals("1")) query += "AND a.car_no = '"+search_text+"' ";
					else if(s_kd.equals("2")) query += "AND b.ins_con_no = '"+search_text+"' ";
					
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
					
					System.out.println("[InsDatabase:getClientInsInfo2(String car_no)]"+ e);
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
			
			
			//차량번호,최초등록일로 rent_l_cd 값 얻기
			public String getRent_l_cd(String car_no, String init_reg_dt)
			{
				getConnection();
				PreparedStatement pstmt = null;
				ResultSet rs = null;
				String rent_l_cd = "";
				String query = "";

				query = " SELECT rent_l_cd FROM "+
					    " car_reg a, cont b "+ 
					    " WHERE a.CAR_MNG_ID = b.CAR_MNG_ID "+
					    " AND a.car_no = '"+car_no+"' "+
					    " AND a.INIT_REG_DT='"+init_reg_dt+"' "+		
						" AND b.USE_YN ='Y'";
				
				try {
					pstmt = conn.prepareStatement(query);
			    	rs = pstmt.executeQuery();
		    	
					if(rs.next()){				
						rent_l_cd = rs.getString(1);
					}
					rs.close();
					pstmt.close();

				} catch (SQLException e) {
					System.out.println("[InsDatabase:getRent_l_cd]"+ e);
			  		e.printStackTrace();
				} finally {
					try{
			                if(rs != null )		rs.close();
	                		if(pstmt != null)	pstmt.close();
					}catch(Exception ignore){}
					closeConnection();
					return rent_l_cd;
				}
 
			}
			
			/**
			 * 첨단산업 정보 업데이트 엑셀
			 */
			public boolean updateHightech(ContEtcBean cont_etc)
			{
				getConnection();
				boolean flag = true;
				String query = "update cont_etc SET \n"+
									" LKAS_YN = ?,"+
									" LDWS_YN = ?,"+
									" AEB_YN = ?,"+
									" FCW_YN = ?,"+
									" EV_YN = ?"+
									" where rent_l_cd = ?";
				
				PreparedStatement pstmt = null;
				

				try 
				{
					conn.setAutoCommit(false);

					pstmt = conn.prepareStatement(query);
					pstmt.setString(1, cont_etc.getLkas_yn());   
					pstmt.setString(2, cont_etc.getLdws_yn());   
					pstmt.setString(3, cont_etc.getAeb_yn());    
					pstmt.setString(4, cont_etc.getFcw_yn());    
					pstmt.setString(5, cont_etc.getEv_yn());     
					pstmt.setString(6, cont_etc.getRent_l_cd()); 
				    pstmt.executeUpdate();
					pstmt.close();

					conn.commit();
				    
			  	} catch (Exception e) {
					System.out.println("[InsDatabase:updateHightech]"+ e);
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
			 * 첨단산업 정보 업데이트 엑셀
			 */
			public boolean updateHightechIns(InsurBean ins)
			{
				getConnection();
				boolean flag = true;
				String query = "update INSUR SET \n"+
						" LKAS_YN = ?,"+
						" LDWS_YN = ?,"+
						" AEB_YN = ?,"+
						" FCW_YN = ?,"+
						" EV_YN = ?"+
						" where ins_con_no = ?"+
						" and ins_start_dt = ?"+
						" ";
				
				PreparedStatement pstmt = null;
				
				
				try 
				{
					conn.setAutoCommit(false);
					
					pstmt = conn.prepareStatement(query);
					pstmt.setString(1, ins.getLkas_yn());   
					pstmt.setString(2, ins.getLdws_yn());   
					pstmt.setString(3, ins.getAeb_yn());    
					pstmt.setString(4, ins.getFcw_yn());    
					pstmt.setString(5, ins.getEv_yn());     
					pstmt.setString(6, ins.getIns_con_no()); 
					pstmt.setString(7, ins.getIns_start_dt()); 
					pstmt.executeUpdate();
					pstmt.close();
					
					conn.commit();
					
				} catch (Exception e) {
					System.out.println("[InsDatabase:updateHightechIns]"+ e);
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
			 * 임차인 정보 업데이트 엑셀
			 */
			public boolean updateFirmEmpNm(InsurBean ins)
			{
				getConnection();
				boolean flag = true;
				String query = "update insur SET \n"+
									" FIRM_EMP_NM = ?,"+
									" enp_no = ?,"+
									" age_scp = ?,"+
									" vins_gcp_kd = ?,"+
									" com_emp_yn = ?"+
									" where INS_CON_NO = ?";
				
				PreparedStatement pstmt = null;
				

				try 
				{
					conn.setAutoCommit(false);

					pstmt = conn.prepareStatement(query);
					pstmt.setString(1, ins.getFirm_emp_nm());   
					pstmt.setString(2, ins.getEnp_no());   
					pstmt.setString(3, ins.getAge_scp());   
					pstmt.setString(4, ins.getVins_gcp_kd());   
					pstmt.setString(5, ins.getCom_emp_yn());   
					pstmt.setString(6, ins.getIns_con_no());   
				    pstmt.executeUpdate();
					pstmt.close();

					conn.commit();
				    
			  	} catch (Exception e) {
					System.out.println("[InsDatabase:updateFirmEmpNm]"+ e);
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
			
			//보험 공문
			public Hashtable getinsUShPrintInfo(String rent_mng_id, String rent_l_cd, String car_mng_id, String ins_st)
			{
				getConnection();
				PreparedStatement pstmt = null;
				ResultSet rs = null;
				Hashtable ht = new Hashtable();
				String query = "", sub_query = "";
				String dt = "";
				
				query = ""+
						" SELECT  c.car_no, c.car_num, c.car_nm, cn.car_name,e.NM ,c.TAKING_P, to_char(to_date(c.INIT_REG_DT,'YYYY-MM-DD'),'YYYY-MM-DD') INIT_REG_DT,  "+
						" 		decode(i. air_ds_yn,'',0,'Y',1,'N',0)+ decode(i. air_as_yn,'',0,'Y',1,'N',0) AIRBAG_EA,  "+
						"		i.COM_EMP_YN, decode(i.age_scp,'','26세이상','2','26세이상','4','24세이상','1','21세이상','3','모든운전자','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','49세이하') AGE_SCP, "+
						"		decode(i.vins_gcp_kd,'','1억원','4','5천만원','3','1억원','6','5억원','7','2억원','8','3억원','9','10억원','그외') VINS_GCP_KD, "+
						"		decode(i.VINS_BACDT_KD,'1','3억원','2','1억5천만원','3','3천만원','4','1500만원','5','5000만원','6','1억원','그외') VINS_BACDT_KD, "+
						"		decode(i.VINS_BACDT_KC2,'1','3억원','2','1억5천만원','3','3천만원','4','1500만원','5','5000만원','6','1억원','그외') VINS_BACDT_KC2, "+
						"		CASE WHEN  i.VINS_CACDT_CAR_AMT = 0 THEN 'N' ELSE 'Y' END VINS_CACDT_CAR_AMT, "+ 
						"		CASE WHEN  i.VINS_CANOISR_AMT = 0 THEN 'N' ELSE 'Y' END VINS_CANOISR_AMT, "+
						"       decode(i.COM_EMP_YN,'','N',i.COM_EMP_YN) COM_EMP_YN, a.firm_nm, d.user_nm, b.ENP_NO, a.RENT_START_DT, a.RENT_END_DT, "+
						"       a.RENT_START_DT, a.RENT_END_DT, "+
						"       TRUNC(MONTHS_BETWEEN( TO_DATE(REPLACE(a.RENT_END_DT,'-'), 'YYYYMMDD'), TO_DATE(REPLACE(a.RENT_START_DT,'-'), 'YYYYMMDD') )) RENT_MONTH, "+
						"       TO_CHAR(SYSDATE, 'YYYY' ) YEAR, TO_CHAR(SYSDATE, 'MM' ) MONTH, TO_CHAR(SYSDATE, 'DD' ) DAY  "+
						" FROM  cont_n_view a, CLIENT b, users d, car_reg c, car_etc g, car_nm cn,  client_site d , insur i, code e "+
						" WHERE a.bus_id =d.user_id(+)  "+ 
						" 	AND e.C_ST ='0008'  "+
						" 	AND a.CLIENT_ID =b.CLIENT_ID  "+
						" 	AND a.car_mng_id = c.car_mng_id  "+ 
						"	AND a.rent_mng_id = g.rent_mng_id(+) "+  
						"	AND a.rent_l_cd = g.rent_l_cd(+) "+  
						"   AND a.client_id=d.client_id(+) "+ 
						"   AND a.r_site =d.SEQ(+) "+   
						"	AND g.car_id=cn.car_id(+) "+  
						"	AND g.car_seq=cn.car_seq(+) "+ 
						"	AND c.CAR_MNG_ID = i.CAR_MNG_ID "+
						"	AND a.rent_mng_id = '"+rent_mng_id+"'  "+	
						"	AND a.rent_l_cd = '"+rent_l_cd+"'  "+	
						"	AND a.car_mng_id = '"+car_mng_id+"'  "+		
						"	AND i.ins_st = '"+ins_st+"'  "+		
						"";
				
				
				
				
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
					
					System.out.println("[InsDatabase:getinsUInPrintInfo(String rent_mng_id, String rent_l_cd, String car_mng_id, String ins_st)]"+ e);
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
			
			//대여료 리스트
			public Vector getScdFeeList(String rent_mng_id , String rent_l_cd)
			{
				getConnection();
				PreparedStatement pstmt = null;
				ResultSet rs = null;
				Vector vt = new Vector();
				String query = "";

				query = " SELECT a.*, SUBSTR(R_FEE_EST_DT,0,4) YEAR, SUBSTR(R_FEE_EST_DT,5,2) MONTH, SUBSTR(R_FEE_EST_DT,7,2) DAY FROM SCD_FEE a WHERE RENT_MNG_ID = '"+ rent_mng_id + "' " +
						" AND RENT_L_CD = '"+ rent_l_cd +  "' " +
						" ORDER BY TO_NUMBER(FEE_TM) " +
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
					
					System.out.println("[InsDatabase:getScdFeeList]"+ e);
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
			 * 고객피보험산출정보등록 
			 */
			public boolean insertInsCalc(InsCalcBean calc)
			{
				getConnection();
				boolean flag = true;
				String query =  " insert into ins_calc(reg_code, reg_dt, reg_id,  "+
								" update_id, update_dt, client_st, car_name, car_b_p, "+
								" client_nm, ssn, m_tel, addr, age_scp,"+
								" vins_gcp_kd, job, ins_limit, com_emp_yn, etc, "+
								" tel_com, t_zip, use_st, enp_no, driver_nm,    "+
								" driver_ssn, driver_rel   "+
								" ) values("+
								" ?, to_char(sysdate,'YYYYMMDD'), ?, "+
								" ?, to_char(sysdate,'YYYYMMDD'), ?, ?, ?, "+
								" ?, ?, ?, ?, ?, "+
								" ?, ?, ?, ?, ?, "+
								" ?, ?, ?, ?, ?, "+
								" ?, ? "+
								" )";

				PreparedStatement pstmt = null;

				try 
				{
					conn.setAutoCommit(false);

					pstmt = conn.prepareStatement(query);
					pstmt.setString	(1,  calc.getRegCode	());
					pstmt.setString	(2,  calc.getRegId		());
				    pstmt.setString	(3,  calc.getUpdateId	());
					pstmt.setString	(4,  calc.getClientSt	());
					pstmt.setString	(5,  calc.getCarName	());
					pstmt.setInt	(6,  calc.getCarBP		());
					pstmt.setString	(7,  calc.getClientNm	());
					pstmt.setString	(8,  calc.getSsn		());
					pstmt.setString	(9, calc.getMTel		());
					pstmt.setString	(10, calc.getAddr		());
					pstmt.setString	(11, calc.getAgeScp		());
					pstmt.setString	(12, calc.getVinsGcpKd	());
					pstmt.setString	(13, calc.getJob		());
					pstmt.setString	(14, calc.getInsLimit	());
					pstmt.setString	(15, calc.getComEmpYn	());
					pstmt.setString	(16, calc.getEtc		());
					pstmt.setString	(17, calc.getTelCom		());
					pstmt.setString	(18, calc.getTZip		());
					pstmt.setString	(19, calc.getUseSt		());
					pstmt.setString	(20, calc.getEnpNo		());
					pstmt.setString	(21, calc.getDriverNm	());
					pstmt.setString	(22, calc.getDriverSsn	());
					pstmt.setString	(23, calc.getDriverRel	());
		
					pstmt.executeUpdate();
					pstmt.close();

					conn.commit();
				    
			  	} catch (Exception e) {
					System.out.println("[InsDatabase:insertInsCalc]"+ e);
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
			 * 고객피보험산출정보리스트 
			 */
			public Vector getInsCalcList(String gubun2, String gubun3, String st_dt, String end_dt, String s_kd, String t_wd)
			{
				getConnection();
				PreparedStatement pstmt = null;
				ResultSet rs = null;
				Vector vt = new Vector();
				String query = "";
			

		        //a.value03 = b.car_mng_id 대여
				query = ""+
						"SELECT REG_CODE, REG_DT, a.REG_ID, UPDATE_DT, UPDATE_ID, INS_COST, CLIENT_ST,\r\n" + 
						"		CAR_NAME, CAR_B_P, CLIENT_NM, SSN, M_TEL, T_ZIP, a.ADDR, \r\n" + 
						"		DECODE(AGE_SCP, '','26세이상','2','26세이상','4','24세이상','1','21세이상','3','모든운전자','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','49세이하',AGE_SCP||'세') AGE_SCP, \r\n" + 
						"		DECODE(REPLACE(a.VINS_GCP_KD,' ',''), null,'1억원','4','5천만원','3','1억원','6','5억원','7','2억원','8','3억원','9','10억원','5천만원') VINS_GCP_KD, \r\n" + 
						"		JOB, DECODE(INS_LIMIT,'1','부부한정','2','기명피보험..','3','가족한정') INS_LIMIT, DECODE(COM_EMP_YN,'Y','가입','N','미가입','미가입') COM_EMP_YN, ETC, TEL_COM, \r\n" + 
						"		b.USER_NM, DECODE(a.CLIENT_ST,'1','법인','2','개인','법인') CLIENT_ST_NM,\r\n" + 
						"		SUBSTR(SSN,0,6) SSN1, SUBSTR(SSN,8,13) SSN2, USE_ST, ENP_NO, DRIVER_NM, DRIVER_SSN, DRIVER_REL\r\n" + 
						" FROM INS_CALC a, USERS b\r\n"+ 
						" WHERE a.REG_ID = b.USER_ID ";
					
				if(!gubun2.equals("")) query += "AND USE_ST ='"+gubun2+"' " ;
				else query += "AND USE_ST = '요청' ";

				if(!gubun3.equals("") && gubun3.equals("당일")) query += "AND REG_DT = to_char(sysdate,'YYYYMMDD') " ;
				if(!gubun3.equals("") && gubun3.equals("전일")) query += "AND REG_DT = to_char(sysdate-1,'YYYYMMDD') " ;
				if(!gubun3.equals("") && gubun3.equals("기간")) query += "AND REG_DT BETWEEN TO_DATE('"+st_dt+"', 'YYYYMMDD') AND TO_DATE('"+end_dt+"', 'YYYYMMDD') " ;
				
				if(!t_wd.equals("") && s_kd.equals("1") ) query += "AND CLIENT_NM like '%"+t_wd+"%' " ;
				if(!t_wd.equals("") && s_kd.equals("2") ) query += "AND ENP_NO like '%"+t_wd+"%' " ;
				if(!t_wd.equals("") && s_kd.equals("3") ) query += "AND b.USER_NM like '%"+t_wd+"%' " ;
				
				
				query += " ORDER BY REG_CODE ";
				
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
					System.out.println("[InsDatabase:getInsChangeList4]\n"+e);
					System.out.println("[InsDatabase:getInsChangeList4]\n"+query);
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
			 * 고객피보험산출정보변경 
			 */
			public boolean updateInsCalc(InsCalcBean calc)
			{
				getConnection();
				boolean flag = true;
				String query = "UPDATE INS_CALC SET		"+
									" UPDATE_DT = to_char(sysdate,'YYYYMMDD'), "+
									" UPDATE_ID = ?,		"+
									" CLIENT_ST = ?,		"+
									" CAR_NAME = ?,		"+
									" CAR_B_P = ?,		"+
									" CLIENT_NM = ?,		"+
									" SSN = ?,			"+
									" M_TEL = ?,			"+
									" ADDR = ?,			"+
									" AGE_SCP = ?,			"+
									" VINS_GCP_KD = ?,	"+
									" JOB = ?,			"+
									" INS_LIMIT = ?,		"+
									" COM_EMP_YN = ?,	"+
									" ETC = ?,			"+
									" TEL_COM = ?,		"+
									" T_ZIP = ?,			"+
									" ENP_NO = ?,			"+
									" DRIVER_NM = ?,			"+
									" DRIVER_SSN = ?,			"+
									" DRIVER_REL = ?			"+
									" WHERE REG_CODE = ? ";
				
				PreparedStatement pstmt = null;

				try 
				{
					conn.setAutoCommit(false);

					pstmt = conn.prepareStatement(query);
					pstmt.setString(1, calc.getUpdateId());
					pstmt.setString(2, calc.getClientSt());
					pstmt.setString(3, calc.getCarName());
					pstmt.setInt(4, calc.getCarBP());
					pstmt.setString(5, calc.getClientNm());
					pstmt.setString(6, calc.getSsn());
					pstmt.setString(7, calc.getMTel());
					pstmt.setString(8, calc.getAddr());
					pstmt.setString(9, calc.getAgeScp());
					pstmt.setString(10, calc.getVinsGcpKd());
					pstmt.setString(11, calc.getJob());
					pstmt.setString(12, calc.getInsLimit());
					pstmt.setString(13, calc.getComEmpYn());
					pstmt.setString(14, calc.getEtc());
					pstmt.setString(15, calc.getTelCom());
					pstmt.setString(16, calc.getTZip());
					pstmt.setString(17, calc.getEnpNo());
					pstmt.setString(18, calc.getDriverNm());
					pstmt.setString(19, calc.getDriverSsn());
					pstmt.setString(20, calc.getDriverRel());
					pstmt.setString(21, calc.getRegCode());
				    pstmt.executeUpdate();
					pstmt.close();

					conn.commit();
				    
			  	} catch (Exception e) {
					System.out.println("[InsDatabase:updateInsCalc]"+ e);
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
			 * 고객피보험산출정보
			 */
			public InsCalcBean getInsCalcInfo(String reg_code)
			{
				getConnection();
				InsCalcBean calc = new InsCalcBean();
				PreparedStatement pstmt = null;
				ResultSet rs = null;
				String query = 	"";
				query = ""+
						" SELECT "+ 
						" 		REG_CODE, REG_DT, REG_ID, UPDATE_DT, UPDATE_ID,\r\n" + 
						"		INS_COST, CLIENT_ST, CAR_NAME, CAR_B_P, CLIENT_NM,\r\n" + 
						"		SSN, M_TEL, ADDR, AGE_SCP, REPLACE(VINS_GCP_KD,' ','') VINS_GCP_KD, JOB,\r\n" + 
						"		INS_LIMIT, COM_EMP_YN, ETC, TEL_COM, T_ZIP, USE_ST, ENP_NO, DRIVER_NM, DRIVER_SSN, DRIVER_REL\r\n" + 
						" FROM INS_CALC "+ 
						" WHERE reg_code='"+reg_code+"' "+
						"";
				try{
						pstmt = conn.prepareStatement(query);
				    	rs = pstmt.executeQuery();
		    	
					while(rs.next())
					{
						calc.setRegCode(rs.getString("REG_CODE")==null?"":rs.getString("REG_CODE"));
						calc.setRegDt     (rs.getString("REG_DT")==null?"":rs.getString("REG_DT"));
						calc.setRegId     (rs.getString("REG_ID")==null?"":rs.getString("REG_ID"));
						calc.setUpdateId  (rs.getString("UPDATE_DT")==null?"":rs.getString("UPDATE_DT"));
						calc.setUpdateDt  (rs.getString("UPDATE_ID")==null?"":rs.getString("UPDATE_ID"));
						calc.setInsCost   (rs.getInt("INS_COST"));
						calc.setClientSt  (rs.getString("CLIENT_ST")==null?"":rs.getString("CLIENT_ST"));
						calc.setCarName   (rs.getString("CAR_NAME")==null?"":rs.getString("CAR_NAME"));
						calc.setCarBP    (rs.getInt("CAR_B_P"));
						calc.setClientNm  (rs.getString("CLIENT_NM")==null?"":rs.getString("CLIENT_NM"));
						calc.setSsn        (rs.getString("SSN")==null?"":rs.getString("SSN"));
						calc.setMTel      (rs.getString("M_TEL")==null?"":rs.getString("M_TEL"));
						calc.setAddr       (rs.getString("ADDR")==null?"":rs.getString("ADDR"));
						calc.setAgeScp     (rs.getString("AGE_SCP")==null?"":rs.getString("AGE_SCP"));
						calc.setVinsGcpKd(rs.getString("VINS_GCP_KD")==null?"":rs.getString("VINS_GCP_KD"));
						calc.setJob        (rs.getString("JOB")==null?"":rs.getString("JOB"));
						calc.setInsLimit  (rs.getString("INS_LIMIT")==null?"":rs.getString("INS_LIMIT"));
						calc.setComEmpYn (rs.getString("COM_EMP_YN")==null?"":rs.getString("COM_EMP_YN"));
						calc.setEtc        (rs.getString("ETC")==null?"":rs.getString("ETC"));
						calc.setTelCom    (rs.getString("TEL_COM")==null?"":rs.getString("TEL_COM"));
						calc.setTZip    	(rs.getString("T_ZIP")==null?"":rs.getString("T_ZIP"));
						calc.setUseSt    	(rs.getString("USE_ST")==null?"":rs.getString("USE_ST"));
						calc.setEnpNo    	(rs.getString("ENP_NO")==null?"":rs.getString("ENP_NO"));
						calc.setDriverNm    	(rs.getString("DRIVER_NM")==null?"":rs.getString("DRIVER_NM"));
						calc.setDriverSsn    	(rs.getString("DRIVER_SSN")==null?"":rs.getString("DRIVER_SSN"));
						calc.setDriverRel    	(rs.getString("DRIVER_REL")==null?"":rs.getString("DRIVER_REL"));
					}
					rs.close();
					pstmt.close();
				} catch (SQLException e) {
					System.out.println("[InsDatabase:getInsCase]"+ e);
			  		e.printStackTrace();
				} finally {
					try{
				                if(rs != null )		rs.close();
		                		if(pstmt != null)	pstmt.close();
					}catch(Exception ignore){}
					closeConnection();
					return calc;
				}
			}
			
			
			/**
			 * 고객피보험산출정보 삭제
			 */
			public boolean deleteInsCalc(String reg_code)
			{
				getConnection();
				PreparedStatement pstmt = null;
				boolean flag = true;
				String query =  " delete from ins_calc"+
								" where reg_code = ?";

				try 
				{
					conn.setAutoCommit(false);

					pstmt = conn.prepareStatement(query);
					pstmt.setString(1, reg_code);
				    pstmt.executeUpdate();
					pstmt.close();

					conn.commit();
				    
			  	} catch (Exception e) {
					System.out.println("[InsDatabase:deleteInsCalc]"+ e);
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
			 * 고객피보험산출정보 비용등록 
			 */
			public boolean updateInsCost(InsCalcBean calc)
			{
				getConnection();
				boolean flag = true;
				String query = "UPDATE INS_CALC SET		"+
									" UPDATE_DT = to_char(sysdate,'YYYYMMDD'), "+
									" UPDATE_ID = ?,		"+
									" INS_COST = ?			"+
									" WHERE REG_CODE = ? AND USE_ST='요청'";
				
				PreparedStatement pstmt = null;

				try 
				{
					conn.setAutoCommit(false);

					pstmt = conn.prepareStatement(query);
					pstmt.setString(1, calc.getUpdateId());
					pstmt.setInt(2, calc.getInsCost());
					pstmt.setString(3, calc.getRegCode());
				    pstmt.executeUpdate();
					pstmt.close();

					conn.commit();
				    
			  	} catch (Exception e) {
					System.out.println("[InsDatabase:updateInsCalc]"+ e);
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
			 * 고객피보험산출정보 완료처리 
			 */
			public boolean updateInsCalcUseSt(String reg_code)
			{
				System.out.println(reg_code);
				getConnection();
				boolean flag = true;
				String query = "UPDATE INS_CALC SET		"+
									" UPDATE_DT = to_char(sysdate,'YYYYMMDD'), "+
									" USE_ST = '완료'	 "+
									" WHERE REG_CODE = ? ";
				
				PreparedStatement pstmt = null;

				try 
				{
					conn.setAutoCommit(false);

					pstmt = conn.prepareStatement(query);
					pstmt.setString(1, reg_code);
				    pstmt.executeUpdate();
					pstmt.close();

					conn.commit();
				    
			  	} catch (Exception e) {
					System.out.println("[InsDatabase:updateInsCalcUseSt]"+ e);
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
			 *	보험료 조회 : con_ins_u.jsp
			 */
			public InsurBean getInsInfo(String ins_con_no)
			{
				getConnection();
				InsurBean ins = new InsurBean();
				PreparedStatement pstmt = null;
				ResultSet rs = null;
				String query = 	"";
				query = "SELECT * FROM insur WHERE INS_CON_NO=? and ins_st = (SELECT MAX(TO_NUMBER(ins_st)) AS ins_st FROM insur WHERE INS_CON_NO=? GROUP BY INS_CON_NO ) ";
				try{
						pstmt = conn.prepareStatement(query);
						pstmt.setString(1, ins_con_no);
						pstmt.setString(2, ins_con_no);
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
						ins.setReg_cau(rs.getString("REG_CAU")==null?"":rs.getString("REG_CAU"));
						ins.setExp_st(rs.getString("EXP_ST")==null?"":rs.getString("EXP_ST"));
						ins.setAuto_yn(rs.getString("AUTO_YN")==null?"":rs.getString("AUTO_YN"));
						ins.setAbs_yn(rs.getString("ABS_YN")==null?"":rs.getString("ABS_YN"));
						ins.setIns_rent_dt(rs.getString("INS_RENT_DT")==null?"":rs.getString("INS_RENT_DT"));
						ins.setVins_cacdt_memin_amt(rs.getInt("VINS_CACDT_MEMIN_AMT"));
						ins.setVins_cacdt_mebase_amt(rs.getInt("VINS_CACDT_MEBASE_AMT"));
						ins.setBlackbox_yn(rs.getString("BLACKBOX_YN")==null?"":rs.getString("BLACKBOX_YN"));
						ins.setVins_share_extra_amt(rs.getInt("vins_share_extra_amt"));
						ins.setVins_blackbox_amt(rs.getInt("vins_blackbox_amt"));
						ins.setVins_blackbox_per(rs.getString("vins_blackbox_per")==null?"":rs.getString("vins_blackbox_per"));
						ins.setCom_emp_yn(rs.getString("com_emp_yn")==null?"":rs.getString("com_emp_yn"));
						ins.setFirm_emp_nm(rs.getString("firm_emp_nm")==null?"":rs.getString("firm_emp_nm"));
						ins.setLong_emp_yn(rs.getString("long_emp_yn")==null?"":rs.getString("long_emp_yn"));
						ins.setBlackbox_nm(rs.getString("blackbox_nm")==null?"":rs.getString("blackbox_nm"));
						ins.setBlackbox_amt(rs.getInt("blackbox_amt"));
						ins.setBlackbox_no(rs.getString("blackbox_no")==null?"":rs.getString("blackbox_no"));
						ins.setBlackbox_dt(rs.getString("blackbox_dt")==null?"":rs.getString("blackbox_dt"));
						ins.setEnp_no(rs.getString("enp_no")==null?"":rs.getString("enp_no"));
						ins.setLkas_yn(rs.getString("lkas_yn")==null?"":rs.getString("lkas_yn"));
						ins.setLdws_yn(rs.getString("ldws_yn")==null?"":rs.getString("ldws_yn"));
						ins.setAeb_yn(rs.getString("aeb_yn")==null?"":rs.getString("aeb_yn"));
						ins.setFcw_yn(rs.getString("fcw_yn")==null?"":rs.getString("fcw_yn"));
						ins.setEv_yn(rs.getString("ev_yn")==null?"":rs.getString("ev_yn"));
						ins.setOthers(rs.getString("OTHERS")==null?"":rs.getString("OTHERS"));
						ins.setOthers_device(rs.getString("OTHERS_DEVICE")==null?"":rs.getString("OTHERS_DEVICE"));
					}
					rs.close();
					pstmt.close();
				} catch (SQLException e) {
					System.out.println("[InsDatabase:getInsInfo]"+ e);
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
			
		//임직원 가입 확인 리스트
		public Vector getInsComEmpInfo(String car_mng_id, String client_id) {
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Vector vt = new Vector();
			String query = "";

			query =  ""+
					" SELECT d.CAR_NO, d.CAR_NM, b.COM_EMP_START_DT, nvl(b.COM_EMP_EXP_DT,'확인서 발급일 현재') COM_EMP_EXP_DT, a.INS_START_DT, a.INS_EXP_DT,\r\n" + 
					"  		 e.INS_COM_NM, a.INS_CON_NO\r\n" + 
					"  FROM INSUR a, INS_COM_EMP_INFO b, CLIENT c, CAR_REG d, INS_COM e\r\n" + 
					"  WHERE a.CAR_MNG_ID = b.CAR_MNG_ID AND a.INS_ST = b.INS_ST\r\n" +
					"  AND b.CAR_MNG_ID ="+car_mng_id+" "+	
					"  AND c.CLIENT_ID ="+client_id+" "+						
					"  AND b.CLIENT_ID = c.CLIENT_ID\r\n" + 
					"  AND a.CAR_MNG_ID = d.CAR_MNG_ID \r\n" + 
					"  AND a.INS_COM_ID = e.INS_COM_ID \r\n" + 
					"  AND (SUBSTR(b.COM_EMP_START_DT,1,4) = TO_CHAR(SYSDATE,'YYYY')-1 OR NVL(SUBSTR(b.COM_EMP_EXP_DT,1,4),TO_CHAR(SYSDATE,'YYYY')) = TO_CHAR(SYSDATE,'YYYY')-1) \r\n" +
			 		"";
			
			query += "	ORDER BY b.COM_EMP_START_DT";
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
					
					System.out.println("[InsDatabase:getInsComEmpInfo]"+ e);
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
		
		////임직원 가입 정보
		public Hashtable getInsComEmpInfo2(String car_mng_id)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Hashtable ht = new Hashtable();
			String query = "", sub_query = "";
			String dt = "";
			
			
			query =  ""+
					"SELECT * FROM INS_COM_EMP_INFO \r\n" + 
					"WHERE CAR_MNG_ID= "+car_mng_id+" \r\n" + 
					"AND REG_DT = (\r\n" + 
					"SELECT MAX(REG_DT) KEEP (DENSE_RANK LAST ORDER BY INS_ST) \r\n" + 
					"FROM INS_COM_EMP_INFO\r\n" + 
					"WHERE CAR_MNG_ID="+car_mng_id+" )"+
					"AND INS_ST = (\r\n" + 
					"SELECT MAX(TO_NUMBER(ins_st)) KEEP (DENSE_RANK LAST ORDER BY INS_ST) \r\n" + 
					"FROM INS_COM_EMP_INFO\r\n" + 
					"WHERE CAR_MNG_ID= "+car_mng_id+")\r\n" + 
			 		  "";
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
				
				System.out.println("[InsDatabase:getInsComEmpInfo2(String car_mng_id, String ins_st)]"+ e);
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
		
		//임직원 가입 확인 리스트
		public Vector getInsComEmpInfo3(String rent_l_cd) {
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Vector vt = new Vector();
			String query = "";

			query =  ""+
			 		" SELECT  d.INS_RENT_DT,  c.car_no, c.car_nm, h.INS_COM_NM, d.INS_CON_NO, nvl(e.COM_EMP_START_DT,d.INS_START_DT) ins_start_dt, nvl(e.COM_EMP_EXP_DT,d.INS_EXP_DT) ins_end_dt,\r\n" + 
			 		" 		d.CAR_MNG_ID\r\n" + 
			 		" FROM CONT a, CONT_etc b, CAR_REG c, insur d, INS_COM_EMP_INFO e, CONT_ETC f, CLIENT g, INS_COM h\r\n" + 
			 		" WHERE 1=1 \r\n" + 
			 		" AND a.RENT_L_CD='"+rent_l_cd+"'\r\n" + 
			 		" AND car_st <> 2\r\n" + 
			 	//	" AND g.CLIENT_ST = 1\r\n" + 
			 		" AND a.RENT_MNG_ID = b.RENT_MNG_ID  AND a.RENT_L_CD = b.RENT_L_CD\r\n" + 
			 		" AND a.CAR_MNG_ID = c.CAR_MNG_ID\r\n" + 
			 		" AND c.CAR_MNG_ID = d.CAR_MNG_ID\r\n" + 
			 		" AND TO_NUMBER(d.INS_RENT_DT) BETWEEN TO_NUMBER(a.RENT_START_DT) AND TO_NUMBER(a.RENT_END_DT)-1\r\n" + 
			 		" AND d.CAR_MNG_ID = e.CAR_MNG_ID(+) AND d.INS_ST = e.INS_ST(+)\r\n" + 
			 		" AND a.RENT_MNG_ID = f.RENT_MNG_ID and a.RENT_L_CD = f.RENT_L_CD\r\n" + 
			 		" AND a.CLIENT_ID = g.CLIENT_ID\r\n" + 
			 		" AND d.INS_COM_ID = h.INS_COM_ID\r\n" + 
			 		" ORDER BY TO_NUMBER(d.INS_START_DT)"+
					"";
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
					
					System.out.println("[InsDatabase:getInsComEmpInfo]"+ e);
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
		
		//임직원 고객정보 찾기
			public Vector getInsComEmpInfo3(String t_wd, String s_kd ) {
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Vector vt = new Vector();
			String query = "";

			query = " select CLIENT_ID, CLIENT_ST, CLIENT_NM, FIRM_NM,"+
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
					" CON_AGNT_NM2, CON_AGNT_O_TEL2, CON_AGNT_M_TEL2, CON_AGNT_FAX2, CON_AGNT_EMAIL2, CON_AGNT_DEPT2, CON_AGNT_TITLE2, lic_no, cms_sms "+
					" from CLIENT "+
				    " where 1=1";
					
					if(s_kd.equals("1")) {
						query += "AND CLIENT_NM like '%"+t_wd+"%' OR FIRM_NM like '%"+t_wd+"%'";
					}else if(s_kd.equals("3")) {
						query += "AND ENP_NO like '%"+t_wd+"%'";
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
					
					System.out.println("[InsDatabase:getInsComEmpInfo]"+ e);
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
		//임직원 가입 차량번호조회
		public Vector getInsComEmpInfo4(String client_id, String year) {
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Vector vt = new Vector();
			String query = "";

			query =  ""+
					" SELECT d.CAR_NO, d.CAR_NM, b.COM_EMP_START_DT, nvl(b.COM_EMP_EXP_DT,'확인서 발급일 현재') COM_EMP_EXP_DT, a.INS_START_DT, a.INS_EXP_DT,\r\n" + 
					"  		 e.INS_COM_NM, a.INS_CON_NO\r\n" + 
					"  FROM INSUR a, INS_COM_EMP_INFO b, CLIENT c, CAR_REG d, INS_COM e\r\n" + 
					"  WHERE a.CAR_MNG_ID = b.CAR_MNG_ID AND a.INS_ST = b.INS_ST\r\n" + 
					"  AND b.CLIENT_ID = c.CLIENT_ID\r\n" + 
					"  AND a.CAR_MNG_ID = d.CAR_MNG_ID \r\n" + 
					"  AND a.INS_COM_ID = e.INS_COM_ID \r\n" + 	
					"";
		
			if(!client_id.equals("")) query += " AND c.CLIENT_ID ="+client_id+" \r\n";
			if(!year.equals("")) query += "	AND (SUBSTR(b.COM_EMP_START_DT,1,4) = "+year+" OR NVL(SUBSTR(b.COM_EMP_EXP_DT,1,4),TO_CHAR(SYSDATE,'YYYY')) = "+year+") \r\n";
			
			query += "	ORDER BY d.CAR_NO, b.COM_EMP_START_DT";
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
					
					System.out.println("[InsDatabase:getInsComEmpInfo4]"+ e);
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
		
		//임직원 가입 차량번호로 Client 조회
		public Vector getInsComEmpInfo5(String car_no)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Vector vt = new Vector();
			String query = "";
			
			
			query =  ""+
					" SELECT d.CAR_NO, d.CAR_MNG_ID, d.CAR_NM, b.COM_EMP_START_DT, nvl(b.COM_EMP_EXP_DT,'-') COM_EMP_EXP_DT, a.INS_START_DT, a.INS_EXP_DT,\r\n" + 
					"  		 e.INS_COM_NM, a.INS_CON_NO, c.FIRM_NM \r\n" + 
					"  FROM INSUR a, INS_COM_EMP_INFO b, CLIENT c, CAR_REG d, INS_COM e\r\n" + 
					"  WHERE a.CAR_MNG_ID = b.CAR_MNG_ID AND a.INS_ST = b.INS_ST\r\n" + 
					"  AND b.CLIENT_ID = c.CLIENT_ID\r\n" + 
					"  AND a.CAR_MNG_ID = d.CAR_MNG_ID \r\n" + 
					"  AND a.INS_COM_ID = e.INS_COM_ID \r\n" + 
					//"  AND b.INS_ST ="+ins_st+" "+	
					"  AND d.CAR_NO like '%"+car_no+"%' "+	
			 		  "";
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
				
				System.out.println("[InsDatabase:getInsComEmpInfo5]"+ e);
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
		
		//엑셀등록 일괄처리
		public String call_sp_ins_excel_etc_act(String w_idx, String reg_code)
		{
			getConnection();

			CallableStatement cstmt = null;
			String sResult = "";
	        
	    	String query1 = "{CALL P_INS_EXCEL_ETC_ACT    (?, ?)}";
			
			try {

				cstmt = conn.prepareCall(query1);				
				cstmt.setString(1, w_idx);
				cstmt.setString(2, reg_code);
				cstmt.execute();
				cstmt.close();

			} catch (SQLException e) {
				System.out.println("[InsDatabase:call_sp_ins_excel_etc_act]"+ e);
		  		e.printStackTrace();
			} finally {
				try{
			                if(cstmt != null)	cstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return sResult;
			}
		}	
		
		////임직원 가입 정보
		public Hashtable getCarRegInfo(String car_mng_id)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Hashtable ht = new Hashtable();
			String query = "", sub_query = "";
			String dt = "";
			
			
			query =  "select * from car_reg where car_mng_id ='"+car_mng_id+"'";
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
				
				System.out.println("[InsDatabase:getInsComEmpInfo2(String car_mng_id, String ins_st)]"+ e);
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
		
		//엑셀등록 일괄처리
		public String call_sp_ins_cng_doc(String ins_doc_no)
		{
			getConnection();

			CallableStatement cstmt = null;
			String sResult = "";
	        
	    	String query1 = "{CALL P_INS_CNG_DOC    (?)}";
			
			try {

				cstmt = conn.prepareCall(query1);				
				cstmt.setString(1, ins_doc_no);
				cstmt.execute();
				cstmt.close();

			} catch (SQLException e) {
				System.out.println("[InsDatabase:call_sp_ins_cng_doc]"+ e);
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
		 * 보험 com_emp_yn 히스토리
		 */
		public boolean insertAttachedFile(AttachedFile file)
		{
			int count = 0;
			
			getConnection();
			boolean flag = true;
			String query = "insert into ACAR_ATTACH_FILE ("+ 
					" SEQ, CONTENT_CODE, CONTENT_SEQ, FILE_NAME, FILE_SIZE, FILE_TYPE, SAVE_FILE, SAVE_FOLDER, REG_USERSEQ  "+
					" ) values("+
					" ACAR_ATTACH_FILE_SEQ.nextval, ?, ?, ?, ?, ?, ?, ?, ? "+
					" )";
			
			
			PreparedStatement pstmt = null;
			
			try 
			{
				conn.setAutoCommit(false);
				pstmt = conn.prepareStatement(query);
				pstmt.setString	(1,  file.getContentCode()			);
				pstmt.setString	(2,  file.getContentSeq()			);
				pstmt.setString	(3,  file.getFileName()				);
				pstmt.setInt	(4,  (int) file.getFileSize()		);
				pstmt.setString	(5,  file.getFileType()				);
				pstmt.setString	(6,  file.getSaveFile()				);
				pstmt.setString	(7,  file.getSaveFolder()			);
				pstmt.setString	(8,  file.getRegUser()				);
				
				pstmt.executeUpdate();
				pstmt.close();
				
				conn.commit();
				
			} catch (Exception e) {
				System.out.println("[InsDatabase:insertInsComEmpInfo]"+ e);
				
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
		 * 보험 com_emp_yn 히스토리 카운트
		 */
		public int getInsChangeDocCnt(InsurChangeBean d_bean )
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			int count = 0;
			String query = "";
			
			query = " select count(0) from INS_CHANGE_DOC "+ 
					" where ch_st=3 "+
					" and CAR_MNG_ID='"+d_bean.getCar_mng_id()+"' "+
					" and ins_st='"+d_bean.getIns_st()+"' "+
					" and RENT_L_CD='"+d_bean.getRent_l_cd()+"' "+
					" and RENT_MNG_ID='"+d_bean.getRent_mng_id()+"' ";
			
			
			try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
	    	
				if(rs.next())
				{				
					count = rs.getInt(1);
				}
				rs.close();
				pstmt.close();
			} catch (SQLException e) {
				System.out.println("[InsDatabase:getInsComEmpInfoCnt(String car_no, String ins_con_no)]"+ e);
		  		e.printStackTrace();
			} finally {
				try{
	                if(rs != null)		rs.close();
	                if(pstmt != null)	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return count;
			}
		}
		
		/**
		 * ins_execl 재리스 대여차량인도 탁송의뢰 등록 찾기
		 */
		public int getInsExcelLeaseConsignmentCnt(String rent_mng_id,String rent_l_cd)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			int count = 0;
			String query = "";
			
			query = "	 SELECT count(*) FROM ins_excel \r\n" + 
					"	 WHERE  VALUE01='재리스 대여차량인도 탁송의뢰 등록' \r\n" + 
					"	 AND VALUE02 = ? "	+ 
					"	 AND VALUE03= ? "	+ 
					"	 AND gubun IS NULL ";
			
			
			try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, rent_mng_id);
				pstmt.setString(2, rent_l_cd);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
	    	
				if(rs.next())
				{				
					count = rs.getInt(1);
				}
				rs.close();
				pstmt.close();
			} catch (SQLException e) {
				System.out.println("[InsDatabase:etInsExcelLeaseConsignmentCnt(String rent_mng_id,String rent_l_cd)]"+ e);
		  		e.printStackTrace();
			} finally {
				try{
	                if(rs != null)		rs.close();
	                if(pstmt != null)	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return count;
			}
		}
		
		/**
		 *  ins_execl 재리스 대여차량인도 탁송의뢰 등록  등록일 수정 (value05)
		 */
		public boolean changeLeaseConsignmentRegDt(String now, String rent_mng_id,String rent_l_cd)
		{
			getConnection();
			boolean flag = true;
			String query = "update ins_excel set"+
								" value05 = ?"+
								"	 WHERE  VALUE01='재리스 대여차량인도 탁송의뢰 등록' \r\n" + 
								"	 AND VALUE02 = ? "	+ 
								"	 AND VALUE03= ? "	+ 
								"	 AND gubun IS NULL ";
			
			PreparedStatement pstmt = null;

			try 
			{
				conn.setAutoCommit(false);

				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, now);
				pstmt.setString(2, rent_mng_id);
				pstmt.setString(3, rent_l_cd);
			    pstmt.executeUpdate();
				pstmt.close();

				conn.commit();
			    
		  	} catch (Exception e) {
				System.out.println("[InsDatabase:changeInsSts]"+ e);
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
		 *	보험료스케줄 엑셀일괄 지급처리
		 */
		public boolean updateInsScdExcelPay(String car_mng_id, String ins_st, String ins_tm, String pay_dt)
		{
			getConnection();
			boolean flag = true;
			String query = " update scd_ins set							"+
							"       PAY_YN='1',							"+
							"       PAY_DT=replace(?, '-', ''),			"+
							"       excel_chk='1'						"+
							" where CAR_MNG_ID=? and INS_ST=? and INS_TM=?";

			PreparedStatement pstmt = null;

			try 
			{
				conn.setAutoCommit(false);
						
				pstmt = conn.prepareStatement(query);
				//set
				pstmt.setString(1, pay_dt);
				pstmt.setString(2, car_mng_id);
				pstmt.setString(3, ins_st);
				pstmt.setString(4, ins_tm);				
			    pstmt.executeUpdate();
				pstmt.close();
			    
			    conn.commit();
			} catch (Exception e) {
				System.out.println("[InsDatabase:updateInsScdExcelPay]"+ e);
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
		 *	중도해지취소 - 해지삭제
		 */
		public boolean dropInsCls(String c_id, String ins_st)
		{
			getConnection();
			PreparedStatement pstmt = null;
			boolean flag = true;
			String query =  " delete from ins_cls"+
							" where car_mng_id = ? and ins_st = ? ";

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
				System.out.println("[InsDatabase:dropInsCls]"+ e);
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
