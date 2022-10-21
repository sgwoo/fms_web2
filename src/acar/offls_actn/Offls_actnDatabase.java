/**
 * 오프리스 매각진행차량(경매) 정보
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2003. 02. 14. Fri.
 * @ last modify date : 
 */
package acar.offls_actn;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;
import acar.exception.DatabaseException;
import acar.exception.DataSourceEmptyException;
import acar.common.*;
import acar.car_accident.*;

public class Offls_actnDatabase
{
	private Connection conn = null;
	public static Offls_actnDatabase db;
	
	public static Offls_actnDatabase getInstance()
	{
		if(Offls_actnDatabase.db == null)
			Offls_actnDatabase.db = new Offls_actnDatabase();
		return Offls_actnDatabase.db;
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
	*	매각준비차량에서 진행으로 2003.2.13.Thu.
	*/
	public int setOffls_actn(String[] actn){
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = "update car_reg set off_ls = '3' where car_mng_id in ('";		
		
		for(int i=0 ; i<actn.length ; i++){
			if(i == (actn.length -1))	query += actn[i];
			else						query += actn[i]+"', '";
		}
		query+="')";

		try{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
		}catch(Exception e){
            try{
				System.out.println("[Offls_actnDatabase:setOffls_actn(String[] actn)]"+e);
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
	*	반출시 - 2003.04.14.Mon.
	*/
	public int cancelOffls_actn(String car_mng_id){
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		int result = 0;
		String query = "update car_reg set off_ls = '1' where car_mng_id=?";			//매각준비로
		String query2 = "UPDATE auction SET choi_st='2' WHERE car_mng_id=? AND seq=?";	//반출여부
		String query3 = "INSERT INTO auction(car_mng_id,seq) VALUES(?,?)";				//새경매레코드미리생성
		
		try{

			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
			result = pstmt.executeUpdate();
			pstmt.close();

			if(result>0){

				pstmt2 = conn.prepareStatement(query2);
				pstmt2.setString(1,car_mng_id);
				pstmt2.setString(2,this.getAuction_maxSeq(car_mng_id));
				result = pstmt2.executeUpdate();
				pstmt2.close();
			}

			if(result>0){
				//순번증가
				String seq = "";
				int i_seq = Integer.parseInt(this.getAuction_maxSeq(car_mng_id));
				if(i_seq<9){
					seq = "0"+String.valueOf(i_seq+1);
				}else{
					seq = String.valueOf(i_seq+1);
				}
				pstmt3 = conn.prepareStatement(query3);
				pstmt3.setString(1,car_mng_id);
				pstmt3.setString(2,seq);
				result = pstmt3.executeUpdate();
				pstmt3.close();
			}

			conn.commit();
		}catch(Exception e){
            try{
				System.out.println("[Offls_actnDatabase:cancelOffls_actn(String car_mng_id)]"+e);
                conn.rollback();
            }catch(SQLException _ignored){}
			e.printStackTrace();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
                if(pstmt2 != null) pstmt2.close();
                if(pstmt3 != null) pstmt3.close();
            }catch(SQLException _ignored){}
			closeConnection();
		}
		return result;
	}



	/**
	*	매각진행차량 Bean에 데이터 넣기 2003.2.12.Wed.
	*/
	 private Offls_actnBean makeOffls_actnBean(ResultSet results) throws DatabaseException {

        try {
            Offls_actnBean bean = new Offls_actnBean();

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
/*			bean.setBkpr(results.getInt("BKPR"));
			bean.setSptax(results.getInt("SPTAX"));
			bean.setAllcost(results.getInt("ALLCOST"));
			bean.setRspr(results.getInt("RSPR"));
*/			bean.setDamdang_id(results.getString("DAMDANG_ID"));
			bean.setModify_id(results.getString("MODIFY_ID"));
			bean.setApprsl_dt(results.getString("APPRSL_DT"));
			bean.setCar_cha_yn(results.getString("CAR_CHA_YN"));
			bean.setCltr_amt(results.getInt("CLTR_AMT"));
			bean.setOff_ls(results.getString("OFF_LS"));	//구분(경매,소매,수의)
			bean.setActn_st(results.getString("ACTN_ST"));	//경매상태(출품,경매진행,최종유찰,개별상담,낙찰)
			bean.setActn_id(results.getString("ACTN_ID"));
			bean.setIns_com_nm(results.getString("INS_COM_NM"));
			bean.setIns_exp_dt(results.getString("INS_EXP_DT"));
			bean.setActn_dt(results.getString("ACTN_DT"));
			bean.setActn_wh(results.getString("ACTN_WH"));
			bean.setCpt_cd(results.getString("CPT_CD"));
			
			bean.setP_rent_mng_id(results.getString("P_RENT_MNG_ID"));
			bean.setP_rent_l_cd(results.getString("P_RENT_L_CD"));
			bean.setP_rpt_no(results.getString("P_RPT_NO"));
			bean.setP_car_no(results.getString("P_CAR_NO"));
			bean.setP_dlv_dt(results.getString("P_DLV_DT"));
			bean.setP_car_off_nm(results.getString("P_CAR_OFF_NM"));
			bean.setP_emp_id(results.getString("P_EMP_ID"));
			bean.setP_emp_nm(results.getString("P_EMP_NM"));

			bean.setPark_nm(results.getString("PARK_NM"));
			bean.setCons_dt(results.getString("CONS_DT"));
			
			bean.setA_cnt(results.getInt("A_CNT"));			
			bean.setO_s_amt(results.getInt("O_S_AMT"));
			bean.setDist_cng(results.getString("DIST_CNG"));	//계기판교체(20190823)

		return bean;

        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}

	/**
	*	매각진행차량 상세정보 2003.2.12.Wed.
	*/
	public Offls_actnBean getActn_detail(String car_mng_id){
		getConnection();
		Offls_actnBean detail = new Offls_actnBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " select r.car_mng_id CAR_MNG_ID, r.car_no CAR_NO, cg.car_no	CAR_PRE_NO,	cgg.cha_dt CHA_DT, r.car_num CAR_NUM, r.init_reg_dt	INIT_REG_DT, r.car_kd CAR_KD, r.car_use	CAR_USE, n.car_nm CAR_JNM, m.car_name CAR_NM,	r.car_form CAR_FORM, r.car_y_form	CAR_Y_FORM,	r.dpm			DPM,	r.fuel_kd		FUEL_KD,	r.maint_st_dt	MAINT_ST_DT,	r.maint_end_dt	MAINT_END_DT, r.test_st_dt TEST_ST_DT, r.test_end_dt TEST_END_DT, r.car_l_cd CAR_L_CD, e.rent_mng_id	RENT_MNG_ID,	e.rent_l_cd		RENT_L_CD,	e.car_id		CAR_ID,	e.colo			COLO,	e.opt			OPT, e.lpg_yn LPG_YN,e.car_cs_amt	CAR_CS_AMT,	e.car_cv_amt	CAR_CV_AMT,	e.car_fs_amt	CAR_FS_AMT,	e.car_fv_amt	CAR_FV_AMT,	e.opt_cs_amt	OPT_CS_AMT,	e.opt_cv_amt	OPT_CV_AMT,	e.opt_fs_amt	OPT_FS_AMT,	e.opt_fv_amt	OPT_FV_AMT,	e.clr_cs_amt	CLR_CS_AMT,	e.clr_cv_amt	CLR_CV_AMT,	e.clr_fs_amt	CLR_FS_AMT,	e.clr_fv_amt	CLR_FV_AMT,	e.sd_cs_amt		SD_CS_AMT,	e.sd_cv_amt		SD_CV_AMT,	e.sd_fs_amt		SD_FS_AMT,	e.sd_fv_amt		SD_FV_AMT,	e.dc_cs_amt		DC_CS_AMT,	e.dc_cv_amt		DC_CV_AMT,	e.dc_fs_amt		DC_FS_AMT,	e.dc_fv_amt		DC_FV_AMT, c.mng_id		MNG_ID,	c.dlv_dt DLV_DT, decode(r.car_mng_id, sq.car_mng_id, 1, 0) ACCIDENT_YN, "+
				"        vt.tot_dist TOT_DIST, r.dist_cng DIST_CNG, "+ //계기판 교체(20190823)
				"        decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD'))))) as AVERAGE_DIST, "+
				"        decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST, "+
				"        bk.bank_nm BANK_NM, bk.lend_prn LEND_PRN, sw.alt_rest	LEND_REM, bk.alt_end_dt ALT_END_DT, s.lev LEV, s.reason REASON, s.car_st CAR_ST,s.imgfile1 IMGFILE1, s.imgfile2 IMGFILE2, s.imgfile3 IMGFILE3, s.imgfile4 IMGFILE4, s.imgfile5 IMGFILE5, "+
				"        s.km, uc.damdang_id DETERM_ID, uc.hp_pr HPPR, uc.st_pr STPR, s.damdang_id DAMDANG_ID, s.modify_id MODIFY_ID, s.apprsl_dt APPRSL_DT, DECODE(r.car_mng_id, ch.car_mng_id, 1, 0) CAR_CHA_YN, t.cltr_amt CLTR_AMT, r.off_ls OFF_LS, uc.actn_st ACTN_ST, s.actn_id ACTN_ID, s.actn_wh ACTN_WH, "+
				"        iu.ins_com_nm INS_COM_NM, iu.ins_exp_dt INS_EXP_DT, uc.actn_dt ACTN_DT, '' cpt_cd, "+
			    "        nvl(ak.a_cnt,0) a_cnt, \n"+  //침수여부
				//"      decode(r.park, '1','목동주차', '2','정일현대', '3','부산지점', '4','대전지점', '5','명진공업', '7','부산부경','8','부산조양','9','대전현대','10','오토크린', '11','대전금호','12','광주지점','13','대구지점','14','상무현대', '15','영남주차', '16','동화엠파크', substr(r.park_cont,1,5)) park_nm, r.cons_dt  CONS_DT,  \n"+				
				"        decode(r.park,'6',substr(r.park_cont,1,5),nvl(cd.nm,r.park)) park_nm, r.cons_dt  CONS_DT,  \n"+
				"        up.P_RENT_MNG_ID, up.P_RENT_L_CD, up.P_RPT_NO, up.P_CAR_NO, up.P_DLV_DT, up.P_CAR_OFF_NM, up.P_EMP_ID, up.P_EMP_NM, uc.o_s_amt  " +
				" from   car_reg r, car_etc e, cont c, apprsl s, cltr t,  CAR_NM m, CAR_MNG n, v_tot_dist vt, (select distinct ac.car_mng_id CAR_MNG_ID from accident ac, car_reg re where ac.car_mng_id=re.car_mng_id) sq, "+
				"        ( select c_st, code, nm_cd, nm from code where c_st = '0027' and code <> '0000'  ) cd,  \n"+  //주차장 
				"	     (select a.car_mng_id CAR_MNG_ID, a.serv_dt SERV_DT, a.tot_dist TOT_DIST  from service a where a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where car_mng_id = a.car_mng_id)) i, "+
				"	     (select al.rent_mng_id RENT_MNG_ID, al.rent_l_cd RENT_L_CD, cd.nm BANK_NM , al.lend_prn LEND_PRN, al.alt_end_dt ALT_END_DT from allot al, code cd where al.cpt_cd = cd.code and cd.c_st = '0003') bk, "+
				"	     (SELECT DISTINCT cc.car_mng_id CAR_MNG_ID FROM car_cha cc, car_reg re WHERE cc.car_mng_id = re.car_mng_id) ch, "+
                "   (select car_mng_id, count(0) as a_cnt from accident where accid_st='6' group by car_mng_id) ak, \n"+ //침수
				"	     (SELECT sc.car_mng_id CAR_MNG_ID, sc.alt_rest ALT_REST FROM scd_alt_case sc WHERE sc.alt_tm = (select max(alt_tm) from scd_alt_case where car_mng_id = sc.car_mng_id)) sw, "+
				"	     (SELECT car_mng_id, cha_dt, car_no FROM car_change a WHERE a.cha_seq = to_char(to_number((select max(b.cha_seq) from car_change b where a.car_mng_id = b.car_mng_id))-1)) cg, "+
				"	     (SELECT car_mng_id, cha_dt, car_no FROM car_change a WHERE a.cha_seq = to_char(to_number((select max(b.cha_seq) from car_change b where a.car_mng_id = b.car_mng_id and b.cha_seq>1)))) cgg, "+
				"	     (SELECT a.car_mng_id CAR_MNG_ID, a.seq SEQ, a.actn_st ACTN_ST, a.actn_dt ACTN_DT, a.damdang_id DAMDANG_ID, a.hp_pr HP_PR, a.st_pr ST_PR, a.o_s_amt FROM auction a WHERE a.seq = (select max(seq) from auction where car_mng_id = a.car_mng_id)) uc, "+
				"	     (SELECT a.car_mng_id CAR_MNG_ID, a.seq P_SEQ, a.rent_mng_id P_RENT_MNG_ID, a.rent_l_cd  P_RENT_L_CD, a.rpt_no P_RPT_NO, a.car_no P_CAR_NO, a.dlv_dt P_DLV_DT, a.car_off_nm P_CAR_OFF_NM, a.emp_id P_EMP_ID, a.emp_nm P_EMP_NM FROM auction_pur a WHERE a.seq = (select max(seq) from auction_pur where car_mng_id = a.car_mng_id)) up, "+
				"        (select ir.car_mng_id CAR_MNG_ID, ic.ins_com_nm INS_COM_NM, ir.ins_exp_dt INS_EXP_DT from insur ir, ins_com ic where ir.ins_com_id = ic.ins_com_id and ir.ins_st = (select max(ins_st) from insur where car_mng_id = ir.car_mng_id)) iu "+
				" where  r.car_mng_id = '"+car_mng_id+"' "+
				"        and r.car_mng_id = c.car_mng_id "+
				"        and e.rent_mng_id = c.rent_mng_id "+
				"        and e.rent_l_cd = c.rent_l_cd "+
				"        and r.car_mng_id = sq.car_mng_id(+) "+
				"        and c.car_st = '2' "+
				//"  and c.use_yn = 'Y' "+
				//"  and r.off_ls = '3' "+
				"        and r.car_mng_id = i.car_mng_id(+) "+
	"  and r.car_mng_id = ak.car_mng_id(+) "+//
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
				"        and r.car_mng_id = up.car_mng_id(+) "+
				" 			and r.park = cd.nm_cd(+) \n"+  //주차장 코드 테이블 
				"        and r.car_mng_id = iu.car_mng_id(+) "+
				" ";


		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			if(rs.next()){
				detail = makeOffls_actnBean(rs);
			}
			rs.close();
			pstmt.close();


		}catch(SQLException e){
			System.out.println("[Offls_actnDatabase:getYb_detail(String car_mng_id)]"+e);
			System.out.println("[Offls_actnDatabase:getYb_detail(String car_mng_id)]"+query);
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
	*	회사별 매각진행차량 통계 - 2003.2.12.Wed.
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
"and c.off_ls = '3'  "+
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
"and c.off_ls = '3'     "+
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
"and c.off_ls = '3'     "+
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
"and c.off_ls = '3'     "+
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
"and c.off_ls = '3'    "+ 
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
				System.out.println("[Offls_actnDatabase:getTg()]"+e);
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
	*	매각진행차량 검색 - 2003.2.12.Wed.
	*	- gubun : 차량번호, 차량명, 최초등록일
	*	- gubun_nm : 해당 데이타
	*/
	public Offls_actnBean[] getActn_lst(String dt, String ref_dt1, String ref_dt2, String gubun, String gubun_nm,String brch_id, String s_au){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String subQuery = "";
		String dt_query = "";  
		String su_query = "";  
			
		String s_dt2 = "to_char(sysdate,'YYYYMM')";
		String s_dt3 = "between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')";

		if(dt.equals("2"))								dt_query = "and uc.actn_dt like "+s_dt2+"||'%' \n";
		else if(dt.equals("3") && !ref_dt1.equals(""))	dt_query = "and uc.actn_dt "+s_dt3+"\n";
		
		if(gubun.equals("car_no")){
			subQuery = " and r.car_no||' '||r.first_car_no like  '%" + gubun_nm + "%'";
		}else if(gubun.equals("car_nm")){
			subQuery = " and r.car_nm like '%" + gubun_nm.toUpperCase() + "%' ";
		}else if(gubun.equals("init_reg_dt")){
			subQuery = " and r.init_reg_dt like ''||replace('"+ gubun_nm +"','-','')||'%' ";
		}else{ //all
			subQuery = "";
		}
		if(!brch_id.equals(""))	subQuery += " and c.brch_id='"+brch_id+"'";

		if(!s_au.equals(""))			su_query = " and s.actn_id = '" + s_au + "' ";
		
		if(gubun.equals("car_no")){
		query = "select	r.car_mng_id CAR_MNG_ID, r.car_no CAR_NO, cg.car_no	CAR_PRE_NO,	cg.cha_dt CHA_DT, r.car_num CAR_NUM, r.init_reg_dt	INIT_REG_DT, r.car_kd CAR_KD, r.car_use	CAR_USE, n.car_nm CAR_JNM, m.car_name CAR_NM,	r.car_form CAR_FORM, r.car_y_form	CAR_Y_FORM,	r.dpm			DPM,	r.fuel_kd		FUEL_KD,	r.maint_st_dt	MAINT_ST_DT,	r.maint_end_dt	MAINT_END_DT, r.test_st_dt TEST_ST_DT, r.test_end_dt TEST_END_DT, r.car_l_cd CAR_L_CD, e.rent_mng_id	RENT_MNG_ID,	e.rent_l_cd		RENT_L_CD,	e.car_id		CAR_ID,	e.colo			COLO, e.opt			OPT, e.lpg_yn LPG_YN,	e.car_cs_amt	CAR_CS_AMT,	e.car_cv_amt	CAR_CV_AMT,	e.car_fs_amt	CAR_FS_AMT,	e.car_fv_amt	CAR_FV_AMT,	e.opt_cs_amt	OPT_CS_AMT,	e.opt_cv_amt	OPT_CV_AMT,	e.opt_fs_amt	OPT_FS_AMT,	e.opt_fv_amt	OPT_FV_AMT,	e.clr_cs_amt	CLR_CS_AMT,	e.clr_cv_amt	CLR_CV_AMT,	e.clr_fs_amt	CLR_FS_AMT,	e.clr_fv_amt	CLR_FV_AMT,	e.sd_cs_amt		SD_CS_AMT,	e.sd_cv_amt		SD_CV_AMT,	e.sd_fs_amt		SD_FS_AMT,	e.sd_fv_amt		SD_FV_AMT,	e.dc_cs_amt		DC_CS_AMT,	e.dc_cv_amt		DC_CV_AMT,	e.dc_fs_amt		DC_FS_AMT,	e.dc_fv_amt		DC_FV_AMT, c.mng_id		MNG_ID, c.dlv_dt DLV_DT,	decode(r.car_mng_id, sq.car_mng_id, 1, 0) ACCIDENT_YN, "+
			" vt.tot_dist TOT_DIST, r.dist_cng DIST_CNG, \n "+ //계기판교체(20190823)
			" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD'))))) as AVERAGE_DIST,  \n "+
			" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST, \n "+
			" bk.bank_nm BANK_NM, bk.lend_prn LEND_PRN, sw.alt_rest	LEND_REM, bk.alt_end_dt ALT_END_DT, s.lev LEV, s.reason REASON, s.car_st CAR_ST, s.imgfile1 IMGFILE1, s.imgfile2 IMGFILE2, s.imgfile3 IMGFILE3, s.imgfile4 IMGFILE4, s.imgfile5 IMGFILE5, \n "+
			" s.km, uc.damdang_id DETERM_ID, uc.hp_pr HPPR, uc.st_pr STPR, s.damdang_id DAMDANG_ID, s.modify_id MODIFY_ID, s.apprsl_dt APPRSL_DT, '' CAR_CHA_YN, 0 CLTR_AMT, r.off_ls OFF_LS, uc.actn_st ACTN_ST, s.actn_id ACTN_ID, s.actn_wh ACTN_WH, \n "+
			//" decode(r.park, '1','목동주차', '2','정일현대', '3','부산지점', '4','대전지점', '5','명진공업', '7','부산부경','8','부산조양','9','대전현대','10','오토크린', '11','대전금호','12','광주지점','13','대구지점','14','상무현대', '15','영남주차', '16','동화엠파크', substr(r.park_cont,1,5)) park_nm, r.cons_dt  CONS_DT,  \n"+				
			" decode(r.park,'6',substr(r.park_cont,1,5),nvl(cd.nm,r.park))  park_nm, r.cons_dt  CONS_DT,  \n"+
			" iu.ins_com_nm INS_COM_NM, iu.ins_exp_dt INS_EXP_DT, uc.actn_dt ACTN_DT, al.cpt_cd , \n "+
			"       nvl(ak.a_cnt,0) a_cnt, \n"+  //침수여부
			" '' P_RENT_MNG_ID, '' P_RENT_L_CD, '' P_RPT_NO, '' P_CAR_NO, '' P_DLV_DT,  '' P_CAR_OFF_NM, '' P_EMP_ID, '' P_EMP_NM, uc.o_s_amt  \n "+
			" from car_reg r, cont c, car_etc e, apprsl s,  CAR_NM m, CAR_MNG n, v_tot_dist vt, allot al, \n "+
			"        ( select c_st, code, nm_cd, nm from code where c_st = '0027' and code <> '0000'  ) cd,  \n"+  //주차장 
			"	(select distinct ac.car_mng_id CAR_MNG_ID from accident ac, car_reg re where ac.car_mng_id=re.car_mng_id) sq, \n "+
			"	(select a.car_mng_id CAR_MNG_ID, a.serv_dt SERV_DT, a.tot_dist TOT_DIST  from service a where a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where car_mng_id = a.car_mng_id)) i, \n "+
			"	(select al.rent_mng_id RENT_MNG_ID, al.rent_l_cd RENT_L_CD, cd.nm BANK_NM, al.lend_prn LEND_PRN, al.alt_end_dt ALT_END_DT from allot al, code cd where al.cpt_cd = cd.code and cd.c_st = '0003') bk, \n "+
		//	"	(SELECT DISTINCT cc.car_mng_id CAR_MNG_ID FROM car_cha cc, car_reg re WHERE cc.car_mng_id = re.car_mng_id) ch, \n "+
			"   (select car_mng_id, count(0) as a_cnt from accident where accid_st='6' group by car_mng_id) ak, \n"+ //침수
			"	(SELECT sc.car_mng_id CAR_MNG_ID, sc.alt_rest ALT_REST FROM scd_alt_case sc WHERE sc.alt_tm = (select max(alt_tm) from scd_alt_case where car_mng_id = sc.car_mng_id)) sw, \n "+
			"	(SELECT car_mng_id, cha_dt, car_no FROM car_change a WHERE a.cha_seq = to_char(to_number((select max(b.cha_seq) from car_change b where a.car_mng_id = b.car_mng_id))-1)) cg, \n "+
			"	(SELECT a.car_mng_id CAR_MNG_ID, a.seq SEQ, a.actn_st ACTN_ST, a.actn_dt ACTN_DT, a.damdang_id DAMDANG_ID, a.hp_pr HP_PR, a.st_pr ST_PR, a.o_s_amt FROM auction a WHERE a.seq = (select max(seq) from auction where car_mng_id = a.car_mng_id)) uc, \n "+
			"   (select ir.car_mng_id CAR_MNG_ID, ic.ins_com_nm INS_COM_NM, ir.ins_exp_dt INS_EXP_DT from insur ir, ins_com ic where ir.ins_com_id = ic.ins_com_id and ir.ins_st = (select max(ins_st) from insur where car_mng_id = ir.car_mng_id)) iu \n "+
			" where r.car_mng_id = c.car_mng_id \n "+
			"  and c.rent_mng_id = e.rent_mng_id \n "+
			"  and c.rent_l_cd = e.rent_l_cd \n "+
			"  and r.car_mng_id = sq.car_mng_id(+) \n "+
			"  and c.car_st = '2' "+
			"  and c.use_yn = 'Y' "+
			"  and r.off_ls = '3' "+
			"  and r.car_mng_id = i.car_mng_id(+) "+
			"  and r.car_mng_id = ak.car_mng_id(+) "+
			"  and c.rent_mng_id = bk.rent_mng_id(+) \n "+
			"  and c.rent_l_cd = bk.rent_l_cd(+) \n "+
			"  and r.car_mng_id = s.car_mng_id(+) \n "+
		//	"  and r.car_mng_id = ch.car_mng_id(+)\n "+
			"  AND r.car_mng_id = sw.car_mng_id(+) \n "+
		//	"  AND c.rent_mng_id = t.rent_mng_id(+)\n "+
		//	"  AND c.rent_l_cd = t.rent_l_cd(+) "+
			"  AND r.car_mng_id = cg.car_mng_id(+)\n "+
			"  AND e.car_id = m.car_id "+	
			"  and e.car_seq = m.car_seq \n "+
			"  and m.car_comp_id = n.car_comp_id \n "+
			"  and m.car_cd = n.code "+	
			"  and r.car_mng_id = vt.car_mng_id(+) "+
			"  and r.car_mng_id = uc.car_mng_id(+) \n "+
			"  and r.park = cd.nm_cd(+) \n"+  //주차장 코드 테이블 
			dt_query + 	su_query +
			"  and r.car_mng_id = iu.car_mng_id(+) "+
			"  and c.rent_mng_id = al.rent_mng_id \n "+
			"  and c.rent_l_cd = al.rent_l_cd\n "+
			subQuery +
			" ORDER BY actn_dt,  actn_id, actn_st  ";
		}else{
		query = "select	r.car_mng_id CAR_MNG_ID, r.car_no CAR_NO, cg.car_no	CAR_PRE_NO,	cg.cha_dt CHA_DT, r.car_num CAR_NUM, r.init_reg_dt	INIT_REG_DT, r.car_kd CAR_KD, r.car_use	CAR_USE, n.car_nm CAR_JNM, m.car_name CAR_NM,	r.car_form CAR_FORM, r.car_y_form	CAR_Y_FORM,	r.dpm			DPM,	r.fuel_kd		FUEL_KD,	r.maint_st_dt	MAINT_ST_DT,	r.maint_end_dt	MAINT_END_DT, r.test_st_dt TEST_ST_DT, r.test_end_dt TEST_END_DT, r.car_l_cd CAR_L_CD, e.rent_mng_id	RENT_MNG_ID,	e.rent_l_cd		RENT_L_CD,	e.car_id		CAR_ID,	e.colo			COLO, e.opt			OPT, e.lpg_yn LPG_YN,	e.car_cs_amt	CAR_CS_AMT,	e.car_cv_amt	CAR_CV_AMT,	e.car_fs_amt	CAR_FS_AMT,	e.car_fv_amt	CAR_FV_AMT,	e.opt_cs_amt	OPT_CS_AMT,	e.opt_cv_amt	OPT_CV_AMT,	e.opt_fs_amt	OPT_FS_AMT,	e.opt_fv_amt	OPT_FV_AMT,	e.clr_cs_amt	CLR_CS_AMT,	e.clr_cv_amt	CLR_CV_AMT,	e.clr_fs_amt	CLR_FS_AMT,	e.clr_fv_amt	CLR_FV_AMT,	e.sd_cs_amt		SD_CS_AMT,	e.sd_cv_amt		SD_CV_AMT,	e.sd_fs_amt		SD_FS_AMT,	e.sd_fv_amt		SD_FV_AMT,	e.dc_cs_amt		DC_CS_AMT,	e.dc_cv_amt		DC_CV_AMT,	e.dc_fs_amt		DC_FS_AMT,	e.dc_fv_amt		DC_FV_AMT, c.mng_id		MNG_ID, c.dlv_dt DLV_DT,	decode(r.car_mng_id, sq.car_mng_id, 1, 0) ACCIDENT_YN, "+
			" vt.tot_dist TOT_DIST, r.dist_cng  DIST_CNG, "+	//계기판교체(20190823)
			" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD'))))) as AVERAGE_DIST, "+
			" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST, "+
			" bk.bank_nm BANK_NM, bk.lend_prn LEND_PRN, sw.alt_rest	LEND_REM, bk.alt_end_dt ALT_END_DT, s.lev LEV, s.reason REASON, s.car_st CAR_ST, s.imgfile1 IMGFILE1, s.imgfile2 IMGFILE2, s.imgfile3 IMGFILE3, s.imgfile4 IMGFILE4, s.imgfile5 IMGFILE5, "+
			" s.km, uc.damdang_id DETERM_ID, uc.hp_pr HPPR, uc.st_pr STPR, s.damdang_id DAMDANG_ID, s.modify_id MODIFY_ID, s.apprsl_dt APPRSL_DT, '' CAR_CHA_YN, 0 CLTR_AMT, r.off_ls OFF_LS, uc.actn_st ACTN_ST, s.actn_id ACTN_ID, s.actn_wh ACTN_WH, "+
			" iu.ins_com_nm INS_COM_NM, iu.ins_exp_dt INS_EXP_DT, uc.actn_dt ACTN_DT, al.cpt_cd, "+
			"       nvl(ak.a_cnt,0) a_cnt, \n"+  //침수여부
			//" decode(r.park, '1','목동주차', '2','정일현대', '3','부산지점', '4','대전지점', '5','명진공업', '7','부산부경','8','부산조양','9','대전현대','10','오토크린', '11','대전금호','12','광주지점','13','대구지점','14','상무현대', '15','영남주차', '16','동화엠파크', substr(r.park_cont,1,5)) park_nm, r.cons_dt  CONS_DT,  \n"+				
			" decode(r.park,'6',substr(r.park_cont,1,5),nvl(cd.nm,r.park))  park_nm, r.cons_dt  CONS_DT,  \n"+
			" '' P_RENT_MNG_ID, '' P_RENT_L_CD, '' P_RPT_NO, '' P_CAR_NO, '' P_DLV_DT,  '' P_CAR_OFF_NM, '' P_EMP_ID, '' P_EMP_NM, uc.o_s_amt " +
			" from car_reg r, cont c, car_etc e, apprsl s,  CAR_NM m, CAR_MNG n, v_tot_dist vt, allot al, \n"+
			"        ( select c_st, code, nm_cd, nm from code where c_st = '0027' and code <> '0000'  ) cd,  \n"+  //주차장 
			"	(select distinct ac.car_mng_id CAR_MNG_ID from accident ac, car_reg re where ac.car_mng_id=re.car_mng_id) sq, "+
			"	(select a.car_mng_id CAR_MNG_ID, a.serv_dt SERV_DT, a.tot_dist TOT_DIST  from service a where a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where car_mng_id = a.car_mng_id)) i, "+
			"	(select al.rent_mng_id RENT_MNG_ID, al.rent_l_cd RENT_L_CD, cd.nm BANK_NM, al.lend_prn LEND_PRN, al.alt_end_dt ALT_END_DT from allot al, code cd where al.cpt_cd = cd.code and cd.c_st = '0003') bk, "+
		//	"	(SELECT DISTINCT cc.car_mng_id CAR_MNG_ID FROM car_cha cc, car_reg re WHERE cc.car_mng_id = re.car_mng_id) ch, "+
			"   (select car_mng_id, count(0) as a_cnt from accident where accid_st='6' group by car_mng_id) ak, \n"+ //침수
			"	(SELECT sc.car_mng_id CAR_MNG_ID, sc.alt_rest ALT_REST FROM scd_alt_case sc WHERE sc.alt_tm = (select max(alt_tm) from scd_alt_case where car_mng_id = sc.car_mng_id)) sw, "+
			"	(SELECT car_mng_id, cha_dt, car_no FROM car_change a WHERE a.cha_seq = to_char(to_number((select max(b.cha_seq) from car_change b where a.car_mng_id = b.car_mng_id))-1)) cg, "+
			"	(SELECT a.car_mng_id CAR_MNG_ID, a.seq SEQ, a.actn_st ACTN_ST, a.actn_dt ACTN_DT, a.damdang_id DAMDANG_ID, a.hp_pr HP_PR, a.st_pr ST_PR, a.o_s_amt FROM auction a WHERE a.seq = (select max(seq) from auction where car_mng_id = a.car_mng_id)) uc, "+
			"   (select ir.car_mng_id CAR_MNG_ID, ic.ins_com_nm INS_COM_NM, ir.ins_exp_dt INS_EXP_DT from insur ir, ins_com ic where ir.ins_com_id = ic.ins_com_id and ir.ins_st = (select max(ins_st) from insur where car_mng_id = ir.car_mng_id)) iu "+
			" where r.car_mng_id = c.car_mng_id "+
			"  and c.rent_mng_id = e.rent_mng_id "+
			"  and c.rent_l_cd = e.rent_l_cd "+
			"  and r.car_mng_id = sq.car_mng_id(+) "+
			"  and c.car_st = '2' "+
			"  and c.use_yn = 'Y' "+
			"  and r.off_ls = '3' "+
			"  and r.car_mng_id = i.car_mng_id(+) "+
			"  and r.car_mng_id = ak.car_mng_id(+) "+//
			"  and c.rent_mng_id = bk.rent_mng_id(+) "+
			"  and c.rent_l_cd = bk.rent_l_cd(+) "+
			"  and r.car_mng_id = s.car_mng_id(+) "+
		//	"  and r.car_mng_id = ch.car_mng_id(+) "+
			"  AND r.car_mng_id = sw.car_mng_id(+) "+
		//	"  AND c.rent_mng_id = t.rent_mng_id(+) "+
		//	"  AND c.rent_l_cd = t.rent_l_cd(+) "+
			"  AND r.car_mng_id = cg.car_mng_id(+) "+
			"  AND e.car_id = m.car_id "+	
			"  and e.car_seq = m.car_seq "+
			"  and m.car_comp_id = n.car_comp_id "+
			"  and m.car_cd = n.code "+	
			"  and r.car_mng_id = vt.car_mng_id(+) "+
			"  and r.car_mng_id = uc.car_mng_id(+) "+
			" and r.park = cd.nm_cd(+) \n"+  //주차장 코드 테이블 
			dt_query + 	su_query +
			"  and r.car_mng_id = iu.car_mng_id(+) "+
			"  and c.rent_mng_id = al.rent_mng_id "+
			"  and c.rent_l_cd = al.rent_l_cd "+
			subQuery +
			" ORDER BY actn_dt, actn_id, actn_st, decode(r.park, '1','11', '2','12', '3','21', '4','31', '5','13', '7','22','8','23','9','32', '99') ";
		}

		Collection<Offls_actnBean> col = new ArrayList<Offls_actnBean>();


		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while(rs.next()){
				col.add(makeOffls_actnBean(rs));
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_preDatabase:getActn_lst(String gubun, String gubun_nm)]"+e);
			System.out.println("[Offls_preDatabase:getActn_lst(String gubun, String gubun_nm)]"+query);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return (Offls_actnBean[])col.toArray(new Offls_actnBean[0]);
		}		
	}

	/**
	*	경매관리 Bean에 데이터 넣기 2003.4.25.Fri.
	*/
	 private Offls_auctionBean makeAuction(ResultSet results) throws DatabaseException {

        try {
            Offls_auctionBean bean = new Offls_auctionBean();

			bean.setCar_mng_id	(results.getString("CAR_MNG_ID"));			//자동차관리번호
			bean.setSeq			(results.getString("SEQ"));
			bean.setActn_st		(results.getString("ACTN_ST"));
			bean.setActn_cnt	(results.getString("ACTN_CNT"));
			bean.setActn_num	(results.getString("ACTN_NUM"));
			bean.setActn_dt		(results.getString("ACTN_DT"));
			bean.setSt_pr		(results.getInt("ST_PR"));
			bean.setHp_pr		(results.getInt("HP_PR"));
			bean.setAma_jum		(results.getString("AMA_JUM"));
			bean.setAma_rsn		(results.getString("AMA_RSN"));
			bean.setAma_nm		(results.getString("AMA_NM"));
			bean.setActn_jum	(results.getString("ACTN_JUM"));
			bean.setActn_rsn	(results.getString("ACTN_RSN"));
			bean.setActn_nm		(results.getString("ACTN_NM"));
			bean.setDamdang_id	(results.getString("DAMDANG_ID"));
			bean.setModify_id	(results.getString("MODIFY_ID"));
			bean.setNak_pr		(results.getInt("NAK_PR"));
			bean.setNak_nm		(results.getString("NAK_NM"));
			bean.setChoi_st		(results.getString("CHOI_ST"));
			bean.setO_s_amt		(results.getInt("O_S_AMT"));
			bean.setOut_amt		(results.getInt("OUT_AMT"));
			bean.setOffls_file	(results.getString("OFFLS_FILE"));

		return bean;

        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}

	/**
	*	매각진행차량 경매관리 조회 - 2003.3.25.Tue.
	*/
	public Offls_auctionBean getAuction(String car_mng_id, String seq){
		getConnection();
		Offls_auctionBean auction = new Offls_auctionBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT car_mng_id, seq, actn_st, actn_cnt, actn_num, actn_dt, st_pr, hp_pr, ama_jum, ama_rsn, ama_nm, actn_jum, actn_rsn, actn_nm, "+
				"        damdang_id, modify_id, nak_pr, nak_nm, choi_st, o_s_amt, out_amt, offls_file "+
				" FROM   auction "+
				" WHERE  car_mng_id = ? AND seq = ? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
			pstmt.setString(2,seq);
			rs = pstmt.executeQuery();
			if(rs.next()){
				auction = makeAuction(rs);				
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_actnDatabase:getAuction(String car_mng_id, String seq)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return auction;
		}		
	}

	/**
	*	매각진행차량 경매관리 리스트 조회 - 2004.11.5.Tue.
	*/
	public Offls_auctionBean[] getAuction(String car_mng_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		Collection<Offls_auctionBean> col = new ArrayList<Offls_auctionBean>();

		query = "SELECT car_mng_id, seq, actn_st, actn_cnt, actn_num, actn_dt, st_pr, hp_pr, ama_jum, ama_rsn, ama_nm, actn_jum, actn_rsn, actn_nm, damdang_id, modify_id, nak_pr, nak_nm, choi_st, o_s_amt, out_amt, offls_file "+
				"FROM auction WHERE car_mng_id = ? "+
				" ORDER BY seq desc ";
		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				col.add(makeAuction(rs));
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_actnDatabase:getAuction(String car_mng_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return (Offls_auctionBean[])col.toArray(new Offls_auctionBean[0]);
		}		
	}

	/**
	*	매각진행차량 경매관리 조회 - 2003.04.14.Mon.
	*	- 재출품된 정보
	*/
	public Offls_auction_reBean getAuction_re(String car_mng_id, String actn_cnt){
		getConnection();
		Offls_auction_reBean auction_re = new Offls_auction_reBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = "SELECT car_mng_id, actn_cnt, damdang_id, re_dt, re_nm, re_tel, hp_pr, st_pr, modify_id "+
				"FROM auction_re WHERE car_mng_id = ? AND actn_cnt = ? ";
		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
			pstmt.setString(2,actn_cnt);
			rs = pstmt.executeQuery();
			while(rs.next()){
				auction_re.setCar_mng_id(rs.getString("CAR_MNG_ID"));			//자동차관리번호
				auction_re.setActn_cnt(rs.getString("ACTN_CNT"));
				auction_re.setDamdang_id(rs.getString("DAMDANG_ID"));
				auction_re.setRe_dt(rs.getString("RE_DT"));
				auction_re.setRe_nm(rs.getString("RE_NM"));
				auction_re.setRe_tel(rs.getString("RE_TEL"));
				auction_re.setHp_pr(rs.getInt("HP_PR"));
				auction_re.setSt_pr(rs.getInt("ST_PR"));
				auction_re.setModify_id(rs.getString("MODIFY_ID"));
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_actnDatabase:getAuction_re(String car_mng_id, String actn_cnt)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return auction_re;
		}		
	}

	/**
	*	매각진행차량 경매관리 조회 - 2003.04.14.Mon.
	*	- 반출된 정보
	*/
	public Offls_auction_banBean getAuction_ban(String car_mng_id, String actn_cnt){
		getConnection();
		Offls_auction_banBean auction_ban = new Offls_auction_banBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = "SELECT car_mng_id, actn_cnt, ban_nm, ban_tel, ban_dt, ban_reason, ban_car_st, js_chul, js_tak, js_in_amt, js_dt, tak_up, tak_nm, tak_tel, insu_id, ban_chk, modify_id "+
				"FROM auction_ban WHERE car_mng_id = ? AND actn_cnt = ? ";
		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
			pstmt.setString(2,actn_cnt);
			rs = pstmt.executeQuery();
			while(rs.next()){
				auction_ban.setCar_mng_id(rs.getString("CAR_MNG_ID"));			//자동차관리번호
				auction_ban.setActn_cnt(rs.getString("ACTN_CNT"));
				auction_ban.setBan_nm(rs.getString("BAN_NM"));
				auction_ban.setBan_tel(rs.getString("BAN_TEL"));
				auction_ban.setBan_dt(rs.getString("BAN_DT"));
				auction_ban.setBan_reason(rs.getString("BAN_REASON"));
				auction_ban.setBan_car_st(rs.getString("BAN_CAR_ST"));
				auction_ban.setJs_chul(rs.getInt("JS_CHUL"));
				auction_ban.setJs_tak(rs.getInt("JS_TAK"));
				auction_ban.setJs_in_amt(rs.getInt("JS_IN_AMT"));
				auction_ban.setJs_dt(rs.getString("JS_DT"));
				auction_ban.setTak_up(rs.getString("TAK_UP"));
				auction_ban.setTak_nm(rs.getString("TAK_NM"));
				auction_ban.setTak_tel(rs.getString("TAK_TEL"));
				auction_ban.setInsu_id(rs.getString("INSU_ID"));
				auction_ban.setBan_chk(rs.getString("BAN_CHK"));
				auction_ban.setModify_id(rs.getString("MODIFY_ID"));
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_actnDatabase:getAuction_ban(String car_mng_id, String seq)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return auction_ban;
		}		
	}

	/**
	*	매각진행차량 경매관리 모조리(몽땅) 조회 - 2003.3.29.Sat.
	*/
	public Offls_auctionBean[] getAuction_list(String car_mng_id){
		getConnection();
		Collection<Offls_auctionBean> col = new ArrayList<Offls_auctionBean>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT  car_mng_id, seq, actn_st, actn_cnt, actn_num, actn_dt, st_pr, hp_pr, ama_jum, ama_rsn, ama_nm, actn_jum, "+
				"        actn_rsn, actn_nm, damdang_id, modify_id, nak_pr, nak_nm, choi_st, o_s_amt, out_amt, offls_file "+
				" FROM   auction "+
				" WHERE  car_mng_id = ? "+
				" order by 2 ";


		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				col.add(makeAuction(rs));
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_actnDatabase:getAuction(String car_mng_id)]"+e);
			System.out.println("[Offls_actnDatabase:getAuction(String car_mng_id)]"+query);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return (Offls_auctionBean[])col.toArray(new Offls_auctionBean[0]);
		}		
	}

	/**
	*	매각진행차량 경매관리 조회 - 2003.3.25.Tue.
	*/
	public String getAuction_maxSeq(String car_mng_id){
		getConnection();
		String seq = "01";
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
			System.out.println("[Offls_actnDatabase:getAuction_maxSeq(String car_mng_id)]"+e);
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
	*	매각진행차량 경매관리 조회 - 2003.4.29.Tue.
	*/
	public String getPer_talk_maxSeq(String car_mng_id, String actn_cnt){
		getConnection();
		String seq = "0";
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		query = "SELECT distinct a.seq SEQ "+
				"FROM per_talk a "+
				"WHERE a.seq = (select max(seq) from per_talk where car_mng_id = a.car_mng_id AND actn_cnt=a.actn_cnt) "+
				"AND a.car_mng_id = '"+car_mng_id+"' AND a.actn_cnt='"+actn_cnt+"'";
		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while(rs.next()){
				seq = rs.getString(1)==null?"0":rs.getString(1);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_actnDatabase:getAuction_maxSeq(String car_mng_id)]"+e);
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
	*	매각진행차량 전경매희망가 - 2003.04.09.Wed.
	*/
	public int getPre_hp_pr(String car_mng_id, String seq){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		int hp_pr = 0;

		query = "SELECT hp_pr FROM auction WHERE car_mng_id=? AND seq=?";
		try{
			//순번감소, 전경매
			int i_seq = Integer.parseInt(seq);
			if(i_seq<10){
				seq = "0"+String.valueOf(i_seq-1);
			}else{
				seq = String.valueOf(i_seq-1);
			}
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
			pstmt.setString(2,seq);
			rs = pstmt.executeQuery();
			while(rs.next()){
				hp_pr = rs.getInt("HP_PR");
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_actnDatabase:getPre_hp_pr(String car_mng_id, String seq)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return hp_pr;
		}		
	}

	/**
	*	상품가격 평가 데이터 존재 여부 - 2003.04.22.Tue.
	*	- 등록,수정버튼 구분하기위해
	*/
	public String getAuction_Car_mng_id(String car_mng_id){

		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String auction_car_mng_id = "";
		String query = "SELECT car_mng_id FROM auction WHERE car_mng_id=? AND seq=?";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
			pstmt.setString(2,this.getAuction_maxSeq(car_mng_id));
			rs = pstmt.executeQuery();
			while(rs.next()){
				auction_car_mng_id = rs.getString(1);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_actnDatabase:getAuction_Car_mng_id(String car_mng_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return auction_car_mng_id;
		}
	}

	/**
	*	매각진행차량 경매관리 입력- 2003.4.22.Tue.
	*	20041102 - 수정 Yongsoon Kwon. 
	*/
	public int insAuction(Offls_auctionBean auction){
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = "";

		query = "INSERT INTO auction(car_mng_id, seq, st_pr, hp_pr, damdang_id, modify_id, o_s_amt, out_amt, offls_file) "+
				" SELECT ?, nvl(lpad(max(seq)+1,2,'0'),'01'),?,?,?,?,?, ?, ? FROM auction WHERE car_mng_id = ? ";

		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1, auction.getCar_mng_id());
			pstmt.setInt	(2, auction.getSt_pr());
			pstmt.setInt	(3, auction.getHp_pr());
			pstmt.setString	(4, auction.getDamdang_id());
			pstmt.setString	(5, auction.getModify_id());
			pstmt.setInt	(6, auction.getO_s_amt());
			pstmt.setInt	(7, auction.getOut_amt());
			pstmt.setString	(8, auction.getOffls_file());
			pstmt.setString	(9, auction.getCar_mng_id());

			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		}catch(SQLException e){
			System.out.println("[Offls_actnDatabase:insAuction(Offls_auctionBean auction)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}
	}


	/**
	*	매각진행차량 경매관리 수정 - 2003.3.25.Tue.
	*/
	public int updAuction(Offls_auctionBean auction){
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = "";

		query = "UPDATE auction "+
			"SET actn_st=?, actn_cnt=?, actn_num=?, actn_dt=?, st_pr=?, hp_pr=?, ama_jum=?, ama_rsn=?, ama_nm=?, actn_jum=?, actn_rsn=?, actn_nm=?, modify_id=?, o_s_amt=?, out_amt=?, offls_file = ? "+
			"WHERE car_mng_id=? AND seq=? ";

		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,auction.getActn_st());
			pstmt.setString(2,auction.getActn_cnt());
			pstmt.setString(3,auction.getActn_num());
			pstmt.setString(4,auction.getActn_dt());
			pstmt.setInt   (5,auction.getSt_pr());
			pstmt.setInt   (6,auction.getHp_pr());
			pstmt.setString(7,auction.getAma_jum());
			pstmt.setString(8,auction.getAma_rsn());
			pstmt.setString(9,auction.getAma_nm());
			pstmt.setString(10,auction.getActn_jum());
			pstmt.setString(11,auction.getActn_rsn());
			pstmt.setString(12,auction.getActn_nm());
			pstmt.setString(13,auction.getModify_id());
			pstmt.setInt   (14,auction.getO_s_amt());
			pstmt.setInt   (15,auction.getOut_amt());
			pstmt.setString(16,auction.getOffls_file());
			pstmt.setString(17,auction.getCar_mng_id());
			pstmt.setString(18,auction.getSeq());
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
		}catch(SQLException e){
			System.out.println("[Offls_actnDatabase:updAuction(Offls_auctionBean auction)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}		
	}

	/**
	*	매각진행차량 경매관리 수정2 - 2003.4.23.Wed.
	*	- 상품관리에서 call
	*/
	public int updAuction2(Offls_auctionBean auction){
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = "";

		query = "UPDATE auction "+
			"SET st_pr=?, hp_pr=?, damdang_id=?, modify_id=? "+
			"WHERE car_mng_id=? AND seq=? ";

		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setInt(1,auction.getSt_pr());
			pstmt.setInt(2,auction.getHp_pr());
			pstmt.setString(3,auction.getDamdang_id());
			pstmt.setString(4,auction.getModify_id());
			pstmt.setString(5,auction.getCar_mng_id());
			pstmt.setString(6,this.getAuction_maxSeq(auction.getCar_mng_id()));
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
				
		}catch(SQLException e){
			System.out.println("[Offls_actnDatabase:updAuction2(Offls_auctionBean auction)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}		
	}

	/**
	*	매각진행차량 경매관리 재출품 수정 - 2003.04.14.Mon.
	*/
	public int updAuction_re(Offls_auction_reBean auction_re){
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = "";

		query = "UPDATE auction_re "+
			"SET damdang_id=?, re_dt=?, re_nm=?, re_tel=?, hp_pr=?, st_pr=?, modify_id=? "+
			"WHERE car_mng_id=? AND actn_cnt=? ";

		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,auction_re.getDamdang_id());
			pstmt.setString(2,auction_re.getRe_dt());
			pstmt.setString(3,auction_re.getRe_nm());
			pstmt.setString(4,auction_re.getRe_tel());
			pstmt.setInt(5,auction_re.getHp_pr());
			pstmt.setInt(6,auction_re.getSt_pr());
			pstmt.setString(7,auction_re.getModify_id());
			pstmt.setString(8,auction_re.getCar_mng_id());
			pstmt.setString(9,auction_re.getActn_cnt());
			result = pstmt.executeUpdate();	
			pstmt.close();
			conn.commit();
						
		}catch(SQLException e){
			System.out.println("[Offls_actnDatabase:updAuction_re(Offls_auction_reBean auction_re)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}		
	}

	/**
	*	매각진행차량 경매관리 재출품 생성 - 2003.04.14.Mon.
	*/
	public int insAuction_re(Offls_auction_reBean auction_re){
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = "";

		query = "INSERT INTO auction_re(car_mng_id,actn_cnt,damdang_id,re_dt,re_nm,re_tel,hp_pr,st_pr,modify_id) VALUES(?,?,?,?,?,?,?,?,?)";

		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,auction_re.getCar_mng_id());
			pstmt.setString(2,auction_re.getActn_cnt());
			pstmt.setString(3,auction_re.getDamdang_id());
			pstmt.setString(4,auction_re.getRe_dt());
			pstmt.setString(5,auction_re.getRe_nm());
			pstmt.setString(6,auction_re.getRe_tel());
			pstmt.setInt(7,auction_re.getHp_pr());
			pstmt.setInt(8,auction_re.getSt_pr());
			pstmt.setString(9,auction_re.getModify_id());
			result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		}catch(SQLException e){
			System.out.println("[Offls_actnDatabase:insAuction_re(Offls_auction_reBean auction_re)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}		
	}

	/**
	*	매각진행차량 경매관리 반출 수정 - 2003.04.28.Mon.
	*/
	public int updAuction_ban(Offls_auction_banBean auction_ban){
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = "";

		query = "UPDATE auction_ban "+
				"SET ban_nm=?, ban_tel=?, ban_dt=?, ban_reason=?, ban_car_st=?, js_chul=?, js_tak=?, js_in_amt=?, js_dt=?, tak_up=?, tak_nm=?, tak_tel=?, insu_id=?, ban_chk=?, modify_id=? "+
				"WHERE car_mng_id=? AND actn_cnt=? ";

		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,auction_ban.getBan_nm());
			pstmt.setString(2,auction_ban.getBan_tel());
			pstmt.setString(3,auction_ban.getBan_dt());
			pstmt.setString(4,auction_ban.getBan_reason());
			pstmt.setString(5,auction_ban.getBan_car_st());
			pstmt.setInt(6,auction_ban.getJs_chul());
			pstmt.setInt(7,auction_ban.getJs_tak());
			pstmt.setInt(8,auction_ban.getJs_in_amt());
			pstmt.setString(9,auction_ban.getJs_dt());
			pstmt.setString(10,auction_ban.getTak_up());
			pstmt.setString(11,auction_ban.getTak_nm());
			pstmt.setString(12,auction_ban.getTak_tel());
			pstmt.setString(13,auction_ban.getInsu_id());
			pstmt.setString(14,auction_ban.getBan_chk());
			pstmt.setString(15,auction_ban.getModify_id());
			pstmt.setString(16,auction_ban.getCar_mng_id());
			pstmt.setString(17,auction_ban.getActn_cnt());
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
		}catch(SQLException e){
			System.out.println("[Offls_actnDatabase:updAuction_ban(Offls_auction_banBean auction_ban)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}		
	}

	/**
	*	매각진행차량 경매관리 반출 생성 - 2003.04.14.Mon.
	*/
	public int insAuction_ban(Offls_auction_banBean auction_ban){
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = "";

		query = "INSERT INTO auction_ban(car_mng_id,actn_cnt,ban_nm,ban_tel,ban_dt,ban_reason,ban_car_st,js_chul,js_tak,js_in_amt,js_dt,tak_up,tak_nm,tak_tel,insu_id,ban_chk,modify_id) "+
				" VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,auction_ban.getCar_mng_id());
			pstmt.setString(2,auction_ban.getActn_cnt());
			pstmt.setString(3,auction_ban.getBan_nm());
			pstmt.setString(4,auction_ban.getBan_tel());
			pstmt.setString(5,auction_ban.getBan_dt());
			pstmt.setString(6,auction_ban.getBan_reason());
			pstmt.setString(7,auction_ban.getBan_car_st());
			pstmt.setInt(8,auction_ban.getJs_chul());
			pstmt.setInt(9,auction_ban.getJs_tak());
			pstmt.setInt(10,auction_ban.getJs_in_amt());
			pstmt.setString(11,auction_ban.getJs_dt());
			pstmt.setString(12,auction_ban.getTak_up());
			pstmt.setString(13,auction_ban.getTak_nm());
			pstmt.setString(14,auction_ban.getTak_tel());
			pstmt.setString(15,auction_ban.getInsu_id());
			pstmt.setString(16,auction_ban.getBan_chk());
			pstmt.setString(17,auction_ban.getModify_id());
			result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		}catch(SQLException e){
			System.out.println("[Offls_actnDatabase:insAuction_ban(Offls_auction_banBean auction_ban)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}		
	}

	/**
	*	매각진행차량 경매관리 수정 낙찰가격 - 2003.4.17.Thu.
	*/
	public int updAuction_nak(String car_mng_id, String seq, int nak_pr, String nak_nm){
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = "";

		query = "UPDATE auction SET nak_pr=?, nak_nm=? WHERE car_mng_id=? AND seq=? ";

		try{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
			pstmt.setInt(1,nak_pr);
			pstmt.setString(2,nak_nm);
			pstmt.setString(3,car_mng_id);
			pstmt.setString(4,seq);
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
		}catch(SQLException e){
			System.out.println("[Offls_actnDatabase:updAuction_nak(String car_mng_id, String seq, int nak_pr, String nak_nm, int car_pr)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}		
	}

	/**
	*	매각진행차량 경매관리 경매상태 등록 - 2003.04.07.Mon.
	*/
	public int updActn_st(String car_mng_id, String seq){
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query2 = "";

		//기존 레코드 경매상태를 개별상담에서 유찰로 바꾼후 새 레코드 생성
		query2 = "UPDATE auction SET actn_st='2' WHERE car_mng_id=? AND seq=?";

		try{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query2);
			pstmt.setString(1,car_mng_id);
			pstmt.setString(2,seq);
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
				
		}catch(SQLException e){
			System.out.println("[Offls_actnDatabase:updActn_st(String car_mng_id, String seq)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}		
	}

	/**
	*	매각진행차량 경매관리 경매상태 낙찰로 등록 - 2003.04.22.Tue.
	*/
	public int updActn_st_nak(String car_mng_id, String seq){
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query2 = "";

		//기존 레코드 경매상태를 개별상담에서 낙찰로 바꾼다
		query2 = "UPDATE auction SET actn_st='4' WHERE car_mng_id=? AND seq=?";

		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query2);
			pstmt.setString(1,car_mng_id);
			pstmt.setString(2,seq);
			result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
			
		}catch(SQLException e){
			System.out.println("[Offls_actnDatabase:updActn_st_nak(String car_mng_id, String seq)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}		
	}

	/**
	*	매각진행차량 경매관리 재출품 - 2003.3.27.Thu.
	*/
	public int reAuction(String car_mng_id, String seq, Offls_auction_reBean auction_re, String user_id){
		getConnection();
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		ResultSet rs = null;
		int result = 0;
		String query = "";
		String query2 = "";
		String query3 = "";
		int car_pr=0;
		String ama_jum="", ama_rsn="", ama_nm="", actn_jum="", actn_rsn = "", actn_nm="";

		query = "UPDATE auction SET choi_st='1' WHERE car_mng_id=? AND seq=?";
		query2 = "SELECT ama_jum, ama_rsn, ama_nm, actn_jum, actn_rsn, actn_nm FROM auction WHERE car_mng_id=? AND seq=?";
		query3 = "INSERT INTO auction(car_mng_id, seq, st_pr, hp_pr, ama_jum, ama_rsn, ama_nm, actn_jum, actn_rsn, actn_nm, damdang_id, modify_id) VALUES(?,?,?,?,?,?,?,?,?,?,?,?)";

		try{
			conn.setAutoCommit(false);


			//최종상태를 재출품으로
			pstmt1 = conn.prepareStatement(query);
			pstmt1.setString(1,car_mng_id);
			pstmt1.setString(2,seq);
			result = pstmt1.executeUpdate();
			pstmt1.close();

			if(result>0){
				//신차가, 시작가, 희망가, 아마존카점수, 아마존카평가, 경매장점수, 경매장평가 가져와서 새 레코드에
				pstmt2 = conn.prepareStatement(query2);
				pstmt2.setString(1,car_mng_id);
				pstmt2.setString(2,seq);
				rs = pstmt2.executeQuery();
				while(rs.next()){
					ama_jum = rs.getString("AMA_JUM");
					ama_rsn = rs.getString("AMA_RSN");
					ama_nm = rs.getString("AMA_NM");
					actn_jum = rs.getString("ACTN_JUM");
					actn_rsn = rs.getString("ACTN_RSN");
					actn_nm = rs.getString("ACTN_NM");
				}
				rs.close();
				pstmt2.close();
			}
			if(result>0){
				//순번증가
				int i_seq = Integer.parseInt(seq);
				if(i_seq<9){
					seq = "0"+String.valueOf(i_seq+1);
				}else{
					seq = String.valueOf(i_seq+1);
				}
				pstmt3 = conn.prepareStatement(query3);
				pstmt3.setString(1,car_mng_id);
				pstmt3.setString(2,seq);
				pstmt3.setInt(3,auction_re.getSt_pr());
				pstmt3.setInt(4,auction_re.getHp_pr());
				pstmt3.setString(5,ama_jum);
				pstmt3.setString(6,ama_rsn);
				pstmt3.setString(7,ama_nm);
				pstmt3.setString(8,actn_jum);
				pstmt3.setString(9,actn_rsn);
				pstmt3.setString(10,actn_nm);
				pstmt3.setString(11,auction_re.getDamdang_id());
				pstmt3.setString(12,user_id);
				result = pstmt3.executeUpdate();
				pstmt3.close();
			}
			conn.commit();
		}catch(SQLException e){
			System.out.println("[Offls_actnDatabase:reAuction(String car_mng_id, String seq, Offls_auction_reBean auction_re)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
				if(rs != null) rs.close();
                if(pstmt1 != null) pstmt1.close();
                if(pstmt2 != null) pstmt2.close();
                if(pstmt3 != null) pstmt3.close();
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}		
	}

	/**
	*	경매관리 Bean에 데이터 넣기 2003.4.25.Fri.
	*/
	 private Offls_per_talkBean makePer_talkBean(ResultSet results) throws DatabaseException {

        try {
            Offls_per_talkBean bean = new Offls_per_talkBean();
			bean.setCar_mng_id(results.getString("CAR_MNG_ID"));	//자동차관리번호
			bean.setActn_cnt(results.getString("ACTN_CNT"));		//경매회차
			bean.setSeq(results.getString("SEQ"));				//순번
			bean.setCust_pr(results.getInt("CUST_PR"));			//고객제시액
			bean.setAma_pr(results.getInt("AMA_PR"));			//당사제시액
			bean.setReason(results.getString("REASON"));			//결렬사유

		return bean;

        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}

	/**
	*	매각진행차량 개별상담 조회 - 2003.3.28.Fri.
	*	-4.04.Fri. ;개별상담은 각 경매회찰별로관리하기 위해 actn_cnt경매회차 추가
	*/
	public Offls_per_talkBean[] getPer_talk(String car_mng_id, String actn_cnt){
		getConnection();
		Collection<Offls_per_talkBean> col2 = new ArrayList<Offls_per_talkBean>();
		ResultSet rs = null;
		String query = "";
		Statement stmt = null;

		query = "SELECT car_mng_id, actn_cnt, seq, cust_pr, ama_pr, reason  "+
				" FROM per_talk WHERE car_mng_id='"+car_mng_id+"' AND actn_cnt='"+actn_cnt+"' "+
				" ORDER BY seq ";

		try{
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);
			while(rs.next()){
				col2.add(makePer_talkBean(rs));
			}
			rs.close();
			stmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_actnDatabase:getPer_talk(String car_mng_id, String actn_cnt)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
				if(stmt !=null) stmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return (Offls_per_talkBean[])col2.toArray(new Offls_per_talkBean[0]);
		}		
	}

	/**
	*	매각진행차량 개별상담 낙찰가격 조회 - 2003.3.28.Fri.
	*/
	public int getPer_talk_nak_pr(String car_mng_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int nak_pr = 0;
		String query = "";

		query = "SELECT nak_pr FROM auction WHERE car_mng_id=? AND seq=? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
			pstmt.setString(2,this.getAuction_maxSeq(car_mng_id));
			rs = pstmt.executeQuery();
			while(rs.next()){
				nak_pr = rs.getInt("NAK_PR");
			}
			rs.close();
			pstmt.close();

		}catch(SQLException e){
			System.out.println("[Offls_actnDatabase:getPer_talk_nak_pr(String car_mng_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return nak_pr;
		}
	}

	/**
	*	매각진행차량 개별상담 수정 - 2003.3.28.Fri.
	*	-4.04.Fri. ;개별상담은 각 경매회차별로관리하기 위해 actn_cnt경매회차 추가
	*/
	public int insPer_talk(Offls_per_talkBean per_talk){
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = "";

		query = "INSERT INTO per_talk(car_mng_id, actn_cnt, seq, cust_pr, ama_pr, reason) values(?,?,?,?,?,?) ";

		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,per_talk.getCar_mng_id());
			pstmt.setString(2,per_talk.getActn_cnt());
			pstmt.setString(3,per_talk.getSeq());
			pstmt.setInt(4,per_talk.getCust_pr());
			pstmt.setInt(5,per_talk.getAma_pr());
			pstmt.setString(6,per_talk.getReason());			
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		}catch(SQLException e){
			System.out.println("[Offls_actnDatabase:updPer_talk(Offls_per_talkBean per_talk)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}		
	}

	/**
	*	매각진행차량 개별상담 낙찰시 - 2003.3.28.Fri.
	*	- 1.먼저 새로운 경매레코드(낙찰된 레코드) 생성하고, -->페기
	*	- 2.개별상담에서 고객제시액,아마존카액 등을 생성하고, -->폐기
	*	- 3.기존 개별상담하던 레코드는 유찰상태로 바꾼다. --폐기
	*	- 2003.4.29.Tue. nak_yn칼럼생성후, 낙찰시 'Y'로 등록하고 조회시 이용한다.
	*/
	public int insPer_talk2(Offls_per_talkBean per_talk){
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = "";

		query = "INSERT INTO per_talk(car_mng_id, actn_cnt, seq, cust_pr, ama_pr, reason, nak_yn) "+
				"VALUES(?,?,?,?,?,?,'Y') ";
		
		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,per_talk.getCar_mng_id());
			pstmt.setString(2,per_talk.getActn_cnt());
			pstmt.setString(3,per_talk.getSeq());
			pstmt.setInt(4,per_talk.getCust_pr());
			pstmt.setInt(5,per_talk.getAma_pr());
			pstmt.setString(6,per_talk.getReason());
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
				
		}catch(SQLException e){
			System.out.println("[Offls_actnDatabase:insPer_talk2(Offls_per_talkBean per_talk)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}
	}

	/**
	*	매각진행차량 개별상담 존재여부 - 2003.4.3.Thu.
	*/
	public String existsCar_mng_id(String car_mng_id, String actn_cnt){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String per_id = "";
		String query = "";

		query = "SELECT car_mng_id FROM per_talk WHERE car_mng_id='"+car_mng_id+"' AND actn_cnt='"+actn_cnt+"'";

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while(rs.next()){
				per_id = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_actnDatabase:existsCar_mng_id(String car_mng_id, String actn_cnt)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return per_id;
		}		
	}
	/**
	*	경매장명 찾기 - 2003.4.26.Sat.
	*/
	public String getActn_nm(String client_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String actn_nm = "";
		String query = "";

		query = "SELECT firm_nm FROM client WHERE client_id=?";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,client_id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				actn_nm = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_actnDatabase:existsCar_mng_id(String car_mng_id, String actn_cnt)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return actn_nm;
		}		
	}

	/**
	*	반출상태  - 2003.4.28.Mon.
	*/
	public String getBan_chk(String car_mng_id, String actn_cnt){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String ban_chk = "";
		String query = "";

		query = "SELECT ban_chk FROM auction_ban WHERE car_mng_id=? AND actn_cnt=?";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
			pstmt.setString(2,actn_cnt);
			rs = pstmt.executeQuery();
			while(rs.next()){
				ban_chk = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt.close();

		}catch(SQLException e){
			System.out.println("[Offls_actnDatabase:getBan_chk(String car_mng_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return ban_chk;
		}		
	}
	
	
	/**
	*	경매관리 Bean에 데이터 넣기 2003.4.25.Fri.
	*/
	 private Offls_car_purBean makeAuctionPur(ResultSet results) throws DatabaseException {

        try {
            Offls_car_purBean bean = new Offls_car_purBean();

			bean.setCar_mng_id(results.getString("CAR_MNG_ID"));			//자동차관리번호
			bean.setSeq(results.getString("SEQ"));
			bean.setRent_mng_id(results.getString("RENT_MNG_ID"));
			bean.setRent_l_cd(results.getString("RENT_L_CD"));
			bean.setRpt_no(results.getString("RPT_NO"));
			bean.setCar_no(results.getString("CAR_NO"));
			bean.setDlv_dt(results.getString("DLV_DT"));
			bean.setIp_dt(results.getString("IP_DT"));
			bean.setCar_off_nm(results.getString("CAR_OFF_NM"));
			bean.setEmp_id(results.getString("EMP_ID"));
			bean.setEmp_nm(results.getString("EMP_NM"));
		

		return bean;

        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}



	/* 경매 출고매핑 */
	public Offls_car_purBean[] getOfflsCarpur(String car_mng_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		Collection<Offls_car_purBean> col = new ArrayList<Offls_car_purBean>();

		query = "SELECT car_mng_id, seq, rent_mng_id, rent_l_cd, rpt_no, car_no, dlv_dt, ip_dt, end_st, car_off_nm, emp_id, emp_nm "+
				"FROM auction_pur WHERE car_mng_id = ? "+
				" ORDER BY seq desc ";
		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				col.add(makeAuctionPur(rs));
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_car_purBean:getOfflsCarpur(String car_mng_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return (Offls_car_purBean[])col.toArray(new Offls_car_purBean[0]);
		}		
	}
	
	/**
	*	출고차량매핑 - 
	*/
	public String getAuctionPur_maxSeq(String car_mng_id){
		getConnection();
		String seq = "01";
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = "SELECT a.seq SEQ "+
				"FROM auction_pur a "+
				"WHERE a.seq = (select max(seq) from auction_pur where car_mng_id = a.car_mng_id) "+
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
			System.out.println("[Offls_actnDatabase:getAuctionPur_maxSeq(String car_mng_id)]"+e);
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
	*	출고차량매핑 조회 -.
	*/
	public Offls_car_purBean getAuctionPur(String car_mng_id, String seq){
		getConnection();
		Offls_car_purBean auction = new Offls_car_purBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = "SELECT car_mng_id, seq, rent_mng_id, rent_l_cd, rpt_no, car_no, dlv_dt, ip_dt , car_off_nm, emp_id, emp_nm "+
				"FROM auction_pur WHERE car_mng_id = ? AND seq = ? ";
		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
			pstmt.setString(2,seq);
			rs = pstmt.executeQuery();
			while(rs.next()){
				auction = makeAuctionPur(rs);				
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_actnDatabase:getAuctionPur(String car_mng_id, String seq)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return auction;
		}		
	}

	/**
	*	출고차량매핑 경매관리 입력- 	
	*/
	public int insAuctionPur(Offls_car_purBean auction){
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = "";

		query = "INSERT INTO auction_pur(car_mng_id, seq, rent_mng_id, rent_l_cd, rpt_no, car_no, dlv_dt, reg_dt, car_off_nm, emp_id, emp_nm ) "+
				" SELECT ?, nvl(lpad(max(seq)+1,2,'0'),'01'),?,?,?,?,?, to_char(sysdate,'YYYYMMdd'), ?, ?, ? FROM auction_pur WHERE car_mng_id = ? ";

		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, auction.getCar_mng_id());
			pstmt.setString(2,auction.getRent_mng_id());
			pstmt.setString(3,auction.getRent_l_cd());
			pstmt.setString(4,auction.getRpt_no());
			pstmt.setString(5,auction.getCar_no());
			pstmt.setString(6, auction.getDlv_dt());
			pstmt.setString(7, auction.getCar_off_nm());
			pstmt.setString(8, auction.getEmp_id());
			pstmt.setString(9, auction.getEmp_nm());
			pstmt.setString(10, auction.getCar_mng_id());			
					
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		}catch(SQLException e){
			System.out.println("[Offls_actnDatabase:insAuctionPur(Offls_car_purBean auction)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}
	}
	
	/**
	*	출고차량매핑 경매관리 수정2 - 2003.4.23.Wed.
	*	- 상품관리에서 call
	*/
	public int updAuction2Pur(Offls_car_purBean auction){
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = "";

		query = "UPDATE auction_pur "+
			"SET rent_mng_id=?, rent_l_cd=?, rpt_no=?, car_no = ?, dlv_dt = ?, upd_dt = to_char(sysdate,'YYYYMMdd'), car_off_nm = ?, emp_id = ? , emp_nm = ?  "+
			"WHERE car_mng_id=? AND seq=? ";

		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,auction.getRent_mng_id());
			pstmt.setString(2,auction.getRent_l_cd());
			pstmt.setString(3,auction.getRpt_no());
			pstmt.setString(4,auction.getCar_no());
			pstmt.setString(5,auction.getDlv_dt());
			pstmt.setString(6,auction.getCar_off_nm());
			pstmt.setString(7,auction.getEmp_id());
			pstmt.setString(8,auction.getEmp_nm());
			pstmt.setString(9,auction.getCar_mng_id());
			pstmt.setString(10,this.getAuctionPur_maxSeq(auction.getCar_mng_id()));
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
				
		}catch(SQLException e){
			System.out.println("[Offls_actnDatabase:updAuction2Pur(Offls_car_purBean auction)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}		
	}

	/**
	*	차량출고매핑 데이터 존재 여부 - 2003.04.22.Tue.
	*	- 등록,수정버튼 구분하기위해
	*/
	public String getAuction_Pur_Car_mng_id(String car_mng_id){

		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String auction_pur_car_mng_id = "";
		String query = "SELECT car_mng_id FROM auction_pur WHERE car_mng_id=? AND seq=?";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
			pstmt.setString(2,this.getAuctionPur_maxSeq(car_mng_id));
			rs = pstmt.executeQuery();
			while(rs.next()){
				auction_pur_car_mng_id = rs.getString(1);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Offls_actnDatabase:getAuction_Pur_Car_mng_id(String car_mng_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return auction_pur_car_mng_id;
		}
	}
	
	 /**
     * 경매출고현황
     *  5:출고지점
     */
    public Vector getAucPurDlvStats(String s_kd, String t_wd, String dt, String t_st_dt, String t_end_dt)
    {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String sub_query = "";
		
	if(dt.equals("0"))       sub_query +=" actn_dt like to_char(sysdate,'YYYYMM')||'%' and actn_dt <= to_char(sysdate,'yyyymmdd') ";
	else if(dt.equals("1"))	 sub_query +=" actn_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' ";
	else if(dt.equals("2"))  sub_query +=" actn_dt like to_char(sysdate,'YYYYMM')||'%' and actn_dt <= to_char(sysdate,'yyyymmdd')  ";
	else if(dt.equals("3"))  sub_query +=" actn_dt between replace(" + t_st_dt + ",'-','') and replace(" + t_end_dt + ",'-','') ";
		
		
		String query = " select b.car_mng_id, b.rpt_no, b.car_no, b.emp_nm, b.car_off_nm, c.firm_nm, s.actn_wh, r.car_no acn_car_no, r.car_nm acn_car_nm,  cr.car_nm , \n"+
					   " decode(b.dlv_dt, '', '', substr(b.dlv_dt, 1, 4)||'-'||substr(b.dlv_dt, 5, 2)||'-'||substr(b.dlv_dt, 7, 2)) dlv_dt, \n"+
					   " decode(a.actn_dt, '', '', substr(a.actn_dt, 1, 4)||'-'||substr(a.actn_dt, 5, 2)||'-'||substr(a.actn_dt, 7, 2)) actn_dt, \n"+
					   " a.actn_cnt, to_number(a.seq) seq  , decode(a.seq , '01', 80000, '02', 70000, 0 ) c_amt, s.apprsl_dt  \n"+
			           "   from auction a,  AUCTION_PUR b, apprsl s, client c, car_reg r , cont_n_view  v , car_reg  cr ,  \n"+
					   " (SELECT car_mng_id, MAX(seq) seq FROM AUCTION where "+sub_query+" GROUP BY car_mng_id) w  "+
					   "  where s.car_mng_id = r.car_mng_id   \n"+
					   "    and a.car_mng_id = b.car_mng_id and b.car_mng_id = s.car_mng_id   \n"+
					   "    and b.rent_mng_id = v.rent_mng_id and b.rent_l_cd = v.rent_l_cd and v.car_mng_id = cr.car_mng_id(+)   \n"+
					   "    and s.actn_id = c.client_id  ";
   
		if(s_kd.equals("5"))	query += " and nvl(b.car_off_nm, ' ') like '%"+t_wd+"%'";
		
		if(dt.equals("0"))       query +=" and a.actn_dt like to_char(sysdate,'YYYYMM')||'%' and A.actn_dt <= to_char(sysdate,'yyyymmdd') ";
		else if(dt.equals("1"))	 query +=" and a.actn_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' ";
		else if(dt.equals("2"))  query +=" and a.actn_dt like to_char(sysdate,'YYYYMM')||'%' and A.actn_dt <= to_char(sysdate,'yyyymmdd')  ";
		else if(dt.equals("3"))  query +=" and A.actn_dt between replace(" + t_st_dt + ",'-','') and replace(" + t_end_dt + ",'-','') ";
			
		query += " AND a.CAR_MNG_ID = w.car_mng_id AND a.SEQ = w.seq AND a.ACTN_ST <> '2' order by a.actn_dt  ";   
  
		try
		{
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
			System.out.println("[Offls_actnDatabase:getAucPurDlvStats]\n"+e);
			System.out.println("[Offls_actnDatabase:getAucPurDlvStats]\n"+query);
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
     * 경매출고현황 - type2
     *  5:출고지점,   dt type 출품일, 경매일, 입금예정일
     */
  
    public Vector getAucPurDlvLists(String s_kd, String t_wd, String dt, String s_year, String s_mon)
    {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		
		
		String query = " select b.car_mng_id, b.rpt_no, b.car_no, b.emp_nm, b.car_off_nm, c.firm_nm, s.actn_wh, r.car_no acn_car_no, r.car_nm acn_car_nm,  cr.car_nm , \n"+
					   " decode(b.dlv_dt, '', '', substr(b.dlv_dt, 1, 4)||'-'||substr(b.dlv_dt, 5, 2)||'-'||substr(b.dlv_dt, 7, 2)) dlv_dt, \n"+
					   " a.actn_dt, nvl(su.jan_pr_dt, su.cont_pr_dt) jan_pr_dt, \n"+
					   " a.actn_cnt, to_number(a.seq) seq  , decode(a.seq , '01', 80000, '02', 70000, 0 ) c_amt , su.ip_est_dt \n"+
			           "   from auction a,  AUCTION_PUR b, apprsl s, client c, car_reg r , cont_n_view  v , sui su, car_reg cr  \n"+
					   "  where s.car_mng_id = r.car_mng_id   \n"+
					   "    and a.car_mng_id = b.car_mng_id and b.car_mng_id = s.car_mng_id   \n"+
					   "    and b.rent_mng_id = v.rent_mng_id and b.rent_l_cd = v.rent_l_cd and v.car_mng_id = cr.car_mng_id(+) \n"+
					   "    and s.actn_id = c.client_id  and s.car_mng_id = su.car_mng_id(+) and a.actn_st = '4' ";
   
  	 	if(s_kd.equals("1"))		query += " and a.actn_cnt like '%"+t_wd+"%'";
		else if(s_kd.equals("5"))	query += " and nvl(b.car_off_nm, ' ') like '%"+t_wd+"%'";
		
		if(dt.equals("jan_pr_dt"))  query +=" and nvl(su.jan_pr_dt, su.cont_pr_dt) like '" + s_year + s_mon+"%'";
		else if(dt.equals("actn_dt"))  query +=" and a.actn_dt like '" + s_year + s_mon+"%'";
		else if(dt.equals("ip_est_dt"))  query +=" and a.seq in ('01', '02') and su.ip_est_dt like '" + s_year + s_mon+"%'";
			
		query += " order by a.actn_dt  ";   
  
		try
		{
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
			System.out.println("[Offls_actnDatabase:getAucPurDlvStats]\n"+e);
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
   
    	
    	
    public String getSuiCommDay(String actn_dt)  
    {
		getConnection();
       
     	String sResult = "";
		CallableStatement cstmt = null;
		       		            		                
        
       try{
         
	            cstmt = conn.prepareCall("{ ? =  call F_getSuiDay( ? ) }");
	
				cstmt.registerOutParameter( 1, java.sql.Types.VARCHAR );			
			    cstmt.setString(2, actn_dt );
	     	           
	           	cstmt.execute();
	           	sResult = cstmt.getString(1); // 결과값
	           	cstmt.close();			

       } catch (SQLException e) {
			System.out.println("[Offls_actnDatabase:getSuiCommDay]\n"+e);
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
     * 경매출고월별현황 - type2 
     *  5:출고지점,   dt type 출품일, 경매일, 입금예정일
     */
  
    public Vector getAucPurMonLists(String s_kd, String t_wd, String dt, String s_year)
    {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();		
	    String sub1_query = "";	
	    String sub2_query = "";	
	    String sub3_query = "";	
		
		if(dt.equals("actn_dt"))  {
			sub1_query =" substr(a1.actn_dt,5,2) ";
			sub2_query =" and a.actn_dt like '" + s_year +"%'";
		}else if(dt.equals("ip_est_dt"))  {
			sub1_query =" substr(a1.ip_est_dt,5,2) ";
			sub2_query =" and su.ip_est_dt like '" + s_year +"%'";
		}
		
  	 	if(s_kd.equals("1"))		sub3_query = " and a.actn_cnt like '%"+t_wd+"%'";
		else if(s_kd.equals("5"))	sub3_query = " and nvl(b.car_off_nm, ' ') like '%"+t_wd+"%'";
			
	
			String query = "select " + sub1_query + " mon ,  count(a1.car_no) t_cnt , sum(decode(a1.actn_st, '4', a1.y_cnt, 0)  ) y_cnt,   \n"+
					   "		sum(decode(a1.actn_st, '4', a1.c_cnt, 0)) c_cnt, sum(decode(a1.actn_st, '4', a1.c_amt, 0) ) c_amt, sum(decode(a1.actn_st, '4', a1.c_amt, 0) ) *0.75*1.1 c_amt_l from (   \n"+
					   "		select r.car_no,  a.actn_dt, su.ip_est_dt, a.actn_st, decode(nvl(su.jan_pr_dt, su.cont_pr_dt), '', 0, null, 0, 1 ) y_cnt ,  \n"+
					   "		 a.actn_cnt, to_number(a.seq) seq  , decode(a.seq , '01', 80000, '02', 70000, 0 ) c_amt,   decode(a.seq , '01', 1, '02', 1, 0 ) c_cnt    \n"+
					   "		   from auction a,  AUCTION_PUR b, apprsl s, client c, car_reg r, sui su , ( select car_mng_id, max(seq) seq from auction group by car_mng_id ) a1  \n"+
					   "   where s.car_mng_id = r.car_mng_id    \n"+
				       "            and a.car_mng_id = b.car_mng_id and b.car_mng_id = s.car_mng_id    \n"+
					   "		    and a.car_mng_id = a1.car_mng_id and a.seq = a1.seq and a.car_mng_id = r.car_mng_id and s.actn_id = '000502' and a.actn_st <> '0'  \n"+
					   "		    and s.actn_id = c.client_id  and s.car_mng_id = su.car_mng_id(+)  " + sub2_query +  " \n"+		
					   "    " + sub3_query +  " \n"+				    
					   "		 ) a1  \n"+
					   "		 group by " + sub1_query ;
					   		 		
   
		query += " order by 1 ";   
    	  		
		try
		{
				
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
			System.out.println("[Offls_actnDatabase:getAucPurMonLists]\n"+e);
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
	 *	차량령계산-출품현황에 표시
	 */
	public Hashtable getCar_old(String init_reg_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " SELECT TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(REPLACE('"+init_reg_dt+"','-',''), 'YYYYMMDD'))/12) YEAR, "+
				" TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(REPLACE('"+init_reg_dt+"','-',''), 'YYYYMMDD')) - TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(REPLACE('"+init_reg_dt+"','-',''), 'YYYYMMDD'))/12) * 12) MONTH "+
				" FROM dual ";

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
			System.out.println("[ResSearchDatabase:getCar_old]"+e);
			System.out.println("[ResSearchDatabase:getCar_old]"+query);
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



//모바일 경매현황보기  - 20160811 :  경매일자 기준에서 세금계산서일자로 변경 
	public Vector  AuctionMobileList(String s_yy, String s_mm, String iw)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";		
		String search = "";

		query = " SELECT (s.COMM1_SUP + s.COMM1_VAT) COMM1_TOT, fa.get_date, fm.sale_amt,  \n" +
				" CASE WHEN fm.assch_rmk LIKE '%폐%'  THEN '폐차'  ELSE fm.assch_rmk  END assch_rmk , \n" + 
				" fya.gisu, fya.get_amt, fya.book_dr, fya.book_cr, fya.jun_reser, fya.dep_amt, nvl(yg.gdep_amt,0)  gdep_amt, \n " +
				"  s.COMM2_TOT, s.COMM3_TOT, c.car_no, c.car_nm, a.*, b.ACTN_ID,  TO_CHAR(TO_DATE(a.ACTN_DT),'W') AS  iw , \n" +
				" case when nvl(fm.s_sup_amt, 0)  > 0 then fm.s_sup_amt else  case when fm.assch_rmk like '%폐%' then fm.sale_amt  when fm.assch_rmk like '%매각%' then nvl(fm.s_sup_amt ,  round(fm.sale_amt/1.1) )   when fm.assch_rmk like '%매입옵션%' then nvl(fm.s_sup_amt, round(fm.sale_amt/1.1) )   else 0 end end sup_amt  \n"+
				" FROM AUCTION a, APPRSL b, CAR_REG c, SUI_ETC s,  fassetma fa, fassetmove fm,  \n"+
				"      ( select	a.* from  fyassetdep a, (select asset_code, max(gisu) gisu from fyassetdep group by asset_code) b where a.asset_code = b.asset_code and a.gisu = b.gisu ) fya ,   \n"+   
                "      ( select a.* from  fyassetdep_green  a, (select asset_code, max(gisu) gisu from fyassetdep_green  group by asset_code) b where a.asset_code = b.asset_code and a.gisu = b.gisu ) yg   \n"+   
		   	    "  WHERE a.CAR_MNG_ID = b.CAR_MNG_ID  AND a.CAR_MNG_ID = c.CAR_MNG_ID  AND a.CAR_MNG_ID = s.CAR_MNG_ID  \n" +
				" AND a.ACTN_ST='4' and a.actn_dt like '"+s_yy+s_mm+"%'  \n" +
				" AND fa.asset_code = fya.asset_code  and fa.asset_code = yg.asset_code(+)  AND fa.asset_code = fm.asset_code AND fm.assch_type = '3'  \n"+
			    " AND fa.car_mng_id = c.car_mng_id(+)  \n"+
				"  \n";

		if(iw.equals("1")||iw.equals("2")||iw.equals("3")||iw.equals("4")||iw.equals("5")){ //1~5주차
			query += " AND  TO_CHAR(TO_DATE(a.actn_dt),'W') = '"+iw+"' "; 
		}else if(iw.equals("6")){ // 금주
			query += " AND a.actn_dt  BETWEEN TRUNC(SYSDATE+1)-TO_CHAR(SYSDATE,'D') AND  TRUNC(SYSDATE+1)-TO_CHAR(SYSDATE,'D')+6.99999421 ";
		}

			query += " ORDER BY fm.ASSCH_DATE ";

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
			System.out.println("[AssetDatabase:AuctionMobileList]\n"+e);
			System.out.println("[AssetDatabase:AuctionMobileList]\n"+query);
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

	//반출처리
	public int cancelOffls_actn(String car_mng_id, String seq, String next_seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		int result = 0;

		//car_reg update 매각준비
		String query1  = "update car_reg set off_ls='1' where car_mng_id=?";
		//auction update 반출처리
		String query2  = "update auction set choi_st='2' where car_mng_id=? and seq=?";
		//auction insert 다음경매
		String query3  = "insert into auction (car_mng_id, seq) values (?,?)";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query1);
			pstmt.setString(1, car_mng_id);
		    pstmt.executeUpdate();
			pstmt.close();

			pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString(1, car_mng_id);
			pstmt2.setString(2, seq);
		    pstmt2.executeUpdate();
			pstmt2.close();

			pstmt3 = conn.prepareStatement(query3);
			pstmt3.setString(1, car_mng_id);
			pstmt3.setString(2, next_seq);
		    pstmt3.executeUpdate();
			pstmt3.close();

	  		result = 1;
			
			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[Offls_actnDatabase:cancelOffls_actn]\n"+e);
			System.out.println("[Offls_actnDatabase:cancelOffls_actn] car_mng_id = "+car_mng_id);
			System.out.println("[Offls_actnDatabase:cancelOffls_actn] seq = "+seq);
			System.out.println("[Offls_actnDatabase:cancelOffls_actn] next_seq = "+next_seq);
	  		e.printStackTrace();
			result = 0;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
				if(pstmt2 != null)	pstmt2.close();
				if(pstmt3 != null)	pstmt3.close();
			}catch(Exception ignore){}
			closeConnection();
			return result;
		}
	}	

	// 경매일자, 경매회차 수정 (2017.12.13)
	public int updAuctCntDt(String car_mng_id, String seq, String actn_cnt, String actn_dt, String user_id){
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = "";

		query = " UPDATE auction "+
				"    SET actn_cnt=?, actn_dt=?, modify_id=?, actn_st = '1' "+
				"  WHERE car_mng_id=? AND seq=? ";
		try{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, actn_cnt);
			pstmt.setString(2, actn_dt);
			pstmt.setString(3, user_id);
			pstmt.setString(4, car_mng_id);
			pstmt.setString(5, seq);
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		}catch(SQLException e){
			System.out.println("[Offls_actnDatabase:updAuctCntDt]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return result;
		}		
	}

}