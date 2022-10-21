/**
 * 오프리스 예비차량 정보
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2003. 01. 23. Thu.
 * @ last modify date : 
 */
package acar.offls_yb;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;
import acar.exception.DatabaseException;
import acar.exception.DataSourceEmptyException;
import acar.common.*;
import acar.car_accident.*;

public class Offls_ybDatabase
{
	private Connection conn = null;
	public static Offls_ybDatabase db;
	
	public static Offls_ybDatabase getInstance()
	{
		if(Offls_ybDatabase.db == null)
			Offls_ybDatabase.db = new Offls_ybDatabase();
		return Offls_ybDatabase.db;
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
	*	예비차량 Bean에 데이터 넣기 2003.1.23. Thu.
	*	- 2003.06.18.Wed. 수정 : ins_com_nm, ins_exp_dt 추가
	*/
	 public Offls_ybBean makeOffls_ybBean(ResultSet results) throws DatabaseException {

        try {
            Offls_ybBean bean = new Offls_ybBean();

			bean.setCar_end_dt(results.getString("CAR_END_DT"));
		    bean.setCar_mng_id(results.getString("CAR_MNG_ID"));			//자동차관리번호
			bean.setCar_no(results.getString("CAR_NO"));
			bean.setCar_num(results.getString("CAR_NUM"));
			bean.setInit_reg_dt(results.getString("INIT_REG_DT"));
			bean.setCar_kd(results.getString("CAR_KD"));
			bean.setCar_use(results.getString("CAR_USE"));
			bean.setCar_jnm(results.getString("CAR_JNM"));
			bean.setCar_nm(results.getString("CAR_NM"));
			bean.setCar_form(results.getString("CAR_FORM"));
			bean.setCar_y_form(results.getString("CAR_Y_FORM"));
			bean.setDpm(results.getString("DPM"));
			bean.setFuel_kd(results.getString("FUEL_KD"));
			bean.setMaint_st_dt(results.getString("MAINT_ST_DT"));
			bean.setMaint_end_dt(results.getString("MAINT_END_DT"));
			bean.setTest_st_dt(results.getString("TEST_ST_DT"));
			bean.setTest_end_dt(results.getString("TEST_END_DT"));
			bean.setCar_l_cd(results.getString("CAR_L_CD"));				//년도별차량등록순번
			bean.setPrepare(results.getString("PREPARE"));					//차량상태20060424
			bean.setRent_mng_id(results.getString("RENT_MNG_ID"));			//계약관리번호
			bean.setRent_l_cd(results.getString("RENT_L_CD"));				//계약번호
			bean.setCar_id(results.getString("CAR_ID"));
			bean.setColo(results.getString("COLO"));
			bean.setOpt(results.getString("OPT"));
			bean.setCar_cs_amt(results.getInt("CAR_CS_AMT"));
			bean.setCar_cv_amt(results.getInt("CAR_CV_AMT"));
			bean.setCar_fs_amt(results.getInt("CAR_FS_AMT"));
			bean.setCar_fv_amt(results.getInt("CAR_FV_AMT"));
			bean.setOpt_cs_amt(results.getInt("OPT_CS_AMT"));
			bean.setOpt_cv_amt(results.getInt("OPT_CV_AMT"));
			bean.setOpt_fs_amt(results.getInt("OPT_FS_AMT"));
			bean.setOpt_fv_amt(results.getInt("OPT_FV_AMT"));
			bean.setClr_cs_amt(results.getInt("CLR_CS_AMT"));
			bean.setClr_cv_amt(results.getInt("CLR_CV_AMT"));
			bean.setClr_fs_amt(results.getInt("CLR_FS_AMT"));
			bean.setClr_fv_amt(results.getInt("CLR_FV_AMT"));
			bean.setSd_cs_amt(results.getInt("SD_CS_AMT"));
			bean.setSd_cv_amt(results.getInt("SD_CV_AMT"));
			bean.setSd_fs_amt(results.getInt("SD_FS_AMT"));
			bean.setSd_fv_amt(results.getInt("SD_FV_AMT"));
			bean.setDc_cs_amt(results.getInt("DC_CS_AMT"));
			bean.setDc_cv_amt(results.getInt("DC_CV_AMT"));
			bean.setDc_fs_amt(results.getInt("DC_FS_AMT"));
			bean.setDc_fv_amt(results.getInt("DC_FV_AMT"));
			bean.setMng_id(results.getString("MNG_ID"));
			bean.setDlv_dt(results.getString("DLV_DT"));
			bean.setAccident_yn(results.getString("ACCIDENT_YN"));
			bean.setTot_dist(results.getInt("TOT_DIST"));
			bean.setAverage_dist(results.getInt("AVERAGE_DIST"));
			bean.setToday_dist(results.getInt("TODAY_DIST"));
			bean.setBank_nm(results.getString("BANK_NM"));
			bean.setLend_prn(results.getInt("LEND_PRN"));
			bean.setLend_rem(results.getInt("LEND_REM"));
			bean.setAlt_end_dt(results.getString("ALT_END_DT"));
			bean.setLev(results.getString("LEV"));
			bean.setReason(results.getString("REASON"));
			bean.setCar_st(results.getString("CAR_ST"));
			bean.setImgfile1(results.getString("IMGFILE1"));
			bean.setImgfile2(results.getString("IMGFILE2"));
			bean.setImgfile3(results.getString("IMGFILE3"));
			bean.setImgfile4(results.getString("IMGFILE4"));
			bean.setImgfile5(results.getString("IMGFILE5"));
			bean.setDamdang_id(results.getString("DAMDANG_ID"));
			bean.setModify_id(results.getString("MODIFY_ID"));
			bean.setApprsl_dt(results.getString("APPRSL_DT"));
			bean.setCar_cha_yn(results.getString("CAR_CHA_YN"));
			bean.setIns_com_nm(results.getString("INS_COM_NM"));
			bean.setIns_exp_dt(results.getString("INS_EXP_DT"));
			bean.setDriver(results.getString("DRIVER"));
			bean.setRent_st_nm(results.getString("RENT_ST_NM"));
			bean.setRet_plan_dt(results.getString("RET_PLAN_DT"));
			bean.setSecondhand(results.getString("SECONDHAND"));
			bean.setUse_mon(results.getString("use_mon"));
			bean.setGps(results.getString("gps"));
			bean.setJg_code(results.getString("jg_code"));
			bean.setCon_f_nm(results.getString("con_f_nm"));
			bean.setPark_cont(results.getString("park_cont"));
			bean.setPark_nm(results.getString("park_nm"));
			bean.setRm_yn(results.getString("RM_YN"));
			bean.setCar_gu(results.getString("CAR_GU"));
			
			bean.setNcar_spe_dc_amt(results.getString("ncar_spe_dc_amt"));
			bean.setSpe_dc_per(results.getString("spe_dc_per"));


		return bean;

        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}
	
	/**
	*	예비차량 상세정보 2003.1.24.Fri. ~ 25.Sat.
	*	- 28.Tue. query 수정 : 빠진 출고일 c.dlv_dt DLV_DT 추가
	*	- 2003.06.18.Wed. 수정 : ins_com_nm, ins_exp_dt 추가
	*/
	public Offls_ybBean getYb_detail(String car_mng_id){
		getConnection();
		Offls_ybBean detail = new Offls_ybBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = "select	r.car_end_dt, r.car_mng_id CAR_MNG_ID, r.car_no CAR_NO, r.car_num CAR_NUM, r.init_reg_dt	INIT_REG_DT, r.car_kd CAR_KD, r.car_use	CAR_USE, n.car_nm CAR_JNM, m.car_name	CAR_NM,	r.car_form CAR_FORM, r.car_y_form	CAR_Y_FORM,	r.dpm			DPM,	r.fuel_kd		FUEL_KD,	r.maint_st_dt	MAINT_ST_DT,	r.maint_end_dt	MAINT_END_DT, r.test_st_dt TEST_ST_DT, r.test_end_dt TEST_END_DT, r.car_l_cd CAR_L_CD, "+
				" decode(nvl(r.prepare,'0'), '2','매각', '3','보관', '4','말소', '5','도난', decode(c.client_id,'000231','중앙(영)') ) PREPARE, "+
				" e.rent_mng_id	RENT_MNG_ID,	e.rent_l_cd		RENT_L_CD,	e.car_id		CAR_ID,	e.colo			COLO,	e.opt			OPT,	e.car_cs_amt	CAR_CS_AMT,	e.car_cv_amt	CAR_CV_AMT,	e.car_fs_amt	CAR_FS_AMT,	e.car_fv_amt	CAR_FV_AMT,	e.opt_cs_amt	OPT_CS_AMT,	e.opt_cv_amt	OPT_CV_AMT,	e.opt_fs_amt	OPT_FS_AMT,	e.opt_fv_amt	OPT_FV_AMT,	e.clr_cs_amt	CLR_CS_AMT,	e.clr_cv_amt	CLR_CV_AMT,	e.clr_fs_amt	CLR_FS_AMT,	e.clr_fv_amt	CLR_FV_AMT,	e.sd_cs_amt		SD_CS_AMT,	e.sd_cv_amt		SD_CV_AMT,	e.sd_fs_amt		SD_FS_AMT,	e.sd_fv_amt		SD_FV_AMT,	e.dc_cs_amt		DC_CS_AMT,	e.dc_cv_amt		DC_CV_AMT,	e.dc_fs_amt		DC_FS_AMT,	e.dc_fv_amt		DC_FV_AMT, c.mng_id		MNG_ID,	c.dlv_dt DLV_DT, decode(r.car_mng_id, sq.car_mng_id, 1, 0) ACCIDENT_YN, "+
				" vt.tot_dist TOT_DIST, "+
				" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD'))))) as AVERAGE_DIST, "+
				" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST, "+
				" bk.bank_nm BANK_NM, bk.lend_prn LEND_PRN, sw.alt_rest	LEND_REM, sc.alt_est_dt ALT_END_DT, s.lev LEV, s.reason REASON, s.car_st CAR_ST,s.imgfile1 IMGFILE1, s.imgfile2 IMGFILE2, s.imgfile3 IMGFILE3, s.imgfile4 IMGFILE4, s.imgfile5 IMGFILE5, s.damdang_id DAMDANG_ID, s.modify_id MODIFY_ID, s.apprsl_dt APPRSL_DT, DECODE(r.car_mng_id, ch.car_mng_id, 1, 0) CAR_CHA_YN "+
				", iu.ins_com_nm INS_COM_NM, iu.ins_exp_dt INS_EXP_DT, s.driver DRIVER "+
				", '' rent_st_nm, '' ret_plan_dt, r.secondhand "+
				", TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(replace(r.init_reg_dt,'-',''), 'YYYYMMDD'))) use_mon, decode(r.gps,'Y','장착') gps, "+
				" m.jg_code, iu.con_f_nm, r.park_cont, r.park as park_nm, r.rm_yn, c.car_gu, r.ncar_spe_dc_amt, r.spe_dc_per "+
				" from car_reg r, car_etc e, cont c, apprsl s, car_nm m, CAR_MNG n, v_tot_dist vt, (select distinct ac.car_mng_id CAR_MNG_ID from accident ac, car_reg re where ac.car_mng_id=re.car_mng_id) sq, "+
				"	(select a.car_mng_id CAR_MNG_ID, a.serv_dt SERV_DT, a.tot_dist TOT_DIST  from service a where a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where car_mng_id = a.car_mng_id)) i, "+
				"	(select al.rent_mng_id RENT_MNG_ID, al.rent_l_cd RENT_L_CD, cd.nm BANK_NM , al.lend_prn LEND_PRN, al.alt_end_dt ALT_END_DT from allot al, code cd where al.cpt_cd = cd.code and cd.c_st = '0003') bk, "+
				"	(SELECT DISTINCT cc.car_mng_id CAR_MNG_ID FROM car_cha cc, car_reg re WHERE cc.car_mng_id = re.car_mng_id) ch, "+
				"	(SELECT sc.car_mng_id CAR_MNG_ID, sc.alt_rest ALT_REST FROM scd_alt_case sc WHERE sc.alt_tm = (select max(alt_tm) from scd_alt_case where car_mng_id = sc.car_mng_id)) sw "+
				", (select ir.car_mng_id CAR_MNG_ID, ic.ins_com_nm INS_COM_NM, ir.ins_exp_dt INS_EXP_DT, ir.con_f_nm from insur ir, ins_com ic where ir.ins_com_id = ic.ins_com_id and ir.ins_st = (select max(ins_st) from insur where car_mng_id = ir.car_mng_id)) iu "+
				", (SELECT sc.car_mng_id CAR_MNG_ID, sc.alt_est_dt ALT_EST_DT FROM scd_alt_case sc WHERE sc.alt_est_dt = (select max(alt_est_dt) from scd_alt_case where car_mng_id = sc.car_mng_id)) sc "+
				" where r.car_mng_id = c.car_mng_id "+
				"  and e.rent_mng_id = c.rent_mng_id "+
				"  and e.rent_l_cd = c.rent_l_cd "+
				"  and r.car_mng_id = sq.car_mng_id(+) "+
				"  and c.car_st = '2' "+
				"  and c.use_yn = 'Y' "+
				"  and r.off_ls = '0' "+
				"  and r.car_mng_id = i.car_mng_id(+) "+
				"  and c.rent_mng_id = bk.rent_mng_id(+) "+
				"  and c.rent_l_cd = bk.rent_l_cd(+) "+
				"  and r.car_mng_id = s.car_mng_id(+) "+
				"  and r.car_mng_id = ch.car_mng_id(+) "+
				"  AND r.car_mng_id = sw.car_mng_id(+) "+
				"  and r.car_mng_id = iu.car_mng_id(+) "+
				"  and r.car_mng_id = sc.car_mng_id(+) "+
				"  AND e.car_id = m.car_id "+	
				"  and e.car_seq = m.car_seq "+
				"  and m.car_comp_id = n.car_comp_id "+
				"  and m.car_cd = n.code "+
				"  and r.car_mng_id = vt.car_mng_id(+) "+
				"  and r.car_mng_id = '"+car_mng_id+"'";

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while(rs.next()){
				detail = makeOffls_ybBean(rs);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_ybDatabase:getYb_detail(String car_mng_id)]"+e);
			System.out.println("[Offls_ybDatabase:getYb_detail(String car_mng_id)]"+query);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return detail;
		}		
	}

	/**
	*	회사별 차량 통계 - 2003.1.27.Mon.
	*	수정 - 2003.06.18.Wed. ;view로 쓰다가 지점(brch_id)별로 검색하기 위해
	*/
	public int[][] getTg(String brch_id){
		getConnection();
		int tg[][] = new int[5][7];
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		if(brch_id.equals("")) brch_id = "%";

		query = "select hd.c1 hdC1, hd.c2 hdC2, hd.c3 hdC3, hd.c4 hdC4, hd.c5 hdC5, hd.c6 hdc6, hd.c7 hdc7, kia.c1 kiaC1, kia.c2 kiaC2, kia.c3 kiaC3, kia.c4 kiaC4, kia.c5 kiaC5, kia.c6 kiac6, kia.c7 kiac7, sam.c1 samC1, sam.c2 samC2, sam.c3 samC3, sam.c4 samC4, sam.c5 samC5, sam.c6 samc6, sam.c7 samc7, ds.c1 dsC1, ds.c2 dsC2, ds.c3 dsC3, ds.c4 dsC4, ds.c5 dsC5, ds.c6 dsc6, ds.c7 dsc7, other.c1 otherC1, other.c2 otherC2, other.c3 otherC3, other.c4 otherC4, other.c5 otherC5, other.c6 otherc6, other.c7 otherc7 "+
				"from		     "+
				"(select nvl(sum(decode(C.car_kd, '1', 1, 0)),0) c1, nvl(sum(decode(C.car_kd, '2', 1, 0)),0) c2, nvl(sum(decode(C.car_kd, '3', 1, '9', 1, 0)),0) c3, nvl(sum(decode(C.car_kd, '4', 1, 0)),0) c4, nvl(sum(decode(C.car_kd, '5', 1, 0)),0) c5, nvl(sum(decode(C.car_kd, '6', 1, 0)),0) c6, nvl(sum(decode(C.car_kd, '7', 1, 0)),0) c7 "+
				"from car_reg C, cont t, car_etc e, car_nm n, code d    "+ 
				"where c.car_mng_id = t.car_mng_id     "+
				"and t.rent_mng_id = e.rent_mng_id     "+
				"and t.rent_l_cd = e.rent_l_cd     "+
				"and  t.car_st='2'     "+
				"and  nvl(t.use_yn,'Y')='Y' "+
				"and t.brch_id like '"+brch_id+"'    "+
				"and c.off_ls = '0'  "+
				"and e.car_id = n.car_id     "+
				"and e.car_seq = n.car_seq	"+
				"and n.car_comp_id = '0001'     "+
				"and n.car_comp_id = d.code     "+
				"and d.c_st = '0001') hd,     "+
				"(select nvl(sum(decode(C.car_kd, '1', 1, 0)),0) c1, nvl(sum(decode(C.car_kd, '2', 1, 0)),0) c2, nvl(sum(decode(C.car_kd, '3', 1, '9', 1, 0)),0) c3, nvl(sum(decode(C.car_kd, '4', 1, 0)),0) c4, nvl(sum(decode(C.car_kd, '5', 1, 0)),0) c5, nvl(sum(decode(C.car_kd, '6', 1, 0)),0) c6, nvl(sum(decode(C.car_kd, '7', 1, 0)),0) c7 "+
				"from car_reg C, cont t, car_etc e, car_nm n, code d   "+  
				"where c.car_mng_id = t.car_mng_id    "+ 
				"and t.rent_mng_id = e.rent_mng_id    "+ 
				"and t.rent_l_cd = e.rent_l_cd   "+  
				"and  t.car_st='2'     "+
				"and  nvl(t.use_yn,'Y')='Y'      "+
				"and t.brch_id like '"+brch_id+"' "+
				"and c.off_ls = '0'     "+
				"and e.car_id = n.car_id     "+
				"and e.car_seq = n.car_seq	"+
				"and n.car_comp_id = '0002'     "+
				"and n.car_comp_id = d.code     "+
				"and d.c_st = '0001') kia,     "+
				"(select nvl(sum(decode(C.car_kd, '1', 1, 0)),0) c1, nvl(sum(decode(C.car_kd, '2', 1, 0)),0) c2, nvl(sum(decode(C.car_kd, '3', 1, '9', 1, 0)),0) c3, nvl(sum(decode(C.car_kd, '4', 1, 0)),0) c4, nvl(sum(decode(C.car_kd, '5', 1, 0)),0) c5, nvl(sum(decode(C.car_kd, '6', 1, 0)),0) c6, nvl(sum(decode(C.car_kd, '7', 1, 0)),0) c7 "+
				"from car_reg C, cont t, car_etc e, car_nm n, code d     "+
				"where c.car_mng_id = t.car_mng_id   "+  
				"and t.rent_mng_id = e.rent_mng_id     "+
				"and t.rent_l_cd = e.rent_l_cd  "+   
				"and  t.car_st='2'     "+
				"and  nvl(t.use_yn,'Y')='Y'      "+
				"and t.brch_id like '"+brch_id+"' "+
				"and c.off_ls = '0'     "+
				"and e.car_id = n.car_id     "+
				"and e.car_seq = n.car_seq	"+
				"and n.car_comp_id = '0003'     "+
				"and n.car_comp_id = d.code     "+
				"and d.c_st = '0001') sam,     "+
				"(select nvl(sum(decode(C.car_kd, '1', 1, 0)),0) c1, nvl(sum(decode(C.car_kd, '2', 1, 0)),0) c2, nvl(sum(decode(C.car_kd, '3', 1, '9', 1, 0)),0) c3, nvl(sum(decode(C.car_kd, '4', 1, 0)),0) c4, nvl(sum(decode(C.car_kd, '5', 1, 0)),0) c5, nvl(sum(decode(C.car_kd, '6', 1, 0)),0) c6, nvl(sum(decode(C.car_kd, '7', 1, 0)),0) c7 "+
				"from car_reg C, cont t, car_etc e, car_nm n, code d     "+
				"where c.car_mng_id = t.car_mng_id     "+
				"and t.rent_mng_id = e.rent_mng_id   "+  
				"and t.rent_l_cd = e.rent_l_cd     "+
				"and  t.car_st='2'     "+
				"and  nvl(t.use_yn,'Y')='Y'      "+
				"and t.brch_id like '"+brch_id+"' "+
				"and c.off_ls = '0'     "+
				"and e.car_id = n.car_id     "+
				"and e.car_seq = n.car_seq	"+
				"and n.car_comp_id in ('0004','0005')     "+
				"and n.car_comp_id = d.code     "+
				"and d.c_st = '0001') ds,     "+
				"(select nvl(sum(decode(C.car_kd, '1', 1, 0)),0) c1, nvl(sum(decode(C.car_kd, '2', 1, 0)),0) c2, nvl(sum(decode(C.car_kd, '3', 1, '9', 1, 0)),0) c3, nvl(sum(decode(C.car_kd, '4', 1, 0)),0) c4, nvl(sum(decode(C.car_kd, '5', 1, 0)),0) c5, nvl(sum(decode(C.car_kd, '6', 1, 0)),0) c6, nvl(sum(decode(C.car_kd, '7', 1, 0)),0) c7 "+
				"from car_reg C, cont t, car_etc e, car_nm n, code d     "+
				"where c.car_mng_id = t.car_mng_id   "+  
				"and t.rent_mng_id = e.rent_mng_id  "+   
				"and t.rent_l_cd = e.rent_l_cd     "+
				"and  t.car_st='2'    "+ 
				"and  nvl(t.use_yn,'Y')='Y'    "+  
				"and t.brch_id like '"+brch_id+"' "+ 
				"and c.off_ls = '0'    "+ 
				"and e.car_id = n.car_id     "+
				"and e.car_seq = n.car_seq	"+
				"and n.car_comp_id > '0005'     "+
				"and n.car_comp_id = d.code     "+
				"and d.c_st = '0001') other ";

			try{
				pstmt = conn.prepareStatement(query);
				rs = pstmt.executeQuery();
				while(rs.next()){
					tg[0][0] = rs.getInt("HDC1");
					tg[0][1] = rs.getInt("HDC2");
					tg[0][2] = rs.getInt("HDC3");
					tg[0][3] = rs.getInt("HDC4");
					tg[0][4] = rs.getInt("HDC5");
					tg[0][5] = rs.getInt("HDC6");
					tg[0][6] = rs.getInt("HDC7");
					tg[1][0] = rs.getInt("KIAC1");
					tg[1][1] = rs.getInt("KIAC2");
					tg[1][2] = rs.getInt("KIAC3");
					tg[1][3] = rs.getInt("KIAC4");
					tg[1][4] = rs.getInt("KIAC5");
					tg[1][5] = rs.getInt("KIAC6");
					tg[1][6] = rs.getInt("KIAC7");
					tg[2][0] = rs.getInt("SAMC1");
					tg[2][1] = rs.getInt("SAMC2");
					tg[2][2] = rs.getInt("SAMC3");
					tg[2][3] = rs.getInt("SAMC4");
					tg[2][4] = rs.getInt("SAMC5");
					tg[2][5] = rs.getInt("SAMC6");
					tg[2][6] = rs.getInt("SAMC7");
					tg[3][0] = rs.getInt("DSC1");
					tg[3][1] = rs.getInt("DSC2");
					tg[3][2] = rs.getInt("DSC3");
					tg[3][3] = rs.getInt("DSC4");
					tg[3][4] = rs.getInt("DSC5");
					tg[3][5] = rs.getInt("DSC6");
					tg[3][6] = rs.getInt("DSC7");
					tg[4][0] = rs.getInt("OTHERC1");
					tg[4][1] = rs.getInt("OTHERC2");
					tg[4][2] = rs.getInt("OTHERC3");
					tg[4][3] = rs.getInt("OTHERC4");
					tg[4][4] = rs.getInt("OTHERC5");
					tg[4][5] = rs.getInt("OTHERC6");
					tg[4][6] = rs.getInt("OTHERC7");
				}
			rs.close();
			pstmt.close();
				
			}catch(SQLException e){
				System.out.println("[Offls_ybDatabase:getTg()]"+e);
				e.printStackTrace();
			}finally{
				try{
					if(rs != null ) rs.close();
					if(pstmt != null) pstmt.close();
				}catch(Exception ignore){}

				closeConnection();
				return tg;
			}
	}

	/**
	*	예비차량 검색 - 2003.1.28.Tue.
	*	- gubun : 차량번호, 차량명, 최초등록일
	*	- gubun_nm : 해당 데이타
	*	- 추가 1.29. Wed. cont_bn 대출은행
	*	- 추가 2.4. Tue. car_form of CAR_REG
	*	- 추가 2.8. Sat. lend_prn of CONT, lend_rem of SCD_ALT_CASE
	*	- 추가 3.3. Fri. test_st_dt and test_end_dt of CAR_REG
	*	- 2003.06.18.Wed. 수정 : ins_com_nm, ins_exp_dt 추가
	*/
	public Offls_ybBean[] getYb_lst(String gubun, String gubun_nm, String brch_id, String gubun2){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String subQuery = "";

		if(gubun.equals("car_no")){
			subQuery = " and r.car_no like '%" + gubun_nm + "%'";
		}else if(gubun.equals("car_nm")){
			subQuery = " and r.car_nm like '%" + gubun_nm.toUpperCase() + "%'";
		}else if(gubun.equals("init_reg_dt")){
			subQuery = " and r.init_reg_dt like replace('"+ gubun_nm +"','-','')||'%'";
		}else if(gubun.equals("month_rent")){
			subQuery = " AND decode(nvl(rh.rent_st,ri.rent_st),'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트','대기') <> '월렌트' ";

		}else{ //all
			subQuery = "";
		}

		if(gubun2.equals("Y"))	subQuery += " and decode(r.off_ls,'3',decode(o.actn_st,'2',to_char(to_date(o.actn_dt,'YYYYMMDD')+7,'YYYYMMDD'),o.actn_dt),decode(nvl(rh.rent_st,ri.rent_st),'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트','대기'))='업무대여'";
		else if (gubun2.equals("N")){
			subQuery += " and decode(r.off_ls,'3',decode(o.actn_st,'2',to_char(to_date(o.actn_dt,'YYYYMMDD')+7,'YYYYMMDD'),o.actn_dt),decode(nvl(rh.rent_st,ri.rent_st),'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트','대기'))<>'업무대여'";
		}
		if(!brch_id.equals(""))	subQuery += " and c.brch_id='"+brch_id+"'";

		if(gubun.equals("car_no")){
			query = " select	'' BANK_NM, '' LEND_PRN, '' ALT_END_DT, '' LEND_REM,  \n"+
					//" decode(r.park,'1','목동', '2','정일', '3','부산', '4','대전', '5','명진', '7','부경','8','조양','9','현대','10','오토', '11','금호','12','광주','13','대구','14','상무', '15','영남', '기타') park_nm, \n"+
					" decode(r.park,'6',substr(r.park_cont,1,5),nvl(cd.nm,r.park))  park_nm, \n"+			
			"		decode(r.car_use,'1',r.car_end_dt) car_end_dt, r.car_mng_id CAR_MNG_ID, r.car_no CAR_NO, r.car_num CAR_NUM, r.init_reg_dt	INIT_REG_DT, r.car_kd CAR_KD, r.car_use	CAR_USE, n.car_nm CAR_JNM, m.car_name CAR_NM, r.car_form CAR_FORM, r.car_y_form	CAR_Y_FORM,	r.dpm			DPM,	r.fuel_kd		FUEL_KD,	r.maint_st_dt	MAINT_ST_DT,	r.maint_end_dt	MAINT_END_DT, r.test_st_dt TEST_ST_DT, r.test_end_dt TEST_END_DT, r.car_l_cd, CAR_L_CD, \n"+
			"		decode(nvl(r.off_ls,'0'),'0',decode(nvl(r.prepare,'0'), '2','  매각', '3','  보관', '4','말소', '5','도난', '9','미회수', '6','해지', '7',' 비대상', decode(c.client_id,'000231',' 중앙(영)', decode(r.car_mng_id,'000797','창고','   예비')) ), '1','매각결정','2','소매','3','경매','4','수의') PREPARE, \n"+
			"		e.rent_mng_id	RENT_MNG_ID,	e.rent_l_cd		RENT_L_CD,	e.car_id		CAR_ID,	e.colo			COLO, e.opt			OPT,	e.car_cs_amt	CAR_CS_AMT,	e.car_cv_amt	CAR_CV_AMT,	e.car_fs_amt	CAR_FS_AMT,	e.car_fv_amt	CAR_FV_AMT,	e.opt_cs_amt	OPT_CS_AMT,	e.opt_cv_amt	OPT_CV_AMT,	e.opt_fs_amt	OPT_FS_AMT,	e.opt_fv_amt	OPT_FV_AMT,	e.clr_cs_amt	CLR_CS_AMT,	e.clr_cv_amt	CLR_CV_AMT,	e.clr_fs_amt	CLR_FS_AMT,	e.clr_fv_amt	CLR_FV_AMT,	e.sd_cs_amt		SD_CS_AMT,	e.sd_cv_amt		SD_CV_AMT,	e.sd_fs_amt		SD_FS_AMT,	e.sd_fv_amt		SD_FV_AMT,	e.dc_cs_amt		DC_CS_AMT,	e.dc_cv_amt		DC_CV_AMT,	e.dc_fs_amt		DC_FS_AMT,	e.dc_fv_amt		DC_FV_AMT, c.mng_id		MNG_ID, c.dlv_dt DLV_DT,	decode(r.car_mng_id, sq.car_mng_id, 1, 0) ACCIDENT_YN, \n"+
			"	    vt.tot_dist TOT_DIST, \n"+
			"		decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD'))))) as AVERAGE_DIST, \n"+
			"		decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST, \n"+
		//	"		bk.bank_nm BANK_NM, bk.lend_prn LEND_PRN,  bk.alt_end_dt ALT_END_DT, sw.alt_rest LEND_REM, \n"+
			"       s.lev LEV, s.reason REASON, s.car_st CAR_ST, s.imgfile1 IMGFILE1, s.imgfile2 IMGFILE2, s.imgfile3 IMGFILE3, s.imgfile4 IMGFILE4, s.imgfile5 IMGFILE5, s.damdang_id DAMDANG_ID, s.modify_id MODIFY_ID, s.apprsl_dt APPRSL_DT, DECODE(r.car_mng_id, ch.car_mng_id, 1, 0) CAR_CHA_YN, \n"+
			"		iu.ins_com_nm INS_COM_NM, iu.ins_exp_dt INS_EXP_DT, s.driver DRIVER, \n"+	
			"		r.secondhand, o.actn_dt, to_char(to_date(o.actn_dt,'YYYYMMDD')+7,'YYYYMMDD') actn_est_dt, \n"+
			"		/*보유차*/ nvl(rh.ret_plan_dt,ri.ret_plan_dt) as ret_plan_dt, "+
			" 	               decode(r.off_ls,'3',decode(o.actn_st,'2',to_char(to_date(o.actn_dt,'YYYYMMDD')+7,'YYYYMMDD'),o.actn_dt),decode(nvl(rh.rent_st,ri.rent_st),'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트','대기')) rent_st_nm, \n"+
			"		decode(nvl(r.off_ls,'0'),'3',decode(o.actn_st,'1','경매진행중','2','유찰','3','개별상담','4','낙찰','출품예정'),'') actn_st, \n"+
			"  		TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(replace(r.init_reg_dt,'-',''), 'YYYYMMDD'))) use_mon, \n"+
			"       decode(r.gps,'Y','장착') gps, m.jg_code, iu.con_f_nm, r.park_cont, r.park as park_nm, r.rm_yn, c.car_gu, r.ncar_spe_dc_amt, r.spe_dc_per \n"+	
//			"       decode(cc.rent_l_cd,'','','해지반납') call_in_st "+
			"	from \n"+
			"		car_reg r, car_etc e, cont c, apprsl s, CAR_NM m, CAR_MNG n, v_tot_dist vt, (select distinct ac.car_mng_id CAR_MNG_ID from accident ac, car_reg re where ac.car_mng_id=re.car_mng_id) sq, \n"+
	//		"		(select a.car_mng_id CAR_MNG_ID, a.serv_dt SERV_DT, a.tot_dist TOT_DIST  from service a where a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where car_mng_id = a.car_mng_id)) i, \n"+
	//		"		(select al.rent_mng_id RENT_MNG_ID, al.rent_l_cd RENT_L_CD, cd.nm BANK_NM, al.lend_prn LEND_PRN, al.alt_end_dt ALT_END_DT from allot al, code cd where al.cpt_cd = cd.code and cd.c_st = '0003') bk, \n"+
			"		(SELECT DISTINCT cc.car_mng_id CAR_MNG_ID FROM car_cha cc, car_reg re WHERE cc.car_mng_id = re.car_mng_id) ch, \n"+
	//		"		(SELECT sc.car_mng_id CAR_MNG_ID, sc.alt_rest ALT_REST FROM scd_alt_case sc WHERE sc.alt_tm = (select max(alt_tm) from scd_alt_case where car_mng_id = sc.car_mng_id)) sw, \n"+
			"		(select ir.car_mng_id CAR_MNG_ID, ic.ins_com_nm INS_COM_NM, ir.ins_exp_dt INS_EXP_DT, ir.con_f_nm from insur ir, ins_com ic where ir.ins_com_id = ic.ins_com_id and ir.ins_st = (select max(ins_st) from insur where car_mng_id = ir.car_mng_id)) iu, \n"+
	        "       (select * from rent_cont a  where (a.car_mng_id, a.rent_s_cd) in (select car_mng_id, max(rent_s_cd) from rent_cont where use_st = '2' and rent_st<>'11' group by car_mng_id)) rh, \n"+
			"		(select * from rent_cont a  where (a.car_mng_id, a.rent_s_cd) in (select car_mng_id, max(rent_s_cd) from rent_cont where use_st = '1' and rent_st<>'11' group by car_mng_id)) ri, \n"+
			"		(select * from auction a where a.seq = (select max(seq) from auction where car_mng_id=a.car_mng_id)) o, \n"+
			"        ( select c_st, code, nm_cd, nm from code where c_st = '0027' and code <> '0000'  ) cd,  \n"+  //주차장 
            //차량해지반납
			"       ( select * from car_call_in where in_st='3' and out_dt is null ) cc "+
			"	where r.car_mng_id = c.car_mng_id \n"+
			"		and e.rent_mng_id = c.rent_mng_id \n"+
			"		and e.rent_l_cd = c.rent_l_cd \n"+
			"		and r.car_mng_id = sq.car_mng_id(+) \n"+
//			"		and c.car_st = '2' \n"+
			"		and c.use_yn = 'Y' \n"+
			"		and nvl(r.off_ls,'0') not in ('5','6') \n"+
		//	"		and r.car_mng_id = i.car_mng_id(+) \n"+
		//	"		and c.rent_mng_id = bk.rent_mng_id(+) \n"+
		//	"		and c.rent_l_cd = bk.rent_l_cd(+) \n"+
			"		and r.car_mng_id = s.car_mng_id(+) \n"+
			"		and r.car_mng_id = ch.car_mng_id(+) \n"+
		//	"		AND r.car_mng_id = sw.car_mng_id(+) \n"+
			"		and r.car_mng_id = iu.car_mng_id(+) \n"+
			"		AND e.car_id = m.car_id \n"+
			"		and e.car_seq = m.car_seq \n"+
			"		and m.car_comp_id = n.car_comp_id \n"+
			"		and m.car_cd = n.code \n"+
			"		and r.car_mng_id=vt.car_mng_id(+) \n"+
			"		and r.car_mng_id=rh.car_mng_id(+) \n"+
			"		and r.car_mng_id=ri.car_mng_id(+) \n"+
			"		and r.car_mng_id=o.car_mng_id(+) \n"+
			"  and r.park = cd.nm_cd(+) \n"+  //주차장 코드 테이블 
			"       and c.rent_mng_id=cc.rent_mng_id(+) and c.rent_l_cd=cc.rent_l_cd(+)"+						
			"       and decode(cc.rent_l_cd,'',c.car_st,'')='2'"+
			subQuery +
			"	ORDER BY nvl(r.off_ls,'0'), o.actn_dt, prepare, secondhand desc, dpm, init_reg_dt";
		}else{
			query = " select '' BANK_NM, '' LEND_PRN, '' ALT_END_DT, '' LEND_REM,  \n"+
				//"  decode(r.park,'1','목동', '2','정일', '3','부산', '4','대전', '5','명진', '7','부경','8','조양','9','현대','10','오토', '11','금호','12','광주','13','대구','14','상무', '15','영남', '기타') park_nm, \n"+
				"  decode(r.park,'6',substr(r.park_cont,1,5),nvl(cd.nm,r.park))  park_nm, \n"+
			"		decode(r.car_use,'1',r.car_end_dt) car_end_dt, r.car_mng_id CAR_MNG_ID, r.car_no CAR_NO, r.car_num CAR_NUM, r.init_reg_dt	INIT_REG_DT, r.car_kd CAR_KD, r.car_use	CAR_USE, n.car_nm CAR_JNM,m.car_name	CAR_NM,	r.car_form CAR_FORM, r.car_y_form	CAR_Y_FORM,	r.dpm			DPM,	r.fuel_kd		FUEL_KD,	r.maint_st_dt	MAINT_ST_DT,	r.maint_end_dt	MAINT_END_DT, r.test_st_dt TEST_ST_DT, r.test_end_dt TEST_END_DT, r.car_l_cd, CAR_L_CD, \n"+
			"		decode(nvl(r.off_ls,'0'),'0',decode(nvl(r.prepare,'0'), '2','  매각', '3','  보관', '4','말소', '5','도난', '9', '미회수', '6','해지', '7',' 비대상', decode(c.client_id,'000231',' 중앙(영)', decode(r.car_mng_id,'000797','창고','   예비')) ), '1','매각결정','2','소매','3','경매','4','수의') PREPARE, \n"+
			"		e.rent_mng_id	RENT_MNG_ID,	e.rent_l_cd		RENT_L_CD,	e.car_id		CAR_ID,	e.colo			COLO, e.opt			OPT,	e.car_cs_amt	CAR_CS_AMT,	e.car_cv_amt	CAR_CV_AMT,	e.car_fs_amt	CAR_FS_AMT,	e.car_fv_amt	CAR_FV_AMT,	e.opt_cs_amt	OPT_CS_AMT,	e.opt_cv_amt	OPT_CV_AMT,	e.opt_fs_amt	OPT_FS_AMT,	e.opt_fv_amt	OPT_FV_AMT,	e.clr_cs_amt	CLR_CS_AMT,	e.clr_cv_amt	CLR_CV_AMT,	e.clr_fs_amt	CLR_FS_AMT,	e.clr_fv_amt	CLR_FV_AMT,	e.sd_cs_amt		SD_CS_AMT,	e.sd_cv_amt		SD_CV_AMT,	e.sd_fs_amt		SD_FS_AMT,	e.sd_fv_amt		SD_FV_AMT,	e.dc_cs_amt		DC_CS_AMT,	e.dc_cv_amt		DC_CV_AMT,	e.dc_fs_amt		DC_FS_AMT,	e.dc_fv_amt		DC_FV_AMT, c.mng_id		MNG_ID, c.dlv_dt DLV_DT,	decode(r.car_mng_id, sq.car_mng_id, 1, 0) ACCIDENT_YN, \n"+
			"   	vt.tot_dist TOT_DIST, \n"+
			"		decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD'))))) as AVERAGE_DIST, "+
			"		decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST, \n"+
		//	"		bk.bank_nm BANK_NM, bk.lend_prn LEND_PRN,  bk.alt_end_dt ALT_END_DT, sw.alt_rest LEND_REM, \n"+
			"		s.lev LEV, s.reason REASON, s.car_st CAR_ST, s.imgfile1 IMGFILE1, s.imgfile2 IMGFILE2, s.imgfile3 IMGFILE3, s.imgfile4 IMGFILE4, s.imgfile5 IMGFILE5, s.damdang_id DAMDANG_ID, s.modify_id MODIFY_ID, s.apprsl_dt APPRSL_DT, DECODE(r.car_mng_id, ch.car_mng_id, 1, 0) CAR_CHA_YN, \n"+
			"		iu.ins_com_nm INS_COM_NM, iu.ins_exp_dt INS_EXP_DT, s.driver DRIVER, \n"+	
			"		r.secondhand, o.actn_dt,  to_char(to_date(o.actn_dt,'YYYYMMDD')+7,'YYYYMMDD') actn_est_dt,\n"+
			"		/*보유차*/ nvl(rh.ret_plan_dt,ri.ret_plan_dt) as ret_plan_dt, decode(r.off_ls,'3',decode(o.actn_st,'2',to_char(to_date(o.actn_dt,'YYYYMMDD')+7,'YYYYMMDD'),o.actn_dt),decode(nvl(rh.rent_st,ri.rent_st),'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트','대기')) rent_st_nm,\n"+
			"		decode(nvl(r.off_ls,'0'),'3',decode(o.actn_st,'1','경매진행중','2','유찰','3','개별상담','4','낙찰','출품예정'),'') actn_st, \n"+
			"  		TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(replace(r.init_reg_dt,'-',''), 'YYYYMMDD'))) use_mon,\n"+
			"       decode(r.gps,'Y','장착') gps, m.jg_code, iu.con_f_nm, r.park_cont, r.park as park_nm, r.rm_yn, c.car_gu, r.ncar_spe_dc_amt, r.spe_dc_per \n"+	
//			"       decode(cc.rent_l_cd,'','','해지반납') call_in_st "+
			"	from \n"+
			"		car_reg r, car_etc e, cont c, apprsl s, CAR_NM m, CAR_MNG n, v_tot_dist vt, (select distinct ac.car_mng_id CAR_MNG_ID from accident ac, car_reg re where ac.car_mng_id=re.car_mng_id) sq, \n"+
	//		"		(select a.car_mng_id CAR_MNG_ID, a.serv_dt SERV_DT, a.tot_dist TOT_DIST  from service a where a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where car_mng_id = a.car_mng_id)) i, \n"+
	//		"		(select al.rent_mng_id RENT_MNG_ID, al.rent_l_cd RENT_L_CD, cd.nm BANK_NM, al.lend_prn LEND_PRN, al.alt_end_dt ALT_END_DT from allot al, code cd where al.cpt_cd = cd.code and cd.c_st = '0003') bk, \n"+
			"		(SELECT DISTINCT cc.car_mng_id CAR_MNG_ID FROM car_cha cc, car_reg re WHERE cc.car_mng_id = re.car_mng_id) ch, \n"+
	//		"		(SELECT sc.car_mng_id CAR_MNG_ID, sc.alt_rest ALT_REST FROM scd_alt_case sc WHERE sc.alt_tm = (select max(alt_tm) from scd_alt_case where car_mng_id = sc.car_mng_id)) sw, \n"+
			"		(select ir.car_mng_id CAR_MNG_ID, ic.ins_com_nm INS_COM_NM, ir.ins_exp_dt INS_EXP_DT, ir.con_f_nm from insur ir, ins_com ic where ir.ins_com_id = ic.ins_com_id and ir.ins_st = (select max(ins_st) from insur where car_mng_id = ir.car_mng_id)) iu, \n"+
	        "       (select * from rent_cont a  where (a.car_mng_id, a.rent_s_cd) in (select car_mng_id, max(rent_s_cd) from rent_cont where use_st = '2' and rent_st<>'11' group by car_mng_id)) rh, \n"+
			"		(select * from rent_cont a  where (a.car_mng_id, a.rent_s_cd) in (select car_mng_id, max(rent_s_cd) from rent_cont where use_st = '1' and rent_st<>'11' group by car_mng_id)) ri, \n"+
			"		(select * from auction a where a.seq = (select max(seq) from auction where car_mng_id=a.car_mng_id)) o, \n"+
			"        ( select c_st, code, nm_cd, nm from code where c_st = '0027' and code <> '0000'  ) cd,  \n"+  //주차장 
            //차량해지반납
			"       ( select * from car_call_in where in_st='3' and out_dt is null ) cc "+
			"	where r.car_mng_id = c.car_mng_id \n"+
			"		and e.rent_mng_id = c.rent_mng_id \n"+
			"		and e.rent_l_cd = c.rent_l_cd \n"+
			"		and r.car_mng_id = sq.car_mng_id(+) \n"+
//			"		and c.car_st = '2' \n"+
			"		and c.use_yn = 'Y' \n"+
			"		and nvl(r.off_ls,'0') not in ('5','6') \n"+
	//		"		and r.car_mng_id = i.car_mng_id(+) \n"+
	//		"		and c.rent_mng_id = bk.rent_mng_id(+) \n"+
	//		"		and c.rent_l_cd = bk.rent_l_cd(+) \n"+
			"		and r.car_mng_id = s.car_mng_id(+) \n"+
			"		and r.car_mng_id = ch.car_mng_id(+) \n"+
	//		"		AND r.car_mng_id = sw.car_mng_id(+) \n"+
			"		and r.car_mng_id = iu.car_mng_id(+) \n"+
			"		AND e.car_id = m.car_id \n"+
			"		and e.car_seq = m.car_seq \n"+
			"		and m.car_comp_id = n.car_comp_id \n"+
			"		and m.car_cd = n.code \n"+
			"		and r.car_mng_id=vt.car_mng_id(+)\n"+
			"		and r.car_mng_id=rh.car_mng_id(+)\n"+
			"		and r.car_mng_id=ri.car_mng_id(+)\n"+
			"		and r.car_mng_id=o.car_mng_id(+)\n"+
				" and r.park = cd.nm_cd(+) \n"+  //주차장 코드 테이블 
			"       and c.rent_mng_id=cc.rent_mng_id(+) and c.rent_l_cd=cc.rent_l_cd(+)"+						
			"       and decode(cc.rent_l_cd,'',c.car_st,'')='2'"+
			subQuery +
			" ORDER BY nvl(r.off_ls,'0'), o.actn_dt, prepare, secondhand desc, dpm, init_reg_dt";
		}
		
		
		Collection<Offls_ybBean> col = new ArrayList<Offls_ybBean>();

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while(rs.next()){
				col.add(makeOffls_ybBean(rs));
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_ybDatabase:getYb_lst(String gubun, String gubun_nm)]"+e);
			System.out.println("[Offls_ybDatabase:getYb_lst(String gubun, String gubun_nm)]"+query);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return (Offls_ybBean[])col.toArray(new Offls_ybBean[0]);
		}		
	}

	/*기존 예비차량검색을 오버로딩하여 생성 gubun3를 추가하여 검색조건 추가*/
	public Offls_ybBean[] getYb_lst(String gubun, String gubun_nm, String brch_id, String gubun2,String gubun3,String gubun4,String gubun5){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String subQuery = "";

		if(gubun.equals("car_no")){
			subQuery = " and r.car_no like '%" + gubun_nm + "%'";
		}else if(gubun.equals("car_nm")){
			subQuery = " and r.car_nm like '%" + gubun_nm.toUpperCase() + "%'";
		}else if(gubun.equals("init_reg_dt")){
			subQuery = " and r.init_reg_dt like replace('"+ gubun_nm +"','-','')||'%'";
		}else if(gubun.equals("month_rent")){
			subQuery = " AND decode(nvl(rh.rent_st,ri.rent_st),'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트','대기') <> '월렌트' ";

		}else{ //all
			subQuery = "";
		}

		if(gubun2.equals("Y"))	subQuery += " and decode(r.off_ls,'3',decode(o.actn_st,'2',to_char(to_date(o.actn_dt,'YYYYMMDD')+7,'YYYYMMDD'),o.actn_dt),decode(nvl(rh.rent_st,ri.rent_st),'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트','대기'))='업무대여'";
		else if (gubun2.equals("N")){
			subQuery += " and decode(r.off_ls,'3',decode(o.actn_st,'2',to_char(to_date(o.actn_dt,'YYYYMMDD')+7,'YYYYMMDD'),o.actn_dt),decode(nvl(rh.rent_st,ri.rent_st),'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트','대기'))<>'업무대여'";
		}
		if(gubun3.equals("lease_y"))	subQuery += " and r.prepare ='1' and r.secondhand='1'";
		else if (gubun3.equals("lease_n")){
			subQuery += " and NVL(r.secondhand,'0')='0'";
		}else if(gubun3.equals("rent_y")){
			subQuery += " and NVL(r.rm_yn,'Y')='Y'";
		}
		else if(gubun3.equals("rent_n")){
			subQuery += " and NVL(r.rm_yn,'Y')='N'";
		}
		if(!brch_id.equals(""))	subQuery += " and c.brch_id='"+brch_id+"'";
		if(gubun4.equals("1")) subQuery += "ORDER BY decode(r.park, '1','1', '2','6', '3','2', '4','4', '5','1', '7','2','8','2','9','4','10','1', '11','4', '12','5', '13','3', '14','7', '9')";
		else if(gubun4.equals("2")) subQuery += "ORDER BY decode(nvl(r.off_ls,'0'),'0',decode(nvl(r.prepare,'0'), '2','매각', '3','보관', '4','말소', '5','도난', '9', '미회수', '6','해지', '7','비대상', decode(c.client_id,'000231',' 중앙(영)', decode(r.car_mng_id,'000797','창고','예비')) ), '1','매각결정','2','소매','3','경매','4','수의')";
		else if(gubun4.equals("3")) subQuery += "ORDER BY r.car_no";
		else if(gubun4.equals("4")) subQuery += "ORDER BY car_jnm";
		if(gubun5.equals("asc")) subQuery += " asc" ;
		else if(gubun5.equals("desc")) subQuery +=" desc";

		if(gubun.equals("car_no")){
			query = " select	'' BANK_NM, '' LEND_PRN, '' ALT_END_DT, '' LEND_REM,  \n"+
					//" decode(r.park,'1','목동주차', '2','정일현대', '3','부산지점', '4','대전지점', '5','명진공업', '7','부산부경','8','부산조양','9','대전현대','10','오토크린', '11','대전금호','12','광주지점','13','대구지점','14','상무현대', '15','영남주차', '16','동화엠파크', substr(r.park_cont,1,5)) park_nm, \n"+
					"  decode(r.park,'6',substr(r.park_cont,1,5),nvl(cd.nm,r.park)) park_nm, \n"+
			"		decode(r.car_use,'1',r.car_end_dt) car_end_dt, r.car_mng_id CAR_MNG_ID, r.car_no CAR_NO, r.car_num CAR_NUM, r.init_reg_dt	INIT_REG_DT, r.car_kd CAR_KD, r.car_use	CAR_USE, n.car_nm CAR_JNM, m.car_name CAR_NM, r.car_form CAR_FORM, r.car_y_form	CAR_Y_FORM,	r.dpm			DPM,	r.fuel_kd		FUEL_KD,	r.maint_st_dt	MAINT_ST_DT,	r.maint_end_dt	MAINT_END_DT, r.test_st_dt TEST_ST_DT, r.test_end_dt TEST_END_DT, r.car_l_cd, CAR_L_CD, \n"+
			"		decode(nvl(r.off_ls,'0'),'0',decode(nvl(r.prepare,'0'), '2','  매각', '3','  보관', '4','말소', '5','도난', '9','미회수', '6','해지', '7',' 비대상', decode(c.client_id,'000231',' 중앙(영)', decode(r.car_mng_id,'000797','창고','   예비')) ), '1','매각결정','2','소매','3','경매','4','수의') PREPARE, \n"+
			"		e.rent_mng_id	RENT_MNG_ID,	e.rent_l_cd		RENT_L_CD,	e.car_id		CAR_ID,	e.colo			COLO, e.opt			OPT,	e.car_cs_amt	CAR_CS_AMT,	e.car_cv_amt	CAR_CV_AMT,	e.car_fs_amt	CAR_FS_AMT,	e.car_fv_amt	CAR_FV_AMT,	e.opt_cs_amt	OPT_CS_AMT,	e.opt_cv_amt	OPT_CV_AMT,	e.opt_fs_amt	OPT_FS_AMT,	e.opt_fv_amt	OPT_FV_AMT,	e.clr_cs_amt	CLR_CS_AMT,	e.clr_cv_amt	CLR_CV_AMT,	e.clr_fs_amt	CLR_FS_AMT,	e.clr_fv_amt	CLR_FV_AMT,	e.sd_cs_amt		SD_CS_AMT,	e.sd_cv_amt		SD_CV_AMT,	e.sd_fs_amt		SD_FS_AMT,	e.sd_fv_amt		SD_FV_AMT,	e.dc_cs_amt		DC_CS_AMT,	e.dc_cv_amt		DC_CV_AMT,	e.dc_fs_amt		DC_FS_AMT,	e.dc_fv_amt		DC_FV_AMT, c.mng_id		MNG_ID, c.dlv_dt DLV_DT,	decode(r.car_mng_id, sq.car_mng_id, 1, 0) ACCIDENT_YN, \n"+
			"	    vt.tot_dist TOT_DIST, \n"+
			"		decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD'))))) as AVERAGE_DIST, \n"+
			"		decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST, \n"+
		//	"		bk.bank_nm BANK_NM, bk.lend_prn LEND_PRN,  bk.alt_end_dt ALT_END_DT, sw.alt_rest LEND_REM, \n"+
			"       s.lev LEV, s.reason REASON, s.car_st CAR_ST, s.imgfile1 IMGFILE1, s.imgfile2 IMGFILE2, s.imgfile3 IMGFILE3, s.imgfile4 IMGFILE4, s.imgfile5 IMGFILE5, s.damdang_id DAMDANG_ID, s.modify_id MODIFY_ID, s.apprsl_dt APPRSL_DT, DECODE(r.car_mng_id, ch.car_mng_id, 1, 0) CAR_CHA_YN, \n"+
			"		iu.ins_com_nm INS_COM_NM, iu.ins_exp_dt INS_EXP_DT, s.driver DRIVER, \n"+	
			"		r.secondhand, o.actn_dt, to_char(to_date(o.actn_dt,'YYYYMMDD')+7,'YYYYMMDD') actn_est_dt, \n"+
			"		/*보유차*/ nvl(rh.ret_plan_dt,ri.ret_plan_dt) as ret_plan_dt, "+
			" 	               decode(r.off_ls,'3',decode(o.actn_st,'2',to_char(to_date(o.actn_dt,'YYYYMMDD')+7,'YYYYMMDD'),o.actn_dt),decode(nvl(rh.rent_st,ri.rent_st),'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트','대기')) rent_st_nm, \n"+
			"		decode(nvl(r.off_ls,'0'),'3',decode(o.actn_st,'1','경매진행중','2','유찰','3','개별상담','4','낙찰','출품예정'),'') actn_st, \n"+
			"  		TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(replace(r.init_reg_dt,'-',''), 'YYYYMMDD'))) use_mon, \n"+
			"       decode(r.gps,'Y','장착') gps, m.jg_code, iu.con_f_nm, r.park_cont, r.park as park_nm, r.rm_yn, c.car_gu, r.ncar_spe_dc_amt, r.spe_dc_per \n"+	
//			"       decode(cc.rent_l_cd,'','','해지반납') call_in_st "+
			"	from \n"+
			"		car_reg r, car_etc e, cont c, apprsl s, CAR_NM m, CAR_MNG n, v_tot_dist vt, (select distinct ac.car_mng_id CAR_MNG_ID from accident ac, car_reg re where ac.car_mng_id=re.car_mng_id) sq, \n"+
	//		"		(select a.car_mng_id CAR_MNG_ID, a.serv_dt SERV_DT, a.tot_dist TOT_DIST  from service a where a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where car_mng_id = a.car_mng_id)) i, \n"+
	//		"		(select al.rent_mng_id RENT_MNG_ID, al.rent_l_cd RENT_L_CD, cd.nm BANK_NM, al.lend_prn LEND_PRN, al.alt_end_dt ALT_END_DT from allot al, code cd where al.cpt_cd = cd.code and cd.c_st = '0003') bk, \n"+
			"		(SELECT DISTINCT cc.car_mng_id CAR_MNG_ID FROM car_cha cc, car_reg re WHERE cc.car_mng_id = re.car_mng_id) ch, \n"+
	//		"		(SELECT sc.car_mng_id CAR_MNG_ID, sc.alt_rest ALT_REST FROM scd_alt_case sc WHERE sc.alt_tm = (select max(alt_tm) from scd_alt_case where car_mng_id = sc.car_mng_id)) sw, \n"+
			"		(select ir.car_mng_id CAR_MNG_ID, ic.ins_com_nm INS_COM_NM, ir.ins_exp_dt INS_EXP_DT, ir.con_f_nm from insur ir, ins_com ic where ir.ins_com_id = ic.ins_com_id and ir.ins_st = (select max(ins_st) from insur where car_mng_id = ir.car_mng_id)) iu, \n"+
	        "       (select * from rent_cont a  where (a.car_mng_id, a.rent_s_cd) in (select car_mng_id, max(rent_s_cd) from rent_cont where use_st = '2' and rent_st<>'11' group by car_mng_id)) rh, \n"+
			"		(select * from rent_cont a  where (a.car_mng_id, a.rent_s_cd) in (select car_mng_id, max(rent_s_cd) from rent_cont where use_st = '1' and rent_st<>'11' group by car_mng_id)) ri, \n"+
			"		(select * from auction a where a.seq = (select max(seq) from auction where car_mng_id=a.car_mng_id)) o, \n"+
				"        ( select c_st, code, nm_cd, nm from code where c_st = '0027' and code <> '0000'  ) cd,  \n"+  //주차장 
            //차량해지반납
			"       ( select * from car_call_in where in_st='3' and out_dt is null ) cc "+
			"	where r.car_mng_id = c.car_mng_id \n"+
			"		and e.rent_mng_id = c.rent_mng_id \n"+
			"		and e.rent_l_cd = c.rent_l_cd \n"+
			"		and r.car_mng_id = sq.car_mng_id(+) \n"+
//			"		and c.car_st = '2' \n"+
			"		and c.use_yn = 'Y' \n"+
			"		and nvl(r.off_ls,'0') not in ('5','6') \n"+
		//	"		and r.car_mng_id = i.car_mng_id(+) \n"+
		//	"		and c.rent_mng_id = bk.rent_mng_id(+) \n"+
		//	"		and c.rent_l_cd = bk.rent_l_cd(+) \n"+
			"		and r.car_mng_id = s.car_mng_id(+) \n"+
			"		and r.car_mng_id = ch.car_mng_id(+) \n"+
		//	"		AND r.car_mng_id = sw.car_mng_id(+) \n"+
			"		and r.car_mng_id = iu.car_mng_id(+) \n"+
			"		AND e.car_id = m.car_id \n"+
			"		and e.car_seq = m.car_seq \n"+
			"		and m.car_comp_id = n.car_comp_id \n"+
			"		and m.car_cd = n.code \n"+
			"		and r.car_mng_id=vt.car_mng_id(+) \n"+
			"		and r.car_mng_id=rh.car_mng_id(+) \n"+
			"		and r.car_mng_id=ri.car_mng_id(+) \n"+
			"		and r.car_mng_id=o.car_mng_id(+) \n"+
			"       and c.rent_mng_id=cc.rent_mng_id(+) and c.rent_l_cd=cc.rent_l_cd(+)"+				
				" and r.park = cd.nm_cd(+) \n"+  //주차장 코드 테이블 		
			"       and decode(cc.rent_l_cd,'',c.car_st,'')='2'"+
			subQuery;
		}else{
			query = " select '' BANK_NM, '' LEND_PRN, '' ALT_END_DT, '' LEND_REM,  \n"+
				//" decode(r.park,'1','목동주차', '2','정일현대', '3','부산지점', '4','대전지점', '5','명진공업', '7','부산부경','8','부산조양','9','대전현대','10','오토크린', '11','대전금호','12','광주지점','13','대구지점','14','상무현대', '15','영남주차', '16','동화엠파크', substr(r.park_cont,1,5)) park_nm, \n"+
				" decode(r.park,'6',substr(r.park_cont,1,5),nvl(cd.nm,r.park)) park_nm, \n"+
			"		decode(r.car_use,'1',r.car_end_dt) car_end_dt, r.car_mng_id CAR_MNG_ID, r.car_no CAR_NO, r.car_num CAR_NUM, r.init_reg_dt	INIT_REG_DT, r.car_kd CAR_KD, r.car_use	CAR_USE, n.car_nm CAR_JNM,m.car_name	CAR_NM,	r.car_form CAR_FORM, r.car_y_form	CAR_Y_FORM,	r.dpm			DPM,	r.fuel_kd		FUEL_KD,	r.maint_st_dt	MAINT_ST_DT,	r.maint_end_dt	MAINT_END_DT, r.test_st_dt TEST_ST_DT, r.test_end_dt TEST_END_DT, r.car_l_cd, CAR_L_CD, \n"+
			"		decode(nvl(r.off_ls,'0'),'0',decode(nvl(r.prepare,'0'), '2','  매각', '3','  보관', '4','말소', '5','도난', '9', '미회수', '6','해지', '7',' 비대상', decode(c.client_id,'000231',' 중앙(영)', decode(r.car_mng_id,'000797','창고','   예비')) ), '1','매각결정','2','소매','3','경매','4','수의') PREPARE, \n"+
			"		e.rent_mng_id	RENT_MNG_ID,	e.rent_l_cd		RENT_L_CD,	e.car_id		CAR_ID,	e.colo			COLO, e.opt			OPT,	e.car_cs_amt	CAR_CS_AMT,	e.car_cv_amt	CAR_CV_AMT,	e.car_fs_amt	CAR_FS_AMT,	e.car_fv_amt	CAR_FV_AMT,	e.opt_cs_amt	OPT_CS_AMT,	e.opt_cv_amt	OPT_CV_AMT,	e.opt_fs_amt	OPT_FS_AMT,	e.opt_fv_amt	OPT_FV_AMT,	e.clr_cs_amt	CLR_CS_AMT,	e.clr_cv_amt	CLR_CV_AMT,	e.clr_fs_amt	CLR_FS_AMT,	e.clr_fv_amt	CLR_FV_AMT,	e.sd_cs_amt		SD_CS_AMT,	e.sd_cv_amt		SD_CV_AMT,	e.sd_fs_amt		SD_FS_AMT,	e.sd_fv_amt		SD_FV_AMT,	e.dc_cs_amt		DC_CS_AMT,	e.dc_cv_amt		DC_CV_AMT,	e.dc_fs_amt		DC_FS_AMT,	e.dc_fv_amt		DC_FV_AMT, c.mng_id		MNG_ID, c.dlv_dt DLV_DT,	decode(r.car_mng_id, sq.car_mng_id, 1, 0) ACCIDENT_YN, \n"+
			"   	vt.tot_dist TOT_DIST, \n"+
			"		decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD'))))) as AVERAGE_DIST, "+
			"		decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST, \n"+
		//	"		bk.bank_nm BANK_NM, bk.lend_prn LEND_PRN,  bk.alt_end_dt ALT_END_DT, sw.alt_rest LEND_REM, \n"+
			"		s.lev LEV, s.reason REASON, s.car_st CAR_ST, s.imgfile1 IMGFILE1, s.imgfile2 IMGFILE2, s.imgfile3 IMGFILE3, s.imgfile4 IMGFILE4, s.imgfile5 IMGFILE5, s.damdang_id DAMDANG_ID, s.modify_id MODIFY_ID, s.apprsl_dt APPRSL_DT, DECODE(r.car_mng_id, ch.car_mng_id, 1, 0) CAR_CHA_YN, \n"+
			"		iu.ins_com_nm INS_COM_NM, iu.ins_exp_dt INS_EXP_DT, s.driver DRIVER, \n"+	
			"		r.secondhand, o.actn_dt,  to_char(to_date(o.actn_dt,'YYYYMMDD')+7,'YYYYMMDD') actn_est_dt,\n"+
			"		/*보유차*/ nvl(rh.ret_plan_dt,ri.ret_plan_dt) as ret_plan_dt, decode(r.off_ls,'3',decode(o.actn_st,'2',to_char(to_date(o.actn_dt,'YYYYMMDD')+7,'YYYYMMDD'),o.actn_dt),decode(nvl(rh.rent_st,ri.rent_st),'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트','대기')) rent_st_nm,\n"+
			"		decode(nvl(r.off_ls,'0'),'3',decode(o.actn_st,'1','경매진행중','2','유찰','3','개별상담','4','낙찰','출품예정'),'') actn_st, \n"+
			"  		TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(replace(r.init_reg_dt,'-',''), 'YYYYMMDD'))) use_mon,\n"+
			"       decode(r.gps,'Y','장착') gps, m.jg_code, iu.con_f_nm, r.park_cont, r.park as park_nm, r.rm_yn, c.car_gu, r.ncar_spe_dc_amt, r.spe_dc_per \n"+	
//			"       decode(cc.rent_l_cd,'','','해지반납') call_in_st "+
			"	from \n"+
			"		car_reg r, car_etc e, cont c, apprsl s, CAR_NM m, CAR_MNG n, v_tot_dist vt, (select distinct ac.car_mng_id CAR_MNG_ID from accident ac, car_reg re where ac.car_mng_id=re.car_mng_id) sq, \n"+
	//		"		(select a.car_mng_id CAR_MNG_ID, a.serv_dt SERV_DT, a.tot_dist TOT_DIST  from service a where a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where car_mng_id = a.car_mng_id)) i, \n"+
	//		"		(select al.rent_mng_id RENT_MNG_ID, al.rent_l_cd RENT_L_CD, cd.nm BANK_NM, al.lend_prn LEND_PRN, al.alt_end_dt ALT_END_DT from allot al, code cd where al.cpt_cd = cd.code and cd.c_st = '0003') bk, \n"+
			"		(SELECT DISTINCT cc.car_mng_id CAR_MNG_ID FROM car_cha cc, car_reg re WHERE cc.car_mng_id = re.car_mng_id) ch, \n"+
	//		"		(SELECT sc.car_mng_id CAR_MNG_ID, sc.alt_rest ALT_REST FROM scd_alt_case sc WHERE sc.alt_tm = (select max(alt_tm) from scd_alt_case where car_mng_id = sc.car_mng_id)) sw, \n"+
			"		(select ir.car_mng_id CAR_MNG_ID, ic.ins_com_nm INS_COM_NM, ir.ins_exp_dt INS_EXP_DT, ir.con_f_nm from insur ir, ins_com ic where ir.ins_com_id = ic.ins_com_id and ir.ins_st = (select max(ins_st) from insur where car_mng_id = ir.car_mng_id)) iu, \n"+
	        "       (select * from rent_cont a  where (a.car_mng_id, a.rent_s_cd) in (select car_mng_id, max(rent_s_cd) from rent_cont where use_st = '2' and rent_st<>'11' group by car_mng_id)) rh, \n"+
			"		(select * from rent_cont a  where (a.car_mng_id, a.rent_s_cd) in (select car_mng_id, max(rent_s_cd) from rent_cont where use_st = '1' and rent_st<>'11' group by car_mng_id)) ri, \n"+
			"		(select * from auction a where a.seq = (select max(seq) from auction where car_mng_id=a.car_mng_id)) o, \n"+
				"        ( select c_st, code, nm_cd, nm from code where c_st = '0027' and code <> '0000'  ) cd,  \n"+  //주차장 
            //차량해지반납
			"       ( select * from car_call_in where in_st='3' and out_dt is null ) cc "+
			"	where r.car_mng_id = c.car_mng_id \n"+
			"		and e.rent_mng_id = c.rent_mng_id \n"+
			"		and e.rent_l_cd = c.rent_l_cd \n"+
			"		and r.car_mng_id = sq.car_mng_id(+) \n"+
//			"		and c.car_st = '2' \n"+
			"		and c.use_yn = 'Y' \n"+
			"		and nvl(r.off_ls,'0') not in ('5','6') \n"+
	//		"		and r.car_mng_id = i.car_mng_id(+) \n"+
	//		"		and c.rent_mng_id = bk.rent_mng_id(+) \n"+
	//		"		and c.rent_l_cd = bk.rent_l_cd(+) \n"+
			"		and r.car_mng_id = s.car_mng_id(+) \n"+
			"		and r.car_mng_id = ch.car_mng_id(+) \n"+
	//		"		AND r.car_mng_id = sw.car_mng_id(+) \n"+
			"		and r.car_mng_id = iu.car_mng_id(+) \n"+
			"		AND e.car_id = m.car_id \n"+
			"		and e.car_seq = m.car_seq \n"+
			"		and m.car_comp_id = n.car_comp_id \n"+
			"		and m.car_cd = n.code \n"+
			"		and r.car_mng_id=vt.car_mng_id(+)\n"+
			"		and r.car_mng_id=rh.car_mng_id(+)\n"+
			"		and r.car_mng_id=ri.car_mng_id(+)\n"+
			"		and r.car_mng_id=o.car_mng_id(+)\n"+
			"       and c.rent_mng_id=cc.rent_mng_id(+) and c.rent_l_cd=cc.rent_l_cd(+)"+		
				" and r.park = cd.nm_cd(+) \n"+  //주차장 코드 테이블 				
			"       and decode(cc.rent_l_cd,'',c.car_st,'')='2'"+
			subQuery;
		}
		
//System.out.println("getYb_lst( "+query);
		
		Collection<Offls_ybBean> col = new ArrayList<Offls_ybBean>();

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while(rs.next()){
				col.add(makeOffls_ybBean(rs));
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_ybDatabase:getYb_lst(String gubun, String gubun_nm)]"+e);
			System.out.println("[Offls_ybDatabase:getYb_lst(String gubun, String gubun_nm)]"+query);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return (Offls_ybBean[])col.toArray(new Offls_ybBean[0]);
		}		
	}

	/*기존 예비차량검색을 오버로딩하여 생성 chgubun을 추가하여 검색조건 추가*/
	public Offls_ybBean[] getYb_lst(String gubun, String gubun_nm, String brch_id, String gubun2,String gubun3,String gubun4,String gubun5,String cjgubun){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String subQuery = "";
		
		if(gubun.equals("old_ncar_spe_dc")){
			subQuery = " AND nvl(r.ncar_spe_dc_amt,0)>0";
		}else {
			subQuery = " and decode(cc.rent_l_cd,'',c.car_st,'')='2'";
		}		

		if(gubun.equals("car_no")){
			subQuery += " and r.car_no like '%" + gubun_nm + "%'";
		}else if(gubun.equals("car_nm")){
			subQuery += " and r.car_nm like '%" + gubun_nm.toUpperCase() + "%'";
		}else if(gubun.equals("init_reg_dt")){
			subQuery += " and r.init_reg_dt like replace('"+ gubun_nm +"','-','')||'%'";
		}else if(gubun.equals("month_rent")){
			subQuery += " AND decode(nvl(rh.rent_st,ri.rent_st),'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트','대기') <> '월렌트' ";
		}else if(gubun.equals("ncar_spe_dc")){
			subQuery += " AND nvl(r.ncar_spe_dc_amt,0)>0";
		}


		if(gubun2.equals("Y")){
			subQuery += " and decode(r.off_ls,'3',decode(o.actn_st,'2',to_char(to_date(o.actn_dt,'YYYYMMDD')+7,'YYYYMMDD'),o.actn_dt),decode(nvl(rh.rent_st,ri.rent_st),'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트','대기'))='업무대여'";
		}else if (gubun2.equals("N")){
			subQuery += " and decode(r.off_ls,'3',decode(o.actn_st,'2',to_char(to_date(o.actn_dt,'YYYYMMDD')+7,'YYYYMMDD'),o.actn_dt),decode(nvl(rh.rent_st,ri.rent_st),'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트','대기'))<>'업무대여'";
		}
		if(gubun3.equals("lease_y")){
			subQuery += " and r.prepare ='1' and r.secondhand='1'";
		}else if (gubun3.equals("lease_n")){
			subQuery += " and NVL(r.secondhand,'0')='0'";
		}else if(gubun3.equals("rent_y")){
			subQuery += " and NVL(r.rm_yn,'Y')='Y'";
		}else if(gubun3.equals("rent_n")){
			subQuery += " and NVL(r.rm_yn,'Y')='N'";
		}
		
		if(cjgubun.equals("300")) subQuery += " and m.s_st='300' \n";
		else if(cjgubun.equals("301")) subQuery += " and m.s_st='301' \n";
		else if(cjgubun.equals("302")) subQuery += " and m.s_st='302' \n";
		else if(cjgubun.equals("100")) subQuery += " and m.s_st in ('100','101','409') \n";
		else if(cjgubun.equals("112")) subQuery += " and m.s_st in ('102','112') \n";
		else if(cjgubun.equals("103")) subQuery += " and m.s_st='103' \n";
		else if(cjgubun.equals("104")) subQuery += " and decode(m.s_st, '105','104', decode(substr(m.s_st,1,1),'9','104', m.s_st)) = '104' \n";
		else if(cjgubun.equals("401")) subQuery += " and decode(substr(m.s_st,1,1),'4','401','5','401','6','401','7') = '401' \n";
		else if(cjgubun.equals("701")) subQuery += " and decode(substr(m.s_st,1,1),'7','701') = '701' \n";
		else if(cjgubun.equals("801")) subQuery += " and decode(substr(m.s_st,1,1),'8','801') = '801' \n";
		else if(cjgubun.equals("car_gu_2"))		subQuery += " and ac.car_mng_id is not null ";

		if(!brch_id.equals(""))	subQuery += " and c.brch_id='"+brch_id+"'";
		if(gubun4.equals("1")) subQuery += "ORDER BY decode(r.park, '1','1', '2','6', '3','2', '4','4', '5','1', '7','2','8','2','9','4','10','1', '11','4', '12','5', '13','3', '14','7', '9')";
		else if(gubun4.equals("2")) subQuery += "ORDER BY decode(nvl(r.off_ls,'0'),'0',decode(nvl(r.prepare,'0'), '2','매각', '3','보관', '4','말소', '5','도난', '9', '미회수', '6','해지', '7','비대상', decode(c.client_id,'000231',' 중앙(영)', decode(r.car_mng_id,'000797','창고','예비')) ), '1','매각결정','2','소매','3','경매','4','수의')";
		else if(gubun4.equals("3")) subQuery += "ORDER BY r.car_no";
		else if(gubun4.equals("4")) subQuery += "ORDER BY car_jnm";
		if(gubun5.equals("asc")) subQuery += " asc" ;
		else if(gubun5.equals("desc")) subQuery +=" desc";

		if(gubun.equals("car_no")){
			query = " select	'' BANK_NM, '' LEND_PRN, '' ALT_END_DT, '' LEND_REM,  \n"+
					" decode(r.park,'6',substr(r.park_cont,1,5),nvl(cd.nm,r.park)) park_nm, \n"+
			"		decode(r.car_use,'1',r.car_end_dt) car_end_dt, r.car_mng_id CAR_MNG_ID, r.car_no CAR_NO, r.car_num CAR_NUM, r.init_reg_dt	INIT_REG_DT, r.car_kd CAR_KD, r.car_use	CAR_USE, n.car_nm CAR_JNM, m.car_name CAR_NM, r.car_form CAR_FORM, r.car_y_form	CAR_Y_FORM,	r.dpm			DPM,	r.fuel_kd		FUEL_KD,	r.maint_st_dt	MAINT_ST_DT,	r.maint_end_dt	MAINT_END_DT, r.test_st_dt TEST_ST_DT, r.test_end_dt TEST_END_DT, r.car_l_cd, CAR_L_CD, \n"+
			"		decode(nvl(r.off_ls,'0'),'0',decode(nvl(r.prepare,'0'), '2','매각예정', '3','보류', '4','말소', '5','도난', '9','미회수', '6','해지', '7','비대상', decode(c.client_id,'000231',' 중앙(영)', decode(r.car_mng_id,'000797','창고',' 예비')) ), '1','매각결정','2','소매','3','경매','4','수의') PREPARE, \n"+
			"		e.rent_mng_id	RENT_MNG_ID,	e.rent_l_cd		RENT_L_CD,	e.car_id		CAR_ID,	e.colo			COLO, e.opt			OPT,	e.car_cs_amt	CAR_CS_AMT,	e.car_cv_amt	CAR_CV_AMT,	e.car_fs_amt	CAR_FS_AMT,	e.car_fv_amt	CAR_FV_AMT,	e.opt_cs_amt	OPT_CS_AMT,	e.opt_cv_amt	OPT_CV_AMT,	e.opt_fs_amt	OPT_FS_AMT,	e.opt_fv_amt	OPT_FV_AMT,	e.clr_cs_amt	CLR_CS_AMT,	e.clr_cv_amt	CLR_CV_AMT,	e.clr_fs_amt	CLR_FS_AMT,	e.clr_fv_amt	CLR_FV_AMT,	e.sd_cs_amt		SD_CS_AMT,	e.sd_cv_amt		SD_CV_AMT,	e.sd_fs_amt		SD_FS_AMT,	e.sd_fv_amt		SD_FV_AMT,	e.dc_cs_amt		DC_CS_AMT,	e.dc_cv_amt		DC_CV_AMT,	e.dc_fs_amt		DC_FS_AMT,	e.dc_fv_amt		DC_FV_AMT, c.mng_id		MNG_ID, c.dlv_dt DLV_DT,	decode(r.car_mng_id, sq.car_mng_id, 1, 0) ACCIDENT_YN, \n"+
			"	    vt.tot_dist TOT_DIST, \n"+
			"		decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD'))))) as AVERAGE_DIST, \n"+
			"		decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST, \n"+
			"       s.lev LEV, s.reason REASON, s.car_st CAR_ST, s.imgfile1 IMGFILE1, s.imgfile2 IMGFILE2, s.imgfile3 IMGFILE3, s.imgfile4 IMGFILE4, s.imgfile5 IMGFILE5, s.damdang_id DAMDANG_ID, s.modify_id MODIFY_ID, s.apprsl_dt APPRSL_DT, DECODE(r.car_mng_id, ch.car_mng_id, 1, 0) CAR_CHA_YN, \n"+
			"		iu.ins_com_nm INS_COM_NM, iu.ins_exp_dt INS_EXP_DT, s.driver DRIVER, \n"+	
			"		r.secondhand, o.actn_dt, to_char(to_date(o.actn_dt,'YYYYMMDD')+7,'YYYYMMDD') actn_est_dt, \n"+
			"		/*보유차*/ nvl(rh.ret_plan_dt,ri.ret_plan_dt) as ret_plan_dt, "+
			" 	               decode(r.off_ls,'3',decode(o.actn_st,'2',to_char(to_date(o.actn_dt,'YYYYMMDD')+7,'YYYYMMDD'),o.actn_dt),decode(nvl(rh.rent_st,ri.rent_st),'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트','대기')) rent_st_nm, \n"+
			"		decode(nvl(r.off_ls,'0'),'3',decode(o.actn_st,'1','경매진행중','2','유찰','3','개별상담','4','낙찰','출품예정'),'') actn_st, \n"+
			"  		TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(replace(r.init_reg_dt,'-',''), 'YYYYMMDD'))) use_mon, \n"+
			"       decode(r.gps,'Y','장착') gps, m.jg_code, iu.con_f_nm, r.park_cont, r.park as park_nm, r.rm_yn, \n"+	
            "       decode(ac.car_mng_id,'','','중고차') car_gu, "+
			"       r.ncar_spe_dc_amt, r.spe_dc_per "+
			"	from \n"+
			"		car_reg r, car_etc e, cont c, apprsl s, CAR_NM m, CAR_MNG n, v_tot_dist vt, (select distinct ac.car_mng_id CAR_MNG_ID from accident ac, car_reg re where ac.car_mng_id=re.car_mng_id) sq, \n"+
			"		(SELECT DISTINCT cc.car_mng_id CAR_MNG_ID FROM car_cha cc, car_reg re WHERE cc.car_mng_id = re.car_mng_id) ch, \n"+
			"		(select ir.car_mng_id CAR_MNG_ID, ic.ins_com_nm INS_COM_NM, ir.ins_exp_dt INS_EXP_DT, ir.con_f_nm from insur ir, ins_com ic where ir.ins_com_id = ic.ins_com_id and ir.ins_st = (select max(ins_st) from insur where car_mng_id = ir.car_mng_id)) iu, \n"+
	        "       (select * from rent_cont a  where (a.car_mng_id, a.rent_s_cd) in (select car_mng_id, max(rent_s_cd) from rent_cont where use_st = '2' and rent_st<>'11' group by car_mng_id)) rh, \n"+
			"		(select * from rent_cont a  where (a.car_mng_id, a.rent_s_cd) in (select car_mng_id, max(rent_s_cd) from rent_cont where use_st = '1' and rent_st<>'11' group by car_mng_id)) ri, \n"+
			"		(select * from auction a where a.seq = (select max(seq) from auction where car_mng_id=a.car_mng_id)) o, \n"+
			"       ( select c_st, code, nm_cd, nm from code where c_st = '0027' and code <> '0000'  ) cd,  \n"+  //주차장 
            //차량해지반납
			"       (select * from car_call_in where in_st='3' and out_dt is null) cc, "+
            "       (select car_mng_id from cont where car_gu='2' group by car_mng_id) ac "+
			"	where r.car_mng_id = c.car_mng_id \n"+
			"		and e.rent_mng_id = c.rent_mng_id \n"+
			"		and e.rent_l_cd = c.rent_l_cd \n"+
			"		and r.car_mng_id = sq.car_mng_id(+) \n"+
			"		and c.use_yn = 'Y' \n"+
			"		and nvl(r.off_ls,'0') not in ('5','6') \n"+
			"		and r.car_mng_id = s.car_mng_id(+) \n"+
			"		and r.car_mng_id = ch.car_mng_id(+) \n"+
			"		and r.car_mng_id = iu.car_mng_id(+) \n"+
			"		AND e.car_id = m.car_id \n"+
			"		and e.car_seq = m.car_seq \n"+
			"		and m.car_comp_id = n.car_comp_id \n"+
			"		and m.car_cd = n.code \n"+
			"		and r.car_mng_id=vt.car_mng_id(+) \n"+
			"		and r.car_mng_id=rh.car_mng_id(+) \n"+
			"		and r.car_mng_id=ri.car_mng_id(+) \n"+
			"		and r.car_mng_id=o.car_mng_id(+) \n"+
			"       and c.rent_mng_id=cc.rent_mng_id(+) and c.rent_l_cd=cc.rent_l_cd(+)"+		
			"       and r.car_mng_id=ac.car_mng_id(+)"+				
			"       and r.park = cd.nm_cd(+) \n"+  //주차장 코드 테이블 				
//			"       and decode(cc.rent_l_cd,'',c.car_st,'')='2'"+
			subQuery;
		}else{
			query = " select '' BANK_NM, '' LEND_PRN, '' ALT_END_DT, '' LEND_REM,  \n"+
				" decode(r.park,'6',substr(r.park_cont,1,5),nvl(cd.nm,r.park)) park_nm, \n"+
			"		decode(r.car_use,'1',r.car_end_dt) car_end_dt, r.car_mng_id CAR_MNG_ID, r.car_no CAR_NO, r.car_num CAR_NUM, r.init_reg_dt	INIT_REG_DT, r.car_kd CAR_KD, r.car_use	CAR_USE, n.car_nm CAR_JNM,m.car_name	CAR_NM,	r.car_form CAR_FORM, r.car_y_form	CAR_Y_FORM,	r.dpm			DPM,	r.fuel_kd		FUEL_KD,	r.maint_st_dt	MAINT_ST_DT,	r.maint_end_dt	MAINT_END_DT, r.test_st_dt TEST_ST_DT, r.test_end_dt TEST_END_DT, r.car_l_cd, CAR_L_CD, \n"+
			"		decode(nvl(r.off_ls,'0'),'0',decode(nvl(r.prepare,'0'), '2','매각예정', '3','보류', '4','말소', '5','도난', '9', '미회수', '6','해지', '7',' 비대상', decode(c.client_id,'000231',' 중앙(영)', decode(r.car_mng_id,'000797','창고',' 예비')) ), '1','매각결정','2','소매','3','경매','4','수의') PREPARE, \n"+
			"		e.rent_mng_id	RENT_MNG_ID,	e.rent_l_cd		RENT_L_CD,	e.car_id		CAR_ID,	e.colo			COLO, e.opt			OPT,	e.car_cs_amt	CAR_CS_AMT,	e.car_cv_amt	CAR_CV_AMT,	e.car_fs_amt	CAR_FS_AMT,	e.car_fv_amt	CAR_FV_AMT,	e.opt_cs_amt	OPT_CS_AMT,	e.opt_cv_amt	OPT_CV_AMT,	e.opt_fs_amt	OPT_FS_AMT,	e.opt_fv_amt	OPT_FV_AMT,	e.clr_cs_amt	CLR_CS_AMT,	e.clr_cv_amt	CLR_CV_AMT,	e.clr_fs_amt	CLR_FS_AMT,	e.clr_fv_amt	CLR_FV_AMT,	e.sd_cs_amt		SD_CS_AMT,	e.sd_cv_amt		SD_CV_AMT,	e.sd_fs_amt		SD_FS_AMT,	e.sd_fv_amt		SD_FV_AMT,	e.dc_cs_amt		DC_CS_AMT,	e.dc_cv_amt		DC_CV_AMT,	e.dc_fs_amt		DC_FS_AMT,	e.dc_fv_amt		DC_FV_AMT, c.mng_id		MNG_ID, c.dlv_dt DLV_DT,	decode(r.car_mng_id, sq.car_mng_id, 1, 0) ACCIDENT_YN, \n"+
			"   	vt.tot_dist TOT_DIST, \n"+
			"		decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD'))))) as AVERAGE_DIST, "+
			"		decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST, \n"+
			"		s.lev LEV, s.reason REASON, s.car_st CAR_ST, s.imgfile1 IMGFILE1, s.imgfile2 IMGFILE2, s.imgfile3 IMGFILE3, s.imgfile4 IMGFILE4, s.imgfile5 IMGFILE5, s.damdang_id DAMDANG_ID, s.modify_id MODIFY_ID, s.apprsl_dt APPRSL_DT, DECODE(r.car_mng_id, ch.car_mng_id, 1, 0) CAR_CHA_YN, \n"+
			"		iu.ins_com_nm INS_COM_NM, iu.ins_exp_dt INS_EXP_DT, s.driver DRIVER, \n"+	
			"		r.secondhand, o.actn_dt,  to_char(to_date(o.actn_dt,'YYYYMMDD')+7,'YYYYMMDD') actn_est_dt,\n"+
			"		/*보유차*/ nvl(rh.ret_plan_dt,ri.ret_plan_dt) as ret_plan_dt, decode(r.off_ls,'3',decode(o.actn_st,'2',to_char(to_date(o.actn_dt,'YYYYMMDD')+7,'YYYYMMDD'),o.actn_dt),decode(nvl(rh.rent_st,ri.rent_st),'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트','대기')) rent_st_nm,\n"+
			"		decode(nvl(r.off_ls,'0'),'3',decode(o.actn_st,'1','경매진행중','2','유찰','3','개별상담','4','낙찰','출품예정'),'') actn_st, \n"+
			"  		TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(replace(r.init_reg_dt,'-',''), 'YYYYMMDD'))) use_mon,\n"+
			"       decode(r.gps,'Y','장착') gps, m.jg_code, iu.con_f_nm, r.park_cont, r.park as park_nm, r.rm_yn, \n"+	
            "       decode(ac.car_mng_id,'','','중고차') car_gu, "+
            "       r.ncar_spe_dc_amt, r.spe_dc_per "+
			"	from \n"+
			"		car_reg r, car_etc e, cont c, apprsl s, CAR_NM m, CAR_MNG n, v_tot_dist vt, (select distinct ac.car_mng_id CAR_MNG_ID from accident ac, car_reg re where ac.car_mng_id=re.car_mng_id) sq, \n"+
			"		(SELECT DISTINCT cc.car_mng_id CAR_MNG_ID FROM car_cha cc, car_reg re WHERE cc.car_mng_id = re.car_mng_id) ch, \n"+
			"		(select ir.car_mng_id CAR_MNG_ID, ic.ins_com_nm INS_COM_NM, ir.ins_exp_dt INS_EXP_DT, ir.con_f_nm from insur ir, ins_com ic where ir.ins_com_id = ic.ins_com_id and ir.ins_st = (select max(ins_st) from insur where car_mng_id = ir.car_mng_id)) iu, \n"+
	        "       (select * from rent_cont a  where (a.car_mng_id, a.rent_s_cd) in (select car_mng_id, max(rent_s_cd) from rent_cont where use_st = '2' and rent_st<>'11' group by car_mng_id)) rh, \n"+
			"		(select * from rent_cont a  where (a.car_mng_id, a.rent_s_cd) in (select car_mng_id, max(rent_s_cd) from rent_cont where use_st = '1' and rent_st<>'11' group by car_mng_id)) ri, \n"+
			"		(select * from auction a where a.seq = (select max(seq) from auction where car_mng_id=a.car_mng_id)) o, \n"+
			"       (select c_st, code, nm_cd, nm from code where c_st = '0027' and code <> '0000') cd,  \n"+  //주차장 
            //차량해지반납
			"       (select * from car_call_in where in_st='3' and out_dt is null) cc, "+
            "       (select car_mng_id from cont where car_gu='2' group by car_mng_id) ac "+
			"	where r.car_mng_id = c.car_mng_id \n"+
			"		and e.rent_mng_id = c.rent_mng_id \n"+
			"		and e.rent_l_cd = c.rent_l_cd \n"+
			"		and r.car_mng_id = sq.car_mng_id(+) \n"+
			"		and c.use_yn = 'Y' \n"+
			"		and nvl(r.off_ls,'0') not in ('5','6') \n"+
			"		and r.car_mng_id = s.car_mng_id(+) \n"+
			"		and r.car_mng_id = ch.car_mng_id(+) \n"+
			"		and r.car_mng_id = iu.car_mng_id(+) \n"+
			"		AND e.car_id = m.car_id \n"+
			"		and e.car_seq = m.car_seq \n"+
			"		and m.car_comp_id = n.car_comp_id \n"+
			"		and m.car_cd = n.code \n"+
			"		and r.car_mng_id=vt.car_mng_id(+)\n"+
			"		and r.car_mng_id=rh.car_mng_id(+)\n"+
			"		and r.car_mng_id=ri.car_mng_id(+)\n"+
			"		and r.car_mng_id=o.car_mng_id(+)\n"+
			"       and c.rent_mng_id=cc.rent_mng_id(+) and c.rent_l_cd=cc.rent_l_cd(+)"+		
			"       and r.car_mng_id=ac.car_mng_id(+)"+				
			"       and r.park = cd.nm_cd(+) \n"+  //주차장 코드 테이블 			
//			"       and decode(cc.rent_l_cd,'',c.car_st,'')='2'"+
			subQuery;
		}
		
		
		Collection<Offls_ybBean> col = new ArrayList<Offls_ybBean>();

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while(rs.next()){
				col.add(makeOffls_ybBean(rs));
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_ybDatabase:getYb_lst(String gubun, String gubun_nm)]"+e);
			System.out.println("[Offls_ybDatabase:getYb_lst(String gubun, String gubun_nm)]"+query);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return (Offls_ybBean[])col.toArray(new Offls_ybBean[0]);
		}		
	}
	/**
	*	상품평가 데이터 존재 여부 - 2003.04.18.Fri.
	*	- 등록,수정버튼 구분하기위해
	*/
	public String getApprsl_Car_mng_id(String car_mng_id){

		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String apprsl_car_mng_id = "";
		String query = "SELECT car_mng_id FROM apprsl WHERE car_mng_id=?";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				apprsl_car_mng_id = rs.getString(1);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_ybDatabase:inApprsl(String car_mng_id, String lev, String reason, String car_st, String damdang_id,String modify_id, String apprsl_dt)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return apprsl_car_mng_id;
		}
	}

	/**
	*	상품평가 데이터 입력 - 2003.2.4.Tue.
	*	- 2003.9.24.Wed. ; driver 칼럼 추가
	*/
	public int inApprsl(String car_mng_id, String lev, String reason, String car_st, String damdang_id, String modify_id, String apprsl_dt, String driver){

		getConnection();
		PreparedStatement pstmt = null;
		String query = "INSERT INTO apprsl(car_mng_id, lev, reason, car_st, damdang_id, modify_id, apprsl_dt, driver) values(?,?,?,?,?,?,?,?)";
		int result = 0;
		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
			pstmt.setString(2,lev);
			pstmt.setString(3,reason);
			pstmt.setString(4,car_st);
			pstmt.setString(5,damdang_id);
			pstmt.setString(6,modify_id);
			pstmt.setString(7,apprsl_dt);
			pstmt.setString(8,driver);
			result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		}catch(SQLException e){
			System.out.println("[Offls_ybDatabase:inApprsl(String car_mng_id, String lev, String reason, String car_st, String damdang_id,String modify_id, String apprsl_dt, String driver)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return result;
		}
	}

	/**
	*	상품평가 데이터 수정 - 2003.2.4.Tue.
	*	- 2003.9.24.Wed. ; driver 칼럼 추가
	*/
	public int upApprsl(String car_mng_id, String lev, String reason, String car_st, String damdang_id, String modify_id, String apprsl_dt, String driver){

		getConnection();
		String query = "UPDATE apprsl SET lev=?,reason=?,car_st=?,damdang_id=?,modify_id=?,apprsl_dt=?,driver=? WHERE car_mng_id=?";
		int result = 0;
		PreparedStatement pstmt = null;
		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,lev);
			pstmt.setString(2,reason);
			pstmt.setString(3,car_st);
			pstmt.setString(4,damdang_id);
			pstmt.setString(5,modify_id);
			pstmt.setString(6,apprsl_dt);
			pstmt.setString(7,driver);
			pstmt.setString(8,car_mng_id);
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
		}catch(SQLException e){
			System.out.println("[Offls_ybDatabase:upApprsl(String car_mng_id, String lev, String reason, String car_st, String damdang_id, String modify_id, String apprsl_dt, String driver)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return result;
		}
	}
	
	/**
	*	차량이력표 - 2003.2.5.Wed.
	*
	*/
	public Vector getCarHisList(String car_mng_id){

		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "SELECT i.client_nm CLIENT_NM,  nvl(i.firm_nm, i.client_nm) FIRM_NM, decode(i.client_nm,'조성희',to_char(to_date(z.cls_dt)+1,'YYYYMMDD'), c.rent_start_dt) RENT_ST_DT,	nvl(t.cls_dt, '') RENT_ED_DT, t.cls_st CLS_ST "+
						"FROM cont c, cls_cont t, client i, (select cont.rent_mng_id RENT_MNG_ID, cont.rent_l_cd RENT_L_CD,cls_cont.cls_dt CLS_DT from cont, cls_cont where cont.RENT_MNG_ID=cls_cont.RENT_MNG_ID and cont.rent_l_cd=cls_cont.rent_l_cd and cont.car_mng_id=?) z "+
						"WHERE c.rent_mng_id = t.rent_mng_id(+) and c.rent_l_cd = t.rent_l_cd(+) and c.rent_mng_id = z.rent_mng_id(+) and c.rent_l_cd = z.rent_l_cd(+) and c.client_id = i.client_id and c.car_mng_id = ? "+
						"ORDER BY 4 ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
			pstmt.setString(2,car_mng_id);
			rs = pstmt.executeQuery();
			while(rs.next()){

				CarHisBean bean = new CarHisBean();

				bean.setClient_nm(rs.getString("CLIENT_NM"));	//상호명
				bean.setFirm_nm(rs.getString("FIRM_NM"));		//대표자명
				bean.setRent_st_dt(rs.getString("RENT_ST_DT"));	//대여시작일
				bean.setRent_ed_dt(rs.getString("RENT_ED_DT"));	//중도해지일 또는 대여만기일
				bean.setCls_st(rs.getString("CLS_ST"));			//해지구분
				
			    vt.add(bean);
            }
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_ybDatabase:getCarHisList(String car_mng_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return vt;
		}
	}

	/**
	*	차량이력표 - 2003.2.5.Wed.
	*/
	public Vector getCarHis3MList(String car_mng_id){

		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String query = " SELECT i.client_nm CLIENT_NM,  nvl(i.firm_nm, i.client_nm) FIRM_NM, decode(i.client_nm,'조성희',to_char(to_date(z.cls_dt)+1,'YYYYMMDD'), c.rent_start_dt) RENT_ST_DT,	nvl(t.cls_dt, '') RENT_ED_DT, t.cls_st CLS_ST "+
						" FROM cont c, cls_cont t, client i, (select cont.rent_mng_id RENT_MNG_ID, cont.rent_l_cd RENT_L_CD,cls_cont.cls_dt CLS_DT from cont, cls_cont where cont.RENT_MNG_ID=cls_cont.RENT_MNG_ID and cont.rent_l_cd=cls_cont.rent_l_cd and cont.car_mng_id=?) z "+
						" WHERE c.car_st<>'2' and c.rent_mng_id = t.rent_mng_id(+) and c.rent_l_cd = t.rent_l_cd(+) and c.rent_mng_id = z.rent_mng_id(+) and c.rent_l_cd = z.rent_l_cd(+) and c.client_id = i.client_id and c.car_mng_id = ? "+
			            "       and trunc(months_between(to_date(t.cls_dt,'YYYYMMDD'),to_date(c.rent_start_dt,'YYYYMMDD')+1),0) > 3"+
						" ORDER BY 4 desc";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
			pstmt.setString(2,car_mng_id);
			rs = pstmt.executeQuery();
			while(rs.next()){

				CarHisBean bean = new CarHisBean();

				bean.setClient_nm(rs.getString("CLIENT_NM"));	//상호명
				bean.setFirm_nm(rs.getString("FIRM_NM"));		//대표자명
				bean.setRent_st_dt(rs.getString("RENT_ST_DT"));	//대여시작일
				bean.setRent_ed_dt(rs.getString("RENT_ED_DT"));	//중도해지일 또는 대여만기일
				bean.setCls_st(rs.getString("CLS_ST"));			//해지구분
				
			    vt.add(bean);
            }
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_ybDatabase:getCarHis3MList(String car_mng_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return vt;
		}
	}

	/**
     *	사고기록 전체조회 2003.2.6.Thu.
	 *	- From acar.car_accident.CarAccidDatabase{}
     */
    public AccidentBean [] getAccidentAll(String car_mng_id) throws DatabaseException, DataSourceEmptyException{
        
		getConnection();
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        String subQuery = "";
        
        query = "select a.car_mng_id CAR_MNG_ID, a.accid_id ACCID_ID, a.rent_mng_id RENT_MNG_ID, a.rent_l_cd RENT_L_CD, a.accid_st ACCID_ST, a.our_car_nm OUR_CAR_NM, a.our_driver OUR_DRIVER, a.our_tel OUR_TEL, a.our_m_tel OUR_M_TEL, a.our_ssn OUR_SSN, a.our_lic_kd OUR_LIC_KD, a.our_lic_no OUR_LIC_NO, a.our_ins OUR_INS, a.our_num OUR_NUM, a.our_post OUR_POST, a.our_addr OUR_ADDR, nvl2(a.accid_dt,substr(a.accid_dt,1,4)||'-'||substr(a.accid_dt,5,2)||'-'||substr(a.accid_dt,7,2)||' '||substr(a.accid_dt,9,2)||':'||substr(a.accid_dt,11,2),'') as ACCID_DT, a.accid_city ACCID_CITY, a.accid_gu ACCID_GU, a.accid_dong ACCID_DONG, a.accid_point ACCID_POINT, a.accid_cont ACCID_CONT, a.ot_car_no OT_CAR_NO, a.ot_car_nm OT_CAR_NM, a.ot_driver OT_DRIVER, a.ot_tel OT_TEL, a.ot_m_tel OT_M_TEL, a.ot_ins OT_INS, a.ot_num OT_NUM, a.ot_ins_nm OT_INS_NM, a.ot_ins_tel OT_INS_TEL, a.ot_ins_m_tel OT_INS_M_TEL, a.ot_pol_sta OT_POL_STA, a.ot_pol_nm OT_POL_NM, a.ot_pol_tel OT_POL_TEL, a.ot_pol_m_tel OT_POL_M_TEL, a.hum_amt HUM_AMT, a.hum_nm HUM_NM, a.hum_tel HUM_TEL, a.mat_amt MAT_AMT, a.mat_nm MAT_NM, a.mat_tel MAT_TEL, a.one_amt ONE_AMT, a.one_nm ONE_NM, a.one_tel ONE_TEL, a.my_amt MY_AMT, a.my_nm MY_NM, a.my_tel MY_TEL, a.ref_dt REF_DT, a.ex_tot_amt EX_TOT_AMT, a.tot_amt TOT_AMT, a.rec_amt REC_AMT, a.rec_dt REC_DT, a.rec_plan_dt REC_PLAN_DT, a.sup_amt SUP_AMT, a.sup_dt SUP_DT, a.ins_sup_amt INS_SUP_AMT, a.ins_sup_dt INS_SUP_DT, a.ins_tot_amt INS_TOT_AMT,\n" 
				+ "c.car_no CAR_NO, d.client_nm CLIENT_NM, d.firm_nm FIRM_NM, e.off_id OFF_ID, f.off_nm OFF_NM\n"
				+ "from accident a, cont b, car_reg c, client d, cust_serv e, serv_off f\n"
				+ "where a.car_mng_id=c.car_mng_id\n"
				+ "and a.rent_mng_id=b.rent_mng_id\n"
				+ "and a.rent_l_cd=b.rent_l_cd\n"
				+ "and a.car_mng_id = ? "
				+ "and b.client_id=d.client_id and a.car_mng_id=e.car_mng_id(+) and e.off_id=f.off_id(+)\n";
		
        Collection<AccidentBean> col = new ArrayList<AccidentBean>();
        try{
            pstmt = conn.prepareStatement(query);
    		pstmt.setString(1, car_mng_id.trim());
    		
    		rs = pstmt.executeQuery();

            while(rs.next()){
                
				col.add(makeAccidentBean(rs));
 
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            closeConnection();
        }
        return (AccidentBean[])col.toArray(new AccidentBean[0]);
    }

	/**
    *	사고기록 Bean에 넣기 2003.2.6.Thu.
    */    
    private AccidentBean makeAccidentBean(ResultSet results) throws DatabaseException {

        try {
            AccidentBean bean = new AccidentBean();

		    bean.setCar_mng_id(results.getString("CAR_MNG_ID")); 					//자동차관리번호
			bean.setAccid_id(results.getString("ACCID_ID"));
			bean.setRent_mng_id(results.getString("RENT_MNG_ID"));
			bean.setRent_l_cd(results.getString("RENT_L_CD"));
			bean.setCar_no(results.getString("CAR_NO"));
			bean.setFirm_nm(results.getString("FIRM_NM"));
			bean.setClient_nm(results.getString("CLIENT_NM"));
			bean.setAccid_st(results.getString("ACCID_ST"));
			bean.setOur_car_nm(results.getString("OUR_CAR_NM"));
			bean.setOur_driver(results.getString("OUR_DRIVER"));
			bean.setOur_tel(results.getString("OUR_TEL"));
			bean.setOur_m_tel(results.getString("OUR_M_TEL"));
			bean.setOur_ssn(results.getString("OUR_SSN"));
			bean.setOur_lic_kd(results.getString("OUR_LIC_KD"));
			bean.setOur_lic_no(results.getString("OUR_LIC_NO"));
			bean.setOur_ins(results.getString("OUR_INS"));
			bean.setOur_num(results.getString("OUR_NUM"));
			bean.setOur_post(results.getString("OUR_POST"));
			bean.setOur_addr(results.getString("OUR_ADDR"));
			bean.setAccid_dt(results.getString("ACCID_DT"));
			bean.setAccid_city(results.getString("ACCID_CITY"));
			bean.setAccid_gu(results.getString("ACCID_GU"));
			bean.setAccid_dong(results.getString("ACCID_DONG"));
			bean.setAccid_point(results.getString("ACCID_POINT"));
			bean.setAccid_cont(results.getString("ACCID_CONT"));
			bean.setOt_car_no(results.getString("OT_CAR_NO"));
			bean.setOt_car_nm(results.getString("OT_CAR_NM"));
			bean.setOt_driver(results.getString("OT_DRIVER"));
			bean.setOt_tel(results.getString("OT_TEL"));
			bean.setOt_m_tel(results.getString("OT_M_TEL"));
			bean.setOt_ins(results.getString("OT_INS"));
			bean.setOt_num(results.getString("OT_NUM"));
			bean.setOt_ins_nm(results.getString("OT_INS_NM"));
			bean.setOt_ins_tel(results.getString("OT_INS_TEL"));
			bean.setOt_ins_m_tel(results.getString("OT_INS_M_TEL"));
			bean.setOt_pol_sta(results.getString("OT_POL_STA"));
			bean.setOt_pol_nm(results.getString("OT_POL_NM"));
			bean.setOt_pol_tel(results.getString("OT_POL_TEL"));
			bean.setOt_pol_m_tel(results.getString("OT_POL_M_TEL"));
			bean.setHum_amt(results.getInt("HUM_AMT"));
			bean.setHum_nm(results.getString("HUM_NM"));
			bean.setHum_tel(results.getString("HUM_TEL"));
			bean.setMat_amt(results.getInt("MAT_AMT"));
			bean.setMat_nm(results.getString("MAT_NM"));
			bean.setMat_tel(results.getString("MAT_TEL"));
			bean.setOne_amt(results.getInt("ONE_AMT"));
			bean.setOne_nm(results.getString("ONE_NM"));
			bean.setOne_tel(results.getString("ONE_TEL"));
			bean.setMy_amt(results.getInt("MY_AMT"));
			bean.setMy_nm(results.getString("MY_NM"));
			bean.setMy_tel(results.getString("MY_TEL"));
			bean.setRef_dt(results.getString("REF_DT"));
			bean.setEx_tot_amt(results.getInt("EX_TOT_AMT"));
			bean.setTot_amt(results.getInt("TOT_AMT"));
			bean.setRec_amt(results.getInt("REC_AMT"));
			bean.setRec_dt(results.getString("REC_DT"));
			bean.setRec_plan_dt(results.getString("REC_PLAN_DT"));
			bean.setSup_amt(results.getInt("SUP_AMT"));
			bean.setSup_dt(results.getString("SUP_DT"));
			bean.setIns_sup_amt(results.getInt("INS_SUP_AMT"));
			bean.setIns_sup_dt(results.getString("INS_SUP_DT"));
			bean.setIns_tot_amt(results.getInt("INS_TOT_AMT"));
			bean.setOff_id(results.getString("OFF_ID"));
			bean.setOff_nm(results.getString("OFF_NM"));
			
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}

	/**
	*	상품평가 이미지 넣기 - 2003.2.6.Thu.
	*	- 
	*/
	public int upApprsl_img(String car_mng_id, String filename, String imgfile1, String imgfile2, String imgfile3, String imgfile4, String imgfile5){

		getConnection();
		int result = 0;
		PreparedStatement pstmt = null;
		String query = "";
		if(imgfile1.equals("")){
			query = "update apprsl set imgfile1=? where car_mng_id = ? ";
		}else if(imgfile2.equals("")){
			query = "update apprsl set imgfile2=? where car_mng_id = ? ";
		}else if(imgfile3.equals("")){
			query = "update apprsl set imgfile3=? where car_mng_id = ? ";
		}else if(imgfile4.equals("")){
			query = "update apprsl set imgfile4=? where car_mng_id = ? ";
		}else if(imgfile5.equals("")){
			query = "update apprsl set imgfile5=? where car_mng_id = ? ";
		}else{
			return result;
		}

		try{
			conn.setAutoCommit(false);
		
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,filename);
			pstmt.setString(2,car_mng_id);
			result = pstmt.executeUpdate();
			pstmt.close();
			if(result != 1){
				result = this.inApprsl_img(car_mng_id, filename, imgfile1, imgfile2, imgfile3, imgfile4, imgfile5);
			}
			conn.commit();
		
		}catch(SQLException e){
            try{
				System.out.println("[Offls_ybDatabase:upApprsl(String car_mng_id, String lev, String reason, String car_st)]"+e);
                conn.rollback();
            }catch(SQLException _ignored){}
			e.printStackTrace();
			
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			closeConnection();
		}
		return result;
	}

	/**
	*	상품평가 차량이미지 삭제 - 2003.2.7.Fri.
	*	- 
	*/
	public int upApprsl_img(String car_mng_id, String imgnum){

		getConnection();
		int result = 0;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		String query = "";
		String imgQuery = "";

		if(imgnum.equals("0")){
			query = "update apprsl set imgfile1='' where car_mng_id = ? ";
			imgQuery = "SELECT imgfile1 FROM apprsl where car_mng_id = ? ";
		}else if(imgnum.equals("1")){
			query = "update apprsl set imgfile2='' where car_mng_id = ? ";
			imgQuery = "SELECT imgfile2 FROM apprsl where car_mng_id = ? ";
		}else if(imgnum.equals("2")){
			query = "update apprsl set imgfile3='' where car_mng_id = ? ";
			imgQuery = "SELECT imgfile3 FROM apprsl where car_mng_id = ? ";
		}else if(imgnum.equals("3")){
			query = "update apprsl set imgfile4='' where car_mng_id = ? ";
			imgQuery = "SELECT imgfile4 FROM apprsl where car_mng_id = ? ";
		}else if(imgnum.equals("4")){
			query = "update apprsl set imgfile5='' where car_mng_id = ? ";
			imgQuery = "SELECT imgfile5 FROM apprsl where car_mng_id = ? ";
		}else{
			return result;
		}

		try{
			conn.setAutoCommit(false);
				
			pstmt = conn.prepareStatement(imgQuery);
			pstmt.setString(1,car_mng_id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				String str = rs.getString(1);
				File drop_file = new File("C:\\Inetpub\\wwwroot\\images\\carImg\\"+str+".gif");
				drop_file.delete();
			}
			rs.close();
			pstmt.close();

			pstmt2 = conn.prepareStatement(query);
			pstmt2.setString(1,car_mng_id);
			result = pstmt2.executeUpdate();
			pstmt2.close();
			conn.commit();
			
		}catch(SQLException e){
            try{
				System.out.println("[Offls_ybDatabase:upApprsl(String car_mng_id, String lev, String reason, String car_st)]"+e);
                conn.rollback();
            }catch(SQLException _ignored){}
			e.printStackTrace();
	
		}finally{
			try{
				conn.setAutoCommit(true);
				if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
                if(pstmt2 != null) pstmt2.close();
            }catch(SQLException _ignored){}
			closeConnection();
		}
		return result;
	}

	/**
	*	상품평가 차량이미지 입력 - 2003.2.7.Fri.
	*	- 
	*/
	public int inApprsl_img(String car_mng_id, String filename, String imgfile1, String imgfile2, String imgfile3, String imgfile4, String imgfile5){

		getConnection();
		int result = 0;
		PreparedStatement pstmt = null;
		String query = "";
		if(imgfile1.equals("")){
			query = "insert into apprsl (car_mng_id, imgfile1) values(?,?)";
		}else if(imgfile2.equals("")){
			query = "insert into apprsl (car_mng_id, imgfile2) values(?,?)";
		}else if(imgfile3.equals("")){
			query = "insert into apprsl (car_mng_id, imgfile3) values(?,?)";
		}else if(imgfile4.equals("")){
			query = "insert into apprsl (car_mng_id, imgfile4) values(?,?)";
		}else if(imgfile5.equals("")){
			query = "insert into apprsl (car_mng_id, imgfile5) values(?,?)";
		}else{
			return result;
		}

		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
			pstmt.setString(2,filename);
			result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		}catch(SQLException e){
            try{
				System.out.println("[Offls_ybDatabase:upApprsl(String car_mng_id, String lev, String reason, String car_st)]"+e);
                conn.rollback();
            }catch(SQLException _ignored){}
			e.printStackTrace();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			closeConnection();
		}
		return result;
	}

	/**
	*	재리스 차량이미지 입력 - 2006.5.22. 월.
	*	- 
	*/
	public int inApprsl_img(String car_mng_id, String filename, String imgfile1, String imgfile2, String imgfile3, String imgfile4, String imgfile5, String imgfile6){

		getConnection();
		int result = 0;
		PreparedStatement pstmt = null;
		String query = "";
		if(imgfile1.equals("")){
			query = "insert into apprsl (car_mng_id, imgfile1) values(?,?)";
		}else if(imgfile2.equals("")){
			query = "insert into apprsl (car_mng_id, imgfile2) values(?,?)";
		}else if(imgfile3.equals("")){
			query = "insert into apprsl (car_mng_id, imgfile3) values(?,?)";
		}else if(imgfile4.equals("")){
			query = "insert into apprsl (car_mng_id, imgfile4) values(?,?)";
		}else if(imgfile5.equals("")){
			query = "insert into apprsl (car_mng_id, imgfile5) values(?,?)";
		}else if(imgfile6.equals("")){
			query = "insert into apprsl (car_mng_id, imgfile6) values(?,?)";
		}else{
			return result;
		}

		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
			pstmt.setString(2,filename);
			result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		}catch(SQLException e){
            try{
				System.out.println("[Offls_ybDatabase:upApprsl(String car_mng_id, String lev, String reason, String car_st)]"+e);
                conn.rollback();
            }catch(SQLException _ignored){}
			e.printStackTrace();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			closeConnection();
		}
		return result;
	}

	/**
	*	차량상태 조회 - 2006.02.23.
	*/
	public String getCarState(String car_mng_id){

		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String state = "";
		String query = "SELECT decode(c.client_id,'000231','중앙(영)',decode(prepare, '2','매각', '3','보관', '4','말소', '5','도난', '-')) prepare "+
						" FROM car_reg a, cont b, client c "+
						" WHERE a.car_mng_id=b.car_mng_id "+
						" and b.client_id = c.client_id "+
						" and a.car_mng_id=? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				state = rs.getString(1);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_ybDatabase:getCarState(String car_mng_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return state;
		}
	}

 	/**
	*	예비차량에서 매각준비차량으로 2003.2.12.Wed.
	*/
	public int setPrepare(String[] pre){
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = "UPDATE car_reg SET prepare = '7', secondhand = '' WHERE car_mng_id in ('";		// secondhand = '' 추가 20140320 재리스 비대상인데 prepare 값만 바꿔서 추가함.
		
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
			if(result >=1 ){
				//result = this.createRowOffls_pre(pre);
			}
			conn.commit();
		
		}catch(SQLException e){
            try{
					System.out.println("[Offls_ybDatabase:setPrepare(String[] pre)]"+e);
                conn.rollback();
            }catch(SQLException _ignored){}
			e.printStackTrace();
	
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			closeConnection();
		}
		return result;
	}

 	/**
	*	재리스비대상차량에서 예비차량으로 2003.2.12.Wed.
	*/
	public int setPrepareC(String[] pre){
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = "UPDATE car_reg SET prepare = '1' WHERE car_mng_id in ('";		
		
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
			if(result >=1 ){
				//result = this.createRowOffls_pre(pre);
			}
			conn.commit();
		
		}catch(SQLException e){
            try{
				System.out.println("[Offls_ybDatabase:setPrepareC(String[] pre)]"+e);
                conn.rollback();
            }catch(SQLException _ignored){}
			e.printStackTrace();
	
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			closeConnection();
		}
		return result;
	}


	/**
	*	예비차량 상세정보 
	*/
	public Offls_ybBean getYb_detail_20090907(String car_mng_id){
		getConnection();
		Offls_ybBean bean = new Offls_ybBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " select r.car_end_dt, r.car_mng_id CAR_MNG_ID, r.car_no CAR_NO, r.car_num CAR_NUM, r.init_reg_dt	INIT_REG_DT, "+
				"        r.car_kd CAR_KD, r.car_use	CAR_USE, n.car_nm CAR_JNM, m.car_name	CAR_NM,	r.car_form CAR_FORM, r.car_y_form	CAR_Y_FORM,	"+
				"        r.dpm			DPM,	r.fuel_kd		FUEL_KD,	r.maint_st_dt	MAINT_ST_DT,	r.maint_end_dt	MAINT_END_DT, "+
				"        r.test_st_dt TEST_ST_DT, r.test_end_dt TEST_END_DT, r.car_l_cd CAR_L_CD, "+
				"        decode(nvl(r.prepare,'0'), '2','매각', '3','보관', '4','말소', '5','도난', decode(c.client_id,'000231','중앙(영)') ) PREPARE, "+
				"        e.rent_mng_id	RENT_MNG_ID,	e.rent_l_cd		RENT_L_CD,	e.car_id		CAR_ID,	e.colo			COLO,	e.opt			OPT,	"+
				"        e.car_cs_amt	CAR_CS_AMT,	e.car_cv_amt	CAR_CV_AMT,	e.car_fs_amt	CAR_FS_AMT,	e.car_fv_amt	CAR_FV_AMT,	"+
				"        e.opt_cs_amt	OPT_CS_AMT,	e.opt_cv_amt	OPT_CV_AMT,	e.opt_fs_amt	OPT_FS_AMT,	e.opt_fv_amt	OPT_FV_AMT,	"+
				"        e.clr_cs_amt	CLR_CS_AMT,	e.clr_cv_amt	CLR_CV_AMT,	e.clr_fs_amt	CLR_FS_AMT,	e.clr_fv_amt	CLR_FV_AMT,	"+
				"        e.sd_cs_amt		SD_CS_AMT,	e.sd_cv_amt		SD_CV_AMT,	e.sd_fs_amt		SD_FS_AMT,	e.sd_fv_amt		SD_FV_AMT,	"+
				"        e.dc_cs_amt		DC_CS_AMT,	e.dc_cv_amt		DC_CV_AMT,	e.dc_fs_amt		DC_FS_AMT,	e.dc_fv_amt		DC_FV_AMT, "+
				"        c.mng_id		MNG_ID,	c.dlv_dt DLV_DT, "+
				"        decode(nvl(sq.accid_cnt,0), 0,0,1) ACCIDENT_YN, \n"+
				"        vt.tot_dist TOT_DIST, "+
				"        decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD'))))) as AVERAGE_DIST, "+
				"        decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST, "+
				"        bk.bank_nm BANK_NM, bk.lend_prn LEND_PRN, sw.alt_rest	LEND_REM, sc.alt_est_dt ALT_END_DT, "+
				"        s.lev LEV, s.reason REASON, s.car_st CAR_ST,s.imgfile1 IMGFILE1, s.imgfile2 IMGFILE2, s.imgfile3 IMGFILE3, s.imgfile4 IMGFILE4, s.imgfile5 IMGFILE5, "+
				"        s.damdang_id DAMDANG_ID, s.modify_id MODIFY_ID, s.apprsl_dt APPRSL_DT, "+
				"        decode(nvl(ch.cha_cnt,0), 0,0,1) CAR_CHA_YN, \n"+
				"        iu.ins_com_nm INS_COM_NM, iu.ins_exp_dt INS_EXP_DT, s.driver DRIVER, "+
				"        '' rent_st_nm, '' ret_plan_dt, r.secondhand, "+
				"        TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(replace(r.init_reg_dt,'-',''), 'YYYYMMDD'))) use_mon, decode(r.gps,'Y','장착') gps, m.jg_code, "+
				"        iu.con_f_nm, r.park_cont, r.park as park_nm, r.rm_yn, c.car_gu, r.ncar_spe_dc_amt, r.spe_dc_per "+
				" from   car_reg r, cont c, car_etc e, apprsl s, car_nm m, CAR_MNG n, v_tot_dist vt, "+
				"	     (select car_mng_id, count(*) accid_cnt from accident group by car_mng_id) sq, \n"+
				"	     (select car_mng_id, serv_dt, tot_dist from service where tot_dist is not null and (car_mng_id,serv_dt||serv_id) in (select car_mng_id, max(serv_dt||serv_id) from service where tot_dist is not null group by car_mng_id)) i, \n"+
				"	     (select al.rent_mng_id RENT_MNG_ID, al.rent_l_cd RENT_L_CD, cd.nm BANK_NM , al.lend_prn LEND_PRN, al.alt_end_dt ALT_END_DT from allot al, code cd where al.cpt_cd = cd.code and cd.c_st = '0003') bk, \n"+
				"	     (SELECT car_mng_id, count(*) cha_cnt FROM car_cha group by car_mng_id) ch, \n"+
				"	     (SELECT car_mng_id CAR_MNG_ID, alt_rest ALT_REST FROM scd_alt_case WHERE (car_mng_id,pay_dt) in (select car_mng_id, max(pay_dt) from scd_alt_case group by car_mng_id)) sw, \n"+
				"        (SELECT car_mng_id CAR_MNG_ID, alt_est_dt ALT_EST_DT FROM scd_alt_case WHERE (car_mng_id,alt_est_dt) in (select car_mng_id, max(alt_est_dt) from scd_alt_case group by car_mng_id)) sc, \n"+
				"        (select ir.car_mng_id CAR_MNG_ID, ic.ins_com_nm INS_COM_NM, ir.ins_exp_dt INS_EXP_DT, ir.con_f_nm from insur ir, ins_com ic where ir.ins_com_id = ic.ins_com_id and (ir.car_mng_id,ir.ins_st) in (select car_mng_id, max(ins_st) from insur group by car_mng_id)) iu, \n"+
				"        (select * from secondhand where (car_mng_id,seq) in (select car_mng_id, max(seq) from secondhand group by car_mng_id)) sh \n"+	
				" where  r.car_mng_id = '"+car_mng_id+"'"+
				"        and r.car_mng_id = c.car_mng_id "+
				"        and c.car_st = '2' "+
				"        and c.use_yn = 'Y' "+
				"        and c.rent_mng_id = e.rent_mng_id and c.rent_l_cd = e.rent_l_cd "+
				"        and r.car_mng_id = s.car_mng_id(+) "+
				"        and e.car_id = m.car_id and e.car_seq = m.car_seq "+
				"        and m.car_comp_id = n.car_comp_id and m.car_cd = n.code "+
				"        and r.car_mng_id = vt.car_mng_id(+)  \n"+
				"        and r.car_mng_id = sq.car_mng_id(+) "+
				"        and r.car_mng_id = i.car_mng_id(+) "+
				"        and c.rent_mng_id = bk.rent_mng_id and c.rent_l_cd = bk.rent_l_cd "+
				"        and r.car_mng_id = ch.car_mng_id(+) "+
				"        and r.car_mng_id = sw.car_mng_id(+) "+
				"        and r.car_mng_id = sc.car_mng_id(+) "+
				"        and r.car_mng_id = iu.car_mng_id "+
				"        and r.car_mng_id = sh.car_mng_id(+)  \n"+
				" ";

		try{

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			if(rs.next()){
				bean = makeOffls_ybBean(rs);
			}
			rs.close();
			pstmt.close();

		}catch(SQLException e){
			System.out.println("[Offls_ybDatabase:getYb_detail_20090907(String car_mng_id)]"+e);
			System.out.println("[Offls_ybDatabase:getYb_detail_20090907(String car_mng_id)]"+query);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return bean;
		}		
	}


	/**
	*	월렌트 비대상 설정 2013.01.04
	*/
	public int setMonPrepare(String[] pre){
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = "UPDATE car_reg SET rm_yn = 'N' WHERE car_mng_id in ('";		
		
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
			if(result >=1 ){
				//result = this.createRowOffls_pre(pre);
			}
			conn.commit();
		
		}catch(SQLException e){
            try{
					System.out.println("[Offls_ybDatabase:setMonPrepare(String[] pre)]"+e);
                conn.rollback();
            }catch(SQLException _ignored){}
			e.printStackTrace();
	
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			closeConnection();
		}
		return result;
	}


/**
	*	월렌트 비대상 설정 2013.01.04
	*/
	public int setMonPrepareC(String[] pre){
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = "UPDATE car_reg SET rm_yn = '' WHERE car_mng_id in ('";		
		
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
			if(result >=1 ){
				//result = this.createRowOffls_pre(pre);
			}
			conn.commit();
		
		}catch(SQLException e){
            try{
					System.out.println("[Offls_ybDatabase:setMonPrepareC(String[] pre)]"+e);
                conn.rollback();
            }catch(SQLException _ignored){}
			e.printStackTrace();
	
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			closeConnection();
		}
		return result;
	}

}