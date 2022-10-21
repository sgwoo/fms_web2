/**
 * 오프리스 매각완료 현황 정보
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2003. 05. 12. Mon.
 * @ last modify date : 
 */
package acar.offls_cmplt;

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

import org.json.simple.JSONObject;
import org.json.simple.JSONArray;

public class Offls_cmpltDatabase
{
	private Connection conn = null;
	public static Offls_cmpltDatabase db;
	
	public static Offls_cmpltDatabase getInstance()
	{
		if(Offls_cmpltDatabase.db == null)
			Offls_cmpltDatabase.db = new Offls_cmpltDatabase();
		return Offls_cmpltDatabase.db;
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
	*	매각경매,수의계약에서 매각완료로 2003.6.3.Tue.
	*/
	public int setOffls_cmplt(String[] cmplt){
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = "UPDATE car_reg SET off_ls = '5' WHERE car_mng_id in ('";		
		
		for(int i=0 ; i<cmplt.length ; i++){
			if(i == (cmplt.length -1))	query += cmplt[i];
			else						query += cmplt[i]+"', '";
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
				System.out.println("[Offls_cmpltDatabase:setOffls_cmplt(String[] cmplt)]"+se);
				se.printStackTrace();
			    conn.rollback();
            }catch(SQLException _ignored){}
       	
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
	*	매각진행차량을 다시 매각준비로 2003.2.12.Wed.
	*/
	public int cancelOffls_cmplt(String[] cmplt){
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = "update car_reg set off_ls = '1' where car_mng_id in ('";		
		
		for(int i=0 ; i<cmplt.length ; i++){
			if(i == (cmplt.length -1))	query += cmplt[i];
			else						query += cmplt[i]+"', '";
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
				System.out.println("[Offls_cmpltDatabase:cancelOffls_cmplt(String[] cmplt)]"+se);
				se.printStackTrace();
			    conn.rollback();
            }catch(SQLException _ignored){}
 
		}finally{
			try{
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			closeConnection();
		}
		return result;
	}

	/**
	*	매각진행차량 Bean에 데이터 넣기 2003.05.12.Mon.
	*/
	 private Offls_cmpltBean makeOffls_cmpltBean(ResultSet results) throws DatabaseException {

        try {

            Offls_cmpltBean bean = new Offls_cmpltBean();


			int count = 0;


		    bean.setCar_mng_id		(results.getString("CAR_MNG_ID")	==null?"":results.getString("CAR_MNG_ID"));			//자동차관리번호
			bean.setCar_no			(results.getString("CAR_NO")		==null?"":results.getString("CAR_NO"));
			bean.setCar_pre_no		(results.getString("CAR_PRE_NO")	==null?"":results.getString("CAR_PRE_NO"));
			bean.setCha_dt			(results.getString("CHA_DT")		==null?"":results.getString("CHA_DT"));
			bean.setCar_num			(results.getString("CAR_NUM")		==null?"":results.getString("CAR_NUM"));
			bean.setInit_reg_dt		(results.getString("INIT_REG_DT")	==null?"":results.getString("INIT_REG_DT"));
			bean.setCar_kd			(results.getString("CAR_KD")		==null?"":results.getString("CAR_KD"));
			bean.setCar_use			(results.getString("CAR_USE")		==null?"":results.getString("CAR_USE"));
			bean.setCar_nm			(results.getString("CAR_NM")		==null?"":results.getString("CAR_NM"));
			bean.setCar_jnm			(results.getString("CAR_JNM")		==null?"":results.getString("CAR_JNM"));
			bean.setCar_form		(results.getString("CAR_FORM")		==null?"":results.getString("CAR_FORM"));
			bean.setCar_y_form		(results.getString("CAR_Y_FORM")	==null?"":results.getString("CAR_Y_FORM"));
			bean.setDpm				(results.getString("DPM")			==null?"":results.getString("DPM"));
			bean.setFuel_kd			(results.getString("FUEL_KD")		==null?"":results.getString("FUEL_KD"));
			bean.setMaint_st_dt		(results.getString("MAINT_ST_DT")	==null?"":results.getString("MAINT_ST_DT"));
			bean.setMaint_end_dt	(results.getString("MAINT_END_DT")	==null?"":results.getString("MAINT_END_DT"));
			bean.setTest_st_dt		(results.getString("TEST_ST_DT")	==null?"":results.getString("TEST_ST_DT"));
			bean.setTest_end_dt		(results.getString("TEST_END_DT")	==null?"":results.getString("TEST_END_DT"));
			bean.setCar_l_cd		(results.getString("CAR_L_CD")		==null?"":results.getString("CAR_L_CD"));			//년도별차량등록순번
			bean.setRent_mng_id		(results.getString("RENT_MNG_ID")	==null?"":results.getString("RENT_MNG_ID"));			//계약관리번호
			bean.setRent_l_cd		(results.getString("RENT_L_CD")		==null?"":results.getString("RENT_L_CD"));				//계약번호
			bean.setCar_id			(results.getString("CAR_ID")		==null?"":results.getString("CAR_ID"));
			bean.setColo			(results.getString("COLO")			==null?"":results.getString("COLO"));
			bean.setOpt				(results.getString("OPT")			==null?"":results.getString("OPT"));
			bean.setLpg_yn			(results.getString("LPG_YN")		==null?"":results.getString("LPG_YN"));
			bean.setCar_cs_amt		(results.getInt("CAR_CS_AMT"));
			bean.setCar_cv_amt		(results.getInt("CAR_CV_AMT"));
			bean.setCar_fs_amt		(results.getInt("CAR_FS_AMT"));
			bean.setCar_fv_amt		(results.getInt("CAR_FV_AMT"));
			bean.setOpt_cs_amt		(results.getInt("OPT_CS_AMT"));
			bean.setOpt_cv_amt		(results.getInt("OPT_CV_AMT"));
			bean.setOpt_fs_amt		(results.getInt("OPT_FS_AMT"));
			bean.setOpt_fv_amt		(results.getInt("OPT_FV_AMT"));
			bean.setClr_cs_amt		(results.getInt("CLR_CS_AMT"));
			bean.setClr_cv_amt		(results.getInt("CLR_CV_AMT"));
			bean.setClr_fs_amt		(results.getInt("CLR_FS_AMT"));
			bean.setClr_fv_amt		(results.getInt("CLR_FV_AMT"));
			bean.setSd_cs_amt		(results.getInt("SD_CS_AMT"));
			bean.setSd_cv_amt		(results.getInt("SD_CV_AMT"));
			bean.setSd_fs_amt		(results.getInt("SD_FS_AMT"));
			bean.setSd_fv_amt		(results.getInt("SD_FV_AMT"));
			bean.setDc_cs_amt		(results.getInt("DC_CS_AMT"));
			bean.setDc_cv_amt		(results.getInt("DC_CV_AMT"));
			bean.setDc_fs_amt		(results.getInt("DC_FS_AMT"));
			bean.setDc_fv_amt		(results.getInt("DC_FV_AMT"));
			bean.setMng_id			(results.getString("MNG_ID")		==null?"":results.getString("MNG_ID"));
			bean.setDlv_dt			(results.getString("DLV_DT")		==null?"":results.getString("DLV_DT"));
			bean.setAccident_yn		(results.getString("ACCIDENT_YN")	==null?"":results.getString("ACCIDENT_YN"));
			bean.setTot_dist		(results.getInt("TOT_DIST"));
			bean.setAverage_dist	(results.getInt("AVERAGE_DIST"));
			bean.setToday_dist		(results.getInt("TODAY_DIST"));
			bean.setBank_nm			(results.getString("BANK_NM")		==null?"":results.getString("BANK_NM"));
			bean.setLend_prn		(results.getInt("LEND_PRN"));
			bean.setLend_rem		(results.getInt("LEND_REM"));
			bean.setAlt_end_dt		(results.getString("ALT_END_DT")	==null?"":results.getString("ALT_END_DT"));
			bean.setLev				(results.getString("LEV")			==null?"":results.getString("LEV"));
			bean.setReason			(results.getString("REASON")		==null?"":results.getString("REASON"));
			bean.setCar_st			(results.getString("CAR_ST")		==null?"":results.getString("CAR_ST"));
			bean.setImgfile1		(results.getString("IMGFILE1")		==null?"":results.getString("IMGFILE1"));
			bean.setImgfile2		(results.getString("IMGFILE2")		==null?"":results.getString("IMGFILE2"));
			bean.setImgfile3		(results.getString("IMGFILE3")		==null?"":results.getString("IMGFILE3"));
			bean.setImgfile4		(results.getString("IMGFILE4")		==null?"":results.getString("IMGFILE4"));
			bean.setImgfile5		(results.getString("IMGFILE5")		==null?"":results.getString("IMGFILE5"));
			bean.setKm				(results.getString("KM")			==null?"":results.getString("KM"));
			bean.setDeterm_id		(results.getString("DETERM_ID")		==null?"":results.getString("DETERM_ID"));
			bean.setHppr			(results.getInt("HPPR"));
			bean.setStpr			(results.getInt("STPR"));
			bean.setDamdang_id		(results.getString("DAMDANG_ID")	==null?"":results.getString("DAMDANG_ID"));
			bean.setModify_id		(results.getString("MODIFY_ID")		==null?"":results.getString("MODIFY_ID"));
			bean.setApprsl_dt		(results.getString("APPRSL_DT")		==null?"":results.getString("APPRSL_DT"));
			bean.setCar_cha_yn		(results.getString("CAR_CHA_YN")	==null?"":results.getString("CAR_CHA_YN"));
			bean.setCltr_amt		(results.getInt("CLTR_AMT"));
			bean.setOff_ls			(results.getString("OFF_LS")		==null?"":results.getString("OFF_LS"));	//구분(경매,소매,수의)
			bean.setActn_st			(results.getString("ACTN_ST")		==null?"":results.getString("ACTN_ST"));	//경매상태(출품,경매진행,최종유찰,개별상담,낙찰)
			bean.setActn_id			(results.getString("ACTN_ID")		==null?"":results.getString("ACTN_ID"));
			bean.setIns_com_nm		(results.getString("INS_COM_NM")	==null?"":results.getString("INS_COM_NM"));
			bean.setIns_exp_dt		(results.getString("INS_EXP_DT")	==null?"":results.getString("INS_EXP_DT"));
			bean.setNak_pr			(results.getInt("NAK_PR"));
			bean.setActn_dt			(results.getString("ACTN_DT")		==null?"":results.getString("ACTN_DT"));
			bean.setSui_nm			(results.getString("SUI_NM")		==null?"":results.getString("SUI_NM"));
			bean.setActn_wh			(results.getString("ACTN_WH")		==null?"":results.getString("ACTN_WH"));			
			bean.setP_rent_mng_id	(results.getString("P_RENT_MNG_ID")	==null?"":results.getString("P_RENT_MNG_ID"));
			bean.setP_rent_l_cd		(results.getString("P_RENT_L_CD")	==null?"":results.getString("P_RENT_L_CD"));
			bean.setP_rpt_no		(results.getString("P_RPT_NO")		==null?"":results.getString("P_RPT_NO"));
			bean.setP_car_no		(results.getString("P_CAR_NO")		==null?"":results.getString("P_CAR_NO"));
			bean.setP_dlv_dt		(results.getString("P_DLV_DT")		==null?"":results.getString("P_DLV_DT"));
			bean.setP_car_off_nm	(results.getString("P_CAR_OFF_NM")	==null?"":results.getString("P_CAR_OFF_NM"));
			bean.setP_emp_id		(results.getString("P_EMP_ID")		==null?"":results.getString("P_EMP_ID"));
			bean.setP_emp_nm		(results.getString("P_EMP_NM")		==null?"":results.getString("P_EMP_NM"));
			bean.setComm1_sup		(results.getInt("COMM1_SUP"));
			bean.setComm1_vat		(results.getInt("COMM1_VAT"));
			bean.setComm1_tot		(results.getInt("COMM1_TOT"));
			bean.setComm2_sup		(results.getInt("COMM2_SUP"));
			bean.setComm2_vat		(results.getInt("COMM2_VAT"));
			bean.setComm2_tot		(results.getInt("COMM2_TOT"));
			bean.setComm3_sup		(results.getInt("COMM3_SUP"));
			bean.setComm3_vat		(results.getInt("COMM3_VAT"));
			bean.setComm3_tot		(results.getInt("COMM3_TOT"));
			bean.setComm_tot		(results.getInt("COMM_TOT"));					
			bean.setO_s_amt			(results.getInt("O_S_AMT"));					
			bean.setOut_amt			(results.getInt("OUT_AMT"));
			bean.setHp_s_cha_amt	(results.getInt("HP_S_CHA_AMT"));					
			bean.setHp_accid_amt	(results.getInt("HP_ACCID_AMT"));
			bean.setPark_nm			(results.getString("PARK_NM"));			
			bean.setA_cnt			(results.getInt("A_CNT"));			
			bean.setCar_old_mons	(results.getString("CAR_OLD_MONS"));			
			bean.setActn_jum		(results.getString("actn_jum"));			
			bean.setIn_col			(results.getString("in_col"));			
			bean.setJg_code			(results.getString("jg_code"));	
			bean.setReq_dt			(results.getString("req_dt")		==null?"":results.getString("req_dt"));			
			
			bean.setCont_dt			(results.getString("cont_dt")		==null?"":results.getString("cont_dt"));			 //20180213 추가 
			bean.setJan_pr_dt			(results.getString("jan_pr_dt")		==null?"":results.getString("jan_pr_dt"));	
			
			bean.setSss			(results.getString("sss")		==null?"":results.getString("sss"));  //자산양수차량 여부 Y ( 20180824)	
			
			return bean;

        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}

	/**
	*	매각진행차량 상세정보 2003.2.12.Wed.
	*/
	public Offls_cmpltBean getCmplt_detail(String car_mng_id){
		getConnection();
		Offls_cmpltBean detail = new Offls_cmpltBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " select r.car_mng_id CAR_MNG_ID, r.car_no CAR_NO, cg.car_no	CAR_PRE_NO,	cgg.cha_dt CHA_DT, r.car_num CAR_NUM, r.init_reg_dt	INIT_REG_DT, r.car_kd CAR_KD, r.car_use	CAR_USE, n.car_nm CAR_JNM, m.car_name CAR_NM,	r.car_form CAR_FORM, r.car_y_form	CAR_Y_FORM,	r.dpm			DPM,	r.fuel_kd		FUEL_KD,	r.maint_st_dt	MAINT_ST_DT,	r.maint_end_dt	MAINT_END_DT, r.test_st_dt TEST_ST_DT, r.test_end_dt TEST_END_DT, r.car_l_cd CAR_L_CD, e.rent_mng_id	RENT_MNG_ID,	e.rent_l_cd		RENT_L_CD,	e.car_id		CAR_ID,	e.colo			COLO,	e.opt			OPT, e.lpg_yn LPG_YN,e.car_cs_amt	CAR_CS_AMT,	e.car_cv_amt	CAR_CV_AMT,	e.car_fs_amt	CAR_FS_AMT,	e.car_fv_amt	CAR_FV_AMT,	e.opt_cs_amt	OPT_CS_AMT,	e.opt_cv_amt	OPT_CV_AMT,	e.opt_fs_amt	OPT_FS_AMT,	e.opt_fv_amt	OPT_FV_AMT,	e.clr_cs_amt	CLR_CS_AMT,	e.clr_cv_amt	CLR_CV_AMT,	e.clr_fs_amt	CLR_FS_AMT,	e.clr_fv_amt	CLR_FV_AMT,	e.sd_cs_amt		SD_CS_AMT,	e.sd_cv_amt		SD_CV_AMT,	e.sd_fs_amt		SD_FS_AMT,	e.sd_fv_amt		SD_FV_AMT,	e.dc_cs_amt		DC_CS_AMT,	e.dc_cv_amt		DC_CV_AMT,	e.dc_fs_amt		DC_FS_AMT,	e.dc_fv_amt		DC_FV_AMT, c.mng_id		MNG_ID,	c.dlv_dt DLV_DT, decode(r.car_mng_id, sq.car_mng_id, 1, 0) ACCIDENT_YN, "+
				"        vt.tot_dist TOT_DIST, "+
				"        decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD'))))) as AVERAGE_DIST, "+
				"        decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST, "+
				"        bk.bank_nm BANK_NM, bk.lend_prn LEND_PRN, sw.alt_rest	LEND_REM, bk.alt_end_dt ALT_END_DT, s.lev LEV, s.reason REASON, s.car_st CAR_ST,s.imgfile1 IMGFILE1, s.imgfile2 IMGFILE2, s.imgfile3 IMGFILE3, s.imgfile4 IMGFILE4, s.imgfile5 IMGFILE5, "+
				"        s.km, uc.damdang_id DETERM_ID, uc.hp_pr HPPR, uc.st_pr STPR, uc.nak_pr NAK_PR, s.damdang_id DAMDANG_ID, s.modify_id MODIFY_ID, s.apprsl_dt APPRSL_DT, DECODE(r.car_mng_id, ch.car_mng_id, 1, 0) CAR_CHA_YN, t.cltr_amt CLTR_AMT, r.off_ls OFF_LS, uc.actn_st ACTN_ST, s.actn_id ACTN_ID, "+
				"        iu.ins_com_nm INS_COM_NM, iu.ins_exp_dt INS_EXP_DT, uc.actn_dt ACTN_DT, su.sui_nm , s.actn_wh , "+
				"        up.P_RENT_MNG_ID, up.P_RENT_L_CD, up.P_RPT_NO, up.P_CAR_NO, up.P_DLV_DT, up.P_CAR_OFF_NM, up.P_EMP_ID, up.P_EMP_NM, " +
				"        0 comm1_sup, 0 comm1_vat, 0 comm1_tot, 0 comm2_sup, 0 comm2_vat, 0 comm2_tot, 0 comm3_sup, 0 comm3_vat, 0 comm3_tot, 0 comm_tot, uc.o_s_amt, uc2.out_amt, 0 hp_s_cha_amt, 0 hp_accid_amt, "+
				"        '' park_nm, 0 a_cnt, '' car_old_mons, uc.actn_jum, e.in_col, m.jg_code, '' req_dt , su.cont_dt , su.jan_pr_dt , '' sss "+
				" from   car_reg r, car_etc e, cont c, apprsl s, cltr t,  CAR_NM m, CAR_MNG n, v_tot_dist vt, sui su, "+
				"        (select distinct ac.car_mng_id CAR_MNG_ID from accident ac, car_reg re where ac.car_mng_id=re.car_mng_id) sq, "+
				"	     (select a.car_mng_id CAR_MNG_ID, a.serv_dt SERV_DT, a.tot_dist TOT_DIST  from service a where a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where car_mng_id = a.car_mng_id)) i, "+
				"	     (select al.rent_mng_id RENT_MNG_ID, al.rent_l_cd RENT_L_CD, cd.nm BANK_NM , al.lend_prn LEND_PRN, al.alt_end_dt ALT_END_DT from allot al, code cd where al.cpt_cd = cd.code and cd.c_st = '0003') bk, "+
				"	     (SELECT DISTINCT cc.car_mng_id CAR_MNG_ID FROM car_cha cc, car_reg re WHERE cc.car_mng_id = re.car_mng_id) ch, "+
				"	     (SELECT sc.car_mng_id CAR_MNG_ID, sc.alt_rest ALT_REST FROM scd_alt_case sc WHERE sc.alt_tm = (select max(alt_tm) from scd_alt_case where car_mng_id = sc.car_mng_id)) sw, "+
				"	     (SELECT car_mng_id, cha_dt, car_no FROM car_change a WHERE a.cha_seq = to_char(to_number((select max(b.cha_seq) from car_change b where a.car_mng_id = b.car_mng_id))-1)) cg, "+
				"	     (SELECT car_mng_id, cha_dt, car_no FROM car_change a WHERE a.cha_seq = to_char(to_number((select max(b.cha_seq) from car_change b where a.car_mng_id = b.car_mng_id and b.cha_seq>1)))) cgg, "+
				"	     (SELECT a.car_mng_id CAR_MNG_ID, a.seq SEQ, a.actn_st ACTN_ST, a.actn_dt ACTN_DT, a.damdang_id DAMDANG_ID, a.hp_pr HP_PR, a.st_pr ST_PR, a.nak_pr NAK_PR, a.o_s_amt, a.actn_jum FROM auction a WHERE a.seq = (select max(seq) from auction where car_mng_id = a.car_mng_id)) uc, "+
				"		(SELECT a.car_mng_id CAR_MNG_ID, SUM(a.out_amt) AS out_amt FROM auction a WHERE a.CHOI_ST = '1'  GROUP BY a.car_mng_id )uc2, "+
				"	     (SELECT a.car_mng_id CAR_MNG_ID, a.seq P_SEQ, a.rent_mng_id P_RENT_MNG_ID, a.rent_l_cd  P_RENT_L_CD, a.rpt_no P_RPT_NO, a.car_no P_CAR_NO, a.dlv_dt P_DLV_DT, a.car_off_nm P_CAR_OFF_NM, a.emp_id P_EMP_ID, a.emp_nm P_EMP_NM FROM auction_pur a WHERE a.seq = (select max(seq) from auction_pur where car_mng_id = a.car_mng_id)) up, "+
				"        (select ir.car_mng_id CAR_MNG_ID, ic.ins_com_nm INS_COM_NM, ir.ins_exp_dt INS_EXP_DT from insur ir, ins_com ic where ir.ins_com_id = ic.ins_com_id and ir.ins_st = (select max(ins_st) from insur where car_mng_id = ir.car_mng_id)) iu, "+
				"        (SELECT car_mng_id, max(rent_start_dt) rent_start_dt, max(reg_dt) reg_dt FROM CONT WHERE car_st='2' GROUP BY car_mng_id) c2 "+
				" where  r.car_mng_id = '"+car_mng_id+"' and r.car_mng_id = c.car_mng_id "+
				"        and e.rent_mng_id = c.rent_mng_id "+
				"        and e.rent_l_cd = c.rent_l_cd "+
				"        and r.car_mng_id = sq.car_mng_id(+) "+
				"        and c.car_st = '2' "+
//				"        and c.use_yn = 'Y' "+
//				"        and r.off_ls = '5' "+
				"        AND c.car_mng_id=c2.car_mng_id AND c.rent_start_dt=c2.rent_start_dt AND c.reg_dt=c2.reg_dt "+
				"        and r.car_mng_id = i.car_mng_id(+) "+
				"        and c.rent_mng_id = bk.rent_mng_id(+) "+
				"        and c.rent_l_cd = bk.rent_l_cd(+) "+
				"        and r.car_mng_id = s.car_mng_id(+) "+
				"        and r.car_mng_id = ch.car_mng_id(+) "+
				"        AND r.car_mng_id = sw.car_mng_id(+) "+
				"        AND c.rent_mng_id = t.rent_mng_id(+) "+
				"        AND c.rent_l_cd = t.rent_l_cd(+) "+
				"        AND r.car_mng_id = cg.car_mng_id(+) "+
				"        AND r.car_mng_id = cgg.car_mng_id(+) "+
				"        AND e.car_id = m.car_id "+	
				"        and e.car_seq = m.car_seq "+
				"        and m.car_comp_id = n.car_comp_id "+
				"        and m.car_cd = n.code "+
				"        and r.car_mng_id = vt.car_mng_id(+) "+
				"        and r.car_mng_id = uc.car_mng_id(+) "+
				"        and r.car_mng_id = uc2.car_mng_id(+) "+
				"        and r.car_mng_id = up.car_mng_id(+) "+
				"        and r.car_mng_id = iu.car_mng_id(+) "+
				"        and r.car_mng_id = su.car_mng_id(+) "+
				"  ";

		try{

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();

			if(rs.next()){
				detail = makeOffls_cmpltBean(rs);
			}

			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_cmpltDatabase:getCmplt_detail(String car_mng_id)]"+e);
			System.out.println("[Offls_cmpltDatabase:getCmplt_detail(String car_mng_id)]"+query);
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
	*	회사별 매각진행차량 통계 - 2003.05.12.Mon.
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
"from car_reg C, cont t, car_etc e, car_nm n, code d, auction o    "+ 
"where c.car_mng_id = t.car_mng_id     "+
"and t.rent_mng_id = e.rent_mng_id     "+
"and t.rent_l_cd = e.rent_l_cd     "+
"and  t.car_st='2'     "+
"and  nvl(t.use_yn,'Y')='Y' "+
"and t.brch_id like '"+brch_id+"'    "+
"and c.off_ls =  '5'  and c.car_mng_id = o.car_mng_id  and o.actn_st='4'    "+ 
"and e.car_id = n.car_id     "+
"and n.car_comp_id = '0001'     "+
"and n.car_comp_id = d.code     "+
"and d.c_st = '0001') hd,     "+
"(select nvl(sum(decode(C.car_kd, '1', 1, 0)),0) c1, nvl(sum(decode(C.car_kd, '2', 1, 0)),0) c2, nvl(sum(decode(C.car_kd, '3', 1, '9', 1, 0)),0) c3, nvl(sum(decode(C.car_kd, '4', 1, 0)),0) c4, nvl(sum(decode(C.car_kd, '5', 1, 0)),0) c5, nvl(sum(decode(C.car_kd, '6', 1, 0)),0) c6, nvl(sum(decode(C.car_kd, '7', 1, 0)),0) c7 "+
"from car_reg C, cont t, car_etc e, car_nm n, code d, auction o   "+  
"where c.car_mng_id = t.car_mng_id    "+ 
"and t.rent_mng_id = e.rent_mng_id    "+ 
"and t.rent_l_cd = e.rent_l_cd   "+  
"and  t.car_st='2'     "+
"and  nvl(t.use_yn,'Y')='Y'      "+
"and t.brch_id like '"+brch_id+"' "+
"and c.off_ls =  '5'  and c.car_mng_id = o.car_mng_id  and o.actn_st='4'    "+ 
"and e.car_id = n.car_id     "+
"and n.car_comp_id = '0002'     "+
"and n.car_comp_id = d.code     "+
"and d.c_st = '0001') kia,     "+
"(select nvl(sum(decode(C.car_kd, '1', 1, 0)),0) c1, nvl(sum(decode(C.car_kd, '2', 1, 0)),0) c2, nvl(sum(decode(C.car_kd, '3', 1, '9', 1, 0)),0) c3, nvl(sum(decode(C.car_kd, '4', 1, 0)),0) c4, nvl(sum(decode(C.car_kd, '5', 1, 0)),0) c5, nvl(sum(decode(C.car_kd, '6', 1, 0)),0) c6, nvl(sum(decode(C.car_kd, '7', 1, 0)),0) c7 "+
"from car_reg C, cont t, car_etc e, car_nm n, code d, auction o     "+
"where c.car_mng_id = t.car_mng_id   "+  
"and t.rent_mng_id = e.rent_mng_id     "+
"and t.rent_l_cd = e.rent_l_cd  "+   
"and  t.car_st='2'     "+
"and  nvl(t.use_yn,'Y')='Y'      "+
"and t.brch_id like '"+brch_id+"' "+
"and c.off_ls =  '5'  and c.car_mng_id = o.car_mng_id  and o.actn_st='4'    "+ 
"and e.car_id = n.car_id     "+
"and n.car_comp_id = '0003'     "+
"and n.car_comp_id = d.code     "+
"and d.c_st = '0001') sam,     "+
"(select nvl(sum(decode(C.car_kd, '1', 1, 0)),0) c1, nvl(sum(decode(C.car_kd, '2', 1, 0)),0) c2, nvl(sum(decode(C.car_kd, '3', 1, '9', 1, 0)),0) c3, nvl(sum(decode(C.car_kd, '4', 1, 0)),0) c4, nvl(sum(decode(C.car_kd, '5', 1, 0)),0) c5, nvl(sum(decode(C.car_kd, '6', 1, 0)),0) c6, nvl(sum(decode(C.car_kd, '7', 1, 0)),0) c7 "+
"from car_reg C, cont t, car_etc e, car_nm n, code d, auction o     "+
"where c.car_mng_id = t.car_mng_id     "+
"and t.rent_mng_id = e.rent_mng_id   "+  
"and t.rent_l_cd = e.rent_l_cd     "+
"and  t.car_st='2'     "+
"and  nvl(t.use_yn,'Y')='Y'      "+
"and t.brch_id like '"+brch_id+"' "+
"and c.off_ls =  '5'  and c.car_mng_id = o.car_mng_id  and o.actn_st='4'    "+ 
"and e.car_id = n.car_id     "+
"and n.car_comp_id in ('0004','0005')     "+
"and n.car_comp_id = d.code     "+
"and d.c_st = '0001') ds,     "+
"(select nvl(sum(decode(C.car_kd, '1', 1, 0)),0) c1, nvl(sum(decode(C.car_kd, '2', 1, 0)),0) c2, nvl(sum(decode(C.car_kd, '3', 1, '9', 1, 0)),0) c3, nvl(sum(decode(C.car_kd, '4', 1, 0)),0) c4, nvl(sum(decode(C.car_kd, '5', 1, 0)),0) c5, nvl(sum(decode(C.car_kd, '6', 1, 0)),0) c6, nvl(sum(decode(C.car_kd, '7', 1, 0)),0) c7 "+
"from car_reg C, cont t, car_etc e, car_nm n, code d, auction o     "+
"where c.car_mng_id = t.car_mng_id   "+  
"and t.rent_mng_id = e.rent_mng_id  "+   
"and t.rent_l_cd = e.rent_l_cd     "+
"and  t.car_st='2'    "+ 
"and  nvl(t.use_yn,'Y')='Y'    "+  
"and t.brch_id like '"+brch_id+"' "+ 
"and c.off_ls =  '5'  and c.car_mng_id = o.car_mng_id  and o.actn_st='4'    "+ 
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
				System.out.println("[Offls_cmpltDatabase:getTg()]"+e);
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
	public Offls_cmpltBean[] getCmplt_lst(String dt, String ref_dt1, String ref_dt2, String gubun, String gubun1, String gubun_nm,String brch_id, String s_au){//8개
		getConnection();

		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String query = "";
		String subQuery = "";
		String dt_query = "";  
		String su_query = "";  
			
		String s_dt2 = "to_char(sysdate,'YYYYMM')";
		String s_dt3 = "between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')";


		//디폴트 기간-일자없음 -> 현재 낙찰상태
		if(dt.equals("2"))								dt_query = " and uc.actn_dt like "+s_dt2+"||'%' \n";
		else if(dt.equals("3") && !ref_dt1.equals(""))	dt_query = " and uc.actn_dt "+s_dt3+" \n";

					
		if(gubun.equals("car_no")){
			subQuery = " and ( r.car_no like '%" + gubun_nm +"%' or nvl(r.first_car_no, ' ') like '%"+ gubun_nm +"%') \n";
		}else if(gubun.equals("car_nm")){
			subQuery = " and r.car_nm like '%" + gubun_nm.toUpperCase() + "%' \n";
		}else if(gubun.equals("init_reg_dt")){
			subQuery = " and r.init_reg_dt like replace('"+ gubun_nm +"','-','')||'%' \n";
		}else if(gubun.equals("actn_nm")){
			subQuery = " and s.firm_nm like '%" + gubun_nm.toUpperCase() + "%' \n";
		}else{ //all
			subQuery = "";
		}


		if(gubun1.equals("rt")){
			subQuery = " and r.car_use = '1' ";
		}else if(gubun1.equals("ls")){
			subQuery = " and r.car_use = '2' ";
		}

		if(!brch_id.equals(""))	subQuery += " and c.brch_id='"+brch_id+"' \n";


		//경매장
		if(!s_au.equals(""))				su_query = " and s.actn_id ='" + s_au + "' \n";

		
		if(gubun.equals("car_no")){
			query = " select uc2.out_amt, se.COMM1_SUP,se.COMM1_VAT, (se.COMM1_SUP + se.COMM1_VAT) COMM1_TOT, \n"+
					"        se.COMM2_SUP,se.COMM2_VAT, (se.COMM2_SUP + se.COMM2_VAT) COMM2_TOT, \n"+
					"        se.COMM3_SUP,se.COMM3_VAT, (se.COMM3_SUP + se.COMM3_VAT) COMM3_TOT, \n"+
					"        ((se.COMM1_SUP + se.COMM1_VAT)+(se.COMM2_SUP + se.COMM2_VAT)+(se.COMM3_SUP + se.COMM3_VAT)) AS comm_tot,  \n"+
					"        r.car_mng_id CAR_MNG_ID, r.car_no CAR_NO, cg.car_no CAR_PRE_NO, cg.cha_dt CHA_DT, r.car_num CAR_NUM, r.init_reg_dt	INIT_REG_DT, r.car_kd CAR_KD, r.car_use	CAR_USE, \n"+
					"        n.car_nm CAR_JNM, m.car_name CAR_NM, r.car_form CAR_FORM, r.car_y_form	CAR_Y_FORM,	r.dpm DPM, r.fuel_kd FUEL_KD, r.maint_st_dt	MAINT_ST_DT, r.maint_end_dt	MAINT_END_DT, \n"+
					"        r.test_st_dt TEST_ST_DT, r.test_end_dt TEST_END_DT, r.car_l_cd CAR_L_CD, e.rent_mng_id	RENT_MNG_ID, e.rent_l_cd RENT_L_CD,	e.car_id CAR_ID, e.colo COLO, e.opt OPT, \n"+
					"        e.lpg_yn LPG_YN, e.car_cs_amt CAR_CS_AMT, e.car_cv_amt	CAR_CV_AMT,	e.car_fs_amt CAR_FS_AMT, e.car_fv_amt CAR_FV_AMT, \n"+
					"        e.opt_cs_amt OPT_CS_AMT, e.opt_cv_amt OPT_CV_AMT, e.opt_fs_amt	OPT_FS_AMT,	e.opt_fv_amt OPT_FV_AMT, e.clr_cs_amt CLR_CS_AMT, \n"+
					"        e.clr_cv_amt CLR_CV_AMT, e.clr_fs_amt	CLR_FS_AMT, e.clr_fv_amt CLR_FV_AMT, \n"+
					"        e.sd_cs_amt SD_CS_AMT, e.sd_cv_amt SD_CV_AMT, e.sd_fs_amt SD_FS_AMT, e.sd_fv_amt SD_FV_AMT, \n"+
					"        e.dc_cs_amt DC_CS_AMT, e.dc_cv_amt DC_CV_AMT, e.dc_fs_amt DC_FS_AMT, e.dc_fv_amt DC_FV_AMT, c.mng_id MNG_ID, c.dlv_dt DLV_DT, \n"+
					"        decode(r.car_mng_id, sq.car_mng_id, 1, 0) ACCIDENT_YN, \n"+
					"        vt.tot_dist TOT_DIST, \n"+
					"        decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD'))))) as AVERAGE_DIST, \n"+
					"        decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST, \n"+
					"        bk.bank_nm BANK_NM, bk.lend_prn LEND_PRN, sw.alt_rest	LEND_REM, bk.alt_end_dt ALT_END_DT, s.lev LEV, s.reason REASON, s.car_st CAR_ST, \n"+
					"        s.imgfile1 IMGFILE1, s.imgfile2 IMGFILE2, s.imgfile3 IMGFILE3, s.imgfile4 IMGFILE4, s.imgfile5 IMGFILE5, \n"+
			//		"        s.km, uc.damdang_id DETERM_ID, uc.hp_pr HPPR, uc.st_pr STPR, uc.nak_pr NAK_PR, \n"+
					"        s.km, uc.damdang_id DETERM_ID, uc.hp_pr HPPR, uc.st_pr STPR, su.mm_pr NAK_PR, \n"+  //실제 낙찰금액으로    
					"        s.damdang_id DAMDANG_ID, s.modify_id MODIFY_ID, s.apprsl_dt APPRSL_DT, ''  CAR_CHA_YN, 0 CLTR_AMT, \n"+
					"        r.off_ls OFF_LS, uc.actn_st ACTN_ST, s.actn_id ACTN_ID , s.actn_wh ACTN_WH, \n"+
					"        iu.ins_com_nm INS_COM_NM, iu.ins_exp_dt INS_EXP_DT, uc.actn_dt ACTN_DT, su.sui_nm ,\n"+
					"        '' P_RENT_MNG_ID, '' P_RENT_L_CD, '' P_RPT_NO, '' P_CAR_NO, '' P_DLV_DT,  '' P_CAR_OFF_NM, '' P_EMP_ID, '' P_EMP_NM, uc.o_s_amt, nvl((uc.nak_pr-uc.o_s_amt),0) as hp_s_cha_amt, nvl(e2.tot_amt,0) hp_accid_amt, \n" +
					"        nvl(ak.a_cnt,0) a_cnt, TRUNC(MONTHS_BETWEEN(TO_DATE(uc.actn_dt,'YYYYMMDD'), TO_DATE(r.init_reg_dt,'YYYYMMDD')),1) car_old_mons, \n"+  //침수여부
					//"        decode(r.park, '1','목동주차', '2','정일현대', '3','부산지점', '4','대전지점', '5','명진공업', '7','부산부경','8','부산조양','9','대전현대','10','오토크린', '11','대전금호','12','광주지점','13','대구지점','14','상무현대', '15','영남주차', '16','동화엠파크', substr(r.park_cont,1,5)) park_nm, \n"+				
					"       decode(r.park,'6',substr(r.park_cont,1,5),nvl(cd.nm,r.park))  park_nm, \n"+
                    "        uc.actn_jum, e.in_col, m.jg_code, \n"+ 
					"	     decode(iu.ins_sts,'2',iu.ins_exp_dt,ic.req_dt) req_dt , su.cont_dt, su.jan_pr_dt , decode(sss.car_mng_id, null , '', 'Y' ) sss \n"+ 
					" from   car_reg r, car_etc e, cont c,  apprsl  s,   CAR_NM m, CAR_MNG n, v_tot_dist vt, sui su, SUI_ETC se, \n"+
						"        ( select c_st, code, nm_cd, nm from code where c_st = '0027' and code <> '0000'  ) cd,  \n"+  //주차장 
					"	     (select distinct ac.car_mng_id CAR_MNG_ID from accident ac, car_reg re where ac.car_mng_id=re.car_mng_id) sq, \n"+
					"	     (select a.car_mng_id CAR_MNG_ID, a.serv_dt SERV_DT, a.tot_dist TOT_DIST  from service a where a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where car_mng_id = a.car_mng_id)) i, \n"+
					"	     (select al.rent_mng_id RENT_MNG_ID, al.rent_l_cd RENT_L_CD, cd.nm BANK_NM, al.lend_prn LEND_PRN, al.alt_end_dt ALT_END_DT from allot al, code cd where al.cpt_cd = cd.code and cd.c_st = '0003') bk, \n"+
				//	"	     (SELECT DISTINCT cc.car_mng_id CAR_MNG_ID FROM car_cha cc, car_reg re WHERE cc.car_mng_id = re.car_mng_id) ch, \n"+
					"	     (SELECT sc.car_mng_id CAR_MNG_ID, sc.alt_rest ALT_REST FROM scd_alt_case sc WHERE sc.alt_tm = (select max(alt_tm) from scd_alt_case where car_mng_id = sc.car_mng_id)) sw, \n"+
					"	     (SELECT car_mng_id, cha_dt, car_no FROM car_change a WHERE a.cha_seq = to_char(to_number((select max(b.cha_seq) from car_change b where a.car_mng_id = b.car_mng_id))-1)) cg, \n"+
					"	     (SELECT a.car_mng_id CAR_MNG_ID, a.seq SEQ, a.actn_st ACTN_ST, a.actn_dt ACTN_DT, a.damdang_id DAMDANG_ID, a.hp_pr HP_PR, a.st_pr ST_PR, a.nak_pr NAK_PR, a.o_s_amt, a.actn_jum FROM auction a WHERE a.seq = (select max(seq) from auction where car_mng_id = a.car_mng_id)) uc, \n"+
					"		 ( SELECT a.car_mng_id CAR_MNG_ID, SUM(a.out_amt) AS out_amt FROM auction a WHERE a.CHOI_ST = '1'  GROUP BY a.car_mng_id) uc2, "+
					"        (select ir.car_mng_id, ic.ins_com_nm, ir.ins_exp_dt, ir.ins_sts from insur ir, ins_com ic where ir.ins_com_id = ic.ins_com_id and ir.ins_st = (select max(ins_st) from insur where car_mng_id = ir.car_mng_id)) iu \n"+
				    " , (SELECT DISTINCT a.car_mng_id, b.tot_amt, b.cust_amt FROM accident a, (SELECT car_mng_id, sum(tot_amt) tot_amt, sum(cust_amt) cust_amt FROM service WHERE accid_id IS NOT null GROUP BY car_mng_id  ) b  WHERE a.car_mng_id = b.car_mng_id(+) AND a.accid_st <> '1' ) e2 \n"+
 			        " , (select car_mng_id, count(0) as a_cnt from accident where accid_st='6' group by car_mng_id) ak \n"+ //침수
					" , (select car_mng_id, req_dt from ins_cls where exp_st='3' and exp_aim='3') ic \n"+ //보험청구
					" , (  select a.car_mng_id from cont a, commi c where  a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd and a.car_gu='2'  and c.agnt_st = '6'   AND a.car_mng_id IS NOT NULL  group by a.car_mng_id )  sss   \n"+		
					"  where r.off_ls = '5' and r.car_mng_id = c.car_mng_id \n"+
					"  and e.rent_mng_id = c.rent_mng_id \n"+
					"  and e.rent_l_cd = c.rent_l_cd \n"+
					"  and r.car_mng_id = sq.car_mng_id(+) \n"+
					"  and c.car_st = '2' \n"+
					"  and c.use_yn = 'Y' \n"+
					"  and r.car_mng_id = i.car_mng_id(+) \n"+
					"  and c.rent_mng_id = bk.rent_mng_id(+) \n"+
					"  and c.rent_l_cd = bk.rent_l_cd(+) \n"+
					"  and r.car_mng_id = s.car_mng_id(+) \n"+
				//	"  and r.car_mng_id = ch.car_mng_id(+) \n"+
					"  AND r.car_mng_id = sw.car_mng_id(+) \n"+
				//	"  AND c.rent_mng_id = t.rent_mng_id(+) \n"+
				//	"  AND c.rent_l_cd = t.rent_l_cd(+) \n"+	
					"  AND r.car_mng_id = cg.car_mng_id(+) \n"+
					"  AND e.car_id = m.car_id \n"+	
					"  and e.car_seq = m.car_seq \n"+
					"  and m.car_comp_id = n.car_comp_id \n"+
					"  and m.car_cd = n.code \n"+
					"  and r.car_mng_id = vt.car_mng_id(+) \n"+
					"  and r.car_mng_id = uc.car_mng_id(+) \n"+
					"  and r.car_mng_id = uc2.car_mng_id(+) \n"+
					"  and r.car_mng_id = iu.car_mng_id(+) \n"+
					"  and r.car_mng_id = su.car_mng_id(+) AND su.CAR_MNG_ID = se.CAR_MNG_ID(+) \n "+
				    "  AND sq.car_mng_id = e2.car_mng_id(+) "+
  			        "  and r.car_mng_id = ak.car_mng_id(+) "+
  			        "  and r.car_mng_id = ic.car_mng_id(+) "+
  			       	" and r.car_mng_id=sss.car_mng_id(+) \n"+
  			  			" and r.park = cd.nm_cd(+) \n"+  //주차장 코드 테이블 
					dt_query + 	su_query +
					subQuery +
					" ORDER BY r.off_ls, uc.actn_dt desc, s.actn_id,  r.car_nm, r.init_reg_dt, r.car_mng_id ";
		}else{
			query = " select uc2.out_amt, se.COMM1_SUP,se.COMM1_VAT, (se.COMM1_SUP + se.COMM1_VAT) COMM1_TOT, \n"+
					"        se.COMM2_SUP,se.COMM2_VAT, (se.COMM2_SUP + se.COMM2_VAT) COMM2_TOT, \n"+
					"        se.COMM3_SUP,se.COMM3_VAT, (se.COMM3_SUP + se.COMM3_VAT) COMM3_TOT, \n"+
					"        ((se.COMM1_SUP + se.COMM1_VAT)+(se.COMM2_SUP + se.COMM2_VAT)+(se.COMM3_SUP + se.COMM3_VAT)) AS comm_tot,  \n"+
					"        r.car_mng_id CAR_MNG_ID, r.car_no CAR_NO, cg.car_no CAR_PRE_NO, cg.cha_dt CHA_DT, r.car_num CAR_NUM, r.init_reg_dt	INIT_REG_DT, r.car_kd CAR_KD, r.car_use	CAR_USE, \n"+
					"        n.car_nm CAR_JNM, m.car_name CAR_NM, r.car_form CAR_FORM, r.car_y_form	CAR_Y_FORM,	r.dpm DPM, r.fuel_kd FUEL_KD, \n"+
					"        r.maint_st_dt	MAINT_ST_DT, r.maint_end_dt	MAINT_END_DT, r.test_st_dt TEST_ST_DT, r.test_end_dt TEST_END_DT, \n"+
					"        r.car_l_cd CAR_L_CD, e.rent_mng_id	RENT_MNG_ID, e.rent_l_cd RENT_L_CD,	e.car_id CAR_ID, e.colo COLO, e.opt OPT, e.lpg_yn LPG_YN, \n"+
					"        e.car_cs_amt CAR_CS_AMT, e.car_cv_amt CAR_CV_AMT, e.car_fs_amt	CAR_FS_AMT,	e.car_fv_amt CAR_FV_AMT, \n"+
					"        e.opt_cs_amt OPT_CS_AMT, e.opt_cv_amt OPT_CV_AMT, e.opt_fs_amt	OPT_FS_AMT,	e.opt_fv_amt OPT_FV_AMT, \n"+
					"        e.clr_cs_amt CLR_CS_AMT, e.clr_cv_amt CLR_CV_AMT, e.clr_fs_amt	CLR_FS_AMT,	e.clr_fv_amt CLR_FV_AMT, \n"+
					"        e.sd_cs_amt SD_CS_AMT,	e.sd_cv_amt SD_CV_AMT, e.sd_fs_amt SD_FS_AMT, e.sd_fv_amt SD_FV_AMT, \n"+
					"        e.dc_cs_amt DC_CS_AMT,	e.dc_cv_amt DC_CV_AMT, e.dc_fs_amt DC_FS_AMT, e.dc_fv_amt DC_FV_AMT, \n"+
					"        c.mng_id MNG_ID, c.dlv_dt DLV_DT, decode(r.car_mng_id, sq.car_mng_id, 1, 0) ACCIDENT_YN, \n"+
					"        vt.tot_dist TOT_DIST, \n"+
					"        decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD'))))) as AVERAGE_DIST, \n"+
					"        decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST, \n "+
					"        bk.bank_nm BANK_NM, bk.lend_prn LEND_PRN, sw.alt_rest	LEND_REM, bk.alt_end_dt ALT_END_DT, s.lev LEV, s.reason REASON, s.car_st CAR_ST, \n"+
					"        s.imgfile1 IMGFILE1, s.imgfile2 IMGFILE2, s.imgfile3 IMGFILE3, s.imgfile4 IMGFILE4, s.imgfile5 IMGFILE5, \n"+
				//	"        s.km, uc.damdang_id DETERM_ID, uc.hp_pr HPPR, uc.st_pr STPR, uc.nak_pr NAK_PR, \n"+  
					"        s.km, uc.damdang_id DETERM_ID, uc.hp_pr HPPR, uc.st_pr STPR, su.mm_pr NAK_PR, \n"+ //실제 낙찰금액으로    
					"        s.damdang_id DAMDANG_ID, s.modify_id MODIFY_ID, s.apprsl_dt APPRSL_DT, \n"+
					"       '' CAR_CHA_YN,  0 CLTR_AMT, r.off_ls OFF_LS, uc.actn_st ACTN_ST, s.actn_id ACTN_ID, s.actn_wh ACTN_WH, \n"+
					"        iu.ins_com_nm INS_COM_NM, iu.ins_exp_dt INS_EXP_DT, uc.actn_dt ACTN_DT, su.sui_nm, \n"+
					"        '' P_RENT_MNG_ID, '' P_RENT_L_CD, '' P_RPT_NO, '' P_CAR_NO, '' P_DLV_DT,  '' P_CAR_OFF_NM, '' P_EMP_ID, '' P_EMP_NM, uc.o_s_amt, nvl((uc.nak_pr-uc.o_s_amt),0) as hp_s_cha_amt, nvl(e2.tot_amt,0) hp_accid_amt, \n"+
					"        nvl(ak.a_cnt,0) a_cnt, TRUNC(MONTHS_BETWEEN(TO_DATE(uc.actn_dt,'YYYYMMDD'), TO_DATE(r.init_reg_dt,'YYYYMMDD')),1) car_old_mons, \n"+  //침수여부
					//"        decode(r.park, '1','목동주차', '2','정일현대', '3','부산지점', '4','대전지점', '5','명진공업', '7','부산부경','8','부산조양','9','대전현대','10','오토크린', '11','대전금호','12','광주지점','13','대구지점','14','상무현대', '15','영남주차', '16','동화엠파크', substr(r.park_cont,1,5)) park_nm, \n"+				
					"        decode(r.park,'6',substr(r.park_cont,1,5),nvl(cd.nm,r.park))  park_nm, \n"+
                    "        uc.actn_jum, e.in_col, m.jg_code, "+ 
					"	     decode(iu.ins_sts,'2',iu.ins_exp_dt,ic.req_dt) req_dt , su.cont_dt , su.jan_pr_dt , decode(sss.car_mng_id, null , '', 'Y' ) sss   \n"+ 
					" from   car_reg r, car_etc e, cont c,  apprsl s,  CAR_NM m, CAR_MNG n, v_tot_dist vt, sui su, SUI_ETC se, \n "+
						"        ( select c_st, code, nm_cd, nm from code where c_st = '0027' and code <> '0000'  ) cd,  \n"+  //주차장 
					"	     (select distinct ac.car_mng_id CAR_MNG_ID from accident ac, car_reg re where ac.car_mng_id=re.car_mng_id) sq, \n"+
					"	     (select a.car_mng_id CAR_MNG_ID, a.serv_dt SERV_DT, a.tot_dist TOT_DIST  from service a where a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where car_mng_id = a.car_mng_id)) i, \n"+
					"	     (select al.rent_mng_id RENT_MNG_ID, al.rent_l_cd RENT_L_CD, cd.nm BANK_NM, al.lend_prn LEND_PRN, al.alt_end_dt ALT_END_DT from allot al, code cd where al.cpt_cd = cd.code and cd.c_st = '0003') bk, \n"+
				//	"	     (SELECT DISTINCT cc.car_mng_id CAR_MNG_ID FROM car_cha cc, car_reg re WHERE cc.car_mng_id = re.car_mng_id) ch, \n"+
					"	     (SELECT sc.car_mng_id CAR_MNG_ID, sc.alt_rest ALT_REST FROM scd_alt_case sc WHERE sc.alt_tm = (select max(alt_tm) from scd_alt_case where car_mng_id = sc.car_mng_id)) sw, \n "+
					"	     (SELECT car_mng_id, cha_dt, car_no FROM car_change a WHERE a.cha_seq = to_char(to_number((select max(b.cha_seq) from car_change b where a.car_mng_id = b.car_mng_id))-1)) cg, \n"+
					"	     (SELECT a.car_mng_id CAR_MNG_ID, a.seq SEQ, a.actn_st ACTN_ST, a.actn_dt ACTN_DT, a.damdang_id DAMDANG_ID, a.hp_pr HP_PR, a.st_pr ST_PR, a.nak_pr NAK_PR, a.o_s_amt, a.actn_jum FROM auction a WHERE a.seq = (select max(seq) from auction where car_mng_id = a.car_mng_id)) uc, \n"+
					"		( SELECT a.car_mng_id CAR_MNG_ID, SUM(a.out_amt) AS out_amt FROM auction a WHERE a.CHOI_ST = '1'  GROUP BY a.car_mng_id) uc2,"+
					"        (select ir.car_mng_id, ic.ins_com_nm, ir.ins_exp_dt, ir.ins_sts from insur ir, ins_com ic where ir.ins_com_id = ic.ins_com_id and ir.ins_st = (select max(ins_st) from insur where car_mng_id = ir.car_mng_id)) iu \n"+
				    " , (SELECT DISTINCT a.car_mng_id, b.tot_amt, b.cust_amt FROM accident a, (SELECT car_mng_id, sum(tot_amt) tot_amt, sum(cust_amt) cust_amt FROM service WHERE accid_id IS NOT null GROUP BY car_mng_id  ) b  WHERE a.car_mng_id = b.car_mng_id(+) AND a.accid_st <> '1' ) e2 \n"+
 			        " , (select car_mng_id, count(0) as a_cnt from accident where accid_st='6' group by car_mng_id) ak \n"+ //침수
					" , (select car_mng_id, req_dt from ins_cls where exp_st='3' and exp_aim='3') ic \n"+ //보험청구
					" , (  select a.car_mng_id from cont a, commi c where  a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd and a.car_gu='2'  and c.agnt_st = '6'   AND a.car_mng_id IS NOT NULL  group by a.car_mng_id )  sss   \n"+		
   			        " where r.off_ls = '5' and r.car_mng_id = c.car_mng_id \n"+
					"  and e.rent_mng_id = c.rent_mng_id \n"+
					"  and e.rent_l_cd = c.rent_l_cd \n"+
					"  and r.car_mng_id = sq.car_mng_id(+) \n"+
					"  and c.car_st = '2' \n"+
					"  and c.use_yn = 'Y' \n"+
					"  and r.car_mng_id = i.car_mng_id(+) \n"+
					"  and c.rent_mng_id = bk.rent_mng_id(+) \n"+
					"  and c.rent_l_cd = bk.rent_l_cd(+) \n"+
					"  and r.car_mng_id = s.car_mng_id(+) \n"+
			//		"  and r.car_mng_id = ch.car_mng_id(+) \n"+
					"  AND r.car_mng_id = sw.car_mng_id(+) \n"+
				//	"  AND c.rent_mng_id = t.rent_mng_id(+) \n"+
					"  AND r.car_mng_id = cg.car_mng_id(+) \n"+
					"  AND e.car_id = m.car_id \n"+	
					"  and e.car_seq = m.car_seq \n"+
					"  and m.car_comp_id = n.car_comp_id \n"+
					"  and m.car_cd = n.code \n"+
					"  and r.car_mng_id = vt.car_mng_id(+) \n"+
					"  and r.car_mng_id = uc.car_mng_id(+) \n"+
					"  and r.car_mng_id = uc2.car_mng_id(+) \n"+
					"  and r.car_mng_id = iu.car_mng_id(+) \n"+
					"  and r.car_mng_id = su.car_mng_id(+) AND su.CAR_MNG_ID = se.CAR_MNG_ID(+) \n"+
  				    "  AND sq.car_mng_id = e2.car_mng_id(+) "+
  			        "  and r.car_mng_id = ak.car_mng_id(+) "+
  			        "  and r.car_mng_id = ic.car_mng_id(+) "+
  			        	" and r.car_mng_id=sss.car_mng_id(+) \n"+
  			     	 "  and r.park = cd.nm_cd(+) \n"+  //주차장 코드 테이블 
					dt_query + 	su_query +
			//		"  AND c.rent_l_cd = t.rent_l_cd(+) "
					subQuery +
					" ORDER BY r.off_ls, uc.actn_dt desc, s.actn_id,  r.car_nm, r.init_reg_dt, r.car_mng_id ";
		}


		Collection<Offls_cmpltBean> col = new ArrayList<Offls_cmpltBean>();

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();

 
			while(rs.next()){
				col.add(makeOffls_cmpltBean(rs));
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_cmpltDatabase:getCmplt_lst(String gubun, String gubun_nm)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return (Offls_cmpltBean[])col.toArray(new Offls_cmpltBean[0]);
		}		
	}

	/**
	*	매각진행차량 검색 - 2003.05.12.Mon.
	*	- gubun : 차량번호, 차량명, 최초등록일
	*	- gubun_nm : 해당 데이타
	*/
	public Offls_cmpltBean[] getCmplt_lst(String dt, String ref_dt1, String ref_dt2, String gubun, String gubun_nm,String brch_id, String s_au){
		getConnection();

		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String query = "";
		String subQuery = "";
		String dt_query = "";  
		String su_query = "";  
			
		String s_dt2 = "to_char(sysdate,'YYYYMM')";
		String s_dt3 = "between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')";


		//디폴트 기간-일자없음 -> 현재 낙찰상태
		if(dt.equals("2"))								dt_query = " and uc.actn_dt like "+s_dt2+"||'%' \n";
		else if(dt.equals("3") && !ref_dt1.equals(""))	dt_query = " and uc.actn_dt "+s_dt3+" \n";

					
		if(gubun.equals("car_no")){
			subQuery = " and ( r.car_no like '%" + gubun_nm +"%' or nvl(r.first_car_no, ' ') like '%"+ gubun_nm +"%') \n";
		}else if(gubun.equals("car_nm")){
			subQuery = " and r.car_nm like '%" + gubun_nm.toUpperCase() + "%' \n";
		}else if(gubun.equals("init_reg_dt")){
			subQuery = " and r.init_reg_dt like ''||replace('"+ gubun_nm +"','-','')||'%' \n";
		}else if(gubun.equals("actn_nm")){
			subQuery = " and s.firm_nm like '%" + gubun_nm.toUpperCase() + "%' \n";
		}else{ //all
			subQuery = "";
		}


		if(!brch_id.equals(""))	subQuery += " and c.brch_id='"+brch_id+"' \n";


		//경매장
		if(!s_au.equals(""))				su_query = " and s.actn_id ='" + s_au + "' \n";

		
		
		
		if(gubun.equals("car_no")){
			query = " select uc2.out_amt, se.COMM1_SUP,se.COMM1_VAT, (se.COMM1_SUP + se.COMM1_VAT) COMM1_TOT, \n"+
					"        se.COMM2_SUP,se.COMM2_VAT, (se.COMM2_SUP + se.COMM2_VAT) COMM2_TOT, \n"+
					"        se.COMM3_SUP,se.COMM3_VAT, (se.COMM3_SUP + se.COMM3_VAT) COMM3_TOT, \n"+
					"        ((se.COMM1_SUP + se.COMM1_VAT)+(se.COMM2_SUP + se.COMM2_VAT)+(se.COMM3_SUP + se.COMM3_VAT)) AS comm_tot,  \n"+
					"        r.car_mng_id CAR_MNG_ID, r.car_no CAR_NO, cg.car_no CAR_PRE_NO, cg.cha_dt CHA_DT, r.car_num CAR_NUM, r.init_reg_dt	INIT_REG_DT, r.car_kd CAR_KD, r.car_use	CAR_USE, \n"+
					"        n.car_nm CAR_JNM, m.car_name CAR_NM, r.car_form CAR_FORM, r.car_y_form	CAR_Y_FORM,	r.dpm DPM, r.fuel_kd FUEL_KD, r.maint_st_dt	MAINT_ST_DT, r.maint_end_dt	MAINT_END_DT, \n"+
					"        r.test_st_dt TEST_ST_DT, r.test_end_dt TEST_END_DT, r.car_l_cd CAR_L_CD, e.rent_mng_id	RENT_MNG_ID, e.rent_l_cd RENT_L_CD,	e.car_id CAR_ID, e.colo COLO, e.opt OPT, \n"+
					"        e.lpg_yn LPG_YN, e.car_cs_amt CAR_CS_AMT, e.car_cv_amt	CAR_CV_AMT,	e.car_fs_amt CAR_FS_AMT, e.car_fv_amt CAR_FV_AMT, \n"+
					"        e.opt_cs_amt OPT_CS_AMT, e.opt_cv_amt OPT_CV_AMT, e.opt_fs_amt	OPT_FS_AMT,	e.opt_fv_amt OPT_FV_AMT, e.clr_cs_amt CLR_CS_AMT, \n"+
					"        e.clr_cv_amt CLR_CV_AMT, e.clr_fs_amt	CLR_FS_AMT, e.clr_fv_amt CLR_FV_AMT, \n"+
					"        e.sd_cs_amt SD_CS_AMT, e.sd_cv_amt SD_CV_AMT, e.sd_fs_amt SD_FS_AMT, e.sd_fv_amt SD_FV_AMT, \n"+
					"        e.dc_cs_amt DC_CS_AMT, e.dc_cv_amt DC_CV_AMT, e.dc_fs_amt DC_FS_AMT, e.dc_fv_amt DC_FV_AMT, c.mng_id MNG_ID, c.dlv_dt DLV_DT, \n"+
					"        decode(r.car_mng_id, sq.car_mng_id, 1, 0) ACCIDENT_YN, \n"+
					"        vt.tot_dist TOT_DIST, \n"+
					"        decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD'))))) as AVERAGE_DIST, \n"+
					"        decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST, \n"+
					"        bk.bank_nm BANK_NM, bk.lend_prn LEND_PRN, sw.alt_rest	LEND_REM, bk.alt_end_dt ALT_END_DT, s.lev LEV, s.reason REASON, s.car_st CAR_ST, \n"+
					"        s.imgfile1 IMGFILE1, s.imgfile2 IMGFILE2, s.imgfile3 IMGFILE3, s.imgfile4 IMGFILE4, s.imgfile5 IMGFILE5, \n"+
					"        s.km, uc.damdang_id DETERM_ID, uc.hp_pr HPPR, uc.st_pr STPR, uc.nak_pr NAK_PR, \n"+
					"        s.damdang_id DAMDANG_ID, s.modify_id MODIFY_ID, s.apprsl_dt APPRSL_DT, DECODE(r.car_mng_id, ch.car_mng_id, 1, 0) CAR_CHA_YN, t.cltr_amt CLTR_AMT, \n"+
					"        r.off_ls OFF_LS, uc.actn_st ACTN_ST, s.actn_id ACTN_ID , s.actn_wh ACTN_WH, \n"+
					"        iu.ins_com_nm INS_COM_NM, iu.ins_exp_dt INS_EXP_DT, uc.actn_dt ACTN_DT, su.sui_nm ,\n"+
					"        '' P_RENT_MNG_ID, '' P_RENT_L_CD, '' P_RPT_NO, '' P_CAR_NO, '' P_DLV_DT,  '' P_CAR_OFF_NM, '' P_EMP_ID, '' P_EMP_NM, uc.o_s_amt, 0 hp_s_cha_amt, 0 hp_accid_amt, "+
					"        r.park_nm, 0 a_cnt, '' car_old_mons, uc.actn_jum, e.in_col, m.jg_code, '' req_dt , su.cont_dt , su.jan_pr_dt  , '' sss  \n" +
					" from   car_reg r, car_etc e, cont c,  apprsl  s, cltr t,  CAR_NM m, CAR_MNG n, v_tot_dist vt, sui su, SUI_ETC se, \n"+
					"	     (select distinct ac.car_mng_id CAR_MNG_ID from accident ac, car_reg re where ac.car_mng_id=re.car_mng_id) sq, \n"+
					"	     (select a.car_mng_id CAR_MNG_ID, a.serv_dt SERV_DT, a.tot_dist TOT_DIST  from service a where a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where car_mng_id = a.car_mng_id)) i, \n"+
					"	     (select al.rent_mng_id RENT_MNG_ID, al.rent_l_cd RENT_L_CD, cd.nm BANK_NM, al.lend_prn LEND_PRN, al.alt_end_dt ALT_END_DT from allot al, code cd where al.cpt_cd = cd.code and cd.c_st = '0003') bk, \n"+
					"	     (SELECT DISTINCT cc.car_mng_id CAR_MNG_ID FROM car_cha cc, car_reg re WHERE cc.car_mng_id = re.car_mng_id) ch, \n"+
					"	     (SELECT sc.car_mng_id CAR_MNG_ID, sc.alt_rest ALT_REST FROM scd_alt_case sc WHERE sc.alt_tm = (select max(alt_tm) from scd_alt_case where car_mng_id = sc.car_mng_id)) sw, \n"+
					"	     (SELECT car_mng_id, cha_dt, car_no FROM car_change a WHERE a.cha_seq = to_char(to_number((select max(b.cha_seq) from car_change b where a.car_mng_id = b.car_mng_id))-1)) cg, \n"+
					"	     (SELECT a.car_mng_id CAR_MNG_ID, a.seq SEQ, a.actn_st ACTN_ST, a.actn_dt ACTN_DT, a.damdang_id DAMDANG_ID, a.hp_pr HP_PR, a.st_pr ST_PR, a.nak_pr NAK_PR, a.o_s_amt, a.actn_jum FROM auction a WHERE a.seq = (select max(seq) from auction where car_mng_id = a.car_mng_id)) uc, \n"+
					"		( SELECT a.car_mng_id CAR_MNG_ID, SUM(a.out_amt) AS out_amt FROM auction a WHERE a.CHOI_ST = '1'  GROUP BY a.car_mng_id) uc2, "+
					"        (select ir.car_mng_id CAR_MNG_ID, ic.ins_com_nm INS_COM_NM, ir.ins_exp_dt INS_EXP_DT from insur ir, ins_com ic where ir.ins_com_id = ic.ins_com_id and ir.ins_st = (select max(ins_st) from insur where car_mng_id = ir.car_mng_id)) iu \n"+
					"  where r.car_mng_id = c.car_mng_id \n"+
					"  and e.rent_mng_id = c.rent_mng_id \n"+
					"  and e.rent_l_cd = c.rent_l_cd \n"+
					"  and r.car_mng_id = sq.car_mng_id(+) \n"+
					"  and c.car_st = '2' \n"+
					"  and c.use_yn = 'Y' \n"+
					"  and r.off_ls = '5' \n"+
					"  and r.car_mng_id = i.car_mng_id(+) \n"+
					"  and c.rent_mng_id = bk.rent_mng_id(+) \n"+
					"  and c.rent_l_cd = bk.rent_l_cd(+) \n"+
					"  and r.car_mng_id = s.car_mng_id(+) \n"+
					"  and r.car_mng_id = ch.car_mng_id(+) \n"+
					"  AND r.car_mng_id = sw.car_mng_id(+) \n"+
					"  AND c.rent_mng_id = t.rent_mng_id(+) \n"+
					"  AND c.rent_l_cd = t.rent_l_cd(+) \n"+	
					"  AND r.car_mng_id = cg.car_mng_id(+) \n"+
					"  AND e.car_id = m.car_id \n"+	
					"  and e.car_seq = m.car_seq \n"+
					"  and m.car_comp_id = n.car_comp_id \n"+
					"  and m.car_cd = n.code \n"+
					"  and r.car_mng_id = vt.car_mng_id(+) \n"+
					"  and r.car_mng_id = uc.car_mng_id(+) \n"+
					"  and r.car_mng_id = uc2.car_mng_id(+) \n"+
					"  and r.car_mng_id = iu.car_mng_id(+) \n"+
					"  and r.car_mng_id = su.car_mng_id(+) AND su.CAR_MNG_ID = se.CAR_MNG_ID(+) \n "+
					dt_query + 	su_query +
					subQuery +
					" ORDER BY r.off_ls, uc.actn_dt desc, r.car_nm, r.init_reg_dt, r.car_mng_id ";
		}else{
			query = " select uc2.out_amt, se.COMM1_SUP,se.COMM1_VAT, (se.COMM1_SUP + se.COMM1_VAT) COMM1_TOT, \n"+
					"        se.COMM2_SUP,se.COMM2_VAT, (se.COMM2_SUP + se.COMM2_VAT) COMM2_TOT, \n"+
					"        se.COMM3_SUP,se.COMM3_VAT, (se.COMM3_SUP + se.COMM3_VAT) COMM3_TOT, \n"+
					"        ((se.COMM1_SUP + se.COMM1_VAT)+(se.COMM2_SUP + se.COMM2_VAT)+(se.COMM3_SUP + se.COMM3_VAT)) AS comm_tot,  \n"+
					"        r.car_mng_id CAR_MNG_ID, r.car_no CAR_NO, cg.car_no CAR_PRE_NO, cg.cha_dt CHA_DT, r.car_num CAR_NUM, r.init_reg_dt	INIT_REG_DT, r.car_kd CAR_KD, r.car_use	CAR_USE, \n"+
					"        n.car_nm CAR_JNM, m.car_name CAR_NM, r.car_form CAR_FORM, r.car_y_form	CAR_Y_FORM,	r.dpm DPM, r.fuel_kd FUEL_KD, \n"+
					"        r.maint_st_dt	MAINT_ST_DT, r.maint_end_dt	MAINT_END_DT, r.test_st_dt TEST_ST_DT, r.test_end_dt TEST_END_DT, \n"+
					"        r.car_l_cd CAR_L_CD, e.rent_mng_id	RENT_MNG_ID, e.rent_l_cd RENT_L_CD,	e.car_id CAR_ID, e.colo COLO, e.opt OPT, e.lpg_yn LPG_YN, \n"+
					"        e.car_cs_amt CAR_CS_AMT, e.car_cv_amt CAR_CV_AMT, e.car_fs_amt	CAR_FS_AMT,	e.car_fv_amt CAR_FV_AMT, \n"+
					"        e.opt_cs_amt OPT_CS_AMT, e.opt_cv_amt OPT_CV_AMT, e.opt_fs_amt	OPT_FS_AMT,	e.opt_fv_amt OPT_FV_AMT, \n"+
					"        e.clr_cs_amt CLR_CS_AMT, e.clr_cv_amt CLR_CV_AMT, e.clr_fs_amt	CLR_FS_AMT,	e.clr_fv_amt CLR_FV_AMT, \n"+
					"        e.sd_cs_amt SD_CS_AMT,	e.sd_cv_amt SD_CV_AMT, e.sd_fs_amt SD_FS_AMT, e.sd_fv_amt SD_FV_AMT, \n"+
					"        e.dc_cs_amt DC_CS_AMT,	e.dc_cv_amt DC_CV_AMT, e.dc_fs_amt DC_FS_AMT, e.dc_fv_amt DC_FV_AMT, \n"+
					"        c.mng_id MNG_ID, c.dlv_dt DLV_DT, decode(r.car_mng_id, sq.car_mng_id, 1, 0) ACCIDENT_YN, \n"+
					"        vt.tot_dist TOT_DIST, \n"+
					"        decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD'))))) as AVERAGE_DIST, \n"+
					"        decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST, \n "+
					"        bk.bank_nm BANK_NM, bk.lend_prn LEND_PRN, sw.alt_rest	LEND_REM, bk.alt_end_dt ALT_END_DT, s.lev LEV, s.reason REASON, s.car_st CAR_ST, \n"+
					"        s.imgfile1 IMGFILE1, s.imgfile2 IMGFILE2, s.imgfile3 IMGFILE3, s.imgfile4 IMGFILE4, s.imgfile5 IMGFILE5, \n"+
					"        s.km, uc.damdang_id DETERM_ID, uc.hp_pr HPPR, uc.st_pr STPR, uc.nak_pr NAK_PR, \n"+
					"        s.damdang_id DAMDANG_ID, s.modify_id MODIFY_ID, s.apprsl_dt APPRSL_DT, \n"+
					"        DECODE(r.car_mng_id, ch.car_mng_id, 1, 0) CAR_CHA_YN, t.cltr_amt CLTR_AMT, r.off_ls OFF_LS, uc.actn_st ACTN_ST, s.actn_id ACTN_ID, s.actn_wh ACTN_WH, \n"+
					"        iu.ins_com_nm INS_COM_NM, iu.ins_exp_dt INS_EXP_DT, uc.actn_dt ACTN_DT, su.sui_nm, \n"+
					"        '' P_RENT_MNG_ID, '' P_RENT_L_CD, '' P_RPT_NO, '' P_CAR_NO, '' P_DLV_DT,  '' P_CAR_OFF_NM, '' P_EMP_ID, '' P_EMP_NM, uc.o_s_amt, 0 hp_s_cha_amt, 0 hp_accid_amt, "+
					"        r.park_nm, 0 a_cnt, '' car_old_mons, uc.actn_jum, e.in_col, m.jg_code, '' req_dt  , su.cont_dt, su.jan_pr_dt , '' sss \n"+
					" from   car_reg r, car_etc e, cont c,  apprsl s, cltr t,  CAR_NM m, CAR_MNG n, v_tot_dist vt, sui su, SUI_ETC se, \n "+
					"	     (select distinct ac.car_mng_id CAR_MNG_ID from accident ac, car_reg re where ac.car_mng_id=re.car_mng_id) sq, \n"+
					"	     (select a.car_mng_id CAR_MNG_ID, a.serv_dt SERV_DT, a.tot_dist TOT_DIST  from service a where a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where car_mng_id = a.car_mng_id)) i, \n"+
					"	     (select al.rent_mng_id RENT_MNG_ID, al.rent_l_cd RENT_L_CD, cd.nm BANK_NM, al.lend_prn LEND_PRN, al.alt_end_dt ALT_END_DT from allot al, code cd where al.cpt_cd = cd.code and cd.c_st = '0003') bk, \n"+
					"	     (SELECT DISTINCT cc.car_mng_id CAR_MNG_ID FROM car_cha cc, car_reg re WHERE cc.car_mng_id = re.car_mng_id) ch, \n"+
					"	     (SELECT sc.car_mng_id CAR_MNG_ID, sc.alt_rest ALT_REST FROM scd_alt_case sc WHERE sc.alt_tm = (select max(alt_tm) from scd_alt_case where car_mng_id = sc.car_mng_id)) sw, \n "+
					"	     (SELECT car_mng_id, cha_dt, car_no FROM car_change a WHERE a.cha_seq = to_char(to_number((select max(b.cha_seq) from car_change b where a.car_mng_id = b.car_mng_id))-1)) cg, \n"+
					"	     (SELECT a.car_mng_id CAR_MNG_ID, a.seq SEQ, a.actn_st ACTN_ST, a.actn_dt ACTN_DT, a.damdang_id DAMDANG_ID, a.hp_pr HP_PR, a.st_pr ST_PR, a.nak_pr NAK_PR, a.o_s_amt, a.actn_jum FROM auction a WHERE a.seq = (select max(seq) from auction where car_mng_id = a.car_mng_id)) uc, \n"+
					"		( SELECT a.car_mng_id CAR_MNG_ID, SUM(a.out_amt) AS out_amt FROM auction a WHERE a.CHOI_ST = '1'  GROUP BY a.car_mng_id) uc2,"+
					"        (select ir.car_mng_id CAR_MNG_ID, ic.ins_com_nm INS_COM_NM, ir.ins_exp_dt INS_EXP_DT from insur ir, ins_com ic where ir.ins_com_id = ic.ins_com_id and ir.ins_st = (select max(ins_st) from insur where car_mng_id = ir.car_mng_id)) iu \n"+
					" where r.car_mng_id = c.car_mng_id \n"+
					"  and e.rent_mng_id = c.rent_mng_id \n"+
					"  and e.rent_l_cd = c.rent_l_cd \n"+
					"  and r.car_mng_id = sq.car_mng_id(+) \n"+
					"  and c.car_st = '2' \n"+
					"  and c.use_yn = 'Y' \n"+
					"  and r.off_ls = '5' \n"+
					"  and r.car_mng_id = i.car_mng_id(+) \n"+
					"  and c.rent_mng_id = bk.rent_mng_id(+) \n"+
					"  and c.rent_l_cd = bk.rent_l_cd(+) \n"+
					"  and r.car_mng_id = s.car_mng_id(+) \n"+
					"  and r.car_mng_id = ch.car_mng_id(+) \n"+
					"  AND r.car_mng_id = sw.car_mng_id(+) \n"+
					"  AND c.rent_mng_id = t.rent_mng_id(+) \n"+
					"  AND r.car_mng_id = cg.car_mng_id(+) \n"+
					"  AND e.car_id = m.car_id \n"+	
					"  and e.car_seq = m.car_seq \n"+
					"  and m.car_comp_id = n.car_comp_id \n"+
					"  and m.car_cd = n.code \n"+
					"  and r.car_mng_id = vt.car_mng_id(+) \n"+
					"  and r.car_mng_id = uc.car_mng_id(+) \n"+
					"  and r.car_mng_id = uc2.car_mng_id(+) \n"+
					"  and r.car_mng_id = iu.car_mng_id(+) \n"+
					"  and r.car_mng_id = su.car_mng_id(+) AND su.CAR_MNG_ID = se.CAR_MNG_ID(+) \n"+
					dt_query + 	su_query +
					"  AND c.rent_l_cd = t.rent_l_cd(+) "+subQuery +
					" ORDER BY r.off_ls, uc.actn_dt desc, r.car_nm, r.init_reg_dt, r.car_mng_id ";
		}


		Collection<Offls_cmpltBean> col = new ArrayList<Offls_cmpltBean>();

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();


			while(rs.next()){
				col.add(makeOffls_cmpltBean(rs));
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_cmpltDatabase:getCmplt_lst(String gubun, String gubun_nm)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return (Offls_cmpltBean[])col.toArray(new Offls_cmpltBean[0]);
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
			System.out.println("[Offls_cmpltDatabase:getAuction_maxSeq(String car_mng_id)]"+e);
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
	*	경매낙찰현황
	*/

	public Vector getCmplt_stat_lst(String dt, String ref_dt1, String ref_dt2, String gubun, String gubun1, String gubun2, String gubun3, String gubun_nm, String brch_id, String s_au, String deep_yn){
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		

		query = " SELECT a.car_mng_id, uc.out_amt,  \n"+
				"		 nvl(e2.tot_amt,0) hap_amt, "+
				"		 cg.car_no as car_pre_no, "+
				"        DECODE(NVL(e2.tot_amt,0),0,0,ROUND((e2.tot_amt*100)/(d.car_cs_amt+d.car_cv_amt+d.opt_cs_amt+d.opt_cv_amt+d.clr_cs_amt+d.clr_cv_amt),2)) se_per, \n"+
				"        a.car_no, A.CAR_NM||' '||e.car_name as car_nm, a.init_reg_dt,  \n"+
				"        b.client_id, b.firm_nm, s.actn_wh, uc.seq, uc.actn_dt,  \n"+
				"        (d.car_cs_amt+d.car_cv_amt+d.opt_cs_amt+d.opt_cv_amt+d.clr_cs_amt+d.clr_cv_amt) car_c_amt, \n"+
				"        (d.car_fs_amt+d.car_fv_amt+d.sd_cs_amt+d.sd_cv_amt-d.dc_cs_amt-d.dc_cv_amt) car_f_amt, \n"+
				"        (d.opt_cs_amt+d.opt_cv_amt) opt_amt, \n"+
				"        uc.o_s_amt as car_s_amt, uc.hp_pr, su.mm_pr nak_pr, \n"+   //경매 계약정보에서 
                "        (uc.nak_pr-uc.o_s_amt) hp_s_cha_amt, "+ 
                "        abs(uc.nak_pr-uc.o_s_amt) abs_hp_s_cha_amt, "+ 
				"        decode(nvl(uc.nak_pr,0),0,0,ROUND((uc.nak_pr*100)/(d.car_cs_amt+d.car_cv_amt+d.opt_cs_amt+d.opt_cv_amt+d.clr_cs_amt+d.clr_cv_amt),2)) hp_c_per, \n"+
				"        decode(nvl(uc.nak_pr,0),0,0,ROUND((uc.nak_pr*100)/(d.car_fs_amt+d.car_fv_amt+d.sd_cs_amt+d.sd_cv_amt-d.dc_cs_amt-d.dc_cv_amt),2)) hp_f_per, \n"+
				"        decode(nvl(uc.nak_pr,0),0,0,decode(nvl(uc.o_s_amt,0),0,0,ROUND((uc.nak_pr*100)/uc.o_s_amt,2))) hp_s_per, \n"+ 
				"        decode(nvl(uc.nak_pr,0),0,0,decode(nvl(uc.o_s_amt,0),0,0,ROUND((uc.nak_pr-uc.o_s_amt)/uc.o_s_amt*100,2))) hp_s_cha_per, \n"+ 
				"        decode(nvl(uc.nak_pr,0),0,0,decode(nvl(uc.o_s_amt,0),0,0,ROUND((uc.nak_pr-uc.o_s_amt)/(d.car_cs_amt+d.car_cv_amt+d.opt_cs_amt+d.opt_cv_amt+d.clr_cs_amt+d.clr_cv_amt)*100,2))) hp_c_cha_per, \n"+ 
				"        decode(nvl(uc.nak_pr,0),0,0,decode(nvl(uc.o_s_amt,0),0,0,ROUND(abs(uc.nak_pr-uc.o_s_amt)/uc.o_s_amt*100,2))) abs_hp_s_cha_per, \n"+ 
				"        decode(nvl(uc.nak_pr,0),0,0,decode(nvl(uc.o_s_amt,0),0,0,ROUND(abs(uc.nak_pr-uc.o_s_amt)/(d.car_cs_amt+d.car_cv_amt+d.opt_cs_amt+d.opt_cv_amt+d.clr_cs_amt+d.clr_cv_amt)*100,2))) abs_hp_c_cha_per, \n"+ 
				"        (se.comm1_sup + se.comm1_vat) comm1_tot, \n"+
				" 	     (se.comm2_sup + se.comm2_vat) comm2_tot, \n"+
				" 	     (se.comm3_sup + se.comm3_vat) comm3_tot, \n"+
				" 	     (se.comm1_sup + se.comm1_vat+se.comm2_sup + se.comm2_vat+se.comm3_sup + se.comm3_vat) AS comm_tot, \n"+
				"        su.sui_nm, s.km, decode(sq.car_mng_id,'','무','유') accid_yn, d.opt, d.colo, \n"+
				"        a.dpm, f.nm as fuel_kd, e.jg_code, \n"+
				"        nvl(ak.a_cnt,0) a_cnt, TRUNC(MONTHS_BETWEEN(TO_DATE(uc.actn_dt,'YYYYMMDD'), TO_DATE(a.init_reg_dt,'YYYYMMDD')),1) car_old_mons, \n"+  //침수여부
				"        decode(a.park,'6',substr(a.park_cont,1,5),nvl(cd.nm,a.park)) park_nm, \n"+
				"        uc.actn_jum, d.in_col, decode(sss.car_mng_id, null , '', 'Y' ) sss , \n"+
				"        decode(su.migr_no,'수출말소','수출말소','자진말소수출','수출말소', '','미입력','이전등록') as migr_stat, "+	//명의이전구분 (20180717)
				"		 a.car_y_form, uc.actn_rsn, decode(nvl(ak.a_cnt,0),'0','','Y') as a_cnt_yn, DECODE(a.DIST_CNG,'','','Y') AS dist_cng_yn, uc.seq-1 AS offer_cnt, "+	//추가 (20181207)

                "        (uc.nak_pr-nvl(uc.deep_car_amt1,0)) hp_s_cha_amt2, "+ 
                "        abs(uc.nak_pr-nvl(uc.deep_car_amt1,0)) abs_hp_s_cha_amt2, "+ 
				"        decode(nvl(uc.nak_pr,0),0,0,decode(nvl(uc.deep_car_amt1,0),0,0,ROUND((uc.nak_pr*100)/uc.deep_car_amt1,2))) hp_s_per2, \n"+ 
				"        decode(nvl(uc.nak_pr,0),0,0,decode(nvl(uc.deep_car_amt1,0),0,0,ROUND((uc.nak_pr-uc.deep_car_amt1)/uc.deep_car_amt1*100,2))) hp_s_cha_per2, \n"+ 
				"        decode(nvl(uc.nak_pr,0),0,0,decode(nvl(uc.deep_car_amt1,0),0,0,ROUND((uc.nak_pr-uc.deep_car_amt1)/(d.car_cs_amt+d.car_cv_amt+d.opt_cs_amt+d.opt_cv_amt+d.clr_cs_amt+d.clr_cv_amt)*100,2))) hp_c_cha_per2, \n"+ 
				"        decode(nvl(uc.nak_pr,0),0,0,decode(nvl(uc.deep_car_amt1,0),0,0,ROUND(abs(uc.nak_pr-uc.deep_car_amt1)/uc.deep_car_amt1*100,2))) abs_hp_s_cha_per2, \n"+ 
				"        decode(nvl(uc.nak_pr,0),0,0,decode(nvl(uc.deep_car_amt1,0),0,0,ROUND(abs(uc.nak_pr-uc.deep_car_amt1)/(d.car_cs_amt+d.car_cv_amt+d.opt_cs_amt+d.opt_cv_amt+d.clr_cs_amt+d.clr_cv_amt)*100,2))) abs_hp_c_cha_per2, \n"+ 
                
				"        nvl(uc.deep_car_amt1,0) deep_car_amt1, nvl(uc.deep_car_amt2,0) deep_car_amt2, nvl(uc.deep_car_amt3,0) deep_car_amt3, nvl(uc.deep_car_amt4,0) deep_car_amt4, \n"+
				"        nvl(uc.deep_car_amt5,0) deep_car_amt5, nvl(uc.deep_car_amt6,0) deep_car_amt6, nvl(uc.deep_car_amt7,0) deep_car_amt7, nvl(uc.deep_car_amt8,0) deep_car_amt8  \n"+
				
				" FROM   CAR_REG a, APPRSL s, AUCTION uc, CLIENT b, CONT c,  \n"+
				"        ( select c_st, code, nm_cd, nm from code where c_st = '0027' and code <> '0000'  ) cd,  \n"+  //주차장 
				"        (SELECT car_mng_id, max(rent_start_dt) rent_start_dt, max(reg_dt) reg_dt FROM CONT WHERE car_st='2' GROUP BY car_mng_id) c2, \n"+
				"        CAR_ETC d, CAR_NM e, sui su, SUI_ETC se, \n"+
				"	     (select car_mng_id, COUNT(0) accid_cnt from accident group by car_mng_id) sq, \n"+
				"        (SELECT CAR_MNG_ID, sum(tot_amt) tot_amt FROM (SELECT  a.car_mng_id, b.tot_amt tot_amt FROM ACCIDENT a, SERVICE b, cont c \r\n" + 
				"        WHERE 1=1 AND a.car_mng_id=b.car_mng_id AND a.accid_id=b.accid_id AND b.tot_amt>0 AND a.rent_mng_id=c.rent_mng_id AND a.rent_l_cd=c.rent_l_cd  AND b.serv_st NOT IN ('7','12')  \r\n" + 
				"	     UNION ALL SELECT  a.CAR_MNG_ID ,b.accid_serv_amt tot_amt FROM    cont a, car_etc b WHERE 1=1 AND a.car_gu='2' and a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd AND nvl(b.accid_serv_amt,0)>0 )GROUP BY car_mng_id ) e2, \n"+
				"        (select car_mng_id, count(0) as a_cnt from accident where accid_st='6' group by car_mng_id) ak, \n"+ //침수
				" 		 (select a.car_mng_id from cont a, commi c where  a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd and a.car_gu='2'  and c.agnt_st = '6'   AND a.car_mng_id IS NOT NULL  group by a.car_mng_id )  sss ,   \n"+  //자산양수차량 
				"        (select sh_code, MAX(jg_2) jg_2, MAX(jg_b) jg_b from esti_jg_var GROUP BY sh_code) ej, "+
				"		 (SELECT car_mng_id, cha_dt, car_no FROM car_change a WHERE a.cha_seq = to_char(to_number((select max(b.cha_seq) from car_change b where a.car_mng_id = b.car_mng_id))-1)) cg, \n"+
				"        (select * from code where c_st='0039') f \n"+
				" WHERE  a.off_ls IN ('5','6')  \n"+
				"        AND a.car_mng_id=s.car_mng_id \n"+
				"        AND a.car_mng_id=uc.car_mng_id AND uc.actn_st='4' \n"+
				"        AND s.actn_id=b.client_id \n"+
				"        AND a.car_mng_id=c.car_mng_id \n"+
				"        AND c.car_st='2' \n"+
				"        AND c.car_mng_id=c2.car_mng_id AND c.rent_start_dt=c2.rent_start_dt AND c.reg_dt=c2.reg_dt \n"+
				"        AND c.rent_mng_id=d.rent_mng_id AND c.rent_l_cd=d.rent_l_cd \n"+
				"        AND d.car_id=e.car_id AND d.car_seq=e.car_seq \n"+
				"        AND a.car_mng_id=su.car_mng_id \n"+
				"        AND a.car_mng_id=se.car_mng_id(+) \n"+
				"        AND a.car_mng_id=sq.car_mng_id(+) \n"+
				"		 AND a.car_mng_id=sss.car_mng_id(+) "+
				"		 AND sq.car_mng_id=e2.car_mng_id(+) "+
				"        and a.car_mng_id = ak.car_mng_id(+) "+
				"        AND a.car_mng_id = cg.car_mng_id(+) "+
				"        and a.park = cd.nm_cd(+) \n"+  //주차장 코드 테이블 
				"        and e.jg_code = ej.sh_code(+) "+
				"        and a.fuel_kd = f.nm_cd \n"+				
				" ";

		
		String s_dt3 = "like replace('" + ref_dt1 + "%','-','')";
		String s_dt4 = "between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')";
		
		//디폴트 기간-일자없음 -> 현재 낙찰상태
		if(dt.equals("2")){											
			query += " and uc.actn_dt like to_char(sysdate,'YYYYMM')||'%' \n";
		} else if (dt.equals("4")){  //당해 											
				query += " and uc.actn_dt like to_char(sysdate,'YYYY')||'%' \n";	
		}else if(dt.equals("3")){
			if(!ref_dt1.equals("") && ref_dt2.equals("")){
				query += " and uc.actn_dt "+s_dt3+" \n";
			}else if(!ref_dt1.equals("") && !ref_dt2.equals("")){
				query += " and uc.actn_dt "+s_dt4+" \n";
			}else if(ref_dt1.equals("") && ref_dt2.equals("")){
				query += " and a.off_ls='5' \n";
			}
		}else if (dt.equals("1")){
			query += " and uc.actn_dt like to_char(add_months(sysdate, -1), 'YYYYMM')||'%' \n";
		}
		
		//딥러잉미분석(딥러닝예측가 없음)
		if(deep_yn.equals("N")) {
			query += " and (uc.deep_car_amt1 is null or uc.deep_car_amt1=0)";
		//딥러닝분석(딥러닝예측가 있음)	
		}else if(deep_yn.equals("Y")) {
			query += " and uc.deep_car_amt1 > 0 ";
		}


		if(!gubun_nm.equals("")){
			if(gubun.equals("car_no"))					query += " and ( a.car_no like '%" + gubun_nm +"%' or nvl(a.first_car_no, ' ') like '%"+ gubun_nm +"%') \n";
			else if(gubun.equals("car_nm"))				query += " and a.car_nm||e.car_name like '%" + gubun_nm.toUpperCase() + "%' \n";
			else if(gubun.equals("init_reg_dt"))		query += " and a.init_reg_dt like replace('"+ gubun_nm +"','-','')||'%' \n";
			else if(gubun.equals("actn_nm"))			query += " and b.firm_nm like '%" + gubun_nm.toUpperCase() + "%' \n";			
			else if(gubun.equals("jg_code"))			query += " and e.jg_code like '%" + gubun_nm + "%' \n";			
		}

		if(!gubun2.equals("")){//차종구분(소형,중형,대형 ........ 이런것들)
			if(gubun2.equals("1"))			query += " AND decode(e.s_st, '101','100', '102','112', '105','104', decode(substr(e.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', e.s_st)) = '104' AND e.car_comp_id < '0006' \n";
			else if(gubun2.equals("2"))		query += " AND decode(e.s_st, '101','100', '102','112', '105','104', decode(substr(e.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', e.s_st)) = '103' AND e.car_comp_id < '0006' \n";
			else if(gubun2.equals("3"))		query += " AND decode(e.s_st, '101','100', '102','112', '105','104', decode(substr(e.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', e.s_st)) = '112' AND e.car_comp_id < '0006' \n";
			else if(gubun2.equals("4"))		query += " AND decode(e.s_st, '101','100', '102','112', '105','104', decode(substr(e.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', e.s_st)) = '302' AND e.car_comp_id < '0006' \n";			
			else if(gubun2.equals("5"))		query += " AND decode(e.s_st, '101','100', '102','112', '105','104', decode(substr(e.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', e.s_st)) = '301' AND e.car_comp_id < '0006' \n";			
			else if(gubun2.equals("6"))		query += " AND decode(e.s_st, '101','100', '102','112', '105','104', decode(substr(e.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', e.s_st)) = '401' AND e.car_comp_id < '0006' \n";			
			else if(gubun2.equals("7"))		query += " AND decode(e.s_st, '101','100', '102','112', '105','104', decode(substr(e.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', e.s_st)) = '801' AND e.car_comp_id < '0006' \n";
			else if(gubun2.equals("8"))		query += " AND decode(e.s_st, '101','100', '102','112', '105','104', decode(substr(e.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', e.s_st)) = '300' AND e.car_comp_id < '0006' \n";
			else if(gubun2.equals("9"))		query += " AND decode(e.s_st, '101','100', '409','100', '102','112', '105','104', decode(substr(e.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', e.s_st)) = '100' AND e.car_comp_id < '0006' \n";
			else if(gubun2.equals("10"))	query += " AND decode(e.s_st, '101','100', '102','112', '105','104', decode(substr(e.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', e.s_st)) = '701' AND e.car_comp_id < '0006' \n";
			else if(gubun2.equals("20"))	query += " AND e.car_comp_id > '0005' \n";
		}

		//경매장
		if(!s_au.equals(""))				query += " and s.actn_id ='" + s_au + "' \n";

		//휘발유
		if(gubun3.equals("1")){
			query += "AND nvl(ej.jg_2,'0') <>'1' and nvl(ej.jg_b,'0') ='0' \n";
		//경유
		}else if(gubun3.equals("2")){
			query += "AND nvl(ej.jg_2,'0') <>'1' and nvl(ej.jg_b,'0') ='1' \n";
		//일반승용LPG
		}else if(gubun3.equals("3")){
			query += "AND nvl(ej.jg_2,'0') ='1'  and nvl(ej.jg_b,'0') ='2'\n";
		//기타차종LPG
		}else if(gubun3.equals("4")){
			query += "AND nvl(ej.jg_2,'0') <>'1' and nvl(ej.jg_b,'0') ='2' \n";
		}

		//렌트(rt)/리스(ls) 구분
		if(gubun1.equals("rt")){
			query += " and a.car_use = '1' ";
		}else if(gubun1.equals("ls")){
			query += " and a.car_use = '2' ";
		}

		query += " ORDER BY uc.actn_dt desc, A.CAR_NM, a.init_reg_dt, a.car_mng_id \n ";


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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
		    rs.close();
            pstmt.close();	

		}catch(SQLException e){
			System.out.println("[Offls_cmpltDatabase:getCmplt_stat_lst()]"+e);
			System.out.println("[Offls_cmpltDatabase:getCmplt_stat_lst()]"+query);
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

  // 경매낙찰 - xml grid paging
	public Vector getCmplt_stat_lst(String dt, String ref_dt1, String ref_dt2, String gubun, String gubun1, String gubun2, String gubun3, String gubun_nm, String brch_id, String s_au , int page, int  rowsPerPage){
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		
		query = "  SELECT   \n"+
            	" ROW_NUMBER() OVER (ORDER BY uc.actn_dt desc, a.car_mng_id) RNUM,    \n"+    	  
				"  a.car_mng_id, uc.out_amt,  \n"+
				"		 nvl(e2.tot_amt,0) hap_amt, "+
				"        DECODE(NVL(e2.tot_amt,0),0,0,ROUND((e2.tot_amt*100)/(d.car_cs_amt+d.car_cv_amt+d.opt_cs_amt+d.opt_cv_amt+d.clr_cs_amt+d.clr_cv_amt),2)) se_per, \n"+
				"        a.car_no, A.CAR_NM||' '||e.car_name as car_nm, a.init_reg_dt,  \n"+
				"        b.client_id, b.firm_nm, s.actn_wh, uc.seq, uc.actn_dt,  \n"+
				"        (d.car_cs_amt+d.car_cv_amt+d.opt_cs_amt+d.opt_cv_amt+d.clr_cs_amt+d.clr_cv_amt) car_c_amt, \n"+
				"        (d.car_fs_amt+d.car_fv_amt+d.sd_cs_amt+d.sd_cv_amt-d.dc_cs_amt-d.dc_cv_amt) car_f_amt, \n"+
				"        (d.opt_cs_amt+d.opt_cv_amt) opt_amt, \n"+
				"        uc.o_s_amt as car_s_amt, uc.hp_pr, su.mm_pr nak_pr, \n"+   //경매 계약정보에서 
                "        (uc.nak_pr-uc.o_s_amt) hp_s_cha_amt, "+ 
                "        abs(uc.nak_pr-uc.o_s_amt) abs_hp_s_cha_amt, "+ 
				"        decode(nvl(uc.nak_pr,0),0,0,ROUND((uc.nak_pr*100)/(d.car_cs_amt+d.car_cv_amt+d.opt_cs_amt+d.opt_cv_amt+d.clr_cs_amt+d.clr_cv_amt),2)) hp_c_per, \n"+
				"        decode(nvl(uc.nak_pr,0),0,0,ROUND((uc.nak_pr*100)/(d.car_fs_amt+d.car_fv_amt+d.sd_cs_amt+d.sd_cv_amt-d.dc_cs_amt-d.dc_cv_amt),2)) hp_f_per, \n"+
				"        decode(nvl(uc.nak_pr,0),0,0,decode(nvl(uc.o_s_amt,0),0,0,ROUND((uc.nak_pr*100)/uc.o_s_amt,2))) hp_s_per, \n"+ 
				"        decode(nvl(uc.nak_pr,0),0,0,decode(nvl(uc.o_s_amt,0),0,0,ROUND((uc.nak_pr-uc.o_s_amt)/uc.o_s_amt*100,2))) hp_s_cha_per, \n"+ 
				"        decode(nvl(uc.nak_pr,0),0,0,decode(nvl(uc.o_s_amt,0),0,0,ROUND((uc.nak_pr-uc.o_s_amt)/(d.car_cs_amt+d.car_cv_amt+d.opt_cs_amt+d.opt_cv_amt+d.clr_cs_amt+d.clr_cv_amt)*100,2))) hp_c_cha_per, \n"+ 
				"        decode(nvl(uc.nak_pr,0),0,0,decode(nvl(uc.o_s_amt,0),0,0,ROUND(abs(uc.nak_pr-uc.o_s_amt)/uc.o_s_amt*100,2))) abs_hp_s_cha_per, \n"+ 
				"        decode(nvl(uc.nak_pr,0),0,0,decode(nvl(uc.o_s_amt,0),0,0,ROUND(abs(uc.nak_pr-uc.o_s_amt)/(d.car_cs_amt+d.car_cv_amt+d.opt_cs_amt+d.opt_cv_amt+d.clr_cs_amt+d.clr_cv_amt)*100,2))) abs_hp_c_cha_per, \n"+ 
				"        (se.comm1_sup + se.comm1_vat) comm1_tot, \n"+
				" 	     (se.comm2_sup + se.comm2_vat) comm2_tot, \n"+
				" 	     (se.comm3_sup + se.comm3_vat) comm3_tot, \n"+
				" 	     (se.comm1_sup + se.comm1_vat+se.comm2_sup + se.comm2_vat+se.comm3_sup + se.comm3_vat) AS comm_tot, \n"+
				"        su.sui_nm, s.km, decode(sq.car_mng_id,'','무','유') accid_yn, d.opt, d.colo, \n"+
				"        a.dpm, f.nm as fuel_kd, e.jg_code, \n"+
				"        nvl(ak.a_cnt,0) a_cnt, TRUNC(MONTHS_BETWEEN(TO_DATE(uc.actn_dt,'YYYYMMDD'), TO_DATE(a.init_reg_dt,'YYYYMMDD')),1) car_old_mons, \n"+  //침수여부
				"       decode(a.park,'6',substr(a.park_cont,1,5),nvl(cd.nm,a.park))  park_nm, \n"+
				"        uc.actn_jum, d.in_col "+		
				" FROM   CAR_REG a, APPRSL s, AUCTION uc, CLIENT b, CONT c,  \n"+
				"        ( select c_st, code, nm_cd, nm from code where c_st = '0027' and code <> '0000'  ) cd,  \n"+  //주차장 
				"        (SELECT car_mng_id, max(rent_start_dt) rent_start_dt, max(reg_dt) reg_dt FROM CONT WHERE car_st='2' GROUP BY car_mng_id) c2, \n"+
				"        CAR_ETC d, CAR_NM e, sui su, SUI_ETC se, \n"+
				"	     (select car_mng_id, COUNT(0) accid_cnt from accident group by car_mng_id) sq, \n"+
				"        (SELECT DISTINCT a.car_mng_id, b.tot_amt, b.cust_amt FROM accident a, (SELECT car_mng_id, sum(tot_amt) tot_amt, sum(cust_amt) cust_amt FROM service WHERE accid_id IS NOT null GROUP BY car_mng_id  ) b  WHERE a.car_mng_id = b.car_mng_id(+) AND a.accid_st <> '1' ) e2, \n"+
				"        (select car_mng_id, count(0) as a_cnt from accident where accid_st='6' group by car_mng_id) ak, \n"+ //침수
				"        (select sh_code, MAX(jg_2) jg_2, MAX(jg_b) jg_b from esti_jg_var GROUP BY sh_code) ej, "+
				"        (select * from code where c_st='0039') f \n"+
				" WHERE  a.off_ls IN ('5','6')  \n"+
				"        AND a.car_mng_id=s.car_mng_id \n"+
				"        AND a.car_mng_id=uc.car_mng_id AND uc.actn_st='4' \n"+
				"        AND s.actn_id=b.client_id \n"+
				"        AND a.car_mng_id=c.car_mng_id \n"+
				"        AND c.car_st='2' \n"+
				"        AND c.car_mng_id=c2.car_mng_id AND c.rent_start_dt=c2.rent_start_dt AND c.reg_dt=c2.reg_dt \n"+
				"        AND c.rent_mng_id=d.rent_mng_id AND c.rent_l_cd=d.rent_l_cd \n"+
				"        AND d.car_id=e.car_id AND d.car_seq=e.car_seq \n"+
				"        AND a.car_mng_id=su.car_mng_id \n"+
				"        AND a.car_mng_id=se.car_mng_id(+) \n"+
				"        AND a.car_mng_id=sq.car_mng_id(+) \n"+
				"		 AND sq.car_mng_id=e2.car_mng_id(+) "+
				"        and a.car_mng_id = ak.car_mng_id(+) "+
				"        and a.park = cd.nm_cd(+) \n"+  //주차장 코드 테이블 
				"        and e.jg_code = ej.sh_code(+) "+
				"        and a.fuel_kd = f.nm_cd \n"+	
				" ";
		
		String s_dt3 = "like replace('" + ref_dt1 + "%','-','')";
		String s_dt4 = "between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')";


		//디폴트 기간-일자없음 -> 현재 낙찰상태
		if(dt.equals("2")){											query += " and uc.actn_dt like to_char(sysdate,'YYYYMM')||'%' \n";
		}else if(dt.equals("3")){
			if(!ref_dt1.equals("") && ref_dt2.equals(""))			query += " and uc.actn_dt "+s_dt3+" \n";
			else if(!ref_dt1.equals("") && !ref_dt2.equals(""))		query += " and uc.actn_dt "+s_dt4+" \n";
			else if(ref_dt1.equals("") && ref_dt2.equals(""))		query += " and a.off_ls='5' \n";
		}


		if(!gubun_nm.equals("")){
			if(gubun.equals("car_no"))					query += " and ( a.car_no like '%" + gubun_nm +"%' or nvl(a.first_car_no, ' ') like '%"+ gubun_nm +"%') \n";
			else if(gubun.equals("car_nm"))				query += " and a.car_nm||e.car_name like '%" + gubun_nm.toUpperCase() + "%' \n";
			else if(gubun.equals("init_reg_dt"))		query += " and a.init_reg_dt like replace('"+ gubun_nm +"','-','')||'%' \n";
			else if(gubun.equals("actn_nm"))			query += " and b.firm_nm like '%" + gubun_nm.toUpperCase() + "%' \n";			
			else if(gubun.equals("jg_code"))			query += " and e.jg_code like '%" + gubun_nm + "%' \n";			
		}

		if(!gubun2.equals("")){//차종구분(소형,중형,대형 ........ 이런것들)
			if(gubun2.equals("1"))			query += " AND decode(e.s_st, '101','100', '102','112', '105','104', decode(substr(e.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', e.s_st)) = '104' \n";
			else if(gubun2.equals("2"))		query += " AND decode(e.s_st, '101','100', '102','112', '105','104', decode(substr(e.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', e.s_st)) = '103' \n";
			else if(gubun2.equals("3"))		query += " AND decode(e.s_st, '101','100', '102','112', '105','104', decode(substr(e.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', e.s_st)) = '112' \n";
			else if(gubun2.equals("4"))		query += " AND decode(e.s_st, '101','100', '102','112', '105','104', decode(substr(e.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', e.s_st)) = '302' \n";			
			else if(gubun2.equals("5"))		query += " AND decode(e.s_st, '101','100', '102','112', '105','104', decode(substr(e.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', e.s_st)) = '301' \n";			
			else if(gubun2.equals("6"))		query += " AND decode(e.s_st, '101','100', '102','112', '105','104', decode(substr(e.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', e.s_st)) = '401' \n";			
			else if(gubun2.equals("7"))		query += " AND decode(e.s_st, '101','100', '102','112', '105','104', decode(substr(e.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', e.s_st)) = '801' \n";
			else if(gubun2.equals("8"))		query += " AND decode(e.s_st, '101','100', '102','112', '105','104', decode(substr(e.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', e.s_st)) = '300' \n";
			else if(gubun2.equals("9"))		query += " AND decode(e.s_st, '101','100', '409','100', '102','112', '105','104', decode(substr(e.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', e.s_st)) = '100' \n";
			else if(gubun2.equals("10"))	query += " AND decode(e.s_st, '101','100', '102','112', '105','104', decode(substr(e.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', e.s_st)) = '701' \n";
		}


		//경매장
		if(!s_au.equals(""))				query += " and s.actn_id ='" + s_au + "' \n";
		
		//LPG구분
		//if(gubun3.equals("1")){
		//	query += "AND nvl(ej.jg_2,'0') = '1' \n";
		//}else if(gubun3.equals("2")){
		//	query += "AND nvl(ej.jg_2,'0') <>'1' \n";
		//}else{
		//}

		
		//휘발유
		if(gubun3.equals("1")){
			query += "AND nvl(ej.jg_2,'0') <>'1' and nvl(ej.jg_b,'0') ='0' \n";
		//경유
		}else if(gubun3.equals("2")){
			query += "AND nvl(ej.jg_2,'0') <>'1' and nvl(ej.jg_b,'0') ='1' \n";
		//일반승용LPG
		}else if(gubun3.equals("3")){
			query += "AND nvl(ej.jg_2,'0') ='1'  and nvl(ej.jg_b,'0') ='2'\n";
		//기타차종LPG
		}else if(gubun3.equals("4")){
			query += "AND nvl(ej.jg_2,'0') <>'1' and nvl(ej.jg_b,'0') ='2' \n";
		}


		//렌트(rt)/리스(ls) 구분
		if(gubun1.equals("rt")){
			query += " and a.car_use = '1' ";
		}else if(gubun1.equals("ls")){
			query += " and a.car_use = '2' ";
		}

//		query += " ORDER BY uc.actn_dt desc, A.CAR_NM, a.init_reg_dt, a.car_mng_id \n ";

// 페이지별로 레코드를 가져오는 쿼리 

	   String prefixPageQuery = "	SELECT \n " +
			      								"   AAA.* \n " +
											   "		FROM( \n " +
						    					"      SELECT \n " +
						        				"           COUNT(0) OVER() AS TOTAL_COUNT, \n " +
						        				"           AA.* \n "+
						   					   "  FROM(  \n ";
	
	
		
		String suffixPageQUery = "    ) AA \n " +
												  "	) AAA  \n " +
												  "	WHERE  \n  " +
												  "		    AAA.RNUM BETWEEN  " + page  + " AND " +  rowsPerPage;
    
	String pageQuery = prefixPageQuery + query + suffixPageQUery;
		



		try{

			pstmt = conn.prepareStatement(pageQuery);
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

		}catch(SQLException e){
			System.out.println("[Offls_cmpltDatabase:getCmplt_stat_lst() pagequery]"+e);
			System.out.println("[Offls_cmpltDatabase:getCmplt_stat_lst() pagequery]"+pageQuery);
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
	

	public Hashtable  getInsInfo(String car_mng_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		Hashtable ht = new Hashtable();
		int count = 0;

		String query = "";

		
		query = " SELECT ir.car_mng_id CAR_MNG_ID, ic.ins_com_nm INS_COM_NM, ir.INS_CON_NO, c.car_no  ,decode(ir.ins_sts,'2',ir.ins_exp_dt,id.req_dt) req_dt \n"
		      + " FROM    insur ir, ins_com ic, car_reg c, (select car_mng_id, ins_st, req_dt from ins_cls where exp_st='3' and exp_aim='3') id \n"
			  + " WHERE ir.CAR_MNG_ID = c.CAR_MNG_ID \n"
			  + " AND ir.ins_com_id = ic.ins_com_ID \n"
			  + " AND ir.car_mng_id=id.car_mng_id(+) AND ir.INS_ST=id.ins_st(+) \n"
			  + " AND c.car_mng_id = '"+car_mng_id+"'"
			  + " and ir.ins_st = (select max(to_number(ins_st))from insur where car_mng_id = ir.car_mng_id)";



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
			System.out.println("[Offls_cmpltDatabase:getInsInfo]"+e);
			System.out.println("[Offls_cmpltDatabase:getInsInfo]"+query);
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

	/**
	*	경매낙찰현황(JSON / grid)
	*/
	
	public JSONArray getCmplt_stat_lst_json(String dt, String ref_dt1, String ref_dt2, String gubun, String gubun1, String gubun2, String gubun3, String gubun_nm, String brch_id, String s_au){
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		JSONArray jsonArray = new JSONArray();
		
		String query = "";
	
		
		query = " SELECT a.car_mng_id, uc.out_amt,  \n"+
				"		 nvl(e2.tot_amt,0) hap_amt, "+
				"        DECODE(NVL(e2.tot_amt,0),0,0,ROUND((e2.tot_amt*100)/(d.car_cs_amt+d.car_cv_amt+d.opt_cs_amt+d.opt_cv_amt+d.clr_cs_amt+d.clr_cv_amt),2)) se_per, \n"+
				"        a.car_no, A.CAR_NM||' '||e.car_name as car_nm, a.init_reg_dt,  \n"+
				"        b.client_id, b.firm_nm, s.actn_wh, uc.seq, uc.actn_dt,  \n"+
				"        (d.car_cs_amt+d.car_cv_amt+d.opt_cs_amt+d.opt_cv_amt+d.clr_cs_amt+d.clr_cv_amt) car_c_amt, \n"+
				"        (d.car_fs_amt+d.car_fv_amt+d.sd_cs_amt+d.sd_cv_amt-d.dc_cs_amt-d.dc_cv_amt) car_f_amt, \n"+
				"        (d.opt_cs_amt+d.opt_cv_amt) opt_amt, \n"+
				"        uc.o_s_amt as car_s_amt, uc.hp_pr, su.mm_pr nak_pr, \n"+   //경매 계약정보에서 
	            "        (uc.nak_pr-uc.o_s_amt) hp_s_cha_amt, "+ 
	            "        abs(uc.nak_pr-uc.o_s_amt) abs_hp_s_cha_amt, "+ 
				"        decode(nvl(uc.nak_pr,0),0,0,ROUND((uc.nak_pr*100)/(d.car_cs_amt+d.car_cv_amt+d.opt_cs_amt+d.opt_cv_amt+d.clr_cs_amt+d.clr_cv_amt),2)) hp_c_per, \n"+
				"        decode(nvl(uc.nak_pr,0),0,0,ROUND((uc.nak_pr*100)/(d.car_fs_amt+d.car_fv_amt+d.sd_cs_amt+d.sd_cv_amt-d.dc_cs_amt-d.dc_cv_amt),2)) hp_f_per, \n"+
				"        decode(nvl(uc.nak_pr,0),0,0,decode(nvl(uc.o_s_amt,0),0,0,ROUND((uc.nak_pr*100)/uc.o_s_amt,2))) hp_s_per, \n"+ 
				"        decode(nvl(uc.nak_pr,0),0,0,decode(nvl(uc.o_s_amt,0),0,0,ROUND((uc.nak_pr-uc.o_s_amt)/uc.o_s_amt*100,2))) hp_s_cha_per, \n"+ 
				"        decode(nvl(uc.nak_pr,0),0,0,decode(nvl(uc.o_s_amt,0),0,0,ROUND((uc.nak_pr-uc.o_s_amt)/(d.car_cs_amt+d.car_cv_amt+d.opt_cs_amt+d.opt_cv_amt+d.clr_cs_amt+d.clr_cv_amt)*100,2))) hp_c_cha_per, \n"+ 
				"        decode(nvl(uc.nak_pr,0),0,0,decode(nvl(uc.o_s_amt,0),0,0,ROUND(abs(uc.nak_pr-uc.o_s_amt)/uc.o_s_amt*100,2))) abs_hp_s_cha_per, \n"+ 
				"        decode(nvl(uc.nak_pr,0),0,0,decode(nvl(uc.o_s_amt,0),0,0,ROUND(abs(uc.nak_pr-uc.o_s_amt)/(d.car_cs_amt+d.car_cv_amt+d.opt_cs_amt+d.opt_cv_amt+d.clr_cs_amt+d.clr_cv_amt)*100,2))) abs_hp_c_cha_per, \n"+ 
				"        (se.comm1_sup + se.comm1_vat) comm1_tot, \n"+
				" 	     (se.comm2_sup + se.comm2_vat) comm2_tot, \n"+
				" 	     (se.comm3_sup + se.comm3_vat) comm3_tot, \n"+
				" 	     (se.comm1_sup + se.comm1_vat+se.comm2_sup + se.comm2_vat+se.comm3_sup + se.comm3_vat) AS comm_tot, \n"+
				"        su.sui_nm, s.km, decode(sq.car_mng_id,'','무','유') accid_yn, d.opt, d.colo, \n"+
				"        a.dpm, f.nm as fuel_kd, e.jg_code, \n"+
				"        nvl(ak.a_cnt,0) a_cnt, TRUNC(MONTHS_BETWEEN(TO_DATE(uc.actn_dt,'YYYYMMDD'), TO_DATE(a.init_reg_dt,'YYYYMMDD')),1) car_old_mons, \n"+  //침수여부
				"        decode(a.park,'6',substr(a.park_cont,1,5),nvl(cd.nm,a.park))  park_nm, \n"+
				"        uc.actn_jum, d.in_col "+		
				" FROM   CAR_REG a, APPRSL s, AUCTION uc, CLIENT b, CONT c,  \n"+
					"        ( select c_st, code, nm_cd, nm from code where c_st = '0027' and code <> '0000'  ) cd,  \n"+  //주차장 
				"        (SELECT car_mng_id, max(rent_start_dt) rent_start_dt, max(reg_dt) reg_dt FROM CONT WHERE car_st='2' GROUP BY car_mng_id) c2, \n"+
				"        CAR_ETC d, CAR_NM e, sui su, SUI_ETC se, \n"+
				"	     (select car_mng_id, COUNT(0) accid_cnt from accident group by car_mng_id) sq, \n"+
				"        (SELECT DISTINCT a.car_mng_id, b.tot_amt, b.cust_amt FROM accident a, (SELECT car_mng_id, sum(tot_amt) tot_amt, sum(cust_amt) cust_amt FROM service WHERE accid_id IS NOT null GROUP BY car_mng_id  ) b  WHERE a.car_mng_id = b.car_mng_id(+) AND a.accid_st <> '1' ) e2, \n"+
				"        (select car_mng_id, count(0) as a_cnt from accident where accid_st='6' group by car_mng_id) ak, \n"+ //침수
				"        (select sh_code, MAX(jg_2) jg_2, MAX(jg_b) jg_b from esti_jg_var GROUP BY sh_code) ej, "+
				"        (select * from code where c_st='0039') f \n"+
				" WHERE  a.off_ls IN ('5','6')  \n"+
				"        AND a.car_mng_id=s.car_mng_id \n"+
				"        AND a.car_mng_id=uc.car_mng_id AND uc.actn_st='4' \n"+
				"        AND s.actn_id=b.client_id \n"+
				"        AND a.car_mng_id=c.car_mng_id \n"+
				"        AND c.car_st='2' \n"+
				"        AND c.car_mng_id=c2.car_mng_id AND c.rent_start_dt=c2.rent_start_dt AND c.reg_dt=c2.reg_dt \n"+
				"        AND c.rent_mng_id=d.rent_mng_id AND c.rent_l_cd=d.rent_l_cd \n"+
				"        AND d.car_id=e.car_id AND d.car_seq=e.car_seq \n"+
				"        AND a.car_mng_id=su.car_mng_id \n"+
				"        AND a.car_mng_id=se.car_mng_id(+) \n"+
				"        AND a.car_mng_id=sq.car_mng_id(+) \n"+
				"		 AND sq.car_mng_id=e2.car_mng_id(+) "+
				"        and a.car_mng_id = ak.car_mng_id(+) "+
				"        and a.park = cd.nm_cd(+) \n"+  //주차장 코드 테이블 
				"        and e.jg_code = ej.sh_code(+) "+
				"        and a.fuel_kd = f.nm_cd \n"+	
				" ";
	
		String s_dt2 = "to_char(sysdate,'YYYYMM')";
		String s_dt3 = "like replace('" + ref_dt1 + "%','-','')";
		String s_dt4 = "between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')";
	
	
		//디폴트 기간-일자없음 -> 현재 낙찰상태
		if(dt.equals("2")){											query += " and uc.actn_dt like "+s_dt2+"||'%' \n";
		}else if(dt.equals("3")){
			if(!ref_dt1.equals("") && ref_dt2.equals(""))			query += " and uc.actn_dt "+s_dt3+" \n";
			else if(!ref_dt1.equals("") && !ref_dt2.equals(""))		query += " and uc.actn_dt "+s_dt4+" \n";
			else if(ref_dt1.equals("") && ref_dt2.equals(""))		query += " and a.off_ls='5' \n";
		}
	
	
		if(!gubun_nm.equals("")){
			if(gubun.equals("car_no"))					query += " and ( a.car_no like '%" + gubun_nm +"%' or nvl(a.first_car_no, ' ') like '%"+ gubun_nm +"%') \n";
			else if(gubun.equals("car_nm"))				query += " and a.car_nm||e.car_name like '%" + gubun_nm.toUpperCase() + "%' \n";
			else if(gubun.equals("init_reg_dt"))		query += " and a.init_reg_dt like replace('"+ gubun_nm +"','-','')||'%' \n";
			else if(gubun.equals("actn_nm"))			query += " and b.firm_nm like '%" + gubun_nm.toUpperCase() + "%' \n";			
			else if(gubun.equals("jg_code"))			query += " and e.jg_code like '%" + gubun_nm + "%' \n";			
		}
	
		if(!gubun2.equals("")){//차종구분(소형,중형,대형 ........ 이런것들)
			if(gubun2.equals("1"))			query += " AND decode(e.s_st, '101','100', '102','112', '105','104', decode(substr(e.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', e.s_st)) = '104' \n";
			else if(gubun2.equals("2"))		query += " AND decode(e.s_st, '101','100', '102','112', '105','104', decode(substr(e.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', e.s_st)) = '103' \n";
			else if(gubun2.equals("3"))		query += " AND decode(e.s_st, '101','100', '102','112', '105','104', decode(substr(e.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', e.s_st)) = '112' \n";
			else if(gubun2.equals("4"))		query += " AND decode(e.s_st, '101','100', '102','112', '105','104', decode(substr(e.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', e.s_st)) = '302' \n";			
			else if(gubun2.equals("5"))		query += " AND decode(e.s_st, '101','100', '102','112', '105','104', decode(substr(e.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', e.s_st)) = '301' \n";			
			else if(gubun2.equals("6"))		query += " AND decode(e.s_st, '101','100', '102','112', '105','104', decode(substr(e.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', e.s_st)) = '401' \n";			
			else if(gubun2.equals("7"))		query += " AND decode(e.s_st, '101','100', '102','112', '105','104', decode(substr(e.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', e.s_st)) = '801' \n";
			else if(gubun2.equals("8"))		query += " AND decode(e.s_st, '101','100', '102','112', '105','104', decode(substr(e.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', e.s_st)) = '300' \n";
			else if(gubun2.equals("9"))		query += " AND decode(e.s_st, '101','100', '409','100', '102','112', '105','104', decode(substr(e.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', e.s_st)) = '100' \n";
			else if(gubun2.equals("10"))	query += " AND decode(e.s_st, '101','100', '102','112', '105','104', decode(substr(e.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', e.s_st)) = '701' \n";
		}
	
	
		//경매장
		if(!s_au.equals(""))				query += " and s.actn_id ='" + s_au + "' \n";
	
		//휘발유
		if(gubun3.equals("1")){
			query += "AND nvl(ej.jg_2,'0') <>'1' and nvl(ej.jg_b,'0') ='0' \n";
		//경유
		}else if(gubun3.equals("2")){
			query += "AND nvl(ej.jg_2,'0') <>'1' and nvl(ej.jg_b,'0') ='1' \n";
		//일반승용LPG
		}else if(gubun3.equals("3")){
			query += "AND nvl(ej.jg_2,'0') ='1'  and nvl(ej.jg_b,'0') ='2'\n";
		//기타차종LPG
		}else if(gubun3.equals("4")){
			query += "AND nvl(ej.jg_2,'0') <>'1' and nvl(ej.jg_b,'0') ='2' \n";
		}
	
	
		//렌트(rt)/리스(ls) 구분
		if(gubun1.equals("rt")){
			query += " and a.car_use = '1' ";
		}else if(gubun1.equals("ls")){
			query += " and a.car_use = '2' ";
		}
	
		query += " ORDER BY uc.actn_dt desc, A.CAR_NM, a.init_reg_dt, a.car_mng_id \n ";
	
	
		try{
	
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			
			while(rs.next())
			{							
				JSONObject obj = new JSONObject();		        
		        
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 obj.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				jsonArray.add(obj);
			}
		    rs.close();
	        pstmt.close();	
	
		}catch(SQLException e){
			System.out.println("[Offls_cmpltDatabase:getCmplt_stat_lst()]"+e);
			System.out.println("[Offls_cmpltDatabase:getCmplt_stat_lst()]"+query);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
	            if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
	
			closeConnection();
			return jsonArray;
		}		
	}
	
	//차량당 n번째 사고수리비 구하기
	public Vector getServiceAmt(String car_mng_id, String number){
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		
		query = " 	SELECT * FROM( \n"
			  + " 		SELECT car_mng_id, NVL(tot_amt,'0')AS TOT_AMT FROM service \n"
			  + "		 WHERE accid_id IS NOT null and car_mng_id = '"+car_mng_id+"' ORDER BY tot_amt DESC\n"
			  + " 	) WHERE rownum <= '"+number+"' ORDER BY tot_amt \n"
			  + "";

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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
		    rs.close();
            pstmt.close();	

		}catch(SQLException e){
			System.out.println("[Offls_cmpltDatabase:getServiceAmt]"+e);
			System.out.println("[Offls_cmpltDatabase:getServiceAmt]"+query);
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
	
	
	//차량당 사고수리비 구하기
		public Vector getServiceAmt2(String car_mng_id){
			getConnection();
			Vector vt = new Vector();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String query = "";
			
			query = "  SELECT * FROM (\r\n" + 
					"			SELECT  a.car_mng_id, b.tot_amt tot_amt FROM ACCIDENT a, SERVICE b, cont c \r\n" + 
					"			WHERE 1=1 AND a.car_mng_id=b.car_mng_id AND a.accid_id=b.accid_id AND b.tot_amt>0 \r\n" + 
					"			AND a.rent_mng_id=c.rent_mng_id AND a.rent_l_cd=c.rent_l_cd  AND b.serv_st NOT IN ('7','12')  \r\n" + 
					"			UNION ALL \r\n" + 
					"			SELECT  a.CAR_MNG_ID ,b.accid_serv_amt tot_amt \r\n" + 
					"			FROM cont a, car_etc b WHERE 1=1 AND a.car_gu='2' and a.rent_mng_id=b.rent_mng_id \r\n" + 
					"			AND a.rent_l_cd=b.rent_l_cd AND nvl(b.accid_serv_amt,0)>0 \r\n" + 
				    " )WHERE CAR_MNG_ID ='"+car_mng_id+"'"+
					" ORDER BY tot_amt desc";

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
						 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
					}
					vt.add(ht);	
				}
			    rs.close();
	            pstmt.close();	

			}catch(SQLException e){
				System.out.println("[Offls_cmpltDatabase:getServiceAmt]"+e);
				System.out.println("[Offls_cmpltDatabase:getServiceAmt]"+query);
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
		*	매각차량잔가손익현황
		*/

		public Vector getSuiStatLst(String dt, String ref_dt1, String ref_dt2, String gubun1, String gubun2, String gubun3, String s_kd, String t_wd){
			getConnection();
			Vector vt = new Vector();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String query = "";

			query = " SELECT c.car_no, a.jg_code, c.car_name, d.init_reg_dt,\r\n"
					+ "       a.cont_dt, SUBSTR(a.cont_dt,1,6) cont_mon, b.migr_dt, a.car_amt1, a.car_mon,\r\n"
					+ "       a.tot_pnl_amt, --잔가총손익\r\n"
					+ "       a.tot_pnl_per, --신차소비자가격대비     \r\n"
					+ "       a.t_pnl_amt,  --잔가손익합계       \r\n"
					+ "       a.j_over_amt, --초과운행대여료합계       \r\n"
					+ "       a.bc_b_d,     --재리스초기영업비용견적반영분 \r\n"
					+ "       a.j_serv_amt, --재리스실수리비   \r\n"
					+ "       a.comm_amt,   --매각수수료합계\r\n"
					+ "       a.cont_mon1,  --장기계약 잔가 손익비교시 미포함 대여기간\r\n"
					+ "       a.cont_mon2,  --적용잔가 재계산없는 추가이용기간\r\n"
					+ "       a.cont_mon3,  --월렌트대여기간\r\n"
					+ "       a.rent_start_dt1, a.rent_end_dt1, a.con_mon1, a.r_con_mon1, a.jan_st1, NVL(a.jan_amt1,0) jan_amt1, \r\n"
					+ "       a.car_amt2, NVL(a.pnl_amt2,0) pnl_amt2, a.rent_start_dt2, a.rent_end_dt2, a.con_mon2, a.r_con_mon2, a.jan_st2, NVL(a.jan_amt2,0) jan_amt2,\r\n"
					+ "       a.car_amt3, NVL(a.pnl_amt3,0) pnl_amt3, a.rent_start_dt3, a.rent_end_dt3, a.con_mon3, a.r_con_mon3, a.jan_st3, NVL(a.jan_amt3,0) jan_amt3, \r\n"
					+ "       a.car_amt4, NVL(a.pnl_amt4,0) pnl_amt4, a.rent_start_dt4, a.rent_end_dt4, a.con_mon4, a.r_con_mon4, a.jan_st4, NVL(a.jan_amt4,0) jan_amt4,\r\n"
					+ "       a.car_amt5, NVL(a.pnl_amt5,0) pnl_amt5, a.rent_start_dt5, a.rent_end_dt5, a.con_mon5, a.r_con_mon5, a.jan_st5, NVL(a.jan_amt5,0) jan_amt5,\r\n"
					+ "       a.car_amt6, NVL(a.pnl_amt6,0) pnl_amt6, a.rent_start_dt6, a.rent_end_dt6, a.con_mon6, a.r_con_mon6, a.jan_st6, NVL(a.jan_amt6,0) jan_amt6,\r\n"
					+ "       a.end_st, --최종계약\r\n"
					+ "       a.end_type, --매각방식\r\n"
					+ "       NVL(a.end_jan_amt,0) end_jan_amt,--최종계약의 적용잔가  \r\n"
					+ "       b.mm_pr,      --매도가\r\n"
					+ "       a.mm_per,\r\n"
					+ "       NVL(a.mm_pnl_amt,0) mm_pnl_amt, --매각손익  \r\n"
					+ "       a.car_mon as car_mon2,  \r\n"
					+ "       a.car_km,     --주행거리  \r\n"
					+ "       a.actn_jum,   --경매장평덤              \r\n"
					+ "       DECODE(b.migr_dt,'','미등록',DECODE(b.migr_no,'수출말소','수출말소','이전등록')) migr_st, --\r\n"
					+ "       a.a_serv_amt, --사고수리비\r\n"
					+ "       d.car_num,   \r\n"
					+ "       a.ja_mon, --자산양수매매기준 차령 \r\n"
					+ "       --a.car_cng_yn --차종변경,계약승계여부\r\n"
					+ "       DECODE(a.car_cng_yn,'4',1,0) car_cng_yn, a.jg_2, a.amt5, a.m_var, a.n_var, a.l_var, a.l_var_amt \r\n"
					+ "FROM   stat_sui a, sui b, sh_base c, car_reg d\r\n"
					+ "WHERE  a.car_mng_id=b.car_mng_id and d.init_reg_dt >= '20090101' \r\n"
					+ "       AND a.car_mng_id=c.car_mng_id(+)          \r\n"
					+ "       AND a.car_mng_id=d.car_mng_id\r\n"
					//+ "       and a.car_cng_yn IN ('0','4') --차종변경,계약승계는 제외  \r\n"+				
					+" ";

			if(gubun3.equals("1")){
				query += " and a.car_cng_yn = '0' and a.ANALYSIS_YN='0' "; //분석대상만
			}else if(gubun3.equals("2")){
				query += " and a.car_cng_yn = '4' "; //폐차만
			}			
			
			String s_dt3 = "like replace('" + ref_dt1 + "%','-','')";
			String s_dt4 = "between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')";
			
			//디폴트 기간-일자없음 -> 현재 낙찰상태
			if(dt.equals("2")){											
				query += " and a.cont_dt like to_char(sysdate,'YYYYMM')||'%' \n";
			} else if (dt.equals("4")){  //당해 											
				query += " and a.cont_dt like to_char(sysdate,'YYYY')||'%' \n";	
			}else if(dt.equals("3")){
				if(!ref_dt1.equals("") && ref_dt2.equals("")){
					query += " and a.cont_dt "+s_dt3+" \n";
				}else if(!ref_dt1.equals("") && !ref_dt2.equals("")){
					query += " and a.cont_dt "+s_dt4+" \n";
				}
			}else if (dt.equals("1")){
				query += " and a.cont_dt like to_char(add_months(sysdate, -1), 'YYYYMM')||'%' \n";
			}
			
			//테스트
			if(dt.equals("5")){		
				query += " and d.car_no in ('58하7552','35호9880','04호3528','28호2686','54호6640','54호6638','66하6520','73수5355','30호9217','22호6287','58하9573')";
			}


			if(!t_wd.equals("")){
				if(s_kd.equals("1"))				query += " and c.car_name like '%" + t_wd.toUpperCase() + "%' \n";
				else if(s_kd.equals("2"))			query += " and a.jg_code = '" + t_wd + "' \n";			
				else if(s_kd.equals("3"))			query += " and d.car_no like '%" + t_wd.toUpperCase() + "%' \n";
				else if(s_kd.equals("4"))			query += " and d.car_num like '%" + t_wd.toUpperCase() + "%' \n";
			}
			                                                   
			if(!gubun2.equals("")){//차종구분(소형,중형,대형 ........ 이런것들)
				if(gubun2.equals("1"))			query += " AND a.s_st = '104' AND a.car_comp_id < '0006' \n";
				else if(gubun2.equals("2"))		query += " AND a.s_st = '103' AND a.car_comp_id < '0006' \n";
				else if(gubun2.equals("3"))		query += " AND a.s_st = '112' AND a.car_comp_id < '0006' \n";
				else if(gubun2.equals("4"))		query += " AND a.s_st = '302' AND a.car_comp_id < '0006' \n";			
				else if(gubun2.equals("5"))		query += " AND a.s_st = '301' AND a.car_comp_id < '0006' \n";			
				else if(gubun2.equals("6"))		query += " AND a.s_st = '401' AND a.car_comp_id < '0006' \n";			
				else if(gubun2.equals("7"))		query += " AND a.s_st = '801' AND a.car_comp_id < '0006' \n";
				else if(gubun2.equals("8"))		query += " AND a.s_st = '300' AND a.car_comp_id < '0006' \n";
				else if(gubun2.equals("9"))		query += " AND a.s_st in ('100','409') AND a.car_comp_id < '0006' \n";
				else if(gubun2.equals("10"))	query += " AND a.s_st = '701' AND a.car_comp_id < '0006' \n";
				else if(gubun2.equals("20"))	query += " AND a.car_comp_id > '0005' \n";
			}

			
			
			//테스트
			if(dt.equals("5")){		
				query += " ORDER BY DECODE(d.car_no,'58하7552',1,'35호9880',2,'04호3528',3,'28호2686',4,'54호6640',5,'54호6638',6,'66하6520',7,'73수5355',8,'30호9217',9,'22호6287',10,'58하9573',11) ";
			}else {
				query += " ORDER BY a.cont_dt desc, c.car_name, d.init_reg_dt, a.car_mng_id \n ";
			}	

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
						 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
					}
					vt.add(ht);	
				}
			    rs.close();
	            pstmt.close();	

			}catch(SQLException e){
				System.out.println("[Offls_cmpltDatabase:getSuiStatLst()]"+e);
				System.out.println("[Offls_cmpltDatabase:getSuiStatLst()]"+query);
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
		*	매각차량잔가손익현황2
		*/

		public Vector getSuiStatLst2(String mode, String s_yy, String gubun1, String gubun2, String gubun3, String gubun4){
			getConnection();
			Vector vt = new Vector();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String base_query1 = " ";			
			String base_query2 = " ";
			String query = " ";
			String where_query = " ";
			
			if(!gubun1.equals("")){//차종구분(소형,중형,대형 ........ 이런것들)
				if(gubun1.equals("1"))			where_query += " AND s_st = '104' AND car_comp_id < '0006' \n";
				else if(gubun1.equals("2"))		where_query += " AND s_st = '103' AND car_comp_id < '0006' \n";
				else if(gubun1.equals("3"))		where_query += " AND s_st = '112' AND car_comp_id < '0006' \n";
				else if(gubun1.equals("4"))		where_query += " AND s_st = '302' AND car_comp_id < '0006' \n";			
				else if(gubun1.equals("5"))		where_query += " AND s_st = '301' AND car_comp_id < '0006' \n";			
				else if(gubun1.equals("6"))		where_query += " AND s_st = '401' AND car_comp_id < '0006' \n";			
				else if(gubun1.equals("7"))		where_query += " AND s_st = '801' AND car_comp_id < '0006' \n";
				else if(gubun1.equals("8"))		where_query += " AND s_st = '300' AND car_comp_id < '0006' \n";
				else if(gubun1.equals("9"))		where_query += " AND s_st in ('100','409') AND car_comp_id < '0006' \n";
				else if(gubun1.equals("10"))	where_query += " AND s_st = '701' AND car_comp_id < '0006' \n";
				else if(gubun1.equals("20"))	where_query += " AND car_comp_id > '0005' \n";
			}	
			
			if(!gubun2.equals("")){//제조사
				where_query += " AND car_comp_id = '"+gubun2+"' \n";
			}
			
			if(!gubun3.equals("")){//차명
				where_query += " AND ab_nm = '"+gubun3+"' \n";
			}
			
			if(!gubun4.equals("")){//경매/매입옵션
				where_query += " AND end_type = '"+gubun4+"' \n";
			}
			
			if(mode.equals("1")) {
				
				query ="--매각차량잔가소닉현황2\r\n"
						+ "SELECT a.cont_year, a.jg_2, b.d_var, b.e_var, b.e_per, b.f_var, b.g_var, b.p_var, b.h_var, b.i_var, b.j_var, b.k_var, b.l_var, b.m_var, b.n_var, b.o_var, b.l_var_s_amt, b.l_var_a_amt\r\n"
						+ "FROM \r\n"
						+ "\r\n"
						+ "          (              \r\n"
						+ "			             SELECT TO_CHAR(TO_CHAR(SYSDATE,'YYYY')-LEVEL+1) AS cont_year, 'LPG' jg_2 FROM DUAL CONNECT BY LEVEL <= ((TO_CHAR(SYSDATE,'YYYY')+1)-2013)\r\n"
						+ "			  			 UNION all \r\n"
						+ "              		 SELECT TO_CHAR(TO_CHAR(SYSDATE,'YYYY')-LEVEL+1) AS cont_year, '비LPG' jg_2 FROM DUAL CONNECT BY LEVEL <= ((TO_CHAR(SYSDATE,'YYYY')+1)-2013)\r\n"
						+ "              		 UNION all\r\n"
						+ "              		 SELECT TO_CHAR(TO_CHAR(SYSDATE,'YYYY')-LEVEL+1) AS cont_year, '소계' jg_2 FROM DUAL CONNECT BY LEVEL <= ((TO_CHAR(SYSDATE,'YYYY')+1)-2013)\r\n"
						+ "                      UNION ALL\r\n"
						+ "                      SELECT '전체' cont_year, 'LPG' jg_2 FROM dual \r\n"
						+ "                      UNION ALL\r\n"
						+ "                      SELECT '전체' cont_year, '비LPG' jg_2 FROM dual\r\n"
						+ "                      UNION ALL\r\n"
						+ "                      SELECT '전체' cont_year, '소계' jg_2 FROM dual\r\n"
						+ "			 ) a,\r\n"
						+ "          ( \r\n"
						+ "				         --년도,구분별\r\n"
						+ "						 SELECT \r\n"
						+ "							       cont_year, jg_2, d_var, e_var, ROUND(e_var/d_var*100,2) e_per, ROUND(f_var,2) f_var, g_var, p_var, TRUNC(h_var) h_var, i_var, ROUND(j_var,2) j_var, ROUND(k_var,2) k_var,\r\n"
//						+ "							       ROUND((POWER((56.7/80),(f_var-k_var)/24)*80)-(POWER((56.7/80),f_var/24)*80),2) l_var,\r\n"
//						+ "							       ROUND(( ROUND(j_var,1) + (POWER((56.7/80),(f_var-k_var)/24)*80)-(POWER((56.7/80),f_var/24)*80) ),2) m_var,\r\n"
//						+ "							       TRUNC( i_var * ( ROUND(j_var,1) + (POWER((56.7/80),(f_var-k_var)/24)*80)-(POWER((56.7/80),f_var/24)*80) ) /100 ) n_var,\r\n"
//						+ "							       TRUNC( i_var * ( ROUND(j_var,1) + (POWER((56.7/80),(f_var-k_var)/24)*80)-(POWER((56.7/80),f_var/24)*80) ) /100 /e_var) o_var       \r\n"
                        + "                                ROUND(l_var,2) l_var, ROUND(m_var,2) m_var, n_var, TRUNC(n_var/e_var) o_var, l_var_s_amt, TRUNC(l_var_a_amt) l_var_a_amt \r\n"
						+ "						 FROM \r\n"
						+ "							   (\r\n"
						+ "							       select \r\n"
						+ "							              SUBSTR(cont_dt,1,4) cont_year,--매각년도\r\n"
						+ "								          DECODE(jg_2,'1','LPG','비LPG') jg_2,--LPG구분 \r\n"
						+ "							              COUNT(0) d_var, --총매각대수\r\n"
						+ "							              COUNT(DECODE(ANALYSIS_YN,'0',car_mng_id)) e_var,  --분석대수       \r\n"
						+ "							              avg(DECODE(ANALYSIS_YN,'0',car_mon)) f_var,  --차령(평균)\r\n"
						+ "							              SUM  (DECODE(ANALYSIS_YN,'0',tot_pnl_amt)) g_var,  --잔가손익(합계)-잔가총손익\r\n"
						+ "							              sum(DECODE(ANALYSIS_YN,'0',tot_pnl_amt))/COUNT(DECODE(ANALYSIS_YN,'0',car_mng_id)) h_var,  --대당잔가손익\r\n"
						+ "							              SUM  (DECODE(ANALYSIS_YN,'0',car_amt1)) i_var,  --소비자가(합계)-신차소비자가\r\n"
						+ "							              sum(DECODE(ANALYSIS_YN,'0',tot_pnl_amt))/sum(DECODE(ANALYSIS_YN,'0',DECODE(car_amt1,0,NULL,car_amt1)))*100 j_var,\r\n"
						+ "							              avg(DECODE(ANALYSIS_YN,'0',cont_mon1)) k_var, --장기계약 잔가 손익비교시 미포함 대여기간(평균)\r\n"
						+ "							              SUM  (DECODE(ANALYSIS_YN,'0',amt5)) p_var,  --중고차평가이익\r\n"
						//"							              avg(DECODE(ANALYSIS_YN,'0',l_var)) l_var, \r\n"
						+ "							              sum(DECODE(ANALYSIS_YN,'0',l_var_amt))/SUM(DECODE(ANALYSIS_YN,'0',car_amt1))*100 l_var, \r\n"
						//+ "							              avg(DECODE(ANALYSIS_YN,'0',m_var)) m_var, \r\n"
						+ "                                       sum(DECODE(ANALYSIS_YN,'0',n_var))/sum(DECODE(ANALYSIS_YN,'0',DECODE(car_amt1,0,NULL,car_amt1)))*100 m_var,\r\n"
						+ "							              SUM  (DECODE(ANALYSIS_YN,'0',n_var)) n_var,  \r\n"
						+ "							              sum  (DECODE(ANALYSIS_YN,'0',l_var_amt)) l_var_s_amt, \r\n"
						+ "							              sum(DECODE(ANALYSIS_YN,'0',l_var_amt))/COUNT(DECODE(ANALYSIS_YN,'0',car_mng_id)) l_var_a_amt  \r\n"
						+ "							       FROM   stat_sui\r\n"
						+ "							       WHERE  cont_dt >= '20130101'\r\n"+where_query
						+ " 				               GROUP BY SUBSTR(cont_dt,1,4), jg_2\r\n"
						+ "							   ) \r\n"
						+ "				         UNION ALL\r\n"
						+ "				         --년도별\r\n"
						+ "						 SELECT \r\n"
						+ "							       cont_year, '소계' jg_2, d_var, e_var, ROUND(e_var/d_var*100,2) e_per, ROUND(f_var,2) f_var, g_var, p_var, TRUNC(h_var) h_var, i_var, ROUND(j_var,2) j_var, ROUND(k_var,2) k_var,\r\n"
//						+ "							       trunc((POWER((56.7/80),(f_var-k_var)/24)*80)-(POWER((56.7/80),f_var/24)*80),2) l_var,\r\n"
//						+ "							       ROUND(( j_var + (POWER((56.7/80),(f_var-k_var)/24)*80)-(POWER((56.7/80),f_var/24)*80) ),2) m_var,\r\n"
//						+ "							       TRUNC( i_var * ( j_var + (POWER((56.7/80),(f_var-k_var)/24)*80)-(POWER((56.7/80),f_var/24)*80) ) /100 ) n_var,\r\n"
//						+ "							       TRUNC( i_var * ( j_var + (POWER((56.7/80),(f_var-k_var)/24)*80)-(POWER((56.7/80),f_var/24)*80) ) /100 /e_var) o_var       \r\n"
						+ "                                ROUND(l_var,2) l_var, ROUND(m_var,2) m_var, n_var, TRUNC(n_var/e_var) o_var, l_var_s_amt, TRUNC(l_var_a_amt) l_var_a_amt \r\n"
						+ "						 FROM \r\n"
						+ "							   (\r\n"
						+ "							       select \r\n"
						+ "							              SUBSTR(cont_dt,1,4) cont_year,--매각년도\r\n"
						+ "							              COUNT(0) d_var, --총매각대수\r\n"
						+ "							              COUNT(DECODE(ANALYSIS_YN,'0',car_mng_id)) e_var,  --분석대수       \r\n"
						+ "							              avg(DECODE(ANALYSIS_YN,'0',car_mon)) f_var,  --차령(평균)\r\n"
						+ "							              SUM  (DECODE(ANALYSIS_YN,'0',tot_pnl_amt)) g_var,  --잔가손익(합계)-잔가총손익\r\n"
						+ "							              sum(DECODE(ANALYSIS_YN,'0',tot_pnl_amt))/COUNT(DECODE(ANALYSIS_YN,'0',car_mng_id)) h_var,  --대당잔가손익\r\n"
						+ "							              SUM  (DECODE(ANALYSIS_YN,'0',car_amt1)) i_var,  --소비자가(합계)-신차소비자가\r\n"
						+ "							              sum(DECODE(ANALYSIS_YN,'0',tot_pnl_amt))/sum(DECODE(ANALYSIS_YN,'0',DECODE(car_amt1,0,NULL,car_amt1)))*100 j_var,\r\n"
						+ "							              avg(DECODE(ANALYSIS_YN,'0',cont_mon1)) k_var, --장기계약 잔가 손익비교시 미포함 대여기간(평균)\r\n"
						+ "							              SUM  (DECODE(ANALYSIS_YN,'0',amt5)) p_var,  --중고차평가이익\r\n"
						//+ "							              avg(DECODE(ANALYSIS_YN,'0',l_var)) l_var, \r\n"
						+ "							              sum(DECODE(ANALYSIS_YN,'0',l_var_amt))/SUM(DECODE(ANALYSIS_YN,'0',car_amt1))*100 l_var, \r\n"						
						//+ "							              avg(DECODE(ANALYSIS_YN,'0',m_var)) m_var, \r\n"
						+ "                                       sum(DECODE(ANALYSIS_YN,'0',n_var))/sum(DECODE(ANALYSIS_YN,'0',DECODE(car_amt1,0,NULL,car_amt1)))*100 m_var,\r\n"
						+ "							              SUM  (DECODE(ANALYSIS_YN,'0',n_var)) n_var,  \r\n"
						+ "							              sum  (DECODE(ANALYSIS_YN,'0',l_var_amt)) l_var_s_amt, \r\n"
						+ "							              sum(DECODE(ANALYSIS_YN,'0',l_var_amt))/COUNT(DECODE(ANALYSIS_YN,'0',car_mng_id)) l_var_a_amt  \r\n"						
						+ "							       FROM   stat_sui\r\n"
						+ "							       WHERE  cont_dt >= '20130101'\r\n"+where_query
						+ " 				               GROUP BY SUBSTR(cont_dt,1,4)\r\n"
						+ "							   )\r\n"
						+ "				         UNION ALL\r\n"
						+ "				         --전체 구분별\r\n"
						+ "						 SELECT \r\n"
						+ "							       '전체' cont_year, jg_2, d_var, e_var, ROUND(e_var/d_var*100,2) e_per, ROUND(f_var,2) f_var, g_var, p_var, TRUNC(h_var) h_var, i_var, ROUND(j_var,2) j_var, ROUND(k_var,2) k_var,\r\n"
//						+ "							       trunc((POWER((56.7/80),(f_var-k_var)/24)*80)-(POWER((56.7/80),f_var/24)*80),2) l_var,\r\n"
//						+ "							       ROUND(( j_var + (POWER((56.7/80),(f_var-k_var)/24)*80)-(POWER((56.7/80),f_var/24)*80) ),2) m_var,\r\n"
//						+ "							       TRUNC( i_var * ( j_var + (POWER((56.7/80),(f_var-k_var)/24)*80)-(POWER((56.7/80),f_var/24)*80) ) /100 ) n_var,\r\n"
//						+ "							       TRUNC( i_var * ( j_var + (POWER((56.7/80),(f_var-k_var)/24)*80)-(POWER((56.7/80),f_var/24)*80) ) /100 /e_var) o_var       \r\n"
						+ "                                ROUND(l_var,2) l_var, ROUND(m_var,2) m_var, n_var, TRUNC(n_var/e_var) o_var, l_var_s_amt, TRUNC(l_var_a_amt) l_var_a_amt \r\n"
						+ "						 FROM \r\n"
						+ "							   (\r\n"
						+ "							       select \r\n"
						+ "				                          DECODE(jg_2,'1','LPG','비LPG') jg_2,--LPG구분 \r\n"
						+ "							              COUNT(0) d_var, --총매각대수\r\n"
						+ "							              COUNT(DECODE(ANALYSIS_YN,'0',car_mng_id)) e_var,  --분석대수       \r\n"
						+ "							              avg(DECODE(ANALYSIS_YN,'0',car_mon)) f_var,  --차령(평균)\r\n"
						+ "							              SUM  (DECODE(ANALYSIS_YN,'0',tot_pnl_amt)) g_var,  --잔가손익(합계)-잔가총손익\r\n"
						+ "							              sum(DECODE(ANALYSIS_YN,'0',tot_pnl_amt))/COUNT(DECODE(ANALYSIS_YN,'0',car_mng_id)) h_var,  --대당잔가손익\r\n"
						+ "							              SUM  (DECODE(ANALYSIS_YN,'0',car_amt1)) i_var,  --소비자가(합계)-신차소비자가\r\n"
						+ "							              sum(DECODE(ANALYSIS_YN,'0',tot_pnl_amt))/sum(DECODE(ANALYSIS_YN,'0',DECODE(car_amt1,0,NULL,car_amt1)))*100 j_var,\r\n"
						+ "							              avg(DECODE(ANALYSIS_YN,'0',cont_mon1)) k_var, --장기계약 잔가 손익비교시 미포함 대여기간(평균)\r\n"
						+ "							              SUM  (DECODE(ANALYSIS_YN,'0',amt5)) p_var,  --중고차평가이익\r\n"
						//+ "							              avg(DECODE(ANALYSIS_YN,'0',l_var)) l_var, \r\n"
						+ "							              sum(DECODE(ANALYSIS_YN,'0',l_var_amt))/SUM(DECODE(ANALYSIS_YN,'0',car_amt1))*100 l_var, \r\n"						
						//+ "							              avg(DECODE(ANALYSIS_YN,'0',m_var)) m_var, \r\n"
						+ "                                       sum(DECODE(ANALYSIS_YN,'0',n_var))/sum(DECODE(ANALYSIS_YN,'0',DECODE(car_amt1,0,NULL,car_amt1)))*100 m_var,\r\n"
						+ "							              SUM  (DECODE(ANALYSIS_YN,'0',n_var)) n_var,  \r\n"		
						+ "							              sum  (DECODE(ANALYSIS_YN,'0',l_var_amt)) l_var_s_amt, \r\n"
						+ "							              sum(DECODE(ANALYSIS_YN,'0',l_var_amt))/COUNT(DECODE(ANALYSIS_YN,'0',car_mng_id)) l_var_a_amt  \r\n"						
						+ "							       FROM   stat_sui\r\n"
						+ "							       WHERE  cont_dt >= '20130101'\r\n"+where_query
						+ " 				               GROUP BY jg_2\r\n"
						+ "							   )          \r\n"
						+ "				         UNION ALL\r\n"
						+ "				         --전체 \r\n"
						+ "						 SELECT \r\n"
						+ "							       '전체' cont_year, '소계' jg_2, d_var, e_var, ROUND(e_var/d_var*100,2) e_per, ROUND(f_var,2) f_var, g_var, p_var, TRUNC(h_var) h_var, i_var, ROUND(j_var,2) j_var, ROUND(k_var,2) k_var,\r\n"
//						+ "							       trunc((POWER((56.7/80),(f_var-k_var)/24)*80)-(POWER((56.7/80),f_var/24)*80),2) l_var,\r\n"
//						+ "							       ROUND(( j_var + (POWER((56.7/80),(f_var-k_var)/24)*80)-(POWER((56.7/80),f_var/24)*80) ),2) m_var,\r\n"
//						+ "							       TRUNC( i_var * ( j_var + (POWER((56.7/80),(f_var-k_var)/24)*80)-(POWER((56.7/80),f_var/24)*80) ) /100 ) n_var,\r\n"
//						+ "							       TRUNC( i_var * ( j_var + (POWER((56.7/80),(f_var-k_var)/24)*80)-(POWER((56.7/80),f_var/24)*80) ) /100 /e_var) o_var       \r\n"
						+ "                                ROUND(l_var,2) l_var, ROUND(m_var,2) m_var, n_var, TRUNC(n_var/e_var) o_var, l_var_s_amt, TRUNC(l_var_a_amt) l_var_a_amt \r\n"
						+ "						 FROM \r\n"
						+ "							   (\r\n"
						+ "							       select \r\n"
						+ "							              COUNT(0) d_var, --총매각대수\r\n"
						+ "							              COUNT(DECODE(ANALYSIS_YN,'0',car_mng_id)) e_var,  --분석대수       \r\n"
						+ "							              avg(DECODE(ANALYSIS_YN,'0',car_mon)) f_var,  --차령(평균)\r\n"
						+ "							              SUM  (DECODE(ANALYSIS_YN,'0',tot_pnl_amt)) g_var,  --잔가손익(합계)-잔가총손익\r\n"
						+ "							              sum(DECODE(ANALYSIS_YN,'0',tot_pnl_amt))/COUNT(DECODE(ANALYSIS_YN,'0',car_mng_id)) h_var,  --대당잔가손익\r\n"
						+ "							              SUM  (DECODE(ANALYSIS_YN,'0',car_amt1)) i_var,  --소비자가(합계)-신차소비자가\r\n"
						+ "							              sum(DECODE(ANALYSIS_YN,'0',tot_pnl_amt))/sum(DECODE(ANALYSIS_YN,'0',DECODE(car_amt1,0,NULL,car_amt1)))*100 j_var,\r\n"
						+ "							              avg(DECODE(ANALYSIS_YN,'0',cont_mon1)) k_var, --장기계약 잔가 손익비교시 미포함 대여기간(평균)\r\n"
						+ "							              SUM  (DECODE(ANALYSIS_YN,'0',amt5)) p_var,  --중고차평가이익\r\n"
						//+ "							              avg(DECODE(ANALYSIS_YN,'0',l_var)) l_var, \r\n"
						+ "							              sum(DECODE(ANALYSIS_YN,'0',l_var_amt))/SUM(DECODE(ANALYSIS_YN,'0',car_amt1))*100 l_var, \r\n"						
						//+ "							              avg(DECODE(ANALYSIS_YN,'0',m_var)) m_var, \r\n"
						+ "                                       sum(DECODE(ANALYSIS_YN,'0',n_var))/sum(DECODE(ANALYSIS_YN,'0',DECODE(car_amt1,0,NULL,car_amt1)))*100 m_var,\r\n"
						+ "							              SUM  (DECODE(ANALYSIS_YN,'0',n_var)) n_var,  \r\n"		
						+ "							              sum  (DECODE(ANALYSIS_YN,'0',l_var_amt)) l_var_s_amt, \r\n"
						+ "							              sum(DECODE(ANALYSIS_YN,'0',l_var_amt))/COUNT(DECODE(ANALYSIS_YN,'0',car_mng_id)) l_var_a_amt  \r\n"						
						+ "							       FROM   stat_sui\r\n"
						+ "							       WHERE  cont_dt >= '20130101'\r\n"+where_query
						+ " 						   )   \r\n"
						+ "          ) b \r\n"
						+ "where a.cont_year=b.cont_year(+) and a.jg_2=b.jg_2(+)\r\n"
						+ "ORDER BY 1,2";
				
	

			
			}else {
				
				query = "SELECT jg_2, \r\n";
						
				for (int i = 0 ; i < 13 ; i++){
					query += " sum(DECODE(cont_month,"+(i+1)+",e_var)) e_var"+(i+1)+", avg(DECODE(cont_month,"+(i+1)+",f_var)) f_var"+(i+1)+", avg(DECODE(cont_month,"+(i+1)+",m_var)) m_var"+(i+1)+", avg(DECODE(cont_month,"+(i+1)+",o_var)) o_var"+(i+1)+", \n";
				}
						
				query += "       COUNT(0) cnt \r\n"     //sum(e_var) e_var13, round(avg(f_var),2) f_var13, round(avg(m_var),2) m_var13, trunc(avg(o_var)) o_var13, 
						+ "FROM (\r\n"
						+ "       SELECT \r\n"
						+ "              TO_NUMBER(cont_month) cont_month, jg_2, e_var, ROUND(f_var,2) f_var, \r\n"
//						+ "              ROUND(( j_var + (POWER((56.7/80),(f_var-k_var)/24)*80)-(POWER((56.7/80),f_var/24)*80) ),2) m_var, \r\n"
//						+ "              TRUNC( i_var * ( j_var + (POWER((56.7/80),(f_var-k_var)/24)*80)-(POWER((56.7/80),f_var/24)*80) ) /100 /e_var) o_var \r\n"
                        + "              ROUND(m_var,2) m_var, TRUNC(n_var/e_var) o_var \r\n"
						+ "       FROM \r\n"
						+ "              ("
						+ "               select \r\n"
						+ "                     SUBSTR(cont_dt,5,2) cont_month, DECODE(jg_2,'1','LPG','비LPG') jg_2,--LPG구분 \r\n"
						+ "                     COUNT(0) d_var, --총매각대수\r\n"
						+ "                     COUNT(DECODE(ANALYSIS_YN,'0',car_mng_id)) e_var,  --분석대수       \r\n"
						+ "                     avg(DECODE(ANALYSIS_YN,'0',car_mon)) f_var,  --차령(평균)\r\n"
						+ "                     SUM  (DECODE(ANALYSIS_YN,'0',tot_pnl_amt)) g_var,  --잔가손익(합계)-잔가총손익\r\n"
						+ "                     sum(DECODE(ANALYSIS_YN,'0',tot_pnl_amt))/COUNT(DECODE(ANALYSIS_YN,'0',car_mng_id)) h_var,  --대당잔가손익\r\n"
						+ "                     SUM  (DECODE(ANALYSIS_YN,'0',car_amt1)) i_var,  --소비자가(합계)-신차소비자가\r\n"
						+ "                     sum(DECODE(ANALYSIS_YN,'0',tot_pnl_amt))/sum(DECODE(ANALYSIS_YN,'0',DECODE(car_amt1,0,NULL,car_amt1)))*100 j_var,\r\n"
						+ "                     avg(DECODE(ANALYSIS_YN,'0',cont_mon1)) k_var, --장기계약 잔가 손익비교시 미포함 대여기간(평균)\r\n"
						//+ "						avg(DECODE(ANALYSIS_YN,'0',m_var)) m_var, \r\n"
						+ "                     sum(DECODE(ANALYSIS_YN,'0',n_var))/sum(DECODE(ANALYSIS_YN,'0',DECODE(car_amt1,0,NULL,car_amt1)))*100 m_var,\r\n"
						+ "						SUM  (DECODE(ANALYSIS_YN,'0',n_var)) n_var  \r\n"																		
						+ "               FROM   stat_sui\r\n"
						+ "               WHERE  cont_dt LIKE '"+s_yy+"%'\r\n"+where_query
				    	+ "               GROUP BY SUBSTR(cont_dt,5,2), jg_2 \r\n"
				    	+ "               UNION all       \r\n"
				    	+ "				  select \r\n"
				    	+ "					    '13' cont_month, DECODE(jg_2,'1','LPG','비LPG') jg_2,--LPG구분 \r\n"
				    	+ "						COUNT(0) d_var, --총매각대수\r\n"
				    	+ "						COUNT(DECODE(ANALYSIS_YN,'0',car_mng_id)) e_var,  --분석대수       \r\n"
				    	+ "						avg(DECODE(ANALYSIS_YN,'0',car_mon)) f_var,  --차령(평균)\r\n"
				    	+ "						SUM  (DECODE(ANALYSIS_YN,'0',tot_pnl_amt)) g_var,  --잔가손익(합계)-잔가총손익\r\n"
				    	+ "						sum(DECODE(ANALYSIS_YN,'0',tot_pnl_amt))/COUNT(DECODE(ANALYSIS_YN,'0',car_mng_id)) h_var,  --대당잔가손익\r\n"
				    	+ "						SUM  (DECODE(ANALYSIS_YN,'0',car_amt1)) i_var,  --소비자가(합계)-신차소비자가\r\n"
				    	+ "						sum(DECODE(ANALYSIS_YN,'0',tot_pnl_amt))/sum(DECODE(ANALYSIS_YN,'0',DECODE(car_amt1,0,NULL,car_amt1)))*100 j_var,\r\n"
				    	+ "						avg(DECODE(ANALYSIS_YN,'0',cont_mon1)) k_var, --장기계약 잔가 손익비교시 미포함 대여기간(평균)\r\n"
						//+ "						avg(DECODE(ANALYSIS_YN,'0',m_var)) m_var, \r\n"
						+ "                     sum(DECODE(ANALYSIS_YN,'0',n_var))/sum(DECODE(ANALYSIS_YN,'0',DECODE(car_amt1,0,NULL,car_amt1)))*100 m_var,\r\n"				    	
						+ "						SUM  (DECODE(ANALYSIS_YN,'0',n_var)) n_var  \r\n"																						    	
				    	+ "				  FROM   stat_sui\r\n"
				    	+ "				  WHERE  cont_dt LIKE '"+s_yy+"%'\r\n"+where_query
				    	+ "               GROUP BY jg_2"
				    	+ "              ) \r\n"
						+ "       )\r\n"
						+ "GROUP BY jg_2\r\n"
			            +" ";
				
				query += "union all  \r\n";
				
				query += "SELECT '소계' jg_2, \r\n";
				
				for (int i = 0 ; i < 13 ; i++){
					query += " sum(DECODE(cont_month,"+(i+1)+",e_var)) e_var"+(i+1)+", avg(DECODE(cont_month,"+(i+1)+",f_var)) f_var"+(i+1)+", avg(DECODE(cont_month,"+(i+1)+",m_var)) m_var"+(i+1)+", avg(DECODE(cont_month,"+(i+1)+",o_var)) o_var"+(i+1)+", \n";
				}
						
				query += "       COUNT(0) cnt \r\n"     //sum(e_var) e_var13, round(avg(f_var),2) f_var13, round(avg(m_var),2) m_var13, trunc(avg(o_var)) o_var13, 
						+ "FROM (\r\n"
						+ "       SELECT \r\n"
						+ "              TO_NUMBER(cont_month) cont_month, jg_2, e_var, ROUND(f_var,2) f_var, \r\n"
//						+ "              ROUND(( j_var + (POWER((56.7/80),(f_var-k_var)/24)*80)-(POWER((56.7/80),f_var/24)*80) ),2) m_var, \r\n"
//						+ "              TRUNC( i_var * ( j_var + (POWER((56.7/80),(f_var-k_var)/24)*80)-(POWER((56.7/80),f_var/24)*80) ) /100 /e_var) o_var \r\n"
                        + "              ROUND(m_var,2) m_var, TRUNC(n_var/e_var) o_var \r\n"
						+ "       FROM \r\n"
						+ "              ("
						+ "               select \r\n"
						+ "                     SUBSTR(cont_dt,5,2) cont_month, '소계' jg_2,--LPG구분 \r\n"
						+ "                     COUNT(0) d_var, --총매각대수\r\n"
						+ "                     COUNT(DECODE(ANALYSIS_YN,'0',car_mng_id)) e_var,  --분석대수       \r\n"
						+ "                     avg(DECODE(ANALYSIS_YN,'0',car_mon)) f_var,  --차령(평균)\r\n"
						+ "                     SUM  (DECODE(ANALYSIS_YN,'0',tot_pnl_amt)) g_var,  --잔가손익(합계)-잔가총손익\r\n"
						+ "                     sum(DECODE(ANALYSIS_YN,'0',tot_pnl_amt))/COUNT(DECODE(ANALYSIS_YN,'0',car_mng_id)) h_var,  --대당잔가손익\r\n"
						+ "                     SUM  (DECODE(ANALYSIS_YN,'0',car_amt1)) i_var,  --소비자가(합계)-신차소비자가\r\n"
						+ "                     sum(DECODE(ANALYSIS_YN,'0',tot_pnl_amt))/sum(DECODE(ANALYSIS_YN,'0',DECODE(car_amt1,0,NULL,car_amt1)))*100 j_var,\r\n"
						+ "                     avg(DECODE(ANALYSIS_YN,'0',cont_mon1)) k_var, --장기계약 잔가 손익비교시 미포함 대여기간(평균)\r\n"
						//+ "						avg(DECODE(ANALYSIS_YN,'0',m_var)) m_var, \r\n"
						+ "                     sum(DECODE(ANALYSIS_YN,'0',n_var))/sum(DECODE(ANALYSIS_YN,'0',DECODE(car_amt1,0,NULL,car_amt1)))*100 m_var,\r\n"
						+ "						SUM  (DECODE(ANALYSIS_YN,'0',n_var)) n_var  \r\n"																		
						+ "               FROM   stat_sui\r\n"
						+ "               WHERE  cont_dt LIKE '"+s_yy+"%'\r\n"+where_query
					    + "               GROUP BY SUBSTR(cont_dt,5,2) \r\n"
					    + "               UNION all       \r\n"
					    + "				  select \r\n"
					    + "						'13' cont_month, '소계' jg_2,--LPG구분 \r\n"
					    + "						COUNT(0) d_var, --총매각대수\r\n"
					    + "						COUNT(DECODE(ANALYSIS_YN,'0',car_mng_id)) e_var,  --분석대수       \r\n"
					    + "						avg(DECODE(ANALYSIS_YN,'0',car_mon)) f_var,  --차령(평균)\r\n"
					    + "						SUM  (DECODE(ANALYSIS_YN,'0',tot_pnl_amt)) g_var,  --잔가손익(합계)-잔가총손익\r\n"
					    + "						sum(DECODE(ANALYSIS_YN,'0',tot_pnl_amt))/COUNT(DECODE(ANALYSIS_YN,'0',car_mng_id)) h_var,  --대당잔가손익\r\n"
					    + "						SUM  (DECODE(ANALYSIS_YN,'0',car_amt1)) i_var,  --소비자가(합계)-신차소비자가\r\n"
					    + "						sum(DECODE(ANALYSIS_YN,'0',tot_pnl_amt))/sum(DECODE(ANALYSIS_YN,'0',DECODE(car_amt1,0,NULL,car_amt1)))*100 j_var,\r\n"
					    + "						avg(DECODE(ANALYSIS_YN,'0',cont_mon1)) k_var, --장기계약 잔가 손익비교시 미포함 대여기간(평균)\r\n"
						//+ "						avg(DECODE(ANALYSIS_YN,'0',m_var)) m_var, \r\n"
						+ "                     sum(DECODE(ANALYSIS_YN,'0',n_var))/sum(DECODE(ANALYSIS_YN,'0',DECODE(car_amt1,0,NULL,car_amt1)))*100 m_var,\r\n"
						+ "						SUM  (DECODE(ANALYSIS_YN,'0',n_var)) n_var  \r\n"																		
					    + "				  FROM   stat_sui\r\n"
					    + "				  WHERE  cont_dt LIKE '"+s_yy+"%'\r\n"+where_query
					    + "              )   \r\n"
						+ "       )\r\n"
			            +" ";				
				
				
				
			}


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
						 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
					}
					vt.add(ht);	
				}
			    rs.close();
	            pstmt.close();	

			}catch(SQLException e){
				System.out.println("[Offls_cmpltDatabase:getSuiStatLst2()]"+e);
				System.out.println("[Offls_cmpltDatabase:getSuiStatLst2()]"+query);
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
		
		
		public Vector getSuiAbNm(String st, String car_comp_id){
			getConnection();
			Vector vt = new Vector();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String query = "";
			
			query = "  SELECT a.car_comp_id, b.nm \r\n"
					+ "FROM \r\n"
					+ "       ( SELECT car_comp_id FROM stat_sui WHERE  cont_dt >= '20130101' GROUP BY car_comp_id ) a, \r\n"
					+ "       ( SELECT * FROM code WHERE c_st='0001' AND code<>'0000') b\r\n"
					+ "WHERE  a.car_comp_id=b.code       \r\n"
					+ "ORDER BY DECODE(a.car_comp_id,'0001','1','0002','2','0003','3','0004','4','0005','5','9'), b.nm";
			
			if(st.equals("2")) {
				query = "SELECT car_comp_id, ab_nm\r\n"
						+ "FROM   stat_sui\r\n"
						+ "WHERE  cont_dt >= '20130101' ";
				
				if(!car_comp_id.equals("")) { 
					query += " AND car_comp_id ='"+car_comp_id+"'\r\n";
				}
						
				query += "GROUP BY car_comp_id, ab_nm\r\n"
						+ "ORDER BY car_comp_id, ab_nm";
			}

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
						 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
					}
					vt.add(ht);	
				}
			    rs.close();
	            pstmt.close();	

			}catch(SQLException e){
				System.out.println("[Offls_cmpltDatabase:getSuiAbNm]"+e);
				System.out.println("[Offls_cmpltDatabase:getSuiAbNm]"+query);
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