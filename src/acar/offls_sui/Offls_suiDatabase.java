/**
 * 오프리스 수의매각
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2003. 05. 22. Thu.
 * @ last modify date : 
 */
package acar.offls_sui;

import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;
import acar.exception.DatabaseException;

public class Offls_suiDatabase
{
	private Connection conn = null;
	public static Offls_suiDatabase db;
	
	public static Offls_suiDatabase getInstance()
	{
		if(Offls_suiDatabase.db == null)
			Offls_suiDatabase.db = new Offls_suiDatabase();
		return Offls_suiDatabase.db;
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
	*	상품관리에서 수의로 2003.5.22.Thu.
	*/
	public int setOffls_sui(String[] sui){
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = "UPDATE car_reg SET off_ls = '4' WHERE car_mng_id in ('";		
		
		for(int i=0 ; i<sui.length ; i++){
			if(i == (sui.length -1))	query += sui[i];
			else						query += sui[i]+"', '";
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
				System.out.println("[Offls_suiDatabase:setOffls_sui(String[] sui)]"+se);
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
	*	상품관리에서 폐차로 2003.5.22.Thu.
	*/
	public int setOffls_junk(String[] sui){
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = "UPDATE car_reg SET off_ls = '7' WHERE car_mng_id in ('";		
		
		for(int i=0 ; i<sui.length ; i++){
			if(i == (sui.length -1))	query += sui[i];
			else						query += sui[i]+"', '";
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
				System.out.println("[Offls_suiDatabase:setOffls_junk(String[] sui)]"+se);
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
	*	수의계약 차량을 다시 상품관리로 2003.6.3.Tue.
	*/
	public int cancelOffls_sui(String[] sui){
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = "UPDATE car_reg SET off_ls = '1' WHERE car_mng_id in ('";		

		for(int i=0 ; i<sui.length ; i++){
			if(i == (sui.length -1))	query += sui[i];
			else						query += sui[i]+"', '";
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
					System.out.println("[Offls_suiDatabase:setOffls_pre(String[] pre)]"+se);
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
	*	예비차량 Bean에 데이터 넣기 2003.5.22.Thu.
	*/
	 private Offls_suiBean makeOffls_suiBean(ResultSet results) throws DatabaseException {

        try {
            Offls_suiBean bean = new Offls_suiBean();

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
			bean.setAss_st_dt(results.getString("ASS_ST_DT"));
			bean.setAss_ed_dt(results.getString("ASS_ED_DT"));
			bean.setMm_pr(results.getInt("MM_PR"));

		return bean;

        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}
	
	/**
	*	예비차량 상세정보 2003.5.22.Thu.
	*/
	public Offls_suiBean getSui_detail(String car_mng_id){
		getConnection();
		Offls_suiBean detail = new Offls_suiBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = "select	r.car_mng_id CAR_MNG_ID, r.car_no CAR_NO, cg.car_no	CAR_PRE_NO,	cgg.cha_dt CHA_DT, r.car_num CAR_NUM, r.init_reg_dt	INIT_REG_DT, "+
			"	        r.car_kd CAR_KD, r.car_use	CAR_USE, n.car_nm CAR_JNM, m.car_name CAR_NM, r.car_form CAR_FORM, r.car_y_form	CAR_Y_FORM,	"+
			"	        r.dpm DPM, r.fuel_kd FUEL_KD, r.maint_st_dt	MAINT_ST_DT, r.maint_end_dt	MAINT_END_DT, r.test_st_dt TEST_ST_DT, r.test_end_dt TEST_END_DT, "+
			"           r.car_l_cd CAR_L_CD, e.rent_mng_id RENT_MNG_ID,	e.rent_l_cd RENT_L_CD, e.car_id CAR_ID,	e.colo COLO, e.opt OPT,	"+
			"           e.car_cs_amt CAR_CS_AMT, e.car_cv_amt CAR_CV_AMT, e.car_fs_amt CAR_FS_AMT, e.car_fv_amt	CAR_FV_AMT,	"+
			"           e.opt_cs_amt OPT_CS_AMT, e.opt_cv_amt OPT_CV_AMT, e.opt_fs_amt OPT_FS_AMT, e.opt_fv_amt	OPT_FV_AMT,	"+
			"           e.clr_cs_amt CLR_CS_AMT, e.clr_cv_amt CLR_CV_AMT, e.clr_fs_amt CLR_FS_AMT, e.clr_fv_amt	CLR_FV_AMT,	"+			
			"           e.sd_cs_amt SD_CS_AMT, e.sd_cv_amt SD_CV_AMT, e.sd_fs_amt SD_FS_AMT, e.sd_fv_amt SD_FV_AMT,	"+
			"           e.dc_cs_amt DC_CS_AMT, e.dc_cv_amt DC_CV_AMT, e.dc_fs_amt DC_FS_AMT, e.dc_fv_amt DC_FV_AMT, "+
			"           c.mng_id MNG_ID, c.dlv_dt DLV_DT, decode(r.car_mng_id, sq.car_mng_id, 1, 0) ACCIDENT_YN, "+
			"           vt.tot_dist TOT_DIST, "+
			"           decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD'))))) as AVERAGE_DIST, "+
			"           decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST, "+
			"           bk.bank_nm BANK_NM, bk.lend_prn LEND_PRN, sw.alt_rest	LEND_REM, bk.alt_end_dt ALT_END_DT, "+
			"           s.lev LEV, s.reason REASON, s.car_st CAR_ST,s.imgfile1 IMGFILE1, s.imgfile2 IMGFILE2, s.imgfile3 IMGFILE3, s.imgfile4 IMGFILE4, s.imgfile5 IMGFILE5, "+
			"           s.damdang_id DAMDANG_ID, s.modify_id MODIFY_ID, s.apprsl_dt APPRSL_DT, DECODE(r.car_mng_id, ch.car_mng_id, 1, 0) CAR_CHA_YN, "+
			"           iu.ins_com_nm INS_COM_NM, iu.ins_exp_dt INS_EXP_DT, u.ass_st_dt ASS_ST_DT, u.ass_ed_dt ASS_ED_DT, u.mm_pr MM_PR "+
			" from car_reg r, car_etc e, cont c, apprsl s, sui u,  CAR_NM m, CAR_MNG n, v_tot_dist vt, "+
			"   (select car_mng_id from accident group by car_mng_id) sq, "+
			"	(select a.car_mng_id CAR_MNG_ID, a.serv_dt SERV_DT, a.tot_dist TOT_DIST  from service a where a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where car_mng_id = a.car_mng_id)) i, "+
			"	(select al.rent_mng_id RENT_MNG_ID, al.rent_l_cd RENT_L_CD, cd.nm BANK_NM , al.lend_prn LEND_PRN, al.alt_end_dt ALT_END_DT from allot al, code cd where al.cpt_cd = cd.code and cd.c_st = '0003') bk, "+
			"	(SELECT DISTINCT cc.car_mng_id CAR_MNG_ID FROM car_cha cc, car_reg re WHERE cc.car_mng_id = re.car_mng_id) ch, "+
			"	(SELECT car_mng_id, cha_dt, car_no FROM car_change a WHERE a.cha_seq = to_char(to_number((select max(b.cha_seq) from car_change b where a.car_mng_id = b.car_mng_id))-1)) cg "+
			",	(SELECT car_mng_id, cha_dt, car_no FROM car_change a WHERE a.cha_seq = to_char(to_number((select max(b.cha_seq) from car_change b where a.car_mng_id = b.car_mng_id and b.cha_seq>1)))) cgg "+
			",	(SELECT sc.car_mng_id CAR_MNG_ID, sc.alt_rest ALT_REST FROM scd_alt_case sc WHERE sc.alt_tm = (select max(alt_tm) from scd_alt_case where car_mng_id = sc.car_mng_id)) sw "+
			", (select ir.car_mng_id CAR_MNG_ID, ic.ins_com_nm INS_COM_NM, ir.ins_exp_dt INS_EXP_DT from insur ir, ins_com ic where ir.ins_com_id = ic.ins_com_id and ir.ins_st = (select max(ins_st) from insur where car_mng_id = ir.car_mng_id)) iu "+
			" where "+
			"  r.car_mng_id = '"+car_mng_id+"' "+			
			"  and r.car_mng_id = c.car_mng_id "+
			"  and e.rent_mng_id = c.rent_mng_id "+
			"  and e.rent_l_cd = c.rent_l_cd "+
			"  and r.car_mng_id = sq.car_mng_id(+) "+
			"  and c.car_st = '2' "+
			"  and c.use_yn = 'Y' "+
			"  and r.off_ls = '4' "+
			"  and r.car_mng_id = i.car_mng_id(+) "+
			"  and c.rent_mng_id = bk.rent_mng_id(+) "+
			"  and c.rent_l_cd = bk.rent_l_cd(+) "+
			"  and r.car_mng_id = s.car_mng_id(+) "+
			"  and r.car_mng_id = ch.car_mng_id(+) "+
			"  AND r.car_mng_id = cg.car_mng_id(+) "+
			"  AND r.car_mng_id = cgg.car_mng_id(+) "+
			"  AND r.car_mng_id = sw.car_mng_id(+) "+
			"  and r.car_mng_id = iu.car_mng_id(+) "+
			"  AND e.car_id = m.car_id "+	
			"  and e.car_seq = m.car_seq "+
			"  and m.car_comp_id = n.car_comp_id "+
			"  and m.car_cd = n.code "+
			"  and r.car_mng_id = vt.car_mng_id(+) "+
			"  ";

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while(rs.next()){
				detail = makeOffls_suiBean(rs);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_suiDatabase:getSui_detail(String car_mng_id)]"+e);
			System.out.println("[Offls_suiDatabase:getSui_detail(String car_mng_id)]"+query);
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
	*	예비차량 상세정보 2003.5.22.Thu.
	*/
	public Offls_suiBean getJunk_detail(String car_mng_id){
		getConnection();
		Offls_suiBean detail = new Offls_suiBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = "select	r.car_mng_id CAR_MNG_ID, r.car_no CAR_NO, cg.car_no	CAR_PRE_NO,	cgg.cha_dt CHA_DT, r.car_num CAR_NUM, r.init_reg_dt	INIT_REG_DT, r.car_kd CAR_KD, r.car_use	CAR_USE,  n.car_nm CAR_JNM, m.car_name CAR_NM,	r.car_form CAR_FORM, r.car_y_form	CAR_Y_FORM,	r.dpm			DPM,	r.fuel_kd		FUEL_KD,	r.maint_st_dt	MAINT_ST_DT,	r.maint_end_dt	MAINT_END_DT, r.test_st_dt TEST_ST_DT, r.test_end_dt TEST_END_DT, r.car_l_cd CAR_L_CD, e.rent_mng_id	RENT_MNG_ID,	e.rent_l_cd		RENT_L_CD,	e.car_id		CAR_ID,	e.colo			COLO,	e.opt			OPT,	e.car_cs_amt	CAR_CS_AMT,	e.car_cv_amt	CAR_CV_AMT,	e.car_fs_amt	CAR_FS_AMT,	e.car_fv_amt	CAR_FV_AMT,	e.opt_cs_amt	OPT_CS_AMT,	e.opt_cv_amt	OPT_CV_AMT,	e.opt_fs_amt	OPT_FS_AMT,	e.opt_fv_amt	OPT_FV_AMT,	e.clr_cs_amt	CLR_CS_AMT,	e.clr_cv_amt	CLR_CV_AMT,	e.clr_fs_amt	CLR_FS_AMT,	e.clr_fv_amt	CLR_FV_AMT,	e.sd_cs_amt		SD_CS_AMT,	e.sd_cv_amt		SD_CV_AMT,	e.sd_fs_amt		SD_FS_AMT,	e.sd_fv_amt		SD_FV_AMT,	e.dc_cs_amt		DC_CS_AMT,	e.dc_cv_amt		DC_CV_AMT,	e.dc_fs_amt		DC_FS_AMT,	e.dc_fv_amt		DC_FV_AMT, c.mng_id		MNG_ID,	c.dlv_dt DLV_DT, decode(r.car_mng_id, sq.car_mng_id, 1, 0) ACCIDENT_YN, "+
			" vt.tot_dist TOT_DIST, "+
			" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD'))))) as AVERAGE_DIST, "+
			" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST, "+
			" bk.bank_nm BANK_NM, bk.lend_prn LEND_PRN, sw.alt_rest	LEND_REM, bk.alt_end_dt ALT_END_DT, s.lev LEV, s.reason REASON, s.car_st CAR_ST,s.imgfile1 IMGFILE1, s.imgfile2 IMGFILE2, s.imgfile3 IMGFILE3, s.imgfile4 IMGFILE4, s.imgfile5 IMGFILE5, s.damdang_id DAMDANG_ID, s.modify_id MODIFY_ID, s.apprsl_dt APPRSL_DT, DECODE(r.car_mng_id, ch.car_mng_id, 1, 0) CAR_CHA_YN "+
			", iu.ins_com_nm INS_COM_NM, iu.ins_exp_dt INS_EXP_DT, u.ass_st_dt ASS_ST_DT, u.ass_ed_dt ASS_ED_DT, u.mm_pr MM_PR "+
			" from car_reg r, car_etc e, cont c, apprsl s, sui u,  CAR_NM m, CAR_MNG n, v_tot_dist vt, (select distinct ac.car_mng_id CAR_MNG_ID from accident ac, car_reg re where ac.car_mng_id=re.car_mng_id) sq, "+
			"	(select a.car_mng_id CAR_MNG_ID, a.serv_dt SERV_DT, a.tot_dist TOT_DIST  from service a where a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where car_mng_id = a.car_mng_id)) i, "+
			"	(select al.rent_mng_id RENT_MNG_ID, al.rent_l_cd RENT_L_CD, cd.nm BANK_NM , al.lend_prn LEND_PRN, al.alt_end_dt ALT_END_DT from allot al, code cd where al.cpt_cd = cd.code and cd.c_st = '0003') bk, "+
			"	(SELECT DISTINCT cc.car_mng_id CAR_MNG_ID FROM car_cha cc, car_reg re WHERE cc.car_mng_id = re.car_mng_id) ch, "+
			"	(SELECT car_mng_id, cha_dt, car_no FROM car_change a WHERE a.cha_seq = to_char(to_number((select max(b.cha_seq) from car_change b where a.car_mng_id = b.car_mng_id))-1)) cg "+
			",	(SELECT car_mng_id, cha_dt, car_no FROM car_change a WHERE a.cha_seq = to_char(to_number((select max(b.cha_seq) from car_change b where a.car_mng_id = b.car_mng_id and b.cha_seq>1)))) cgg "+
			",	(SELECT sc.car_mng_id CAR_MNG_ID, sc.alt_rest ALT_REST FROM scd_alt_case sc WHERE sc.alt_tm = (select max(alt_tm) from scd_alt_case where car_mng_id = sc.car_mng_id)) sw "+
			", (select ir.car_mng_id CAR_MNG_ID, ic.ins_com_nm INS_COM_NM, ir.ins_exp_dt INS_EXP_DT from insur ir, ins_com ic where ir.ins_com_id = ic.ins_com_id and ir.ins_st = (select max(ins_st) from insur where car_mng_id = ir.car_mng_id)) iu "+
			" where "+
			"      r.car_mng_id = '"+car_mng_id+"' "+			
			"  and r.car_mng_id = c.car_mng_id "+
			"  and e.rent_mng_id = c.rent_mng_id "+
			"  and e.rent_l_cd = c.rent_l_cd "+
			"  and r.car_mng_id = sq.car_mng_id(+) "+
			"  and c.car_st = '2' "+
			"  and c.use_yn = 'Y' "+
			"  and r.off_ls = '7' "+
			"  and r.car_mng_id = i.car_mng_id(+) "+
			"  and c.rent_mng_id = bk.rent_mng_id(+) "+
			"  and c.rent_l_cd = bk.rent_l_cd(+) "+
			"  and r.car_mng_id = s.car_mng_id(+) "+
			"  and r.car_mng_id = ch.car_mng_id(+) "+
			"  AND r.car_mng_id = cg.car_mng_id(+) "+
			"  AND r.car_mng_id = cgg.car_mng_id(+) "+
			"  AND r.car_mng_id = sw.car_mng_id(+) "+
			"  and r.car_mng_id = iu.car_mng_id(+) "+
			"  AND e.car_id = m.car_id "+	
			"  and e.car_seq = m.car_seq "+
			"  and m.car_comp_id = n.car_comp_id "+
			"  and m.car_cd = n.code "+
			"  and r.car_mng_id = vt.car_mng_id(+) "+
			"  ";

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while(rs.next()){
				detail = makeOffls_suiBean(rs);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_suiDatabase:getSui_detail(String car_mng_id)]"+e);
			System.out.println("[Offls_suiDatabase:getSui_detail(String car_mng_id)]"+query);
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
	*	회사별 매각준비차량 통계 - 2003.5.22.Thu.
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
"and c.off_ls = '4'  "+
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
"and c.off_ls = '4'     "+
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
"and c.off_ls = '4'     "+
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
"and c.off_ls = '4'     "+
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
"and c.off_ls = '4'    "+ 
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
				System.out.println("[Offls_suiDatabase:getTg()]"+e);
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
	*	폐차차량 - 수의계약과 유사.
	*/
	public Offls_suiBean[] getJunk_lst(String gubun, String gubun_nm){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String subQuery = "";

		if(gubun.equals("car_no")){
			subQuery = " and cg.car_no like '%" + gubun_nm + "%' ";
		}else if(gubun.equals("car_nm")){
			subQuery = " and r.car_nm like '%" + gubun_nm.toUpperCase() + "%' ";
		}else if(gubun.equals("init_reg_dt")){
			subQuery = " and r.init_reg_dt like replace('"+ gubun_nm +"','-','')||'%' ";
		}else{ //all
			subQuery = "";
		}

		if(gubun.equals("car_no")){
		query = "select	r.car_mng_id CAR_MNG_ID, r.car_no CAR_NO, cg.car_no	CAR_PRE_NO,	cg.cha_dt CHA_DT, r.car_num CAR_NUM, r.init_reg_dt	INIT_REG_DT, r.car_kd CAR_KD, r.car_use	CAR_USE, n.car_nm CAR_JNM, m.car_name CAR_NM, r.car_form CAR_FORM, r.car_y_form	CAR_Y_FORM,	r.dpm			DPM,	r.fuel_kd		FUEL_KD,	r.maint_st_dt	MAINT_ST_DT,	r.maint_end_dt	MAINT_END_DT, r.test_st_dt TEST_ST_DT, r.test_end_dt TEST_END_DT, r.car_l_cd, CAR_L_CD, e.rent_mng_id	RENT_MNG_ID,	e.rent_l_cd		RENT_L_CD,	e.car_id		CAR_ID,	e.colo			COLO, e.opt			OPT,	e.car_cs_amt	CAR_CS_AMT,	e.car_cv_amt	CAR_CV_AMT,	e.car_fs_amt	CAR_FS_AMT,	e.car_fv_amt	CAR_FV_AMT,	e.opt_cs_amt	OPT_CS_AMT,	e.opt_cv_amt	OPT_CV_AMT,	e.opt_fs_amt	OPT_FS_AMT,	e.opt_fv_amt	OPT_FV_AMT,	e.clr_cs_amt	CLR_CS_AMT,	e.clr_cv_amt	CLR_CV_AMT,	e.clr_fs_amt	CLR_FS_AMT,	e.clr_fv_amt	CLR_FV_AMT,	e.sd_cs_amt		SD_CS_AMT,	e.sd_cv_amt		SD_CV_AMT,	e.sd_fs_amt		SD_FS_AMT,	e.sd_fv_amt		SD_FV_AMT,	e.dc_cs_amt		DC_CS_AMT,	e.dc_cv_amt		DC_CV_AMT,	e.dc_fs_amt		DC_FS_AMT,	e.dc_fv_amt		DC_FV_AMT, c.mng_id		MNG_ID, c.dlv_dt DLV_DT,	decode(r.car_mng_id, sq.car_mng_id, 1, 0) ACCIDENT_YN, "+
			" vt.tot_dist TOT_DIST, "+
			" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD'))))) as AVERAGE_DIST, "+
			" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST, "+
			" bk.bank_nm BANK_NM, bk.lend_prn LEND_PRN, sw.alt_rest	LEND_REM, bk.alt_end_dt ALT_END_DT, s.lev LEV, s.reason REASON, s.car_st CAR_ST, s.imgfile1 IMGFILE1, s.imgfile2 IMGFILE2, s.imgfile3 IMGFILE3, s.imgfile4 IMGFILE4, s.imgfile5 IMGFILE5, s.damdang_id DAMDANG_ID, s.modify_id MODIFY_ID, s.apprsl_dt APPRSL_DT, DECODE(r.car_mng_id, ch.car_mng_id, 1, 0) CAR_CHA_YN "+
			", iu.ins_com_nm INS_COM_NM, iu.ins_exp_dt INS_EXP_DT, u.ass_st_dt ASS_ST_DT, u.ass_ed_dt ASS_ED_DT, u.mm_pr MM_PR "+
			" from car_reg r, car_etc e, cont c, apprsl s, CAR_NM m, CAR_MNG n, sui u, v_tot_dist vt, (select distinct ac.car_mng_id CAR_MNG_ID from accident ac, car_reg re where ac.car_mng_id=re.car_mng_id) sq, "+
			"	(select a.car_mng_id CAR_MNG_ID, a.serv_dt SERV_DT, a.tot_dist TOT_DIST  from service a where a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where car_mng_id = a.car_mng_id)) i, "+
			"	(select al.rent_mng_id RENT_MNG_ID, al.rent_l_cd RENT_L_CD, cd.nm BANK_NM, al.lend_prn LEND_PRN, al.alt_end_dt ALT_END_DT from allot al, code cd where al.cpt_cd = cd.code and cd.c_st = '0003') bk, "+
			"	(SELECT DISTINCT cc.car_mng_id CAR_MNG_ID FROM car_cha cc, car_reg re WHERE cc.car_mng_id = re.car_mng_id) ch, "+
			"	(SELECT car_mng_id, cha_dt, car_no FROM car_change a WHERE a.cha_seq = to_char(to_number((select max(b.cha_seq) from car_change b where a.car_mng_id = b.car_mng_id))-1)) cg, "+
			"	(SELECT sc.car_mng_id CAR_MNG_ID, sc.alt_rest ALT_REST FROM scd_alt_case sc WHERE sc.alt_tm = (select max(alt_tm) from scd_alt_case where car_mng_id = sc.car_mng_id)) sw "+
			", (select ir.car_mng_id CAR_MNG_ID, ic.ins_com_nm INS_COM_NM, ir.ins_exp_dt INS_EXP_DT from insur ir, ins_com ic where ir.ins_com_id = ic.ins_com_id and ir.ins_st = (select max(ins_st) from insur where car_mng_id = ir.car_mng_id)) iu "+
			" where r.car_mng_id = c.car_mng_id "+
			"  and e.rent_mng_id = c.rent_mng_id "+
			"  and e.rent_l_cd = c.rent_l_cd "+
			"  and r.car_mng_id = sq.car_mng_id(+) "+
			"  and c.car_st = '2' "+
			"  and c.use_yn = 'Y' "+
			"  and r.off_ls = '7' \n"+
			"  and r.car_mng_id = i.car_mng_id(+) "+
			"  and c.rent_mng_id = bk.rent_mng_id(+) "+
			"  and c.rent_l_cd = bk.rent_l_cd(+) "+
			"  and r.car_mng_id = s.car_mng_id(+) "+
			"  and r.car_mng_id = ch.car_mng_id(+) "+
			"  AND r.car_mng_id = cg.car_mng_id(+) "+
			"  AND r.car_mng_id = sw.car_mng_id(+) "+
			"  and r.car_mng_id = iu.car_mng_id(+) "+
			"  AND e.car_id = m.car_id "+	
			"  and e.car_seq = m.car_seq "+
			"  and m.car_comp_id = n.car_comp_id "+
			"  and m.car_cd = n.code "+
			"  AND r.car_mng_id = u.car_mng_id(+) "+
			"  AND r.car_mng_id = vt.car_mng_id(+) "+
				subQuery +
			" ORDER BY init_reg_dt ";
		}else{
		query = "select	r.car_mng_id CAR_MNG_ID, r.car_no CAR_NO, cg.car_no	CAR_PRE_NO,	cg.cha_dt CHA_DT, r.car_num CAR_NUM, r.init_reg_dt	INIT_REG_DT, r.car_kd CAR_KD, r.car_use	CAR_USE, n.car_nm CAR_JNM, m.car_name CAR_NM, r.car_form CAR_FORM, r.car_y_form	CAR_Y_FORM,	r.dpm			DPM,	r.fuel_kd		FUEL_KD,	r.maint_st_dt	MAINT_ST_DT,	r.maint_end_dt	MAINT_END_DT, r.test_st_dt TEST_ST_DT, r.test_end_dt TEST_END_DT, r.car_l_cd, CAR_L_CD, e.rent_mng_id	RENT_MNG_ID,	e.rent_l_cd		RENT_L_CD,	e.car_id		CAR_ID,	e.colo			COLO, e.opt			OPT,	e.car_cs_amt	CAR_CS_AMT,	e.car_cv_amt	CAR_CV_AMT,	e.car_fs_amt	CAR_FS_AMT,	e.car_fv_amt	CAR_FV_AMT,	e.opt_cs_amt	OPT_CS_AMT,	e.opt_cv_amt	OPT_CV_AMT,	e.opt_fs_amt	OPT_FS_AMT,	e.opt_fv_amt	OPT_FV_AMT,	e.clr_cs_amt	CLR_CS_AMT,	e.clr_cv_amt	CLR_CV_AMT,	e.clr_fs_amt	CLR_FS_AMT,	e.clr_fv_amt	CLR_FV_AMT,	e.sd_cs_amt		SD_CS_AMT,	e.sd_cv_amt		SD_CV_AMT,	e.sd_fs_amt		SD_FS_AMT,	e.sd_fv_amt		SD_FV_AMT,	e.dc_cs_amt		DC_CS_AMT,	e.dc_cv_amt		DC_CV_AMT,	e.dc_fs_amt		DC_FS_AMT,	e.dc_fv_amt		DC_FV_AMT, c.mng_id		MNG_ID, c.dlv_dt DLV_DT,	decode(r.car_mng_id, sq.car_mng_id, 1, 0) ACCIDENT_YN, "+
			" vt.tot_dist TOT_DIST, "+
			" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD'))))) as AVERAGE_DIST, "+
			" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST, "+
			" bk.bank_nm BANK_NM, bk.lend_prn LEND_PRN, sw.alt_rest	LEND_REM, bk.alt_end_dt ALT_END_DT, s.lev LEV, s.reason REASON, s.car_st CAR_ST, s.imgfile1 IMGFILE1, s.imgfile2 IMGFILE2, s.imgfile3 IMGFILE3, s.imgfile4 IMGFILE4, s.imgfile5 IMGFILE5, s.damdang_id DAMDANG_ID, s.modify_id MODIFY_ID, s.apprsl_dt APPRSL_DT, DECODE(r.car_mng_id, ch.car_mng_id, 1, 0) CAR_CHA_YN "+
			", iu.ins_com_nm INS_COM_NM, iu.ins_exp_dt INS_EXP_DT, u.ass_st_dt ASS_ST_DT, u.ass_ed_dt ASS_ED_DT, u.mm_pr MM_PR "+
			" from car_reg r, car_etc e, cont c, apprsl s, CAR_NM m, CAR_MNG n, sui u, v_tot_dist vt, (select distinct ac.car_mng_id CAR_MNG_ID from accident ac, car_reg re where ac.car_mng_id=re.car_mng_id) sq, "+
			"	(select a.car_mng_id CAR_MNG_ID, a.serv_dt SERV_DT, a.tot_dist TOT_DIST  from service a where a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where car_mng_id = a.car_mng_id)) i, "+
			"	(select al.rent_mng_id RENT_MNG_ID, al.rent_l_cd RENT_L_CD, cd.nm BANK_NM, al.lend_prn LEND_PRN, al.alt_end_dt ALT_END_DT from allot al, code cd where al.cpt_cd = cd.code and cd.c_st = '0003') bk, "+
			"	(SELECT DISTINCT cc.car_mng_id CAR_MNG_ID FROM car_cha cc, car_reg re WHERE cc.car_mng_id = re.car_mng_id) ch, "+
			"	(SELECT car_mng_id, cha_dt, car_no FROM car_change a WHERE a.cha_seq = to_char(to_number((select max(b.cha_seq) from car_change b where a.car_mng_id = b.car_mng_id))-1)) cg, "+
			"	(SELECT sc.car_mng_id CAR_MNG_ID, sc.alt_rest ALT_REST FROM scd_alt_case sc WHERE sc.alt_tm = (select max(alt_tm) from scd_alt_case where car_mng_id = sc.car_mng_id)) sw "+
			", (select ir.car_mng_id CAR_MNG_ID, ic.ins_com_nm INS_COM_NM, ir.ins_exp_dt INS_EXP_DT from insur ir, ins_com ic where ir.ins_com_id = ic.ins_com_id and ir.ins_st = (select max(ins_st) from insur where car_mng_id = ir.car_mng_id)) iu "+
			" where r.car_mng_id = c.car_mng_id "+
			"  and e.rent_mng_id = c.rent_mng_id "+
			"  and e.rent_l_cd = c.rent_l_cd "+
			"  and r.car_mng_id = sq.car_mng_id(+) "+
			"  and c.car_st = '2' "+
			"  and c.use_yn = 'Y' "+
			"  and r.off_ls = '7' "+
			"  and r.car_mng_id = i.car_mng_id(+) "+
			"  and c.rent_mng_id = bk.rent_mng_id(+) "+
			"  and c.rent_l_cd = bk.rent_l_cd(+) "+
			"  and r.car_mng_id = s.car_mng_id(+) "+
			"  and r.car_mng_id = ch.car_mng_id(+) "+
			"  AND r.car_mng_id = cg.car_mng_id(+) "+
			"  AND r.car_mng_id = sw.car_mng_id(+) "+
			"  and r.car_mng_id = iu.car_mng_id(+) "+
			"  AND e.car_id = m.car_id "+	
			"  and e.car_seq = m.car_seq "+
			"  and m.car_comp_id = n.car_comp_id "+
			"  and m.car_cd = n.code "+
			"  AND r.car_mng_id = u.car_mng_id(+) "+
			"  AND r.car_mng_id = vt.car_mng_id(+) "+
				subQuery +
			" ORDER BY init_reg_dt ";
		}

		System.out.println("getJunk_lst= " +  query); 
		
		Collection<Offls_suiBean> col = new ArrayList<Offls_suiBean>();
		
		
		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while(rs.next()){
				col.add(makeOffls_suiBean(rs));
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_suiDatabase:getJunk_lst(String gubun, String gubun_nm)]"+e);
			System.out.println("[Offls_suiDatabase:getJunk_lst(String gubun, String gubun_nm)]"+query);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return (Offls_suiBean[])col.toArray(new Offls_suiBean[0]);
		}		
	}
	
	
	/**
	*	수의차량 검색 - 2003.5.22.Thu.
	*/
	public Offls_suiBean[] getSui_lst(String gubun, String gubun_nm){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String subQuery = "";

		if(gubun.equals("car_no")){
			subQuery = " and cg.car_no like '%" + gubun_nm + "%' ";		
		}else if(gubun.equals("car_nm")){
			subQuery = " and r.car_nm like '%" + gubun_nm.toUpperCase() + "%' ";
		}else if(gubun.equals("init_reg_dt")){
			subQuery = " and r.init_reg_dt like replace('"+ gubun_nm +"','-','')||'%' ";
		}else{ //all
			subQuery = "";
		}

		if(gubun.equals("car_no")){
		query = "select	r.car_mng_id CAR_MNG_ID, r.car_no CAR_NO, cg.car_no	CAR_PRE_NO,	cg.cha_dt CHA_DT, r.car_num CAR_NUM, r.init_reg_dt	INIT_REG_DT, r.car_kd CAR_KD, r.car_use	CAR_USE, n.car_nm CAR_JNM, m.car_name CAR_NM, r.car_form CAR_FORM, r.car_y_form	CAR_Y_FORM,	r.dpm			DPM,	r.fuel_kd		FUEL_KD,	r.maint_st_dt	MAINT_ST_DT,	r.maint_end_dt	MAINT_END_DT, r.test_st_dt TEST_ST_DT, r.test_end_dt TEST_END_DT, r.car_l_cd, CAR_L_CD, e.rent_mng_id	RENT_MNG_ID,	e.rent_l_cd		RENT_L_CD,	e.car_id		CAR_ID,	e.colo			COLO, e.opt			OPT,	e.car_cs_amt	CAR_CS_AMT,	e.car_cv_amt	CAR_CV_AMT,	e.car_fs_amt	CAR_FS_AMT,	e.car_fv_amt	CAR_FV_AMT,	e.opt_cs_amt	OPT_CS_AMT,	e.opt_cv_amt	OPT_CV_AMT,	e.opt_fs_amt	OPT_FS_AMT,	e.opt_fv_amt	OPT_FV_AMT,	e.clr_cs_amt	CLR_CS_AMT,	e.clr_cv_amt	CLR_CV_AMT,	e.clr_fs_amt	CLR_FS_AMT,	e.clr_fv_amt	CLR_FV_AMT,	e.sd_cs_amt		SD_CS_AMT,	e.sd_cv_amt		SD_CV_AMT,	e.sd_fs_amt		SD_FS_AMT,	e.sd_fv_amt		SD_FV_AMT,	e.dc_cs_amt		DC_CS_AMT,	e.dc_cv_amt		DC_CV_AMT,	e.dc_fs_amt		DC_FS_AMT,	e.dc_fv_amt		DC_FV_AMT, c.mng_id		MNG_ID, c.dlv_dt DLV_DT,	decode(r.car_mng_id, sq.car_mng_id, 1, 0) ACCIDENT_YN, "+
			" vt.tot_dist TOT_DIST, "+
			" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD'))))) as AVERAGE_DIST, "+
			" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST, "+
			" bk.bank_nm BANK_NM, bk.lend_prn LEND_PRN, sw.alt_rest	LEND_REM, bk.alt_end_dt ALT_END_DT, s.lev LEV, s.reason REASON, s.car_st CAR_ST, s.imgfile1 IMGFILE1, s.imgfile2 IMGFILE2, s.imgfile3 IMGFILE3, s.imgfile4 IMGFILE4, s.imgfile5 IMGFILE5, s.damdang_id DAMDANG_ID, s.modify_id MODIFY_ID, s.apprsl_dt APPRSL_DT, '' CAR_CHA_YN "+
			", iu.ins_com_nm INS_COM_NM, iu.ins_exp_dt INS_EXP_DT, u.ass_st_dt ASS_ST_DT, u.ass_ed_dt ASS_ED_DT, u.mm_pr MM_PR "+
			" from car_reg r, car_etc e, cont c, apprsl s, CAR_NM m, CAR_MNG n, sui u, v_tot_dist vt, (select distinct ac.car_mng_id CAR_MNG_ID from accident ac, car_reg re where ac.car_mng_id=re.car_mng_id) sq, "+
			"	(select a.car_mng_id CAR_MNG_ID, a.serv_dt SERV_DT, a.tot_dist TOT_DIST  from service a where a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where car_mng_id = a.car_mng_id)) i, "+
			"	(select al.rent_mng_id RENT_MNG_ID, al.rent_l_cd RENT_L_CD, cd.nm BANK_NM, al.lend_prn LEND_PRN, al.alt_end_dt ALT_END_DT from allot al, code cd where al.cpt_cd = cd.code and cd.c_st = '0003') bk, "+
		//	"	(SELECT DISTINCT cc.car_mng_id CAR_MNG_ID FROM car_cha cc, car_reg re WHERE cc.car_mng_id = re.car_mng_id) ch, "+
			"	(SELECT car_mng_id, cha_dt, car_no FROM car_change a WHERE a.cha_seq = to_char(to_number((select max(b.cha_seq) from car_change b where a.car_mng_id = b.car_mng_id))-1)) cg, "+
			"	(SELECT sc.car_mng_id CAR_MNG_ID, sc.alt_rest ALT_REST FROM scd_alt_case sc WHERE sc.alt_tm = (select max(alt_tm) from scd_alt_case where car_mng_id = sc.car_mng_id)) sw "+
			", (select ir.car_mng_id CAR_MNG_ID, ic.ins_com_nm INS_COM_NM, ir.ins_exp_dt INS_EXP_DT from insur ir, ins_com ic where ir.ins_com_id = ic.ins_com_id and ir.ins_st = (select max(ins_st) from insur where car_mng_id = ir.car_mng_id)) iu "+
			" where r.car_mng_id = c.car_mng_id "+
			"  and e.rent_mng_id = c.rent_mng_id "+
			"  and e.rent_l_cd = c.rent_l_cd "+
			"  and r.car_mng_id = sq.car_mng_id(+) "+
			"  and c.car_st = '2' "+
			"  and c.use_yn = 'Y' "+
			"  and r.off_ls = '7' "+
			"  and r.car_mng_id = i.car_mng_id(+) "+
			"  and c.rent_mng_id = bk.rent_mng_id(+) "+
			"  and c.rent_l_cd = bk.rent_l_cd(+) "+
			"  and r.car_mng_id = s.car_mng_id(+) "+
		//	"  and r.car_mng_id = ch.car_mng_id(+) "+
			"  AND r.car_mng_id = cg.car_mng_id(+) "+
			"  AND r.car_mng_id = sw.car_mng_id(+) "+
			"  and r.car_mng_id = iu.car_mng_id(+) "+
			"  AND e.car_id = m.car_id "+	
			"  and e.car_seq = m.car_seq "+
			"  and m.car_comp_id = n.car_comp_id "+
			"  and m.car_cd = n.code "+
			"  AND r.car_mng_id = u.car_mng_id(+) "+
			"  AND r.car_mng_id = vt.car_mng_id(+) "+
				subQuery +
			" ORDER BY init_reg_dt ";
		}else{
		query = "select	r.car_mng_id CAR_MNG_ID, r.car_no CAR_NO, cg.car_no	CAR_PRE_NO,	cg.cha_dt CHA_DT, r.car_num CAR_NUM, r.init_reg_dt	INIT_REG_DT, r.car_kd CAR_KD, r.car_use	CAR_USE, n.car_nm CAR_JNM, m.car_name CAR_NM, r.car_form CAR_FORM, r.car_y_form	CAR_Y_FORM,	r.dpm			DPM,	r.fuel_kd		FUEL_KD,	r.maint_st_dt	MAINT_ST_DT,	r.maint_end_dt	MAINT_END_DT, r.test_st_dt TEST_ST_DT, r.test_end_dt TEST_END_DT, r.car_l_cd, CAR_L_CD, e.rent_mng_id	RENT_MNG_ID,	e.rent_l_cd		RENT_L_CD,	e.car_id		CAR_ID,	e.colo			COLO, e.opt			OPT,	e.car_cs_amt	CAR_CS_AMT,	e.car_cv_amt	CAR_CV_AMT,	e.car_fs_amt	CAR_FS_AMT,	e.car_fv_amt	CAR_FV_AMT,	e.opt_cs_amt	OPT_CS_AMT,	e.opt_cv_amt	OPT_CV_AMT,	e.opt_fs_amt	OPT_FS_AMT,	e.opt_fv_amt	OPT_FV_AMT,	e.clr_cs_amt	CLR_CS_AMT,	e.clr_cv_amt	CLR_CV_AMT,	e.clr_fs_amt	CLR_FS_AMT,	e.clr_fv_amt	CLR_FV_AMT,	e.sd_cs_amt		SD_CS_AMT,	e.sd_cv_amt		SD_CV_AMT,	e.sd_fs_amt		SD_FS_AMT,	e.sd_fv_amt		SD_FV_AMT,	e.dc_cs_amt		DC_CS_AMT,	e.dc_cv_amt		DC_CV_AMT,	e.dc_fs_amt		DC_FS_AMT,	e.dc_fv_amt		DC_FV_AMT, c.mng_id		MNG_ID, c.dlv_dt DLV_DT,	decode(r.car_mng_id, sq.car_mng_id, 1, 0) ACCIDENT_YN, "+
			" vt.tot_dist TOT_DIST, "+
			" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD'))))) as AVERAGE_DIST, "+
			" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST, "+
			" bk.bank_nm BANK_NM, bk.lend_prn LEND_PRN, sw.alt_rest	LEND_REM, bk.alt_end_dt ALT_END_DT, s.lev LEV, s.reason REASON, s.car_st CAR_ST, s.imgfile1 IMGFILE1, s.imgfile2 IMGFILE2, s.imgfile3 IMGFILE3, s.imgfile4 IMGFILE4, s.imgfile5 IMGFILE5, s.damdang_id DAMDANG_ID, s.modify_id MODIFY_ID, s.apprsl_dt APPRSL_DT, '' CAR_CHA_YN "+
			", iu.ins_com_nm INS_COM_NM, iu.ins_exp_dt INS_EXP_DT, u.ass_st_dt ASS_ST_DT, u.ass_ed_dt ASS_ED_DT, u.mm_pr MM_PR "+
			" from car_reg r, car_etc e, cont c, apprsl s, CAR_NM m, CAR_MNG n, sui u, v_tot_dist vt, (select distinct ac.car_mng_id CAR_MNG_ID from accident ac, car_reg re where ac.car_mng_id=re.car_mng_id) sq, "+
			"	(select a.car_mng_id CAR_MNG_ID, a.serv_dt SERV_DT, a.tot_dist TOT_DIST  from service a where a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where car_mng_id = a.car_mng_id)) i, "+
			"	(select al.rent_mng_id RENT_MNG_ID, al.rent_l_cd RENT_L_CD, cd.nm BANK_NM, al.lend_prn LEND_PRN, al.alt_end_dt ALT_END_DT from allot al, code cd where al.cpt_cd = cd.code and cd.c_st = '0003') bk, "+
		//	"	(SELECT DISTINCT cc.car_mng_id CAR_MNG_ID FROM car_cha cc, car_reg re WHERE cc.car_mng_id = re.car_mng_id) ch, "+
			"	(SELECT car_mng_id, cha_dt, car_no FROM car_change a WHERE a.cha_seq = to_char(to_number((select max(b.cha_seq) from car_change b where a.car_mng_id = b.car_mng_id))-1)) cg, "+
			"	(SELECT sc.car_mng_id CAR_MNG_ID, sc.alt_rest ALT_REST FROM scd_alt_case sc WHERE sc.alt_tm = (select max(alt_tm) from scd_alt_case where car_mng_id = sc.car_mng_id)) sw "+
			", (select ir.car_mng_id CAR_MNG_ID, ic.ins_com_nm INS_COM_NM, ir.ins_exp_dt INS_EXP_DT from insur ir, ins_com ic where ir.ins_com_id = ic.ins_com_id and ir.ins_st = (select max(ins_st) from insur where car_mng_id = ir.car_mng_id)) iu "+
			" where r.car_mng_id = c.car_mng_id "+
			"  and e.rent_mng_id = c.rent_mng_id "+
			"  and e.rent_l_cd = c.rent_l_cd "+
			"  and r.car_mng_id = sq.car_mng_id(+) "+
			"  and c.car_st = '2' "+
			"  and c.use_yn = 'Y' "+
			"  and r.off_ls = '4' "+
			"  and r.car_mng_id = i.car_mng_id(+) "+
			"  and c.rent_mng_id = bk.rent_mng_id(+) "+
			"  and c.rent_l_cd = bk.rent_l_cd(+) "+
			"  and r.car_mng_id = s.car_mng_id(+) "+
		//	"  and r.car_mng_id = ch.car_mng_id(+) "+
			"  AND r.car_mng_id = cg.car_mng_id(+) "+
			"  AND r.car_mng_id = sw.car_mng_id(+) "+
			"  and r.car_mng_id = iu.car_mng_id(+) "+
			"  AND e.car_id = m.car_id "+	
			"  and e.car_seq = m.car_seq "+
			"  and m.car_comp_id = n.car_comp_id "+
			"  and m.car_cd = n.code "+
			"  AND r.car_mng_id = u.car_mng_id(+) "+
			"  AND r.car_mng_id = vt.car_mng_id(+) "+
				subQuery +
			" ORDER BY init_reg_dt ";
		}

		Collection<Offls_suiBean> col = new ArrayList<Offls_suiBean>();
		
		

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while(rs.next()){
				col.add(makeOffls_suiBean(rs));
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_suiDatabase:getSui_lst(String gubun, String gubun_nm)]"+e);
			System.out.println("[Offls_suiDatabase:getSui_lst(String gubun, String gubun_nm)]"+query);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return (Offls_suiBean[])col.toArray(new Offls_suiBean[0]);
		}		
	}
	

	/**
	*	수의매각대금_계약금 수금스케쥴 Bean에 데이터 넣기 2003.5.29.Thu.
	*/
	 private Scd_sui_contBean makeScd_sui_contBean(ResultSet results) throws DatabaseException {

        try {
            Scd_sui_contBean bean = new Scd_sui_contBean();

			bean.setCar_mng_id(results.getString("CAR_MNG_ID"));
			bean.setTm(results.getString("TM"));
			bean.setCont_amt(results.getInt("CONT_AMT"));
			bean.setEst_dt(results.getString("EST_DT"));
			bean.setPay_amt(results.getInt("PAY_AMT"));
			bean.setPay_dt(results.getString("PAY_DT"));

			return bean;

        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}

	/**
	*	수의매각대금 수금스케쥴 Bean에 데이터 넣기 2003.5.26.Mon.
	*/
	 private Scd_sui_janBean makeScd_sui_janBean(ResultSet results) throws DatabaseException {

        try {
            Scd_sui_janBean bean = new Scd_sui_janBean();

			bean.setCar_mng_id(results.getString("CAR_MNG_ID"));
			bean.setTm(results.getString("TM"));
			bean.setJan_amt(results.getInt("JAN_AMT"));
			bean.setEst_dt(results.getString("EST_DT"));
			bean.setPay_amt(results.getInt("PAY_AMT"));
			bean.setPay_dt(results.getString("PAY_DT"));

			return bean;

        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}

	/**
	*	수의매각대금_계약금 수금 스케쥴 - 2003.5.26.Mon.
	*/
	public Scd_sui_contBean[] getScd_sui_cont(String car_mng_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		Collection<Scd_sui_contBean> col = new ArrayList<Scd_sui_contBean>();

		query = "SELECT car_mng_id, tm, cont_amt, est_dt, pay_amt, pay_dt FROM scd_sui_cont WHERE car_mng_id = ? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				col.add(makeScd_sui_contBean(rs));
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_suiDatabase:getScd_sui_cont(String car_mng_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return (Scd_sui_contBean[])col.toArray(new Scd_sui_contBean[0]);
		}		
	}

	/**
	*	수의매각대금_잔금 수금 스케쥴 - 2003.5.26.Mon.
	*/
	public Scd_sui_janBean[] getScd_sui_jan(String car_mng_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		Collection<Scd_sui_janBean> col = new ArrayList<Scd_sui_janBean>();

		query = "SELECT car_mng_id, tm, jan_amt, est_dt, pay_amt, pay_dt FROM scd_sui_jan WHERE car_mng_id = ? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				col.add(makeScd_sui_janBean(rs));
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_suiDatabase:getScd_sui_jan(String car_mng_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return (Scd_sui_janBean[])col.toArray(new Scd_sui_janBean[0]);
		}		
	}

	/**
	*	수의매각정보 bean에 데이터 넣기 2003.5.29.Thu.
	*/
	 private SuiBean makeSuiBean(ResultSet results) throws DatabaseException {

        try {
            SuiBean bean = new SuiBean();

			bean.setClient_id(results.getString("CLIENT_ID"));
			bean.setCar_mng_id(results.getString("CAR_MNG_ID"));
			bean.setSui_nm(results.getString("SUI_NM"));
			bean.setSsn(results.getString("SSN"));
			bean.setRelation(results.getString("RELATION"));
			bean.setH_tel(results.getString("H_TEL"));
			bean.setM_tel(results.getString("M_TEL"));
			bean.setCont_dt(results.getString("CONT_DT"));
			bean.setH_addr(results.getString("H_ADDR"));
			bean.setH_zip(results.getString("H_ZIP"));
			bean.setD_addr(results.getString("D_ADDR"));
			bean.setD_zip(results.getString("D_ZIP"));
			bean.setCar_nm(results.getString("CAR_NM"));
			bean.setCar_relation(results.getString("CAR_RELATION"));
			bean.setCar_addr(results.getString("CAR_ADDR"));
			bean.setCar_zip(results.getString("CAR_ZIP"));
			bean.setCar_ssn(results.getString("CAR_SSN"));
			bean.setCar_h_tel(results.getString("CAR_H_TEL"));
			bean.setCar_m_tel(results.getString("CAR_M_TEL"));
			bean.setEtc(results.getString("ETC"));
			bean.setSuifile(results.getString("SUIFILE"));
			bean.setLpgfile(results.getString("LPGFILE"));
			bean.setAss_st_dt(results.getString("ASS_ST_DT"));
			bean.setAss_ed_dt(results.getString("ASS_ED_DT"));
			bean.setAss_st_km(results.getString("ASS_ST_KM"));
			bean.setAss_ed_km(results.getString("ASS_ED_KM"));
			bean.setAss_wrt(results.getString("ASS_WRT"));
			bean.setMm_pr(results.getInt("MM_PR"));
			bean.setCont_pr(results.getInt("CONT_PR"));
			bean.setJan_pr(results.getInt("JAN_PR"));
			bean.setModify_id(results.getString("MODIFY_ID"));
			bean.setCont_pr_dt(results.getString("CONT_PR_DT"));
			bean.setJan_pr_dt(results.getString("JAN_PR_DT"));
			bean.setMigr_dt(results.getString("MIGR_DT"));
			bean.setMigr_no(results.getString("MIGR_NO"));
			bean.setEnp_no(results.getString("ENP_NO"));
			bean.setEmail(results.getString("EMAIL"));
			bean.setDes_addr(results.getString("DES_ADDR"));
			bean.setDes_zip(results.getString("DES_ZIP"));
			bean.setDes_nm(results.getString("DES_NM"));
			bean.setUdt_dt(results.getString("UDT_DT"));
			bean.setDes_tel(results.getString("DES_TEL")); //수취인 연락처
			bean.setAccid_yn(results.getString("ACCID_YN")); //수의계약(잔존물) - 사고건 
			return bean;

        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}

	/**
	*	수의매각정보 찾기 - 2003.5.29.Thu.
	*/
	public SuiBean getSui(String car_mng_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		SuiBean sBean = new SuiBean();
		query = "SELECT client_id, car_mng_id, sui_nm,  text_decrypt(ssn, 'pw')  ssn, relation,h_tel,m_tel,cont_dt,h_addr,h_zip,d_addr,d_zip,car_nm,car_relation,car_addr,car_zip,  text_decrypt(car_ssn, 'pw')  car_ssn   ,car_h_tel,car_m_tel,etc,suifile,lpgfile,ass_st_dt,ass_ed_dt,ass_st_km,ass_ed_km,ass_wrt,mm_pr,cont_pr,jan_pr,modify_id,cont_pr_dt,jan_pr_dt,migr_dt,migr_no,enp_no,email, \n"+
			      " des_zip, des_addr, des_nm , udt_dt, des_tel , accid_yn   \n" +			      
				" FROM sui WHERE car_mng_id = ? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				sBean = makeSuiBean(rs);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_suiDatabase:getSui(String car_mng_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return sBean;
		}		
	}

	/**
	*	- 수의매각 수의아이디 알아내기 - 2003.05.26.Mon.
	*	- 저장된 car_mng_id를 찰아 sui_id로 되돌려 준다.
	*/
	public String getSui_id(String car_mng_id){

		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sui_id = "";
		String query = "SELECT car_mng_id FROM scd_sui WHERE car_mng_id=?";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				sui_id = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_suiDatabase:getSui_id(String car_mng_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return sui_id;
		}
	}

	/**
	*	수의계약정보 입력 - 2003.5.27.Tue.
	*	- 
	*/
	public int inSui(SuiBean sui){

		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		PreparedStatement pstmt4 = null;
		PreparedStatement pstmt5 = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		int result = 0;
		String query = "";
		String query2 = "";
		String query3 = "";
		String query4 = "";
		String query5 = "";
		String query1 = "";
		
		int cnt = 0;
		
		query = "INSERT INTO sui(car_mng_id,sui_nm,ssn,  relation,h_tel,m_tel,  cont_dt,h_addr,h_zip,d_addr,d_zip,car_nm,car_relation, \n" +//13
				"  car_addr,car_zip,car_ssn,car_h_tel,car_m_tel,etc,  suifile,lpgfile,   ass_st_dt,ass_ed_dt, ass_st_km,ass_ed_km,ass_wrt,  \n" +	 // 13
				"  mm_pr,cont_pr,jan_pr,modify_id,  cont_pr_dt,jan_pr_dt,migr_dt,    migr_no,enp_no,email,client_id, sui_st,    des_zip, des_addr, des_nm, des_tel, accid_yn ) "+ //17
			" VALUES(?,?, TEXT_ENCRYPT(?, 'pw' ),    ?,?,?,   replace(?,'-', ''), ?,?,?,?,?,?, \n" +
			"    ?,?, TEXT_ENCRYPT(?, 'pw' ),  ?,?,?,?,?,    replace(?,'-', ''), replace(?,'-', ''),   ?,?,?,   \n" +
			"   ?,?,?,?,     replace(?,'-', ''), replace(?,'-', ''), replace(?,'-', ''),   ?,?,?,?,?,   ?,?,?, ? , ?  )";
		query2 = "INSERT INTO scd_sui_cont(car_mng_id,tm,cont_amt,est_dt) VALUES(?,?,?, replace(?, '-', ''))";
		query3 = "INSERT INTO scd_sui_jan(car_mng_id,tm,jan_amt,est_dt) VALUES(?,?,?,replace(?, '-', '') )";
	
		query4 = "INSERT INTO sui_etc(car_mng_id) VALUES(?)";
	
		query5 = "SELECT count(0) FROM sui_etc WHERE car_mng_id=?" ;
			
		query1 = "UPDATE sui SET sh_car_amt = ?   WHERE car_mng_id=? ";
		
		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,sui.getCar_mng_id());
			pstmt.setString(2,sui.getSui_nm());
			pstmt.setString(3,sui.getSsn());
			pstmt.setString(4,sui.getRelation());
			pstmt.setString(5,sui.getH_tel());
			pstmt.setString(6,sui.getM_tel());
			pstmt.setString(7,sui.getCont_dt());
			pstmt.setString(8,sui.getH_addr());
			pstmt.setString(9,sui.getH_zip());
			pstmt.setString(10,sui.getD_addr());
			pstmt.setString(11,sui.getD_zip());
			pstmt.setString(12,sui.getCar_nm());
			pstmt.setString(13,sui.getCar_relation());  //13
			
			pstmt.setString(14,sui.getCar_addr());
			pstmt.setString(15,sui.getCar_zip());
			pstmt.setString(16,sui.getCar_ssn());
			pstmt.setString(17,sui.getCar_h_tel());
			pstmt.setString(18,sui.getCar_m_tel());
			pstmt.setString(19,sui.getEtc());
			pstmt.setString(20,sui.getSuifile());
			pstmt.setString(21,sui.getLpgfile());
			pstmt.setString(22,sui.getAss_st_dt());
			pstmt.setString(23,sui.getAss_ed_dt());
			pstmt.setString(24,sui.getAss_st_km());
			pstmt.setString(25,sui.getAss_ed_km());
			pstmt.setString(26,sui.getAss_wrt());     //13
			
			pstmt.setInt(27,sui.getMm_pr());
			pstmt.setInt(28,sui.getCont_pr());
			pstmt.setInt(29,sui.getJan_pr());
			pstmt.setString(30,sui.getModify_id());
			pstmt.setString(31,sui.getCont_pr_dt());
			pstmt.setString(32,sui.getJan_pr_dt());
			pstmt.setString(33,sui.getMigr_dt());
			pstmt.setString(34,sui.getMigr_no());
			pstmt.setString(35,sui.getEnp_no());
			pstmt.setString(36,sui.getEmail());
			pstmt.setString(37,sui.getClient_id());
			pstmt.setString(38,sui.getSui_st());
			pstmt.setString(39,sui.getDes_zip());
			pstmt.setString(40,sui.getDes_addr());
			pstmt.setString(41,sui.getDes_nm());    //15
			pstmt.setString(42,sui.getDes_tel());    //16
			pstmt.setString(43,sui.getAccid_yn());    //17
			result = pstmt.executeUpdate();
			pstmt.close();

			//계약금 등록
			pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString(1,sui.getCar_mng_id());
			pstmt2.setString(2,"1");
			pstmt2.setInt(3,sui.getCont_pr());
			pstmt2.setString(4,sui.getCont_pr_dt());
			result = pstmt2.executeUpdate();
			pstmt2.close();

			//잔금 등록
			pstmt3 = conn.prepareStatement(query3);
			pstmt3.setString(1,sui.getCar_mng_id());
			pstmt3.setString(2,"1");
			pstmt3.setInt(3,sui.getJan_pr());
			pstmt3.setString(4,sui.getJan_pr_dt());
			result = pstmt3.executeUpdate();
			pstmt3.close();
						
				// 매입옵션 진행사항 입력여부 확인- 20181030
			pstmt5 = conn.prepareStatement(query5);
			pstmt5.setString(1,sui.getCar_mng_id());
			rs = pstmt5.executeQuery();
			while(rs.next()){
				cnt = rs.getInt(1);			
			}
			rs.close();
			pstmt5.close();
			
			if ( cnt < 1 ) {			
			//잔금 등록
				pstmt4 = conn.prepareStatement(query4);
				pstmt4.setString(1,sui.getCar_mng_id());
				result = pstmt4.executeUpdate();
				pstmt4.close();
		   }
			//사고폐차 수의계약인 경우 
			if ( sui.getAccid_yn().equals("Y") && sui.getSh_car_amt() > 0 ) {
				pstmt1 = conn.prepareStatement(query1);
				pstmt1.setInt(1,sui.getSh_car_amt());
				pstmt1.setString(2,sui.getCar_mng_id());
	
				result = pstmt1.executeUpdate();
				pstmt1.close();
			}	
		   
			conn.commit();
			
		}catch(SQLException e){
			System.out.println("[Offls_suiDatabase:inSui(SuiBean sui)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
				if(pstmt2 != null) pstmt2.close();
				if(pstmt3 != null) pstmt3.close();
				if(pstmt4 != null) pstmt4.close();
				if(pstmt5 != null) pstmt5.close();
				if(pstmt1 != null) pstmt1.close();
			}catch(Exception ex){}
			closeConnection();
			return result;
		}
	}

	/**
	*	수의계약정보 수정 - 2003.5.29.Thu.
	*	- 
	*/
	public int upSui(SuiBean sui){

		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		int result = 0;
		String query = "";
		String query1 = "";
		
		query = "UPDATE sui "+
			" SET sui_nm=?, ssn= TEXT_ENCRYPT(?, 'pw' ), relation=?, h_tel=?, m_tel=?, cont_dt=replace(?, '-', ''), h_addr=?, h_zip=?, d_addr=?, d_zip=?, car_nm=?, car_relation=?,  \n" + 
			"  car_addr=?, car_zip=?, car_ssn= TEXT_ENCRYPT(?, 'pw' ), car_h_tel=?, car_m_tel=?, etc=?, suifile=?, lpgfile=?, ass_st_dt=replace(?, '-', '') , ass_ed_dt=replace(?, '-', '') , ass_st_km=?, ass_ed_km=?,  \n" + 
			"  ass_wrt=?, mm_pr=?, cont_pr=?, jan_pr=?, modify_id=?, cont_pr_dt=replace(?, '-', '') , jan_pr_dt=replace(?, '-', '') , migr_dt=replace(?, '-', '') , migr_no=?, enp_no=?, email=?, client_id=?,  \n" + 
			"  des_zip = ?, des_addr = ?, des_nm = ?, udt_dt= ? , des_tel = ? , accid_yn = ?  "+
			" WHERE car_mng_id=? ";
		
		query1 = "UPDATE sui SET sh_car_amt = ?   WHERE car_mng_id=? ";
		
		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,sui.getSui_nm());
			pstmt.setString(2,sui.getSsn());
			pstmt.setString(3,sui.getRelation());
			pstmt.setString(4,sui.getH_tel());
			pstmt.setString(5,sui.getM_tel());
			pstmt.setString(6,sui.getCont_dt());
			pstmt.setString(7,sui.getH_addr());
			pstmt.setString(8,sui.getH_zip());
			pstmt.setString(9,sui.getD_addr());
			pstmt.setString(10,sui.getD_zip());
			pstmt.setString(11,sui.getCar_nm());
			pstmt.setString(12,sui.getCar_relation());   //12
			
			pstmt.setString(13,sui.getCar_addr());
			pstmt.setString(14,sui.getCar_zip());
			pstmt.setString(15,sui.getCar_ssn());
			pstmt.setString(16,sui.getCar_h_tel());
			pstmt.setString(17,sui.getCar_m_tel());
			pstmt.setString(18,sui.getEtc());
			pstmt.setString(19,sui.getSuifile());
			pstmt.setString(20,sui.getLpgfile());
			pstmt.setString(21,sui.getAss_st_dt());
			pstmt.setString(22,sui.getAss_ed_dt());
			pstmt.setString(23,sui.getAss_st_km());
			pstmt.setString(24,sui.getAss_ed_km());  //12
			
			pstmt.setString(25,sui.getAss_wrt());
			pstmt.setInt(26,sui.getMm_pr());
			pstmt.setInt(27,sui.getCont_pr());
			pstmt.setInt(28,sui.getJan_pr());
			pstmt.setString(29,sui.getModify_id());
			pstmt.setString(30,sui.getCont_pr_dt());
			pstmt.setString(31,sui.getJan_pr_dt());
			pstmt.setString(32,sui.getMigr_dt());
			pstmt.setString(33,sui.getMigr_no());
			pstmt.setString(34,sui.getEnp_no());
			pstmt.setString(35,sui.getEmail());
			pstmt.setString(36,sui.getClient_id());
			
			pstmt.setString(37,sui.getDes_zip());
			pstmt.setString(38,sui.getDes_addr());		
			pstmt.setString(39,sui.getDes_nm());		
			pstmt.setString(40,sui.getUdt_dt());	
			pstmt.setString(41,sui.getDes_tel());	
			
			pstmt.setString(42,sui.getAccid_yn());	 //수의계약(잔존물)
			
			pstmt.setString(43,sui.getCar_mng_id());

			result = pstmt.executeUpdate();
			pstmt.close();
			
			if ( sui.getAccid_yn().equals("Y") && sui.getSh_car_amt() > 0 ) {
				pstmt1 = conn.prepareStatement(query1);
				pstmt1.setInt(1,sui.getSh_car_amt());
				pstmt1.setString(2,sui.getCar_mng_id());
	
				result = pstmt1.executeUpdate();
				pstmt1.close();
			}
			
			conn.commit();
		}catch(SQLException e){
			System.out.println("[Offls_suiDatabase:upSui(Offls_suiBean sui)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
				if(pstmt != null) pstmt.close();
				if(pstmt1 != null) pstmt1.close();
			}catch(Exception ex){}
			closeConnection();
			return result;
		}
	}

	/**
	*	매각처리(해지테이블에 입력,계약사용끝 'N',오프리스'6') - 2003.10.10.
	*	- 
	*/
	public int regCls_cont(SuiBean sui){

		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		PreparedStatement pstmt4 = null;
		ResultSet rs = null;
		int result = 0;
		String query4 = "";
		String query5 = "";
		String query6 = "";
		String query7 = "";
		String rent_mng_id ="";
		String rent_l_cd = "";
		
		query4 = "INSERT INTO cls_cont(rent_mng_id,rent_l_cd,cls_st,term_yn,cls_dt,reg_id, reg_dt, cls_cau) VALUES(?,?,'6','Y',replace(?, '-', '') ,?, to_char(sysdate,'YYYYMMdd'),  ?)";
		query5 = "SELECT rent_mng_id,rent_l_cd FROM cont WHERE car_mng_id=? and nvl(use_yn,'Y')='Y' AND car_st='2'";
		query6 = "UPDATE cont SET use_yn='N' WHERE rent_mng_id=? AND rent_l_cd=?";
		query7 = "UPDATE car_reg SET off_ls='6' WHERE car_mng_id=?";
		
		try{

			conn.setAutoCommit(false);
			//명의변경일,번호등록
//			result = this.upSui(sui);

			//중도해지에 매각 등록
			pstmt = conn.prepareStatement(query5);
			pstmt.setString(1,sui.getCar_mng_id());
			rs = pstmt.executeQuery();
			while(rs.next()){
				rent_mng_id = rs.getString(1)==null?"":rs.getString(1);
				rent_l_cd = rs.getString(2)==null?"":rs.getString(2);
			}
			rs.close();
			pstmt.close();

			System.out.println(sui.getCar_mng_id());			
			System.out.println(rent_mng_id);
			System.out.println(rent_l_cd);
			System.out.println(sui.getCont_dt());
			System.out.println(sui.getModify_id());
			System.out.println("오프리스에서 매각 처리("+sui.getMigr_dt()+","+sui.getMigr_no()+")");

			pstmt2 = conn.prepareStatement(query4);
			pstmt2.setString(1,rent_mng_id);
			pstmt2.setString(2,rent_l_cd);
			pstmt2.setString(3,sui.getCont_dt());
			pstmt2.setString(4,sui.getModify_id());
			pstmt2.setString(5,"오프리스에서 매각 처리("+sui.getMigr_dt()+","+sui.getMigr_no()+")");
			result = pstmt2.executeUpdate();
			pstmt2.close();

			//계약 사용여부 'N'
			pstmt3 = conn.prepareStatement(query6);
			pstmt3.setString(1,rent_mng_id);
			pstmt3.setString(2,rent_l_cd);
			result = pstmt3.executeUpdate();
			pstmt3.close();

			//오프리스 상태 '6' 사후관리
			pstmt4 = conn.prepareStatement(query7);
			pstmt4.setString(1,sui.getCar_mng_id());
			result = pstmt4.executeUpdate();
			pstmt4.close();
			
			conn.commit();

		}catch(SQLException e){
			System.out.println("[Offls_suiDatabase:regCls_cont(SuiBean sui)]"+e);
			e.printStackTrace();
			conn.rollback();

		}finally{
			try{
				conn.setAutoCommit(true);
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
				if(pstmt2 != null) pstmt2.close();
				if(pstmt3 != null) pstmt3.close();
				if(pstmt4 != null) pstmt4.close();
			}catch(Exception ex){}
			closeConnection();
			return result;
		}
	}
	
		/**
	*	수의계약정보 입력 - 2003.5.27.Tue.
	*	- 
	*/
	public int updateSuiEtc(String car_mng_id , String conj_dt, String est_dt){

		getConnection();
		
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
	
		int result = 0;
		int cnt = 0;
		String query = "";
		String query1 = "";
		String query2 = "";
		ResultSet rs = null;			
		
		query = "SELECT count(0) FROM sui_etc WHERE car_mng_id=?" ;
			
		query1 = "INSERT INTO sui_etc(car_mng_id, conj_dt , est_dt ) VALUES (?, replace(?, '-', ''), replace(?, '-', '') )";
		
		query2 = "UPDATE sui_etc SET conj_dt = replace(?, '-', '') , est_dt = replace(?, '-', '')   WHERE car_mng_id=? ";
		
		try{
			conn.setAutoCommit(false);


			//
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				cnt = rs.getInt(1);			
			}
			rs.close();
			pstmt.close();
			
			if ( cnt > 0) {
				pstmt1 = conn.prepareStatement(query2);		
				pstmt1.setString(1,conj_dt);
				pstmt1.setString(2,est_dt);		  
				pstmt1.setString(3,car_mng_id);					
			
		  } else {
		  		pstmt1 = conn.prepareStatement(query1);		
				pstmt1.setString(1,car_mng_id);
				pstmt1.setString(2,conj_dt);
				pstmt1.setString(3,est_dt);
		  	
		  }		
			result = pstmt1.executeUpdate();
			pstmt1.close();

			conn.commit();
			
		}catch(SQLException e){
			System.out.println("[Offls_suiDatabase:updateSuiEtc]"+e);
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



	public Sui_etcBean getSuiEtc(String car_mng_id) {

		getConnection();
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Sui_etcBean bean = new Sui_etcBean();
        String query = "";
        
        query = " select a.* from sui_etc a " +
        	    " where a.car_mng_id='"+car_mng_id+"'";
   
        try{
                      
            pstmt = conn.prepareStatement(query);  		    		
   	  	  	rs = pstmt.executeQuery();
    		
            if(rs.next()){            	
	    			bean.setCar_mng_id(rs.getString("CAR_MNG_ID"));			 
				   bean.setConj_dt(rs.getString("CONJ_DT"));
				   bean.setEst_dt(rs.getString("EST_DT"));										    
            }
            rs.close();
            pstmt.close();
        	}catch(SQLException e){
			System.out.println("[Offls_suiDatabase:getSuiEtc(String car_mng_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return bean;
		}
	}
       
    
	/**
	*	차량번호 찾아내기 - 2003.5.27.Tue.
	*/
	public String getCar_no(String car_mng_id){

		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String car_no = "";
		
		query = "SELECT car_no FROM car_reg WHERE car_mng_id=?";
		
		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				car_no = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_suiDatabase:getCar_no(String car_mng_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return car_no;
		}
	}

	/**
	*	- 수의계약정보 유무확인 - 2003.05.27.Tue.
	*	- 저장된 car_mng_id를 찰아 되돌려 준다.
	*/
	public String getCar_mng_id(String car_mng_id){

		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String id = "";
		String query = "SELECT car_mng_id FROM sui WHERE car_mng_id=?";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				id = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_suiDatabase:getCar_mng_id(String car_mng_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return id;
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
			System.out.println("[Offls_suiDatabase:inApprsl(String car_mng_id, String lev, String reason, String car_st, String damdang_id,String modify_id, String apprsl_dt)]"+e);
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
	*	수의 계약금 입금처리 - 2003.6.2.Mon.
	*	- 
	*/
	public int inScd_sui_cont(Scd_sui_contBean sscb){

		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = "";

		query = "INSERT INTO scd_sui_cont(car_mng_id,tm,cont_amt,est_dt) VALUES(?,?,?,?)";
		
		try{
			conn.setAutoCommit(false);

			//먼저 해당 회차 수정
			result = this.upScd_sui_cont(sscb);

			if(sscb.getCont_amt() - sscb.getPay_amt() > 0){
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1,sscb.getCar_mng_id());
				pstmt.setString(2,Integer.toString((AddUtil.parseInt(sscb.getTm())+1)));
				pstmt.setInt(3,sscb.getCont_amt() - sscb.getPay_amt());
				pstmt.setString(4,sscb.getEst_dt());
				result = pstmt.executeUpdate();
				pstmt.close();
			}

			conn.commit();
		}catch(SQLException e){
			System.out.println("[Offls_suiDatabase:inScd_sui_cont(Scd_sui_contBean sscb)]"+e);
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
	*	수의 계약금 수정 - 2003.6.2.Mon.
	*	- 
	*/
	public int upScd_sui_cont(Scd_sui_contBean sscb){

		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = "";
		
		query = "UPDATE scd_sui_cont SET cont_amt=?,est_dt=?,pay_amt=?,pay_dt=? WHERE car_mng_id=? AND tm=?";
		
		try{
			conn.setAutoCommit(false);
		
			pstmt = conn.prepareStatement(query);
			pstmt.setInt(1,sscb.getCont_amt());
			pstmt.setString(2,sscb.getEst_dt());
			pstmt.setInt(3,sscb.getPay_amt());
			pstmt.setString(4,sscb.getPay_dt());
			pstmt.setString(5,sscb.getCar_mng_id());
			pstmt.setString(6,sscb.getTm());
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
		}catch(SQLException e){
			System.out.println("[Offls_suiDatabase:upScd_sui_cont(Scd_sui_contBean sscb)]"+e);
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
	*	수의 계약금 삭제 - 2003.6.2.Mon.
	*	- 
	*/
	public int delScd_sui_cont(Scd_sui_contBean sscb){

		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		int result = 0;
		String query = "";
		String query2 = "";
		
		query = "DELETE scd_sui_cont WHERE car_mng_id=? AND tm=?";

		query2 = "UPDATE scd_sui_cont SET pay_dt='',pay_amt=0 WHERE car_mng_id=? AND tm=?"; 
		
		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,sscb.getCar_mng_id());
			pstmt.setString(2,sscb.getTm());
			result = pstmt.executeUpdate();
			pstmt.close();

			pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString(1,sscb.getCar_mng_id());
			pstmt2.setString(2,Integer.toString((AddUtil.parseInt(sscb.getTm())-1)));
			result = pstmt2.executeUpdate();
			pstmt2.close();

			conn.commit();
		}catch(SQLException e){
			System.out.println("[Offls_suiDatabase:delScd_sui_cont(Scd_sui_contBean sscb)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
				if(pstmt != null) pstmt.close();
				if(pstmt2 != null) pstmt2.close();
			}catch(Exception ex){}
			closeConnection();
			return result;
		}
	}

	/**
	*	수의 잔금 입금처리 - 2003.6.2.Mon.
	*	- 
	*/
	public int inScd_sui_jan(Scd_sui_janBean ssjb){

		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = "";

		query = "INSERT INTO scd_sui_jan(car_mng_id,tm,jan_amt,est_dt) VALUES(?,?,?,?)";
		
		try{
			conn.setAutoCommit(false);

			//먼저 해당 회차 수정
			result = this.upScd_sui_jan(ssjb);

			if(ssjb.getJan_amt() - ssjb.getPay_amt() > 0){
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1,ssjb.getCar_mng_id());
				pstmt.setString(2,Integer.toString((AddUtil.parseInt(ssjb.getTm())+1)));
				pstmt.setInt(3,ssjb.getJan_amt() - ssjb.getPay_amt());
				pstmt.setString(4,ssjb.getEst_dt());
				result = pstmt.executeUpdate();
				pstmt.close();
			}

			conn.commit();
		}catch(SQLException e){
			System.out.println("[Offls_suiDatabase:inScd_sui_jan(Scd_sui_janBean ssjb)]"+e);
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
	*	수의 잔금 수정 - 2003.6.2.Mon.
	*	- 
	*/
	public int upScd_sui_jan(Scd_sui_janBean ssjb){

		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = "";
		
		query = "UPDATE scd_sui_jan SET jan_amt=?,est_dt=?,pay_amt=?,pay_dt=? WHERE car_mng_id=? AND tm=?";
		
		try{
			conn.setAutoCommit(false);
		
			pstmt = conn.prepareStatement(query);
			pstmt.setInt(1,ssjb.getJan_amt());
			pstmt.setString(2,ssjb.getEst_dt());
			pstmt.setInt(3,ssjb.getPay_amt());
			pstmt.setString(4,ssjb.getPay_dt());
			pstmt.setString(5,ssjb.getCar_mng_id());
			pstmt.setString(6,ssjb.getTm());
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
		}catch(SQLException e){
			System.out.println("[Offls_suiDatabase:upScd_sui_jan(Scd_sui_janBean ssjb)]"+e);
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
	*	수의 잔금 삭제 - 2003.6.2.Mon.
	*	- 
	*/
	public int delScd_sui_jan(Scd_sui_janBean ssjb){

		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		int result = 0;
		String query = "";
		String query2 = "";
		
		query = "DELETE scd_sui_jan WHERE car_mng_id=? AND tm=?";
		query2 = "UPDATE scd_sui_jan SET pay_dt='',pay_amt=0 WHERE car_mng_id=? AND tm=?"; 
		
		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,ssjb.getCar_mng_id());
			pstmt.setString(2,ssjb.getTm());
			result = pstmt.executeUpdate();
			pstmt.close();

			pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString(1,ssjb.getCar_mng_id());
			pstmt2.setString(2,Integer.toString((AddUtil.parseInt(ssjb.getTm())-1)));
			result = pstmt2.executeUpdate();
			pstmt2.close();
			
			conn.commit();
		}catch(SQLException e){
			System.out.println("[Offls_suiDatabase:delScd_sui_jan(Scd_sui_janBean ssjb)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
				if(pstmt != null) pstmt.close();
				if(pstmt2 != null) pstmt2.close();
			}catch(Exception ex){}
			closeConnection();
			return result;
		}
	}
	
	public int getAuctionChk(String car_mng_id){
		getConnection();
		int cnt = 0;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = "SELECT count(0) "+
				"FROM auction a "+
				"WHERE a.seq = (select max(seq) from auction where car_mng_id = a.car_mng_id) "+
				"AND a.car_mng_id = ? and a.ACTN_ST= '4'";
		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				cnt = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_cmpltDatabase:getAuctionChk(String car_mng_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return cnt;
		}		
	}
	
	
	/**
	*	글로비스인 경우 입금예정일 추가 
	*	- 
	*/
	public int upScd_sui_ip_est(String car_mng_id, String actn_dt){

		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = "";
		
		String sResult = "";
		CallableStatement cstmt = null;
		
		
		query = "UPDATE sui SET ip_est_dt=? WHERE car_mng_id= ? ";
		
		try{
			conn.setAutoCommit(false);
		
			cstmt = conn.prepareCall("{ ? =  call F_getSuiDay( ? ) }");
	
			cstmt.registerOutParameter( 1, java.sql.Types.VARCHAR );			
		    cstmt.setString(2, actn_dt );
	     	           
	        cstmt.execute();
	        sResult = cstmt.getString(1); // 결과값
	        cstmt.close();
	           	
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, sResult);
			pstmt.setString(2, car_mng_id);
			result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
			
		}catch(SQLException e){
			System.out.println("[Offls_suiDatabase:upScd_sui_ip_est]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
				if(cstmt != null) cstmt.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return result;
		}
	}
	
	
	//매입옵션시 서류 발송 주소 계산서 발행여부  - 해지 위약금, 외부비용, 부대비용, 기타손해배상금
	public Hashtable  getDesAddr( String  car_mng_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";		
		
		query = " select   nvl(a.des_zip, '') des_zip,  nvl( a.des_addr , '') des_addr , nvl( a.des_nm , '') des_nm , nvl( a.des_tel , '') des_tel   "+
 				"  from   cls_etc_more a, cont b, cls_cont c "+
 				" where a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd "+
 				"   and  c.cls_st = '8' and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd  "+
				"   and b.car_mng_id = '"+ car_mng_id+"'";
		 			
 		
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
			System.out.println("[AccDatabase:getDesAddr]\n"+e);			
			System.out.println("[AccDatabase:getDesAddr]\n"+query);			
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
	
	//매각취소관련 - 
	 //scd_sui_jan, scd_sui_cont, sui, sui_etc, car_reg off_ls= '3으로 , auction actn_st = '4'로   경매건 취소 actn_st:2
	public int cancelSui(String car_mng_id){

		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		PreparedStatement pstmt4 = null;
		PreparedStatement pstmt5 = null;
		PreparedStatement pstmt6 = null;
		int result = 0;
		String query = "";
		String query2 = "";
		String query3 = "";
		String query4 = "";
		String query5 = "";
		String query6 = "";
				
		query = "DELETE scd_sui_jan WHERE car_mng_id=? ";
		query2 ="DELETE scd_sui_cont WHERE car_mng_id=? ";
		query3 ="DELETE sui WHERE car_mng_id=? ";
		query4 ="DELETE sui_etc WHERE car_mng_id=? ";
		query5 ="update car_reg set off_ls = '3' WHERE car_mng_id=? ";
		query6 ="update auction set actn_st = '2'  where car_mng_id= ? and seq = ( select max(seq) from auction where car_mng_id = ? ) "; //max로 
				
		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
			
			result = pstmt.executeUpdate();
			pstmt.close();

			pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString(1,car_mng_id);
			result = pstmt2.executeUpdate();
			pstmt2.close();
			
			pstmt3 = conn.prepareStatement(query3);
			pstmt3.setString(1,car_mng_id);
			result = pstmt3.executeUpdate();
			pstmt3.close();
			
			pstmt4 = conn.prepareStatement(query4);
			pstmt4.setString(1,car_mng_id);
			result = pstmt4.executeUpdate();
			pstmt4.close();
			
			pstmt5 = conn.prepareStatement(query5);
			pstmt5.setString(1,car_mng_id);
			result = pstmt5.executeUpdate();
			pstmt5.close();
			
			pstmt6 = conn.prepareStatement(query6);
			pstmt6.setString(1,car_mng_id);
			pstmt6.setString(2,car_mng_id);
			result = pstmt6.executeUpdate();
			pstmt6.close();
			
			conn.commit();
		}catch(SQLException e){
			System.out.println("[Offls_suiDatabase:cancelSui]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
				if(pstmt != null) pstmt.close();
				if(pstmt2 != null) pstmt2.close();
				if(pstmt3 != null) pstmt3.close();
				if(pstmt4 != null) pstmt4.close();
				if(pstmt5 != null) pstmt5.close();
				if(pstmt6 != null) pstmt6.close();
				
			}catch(Exception ex){}
			closeConnection();
			return result;
		}
	}
	
	
	//자산처리여부 
	public String getAssetYn(String car_mng_id){

		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String id = "";
		String query = "SELECT deprf_yn FROM fassetma WHERE car_mng_id=?";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				id = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_suiDatabase:getAssetYn(String car_mng_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return id;
		}
	}
	
	//딥러닝예측낙찰가
	public Hashtable  getAuctionDeepCar(String  car_no, String actn_dt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";		
		
		query = " SELECT b.car_mng_id, b.seq, b.deep_car_amt1, b.deep_car_amt2, b.deep_car_amt3, b.deep_car_amt4, b.deep_car_amt5, b.deep_car_amt6, b.deep_car_amt7\r\n"
				+ "FROM   car_reg a, auction b \r\n"
				+ "where  a.car_no='"+car_no+"' \r\n"
				+ "AND a.car_mng_id=b.car_mng_id AND b.actn_dt=REPLACE('"+actn_dt+"','-','') "
				+ " ";
 		
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
			System.out.println("[AccDatabase:getAuctionDeepCar]\n"+e);			
			System.out.println("[AccDatabase:ggetAuctionDeepCar]\n"+query);			
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
	
	public int updateDeepCarAmt(String car_mng_id, String seq, int deep_car_amt1, int deep_car_amt2, int deep_car_amt3, int deep_car_amt4, int deep_car_amt5, int deep_car_amt6, int deep_car_amt7, int deep_car_amt8){

		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = "";
		
		query = "UPDATE auction SET deep_car_amt1=?, deep_car_amt2=?, deep_car_amt3=?, deep_car_amt4=?, deep_car_amt5=?, deep_car_amt6=?, deep_car_amt7=?, deep_car_amt8=? WHERE car_mng_id= ? and seq=? ";
		
		try{
			conn.setAutoCommit(false);
		
			pstmt = conn.prepareStatement(query);
			pstmt.setInt   (1, deep_car_amt1);
			pstmt.setInt   (2, deep_car_amt2);
			pstmt.setInt   (3, deep_car_amt3);
			pstmt.setInt   (4, deep_car_amt4);
			pstmt.setInt   (5, deep_car_amt5);
			pstmt.setInt   (6, deep_car_amt6);
			pstmt.setInt   (7, deep_car_amt7);
			pstmt.setInt   (8, deep_car_amt8);
			pstmt.setString(9, car_mng_id);
			pstmt.setString(10, seq);
			result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
			
		}catch(SQLException e){
			System.out.println("[Offls_suiDatabase:updateDeepCarAmt]"+e);
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
	
}
