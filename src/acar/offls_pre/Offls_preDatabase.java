/**
 * 오프리스 매각준비차량 정보
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2003. 02. 12. Wed.
 * @ last modify date : 
 */
package acar.offls_pre;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;
import acar.exception.DatabaseException;
import acar.exception.DataSourceEmptyException;
import acar.common.*;
import acar.car_accident.*;

public class Offls_preDatabase
{
	private Connection conn = null;
	public static Offls_preDatabase db;
	
	public static Offls_preDatabase getInstance()
	{
		if(Offls_preDatabase.db == null)
			Offls_preDatabase.db = new Offls_preDatabase();
		return Offls_preDatabase.db;
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
	*	예비차량에서 매각준비차량으로 2003.2.12.Wed.
	*/
	public int setOffls_pre(String[] pre){
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = "UPDATE car_reg SET off_ls = '1', secondhand='' WHERE prepare='2' and  car_mng_id in ('";		
		
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
		 }catch(Exception se){
           try{
				System.out.println("[Offls_preDatabase:setOffls_pre(String[] pre)]"+se);
				se.printStackTrace();
			    conn.rollback();
            }catch(SQLException _ignored){}
            
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
	*	매각준비차량을 다시 예비차로 2003.2.12.Wed.
	*/
	public int cancelOffls_pre(String[] pre){
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = "UPDATE car_reg SET off_ls = '0' WHERE car_mng_id in ('";		
		for(int i=0 ; i<pre.length ; i++){
			if(i == (pre.length -1)){
				query += pre[i];
			}else{
				query += pre[i]+"', '";
			}
		}
		query += "')";
		try{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		 }catch(Exception se){
           try{
				System.out.println("[Offls_preDatabase:setOffls_pre(String[] pre)]"+se);
				se.printStackTrace();
			    conn.rollback();
            }catch(SQLException _ignored){}
            
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
	*	매각준비차량 Bean에 데이터 넣기 2003.2.12.Wed.
	*/
	 private Offls_preBean makeOffls_preBean(ResultSet results) throws DatabaseException {

        try {
            Offls_preBean bean = new Offls_preBean();

		    bean.setCar_mng_id(results.getString("CAR_MNG_ID"));			//자동차관리번호
			bean.setCar_no(results.getString("CAR_NO"));
			bean.setCar_pre_no(results.getString("CAR_PRE_NO"));
			bean.setCha_dt(results.getString("CHA_DT"));
			bean.setCar_num(results.getString("CAR_NUM"));
			bean.setInit_reg_dt(results.getString("INIT_REG_DT"));
			bean.setCar_kd(results.getString("CAR_KD"));
			bean.setCar_use(results.getString("CAR_USE"));
			bean.setCar_nm(results.getString("CAR_NM"));
			bean.setCar_jnm(results.getString("CAR_JNM"));
			bean.setCar_form(results.getString("CAR_FORM"));
			bean.setCar_y_form(results.getString("CAR_Y_FORM"));
			bean.setDpm(results.getString("DPM"));
			bean.setFuel_kd(results.getString("FUEL_KD"));
			bean.setMaint_st_dt(results.getString("MAINT_ST_DT"));
			bean.setMaint_end_dt(results.getString("MAINT_END_DT"));
			bean.setTest_st_dt(results.getString("TEST_ST_DT"));
			bean.setTest_end_dt(results.getString("TEST_END_DT"));
			bean.setCar_l_cd(results.getString("CAR_L_CD"));				//년도별차량등록순번
			bean.setRent_mng_id(results.getString("RENT_MNG_ID"));			//계약관리번호
			bean.setRent_l_cd(results.getString("RENT_L_CD"));				//계약번호
			bean.setCar_id(results.getString("CAR_ID"));
			bean.setColo(results.getString("COLO"));
			bean.setOpt(results.getString("OPT"));
			bean.setLpg_yn(results.getString("LPG_YN"));
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
			bean.setKm(results.getString("KM"));
			bean.setDeterm_id(results.getString("DETERM_ID"));
			bean.setHppr(results.getInt("HPPR"));
			bean.setStpr(results.getInt("STPR"));
/*			bean.setBkpr(results.getInt("BKPR"));
			bean.setSptax(results.getInt("SPTAX"));
			bean.setAllcost(results.getInt("ALLCOST"));
			bean.setRspr(results.getInt("RSPR"));
*/			bean.setDamdang_id(results.getString("DAMDANG_ID"));
			bean.setModify_id(results.getString("MODIFY_ID"));
			bean.setApprsl_dt(results.getString("APPRSL_DT"));
			bean.setCar_cha_yn(results.getString("CAR_CHA_YN"));
			bean.setCltr_amt(results.getInt("CLTR_AMT"));
			bean.setIns_com_nm(results.getString("INS_COM_NM"));
			bean.setIns_exp_dt(results.getString("INS_EXP_DT"));
			bean.setCar_doc_no(results.getString("car_doc_no"));
			bean.setGps(results.getString("GPS"));
			bean.setPark(results.getString("PARK"));
			bean.setCons_dt(results.getString("CONS_DT"));
			bean.setA_cnt(results.getInt("A_CNT"));
			bean.setCar_out_dt(results.getString("CAR_OUT_DT"));
			bean.setActn_id(results.getString("ACTN_ID"));


		return bean;

        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}
	
	/**
	*	매각준비차량 상세정보 2003.2.12.Wed.
	*/
	public Offls_preBean getPre_detail(String car_mng_id){
		getConnection();
		Offls_preBean detail = new Offls_preBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = "select	r.car_doc_no, r.car_mng_id CAR_MNG_ID, r.car_no CAR_NO, cg.car_no	CAR_PRE_NO,	cgg.cha_dt CHA_DT, r.car_num CAR_NUM, r.init_reg_dt	INIT_REG_DT, r.car_kd CAR_KD, r.car_use	CAR_USE, n.car_nm CAR_JNM, m.car_name CAR_NM,	r.car_form CAR_FORM, r.car_y_form	CAR_Y_FORM,	r.dpm			DPM,	r.fuel_kd		FUEL_KD,	r.maint_st_dt	MAINT_ST_DT,	r.maint_end_dt	MAINT_END_DT, r.test_st_dt TEST_ST_DT, r.test_end_dt TEST_END_DT, r.car_l_cd CAR_L_CD, e.rent_mng_id	RENT_MNG_ID,	e.rent_l_cd		RENT_L_CD,	e.car_id		CAR_ID,	e.colo			COLO,	e.opt			OPT, e.lpg_yn LPG_YN,e.car_cs_amt	CAR_CS_AMT,	e.car_cv_amt	CAR_CV_AMT,	e.car_fs_amt	CAR_FS_AMT,	e.car_fv_amt	CAR_FV_AMT,	e.opt_cs_amt	OPT_CS_AMT,	e.opt_cv_amt	OPT_CV_AMT,	e.opt_fs_amt	OPT_FS_AMT,	e.opt_fv_amt	OPT_FV_AMT,	e.clr_cs_amt	CLR_CS_AMT,	e.clr_cv_amt	CLR_CV_AMT,	e.clr_fs_amt	CLR_FS_AMT,	e.clr_fv_amt	CLR_FV_AMT,	e.sd_cs_amt		SD_CS_AMT,	e.sd_cv_amt		SD_CV_AMT,	e.sd_fs_amt		SD_FS_AMT,	e.sd_fv_amt		SD_FV_AMT,	e.dc_cs_amt		DC_CS_AMT,	e.dc_cv_amt		DC_CV_AMT,	e.dc_fs_amt		DC_FS_AMT,	e.dc_fv_amt		DC_FV_AMT, c.mng_id		MNG_ID,	c.dlv_dt DLV_DT, decode(r.car_mng_id, sq.car_mng_id, 1, 0) ACCIDENT_YN, "+
			" vt.tot_dist TOT_DIST, "+
			" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD'))))) as AVERAGE_DIST, "+
			" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST, "+
			" bk.bank_nm BANK_NM, bk.lend_prn LEND_PRN, sw.alt_rest	LEND_REM, bk.alt_end_dt ALT_END_DT, s.lev LEV, s.reason REASON, s.car_st CAR_ST,s.imgfile1 IMGFILE1, s.imgfile2 IMGFILE2, s.imgfile3 IMGFILE3, s.imgfile4 IMGFILE4, s.imgfile5 IMGFILE5, "+
			" nvl(s.km, 0) KM, uc.determ_id DETERM_ID, uc.hp_pr HPPR, uc.st_pr STPR, s.damdang_id DAMDANG_ID, s.modify_id MODIFY_ID, s.apprsl_dt APPRSL_DT, DECODE(r.car_mng_id, ch.car_mng_id, 1, 0) CAR_CHA_YN, t.cltr_amt CLTR_AMT "+
			", iu.ins_com_nm INS_COM_NM, iu.ins_exp_dt INS_EXP_DT, "+
			"       nvl(ak.a_cnt,0) a_cnt, \n"+  //침수여부
			"       decode(r.gps,'Y','장착') gps,"+		
			//" decode(r.park, '1','목동주차', '2','정일현대', '3','부산지점', '4','대전지점', '5','명진공업', '7','부산부경','8','부산조양','9','대전현대','10','오토크린', '11','대전금호','12','광주지점','13','대구지점','14','상무현대', '15','영남주차', '16','동화엠파크', substr(r.park_cont,1,5)) park , r.cons_dt CONS_DT, s.car_out_dt, s.actn_id   "+
			"  decode(r.park,'6',substr(r.park_cont,1,5),nvl(cd.nm,r.park)) park , r.cons_dt CONS_DT, s.car_out_dt, s.actn_id   "+
			" from car_reg r, car_etc e, cont c, apprsl s, cltr t,  CAR_NM m, CAR_MNG n, v_tot_dist vt, (select distinct ac.car_mng_id CAR_MNG_ID from accident ac, car_reg re where ac.car_mng_id=re.car_mng_id) sq, "+
			"        ( select c_st, code, nm_cd, nm from code where c_st = '0027' and code <> '0000'  ) cd,  \n"+  //주차장 
			"	(select a.car_mng_id CAR_MNG_ID, a.serv_dt SERV_DT, a.tot_dist TOT_DIST  from service a where a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where car_mng_id = a.car_mng_id)) i, "+
			"	(select al.rent_mng_id RENT_MNG_ID, al.rent_l_cd RENT_L_CD, cd.nm BANK_NM , al.lend_prn LEND_PRN, al.alt_end_dt ALT_END_DT from allot al, code cd where al.cpt_cd = cd.code and cd.c_st = '0003') bk, "+
			"	(SELECT DISTINCT cc.car_mng_id CAR_MNG_ID FROM car_cha cc, car_reg re WHERE cc.car_mng_id = re.car_mng_id) ch, "+
			"	(SELECT sc.car_mng_id CAR_MNG_ID, sc.alt_rest ALT_REST FROM scd_alt_case sc WHERE sc.alt_tm = (select max(alt_tm) from scd_alt_case where car_mng_id = sc.car_mng_id)) sw, "+
			"	(SELECT car_mng_id, cha_dt, car_no FROM car_change a WHERE a.cha_seq = to_char(to_number((select max(b.cha_seq) from car_change b where a.car_mng_id = b.car_mng_id))-1)) cg, "+
			"	(SELECT car_mng_id, cha_dt, car_no FROM car_change a WHERE a.cha_seq = to_char(to_number((select max(b.cha_seq) from car_change b where a.car_mng_id = b.car_mng_id and b.cha_seq>1)))) cgg, "+
			"	(SELECT a.car_mng_id CAR_MNG_ID, a.seq SEQ, a.actn_st ACTN_ST, a.damdang_id DETERM_ID, a.hp_pr HP_PR, a.st_pr ST_PR FROM auction a WHERE a.seq = (select max(seq) from auction where car_mng_id = a.car_mng_id)) uc ,"+
			"       (select ir.car_mng_id CAR_MNG_ID, ic.ins_com_nm INS_COM_NM, ir.ins_exp_dt INS_EXP_DT from insur ir, ins_com ic where ir.ins_com_id = ic.ins_com_id and ir.ins_st = (select max(ins_st) from insur where car_mng_id = ir.car_mng_id)) iu , "+
			"       (select car_mng_id, count(0) as a_cnt from accident where accid_st='6' group by car_mng_id) ak \n"+
			" where r.car_mng_id = c.car_mng_id "+
			"  and e.rent_mng_id = c.rent_mng_id "+
			"  and e.rent_l_cd = c.rent_l_cd "+
			"  and r.car_mng_id = sq.car_mng_id(+) "+
			"  and c.car_st = '2' "+
			"  and c.use_yn = 'Y' "+
			"  and r.off_ls = '1' "+
			"  and r.car_mng_id = i.car_mng_id(+) "+
			"  and c.rent_mng_id = bk.rent_mng_id(+) "+
			"  and c.rent_l_cd = bk.rent_l_cd(+) "+
			"  and r.car_mng_id = s.car_mng_id(+) "+
			"  and r.car_mng_id = ch.car_mng_id(+) "+
			"  AND r.car_mng_id = sw.car_mng_id(+) "+
			"  AND c.rent_mng_id = t.rent_mng_id(+) "+
			"  AND c.rent_l_cd = t.rent_l_cd(+) "+
			"  AND r.car_mng_id = cg.car_mng_id(+) "+
			"  AND r.car_mng_id = cgg.car_mng_id(+) "+
			"  AND r.car_mng_id = ak.car_mng_id(+) \n"+  //침수차량여부
			"  AND e.car_id = m.car_id "+	
			"  and e.car_seq = m.car_seq "+
			"  and m.car_comp_id = n.car_comp_id "+
			"  and m.car_cd = n.code "+
			"  AND r.car_mng_id = vt.car_mng_id(+) "+
			"  AND r.car_mng_id = uc.car_mng_id(+) "+
			"  and r.car_mng_id = iu.car_mng_id(+) "+
			"  and r.park = cd.nm_cd(+) \n"+  //주차장 코드 테이블 
			"  and r.car_mng_id = '"+car_mng_id+"'";


		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while(rs.next()){
				detail = makeOffls_preBean(rs);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_preDatabase:getPre_detail(String car_mng_id)]"+e);
			System.out.println("[Offls_preDatabase:getPre_detail(String car_mng_id)]"+query);
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
	*	출품현황에서 품질 보증서 출력할 수 있도록
	*/
	public Offls_preBean getPre_detail2(String car_mng_id){
		getConnection();
		Offls_preBean detail = new Offls_preBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = "select	r.car_doc_no, r.car_mng_id CAR_MNG_ID, r.car_no CAR_NO, cg.car_no	CAR_PRE_NO,	cgg.cha_dt CHA_DT, r.car_num CAR_NUM, r.init_reg_dt	INIT_REG_DT, r.car_kd CAR_KD, r.car_use	CAR_USE, n.car_nm CAR_JNM, m.car_name CAR_NM,	r.car_form CAR_FORM, r.car_y_form	CAR_Y_FORM,	r.dpm			DPM,	r.fuel_kd		FUEL_KD,	r.maint_st_dt	MAINT_ST_DT,	r.maint_end_dt	MAINT_END_DT, r.test_st_dt TEST_ST_DT, r.test_end_dt TEST_END_DT, r.car_l_cd CAR_L_CD, e.rent_mng_id	RENT_MNG_ID,	e.rent_l_cd		RENT_L_CD,	e.car_id		CAR_ID,	e.colo			COLO,	e.opt			OPT, e.lpg_yn LPG_YN,e.car_cs_amt	CAR_CS_AMT,	e.car_cv_amt	CAR_CV_AMT,	e.car_fs_amt	CAR_FS_AMT,	e.car_fv_amt	CAR_FV_AMT,	e.opt_cs_amt	OPT_CS_AMT,	e.opt_cv_amt	OPT_CV_AMT,	e.opt_fs_amt	OPT_FS_AMT,	e.opt_fv_amt	OPT_FV_AMT,	e.clr_cs_amt	CLR_CS_AMT,	e.clr_cv_amt	CLR_CV_AMT,	e.clr_fs_amt	CLR_FS_AMT,	e.clr_fv_amt	CLR_FV_AMT,	e.sd_cs_amt		SD_CS_AMT,	e.sd_cv_amt		SD_CV_AMT,	e.sd_fs_amt		SD_FS_AMT,	e.sd_fv_amt		SD_FV_AMT,	e.dc_cs_amt		DC_CS_AMT,	e.dc_cv_amt		DC_CV_AMT,	e.dc_fs_amt		DC_FS_AMT,	e.dc_fv_amt		DC_FV_AMT, c.mng_id		MNG_ID,	c.dlv_dt DLV_DT, decode(r.car_mng_id, sq.car_mng_id, 1, 0) ACCIDENT_YN, "+
			" vt.tot_dist TOT_DIST, "+
			" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD'))))) as AVERAGE_DIST, "+
			" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST, "+
			" bk.bank_nm BANK_NM, bk.lend_prn LEND_PRN, sw.alt_rest	LEND_REM, bk.alt_end_dt ALT_END_DT, s.lev LEV, s.reason REASON, s.car_st CAR_ST,s.imgfile1 IMGFILE1, s.imgfile2 IMGFILE2, s.imgfile3 IMGFILE3, s.imgfile4 IMGFILE4, s.imgfile5 IMGFILE5, "+
			" nvl(s.km, 0) KM, uc.determ_id DETERM_ID, uc.hp_pr HPPR, uc.st_pr STPR, s.damdang_id DAMDANG_ID, s.modify_id MODIFY_ID, s.apprsl_dt APPRSL_DT, DECODE(r.car_mng_id, ch.car_mng_id, 1, 0) CAR_CHA_YN, t.cltr_amt CLTR_AMT "+
			", iu.ins_com_nm INS_COM_NM, iu.ins_exp_dt INS_EXP_DT, "+
			"       nvl(ak.a_cnt,0) a_cnt, \n"+  //침수여부
			"       decode(r.gps,'Y','장착') gps,"+		
			//" decode(r.park, '1','목동주차', '2','정일현대', '3','부산지점', '4','대전지점', '5','명진공업', '7','부산부경','8','부산조양','9','대전현대','10','오토크린', '11','대전금호','12','광주지점','13','대구지점','14','상무현대', '15','영남주차', '16','동화엠파크', substr(r.park_cont,1,5)) park , r.cons_dt CONS_DT, s.car_out_dt, s.actn_id  "+
			" decode(r.park,'6',substr(r.park_cont,1,5),nvl(cd.nm,r.park)) park , r.cons_dt CONS_DT, s.car_out_dt, s.actn_id  "+
			" from car_reg r, car_etc e, cont c, apprsl s, cltr t,  CAR_NM m, CAR_MNG n, v_tot_dist vt, (select distinct ac.car_mng_id CAR_MNG_ID from accident ac, car_reg re where ac.car_mng_id=re.car_mng_id) sq, "+
			"        ( select c_st, code, nm_cd, nm from code where c_st = '0027' and code <> '0000'  ) cd,  \n"+  //주차장 
			"	(select a.car_mng_id CAR_MNG_ID, a.serv_dt SERV_DT, a.tot_dist TOT_DIST  from service a where a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where car_mng_id = a.car_mng_id)) i, "+
			"	(select al.rent_mng_id RENT_MNG_ID, al.rent_l_cd RENT_L_CD, cd.nm BANK_NM , al.lend_prn LEND_PRN, al.alt_end_dt ALT_END_DT from allot al, code cd where al.cpt_cd = cd.code and cd.c_st = '0003') bk, "+
			"	(SELECT DISTINCT cc.car_mng_id CAR_MNG_ID FROM car_cha cc, car_reg re WHERE cc.car_mng_id = re.car_mng_id) ch, "+
			"	(SELECT sc.car_mng_id CAR_MNG_ID, sc.alt_rest ALT_REST FROM scd_alt_case sc WHERE sc.alt_tm = (select max(alt_tm) from scd_alt_case where car_mng_id = sc.car_mng_id)) sw, "+
			"	(SELECT car_mng_id, cha_dt, car_no FROM car_change a WHERE a.cha_seq = to_char(to_number((select max(b.cha_seq) from car_change b where a.car_mng_id = b.car_mng_id))-1)) cg, "+
			"	(SELECT car_mng_id, cha_dt, car_no FROM car_change a WHERE a.cha_seq = to_char(to_number((select max(b.cha_seq) from car_change b where a.car_mng_id = b.car_mng_id and b.cha_seq>1)))) cgg, "+
			"	(SELECT a.car_mng_id CAR_MNG_ID, a.seq SEQ, a.actn_st ACTN_ST, a.damdang_id DETERM_ID, a.hp_pr HP_PR, a.st_pr ST_PR FROM auction a WHERE a.seq = (select max(seq) from auction where car_mng_id = a.car_mng_id)) uc ,"+
			"       (select ir.car_mng_id CAR_MNG_ID, ic.ins_com_nm INS_COM_NM, ir.ins_exp_dt INS_EXP_DT from insur ir, ins_com ic where ir.ins_com_id = ic.ins_com_id and ir.ins_st = (select max(ins_st) from insur where car_mng_id = ir.car_mng_id)) iu , "+
			"       (select car_mng_id, count(0) as a_cnt from accident where accid_st='6' group by car_mng_id) ak \n"+
			" where r.car_mng_id = c.car_mng_id "+
			"  and e.rent_mng_id = c.rent_mng_id "+
			"  and e.rent_l_cd = c.rent_l_cd "+
			"  and r.car_mng_id = sq.car_mng_id(+) "+
			"  and c.car_st = '2' "+
			"  and c.use_yn = 'Y' "+
//			"  and r.off_ls = '1' "+
			"  and r.car_mng_id = i.car_mng_id(+) "+
			"  and c.rent_mng_id = bk.rent_mng_id(+) "+
			"  and c.rent_l_cd = bk.rent_l_cd(+) "+
			"  and r.car_mng_id = s.car_mng_id(+) "+
			"  and r.car_mng_id = ch.car_mng_id(+) "+
			"  AND r.car_mng_id = sw.car_mng_id(+) "+
			"  AND c.rent_mng_id = t.rent_mng_id(+) "+
			"  AND c.rent_l_cd = t.rent_l_cd(+) "+
			"  AND r.car_mng_id = cg.car_mng_id(+) "+
			"  AND r.car_mng_id = cgg.car_mng_id(+) "+
			"  AND r.car_mng_id = ak.car_mng_id(+) \n"+  //침수차량여부
			"  AND e.car_id = m.car_id "+	
			"  and e.car_seq = m.car_seq "+
			"  and m.car_comp_id = n.car_comp_id "+
			"  and m.car_cd = n.code "+
			"  AND r.car_mng_id = vt.car_mng_id(+) "+
			"  AND r.car_mng_id = uc.car_mng_id(+) "+
			"  and r.car_mng_id = iu.car_mng_id(+) "+
			" and r.park = cd.nm_cd(+) \n"+  //주차장 코드 테이블 
			"  and r.car_mng_id = '"+car_mng_id+"'";


		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while(rs.next()){
				detail = makeOffls_preBean(rs);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_preDatabase:getPre_detail(String car_mng_id)]"+e);
			System.out.println("[Offls_preDatabase:getPre_detail(String car_mng_id)]"+query);
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
	*	회사별 매각준비차량 통계 - 2003.2.12.Wed.
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
"and c.off_ls = '1'  "+
"and e.car_id = n.car_id     "+
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
"and c.off_ls = '1'     "+
"and e.car_id = n.car_id     "+
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
"and c.off_ls = '1'     "+
"and e.car_id = n.car_id     "+
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
"and c.off_ls = '1'     "+
"and e.car_id = n.car_id     "+
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
"and c.off_ls = '1'    "+ 
"and e.car_id = n.car_id     "+
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
				System.out.println("[Offls_preDatabase:getTg()]"+e);
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
	*	매각준비차량 검색 - 2003.2.12.Wed.
	*	- gubun : 차량번호, 차량명, 최초등록일
	*	- gubun_nm : 해당 데이타
	*/
	public Offls_preBean[] getPre_lst(String gubun, String gubun_nm, String brch_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String subQuery = "";

		if(gubun.equals("car_no")){
			subQuery = " and r.car_no like '%" + gubun_nm + "%' ";
		}else if(gubun.equals("car_nm")){
			subQuery = " and r.car_nm like '%" + gubun_nm.toUpperCase() + "%' ";
		}else if(gubun.equals("init_reg_dt")){
			subQuery = " and r.init_reg_dt like replace('"+ gubun_nm +"','-','')||'%' ";
		}else{ //all
			subQuery = "";
		}
		
		if(!brch_id.equals(""))	subQuery += " and c.brch_id='"+brch_id+"'";

		query = "select	r.car_doc_no, r.car_mng_id CAR_MNG_ID, r.car_no CAR_NO, cg.car_no	CAR_PRE_NO,	cg.cha_dt CHA_DT, r.car_num CAR_NUM, r.init_reg_dt	INIT_REG_DT, r.car_kd CAR_KD, r.car_use	CAR_USE, n.car_nm CAR_JNM, m.car_name CAR_NM,	r.car_form CAR_FORM, r.car_y_form	CAR_Y_FORM,	r.dpm			DPM,	r.fuel_kd		FUEL_KD,	r.maint_st_dt	MAINT_ST_DT,	r.maint_end_dt	MAINT_END_DT, r.test_st_dt TEST_ST_DT, r.test_end_dt TEST_END_DT, r.car_l_cd CAR_L_CD, e.rent_mng_id	RENT_MNG_ID,	e.rent_l_cd		RENT_L_CD,	e.car_id		CAR_ID,	e.colo			COLO, e.opt			OPT, e.lpg_yn LPG_YN,	e.car_cs_amt	CAR_CS_AMT,	e.car_cv_amt	CAR_CV_AMT,	e.car_fs_amt	CAR_FS_AMT,	e.car_fv_amt	CAR_FV_AMT,	e.opt_cs_amt	OPT_CS_AMT,	e.opt_cv_amt	OPT_CV_AMT,	e.opt_fs_amt	OPT_FS_AMT,	e.opt_fv_amt	OPT_FV_AMT,	e.clr_cs_amt	CLR_CS_AMT,	e.clr_cv_amt	CLR_CV_AMT,	e.clr_fs_amt	CLR_FS_AMT,	e.clr_fv_amt	CLR_FV_AMT,	e.sd_cs_amt		SD_CS_AMT,	e.sd_cv_amt		SD_CV_AMT,	e.sd_fs_amt		SD_FS_AMT,	e.sd_fv_amt		SD_FV_AMT,	e.dc_cs_amt		DC_CS_AMT,	e.dc_cv_amt		DC_CV_AMT,	e.dc_fs_amt		DC_FS_AMT,	e.dc_fv_amt		DC_FV_AMT, c.mng_id		MNG_ID, c.dlv_dt DLV_DT,	decode(r.car_mng_id, sq.car_mng_id, 1, 0) ACCIDENT_YN, "+
			" vt.tot_dist TOT_DIST, \n"+
			" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD'))))) as AVERAGE_DIST, \n"+
			" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST, \n"+
			" bk.bank_nm BANK_NM, bk.lend_prn LEND_PRN, sw.alt_rest	LEND_REM, bk.alt_end_dt ALT_END_DT, s.lev LEV, s.reason REASON, s.car_st CAR_ST, s.imgfile1 IMGFILE1, s.imgfile2 IMGFILE2, s.imgfile3 IMGFILE3, s.imgfile4 IMGFILE4, s.imgfile5 IMGFILE5, \n"+
			"   s.km KM, uc.determ_id DETERM_ID, uc.hp_pr HPPR, uc.st_pr STPR, s.damdang_id DAMDANG_ID, s.modify_id MODIFY_ID, s.apprsl_dt APPRSL_DT,  '' CAR_CHA_YN, 0  CLTR_AMT \n"+
		//	+ " DECODE(r.car_mng_id, ch.car_mng_id, 1, 0) CAR_CHA_YN, t.cltr_amt CLTR_AMT \n"+
			", iu.ins_com_nm INS_COM_NM, iu.ins_exp_dt INS_EXP_DT, \n"+
			"       nvl(ak.a_cnt,0) a_cnt, \n"+  //침수여부
			"       decode(r.gps,'Y','장착') gps, "+	
			//"       decode(r.park, '1','목동주차', '2','정일현대', '3','부산지점', '4','대전지점', '5','명진공업', '7','부산부경','8','부산조양','9','대전현대','10','오토크린', '11','대전금호','12','광주지점','13','대구지점','14','상무현대', '15','영남주차', '16','동화엠파크', substr(r.park_cont,1,5)) park,  \n"+	
			" decode(r.park,'6',substr(r.park_cont,1,5),nvl(cd.nm,r.park)) park, \n"+
			"      '' call_in_st,   r.cons_dt  CONS_DT, s.car_out_dt, s.actn_id  "+
		//	"  cltr t,      decode(cc.rent_l_cd,'','','해지반납') call_in_st,   r.cons_dt  CONS_DT, s.car_out_dt, s.actn_id  "+
			" from car_reg r, car_etc e, cont c, apprsl s,  CAR_NM m, CAR_MNG n, v_tot_dist vt, (select distinct ac.car_mng_id CAR_MNG_ID from accident ac, car_reg re where ac.car_mng_id=re.car_mng_id) sq, \n"+
			"		(select a.car_mng_id CAR_MNG_ID, a.serv_dt SERV_DT, a.tot_dist TOT_DIST  from service a where a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where car_mng_id = a.car_mng_id)) i, \n"+
			"		(select al.rent_mng_id RENT_MNG_ID, al.rent_l_cd RENT_L_CD, cd.nm BANK_NM, al.lend_prn LEND_PRN, al.alt_end_dt ALT_END_DT from allot al, code cd where al.cpt_cd = cd.code and cd.c_st = '0003') bk, \n"+
		//	"		(SELECT DISTINCT cc.car_mng_id CAR_MNG_ID FROM car_cha cc, car_reg re WHERE cc.car_mng_id = re.car_mng_id) ch, \n"+
			"		(SELECT sc.car_mng_id CAR_MNG_ID, sc.alt_rest ALT_REST FROM scd_alt_case sc WHERE sc.alt_tm = (select max(alt_tm) from scd_alt_case where car_mng_id = sc.car_mng_id)) sw, \n"+
			"	    (SELECT car_mng_id, cha_dt, car_no FROM car_change a WHERE a.cha_seq = to_char(to_number((select max(b.cha_seq) from car_change b where a.car_mng_id = b.car_mng_id))-1)) cg, \n"+
			"	    (SELECT a.car_mng_id CAR_MNG_ID, a.seq SEQ, a.actn_st ACTN_ST, a.damdang_id DETERM_ID, a.hp_pr HP_PR, a.st_pr ST_PR FROM auction a WHERE a.seq = (select max(seq) from auction where car_mng_id = a.car_mng_id)) uc, \n"+
			"       (select ir.car_mng_id CAR_MNG_ID, ic.ins_com_nm INS_COM_NM, ir.ins_exp_dt INS_EXP_DT from insur ir, ins_com ic where ir.ins_com_id = ic.ins_com_id and ir.ins_st = (select max(ins_st) from insur where car_mng_id = ir.car_mng_id)) iu, \n"+
            //차량해지반납
		//	"       ( select * from car_call_in where in_st='3' and out_dt is null ) cc, "+
			"       (select car_mng_id, count(0) as a_cnt from accident where accid_st='6' group by car_mng_id) ak, \n"+
			"        ( select c_st, code, nm_cd, nm from code where c_st = '0027' and code <> '0000'  ) cd,  \n"+  //주차장 
			"       (select * from sh_res a     where a.use_yn='Y' and a.situation in ('1','2')) g "+ //계약확정은 제외
			" where r.car_mng_id = c.car_mng_id \n"+
			"  and e.rent_mng_id = c.rent_mng_id \n"+
			"  and e.rent_l_cd = c.rent_l_cd \n"+
			"  and r.car_mng_id = sq.car_mng_id(+) \n"+
//			"  and c.car_st = '2' \n"+
			"  and c.use_yn = 'Y' \n"+
			"  and r.off_ls = '1' \n"+
			"  and r.car_mng_id = i.car_mng_id(+) \n"+
			"  and c.rent_mng_id = bk.rent_mng_id(+) \n"+
			"  and c.rent_l_cd = bk.rent_l_cd(+) \n"+
			"  and r.car_mng_id = s.car_mng_id(+) \n"+
		//	"  and r.car_mng_id = ch.car_mng_id(+) \n"+
			"  AND r.car_mng_id = sw.car_mng_id(+) \n"+
		//	"  AND c.rent_mng_id = t.rent_mng_id(+) \n"+
			"  AND r.car_mng_id = cg.car_mng_id(+) \n"+
			"  AND r.car_mng_id = ak.car_mng_id(+) \n"+  //침수차량여부
			"  AND e.car_id = m.car_id \n"+	
			"  and e.car_seq = m.car_seq \n"+
			"  and m.car_comp_id = n.car_comp_id \n"+
			"  and m.car_cd = n.code \n"+
			"  AND r.car_mng_id = vt.car_mng_id(+) \n"+
			"  AND r.car_mng_id = uc.car_mng_id(+) \n"+
			"  and r.car_mng_id = iu.car_mng_id(+) \n"+
		//	"  AND c.rent_l_cd = t.rent_l_cd(+) \n"+
		//	"  and c.rent_mng_id=cc.rent_mng_id(+) and c.rent_l_cd=cc.rent_l_cd(+)"+						
		//	"  and decode(cc.rent_l_cd,'',c.car_st,'')='2'"+
			"  and r.car_mng_id=g.car_mng_id(+) "+
			" and r.park = cd.nm_cd(+) \n"+  //주차장 코드 테이블 
			"  and g.car_mng_id is null"+
			subQuery+
		  //" ORDER BY s.actn_id, decode(s.doc_chk,'Y','1','2'),  decode(r.park, '1','11', '2','12', '3','21', '4','31', '5','13', '7','22','8','23','9','32','12','33','13','34', '99'), apprsl_dt ";
			" ORDER BY s.actn_id, decode(s.doc_chk,'Y','1','2'),  decode(r.park, '1','11','15','12', '2','13', '3','21', '4','31', '5','13', '7','22','8','23','9','32','12','33','13','34', '99'), apprsl_dt ";


		Collection<Offls_preBean> col = new ArrayList<Offls_preBean>();

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while(rs.next()){
				col.add(makeOffls_preBean(rs));
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_preDatabase:getPre_lst(String gubun, String gubun_nm)]"+e);
			System.out.println("[Offls_preDatabase:getPre_lst(String gubun, String gubun_nm)]"+query);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return (Offls_preBean[])col.toArray(new Offls_preBean[0]);
		}		
	}

	/**
	*	상품평가 데이터 입력 - 2003.2.22.Sat.
	*	- 
	*/
	public int inApprsl(String car_mng_id, Off_ls_pre_apprsl apprsl){

		getConnection();
		int result = 0;
		PreparedStatement pstmt = null;

		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement("insert into apprsl(car_mng_id, lev, reason, car_st, sago_yn, lpg_yn, km, damdang, actn_id, damdang_id, modify_id, apprsl_dt, actn_wh ) values(?,?,?,?,?,?,?,?,?,?,?,?, ?)");
			pstmt.setString(1,car_mng_id);
			pstmt.setString(2,apprsl.getLev());
			pstmt.setString(3,apprsl.getReason());
			pstmt.setString(4,apprsl.getCar_st());
			pstmt.setString(5,apprsl.getSago_yn());
			pstmt.setString(6,apprsl.getLpg_yn());
			pstmt.setString(7,apprsl.getKm());
			pstmt.setString(8,apprsl.getDamdang());
			pstmt.setString(9,apprsl.getActn_id());
			pstmt.setString(10,apprsl.getDamdang_id());
			pstmt.setString(11,apprsl.getModify_id());
			pstmt.setString(12,apprsl.getApprsl_dt());
			pstmt.setString(13,apprsl.getActn_wh());
			//pstmt.setString(15,apprsl.getDeterm_id());
			//pstmt.setString(9,apprsl.getNum_ch());
			//pstmt.setInt(9,apprsl.getHppr());
			//pstmt.setInt(10,apprsl.getStpr());
			//pstmt.setInt(11,apprsl.getBkpr());
			//pstmt.setInt(12,apprsl.getSptax());
			//pstmt.setInt(13,apprsl.getAllcost());
			//pstmt.setInt(14,apprsl.getRspr());
			result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		}catch(SQLException e){
			System.out.println("[Offls_preDatabase:inApprsl(String car_mng_id, Off_ls_pre_apprsl apprsl)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{	
                if(pstmt != null) pstmt.close();
				conn.setAutoCommit(true);				
			}catch(Exception ignore){}
			closeConnection();
			return result;
		}
	}

	/**
	*	상품평가 데이터 수정 - 2003.2.22.Sat.
	*	- 먼저 car_mng_id가 있으면 update하고, 아니면 inApprsl()호출해서 insert한다.
	*/
	public int upApprsl(String car_mng_id, Off_ls_pre_apprsl apprsl){

		getConnection();
		int result = 0;
		PreparedStatement pstmt = null;
		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement("update apprsl set lev=?,reason=?,car_st=?, sago_yn=?, lpg_yn=?, km=?, damdang=?, actn_id=?, damdang_id=?, modify_id=?, apprsl_dt=?, actn_wh = ?  where car_mng_id = ? ");
			pstmt.setString(1,apprsl.getLev());
			pstmt.setString(2,apprsl.getReason());
			pstmt.setString(3,apprsl.getCar_st());
			pstmt.setString(4,apprsl.getSago_yn());
			pstmt.setString(5,apprsl.getLpg_yn());
			pstmt.setString(6,apprsl.getKm());
			pstmt.setString(7,apprsl.getDamdang());
			pstmt.setString(8,apprsl.getActn_id());
			pstmt.setString(9,apprsl.getDamdang_id());
			pstmt.setString(10,apprsl.getModify_id());
			pstmt.setString(11,apprsl.getApprsl_dt());
			pstmt.setString(12,apprsl.getActn_wh());
			pstmt.setString(13,car_mng_id);
			//pstmt.setString(14,apprsl.getDeterm_id());
			//pstmt.setString(8,apprsl.getNum_ch());
			//pstmt.setInt(8,apprsl.getHppr());
			//pstmt.setInt(9,apprsl.getStpr());
			//pstmt.setInt(10,apprsl.getBkpr());
			//pstmt.setInt(11,apprsl.getSptax());
			//pstmt.setInt(12,apprsl.getAllcost());
			//pstmt.setInt(13,apprsl.getRspr());
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		}catch(SQLException e){
			System.out.println("[Offls_preDatabase:upApprsl(String car_mng_id, Off_ls_pre_apprsl apprsl)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{	
                if(pstmt != null) pstmt.close();
				conn.setAutoCommit(true);				
			}catch(Exception ignore){}
			closeConnection();
			return result;			
		}
	}

	/**
	*	보험상태 데이터 존재 여부 - 2003.04.18.Fri.
	*	- 등록,수정버튼 구분하기위해
	*/
	public boolean getApprsl_ins(String car_mng_id){

		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		boolean apprsl_ins = false;
		String query = "SELECT ins_com_id, ins_type, ins_st_dt, ins_ed_dt, ins_pr, ins_pr_dt FROM apprsl WHERE car_mng_id=?";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				String apprsl_ins_com_id = rs.getString(1)==null?"":rs.getString(1);
				String apprsl_ins_type = rs.getString(2)==null?"":rs.getString(2);
				String apprsl_ins_st_dt = rs.getString(3)==null?"":rs.getString(3);
				String apprsl_ins_ed_dt = rs.getString(4)==null?"":rs.getString(4);
				int apprsl_ins_pr = rs.getInt(5);
				String apprsl_ins_pr_dt = rs.getString(6)==null?"":rs.getString(6);
				if(apprsl_ins_com_id.equals("") && apprsl_ins_type.equals("") && apprsl_ins_st_dt.equals("") 
					&& apprsl_ins_ed_dt.equals("") && apprsl_ins_pr==0 && apprsl_ins_pr_dt.equals("")) 
					apprsl_ins = true;
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_preDatabase:getApprsl_Ins_com_id(String car_mng_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return apprsl_ins;
		}
	}

	/**
	*	보증서 데이터 존재 여부 - 2003.04.18.Fri.
	*	- 등록,수정버튼 구분하기위해
	*/
	public boolean getApprsl_ass(String car_mng_id){

		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		boolean apprsl_ass = false;
		String query = "SELECT ass_st_dt, ass_ed_dt, ass_st_km, ass_ed_km, ass_wrt FROM apprsl WHERE car_mng_id=?";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				String apprsl_ass_st_dt = rs.getString(1)==null?"":rs.getString(1);
				String apprsl_ass_ed_dt = rs.getString(2)==null?"":rs.getString(2);
				String apprsl_ass_st_km = rs.getString(3)==null?"":rs.getString(3);
				String apprsl_ass_ed_km = rs.getString(4)==null?"":rs.getString(4);
				String apprsl_ass_wrt = rs.getString(5)==null?"":rs.getString(5);
				if(apprsl_ass_st_dt.equals("")&& apprsl_ass_ed_dt.equals("") && apprsl_ass_st_km.equals("") && apprsl_ass_ed_km.equals("") && apprsl_ass_wrt.equals("")) apprsl_ass=true;
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_preDatabase:getApprsl_ass_st_dt(String car_mng_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return apprsl_ass;
		}
	}

	/**
	*	오프리스 보험 등록 - 2003.06.19.Thu.
	*/
	public int inOffls_ins(Offls_insBean ins){

		getConnection();
		int result = 0;
		PreparedStatement pstmt = null;
		String query = "";

		query = "INSERT INTO offls_ins VALUES(?,?,?,?,?,?,?)";

		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,ins.getCar_mng_id());
			pstmt.setString(2,ins.getIns_com_id());
			pstmt.setString(3,ins.getIns_type());
			pstmt.setString(4,ins.getIns_st_dt());
			pstmt.setString(5,ins.getIns_ed_dt());
			pstmt.setInt(6,ins.getPay_pr());
			pstmt.setString(7,ins.getPay_pr_dt());
			result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		}catch(SQLException e){
			System.out.println("[Offls_preDatabase:inOffls_ins(Offls_insBean ins)]"+e);
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
	*	오프리스 보험 수정 - 2003.06.19.Thu.
	*/
	public int upOffls_ins(Offls_insBean ins){

		getConnection();
		int result = 0;
		PreparedStatement pstmt = null;
		String query = "";

		query = "UPDATE offls_ins SET ins_com_id=?,ins_type=?,ins_st_dt=?,ins_ed_dt=?,pay_pr=? WHERE car_mng_id=? AND pay_pr_dt=?";

		try{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,ins.getIns_com_id());
			pstmt.setString(2,ins.getIns_type());
			pstmt.setString(3,ins.getIns_st_dt());
			pstmt.setString(4,ins.getIns_ed_dt());
			pstmt.setInt(5,ins.getPay_pr());
			pstmt.setString(6,ins.getCar_mng_id());
			pstmt.setString(7,ins.getPay_pr_dt());
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
				
		}catch(SQLException e){
			System.out.println("[Offls_preDatabase:upOffls_ins(Offls_insBean ins)]"+e);
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
	*	오프리스 보험 삭제 - 2003.06.19.Thu.
	*/
	public int delOffls_ins(Offls_insBean ins){

		getConnection();
		int result = 0;
		PreparedStatement pstmt = null;
		String query = "";

		query = "DELETE offls_ins WHERE car_mng_id=? AND pay_pr_dt=?";

		try{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,ins.getCar_mng_id());
			pstmt.setString(2,ins.getPay_pr_dt());
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
				
		}catch(SQLException e){
			System.out.println("[Offls_preDatabase:delOffls_ins(Offls_insBean ins)]"+e);
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
	*	오프리스 보험 조회 - 2003.06.19.Thu.
	*/
	public Offls_insBean[] getOffls_ins(String car_mng_id){

		getConnection();
		int result = 0;
		Collection<Offls_insBean> col = new ArrayList<Offls_insBean>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = "SELECT car_mng_id,ins_com_id,ins_type,ins_st_dt,ins_ed_dt,pay_pr,pay_pr_dt FROM offls_ins WHERE car_mng_id=? ORDER BY pay_pr_dt";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				Offls_insBean ins = new Offls_insBean();
				ins.setCar_mng_id(rs.getString("CAR_MNG_ID")==null?"":rs.getString("CAR_MNG_ID"));
				ins.setIns_com_id(rs.getString("INS_COM_ID")==null?"":rs.getString("INS_COM_ID"));
				ins.setIns_type(rs.getString("INS_TYPE")==null?"":rs.getString("INS_TYPE"));
				ins.setIns_st_dt(rs.getString("INS_ST_DT")==null?"":rs.getString("INS_ST_DT"));
				ins.setIns_ed_dt(rs.getString("INS_ED_DT")==null?"":rs.getString("INS_ED_DT"));
				ins.setPay_pr(rs.getInt("PAY_PR"));
				ins.setPay_pr_dt(rs.getString("PAY_PR_DT")==null?"":rs.getString("PAY_PR_DT"));

				col.add(ins);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_preDatabase:getOffls_ins(String car_mng_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(pstmt != null) pstmt.close();
				if(rs != null) rs.close();
			}catch(Exception ex){}
			closeConnection();
			return (Offls_insBean[])col.toArray(new Offls_insBean[0]);
		}
	}

	/**
	*	오프리스 보험사명 조회 - 2003.06.19.Thu.
	*/
	public String getIns_com_nm(String ins_com_id){

		getConnection();
		int result = 0;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String ins_com_nm = "";

		query = "SELECT ins_com_nm FROM ins_com WHERE ins_com_id=?";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,ins_com_id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				ins_com_nm = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_preDatabase:getIns_com_nm(String ins_com_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(pstmt != null) pstmt.close();
				if(rs != null) rs.close();
			}catch(Exception ex){}
			closeConnection();
			return ins_com_nm;
		}
	}


	/**
	*	상품평가 데이터 수정(보증서류) - 2003.4.11.Fri.
	*/
	public int upApprsl_ass(String car_mng_id, Off_ls_pre_apprsl apprsl){

		getConnection();
		int result = 0;
		PreparedStatement pstmt = null;
		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement("UPDATE apprsl SET ass_st_dt=?, ass_ed_dt=?, ass_st_km=?, ass_ed_km=?, ass_wrt=?, ass_chk=? where car_mng_id = ?");
			pstmt.setString(1,apprsl.getAss_st_dt());
			pstmt.setString(2,apprsl.getAss_ed_dt());
			pstmt.setString(3,apprsl.getAss_st_km());
			pstmt.setString(4,apprsl.getAss_ed_km());
			pstmt.setString(5,apprsl.getAss_wrt());
			pstmt.setString(6,apprsl.getAss_chk());
			pstmt.setString(7,car_mng_id);
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
		}catch(SQLException e){
			System.out.println("[Offls_preDatabase:upApprsl_ass(String car_mng_id, Off_ls_pre_apprsl apprsl)]"+e);
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
	*	상품평가관련데이터 가져오기 - 2003.2.24.Mon.
	*	- 
	*/
	public Off_ls_pre_apprsl getPre_apprsl(String car_mng_id){

		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Off_ls_pre_apprsl apprsl = new Off_ls_pre_apprsl();

		try{
			pstmt = conn.prepareStatement("SELECT car_mng_id, lev, reason, car_st, sago_yn, lpg_yn, km, damdang, actn_id, damdang_id, modify_id, doc_chk, doc_seq, apprsl_dt, ins_com_id, ins_type, ins_st_dt, ins_ed_dt, ins_pr, ins_pr_dt, ass_st_dt, ass_ed_dt, ass_st_km, ass_ed_km, ass_wrt, ass_chk , actn_wh FROM apprsl WHERE car_mng_id=?");
			pstmt.setString(1,car_mng_id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				apprsl.setLev(rs.getString("LEV"));
				apprsl.setReason(rs.getString("REASON"));
				apprsl.setCar_st(rs.getString("CAR_ST"));
				apprsl.setSago_yn(rs.getString("SAGO_YN"));
				apprsl.setLpg_yn(rs.getString("LPG_YN"));
				apprsl.setKm(rs.getString("KM"));
				apprsl.setDamdang(rs.getString("DAMDANG"));
				//apprsl.setNum_ch(rs.getString("NUM_CH"));
				//apprsl.setHppr(rs.getInt("HPPR"));
				//apprsl.setStpr(rs.getInt("STPR"));
				//apprsl.setBkpr(rs.getInt("BKPR"));
				//apprsl.setSptax(rs.getInt("SPTAX"));
				//apprsl.setAllcost(rs.getInt("ALLCOST"));
				//apprsl.setRspr(rs.getInt("RSPR"));
				apprsl.setActn_id(rs.getString("ACTN_ID"));
				apprsl.setDamdang_id(rs.getString("DAMDANG_ID"));
				apprsl.setModify_id(rs.getString("MODIFY_ID"));
				apprsl.setDoc_chk(rs.getString("DOC_CHK"));
				apprsl.setDoc_seq(rs.getString("DOC_SEQ"));
				apprsl.setApprsl_dt(rs.getString("APPRSL_DT"));
				//apprsl.setDeterm_id(rs.getString("DETERM_ID"));
				apprsl.setIns_com_id(rs.getString("INS_COM_ID"));
				apprsl.setIns_type(rs.getString("INS_TYPE"));
				apprsl.setIns_st_dt(rs.getString("INS_ST_DT"));
				apprsl.setIns_ed_dt(rs.getString("INS_ED_DT"));
				apprsl.setIns_pr(rs.getInt("INS_PR"));
				apprsl.setIns_pr_dt(rs.getString("INS_PR_DT"));
				apprsl.setAss_st_dt(rs.getString("ASS_ST_DT"));
				apprsl.setAss_ed_dt(rs.getString("ASS_ED_DT"));
				apprsl.setAss_st_km(rs.getString("ASS_ST_KM"));
				apprsl.setAss_ed_km(rs.getString("ASS_ED_KM"));
				apprsl.setAss_wrt(rs.getString("ASS_WRT"));
				apprsl.setAss_chk(rs.getString("ASS_CHK"));
				apprsl.setActn_wh(rs.getString("ACTN_WH"));
			}
			rs.close();
			pstmt.close();
		}catch(Exception e){
			System.out.println("[Offls_preDatabase:getPre_apprsl(String car_mng_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(pstmt != null) pstmt.close();
				if(rs != null) rs.close();
			}catch(Exception ex){}
			closeConnection();
			return apprsl;
		}
	}

	/**
	*	경매장 전체  - 2003.2.26.Wed.
	*	- 
	*/
	public Vector getActns(){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		try{
			pstmt = conn.prepareStatement("SELECT client_id, firm_nm FROM client WHERE client_st='6' AND client_id NOT IN ('003226','004242') ORDER BY firm_nm ");
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while(rs.next()){
				Hashtable ht = new Hashtable();
				for(int pos=1; pos<=rsmd.getColumnCount(); pos++){
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();
		}catch(Exception e){
			System.out.println("[Offls_preDatabase:getActns()]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return vt;
		}
	}

	/**
	*	경매장 연락처 - 2003.2.26.Wed.
	*	- 
	*/
	public Vector getTels(String id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		try{
			pstmt = conn.prepareStatement("SELECT client_id, seq, gubun, name, title, tel, mobile, fax FROM actn_tel WHERE client_id=? ORDER BY seq");
			pstmt.setString(1,id);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while(rs.next()){
				Hashtable ht = new Hashtable();
				for(int pos=1; pos<=rsmd.getColumnCount(); pos++){
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();
		}catch(Exception e){
			System.out.println("[Offls_preDatabase:getTels(String id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return vt;
		}
	}


	/**
	*	경매장 코드 가져오기 - 2003.2.27.Thu.
	*/
	public String getActn_id(String car_mng_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String actn_id = null;

		try{
			pstmt = conn.prepareStatement("SELECT actn_id FROM apprsl WHERE car_mng_id = ?");
			pstmt.setString(1,car_mng_id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				actn_id = rs.getString(1);
			}
			if(actn_id==null) actn_id="";
			rs.close();
			pstmt.close();

		}catch(Exception e){
			System.out.println("[Offls_preDatabase:getActn_id()]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return actn_id;
		}
	}



	/*
	*	경매장별 담당자 연락처 입력 - 2003.2.28.Fri.
	*/
	public int inActn_tel(Off_ls_pre_actn_tel tel){
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		int result = 0;
		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement("SELECT nvl(to_char(to_number(max(seq))+1),0) FROM actn_tel WHERE client_id=?");
			pstmt.setString(1,tel.getClient_id());
			rs = pstmt.executeQuery();
			while(rs.next()){
				tel.setSeq(rs.getString(1));
			}
			rs.close();
			pstmt.close();

			String seq = tel.getSeq();
			if(tel.getSeq().length()==1) tel.setSeq("0"+seq);

			pstmt2 = conn.prepareStatement("INSERT INTO actn_tel(client_id,seq,gubun,name,title,tel,mobile,fax) VALUES(?,?,?,?,?,?,?,?)");
			pstmt2.setString(1,tel.getClient_id());
			pstmt2.setString(2,tel.getSeq());
			pstmt2.setString(3,tel.getGubun());
			pstmt2.setString(4,tel.getName());
			pstmt2.setString(5,tel.getTitle());
			pstmt2.setString(6,tel.getTel());
			pstmt2.setString(7,tel.getMobile());
			pstmt2.setString(8,tel.getFax());
			result = pstmt2.executeUpdate();
			pstmt2.close();

			conn.commit();
		}catch(Exception e){
			System.out.println("[Offls_preDatabase:inActn_tel(Off_ls_pre_actn_tel tel)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
				if(pstmt2 != null) pstmt2.close();
			}catch(Exception ex){}
			closeConnection();
			return result;
		}
	}

	/*
	*	경매장별 담당자 연락처 수정 - 2003.2.28.Fri.
	*/
	public int upActn_tel(Off_ls_pre_actn_tel tel){
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement("UPDATE actn_tel SET gubun=?,name=?,title=?,tel=?,mobile=?,fax=? WHERE client_id=? AND seq=?");
			pstmt.setString(1,tel.getGubun());
			pstmt.setString(2,tel.getName());
			pstmt.setString(3,tel.getTitle());
			pstmt.setString(4,tel.getTel());
			pstmt.setString(5,tel.getMobile());
			pstmt.setString(6,tel.getFax());
			pstmt.setString(7,tel.getClient_id());
			pstmt.setString(8,tel.getSeq());
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		}catch(Exception e){
			System.out.println("[Offls_preDatabase:inActn_tel(Off_ls_pre_actn_tel tel)]"+e);
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

	/*
	*	경매장별 담당자 연락처 삭제 - 2003.3.3.Mon.
	*/
	public int delActn_tel(Off_ls_pre_actn_tel tel){
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		try{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement("DELETE actn_tel WHERE client_id=? AND seq=?");
			pstmt.setString(1,tel.getClient_id());
			pstmt.setString(2,tel.getSeq());
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
				
		}catch(Exception e){
			System.out.println("[Offls_preDatabase:delActn_tel(Off_ls_pre_actn_tel tel)]"+e);
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
	*	경매장별 구비서류 - 2003.3.3.Mon.
	*	- 
	*/
	public Vector getDocs(String id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		try{
			pstmt = conn.prepareStatement("SELECT client_id, seq, doc_nm FROM actn_doc WHERE client_id=? ORDER BY seq");
			pstmt.setString(1,id);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while(rs.next()){
				Hashtable ht = new Hashtable();
				for(int pos=1; pos<=rsmd.getColumnCount(); pos++){
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();
		}catch(Exception e){
			System.out.println("[Offls_preDatabase:getDocs(String id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return vt;
		}
	}


	/*
	*	경매장별 구비서류 입력 - 2003.3.3.Mon.
	*/
	public int inActn_doc(Off_ls_pre_actn_doc doc){
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		int result = 0;
		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement("SELECT nvl(to_char(to_number(max(seq))+1),0) FROM actn_doc WHERE client_id=?");
			pstmt.setString(1,doc.getClient_id());
			rs = pstmt.executeQuery();
			while(rs.next()){
				doc.setSeq(rs.getString(1));
			}
			rs.close();
			pstmt.close();

			String seq = doc.getSeq();
			if(doc.getSeq().length()==1) doc.setSeq("0"+seq);

			pstmt2 = conn.prepareStatement("INSERT INTO actn_doc(client_id,seq,doc_nm,doc_ck) VALUES(?,?,?,?)");
			pstmt2.setString(1,doc.getClient_id());
			pstmt2.setString(2,doc.getSeq());
			pstmt2.setString(3,doc.getDoc_nm());
			pstmt2.setString(4,doc.getDoc_ck());
			result = pstmt2.executeUpdate();
			pstmt2.close();

			conn.commit();
		}catch(Exception e){
			System.out.println("[Offls_preDatabase:inActn_doc(Off_ls_pre_actn_doc doc)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
				if(pstmt2 != null) pstmt2.close();
			}catch(Exception ex){}
			closeConnection();
			return result;
		}
	}

	/*
	*	경매장별 구비서류 수정 - 2003.3.3.Mon.
	*/
	public int upActn_doc(Off_ls_pre_actn_doc doc){
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement("UPDATE actn_doc SET doc_nm=?, doc_ck=? WHERE client_id=? AND seq=?");
			pstmt.setString(1,doc.getDoc_nm());
			pstmt.setString(2,doc.getDoc_ck());
			pstmt.setString(3,doc.getClient_id());
			pstmt.setString(4,doc.getSeq());
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		}catch(Exception e){
			System.out.println("[Offls_preDatabase:upActn_doc(Off_ls_pre_actn_doc doc)]"+e);
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

	/*
	*	경매장별 구비서류 삭제 - 2003.3.3.Mon.
	*/
	public int delActn_doc(Off_ls_pre_actn_doc doc){
		getConnection();
		PreparedStatement pstmt = null;

		int result = 0;
		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement("DELETE from actn_doc WHERE client_id=? AND seq=?");
			pstmt.setString(1,doc.getClient_id());
			pstmt.setString(2,doc.getSeq());
			result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		}catch(Exception e){
			System.out.println("[Offls_preDatabase:delActn_doc(Off_ls_pre_actn_doc doc)]"+e);
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

	/*
	*	경매장별 구비서류 입력2 - 2003.3.4.Tue.
	*/
	public int inActn_doc(String client_id, String[] docs){
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		int result = 0;
		try{
			conn.setAutoCommit(false);

			for(int i=0; i<docs.length; i++){
				if(docs[i].equals("")) continue;
				String seq = "";
				pstmt = conn.prepareStatement("SELECT nvl(to_char(to_number(max(seq))+1),0) FROM actn_doc WHERE client_id=?");
				pstmt.setString(1,client_id);
				rs = pstmt.executeQuery();
				while(rs.next()){
					seq = (rs.getString(1));
				}
				rs.close();
				pstmt.close();

				if(seq.length()==1) seq="0"+seq;

				pstmt2 = conn.prepareStatement("INSERT INTO actn_doc(client_id,seq,doc_nm) VALUES(?,?,?)");
				pstmt2.setString(1,client_id);
				pstmt2.setString(2,seq);
				pstmt2.setString(3,docs[i]);
				result = pstmt2.executeUpdate();
				pstmt2.close();
			}

			conn.commit();
		}catch(Exception e){
			System.out.println("[Offls_preDatabase:inActn_doc(String client_id, String[] doc)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
				if(pstmt2 != null) pstmt2.close();
			}catch(Exception ex){}
			closeConnection();
			return result;
		}
	}

	/*
	*	경매장별 담당자 입력2 - 2003.3.4.Tue.
	*/
	public int inActn_tel2(Off_ls_pre_actn_tel tel){
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement("INSERT INTO actn_tel(client_id,seq,gubun,name,title,tel,mobile,fax) VALUES(?,?,?,?,?,?,?,?)");
			pstmt.setString(1,tel.getClient_id());
			pstmt.setString(2,tel.getSeq());
			pstmt.setString(3,tel.getGubun());
			pstmt.setString(4,tel.getName());
			pstmt.setString(5,tel.getTitle());
			pstmt.setString(6,tel.getTel());
			pstmt.setString(7,tel.getMobile());
			pstmt.setString(8,tel.getFax());
			result = pstmt.executeUpdate();		
			pstmt.close();
			
			conn.commit();
		}catch(Exception e){
			System.out.println("[Offls_preDatabase:inActn_tel(Off_ls_pre_actn_tel tel)]"+e);
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
	*	상품평가 경매장 id 입력 - 2003.3.10.Mon.
	*	- 
	*/
	private int inApprsl(String car_mng_id, String actn_id){

		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement("insert into apprsl(car_mng_id, actn_id) values(?,?)");
			pstmt.setString(1,car_mng_id);
			pstmt.setString(2,actn_id);
			result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		}catch(SQLException e){
			System.out.println("[Offls_preDatabase:inApprsl(String car_mng_id, String actn_id)]"+e);
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
	*	상품평가 경매장 id 수정 - 2003.3.10.Mon.
	*	- 먼저 car_mng_id가 있으면 update하고, 아니면 inApprsl()호출해서 insert한다.
	*/
	public int upApprsl(String car_mng_id,  String actn_id){

		getConnection();
		int result = 0;
		PreparedStatement pstmt = null;
		try{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement("update apprsl set actn_id=? where car_mng_id = ?");
			pstmt.setString(1,actn_id);
			pstmt.setString(2,car_mng_id);
			result = pstmt.executeUpdate();
			pstmt.close();
			if(result != 1){
				result = this.inApprsl(car_mng_id, actn_id);
			}
			conn.commit();
		}catch(SQLException e){
			System.out.println("[Offls_preDatabase:upApprsl(String car_mng_id, String actn_id)]"+e);
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
	*	경매장 구비서류 체크입력 - 2003.3.11.Tue.
	*	- 
	*/
	public int doc_chk(String car_mng_id, String doc_chk){

		getConnection();
		int result = 0;
		PreparedStatement pstmt = null;
		try{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement("UPDATE apprsl SET doc_chk=? WHERE car_mng_id=? ");
			pstmt.setString(1,doc_chk);
			pstmt.setString(2,car_mng_id);
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		}catch(SQLException e){
			System.out.println("[Offls_preDatabase:doc_chk(String actn_id, String[] seq, String car_mng_id)]"+e);
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
	*	차량별 경매장 구비서류 체크2 - 2003.3.11.Tue.
	*	- 준비차량전체보기(off_ls_pre_sc_in.jsp)에서 확인하기 위해
	*/
	public boolean doc_chk2(String car_mng_id){

		getConnection();
		ResultSet rs = null;
		PreparedStatement pstmt = null;
		ResultSet rs2 = null;
		PreparedStatement pstmt2 = null;
		String client_id = "";
		boolean chk = false;

		try{
			pstmt = conn.prepareStatement("SELECT actn_id FROM apprsl WHERE car_mng_id=? ");
			pstmt.setString(1,car_mng_id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				client_id = rs.getString(1);
			}
			rs.close();
			pstmt.close();
			
			if(client_id.equals("")){
				chk = false;
			}else{
				pstmt2 = conn.prepareStatement("SELECT doc_ck FROM actn_doc WHERE client_id=? AND car_mng_id=? ");
				pstmt2.setString(1,client_id);
				pstmt2.setString(2,car_mng_id);
				rs2 = pstmt2.executeQuery();
				while(rs2.next()){
					if(rs2.getString(1).equals("Y")){
						System.out.println("8");
					}else{
						System.out.println("9");
						chk = false;
						break;
					}
				}
				rs2.close();
				pstmt2.close();

				chk = true;
			}
		}catch(SQLException e){
			System.out.println("[Offls_preDatabase:doc_chk2(String car_mng_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null)		rs.close();
				if(pstmt != null)	pstmt.close();
				if(rs2 != null)		rs2.close();
				if(pstmt2 != null)	pstmt2.close();
			}catch(Exception ex){}
			closeConnection();
			return chk;
		}
	}

	/**
	*	경매장 구비서류 완료,미비 여부 가져오기 - 2003.3.11.Tue.
	*	- 
	*/
	public String getDoc_chk(String car_mng_id){

		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String chk = "";
		try{
			pstmt = conn.prepareStatement("SELECT doc_chk FROM apprsl WHERE car_mng_id=?");
			pstmt.setString(1,car_mng_id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				chk = rs.getString(1);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_preDatabase:getDoc_chk(String car_mng_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return chk;
		}
	}

	/**
	*	경매장 구비서류 체크입력 - 2003.3.12.Wed.
	*	- 
	*/
	public int upDocChk(String car_mng_id, String doc_chk, String doc_seq){

		getConnection();
		int result = 0;
		PreparedStatement pstmt = null;
		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement("UPDATE apprsl SET doc_chk=?, doc_seq=? WHERE car_mng_id=?");
			pstmt.setString(1,doc_chk);
			pstmt.setString(2,doc_seq);
			pstmt.setString(3,car_mng_id);
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
		}catch(SQLException e){
			System.out.println("[Offls_preDatabase:doc_chk(String actn_id, String[] seq, String car_mng_id)]"+e);
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
	*	매각진행차량 경매관리 조회 - 2003.4.22.Tue.
	*	- choi_st = '2' 반출
	*/
	public String getCar_mng_id_ban(String car_mng_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String seq = "";

		query = "SELECT max(actn_cnt) FROM auction WHERE car_mng_id=? AND choi_st='2' ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				seq = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_preDatabase:getCar_mng_id_ban(String car_mng_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return seq;
		}		
	}

	/**
	*	엔카등록 데이터 가져오기 - 2003.8.19.Tue.
	*	- 
	*/
	public Off_ls_pre_encar getEncar(String car_mng_id){

		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Off_ls_pre_encar encar = new Off_ls_pre_encar();
		String query = "SELECT car_mng_id,encar_id,reg_dt,count,opt_value,d_car_amt,s_car_amt,e_car_amt,ea_car_amt,content,guar_no,day_car_amt,reg_id,upd_id,img_path "+
						" FROM encar WHERE car_mng_id=? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				encar.setCar_mng_id(rs.getString(1));
				encar.setEncar_id(rs.getString(2));
				encar.setReg_dt(rs.getString(3));
				encar.setCount(rs.getInt(4));
				encar.setOpt_value(rs.getString(5));
				encar.setD_car_amt(rs.getInt(6));
				encar.setS_car_amt(rs.getInt(7));
				encar.setE_car_amt(rs.getInt(8));
				encar.setEa_car_amt(rs.getInt(9));
				encar.setContent(rs.getString(10));
				encar.setGuar_no(rs.getString(11));
				encar.setDay_car_amt(rs.getInt(12));
				encar.setReg_id(rs.getString(13));
				encar.setUpd_id(rs.getString(14));
				encar.setImg_path(rs.getString(15));
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_preDatabase:getEncar(String car_mng_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return encar;
		}
	}

	/**
	*	엔카 데이터 입력 - 2003.8.19.Tue.
	*	- 
	*/
	public int insEncar(Off_ls_pre_encar encar){

		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query =  " INSERT INTO encar(car_mng_id, encar_id, reg_dt, count, opt_value,"+
						" d_car_amt, s_car_amt, e_car_amt, ea_car_amt, content,"+
						" guar_no, day_car_amt, reg_id, img_path) "+
						" VALUES ('"+encar.getCar_mng_id().trim()+"', '"+encar.getEncar_id().trim()+"',"+
						" replace('"+encar.getReg_dt().trim()+"','-',''), "+encar.getCount()+","+
						" '"+encar.getOpt_value().trim()+"', "+encar.getD_car_amt()+","+
						" "+encar.getS_car_amt()+", "+encar.getE_car_amt()+", "+encar.getEa_car_amt()+","+
						" '"+encar.getContent().trim()+"', '"+encar.getGuar_no().trim()+"',"+
						" "+encar.getDay_car_amt()+", '"+encar.getReg_id().trim()+"', '"+encar.getImg_path().trim()+"')";

		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		}catch(SQLException e){
			System.out.println("[Offls_preDatabase:insEncar(Off_ls_pre_encar encar)]"+e);
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
	*	엔카 데이터 수정 - 2003.8.20.Wed.
	*	- 
	*/
	public int updEncar(Off_ls_pre_encar encar){

		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = "UPDATE encar SET "+
						" encar_id='"+encar.getEncar_id().trim()+"',"+
						" reg_dt=replace('"+encar.getReg_dt().trim()+"','-',''),"+
						" count="+encar.getCount()+","+
						" opt_value='"+encar.getOpt_value().trim()+"', d_car_amt="+encar.getD_car_amt()+","+
						" s_car_amt="+encar.getS_car_amt()+", e_car_amt="+encar.getE_car_amt()+","+
						" ea_car_amt="+encar.getEa_car_amt()+", content='"+encar.getContent().trim()+"',"+
						" guar_no='"+encar.getGuar_no().trim()+"', day_car_amt="+encar.getDay_car_amt()+","+
						" upd_id='"+encar.getUpd_id().trim()+"', img_path='"+encar.getImg_path().trim()+"' "+
						" WHERE car_mng_id='"+encar.getCar_mng_id().trim()+"' ";

		try{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		}catch(SQLException e){
			System.out.println("[Offls_preDatabase:updEncar(Off_ls_pre_encar encar)]"+e);
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
	*	재리스 견적 데이터 가져오기 - 2004.4.16.
	*	- 
	*/
	public Off_ls_pre_release getRelease(String car_mng_id){

		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Off_ls_pre_release release = new Off_ls_pre_release();
		String query = "SELECT car_mng_id,fee24_s_amt,fee24_v_amt,fee36_s_amt,fee36_v_amt,gua_amt,pp_amt,reg_id,upd_id,mo24_amt,mo36_amt "+
						" FROM release WHERE car_mng_id=? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				release.setCar_mng_id(rs.getString(1));
				release.setFee24_s_amt(rs.getInt(2));
				release.setFee24_v_amt(rs.getInt(3));
				release.setFee36_s_amt(rs.getInt(4));
				release.setFee36_v_amt(rs.getInt(5));
				release.setGua_amt(rs.getInt(6));
				release.setPp_amt(rs.getInt(7));
				//release.setSt_amt(rs.getInt(8));
				release.setReg_id(rs.getString(8));
				release.setUpd_id(rs.getString(9));
				release.setMo24_amt(rs.getInt(10));
				release.setMo36_amt(rs.getInt(11));
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_preDatabase:getRelease(String car_mng_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return release;
		}
	}
	/**
	*	재리스 데이터 입력 - 2004.4.16.
	*	- 
	*/
	public int insRelease(Off_ls_pre_release release){

		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query =  " INSERT INTO release(car_mng_id, fee24_s_amt, fee24_v_amt, fee36_s_amt, fee36_v_amt, gua_amt, pp_amt, reg_id, mo24_amt, mo36_amt) "+
						" VALUES(?,?,?,?,?,?,?,?,?,?)";

		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,release.getCar_mng_id());
			pstmt.setInt(2,release.getFee24_s_amt());
			pstmt.setInt(3,release.getFee24_v_amt());
			pstmt.setInt(4,release.getFee36_s_amt());
			pstmt.setInt(5,release.getFee36_v_amt());
			pstmt.setInt(6,release.getGua_amt());
			pstmt.setInt(7,release.getPp_amt());
			//pstmt.setInt(8,release.getSt_amt());
			pstmt.setString(8,release.getReg_id());
			pstmt.setInt(9,release.getMo24_amt());
			pstmt.setInt(10,release.getMo36_amt());
			result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		}catch(SQLException e){
			System.out.println("[Offls_preDatabase:insRelease(Off_ls_pre_release release)]"+e);
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
	*	재리스 데이터 수정 - 2004.4.16.
	*	- 
	*/
	public int updRelease(Off_ls_pre_release release){

		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = "UPDATE release SET "+
						" fee24_s_amt=?, fee24_v_amt=?, fee36_s_amt=?, fee36_v_amt=?, gua_amt=?, pp_amt=?, upd_id=?, mo24_amt=?, mo36_amt=? "+
						" WHERE car_mng_id=? ";

		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setInt(1,release.getFee24_s_amt());
			pstmt.setInt(2,release.getFee24_v_amt());
			pstmt.setInt(3,release.getFee36_s_amt());
			pstmt.setInt(4,release.getFee36_v_amt());
			pstmt.setInt(5,release.getGua_amt());
			pstmt.setInt(6,release.getPp_amt());
			//pstmt.setInt(7,release.getSt_amt());
			pstmt.setString(7,release.getUpd_id());
			pstmt.setInt(8,release.getMo24_amt());
			pstmt.setInt(9,release.getMo36_amt());
			pstmt.setString(10,release.getCar_mng_id());

			result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		}catch(SQLException e){
			System.out.println("[Offls_preDatabase:updRelease(Off_ls_pre_release release)]"+e);
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
	*	매각결정현황에서 경매장 ID와 평가일자를 입력시킴.
	*	
	*/
	public int upApprsl2(String car_mng_id,  String actn_id, String modify_id){

		getConnection();
		int result = 0;
		PreparedStatement pstmt = null;
		try{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement("update apprsl set actn_id=?, apprsl_dt = to_char(sysdate,'YYYYMMDD'), doc_chk = 'Y', MODIFY_ID = '"+modify_id+"' where car_mng_id = ?");
			pstmt.setString(1,actn_id);
			pstmt.setString(2,car_mng_id);
			result = pstmt.executeUpdate();
			pstmt.close();
			if(result != 1){
				result = this.inApprsl(car_mng_id, actn_id);
			}
			conn.commit();
		}catch(SQLException e){
			System.out.println("[Offls_preDatabase:upApprsl2(String car_mng_id, String actn_id)]"+e);
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

//주행거리 입력.
	public int upApprslKM(String car_mng_id,  String km, String car_out_dt){

		getConnection();
		int result = 0;
		PreparedStatement pstmt = null;
		try{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement("update apprsl set km=replace(?,',',''), car_out_dt = replace(?,'-','') where car_mng_id = ?");
			pstmt.setString(1,km);
			pstmt.setString(2,car_out_dt);
			pstmt.setString(3,car_mng_id);
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		}catch(SQLException e){
			System.out.println("[Offls_preDatabase:upApprslKM()]"+e);
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


//출품현황 차량번호, 차명, 최초등록일만 팝업으로 띄우기 
public Hashtable getSearch_list(String car_mng_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		int count = 0;
		String query = "";

		query +=" SELECT r.car_no, r.CAR_NM, r.INIT_REG_DT, m.CAR_NAME , r.car_num , r.car_doc_no, r.car_ext , s.actn_id " +
				" FROM car_reg r, cont c, CAR_NM m, CAR_ETC e , apprsl s \n" +
				" WHERE r.car_mng_id = c.car_mng_id  AND c.rent_mng_id = e.rent_mng_id  AND c.rent_l_cd = e.rent_l_cd AND e.car_id = m.car_id  AND e.car_seq = m.car_seq \n" +
			    " AND r.car_mng_id = '"+car_mng_id+"' AND c.use_yn = 'Y' and r.car_mng_id = s.car_mng_id(+) ";


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery(); 
			ResultSetMetaData rsmd = rs.getMetaData();

			if(rs.next()){	
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[Offls_preDatabase:getSearch_list]"+e);
			System.out.println("[Offls_preDatabase:getSearch_list]"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )			rs.close();
                if(pstmt != null)		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}


	//매각결정차량리스트 예상낙찰가 가져오기
	public int getOffls_pre_o_s_amt(String car_mng_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int o_s_amt = 0;
		String query = "";

		query +=" SELECT NVL(max(c.accid_sik_j),0)*10000 AS o_s_amt "+
				" FROM   SECONDHAND a, ESTIMATE_SH b, ESTI_EXAM_SH c  "+
				" WHERE  a.car_mng_id='"+car_mng_id+"'  "+
				" AND a.seq = (select max(seq) from secondhand where car_mng_id=a.car_mng_id) "+
				" AND a.car_mng_id=b.mgr_nm AND a.apply_sh_dt=b.rent_dt AND b.est_id=c.est_id ";



		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery(); 

			if(rs.next()){	
				o_s_amt = rs.getInt("o_s_amt");
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[Offls_preDatabase:getOffls_pre_o_s_amt]"+e);
			System.out.println("[Offls_preDatabase:getOffls_pre_o_s_amt]"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )			rs.close();
                if(pstmt != null)		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return o_s_amt;
		}
	}





}