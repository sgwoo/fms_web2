package acar.res_search;

import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;
import acar.account.*;
import acar.offls_pre.*;
import acar.stat_applet.*;


public class ResSearchDatabase
{
	private Connection conn = null;
	public static ResSearchDatabase db;
	
	public static ResSearchDatabase getInstance()
	{
		if(ResSearchDatabase.db == null)
			ResSearchDatabase.db = new ResSearchDatabase();
		return ResSearchDatabase.db;
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
	

	/**
	 *	예약조회 리스트
	 */
	public Vector getResSearchList(String br_id, String gubun1, String gubun2, String brch_id, String start_dt, String end_dt, String car_comp_id, String code, String s_cc, int s_year, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+ 
				" a.car_mng_id, a.car_no, k.car_nm, d.car_name, a.init_reg_dt, a.dpm, c.colo, c.opt, c.add_opt, d.car_name, g.max_dt,"+
				" e.imgfile1, e.imgfile2, e.imgfile3, e.imgfile4, e.imgfile5,"+
				" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(b.dlv_dt,a.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(b.dlv_dt,a.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as today_dist,"+
				" f.nm as fuel_kd,"+
				" b.brch_id, i.use_st, i.rent_st, nvl(j.use_per,0) use_per, k.car_comp_id code, a.prepare,"+
				" i.rent_s_cd, i.cust_st, i.cust_id, decode(i.use_st, '1','예약','2','배차','3','반차','대기') car_stat,"+
				" f2.nm as rent_st_nm,"+
				" decode(i.cust_st,'4',n.user_nm,l.firm_nm) cust_nm"+
				" from CAR_REG a, CONT b, CAR_ETC c, CAR_NM d, APPRSL e, CAR_MNG k, v_tot_dist vt, "+
					" (select car_mng_id, max(dt) max_dt from SCD_CAR group by car_mng_id) g,"+
					" (select a.car_mng_id, a.serv_dt, a.tot_dist from SERVICE a where a.serv_dt||a.serv_id=(select max(serv_dt||serv_id) from service where car_mng_id=a.car_mng_id and tot_dist > 0)) h,"+
					" (select a.rent_s_cd, a.car_mng_id, a.rent_st, a.use_st, a.cust_st, a.cust_id from rent_cont a, (select car_mng_id, max(deli_plan_dt) deli_plan_dt from rent_cont where use_st<>'5' group by car_mng_id) b where a.use_st<>'5' and a.car_mng_id=b.car_mng_id and a.deli_plan_dt=b.deli_plan_dt) i,"+
					" (select car_mng_id, to_char(count(0)/to_number(to_char(last_day(sysdate),'DD'))*100,999) use_per from scd_car where dt like to_char(sysdate,'YYYYMM')||'%' group by car_mng_id) j,"+
					" client l, users n, "+
					" (select * from code where c_st='0039') f, \n"+
					" (select * from code where c_st='0042') f2 \n"+
				" where a.off_ls ='0'"+
					" and a.car_mng_id=b.car_mng_id and nvl(b.use_yn,'Y')='Y' and b.car_st='2'"+
					" and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd"+
					" and c.car_id=d.car_id and c.car_seq=d.car_seq and d.car_comp_id=k.car_comp_id and d.car_cd=k.code"+
					" and a.car_mng_id=vt.car_mng_id(+)"+
					" and a.car_mng_id=e.car_mng_id(+)"+
					" and a.car_mng_id=g.car_mng_id(+)"+
					" and a.car_mng_id=h.car_mng_id(+)"+
					" and a.car_mng_id=i.car_mng_id(+)"+
					" and a.car_mng_id=j.car_mng_id(+)"+
					" and i.cust_id=l.client_id(+) and i.cust_id=n.user_id(+)\n"+
					" and a.fuel_kd=f.nm_cd and i.rent_st=f2.nm_cd(+) ";
		
		if     (gubun2.equals("1"))							query += " and nvl(i.use_st,'5') not in ('2')";
		else if(gubun2.equals("11"))						query += " and nvl(i.use_st,'5') not in ('1','2')";
		else if(gubun2.equals("12"))						query += " and nvl(i.use_st,'5') = '1'";
		else if(gubun2.equals("13"))						query += " and nvl(i.use_st,'5') = '2'";
		else if(gubun2.equals("14"))						query += " and nvl(i.use_st,'5') = '3'";
		else if(gubun2.equals("2"))							query += " and i.rent_st='4' and i.use_st in ('1','2')";
		
		if(brch_id.equals("S1"))							query += " and b.brch_id in ('S1','K1')";
		if(brch_id.equals("S2"))							query += " and b.brch_id='S2'";
		if(brch_id.equals("B1"))							query += " and b.brch_id='B1'";

		if     (!start_dt.equals("") && !end_dt.equals(""))	query += " and a.car_mng_id in (select DISTINCT car_mng_id from scd_car where dt not between '"+start_dt+"' and '"+end_dt+"')";
		else if(!start_dt.equals("") && end_dt.equals(""))	query += " and a.car_mng_id in (select DISTINCT car_mng_id from scd_car where dt not like '"+start_dt+"%')";

		if(!car_comp_id.equals(""))							query += " and k.car_comp_id='"+car_comp_id+"'";		
		if(!code.equals(""))								query += " and d.car_cd='"+code+"'";		

		if     (s_cc.equals("3"))							query += " and a.dpm > '2000'";
		else if(s_cc.equals("2"))							query += " and a.dpm between '1500' and '2000'";
		else if(s_cc.equals("1"))							query += " and a.dpm < '1500'";

		if(s_year > 0)										query += " and a.init_reg_dt like '"+s_year+"%'";	
					
		if(s_kd.equals("1"))								query += " and upper(a.car_no)||upper(a.first_car_no) like upper('%"+t_wd+"%')\n";		

		if     (!sort_gubun.equals("") && sort_gubun.equals("i.use_st"))	query += " ORDER BY i.use_st "+asc+", i.rent_st, a.car_nm ";
		else if(!sort_gubun.equals("") && !sort_gubun.equals("i.use_st"))	query += " ORDER BY "+sort_gubun+" "+asc;
		else																query += " ORDER BY a.car_nm";

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
			System.out.println("[ResSearchDatabase:getResSearchList]"+e);
			System.out.println("[ResSearchDatabase:getResSearchList]"+query);
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
	 *	예약조회 리스트
	 */
	public Vector getResSearchList_New(String br_id, String gubun1, String gubun2, String brch_id, String start_dt, String end_dt, String car_comp_id, String code, String s_cc, int s_year, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select   /*+ RULE */       "+
				"        a.car_mng_id, a.car_no, a.init_reg_dt, a.dpm, a.prepare, \n" +			
				"	 		decode(a.park,'6',substr(a.park_cont,1,5),nvl(cd.nm,a.park)) park, a.park_cont, \n"+
				"        nvl(g.mng_br_id,b.brch_id) brch_id,"+
				"        c.colo||decode(c.in_col,'','','(내장:'||c.in_col||')') as colo, "+
				"        c.opt, c.add_opt, \n" +
				"        k.car_comp_id code, k.car_nm, d.car_name,"+
				"        i.use_st, i.rent_st, i.rent_s_cd, i.cust_st, i.cust_id, \n" +
				"        decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(b.dlv_dt,a.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(b.dlv_dt,a.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as today_dist,"+
				"        cd2.nm as fuel_kd, \n" +
				"        decode(i.use_st, '1','예약','2','배차','3','반차','대기') car_stat,"+
				"        cd3.nm as rent_st_nm,\n" +
				"        decode(i.cust_st,'4',n.user_nm,l.firm_nm) cust_nm, i.d_car_no,\n" +
				"        decode(o.situation,'0','상담중','1','계약진행중','2','계약확정','3','계약연동') situation, o.memo, o.damdang, o.reg_dt as situation_dt, \n" +
				"        p.fee_s_amt+p.fee_v_amt as fee_amt, round(p.fee_s_amt/30,-3)*1.1 as day_amt,\n" +
				"        decode(q.rent_l_cd,'','','해지반납') call_in_st, q.in_dt as call_in_dt, \n" +
				"        nvl(f.upload_dt,'미견적') as upload_dt, decode(f.rb36, 0,f.lb36, -1,f.lb36, f.rb36) fee_amt, decode(f.rb30, 0,f.lb30, -1,f.lb30, f.rb30) fee_amt_30, f.rm1, NVL(f.rb36, f.rs36) rb, NVL(f.lb36, f.ls36) lb, \n" +
				"        decode(a.secondhand,'1','SH') sh, \n" +
				"        decode(a.rm_st,'1','즉시','6','기타','2','대상','3','정비요','5','정비요','4','A급','7','B급','8','C급','9','이동중','미확인') rm_st, a.car_use, \n" +
			    "        pa.park_id, pa.area, decode(pa.car_mng_id,'','','P') park_yn, \n" +
                "        sf.amt_01d, TRUNC((round(p.fee_s_amt/30,-3)*1.1)/sf.amt_01d*100,0) sf_amt_per \n" +
				" from   CAR_REG a, cont b, CAR_ETC c, CAR_NM d,  CAR_MNG k, v_tot_dist vt, client l, users n, cont_etc g, \n" +
				"        ( select c_st, code, nm_cd, nm from code where c_st = '0027') cd,  \n"+  //주차장 
				"        ( select c_st, code, nm_cd, nm from code where c_st = '0039') cd2,  \n"+
				"        ( select c_st, code, nm_cd, nm from code where c_st = '0042') cd3,  \n"+
				//       i 최근단기거래내역
				"        ( select a.rent_s_cd, a.car_mng_id, a.rent_st, a.use_st, a.cust_st, a.cust_id, c.car_no as d_car_no "+
				"        	from   rent_cont a, (select car_mng_id, max(nvl(deli_dt,deli_plan_dt)) deli_plan_dt from rent_cont where use_st in ('1','2') group by car_mng_id) b, car_reg c "+
				"        	where  a.use_st in ('1','2') and a.car_mng_id=b.car_mng_id and nvl(a.deli_dt,a.deli_plan_dt)=b.deli_plan_dt and a.sub_c_id=c.car_mng_id(+) "+
				"          ) i, \n" +
				//       o 재리스상담
				"        ( select a.*, b.user_nm as damdang from sh_res a, users b where a.use_yn='Y' and a.situation in ('0','2') and a.damdang_id=b.user_id(+)) o, \n" +
                //       p 일반대차요금
				"        ( select a.* "+
				"          from   estimate_sh a, "+
				"                 (select est_ssn, max(est_id) est_id from estimate_sh where est_from ='res_car' and est_fax='Y' and rent_dt like to_char(sysdate,'YYYYMM')||'%' group by est_ssn ) b "+
				"          where  a.est_from ='res_car' and a.est_fax='Y' and a.rent_dt like to_char(sysdate,'YYYYMM')||'%' and  a.est_ssn=b.est_ssn and a.est_id=b.est_id "+
				"        ) p, \n" +
                //       q 차량해지반납
				"        ( select * from car_call_in where in_st='3' and out_dt is null ) q, \n" +
                //       f 재리스차량
				"        (select * from secondhand a where a.seq = (select max(seq) from secondhand where car_mng_id=a.car_mng_id)) f, \n" +
				"        PARK_CONDITION pa, \n" +
				//단기요금
				"	     ( select a.section, a.amt_01D*1.1 AS amt_01d from short_fee_mng a, (select kind, section, fee_st, max(reg_dt) reg_dt from short_fee_mng group by kind, section, fee_st ) c \n"+
                "          where  a.fee_st='2' AND a.kind=c.kind AND a.section=C.SECTION AND a.fee_st=c.fee_st AND a.reg_dt=c.reg_dt ) sf  \n"+
				" where a.off_ls ='0'\n" +			
					" and a.car_mng_id=b.car_mng_id and nvl(b.use_yn,'Y')='Y' \n" +
					" and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd \n" +
					" and c.car_id=d.car_id and c.car_seq=d.car_seq and d.car_comp_id=k.car_comp_id and d.car_cd=k.code \n" +
					" and a.car_mng_id=vt.car_mng_id(+) \n" +
					" and a.car_mng_id=i.car_mng_id(+) \n" +
					" and i.cust_id=l.client_id(+) and i.cust_id=n.user_id(+) \n" +
					" and b.rent_mng_id=g.rent_mng_id(+) and b.rent_l_cd=g.rent_l_cd(+) \n" +				
					" and a.car_mng_id=o.car_mng_id(+) \n" +					
					" and a.car_mng_id=p.est_ssn(+) \n" +
					" and b.rent_mng_id=q.rent_mng_id(+) and b.rent_l_cd=q.rent_l_cd(+) \n" +					
					" and a.car_mng_id=f.car_mng_id(+) \n" +
					" and decode(q.rent_l_cd,'',b.car_st,'2')='2' \n" +
					" and a.car_mng_id=pa.car_mng_id(+) \n" +
				    " and d.section=sf.section(+) \n" +
					" and a.park = cd.nm_cd(+) \n"+  //주차장 코드 테이블 
					" and a.fuel_kd = cd2.nm_cd \n"+
					" and i.rent_st = cd3.nm_cd(+) \n"+
					" ";
		
		if(gubun2.equals("1"))								query += " and nvl(i.use_st,'5') not in ('2')"; //예비차량
		else if(gubun2.equals("11"))						query += " and nvl(i.use_st,'5') not in ('1','2') and nvl(a.prepare,'0') not in ('4','5', '9')"; //대기 (9:미회수차량포함 -20130108)
		else if(gubun2.equals("12"))						query += " and nvl(i.use_st,'5') = '1'"; //예약
		else if(gubun2.equals("13"))						query += " and nvl(i.use_st,'5') = '2'"; //배차
		else if(gubun2.equals("14"))						query += " and nvl(i.use_st,'5') = '3'"; //반차
		else if(gubun2.equals("2"))							query += " and i.rent_st='4' and i.use_st in ('1','2')"; //업무대여
		

		if(brch_id.equals("S1"))							query += " and nvl(g.mng_br_id,b.brch_id) in ('S1','K1','S2')";
		if(brch_id.equals("B1"))							query += " and nvl(g.mng_br_id,b.brch_id) in ('B1','N1')";
		if(brch_id.equals("D1"))							query += " and nvl(g.mng_br_id,b.brch_id)='D1'";
		if(brch_id.equals("G1"))							query += " and nvl(g.mng_br_id,b.brch_id)='G1'";
		if(brch_id.equals("J1"))							query += " and nvl(g.mng_br_id,b.brch_id)='J1'";

		if(!start_dt.equals("") && !end_dt.equals(""))		query += " and a.car_mng_id in (select DISTINCT car_mng_id from scd_car where dt not between '"+start_dt+"' and '"+end_dt+"')";
		else if(!start_dt.equals("") && end_dt.equals(""))	query += " and a.car_mng_id in (select DISTINCT car_mng_id from scd_car where dt not like '"+start_dt+"%')";

		if(!car_comp_id.equals(""))							query += " and k.car_comp_id='"+car_comp_id+"'";		
		if(!code.equals(""))								query += " and d.car_cd='"+code+"'";		

		if(s_cc.equals("3"))								query += " and to_number(a.dpm) > 2000";
		else if(s_cc.equals("2"))							query += " and to_number(a.dpm)  between 1500 and 2000";
		else if(s_cc.equals("1"))							query += " and to_number(a.dpm)  < 1500";

		if(s_year > 0)										query += " and a.init_reg_dt like '"+s_year+"%'";	
					
		if(s_kd.equals("1"))								query += " and upper(a.car_no)||upper(a.first_car_no) like upper('%"+t_wd+"%')\n";		
		if(s_kd.equals("5"))								query += " and upper(i.d_car_no) like upper('%"+t_wd+"%')\n";		

		if(!sort_gubun.equals("")){
			if(sort_gubun.equals("i.use_st"))				query += " ORDER BY i.use_st "+asc+", i.rent_st, a.car_nm ";
			else if(sort_gubun.equals("a.park"))			query += " ORDER BY decode(a.park,'6',substr(a.park_cont,1,5),nvl(cd.nm,a.park)) "+asc+", i.rent_st, a.car_nm ";
			else if(sort_gubun.equals("a.car_no")||sort_gubun.equals("a.car_nm")||sort_gubun.equals("a.init_reg_dt")||sort_gubun.equals("a.dpm"))	query += " ORDER BY "+sort_gubun+" "+asc+", d.jg_code ";
		}else{
			query += " ORDER BY a.car_nm ";
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
			System.out.println("[ResSearchDatabase:getResSearchList_New]"+e);
			System.out.println("[ResSearchDatabase:getResSearchList_New]"+query);			
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
	 *	배차관리 리스트
	 */
	public Vector getResStatList(String br_id, String gubun1, String gubun2, String brch_id, String start_dt, String end_dt, String car_comp_id, String code, String s_cc, int s_year, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select  "+
				"        a.rent_s_cd, a.car_mng_id, decode(a.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','장기대기','12','월렌트') rent_st,"+
				"        decode(a.cust_st, '', '조성희', '1',d.client_nm, '4',e.user_nm, c.cust_nm) cust_nm,\n"+
				"        decode(a.cust_st, '', '(주)아마존카', '1',d.firm_nm, '4','(주)아마존카', c.firm_nm) firm_nm,"+
				"        a.rent_dt, a.rent_start_dt, a.rent_end_dt, a.deli_plan_dt, a.ret_plan_dt, b.rent_tot_amt, a.brch_id, a.bus_id, \n"+
				"        cr.car_no, cr.init_reg_dt, j.car_nm, h.car_name, \n"+
				"        g.imgfile1, g.imgfile2, g.imgfile3, g.imgfile4, g.imgfile5"+
				" from   RENT_CONT a, RENT_FEE b, RENT_CUST c, CLIENT d, USERS e, CONT_N_VIEW f, APPRSL g, CAR_NM h, CAR_MNG j , car_etc ce, car_reg cr  \n"+
				" where  a.use_st='1' and a.rent_s_cd=b.rent_s_cd(+) and a.cust_id=c.cust_id(+) and a.cust_id=d.client_id(+) and a.cust_id=e.user_id(+) \n"+
				"        and a.car_mng_id=f.car_mng_id and nvl(f.use_yn,'Y')='Y' and a.car_mng_id=g.car_mng_id(+) and f.car_mng_id = cr.car_mng_id \n"+
				"        and f.rent_mng_id = ce.rent_mng_id(+) and f.rent_l_cd = ce.rent_l_cd(+) \n"+
				"        and ce.car_id=h.car_id(+) and ce.car_seq=h.car_seq(+) and h.car_comp_id=j.car_comp_id and h.car_cd=j.code";

		
		
		if(!gubun2.equals("")){
			if(gubun2.equals("20"))								query += " and a.rent_st in ('1', '2', '3', '4', '5')";
  			else if(gubun2.equals("30"))						query += " and a.rent_st in ('6', '7', '8')";
  			else if(gubun2.equals("4"))							query += " and a.rent_st in ('4', '5')";
  			else if(gubun2.equals("6"))							query += " and a.rent_st in ('6', '7')";
			else												query += " and a.rent_st='"+gubun2+"'";
		}


		if(brch_id.equals("S1"))								query += " and a.brch_id in ('S1','K1')";
		if(brch_id.equals("S2"))								query += " and a.brch_id='S2'";
		if(brch_id.equals("B1"))								query += " and a.brch_id='B1'";

		if(!start_dt.equals("") && !end_dt.equals(""))			query += " and a.deli_plan_dt between '"+start_dt+"00' and '"+end_dt+"24'";
		else if(!start_dt.equals("") && end_dt.equals(""))		query += " and a.deli_plan_dt like '"+start_dt+"%'";

		if(!car_comp_id.equals(""))								query += " and j.car_comp_id='"+car_comp_id+"'";		
		if(!code.equals(""))									query += " and j.code='"+code+"'";		
				
		if(s_kd.equals("1"))									query += " and upper(cr.car_no)||upper(cr.first_car_no) like upper('%"+t_wd+"%')\n";		
		if(s_kd.equals("2"))									query += " and decode(a.cust_st, '', '조성희', '1',d.client_nm, '4',e.user_nm, c.cust_nm) like '%"+t_wd+"%'\n";		
		if(s_kd.equals("3"))									query += " and decode(a.cust_st, '', '(주)아마존카', '1',d.firm_nm, '4','(주)아마존카', c.firm_nm) like '%"+t_wd+"%'\n";		

		if(!sort_gubun.equals(""))								query += " ORDER BY "+sort_gubun+" "+asc;
		else													query += " ORDER BY j.car_nm";

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
			System.out.println("[ResSearchDatabase:getResStatList]"+e);
			System.out.println("[ResSearchDatabase:getResStatList]"+query);
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
	 *	배차관리 리스트
	 */
	public Vector getResStatList_New(String br_id, String gubun1, String gubun2, String brch_id, String start_dt, String end_dt, String car_comp_id, String code, String s_cc, int s_year, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				"        a.rent_s_cd, a.car_mng_id, decode(d.rm_st,'1','즉시','6','기타','2','대상','3','정비요','5','정비요','4','A급','7','B급','8','C급','9','이동중','미확인') rm_st,  "+
				"        decode(a.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','장기대기','12','월렌트') rent_st,"+
				"        decode(a.cust_st, '4',c.user_nm, b.firm_nm) cust_nm,"+
				"        a.rent_dt, a.rent_start_dt, a.rent_end_dt, a.deli_plan_dt, a.ret_plan_dt, a.brch_id, a.bus_id,"+
				"        d.car_no, d.init_reg_dt, d.car_nm, i.car_name, f.user_nm as bus_nm, d2.car_no as d_car_no, d2.car_nm as d_car_nm, f2.user_nm as mng_nm, a.etc "+
				" from   RENT_CONT a, CLIENT b, USERS c, CAR_REG d, users f, car_reg d2,"+
				"        (select a.car_mng_id, min(ce.car_id) car_id, min(ce.car_seq) car_seq from cont a, car_etc ce where a.rent_mng_id = ce.rent_mng_id and a.rent_l_cd = ce.rent_l_cd group by a.car_mng_id) g, car_nm i, CAR_MNG e, users f2 "+
				" where  a.use_st='1' and a.cust_id=b.client_id(+) and a.cust_id=c.user_id(+)"+
				"        and a.car_mng_id=d.car_mng_id and a.bus_id=f.user_id(+) and a.sub_c_id=d2.car_mng_id(+)"+
				"        and a.car_mng_id=g.car_mng_id and g.car_id=i.car_id and g.car_seq=i.car_seq and i.car_comp_id=e.car_comp_id and i.car_cd=e.code "+
				"        and a.mng_id=f2.user_id(+) "+  /*AND NVL(d.RM_YN, 'Y') <> 'N' */
				" ";
		
		if(!gubun2.equals("")){
			if(gubun2.equals("20"))								query += " and a.rent_st in ('1', '2', '3', '4', '5')";
  			else if(gubun2.equals("30"))						query += " and a.rent_st in ('6', '7', '8')";
  			else if(gubun2.equals("4"))							query += " and a.rent_st in ('4', '5')";
  			else if(gubun2.equals("6"))							query += " and a.rent_st in ('6', '7')";
			else												query += " and a.rent_st='"+gubun2+"'";
		}

		if(brch_id.equals("S1"))								query += " and a.brch_id in ('S1','K1','S2')";
//		if(brch_id.equals("S2"))								query += " and a.brch_id='S2'";
		if(brch_id.equals("B1"))								query += " and a.brch_id in ('B1','N1')";
		if(brch_id.equals("D1"))								query += " and a.brch_id='D1'";
		if(brch_id.equals("G1"))								query += " and a.brch_id='G1'";
		if(brch_id.equals("J1"))								query += " and a.brch_id='J1'";

		if(!start_dt.equals("") && !end_dt.equals(""))			query += " and a.deli_plan_dt between '"+start_dt+"00' and '"+end_dt+"24'";
		else if(!start_dt.equals("") && end_dt.equals(""))		query += " and a.deli_plan_dt like '"+start_dt+"%'";

		if(!car_comp_id.equals(""))								query += " and e.car_comp_id='"+car_comp_id+"'";		
		if(!code.equals(""))									query += " and e.code='"+code+"'";		
			
		if(!t_wd.equals("")){
			if(s_kd.equals("1"))								query += " and upper(d.car_no)||upper(d.first_car_no) like upper('%"+t_wd+"%')\n";		
			if(s_kd.equals("2"))								query += " and decode(a.cust_st, '4',c.user_nm, b.client_nm) like '%"+t_wd+"%'\n";		
			if(s_kd.equals("3"))								query += " and decode(a.cust_st, '4','(주)아마존카', b.firm_nm) like '%"+t_wd+"%'\n";		
			if(s_kd.equals("4"))								query += " and f.user_nm like '%"+t_wd+"%'\n";		
			if(s_kd.equals("5"))								query += " and upper(d2.car_no)||upper(d2.first_car_no) like upper('%"+t_wd+"%')\n";			
		}

		if(sort_gubun.equals("a.dpm"))							sort_gubun  = "d.dpm";

		if(!sort_gubun.equals(""))								query += " ORDER BY decode(a.rent_st,'11',1,0), decode(a.rent_st,'4',1,0), "+sort_gubun+" "+asc;
		else													query += " ORDER BY decode(a.rent_st,'11',1,0), decode(a.rent_st,'4',1,0), d.car_nm";


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
			System.out.println("[ResSearchDatabase:getResStatList_New]"+e);
			System.out.println("[ResSearchDatabase:getResStatList_New]"+query);
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
	 *	반차관리 리스트
	 */
	public Vector getRentMngList(String br_id, String gubun1, String gubun2, String brch_id, String start_dt, String end_dt, String car_comp_id, String code, String s_cc, int s_year, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select  "+
				" a.rent_s_cd, a.car_mng_id, decode(a.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','장기대기','12','월렌트') rent_st,"+
				" decode(a.cust_st, '', '조성희', '1',d.client_nm, '4',e.user_nm, c.cust_nm) cust_nm,"+
				" decode(a.cust_st, '', '(주)아마존카', '1',d.firm_nm, '4','(주)아마존카', c.firm_nm) firm_nm,"+
				" a.rent_dt, a.rent_start_dt, a.rent_end_dt, a.deli_plan_dt, a.ret_plan_dt, a.deli_dt, a.ret_dt, b.rent_tot_amt, a.brch_id, a.bus_id,"+
				" cr.car_no, cr.init_reg_dt, j.car_nm, h.car_name,"+
				" g.imgfile1, g.imgfile2, g.imgfile3, g.imgfile4, g.imgfile5"+
				" from RENT_CONT a, RENT_FEE b, RENT_CUST c, CLIENT d, USERS e, CONT_N_VIEW f, APPRSL g, CAR_NM h, CAR_MNG j , car_etc ce, car_reg cr  \n"+
				" where a.use_st='2' and a.rent_s_cd=b.rent_s_cd(+) and a.cust_id=c.cust_id(+) and a.cust_id=d.client_id(+) and a.cust_id=e.user_id(+)"+
				" and a.car_mng_id=f.car_mng_id and nvl(f.use_yn,'Y')='Y' and a.car_mng_id=g.car_mng_id(+)  and f.car_mng_id = cr.car_mng_id \n"+
				"        and f.rent_mng_id = ce.rent_mng_id(+) and f.rent_l_cd = ce.rent_l_cd(+) \n"+
				"        and ce.car_id=h.car_id(+) and ce.car_seq=h.car_seq(+) and h.car_comp_id=j.car_comp_id and h.car_cd=j.code";
						
		
		if(!gubun2.equals("")){
		  if(gubun2.equals("20"))							query += " and a.rent_st in ('1', '2', '3', '4', '5')";
  		else if(gubun2.equals("30"))						query += " and a.rent_st in ('6', '7', '8')";
  		else if(gubun2.equals("4"))							query += " and a.rent_st in ('4', '5')";
  		else if(gubun2.equals("6"))							query += " and a.rent_st in ('6', '7')";
		  else												query += " and a.rent_st='"+gubun2+"'";
	  }

		if(brch_id.equals("S1"))							query += " and a.brch_id in ('S1','K1')";
		if(brch_id.equals("S2"))							query += " and a.brch_id='S2'";
		if(brch_id.equals("B1"))							query += " and a.brch_id='B1'";

		if(!start_dt.equals("") && !end_dt.equals(""))		query += " and a.ret_plan_dt between '"+start_dt+"00' and '"+end_dt+"24'";
		else if(!start_dt.equals("") && end_dt.equals(""))	query += " and a.ret_plan_dt like '"+start_dt+"%'";

		if(!car_comp_id.equals(""))							query += " and j.car_comp_id='"+car_comp_id+"'";		
		if(!code.equals(""))								query += " and j.code='"+code+"'";		
				
		if(s_kd.equals("1"))								query += " and upper(cr.car_no)||upper(cr.first_car_no) like upper('%"+t_wd+"%')\n";		
		if(s_kd.equals("2"))								query += " and decode(a.cust_st, '', '조성희', '1',d.client_nm, '4',e.user_nm, c.cust_nm) like '%"+t_wd+"%'\n";		
		if(s_kd.equals("3"))								query += " and decode(a.cust_st, '', '(주)아마존카', '1',d.firm_nm, '4','(주)아마존카', c.firm_nm) like '%"+t_wd+"%'\n";		

		if(!sort_gubun.equals(""))							query += " ORDER BY "+sort_gubun+" "+asc;
		else												query += " ORDER BY j.car_nm";

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
			System.out.println("[ResSearchDatabase:getRentMngList]"+e);
			System.out.println("[ResSearchDatabase:getRentMngList]"+query);
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
	 *	반차관리 리스트
	 */
	public Vector getRentMngList_New(String br_id, String gubun1, String gubun2, String brch_id, String start_dt, String end_dt, String car_comp_id, String code, String s_cc, int s_year, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select /*+ leading(A H F) index(a RENT_CONT_IDX4) index(i CAR_NM_IDX1) */ \n"+
				"        a.rent_s_cd, a.car_mng_id, a.etc, \n"+
				"        decode(a.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','장기대기','12','월렌트') rent_st,\n"+
				"        decode(a.cust_st, '','아마존카', '4',e.user_nm, d.client_nm) cust_nm, \n"+
				"        decode(a.cust_st, '','아마존카', '4',e.user_nm, d.firm_nm) firm_nm, \n"+
				"        a.rent_dt, a.rent_start_dt, a.rent_end_dt, a.deli_plan_dt, a.ret_plan_dt, a.deli_dt, a.ret_dt, b.rent_tot_amt, a.brch_id, a.bus_id, \n"+
				"        c.car_no, c.init_reg_dt, c.car_nm, i.car_name, g.user_nm as bus_nm, g2.user_nm as mng_nm, \n"+
				"        c2.car_no as d_car_no, c2.car_nm as d_car_nm, a.cust_id, e.loan_st, replace(a.sub_l_cd,' ','') as sub_l_cd \n"+
				" from   RENT_CONT a, RENT_FEE b, CAR_REG c, CLIENT d, USERS e, users g, users g2, \n"+
				"        (select  /*+ index(a CONT_IDX5) */  a.* FROM CONT a, (SELECT car_mng_id, min(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%'   group by car_mng_id) b WHERE a.car_mng_id=b.car_mng_id AND a.rent_l_cd=b.rent_l_cd) h, "+
				"        car_reg c2, \n"+
				"        car_etc f, \n"+
				"        car_nm i, CAR_MNG j \n"+
				" where  a.use_st='2' and a.rent_s_cd=b.rent_s_cd(+) and a.car_mng_id=c.car_mng_id and a.cust_id=d.client_id(+) and a.cust_id=e.user_id(+) \n"+
				"        and a.bus_id=g.user_id(+) and a.mng_id=g2.user_id(+) "+
				"		 and a.car_mng_id=h.car_mng_id "+
				"		 and a.sub_c_id=c2.car_mng_id(+) \n"+
				"        and h.rent_mng_id=f.rent_mng_id and h.rent_l_cd=f.rent_l_cd "+
				"	     and f.car_id=i.car_id and f.car_seq=i.car_seq and i.car_comp_id=j.car_comp_id and i.car_cd=j.code \n "+
				" ";

		if(!gubun2.equals("")){
			if(gubun2.equals("20"))								query += " and a.rent_st in ('1', '2', '3', '4', '5')";
  			else if(gubun2.equals("30"))						query += " and a.rent_st in ('6', '7', '8')";
  			else if(gubun2.equals("4"))							query += " and a.rent_st in ('4', '5')";
  			else if(gubun2.equals("6"))							query += " and a.rent_st in ('6', '7')";
			else												query += " and a.rent_st='"+gubun2+"'";
		}

		if(brch_id.equals("S1"))								query += " and a.brch_id in ('S1','K1','S2')";
//		if(brch_id.equals("S2"))								query += " and a.brch_id='S2'";
		if(brch_id.equals("B1"))								query += " and a.brch_id in ('B1','N1')";
		if(brch_id.equals("D1"))								query += " and a.brch_id='D1'";
		if(brch_id.equals("G1"))								query += " and a.brch_id='G1'";
		if(brch_id.equals("J1"))								query += " and a.brch_id='J1'";


		if(!start_dt.equals("") && !end_dt.equals(""))			query += " and a.ret_plan_dt between '"+start_dt+"00' and '"+end_dt+"24'";
		else if(!start_dt.equals("") && end_dt.equals(""))		query += " and a.ret_plan_dt like '"+start_dt+"%'";

		if(!car_comp_id.equals(""))								query += " and j.car_comp_id='"+car_comp_id+"'";		
		if(!code.equals(""))									query += " and j.code='"+code+"'";		
				
		if(s_kd.equals("1"))									query += " and upper(c.car_no)||upper(c.first_car_no) like upper('%"+t_wd+"%')\n";		
		if(s_kd.equals("2"))									query += " and decode(a.cust_st, '','아마존카', '4',e.user_nm, d.client_nm) like '%"+t_wd+"%'\n";		
		if(s_kd.equals("3"))									query += " and decode(a.cust_st, '','아마존카', '4',e.user_nm, d.firm_nm) like '%"+t_wd+"%'\n";		
		if(s_kd.equals("4"))									query += " and g.user_nm like '%"+t_wd+"%'\n";		
		if(s_kd.equals("5"))									query += " and upper(c2.car_no)||upper(c2.first_car_no) like '%"+t_wd+"%'\n";		
		if(s_kd.equals("6"))									query += " and g2.user_nm like '%"+t_wd+"%'\n";		
		if(s_kd.equals("7"))									query += " and g.user_nm||g2.user_nm like '%"+t_wd+"%'\n";		
		if(s_kd.equals("8"))									query += " and a.rent_s_cd = '"+t_wd+"'\n";		


		if(sort_gubun.equals("d.car_no"))	sort_gubun = "c.car_no";


		if(!sort_gubun.equals(""))								query += " ORDER BY decode(a.rent_st,'4',1,0), decode(a.rent_st, '4', '00', '12', '01',  '99') desc , "+sort_gubun+" "+asc;
		else													query += " ORDER BY decode(a.rent_st,'4',1,0), decode(a.cust_st, '4',e.user_nm, d.firm_nm)";

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
			System.out.println("[ResSearchDatabase:getRentMngList_New]"+e);
			System.out.println("[ResSearchDatabase:getRentMngList_New]"+query);
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
	 *	정산관리 리스트
	 */
	public Vector getRentSettleList(String br_id, String gubun1, String gubun2, String brch_id, String start_dt, String end_dt, String car_comp_id, String code, String s_cc, int s_year, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select  "+
				" a.rent_s_cd, a.car_mng_id, decode(a.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','장기대기','12','월렌트') rent_st,"+
				" decode(a.cust_st, '','조성희', '1',d.client_nm, '4',e.user_nm, c.cust_nm) cust_nm,"+
				" decode(a.cust_st, '','(주)아마존카', '1',d.firm_nm, '4','(주)아마존카', c.firm_nm) firm_nm,"+
				" a.rent_dt, a.rent_start_dt, a.rent_end_dt, a.deli_plan_dt, a.ret_plan_dt, a.deli_dt, a.ret_dt, b.rent_tot_amt, a.brch_id, a.bus_id,"+
				" cr.car_no, cr.init_reg_dt, j.car_nm, h.car_name,"+
				" g.imgfile1, g.imgfile2, g.imgfile3, g.imgfile4, g.imgfile5"+
				" from RENT_CONT a, RENT_FEE b, RENT_CUST c, CLIENT d, USERS e, CONT_N_VIEW f, APPRSL g, CAR_NM h, CAR_MNG j  , car_etc ce, car_reg cr  \n"+
				" where a.use_st='3' and a.rent_s_cd=b.rent_s_cd(+) and a.cust_id=c.cust_id(+) and a.cust_id=d.client_id(+) and a.cust_id=e.user_id(+)"+
				" and a.car_mng_id=f.car_mng_id and nvl(f.use_yn,'Y')='Y' and a.car_mng_id=g.car_mng_id(+) and f.car_mng_id = cr.car_mng_id \n"+
				"        and f.rent_mng_id = ce.rent_mng_id(+) and f.rent_l_cd = ce.rent_l_cd(+) \n"+
				"        and ce.car_id=h.car_id(+) and ce.car_seq=h.car_seq(+) and h.car_comp_id=j.car_comp_id and h.car_cd=j.code";
				
		
		if(!gubun2.equals("") && !gubun2.equals("20") && !gubun2.equals("30"))		query += " and a.rent_st='"+gubun2+"'";
		else if(gubun2.equals("20"))												query += " and a.rent_st in ('1', '2', '3', '4', '5')";
		else if(gubun2.equals("30"))												query += " and a.rent_st in ('6', '7', '8'";

		if(brch_id.equals("S1"))							query += " and a.brch_id in ('S1','K1')";
		if(brch_id.equals("S2"))							query += " and a.brch_id='S2'";
		if(brch_id.equals("B1"))							query += " and a.brch_id='B1'";

		if(!start_dt.equals("") && !end_dt.equals(""))		query += " and a.ret_dt between '"+start_dt+"00' and '"+end_dt+"24'";
		else if(!start_dt.equals("") && end_dt.equals(""))	query += " and a.ret_dt like '"+start_dt+"%'";

		if(!car_comp_id.equals(""))							query += " and j.car_comp_id='"+car_comp_id+"'";		
		if(!code.equals(""))								query += " and j.code='"+code+"'";		
				
		if(s_kd.equals("1"))								query += " and upper(cr.car_no)||upper(cr.first_car_no) like upper('%"+t_wd+"%')\n";		
		if(s_kd.equals("2"))								query += " and decode(a.cust_st, '','조성희', '1',d.client_nm, '4',e.user_nm, c.cust_nm) like '%"+t_wd+"%'\n";		
		if(s_kd.equals("3"))								query += " and decode(a.cust_st, '','(주)아마존카', '1',d.firm_nm, '4','(주)아마존카', c.firm_nm) like '%"+t_wd+"%'\n";		

		if(!sort_gubun.equals(""))							query += " ORDER BY "+sort_gubun+" "+asc;
		else												query += " ORDER BY j.car_nm";

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
			System.out.println("[ResSearchDatabase:getRentSettleList]"+e);
			System.out.println("[ResSearchDatabase:getRentSettleList]"+query);
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
	 *	정산관리 리스트
	 */
	public Vector getRentSettleList_New(String br_id, String gubun1, String gubun2, String brch_id, String start_dt, String end_dt, String car_comp_id, String code, String s_cc, int s_year, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" a.rent_s_cd, a.car_mng_id, decode(a.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','장기대기','12','월렌트') rent_st,"+
				" decode(a.cust_st, '4',e.user_nm, d.client_nm) cust_nm,"+
				" decode(a.cust_st, '4','(주)아마존카', d.firm_nm) firm_nm,"+
				" a.rent_dt, a.rent_start_dt, a.rent_end_dt, a.deli_plan_dt, a.ret_plan_dt, a.deli_dt, a.ret_dt, b.rent_tot_amt, a.brch_id, a.bus_id,"+
				" a.rent_hour tot_hour, a.rent_days tot_days, a.rent_months tot_months,"+
				" f.car_no, f.init_reg_dt, f.car_nm,"+
				" h.user_nm as bus_nm, h2.user_nm as mng_nm, "+
				" trunc(to_date(a.ret_dt,'YYYYMMDDHH24mi')-to_date(a.deli_dt,'YYYYMMDDHH24mi'),0) use_day, a.cls_st"+
				" from   RENT_CONT a, RENT_FEE b, CLIENT d, USERS e, CAR_REG f, users h, users h2, "+
				"        (select   /*+ index(a CONT_IDX5) */  a.* FROM CONT a, (SELECT car_mng_id, min(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%'  group by car_mng_id) b WHERE a.car_mng_id=b.car_mng_id AND a.rent_l_cd=b.rent_l_cd) c, "+
				"        car_etc g, car_nm i, CAR_MNG j "+
				" where a.use_st in ('3') and a.rent_st in ('1','9','12','2') "+
				" and a.rent_s_cd=b.rent_s_cd(+) and a.cust_id=d.client_id(+) and a.cust_id=e.user_id(+) "+
				" and a.car_mng_id=f.car_mng_id and a.bus_id=h.user_id(+) and a.mng_id=h2.user_id(+) "+
//				" and f.car_nm=j.car_nm(+) "+
				" and a.car_mng_id=c.car_mng_id "+
				" and c.rent_mng_id=g.rent_mng_id and c.rent_l_cd=g.rent_l_cd "+
				" and g.car_id=i.car_id and g.car_seq=i.car_seq "+
				" and i.car_comp_id=j.car_comp_id and i.car_cd=j.code "+
				" and decode(a.rent_st,'2',decode(b.fee_s_amt,0,'N','Y'),'Y')='Y' "+
				" ";
		
		
		if(!gubun2.equals("") && !gubun2.equals("20") && !gubun2.equals("30"))		query += " and a.rent_st='"+gubun2+"'";
		else if(gubun2.equals("20"))												query += " and a.rent_st in ('1', '2', '3', '4', '5')";
		else if(gubun2.equals("30"))												query += " and a.rent_st in ('6', '7', '8'";


		if(brch_id.equals("S1"))							query += " and a.brch_id in ('S1','K1','S2')";
		if(brch_id.equals("S2"))							query += " and a.brch_id='S2'";
		if(brch_id.equals("B1"))							query += " and a.brch_id in ('B1','N1')";
		if(brch_id.equals("D1"))							query += " and a.brch_id='D1'";
		if(brch_id.equals("G1"))							query += " and a.brch_id='G1'";
		if(brch_id.equals("J1"))							query += " and a.brch_id='J1'";

		if(!start_dt.equals("") && !end_dt.equals(""))		query += " and a.ret_dt between '"+start_dt+"00' and '"+end_dt+"24'";
		else if(!start_dt.equals("") && end_dt.equals(""))	query += " and a.ret_dt like '"+start_dt+"%'";

		if(!car_comp_id.equals(""))							query += " and j.car_comp_id='"+car_comp_id+"'";		
		if(!code.equals(""))								query += " and j.code='"+code+"'";		
				
		if(s_kd.equals("1"))								query += " and upper(f.car_no)||upper(f.first_car_no) like upper('%"+t_wd+"%')\n";		
		if(s_kd.equals("2"))								query += " and decode(a.cust_st, '4',e.user_nm, d.client_nm) like '%"+t_wd+"%'\n";		
		if(s_kd.equals("3"))								query += " and decode(a.cust_st, '4','(주)아마존카', d.firm_nm) like '%"+t_wd+"%'\n";	
		if(s_kd.equals("4"))								query += " and upper(h.user_nm) like upper('%"+t_wd+"%')\n";		
		if(s_kd.equals("5"))								query += " and upper(h2.user_nm) like upper('%"+t_wd+"%')\n";		

		if(!sort_gubun.equals(""))							query += " ORDER BY "+sort_gubun+" "+asc;
		else												query += " ORDER BY f.car_nm";

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
			System.out.println("[ResSearchDatabase:getRentSettleList_New]"+e);
			System.out.println("[ResSearchDatabase:getRentSettleList_New]"+query);
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
	 *	사후관리 리스트
	 */
	public Vector getRentEndList(String br_id, String gubun1, String gubun2, String brch_id, String start_dt, String end_dt, String car_comp_id, String code, String s_cc, int s_year, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select  "+
				" a.rent_s_cd, a.car_mng_id, decode(a.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','장기대기','12','월렌트') rent_st,"+
				" decode(a.cust_st, '','조성희', '1',d.client_nm, '4',e.user_nm, c.cust_nm) cust_nm,"+
				" decode(a.cust_st, '','(주)아마존카', '1',d.firm_nm, '4','(주)아마존카', c.firm_nm) firm_nm,"+
				" a.rent_dt, a.rent_start_dt, a.rent_end_dt, a.deli_plan_dt, a.ret_plan_dt, a.deli_dt, a.ret_dt, b.rent_tot_amt, a.brch_id, a.bus_id,"+
				" j.sett_dt, j.tot_hour, j.tot_days, j.tot_months, j.rent_tot_amt, j.run_km,"+
				" cr.car_no, cr.init_reg_dt, k.car_nm, h.car_name,"+
				" g.imgfile1, g.imgfile2, g.imgfile3, g.imgfile4, g.imgfile5"+
				" from RENT_CONT a, RENT_FEE b, RENT_CUST c, CLIENT d, USERS e, CONT_N_VIEW f, APPRSL g, CAR_NM h, RENT_SETTLE j, CAR_MNG k , car_etc ce, car_reg cr  \n"+
				" where a.use_st='4' and a.rent_s_cd=b.rent_s_cd(+)"+
				" and a.cust_id=c.cust_id(+) and a.cust_id=d.client_id(+) and a.cust_id=e.user_id(+)"+
				" and a.car_mng_id=f.car_mng_id and a.car_mng_id=g.car_mng_id(+) and f.car_mng_id = cr.car_mng_id \n"+
				"        and f.rent_mng_id = ce.rent_mng_id(+) and f.rent_l_cd = ce.rent_l_cd(+) \n"+
				"        and ce.car_id=h.car_id(+) and ce.car_seq=h.car_seq(+) and h.car_comp_id=k.car_comp_id and h.car_cd=k.code \n"+		
				" and a.rent_s_cd=j.rent_s_cd and f.rent_l_cd = (select max(rent_l_cd) from cont where car_mng_id=a.car_mng_id and rent_l_cd not like 'RM%')";
		
				
		if(!gubun2.equals("") && !gubun2.equals("20") && !gubun2.equals("30"))		query += " and a.rent_st='"+gubun2+"'";
		else if(gubun2.equals("20"))												query += " and a.rent_st in ('1', '2', '3', '4', '5')";
		else if(gubun2.equals("30"))												query += " and a.rent_st in ('6', '7', '8'";

		if(brch_id.equals("S1"))							query += " and a.brch_id in ('S1','K1')";
		if(brch_id.equals("S2"))							query += " and a.brch_id='S2'";
		if(brch_id.equals("B1"))							query += " and a.brch_id='B1'";

		if(!start_dt.equals("") && !end_dt.equals(""))		query += " and j.sett_dt between '"+start_dt+"' and '"+end_dt+"'";
		else if(!start_dt.equals("") && end_dt.equals(""))	query += " and j.sett_dt like '"+start_dt+"%'";

		if(!car_comp_id.equals(""))							query += " and k.car_comp_id='"+car_comp_id+"'";		
		if(!code.equals(""))								query += " and k.code='"+code+"'";		
				
		if(s_kd.equals("1"))								query += " and upper(cr.car_no)||upper(cr.first_car_no) like upper('%"+t_wd+"%')\n";		
		if(s_kd.equals("2"))								query += " and decode(a.cust_st, '','조성희', '1',d.client_nm, '4',e.user_nm, c.cust_nm) like '%"+t_wd+"%'\n";		
		if(s_kd.equals("3"))								query += " and decode(a.cust_st, '','(주)아마존카', '1',d.firm_nm, '4','(주)아마존카', c.firm_nm) like '%"+t_wd+"%'\n";		

		if(!sort_gubun.equals(""))							query += " ORDER BY "+sort_gubun+" "+asc;
		else												query += " ORDER BY k.car_nm";

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
			System.out.println("[ResSearchDatabase:getRentEndList]"+e);
			System.out.println("[ResSearchDatabase:getRentEndList]"+query);
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
	 *	사후관리 리스트  
	 */
	public Vector getRentEndList_New(String br_id, String gubun1, String gubun2, String brch_id, String start_dt, String end_dt, String car_comp_id, String code, String s_cc, int s_year, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" a.rent_s_cd, a.car_mng_id, a.rent_dt, a.rent_start_dt, a.rent_end_dt, a.deli_plan_dt, a.ret_plan_dt, a.deli_dt, a.ret_dt, a.brch_id, a.bus_id,"+
				" b.rent_tot_amt, "+
				" j.sett_dt, j.rent_tot_amt, j.run_km,"+
				" f.car_no, f.init_reg_dt, f.car_nm, "+
				" i.user_nm as bus_nm,"+
				" decode(a.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','장기대기','12','월렌트') rent_st,"+
				" decode(a.cust_st, '4',e.user_nm, d.client_nm) cust_nm,"+
				" decode(a.cust_st, '4','(주)아마존카', d.firm_nm) firm_nm,"+
				" nvl(j.tot_hour,a.rent_hour) tot_hour, nvl(j.tot_days,a.rent_days) tot_days, nvl(j.tot_months,a.rent_months) tot_months,"+
				" trunc(to_date(substr(nvl(a.ret_dt,a.ret_plan_dt),1,8),'YYYYMMDD')-to_date(substr(nvl(a.deli_dt,a.deli_plan_dt),1,8),'YYYYMMDD'),0) use_day, "+
				" f2.car_no as d_car_no, f2.car_nm as d_car_nm"+
				" from RENT_CONT a, RENT_FEE b, RENT_SETTLE j, CLIENT d, USERS e, CAR_REG f, users i, car_mng k, car_reg f2"+
				" where a.use_st in ('4','5') and a.rent_s_cd=b.rent_s_cd(+)"+
				" and a.cust_id=d.client_id(+) and a.cust_id=e.user_id(+)"+
				" and a.car_mng_id=f.car_mng_id "+
				" and a.rent_s_cd=j.rent_s_cd(+) and a.bus_id=i.user_id(+) and f.car_nm=k.car_nm(+) and a.sub_c_id=f2.car_mng_id(+)";
		
		
		if(!gubun2.equals("") && !gubun2.equals("20") && !gubun2.equals("30"))		query += " and a.rent_st='"+gubun2+"'";
		else if(gubun2.equals("20"))												query += " and a.rent_st in ('1', '2', '3', '4', '5','10','9')";
		else if(gubun2.equals("30"))												query += " and a.rent_st in ('6', '7', '8')";

		if(brch_id.equals("S1"))							query += " and a.brch_id in ('S1','K1')";
		if(brch_id.equals("S2"))							query += " and a.brch_id='S2'";
		if(brch_id.equals("B1"))							query += " and a.brch_id in ('B1','N1')";
		if(brch_id.equals("D1"))							query += " and a.brch_id='D1'";

		if(!start_dt.equals("") && !end_dt.equals(""))		query += " and j.sett_dt between '"+start_dt+"' and '"+end_dt+"'";
		else if(!start_dt.equals("") && end_dt.equals(""))	query += " and j.sett_dt like '"+start_dt+"%'";

		if(!car_comp_id.equals(""))							query += " and k.car_comp_id='"+car_comp_id+"'";		
		if(!code.equals(""))								query += " and k.code='"+code+"'";		
				
		if(s_kd.equals("1"))								query += " and upper(f.car_no)||upper(f.first_car_no) like upper('%"+t_wd+"%')\n";		
		if(s_kd.equals("2"))								query += " and decode(a.cust_st, '4',e.user_nm, d.client_nm) like '%"+t_wd+"%'\n";		
		if(s_kd.equals("3"))								query += " and decode(a.cust_st, '4','(주)아마존카', d.firm_nm) like '%"+t_wd+"%'\n";	
		if(s_kd.equals("4"))								query += " and upper(f2.car_no)||upper(f2.first_car_no) like upper('%"+t_wd+"%')\n";				


		if(!sort_gubun.equals(""))							query += " ORDER BY "+sort_gubun+" "+asc;
		else												query += " ORDER BY f.car_nm";

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
			System.out.println("[ResSearchDatabase:getRentEndList_New]"+e);
			System.out.println("[ResSearchDatabase:getRentEndList_New]"+query);
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
	 *	운행일지 리스트
	 */
	public Vector getRentDiaryList(String br_id, String gubun1, String gubun2, String brch_id, String start_dt, String end_dt, String car_comp_id, String code, String s_cc, String s_year, String s_month, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" a.car_mng_id, a.car_no, k.car_nm, d.car_name, a.init_reg_dt, a.dpm, c.colo, c.opt, c.add_opt, d.car_name, b.brch_id, b.mng_id,"+// g.max_dt,
				" e.imgfile1, e.imgfile2, e.imgfile3, e.imgfile4, e.imgfile5,"+
				" b.brch_id, i.use_st, i.rent_st, nvl(j.use_per,0) use_per, k.car_comp_id code,"+
				" decode(i.use_st, '1','예약','2','배차','3','반차','대기') car_stat,"+
				" decode(i.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','장기대기','12','월렌트') rent_st_nm"+
				" from CAR_REG a, CONT b, CAR_ETC c, CAR_NM d, APPRSL e, CAR_MNG k,"+
					" (select a.car_mng_id, a.rent_st, a.use_st, a.brch_id, a.bus_id from RENT_CONT a where a.rent_s_cd = (select max(rent_s_cd) from RENT_CONT where car_mng_id = a.car_mng_id)) i,"+
					" (select car_mng_id, to_char(count(0)/to_number(to_char(last_day(sysdate),'DD'))*100,999) use_per from scd_car where dt like to_char(sysdate,'YYYYMM')||'%' group by car_mng_id) j"+
				" where a.off_ls ='0'"+
					" and a.car_mng_id=b.car_mng_id and nvl(b.use_yn,'Y')='Y' and b.car_st='2'"+
					" and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd"+
					" and c.car_id=d.car_id and c.car_seq=d.car_seq and d.car_comp_id=k.car_comp_id and d.car_cd=k.code"+
					" and a.car_mng_id=e.car_mng_id(+)"+
					" and a.car_mng_id=i.car_mng_id(+)"+
					" and a.car_mng_id=j.car_mng_id(+)";
		


		if(gubun2.equals("1"))					query += " and nvl(i.use_st,'5') not in ('1','2')";
		else if(gubun2.equals("2"))				query += " and i.rent_st='4' and i.use_st in ('1','2')";

		if(brch_id.equals("S1"))				query += " and b.brch_id in ('S1','K1')";
		if(brch_id.equals("S2"))				query += " and b.brch_id='S2'";
		if(brch_id.equals("B1"))				query += " and b.brch_id='B1'";


		if(!car_comp_id.equals(""))				query += " and k.car_comp_id='"+car_comp_id+"'";		
		if(!code.equals(""))					query += " and k.code='"+code+"'";		

		if(s_cc.equals("3"))					query += " and a.dpm > '2000'";
		else if(s_cc.equals("2"))				query += " and a.dpm between '1500' and '2000'";
		else if(s_cc.equals("1"))				query += " and a.dpm < '1500'";
				
		if(s_kd.equals("1"))					query += " and a.car_no||a.first_car_no like upper('%"+t_wd+"%')\n";		

		if(!sort_gubun.equals(""))				query += " ORDER BY "+sort_gubun+" "+asc;
		else									query += " ORDER BY a.car_nm";

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
			System.out.println("[ResSearchDatabase:getRentDiaryList]"+e);
			System.out.println("[ResSearchDatabase:getRentDiaryList]"+query);
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
	 *	보유차현황 리스트
	 */
	public Vector getRentPrepareList(String br_id, String gubun1, String gubun2, String brch_id, String start_dt, String end_dt, String car_comp_id, String code, String s_cc, int s_year, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" a.car_mng_id, a.car_no, k.car_nm, d.car_name, a.init_reg_dt, a.dpm, c.colo, c.opt, c.add_opt, d.car_name, g.max_dt, i.rent_start_dt, i.rent_end_dt, i.deli_plan_dt, i.ret_plan_dt, i.deli_mng_id, i.rent_st, "+
				" e.imgfile1, e.imgfile2, e.imgfile3, e.imgfile4, e.imgfile5,"+
				" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(b.dlv_dt,a.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(b.dlv_dt,a.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as today_dist,"+
				" f.nm as fuel_kd,"+
				" b.brch_id, i.use_st, i.rent_st, nvl(j.use_per,0) use_per, k.car_comp_id as code,"+
				" decode(i.use_st, '1','예약','2','배차','대기') car_stat,"+
				" f2.nm as rent_st_nm,"+
				" decode(a.prepare, '2','매각예정', '3','보류', '4','말소', '예비') prepare, a.park, a.park_cont,"+
				" decode(i.cust_st, '', '조성희', '1',l.client_nm, '4',n.user_nm, m.cust_nm) cust_nm,"+
				" decode(i.cust_st, '', '(주)아마존카', '1',l.firm_nm, '4','(주)아마존카', m.firm_nm) firm_nm"+
				" from CAR_REG a, CONT b, CAR_ETC c, CAR_NM d, APPRSL e, CAR_MNG k, v_tot_dist vt, "+
					" (select car_mng_id, max(dt) max_dt from SCD_CAR group by car_mng_id) g,"+
					" (select a.car_mng_id, a.serv_dt, a.tot_dist from SERVICE a where a.serv_dt||a.serv_id=(select max(serv_dt||serv_id) from service where car_mng_id=a.car_mng_id and tot_dist > 0)) h,"+
					" (select * from RENT_CONT a where a.rent_s_cd = (select max(rent_s_cd) from RENT_CONT where car_mng_id = a.car_mng_id)) i,"+
					" (select car_mng_id, to_char(count(0)/21*100,999) use_per from scd_car where dt between to_char(sysdate-21,'YYYYMMDD') and to_char(sysdate,'YYYYMMDD') group by car_mng_id) j,"+
					" client l, users n, rent_cust m, "+
					" (select * from code where c_st='0039') f, "+
					" (select * from code where c_st='0042') f2 "+
				" where "+ 
					" a.car_mng_id=b.car_mng_id and nvl(b.use_yn,'Y')='Y' and b.car_st='2'"+
					" and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd"+
					" and c.car_id=d.car_id and c.car_seq=d.car_seq and d.car_comp_id=k.car_comp_id and d.car_cd=k.code"+
					" and a.car_mng_id=vt.car_mng_id(+)"+
					" and a.car_mng_id=e.car_mng_id(+)"+
					" and a.car_mng_id=g.car_mng_id(+)"+
					" and a.car_mng_id=h.car_mng_id(+)"+
					" and a.car_mng_id=i.car_mng_id(+)"+
					" and a.car_mng_id=j.car_mng_id(+)"+
					" and i.cust_id=m.cust_id(+) and i.cust_id=l.client_id(+) and i.cust_id=n.user_id(+)"+
					" and a.fuel_kd=f.nm_cd and i.rent_st=f2.nm_cd(+) "+
					" ";
		
		if(gubun2.equals("1"))			query += " and nvl(a.prepare,'1') = '1'";
		else if(gubun2.equals("11"))	query += " and nvl(a.prepare,'1') = '1' and nvl(i.use_st,'5') not in ('2')";
		else if(gubun2.equals("12"))	query += " and nvl(a.prepare,'1') = '1' and nvl(i.use_st,'5') = '1'";
		else if(gubun2.equals("13"))	query += " and nvl(a.prepare,'1') = '1' and nvl(i.use_st,'5') = '2'";
		else if(gubun2.equals("14"))	query += " and nvl(a.prepare,'1') = '1' and nvl(i.use_st,'5') = '3'";
		else if(gubun2.equals("15"))	query += " and nvl(a.prepare,'1') = '1' and nvl(i.use_st,'5') = '2' and i.rent_st='4'";		
		else if(gubun2.equals("2"))		query += " and nvl(a.prepare,'1') = '2'";
		else if(gubun2.equals("3"))		query += " and nvl(a.prepare,'1') = '3'";		
		else if(gubun2.equals("4"))		query += " and (nvl(i.use_st,'5') not in ('2') or i.rent_st in ('6', '7', '8'))";		

		if(brch_id.equals("S1"))		query += " and b.brch_id in ('S1','K1')";
		if(brch_id.equals("S2"))		query += " and b.brch_id='S2'";
		if(brch_id.equals("B1"))		query += " and b.brch_id='B1'";

		if(!car_comp_id.equals(""))		query += " and k.car_comp_id='"+car_comp_id+"'";		
		if(!code.equals(""))			query += " and k.code='"+code+"'";		
					
		if(s_kd.equals("1"))			query += " and upper(a.car_no)||upper(a.first_car_no) like upper('%"+t_wd+"%')\n";		
		if(s_kd.equals("2"))			query += " and a.init_reg_dt like '"+t_wd+"%'\n";		
		if(s_kd.equals("3"))			query += " and f.nm like '%"+t_wd+"%'\n";		

		if(!sort_gubun.equals(""))		query += " ORDER BY decode(a.prepare,'4',1,0), "+sort_gubun+" "+asc+", a.park, a.dpm desc, k.car_nm, d.car_name";
		else							query += " ORDER BY decode(a.prepare,'4',1,0), k.car_nm, d.car_name, a.park";


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
			System.out.println("[ResSearchDatabase:getRentPrepareList]"+e);
			System.out.println("[ResSearchDatabase:getRentPrepareList]"+query);
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
	 *	보유차현황 리스트
	 */
	public Vector getRentPrepareList2(String br_id, String gubun1, String gubun2, String brch_id, String start_dt, String end_dt, String car_comp_id, String code, String s_cc, int s_year, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select /*+ leading(A) index(a CAR_REG_IDX5) */ \n"+  
				" us.mng_nm, decode(nvl(q.mng_br_id,b.brch_id),'S1','본사','K1','본사','S2','본사','B1','부산지점','N1','부산지점','D1','대전지점','G1','대구지점','J1','광주지점','본사') brch_nm, "+
				" a.car_mng_id, a.car_no, a.car_nm, d.car_name, a.init_reg_dt, b.rent_dt, i.rent_start_dt, i.rent_end_dt, i.deli_plan_dt, i.ret_plan_dt, substr(i.ret_plan_dt,1,8) ret_est_dt, p.user_nm as bus_nm, \n"+
				" cd2.nm as fuel_kd, \n"+
				" a.dpm, c.colo||decode(c.in_col,'','','(내장:'||c.in_col||')') as colo, \n"+
				" j.use_dt, nvl(j.use_per,0) use_per, jj.max_use_dt, i.use_st, i.rent_st, i.rent_s_cd, \n"+
				" decode(a.prepare, '2','매각예정', '3','보관', '4','말소', '5','도난', '6','해지', '8','수해', '예비') prepare, \n"+
				" decode(a.park,'6',substr(a.park_cont,1,5),nvl(cd.nm,a.park)) park, a.park_cont, \n"+
				" decode(i.use_st, '1','예약','2','배차',decode(a.prepare,'4','-','5','-','6','-','8','-','대기')) car_stat, \n"+
				" decode(a.prepare,'4','-','5','-','6','-', decode(i.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무지원','6','차량정비','7','차량점검','8','사고수리','11','장기대기','12','월렌트', '-') ) rent_st_nm, \n"+
				" decode(i.cust_st, '', '조성희', '1',l.client_nm, '4',n.user_nm, m.cust_nm) cust_nm, \n"+
				" decode(i.cust_st, '', '아마존카', '1',replace(l.firm_nm,'(주)',''), '4','아마존카', m.firm_nm) firm_nm, \n"+
				" decode(sign(TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.rent_dt, 'YYYYMMDD')) * 30.5)),-1,0,TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.rent_dt, 'YYYYMMDD')) * 30.5)) DAY, \n"+
				" nvl(k.a_cnt,0) a_cnt, \n"+
				" /*네  고*/decode(o.situation,'0','상담중','1','계약진행중','2','계약확정','3','계약연동','') situation, o.memo, o.damdang, o.reg_dt as situation_dt, \n"+
				" decode(a.gps,'Y','장착') gps, a.secondhand, \n"+
				" decode(r.con_f_nm,'아마존카','','피') as con_f_nm, decode(r.age_scp, '1','21', '2','26', '4','24', '5','30', '6','35', '7','43', '8','48', '모든') as age_st, \n"+
				" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(b.dlv_dt,a.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(b.dlv_dt,a.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST, \n"+
				" p2.fee_s_amt+p2.fee_v_amt as fee_amt, round(p2.fee_s_amt/30,-3)*1.1 as day_amt, a.taking_p, \n"+
				" decode(cc.rent_l_cd,'','','해지반납') call_in_st, cc.in_dt as call_in_dt, \n"+
				" ss.sort_code, a.rm_yn, \n"+
				" TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(replace(a.init_reg_dt,'-',''), 'YYYYMMDD'))) use_mon, \n"+
				" decode(a.rm_st,'1','즉시','6','기타','2','대상','3','정비요','4','A급','7','B급','8','C급','5','정비요','9','이동중','미확인') rm_st, a.car_use,  \n"+
				" pa.park_id, pa.area, decode(pa.car_mng_id,'','','P') park_yn,  q.mng_br_id, b.brch_id, a.check_dt,  \n"+
                " sf.amt_01d, TRUNC((round(p2.fee_s_amt/30,-3)*1.1)/sf.amt_01d*100,0) sf_amt_per  , decode(sss.car_mng_id, null, 'N', 'Y' )  sss "+
           	" from   car_reg a, (select * from cont where rent_l_cd not like 'RM%' )  b, car_etc c, car_nm d, client l, users n, rent_cust m, users p, cont_etc q, v_tot_dist vt, \n"+
				"        (select a.* from rent_cont a, (select car_mng_id, max(use_st||nvl(deli_dt,decode(rent_st,'11','0000000000',deli_plan_dt))) deli_dt from rent_cont where use_st in ('1','2') group by car_mng_id) b where a.use_st in ('1','2') and a.car_mng_id=b.car_mng_id and a.use_st||nvl(a.deli_dt,decode(a.rent_st,'11','0000000000',a.deli_plan_dt))=b.deli_dt) i, \n"+
				"        (select car_mng_id, max(dt) use_dt, to_char(count(0)/21*100,999) use_per from (select car_mng_id, dt from scd_car where dt between to_char(sysdate-20,'YYYYMMDD') and to_char(sysdate,'YYYYMMDD') group by car_mng_id, dt) group by car_mng_id) j, \n"+
				"        (select car_mng_id, max(dt) max_use_dt from scd_car group by car_mng_id) jj, \n"+
				"        ( select c_st, code, nm_cd, nm from code where c_st = '0027') cd,  \n"+  //주차장 
				"        ( select c_st, code, nm_cd, nm from code where c_st = '0039') cd2, \n"+
				"        (select car_mng_id, count(0) as a_cnt from accident where accid_st='6' group by car_mng_id) k, \n"+
				"        (select a.*, b.user_nm as damdang from sh_res a, users b where a.use_yn='Y' and a.situation in ('0','2') and a.damdang_id=b.user_id(+)) o, \n"+
				"        (select a.* from insur a, (select car_mng_id, max(ins_st) ins_st from insur where ins_sts='1' group by car_mng_id) b where a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st ) r, \n"+
                //일반대차요금
				"        ( select a.* \n"+
				"          from   estimate_sh a, \n"+
				"                 (select est_ssn, max(est_id) est_id from estimate_sh where est_from ='res_car' and est_fax='Y' and rent_dt like to_char(sysdate,'YYYYMM')||'%' group by est_ssn ) b \n"+
				"          where  a.est_from ='res_car' and a.est_fax='Y' and a.rent_dt like to_char(sysdate,'YYYYMM')||'%' and  a.est_ssn=b.est_ssn and a.est_id=b.est_id) p2, \n"+
				"        ( SELECT a.mng_id, a.car_mng_id, b.user_nm AS mng_nm  FROM cont a, users b  WHERE a.use_yn = 'Y' AND a.mng_id = b.user_id and a.rent_l_cd not like 'RM%' ) us, \n"+
                //차량해지반납
				"        ( select * from car_call_in where in_st='3' and out_dt is null ) cc, \n"+
				//매각대상선별차량
				"        ( select * from sui_sort where reg_dt=to_char(sysdate,'YYYYMMDD') ) ss, \n"+	
				"        PARK_CONDITION pa, "+
				//단기요금
				"	     ( select a.section, a.amt_01D*1.1 AS amt_01d from short_fee_mng a, (select kind, section, fee_st, max(reg_dt) reg_dt from short_fee_mng group by kind, section, fee_st ) c \n"+
             "          where  a.fee_st='2' AND a.kind=c.kind AND a.section=C.SECTION AND a.fee_st=c.fee_st AND a.reg_dt=c.reg_dt ) sf,  \n"+
				//자산양수차 - 20170405 추가 
				" (  select a.car_mng_id from cont a, commi c where  a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd and a.car_gu='2'  and c.agnt_st = '6'   AND a.car_mng_id IS NOT NULL  \n"+
				"		 group by a.car_mng_id )  sss \n"+				
				" where a.off_ls ='0'  \n"+
				" and nvl(b.use_yn,'Y')='Y'  and a.car_mng_id=b.car_mng_id \n"+
				" and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd \n"+
				" and c.car_id=d.car_id and c.car_seq=d.car_seq \n"+
				" and i.cust_id=l.client_id(+) and i.cust_id=n.user_id(+) and i.cust_id=m.cust_id(+) \n"+
				" and a.car_mng_id=i.car_mng_id(+) \n"+
				" and a.car_mng_id=j.car_mng_id(+) \n"+
				" and a.car_mng_id=jj.car_mng_id(+) \n"+
				" and a.car_mng_id=k.car_mng_id(+) \n"+
				" and a.car_mng_id=o.car_mng_id(+) and i.bus_id=p.user_id(+) and a.car_mng_id = us.car_mng_id(+) \n"+
				" and b.rent_mng_id=q.rent_mng_id(+) and b.rent_l_cd=q.rent_l_cd(+) \n"+
			    " and decode(a.prepare,'','1','7','1',a.prepare) not in ('4','5','6','8', '9') \n"+  //9:미회수차량
				" and a.car_mng_id=r.car_mng_id(+) \n"+
				" and a.car_mng_id = vt.car_mng_id(+) \n"+
				" and a.car_mng_id=p2.est_ssn(+) \n"+
				" and b.rent_mng_id=cc.rent_mng_id(+) and b.rent_l_cd=cc.rent_l_cd(+) \n"+				
				" and decode(cc.rent_l_cd,'',b.car_st,'2')='2' \n"+
				" and a.car_mng_id=ss.car_mng_id(+) \n"+
				" and a.car_mng_id=sss.car_mng_id(+) \n"+  // 자산양수차 
				" and a.car_mng_id=pa.car_mng_id(+)"+
				" and a.park = cd.nm_cd(+) \n"+  //주차장 코드 테이블 
				" and a.fuel_kd = cd2.nm_cd \n"+  
				" and d.section=sf.section(+)"+
			    " ";
		
		if(gubun2.equals("1"))			query += " and decode(a.prepare,'','1','7','1',a.prepare) = '1' \n";
		else if(gubun2.equals("11"))	query += " and decode(a.prepare,'','1','7','1',a.prepare) = '1' and nvl(i.use_st,'5') not in ('1','2') \n";
		else if(gubun2.equals("12"))	query += " and decode(a.prepare,'','1','7','1',a.prepare) = '1' and nvl(i.use_st,'5') = '1' \n";
		else if(gubun2.equals("13"))	query += " and decode(a.prepare,'','1','7','1',a.prepare) = '1' and nvl(i.use_st,'5') = '2' \n";
		else if(gubun2.equals("14"))	query += " and decode(a.prepare,'','1','7','1',a.prepare) = '1' and nvl(i.use_st,'5') = '3' \n";
		else if(gubun2.equals("15"))	query += " and decode(a.prepare,'','1','7','1',a.prepare) = '1' and nvl(i.use_st,'5') = '2' and i.rent_st='4' \n";		
		else if(gubun2.equals("2"))		query += " and decode(a.prepare,'','1','7','1',a.prepare) = '2' \n";
		else if(gubun2.equals("3"))		query += " and decode(a.prepare,'','1','7','1',a.prepare) = '3' \n";		
		else if(gubun2.equals("16"))	query += " and decode(a.prepare,'','1','7','1',a.prepare) in ('4','5','6','8') \n";		
		else if(gubun2.equals("4"))		query += " and (nvl(i.use_st,'5') not in ('2') or i.rent_st in ('6', '7', '8')) \n";		
		else if(gubun2.equals("17"))	query += " and nvl(i.use_st,'5') = '2' and i.rent_st in ('4','5') \n ";
		else if(gubun2.equals("18"))	query += " and a.car_use='1' and nvl(i.rent_st,'0') not in ('4') \n ";
		else if(gubun2.equals("19"))	query += " and a.car_use='1' and nvl(i.rent_st,'0') not in ('4') and  NVL(a.rm_st,'0') IN ('3','5','0') \n ";
		else if(gubun2.equals("22"))	query += " and a.car_use='1' and nvl(i.rent_st,'0') not in ('4') and nvl(a.rm_st,'0')='0' \n ";
		else if(gubun2.equals("20"))	query += " and a.secondhand='1' \n ";
		else if(gubun2.equals("21"))	query += " and nvl(i.rent_st,'0') not in ('4','12') \n ";

		if(brch_id.equals("S1"))		query += " and nvl(q.mng_br_id,b.brch_id) in ('S1','K1','S2') \n";
		if(brch_id.equals("B1"))		query += " and nvl(q.mng_br_id,b.brch_id) in ('B1','N1') \n";
		if(brch_id.equals("D1"))		query += " and nvl(q.mng_br_id,b.brch_id)='D1' \n";
		if(brch_id.equals("G1"))		query += " and nvl(q.mng_br_id,b.brch_id)='G1' \n";
		if(brch_id.equals("J1"))		query += " and nvl(q.mng_br_id,b.brch_id)='J1' \n";

		if(!car_comp_id.equals(""))		query += " and d.car_comp_id='"+car_comp_id+"' \n";		
		if(!code.equals(""))			query += " and d.car_cd='"+code+"' \n";		
					
		if(!t_wd.equals("")){
			if(s_kd.equals("1"))			query += " and upper(a.car_no)||upper(a.first_car_no) like upper('%"+t_wd+"%')\n";		
			if(s_kd.equals("2"))			query += " and a.init_reg_dt like '"+t_wd+"%'\n";		
			if(s_kd.equals("3"))			query += " and cd2.nm like '%"+t_wd+"%'\n";		
			if(s_kd.equals("4"))			query += " and a.taking_p >= '"+t_wd+"'\n";		
			if(s_kd.equals("5"))			query += " and us.mng_nm like '%"+t_wd+"%'\n";		
			if(s_kd.equals("6"))			query += " and decode(a.park,'6',substr(a.park_cont,1,5),nvl(cd.nm,a.park))  like '%"+t_wd+"%'\n";		
			if(s_kd.equals("7"))			query += " and decode(a.rm_st,'1','즉시','6','기타','2','대상','3','정비요','4','확인함','5','점검요','9','이동중','-') like '%"+t_wd+"%'\n";		
		}
		
		if(sort_gubun.equals("1")){
			query += " order by decode(nvl(a.prepare,'1'),'2','2','5','3','4','4','8','5','1'), \n"+
					          " decode(i.rent_st,'4',1,0), decode(nvl(q.mng_br_id,b.brch_id),'S1',1,'K1',1,'S2',2,'I1',2,'B1',3,'N1',3,'G1',4,'D1',5,'J1',6), \n"+
							  " decode(i.use_st,'',decode(o.situation,'0',1, '1',2, '2',3, 0),'1','4','2','5','6'), \n"+
							  " decode(i.use_st,'1',decode(o.situation,'0',0.02,'2',0.03,0.01),'2',decode(i.rent_st,'6','0.1','7','0.2','8','0.3',i.rent_st),'9'), \n"+
							  " decode(o.situation,'0',1, '1',2, '2',3, 0), \n"+	
							  " to_number(a.dpm) desc, a.car_nm, a.init_reg_dt desc, replace(a.park,' ','')"; 
		}
		if(sort_gubun.equals("2"))		query += " order by a.car_no "+asc; 
		if(sort_gubun.equals("3"))		query += " order by decode(nvl(a.prepare,'1'),'2','2','5','3','4','4','8','5','1'), a.car_nm||d.car_name "+asc;
		if(sort_gubun.equals("4"))		query += " order by decode(nvl(a.prepare,'1'),'2','2','5','3','4','4','8','5','1'), a.init_reg_dt "+asc;
		if(sort_gubun.equals("5"))		query += " order by decode(nvl(a.prepare,'1'),'2','2','5','3','4','4','8','5','1'), a.dpm "+asc;
		if(sort_gubun.equals("6"))		query += " order by decode(nvl(a.prepare,'1'),'2','2','5','3','4','4','8','5','1'), b.rent_dt "+asc;


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
			System.out.println("[ResSearchDatabase:getRentPrepareList2]"+e);
			System.out.println("[ResSearchDatabase:getRentPrepareList2]"+query);
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
	 *	보유차현황 리스트2  --  현재 보유차 현황  
	 */
	public Vector getRentPrepareList2(String br_id, String gubun1, String gubun2, String brch_id, String start_dt, String end_dt, String car_comp_id, String code, String s_cc, int s_year, String s_kd, String t_wd, String sort_gubun, String asc,String cjgubun)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select /*+ RULE */ \n"+  
				" decode(nvl(q.mng_br_id,b.brch_id),'S1','본사','K1','본사','S2','본사','B1','부산지점','N1','부산지점','D1','대전지점','G1','대구지점','J1','광주지점','본사') brch_nm, "+
				" a.car_mng_id, a.car_no, a.car_nm, d.car_name, a.init_reg_dt, b.rent_dt, i.rent_start_dt, i.rent_end_dt, i.deli_plan_dt, i.ret_plan_dt, substr(i.ret_plan_dt,1,8) ret_est_dt, p.user_nm as bus_nm, \n"+
				" cd2.nm as fuel_kd, \n"+
				" a.dpm, c.colo||decode(c.in_col,'','','(내장:'||c.in_col||')') as colo, DECODE(r.com_emp_yn,'Y','가입','N','미가입','') AS com_emp_yn, \n"+
			//	" j.use_dt, nvl(j.use_per,0) use_per, jj.max_use_dt, i.use_st, i.rent_st, i.rent_s_cd, \n"+
				" j.use_dt, nvl(j.use_per,0) use_per, i.use_st, i.rent_st, i.rent_s_cd, \n"+
				" decode(a.prepare, '2','매각예정', '3','보류', '4','말소', '5','도난', '6','해지', '8','수해', '예비') prepare, \n"+
				" decode(a.park,'6',substr(a.park_cont,1,5),nvl(cd.nm,a.park)) park, a.park_cont, \n"+		
				" decode(i.use_st, '1','예약','2','배차',decode(a.prepare,'4','-','5','-','6','-','8','-','대기')) car_stat, \n"+
				" decode(a.prepare,'4','-','5','-','6','-', decode(i.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무지원','6','차량정비','7','차량점검','8','사고수리','11','장기대기','12','월렌트', '-') ) rent_st_nm, \n"+
				" decode(i.cust_st, '', '조성희', '1',l.client_nm, '4',n.user_nm, m.cust_nm) cust_nm, \n"+
				" decode(i.cust_st, '', '아마존카', '1',replace(l.firm_nm,'(주)',''), '4','아마존카', m.firm_nm) firm_nm, \n"+
				" decode(sign(TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.rent_dt, 'YYYYMMDD')) * 30.5)),-1,0,TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.rent_dt, 'YYYYMMDD')) * 30.5)) DAY, \n"+
				" nvl(k.a_cnt,0) a_cnt, \n"+
				" /*네  고*/decode(o.situation,'0','상담중','1','계약진행중','2','계약확정','3','계약연동','') situation, o.memo, o.damdang, o.reg_dt as situation_dt, \n"+
				" decode(a.gps,'Y','장착') gps, a.secondhand, \n"+
				" decode(r.con_f_nm,'아마존카','','피') as con_f_nm, decode(r.age_scp, '1','21', '2','26', '4','24', '5','30', '6','35', '7','43', '8','48', '모든') as age_st, \n"+
				" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(b.dlv_dt,a.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(b.dlv_dt,a.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST, \n"+
				" p2.fee_s_amt+p2.fee_v_amt as fee_amt, round(p2.fee_s_amt/30,-3)*1.1 as day_amt, a.taking_p, \n"+
				" decode(cc.rent_l_cd,'','','해지반납') call_in_st, cc.in_dt as call_in_dt, \n"+
				" ss.sort_code, ss.ex_n_h, ss.ex_n_h_dt, a.rm_yn,  \n"+
				" TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(replace(a.init_reg_dt,'-',''), 'YYYYMMDD'))) use_mon, \n"+
				" decode(a.rm_st,'1','즉시','6','기타','2','대상','3','정비요','4','A급','7','B급','8','C급','5','정비요','9','이동중','미확인') rm_st, a.car_use,  \n"+
				" pa.park_id, pa.area, decode(pa.car_mng_id,'','','P') park_yn,  q.mng_br_id, b.brch_id, a.check_dt,  \n"+
                " sf.amt_01d, TRUNC((round(p2.fee_s_amt/30,-3)*1.1)/sf.amt_01d*100,0) sf_amt_per , decode(sss.car_mng_id, null , '', 'Y' ) sss, nvl(h2.pic_cnt,0) as pic_cnt, h2.pic_reg_dt, b.mng_id   \n"+
				" from   car_reg a, cont b, car_etc c, car_nm d, client l, users n, rent_cust m, users p, cont_etc q, v_tot_dist vt, \n"+
				"        ( select c_st, code, nm_cd, nm from code where c_st = '0027') cd,  \n"+
				"        ( select c_st, code, nm_cd, nm from code where c_st = '0039') cd2,  \n"+
				"        (select a.* from rent_cont a, (select car_mng_id, max(use_st||nvl(deli_dt,decode(rent_st,'11','0000000000',deli_plan_dt))) deli_dt from rent_cont where use_st in ('1','2') group by car_mng_id) b where a.use_st in ('1','2') and a.car_mng_id=b.car_mng_id and a.use_st||nvl(a.deli_dt,decode(a.rent_st,'11','0000000000',a.deli_plan_dt))=b.deli_dt) i, \n"+
				"        (select car_mng_id, max(dt) use_dt, to_char(count(0)/21*100,999) use_per from (select car_mng_id, dt from scd_car where dt between to_char(sysdate-20,'YYYYMMDD') and to_char(sysdate,'YYYYMMDD') group by car_mng_id, dt) group by car_mng_id) j, \n"+
				"        (select car_mng_id, count(0) as a_cnt from accident where accid_st='6' group by car_mng_id) k, \n"+
				"        (select a.*, b.user_nm as damdang from sh_res a, users b where a.use_yn='Y' and a.situation in ('0','2') and a.damdang_id=b.user_id(+)) o, \n"+
				"        (select a.* from insur a, (select car_mng_id, max(ins_st) ins_st from insur where ins_sts='1' group by car_mng_id) b where a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st ) r, \n"+
                //일반대차요금
				"        ( select a.* \n"+
				"          from   estimate_sh a, \n"+
				"                 (select est_ssn, max(est_id) est_id from estimate_sh where est_from ='res_car' and est_fax='Y' and rent_dt like to_char(sysdate,'YYYYMM')||'%' group by est_ssn ) b \n"+
				"          where  a.est_from ='res_car' and a.est_fax='Y' and a.rent_dt like to_char(sysdate,'YYYYMM')||'%' and  a.est_ssn=b.est_ssn and a.est_id=b.est_id) p2, \n"+
                //차량해지반납
				"        ( select * from car_call_in where in_st='3' and out_dt is null ) cc, \n"+
				//매각대상선별차량
				"        ( select * from sui_sort where reg_dt=to_char(sysdate,'YYYYMMDD') ) ss, \n"+	
				"        PARK_CONDITION pa, "+
				//단기요금
				"	     ( select a.section, a.amt_01D*1.1 AS amt_01d from short_fee_mng a, (select kind, section, fee_st, max(reg_dt) reg_dt from short_fee_mng group by kind, section, fee_st ) c \n"+
                "          where  a.fee_st='2' AND a.kind=c.kind AND a.section=C.SECTION AND a.fee_st=c.fee_st AND a.reg_dt=c.reg_dt ) sf , \n"+
             	//자산양수차 - 20170405 추가 
				" (  select a.car_mng_id from cont a, commi c where  a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd and a.car_gu='2'  and c.agnt_st = '6'   AND a.car_mng_id IS NOT NULL  \n"+
				"		 group by a.car_mng_id )  sss ,  \n"+		
				//사진 
				" (select SUBSTR(content_seq,1,6) car_mng_id, count(0) pic_cnt, TO_CHAR(MAX(reg_date),'YYYYMMDD') pic_reg_dt from ACAR_ATTACH_FILE where ISDELETED='N' and content_code='APPRSL' group by SUBSTR(content_seq,1,6)) h2 \n"+
				" where a.off_ls ='0'  \n"+		
				" and a.car_mng_id=b.car_mng_id and nvl(b.use_yn,'Y')='Y'  \n"+
				" and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd \n"+
				" and c.car_id=d.car_id and c.car_seq=d.car_seq \n"+
				" and i.cust_id=l.client_id(+) and i.cust_id=n.user_id(+) and i.cust_id=m.cust_id(+) \n"+
				" and a.car_mng_id=i.car_mng_id(+) \n"+
				" and a.car_mng_id=j.car_mng_id(+) \n"+
				" and a.car_mng_id=k.car_mng_id(+) \n"+
				" and a.car_mng_id=o.car_mng_id(+) and i.bus_id=p.user_id(+) \n"+
				" and b.rent_mng_id=q.rent_mng_id(+) and b.rent_l_cd=q.rent_l_cd(+) \n"+
			    " and decode(a.prepare,'','1','7','1',a.prepare) not in ('4','5','6','8', '9') \n"+  //9:미회수차량
				" and a.car_mng_id=r.car_mng_id(+) \n"+
				" and a.car_mng_id = vt.car_mng_id(+) \n"+
				" and a.car_mng_id=p2.est_ssn(+) \n"+
				" and b.rent_mng_id=cc.rent_mng_id(+) and b.rent_l_cd=cc.rent_l_cd(+) \n"+				
				" and decode(cc.rent_l_cd,'',b.car_st,'2')='2' \n"+
				" and a.car_mng_id=ss.car_mng_id(+) \n"+
				" and a.car_mng_id=sss.car_mng_id(+) \n"+
				" and a.car_mng_id=h2.car_mng_id(+) \n"+
				" and a.car_mng_id=pa.car_mng_id(+) \n"+
				" and a.park = cd.nm_cd(+) \n"+  //주차장 코드 테이블 
				" and a.fuel_kd = cd2.nm_cd \n"+  
				" and d.section=sf.section(+)"+
			    " ";
		
		if(gubun2.equals("1"))			query += " and decode(a.prepare,'','1','7','1',a.prepare) = '1' \n";
		else if(gubun2.equals("11"))	query += " and decode(a.prepare,'','1','7','1',a.prepare) = '1' and nvl(i.use_st,'5') not in ('1','2') \n";
		else if(gubun2.equals("12"))	query += " and decode(a.prepare,'','1','7','1',a.prepare) = '1' and nvl(i.use_st,'5') = '1' \n";
		else if(gubun2.equals("13"))	query += " and decode(a.prepare,'','1','7','1',a.prepare) = '1' and nvl(i.use_st,'5') = '2' \n";
		else if(gubun2.equals("14"))	query += " and decode(a.prepare,'','1','7','1',a.prepare) = '1' and nvl(i.use_st,'5') = '3' \n";
		else if(gubun2.equals("15"))	query += " and decode(a.prepare,'','1','7','1',a.prepare) = '1' and nvl(i.use_st,'5') = '2' and i.rent_st='4' \n";		
		else if(gubun2.equals("2"))		query += " and decode(a.prepare,'','1','7','1',a.prepare) = '2' \n";
		else if(gubun2.equals("3"))		query += " and decode(a.prepare,'','1','7','1',a.prepare) = '3' \n";		
		else if(gubun2.equals("16"))	query += " and decode(a.prepare,'','1','7','1',a.prepare) in ('4','5','6','8') \n";		
		else if(gubun2.equals("4"))		query += " and (nvl(i.use_st,'5') not in ('2') or i.rent_st in ('6', '7', '8')) \n";		
		else if(gubun2.equals("17"))	query += " and nvl(i.use_st,'5') = '2' and i.rent_st in ('4','5') \n ";
		else if(gubun2.equals("18"))	query += " and a.car_use='1' and nvl(i.rent_st,'0') not in ('4') \n ";
		else if(gubun2.equals("19"))	query += " and a.car_use='1' and nvl(i.rent_st,'0') not in ('4') and  NVL(a.rm_st,'0') IN ('3','5','0') \n ";
		else if(gubun2.equals("22"))	query += " and a.car_use='1' and nvl(i.rent_st,'0') not in ('4') and nvl(a.rm_st,'0')='0' \n ";
		else if(gubun2.equals("20"))	query += " and a.secondhand='1' \n ";
		else if(gubun2.equals("21"))	query += " and nvl(i.rent_st,'0') not in ('4','12') \n ";

		if(brch_id.equals("S1"))		query += " and nvl(q.mng_br_id,b.brch_id) in ('S1','K1','S2') \n";
		if(brch_id.equals("B1"))		query += " and nvl(q.mng_br_id,b.brch_id) in ('B1','N1') \n";
		if(brch_id.equals("D1"))		query += " and nvl(q.mng_br_id,b.brch_id)='D1' \n";
		if(brch_id.equals("G1"))		query += " and nvl(q.mng_br_id,b.brch_id)='G1' \n";
		if(brch_id.equals("J1"))		query += " and nvl(q.mng_br_id,b.brch_id)='J1' \n";

		if(!car_comp_id.equals(""))		query += " and d.car_comp_id='"+car_comp_id+"' \n";		
		if(!code.equals(""))			query += " and d.car_cd='"+code+"' \n";		
					
		if(!t_wd.equals("")){
			if(s_kd.equals("1"))			query += " and upper(a.car_no)||upper(a.first_car_no) like upper('%"+t_wd+"%')\n";		
			if(s_kd.equals("2"))			query += " and a.init_reg_dt like '"+t_wd+"%'\n";		
			if(s_kd.equals("6"))			query += " and decode(a.park,'6',substr(a.park_cont,1,5),nvl(cd.nm,a.park))  like '%"+t_wd+"%'\n";		
			if(s_kd.equals("7"))			query += " and decode(a.rm_st,'1','즉시','6','기타','2','대상','3','정비요','4','확인함','5','점검요','9','이동중','-') like '%"+t_wd+"%'\n";		
		}
		if(cjgubun.equals("300")) query += " and d.s_st='300' \n";
		else if(cjgubun.equals("301")) query += " and d.s_st='301' \n";
		else if(cjgubun.equals("302")) query += " and d.s_st='302' \n";
		else if(cjgubun.equals("100")) query += " and d.s_st in ('100','101','409') \n";
		else if(cjgubun.equals("112")) query += " and d.s_st in ('102','112') \n";
		else if(cjgubun.equals("103")) query += " and d.s_st='103' \n";
		else if(cjgubun.equals("104")) query += " and decode(d.s_st, '105','104', decode(substr(d.s_st,1,1),'9','104', d.s_st)) = '104' \n";
		else if(cjgubun.equals("401")) query += " and decode(substr(d.s_st,1,1),'4','401','5','401','6','401','7') = '401' \n";
		else if(cjgubun.equals("701")) query += " and decode(substr(d.s_st,1,1),'7','701') = '701' \n";
		else if(cjgubun.equals("801")) query += " and decode(substr(d.s_st,1,1),'8','801') = '801' \n";
		
		if(sort_gubun.equals("1")){
			query += " order by decode(nvl(a.prepare,'1'),'2','2','5','3','4','4','8','5','1'), \n"+
				          " decode(i.rent_st,'4',1,0), decode(nvl(q.mng_br_id,b.brch_id),'S1',1,'K1',1,'S2',2,'I1',2,'B1',3,'N1',3,'G1',4,'D1',5,'J1',6), \n"+
						  " decode(i.use_st,'',decode(o.situation,'0',1, '1',2, '2',3, 0),'1','4','2','5','6'), \n"+
						  " decode(i.use_st,'1',decode(o.situation,'0',0.02,'2',0.03,0.01),'2',decode(i.rent_st,'6','0.1','7','0.2','8','0.3',i.rent_st),'9'), \n"+
						  " decode(o.situation,'0',1, '1',2, '2',3, 0), \n"+	
						  " to_number(a.dpm) desc, a.car_nm, a.park";
					  //" to_number(a.dpm) desc, a.car_nm, replace(a.park,' ','')";
		}
		if(sort_gubun.equals("2"))		query += " order by a.car_no "+asc; 
		if(sort_gubun.equals("3"))		query += " order by decode(nvl(a.prepare,'1'),'2','2','5','3','4','4','8','5','1'), a.car_nm||d.car_name "+asc;
		if(sort_gubun.equals("4"))		query += " order by decode(nvl(a.prepare,'1'),'2','2','5','3','4','4','8','5','1'), a.init_reg_dt "+asc;
		if(sort_gubun.equals("5"))		query += " order by decode(nvl(a.prepare,'1'),'2','2','5','3','4','4','8','5','1'), a.dpm "+asc;
		if(sort_gubun.equals("6"))		query += " order by decode(nvl(a.prepare,'1'),'2','2','5','3','4','4','8','5','1'), b.rent_dt "+asc;


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
	    	
	   // 	System.out.println("[ResSearchDatabase:getRentPrepareList2]"+query);
	    	
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
			System.out.println("[ResSearchDatabase:getRentPrepareList2]"+e);
			System.out.println("[ResSearchDatabase:getRentPrepareList2]"+query);
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
	 *	보유차현황 통계
	 */
	public Vector getStatCar(String br_id, String brch_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
	
		query = " select nvl(a.prepare,'1') prepare, nvl(i.rent_st,'0') rent_st, count(0) su"+
				" from CAR_REG a, (select * from CONT where rent_l_cd not like 'RM%' )  b, CAR_ETC c, CAR_NM d, APPRSL e, CAR_MNG k,"+
					" (select car_mng_id, max(dt) max_dt from SCD_CAR group by car_mng_id) g,"+
					" (select a.car_mng_id, a.serv_dt, a.tot_dist from SERVICE a where a.serv_dt||a.serv_id=(select max(serv_dt||serv_id) from service where car_mng_id=a.car_mng_id and tot_dist > 0)) h,"+
					" (select a.car_mng_id, a.rent_st, a.use_st from RENT_CONT a where a.rent_s_cd = (select max(rent_s_cd) from RENT_CONT where car_mng_id = a.car_mng_id)) i,"+
					" (select car_mng_id, to_char(count(0)/to_number(to_char(last_day(sysdate),'DD'))*100,999) use_per from scd_car where dt like to_char(sysdate,'YYYYMM')||'%' group by car_mng_id) j"+
				" where a.off_ls ='0'"+
					" and a.car_mng_id=b.car_mng_id and nvl(b.use_yn,'Y')='Y' and b.car_st='2'"+
					" and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd"+
					" and c.car_id=d.car_id and c.car_seq=d.car_seq and d.car_comp_id=k.car_comp_id and d.car_cd=k.code"+
					" and a.car_mng_id=e.car_mng_id(+)"+
					" and a.car_mng_id=g.car_mng_id(+)"+
					" and a.car_mng_id=h.car_mng_id(+)"+
					" and a.car_mng_id=i.car_mng_id(+)"+
					" and a.car_mng_id=j.car_mng_id(+)";

		if(brch_id.equals("S1"))							query += " and b.brch_id in ('S1','K1')";
		if(brch_id.equals("S2"))							query += " and b.brch_id='S2'";


		query += " group by a.prepare, i.rent_st order by a.prepare, i.rent_st";

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
			System.out.println("[ResSearchDatabase:getStatCar]"+e);
			System.out.println("[ResSearchDatabase:getStatCar]"+query);
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
	 *	보유차현황 통계수
	 */
	public int getStatCar(String br_id, String brch_id, int gubun)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		String query = "";

		query = " select count(0)"+
				" from CAR_REG a, ( select * from CONT where rent_l_cd not like 'RM%' )  b, CAR_ETC c, CAR_NM d, APPRSL e, CAR_MNG k,"+
					" (select car_mng_id, max(dt) max_dt from SCD_CAR group by car_mng_id) g,"+
					" (select a.car_mng_id, a.serv_dt, a.tot_dist from SERVICE a where a.serv_dt||a.serv_id=(select max(serv_dt||serv_id) from service where car_mng_id=a.car_mng_id and tot_dist > 0)) h,"+
					" (select a.car_mng_id, a.rent_st, a.use_st from RENT_CONT a where a.rent_s_cd = (select max(rent_s_cd) from RENT_CONT where car_mng_id = a.car_mng_id)) i,"+
					" (select car_mng_id, to_char(count(0)/to_number(to_char(last_day(sysdate),'DD'))*100,999) use_per from scd_car where dt like to_char(sysdate,'YYYYMM')||'%' group by car_mng_id) j"+
				" where a.off_ls ='0'"+
					" and a.car_mng_id=b.car_mng_id and nvl(b.use_yn,'Y')='Y' and b.car_st='2'"+
					" and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd"+
					" and c.car_id=d.car_id and c.car_seq=d.car_seq and d.car_comp_id=k.car_comp_id and d.car_cd=k.code"+
					" and a.car_mng_id=e.car_mng_id(+)"+
					" and a.car_mng_id=g.car_mng_id(+)"+
					" and a.car_mng_id=h.car_mng_id(+)"+
					" and a.car_mng_id=i.car_mng_id(+)"+
					" and a.car_mng_id=j.car_mng_id(+)";
		
		if(gubun == 0)					query += " and i.use_st='2' and i.rent_st='1'";
		else if(gubun == 1)				query += " and i.use_st='2' and i.rent_st='9'";
		else if(gubun == 2)				query += " and i.use_st='2' and i.rent_st='10'";
		else if(gubun == 3)				query += " and i.use_st='2' and i.rent_st='2'";
		else if(gubun == 4)				query += " and i.use_st='2' and i.rent_st='3'";
		else if(gubun == 5)				query += " and i.use_st='2' and i.rent_st in ('4','5')";	
		else if(gubun == 6)				query += " and i.use_st='2' and i.rent_st in ('6','7')";
		else if(gubun == 7)				query += " and i.use_st='2' and i.rent_st='8'";	
		else if(gubun == 8)				query += " and i.use_st='1'";//예약
		else if(gubun == 9)				query += " and nvl(i.use_st,'5') not in ('1','2') and nvl(a.prepare,'1') not in ('4','2')";//대기
		else if(gubun == 10)			query += " and nvl(a.prepare,'1') = '4'";//말소	
		else if(gubun == 11)			query += " and nvl(i.use_st,'5') not in ('1','2') and nvl(a.prepare,'1') = '2'";//매각예정

		if(brch_id.equals("S1"))		query += " and b.brch_id in ('S1','K1')";
		if(brch_id.equals("S2"))		query += " and b.brch_id='S2'";
		if(brch_id.equals("B1"))		query += " and b.brch_id='B1'";


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{				
				count = rs.getInt(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:getStatCar(String br_id, String brch_id, int gubun)]"+e);
			System.out.println("[ResSearchDatabase:getStatCar]"+query);
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

	/**
	 *	보유차현황 통계
	 */
	public int getStatCar2(String br_id, String brch_id, int gubun)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		String query = "";

		query = " select count(0)"+
				" from CAR_REG a, CONT b,"+
					" (select a.car_mng_id, a.rent_st, a.use_st from RENT_CONT a where a.rent_s_cd = (select max(rent_s_cd) from RENT_CONT where car_mng_id = a.car_mng_id)) i"+
				" where a.off_ls ='0'"+
					" and a.car_mng_id=b.car_mng_id and nvl(b.use_yn,'Y')='Y' and b.car_st='2'"+
					" and a.car_mng_id=i.car_mng_id(+)";
		
		if(gubun == 0)						query += " and i.use_st='2' and i.rent_st='1'";
		else if(gubun == 1)					query += " and i.use_st='2' and i.rent_st='9'";
		else if(gubun == 2)					query += " and i.use_st='2' and i.rent_st='10'";
		else if(gubun == 3)					query += " and i.use_st='2' and i.rent_st='2'";
		else if(gubun == 4)					query += " and i.use_st='2' and i.rent_st='3'";
		else if(gubun == 5)					query += " and i.use_st='2' and i.rent_st in ('4','5')";	
		else if(gubun == 6)					query += " and i.use_st='2' and i.rent_st in ('6','7')";
		else if(gubun == 7)					query += " and i.use_st='2' and i.rent_st='8'";	
		else if(gubun == 8)					query += " and i.use_st='1'";//예약
		else if(gubun == 9)					query += " and nvl(i.use_st,'5') not in ('1','2') and nvl(a.prepare,'1') not in ('4','2')";//대기
		else if(gubun == 10)				query += " and nvl(a.prepare,'1') = '4'";//말소	
		else if(gubun == 11)				query += " and nvl(i.use_st,'5') not in ('1','2') and nvl(a.prepare,'1') = '2'";//매각예정

		if(brch_id.equals("S1"))			query += " and b.brch_id in ('S1','K1')";
		if(brch_id.equals("S2"))			query += " and b.brch_id='S2'";
		if(brch_id.equals("B1"))			query += " and b.brch_id='B1'";


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{				
				count = rs.getInt(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:getStatCar2]"+e);
			System.out.println("[ResSearchDatabase:getStatCar2]"+query);
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
	
	/**
	 *	보유차현황 통계
	 */
	public Hashtable getStatCar3(String br_id, String brch_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
	
		query = " select"+

				"        count(decode(c.use_st,'2',decode(c.rent_st,'1', a.car_mng_id))) cnt0,"+
				"        count(decode(c.use_st,'2',decode(c.rent_st,'9', a.car_mng_id))) cnt1,"+
				"        count(decode(c.use_st,'2',decode(c.rent_st,'10',a.car_mng_id))) cnt2,"+
				"        count(decode(c.use_st,'2',decode(c.rent_st,'2', a.car_mng_id))) cnt3,"+
				"        count(decode(c.use_st,'2',decode(c.rent_st,'3', a.car_mng_id))) cnt4,"+
				"        count(decode(c.use_st,'2',decode(c.rent_st,'4', a.car_mng_id,'5',a.car_mng_id))) cnt5,"+
				"        count(decode(c.use_st,'2',decode(c.rent_st,'6', a.car_mng_id,'7',a.car_mng_id))) cnt6,"+
				"        count(decode(c.use_st,'2',decode(c.rent_st,'8', a.car_mng_id))) cnt7,"+
				"        count(decode(c.use_st,'1',a.car_mng_id)) cnt8,"+
				"        count(decode(c.use_st,'', decode(nvl(a.prepare,'1'),'1',a.car_mng_id,'7',a.car_mng_id))) cnt9,"+
				"        count(decode(c.use_st,'', decode(a.prepare,'4', a.car_mng_id,'5',a.car_mng_id,'6',a.car_mng_id,'8',a.car_mng_id))) cnt10,"+
				"        count(decode(c.use_st,'', decode(a.prepare,'2', a.car_mng_id))) cnt11,"+
				"        count(decode(c.use_st,'2',decode(c.rent_st,'12', a.car_mng_id))) cnt12,"+
				//계약확정
				"        count(decode(c.use_st,'2',decode(c.rent_st,'1', decode(o.situation,'2',a.car_mng_id)))) cnt1_0,"+
				"        count(decode(c.use_st,'2',decode(c.rent_st,'9', decode(o.situation,'2',a.car_mng_id)))) cnt1_1,"+
				"        count(decode(c.use_st,'2',decode(c.rent_st,'10',decode(o.situation,'2',a.car_mng_id)))) cnt1_2,"+
				"        count(decode(c.use_st,'2',decode(c.rent_st,'2', decode(o.situation,'2',a.car_mng_id)))) cnt1_3,"+
				"        count(decode(c.use_st,'2',decode(c.rent_st,'3', decode(o.situation,'2',a.car_mng_id)))) cnt1_4,"+
				"        count(decode(c.use_st,'2',decode(c.rent_st,'4', decode(o.situation,'2',a.car_mng_id),'5',decode(o.situation,'2',a.car_mng_id)))) cnt1_5,"+
				"        count(decode(c.use_st,'2',decode(c.rent_st,'6', decode(o.situation,'2',a.car_mng_id),'7',decode(o.situation,'2',a.car_mng_id)))) cnt1_6,"+
				"        count(decode(c.use_st,'2',decode(c.rent_st,'8', decode(o.situation,'2',a.car_mng_id)))) cnt1_7,"+
				"        count(decode(c.use_st,'1',decode(o.situation,'2',a.car_mng_id))) cnt1_8,"+
				"        count(decode(c.use_st,'', decode(nvl(a.prepare,'1'),'1',decode(o.situation,'2',a.car_mng_id),'7',decode(o.situation,'2',a.car_mng_id)))) cnt1_9,"+
				"        count(decode(c.use_st,'', decode(a.prepare,'2', decode(o.situation,'2',a.car_mng_id)))) cnt1_11,"+
				"        count(decode(c.use_st,'2',decode(c.rent_st,'12', decode(o.situation,'2',a.car_mng_id)))) cnt1_12,"+
				//상담중
				"        count(decode(c.use_st,'2',decode(c.rent_st,'1', decode(o.situation,'0',a.car_mng_id)))) cnt2_0,"+
				"        count(decode(c.use_st,'2',decode(c.rent_st,'9', decode(o.situation,'0',a.car_mng_id)))) cnt2_1,"+
				"        count(decode(c.use_st,'2',decode(c.rent_st,'10',decode(o.situation,'0',a.car_mng_id)))) cnt2_2,"+
				"        count(decode(c.use_st,'2',decode(c.rent_st,'2', decode(o.situation,'0',a.car_mng_id)))) cnt2_3,"+
				"        count(decode(c.use_st,'2',decode(c.rent_st,'3', decode(o.situation,'0',a.car_mng_id)))) cnt2_4,"+
				"        count(decode(c.use_st,'2',decode(c.rent_st,'4', decode(o.situation,'0',a.car_mng_id),'5',decode(o.situation,'0',a.car_mng_id)))) cnt2_5,"+
				"        count(decode(c.use_st,'2',decode(c.rent_st,'6', decode(o.situation,'0',a.car_mng_id),'7',decode(o.situation,'0',a.car_mng_id)))) cnt2_6,"+
				"        count(decode(c.use_st,'2',decode(c.rent_st,'8', decode(o.situation,'0',a.car_mng_id)))) cnt2_7,"+
				"        count(decode(c.use_st,'1',decode(o.situation,'0',a.car_mng_id))) cnt2_8,"+
				"        count(decode(c.use_st,'', decode(nvl(a.prepare,'1'),'1',decode(o.situation,'0',a.car_mng_id),'7',decode(o.situation,'0',a.car_mng_id)))) cnt2_9,"+
				"        count(decode(c.use_st,'', decode(a.prepare,'2', decode(o.situation,'0',a.car_mng_id)))) cnt2_11,"+
				"        count(decode(c.use_st,'2',decode(c.rent_st,'12', decode(o.situation,'0',a.car_mng_id)))) cnt2_12 "+

				" from   car_reg a, cont b, "+
				//c 마지막단기
				"        (select a.* from rent_cont a, (select car_mng_id, max(nvl(deli_dt,decode(rent_st,'11','0000000000',deli_plan_dt))) deli_dt from rent_cont where use_st in ('1','2') group by car_mng_id) b where a.use_st in ('1','2') and a.car_mng_id=b.car_mng_id and nvl(a.deli_dt,decode(a.rent_st,'11','0000000000',a.deli_plan_dt))=b.deli_dt) c, "+
                //cc 차량해지반납
				"        ( select * from car_call_in where in_st='3' and out_dt is null ) cc, \n"+
				//o 재리스상담
				"        ( select a.*, b.user_nm as damdang from sh_res a, users b where a.use_yn='Y' and a.situation in ('0','2') and a.damdang_id=b.user_id(+) ) o \n"+
				" where  a.off_ls ='0' and a.car_mng_id=b.car_mng_id and nvl(b.use_yn,'Y')='Y' "+
				"        and a.car_mng_id=c.car_mng_id(+)"+
 				"        and decode(a.prepare,'','1','7','1',a.prepare) not in ('4','5','6','8')"+
				"        and b.rent_mng_id=cc.rent_mng_id(+) and b.rent_l_cd=cc.rent_l_cd(+) \n"+				
				"        and decode(cc.rent_l_cd,'',b.car_st,'2')='2' \n"+
				"        and a.car_mng_id=o.car_mng_id(+)"+
			    " ";

		if(brch_id.equals("S1"))		query += " and b.brch_id in ('S1','K1')";
		if(brch_id.equals("S2"))		query += " and b.brch_id='S2'";
		if(brch_id.equals("B1"))		query += " and b.brch_id in ('B1','N1')";
		if(brch_id.equals("D1"))		query += " and b.brch_id='D1'";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:getStatCar3]"+e);
			System.out.println("[ResSearchDatabase:getStatCar3]"+query);
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
	 *	보유차현황 통계 확장
	 */
	public Hashtable getStatCar3(String br_id, String gubun1, String gubun2, String brch_id, String start_dt, String end_dt, String car_comp_id, String code, String s_cc, int s_year, String s_kd, String t_wd, String sort_gubun, String asc, String cjgubun)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
	
		query = " select   /*+ RULE */  "+

				"        count(decode(i.use_st,'2',decode(i.rent_st,'1', a.car_mng_id))) cnt0,"+
				"        count(decode(i.use_st,'2',decode(i.rent_st,'9', a.car_mng_id))) cnt1,"+
				"        count(decode(i.use_st,'2',decode(i.rent_st,'10',a.car_mng_id))) cnt2,"+
				"        count(decode(i.use_st,'2',decode(i.rent_st,'2', a.car_mng_id))) cnt3,"+
				"        count(decode(i.use_st,'2',decode(i.rent_st,'3', a.car_mng_id))) cnt4,"+
				"        count(decode(i.use_st,'2',decode(i.rent_st,'4', a.car_mng_id,'5',a.car_mng_id))) cnt5,"+
				"        count(decode(i.use_st,'2',decode(i.rent_st,'6', a.car_mng_id,'7',a.car_mng_id))) cnt6,"+
				"        count(decode(i.use_st,'2',decode(i.rent_st,'8', a.car_mng_id))) cnt7,"+
				"        count(decode(i.use_st,'1',a.car_mng_id)) cnt8,"+
				"        count(decode(i.use_st,'', decode(nvl(a.prepare,'1'),'1',a.car_mng_id,'7',a.car_mng_id))) cnt9,"+
				"        count(decode(i.use_st,'', decode(a.prepare,'4', a.car_mng_id,'5',a.car_mng_id,'6',a.car_mng_id,'8',a.car_mng_id))) cnt10,"+
				"        count(decode(i.use_st,'', decode(a.prepare,'2', a.car_mng_id))) cnt11,"+
				"        count(decode(i.use_st,'2',decode(i.rent_st,'12', a.car_mng_id))) cnt12,"+
				//계약확정
				"        count(decode(i.use_st,'2',decode(i.rent_st,'1', decode(o.situation,'2',a.car_mng_id)))) cnt1_0,"+
				"        count(decode(i.use_st,'2',decode(i.rent_st,'9', decode(o.situation,'2',a.car_mng_id)))) cnt1_1,"+
				"        count(decode(i.use_st,'2',decode(i.rent_st,'10',decode(o.situation,'2',a.car_mng_id)))) cnt1_2,"+
				"        count(decode(i.use_st,'2',decode(i.rent_st,'2', decode(o.situation,'2',a.car_mng_id)))) cnt1_3,"+
				"        count(decode(i.use_st,'2',decode(i.rent_st,'3', decode(o.situation,'2',a.car_mng_id)))) cnt1_4,"+
				"        count(decode(i.use_st,'2',decode(i.rent_st,'4', decode(o.situation,'2',a.car_mng_id),'5',decode(o.situation,'2',a.car_mng_id)))) cnt1_5,"+
				"        count(decode(i.use_st,'2',decode(i.rent_st,'6', decode(o.situation,'2',a.car_mng_id),'7',decode(o.situation,'2',a.car_mng_id)))) cnt1_6,"+
				"        count(decode(i.use_st,'2',decode(i.rent_st,'8', decode(o.situation,'2',a.car_mng_id)))) cnt1_7,"+
				"        count(decode(i.use_st,'1',decode(o.situation,'2',a.car_mng_id))) cnt1_8,"+
				"        count(decode(i.use_st,'', decode(nvl(a.prepare,'1'),'1',decode(o.situation,'2',a.car_mng_id),'7',decode(o.situation,'2',a.car_mng_id)))) cnt1_9,"+
				"        count(decode(i.use_st,'', decode(a.prepare,'2', decode(o.situation,'2',a.car_mng_id)))) cnt1_11,"+
				"        count(decode(i.use_st,'2',decode(i.rent_st,'12', decode(o.situation,'2',a.car_mng_id)))) cnt1_12,"+
				//상담중
				"         count(decode(i.use_st,'2',decode(i.rent_st,'1', decode(o.situation,'0',a.car_mng_id)))) cnt2_0,"+
				"         count(decode(i.use_st,'2',decode(i.rent_st,'9', decode(o.situation,'0',a.car_mng_id)))) cnt2_1,"+
				"         count(decode(i.use_st,'2',decode(i.rent_st,'10',decode(o.situation,'0',a.car_mng_id)))) cnt2_2,"+
				"         count(decode(i.use_st,'2',decode(i.rent_st,'2', decode(o.situation,'0',a.car_mng_id)))) cnt2_3,"+
				"         count(decode(i.use_st,'2',decode(i.rent_st,'3', decode(o.situation,'0',a.car_mng_id)))) cnt2_4,"+
				"         count(decode(i.use_st,'2',decode(i.rent_st,'4', decode(o.situation,'0',a.car_mng_id),'5',decode(o.situation,'0',a.car_mng_id)))) cnt2_5,"+
				"         count(decode(i.use_st,'2',decode(i.rent_st,'6', decode(o.situation,'0',a.car_mng_id),'7',decode(o.situation,'0',a.car_mng_id)))) cnt2_6,"+
				"         count(decode(i.use_st,'2',decode(i.rent_st,'8', decode(o.situation,'0',a.car_mng_id)))) cnt2_7,"+
				"         count(decode(i.use_st,'1',decode(o.situation,'0',a.car_mng_id))) cnt2_8,"+
				"         count(decode(i.use_st,'', decode(nvl(a.prepare,'1'),'1',decode(o.situation,'0',a.car_mng_id),'7',decode(o.situation,'0',a.car_mng_id)))) cnt2_9,"+
				"         count(decode(i.use_st,'', decode(a.prepare,'2', decode(o.situation,'0',a.car_mng_id)))) cnt2_11,"+
				"         count(decode(i.use_st,'2',decode(i.rent_st,'12', decode(o.situation,'0',a.car_mng_id)))) cnt2_12 "+

				" from   car_reg a, cont b, car_etc c, car_nm d, client l, users n, rent_cust m, users p, cont_etc q, v_tot_dist vt, \n"+
				"        ( select c_st, code, nm_cd, nm from code where c_st = '0027') cd,  \n"+  //주차장 
				"        (select a.* from rent_cont a, (select car_mng_id, max(use_st||nvl(deli_dt,decode(rent_st,'11','0000000000',deli_plan_dt))) deli_dt from rent_cont where use_st in ('1','2') group by car_mng_id) b where a.use_st in ('1','2') and a.car_mng_id=b.car_mng_id and a.use_st||nvl(a.deli_dt,decode(a.rent_st,'11','0000000000',a.deli_plan_dt))=b.deli_dt) i, \n"+
				"        (select car_mng_id, max(dt) use_dt, to_char(count(0)/21*100,999) use_per from (select car_mng_id, dt from scd_car where dt between to_char(sysdate-20,'YYYYMMDD') and to_char(sysdate,'YYYYMMDD') group by car_mng_id, dt) group by car_mng_id) j, \n"+
				"        (select car_mng_id, max(dt) max_use_dt from scd_car group by car_mng_id) jj, \n"+
				"        (select car_mng_id, count(0) as a_cnt from accident where accid_st='6' group by car_mng_id) k, \n"+
				"        (select a.*, b.user_nm as damdang from sh_res a, users b where a.use_yn='Y' and a.situation in ('0','2') and a.damdang_id=b.user_id(+)) o, \n"+
				"        (select a.* from insur a, (select car_mng_id, max(ins_st) ins_st from insur where ins_sts='1' group by car_mng_id) b where a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st ) r, \n"+
                //일반대차요금
				"        ( select a.* \n"+
				"          from   estimate_sh a, \n"+
				"                 (select est_ssn, max(est_id) est_id from estimate_sh where est_from ='res_car' and est_fax='Y' and rent_dt like to_char(sysdate,'YYYYMM')||'%' group by est_ssn ) b \n"+
				"          where  a.est_from ='res_car' and a.est_fax='Y' and a.rent_dt like to_char(sysdate,'YYYYMM')||'%' and  a.est_ssn=b.est_ssn and a.est_id=b.est_id) p2, \n"+
                //차량해지반납
				"        ( select * from car_call_in where in_st='3' and out_dt is null ) cc, \n"+
				//매각대상선별차량
				"        ( select * from sui_sort where reg_dt=to_char(sysdate,'YYYYMMDD') ) ss, \n"+	
				"        PARK_CONDITION pa, "+
				//단기요금
				"	     ( select a.section, a.amt_01D*1.1 AS amt_01d from short_fee_mng a, (select kind, section, fee_st, max(reg_dt) reg_dt from short_fee_mng group by kind, section, fee_st ) c \n"+
                "          where  a.fee_st='2' AND a.kind=c.kind AND a.section=C.SECTION AND a.fee_st=c.fee_st AND a.reg_dt=c.reg_dt ) sf \n"+
				" where a.off_ls ='0'  \n"+
				" and a.car_mng_id=b.car_mng_id and nvl(b.use_yn,'Y')='Y' \n"+
				" and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd \n"+
				" and c.car_id=d.car_id and c.car_seq=d.car_seq \n"+
				" and i.cust_id=l.client_id(+) and i.cust_id=n.user_id(+) and i.cust_id=m.cust_id(+) \n"+
				" and a.car_mng_id=i.car_mng_id(+) \n"+
				" and a.car_mng_id=j.car_mng_id(+) \n"+
				" and a.car_mng_id=jj.car_mng_id(+) \n"+
				" and a.car_mng_id=k.car_mng_id(+) \n"+
			//	" and a.car_mng_id=o.car_mng_id(+) and i.bus_id=p.user_id(+) and a.car_mng_id = us.car_mng_id(+) \n"+
				" and a.car_mng_id=o.car_mng_id(+) and i.bus_id=p.user_id(+)  \n"+
				" and b.rent_mng_id=q.rent_mng_id(+) and b.rent_l_cd=q.rent_l_cd(+) \n"+
			    " and decode(a.prepare,'','1','7','1',a.prepare) not in ('4','5','6','8', '9') \n"+  //9:미회수차량
				" and a.car_mng_id=r.car_mng_id(+) \n"+
				" and a.car_mng_id = vt.car_mng_id(+) \n"+
				" and a.car_mng_id=p2.est_ssn(+) \n"+
				" and b.rent_mng_id=cc.rent_mng_id(+) and b.rent_l_cd=cc.rent_l_cd(+) \n"+				
				" and decode(cc.rent_l_cd,'',b.car_st,'2')='2' \n"+
				" and a.car_mng_id=ss.car_mng_id(+) \n"+
				" and a.car_mng_id=pa.car_mng_id(+)"+
				" and a.park = cd.nm_cd(+) \n"+  //주차장 코드 테이블 
		//		" and a.fuel_kd = cd2.nm_cd \n"+  
				" and d.section=sf.section(+)"+
			    " ";
		
		if(gubun2.equals("1"))			query += " and decode(a.prepare,'','1','7','1',a.prepare) = '1' \n";
		else if(gubun2.equals("11"))	query += " and decode(a.prepare,'','1','7','1',a.prepare) = '1' and nvl(i.use_st,'5') not in ('1','2') \n";
		else if(gubun2.equals("12"))	query += " and decode(a.prepare,'','1','7','1',a.prepare) = '1' and nvl(i.use_st,'5') = '1' \n";
		else if(gubun2.equals("13"))	query += " and decode(a.prepare,'','1','7','1',a.prepare) = '1' and nvl(i.use_st,'5') = '2' \n";
		else if(gubun2.equals("14"))	query += " and decode(a.prepare,'','1','7','1',a.prepare) = '1' and nvl(i.use_st,'5') = '3' \n";
		else if(gubun2.equals("15"))	query += " and decode(a.prepare,'','1','7','1',a.prepare) = '1' and nvl(i.use_st,'5') = '2' and i.rent_st='4' \n";		
		else if(gubun2.equals("2"))		query += " and decode(a.prepare,'','1','7','1',a.prepare) = '2' \n";
		else if(gubun2.equals("3"))		query += " and decode(a.prepare,'','1','7','1',a.prepare) = '3' \n";		
		else if(gubun2.equals("16"))	query += " and decode(a.prepare,'','1','7','1',a.prepare) in ('4','5','6','8') \n";		
		else if(gubun2.equals("4"))		query += " and (nvl(i.use_st,'5') not in ('2') or i.rent_st in ('6', '7', '8')) \n";		
		else if(gubun2.equals("17"))	query += " and nvl(i.use_st,'5') = '2' and i.rent_st in ('4','5') \n ";
		else if(gubun2.equals("18"))	query += " and a.car_use='1' and nvl(i.rent_st,'0') not in ('4') \n ";
		else if(gubun2.equals("19"))	query += " and a.car_use='1' and nvl(i.rent_st,'0') not in ('4') and  NVL(a.rm_st,'0') IN ('3','5','0') \n ";
		else if(gubun2.equals("22"))	query += " and a.car_use='1' and nvl(i.rent_st,'0') not in ('4') and nvl(a.rm_st,'0')='0' \n ";
		else if(gubun2.equals("20"))	query += " and a.secondhand='1' \n ";
		else if(gubun2.equals("21"))	query += " and nvl(i.rent_st,'0') not in ('4','12') \n ";

		if(brch_id.equals("S1"))		query += " and nvl(q.mng_br_id,b.brch_id) in ('S1','K1','S2') \n";
		if(brch_id.equals("B1"))		query += " and nvl(q.mng_br_id,b.brch_id) in ('B1','N1') \n";
		if(brch_id.equals("D1"))		query += " and nvl(q.mng_br_id,b.brch_id)='D1' \n";
		if(brch_id.equals("G1"))		query += " and nvl(q.mng_br_id,b.brch_id)='G1' \n";
		if(brch_id.equals("J1"))		query += " and nvl(q.mng_br_id,b.brch_id)='J1' \n";

		if(!car_comp_id.equals(""))		query += " and d.car_comp_id='"+car_comp_id+"' \n";		
		if(!code.equals(""))			query += " and d.car_cd='"+code+"' \n";		
					
		if(!t_wd.equals("")){
			if(s_kd.equals("1"))			query += " and upper(a.car_no)||upper(a.first_car_no) like upper('%"+t_wd+"%')\n";		
			if(s_kd.equals("2"))			query += " and a.init_reg_dt like '"+t_wd+"%'\n";		
			if(s_kd.equals("6"))			query += " and decode(a.park,'6',substr(a.park_cont,1,5),nvl(cd.nm,a.park)) like '%"+t_wd+"%'\n";		
			if(s_kd.equals("7"))			query += " and decode(a.rm_st,'1','즉시','6','기타','2','대상','3','정비요','4','확인함','5','점검요','9','이동중','-') like '%"+t_wd+"%'\n";		
		}
		if(cjgubun.equals("300")) query += " and d.s_st='300' \n";
		else if(cjgubun.equals("301")) query += " and d.s_st='301' \n";
		else if(cjgubun.equals("302")) query += " and d.s_st='302' \n";
		else if(cjgubun.equals("100")) query += " and d.s_st in ('100','101','409') \n";
		else if(cjgubun.equals("112")) query += " and d.s_st in ('102','112') \n";
		else if(cjgubun.equals("103")) query += " and d.s_st='103' \n";
		else if(cjgubun.equals("104")) query += " and decode(d.s_st, '105','104', decode(substr(d.s_st,1,1),'9','104', d.s_st)) = '104' \n";
		else if(cjgubun.equals("401")) query += " and decode(substr(d.s_st,1,1),'4','401','5','401','6','401','7') = '401' \n";
		else if(cjgubun.equals("701")) query += " and decode(substr(d.s_st,1,1),'7','701') = '701' \n";
		else if(cjgubun.equals("801")) query += " and decode(substr(d.s_st,1,1),'8','801') = '801' \n";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:getStatCar3]"+e);
			System.out.println("[ResSearchDatabase:getStatCar3]"+query);
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
	 *	보유차현황 통계
	 */
	public Hashtable getStatCar3(String br_id, String brch_id, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
	
		query = " select"+

				"        count(decode(c.use_st,'2',decode(c.rent_st,'1', a.car_mng_id))) cnt0,"+
				"        count(decode(c.use_st,'2',decode(c.rent_st,'9', a.car_mng_id))) cnt1,"+
				"        count(decode(c.use_st,'2',decode(c.rent_st,'10',a.car_mng_id))) cnt2,"+
				"        count(decode(c.use_st,'2',decode(c.rent_st,'2', a.car_mng_id))) cnt3,"+
				"        count(decode(c.use_st,'2',decode(c.rent_st,'3', a.car_mng_id))) cnt4,"+
				"        count(decode(c.use_st,'2',decode(c.rent_st,'4', a.car_mng_id,'5',a.car_mng_id))) cnt5,"+
				"        count(decode(c.use_st,'2',decode(c.rent_st,'6', a.car_mng_id,'7',a.car_mng_id))) cnt6,"+
				"        count(decode(c.use_st,'2',decode(c.rent_st,'8', a.car_mng_id))) cnt7,"+
				"        count(decode(c.use_st,'1',a.car_mng_id)) cnt8,"+
				"        count(decode(c.use_st,'', decode(nvl(a.prepare,'1'),'1',a.car_mng_id,'7',a.car_mng_id))) cnt9,"+
				"        count(decode(c.use_st,'', decode(a.prepare,'4', a.car_mng_id,'5',a.car_mng_id,'6',a.car_mng_id,'8',a.car_mng_id))) cnt10,"+
				"        count(decode(c.use_st,'', decode(a.prepare,'2', a.car_mng_id))) cnt11,"+
				"        count(decode(c.use_st,'2',decode(c.rent_st,'12', a.car_mng_id))) cnt12,"+
				//계약확정
				"        count(decode(c.use_st,'2',decode(c.rent_st,'1', decode(o.situation,'2',a.car_mng_id)))) cnt1_0,"+
				"        count(decode(c.use_st,'2',decode(c.rent_st,'9', decode(o.situation,'2',a.car_mng_id)))) cnt1_1,"+
				"        count(decode(c.use_st,'2',decode(c.rent_st,'10',decode(o.situation,'2',a.car_mng_id)))) cnt1_2,"+
				"        count(decode(c.use_st,'2',decode(c.rent_st,'2', decode(o.situation,'2',a.car_mng_id)))) cnt1_3,"+
				"        count(decode(c.use_st,'2',decode(c.rent_st,'3', decode(o.situation,'2',a.car_mng_id)))) cnt1_4,"+
				"        count(decode(c.use_st,'2',decode(c.rent_st,'4', decode(o.situation,'2',a.car_mng_id),'5',decode(o.situation,'2',a.car_mng_id)))) cnt1_5,"+
				"        count(decode(c.use_st,'2',decode(c.rent_st,'6', decode(o.situation,'2',a.car_mng_id),'7',decode(o.situation,'2',a.car_mng_id)))) cnt1_6,"+
				"        count(decode(c.use_st,'2',decode(c.rent_st,'8', decode(o.situation,'2',a.car_mng_id)))) cnt1_7,"+
				"        count(decode(c.use_st,'1',decode(o.situation,'2',a.car_mng_id))) cnt1_8,"+
				"        count(decode(c.use_st,'', decode(nvl(a.prepare,'1'),'1',decode(o.situation,'2',a.car_mng_id),'7',decode(o.situation,'2',a.car_mng_id)))) cnt1_9,"+
				"        count(decode(c.use_st,'', decode(a.prepare,'2', decode(o.situation,'2',a.car_mng_id)))) cnt1_11,"+
				"        count(decode(c.use_st,'2',decode(c.rent_st,'12', decode(o.situation,'2',a.car_mng_id)))) cnt1_12,"+
				//상담중
				"        count(decode(c.use_st,'2',decode(c.rent_st,'1', decode(o.situation,'0',a.car_mng_id)))) cnt2_0,"+
				"        count(decode(c.use_st,'2',decode(c.rent_st,'9', decode(o.situation,'0',a.car_mng_id)))) cnt2_1,"+
				"        count(decode(c.use_st,'2',decode(c.rent_st,'10',decode(o.situation,'0',a.car_mng_id)))) cnt2_2,"+
				"        count(decode(c.use_st,'2',decode(c.rent_st,'2', decode(o.situation,'0',a.car_mng_id)))) cnt2_3,"+
				"        count(decode(c.use_st,'2',decode(c.rent_st,'3', decode(o.situation,'0',a.car_mng_id)))) cnt2_4,"+
				"        count(decode(c.use_st,'2',decode(c.rent_st,'4', decode(o.situation,'0',a.car_mng_id),'5',decode(o.situation,'0',a.car_mng_id)))) cnt2_5,"+
				"        count(decode(c.use_st,'2',decode(c.rent_st,'6', decode(o.situation,'0',a.car_mng_id),'7',decode(o.situation,'0',a.car_mng_id)))) cnt2_6,"+
				"        count(decode(c.use_st,'2',decode(c.rent_st,'8', decode(o.situation,'0',a.car_mng_id)))) cnt2_7,"+
				"        count(decode(c.use_st,'1',decode(o.situation,'0',a.car_mng_id))) cnt2_8,"+
				"        count(decode(c.use_st,'', decode(nvl(a.prepare,'1'),'1',decode(o.situation,'0',a.car_mng_id),'7',decode(o.situation,'0',a.car_mng_id)))) cnt2_9,"+
				"        count(decode(c.use_st,'', decode(a.prepare,'2', decode(o.situation,'0',a.car_mng_id)))) cnt2_11,"+
				"        count(decode(c.use_st,'2',decode(c.rent_st,'12', decode(o.situation,'0',a.car_mng_id)))) cnt2_12 "+

				" from   car_reg a, cont b, "+
				//c 마지막단기
				"        (select a.* from rent_cont a, (select car_mng_id, max(nvl(deli_dt,decode(rent_st,'11','0000000000',deli_plan_dt))) deli_dt from rent_cont where use_st in ('1','2') group by car_mng_id) b where a.use_st in ('1','2') and a.car_mng_id=b.car_mng_id and nvl(a.deli_dt,decode(a.rent_st,'11','0000000000',a.deli_plan_dt))=b.deli_dt) c, "+
                //cc 차량해지반납
				"        ( select * from car_call_in where in_st='3' and out_dt is null ) cc, \n"+
				//o 재리스상담
				"        ( select a.*, b.user_nm as damdang from sh_res a, users b where a.use_yn='Y' and a.situation in ('0','2') and a.damdang_id=b.user_id(+) ) o \n"+
				" where  a.off_ls ='0' and a.car_mng_id=b.car_mng_id and nvl(b.use_yn,'Y')='Y' "+
				"        and a.car_mng_id=c.car_mng_id(+)"+
 				"        and decode(a.prepare,'','1','7','1',a.prepare) not in ('4','5','6','8')"+
				"        and b.rent_mng_id=cc.rent_mng_id(+) and b.rent_l_cd=cc.rent_l_cd(+) \n"+				
				"        and decode(cc.rent_l_cd,'',b.car_st,'2')='2' \n"+
				"        and a.car_mng_id=o.car_mng_id(+)"+
			    " ";


		if(gubun2.equals("21"))			query += " and nvl(c.rent_st,'0') not in ('4','12')";


		if(brch_id.equals("S1"))		query += " and b.brch_id in ('S1','K1')";
		if(brch_id.equals("S2"))		query += " and b.brch_id='S2'";
		if(brch_id.equals("B1"))		query += " and b.brch_id in ('B1','N1')";
		if(brch_id.equals("D1"))		query += " and b.brch_id='D1'";


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:getStatCar3]"+e);
			System.out.println("[ResSearchDatabase:getStatCar3]"+query);
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
	*	예비차량에서 매각예정차량 또는 보류차량으로
	*/
	public int setCar_prepare(String[] pre, String prepare) throws SQLException
	{
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;

		String query = "UPDATE car_reg SET prepare = '"+prepare+"' WHERE car_mng_id in ('";		
		
		for(int i=0 ; i<pre.length ; i++){
			if(i == (pre.length -1))	query += pre[i];
			else						query += pre[i]+"', '";
		}
		query+="')";

		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		}catch(SQLException e){
			System.out.println("[ResSearchDatabase:setCar_prepare(String[] pre, String prepare)]"+e);
			System.out.println("[ResSearchDatabase:setCar_prepare]"+query);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
                if(pstmt != null) pstmt.close();
				conn.setAutoCommit(true);
            }catch(SQLException _ignored){}

			closeConnection();
		}
		return result;
	}

	/**
	*	예비차량에서 매각예정차량 또는 보류차량으로
	*/
	public int setCar_prepare1(String c_id, String prepare) throws SQLException
	{
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;

		String query = "UPDATE car_reg SET prepare = '"+prepare+"' WHERE car_mng_id = '"+c_id+"'";

		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		}catch(SQLException e){
			System.out.println("[ResSearchDatabase:setCar_prepare1(String c_id, String prepare)]"+e);
			System.out.println("[ResSearchDatabase:setCar_prepare1]"+query);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
                if(pstmt != null) pstmt.close();
				conn.setAutoCommit(true);
            }catch(SQLException _ignored){}

			closeConnection();
		}
		return result;
	}


	/**
	*	매각결정차량으로 처리
	*/
	public int setCar_off_ls(String[] pre, String prepare) throws SQLException
	{
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;

		String query = "UPDATE car_reg SET off_ls = '"+prepare+"' WHERE car_mng_id in ('";		
		
		for(int i=0 ; i<pre.length ; i++){
			if(i == (pre.length -1))	query += pre[i];
			else						query += pre[i]+"', '";
		}
		query+="') and prepare='2' ";

		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		}catch(SQLException e){
			System.out.println("[ResSearchDatabase:setCar_off_ls(String[] pre, String prepare)]"+e);
			System.out.println("[ResSearchDatabase:setCar_off_ls]"+query);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
                if(pstmt != null) pstmt.close();
				conn.setAutoCommit(true);
            }catch(SQLException _ignored){}

			closeConnection();
		}
		return result;
	}

	/**
	*	매각결정차량으로 처리
	*/
	public int setCar_off_ls1(String c_id, String prepare) throws SQLException
	{
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;

		String query = "UPDATE car_reg SET off_ls = '"+prepare+"' WHERE car_mng_id = '"+c_id+"' and prepare='2' ";

		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		}catch(SQLException e){
			System.out.println("[ResSearchDatabase:setCar_off_ls1(String c_id, String prepare)]"+e);
			System.out.println("[ResSearchDatabase:setCar_off_ls1]"+query);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
                if(pstmt != null) pstmt.close();
				conn.setAutoCommit(true);
            }catch(SQLException _ignored){}

			closeConnection();
		}
		return result;
	}

	/**
	*	차량상태 초기화 (off_ls, prepare, secondhand)
	*/
	public int setCar_stat_Init(String car_mng_id) throws SQLException
	{
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;

		String query = "UPDATE car_reg SET off_ls='', prepare='', secondhand='' WHERE car_mng_id ='"+car_mng_id+"'";		
		
		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		}catch(SQLException e){
			System.out.println("[ResSearchDatabase:setCar_stat_Init(String car_mng_id)]"+e);
			System.out.println("[ResSearchDatabase:setCar_stat_Init]"+query);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
                if(pstmt != null) pstmt.close();
				conn.setAutoCommit(true);
            }catch(SQLException _ignored){}

			closeConnection();
		}
		return result;
	}

	/**
	 *	예비차 보유현황 - 안부장님 요청
	 */
	public Vector getStatCar()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.car_kd, decode(a.prepare,'4','1', '5','1', '8','1', '9', '1', '2','2', '0') prepare, a.off_ls, decode(c.use_st,'1','11',nvl(c.rent_st,'0')) rent_st, count(0) su"+
				" from car_reg a, cont b, rent_cont c,"+
				" (select car_mng_id, max(rent_s_cd) rent_s_cd from rent_cont where use_st in ('2','1') group by car_mng_id) d,"+
				" (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where car_st<>'4' group by car_mng_id) e,"+
                //차량해지반납
				" ( select * from car_call_in where in_st='3' and out_dt is null ) q "+
				" where a.car_mng_id=b.car_mng_id and nvl(b.use_yn,'Y')='Y' and a.off_ls <>'6'"+
				" and a.car_mng_id=d.car_mng_id(+)"+
				" and d.car_mng_id=c.car_mng_id(+) and d.rent_s_cd=c.rent_s_cd(+)"+
				" and b.car_mng_id=e.car_mng_id(+) and b.rent_l_cd=e.rent_l_cd(+)"+
				" and b.rent_mng_id=q.rent_mng_id(+) and b.rent_l_cd=q.rent_l_cd(+)"+						
				" and decode(q.rent_l_cd,'',b.car_st,'2')='2'"+
				" group by a.car_kd, decode(a.prepare,'4','1','5','1','8','1','9', '1', '2','2','0'), a.off_ls, decode(c.use_st,'1','11',nvl(c.rent_st,'0'))"+
				" order by a.car_kd, decode(a.prepare,'4','1','5','1','8','1', '9', '1', '2','2','0'), a.off_ls, decode(c.use_st,'1','11',nvl(c.rent_st,'0'))"+
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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:getStatCar()]"+e);
			System.out.println("[ResSearchDatabase:getStatCar()]"+query);
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
	 *	예비차 보유현황2 출고전대차 - 안부장님 요청
	 */
	public Vector getStatCarTae()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.car_kd, count(0) su"+
				" from car_reg a, cont b, taecha c,"+
				" (select car_mng_id, max(no) no from taecha group by car_mng_id) d"+
				" where a.car_mng_id=b.car_mng_id and nvl(b.use_yn,'Y')='Y'"+
				" and a.car_mng_id=c.car_mng_id "+
				" and c.car_mng_id=d.car_mng_id and c.no=d.no"+
				" and to_char(sysdate,'YYYYMMDD') between c.car_rent_st and c.car_rent_et"+
				" group by a.car_kd order by a.car_kd";

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
			System.out.println("[ResSearchDatabase:getStatCarTae()]"+e);
			System.out.println("[ResSearchDatabase:getStatCarTae()]"+query);
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
	 *	요금관리 리스트
	 */
	public Vector getScdRentMngList(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String brch_id, String s_bus, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select  "+
				" a.rent_s_cd, a.car_mng_id, decode(a.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','장기대기','12','월렌트') rent_st,"+
				" decode(a.cust_st, '','조성희', '1',d.client_nm, '4',e.user_nm, c.cust_nm) cust_nm,"+
				" decode(a.cust_st, '','(주)아마존카', '1',d.firm_nm, '4','(주)아마존카', c.firm_nm) firm_nm,"+
				" a.rent_dt, a.brch_id, a.bus_id, a.cust_st, a.cust_id, b.rent_tot_amt, cr.car_no, k.car_nm, h.car_name,"+
				" decode(j.pay_dt, '','미수금','수금') pay_yn, decode(j.rent_st,'1','보증금','2','선납대여료','3','대여료','4','정산금','5','연장대여료') s_rent_st,"+
				" j.tm, j.est_dt, j.pay_dt, decode(j.pay_amt,0,j.rest_amt,j.pay_amt) amt, j.rent_s_amt+nvl(j.rent_v_amt,0) rent_amt, j.pay_amt, j.rest_amt, j.dly_amt, nvl(j.dly_days,'0') dly_days"+
				" from RENT_CONT a, RENT_FEE b, RENT_CUST c, CLIENT d, USERS e, CONT_N_VIEW f, CAR_NM h, SCD_RENT j, CAR_MNG k, , car_etc ce, car_reg cr,  \n"+ 
				"  (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where car_st<>'4'  group by car_mng_id) i"+
				" where a.rent_s_cd=b.rent_s_cd(+) and a.cust_id=c.cust_id(+) and a.cust_id=d.client_id(+) and a.cust_id=e.user_id(+)"+
				" and a.car_mng_id=f.car_mng_id   and f.car_mng_id = cr.car_mng_id \n"+
				" and f.car_mng_id=i.car_mng_id and f.rent_l_cd=i.rent_l_cd"+
				"        and f.rent_mng_id = ce.rent_mng_id(+) and f.rent_l_cd = ce.rent_l_cd(+) \n"+
				"        and ce.car_id=h.car_id(+) and ce.car_seq=h.car_seq(+) and h.car_comp_id=k.car_comp_id and h.car_cd=k.code \n" +
				" and a.rent_s_cd=j.rent_s_cd and j.rent_s_amt > 0";
		

		if(brch_id.equals("S1"))							query += " and a.brch_id in ('S1','K1')";
		if(brch_id.equals("S2"))							query += " and a.brch_id='S2'";
		if(brch_id.equals("B1"))							query += " and a.brch_id='B1'";


		if(!s_bus.equals(""))								query += " and a.bus_id='"+s_bus+"'";

		if(gubun2.equals("1") && gubun3.equals("1"))		query += " and j.est_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("1") && gubun3.equals("2"))	query += " and j.pay_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("1") && gubun3.equals("3"))	query += " and j.est_dt like to_char(sysdate,'YYYYMM')||'%' and j.pay_dt is null";
		else if(gubun2.equals("2") && gubun3.equals("1"))	query += " and j.est_dt=to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("2") && gubun3.equals("2"))	query += " and j.pay_dt=to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("2") && gubun3.equals("3"))	query += " and j.est_dt=to_char(sysdate,'YYYYMMDD') and j.pay_dt is null";
		else if(gubun2.equals("6") && gubun3.equals("1"))	query += " and j.est_dt <= to_char(sysdate,'YYYYMMDD') and (j.pay_dt is null or j.pay_dt=to_char(sysdate,'YYYYMMDD'))";
		else if(gubun2.equals("6") && gubun3.equals("2"))	query += " and j.est_dt <= to_char(sysdate,'YYYYMMDD') and j.pay_dt=to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("6") && gubun3.equals("3"))	query += " and j.est_dt <= to_char(sysdate,'YYYYMMDD') and j.pay_dt is null";
		else if(gubun2.equals("3") && gubun3.equals("1"))	query += " and j.est_dt < to_char(sysdate,'YYYYMMDD') and (j.pay_dt is null or j.pay_dt=to_char(sysdate,'YYYYMMDD'))";
		else if(gubun2.equals("3") && gubun3.equals("2"))	query += " and j.est_dt < to_char(sysdate,'YYYYMMDD') and j.pay_dt=to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("3") && gubun3.equals("3"))	query += " and j.est_dt < to_char(sysdate,'YYYYMMDD') and j.pay_dt is null";
		else if(gubun2.equals("4") && gubun3.equals("1"))	query += " and j.est_dt between '"+st_dt+"' and '"+end_dt+"'";
		else if(gubun2.equals("4") && gubun3.equals("2"))	query += " and j.pay_dt between '"+st_dt+"' and '"+end_dt+"'";
		else if(gubun2.equals("4") && gubun3.equals("3"))	query += " and j.est_dt between '"+st_dt+"' and '"+end_dt+"' and j.pay_dt is null";
		else if(gubun2.equals("5") && gubun3.equals("2"))	query += " and j.pay_dt is not null";
		else if(gubun2.equals("5") && gubun3.equals("3"))	query += " and j.pay_dt is null";
				

		if(s_kd.equals("1"))								query += " and decode(a.cust_st, '','조성희', '1',d.client_nm, '4',e.user_nm, c.cust_nm) like '%"+t_wd+"%'\n";		
		if(s_kd.equals("2"))								query += " and decode(a.cust_st, '','(주)아마존카', '1',d.firm_nm, '4','(주)아마존카', c.firm_nm) like '%"+t_wd+"%'\n";		
		if(s_kd.equals("3"))								query += " and a.rent_s_cd like '%"+t_wd+"%'\n";		
		if(s_kd.equals("4"))								query += " and cr.car_no||' '||cr.first_car_no like '%"+t_wd+"%'\n";
		if(s_kd.equals("5"))								query += " and k.car_nm||h.car_name like '%"+t_wd+"%'\n";		
		if(s_kd.equals("6"))								query += " and a.rent_dt like '"+t_wd+"%'\n";
		if(s_kd.equals("7"))								query += " and nvl(j.pay_amt,0,j.rest_amt) like '%"+t_wd+"%'\n";

		if(sort_gubun.equals("1"))							query += " ORDER BY j.est_dt "+asc+", to_number(j.tm)";
		if(sort_gubun.equals("2"))							query += " ORDER BY decode(a.cust_id, '1',d.client_nm, '4',e.user_nm, c.cust_nm) "+asc+", to_number(j.tm)";
		if(sort_gubun.equals("3"))							query += " ORDER BY j.pay_dt "+asc+", to_number(j.tm)";
		if(sort_gubun.equals("4"))							query += " ORDER BY nvl(j.pay_amt,0,j.rest_amt) "+asc;


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
			System.out.println("[ResSearchDatabase:getScdRentMngList]"+e);
			System.out.println("[ResSearchDatabase:getScdRentMngList]"+query);
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
	 *	요금관리 리스트
	 */
	public Vector getScdRentMngList_New(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String brch_id, String s_bus, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				"        a.rent_s_cd, a.car_mng_id, decode(a.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','장기대기','12','월렌트') rent_st,"+
				"        decode(a.cust_st, '4',e.user_nm, d.client_nm) cust_nm,"+
				"        decode(a.cust_st, '4','(주)아마존카', d.firm_nm) firm_nm,"+
				"        a.rent_dt, a.brch_id, a.bus_id, a.mng_id, a.cust_st, a.cust_id, b.rent_tot_amt, c.car_no, c.car_nm, "+
				"        decode(j.pay_dt, '','미수금','수금') pay_yn, decode(j.rent_st,'1','예약금','2','선납대여료','3','대여료','4','정산금','5','연장대여료','6','보증금', '8', '과태료') s_rent_st,"+
				"        j.tm, j.est_dt, j.pay_dt, "+
				"        decode(j.pay_amt,0,j.rest_amt,j.pay_amt) amt, "+
				"        j.rent_s_amt+nvl(j.rent_v_amt,0) rent_amt, j.pay_amt, j.rest_amt, j.dly_amt, nvl(j.dly_days,'0') dly_days, "+
				"        t.tax_dt, "+
				"        h.reg_nm, h.sub, h.note, h.reg_dt, h.reg_dt2 "+
				" from   RENT_CONT a, RENT_FEE b, CAR_REG c, CLIENT d, USERS e, SCD_RENT j, "+
				"        (select a.rent_l_cd, a.rent_st, a.tm, MAX(b.tax_dt) tax_dt from tax_item_list a, tax b where a.item_id=b.item_id and b.tax_st<>'C' and a.gubun in ('9','10','16','17') group by a.rent_l_cd, a.rent_st, a.tm HAVING SUM(a.item_supply)<>0) t,"+
				" /*dly_mm-g*/	(select rent_s_cd, max(reg_dt||reg_dt_time) reg_dt from rent_m group by rent_s_cd) g,"+
				" /*dly_mm-h*/	(select a.rent_s_cd, b.user_nm as reg_nm, a.sub, a.note, reg_dt||reg_dt_time as reg_dt, reg_dt as reg_dt2 from rent_m a, users b where a.user_id=b.user_id) h"+
				" where  a.rent_st in ('1','9','12','2') "+
				"        and (a.use_st<>'5' or (a.use_st='5' and j.pay_dt is not null))"+
				"        and a.rent_start_dt >= '20070101' "+
				"        and a.rent_s_cd=b.rent_s_cd(+) and a.car_mng_id=c.car_mng_id and a.cust_id=d.client_id(+) and a.cust_id=e.user_id(+)"+
				"        and a.rent_s_cd=j.rent_s_cd(+) and  nvl(j.bill_yn,'Y')='Y'"+
				"        and j.rent_s_cd=t.rent_l_cd(+) and j.rent_st=t.rent_st(+) and j.tm=t.tm(+) "+
				"        and a.rent_s_cd=g.rent_s_cd(+) and g.rent_s_cd=h.rent_s_cd(+) and g.reg_dt=h.reg_dt(+) "+
				"        and decode(a.rent_st,'2',decode(b.fee_s_amt,0,'N','Y'),'Y')='Y' "+
				"        and j.rent_s_amt<>0 "+
				" ";
		
		if(brch_id.equals("S1"))							query += " and a.brch_id in ('S1','K1','S2')";
//		if(brch_id.equals("S2"))							query += " and a.brch_id='S2'";
		if(brch_id.equals("B1"))							query += " and a.brch_id in ('B1','N1')";
		if(brch_id.equals("D1"))							query += " and a.brch_id='D1'";
		if(brch_id.equals("G1"))							query += " and a.brch_id='G1'";
		if(brch_id.equals("J1"))							query += " and a.brch_id='J1'";


		if(!s_bus.equals(""))								query += " and a.bus_id='"+s_bus+"'";

		if(gubun2.equals("1") && gubun3.equals("1"))		query += " and j.est_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("1") && gubun3.equals("2"))	query += " and j.pay_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("1") && gubun3.equals("3"))	query += " and j.est_dt like to_char(sysdate,'YYYYMM')||'%' and j.pay_dt is null";
		else if(gubun2.equals("2") && gubun3.equals("1"))	query += " and j.est_dt=to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("2") && gubun3.equals("2"))	query += " and j.pay_dt=to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("2") && gubun3.equals("3"))	query += " and j.est_dt=to_char(sysdate,'YYYYMMDD') and j.pay_dt is null";
		else if(gubun2.equals("6") && gubun3.equals("1"))	query += " and j.est_dt <= to_char(sysdate,'YYYYMMDD') and (j.pay_dt is null or j.pay_dt=to_char(sysdate,'YYYYMMDD'))";
		else if(gubun2.equals("6") && gubun3.equals("2"))	query += " and j.est_dt <= to_char(sysdate,'YYYYMMDD') and j.pay_dt=to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("6") && gubun3.equals("3"))	query += " and j.est_dt <= to_char(sysdate,'YYYYMMDD') and j.pay_dt is null";
		else if(gubun2.equals("3") && gubun3.equals("1"))	query += " and j.est_dt < to_char(sysdate,'YYYYMMDD') and (j.pay_dt is null or j.pay_dt=to_char(sysdate,'YYYYMMDD'))";
		else if(gubun2.equals("3") && gubun3.equals("2"))	query += " and j.est_dt < to_char(sysdate,'YYYYMMDD') and j.pay_dt=to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("3") && gubun3.equals("3"))	query += " and j.est_dt < to_char(sysdate,'YYYYMMDD') and j.pay_dt is null";
		else if(gubun2.equals("4") && gubun3.equals("1"))	query += " and j.est_dt between '"+st_dt+"' and '"+end_dt+"'";
		else if(gubun2.equals("4") && gubun3.equals("2"))	query += " and j.pay_dt between '"+st_dt+"' and '"+end_dt+"'";
		else if(gubun2.equals("4") && gubun3.equals("3"))	query += " and j.est_dt between '"+st_dt+"' and '"+end_dt+"' and j.pay_dt is null";
		else if(gubun2.equals("5") && gubun3.equals("2"))	query += " and j.pay_dt is not null";
		else if(gubun2.equals("5") && gubun3.equals("3"))	query += " and j.pay_dt is null";
				

		if(s_kd.equals("1"))								query += " and decode(a.cust_st, '4',e.user_nm, d.client_nm) like '%"+t_wd+"%'\n";		
		if(s_kd.equals("2"))								query += " and decode(a.cust_st, '4','(주)아마존카', d.firm_nm) like '%"+t_wd+"%'\n";		
		if(s_kd.equals("3"))								query += " and a.rent_s_cd like '%"+t_wd+"%'\n";		
		if(s_kd.equals("4"))								query += " and c.car_no||' '||upper(c.first_car_no) like '%"+t_wd+"%'\n";
		if(s_kd.equals("5"))								query += " and c.car_nm like '%"+t_wd+"%'\n";		
		if(s_kd.equals("6"))								query += " and a.rent_dt like '"+t_wd+"%'\n";
		if(s_kd.equals("7"))								query += " and nvl(j.pay_amt,0,j.rest_amt) like '%"+t_wd+"%'\n";

		if(sort_gubun.equals("1"))							query += " ORDER BY j.est_dt "+asc+", to_number(j.tm)";
		if(sort_gubun.equals("2"))							query += " ORDER BY decode(a.cust_id, '4',e.user_nm, d.firm_nm) "+asc+", to_number(j.tm)";
		if(sort_gubun.equals("3"))							query += " ORDER BY j.pay_dt "+asc+", to_number(j.tm)";
		if(sort_gubun.equals("4"))							query += " ORDER BY nvl(j.pay_amt,0,j.rest_amt) "+asc;


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
			System.out.println("[ResSearchDatabase:getScdRentMngList_New]"+e);
			System.out.println("[ResSearchDatabase:getScdRentMngList_New]"+query);
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
	 *	요금관리 리스트
	 */
	public Vector getScdRentMngList_New2(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String brch_id, String s_bus, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				"        a.rent_s_cd, a.car_mng_id, decode(a.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','장기대기','12','월렌트') rent_st,"+
				"        decode(a.use_st,'2','배차','3','반차','4','종료') use_st,"+
				"        decode(a.cust_st, '4',e.user_nm, d.client_nm) cust_nm,"+
				"        decode(a.cust_st, '4','(주)아마존카', d.firm_nm) firm_nm,"+
				"        a.rent_dt, a.brch_id, a.bus_id, a.mng_id, a.cust_st, a.cust_id, b.rent_tot_amt, c.car_no, c.car_nm, "+
				"        decode(i.cnt, '','미등록','등록') reg_yn,"+
				"        decode(j.rent_s_cd, '','미정산','정산') settle_yn,"+
				"        a.rent_start_dt, a.rent_end_dt, nvl(a.deli_dt,a.deli_plan_dt) deli_dt, nvl(a.ret_dt,a.ret_plan_dt) ret_dt, j.sett_dt, j.rent_sett_amt, i.pay_amt, i.cnt"+
				" from   RENT_CONT a, RENT_FEE b, CAR_REG c, CLIENT d, USERS e, RENT_SETTLE j,"+
				"        (select rent_s_cd, sum(pay_amt) pay_amt, count(0) cnt from scd_rent where (rent_s_amt+pay_amt)>0 group by rent_s_cd) i"+
				" where  a.rent_st in ('1','9','12','2') "+
				"        and a.use_st<>'5' "+
				"        and a.rent_start_dt >= '20070101' "+
				"        and a.rent_s_cd > '018979' "+
				"        and a.rent_s_cd=b.rent_s_cd(+) and a.car_mng_id=c.car_mng_id and a.cust_id=d.client_id(+) and a.cust_id=e.user_id(+)"+
				"        and a.rent_s_cd=j.rent_s_cd(+)"+
				"        and a.rent_s_cd=i.rent_s_cd(+)"+
				"        and decode(a.rent_st,'2',decode(nvl(b.fee_s_amt,0),0,'N','Y'),'Y')='Y' "+
				" ";
		
		if(t_wd.equals("")){
			if(brch_id.equals("S1"))							query += " and a.brch_id in ('S1','K1','S2')";
//			if(brch_id.equals("S2"))							query += " and a.brch_id='S2'";
			if(brch_id.equals("B1"))							query += " and a.brch_id in ('B1','N1')";
			if(brch_id.equals("D1"))							query += " and a.brch_id='D1'";
			if(brch_id.equals("G1"))							query += " and a.brch_id='G1'";
			if(brch_id.equals("J1"))							query += " and a.brch_id='J1'";

			if(!s_bus.equals(""))								query += " and a.bus_id='"+s_bus+"'";

			if(gubun2.equals("1"))								query += " and i.cnt > 0";
			if(gubun2.equals("2"))								query += " and i.cnt is null";

			if(gubun3.equals("1"))								query += " and nvl(a.deli_dt,a.deli_plan_dt) like to_char(sysdate,'YYYYMM')||'%'";
			if(gubun3.equals("2"))								query += " and nvl(a.deli_dt,a.deli_plan_dt) like to_char(sysdate,'YYYYMMDD')||'%'";
			if(gubun3.equals("3"))								query += " and nvl(a.deli_dt,a.deli_plan_dt) between '"+st_dt+"' and '"+end_dt+"'";				

		}else{

			if(s_kd.equals("1"))								query += " and decode(a.cust_st, '4',e.user_nm, d.client_nm) like '%"+t_wd+"%'\n";		
			if(s_kd.equals("2"))								query += " and decode(a.cust_st, '4','(주)아마존카', d.firm_nm) like '%"+t_wd+"%'\n";		
			if(s_kd.equals("3"))								query += " and a.rent_s_cd like '%"+t_wd+"%'\n";		
			if(s_kd.equals("4"))								query += " and c.car_no||' '||upper(c.first_car_no) like '%"+t_wd+"%'\n";
			if(s_kd.equals("5"))								query += " and c.car_nm like '%"+t_wd+"%'\n";		
			if(s_kd.equals("6"))								query += " and a.rent_dt like '"+t_wd+"%'\n";
			if(s_kd.equals("7"))								query += " and b.rent_tot_amt like '%"+t_wd+"%'\n";

		}

		if(sort_gubun.equals("1"))							query += " ORDER BY nvl(a.ret_dt,a.ret_plan_dt) "+asc+"";
		if(sort_gubun.equals("2"))							query += " ORDER BY decode(a.cust_id, '4',e.user_nm, d.firm_nm) "+asc+"";
		if(sort_gubun.equals("3"))							query += " ORDER BY nvl(j.sett_dt,nvl(a.ret_dt,a.ret_plan_dt)) "+asc+"";


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
			System.out.println("[ResSearchDatabase:getScdRentMngList_New2]"+e);
			System.out.println("[ResSearchDatabase:getScdRentMngList_New2]"+query);
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
	 *	수금현황-단기대여요금
	 */
	public Vector getScdRentStat(String br_id, String search_kd, String brch_id, String bus_id2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String query2 = "";

		query = " select decode(a.pay_amt,0,a.rest_amt,a.pay_amt) amt, a.est_dt, a.pay_dt"+
					" from scd_rent a, rent_cont b"+
					" where a.rent_s_cd=b.rent_s_cd"+
					" and a.rent_s_amt > 0 and a.bill_yn='Y'";


		query2 = " select '계획' gubun, a.*, b.*, c.*\n"+
				" from\n"+
					" ( select count(0) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+query+") where est_dt like to_char(sysdate,'YYYYMM')||'%' ) a,\n"+
					" ( select count(0) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+query+") where est_dt = to_char(sysdate,'YYYYMMDD') ) b,\n"+	
					" ( select count(0) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+query+") where est_dt < to_char(sysdate,'YYYYMMDD') and (pay_dt is null or pay_dt = to_char(sysdate,'YYYYMMDD')) ) c\n"+
				" union all\n"+
				" select '수금' gubun, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(0) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+query+") where est_dt like to_char(sysdate,'YYYYMM')||'%' and pay_dt is not null) a,\n"+
					" ( select count(0) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+query+") where est_dt = to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD') ) b,\n"+	
					" ( select count(0) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+query+") where est_dt < to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD') ) c\n"+
				" union all\n"+
				" select '미수금' gubun, a.*, b.*, c.*\n"+
				" from \n"+
					" ( select count(0) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+query+") where est_dt like to_char(sysdate,'YYYYMM')||'%' and pay_dt is null ) a,\n"+
					" ( select count(0) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+query+") where est_dt = to_char(sysdate,'YYYYMMDD') and pay_dt is null) b,\n"+
					" ( select count(0) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+query+") where est_dt < to_char(sysdate,'YYYYMMDD') and pay_dt is null ) c\n"+
				" union all\n"+
				" select '비율' gubun, a.*, b.*, c.*\n"+
				" from \n"+
					" ( select decode(a.tot_su1, 0,0, to_number(to_char((b.tot_su1/a.tot_su1)*100, 999.99))) tot_su1, decode(a.tot_amt1, 0,0, to_number(to_char((b.tot_amt1/a.tot_amt1)*100, 999.99))) tot_amt1 from \n"+
						" ( select count(0) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+query+") where est_dt like to_char(sysdate,'YYYYMM')||'%' ) a,\n"+
						" ( select count(0) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+query+") where est_dt like to_char(sysdate,'YYYYMM')||'%' and pay_dt is not null ) b\n"+
					" ) a,\n"+
					" ( select decode(a.tot_su2, 0,0, to_number(to_char((b.tot_su2/a.tot_su2)*100, 999.99))) tot_su2, decode(a.tot_amt2, 0,0, to_number(to_char((b.tot_amt2/a.tot_amt2)*100, 999.99))) tot_amt2 from \n"+
						" ( select count(0) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+query+") where est_dt = to_char(sysdate,'YYYYMMDD') ) a,\n"+
						" ( select count(0) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+query+") where est_dt = to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD') ) b\n"+
					" ) b,\n"+
					" ( select decode(a.tot_su3, 0,0, to_number(to_char((b.tot_su3/a.tot_su3)*100, 999.99))) tot_su3, decode(a.tot_amt3, 0,0, to_number(to_char((b.tot_amt3/a.tot_amt3)*100, 999.99))) tot_amt3 from \n"+
						" ( select count(0) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+query+") where est_dt < to_char(sysdate,'YYYYMMDD') and (pay_dt is null or pay_dt = to_char(sysdate,'YYYYMMDD')) ) a,\n"+
						" ( select count(0) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+query+") where est_dt < to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD') ) b\n"+
					" ) c";

		try {
			pstmt = conn.prepareStatement(query2);
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
			System.out.println("[ResSearchDatabase:getScdRentStat]"+e);
			System.out.println("[ResSearchDatabase:getScdRentStat]"+query2);
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
	 *	일일업무조회 리스트
	 */
	public Vector getResPlanList(String br_id, String gubun1, String gubun2, String brch_id, String bus_id, String start_dt, String end_dt, String use_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String search1 = "";
		
		if(use_st.equals("1")){
			search1 = "a.deli_plan_dt";		
		}else if(use_st.equals("2")){ 
			search1 = "a.ret_plan_dt";		
		}else if(use_st.equals("3")){
			search1 = "a.ret_dt";		
		}

		query = " select  "+
				" a.rent_s_cd, a.car_mng_id, decode(a.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','장기대기','12','월렌트') rent_st,"+
				" decode(a.cust_st, '','조성희', '1',d.client_nm, '4',e.user_nm, c.cust_nm) cust_nm,"+
				" decode(a.cust_st, '','(주)아마존카', '1',d.firm_nm, '4','(주)아마존카', c.firm_nm) firm_nm,"+
				" a.rent_dt, a.rent_start_dt, a.rent_end_dt, a.brch_id, a.bus_id,"+
				" a.deli_plan_dt, a.ret_plan_dt,"+
				" a.deli_dt, a.ret_dt,"+
				" j.sett_dt,"+
				" cr.car_no, k.car_nm, h.car_name"+
				" from RENT_CONT a, RENT_FEE b, RENT_CUST c, CLIENT d, USERS e, CONT_N_VIEW f, CAR_NM h, RENT_SETTLE j, CAR_MNG k  , car_etc ce, car_reg cr  \n"+
				" where a.rent_s_cd=b.rent_s_cd(+) and a.cust_id=c.cust_id(+) and a.cust_id=d.client_id(+) and a.cust_id=e.user_id(+)"+
				" and a.car_mng_id=f.car_mng_id  and f.car_mng_id = cr.car_mng_id  and nvl(f.use_yn,'Y')='Y' \n"+
				"        and f.rent_mng_id = ce.rent_mng_id(+) and f.rent_l_cd = ce.rent_l_cd(+) \n"+
				"        and ce.car_id=h.car_id(+) and ce.car_seq=h.car_seq(+) and h.car_comp_id=k.car_comp_id and h.car_cd=k.code \n" +
				" and a.rent_s_cd=j.rent_s_cd(+)";
		
		if(brch_id.equals("S1"))								query += " and a.brch_id in ('S1','K1')";
		if(brch_id.equals("S2"))								query += " and a.brch_id='S2'";
		if(brch_id.equals("B1"))								query += " and a.brch_id in ('B1','N1')";
		if(brch_id.equals("D1"))								query += " and a.brch_id='D1'";

		if(!bus_id.equals(""))									query += " and a.bus_id='"+bus_id+"'";		

		if(gubun1.equals("1"))									query += " and "+search1+" like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun1.equals("2"))								query += " and "+search1+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun1.equals("3")){
			if(!start_dt.equals("") && !end_dt.equals(""))		query += " and "+search1+" between replace('"+start_dt+"00','-','') and replace('"+end_dt+"24','-','')";
			else if(!start_dt.equals("") && end_dt.equals(""))	query += " and "+search1+" like '"+start_dt+"%'";
		}

		//취소된거는 뺀다.
		query += " and nvl(a.use_st,'5')<>'5'";
		 
		query += " order by "+search1;

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
			System.out.println("[ResSearchDatabase:getResPlanList]"+e);
			System.out.println("[ResSearchDatabase:getResPlanList]"+query);
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
	 *	단기대여요금 연체료 계산
	 */
	public boolean calDelay(String s_cd) throws SQLException
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;

		//연체일 있는 경우(입금:입금일>입금예정일, 미입금:현재날자>입금예정일)
		String query1 = "";
		query1= " UPDATE scd_rent SET"+
				" dly_days=TRUNC(NVL(TO_DATE(pay_dt, 'YYYYMMDD'), SYSDATE) - TO_DATE(est_dt, 'YYYYMMDD')),"+
				" dly_amt=decode(sign(rent_s_amt),1,(TRUNC(((rent_s_amt+rent_v_amt)*0.24*TRUNC(TO_DATE(est_dt, 'YYYYMMDD')- NVL(TO_DATE(pay_dt, 'YYYYMMDD'), SYSDATE)))/365) * -1))"+
				" WHERE rent_s_cd='"+s_cd+"' and rent_st not in ('6','7') and est_dt is not null "+
				" and SIGN(TRUNC(NVL(TO_DATE(pay_dt, 'YYYYMMDD'), SYSDATE) - TO_DATE(est_dt, 'YYYYMMDD'))) > 0";
	
		//연체일 없는 경우(입금:입금일=입금예정일, 입금일<입금예정일(선수), 미입금:현재날짜<입금예정일)
		String query2 = "";
		query2= " UPDATE scd_rent set"+
				" dly_days = '0',"+
				" dly_amt = 0"+
				" WHERE rent_s_cd='"+s_cd+"' and rent_st not in ('6','7') and est_dt is not null "+
				" and SIGN(TRUNC(NVL(TO_DATE(pay_dt, 'YYYYMMDD'), SYSDATE) - TO_DATE(est_dt, 'YYYYMMDD'))) < 1";


		try 
		{
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query1);
		    pstmt1.executeUpdate();
			pstmt1.close();

		    pstmt2 = conn.prepareStatement(query2);
		    pstmt2.executeUpdate();
			pstmt2.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[ResSearchDatabase:calDelay]\n"+e);
			System.out.println("[ResSearchDatabase:calDelay]\n"+query1);
			System.out.println("[ResSearchDatabase:calDelay]\n"+query2);
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
	 *	차량사진 크게보기
	 */
	public Hashtable getCarBinImg(String c_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select imgfile1, imgfile2, imgfile3, imgfile4, imgfile5"+
				" from apprsl"+
				" where car_mng_id='"+c_id+"'";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();


		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:getCarBinImg]"+e);
			System.out.println("[ResSearchDatabase:getCarBinImg]"+query);
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
	 *	차량사진 크게보기
	 */
	public Off_ls_pre_apprsl getCarBinImg2(String c_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Off_ls_pre_apprsl bean = new Off_ls_pre_apprsl();
		String query = "";

		query = " select imgfile1, imgfile2, imgfile3, imgfile4, imgfile5, imgfile6 "+
				" from apprsl"+
				" where car_mng_id='"+c_id+"'";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{				
				bean.setImgfile1(rs.getString("IMGFILE1"));
				bean.setImgfile2(rs.getString("IMGFILE2"));
				bean.setImgfile3(rs.getString("IMGFILE3"));
				bean.setImgfile4(rs.getString("IMGFILE4"));
				bean.setImgfile5(rs.getString("IMGFILE5"));
				bean.setImgfile6(rs.getString("IMGFILE6"));
			}
			rs.close();
			pstmt.close();


		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:getCarBinImg2]"+e);
			System.out.println("[ResSearchDatabase:getCarBinImg2]"+query);
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
	 *	차량사진 : apprsl 레코드 확인
	 */
	public int getApprslChk(String c_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		String query = "";

		query = " select count(0)"+
				" from apprsl"+
				" where car_mng_id='"+c_id+"'";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{				
				count = rs.getInt(1);
			}
			rs.close();
			pstmt.close();


		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:getApprslChk]"+e);
			System.out.println("[ResSearchDatabase:getApprslChk]"+query);
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

	/**
	 *	차량사진 등록하기
	 */
	public int insertApprsl(String c_id, String filename, String idx) throws SQLException
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";

		query = " update apprsl set imgfile"+idx+"='"+filename+"', img_dt=to_char(sysdate,'YYYYMMDD') where car_mng_id='"+c_id+"'";

		try {
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
	    	count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:insertApprsl]"+e);
			System.out.println("[ResSearchDatabase:insertApprsl]"+query);
			e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}	

	/**
	 *	차량사진 수정하기
	 */
	public int updateCarImg(String c_id, String filename, String idx) throws SQLException
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";

		query = " update apprsl set imgfile"+idx+"='"+filename+"', img_dt=to_char(sysdate,'YYYYMMDD') where car_mng_id='"+c_id+"'";

		try {
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
	    	count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:updateCarImg]"+e);
			System.out.println("[ResSearchDatabase:updateCarImg]"+query);
			e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}	

	/**
	 *	차량정보
	 */
	public Hashtable getCarInfo(String c_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select /*+ leading(A) index(a CAR_REG_IDX5) */ e.EXPORT_AMT, \n"+
				"        a.car_mng_id, a.car_no, k.car_nm, d.car_name, a.car_num, a.init_reg_dt, substr(a.init_reg_dt,1,4) car_year, b.dlv_dt, \n"+
				"        a.dpm, c.colo||decode(c.in_col,'','','(내장:'||c.in_col||')') as colo, \n"+
				"        c.opt, c.add_opt, d.car_comp_id, d.car_id, d.car_seq, d.section, '' max_dt, h.serv_dt, \n"+
				"        e.imgfile1, e.imgfile2, e.imgfile3, e.imgfile4, e.imgfile5, \n"+
				"        decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(b.dlv_dt,a.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(b.dlv_dt,a.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as today_dist, \n"+
				"        f2.nm fuel_kd, \n"+
				"        b.brch_id, f.code, a.car_end_dt, a.test_st_dt, a.test_end_dt, \n"+
				"        a.maint_st_dt, a.maint_end_dt, b.rent_dt, a.park, a.park_cont, nvl(a.m1_chk, 0) m1_chk, a.m1_dt,  \n"+
				"        p.fee_s_amt, round(p.fee_s_amt/30,-3) day_s_amt, "+
				"        p.fee_s_amt+p.fee_v_amt as fee_amt, round((p.fee_s_amt+p.fee_v_amt)/30,-3) day_amt, "+
				"        a.car_use, d.section, b.car_st, b.rent_mng_id, b.rent_l_cd, a.secondhand, d.car_b, c.opt, a.rm_st, a.rm_cont, a.checker, a.check_dt, "+
				"        nvl(g.mng_br_id,b.brch_id) mng_br_id  \n"+
				" from   CAR_REG a, CONT b, CAR_ETC c, CAR_NM d, APPRSL e, \n"+
				"        (select * from code where c_st='0001' and code<>'0000') f, \n"+
				"        (select * from code where c_st='0039') f2, \n"+
				"        CAR_MNG k, v_tot_dist vt, cont_etc g, \n"+
				"        (select a.car_mng_id, a.serv_dt, a.tot_dist from SERVICE a where a.serv_dt||a.serv_id=(select max(serv_dt||serv_id) from service where car_mng_id=a.car_mng_id and tot_dist > 0)) h,  \n"+
                //일반대차요금
				"        ( select a.*  \n"+
				"          from   estimate_sh a,  \n"+
				"                 (select est_ssn, max(est_id) est_id from estimate_sh where est_ssn='"+c_id+"' and est_from ='res_car' and est_fax='Y' and rent_dt like to_char(sysdate,'YYYYMM')||'%' group by est_ssn ) b  \n"+
				"          where  a.est_ssn='"+c_id+"' and a.est_from ='res_car' and a.est_fax='Y' and a.rent_dt like to_char(sysdate,'YYYYMM')||'%' and  a.est_ssn=b.est_ssn and a.est_id=b.est_id "+
				"	     ) p  \n"+
				" where  \n"+
					" a.car_mng_id=b.car_mng_id \n"+
					" and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd \n"+
					" and c.car_id=d.car_id and c.car_seq=d.car_seq and d.car_comp_id=k.car_comp_id and d.car_cd=k.code \n"+
					" and d.car_comp_id=f.code  \n"+
					" and a.fuel_kd=f2.nm_cd \n"+
					" and a.car_mng_id=vt.car_mng_id(+) \n"+
					" and a.car_mng_id=e.car_mng_id(+) \n"+
					" and a.car_mng_id=h.car_mng_id(+) \n"+
					" and a.car_mng_id=p.est_ssn(+) \n"+						
					" and b.rent_mng_id=g.rent_mng_id and b.rent_l_cd=g.rent_l_cd \n"+
					" and a.car_mng_id='"+c_id+"' \n"+
					" order by DECODE(b.car_st,'2',0,1), b.reg_dt desc" ;


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:getCarInfo]"+e);
			System.out.println("[ResSearchDatabase:getCarInfo]"+query);
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
	 *	차량별 예약현황 리스트
	 */
	public Vector getResCarList(String c_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select g.car_no, g.first_car_no, a.rent_s_cd, a.com_emp_yn,"+
				" decode(a.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','장기대기','12','월렌트') rent_st,"+
				" decode(a.use_st,'1','예약','2','배차','3','반차','4','종료','5','취소') use_st,"+
				" nvl(a.deli_dt,a.rent_start_dt) deli_dt, nvl(a.ret_dt,a.ret_plan_dt) ret_dt,"+
				" nvl(a.deli_dt,a.rent_start_dt) rent_start_dt, nvl(nvl(a.ret_dt,a.ret_plan_dt),a.rent_end_dt) rent_end_dt,"+
				" a. rent_hour, (b.fee_s_amt+b.fee_v_amt) fee_amt,"+
				" decode(a.cust_st, '','조성희', '1',e.client_nm, '4',f.user_nm, d.cust_nm) cust_nm,"+
				" decode(a.cust_st, '','(주)아마존카', '1',e.firm_nm, '4','(주)아마존카', d.firm_nm) firm_nm,"+
				" decode(a.cust_st, '','', '1',TEXT_DECRYPT(e.ssn, 'pw' ) , '4', TEXT_DECRYPT(f.user_ssn, 'pw' ) , d.ssn) ssn,"+
				" decode(a.cust_st, '','', '1',e.enp_no, '4','', d.enp_no) enp_no, "+
				" f2.user_nm as bus_nm, g2.car_no as d_car_no, g2.car_nm as d_car_nm, a.reg_dt, f3.user_nm as reg_nm, f4.user_nm as mng_nm "+
				" from RENT_CONT a, RENT_FEE b, RENT_SETTLE c, RENT_CUST d, CLIENT e, users f, car_reg g, users f2, car_reg g2, users f3, users f4 "+
				" where "+
				" a.car_mng_id='"+c_id+"'"+
				" and a.rent_s_cd=b.rent_s_cd(+) and a.rent_s_cd=c.rent_s_cd(+)"+
				" and a.cust_id=d.cust_id(+) and a.cust_id=e.client_id(+) and a.cust_id=f.user_id(+)"+
				" and a.car_mng_id=g.car_mng_id"+
				" and a.bus_id=f2.user_id(+)"+
				" and a.sub_c_id=g2.car_mng_id(+)"+
				" and a.reg_id=f3.user_id(+)"+
				" and a.mng_id=f4.user_id(+)"+
				" order by a.rent_start_dt desc, a.rent_s_cd desc";


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
			System.out.println("[ResSearchDatabase:getResCarList]"+e);
			System.out.println("[ResSearchDatabase:getResCarList]"+query);
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
	 *	차량별 예약현황 리스트
	 */
	public Vector getResCarCauCarList(String c_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select g.car_no, g.first_car_no, a.rent_s_cd,"+
				" decode(a.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','장기대기','12','월렌트') rent_st,"+
				" decode(a.use_st,'1','예약','2','배차','3','반차','4','종료','5','취소') use_st,"+
				" nvl(a.deli_dt,a.rent_start_dt) deli_dt, nvl(a.ret_dt,a.ret_plan_dt) ret_dt,"+
				" nvl(a.deli_dt,a.rent_start_dt) rent_start_dt, nvl(nvl(a.ret_dt,a.ret_plan_dt),a.rent_end_dt) rent_end_dt,"+
				" a. rent_hour, (b.fee_s_amt+b.fee_v_amt) fee_amt,"+
				" decode(a.cust_st, '','조성희', '1',e.client_nm, '4',f.user_nm, d.cust_nm) cust_nm,"+
				" decode(a.cust_st, '','(주)아마존카', '1',e.firm_nm, '4','(주)아마존카', d.firm_nm) firm_nm,"+
				" decode(a.cust_st, '','', '1', TEXT_DECRYPT(e.ssn, 'pw' ) , '4', TEXT_DECRYPT(f.user_ssn, 'pw' )  , d.ssn) ssn,"+
				" decode(a.cust_st, '','', '1',e.enp_no, '4','', d.enp_no) enp_no, f2.user_nm as bus_nm, g2.car_no as d_car_no, g2.car_nm as d_car_nm, a.reg_dt, f3.user_nm as reg_nm "+
				" from RENT_CONT a, RENT_FEE b, RENT_SETTLE c, RENT_CUST d, CLIENT e, users f, car_reg g, users f2, car_reg g2, users f3"+
				" where "+
				" a.car_mng_id||a.sub_c_id like '%"+c_id+"%'"+
				" and a.rent_s_cd=b.rent_s_cd(+) and a.rent_s_cd=c.rent_s_cd(+)"+
				" and a.cust_id=d.cust_id(+) and a.cust_id=e.client_id(+) and a.cust_id=f.user_id(+)"+
				" and a.car_mng_id=g.car_mng_id"+
				" and a.bus_id=f2.user_id"+
				" and a.sub_c_id=g2.car_mng_id(+)"+
				" and a.rent_st||a.use_st<>'115'"+
				" and a.reg_id=f3.user_id(+)"+
				" order by a.rent_s_cd desc";


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
			System.out.println("[ResSearchDatabase:getResCarList]"+e);
			System.out.println("[ResSearchDatabase:getResCarList]"+query);
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
	 *	차량별 운행현황 리스트
	 */
	public Vector getResCarScdList(String c_id, String dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select "+
				" decode(a.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','장기대기','12','월렌트') rent_st,"+
				" decode(a.use_st,'1','예약','2','배차','3','반차','4','종료','5','취소') use_st, a.rent_s_cd, nvl(a.deli_dt,a.deli_plan_dt) deli_dt, nvl(a.ret_dt,a.ret_plan_dt) ret_dt,"+
				" decode(a.cust_st, '','조성희', '1',e.client_nm, '4',f.user_nm, d.cust_nm) cust_nm,"+
				" decode(a.cust_st, '','(주)아마존카', '1',e.firm_nm, '4','(주)아마존카', d.firm_nm) firm_nm"+
				" from RENT_CONT a, SCD_CAR b, RENT_CUST d, CLIENT e, users f"+
				" where "+
				" a.rent_s_cd=b.rent_s_cd(+)"+
				" and a.cust_id=d.cust_id(+) and a.cust_id=e.client_id(+) and a.cust_id=f.user_id(+)"+
				" and a.car_mng_id='"+c_id+"' and b.dt='"+dt+"'"+
				" order by a.rent_s_cd";

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
			System.out.println("[ResSearchDatabase:getResCarScdList]"+e);
			System.out.println("[ResSearchDatabase:getResCarScdList]"+query);
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
	 *	차량별 운행현황 리스트
	 */
	public Vector getRentCarScdList(String c_id, String s_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select * from SCD_CAR where car_mng_id='"+c_id+"' and rent_s_cd='"+s_cd+"'"+
				" order by dt";

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
			System.out.println("[ResSearchDatabase:getRentCarScdList]"+e);
			System.out.println("[ResSearchDatabase:getRentCarScdList]"+query);
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
	 *	동급차량 예약현황 리스트
	 */
	public Vector getResCarList(String car_comp_id, String car_id, String car_year)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select "+
				" decode(a.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','장기대기','12','월렌트') rent_st,"+
				" decode(a.use_st,'1','예약','2','배차','3','반차','4','종료','5','취소') use_st,"+
				" nvl(a.deli_dt,a.rent_start_dt) rent_start_dt, nvl(nvl(a.ret_dt,a.ret_plan_dt),a.rent_end_dt) rent_end_dt, a. rent_hour, (b.fee_s_amt+b.fee_v_amt) fee_amt,"+
				" decode(a.cust_st, '','조성희', '1',e.client_nm, '4',j.user_nm, d.cust_nm) cust_nm,"+
				" decode(a.cust_st, '','(주)아마존카', '1',e.firm_nm, '4','(주)아마존카', d.firm_nm) firm_nm,"+
				" f.car_no"+
				" from RENT_CONT a, RENT_FEE b, RENT_SETTLE c, RENT_CUST d, CLIENT e, CAR_REG f, CONT g, CAR_ETC h, CAR_NM i, USERS j"+
				" where "+
				" a.rent_s_cd=b.rent_s_cd(+) and a.rent_s_cd=c.rent_s_cd(+)"+
				" and a.cust_id=d.cust_id(+) and a.cust_id=e.client_id(+) and a.cust_id=j.user_id(+)"+
				" and a.car_mng_id=f.car_mng_id"+
				" and a.car_mng_id=g.car_mng_id and nvl(g.use_yn,'Y')='Y'"+
				" and g.rent_mng_id=h.rent_mng_id and g.rent_l_cd=h.rent_l_cd"+
				" and h.car_id=i.car_id"+
				" and i.car_comp_id='"+car_comp_id+"' and i.car_id='"+car_id+"' and f.init_reg_dt like '"+car_year+"%'"+
				" order by a.rent_start_dt desc";

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
			System.out.println("[ResSearchDatabase:getResCarList]"+e);
			System.out.println("[ResSearchDatabase:getResCarList]"+query);
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
	 *	예약가능 날짜 조회
	 */
	public boolean getResSearchDate(String c_id, String search_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		boolean flag = true;
		int count = 0;
		String query = "";

		query = " select count(0) from scd_car a, rent_cont b where a.rent_s_cd=b.rent_s_cd and b.rent_st<>'4'"+
				" and a.car_mng_id='"+c_id+"' and a.dt='"+search_dt+"' and time is null";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{				
				count = rs.getInt(1);
			}
			if(count > 0)	flag = false;
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:getResSearchDate]"+e);
			System.out.println("[ResSearchDatabase:getResSearchDate]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}	

	/**
	 *	사고대차리스트
	 */
	public Vector getAccidCarList(String c_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

       	String query =	" select  a.rent_mng_id, a.rent_l_cd, a.firm_nm, a.client_nm, cr.car_no, b.car_mng_id,"+
						" b.accid_id, decode(b.accid_st, '1','피해자', '2','가해자', '3','쌍방', '4','운행자차', '5','사고자차', '7','재리스수리', '6','수해', ' ') accid_st, accid_st as accid_st2,"+
						" c.serv_id, d.off_nm, decode(b.accid_st, '2', b.ot_car_no, cr.car_no) p_car_no,"+
						" decode(b.accid_st, '2', b.ot_car_nm, b.our_car_nm) p_car_nm, "+
						" decode(b.accid_st, '2', b.ot_num, b.our_num) p_num, "+
						" decode(b.accid_st, '2', b.our_ins, b.ot_ins) g_ins, "+
						" decode(b.accid_st, '2', b.mat_nm, b.ot_ins_nm) g_ins_nm, "+
						" b.our_driver, substr(b.accid_dt,1,8) accid_dt, b.accid_addr, b.accid_cont, b.accid_cont2,"+
						" decode(b.sub_rent_gu, '1','출고전대차', '2','단기대여', '3','기타', ' ') sub_rent_gu, b.sub_firm_nm, b.reg_id, nvl(e.cnt,0) cnt, "+
						" z.age_scp "+
						" from   accident b, cont_n_view a, service c, serv_off d, car_reg cr, "+
						"        (select sub_c_id, accid_id, count(0) cnt from rent_cont where use_st<>'5' group by sub_c_id, accid_id) e, "+
						"        (select * from insur where ins_sts='1' and ins_exp_dt > to_char(sysdate,'YYYYMMDD')) z \n"+
						" where b.car_mng_id = '" + c_id + "' "+
						"        and b.car_mng_id=a.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
						"        and b.car_mng_id=c.car_mng_id(+) and b.accid_id=c.accid_id(+) and c.off_id=d.off_id(+)"+
						"        and b.car_mng_id=e.sub_c_id(+) and b.accid_id=e.accid_id(+)"+
						"        and a.car_mng_id=z.car_mng_id(+) and b.car_mng_id = cr.car_mng_id \n"+
						" order by b.accid_dt";

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
			System.out.println("[ResSearchDatabase:getAccidCarList]"+e);
			System.out.println("[ResSearchDatabase:getAccidCarList]"+query);
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
	 *	정비대차 정보
	 */
	public Hashtable getInfoServ(String c_id, String serv_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		if(!serv_id.equals("")){
			query = " select"+
					" a.car_mng_id, a.serv_dt, nvl(b.off_nm,'') off_nm, c.car_no, c.car_nm"+
					" from SERVICE a, SERV_OFF b, CAR_REG c"+
					" where a.off_id=b.off_id(+) and a.car_mng_id=c.car_mng_id"+
					" and a.car_mng_id='"+c_id+"' and a.serv_id='"+serv_id+"'";
		}else{
			query = " select"+
					" c.car_mng_id, '' serv_dt, '' off_nm, c.car_no, c.car_nm"+
					" from CAR_REG c"+
					" where c.car_mng_id='"+c_id+"'";
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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:getInfoServ]"+e);
			System.out.println("[ResSearchDatabase:getInfoServ]"+query);
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
	 *	차량점검 정보
	 */
	public Hashtable getInfoMaint(String c_id, String maint_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select * from car_maint where car_mng_id='"+c_id+"' and seq_no='"+maint_id+"'";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:getInfoMaint]"+e);
			System.out.println("[ResSearchDatabase:getInfoMaint]"+query);
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
	 *	사고대차 정보
	 */
	public Hashtable getInfoAccid(String c_id, String accid_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
       	String query =	"";
		
		if(!accid_id.equals("")){
			query = " select  a.rent_mng_id, a.rent_l_cd, a.firm_nm, a.client_nm, cr.car_no, cr.car_nm, b.car_mng_id,"+
						" b.accid_id, decode(b.accid_st, '1','피해자', '2','가해자', '3','쌍방', '4','자차사고', ' ') accid_st,"+
						" c.serv_id, d.off_nm, decode(b.accid_st, '2', b.ot_car_no, cr.car_no) p_car_no,"+
						" decode(b.accid_st, '2', b.ot_car_nm, b.our_car_nm) p_car_nm, "+
						" decode(b.accid_st, '2', b.ot_num, b.our_num) p_num, "+
						" decode(b.accid_st, '2', b.our_ins, b.ot_ins) g_ins, "+
						" decode(b.accid_st, '2', b.mat_nm, b.ot_ins_nm) g_ins_nm, "+
						" b.our_driver, substr(b.accid_dt,1,8) accid_dt, b.accid_addr, b.accid_cont, b.accid_cont2,"+
						" decode(b.sub_rent_gu, '1','출고전대차', '2','단기대여', '3','기타', ' ') sub_rent_gu, b.sub_firm_nm, b.reg_id"+
						" from cont_n_view a, accident b, service c, serv_off d, car_reg cr "+
						" where a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
						" and b.car_mng_id=c.car_mng_id(+) and b.accid_id=c.accid_id(+) and c.off_id=d.off_id(+)"+
						" and b.car_mng_id = cr.car_mng_id and a.car_mng_id='"+c_id+"' and b.accid_id='"+accid_id+"'"+
						" order by b.accid_dt";
		}else{
			query = " select a.rent_mng_id, a.rent_l_cd, a.firm_nm, a.client_nm, cr.car_no, cr.car_nm, a.car_mng_id,"+
						" '' accid_id, '' accid_st,"+
						" '' serv_id, '' off_nm, '' p_car_no,"+
						" '' p_car_nm, "+
						" '' p_num, "+
						" '' g_ins, "+
						" '' g_ins_nm, "+
						" '' our_driver, '' accid_dt, '' accid_addr, '' accid_cont, '' accid_cont2,"+
						" '' sub_rent_gu, '' sub_firm_nm, '' reg_id"+
						" from cont_n_view a , car_reg cr "+
						" where a.car_mng_id = cr.car_mng_id(+) and  a.car_mng_id='"+c_id+"' and nvl(a.use_yn,'Y')='Y'";
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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:getInfoAccid]"+e);
			System.out.println("[ResSearchDatabase:getInfoAccid]"+query);
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
	 *	사고대차 정보
	 */
	public Hashtable getInfoAccid(String c_id, String accid_id, String seq_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
       	String query =	"";
		
		if(!accid_id.equals("")){
			query = " select  a.rent_mng_id, a.rent_l_cd, a.firm_nm, a.client_nm, cr.car_no, cr.car_nm, b.car_mng_id,"+
						"        b.accid_id, decode(b.accid_st, '1','피해자', '2','가해자', '3','쌍방', '4','자차사고', ' ') accid_st,"+
						"        c.serv_id, d.off_nm, decode(b.accid_st, '2', b.ot_car_no, cr.car_no) p_car_no,"+
						"        decode(b.accid_st, '2', b.ot_car_nm, b.our_car_nm) p_car_nm, "+
						"        nvl(e.ins_num,decode(b.accid_st, '2', b.ot_num, b.our_num)) p_num, "+
						"        nvl(e.ins_com,decode(b.accid_st, '2', b.our_ins, b.ot_ins)) g_ins, "+
						"        decode(b.accid_st, '2', b.mat_nm, b.ot_ins_nm) g_ins_nm, "+
						"        b.our_driver, substr(b.accid_dt,1,8) accid_dt, b.accid_addr, b.accid_cont, b.accid_cont2,"+
						"        decode(b.sub_rent_gu, '1','출고전대차', '2','단기대여', '3','기타', ' ') sub_rent_gu, b.sub_firm_nm, b.reg_id"+
						" from   accident b, cont_n_view a, service c, serv_off d, my_accid e, car_reg cr "+
						" where  b.car_mng_id='"+c_id+"' and b.accid_id='"+accid_id+"'"+
						" and    b.car_mng_id=a.car_mng_id and b.rent_mng_id=a.rent_mng_id and b.rent_l_cd=a.rent_l_cd"+
						" and    b.car_mng_id=c.car_mng_id(+) and b.accid_id=c.accid_id(+) and c.off_id=d.off_id(+)"+
						" and    b.car_mng_id = cr.car_mng_id and b.car_mng_id=e.car_mng_id and b.accid_id=e.accid_id and e.seq_no='"+seq_no+"'"+
						" order by b.accid_dt";
		}else{
			query = " select a.rent_mng_id, a.rent_l_cd, a.firm_nm, a.client_nm, cr.car_no, cr.car_nm, a.car_mng_id,"+
						" '' accid_id, '' accid_st,"+
						" '' serv_id, '' off_nm, '' p_car_no,"+
						" '' p_car_nm, "+
						" '' p_num, "+
						" '' g_ins, "+
						" '' g_ins_nm, "+
						" '' our_driver, '' accid_dt, '' accid_addr, '' accid_cont, '' accid_cont2,"+
						" '' sub_rent_gu, '' sub_firm_nm, '' reg_id"+
						" from cont_n_view a, car_reg cr "+
						" where a.car_mng_id = cr.car_mng_id(+) and a.car_mng_id='"+c_id+"' and nvl(a.use_yn,'Y')='Y'";
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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:getInfoAccid]"+e);
			System.out.println("[ResSearchDatabase:getInfoAccid]"+query);
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

	// 단기거래처 관리--------------------------------------------------------------------------------------------------------------
	
	//고객 리스트 조회 (gubun - 1:상호, 2:계약자명, 3:주민(사업자)등록번호)
	public Vector getClientList(String rent_st, String cust_st, String h_con, String h_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String l_query = "";

		if(rent_st.equals("1") || rent_st.equals("9") || rent_st.equals("11") || rent_st.equals("12")){//단기대여-고객리스트


			if(cust_st.equals("4")){

				l_query = " select 'u' GUBUN, '직원' AS CUST_ST,"+
						" user_id AS CUST_ID, '' site_id, user_nm AS CUST_NM, '(주)아마존카' AS FIRM_NM,"+
						" decode(TEXT_DECRYPT(user_ssn, 'pw' )  ,'','',substr(TEXT_DECRYPT(user_ssn, 'pw' ),1,6)||'-'||substr(TEXT_DECRYPT(user_ssn, 'pw' ),7,7)) AS SSN,"+
						" '' AS ENP_NO,"+
						" '' LIC_NO, '' LIC_ST, user_h_tel AS TEL, user_m_tel M_TEL, ZIP AS ZIP, ADDR AS ADDR,"+
						" '' RANK, '' CAR_NO, '' CAR_NM, '' CAR_NAME, '' CAR_MNG_ID, '' RENT_L_CD, user_email as agnt_email, use_yn, '' mng_id, '' mng_nm, ven_code, "+
						" '' car_st, '' rent_way, '' twomon_yn, '' rent_start_dt, '' MAINT_ST_DT, '' MAINT_END_DT, '' CAR_END_DT, '' TEST_ST_DT, '' TEST_END_DT, '' rent_dt "+
						" from USERS";

				if(h_con.equals("1"))		l_query += " where nvl('(주)아마존카', ' ') like '%"+h_wd+"%'";
				else if(h_con.equals("2"))	l_query += " where nvl(user_nm, ' ') like '%"+h_wd+"%'";
				else if(h_con.equals("3"))	l_query += " where nvl(user_ssn, ' ') like '%"+h_wd+"%'";

				l_query += " order by use_yn desc, 6";

			}else{

				l_query = " select 'l' GUBUN, decode(a.CLIENT_ST, '1','법인','2','개인','3','개인사업자(일반과세)','4','개인사업자(간이과세)','5','개인사업자(면세사업자)') AS CUST_ST,"+
						  "        a.CLIENT_ID AS CUST_ID, '' site_id, a.CLIENT_NM AS CUST_NM, nvl(a.FIRM_NM, a.client_nm) AS FIRM_NM,"+
						  "        decode(TEXT_DECRYPT(a.ssn, 'pw' ) ,'','',substr(TEXT_DECRYPT(a.ssn, 'pw' ),1,6)||'-'||substr(TEXT_DECRYPT(a.ssn, 'pw' ),7,7)) AS SSN,"+
						  "        decode(a.ENP_NO,'','',substr(a.enp_no,1,3)||'-'||substr(a.enp_no,4,2)||'-'||substr(a.enp_no,6,5)) AS ENP_NO,"+
						  "        '' LIC_NO, '' LIC_ST, a.O_TEL AS TEL, a.M_TEL, a.O_ZIP AS ZIP, a.O_ADDR AS ADDR,"+
						  "        decode(a.RANK,'','일반','1','일반','2','우수','3','불량') RANK, '' CAR_NO, '' CAR_NM, '' CAR_NAME, '' CAR_MNG_ID, '' RENT_L_CD, "+
						  "        a.con_agnt_email as agnt_email, '' use_yn, "+
						  "        decode(b.mng_id,'',d.mng_id,decode(c.dept_id,'0001','',b.mng_id)) as mng_id, "+
						  "        decode(b.mng_id,'',e.user_nm,decode(c.dept_id,'0001','',c.user_nm)) as mng_nm, "+
						  "        a.ven_code, '' car_st, '' rent_way, '' twomon_yn, '' rent_start_dt, '' MAINT_ST_DT, '' MAINT_END_DT, '' CAR_END_DT, '' TEST_ST_DT, '' TEST_END_DT, '' rent_dt  \n"+
						  " from   CLIENT a, "+
						  "	       (SELECT cust_id, max(mng_id) mng_id FROM RENT_CONT WHERE rent_st='12' AND use_st IN ('1','2') GROUP BY cust_id) b, users c, "+
						  "        (SELECT client_id, max(bus_id2) mng_id FROM CONT WHERE nvl(use_yn,'Y')='Y' and car_st in ('1','3') GROUP BY client_id) d, users e  "+
						  " where  a.client_id=b.cust_id(+) and b.mng_id=c.user_id(+) \n"+
						  "        and a.client_id=d.client_id(+) and d.mng_id=e.user_id(+) " ;

				if(h_con.equals("1"))		l_query += " and nvl(a.FIRM_NM, ' ') like '%"+h_wd+"%'";
				else if(h_con.equals("2"))	l_query += " and nvl(a.CLIENT_NM, ' ') like '%"+h_wd+"%'";
				else if(h_con.equals("3"))	l_query += " and nvl(TEXT_DECRYPT(a.ssn, 'pw' )||a.ENP_NO, ' ') like '%"+h_wd+"%'";

/*
				l_query += " union all \n"+
						" select 'l' GUBUN, decode(a.CLIENT_ST, '1','법인','2','개인','3','개인사업자(일반과세)','4','개인사업자(간이과세)','5','개인사업자(면세사업자)') AS CUST_ST, \n"+
						" a.CLIENT_ID AS CUST_ID, b.seq AS site_id, b.site_jang AS CUST_NM, b.r_site AS FIRM_NM, \n"+
						" decode(LENGTH(b.enp_no),13,substr(b.enp_no,1,6)||'-'||substr(b.enp_no,7,7)) AS SSN, \n"+
						" decode(LENGTH(b.enp_no),10,substr(b.enp_no,1,3)||'-'||substr(b.enp_no,4,2)||'-'||substr(b.enp_no,6,5)) AS ENP_NO, \n"+
						" '' LIC_NO, '' LIC_ST, b.tel AS TEL, '' M_TEL, ZIP AS ZIP, ADDR AS ADDR, \n"+
						" decode(a.RANK,'','일반','1','일반','2','우수','3','불량') RANK, '' CAR_NO, '' CAR_NM, '' CAR_NAME, '' CAR_MNG_ID, '' RENT_L_CD, b.agnt_email, '' use_yn \n"+
						" from CLIENT_SITE b, CLIENT a \n"+
                        " WHERE b.enp_no IS NOT NULL AND b.client_id=a.client_id";

				if(h_con.equals("1"))		l_query += " AND nvl(b.r_site, ' ') like '%"+h_wd+"%'";
				else if(h_con.equals("2"))	l_query += " AND nvl(b.site_jang, ' ') like '%"+h_wd+"%'";
				else if(h_con.equals("3"))	l_query += " AND nvl(b.enp_no, ' ') like '%"+h_wd+"%'";
*/

				l_query += " order by a.FIRM_NM";

			}

				query = l_query;


		}else{//대차-계약리스트 
			
			query = " select 'l' GUBUN, decode(CLIENT_ST, '1','법인','2','개인','3','개인사업자(일반과세)','4','개인사업자(간이과세)','5','개인사업자(면세사업자)') AS CUST_ST,"+
					"        a.CLIENT_ID AS CUST_ID, '' site_id, a.CLIENT_NM AS CUST_NM, nvl(a.FIRM_NM, a.client_nm) AS FIRM_NM,"+
					"        decode(TEXT_DECRYPT(a.ssn, 'pw' ),'','',substr(TEXT_DECRYPT(a.ssn, 'pw' ),1,6)||'-'||substr(TEXT_DECRYPT(a.ssn, 'pw' ),7,7)) AS SSN,"+
					"        decode(a.ENP_NO,'','',substr(a.enp_no,1,3)||'-'||substr(a.enp_no,4,2)||'-'||substr(a.enp_no,6,5)) AS ENP_NO,"+
					"        '' LIC_NO, '' LIC_ST, O_TEL AS TEL, M_TEL, a.O_ZIP AS ZIP, a.O_ADDR AS ADDR,"+
					"        decode(a.RANK,'','일반','1','일반','2','우수','3','불량') RANK, c.CAR_NO, f.CAR_NM, e.CAR_NAME, c.CAR_MNG_ID, b.RENT_L_CD, "+
					"        b.use_yn, "+
					"        nvl(z.age_scp,decode(b.driving_age,'0','2','3','4','2','3',b.driving_age)) age_scp, "+
					"        a.con_agnt_email as agnt_email, '' mng_id, '' mng_nm, a.ven_code, b.car_st, g.rent_way, "+
					"        CASE WHEN TO_CHAR(ADD_MONTHS(TO_DATE(b.rent_start_dt,'YYYYMMDD'),2),'YYYYMMDD') < TO_CHAR(SYSDATE,'YYYYMMDD') THEN 'Y' ELSE 'N' END twomon_yn, "+
					"        b.rent_start_dt, c.MAINT_ST_DT, c.MAINT_END_DT, c.CAR_END_DT, c.TEST_ST_DT, c.TEST_END_DT, b.rent_dt  \n"+
					" from   CLIENT a, CONT b, CAR_REG c, car_etc d, car_nm e, car_mng f, \n"+
					"        ( select * from insur where ins_sts='1' and ins_exp_dt > to_char(sysdate,'YYYYMMDD')) z, \n"+
					"        fee g, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) h \n"+
					" where a.client_id=b.client_id "+
					"        and b.car_mng_id=c.car_mng_id(+)"+
					"        and b.rent_mng_id=d.rent_mng_id and b.rent_l_cd=d.rent_l_cd"+
					"        and d.car_id=e.car_id and d.car_seq=e.car_seq and e.car_comp_id=f.car_comp_id and e.car_cd=f.code"+
					"        and b.car_mng_id=z.car_mng_id(+) "+
					"        and b.rent_mng_id=g.rent_mng_id and b.rent_l_cd=g.rent_l_cd "+
					"        and g.rent_mng_id=h.rent_mng_id and g.rent_l_cd=h.rent_l_cd and g.rent_st=h.rent_st "+
					" ";
			
				if(rent_st.equals("10")) {
					query += " and b.rent_start_dt is null and nvl(b.use_yn,'Y')='Y' ";
				}


				if(h_con.equals("1"))		query += " and nvl(a.FIRM_NM, ' ') like '%"+h_wd+"%'";
				else if(h_con.equals("2"))	query += " and nvl(a.CLIENT_NM, ' ') like '%"+h_wd+"%'";
				else if(h_con.equals("3"))	query += " and nvl(a.ENP_NO, ' ') like '%"+h_wd+"%'";
				else if(h_con.equals("4"))	query += " and nvl(c.CAR_NO, ' ') like '%"+h_wd+"%'";

				l_query += " order by use_yn desc, 6";
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
			System.out.println("[ResSearchDatabase:getClientList]\n"+e);
			System.out.println("[ResSearchDatabase:getClientList]\n"+query);
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

	//고객 리스트 조회 (gubun - 1:상호, 2:계약자명, 3:주민(사업자)등록번호) - 에이전트 출고전대차 고객 - 본인 장기고객만 조회한다.
	public Vector getClientListA(String rent_st, String cust_st, String h_con, String h_wd, String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

			query = " select 'l' GUBUN, decode(CLIENT_ST, '1','법인','2','개인','3','개인사업자(일반과세)','4','개인사업자(간이과세)','5','개인사업자(면세사업자)') AS CUST_ST,"+
					"        a.CLIENT_ID AS CUST_ID, '' site_id, a.CLIENT_NM AS CUST_NM, nvl(a.FIRM_NM, a.client_nm) AS FIRM_NM,"+
					"        decode(TEXT_DECRYPT(a.ssn, 'pw' ),'','',substr(TEXT_DECRYPT(a.ssn, 'pw' ),1,6)||'-'||substr(TEXT_DECRYPT(a.ssn, 'pw' ),7,7)) AS SSN,"+
					"        decode(a.ENP_NO,'','',substr(a.enp_no,1,3)||'-'||substr(a.enp_no,4,2)||'-'||substr(a.enp_no,6,5)) AS ENP_NO,"+
					"        '' LIC_NO, '' LIC_ST, O_TEL AS TEL, M_TEL, a.O_ZIP AS ZIP, a.O_ADDR AS ADDR,"+
					"        decode(a.RANK,'','일반','1','일반','2','우수','3','불량') RANK, c.CAR_NO, f.CAR_NM, e.CAR_NAME, c.CAR_MNG_ID, b.RENT_L_CD, b.RENT_MNG_ID,"+
					"        b.use_yn, nvl(z.age_scp,decode(b.driving_age,'0','2','3','4','2','3',b.driving_age)) age_scp, a.con_agnt_email as agnt_email, '' mng_id, '' mng_nm, a.ven_code, g.rent_way, "+
					"        CASE WHEN TO_CHAR(ADD_MONTHS(TO_DATE(b.rent_start_dt,'YYYYMMDD'),2),'YYYYMMDD') < TO_CHAR(SYSDATE,'YYYYMMDD') THEN 'Y' ELSE 'N' END twomon_yn, "+
					"        b.rent_start_dt \n"+
					" from   CONT b, CLIENT a, CAR_REG c, car_etc d, car_nm e, car_mng f, \n"+
					"        ( select * from insur where ins_sts='1' and ins_exp_dt > to_char(sysdate,'YYYYMMDD')) z, \n"+
					"        fee g, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) h \n"+
					" where  b.bus_id='"+user_id+"' and a.client_id=b.client_id "+
					"        and b.car_mng_id=c.car_mng_id(+)"+
					"        and b.rent_mng_id=d.rent_mng_id and b.rent_l_cd=d.rent_l_cd"+
					"        and d.car_id=e.car_id and d.car_seq=e.car_seq and e.car_comp_id=f.car_comp_id and e.car_cd=f.code"+
					"        and b.car_mng_id=z.car_mng_id(+) "+
					"        and b.rent_mng_id=g.rent_mng_id and b.rent_l_cd=g.rent_l_cd "+
					"        and g.rent_mng_id=h.rent_mng_id and g.rent_l_cd=h.rent_l_cd and g.rent_st=h.rent_st "+
					" ";
			
				if(rent_st.equals("10")) {
					query += " and b.rent_start_dt is null and nvl(b.use_yn,'Y')='Y' ";
				}


				if(h_con.equals("1"))		query += " and nvl(a.FIRM_NM, ' ') like '%"+h_wd+"%'";
				else if(h_con.equals("2"))	query += " and nvl(a.CLIENT_NM, ' ') like '%"+h_wd+"%'";
				else if(h_con.equals("3"))	query += " and nvl(a.ENP_NO, ' ') like '%"+h_wd+"%'";
				else if(h_con.equals("4"))	query += " and nvl(c.CAR_NO, ' ') like '%"+h_wd+"%'";

					
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
			System.out.println("[ResSearchDatabase:getClientList]\n"+e);
			System.out.println("[ResSearchDatabase:getClientList]\n"+query);
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


	//사원 리스트 조회
	public Hashtable getUserList(String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		query = " select a.USER_NM AS CUST_NM, a.USER_ID AS CUST_ID, '(주)아마존카' AS FIRM_NM,"+
				" decode(TEXT_DECRYPT(a.USER_SSN, 'pw' ) , '','', substr(TEXT_DECRYPT(a.USER_SSN, 'pw' ),1,6)||'-'||substr(TEXT_DECRYPT(a.USER_SSN, 'pw' ),7,7)) SSN,"+
				" a.LIC_NO, '' LIC_ST, b.nm AS DEPT_NM, c.br_nm AS BRCH_NM,"+
				" '02-757-0802' TEL, a.USER_M_TEL AS M_TEL"+
				" from USERS a, code b, branch c"+
				" where b.c_st='0002' and a.dept_id=b.code and a.br_id=c.br_id"+
				" and nvl(a.USER_ID, ' ') like '%"+user_id+"%'";
				
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
			System.out.println("[ResSearchDatabase:getUserList]\n"+e);
			System.out.println("[ResSearchDatabase:getUserList]\n"+query);
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


	//단기고객 등록 주민등록번호 중복 체크
	public int checkSSN(String ssn)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;

		String query = "select count(0) from rent_cust where ssn=replace('"+ssn+"','-','')";

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
			System.out.println("[ResSearchDatabase:checkSSN]"+e);
			System.out.println("[ResSearchDatabase:checkSSN]"+query);
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

	//단기고객 등록 시 불량임차인 체크
	public int checkBadCust(String ssn)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;

		String query = "select count(0) from bad_cust where bc_ent_no=replace('"+ssn+"','-','')";

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
			System.out.println("[ResSearchDatabase:checkBadCust]"+e);
			System.out.println("[ResSearchDatabase:checkBadCust]"+query);
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
	
	//단기고객 정보 조회
	public RentCustBean getRentCustCase(String cust_st, String cust_id )
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		RentCustBean bean = new RentCustBean();
		String query = "";

		if(cust_st.equals("1")){//장기고객
			query = " select   'l' GUBUN,"+
					" decode(a.CLIENT_ST, '1','법인','2','개인','3','개인사업자(일반과세)','4','개인사업자(간이과세)','5','개인사업자(면세사업자)') AS CUST_ST,"+
					" a.CLIENT_ID AS CUST_ID, a.CLIENT_NM AS CUST_NM, nvl(a.FIRM_NM, a.client_nm) AS FIRM_NM,"+
					" decode(TEXT_DECRYPT(a.ssn, 'pw' ) ,'','',substr(TEXT_DECRYPT(a.ssn, 'pw' ),1,6)||'-'||substr(TEXT_DECRYPT(a.ssn, 'pw' ),7,7)) AS SSN,"+
					" decode(a.ENP_NO,'','',substr(a.enp_no,1,3)||'-'||substr(a.enp_no,4,2)||'-'||substr(a.enp_no,6,5)) AS ENP_NO,"+
					" '' LIC_NO, '' LIC_ST, a.O_TEL AS TEL, a.M_TEL, a.O_ZIP AS ZIP, a.O_ADDR AS ADDR, '' DEPT_NM, '' BRCH_NM, '' CAR_NO, '' CAR_NM, a.con_agnt_email as email "+
					" from CLIENT a"+
					" where a.client_id='"+cust_id+"'";
		}else if(cust_st.equals("4")){//직원
			query = " select 'u' GUBUN,"+
					" '직원' CUST_ST,"+
					" a.USER_ID AS CUST_ID, a.USER_NM AS CUST_NM, '(주)아마존카' AS FIRM_NM,"+
					" decode(TEXT_DECRYPT(a.USER_SSN, 'pw' ) , '','', substr(TEXT_DECRYPT(a.USER_SSN, 'pw' ),1,6)||'-'||substr(TEXT_DECRYPT(a.USER_SSN, 'pw' ),7,7)) SSN,"+
					" '' ENP_NO,"+
					" a.LIC_NO, '' LIC_ST, '02-757-0802' TEL, a.USER_M_TEL AS M_TEL, '' ZIP, '' ADDR, b.nm AS DEPT_NM, c.br_nm AS BRCH_NM, '' CAR_NO, '' CAR_NM, a.user_email as email "+
					" from USERS a, code b, branch c"+
					" where b.c_st='0002' and a.dept_id=b.code and a.br_id=c.br_id"+
					" and nvl(a.USER_ID, ' ') like '%"+cust_id+"%'";
		}else{
			query = " select decode(client_id,'','s','l') GUBUN,"+
					" decode(CUST_ST, '1','법인','2','개인','3','개인사업자(일반과세)','4','개인사업자(간이과세)','5','개인사업자(면세사업자)') AS CUST_ST,"+
					" CUST_ID, CUST_NM, FIRM_NM,"+
					" decode(length(SSN), 0,'', 13,substr(ssn,1,6)||'-'||substr(ssn,7,7), SSN) AS SSN,"+
					" decode(length(ENP_NO), 0,'', 10,substr(enp_no,1,3)||'-'||substr(enp_no,4,2)||'-'||substr(enp_no,6,5), ENP_NO) AS ENP_NO,"+
					" LIC_NO, decode(LIC_ST,'1','1종보통','2','2종보통','') LIC_ST, TEL, M_TEL, ZIP, ADDR, '' DEPT_NM, '' BRCH_NM, '' CAR_NO, '' CAR_NM, '' email "+
					" from RENT_CUST"+
					" where cust_id='"+cust_id+"'";
		}
				
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();		
			if(rs.next())
			{			
				 bean.setCust_id	(cust_id);
				 bean.setCust_st	(rs.getString(2)==null?"":rs.getString(2));
				 bean.setCust_nm	(rs.getString(4)==null?"":rs.getString(4));
				 bean.setFirm_nm	(rs.getString(5)==null?"":rs.getString(5));
				 bean.setSsn		(rs.getString(6)==null?"":rs.getString(6));
				 bean.setEnp_no		(rs.getString(7)==null?"":rs.getString(7));
				 bean.setLic_no		(rs.getString(8)==null?"":rs.getString(8));
				 bean.setLic_st		(rs.getString(9)==null?"":rs.getString(9));
				 bean.setTel		(rs.getString(10)==null?"":rs.getString(10));
				 bean.setM_tel		(rs.getString(11)==null?"":rs.getString(11));
				 bean.setZip		(rs.getString(12)==null?"":rs.getString(12));
				 bean.setAddr		(rs.getString(13)==null?"":rs.getString(13));
				 bean.setDept_nm	(rs.getString(14)==null?"":rs.getString(14));
				 bean.setBrch_nm	(rs.getString(15)==null?"":rs.getString(15));
				 bean.setCar_no		(rs.getString(16)==null?"":rs.getString(16));
				 bean.setCar_nm		(rs.getString(17)==null?"":rs.getString(17));
				 bean.setEmail		(rs.getString(18)==null?"":rs.getString(18));
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:getRentCustCase]\n"+e);
			System.out.println("[ResSearchDatabase:getRentCustCase]\n"+query);
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

	//단기고객 정보 조회
	public String getCustNmCase(String cust_st, String cust_id )
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String custNfirm_nm = "";
		String query = "";

		if(cust_st.equals("1")){//장기고객
			query = " select  a.CLIENT_NM AS CUST_NM, nvl(a.FIRM_NM, a.client_nm) AS FIRM_NM"+
					" from CLIENT a, CONT_N_VIEW b"+
					" where b.client_id=a.client_id and a.client_id='"+cust_id+"'";
		}else if(cust_st.equals("4")){//직원
			query = " select  a.USER_NM AS CUST_NM, '(주)아마존카' AS FIRM_NM"+
					" from USERS a, code b, branch c"+
					" where b.c_st='0002' and a.dept_id=b.code and a.br_id=c.br_id"+
					" and nvl(a.USER_ID, ' ') like '%"+cust_id+"%'";
		}else{
			query = " select CUST_NM, FIRM_NM"+
					" from RENT_CUST"+
					" where cust_id='"+cust_id+"'";
		}
				
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();		
			if(rs.next())
			{			
			  custNfirm_nm = rs.getString(2)+"/"+rs.getString(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:getCustNmCase]\n"+e);
			System.out.println("[ResSearchDatabase:getCustNmCase]\n"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return custNfirm_nm;
		}		
	}	
	
	//단기고객 리스트 조회
	public Vector getCustList(String s_kd, String t_wd, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = "select * from rent_cust";

		if(s_kd.equals("1"))		query += " where cust_nm like '%"+t_wd+"%' order by cust_nm "+asc;
		else if(s_kd.equals("2"))	query += " where firm_nm like '%"+t_wd+"%' order by firm_nm "+asc;
		else if(s_kd.equals("3"))	query += " where tel like '%"+t_wd+"%' order by tel "+asc;
		else if(s_kd.equals("4"))	query += " where m_tel like '%"+t_wd+"%' order by m_tel "+asc;
		else if(s_kd.equals("5"))	query += " where addr like '%"+t_wd+"%' order by addr "+asc;
				
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
			System.out.println("[ResSearchDatabase:getCustList]\n"+e);
			System.out.println("[ResSearchDatabase:getCustList]\n"+query);
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

	//단기고객 삽입
	public RentCustBean insertRentCust(RentCustBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;

		String id_sql = " select ltrim(to_char(to_number(MAX(cust_id))+1, '000000')) ID from RENT_CUST ";
		String cust_id="";
		try{
				pstmt = conn.prepareStatement(id_sql);
		    	rs = pstmt.executeQuery();
		    	while(rs.next())
		    	{
		    		cust_id=rs.getString(1)==null?"":rs.getString(1);
		    	}
				rs.close();
				pstmt.close();

		} catch (SQLException e) {
	  		e.printStackTrace();
	  	} catch (Exception e) {
	  		e.printStackTrace();
	  	}
	  	
		if(cust_id.equals(""))	cust_id = "000001";
		bean.setCust_id(cust_id);
		
		String query = " insert into RENT_CUST ( CUST_ID, CLIENT_ID, CUST_ST, CUST_NM, FIRM_NM, SSN, ENP_NO,"+
						" LIC_NO, LIC_ST, ZIP, ADDR, TEL, M_TEL,"+
						" EMAIL, ETC, RANK, REG_ID, REG_DT) values ("+
						" ?, ?, ?, ?, ?, replace(?,'-',''), replace(?,'-',''),"+
						" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, to_char(sysdate,'YYYYMMDD'))";		
		try 
		{
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query);
			pstmt1.setString(1,  bean.getCust_id	());
			pstmt1.setString(2,  bean.getClient_id	());
			pstmt1.setString(3,  bean.getCust_st	());
			pstmt1.setString(4,  bean.getCust_nm	());
			pstmt1.setString(5,  bean.getFirm_nm	());
			pstmt1.setString(6,  bean.getSsn		());
			pstmt1.setString(7,  bean.getEnp_no		());
			pstmt1.setString(8,  bean.getLic_no		());
			pstmt1.setString(9,  bean.getLic_st		());
			pstmt1.setString(10, bean.getZip		());
			pstmt1.setString(11, bean.getAddr		());
			pstmt1.setString(12, bean.getTel		());
			pstmt1.setString(13, bean.getM_tel		());
			pstmt1.setString(14, bean.getEmail		());
			pstmt1.setString(15, bean.getEtc		());
			pstmt1.setString(16, bean.getRank		());
			pstmt1.setString(17, bean.getReg_id		());
		    pstmt1.executeUpdate();
			pstmt1.close();

			conn.commit();
		    
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:insertRentCust]\n"+e);
	  		e.printStackTrace();
			conn.rollback();
	  	} catch (Exception e) {
		  	System.out.println("[ResSearchDatabase:insertRentCust]\n"+e);
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
			return bean;
		}
	}

	//단기고객 수정
	public boolean updateRentCust(RentCustBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		
		String query = " update RENT_CUST set "+
						" CUST_ST=?, CUST_NM=?, FIRM_NM=?, SSN=replace(?,'-',''), ENP_NO=replace(?,'-',''),"+
						" LIC_NO=?, LIC_ST=?, ZIP=?, ADDR=?, TEL=?, M_TEL=?,"+
						" EMAIL=?, ETC=?, RANK=?, UPDATE_ID=?, UPDATE_DT=to_char(sysdate,'YYYYMMDD')"+
						" where CUST_ID = ?";		
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  bean.getCust_st	());
			pstmt.setString(2,  bean.getCust_nm	());
			pstmt.setString(3,  bean.getFirm_nm	());
			pstmt.setString(4,  bean.getSsn		());
			pstmt.setString(5,  bean.getEnp_no	());
			pstmt.setString(6,  bean.getLic_no	());
			pstmt.setString(7,  bean.getLic_st	());
			pstmt.setString(8,  bean.getZip		());
			pstmt.setString(9,  bean.getAddr	());
			pstmt.setString(10, bean.getTel		());
			pstmt.setString(11, bean.getM_tel	());
			pstmt.setString(12, bean.getEmail	());
			pstmt.setString(13, bean.getEtc		());
			pstmt.setString(14, bean.getRank	());
			pstmt.setString(15, bean.getUpdate_id());
			pstmt.setString(16, bean.getCust_id	());
		    pstmt.executeUpdate();
			pstmt.close();
		    
			conn.commit();
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:updateRentCust]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
	  	} catch (Exception e) {
			System.out.println("[ResSearchDatabase:updateRentCust]\n"+e);
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


	// 단기계약 관리--------------------------------------------------------------------------------------------------------------


	//단기계약 한건 조회
	public RentContBean getRentContCase(String s_cd, String c_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		RentContBean bean = new RentContBean();
		String query = "";

		query = " select * from RENT_CONT where rent_s_cd='"+s_cd+"'";

		if(!c_id.equals("")) query += " and car_mng_id='"+c_id+"'";


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
		
			if(rs.next())
			{				
				 bean.setRent_s_cd	(rs.getString(1)==null?"":rs.getString(1));
				 bean.setCar_mng_id	(rs.getString(2)==null?"":rs.getString(2));
				 bean.setRent_st	(rs.getString(3)==null?"":rs.getString(3));
				 bean.setCust_st	(rs.getString(4)==null?"":rs.getString(4));
				 bean.setCust_id	(rs.getString(5)==null?"":rs.getString(5));
				 bean.setSub_c_id	(rs.getString(6)==null?"":rs.getString(6));
				 bean.setAccid_id	(rs.getString(7)==null?"":rs.getString(7));
				 bean.setServ_id	(rs.getString(8)==null?"":rs.getString(8));
				 bean.setMaint_id	(rs.getString(9)==null?"":rs.getString(9));
				 bean.setRent_dt	(rs.getString(10)==null?"":rs.getString(10));
				 bean.setBrch_id	(rs.getString(11)==null?"":rs.getString(11));
				 bean.setBus_id		(rs.getString(12)==null?"":rs.getString(12));
				 bean.setRent_start_dt2(rs.getString(13)==null?"":rs.getString(13));
				 bean.setRent_end_dt2(rs.getString(14)==null?"":rs.getString(14));
				 bean.setRent_hour	(rs.getString(15)==null?"":rs.getString(15));
				 bean.setRent_days	(rs.getString(16)==null?"":rs.getString(16));
				 bean.setRent_months(rs.getString(17)==null?"":rs.getString(17));
				 bean.setEtc		(rs.getString(18)==null?"":rs.getString(18));
				 bean.setDeli_plan_dt2(rs.getString(19)==null?"":rs.getString(19));
				 bean.setRet_plan_dt2(rs.getString(20)==null?"":rs.getString(20));
				 bean.setDeli_dt2	(rs.getString(21)==null?"":rs.getString(21));
				 bean.setRet_dt2	(rs.getString(22)==null?"":rs.getString(22));
				 bean.setDeli_loc	(rs.getString(23)==null?"":rs.getString(23));
				 bean.setRet_loc	(rs.getString(24)==null?"":rs.getString(24));
				 bean.setDeli_mng_id(rs.getString(25)==null?"":rs.getString(25));
				 bean.setRet_mng_id	(rs.getString(26)==null?"":rs.getString(26));
				 bean.setUse_st		(rs.getString(27)==null?"":rs.getString(27));
				 bean.setSub_l_cd	(rs.getString(34)==null?"":AddUtil.replace(rs.getString(34)," ",""));
				 bean.setReg_id		(rs.getString(28)==null?"":rs.getString(28));
				 bean.setReg_dt		(rs.getString(29)==null?"":rs.getString(29));
				 bean.setUpdate_dt	(rs.getString(30)==null?"":rs.getString(30));
				 bean.setUpdate_id	(rs.getString(31)==null?"":rs.getString(31));
				 bean.setSite_id	(rs.getString(37)==null?"":rs.getString(37));
				 bean.setMng_id		(rs.getString(38)==null?"":rs.getString(38));
				 bean.setCls_st		(rs.getString(39)==null?"":rs.getString(39));
				 bean.setCls_dt		(rs.getString(40)==null?"":rs.getString(40));
				 bean.setCom_emp_yn	(rs.getString(41)==null?"":rs.getString(41));
				 bean.setIns_change_std_dt	(rs.getString(42)==null?"":rs.getString(42));
				 bean.setIns_change_flag	(rs.getString(43)==null?"":rs.getString(43));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:getRentContCase]\n"+e);
			System.out.println("[ResSearchDatabase:getRentContCase]\n"+query);
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
	
	//단기계약 한건 조회
	public RentContBean getRentContCase2(String s_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		RentContBean bean = new RentContBean();
		String query = "";

		query = " select * from RENT_CONT where rent_s_cd='"+s_cd+"' ";


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
		
			if(rs.next())
			{				
				 bean.setRent_s_cd	(rs.getString(1)==null?"":rs.getString(1));
				 bean.setCar_mng_id	(rs.getString(2)==null?"":rs.getString(2));
				 bean.setRent_st	(rs.getString(3)==null?"":rs.getString(3));
				 bean.setCust_st	(rs.getString(4)==null?"":rs.getString(4));
				 bean.setCust_id	(rs.getString(5)==null?"":rs.getString(5));
				 bean.setSub_c_id	(rs.getString(6)==null?"":rs.getString(6));
				 bean.setAccid_id	(rs.getString(7)==null?"":rs.getString(7));
				 bean.setServ_id	(rs.getString(8)==null?"":rs.getString(8));
				 bean.setMaint_id	(rs.getString(9)==null?"":rs.getString(9));
				 bean.setRent_dt	(rs.getString(10)==null?"":rs.getString(10));
				 bean.setBrch_id	(rs.getString(11)==null?"":rs.getString(11));
				 bean.setBus_id		(rs.getString(12)==null?"":rs.getString(12));
				 bean.setRent_start_dt2(rs.getString(13)==null?"":rs.getString(13));
				 bean.setRent_end_dt2(rs.getString(14)==null?"":rs.getString(14));
				 bean.setRent_hour	(rs.getString(15)==null?"":rs.getString(15));
				 bean.setRent_days	(rs.getString(16)==null?"":rs.getString(16));
				 bean.setRent_months(rs.getString(17)==null?"":rs.getString(17));
				 bean.setEtc		(rs.getString(18)==null?"":rs.getString(18));
				 bean.setDeli_plan_dt2(rs.getString(19)==null?"":rs.getString(19));
				 bean.setRet_plan_dt2(rs.getString(20)==null?"":rs.getString(20));
				 bean.setDeli_dt2	(rs.getString(21)==null?"":rs.getString(21));
				 bean.setRet_dt2	(rs.getString(22)==null?"":rs.getString(22));
				 bean.setDeli_loc	(rs.getString(23)==null?"":rs.getString(23));
				 bean.setRet_loc	(rs.getString(24)==null?"":rs.getString(24));
				 bean.setDeli_mng_id(rs.getString(25)==null?"":rs.getString(25));
				 bean.setRet_mng_id	(rs.getString(26)==null?"":rs.getString(26));
				 bean.setUse_st	(rs.getString(27)==null?"":rs.getString(27));
				 bean.setSub_l_cd	(rs.getString(34)==null?"":rs.getString(34));
				 bean.setReg_id		(rs.getString(28)==null?"":rs.getString(28));
				 bean.setReg_dt		(rs.getString(29)==null?"":rs.getString(29));
				 bean.setUpdate_dt	(rs.getString(30)==null?"":rs.getString(30));
				 bean.setUpdate_id	(rs.getString(31)==null?"":rs.getString(31));
				 bean.setSite_id	(rs.getString(37)==null?"":rs.getString(37));
				 bean.setMng_id		(rs.getString(38)==null?"":rs.getString(38));
				 bean.setCls_st		(rs.getString(39)==null?"":rs.getString(39));
				 bean.setCls_dt		(rs.getString(40)==null?"":rs.getString(40));

			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:getRentContCase2]\n"+e);
			System.out.println("[ResSearchDatabase:getRentContCase2]\n"+query);
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

	//예약 등록
	public RentContBean insertRentCont(RentContBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;

		//단기계약관리번호 생성
		String id_sql = " select ltrim(to_char(to_number(MAX(rent_s_cd))+1, '000000')) ID from RENT_CONT ";
		String rent_s_cd="";
		try{
			pstmt = conn.prepareStatement(id_sql);
	    	rs = pstmt.executeQuery();
	    	if(rs.next())
	    		rent_s_cd=rs.getString(1)==null?"":rs.getString(1);

			rs.close();
			pstmt.close();

		} catch (SQLException e) {
	  		e.printStackTrace();
	  	} catch (Exception e) {
	  		e.printStackTrace();
	  	}
	  	
		if(rent_s_cd.equals(""))	rent_s_cd = "000001";
		bean.setRent_s_cd(rent_s_cd);
		
		String query = "";
		query = " insert into RENT_CONT "+
				" ( rent_s_cd, car_mng_id, rent_st, cust_st, cust_id, sub_c_id, accid_id, serv_id, maint_id,"+
				" rent_dt, brch_id, bus_id, rent_start_dt, rent_end_dt, rent_hour, rent_days, rent_months, etc,"+
				" deli_plan_dt, ret_plan_dt, deli_dt, ret_dt, deli_loc, ret_loc, deli_mng_id, ret_mng_id, use_st,"+
				" reg_id, reg_dt, sub_l_cd, site_id, mng_id, com_emp_yn, ins_change_std_dt, ins_change_flag "+
				" ) values ("+
				" ?, ?, ?, ?, ?, ?, ?, ?, ?,"+//9
				" replace(?,'-',''), ?, ?, replace(?,'-',''), replace(?,'-',''), ?, ?, ?, ?,"+//9
				" replace(?,'-',''), replace(?,'-',''), replace(?,'-',''), replace(?,'-',''), ?, ?, ?, ?, ?,"+//9
				" ?, to_char(sysdate,'YYYYMMDDhh24miss'), ?, ?, ?, ?, replace(?,'-',''), ? "+//1
				" )";		
		try 
		{			
			
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query);
			pstmt1.setString(1,  bean.getRent_s_cd().trim()		);
			pstmt1.setString(2,  bean.getCar_mng_id().trim()	);
			pstmt1.setString(3,  bean.getRent_st().trim()		);
			pstmt1.setString(4,  bean.getCust_st().trim()		);
			pstmt1.setString(5,  bean.getCust_id().trim()		);
			pstmt1.setString(6,  bean.getSub_c_id().trim()		);
			pstmt1.setString(7,  bean.getAccid_id().trim()		);
			pstmt1.setString(8,  bean.getServ_id().trim()		);
			pstmt1.setString(9,  bean.getMaint_id().trim()		);
			pstmt1.setString(10, bean.getRent_dt().trim()		);
			pstmt1.setString(11, bean.getBrch_id().trim()		);
			pstmt1.setString(12, bean.getBus_id().trim()		);
			pstmt1.setString(13, bean.getRent_start_dt().trim()	);
			pstmt1.setString(14, bean.getRent_end_dt().trim()	);
			pstmt1.setString(15, bean.getRent_hour().trim()		);
			pstmt1.setString(16, bean.getRent_days().trim()		);
			pstmt1.setString(17, bean.getRent_months().trim()	);
			pstmt1.setString(18, bean.getEtc().trim()			);
			pstmt1.setString(19, bean.getDeli_plan_dt().trim()	);
			pstmt1.setString(20, bean.getRet_plan_dt().trim()	);
			pstmt1.setString(21, bean.getDeli_dt().trim()		);
			pstmt1.setString(22, bean.getRet_dt().trim()		);
			pstmt1.setString(23, bean.getDeli_loc().trim()		);
			pstmt1.setString(24, bean.getRet_loc().trim()		);
			pstmt1.setString(25, bean.getDeli_mng_id().trim()	);
			pstmt1.setString(26, bean.getRet_mng_id().trim()	);
			pstmt1.setString(27, bean.getUse_st().trim()		);
			pstmt1.setString(28, bean.getReg_id().trim()		);
			pstmt1.setString(29, bean.getSub_l_cd().trim()		);
			pstmt1.setString(30, bean.getSite_id().trim()		);
			pstmt1.setString(31, bean.getMng_id().trim()		);
			pstmt1.setString(32, bean.getCom_emp_yn().trim()    );
			pstmt1.setString(33, bean.getIns_change_std_dt().trim()    );
			pstmt1.setString(34, bean.getIns_change_flag().trim()    );
			pstmt1.executeUpdate();
			pstmt1.close();

			conn.commit();
		    
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:insertRentCont]\n"+e);
	  		e.printStackTrace();
			conn.rollback();
	  	} catch (Exception e) {
		  	System.out.println("[ResSearchDatabase:insertRentCont]\n"+e);

		  	System.out.println("[bean.getRent_s_cd().trim()			]\n"+bean.getRent_s_cd().trim()			);
		  	System.out.println("[bean.getCar_mng_id().trim()		]\n"+bean.getCar_mng_id().trim()		);
		  	System.out.println("[bean.getRent_st().trim()			]\n"+bean.getRent_st().trim()			);
		  	System.out.println("[bean.getCust_st().trim()			]\n"+bean.getCust_st().trim()			);
		  	System.out.println("[bean.getCust_id().trim()			]\n"+bean.getCust_id().trim()			);
		  	System.out.println("[bean.getSub_c_id().trim()			]\n"+bean.getSub_c_id().trim()			);
		  	System.out.println("[bean.getAccid_id().trim()			]\n"+bean.getAccid_id().trim()			);
		  	System.out.println("[bean.getServ_id().trim()			]\n"+bean.getServ_id().trim()			);
		  	System.out.println("[bean.getMaint_id().trim()			]\n"+bean.getMaint_id().trim()			);
		  	System.out.println("[bean.getRent_dt().trim()			]\n"+bean.getRent_dt().trim()			);
		  	System.out.println("[bean.getBrch_id().trim()			]\n"+bean.getBrch_id().trim()			);
		  	System.out.println("[bean.getBus_id().trim()			]\n"+bean.getBus_id().trim()			);
		  	System.out.println("[bean.getRent_start_dt().trim()		]\n"+bean.getRent_start_dt().trim()		);
		  	System.out.println("[bean.getRent_end_dt().trim()		]\n"+bean.getRent_end_dt().trim()		);
		  	System.out.println("[bean.getRent_hour().trim()			]\n"+bean.getRent_hour().trim()			);
		  	System.out.println("[bean.getRent_days().trim()			]\n"+bean.getRent_days().trim()			);
		  	System.out.println("[bean.getRent_months().trim()		]\n"+bean.getRent_months().trim()		);
		  	System.out.println("[bean.getEtc().trim()				]\n"+bean.getEtc().trim()				);
		  	System.out.println("[bean.getDeli_plan_dt().trim()		]\n"+bean.getDeli_plan_dt().trim()		);
		  	System.out.println("[bean.getRet_plan_dt().trim()		]\n"+bean.getRet_plan_dt().trim()		);
		  	System.out.println("[bean.getDeli_dt().trim()			]\n"+bean.getDeli_dt().trim()			);
		  	System.out.println("[bean.getRet_dt().trim()			]\n"+bean.getRet_dt().trim()			);
		  	System.out.println("[bean.getDeli_loc().trim()			]\n"+bean.getDeli_loc().trim()			);
		  	System.out.println("[bean.getRet_loc().trim()			]\n"+bean.getRet_loc().trim()			);
		  	System.out.println("[bean.getDeli_mng_id().trim()		]\n"+bean.getDeli_mng_id().trim()		);
		  	System.out.println("[bean.getRet_mng_id().trim()		]\n"+bean.getRet_mng_id().trim()		);
		  	System.out.println("[bean.getUse_st().trim()			]\n"+bean.getUse_st().trim()			);
		  	System.out.println("[bean.getReg_id().trim()			]\n"+bean.getReg_id().trim()			);
		  	System.out.println("[bean.getSub_l_cd().trim()			]\n"+bean.getSub_l_cd().trim()			);

	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(rs != null)		rs.close();
				if(pstmt != null)	pstmt.close();
				if(pstmt1 != null)	pstmt1.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}
	}

	//단기계약 수정
	public int updateRentCont(RentContBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;		
		String query = "";
		query = " update RENT_CONT set"+
				" cust_st=?, cust_id=?, sub_c_id=?, accid_id=?, serv_id=?, maint_id=?,"+//6
				" rent_dt=replace(?,'-',''), brch_id=?, bus_id=?,"+//3
				" rent_start_dt=replace(?,'-',''), rent_end_dt=replace(?,'-',''), rent_hour=?, rent_days=?, rent_months=?, etc=?,"+//6
				" deli_plan_dt=replace(?,'-',''), ret_plan_dt=replace(?,'-',''), deli_dt=replace(?,'-',''), ret_dt=replace(?,'-',''),"+//4
				" deli_loc=?, ret_loc=?, deli_mng_id=?, ret_mng_id=?, use_st=?,"+//5
				" update_id=?, update_dt=to_char(sysdate,'YYYYMMDD'), sub_l_cd=?, cls_st=?, cls_dt=replace(?,'-',''), mng_id=?, rent_st=?, ins_change_flag=? "+//2
				" where rent_s_cd=? and car_mng_id=?";//2=>27
		try 
		{			
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1,  bean.getCust_st().trim()		);
			pstmt.setString(2,  bean.getCust_id().trim()		);
			pstmt.setString(3,  bean.getSub_c_id().trim()		);
			pstmt.setString(4,  bean.getAccid_id().trim()		);
			pstmt.setString(5,  bean.getServ_id().trim()		);
			pstmt.setString(6,  bean.getMaint_id().trim()		);
			pstmt.setString(7,  bean.getRent_dt().trim()		);
			pstmt.setString(8,  bean.getBrch_id().trim()		);
			pstmt.setString(9,  bean.getBus_id().trim()			);
			pstmt.setString(10, bean.getRent_start_dt().trim()	);
			pstmt.setString(11, bean.getRent_end_dt().trim()	);
			pstmt.setString(12, bean.getRent_hour().trim()		);
			pstmt.setString(13, bean.getRent_days().trim()		);
			pstmt.setString(14, bean.getRent_months().trim()	);
			pstmt.setString(15, bean.getEtc().trim()			);
			pstmt.setString(16, bean.getDeli_plan_dt().trim()	);
			pstmt.setString(17, bean.getRet_plan_dt().trim()	);
			pstmt.setString(18, bean.getDeli_dt().trim()		);
			pstmt.setString(19, bean.getRet_dt().trim()			);
			pstmt.setString(20, bean.getDeli_loc().trim()		);
			pstmt.setString(21, bean.getRet_loc().trim()		);
			pstmt.setString(22, bean.getDeli_mng_id().trim()	);
			pstmt.setString(23, bean.getRet_mng_id().trim()		);
			pstmt.setString(24, bean.getUse_st().trim()			);
			pstmt.setString(25, bean.getReg_id().trim()			);
			pstmt.setString(26, bean.getSub_l_cd().trim()		);
			pstmt.setString(27, bean.getCls_st().trim()			);
			pstmt.setString(28, bean.getCls_dt().trim()			);
			pstmt.setString(29, bean.getMng_id().trim()			);
			pstmt.setString(30, bean.getRent_st().trim()		);
			pstmt.setString(31, bean.getIns_change_flag().trim());
			pstmt.setString(32, bean.getRent_s_cd().trim()		);
			pstmt.setString(33, bean.getCar_mng_id().trim()		);

			count = pstmt.executeUpdate();
			pstmt.close();
		    conn.commit();
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:updateRentCont]\n"+e);
			System.out.println("[bean.getCust_st().trim()			]\n"+bean.getCust_st().trim()			);
			System.out.println("[bean.getCust_id().trim()			]\n"+bean.getCust_id().trim()			);
			System.out.println("[bean.getSub_c_id().trim()			]\n"+bean.getSub_c_id().trim()			);
			System.out.println("[bean.getAccid_id().trim()			]\n"+bean.getAccid_id().trim()			);
			System.out.println("[bean.getServ_id().trim()			]\n"+bean.getServ_id().trim()			);
			System.out.println("[bean.getMaint_id().trim()			]\n"+bean.getMaint_id().trim()			);
			System.out.println("[bean.getRent_dt().trim()			]\n"+bean.getRent_dt().trim()			);
			System.out.println("[bean.getBrch_id().trim()			]\n"+bean.getBrch_id().trim()			);
			System.out.println("[bean.getBus_id().trim()			]\n"+bean.getBus_id().trim()			);
			System.out.println("[bean.getRent_start_dt().trim()		]\n"+bean.getRent_start_dt().trim()		);
			System.out.println("[bean.getRent_end_dt().trim()		]\n"+bean.getRent_end_dt().trim()		);
			System.out.println("[bean.getRent_hour().trim()			]\n"+bean.getRent_hour().trim()			);
			System.out.println("[bean.getRent_days().trim()			]\n"+bean.getRent_days().trim()			);
			System.out.println("[bean.getRent_months().trim()		]\n"+bean.getRent_months().trim()		);
			System.out.println("[bean.getEtc().trim()				]\n"+bean.getEtc().trim()				);
			System.out.println("[bean.getDeli_plan_dt().trim()		]\n"+bean.getDeli_plan_dt().trim()		);
			System.out.println("[bean.getRet_plan_dt().trim()		]\n"+bean.getRet_plan_dt().trim()		);
			System.out.println("[bean.getDeli_dt().trim()			]\n"+bean.getDeli_dt().trim()			);
			System.out.println("[bean.getRet_dt().trim()			]\n"+bean.getRet_dt().trim()			);
			System.out.println("[bean.getDeli_loc().trim()			]\n"+bean.getDeli_loc().trim()			);
			System.out.println("[bean.getRet_loc().trim()			]\n"+bean.getRet_loc().trim()			);
			System.out.println("[bean.getDeli_mng_id().trim()		]\n"+bean.getDeli_mng_id().trim()		);
			System.out.println("[bean.getRet_mng_id().trim()		]\n"+bean.getRet_mng_id().trim()		);
			System.out.println("[bean.getUse_st().trim()			]\n"+bean.getUse_st().trim()			);
			System.out.println("[bean.getReg_id().trim()			]\n"+bean.getReg_id().trim()			);
			System.out.println("[bean.getSub_l_cd().trim()			]\n"+bean.getSub_l_cd().trim()			);
			System.out.println("[bean.getRent_s_cd().trim()			]\n"+bean.getRent_s_cd().trim()			);
			System.out.println("[bean.getCar_mng_id().trim()		]\n"+bean.getCar_mng_id().trim()		);

	  		e.printStackTrace();
			conn.rollback();
	  	} catch (Exception e) {
		  	System.out.println("[ResSearchDatabase:updateRentCont]\n"+e);
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}


	// 단기대여 관리--------------------------------------------------------------------------------------------------------------

	//단기대여 한건 조회
	public RentFeeBean getRentFeeCase(String s_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		RentFeeBean bean = new RentFeeBean();
		String query = "";

		query = " select * from RENT_FEE where rent_s_cd='"+s_cd+"'";
				
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
		
			if(rs.next())
			{				
				 bean.setRent_s_cd		(rs.getString(1)==null?"":rs.getString(1));
				 bean.setDriver_yn		(rs.getString(2)==null?"":rs.getString(2));
				 bean.setTax_yn			(rs.getString(3)==null?"":rs.getString(3));
				 bean.setIns_yn			(rs.getString(4)==null?"":rs.getString(4));
				 bean.setGua_st			(rs.getString(5)==null?"":rs.getString(5));
				 bean.setGua_cau		(rs.getString(6)==null?"":rs.getString(6));
				 bean.setPaid_way		(rs.getString(7)==null?"":rs.getString(7));
				 bean.setPaid_st		(rs.getString(8)==null?"":rs.getString(8));
				 bean.setCard_no		(rs.getString(9)==null?"":rs.getString(9));
				 bean.setFee_s_amt		(rs.getInt(10));
				 bean.setFee_v_amt		(rs.getInt(11));
				 bean.setDc_s_amt		(rs.getInt(12));
				 bean.setDc_v_amt		(rs.getInt(13));
				 bean.setIns_s_amt		(rs.getInt(14));
				 bean.setIns_v_amt		(rs.getInt(15));
				 bean.setEtc_s_amt		(rs.getInt(16));
				 bean.setEtc_v_amt		(rs.getInt(17));
				 bean.setRent_tot_amt	(rs.getInt(18));
				 bean.setInv_s_amt		(rs.getInt(23));
				 bean.setInv_v_amt		(rs.getInt(24));
				 bean.setCons_yn		(rs.getString(25)==null?"":rs.getString(25));
				 bean.setNavi_yn		(rs.getString(26)==null?"":rs.getString(26));
				 bean.setGps_yn			(rs.getString(27)==null?"":rs.getString(27));
				 bean.setOil_st			(rs.getString(28)==null?"":rs.getString(28));
				 bean.setDist_km		(rs.getInt(29));
				 bean.setEst_id			(rs.getString(30)==null?"":rs.getString(30));
				 bean.setNavi_s_amt		(rs.getInt(31));
				 bean.setNavi_v_amt		(rs.getInt(32));
				 bean.setCons1_s_amt	(rs.getInt(33));
				 bean.setCons1_v_amt	(rs.getInt(34));
				 bean.setCons2_s_amt	(rs.getInt(35));
				 bean.setCons2_v_amt	(rs.getInt(36));
				 bean.setFee_etc		(rs.getString(37)==null?"":rs.getString(37));
				 bean.setCms_bank		(rs.getString(38)==null?"":rs.getString(38));
				 bean.setCms_acc_no		(rs.getString(39)==null?"":rs.getString(39));
				 bean.setCms_dep_nm		(rs.getString(40)==null?"":rs.getString(40));
				 bean.setMy_accid_yn	(rs.getString(41)==null?"":rs.getString(41));
				 bean.setCar_ja			(rs.getInt(42));
				 bean.setOver_run_amt	(rs.getInt(43));
				 bean.setCars			(rs.getString(44)==null?"":rs.getString(44));
				 bean.setAmt_01d		(rs.getInt(45));
				 bean.setAmt_03d		(rs.getInt(46));
				 bean.setAmt_05d		(rs.getInt(47));
				 bean.setAmt_07d		(rs.getInt(48));
				 bean.setF_rent_tot_amt	(rs.getInt(49));
				 bean.setF_paid_way		(rs.getString(50)==null?"":rs.getString(50));
				 bean.setF_paid_way2	(rs.getString(51)==null?"":rs.getString(51));
				 bean.setM2_dc_amt		(rs.getInt(53));
				 bean.setM3_dc_amt		(rs.getInt(54));
				 bean.setAmt_per		(rs.getString(55)==null?"":rs.getString(55));
				 bean.setCar_use		(rs.getString(56)==null?"":rs.getString(56));
				 bean.setSerial_no		(rs.getString(57)==null?"":rs.getString(57));


			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:getRentFeeCase]\n"+e);
			System.out.println("[ResSearchDatabase:getRentFeeCase]\n"+query);
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
	
	//단기대여정보 등록
	public int insertRentFee(RentFeeBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";
		query = " insert into RENT_FEE "+
				" ( rent_s_cd, driver_yn, tax_yn, ins_yn, gua_st, gua_cau, paid_way, paid_st, card_no,"+
				"   fee_s_amt, fee_v_amt, dc_s_amt, dc_v_amt, ins_s_amt, ins_v_amt, etc_s_amt, etc_v_amt, rent_tot_amt,"+
				"   reg_id, reg_dt, "+
				"   inv_s_amt, inv_v_amt, cons_yn, navi_yn, gps_yn, oil_st, "+
				"   dist_km, est_id, navi_s_amt, navi_v_amt, cons1_s_amt, cons1_v_amt, cons2_s_amt, cons2_v_amt, fee_etc, "+
				"   cms_bank, cms_acc_no, cms_dep_nm, my_accid_yn, car_ja, "+
				"   over_run_amt, cars, amt_01d, amt_03d, amt_05d, amt_07d, "+
				"   f_rent_tot_amt, f_paid_way, f_paid_way2, m2_dc_amt, m3_dc_amt, amt_per, car_use , serial_no, "+
				"   card_y_mm, card_y_yy, card_user "+
				" ) values ("+
				" ?, ?, ?, ?, ?, ?, ?, ?, ?,"+//9
				" ?, ?, ?, ?, ?, ?, ?, ?, ?,"+//9
				" ?, to_char(sysdate,'YYYYMMDD'), "+//1
				" ?, ?, ?, ?, ?, ?, "+	
				" ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
				" ?, ?, ?, ?, ?, "+
				" ?, ?, ?, ?, ?, ?, "+
                " ?, ?, ?, ?, ?, ?, ?, ?, "+
                " ?, ?, ? "+
				" )";		
		try 
		{			
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1,  bean.getRent_s_cd	());
			pstmt.setString(2,  bean.getDriver_yn	());
			pstmt.setString(3,  bean.getTax_yn		());
			pstmt.setString(4,  bean.getIns_yn		());
			pstmt.setString(5,  bean.getGua_st		());
			pstmt.setString(6,  bean.getGua_cau		());
			pstmt.setString(7,  bean.getPaid_way	());
			pstmt.setString(8,  bean.getPaid_st		());
			pstmt.setString(9,  bean.getCard_no		());
			pstmt.setInt   (10, bean.getFee_s_amt	());
			pstmt.setInt   (11, bean.getFee_v_amt	());
			pstmt.setInt   (12, bean.getDc_s_amt	());
			pstmt.setInt   (13, bean.getDc_v_amt	());
			pstmt.setInt   (14, bean.getIns_s_amt	());
			pstmt.setInt   (15, bean.getIns_v_amt	());
			pstmt.setInt   (16, bean.getEtc_s_amt	());
			pstmt.setInt   (17, bean.getEtc_v_amt	());
			pstmt.setInt   (18, bean.getRent_tot_amt());
			pstmt.setString(19, bean.getReg_id		());
			pstmt.setInt   (20, bean.getInv_s_amt	());
			pstmt.setInt   (21, bean.getInv_v_amt	());
			pstmt.setString(22, bean.getCons_yn		());
			pstmt.setString(23, bean.getNavi_yn		());
			pstmt.setString(24, bean.getGps_yn		());
			pstmt.setString(25, bean.getOil_st		());
			pstmt.setInt   (26, bean.getDist_km		());
			pstmt.setString(27, bean.getEst_id		());
			pstmt.setInt   (28, bean.getNavi_s_amt	());
			pstmt.setInt   (29, bean.getNavi_v_amt	());
			pstmt.setInt   (30, bean.getCons1_s_amt	());
			pstmt.setInt   (31, bean.getCons1_v_amt	());
			pstmt.setInt   (32, bean.getCons2_s_amt	());
			pstmt.setInt   (33, bean.getCons2_v_amt	());
			pstmt.setString(34, bean.getFee_etc		());
			pstmt.setString(35, bean.getCms_bank	());
			pstmt.setString(36, bean.getCms_acc_no	());
			pstmt.setString(37, bean.getCms_dep_nm	());
			pstmt.setString(38, bean.getMy_accid_yn	());
			pstmt.setInt   (39, bean.getCar_ja		());
			pstmt.setInt   (40, bean.getOver_run_amt());
			pstmt.setString(41, bean.getCars		());
			pstmt.setInt   (42, bean.getAmt_01d		());
			pstmt.setInt   (43, bean.getAmt_03d		());
			pstmt.setInt   (44, bean.getAmt_05d		());
			pstmt.setInt   (45, bean.getAmt_07d		());
			pstmt.setInt   (46, bean.getF_rent_tot_amt());
			pstmt.setString(47, bean.getF_paid_way	());
			pstmt.setString(48, bean.getF_paid_way2	());
			pstmt.setInt   (49, bean.getM2_dc_amt	());
			pstmt.setInt   (50, bean.getM3_dc_amt	());
			pstmt.setString(51, bean.getAmt_per		());
			pstmt.setString(52, bean.getCar_use		());
			pstmt.setString(53, bean.getSerial_no	());
			pstmt.setString(54, bean.getCard_y_mm	());
			pstmt.setString(55, bean.getCard_y_yy	());
			pstmt.setString(56, bean.getCard_user	());
	

			count = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:insertRentFee]\n"+e);
	  		e.printStackTrace();
			conn.rollback();
	  	} catch (Exception e) {
		  	System.out.println("[ResSearchDatabase:insertRentFee]\n"+e);
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	//단기대여정보 수정
	public int updateRentFee(RentFeeBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";
		query = " update RENT_FEE set"+
				"        driver_yn=?, tax_yn=?, ins_yn=?, gua_st=?, gua_cau=?, paid_way=?, paid_st=?, card_no=?,"+
				"        fee_s_amt=?, fee_v_amt=?, dc_s_amt=?, dc_v_amt=?, ins_s_amt=?, ins_v_amt=?, etc_s_amt=?, etc_v_amt=?, rent_tot_amt=?,"+
				"        update_id=?, update_dt=to_char(sysdate,'YYYYMMDD'),"+
				"        inv_s_amt=?, inv_v_amt=?, cons_yn=?, navi_yn=?, gps_yn=?, oil_st=?,  "+
				"        dist_km=?, navi_s_amt=?, navi_v_amt=?, cons1_s_amt=?, cons1_v_amt=?, cons2_s_amt=?, cons2_v_amt=?, fee_etc=?, "+
				"        cms_bank=?, cms_acc_no=?, cms_dep_nm=?, "+
				"        my_accid_yn=?, car_ja=?, f_rent_tot_amt=?, f_paid_way=?, f_paid_way2=?, m2_dc_amt=?, m3_dc_amt=?, amt_per=?, car_use=? , serial_no = ?  "+
				" where rent_s_cd=?";
		try 
		{			
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1,  bean.getDriver_yn	());
			pstmt.setString(2,  bean.getTax_yn		());
			pstmt.setString(3,  bean.getIns_yn		());
			pstmt.setString(4,  bean.getGua_st		());
			pstmt.setString(5,  bean.getGua_cau		());
			pstmt.setString(6,  bean.getPaid_way	());
			pstmt.setString(7,  bean.getPaid_st		());
			pstmt.setString(8,  bean.getCard_no		());
			pstmt.setInt   (9,  bean.getFee_s_amt	());
			pstmt.setInt   (10, bean.getFee_v_amt	());
			pstmt.setInt   (11, bean.getDc_s_amt	());
			pstmt.setInt   (12, bean.getDc_v_amt	());
			pstmt.setInt   (13, bean.getIns_s_amt	());
			pstmt.setInt   (14, bean.getIns_v_amt	());
			pstmt.setInt   (15, bean.getEtc_s_amt	());
			pstmt.setInt   (16, bean.getEtc_v_amt	());
			pstmt.setInt   (17, bean.getRent_tot_amt());
			pstmt.setString(18, bean.getReg_id		());
			pstmt.setInt   (19, bean.getInv_s_amt	());
			pstmt.setInt   (20, bean.getInv_v_amt	());
			pstmt.setString(21, bean.getCons_yn		());
			pstmt.setString(22, bean.getNavi_yn		());
			pstmt.setString(23, bean.getGps_yn		());
			pstmt.setString(24, bean.getOil_st		());
			pstmt.setInt   (25, bean.getDist_km		());
			pstmt.setInt   (26, bean.getNavi_s_amt	());
			pstmt.setInt   (27, bean.getNavi_v_amt	());
			pstmt.setInt   (28, bean.getCons1_s_amt	());
			pstmt.setInt   (29, bean.getCons1_v_amt	());
			pstmt.setInt   (30, bean.getCons2_s_amt	());
			pstmt.setInt   (31, bean.getCons2_v_amt	());
			pstmt.setString(32, bean.getFee_etc		());
			pstmt.setString(33, bean.getCms_bank	());
			pstmt.setString(34, bean.getCms_acc_no	());
			pstmt.setString(35, bean.getCms_dep_nm	());
			pstmt.setString(36, bean.getMy_accid_yn	());
			pstmt.setInt   (37, bean.getCar_ja		());
			pstmt.setInt   (38, bean.getF_rent_tot_amt());
			pstmt.setString(39, bean.getF_paid_way	());
			pstmt.setString(40, bean.getF_paid_way2	());
			pstmt.setInt   (41, bean.getM2_dc_amt	());
			pstmt.setInt   (42, bean.getM3_dc_amt	());
			pstmt.setString(43, bean.getAmt_per		());
			pstmt.setString(44, bean.getCar_use		());
			pstmt.setString(45, bean.getSerial_no	());
			pstmt.setString(46, bean.getRent_s_cd	());
			count = pstmt.executeUpdate();
			pstmt.close();

		    conn.commit();
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:updateRentFee]\n"+e);
	  		e.printStackTrace();
			conn.rollback();
	  	} catch (Exception e) {
		  	System.out.println("[ResSearchDatabase:updateRentFee]\n"+e);
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}


	// 단기대여 정산 관리--------------------------------------------------------------------------------------------------------------

	//단기대여 정산 한건 조회
	public RentSettleBean getRentSettleCase(String s_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		RentSettleBean bean = new RentSettleBean();
		String query = "";

		query = " select * from RENT_SETTLE where rent_s_cd='"+s_cd+"'";
				
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
		
			if(rs.next())
			{				
				bean.setRent_s_cd		(rs.getString(1)==null?"":rs.getString(1));
				bean.setSett_dt			(rs.getString(2)==null?"":rs.getString(2));
				bean.setRun_km			(rs.getString(3)==null?"":rs.getString(3));
				bean.setAgree_hour		(rs.getString(4)==null?"":rs.getString(4));
				bean.setAgree_days		(rs.getString(5)==null?"":rs.getString(5));
				bean.setAgree_months	(rs.getString(6)==null?"":rs.getString(6));
				bean.setAdd_hour		(rs.getString(7)==null?"":rs.getString(7));
				bean.setAdd_days		(rs.getString(8)==null?"":rs.getString(8));
				bean.setAdd_months		(rs.getString(9)==null?"":rs.getString(9));
				bean.setTot_hour		(rs.getString(10)==null?"":rs.getString(10));
				bean.setTot_days		(rs.getString(11)==null?"":rs.getString(11));
				bean.setTot_months		(rs.getString(12)==null?"":rs.getString(12));
				bean.setEtc				(rs.getString(13)==null?"":rs.getString(13));
				bean.setDriv_serv_st	(rs.getString(14)==null?"":rs.getString(14));
				bean.setDriv_serv_etc	(rs.getString(15)==null?"":rs.getString(15));
				bean.setAdd_fee_s_amt	(rs.getInt(16));
				bean.setAdd_fee_v_amt	(rs.getInt(17));
				bean.setAdd_ins_s_amt	(rs.getInt(18));
				bean.setAdd_ins_v_amt	(rs.getInt(19));
				bean.setAdd_etc_s_amt	(rs.getInt(20));
				bean.setAdd_etc_v_amt	(rs.getInt(21));
				bean.setIns_m_s_amt		(rs.getInt(22));
				bean.setIns_m_v_amt		(rs.getInt(23));
				bean.setIns_h_s_amt		(rs.getInt(24));
				bean.setIns_h_v_amt		(rs.getInt(25));
				bean.setOil_s_amt		(rs.getInt(26));
				bean.setOil_v_amt		(rs.getInt(27));
				bean.setRent_tot_amt	(rs.getInt(28));
				bean.setRent_sett_amt	(rs.getInt(29));
				bean.setReg_id			(rs.getString(30)==null?"":rs.getString(30));
				bean.setReg_dt			(rs.getString(31)==null?"":rs.getString(31));
				bean.setUpdate_dt		(rs.getString(32)==null?"":rs.getString(32));
				bean.setUpdate_id		(rs.getString(33)==null?"":rs.getString(33));
				bean.setAdd_navi_s_amt	(rs.getInt(34));
				bean.setAdd_navi_v_amt	(rs.getInt(35));
				bean.setAdd_cons1_s_amt	(rs.getInt(36));
				bean.setAdd_cons1_v_amt	(rs.getInt(37));
				bean.setAdd_cons2_s_amt	(rs.getInt(38));
				bean.setAdd_cons2_v_amt	(rs.getInt(39));
				bean.setCls_s_amt		(rs.getInt(40));
				bean.setCls_v_amt		(rs.getInt(41));
				bean.setKm_s_amt		(rs.getInt(42));
				bean.setKm_v_amt		(rs.getInt(43));
				bean.setAdd_inv_s_amt	(rs.getInt(44));
				bean.setAdd_inv_v_amt	(rs.getInt(45));
				bean.setFine_s_amt		(rs.getInt(46));

			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:getRentSettleCase]\n"+e);
			System.out.println("[ResSearchDatabase:getRentSettleCase]\n"+query);
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
	
	//단기대여정산 정보 등록
	public int insertRentSettle(RentSettleBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";
		query = " insert into RENT_SETTLE "+
				" ( rent_s_cd, sett_dt, run_km, agree_hour, agree_days, agree_months,"+
				"   add_hour, add_days, add_months, tot_hour, tot_days, tot_months,"+
				"   etc, driv_serv_st, driv_serv_etc, add_fee_s_amt, add_fee_v_amt, add_ins_s_amt, add_ins_v_amt,"+
				"   add_etc_s_amt, add_etc_v_amt, ins_m_s_amt, ins_m_v_amt, ins_h_s_amt, ins_h_v_amt, oil_s_amt, oil_v_amt,"+
				"   rent_tot_amt, rent_sett_amt, reg_id, reg_dt, "+
				"   add_navi_s_amt, add_navi_v_amt, add_cons1_s_amt, add_cons1_v_amt, add_cons2_s_amt, add_cons2_v_amt, cls_s_amt, cls_v_amt, km_s_amt, km_v_amt, "+
				"   add_inv_s_amt, add_inv_v_amt, fine_s_amt "+
				" ) values ("+
				"   ?, replace(?,'-',''), ?, ?, ?, ?,"+//6
				"   ?, ?, ?, ?, ?, ?,"+//6
				"   ?, ?, ?, ?, ?, ?, ?,"+//7
				"   ?, ?, ?, ?, ?, ?, ?, ?,"+//8
				"   ?, ?, ?, to_char(sysdate,'YYYYMMDD'), "+//3
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? "+
				" )";		
		try 
		{			
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1,  bean.getRent_s_cd		());
			pstmt.setString(2,  bean.getSett_dt			());
			pstmt.setString(3,  bean.getRun_km			());
			pstmt.setString(4,  bean.getAgree_hour		());
			pstmt.setString(5,  bean.getAgree_days		());
			pstmt.setString(6,  bean.getAgree_months	());
			pstmt.setString(7,  bean.getAdd_hour		());
			pstmt.setString(8,  bean.getAdd_days		());
			pstmt.setString(9,  bean.getAdd_months		());
			pstmt.setString(10, bean.getTot_hour		());
			pstmt.setString(11, bean.getTot_days		());
			pstmt.setString(12, bean.getTot_months		());
			pstmt.setString(13, bean.getEtc				());
			pstmt.setString(14, bean.getDriv_serv_st	());
			pstmt.setString(15, bean.getDriv_serv_etc	());
			pstmt.setInt   (16, bean.getAdd_fee_s_amt	());
			pstmt.setInt   (17, bean.getAdd_fee_v_amt	());
			pstmt.setInt   (18, bean.getAdd_ins_s_amt	());
			pstmt.setInt   (19, bean.getAdd_ins_v_amt	());
			pstmt.setInt   (20, bean.getAdd_etc_s_amt	());
			pstmt.setInt   (21, bean.getAdd_etc_v_amt	());
			pstmt.setInt   (22, bean.getIns_m_s_amt		());
			pstmt.setInt   (23, bean.getIns_m_v_amt		());
			pstmt.setInt   (24, bean.getIns_h_s_amt		());
			pstmt.setInt   (25, bean.getIns_h_v_amt		());
			pstmt.setInt   (26, bean.getOil_s_amt		());
			pstmt.setInt   (27, bean.getOil_v_amt		());
			pstmt.setInt   (28, bean.getRent_tot_amt	());
			pstmt.setInt   (29, bean.getRent_sett_amt	());
			pstmt.setString(30, bean.getReg_id			());
			pstmt.setInt   (31, bean.getAdd_navi_s_amt	());
			pstmt.setInt   (32, bean.getAdd_navi_v_amt	());
			pstmt.setInt   (33, bean.getAdd_cons1_s_amt	());
			pstmt.setInt   (34, bean.getAdd_cons1_v_amt	());
			pstmt.setInt   (35, bean.getAdd_cons2_s_amt	());
			pstmt.setInt   (36, bean.getAdd_cons2_v_amt	());
			pstmt.setInt   (37, bean.getCls_s_amt		());
			pstmt.setInt   (38, bean.getCls_v_amt		());
			pstmt.setInt   (39, bean.getKm_s_amt		());
			pstmt.setInt   (40, bean.getKm_v_amt		());
			pstmt.setInt   (41, bean.getAdd_inv_s_amt	());
			pstmt.setInt   (42, bean.getAdd_inv_v_amt	());
			pstmt.setInt   (43, bean.getFine_s_amt		());


			count = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		    
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:insertRentSettle]\n"+e);

			System.out.println("[bean.getRent_s_cd()	]\n"+bean.getRent_s_cd()	);
			System.out.println("[bean.getSett_dt()		]\n"+bean.getSett_dt()		);
			System.out.println("[bean.getRun_km()		]\n"+bean.getRun_km()		);
			System.out.println("[bean.getAgree_hour()	]\n"+bean.getAgree_hour()	);
			System.out.println("[bean.getAgree_days()	]\n"+bean.getAgree_days()	);
			System.out.println("[bean.getAgree_months()	]\n"+bean.getAgree_months()	);
			System.out.println("[bean.getAdd_hour()		]\n"+bean.getAdd_hour()		);
			System.out.println("[bean.getAdd_days()		]\n"+bean.getAdd_days()		);
			System.out.println("[bean.getAdd_months()	]\n"+bean.getAdd_months()	);
			System.out.println("[bean.getTot_hour()		]\n"+bean.getTot_hour()		);
			System.out.println("[bean.getTot_days()		]\n"+bean.getTot_days()		);
			System.out.println("[bean.getTot_months()	]\n"+bean.getTot_months()	);
			System.out.println("[bean.getEtc()			]\n"+bean.getEtc()			);
			System.out.println("[bean.getDriv_serv_st()	]\n"+bean.getDriv_serv_st()	);
			System.out.println("[bean.getDriv_serv_etc()]\n"+bean.getDriv_serv_etc());
			System.out.println("[bean.getAdd_fee_s_amt()]\n"+bean.getAdd_fee_s_amt());
			System.out.println("[bean.getAdd_fee_v_amt()]\n"+bean.getAdd_fee_v_amt());
			System.out.println("[bean.getAdd_ins_s_amt()]\n"+bean.getAdd_ins_s_amt());
			System.out.println("[bean.getAdd_ins_v_amt()]\n"+bean.getAdd_ins_v_amt());
			System.out.println("[bean.getAdd_etc_s_amt()]\n"+bean.getAdd_etc_s_amt());
			System.out.println("[bean.getAdd_etc_v_amt()]\n"+bean.getAdd_etc_v_amt());
			System.out.println("[bean.getIns_m_s_amt()	]\n"+bean.getIns_m_s_amt()	);
			System.out.println("[bean.getIns_m_v_amt()	]\n"+bean.getIns_m_v_amt()	);
			System.out.println("[bean.getIns_h_s_amt()	]\n"+bean.getIns_h_s_amt()	);
			System.out.println("[bean.getIns_h_v_amt()	]\n"+bean.getIns_h_v_amt()	);
			System.out.println("[bean.getOil_s_amt()	]\n"+bean.getOil_s_amt()	);
			System.out.println("[bean.getOil_v_amt()	]\n"+bean.getOil_v_amt()	);
			System.out.println("[bean.getRent_tot_amt()	]\n"+bean.getRent_tot_amt()	);
			System.out.println("[bean.getRent_sett_amt()]\n"+bean.getRent_sett_amt());
			System.out.println("[bean.getReg_id()		]\n"+bean.getReg_id()		);

	  		e.printStackTrace();
			conn.rollback();
	  	} catch (Exception e) {
		  	System.out.println("[ResSearchDatabase:insertRentSettle]\n"+e);
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	//단기대여 정산 정보 수정
	public int updateRentSettle(RentSettleBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";
		query = " update RENT_SETTLE set"+
				" sett_dt=replace(?,'-',''), run_km=?, agree_hour=?, agree_days=?, agree_months=?,"+
				" add_hour=?, add_days=?, add_months=?, tot_hour=?, tot_days=?, tot_months=?,"+
				" etc=?, driv_serv_st=?, driv_serv_etc=?, add_fee_s_amt=?, add_fee_v_amt=?, add_ins_s_amt=?, add_ins_v_amt=?,"+
				" add_etc_s_amt=?, add_etc_v_amt=?, ins_m_s_amt=?, ins_m_v_amt=?, ins_h_s_amt=?, ins_h_v_amt=?, oil_s_amt=?, oil_v_amt=?,"+
				" rent_tot_amt=?,  rent_sett_amt=?, update_id=?, update_dt=to_char(sysdate,'YYYYMMDD'), "+
				" add_navi_s_amt=?, add_navi_v_amt=?, add_cons1_s_amt=?, add_cons1_v_amt=?, add_cons2_s_amt=?, add_cons2_v_amt=?, "+
				" cls_s_amt=?, cls_v_amt=?, km_s_amt=?, km_v_amt=?, add_inv_s_amt=?, add_inv_v_amt=? "+
				" where rent_s_cd=?";

		try 
		{			
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getSett_dt());
			pstmt.setString(2, bean.getRun_km());
			pstmt.setString(3, bean.getAgree_hour());
			pstmt.setString(4, bean.getAgree_days());
			pstmt.setString(5, bean.getAgree_months());
			pstmt.setString(6, bean.getAdd_hour());
			pstmt.setString(7, bean.getAdd_days());
			pstmt.setString(8, bean.getAdd_months());
			pstmt.setString(9, bean.getTot_hour());
			pstmt.setString(10, bean.getTot_days());
			pstmt.setString(11, bean.getTot_months());
			pstmt.setString(12, bean.getEtc());
			pstmt.setString(13, bean.getDriv_serv_st());
			pstmt.setString(14, bean.getDriv_serv_etc());
			pstmt.setInt   (15, bean.getAdd_fee_s_amt());
			pstmt.setInt   (16, bean.getAdd_fee_v_amt());
			pstmt.setInt   (17, bean.getAdd_ins_s_amt());
			pstmt.setInt   (18, bean.getAdd_ins_v_amt());
			pstmt.setInt   (19, bean.getAdd_etc_s_amt());
			pstmt.setInt   (20, bean.getAdd_etc_v_amt());
			pstmt.setInt   (21, bean.getIns_m_s_amt());
			pstmt.setInt   (22, bean.getIns_m_v_amt());
			pstmt.setInt   (23, bean.getIns_h_s_amt());
			pstmt.setInt   (24, bean.getIns_h_v_amt());
			pstmt.setInt   (25, bean.getOil_s_amt());
			pstmt.setInt   (26, bean.getOil_v_amt());
			pstmt.setInt   (27, bean.getRent_tot_amt());
			pstmt.setInt   (28, bean.getRent_sett_amt());
			pstmt.setString(29, bean.getReg_id());
			pstmt.setInt   (30, bean.getAdd_navi_s_amt	());
			pstmt.setInt   (31, bean.getAdd_navi_v_amt	());
			pstmt.setInt   (32, bean.getAdd_cons1_s_amt	());
			pstmt.setInt   (33, bean.getAdd_cons1_v_amt	());
			pstmt.setInt   (34, bean.getAdd_cons2_s_amt	());
			pstmt.setInt   (35, bean.getAdd_cons2_v_amt	());
			pstmt.setInt   (36, bean.getCls_s_amt		());
			pstmt.setInt   (37, bean.getCls_v_amt		());
			pstmt.setInt   (38, bean.getKm_s_amt		());
			pstmt.setInt   (39, bean.getKm_v_amt		());
			pstmt.setInt   (40, bean.getAdd_inv_s_amt	());
			pstmt.setInt   (41, bean.getAdd_inv_v_amt	());
			pstmt.setString(42, bean.getRent_s_cd());
			count = pstmt.executeUpdate();
			pstmt.close();

		    conn.commit();
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:updateRentSettle]\n"+e);
	  		e.printStackTrace();
			conn.rollback();
	  	} catch (Exception e) {
		  	System.out.println("[ResSearchDatabase:updateRentSettle]\n"+e);
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}


	// 단기대여 요금 스케줄 관리--------------------------------------------------------------------------------------------------------------

	/**
	 *	단기대여 요금 리스트
	 */
	public Vector getScdRentList2(String s_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

 		query = " select * from SCD_RENT where rent_s_cd='"+s_cd+"' and rent_s_amt > 0 order by rent_st, tm";

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
			System.out.println("[ResSearchDatabase:getScdRentList2]"+e);
			System.out.println("[ResSearchDatabase:getScdRentList2]"+query);
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
	 *	단기대여 요금 스케줄 - 선납금 || 정산금
	 */
	public Vector getScdRentList(String s_cd, String gubun)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

 		query = " select a.*, a.rent_s_amt+nvl(a.rent_v_amt,0) rent_amt, b.brch_id, f.tax_dt"+
				" from   SCD_RENT a, rent_cont b, "+
				"        ( select a.rent_l_cd, a.rent_st, a.tm, max(b.tax_dt) tax_dt, sum(a.item_supply) tax_s_amt "+
				"          from   tax_item_list a, tax b "+
				"          where  a.item_id=b.item_id and b.tax_st<>'C' and a.gubun in ('9','10','16','17')"+
				"          group by a.rent_l_cd, a.rent_st, a.tm "+
				"          having sum(a.item_supply)<>0 "+
				"        ) f"+
				" where  nvl(a.bill_yn,'Y')='Y' and a.rent_s_cd=b.rent_s_cd "+
				"        and a.rent_s_cd=f.rent_l_cd(+) and a.rent_st=f.rent_st(+) and a.tm=f.tm(+) "+
				"        and a.rent_s_cd='"+s_cd+"'";
		
		if(gubun.equals("pre"))	query += " and a.rent_st in ('1','2') and a.tm=1 ";
		if(gubun.equals("fee"))	query += " and (a.rent_st not in ('1','2','6','7') or a.tm>1)";
		
		query += " order by decode(a.rent_st,'6','0','5','4','4','5',a.rent_st), decode(a.rent_st,'3',a.est_dt), a.tm";//and a.rent_s_amt > 0 

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
			System.out.println("[ResSearchDatabase:getScdRentList]"+e);
			System.out.println("[ResSearchDatabase:getScdRentList]"+query);
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
	 *	단기대여 요금 리스트 - 입금처리된 목록 
	 */
	public Vector getScdRentList(String s_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

 		query = " select * from SCD_RENT where rent_s_cd='"+s_cd+"' and pay_dt is not null and rent_st not in ('7') and pay_amt<>0 and nvl(bill_yn,'Y')='Y' order by decode(rent_st,'5','4','4','5',rent_st), decode(rent_st,'3', est_dt), tm";

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
			System.out.println("[ResSearchDatabase:getScdRentList]"+e);
			System.out.println("[ResSearchDatabase:getScdRentList]"+query);
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
	 *	단기대여 요금 리스트 - 보증금,정산금외 미수채권
	 */
	public Vector getScdRentNoList(String s_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

 		query = " select * from SCD_RENT where rent_s_cd='"+s_cd+"' and pay_dt is null and rent_st not in ('4','6','7') and rent_s_amt+rent_v_amt<>0 and nvl(bill_yn,'Y')='Y' order by decode(rent_st,'5','4','4','5',rent_st), decode(rent_st,'3', est_dt), tm";

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
			System.out.println("[ResSearchDatabase:getScdRentList]"+e);
			System.out.println("[ResSearchDatabase:getScdRentList]"+query);
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
	
	//단기대여 한건 조회
	public ScdRentBean getScdRentCase(String s_cd, String rent_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ScdRentBean bean = new ScdRentBean();
		String query = "";

		query = " select rent_s_cd, rent_st, tm, paid_st, rent_s_amt, rent_v_amt, pay_amt, rest_amt, "+
				"        pay_dt, est_dt, dly_days, dly_amt, bill_yn,  incom_dt, incom_seq , ext_seq  "+
				" from   SCD_RENT "+
				" where  rent_s_cd='"+s_cd+"' and rent_st='"+rent_st+"' and tm=1 and nvl(bill_yn,'Y')='Y'";
				
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
		
			if(rs.next())
			{				
				 bean.setRent_s_cd	(rs.getString(1)==null?"":rs.getString(1));
				 bean.setRent_st	(rs.getString(2)==null?"":rs.getString(2));
				 bean.setTm			(rs.getString(3)==null?"":rs.getString(3));
				 bean.setPaid_st	(rs.getString(4)==null?"":rs.getString(4));
				 bean.setRent_s_amt	(rs.getInt(5));
				 bean.setRent_v_amt	(rs.getInt(6));
				 bean.setPay_amt	(rs.getInt(7));
				 bean.setRest_amt	(rs.getInt(8));
				 bean.setPay_dt		(rs.getString(9)==null?"":rs.getString(9));
				 bean.setEst_dt		(rs.getString(10)==null?"":rs.getString(10));
				 bean.setDly_days	(rs.getString(11)==null?"":rs.getString(11));
				 bean.setDly_amt	(rs.getInt(12));
				 bean.setBill_yn	(rs.getString(13)==null?"":rs.getString(13));
			 	 bean.setIncom_dt	(rs.getString(14)==null?"":rs.getString(14));
			 	 bean.setIncom_seq	(rs.getInt(15));
			 	 bean.setExt_seq	(rs.getString(16)==null?"":rs.getString(16));
				 	 
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:getScdRentCase]\n"+e);
			System.out.println("[ResSearchDatabase:getScdRentCase]\n"+query);
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

	//단기대여 한건 조회
	public ScdRentBean getScdRentCase(String s_cd, String rent_st, String tm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ScdRentBean bean = new ScdRentBean();
		String query = "";

		query = " select rent_s_cd, rent_st, tm, paid_st, rent_s_amt, rent_v_amt, pay_amt, rest_amt,"+
				"        pay_dt, est_dt, dly_days, dly_amt, bill_yn, incom_dt, incom_seq, ext_seq "+
				" from   SCD_RENT "+
				" where  rent_s_cd='"+s_cd+"' and rent_st='"+rent_st+"' and tm='"+tm+"' and nvl(bill_yn,'Y')='Y'";
				
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
		
			if(rs.next())
			{				
				 bean.setRent_s_cd	(rs.getString(1)==null?"":rs.getString(1));
				 bean.setRent_st	(rs.getString(2)==null?"":rs.getString(2));
				 bean.setTm			(rs.getString(3)==null?"":rs.getString(3));
				 bean.setPaid_st	(rs.getString(4)==null?"":rs.getString(4));
				 bean.setRent_s_amt	(rs.getInt(5));
				 bean.setRent_v_amt	(rs.getInt(6));
				 bean.setPay_amt	(rs.getInt(7));
				 bean.setRest_amt	(rs.getInt(8));
				 bean.setPay_dt		(rs.getString(9)==null?"":rs.getString(9));
				 bean.setEst_dt		(rs.getString(10)==null?"":rs.getString(10));
				 bean.setDly_days	(rs.getString(11)==null?"":rs.getString(11));
				 bean.setDly_amt	(rs.getInt(12));
				 bean.setBill_yn	(rs.getString(13)==null?"":rs.getString(13));
				 bean.setIncom_dt	(rs.getString(14)==null?"":rs.getString(14));
			 	 bean.setIncom_seq	(rs.getInt(15));
			  	 bean.setExt_seq	(rs.getString(16)==null?"":rs.getString(16));
			  	 
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:getScdRentCase]\n"+e);
			System.out.println("[ResSearchDatabase:getScdRentCase]\n"+query);
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
	
	//단기대여 요금 스케줄 등록
	public int insertScdRent(ScdRentBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";
		query = " insert into SCD_RENT "+
				" ( rent_s_cd, rent_st, tm, paid_st, rent_s_amt, rent_v_amt, pay_amt, rest_amt,"+
				"   pay_dt, est_dt, dly_days, dly_amt, bill_yn, reg_id, reg_dt, ext_seq "+
				" ) values ("+
				"   ?, ?, ?, ?, ?, ?, ?, ?,"+//8
				"   replace(?,'-',''), replace(?,'-',''), ?, ?, ?, ?, to_char(sysdate,'YYYYMMDD'), ? "+//7
				" )";		
		try 
		{			
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getRent_s_cd());
			pstmt.setString(2, bean.getRent_st());
			pstmt.setString(3, bean.getTm());
			pstmt.setString(4, bean.getPaid_st());
			pstmt.setInt   (5, bean.getRent_s_amt());
			pstmt.setInt   (6, bean.getRent_v_amt());
			pstmt.setInt   (7, bean.getPay_amt());
			pstmt.setInt   (8, bean.getRest_amt());
			pstmt.setString(9, bean.getPay_dt());
			pstmt.setString(10, bean.getEst_dt());
			pstmt.setString(11, bean.getDly_days());
			pstmt.setInt   (12, bean.getDly_amt());
			pstmt.setString(13, bean.getBill_yn());
			pstmt.setString(14, bean.getReg_id());
			pstmt.setString(15, bean.getExt_seq());



			count = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:insertScdRent]\n"+e);
	  		e.printStackTrace();
			conn.rollback();
	  	} catch (Exception e) {
		  	System.out.println("[ResSearchDatabase:insertScdRent]\n"+e);
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	//단기대여 요금 스케줄 수정
	public int updateScdRent(ScdRentBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";
		query = " update SCD_RENT set"+
				" paid_st=?, rent_s_amt=?, rent_v_amt=?, pay_amt=?, rest_amt=?,"+
				" pay_dt=replace(?,'-',''), est_dt=replace(?,'-',''), dly_days=?, dly_amt=?, bill_yn=?,"+
				" update_id=?, update_dt=to_char(sysdate,'YYYYMMDD'), incom_dt = ?,  incom_seq = ?, ext_seq = ?  "+
				" where rent_s_cd=? and rent_st=? and tm=?";
		try 
		{			
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1,  bean.getPaid_st());
			pstmt.setInt   (2,  bean.getRent_s_amt());
			pstmt.setInt   (3,  bean.getRent_v_amt());
			pstmt.setInt   (4,  bean.getPay_amt());
			pstmt.setInt   (5,  bean.getRest_amt());
			pstmt.setString(6,  bean.getPay_dt());
			pstmt.setString(7,  bean.getEst_dt());
			pstmt.setString(8,  bean.getDly_days());
			pstmt.setInt   (9,  bean.getDly_amt());
			pstmt.setString(10, bean.getBill_yn());
			pstmt.setString(11, bean.getReg_id());
			pstmt.setString(12, bean.getIncom_dt());
			pstmt.setInt   (13, bean.getIncom_seq());
			pstmt.setString(14, bean.getExt_seq());
			pstmt.setString(15, bean.getRent_s_cd());
			pstmt.setString(16, bean.getRent_st());
			pstmt.setString(17, bean.getTm());

			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		    
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:updateScdRent]\n"+e);
	  		e.printStackTrace();
			conn.rollback();
	  	} catch (Exception e) {
		  	System.out.println("[ResSearchDatabase:updateScdRent]\n"+e);
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	//단기대여 요금 스케줄 삭제
	public int deleteScdRent(String s_cd, String rent_st, String tm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";
		query = " delete from SCD_RENT"+
				" where rent_s_cd=? and rent_st=? and tm=?";
		try 
		{			
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1,s_cd);
			pstmt.setString(2, rent_st);
			pstmt.setString(3, tm);
			count = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:deleteScdRent]\n"+e);
	  		e.printStackTrace();
			conn.rollback();
	  	} catch (Exception e) {
		  	System.out.println("[ResSearchDatabase:deleteScdRent]\n"+e);
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	//단기대여 요금 스케줄 삭제
	public int deleteScdRentNew(String s_cd, String rent_st, String tm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";
		query = " update SCD_RENT set bill_yn='N'"+
				" where rent_s_cd=? and rent_st=? and tm=?";
		try 
		{			
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1,s_cd);
			pstmt.setString(2, rent_st);
			pstmt.setString(3, tm);
			count = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:deleteScdRentNew]\n"+e);
	  		e.printStackTrace();
			conn.rollback();
	  	} catch (Exception e) {
		  	System.out.println("[ResSearchDatabase:deleteScdRentNew]\n"+e);
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	// 단기대여 용역비용 스케줄 관리--------------------------------------------------------------------------------------------------------------

	/**
	 *	단기대여 용역비용 리스트
	 */
	public Vector getScdDrivList(String s_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

 		query = " select * from SCD_DRIV where rent_s_cd='"+s_cd+"' and pay_dt is not null and pay_amt>0 order by rent_st, tm";

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
			System.out.println("[ResSearchDatabase:getScdDrivList]"+e);
			System.out.println("[ResSearchDatabase:getScdDrivList]"+query);
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
	
	//단기대여 용역비용 조회
	public ScdDrivBean getScdDrivCase(String s_cd, String rent_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ScdDrivBean bean = new ScdDrivBean();
		String query = "";

		query = " select * from SCD_DRIV where rent_s_cd='"+s_cd+"' and rent_st='"+rent_st+"'";
				
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
		
			if(rs.next())
			{				
				 bean.setRent_s_cd	(rs.getString(1)==null?"":rs.getString(1));
				 bean.setRent_st	(rs.getString(2)==null?"":rs.getString(2));
				 bean.setTm			(rs.getString(3)==null?"":rs.getString(3));
				 bean.setPaid_st	(rs.getString(4)==null?"":rs.getString(4));
				 bean.setPay_amt	(rs.getInt(5));
				 bean.setPay_dt		(rs.getString(6)==null?"":rs.getString(6));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:getScdDrivCase]\n"+e);
			System.out.println("[ResSearchDatabase:getScdDrivCase]\n"+query);
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
	
	//단기대여 용역비용 스케줄 등록
	public int insertScdDriv(ScdDrivBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";
		query = " insert into SCD_DRIV "+
				" ( rent_s_cd, rent_st, tm, paid_st, pay_amt,"+
				"   pay_dt, reg_id, reg_dt"+
				" ) values ("+
				"   ?, ?, ?, ?, ?,"+//5
				"   replace(?,'-',''), ?, to_char(sysdate,'YYYYMMDD')"+//2
				" )";		
		try 
		{			
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getRent_s_cd());
			pstmt.setString(2, bean.getRent_st());
			pstmt.setString(3, bean.getTm());
			pstmt.setString(4, bean.getPaid_st());
			pstmt.setInt(5, bean.getPay_amt());
			pstmt.setString(6, bean.getPay_dt());
			pstmt.setString(7, bean.getReg_id());

			count = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:insertScdDriv]\n"+e);
	  		e.printStackTrace();
			conn.rollback();
	  	} catch (Exception e) {
		  	System.out.println("[ResSearchDatabase:insertScdDriv]\n"+e);
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	//단기대여 용역비용 스케줄 수정
	public int updateScdDriv(ScdDrivBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";
		query = " update SCD_DRIV set"+
				" paid_st=?, pay_amt=?, pay_dt=replace(?,'-',''),"+
				" update_id=?, update_dt=to_char(sysdate,'YYYYMMDD')"+
				" where rent_s_cd=? and rent_st=? and tm=?";
		try 
		{			
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getPaid_st());
			pstmt.setInt(2, bean.getPay_amt());
			pstmt.setString(3, bean.getPay_dt());
			pstmt.setString(4, bean.getReg_id());
			pstmt.setString(5, bean.getRent_s_cd());
			pstmt.setString(6, bean.getRent_st());
			pstmt.setString(7, bean.getTm());

			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		    
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:updateScdDriv]\n"+e);
	  		e.printStackTrace();
			conn.rollback();
	  	} catch (Exception e) {
		  	System.out.println("[ResSearchDatabase:updateScdDriv]\n"+e);
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}


	// 단기 관리자 관리--------------------------------------------------------------------------------------------------------------


	//단기관리자 정보 조회
	public RentMgrBean getRentMgrCase(String s_cd, String mgr_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		RentMgrBean bean = new RentMgrBean();
		String query = "";

		query = " select * from RENT_MGR"+
				" where rent_s_cd='"+s_cd+"' and mgr_st='"+mgr_st+"'";

				
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();		
			if(rs.next())
			{			
				 bean.setRent_s_cd(rs.getString(1)==null?"":rs.getString(1));
				 bean.setMgr_st(rs.getString(2)==null?"":rs.getString(2));
				 bean.setMgr_nm(rs.getString(3)==null?"":rs.getString(3));
				 bean.setSsn(rs.getString(4)==null?"":rs.getString(4));
				 bean.setZip(rs.getString(5)==null?"":rs.getString(5));
				 bean.setAddr(rs.getString(6)==null?"":rs.getString(6));
				 bean.setLic_no(rs.getString(7)==null?"":rs.getString(7));
				 bean.setTel(rs.getString(8)==null?"":rs.getString(8));
				 bean.setEtc(rs.getString(9)==null?"":rs.getString(9));
				 bean.setLic_st(rs.getString(14)==null?"":rs.getString(14));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:getRentMgrCase]\n"+e);
			System.out.println("[ResSearchDatabase:getRentMgrCase]\n"+query);
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
	
	//단기 관리자 등록
	public int insertRentMgr(RentMgrBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";

		query = " insert into RENT_MGR "+
				" ( rent_s_cd, mgr_st, mgr_nm, ssn, zip, addr, lic_no, tel, etc, lic_st )"+
				" values "+
				" ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ? )";//9
		try 
		{				
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getRent_s_cd());
			pstmt.setString(2, bean.getMgr_st());
			pstmt.setString(3, bean.getMgr_nm());
			pstmt.setString(4, bean.getSsn());
			pstmt.setString(5, bean.getZip());
			pstmt.setString(6, bean.getAddr());
			pstmt.setString(7, bean.getLic_no());
			pstmt.setString(8, bean.getTel());
			pstmt.setString(9, bean.getEtc());
			pstmt.setString(10,bean.getLic_st());

			count = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:insertRentMgr]\n"+e);
	  		e.printStackTrace();
			conn.rollback();
	  	} catch (Exception e) {
		  	System.out.println("[ResSearchDatabase:insertRentMgr]\n"+e);
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	//단기 관리자 수정
	public int updateRentMgr(RentMgrBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";
		query = " update RENT_MGR set"+
				"        mgr_nm=?, ssn=?, zip=?, addr=?, lic_no=?, tel=?, etc=?, lic_st=?"+
				" where  rent_s_cd=? and mgr_st=?";

		try 
		{					
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getMgr_nm	());
			pstmt.setString(2, bean.getSsn		());
			pstmt.setString(3, bean.getZip		());
			pstmt.setString(4, bean.getAddr		());
			pstmt.setString(5, bean.getLic_no	());
			pstmt.setString(6, bean.getTel		());
			pstmt.setString(7, bean.getEtc		());
			pstmt.setString(8, bean.getLic_st	());
			pstmt.setString(9, bean.getRent_s_cd());
			pstmt.setString(10,bean.getMgr_st	());

			count = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:updateRentMgr]\n"+e);
	  		e.printStackTrace();
			conn.rollback();
	  	} catch (Exception e) {
		  	System.out.println("[ResSearchDatabase:updateRentMgr]\n"+e);
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}


	// 단기 보험대차 관리--------------------------------------------------------------------------------------------------------------


	//단기보험대차 정보 조회
	public RentInsBean getRentInsCase(String s_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		RentInsBean bean = new RentInsBean();
		String query = "";

		query = " select * from RENT_INS"+
				" where rent_s_cd='"+s_cd+"'";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();		
			if(rs.next())
			{			
				 bean.setRent_s_cd	(rs.getString(1)==null?"":rs.getString(1));
				 bean.setIns_com_id	(rs.getString(2)==null?"":rs.getString(2));
				 bean.setIns_num	(rs.getString(3)==null?"":rs.getString(3));
				 bean.setIns_nm		(rs.getString(4)==null?"":rs.getString(4));
				 bean.setIns_tel	(rs.getString(5)==null?"":rs.getString(5));
				 bean.setIns_tel2	(rs.getString(6)==null?"":rs.getString(6));
				 bean.setIns_fax	(rs.getString(7)==null?"":rs.getString(7));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:getRentInsCase]\n"+e);
			System.out.println("[ResSearchDatabase:getRentInsCase]\n"+query);
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
	
	//단기 보험대차 등록
	public int insertRentIns(RentInsBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";
		query = " insert into RENT_INS "+
				" ( rent_s_cd, ins_com_id, ins_num, ins_nm, ins_tel, ins_tel2, ins_fax, reg_id, reg_dt )"+
				" values "+
				" ( ?, ?, ?, ?, ?, ?, ?, ?, to_char(sysdate,'YYYYMMDD') )";//9
		try 
		{						
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getRent_s_cd());
			pstmt.setString(2, bean.getIns_com_id());
			pstmt.setString(3, bean.getIns_num());
			pstmt.setString(4, bean.getIns_nm());
			pstmt.setString(5, bean.getIns_tel());
			pstmt.setString(6, bean.getIns_tel2());
			pstmt.setString(7, bean.getIns_fax());
			pstmt.setString(8, bean.getReg_id());
			count = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:insertRentIns]\n"+e);
	  		e.printStackTrace();
			conn.rollback();
	  	} catch (Exception e) {
		  	System.out.println("[ResSearchDatabase:insertRentIns]\n"+e);
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	//단기 보험대차 수정
	public int updateRentIns(RentInsBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";
		query = " update RENT_INS set"+
				" ins_com_id=?, ins_num=?, ins_nm=?, ins_tel=?, ins_tel2=?, ins_fax=?, update_id=?, update_dt=to_char(sysdate,'YYYYMMDD')"+
				" where rent_s_cd=?";

		try 
		{					
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getIns_com_id());
			pstmt.setString(2, bean.getIns_num());
			pstmt.setString(3, bean.getIns_nm());
			pstmt.setString(4, bean.getIns_tel());
			pstmt.setString(5, bean.getIns_tel2());
			pstmt.setString(6, bean.getIns_fax());
			pstmt.setString(7, bean.getReg_id());
			pstmt.setString(8, bean.getRent_s_cd());

			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		    
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:updateRentIns]\n"+e);
	  		e.printStackTrace();
			conn.rollback();
	  	} catch (Exception e) {
		  	System.out.println("[ResSearchDatabase:updateRentIns]\n"+e);
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}


	//운행일지----------------------------------------------------------------------------------------------------------


	/**
	 *	cur_date(날짜) + day(일) 을 리턴
	 */
	public String addDay(String cur_date, int day)
	{
		getConnection();
            
		String query = "select to_char(to_date(replace('"+ cur_date +"','-',''), 'YYYYMMDD')+"+ day +", 'YYYYMMDD') "+
						" from dual";
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String rtn = "";
		try {
			if(AddUtil.checkDate(cur_date)){	
				pstmt = conn.prepareStatement(query);
			    rs = pstmt.executeQuery();
   	
				if(rs.next())
				{				
					 rtn = rs.getString(1)==null?"":rs.getString(1);
				}
				rs.close();
			    pstmt.close();
			}
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:addDay]\n"+e);
			System.out.println("[ResSearchDatabase:addDay]\n"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException ignore){}
			closeConnection();
			return rtn;
		}
	}	

	/**
	 *	cur_date(날짜) + mon(월) 을 리턴
	 */
	public String addMonth(String cur_date, int mon)
	{
		getConnection();
            
		String query = " select to_char(add_months(to_date(replace('"+ cur_date +"','-',''), 'YYYYMMDD'),"+ mon +"),'YYYYMMDD') "+
						" from dual";
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String rtn = "";
		try {
			if(AddUtil.checkDate(cur_date)){	
				pstmt = conn.prepareStatement(query);
			    rs = pstmt.executeQuery();
   		
				if(rs.next())
				{				
					 rtn = rs.getString(1)==null?"":rs.getString(1);
				}
				rs.close();
			    pstmt.close();
			}
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:addMonth]\n"+e);
			System.out.println("[ResSearchDatabase:addMonth]\n"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException ignore){}
			closeConnection();
			return rtn;
		}
	}	

	/**
	 *	날짜 간격 일자 리턴
	 */
	public String getDay(String s_date, String e_date)
	{
		getConnection();
            
		String query = "select to_char(to_date(replace('"+e_date+"','-',''),'YYYYMMDD')-to_date(replace('"+s_date+"','-',''),'YYYYMMDD')+1) from dual";
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String rtn = "";
		try {
			if(AddUtil.checkDate(s_date) && AddUtil.checkDate(e_date)){
				pstmt = conn.prepareStatement(query);
			    rs = pstmt.executeQuery();
   	
				if(rs.next())
				{				
					 rtn = rs.getString(1)==null?"":rs.getString(1);
				}
				rs.close();
			    pstmt.close();
			}
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:getDay]\n"+e);
			System.out.println("[ResSearchDatabase:getDay]\n"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException ignore){}
			closeConnection();
			return rtn;
		}
	}	

	/**
	 *	날짜 간격 일자 리턴
	 */
	public String getDay2(String s_date, String e_date)
	{
		getConnection();
            
		String query = "select to_char(to_date(replace('"+e_date+"','-',''),'YYYYMMDD')-to_date(replace('"+s_date+"','-',''),'YYYYMMDD')) from dual";
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String rtn = "";
		try {
			if(AddUtil.checkDate(s_date) && AddUtil.checkDate(e_date)){
				pstmt = conn.prepareStatement(query);
			    rs = pstmt.executeQuery();
   	
				if(rs.next())
				{				
					 rtn = rs.getString(1)==null?"":rs.getString(1);
				}
				rs.close();
			    pstmt.close();
			}
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:getDay]\n"+e);
			System.out.println("[ResSearchDatabase:getDay]\n"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException ignore){}
			closeConnection();
			return rtn;
		}
	}	

	/**
	 *	운행일지 한건 조회
	 */
	public ScdCarBean getScdCarCase(String c_id, String s_cd, String dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ScdCarBean bean = new ScdCarBean();
		String query = "";

		query = " select * from scd_car where car_mng_id='"+c_id+"' and rent_s_cd='"+s_cd+"' and dt=replace('"+dt+"','-','')";


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{				
	            bean.setCar_mng_id(rs.getString("car_mng_id")==null?"":rs.getString("car_mng_id"));				
			    bean.setRent_s_cd(rs.getString("rent_s_cd")==null?"":rs.getString("rent_s_cd"));			
			    bean.setDt(rs.getString("dt")==null?"":rs.getString("dt"));				
			    bean.setTime(rs.getString("time")==null?"":rs.getString("time"));	
			    bean.setTm(rs.getInt("tm"));	
			    bean.setUse_st(rs.getString("use_st"));	
			}
			rs.close();
			pstmt.close();


		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:getScdCarCase]"+e);
			System.out.println("[ResSearchDatabase:getScdCarCase]"+query);
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


	//운행일지 삽입
	public int insertScdCar(ScdCarBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		int count = 0;
		int chk = 0;

		String query = "";
		query = " insert into SCD_CAR ( car_mng_id, rent_s_cd, dt, time, reg_id, reg_dt, use_yn, use_st, tm)"+
				" values ("+
				" ?, ?, replace(?,'-',''), ?, ?, to_char(sysdate,'YYYYMMDD'), 'Y', ?, ?)";

		//입력체크
		String query2 = "select count(0) from SCD_CAR where car_mng_id=? and rent_s_cd=? and dt=replace(?,'-','')";

		try 
		{	
			conn.setAutoCommit(false);

			pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString(1, bean.getCar_mng_id());
			pstmt2.setString(2, bean.getRent_s_cd());
			pstmt2.setString(3, bean.getDt());
	    	rs = pstmt2.executeQuery();
			if(rs.next()){
				chk = rs.getInt(1);	
			}
			rs.close();
			pstmt2.close();

			if(chk==0){
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, bean.getCar_mng_id());
				pstmt.setString(2, bean.getRent_s_cd());
				pstmt.setString(3, bean.getDt());
				pstmt.setString(4, bean.getTime());
				pstmt.setString(5, bean.getReg_id());
				pstmt.setString(6, bean.getUse_st());
				pstmt.setInt(7, bean.getTm());
				count = pstmt.executeUpdate();
				pstmt.close();
			}

			conn.commit();
		    
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:insertScdCar]\n"+e+"\nrent_s_cd="+bean.getRent_s_cd());
	  		e.printStackTrace();
			conn.rollback();
	  	} catch (Exception e) {
		  	System.out.println("[ResSearchDatabase:insertScdCar]\n"+e);
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(rs != null)		rs.close();
				if(pstmt != null)	pstmt.close();
				if(pstmt2 != null)	pstmt2.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	//운행일지 수정
	public int updateScdCar(ScdCarBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";
		query = " update SCD_CAR set time=?, tm=?, use_st=?"+
				" where car_mng_id=? and rent_s_cd=? and dt=replace(?,'-','')";

		try 
		{						
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, bean.getTime());
			pstmt.setInt(2, bean.getTm());
			pstmt.setString(3, bean.getUse_st());
			pstmt.setString(4, bean.getCar_mng_id());
			pstmt.setString(5, bean.getRent_s_cd());
			pstmt.setString(6, bean.getDt());
			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		    
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:updateScdCar]\n"+e);
	  		e.printStackTrace();
			conn.rollback();
	  	} catch (Exception e) {
		  	System.out.println("[ResSearchDatabase:updateScdCar]\n"+e);
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	/**	
	 *	반차처리 - 마지막 운행일자 조회
	 */
	public String getMaxData(String s_cd, String c_id, String data)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String max_dt = "";

		query = " select max("+data+") from SCD_CAR where RENT_S_CD='"+s_cd+"' and CAR_MNG_ID='"+c_id+"'"+
				" group by CAR_MNG_ID, RENT_S_CD order by CAR_MNG_ID, RENT_S_CD";

		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{				
			    max_dt = rs.getString(1)==null?"":rs.getString(1);	
			}
			rs.close();
			pstmt.close();
	  	} catch (Exception e) {
			System.out.println("[ResSearchDatabase:getMaxData]\n"+e);
			System.out.println("[ResSearchDatabase:getMaxData]\n"+query);
			e.printStackTrace();
		} finally {
			try{	
				if(rs != null)	rs.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return max_dt;
		}
	}

	/**	
	 *	반차처리 - 마지막 운행일자 조회
	 */
	public String getMaxData(String c_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String max_dt = "";

		query = " select max(dt) from SCD_CAR where CAR_MNG_ID='"+c_id+"'"+
				" group by CAR_MNG_ID order by CAR_MNG_ID";

		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{				
			    max_dt = rs.getString(1)==null?"":rs.getString(1);	
			}
			rs.close();
			pstmt.close();
	  	} catch (Exception e) {
			System.out.println("[ResSearchDatabase:getMaxData]\n"+e);
			System.out.println("[ResSearchDatabase:getMaxData]\n"+query);
			e.printStackTrace();
		} finally {
			try{	
				if(rs != null)	rs.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return max_dt;
		}
	}

	/**	
	 *	반차처리 - 기간미만 사용시 마지막 운행일자 삭제
	 */
	public int deleteScdCar(String s_cd, String c_id, String ret_dt)
	{
		getConnection();
		int count = 0;
		PreparedStatement pstmt = null;
		String query = "";
		query = " delete from SCD_CAR where rent_s_cd='"+s_cd+"' and car_mng_id='"+c_id+"'";

		if(!ret_dt.equals(""))	query += " and dt > replace('"+ret_dt+"','-','')";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.executeUpdate();
			pstmt.close();
			count =1;

			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[ResSearchDatabase:deleteScdCar]\n"+e);
			System.out.println("[ResSearchDatabase:deleteScdCar]\n"+query);
			e.printStackTrace();
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	/**	
	 *	반차처리 - 기간미만 사용시 마지막 운행일자 삭제
	 */
	public int deleteScdCar2(String s_cd, String c_id, String dt)
	{
		getConnection();
		int count = 0;
		PreparedStatement pstmt = null;
		String query = "";
		query = " delete from SCD_CAR where rent_s_cd='"+s_cd+"' and car_mng_id='"+c_id+"'"+
				" and dt =replace('"+dt+"','-','')";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.executeUpdate();
			pstmt.close();
			count =1;

			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[ResSearchDatabase:deleteScdCar2]\n"+e);
			System.out.println("[ResSearchDatabase:deleteScdCar2]\n"+query);
			e.printStackTrace();
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}


	/**	
	 *	계약정산에서 운행일지 삭제
	 */
	public int deleteScdCar(String s_cd, String c_id, String deli_dt, String ret_dt)
	{
		getConnection();
		int count = 0;
		PreparedStatement pstmt = null;
		String query = "";
		query = " delete from SCD_CAR where RENT_S_CD='"+s_cd+"' and CAR_MNG_ID='"+c_id+"'";
		
		if(!ret_dt.equals("")) query += " and dt < replace('"+deli_dt+"','-','') and dt > replace('"+ret_dt+"','-','')";
		

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.executeUpdate();
			pstmt.close();
			count =1;

			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[ResSearchDatabase:deleteScdCar]\n"+e);
			System.out.println("[ResSearchDatabase:deleteScdCar]\n"+query);
			e.printStackTrace();
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	/**	
	 *	메뉴별 권한 조회
	 */
	public String getAuthRw(String user_id, String m_st, String m_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String auth_rw = "";

		query = " select nvl(auth_rw,'0') auth_rw from US_ME where user_id='"+user_id+"' and m_st='"+m_st+"' and m_cd='"+m_cd+"'";

		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{				
			    auth_rw = rs.getString(1)==null?"":rs.getString(1);	
			}
			rs.close();
			pstmt.close();
	  	} catch (Exception e) {
			System.out.println("[ResSearchDatabase:getAuthRw]\n"+e);
			System.out.println("[ResSearchDatabase:getAuthRw]\n"+query);
			e.printStackTrace();
		} finally {
			try{	
				if(rs != null)	rs.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return auth_rw;
		}
	}

	/**	
	 *	New 메뉴별 권한 조회
	 */
	public String getAuthRw(String user_id, String m_st, String m_st2, String m_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String auth_rw = "";

		//query = " select nvl(auth_rw,'0') auth_rw from US_MA_ME where user_id='"+user_id+"' and m_st='"+m_st+"' and m_st2='"+m_st2+"' and m_cd='"+m_cd+"'";

		query = " select max(nvl(d.auth_rw,'0')) auth_rw "+
				" from   ma_menu b, xml_menu c, xml_ma_me d "+
				" where  b.m_st='"+m_st+"' and b.m_st2='"+m_st2+"' and b.m_cd='"+m_cd+"'"+
				"        and b.url=c.url "+
				"        and d.user_id='"+user_id+"' and c.m_st=d.m_st and c.m_st2=d.m_st2 and c.m_cd=d.m_cd ";
		       

		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{				
			    auth_rw = rs.getString(1)==null?"":rs.getString(1);	
			}
			rs.close();
			pstmt.close();
	  	} catch (Exception e) {
			System.out.println("[ResSearchDatabase:getAuthRw]\n"+e);
			System.out.println("[ResSearchDatabase:getAuthRw]\n"+query);
			e.printStackTrace();
		} finally {
			try{	
				if(rs != null)	rs.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return auth_rw;
		}
	}

	/**	
	 *	New 메뉴별 권한 조회
	 */
	public String getAuthRwOld(String user_id, String m_st, String m_st2, String m_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String auth_rw = "";

		query = " select nvl(auth_rw,'0') auth_rw from US_MA_ME where user_id='"+user_id+"' and m_st='"+m_st+"' and m_st2='"+m_st2+"' and m_cd='"+m_cd+"'";		       

		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{				
			    auth_rw = rs.getString(1)==null?"":rs.getString(1);	
			}
			rs.close();
			pstmt.close();
	  	} catch (Exception e) {
			System.out.println("[ResSearchDatabase:getAuthRwOld]\n"+e);
			System.out.println("[ResSearchDatabase:getAuthRwOld]\n"+query);
			e.printStackTrace();
		} finally {
			try{	
				if(rs != null)	rs.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return auth_rw;
		}
	}

	//통화메모----------------------------------------------------------------------------------------------------------


	/**
     * 견적서 메모 전체조회
     */
    public RentMBean [] getRentMAll(String s_cd)
	{
		getConnection();
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = "select RENT_S_CD, USER_ID, SEQ_NO, SUB, NOTE, REG_DT\n"
				+ "from rent_m\n"
				+ "where RENT_S_CD=? order by reg_dt desc \n";// and user_id=?

        Collection col = new ArrayList();
        try{
			pstmt = conn.prepareStatement(query);
    		pstmt.setString(1, s_cd);		    		
    		rs = pstmt.executeQuery();

            while(rs.next()){
	            RentMBean bean = new RentMBean();
				bean.setRent_s_cd(rs.getString("RENT_S_CD"));
			    bean.setUser_id(rs.getString("USER_ID"));
			    bean.setSeq_no(rs.getInt("SEQ_NO"));
				bean.setSub(rs.getString("SUB"));
			    bean.setNote(rs.getString("NOTE"));
			    bean.setReg_dt(rs.getString("REG_DT"));

				col.add(bean);
            }
			rs.close();
			pstmt.close();
	  	} catch (Exception e) {
			System.out.println("[ResSearchDatabase:getRentMAll]\n"+e);
			e.printStackTrace();
		} finally {
			try{	
				if(rs != null)	rs.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
		    return (RentMBean[])col.toArray(new RentMBean[0]);
		}
    }

	/**
     * 견적서 메모 전체조회
     */
    public int insertRentM(RentMBean bean)
	{
		getConnection();
        
        PreparedStatement pstmt = null;
        PreparedStatement pstmt1 = null;
        ResultSet rs = null;
        String query = "";
        String query1 = "";
        int seq_no = 0;
        int count = 0;
                
        query="insert into rent_m(RENT_S_CD, USER_ID, SEQ_NO, SUB, NOTE, REG_DT, REG_DT_TIME)\n"
			+ "values(?, ?, ?, ?, ?, to_char(sysdate,'YYYYMMDD'), to_char(sysdate,'HH24MI'))\n";//to_char(sysdate,'YYYYMMDDHH24MI')

        query1="select nvl(max(seq_no)+1,1) from rent_m where RENT_S_CD=?";
		

        try{
            conn.setAutoCommit(false);

            pstmt1 = conn.prepareStatement(query1);
            pstmt1.setString(1, bean.getRent_s_cd());
			rs = pstmt1.executeQuery();
            if(rs.next())
			{
				seq_no = rs.getInt(1);
            }
			rs.close();
			pstmt1.close();
			
            pstmt = conn.prepareStatement(query);
			pstmt.setString(1, bean.getRent_s_cd());
			pstmt.setString(2, bean.getUser_id().trim());
			pstmt.setInt(3, seq_no);
			pstmt.setString(4, bean.getSub().trim());
			pstmt.setString(5, bean.getNote().trim());	           
            count = pstmt.executeUpdate();
			pstmt.close();
             
            conn.commit();

	  	} catch (Exception e) {
			System.out.println("[ResSearchDatabase:insertRentM]\n"+e);
			e.printStackTrace();
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(rs != null)	rs.close();
				if(pstmt != null)	pstmt.close();
				if(pstmt1 != null)	pstmt1.close();
			}catch(Exception ignore){}
			closeConnection();
		    return count;
		}
    }

	//단기계약 한건 조회
	public RentContBean getRentContCaseAccid(String c_id, String accid_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		RentContBean bean = new RentContBean();
		String query = "";

		query = " select * from RENT_CONT where sub_c_id='"+c_id+"' and accid_id='"+accid_id+"'";
				
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
		
			if(rs.next())
			{				
				 bean.setRent_s_cd(rs.getString(1)==null?"":rs.getString(1));
				 bean.setCar_mng_id(rs.getString(2)==null?"":rs.getString(2));
				 bean.setRent_st(rs.getString(3)==null?"":rs.getString(3));
				 bean.setCust_st(rs.getString(4)==null?"":rs.getString(4));
				 bean.setCust_id(rs.getString(5)==null?"":rs.getString(5));
				 bean.setSub_c_id(rs.getString(6)==null?"":rs.getString(6));
				 bean.setAccid_id(rs.getString(7)==null?"":rs.getString(7));
				 bean.setServ_id(rs.getString(8)==null?"":rs.getString(8));
				 bean.setMaint_id(rs.getString(9)==null?"":rs.getString(9));
				 bean.setRent_dt(rs.getString(10)==null?"":rs.getString(10));
				 bean.setBrch_id(rs.getString(11)==null?"":rs.getString(11));
				 bean.setBus_id(rs.getString(12)==null?"":rs.getString(12));
				 bean.setRent_start_dt2(rs.getString(13)==null?"":rs.getString(13));
				 bean.setRent_end_dt2(rs.getString(14)==null?"":rs.getString(14));
				 bean.setRent_hour(rs.getString(15)==null?"":rs.getString(15));
				 bean.setRent_days(rs.getString(16)==null?"":rs.getString(16));
				 bean.setRent_months(rs.getString(17)==null?"":rs.getString(17));
				 bean.setEtc(rs.getString(18)==null?"":rs.getString(18));
				 bean.setDeli_plan_dt2(rs.getString(19)==null?"":rs.getString(19));
				 bean.setRet_plan_dt2(rs.getString(20)==null?"":rs.getString(20));
				 bean.setDeli_dt2(rs.getString(21)==null?"":rs.getString(21));
				 bean.setRet_dt2(rs.getString(22)==null?"":rs.getString(22));
				 bean.setDeli_loc(rs.getString(23)==null?"":rs.getString(23));
				 bean.setRet_loc(rs.getString(24)==null?"":rs.getString(24));
				 bean.setDeli_mng_id(rs.getString(25)==null?"":rs.getString(25));
				 bean.setRet_mng_id(rs.getString(26)==null?"":rs.getString(26));
				 bean.setUse_st(rs.getString(27)==null?"":rs.getString(27));
				 bean.setSite_id	(rs.getString(37)==null?"":rs.getString(37));
				 bean.setMng_id		(rs.getString(38)==null?"":rs.getString(38));
				 bean.setCls_st		(rs.getString(39)==null?"":rs.getString(39));
				 bean.setCls_dt		(rs.getString(40)==null?"":rs.getString(40));

			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:getRentContCaseAccid]\n"+e);
			System.out.println("[ResSearchDatabase:getRentContCaseAccid]\n"+query);
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

	//단기계약 한건 조회
	public RentContBean getRentContCaseAccid2(String c_id, String accid_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		RentContBean bean = new RentContBean();
		String query = "";

		query = " select * from RENT_CONT where car_mng_id='"+c_id+"' and accid_id='"+accid_id+"'";
				
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
		
			if(rs.next())
			{				
				 bean.setRent_s_cd(rs.getString(1)==null?"":rs.getString(1));
				 bean.setCar_mng_id(rs.getString(2)==null?"":rs.getString(2));
				 bean.setRent_st(rs.getString(3)==null?"":rs.getString(3));
				 bean.setCust_st(rs.getString(4)==null?"":rs.getString(4));
				 bean.setCust_id(rs.getString(5)==null?"":rs.getString(5));
				 bean.setSub_c_id(rs.getString(6)==null?"":rs.getString(6));
				 bean.setAccid_id(rs.getString(7)==null?"":rs.getString(7));
				 bean.setServ_id(rs.getString(8)==null?"":rs.getString(8));
				 bean.setMaint_id(rs.getString(9)==null?"":rs.getString(9));
				 bean.setRent_dt(rs.getString(10)==null?"":rs.getString(10));
				 bean.setBrch_id(rs.getString(11)==null?"":rs.getString(11));
				 bean.setBus_id(rs.getString(12)==null?"":rs.getString(12));
				 bean.setRent_start_dt2(rs.getString(13)==null?"":rs.getString(13));
				 bean.setRent_end_dt2(rs.getString(14)==null?"":rs.getString(14));
				 bean.setRent_hour(rs.getString(15)==null?"":rs.getString(15));
				 bean.setRent_days(rs.getString(16)==null?"":rs.getString(16));
				 bean.setRent_months(rs.getString(17)==null?"":rs.getString(17));
				 bean.setEtc(rs.getString(18)==null?"":rs.getString(18));
				 bean.setDeli_plan_dt2(rs.getString(19)==null?"":rs.getString(19));
				 bean.setRet_plan_dt2(rs.getString(20)==null?"":rs.getString(20));
				 bean.setDeli_dt2(rs.getString(21)==null?"":rs.getString(21));
				 bean.setRet_dt2(rs.getString(22)==null?"":rs.getString(22));
				 bean.setDeli_loc(rs.getString(23)==null?"":rs.getString(23));
				 bean.setRet_loc(rs.getString(24)==null?"":rs.getString(24));
				 bean.setDeli_mng_id(rs.getString(25)==null?"":rs.getString(25));
				 bean.setRet_mng_id(rs.getString(26)==null?"":rs.getString(26));
				 bean.setUse_st(rs.getString(27)==null?"":rs.getString(27));
				 bean.setSite_id	(rs.getString(37)==null?"":rs.getString(37));
				 bean.setMng_id		(rs.getString(38)==null?"":rs.getString(38));
				 bean.setCls_st		(rs.getString(39)==null?"":rs.getString(39));
				 bean.setCls_dt		(rs.getString(40)==null?"":rs.getString(40));

			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:getRentContCaseAccid]\n"+e);
			System.out.println("[ResSearchDatabase:getRentContCaseAccid]\n"+query);
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
	 *	차량위치 수정
	 */
	public int updateCarPark(String c_id, String park, String park_cont)
	{
		getConnection();
		int count = 0;
		PreparedStatement pstmt = null;
		String query = "";
		query = " update CAR_REG set park='"+park+"', park_cont='"+park_cont+"' where CAR_MNG_ID='"+c_id+"'";
		
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.executeUpdate();
			pstmt.close();
			count =1;

			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[ResSearchDatabase:updateCarPark]\n"+e);
			System.out.println("[ResSearchDatabase:updateCarPark]\n"+query);
			e.printStackTrace();
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	/**	
	 *	차량위치 수정2 :: 수정한 사람, 수정한 날짜 추가
	 */
	public int updateCarPark2(String c_id, String park, String park_cont, String user_id)
	{
		getConnection();
		int count = 0;
		PreparedStatement pstmt = null;
		String query = "";
		query = " update CAR_REG set park='"+park+"', park_cont='"+park_cont+"', checker = '"+user_id+"', check_dt =to_char(sysdate,'YYYYMMDD')  where CAR_MNG_ID='"+c_id+"' ";


		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.executeUpdate();
			pstmt.close();
			count =1;

			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[ResSearchDatabase:updateCarPark]\n"+e);
			System.out.println("[ResSearchDatabase:updateCarPark]\n"+query);
			e.printStackTrace();
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}
	
	
	 // 차량 위치 
	public String GetParkId(String car_mng_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	"SELECT nvl(park, 'xx') park_id  FROM car_reg WHERE car_mng_id = '"+ car_mng_id+ "'";;
		String park_id = "";

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				park_id = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:GetParkId]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return park_id;
		}
	}
	
	/**
	 *	//차량스케줄 연동 일자 조회
	 */
	public String [] getResCalendar(String car_mng_id, String year, String month, int days)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Collection col = new ArrayList();

		String query = "";
		String jobday = "";
		String day = "";
		int day_minus = 0;
		int while_day = 0;		
		int use_days = 0;

		String st_dt = year+month+"01";
		String end_dt = year+month+AddUtil.addZero2(days);

		LastDay ld = new LastDay();

		query = " select dt from scd_car where car_mng_id='"+car_mng_id+"' and dt like '"+year+month+"%' and use_st='1' group by dt order by dt";
		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			day = ld.addDay(st_dt, while_day-day_minus);
			
			while(rs.next())
			{				

				jobday = rs.getString("dt");				

				if(!jobday.equals(day)){
					use_days = AddUtil.parseInt(getDay(day, jobday));
					for(int i=1; i<=use_days; i++){
						col.add("N");
						day_minus--;
						day = ld.addDay(st_dt, while_day-day_minus);
					}
				}else{
					col.add("Y");
					day_minus--;
					day = ld.addDay(st_dt, while_day-day_minus);
				}			
			}
			rs.close();
			pstmt.close();

			if(!end_dt.equals(day)){
				use_days = AddUtil.parseInt(getDay(day, end_dt));
				for(int i=1; i<=use_days; i++){
					col.add("N");
					day_minus--;
					day = ld.addDay(st_dt, while_day-day_minus);
				}
			}

		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:getResCalendar]"+e);
			System.out.println("[ResSearchDatabase:getResCalendar]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return (String[])col.toArray(new String[0]);
		}
	}	

	/**	
	 *	Url별 권한 조회
	 */
	public String getAuthRw(String user_id, String url)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String auth_rw = "";

		query = " select max(nvl(a.auth_rw,'0')) auth_rw from US_MA_ME a, ma_menu b where a.user_id='"+user_id+"' and a.m_st=b.m_st and a.m_st2=b.m_st2 and a.m_cd=b.m_cd and b.url='"+url+"'";

		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{				
			    auth_rw = rs.getString(1)==null?"":rs.getString(1);	
			}
			rs.close();
			pstmt.close();
	  	} catch (Exception e) {
			System.out.println("[ResSearchDatabase:getAuthRw(String user_id, String url)]\n"+e);
			System.out.println("[ResSearchDatabase:getAuthRw(String user_id, String url)]\n"+query);
			e.printStackTrace();
		} finally {
			try{	
				if(rs != null)	rs.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return auth_rw;
		}
	}
	
	/**
	 *	보유차현황 리스트 -  실입고 차량
	 */
	public Vector getRentPrepareRealList2(String br_id, String gubun1, String start_dt, String end_dt, String s_cc,  int s_year, String s_kd, String t_wd )
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" decode(nvl(q.mng_br_id,b.brch_id),'S1','본사','K1','본사','S2','본사','B1','부산지점','N1','부산지점','D1','대전지점','G1','대구지점','J1','광주지점','본사') brch_nm, a.car_mng_id, a.car_no, a.car_nm, d.car_name, a.init_reg_dt, b.rent_dt, i.rent_start_dt, i.rent_end_dt, i.deli_plan_dt, i.ret_plan_dt, p.user_nm as bus_nm, \n"+
				" f.nm as fuel_kd,  \n"+
				" a.dpm, c.colo, nvl(j.use_per,0) use_per, i.use_st, i.rent_st, i.rent_s_cd,  \n"+
				" decode(a.prepare, '2','매각', '3','보관', '4','말소', '5','도난', '6','해지', '8','수해', '예비') prepare, a.park, a.park_cont,  \n"+
				" decode(i.use_st, '1','예약','2','배차',decode(a.prepare,'4','-','5','-','6','-','8','-','대기')) car_stat,  \n"+
				" decode(a.prepare,'4','-','5','-','6','-','8','-', decode(i.rent_st,'1','단기','2','정비','3','사고','9','보험','10','지연','4','업무','5','업무','6','정비','7','정비','8','수리','11','장기대기')) rent_st_nm,  \n"+
				" decode(i.cust_st, '', '조성희', '1',l.client_nm, '4',n.user_nm, m.cust_nm) cust_nm,  \n"+
				" decode(i.cust_st, '', '아마존카', '1',replace(l.firm_nm,'(주)',''), '4','아마존카', m.firm_nm) firm_nm,  \n"+
				" TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.rent_dt, 'YYYYMMDD')) * 30.5) DAY, nvl(k.a_cnt,0) a_cnt \n "+ 
			    " from car_reg a, cont b, car_etc c, car_nm d, client l, users n, rent_cust m, users p, cont_etc q, \n"+
				" (select a.* from rent_cont a, (select car_mng_id, max(nvl(deli_dt,decode(use_st,'1','0000000000',deli_plan_dt))) deli_dt from rent_cont where use_st in ('1','2') group by car_mng_id) b where a.use_st in ('1','2') and a.car_mng_id=b.car_mng_id and nvl(a.deli_dt,decode(a.use_st,'1','0000000000',a.deli_plan_dt))=b.deli_dt) i,  \n "+
				" (select car_mng_id, to_char(count(0)/21*100,999) use_per from scd_car where dt between to_char(sysdate-21,'YYYYMMDD') and to_char(sysdate,'YYYYMMDD') group by car_mng_id) j,  \n"+
				" (select car_mng_id, count(0) as a_cnt from accident where accid_st='6' group by car_mng_id) k,  \n"+
				" (select * from code where c_st='0039') f \n"+
				" where nvl(b.use_yn,'Y')='Y' and ( b.car_st='2'  or a.ip_chk  = 'Y' ) \n "+
				" and a.off_ls ='0' and a.car_mng_id=b.car_mng_id  \n"+
				" and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd  \n"+
				" and c.car_id=d.car_id and c.car_seq=d.car_seq  \n"+
				" and i.cust_id=l.client_id(+) and i.cust_id=n.user_id(+) and i.cust_id=m.cust_id(+)  \n"+
				" and a.car_mng_id=i.car_mng_id(+)  \n"+
				" and a.car_mng_id=j.car_mng_id(+)  \n"+
				" and a.car_mng_id=k.car_mng_id(+)  \n"+
				" and b.rent_mng_id=q.rent_mng_id(+) and b.rent_l_cd=q.rent_l_cd(+)  \n"+
				" and i.bus_id=p.user_id(+) and a.fuel_kd=f.nm_cd and nvl(a.prepare, '1')  not in ('4' , '5' ) and nvl(i.rent_st, '99')  not in ('4', '5') \n";
	
			
		
		if(s_kd.equals("1"))			query += " and upper(a.car_no)||upper(a.first_car_no) like upper('%"+t_wd+"%')\n";		
		if(s_kd.equals("2"))			query += " and a.init_reg_dt like '"+t_wd+"%'\n";		


		
		query += " order by decode(nvl(a.prepare,'1'),'2','2','5','3','4','4','8','5','1'), decode(nvl(q.mng_br_id,b.brch_id),'S1',1,'K1',1,'B1',2,'N1',2,'D1',3), decode(i.use_st,'1','1','2','2','0'), decode(i.use_st,'1',i.rent_st,'2',decode(i.rent_st,'6','0.1','7','0.2','8','0.3',i.rent_st),'0'), a.park, a.dpm desc";
		

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
			System.out.println("[ResSearchDatabase:getRentPrepareRealList2]"+e);
			System.out.println("[ResSearchDatabase:getRentPrepareRealList2]"+query);
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
	*	출고차량 지정 
	*/
	public int setCar_ip(String[] pre, String mode) throws SQLException
	{
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;

		String query = "UPDATE car_reg SET ip_chk = '"+mode+"' WHERE car_mng_id in ('";		
		
		for(int i=0 ; i<pre.length ; i++){
			if(i == (pre.length -1))	query += pre[i];
			else						query += pre[i]+"', '";
		}
		query+="')";

		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		}catch(SQLException e){
			System.out.println("[ResSearchDatabase:setCar_ip(String[] pre, String mode)]"+e);
			System.out.println("[ResSearchDatabase:setCar_ip]"+query);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
                if(pstmt != null) pstmt.close();
				conn.setAutoCommit(true);
            }catch(SQLException _ignored){}

			closeConnection();
		}
		return result;
	}
	
	/**	
	 *	차량입고처리 수정
	 */
	public int updateCarIpPark(String c_id, String park, String park_cont)
	{
		getConnection();
		int count = 0;
		PreparedStatement pstmt = null;
		String query = "";
		query = " update CAR_REG set park='"+park+"', park_cont='"+park_cont+"'  , ip_chk = 'Y' where CAR_MNG_ID='"+c_id+"'";
		
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.executeUpdate();
			pstmt.close();
			count =1;

			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[ResSearchDatabase:updateCarIpPark]\n"+e);
			System.out.println("[ResSearchDatabase:updateCarIpPark]\n"+query);
			e.printStackTrace();
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	/**
	 *	차량별 예약현황 리스트
	 */
	public Vector getResCarList2(String c_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select g.car_no, g.first_car_no, a.rent_s_cd,"+
				" decode(a.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','장기대기','12','월렌트') rent_st,"+
				" decode(a.use_st,'1','예약','2','배차','3','반차','4','종료','5','취소') use_st,"+
				" nvl(a.deli_dt,a.rent_start_dt) deli_dt, nvl(a.ret_dt,a.ret_plan_dt) ret_dt,"+
				" nvl(a.deli_dt,a.rent_start_dt) rent_start_dt, nvl(nvl(a.ret_dt,a.ret_plan_dt),a.rent_end_dt) rent_end_dt,"+
				" a. rent_hour, (b.fee_s_amt+b.fee_v_amt) fee_amt,"+
				" decode(a.cust_st, '','조성희', '1',e.client_nm, '4',f.user_nm, d.cust_nm) cust_nm,"+
				" decode(a.cust_st, '','(주)아마존카', '1',e.firm_nm, '4','(주)아마존카', d.firm_nm) firm_nm,"+
				" decode(a.cust_st, '','', '1',TEXT_DECRYPT(e.ssn, 'pw' ) , '4',  TEXT_DECRYPT(f.user_ssn, 'pw' )  , d.ssn) ssn,"+
				" decode(a.cust_st, '','', '1',e.enp_no, '4','', d.enp_no) enp_no,"+
				" h.car_no as sub_car_no"+
				" from RENT_CONT a, RENT_FEE b, RENT_SETTLE c, RENT_CUST d, CLIENT e, users f, car_reg g, car_reg h"+
				" where "+
				" a.rent_s_cd=b.rent_s_cd(+) and a.rent_s_cd=c.rent_s_cd(+)"+
				" and a.cust_id=d.cust_id(+) and a.cust_id=e.client_id(+) and a.cust_id=f.user_id(+)"+
				" and (a.car_mng_id='"+c_id+"' or a.sub_c_id='"+c_id+"')"+
				" and a.car_mng_id=g.car_mng_id and a.sub_c_id=h.car_mng_id(+)"+
				" order by a.rent_start_dt desc";

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
			System.out.println("[ResSearchDatabase:getResCarList2]"+e);
			System.out.println("[ResSearchDatabase:getResCarList2]"+query);
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
	 *	차량별 예약현황 리스트
	 */
	public Hashtable getResCarCase(String c_id, String use_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select "+
				" rent_s_cd, car_mng_id,"+
				" decode(a.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','장기대기','12','월렌트') rent_st,"+
				" decode(a.use_st,'1','예약','2','배차','3','반차','4','종료','5','취소') use_st,"+
				" nvl(a.deli_dt,a.rent_start_dt) deli_dt, "+
				" nvl(a.ret_dt,nvl(a.ret_plan_dt,a.ret_plan_dt)) ret_dt,"+
				" substr(nvl(a.ret_dt,nvl(a.ret_plan_dt,a.rent_end_dt)),1,8) ret_dt2,"+
				" decode(a.cust_st, '','조성희', '1',e.client_nm, f.user_nm) cust_nm,"+
				" decode(a.cust_st, '','(주)아마존카', '1',e.firm_nm, '(주)아마존카') firm_nm, a.reg_dt, a.reg_id "+
				" from RENT_CONT a, CLIENT e, users f"+
				" where a.car_mng_id='"+c_id+"' and a.use_st='"+use_st+"'"+
				" and a.cust_id=e.client_id(+) and a.cust_id=f.user_id(+)"+
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
			System.out.println("[ResSearchDatabase:getResCarCase]"+e);
			System.out.println("[ResSearchDatabase:getResCarCase]"+query);
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
	
///////////////////////추가 류길선 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	/**
	 *	반차관리 리스트(입고)
	 */
	public Vector getRentMngList2(String dt, String ref_dt1, String ref_dt2, String s_kd, String t_wd,  String gsjg, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		query =	" select "+
				" a.rent_s_cd, a.ret_loc, a.deli_loc, a.car_mng_id, cd3.nm as rent_st,"+
				" decode(a.cust_st, '','아마존카', '4',e.user_nm, d.firm_nm) cust_nm,"+
				" decode(a.cust_st, '','아마존카', '4',e.user_nm, d.firm_nm) firm_nm,"+
				" a.rent_dt, a.rent_start_dt, a.rent_end_dt, a.deli_plan_dt, a.ret_plan_dt, a.deli_dt, a.ret_dt, decode(a.brch_id, 'S1','본사','B1','부산','D1','대전') brch_id, a.bus_id,"+
				" c.car_no,   decode(c.park,'6',substr(c.park_cont,1,5),nvl(cd.nm,c.park)) park, c.init_reg_dt, c.dpm, cd2.nm as fuel_kd, c.car_nm, "+
				" g.user_nm as bus_nm, a.in_dt, a.out_dt, decode(a.in_dt, null,'예정', '', '예정', '완료') as gubun, G.USER_NM AS REG_ID "+
				" from RENT_CONT a, RENT_FEE b, CAR_REG c, CLIENT d, USERS e, CAR_MNG j , users g, "+
				"        ( select c_st, code, nm_cd, nm from code where c_st = '0027') cd,  \n"+  //주차장 
				"        ( select c_st, code, nm_cd, nm from code where c_st = '0039') cd2, \n"+
				"        ( select c_st, code, nm_cd, nm from code where c_st = '0042') cd3  \n"+
				" where a.use_st='4' and a.rent_s_cd=b.rent_s_cd(+) and a.car_mng_id=c.car_mng_id and a.cust_id=d.client_id(+) and a.cust_id=e.user_id(+)"+
				" and c.car_nm=j.car_nm(+) and a.bus_id=g.user_id  and c.park = cd.nm_cd(+) and c.fuel_kd=cd2.nm_cd and a.rent_st=cd3.nm_cd ";

		if(dt.equals("1"))	query += " and a.ret_dt like to_char(sysdate,'YYYYMMDD')||'%'";
        if(dt.equals("2"))	query += " and a.ret_dt like to_char(sysdate,'YYYYMM')||'%'\n";
        if(dt.equals("3"))	query += " and a.ret_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')\n";

		if(gsjg.equals("1"))	query += " and decode(a.in_dt, NULL, '예정', '', '예정', '완료' ) is not null \n";
		if(gsjg.equals("2"))	query += " and decode(a.in_dt, NULL, '예정', '', '예정', '완료' ) =  '예정' \n";
		if(gsjg.equals("3"))	query += " and decode(a.in_dt, NULL, '예정', '', '예정', '완료' ) =  '완료' \n";

		if(s_kd.equals("1"))	query += " and c.car_no like upper('%"+t_wd+"%')\n";		
		if(s_kd.equals("2"))	query += " and c.car_nm like upper('%"+t_wd+"%')\n";		
		if(s_kd.equals("3"))	query += " and park like '%"+t_wd+"%'\n";		
		
		if(sort_gubun.equals("1"))		query += " order by c.car_no "+asc;
		if(sort_gubun.equals("4"))		query += " order by c.car_nm "+asc;  

		query += " union "+
				" select "+
				" '', '', '', a.car_mng_id, decode(a.io_sau, '1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','장기대기','12','월렌트') AS rent_st, '', '', '', '', '', '', substr(a.io_dt, 1,8) as ret_plan_dt, '', '', "+
				" decode( a.br_id, 'S1', '본사', 'B1', '부산', 'D1', '대전' ) brch_id, '', a.car_no, "+
				" decode( a.park_id, '1', '영남주차장', '2', '정일현대', '3', '본사지하', '4', '부산지점', '5', '대전지점', '6', '파주차고지',	'7', '포천차고지', '8', '김해차고지' ) AS park, "+
				" b.init_reg_dt, b.DPM, cd2.nm AS fuel_kd, a.car_nm, a.park_mng, '', '', decode(a.car_st, 1,'예정',2,'완료' ) AS gubun, a.reg_id"+
				" from park_io a, car_reg b, cont c, car_etc d, ( select c_st, code, nm_cd, nm from code where c_st = '0039') cd2 "+
				" WHERE a.car_mng_id = b.car_mng_id(+) AND a.car_mng_id = c.car_mng_id(+) AND c.rent_l_cd = d.rent_l_cd(+) and io_gubun = '1' and b.fuel_kd=cd2.nm_cd";

		if(dt.equals("1"))	query += " and a.io_dt like to_char(sysdate,'YYYYMMDD')||'%'";
        if(dt.equals("2"))	query += " and a.io_dt like to_char(sysdate,'YYYYMM')||'%'\n";
        if(dt.equals("3"))	query += " and a.io_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')\n";
		
		if(gsjg.equals("1"))	query += " and decode(a.car_st, 1, '예정', 2, '완료', '') is not null \n";
		if(gsjg.equals("2"))	query += " and decode(a.car_st, 1, '예정', 2, '완료') =  '예정' \n";
		if(gsjg.equals("3"))	query += " and decode(a.car_st, 1, '예정', 2, '완료') =  '완료' \n";
		
		if(s_kd.equals("1"))	query += " and a.car_no like upper('%"+t_wd+"%')\n";		
		if(s_kd.equals("2"))	query += " and a.car_nm like upper('%"+t_wd+"%')\n";		
		if(s_kd.equals("3"))	query += " and park like '%"+t_wd+"%'\n";		
		
		if(sort_gubun.equals("1"))		query += " order by a.car_no "+asc;
		if(sort_gubun.equals("4"))		query += " order by a.car_nm "+asc;  


		query += " order by gubun asc";


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
			System.out.println("[ResSearchDatabase:getRentMngList2]"+e);
			System.out.println("[ResSearchDatabase:getRentMngList2]"+query);
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
	 *	배차관리 리스트(출고)
	 */
	public Vector getRentMngList3(String dt, String ref_dt1, String ref_dt2, String s_kd, String t_wd, String gsjg, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query =	" select"+
				" a.rent_s_cd, a.ret_loc, a.deli_loc, a.car_mng_id, cd3.nm as rent_st,"+
				" decode(a.cust_st, '4',c.user_nm, b.firm_nm) cust_nm,"+
				" a.rent_dt, a.rent_start_dt, a.rent_end_dt, a.deli_plan_dt, a.ret_plan_dt, a.deli_dt, a.ret_dt, decode(a.brch_id, 'S1','본사','B1','부산','D1','대전') brch_id, a.bus_id,"+
				" d.car_no, decode(d.park,'6',substr(d.park_cont,1,5),nvl(cd.nm,d.park)) park, d.init_reg_dt, d.dpm, cd2.nm as fuel_kd, d.car_nm, f.user_nm as bus_nm, "+
				" a.in_dt, a.out_dt, decode( a.out_dt, NULL, '예정', '', '예정', '완료' ) AS gubun, F.USER_NM AS REG_ID"+
				" from RENT_CONT a, CLIENT b, USERS c, CAR_REG d, car_mng e, users f ,"+ 
				"        ( select c_st, code, nm_cd, nm from code where c_st = '0027') cd,  \n"+  //주차장  
				"        ( select c_st, code, nm_cd, nm from code where c_st = '0039') cd2, \n"+
				"        ( select c_st, code, nm_cd, nm from code where c_st = '0042') cd3  \n"+				
				" where (a.use_st = '1' or a.use_st = '2') and a.rent_st <> '11' /*장기대기 제외, 예약도 보여주기*/and a.cust_id=b.client_id(+) and a.cust_id=c.user_id(+)"+
				" and a.car_mng_id=d.car_mng_id and d.car_nm=e.car_nm(+) and a.bus_id=f.user_id  and d.park = cd.nm_cd(+)  and d.fuel_kd = cd2.nm_cd and a.rent_st = cd3.nm_cd ";

		if(dt.equals("1"))	query += " and a.deli_plan_dt like to_char(sysdate,'YYYYMMDD')||'%'";
        if(dt.equals("2"))	query += " and a.deli_plan_dt like to_char(sysdate,'YYYYMM')||'%'\n";
        if(dt.equals("3"))	query += " and a.deli_plan_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')\n";

		if(gsjg.equals("1"))	query += " and decode(a.out_dt, NULL, '예정', '', '예정', '완료' ) is not null \n";
		if(gsjg.equals("2"))	query += " and decode(a.out_dt, NULL, '예정', '', '예정', '완료' ) =  '예정' \n";
		if(gsjg.equals("3"))	query += " and decode(a.out_dt, NULL, '예정', '', '예정', '완료' ) =  '완료' \n";

		if(s_kd.equals("1"))			query += " and d.car_no like upper('%"+t_wd+"%')\n";		
		if(s_kd.equals("2"))			query += " and d.car_nm like upper('%"+t_wd+"%')\n";		
		if(s_kd.equals("3"))			query += " and park like '%"+t_wd+"%'\n";		


		if(sort_gubun.equals("1"))		query += " order by a.deli_plan_dt, d.car_no "+asc ;
		if(sort_gubun.equals("4"))		query += " order by a.deli_plan_dt, d.car_nm "+asc ;

		query +=" union "+
				" select "+
				" '', '', '', a.car_mng_id, decode(a.io_sau, '1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','장기대기','12','월렌트') AS rent_st, '', '', '', '', '', substr(a.io_dt, 1,8) as deli_plan_dt, '', '', "+
				" decode( a.br_id, 'S1', '본사', 'B1', '부산', 'D1', '대전' ) brch_id, '', a.car_no, "+
				" decode( a.park_id, '1', '영남주차장', '2', '정일현대, '3', '본사지하', '4', '부산지점', '5', '대전지점', '6', '파주차고지',	'7', '포천차고지', '8', '김해차고지' ) AS park, "+
				" b.init_reg_dt, b.DPM, cd2.nm as fuel_kd, a.car_nm, '', '', '', decode(a.car_st, 1,'예정',2,'완료' ) AS gubun, a.REG_ID"+
				" from park_io a, car_reg b, cont c, car_etc d, "+
				"        ( select c_st, code, nm_cd, nm from code where c_st = '0039') cd2 \n"+
				" WHERE a.car_mng_id = b.car_mng_id(+) AND a.car_mng_id = c.car_mng_id(+) AND c.rent_l_cd = d.rent_l_cd(+) and io_gubun = '2'  and b.FUEL_KD = cd2.nm_cd ";

		if(dt.equals("1"))	query += " and a.io_dt like to_char(sysdate,'YYYYMMDD')||'%'";
        if(dt.equals("2"))	query += " and a.io_dt like to_char(sysdate,'YYYYMM')||'%'\n";
        if(dt.equals("3"))	query += " and a.io_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')\n";
		
		if(gsjg.equals("1"))	query += " and decode(a.car_st, 1, '예정', 2, '완료', '') is not null \n";
		if(gsjg.equals("2"))	query += " and decode(a.car_st, 1, '예정', 2, '완료') =  '예정' \n";
		if(gsjg.equals("3"))	query += " and decode(a.car_st, 1, '예정', 2, '완료') =  '완료' \n";
		
		if(s_kd.equals("1"))	query += " and a.car_no like upper('%"+t_wd+"%')\n";		
		if(s_kd.equals("2"))	query += " and a.car_nm like upper('%"+t_wd+"%')\n";		
		if(s_kd.equals("3"))	query += " and park like '%"+t_wd+"%'\n";		

		if(sort_gubun.equals("1"))		query += " order by deli_plan_dt, a.car_no "+asc;
		if(sort_gubun.equals("4"))		query += " order by deli_plan_dt, a.car_nm "+asc;  

		query += " order by gubun asc";


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
			System.out.println("[ResSearchDatabase:getRentMngList3]"+e);
			System.out.println("[ResSearchDatabase:getRentMngList3]"+query);
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
	 *	차고지별 차량 현황 
	 */
	public Vector getRentParkRealList(String br_id, String gubun1, String start_dt, String end_dt, String s_cc,  int s_year, String s_kd, String t_wd, String sort_gubun, String asc )
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select  t.car_use, t.brch_id, t.p_p, t.uu_st, t.rr_st, t.brch_nm, t.car_mng_id, t.car_no, t.car_nm, t.init_reg_dt, "+
				" t.car_st, t.rent_dt, t.rent_start_dt, t.rent_end_dt, t.deli_plan_dt, t.ret_plan_dt, t.bus_nm, t.fuel_kd, t.dpm, t.taking_p, "+
			    " t.colo, t.use_st, t.rent_st, t.rent_s_cd, t.first_car_no, t.prepare, t.park, t.park_cont, t.car_stat, "+
			    " t.rent_st_nm, t.cust_nm, t.firm_nm, decode(t.car_stat, '배차', decode(t.rent_st_nm,'업무', t.cust_nm, t.firm_nm), t.park ) as park_nm \n"+
			    " from (  \n"+
				"        select decode(nvl(q.mng_br_id,b.brch_id),'S1',1,'K1',1,'B1',2,'N1',2,'D1',3) brch_id, decode(nvl(a.prepare,'1'),'2','2','5','3','4','4','8','5','1') p_p, \n"+
				"        decode(i.use_st,'1','1','2','2','0') as uu_st, decode(i.use_st,'1',i.rent_st,'2',decode(i.rent_st,'6','0.1','7','0.2','8','0.3',i.rent_st),'0') rr_st,  \n"+
				"        decode(nvl(q.mng_br_id,b.brch_id),'S1','본사','K1','본사','S2','본사','B1','부산지점','N1','부산지점','D1','대전지점','G1','대구지점','J1','광주지점','본사') brch_nm, a.car_mng_id, a.car_no, a.car_nm, a.init_reg_dt, b.car_st, b.rent_dt, i.rent_start_dt, i.rent_end_dt, i.deli_plan_dt, i.ret_plan_dt, p.user_nm as bus_nm, \n"+
				"        cd2.nm as fuel_kd,  \n"+
				"        a.dpm, a.car_use, a.taking_p, c.colo,  i.use_st, i.rent_st, i.rent_s_cd, a.first_car_no, \n"+
				"        decode(a.prepare, '2','매각', '3','보관', '4','말소', '5','도난', '6','해지', '8','수해', '예비') prepare, " +
				"        decode(a.park,'6',substr(a.park_cont,1,5),nvl(cd.nm,a.park)) park, a.park_cont,  \n"+
				"        decode(i.use_st, '1','예약','2','배차',decode(a.prepare,'4','-','5','-','6','-','8','-','대기')) car_stat,  \n"+
				"        decode(a.prepare,'4','-','5','-','6','-','8','-', decode(i.rent_st,'1','단기','2','정비','3','사고','9','보험','10','지연','4','업무','5','업무','6','정비','7','정비','8','수리','11','대기')) rent_st_nm,  \n"+
				"        decode(i.cust_st, '', '조성희', '1',l.client_nm, '4',n.user_nm, m.cust_nm) cust_nm,  \n"+
				"        decode(i.cust_st, '', '아마존카', '1',replace(l.firm_nm,'(주)',''), '4','아마존카', m.firm_nm) firm_nm \n"+
				"        from car_reg a, cont b, car_etc c, client l, users n, rent_cust m, users p, cont_etc q, \n"+
				"               ( select c_st, code, nm_cd, nm from code where c_st = '0027') cd,  \n"+  //주차장 
				"               ( select c_st, code, nm_cd, nm from code where c_st = '0039') cd2,  \n"+ 
				"               (select a.* from rent_cont a, (select car_mng_id, max(nvl(deli_dt,decode(use_st,'1','0000000000',deli_plan_dt))) deli_dt from rent_cont where use_st in ('1','2') group by car_mng_id) b where a.use_st in ('1','2') and a.car_mng_id=b.car_mng_id and nvl(a.deli_dt,decode(a.use_st,'1','0000000000',a.deli_plan_dt))=b.deli_dt) i,  \n "+
				"               (select car_mng_id, count(0) as a_cnt from accident where accid_st='6' group by car_mng_id) k  \n"+
				"        where nvl(b.use_yn,'Y')='Y' and ( b.car_st='2'  or a.ip_chk  = 'Y' ) \n "+
				"        and a.off_ls ='0' and a.car_mng_id=b.car_mng_id  \n"+
				"        and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd  \n"+
				"        and i.cust_id=l.client_id(+) and i.cust_id=n.user_id(+) and i.cust_id=m.cust_id(+)  \n"+
				"        and a.car_mng_id=i.car_mng_id(+)  \n"+
				"        and a.park = cd.nm_cd(+) \n"+
				"        and a.fuel_kd = cd2.nm_cd \n"+
				"        and a.car_mng_id=k.car_mng_id(+) and i.bus_id=p.user_id(+) \n"+
				"        and b.rent_mng_id=q.rent_mng_id(+) and b.rent_l_cd=q.rent_l_cd(+) \n"+
				"     ) t \n"+
				" where ( decode(t.car_stat, '배차', decode(t.rent_st_nm,'업무', t.cust_nm, t.firm_nm), t.park ) like '%영남%' OR decode(t.car_stat, '배차', decode(t.rent_st_nm,'업무', t.cust_nm, t.firm_nm), t.park ) like '%부산%' OR decode(t.car_stat, '배차', decode(t.rent_st_nm,'업무', t.cust_nm, t.firm_nm), t.park ) like '%대전%')  \n"; 

		if(s_kd.equals("1"))	query += " and upper(t.car_no)||upper(t.first_car_no) like upper('%"+t_wd+"%')\n";		
		if(s_kd.equals("2"))	query += " and t.init_reg_dt like '"+t_wd+"%'\n";
		if(s_kd.equals("4"))	query += " and upper(t.car_nm) like upper('%"+t_wd+"%')\n";			
		if(s_kd.equals("5"))	query += " and decode(t.car_stat, '배차', decode(t.rent_st_nm,'업무', t.cust_nm, t.firm_nm), t.park ) like '%"+t_wd+"%'\n";		

			if(gubun1.equals("1"))		query += " and t.car_use = '1' ";
  			if(gubun1.equals("2"))		query += " and t.car_use = '2' ";
			if(gubun1.equals("11"))		query += " and t.car_st = '2' ";
  			if(gubun1.equals("12"))		query += " and t.car_st in ('1','3') ";
  			if(gubun1.equals("3"))		query += " and t.taking_p = 5 ";
  			if(gubun1.equals("4"))		query += " and t.taking_p = 7 ";
			if(gubun1.equals("5"))		query += " and t.taking_p >= 9 ";
  			if(gubun1.equals("6"))		query += " and t.taking_p <= 3 ";
  			if(gubun1.equals("7"))		query += " and t.fuel_kd like '휘발유' ";
  			if(gubun1.equals("8"))		query += " and t.fuel_kd like '%경유%' ";
			if(gubun1.equals("9"))		query += " and t.fuel_kd like '%LPG%' ";
  			if(gubun1.equals("10"))		query += " and t.fuel_kd like '%겸용%' ";

  			if(gubun1.equals("13"))		query += " and decode(t.car_stat, '배차', decode(t.rent_st_nm,'업무', t.cust_nm, t.firm_nm), t.park ) like '%영남%' ";
  			if(gubun1.equals("14"))		query += " and decode(t.car_stat, '배차', decode(t.rent_st_nm,'업무', t.cust_nm, t.firm_nm), t.park ) like '%부산%' ";
  			if(gubun1.equals("15"))		query += " and decode(t.car_stat, '배차', decode(t.rent_st_nm,'업무', t.cust_nm, t.firm_nm), t.park ) like '%대전%' ";

		
 	  query += " union "+
				" select "+
				" b.car_use, decode(a.br_id, 'S1', 1, 'K1', 1, 'B1', 2, 'N1', 2, 'D1', 3) brch_id, decode( nvl(b.prepare, '1' ), '2', '2', '5', '3', '4', '4', '8', '5', '1' ) p_p, '', '', decode(a.br_id,'S1','본사','K1','본사','B1','부산지점','N1','부산지점','D1','대전지점','G1','대구지점','J1','광주지점','본사') brch_nm, a.car_mng_id, b.car_no, b.car_nm, b.init_reg_dt,  decode(c.car_st, 1,'1',2,'2' ) AS gubun, "+
				" '', '', '', '', substr(a.io_dt, 1,8) as ret_plan_dt, '', cd2.nm as fuel_kd, b.DPM, b.taking_p, d.colo, '', decode(a.io_sau, '1','단기대여','2','보험대차','3','지연대차','4','사고대차','5','정비대차','6','업무대여','7','장기대기','8','예약','9','차량정비','10','사고수리','11','임시','12','월렌트') AS rent_st, "+
				" '',  a.car_no as first_car_no, decode(b.prepare, '2', '매각', '3', '보관', '4', '말소',  '5', '도난', '6', '해지', '8', '수해', '임시' ) prepare, "+
				" decode( a.park_id, '1', '영남주차장', '2', '정일현대', '3', '본사지하', '4', '부산지점', '5', '대전지점', '6', '파주차고지', '7', '포천차고지', '8', '김해차고지' ) AS park, "+
				" '', '',decode(a.io_sau, '1','단기대여','2','보험대차','3','지연대차','4','사고대차','5','정비대차','6','업무대여','7','장기대기','8','예약','9','차량정비','10','사고수리','11','임시','12','월렌트') AS rent_st_nm, '', '', decode( a.park_id, '1', '영남주차장', '2', '정일현대', '3', '본사지하', '4', '부산지점', '5', '대전지점', '6', '파주차고지', '7', '포천차고지', '8', '김해차고지' ) AS park_nm "+
				" from park_io a, car_reg b, cont c, car_etc d, (select car_mng_id, max(park_seq) as seq from park_io group by car_mng_id ) e, "+
				"               ( select c_st, code, nm_cd, nm from code where c_st = '0039') cd2  \n"+
				" WHERE a.car_mng_id = e.car_mng_id and mod(e.seq, 2) > 0 and a.park_seq = seq and a.car_mng_id = b.car_mng_id(+) AND a.car_mng_id = c.car_mng_id(+) \n"+
				"       AND c.rent_l_cd = d.rent_l_cd(+) and io_gubun = '1' and c.car_st = '2' and a.park_id IN ('1','2','3','4','5','6','7','8') and b.FUEL_KD=cd2.nm_cd ";

		if(s_kd.equals("1"))	query += " and upper(a.car_no)||upper(first_car_no) like upper('%"+t_wd+"%')\n";		
		if(s_kd.equals("2"))	query += " and b.init_reg_dt like '"+t_wd+"%'\n";
		if(s_kd.equals("4"))	query += " and upper(a.car_nm) like ('%"+t_wd+"%')\n";			
		if(s_kd.equals("5"))	query += " and decode( a.park_id, '1', '영남주차장', '2', '정일현대', '3', '본사지하', '4', '부산지점', '5', '대전지점', '6', '파주차고지', '7', '포천차고지', '8', '김해차고지' )  like '%"+t_wd+"%'\n";		

			if(gubun1.equals("1"))		query += " and b.car_use = '1' ";
  			if(gubun1.equals("2"))		query += " and b.car_use = '2' ";
			if(gubun1.equals("11"))		query += " and c.car_st = '2' ";
  			if(gubun1.equals("12"))		query += " and c.car_st in ('1','3') ";
  			if(gubun1.equals("3"))		query += " and b.taking_p = 5 ";
  			if(gubun1.equals("4"))		query += " and b.taking_p = 7 ";
			if(gubun1.equals("5"))		query += " and b.taking_p >= 9 ";
  			if(gubun1.equals("6"))		query += " and b.taking_p <= 3 ";
  			if(gubun1.equals("7"))		query += " and cd2.nm like '휘발유' ";
  			if(gubun1.equals("8"))		query += " and cd2.nm like '%경유%' ";
			if(gubun1.equals("9"))		query += " and cd2.nm like '%LPG%' ";
  			if(gubun1.equals("10"))		query += " and cd2.nm like '%겸용%' ";

  			if(gubun1.equals("13"))		query += " and a.park_id IN ('1','2','3','6','7') ";
  			if(gubun1.equals("14"))		query += " and a.park_id IN ('5') ";
  			if(gubun1.equals("15"))		query += " and a.park_id IN ('4','8') ";

 		if(sort_gubun.equals("5"))		query += " order by prepare  "+asc;


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
			System.out.println("[ResSearchDatabase:getRentParkRealList]"+e);
			System.out.println("[ResSearchDatabase:getRentParkRealList]"+query);
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
	 *	차고지별 차량 한건 조회 
	 */
	public Vector getselectParking(String car_mng_id, String car_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select t.*, decode(t.car_stat, '배차', decode(t.rent_st_nm,'업무', t.cust_nm, t.firm_nm), t.park ) as park_nm \n"+
				" from (  \n"+
				"        select decode(nvl(q.mng_br_id,b.brch_id),'S1',1,'K1',1,'B1',2,'N1',2,'D1',3) brch_id, decode(nvl(a.prepare,'1'),'2','2','5','3','4','4','8','5','1') p_p, \n"+
				"        decode(i.use_st,'1','1','2','2','0') as uu_st, decode(i.use_st,'1',i.rent_st,'2',decode(i.rent_st,'6','0.1','7','0.2','8','0.3',i.rent_st),'0') rr_st,  \n"+
				"        decode(nvl(q.mng_br_id,b.brch_id),'S1','본사','K1','본사','S2','본사','B1','부산지점','N1','부산지점','D1','대전지점','G1','대구지점','J1','광주지점','본사') brch_nm, a.car_mng_id, a.car_no, a.car_nm, a.init_reg_dt, b.car_st, b.rent_dt, i.rent_start_dt, i.rent_end_dt, i.deli_plan_dt, i.ret_plan_dt, p.user_nm as bus_nm, \n"+
				"        f.nm as fuel_kd,  \n"+
				"        a.dpm, c.colo,  i.use_st, i.rent_st, i.rent_s_cd, a.first_car_no, \n"+
				"        decode(a.prepare, '2','매각', '3','보관', '4','말소', '5','도난', '6','해지', '8','수해', '예비') prepare, a.park, a.park_cont,  \n"+
				"        decode(i.use_st, '1','예약','2','배차',decode(a.prepare,'4','-','5','-','6','-','8','-','대기')) car_stat,  \n"+
				"        decode(a.prepare,'4','-','5','-','6','-','8','-', decode(i.rent_st,'1','단기','2','정비','3','사고','9','보험','10','지연','4','업무','5','업무','6','정비','7','정비','8','수리','11','대기')) rent_st_nm,  \n"+
				"        decode(i.cust_st, '', '조성희', '1',l.client_nm, '4',n.user_nm, m.cust_nm) cust_nm,  \n"+
				"        decode(i.cust_st, '', '아마존카', '1',replace(l.firm_nm,'(주)',''), '4','아마존카', m.firm_nm) firm_nm \n"+
				"        from car_reg a, cont b, car_etc c, client l, users n, rent_cust m, users p, cont_etc q, \n"+
				"                    (select a.* from rent_cont a, (select car_mng_id, max(nvl(deli_dt,decode(use_st,'1','0000000000',deli_plan_dt))) deli_dt from rent_cont where use_st in ('1','2') group by car_mng_id) b where a.use_st in ('1','2') and a.car_mng_id=b.car_mng_id and nvl(a.deli_dt,decode(a.use_st,'1','0000000000',a.deli_plan_dt))=b.deli_dt) i,  \n "+
				"                    (select car_mng_id, count(0) as a_cnt from accident where accid_st='6' group by car_mng_id) k,  \n"+
				"                    (select * from code where c_st='0039') f "+
				"        where \n "+
				"        a.off_ls='0' and a.car_mng_id=b.car_mng_id and nvl(b.use_yn,'Y')='Y' and ( b.car_st='2'  or a.ip_chk  = 'Y' )  \n"+
				"        and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd  \n"+
				"        and i.cust_id=l.client_id(+) and i.cust_id=n.user_id(+) and i.cust_id=m.cust_id(+)  \n"+
				"        and a.car_mng_id=i.car_mng_id(+)  \n"+
				"        and a.car_mng_id=k.car_mng_id(+) and i.bus_id=p.user_id(+) \n"+
				"        and b.rent_mng_id=q.rent_mng_id(+) and b.rent_l_cd=q.rent_l_cd(+) \n"+
				"        and a.fuel_kd=f.nm_cd "+
				"      ) t \n"+
				" where car_mng_id ='"+car_mng_id+"' and car_no ='" + car_no+"'" ;


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
			System.out.println("[ResSearchDatabase:getselectParking]"+e);
			System.out.println("[ResSearchDatabase:getselectParking]"+query);
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
	*	입고일 갱신
	*/
	public int updateParkInRentContIn(String c_id, String s_cd, String serv_dt) throws SQLException
	{
		getConnection();
		int count = 0;
		PreparedStatement pstmt = null;
		String query = "";
		query = " update RENT_CONT set IN_DT='"+serv_dt+"' where CAR_MNG_ID='"+c_id+"' and RENT_S_CD='" + s_cd + "'";
		
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.executeUpdate();
			pstmt.close();
			count =1;

			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[ResSearchDatabase:updateParkInRentContIn]\n"+e);
			System.out.println("[ResSearchDatabase:updateParkInRentContIn]\n"+query);
			e.printStackTrace();
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	/**
	*	출고일 갱신
	*/
	public int updateParkInRentContOut(String c_id, String s_cd, String serv_dt) throws SQLException
	{
		getConnection();
		int count = 0;
		PreparedStatement pstmt = null;
		String query = "";
		query = " update RENT_CONT set OUT_DT='"+serv_dt+"' where CAR_MNG_ID='"+c_id+"' and RENT_S_CD='" + s_cd + "'";
		

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.executeUpdate();
			pstmt.close();
			count =1;

			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[ResSearchDatabase:updateParkInRentContOut]\n"+e);
			System.out.println("[ResSearchDatabase:updateParkInRentContOut]\n"+query);
			e.printStackTrace();
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	/**
	 *	보유차현황 리스트
	 */
	public Vector getRentPrepareEndList(String br_id, String gubun1, String gubun2, String brch_id, String start_dt, String end_dt, String car_comp_id, String code, String s_cc, int s_year, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";		

		query = " select "+
				" decode(nvl(q.mng_br_id,b.brch_id),'S1','본사','K1','본사','S2','본사','B1','부산지점','N1','부산지점','D1','대전지점','G1','대구지점','J1','광주지점','본사') brch_nm, a.car_mng_id, a.car_no, a.car_nm, d.car_name, a.init_reg_dt, b.rent_dt, i.rent_start_dt, i.rent_end_dt, i.deli_plan_dt, i.ret_plan_dt, p.user_nm as bus_nm,"+
				" cd2.nm as fuel_kd,"+
				" a.dpm, c.colo, nvl(j.use_per,0) use_per, i.use_st, i.rent_st, i.rent_s_cd, "+
				" decode(a.prepare, '2','매각', '3','보관', '4','말소', '5','도난', '6','해지', '8','수해', '9', '미회수', '예비') prepare, " +
				" decode(a.park,'6',substr(a.park_cont,1,5),nvl(cd.nm,a.park))  park, a.park_cont,"+
				" decode(i.use_st, '1','예약','2','배차',decode(a.prepare,'4','-','5','-','6','-','8','-','대기')) car_stat,"+
				" decode(a.prepare,'4','-','5','-','6','-', cd3.nm ) rent_st_nm,"+
				" decode(i.cust_st, '', '조성희', '1',l.client_nm, '4',n.user_nm, m.cust_nm) cust_nm,"+
				" decode(i.cust_st, '', '아마존카', '1',replace(l.firm_nm,'(주)',''), '4','아마존카', m.firm_nm) firm_nm,"+
				" TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.rent_dt, 'YYYYMMDD')) * 30.5) DAY, nvl(k.a_cnt,0) a_cnt, "+ 
				" /*네  고*/decode(o.situation,'0','상담중','1','계약진행중','2','계약확정','3','계약연동','') situation, o.memo, o.damdang, o.reg_dt as situation_dt"+
				" from car_reg a, cont b, car_etc c, car_nm d, client l, users n, rent_cust m, users p, cont_etc q,"+
				"        ( select c_st, code, nm_cd, nm from code where c_st = '0027') cd,  \n"+  //주차장 
				"        ( select c_st, code, nm_cd, nm from code where c_st = '0039') cd2, \n"+ 
				"        ( select c_st, code, nm_cd, nm from code where c_st = '0042') cd3, \n"+
				" (select a.* from rent_cont a, (select car_mng_id, max(nvl(deli_dt,decode(use_st,'1','0000000000',deli_plan_dt))) deli_dt from rent_cont where use_st in ('1','2') group by car_mng_id) b where a.use_st in ('1','2') and a.car_mng_id=b.car_mng_id and nvl(a.deli_dt,decode(a.use_st,'1','0000000000',a.deli_plan_dt))=b.deli_dt) i,"+
				" (select car_mng_id, to_char(count(0)/21*100,999) use_per from (select car_mng_id, dt from scd_car where dt between to_char(sysdate-21,'YYYYMMDD') and to_char(sysdate,'YYYYMMDD') group by car_mng_id, dt) group by car_mng_id) j,"+
				" (select car_mng_id, count(0) as a_cnt from accident where accid_st='6' group by car_mng_id) k,"+
				" (select a.*, b.user_nm as damdang from sh_res a, users b where a.seq = (select max(seq) from sh_res where car_mng_id=a.car_mng_id) and a.damdang_id=b.user_id) o"+
				" where "+
				" a.off_ls ='0' and a.car_mng_id=b.car_mng_id and nvl(b.use_yn,'Y')='Y' and b.car_st='2'"+
				" and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd"+
				" and c.car_id=d.car_id and c.car_seq=d.car_seq"+
				" and i.cust_id=l.client_id(+) and i.cust_id=n.user_id(+) and i.cust_id=m.cust_id(+)"+
				" and a.car_mng_id=i.car_mng_id(+)"+
				" and a.car_mng_id=j.car_mng_id(+)"+
				" and a.car_mng_id=k.car_mng_id(+)"+
				" and a.car_mng_id=o.car_mng_id(+) and i.bus_id=p.user_id(+)"+
				" and a.park = cd.nm_cd(+) \n"+  //주차장 코드 테이블 
				" and a.fuel_kd = cd2.nm_cd \n"+ 
				" and i.rent_st = cd3.nm_cd(+) \n"+
				" and b.rent_mng_id=q.rent_mng_id(+) and b.rent_l_cd=q.rent_l_cd(+)";
		
		query += " and decode(a.prepare,'','1','7','1',a.prepare) in ('4','5','6','8','9') order by decode(a.prepare,'','1','7','1',a.prepare)";	
		
		
	

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
			System.out.println("[ResSearchDatabase:getRentPrepareEndList]"+e);
			System.out.println("[ResSearchDatabase:getRentPrepareEndList]"+query);
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

//단기고객 정보 조회
	public RentCustBean getRentCustCase2(String cust_st, String cust_id, String rent_s_cd )
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		RentCustBean bean = new RentCustBean();
		String query = "";

		if(cust_st.equals("1")){//장기고객
			query = " select  'l' GUBUN,"+
					" decode(a.CLIENT_ST, '1','법인','2','개인','3','개인사업자(일반과세)','4','개인사업자(간이과세)','5','개인사업자(면세사업자)') AS CUST_ST,"+
					" a.CLIENT_ID AS CUST_ID, a.CLIENT_NM AS CUST_NM, nvl(a.FIRM_NM, a.client_nm) AS FIRM_NM,"+
					" decode(TEXT_DECRYPT(a.ssn, 'pw' ) ,'','',substr(TEXT_DECRYPT(a.ssn, 'pw' ),1,6)||'-'||substr(TEXT_DECRYPT(a.ssn, 'pw' ),7,7)) AS SSN,"+
					" decode(a.ENP_NO,'','',substr(a.enp_no,1,3)||'-'||substr(a.enp_no,4,2)||'-'||substr(a.enp_no,6,5)) AS ENP_NO,"+
					" '' LIC_NO, '' LIC_ST, a.O_TEL AS TEL, a.M_TEL, a.O_ZIP AS ZIP, a.O_ADDR AS ADDR, '' DEPT_NM, '' BRCH_NM, cr.CAR_NO, cr.CAR_NM "+
					" from CLIENT a, CONT_N_VIEW b, car_reg cr "+
					" where a.client_id=b.client_id(+) and  b.car_mng_id = cr.car_mng_id(+) and a.client_id='"+cust_id+"' and b.rent_mng_id = '"+rent_s_cd+"'";
		}else if(cust_st.equals("4")){//직원
			query = " select 'u' GUBUN,"+
					" '직원' CUST_ST,"+
					" a.USER_ID AS CUST_ID, a.USER_NM AS CUST_NM, '(주)아마존카' AS FIRM_NM,"+
					" decode(TEXT_DECRYPT(a.USER_SSN, 'pw' ) , '','', substr(TEXT_DECRYPT(a.USER_SSN, 'pw' ),1,6)||'-'||substr(TEXT_DECRYPT(a.USER_SSN, 'pw' ),7,7)) SSN,"+
					" '' ENP_NO,"+
					" a.LIC_NO, '' LIC_ST, '02-757-0802' TEL, a.USER_M_TEL AS M_TEL, '' ZIP, '' ADDR, b.nm AS DEPT_NM, c.br_nm AS BRCH_NM, '' CAR_NO, '' CAR_NM"+
					" from USERS a, code b, branch c"+
					" where b.c_st='0002' and a.dept_id=b.code and a.br_id=c.br_id"+
					" and nvl(a.USER_ID, ' ') like '%"+cust_id+"%'";
		}else{
			query = " select decode(client_id,'','s','l') GUBUN,"+
					" decode(CUST_ST, '1','법인','2','개인','3','개인사업자(일반과세)','4','개인사업자(간이과세)','5','개인사업자(면세사업자)') AS CUST_ST,"+
					" CUST_ID, CUST_NM, FIRM_NM,"+
					" decode(length(SSN), 0,'', 13,substr(ssn,1,6)||'-'||substr(ssn,7,7), SSN) AS SSN,"+
					" decode(length(ENP_NO), 0,'', 10,substr(enp_no,1,3)||'-'||substr(enp_no,4,2)||'-'||substr(enp_no,6,5), ENP_NO) AS ENP_NO,"+
					" LIC_NO, decode(LIC_ST,'1','1종보통','2','2종보통','') LIC_ST, TEL, M_TEL, ZIP, ADDR, '' DEPT_NM, '' BRCH_NM, '' CAR_NO, '' CAR_NM"+
					" from RENT_CUST"+
					" where cust_id='"+cust_id+"'";
		}
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();		
			if(rs.next())
			{			
				 bean.setCust_id(cust_id);
				 bean.setCust_st(rs.getString(2)==null?"":rs.getString(2));
				 bean.setCust_nm(rs.getString(4)==null?"":rs.getString(4));
				 bean.setFirm_nm(rs.getString(5)==null?"":rs.getString(5));
				 bean.setSsn(rs.getString(6)==null?"":rs.getString(6));
				 bean.setEnp_no(rs.getString(7)==null?"":rs.getString(7));
				 bean.setLic_no(rs.getString(8)==null?"":rs.getString(8));
				 bean.setLic_st(rs.getString(9)==null?"":rs.getString(9));
				 bean.setTel(rs.getString(10)==null?"":rs.getString(10));
				 bean.setM_tel(rs.getString(11)==null?"":rs.getString(11));
				 bean.setZip(rs.getString(12)==null?"":rs.getString(12));
				 bean.setAddr(rs.getString(13)==null?"":rs.getString(13));
				 bean.setDept_nm(rs.getString(14)==null?"":rs.getString(14));
				 bean.setBrch_nm(rs.getString(15)==null?"":rs.getString(15));
				 bean.setCar_no(rs.getString(16)==null?"":rs.getString(16));
				 bean.setCar_nm(rs.getString(17)==null?"":rs.getString(17));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:getRentCustCase2]\n"+e);
			System.out.println("[ResSearchDatabase:getRentCustCase2]\n"+query);
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
	 *	지연대차 정보
	 */
	public Hashtable getInfoTeacha(String cust_id, String car_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

			query = " select \n"+
					" a.car_mng_id, '' serv_dt, '' off_nm, d.car_no, g.car_nm  \n"+
					" from cont a, client b, taecha c, car_reg d, car_etc e, CAR_NM f, car_mng g \n"+
					" where a.client_id='"+cust_id+"' and a.client_id=b.client_id \n"+
					" and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) \n"+
					" and a.car_mng_id=d.car_mng_id(+) \n"+
				    " AND a.rent_mng_id=e.rent_mng_id AND a.rent_l_cd=e.RENT_L_CD \n"+
			        " AND e.car_id=f.car_id AND e.car_seq=f.car_seq AND f.car_comp_id=g.car_comp_id AND f.car_cd=g.code \n"+
					//" and (a.rent_l_cd='"+car_no+"' or c.car_no='"+car_no+"')"+ 
					" and a.car_mng_id is null  ";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:getInfoTeacha]"+e);
			System.out.println("[ResSearchDatabase:getInfoTeacha]"+query);
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
	
	//지연대차정보2 (20190304)
	public Hashtable getInfoTeacha2(String rent_l_cd, String car_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select \n"+
				" a.car_mng_id, '' serv_dt, '' off_nm, d.car_no, g.car_nm  \n"+
				" from cont a, client b, taecha c, car_reg d, car_etc e, CAR_NM f, car_mng g \n"+
				" where a.client_id=b.client_id \n"+
				" and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) \n"+
				" and a.car_mng_id=d.car_mng_id(+) \n"+
			    " AND a.rent_mng_id=e.rent_mng_id AND a.rent_l_cd=e.RENT_L_CD \n"+
		        " AND e.car_id=f.car_id AND e.car_seq=f.car_seq AND f.car_comp_id=g.car_comp_id AND f.car_cd=g.code \n"+
				" and a.rent_l_cd='"+rent_l_cd+"' "+//(c.car_no='"+car_no+"' or ) 
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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:getInfoTeacha2]"+e);
			System.out.println("[ResSearchDatabase:getInfoTeacha2]"+query);
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

	//단기계약 수정
	public int cancelCarShResAuto(String car_mng_id, String reg_dt, String damdang_id )
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;		
		String query = "";
		query = " update rent_cont set use_st='5'	"+
				" where      car_mng_id	= ?			"+
				"        and rent_st	= '11'		"+
				"        and rent_dt	= replace(?,'-','') "+
				"        and bus_id		= ?			";
		try 
		{			
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1,  car_mng_id);
			pstmt.setString(2,  reg_dt);
			pstmt.setString(3,  damdang_id);

			count = pstmt.executeUpdate();
			pstmt.close();
		    conn.commit();
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:cancelCarShResAuto]\n"+e);
	  		e.printStackTrace();
			conn.rollback();
	  	} catch (Exception e) {
		  	System.out.println("[ResSearchDatabase:cancelCarShResAuto]\n"+e);
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	/**	
	 *	검사대행업체에 검사의뢰
	 */
	public int updateCarReqMaster1(String c_id, String m1_chk)
	{
		getConnection();
		int count = 0;
		PreparedStatement pstmt = null;
		String query = "";
		query = " update CAR_REG set m1_chk='"+m1_chk+"', m1_dt = to_char(sysdate,'YYYYMMdd') where CAR_MNG_ID='"+c_id+"'";
		
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.executeUpdate();
			pstmt.close();
			count =1;

			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[ResSearchDatabase:updateCarReqMaster1]\n"+e);
			System.out.println("[ResSearchDatabase:updateCarReqMaster1]\n"+query);
			e.printStackTrace();
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	/**
	 * 차량관리번호, 서비스번호로 예약시스템 정비대차 입력분이 있는지 확인
	 */
	public int getRentContServChk(String car_mng_id, String serv_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		int res_cnt = 0;

		query = "SELECT count(0) FROM rent_cont WHERE sub_c_id=? and serv_id = ? and rent_st='2' and use_st not in ('5') ";
		
		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
			pstmt.setString(2, serv_id);
			rs = pstmt.executeQuery();
			if(rs.next()){
				res_cnt = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[ResSearchDatabase:getRentContServChk]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null)	rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return res_cnt;
		}
	}

	/**
	 * 차량관리번호, 서비스번호로 예약시스템 사고대차 입력분이 있는지 확인
	 */
	public int getRentContAccidChk(String car_mng_id, String accid_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		int res_cnt = 0;

		query = "SELECT count(0) FROM rent_cont WHERE sub_c_id=? and accid_id = ? and rent_st='3' and use_st not in ('5') ";
		
		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
			pstmt.setString(2, accid_id);
			rs = pstmt.executeQuery();
			if(rs.next()){
				res_cnt = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[ResSearchDatabase:getRentContAccidChk]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null)	rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return res_cnt;
		}
	}
	
	/**
	 * 차량관리번호, 서비스번호로 예약시스템 정비대차 입력분이 있는지 확인
	 */
	public int getScdExtServChk(String car_mng_id, String serv_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		int res_cnt = 0;

		query = " SELECT count(0) FROM service a, scd_ext b "+
				" WHERE  a.car_mng_id=? and a.serv_id=? and b.ext_st='3' and b.ext_tm='1' "+
				"        and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.serv_id=b.ext_id   and nvl(b.bill_yn, 'Y')='Y' ";
		
		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
			pstmt.setString(2, serv_id);
			rs = pstmt.executeQuery();
			if(rs.next()){
				res_cnt = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[ResSearchDatabase:getScdExtServChk]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null)	rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return res_cnt;
		}
	}	
	/**
	 *	2010년 이후 업무용 대여차량 리스트
	 */
	
	public Vector getRentPrepareList4(String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		
		query = " select a.rent_s_cd, a.car_mng_id, a.cust_id, a.rent_dt, u.user_nm , c.car_no, c.car_nm, s.serv_dt, s.tot_dist \n"+
				" from rent_cont a, users u, car_reg c, service s, (select car_mng_id, max(nvl(deli_dt,decode(use_st,'1','0000000000',deli_plan_dt))) deli_dt from rent_cont where use_st in ('1','2') group by car_mng_id) b \n"+
				" where a.use_st in ('1','2') and a.car_mng_id=b.car_mng_id and nvl(a.deli_dt,decode(a.use_st,'1','0000000000',a.deli_plan_dt))=b.deli_dt \n"+
				" and a.rent_st = '4' and a.cust_id = u.user_id and a.car_mng_id = c.car_mng_id \n"+
				" and a.car_mng_id = s.car_mng_id and a.rent_dt < s.serv_dt and s.serv_dt > '20100101'  and s.serv_st = '1' \n"+
				" and a.cust_id= '"+ user_id + "'";

		query +=  " order by a.rent_dt desc ";
	
		

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
			System.out.println("[ResSearchDatabase:getRentPrepareList4]"+e);
			System.out.println("[ResSearchDatabase:getRentPrepareList4]"+query);
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
	 * 차량관리번호, 과태료위반일시로 예약시스템 대차 입력분이 있는지 확인
	 */
	public int getRentContFindChk(String car_mng_id, String vio_dt){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		int res_cnt = 0;

		query = "SELECT count(0) FROM rent_cont WHERE sub_c_id=? and "+vio_dt+" between deli_dt and nvl(ret_dt,ret_plan_dt) and use_st not in ('5') ";
		
		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
			rs = pstmt.executeQuery();
			if(rs.next()){
				res_cnt = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[ResSearchDatabase:getRentContFindChk]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null)	rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return res_cnt;
		}
	}
	
	
	public String insertCarMaintReq(CarMaintReqBean bean)
	{
		getConnection();
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		String m1_no = "";
		String query =  " insert into CAR_MAINT_REQ "+
						" ( m1_no,  mng_id, car_mng_id, rent_l_cd, "+
						"   m1_dt, m1_chk, m1_content, reg_dt , off_id , off_nm, gubun "+
						" ) values "+
						" ( ?, ?, ?, ?, "+
						"   to_char(sysdate,'YYYYMMdd'), ?, ?, to_char(sysdate,'YYYYMMdd') , ? , ?, ? "+
						" )";

		String qry_id = " select to_char(sysdate,'YYYYMMDD')||nvl(ltrim(to_char(to_number(max(substr(m1_no,9,4))+1), '0000')), '0001') m1_no"+
						" from CAR_MAINT_REQ "+
						" where substr(m1_no,1,8)=to_char(sysdate,'YYYYMMDD')";

		try
		{
			conn.setAutoCommit(false);
			pstmt1 = conn.prepareStatement(qry_id);
		   	rs = pstmt1.executeQuery();
			while(rs.next())
			{
				m1_no = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt1.close();
			conn.commit();
		}catch(Exception e){					
	        try{
				System.out.println("[ResSearchDatabase:insertCarMaintReq]"+e);
	            conn.rollback();
				e.printStackTrace();	
	        }catch(SQLException _ignored){}
		}finally{
			try{
                if(rs != null )		rs.close();
	            if(pstmt1 != null)	pstmt1.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
		}

		try
		{
			conn.setAutoCommit(false);

			pstmt2 = conn.prepareStatement(query);
			
			if(bean.getM1_no().equals("")){
				pstmt2.setString(1,  m1_no		      );
			}else{
				pstmt2.setString(1,  bean.getM1_no	());
				m1_no = bean.getM1_no();
			}
			
			pstmt2.setString(2,  bean.getMng_id		());	
			pstmt2.setString(3,  bean.getCar_mng_id	());
			pstmt2.setString(4,  bean.getRent_l_cd	());
			pstmt2.setString(5,  bean.getM1_chk		());
			pstmt2.setString(6,  bean.getM1_content	());
			pstmt2.setString(7,  bean.getOff_id	());
			pstmt2.setString(8,  bean.getOff_nm	());
			pstmt2.setString(9,  bean.getGubun	());
							
			pstmt2.executeUpdate();			
			pstmt2.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[ResSearchDatabase:insertCarMaintReq]\n"+e);
			e.printStackTrace();
			m1_no = "";
			conn.rollback();
		}finally{
			try{
	            if(pstmt2 != null)	pstmt2.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return m1_no;
		}
	}
	
	/**
	 *	차량검사의뢰정보
	 */
	public Hashtable getCarMaintInfo(String c_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";



		query = " select a.car_mng_id, a.car_no,   a.init_reg_dt, substr(a.init_reg_dt,1,4) car_year,  \n" +
		 		" decode(rm.use_yn , 'N', '', a.m1_chk ) m1_chk,  nvl(rm.m1_dt, a.m1_dt ) m1_dt, rm.m1_content, rm.che_remark  \n" +	
				" from CAR_REG a, \n" +
				"  ( select m.* from car_maint_req m , (select car_mng_id,  max(m1_no)  m1_no from car_maint_req  group by car_mng_id ) m1  \n" +
				"     where m.car_mng_id = m1.car_mng_id and m.m1_no = m1.m1_no  ) rm   \n" +
				" where  a.car_mng_id= rm.car_mng_id(+)     \n" +			
				" and a.car_mng_id='"+c_id+"'";

				

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:getCarInfo]"+e);
			System.out.println("[ResSearchDatabase:getCarInfo]"+query);
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
	 *	사고대차리스트
	 */
	public Vector getAccidCarSearchList(String c_id, String s_cd, String firm_nm, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

       	String query =	" select  "+
						"        a.rent_mng_id, a.rent_l_cd, decode(a.car_st,'2',b.sub_firm_nm,a.firm_nm) firm_nm, a.client_nm, cr.car_no, b.car_mng_id,"+
						"        b.accid_id, decode(b.accid_st, '1','피해자', '2','가해자', '3','쌍방', '4','운행자차', '5','사고자차', '7','재리스수리', '6','수해', ' ') accid_st, accid_st as accid_st2,"+
						"        c.serv_id, d.off_nm, decode(b.accid_st, '2', b.ot_car_no, cr.car_no) p_car_no,"+
						"        decode(b.accid_st, '2', b.ot_car_nm, b.our_car_nm) p_car_nm, "+
						"        decode(b.accid_st, '2', b.ot_num, b.our_num) p_num, "+
						"        decode(b.accid_st, '2', b.our_ins, b.ot_ins) g_ins, "+
						"        decode(b.accid_st, '2', b.mat_nm, b.ot_ins_nm) g_ins_nm, "+
						"        b.our_driver, substr(b.accid_dt,1,8) accid_dt, b.accid_addr, b.accid_cont, b.accid_cont2,"+
						"        decode(b.sub_rent_gu, '1','출고전대차', '2','단기대여', '3','기타', ' ') sub_rent_gu, b.sub_firm_nm, b.reg_id, nvl(e.cnt,0) cnt"+
						" from   accident b, cont_n_view a, service c, serv_off d, car_reg cr, "+
						"        (select sub_c_id, accid_id, count(0) cnt from rent_cont where use_st<>'5' group by sub_c_id, accid_id) e"+
						" where   ";

		if(!t_wd.equals("")){
			query += " upper(nvl(cr.car_no, ' ')) like upper('%"+t_wd+"%') ";
		}else{
			query += " a.firm_nm||b.sub_firm_nm like '%"+firm_nm+"%'";
		}


        query += 		"        and b.car_mng_id=a.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.car_mng_id = cr.car_mng_id(+) \n"+
						"        and b.car_mng_id=c.car_mng_id(+) and b.accid_id=c.accid_id(+) and c.off_id=d.off_id(+)"+
						"        and b.car_mng_id=e.sub_c_id(+) and b.accid_id=e.accid_id(+)"+
						" order by b.accid_dt";

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
			System.out.println("[ResSearchDatabase:getAccidCarSearchList]"+e);
			System.out.println("[ResSearchDatabase:getAccidCarSearchList]"+query);
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
	 *	매각대상 선별 등록일자
	 */
	public Vector getSuiSortRegDtList()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

       	String query =	" select reg_dt from SUI_SORT group by reg_dt order by reg_dt  ";

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
			System.out.println("[ResSearchDatabase:getSuiSortRegDtList]"+e);
			System.out.println("[ResSearchDatabase:getSuiSortRegDtList]"+query);
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
	 *	매각대상 선별 기준 변수
	 */
	public Vector getSuiSortVarList()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

       	String query =	" select \n"+
						"        a.sort_code, a.seq, a.reg_dt, a.sort_gubun, a.b_mon, a.b_dist, a.b_use_per, a.b_s_st, a.b_min_dpm, a.b_max_dpm, a.b_day, c.cars, a.b_mon_only, a.b_dist_only, nvl(d.cnt,0) sort_cnt \n"+
                        " FROM   sui_sort_var a, \n"+
                        "        (select sort_code, max(seq) seq from sui_sort_var group by sort_code) b, \n"+
						"        ((select a.a_e, a.cars from esti_car_var a, (select a_e, max(seq) seq from esti_car_var where a_a='1' group by a_e) b where a.a_a='1' and a.a_e=b.a_e and a.seq=b.seq)) c, "+
						"        (select sort_code, var_seq, count(0) cnt from sui_sort where reg_dt=to_char(sysdate,'YYYYMMDD') group by sort_code, var_seq) d"+
                        " WHERE  nvl(a.use_yn,'Y')='Y' and a.sort_code=b.sort_code and a.seq=b.seq \n"+
						"        and a.b_s_st=c.a_e(+) "+
						"        and a.sort_code=d.sort_code(+) and a.seq=d.var_seq(+) "+
//                        " order by a.sort_code  ";
                        " order by a.b_s_st, a.b_min_dpm  ";

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
			System.out.println("[ResSearchDatabase:getSuiSortVarList]"+e);
			System.out.println("[ResSearchDatabase:getSuiSortVarList]"+query);
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
	 *	매각대상선별관리 리스트
	 */
	public Vector getSuiSortCarList(String br_id, String gubun1, String gubun2, String brch_id, String start_dt, String end_dt, String car_comp_id, String code, String s_cc, int s_year, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.car_mng_id, a.seq, a.reg_dt, a.sort_code, a.var_seq, a.car_mon, a.car_dist, a.car_use_per, a.car_day, \n"+
				"        b.sort_gubun, b.b_mon, b.b_dist, b.b_use_per, b.b_day, b.b_mon_only, b.b_dist_only, \n"+
				"        c.car_no, c.car_nm, c.init_reg_dt, h.car_name, c.secondhand, \n"+
				"        i.rent_s_cd, d.use_yn, d.car_st, \n"+
				"        decode(c.off_ls, '1','매각결정', '2','소매', '3','경매장', '4','수의', '5','경매처분현황', '6','사후관리', '예비차량') off_ls, \n"+
				"        decode(c.prepare, '2','매각예정', '3','보관', '4','말소', '5','도난', '6','해지', '8','수해',  '9', '미회수', '예비') prepare, \n"+//'7', '재리스비대상', 
				"        decode(nvl(i.brch_id,nvl(q.mng_br_id,d.brch_id)),'S1','본사','K1','본사','S2','본사','B1','부산지점','N1','부산지점','D1','대전지점','G1','대구지점','J1','광주지점','본사') brch_nm, \n"+
				"        decode(i.use_st, '1','예약','2','배차',decode(c.prepare,'4','-','5','-','6','-','8','-','대기')) car_stat, \n"+
				"        decode(c.secondhand,'1',decode(o.situation,'0','상담중','1','계약진행중','2','계약확정','3','계약연동'),'') situation, \n"+
				"        decode(c.prepare,'4','-','5','-','6'  , '- ',  '9', '-' , decode(i.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무지원','6','차량정비','7','차량점검','8','사고수리','11','장기대기','12','월렌트', '-') ) rent_st_nm, \n"+
				"        decode(c.park,'6',substr(c.park_cont,1,5),nvl(cd.nm,c.park))  park, \n"+
				"        decode(i.cust_st, '', '조성희', '1',l.client_nm, '4',n.user_nm) cust_nm, \n"+
				" 		 decode(i.cust_st, '', '아마존카', '1',replace(l.firm_nm,'(주)',''), '4','아마존카') firm_nm, \n"+
				"        nvl(k.a_cnt,0) a_cnt, a.st1_yn, a.st2_yn, a.st3_yn, a.st3_1_yn, a.st3_2_yn, a.st3_3_yn, nvl(o.sh_res_cnt,0) sh_res_cnt,  "+
				"        a.ex_n_h, a.ex_n_h_dt "+
				" from   sui_sort a, sui_sort_var b, car_reg c, cont d, cont_etc q, car_etc e, car_nm h, \n"+
				"        ( select c_st, code, nm_cd, nm from code where c_st = '0027' and code <> '0000'  ) cd,  \n"+  //주차장 
				" 		 (select a.* from rent_cont a, (select car_mng_id, max(use_st||nvl(deli_dt,decode(rent_st,'11','0000000000',deli_plan_dt))) deli_dt from rent_cont where use_st in ('1','2') group by car_mng_id) b where a.use_st in ('1','2') and a.car_mng_id=b.car_mng_id and a.use_st||nvl(a.deli_dt,decode(a.rent_st,'11','0000000000',a.deli_plan_dt))=b.deli_dt) i, \n"+
				" 		 (select car_mng_id, min(decode(use_yn,'Y',situation)) situation, count(0) sh_res_cnt from sh_res where situation in ('0','2') and reg_dt between to_char(sysdate-100,'YYYYMMDD') and to_char(sysdate,'YYYYMMDD') group by car_mng_id ) o, \n"+
				"        (select car_mng_id, count(0) as a_cnt from accident where accid_st='6' group by car_mng_id) k, "+
				" 		 client l, users n  \n"+
				" where  a.reg_dt=nvl(replace('"+gubun1+"','-',''),a.reg_dt) \n"+
				"        and a.sort_code=b.sort_code(+) and a.var_seq=b.seq(+) \n"+
				"        and a.car_mng_id=c.car_mng_id \n"+
				"        and a.car_mng_id=d.car_mng_id and a.rent_l_cd=d.rent_l_cd \n"+
				"        and d.rent_mng_id=q.rent_mng_id(+) and d.rent_l_cd=q.rent_l_cd(+) \n"+
				"        and d.rent_mng_id=e.rent_mng_id and d.rent_l_cd=e.rent_l_cd and e.car_id=h.car_id and e.car_seq=h.car_seq "+
				"        and a.car_mng_id=i.car_mng_id(+) \n"+
				"        and a.car_mng_id=o.car_mng_id(+) \n"+
				"        and a.car_mng_id=k.car_mng_id(+) \n"+
						" and c.park = cd.nm_cd(+) \n"+  //주차장 코드 테이블 
				"        and i.cust_id=l.client_id(+) and i.cust_id=n.user_id(+) \n"+	
			    " ";
		
		if(!gubun2.equals(""))			query += " and a.sort_code = '"+gubun2+"'";
		
					
		if(!t_wd.equals("")){
			if(s_kd.equals("1"))			query += " and upper(c.car_no)||upper(c.first_car_no) like upper('%"+t_wd+"%')\n";		
			if(s_kd.equals("2"))			query += " and c.init_reg_dt like '"+t_wd+"%'\n";		
		}
		

		if(sort_gubun.equals("1"))		query += " order by decode(nvl(c.prepare,'1'),'2','1', '9', '3' , '2'), a.sort_code "+asc+", h.jg_code, a.reg_dt ";
		if(sort_gubun.equals("2"))		query += " order by c.car_no "+asc+", a.reg_dt ";
		if(sort_gubun.equals("3"))		query += " order by decode(nvl(c.prepare,'1'),'2','1', '9', '3', '2'), c.car_nm||h.car_name "+asc+", a.reg_dt ";
		if(sort_gubun.equals("4"))		query += " order by decode(nvl(c.prepare,'1'),'2','1', '9', '3', '2'), c.init_reg_dt "+asc+", h.jg_code, a.reg_dt ";
		if(sort_gubun.equals("5"))		query += " order by decode(nvl(c.prepare,'1'),'2','1', '9', '3', '2'), c.dpm "+asc+", h.jg_code, a.reg_dt ";


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
			System.out.println("[ResSearchDatabase:getSuiSortCarList]"+e);
			System.out.println("[ResSearchDatabase:getSuiSortCarList]"+query);
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

	//매각대상선별기준변수 한건 조회
	public SuiSortVarBean getSuiSortVar(String sort_code, int seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		SuiSortVarBean bean = new SuiSortVarBean();
		String query = "";

		query = " select * from SUI_SORT_VAR where sort_code='"+sort_code+"' and seq="+seq+" ";



		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
		
			if(rs.next())
			{				
				 bean.setSort_code	(rs.getString(1) ==null?"":rs.getString(1));
				 bean.setSeq		(rs.getString(2) ==null?0:AddUtil.parseInt(rs.getString(2)));
				 bean.setReg_dt		(rs.getString(3) ==null?"":rs.getString(3));
				 bean.setSort_gubun	(rs.getString(4) ==null?"":rs.getString(4));
				 bean.setB_mon		(rs.getString(5) ==null?0:AddUtil.parseInt(rs.getString(5)));
				 bean.setB_dist		(rs.getString(6) ==null?0:AddUtil.parseInt(rs.getString(6)));
				 bean.setB_use_per	(rs.getString(7) ==null?0:AddUtil.parseFloat(rs.getString(7)));
				 bean.setB_s_st		(rs.getString(8) ==null?"":rs.getString(8));
				 bean.setB_min_dpm	(rs.getString(9) ==null?0:AddUtil.parseInt(rs.getString(9)));
				 bean.setB_max_dpm	(rs.getString(10)==null?0:AddUtil.parseInt(rs.getString(10)));
				 bean.setB_day		(rs.getString(11) ==null?0:AddUtil.parseInt(rs.getString(11)));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:getSuiSortVar]\n"+e);
			System.out.println("[ResSearchDatabase:getSuiSortVar]\n"+query);
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

	//매각대상선별기준변수 등록
	public int insertSuiSortVar(SuiSortVarBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;		
		String query = "";
		query = " INSERT INTO SUI_SORT_VAR "+
				"        ( sort_code, seq, reg_dt, sort_gubun, b_mon, b_dist, b_use_per, b_s_st, b_min_dpm, b_max_dpm, b_day, b_mon_only, b_dist_only, use_yn ) "+
				"        VALUES "+
				"        ( ?, ?, replace(?,'-',''), ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'Y' ) "+
				" ";
		try 
		{			
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1,  bean.getSort_code	());
			pstmt.setInt   (2,  bean.getSeq			());
			pstmt.setString(3,  bean.getReg_dt		());
			pstmt.setString(4,  bean.getSort_gubun	());
			pstmt.setInt   (5,  bean.getB_mon		());
			pstmt.setInt   (6,  bean.getB_dist		());
			pstmt.setFloat (7,  bean.getB_use_per	());
			pstmt.setString(8,  bean.getB_s_st		());
			pstmt.setInt   (9,  bean.getB_min_dpm	());
			pstmt.setInt   (10, bean.getB_max_dpm	());
			pstmt.setInt   (11, bean.getB_day		());
			pstmt.setInt   (12, bean.getB_mon_only	());
			pstmt.setInt   (13, bean.getB_dist_only	());

			count = pstmt.executeUpdate();
			pstmt.close();
		    conn.commit();

		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:insertSuiSortVar]\n"+e);
			System.out.println("[bean.getSort_code	()]\n"+bean.getSort_code	());
			System.out.println("[bean.getSeq		()]\n"+bean.getSeq			());
			System.out.println("[bean.getSort_gubun	()]\n"+bean.getSort_gubun	());
			System.out.println("[bean.getB_mon		()]\n"+bean.getB_mon		());
			System.out.println("[bean.getB_dist		()]\n"+bean.getB_dist		());
			System.out.println("[bean.getB_use_per	()]\n"+bean.getB_use_per	());
			System.out.println("[bean.getB_s_st		()]\n"+bean.getB_s_st		());
			System.out.println("[bean.getB_min_dpm	()]\n"+bean.getB_min_dpm	());
			System.out.println("[bean.getB_max_dpm	()]\n"+bean.getB_max_dpm	());
			System.out.println("[bean.getB_day		()]\n"+bean.getB_day		());
			System.out.println("[bean.getB_mon_only	()]\n"+bean.getB_mon_only	());
			System.out.println("[bean.getB_dist_only()]\n"+bean.getB_dist_only	());

	  		e.printStackTrace();
			conn.rollback();
	  	} catch (Exception e) {
		  	System.out.println("[ResSearchDatabase:insertSuiSortVar]\n"+e);
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	//매각대상선별기준변수 수정
	public int updateSuiSortVar(SuiSortVarBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;		
		String query = "";
		query = " update SUI_SORT_VAR set "+
				"        sort_gubun	= ?, "+
				"        b_mon		= ?, "+
				"        b_dist		= ?, "+
				"        b_use_per	= ?, "+
				"        b_s_st		= ?, "+
				"        b_min_dpm	= ?, "+
				"        b_max_dpm	= ?, "+
				"        b_day		= ?, "+
				"        b_mon_only	= ?, "+
				"        b_dist_only= ?  "+
				" where sort_code=? and seq=?";
		try 
		{			
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1,  bean.getSort_gubun	());
			pstmt.setInt   (2,  bean.getB_mon		());
			pstmt.setInt   (3,  bean.getB_dist		());
			pstmt.setFloat (4,  bean.getB_use_per	());
			pstmt.setString(5,  bean.getB_s_st		());
			pstmt.setInt   (6,  bean.getB_min_dpm	());
			pstmt.setInt   (7,  bean.getB_max_dpm	());
			pstmt.setInt   (8,  bean.getB_day		());
			pstmt.setInt   (9,  bean.getB_mon_only	());
			pstmt.setInt   (10, bean.getB_dist_only	());
			pstmt.setString(11, bean.getSort_code	());
			pstmt.setInt   (12, bean.getSeq			());

			count = pstmt.executeUpdate();
			pstmt.close();
		    conn.commit();

		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:updateSuiSortVar]\n"+e);
			System.out.println("[bean.getSort_gubun	()]\n"+bean.getSort_gubun	());
			System.out.println("[bean.getB_mon		()]\n"+bean.getB_mon		());
			System.out.println("[bean.getB_dist		()]\n"+bean.getB_dist		());
			System.out.println("[bean.getB_use_per	()]\n"+bean.getB_use_per	());
			System.out.println("[bean.getB_s_st		()]\n"+bean.getB_s_st		());
			System.out.println("[bean.getB_min_dpm	()]\n"+bean.getB_min_dpm	());
			System.out.println("[bean.getB_max_dpm	()]\n"+bean.getB_max_dpm	());
			System.out.println("[bean.getB_day		()]\n"+bean.getB_day		());
			System.out.println("[bean.getB_mon_only	()]\n"+bean.getB_mon_only	());
			System.out.println("[bean.getB_dist_only()]\n"+bean.getB_dist_only	());
			System.out.println("[bean.getSort_code	()]\n"+bean.getSort_code	());
			System.out.println("[bean.getSeq		()]\n"+bean.getSeq			());

	  		e.printStackTrace();
			conn.rollback();
	  	} catch (Exception e) {
		  	System.out.println("[ResSearchDatabase:updateSuiSortVar]\n"+e);
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	//매각대상선별기준변수 삭제
	public int deleteSuiSortVar(SuiSortVarBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;		
		String query = "";

		query = " update SUI_SORT_VAR set "+
				"        use_yn	= 'N' "+
				" where sort_code=? and seq=?";

		try 
		{			
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1,  bean.getSort_code	());
			pstmt.setInt   (2,  bean.getSeq			());

			count = pstmt.executeUpdate();
			pstmt.close();
		    conn.commit();

		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:deleteSuiSortVar]\n"+e);
			System.out.println("[bean.getSort_code	()]\n"+bean.getSort_code	());
			System.out.println("[bean.getSeq		()]\n"+bean.getSeq			());

	  		e.printStackTrace();
			conn.rollback();
	  	} catch (Exception e) {
		  	System.out.println("[ResSearchDatabase:deleteSuiSortVar]\n"+e);
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	/*
	 *	P_SUI_SORT 마감
	*/
	public String call_sp_sui_sort()
	{
    	getConnection();
    	
    	String query = "{CALL P_SUI_SORT}";

		CallableStatement cstmt = null;
		
		try {

			cstmt = conn.prepareCall(query);			
			cstmt.execute();
			cstmt.close();		
	
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:call_sp_sui_sort]\n"+e);
			e.printStackTrace();
		} finally {
			try{
			     if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return "";
		}
	}	

	/**
	 *	매각대상 선별 기준 변수 - 업무대여제외한 보유차대수
	 */
	public int getSuiSortVarCarCnt(String car_st, String s_st, String min_dpm, String max_dpm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;

       	String query =	"          select count(0) cnt \n"+
						"          from   cont a, car_reg b, car_etc c, car_nm d,  \n"+
						"                 (select a.* from rent_cont a, (select car_mng_id, max(use_st||nvl(deli_dt,decode(rent_st,'11','0000000000',deli_plan_dt))) deli_dt from rent_cont where use_st in ('2') group by car_mng_id) b where a.use_st in ('2') and a.car_mng_id=b.car_mng_id and a.use_st||nvl(a.deli_dt,decode(a.rent_st,'11','0000000000',a.deli_plan_dt))=b.deli_dt) i \n"+
						"          where  nvl(a.use_yn,'Y')='Y' \n"+
						"                 and a.car_mng_id=b.car_mng_id \n"+
						"                 and nvl(b.prepare,'0') not in ('4','5') \n"+
						"                 and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"+
						"                 and c.car_id=d.car_id and c.car_seq=d.car_seq \n"+
						"                 and a.car_mng_id=i.car_mng_id(+) \n"+
						"   ";

		//차종
		if(!car_st.equals(""))		query += " and a.car_st='2'"+
						"                 and nvl(b.off_ls,'0')='0' \n"+
						"                 and decode(b.prepare,'4','-','5','-','6','-', decode(i.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무지원','6','차량정비','7','차량점검','8','사고수리','11','장기대기','12','월렌트', '-') ) <>'업무대여' \n"+
						" ";

		//차종
//		if(!s_st.equals(""))		query += " and instr('"+s_st+"',d.s_st)>0";
		if(!s_st.equals(""))		query += " and case when substr('"+s_st+"',1,1) = '9' then    \n"+ //수입차
					                         "          decode(d.car_comp_id,'0001',0,'0002',0,'0003',0,'0004',0,'0005',0,1) \n"+
                                             "     else                                         \n"+ //국산차
                                             "          instr('"+s_st+"',d.s_st)*decode(d.car_comp_id,'0001',1,'0002',1,'0003',1,'0004',1,'0005',1,0) \n"+
                                             "     end > 0";

		//배기량
		if(!min_dpm.equals(""))		query += " and to_number(replace(b.dpm,' ','')) between "+min_dpm+" and "+max_dpm+"";


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			if(rs.next())
			{				
				count = rs.getInt("cnt");
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:getSuiSortVarCarCnt]"+e);
			System.out.println("[ResSearchDatabase:getSuiSortVarCarCnt]"+query);
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

	/**	
	 *	재리스계약 신규대여개시시 반차 미처리분 조회
	 */
	public int getCarRetChk(String car_mng_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		int count = 0;

		query = " select count(0) from rent_cont where car_mng_id='"+car_mng_id+"' and use_st='2' ";

		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{				
			    count = rs.getInt(1);	
			}
			rs.close();
			pstmt.close();
	  	} catch (Exception e) {
			System.out.println("[ResSearchDatabase:getCarRetChk()]\n"+e);
			System.out.println("[ResSearchDatabase:getCarRetChk()]\n"+query);
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
	 *	차량별 예약현황 리스트
	 */
	public Vector getResCarAccidList(String c_id, String accid_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select g.car_no, g.car_nm, g.first_car_no, a.car_mng_id, a.rent_s_cd,"+
				" decode(a.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','장기대기','12','월렌트') rent_st,"+
				" decode(a.use_st,'1','예약','2','배차','3','반차','4','종료','5','취소') use_st,"+
				" nvl(a.deli_dt,a.rent_start_dt) deli_dt, nvl(a.ret_dt,a.ret_plan_dt) ret_dt,"+
				" nvl(a.deli_dt,a.rent_start_dt) rent_start_dt, nvl(nvl(a.ret_dt,a.ret_plan_dt),a.rent_end_dt) rent_end_dt,"+
				" a. rent_hour, (b.fee_s_amt+b.fee_v_amt) fee_amt,"+
				" decode(a.cust_st, '','조성희', '1',e.client_nm, '4',f.user_nm, d.cust_nm) cust_nm,"+
				" decode(a.cust_st, '','(주)아마존카', '1',e.firm_nm, '4','(주)아마존카', d.firm_nm) firm_nm,"+
				" decode(a.cust_st, '','', '1',TEXT_DECRYPT(e.ssn, 'pw' ) , '4', TEXT_DECRYPT(f.user_ssn, 'pw' )  , d.ssn) ssn,"+
				" decode(a.cust_st, '','', '1',e.enp_no, '4','', d.enp_no) enp_no, f2.user_nm as bus_nm, g2.car_no as d_car_no, g2.car_nm as d_car_nm"+
				" from RENT_CONT a, RENT_FEE b, RENT_SETTLE c, RENT_CUST d, CLIENT e, users f, car_reg g, users f2, car_reg g2"+
				" where "+
				" a.sub_c_id='"+c_id+"' and a.accid_id='"+accid_id+"' and a.rent_st='3' and a.use_st<>'5' "+
				" and a.rent_s_cd=b.rent_s_cd(+) and a.rent_s_cd=c.rent_s_cd(+)"+
				" and a.cust_id=d.cust_id(+) and a.cust_id=e.client_id(+) and a.cust_id=f.user_id(+)"+
				" and a.car_mng_id=g.car_mng_id"+
				" and a.bus_id=f2.user_id"+
				" and a.sub_c_id=g2.car_mng_id(+)"+
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
			System.out.println("[ResSearchDatabase:getResCarAccidList]"+e);
			System.out.println("[ResSearchDatabase:getResCarAccidList]"+query);
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
	 *	차량별 예약현황 리스트
	 */
	public Vector getResCarTaechaSearch(String s_kd, String t_wd, String section_yn, String section)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select b.init_reg_dt, b.car_no, b.car_nm, f.section, a.reg_dt, \n"+
				"        decode(b.prepare,'4','-','5','-','6','-', decode(i.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무지원','6','차량정비','7','차량점검','8','사고수리','11','장기대기','12','월렌트', '대기') ) rent_st_nm, \n"+
				"        i.deli_dt, decode(i.rent_st,'4','',i.ret_plan_dt) ret_dt, \n"+
				"        decode(i.cust_st,'1',c.firm_nm,d.user_nm) firm_nm \n"+
				" from   cont a, car_reg b,  \n"+
				"        (select a.* from rent_cont a, (select car_mng_id, max(use_st||nvl(deli_dt,decode(rent_st,'11','0000000000',deli_plan_dt))) deli_dt from rent_cont where use_st in ('2') group by car_mng_id) b where a.use_st in ('2') and a.car_mng_id=b.car_mng_id and a.use_st||nvl(a.deli_dt,decode(a.rent_st,'11','0000000000',a.deli_plan_dt))=b.deli_dt) i, \n"+
				"        client c, users d, car_etc e, car_nm f \n"+
				" where  a.use_yn='Y' and a.car_st='2' \n"+
				"        and a.car_mng_id=b.car_mng_id \n"+
				"        and b.car_use='1' \n"+
				"        and nvl(b.off_ls,'0')='0' \n"+
				"        and nvl(b.prepare,'0') not in ('4','5') \n"+
				"        and b.car_mng_id=i.car_mng_id(+) \n"+
				"        and nvl(i.rent_st,'0')<>'3' \n"+
				"        and i.cust_id=c.client_id(+) \n"+
				"        and i.cust_id=d.user_id(+) \n"+
				"        and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd \n"+
				"        and e.car_id=f.car_id and e.car_seq=f.car_seq \n"+
				" ";
		
		if(section_yn.equals("Y") && !section.equals("")) query += " and f.section='"+section+"' ";

		query += " order by decode(i.rent_st,'',0,'4',2,1), f.section, f.jg_code, nvl(i.rent_st,'0'), i.deli_dt, b.init_reg_dt";


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
			System.out.println("[ResSearchDatabase:getResCarTaechaSearch]"+e);
			System.out.println("[ResSearchDatabase:getResCarTaechaSearch]"+query);
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
	 *	출고지연대차 계약리스트
	 */
	public Vector getTarchaContSearchList(String firm_nm, String rent_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

       	String query =	" select a.rent_mng_id, a.rent_l_cd, a.firm_nm, c.car_no, c.car_nm, cn.car_name, a.rent_dt, a.rent_start_dt, a.rent_end_dt \n"+
						" from   cont_n_view a , car_reg c,  car_etc g, car_nm cn \n"+
						" where  a.firm_nm='"+firm_nm+"' and a.fee_rent_st='1' \n"+
						"	and a.car_mng_id = c.car_mng_id(+)  and a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+)  \n"+
                       				"	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+) ";	

		if(!rent_dt.equals("")){
			query += " and replace(a.rent_dt,'-','') like replace('"+rent_dt+"%','-','')  ";
		}

        query += 		" order by a.rent_dt";

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
			System.out.println("[ResSearchDatabase:getTarchaContSearchList]"+e);
			System.out.println("[ResSearchDatabase:getTarchaContSearchList]"+query);
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
	 *	지연대차 미반차리스트
	 */
	public Vector getTarchaNoRegSearchList(String client_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

       	String query =	" select b.car_no, b.car_nm, a.rent_s_cd, a.car_mng_id, a.deli_dt \n"+
						" from   rent_cont a, car_reg b \n"+
						" where  a.cust_id='"+client_id+"' \n"+
						"        and a.rent_st='10' and a.use_st<>'5' \n"+
						"        and a.deli_dt is not null and a.ret_dt is null and a.sub_l_cd is null \n"+
						"        and a.car_mng_id=b.car_mng_id \n"+
						" ";

        query += 		" order by a.deli_dt";

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
			System.out.println("[ResSearchDatabase:getTarchaNoRegSearchList]"+e);
			System.out.println("[ResSearchDatabase:getTarchaNoRegSearchList]"+query);
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
	 *	지연대차 미반차리스트 : 계약연동되었고 미반차인거
	 */
	public Vector getTarchaNoRetSearchList(String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

       	String query =	" select b.car_no, b.car_nm, a.rent_s_cd, a.car_mng_id, a.deli_dt \n"+
						" from   rent_cont a, car_reg b \n"+
						" where  a.sub_l_cd='"+rent_l_cd+"' \n"+
						"        and a.rent_st='10' and a.use_st<>'5' \n"+
						"        and a.deli_dt is not null and a.ret_dt is null \n"+
						"        and a.car_mng_id=b.car_mng_id \n"+
						" ";

        query += 		" order by a.deli_dt";

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
			System.out.println("[ResSearchDatabase:getTarchaNoRegSearchList]"+e);
			System.out.println("[ResSearchDatabase:getTarchaNoRegSearchList]"+query);
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
	 *	지연대차 미반차리스트 : 계약연동되었고 출고전대차 미입력건
	 */
	public Vector getTarchaNoRegSearchList2(String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

       	String query =	" select b.car_no, b.car_nm, a.rent_s_cd, a.car_mng_id, a.deli_dt \n"+
						" from   rent_cont a, car_reg b, taecha c \n"+
						" where  a.sub_l_cd='"+rent_l_cd+"' \n"+
						"        and a.rent_st='10' and a.use_st<>'5' \n"+
						"        and a.car_mng_id=b.car_mng_id \n"+
						"        and a.sub_l_cd=c.rent_l_cd(+) and a.car_mng_id=c.car_mng_id(+) and c.rent_l_cd is null \n"+
						" ";

        query += 		" order by a.deli_dt";

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
			System.out.println("[ResSearchDatabase:getTarchaNoRegSearchList2]"+e);
			System.out.println("[ResSearchDatabase:getTarchaNoRegSearchList2]"+query);
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
	 *	보유차현황 리스트중 매각예정차량만 보기
	 */
	public Vector getRentPrepare_2(String br_id, String gubun1, String gubun2, String brch_id, String start_dt, String end_dt, String car_comp_id, String code, String s_cc, int s_year, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select /*+ leading(A) index(a CAR_REG_IDX5) */ e.export_amt, e.imgfile1,\n"+
				" us.mng_nm, decode(nvl(i.brch_id,nvl(q.mng_br_id,b.brch_id)),'S1','본사','K1','본사','S2','본사','B1','부산지점','N1','부산지점','D1','대전지점','G1','대구지점','J1','광주지점','본사') brch_nm, a.car_mng_id, a.car_no, a.car_nm, d.car_name, a.init_reg_dt, b.rent_dt, i.rent_start_dt, i.rent_end_dt, i.deli_plan_dt, i.ret_plan_dt, p.user_nm as bus_nm, \n"+
				" cd2.nm as fuel_kd, \n"+
				" a.dpm, c.colo||decode(c.in_col,'','','(내장:'||c.in_col||')') as colo, \n"+
				" j.use_dt, nvl(j.use_per,0) use_per, i.use_st, i.rent_st, i.rent_s_cd, \n"+
				" decode(a.prepare, '2','매각예정', '3','보관', '4','말소', '5','도난', '6','해지', '8','수해', '예비') prepare, \n"+
				" decode(a.park,'6',substr(a.park_cont,1,5),nvl(cd.nm,a.park)) park, a.park_cont, \n"+
				" decode(i.use_st, '1','예약','2','배차',decode(a.prepare,'4','-','5','-','6','-','8','-','대기')) car_stat, \n"+
				" decode(a.prepare,'4','-','5','-','6','-', cd3.nm ) rent_st_nm, \n"+
				" decode(i.cust_st, '', '조성희', '1',l.client_nm, '4',n.user_nm, m.cust_nm) cust_nm, \n"+
				" decode(i.cust_st, '', '아마존카', '1',replace(l.firm_nm,'(주)',''), '4','아마존카', m.firm_nm) firm_nm, \n"+
				" decode(sign(TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.rent_dt, 'YYYYMMDD')) * 30.5)),-1,0,TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.rent_dt, 'YYYYMMDD')) * 30.5)) DAY, \n"+
				" nvl(k.a_cnt,0) a_cnt, \n"+
				" /*네  고*/decode(o.situation,'0','상담중','1','계약진행중','2','계약확정','3','계약연동','') situation, o.memo, o.damdang, o.reg_dt as situation_dt, \n"+
				" decode(a.gps,'Y','장착') gps, a.secondhand, \n"+
				" decode(r.con_f_nm,'아마존카','','피') as con_f_nm, \n"+
				" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(b.dlv_dt,a.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(b.dlv_dt,a.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST, \n"+
				" p2.fee_s_amt, round(p2.fee_s_amt/30,-3) day_s_amt, a.taking_p, \n"+
				" decode(cc.rent_l_cd,'','','해지반납') call_in_st, cc.in_dt as call_in_dt, \n"+
				" ss.sort_code, \n"+
				" c.opt OPT, c.lpg_yn LPG_YN,	c.car_cs_amt CAR_CS_AMT, c.car_cv_amt CAR_CV_AMT, c.car_fs_amt CAR_FS_AMT, c.car_fv_amt	CAR_FV_AMT,	c.opt_cs_amt OPT_CS_AMT, c.opt_cv_amt OPT_CV_AMT, \n"+
				" c.opt_fs_amt OPT_FS_AMT, c.opt_fv_amt OPT_FV_AMT, c.clr_cs_amt	CLR_CS_AMT,	c.clr_cv_amt CLR_CV_AMT, c.clr_fs_amt CLR_FS_AMT, c.clr_fv_amt CLR_FV_AMT, c.sd_cs_amt SD_CS_AMT, \n"+
				" c.sd_cv_amt SD_CV_AMT, c.sd_fs_amt SD_FS_AMT, c.sd_fv_amt SD_FV_AMT, c.dc_cs_amt DC_CS_AMT,	c.dc_cv_amt DC_CV_AMT, c.dc_fs_amt DC_FS_AMT, c.dc_fv_amt DC_FV_AMT, \n"+
				" TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(replace(a.init_reg_dt,'-',''), 'YYYYMMDD'))) use_mon \n"+
				" from   car_reg a, cont b, car_etc c, car_nm d, client l, users n, rent_cust m, users p, cont_etc q, v_tot_dist vt, APPRSL e, \n"+
				"        ( select c_st, code, nm_cd, nm from code where c_st = '0027') cd,  \n"+  //주차장 
				"        ( select c_st, code, nm_cd, nm from code where c_st = '0039') cd2,  \n"+  
				"        ( select c_st, code, nm_cd, nm from code where c_st = '0042') cd3,  \n"+
				"        (select a.* from rent_cont a, (select car_mng_id, max(use_st||nvl(deli_dt,decode(rent_st,'11','0000000000',deli_plan_dt))) deli_dt from rent_cont where use_st in ('1','2') group by car_mng_id) b where a.use_st in ('1','2') and a.car_mng_id=b.car_mng_id and a.use_st||nvl(a.deli_dt,decode(a.rent_st,'11','0000000000',a.deli_plan_dt))=b.deli_dt) i, \n"+
				"        (select car_mng_id, max(dt) use_dt, to_char(count(0)/21*100,999) use_per from (select car_mng_id, dt from scd_car where dt between to_char(sysdate-20,'YYYYMMDD') and to_char(sysdate,'YYYYMMDD') group by car_mng_id, dt) group by car_mng_id) j, \n"+
				"        (select car_mng_id, count(0) as a_cnt from accident where accid_st='6' group by car_mng_id) k, \n"+
				"        (select a.*, b.user_nm as damdang from sh_res a, users b where a.use_yn='Y' and a.situation in ('0','2') and a.damdang_id=b.user_id(+)) o, \n"+
				"        (select a.* from insur a, (select car_mng_id, max(ins_st) ins_st from insur where ins_sts='1' group by car_mng_id) b where a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st ) r, \n"+
                //일반대차요금
				"        ( select a.* \n"+
				"          from   estimate_sh a, \n"+
				"                 (select est_ssn, max(est_id) est_id from estimate_sh where est_from ='res_car' and est_fax='Y' and rent_dt like to_char(sysdate,'YYYYMM')||'%' group by est_ssn ) b \n"+
				"          where  a.est_from ='res_car' and a.est_fax='Y' and a.rent_dt like to_char(sysdate,'YYYYMM')||'%' and  a.est_ssn=b.est_ssn and a.est_id=b.est_id) p2, \n"+
				"        ( SELECT a.mng_id, a.car_mng_id, b.user_nm AS mng_nm  FROM cont a, users b  WHERE a.use_yn = 'Y' AND a.mng_id = b.user_id ) us, \n"+
                //차량해지반납
				"        ( select * from car_call_in where in_st='3' and out_dt is null ) cc, \n"+
				//매각대상선별차량
				"        ( select * from sui_sort where reg_dt=to_char(sysdate,'YYYYMMDD') ) ss \n"+	
				" where a.off_ls ='0'  \n"+
				" and  a.car_mng_id=b.car_mng_id and nvl(b.use_yn,'Y')='Y'  \n"+
				" and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd \n"+
				" and c.car_id=d.car_id and c.car_seq=d.car_seq \n"+
				" and i.cust_id=l.client_id(+) and i.cust_id=n.user_id(+) and i.cust_id=m.cust_id(+) \n"+
				" and a.car_mng_id=i.car_mng_id(+) \n"+
				" and a.car_mng_id=j.car_mng_id(+) \n"+
				" and a.car_mng_id=k.car_mng_id(+) \n"+
				" and a.car_mng_id=o.car_mng_id(+) AND a.car_mng_id=e.car_mng_id(+) and i.bus_id=p.user_id(+) and a.car_mng_id = us.car_mng_id(+) \n"+
				" and b.rent_mng_id=q.rent_mng_id(+) and b.rent_l_cd=q.rent_l_cd(+) \n"+
			    " and decode(a.prepare,'','1','7','1',a.prepare) not in ('4','5','6','8') \n"+
				" and a.car_mng_id=r.car_mng_id(+) \n"+
				" and a.car_mng_id = vt.car_mng_id(+) \n"+
				" and a.car_mng_id=p2.est_ssn(+) \n"+
				" and b.rent_mng_id=cc.rent_mng_id(+) and b.rent_l_cd=cc.rent_l_cd(+) \n"+				
				" and decode(cc.rent_l_cd,'',b.car_st,'2')='2' \n"+
				" and a.car_mng_id=ss.car_mng_id(+) \n"+
				" and a.park = cd.nm_cd(+) \n"+  //주차장 코드 테이블 
				" and a.fuel_kd = cd2.nm_cd \n"+ 
				" and i.rent_st = cd3.nm_cd(+) \n"+
				" and decode(a.prepare,'','1','7','1',a.prepare) = '2' \n"+
			    " ";

		if(brch_id.equals("S1"))		query += " and nvl(i.brch_id,nvl(q.mng_br_id,b.brch_id)) in ('S1','K1')";
		if(brch_id.equals("S2"))		query += " and nvl(i.brch_id,nvl(q.mng_br_id,b.brch_id))='S2'";
		if(brch_id.equals("B1"))		query += " and nvl(i.brch_id,nvl(q.mng_br_id,b.brch_id)) in ('B1','N1')";
		if(brch_id.equals("D1"))		query += " and nvl(i.brch_id,nvl(q.mng_br_id,b.brch_id))='D1'";

		if(!car_comp_id.equals(""))		query += " and d.car_comp_id='"+car_comp_id+"'";		
		if(!code.equals(""))			query += " and d.car_cd='"+code+"'";		
					
		if(!t_wd.equals("")){
			if(s_kd.equals("1"))			query += " and upper(a.car_no)||upper(a.first_car_no) like upper('%"+t_wd+"%')\n";		
			if(s_kd.equals("3"))			query += " and a.init_reg_dt like '"+t_wd+"%'\n";		
			if(s_kd.equals("2"))			query += " and a.car_nm like '%"+t_wd+"%' \n";		
		}
		


		if(sort_gubun.equals("1")){
			query += " order by decode(nvl(a.prepare,'1'),'2','2','5','3','4','4','8','5','1'), \n"+
					          " decode(i.rent_st,'4',1,0), decode(nvl(i.brch_id,nvl(q.mng_br_id,b.brch_id)),'S1',1,'K1',1,'B1',2,'N1',2,'D1',3), \n"+
							  " decode(i.use_st,'',decode(o.situation,'0',1, '1',2, '2',3, 0),'1','4','2','5','6'), \n"+
							  " decode(i.use_st,'1',decode(o.situation,'0',0.02,'2',0.03,0.01),'2',decode(i.rent_st,'6','0.1','7','0.2','8','0.3',i.rent_st),'9'), \n"+
							  " decode(o.situation,'0',1, '1',2, '2',3, 0), \n"+	
							  " to_number(a.dpm) desc, a.car_nm, a.init_reg_dt desc, replace(a.park,' ','')"; 
		}
		if(sort_gubun.equals("2"))		query += " order by a.car_no "+asc; 
		if(sort_gubun.equals("3"))		query += " order by decode(nvl(a.prepare,'1'),'2','2','5','3','4','4','8','5','1'), a.car_nm||d.car_name "+asc;
		if(sort_gubun.equals("4"))		query += " order by decode(nvl(a.prepare,'1'),'2','2','5','3','4','4','8','5','1'), a.init_reg_dt "+asc;
		if(sort_gubun.equals("5"))		query += " order by decode(nvl(a.prepare,'1'),'2','2','5','3','4','4','8','5','1'), a.dpm "+asc;
		if(sort_gubun.equals("6"))		query += " order by decode(nvl(a.prepare,'1'),'2','2','5','3','4','4','8','5','1'), b.rent_dt "+asc;

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
			System.out.println("[ResSearchDatabase:getRentPrepare_2]"+e);
			System.out.println("[ResSearchDatabase:getRentPrepare_2]"+query);
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
	 *	수출매각 예상가 입력
	 */
	public int updateApprsl_export_amt(String c_id, String export_amt) throws SQLException
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";

		query = " update apprsl set export_amt='"+export_amt+"' where car_mng_id='"+c_id+"'";

		try {
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
	    	count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:insertApprsl_export_amt]"+e);
			System.out.println("[ResSearchDatabase:insertApprsl_export_amt]"+query);
			e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}	


	/**	
	 *	삭제
	 */
	public int deleteRentContCase(String s_cd, String c_id)
	{
		getConnection();
		int count = 0;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		PreparedStatement pstmt4 = null;
		PreparedStatement pstmt5 = null;
		PreparedStatement pstmt6 = null;
		PreparedStatement pstmt7 = null;
		PreparedStatement pstmt8 = null;
		String query = "";

		query = " delete from rent_cont where RENT_S_CD='"+s_cd+"' and CAR_MNG_ID='"+c_id+"'";
		
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.executeUpdate();
			pstmt.close();

			query = " delete from scd_car where RENT_S_CD='"+s_cd+"' and CAR_MNG_ID='"+c_id+"'";
			pstmt2 = conn.prepareStatement(query);
			pstmt2.executeUpdate();
			pstmt2.close();

			query = " delete from rent_mgr where RENT_S_CD='"+s_cd+"' ";
			pstmt3 = conn.prepareStatement(query);
			pstmt3.executeUpdate();
			pstmt3.close();

			query = " delete from rent_fee where RENT_S_CD='"+s_cd+"' ";
			pstmt4 = conn.prepareStatement(query);
			pstmt4.executeUpdate();
			pstmt4.close();

			query = " delete from rent_settle where RENT_S_CD='"+s_cd+"' ";
			pstmt5 = conn.prepareStatement(query);
			pstmt5.executeUpdate();
			pstmt5.close();

			query = " delete from scd_rent where RENT_S_CD='"+s_cd+"' ";
			pstmt6 = conn.prepareStatement(query);
			pstmt6.executeUpdate();
			pstmt6.close();

			query = " delete from rent_ins where RENT_S_CD='"+s_cd+"' ";
			pstmt7 = conn.prepareStatement(query);
			pstmt7.executeUpdate();
			pstmt7.close();

			query = " delete from sc_scan where RENT_S_CD='"+s_cd+"' ";
			pstmt8 = conn.prepareStatement(query);
			pstmt8.executeUpdate();
			pstmt8.close();

			count =1;

			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[ResSearchDatabase:deleteRentContCase]\n"+e);
			System.out.println("[ResSearchDatabase:deleteRentContCase]\n"+query);
			e.printStackTrace();
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
				if(pstmt2 != null)	pstmt2.close();
				if(pstmt3 != null)	pstmt3.close();
				if(pstmt4 != null)	pstmt4.close();
				if(pstmt5 != null)	pstmt5.close();
				if(pstmt6 != null)	pstmt6.close();
				if(pstmt7 != null)	pstmt7.close();
				if(pstmt8 != null)	pstmt8.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	//단기고객 정보 조회
	public RentCustBean getRentCustCase(String cust_st, String cust_id, String site_id )
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		RentCustBean bean = new RentCustBean();
		String query = "";

		if(cust_st.equals("1")){//장기고객

			if(site_id.equals("")){
				query = " select   'l' GUBUN,"+
						" decode(a.CLIENT_ST, '1','법인','2','개인','3','개인사업자(일반과세)','4','개인사업자(간이과세)','5','개인사업자(면세사업자)') AS CUST_ST,"+
						" a.CLIENT_ID AS CUST_ID, a.CLIENT_NM AS CUST_NM, nvl(a.FIRM_NM, a.client_nm) AS FIRM_NM,"+
						" decode(TEXT_DECRYPT(a.ssn, 'pw' ) ,'','',substr(TEXT_DECRYPT(a.ssn, 'pw' ),1,6)||'-'||substr(TEXT_DECRYPT(a.ssn, 'pw' ),7,7)) AS SSN,"+
						" decode(a.ENP_NO,'','',substr(a.enp_no,1,3)||'-'||substr(a.enp_no,4,2)||'-'||substr(a.enp_no,6,5)) AS ENP_NO,"+
//						" '' LIC_NO, '' LIC_ST, a.O_TEL AS TEL, a.M_TEL, a.O_ZIP AS ZIP, a.O_ADDR AS ADDR, '' DEPT_NM, '' BRCH_NM, '' CAR_NO, '' CAR_NM"+
						" '' LIC_NO, '' LIC_ST, a.O_TEL AS TEL, a.M_TEL, a.O_ZIP AS ZIP, a.O_ADDR AS ADDR, '' DEPT_NM, '' BRCH_NM, '' CAR_NO, '' CAR_NM, a.con_agnt_email as email "+	//2017.12.19 수정
						" from CLIENT a"+
						" where a.client_id='"+cust_id+"'";
			}else{
				query = " select   'l' GUBUN,"+
						" decode(a.CLIENT_ST, '1','법인','2','개인','3','개인사업자(일반과세)','4','개인사업자(간이과세)','5','개인사업자(면세사업자)') AS CUST_ST,"+
						" b.CLIENT_ID AS CUST_ID, b.site_jang AS CUST_NM, b.r_site AS FIRM_NM,"+
						" decode(LENGTH(TEXT_DECRYPT(b.enp_no, 'pw' )),13,substr(TEXT_DECRYPT(b.enp_no, 'pw' ),1,6)||'-'||substr(TEXT_DECRYPT(b.enp_no, 'pw' ),7,7)) AS SSN,"+
						" decode(LENGTH(TEXT_DECRYPT(b.enp_no, 'pw' )),10,substr(TEXT_DECRYPT(b.enp_no, 'pw' ),1,3)||'-'||substr(TEXT_DECRYPT(b.enp_no, 'pw' ),4,2)||'-'||substr(TEXT_DECRYPT(b.enp_no, 'pw' ),6,5)) AS ENP_NO,"+
//						" '' LIC_NO, '' LIC_ST, b.TEL AS TEL, '' M_TEL, ZIP, ADDR, '' DEPT_NM, '' BRCH_NM, '' CAR_NO, '' CAR_NM"+
						" '' LIC_NO, '' LIC_ST, b.TEL AS TEL, '' M_TEL, ZIP, ADDR, '' DEPT_NM, '' BRCH_NM, '' CAR_NO, '' CAR_NM, a.con_agnt_email as email "+	//2017.12.19 수정
						" from client_site b, CLIENT a"+
						" where b.client_id='"+cust_id+"' and b.seq='"+site_id+"' and b.client_id=a.client_id ";
			}
		}else if(cust_st.equals("4")){//직원
			query = " select 'u' GUBUN,"+
					" '직원' CUST_ST,"+
					" a.USER_ID AS CUST_ID, a.USER_NM AS CUST_NM, '(주)아마존카' AS FIRM_NM,"+
					" decode(TEXT_DECRYPT(a.USER_SSN, 'pw' ) , '','', substr(TEXT_DECRYPT(a.USER_SSN, 'pw' ),1,6)||'-'||substr(TEXT_DECRYPT(a.USER_SSN, 'pw' ),7,7)) SSN,"+
					" '' ENP_NO,"+
//					" a.LIC_NO, '' LIC_ST, '02-757-0802' TEL, a.USER_M_TEL AS M_TEL, '' ZIP, '' ADDR, b.nm AS DEPT_NM, c.br_nm AS BRCH_NM, '' CAR_NO, '' CAR_NM"+
					" a.LIC_NO, '' LIC_ST, '02-757-0802' TEL, a.USER_M_TEL AS M_TEL, '' ZIP, '' ADDR, b.nm AS DEPT_NM, c.br_nm AS BRCH_NM, '' CAR_NO, '' CAR_NM, a.user_email as email "+	//2017.12.19 수정
					" from USERS a, code b, branch c"+
					" where b.c_st='0002' and a.dept_id=b.code and a.br_id=c.br_id"+
					" and nvl(a.USER_ID, ' ') like '%"+cust_id+"%'";
		}else{
			query = " select decode(client_id,'','s','l') GUBUN,"+
					" decode(CUST_ST, '1','법인','2','개인','3','개인사업자(일반과세)','4','개인사업자(간이과세)','5','개인사업자(면세사업자)') AS CUST_ST,"+
					" CUST_ID, CUST_NM, FIRM_NM,"+
					" decode(length(SSN), 0,'', 13,substr(ssn,1,6)||'-'||substr(ssn,7,7), SSN) AS SSN,"+
					" decode(length(ENP_NO), 0,'', 10,substr(enp_no,1,3)||'-'||substr(enp_no,4,2)||'-'||substr(enp_no,6,5), ENP_NO) AS ENP_NO,"+
//					" LIC_NO, decode(LIC_ST,'1','1종보통','2','2종보통','') LIC_ST, TEL, M_TEL, ZIP, ADDR, '' DEPT_NM, '' BRCH_NM, '' CAR_NO, '' CAR_NM"+
					" LIC_NO, decode(LIC_ST,'1','1종보통','2','2종보통','') LIC_ST, TEL, M_TEL, ZIP, ADDR, '' DEPT_NM, '' BRCH_NM, '' CAR_NO, '' CAR_NM, EMAIL "+	//2017.12.19 수정
					" from RENT_CUST"+
					" where cust_id='"+cust_id+"'";
		}
				
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();		
			if(rs.next())
			{			
				 bean.setCust_id(cust_id);
				 bean.setCust_st(rs.getString(2)==null?"":rs.getString(2));
				 bean.setCust_nm(rs.getString(4)==null?"":rs.getString(4));
				 bean.setFirm_nm(rs.getString(5)==null?"":rs.getString(5));
				 bean.setSsn(rs.getString(6)==null?"":rs.getString(6));
				 bean.setEnp_no(rs.getString(7)==null?"":rs.getString(7));
				 bean.setLic_no(rs.getString(8)==null?"":rs.getString(8));
				 bean.setLic_st(rs.getString(9)==null?"":rs.getString(9));
				 bean.setTel(rs.getString(10)==null?"":rs.getString(10));
				 bean.setM_tel(rs.getString(11)==null?"":rs.getString(11));
				 bean.setZip(rs.getString(12)==null?"":rs.getString(12));
				 bean.setAddr(rs.getString(13)==null?"":rs.getString(13));
				 bean.setDept_nm(rs.getString(14)==null?"":rs.getString(14));
				 bean.setBrch_nm(rs.getString(15)==null?"":rs.getString(15));
				 bean.setCar_no(rs.getString(16)==null?"":rs.getString(16));
				 bean.setCar_nm(rs.getString(17)==null?"":rs.getString(17));
				 bean.setEmail(rs.getString(18)==null?"":rs.getString(18));		//추가 (2017.12.19)	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:getRentCustCase]\n"+e);
			System.out.println("[ResSearchDatabase:getRentCustCase]\n"+query);
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
	 *	차량위치 수정
	 */
	public int updateCarRmSt(String c_id, String rm_st, String rm_cont, String checker)
	{
		getConnection();
		int count = 0;
		PreparedStatement pstmt = null;
		String query = "";

		query = " update CAR_REG set checker='"+ checker + "', check_dt=to_char(sysdate,'YYYYMMDD'), rm_st='"+rm_st+"', rm_cont='"+rm_cont+"' where CAR_MNG_ID='"+c_id+"'";
		
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.executeUpdate();
			pstmt.close();
			count =1;

			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[ResSearchDatabase:updateCarRmSt]\n"+e);
			System.out.println("[ResSearchDatabase:updateCarRmSt]\n"+query);
			e.printStackTrace();
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	/**
	 *	사후관리 리스트 - gubun4
	 */
	public Vector getRentEndList_New(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String brch_id, String start_dt, String end_dt, String car_comp_id, String code, String s_cc, int s_year, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				"        a.rent_s_cd, a.car_mng_id, a.rent_dt, a.rent_start_dt, a.rent_end_dt, a.deli_plan_dt, a.ret_plan_dt, a.deli_dt, a.ret_dt, a.brch_id, a.bus_id, a.etc, a.sub_l_cd, \n"+
				"        b.rent_tot_amt, "+
				"        j.sett_dt, j.rent_tot_amt, nvl(j.run_km,b.dist_km) run_km, \n"+
				"        f.car_no, f.init_reg_dt, f.car_nm, h.car_name, decode(d.client_st,'1','법인','2','개인','개인사업자') client_st, "+
				"        i.user_nm as bus_nm, i2.user_nm as mng_nm, \n"+
				"        decode(a.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','장기대기','12','월렌트') rent_st,  \n"+
				"        decode(a.use_st,'1','예약','2','배차','3','반차','4','정산','5','취소') use_st ,   \n"+
				"        decode(a.cust_st, '4',e.user_nm, d.client_nm) cust_nm,"+
				"        decode(a.cust_st, '4','(주)아마존카', d.firm_nm) firm_nm,  \n"+
				"        nvl(j.tot_hour,a.rent_hour) tot_hour, nvl(j.tot_days,a.rent_days) tot_days, nvl(j.tot_months,a.rent_months) tot_months,  \n"+
				"        trunc(to_date(substr(nvl(a.ret_dt,a.ret_plan_dt),1,8),'YYYYMMDD')-to_date(substr(nvl(a.deli_dt,a.deli_plan_dt),1,8),'YYYYMMDD'),0) use_day, \n"+
				"        f2.car_no as d_car_no, f2.car_nm as d_car_nm, nvl(b.inv_s_amt,0) inv_amt, nvl(b.dc_s_amt,0) dc_amt, p.io_dt, b.NAVI_YN, decode(l.rent_way,'3','기본식-'||l.rent_start_dt,'') rent_way \n"+
				" from   RENT_CONT a, RENT_FEE b, RENT_SETTLE j, CLIENT d, USERS e, CAR_REG f, users i, users i2, \n"+
				"        (select a.* FROM CONT a, (SELECT car_mng_id, min(rent_l_cd) rent_l_cd from cont where car_st<>'4' group by car_mng_id) b WHERE a.car_mng_id=b.car_mng_id AND a.rent_l_cd=b.rent_l_cd) c, \n"+
				"        car_etc g, car_nm h, "+
				"        car_mng k, car_reg f2, \n"+
				"        ( select distinct car_mng_id, io_dt from park_io where io_gubun = '1' ) p, "+
				"        cont c2, (select * from fee where rent_st='1') l \n"+
				" where  a.rent_s_cd=b.rent_s_cd(+) and a.rent_s_cd=j.rent_s_cd(+) "+
				"        and a.cust_id=d.client_id(+) and a.cust_id=e.user_id(+)  \n"+
				"        and a.car_mng_id=f.car_mng_id "+
				"        and a.bus_id=i.user_id(+) and a.mng_id=i2.user_id(+) \n"+
				"        and a.car_mng_id=c.car_mng_id(+) "+
				"        and c.rent_mng_id=g.rent_mng_id(+) and c.rent_l_cd=g.rent_l_cd(+) "+
				"        and g.car_id=h.car_id(+) and g.car_seq=h.car_seq(+) \n"+
				"        and h.car_comp_id=k.car_comp_id(+) and h.car_cd=k.code(+) \n"+
				" 	     and a.car_mng_id = p.car_mng_id(+)  and substr(a.ret_dt,1,8) = p.io_dt(+) \n"+
				"        and a.sub_c_id=f2.car_mng_id(+) \n"+
				"        and a.sub_c_id=c2.car_mng_id(+) and a.sub_l_cd=c2.rent_l_cd(+) "+
				"        and c2.rent_mng_id=l.rent_mng_id(+) and c2.rent_l_cd=l.rent_l_cd(+) "+
				" ";
		
		String dt1 = "";

		if(gubun3.equals("1"))			dt1 = "a.rent_dt";
		if(gubun3.equals("2"))			dt1 = "nvl(a.deli_dt,a.deli_plan_dt)";
		if(gubun3.equals("3"))			dt1 = "nvl(a.ret_dt,a.ret_plan_dt)";
		if(gubun3.equals("4"))			dt1 = "j.sett_dt";
		if(gubun3.equals("5"))			dt1 = "a.reg_dt";

		if(gubun1.equals("6") || gubun1.equals("7") || gubun1.equals("8")){

		}else{

			if(gubun4.equals("1"))			query += " and "+dt1+" like to_char(sysdate,'YYYYMM')||'%'";
			if(gubun4.equals("2"))			query += " and "+dt1+" like to_char(sysdate,'YYYYMMDD')||'%'";
			if(gubun4.equals("4"))			query += " and "+dt1+" like to_char(sysdate-1,'YYYYMMDD')||'%'";
			if(gubun4.equals("5"))			query += " and "+dt1+" like to_char(to_date(to_char(sysdate,'YYYYMM'),'YYYYMM')-1,'YYYYMM')||'%'";
			if(gubun4.equals("3")){	
				if(!start_dt.equals("") && end_dt.equals(""))		query += " and "+dt1+" like replace('"+start_dt+"%', '-','')";
				if(!start_dt.equals("") && !end_dt.equals(""))		query += " and "+dt1+" between replace('"+start_dt+"', '-','') and replace('"+end_dt+"', '-','')";
			}
		}

		if(gubun1.equals(""))			query += " and a.use_st not in ('5') ";		
		if(gubun1.equals("1"))			query += " and a.use_st='"+gubun1+"'";		
		if(gubun1.equals("2"))			query += " and a.use_st='"+gubun1+"'";		
		if(gubun1.equals("3"))			query += " and a.use_st='"+gubun1+"'";		
		if(gubun1.equals("4"))			query += " and a.use_st='"+gubun1+"'";		
		if(gubun1.equals("5"))			query += " and a.use_st='"+gubun1+"'";		
		if(gubun1.equals("6"))			query += " and a.use_st in ('1','2') and a.brch_id in ('S1','S2') and a.mng_id in ('000006','000085','000077')";		
		if(gubun1.equals("7"))			query += " and a.use_st in ('1','2') and a.brch_id='B1' and a.mng_id in ('000053')";		
		if(gubun1.equals("8"))			query += " and a.use_st in ('1','2') and a.brch_id='D1' and a.mng_id in ('000052')";		
		if(gubun1.equals("9"))			query += " and a.use_st in ('1','2') and a.brch_id='G1' and a.mng_id in ('000054')";		
		if(gubun1.equals("10"))			query += " and a.use_st in ('1','2') and a.brch_id='J1' and a.mng_id in ('000020')";		
		if(gubun1.equals("11"))			query += " ";		


		if(!gubun2.equals("") && !gubun2.equals("20") && !gubun2.equals("30"))		query += " and a.rent_st='"+gubun2+"'";
		else if(gubun2.equals("20"))												query += " and a.rent_st in ('1', '2', '3', '4', '5','10','9')";
		else if(gubun2.equals("30"))												query += " and a.rent_st in ('6', '7', '8')";

		if(brch_id.equals("S1"))							query += " and a.brch_id in ('S1','K1','S2')";
		if(brch_id.equals("B1"))							query += " and a.brch_id in ('B1','N1')";
		if(brch_id.equals("D1"))							query += " and a.brch_id='D1'";
//		if(brch_id.equals("S2"))							query += " and a.brch_id='S2'";
		if(brch_id.equals("G1"))							query += " and a.brch_id='G1'";
		if(brch_id.equals("J1"))							query += " and a.brch_id='J1'";


		if(!car_comp_id.equals(""))							query += " and k.car_comp_id='"+car_comp_id+"'";		
		if(!code.equals(""))								query += " and k.code='"+code+"'";		
			
		if(!t_wd.equals("")){
			if(s_kd.equals("1"))								query += " and upper(f.car_no)||upper(f.first_car_no) like upper('%"+t_wd+"%')\n";		
			if(s_kd.equals("2"))								query += " and decode(a.cust_st, '4',e.user_nm, d.client_nm) like '%"+t_wd+"%'\n";		
			if(s_kd.equals("3"))								query += " and decode(a.cust_st, '4','(주)아마존카', d.firm_nm) like '%"+t_wd+"%'\n";	
			if(s_kd.equals("4"))								query += " and upper(f2.car_no)||upper(f2.first_car_no) like upper('%"+t_wd+"%')\n";				
			if(s_kd.equals("5"))								query += " and upper(a.rent_s_cd) like upper('%"+t_wd+"%')\n";				
			if(s_kd.equals("6"))								query += " and upper(i.user_nm) like upper('%"+t_wd+"%')\n";				
			if(s_kd.equals("7"))								query += " and upper(i2.user_nm) like upper('%"+t_wd+"%')\n";				
			if(s_kd.equals("8"))								query += " and a.rent_s_cd='"+t_wd+"'\n";
			if(s_kd.equals("mons"))								query += " and a.rent_months like upper('%"+t_wd+"%')\n";				
		}


		if(!sort_gubun.equals(""))							query += " ORDER BY decode(a.use_st,'1',1,0), "+sort_gubun+" "+asc+", a.reg_dt ";
		else												query += " ORDER BY f.car_nm";

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
			System.out.println("[ResSearchDatabase:getRentEndList_New]"+e);
			System.out.println("[ResSearchDatabase:getRentEndList_New]"+query);
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
	 *	일일영업현황
	 */	
	public Hashtable getRentStat1(String mode, String s_dt, String s_br)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		String b_query = "";

		 		
		b_query = " \n"+
			      //개시
				  " SELECT '1' st, substr(deli_dt,1,8) AS  dt, brch_id, car_mng_id, rent_s_cd FROM RENT_CONT WHERE deli_dt LIKE '"+s_dt+"%' AND RENT_ST='12' AND use_st<>'5' \n"+
		          " union all \n"+
                  //연장계약
				  " SELECT '2' st, a.rent_start_dt AS  dt, b.brch_id, b.car_mng_id, b.rent_s_cd FROM RENT_CONT_EXT a, RENT_CONT b WHERE a.rent_start_dt LIKE '"+s_dt+"%' AND b.RENT_ST='12' AND b.use_st<>'5' and a.rent_s_cd=b.rent_s_cd \n"+
			      " union all \n"+
                  //반차
		          " SELECT '3' st, substr(ret_dt,1,8) AS  dt, brch_id, car_mng_id, rent_s_cd FROM RENT_CONT WHERE ret_dt LIKE '"+s_dt+"%' AND RENT_ST='12' AND use_st<>'5' \n"+
		          " union all \n"+
                  //미반차-신규
		          " SELECT '4' st, substr(ret_plan_dt,1,8) AS  dt, brch_id, car_mng_id, rent_s_cd FROM RENT_CONT WHERE ret_plan_dt LIKE '"+s_dt+"%' AND ret_dt IS null AND RENT_ST='12' AND use_st<>'5' \n"+
		          " union all \n";

        //미반차-진행 
		if(mode.equals("days")){
			b_query += " SELECT '5' st, '"+s_dt+"' AS  dt, brch_id, car_mng_id, rent_s_cd FROM RENT_CONT WHERE substr(ret_plan_dt,1,8) < to_char(sysdate,'YYYYMMDD') and substr(ret_plan_dt,1,8) < '"+s_dt+"' AND ret_dt IS null AND RENT_ST='12' AND use_st<>'5' \n";
		}else if(mode.equals("months")){
			b_query += " SELECT '5' st, '"+s_dt+"' AS  dt, brch_id, car_mng_id, rent_s_cd FROM RENT_CONT WHERE substr(ret_plan_dt,1,8) < to_char(sysdate,'YYYYMMDD') and substr(ret_plan_dt,1,6) < '"+s_dt+"' AND ret_dt IS null AND RENT_ST='12' AND use_st<>'5' \n";
		}else if(mode.equals("years")){
			b_query += " SELECT '5' st, '"+s_dt+"' AS  dt, brch_id, car_mng_id, rent_s_cd FROM RENT_CONT WHERE substr(ret_plan_dt,1,8) < to_char(sysdate,'YYYYMMDD') and substr(ret_plan_dt,1,4) < '"+s_dt+"' AND ret_dt IS null AND RENT_ST='12' AND use_st<>'5' \n";
		}



		String b_dt = "dt";

		if(mode.equals("months")){
			b_dt = "substr(dt,1,6)";	
		}else if(mode.equals("years")){
			b_dt = "substr(dt,1,4)";
		}

		
		query = " select "+b_dt+" as dt, \n"+
				"        COUNT(rent_s_cd) t_cnt, \n"+
				"        COUNT(DECODE(st,'1',rent_s_cd)) t_st1, \n"+
				"        COUNT(DECODE(st,'2',rent_s_cd)) t_st2, \n"+
				"        COUNT(DECODE(st,'3',rent_s_cd)) t_st3, \n"+
				"        COUNT(DECODE(st,'4',rent_s_cd)) t_st4, \n"+
				"        COUNT(DECODE(st,'5',rent_s_cd)) t_st5, \n"+
				"        COUNT(DECODE(st,'4',rent_s_cd,'5',rent_s_cd)) t_st6, \n"+
				"        COUNT(DECODE(st,'3',rent_s_cd,'4',rent_s_cd,'5',rent_s_cd)) t_st7 \n"+
				" ";

		query += " from   ("+b_query+") \n";	
		
		if(!s_br.equals(""))	query += " where brch_id='"+s_br+"' \n";	
		
		query += " GROUP BY "+b_dt+" \n"+
				 " ORDER BY "+b_dt+" \n"+
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
			System.out.println("[ResSearchDatabase:getRentStat1]"+e);
			System.out.println("[ResSearchDatabase:getRentStat1]"+query);
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
	 *	일일영업현황
	 */	
	public Vector getRentStat1SubList(String mode, String st, String s_dt, String s_br)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String b_query = "";

		 		
		if(st.equals("1")){
			b_query = " SELECT '1' st, substr(deli_dt,1,8) AS  dt, brch_id, use_st, car_mng_id, cust_id, rent_s_cd, rent_dt, rent_start_dt, rent_end_dt, nvl(deli_dt,deli_plan_dt) deli_dt, nvl(ret_dt,ret_plan_dt) ret_dt, rent_months, rent_days FROM RENT_CONT WHERE deli_dt LIKE '"+s_dt+"%' AND RENT_ST='12' AND use_st<>'5' \n";
		}else if(st.equals("2")){
			b_query = " SELECT '2' st, a.rent_start_dt AS  dt, b.brch_id, b.use_st, b.car_mng_id, b.cust_id, b.rent_s_cd, a.rent_dt, a.rent_start_dt, a.rent_end_dt, '' deli_dt, '' ret_dt, a.rent_months, a.rent_days FROM RENT_CONT_EXT a, RENT_CONT b WHERE a.rent_start_dt LIKE '"+s_dt+"%' AND b.RENT_ST='12' AND b.use_st<>'5' and a.rent_s_cd=b.rent_s_cd \n";
		}else if(st.equals("3")){
			b_query = " SELECT '3' st, substr(ret_dt,1,8) AS  dt, brch_id, use_st, car_mng_id, cust_id, rent_s_cd, rent_dt, rent_start_dt, rent_end_dt, nvl(deli_dt,deli_plan_dt) deli_dt, nvl(ret_dt,ret_plan_dt) ret_dt, rent_months, rent_days FROM RENT_CONT WHERE ret_dt LIKE '"+s_dt+"%' AND RENT_ST='12' AND use_st<>'5' \n";
		}else if(st.equals("4")){
			b_query = " SELECT '4' st, substr(ret_plan_dt,1,8) AS  dt, brch_id, use_st, car_mng_id, cust_id, rent_s_cd, rent_dt, rent_start_dt, rent_end_dt, nvl(deli_dt,deli_plan_dt) deli_dt, nvl(ret_dt,ret_plan_dt) ret_dt, rent_months, rent_days FROM RENT_CONT WHERE ret_plan_dt LIKE '"+s_dt+"%' AND ret_dt IS null AND RENT_ST='12' AND use_st<>'5' \n";
		}else if(st.equals("5")){
			if(mode.equals("days")){
				b_query = " SELECT '5' st, '"+s_dt+"' AS  dt, brch_id, use_st, car_mng_id, cust_id, rent_s_cd, rent_dt, rent_start_dt, rent_end_dt, nvl(deli_dt,deli_plan_dt) deli_dt, nvl(ret_dt,ret_plan_dt) ret_dt, rent_months, rent_days FROM RENT_CONT WHERE substr(ret_plan_dt,1,8) < '"+s_dt+"' AND ret_dt IS null AND RENT_ST='12' AND use_st<>'5' \n";
			}else if(mode.equals("months")){
				b_query = " SELECT '5' st, '"+s_dt+"' AS  dt, brch_id, use_st, car_mng_id, cust_id, rent_s_cd, rent_dt, rent_start_dt, rent_end_dt, nvl(deli_dt,deli_plan_dt) deli_dt, nvl(ret_dt,ret_plan_dt) ret_dt, rent_months, rent_days FROM RENT_CONT WHERE substr(ret_plan_dt,1,6) < '"+s_dt+"' AND ret_dt IS null AND RENT_ST='12' AND use_st<>'5' \n";
			}else if(mode.equals("years")){
				b_query = " SELECT '5' st, '"+s_dt+"' AS  dt, brch_id, use_st, car_mng_id, cust_id, rent_s_cd, rent_dt, rent_start_dt, rent_end_dt, nvl(deli_dt,deli_plan_dt) deli_dt, nvl(ret_dt,ret_plan_dt) ret_dt, rent_months, rent_days FROM RENT_CONT WHERE substr(ret_plan_dt,1,4) < '"+s_dt+"' AND ret_dt IS null AND RENT_ST='12' AND use_st<>'5' \n";
			}
		}


		String b_dt = "a.dt";

		if(mode.equals("months")){
			b_dt = "substr(a.dt,1,6)";	
		}else if(mode.equals("years")){
			b_dt = "substr(a.dt,1,4)";
		}

		
		query = " select a.*, \n"+
				"        b.car_no, b.car_nm, c.firm_nm \n"+       
				" from   ("+b_query+") a, car_reg b, client c \n"+
				" where  a.car_mng_id=b.car_mng_id and a.cust_id=c.client_id "+
				"";	
		
		if(!s_br.equals(""))	query += " and a.brch_id='"+s_br+"' \n";	
		
		query += " ORDER BY "+b_dt+", a.ret_dt, a.rent_s_cd \n"+
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
			System.out.println("[ResSearchDatabase:getRentStat1SubList]"+e);
			System.out.println("[ResSearchDatabase:getRentStat1SubList]"+query);
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
	 *	신규영업현황
	 */	
	public Vector getRentStat2List(String mode, String gubun4, String start_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String b_query = "";


		b_query = " \n"+
				  " SELECT '1' st, brch_id, cust_id, car_mng_id, rent_s_cd, '' seq, substr(deli_dt,1,8) as rent_dt  FROM RENT_CONT WHERE RENT_ST='12' AND use_st<>'5' and deli_dt is not null \n"+
		          " union all \n"+
				  " SELECT '2' st, b.brch_id, b.cust_id, b.car_mng_id, b.rent_s_cd, a.seq, a.rent_start_dt as rent_dt FROM RENT_CONT_EXT a, RENT_CONT b WHERE b.RENT_ST='12' AND b.use_st<>'5' and a.rent_s_cd=b.rent_s_cd \n"+
		          " ";

		query = " select a.brch_id, decode(b.car_kd,'3','1', '9','1', '2','2', '1','3', '4') car_kd, decode(decode(b.car_kd,'3','1', '9','1', '2','2', '1','3', '4'),'1','소형', '2','중형', '3','대형', '기타') car_kd_nm, \n"+
				"        count(decode(a.st,'1',a.rent_s_cd)) cnt1,  \n"+
				"        sum(decode(a.st,'1',e.pay_fee)) amt1_1,  \n"+
				"        sum(decode(a.st,'1',e.dly_fee)) amt1_2,  \n"+
				"        sum(decode(a.st,'1',e.pay_fee+e.dly_fee)) amt1,  \n"+
				"        count(decode(a.st,'2',a.rent_s_cd)) cnt2,  \n"+
				"        sum(decode(a.st,'2',e2.pay_fee)) amt2_1,  \n"+
				"        sum(decode(a.st,'2',e2.dly_fee)) amt2_2,  \n"+
				"        sum(decode(a.st,'2',e2.pay_fee+e2.dly_fee)) amt2  \n"+
				" from   ("+b_query+") a, car_reg b, client c, rent_cont_ext d, \n"+
				"        (select a.rent_s_cd, sum(decode(a.pay_dt,'',a.rent_s_amt)) dly_fee, sum(decode(a.pay_dt,'',0,a.rent_s_amt)) pay_fee "+
				"         from   scd_rent a, rent_cont b "+
				"	      where  b.rent_st='12' and b.use_st<>'5' and a.rent_s_cd=b.rent_s_cd and a.rent_st in ('1','2','3') and a.rent_s_amt<>0 and nvl(a.bill_yn,'Y')='Y' "+
				"         group by a.rent_s_cd) e, \n"+
				"        (select a.rent_s_cd, a.ext_seq, sum(decode(a.pay_dt,'',a.rent_s_amt)) dly_fee, sum(decode(a.pay_dt,'',0,a.rent_s_amt)) pay_fee "+
				"         from   scd_rent a, rent_cont b "+
				"         where  b.rent_st='12' and b.use_st<>'5' and a.rent_s_cd=b.rent_s_cd and a.rent_st in ('5') and a.rent_s_amt<>0 and nvl(a.bill_yn,'Y')='Y' "+
				"         group by a.rent_s_cd, a.ext_seq) e2 \n"+
				" where  a.car_mng_id=b.car_mng_id and a.cust_id=c.client_id and a.rent_s_cd=d.rent_s_cd(+) and a.seq=d.seq(+) and a.rent_s_cd=e.rent_s_cd(+) and a.rent_s_cd=e2.rent_s_cd(+) and a.seq=e2.ext_seq(+)  \n"+
				"";	

		if(!mode.equals(""))	query += " and a.brch_id='"+mode+"' \n";	

		String dt1 = "a.rent_dt";
		
		if(gubun4.equals("1"))			query += " and "+dt1+" like to_char(sysdate,'YYYYMM')||'%'";
		if(gubun4.equals("2"))			query += " and "+dt1+" like to_char(sysdate,'YYYYMMDD')||'%'";
		if(gubun4.equals("4"))			query += " and "+dt1+" like to_char(sysdate-1,'YYYYMMDD')||'%'";
		if(gubun4.equals("5"))			query += " and "+dt1+" like to_char(to_date(to_char(sysdate,'YYYYMM'),'YYYYMM')-1,'YYYYMM')||'%'";
		if(gubun4.equals("3")){	
			if(!start_dt.equals("") && end_dt.equals(""))		query += " and "+dt1+" like replace('"+start_dt+"%', '-','')";
			if(!start_dt.equals("") && !end_dt.equals(""))		query += " and "+dt1+" between replace('"+start_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		query += " GROUP BY a.brch_id, decode(b.car_kd,'3','1', '9','1', '2','2', '1','3', '4') \n"+
				 " ";				
		
		query += " ORDER BY a.brch_id, decode(b.car_kd,'3','1', '9','1', '2','2', '1','3', '4') \n"+
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
			System.out.println("[ResSearchDatabase:getRentStat2List]"+e);
			System.out.println("[ResSearchDatabase:getRentStat2List]"+query);
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
	 *	신규영업현황 세부리스트
	 */	
	public Vector getRentStat2SubList(String gubun4, String start_dt, String end_dt, String s_br, String car_kd, String st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String b_query = "";

		 		
		if(st.equals("1")){
			b_query = " SELECT '1' st, brch_id, cust_id, use_st, car_mng_id, rent_s_cd, '' seq, substr(deli_dt,1,8) as rent_dt, rent_months, rent_days  FROM RENT_CONT WHERE RENT_ST='12' AND use_st<>'5' and deli_dt is not null \n";

			if(!s_br.equals(""))	b_query += " and brch_id='"+s_br+"' \n";	

		}else if(st.equals("2")){
			b_query = " SELECT '2' st, b.brch_id, b.cust_id, b.use_st, b.car_mng_id, b.rent_s_cd, a.seq, a.rent_start_dt as rent_dt, a.rent_months, a.rent_days FROM RENT_CONT_EXT a, RENT_CONT b WHERE b.RENT_ST='12' AND b.use_st<>'5' and a.rent_s_cd=b.rent_s_cd \n";

			if(!s_br.equals(""))	b_query += " and b.brch_id='"+s_br+"' \n";	

		}



		query = " select a.*, \n"+
				"        decode(a.st, '1', e.dly_fee, e2.dly_fee) as dly_fee, "+
				"        decode(a.st, '1', e.pay_fee, e2.pay_fee) as pay_fee, "+
				"        b.car_no, b.car_nm, c.firm_nm \n"+     
				" from   ("+b_query+") a, car_reg b, client c, \n"+
				"        (select a.rent_s_cd, sum(decode(a.pay_dt,'',a.rent_s_amt)) dly_fee, sum(decode(a.pay_dt,'',0,a.rent_s_amt)) pay_fee "+
				"         from   scd_rent a, rent_cont b "+
				"	      where  b.rent_st='12' and b.use_st<>'5' and a.rent_s_cd=b.rent_s_cd and a.rent_st in ('1','2','3') and a.rent_s_amt<>0 and nvl(a.bill_yn,'Y')='Y' "+
				"         group by a.rent_s_cd) e, \n"+
				"        (select a.rent_s_cd, a.ext_seq, sum(decode(a.pay_dt,'',a.rent_s_amt)) dly_fee, sum(decode(a.pay_dt,'',0,a.rent_s_amt)) pay_fee "+
				"         from   scd_rent a, rent_cont b "+
				"         where  b.rent_st='12' and b.use_st<>'5' and a.rent_s_cd=b.rent_s_cd and a.rent_st in ('5') and a.rent_s_amt<>0 and nvl(a.bill_yn,'Y')='Y' "+
				"         group by a.rent_s_cd, a.ext_seq) e2 \n"+
				" where  a.car_mng_id=b.car_mng_id and a.cust_id=c.client_id \n"+
				"        and a.rent_s_cd=e.rent_s_cd(+) and a.rent_s_cd=e2.rent_s_cd(+) and a.seq=e2.ext_seq(+)  \n"+
				"";	

		if(!car_kd.equals(""))	query += " and decode(b.car_kd,'3','1', '9','1', '2','2', '1','3', '4')='"+car_kd+"' \n";	

		String dt1 = "a.rent_dt";
		
		if(gubun4.equals("1"))			query += " and "+dt1+" like to_char(sysdate,'YYYYMM')||'%'";
		if(gubun4.equals("2"))			query += " and "+dt1+" like to_char(sysdate,'YYYYMMDD')||'%'";
		if(gubun4.equals("4"))			query += " and "+dt1+" like to_char(sysdate-1,'YYYYMMDD')||'%'";
		if(gubun4.equals("5"))			query += " and "+dt1+" like to_char(to_date(to_char(sysdate,'YYYYMM'),'YYYYMM')-1,'YYYYMM')||'%'";
		if(gubun4.equals("3")){	
			if(!start_dt.equals("") && end_dt.equals(""))		query += " and "+dt1+" like replace('"+start_dt+"%', '-','')";
			if(!start_dt.equals("") && !end_dt.equals(""))		query += " and "+dt1+" between replace('"+start_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

					
		
		query += " ORDER BY a.rent_dt, a.rent_s_cd \n"+
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
			System.out.println("[ResSearchDatabase:getRentStat2SubList]"+e);
			System.out.println("[ResSearchDatabase:getRentStat2SubList]"+query);
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
	 *	영업유지현황
	 */	
	public Vector getRentStat3List(String mode, String gubun4, String start_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String b_query = "";


		b_query = " \n"+
				  " SELECT '1' st, brch_id, cust_id, car_mng_id, rent_s_cd, '' seq, substr(deli_dt,1,8) as rent_dt  FROM RENT_CONT WHERE RENT_ST='12' AND use_st<>'5' and deli_dt is not null and ret_dt is null \n"+
		          " ";

		if(!mode.equals(""))	b_query += " and brch_id='"+mode+"' \n";	


		query = " select a.brch_id, decode(b.car_kd,'3','1', '9','1', '2','2', '1','3', '4') car_kd, decode(decode(b.car_kd,'3','1', '9','1', '2','2', '1','3', '4'),'1','소형', '2','중형', '3','대형', '기타') car_kd_nm, \n"+
				"        count(a.rent_s_cd) cnt1,  \n"+
				"        sum(e.est_fee) amt0,  \n"+
				"        sum(e.pay_fee) amt1_1,  \n"+
				"        sum(e.dly_fee) amt1_2,  \n"+
				"        sum(e.pay_fee+e.dly_fee) amt1 \n"+
				" from   ("+b_query+") a, car_reg b, client c, \n"+
				"        (select a.rent_s_cd, "+
				"                sum(a.rent_s_amt) est_fee, "+							//계약고
				"                sum(decode(a.pay_dt,'',a.rent_s_amt)) dly_fee, "+		//미도래+미입금
				"                sum(decode(a.pay_dt,'',0,decode(substr(a.pay_dt,1,6),to_char(sysdate,'YYYYMM'),a.rent_s_amt))) pay_fee \n"+	//매출(입금분)->당월분
				"         from   scd_rent a, rent_cont b \n"+
				"	      where  b.rent_st='12' and b.use_st<>'5' and a.rent_s_cd=b.rent_s_cd and a.rent_s_amt<>0 and nvl(a.bill_yn,'Y')='Y' \n"+
				"         group by a.rent_s_cd) e \n"+
				" where  a.car_mng_id=b.car_mng_id and a.cust_id=c.client_id \n"+
				"        and a.rent_s_cd=e.rent_s_cd(+) \n"+
				"";	



		query += " GROUP BY a.brch_id, decode(b.car_kd,'3','1', '9','1', '2','2', '1','3', '4') \n"+
				 " ";				
		
		query += " ORDER BY a.brch_id, decode(b.car_kd,'3','1', '9','1', '2','2', '1','3', '4') \n"+
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
			System.out.println("[ResSearchDatabase:getRentStat3List]"+e);
			System.out.println("[ResSearchDatabase:getRentStat3List]"+query);
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
	 *	영업유지현황 세부리스트
	 */	
	public Vector getRentStat3SubList(String s_br, String car_kd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String b_query = "";

		 		
		b_query = " \n"+
				  " SELECT '1' st, brch_id, cust_id, use_st, car_mng_id, rent_s_cd, '' seq, substr(deli_dt,1,8) as rent_dt, substr(ret_plan_dt,1,8) as exp_dt, rent_months, rent_days  FROM RENT_CONT WHERE RENT_ST='12' AND use_st<>'5' and deli_dt is not null and ret_dt is null \n"+
		          " ";

		if(!s_br.equals(""))	b_query += " and brch_id='"+s_br+"' \n";	




		query = " select a.*, \n"+
				"        d.ext_months, d.ext_days, \n"+
				"        decode( sign(to_date(a.exp_dt, 'YYYYMMDD') - to_date(a.rent_dt, 'YYYYMMDD')), -1, '0', trunc(months_between(to_date(a.exp_dt, 'YYYYMMDD')+1, to_date(a.rent_dt, 'YYYYMMDD')))) u_mon, \n"+
				"        decode( sign(to_date(a.exp_dt, 'YYYYMMDD') - to_date(a.rent_dt, 'YYYYMMDD')), -1, '0', trunc(to_date(a.exp_dt, 'YYYYMMDD')+1-add_months(to_date(a.rent_dt, 'YYYYMMDD'), trunc(months_between(to_date(a.exp_dt, 'YYYYMMDD')+1, to_date(a.rent_dt, 'YYYYMMDD')))))) u_day, \n"+
				"        trunc(sysdate-TO_DATE(SUBSTR(a.exp_dt,1,8),'YYYYMMDD')) add_day, "+
				"        e.est_fee, e.dly_fee, e.pay_fee, \n"+
				"        b.car_no, b.car_nm, c.firm_nm \n"+     
				" from   ("+b_query+") a, car_reg b, client c, \n"+
				"        (select rent_s_cd, sum(rent_months) ext_months, sum(rent_days) ext_days from rent_cont_ext group by rent_s_cd) d, \n"+
				"        (select a.rent_s_cd, "+
				"                sum(a.rent_s_amt) est_fee, "+							//계약고
				"                sum(decode(a.pay_dt,'',a.rent_s_amt)) dly_fee, "+		//미도래+미입금
				"                sum(decode(a.pay_dt,'',0,decode(substr(a.pay_dt,1,6),to_char(sysdate,'YYYYMM'),a.rent_s_amt))) pay_fee \n"+	//매출(입금분)->당월분
//				"                sum(decode(a.pay_dt,'',a.rent_s_amt)) dly_fee, "+
//				"                sum(decode(a.pay_dt,'',0,a.rent_s_amt)) pay_fee "+
				"         from   scd_rent a, rent_cont b "+
				"	      where  b.rent_st='12' and b.use_st<>'5' and a.rent_s_cd=b.rent_s_cd and a.rent_s_amt<>0 and nvl(a.bill_yn,'Y')='Y' "+
				"         group by a.rent_s_cd) e \n"+
				" where  a.car_mng_id=b.car_mng_id and a.cust_id=c.client_id \n"+
				"        and a.rent_s_cd=d.rent_s_cd(+) and a.rent_s_cd=e.rent_s_cd(+) \n"+
				"";	

		if(!car_kd.equals(""))	query += " and decode(b.car_kd,'3','1', '9','1', '2','2', '1','3', '4')='"+car_kd+"' \n";	
					
		
		query += " ORDER BY a.rent_dt, a.rent_s_cd \n"+
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
			System.out.println("[ResSearchDatabase:getRentStat3SubList]"+e);
			System.out.println("[ResSearchDatabase:getRentStat3SubList]"+query);
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
	 *	계약종료관리
	 */	
	public Vector getRentStat4List(String mode, String gubun4, String start_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String b_query = "";


		b_query = " \n"+
				  " SELECT '1' st, brch_id, cust_id, car_mng_id, rent_s_cd, nvl(cls_st,'1') cls_st, substr(ret_dt,1,8) as ret_dt  FROM RENT_CONT WHERE RENT_ST='12' AND use_st<>'5' and deli_dt is not null and ret_dt is not null \n"+
		          " union all \n"+
				  " SELECT '2' st, brch_id, cust_id, car_mng_id, rent_s_cd, cls_st, substr(ret_plan_dt,1,8) as ret_dt  FROM RENT_CONT WHERE RENT_ST='12' AND use_st<>'5' and deli_dt is not null and ret_dt is null and substr(ret_plan_dt,1,8) <= to_char(sysdate,'YYYYMMDD') \n"+
		          " ";

		query = " select a.brch_id, decode(b.car_kd,'3','1', '9','1', '2','2', '1','3', '4') car_kd, decode(decode(b.car_kd,'3','1', '9','1', '2','2', '1','3', '4'),'1','소형', '2','중형', '3','대형', '기타') car_kd_nm, \n"+
				"        count(decode(a.st,'1',decode(a.cls_st,'2',a.rent_s_cd))) cnt1,  \n"+
				"        count(decode(a.st,'1',decode(a.cls_st,'1',a.rent_s_cd))) cnt2,  \n"+
				"        count(decode(a.st,'2',a.rent_s_cd)) cnt3  \n"+
				" from   ("+b_query+") a, car_reg b, client c \n"+
				" where  a.car_mng_id=b.car_mng_id and a.cust_id=c.client_id \n"+
				"";	

		if(!mode.equals(""))	query += " and a.brch_id='"+mode+"' \n";	

		String dt1 = "a.ret_dt";
		
		if(gubun4.equals("1"))			query += " and "+dt1+" like to_char(sysdate,'YYYYMM')||'%'";
		if(gubun4.equals("2"))			query += " and "+dt1+" like to_char(sysdate,'YYYYMMDD')||'%'";
		if(gubun4.equals("4"))			query += " and "+dt1+" like to_char(sysdate-1,'YYYYMMDD')||'%'";
		if(gubun4.equals("5"))			query += " and "+dt1+" like to_char(to_date(to_char(sysdate,'YYYYMM'),'YYYYMM')-1,'YYYYMM')||'%'";
		if(gubun4.equals("3")){	
			if(!start_dt.equals("") && end_dt.equals(""))		query += " and "+dt1+" like replace('"+start_dt+"%', '-','')";
			if(!start_dt.equals("") && !end_dt.equals(""))		query += " and "+dt1+" between replace('"+start_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		query += " GROUP BY a.brch_id, decode(b.car_kd,'3','1', '9','1', '2','2', '1','3', '4') \n"+
				 " ";				
		
		query += " ORDER BY a.brch_id, decode(b.car_kd,'3','1', '9','1', '2','2', '1','3', '4') \n"+
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
			System.out.println("[ResSearchDatabase:getRentStat4List]"+e);
			System.out.println("[ResSearchDatabase:getRentStat4List]"+query);
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
	 *	계약종료관리 세부리스트
	 */	
	public Vector getRentStat4SubList(String gubun4, String start_dt, String end_dt, String s_br, String car_kd, String st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String b_query = "";

		 		

		if(st.equals("1")){
			b_query = " SELECT '1' st, brch_id, cust_id, use_st, car_mng_id, rent_s_cd, nvl(cls_st,'1') cls_st, rent_months, rent_days, substr(deli_dt,1,8) as rent_dt, substr(ret_dt,1,8) as ret_dt  FROM RENT_CONT WHERE RENT_ST='12' AND use_st<>'5' and deli_dt is not null and ret_dt is not null and nvl(cls_st,'1')='2' \n";

			if(!s_br.equals(""))	b_query += " and brch_id='"+s_br+"' \n";	

		}else if(st.equals("2")){
			b_query = " SELECT '2' st, brch_id, cust_id, use_st, car_mng_id, rent_s_cd, nvl(cls_st,'1') cls_st, rent_months, rent_days, substr(deli_dt,1,8) as rent_dt, substr(ret_dt,1,8) as ret_dt  FROM RENT_CONT WHERE RENT_ST='12' AND use_st<>'5' and deli_dt is not null and ret_dt is not null and nvl(cls_st,'1')='1' \n";

			if(!s_br.equals(""))	b_query += " and brch_id='"+s_br+"' \n";	

		}else if(st.equals("3")){
			b_query = " SELECT '3' st, brch_id, cust_id, use_st, car_mng_id, rent_s_cd, cls_st, rent_months, rent_days, substr(deli_dt,1,8) as rent_dt, substr(ret_plan_dt,1,8) as ret_dt  FROM RENT_CONT WHERE RENT_ST='12' AND use_st<>'5' and deli_dt is not null and ret_dt is null and substr(ret_plan_dt,1,8) <= to_char(sysdate,'YYYYMMDD') \n";

			if(!s_br.equals(""))	b_query += " and brch_id='"+s_br+"' \n";	
		}



		query = " select a.*, \n"+
				"        d.ext_months, d.ext_days, \n"+
				"        decode( sign(to_date(a.ret_dt, 'YYYYMMDD') - to_date(a.rent_dt, 'YYYYMMDD')), -1, '0', trunc(months_between(to_date(a.ret_dt, 'YYYYMMDD')+1, to_date(a.rent_dt, 'YYYYMMDD')))) u_mon, \n"+
				"        decode( sign(to_date(a.ret_dt, 'YYYYMMDD') - to_date(a.rent_dt, 'YYYYMMDD')), -1, '0', trunc(to_date(a.ret_dt, 'YYYYMMDD')+1-add_months(to_date(a.rent_dt, 'YYYYMMDD'), trunc(months_between(to_date(a.ret_dt, 'YYYYMMDD')+1, to_date(a.rent_dt, 'YYYYMMDD')))))) u_day, \n"+
				"        e.dly_fee, e.pay_fee, \n"+
				"        b.car_no, b.car_nm, c.firm_nm \n"+     
				" from   ("+b_query+") a, car_reg b, client c, \n"+
				"        (select rent_s_cd, sum(rent_months) ext_months, sum(rent_days) ext_days from rent_cont_ext group by rent_s_cd) d, \n"+
				"        (select a.rent_s_cd, sum(decode(a.pay_dt,'',a.rent_s_amt)) dly_fee, sum(decode(a.pay_dt,'',0,a.rent_s_amt)) pay_fee "+
				"         from   scd_rent a, rent_cont b "+
				"	      where  b.rent_st='12' and b.use_st<>'5' and a.rent_s_cd=b.rent_s_cd and a.rent_s_amt<>0 and nvl(a.bill_yn,'Y')='Y' "+
				"         group by a.rent_s_cd) e \n"+
				" where  a.car_mng_id=b.car_mng_id and a.cust_id=c.client_id \n"+
				"        and a.rent_s_cd=d.rent_s_cd(+) and a.rent_s_cd=e.rent_s_cd(+) \n"+
				"";	

		if(!car_kd.equals(""))	query += " and decode(b.car_kd,'3','1', '9','1', '2','2', '1','3', '4')='"+car_kd+"' \n";	

		String dt1 = "a.ret_dt";
		
		if(gubun4.equals("1"))			query += " and "+dt1+" like to_char(sysdate,'YYYYMM')||'%'";
		if(gubun4.equals("2"))			query += " and "+dt1+" like to_char(sysdate,'YYYYMMDD')||'%'";
		if(gubun4.equals("4"))			query += " and "+dt1+" like to_char(sysdate-1,'YYYYMMDD')||'%'";
		if(gubun4.equals("5"))			query += " and "+dt1+" like to_char(to_date(to_char(sysdate,'YYYYMM'),'YYYYMM')-1,'YYYYMM')||'%'";
		if(gubun4.equals("3")){	
			if(!start_dt.equals("") && end_dt.equals(""))		query += " and "+dt1+" like replace('"+start_dt+"%', '-','')";
			if(!start_dt.equals("") && !end_dt.equals(""))		query += " and "+dt1+" between replace('"+start_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

					
		
		query += " ORDER BY a.ret_dt, a.rent_dt, a.rent_s_cd \n"+
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
			System.out.println("[ResSearchDatabase:getRentStat4SubList]"+e);
			System.out.println("[ResSearchDatabase:getRentStat4SubList]"+query);
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
	 *	연체대여료
	 */	
	public Hashtable getRentStat5List(String mode, String s_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		String b_query = "";

		 		
		b_query = " \n"+
				  " SELECT '1' st, rent_s_cd, est_dt, pay_dt, est_dt AS dt, (rent_s_amt+rent_v_amt) amt FROM SCD_RENT WHERE est_dt='"+s_dt+"' AND pay_dt IS NULL AND NVL(bill_yn,'Y')='Y' AND rent_s_amt>0 \n"+
				  " UNION all \n"+
				  " SELECT '2' st, rent_s_cd, est_dt, pay_dt, pay_dt AS dt, (pay_amt) amt FROM SCD_RENT WHERE pay_dt='"+s_dt+"' AND NVL(bill_yn,'Y')='Y' AND rent_s_amt>0 \n"+ 
				  " UNION all \n"+
				  " SELECT '3' st, rent_s_cd, est_dt, pay_dt, '"+s_dt+"' AS dt, (rent_s_amt+rent_v_amt) amt FROM SCD_RENT WHERE est_dt < to_char(sysdate,'YYYYMMDD') and TO_CHAR(TO_DATE(est_dt,'YYYYMMDD')+1,'YYYYMMDD')='"+s_dt+"' AND (pay_dt IS NULL OR pay_dt > '"+s_dt+"') AND NVL(bill_yn,'Y')='Y' AND rent_s_amt>0 and rent_s_cd||rent_st not in ('0233124') \n"+
				  " UNION all \n"+
				  " SELECT '4' st, rent_s_cd, est_dt, pay_dt, '"+s_dt+"' AS dt, (rent_s_amt+rent_v_amt) amt FROM SCD_RENT WHERE est_dt < to_char(sysdate,'YYYYMMDD') and TO_CHAR(TO_DATE(est_dt,'YYYYMMDD')+1,'YYYYMMDD') <'"+s_dt+"' AND (pay_dt IS NULL OR pay_dt > '"+s_dt+"') and est_dt<>to_char(sysdate,'YYYYMMDD') AND NVL(bill_yn,'Y')='Y' AND rent_s_amt>0 and rent_s_cd||rent_st not in ('0233124')  \n"+
				  " UNION all \n"+
				  " SELECT '5' st, a.rent_s_cd, '' est_dt, '' pay_dt, '"+s_dt+"' AS dt, (b.inv_s_amt+b.inv_v_amt+b.navi_s_amt+b.navi_v_amt+b.etc_s_amt+b.etc_v_amt-b.dc_s_amt-b.dc_v_amt) amt FROM RENT_CONT a, RENT_FEE b WHERE a.rent_st='12' AND a.use_st<>'5' AND a.deli_dt IS NOT NULL AND a.ret_dt IS NULL AND SUBSTR(a.ret_plan_dt,1,8) < to_char(sysdate,'YYYYMMDD') AND SUBSTR(a.ret_plan_dt,1,8) < '"+s_dt+"' AND TO_CHAR(TO_DATE(SUBSTR(a.ret_plan_dt,1,8),'YYYYMMDD')+1,'YYYYMMDD')='"+s_dt+"' AND a.rent_s_cd=b.rent_s_cd   \n"+
				  " UNION all \n"+
				  " SELECT '6' st, a.rent_s_cd, '' est_dt, '' pay_dt, '"+s_dt+"' AS dt, (b.inv_s_amt+b.inv_v_amt+b.navi_s_amt+b.navi_v_amt+b.etc_s_amt+b.etc_v_amt-b.dc_s_amt-b.dc_v_amt) amt FROM RENT_CONT a, RENT_FEE b WHERE a.rent_st='12' AND a.use_st<>'5' AND a.deli_dt IS NOT NULL AND a.ret_dt IS NULL AND SUBSTR(a.ret_plan_dt,1,8) < to_char(sysdate,'YYYYMMDD') AND SUBSTR(a.ret_plan_dt,1,8) < '"+s_dt+"' AND TO_CHAR(TO_DATE(SUBSTR(a.ret_plan_dt,1,8),'YYYYMMDD')+1,'YYYYMMDD')<'"+s_dt+"' and TO_CHAR(TO_DATE(SUBSTR(a.ret_plan_dt,1,8),'YYYYMMDD')+1,'YYYYMMDD')<>to_char(sysdate,'YYYYMMDD') AND a.rent_s_cd=b.rent_s_cd   \n"+
				  " UNION all \n"+
                  " SELECT '7' st, rent_s_cd, est_dt, pay_dt, '"+s_dt+"' AS dt, decode(pay_dt,'',rent_s_amt+rent_v_amt,pay_amt) amt FROM SCD_RENT WHERE (pay_dt IS NULL OR pay_dt > '"+s_dt+"')  AND NVL(bill_yn,'Y')='Y' AND rent_s_amt>0 \n"+
				  "  \n";


		String b_dt = "a.dt";

		
		query = " select "+b_dt+" as dt, \n"+
				"        COUNT(DECODE(a.st,'1',a.rent_s_cd)) cnt1,  \n"+
				"        nvl(SUM  (DECODE(a.st,'1',a.amt)),0) amt1, \n"+
				"        COUNT(DECODE(a.st,'2',a.rent_s_cd)) cnt2,  \n"+
				"        nvl(SUM  (DECODE(a.st,'2',a.amt)),0) amt2, \n"+
				"        COUNT(DECODE(a.st,'3',a.rent_s_cd)) cnt3,  \n"+
				"        nvl(SUM  (DECODE(a.st,'3',a.amt)),0) amt3, \n"+
				"        COUNT(DECODE(a.st,'4',a.rent_s_cd)) cnt4,  \n"+
				"        nvl(SUM  (DECODE(a.st,'4',a.amt)),0) amt4, \n"+
				"        COUNT(DECODE(a.st,'5',a.rent_s_cd)) cnt5,  \n"+
				"        nvl(SUM  (DECODE(a.st,'5',a.amt)),0) amt5, \n"+
				"        COUNT(DECODE(a.st,'6',a.rent_s_cd)) cnt6,  \n"+
				"        nvl(SUM  (DECODE(a.st,'6',a.amt)),0) amt6, \n"+
				"        COUNT(DECODE(a.st,'7',a.rent_s_cd)) cnt7,  \n"+
				"        nvl(SUM  (DECODE(a.st,'7',a.amt)),0) amt7, \n"+           
                "        decode(  nvl(SUM  (DECODE(a.st,'3',a.amt)),0)+nvl(SUM  (DECODE(a.st,'4',a.amt)),0)+nvl(SUM  (DECODE(a.st,'5',a.amt)),0)+nvl(SUM  (DECODE(a.st,'6',a.amt)),0), 0, 0.00, "+
                "        TO_CHAR( \n"+
                "					(nvl(SUM  (DECODE(a.st,'3',a.amt)),0)+nvl(SUM  (DECODE(a.st,'4',a.amt)),0)+nvl(SUM  (DECODE(a.st,'5',a.amt)),0)+nvl(SUM  (DECODE(a.st,'6',a.amt)),0))   \n"+
                "                    /  \n"+
                "                   (nvl(SUM  (DECODE(a.st,'7',a.amt)),0)+nvl(SUM  (DECODE(a.st,'5',a.amt)),0)+nvl(SUM  (DECODE(a.st,'6',a.amt)),0))  \n"+
                "                    * 100 \n"+
                "                , '9999.99')) dly_per   \n"+
				" ";

		query += " from   ("+b_query+") a, rent_cont b where a.rent_s_cd=b.rent_s_cd and b.rent_st='12' and b.use_st<>'5' \n";	
						
		query += " GROUP BY "+b_dt+" \n"+
				 " ORDER BY "+b_dt+" \n"+
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
			System.out.println("[ResSearchDatabase:getRentStat5]"+e);
			System.out.println("[ResSearchDatabase:getRentStat5]"+query);
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
	 *	연체대여료
	 */	
	public Vector getRentStat5SubList(String mode, String st, String s_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String b_query = "";

		 		

		if(st.equals("1")){
			b_query = " SELECT '1' st, rent_s_cd, est_dt, pay_dt, est_dt AS dt, (rent_s_amt+rent_v_amt) amt FROM SCD_RENT WHERE est_dt='"+s_dt+"' AND pay_dt IS NULL AND NVL(bill_yn,'Y')='Y' AND rent_s_amt>0 \n";
		}else if(st.equals("2")){
			b_query = " SELECT '2' st, rent_s_cd, est_dt, pay_dt, pay_dt AS dt, (pay_amt) amt FROM SCD_RENT WHERE pay_dt='"+s_dt+"' AND NVL(bill_yn,'Y')='Y' AND rent_s_amt>0 \n";
		}else if(st.equals("3")){
			b_query = " SELECT '3' st, rent_s_cd, est_dt, pay_dt, '"+s_dt+"' AS dt, (rent_s_amt+rent_v_amt) amt FROM SCD_RENT WHERE est_dt < to_char(sysdate,'YYYYMMDD') and TO_CHAR(TO_DATE(est_dt,'YYYYMMDD')+1,'YYYYMMDD')='"+s_dt+"' AND (pay_dt IS NULL OR pay_dt > '"+s_dt+"') AND NVL(bill_yn,'Y')='Y' AND rent_s_amt>0 and rent_s_cd||rent_st not in ('0233124')  \n";
		}else if(st.equals("4")){
			b_query = " SELECT '4' st, rent_s_cd, est_dt, pay_dt, '"+s_dt+"' AS dt, (rent_s_amt+rent_v_amt) amt FROM SCD_RENT WHERE est_dt < to_char(sysdate,'YYYYMMDD') and TO_CHAR(TO_DATE(est_dt,'YYYYMMDD')+1,'YYYYMMDD') <'"+s_dt+"' AND (pay_dt IS NULL OR pay_dt > '"+s_dt+"') AND NVL(bill_yn,'Y')='Y' AND rent_s_amt>0 and rent_s_cd||rent_st not in ('0233124')  \n";
		}else if(st.equals("5")){
			b_query = " SELECT '5' st, a.rent_s_cd, '"+s_dt+"' as est_dt, '' pay_dt, '"+s_dt+"' AS dt, (b.inv_s_amt+b.inv_v_amt+b.navi_s_amt+b.navi_v_amt+b.etc_s_amt+b.etc_v_amt-b.dc_s_amt-b.dc_v_amt) amt FROM RENT_CONT a, RENT_FEE b WHERE a.rent_st='12' AND a.use_st<>'5' AND a.deli_dt IS NOT NULL AND a.ret_dt IS NULL AND SUBSTR(a.ret_plan_dt,1,8) < to_char(sysdate,'YYYYMMDD') AND SUBSTR(a.ret_plan_dt,1,8) < '"+s_dt+"' AND TO_CHAR(TO_DATE(SUBSTR(a.ret_plan_dt,1,8),'YYYYMMDD')+1,'YYYYMMDD')='"+s_dt+"' AND a.rent_s_cd=b.rent_s_cd  \n";
		}else if(st.equals("6")){
			b_query = " SELECT '6' st, a.rent_s_cd, '"+s_dt+"' as est_dt, '' pay_dt, '"+s_dt+"' AS dt, (b.inv_s_amt+b.inv_v_amt+b.navi_s_amt+b.navi_v_amt+b.etc_s_amt+b.etc_v_amt-b.dc_s_amt-b.dc_v_amt) amt FROM RENT_CONT a, RENT_FEE b WHERE a.rent_st='12' AND a.use_st<>'5' AND a.deli_dt IS NOT NULL AND a.ret_dt IS NULL AND SUBSTR(a.ret_plan_dt,1,8) < to_char(sysdate,'YYYYMMDD') AND SUBSTR(a.ret_plan_dt,1,8) < '"+s_dt+"' AND TO_CHAR(TO_DATE(SUBSTR(a.ret_plan_dt,1,8),'YYYYMMDD')+1,'YYYYMMDD')<'"+s_dt+"' AND a.rent_s_cd=b.rent_s_cd  \n";
		}else if(st.equals("7")){
			b_query = " SELECT '7' st, rent_s_cd, est_dt, pay_dt, '"+s_dt+"' AS dt, decode(pay_dt,'',rent_s_amt+rent_v_amt,pay_amt) amt FROM SCD_RENT WHERE (pay_dt IS NULL OR pay_dt > '"+s_dt+"')  AND NVL(bill_yn,'Y')='Y' AND rent_s_amt>0 \n";
		}


		String b_dt = "a.dt";

		
		query = " select a.*, d.car_mng_id, d.use_st, \n"+
				"        substr(d.deli_dt,1,8) deli_dt, substr(nvl(d.ret_dt,d.ret_plan_dt),1,8) ret_dt, \n"+
				"        b.car_no, b.car_nm, c.firm_nm \n"+       
				" from   ("+b_query+") a, rent_cont d, car_reg b, client c \n"+
				" where  a.rent_s_cd=d.rent_s_cd and d.rent_st='12' and d.use_st<>'5' and d.car_mng_id=b.car_mng_id and d.cust_id=c.client_id "+
				"";	
		
		
		query += " ORDER BY a.est_dt, "+b_dt+", d.deli_dt, nvl(d.ret_dt,d.ret_plan_dt), a.rent_s_cd \n"+
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
			System.out.println("[ResSearchDatabase:getRentStat5SubList]"+e);
			System.out.println("[ResSearchDatabase:getRentStat5SubList]"+query);
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
	 *	단기대여 요금 스케줄  관리번호 생성
	 */
	public String getScdRentNextTm(String s_cd, String rent_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String tm = "";
		String query = "";

		//관리번호 생성
		query = " select to_char(MAX(tm)+1) ID from SCD_RENT where rent_s_cd=? and rent_st=?";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, s_cd);
			pstmt.setString(2, rent_st);
	    	rs = pstmt.executeQuery();
    		if(rs.next()){
	    		tm=rs.getString(1)==null?"":rs.getString(1);
			}
			
			if(tm.equals("")) tm = "1";

			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:getScdRentNextTm]"+e);
			System.out.println("[ResSearchDatabase:getScdRentNextTm]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return tm;
		}
	}

	//연장 등록
	public RentContBean insertRentContExt(RentContBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;

		//관리번호 생성
		String id_sql = " select nvl(ltrim(to_char(to_number(MAX(seq))+1, '00')), '01') ID from RENT_CONT_EXT where rent_s_cd=?";
		String seq ="";
		try{
			pstmt = conn.prepareStatement(id_sql);
			pstmt.setString(1, bean.getRent_s_cd());
	    	rs = pstmt.executeQuery();
	    	if(rs.next())
	    		seq=rs.getString(1)==null?"":rs.getString(1);

			rs.close();
			pstmt.close();

		} catch (SQLException e) {
	  		e.printStackTrace();
	  	} catch (Exception e) {
	  		e.printStackTrace();
	  	}
	  	
		if(seq.equals(""))	seq = "01";
		bean.setSeq(seq);
		
		String query = "";
		query = " insert into RENT_CONT_EXT "+
				" ( rent_s_cd, seq, rent_dt, rent_start_dt, rent_end_dt, rent_days, rent_months, reg_id, reg_dt, mng_id "+
				" ) values ("+
				"   ?, ?, replace(?,'-',''), replace(?,'-',''), replace(?,'-',''), ?, ?, ?, to_char(sysdate,'YYYYMMDDhh24miss'), ? "+
				" )";		
		try 
		{			
			
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query);
			pstmt1.setString(1, bean.getRent_s_cd		().trim()	);
			pstmt1.setString(2, bean.getSeq				().trim()	);
			pstmt1.setString(3, bean.getRent_dt			().trim()	);
			pstmt1.setString(4, bean.getRent_start_dt	().trim()	);
			pstmt1.setString(5, bean.getRent_end_dt		().trim()	);
			pstmt1.setString(6, bean.getRent_days		().trim()	);
			pstmt1.setString(7, bean.getRent_months		().trim()	);
			pstmt1.setString(8, bean.getReg_id			().trim()	);
			pstmt1.setString(9, bean.getMng_id			().trim()	);
			pstmt1.executeUpdate();
			pstmt1.close();

			conn.commit();
		    
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:insertRentContExt]\n"+e);
	  		e.printStackTrace();
			conn.rollback();
	  	} catch (Exception e) {
		  	System.out.println("[ResSearchDatabase:insertRentContExt]\n"+e);
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(rs != null)		rs.close();
				if(pstmt != null)	pstmt.close();
				if(pstmt1 != null)	pstmt1.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}
	}

	/**
	 *	단기대여 연장리스트
	 */
	public Vector getRentContExtList(String s_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

 		query = " select a.*, b.pay_amt "+ 
				" from   RENT_CONT_EXT a,  "+ 
				"        (SELECT rent_s_cd, ext_seq, SUM(pay_amt) pay_amt FROM SCD_RENT WHERE rent_st='5' GROUP BY rent_s_cd, ext_seq) b  "+ 
				" where  a.rent_s_cd='"+s_cd+"' AND a.rent_s_cd=b.rent_s_cd(+) AND a.seq=b.ext_seq(+)  "+ 
				" order by a.seq ";

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
			System.out.println("[ResSearchDatabase:getRentContExtList]"+e);
			System.out.println("[ResSearchDatabase:getRentContExtList]"+query);
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
	 *	월렌트 기존거래 리스트
	 */
	public Vector getRentContCustHList(String rent_st, String cust_id, String rent_s_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

 		query = " select b.car_no, b.car_nm, a.*, c.user_nm as bus_nm, d.user_nm as mng_nm, "+
				"        decode(a.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트','대기') rent_st_nm, "+ 
				"        decode(a.use_st,'1','예약','2','배차','3','반차','4','종료') use_st_nm "+
				" from   RENT_CONT a, car_reg b, users c, users d "+
				" where  a.use_st<>'5' and a.rent_st='"+rent_st+"' and a.cust_id='"+cust_id+"' and a.rent_s_cd<>'"+rent_s_cd+"'"+
				"        and a.car_mng_id=b.car_mng_id and a.bus_id=c.user_id and a.mng_id=d.user_id(+)"+
				" order by a.rent_dt desc ";

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
			System.out.println("[ResSearchDatabase:getRentContCustHList]"+e);
			System.out.println("[ResSearchDatabase:getRentContCustHList]"+query);
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
	 *	배차관리-취소시 미수금스케줄 미청구처리
	 */
	public int cancleScdRent(String s_cd)
	{
		getConnection();
		int count = 0;
		PreparedStatement pstmt = null;
		String query = "";

		query = " update scd_rent set bill_yn='N' where rent_s_cd='"+s_cd+"' and pay_dt is null";// and rent_s_amt>0

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.executeUpdate();
			pstmt.close();
			count =1;

			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[ResSearchDatabase:cancleScdRent]\n"+e);
			System.out.println("[ResSearchDatabase:cancleScdRent]\n"+query);
			e.printStackTrace();
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	/**	
	 *	배차관리-배차시 미수금스케줄 입금예정일 공단 배차일자로 처리
	 */
	public int updateRMScdRentEstDt(String s_cd, String deli_dt)
	{
		getConnection();
		int count = 0;
		PreparedStatement pstmt = null;
		String query = "";

		query = " update scd_rent set est_dt=substr(replace('"+deli_dt+"','-',''),1,8) where rent_s_cd='"+s_cd+"' and pay_dt is null and rent_s_amt>0 and est_dt is null ";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.executeUpdate();
			pstmt.close();
			count =1;

			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[ResSearchDatabase:updateRMScdRentEstDt]\n"+e);
			System.out.println("[ResSearchDatabase:updateRMScdRentEstDt]\n"+query);
			e.printStackTrace();
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	//관리담당자 리스트 조회 
	public Vector getSearchMngIdList(String brch_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.user_nm, a.user_id, a.user_pos, b.cnt \n"+
				" FROM   USERS a, (SELECT mng_id, count(0) cnt FROM RENT_CONT WHERE rent_st='12' AND use_st IN ('1','2') GROUP BY mng_id) b \n"+
				" WHERE a.user_id=b.mng_id \n"+
				" AND a.br_id='"+brch_id+"' AND a.loan_st='1' \n"+
				" ORDER BY b.cnt, a.user_id desc ";
					
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
			System.out.println("[ResSearchDatabase:getSearchMngIdList]\n"+e);
			System.out.println("[ResSearchDatabase:getSearchMngIdList]\n"+query);
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
	
	//고객관련자 리스트 조회 
	public Vector getSearchRentMgrList(String client_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT c.car_no, a.rent_dt, \n"+
				"        DECODE(b.mgr_st,'4','계약자','2','비상연락처','1','추가운전자') mgr_st_nm, \n"+
				"        decode(b.lic_st,'1','2종보통','2','1종보통','3','1종대형') lic_st_nm, \n"+
				"        b.* \n"+
				" FROM   rent_cont a, rent_mgr b, car_reg c \n"+
				" WHERE  a.cust_st='1' and a.cust_id='"+client_id+"' and a.rent_s_cd=b.rent_s_cd and a.car_mng_id=c.car_mng_id \n"+
				"        AND b.mgr_nm||b.ssn||b.zip||b.addr||b.lic_no||b.tel||b.etc IS NOT null \n"+
				" ORDER BY b.rent_s_cd, b.mgr_st ";
					
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
			System.out.println("[ResSearchDatabase:getSearchRentMgrList]\n"+e);
			System.out.println("[ResSearchDatabase:getSearchRentMgrList]\n"+query);
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

	//고객관련자 리스트 조회 
	public Vector getSearchRentFeeCmsList(String client_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT c.car_no, a.rent_dt, \n"+
				"        b.cms_bank, b.cms_acc_no, b.cms_dep_nm \n"+
				" FROM   rent_cont a, rent_fee b, car_reg c \n"+
				" WHERE  a.cust_st='1' and a.cust_id='"+client_id+"' and a.rent_s_cd=b.rent_s_cd and a.car_mng_id=c.car_mng_id \n"+
				"        AND b.cms_bank||b.cms_acc_no IS NOT null \n"+
				" ORDER BY b.rent_s_cd ";
					
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
			System.out.println("[ResSearchDatabase:getSearchRentFeeCmsList]\n"+e);
			System.out.println("[ResSearchDatabase:getSearchRentFeeCmsList]\n"+query);
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


	public Hashtable getAxHubCase(String am_good_id1, String am_good_id2, int am_good_amt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select * from ax_hub where am_good_id1=? and am_good_amt=? ";
		
		if(!am_good_id2.equals("")) query += " and am_good_id2='"+am_good_id2+"' ";

		try 
		{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  am_good_id1);
			pstmt.setInt   (2,  am_good_amt);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next())
			{								
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
		    rs.close();
            pstmt.close();	

		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:getAxHubCase]\n"+e);
			System.out.println("[ResSearchDatabase:getAxHubCase]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
    }

	public Hashtable getAxHubCase(String am_ax_code)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select * from ax_hub where am_ax_code=? ";

		try 
		{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  am_ax_code);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next())
			{								
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
		    rs.close();
            pstmt.close();	

		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:getAxHubCase(String am_ax_code)]\n"+e);
			System.out.println("[ResSearchDatabase:getAxHubCase(String am_ax_code)]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
    }

	//결제인증번호발행
	public int insertAxHub(String am_ax_code, String am_good_st, String am_good_id1, String am_good_id2, int am_good_amt, int am_good_s_amt, int am_good_v_amt, int am_good_m_amt, String reg_id, String email, String m_tel)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;		
		String query = "";
		query = " INSERT INTO ax_hub "+
				"        ( am_ax_code, am_good_st, am_good_id1, am_good_id2, am_good_amt, am_good_s_amt, am_good_v_amt, am_good_m_amt, am_reg_id, am_reg_dt, buyr_mail, buyr_tel2, am_m_tel ) "+
				"        VALUES "+
				"        ( ?, ?, ?, ?, ?, ?, ?, ?, ?, sysdate, ?, ?, ?) "+
				" ";
		try 
		{			
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1,  am_ax_code		);
			pstmt.setString(2,  am_good_st		);
			pstmt.setString(3,  am_good_id1		);
			pstmt.setString(4,  am_good_id2		);
			pstmt.setInt   (5,  am_good_amt		);
			pstmt.setInt   (6,  am_good_s_amt	);
			pstmt.setInt   (7,  am_good_v_amt	);
			pstmt.setInt   (8,  am_good_m_amt	);
			pstmt.setString(9,  reg_id			);
			pstmt.setString(10, email			);
			pstmt.setString(11, m_tel			);
			pstmt.setString(12, m_tel			);

			count = pstmt.executeUpdate();
			pstmt.close();
		    conn.commit();

		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:insertAxHub]\n"+e);
			System.out.println("[am_ax_code		]\n"+am_ax_code		);
			System.out.println("[am_good_st		]\n"+am_good_st		);
			System.out.println("[am_good_id1	]\n"+am_good_id1	);
			System.out.println("[am_good_id2	]\n"+am_good_id2	);
			System.out.println("[am_good_amt	]\n"+am_good_amt	);
			System.out.println("[am_good_s_amt	]\n"+am_good_s_amt	);
			System.out.println("[am_good_v_amt	]\n"+am_good_v_amt	);
			System.out.println("[am_good_m_amt	]\n"+am_good_m_amt	);
			System.out.println("[reg_id			]\n"+reg_id			);
	  		e.printStackTrace();
			conn.rollback();
	  	} catch (Exception e) {
		  	System.out.println("[ResSearchDatabase:insertAxHub]\n"+e);
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	//결제인증번호 문자재발행
	public int updateAxHub(String am_ax_code, String reg_id, String m_tel)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;		
		String query = "";
		query = " update ax_hub set "+
				"        am_reg_id=?, buyr_tel2=?, am_m_tel=? "+
				" where  am_ax_code = ? "+
				" ";
		try 
		{			
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, reg_id			);
			pstmt.setString(2, m_tel			);
			pstmt.setString(3, m_tel			);
			pstmt.setString(4, am_ax_code		);

			count = pstmt.executeUpdate();
			pstmt.close();
		    conn.commit();

		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:updateAxHub]\n"+e);
			System.out.println("[am_ax_code		]\n"+am_ax_code		);
	  		e.printStackTrace();
			conn.rollback();
	  	} catch (Exception e) {
		  	System.out.println("[ResSearchDatabase:updateAxHub]\n"+e);
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	public String getBrchMaxMngId(String brch_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String mng_id = "";
		String query = "";

		query = " SELECT a.mng_id \n"+
                " FROM   RENT_CONT a, \n"+
                "        (SELECT max(reg_dt) reg_dt FROM RENT_CONT WHERE brch_id=? and rent_st='12' and use_st not in ('5') AND bus_id<>mng_id and mng_id NOT IN ('000006','000052','000053','000085','000077')) b \n"+
                " WHERE  a.brch_id=? and a.rent_st='12' and a.use_st not in ('5') and bus_id<>mng_id \n"+
                "        AND a.reg_dt=b.reg_dt \n"+
				" ";

		try 
		{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  brch_id);
			pstmt.setString(2,  brch_id);
	    	rs = pstmt.executeQuery();
    		
			if(rs.next())
			{					
				mng_id = rs.getString(1)==null?"":rs.getString(1);	
			}
		    rs.close();
            pstmt.close();	

		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:getBrchMaxMngId]\n"+e);
			System.out.println("[ResSearchDatabase:getBrchMaxMngId]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return mng_id;
		}
    }

	public String getBrchMaxMngIdLcContRm(String brch_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String mng_id = "";
		String query = "";

		int cnt = 0;

		query = " SELECT a.mng_id \n"+
                " FROM   CONT a, fee c, users d \n"+
                " WHERE  a.car_st in ('4') and a.rent_st='1' and a.bus_id<>a.mng_id and a.mng_id NOT IN ('000026','000053','000052','000066')  \n"+
                "        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and c.rent_st='1' \n"+
			    "        and a.bus_id=d.user_id  \n"+
                "        and decode(d.br_id, 'S2','S1', 'S3','S1', 'S4','S1', 'S5','S1', 'S6','S1', 'I1','S1', 'U1','B1', d.br_id)=decode('"+brch_id+"', 'S2','S1', 'S3','S1', 'S4','S1', 'S5','S1', 'S6','S1', 'I1','S1', 'U1','B1', '"+brch_id+"') \n"+
			    "        AND d.use_yn='Y'  AND d.dept_id <>'8888' \n"+
                "        AND TO_CHAR(TO_DATE(a.reg_dt,'YYYYMMDD')+100,'YYYYMMDD') > TO_CHAR(SYSDATE,'YYYYMMDD') \n"+
                "        ORDER BY a.reg_dt||a.rent_mng_id desc "+
				" ";


		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		
			while(rs.next())
			{		
				if(cnt == 0){	
					mng_id = rs.getString("mng_id")==null?"":rs.getString("mng_id");	
				}
				cnt++;
			}
		    rs.close();
            pstmt.close();	

		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:getBrchMaxMngIdLcContRm]\n"+e);
			System.out.println("[ResSearchDatabase:getBrchMaxMngIdLcContRm]\n"+query);
			System.out.println("[ResSearchDatabase:getBrchMaxMngIdLcContRm]\n"+mng_id);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return mng_id;
		}
    }

	public String getBrchMaxMngIdLcCont(String brch_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String mng_id = "";
		String query = "";

		query = " SELECT a.bus_id2 as mng_id \n"+
                " FROM   CONT a, fee c, users d, \n"+
                "        ( SELECT max(a.reg_dt||a.rent_mng_id) max_rent_mng_id "+
				"          FROM   CONT a, users b "+
				"          WHERE  a.car_st in ('1','3') and a.rent_st='1' AND a.bus_id<>a.mng_id and a.mng_id NOT IN ('000006','000052','000053','000085','000077') "+
				"                 and a.bus_id2=b.user_id and decode(b.br_id, 'S2','S1', 'S3','S1', 'S4','S1', 'S5','S1', 'S6','S1', 'I1','S1', 'U1','B1', b.br_id)=? "+
			    "                 AND b.use_yn='Y'  AND b.dept_id <>'8888' "+
                "                 AND TO_CHAR(ADD_MONTHS(TO_DATE(b.enter_dt,'YYYYMMDD'),2),'YYYYMMDD') < TO_CHAR(SYSDATE,'YYYYMMDD') "+
				"        ) b \n"+
                " WHERE  a.car_st in ('1','3') and a.rent_st='1' and a.bus_id<>a.mng_id \n"+
                "        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and c.rent_st='1' "+
				"        AND a.reg_dt||a.rent_mng_id=b.max_rent_mng_id \n"+
			    "        and a.bus_id2=d.user_id and decode(d.br_id, 'S2','S1', 'S3','S1', 'S4','S1', 'S5','S1', 'S6','S1', 'I1','S1', 'U1','B1', d.br_id)=?  "+
			    "        AND d.use_yn='Y'  AND d.dept_id <>'8888' "+
                "        AND TO_CHAR(ADD_MONTHS(TO_DATE(d.enter_dt,'YYYYMMDD'),2),'YYYYMMDD') < TO_CHAR(SYSDATE,'YYYYMMDD') "+
				" ";

		try 
		{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  brch_id);
			pstmt.setString(2,  brch_id);
	    	rs = pstmt.executeQuery();
    		
			if(rs.next())
			{					
				mng_id = rs.getString(1)==null?"":rs.getString(1);	
			}
		    rs.close();
            pstmt.close();	

		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:getBrchMaxMngIdLcCont]\n"+e);
			System.out.println("[ResSearchDatabase:getBrchMaxMngIdLcCont]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return mng_id;
		}
    }

	//마지막배정자 갖고오기
	public Vector getBrchMaxMngIdLcContList(String brch_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.bus_id2 as mng_id \n"+
                " FROM   CONT a, fee c, users d \n"+
                " WHERE  a.car_st in ('1','3') and a.rent_st='1' and a.bus_id<>a.mng_id and a.mng_id NOT IN ('000026','000052','000053')  \n"+
                "        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and c.rent_st='1' \n"+
			    "              and a.bus_id2=d.user_id  \n"+
                "        and decode(d.br_id, 'S2','S1', 'S3','S1', 'S4','S1', 'S5','S1', 'S6','S1', 'I1','S1', 'U1','B1', d.br_id)=? \n"+
			    "              AND d.use_yn='Y'  AND d.dept_id <>'8888' \n"+
                "        AND TO_CHAR(TO_DATE(a.reg_dt,'YYYYMMDD')+10,'YYYYMMDD') > TO_CHAR(SYSDATE,'YYYYMMDD') \n"+
                "        ORDER BY a.reg_dt||a.rent_mng_id desc "+
				" ";
					
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  brch_id);
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
			System.out.println("[ResSearchDatabase:getBrchMaxMngIdLcContList]\n"+e);
			System.out.println("[ResSearchDatabase:getBrchMaxMngIdLcContList]\n"+query);
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
	*	월렌트 월대여료대비 적용율
	*/
	public Hashtable getEstiRmDayPers(String per){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();

		String var1 = "0.15";

		if(per.equals("")) per = "0";

		String query =  " SELECT \n";

		for (int i = 0 ; i < 30 ; i++){
			query +=	" ROUND( ("+var1+"+ROUND(POWER("+(i+1)+",1/2)/POWER(30,1/2)*(1-"+var1+"),2)) * 100 / (1-"+per+"), 0) AS per_"+(i+1)+", \n";	
		}

			query +=	" "+per+" as per "+
						" FROM   dual \n"+
						" ";

		try{


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
		}catch(Exception e){
			System.out.println("[ResSearchDatabase:getEstiRmDayPers]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return ht;
		}
	}

	/**
	 *	월렌트 카드결재 리스트
	 */
	public Vector getRentContCardList(String s_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

 		query = " select * from ax_hub where am_good_id1='"+s_cd+"' and am_good_st='월렌트' order by am_ax_code ";

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
			System.out.println("[ResSearchDatabase:getRentContCardList]"+e);
			System.out.println("[ResSearchDatabase:getRentContCardList]"+query);
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
	 *	월렌트 카드결재 리스트
	 */
	public Vector getRentContCardList(String am_good_id1, String am_good_id2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

 		query = " select * from ax_hub where am_good_id1='"+am_good_id1+"' ";
		
		
		if(!am_good_id2.equals("")) query += " and am_good_id2='"+am_good_id2+"' ";
		
		query += " order by am_ax_code ";

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
			System.out.println("[ResSearchDatabase:getRentContCardList]"+e);
			System.out.println("[ResSearchDatabase:getRentContCardList]"+query);
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
	 *	월렌트 카드결재 리스트
	 */
	public Vector getFineSettleList(String s_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

 		query = " SELECT b.rent_mng_id, b.rent_l_cd, b.seq_no, b.car_mng_id, "+
				"        b.coll_dt, b.proxy_dt, b.vio_dt, b.vio_pla, b.vio_cont, b.paid_amt, b.coll_dt, b.fault_st, b.bill_yn, b.paid_st, b.no_paid_yn, b.reg_dt \n"+
				" FROM   RENT_CONT a, FINE b \n"+
				" WHERE   \n"+
				"        a.rent_s_cd='"+s_cd+"' \n"+
				"        AND a.rent_s_cd=b.rent_s_cd \n"+
				"        and b.paid_amt>0 \n"+
				"        and b.coll_dt is NULL \n"+			//--수금일자없음
				"        AND b.fault_st='1'	\n"+			//--고객과실
				"        and nvl(b.bill_yn,'Y')='Y' \n"+	//--청구분
				"        and b.paid_st in ('3','4') \n"+	//--회사대납,수금납입
				"        and nvl(b.no_paid_yn,'N')='N' \n"+	//--면제아닌
				" order by b.vio_dt ";

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
			System.out.println("[ResSearchDatabase:getFineSettleList]"+e);
			System.out.println("[ResSearchDatabase:getFineSettleList]"+query);
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
	 *	일일영업현황
	 */	
	public Hashtable getRmRentStat1(String mode, String s_dt, String s_br)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		String b_query = "";

		b_query = " \n"+
			      //개시
				  " SELECT '1' st, b.rent_start_dt AS  dt, a.brch_id, a.use_yn, a.car_mng_id, a.client_id, a.rent_mng_id, a.rent_l_cd, a.rent_dt, b.rent_start_dt, b.rent_end_dt, b.con_mon, d.con_day, b.rent_st, c.cls_dt FROM cont a, fee b, cls_cont c, fee_etc d WHERE a.car_st='4' AND a.rent_l_cd NOT LIKE 'RM%' AND a.rent_l_cd NOT IN ('S113KNLM00003','S113HA4M00001') and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_st='1' and b.rent_start_dt LIKE '"+s_dt+"%' and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) and b.rent_start_dt < nvl(c.cls_dt,b.rent_end_dt) and b.rent_mng_id=d.rent_mng_id and b.rent_l_cd=d.rent_l_cd and b.rent_st=d.rent_st \n"+
		          " union all \n"+
                  //연장계약
				  " SELECT '2' st, b.rent_start_dt AS  dt, a.brch_id, a.use_yn, a.car_mng_id, a.client_id, a.rent_mng_id, a.rent_l_cd, b.rent_dt, b.rent_start_dt, b.rent_end_dt, b.con_mon, d.con_day, b.rent_st, c.cls_dt FROM cont a, fee b, cls_cont c, fee_etc d WHERE a.car_st='4' AND a.rent_l_cd NOT LIKE 'RM%' AND a.rent_l_cd NOT IN ('S113KNLM00003','S113HA4M00001') and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_st<>'1' and b.rent_start_dt LIKE '"+s_dt+"%' and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) and b.rent_start_dt < nvl(c.cls_dt,b.rent_end_dt) and b.rent_mng_id=d.rent_mng_id and b.rent_l_cd=d.rent_l_cd and b.rent_st=d.rent_st \n"+
			      " union all \n"+
                  //반차
				  " SELECT '3' st, c.cls_dt AS         dt, a.brch_id, a.use_yn, a.car_mng_id, a.client_id, a.rent_mng_id, a.rent_l_cd, a.rent_dt, b.rent_start_dt, b.rent_end_dt, b.con_mon, '' con_day, '' rent_st, c.cls_dt FROM cont a, (select rent_mng_id, rent_l_cd, to_char(sum(con_mon)) con_mon, min(rent_start_dt) rent_start_dt, max(rent_end_dt) rent_end_dt from fee group by rent_mng_id, rent_l_cd) b, cls_cont c WHERE a.car_st='4' AND a.rent_l_cd NOT LIKE 'RM%' AND a.rent_l_cd NOT IN ('S113KNLM00003','S113HA4M00001') and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and c.cls_dt LIKE '"+s_dt+"%' and a.rent_start_dt < c.cls_dt \n"+
		          " union all \n"+
                  //미반차-신규
				  " SELECT '4' st, b.use_e_dt AS       dt, a.brch_id, a.use_yn, a.car_mng_id, a.client_id, a.rent_mng_id, a.rent_l_cd, a.rent_dt, b.use_s_dt rent_start_dt, b.use_e_dt rent_end_dt, '' con_mon, '' con_day, b.rent_st, c.cls_dt FROM cont a, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, min(use_s_dt) use_s_dt, max(use_e_dt) use_e_dt from scd_fee group by rent_mng_id, rent_l_cd) b, cls_cont c WHERE a.car_st='4' AND a.rent_l_cd NOT LIKE 'RM%' AND a.rent_l_cd NOT IN ('S113KNLM00003','S113HA4M00001') and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.use_e_dt LIKE '"+s_dt+"%' and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) and c.rent_l_cd is null \n"+
		          " union all \n";

        //미반차-진행 
		if(mode.equals("days")){
			b_query += " SELECT '5' st, '"+s_dt+"' AS   dt, a.brch_id, a.use_yn, a.car_mng_id, a.client_id, a.rent_mng_id, a.rent_l_cd, a.rent_dt, b.use_s_dt rent_start_dt, b.use_e_dt rent_end_dt, '' con_mon, '' con_day, b.rent_st, c.cls_dt FROM cont a, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, min(use_s_dt) use_s_dt, max(use_e_dt) use_e_dt from scd_fee group by rent_mng_id, rent_l_cd) b, cls_cont c WHERE a.car_st='4' AND a.rent_l_cd NOT LIKE 'RM%' AND a.rent_l_cd NOT IN ('S113KNLM00003','S113HA4M00001') and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.use_e_dt < to_char(sysdate,'YYYYMMDD') and substr(b.use_e_dt,1,8) < '"+s_dt+"' and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) and c.rent_l_cd is null \n";
		}else if(mode.equals("months")){
			b_query += " SELECT '5' st, '"+s_dt+"' AS   dt, a.brch_id, a.use_yn, a.car_mng_id, a.client_id, a.rent_mng_id, a.rent_l_cd, a.rent_dt, b.use_s_dt rent_start_dt, b.use_e_dt rent_end_dt, '' con_mon, '' con_day, b.rent_st, c.cls_dt FROM cont a, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, min(use_s_dt) use_s_dt, max(use_e_dt) use_e_dt from scd_fee group by rent_mng_id, rent_l_cd) b, cls_cont c WHERE a.car_st='4' AND a.rent_l_cd NOT LIKE 'RM%' AND a.rent_l_cd NOT IN ('S113KNLM00003','S113HA4M00001') and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.use_e_dt < to_char(sysdate,'YYYYMMDD') and substr(b.use_e_dt,1,6) < '"+s_dt+"' and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) and c.rent_l_cd is null \n";
		}else if(mode.equals("years")){
			b_query += " SELECT '5' st, '"+s_dt+"' AS   dt, a.brch_id, a.use_yn, a.car_mng_id, a.client_id, a.rent_mng_id, a.rent_l_cd, a.rent_dt, b.use_s_dt rent_start_dt, b.use_e_dt rent_end_dt, '' con_mon, '' con_day, b.rent_st, c.cls_dt FROM cont a, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, min(use_s_dt) use_s_dt, max(use_e_dt) use_e_dt from scd_fee group by rent_mng_id, rent_l_cd) b, cls_cont c WHERE a.car_st='4' AND a.rent_l_cd NOT LIKE 'RM%' AND a.rent_l_cd NOT IN ('S113KNLM00003','S113HA4M00001') and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.use_e_dt < to_char(sysdate,'YYYYMMDD') and substr(b.use_e_dt,1,4) < '"+s_dt+"' and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) and c.rent_l_cd is null \n";
		}

		String b_dt = "dt";

		if(mode.equals("months")){
			b_dt = "substr(dt,1,6)";	
		}else if(mode.equals("years")){
			b_dt = "substr(dt,1,4)";
		}

		
		query = " select "+b_dt+" as dt, \n"+
				"        COUNT(rent_l_cd) t_cnt, \n"+
				"        COUNT(DECODE(st,'1',rent_l_cd)) t_st1, \n"+
				"        COUNT(DECODE(st,'2',rent_l_cd)) t_st2, \n"+
				"        COUNT(DECODE(st,'3',rent_l_cd)) t_st3, \n"+
				"        COUNT(DECODE(st,'4',rent_l_cd)) t_st4, \n"+
				"        COUNT(DECODE(st,'5',rent_l_cd)) t_st5, \n"+
				"        COUNT(DECODE(st,'4',rent_l_cd,'5',rent_l_cd)) t_st6, \n"+
				"        COUNT(DECODE(st,'3',rent_l_cd,'4',rent_l_cd,'5',rent_l_cd)) t_st7 \n"+
				" ";

		query += " from   ("+b_query+") \n";	
		
		if(!s_br.equals(""))	query += " where brch_id='"+s_br+"' \n";	
		
		query += " GROUP BY "+b_dt+" \n"+
				 " ORDER BY "+b_dt+" \n"+
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
			System.out.println("[ResSearchDatabase:getRmRentStat1]"+e);
			System.out.println("[ResSearchDatabase:getRmRentStat1]"+query);
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
	 *	일일영업현황
	 */	

	public Vector getRmRentStat1SubList(String mode, String st, String s_dt, String s_br)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String b_query = "";

		 		
		//개시
		if(st.equals("1")){
			b_query = " SELECT '1' st, b.rent_start_dt AS  dt, a.brch_id, a.use_yn, a.car_mng_id, a.client_id, a.rent_mng_id, a.rent_l_cd, a.rent_dt, b.rent_start_dt, b.rent_end_dt, b.con_mon, d.con_day, b.rent_st, c.cls_dt FROM cont a, fee b, cls_cont c, fee_etc d WHERE a.car_st='4' AND a.rent_l_cd NOT LIKE 'RM%' AND a.rent_l_cd NOT IN ('S113KNLM00003','S113HA4M00001') and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_st='1' and b.rent_start_dt LIKE '"+s_dt+"%' and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) and b.rent_start_dt < nvl(c.cls_dt,b.rent_end_dt) and b.rent_mng_id=d.rent_mng_id and b.rent_l_cd=d.rent_l_cd and b.rent_st=d.rent_st \n";
		//연장계약
		}else if(st.equals("2")){
			b_query = " SELECT '2' st, b.rent_start_dt AS  dt, a.brch_id, a.use_yn, a.car_mng_id, a.client_id, a.rent_mng_id, a.rent_l_cd, b.rent_dt, b.rent_start_dt, b.rent_end_dt, b.con_mon, d.con_day, b.rent_st, c.cls_dt FROM cont a, fee b, cls_cont c, fee_etc d WHERE a.car_st='4' AND a.rent_l_cd NOT LIKE 'RM%' AND a.rent_l_cd NOT IN ('S113KNLM00003','S113HA4M00001') and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_st<>'1' and b.rent_start_dt LIKE '"+s_dt+"%' and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) and b.rent_start_dt < nvl(c.cls_dt,b.rent_end_dt) and b.rent_mng_id=d.rent_mng_id and b.rent_l_cd=d.rent_l_cd and b.rent_st=d.rent_st \n";
		//반차
		}else if(st.equals("3")){
			b_query = " SELECT '3' st, c.cls_dt AS         dt, a.brch_id, a.use_yn, a.car_mng_id, a.client_id, a.rent_mng_id, a.rent_l_cd, a.rent_dt, b.rent_start_dt, b.rent_end_dt, b.con_mon, '' con_day, '' rent_st, c.cls_dt FROM cont a, (select rent_mng_id, rent_l_cd, to_char(sum(con_mon)) con_mon, min(rent_start_dt) rent_start_dt, max(rent_end_dt) rent_end_dt from fee group by rent_mng_id, rent_l_cd) b, cls_cont c WHERE a.car_st='4' AND a.rent_l_cd NOT LIKE 'RM%' AND a.rent_l_cd NOT IN ('S113KNLM00003','S113HA4M00001') and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and c.cls_dt LIKE '"+s_dt+"%' and a.rent_start_dt < c.cls_dt \n";
		//미반차-신규
		}else if(st.equals("4")){
			b_query = " SELECT '4' st, b.use_e_dt AS       dt, a.brch_id, a.use_yn, a.car_mng_id, a.client_id, a.rent_mng_id, a.rent_l_cd, a.rent_dt, b.use_s_dt rent_start_dt, b.use_e_dt rent_end_dt, '' con_mon, '' con_day, b.rent_st, c.cls_dt FROM cont a, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, min(use_s_dt) use_s_dt, max(use_e_dt) use_e_dt from scd_fee group by rent_mng_id, rent_l_cd) b, cls_cont c WHERE a.car_st='4' AND a.rent_l_cd NOT LIKE 'RM%' AND a.rent_l_cd NOT IN ('S113KNLM00003','S113HA4M00001') and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.use_e_dt LIKE '"+s_dt+"%' and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) and c.rent_l_cd is null \n";
		//미반차-진행
		}else if(st.equals("5")){
			if(mode.equals("days")){
				b_query = " SELECT '5' st, '"+s_dt+"' AS   dt, a.brch_id, a.use_yn, a.car_mng_id, a.client_id, a.rent_mng_id, a.rent_l_cd, a.rent_dt, b.use_s_dt rent_start_dt, b.use_e_dt rent_end_dt, '' con_mon, '' con_day, b.rent_st, c.cls_dt FROM cont a, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, min(use_s_dt) use_s_dt, max(use_e_dt) use_e_dt from scd_fee group by rent_mng_id, rent_l_cd) b, cls_cont c WHERE a.car_st='4' AND a.rent_l_cd NOT LIKE 'RM%' AND a.rent_l_cd NOT IN ('S113KNLM00003','S113HA4M00001') and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.use_e_dt < to_char(sysdate,'YYYYMMDD') and substr(b.use_e_dt,1,8) < '"+s_dt+"' and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) and c.rent_l_cd is null \n";
			}else if(mode.equals("months")){
				b_query = " SELECT '5' st, '"+s_dt+"' AS   dt, a.brch_id, a.use_yn, a.car_mng_id, a.client_id, a.rent_mng_id, a.rent_l_cd, a.rent_dt, b.use_s_dt rent_start_dt, b.use_e_dt rent_end_dt, '' con_mon, '' con_day, b.rent_st, c.cls_dt FROM cont a, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, min(use_s_dt) use_s_dt, max(use_e_dt) use_e_dt from scd_fee group by rent_mng_id, rent_l_cd) b, cls_cont c WHERE a.car_st='4' AND a.rent_l_cd NOT LIKE 'RM%' AND a.rent_l_cd NOT IN ('S113KNLM00003','S113HA4M00001') and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.use_e_dt < to_char(sysdate,'YYYYMMDD') and substr(b.use_e_dt,1,6) < '"+s_dt+"' and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) and c.rent_l_cd is null \n";
			}else if(mode.equals("years")){
				b_query = " SELECT '5' st, '"+s_dt+"' AS   dt, a.brch_id, a.use_yn, a.car_mng_id, a.client_id, a.rent_mng_id, a.rent_l_cd, a.rent_dt, b.use_s_dt rent_start_dt, b.use_e_dt rent_end_dt, '' con_mon, '' con_day, b.rent_st, c.cls_dt FROM cont a, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, min(use_s_dt) use_s_dt, max(use_e_dt) use_e_dt from scd_fee group by rent_mng_id, rent_l_cd) b, cls_cont c WHERE a.car_st='4' AND a.rent_l_cd NOT LIKE 'RM%' AND a.rent_l_cd NOT IN ('S113KNLM00003','S113HA4M00001') and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.use_e_dt < to_char(sysdate,'YYYYMMDD') and substr(b.use_e_dt,1,4) < '"+s_dt+"' and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) and c.rent_l_cd is null \n";
			}
		}


		String b_dt = "a.dt";

		if(mode.equals("months")){
			b_dt = "substr(a.dt,1,6)";	
		}else if(mode.equals("years")){
			b_dt = "substr(a.dt,1,4)";
		}

		
		query = " select a.*, \n"+
				"        b.car_no, b.car_nm, c.firm_nm \n"+       
				" from   ("+b_query+") a, car_reg b, client c \n"+
				" where  a.car_mng_id=b.car_mng_id and a.client_id=c.client_id "+
				"";	
		
		if(!s_br.equals(""))	query += " and a.brch_id='"+s_br+"' \n";	
		
		query += " ORDER BY "+b_dt+", a.rent_end_dt, a.rent_mng_id \n"+
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
			System.out.println("[ResSearchDatabase:getRmRentStat1SubList]"+e);
			System.out.println("[ResSearchDatabase:getRmRentStat1SubList]"+query);
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
	 *	신규영업현황
	 */	
	public Vector getRmRentStat2List(String mode, String gubun4, String start_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String b_query = "";



		b_query = " \n"+
			      //신규계약
				  " SELECT '1' st, a.brch_id, a.client_id, a.car_mng_id, a.rent_mng_id, a.rent_l_cd, a.rent_st, a.rent_dt FROM cont a, fee b, cls_cont c WHERE a.car_st='4' AND a.rent_l_cd NOT LIKE 'RM%' AND a.rent_l_cd NOT IN ('S113KNLM00003','S113HA4M00001') and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_st='1' and b.rent_start_dt is not null and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) and b.rent_start_dt < nvl(c.cls_dt,b.rent_end_dt) \n"+
		          " union all \n"+
                  //연장계약
				  " SELECT '2' st, a.brch_id, a.client_id, a.car_mng_id, a.rent_mng_id, a.rent_l_cd, b.rent_st, b.rent_dt FROM cont a, fee b, cls_cont c WHERE a.car_st='4' AND a.rent_l_cd NOT LIKE 'RM%' AND a.rent_l_cd NOT IN ('S113KNLM00003','S113HA4M00001') and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_st<>'1' and b.rent_start_dt is not null and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) and b.rent_start_dt < nvl(c.cls_dt,b.rent_end_dt) \n"+
		          " ";

		query = " select a.brch_id, decode(b.car_kd,'3','1', '9','1', '2','2', '1','3', '4') car_kd, decode(decode(b.car_kd,'3','1', '9','1', '2','2', '1','3', '4'),'1','소형', '2','중형', '3','대형', '기타') car_kd_nm, \n"+
				"        count(decode(a.st,'1',a.rent_l_cd)) cnt1,  \n"+
				"        sum  (decode(a.st,'1',e.pay_fee))   amt1_1,  \n"+
				"        sum  (decode(a.st,'1',e.dly_fee))   amt1_2,  \n"+
				"        sum  (decode(a.st,'1',e.pay_fee+e.dly_fee)) amt1,  \n"+
				"        count(decode(a.st,'2',a.rent_l_cd)) cnt2,  \n"+
				"        sum  (decode(a.st,'2',e.pay_fee))  amt2_1,  \n"+
				"        sum  (decode(a.st,'2',e.dly_fee))  amt2_2,  \n"+
				"        sum  (decode(a.st,'2',e.pay_fee+e.dly_fee)) amt2  \n"+
				" from   ("+b_query+") a, car_reg b, client c, \n"+
				"        ( select a.rent_mng_id, a.rent_l_cd, a.rent_st, "+
				"                 sum(decode(a.rc_dt,'',a.fee_s_amt)) dly_fee, sum(decode(a.rc_dt,'',0,a.fee_s_amt)) pay_fee "+
				"          from   scd_fee a, cont b "+
				"	       where  b.car_st='4' AND b.rent_l_cd NOT LIKE 'RM%' AND b.rent_l_cd NOT IN ('S113KNLM00003','S113HA4M00001') "+
				"                 and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd "+
				"                 and nvl(a.bill_yn,'Y')='Y' "+
				"          group by a.rent_mng_id, a.rent_l_cd, a.rent_st "+
				"        ) e \n"+
				" where  a.car_mng_id=b.car_mng_id and a.client_id=c.client_id "+
				"        and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+) and a.rent_st=e.rent_st(+)  \n"+
				"";	

		if(!mode.equals(""))	query += " and a.brch_id='"+mode+"' \n";	

		String dt1 = "a.rent_dt";
		
		if(gubun4.equals("1"))			query += " and "+dt1+" like to_char(sysdate,'YYYYMM')||'%'";
		if(gubun4.equals("2"))			query += " and "+dt1+" like to_char(sysdate,'YYYYMMDD')||'%'";
		if(gubun4.equals("4"))			query += " and "+dt1+" like to_char(sysdate-1,'YYYYMMDD')||'%'";
		if(gubun4.equals("5"))			query += " and "+dt1+" like to_char(to_date(to_char(sysdate,'YYYYMM'),'YYYYMM')-1,'YYYYMM')||'%'";
		if(gubun4.equals("3")){	
			if(!start_dt.equals("") && end_dt.equals(""))		query += " and "+dt1+" like replace('"+start_dt+"%', '-','')";
			if(!start_dt.equals("") && !end_dt.equals(""))		query += " and "+dt1+" between replace('"+start_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		query += " GROUP BY a.brch_id, decode(b.car_kd,'3','1', '9','1', '2','2', '1','3', '4') \n"+
				 " ";				
		
		query += " ORDER BY a.brch_id, decode(b.car_kd,'3','1', '9','1', '2','2', '1','3', '4') \n"+
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
			System.out.println("[ResSearchDatabase:getRmRentStat2List]"+e);
			System.out.println("[ResSearchDatabase:getRmRentStat2List]"+query);
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
	 *	신규영업현황 세부리스트
	 */	
	public Vector getRmRentStat2SubList(String gubun4, String start_dt, String end_dt, String s_br, String car_kd, String st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String b_query = "";

		 		
		//신규계약
		if(st.equals("1")){
			b_query = " SELECT '1' st, a.brch_id, a.client_id, a.use_yn, a.car_mng_id, a.rent_mng_id, a.rent_l_cd, a.rent_st, a.rent_dt, b.con_mon, d.con_day FROM cont a, fee b, cls_cont c, fee_etc d WHERE a.car_st='4' AND a.rent_l_cd NOT LIKE 'RM%' AND a.rent_l_cd NOT IN ('S113KNLM00003','S113HA4M00001') and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_st='1' and b.rent_start_dt is not null and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) and b.rent_start_dt < nvl(c.cls_dt,b.rent_end_dt) and b.rent_mng_id=d.rent_mng_id and b.rent_l_cd=d.rent_l_cd and b.rent_st=d.rent_st \n";

			if(!s_br.equals(""))	b_query += " and a.brch_id='"+s_br+"' \n";	

		//연장계약
		}else if(st.equals("2")){
			b_query = " SELECT '2' st, a.brch_id, a.client_id, a.use_yn, a.car_mng_id, a.rent_mng_id, a.rent_l_cd, a.rent_st, a.rent_dt, b.con_mon, d.con_day FROM cont a, fee b, cls_cont c, fee_etc d WHERE a.car_st='4' AND a.rent_l_cd NOT LIKE 'RM%' AND a.rent_l_cd NOT IN ('S113KNLM00003','S113HA4M00001') and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_st<>'1' and b.rent_start_dt is not null and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) and b.rent_start_dt < nvl(c.cls_dt,b.rent_end_dt) and b.rent_mng_id=d.rent_mng_id and b.rent_l_cd=d.rent_l_cd and b.rent_st=d.rent_st \n";

			if(!s_br.equals(""))	b_query += " and a.brch_id='"+s_br+"' \n";	

		}



		query = " select a.*, \n"+
				"        e.dly_fee, "+
				"        e.pay_fee, "+
				"        b.car_no, b.car_nm, c.firm_nm \n"+     
				" from   ("+b_query+") a, car_reg b, client c, \n"+
				"        ( select a.rent_mng_id, a.rent_l_cd, a.rent_st, "+
				"                 sum(decode(a.rc_dt,'',a.fee_s_amt)) dly_fee, sum(decode(a.rc_dt,'',0,a.fee_s_amt)) pay_fee "+
				"          from   scd_fee a, cont b "+
				"	       where  b.car_st='4' AND b.rent_l_cd NOT LIKE 'RM%' AND b.rent_l_cd NOT IN ('S113KNLM00003','S113HA4M00001') "+
				"                 and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd "+
				"                 and nvl(a.bill_yn,'Y')='Y' "+
				"          group by a.rent_mng_id, a.rent_l_cd, a.rent_st "+
				"        ) e \n"+
				" where  a.car_mng_id=b.car_mng_id and a.client_id=c.client_id \n"+
				"        and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+) and a.rent_st=e.rent_st(+)  \n"+
				"";	

		if(!car_kd.equals(""))	query += " and decode(b.car_kd,'3','1', '9','1', '2','2', '1','3', '4')='"+car_kd+"' \n";	

		String dt1 = "a.rent_dt";
		
		if(gubun4.equals("1"))			query += " and "+dt1+" like to_char(sysdate,'YYYYMM')||'%'";
		if(gubun4.equals("2"))			query += " and "+dt1+" like to_char(sysdate,'YYYYMMDD')||'%'";
		if(gubun4.equals("4"))			query += " and "+dt1+" like to_char(sysdate-1,'YYYYMMDD')||'%'";
		if(gubun4.equals("5"))			query += " and "+dt1+" like to_char(to_date(to_char(sysdate,'YYYYMM'),'YYYYMM')-1,'YYYYMM')||'%'";
		if(gubun4.equals("3")){	
			if(!start_dt.equals("") && end_dt.equals(""))		query += " and "+dt1+" like replace('"+start_dt+"%', '-','')";
			if(!start_dt.equals("") && !end_dt.equals(""))		query += " and "+dt1+" between replace('"+start_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

					
		
		query += " ORDER BY a.rent_dt, a.rent_mng_id \n"+
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
			System.out.println("[ResSearchDatabase:getRmRentStat2SubList]"+e);
			System.out.println("[ResSearchDatabase:getRmRentStat2SubList]"+query);
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
	 *	영업유지현황
	 */	
	public Vector getRmRentStat3List(String mode, String gubun4, String start_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String b_query = "";


		b_query = " \n"+
				  " SELECT '1' st, brch_id, client_id, car_mng_id, rent_mng_id, rent_l_cd FROM cont a WHERE a.car_st='4' AND a.rent_l_cd NOT LIKE 'RM%' AND a.rent_l_cd NOT IN ('S113KNLM00003','S113HA4M00001') and use_yn='Y' and rent_start_dt is not null \n"+
		          " ";

		if(!mode.equals(""))	b_query += " and brch_id='"+mode+"' \n";	


		query = " select a.brch_id, decode(b.car_kd,'3','1', '9','1', '2','2', '1','3', '4') car_kd, decode(decode(b.car_kd,'3','1', '9','1', '2','2', '1','3', '4'),'1','소형', '2','중형', '3','대형', '기타') car_kd_nm, \n"+
				"        count(a.rent_l_cd) cnt1,  \n"+
				"        sum(e.est_fee) amt0,  \n"+
				"        sum(e.pay_fee) amt1_1,  \n"+
				"        sum(e.dly_fee) amt1_2,  \n"+
				"        sum(e.pay_fee+e.dly_fee) amt1 \n"+
				" from   ("+b_query+") a, car_reg b, client c, \n"+
		        "        (select a.rent_mng_id, a.rent_l_cd, "+
				"                sum(a.fee_s_amt) est_fee, "+							//계약고
				"                sum(decode(a.rc_dt,'',a.fee_s_amt)) dly_fee, "+		//미도래+미입금
				"                sum(decode(a.rc_dt,'',0,decode(substr(a.rc_dt,1,6),to_char(sysdate,'YYYYMM'),a.fee_s_amt))) pay_fee \n"+	//매출(입금분)->당월분
				"         from   scd_fee a, cont b \n"+
				"	      where  b.car_st='4' AND b.rent_l_cd NOT LIKE 'RM%' AND b.rent_l_cd NOT IN ('S113KNLM00003','S113HA4M00001') "+
				"	             and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.fee_s_amt<>0 and nvl(a.bill_yn,'Y')='Y' and a.tm_st1='0' \n"+
				"         group by a.rent_mng_id, a.rent_l_cd) e \n"+
				" where  a.car_mng_id=b.car_mng_id and a.client_id=c.client_id \n"+
				"        and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+) \n"+
				"";	



		query += " GROUP BY a.brch_id, decode(b.car_kd,'3','1', '9','1', '2','2', '1','3', '4') \n"+
				 " ";				
		
		query += " ORDER BY a.brch_id, decode(b.car_kd,'3','1', '9','1', '2','2', '1','3', '4') \n"+
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
			System.out.println("[ResSearchDatabase:getRmRentStat3List]"+e);
			System.out.println("[ResSearchDatabase:getRmRentStat3List]"+query);
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
	 *	영업유지현황 세부리스트
	 */	
	public Vector getRmRentStat3SubList(String s_br, String car_kd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String b_query = "";

		 		
		b_query = " \n"+
				  " SELECT '1' st, a.brch_id, a.client_id, a.car_mng_id, a.rent_mng_id, a.rent_l_cd, a.rent_dt FROM cont a WHERE a.car_st='4' AND a.rent_l_cd NOT LIKE 'RM%' AND a.rent_l_cd NOT IN ('S113KNLM00003','S113HA4M00001') and a.use_yn='Y' and a.rent_start_dt is not null \n"+
		          " ";

		if(!s_br.equals(""))	b_query += " and brch_id='"+s_br+"' \n";	




		query = " select a.*, \n"+
				"        f.con_mon, g.con_day, d.ext_months, d.ext_days, \n"+
				"        decode( sign(to_date(e.use_e_dt, 'YYYYMMDD') - to_date(f.rent_start_dt, 'YYYYMMDD')), -1, '0', trunc(months_between(to_date(e.use_e_dt, 'YYYYMMDD')+1, to_date(f.rent_start_dt, 'YYYYMMDD')))) u_mon, \n"+
				"        decode( sign(to_date(e.use_e_dt, 'YYYYMMDD') - to_date(f.rent_start_dt, 'YYYYMMDD')), -1, '0', trunc(to_date(e.use_e_dt, 'YYYYMMDD')+1-add_months(to_date(f.rent_start_dt, 'YYYYMMDD'), trunc(months_between(to_date(e.use_e_dt, 'YYYYMMDD')+1, to_date(f.rent_start_dt, 'YYYYMMDD')))))) u_day, \n"+
				"        trunc(sysdate-TO_DATE(SUBSTR(e.use_e_dt,1,8),'YYYYMMDD')) add_day, "+
				"        e.est_fee, e.dly_fee, e.pay_fee, e.use_e_dt, e.use_s_dt, \n"+
				"        b.car_no, b.car_nm, c.firm_nm \n"+     
				" from   ("+b_query+") a, car_reg b, client c, \n"+
				"        fee f, fee_etc g, \n"+
				"        (select a.rent_mng_id, a.rent_l_cd, sum(a.con_mon) ext_months, sum(b.con_day) ext_days from fee a, fee_etc b where a.rent_st<>'1' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st group by a.rent_mng_id, a.rent_l_cd) d, \n"+
		        "        (select a.rent_mng_id, a.rent_l_cd, min(use_s_dt) use_s_dt, max(use_e_dt) use_e_dt, "+
				"                sum(a.fee_s_amt) est_fee, "+							//계약고
				"                sum(decode(a.rc_dt,'',a.fee_s_amt)) dly_fee, "+		//미도래+미입금
				"                sum(decode(a.rc_dt,'',0,decode(substr(a.rc_dt,1,6),to_char(sysdate,'YYYYMM'),a.fee_s_amt))) pay_fee \n"+	//매출(입금분)->당월분
				"         from   scd_fee a, cont b \n"+
				"	      where  b.car_st='4' AND b.rent_l_cd NOT LIKE 'RM%' AND b.rent_l_cd NOT IN ('S113KNLM00003','S113HA4M00001') "+
				"	             and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.fee_s_amt<>0 and nvl(a.bill_yn,'Y')='Y' \n"+
				"         group by a.rent_mng_id, a.rent_l_cd) e \n"+
				" where  a.car_mng_id=b.car_mng_id and a.client_id=c.client_id \n"+
				"        and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd and f.rent_st='1' "+
				"        and f.rent_mng_id=g.rent_mng_id and f.rent_l_cd=g.rent_l_cd and f.rent_st=g.rent_st "+
				"        and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+) "+
				"	     and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+) \n"+
				"";	

		if(!car_kd.equals(""))	query += " and decode(b.car_kd,'3','1', '9','1', '2','2', '1','3', '4')='"+car_kd+"' \n";	
					
		
		query += " ORDER BY a.rent_dt, a.rent_dt \n"+
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
			System.out.println("[ResSearchDatabase:getRmRentStat3SubList]"+e);
			System.out.println("[ResSearchDatabase:getRmRentStat3SubList]"+query);
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
	 *	계약종료관리
	 */	
	public Vector getRmRentStat4List(String mode, String gubun4, String start_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String b_query = "";


		b_query = " \n"+
			      //반차완료-중도해지
				  " SELECT '1' st, a.brch_id, a.client_id, a.car_mng_id, a.rent_mng_id, a.rent_l_cd, '2' cls_st, c.cls_dt FROM cont a, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, min(use_s_dt) use_s_dt, max(use_e_dt) use_e_dt from scd_fee group by rent_mng_id, rent_l_cd) b, cls_cont c WHERE a.car_st='4' AND a.rent_l_cd NOT LIKE 'RM%' AND a.rent_l_cd NOT IN ('S113KNLM00003','S113HA4M00001') and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and b.use_e_dt > c.cls_dt \n"+
		          " union all \n"+
			      //반차완료-만기해지
				  " SELECT '1' st, a.brch_id, a.client_id, a.car_mng_id, a.rent_mng_id, a.rent_l_cd, '1' cls_st, c.cls_dt FROM cont a, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, min(use_s_dt) use_s_dt, max(use_e_dt) use_e_dt from scd_fee group by rent_mng_id, rent_l_cd) b, cls_cont c WHERE a.car_st='4' AND a.rent_l_cd NOT LIKE 'RM%' AND a.rent_l_cd NOT IN ('S113KNLM00003','S113HA4M00001') and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and b.use_e_dt <= c.cls_dt \n"+
		          " union all \n"+
                  //미반차
				  " SELECT '2' st, a.brch_id, a.client_id, a.car_mng_id, a.rent_mng_id, a.rent_l_cd, '' cls_st, b.use_e_dt as cls_dt FROM cont a, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, min(use_s_dt) use_s_dt, max(use_e_dt) use_e_dt from scd_fee group by rent_mng_id, rent_l_cd) b, cls_cont c WHERE a.car_st='4' AND a.rent_l_cd NOT LIKE 'RM%' AND a.rent_l_cd NOT IN ('S113KNLM00003','S113HA4M00001') and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) and c.rent_l_cd is null and b.use_s_dt < nvl(c.cls_dt,b.use_e_dt) \n"+
		          " ";

		query = " select a.brch_id, decode(b.car_kd,'3','1', '9','1', '2','2', '1','3', '4') car_kd, decode(decode(b.car_kd,'3','1', '9','1', '2','2', '1','3', '4'),'1','소형', '2','중형', '3','대형', '기타') car_kd_nm, \n"+
				"        count(decode(a.st,'1',decode(a.cls_st,'2',a.rent_l_cd))) cnt1,  \n"+
				"        count(decode(a.st,'1',decode(a.cls_st,'1',a.rent_l_cd))) cnt2,  \n"+
				"        count(decode(a.st,'2',a.rent_l_cd)) cnt3  \n"+
				" from   ("+b_query+") a, car_reg b, client c, \n"+
				"        (select a.rent_mng_id, a.rent_l_cd, min(rent_start_dt) rent_start_dt, sum(a.con_mon) ext_months, sum(b.con_day) ext_days from fee a, fee_etc b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st group by a.rent_mng_id, a.rent_l_cd) d, \n"+
		        "        (select a.rent_mng_id, a.rent_l_cd, min(use_s_dt) use_s_dt, max(use_e_dt) use_e_dt, "+
				"                sum(a.fee_s_amt) est_fee, "+							//계약고
				"                sum(decode(a.rc_dt,'',a.fee_s_amt)) dly_fee, "+		//미도래+미입금
				"                sum(decode(a.rc_dt,'',0,decode(substr(a.rc_dt,1,6),to_char(sysdate,'YYYYMM'),a.fee_s_amt))) pay_fee \n"+	//매출(입금분)->당월분
				"         from   scd_fee a, cont b \n"+
				"	      where  b.car_st='4' AND b.rent_l_cd NOT LIKE 'RM%' AND b.rent_l_cd NOT IN ('S113KNLM00003','S113HA4M00001') "+
				"	             and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.fee_s_amt<>0 and nvl(a.bill_yn,'Y')='Y' \n"+
				"         group by a.rent_mng_id, a.rent_l_cd) e \n"+
				" where  a.car_mng_id=b.car_mng_id and a.client_id=c.client_id \n"+
				"        and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd "+
				"	     and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd \n"+
				"";	

		if(!mode.equals(""))	query += " and a.brch_id='"+mode+"' \n";	

		String dt1 = "a.cls_dt";
		
		if(gubun4.equals("1"))			query += " and "+dt1+" like to_char(sysdate,'YYYYMM')||'%'";
		if(gubun4.equals("2"))			query += " and "+dt1+" like to_char(sysdate,'YYYYMMDD')||'%'";
		if(gubun4.equals("4"))			query += " and "+dt1+" like to_char(sysdate-1,'YYYYMMDD')||'%'";
		if(gubun4.equals("5"))			query += " and "+dt1+" like to_char(to_date(to_char(sysdate,'YYYYMM'),'YYYYMM')-1,'YYYYMM')||'%'";
		if(gubun4.equals("3")){	
			if(!start_dt.equals("") && end_dt.equals(""))		query += " and "+dt1+" like replace('"+start_dt+"%', '-','')";
			if(!start_dt.equals("") && !end_dt.equals(""))		query += " and "+dt1+" between replace('"+start_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		query += " GROUP BY a.brch_id, decode(b.car_kd,'3','1', '9','1', '2','2', '1','3', '4') \n"+
				 " ";				
		
		query += " ORDER BY a.brch_id, decode(b.car_kd,'3','1', '9','1', '2','2', '1','3', '4') \n"+
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
			System.out.println("[ResSearchDatabase:getRmRentStat4List]"+e);
			System.out.println("[ResSearchDatabase:getRmRentStat4List]"+query);
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
	 *	계약종료관리 세부리스트
	 */	
	public Vector getRmRentStat4SubList(String gubun4, String start_dt, String end_dt, String s_br, String car_kd, String st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String b_query = "";

		 		
		//중도해지
		if(st.equals("1")){
			b_query = " SELECT '1' st, a.brch_id, a.client_id, a.car_mng_id, a.rent_mng_id, a.rent_l_cd, '2' cls_st, c.cls_dt FROM cont a, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, min(use_s_dt) use_s_dt, max(use_e_dt) use_e_dt from scd_fee group by rent_mng_id, rent_l_cd) b, cls_cont c WHERE a.car_st='4' AND a.rent_l_cd NOT LIKE 'RM%' AND a.rent_l_cd NOT IN ('S113KNLM00003','S113HA4M00001') and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and b.use_e_dt > c.cls_dt \n";

			if(!s_br.equals(""))	b_query += " and a.brch_id='"+s_br+"' \n";	

		//만기해지
		}else if(st.equals("2")){
			b_query = " SELECT '2' st, a.brch_id, a.client_id, a.car_mng_id, a.rent_mng_id, a.rent_l_cd, '1' cls_st, c.cls_dt FROM cont a, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, min(use_s_dt) use_s_dt, max(use_e_dt) use_e_dt from scd_fee group by rent_mng_id, rent_l_cd) b, cls_cont c WHERE a.car_st='4' AND a.rent_l_cd NOT LIKE 'RM%' AND a.rent_l_cd NOT IN ('S113KNLM00003','S113HA4M00001') and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and b.use_e_dt <= c.cls_dt \n";

			if(!s_br.equals(""))	b_query += " and a.brch_id='"+s_br+"' \n";	

		//미반차
		}else if(st.equals("3")){
			b_query = " SELECT '3' st, a.brch_id, a.client_id, a.car_mng_id, a.rent_mng_id, a.rent_l_cd, '' cls_st, b.use_e_dt as cls_dt FROM cont a, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, min(use_s_dt) use_s_dt, max(use_e_dt) use_e_dt from scd_fee group by rent_mng_id, rent_l_cd) b, cls_cont c WHERE a.car_st='4' AND a.rent_l_cd NOT LIKE 'RM%' AND a.rent_l_cd NOT IN ('S113KNLM00003','S113HA4M00001') and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) and c.rent_l_cd is null and b.use_s_dt < nvl(c.cls_dt,b.use_e_dt) \n";

			if(!s_br.equals(""))	b_query += " and a.brch_id='"+s_br+"' \n";	
		}



		query = " select a.*, \n"+
				"        d.rent_start_dt, d.ext_months, d.ext_days, \n"+
				"        decode( sign(to_date(a.cls_dt, 'YYYYMMDD') - to_date(d.rent_start_dt, 'YYYYMMDD')), -1, '0', trunc(months_between(to_date(a.cls_dt, 'YYYYMMDD')+1, to_date(d.rent_start_dt, 'YYYYMMDD')))) u_mon, \n"+
				"        decode( sign(to_date(a.cls_dt, 'YYYYMMDD') - to_date(d.rent_start_dt, 'YYYYMMDD')), -1, '0', trunc(to_date(a.cls_dt, 'YYYYMMDD')+1-add_months(to_date(d.rent_start_dt, 'YYYYMMDD'), trunc(months_between(to_date(a.cls_dt, 'YYYYMMDD')+1, to_date(d.rent_start_dt, 'YYYYMMDD')))))) u_day, \n"+
				"        e.dly_fee, e.pay_fee, \n"+
				"        b.car_no, b.car_nm, c.firm_nm \n"+     
				" from   ("+b_query+") a, car_reg b, client c, \n"+
				"        (select a.rent_mng_id, a.rent_l_cd, min(rent_start_dt) rent_start_dt, sum(a.con_mon) ext_months, sum(b.con_day) ext_days from fee a, fee_etc b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st group by a.rent_mng_id, a.rent_l_cd) d, \n"+
		        "        (select a.rent_mng_id, a.rent_l_cd, min(use_s_dt) use_s_dt, max(use_e_dt) use_e_dt, "+
				"                sum(a.fee_s_amt) est_fee, "+							//계약고
				"                sum(decode(a.rc_dt,'',a.fee_s_amt)) dly_fee, "+		//미도래+미입금
				"                sum(decode(a.rc_dt,'',0,decode(substr(a.rc_dt,1,6),to_char(sysdate,'YYYYMM'),a.fee_s_amt))) pay_fee \n"+	//매출(입금분)->당월분
				"         from   scd_fee a, cont b \n"+
				"	      where  b.car_st='4' AND b.rent_l_cd NOT LIKE 'RM%' AND b.rent_l_cd NOT IN ('S113KNLM00003','S113HA4M00001') "+
				"	             and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.fee_s_amt<>0 and nvl(a.bill_yn,'Y')='Y' \n"+
				"         group by a.rent_mng_id, a.rent_l_cd) e \n"+
				" where  a.car_mng_id=b.car_mng_id and a.client_id=c.client_id \n"+
				"        and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd "+
				"	     and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd \n"+
				"";	

		if(!car_kd.equals(""))	query += " and decode(b.car_kd,'3','1', '9','1', '2','2', '1','3', '4')='"+car_kd+"' \n";	

		String dt1 = "a.cls_dt";
		
		if(gubun4.equals("1"))			query += " and "+dt1+" like to_char(sysdate,'YYYYMM')||'%'";
		if(gubun4.equals("2"))			query += " and "+dt1+" like to_char(sysdate,'YYYYMMDD')||'%'";
		if(gubun4.equals("4"))			query += " and "+dt1+" like to_char(sysdate-1,'YYYYMMDD')||'%'";
		if(gubun4.equals("5"))			query += " and "+dt1+" like to_char(to_date(to_char(sysdate,'YYYYMM'),'YYYYMM')-1,'YYYYMM')||'%'";
		if(gubun4.equals("3")){	
			if(!start_dt.equals("") && end_dt.equals(""))		query += " and "+dt1+" like replace('"+start_dt+"%', '-','')";
			if(!start_dt.equals("") && !end_dt.equals(""))		query += " and "+dt1+" between replace('"+start_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

					
		
		query += " ORDER BY a.cls_dt, a.rent_mng_id \n"+
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
			System.out.println("[ResSearchDatabase:getRmRentStat4SubList]"+e);
			System.out.println("[ResSearchDatabase:getRmRentStat4SubList]"+query);
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
	 *	연체대여료
	 */	
	public Hashtable getRmRentStat5List(String mode, String s_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		String b_query = "";

		 		
		b_query = " \n"+
			      //수금예정
				  " SELECT '1' st, a.rent_mng_id, a.rent_l_cd, b.fee_est_dt as est_dt, b.rc_dt as pay_dt, b.r_fee_est_dt AS dt, (b.fee_s_amt+b.fee_v_amt) amt FROM cont a, SCD_fee b WHERE a.car_st='4' AND a.rent_l_cd NOT LIKE 'RM%' AND a.rent_l_cd NOT IN ('S113KNLM00003','S113HA4M00001') and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.r_fee_est_dt='"+s_dt+"' AND NVL(b.bill_yn,'Y')='Y' AND b.fee_s_amt>0 \n"+//AND b.rc_dt IS NULL 
                  
				  " UNION all \n"+
			      //수금대여료
				  " SELECT '2' st, a.rent_mng_id, a.rent_l_cd, b.fee_est_dt as est_dt, b.rc_dt as pay_dt, b.rc_dt AS dt, b.rc_amt as amt FROM cont a, SCD_fee b WHERE a.car_st='4' AND a.rent_l_cd NOT LIKE 'RM%' AND a.rent_l_cd NOT IN ('S113KNLM00003','S113HA4M00001') and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rc_dt='"+s_dt+"' AND NVL(b.bill_yn,'Y')='Y' AND b.fee_s_amt>0 \n"+

				  " UNION all \n"+
			      //신규연체대여료
				  " SELECT '3' st, a.rent_mng_id, a.rent_l_cd, b.fee_est_dt as est_dt, b.rc_dt as pay_dt, '"+s_dt+"' AS dt, (b.fee_s_amt+b.fee_v_amt) amt FROM cont a, SCD_fee b WHERE a.car_st='4' AND a.rent_l_cd NOT LIKE 'RM%' AND a.rent_l_cd NOT IN ('S113KNLM00003','S113HA4M00001') and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.r_fee_est_dt < to_char(sysdate,'YYYYMMDD') and  b.r_fee_est_dt = To_CHAR(TO_DATE('"+s_dt+"' ,'YYYYMMDD')-1, 'YYYYMMDD')    AND (b.rc_dt IS NULL OR b.rc_dt > '"+s_dt+"') AND NVL(b.bill_yn,'Y')='Y' AND b.fee_s_amt>0 \n"+

				  " UNION all \n"+
			      //누적연체대여료
				  " SELECT '4' st, a.rent_mng_id, a.rent_l_cd, b.fee_est_dt as est_dt, b.rc_dt as pay_dt, '"+s_dt+"' AS dt, (b.fee_s_amt+b.fee_v_amt) amt FROM cont a, SCD_fee b WHERE a.car_st='4' AND a.rent_l_cd NOT LIKE 'RM%' AND a.rent_l_cd NOT IN ('S113KNLM00003','S113HA4M00001') and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.r_fee_est_dt < to_char(sysdate,'YYYYMMDD') and  b.r_fee_est_dt  <  To_CHAR(TO_DATE('"+s_dt+"' ,'YYYYMMDD')-1, 'YYYYMMDD')  AND (b.rc_dt IS NULL OR b.rc_dt > '"+s_dt+"') and b.r_fee_est_dt<>to_char(sysdate,'YYYYMMDD') AND NVL(b.bill_yn,'Y')='Y' AND b.fee_s_amt>0 \n"+

//				  " UNION all \n"+
			      //신규연체대여료 미청구분
//				  " SELECT '5' st, a.rent_s_cd, '' est_dt, '' pay_dt, '"+s_dt+"' AS dt, (b.inv_s_amt+b.inv_v_amt+b.navi_s_amt+b.navi_v_amt+b.etc_s_amt+b.etc_v_amt-b.dc_s_amt-b.dc_v_amt) amt FROM RENT_CONT a, RENT_FEE b WHERE a.rent_st='12' AND a.use_st<>'5' AND a.deli_dt IS NOT NULL AND a.ret_dt IS NULL AND SUBSTR(a.ret_plan_dt,1,8) < to_char(sysdate,'YYYYMMDD') AND SUBSTR(a.ret_plan_dt,1,8) < '"+s_dt+"' AND TO_CHAR(TO_DATE(SUBSTR(a.ret_plan_dt,1,8),'YYYYMMDD')+1,'YYYYMMDD')='"+s_dt+"' AND a.rent_s_cd=b.rent_s_cd   \n"+

//				  " UNION all \n"+
			      //누적연체대여료 미청구분
//				  " SELECT '6' st, a.rent_s_cd, '' est_dt, '' pay_dt, '"+s_dt+"' AS dt, (b.inv_s_amt+b.inv_v_amt+b.navi_s_amt+b.navi_v_amt+b.etc_s_amt+b.etc_v_amt-b.dc_s_amt-b.dc_v_amt) amt FROM RENT_CONT a, RENT_FEE b WHERE a.rent_st='12' AND a.use_st<>'5' AND a.deli_dt IS NOT NULL AND a.ret_dt IS NULL AND SUBSTR(a.ret_plan_dt,1,8) < to_char(sysdate,'YYYYMMDD') AND SUBSTR(a.ret_plan_dt,1,8) < '"+s_dt+"' AND TO_CHAR(TO_DATE(SUBSTR(a.ret_plan_dt,1,8),'YYYYMMDD')+1,'YYYYMMDD')<'"+s_dt+"' and TO_CHAR(TO_DATE(SUBSTR(a.ret_plan_dt,1,8),'YYYYMMDD')+1,'YYYYMMDD')<>to_char(sysdate,'YYYYMMDD') AND a.rent_s_cd=b.rent_s_cd   \n"+

				  " UNION all \n"+
			      //연체율계산 받을어음
				  " SELECT '7' st, a.rent_mng_id, a.rent_l_cd, b.fee_est_dt as est_dt, b.rc_dt as pay_dt, '"+s_dt+"' AS dt, decode(b.rc_dt,'',b.fee_s_amt+b.fee_v_amt,b.rc_amt) amt FROM cont a, SCD_fee b WHERE a.car_st='4' AND a.rent_l_cd NOT LIKE 'RM%' AND a.rent_l_cd NOT IN ('S113KNLM00003','S113HA4M00001') and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and (b.rc_dt IS NULL OR b.rc_dt > '"+s_dt+"') AND NVL(b.bill_yn,'Y')='Y' AND b.fee_s_amt>0 \n"+
				  "  \n";


		String b_dt = "a.dt";

		
		query = " select "+b_dt+" as dt, \n"+
				"        COUNT    (DECODE(a.st,'1',a.rent_l_cd)) cnt1,  \n"+
				"        nvl(SUM  (DECODE(a.st,'1',a.amt)),0) amt1, \n"+
				"        COUNT    (DECODE(a.st,'2',a.rent_l_cd)) cnt2,  \n"+
				"        nvl(SUM  (DECODE(a.st,'2',a.amt)),0) amt2, \n"+
				"        COUNT    (DECODE(a.st,'3',a.rent_l_cd)) cnt3,  \n"+
				"        nvl(SUM  (DECODE(a.st,'3',a.amt)),0) amt3, \n"+
				"        COUNT    (DECODE(a.st,'4',a.rent_l_cd)) cnt4,  \n"+
				"        nvl(SUM  (DECODE(a.st,'4',a.amt)),0) amt4,  \n"+
				"        COUNT    (DECODE(a.st,'5',a.rent_l_cd)) cnt5,  \n"+
				"        nvl(SUM  (DECODE(a.st,'5',a.amt)),0) amt5, \n"+
				"        COUNT    (DECODE(a.st,'6',a.rent_l_cd)) cnt6,  \n"+
				"        nvl(SUM  (DECODE(a.st,'6',a.amt)),0) amt6,  \n"+
				"        COUNT    (DECODE(a.st,'7',a.rent_l_cd)) cnt7,  \n"+
				"        nvl(SUM  (DECODE(a.st,'7',a.amt)),0) amt7,      \n"+           
                "        decode(  nvl(SUM  (DECODE(a.st,'3',a.amt)),0)+nvl(SUM  (DECODE(a.st,'4',a.amt)),0), 0, 0.00, "+
				"                  TO_CHAR  ( \n"+
                "					(nvl(SUM  (DECODE(a.st,'3',a.amt)),0)+nvl(SUM  (DECODE(a.st,'4',a.amt)),0)+nvl(SUM  (DECODE(a.st,'5',a.amt)),0)+nvl(SUM  (DECODE(a.st,'6',a.amt)),0))   \n"+
                "                    /  \n"+
                "                   (nvl(SUM  (DECODE(a.st,'7',a.amt)),0)+nvl(SUM  (DECODE(a.st,'5',a.amt)),0)+nvl(SUM  (DECODE(a.st,'6',a.amt)),0))  \n"+
                "                    * 100 \n"+
                "                , '9999.99')) dly_per   \n"+
				" ";

		query += " from   ("+b_query+") a \n";	
						
		query += " GROUP BY "+b_dt+" \n"+
				 " ORDER BY "+b_dt+" \n"+
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
			System.out.println("[ResSearchDatabase:getRmRentStat5]"+e);
			System.out.println("[ResSearchDatabase:getRmRentStat5]"+query);
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
	 *	연체대여료
	 */	
	public Vector getRmRentStat5SubList(String mode, String st, String s_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String b_query = "";

		 		

		if(st.equals("1")){
			b_query = " SELECT '1' st, a.car_mng_id, a.client_id, a.rent_mng_id, a.rent_l_cd, a.mng_id, b.fee_est_dt as est_dt, b.rc_dt as pay_dt, b.fee_est_dt AS dt, (b.fee_s_amt+b.fee_v_amt) amt FROM cont a, SCD_fee b WHERE a.car_st='4' AND a.rent_l_cd NOT LIKE 'RM%' AND a.rent_l_cd NOT IN ('S113KNLM00003','S113HA4M00001') and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.r_fee_est_dt='"+s_dt+"' AND b.rc_dt IS NULL AND NVL(b.bill_yn,'Y')='Y' AND b.fee_s_amt>0 \n";
		}else if(st.equals("2")){
			b_query = " SELECT '2' st, a.car_mng_id, a.client_id, a.rent_mng_id, a.rent_l_cd, a.mng_id, b.fee_est_dt as est_dt, b.rc_dt as pay_dt, b.rc_dt AS dt, b.rc_amt as amt FROM cont a, SCD_fee b WHERE a.car_st='4' AND a.rent_l_cd NOT LIKE 'RM%' AND a.rent_l_cd NOT IN ('S113KNLM00003','S113HA4M00001') and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rc_dt='"+s_dt+"' AND NVL(b.bill_yn,'Y')='Y' AND b.fee_s_amt>0 \n";
		}else if(st.equals("3")){
			b_query = " SELECT '3' st, a.car_mng_id, a.client_id, a.rent_mng_id, a.rent_l_cd, a.mng_id, b.fee_est_dt as est_dt, b.rc_dt as pay_dt, '"+s_dt+"' AS dt, (b.fee_s_amt+b.fee_v_amt) amt FROM cont a, SCD_fee b WHERE a.car_st='4' AND a.rent_l_cd NOT LIKE 'RM%' AND a.rent_l_cd NOT IN ('S113KNLM00003','S113HA4M00001') and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.r_fee_est_dt < to_char(sysdate,'YYYYMMDD') and TO_CHAR(TO_DATE(b.r_fee_est_dt,'YYYYMMDD')+1,'YYYYMMDD')='"+s_dt+"' AND (b.rc_dt IS NULL OR b.rc_dt > '"+s_dt+"') AND NVL(b.bill_yn,'Y')='Y' AND b.fee_s_amt>0 \n";
		}else if(st.equals("4")){
			b_query = " SELECT '4' st, a.car_mng_id, a.client_id, a.rent_mng_id, a.rent_l_cd, a.mng_id, b.fee_est_dt as est_dt, b.rc_dt as pay_dt, '"+s_dt+"' AS dt, (b.fee_s_amt+b.fee_v_amt) amt FROM cont a, SCD_fee b WHERE a.car_st='4' AND a.rent_l_cd NOT LIKE 'RM%' AND a.rent_l_cd NOT IN ('S113KNLM00003','S113HA4M00001') and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.r_fee_est_dt < to_char(sysdate,'YYYYMMDD') and TO_CHAR(TO_DATE(b.r_fee_est_dt,'YYYYMMDD')+1,'YYYYMMDD')<'"+s_dt+"' AND (b.rc_dt IS NULL OR b.rc_dt > '"+s_dt+"') and b.r_fee_est_dt<>to_char(sysdate,'YYYYMMDD') AND NVL(b.bill_yn,'Y')='Y' AND b.fee_s_amt>0 \n";
		}


		String b_dt = "a.dt";

		
		query = " select a.*, b.car_mng_id, b.car_no, b.car_nm, \n"+
				"        e.use_s_dt, e.use_e_dt, \n"+
				"        b.car_no, b.car_nm, c.firm_nm, f.user_nm as mng_nm, d.cls_dt \n"+       
				" from   ("+b_query+") a, car_reg b, client c, \n"+
		        "        (select a.rent_mng_id, a.rent_l_cd, min(use_s_dt) use_s_dt, max(use_e_dt) use_e_dt "+
				"         from   scd_fee a, cont b \n"+
				"	      where  b.car_st='4' AND b.rent_l_cd NOT LIKE 'RM%' AND b.rent_l_cd NOT IN ('S113KNLM00003','S113HA4M00001') "+
				"	             and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.fee_s_amt<>0 and nvl(a.bill_yn,'Y')='Y' \n"+
				"         group by a.rent_mng_id, a.rent_l_cd) e, \n"+
			    "        users f, cls_cont d "+
				" where  a.car_mng_id=b.car_mng_id and a.client_id=c.client_id "+
				"	     and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd \n"+
				"        and a.mng_id=f.user_id"+
				"	     and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+) \n"+
				"";	
		
		
		query += " ORDER BY a.est_dt, "+b_dt+", e.use_s_dt, e.use_e_dt, a.rent_l_cd \n"+
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
			System.out.println("[ResSearchDatabase:getRmRentStat5SubList]"+e);
			System.out.println("[ResSearchDatabase:getRmRentStat5SubList]"+query);
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
	 *	기본식정비대차 수금관리리스트
	 */
	public Vector getConSRent2SettleList(String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT A.CAR_MNG_id, a.RENT_S_CD, c.rent_mng_id, c.rent_l_cd, c.use_yn, d.rent_st, "+
				"        e.car_no, E.CAR_NM, "+
				"        e2.car_no AS car_no2, E2.CAR_NM AS car_nm2, "+
				"        f.firm_nm, "+
				"        d.rent_start_dt, a.deli_dt, a.ret_dt, a.reg_dt, a.use_st, "+
				"        NVL(h.tot_months,a.rent_months) months, NVL(h.tot_days,a.rent_days) days, NVL(h.tot_hour,a.rent_hour) hour, "+
				"        b.inv_s_amt, "+
				"        b.fee_s_amt+b.FEE_v_amt AS fee_amt, "+
				"        b.cons1_s_amt+b.CONS1_V_AMT+b.cons2_s_amt+b.CONS2_V_AMT AS cons_amt, "+
				"        b.rent_tot_amt, "+
				"        h.sett_dt,  "+
				"        g.tm, g.dly_days, g.est_dt, g.pay_dt, g.pay_amt, "+
				"        DECODE(NVL(g.pay_amt,0),0,'미수금','수금') pay_st, "+
				"        i.user_nm, l.tax_dt "+
				" FROM   RENT_CONT a, RENT_FEE b, CONT c, FEE d, CAR_REG e, CAR_REG e2, CLIENT f, "+
				"        (SELECT * FROM SCD_RENT WHERE NVL(bill_yn,'Y')='Y' and rent_s_amt >0 ) g, "+
				"        RENT_SETTLE h, USERS i, "+
                "        (select bb.rent_l_cd, min(tax_dt) tax_dt, SUM(tax_supply) tax_supply, SUM(tax_value) tax_value from tax_item_list aa, tax bb where aa.item_id=bb.item_id and bb.tax_st='O' and aa.gubun ='17' GROUP BY bb.rent_l_cd HAVING SUM(tax_supply)>0) l "+
				" WHERE  SUBSTR(a.deli_dt,1,8)>='20141101' AND a.RENT_ST='2' AND a.use_st IN ('4') "+
				"        AND a.rent_s_cd=b.rent_s_cd "+
				"        AND a.sub_c_id=c.car_mng_id AND a.sub_l_cd=c.rent_l_cd "+
				"        AND c.rent_mng_id=d.rent_mng_id AND c.rent_l_cd=d.rent_l_cd "+
				"        AND a.car_mng_id=e.car_mng_id "+
				"        AND c.car_mng_id=e2.car_mng_id "+
				"        AND a.cust_id=f.client_id "+
				"        AND SUBSTR(a.deli_dt,1,8) BETWEEN d.rent_start_dt AND d.rent_end_dt "+
				"        AND d.rent_way='3'        "+
				"        AND TO_CHAR(ADD_MONTHS(TO_DATE(d.rent_start_dt,'YYYYMMDD'),2),'YYYYMMDD') <=SUBSTR(a.deli_dt,1,8) "+
				"        AND a.rent_s_cd=g.rent_s_cd "+
				"        AND a.RENT_s_cd=h.rent_s_cd(+) "+
				"        AND a.bus_id=i.user_id "+
				"        AND a.rent_s_cd=l.rent_l_cd(+) "+
				" ";

		/*상세조회&&세부조회*/

		//당월-계획
		if(gubun2.equals("1") && gubun3.equals("1")){		query += " and g.est_dt like to_char(sysdate,'YYYYMM')||'%'";
		//당월-수금
		}else if(gubun2.equals("1") && gubun3.equals("2")){	query += " and g.est_dt like to_char(sysdate,'YYYYMM')||'%' and g.pay_dt is not null";
		//당월-미수금
		}else if(gubun2.equals("1") && gubun3.equals("3")){	query += " and g.est_dt like to_char(sysdate,'YYYYMM')||'%' and g.pay_dt is null";
		//당일-계획
		}else if(gubun2.equals("2") && gubun3.equals("1")){	query += " and g.est_dt = to_char(sysdate,'YYYYMMDD')";
		//당일-수금
		}else if(gubun2.equals("2") && gubun3.equals("2")){	query += " and g.est_dt = to_char(sysdate,'YYYYMMDD') and g.pay_dt = to_char(sysdate,'YYYYMMDD')";
		//당일-미수금
		}else if(gubun2.equals("2") && gubun3.equals("3")){	query += " and g.est_dt = to_char(sysdate,'YYYYMMDD') and g.pay_dt is null";
		//연체-계획
		}else if(gubun2.equals("3") && gubun3.equals("1")){	query += " and g.est_dt < to_char(sysdate,'YYYYMMDD') and (g.pay_dt is null or g.pay_dt = to_char(sysdate,'YYYYMMDD'))";
		//연체-수금
		}else if(gubun2.equals("3") && gubun3.equals("2")){	query += " and g.est_dt < to_char(sysdate,'YYYYMMDD') and g.pay_dt = to_char(sysdate,'YYYYMMDD')";
		//연체-미수금
		}else if(gubun2.equals("3") && gubun3.equals("3")){	query += " and g.est_dt < to_char(sysdate,'YYYYMMDD') and g.pay_dt is null";
		//기간-계획
		}else if(gubun2.equals("4") && gubun3.equals("1")){	query += " and g.est_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		//기간-수금
		}else if(gubun2.equals("4") && gubun3.equals("2")){	query += " and g.est_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and g.pay_dt is not null";
		//기간-미수금
		}else if(gubun2.equals("4") && gubun3.equals("3")){	query += " and g.est_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and g.pay_dt is null";
		//당일+연체-계획
		}else if(gubun2.equals("6") && gubun3.equals("1")){	query += " and g.est_dt <= to_char(sysdate,'YYYYMMDD') and (g.pay_dt is null or g.pay_dt = to_char(sysdate,'YYYYMMDD'))";
		//당일+연체-수금
		}else if(gubun2.equals("6") && gubun3.equals("2")){	query += " and g.est_dt <= to_char(sysdate,'YYYYMMDD') and g.pay_dt = to_char(sysdate,'YYYYMMDD')";
		//당일+연체-미수금
		}else if(gubun2.equals("6") && gubun3.equals("3")){	query += " and g.est_dt <= to_char(sysdate,'YYYYMMDD') and g.pay_dt is null";
		//검색
		}

		if(!t_wd.equals("")){	
			if(s_kd.equals("1"))		query += " and f.firm_nm like '%"+t_wd+"%'\n";
			else if(s_kd.equals("2"))	query += " and upper(c.rent_l_cd) like upper('%"+t_wd+"%')\n";
			else if(s_kd.equals("3"))	query += " and nvl(e2.car_no, '') like '%"+t_wd+"%'\n";
			else if(s_kd.equals("4"))	query += " and nvl(e.car_no, '') like '%"+t_wd+"%'\n";
			else if(s_kd.equals("5"))	query += " and a.bus_id= '"+t_wd+"'\n";
		}

		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		/*정렬조건*/
		if(sort_gubun.equals("1"))		query += " order by c.use_yn desc, g.est_dt "+sort+", g.pay_dt, f.firm_nm";
		else if(sort_gubun.equals("2"))	query += " order by c.use_yn desc, g.pay_dt "+sort+", f.firm_nm, g.est_dt";
		else if(sort_gubun.equals("3"))	query += " order by c.use_yn desc, f.firm_nm, g.pay_dt, g.est_dt";


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
			System.out.println("[ResSearchDatabase:getConSRent2SettleList]"+e);
			System.out.println("[ResSearchDatabase:getConSRent2SettleList]"+query);
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
	 *	기본식정비대차 수금관리리스트
	 */
	public Vector getConSRent2SettleScd(String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT A.CAR_MNG_id, a.RENT_S_CD, c.rent_mng_id, c.rent_l_cd, c.use_yn, "+
				"        e.car_no, E.CAR_NM, "+
				"        e2.car_no AS car_no2, E2.CAR_NM AS car_nm2, "+
				"        f.firm_nm, "+
				"        d.rent_start_dt, a.deli_dt, a.ret_dt, a.reg_dt, a.use_st, "+
				"        NVL(h.tot_months,a.rent_months) months, NVL(h.tot_days,a.rent_days) days, NVL(h.tot_hour,a.rent_hour) hour, "+
				"        b.inv_s_amt, "+
				"        b.fee_s_amt+b.FEE_v_amt AS fee_amt, "+
				"        b.cons1_s_amt+b.CONS1_V_AMT+b.cons2_s_amt+b.CONS2_V_AMT AS cons_amt, "+
				"        b.rent_tot_amt, "+
				"        h.sett_dt,  "+
				"        g.rent_st, g.tm, g.dly_days, g.est_dt, g.pay_dt, g.pay_amt, g.rent_s_amt+g.rent_v_amt as rent_amt, g.dly_amt, "+
				"        DECODE(NVL(g.pay_amt,0),0,'미수금','수금') pay_st, "+
				"        i.user_nm, l.tax_dt "+
				" FROM   RENT_CONT a, RENT_FEE b, CONT c, FEE d, CAR_REG e, CAR_REG e2, CLIENT f, "+
				"        (SELECT * FROM SCD_RENT WHERE NVL(bill_yn,'Y')='Y' and rent_s_amt >0 ) g, "+
				"        RENT_SETTLE h, USERS i, "+
                "        (select bb.rent_l_cd, min(tax_dt) tax_dt, SUM(tax_supply) tax_supply, SUM(tax_value) tax_value from tax_item_list aa, tax bb where aa.item_id=bb.item_id and bb.tax_st='O' and aa.gubun ='17' GROUP BY bb.rent_l_cd HAVING SUM(tax_supply)>0) l "+
				" WHERE  a.sub_l_cd='"+rent_l_cd+"' and SUBSTR(a.deli_dt,1,8)>='20141101' AND a.RENT_ST='2' AND a.use_st IN ('4') "+
				"        AND a.rent_s_cd=b.rent_s_cd "+
				"        AND a.sub_c_id=c.car_mng_id AND a.sub_l_cd=c.rent_l_cd "+
				"        AND c.rent_mng_id=d.rent_mng_id AND c.rent_l_cd=d.rent_l_cd "+
				"        AND a.car_mng_id=e.car_mng_id "+
				"        AND c.car_mng_id=e2.car_mng_id "+
				"        AND a.cust_id=f.client_id "+
				"        AND SUBSTR(a.deli_dt,1,8) BETWEEN d.rent_start_dt AND d.rent_end_dt "+
				"        AND d.rent_way='3'        "+
				"        AND TO_CHAR(ADD_MONTHS(TO_DATE(d.rent_start_dt,'YYYYMMDD'),2),'YYYYMMDD') <=SUBSTR(a.deli_dt,1,8) "+
				"        AND a.rent_s_cd=g.rent_s_cd "+
				"        AND a.RENT_s_cd=h.rent_s_cd(+) "+
				"        AND a.bus_id=i.user_id "+
				"        AND a.rent_s_cd=l.rent_l_cd(+) "+
				" ";

		query += " ORDER BY a.deli_dt ";
		

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
			System.out.println("[ResSearchDatabase:getConSRent2SettleScd]"+e);
			System.out.println("[ResSearchDatabase:getConSRent2SettleScd]"+query);
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
	 *	차량정보
	 */

public Hashtable HtResCarAccidList(String c_id, String accid_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select g.car_no, g.car_nm, g.first_car_no, a.car_mng_id, a.rent_s_cd,"+
				" decode(a.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','장기대기','12','월렌트') rent_st,"+
				" decode(a.use_st,'1','예약','2','배차','3','반차','4','종료','5','취소') use_st,"+
				" nvl(a.deli_dt,a.rent_start_dt) deli_dt, nvl(a.ret_dt,a.ret_plan_dt) ret_dt,"+
				" nvl(a.deli_dt,a.rent_start_dt) rent_start_dt, nvl(nvl(a.ret_dt,a.ret_plan_dt),a.rent_end_dt) rent_end_dt,"+
				" a. rent_hour, (b.fee_s_amt+b.fee_v_amt) fee_amt,"+
				" decode(a.cust_st, '','조성희', '1',e.client_nm, '4',f.user_nm, d.cust_nm) cust_nm,"+
				" decode(a.cust_st, '','(주)아마존카', '1',e.firm_nm, '4','(주)아마존카', d.firm_nm) firm_nm,"+
				" decode(a.cust_st, '','', '1',TEXT_DECRYPT(e.ssn, 'pw' ) , '4', TEXT_DECRYPT(f.user_ssn, 'pw' ) , d.ssn) ssn,"+
				" decode(a.cust_st, '','', '1',e.enp_no, '4','', d.enp_no) enp_no, f2.user_nm as bus_nm, g2.car_no as d_car_no, g2.car_nm as d_car_nm"+
				" from RENT_CONT a, RENT_FEE b, RENT_SETTLE c, RENT_CUST d, CLIENT e, users f, car_reg g, users f2, car_reg g2"+
				" where "+
				" a.sub_c_id='"+c_id+"' and a.accid_id='"+accid_id+"' and a.rent_st='3' and a.use_st<>'5' "+
				" and a.rent_s_cd=b.rent_s_cd(+) and a.rent_s_cd=c.rent_s_cd(+)"+
				" and a.cust_id=d.cust_id(+) and a.cust_id=e.client_id(+) and a.cust_id=f.user_id(+)"+
				" and a.car_mng_id=g.car_mng_id"+
				" and a.bus_id=f2.user_id"+
				" and a.sub_c_id=g2.car_mng_id(+)"+
				" order by a.deli_dt";


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:HtResCarAccidList]"+e);
			System.out.println("[ResSearchDatabase:HtResCarAccidList]"+query);
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

	/****************************************************************************************
	*******************************************   smart
    ****************************************************************************************/
	
	/**
	 *	배차관리 리스트
	 */
	public Vector getResStatList_New(String s_kd, String t_wd, String self_st, String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" a.rent_s_cd, a.car_mng_id, decode(a.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','장기대기') rent_st,"+
				" decode(a.cust_st, '4',c.user_nm, b.firm_nm) cust_nm,"+
				" a.rent_dt, a.rent_start_dt, a.rent_end_dt, a.deli_plan_dt, a.ret_plan_dt, a.brch_id, a.bus_id,"+
				" d.car_no, d.init_reg_dt, d.car_nm, f.user_nm as bus_nm, d2.car_no as d_car_no, d2.car_nm as d_car_nm"+
				" from RENT_CONT a, CLIENT b, USERS c, CAR_REG d, users f, car_reg d2,"+
				"       (select a.car_mng_id, min(ce.car_id) car_id, min(ce.car_seq) car_seq from cont a, car_etc ce where a.rent_mng_id = ce.rent_mng_id and a.rent_l_cd = ce.rent_l_cd group by a.car_mng_id) g, car_nm i, CAR_MNG e "+
		//		"      (select car_mng_id, min(car_id) car_id, min(car_seq) car_seq from cont_view group by car_mng_id) g, car_nm i, CAR_MNG e "+
				" where a.use_st='1' and a.cust_id=b.client_id(+) and a.cust_id=c.user_id(+)"+
				" and a.car_mng_id=d.car_mng_id and a.bus_id=f.user_id(+) and a.sub_c_id=d2.car_mng_id(+)"+
				" and a.car_mng_id=g.car_mng_id and g.car_id=i.car_id and g.car_seq=i.car_seq and i.car_comp_id=e.car_comp_id and i.car_cd=e.code "+
				" and a.rent_st<>'11'"+ //장기대기는 제외
				" ";
		
		if(self_st.equals("Y"))			query += " and a.reg_id||a.bus_id like '%"+user_id+"%'";

		if(s_kd.equals("1"))			query += " and upper(d.car_no)||upper(d.first_car_no) like upper('%"+t_wd+"%')\n";		
		if(s_kd.equals("2"))			query += " and decode(a.cust_st, '4',c.user_nm, b.client_nm) like '%"+t_wd+"%'\n";		
		if(s_kd.equals("3"))			query += " and decode(a.cust_st, '4','(주)아마존카', b.firm_nm) like '%"+t_wd+"%'\n";		
		if(s_kd.equals("4"))			query += " and f.user_nm like '%"+t_wd+"%'\n";		
		if(s_kd.equals("5"))			query += " and upper(d2.car_no)||upper(d2.first_car_no) like upper('%"+t_wd+"%')\n";			

		query += " ORDER BY d.car_nm";

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
			System.out.println("[ResSearchDatabase:getResStatList_New]"+e);
			System.out.println("[ResSearchDatabase:getResStatList_New]"+query);
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
	 *	반차관리 리스트
	 */
	public Vector getRentMngList_New(String s_kd, String t_wd, String self_st, String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" a.rent_s_cd, a.car_mng_id, decode(a.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','장기대기') rent_st,"+
				" decode(a.cust_st, '','아마존카', '4',e.user_nm, d.firm_nm) cust_nm,"+
				" decode(a.cust_st, '','아마존카', '4',e.user_nm, d.firm_nm) firm_nm,"+
				" a.rent_dt, a.rent_start_dt, a.rent_end_dt, a.deli_plan_dt, a.ret_plan_dt, a.deli_dt, a.ret_dt, b.rent_tot_amt, a.brch_id, a.bus_id,"+
				" c.car_no, c.init_reg_dt, c.car_nm, "+
				" g.user_nm as bus_nm,"+
				" decode(h.car_mng_id,'','단기','장기') lc_st, c2.car_no as d_car_no, c2.car_nm as d_car_nm, a.cust_id, e.loan_st "+
				" from RENT_CONT a, RENT_FEE b, CAR_REG c, CLIENT d, USERS e, users g, (select car_mng_id from cont where use_yn='Y' and car_st<>'2') h, car_reg c2, "+
				"      (select a.car_mng_id, min(ce.car_id) car_id, min(ce.car_seq) car_seq from cont a, car_etc ce where a.rent_mng_id = ce.rent_mng_id and a.rent_l_cd = ce.rent_l_cd group by a.car_mng_id) f, car_nm i, CAR_MNG j "+
		//		"      (select car_mng_id, min(car_id) car_id, min(car_seq) car_seq from cont_view group by car_mng_id) f, car_nm i, CAR_MNG j "+
				" where a.use_st='2' and a.rent_s_cd=b.rent_s_cd(+) and a.car_mng_id=c.car_mng_id and a.cust_id=d.client_id(+) and a.cust_id=e.user_id(+)"+
				" and a.bus_id=g.user_id(+) and a.car_mng_id=h.car_mng_id(+) and a.sub_c_id=c2.car_mng_id(+)"+
				" and a.car_mng_id=f.car_mng_id and f.car_id=i.car_id and f.car_seq=i.car_seq and i.car_comp_id=j.car_comp_id and i.car_cd=j.code "+
				" ";

		if(self_st.equals("Y"))			query += " and a.reg_id||a.bus_id like '%"+user_id+"%'";
				
		if(s_kd.equals("1"))									query += " and upper(c.car_no)||upper(c.first_car_no) like upper('%"+t_wd+"%')\n";		
		if(s_kd.equals("2"))									query += " and decode(a.cust_st, '','아마존카', '4',e.user_nm, d.client_nm) like '%"+t_wd+"%'\n";		
		if(s_kd.equals("3"))									query += " and decode(a.cust_st, '','아마존카', '4',e.user_nm, d.firm_nm) like '%"+t_wd+"%'\n";		
		if(s_kd.equals("4"))									query += " and g.user_nm like '%"+t_wd+"%'\n";		
		if(s_kd.equals("5"))									query += " and upper(c2.car_no)||upper(c2.first_car_no) like '%"+t_wd+"%'\n";		

		query += " ORDER BY decode(h.car_mng_id,'','단기','장기'), decode(a.cust_st, '4',e.user_nm, d.firm_nm)";

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
			System.out.println("[ResSearchDatabase:getRentMngList_New]"+e);
			System.out.println("[ResSearchDatabase:getRentMngList_New]"+query);
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

/**
	 *	월렌트 리스트 - 상호검색
	 */
	public Vector getRentEndList_New(String gubun2, String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				"        a.rent_s_cd, a.car_mng_id, a.rent_dt, a.rent_start_dt, a.rent_end_dt, a.deli_plan_dt, a.ret_plan_dt, a.deli_dt, a.ret_dt, a.brch_id, a.bus_id, a.etc, \n"+
				"        b.rent_tot_amt, "+
				"        j.sett_dt, j.rent_tot_amt, nvl(j.run_km,b.dist_km) run_km, d.FAX, d.O_ZIP, d.O_ADDR, d.enp_no, TEXT_DECRYPT(d.ssn, 'pw' )  ssn,  d.FIRM_NM, \n"+
				"        f.car_no, f.init_reg_dt, f.car_nm, h.car_name, d.client_id, d.client_nm, d.client_st, decode(d.client_st,'1','법인','2','개인','개인사업자') CLIENT_ST_NM, d.o_tel, d.m_tel, "+
				"        i.user_nm as bus_nm, i2.user_nm as mng_nm,  \n"+
				"        decode(a.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','장기대기','12','월렌트') rent_st,  \n"+
				"        decode(a.use_st,'1','예약','2','배차','3','반차','4','정산','5','취소') use_st ,   \n"+
				"        decode(a.cust_st, '4',e.user_nm, d.client_nm) cust_nm,"+
				"        decode(a.cust_st, '4','(주)아마존카', d.firm_nm) firm_nm,  \n"+
				"        nvl(j.tot_hour,a.rent_hour) tot_hour, nvl(j.tot_days,a.rent_days) tot_days, nvl(j.tot_months,a.rent_months) tot_months,  \n"+
				"        trunc(to_date(substr(nvl(a.ret_dt,a.ret_plan_dt),1,8),'YYYYMMDD')-to_date(substr(nvl(a.deli_dt,a.deli_plan_dt),1,8),'YYYYMMDD'),0) use_day, \n"+
				"        f2.car_no as d_car_no, f2.car_nm as d_car_nm, nvl(b.inv_s_amt,0) inv_amt, nvl(b.dc_s_amt,0) dc_amt, p.io_dt \n"+
				" from   RENT_CONT a, RENT_FEE b, RENT_SETTLE j, CLIENT d, USERS e, CAR_REG f, users i, users i2, \n"+
				"        (select a.* FROM CONT a, (SELECT car_mng_id, min(rent_l_cd) rent_l_cd from cont where car_st<>'4' group by car_mng_id) b WHERE a.car_mng_id=b.car_mng_id AND a.rent_l_cd=b.rent_l_cd) c, \n"+
				"        car_etc g, car_nm h, "+
				"        car_mng k, car_reg f2, \n"+
				"       ( select distinct car_mng_id, io_dt from park_io where io_gubun = '1' ) p \n"+
				" where  a.rent_s_cd=b.rent_s_cd(+)"+
				"        and a.cust_id=d.client_id(+) and a.cust_id=e.user_id(+)  \n"+
				"        and a.car_mng_id=f.car_mng_id "+
				"        and a.rent_s_cd=j.rent_s_cd(+) and a.bus_id=i.user_id(+) and a.mng_id=i2.user_id(+) \n"+
				"        and a.car_mng_id=c.car_mng_id(+) and c.rent_mng_id=g.rent_mng_id(+) and c.rent_l_cd=g.rent_l_cd(+) and g.car_id=h.car_id(+) and g.car_seq=h.car_seq(+) \n"+
				" 	and a.car_mng_id = p.car_mng_id(+)  and substr(a.ret_dt,1,8) = p.io_dt(+) \n"+
//				"        and f.car_nm=k.car_nm(+) "+
				"        and h.car_comp_id=k.car_comp_id(+) and h.car_cd=k.code(+) \n"+
				"        and a.sub_c_id=f2.car_mng_id(+) \n";
		

		if(gubun2.equals("12"))		query += " and a.rent_st='12'";

		
		if(!t_wd.equals("")){
			if(s_kd.equals("2"))								query += " and upper(f.car_no)||upper(f.first_car_no) like upper('%"+t_wd+"%')\n";		
			if(s_kd.equals("1"))								query += " and decode(a.cust_st, '4','(주)아마존카', d.firm_nm) like '%"+t_wd+"%'\n";			
		}


			query += " ORDER BY a.use_st, a.reg_dt ";


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
			System.out.println("[ResSearchDatabase:getRentEndList_New]"+e);
			System.out.println("[ResSearchDatabase:getRentEndList_New]"+query);
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
	 *	월렌트-연체대여료 - 실시간 
	 */	
	public Vector getRmRentStat5MagamList(String s_ym)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		 		
		query = " select a.*, decode(a.amt3+a.amt4, 0, '0.00', TO_CHAR((a.amt3+a.amt4)/a.amt7*100,'9999.99')) dly_per \n"+
				" from   stat_fee_rm a \n"+
				" where  a.dt like '"+s_ym+"%' \n"+
				" order by a.dt \n"+
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
			System.out.println("[ResSearchDatabase:getRmRentStat5MagamList]"+e);
			System.out.println("[ResSearchDatabase:getRmRentStat5MagamList]"+query);
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
	
	
	public Vector getRealRmRentStat5MagamList()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = "  select a.*, decode(a.amt3+a.amt4, 0, '0.00', TO_CHAR((a.amt3+a.amt4)/a.amt7*100,'9999.99')) dly_per  \n" + 
				" from ( \n" + 	
				" select   to_char(sysdate,'YYYYMMdd') dt ,  COUNT    (DECODE(a.st,'1',a.rent_l_cd)) cnt1, \n" + 
			    "    nvl(SUM  (DECODE(a.st,'1',a.amt)),0) amt1, \n" + 
			    "    COUNT    (DECODE(a.st,'2',a.rent_l_cd)) cnt2, \n" + 
			    "    nvl(SUM  (DECODE(a.st,'2',a.amt)),0) amt2, \n" + 
			    "    COUNT    (DECODE(a.st,'3',a.rent_l_cd)) cnt3, \n" + 
			    "    nvl(SUM  (DECODE(a.st,'3',a.amt)),0) amt3, \n" + 
			    "    COUNT    (DECODE(a.st,'4',a.rent_l_cd)) cnt4, \n" + 
			    "    nvl(SUM  (DECODE(a.st,'4',a.amt)),0) amt4, \n" + 
			    "    COUNT    (DECODE(a.st,'5',a.rent_l_cd)) cnt5, \n" + 
			    "    nvl(SUM  (DECODE(a.st,'5',a.amt)),0) amt5, \n" + 
			    "    COUNT    (DECODE(a.st,'6',a.rent_l_cd)) cnt6, \n" + 
			    "    nvl(SUM  (DECODE(a.st,'6',a.amt)),0) amt6, \n" + 
			    "    COUNT    (DECODE(a.st,'7',a.rent_l_cd)) cnt7, \n" + 
			    "    nvl(SUM  (DECODE(a.st,'7',a.amt)),0) amt7 \n" + 
			    "	from   (\n" + 
    //   --수금예정
				"         SELECT '1' st, a.rent_mng_id, a.rent_l_cd, (b.fee_s_amt+b.fee_v_amt) amt \n" + 
				" FROM   cont a, SCD_fee b \n" + 
				" WHERE  a.car_st='4' \n" +  //--AND a.rent_l_cd NOT LIKE 'RM%' AND a.rent_l_cd NOT IN ('S113KNLM00003','S113HA4M00001') \n" + 
				"        and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n" + 
				"        AND b.bill_yn='Y' AND b.fee_s_amt>0 and b.rc_dt IS NULL \n" + 
				"        and b.r_fee_est_dt=to_char(sysdate,'YYYYMMdd') \n" + 
				
				"         UNION all \n" + 

 //--수금대여료
				"         SELECT '2' st, a.rent_mng_id, a.rent_l_cd, b.rc_amt as amt \n" + 
				" FROM   cont a, SCD_fee b \n" + 
				" WHERE  a.car_st='4' \n" +  // --AND a.rent_l_cd NOT LIKE 'RM%' AND a.rent_l_cd NOT IN ('S113KNLM00003','S113HA4M00001') \n" + 
				"        and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n" + 
				"        AND b.bill_yn='Y' AND b.fee_s_amt >0 \n" + 
				"        and b.rc_dt=to_char(sysdate,'YYYYMMdd') \n" + 
				
				"         UNION all \n" + 

 //--신규연체대여료
				"         SELECT '3' st, a.rent_mng_id, a.rent_l_cd, (b.fee_s_amt+b.fee_v_amt) amt \n" + 
				" FROM   cont a, SCD_fee b \n" + 
				" WHERE  a.car_st='4' \n" +  //--AND a.rent_l_cd NOT LIKE 'RM%' AND a.rent_l_cd NOT IN ('S113KNLM00003','S113HA4M00001') \n" + 
				"        and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n" + 
				"        AND b.bill_yn='Y' AND b.fee_s_amt>0 \n" + 
				"        and b.r_fee_est_dt < to_char(sysdate,'YYYYMMDD') \n" + 
				"        and b.r_fee_est_dt = To_CHAR(TO_DATE(to_char(sysdate,'YYYYMMDD') ,'YYYYMMDD')-1, 'YYYYMMDD') \n" + 
				"        AND (b.rc_dt IS NULL OR b.rc_dt > to_char(sysdate,'YYYYMMDD')) \n" + 
				
				"         UNION all \n" + 

 //--누적연체대여료
				"         SELECT '4' st, a.rent_mng_id, a.rent_l_cd, (b.fee_s_amt+b.fee_v_amt) amt  \n" + 
				" FROM   cont a, SCD_fee b  \n" + 
				" WHERE  a.car_st='4'  \n" +  //--AND a.rent_l_cd NOT LIKE 'RM%' AND a.rent_l_cd NOT IN ('S113KNLM00003','S113HA4M00001')  \n" + 
				"        and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd  \n" + 
				"        AND b.bill_yn='Y' AND b.fee_s_amt>0  \n" + 
				"        and b.r_fee_est_dt < to_char(sysdate,'YYYYMMDD')  \n" + 
				"        and b.r_fee_est_dt < To_CHAR(TO_DATE(to_char(sysdate,'YYYYMMDD') ,'YYYYMMDD')-1, 'YYYYMMDD')  \n" + 
				"        AND (b.rc_dt IS NULL OR b.rc_dt > to_char(sysdate,'YYYYMMdd'))  \n" + 
				"        and b.r_fee_est_dt<>to_char(sysdate,'YYYYMMDD')  \n" + 
				
				"         UNION all  \n" + 

	//			 --연체율계산 받을어음
				"         SELECT '7' st, a.rent_mng_id, a.rent_l_cd, decode(b.rc_dt,'',b.fee_s_amt+b.fee_v_amt,b.rc_amt) amt \n" + 
				" FROM   cont a, SCD_fee b \n" + 
				" WHERE  a.car_st='4' \n" +  //--AND a.rent_l_cd NOT LIKE 'RM%' AND a.rent_l_cd NOT IN ('S113KNLM00003','S113HA4M00001')
				"        and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n" + 
				"        AND b.bill_yn='Y' AND b.fee_s_amt>0 \n" + 
				"        and (b.rc_dt IS NULL OR b.rc_dt > to_char(sysdate,'YYYYMMDD')) \n" + 
				"   ) a\n" + 
				") a \n" + 
				" " ;			

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
			System.out.println("[ResSearchDatabase:getRealRmRentStat5MagamList]"+e);
			System.out.println("[ResSearchDatabase:getRealRmRentStat5MagamList]"+query);
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
	 *	New 메뉴별 권한 조회
	 */
	public String getXmlAuthRw(String user_id, String m_st, String m_st2, String m_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String auth_rw = "";

		query = " select nvl(auth_rw,'0') auth_rw from xml_MA_ME where user_id='"+user_id+"' and m_st='"+m_st+"' and m_st2='"+m_st2+"' and m_cd='"+m_cd+"'";

		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{				
			    auth_rw = rs.getString(1)==null?"":rs.getString(1);	
			}
			rs.close();
			pstmt.close();
	  	} catch (Exception e) {
			System.out.println("[ResSearchDatabase:getXmlAuthRw]\n"+e);
			System.out.println("[ResSearchDatabase:getXmlAuthRw]\n"+query);
			e.printStackTrace();
		} finally {
			try{	
				if(rs != null)	rs.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return auth_rw;
		}
	}

	/**	
	 *	Url별 권한 조회
	 */
	public String getXmlAuthRw(String user_id, String url)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String auth_rw = "";

		query = " select max(nvl(a.auth_rw,'0')) auth_rw from xml_MA_ME a, xml_menu b where a.user_id='"+user_id+"' and a.m_st=b.m_st and a.m_st2=b.m_st2 and a.m_cd=b.m_cd and b.url='"+url+"'";

		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{				
			    auth_rw = rs.getString(1)==null?"":rs.getString(1);	
			}
			rs.close();
			pstmt.close();
	  	} catch (Exception e) {
			System.out.println("[ResSearchDatabase:getXmlAuthRw(String user_id, String url)]\n"+e);
			System.out.println("[ResSearchDatabase:getXmlAuthRw(String user_id, String url)]\n"+query);
			e.printStackTrace();
		} finally {
			try{	
				if(rs != null)	rs.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return auth_rw;
		}
	}
	
	/*
	 *	P_SUI_SORT 마감
	*/
	public String call_sp_res_ret_msg(String msg_st, String rent_s_cd)
	{
    	getConnection();
    	
    	String query = "{CALL P_RES_RET_MSG     (?, ?)}";

		CallableStatement cstmt = null;
		
		try {

			cstmt = conn.prepareCall(query);	
			cstmt.setString(1, msg_st);
			cstmt.setString(2, rent_s_cd);
			cstmt.execute();
			cstmt.close();		
	
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:call_sp_res_ret_msg]\n"+e);
			e.printStackTrace();
		} finally {
			try{
			     if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return "";
		}
	}	
	
	/*
	 *	P_SUI_SORT 마감
	*/
	public String call_sp_res_deli_msg(String msg_st, String rent_s_cd)
	{
    	getConnection();
    	
    	String query = "{CALL P_RES_DELI_MSG     (?, ?)}";

		CallableStatement cstmt = null;
		
		try {

			cstmt = conn.prepareCall(query);	
			cstmt.setString(1, msg_st);
			cstmt.setString(2, rent_s_cd);
			cstmt.execute();
			cstmt.close();		
	
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:call_sp_res_deli_msg]\n"+e);
			e.printStackTrace();
		} finally {
			try{
			     if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return "";
		}
	}		


}