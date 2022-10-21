/**
 * 오프리스 매각완료 현황 정보
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2003. 05. 12. Mon.
 * @ last modify date : 
 */
package acar.offls_after;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;
import acar.exception.DatabaseException;
import acar.exception.DataSourceEmptyException;
import acar.common.*;
import acar.car_accident.*;
import acar.offls_actn.*;

public class Offls_afterDatabase
{
	private Connection conn = null;
	public static Offls_afterDatabase db;
	
	public static Offls_afterDatabase getInstance()
	{
		if(Offls_afterDatabase.db == null)
			Offls_afterDatabase.db = new Offls_afterDatabase();
		return Offls_afterDatabase.db;
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
	*	수의계약에서 사후관리로 2003.6.3.Tue.
	*	off_ls  = 0;보유차량, 1;매각준비차량, 2;매각소매(폐기), 3;매각경매차량, 4;매각수의, 5;경매처분현황, 6;사후관리
	*/
	public int setOffls_after(String[] after){
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = "UPDATE car_reg SET off_ls = '6' WHERE car_mng_id in ('";		


		for(int i=0 ; i<after.length ; i++){
			if(i == (after.length -1)){
				query += after[i];
			}else{
				query += after[i]+"', '";
			}
		}
		query+="')";

		try{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
		 }catch(Exception se){
           try{
				System.out.println("[Offls_afterDatabase:setOffls_after(String[] after)]"+se);
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
	*	다시 매각준비로 2003.2.12.Wed.
	*/
	public int cancelOffls_after(String[] after){
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = "update car_reg set off_ls = '1' where car_mng_id in ('";		
		
		for(int i=0 ; i<after.length ; i++){
			if(i == (after.length -1))	query += after[i];
			else						query += after[i]+"', '";
		}
		query+="')";

		try{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		
		 }catch(Exception se){
           try{
					System.out.println("[Offls_afterDatabase:cancelOffls_after(String[] after)]"+se);
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
	*	매각진행차량 Bean에 데이터 넣기 2003.05.12.Mon.
	*/
	 private Offls_afterBean makeOffls_afterBean(ResultSet results) throws DatabaseException {

        try {
            Offls_afterBean bean = new Offls_afterBean();

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
			bean.setCar_l_cd(results.getString("CAR_L_CD"));			//년도별차량등록순번
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
			bean.setDamdang_id(results.getString("DAMDANG_ID"));
			bean.setModify_id(results.getString("MODIFY_ID"));
			bean.setApprsl_dt(results.getString("APPRSL_DT"));
			bean.setCar_cha_yn(results.getString("CAR_CHA_YN"));
			bean.setCltr_amt(results.getInt("CLTR_AMT"));
			bean.setOff_ls(results.getString("OFF_LS"));	//구분(경매,소매,수의)
			bean.setActn_st(results.getString("ACTN_ST"));	//경매상태(출품,경매진행,최종유찰,개별상담,낙찰)
			bean.setActn_id(results.getString("ACTN_ID"));
			bean.setSui_nm(results.getString("SUI_NM"));
			bean.setMm_pr(results.getInt("MM_PR"));
			bean.setCont_dt(results.getString("CONT_DT"));
			bean.setAss_ed_dt_actn(results.getString("ASS_ED_DT_ACTN"));
			bean.setAss_ed_dt_sui(results.getString("ASS_ED_DT_SUI"));
			bean.setIns_com_nm(results.getString("INS_COM_NM"));
			bean.setIns_exp_dt(results.getString("INS_EXP_DT"));
			bean.setCls_man_st(results.getString("CLS_MAN_ST"));
			bean.setTax_st(results.getString("TAX_ST"));
			bean.setReq_dt(results.getString("REQ_DT"));

		return bean;

        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}

	/**
	*	매각진행차량 상세정보 2003.2.12.Wed.
	*/
	public Offls_afterBean getAfter_detail(String car_mng_id){
		getConnection();
		Offls_afterBean detail = new Offls_afterBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = "select	r.car_mng_id CAR_MNG_ID, r.car_no CAR_NO, cg.car_no	CAR_PRE_NO,	cgg.cha_dt CHA_DT, r.car_num CAR_NUM, r.init_reg_dt	INIT_REG_DT, r.car_kd CAR_KD, r.car_use	CAR_USE, n.car_nm CAR_JNM, m.car_name CAR_NM, r.car_form CAR_FORM, r.car_y_form	CAR_Y_FORM,	r.dpm			DPM,	r.fuel_kd		FUEL_KD,	r.maint_st_dt	MAINT_ST_DT,	r.maint_end_dt	MAINT_END_DT, r.test_st_dt TEST_ST_DT, r.test_end_dt TEST_END_DT, r.car_l_cd CAR_L_CD, e.rent_mng_id	RENT_MNG_ID,	e.rent_l_cd		RENT_L_CD,	e.car_id		CAR_ID,	e.colo			COLO,	e.opt			OPT, e.lpg_yn LPG_YN,e.car_cs_amt	CAR_CS_AMT,	e.car_cv_amt	CAR_CV_AMT,	e.car_fs_amt	CAR_FS_AMT,	e.car_fv_amt	CAR_FV_AMT,	e.opt_cs_amt	OPT_CS_AMT,	e.opt_cv_amt	OPT_CV_AMT,	e.opt_fs_amt	OPT_FS_AMT,	e.opt_fv_amt	OPT_FV_AMT,	e.clr_cs_amt	CLR_CS_AMT,	e.clr_cv_amt	CLR_CV_AMT,	e.clr_fs_amt	CLR_FS_AMT,	e.clr_fv_amt	CLR_FV_AMT,	e.sd_cs_amt		SD_CS_AMT,	e.sd_cv_amt		SD_CV_AMT,	e.sd_fs_amt		SD_FS_AMT,	e.sd_fv_amt		SD_FV_AMT,	e.dc_cs_amt		DC_CS_AMT,	e.dc_cv_amt		DC_CV_AMT,	e.dc_fs_amt		DC_FS_AMT,	e.dc_fv_amt		DC_FV_AMT, c.mng_id		MNG_ID,	c.dlv_dt DLV_DT, decode(r.car_mng_id, sq.car_mng_id, 1, 0) ACCIDENT_YN, "+
			" vt.tot_dist TOT_DIST, "+
			" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD'))))) as AVERAGE_DIST, "+
			" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST, "+
			" bk.bank_nm BANK_NM, bk.lend_prn LEND_PRN, sw.alt_rest	LEND_REM, bk.alt_end_dt ALT_END_DT, s.lev LEV, s.reason REASON, s.car_st CAR_ST,s.imgfile1 IMGFILE1, s.imgfile2 IMGFILE2, s.imgfile3 IMGFILE3, s.imgfile4 IMGFILE4, s.imgfile5 IMGFILE5, "+
			" s.km, uc.damdang_id DETERM_ID, uc.hp_pr HPPR, uc.st_pr STPR, s.damdang_id DAMDANG_ID, s.modify_id MODIFY_ID, s.apprsl_dt APPRSL_DT, DECODE(r.car_mng_id, ch.car_mng_id, 1, 0) CAR_CHA_YN, t.cltr_amt CLTR_AMT, r.off_ls OFF_LS, uc.actn_st ACTN_ST, s.actn_id ACTN_ID "+
			", u.sui_nm SUI_NM, u.mm_pr MM_PR, u.cont_dt CONT_DT,  s.ass_ed_dt ASS_ED_DT_ACTN, u.ass_ed_dt ASS_ED_DT_SUI "+
			", iu.ins_com_nm INS_COM_NM, iu.ins_exp_dt INS_EXP_DT, x.cls_man_st CLS_MAN_ST, x.tax_st TAX_ST, ic.req_dt REQ_DT,  uc.actn_dt ACTN_DT "+
			" from car_reg r, car_etc e, cont c, apprsl s, cltr t,  CAR_NM m, CAR_MNG n, v_tot_dist vt, sui u, car_tax x, "+
			"	(select distinct ac.car_mng_id CAR_MNG_ID from accident ac, car_reg re where ac.car_mng_id=re.car_mng_id) sq, "+
			"	(select a.car_mng_id CAR_MNG_ID, a.serv_dt SERV_DT, a.tot_dist TOT_DIST  from service a where a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where car_mng_id = a.car_mng_id)) i, "+
			"	(select al.rent_mng_id RENT_MNG_ID, al.rent_l_cd RENT_L_CD, cd.nm BANK_NM , al.lend_prn LEND_PRN, al.alt_end_dt ALT_END_DT from allot al, code cd where al.cpt_cd = cd.code and cd.c_st = '0003') bk, "+
			"	(SELECT DISTINCT cc.car_mng_id CAR_MNG_ID FROM car_cha cc, car_reg re WHERE cc.car_mng_id = re.car_mng_id) ch, "+
			"	(SELECT sc.car_mng_id CAR_MNG_ID, sc.alt_rest ALT_REST FROM scd_alt_case sc WHERE sc.alt_tm = (select max(alt_tm) from scd_alt_case where car_mng_id = sc.car_mng_id)) sw, "+
			"	(SELECT car_mng_id, cha_dt, car_no FROM car_change a WHERE a.cha_seq = to_char(to_number((select max(b.cha_seq) from car_change b where a.car_mng_id = b.car_mng_id))-1)) cg "+
			",	(SELECT car_mng_id, cha_dt, car_no FROM car_change a WHERE a.cha_seq = to_char(to_number((select max(b.cha_seq) from car_change b where a.car_mng_id = b.car_mng_id and b.cha_seq>1)))) cgg "+
			",	(SELECT a.car_mng_id CAR_MNG_ID, a.seq SEQ, a.actn_st ACTN_ST, a.actn_dt ACTN_DT, a.damdang_id DAMDANG_ID, a.hp_pr HP_PR, a.st_pr ST_PR FROM auction a WHERE a.seq = (select max(seq) from auction where car_mng_id = a.car_mng_id)) uc "+
			", (select ir.car_mng_id CAR_MNG_ID, ic.ins_com_nm INS_COM_NM, ir.ins_exp_dt INS_EXP_DT from insur ir, ins_com ic where ir.ins_com_id = ic.ins_com_id and ir.ins_st = (select max(to_number(ins_st)) from insur where car_mng_id = ir.car_mng_id)) iu "+
			", (select car_mng_id, req_dt from ins_cls ) ic "+			
			" where r.car_mng_id = c.car_mng_id "+
			"  and e.rent_mng_id = c.rent_mng_id "+
			"  and e.rent_l_cd = c.rent_l_cd "+
			"  and r.car_mng_id = sq.car_mng_id(+) "+
			//"  and c.car_st = '2' "+
			"  and c.use_yn = 'N' "+
			//"  and r.off_ls = '6' "+
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
			"  AND e.car_id = m.car_id "+	
			"  and e.car_seq = m.car_seq "+
			"  and m.car_comp_id = n.car_comp_id "+
			"  and m.car_cd = n.code "+
			"  and r.car_mng_id = vt.car_mng_id(+) "+
			"  and r.car_mng_id = uc.car_mng_id(+) "+
			"  AND r.car_mng_id = u.car_mng_id(+) "+
			"  and r.car_mng_id = iu.car_mng_id(+) "+
			"  AND c.car_mng_id = x.car_mng_id(+) "+
			"  AND c.car_mng_id = ic.car_mng_id(+) "+
			"  and r.car_mng_id = '"+car_mng_id+"'";

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while(rs.next()){
				detail = makeOffls_afterBean(rs);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_afterDatabase:getAfter_detail(String car_mng_id)]"+e);
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
	*	회사별 매각차량사후관리 통계 - 2003.05.12.Mon.
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
"from car_reg C, cont t, car_etc e, car_nm n, code d, cls_cont l "+//, auction o    "+ 
"where c.car_mng_id = t.car_mng_id     "+
"and t.rent_mng_id = e.rent_mng_id     "+
"and t.rent_l_cd = e.rent_l_cd     "+
"and t.rent_mng_id = l.rent_mng_id "+
"and t.rent_l_cd = l.rent_l_cd "+
"and  t.car_st='2'     "+
"and  t.use_yn='N' "+
"and t.brch_id like '"+brch_id+"'    "+
"and c.off_ls = '6' "+//and c.car_mng_id = o.car_mng_id  "+
"and e.car_id = n.car_id     "+
"and n.car_comp_id = '0001'     "+
"and n.car_comp_id = d.code     "+
"and d.c_st = '0001') hd,     "+
"(select nvl(sum(decode(C.car_kd, '1', 1, 0)),0) c1, nvl(sum(decode(C.car_kd, '2', 1, 0)),0) c2, nvl(sum(decode(C.car_kd, '3', 1, '9', 1, 0)),0) c3, nvl(sum(decode(C.car_kd, '4', 1, 0)),0) c4, nvl(sum(decode(C.car_kd, '5', 1, 0)),0) c5, nvl(sum(decode(C.car_kd, '6', 1, 0)),0) c6, nvl(sum(decode(C.car_kd, '7', 1, 0)),0) c7 "+
"from car_reg C, cont t, car_etc e, car_nm n, code d, cls_cont l "+//, auction o   "+  
"where c.car_mng_id = t.car_mng_id    "+ 
"and t.rent_mng_id = e.rent_mng_id    "+ 
"and t.rent_l_cd = e.rent_l_cd   "+  
"and t.rent_mng_id = l.rent_mng_id "+
"and t.rent_l_cd = l.rent_l_cd "+
"and  t.car_st='2'     "+
"and  t.use_yn='N' "+
"and t.brch_id like '"+brch_id+"'    "+
"and c.off_ls = '6' "+//and c.car_mng_id = o.car_mng_id  "+
"and e.car_id = n.car_id     "+
"and n.car_comp_id = '0002'     "+
"and n.car_comp_id = d.code     "+
"and d.c_st = '0001') kia,     "+
"(select nvl(sum(decode(C.car_kd, '1', 1, 0)),0) c1, nvl(sum(decode(C.car_kd, '2', 1, 0)),0) c2, nvl(sum(decode(C.car_kd, '3', 1, '9', 1, 0)),0) c3, nvl(sum(decode(C.car_kd, '4', 1, 0)),0) c4, nvl(sum(decode(C.car_kd, '5', 1, 0)),0) c5, nvl(sum(decode(C.car_kd, '6', 1, 0)),0) c6, nvl(sum(decode(C.car_kd, '7', 1, 0)),0) c7 "+
"from car_reg C, cont t, car_etc e, car_nm n, code d, cls_cont l "+//, auction o     "+
"where c.car_mng_id = t.car_mng_id   "+  
"and t.rent_mng_id = e.rent_mng_id     "+
"and t.rent_l_cd = e.rent_l_cd  "+ 
"and t.rent_mng_id = l.rent_mng_id "+
"and t.rent_l_cd = l.rent_l_cd "+	
"and  t.car_st='2'     "+
"and  t.use_yn='N' "+
"and t.brch_id like '"+brch_id+"'    "+
"and c.off_ls = '6' "+//and c.car_mng_id = o.car_mng_id  "+
"and e.car_id = n.car_id     "+
"and n.car_comp_id = '0003'     "+
"and n.car_comp_id = d.code     "+
"and d.c_st = '0001') sam,     "+
"(select nvl(sum(decode(C.car_kd, '1', 1, 0)),0) c1, nvl(sum(decode(C.car_kd, '2', 1, 0)),0) c2, nvl(sum(decode(C.car_kd, '3', 1, '9', 1, 0)),0) c3, nvl(sum(decode(C.car_kd, '4', 1, 0)),0) c4, nvl(sum(decode(C.car_kd, '5', 1, 0)),0) c5, nvl(sum(decode(C.car_kd, '6', 1, 0)),0) c6, nvl(sum(decode(C.car_kd, '7', 1, 0)),0) c7 "+
"from car_reg C, cont t, car_etc e, car_nm n, code d, cls_cont l "+//, auction o     "+
"where c.car_mng_id = t.car_mng_id     "+
"and t.rent_mng_id = e.rent_mng_id   "+  
"and t.rent_l_cd = e.rent_l_cd     "+
"and t.rent_mng_id = l.rent_mng_id "+
"and t.rent_l_cd = l.rent_l_cd "+
"and  t.car_st='2'     "+
"and  t.use_yn='N' "+
"and t.brch_id like '"+brch_id+"'    "+
"and c.off_ls = '6' "+//and c.car_mng_id = o.car_mng_id  "+
"and e.car_id = n.car_id     "+
"and n.car_comp_id in ('0004','0005')     "+
"and n.car_comp_id = d.code     "+
"and d.c_st = '0001') ds,     "+
"(select nvl(sum(decode(C.car_kd, '1', 1, 0)),0) c1, nvl(sum(decode(C.car_kd, '2', 1, 0)),0) c2, nvl(sum(decode(C.car_kd, '3', 1, '9', 1, 0)),0) c3, nvl(sum(decode(C.car_kd, '4', 1, 0)),0) c4, nvl(sum(decode(C.car_kd, '5', 1, 0)),0) c5, nvl(sum(decode(C.car_kd, '6', 1, 0)),0) c6, nvl(sum(decode(C.car_kd, '7', 1, 0)),0) c7 "+
"from car_reg C, cont t, car_etc e, car_nm n, code d, cls_cont l "+//, auction o     "+
"where c.car_mng_id = t.car_mng_id   "+  
"and t.rent_mng_id = e.rent_mng_id  "+   
"and t.rent_l_cd = e.rent_l_cd     "+
"and t.rent_mng_id = l.rent_mng_id "+
"and t.rent_l_cd = l.rent_l_cd "+
"and  t.car_st='2'    "+ 
"and  t.use_yn='N' "+
"and t.brch_id like '"+brch_id+"'    "+
"and c.off_ls = '6' "+
"and e.car_id = n.car_id     "+
"and n.car_comp_id > '0005'    "+
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
				System.out.println("[Offls_afterDatabase:getTg()]"+e);
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
	*	매각진행차량 검색 - 2003.05.12.Mon.
	*	- gubun : 차량번호, 차량명, 최초등록일
	*	- gubun_nm : 해당 데이타
	*/
	public Offls_afterBean[] getAfter_lst(String gubun, String gubun_nm,String brch_id, String migr_dt, String st_dt, String end_dt, String car_st, String com_id, String car_cd, String dt, String ref_dt1, String ref_dt2, String gubun2){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String subQuery = "";
		String subQuery2 = "";
		String dt_query = "";  
	
					
		String s_dt2 = "to_char(sysdate,'YYYYMM')";
		String s_dt3 = "between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')";

		if(dt.equals("2"))								dt_query = "and uc.actn_dt like "+s_dt2+"||'%' \n";
		else if(dt.equals("3") && !ref_dt1.equals(""))	dt_query = "and uc.actn_dt "+s_dt3+"\n";
		
		//검색항목
		if(gubun.equals("car_no")){
			subQuery = " and r.car_no||' '||r.first_car_no like  '%" + gubun_nm + "%'";
		}else if(gubun.equals("init_reg_dt")){
			subQuery = " and r.init_reg_dt like '"+ gubun_nm +"%'";
		}else if(gubun.equals("sui_nm")){
			subQuery = " and u.sui_nm like '%" + gubun_nm + "%' ";
		}

		//영업소코드
		if(!brch_id.equals(""))				subQuery += " and c.brch_id='"+brch_id+"'";
		
		//명의이전일
		if(migr_dt.equals("1")){
			subQuery += " and u.migr_dt between '"+st_dt+"' and '"+end_dt+"' ";
		}else if(migr_dt.equals("2")){
			subQuery += " and u.migr_dt like to_char(sysdate,'yyyymm')||'%' ";
		}else if(migr_dt.equals("3")){
			subQuery += " and u.migr_dt like to_char(sysdate,'yyyy')||'%' ";
		}

		//렌트,리스
		if(car_st.equals("1"))				subQuery += " and  r.car_use='1' ";
		else if(car_st.equals("3"))			subQuery += " and  r.car_use='2' ";


		//제조사, 차종
		if(!com_id.equals(""))				subQuery += " and n.car_comp_id = '"+com_id+"'";
		if(car_cd!=null){
			if(!car_cd.equals(""))			subQuery += " and n.car_comp_id ='"+com_id+"' and n.code = '"+car_cd+"'";
		}

		if(gubun.equals("car_no")){
		query = "select	r.car_mng_id CAR_MNG_ID, r.car_no CAR_NO, r.first_car_no	CAR_PRE_NO,	cg.cha_dt CHA_DT, r.car_num CAR_NUM, r.init_reg_dt	INIT_REG_DT, r.car_kd CAR_KD, r.car_use	CAR_USE, n.car_nm CAR_JNM, m.car_name CAR_NM, r.car_form CAR_FORM, r.car_y_form	CAR_Y_FORM,	r.dpm			DPM,	r.fuel_kd		FUEL_KD,	r.maint_st_dt	MAINT_ST_DT,	r.maint_end_dt	MAINT_END_DT, r.test_st_dt TEST_ST_DT, r.test_end_dt TEST_END_DT, r.car_l_cd CAR_L_CD, e.rent_mng_id	RENT_MNG_ID,	e.rent_l_cd		RENT_L_CD,	e.car_id		CAR_ID,	e.colo			COLO, e.opt			OPT, e.lpg_yn LPG_YN,	e.car_cs_amt	CAR_CS_AMT,	e.car_cv_amt	CAR_CV_AMT,	e.car_fs_amt	CAR_FS_AMT,	e.car_fv_amt	CAR_FV_AMT,	e.opt_cs_amt	OPT_CS_AMT,	e.opt_cv_amt	OPT_CV_AMT,	e.opt_fs_amt	OPT_FS_AMT,	e.opt_fv_amt	OPT_FV_AMT,	e.clr_cs_amt	CLR_CS_AMT,	e.clr_cv_amt	CLR_CV_AMT,	e.clr_fs_amt	CLR_FS_AMT,	e.clr_fv_amt	CLR_FV_AMT,	e.sd_cs_amt		SD_CS_AMT,	e.sd_cv_amt		SD_CV_AMT,	e.sd_fs_amt		SD_FS_AMT,	e.sd_fv_amt		SD_FV_AMT,	e.dc_cs_amt		DC_CS_AMT,	e.dc_cv_amt		DC_CV_AMT,	e.dc_fs_amt		DC_FS_AMT,	e.dc_fv_amt		DC_FV_AMT, c.mng_id		MNG_ID, c.dlv_dt DLV_DT,	decode(r.car_mng_id, sq.car_mng_id, 1, 0) ACCIDENT_YN, "+
			" vt.tot_dist TOT_DIST, \n"+
			" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD'))))) as AVERAGE_DIST, \n"+
			" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST, \n"+
			" bk.bank_nm BANK_NM, bk.lend_prn LEND_PRN, sw.alt_rest	LEND_REM, bk.alt_end_dt ALT_END_DT, s.lev LEV, s.reason REASON, s.car_st CAR_ST, s.imgfile1 IMGFILE1, s.imgfile2 IMGFILE2, s.imgfile3 IMGFILE3, s.imgfile4 IMGFILE4, s.imgfile5 IMGFILE5, \n"+
			" s.km, uc.damdang_id DETERM_ID, uc.hp_pr HPPR, uc.st_pr STPR, s.damdang_id DAMDANG_ID, s.modify_id MODIFY_ID, s.apprsl_dt APPRSL_DT, DECODE(r.car_mng_id, ch.car_mng_id, 1, 0) CAR_CHA_YN, t.cltr_amt CLTR_AMT, r.off_ls OFF_LS, uc.actn_st ACTN_ST, s.actn_id ACTN_ID \n"+
			", u.sui_nm SUI_NM, u.mm_pr MM_PR, u.cont_dt CONT_DT,  s.ass_ed_dt ASS_ED_DT_ACTN, u.ass_ed_dt ASS_ED_DT_SUI \n"+
			", iu.ins_com_nm INS_COM_NM, iu.ins_exp_dt INS_EXP_DT, x.cls_man_st CLS_MAN_ST, x.tax_st TAX_ST, ic.req_dt REQ_DT, uc.actn_dt ACTN_DT  \n"+
			" from car_reg r,car_etc e, cont c, apprsl s, cltr t,  CAR_NM m, CAR_MNG n, v_tot_dist vt, sui u, cls_cont l, car_tax x, \n"+
			"	(select distinct ac.car_mng_id CAR_MNG_ID from accident ac, car_reg re where ac.car_mng_id=re.car_mng_id) sq, \n"+
			"	(select a.car_mng_id CAR_MNG_ID, a.serv_dt SERV_DT, a.tot_dist TOT_DIST  from service a where a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where car_mng_id = a.car_mng_id)) i, \n"+
			"	(select al.rent_mng_id RENT_MNG_ID, al.rent_l_cd RENT_L_CD, cd.nm BANK_NM, al.lend_prn LEND_PRN, al.alt_end_dt ALT_END_DT from allot al, code cd where al.cpt_cd = cd.code and cd.c_st = '0003') bk, \n"+
			"	(SELECT DISTINCT cc.car_mng_id CAR_MNG_ID FROM car_cha cc, car_reg re WHERE cc.car_mng_id = re.car_mng_id) ch, \n"+
			"	(SELECT sc.car_mng_id CAR_MNG_ID, sc.alt_rest ALT_REST FROM scd_alt_case sc WHERE sc.alt_tm = (select max(alt_tm) from scd_alt_case where car_mng_id = sc.car_mng_id)) sw, \n"+
			"	(SELECT car_mng_id, cha_dt, car_no FROM car_change a WHERE a.cha_seq = to_char(to_number((select max(b.cha_seq) from car_change b where a.car_mng_id = b.car_mng_id))-1)) cg, \n"+
			"	(SELECT a.car_mng_id CAR_MNG_ID, a.seq SEQ, a.actn_st ACTN_ST, a.actn_dt ACTN_DT, a.damdang_id DAMDANG_ID, a.hp_pr HP_PR, a.st_pr ST_PR FROM auction a WHERE a.seq = (select max(seq) from auction where car_mng_id = a.car_mng_id)) uc, \n"+
			"   (select ir.car_mng_id CAR_MNG_ID, ic.ins_com_nm INS_COM_NM, ir.ins_exp_dt INS_EXP_DT from insur ir, ins_com ic where ir.ins_com_id = ic.ins_com_id and ir.ins_st = (select max(to_number(ins_st)) from insur where car_mng_id = ir.car_mng_id)) iu, \n"+
			"   (select a.car_mng_id, a.ins_st, a.exp_dt, a.req_dt, b.migr_dt from ins_cls a, sui b where a.car_mng_id=b.car_mng_id and a.exp_dt=b.migr_dt ) ic \n"+
			" where r.car_mng_id = c.car_mng_id "+
			"  and e.rent_mng_id = c.rent_mng_id "+
			"  and e.rent_l_cd = c.rent_l_cd "+
			"  and r.car_mng_id = sq.car_mng_id(+) \n"+
			"  and c.car_st = '2' "+
			"  and c.use_yn = 'N' "+
			"  and r.off_ls = '6' "+
			"  and l.cls_st = '6' \n"+ //해지사유가 매각
			"  and r.car_mng_id = i.car_mng_id(+) "+
			"  and c.rent_mng_id = bk.rent_mng_id(+) "+
			"  and c.rent_l_cd = bk.rent_l_cd(+) "+
			"  and r.car_mng_id = s.car_mng_id(+) "+
			"  and r.car_mng_id = ch.car_mng_id(+) \n"+
			"  AND r.car_mng_id = sw.car_mng_id(+) "+
			"  AND c.rent_mng_id = t.rent_mng_id(+) "+
			"  AND c.rent_l_cd = t.rent_l_cd(+) "+
			"  AND r.car_mng_id = cg.car_mng_id(+) \n"+
			"  AND e.car_id = m.car_id "+	
			"  and e.car_seq = m.car_seq "+
			"  and m.car_comp_id = n.car_comp_id "+
			"  and m.car_cd = n.code "+
			"  and r.car_mng_id = vt.car_mng_id(+)\n "+
			"  and r.car_mng_id = uc.car_mng_id(+)\n "+
			dt_query + 	
			"  AND r.car_mng_id = u.car_mng_id(+) "+
			"  and r.car_mng_id = iu.car_mng_id(+) "+
			"  AND c.rent_mng_id = l.rent_mng_id "+
			"  AND c.rent_l_cd = l.rent_l_cd \n"+
	//		"  AND r.car_mng_id = ca.car_mng_id(+) "+
			"  AND c.car_mng_id = x.car_mng_id(+) "+
			"  AND c.car_mng_id = ic.car_mng_id(+) "+
			subQuery+
			"  ORDER BY cont_dt desc";
		}else{
			query = "select	r.car_mng_id CAR_MNG_ID, r.car_no CAR_NO, r.first_car_no	CAR_PRE_NO,	cg.cha_dt CHA_DT, r.car_num CAR_NUM, r.init_reg_dt	INIT_REG_DT, r.car_kd CAR_KD, r.car_use	CAR_USE, n.car_nm CAR_JNM, m.car_name CAR_NM, r.car_form CAR_FORM, r.car_y_form	CAR_Y_FORM,	r.dpm			DPM,	r.fuel_kd		FUEL_KD,	r.maint_st_dt	MAINT_ST_DT,	r.maint_end_dt	MAINT_END_DT, r.test_st_dt TEST_ST_DT, r.test_end_dt TEST_END_DT, r.car_l_cd CAR_L_CD, e.rent_mng_id	RENT_MNG_ID,	e.rent_l_cd		RENT_L_CD,	e.car_id		CAR_ID,	e.colo			COLO, e.opt			OPT, e.lpg_yn LPG_YN,	e.car_cs_amt	CAR_CS_AMT,	e.car_cv_amt	CAR_CV_AMT,	e.car_fs_amt	CAR_FS_AMT,	e.car_fv_amt	CAR_FV_AMT,	e.opt_cs_amt	OPT_CS_AMT,	e.opt_cv_amt	OPT_CV_AMT,	e.opt_fs_amt	OPT_FS_AMT,	e.opt_fv_amt	OPT_FV_AMT,	e.clr_cs_amt	CLR_CS_AMT,	e.clr_cv_amt	CLR_CV_AMT,	e.clr_fs_amt	CLR_FS_AMT,	e.clr_fv_amt	CLR_FV_AMT,	e.sd_cs_amt		SD_CS_AMT,	e.sd_cv_amt		SD_CV_AMT,	e.sd_fs_amt		SD_FS_AMT,	e.sd_fv_amt		SD_FV_AMT,	e.dc_cs_amt		DC_CS_AMT,	e.dc_cv_amt		DC_CV_AMT,	e.dc_fs_amt		DC_FS_AMT,	e.dc_fv_amt		DC_FV_AMT, c.mng_id		MNG_ID, c.dlv_dt DLV_DT,	decode(r.car_mng_id, sq.car_mng_id, 1, 0) ACCIDENT_YN, "+
			" vt.tot_dist TOT_DIST, \n"+
			" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD'))))) as AVERAGE_DIST,  \n"+
			" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST,  \n"+
			" bk.bank_nm BANK_NM, bk.lend_prn LEND_PRN, sw.alt_rest	LEND_REM, bk.alt_end_dt ALT_END_DT, s.lev LEV, s.reason REASON, s.car_st CAR_ST, s.imgfile1 IMGFILE1, s.imgfile2 IMGFILE2, s.imgfile3 IMGFILE3, s.imgfile4 IMGFILE4, s.imgfile5 IMGFILE5,  \n"+
			" s.km, uc.damdang_id DETERM_ID, uc.hp_pr HPPR, uc.st_pr STPR, s.damdang_id DAMDANG_ID, s.modify_id MODIFY_ID, s.apprsl_dt APPRSL_DT, DECODE(r.car_mng_id, ch.car_mng_id, 1, 0) CAR_CHA_YN, t.cltr_amt CLTR_AMT, r.off_ls OFF_LS, uc.actn_st ACTN_ST, s.actn_id ACTN_ID  \n"+
			", u.sui_nm SUI_NM, u.mm_pr MM_PR, u.cont_dt CONT_DT,  s.ass_ed_dt ASS_ED_DT_ACTN, u.ass_ed_dt ASS_ED_DT_SUI  \n"+
			", iu.ins_com_nm INS_COM_NM, iu.ins_exp_dt INS_EXP_DT, x.cls_man_st CLS_MAN_ST, x.tax_st TAX_ST, ic.req_dt REQ_DT,uc.actn_dt ACTN_DT   \n"+
			" from car_reg r,car_etc e, cont c, apprsl s, cltr t,  CAR_NM m, CAR_MNG n, v_tot_dist vt, sui u, cls_cont l, car_tax x,  \n"+
			"	(select distinct ac.car_mng_id CAR_MNG_ID from accident ac, car_reg re where ac.car_mng_id=re.car_mng_id) sq,  \n"+
			"	(select a.car_mng_id CAR_MNG_ID, a.serv_dt SERV_DT, a.tot_dist TOT_DIST  from service a where a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where car_mng_id = a.car_mng_id)) i,  \n"+
			"	(select al.rent_mng_id RENT_MNG_ID, al.rent_l_cd RENT_L_CD, cd.nm BANK_NM, al.lend_prn LEND_PRN, al.alt_end_dt ALT_END_DT from allot al, code cd where al.cpt_cd = cd.code and cd.c_st = '0003') bk, \n"+
			"	(SELECT DISTINCT cc.car_mng_id CAR_MNG_ID FROM car_cha cc, car_reg re WHERE cc.car_mng_id = re.car_mng_id) ch, \n"+
			"	(SELECT sc.car_mng_id CAR_MNG_ID, sc.alt_rest ALT_REST FROM scd_alt_case sc WHERE sc.alt_tm = (select max(alt_tm) from scd_alt_case where car_mng_id = sc.car_mng_id)) sw, \n"+
			"	(SELECT car_mng_id, cha_dt, car_no FROM car_change a WHERE a.cha_seq = to_char(to_number((select max(b.cha_seq) from car_change b where a.car_mng_id = b.car_mng_id))-1)) cg, \n"+
			"	(SELECT a.car_mng_id CAR_MNG_ID, a.seq SEQ, a.actn_st ACTN_ST, a.actn_dt ACTN_DT, a.damdang_id DAMDANG_ID, a.hp_pr HP_PR, a.st_pr ST_PR FROM auction a WHERE a.seq = (select max(seq) from auction where car_mng_id = a.car_mng_id)) uc \n"+
			", (select ir.car_mng_id CAR_MNG_ID, ic.ins_com_nm INS_COM_NM, ir.ins_exp_dt INS_EXP_DT from insur ir, ins_com ic where ir.ins_com_id = ic.ins_com_id and ir.ins_st = (select max(to_number(ins_st)) from insur where car_mng_id = ir.car_mng_id)) iu \n"+
			", (select a.car_mng_id, a.ins_st, a.exp_dt, a.req_dt, b.migr_dt from ins_cls a, sui b where a.car_mng_id=b.car_mng_id and a.exp_dt=b.migr_dt ) ic \n "+
			" where r.car_mng_id = c.car_mng_id "+
			"  and e.rent_mng_id = c.rent_mng_id "+
			"  and e.rent_l_cd = c.rent_l_cd "+
			"  and r.car_mng_id = sq.car_mng_id(+) \n"+
			"  and c.car_st = '2' "+
			"  and c.use_yn = 'N' "+
			"  and r.off_ls = '6' \n"+
			"  and l.cls_st = '6' \n"+
			"  and r.car_mng_id = i.car_mng_id(+) "+
			"  and c.rent_mng_id = bk.rent_mng_id(+) "+
			"  and c.rent_l_cd = bk.rent_l_cd(+) \n"+
			"  and r.car_mng_id = s.car_mng_id(+) "+
			"  and r.car_mng_id = ch.car_mng_id(+) "+
			"  AND r.car_mng_id = sw.car_mng_id(+) "+
			"  AND c.rent_mng_id = t.rent_mng_id(+) "+
			"  AND r.car_mng_id = cg.car_mng_id(+) \n"+
			"  AND e.car_id = m.car_id "+	
			"  and e.car_seq = m.car_seq "+
			"  and m.car_comp_id = n.car_comp_id \n"+
			"  and m.car_cd = n.code "+
			"  and r.car_mng_id = vt.car_mng_id(+) "+
			"  and r.car_mng_id = uc.car_mng_id(+) "+
			dt_query + 	
			"  AND r.car_mng_id = u.car_mng_id(+) "+
			"  and r.car_mng_id = iu.car_mng_id(+) \n"+
			"  AND c.rent_mng_id = l.rent_mng_id "+
			"  AND c.rent_l_cd = l.rent_l_cd "+
			"  AND c.rent_l_cd = t.rent_l_cd(+) \n"+
			"  AND c.car_mng_id = x.car_mng_id(+) "+
			"  AND c.car_mng_id = ic.car_mng_id(+) \n"+
				subQuery+
			"  ORDER BY cont_dt desc";
		}

		Collection<Offls_afterBean> col = new ArrayList<Offls_afterBean>();

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while(rs.next()){
				col.add(makeOffls_afterBean(rs));
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_afterDatabase:getAfter_lst(String gubun, String gubun_nm)]"+e);
			System.out.println("[Offls_afterDatabase:getAfter_lst(String gubun, String gubun_nm)]"+query);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return (Offls_afterBean[])col.toArray(new Offls_afterBean[0]);
		}		
	}

	/**
	*	매각진행차량 검색 - 2003.05.12.Mon.
	*	- gubun : 차량번호, 차량명, 최초등록일
	*	- gubun_nm : 해당 데이타
	*/
	public Offls_afterBean[] getAfter_lst(String gubun, String gubun_nm,String brch_id, String migr_dt, String st_dt, String end_dt, String car_st, String com_id, String car_cd){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String subQuery = "";
		String subQuery2 = "";
	
		
		//검색항목
		if(gubun.equals("car_no")){
			subQuery = " and r.car_no||' '||r.first_car_no like  '%" + gubun_nm + "%'";
		}else if(gubun.equals("init_reg_dt")){
			subQuery = " and r.init_reg_dt like '"+ gubun_nm +"%'";
		}else if(gubun.equals("sui_nm")){
			subQuery = " and u.sui_nm like '%" + gubun_nm + "%' ";
		}

		//영업소코드
		if(!brch_id.equals(""))				subQuery += " and c.brch_id='"+brch_id+"'";
		
		//명의이전일
		if(migr_dt.equals("1")){
			subQuery += " and u.migr_dt between '"+st_dt+"' and '"+end_dt+"' ";
		}else if(migr_dt.equals("2")){
			subQuery += " and u.migr_dt like to_char(sysdate,'yyyymm')||'%' ";
		}else if(migr_dt.equals("3")){
			subQuery += " and u.migr_dt like to_char(sysdate,'yyyy')||'%' ";
		}

		//렌트,리스
		if(car_st.equals("1"))				subQuery += " and  r.car_use='1' ";
		else if(car_st.equals("3"))			subQuery += " and  r.car_use='2' ";


		//제조사, 차종
		if(!com_id.equals(""))				subQuery += " and n.car_comp_id = '"+com_id+"'";
		if(car_cd!=null){
			if(!car_cd.equals(""))			subQuery += " and n.car_comp_id ='"+com_id+"' and n.code = '"+car_cd+"'";
		}

		if(gubun.equals("car_no")){
		query = "select	r.car_mng_id CAR_MNG_ID,  r.car_num, r.car_no CAR_NO, r.first_car_no	CAR_PRE_NO,	cg.cha_dt CHA_DT, r.car_num CAR_NUM, r.init_reg_dt	INIT_REG_DT, r.car_kd CAR_KD, r.car_use	CAR_USE, n.car_nm CAR_JNM, m.car_name CAR_NM, r.car_form CAR_FORM, r.car_y_form	CAR_Y_FORM,	r.dpm			DPM,	r.fuel_kd		FUEL_KD,	r.maint_st_dt	MAINT_ST_DT,	r.maint_end_dt	MAINT_END_DT, r.test_st_dt TEST_ST_DT, r.test_end_dt TEST_END_DT, r.car_l_cd CAR_L_CD, e.rent_mng_id	RENT_MNG_ID,	e.rent_l_cd		RENT_L_CD,	e.car_id		CAR_ID,	e.colo			COLO, e.opt			OPT, e.lpg_yn LPG_YN,	e.car_cs_amt	CAR_CS_AMT,	e.car_cv_amt	CAR_CV_AMT,	e.car_fs_amt	CAR_FS_AMT,	e.car_fv_amt	CAR_FV_AMT,	e.opt_cs_amt	OPT_CS_AMT,	e.opt_cv_amt	OPT_CV_AMT,	e.opt_fs_amt	OPT_FS_AMT,	e.opt_fv_amt	OPT_FV_AMT,	e.clr_cs_amt	CLR_CS_AMT,	e.clr_cv_amt	CLR_CV_AMT,	e.clr_fs_amt	CLR_FS_AMT,	e.clr_fv_amt	CLR_FV_AMT,	e.sd_cs_amt		SD_CS_AMT,	e.sd_cv_amt		SD_CV_AMT,	e.sd_fs_amt		SD_FS_AMT,	e.sd_fv_amt		SD_FV_AMT,	e.dc_cs_amt		DC_CS_AMT,	e.dc_cv_amt		DC_CV_AMT,	e.dc_fs_amt		DC_FS_AMT,	e.dc_fv_amt		DC_FV_AMT, c.mng_id		MNG_ID, c.dlv_dt DLV_DT,	decode(r.car_mng_id, sq.car_mng_id, 1, 0) ACCIDENT_YN, "+
			" vt.tot_dist TOT_DIST, \n"+
			" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD'))))) as AVERAGE_DIST, \n"+
			" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST, \n"+
			" bk.bank_nm BANK_NM, bk.lend_prn LEND_PRN, sw.alt_rest	LEND_REM, bk.alt_end_dt ALT_END_DT, s.lev LEV, s.reason REASON, s.car_st CAR_ST, s.imgfile1 IMGFILE1, s.imgfile2 IMGFILE2, s.imgfile3 IMGFILE3, s.imgfile4 IMGFILE4, s.imgfile5 IMGFILE5, \n"+
			" s.km, uc.damdang_id DETERM_ID, uc.hp_pr HPPR, uc.st_pr STPR, s.damdang_id DAMDANG_ID, s.modify_id MODIFY_ID, s.apprsl_dt APPRSL_DT, DECODE(r.car_mng_id, ch.car_mng_id, 1, 0) CAR_CHA_YN, t.cltr_amt CLTR_AMT, r.off_ls OFF_LS, uc.actn_st ACTN_ST, s.actn_id ACTN_ID \n"+
			", u.sui_nm SUI_NM, u.mm_pr MM_PR, u.cont_dt CONT_DT,  s.ass_ed_dt ASS_ED_DT_ACTN, u.ass_ed_dt ASS_ED_DT_SUI \n"+
			", iu.ins_com_nm INS_COM_NM, iu.ins_exp_dt INS_EXP_DT, x.cls_man_st CLS_MAN_ST, x.tax_st TAX_ST, decode(iu.ins_sts,'2',iu.ins_exp_dt,ic.req_dt) REQ_DT, uc.actn_dt ACTN_DT \n"+
			" from car_reg r,car_etc e, cont c, apprsl s, cltr t,  CAR_NM m, CAR_MNG n, v_tot_dist vt, sui u, cls_cont l, car_tax x, \n"+
			"	(select distinct ac.car_mng_id CAR_MNG_ID from accident ac, car_reg re where ac.car_mng_id=re.car_mng_id) sq, \n"+
			"	(select a.car_mng_id CAR_MNG_ID, a.serv_dt SERV_DT, a.tot_dist TOT_DIST  from service a where a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where car_mng_id = a.car_mng_id)) i, \n"+
			"	(select al.rent_mng_id RENT_MNG_ID, al.rent_l_cd RENT_L_CD, cd.nm BANK_NM, al.lend_prn LEND_PRN, al.alt_end_dt ALT_END_DT from allot al, code cd where al.cpt_cd = cd.code and cd.c_st = '0003') bk, \n"+
			"	(SELECT DISTINCT cc.car_mng_id CAR_MNG_ID FROM car_cha cc, car_reg re WHERE cc.car_mng_id = re.car_mng_id) ch, \n"+
			"	(SELECT sc.car_mng_id CAR_MNG_ID, sc.alt_rest ALT_REST FROM scd_alt_case sc WHERE sc.alt_tm = (select max(alt_tm) from scd_alt_case where car_mng_id = sc.car_mng_id)) sw, \n"+
			"	(SELECT car_mng_id, cha_dt, car_no FROM car_change a WHERE a.cha_seq = to_char(to_number((select max(b.cha_seq) from car_change b where a.car_mng_id = b.car_mng_id))-1)) cg, \n"+
			"	(SELECT a.car_mng_id CAR_MNG_ID, a.seq SEQ, a.actn_st ACTN_ST, a.actn_dt ACTN_DT,  a.damdang_id DAMDANG_ID, a.hp_pr HP_PR, a.st_pr ST_PR FROM auction a WHERE a.seq = (select max(seq) from auction where car_mng_id = a.car_mng_id)) uc \n"+
			", (select ir.ins_sts, ir.car_mng_id CAR_MNG_ID, ic.ins_com_nm INS_COM_NM, ir.ins_exp_dt INS_EXP_DT from insur ir, ins_com ic where ir.ins_com_id = ic.ins_com_id and ir.ins_st = (select max(to_number(ins_st)) from insur where car_mng_id = ir.car_mng_id)) iu \n"+
			", (select a.car_mng_id, a.ins_st, a.exp_dt, a.req_dt, b.migr_dt from ins_cls a, sui b where a.car_mng_id=b.car_mng_id and a.exp_dt=b.migr_dt ) ic \n"+
			" where r.car_mng_id = c.car_mng_id "+
			"  and e.rent_mng_id = c.rent_mng_id "+
			"  and e.rent_l_cd = c.rent_l_cd "+
			"  and r.car_mng_id = sq.car_mng_id(+) \n"+
			"  and c.car_st = '2' "+
			"  and c.use_yn = 'N' "+
			"  and r.off_ls = '6' "+
			"  and l.cls_st = '6' \n"+ //해지사유가 매각
			"  and r.car_mng_id = i.car_mng_id(+) "+
			"  and c.rent_mng_id = bk.rent_mng_id(+) "+
			"  and c.rent_l_cd = bk.rent_l_cd(+) "+
			"  and r.car_mng_id = s.car_mng_id(+) "+
			"  and r.car_mng_id = ch.car_mng_id(+) "+
			"  AND r.car_mng_id = sw.car_mng_id(+) \n"+
			"  AND c.rent_mng_id = t.rent_mng_id(+) "+
			"  AND c.rent_l_cd = t.rent_l_cd(+) "+
			"  AND r.car_mng_id = cg.car_mng_id(+) \n "+
			"  AND e.car_id = m.car_id "+	
			"  and e.car_seq = m.car_seq "+
			"  and m.car_comp_id = n.car_comp_id "+
			"  and m.car_cd = n.code \n "+
			"  and r.car_mng_id = vt.car_mng_id(+) "+
			"  and r.car_mng_id = uc.car_mng_id(+) "+
			"  AND r.car_mng_id = u.car_mng_id(+) "+
			"  and r.car_mng_id = iu.car_mng_id(+) "+
			"  AND c.rent_mng_id = l.rent_mng_id "+
			"  AND c.rent_l_cd = l.rent_l_cd \n "+
			"  AND c.car_mng_id = x.car_mng_id(+) "+
			"  AND c.car_mng_id = ic.car_mng_id(+) \n"+
			subQuery+
			"  ORDER BY cont_dt desc";
		}else{
			query = "select	r.car_mng_id CAR_MNG_ID, r.car_num, r.car_no CAR_NO, r.first_car_no	CAR_PRE_NO,	cg.cha_dt CHA_DT, r.car_num CAR_NUM, r.init_reg_dt	INIT_REG_DT, r.car_kd CAR_KD, r.car_use	CAR_USE, n.car_nm CAR_JNM, m.car_name CAR_NM, r.car_form CAR_FORM, r.car_y_form	CAR_Y_FORM,	r.dpm			DPM,	r.fuel_kd		FUEL_KD,	r.maint_st_dt	MAINT_ST_DT,	r.maint_end_dt	MAINT_END_DT, r.test_st_dt TEST_ST_DT, r.test_end_dt TEST_END_DT, r.car_l_cd CAR_L_CD, e.rent_mng_id	RENT_MNG_ID,	e.rent_l_cd		RENT_L_CD,	e.car_id		CAR_ID,	e.colo			COLO, e.opt			OPT, e.lpg_yn LPG_YN,	e.car_cs_amt	CAR_CS_AMT,	e.car_cv_amt	CAR_CV_AMT,	e.car_fs_amt	CAR_FS_AMT,	e.car_fv_amt	CAR_FV_AMT,	e.opt_cs_amt	OPT_CS_AMT,	e.opt_cv_amt	OPT_CV_AMT,	e.opt_fs_amt	OPT_FS_AMT,	e.opt_fv_amt	OPT_FV_AMT,	e.clr_cs_amt	CLR_CS_AMT,	e.clr_cv_amt	CLR_CV_AMT,	e.clr_fs_amt	CLR_FS_AMT,	e.clr_fv_amt	CLR_FV_AMT,	e.sd_cs_amt		SD_CS_AMT,	e.sd_cv_amt		SD_CV_AMT,	e.sd_fs_amt		SD_FS_AMT,	e.sd_fv_amt		SD_FV_AMT,	e.dc_cs_amt		DC_CS_AMT,	e.dc_cv_amt		DC_CV_AMT,	e.dc_fs_amt		DC_FS_AMT,	e.dc_fv_amt		DC_FV_AMT, c.mng_id		MNG_ID, c.dlv_dt DLV_DT,	decode(r.car_mng_id, sq.car_mng_id, 1, 0) ACCIDENT_YN, "+
			" vt.tot_dist TOT_DIST, \n"+
			" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD'))))) as AVERAGE_DIST,  \n"+
			" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST,  \n"+
			" bk.bank_nm BANK_NM, bk.lend_prn LEND_PRN, sw.alt_rest	LEND_REM, bk.alt_end_dt ALT_END_DT, s.lev LEV, s.reason REASON, s.car_st CAR_ST, s.imgfile1 IMGFILE1, s.imgfile2 IMGFILE2, s.imgfile3 IMGFILE3, s.imgfile4 IMGFILE4, s.imgfile5 IMGFILE5,  \n"+
			" s.km, uc.damdang_id DETERM_ID, uc.hp_pr HPPR, uc.st_pr STPR, s.damdang_id DAMDANG_ID, s.modify_id MODIFY_ID, s.apprsl_dt APPRSL_DT, DECODE(r.car_mng_id, ch.car_mng_id, 1, 0) CAR_CHA_YN, t.cltr_amt CLTR_AMT, r.off_ls OFF_LS, uc.actn_st ACTN_ST, s.actn_id ACTN_ID  \n"+
			", u.sui_nm SUI_NM, u.mm_pr MM_PR, u.cont_dt CONT_DT,  s.ass_ed_dt ASS_ED_DT_ACTN, u.ass_ed_dt ASS_ED_DT_SUI  \n"+
			", iu.ins_com_nm INS_COM_NM, iu.ins_exp_dt INS_EXP_DT, x.cls_man_st CLS_MAN_ST, x.tax_st TAX_ST, decode(iu.ins_sts,'2',iu.ins_exp_dt,ic.req_dt) REQ_DT, uc.actn_dt ACTN_DT \n"+
			" from car_reg r,car_etc e, cont c, apprsl s, cltr t,  CAR_NM m, CAR_MNG n, v_tot_dist vt, sui u, cls_cont l, car_tax x,  \n"+
			"	(select distinct ac.car_mng_id CAR_MNG_ID from accident ac, car_reg re where ac.car_mng_id=re.car_mng_id) sq,  \n"+
			"	(select a.car_mng_id CAR_MNG_ID, a.serv_dt SERV_DT, a.tot_dist TOT_DIST  from service a where a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where car_mng_id = a.car_mng_id)) i,  \n"+
			"	(select al.rent_mng_id RENT_MNG_ID, al.rent_l_cd RENT_L_CD, cd.nm BANK_NM, al.lend_prn LEND_PRN, al.alt_end_dt ALT_END_DT from allot al, code cd where al.cpt_cd = cd.code and cd.c_st = '0003') bk, \n"+
			"	(SELECT DISTINCT cc.car_mng_id CAR_MNG_ID FROM car_cha cc, car_reg re WHERE cc.car_mng_id = re.car_mng_id) ch, \n"+
			"	(SELECT sc.car_mng_id CAR_MNG_ID, sc.alt_rest ALT_REST FROM scd_alt_case sc WHERE sc.alt_tm = (select max(alt_tm) from scd_alt_case where car_mng_id = sc.car_mng_id)) sw, \n"+
			"	(SELECT car_mng_id, cha_dt, car_no FROM car_change a WHERE a.cha_seq = to_char(to_number((select max(b.cha_seq) from car_change b where a.car_mng_id = b.car_mng_id))-1)) cg, \n"+
			"	(SELECT a.car_mng_id CAR_MNG_ID, a.seq SEQ, a.actn_st ACTN_ST, a.actn_dt ACTN_DT, a.damdang_id DAMDANG_ID, a.hp_pr HP_PR, a.st_pr ST_PR FROM auction a WHERE a.seq = (select max(seq) from auction where car_mng_id = a.car_mng_id)) uc \n"+
			", (select ir.ins_sts, ir.car_mng_id CAR_MNG_ID, ic.ins_com_nm INS_COM_NM, ir.ins_exp_dt INS_EXP_DT from insur ir, ins_com ic where ir.ins_com_id = ic.ins_com_id and ir.ins_st = (select max(to_number(ins_st)) from insur where car_mng_id = ir.car_mng_id)) iu \n"+
			", (select a.car_mng_id, a.ins_st, a.exp_dt, a.req_dt, b.migr_dt from ins_cls a, sui b where a.car_mng_id=b.car_mng_id and a.exp_dt=b.migr_dt ) ic \n "+
			" where r.car_mng_id = c.car_mng_id "+
			"  and e.rent_mng_id = c.rent_mng_id "+
			"  and e.rent_l_cd = c.rent_l_cd "+
			"  and r.car_mng_id = sq.car_mng_id(+) \n"+
			"  and c.car_st = '2' "+
			"  and c.use_yn = 'N' "+
			"  and r.off_ls = '6' \n"+
			"  and l.cls_st = '6' \n"+
			"  and r.car_mng_id = i.car_mng_id(+) "+
			"  and c.rent_mng_id = bk.rent_mng_id(+) "+
			"  and c.rent_l_cd = bk.rent_l_cd(+) \n"+
			"  and r.car_mng_id = s.car_mng_id(+) "+
			"  and r.car_mng_id = ch.car_mng_id(+) "+
			"  AND r.car_mng_id = sw.car_mng_id(+) "+
			"  AND c.rent_mng_id = t.rent_mng_id(+) "+
			"  AND r.car_mng_id = cg.car_mng_id(+) \n"+
			"  AND e.car_id = m.car_id "+	
			"  and e.car_seq = m.car_seq "+
			"  and m.car_comp_id = n.car_comp_id \n"+
			"  and m.car_cd = n.code "+
			"  and r.car_mng_id = vt.car_mng_id(+) "+
			"  and r.car_mng_id = uc.car_mng_id(+) "+
			"  AND r.car_mng_id = u.car_mng_id(+) "+
			"  and r.car_mng_id = iu.car_mng_id(+) \n"+
			"  AND c.rent_mng_id = l.rent_mng_id "+
			"  AND c.rent_l_cd = l.rent_l_cd "+
			"  AND c.rent_l_cd = t.rent_l_cd(+) \n"+
			"  AND c.car_mng_id = x.car_mng_id(+) "+
			"  AND c.car_mng_id = ic.car_mng_id(+) \n"+
				subQuery+
			"  ORDER BY cont_dt desc";
		}

		Collection<Offls_afterBean> col = new ArrayList<Offls_afterBean>();

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while(rs.next()){
				col.add(makeOffls_afterBean(rs));
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_afterDatabase:getAfter_lst(String gubun, String gubun_nm)]"+e);
			System.out.println("[Offls_afterDatabase:getAfter_lst(String gubun, String gubun_nm)]"+query);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return (Offls_afterBean[])col.toArray(new Offls_afterBean[0]);
		}		
	}
	
	
	/**
	*	매각진행차량 검색 - 2003.05.12.Mon.
	*	- gubun : 차량번호, 차량명, 최초등록일
	*	- gubun_nm : 해당 데이타
	*/
	public Offls_afterBean[] getAfter_lst(String gubun, String gubun_nm,String brch_id, String dt, String st_dt, String end_dt, String car_st, String com_id, String car_cd, String migr_gu){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String subQuery = "";
		String subQuery2 = "";
			
		//검색항목
		if(gubun.equals("car_no")){
			subQuery = " and (r.car_no like '%"+gubun_nm+"%' or r.first_car_no like '%" + gubun_nm + "%')";
		}else if(gubun.equals("init_reg_dt")){
			subQuery = " and r.init_reg_dt like '"+ gubun_nm +"'||'%' ";
		}else if(gubun.equals("sui_nm")){
			subQuery = " and u.sui_nm like '%" + gubun_nm + "%' ";
		}else if(gubun.equals("ins_com_nm")){
			subQuery = " and iu.ins_com_nm like '%" + gubun_nm + "%' ";
		}else if(gubun.equals("migr_no")){
			subQuery = " and u.migr_no like '%" + gubun_nm + "%' ";
		}

		//영업소코드
		if(!brch_id.equals("")) {
			subQuery += " and c.brch_id='"+brch_id+"'";
		}
		
		//명의이전일		
		if(dt.equals("cont_dt")){
			if(migr_gu.equals("1")){
				subQuery += " and u.cont_dt between '"+st_dt+"' and '"+end_dt+"' ";
			}else if(migr_gu.equals("2")){
				subQuery += " and u.cont_dt like to_char(sysdate,'yyyymm')||'%' ";
			}else if(migr_gu.equals("3")){
				subQuery += " and u.cont_dt like to_char(sysdate,'yyyy')||'%' ";
			}
						
		} else { 	
			if(migr_gu.equals("1")){
				subQuery += " and u.migr_dt between '"+st_dt+"' and '"+end_dt+"' ";
			}else if(migr_gu.equals("2")){
				subQuery += " and u.migr_dt like to_char(sysdate,'yyyymm')||'%' ";
			}else if(migr_gu.equals("3")){
				subQuery += " and u.migr_dt like to_char(sysdate,'yyyy')||'%' ";
			}
		}	
			
	
		//렌트,리스
		if(car_st.equals("1"))				subQuery += " and  r.car_use='1' ";
		else if(car_st.equals("3"))			subQuery += " and  r.car_use='2' ";
		

		//제조사, 차종
		if(!com_id.equals(""))				subQuery += " and n.car_comp_id = '"+com_id+"'";
		if(car_cd!=null){
			if(!car_cd.equals(""))			subQuery += " and n.car_comp_id ='"+com_id+"' and n.code = '"+car_cd+"'";
		}
		
		

		if(gubun.equals("car_no")){
			query = " select r.car_mng_id CAR_MNG_ID,  r.car_num, r.car_no CAR_NO, r.first_car_no	CAR_PRE_NO,	cg.cha_dt CHA_DT, r.car_num CAR_NUM, r.init_reg_dt	INIT_REG_DT, r.car_kd CAR_KD, r.car_use	CAR_USE, n.car_nm CAR_JNM, m.car_name CAR_NM, r.car_form CAR_FORM, r.car_y_form	CAR_Y_FORM,	r.dpm			DPM,	r.fuel_kd		FUEL_KD,	r.maint_st_dt	MAINT_ST_DT,	r.maint_end_dt	MAINT_END_DT, r.test_st_dt TEST_ST_DT, r.test_end_dt TEST_END_DT, r.car_l_cd CAR_L_CD, e.rent_mng_id	RENT_MNG_ID,	e.rent_l_cd		RENT_L_CD,	e.car_id		CAR_ID,	e.colo			COLO, e.opt			OPT, e.lpg_yn LPG_YN,	e.car_cs_amt	CAR_CS_AMT,	e.car_cv_amt	CAR_CV_AMT,	e.car_fs_amt	CAR_FS_AMT,	e.car_fv_amt	CAR_FV_AMT,	e.opt_cs_amt	OPT_CS_AMT,	e.opt_cv_amt	OPT_CV_AMT,	e.opt_fs_amt	OPT_FS_AMT,	e.opt_fv_amt	OPT_FV_AMT,	e.clr_cs_amt	CLR_CS_AMT,	e.clr_cv_amt	CLR_CV_AMT,	e.clr_fs_amt	CLR_FS_AMT,	e.clr_fv_amt	CLR_FV_AMT,	e.sd_cs_amt		SD_CS_AMT,	e.sd_cv_amt		SD_CV_AMT,	e.sd_fs_amt		SD_FS_AMT,	e.sd_fv_amt		SD_FV_AMT,	e.dc_cs_amt		DC_CS_AMT,	e.dc_cv_amt		DC_CV_AMT,	e.dc_fs_amt		DC_FS_AMT,	e.dc_fv_amt		DC_FV_AMT, c.mng_id		MNG_ID, c.dlv_dt DLV_DT,	decode(r.car_mng_id, sq.car_mng_id, 1, 0) ACCIDENT_YN, "+
					"        vt.tot_dist TOT_DIST, \n"+
					"        decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD'))))) as AVERAGE_DIST, \n"+
					"        decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST, \n"+
					"        bk.bank_nm BANK_NM, bk.lend_prn LEND_PRN, sw.alt_rest	LEND_REM, bk.alt_end_dt ALT_END_DT, s.lev LEV, s.reason REASON, s.car_st CAR_ST, s.imgfile1 IMGFILE1, s.imgfile2 IMGFILE2, s.imgfile3 IMGFILE3, s.imgfile4 IMGFILE4, s.imgfile5 IMGFILE5, \n"+
					"        s.km, uc.damdang_id DETERM_ID, uc.hp_pr HPPR, uc.st_pr STPR, s.damdang_id DAMDANG_ID, s.modify_id MODIFY_ID, s.apprsl_dt APPRSL_DT, DECODE(r.car_mng_id, ch.car_mng_id, 1, 0) CAR_CHA_YN, t.cltr_amt CLTR_AMT, r.off_ls OFF_LS, uc.actn_st ACTN_ST, s.actn_id ACTN_ID, \n"+
					"        u.sui_nm SUI_NM, u.mm_pr MM_PR, u.cont_dt CONT_DT,  s.ass_ed_dt ASS_ED_DT_ACTN, u.ass_ed_dt ASS_ED_DT_SUI, \n"+
					"        iu.ins_com_nm INS_COM_NM, iu.ins_exp_dt INS_EXP_DT, x.cls_man_st CLS_MAN_ST, x.tax_st TAX_ST, "+
					"        decode(u.migr_dt,iu.cls_exp_dt,iu.cls_req_dt,decode(iu.ins_sts,'2',iu.ins_exp_dt,ic.req_dt)) REQ_DT, uc.actn_dt ACTN_DT \n"+
					" from   car_reg r, car_etc e, cont c, apprsl s, cltr t,  CAR_NM m, CAR_MNG n, v_tot_dist vt, sui u, cls_cont l, car_tax x, \n"+
					"	     (select distinct ac.car_mng_id CAR_MNG_ID from accident ac, car_reg re where ac.car_mng_id=re.car_mng_id) sq, \n"+
					"	     (select a.car_mng_id CAR_MNG_ID, a.serv_dt SERV_DT, a.tot_dist TOT_DIST  from service a where a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where car_mng_id = a.car_mng_id)) i, \n"+
					"	     (select al.rent_mng_id RENT_MNG_ID, al.rent_l_cd RENT_L_CD, cd.nm BANK_NM, al.lend_prn LEND_PRN, al.alt_end_dt ALT_END_DT from allot al, code cd where al.cpt_cd = cd.code and cd.c_st = '0003') bk, \n"+
					"	     (SELECT DISTINCT cc.car_mng_id CAR_MNG_ID FROM car_cha cc, car_reg re WHERE cc.car_mng_id = re.car_mng_id) ch, \n"+
					"	     (SELECT sc.car_mng_id CAR_MNG_ID, sc.alt_rest ALT_REST FROM scd_alt_case sc WHERE sc.alt_tm = (select max(alt_tm) from scd_alt_case where car_mng_id = sc.car_mng_id)) sw, \n"+
					"	     (SELECT car_mng_id, cha_dt, car_no FROM car_change a WHERE a.cha_seq = to_char(to_number((select max(b.cha_seq) from car_change b where a.car_mng_id = b.car_mng_id))-1)) cg, \n"+
					"	     (SELECT a.car_mng_id CAR_MNG_ID, a.seq SEQ, a.actn_st ACTN_ST, a.actn_dt ACTN_DT,  a.damdang_id DAMDANG_ID, a.hp_pr HP_PR, a.st_pr ST_PR FROM auction a WHERE a.seq = (select max(seq) from auction where car_mng_id = a.car_mng_id)) uc, \n"+
					"        (select ir.ins_sts, ir.car_mng_id CAR_MNG_ID, ic.ins_com_nm INS_COM_NM, ir.ins_exp_dt INS_EXP_DT, z.exp_dt as cls_exp_dt, z.req_dt as cls_req_dt "+
					"         from   insur ir, ins_com ic, ins_cls z "+
					"         where  ir.ins_com_id = ic.ins_com_id and ir.ins_st = (select max(to_number(ins_st)) from insur where car_mng_id = ir.car_mng_id) and ir.car_mng_id=z.car_mng_id(+) and ir.ins_st=z.ins_st(+) "+
					"        ) iu, \n"+
					"		 (select car_mng_id, req_dt from ins_cls where exp_st='3' and exp_aim='3') ic "+
					" where r.car_mng_id = c.car_mng_id "+
					"  and e.rent_mng_id = c.rent_mng_id "+
					"  and e.rent_l_cd = c.rent_l_cd "+
					"  and r.car_mng_id = sq.car_mng_id(+) \n"+
					"  and c.car_st = '2' "+
					"  and c.use_yn = 'N' "+
					"  and r.off_ls = '6' "+
					"  and l.cls_st = '6' \n"+ //해지사유가 매각
					"  and r.car_mng_id = i.car_mng_id(+) "+
					"  and c.rent_mng_id = bk.rent_mng_id(+) "+
					"  and c.rent_l_cd = bk.rent_l_cd(+) "+
					"  and r.car_mng_id = s.car_mng_id(+) "+
					"  and r.car_mng_id = ch.car_mng_id(+) "+
					"  AND r.car_mng_id = sw.car_mng_id(+) \n"+
					"  AND c.rent_mng_id = t.rent_mng_id(+) "+
					"  AND c.rent_l_cd = t.rent_l_cd(+) "+
					"  AND r.car_mng_id = cg.car_mng_id(+) \n "+
					"  AND e.car_id = m.car_id "+	
					"  and e.car_seq = m.car_seq "+
					"  and m.car_comp_id = n.car_comp_id "+
					"  and m.car_cd = n.code \n "+
					"  and r.car_mng_id = vt.car_mng_id(+) "+
					"  and r.car_mng_id = uc.car_mng_id(+) "+
					"  AND r.car_mng_id = u.car_mng_id(+) "+
					"  and r.car_mng_id = iu.car_mng_id(+) "+
					"  AND c.rent_mng_id = l.rent_mng_id "+
					"  AND c.rent_l_cd = l.rent_l_cd \n "+
					"  AND c.car_mng_id = x.car_mng_id(+) "+
					"  AND c.car_mng_id = ic.car_mng_id(+) \n"+
						subQuery+
					"  ORDER BY cont_dt desc";
		}else{
			query = " select "+
					"        r.car_mng_id CAR_MNG_ID, r.car_num, r.car_no CAR_NO, r.first_car_no	CAR_PRE_NO,	cg.cha_dt CHA_DT, r.car_num CAR_NUM, r.init_reg_dt	INIT_REG_DT, r.car_kd CAR_KD, r.car_use	CAR_USE, n.car_nm CAR_JNM, m.car_name CAR_NM, r.car_form CAR_FORM, r.car_y_form	CAR_Y_FORM,	r.dpm			DPM,	r.fuel_kd		FUEL_KD,	r.maint_st_dt	MAINT_ST_DT,	r.maint_end_dt	MAINT_END_DT, r.test_st_dt TEST_ST_DT, r.test_end_dt TEST_END_DT, r.car_l_cd CAR_L_CD, e.rent_mng_id	RENT_MNG_ID,	e.rent_l_cd		RENT_L_CD,	e.car_id		CAR_ID,	e.colo			COLO, e.opt			OPT, e.lpg_yn LPG_YN,	e.car_cs_amt	CAR_CS_AMT,	e.car_cv_amt	CAR_CV_AMT,	e.car_fs_amt	CAR_FS_AMT,	e.car_fv_amt	CAR_FV_AMT,	e.opt_cs_amt	OPT_CS_AMT,	e.opt_cv_amt	OPT_CV_AMT,	e.opt_fs_amt	OPT_FS_AMT,	e.opt_fv_amt	OPT_FV_AMT,	e.clr_cs_amt	CLR_CS_AMT,	e.clr_cv_amt	CLR_CV_AMT,	e.clr_fs_amt	CLR_FS_AMT,	e.clr_fv_amt	CLR_FV_AMT,	e.sd_cs_amt		SD_CS_AMT,	e.sd_cv_amt		SD_CV_AMT,	e.sd_fs_amt		SD_FS_AMT,	e.sd_fv_amt		SD_FV_AMT,	e.dc_cs_amt		DC_CS_AMT,	e.dc_cv_amt		DC_CV_AMT,	e.dc_fs_amt		DC_FS_AMT,	e.dc_fv_amt		DC_FV_AMT, c.mng_id		MNG_ID, c.dlv_dt DLV_DT,	decode(r.car_mng_id, sq.car_mng_id, 1, 0) ACCIDENT_YN, "+
					"        vt.tot_dist TOT_DIST, \n"+
					"        decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD'))))) as AVERAGE_DIST,  \n"+
					"        decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST,  \n"+
					"        bk.bank_nm BANK_NM, bk.lend_prn LEND_PRN, sw.alt_rest	LEND_REM, bk.alt_end_dt ALT_END_DT, s.lev LEV, s.reason REASON, s.car_st CAR_ST, s.imgfile1 IMGFILE1, s.imgfile2 IMGFILE2, s.imgfile3 IMGFILE3, s.imgfile4 IMGFILE4, s.imgfile5 IMGFILE5,  \n"+
					"        s.km, uc.damdang_id DETERM_ID, uc.hp_pr HPPR, uc.st_pr STPR, s.damdang_id DAMDANG_ID, s.modify_id MODIFY_ID, s.apprsl_dt APPRSL_DT, DECODE(r.car_mng_id, ch.car_mng_id, 1, 0) CAR_CHA_YN, t.cltr_amt CLTR_AMT, r.off_ls OFF_LS, uc.actn_st ACTN_ST, s.actn_id ACTN_ID,  \n"+
					"        u.sui_nm SUI_NM, u.mm_pr MM_PR, u.cont_dt CONT_DT,  s.ass_ed_dt ASS_ED_DT_ACTN, u.ass_ed_dt ASS_ED_DT_SUI,  \n"+
					"        iu.ins_com_nm INS_COM_NM, iu.ins_exp_dt INS_EXP_DT, x.cls_man_st CLS_MAN_ST, x.tax_st TAX_ST, "+
					"        decode(u.migr_dt,iu.cls_exp_dt,iu.cls_req_dt,decode(iu.ins_sts,'2',iu.ins_exp_dt,ic.req_dt)) REQ_DT, uc.actn_dt ACTN_DT \n"+

					" from   car_reg r,car_etc e, cont c, apprsl s, cltr t,  CAR_NM m, CAR_MNG n, v_tot_dist vt, sui u, cls_cont l, car_tax x,  \n"+
					"	     (select distinct ac.car_mng_id CAR_MNG_ID from accident ac, car_reg re where ac.car_mng_id=re.car_mng_id) sq,  \n"+
					"	     (select a.car_mng_id CAR_MNG_ID, a.serv_dt SERV_DT, a.tot_dist TOT_DIST  from service a where a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where car_mng_id = a.car_mng_id)) i,  \n"+
					"	     (select al.rent_mng_id RENT_MNG_ID, al.rent_l_cd RENT_L_CD, cd.nm BANK_NM, al.lend_prn LEND_PRN, al.alt_end_dt ALT_END_DT from allot al, code cd where al.cpt_cd = cd.code and cd.c_st = '0003') bk, \n"+
					"	     (SELECT DISTINCT cc.car_mng_id CAR_MNG_ID FROM car_cha cc, car_reg re WHERE cc.car_mng_id = re.car_mng_id) ch, \n"+
					"	     (SELECT sc.car_mng_id CAR_MNG_ID, sc.alt_rest ALT_REST FROM scd_alt_case sc WHERE sc.alt_tm = (select max(alt_tm) from scd_alt_case where car_mng_id = sc.car_mng_id)) sw, \n"+
					"	     (SELECT car_mng_id, cha_dt, car_no FROM car_change a WHERE a.cha_seq = to_char(to_number((select max(b.cha_seq) from car_change b where a.car_mng_id = b.car_mng_id))-1)) cg, \n"+
					"	     (SELECT a.car_mng_id CAR_MNG_ID, a.seq SEQ, a.actn_st ACTN_ST, a.actn_dt ACTN_DT, a.damdang_id DAMDANG_ID, a.hp_pr HP_PR, a.st_pr ST_PR FROM auction a WHERE a.seq = (select max(seq) from auction where car_mng_id = a.car_mng_id)) uc, \n"+
					"        (select ir.ins_sts, ir.car_mng_id CAR_MNG_ID, ic.ins_com_nm INS_COM_NM, ir.ins_exp_dt INS_EXP_DT, z.exp_dt as cls_exp_dt, z.req_dt as cls_req_dt "+
					"		  from   insur ir, ins_com ic, ins_cls z "+
					"		  where  ir.ins_com_id = ic.ins_com_id and ir.ins_st = (select max(to_number(ins_st)) from insur where car_mng_id = ir.car_mng_id) and ir.car_mng_id=z.car_mng_id(+) and ir.ins_st=z.ins_st(+)"+
					"	     ) iu, \n"+
					"		 (select car_mng_id, req_dt from ins_cls where exp_st='3' and exp_aim='3') ic "+

					" where r.car_mng_id = c.car_mng_id "+
					"  and e.rent_mng_id = c.rent_mng_id "+
					"  and e.rent_l_cd = c.rent_l_cd "+
					"  and r.car_mng_id = sq.car_mng_id(+) \n"+
					"  and c.car_st = '2' "+
					"  and c.use_yn = 'N' "+
					"  and r.off_ls = '6' \n"+
					"  and l.cls_st = '6' \n"+
					"  and r.car_mng_id = i.car_mng_id(+) "+
					"  and c.rent_mng_id = bk.rent_mng_id(+) "+
					"  and c.rent_l_cd = bk.rent_l_cd(+) \n"+
					"  and r.car_mng_id = s.car_mng_id(+) "+
					"  and r.car_mng_id = ch.car_mng_id(+) "+
					"  AND r.car_mng_id = sw.car_mng_id(+) "+
					"  AND c.rent_mng_id = t.rent_mng_id(+) "+
					"  AND r.car_mng_id = cg.car_mng_id(+) \n"+
					"  AND e.car_id = m.car_id "+	
					"  and e.car_seq = m.car_seq "+
					"  and m.car_comp_id = n.car_comp_id \n"+
					"  and m.car_cd = n.code "+
					"  and r.car_mng_id = vt.car_mng_id(+) "+
					"  and r.car_mng_id = uc.car_mng_id(+) "+
					"  AND r.car_mng_id = u.car_mng_id(+) "+
					"  and r.car_mng_id = iu.car_mng_id(+) \n"+
					"  AND c.rent_mng_id = l.rent_mng_id "+
					"  AND c.rent_l_cd = l.rent_l_cd "+
					"  AND c.rent_l_cd = t.rent_l_cd(+) \n"+
					"  AND c.car_mng_id = x.car_mng_id(+) "+
					"  AND c.car_mng_id = ic.car_mng_id(+) \n"+
						subQuery+
					"  ORDER BY cont_dt desc";
		}
		
		
		Collection<Offls_afterBean> col = new ArrayList<Offls_afterBean>();

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while(rs.next()){
				col.add(makeOffls_afterBean(rs));
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_afterDatabase:getAfter_lst(String gubun, String gubun_nm)]"+e);
			System.out.println("[Offls_afterDatabase:getAfter_lst(String gubun, String gubun_nm)]"+query);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return (Offls_afterBean[])col.toArray(new Offls_afterBean[0]);
		}		
	}

	/**
	*	매각진행차량 경매관리 조회 - 2003.3.25.Tue.
	*/
	public String getAuction_maxSeq(String car_mng_id){
		getConnection();
		String seq = "";
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = "SELECT a.seq SEQ "+
				"FROM auction a "+
				"WHERE a.seq = (select max(seq) from auction where car_mng_id = a.car_mng_id) "+
				"AND a.car_mng_id = ? ";
		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				seq = rs.getString("SEQ");
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_afterDatabase:getAuction_maxSeq(String car_mng_id)]"+e);
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
	*	매입옵션 검색 - 2004.11.2. Yongsoon Kwon.
	*/
	public Vector getMoption_lst(){
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = "SELECT d.car_mng_id, d.car_no, g.car_nm||' '||f.car_name car_name, nvl(c.firm_nm, c.client_nm) firm_nm, b.cls_dt, h.sui_nm, h.mm_pr, h.cont_dt, d.init_reg_dt, "+
				" e.car_cs_amt+e.car_cv_amt+e.opt_cs_amt+e.opt_cv_amt+e.clr_cs_amt+e.clr_cv_amt+e.sd_cs_amt+e.sd_cv_amt+e.dc_cs_amt+e.dc_cv_amt C_AMT, "+
				" e.car_fs_amt+e.car_fv_amt+e.opt_fs_amt+e.opt_fv_amt+e.clr_fs_amt+e.clr_fv_amt+e.sd_fs_amt+e.sd_fv_amt+e.dc_fs_amt+e.dc_fv_amt F_AMT "+
				", x.cls_man_st, x.tax_st, ic.req_dt "+
				" FROM cont a, cls_cont b, client c, car_reg d, car_etc e, car_nm f, car_mng g, sui h "+
				"		, car_tax x , (select car_mng_id, req_dt from ins_cls where exp_st='3' and exp_aim='3') ic "+
				" WHERE a.rent_mng_id = b.rent_mng_id "+
				" and a.rent_l_cd = b.rent_l_cd "+
				" and a.client_id = c.client_id "+
				" and a.car_mng_id = d.car_mng_id "+
				" and a.rent_mng_id = e.rent_mng_id "+
				" and a.rent_l_cd = e.rent_l_cd "+
				" and e.car_id = f.car_id "+
				" and e.car_seq = f.car_seq "+
				" and f.car_comp_id = g.car_comp_id "+
				" and f.car_cd = g.code "+
				" and a.car_mng_id = h.car_mng_id(+) "+
				" AND a.car_mng_id = x.car_mng_id(+) "+
				" AND a.car_mng_id = ic.car_mng_id(+) "+
				" and a.use_yn = 'N' "+
				" and b.cls_st = '8'"+
				" ORDER BY b.cls_dt desc ";

		try{
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
		}catch(SQLException e){
			System.out.println("[Offls_afterDatabase:getMoption_lst()]"+e);
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
	*	매입옵션 검색 - 2004.11.2. Yongsoon Kwon.
	*/
	public Vector getMoption_lst(String gubun, String gubun_nm, String dt, String st_dt, String end_dt, String car_st, String migr_gu){
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String subQuery = "";
			
		//검색항목
		if(gubun.equals("car_no")){
			subQuery = " and d.car_no||' '||d.first_car_no like  '%" + gubun_nm + "%'";
		}else if(gubun.equals("init_reg_dt")){
			subQuery = " and d.init_reg_dt like '"+ gubun_nm +"%' ";
		}else if(gubun.equals("sui_nm")){
			subQuery = " and h.sui_nm like '%" + gubun_nm + "%' ";
		}else if(gubun.equals("car_num")){
			subQuery = " and d.car_num like '%" + gubun_nm + "%' ";
		}else if(gubun.equals("bohum")){
			subQuery = " and decode(i.ins_sts,'2',i.ins_exp_dt,ic.req_dt) IS not null ";
		}else if(gubun.equals("nobohum")){
			subQuery = " and decode(i.ins_sts,'2',i.ins_exp_dt,ic.req_dt) IS null ";
		}else if(gubun.equals("migr_no")){
			subQuery = " and h.migr_no like '%" + gubun_nm + "%' ";
		}
		
	
		if(dt.equals("cont_dt")){	
			//매매일
			if(migr_gu.equals("1")){
				subQuery += " and h.cont_dt between '"+st_dt+"' and '"+end_dt+"' ";
			}else if(migr_gu.equals("2")){
				subQuery += " and h.cont_dt like to_char(sysdate,'yyyymm')||'%' ";
			}else if(migr_gu.equals("3")){
				subQuery += " and h.cont_dt like to_char(sysdate,'yyyy')||'%' ";
			}else if(migr_gu.equals("4")){
				subQuery += " and h.cont_dt like to_char(add_months(sysdate, -1), 'yyyymm')||'%' ";						
			}
		} else if(dt.equals("cls_dt")){	
			//해지일
			if(migr_gu.equals("1")){
				subQuery += " and b.cls_dt between '"+st_dt+"' and '"+end_dt+"' ";
			}else if(migr_gu.equals("2")){
				subQuery += " and b.cls_dt like to_char(sysdate,'yyyymm')||'%' ";
			}else if(migr_gu.equals("3")){
				subQuery += " and b.cls_dt like to_char(sysdate,'yyyy')||'%' ";
			}else if(migr_gu.equals("4")){
				subQuery += " and b.cls_dt like to_char(add_months(sysdate, -1), 'yyyymm')||'%' ";				
			}
				
		} else  {		
			//명의이전일
			if(migr_gu.equals("1")){
				subQuery += " and h.migr_dt between '"+st_dt+"' and '"+end_dt+"' ";
			}else if(migr_gu.equals("2")){
				subQuery += " and h.migr_dt like to_char(sysdate,'yyyymm')||'%' ";
			}else if(migr_gu.equals("3")){
				subQuery += " and h.migr_dt like to_char(sysdate,'yyyy')||'%' ";
			}else if(migr_gu.equals("4")){
				subQuery += " and h.migr_dt like to_char(add_months(sysdate, -1), 'yyyymm')||'%' ";				
			}
		}	
					

		//렌트,리스
		if(car_st.equals("1"))				subQuery += " and d.car_use ='1' ";
		else if(car_st.equals("3"))			subQuery += " and d.car_use ='2' ";
		else if(car_st.equals("9"))			subQuery += " and h.migr_dt is null ";


		query = " SELECT d.car_mng_id, d.car_num, d.car_no, d.car_doc_no, g.car_nm||' '||f.car_name car_name, nvl(c.firm_nm, c.client_nm) firm_nm, b.cls_dt, h.sui_nm, h.mm_pr, h.cont_dt, d.init_reg_dt, "+
				"        e.car_cs_amt+e.car_cv_amt+e.opt_cs_amt+e.opt_cv_amt+e.clr_cs_amt+e.clr_cv_amt+e.sd_cs_amt+e.sd_cv_amt+e.dc_cs_amt+e.dc_cv_amt C_AMT, "+
				"        e.car_fs_amt+e.car_fv_amt+e.opt_fs_amt+e.opt_fv_amt+e.clr_fs_amt+e.clr_fv_amt+e.sd_fs_amt+e.sd_fv_amt+e.dc_fs_amt+e.dc_fv_amt F_AMT, "+
				"        x.cls_man_st, x.tax_st, decode(h.migr_dt,i.cls_exp_dt,i.cls_req_dt,decode(i.ins_sts,'2',i.ins_exp_dt,ic.req_dt)) req_dt, i.ins_com_nm, decode(h.migr_dt,'','N','Y') migr_yn, "+
				"        decode(instr(d.first_car_no,'허'),0,'미대상') car_st, h.migr_dt , "+
				"        decode(sign(5-trunc(months_between(TO_DATE(nvl(h.migr_dt,h.cont_dt), 'YYYYMMDD'), TO_DATE(d.init_reg_dt, 'YYYYMMDD'))/12,0)),-1,'5년경과') dlv_mon_st , se.conj_dt , se.est_dt "+
				" FROM   cont a, cls_cont b, client c, car_reg d, car_etc e, car_nm f, car_mng g, sui h, sui_etc se , "+
				"		 car_tax x , "+
				"        (select car_mng_id, req_dt from ins_cls where exp_st='3' and exp_aim='3') ic, "+
				"        (select i.*, k.ins_com_nm, n.exp_dt as cls_exp_dt, n.req_dt as cls_req_dt "+
				"         from   insur i, (select car_mng_id, max(to_number(ins_st)) ins_st from insur group by car_mng_id) j, ins_com k, ins_cls n "+
				"         where  i.car_mng_id=j.car_mng_id and i.ins_st=j.ins_st and i.ins_com_id=k.ins_com_id and i.car_mng_id=n.car_mng_id(+) and i.ins_st=n.ins_st(+) "+
				"        ) i "+
				" WHERE  a.rent_mng_id = b.rent_mng_id "+
				"        and a.rent_l_cd = b.rent_l_cd "+
				"        and a.client_id = c.client_id "+
				"        and a.car_mng_id = d.car_mng_id "+
				"        and a.rent_mng_id = e.rent_mng_id "+
				"        and a.rent_l_cd = e.rent_l_cd "+
				"        and e.car_id = f.car_id "+
				"        and e.car_seq = f.car_seq "+
				"        and f.car_comp_id = g.car_comp_id "+
				"        and f.car_cd = g.code "+
				"        and a.car_mng_id = h.car_mng_id(+) and a.car_mng_id = se.car_mng_id(+) "+
				"        AND a.car_mng_id = x.car_mng_id(+) "+
				"        AND a.car_mng_id = ic.car_mng_id(+) "+
				"        and a.use_yn = 'N' "+
				"        and b.cls_st = '8'"+
				"        and a.car_mng_id = i.car_mng_id(+) "+
				subQuery+
				" ORDER BY decode(h.migr_dt , null, '1', '0' ) desc ,  b.cls_dt desc ";

		try{
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
		}catch(SQLException e){
			System.out.println("[Offls_afterDatabase:getMoption_lst()]"+e);
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
	//20160516--매각처리 등록일(c.reg_dt) 기준 명의이전일 차량 리스트  
	public Vector getOffls_after_excel_lst(String st_dt,String end_dt,String migr_gu){
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String subQuery="";
		if(migr_gu.equals("1")){
				subQuery += " and c.reg_dt between '"+st_dt+"' and '"+end_dt+"' ";
			}else if(migr_gu.equals("2")){
				subQuery += " and c.reg_dt like to_char(sysdate,'yyyymm')||'%' ";
			}else if(migr_gu.equals("3")){
				subQuery += " and c.reg_dt like to_char(sysdate,'yyyy')||'%' ";
			}

		query = "SELECT c.reg_dt, a.migr_dt, d.car_no, D.CAR_NM, f.ins_com_nm, e.INS_CON_NO, e.ins_start_dt, e.ins_exp_dt \n"+
				" FROM   SUI a, CONT b, CLS_CONT c, CAR_REG d, INSUR e, INS_COM f \n"+
				" ,(select car_mng_id, req_dt from ins_cls where exp_st='3' and exp_aim='3') ic"+
				" WHERE  a.car_mng_id=b.car_mng_id AND b.rent_l_cd=c.rent_l_cd AND c.cls_st='6' \n"
				+subQuery+
				" AND a.car_mng_id=d.car_mng_id \n"+
				" AND a.CAR_MNG_ID = ic.car_mng_id(+) \n"+
				" AND a.car_mng_id=e.car_mng_id AND e.ins_sts='1' \n"+
				" AND e.ins_com_id=f.ins_com_id \n"+
				" AND ic.req_dt IS NULL \n"+
				" AND f.INS_COM_nm='렌터카공제조합' \n"+
				" ORDER BY c.reg_dt desc ";

		try{
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
		}catch(SQLException e){
			System.out.println("[Offls_afterDatabase:getOffls_after_excel_lst()]"+e);
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
}