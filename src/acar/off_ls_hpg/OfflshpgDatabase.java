package acar.off_ls_hpg;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.exception.DataSourceEmptyException;
import acar.exception.DatabaseException;
import acar.util.*;


public class OfflshpgDatabase
{
	private Connection conn = null;
	public static OfflshpgDatabase db;
	private int totalsize = 0;	//전체게시물수
	private int pagesize = 10; //10으로 초기화
	private int totalpage = 0;	//전체페이지

	//마이링커 신규매물
	private int totalsize_new = 0;	//전체게시물수
	private int pagesize_new = 4; //4로 초기화
	private int totalpage_new = 0;	//전체페이지
	//마이링커 가격변동 매물
	private int totalsize_old = 0;	//전체게시물수
	private int pagesize_old = 4; //4로 초기화
	private int totalpage_old = 0;	//전체페이지

	//재리스 
	private int totalsize_sh = 0;	//전체게시물수
	private int pagesize_sh = 10;	//10으로 초기화
	private int totalpage_sh = 0;	//전체페이지

	public static OfflshpgDatabase getInstance()
	{
		if(OfflshpgDatabase.db == null)
			OfflshpgDatabase.db = new OfflshpgDatabase();
		return OfflshpgDatabase.db;
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
	 *	매물 리스트 2004.04.22. 
	 * ; 제조사,차종,모델별 검색위해
	 */
	public Vector getOfflshpgList(String com_id,String car_cd,String car_cc,int car_year,String sort,String sort_gubun){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		this.totalsize = 0;
		String query = "";

		query = " select b.rent_mng_id, b.rent_l_cd, a.car_mng_id, a.car_no, h.car_nm car_jnm, g.car_name car_nm, b.colo, a.dpm,"+
				" substr(a.init_reg_dt,3,2)||'/'||substr(a.init_reg_dt,5,2) init_reg_dt, decode(c.lev,'1','상','2','중','3','하') lev, j.hp_pr,"+
				" decode(vt.tot_dist,'0',0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(e.dlv_dt,'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD'))) as tot_dist,"+
				" n.encar_id, n.reg_dt REG_DT, c.km as TODAY_DIST, c.imgfile1 "+
				" from car_reg a, car_etc b, apprsl c, cont e, car_nm g, CAR_MNG h, v_tot_dist vt, encar n, "+
				" (select a.car_mng_id CAR_MNG_ID, a.serv_dt SERV_DT, a.tot_dist TOT_DIST  from service a where a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where car_mng_id = a.car_mng_id)) i,"+
				" (SELECT a.car_mng_id CAR_MNG_ID, a.seq SEQ, a.actn_st ACTN_ST, a.damdang_id DAMDANG_ID, a.hp_pr HP_PR, a.st_pr ST_PR FROM auction a WHERE a.seq = (select max(seq) from auction where car_mng_id = a.car_mng_id)) j "+
				" where nvl(e.use_yn,'Y')='Y' and e.car_st='2' and a.off_ls='1' and b.car_id=g.car_id and a.car_mng_id=e.car_mng_id and e.rent_l_cd=b.rent_l_cd"+
				" and a.car_mng_id=c.car_mng_id(+) and a.car_mng_id=i.car_mng_id(+) and a.car_mng_id=n.car_mng_id(+)"+
				" and a.car_mng_id=j.car_mng_id(+) "+
				" AND b.car_id = g.car_id "+
				" and b.car_seq = g.car_seq "+
				" and g.car_comp_id = h.car_comp_id "+
				" and g.car_cd = h.code "+
				" and a.car_mng_id=vt.car_mng_id(+) "+
				" and a.car_mng_id='999' "; //임시중단

		if(!com_id.equals(""))			query += " and h.car_comp_id = '"+com_id+"'";
		if(car_cd!=null){
			if(!car_cd.equals(""))		query += " and h.car_comp_id ='"+com_id+"' and h.code = '"+car_cd+"'";
		}

		if(car_cc.equals("3"))			query += " and a.dpm > '2000'";
		else if(car_cc.equals("2"))		query += " and a.dpm between '1500' and '2000'";
		else if(car_cc.equals("1"))		query += " and a.dpm < '1500'";

		if(car_year > 0)				query += " and a.init_reg_dt like '"+car_year+"%'";	

		if(!sort.equals(""))			query += " ORDER BY "+sort+" "+sort_gubun;
		else							query += " ORDER BY c.apprsl_dt desc ";


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
				this.totalsize++;
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[OfflshpgDatabase:getOfflshpgList]"+e);
			e.printStackTrace();
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
	 *	마이링커 신규,가격변동 리스트 2004.11.03. Yongsoon Kwon.
	 */
	public Vector getMylinkerList(String arg){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String subQuery = "";
		this.totalsize_new = 0;
		this.totalsize_old = 0;

		if(arg.equals("new"))		subQuery = " and j.seq ='01' ";
		else if(arg.equals("old"))	subQuery = " and j.seq >'01' ";

		query = " select b.rent_mng_id, b.rent_l_cd, a.car_mng_id, a.car_no, h.car_nm car_jnm, g.car_name car_nm, b.colo, a.dpm,"+
				" substr(a.init_reg_dt,3,2)||'/'||substr(a.init_reg_dt,5,2) init_reg_dt, decode(c.lev,'1','상','2','중','3','하') lev, j.hp_pr,"+
				" decode(vt.tot_dist,'0',0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(e.dlv_dt,'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD'))) as tot_dist,"+
				" n.encar_id, c.km as today_dist, c.imgfile1 "+
				" from car_reg a, car_etc b, apprsl c, cont e, car_nm g, CAR_MNG h, v_tot_dist vt, encar n, "+
				" (select a.car_mng_id CAR_MNG_ID, a.serv_dt SERV_DT, a.tot_dist TOT_DIST  from service a where a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where car_mng_id = a.car_mng_id)) i,"+
				" (SELECT a.car_mng_id CAR_MNG_ID, a.seq SEQ, a.actn_st ACTN_ST, a.damdang_id DAMDANG_ID, a.hp_pr HP_PR, a.st_pr ST_PR FROM auction a WHERE a.seq = (select max(seq) from auction where car_mng_id = a.car_mng_id)) j "+
				" where nvl(e.use_yn,'Y')='Y' and e.car_st='2' and a.off_ls='1' and b.car_id=g.car_id and a.car_mng_id=e.car_mng_id and e.rent_l_cd=b.rent_l_cd"+
				" and a.car_mng_id=c.car_mng_id(+) and a.car_mng_id=i.car_mng_id(+) and a.car_mng_id=n.car_mng_id(+)"+
				" and a.car_mng_id=j.car_mng_id(+) "+
				" AND b.car_id = g.car_id "+
				" and b.car_seq = g.car_seq "+
				" and g.car_comp_id = h.car_comp_id "+
				" and g.car_cd = h.code "+ 
				" and a.car_mng_id=vt.car_mng_id(+) "+	
				subQuery;


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
				if(arg.equals("new"))		this.totalsize_new++;
				else if(arg.equals("old"))	this.totalsize_old++;

			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[OfflshpgDatabase:getMylinkerList(String arg)]"+e);
			e.printStackTrace();
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
	 *	실제매매(매각된 차량) 리스트 2004.04.23.
	 * ; 제조사,차종,모델별 검색위해
	 */
	public Vector getOfflshpgSuiList(String com_id,String car_cd, String car_cc, int car_year, String sort, String sort_gubun)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		this.totalsize = 0;
		String query = "";

		query = " select b.rent_mng_id, b.rent_l_cd, a.car_mng_id, a.car_no, m.car_nm car_jnm, g.car_name car_nm, g.car_cd,  b.colo, a.dpm,"+
				" substr(a.init_reg_dt,3,2)||'/'||substr(a.init_reg_dt,5,2) init_reg_dt, decode(c.lev,'1','상','2','중','3','하') lev, d.hp_pr, f.mm_pr, f.cont_dt,"+
				" decode(vt.tot_dist,'0',0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(e.dlv_dt,'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD'))) as tot_dist,"+
				" n.encar_id, n.reg_dt REG_DT, c.km as TODAY_DIST, c.imgfile1 "+
				" from car_reg a, car_etc b, apprsl c, auction d, cont e, car_nm g, CAR_MNG m, v_tot_dist vt, sui f, cls_cont j, encar n,"+
				" (select car_mng_id, max(seq) seq from auction group by car_mng_id) h,"+
				" (select a.car_mng_id CAR_MNG_ID, a.serv_dt SERV_DT, a.tot_dist TOT_DIST  from service a where a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where car_mng_id = a.car_mng_id)) i"+
				" where e.use_yn='N' and e.car_st='2' and b.car_id=g.car_id  and b.car_seq = g.car_seq  and g.car_comp_id = m.car_comp_id  and g.car_cd = m.code and a.car_mng_id=e.car_mng_id and e.rent_l_cd=b.rent_l_cd"+
				" and a.car_mng_id=c.car_mng_id and a.car_mng_id=d.car_mng_id and a.car_mng_id=i.car_mng_id and a.car_mng_id=f.car_mng_id and a.car_mng_id=n.car_mng_id(+) and a.car_mng_id=vt.car_mng_id(+)"+
				" and e.rent_mng_id=j.rent_mng_id and e.rent_l_cd=j.rent_l_cd and j.cls_st='6' and d.car_mng_id=h.car_mng_id and d.seq=h.seq and c.imgfile1 is not null ";

		//if(!car_nm.equals(""))			query += " and m.car_nm like '%"+car_nm+"%'";
		if(!com_id.equals(""))			query += " and m.car_comp_id = '"+com_id+"'";
		if(car_cd!=null){
			if(!car_cd.equals(""))			query += " and m.car_comp_id ='"+com_id+"' and m.code = '"+car_cd+"'";
		}

		if(car_cc.equals("3"))			query += " and a.dpm > '2000'";
		else if(car_cc.equals("2"))		query += " and a.dpm between '1500' and '2000'";
		else if(car_cc.equals("1"))		query += " and a.dpm < '1500'";

		if(car_year > 0)				query += " and a.init_reg_dt like '"+car_year+"%'";	

		if(!sort.equals(""))			query += " ORDER BY "+sort+" "+sort_gubun;
		else							query += " ORDER BY f.cont_dt desc ";


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
				this.totalsize++;
			}
			rs.close();
			pstmt.close();


		} catch (SQLException e) {
			System.out.println("[OfflshpgDatabase:getOfflshpgSuiList]"+e);
			e.printStackTrace();
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
	 *	매물 상세 조회
	 */
	public Hashtable getOfflshpgCase(String m_id, String l_cd, String c_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select g.car_comp_id, h.car_nm car_jnm, g.car_name car_nm, g.car_cd, REPLACE(a.car_no,SUBSTR(a.car_no,-4),'XXXX') car_no, b.ex_gas, a.car_kd as car_kd_cd,"+
				" j.nm as car_kd,"+
				" substr(a.init_reg_dt,3,2)||'/'||substr(a.init_reg_dt,5,2) yearmon, substr(a.init_reg_dt,1,4) year,"+
				" a.dpm, a.car_num, b.colo, a.init_reg_dt, e.dlv_dt,"+
				" i.nm as fuel_kd,"+
				" decode(vt.tot_dist,'0',0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(e.dlv_dt,'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD'))) as tot_dist,"+
				" c.km as today_dist,"+
				" b.opt,"+ 
				" d.hp_pr, (b.car_cs_amt+b.car_cv_amt) car_amt, (b.opt_cs_amt+b.opt_cv_amt) opt_amt, (b.clr_cs_amt+b.clr_cv_amt) clr_amt,"+
				" (b.car_cs_amt+b.car_cv_amt+b.opt_cs_amt+b.opt_cv_amt+b.clr_cs_amt+b.clr_cv_amt) tot_amt,"+
				" c.ass_chk, c.ass_st_dt, c.ass_ed_dt, c.ass_st_km, c.ass_ed_km, decode(c.lpg_yn,'1','있음','0','없음','2','탈거','없음') lpg_yn,"+
				" c.imgfile1, c.imgfile2, c.imgfile3, c.imgfile4, c.imgfile5,"+
				" n.encar_id, n.reg_dt, n.count, n.opt_value, n.d_car_amt, n.s_car_amt, n.e_car_amt, n.ea_car_amt, n.content, n.guar_no, n.day_car_amt, n.img_path, e.dlv_dt, ls36 "+
				" from car_reg a, car_etc b, apprsl c, cont e, car_nm g, CAR_MNG h, v_tot_dist vt, encar n,"+
				"      (select * from secondhand a where a.seq = (select max(seq) from secondhand where car_mng_id=a.car_mng_id) and ls36>0 and rs36>0 ) sh, "+
				"      (SELECT a.car_mng_id CAR_MNG_ID, a.seq SEQ, a.actn_st ACTN_ST, a.damdang_id DAMDANG_ID, a.hp_pr HP_PR, a.st_pr ST_PR FROM auction a WHERE a.seq = (select max(seq) from auction where car_mng_id = a.car_mng_id)) d, "+
				"      (select * from code where c_st='0039') i, "+
				"      (select * from code where c_st='0041') j  "+
				" where a.car_mng_id='"+c_id+"' and nvl(e.use_yn,'Y')='Y' and a.off_ls='1' and a.car_mng_id=e.car_mng_id and e.rent_l_cd=b.rent_l_cd"+
				" and a.car_mng_id=c.car_mng_id(+) and a.car_mng_id=d.car_mng_id(+) and a.car_mng_id=n.car_mng_id(+) and a.car_mng_id=vt.car_mng_id(+)"+
				" AND b.car_id = g.car_id 	and b.car_seq = g.car_seq  and g.car_comp_id = h.car_comp_id  and g.car_cd = h.code and a.car_mng_id=sh.car_mng_id(+) "+ 
				" and a.fuel_kd=i.nm_cd "+
				" and a.car_kd=j.nm_cd "+
				" ";

		if(!m_id.equals(""))	query += " and b.rent_mng_id='"+m_id+"' and b.rent_l_cd='"+l_cd+"'";

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
			System.out.println("[OfflshpgDatabase:getOfflshpgCase]"+e);
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
	 *	실제매매(매각된 차량) 상세 조회
	 */
	public Hashtable getOfflshpgSuiCase(String m_id, String l_cd, String c_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select g.car_comp_id, g.car_name, g.car_cd, a.car_nm, REPLACE(a.car_no,SUBSTR(a.car_no,-4),'XXXX') car_no, b.ex_gas,"+
				" i2.nm as car_kd,"+
				" substr(a.init_reg_dt,3,2)||'/'||substr(a.init_reg_dt,5,2) yearmon, substr(a.init_reg_dt,1,4) year,"+
				" a.dpm, a.car_num, b.colo, a.init_reg_dt, e.dlv_dt,"+
				" i.nm as fuel_kd,"+		
				" c.km as today_dist,"+
				" decode(b.lpg_yn,'Y','장착','N','미장착') lpg_yn, b.opt,"+
				" d.hp_pr, f.mm_pr, f.cont_dt, (b.car_cs_amt+b.car_cv_amt) car_amt, (b.opt_cs_amt+b.opt_cv_amt) opt_amt, (b.clr_cs_amt+b.clr_cv_amt) clr_amt,"+
				" (b.car_cs_amt+b.car_cv_amt+b.opt_cs_amt+b.opt_cv_amt+b.clr_cs_amt+b.clr_cv_amt) tot_amt,"+
				" c.ass_chk, c.ass_st_dt, c.ass_ed_dt, c.ass_st_km, c.ass_ed_km, decode(c.lpg_yn,'0','있음','1','없음','3','탈거','없음') lpg_yn,"+
				" n.encar_id, n.reg_dt, n.count, n.opt_value, n.d_car_amt, n.s_car_amt, n.e_car_amt, n.ea_car_amt, n.content, n.guar_no, n.day_car_amt, n.img_path, sh.ls36 "+
				" from car_reg a, car_etc b, apprsl c, auction d, cont e, car_nm g, sui f, cls_cont j, encar n,"+
				" (select * from secondhand a where a.seq = (select max(seq) from secondhand where car_mng_id=a.car_mng_id) and ls36>0 and rs36>0 ) sh, "+
				" (select car_mng_id, max(seq) seq from auction group by car_mng_id) h,"+
				" (select * from code where c_st='0039') i, "+
				" (select * from code where c_st='0041') i2 "+
				" where a.car_mng_id='"+c_id+"' and e.use_yn='N' and e.car_st='2' and b.car_id=g.car_id and a.car_mng_id=e.car_mng_id and e.rent_l_cd=b.rent_l_cd"+
				" and a.car_mng_id=c.car_mng_id and a.car_mng_id=d.car_mng_id and a.car_mng_id=f.car_mng_id and a.car_mng_id=n.car_mng_id(+)"+
				" and e.rent_mng_id=j.rent_mng_id and e.rent_l_cd=j.rent_l_cd and j.cls_st='6' and d.car_mng_id=h.car_mng_id and d.seq=h.seq"+
				" and a.fuel_kd=i.nm_cd "+
				" and a.car_kd=i2.nm_cd "+
				"  ";

		if(!m_id.equals(""))	query += " and b.rent_mng_id='"+m_id+"' and b.rent_l_cd='"+l_cd+"'";

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
			System.out.println("[OfflshpgDatabase:getOfflshpgSuiCase]"+e);
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
	 *	재리스(SECONDHAND) 상세 조회 2004.12.27.월.
	 */
	public Hashtable getSecondhandCase(String m_id, String l_cd, String c_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " SELECT /*+use_hash(d c)*/ "+
				" s.lb12, s.lb18, s.lb24, s.lb30, s.lb36, s.lb42, s.lb48,"+
				" s.ls12, s.ls18, s.ls24, s.ls30, s.ls36, s.ls42, s.ls48,"+
				" s.rb1,  s.rb2,  s.rb3,  s.rb4,  s.rb5,  s.rb6,  s.rb7,  s.rb8,  s.rb9, s.rb10, s.rb11, s.rb12, s.rb18, s.rb24, s.rb30, s.rb36, s.rb42, s.rb48,"+
				" s.rs1,  s.rs2,  s.rs3,  s.rs4,  s.rs5,  s.rs6,  s.rs7,  s.rs8,  s.rs9, s.rs10, s.rs11, s.rs12, s.rs18, s.rs24, s.rs30, s.rs36, s.rs42, s.rs48,"+
				" s.RB36_AG, s.RB24_AG, s.RB12_AG, s.RB6_AG,  "+
                " s.RS36_AG, s.RS24_AG, s.RS12_AG, s.RS6_AG,  "+
                " s.LB36_AG, s.LB24_AG, s.LB12_AG,  "+
                " s.LS36_AG, s.LS24_AG, s.LS12_AG,  "+
                " s.RM1_AG,  "+
                " s.LSMAX_AG, s.LBMAX_AG, s.RSMAX_AG, s.RBMAX_AG,  "+
				" s.real_km, s.apply_sh_pr, b.car_id, b.car_seq, g.car_comp_id, h.car_nm car_jnm, g.car_name car_nm, g.car_cd, a.car_no, b.ex_gas, a.car_kd as car_kd_cd,"+
				" f2.nm as car_kd,"+
				" substr(a.init_reg_dt,3,2)||'/'||substr(a.init_reg_dt,5,2) yearmon, substr(a.init_reg_dt,1,4) year,"+
				" a.DIST_CNG, a.dpm, a.car_use, a.car_num, b.colo, a.init_reg_dt, e.dlv_dt,"+
				" f.nm as fuel_kd, a.fuel_kd as fuel_code, "+
				" s.real_km, "+
				" c.km as today_dist,"+
				" g.car_b, b.opt, decode(b.lpg_yn,'Y','장착','N','미장착') lpg_yn, "+
				" d.hp_pr, (b.car_cs_amt+b.car_cv_amt) car_amt, (b.opt_cs_amt+b.opt_cv_amt) opt_amt, (b.clr_cs_amt+b.clr_cv_amt) clr_amt,"+
				" (b.car_cs_amt+b.car_cv_amt+b.opt_cs_amt+b.opt_cv_amt+b.clr_cs_amt+b.clr_cv_amt) tot_amt,"+
				" c.ass_chk, c.ass_st_dt, c.ass_ed_dt, c.ass_st_km, c.ass_ed_km, decode(c.lpg_yn,'1','있음','0','없음','2','탈거','없음') lpg_yn,"+
				" c.imgfile1, c.imgfile2, c.imgfile3, c.imgfile4, c.imgfile5, "+
				" s.UPLOAD_DT, s.reg_code"+
				" FROM car_reg a, car_etc b, apprsl c, cont e, car_nm g, CAR_MNG h, "+
				" (SELECT a.car_mng_id CAR_MNG_ID, a.seq SEQ, a.actn_st ACTN_ST, a.damdang_id DAMDANG_ID, a.hp_pr HP_PR, a.st_pr ST_PR FROM auction a WHERE a.seq = (select max(seq) from auction where car_mng_id = a.car_mng_id)) d, "+				
				" (select a.car_mng_id CAR_MNG_ID, a.serv_dt SERV_DT, a.tot_dist TOT_DIST  from service a where a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where car_mng_id = a.car_mng_id)) i, "+
				" (select * from secondhand a where a.seq = (select max(seq) from secondhand where reg_code is null and car_mng_id=a.car_mng_id)  ) s, "+
				" (select * from code where c_st='0039') f, "+
				" (select * from code where c_st='0041') f2 "+
				" WHERE a.car_mng_id='"+c_id+"' "+
				" and nvl(e.use_yn,'Y')='Y'"+
				" and a.car_mng_id=e.car_mng_id and e.rent_l_cd=b.rent_l_cd"+
				" and a.car_mng_id=c.car_mng_id(+) "+
				" and a.car_mng_id=d.car_mng_id(+) "+
				" and a.car_mng_id=i.car_mng_id(+) "+
				" and b.car_id=g.car_id and b.car_seq=g.car_seq and g.car_comp_id=h.car_comp_id and g.car_cd=h.code "+ 
				" and a.car_mng_id=s.car_mng_id(+) and a.fuel_kd=f.nm_cd and a.car_kd=f2.nm_cd ";

		if(!m_id.equals(""))	query += " and b.rent_mng_id='"+m_id+"' and b.rent_l_cd='"+l_cd+"'";

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
			System.out.println("[OfflshpgDatabase:getSecondhandCase]"+e);
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
	 *	대여료에 탁송료 계산
	 */
	public String getSecondHandBrAmtCalculate(int amt, int ag, int br_cons) throws DatabaseException, DataSourceEmptyException {
		int to_amt = amt + (int)Math.round(((double)br_cons / 100000 * ag) / 100) * 100;
		String result = String.valueOf(to_amt);
		return result;
	}
	
	/**
	 *	지점간이동 변수 금액
	 */
	public Hashtable getEstiCommVarSh() {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		
		query = " SELECT br_cons_00, br_cons_01, br_cons_02, br_cons_03, br_cons_04, "+
				" br_cons_10, br_cons_11, br_cons_12, br_cons_13, br_cons_14, "+
				" br_cons_20, br_cons_21, br_cons_22, br_cons_23, br_cons_24, "+
				" br_cons_30, br_cons_31, br_cons_32, br_cons_33, br_cons_34, "+
				" br_cons_40, br_cons_41, br_cons_42, br_cons_43, br_cons_44 "+
				" FROM  esti_comm_var  "+
				" WHERE a_a='1' AND seq IN (SELECT MAX(seq) seq FROM esti_comm_var WHERE a_a='1') ";		
		
		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName)/**/);
				}
			}
			
		} catch (SQLException e) {
			System.out.println("[OfflshpgDatabase:getEstiCommVarSh]"+e);
			e.printStackTrace();
		} finally {
			try{
				rs.close();
				pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}	

	/**
	 *	재리스(SECONDHAND) 상세 조회 
	 */
	public Hashtable getSecondhandCase_20090901(String m_id, String l_cd, String c_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " SELECT "+
				"        s.lb12, s.lb18, s.lb24, s.lb30, s.lb36, s.lb42, s.lb48,"+
				"        s.ls12, s.ls18, s.ls24, s.ls30, s.ls36, s.ls42, s.ls48,"+
				"        s.rb1,  s.rb2,  s.rb3,  s.rb4,  s.rb5,  s.rb6,  s.rb7,  s.rb8,  s.rb9, s.rb10, s.rb11, s.rb12, s.rb18, s.rb24, s.rb30, s.rb36, s.rb42, s.rb48,"+
				"        s.rs1,  s.rs2,  s.rs3,  s.rs4,  s.rs5,  s.rs6,  s.rs7,  s.rs8,  s.rs9, s.rs10, s.rs11, s.rs12, s.rs18, s.rs24, s.rs30, s.rs36, s.rs42, s.rs48, s.rm1, s.lsmax, s.lbmax, s.rsmax, s.rbmax, "+
			    "        s.rb36_id, s.rb24_id, s.rb12_id, s.rb6_id, "+
                "        s.rs36_id, s.rs24_id, s.rs12_id, s.rs6_id, "+
                "        s.lb36_id, s.lb24_id, s.lb12_id, "+
                "        s.ls36_id, s.ls24_id, s.ls12_id, "+
                "        s.rm1_id,  "+
                "        s.lsmax_id, s.lbmax_id, s.rsmax_id, s.rbmax_id, "+
                "        s.RB36_AG, s.RB24_AG, s.RB12_AG, s.RB6_AG,  "+
                "        s.RS36_AG, s.RS24_AG, s.RS12_AG, s.RS6_AG,  "+
                "        s.LB36_AG, s.LB24_AG, s.LB12_AG,  "+
                "        s.LS36_AG, s.LS24_AG, s.LS12_AG,  "+
                "        s.RM1_AG,  "+
                "        s.LSMAX_AG, s.LBMAX_AG, s.RSMAX_AG, s.RBMAX_AG,  "+
				"        s.real_km, s.apply_sh_pr, b.car_id, b.car_seq, g.car_comp_id, h.car_nm car_jnm, g.car_name car_nm, g.car_cd, 'XXX'||SUBSTR(a.car_no,-4) car_no, b.ex_gas, a.car_kd as car_kd_cd,"+
				"        f2.nm as car_kd,"+
				"        substr(a.init_reg_dt,3,2)||'/'||substr(a.init_reg_dt,5,2) yearmon, substr(a.init_reg_dt,1,4) year,"+
				"        a.dpm, a.car_use, a.car_num, b.colo, a.init_reg_dt, e.dlv_dt,"+
				"        f.nm as fuel_kd, a.fuel_kd as fuel_code, "+
				"        s.real_km, "+
				"        c.km as today_dist,"+
				"        g.car_b, b.opt, decode(b.lpg_yn,'Y','장착','N','미장착') lpg_yn, "+
				"        d.hp_pr, (b.car_cs_amt+b.car_cv_amt) car_amt, (b.opt_cs_amt+b.opt_cv_amt) opt_amt, (b.clr_cs_amt+b.clr_cv_amt) clr_amt,"+
				"        (b.car_cs_amt+b.car_cv_amt+b.opt_cs_amt+b.opt_cv_amt+b.clr_cs_amt+b.clr_cv_amt) tot_amt,"+
				"        c.ass_chk, c.ass_st_dt, c.ass_ed_dt, c.ass_st_km, c.ass_ed_km, decode(c.lpg_yn,'1','있음','0','없음','2','탈거','없음') lpg_yn,"+
				"        c.imgfile1, c.imgfile2, c.imgfile3, c.imgfile4, c.imgfile5, "+
				"        s.UPLOAD_DT, s.reg_code, s.max_use_mon, s.agree_dist, "+
				"        t.lkas_yn, t.ldws_yn, t.aeb_yn, t.fcw_yn, t.hook_yn, t.top_cng_yn "+
				" FROM   car_reg a, car_etc b, apprsl c, cont e, car_nm g, CAR_MNG h, cont_etc t, "+
				"        (SELECT a.car_mng_id CAR_MNG_ID, a.seq SEQ, a.actn_st ACTN_ST, a.damdang_id DAMDANG_ID, a.hp_pr HP_PR, a.st_pr ST_PR FROM auction a WHERE a.seq = (select max(seq) from auction where car_mng_id = a.car_mng_id)) d, "+				
				"        (select a.car_mng_id CAR_MNG_ID, a.serv_dt SERV_DT, a.tot_dist TOT_DIST  from service a where a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where car_mng_id = a.car_mng_id)) i, "+
				"        (select * from secondhand a where a.seq = (select max(seq) from secondhand where reg_code is not null and (agree_dist is null or agree_dist=10000) and car_mng_id=a.car_mng_id)  ) s,  "+
				"        (select * from code where c_st='0039') f, "+
				"        (select * from code where c_st='0041') f2 "+
				" WHERE a.car_mng_id='"+c_id+"' "+
				"        and nvl(e.use_yn,'Y')='Y'"+
				"        and a.car_mng_id=e.car_mng_id and e.rent_l_cd=b.rent_l_cd "+
				"        and a.car_mng_id=c.car_mng_id(+) "+
				"        and a.car_mng_id=d.car_mng_id(+) "+
				"        and a.car_mng_id=i.car_mng_id(+) "+
				"        and b.car_id=g.car_id and b.car_seq=g.car_seq and g.car_comp_id=h.car_comp_id and g.car_cd=h.code "+ 
				"        and a.car_mng_id=s.car_mng_id and a.fuel_kd=f.nm_cd and a.car_kd=f2.nm_cd ";

		if(!m_id.equals("")){
			query += " and b.rent_mng_id='"+m_id+"' and b.rent_l_cd='"+l_cd+"'";
			query += " and t.rent_mng_id='"+m_id+"' and t.rent_l_cd='"+l_cd+"'";
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
			System.out.println("[OfflshpgDatabase:getSecondhandCase]"+e);
			System.out.println("[OfflshpgDatabase:getSecondhandCase]"+query);
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
	 *	재리스(SECONDHAND) 상세 조회 
	 */
	public Hashtable getSecondhandCaseDist(String m_id, String l_cd, String c_id, String agree_dist)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " SELECT "+
				"        s.lb12, s.lb18, s.lb24, s.lb30, s.lb36, s.lb42, s.lb48,"+
				"        s.ls12, s.ls18, s.ls24, s.ls30, s.ls36, s.ls42, s.ls48,"+
				"        s.rb1,  s.rb2,  s.rb3,  s.rb4,  s.rb5,  s.rb6,  s.rb7,  s.rb8,  s.rb9, s.rb10, s.rb11, s.rb12, s.rb18, s.rb24, s.rb30, s.rb36, s.rb42, s.rb48,"+
				"        s.rs1,  s.rs2,  s.rs3,  s.rs4,  s.rs5,  s.rs6,  s.rs7,  s.rs8,  s.rs9, s.rs10, s.rs11, s.rs12, s.rs18, s.rs24, s.rs30, s.rs36, s.rs42, s.rs48, "+
				"        s.rm1, s.lsmax, s.lbmax, s.rsmax, s.rbmax, "+
			    "        s.rb36_id, s.rb24_id, s.rb12_id, s.rb6_id, "+
                "        s.rs36_id, s.rs24_id, s.rs12_id, s.rs6_id, "+
                "        s.lb36_id, s.lb24_id, s.lb12_id, "+
                "        s.ls36_id, s.ls24_id, s.ls12_id, "+
                "        s.rm1_id,  "+
                "        s.RB36_AG, s.RB24_AG, s.RB12_AG, s.RB6_AG,  "+
                "        s.RS36_AG, s.RS24_AG, s.RS12_AG, s.RS6_AG,  "+
                "        s.LB36_AG, s.LB24_AG, s.LB12_AG,  "+
                "        s.LS36_AG, s.LS24_AG, s.LS12_AG,  "+
                "        s.RM1_AG,  "+
                "        s.LSMAX_AG, s.LBMAX_AG, s.RSMAX_AG, s.RBMAX_AG,  "+
                "        s.lsmax_id, s.lbmax_id, s.rsmax_id, s.rbmax_id, "+
				"        s.real_km, s.UPLOAD_DT, s.reg_code, s.max_use_mon, s.agree_dist "+
				" FROM   "+
				"        (select * from secondhand a where a.car_mng_id='"+c_id+"' and a.seq = (select max(seq) from secondhand where car_mng_id='"+c_id+"' and agree_dist="+agree_dist+" )  ) s  ";

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
			System.out.println("[OfflshpgDatabase:getSecondhandCaseDist]"+e);
			System.out.println("[OfflshpgDatabase:getSecondhandCaseDist]"+query);
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
	 *	재리스(SECONDHAND) 상세 조회 
	 */
	public Hashtable getSecondhandCaseRm(String m_id, String l_cd, String c_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " SELECT  "+
				"        s.lb12, s.lb18, s.lb24, s.lb30, s.lb36, s.lb42, s.lb48,"+
				"        s.ls12, s.ls18, s.ls24, s.ls30, s.ls36, s.ls42, s.ls48,"+
				"        s.rb1,  s.rb2,  s.rb3,  s.rb4,  s.rb5,  s.rb6,  s.rb7,  s.rb8,  s.rb9, s.rb10, s.rb11, s.rb12, s.rb18, s.rb24, s.rb30, s.rb36, s.rb42, s.rb48,"+
				"        s.rs1,  s.rs2,  s.rs3,  s.rs4,  s.rs5,  s.rs6,  s.rs7,  s.rs8,  s.rs9, s.rs10, s.rs11, s.rs12, s.rs18, s.rs24, s.rs30, s.rs36, s.rs42, s.rs48, s.rm1, s.lsmax, s.lbmax, s.rsmax, s.rbmax, "+
				"        s.rm1, s.lsmax, s.lbmax, s.rsmax, s.rbmax, "+
			    "        s.rb36_id, s.rb24_id, s.rb12_id, s.rb6_id, "+
                "        s.rs36_id, s.rs24_id, s.rs12_id, s.rs6_id, "+
                "        s.lb36_id, s.lb24_id, s.lb12_id, "+
                "        s.ls36_id, s.ls24_id, s.ls12_id, "+
                "        s.rm1_id,  "+
                "        s.lsmax_id, s.lbmax_id, s.rsmax_id, s.rbmax_id, "+
                "        s.RB36_AG, s.RB24_AG, s.RB12_AG, s.RB6_AG,  "+
                "        s.RS36_AG, s.RS24_AG, s.RS12_AG, s.RS6_AG,  "+
                "        s.LB36_AG, s.LB24_AG, s.LB12_AG,  "+
                "        s.LS36_AG, s.LS24_AG, s.LS12_AG,  "+
                "        s.RM1_AG,  "+
                "        s.LSMAX_AG, s.LBMAX_AG, s.RSMAX_AG, s.RBMAX_AG,  "+
				"        s.real_km, s.apply_sh_pr, b.car_id, b.car_seq, g.car_comp_id, h.car_nm car_jnm, g.car_name car_nm, g.car_cd, 'XXX'||SUBSTR(a.car_no,-4) car_no, b.ex_gas, a.car_kd as car_kd_cd,"+
				"        f2.nm as car_kd,"+
				"        substr(a.init_reg_dt,3,2)||'/'||substr(a.init_reg_dt,5,2) yearmon, substr(a.init_reg_dt,1,4) year,"+
				"        a.dpm, a.car_use, a.car_num, b.colo, a.init_reg_dt, e.dlv_dt,"+
				"        f.nm as fuel_kd, a.fuel_kd as fuel_code, "+
				"        s.real_km, "+
				"        c.km as today_dist,"+
				"        g.car_b, b.opt, decode(b.lpg_yn,'Y','장착','N','미장착') lpg_yn, "+
				"        d.hp_pr, (b.car_cs_amt+b.car_cv_amt) car_amt, (b.opt_cs_amt+b.opt_cv_amt) opt_amt, (b.clr_cs_amt+b.clr_cv_amt) clr_amt,"+
				"        (b.car_cs_amt+b.car_cv_amt+b.opt_cs_amt+b.opt_cv_amt+b.clr_cs_amt+b.clr_cv_amt) tot_amt,"+
				"        c.ass_chk, c.ass_st_dt, c.ass_ed_dt, c.ass_st_km, c.ass_ed_km, decode(c.lpg_yn,'1','있음','0','없음','2','탈거','없음') lpg_yn,"+
				"        c.imgfile1, c.imgfile2, c.imgfile3, c.imgfile4, c.imgfile5, "+
				"        s.UPLOAD_DT, s.reg_code, s.max_use_mon "+
				" FROM   car_reg a, car_etc b, apprsl c, cont e, car_nm g, CAR_MNG h, "+
				"        (SELECT a.car_mng_id CAR_MNG_ID, a.seq SEQ, a.actn_st ACTN_ST, a.damdang_id DAMDANG_ID, a.hp_pr HP_PR, a.st_pr ST_PR FROM auction a WHERE a.seq = (select max(seq) from auction where car_mng_id = a.car_mng_id)) d, "+				
				"        (select a.car_mng_id CAR_MNG_ID, a.serv_dt SERV_DT, a.tot_dist TOT_DIST  from service a where a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where car_mng_id = a.car_mng_id)) i, "+
				"        (select * from secondhand a where a.seq = (select max(seq) from secondhand where rm1>0 and reg_code is not null and (agree_dist is null or agree_dist=20000) and car_mng_id=a.car_mng_id)  ) s, "+
				"        (select * from code where c_st='0039') f, "+
				"        (select * from code where c_st='0041') f2 "+
				" WHERE a.car_mng_id='"+c_id+"' "+
				"        and nvl(e.use_yn,'Y')='Y'"+ 
				"        and a.car_mng_id=e.car_mng_id and e.rent_l_cd=b.rent_l_cd  "+
				"        and a.car_mng_id=c.car_mng_id(+) "+
				"        and a.car_mng_id=d.car_mng_id(+) "+
				"        and a.car_mng_id=i.car_mng_id(+) "+
				"        and b.car_id=g.car_id and b.car_seq=g.car_seq and g.car_comp_id=h.car_comp_id and g.car_cd=h.code "+ 
				"        and a.car_mng_id=s.car_mng_id and a.fuel_kd=f.nm_cd and a.car_kd=f2.nm_cd ";

		if(!m_id.equals(""))	query += " and b.rent_mng_id='"+m_id+"' and b.rent_l_cd='"+l_cd+"'";

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
			System.out.println("[OfflshpgDatabase:getSecondhandCase]"+e);
			System.out.println("[OfflshpgDatabase:getSecondhandCase]"+query);
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
	 *	차량이력표
	 */
	public Vector getCarHisList(String c_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select  a.firm_nm, to_char(to_date(a.reg_dt,'YYYYMMDD')+1, 'YYYYMMDD') reg_dt,"+
				" c.rent_start_dt, a.rent_end_dt, nvl(b.mgr_title,'중역') mgr_title, cc.cls_st, cc.cls_dt"+
				" from cont_n_view a, car_mgr b, fee c, cls_cont cc "+
				" where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.mgr_st='차량이용자'"+
				" and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and c.rent_st='1'"+
				" and a.rent_mng_id=cc.rent_mng_id(+) and a.rent_l_cd=cc.rent_l_cd(+) " + 
				" and a.car_mng_id='"+c_id+"'";

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
			System.out.println("[OfflshpgDatabase:getCarHisList]"+e);
			e.printStackTrace();
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
	 *	조회수 증가
	 */
	public void updateCount(String c_id)
	{
		getConnection();
		PreparedStatement pstmt = null;

		String query = "update encar set count=count+1 where car_mng_id = '"+c_id+"'";			

		try 
		{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
		    pstmt.executeUpdate();
			pstmt.close();
		    conn.commit();
		    
		 }catch(Exception se){
           try{
				System.out.println("[OfflshpgDatabase:updateCount]"+se);
				se.printStackTrace();
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

	/*
	*	페이지별 리스트 보기 2004.04.07.
	*/
	public void setPagesize(int pagesize){
		this.pagesize = pagesize;
	}
	public int getPagesize(){
		return pagesize;
	}
	public int getTotalpage(){
		totalpage = totalsize / pagesize;
		if((totalsize % pagesize) != 0){
			totalpage++;
		}
		return totalpage;
	}
	public int getTotalsize(){
		return totalsize;
	}

	/*
	*	마이링커 신규 매물 _--------페이지별 리스트 보기 2004.11.5
	*/
	public void setPagesize_new(int pagesize_new){
		this.pagesize_new = pagesize_new;
	}
	public int getPagesize_new(){
		return pagesize_new;
	}
	public int getTotalpage_new(){
		totalpage_new = totalsize_new / pagesize_new;
		if((totalsize_new % pagesize_new) != 0){
			totalpage_new++;
		}
		return totalpage_new;
	}
	public int getTotalsize_new(){
		return totalsize_new;
	}

	/*
	*	페이지별 리스트 보기 2004.04.07.
	*/
	public void setPagesize_old(int pagesize_old){
		this.pagesize_old = pagesize_old;
	}
	public int getPagesize_old(){
		return pagesize_old;
	}
	public int getTotalpage_old(){
		totalpage_old = totalsize_old / pagesize_old;
		if((totalsize_old % pagesize_old) != 0){
			totalpage_old++;
		}
		return totalpage_old;
	}
	public int getTotalsize_old(){
		return totalsize_old;
	}

	/*
	*	재리스 --------페이지별 리스트 보기 2004.12.27.
	*/
	public void setPagesize_sh(int pagesize_sh){
		this.pagesize_sh = pagesize_sh;
	}
	public int getPagesize_sh(){
		return pagesize_sh;
	}
	public int getTotalpage_sh(){
		totalpage_sh = totalsize_sh / pagesize_sh;
		if((totalsize_sh % pagesize_sh) != 0){
			totalpage_sh++;
		}
		return totalpage_sh;
	}
	public int getTotalsize_sh(){
		return totalsize_sh;
	}


  /**
	 *	정비이력표
	 */
	public Vector getServCarHisList(String c_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.car_mng_id CAR_MNG_ID, a.serv_id SERV_ID, a.accid_id ACCID_ID, a.rent_mng_id RENT_MNG_ID, a.rent_l_cd RENT_L_CD, a.off_id OFF_ID, b.off_nm OFF_NM, "+
				" decode(serv_st,'4',a.accid_dt,a.serv_dt) SERV_DT, a.serv_st SERV_ST, a.checker CHECKER, a.tot_dist TOT_DIST, "+
				" a.rep_nm REP_NM, a.rep_tel REP_TEL, a.rep_m_tel REP_M_TEL, "+
				" a.rep_amt REP_AMT, a.sup_amt SUP_AMT, a.add_amt ADD_AMT, a.dc DC, a.tot_amt TOT_AMT, "+
				" nvl2(a.sup_dt,substr(a.sup_dt,1,4)||'-'||substr(a.sup_dt,5,2)||'-'||substr(a.sup_dt,7,2),'') SUP_DT, "+
				" nvl2(a.set_dt,substr(a.set_dt,1,4)||'-'||substr(a.set_dt,5,2)||'-'||substr(a.set_dt,7,2),'') SET_DT, "+
				" a.bank BANK, a.acc_no ACC_NO, a.acc_nm ACC_NM, a.rep_item REP_ITEM, a.rep_cont REP_CONT, "+
				" nvl2(a.cust_plan_dt,substr(a.cust_plan_dt,1,4)||'-'||substr(a.cust_plan_dt,5,2)||'-'||substr(a.cust_plan_dt,7,2),'') CUST_PLAN_DT, "+
				" a.cust_amt CUST_AMT, a.cust_agnt CUST_AGNT, a.accid_dt ACCID_DT, a.bill_doc_yn, a.bill_mon, a.serv_jc SERV_JC, a.cust_serv_dt CUST_SERV_DT, "+
				" nvl(a.next_serv_dt,a.serv_dt) NEXT_SERV_DT, a.next_rep_cont NEXT_REP_CONT, a.spdchk SPDCHK, "+
				" a.ipgoza IPGOZA, a.ipgodt IPGODT, a.chulgoza CHULGOZA, a.chulgodt CHULGODT, a.spdchk_dt SPDCHK_DT, a.checker_st CHECKER_ST, "+
				" a.cust_act_dt, a.cust_nm, a.cust_tel, a.cust_rel, a.reg_id, a.update_id, a.r_labor, a.r_amt, a.r_dc, a.r_j_amt ,a.jung_st, a.r_dc_per, "+
				"  '' scan_file, a.estimate_num , a.sh_amt , a.call_t_nm, a.call_t_tel, c.firm_nm, "+
				" decode(a.serv_st,'1','순회점검','2','일반수리','3','보증수리','4','운행자차','5','사고자차','7','재리스수리') serv_st_nm "
				+ "FROM service a, serv_off b, cont_n_view c "
				+ "WHERE a.car_mng_id='"+c_id+"' and a.serv_st not in ('4','5') "
				+ "AND a.off_id=b.off_id(+) "
				+ "AND a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd "
				+ "and a.serv_id not like 'NN%' "
				+ " ORDER BY a.serv_dt ";

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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName)/**/);
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[OfflshpgDatabase:getServCarHisList]"+e);
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )			rs.close();
				if(pstmt != null )		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}	

	 /**
	 *	사고이력표
	 */
	public Vector getAccidCarHisList(String c_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select   "+
				"        a.car_mng_id, a.rent_mng_id, a.rent_l_cd, b.client_id, b.firm_nm, b.client_nm, c.car_no, c.car_nm, cn.car_name, b.use_yn,"+
				"        a.accid_id, a.accid_st, a.accid_dt, a.accid_addr, a.accid_cont, a.accid_cont2, a.reg_id,"+
				"        decode(a.accid_st, '1','피해자','2','가해자','3','쌍방','4','운행자차','5','사고자차','6','수해','7','재리스정비') accid_st_nm, "+
				"        a.our_num, a.settle_st, h.pic_cnt,"+
				"        decode(i.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트') res_st,"+
				"        decode(i.cust_st, '1',j.firm_nm, '4',k.user_nm,l.cust_nm) cust_nm, "+
				"        n.serv_id, n.tot_amt, b.bus_id2, a.rent_s_cd, a.sub_etc, a.DAM_TYPE1, a.DAM_TYPE2, a.DAM_TYPE3, a.DAM_TYPE4, a.reg_id "+
				" from   accident a, cont_n_view b, car_reg c,  car_etc g, car_nm cn ,  insur e, (select car_mng_id, max(ins_st) ins_st from insur group by car_mng_id) f, ins_com g, "+
				"        (select car_mng_id, accid_id, count(0) pic_cnt from pic_accid group by car_mng_id, accid_id) h, "+
				"        rent_cont i, client j, users k, rent_cust l, "+
				"		 (select * from service where serv_id not like 'NN%') n "+
				" where  a.car_mng_id='"+c_id+"' and a.accid_st not in ('7') "+
				"        and a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd "+
				"        and a.car_mng_id=e.car_mng_id "+
				"	and a.car_mng_id = c.car_mng_id  and a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+)  \n"+
                       		"	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+)  \n"+
				"        and e.car_mng_id=f.car_mng_id and e.ins_st=f.ins_st and e.ins_com_id=g.ins_com_id"+
				"        and a.car_mng_id=h.car_mng_id(+) and a.accid_id=h.accid_id(+)"+
				"        and a.car_mng_id=i.car_mng_id(+) and a.rent_s_cd=i.rent_s_cd(+) "+
				"        and i.cust_id=j.client_id(+) and i.cust_id=k.user_id(+) and i.cust_id=l.cust_id(+)"+
				"        and a.car_mng_id=n.car_mng_id(+) and a.rent_mng_id=n.rent_mng_id(+) and a.rent_l_cd=n.rent_l_cd(+) and a.accid_id=n.accid_id(+) "+
				" order by a.accid_dt" ;

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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName)/**/);
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[OfflshpgDatabase:getAccidCarHisList]"+e);
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )			rs.close();
				if(pstmt != null )		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}	


	  /**
	 *	사고이력표 - 정비
	 */
	public Vector getServItemCarHisList(String car_mng_id, String serv_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

        query = "   SELECT car_mng_id, serv_id, seq_no, item, bpm, count, price, amt, labor\n" 
				+ " FROM   serv_item\n"
				+ " WHERE  car_mng_id='"+car_mng_id+"'\n"
				+ " AND    serv_id='"+serv_id+"' and item not like '%작업%항목%' \n";

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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName)/**/);
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[OfflshpgDatabase:getServItemCarHisList]"+e);
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )			rs.close();
				if(pstmt != null )		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}	

  /****************************************************************************************
	*******************************************   smart
    ****************************************************************************************/

		/**
	 *	재리스 리스트 : 검색항목 및 정렬 변경
	 */
	public Vector getSecondhandList_20100930(String gubun1, String sort){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		this.totalsize_sh = 0;
		String query = "";

		query = " SELECT \n"+
				"        b.rent_mng_id, b.rent_l_cd, a.car_mng_id, a.car_no, 'XXX'||SUBSTR(a.car_no,-4) ab_car_no, \n"+
				"        c.imgfile1, c.imgfile6, h.car_nm car_jnm, g.car_name car_nm, a.dpm, b.colo, \n"+
				"	     substr(a.init_reg_dt,1,4)||'년'||substr(a.init_reg_dt,5,2)||'월' init_reg_dt, s.real_km, \n"+
				"        d.nm as fuel_kd,"+
				"        decode(s.rb36, 0,s.lb36, -1,s.lb36, s.rb36) fee_amt, "+
				"        decode(s.rb30, 0,s.lb30, -1,s.lb30, s.rb30) fee_amt_30, "+
				"        j.sh_code, \n"+
				"        /*네  고*/decode(sr.situation,'0','상담중','1','계약진행중','2','계약확정','3','계약연동','예약가능') situation,  \n"+
				"        decode(nvl(hh.rent_st,ii.rent_st),'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','대기') rent_st, "+ 
				"        nvl( hh.ret_plan_dt, ii.ret_plan_dt ) AS ret_plan_dt\n"+
				" from   car_reg a, cont e, car_etc b, apprsl c, car_nm g, car_mng h, \n"+
				"        (select a.* from esti_jg_var a where a.seq = (select max(seq) from esti_jg_var where sh_code=a.sh_code)) j, \n"+
				"        (select a.* from secondhand a  where a.seq = (select max(seq) from secondhand  where reg_code is not null and car_mng_id=a.car_mng_id)) s, \n"+
				"        (select a.* from sh_res a      where a.use_yn='Y' and a.situation in ('0','2')) sr, \n"+
				"        (select * from rent_cont a  where a.use_st = '2' and a.rent_st<>'11') hh,"+
				"		 (select * from rent_cont a  where a.use_st = '1' and a.rent_st<>'11') ii,"+
				"        (select * from code where c_st='0039') d "+
				" where  a.car_mng_id=e.car_mng_id and a.car_mng_id = hh.car_mng_id(+) and a.car_mng_id = ii.car_mng_id(+) \n"+
				"        and e.use_yn='Y' "+
				"        and e.car_st='2' and a.secondhand = '1' \n"+
				"        and nvl(a.off_ls,'0') in ('0','1') "+			//출품전까지 20100126
				"        and nvl(a.prepare,'0')<>'7'"+
				"        and e.rent_mng_id=b.rent_mng_id and e.rent_l_cd=b.rent_l_cd \n"+
				"        and a.car_mng_id=c.car_mng_id(+) \n"+
				"        and b.car_id=g.car_id and b.car_seq=g.car_seq \n"+
				"        and g.car_comp_id=h.car_comp_id and g.car_cd=h.code \n"+
				"        and g.jg_code=j.sh_code \n"+
				"        and a.car_mng_id = s.car_mng_id \n"+
				"        and a.car_mng_id = sr.car_mng_id(+) and a.fuel_kd=d.nm_cd \n"+
				" ";

		//월렌트계약만료5일전것만 나옴
		query += " and decode(hh.rent_st,'12',to_char(to_date(substr(hh.ret_plan_dt,1,8),'YYYYMMDD')-5,'YYYYMMDD'), to_char(sysdate,'YYYYMMDD')) <= to_char(sysdate,'YYYYMMDD')";

 
		if(gubun1.equals("1"))			query += " and g.jg_code like '4%' and g.car_comp_id <= '0005' and a.fuel_kd not in ('3','5','6')"; //대형승용
		else if(gubun1.equals("2"))		query += " and g.jg_code like '3%' and g.car_comp_id <= '0005' and a.fuel_kd not in ('3','5','6')"; //중형승용
		else if(gubun1.equals("3"))		query += " and g.jg_code between '1000000' and '2999999' and g.car_comp_id <= '0005' and a.fuel_kd not in ('3','5','6')"; //소형승용
		else if(gubun1.equals("4"))		query += " and g.jg_code like '4%' and g.car_comp_id <= '0005' and a.fuel_kd in ('3','5','6')"; //대형승용LPG
		else if(gubun1.equals("5"))		query += " and g.jg_code like '3%' and g.car_comp_id <= '0005' and a.fuel_kd in ('3','5','6')"; //중형승용LPG
		else if(gubun1.equals("8"))		query += " and g.jg_code between '1000000' and '2999999' and g.car_comp_id <= '0005' and a.fuel_kd in ('3','5','6')"; //소형승용LPG
		else if(gubun1.equals("6"))		query += " and g.jg_code between '5000000' and '9999999' and g.car_comp_id <= '0005' "; //국산 RV및기타(승합,화물)
		else if(gubun1.equals("7"))		query += " and g.car_comp_id > '0005' "; //수입차
		
		if(sort.equals("1")){
			query += " order by decode(nvl(sr.situation,'0'),'2',1,0), d.nm, ";
		}else if(sort.equals("2")){
			query += " order by decode(nvl(sr.situation,'0'),'2',1,0), b.colo, ";
		}else if(sort.equals("3")){
			query += " order by decode(nvl(sr.situation,'0'),'2',1,0), a.init_reg_dt, ";
		}else if(sort.equals("4")){
			query += " order by decode(nvl(sr.situation,'0'),'2',1,0), to_number(s.real_km), ";
		}else if(sort.equals("5")){
			query += " order by decode(nvl(sr.situation,'0'),'2',1,0), decode(s.rb36, 0,s.lb36, -1,s.lb36, s.rb36), ";
		}else{
			query += " order by decode(nvl(sr.situation,'0'),'2',1,0), ";
		}

		//20101021 : 소형LPG,중형LPG,대형LPG,소형,중형,대형,RV,수입 순으로 정렬 변경	
		query += "     decode(g.car_comp_id, '0001',0, '0002',0, '0003',0, '0004',0, '0005',0, 1), "+ //국내차량 위, 수입차량 아래로
				 "     decode(a.fuel_kd, '3',0, '5',0, '6',0, 1), "+
	             "     g.jg_code, g.car_b_p, g.car_name, a.init_reg_dt, a.car_mng_id ";

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
				this.totalsize_sh++;
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[OfflshpgDatabase:getSecondhandList_20100930]"+e);
			System.out.println("[OfflshpgDatabase:getSecondhandList_20100930]"+query);
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )			rs.close();
				if(pstmt != null )		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	public Vector getSecondhandRandomList(String gubun){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		this.totalsize_sh = 0;
		String query = "";
	

		query = " SELECT b.rent_mng_id, b.rent_l_cd, a.car_mng_id, a.car_no, 'XXX'||SUBSTR(a.car_no,-4) ab_car_no, c.imgfile1, h.car_nm || g.car_name car_nm, a.dpm, b.colo, substr(a.init_reg_dt,1,4)||'년 '||substr(a.init_reg_dt,5,2)||'월' init_reg_dt, s.real_km,"+
				" decode(s.rb36, 0,s.lb36, -1,s.lb36, s.rb36) fee_amt "+ //s.ls36, s.lb36, s.rs36, 
				" from car_reg a, car_etc b, apprsl c, cont e, car_nm g, CAR_MNG h,  "+
				" 	 ( select * from secondhand a where a.seq = (select max(seq) from secondhand where car_mng_id=a.car_mng_id)  ) s,  "+
				"	  (select * from sh_res a where a.seq = (select max(seq) from sh_res where car_mng_id = a.car_mng_id) ) sr "+
				" where e.use_yn='Y' and e.car_st='2' and nvl(a.off_ls,'0') in ('0')  "+//a.off_ls in ('0','1')
				" and b.car_id=g.car_id and b.car_seq = g.car_seq "+
				" and a.car_mng_id=e.car_mng_id  "+
				" and e.rent_mng_id = b.rent_mng_id and e.rent_l_cd=b.rent_l_cd "+
				" and a.car_mng_id=c.car_mng_id(+) and c.imgfile1 is not null  "+
				" and g.car_comp_id = h.car_comp_id  "+
				" and g.car_cd = h.code "+
				" and a.car_mng_id = s.car_mng_id "+
				" and a.car_mng_id = sr.car_mng_id(+) "+
				" and a.secondhand = '1' and nvl(sr.situation,'0')<>'2'";

		
		//정렬

		query += " ORDER BY dbms_random.value ";

		//query += " ORDER BY decode(sr.situation,'',1,'0',2,'1',3,'2',4), a.fuel_kd, a.dpm desc, h.car_nm, g.car_name";
				 
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next() )
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);
				this.totalsize_sh++;
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[OfflshpgDatabase:getSecondhandList]"+e);
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )			rs.close();
				if(pstmt != null )		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}


//재리스차량예약상태
	public Vector getShResList(String car_mng_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.car_mng_id, a.seq, a.damdang_id, a.situation, a.reg_dt, a.res_st_dt, a.res_end_dt, nvl(a.use_yn,'') use_yn, a.memo, b.user_nm, b.user_m_tel "+
				" from   sh_res a, users b "+
				" where  a.car_mng_id='"+car_mng_id+"' and nvl(a.use_yn,'Y')='Y' and a.situation in ('0','2') and a.damdang_id=b.user_id"+
				" order by seq";

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
			System.out.println("[OfflshpgDatabase:getShResList]\n"+e);
			System.out.println("[OfflshpgDatabase:getShResList]\n"+query);
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
	*	재리스 차량 기본데이터
	*/
	public Hashtable getShBase(String car_mng_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();

		String query =  " select * from sh_base where car_mng_id=?"+
						" ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
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
			System.out.println("[OfflshpgDatabase:getShBase]"+e);
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
	 *	검사이력표
	 */
	public Vector getMaintCarHisList(String c_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

        query = "   SELECT  a.car_mng_id as CAR_MNG_ID,a.seq_no as SEQ_NO,a.che_kd as CHE_KD, \n"
				+ "         decode(a.che_st_dt,null,'',substr(a.che_st_dt,1,4)||'-'||substr(a.che_st_dt,5,2)||'-'||substr(a.che_st_dt,7,2)) as CHE_ST_DT, \n"
				+ "         decode(a.che_end_dt,null,'',substr(a.che_end_dt,1,4)||'-'||substr(a.che_end_dt,5,2)||'-'||substr(a.che_end_dt,7,2)) as CHE_END_DT, \n"
				+ "         decode(a.che_dt,null,'',substr(a.che_dt,1,4)||'-'||substr(a.che_dt,5,2)||'-'||substr(a.che_dt,7,2)) as CHE_DT, \n"
				+ "         a.che_no as CHE_NO,a.che_comp as CHE_COMP, a.che_amt CHE_AMT, a.che_km CHE_KM \n"
				+ " FROM car_maint a\n"
				+ " where  a.car_mng_id='" + c_id + "' order by a.che_dt desc\n";


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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName)/**/);
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[OfflshpgDatabase:getMaintCarHisList]"+e);
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )			rs.close();
				if(pstmt != null )		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}	


 /**
	 *	사고이력표 - 정비
	 */
	public Vector getServItemCarHisList(String car_mng_id, String serv_id, String accid_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

        query = "   SELECT car_mng_id, serv_id, seq_no, item, bpm, count, price, amt, labor\n" 
				+ " FROM   serv_item\n"
				+ " WHERE  car_mng_id='"+car_mng_id+"'\n"
				+ " and item not like '%작업%항목%' \n";

		if(!serv_id.equals("") && accid_id.equals(""))		query += " AND    serv_id='"+serv_id+"' ";

		if(!accid_id.equals(""))	query += " AND    serv_id in (select serv_id from service where car_mng_id='"+car_mng_id+"' and accid_id='"+accid_id+"') ";

		query += " order by serv_id, seq_no ";

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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName)/**/);
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[OfflshpgDatabase:getServItemCarHisList]"+e);
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )			rs.close();
				if(pstmt != null )		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}	


//두날짜 기간 조회
	public Hashtable getYearMonthDay3(String st_dt, String end_dt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
	
		query = " select sdt, edt , floor(months_between(edt, sdt)) as months , ceil(mod(months_between(edt, sdt)*31, 31)) as days "+
				" from (select to_date('"+st_dt+"', 'yyyymmdd') sdt, to_date('"+end_dt+"', 'yyyymmdd')+1 edt from dual) ";


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
			System.out.println("[AddClsDatabase:getYearMonthDay3]\n"+e);			
			System.out.println("[AddClsDatabase:getYearMonthDay3]\n"+query);			
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

	//두날짜 기간 조회
	public Hashtable getYearMonthDay4(String st_dt, String end_dt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
			
	query = " SELECT "+
				" trunc(months_between(to_date('"+end_dt+"', 'yyyymmdd'), to_date('"+st_dt+"', 'yyyymmdd'))+1/31, 0) AS MONTHS "+
				",trunc(months_between(to_date('"+end_dt+"', 'yyyymmdd'), to_date('"+st_dt+"', 'yyyymmdd'))+1/31 "+
				"  - trunc(months_between(to_date('"+end_dt+"', 'yyyymmdd'), to_date('"+st_dt+"', 'yyyymmdd'))+1/31, 0)) * 31 AS DAYS "+
				"  FROM dual ";



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
			System.out.println("[AddClsDatabase:getYearMonthDay4]\n"+e);			
			System.out.println("[AddClsDatabase:getYearMonthDay4]\n"+query);			
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


public Vector getMrent_Cars2_nm(String gubun2, String gubun, String gubun_nm, String brch_id, String sort_gubun, String res_yn, String res_mon_yn, String all_car_yn, int r_mon, int r_day)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String res_mon_order = "";

		query = " select DISTINCT DECODE(SUBSTR( d.jg_code,2,1),'1','현대','2','기아','3','한국GM','4','쌍용','5','삼성') COM_NM, B.CAR_NM, d.CAR_COMP_ID, b.FUEL_KD \n"+
				" from   cont a, car_reg b, car_etc c, car_nm d, apprsl e, cont_etc n, \n"+
				"        (select * from secondhand a where a.seq = (select max(seq) from secondhand where car_mng_id=a.car_mng_id)) f, \n"+
				"        (select * from sh_res a     where a.use_yn='Y' and a.situation in ('0','2')) g, \n"+ //(보유차등록일 이후의 상담건만 출력)
				"        (select a.car_mng_id, count(0) res_cnt from sh_res a     where a.use_yn is null and a.situation in ('0','2') group by a.car_mng_id) g2, \n"+ //(보유차등록일 이후의 상담건만 출력)
				"        (select * from rent_cont a  where a.use_st = '2' and a.rent_st <>'11') h, \n"+//배차
				"        (select * from rent_cont a  where a.use_st = '1' and a.rent_st<>'11') i, \n"+//예약
				"        PARK_CONDITION p,  (SELECT sh_code, jg_v, seq FROM (SELECT sh_code, jg_v, seq, ROW_NUMBER() over(PARTITION BY sh_code ORDER BY SEQ desc) rn FROM ESTI_JG_VAR ) a  WHERE rn = 1	) q  \n"+
				" where "+
				"        nvl(a.use_yn,'Y')='Y' and a.car_st IN ('2','4')  \n"+
				"        and nvl(b.prepare,'0')<>'9' \n"+				//9-미회수차량
				"		 and nvl(b.rm_yn, 'Y') <> 'N' "+				//월렌트비대상	
				"        and nvl(b.off_ls,'0') in ('0') \n"+			//출품전까지 20100126
				"        and a.car_mng_id=b.car_mng_id \n"+
				"        and a.rent_l_cd=c.rent_l_cd \n"+
				"        and c.car_id=d.car_id and c.car_seq=d.car_seq \n"+
				"        and b.car_mng_id=e.car_mng_id(+) \n"+
				"        and a.rent_mng_id=n.rent_mng_id(+) \n"+
				"		 and a.rent_l_cd=n.rent_l_cd(+) \n"+						
				"        and b.car_mng_id=f.car_mng_id(+) \n"+
				"        and b.car_mng_id=g.car_mng_id(+) \n"+
				"        and b.car_mng_id=g2.car_mng_id(+) \n"+
				"        and b.car_mng_id=h.car_mng_id(+) \n"+
				"        and b.car_mng_id=i.car_mng_id(+) \n"+
				"        and a.car_mng_id=p.car_mng_id(+)  \n"+
				"		 AND d.JG_CODE = q.sh_code(+) \n"+
				"		 and nvl(g.situation,'-') not in ('2') and b.off_ls <> '1'  "; //상담중 제외


			//월렌트차량	//월렌트계약만료7일전것만 나옴 //매각예정차량 제외
			query += " and b.car_use='1'  and nvl(b.prepare,'0') in('0','1','2','7')  ";

			//차명
		//if(!gubun_nm.equals(""))			query += " and b.car_nm like '%"+gubun_nm+"%' ";


		//전체 "", 즉시 = "2", 7일이내 = "1"
		if(!gubun.equals("")){			query += " and decode(nvl(h.rent_st,i.rent_st),'12',to_char(to_date(substr(h.ret_plan_dt,1,8),'YYYYMMDD')-5,'YYYYMMDD'), to_char(sysdate,'YYYYMMDD')) <= to_char(sysdate,'YYYYMMDD') ";	
										query += " AND decode(nvl(h.rent_st,i.rent_st),'1',to_char(to_date(substr(h.ret_plan_dt,1,8),'YYYYMMDD')-5,'YYYYMMDD'), to_char(sysdate,'YYYYMMDD')) <= to_char(sysdate,'YYYYMMDD') ";	
										query += " AND decode(nvl(h.rent_st,i.rent_st),'2',to_char(to_date(substr(h.ret_plan_dt,1,8),'YYYYMMDD')-5,'YYYYMMDD'), to_char(sysdate,'YYYYMMDD')) <= to_char(sysdate,'YYYYMMDD') ";	
										query += " AND decode(nvl(h.rent_st,i.rent_st),'3',to_char(to_date(substr(h.ret_plan_dt,1,8),'YYYYMMDD')-5,'YYYYMMDD'), to_char(sysdate,'YYYYMMDD')) <= to_char(sysdate,'YYYYMMDD') ";	
										query += " AND decode(nvl(h.rent_st,i.rent_st),'9',to_char(to_date(substr(h.ret_plan_dt,1,8),'YYYYMMDD')-5,'YYYYMMDD'), to_char(sysdate,'YYYYMMDD')) <= to_char(sysdate,'YYYYMMDD') ";	
										query += " AND decode(nvl(h.rent_st,i.rent_st),'10',to_char(to_date(substr(h.ret_plan_dt,1,8),'YYYYMMDD')-5,'YYYYMMDD'), to_char(sysdate,'YYYYMMDD')) <= to_char(sysdate,'YYYYMMDD')   ";	                  
		}

		if(gubun.equals("1"))			query += " and decode(nvl(h.rent_st,i.rent_st),'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트','대기')  IN('대기','차량정비','월렌트','단기대여','정비대차','사고대차','보험대차','지연대차')  ";

		if(gubun.equals("2"))			query += " and g.situation is null /*and p.park_id IS NOT NULL */ and decode(nvl(h.rent_st,i.rent_st),'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트','대기') = '대기'  AND decode(b.rm_st,'3','수리요','즉시') = '즉시'";

		if(brch_id.equals("S1"))			query += " and decode(b.park,'1','S1','2','S1','3','B1','4','D1','5','S1','7','B1','8','B1','9','D1','12','J1','13','G1', nvl(n.mng_br_id,a.brch_id)) = 'S1' ";
		if(brch_id.equals("B1"))			query += " and decode(b.park,'1','S1','2','S1','3','B1','4','D1','5','S1','7','B1','8','B1','9','D1','12','J1','13','G1', nvl(n.mng_br_id,a.brch_id)) = 'B1' ";
		if(brch_id.equals("D1"))			query += " and decode(b.park,'1','S1','2','S1','3','B1','4','D1','5','S1','7','B1','8','B1','9','D1','12','J1','13','G1', nvl(n.mng_br_id,a.brch_id)) = 'D1' ";
		if(brch_id.equals("J1"))			query += " and decode(b.park,'1','S1','2','S1','3','B1','4','D1','5','S1','7','B1','8','B1','9','D1','12','J1','13','G1', nvl(n.mng_br_id,a.brch_id)) = 'J1' ";
		if(brch_id.equals("G1"))			query += " and decode(b.park,'1','S1','2','S1','3','B1','4','D1','5','S1','7','B1','8','B1','9','D1','12','J1','13','G1', nvl(n.mng_br_id,a.brch_id)) = 'G1' ";

		if(gubun2.equals("1"))			query += " and d.jg_code like '4%' and d.car_comp_id <= '0005' and b.fuel_kd not in ('3','5','6')"; //대형승용
		else if(gubun2.equals("2"))		query += " and d.jg_code like '3%' and d.car_comp_id <= '0005' and b.fuel_kd not in ('3','5','6')"; //중형승용
		else if(gubun2.equals("3"))		query += " and d.jg_code between '1000000' and '2999999' and d.car_comp_id <= '0005' and b.fuel_kd not in ('3','5','6')"; //소형승용
		else if(gubun2.equals("4"))		query += " and d.jg_code like '4%' and d.car_comp_id <= '0005' and b.fuel_kd in ('3','5','6')"; //대형승용LPG
		else if(gubun2.equals("5"))		query += " and d.jg_code between '1000000' and '3999999' and d.car_comp_id <= '0005' and b.fuel_kd in ('3','5','6')"; //소형승용LPG
		else if(gubun2.equals("8"))		query += " and d.jg_code between '1000000' and '3999999' and d.car_comp_id <= '0005' and b.fuel_kd in ('3','5','6')"; //소형승용LPG
		else if(gubun2.equals("6"))		query += " and d.jg_code between '5000000' and '9999999' and d.car_comp_id <= '0005' "; //국산 RV및기타(승합,화물)
		else if(gubun2.equals("7"))		query += " and d.car_comp_id > '0005' "; //수입차
		


				query += 	" ORDER BY 3 ";

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
			System.out.println("[OfflshpgDatabase:getMrent_Cars2_nm]\n"+e);
			System.out.println("[OfflshpgDatabase:getMrent_Cars2_nm]\n"+query);
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


	//재리스차량현황 - 월렌트계약 분리  // 67번에서 copy
	public Vector getSecondhandMonthsList_20131210(String gubun2, String gubun, String gubun_nm, String brch_id, String sort_gubun, String res_yn, String res_mon_yn, String all_car_yn, int r_mon, int r_day)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String res_mon_order = "";

		query = " select CASE WHEN "+r_mon+" = 1 THEN (0.04 * "+r_day+" / 30) WHEN "+r_mon+" = 2 THEN 0.04 + 0.02 * "+r_day+" / 30 WHEN "+r_mon+" > 2 THEN 0.06 END PER, \n"+
				" decode(b.park,'1','S1','2','S1','3','B1','4','D1','5','S1','7','B1','8','B1','9','D1','12','J1','13','G1', nvl(n.mng_br_id,a.brch_id)) br_id, f.apply_sh_pr, f.reg_code, q.jg_v, a.rent_mng_id, a.rent_l_cd, b.car_mng_id, b.car_no,  \n"+
				"  b.car_nm, b.car_use, b.secondhand, d.car_name, SUBSTR(b.init_reg_dt, 0, 4)||'년' ||SUBSTR(b.init_reg_dt, 5, 2)||'월' AS init_reg_dt,  \n"+
				" b.dpm, cd2.nm as fuel_kd,  \n"+
				" 'XXX'||SUBSTR(b.car_no,-4) ab_car_no, f.real_km, c.colo||decode(c.in_col,'','','(내장:'||c.in_col||')')||decode(c.garnish_col,'','','(가니쉬:'||c.garnish_col||')') AS colo, \n"+
				" NVL(nvl(h.ret_plan_dt,i.ret_plan_dt),r.use_e_dt) AS ret_plan_dt, b.secondhand_dt, \n"+
				" decode(b.rm_st,'3','수리요','5','점검요','즉시') rm_st, \n"+
				" decode(g.situation,'0','상담중','1','계약진행중','2','계약확정','3','계약연동','예약가능') situation,  \n"+
				" g.memo, g.reg_dt, g.res_st_dt, g.res_end_dt, g2.res_cnt, nvl(f.upload_dt,'미견적') AS upload_dt, f.rm1,  \n"+
				" decode(b.park,'6',substr(b.park_cont,1,5),nvl(cd.nm,b.park)) park,  \n"+
				" b.park_cont, TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(replace(b.init_reg_dt,'-',''), 'YYYYMMDD'))) use_mon, e.imgfile1, e.imgfile6, e.img_dt,  d.jg_code, \n"+
				" b.rm_cont,  p.park_id, p.area, decode(p.car_mng_id,'','','P') park_yn, decode( p.io_gubun, '1', '입고', '2', '출고', '3','매각확정') AS io_gubun_nm,  \n"+
				" DECODE(a.car_st, '4','월렌트',decode(b.off_ls,'3','경매','1','매각결정',decode(nvl(h.rent_st,i.rent_st),'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트','대기'))) rent_st, \n"+
				" decode( p.park_id, '1', '영남주차장', '2', '정일현대', '3', '부산지점', '4', '대전지점', '5', '명진공업', '7', '부산부경', '8', '부산조양', '9', '대전현대','12','광주지점','13','대구지점' ) AS park_nm \n"+
				" from   cont a, car_reg b, car_etc c, car_nm d, apprsl e, cont_etc n, \n"+
				"        ( select c_st, code, nm_cd, nm from code where c_st = '0027') cd,  \n"+  //주차장 
				"        ( select c_st, code, nm_cd, nm from code where c_st = '0039') cd2,  \n"+  //연료				
				"        (select * from secondhand a where a.seq = (select max(seq) from secondhand where car_mng_id=a.car_mng_id AND rm1 > 0  )) f, \n"+
				"        (select * from sh_res a     where a.use_yn='Y' and a.situation in ('0','2')) g, \n"+ //(보유차등록일 이후의 상담건만 출력)
				"        (select a.car_mng_id, count(0) res_cnt from sh_res a     where a.use_yn is null and a.situation in ('0','2') group by a.car_mng_id) g2, \n"+ //(보유차등록일 이후의 상담건만 출력)
				"        (select * from rent_cont a  where a.use_st = '2' and a.rent_st <>'11') h, \n"+//배차
				"        (select * from rent_cont a  where a.use_st = '1' and a.rent_st<>'11') i, \n"+//예약
				"        PARK_CONDITION p,  (SELECT sh_code, jg_v, seq FROM (SELECT sh_code, jg_v, seq, ROW_NUMBER() over(PARTITION BY sh_code ORDER BY SEQ desc) rn FROM ESTI_JG_VAR ) a  WHERE rn = 1	) q,  \n"+
				"        (SELECT aa.car_mng_id, bb.use_e_dt FROM cont aa,(SELECT rent_mng_id, rent_l_cd, max(use_e_dt) use_e_dt FROM scd_fee GROUP BY rent_mng_id, rent_l_cd) bb WHERE aa.car_st='4' AND nvl(aa.use_yn,'Y')='Y' AND aa.rent_mng_id=bb.rent_mng_id AND aa.rent_l_cd=bb.rent_l_cd ) r\n"+
				" where "+
				"        nvl(a.use_yn,'Y')='Y' /* and a.car_st='2' */ AND a.car_st IN ('2','4') \n"+
				"        and nvl(b.prepare,'0')<>'9' \n"+				//9-미회수차량
				"		 and nvl(b.rm_yn, 'Y') <> 'N' "+				//월렌트비대상	
				"        and nvl(b.off_ls,'0') in ('0') \n"+			//출품전까지 20100126
				"        and a.car_mng_id=b.car_mng_id \n"+
				"        and a.rent_l_cd=c.rent_l_cd \n"+
				"        and c.car_id=d.car_id and c.car_seq=d.car_seq \n"+
				"        and b.car_mng_id=e.car_mng_id(+) \n"+
				"        and a.rent_mng_id=n.rent_mng_id(+) \n"+
				"		 and a.rent_l_cd=n.rent_l_cd(+) AND a.car_mng_id=r.car_mng_id(+) \n"+						
				"        and b.car_mng_id=f.car_mng_id(+) \n"+
				"        and b.car_mng_id=g.car_mng_id(+) \n"+
				"        and b.car_mng_id=g2.car_mng_id(+) \n"+
				"        and b.car_mng_id=h.car_mng_id(+) \n"+
				"        and b.car_mng_id=i.car_mng_id(+) \n"+
				"        and a.car_mng_id=p.car_mng_id(+)  \n"+
				"		 AND d.JG_CODE = q.sh_code(+) \n"+
				"        and b.park = cd.nm_cd(+) \n"+  //주차장 코드 테이블 
				"        and b.fuel_kd = cd2.nm_cd \n"+ 
				"		 and f.rm1 > 0	"+
				"		 and nvl(g.situation,'-') not in ('2') and b.off_ls <> '1'  "; //상담중 제외


			//월렌트차량	//월렌트계약만료7일전것만 나옴 //매각예정차량 제외
			query += " and b.car_use='1'  and nvl(b.prepare,'0') in('0','1','2','7')  ";

			//차명
		if(!gubun_nm.equals(""))			query += " and b.car_nm like '%"+gubun_nm+"%' ";


		//전체 "", 즉시 = "2", 3일이내 = "1"
		if(gubun.equals("")){			query += " and decode(nvl(h.rent_st,i.rent_st),'12',to_char(to_date(substr(h.ret_plan_dt,1,8),'YYYYMMDD')-3,'YYYYMMDD'), to_char(sysdate,'YYYYMMDD')) <= to_char(sysdate,'YYYYMMDD') ";	
										query += " AND decode(nvl(h.rent_st,i.rent_st),'1',to_char(to_date(substr(h.ret_plan_dt,1,8),'YYYYMMDD')-3,'YYYYMMDD'), to_char(sysdate,'YYYYMMDD')) <= to_char(sysdate,'YYYYMMDD') ";	
										query += " AND decode(nvl(h.rent_st,i.rent_st),'2',to_char(to_date(substr(h.ret_plan_dt,1,8),'YYYYMMDD')-3,'YYYYMMDD'), to_char(sysdate,'YYYYMMDD')) <= to_char(sysdate,'YYYYMMDD') ";	
										query += " AND decode(nvl(h.rent_st,i.rent_st),'3',to_char(to_date(substr(h.ret_plan_dt,1,8),'YYYYMMDD')-3,'YYYYMMDD'), to_char(sysdate,'YYYYMMDD')) <= to_char(sysdate,'YYYYMMDD') ";	
										query += " AND decode(nvl(h.rent_st,i.rent_st),'9',to_char(to_date(substr(h.ret_plan_dt,1,8),'YYYYMMDD')-3,'YYYYMMDD'), to_char(sysdate,'YYYYMMDD')) <= to_char(sysdate,'YYYYMMDD') ";	
										query += " AND decode(nvl(h.rent_st,i.rent_st),'10',to_char(to_date(substr(h.ret_plan_dt,1,8),'YYYYMMDD')-3,'YYYYMMDD'), to_char(sysdate,'YYYYMMDD')) <= to_char(sysdate,'YYYYMMDD') ";	                  

		}

		if(gubun.equals("1")){
										query += " and decode(nvl(h.rent_st,i.rent_st),'12',to_char(to_date(substr(h.ret_plan_dt,1,8),'YYYYMMDD')-3,'YYYYMMDD'), to_char(sysdate,'YYYYMMDD')) <= to_char(sysdate,'YYYYMMDD') ";	
										query += " AND decode(nvl(h.rent_st,i.rent_st),'1',to_char(to_date(substr(h.ret_plan_dt,1,8),'YYYYMMDD')-3,'YYYYMMDD'), to_char(sysdate,'YYYYMMDD')) <= to_char(sysdate,'YYYYMMDD') ";	
										query += " AND decode(nvl(h.rent_st,i.rent_st),'2',to_char(to_date(substr(h.ret_plan_dt,1,8),'YYYYMMDD')-3,'YYYYMMDD'), to_char(sysdate,'YYYYMMDD')) <= to_char(sysdate,'YYYYMMDD') ";	
										query += " AND decode(nvl(h.rent_st,i.rent_st),'3',to_char(to_date(substr(h.ret_plan_dt,1,8),'YYYYMMDD')-3,'YYYYMMDD'), to_char(sysdate,'YYYYMMDD')) <= to_char(sysdate,'YYYYMMDD') ";	
										query += " AND decode(nvl(h.rent_st,i.rent_st),'9',to_char(to_date(substr(h.ret_plan_dt,1,8),'YYYYMMDD')-3,'YYYYMMDD'), to_char(sysdate,'YYYYMMDD')) <= to_char(sysdate,'YYYYMMDD') ";	
										query += " AND decode(nvl(h.rent_st,i.rent_st),'10',to_char(to_date(substr(h.ret_plan_dt,1,8),'YYYYMMDD')-3,'YYYYMMDD'), to_char(sysdate,'YYYYMMDD')) <= to_char(sysdate,'YYYYMMDD') ";	                  

//			query += " and DECODE(a.car_st,'4','월렌트', decode(nvl(h.rent_st,i.rent_st),'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트','대기'))  IN('대기','차량정비','월렌트','단기대여','정비대차','사고대차','보험대차','지연대차')  ";
			query += " AND decode(a.car_st,'4',to_char(to_date(substr(NVL(nvl(h.ret_plan_dt,i.ret_plan_dt),r.use_e_dt),1,8),'YYYYMMDD')-3,'YYYYMMDD'), to_char(sysdate,'YYYYMMDD')) <= to_char(sysdate,'YYYYMMDD') "; 
		}
		if(gubun.equals("2"))			query += " and g.situation is null and p.park_id IS NOT NULL AND NVL(nvl(h.ret_plan_dt,i.ret_plan_dt),r.use_e_dt) IS null  and decode(nvl(h.rent_st,i.rent_st),'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트','대기') = '대기'  AND decode(b.rm_st,'3','수리요','즉시') = '즉시'";  // AND NVL(nvl(h.ret_plan_dt,i.ret_plan_dt),r.use_e_dt) IS null  20140228 추가. 즉시가능 차량만 보이게 하려고
/*
		if(brch_id.equals("S1"))			query += " and nvl(n.mng_br_id,a.brch_id) in ('S1','K1','S2')";
		if(brch_id.equals("B1"))			query += " and nvl(n.mng_br_id,a.brch_id) in ('B1','N1')";
		if(brch_id.equals("D1"))			query += " and nvl(n.mng_br_id,a.brch_id)='D1'";
*/
		if(brch_id.equals("S1"))			query += " and decode(b.park,'1','S1','2','S1','3','B1','4','D1','5','S1','7','B1','8','B1','9','D1','12','J1','13','G1', nvl(n.mng_br_id,a.brch_id)) = 'S1' ";
		if(brch_id.equals("B1"))			query += " and decode(b.park,'1','S1','2','S1','3','B1','4','D1','5','S1','7','B1','8','B1','9','D1','12','J1','13','G1', nvl(n.mng_br_id,a.brch_id)) = 'B1' ";
		if(brch_id.equals("D1"))			query += " and decode(b.park,'1','S1','2','S1','3','B1','4','D1','5','S1','7','B1','8','B1','9','D1','12','J1','13','G1', nvl(n.mng_br_id,a.brch_id)) = 'D1' ";
		if(brch_id.equals("J1"))			query += " and decode(b.park,'1','S1','2','S1','3','B1','4','D1','5','S1','7','B1','8','B1','9','D1','12','J1','13','G1', nvl(n.mng_br_id,a.brch_id)) = 'J1' ";
		if(brch_id.equals("G1"))			query += " and decode(b.park,'1','S1','2','S1','3','B1','4','D1','5','S1','7','B1','8','B1','9','D1','12','J1','13','G1', nvl(n.mng_br_id,a.brch_id)) = 'G1' ";

		if(gubun2.equals("1"))			query += " and d.jg_code like '4%' and d.car_comp_id <= '0005' and b.fuel_kd not in ('3','5','6')"; //대형승용
		else if(gubun2.equals("2"))		query += " and d.jg_code like '3%' and d.car_comp_id <= '0005' and b.fuel_kd not in ('3','5','6')"; //중형승용
		else if(gubun2.equals("3"))		query += " and d.jg_code between '1000000' and '2999999' and d.car_comp_id <= '0005' and b.fuel_kd not in ('3','5','6')"; //소형승용
		else if(gubun2.equals("4"))		query += " and d.jg_code like '4%' and d.car_comp_id <= '0005' and b.fuel_kd in ('3','5','6')"; //대형승용LPG
		else if(gubun2.equals("5"))		query += " and d.jg_code between '1000000' and '3999999' and d.car_comp_id <= '0005' and b.fuel_kd in ('3','5','6')"; //소형승용LPG
		else if(gubun2.equals("5"))		query += " and d.jg_code between '1000000' and '3999999' and d.car_comp_id <= '0005' and b.fuel_kd in ('3','5','6')"; //소형승용LPG
		else if(gubun2.equals("6"))		query += " and d.jg_code between '5000000' and '9999999' and d.car_comp_id <= '0005' "; //국산 RV및기타(승합,화물)
		else if(gubun2.equals("7"))		query += " and d.car_comp_id > '0005'  "; //수입차


				query += 	" ORDER BY decode(nvl(g.situation,'0'), '2',1, 0), "+
							" decode(d.car_comp_id, '0001',0, '0002',0, '0003',0, '0004',0, '0005',0, 1), "+
							" decode(b.fuel_kd, '3',0, '5',0, '6',0, 1), "+
							" d.jg_code, f.rm1, "+
							" d.car_b_p, "+
							" d.car_name, "+
							" b.init_reg_dt,"+ 
							" b.car_mng_id  ";

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
			System.out.println("[OfflshpgDatabase:getSecondhandMonthsList_20131210]\n"+e);
			System.out.println("[OfflshpgDatabase:getSecondhandMonthsList_20131210]\n"+query);
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

 
 
  public Vector getSecondhandListM_20151202(String gubun, String res_yn, String sort, String month){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		this.totalsize_sh = 0;
		String query = "";

		query = " SELECT s.max_use_mon, s.lsmax, s.lbmax, s.rsmax, s.rbmax,  DECODE(rbmax, 0, lbmax, rbmax) as max_amt,  g.car_comp_id,  \n"+
				"        s.rb12, s.rs12, s.lb12, s.ls12, s.rb24, s.rs24, s.lb24, s.ls24, s.rb36, s.rs36, s.lb36, s.ls36, s.rb48, s.rs48, s.lb48, s.ls48, \n"+
			    "        s.apply_sh_pr, s.upload_dt, s.reg_code, \n"+
				"        b.rent_mng_id, b.rent_l_cd, a.car_mng_id, a.car_no, '*** '||SUBSTR(a.car_no,-4) ab_car_no, a.car_y_form, \n"+
				"        c.imgfile1, NVL(h2.save_file, c.imgfile6) imgfile6, h2.save_folder, h.car_nm car_jnm, g.car_name car_nm, a.dpm, b.colo, \n"+
				"	     substr(a.init_reg_dt,1,4)||'년'||substr(a.init_reg_dt,5,2)||'월' init_reg_dt, s.real_km, \n"+
				"        d.nm as fuel_kd,"+
				"        decode(s.rb36, 0,s.lb36, -1,s.lb36, s.rb36) fee_amt, "+
				"        decode(s.rb30, 0,s.lb30, -1,s.lb30, s.rb30) fee_amt_30, "+
				"		 NVL(s.rb36, s.rs36) rb, NVL(s.lb36, s.ls36) lb, NVL(s.rb30, s.rs30) rb30, NVL(s.lb30, s.ls30) lb30,	"+
				"        j.sh_code, sr.RES_END_DT,g2.res_cnt, \n"+
				"        /*네  고*/decode(sr.situation,'0','상담중','1','계약진행중','2','계약확정','3','계약연동','예약가능') situation,  \n"+
				"        decode(nvl(hh.rent_st,ii.rent_st),'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트','대기') rent_st, "+ 
				"        nvl( hh.ret_plan_dt, ii.ret_plan_dt ) AS ret_plan_dt\n"+
				" from   car_reg a, cont e, car_etc b, apprsl c, car_nm g, car_mng h, \n"+
				"        (select a.* from esti_jg_var a where a.seq = (select max(seq) from esti_jg_var where sh_code=a.sh_code)) j, \n"+
				"        (select a.* from secondhand a  where a.seq = (select max(seq) from secondhand  where reg_code is not null and car_mng_id=a.car_mng_id)) s, \n"+
				"        (select a.* from sh_res a      where a.use_yn='Y' and a.situation in ('0','2')) sr, \n"+
				"        (select * from rent_cont a  where a.use_st = '2' and a.rent_st<>'11') hh,"+
				"		 (select * from rent_cont a  where a.use_st = '1' and a.rent_st<>'11') ii,"+
				"		 ( SELECT a.car_mng_id, count( * ) res_cnt FROM sh_res a WHERE a.use_yn IS NULL AND a.situation IN ( '0', '2' ) GROUP BY a.car_mng_id ) g2, "+
				"		 (select SUBSTR(content_seq,1,6) car_mng_id, content_seq, save_folder, save_file  from ACAR_ATTACH_FILE where ISDELETED='N' and content_code='APPRSL' AND SUBSTR(content_seq,7,1) = '1') h2, "+
				"        (select * from code where c_st='0039') d "+
				" where  a.car_mng_id=e.car_mng_id and a.car_mng_id = hh.car_mng_id(+) and a.car_mng_id = ii.car_mng_id(+) AND a.car_mng_id = g2.car_mng_id(+) \n"+
				"        and e.use_yn='Y' and e.car_st='2' "+
				"        and nvl(a.off_ls,'0') in ('0') "+		//출품전까지 20110126 , 20130201- 1값 제외.
				"        and a.secondhand = '1' \n"+
				"        and nvl(a.prepare,'0') not in ('7', '9') "+
				"        and e.rent_mng_id=b.rent_mng_id and e.rent_l_cd=b.rent_l_cd \n"+
				"        and a.car_mng_id=c.car_mng_id(+) \n"+
				"        and b.car_id=g.car_id and b.car_seq=g.car_seq \n"+
				"        and g.car_comp_id=h.car_comp_id and g.car_cd=h.code \n"+
				"        and g.jg_code=j.sh_code \n"+
				"        and a.car_mng_id = s.car_mng_id \n"+
				"        and a.car_mng_id = sr.car_mng_id(+) and a.car_mng_id=h2.car_mng_id(+) \n"+
				"        and nvl(sr.situation,'0')<>'2' \n"+ //계약확정 아닌것
				"        and a.fuel_kd=d.nm_cd "+
				" ";

		//월렌트계약만료5일전것만 나옴
		query += " and decode(hh.rent_st,'12',to_char(to_date(substr(hh.ret_plan_dt,1,8),'YYYYMMDD')-5,'YYYYMMDD'), to_char(sysdate,'YYYYMMDD')) <= to_char(sysdate,'YYYYMMDD')";

		if(res_yn.equals("Y"))			query += " and nvl(sr.situation,'-')<>'0'";

		if(gubun.equals("1"))			query += " and g.jg_code like '4%' and g.car_comp_id <= '0005' and a.fuel_kd not in ('3','5','6')"; //대형승용
		else if(gubun.equals("2"))		query += " and g.jg_code like '3%' and g.car_comp_id <= '0005' and a.fuel_kd not in ('3','5','6')"; //중형승용
		else if(gubun.equals("3"))		query += " and g.jg_code between '1000000' and '2999999' and g.car_comp_id <= '0005' and a.fuel_kd not in ('3','5','6')"; //소형승용
		else if(gubun.equals("4"))		query += " and g.jg_code like '4%' and g.car_comp_id <= '0005' and a.fuel_kd in ('3','5','6')"; //대형승용LPG
		else if(gubun.equals("5"))		query += " and g.jg_code like '3%' and g.car_comp_id <= '0005' and a.fuel_kd in ('3','5','6')"; //중형승용LPG
		else if(gubun.equals("8"))		query += " and g.jg_code between '1000000' and '2999999' and g.car_comp_id <= '0005' and a.fuel_kd in ('3','5','6')"; //소형승용LPG
		else if(gubun.equals("6"))		query += " and g.jg_code between '5000000' and '9999999' and g.car_comp_id <= '0005' "; //국산 RV및기타(승합,화물)
		else if(gubun.equals("7"))		query += " and g.car_comp_id > '0005' "; //수입차
		
		if(month.equals("12"))			{		query += " and   s.rb12 +  s.rs12 + s.lb12 + s.ls12  > 0 "; //12
		}else if(month.equals("24"))	{		query += " and   s.rb24 +  s.rs24 + s.lb24 + s.ls24  > 0 "; //12
		}else  if(month.equals("36"))	{		query += " and   s.rb36 +  s.rs36 + s.lb36 + s.ls36  > 0 "; //12
		} 	
		
		if(sort.equals("1")){
			query += " order by decode(nvl(sr.situation,'0'),'2',1,0), d.nm, ";
		}else if(sort.equals("2")){
			query += " order by decode(nvl(sr.situation,'0'),'2',1,0), b.colo, ";
		}else if(sort.equals("3")){
			query += " order by decode(nvl(sr.situation,'0'),'2',1,0), a.init_reg_dt, ";
		}else if(sort.equals("4")){
			query += " order by decode(nvl(sr.situation,'0'),'2',1,0), to_number(s.real_km), ";
		}else if(sort.equals("5")){
			query += " order by decode(nvl(sr.situation,'0'),'2',1,0), decode(s.rb36, 0,s.lb36, -1,s.lb36, s.rb36), ";
		}else{
			query += " order by ";
		}
	
		//20101021 : 소형LPG,중형LPG,대형LPG,소형,중형,대형,RV,수입 순으로 정렬 변경	
		query += "     decode(g.car_comp_id, '0001',0, '0002',0, '0003',0, '0004',0, '0005',0, 1), "+ //국내차량 위, 수입차량 아래로
				 "     decode(a.fuel_kd, '3',0, '5',0, '6',0, 1), "+
	             "     g.jg_code,  g.car_b_p, g.car_name, a.init_reg_dt, a.car_mng_id ";


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
				this.totalsize_sh++;
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[OfflshpgDatabase:getSecondhandListM_20151202]"+e);
			System.out.println("[OfflshpgDatabase:getSecondhandListM_20151202]"+query);
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )			rs.close();
				if(pstmt != null )		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	기본식,맞춤식 이력여부
	 */
	public int getContRentWay(String c_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int rent_way_chk = 0;
		String query = "";

		query = " select count(*) from cont a, fee b where a.car_mng_id='"+c_id+"' and a.car_st in ('1','3') and a.rent_mng_id=b.RENT_MNG_ID and a.rent_l_cd=b.rent_l_cd and b.rent_st='1' and b.rent_way in ('2','3') ";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			if(rs.next())
			{				
				rent_way_chk = rs.getInt(1);
			}

		} catch (SQLException e) {
			System.out.println("[OfflshpgDatabase:getContRentWay]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return rent_way_chk;
		}
	}	
	
	
	public Hashtable getSecondhandCaseData(String car_mng_id, String reg_code) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " SELECT * FROM SECONDHAND " +
					" WHERE " +
					" car_mng_id = '"+car_mng_id+"' " +
					" AND reg_code = '"+reg_code+"' ";

		try {			
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			if (rs.next()) {				
				for (int pos =1; pos <= rsmd.getColumnCount(); pos++) {
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[OfflshpgDatabase:getSecondhandCaseData]"+e);
			System.out.println("[OfflshpgDatabase:getSecondhandCaseData]"+query);
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
