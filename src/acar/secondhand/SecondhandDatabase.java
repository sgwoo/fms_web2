/**
 * �縮�� ���� ����
 * @ author : Yongsoon Kwon
 * @ e-mail :
 * @ create date : 2004. 12. 8. Wed.
 * @ last modify date :
 */
package acar.secondhand;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Hashtable;
import java.util.Vector;

import acar.database.DBConnectionManager;
import acar.exception.DatabaseException;
import acar.offls_yb.Offls_ybBean;
import acar.offls_yb.Offls_ybDatabase;
import acar.util.AddUtil;

public class SecondhandDatabase
{
	private Connection conn = null;
	public static SecondhandDatabase db;

	public static SecondhandDatabase getInstance()
	{
		if(SecondhandDatabase.db == null)
			SecondhandDatabase.db = new SecondhandDatabase();
		return SecondhandDatabase.db;
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
	*	������������ �縮�� �������� 2004.12.8.Wed.
	*/
	public int setSecondhand(String[] car){
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = "UPDATE car_reg SET prepare='1', secondhand = '1', secondhand_dt='"+AddUtil.getDate(4)+"' WHERE car_mng_id in ('";
		
		for(int i=0 ; i<car.length ; i++){
			if(i == (car.length -1))	query += car[i];
			else						query += car[i]+"', '";
		}
		query+="')";

		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		}catch(SQLException e){
            try{
				System.out.println("[SecondhandDatabase:setSecondhand(String[] car)]"+e);
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
	*	�縮�� ������ �ٽ� �������� 2004.12.8.Wed.
	*/
	public int cancelSecondhand(String[] car){
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = "UPDATE car_reg SET secondhand = '' WHERE car_mng_id in ('";

		for(int i=0 ; i<car.length ; i++){
			if(i == (car.length -1))	query += car[i];
			else						query += car[i]+"', '";
		}
		query += "')";

		try{

			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		}catch(SQLException e){
            try{
				System.out.println("[SecondhandDatabase:cancelSecondhand(String[] car)]"+e);
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
	*	�縮���� ������ �ֱ� 2004.12.14. ȭ.
	*/
	 private SecondhandBean makeSecondhandBean(ResultSet results) throws DatabaseException {

        try {
            SecondhandBean bean = new SecondhandBean();

		    bean.setCar_mng_id(results.getString("CAR_MNG_ID"));
			bean.setSeq(results.getString("SEQ"));
			bean.setBase_sh_pr(results.getInt("BASE_SH_PR"));
			bean.setBase_sh_dt(results.getString("BASE_SH_DT"));
			bean.setApply_sh_dt(results.getString("APPLY_SH_DT"));
			bean.setReal_km(results.getString("REAL_KM"));
			bean.setApply_sh_pr(results.getInt("APPLY_SH_PR"));
			bean.setReg_id(results.getString("REG_ID"));
			bean.setReg_dt(results.getString("REG_DT"));
			bean.setUpd_id(results.getString("UPD_ID"));
			bean.setUpd_dt(results.getString("UPD_DT"));
			bean.setLs18(results.getInt("LS18"));
			bean.setLs24(results.getInt("LS24"));
			bean.setLs36(results.getInt("LS36"));
			bean.setLb24(results.getInt("LB24"));
			bean.setLb36(results.getInt("LB36"));
			bean.setRs12(results.getInt("RS12"));
			bean.setRs24(results.getInt("RS24"));
			bean.setRs36(results.getInt("RS36"));
			bean.setRb24(results.getInt("RB24"));
			bean.setRb36(results.getInt("RB36"));
			bean.setUpload_id(results.getString("UPLOAD_ID"));
			bean.setUpload_dt(results.getString("UPLOAD_DT"));


			return bean;

        }catch (SQLException e) {
			System.out.println("[SecondhanDatabase:makeSecondhandBean(ResultSet results)]"+e);
            throw new DatabaseException(e.getMessage());
        }
	}

	/**
	*	�縮�� ���� �˻� - 2004.12.9.��.
	*	- gubun : ������ȣ, ������, ���ʵ����
	*	- gubun_nm : �ش� ����Ÿ
	*/
	public Offls_ybBean[] getSecondhandList(String gubun, String gubun_nm, String brch_id, String sort_gubun){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String subQuery = "";
		Offls_ybDatabase oldb = Offls_ybDatabase.getInstance();

		if(gubun.equals("car_no")){
			subQuery = " and ca.car_no like '%" + gubun_nm + "%'";
		}else if(gubun.equals("car_nm")){
			subQuery = " and r.car_nm like '%" + gubun_nm.toUpperCase() + "%'";
		}else if(gubun.equals("init_reg_dt")){
			subQuery = " and r.init_reg_dt like replace('"+ gubun_nm +"','-','')||'%'";
		}

		if(!brch_id.equals(""))	subQuery += " and c.brch_id='"+brch_id+"'";

		//����
		subQuery += " ORDER BY situation desc";
		if(sort_gubun.equals("car_nm"))				subQuery += ", CAR_JNM, CAR_NM ";
		else if(sort_gubun.equals("car_no"))		subQuery += ", CAR_NO ";
		else if(sort_gubun.equals("init_reg_dt"))	subQuery += ", INIT_REG_DT DESC ";
		else if(sort_gubun.equals("fuel_kd"))		subQuery += ", FUEL_KD, CAR_JNM, CAR_NM  ";
		else if(sort_gubun.equals("dpm"))			subQuery += ", FUEL_KD, DPM DESC, CAR_JNM, CAR_NM  ";
		else										subQuery += ", FUEL_KD, DPM DESC, CAR_JNM, CAR_NM  ";

		if(gubun.equals("car_no")){
		query = "select	r.car_mng_id CAR_MNG_ID, r.car_no CAR_NO, r.car_num CAR_NUM, r.init_reg_dt	INIT_REG_DT, r.car_kd CAR_KD, r.car_use	CAR_USE, n.car_nm CAR_JNM, m.car_name CAR_NM, r.car_form CAR_FORM, r.car_y_form	CAR_Y_FORM,	r.dpm			DPM,	r.fuel_kd		FUEL_KD,	r.maint_st_dt	MAINT_ST_DT,	r.maint_end_dt	MAINT_END_DT, r.test_st_dt TEST_ST_DT, r.test_end_dt TEST_END_DT, r.car_l_cd, CAR_L_CD, r.prepare, e.rent_mng_id	RENT_MNG_ID,	e.rent_l_cd		RENT_L_CD,	e.car_id		CAR_ID,	e.colo			COLO, e.opt			OPT,	e.car_cs_amt	CAR_CS_AMT,	e.car_cv_amt	CAR_CV_AMT,	e.car_fs_amt	CAR_FS_AMT,	e.car_fv_amt	CAR_FV_AMT,	e.opt_cs_amt	OPT_CS_AMT,	e.opt_cv_amt	OPT_CV_AMT,	e.opt_fs_amt	OPT_FS_AMT,	e.opt_fv_amt	OPT_FV_AMT,	e.clr_cs_amt	CLR_CS_AMT,	e.clr_cv_amt	CLR_CV_AMT,	e.clr_fs_amt	CLR_FS_AMT,	e.clr_fv_amt	CLR_FV_AMT,	e.sd_cs_amt		SD_CS_AMT,	e.sd_cv_amt		SD_CV_AMT,	e.sd_fs_amt		SD_FS_AMT,	e.sd_fv_amt		SD_FV_AMT,	e.dc_cs_amt		DC_CS_AMT,	e.dc_cv_amt		DC_CV_AMT,	e.dc_fs_amt		DC_FS_AMT,	e.dc_fv_amt		DC_FV_AMT, c.mng_id		MNG_ID, c.dlv_dt DLV_DT,	decode(r.car_mng_id, sq.car_mng_id, 1, 0) ACCIDENT_YN, "+
			" vt.tot_dist TOT_DIST, "+
			" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD'))))) as AVERAGE_DIST, "+
			" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST, "+
			" bk.bank_nm BANK_NM, bk.lend_prn LEND_PRN, sw.alt_rest	LEND_REM, bk.alt_end_dt ALT_END_DT, s.lev LEV, s.reason REASON, s.car_st CAR_ST, s.imgfile1 IMGFILE1, s.imgfile2 IMGFILE2, s.imgfile3 IMGFILE3, s.imgfile4 IMGFILE4, s.imgfile5 IMGFILE5, s.damdang_id DAMDANG_ID, s.modify_id MODIFY_ID, s.apprsl_dt APPRSL_DT, DECODE(r.car_mng_id, ch.car_mng_id, 1, 0) CAR_CHA_YN "+
			", iu.ins_com_nm INS_COM_NM, iu.ins_exp_dt INS_EXP_DT, s.driver DRIVER "+
			", decode(rc.rent_st,'1','�ܱ�뿩','2','�������','3','������','9','�������','10','��������','4','�����뿩','5','�����뿩','6','��������','7','��������','8','������','11','������','12','����Ʈ') rent_st_nm "+
			", rc.rent_start_dt, rc.rent_end_dt, rc.deli_plan_dt, rc.ret_plan_dt, sr.situation, r.secondhand "+
			" from car_reg r, car_etc e, cont c, apprsl s, CAR_NM m, CAR_MNG n, v_tot_dist vt, "+
			"	(select * from sh_res a where a.seq = (select max(seq) from sh_res where car_mng_id = a.car_mng_id) ) sr, "+
			" 	(select * from secondhand a where a.seq = (select max(seq) from secondhand where car_mng_id=a.car_mng_id) ) sh, "+
			"   (select distinct ac.car_mng_id CAR_MNG_ID from accident ac, car_reg re where ac.car_mng_id=re.car_mng_id) sq, "+
			"	(select a.car_mng_id CAR_MNG_ID, a.serv_dt SERV_DT, a.tot_dist TOT_DIST  from service a where a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where car_mng_id = a.car_mng_id)) i, "+
			"	(select al.rent_mng_id RENT_MNG_ID, al.rent_l_cd RENT_L_CD, cd.nm BANK_NM, al.lend_prn LEND_PRN, al.alt_end_dt ALT_END_DT from allot al, code cd where al.cpt_cd = cd.code and cd.c_st = '0003') bk, "+
			"	(SELECT DISTINCT cc.car_mng_id CAR_MNG_ID FROM car_cha cc, car_reg re WHERE cc.car_mng_id = re.car_mng_id) ch, "+
			"	(SELECT sc.car_mng_id CAR_MNG_ID, sc.alt_rest ALT_REST FROM scd_alt_case sc WHERE sc.pay_dt = (select max(pay_dt) from scd_alt_case where car_mng_id = sc.car_mng_id)) sw "+
			", (select ir.car_mng_id CAR_MNG_ID, ic.ins_com_nm INS_COM_NM, ir.ins_exp_dt INS_EXP_DT from insur ir, ins_com ic where ir.ins_com_id = ic.ins_com_id and ir.ins_st = (select max(ins_st) from insur where car_mng_id = ir.car_mng_id)) iu "+
			", (select a.car_mng_id CAR_MNG_ID, a.car_no CAR_NO FROM car_change a, car_reg b WHERE a.car_mng_id =b.car_mng_id) ca "+
			", (select * from RENT_CONT a where a.rent_s_cd = (select max(rent_s_cd) from RENT_CONT where car_mng_id = a.car_mng_id)) rc "+
			" where r.car_mng_id = c.car_mng_id "+
			"  and e.rent_mng_id = c.rent_mng_id "+
			"  and e.rent_l_cd = c.rent_l_cd "+
			"  and r.car_mng_id = sq.car_mng_id(+) "+
			"  and c.car_st = '2' "+
			"  and c.use_yn = 'Y' "+
			"  and r.off_ls ='0' "+
			"  and r.secondhand = '1' "+
			"  and r.car_mng_id = i.car_mng_id(+) "+
			"  and c.rent_mng_id = bk.rent_mng_id(+) "+
			"  and c.rent_l_cd = bk.rent_l_cd(+) "+
			"  and r.car_mng_id = s.car_mng_id(+) "+
			"  and r.car_mng_id = ch.car_mng_id(+) "+
			"  AND r.car_mng_id = sw.car_mng_id(+) "+
			" and r.car_mng_id = iu.car_mng_id(+) "+
			" AND r.car_mng_id = ca.car_mng_id(+) "+
			" AND e.car_id = m.car_id "+
			" and e.car_seq = m.car_seq "+
			" and m.car_comp_id = n.car_comp_id "+
			" and m.car_cd = n.code "+
			" and r.car_mng_id = vt.car_mng_id(+) "+
			" and r.car_mng_id = sh.car_mng_id(+) "+
			" and r.car_mng_id = rc.car_mng_id(+) "+
			" and r.car_mng_id = sr.car_mng_id(+) "+

			subQuery;
		}else{
			query = "select	r.car_mng_id CAR_MNG_ID, r.car_no CAR_NO, r.car_num CAR_NUM, r.init_reg_dt	INIT_REG_DT, r.car_kd CAR_KD, r.car_use	CAR_USE, n.car_nm CAR_JNM,m.car_name	CAR_NM,	r.car_form CAR_FORM, r.car_y_form	CAR_Y_FORM,	r.dpm			DPM,	r.fuel_kd		FUEL_KD,	r.maint_st_dt	MAINT_ST_DT,	r.maint_end_dt	MAINT_END_DT, r.test_st_dt TEST_ST_DT, r.test_end_dt TEST_END_DT, r.car_l_cd, CAR_L_CD, r.prepare, e.rent_mng_id	RENT_MNG_ID,	e.rent_l_cd		RENT_L_CD,	e.car_id		CAR_ID,	e.colo			COLO, e.opt			OPT,	e.car_cs_amt	CAR_CS_AMT,	e.car_cv_amt	CAR_CV_AMT,	e.car_fs_amt	CAR_FS_AMT,	e.car_fv_amt	CAR_FV_AMT,	e.opt_cs_amt	OPT_CS_AMT,	e.opt_cv_amt	OPT_CV_AMT,	e.opt_fs_amt	OPT_FS_AMT,	e.opt_fv_amt	OPT_FV_AMT,	e.clr_cs_amt	CLR_CS_AMT,	e.clr_cv_amt	CLR_CV_AMT,	e.clr_fs_amt	CLR_FS_AMT,	e.clr_fv_amt	CLR_FV_AMT,	e.sd_cs_amt		SD_CS_AMT,	e.sd_cv_amt		SD_CV_AMT,	e.sd_fs_amt		SD_FS_AMT,	e.sd_fv_amt		SD_FV_AMT,	e.dc_cs_amt		DC_CS_AMT,	e.dc_cv_amt		DC_CV_AMT,	e.dc_fs_amt		DC_FS_AMT,	e.dc_fv_amt		DC_FV_AMT, c.mng_id		MNG_ID, c.dlv_dt DLV_DT,	decode(r.car_mng_id, sq.car_mng_id, 1, 0) ACCIDENT_YN, "+
			" vt.tot_dist TOT_DIST, "+
			" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD'))))) as AVERAGE_DIST, "+
			" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST, "+
			" bk.bank_nm BANK_NM, bk.lend_prn LEND_PRN, sw.alt_rest	LEND_REM, bk.alt_end_dt ALT_END_DT, s.lev LEV, s.reason REASON, s.car_st CAR_ST, s.imgfile1 IMGFILE1, s.imgfile2 IMGFILE2, s.imgfile3 IMGFILE3, s.imgfile4 IMGFILE4, s.imgfile5 IMGFILE5, s.damdang_id DAMDANG_ID, s.modify_id MODIFY_ID, s.apprsl_dt APPRSL_DT, DECODE(r.car_mng_id, ch.car_mng_id, 1, 0) CAR_CHA_YN "+
			", iu.ins_com_nm INS_COM_NM, iu.ins_exp_dt INS_EXP_DT, s.driver DRIVER "+
			", decode(rc.rent_st,'1','�ܱ�뿩','2','�������','3','������','9','�������','10','��������','4','�����뿩','5','�����뿩','6','��������','7','��������','8','������','11','������','12','����Ʈ') rent_st_nm "+
			", rc.rent_start_dt, rc.rent_end_dt, rc.deli_plan_dt, rc.ret_plan_dt, sr.situation, r.secondhand "+
			" from car_reg r, car_etc e, cont c, apprsl s, CAR_NM m, CAR_MNG n, v_tot_dist vt, "+
			"	(select * from sh_res a where a.seq = (select max(seq) from sh_res where car_mng_id = a.car_mng_id) ) sr, "+
			" 	(select * from secondhand a where a.seq = (select max(seq) from secondhand where car_mng_id=a.car_mng_id) ) sh, "+
			"	(select distinct ac.car_mng_id CAR_MNG_ID from accident ac, car_reg re where ac.car_mng_id=re.car_mng_id) sq, "+
			"	(select a.car_mng_id CAR_MNG_ID, a.serv_dt SERV_DT, a.tot_dist TOT_DIST  from service a where a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where car_mng_id = a.car_mng_id)) i, "+
			"	(select al.rent_mng_id RENT_MNG_ID, al.rent_l_cd RENT_L_CD, cd.nm BANK_NM, al.lend_prn LEND_PRN, al.alt_end_dt ALT_END_DT from allot al, code cd where al.cpt_cd = cd.code and cd.c_st = '0003') bk, "+
			"	(SELECT DISTINCT cc.car_mng_id CAR_MNG_ID FROM car_cha cc, car_reg re WHERE cc.car_mng_id = re.car_mng_id) ch, "+
			"	(SELECT sc.car_mng_id CAR_MNG_ID, sc.alt_rest ALT_REST FROM scd_alt_case sc WHERE sc.pay_dt = (select max(pay_dt) from scd_alt_case where car_mng_id = sc.car_mng_id)) sw "+
			", (select ir.car_mng_id CAR_MNG_ID, ic.ins_com_nm INS_COM_NM, ir.ins_exp_dt INS_EXP_DT from insur ir, ins_com ic where ir.ins_com_id = ic.ins_com_id and ir.ins_st = (select max(ins_st) from insur where car_mng_id = ir.car_mng_id)) iu "+
			", (select * from RENT_CONT a where a.rent_s_cd = (select max(rent_s_cd) from RENT_CONT where car_mng_id = a.car_mng_id)) rc "+
			" where r.car_mng_id = c.car_mng_id "+
			"  and e.rent_mng_id = c.rent_mng_id "+
			"  and e.rent_l_cd = c.rent_l_cd "+
			"  and r.car_mng_id = sq.car_mng_id(+) "+
			"  and c.car_st = '2' "+
			"  and c.use_yn = 'Y' "+
			"  and r.off_ls = '0' "+
			"  and r.secondhand = '1' "+
			"  and r.car_mng_id = i.car_mng_id(+) "+
			"  and c.rent_mng_id = bk.rent_mng_id(+) "+
			"  and c.rent_l_cd = bk.rent_l_cd(+) "+
			"  and r.car_mng_id = s.car_mng_id(+) "+
			"  and r.car_mng_id = ch.car_mng_id(+) "+
			"  AND r.car_mng_id = sw.car_mng_id(+) "+
			"  and r.car_mng_id = iu.car_mng_id(+) "+
			" AND e.car_id = m.car_id "+
			" and e.car_seq = m.car_seq "+
			" and m.car_comp_id = n.car_comp_id "+
			" and m.car_cd = n.code "+
			" and r.car_mng_id = vt.car_mng_id(+) "+
			" and r.car_mng_id = sh.car_mng_id(+) "+
			" and r.car_mng_id = rc.car_mng_id(+) "+
			" and r.car_mng_id = sr.car_mng_id(+) "+
			subQuery;
		}


		Collection<Offls_ybBean> col = new ArrayList<Offls_ybBean>();

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while(rs.next()){
				col.add(oldb.makeOffls_ybBean(rs));
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[SecondhandDatabase:getSecondhandList(String gubun, String gubun_nm)]"+e);
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
	*	�縮�� ���� ������ 2004.12.9. ��.
	*/
	public Offls_ybBean getSecondhandDetail(String car_mng_id){
		getConnection();
		Offls_ybBean detail = new Offls_ybBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		Offls_ybDatabase oldb = Offls_ybDatabase.getInstance();

		query = "select	r.car_mng_id CAR_MNG_ID, r.car_no CAR_NO, r.car_num CAR_NUM, r.init_reg_dt	INIT_REG_DT, r.car_kd CAR_KD, r.car_use	CAR_USE, n.car_nm CAR_JNM, m.car_name	CAR_NM,	r.car_form CAR_FORM, r.car_y_form	CAR_Y_FORM,	r.dpm			DPM,	r.fuel_kd		FUEL_KD,	r.maint_st_dt	MAINT_ST_DT,	r.maint_end_dt	MAINT_END_DT, r.test_st_dt TEST_ST_DT, r.test_end_dt TEST_END_DT, r.car_l_cd CAR_L_CD, r.prepare, e.rent_mng_id	RENT_MNG_ID,	e.rent_l_cd		RENT_L_CD,	e.car_id		CAR_ID,	e.colo			COLO,	e.opt			OPT,	e.car_cs_amt	CAR_CS_AMT,	e.car_cv_amt	CAR_CV_AMT,	e.car_fs_amt	CAR_FS_AMT,	e.car_fv_amt	CAR_FV_AMT,	e.opt_cs_amt	OPT_CS_AMT,	e.opt_cv_amt	OPT_CV_AMT,	e.opt_fs_amt	OPT_FS_AMT,	e.opt_fv_amt	OPT_FV_AMT,	e.clr_cs_amt	CLR_CS_AMT,	e.clr_cv_amt	CLR_CV_AMT,	e.clr_fs_amt	CLR_FS_AMT,	e.clr_fv_amt	CLR_FV_AMT,	e.sd_cs_amt		SD_CS_AMT,	e.sd_cv_amt		SD_CV_AMT,	e.sd_fs_amt		SD_FS_AMT,	e.sd_fv_amt		SD_FV_AMT,	e.dc_cs_amt		DC_CS_AMT,	e.dc_cv_amt		DC_CV_AMT,	e.dc_fs_amt		DC_FS_AMT,	e.dc_fv_amt		DC_FV_AMT, c.mng_id		MNG_ID,	c.dlv_dt DLV_DT, decode(r.car_mng_id, sq.car_mng_id, 1, 0) ACCIDENT_YN, "+
			" vt.tot_dist TOT_DIST, "+
			" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD'))))) as AVERAGE_DIST, "+
			" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(c.dlv_dt,r.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(c.dlv_dt,r.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST, "+
			" bk.bank_nm BANK_NM, bk.lend_prn LEND_PRN, sw.alt_rest	LEND_REM, sc.alt_est_dt ALT_END_DT, s.lev LEV, s.reason REASON, s.car_st CAR_ST,s.imgfile1 IMGFILE1, s.imgfile2 IMGFILE2, s.imgfile3 IMGFILE3, s.imgfile4 IMGFILE4, s.imgfile5 IMGFILE5, s.damdang_id DAMDANG_ID, s.modify_id MODIFY_ID, s.apprsl_dt APPRSL_DT, DECODE(r.car_mng_id, ch.car_mng_id, 1, 0) CAR_CHA_YN "+
			", iu.ins_com_nm INS_COM_NM, iu.ins_exp_dt INS_EXP_DT, s.driver DRIVER, '' RENT_ST_NM, '' RET_PLAN_DT, r.secondhand  "+
			" from car_reg r, car_etc e, cont c, apprsl s, car_nm m, CAR_MNG n, v_tot_dist vt, "+
			"	(select distinct ac.car_mng_id CAR_MNG_ID from accident ac, car_reg re where ac.car_mng_id=re.car_mng_id) sq, "+
			"	(select a.car_mng_id CAR_MNG_ID, a.serv_dt SERV_DT, a.tot_dist TOT_DIST  from service a where a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where car_mng_id = a.car_mng_id)) i, "+
			"	(select al.rent_mng_id RENT_MNG_ID, al.rent_l_cd RENT_L_CD, cd.nm BANK_NM , al.lend_prn LEND_PRN, al.alt_end_dt ALT_END_DT from allot al, code cd where al.cpt_cd = cd.code and cd.c_st = '0003') bk, "+
			"	(SELECT DISTINCT cc.car_mng_id CAR_MNG_ID FROM car_cha cc, car_reg re WHERE cc.car_mng_id = re.car_mng_id) ch, "+
			"	(SELECT sc.car_mng_id CAR_MNG_ID, sc.alt_rest ALT_REST FROM scd_alt_case sc WHERE sc.pay_dt = (select max(pay_dt) from scd_alt_case where car_mng_id = sc.car_mng_id)) sw "+
			", (select ir.car_mng_id CAR_MNG_ID, ic.ins_com_nm INS_COM_NM, ir.ins_exp_dt INS_EXP_DT from insur ir, ins_com ic where ir.ins_com_id = ic.ins_com_id and ir.ins_st = (select max(ins_st) from insur where car_mng_id = ir.car_mng_id)) iu "+
			", (SELECT sc.car_mng_id CAR_MNG_ID, sc.alt_est_dt ALT_EST_DT FROM scd_alt_case sc WHERE sc.alt_est_dt = (select max(alt_est_dt) from scd_alt_case where car_mng_id = sc.car_mng_id)) sc "+
			" where r.car_mng_id = c.car_mng_id "+
			"  and e.rent_mng_id = c.rent_mng_id "+
			"  and e.rent_l_cd = c.rent_l_cd "+
			"  and r.car_mng_id = sq.car_mng_id(+) "+
			"  and c.car_st = '2' "+
			"  and c.use_yn = 'Y' "+
			"  and r.off_ls in ('0','1') "+
			"  and r.secondhand = '1' "+
			"  and r.car_mng_id = i.car_mng_id(+) "+
			"  and c.rent_mng_id = bk.rent_mng_id(+) "+
			"  and c.rent_l_cd = bk.rent_l_cd(+) "+
			"  and r.car_mng_id = s.car_mng_id(+) "+
			"  and r.car_mng_id = ch.car_mng_id(+) "+
			"  AND r.car_mng_id = sw.car_mng_id(+) "+
			"  and r.car_mng_id = iu.car_mng_id(+) "+
			"  and r.car_mng_id = sc.car_mng_id(+) "+
			" AND e.car_id = m.car_id "+
			" and e.car_seq = m.car_seq "+
			" and m.car_comp_id = n.car_comp_id "+
			" and m.car_cd = n.code "+
			" and r.car_mng_id = vt.car_mng_id(+) "+
			"  and r.car_mng_id = '"+car_mng_id+"'";


		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while(rs.next()){
				detail = oldb.makeOffls_ybBean(rs);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[SecondhandDatabase:getSecondhandDetail(String car_mng_id)]"+e);
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
	*	ȸ�纰 ���� ��� - 2004.12.9.
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
				"from car_reg C, cont t, car_etc e, car_nm n, code d, "+
				" 	(select * from secondhand a where a.seq = (select max(seq) from secondhand where car_mng_id=a.car_mng_id) ) sh "+
				"where c.car_mng_id = t.car_mng_id     "+
				"and t.rent_mng_id = e.rent_mng_id     "+
				"and t.rent_l_cd = e.rent_l_cd     "+
				"and  t.car_st='2'     "+
				"and  nvl(t.use_yn,'Y')='Y' "+
				"and t.brch_id like '"+brch_id+"'    "+
				"and c.off_ls = '0'  "+
				"and c.car_mng_id = sh.car_mng_id(+) "+
				"and c.secondhand = '1' "+
				"and e.car_id = n.car_id and e.car_seq=n.car_seq     "+
				"and n.car_comp_id = '0001'     "+
				"and n.car_comp_id = d.code     "+
				"and d.c_st = '0001') hd,     "+
				"(select nvl(sum(decode(C.car_kd, '1', 1, 0)),0) c1, nvl(sum(decode(C.car_kd, '2', 1, 0)),0) c2, nvl(sum(decode(C.car_kd, '3', 1, '9', 1, 0)),0) c3, nvl(sum(decode(C.car_kd, '4', 1, 0)),0) c4, nvl(sum(decode(C.car_kd, '5', 1, 0)),0) c5, nvl(sum(decode(C.car_kd, '6', 1, 0)),0) c6, nvl(sum(decode(C.car_kd, '7', 1, 0)),0) c7 "+
				"from car_reg C, cont t, car_etc e, car_nm n, code d, "+
				" 	(select * from secondhand a where a.seq = (select max(seq) from secondhand where car_mng_id=a.car_mng_id) ) sh "+
				"where c.car_mng_id = t.car_mng_id    "+
				"and t.rent_mng_id = e.rent_mng_id    "+
				"and t.rent_l_cd = e.rent_l_cd   "+
				"and  t.car_st='2'     "+
				"and  nvl(t.use_yn,'Y')='Y'      "+
				"and t.brch_id like '"+brch_id+"' "+
				"and c.off_ls = '0'  "+
				"and c.car_mng_id = sh.car_mng_id(+) "+
				"and c.secondhand = '1' "+
				"and e.car_id = n.car_id and e.car_seq=n.car_seq     "+
				"and n.car_comp_id = '0002'     "+
				"and n.car_comp_id = d.code     "+
				"and d.c_st = '0001') kia,     "+
				"(select nvl(sum(decode(C.car_kd, '1', 1, 0)),0) c1, nvl(sum(decode(C.car_kd, '2', 1, 0)),0) c2, nvl(sum(decode(C.car_kd, '3', 1, '9', 1, 0)),0) c3, nvl(sum(decode(C.car_kd, '4', 1, 0)),0) c4, nvl(sum(decode(C.car_kd, '5', 1, 0)),0) c5, nvl(sum(decode(C.car_kd, '6', 1, 0)),0) c6, nvl(sum(decode(C.car_kd, '7', 1, 0)),0) c7 "+
				"from car_reg C, cont t, car_etc e, car_nm n, code d, "+
				" 	(select * from secondhand a where a.seq = (select max(seq) from secondhand where car_mng_id=a.car_mng_id) ) sh "+
				"where c.car_mng_id = t.car_mng_id   "+
				"and t.rent_mng_id = e.rent_mng_id     "+
				"and t.rent_l_cd = e.rent_l_cd  "+
				"and  t.car_st='2'     "+
				"and  nvl(t.use_yn,'Y')='Y'      "+
				"and t.brch_id like '"+brch_id+"' "+
				"and c.off_ls = '0'  "+
				"and c.car_mng_id = sh.car_mng_id(+) "+
				"and c.secondhand = '1' "+
				"and e.car_id = n.car_id and e.car_seq=n.car_seq     "+
				"and n.car_comp_id = '0003'     "+
				"and n.car_comp_id = d.code     "+
				"and d.c_st = '0001') sam,     "+
				"(select nvl(sum(decode(C.car_kd, '1', 1, 0)),0) c1, nvl(sum(decode(C.car_kd, '2', 1, 0)),0) c2, nvl(sum(decode(C.car_kd, '3', 1, '9', 1, 0)),0) c3, nvl(sum(decode(C.car_kd, '4', 1, 0)),0) c4, nvl(sum(decode(C.car_kd, '5', 1, 0)),0) c5, nvl(sum(decode(C.car_kd, '6', 1, 0)),0) c6, nvl(sum(decode(C.car_kd, '7', 1, 0)),0) c7 "+
				"from car_reg C, cont t, car_etc e, car_nm n, code d, "+
				" 	(select * from secondhand a where a.seq = (select max(seq) from secondhand where car_mng_id=a.car_mng_id) ) sh "+
				"where c.car_mng_id = t.car_mng_id     "+
				"and t.rent_mng_id = e.rent_mng_id   "+
				"and t.rent_l_cd = e.rent_l_cd     "+
				"and  t.car_st='2'     "+
				"and  nvl(t.use_yn,'Y')='Y'      "+
				"and t.brch_id like '"+brch_id+"' "+
				"and c.off_ls = '0'  "+
				"and c.car_mng_id = sh.car_mng_id(+) "+
				"and c.secondhand = '1' "+
				"and e.car_id = n.car_id and e.car_seq=n.car_seq     "+
				"and n.car_comp_id in ('0004','0005')     "+
				"and n.car_comp_id = d.code     "+
				"and d.c_st = '0001') ds,     "+
				"(select nvl(sum(decode(C.car_kd, '1', 1, 0)),0) c1, nvl(sum(decode(C.car_kd, '2', 1, 0)),0) c2, nvl(sum(decode(C.car_kd, '3', 1, '9', 1, 0)),0) c3, nvl(sum(decode(C.car_kd, '4', 1, 0)),0) c4, nvl(sum(decode(C.car_kd, '5', 1, 0)),0) c5, nvl(sum(decode(C.car_kd, '6', 1, 0)),0) c6, nvl(sum(decode(C.car_kd, '7', 1, 0)),0) c7 "+
				"from car_reg C, cont t, car_etc e, car_nm n, code d, "+
				" 	(select * from secondhand a where a.seq = (select max(seq) from secondhand where car_mng_id=a.car_mng_id) ) sh "+
				"where c.car_mng_id = t.car_mng_id   "+
				"and t.rent_mng_id = e.rent_mng_id  "+
				"and t.rent_l_cd = e.rent_l_cd     "+
				"and  t.car_st='2'    "+
				"and  nvl(t.use_yn,'Y')='Y'    "+
				"and t.brch_id like '"+brch_id+"' "+
				"and c.off_ls = '0'  "+
				"and c.car_mng_id = sh.car_mng_id(+) "+
				"and c.secondhand = '1' "+
				"and e.car_id = n.car_id and e.car_seq=n.car_seq     "+
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
				System.out.println("[SecondhandDatabase:getTg()]"+e);
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
	*	�⺻������(������ġ������ ���� �����,lpg�����ð���) ��ȸ 2004.12.13.��
	*/
	public Hashtable getBase(String car_mng_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query =  " select "+
						" b.rent_mng_id, b.rent_l_cd, b.dlv_dt, a.car_mng_id, a.car_no, 'XXX'||substr(a.car_no,-4) car_no_x, "+
						" to_char(sysdate-365,'yyyymmdd') before_one_year, a.init_reg_dt, a.secondhand_dt, a.fuel_kd, a.park, c.lpg_yn, c.lpg_price, "+
						" d.car_comp_id, d.code, e.car_id, e.car_seq, d.car_nm||' '||e.car_name CAR_NAME, "+
						" c.car_cs_amt+c.car_cv_amt CAR_AMT, c.opt, c.opt_cs_amt+c.opt_cv_amt OPT_AMT, "+
						" c.colo||decode(c.in_col,'','','(����:'||c.in_col||')') as colo, "+
						" c.clr_cs_amt+c.clr_cv_amt CLR_AMT, "+
						" (c.car_cs_amt+c.car_cv_amt+c.opt_cs_amt+c.opt_cv_amt+c.clr_cs_amt+c.clr_cv_amt) o_1, "+
 			            " NVL(c.tax_dc_s_amt,0)+NVL(c.tax_dc_v_amt,0) as TAX_DC_AMT, "+
						" vt.tot_dist, vt.tot_dt as serv_dt, "+
						" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(b.dlv_dt,a.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(b.dlv_dt,a.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST,"+
						" e.jg_code, e.s_st, e.sh_code, a.car_use, a.car_ext"+
						" from car_reg a, cont b, car_etc c, car_mng d, car_nm e, v_tot_dist vt, "+
						"      (select a.car_mng_id CAR_MNG_ID, a.serv_dt SERV_DT, a.tot_dist TOT_DIST  from service a where a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where car_mng_id = a.car_mng_id)) i, "+
						"      (select car_mng_id, max(rent_mng_id||rent_l_cd) max_rent from cont where car_st<>'4' group by car_mng_id) b2  "+
						" where a.car_mng_id='"+car_mng_id+"' "+
						" and a.car_mng_id = b.car_mng_id "+
						" and b.rent_mng_id = c.rent_mng_id "+
						" and b.rent_l_cd = c.rent_l_cd "+
						" and c.car_id = e.car_id and c.car_seq = e.car_seq "+
						" and d.car_comp_id = e.car_comp_id and d.code = e.car_cd "+
						" and a.car_mng_id = vt.car_mng_id(+) "+
						" and a.car_mng_id = i.car_mng_id(+) "+
						" and b.car_mng_id = b2.car_mng_id and b.rent_mng_id||b.rent_l_cd=b2.max_rent"+
						" ";

		try{
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
		}catch(Exception e){
			System.out.println("[SecondhandDatabase:getBase(String car_mng_id)]"+e);
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
	*	�⺻������(������ġ������ ���� �����,lpg�����ð���) ��ȸ 2004.12.13.��
	*/
	public Hashtable getBase(String car_mng_id, String rent_dt){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String r_rent_dt = "";

		if(rent_dt.equals(""))  r_rent_dt = "to_char(sysdate,'YYYYMMDD')";
		else                    r_rent_dt = "'"+rent_dt+"'";


		String query =  " select "+
						"        b.rent_mng_id, b.rent_l_cd, b.dlv_dt, a.car_mng_id, a.car_no, 'XXX'||substr(a.car_no,-4) car_no_x, "+
						"        to_char(to_date("+r_rent_dt+",'yyyymmdd')-365,'yyyymmdd') before_one_year, a.init_reg_dt, a.secondhand_dt, a.fuel_kd, a.park, c.lpg_yn, c.lpg_price, "+
						"        d.car_comp_id, d.code, e.car_id, e.car_seq, d.car_nm||' '||e.car_name CAR_NAME, "+
						"        c.car_cs_amt+c.car_cv_amt CAR_AMT, c.opt, c.opt_cs_amt+c.opt_cv_amt OPT_AMT, "+
						"        c.colo||decode(c.in_col,'','','(����:'||c.in_col||')') as colo, "+
						"        c.clr_cs_amt+c.clr_cv_amt CLR_AMT, "+
						"        (c.car_cs_amt+c.car_cv_amt+c.opt_cs_amt+c.opt_cv_amt+c.clr_cs_amt+c.clr_cv_amt) o_1, "+
 			            " NVL(c.tax_dc_s_amt,0)+NVL(c.tax_dc_v_amt,0) as TAX_DC_AMT, "+
						"        vt.tot_dist, vt.tot_dt as serv_dt, "+
						"        decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(b.dlv_dt,a.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(b.dlv_dt,a.init_reg_dt),'YYYYMMDD')))*(to_date("+r_rent_dt+",'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST,"+
						"        e.jg_code, e.s_st, e.sh_code, a.car_use, a.car_ext"+
						" from car_reg a, cont b, car_etc c, car_mng d, car_nm e, "+
						"      (select distinct a.car_mng_id, a.tot_dt, a.tot_dist "+
						"		from   v_dist a, (select car_mng_id, max(tot_dt||tot_dist) tot from v_dist where tot_dt<="+r_rent_dt+" group by car_mng_id) b "+
						"       where  a.car_mng_id=b.car_mng_id "+
						"              and a.tot_dt<="+r_rent_dt+" "+
						"              and a.tot_dt||a.tot_dist=b.tot)  vt, "+
						"      (select a.car_mng_id CAR_MNG_ID, a.serv_dt SERV_DT, a.tot_dist TOT_DIST  from service a where a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where car_mng_id = a.car_mng_id)) i, "+
						"      (select car_mng_id, max(rent_mng_id||rent_l_cd) max_rent from cont where car_st<>'4' group by car_mng_id) b2  "+
						" where a.car_mng_id='"+car_mng_id+"' "+
						"        and a.car_mng_id = b.car_mng_id "+
						"        and b.rent_mng_id = c.rent_mng_id "+
						"        and b.rent_l_cd = c.rent_l_cd "+
						"        and c.car_id = e.car_id and c.car_seq = e.car_seq "+
						"        and d.car_comp_id = e.car_comp_id and d.code = e.car_cd "+
						"        and a.car_mng_id = vt.car_mng_id(+) "+
						"        and a.car_mng_id = i.car_mng_id(+) "+
						"        and b.car_mng_id = b2.car_mng_id and b.rent_mng_id||b.rent_l_cd=b2.max_rent"+
						" ";

		try{
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

		}catch(Exception e){
			System.out.println("[SecondhandDatabase:getBase(String car_mng_id, String rent_dt)]"+e);
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
	*	�⺻������(������ġ������ ���� �����,lpg�����ð���) ��ȸ 2004.12.13.��
	*/
	public Hashtable getBase(String car_mng_id, String rent_dt, String serv_dt){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String r_rent_dt = "";

		if(rent_dt.equals(""))  r_rent_dt = "to_char(sysdate,'YYYYMMDD')";
		else                    r_rent_dt = "'"+rent_dt+"'";

		String query =  " select "+
						" b.rent_mng_id, b.rent_l_cd, b.dlv_dt, a.car_mng_id, a.car_no, 'XXX'||substr(a.car_no,-4) car_no_x, "+
						" to_char(to_date("+r_rent_dt+",'yyyymmdd')-365,'yyyymmdd') before_one_year, a.init_reg_dt, a.secondhand_dt, a.fuel_kd, a.park, c.lpg_yn, c.lpg_price, "+
						" d.car_comp_id, d.code, e.car_id, e.car_seq, d.car_nm||' '||e.car_name CAR_NAME, "+
						" c.car_cs_amt+c.car_cv_amt CAR_AMT, c.opt, c.opt_cs_amt+c.opt_cv_amt OPT_AMT, "+
						" c.colo||decode(c.in_col,'','','(����:'||c.in_col||')') as colo, "+
						" c.clr_cs_amt+c.clr_cv_amt CLR_AMT, "+
						" (c.car_cs_amt+c.car_cv_amt+c.opt_cs_amt+c.opt_cv_amt+c.clr_cs_amt+c.clr_cv_amt) o_1, "+
 			            " NVL(c.tax_dc_s_amt,0)+NVL(c.tax_dc_v_amt,0) as TAX_DC_AMT, "+
						" vt.tot_dist, vt.tot_dt as serv_dt, "+
						" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(b.dlv_dt,a.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(b.dlv_dt,a.init_reg_dt),'YYYYMMDD')))*(to_date("+r_rent_dt+",'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST,"+
						" e.jg_code, e.s_st, e.sh_code, a.car_use, a.car_ext, vt.cha_st_dt, vt.b_dist"+
						" from car_reg a, cont b, car_etc c, car_mng d, car_nm e, ";

				if(serv_dt.equals("")){
					query += 	"      (select distinct a.car_mng_id, a.tot_dt, DECODE(c.b_dist,'',a.tot_dist,a.tot_dist+c.b_dist) tot_dist, c.cha_st_dt, c.b_dist "+
								"		from   v_dist a, "+
								"              ( select car_mng_id, max(tot_dt||tot_dist) tot from v_dist where tot_dt<="+r_rent_dt+" group by car_mng_id) b, "+
						        "              ( SELECT car_mng_id, MAX(cha_st_dt) cha_st_dt, SUM(b_dist-NVL(a_dist,0)) b_dist FROM CAR_CHA WHERE  cha_st='4' AND b_dist >0 and cha_st_dt<="+r_rent_dt+"  GROUP BY car_mng_id ) c "+
								"       where  a.car_mng_id=b.car_mng_id "+
								"              and a.tot_dt<="+r_rent_dt+" "+
								"              and a.tot_dt||a.tot_dist=b.tot "+
								"              and a.car_mng_id=c.car_mng_id(+) "+
								"	   ) vt, "+
								"      (select a.car_mng_id CAR_MNG_ID, a.serv_dt SERV_DT, a.tot_dist TOT_DIST  from service a where a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where car_mng_id = a.car_mng_id)) i, "+
								"      (select car_mng_id, max(rent_mng_id||rent_l_cd) max_rent from cont where car_st<>'4' group by car_mng_id) b2  ";
				}else{
					query += 	"      (select distinct a.car_mng_id, a.tot_dt, DECODE(c.b_dist,'',a.tot_dist,a.tot_dist+c.b_dist) tot_dist, c.cha_st_dt, c.b_dist "+
								"		from   v_dist a, "+
								"              (select car_mng_id, max(tot_dt||tot_dist) tot from v_dist where tot_dt<="+serv_dt+" group by car_mng_id) b, "+
						        "              ( SELECT car_mng_id, MAX(cha_st_dt) cha_st_dt, SUM(b_dist-NVL(a_dist,0)) b_dist FROM CAR_CHA WHERE  cha_st='4' AND b_dist >0 and cha_st_dt<="+serv_dt+"  GROUP BY car_mng_id ) c "+
								"       where  a.car_mng_id=b.car_mng_id "+
								"              and a.tot_dt<="+serv_dt+" "+
								"              and a.tot_dt||a.tot_dist=b.tot "+
								"              and a.car_mng_id=c.car_mng_id(+) "+
								"      ) vt, "+
								"      (select a.car_mng_id CAR_MNG_ID, a.serv_dt SERV_DT, a.tot_dist TOT_DIST  from service a where a.serv_dt = '"+serv_dt+"') i, "+
								"      (select car_mng_id, max(rent_mng_id||rent_l_cd) max_rent from cont where car_st<>'4' group by car_mng_id) b2  ";
				}

				query +=" where a.car_mng_id=? "+
						" and a.car_mng_id = b.car_mng_id "+
						" and b.rent_mng_id = c.rent_mng_id "+
						" and b.rent_l_cd = c.rent_l_cd "+
						" and c.car_id = e.car_id and c.car_seq = e.car_seq "+
						" and d.car_comp_id = e.car_comp_id and d.code = e.car_cd "+
						" and a.car_mng_id = vt.car_mng_id(+) "+
						" and a.car_mng_id = i.car_mng_id(+) "+
						" and b.car_mng_id = b2.car_mng_id and b.rent_mng_id||b.rent_l_cd=b2.max_rent"+
						" ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
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
		}catch(Exception e){
			System.out.println("[SecondhandDatabase:getBase(String car_mng_id, String rent_dt, String serv_dt)]"+e);
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
	*	�⺻������(������ġ������ ���� �����,lpg�����ð���) ��ȸ
	*/
	public Hashtable getBase(String car_mng_id, String rent_dt, String serv_dt, String s_tot_dist){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String r_rent_dt = "";

		if(rent_dt.equals(""))  r_rent_dt = "to_char(sysdate,'YYYYMMDD')";
		else                    r_rent_dt = "'"+rent_dt+"'";

		String query =  " select "+
						" b.rent_mng_id, b.rent_l_cd, b.dlv_dt, a.car_mng_id, a.car_no, 'XXX'||substr(a.car_no,-4) car_no_x, "+
						" to_char(to_date("+r_rent_dt+",'yyyymmdd')-365,'yyyymmdd') before_one_year, a.init_reg_dt, a.secondhand_dt, a.fuel_kd, a.park, c.lpg_yn, c.lpg_price, "+
						" d.car_comp_id, d.code, e.car_id, e.car_seq, d.car_nm||' '||e.car_name CAR_NAME, "+
						" c.car_cs_amt+c.car_cv_amt CAR_AMT, c.opt, c.opt_cs_amt+c.opt_cv_amt OPT_AMT, "+
						" c.colo||decode(c.in_col,'','','(����:'||c.in_col||')') as colo, "+
						" c.clr_cs_amt+c.clr_cv_amt CLR_AMT, "+
						" (c.car_cs_amt+c.car_cv_amt+c.opt_cs_amt+c.opt_cv_amt+c.clr_cs_amt+c.clr_cv_amt) o_1, "+
 			            " NVL(c.tax_dc_s_amt,0)+NVL(c.tax_dc_v_amt,0) as TAX_DC_AMT, "+
						" vt.tot_dist, vt.tot_dt as serv_dt, "+
						" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(b.dlv_dt,a.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(b.dlv_dt,a.init_reg_dt),'YYYYMMDD')))*(to_date("+r_rent_dt+",'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST,"+
						" e.jg_code, e.s_st, e.sh_code, a.car_use, a.car_ext"+
						" from car_reg a, cont b, car_etc c, car_mng d, car_nm e, ";

				query += 	"      (select "+s_tot_dist+" tot_dist, '"+serv_dt+"' tot_dt from dual ) vt, (select a.car_mng_id CAR_MNG_ID, a.serv_dt SERV_DT, a.tot_dist TOT_DIST  from service a where a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where car_mng_id = a.car_mng_id)) i, "+
							"      (select car_mng_id, max(rent_mng_id||rent_l_cd) max_rent from cont where car_st<>'4' group by car_mng_id) b2  ";


				query +=" where a.car_mng_id=? "+
						" and a.car_mng_id = b.car_mng_id "+
						" and b.rent_mng_id = c.rent_mng_id "+
						" and b.rent_l_cd = c.rent_l_cd "+
						" and c.car_id = e.car_id and c.car_seq = e.car_seq "+
						" and d.car_comp_id = e.car_comp_id and d.code = e.car_cd "+
						" and a.car_mng_id = i.car_mng_id(+) "+
						" and b.car_mng_id = b2.car_mng_id and b.rent_mng_id||b.rent_l_cd=b2.max_rent"+
						" ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
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
		}catch(Exception e){
			System.out.println("[SecondhandDatabase:getBase(String car_mng_id, String rent_dt, String serv_dt)]"+e);
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
	*	�縮�� ���� ������ġ ������� ��ȸ 20050527
	*	- 20051011 ����0�����ܰ��� ���� 0.85-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.05,0) janga0 --> 0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0) janga0
	*/
	public Hashtable getJanga(String car_mng_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "SELECT e.sh_code, b.init_reg_dt, c.lpg_yn, e.dpm "+
" 	  ,i.serv_dt as SERV_DT, i.tot_dist as  TODAY_DIST "+
" 	  ,d.janga24/100 as janga24  "+
" 	  ,0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0) as janga0  "+
" 	  ,POWER((d.janga24/100)/(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0)), ((to_date(to_char(sysdate,'yyyymmdd'))-to_date(b.init_reg_dt))/365*12)/24)*(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0)) month_janga  "+
" 	  ,((to_date(to_char(sysdate,'yyyymmdd'))-to_date(b.init_reg_dt))/365*12) as car_old  "+
" 	  ,((to_date(to_char(sysdate,'yyyymmdd'))-to_date(b.init_reg_dt))/365*12)*2250  std_km  "+
" 	  ,POWER((d.janga24/100)/(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0)), ((to_date(to_char(sysdate,'yyyymmdd'))-to_date(b.init_reg_dt))/365*12)/24)*(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0))*  "+
" 	   (1- (nvl(i.tot_dist,0)-(((to_date(to_char(sysdate,'yyyymmdd'))-to_date(b.init_reg_dt))/365*12)*2250)) /5000 * decode(d.jeep_yn,'Y',0.005,0.01) ) real_km_janga "+
" 	  ,c.car_cs_amt+c.car_cv_amt+c.opt_cs_amt+c.opt_cv_amt+c.clr_cs_amt+c.clr_cv_amt car_amt  "+
" 	  ,decode(d.rentcar,'Y',0,nvl(f.sp_tax,0)) xstart, nvl(g.sp_tax,0) xend  "+
" 	  ,(c.car_cs_amt+c.car_cv_amt+c.opt_cs_amt+c.opt_cv_amt+c.clr_cs_amt+c.clr_cv_amt)/(1+decode(d.rentcar,'Y',0,nvl(f.sp_tax,0))/100)*(1+nvl(g.sp_tax,0)/100) apply_amt  "+
" 	  ,round(POWER((d.janga24/100)/(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0)), ((to_date(to_char(sysdate,'yyyymmdd'))-to_date(b.init_reg_dt))/365*12)/24)*(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0))*  "+
" 	   (1- (nvl(i.tot_dist,0) -(((to_date(to_char(sysdate,'yyyymmdd'))-to_date(b.init_reg_dt))/365*12)*2250)) /5000 * decode(d.jeep_yn,'Y',0.005,0.01) ) "+
" 	   *  "+
" 	   (c.car_cs_amt+c.car_cv_amt+c.opt_cs_amt+c.opt_cv_amt+c.clr_cs_amt+c.clr_cv_amt)/(1+decode(d.rentcar,'Y',0,nvl(f.sp_tax,0))/100)*(1+nvl(g.sp_tax,0)/100),-4 ) auction_amt  "+
//sh_amt
" 	  ,round(round(POWER((d.janga24/100)/(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0)), ((to_date(to_char(sysdate,'yyyymmdd'))-to_date(b.init_reg_dt))/365*12)/24)*(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0))*  "+
" 		   (1- (nvl(i.tot_dist,0)-(((to_date(to_char(sysdate,'yyyymmdd'))-to_date(b.init_reg_dt))/365*12)*2250)) /5000 * decode(d.jeep_yn,'Y',0.005,0.01) ) "+
" 		   *  "+
" 		   (c.car_cs_amt+c.car_cv_amt+c.opt_cs_amt+c.opt_cv_amt+c.clr_cs_amt+c.clr_cv_amt)/(1+decode(d.rentcar,'Y',0,nvl(f.sp_tax,0))/100)*(1+nvl(g.sp_tax,0)/100),-4   "+
" 	   )*105/100+decode(c.lpg_yn,'Y',500000*(POWER((d.janga24/100)/(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0)), ((to_date(to_char(sysdate,'yyyymmdd'))-to_date(b.init_reg_dt))/365*12)/24)*(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0))*  "+
" 	   (1- (nvl(i.tot_dist,0) -(((to_date(to_char(sysdate,'yyyymmdd'))-to_date(b.init_reg_dt))/365*12)*2250)) /5000 * decode(d.jeep_yn,'Y',0.005,0.01) )),0),-5)  sh_amt "+
//sh_amt_no_lpg
" 	  ,round(round(POWER((d.janga24/100)/(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0)), ((to_date(to_char(sysdate,'yyyymmdd'))-to_date(b.init_reg_dt))/365*12)/24)*(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0))* "+
" 		   (1- (nvl(i.tot_dist,0)-(((to_date(to_char(sysdate,'yyyymmdd'))-to_date(b.init_reg_dt))/365*12)*2250)) /5000 * decode(d.jeep_yn,'Y',0.005,0.01) ) "+
" 		   * "+
" 		   (c.car_cs_amt+c.car_cv_amt+c.opt_cs_amt+c.opt_cv_amt+c.clr_cs_amt+c.clr_cv_amt)/(1+decode(d.rentcar,'Y',0,nvl(f.sp_tax,0))/100)*(1+nvl(g.sp_tax,0)/100),-4 "+
" 	   )*105/100, -5)  sh_amt_no_lpg "+
" FROM cont a, car_reg b, car_etc c,   "+
" 	 (select * from esti_sh_var a where seq = (select max(seq) from esti_sh_var b where a.sh_code=b.sh_code)) d,  "+
" 	 car_nm e, sp_tax f,  "+
" 	 (select * from sp_tax where seq = (select max(seq) from sp_tax)) g, "+
"    (select a.car_mng_id, max(b.serv_dt) serv_dt, max(a.tot_dist) tot_dist "+
"		from (select car_mng_Id, nvl(max(tot_dist),0) tot_dist from service group by car_mng_id) a, service b "+
"		where a.car_mng_id=b.car_mng_id and a.tot_dist=b.tot_dist "+
"		group by a.car_mng_id) i "+
" WHERE a.car_mng_id= b.car_mng_id  "+
" AND a.rent_mng_id = c.rent_mng_id  "+
" AND a.rent_l_cd = c.rent_l_cd  "+
" AND a.use_Yn = 'Y'  "+
" and c.car_id = e.car_id and c.car_seq=e.car_seq  "+
" AND e.sh_code= d.sh_code  "+
" and e.sh_code= f.sh_code(+)  "+
" and b.init_reg_dt between nvl(f.tax_st_dt,'00000000') and nvl(f.tax_end_dt,'99999999')  "+
" and e.sh_code= g.sh_code(+)  "+
" and b.car_mng_id = i.car_mng_id(+) "+
" and b.car_mng_id=? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
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
		}catch(Exception e){
			System.out.println("[SecondhandDatabase:getJanga(String car_mng_id)]"+e);
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
	*	�縮�� ���� ������ġ ������� ��ȸ 20050527
	*	- 20051011 ����0�����ܰ��� ���� 0.85-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.05,0) janga0 --> 0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0) janga0
	*/
	public Hashtable getJanga_20070528(String car_mng_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "SELECT e.sh_code, b.init_reg_dt, c.lpg_yn, e.dpm "+
" 	  ,i.serv_dt as SERV_DT, i.tot_dist as  TODAY_DIST "+
" 	  ,d.janga24/100 as janga24  "+
" 	  ,0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0) as janga0  "+
" 	  ,POWER((d.janga24/100)/(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0)), ((to_date(to_char(sysdate,'yyyymmdd'))-to_date(b.init_reg_dt))/365*12)/24)*(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0)) month_janga  "+
" 	  ,((to_date(to_char(sysdate,'yyyymmdd'))-to_date(b.init_reg_dt))/365*12) as car_old  "+
" 	  ,((to_date(to_char(sysdate,'yyyymmdd'))-to_date(b.init_reg_dt))/365*12)*2250  std_km  "+
" 	  ,POWER((d.janga24/100)/(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0)), ((to_date(to_char(sysdate,'yyyymmdd'))-to_date(b.init_reg_dt))/365*12)/24)*(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0))*  "+
" 	   (1- (nvl(i.tot_dist,0)-(((to_date(to_char(sysdate,'yyyymmdd'))-to_date(b.init_reg_dt))/365*12)*2250)) /5000 * decode(d.jeep_yn,'Y',0.005,0.01) ) real_km_janga "+
" 	  ,c.car_cs_amt+c.car_cv_amt+c.opt_cs_amt+c.opt_cv_amt+c.clr_cs_amt+c.clr_cv_amt car_amt  "+
" 	  ,decode(d.rentcar,'Y',0,nvl(f.sp_tax,0)) xstart, nvl(g.sp_tax,0) xend  "+
" 	  ,(c.car_cs_amt+c.car_cv_amt+c.opt_cs_amt+c.opt_cv_amt+c.clr_cs_amt+c.clr_cv_amt)/(1+decode(d.rentcar,'Y',0,nvl(f.sp_tax,0))/100)*(1+nvl(g.sp_tax,0)/100) apply_amt  "+
" 	  ,round(POWER((d.janga24/100)/(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0)), ((to_date(to_char(sysdate,'yyyymmdd'))-to_date(b.init_reg_dt))/365*12)/24)*(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0))*  "+
" 	   (1- (nvl(i.tot_dist,0) -(((to_date(to_char(sysdate,'yyyymmdd'))-to_date(b.init_reg_dt))/365*12)*2250)) /5000 * decode(d.jeep_yn,'Y',0.005,0.01) ) "+
" 	   *  "+
" 	   (c.car_cs_amt+c.car_cv_amt+c.opt_cs_amt+c.opt_cv_amt+c.clr_cs_amt+c.clr_cv_amt)/(1+decode(d.rentcar,'Y',0,nvl(f.sp_tax,0))/100)*(1+nvl(g.sp_tax,0)/100),-4 ) auction_amt  "+
//sh_amt
" 	  ,round(round(POWER((d.janga24/100)/(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0)), ((to_date(to_char(sysdate,'yyyymmdd'))-to_date(b.init_reg_dt))/365*12)/24)*(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0))*  "+
" 		   (1- (nvl(i.tot_dist,0)-(((to_date(to_char(sysdate,'yyyymmdd'))-to_date(b.init_reg_dt))/365*12)*2250)) /5000 * decode(d.jeep_yn,'Y',0.005,0.01) ) "+
" 		   *  "+
" 		   (c.car_cs_amt+c.car_cv_amt+c.opt_cs_amt+c.opt_cv_amt+c.clr_cs_amt+c.clr_cv_amt)/(1+decode(d.rentcar,'Y',0,nvl(f.sp_tax,0))/100)*(1+nvl(g.sp_tax,0)/100),-4   "+
" 	   )*105/100+decode(c.lpg_yn,'Y',500000*(POWER((d.janga24/100)/(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0)), ((to_date(to_char(sysdate,'yyyymmdd'))-to_date(b.init_reg_dt))/365*12)/24)*(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0))*  "+
" 	   (1- (nvl(i.tot_dist,0) -(((to_date(to_char(sysdate,'yyyymmdd'))-to_date(b.init_reg_dt))/365*12)*2250)) /5000 * decode(d.jeep_yn,'Y',0.005,0.01) )),0),-5)  sh_amt "+
//sh_amt_no_lpg
" 	  ,round(round(POWER((d.janga24/100)/(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0)), ((to_date(to_char(sysdate,'yyyymmdd'))-to_date(b.init_reg_dt))/365*12)/24)*(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0))* "+
" 		   (1- (nvl(i.tot_dist,0)-(((to_date(to_char(sysdate,'yyyymmdd'))-to_date(b.init_reg_dt))/365*12)*2250)) /5000 * decode(d.jeep_yn,'Y',0.005,0.01) ) "+
" 		   * "+
" 		   (c.car_cs_amt+c.car_cv_amt+c.opt_cs_amt+c.opt_cv_amt+c.clr_cs_amt+c.clr_cv_amt)/(1+decode(d.rentcar,'Y',0,nvl(f.sp_tax,0))/100)*(1+nvl(g.sp_tax,0)/100),-4 "+
" 	   )*105/100, -5)  sh_amt_no_lpg "+
" FROM cont a, car_reg b, car_etc c,   "+
" 	 (select * from esti_sh_var a where seq = (select max(seq) from esti_sh_var b where a.sh_code=b.sh_code)) d,  "+
" 	 car_nm e, sp_tax f,  "+
" 	 (select * from sp_tax where seq = (select max(seq) from sp_tax)) g, "+
	" (select * from service a    where a.tot_dist is not null and a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where tot_dist is not null and car_mng_id = a.car_mng_id)) i"+
" WHERE a.car_mng_id= b.car_mng_id  "+
" AND a.rent_mng_id = c.rent_mng_id  "+
" AND a.rent_l_cd = c.rent_l_cd  "+
" AND nvl(a.use_Yn,'Y') = 'Y'  "+
" and c.car_id = e.car_id and c.car_seq=e.car_seq  "+
" AND e.sh_code= d.sh_code  "+
" and e.sh_code= f.sh_code(+)  "+
" and b.init_reg_dt between nvl(f.tax_st_dt,'00000000') and nvl(f.tax_end_dt,'99999999')  "+
" and e.sh_code= g.sh_code(+)  "+
" and b.car_mng_id = i.car_mng_id(+) "+
" and b.car_mng_id=? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
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
		}catch(Exception e){
			System.out.println("[SecondhandDatabase:getJanga_20070528(String car_mng_id)]"+e);
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
	*	�縮�� ���� ���� ������ġ ������� ��ȸ 20051118
	*/
	public Hashtable getJanga(String car_mng_id, String esti_dt){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "SELECT e.sh_code, b.init_reg_dt, c.lpg_yn, e.dpm "+
" 	  ,i.serv_dt SERV_DT, i.tot_dist TODAY_DIST "+
" 	  ,d.janga24/100 janga24  "+
" 	  ,0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0) janga0  "+
" 	  ,POWER((d.janga24/100)/(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0)), ((to_date("+esti_dt+")-to_date(b.init_reg_dt))/365*12)/24)*(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0)) month_janga  "+
" 	  ,((to_date("+esti_dt+")-to_date(b.init_reg_dt))/365*12) car_old  "+
" 	  ,((to_date("+esti_dt+")-to_date(b.init_reg_dt))/365*12)*2250  std_km  "+
" 	  ,POWER((d.janga24/100)/(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0)), ((to_date("+esti_dt+")-to_date(b.init_reg_dt))/365*12)/24)*(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0))*  "+
" 	   (1- (nvl(i.tot_dist,0)-(((to_date("+esti_dt+")-to_date(b.init_reg_dt))/365*12)*2250)) /5000 * decode(d.jeep_yn,'Y',0.005,0.01) ) real_km_janga "+
" 	  ,c.car_cs_amt+c.car_cv_amt+c.opt_cs_amt+c.opt_cv_amt+c.clr_cs_amt+c.clr_cv_amt car_amt  "+
" 	  ,decode(d.rentcar,'Y',0,nvl(f.sp_tax,0)) xstart, nvl(g.sp_tax,0) xend  "+
" 	  ,round((c.car_cs_amt+c.car_cv_amt+c.opt_cs_amt+c.opt_cv_amt+c.clr_cs_amt+c.clr_cv_amt)/(1+decode(d.rentcar,'Y',0,nvl(f.sp_tax,0))/100)*(1+nvl(g.sp_tax,0)/100)) apply_amt  "+
" 	  ,round(POWER((d.janga24/100)/(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0)), ((to_date("+esti_dt+")-to_date(b.init_reg_dt))/365*12)/24)*(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0))*  "+
" 	   (1- (nvl(i.tot_dist,0) -(((to_date("+esti_dt+")-to_date(b.init_reg_dt))/365*12)*2250)) /5000 * decode(d.jeep_yn,'Y',0.005,0.01) ) "+
" 	   *  "+
" 	   (c.car_cs_amt+c.car_cv_amt+c.opt_cs_amt+c.opt_cv_amt+c.clr_cs_amt+c.clr_cv_amt)/(1+decode(d.rentcar,'Y',0,nvl(f.sp_tax,0))/100)*(1+nvl(g.sp_tax,0)/100),-4 ) auction_amt  "+
" 	  ,round(round(POWER((d.janga24/100)/(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0)), ((to_date("+esti_dt+")-to_date(b.init_reg_dt))/365*12)/24)*(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0))*  "+
" 		   (1- (nvl(i.tot_dist,0)-(((to_date("+esti_dt+")-to_date(b.init_reg_dt))/365*12)*2250)) /5000 * decode(d.jeep_yn,'Y',0.005,0.01) ) "+
" 		   *  "+
" 		   (c.car_cs_amt+c.car_cv_amt+c.opt_cs_amt+c.opt_cv_amt+c.clr_cs_amt+c.clr_cv_amt)/(1+decode(d.rentcar,'Y',0,nvl(f.sp_tax,0))/100)*(1+nvl(g.sp_tax,0)/100),-4   "+
" 	   )*105/100+decode(c.lpg_yn,'Y',500000*(POWER((d.janga24/100)/(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0)), ((to_date("+esti_dt+")-to_date(b.init_reg_dt))/365*12)/24)*(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0))*  "+
" 	   (1- (nvl(i.tot_dist,0) -(((to_date("+esti_dt+")-to_date(b.init_reg_dt))/365*12)*2250)) /5000 * decode(d.jeep_yn,'Y',0.005,0.01) )),0),-5)  sh_amt "+
" 	  ,round(round(POWER((d.janga24/100)/(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0)), ((to_date("+esti_dt+")-to_date(b.init_reg_dt))/365*12)/24)*(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0))* "+
" 		   (1- (nvl(i.tot_dist,0)-(((to_date("+esti_dt+")-to_date(b.init_reg_dt))/365*12)*2250)) /5000 * decode(d.jeep_yn,'Y',0.005,0.01) ) "+
" 		   * "+
" 		   (c.car_cs_amt+c.car_cv_amt+c.opt_cs_amt+c.opt_cv_amt+c.clr_cs_amt+c.clr_cv_amt)/(1+decode(d.rentcar,'Y',0,nvl(f.sp_tax,0))/100)*(1+nvl(g.sp_tax,0)/100),-4 "+
" 	   )*105/100, -5)  sh_amt_no_lpg "+
" FROM cont a, car_reg b, car_etc c,   "+
" 	 (select * from esti_sh_var a where seq = (select max(seq) from esti_sh_var b where a.sh_code=b.sh_code)) d,  "+
" 	 car_nm e, sp_tax f,  "+
" 	 (select * from sp_tax where seq = (select max(seq) from sp_tax)) g, "+
"    (select a.car_mng_id, max(b.serv_dt) serv_dt, max(a.tot_dist) tot_dist "+
"		from (select car_mng_Id, nvl(max(tot_dist),0) tot_dist from service group by car_mng_id) a, service b "+
"		where a.car_mng_id=b.car_mng_id and a.tot_dist=b.tot_dist "+
"		group by a.car_mng_id) i "+
" WHERE a.car_mng_id= b.car_mng_id  "+
" AND a.rent_mng_id = c.rent_mng_id  "+
" AND a.rent_l_cd = c.rent_l_cd  "+
" AND a.use_Yn = 'Y'  "+
" and c.car_id = e.car_id and c.car_seq=e.car_seq  "+
" AND e.sh_code= d.sh_code  "+
" and e.sh_code= f.sh_code(+)  "+
" and b.init_reg_dt between nvl(f.tax_st_dt,'00000000') and nvl(f.tax_end_dt,'99999999')  "+
" and e.sh_code= g.sh_code(+)  "+
" and b.car_mng_id = i.car_mng_id(+) "+
" and b.car_mng_id=? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
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
		}catch(Exception e){
			System.out.println("[SecondhandDatabase:getJanga(String car_mng_id, String esti_dt)]"+e);
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
	*	������� �縮�� �������� �����ؼ� ������ġ ������� ��ȸ 20051201
	*/
	public Hashtable getJanga_e(String car_mng_id, String esti_dt){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "SELECT e.sh_code, b.init_reg_dt, c.lpg_yn, e.dpm "+
" 	  ,i.serv_dt SERV_DT, i.tot_dist TODAY_DIST "+
" 	  ,d.janga24/100 janga24  "+
" 	  ,0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0) janga0  "+
" 	  ,POWER((d.janga24/100)/(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0)), ((to_date("+esti_dt+")-to_date(b.init_reg_dt))/365*12)/24)*(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0)) month_janga  "+
" 	  ,((to_date("+esti_dt+")-to_date(b.init_reg_dt))/365*12) car_old  "+
" 	  ,((to_date("+esti_dt+")-to_date(b.init_reg_dt))/365*12)*2250  std_km  "+
" 	  ,POWER((d.janga24/100)/(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0)), ((to_date("+esti_dt+")-to_date(b.init_reg_dt))/365*12)/24)*(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0))*  "+
" 	   (1- (i.tot_dist-(((to_date("+esti_dt+")-to_date(b.init_reg_dt))/365*12)*2250)) /5000 * decode(d.jeep_yn,'Y',0.005,0.01) ) real_km_janga "+
" 	  ,c.car_cs_amt+c.car_cv_amt+c.opt_cs_amt+c.opt_cv_amt+c.clr_cs_amt+c.clr_cv_amt car_amt  "+
" 	  ,decode(d.rentcar,'Y',0,f.sp_tax) xstart, g.sp_tax xend  "+
" 	  ,(c.car_cs_amt+c.car_cv_amt+c.opt_cs_amt+c.opt_cv_amt+c.clr_cs_amt+c.clr_cv_amt)/(1+decode(d.rentcar,'Y',0,f.sp_tax)/100)*(1+g.sp_tax/100) apply_amt  "+
" 	  ,round(POWER((d.janga24/100)/(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0)), ((to_date("+esti_dt+")-to_date(b.init_reg_dt))/365*12)/24)*(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0))*  "+
" 	   (1- (i.tot_dist -(((to_date("+esti_dt+")-to_date(b.init_reg_dt))/365*12)*2250)) /5000 * decode(d.jeep_yn,'Y',0.005,0.01) ) "+
" 	   *  "+
" 	   (c.car_cs_amt+c.car_cv_amt+c.opt_cs_amt+c.opt_cv_amt+c.clr_cs_amt+c.clr_cv_amt)/(1+decode(d.rentcar,'Y',0,f.sp_tax)/100)*(1+g.sp_tax/100),-4 ) auction_amt  "+
" 	  ,round(round(POWER((d.janga24/100)/(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0)), ((to_date("+esti_dt+")-to_date(b.init_reg_dt))/365*12)/24)*(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0))*  "+
" 		   (1- (i.tot_dist-(((to_date("+esti_dt+")-to_date(b.init_reg_dt))/365*12)*2250)) /5000 * decode(d.jeep_yn,'Y',0.005,0.01) ) "+
" 		   *  "+
" 		   (c.car_cs_amt+c.car_cv_amt+c.opt_cs_amt+c.opt_cv_amt+c.clr_cs_amt+c.clr_cv_amt)/(1+decode(d.rentcar,'Y',0,f.sp_tax)/100)*(1+g.sp_tax/100),-4   "+
" 	   )*105/100+decode(c.lpg_yn,'Y',500000*(POWER((d.janga24/100)/(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0)), ((to_date("+esti_dt+")-to_date(b.init_reg_dt))/365*12)/24)*(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0))*  "+
" 	   (1- (i.tot_dist -(((to_date("+esti_dt+")-to_date(b.init_reg_dt))/365*12)*2250)) /5000 * decode(d.jeep_yn,'Y',0.005,0.01) )),0),-5)  sh_amt "+
" 	  ,round(round(POWER((d.janga24/100)/(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0)), ((to_date("+esti_dt+")-to_date(b.init_reg_dt))/365*12)/24)*(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0))* "+
" 		   (1- (i.tot_dist-(((to_date("+esti_dt+")-to_date(b.init_reg_dt))/365*12)*2250)) /5000 * decode(d.jeep_yn,'Y',0.005,0.01) ) "+
" 		   * "+
" 		   (c.car_cs_amt+c.car_cv_amt+c.opt_cs_amt+c.opt_cv_amt+c.clr_cs_amt+c.clr_cv_amt)/(1+decode(d.rentcar,'Y',0,f.sp_tax)/100)*(1+g.sp_tax/100),-4 "+
" 	   )*105/100, -5)  sh_amt_no_lpg "+
" FROM cont a, car_reg b, car_etc c,   "+
" 	 (select * from esti_sh_var a where seq = (select max(seq) from esti_sh_var b where a.sh_code=b.sh_code)) d,  "+
" 	 car_nm e, sp_tax f,  "+
" 	 (select * from sp_tax where seq = (select max(seq) from sp_tax)) g, "+
"    (select b.car_mng_id, '"+esti_dt+"' serv_dt, round(((to_date("+esti_dt+")-to_date(b.init_reg_dt))/365*12)*2250) tot_dist from dual a, car_reg b where b.car_mng_id='"+car_mng_id+"') i "+
" WHERE a.car_mng_id= b.car_mng_id  "+
" AND a.rent_mng_id = c.rent_mng_id  "+
" AND a.rent_l_cd = c.rent_l_cd  "+
" AND a.use_Yn = 'Y'  "+
" and c.car_id = e.car_id and c.car_seq=e.car_seq  "+
" AND e.sh_code= d.sh_code  "+
" and e.sh_code= f.sh_code(+)  "+
" and b.init_reg_dt between nvl(f.tax_st_dt,'00000000') and nvl(f.tax_end_dt,'99999999')  "+
" and e.sh_code= g.sh_code(+)  "+
" and b.car_mng_id = i.car_mng_id(+) "+
" and b.car_mng_id=? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
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
		}catch(Exception e){
			System.out.println("[SecondhandDatabase:getJanga(String car_mng_id, String esti_dt)]"+e);
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
	*	���� �߰��� ����(�ڵ����) - 2004.12.8.Wed.
	*/
	public int getApplySecondhandPrice(String car_mng_id, String base_secondhand_price, String base_secondhand_dt, String apply_secondhand_dt, int real_km){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int apply_secondhand_price = 0;
		String query =
					" SELECT "+base_secondhand_price+"+ "+
					" round(((c.opt_cs_amt+c.opt_cv_amt)+c.lpg_price)*"+base_secondhand_price+"/(c.car_cs_amt+c.car_cv_amt),-5)+ "+
					" round( "+
					" ("+base_secondhand_price+"+ "+
					"  round(((c.opt_cs_amt+c.opt_cv_amt)+c.lpg_price)*"+base_secondhand_price+"/(c.car_cs_amt+c.car_cv_amt),-5) "+
					" )* "+
					" ( "+
					"  ((to_date(a.init_reg_dt)-to_date('"+base_secondhand_dt+"','yyyymmdd'))/30.4*(1/100))- "+
					"  (("+real_km+"-to_number(round( "+
					"  					             (to_date(substr('"+apply_secondhand_dt+"',1,6)||'01','yyyymmdd')-to_date(a.init_reg_dt,'yyyymmdd'))/365*27000 "+
					" 					            ,0) "+
					" 					       ) "+
					"   )/5000*(1/100)) "+
					" ),-5 ) APPLY_SECONDHAND_PRICE "+
					" FROM car_reg a, cont b, car_etc c, car_mng d, car_nm e, code f "+
					" WHERE a.car_mng_id = b.car_mng_id "+
					"  AND b.rent_mng_id = c.rent_mng_id "+
					"  AND b.rent_l_cd = c.rent_l_cd "+
					"  AND c.car_id = e.car_id "+
					"  AND c.car_seq = e.car_seq "+
					"  AND d.car_comp_id = e.car_comp_id "+
					"  AND d.code = e.car_cd "+
					"  AND e.car_comp_id = f.code "+
					"  AND f.c_st = '0001' "+
					"  AND a.car_mng_id = '"+car_mng_id+"' "+
					"  AND b.use_yn = 'Y' "+
					"  AND b.car_st = '2' "+
					" and a.off_ls in ('0','1') ";

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while(rs.next()){
				apply_secondhand_price  = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[SecondhandDatabase:getApplySecondhandPrice(String car_mng_id, String base_secondhand_price, String base_secondhand_dt)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null)	rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			closeConnection();
		}
		return apply_secondhand_price;
	}

	/**
    * ������ġ���� ���� ��� 2004.12.14.ȭ.
    */
	public int secondhandPrice_i(SecondhandBean bean){
		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		int result = 0;

		query = "INSERT INTO secondhand(car_mng_id, seq, base_sh_pr, base_sh_dt, apply_sh_dt, real_km, apply_sh_pr, reg_id, reg_dt) "+
				" SELECT ?,nvl(lpad(max(seq)+1,3,'0'),'001'),?,?,?,?,?,?,? FROM secondhand WHERE car_mng_id=? ";
		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, bean.getCar_mng_id());
			pstmt.setInt(2, bean.getBase_sh_pr());
			pstmt.setString(3, bean.getBase_sh_dt());
			pstmt.setString(4, bean.getApply_sh_dt());
			pstmt.setString(5, bean.getReal_km());
			pstmt.setInt(6, bean.getApply_sh_pr());
			pstmt.setString(7, bean.getReg_id());
			pstmt.setString(8, bean.getReg_dt());
			pstmt.setString(9, bean.getCar_mng_id());
			result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		}catch(SQLException e){
			System.out.println("[SecondhandDatabase:secondhandPrice_i(SecondhandBean bean)]"+e);
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
	*	 ������ġ���� ���� ���� 2004.12.14.ȭ.
	*/
	public int secondhandPrice_u(SecondhandBean bean){
		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		int result = 0;

		query = " UPDATE secondhand SET base_sh_pr=?, base_sh_dt=?, apply_sh_dt=?, real_km=?, apply_sh_pr=?, upd_id=?, upd_dt=? "+
				" WHERE car_mng_id=? AND seq=? ";

		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, bean.getBase_sh_pr());
			pstmt.setString(2, bean.getBase_sh_dt());
			pstmt.setString(3, bean.getApply_sh_dt());
			pstmt.setString(4, bean.getReal_km());
			pstmt.setInt(5, bean.getApply_sh_pr());
			pstmt.setString(6, bean.getUpd_id());
			pstmt.setString(7, bean.getUpd_dt());
			pstmt.setString(8, bean.getCar_mng_id());
			pstmt.setString(9, bean.getSeq());
			result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		}catch(SQLException e){
			System.out.println("[SecondhandDatabase:secondhandPrice_u(SecondhandBean bean)]"+e);
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
	*	�縮������ ���� ���� �̷� �˻� - 2004.12.14.ȭ.
	*/
	public SecondhandBean[] getSecondhandPriceList(String car_mng_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Collection<SecondhandBean> col = new ArrayList<SecondhandBean>();
		String query = "";
		String subQuery = "";

		query = "SELECT	car_mng_id, seq, base_sh_pr, base_sh_dt, apply_sh_dt, real_km, apply_sh_pr, reg_id, reg_dt, upd_id, upd_dt, ls18, ls24, ls36, lb24, lb36, rs12, rs24, rs36, rb24, rb36, upload_id, upload_dt "+
				" FROM secondhand "+
				" WHERE car_mng_id = ? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				col.add(this.makeSecondhandBean(rs));
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[SecondhandDatabase:getSecondhandPriceList(String car_mng_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return (SecondhandBean[])col.toArray(new SecondhandBean[0]);
		}
	}

	/**
	*	�縮������ ���� ���� �̷� �Ǻ� �� �˻� - 2004.12.14.ȭ.
	*/
	public SecondhandBean getSecondhand(String car_mng_id, String seq){
		getConnection();
		SecondhandBean bean = new SecondhandBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = "SELECT car_mng_id, seq, base_sh_pr, base_sh_dt, apply_sh_dt, real_km, apply_sh_pr, reg_id, reg_dt, upd_id, upd_dt, ls18, ls24, ls36, lb24, lb36, rs12, rs24, rs36, rb24, rb36, upload_id, upload_dt "+
				"  FROM secondhand WHERE car_mng_id = ? and seq = ? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
			pstmt.setString(2, seq);
			rs = pstmt.executeQuery();
			while(rs.next()){
				bean = this.makeSecondhandBean(rs);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[SecondhandDatabase:getSecondhand(String car_mng_id, String seq)]"+e);
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
	*	�縮������ ���� ���� �̷� �Ǻ� �� �˻� - 2004.12.14.ȭ. -����ϰ� �ǽð����� �ٲ�.
	*/
	public Hashtable getSecondhandFee(String car_mng_id, String column){
		getConnection();
		Hashtable ht = new Hashtable();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = "SELECT upload_dt, "+column+
				" FROM secondhand b "+
				" WHERE b.car_mng_id=? "+
				"	AND b.seq=(select max(a.seq) from secondhand a where a.car_mng_id=b.car_mng_id) ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
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

		}catch(SQLException e){
			System.out.println("[SecondhandDatabase:getSecondhand(String car_mng_id, String column)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return ht;
		}
	}

//---------------------------------------------------------------------------------------------------------
//	200505	�縮��.
//---------------------------------------------------------------------------------------------------------
	/**
    * �縮�� �뿩�� ��� 2005.06.02.
    */
	public int uploadSecondhand(SecondhandBean bean){
		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		int result = 0;

		query = "INSERT INTO secondhand(car_mng_id, seq, real_km, apply_sh_pr, "+
				"	ls12, ls18, ls24, ls30, ls36, ls42, ls48, "+
				"	lb12, lb18, lb24, lb30, lb36, lb42, lb48, "+
				"	rs1, rs2, rs3, rs4, rs5, rs6, rs7, rs8, rs9, rs10, rs11, rs12, rs18, rs24, rs30, rs36, rs42, rs48, "+
				"	rb1, rb2, rb3, rb4, rb5, rb6, rb7, rb8, rb9, rb10, rb11, rb12, rb18, rb24, rb30, rb36, rb42, rb48, "+
				"	upload_id, upload_dt) "+
				" SELECT ?,nvl(lpad(max(seq)+1,3,'0'),'001'), ?, ?, "+
				"	?,?,?,?,?,?,?, "+
				"	?,?,?,?,?,?,?, "+
				"	?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?, "+
				"	?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?, "+
				"	?,to_char(sysdate,'yyyymmdd') FROM secondhand WHERE car_mng_id=? ";
		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, bean.getCar_mng_id());
			pstmt.setString(2, bean.getReal_km());
			pstmt.setInt(3,  bean.getApply_sh_pr());
			pstmt.setInt(4,  bean.getLs12());
			pstmt.setInt(5,  bean.getLs18());
			pstmt.setInt(6,  bean.getLs24());
			pstmt.setInt(7,  bean.getLs30());
			pstmt.setInt(8,  bean.getLs36());
			pstmt.setInt(9,  bean.getLs42());
			pstmt.setInt(10, bean.getLs48());
			pstmt.setInt(11, bean.getLb12());
			pstmt.setInt(12, bean.getLb18());
			pstmt.setInt(13, bean.getLb24());
			pstmt.setInt(14, bean.getLb30());
			pstmt.setInt(15, bean.getLb36());
			pstmt.setInt(16, bean.getLb42());
			pstmt.setInt(17, bean.getLb48());
			pstmt.setInt(18, bean.getRs1 ());
			pstmt.setInt(19, bean.getRs2 ());
			pstmt.setInt(20, bean.getRs3 ());
			pstmt.setInt(21, bean.getRs4 ());
			pstmt.setInt(22, bean.getRs5 ());
			pstmt.setInt(23, bean.getRs6 ());
			pstmt.setInt(24, bean.getRs7 ());
			pstmt.setInt(25, bean.getRs8 ());
			pstmt.setInt(26, bean.getRs9 ());
			pstmt.setInt(27, bean.getRs10());
			pstmt.setInt(28, bean.getRs11());
			pstmt.setInt(29, bean.getRs12());
			pstmt.setInt(30, bean.getRs18());
			pstmt.setInt(31, bean.getRs24());
			pstmt.setInt(32, bean.getRs30());
			pstmt.setInt(33, bean.getRs36());
			pstmt.setInt(34, bean.getRs42());
			pstmt.setInt(35, bean.getRs48());
			pstmt.setInt(36, bean.getRb1 ());
			pstmt.setInt(37, bean.getRb2 ());
			pstmt.setInt(38, bean.getRb3 ());
			pstmt.setInt(39, bean.getRb4 ());
			pstmt.setInt(40, bean.getRb5 ());
			pstmt.setInt(41, bean.getRb6 ());
			pstmt.setInt(42, bean.getRb7 ());
			pstmt.setInt(43, bean.getRb8 ());
			pstmt.setInt(44, bean.getRb9 ());
			pstmt.setInt(45, bean.getRb10());
			pstmt.setInt(46, bean.getRb11());
			pstmt.setInt(47, bean.getRb12());
			pstmt.setInt(48, bean.getRb18());
			pstmt.setInt(49, bean.getRb24());
			pstmt.setInt(50, bean.getRb30());
			pstmt.setInt(51, bean.getRb36());
			pstmt.setInt(52, bean.getRb42());
			pstmt.setInt(53, bean.getRb48());
			pstmt.setString(54, bean.getUpload_id());
			pstmt.setString(55, bean.getCar_mng_id());
			result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		}catch(SQLException e){
			System.out.println("[SecondhandDatabase:uploadSecondhand(SecondhandBean bean)]"+e);
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
    * ������������ ��� 2005.6.14.ȭ.
    */
	public int shRes_i(ShResBean bean){
		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		int result = 0;

		query = "INSERT INTO sh_res(car_mng_id, seq, damdang_id, situation, memo, reg_dt, cust_nm, cust_tel, est_id, reg_code) "+
				" SELECT ?,nvl(lpad(max(seq)+1,3,'0'),'001'),?,?,?,?,?,?,?,? FROM sh_res WHERE car_mng_id=? ";
		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, bean.getCar_mng_id());
			pstmt.setString(2, bean.getDamdang_id());
			pstmt.setString(3, bean.getSituation());
			pstmt.setString(4, bean.getMemo());
			pstmt.setString(5, bean.getReg_dt());
			pstmt.setString(6, bean.getCust_nm());
			pstmt.setString(7, bean.getCust_tel());
			pstmt.setString(8, bean.getEst_id());
			pstmt.setString(9, bean.getReg_code());
			pstmt.setString(10, bean.getCar_mng_id());
			
			result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		}catch(SQLException e){
			System.out.println("[SecondhandDatabase:shRes_i(ShResBean bean)]"+e);
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
	*	 ������������ ���� 2005.6.14.ȭ.
	*/
	public int shRes_u(ShResBean bean){
		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		int result = 0;

		query = " UPDATE sh_res "+
				" SET damdang_id=?, situation=?, memo=?, reg_dt=?, cust_nm=?, cust_tel=? "+
				" WHERE car_mng_id=? AND seq=? ";

		try{

			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, bean.getDamdang_id());
			pstmt.setString(2, bean.getSituation());
			pstmt.setString(3, bean.getMemo());
			pstmt.setString(4, bean.getReg_dt());
			pstmt.setString(5, bean.getCust_nm());
			pstmt.setString(6, bean.getCust_tel());
			pstmt.setString(7, bean.getCar_mng_id());
			pstmt.setString(8, bean.getSeq());
			result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		}catch(SQLException e){
			System.out.println("[SecondhandDatabase:shRes_u(ShResBean bean)]"+e);
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
	*	 �������������޸� ���� 2012-06-22
	*/
	public int shRes_u_M(ShResBean bean){
		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		int result = 0;

		query = " UPDATE sh_res SET "+
				"        memo=?, cust_nm=?, cust_tel=? "+
				" WHERE  car_mng_id=? AND seq=? ";

		try{

			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, bean.getMemo());
			pstmt.setString(2, bean.getCust_nm());
			pstmt.setString(3, bean.getCust_tel());
			pstmt.setString(4, bean.getCar_mng_id());
			pstmt.setString(5, bean.getSeq());
			result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		}catch(SQLException e){
			System.out.println("[SecondhandDatabase:shRes_u_M(ShResBean bean)]"+e);
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

	public int shRes_u_Useyn(ShResBean bean){
		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		int result = 0;

		query = " UPDATE sh_res SET "+
				"        use_yn=? "+
				" WHERE  car_mng_id=? AND seq=? ";

		try{

			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, bean.getUse_yn());
			pstmt.setString(2, bean.getCar_mng_id());
			pstmt.setString(3, bean.getSeq());
			result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		}catch(SQLException e){
			System.out.println("[SecondhandDatabase:shRes_u_Useyn(ShResBean bean)]"+e);
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
	*	 ������������ ��ȸ 2005.6.14.ȭ.
	*/
	public ShResBean getShRes(String car_mng_id){
		getConnection();
		ShResBean bean = new ShResBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT car_mng_id, seq, damdang_id, situation, memo, reg_dt, res_st_dt, res_end_dt, use_yn, "+
			    "        cust_nm, cust_tel, nvl(add_cnt,0) add_cnt, nvl(add_cnt_s,0) add_cnt_s, est_id, reg_code "+
				" FROM sh_res a WHERE car_mng_id = ? and seq=(select max(seq) from sh_res b where a.car_mng_id = b.car_mng_id) ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
			rs = pstmt.executeQuery();
			if(rs.next()){
				bean.setCar_mng_id	(rs.getString("CAR_MNG_ID"));
				bean.setSeq			(rs.getString("SEQ"));
				bean.setDamdang_id	(rs.getString("DAMDANG_ID"));
				bean.setSituation	(rs.getString("SITUATION"));
				bean.setMemo		(rs.getString("MEMO"));
				bean.setReg_dt		(rs.getString("REG_DT"));
				bean.setRes_end_dt	(rs.getString("RES_END_DT")==null?"":rs.getString("RES_END_DT"));
				bean.setRes_st_dt	(rs.getString("RES_ST_DT")==null?"":rs.getString("RES_ST_DT"));
				bean.setUse_yn		(rs.getString("USE_YN")==null?"":rs.getString("USE_YN"));
				bean.setCust_nm		(rs.getString("CUST_NM")==null?"":rs.getString("CUST_NM"));
				bean.setCust_tel	(rs.getString("CUST_TEL")==null?"":rs.getString("CUST_TEL"));
				bean.setAdd_cnt		(rs.getString("add_cnt")==null?0:Integer.parseInt(rs.getString("add_cnt")));
				bean.setEst_id 		(rs.getString("EST_ID")==null?"":rs.getString("EST_ID"));
				bean.setReg_code	(rs.getString("REG_CODE")==null?"":rs.getString("REG_CODE"));
				bean.setAdd_cnt_s	(rs.getString("add_cnt_s")==null?0:Integer.parseInt(rs.getString("add_cnt_s")));
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[SecondhandDatabase:getSecondhand(String car_mng_id)]"+e);
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
	*	 ������������ ��ȸ 
	*/
	public ShResBean getShRes(String car_mng_id, String seq){
		getConnection();
		ShResBean bean = new ShResBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = "SELECT car_mng_id, seq, damdang_id, situation, memo, reg_dt, res_st_dt, res_end_dt, use_yn, cust_nm, cust_tel, nvl(add_cnt,0) add_cnt, nvl(add_cnt_s,0) add_cnt_s, est_id, reg_code "+
				"  FROM sh_res a WHERE car_mng_id = ? and seq= ?  ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
			pstmt.setString(2, seq);
			rs = pstmt.executeQuery();
			if(rs.next()){
				bean.setCar_mng_id	(rs.getString("CAR_MNG_ID"));
				bean.setSeq			(rs.getString("SEQ"));
				bean.setDamdang_id	(rs.getString("DAMDANG_ID"));
				bean.setSituation	(rs.getString("SITUATION"));
				bean.setMemo		(rs.getString("MEMO"));
				bean.setReg_dt		(rs.getString("REG_DT"));
				bean.setRes_end_dt	(rs.getString("RES_END_DT")==null?"":rs.getString("RES_END_DT"));
				bean.setRes_st_dt	(rs.getString("RES_ST_DT")==null?"":rs.getString("RES_ST_DT"));
				bean.setUse_yn		(rs.getString("USE_YN")==null?"":rs.getString("USE_YN"));
				bean.setCust_nm		(rs.getString("CUST_NM")==null?"":rs.getString("CUST_NM"));
				bean.setCust_tel	(rs.getString("CUST_TEL")==null?"":rs.getString("CUST_TEL"));
				bean.setAdd_cnt		(rs.getString("add_cnt")==null?0:Integer.parseInt(rs.getString("add_cnt")));
				bean.setEst_id 		(rs.getString("EST_ID")==null?"":rs.getString("EST_ID"));
				bean.setReg_code	(rs.getString("REG_CODE")==null?"":rs.getString("REG_CODE"));
				bean.setAdd_cnt_s	(rs.getString("add_cnt_s")==null?0:Integer.parseInt(rs.getString("add_cnt_s")));
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[SecondhandDatabase:getShRes(String car_mng_id, String seq)]"+e);
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
	*	 ������������ ��ȸ
	*/
	public ShResBean getShRes2(String car_mng_id){
		getConnection();
		ShResBean bean = new ShResBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = "SELECT car_mng_id, seq, damdang_id, situation, memo, reg_dt, res_st_dt, res_end_dt, use_yn, cust_nm, cust_tel, nvl(add_cnt,0) add_cnt, nvl(add_cnt_s,0) add_cnt_s, est_id, reg_code "+
				"  FROM sh_res  WHERE car_mng_id = ? and situation='2' and use_yn='Y'";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
			rs = pstmt.executeQuery();
			if(rs.next()){
				bean.setCar_mng_id	(rs.getString("CAR_MNG_ID"));
				bean.setSeq			(rs.getString("SEQ"));
				bean.setDamdang_id	(rs.getString("DAMDANG_ID"));
				bean.setSituation	(rs.getString("SITUATION"));
				bean.setMemo		(rs.getString("MEMO"));
				bean.setReg_dt		(rs.getString("REG_DT"));
				bean.setRes_end_dt	(rs.getString("RES_END_DT")==null?"":rs.getString("RES_END_DT"));
				bean.setRes_st_dt	(rs.getString("RES_ST_DT")==null?"":rs.getString("RES_ST_DT"));
				bean.setUse_yn		(rs.getString("USE_YN")==null?"":rs.getString("USE_YN"));
				bean.setCust_nm		(rs.getString("CUST_NM")==null?"":rs.getString("CUST_NM"));
				bean.setCust_tel	(rs.getString("CUST_TEL")==null?"":rs.getString("CUST_TEL"));
				bean.setAdd_cnt		(rs.getString("add_cnt")==null?0:Integer.parseInt(rs.getString("add_cnt")));
				bean.setEst_id 		(rs.getString("EST_ID")==null?"":rs.getString("EST_ID"));
				bean.setReg_code	(rs.getString("REG_CODE")==null?"":rs.getString("REG_CODE"));
				bean.setAdd_cnt_s	(rs.getString("add_cnt_s")==null?0:Integer.parseInt(rs.getString("add_cnt_s")));
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[SecondhandDatabase:getShRes2(String car_mng_id)]"+e);
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
	*	 ������������ ��ȸ
	*/
	public ShResBean getShRes3(String car_mng_id){
		getConnection();
		ShResBean bean = new ShResBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = "SELECT car_mng_id, seq, damdang_id, situation, memo, reg_dt, res_st_dt, res_end_dt, use_yn, cust_nm, cust_tel, nvl(add_cnt,0) add_cnt, nvl(add_cnt_s,0) add_cnt_s, est_id, reg_code "+
				"  FROM sh_res  WHERE car_mng_id = ? and situation='0' and use_yn='Y'";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
			rs = pstmt.executeQuery();
			if(rs.next()){
				bean.setCar_mng_id	(rs.getString("CAR_MNG_ID"));
				bean.setSeq			(rs.getString("SEQ"));
				bean.setDamdang_id	(rs.getString("DAMDANG_ID"));
				bean.setSituation	(rs.getString("SITUATION"));
				bean.setMemo		(rs.getString("MEMO"));
				bean.setReg_dt		(rs.getString("REG_DT"));
				bean.setRes_end_dt	(rs.getString("RES_END_DT")==null?"":rs.getString("RES_END_DT"));
				bean.setRes_st_dt	(rs.getString("RES_ST_DT")==null?"":rs.getString("RES_ST_DT"));
				bean.setUse_yn		(rs.getString("USE_YN")==null?"":rs.getString("USE_YN"));
				bean.setCust_nm		(rs.getString("CUST_NM")==null?"":rs.getString("CUST_NM"));
				bean.setCust_tel	(rs.getString("CUST_TEL")==null?"":rs.getString("CUST_TEL"));
				bean.setAdd_cnt		(rs.getString("add_cnt")==null?0:Integer.parseInt(rs.getString("add_cnt")));
				bean.setEst_id 		(rs.getString("EST_ID")==null?"":rs.getString("EST_ID"));
				bean.setReg_code	(rs.getString("REG_CODE")==null?"":rs.getString("REG_CODE"));
				bean.setAdd_cnt_s	(rs.getString("add_cnt_s")==null?0:Integer.parseInt(rs.getString("add_cnt_s")));
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[SecondhandDatabase:getShRes3(String car_mng_id)]"+e);
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
	*	 ������������ ��ȸ 2005.6.14.ȭ.
	*/
	public ShResBean getShRes(String car_mng_id, String damdang_id, String reg_dt){
		getConnection();
		ShResBean bean = new ShResBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = "SELECT car_mng_id, seq, damdang_id, situation, memo, reg_dt, res_st_dt, res_end_dt, use_yn, cust_nm, cust_tel, nvl(add_cnt,0) add_cnt, nvl(add_cnt_s,0) add_cnt_s, est_id, reg_code "+
				"  FROM sh_res WHERE car_mng_id = ? and damdang_id=? and reg_dt=replace(?,'-','') and use_yn is null ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
			pstmt.setString(2, damdang_id);
			pstmt.setString(3, reg_dt);
			rs = pstmt.executeQuery();
			if(rs.next()){
				bean.setCar_mng_id	(rs.getString("CAR_MNG_ID"));
				bean.setSeq			(rs.getString("SEQ"));
				bean.setDamdang_id	(rs.getString("DAMDANG_ID"));
				bean.setSituation	(rs.getString("SITUATION"));
				bean.setMemo		(rs.getString("MEMO"));
				bean.setReg_dt		(rs.getString("REG_DT"));
				bean.setRes_end_dt	(rs.getString("RES_END_DT")==null?"":rs.getString("RES_END_DT"));
				bean.setRes_st_dt	(rs.getString("RES_ST_DT")==null?"":rs.getString("RES_ST_DT"));
				bean.setUse_yn		(rs.getString("USE_YN")==null?"":rs.getString("USE_YN"));
				bean.setCust_nm		(rs.getString("CUST_NM")==null?"":rs.getString("CUST_NM"));
				bean.setCust_tel	(rs.getString("CUST_TEL")==null?"":rs.getString("CUST_TEL"));
				bean.setAdd_cnt		(rs.getString("add_cnt")==null?0:Integer.parseInt(rs.getString("add_cnt")));
				bean.setEst_id 		(rs.getString("EST_ID")==null?"":rs.getString("EST_ID"));
				bean.setReg_code	(rs.getString("REG_CODE")==null?"":rs.getString("REG_CODE"));
				bean.setAdd_cnt_s	(rs.getString("add_cnt_s")==null?0:Integer.parseInt(rs.getString("add_cnt_s")));
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[SecondhandDatabase:getSecondhand(String car_mng_id, String damdang_id, String reg_dt)]"+e);
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
	*	 ������������ ���� 2005.6.14.ȭ.
	*/
	public int shRes_cancel(String car_mng_id, String seq){
		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		int result = 0;

		query = " UPDATE sh_res "+
				" SET use_yn='N'"+
				" WHERE car_mng_id=? AND seq=? ";

		try{

			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
			pstmt.setString(2, seq);
			result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		}catch(SQLException e){
			System.out.println("[SecondhandDatabase:shRes_cancel]"+e);
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
	*	 ������������ ���� 2005.6.14.ȭ.
	*/
	public int shRes_2cng(String car_mng_id, String seq){
		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		int result = 0;

		query = " UPDATE sh_res "+
				" SET situation='2'"+
				" WHERE car_mng_id=? AND seq=? ";

		try{

			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
			pstmt.setString(2, seq);
			result = pstmt.executeUpdate();

			pstmt.close();
			conn.commit();

		}catch(SQLException e){
			System.out.println("[SecondhandDatabase:shRes_2cng]"+e);
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
	*	 ������������ ��ü ���
	*/
	public int shRes_all_cancel(String car_mng_id){
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		String query = "";
		String query2 = "";
		String query3 = "";
		int result = 0;

		query = " UPDATE sh_res "+
				" SET use_yn='N'"+
				" WHERE car_mng_id=? and nvl(use_yn,'Y')='Y' ";

		query2 = " UPDATE car_reg "+
				" SET off_ls='0', prepare='1', secondhand='' "+
				" WHERE car_mng_id=? ";

		query3 = " UPDATE rent_cont "+
				" SET use_st='5' "+
				" WHERE car_mng_id=? and use_st='1' and rent_st='11' ";

		try{

			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
			result = pstmt.executeUpdate();
			pstmt.close();

			pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString(1, car_mng_id);
			result = pstmt2.executeUpdate();
			pstmt2.close();

			pstmt3 = conn.prepareStatement(query3);
			pstmt3.setString(1, car_mng_id);
			result = pstmt3.executeUpdate();
			pstmt3.close();

			conn.commit();

		}catch(SQLException e){
			System.out.println("[SecondhandDatabase:shRes_all_cancel]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
				if(pstmt2 != null) pstmt2.close();
				if(pstmt3 != null) pstmt3.close();
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}
	}

	/**
	*	 ������������ ��ü ���
	*/
	public int shRes_all_cancelRm(String car_mng_id){
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		String query = "";
		String query2 = "";
		String query3 = "";
		int result = 0;

		query = " UPDATE sh_res "+
				" SET use_yn='N'"+
				" WHERE car_mng_id=? and nvl(use_yn,'Y')='Y' ";

		query3 = " UPDATE rent_cont "+
				" SET use_st='5' "+
				" WHERE car_mng_id=? and use_st='1' and rent_st='11' ";

		try{

			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
			result = pstmt.executeUpdate();
			pstmt.close();

			pstmt2 = conn.prepareStatement(query3);
			pstmt2.setString(1, car_mng_id);
			result = pstmt2.executeUpdate();
			pstmt2.close();

			conn.commit();

		}catch(SQLException e){
			System.out.println("[SecondhandDatabase:shRes_all_cancelRm]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
				if(pstmt2 != null) pstmt2.close();
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}
	}

	/**
	*	�������� �縮���� ����� �� ã��- 2005.12.27.ȭ.
	*/
	public String getSecondhand_dt(String car_mng_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String secondhand_dt = "";
		String query = "";

		query = "SELECT secondhand_dt FROM car_reg WHERE car_mng_id=? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
			rs = pstmt.executeQuery();

			while(rs.next()){
				secondhand_dt = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt.close();

		}catch(SQLException e){
			System.out.println("[SecondhandDatabase:getSecondhand_dt(String car_mng_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return secondhand_dt;
		}
	}
	/**
	*	�縮���� ����ϰ� ���뿩�� Ȩ�������� �ø��� ã��- 2006.2.28.ȭ.
	*/
	public Hashtable getUpload(String car_mng_id){
		getConnection();
		Hashtable ht = new Hashtable();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = "SELECT upload_dt, f_getname(upload_id) upload_nm FROM secondhand a WHERE a.car_mng_id=? "+
				" and a.seq = (select max(b.seq) from secondhand b where a.car_mng_id=b.car_mng_id) ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
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

		}catch(SQLException e){
			System.out.println("[SecondhandDatabase:getUpload_dt(String car_mng_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return ht;
		}
	}

	//�縮��������Ȳ
	public Vector getSecondhandList_20070516(String gubun, String gubun_nm, String brch_id, String sort_gubun)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
 
		query = " select"+
				" a.rent_mng_id, a.rent_l_cd, b.car_mng_id, b.car_no, b.car_nm, d.car_name, b.init_reg_dt, b.dpm,"+
				" cd2.nm as fuel_kd,"+
				" c.opt, c.COLO,"+
				" (c.car_cs_amt+c.car_cv_amt+c.opt_cs_amt+c.opt_cv_amt+c.clr_cs_amt+c.clr_cv_amt) car_c_amt,"+
				" (c.car_fs_amt+c.car_fv_amt+c.sd_cs_amt+c.sd_cv_amt-c.dc_cs_amt-c.dc_cv_amt) car_f_amt,"+
				" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(a.dlv_dt,b.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(a.dlv_dt,b.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST,"+
				" decode(nvl(l.accid_cnt,0),0,'-','��') accid_yn,"+
				" /*��  ��*/decode(e.lev,'1','��','2','��','3','��','') lev, e.reason, k.user_nm as lev_nm,"+
				" /*������*/nvl(h.ret_plan_dt,i.ret_plan_dt) as ret_plan_dt, decode(b.off_ls,'3','���'||o.actn_dt,'1','�Ű�����',decode(nvl(h.rent_st,i.rent_st),'1','�ܱ�뿩','2','�������','3','������','9','�������','10','��������','4','�����뿩','5','�����뿩','6','��������','7','��������','8','������','11','������','12','����Ʈ','���')) rent_st,"+
				" /*�縮��*/b.secondhand_dt,"+
				" /*�����*/o.actn_dt, to_char(to_date(o.actn_dt,'YYYYMMDD')+7,'YYYYMMDD') actn_est_dt,"+
				" /*��  ��*/decode(g.situation,'0','�����','1','���������','2','���Ȯ��','3','��࿬��','���డ��') situation, g.memo, g.reg_dt, m.user_nm as situ_nm,"+
				" /*���ε�*/nvl(f.upload_dt,'�̰���') as upload_dt,"+
				" decode(nvl(b.off_ls,'0'),'3',decode(o.actn_st,'1','���������','2','����','3','�������','4','����','��ǰ����'),'') actn_st, "+
				" decode(b.park,'6',substr(b.park_cont,1,5),nvl(cd.nm,b.park))  park,"+
				" TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(replace(b.init_reg_dt,'-',''), 'YYYYMMDD'))) use_mon, e.imgfile1, e.imgfile6"+
				" from   cont a, car_reg b, car_etc c, car_nm d, apprsl e, users k, users m, v_tot_dist vt, "+
				"        (select * from secondhand a where a.seq = (select max(seq) from secondhand where car_mng_id=a.car_mng_id)) f,"+
				"        (select * from sh_res a     where a.seq = (select max(seq) from sh_res     where car_mng_id=a.car_mng_id)) g,"+ //(����������� ������ ���Ǹ� ���)
				"        (select * from rent_cont a  where a.use_st = '2') h,"+
				"        (select * from rent_cont a  where a.use_st = '1') i,"+
				"        (select * from service a    where a.tot_dist is not null and a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where tot_dist is not null and car_mng_id = a.car_mng_id)) j,"+
				"        (select car_mng_id, count(0) accid_cnt from accident group by car_mng_id) l,"+
				"        ( select c_st, code, nm_cd, nm from code where c_st = '0027') cd,  \n"+  //������ 
				"        ( select c_st, code, nm_cd, nm from code where c_st = '0039') cd2, \n"+				
				"        (select * from auction a where a.seq = (select max(seq) from auction where car_mng_id=a.car_mng_id)) o"+
				" where"+
				" nvl(a.use_yn,'Y')='Y' and a.car_st='2' and b.secondhand='1' "+
				" and nvl(b.off_ls,'0') not in ('5','6') "+
				" and a.car_mng_id=b.car_mng_id"+
				" and a.rent_l_cd=c.rent_l_cd"+
				" and c.car_id=d.car_id and c.car_seq=d.car_seq"+
				" and b.car_mng_id=e.car_mng_id(+)"+
				" and e.damdang_id=k.user_id(+)"+
				" and g.damdang_id=m.user_id(+)"+
				" and a.car_mng_id=vt.car_mng_id(+)"+
				" and b.car_mng_id=f.car_mng_id(+)"+
				" and b.car_mng_id=g.car_mng_id(+)"+
				" and b.car_mng_id=h.car_mng_id(+)"+
				" and b.car_mng_id=i.car_mng_id(+)"+
				" and b.car_mng_id=j.car_mng_id(+)"+
				" and b.car_mng_id=l.car_mng_id(+)"+
				" and b.park = cd.nm_cd(+) \n"+  //������ �ڵ� ���̺� 
				" and b.fuel_kd = cd2.nm_cd \n"+  
				" and a.car_mng_id=o.car_mng_id(+)"+
				" ";

		if(gubun.equals("car_no"))			query += " and b.car_no like '%"+gubun_nm+"%'";
		if(gubun.equals("car_nm"))			query += " and b.car_nm||d.car_name like '%"+gubun_nm+"%'";
		if(gubun.equals("init_reg_dt"))		query += " and b.init_reg_dt like replace('"+ gubun_nm +"','-','')||'%'";

		if(!brch_id.equals(""))				query += " and a.brch_id='"+brch_id+"'";

		query += " order by decode(g.situation,'',1,'0',2,'1',3,'2',4) ";

		if(sort_gubun.equals("car_nm"))				query += ", b.car_nm||d.car_name";
		else if(sort_gubun.equals("car_no"))		query += ", b.car_no ";
		else if(sort_gubun.equals("init_reg_dt"))	query += ", b.init_reg_dt desc ";
		else if(sort_gubun.equals("fuel_kd"))		query += ", b.fuel_kd, b.dpm desc";
		else if(sort_gubun.equals("dpm"))			query += ", b.fuel_kd, b.dpm desc, b.car_nm||d.car_name  ";
		else										query += ", b.fuel_kd, b.dpm DESC, b.car_nm||d.car_name  ";

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
			System.out.println("[SecondhandDatabase:getSecondhandList_20070516]\n"+e);
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

	//�縮��������Ȳ
	public Vector getSecondhandList_20090507(String gubun2, String gubun, String gubun_nm, String brch_id, String sort_gubun)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" a.rent_mng_id, a.rent_l_cd, b.car_mng_id, b.car_no, b.car_nm, d.car_name, b.init_reg_dt, b.dpm,"+
				" cd2.nm as fuel_kd,"+
				" c.opt, c.COLO,"+
				" (c.car_cs_amt+c.car_cv_amt+c.opt_cs_amt+c.opt_cv_amt+c.clr_cs_amt+c.clr_cv_amt) car_c_amt,"+
				" (c.car_fs_amt+c.car_fv_amt+c.sd_cs_amt+c.sd_cv_amt-c.dc_cs_amt-c.dc_cv_amt) car_f_amt,"+
				" decode(j.tot_dist,'',0,'0',0,decode(j.serv_dt,nvl(a.dlv_dt,b.init_reg_dt),0,j.tot_dist+round(j.tot_dist/(to_date(j.serv_dt,'YYYYMMDD')-to_date(nvl(a.dlv_dt,b.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(j.serv_dt,'YYYYMMDD')))) as TODAY_DIST,"+
				" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(a.dlv_dt,b.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(a.dlv_dt,b.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST2,"+
				" decode(nvl(l.accid_cnt,0),0,'-','��') accid_yn,"+
				" /*��  ��*/decode(e.lev,'1','��','2','��','3','��','') lev, e.reason, k.user_nm as lev_nm,"+
				" /*������*/nvl(h.ret_plan_dt,i.ret_plan_dt) as ret_plan_dt, decode(b.off_ls,'3','���'||o.actn_dt,'1','�Ű�����',decode(nvl(h.rent_st,i.rent_st),'1','�ܱ�뿩','2','�������','3','������','9','�������','10','��������','4','�����뿩','5','�����뿩','6','��������','7','��������','8','������','11','������','12','����Ʈ','���')) rent_st,"+
				" /*�縮��*/b.secondhand_dt,"+
				" /*�����*/o.actn_dt, to_char(to_date(o.actn_dt,'YYYYMMDD')+7,'YYYYMMDD') actn_est_dt,"+
				" /*��  ��*/decode(g.situation,'0','�����','1','���������','2','���Ȯ��','3','��࿬��','���డ��') situation, g.memo, g.reg_dt, m.user_nm as situ_nm, g.res_st_dt, g.res_end_dt, g2.res_cnt,"+
				" /*���ε�*/nvl(f.upload_dt,'�̰���') as upload_dt, decode(f.rb36, 0,f.lb36, -1,f.lb36, f.rb36) fee_amt, decode(f.rb30, 0,f.lb30, -1,f.lb30, f.rb30) fee_amt_30, "+
				" decode(nvl(b.off_ls,'0'),'3',decode(o.actn_st,'1','���������','2','����','3','�������','4','����','��ǰ����'),'') actn_st, "+				
				" decode(b.park,'6',substr(b.park_cont,1,5),nvl(cd.nm,b.park)) park,"+
				" TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(replace(b.init_reg_dt,'-',''), 'YYYYMMDD'))) use_mon, e.imgfile1, e.imgfile6,"+
				" decode(b.gps,'Y','����') gps, j.serv_dt, d.jg_code,"+
				" decode(cc.rent_l_cd,'','','�����ݳ�') call_in_st "+
				" from cont a, car_reg b, car_etc c, car_nm d, apprsl e, users k, users m,"+
				"        ( select c_st, code, nm_cd, nm from code where c_st = '0027') cd,  \n"+  //������ 
				"        ( select c_st, code, nm_cd, nm from code where c_st = '0039') cd2, \n"+
				" (select * from secondhand a where a.seq = (select max(seq) from secondhand where car_mng_id=a.car_mng_id)) f,"+
				" (select * from sh_res a     where a.use_yn='Y' and a.situation in ('0','2')) g,"+ //(����������� ������ ���Ǹ� ���)
				" (select a.car_mng_id, count(0) res_cnt from sh_res a     where a.use_yn is null and a.situation in ('0','2') group by a.car_mng_id) g2,"+ //(����������� ������ ���Ǹ� ���)
				" (select * from rent_cont a  where a.use_st = '2' and a.rent_st<>'11') h,"+
				" (select * from rent_cont a  where a.use_st = '1' and a.rent_st<>'11') i,"+
				" (select * from service a    where a.tot_dist is not null and a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where tot_dist is not null and car_mng_id = a.car_mng_id)) j,"+
				" (select car_mng_id, count(0) accid_cnt from accident group by car_mng_id) l,"+
				" (select * from auction a where a.seq = (select max(seq) from auction where car_mng_id=a.car_mng_id)) o, v_tot_dist vt,"+
	            //���������ݳ�
				"       ( select * from car_call_in where in_st='3' and out_dt is null ) cc "+
				" where"+
				" nvl(a.use_yn,'Y')='Y' and b.secondhand='1' "+
				" and nvl(b.prepare,'0')<>'7'"+
				" and nvl(b.off_ls,'0') in ('0','1') "+			//��ǰ������ 20100126
				" and a.car_mng_id=b.car_mng_id"+
				" and a.rent_l_cd=c.rent_l_cd"+
				" and c.car_id=d.car_id and c.car_seq=d.car_seq"+
				" and b.car_mng_id=e.car_mng_id(+)"+
				" and b.car_mng_id=f.car_mng_id(+)"+
				" and b.car_mng_id=g.car_mng_id(+)"+
				" and b.car_mng_id=g2.car_mng_id(+)"+
				" and b.car_mng_id=h.car_mng_id(+)"+
				" and b.car_mng_id=i.car_mng_id(+)"+
				" and b.car_mng_id=j.car_mng_id(+)"+
				" and e.damdang_id=k.user_id(+)"+
				" and b.car_mng_id=l.car_mng_id(+)"+
				" and a.car_mng_id=o.car_mng_id(+)"+
				" and a.car_mng_id=vt.car_mng_id(+)"+
				" and g.damdang_id=m.user_id(+)"+
				" and a.rent_mng_id=cc.rent_mng_id(+) and a.rent_l_cd=cc.rent_l_cd(+)"+
				" and b.park = cd.nm_cd(+) \n"+  //������ �ڵ� ���̺� 
				" and b.fuel_kd = cd2.nm_cd \n"+ 
				" and decode(cc.rent_l_cd,'',a.car_st,'')='2'"+
				" "	;

		if(gubun.equals("car_no"))			query += " and b.car_no like '%"+gubun_nm+"%'";
		if(gubun.equals("car_nm"))			query += " and b.car_nm||d.car_name like '%"+gubun_nm+"%'";
		if(gubun.equals("init_reg_dt"))		query += " and b.init_reg_dt like replace('"+ gubun_nm +"','-','')||'%'";

		if(!brch_id.equals(""))				query += " and a.brch_id='"+brch_id+"'";
 
		if(gubun2.equals("1"))			query += " and d.jg_code like '4%' and d.car_comp_id <= '0005' and b.fuel_kd not in ('3','5','6')"; //�����¿�
		else if(gubun2.equals("2"))		query += " and d.jg_code like '3%' and d.car_comp_id <= '0005' and b.fuel_kd not in ('3','5','6')"; //�����¿�
		else if(gubun2.equals("3"))		query += " and d.jg_code between '1000000' and '2999999' and d.car_comp_id <= '0005' and b.fuel_kd not in ('3','5','6')"; //�����¿�
		else if(gubun2.equals("4"))		query += " and d.jg_code like '4%' and d.car_comp_id <= '0005' and b.fuel_kd in ('3','5','6')"; //�����¿�LPG
		else if(gubun2.equals("5"))		query += " and d.jg_code like '3%' and d.car_comp_id <= '0005' and b.fuel_kd in ('3','5','6')"; //���������¿�LPG
		else if(gubun2.equals("8"))		query += " and d.jg_code between '1000000' and '2999999' and d.car_comp_id <= '0005' and b.fuel_kd in ('3','5','6')"; //�����¿�LPG
		else if(gubun2.equals("6"))		query += " and d.jg_code between '5000000' and '9999999' and d.car_comp_id <= '0005' "; //���� RV�ױ�Ÿ(����,ȭ��)
		else if(gubun2.equals("7"))		query += " and d.car_comp_id > '0005' "; //������

		if(sort_gubun.equals("car_kind")){

			//20101021 : ����LPG,����LPG,����LPG,����,����,����,RV,���� ������ ���� ����
			query += " ORDER BY decode(nvl(g.situation,'0'), '2',1, 0), "+ //���Ȯ���� �ǾƷ���
					 "          decode(d.car_comp_id, '0001',0, '0002',0, '0003',0, '0004',0, '0005',0, 1), "+ //�������� ��, �������� �Ʒ���
				     "          decode(b.fuel_kd, '3',0, '5',0, '6',0, 1), "+//LPG����
				     "          d.jg_code, d.car_b_p, d.car_name, b.init_reg_dt, b.car_mng_id ";

		}else if(sort_gubun.equals("situation")){

			query += " order by decode(g.situation,'',1,'0',2,'1',3,'2',4) ";

			query += ", b.fuel_kd, b.dpm DESC, b.car_nm||d.car_name  ";

		}else{

			if(sort_gubun.equals("today_dist2")){
				query += " order by decode(nvl(g.situation,'0'),'2',1,0), decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(a.dlv_dt,b.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(a.dlv_dt,b.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD'))))";
			}else{
				query += " order by decode(nvl(g.situation,'0'),'2',1,0) ";

				if(sort_gubun.equals("car_nm"))				query += ", b.car_nm||d.car_name";
				else if(sort_gubun.equals("car_no"))		query += ", b.car_no ";
				else if(sort_gubun.equals("init_reg_dt"))	query += ", b.init_reg_dt ";
				else if(sort_gubun.equals("fuel_kd"))		query += ", cd2.nm ";
				else if(sort_gubun.equals("dpm"))			query += ", b.fuel_kd, b.dpm desc, b.car_nm||d.car_name  ";
				else if(sort_gubun.equals("secondhand_dt"))	query += ", b.secondhand_dt ";
				else if(sort_gubun.equals("colo"))			query += ", c.colo ";
				else if(sort_gubun.equals("fee_amt"))		query += ", decode(f.rb36, 0,f.lb36, -1,f.lb36, f.rb36) ";
				else										query += ", b.fuel_kd, b.dpm DESC, b.car_nm||d.car_name  ";
			}


			//20101021 : ����LPG,����LPG,����LPG,����,����,����,RV,���� ������ ���� ����
			query += "   , decode(d.car_comp_id, '0001',0, '0002',0, '0003',0, '0004',0, '0005',0, 1), "+ //�������� ��, �������� �Ʒ���
				     "          decode(b.fuel_kd, '3',0, '5',0, '6',0, 1), "+//LPG����
				     "          d.jg_code, d.car_b_p, d.car_name, b.init_reg_dt, b.car_mng_id ";


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
			System.out.println("[SecondhandDatabase:getSecondhandList_20090507]\n"+e);
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

	//�縮��������Ȳ
	public Vector getSecondhandList_20110216(String gubun2, String gubun, String gubun_nm, String brch_id, String sort_gubun, String res_yn)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" a.rent_mng_id, a.rent_l_cd, b.car_mng_id, b.car_no, b.car_nm, d.car_name, b.init_reg_dt, b.dpm,"+
				" cd2.nm as fuel_kd,"+
				" c.opt, "+
				" c.colo||decode(c.in_col,'','','(����:'||c.in_col||')') as colo, "+
				" (c.car_cs_amt+c.car_cv_amt+c.opt_cs_amt+c.opt_cv_amt+c.clr_cs_amt+c.clr_cv_amt) car_c_amt,"+
				" (c.car_fs_amt+c.car_fv_amt+c.sd_cs_amt+c.sd_cv_amt-c.dc_cs_amt-c.dc_cv_amt) car_f_amt,"+
				" decode(j.tot_dist,'',0,'0',0,decode(j.serv_dt,nvl(a.dlv_dt,b.init_reg_dt),0,j.tot_dist+round(j.tot_dist/(to_date(j.serv_dt,'YYYYMMDD')-to_date(nvl(a.dlv_dt,b.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(j.serv_dt,'YYYYMMDD')))) as TODAY_DIST,"+
				" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(a.dlv_dt,b.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(a.dlv_dt,b.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST2,"+
				" decode(nvl(l.accid_cnt,0),0,'-','��') accid_yn,"+
				" /*��  ��*/decode(e.lev,'1','��','2','��','3','��','') lev, e.reason, k.user_nm as lev_nm,"+
				" /*������*/nvl(h.ret_plan_dt,i.ret_plan_dt) as ret_plan_dt, decode(b.off_ls,'3','���'||o.actn_dt,'1','�Ű�����',decode(nvl(h.rent_st,i.rent_st),'1','�ܱ�뿩','2','�������','3','������','9','�������','10','��������','4','�����뿩','5','�����뿩','6','��������','7','��������','8','������','11','������','12','����Ʈ','���')) rent_st,"+
				" /*�縮��*/b.secondhand_dt,"+
				" /*�����*/o.actn_dt, to_char(to_date(o.actn_dt,'YYYYMMDD')+7,'YYYYMMDD') actn_est_dt,"+
				" /*��  ��*/decode(g.situation,'0','�����','1','���������','2','���Ȯ��','3','��࿬��','���డ��') situation, g.memo, g.reg_dt, m.user_nm as situ_nm, g.res_st_dt, g.res_end_dt, g2.res_cnt,"+
				" /*���ε�*/nvl(f.upload_dt,'�̰���') as upload_dt, decode(f.rb36, 0,f.lb36, -1,f.lb36, f.rb36) fee_amt, decode(f.rb30, 0,f.lb30, -1,f.lb30, f.rb30) fee_amt_30, "+
				" NVL(f.rb36, f.rs36) rb, NVL(f.lb36, f.ls36) lb,	"+
				" decode(nvl(b.off_ls,'0'),'3',decode(o.actn_st,'1','���������','2','����','3','�������','4','����','��ǰ����'),'') actn_st, "+				
				" decode(b.park,'6',substr(b.park_cont,1,5),nvl(cd.nm,b.park)) park, b.park_cont, "+
				" TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(replace(b.init_reg_dt,'-',''), 'YYYYMMDD'))) use_mon, e.imgfile1, e.imgfile6,"+
				" decode(b.gps,'Y','����') gps, j.serv_dt, d.jg_code,"+
				" decode(cc.rent_l_cd,'','','�����ݳ�') call_in_st "+
				" from cont a, car_reg b, car_etc c, car_nm d, apprsl e, users k, users m,"+
				"        ( select c_st, code, nm_cd, nm from code where c_st = '0027') cd,  \n"+  //������ 
				"        ( select c_st, code, nm_cd, nm from code where c_st = '0039') cd2, \n"+				
				" (select * from secondhand a where a.seq = (select max(seq) from secondhand where car_mng_id=a.car_mng_id)) f,"+
				" (select * from sh_res a     where a.use_yn='Y' and a.situation in ('0','2')) g,"+ //(����������� ������ ���Ǹ� ���)
				" (select a.car_mng_id, count(0) res_cnt from sh_res a     where a.use_yn is null and a.situation in ('0','2') group by a.car_mng_id) g2,"+ //(����������� ������ ���Ǹ� ���)
				" (select * from rent_cont a  where a.use_st = '2' and a.rent_st<>'11') h,"+
				" (select * from rent_cont a  where a.use_st = '1' and a.rent_st<>'11') i,"+
				" (select * from service a    where a.tot_dist is not null and a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where tot_dist is not null and car_mng_id = a.car_mng_id)) j,"+
				" (select car_mng_id, count(0) accid_cnt from accident group by car_mng_id) l,"+
				" (select * from auction a where a.seq = (select max(seq) from auction where car_mng_id=a.car_mng_id)) o, v_tot_dist vt,"+
	            //���������ݳ�
				"       ( select * from car_call_in where in_st='3' and out_dt is null ) cc "+
				" where"+
				" nvl(a.use_yn,'Y')='Y' and b.secondhand='1' "+
				" and nvl(b.prepare,'0')<>'7'"+
				" and nvl(b.off_ls,'0') in ('0','1') "+			//��ǰ������ 20100126
				" and a.car_mng_id=b.car_mng_id"+
				" and a.rent_l_cd=c.rent_l_cd"+
				" and c.car_id=d.car_id and c.car_seq=d.car_seq"+
				" and b.car_mng_id=e.car_mng_id(+)"+
				" and b.car_mng_id=f.car_mng_id(+)"+
				" and b.car_mng_id=g.car_mng_id(+)"+
				" and b.car_mng_id=g2.car_mng_id(+)"+
				" and b.car_mng_id=h.car_mng_id(+)"+
				" and b.car_mng_id=i.car_mng_id(+)"+
				" and b.car_mng_id=j.car_mng_id(+)"+
				" and e.damdang_id=k.user_id(+)"+
				" and b.car_mng_id=l.car_mng_id(+)"+
				" and a.car_mng_id=o.car_mng_id(+)"+
				" and a.car_mng_id=vt.car_mng_id(+)"+
				" and g.damdang_id=m.user_id(+)"+
				" and a.rent_mng_id=cc.rent_mng_id(+) and a.rent_l_cd=cc.rent_l_cd(+)"+
				" and b.park = cd.nm_cd(+) \n"+  //������ �ڵ� ���̺� 
				" and b.fuel_kd = cd2.nm_cd \n"+  
				" and decode(cc.rent_l_cd,'',a.car_st,'')='2'"+
				" "	;

		if(res_yn.equals("Y"))			query += " and nvl(g.situation,'-') not in ('0','2')";

		if(gubun.equals("car_no"))			query += " and b.car_no like '%"+gubun_nm+"%'";
		if(gubun.equals("car_nm"))			query += " and b.car_nm||d.car_name like '%"+gubun_nm+"%'";
		if(gubun.equals("init_reg_dt"))		query += " and b.init_reg_dt like replace('"+ gubun_nm +"','-','')||'%'";

		if(!brch_id.equals(""))				query += " and a.brch_id='"+brch_id+"'";


		if(gubun2.equals("1"))			query += " and d.jg_code like '4%' and d.car_comp_id <= '0005' and b.fuel_kd not in ('3','5','6')"; //�����¿�
		else if(gubun2.equals("2"))		query += " and d.jg_code like '3%' and d.car_comp_id <= '0005' and b.fuel_kd not in ('3','5','6')"; //�����¿�
		else if(gubun2.equals("3"))		query += " and d.jg_code between '1000000' and '2999999' and d.car_comp_id <= '0005' and b.fuel_kd not in ('3','5','6')"; //�����¿�
		else if(gubun2.equals("4"))		query += " and d.jg_code like '4%' and d.car_comp_id <= '0005' and b.fuel_kd in ('3','5','6')"; //�����¿�LPG
		else if(gubun2.equals("5"))		query += " and d.jg_code like '3%' and d.car_comp_id <= '0005' and b.fuel_kd in ('3','5','6')"; //���������¿�LPG
		else if(gubun2.equals("8"))		query += " and d.jg_code between '1000000' and '2999999' and d.car_comp_id <= '0005' and b.fuel_kd in ('3','5','6')"; //�����¿�LPG
		else if(gubun2.equals("6"))		query += " and d.jg_code between '5000000' and '9999999' and d.car_comp_id <= '0005' "; //���� RV�ױ�Ÿ(����,ȭ��)
		else if(gubun2.equals("7"))		query += " and d.car_comp_id > '0005' "; //������

		if(sort_gubun.equals("car_kind")){


			//20101021 : ����LPG,����LPG,����LPG,����,����,����,RV,���� ������ ���� ����
			query += " ORDER BY decode(nvl(g.situation,'0'), '2',1, 0), "+ //���Ȯ���� �ǾƷ���
					 "          decode(d.car_comp_id, '0001',0, '0002',0, '0003',0, '0004',0, '0005',0, 1), "+ //�������� ��, �������� �Ʒ���
				     "          decode(b.fuel_kd, '3',0, '5',0, '6',0, 1), "+//LPG����
				     "          d.jg_code, d.car_b_p, d.car_name, b.init_reg_dt, b.car_mng_id ";

		}else if(sort_gubun.equals("situation")){

			query += " order by decode(g.situation,'',1,'0',2,'1',3,'2',4) ";

			query += ", b.fuel_kd, b.dpm DESC, b.car_nm||d.car_name  ";

		}else{

			if(sort_gubun.equals("today_dist2")){
				query += " order by decode(nvl(g.situation,'0'),'2',1,0), decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(a.dlv_dt,b.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(a.dlv_dt,b.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD'))))";
			}else{
				query += " order by decode(nvl(g.situation,'0'),'2',1,0) ";

				if(sort_gubun.equals("car_nm"))				query += ", b.car_nm||d.car_name";
				else if(sort_gubun.equals("car_no"))		query += ", b.car_no ";
				else if(sort_gubun.equals("init_reg_dt"))	query += ", b.init_reg_dt ";
				else if(sort_gubun.equals("fuel_kd"))		query += ", cd2.nm ";
				else if(sort_gubun.equals("dpm"))			query += ", b.fuel_kd, b.dpm desc, b.car_nm||d.car_name  ";
				else if(sort_gubun.equals("secondhand_dt"))	query += ", b.secondhand_dt ";
				else if(sort_gubun.equals("colo"))			query += ", c.colo ";
				else if(sort_gubun.equals("fee_amt"))		query += ", decode(f.rb36, 0,f.lb36, -1,f.lb36, f.rb36) ";
				else										query += ", b.fuel_kd, b.dpm DESC, b.car_nm||d.car_name  ";
			}


			//20101021 : ����LPG,����LPG,����LPG,����,����,����,RV,���� ������ ���� ����
			query += "   , decode(d.car_comp_id, '0001',0, '0002',0, '0003',0, '0004',0, '0005',0, 1), "+ //�������� ��, �������� �Ʒ���
				     "          decode(b.fuel_kd, '3',0, '5',0, '6',0, 1), "+//LPG����
				     "          d.jg_code, d.car_b_p, d.car_name, b.init_reg_dt, b.car_mng_id ";


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
			System.out.println("[SecondhandDatabase:getSecondhandList_20110216]\n"+e);
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

	//�縮��������Ȳ
	public Vector getSecondhandList_20120418(String gubun2, String gubun, String gubun_nm, String brch_id, String sort_gubun, String res_yn, String res_mon_yn)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select "+
				"        a.rent_mng_id, a.rent_l_cd, b.car_mng_id, b.car_no, b.car_nm, d.car_name, b.init_reg_dt, b.dpm, \n"+
				"        cd2.nm as fuel_kd,  \n"+
				"        c.opt,   c.colo||decode(c.in_col,'','','(����:'||c.in_col||')') as colo,  \n"+
				"        (c.car_cs_amt+c.car_cv_amt+c.opt_cs_amt+c.opt_cv_amt+c.clr_cs_amt+c.clr_cv_amt) car_c_amt,  \n"+
				"        (c.car_fs_amt+c.car_fv_amt+c.sd_cs_amt+c.sd_cv_amt-c.dc_cs_amt-c.dc_cv_amt) car_f_amt,  \n"+
				"        decode(j.tot_dist,'',0,'0',0,decode(j.serv_dt,nvl(a.dlv_dt,b.init_reg_dt),0,j.tot_dist+round(j.tot_dist/(to_date(j.serv_dt,'YYYYMMDD')-to_date(nvl(a.dlv_dt,b.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(j.serv_dt,'YYYYMMDD')))) as TODAY_DIST,   \n"+
				"        decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(a.dlv_dt,b.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(a.dlv_dt,b.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST2,   \n"+
				"        decode(nvl(l.accid_cnt,0),0,'-','��') accid_yn,  \n"+
				"        /*��  ��*/decode(e.lev,'1','��','2','��','3','��','') lev, e.reason, k.user_nm as lev_nm , \n"+
				"        /*������*/nvl(h.ret_plan_dt,i.ret_plan_dt) as ret_plan_dt, decode(b.off_ls,'3','���'||o.actn_dt,'1','�Ű�����',decode(nvl(h.rent_st,i.rent_st),'1','�ܱ�뿩','2','�������','3','������','9','�������','10','��������','4','�����뿩','5','�����뿩','6','��������','7','��������','8','������','11','������','12','����Ʈ','���')) rent_st,   \n"+
				"        /*�縮��*/b.secondhand_dt,   \n"+
				"        /*�����*/o.actn_dt, to_char(to_date(o.actn_dt,'YYYYMMDD')+7,'YYYYMMDD') actn_est_dt,  \n"+
				"        /*��  ��*/decode(g.situation,'0','�����','1','���������','2','���Ȯ��','3','��࿬��','���డ��') situation, g.memo, g.reg_dt, m.user_nm as situ_nm, g.res_st_dt, g.res_end_dt, g2.res_cnt,  \n"+
				"        /*���ε�*/nvl(f.upload_dt,'�̰���') as upload_dt, decode(f.rb36, 0,f.lb36, -1,f.lb36, f.rb36) fee_amt, decode(f.rb30, 0,f.lb30, -1,f.lb30, f.rb30) fee_amt_30, f.rm1, NVL(f.rb36, f.rs36) rb, NVL(f.lb36, f.ls36) lb,  \n"+
				"        decode(nvl(b.off_ls,'0'),'3',decode(o.actn_st,'1','���������','2','����','3','�������','4','����','��ǰ����'),'') actn_st, \n"+
				"        decode(b.park,'6',substr(b.park_cont,1,5),nvl(cd.nm,b.park)) park, b.park_cont,  \n"+
				"        TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(replace(b.init_reg_dt,'-',''), 'YYYYMMDD'))) use_mon, e.imgfile1, e.imgfile6, e.img_dt,  \n"+
				"        decode(b.gps,'Y','����') gps, j.serv_dt, d.jg_code,  \n"+
				"        decode(cc.rent_l_cd,'','','�����ݳ�') call_in_st, decode(b.rm_st,'1','���','6','��Ÿ',' ') rm_st, b.rm_cont  \n"+
				" from cont a, car_reg b, car_etc c, car_nm d, apprsl e, users k, users m,   \n"+
				"        ( select c_st, code, nm_cd, nm from code where c_st = '0027') cd,  \n"+  //������ 
				"        ( select c_st, code, nm_cd, nm from code where c_st = '0039') cd2,  \n"+ 
				"        (select * from secondhand a where a.seq = (select max(seq) from secondhand where car_mng_id=a.car_mng_id)) f,   \n"+
				"        (select * from sh_res a     where a.use_yn='Y' and a.situation in ('0','2')) g,  \n"+  //(����������� ������ ���Ǹ� ���)
				"        (select a.car_mng_id, count(0) res_cnt from sh_res a     where a.use_yn is null and a.situation in ('0','2') group by a.car_mng_id) g2,   \n"+ //(����������� ������ ���Ǹ� ���)
				"        (select * from rent_cont a  where a.use_st = '2' and a.rent_st<>'11') h,   \n"+
				"        (select * from rent_cont a  where a.use_st = '1' and a.rent_st<>'11') i, \n"+
				"        (select * from service a    where a.tot_dist is not null and a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where tot_dist is not null and car_mng_id = a.car_mng_id)) j, \n"+
				"        (select car_mng_id, count(0) accid_cnt from accident group by car_mng_id) l, \n"+
				"        (select * from auction a where a.seq = (select max(seq) from auction where car_mng_id=a.car_mng_id)) o, v_tot_dist vt, \n"+
	            //���������ݳ�
				"        ( select * from car_call_in where in_st='3' and out_dt is null ) cc  \n"+
				" where"+
				"        nvl(a.use_yn,'Y')='Y' and b.secondhand='1'  \n"+
				"        and nvl(b.prepare,'0')<>'7'  \n"+
				"        and nvl(b.off_ls,'0') in ('0','1')  \n"+			//��ǰ������ 20100126
				"        and a.car_mng_id=b.car_mng_id \n"+
				"        and a.rent_l_cd=c.rent_l_cd \n"+
				"        and c.car_id=d.car_id and c.car_seq=d.car_seq  \n"+
				"        and b.car_mng_id=e.car_mng_id(+)  \n"+
				"        and b.car_mng_id=f.car_mng_id(+)  \n"+
				"        and b.car_mng_id=g.car_mng_id(+)  \n"+
				"        and b.car_mng_id=g2.car_mng_id(+)  \n"+
				"        and b.car_mng_id=h.car_mng_id(+)  \n"+
				"        and b.car_mng_id=i.car_mng_id(+)  \n"+
				"        and b.car_mng_id=j.car_mng_id(+)  \n"+
				"        and e.damdang_id=k.user_id(+)  \n"+
				"        and b.car_mng_id=l.car_mng_id(+)  \n"+
				"        and a.car_mng_id=o.car_mng_id(+)  \n"+
				"        and a.car_mng_id=vt.car_mng_id(+)  \n"+
				"        and g.damdang_id=m.user_id(+)  \n"+
				"        and a.rent_mng_id=cc.rent_mng_id(+) and a.rent_l_cd=cc.rent_l_cd(+)  \n"+
				"        and b.park = cd.nm_cd(+) \n"+  //������ �ڵ� ���̺� 
				"        and b.fuel_kd = cd2.nm_cd \n"+ 
				"        and decode(cc.rent_l_cd,'',a.car_st,'')='2'  \n"+
				" "	;

		if(res_yn.equals("Y"))				query += " and nvl(g.situation,'-') not in ('0','2')";

		if(res_mon_yn.equals("Y"))			query += " and b.car_use='1'";

		if(gubun.equals("car_no"))			query += " and b.car_no like '%"+gubun_nm+"%'";
		if(gubun.equals("car_nm"))			query += " and b.car_nm||d.car_name like '%"+gubun_nm+"%'";
		if(gubun.equals("init_reg_dt"))		query += " and b.init_reg_dt like replace('"+ gubun_nm +"','-','')||'%'";

		if(!brch_id.equals(""))				query += " and a.brch_id='"+brch_id+"'";


		if(gubun2.equals("1"))			query += " and d.jg_code like '4%' and d.car_comp_id <= '0005' and b.fuel_kd not in ('3','5','6')"; //�����¿�
		else if(gubun2.equals("2"))		query += " and d.jg_code like '3%' and d.car_comp_id <= '0005' and b.fuel_kd not in ('3','5','6')"; //�����¿�
		else if(gubun2.equals("3"))		query += " and d.jg_code between '1000000' and '2999999' and d.car_comp_id <= '0005' and b.fuel_kd not in ('3','5','6')"; //�����¿�
		else if(gubun2.equals("4"))		query += " and d.jg_code like '4%' and d.car_comp_id <= '0005' and b.fuel_kd in ('3','5','6')"; //�����¿�LPG
		else if(gubun2.equals("5"))		query += " and d.jg_code like '3%' and d.car_comp_id <= '0005' and b.fuel_kd in ('3','5','6')"; //���������¿�LPG
		else if(gubun2.equals("8"))		query += " and d.jg_code between '1000000' and '2999999' and d.car_comp_id <= '0005' and b.fuel_kd in ('3','5','6')"; //�����¿�LPG
		else if(gubun2.equals("6"))		query += " and d.jg_code between '5000000' and '9999999' and d.car_comp_id <= '0005' "; //���� RV�ױ�Ÿ(����,ȭ��)
		else if(gubun2.equals("7"))		query += " and d.car_comp_id > '0005' "; //������

		if(sort_gubun.equals("car_kind")){


			//20101021 : ����LPG,����LPG,����LPG,����,����,����,RV,���� ������ ���� ����
			query += " ORDER BY decode(nvl(g.situation,'0'), '2',1, 0), "+ //���Ȯ���� �ǾƷ���
					 "          decode(d.car_comp_id, '0001',0, '0002',0, '0003',0, '0004',0, '0005',0, 1), "+ //�������� ��, �������� �Ʒ���
				     "          decode(b.fuel_kd, '3',0, '5',0, '6',0, 1), "+//LPG����
				     "          d.jg_code, d.car_b_p, d.car_name, b.init_reg_dt, b.car_mng_id ";

		}else if(sort_gubun.equals("situation")){

			query += " order by decode(g.situation,'',1,'0',2,'1',3,'2',4) ";

			query += ", b.fuel_kd, b.dpm DESC, b.car_nm||d.car_name  ";

		}else{

			if(sort_gubun.equals("today_dist2")){
				query += " order by decode(nvl(g.situation,'0'),'2',1,0), decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(a.dlv_dt,b.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(a.dlv_dt,b.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD'))))";
			}else{
				query += " order by decode(nvl(g.situation,'0'),'2',1,0) ";

				if(sort_gubun.equals("car_nm"))				query += ", b.car_nm||d.car_name";
				else if(sort_gubun.equals("car_no"))		query += ", b.car_no ";
				else if(sort_gubun.equals("init_reg_dt"))	query += ", b.init_reg_dt ";
				else if(sort_gubun.equals("fuel_kd"))		query += ", cd2.nm  ";
				else if(sort_gubun.equals("dpm"))			query += ", b.fuel_kd, b.dpm desc, b.car_nm||d.car_name  ";
				else if(sort_gubun.equals("secondhand_dt"))	query += ", b.secondhand_dt ";
				else if(sort_gubun.equals("colo"))			query += ", c.colo ";
				else if(sort_gubun.equals("fee_amt"))		query += ", decode(f.rb36, 0,f.lb36, -1,f.lb36, f.rb36) ";
				else										query += ", b.fuel_kd, b.dpm DESC, b.car_nm||d.car_name  ";
			}


			//20101021 : ����LPG,����LPG,����LPG,����,����,����,RV,���� ������ ���� ����
			query += "   , decode(d.car_comp_id, '0001',0, '0002',0, '0003',0, '0004',0, '0005',0, 1), "+ //�������� ��, �������� �Ʒ���
				     "          decode(b.fuel_kd, '3',0, '5',0, '6',0, 1), "+//LPG����
				     "          d.jg_code, d.car_b_p, d.car_name, b.init_reg_dt, b.car_mng_id ";


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
			System.out.println("[SecondhandDatabase:getSecondhandList_20120418]\n"+e);
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
	*	�縮�� ���� ������ġ ������� ��ȸ 20050527
	*	- 20051011 ����0�����ܰ��� ���� 0.85-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.05,0) janga0 --> 0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0) janga0
	*/
	public Hashtable getJanga_20071001(String car_mng_id, String rent_l_cd, String esti_dt){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();

		if(esti_dt.equals("")) esti_dt = "to_char(sysdate,'YYYYMMDD')";

		String query = "SELECT e.sh_code, b.init_reg_dt, c.lpg_yn, e.dpm "+
" 	  ,i.serv_dt SERV_DT, i.tot_dist TODAY_DIST "+
" 	  ,d.janga24/100 janga24  "+
" 	  ,0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0) janga0  "+
" 	  ,POWER((d.janga24/100)/(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0)), ((to_date("+esti_dt+")-to_date(b.init_reg_dt))/365*12)/24)*(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0)) month_janga  "+
" 	  ,((to_date("+esti_dt+")-to_date(b.init_reg_dt))/365*12) car_old  "+
" 	  ,((to_date("+esti_dt+")-to_date(b.init_reg_dt))/365*12)*2250  std_km  "+
" 	  ,POWER((d.janga24/100)/(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0)), ((to_date("+esti_dt+")-to_date(b.init_reg_dt))/365*12)/24)*(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0))*  "+
" 	   (1- (nvl(i.tot_dist,0)-(((to_date("+esti_dt+")-to_date(b.init_reg_dt))/365*12)*2250)) /5000 * decode(d.jeep_yn,'Y',0.005,0.01) ) real_km_janga "+
" 	  ,c.car_cs_amt+c.car_cv_amt+c.opt_cs_amt+c.opt_cv_amt+c.clr_cs_amt+c.clr_cv_amt car_amt  "+
" 	  ,decode(d.rentcar,'Y',0,nvl(f.sp_tax,0)) xstart, nvl(g.sp_tax,0) xend  "+
" 	  ,round((c.car_cs_amt+c.car_cv_amt+c.opt_cs_amt+c.opt_cv_amt+c.clr_cs_amt+c.clr_cv_amt)/(1+decode(d.rentcar,'Y',0,nvl(f.sp_tax,0))/100)*(1+nvl(g.sp_tax,0)/100)) apply_amt  "+
" 	  ,round(POWER((d.janga24/100)/(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0)), ((to_date("+esti_dt+")-to_date(b.init_reg_dt))/365*12)/24)*(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0))*  "+
" 	   (1- (nvl(i.tot_dist,0) -(((to_date("+esti_dt+")-to_date(b.init_reg_dt))/365*12)*2250)) /5000 * decode(d.jeep_yn,'Y',0.005,0.01) ) "+
" 	   *  "+
" 	   (c.car_cs_amt+c.car_cv_amt+c.opt_cs_amt+c.opt_cv_amt+c.clr_cs_amt+c.clr_cv_amt)/(1+decode(d.rentcar,'Y',0,nvl(f.sp_tax,0))/100)*(1+nvl(g.sp_tax,0)/100),-4 ) auction_amt  "+
" 	  ,round(round(POWER((d.janga24/100)/(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0)), ((to_date("+esti_dt+")-to_date(b.init_reg_dt))/365*12)/24)*(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0))*  "+
" 		   (1- (nvl(i.tot_dist,0)-(((to_date("+esti_dt+")-to_date(b.init_reg_dt))/365*12)*2250)) /5000 * decode(d.jeep_yn,'Y',0.005,0.01) ) "+
" 		   *  "+
" 		   (c.car_cs_amt+c.car_cv_amt+c.opt_cs_amt+c.opt_cv_amt+c.clr_cs_amt+c.clr_cv_amt)/(1+decode(d.rentcar,'Y',0,nvl(f.sp_tax,0))/100)*(1+nvl(g.sp_tax,0)/100),-4   "+
" 	   )*105/100+decode(c.lpg_yn,'Y',500000*(POWER((d.janga24/100)/(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0)), ((to_date("+esti_dt+")-to_date(b.init_reg_dt))/365*12)/24)*(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0))*  "+
" 	   (1- (nvl(i.tot_dist,0) -(((to_date("+esti_dt+")-to_date(b.init_reg_dt))/365*12)*2250)) /5000 * decode(d.jeep_yn,'Y',0.005,0.01) )),0),-5)  sh_amt "+
" 	  ,round(round(POWER((d.janga24/100)/(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0)), ((to_date("+esti_dt+")-to_date(b.init_reg_dt))/365*12)/24)*(0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0))* "+
" 		   (1- (nvl(i.tot_dist,0)-(((to_date("+esti_dt+")-to_date(b.init_reg_dt))/365*12)*2250)) /5000 * decode(d.jeep_yn,'Y',0.005,0.01) ) "+
" 		   * "+
" 		   (c.car_cs_amt+c.car_cv_amt+c.opt_cs_amt+c.opt_cv_amt+c.clr_cs_amt+c.clr_cv_amt)/(1+decode(d.rentcar,'Y',0,nvl(f.sp_tax,0))/100)*(1+nvl(g.sp_tax,0)/100),-4 "+
" 	   )*105/100, -5)  sh_amt_no_lpg "+
" FROM cont a, car_reg b, car_etc c,   "+
" 	 (select * from esti_sh_var a where seq = (select max(seq) from esti_sh_var b where a.sh_code=b.sh_code)) d,  "+
" 	 car_nm e, sp_tax f,  "+
" 	 (select * from sp_tax where seq = (select max(seq) from sp_tax)) g, "+
"    (select a.car_mng_id, max(b.serv_dt) serv_dt, max(a.tot_dist) tot_dist "+
"		from (select car_mng_Id, nvl(max(tot_dist),0) tot_dist from service group by car_mng_id) a, service b "+
"		where a.car_mng_id=b.car_mng_id and a.tot_dist=b.tot_dist "+
"		group by a.car_mng_id) i "+
" WHERE a.car_mng_id= b.car_mng_id  "+
" AND a.rent_mng_id = c.rent_mng_id  "+
" AND a.rent_l_cd = c.rent_l_cd  "+
" and c.car_id = e.car_id and c.car_seq=e.car_seq  "+
" AND e.sh_code= d.sh_code  "+
" and e.sh_code= f.sh_code(+)  "+
" and b.init_reg_dt between nvl(f.tax_st_dt,'00000000') and nvl(f.tax_end_dt,'99999999')  "+
" and e.sh_code= g.sh_code(+)  "+
" and b.car_mng_id = i.car_mng_id(+) "+
" and b.car_mng_id=? and a.rent_l_cd=? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
			pstmt.setString(2,rent_l_cd);
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
		}catch(Exception e){
			System.out.println("[SecondhandDatabase:getJanga_20071001(String car_mng_id)]"+e);
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

	//�縮������ �װ�����
	public Vector getSecondhandResCancel(int cancel_day)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" a.car_st, b.SECONDHAND, c.*, trunc(sysdate-to_date(c.reg_dt,'YYYYMMDD'),0) reg_day"+
				" from cont a, car_reg b, sh_res c, (select car_mng_id, max(seq) seq from sh_res group by car_mng_id) d"+
				" where nvl(a.use_yn,'Y')='Y'"+
				" and a.car_mng_id=b.car_mng_id"+
				" and b.car_mng_id=c.car_mng_id"+
				" and c.car_mng_id=d.car_mng_id and c.seq=d.seq"+
				" and c.situation is not null and c.situation<>'2'"+
				" and trunc(sysdate-to_date(c.reg_dt,'YYYYMMDD'),0) > ?"+
				" order by c.reg_dt desc";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, cancel_day);
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
			System.out.println("[SecondhandDatabase:getSecondhandResCancel]\n"+e);
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
	*	�縮�� ���� �⺻������
	*/
	public Hashtable getShBase(String car_mng_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();

		String query =  " SELECT b.CAR_Y_FORM, b.car_end_dt, a.* from sh_base a, car_reg b WHERE a.CAR_MNG_ID = b.CAR_MNG_ID(+) and  a.car_mng_id=?"+
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
			System.out.println("[SecondhandDatabase:getShBase]"+e);
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
	*	 �縮�������⺻���� ���
	*/
	public int insertShBase(Hashtable ht){
		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		int result = 0;

		query = " insert into sh_base "+
				" ( CAR_MNG_ID, REG_ID, REG_DT, CAR_COMP_ID, CAR_CD, CAR_ID, CAR_SEQ, S_ST, JG_CODE, CAR_NO,"+
				"   CAR_NAME, OPT, COL, CAR_AMT, OPT_AMT, COL_AMT, O_L, CAR_USE, CAR_EXT,"+
				"   LPG_YN, DLV_DT, INIT_REG_DT, SECONDHAND_DT, BEFORE_ONE_YEAR, SERV_DT, TOT_DIST, PARK, TODAY_DIST, SH_CODE, accid_serv_amt1, accid_serv_amt2 "+
				" ) values "+
				" ( ?, ?, to_char(sysdate,'YYYYMMDD'), ?, ?, ?, ?, ?, ?, ?, "+
				"   ?, ?, ?, ?, ?,   ?, ?, ?, ?,"+
				"   ?, replace(?,'-',''), replace(?,'-',''), replace(?,'-',''), replace(?,'-',''),   replace(?,'-',''), ?, ?, ?, ?, 0, 0"+
				" ) ";

		try{

			conn.setAutoCommit(false);

			if(!String.valueOf(ht.get("CAR_MNG_ID")).equals("null")){
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1,  String.valueOf(ht.get("CAR_MNG_ID"))					);
				pstmt.setString(2,  String.valueOf(ht.get("REG_ID"))						);
				pstmt.setString(3,  String.valueOf(ht.get("CAR_COMP_ID"))					);
				pstmt.setString(4,  String.valueOf(ht.get("CODE"))							);
				pstmt.setString(5,  String.valueOf(ht.get("CAR_ID"))						);
				pstmt.setString(6,  String.valueOf(ht.get("CAR_SEQ"))						);
				pstmt.setString(7,  String.valueOf(ht.get("S_ST"))							);
				pstmt.setString(8,  String.valueOf(ht.get("JG_CODE"))						);
				pstmt.setString(9,  String.valueOf(ht.get("CAR_NO"))						);
				pstmt.setString(10, String.valueOf(ht.get("CAR_NAME"))						);
				pstmt.setString(11, String.valueOf(ht.get("OPT"))							);
				pstmt.setString(12, String.valueOf(ht.get("COLO"))							);
				pstmt.setInt   (13, AddUtil.parseInt(String.valueOf(ht.get("CAR_AMT")))		);
				pstmt.setInt   (14, AddUtil.parseInt(String.valueOf(ht.get("OPT_AMT")))		);
				pstmt.setInt   (15, AddUtil.parseInt(String.valueOf(ht.get("CLR_AMT")))		);
				pstmt.setInt   (16, AddUtil.parseInt(String.valueOf(ht.get("O_1")))			);
				pstmt.setString(17, String.valueOf(ht.get("CAR_USE"))						);
				pstmt.setString(18, String.valueOf(ht.get("CAR_EXT"))						);
				pstmt.setString(19, String.valueOf(ht.get("LPG_YN"))						);
				pstmt.setString(20, String.valueOf(ht.get("DLV_DT"))						);
				pstmt.setString(21, String.valueOf(ht.get("INIT_REG_DT"))					);
				pstmt.setString(22, String.valueOf(ht.get("SECONDHAND_DT"))					);
				pstmt.setString(23, String.valueOf(ht.get("BEFORE_ONE_YEAR"))				);
				pstmt.setString(24, String.valueOf(ht.get("SERV_DT"))						);
				pstmt.setInt   (25, AddUtil.parseInt(String.valueOf(ht.get("TOT_DIST")))	);
				pstmt.setString(26, String.valueOf(ht.get("PARK"))							);
				pstmt.setInt   (27, AddUtil.parseInt(String.valueOf(ht.get("TODAY_DIST")))	);
				pstmt.setString(28, String.valueOf(ht.get("SH_CODE"))						);
				result = pstmt.executeUpdate();
				pstmt.close();
			}
			conn.commit();

		}catch(SQLException e){
			System.out.println("[SecondhandDatabase:insertShBase]"+e);
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
	*	 �縮�������⺻���� ����
	*/
	public int updateShBase(Hashtable ht){
		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		int result = 0;

		query = " update sh_base set "+
				" SECONDHAND_DT		=replace(?,'-',''), "+
				" BEFORE_ONE_YEAR	=replace(?,'-',''), "+
				" SERV_DT			=replace(?,'-',''), "+
				" TOT_DIST			=?, "+
				" TODAY_DIST		=?, "+
				" PARK				=?,"+
				" CAR_NO			=?, "+
				" CAR_USE			=?, "+
				" CAR_EXT			=?, "+
				" JG_CODE			=?, "+
				" COL				=?, "+
				" TAX_DC_AMT		=? "+
				" where car_mng_id=? ";

		try{

			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, String.valueOf(ht.get("SECONDHAND_DT")));
			pstmt.setString(2, String.valueOf(ht.get("BEFORE_ONE_YEAR")));
			pstmt.setString(3, String.valueOf(ht.get("SERV_DT")));
			pstmt.setInt   (4, AddUtil.parseInt(String.valueOf(ht.get("TOT_DIST"))));
			pstmt.setInt   (5, AddUtil.parseInt(String.valueOf(ht.get("TODAY_DIST"))));
			pstmt.setString(6, String.valueOf(ht.get("PARK")));
			pstmt.setString(7, String.valueOf(ht.get("CAR_NO")));
			pstmt.setString(8, String.valueOf(ht.get("CAR_USE")));
			pstmt.setString(9, String.valueOf(ht.get("CAR_EXT")));
			pstmt.setString(10, String.valueOf(ht.get("JG_CODE")));
			pstmt.setString(11, String.valueOf(ht.get("COLO")));
			pstmt.setInt   (12, AddUtil.parseInt(String.valueOf(ht.get("TAX_DC_AMT"))));
			pstmt.setString(13, String.valueOf(ht.get("CAR_MNG_ID")));
			result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		}catch(SQLException e){
			System.out.println("[SecondhandDatabase:updateShBase]"+e);
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
	*	�縮�� ���� �ܰ���� ������
	*/
	public Hashtable getShBaseVar(String car_mng_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();

		String query =  " select * from sh_base_var where car_mng_id=?"+
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
			System.out.println("[SecondhandDatabase:getShBaseVar]"+e);
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

	//	�縮�� ���� �ܰ���� ������ ���
	public int insertShBaseVar(Hashtable ht){
		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		int result = 0;

		query = " insert into sh_base_var "+
				" ( CAR_MNG_ID, RENT_DT, TODAY_DIST, A_B, CAR_ST, O_A, G_1, O_2, O_3, O_B,  "+
				"	O_4, O_D, FW_917, GB917, O_E, O_E_R, G_3, FW_920, O_P, O_6,  "+
				"	O_F, O_F_R, G_K3, O_Q1, O_Q2, O_Q3, O_Q4, O_7, FW_930, O_8,  "+
				"	FW_932, O_9, O_G1, O_G1_R, FW_935, O_10, O_G2, O_G2_R, O_11, O_G,  "+
				"	O_G_R, G_7, G_7_R, FW_941, GB_942, O_R, O_R_R, O_S_R, G_9, G_10,  "+
				"	A_M_1, A_M_2, A_M_3, A_M_4, O_T, O_S, O_U, G_11, O_V, SH_C_A,  "+
				"	GB_954, O_W, O_X, SH_CAR_AMT, DLV_CAR_AMT, O_Y"+
				" ) values "+
				" ( ?, ?, ?, ?, ?, substr(?,1,7), substr(?,1,7), substr(?,1,7), substr(?,1,7), substr(?,1,7), "+
				"   substr(?,1,7), substr(?,1,7), substr(?,1,7), substr(?,1,7), substr(?,1,7),   substr(?,1,7), substr(?,1,7), substr(?,1,7), substr(?,1,7), substr(?,1,7), "+
				"   substr(?,1,7), substr(?,1,7), substr(?,1,7), substr(?,1,7), substr(?,1,7),   substr(?,1,7), substr(?,1,7), substr(?,1,7), substr(?,1,7), substr(?,1,7), "+
				"   substr(?,1,7), substr(?,1,7), substr(?,1,7), substr(?,1,7), substr(?,1,7),   substr(?,1,7), substr(?,1,7), substr(?,1,7), substr(?,1,7), substr(?,1,7), "+
				"   substr(?,1,7), substr(?,1,7), substr(?,1,7), substr(?,1,7), substr(?,1,7),   substr(?,1,7), substr(?,1,7), substr(?,1,7), substr(?,1,7), substr(?,1,7), "+
				"   substr(?,1,7), substr(?,1,7), substr(?,1,7), substr(?,1,7), substr(?,1,7),   substr(?,1,7), substr(?,1,7), substr(?,1,7), substr(?,1,7), substr(?,1,7), "+
				"   substr(?,1,7), substr(?,1,7), substr(?,1,7), ?, ?, substr(?,1,7) "+
				" ) ";

		try{

			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1,  String.valueOf(ht.get("CAR_MNG_ID")));
			pstmt.setString(2,  String.valueOf(ht.get("RENT_DT")));
			pstmt.setString(3,  String.valueOf(ht.get("TODAY_DIST")));
			pstmt.setString(4,  String.valueOf(ht.get("A_B")));
			pstmt.setString(5,  String.valueOf(ht.get("CAR_ST")));
			pstmt.setString(6,  String.valueOf(ht.get("O_A")));
			pstmt.setString(7,  String.valueOf(ht.get("G_1")));
			pstmt.setString(8,  String.valueOf(ht.get("O_2")));
			pstmt.setString(9,  String.valueOf(ht.get("O_3")));
			pstmt.setString(10, String.valueOf(ht.get("O_B")));
			pstmt.setString(11, String.valueOf(ht.get("O_4")));
			pstmt.setString(12, String.valueOf(ht.get("O_D")));
			pstmt.setString(13, String.valueOf(ht.get("FW_917")));
			pstmt.setString(14, String.valueOf(ht.get("GB_917")));
			pstmt.setString(15, String.valueOf(ht.get("O_E")));
			pstmt.setString(16, String.valueOf(ht.get("O_E_R")));
			pstmt.setString(17, String.valueOf(ht.get("G_3")));
			pstmt.setString(18, String.valueOf(ht.get("FW_920")));
			pstmt.setString(19, String.valueOf(ht.get("O_P")));
			pstmt.setString(20, String.valueOf(ht.get("O_6")));
			pstmt.setString(21, String.valueOf(ht.get("O_F")));
			pstmt.setString(22, String.valueOf(ht.get("O_F_R")));
			pstmt.setString(23, String.valueOf(ht.get("G_K3")));
			pstmt.setString(24, String.valueOf(ht.get("O_Q1")));
			pstmt.setString(25, String.valueOf(ht.get("O_Q2")));
			pstmt.setString(26, String.valueOf(ht.get("O_Q3")));
			pstmt.setString(27, String.valueOf(ht.get("O_Q4")));
			pstmt.setString(28, String.valueOf(ht.get("O_7")));
			pstmt.setString(29, String.valueOf(ht.get("FW_930")));
			pstmt.setString(30, String.valueOf(ht.get("O_8")));
			pstmt.setString(31, String.valueOf(ht.get("FW_932")));
			pstmt.setString(32, String.valueOf(ht.get("O_9")));
			pstmt.setString(33, String.valueOf(ht.get("O_G1")));
			pstmt.setString(34, String.valueOf(ht.get("O_G1_R")));
			pstmt.setString(35, String.valueOf(ht.get("FW_935")));
			pstmt.setString(36, String.valueOf(ht.get("O_10")));
			pstmt.setString(37, String.valueOf(ht.get("O_G2")));
			pstmt.setString(38, String.valueOf(ht.get("O_G2_R")));
			pstmt.setString(39, String.valueOf(ht.get("O_11")));
			pstmt.setString(40, String.valueOf(ht.get("O_G")));
			pstmt.setString(41, String.valueOf(ht.get("O_G_R")));
			pstmt.setString(42, String.valueOf(ht.get("G_7")));
			pstmt.setString(43, String.valueOf(ht.get("G_7_R")));
			pstmt.setString(44, String.valueOf(ht.get("FW_941")));
			pstmt.setString(45, String.valueOf(ht.get("GB_942")));
			pstmt.setString(46, String.valueOf(ht.get("O_R")));
			pstmt.setString(47, String.valueOf(ht.get("O_R_R")));
			pstmt.setString(48, String.valueOf(ht.get("O_S_R")));
			pstmt.setString(49, String.valueOf(ht.get("G_9")));
			pstmt.setString(50, String.valueOf(ht.get("G_10")));
			pstmt.setString(51, String.valueOf(ht.get("A_M_1")));
			pstmt.setString(52, String.valueOf(ht.get("A_M_2")));
			pstmt.setString(53, String.valueOf(ht.get("A_M_3")));
			pstmt.setString(54, String.valueOf(ht.get("A_M_4")));
			pstmt.setString(55, String.valueOf(ht.get("O_T")));
			pstmt.setString(56, String.valueOf(ht.get("O_S")));
			pstmt.setString(57, String.valueOf(ht.get("O_U")));
			pstmt.setString(58, String.valueOf(ht.get("G_11")));
			pstmt.setString(59, String.valueOf(ht.get("O_V")));
			pstmt.setString(60, String.valueOf(ht.get("SH_C_A")));
			pstmt.setString(61, String.valueOf(ht.get("GB_954")));
			pstmt.setString(62, String.valueOf(ht.get("O_W")));
			pstmt.setString(63, String.valueOf(ht.get("O_X")));
			pstmt.setString(64, String.valueOf(ht.get("SH_CAR_AMT")));
			pstmt.setString(65, String.valueOf(ht.get("DLV_CAR_AMT")));
			pstmt.setString(66, String.valueOf(ht.get("O_Y")));
			result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		}catch(SQLException e){
			System.out.println("[SecondhandDatabase:insertShBaseVar]"+e);
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


	//	�縮�� ���� �ܰ���� ������ ����
	public int updateShBaseVar(Hashtable ht){
		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		int result = 0;

		query = " update sh_base_var set "+
				" RENT_DT=?, TODAY_DIST=?, A_B=?, CAR_ST=?, O_A=substr(?,1,7), "+
				" G_1=substr(?,1,7),   O_2=substr(?,1,7),   O_3=substr(?,1,7),    O_B=substr(?,1,7), "+
				" O_4=substr(?,1,7),   O_D=substr(?,1,7),   FW_917=substr(?,1,7), GB917=substr(?,1,7),    O_E=substr(?,1,7), "+
				" O_E_R=substr(?,1,7), G_3=substr(?,1,7),   FW_920=substr(?,1,7), O_P=substr(?,1,7),      O_6=substr(?,1,7), "+
				" O_F=substr(?,1,7),   O_F_R=substr(?,1,7), G_K3=substr(?,1,7),   O_Q1=substr(?,1,7),     O_Q2=substr(?,1,7),   O_Q3=substr(?,1,7), O_Q4=substr(?,1,7),  O_7=substr(?,1,7),    FW_930=substr(?,1,7), O_8=substr(?,1,7),  "+
				" FW_932=substr(?,1,7), O_9=substr(?,1,7),  O_G1=substr(?,1,7),   O_G1_R=substr(?,1,7),   FW_935=substr(?,1,7), O_10=substr(?,1,7), O_G2=substr(?,1,7),  O_G2_R=substr(?,1,7), O_11=substr(?,1,7),   O_G=substr(?,1,7),  "+
				" O_G_R=substr(?,1,7), G_7=substr(?,1,7),   G_7_R=substr(?,1,7),  FW_941=substr(?,1,7),   GB_942=substr(?,1,7), O_R=substr(?,1,7),  O_R_R=substr(?,1,7), O_S_R=substr(?,1,7),  G_9=substr(?,1,7),    G_10=substr(?,1,7),  "+
				" A_M_1=substr(?,1,7), A_M_2=substr(?,1,7), A_M_3=substr(?,1,7),  A_M_4=substr(?,1,7),    O_T=substr(?,1,7),    O_S=substr(?,1,7),  O_U=substr(?,1,7),   G_11=substr(?,1,7),   O_V=substr(?,1,7),    SH_C_A=substr(?,1,7),  "+
				" GB_954=substr(?,1,7), O_W=substr(?,1,7),  O_X=substr(?,1,7),    SH_CAR_AMT=?, DLV_CAR_AMT=?, O_Y=substr(?,1,7)"+
				" where car_mng_id=? ";

		try{

			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);


			pstmt.setString(1,  String.valueOf(ht.get("RENT_DT")));
			pstmt.setString(2,  String.valueOf(ht.get("TODAY_DIST")));
			pstmt.setString(3,  String.valueOf(ht.get("A_B")));
			pstmt.setString(4,  String.valueOf(ht.get("CAR_ST")));
			pstmt.setString(5,  String.valueOf(ht.get("O_A")));
			pstmt.setString(6,  String.valueOf(ht.get("G_1")));
			pstmt.setString(7,  String.valueOf(ht.get("O_2")));
			pstmt.setString(8,  String.valueOf(ht.get("O_3")));
			pstmt.setString(9,  String.valueOf(ht.get("O_B")));
			pstmt.setString(10, String.valueOf(ht.get("O_4")));
			pstmt.setString(11, String.valueOf(ht.get("O_D")));
			pstmt.setString(12, String.valueOf(ht.get("FW_917")));
			pstmt.setString(13, String.valueOf(ht.get("GB_917")));
			pstmt.setString(14, String.valueOf(ht.get("O_E")));
			pstmt.setString(15, String.valueOf(ht.get("O_E_R")));
			pstmt.setString(16, String.valueOf(ht.get("G_3")));
			pstmt.setString(17, String.valueOf(ht.get("FW_920")));
			pstmt.setString(18, String.valueOf(ht.get("O_P")));
			pstmt.setString(19, String.valueOf(ht.get("O_6")));
			pstmt.setString(20, String.valueOf(ht.get("O_F")));
			pstmt.setString(21, String.valueOf(ht.get("O_F_R")));
			pstmt.setString(22, String.valueOf(ht.get("G_K3")));
			pstmt.setString(23, String.valueOf(ht.get("O_Q1")));
			pstmt.setString(24, String.valueOf(ht.get("O_Q2")));
			pstmt.setString(25, String.valueOf(ht.get("O_Q3")));
			pstmt.setString(26, String.valueOf(ht.get("O_Q4")));
			pstmt.setString(27, String.valueOf(ht.get("O_7")));
			pstmt.setString(28, String.valueOf(ht.get("FW_930")));
			pstmt.setString(29, String.valueOf(ht.get("O_8")));
			pstmt.setString(30, String.valueOf(ht.get("FW_932")));
			pstmt.setString(31, String.valueOf(ht.get("O_9")));
			pstmt.setString(32, String.valueOf(ht.get("O_G1")));
			pstmt.setString(33, String.valueOf(ht.get("O_G1_R")));
			pstmt.setString(34, String.valueOf(ht.get("FW_935")));
			pstmt.setString(35, String.valueOf(ht.get("O_10")));
			pstmt.setString(36, String.valueOf(ht.get("O_G2")));
			pstmt.setString(37, String.valueOf(ht.get("O_G2_R")));
			pstmt.setString(38, String.valueOf(ht.get("O_11")));
			pstmt.setString(39, String.valueOf(ht.get("O_G")));
			pstmt.setString(40, String.valueOf(ht.get("O_G_R")));
			pstmt.setString(41, String.valueOf(ht.get("G_7")));
			pstmt.setString(42, String.valueOf(ht.get("G_7_R")));
			pstmt.setString(43, String.valueOf(ht.get("FW_941")));
			pstmt.setString(44, String.valueOf(ht.get("GB_942")));
			pstmt.setString(45, String.valueOf(ht.get("O_R")));
			pstmt.setString(46, String.valueOf(ht.get("O_R_R")));
			pstmt.setString(47, String.valueOf(ht.get("O_S_R")));
			pstmt.setString(48, String.valueOf(ht.get("G_9")));
			pstmt.setString(49, String.valueOf(ht.get("G_10")));
			pstmt.setString(50, String.valueOf(ht.get("A_M_1")));
			pstmt.setString(51, String.valueOf(ht.get("A_M_2")));
			pstmt.setString(52, String.valueOf(ht.get("A_M_3")));
			pstmt.setString(53, String.valueOf(ht.get("A_M_4")));
			pstmt.setString(54, String.valueOf(ht.get("O_T")));
			pstmt.setString(55, String.valueOf(ht.get("O_S")));
			pstmt.setString(56, String.valueOf(ht.get("O_U")));
			pstmt.setString(57, String.valueOf(ht.get("G_11")));
			pstmt.setString(58, String.valueOf(ht.get("O_V")));
			pstmt.setString(59, String.valueOf(ht.get("SH_C_A")));
			pstmt.setString(60, String.valueOf(ht.get("GB_954")));
			pstmt.setString(61, String.valueOf(ht.get("O_W")));
			pstmt.setString(62, String.valueOf(ht.get("O_X")));
			pstmt.setString(63, String.valueOf(ht.get("SH_CAR_AMT")));
			pstmt.setString(64, String.valueOf(ht.get("DLV_CAR_AMT")));
			pstmt.setString(65, String.valueOf(ht.get("O_Y")));
			pstmt.setString(66, String.valueOf(ht.get("CAR_MNG_ID")));

			result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		}catch(SQLException e){
			System.out.println("[SecondhandDatabase:updateShBaseVar]"+e);
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

	//	�縮�� ���� �ܰ���� ������ ���
	public int insertShCompare(Hashtable ht){
		getConnection();
		PreparedStatement pstmt = null;
    	Statement stmt = null;
        ResultSet rs = null;
		int id_chk = 0;
		String query = "";
		int result = 0;

		String query3 = "select count(0) from esti_compare where est_id='"+String.valueOf(ht.get("EST_ID"))+"'";

		query = " insert into esti_compare "+
				" ( EST_ID, I67, O67, AX32, O68, O69, O70, AO70, AO71, O71, "+
				"   I72, O72, AO72, I73, I74, O75, I75, O78, I78, AO76, "+
				"   AO77, I76, I77, I79, AK78, AE79, AE81, O80, I80, I81,"+
				"   O82, I82, O83, I83, O84, I84, O85, I85, I86, AE86, "+
				"   I87, AE87, AO86, I88, I89, I90, AE90, I91, AE91, AE93, "+
				"   ENGIN "+
				" ) values "+
				" ( ?, ?, ?, ?, ?,   ?, ?, ?, ?, ?, "+
				"   ?, ?, ?, ?, trunc(?),   ?, ?, ?, ?, ?, "+
				"   ?, ?, ?, trunc(?), ?,   ?, ?, ?, ?, ?, "+
				"   ?, ?, ?, ?, ?,   ?, ?, ?, ?, ?, "+
				"   trunc(?), ?, ?, ?, ?,   ?, ?, trunc(?), ?, trunc(?), "+
				"   ? "+
				" ) ";

		try{

			conn.setAutoCommit(false);

            //est_id üũ
            stmt = conn.createStatement();
            rs = stmt.executeQuery(query3);
            if(rs.next())
            	id_chk = rs.getInt(1);
            rs.close();
      		stmt.close();

			if(id_chk == 0){

				pstmt = conn.prepareStatement(query);

				pstmt.setString(1,  String.valueOf(ht.get("EST_ID")));
				pstmt.setString(2,  String.valueOf(ht.get("I67"))	);
				pstmt.setString(3,  String.valueOf(ht.get("O67"))	);
				pstmt.setString(4,  String.valueOf(ht.get("AX32"))	);
				pstmt.setString(5,  String.valueOf(ht.get("O68"))	);
				pstmt.setString(6,  String.valueOf(ht.get("O69"))	);
				pstmt.setString(7,  String.valueOf(ht.get("O70"))	);
				pstmt.setString(8,  String.valueOf(ht.get("AO70"))	);
				pstmt.setString(9,  String.valueOf(ht.get("AO71"))	);
				pstmt.setString(10, String.valueOf(ht.get("O71"))	);
				pstmt.setString(11, String.valueOf(ht.get("I72"))	);
				pstmt.setString(12, String.valueOf(ht.get("O72"))	);
				pstmt.setString(13, String.valueOf(ht.get("AO72"))	);
				pstmt.setString(14, String.valueOf(ht.get("I73"))	);
				pstmt.setString(15, String.valueOf(ht.get("I74"))	);
				pstmt.setString(16, String.valueOf(ht.get("O75"))	);
				pstmt.setString(17, String.valueOf(ht.get("I75"))	);
				pstmt.setString(18, String.valueOf(ht.get("O78"))	);
				pstmt.setString(19, String.valueOf(ht.get("I78"))	);
				pstmt.setString(20, String.valueOf(ht.get("AO76"))	);
				pstmt.setString(21, String.valueOf(ht.get("AO77"))	);
				pstmt.setString(22, String.valueOf(ht.get("I76"))	);
				pstmt.setString(23, String.valueOf(ht.get("I77"))	);
				pstmt.setString(24, String.valueOf(ht.get("I79"))	);
				pstmt.setString(25, String.valueOf(ht.get("AK78"))	);
				pstmt.setString(26, String.valueOf(ht.get("AE79"))	);
				pstmt.setString(27, String.valueOf(ht.get("AE81"))	);
				pstmt.setString(28, String.valueOf(ht.get("O80"))	);
				pstmt.setString(29, String.valueOf(ht.get("I80"))	);
				pstmt.setString(30, String.valueOf(ht.get("I81"))	);
				pstmt.setString(31, String.valueOf(ht.get("O82"))	);
				pstmt.setString(32, String.valueOf(ht.get("I82"))	);
				pstmt.setString(33, String.valueOf(ht.get("O83"))	);
				pstmt.setString(34, String.valueOf(ht.get("I83"))	);
				pstmt.setString(35, String.valueOf(ht.get("O84"))	);
				pstmt.setString(36, String.valueOf(ht.get("I84"))	);
				pstmt.setString(37, String.valueOf(ht.get("O85"))	);
				pstmt.setString(38, String.valueOf(ht.get("I85"))	);
				pstmt.setString(39, String.valueOf(ht.get("I86"))	);
				pstmt.setString(40, String.valueOf(ht.get("AE86"))	);
				pstmt.setString(41, String.valueOf(ht.get("I87"))	);
				pstmt.setString(42, String.valueOf(ht.get("AE87"))	);
				pstmt.setString(43, String.valueOf(ht.get("AO86"))	);
				pstmt.setString(44, String.valueOf(ht.get("I88"))	);
				pstmt.setString(45, String.valueOf(ht.get("I89"))	);
				pstmt.setString(46, String.valueOf(ht.get("I90"))	);
				pstmt.setString(47, String.valueOf(ht.get("AE90"))	);
				pstmt.setString(48, String.valueOf(ht.get("I91"))	);
				pstmt.setString(49, String.valueOf(ht.get("AE91"))	);
				pstmt.setString(50, String.valueOf(ht.get("AE93"))	);
				pstmt.setString(51, String.valueOf(ht.get("ENGIN"))	);
				result = pstmt.executeUpdate();
				pstmt.close();
			}
			conn.commit();

		}catch(SQLException e){
			System.out.println("[SecondhandDatabase:insertShCompare]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(rs != null)		rs.close();
                if(stmt != null)	stmt.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}
	}

	//	�縮�� ���� �ܰ���� ������ ���
	public int insertShCompareHp(Hashtable ht){
		getConnection();
		PreparedStatement pstmt = null;
    	Statement stmt = null;
        ResultSet rs = null;
		int id_chk = 0;

		String query = "";
		int result = 0;

		String query3 = "select count(0) from esti_compare_hp where est_id='"+String.valueOf(ht.get("EST_ID"))+"'";

		query = " insert into esti_compare_hp "+
				" ( EST_ID, I67, O67, AX32, O68, O69, O70, AO70, AO71, O71, "+
				"   I72, O72, AO72, I73, I74, O75, I75, O78, I78, AO76, "+
				"   AO77, I76, I77, I79, AK78, AE79, AE81, O80, I80, I81,"+
				"   O82, I82, O83, I83, O84, I84, O85, I85, I86, AE86, "+
				"   I87, AE87, AO86, I88, I89, I90, AE90, I91, AE91, AE93, "+
				"   ENGIN "+
				" ) values "+
				" ( ?, ?, ?, ?, ?,   ?, ?, ?, ?, ?, "+
				"   ?, ?, ?, ?, trunc(?),   ?, ?, ?, ?, ?, "+
				"   ?, ?, ?, trunc(?), ?,   ?, ?, ?, ?, ?, "+
				"   ?, ?, ?, ?, ?,   ?, ?, ?, ?, ?, "+
				"   trunc(?), ?, ?, ?, ?,   ?, ?, trunc(?), ?, trunc(?), "+
				"   ? "+
				" ) ";

		try{

			conn.setAutoCommit(false);

            //est_id üũ
            stmt = conn.createStatement();
            rs = stmt.executeQuery(query3);
            if(rs.next())
            	id_chk = rs.getInt(1);
            rs.close();
      		stmt.close();

			if(id_chk == 0){

				pstmt = conn.prepareStatement(query);

				pstmt.setString(1,  String.valueOf(ht.get("EST_ID")));
				pstmt.setString(2,  String.valueOf(ht.get("I67"))	);
				pstmt.setString(3,  String.valueOf(ht.get("O67"))	);
				pstmt.setString(4,  String.valueOf(ht.get("AX32"))	);
				pstmt.setString(5,  String.valueOf(ht.get("O68"))	);
				pstmt.setString(6,  String.valueOf(ht.get("O69"))	);
				pstmt.setString(7,  String.valueOf(ht.get("O70"))	);
				pstmt.setString(8,  String.valueOf(ht.get("AO70"))	);
				pstmt.setString(9,  String.valueOf(ht.get("AO71"))	);
				pstmt.setString(10, String.valueOf(ht.get("O71"))	);
				pstmt.setString(11, String.valueOf(ht.get("I72"))	);
				pstmt.setString(12, String.valueOf(ht.get("O72"))	);
				pstmt.setString(13, String.valueOf(ht.get("AO72"))	);
				pstmt.setString(14, String.valueOf(ht.get("I73"))	);
				pstmt.setString(15, String.valueOf(ht.get("I74"))	);
				pstmt.setString(16, String.valueOf(ht.get("O75"))	);
				pstmt.setString(17, String.valueOf(ht.get("I75"))	);
				pstmt.setString(18, String.valueOf(ht.get("O78"))	);
				pstmt.setString(19, String.valueOf(ht.get("I78"))	);
				pstmt.setString(20, String.valueOf(ht.get("AO76"))	);
				pstmt.setString(21, String.valueOf(ht.get("AO77"))	);
				pstmt.setString(22, String.valueOf(ht.get("I76"))	);
				pstmt.setString(23, String.valueOf(ht.get("I77"))	);
				pstmt.setString(24, String.valueOf(ht.get("I79"))	);
				pstmt.setString(25, String.valueOf(ht.get("AK78"))	);
				pstmt.setString(26, String.valueOf(ht.get("AE79"))	);
				pstmt.setString(27, String.valueOf(ht.get("AE81"))	);
				pstmt.setString(28, String.valueOf(ht.get("O80"))	);
				pstmt.setString(29, String.valueOf(ht.get("I80"))	);
				pstmt.setString(30, String.valueOf(ht.get("I81"))	);
				pstmt.setString(31, String.valueOf(ht.get("O82"))	);
				pstmt.setString(32, String.valueOf(ht.get("I82"))	);
				pstmt.setString(33, String.valueOf(ht.get("O83"))	);
				pstmt.setString(34, String.valueOf(ht.get("I83"))	);
				pstmt.setString(35, String.valueOf(ht.get("O84"))	);
				pstmt.setString(36, String.valueOf(ht.get("I84"))	);
				pstmt.setString(37, String.valueOf(ht.get("O85"))	);
				pstmt.setString(38, String.valueOf(ht.get("I85"))	);
				pstmt.setString(39, String.valueOf(ht.get("I86"))	);
				pstmt.setString(40, String.valueOf(ht.get("AE86"))	);
				pstmt.setString(41, String.valueOf(ht.get("I87"))	);
				pstmt.setString(42, String.valueOf(ht.get("AE87"))	);
				pstmt.setString(43, String.valueOf(ht.get("AO86"))	);
				pstmt.setString(44, String.valueOf(ht.get("I88"))	);
				pstmt.setString(45, String.valueOf(ht.get("I89"))	);
				pstmt.setString(46, String.valueOf(ht.get("I90"))	);
				pstmt.setString(47, String.valueOf(ht.get("AE90"))	);
				pstmt.setString(48, String.valueOf(ht.get("I91"))	);
				pstmt.setString(49, String.valueOf(ht.get("AE91"))	);
				pstmt.setString(50, String.valueOf(ht.get("AE93"))	);
				pstmt.setString(51, String.valueOf(ht.get("ENGIN"))	);
				result = pstmt.executeUpdate();
				pstmt.close();
			}
			conn.commit();

		}catch(SQLException e){
			System.out.println("[SecondhandDatabase:insertShCompareHp]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(rs != null)		rs.close();
                if(stmt != null)	stmt.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}
	}

	//	�縮�� ���� �ܰ���� ������ ���
	public int insertShCompareHpSimple(Hashtable ht){
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		int id_chk = 0;
		String query = "";
		String query2 = "";
		int result = 0;


		query = " insert into esti_compare_hp ( EST_ID ) values ( ? ) ";
		query2 = " insert into esti_exam_hp ( EST_ID ) values ( ? ) ";

		try{

			conn.setAutoCommit(false);

				pstmt = conn.prepareStatement(query);
				pstmt.setString(1,  String.valueOf(ht.get("EST_ID")));
				result = pstmt.executeUpdate();
				pstmt.close();

				pstmt2 = conn.prepareStatement(query2);
				pstmt2.setString(1,  String.valueOf(ht.get("EST_ID")));
				result = pstmt2.executeUpdate();
				pstmt2.close();

			conn.commit();

		}catch(SQLException e){
			System.out.println("[SecondhandDatabase:insertShCompareHpSimple]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
                if(pstmt2 != null) pstmt2.close();
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}
	}

	//	�縮�� ���� �ܰ���� ������ ���
	public int insertShCompareSh(Hashtable ht){
		getConnection();
		PreparedStatement pstmt = null;
    	Statement stmt = null;
        ResultSet rs = null;
		int id_chk = 0;

		String query = "";
		int result = 0;


		String query3 = "select count(0) from esti_compare_sh where est_id='"+String.valueOf(ht.get("EST_ID"))+"'";

		query = " insert into esti_compare_sh "+
				" ( EST_ID, I67, O67, AX32, O68, O69, O70, AO70, AO71, O71, "+
				"   I72, O72, AO72, I73, I74, O75, I75, O78, I78, AO76, "+
				"   AO77, I76, I77, I79, AK78, AE79, AE81, O80, I80, I81,"+
				"   O82, I82, O83, I83, O84, I84, O85, I85, I86, AE86, "+
				"   I87, AE87, AO86, I88, I89, I90, AE90, I91, AE91, AE93, "+
				"   ENGIN "+
				" ) values "+
				" ( ?, ?, ?, ?, ?,   ?, ?, ?, ?, ?, "+
				"   ?, ?, ?, ?, trunc(?),   ?, ?, ?, ?, ?, "+
				"   ?, ?, ?, trunc(?), ?,   ?, ?, ?, ?, ?, "+
				"   ?, ?, ?, ?, ?,   ?, ?, ?, ?, ?, "+
				"   trunc(?), ?, ?, ?, ?,   ?, ?, trunc(?), ?, trunc(?), "+
				"   ? "+
				" ) ";

		try{

			conn.setAutoCommit(false);

            //est_id üũ
            stmt = conn.createStatement();
            rs = stmt.executeQuery(query3);
            if(rs.next())
            	id_chk = rs.getInt(1);
            rs.close();
      		stmt.close();

			if(id_chk == 0){

				pstmt = conn.prepareStatement(query);

				pstmt.setString(1,  String.valueOf(ht.get("EST_ID")));
				pstmt.setString(2,  String.valueOf(ht.get("I67"))	);
				pstmt.setString(3,  String.valueOf(ht.get("O67"))	);
				pstmt.setString(4,  String.valueOf(ht.get("AX32"))	);
				pstmt.setString(5,  String.valueOf(ht.get("O68"))	);
				pstmt.setString(6,  String.valueOf(ht.get("O69"))	);
				pstmt.setString(7,  String.valueOf(ht.get("O70"))	);
				pstmt.setString(8,  String.valueOf(ht.get("AO70"))	);
				pstmt.setString(9,  String.valueOf(ht.get("AO71"))	);
				pstmt.setString(10, String.valueOf(ht.get("O71"))	);
				pstmt.setString(11, String.valueOf(ht.get("I72"))	);
				pstmt.setString(12, String.valueOf(ht.get("O72"))	);
				pstmt.setString(13, String.valueOf(ht.get("AO72"))	);
				pstmt.setString(14, String.valueOf(ht.get("I73"))	);
				pstmt.setString(15, String.valueOf(ht.get("I74"))	);
				pstmt.setString(16, String.valueOf(ht.get("O75"))	);
				pstmt.setString(17, String.valueOf(ht.get("I75"))	);
				pstmt.setString(18, String.valueOf(ht.get("O78"))	);
				pstmt.setString(19, String.valueOf(ht.get("I78"))	);
				pstmt.setString(20, String.valueOf(ht.get("AO76"))	);
				pstmt.setString(21, String.valueOf(ht.get("AO77"))	);
				pstmt.setString(22, String.valueOf(ht.get("I76"))	);
				pstmt.setString(23, String.valueOf(ht.get("I77"))	);
				pstmt.setString(24, String.valueOf(ht.get("I79"))	);
				pstmt.setString(25, String.valueOf(ht.get("AK78"))	);
				pstmt.setString(26, String.valueOf(ht.get("AE79"))	);
				pstmt.setString(27, String.valueOf(ht.get("AE81"))	);
				pstmt.setString(28, String.valueOf(ht.get("O80"))	);
				pstmt.setString(29, String.valueOf(ht.get("I80"))	);
				pstmt.setString(30, String.valueOf(ht.get("I81"))	);
				pstmt.setString(31, String.valueOf(ht.get("O82"))	);
				pstmt.setString(32, String.valueOf(ht.get("I82"))	);
				pstmt.setString(33, String.valueOf(ht.get("O83"))	);
				pstmt.setString(34, String.valueOf(ht.get("I83"))	);
				pstmt.setString(35, String.valueOf(ht.get("O84"))	);
				pstmt.setString(36, String.valueOf(ht.get("I84"))	);
				pstmt.setString(37, String.valueOf(ht.get("O85"))	);
				pstmt.setString(38, String.valueOf(ht.get("I85"))	);
				pstmt.setString(39, String.valueOf(ht.get("I86"))	);
				pstmt.setString(40, String.valueOf(ht.get("AE86"))	);
				pstmt.setString(41, String.valueOf(ht.get("I87"))	);
				pstmt.setString(42, String.valueOf(ht.get("AE87"))	);
				pstmt.setString(43, String.valueOf(ht.get("AO86"))	);
				pstmt.setString(44, String.valueOf(ht.get("I88"))	);
				pstmt.setString(45, String.valueOf(ht.get("I89"))	);
				pstmt.setString(46, String.valueOf(ht.get("I90"))	);
				pstmt.setString(47, String.valueOf(ht.get("AE90"))	);
				pstmt.setString(48, String.valueOf(ht.get("I91"))	);
				pstmt.setString(49, String.valueOf(ht.get("AE91"))	);
				pstmt.setString(50, String.valueOf(ht.get("AE93"))	);
				pstmt.setString(51, String.valueOf(ht.get("ENGIN"))	);
				result = pstmt.executeUpdate();
				pstmt.close();
			}

			conn.commit();

		}catch(SQLException e){
			System.out.println("[SecondhandDatabase:insertShCompareSh]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(rs != null)		rs.close();
                if(stmt != null)	stmt.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}
	}

	/**
	*	�縮�� ���� ���� ������
	*/
	public Hashtable getShCompare(String est_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();

		String query =  " select * from esti_compare where est_id=?"+
						" ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,est_id);
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
			System.out.println("[SecondhandDatabase:getShCompare]"+e);
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
	*	�縮�� ���� ���� ������
	*/
	public Hashtable getShCompareHp(String est_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();

		String query =  " select * from esti_compare_hp where est_id=?"+
						" ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,est_id);
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
			System.out.println("[SecondhandDatabase:getShCompareHp]"+e);
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
	*	�縮�� ���� ���� ������
	*/
	public Hashtable getShCompareSh(String est_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();

		String query =  " select * from esti_compare_sh where est_id=?"+
						" ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,est_id);
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
			System.out.println("[SecondhandDatabase:getShCompareSh]"+e);
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
	*	�縮�� ���� ���� ������
	*/
	public Hashtable getEstiExam(String est_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();

		String query =  " select * from esti_exam where est_id=?"+
						" ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,est_id);
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
			System.out.println("[SecondhandDatabase:getEstiExam]"+e);
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
	*	�縮�� ���� ���� ������
	*/
	public Hashtable getEstiExamHp(String est_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();

		String query =  " select * from esti_exam_hp where est_id=?"+
						" ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,est_id);
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
			System.out.println("[SecondhandDatabase:getEstiExamHp]"+e);
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
	*	�縮�� ���� ���� ������
	*/
	public Hashtable getEstiExamSh(String est_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();

		String query =  " select * from esti_exam_sh where est_id=?"+
						" ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,est_id);
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
			System.out.println("[SecondhandDatabase:getEstiExamSh]"+e);
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
	*	�⺻������(������ġ������ ���� �����,lpg�����ð���) ��ȸ 2004.12.13.��
	*/
	public Hashtable getBaseRent(String rent_l_cd){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();


		String query =  " select "+
						" b.rent_mng_id, b.rent_l_cd, b.dlv_dt, '' car_mng_id, '' car_no, '' car_no_x, "+
						" to_char(sysdate-365,'yyyymmdd') before_one_year, a.sh_init_reg_dt as init_reg_dt, a.sh_day_bas_dt as secondhand_dt, "+
						" '' fuel_kd, '' park, c.lpg_yn, c.lpg_price, "+
						" d.car_comp_id, d.code, e.car_id, e.car_seq, d.car_nm||' '||e.car_name CAR_NAME, "+
						" c.car_cs_amt+c.car_cv_amt CAR_AMT, c.opt, c.opt_cs_amt+c.opt_cv_amt OPT_AMT, "+
						" c.colo||decode(c.in_col,'','','(����:'||c.in_col||')') as colo, "+
						" c.clr_cs_amt+c.clr_cv_amt CLR_AMT, "+
						" (c.car_cs_amt+c.car_cv_amt+c.opt_cs_amt+c.opt_cv_amt+c.clr_cs_amt+c.clr_cv_amt) o_1, "+
						" a.sh_km tot_dist, a.sh_km_bas_dt serv_dt, a.sh_km as TODAY_DIST,"+
						" e.jg_code, e.s_st, e.sh_code, '' car_use, '' car_ext"+
						" from fee_etc a, cont b, car_etc c, car_mng d, car_nm e "+
						" where a.rent_l_cd=? and a.rent_st='1' "+
						" and nvl(b.use_yn,'Y') = 'Y' "+
						" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd = b.rent_l_cd "+
						" and b.rent_mng_id = c.rent_mng_id and b.rent_l_cd = c.rent_l_cd "+
						" and c.car_id = e.car_id and c.car_seq = e.car_seq "+
						" and d.car_comp_id = e.car_comp_id and d.code = e.car_cd "+
						" ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,rent_l_cd);
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
		}catch(Exception e){
			System.out.println("[SecondhandDatabase:getBaseRent(String rent_l_cd)]"+e);
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
	//	 ���� �ܰ���� ������ ���
	public int insertShCompareSimple(Hashtable ht){
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		int id_chk = 0;

		String query = "";
		String query2 = "";
		int result = 0;

		query = " insert into esti_compare ( EST_ID ) values ( ? ) ";
		query2 = " insert into esti_exam ( EST_ID ) values ( ? ) ";

		try{

			conn.setAutoCommit(false);


				pstmt = conn.prepareStatement(query);
				pstmt.setString(1,  String.valueOf(ht.get("EST_ID")));
				result = pstmt.executeUpdate();
				pstmt.close();

				pstmt2 = conn.prepareStatement(query2);
				pstmt2.setString(1,  String.valueOf(ht.get("EST_ID")));
				result = pstmt2.executeUpdate();
				pstmt2.close();


			conn.commit();

		}catch(SQLException e){
			System.out.println("[SecondhandDatabase:insertShCompareSimple]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
				if(pstmt2 != null) pstmt2.close();
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}
	}

	//�縮��������Ȳ
	public Vector getShResList(String car_mng_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select car_mng_id, seq, damdang_id, situation, reg_dt, res_st_dt, res_end_dt, nvl(use_yn,'') use_yn, memo, cust_nm, cust_tel, nvl(add_cnt,0) add_cnt, nvl(add_cnt_s,0) add_cnt_s, est_id, reg_code, reg_date  "+
				" from   sh_res "+
				" where  car_mng_id='"+car_mng_id+"' and nvl(use_yn,'Y')='Y' and situation in ('0','2','3')"+
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
			System.out.println("[SecondhandDatabase:getShResList]\n"+e);
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

	//�縮��������Ȳ
	public Vector getShResHList(String car_mng_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		query = " select car_mng_id, seq, damdang_id, situation, reg_dt, res_st_dt, res_end_dt, nvl(use_yn,'') use_yn, memo, cust_nm, cust_tel, nvl(add_cnt,0) add_cnt, nvl(add_cnt_s,0) add_cnt_s, est_id, reg_code "+
				" from   sh_res "+
				" where  car_mng_id='"+car_mng_id+"' and situation in ('0','2','3')"+
				" order by seq desc";

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
			System.out.println("[SecondhandDatabase:getShResHList]\n"+e);
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

	//�������
	public Hashtable getCarApprsl(String car_mng_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select d.firm_nm, a.actn_id, a.apprsl_dt, \n"+
				"        decode(b.actn_st,'0','��ǰ����','1','���������','2','����','3','�������','4','����') actn_st_nm, \n"+
				"        b.actn_dt \n"+
				" from   apprsl a, auction b, \n"+
				"        (select car_mng_id, max(seq) seq from auction group by car_mng_id) c, \n"+
				"        client d \n"+
				" where  a.car_mng_id='"+car_mng_id+"' \n"+
				"        and a.car_mng_id=b.car_mng_id(+) \n"+
				"        and b.car_mng_id=c.car_mng_id(+) and b.seq=c.seq(+) \n"+
				"        and a.actn_id=d.client_id(+) \n"+
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
			System.out.println("[SecondhandDatabase:getCarApprsl]\n"+e);
	  		e.printStackTrace();

		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}

	/**
     * ���ν��� ȣ��
     */
	public String call_sp_sh_res_dire_cancel(String car_mng_id, String seq)
	{
    	getConnection();

    	String query = "{CALL P_SH_RES_DIRE_CANCEL(?, ?, ?)}";

		String sResult = "";

		CallableStatement cstmt = null;

		try {

			cstmt = conn.prepareCall(query);
			cstmt.setString(1, car_mng_id);
			cstmt.setString(2, seq);
			cstmt.registerOutParameter( 3, java.sql.Types.VARCHAR );
			cstmt.execute();

			sResult = cstmt.getString(3); // �����

			cstmt.close();


		} catch (SQLException e) {
			System.out.println("[SecondhandDatabase:call_sp_sh_res_dire_cancel]\n"+e);
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
     * ���ν��� ȣ��
     */
	public String call_sp_sh_res_dire_dtset(String gubun, String car_mng_id, String seq, String ret_dt)
	{
    	getConnection();

    	String query = "{CALL P_SH_RES_DIRE_DTSET(?, ?, ?, ?, ?)}";

		String sResult = "";

		CallableStatement cstmt = null;

		try {

			cstmt = conn.prepareCall(query);
			cstmt.setString(1, gubun);
			cstmt.setString(2, car_mng_id);
			cstmt.setString(3, seq);
			cstmt.setString(4, ret_dt);
			cstmt.registerOutParameter( 5, java.sql.Types.VARCHAR );
			cstmt.execute();

			sResult = cstmt.getString(5); // �����

			cstmt.close();


		} catch (SQLException e) {
			System.out.println("[SecondhandDatabase:call_sp_sh_res_dire_dtset]\n"+e);
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
	*	������ ��������Ÿ� ��ȸ
	*/
	public Hashtable getCarDistView(String car_mng_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();

		String query =  " select * from v_tot_dist where car_mng_id='"+car_mng_id+"' ";

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
			System.out.println("[SecondhandDatabase:getCarDistView(String car_mng_id)]"+e);
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
	*	Ư������ �������� ��������Ÿ� ��ȸ 2011.07.12
	*/
	public Hashtable getCarDistView2(String car_mng_id, String tot_dt ){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();

		String query =  " select a.* \n"+
                        " from v_dist a, (select car_mng_id, max(tot_dt||tot_dist||reg_dt) tot from v_dist where car_mng_id='"+car_mng_id+"' and tot_dt<=replace('"+tot_dt+"','-','') group by car_mng_id) b \n"+
                        " where a.car_mng_id=b.car_mng_id and a.tot_dt||a.tot_dist||a.reg_dt=b.tot";

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
			System.out.println("[SecondhandDatabase:getCarDistView(String car_mng_id)]"+e);
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
	*	�縮�� ���� ���� ������
	*/
	public String getSearchEstIdShRm(String car_mng_id, String a_a, String a_b, String o_1, String today_dist, String rent_dt, String amt, String reg_code){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String est_id = "";

		String query =  " select a.est_id from estimate_sh a, esti_compare_sh b where a.est_type = 'S' and a.est_id=b.est_id "+
						" and a.mgr_nm = '"+car_mng_id+"' "+
						" and a.a_a = '"+a_a+"' "+
						" and a.a_b = '"+a_b+"' "+
						" and a.rent_dt	= '"+rent_dt+"' "+
						" and a.fee_s_amt = "+amt+" "+
						" and a.mgr_ssn='rm1'"+
						" ";

		if(!reg_code.equals(""))	query += " and a.reg_code	= "+reg_code+" ";
		if(!today_dist.equals("0"))	query += " and a.today_dist	= "+today_dist+" ";

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();

			if(rs.next())
			{
				 est_id = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
            pstmt.close();

		}catch(Exception e){
			System.out.println("[SecondhandDatabase:getSearchEstIdShRm]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return est_id;
		}
	}

	/**
	*	�縮�� ���� ���� ������
	*/
	public String getSearchEstIdShRes(String car_mng_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String est_id = "";

		String query =  " select a.* "+
				        " from   estimate_sh a, "+
         				"        (select est_ssn, max(est_id) est_id from estimate_sh where est_from ='res_car' and est_fax='Y' and rent_dt like to_char(sysdate,'YYYYMM')||'%' group by est_ssn ) b "+
		         		" where  a.est_ssn='"+car_mng_id+"' and a.est_from ='res_car' and a.est_fax='Y' and a.rent_dt like to_char(sysdate,'YYYYMM')||'%' and  a.est_ssn=b.est_ssn and a.est_id=b.est_id "+
						" ";


		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();

			if(rs.next())
			{
				 est_id = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
            pstmt.close();

		}catch(Exception e){
			System.out.println("[SecondhandDatabase:getSearchEstIdShRes]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return est_id;
		}
	}

	//�縮��������Ȳ
	public Vector getSecondhandList_20120619(String gubun2, String gubun, String gubun_nm, String brch_id, String sort_gubun, String res_yn, String res_mon_yn, String all_car_yn)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String res_mon_order = "";

		query = " select "+
				"        a.rent_mng_id, a.rent_l_cd, b.car_mng_id, b.car_no, b.car_nm, b.car_use, b.secondhand, d.car_name, b.init_reg_dt, b.dpm,"+
				"        cd2.nm as fuel_kd,"+
				"        c.opt, "+
				"        c.colo||decode(c.in_col,'','','(����:'||c.in_col||')') as colo, "+
				"        (c.car_cs_amt+c.car_cv_amt+c.opt_cs_amt+c.opt_cv_amt+c.clr_cs_amt+c.clr_cv_amt) car_c_amt,"+
				"        (c.car_fs_amt+c.car_fv_amt+c.sd_cs_amt+c.sd_cv_amt-c.dc_cs_amt-c.dc_cv_amt) car_f_amt,"+
				"        decode(j.tot_dist,'',0,'0',0,decode(j.serv_dt,nvl(a.dlv_dt,b.init_reg_dt),0,j.tot_dist+round(j.tot_dist/(to_date(j.serv_dt,'YYYYMMDD')-to_date(nvl(a.dlv_dt,b.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(j.serv_dt,'YYYYMMDD')))) as TODAY_DIST,"+
				"        decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(a.dlv_dt,b.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(a.dlv_dt,b.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST2,"+
				"        decode(nvl(l.accid_cnt,0),0,'-','��') accid_yn,"+
				"        /*��  ��*/decode(e.lev,'1','��','2','��','3','��','') lev, e.reason, k.user_nm as lev_nm,"+
				"        /*������*/nvl(h.ret_plan_dt,i.ret_plan_dt) as ret_plan_dt, decode(b.off_ls,'3','���'||o.actn_dt,'1','�Ű�����',decode(nvl(h.rent_st,i.rent_st),'1','�ܱ�뿩','2','�������','3','������','9','�������','10','��������','4','�����뿩','5','�����뿩','6','��������','7','��������','8','������','11','������','12','����Ʈ','���')) rent_st,"+
				"        /*�縮��*/b.secondhand_dt,"+
				"        /*�����*/o.actn_dt, to_char(to_date(o.actn_dt,'YYYYMMDD')+7,'YYYYMMDD') actn_est_dt,"+
				"        /*��  ��*/decode(g.situation,'0','�����','1','���������','2','���Ȯ��','3','��࿬��','���డ��') situation, g.memo, g.reg_dt, m.user_nm as situ_nm, g.res_st_dt, g.res_end_dt, g2.res_cnt,"+
				"        /*���ε�*/nvl(f.upload_dt,'�̰���') as upload_dt, decode(f.rb36, 0,f.lb36, -1,f.lb36, f.rb36) fee_amt, decode(f.rb30, 0,f.lb30, -1,f.lb30, f.rb30) fee_amt_30, f.rm1, (f.rm1*1.1) as rm1_sv, decode(b.secondhand,'1',NVL(f.rb36, f.rs36)) rb, decode(b.secondhand,'1',NVL(f.lb36, f.ls36)) lb, "+
				"        decode(nvl(b.off_ls,'0'),'3',decode(o.actn_st,'1','���������','2','����','3','�������','4','����','��ǰ����'),'') actn_st, "+
				"        decode(b.park,'6',substr(b.park_cont,1,5),nvl(cd.nm,b.park)) park, b.park_cont, "+
				"        TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(replace(b.init_reg_dt,'-',''), 'YYYYMMDD'))) use_mon, e.imgfile1, e.imgfile6, e.img_dt, "+
				"        decode(b.gps,'Y','����') gps, j.serv_dt, d.jg_code,"+
				"        decode(cc.rent_l_cd,'','','�����ݳ�') call_in_st, decode(b.rm_st,'1','���','2','���','6','��Ÿ',' ') rm_st, b.rm_cont, "+
				"        p.park_id, p.area, decode(p.car_mng_id,'','','P') park_yn, "+
				"        decode( p.io_gubun, '1', '�԰�', '2', '���', '3','�Ű�Ȯ��') AS io_gubun_nm, \n"+
				"        decode( p.park_id, '1', '����������', '2', '��������', '3', '�λ�����', '4', '��������', '5', '��������', '7', '�λ�ΰ�', '8', '�λ�뼺', '9', '��������', '11','(��)1�ޱ�ȣ','12','��������','13','�뱸����','14','������' ) AS park_nm  \n"+
				" from   cont a, car_reg b, car_etc c, car_nm d, apprsl e, users k, users m, cont_etc n, "+
				"        ( select c_st, code, nm_cd, nm from code where c_st = '0027') cd,  \n"+  //������ 
				"        ( select c_st, code, nm_cd, nm from code where c_st = '0039') cd2,  \n"+ 
				"        (select * from secondhand a where a.seq = (select max(seq) from secondhand where car_mng_id=a.car_mng_id)) f,"+
				"        (select * from sh_res a     where a.use_yn='Y' and a.situation in ('0','2')) g,"+ //(����������� ������ ���Ǹ� ���)
				"        (select a.car_mng_id, count(0) res_cnt from sh_res a     where a.use_yn is null and a.situation in ('0','2') group by a.car_mng_id) g2,"+ //(����������� ������ ���Ǹ� ���)
				"        (select * from rent_cont a  where a.use_st = '2' and a.rent_st<>'11') h,"+
				"        (select * from rent_cont a  where a.use_st = '1' and a.rent_st<>'11') i,"+
				"        (select * from service a    where a.tot_dist is not null and a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where tot_dist is not null and car_mng_id = a.car_mng_id)) j,"+
				"        (select car_mng_id, count(0) accid_cnt from accident group by car_mng_id) l,"+
				"        (select * from auction a where a.seq = (select max(seq) from auction where car_mng_id=a.car_mng_id)) o, v_tot_dist vt,"+
	            //���������ݳ�
				"        (select * from car_call_in where in_st='3' and out_dt is null) cc, "+
				"        PARK_CONDITION p "+
				" where"+
				"        nvl(a.use_yn,'Y')='Y' and a.car_st='2' "+
				"        and nvl(b.prepare,'0')<>'7'"+
				"        and nvl(b.off_ls,'0') in ('0','1') "+			//��ǰ������ 20100126
				"        and a.car_mng_id=b.car_mng_id"+
				"        and a.rent_l_cd=c.rent_l_cd"+
				"        and c.car_id=d.car_id and c.car_seq=d.car_seq"+
				"        and b.car_mng_id=e.car_mng_id(+)"+
				"        and a.rent_mng_id=n.rent_mng_id(+) and a.rent_l_cd=n.rent_l_cd(+)"+
				"        and b.car_mng_id=f.car_mng_id(+)"+
				"        and b.car_mng_id=g.car_mng_id(+)"+
				"        and b.car_mng_id=g2.car_mng_id(+)"+
				"        and b.car_mng_id=h.car_mng_id(+)"+
				"        and b.car_mng_id=i.car_mng_id(+)"+
				"        and b.car_mng_id=j.car_mng_id(+)"+
				"        and e.damdang_id=k.user_id(+)"+
				"        and b.car_mng_id=l.car_mng_id(+)"+
				"        and a.car_mng_id=o.car_mng_id(+)"+
				"        and a.car_mng_id=vt.car_mng_id(+)"+
				"        and g.damdang_id=m.user_id(+)"+
				"        and a.rent_mng_id=cc.rent_mng_id(+) and a.rent_l_cd=cc.rent_l_cd(+)"+
				"        and a.car_mng_id=p.car_mng_id(+)"+
				"        and b.park = cd.nm_cd(+) \n"+  //������ �ڵ� ���̺� 
				"        and b.fuel_kd = cd2.nm_cd \n"+ 
				"        and decode(cc.rent_l_cd,'',a.car_st,'')='2'"+
				" "	;

		if(res_yn.equals("Y"))				query += " and nvl(g.situation,'-') not in ('0','2')";

		//�縮������
		if(res_mon_yn.equals("") && all_car_yn.equals("")){
												query += " and b.secondhand='1'";
		}else{
			//����Ʈ����
			if(res_mon_yn.equals("Y"))			query += " and b.car_use='1' and (b.secondhand='1' or b.rm_st is not null) ";
			//��ü����
			if(all_car_yn.equals("Y"))			query += " and (b.secondhand='1' or (b.car_use='1' and b.rm_st is not null))";
		}


		if(gubun.equals("car_no"))			query += " and b.car_no like '%"+gubun_nm+"%'";
		if(gubun.equals("car_nm"))			query += " and b.car_nm||d.car_name like '%"+gubun_nm+"%'";
		if(gubun.equals("init_reg_dt"))		query += " and b.init_reg_dt like replace('"+ gubun_nm +"','-','')||'%'";
		if(gubun.equals("park"))			query += " and decode(b.park,'6',substr(b.park_cont,1,5),nvl(cd.nm,b.park)) like '%'||replace('"+ gubun_nm +"','-','')||'%'";
		if(gubun.equals("park_condition"))	query += " and decode(p.park_id, '1', '����������-����', '2', '��������-����', '3', '�λ�����', '4', '��������', '5', '��������-����', '7', '�λ�ΰ�', '8', '�λ�뼺', '9', '��������', '11','(��)1�ޱ�ȣ-����','12','��������','13','�뱸����','14','������' ) like '%"+gubun_nm+"%'";

		if(brch_id.equals("S1"))			query += " and nvl(n.mng_br_id,a.brch_id) in ('S1','K1')";
		if(brch_id.equals("S2"))			query += " and nvl(n.mng_br_id,a.brch_id)='S2'";
		if(brch_id.equals("B1"))			query += " and nvl(n.mng_br_id,a.brch_id) in ('B1','N1')";
		if(brch_id.equals("D1"))			query += " and nvl(n.mng_br_id,a.brch_id)='D1'";



		if(gubun2.equals("1"))			query += " and d.jg_code like '4%' and d.car_comp_id <= '0005' and b.fuel_kd not in ('3','5','6')"; //�����¿�
		else if(gubun2.equals("2"))		query += " and d.jg_code like '3%' and d.car_comp_id <= '0005' and b.fuel_kd not in ('3','5','6')"; //�����¿�
		else if(gubun2.equals("3"))		query += " and d.jg_code between '1000000' and '2999999' and d.car_comp_id <= '0005' and b.fuel_kd not in ('3','5','6')"; //�����¿�
		else if(gubun2.equals("4"))		query += " and d.jg_code like '4%' and d.car_comp_id <= '0005' and b.fuel_kd in ('3','5','6')"; //�����¿�LPG
		else if(gubun2.equals("5"))		query += " and d.jg_code like '3%' and d.car_comp_id <= '0005' and b.fuel_kd in ('3','5','6')"; //���������¿�LPG
		else if(gubun2.equals("8"))		query += " and d.jg_code between '1000000' and '2999999' and d.car_comp_id <= '0005' and b.fuel_kd in ('3','5','6')"; //�����¿�LPG
		else if(gubun2.equals("6"))		query += " and d.jg_code between '5000000' and '9999999' and d.car_comp_id <= '0005' "; //���� RV�ױ�Ÿ(����,ȭ��)
		else if(gubun2.equals("7"))		query += " and d.car_comp_id > '0005' "; //������

		if(res_mon_yn.equals("Y")){
			res_mon_order = " decode(nvl(g.situation,'0'), '2',1, 0), decode(p.park_id, '1', '1', '2', '2', '3', '4', '4', '7', '5', '3', '7', '5', '8', '6', '9', '8', '99' ), ";
		}


		if(sort_gubun.equals("car_kind")){


			//20101021 : ����LPG,����LPG,����LPG,����,����,����,RV,���� ������ ���� ����
			query += " ORDER BY "+res_mon_order+" "+
					 "          decode(nvl(g.situation,'0'), '2',1, 0), "+ //���Ȯ���� �ǾƷ���
					 "          decode(d.car_comp_id, '0001',0, '0002',0, '0003',0, '0004',0, '0005',0, 1), "+ //�������� ��, �������� �Ʒ���
				     "          decode(b.fuel_kd, '3',0, '5',0, '6',0, 1), "+//LPG����
				     "          d.jg_code, d.car_b_p, d.car_name, b.init_reg_dt, b.car_mng_id ";

		}else if(sort_gubun.equals("situation")){

			query += " order by "+res_mon_order+" decode(g.situation,'',1,'0',2,'1',3,'2',4) ";

			query += ", b.fuel_kd, b.dpm DESC, b.car_nm||d.car_name  ";

		}else{

			if(sort_gubun.equals("today_dist2")){
				query += " order by "+res_mon_order+" decode(nvl(g.situation,'0'),'2',1,0), decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(a.dlv_dt,b.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(a.dlv_dt,b.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD'))))";
			}else{
				query += " order by "+res_mon_order+" decode(nvl(g.situation,'0'),'2',1,0) ";

				if(sort_gubun.equals("car_nm"))				query += ", b.car_nm||d.car_name";
				else if(sort_gubun.equals("car_no"))		query += ", b.car_no ";
				else if(sort_gubun.equals("init_reg_dt"))	query += ", b.init_reg_dt ";
				else if(sort_gubun.equals("fuel_kd"))		query += ", cd2.nm ";
				else if(sort_gubun.equals("dpm"))			query += ", b.fuel_kd, b.dpm desc, b.car_nm||d.car_name  ";
				else if(sort_gubun.equals("secondhand_dt"))	query += ", b.secondhand_dt ";
				else if(sort_gubun.equals("colo"))			query += ", c.colo ";
				else if(sort_gubun.equals("fee_amt"))		query += ", decode(f.rb36, 0,f.lb36, -1,f.lb36, f.rb36) ";
				else										query += ", b.fuel_kd, b.dpm DESC, b.car_nm||d.car_name  ";
			}


			//20101021 : ����LPG,����LPG,����LPG,����,����,����,RV,���� ������ ���� ����
			query += "   , decode(d.car_comp_id, '0001',0, '0002',0, '0003',0, '0004',0, '0005',0, 1), "+ //�������� ��, �������� �Ʒ���
				     "          decode(b.fuel_kd, '3',0, '5',0, '6',0, 1), "+//LPG����
				     "          d.jg_code, d.car_b_p, d.car_name, b.init_reg_dt, b.car_mng_id ";


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
			System.out.println("[SecondhandDatabase:getSecondhandList_20120619]\n"+e);
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

	//������Ȳ - ����Ʈ
	public Vector getSecondhandList_RM(String gubun2, String gubun, String gubun_nm, String brch_id, String sort_gubun, String res_yn, String res_mon_yn, String all_car_yn)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String r_query = "";

		query = " select "+
				"        a.rent_mng_id, a.rent_l_cd, b.car_mng_id, b.car_no, b.car_nm, d.car_name, b.init_reg_dt, b.dpm, b.secondhand_dt, "+
				"        cd2.nm as fuel_kd,"+
				"        c.opt,  "+
				"        c.colo||decode(c.in_col,'','','(����:'||c.in_col||')') as colo, "+
				"        decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(a.dlv_dt,b.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(a.dlv_dt,b.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST2,"+
				"        decode(nvl(l.accid_cnt,0),0,'-','��') accid_yn,"+
				"        decode(a.car_st, '4', r.use_e_dt, nvl(h.ret_plan_dt,i.ret_plan_dt)) AS ret_plan_dt, "+
				"	     decode(a.car_st, '4','����Ʈ',decode(b.off_ls,'3','���'||o.actn_dt,'1','�Ű�����',decode(nvl(h.rent_st,i.rent_st),'1','�ܱ�뿩','2','�������','3','������','9','�������','10','��������','4','�����뿩','5','�����뿩','6','��������','7','��������','8','������','11','������','12','����Ʈ','���'))) rent_st,"+
				"        o.actn_dt, to_char(to_date(o.actn_dt,'YYYYMMDD')+7,'YYYYMMDD') actn_est_dt,"+
				"        decode(g.situation,'0','�����','1','���������','2','���Ȯ��','3','��࿬��','���డ��') situation, "+
				"        g.memo, m.user_nm as situ_nm, g.res_st_dt, g.res_end_dt, g2.res_cnt,"+
				"        nvl(f.upload_dt,'�̰���') as upload_dt, "+
				"        decode(b.car_use,'1',f.rm1,0) rm1, decode(b.car_use,'1',(f.rm1*1.1),0) as rm1_sv, "+
				"        decode(nvl(b.off_ls,'0'),'3',decode(o.actn_st,'1','���������','2','����','3','�������','4','����','��ǰ����'),'') actn_st, "+
				"        decode(b.park,'6',substr(b.park_cont,1,5),nvl(cd.nm,b.park))  park, b.park_cont, "+
				"        TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(replace(b.init_reg_dt,'-',''), 'YYYYMMDD'))) use_mon, "+
				"        d.jg_code,"+
				"        decode(b.rm_st,'1','���','6','��Ÿ','2','���','3','�����','5','�����','4','A��','7','B��','8','C��','9','�̵���','��Ȯ��') rm_st, b.rm_cont, "+
				"        p.park_id, p.area, "+
				"        decode( p.park_id, '1', '����������', '2', '��������', '3', '�λ�����', '4', '��������', '5', '��������', '7', '�λ�ΰ�', '8', '�λ�뼺', '9', '��������', '10', '����ũ��', '11','(��)1�ޱ�ȣ','12','��������','13','�뱸����','14','������' ) AS park_nm,  \n"+
			    "        decode( p.park_id, '1', '����������-����', '2', '��������-����', '3', '�λ�����', '4', '��������', '5', '��������-����', '7', '�λ�ΰ�', '8', '�λ�뼺', '9', '��������','12', '10', '����ũ��-����', '11','(��)1�ޱ�ȣ-����', '12','��������','13','�뱸����','14','������-����' ) AS s_park_nm,  \n"+
                "        nvl(h2.pic_cnt,0) pic_cnt, h2.pic_reg_dt, "+
	            "        case when a.car_st='2' and g.situation is null and p.car_mng_id is not null and b.off_ls not in ('1','3') and h.car_mng_id is null and i.car_mng_id is null and nvl(b.rm_st,'0')<>'3' then 'Y3' "+
                "             when decode(a.car_st,'4',to_char(to_date(r.use_e_dt,'YYYYMMDD')-3,'YYYYMMDD'), decode(nvl(h.rent_st,i.rent_st),'',to_char(sysdate,'YYYYMMDD'),to_char(to_date(substr(h.ret_plan_dt,1,8),'YYYYMMDD')-3,'YYYYMMDD'))) <= to_char(sysdate,'YYYYMMDD') then 'Y4' "+
				"             when a.car_st='4' then 'Y5' "+
       		    "             else 'Y' end res_mon_yn, "+
			    "        decode(NVL(p.park_id,b.park),'1','S1','2','S1','3','B1','4','D1','5','S1','7','B1','8','B1','9','D1','12','J1','13','G1','14','J1', nvl(n.mng_br_id,a.brch_id)) brch_id, "+
				"        decode(d.car_comp_id, '0001','������', '0002','������', '0003','������', '0004','������', '0005','������', '������') s_car_comp, "+
				"        decode(b.fuel_kd, '3',0, '5',0, '6',0, 1) s_fuel, d.car_b_p "+
				" from   cont a, car_reg b, car_etc c, car_nm d, users m, cont_etc n, "+
				"        (select c_st, code, nm_cd, nm from code where c_st = '0027') cd,  \n"+  //������ 
				"        (select c_st, code, nm_cd, nm from code where c_st = '0039') cd2,  \n"+ 
				"        (select * from secondhand a where a.seq = (select max(seq) from secondhand where car_mng_id=a.car_mng_id AND RM1>0 )) f,"+
				"        (select * from sh_res a     where a.use_yn='Y' and a.situation in ('0','2')) g,"+ //(����������� ������ ���Ǹ� ���)
				"        (select a.car_mng_id, count(0) res_cnt from sh_res a     where a.use_yn is null and a.situation in ('0','2') group by a.car_mng_id) g2,"+ //(����������� ������ ���Ǹ� ���)
				"        (select * from rent_cont a  where a.use_st = '2' and a.rent_st<>'11') h,"+//����
				"        (select * from rent_cont a  where a.use_st = '1' and a.rent_st<>'11') i,"+//����
				"        (select car_mng_id, count(0) accid_cnt from accident group by car_mng_id) l,"+
				"        (select * from auction a where a.seq = (select max(seq) from auction where car_mng_id=a.car_mng_id)) o, v_tot_dist vt,"+
				"        PARK_CONDITION p, "+
				"        (SELECT rent_mng_id, rent_l_cd, max(use_e_dt) use_e_dt FROM scd_fee GROUP BY rent_mng_id, rent_l_cd) r, \n"+
				"        (select SUBSTR(content_seq,1,6) car_mng_id, count(0) pic_cnt, TO_CHAR(MAX(reg_date),'YYYYMMDD') pic_reg_dt from ACAR_ATTACH_FILE where content_code='APPRSL' and NVL(isdeleted,'N')<>'Y' group by SUBSTR(content_seq,1,6)) h2 "+
				" where"+
				"        a.car_st IN ('2','4') and a.use_yn='Y' \n "+
				"        and a.car_mng_id=b.car_mng_id "+
                "        and b.car_use='1' "+
				"		 and nvl(b.rm_yn, 'Y') <> 'N' "+				//����Ʈ���� ����
				"        and nvl(b.off_ls,'0') in ('0') "+				//��ǰ������ 20100126
				"        and nvl(b.prepare,'0') IN ('0','1','2','7') "+	//��������,�Ű���������,�縮������ (��������,��������,��������,���,�������� ����)
				"        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd"+
				"        and a.rent_mng_id=n.rent_mng_id and a.rent_l_cd=n.rent_l_cd"+
				"        and c.car_id=d.car_id and c.car_seq=d.car_seq"+
				"        and b.car_mng_id=f.car_mng_id(+) "+
				"        and a.rent_mng_id=r.rent_mng_id(+) and a.rent_l_cd=r.rent_l_cd(+)"+
				"        and b.car_mng_id=g.car_mng_id(+)"+
				"        and b.car_mng_id=g2.car_mng_id(+)"+
				"        and b.car_mng_id=h.car_mng_id(+)"+
				"        and b.car_mng_id=i.car_mng_id(+)"+
				"        and b.car_mng_id=l.car_mng_id(+)"+
				"        and a.car_mng_id=o.car_mng_id(+)"+
				"        and a.car_mng_id=vt.car_mng_id(+)"+
				"        and g.damdang_id=m.user_id(+)"+
				"        and a.car_mng_id=p.car_mng_id(+)"+
				"        and b.park = cd.nm_cd(+) \n"+  //������ �ڵ� ���̺� 
				"        and b.fuel_kd = cd2.nm_cd \n"+  
				"        and b.car_mng_id=h2.car_mng_id(+)"+
				" "	;

		//����� ����	
		if(res_yn.equals("Y")){
			query += " and g.situation is null"; 
		}

		if(gubun2.equals("1"))				query += " and d.jg_code like '4%' and d.car_comp_id <= '0005' and b.fuel_kd not in ('3','5','6')"; //�����¿�
		else if(gubun2.equals("2"))			query += " and d.jg_code like '3%' and d.car_comp_id <= '0005' and b.fuel_kd not in ('3','5','6')"; //�����¿�
		else if(gubun2.equals("3"))			query += " and d.jg_code between '1000000' and '2999999' and d.car_comp_id <= '0005' and b.fuel_kd not in ('3','5','6')"; //�����¿�
		else if(gubun2.equals("4"))			query += " and d.jg_code like '4%' and d.car_comp_id <= '0005' and b.fuel_kd in ('3','5','6')"; //�����¿�LPG
		else if(gubun2.equals("5"))			query += " and d.jg_code like '3%' and d.car_comp_id <= '0005' and b.fuel_kd in ('3','5','6')"; //���������¿�LPG
		else if(gubun2.equals("8"))			query += " and d.jg_code between '1000000' and '2999999' and d.car_comp_id <= '0005' and b.fuel_kd in ('3','5','6')"; //�����¿�LPG
		else if(gubun2.equals("6"))			query += " and d.jg_code between '5000000' and '9999999' and d.car_comp_id <= '0005' "; //���� RV�ױ�Ÿ(����,ȭ��)
		else if(gubun2.equals("7"))			query += " and d.car_comp_id > '0005' "; //������


		r_query = " select * from ("+query+") where res_mon_yn='"+res_mon_yn+"'";
	
		if(!brch_id.equals("")){
			r_query += " and brch_id = '"+brch_id+"'";	
		}

		if(!gubun_nm.equals("")){
	 		if(gubun.equals("car_no"))			r_query += " and car_no like '%"+gubun_nm+"%'";
			if(gubun.equals("car_nm"))			r_query += " and car_nm||car_name like '%"+gubun_nm+"%'";
			if(gubun.equals("init_reg_dt"))		r_query += " and init_reg_dt like replace('"+ gubun_nm +"','-','')||'%'";
			if(gubun.equals("park"))			r_query += " and park like '%'||replace('"+ gubun_nm +"','-','')||'%'";
			if(gubun.equals("park_condition"))	r_query += " and s_park_nm like '%"+gubun_nm+"%'";
			if(gubun.equals("situ_nm"))			r_query += " and situ_nm like '%"+gubun_nm+"%'"; //������ �˻�
		}

		if(sort_gubun.equals("car_kind")){

			//20101021 : ����LPG,����LPG,����LPG,����,����,����,RV,���� ������ ���� ����
			r_query += " ORDER BY decode(situation, '���Ȯ��',1, '��࿬��',2, 0), "+ //���Ȯ���� �ǾƷ���
					 "          decode(s_car_comp, '������',0, 1), "+ //�������� ��, �������� �Ʒ���
				     "          s_fuel, "+//LPG����
				     "          jg_code ";

			if(res_mon_yn.equals("Y")){
				r_query += ", rm1 ";
			}

			r_query += ", car_b_p, car_name, init_reg_dt, car_mng_id ";

		}else if(sort_gubun.equals("situation")){

			r_query += " order by decode(situation,'',1,'�����',2,'���Ȯ��',3,'��࿬��',4) ";

			r_query += ", s_fuel, jg_code, car_b_p, car_name, init_reg_dt, car_mng_id";

		}else{

			if(sort_gubun.equals("today_dist2")){
				r_query += " order by decode(situation, '���Ȯ��',1, '��࿬��',2, 0), today_dist2";
			}else{
				r_query += " order by decode(situation, '���Ȯ��',1, '��࿬��',2, 0) ";

				if(sort_gubun.equals("car_nm"))				r_query += ", car_nm||car_name";
				else if(sort_gubun.equals("car_no"))		r_query += ", car_no ";
				else if(sort_gubun.equals("init_reg_dt"))	r_query += ", init_reg_dt ";
				else if(sort_gubun.equals("fuel_kd"))		r_query += ", fuel_kd ";
				else if(sort_gubun.equals("dpm"))			r_query += ", fuel_kd, dpm desc, car_nm, car_name  ";
				else if(sort_gubun.equals("secondhand_dt"))	r_query += ", secondhand_dt ";
				else if(sort_gubun.equals("colo"))			r_query += ", colo ";
				else if(sort_gubun.equals("fee_amt"))		r_query += ", rm1 ";
				else										r_query += ", fuel_kd, dpm DESC, car_nmd.car_name  ";
			}

			r_query += "   , decode(s_car_comp, '������',0, 1), "+ //�������� ��, �������� �Ʒ���
				     "          s_fuel, "+//LPG����
				     "          jg_code, car_b_p, car_name, init_reg_dt, car_mng_id ";

		}


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
		} catch (SQLException e) {
			System.out.println("[SecondhandDatabase:getSecondhandList_RM]\n"+e);
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

	//������Ȳ - ����Ʈ
	public Vector getSecondhandList_RM_B(String gubun2, String gubun, String gubun_nm, String brch_id, String sort_gubun, String res_yn, String res_mon_yn, String all_car_yn)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String res_mon_order = "";

		query = " select "+
				"        a.rent_mng_id, a.rent_l_cd, b.car_mng_id, b.car_no, b.car_nm, d.car_name, b.init_reg_dt, "+
				"        cd2.nm as fuel_kd,"+
				"        c.opt, "+
				"        c.colo||decode(c.in_col,'','','(����:'||c.in_col||')') as colo, "+
				"        decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(a.dlv_dt,b.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(a.dlv_dt,b.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST2,"+
				"        decode(nvl(l.accid_cnt,0),0,'-','��') accid_yn,"+
				"        decode(a.car_st, '4', r.use_e_dt, nvl(h.ret_plan_dt,i.ret_plan_dt)) AS ret_plan_dt, "+
				"	     decode(a.car_st, '4','����Ʈ',decode(b.off_ls,'3','���'||o.actn_dt,'1','�Ű�����',decode(nvl(h.rent_st,i.rent_st),'1','�ܱ�뿩','2','�������','3','������','9','�������','10','��������','4','�����뿩','5','�����뿩','6','��������','7','��������','8','������','11','������','12','����Ʈ','���'))) rent_st,"+
				"        o.actn_dt, to_char(to_date(o.actn_dt,'YYYYMMDD')+7,'YYYYMMDD') actn_est_dt,"+
				"        decode(g.situation,'0','�����','1','���������','2','���Ȯ��','3','��࿬��','���డ��') situation, "+
				"        g.memo, m.user_nm as situ_nm, g.res_st_dt, g.res_end_dt, g2.res_cnt,"+
				"        nvl(f.upload_dt,'�̰���') as upload_dt, "+
				"        decode(b.car_use,'1',f.rm1,0) rm1, decode(b.car_use,'1',(f.rm1*1.1),0) as rm1_sv, "+
				"        decode(nvl(b.off_ls,'0'),'3',decode(o.actn_st,'1','���������','2','����','3','�������','4','����','��ǰ����'),'') actn_st, "+
				"        decode(b.park,'6',substr(b.park_cont,1,5),nvl(cd.nm,b.park))  park, b.park_cont, "+
				"        TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(replace(b.init_reg_dt,'-',''), 'YYYYMMDD'))) use_mon, "+
				"        d.jg_code,"+
				"        decode(b.rm_st,'1','���','6','��Ÿ','2','���','3','�����','5','�����','4','A��','7','B��','8','C��','9','�̵���','��Ȯ��') rm_st, b.rm_cont, "+
				"        p.park_id, p.area, "+
				"        decode( p.park_id, '1', '����������', '2', '��������', '3', '�λ�����', '4', '��������', '5', '��������', '7', '�λ�ΰ�', '8', '�λ�뼺', '9', '��������', '10', '����ũ��', '11','(��)1�ޱ�ȣ','12','��������','13','�뱸����','14','������' ) AS park_nm,  \n"+
                "        nvl(h2.pic_cnt,0) pic_cnt, h2.pic_reg_dt "+
				" from   cont a, car_reg b, car_etc c, car_nm d, users m, cont_etc n, "+
				"        (select c_st, code, nm_cd, nm from code where c_st = '0027') cd,  \n"+  //������ 
				"        (select c_st, code, nm_cd, nm from code where c_st = '0039') cd2,  \n"+  
				"        (select * from secondhand a where a.seq = (select max(seq) from secondhand where car_mng_id=a.car_mng_id AND RM1>0 )) f,"+
				"        (select * from sh_res a     where a.use_yn='Y' and a.situation in ('0','2')) g,"+ //(����������� ������ ���Ǹ� ���)
				"        (select a.car_mng_id, count(0) res_cnt from sh_res a     where a.use_yn is null and a.situation in ('0','2') group by a.car_mng_id) g2,"+ //(����������� ������ ���Ǹ� ���)
				"        (select * from rent_cont a  where a.use_st = '2' and a.rent_st<>'11') h,"+//����
				"        (select * from rent_cont a  where a.use_st = '1' and a.rent_st<>'11') i,"+//����
				"        (select car_mng_id, count(0) accid_cnt from accident group by car_mng_id) l,"+
				"        (select * from auction a where a.seq = (select max(seq) from auction where car_mng_id=a.car_mng_id)) o, v_tot_dist vt,"+
				"        PARK_CONDITION p, "+
				"        (SELECT rent_mng_id, rent_l_cd, max(use_e_dt) use_e_dt FROM scd_fee GROUP BY rent_mng_id, rent_l_cd) r, \n"+
				"        (select SUBSTR(content_seq,1,6) car_mng_id, count(0) pic_cnt, TO_CHAR(MAX(reg_date),'YYYYMMDD') pic_reg_dt from ACAR_ATTACH_FILE where content_code='APPRSL' and NVL(isdeleted,'N')<>'Y' group by SUBSTR(content_seq,1,6)) h2 "+
				" where"+
				"        a.car_st IN ('2','4') and a.use_yn='Y' \n "+
				"        and a.car_mng_id=b.car_mng_id "+
                "        and b.car_use='1' "+
				"		 and nvl(b.rm_yn, 'Y') <> 'N' "+				//����Ʈ���� ����
				"        and nvl(b.off_ls,'0') in ('0') "+				//��ǰ������ 20100126
				"        and nvl(b.prepare,'0') IN ('0','1','2','7') "+	//��������,�Ű���������,�縮������ (��������,��������,��������,���,�������� ����)
				"        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd"+
				"        and a.rent_mng_id=n.rent_mng_id and a.rent_l_cd=n.rent_l_cd"+
				"        and c.car_id=d.car_id and c.car_seq=d.car_seq"+
				"        and b.car_mng_id=f.car_mng_id(+) "+
				"        and a.rent_mng_id=r.rent_mng_id(+) and a.rent_l_cd=r.rent_l_cd(+)"+
				"        and b.car_mng_id=g.car_mng_id(+)"+
				"        and b.car_mng_id=g2.car_mng_id(+)"+
				"        and b.car_mng_id=h.car_mng_id(+)"+
				"        and b.car_mng_id=i.car_mng_id(+)"+
				"        and b.car_mng_id=l.car_mng_id(+)"+
				"        and a.car_mng_id=o.car_mng_id(+)"+
				"        and a.car_mng_id=vt.car_mng_id(+)"+
				"        and g.damdang_id=m.user_id(+)"+
				"        and a.car_mng_id=p.car_mng_id(+)"+
				"        and b.park = cd.nm_cd(+) \n"+  //������ �ڵ� ���̺� 
				"        and b.fuel_kd = cd2.nm_cd \n"+  
				"        and b.car_mng_id=h2.car_mng_id(+)"+
				" "	;

		//����� ����	
		if(res_yn.equals("Y")){
			query += " and g.situation is null"; 
		}

		//����Ʈ����-��ü	: ����Ʈ �뿩�߿� ��γ���  /* 3���̳� ���������� �������� */
		if(!res_mon_yn.equals("Y5")){
			query += " AND decode(a.car_st,'4',to_char(to_date(substr(r.use_e_dt,1,8),'YYYYMMDD')-3,'YYYYMMDD'), to_char(sysdate,'YYYYMMDD')) <= to_char(sysdate,'YYYYMMDD') ";
		}

		//����Ʈ(3���̳� ��������)	
		if(res_mon_yn.equals("Y4")){
			query += " and decode(nvl(h.rent_st,i.rent_st),'',to_char(sysdate,'YYYYMMDD'),to_char(to_date(substr(h.ret_plan_dt,1,8),'YYYYMMDD')-3,'YYYYMMDD')) <= to_char(sysdate,'YYYYMMDD') ";
		}

		//����Ʈ��ð�������
		if(res_mon_yn.equals("Y3")){
			query += " and a.car_st='2' "+
			         " and g.situation is null  "+
                     " and p.car_mng_id is not null  "+
                     " and b.off_ls not in ('1','3')  "+
                     " and h.car_mng_id is null  "+
                     " and i.car_mng_id is null  "+
                     " and nvl(b.rm_st,'0')<>'3' "+
					 " ";
		}

		//����Ʈ(�뿩��������)	
		if(res_mon_yn.equals("Y5")){//����Ʈ �뿩������
			query += " and a.car_st = '4' ";
		}

		if(gubun.equals("car_no"))			query += " and b.car_no like '%"+gubun_nm+"%'";
		if(gubun.equals("car_nm"))			query += " and b.car_nm||d.car_name like '%"+gubun_nm+"%'";
		if(gubun.equals("init_reg_dt"))		query += " and b.init_reg_dt like replace('"+ gubun_nm +"','-','')||'%'";
		if(gubun.equals("park"))			query += " and decode(b.park,'6',substr(b.park_cont,1,5),nvl(cd.nm,b.park))   like '%'||replace('"+ gubun_nm +"','-','')||'%'";
		if(gubun.equals("park_condition"))	query += " and decode(p.park_id, '1', '����������-����', '2', '��������-����', '3', '�λ�����', '4', '��������', '5', '��������-����', '7', '�λ�ΰ�', '8', '�λ�뼺', '9', '��������','12','��������','13','�뱸����','14','������' ) like '%"+gubun_nm+"%'";
		if(gubun.equals("situ_nm"))			query += " and m.user_nm like '%"+gubun_nm+"%'"; //������ �˻�

		//����
		if(brch_id.equals("S1"))			query += " and decode(NVL(p.park_id,b.park),'1','S1','2','S1','3','B1','4','D1','5','S1','7','B1','8','B1','9','D1','12','J1','13','G1','14','J1', nvl(n.mng_br_id,a.brch_id)) = 'S1' ";
		if(brch_id.equals("B1"))			query += " and decode(NVL(p.park_id,b.park),'1','S1','2','S1','3','B1','4','D1','5','S1','7','B1','8','B1','9','D1','12','J1','13','G1','14','J1', nvl(n.mng_br_id,a.brch_id)) = 'B1' ";
		if(brch_id.equals("D1"))			query += " and decode(NVL(p.park_id,b.park),'1','S1','2','S1','3','B1','4','D1','5','S1','7','B1','8','B1','9','D1','12','J1','13','G1','14','J1', nvl(n.mng_br_id,a.brch_id)) = 'D1' ";
		if(brch_id.equals("J1"))			query += " and decode(NVL(p.park_id,b.park),'1','S1','2','S1','3','B1','4','D1','5','S1','7','B1','8','B1','9','D1','12','J1','13','G1','14','J1', nvl(n.mng_br_id,a.brch_id)) = 'J1' ";
		if(brch_id.equals("G1"))			query += " and decode(NVL(p.park_id,b.park),'1','S1','2','S1','3','B1','4','D1','5','S1','7','B1','8','B1','9','D1','12','J1','13','G1','14','J1', nvl(n.mng_br_id,a.brch_id)) = 'G1' ";

		if(gubun2.equals("1"))				query += " and d.jg_code like '4%' and d.car_comp_id <= '0005' and b.fuel_kd not in ('3','5','6')"; //�����¿�
		else if(gubun2.equals("2"))			query += " and d.jg_code like '3%' and d.car_comp_id <= '0005' and b.fuel_kd not in ('3','5','6')"; //�����¿�
		else if(gubun2.equals("3"))			query += " and d.jg_code between '1000000' and '2999999' and d.car_comp_id <= '0005' and b.fuel_kd not in ('3','5','6')"; //�����¿�
		else if(gubun2.equals("4"))			query += " and d.jg_code like '4%' and d.car_comp_id <= '0005' and b.fuel_kd in ('3','5','6')"; //�����¿�LPG
		else if(gubun2.equals("5"))			query += " and d.jg_code like '3%' and d.car_comp_id <= '0005' and b.fuel_kd in ('3','5','6')"; //���������¿�LPG
		else if(gubun2.equals("8"))			query += " and d.jg_code between '1000000' and '2999999' and d.car_comp_id <= '0005' and b.fuel_kd in ('3','5','6')"; //�����¿�LPG
		else if(gubun2.equals("6"))			query += " and d.jg_code between '5000000' and '9999999' and d.car_comp_id <= '0005' "; //���� RV�ױ�Ÿ(����,ȭ��)
		else if(gubun2.equals("7"))			query += " and d.car_comp_id > '0005' "; //������



		if(sort_gubun.equals("car_kind")){



			//20101021 : ����LPG,����LPG,����LPG,����,����,����,RV,���� ������ ���� ����
			if(res_mon_yn.equals("Y")||res_mon_yn.equals("Y2")){

			query += " ORDER BY "+res_mon_order+" "+
					 "          decode(nvl(g.situation,'0'), '2',1, 0), "+ //���Ȯ���� �ǾƷ���
					 "          decode(d.car_comp_id, '0001',0, '0002',0, '0003',0, '0004',0, '0005',0, 1), "+ //�������� ��, �������� �Ʒ���
				     "          decode(b.fuel_kd, '3',0, '5',0, '6',0, 1), "+//LPG����
				     "          d.jg_code,f.rm1, d.car_b_p, d.car_name, b.init_reg_dt, b.car_mng_id ";
			}else{
			query += " ORDER BY "+res_mon_order+" "+
					 "          decode(nvl(g.situation,'0'), '2',1, 0), "+ //���Ȯ���� �ǾƷ���
					 "          decode(d.car_comp_id, '0001',0, '0002',0, '0003',0, '0004',0, '0005',0, 1), "+ //�������� ��, �������� �Ʒ���
				     "          decode(b.fuel_kd, '3',0, '5',0, '6',0, 1), "+//LPG����
				     "          d.jg_code,  d.car_b_p, d.car_name, b.init_reg_dt, b.car_mng_id ";
			}
		}else if(sort_gubun.equals("reg_code")){

			query += " order by d.jg_code, d.car_comp_id, d.car_cd, d.car_b_p, c.opt_cs_amt, a.dlv_dt ";

		}else if(sort_gubun.equals("situation")){

			query += " order by "+res_mon_order+" decode(g.situation,'',1,'0',2,'1',3,'2',4) ";

			query += ", b.fuel_kd, b.dpm DESC, b.car_nm||d.car_name  ";

		}else{

			if(sort_gubun.equals("today_dist2")){
				query += " order by "+res_mon_order+" decode(nvl(g.situation,'0'),'2',1,0), decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(a.dlv_dt,b.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(a.dlv_dt,b.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD'))))";
			}else{
				query += " order by "+res_mon_order+" decode(nvl(g.situation,'0'),'2',1,0) ";

				if(sort_gubun.equals("car_nm"))				query += ", b.car_nm||d.car_name";
				else if(sort_gubun.equals("car_no"))		query += ", b.car_no ";
				else if(sort_gubun.equals("init_reg_dt"))	query += ", b.init_reg_dt ";
				else if(sort_gubun.equals("fuel_kd"))		query += ", cd2.nm  ";
				else if(sort_gubun.equals("dpm"))			query += ", b.fuel_kd, b.dpm desc, b.car_nm||d.car_name  ";
				else if(sort_gubun.equals("secondhand_dt"))	query += ", b.secondhand_dt ";
				else if(sort_gubun.equals("colo"))			query += ", c.colo ";
				else if(sort_gubun.equals("fee_amt"))		query += ", decode(f.rb36, 0,f.lb36, -1,f.lb36, f.rb36) ";
				else										query += ", b.fuel_kd, b.dpm DESC, b.car_nm||d.car_name  ";
			}

			//20101021 : ����LPG,����LPG,����LPG,����,����,����,RV,���� ������ ���� ����
			query += "   , decode(d.car_comp_id, '0001',0, '0002',0, '0003',0, '0004',0, '0005',0, 1), "+ //�������� ��, �������� �Ʒ���
				     "          decode(b.fuel_kd, '3',0, '5',0, '6',0, 1), "+//LPG����
				     "          d.jg_code, d.car_b_p, d.car_name, b.init_reg_dt, b.car_mng_id ";


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
			System.out.println("[SecondhandDatabase:getSecondhandList_RM_B]\n"+e);
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


	//�縮��������Ȳ -
	public Vector getSecondhandList_20120821(String gubun2, String gubun, String gubun_nm, String brch_id, String sort_gubun, String res_yn, String res_mon_yn, String all_car_yn, String agent_yn)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String res_mon_order = "";


		query = " select "+
				"        a.rent_mng_id, a.rent_l_cd, b.car_mng_id, b.car_no, b.car_nm, b.car_use, b.secondhand, d.car_name, b.init_reg_dt, b.dpm,"+
				"        cd2.nm as fuel_kd,"+
				"        c.opt, b.car_y_form, "+
				"        c.colo||decode(c.in_col,'','','(����:'||c.in_col||')') as colo, "+
				"        (c.car_cs_amt+c.car_cv_amt+c.opt_cs_amt+c.opt_cv_amt+c.clr_cs_amt+c.clr_cv_amt) car_c_amt,"+
				"        (c.car_fs_amt+c.car_fv_amt+c.sd_cs_amt+c.sd_cv_amt-c.dc_cs_amt-c.dc_cv_amt) car_f_amt,"+
				"        decode(j.tot_dist,'',0,'0',0,decode(j.serv_dt,nvl(a.dlv_dt,b.init_reg_dt),0,j.tot_dist+round(j.tot_dist/(to_date(j.serv_dt,'YYYYMMDD')-to_date(nvl(a.dlv_dt,b.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(j.serv_dt,'YYYYMMDD')))) as TODAY_DIST,"+
				"        decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(a.dlv_dt,b.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(a.dlv_dt,b.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST2,"+
				"        vt.tot_dist, vt.tot_dt, "+
				"        decode(nvl(l.accid_cnt,0),0,'-','��') accid_yn,"+
				"        /*��  ��*/decode(e.lev,'1','��','2','��','3','��','') lev, e.reason, k.user_nm as lev_nm,"+
				"        /*������*/decode(a.car_st, '4', r.use_e_dt, nvl(h.ret_plan_dt,i.ret_plan_dt)) AS ret_plan_dt, DECODE(a.car_st, '4','����Ʈ',decode(b.off_ls,'3','���'||o.actn_dt,'1','�Ű�����',decode(nvl(h.rent_st,i.rent_st),'1','�ܱ�뿩','2','�������','3','������','9','�������','10','��������','4','�����뿩','5','�����뿩','6','��������','7','��������','8','������','11','������','12','����Ʈ','���'))) rent_st,"+//||decode(h.rent_st,'',decode(i.rent_st,'','','����'))
				"        /*�縮��*/b.secondhand_dt,"+
				"        /*�����*/o.actn_dt, to_char(to_date(o.actn_dt,'YYYYMMDD')+7,'YYYYMMDD') actn_est_dt,"+
				"        /*��  ��*/decode(g.situation,'0','�����','1','���������','2','���Ȯ��','3','��࿬��','���డ��') situation, g.memo, g.reg_dt, m.user_nm as situ_nm, g.res_st_dt, g.res_end_dt, g2.res_cnt,"+
				"        /*���ε�*/nvl(f.upload_dt,'�̰���') as upload_dt, decode(f.rb36, 0,f.lb36, -1,f.lb36, f.rb36) fee_amt, decode(f.rb30, 0,f.lb30, -1,f.lb30, f.rb30) fee_amt_30, decode(b.car_use,'1',f.rm1,0) rm1, decode(b.car_use,'1',(f.rm1*1.1),0) as rm1_sv, decode(b.secondhand,'1',NVL(f.rb36, f.rs36)) rb, decode(b.secondhand,'1',NVL(f.lb36, f.ls36)) lb, "+
				"        nvl(f.rb36,0) rb36, nvl(f.rb24,0) rb24, nvl(f.rb12,0) rb12, nvl(f.lb36,0) lb36, "+
				"        decode(nvl(b.off_ls,'0'),'3',decode(o.actn_st,'1','���������','2','����','3','�������','4','����','��ǰ����'),'') actn_st, "+
				"        decode(b.park,'6',substr(b.park_cont,1,5),nvl(cd.nm,b.park))  park, b.park_cont, "+
				"        TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(replace(b.init_reg_dt,'-',''), 'YYYYMMDD'))) use_mon, e.imgfile1, e.imgfile6, e.img_dt, "+
				"        decode(b.gps,'Y','����') gps, j.serv_dt, d.jg_code,"+
				"        decode(cc.rent_l_cd,'','','�����ݳ�') call_in_st, decode(b.rm_st,'1','���','6','��Ÿ','2','���','3','�����','5','�����','4','A��','7','B��','8','C��','9','�̵���','��Ȯ��') rm_st, b.rm_cont, "+
				"        p.park_id, p.area, decode(p.car_mng_id,'','','P') park_yn, "+
				"        decode( p.io_gubun, '1', '�԰�', '2', '���', '3','�Ű�Ȯ��') AS io_gubun_nm, \n"+
				"        decode( p.park_id, '1', '����������', '2', '��������', '3', '�λ�����', '4', '��������', '5', '��������', '7', '�λ�ΰ�', '8', '�λ�뼺', '9', '��������', '10', '����ũ��', '11','(��)1�ޱ�ȣ','12','��������','13','�뱸����','14','������' ) AS park_nm,  \n"+
                "        nvl(h2.pic_cnt,0) as pic_cnt, pic_reg_dt, f.max_use_mon, "+
                "        decode(ac.car_mng_id,'','','�߰���') car_gu, "+  
                "        sr.accid_serv_amt1, sr.accid_serv_amt2, sr.accid_id "+ 
				" from   cont a, car_reg b, car_etc c, car_nm d, apprsl e, users k, users m, cont_etc n, "+
				"        ( select c_st, code, nm_cd, nm from code where c_st = '0027') cd,  \n"+  //������ 
				"        ( select c_st, code, nm_cd, nm from code where c_st = '0039') cd2,  \n"+ 
				"        (select * from secondhand a where a.seq = ( select max(seq) from secondhand where car_mng_id=a.car_mng_id and (agree_dist is null or agree_dist=10000))) f,"+
				"        (select * from sh_res a     where a.use_yn='Y' and a.situation in ('0','2','3')) g,"+ //(����������� ������ ���Ǹ� ���)
				"        (select a.car_mng_id, count(0) res_cnt "+
				"	      from   sh_res a, users b "+
				"	      where  a.use_yn is null and a.situation in ('0','2') and a.DAMDANG_ID=b.user_id ";

		if(gubun.equals("situ_nm"))			query += " and b.user_nm like '%"+gubun_nm+"%'"; //������ �˻�

		query +="	      group by a.car_mng_id) g2,"+ //(����������� ������ ���Ǹ� ���)
				"        (select * from rent_cont a  where a.use_st = '2' and a.rent_st<>'11') h,"+//����
				"        (select * from rent_cont a  where a.use_st = '1' and a.rent_st<>'11') i,"+//����
				"        (select * from service a    where a.tot_dist is not null and a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where tot_dist is not null and car_mng_id = a.car_mng_id)) j,"+
				"        (select car_mng_id, count(0) accid_cnt from accident group by car_mng_id) l,"+
				"        (select * from auction a where a.seq = (select max(seq) from auction where car_mng_id=a.car_mng_id)) o, v_tot_dist vt,"+
	            //���������ݳ�
				"        (select * from car_call_in where in_st='3' and out_dt is null) cc, "+
				"        PARK_CONDITION p "+
				"        , (SELECT aa.car_mng_id, bb.use_e_dt FROM cont aa,(SELECT rent_mng_id, rent_l_cd, max(use_e_dt) use_e_dt FROM scd_fee GROUP BY rent_mng_id, rent_l_cd) bb WHERE aa.car_st='4' AND nvl(aa.use_yn,'Y')='Y' AND aa.rent_mng_id=bb.rent_mng_id AND aa.rent_l_cd=bb.rent_l_cd ) r\n"+
				//����
				"        , (select SUBSTR(content_seq,1,6) car_mng_id, count(0) pic_cnt, TO_CHAR(MAX(reg_date),'YYYYMMDD') pic_reg_dt from ACAR_ATTACH_FILE where ISDELETED='N' and content_code='APPRSL' group by SUBSTR(content_seq,1,6)) h2, "+
                "        (select car_mng_id from cont where car_gu='2' group by car_mng_id) ac, "+
				"        sh_base sr "+
				" where"+
				"        nvl(a.use_yn,'Y')='Y' AND a.car_st IN ('2','4') and a.rent_l_cd not like 'RM%' \n "+
				"        and nvl(b.prepare,'0') NOT IN ('7','9') "+				//9-��ȸ������
				"        and nvl(b.off_ls,'0') in ('0') "+						//��ǰ������ 20100126
				"        and a.car_mng_id=b.car_mng_id"+
				"        and a.rent_l_cd=c.rent_l_cd"+
				"        and c.car_id=d.car_id and c.car_seq=d.car_seq"+
				"        and b.car_mng_id=e.car_mng_id(+)"+
				"        and a.rent_mng_id=n.rent_mng_id(+) and a.rent_l_cd=n.rent_l_cd(+)"+
				"        and b.car_mng_id=f.car_mng_id(+) AND a.car_mng_id=r.car_mng_id(+) "+
				"        and b.car_mng_id=g.car_mng_id(+)"+
				"        and b.car_mng_id=g2.car_mng_id(+)"+
				"        and b.car_mng_id=h.car_mng_id(+)"+
				"        and b.car_mng_id=i.car_mng_id(+)"+
				"        and b.car_mng_id=j.car_mng_id(+)"+
				"        and e.damdang_id=k.user_id(+)"+
				"        and b.car_mng_id=l.car_mng_id(+)"+
				"        and a.car_mng_id=o.car_mng_id(+)"+
				"        and a.car_mng_id=vt.car_mng_id(+)"+
				"        and g.damdang_id=m.user_id(+)"+
				"        and a.rent_mng_id=cc.rent_mng_id(+) and a.rent_l_cd=cc.rent_l_cd(+)"+
				"        and a.car_mng_id=p.car_mng_id(+)"+
				"        and a.car_mng_id=h2.car_mng_id(+)"+
				"        and a.car_mng_id=ac.car_mng_id(+)"+
				" 		 and b.park = cd.nm_cd(+) \n"+  //������ �ڵ� ���̺� 
				" 		 and b.fuel_kd = cd2.nm_cd \n"+
				"        and a.car_mng_id=sr.car_mng_id(+)"+
				" "	;

		if(res_yn.equals("Y"))					query += " and nvl(g.situation,'-') not in ('0')"; //('0','2')  //����� ����

		//�縮������
		if(res_mon_yn.equals("") && all_car_yn.equals("")){
												query += " and b.secondhand='1'";

		}else{
			//����Ʈ����-��ü	//�Ű��������� ����
			if(res_mon_yn.equals("Y"))			query += " and nvl(b.rm_yn, 'Y') <> 'N' and b.car_use='1' ";

			//����Ʈ���� //�Ű��������� ����
			if(res_mon_yn.equals("Y2")){
				query += " and nvl(b.rm_yn, 'Y') <> 'N' and b.car_use='1' and nvl(b.prepare,'0')<>'2' ";
			}

			//��ü����
			if(all_car_yn.equals("Y"))			query += " and (b.secondhand='1' or b.car_use='1')";

			if(res_mon_yn.equals("Y3")){//����Ʈ��ð�������
				query += " and nvl(b.rm_yn, 'Y') <> 'N' and b.car_use='1' and (b.secondhand='1' or nvl(b.rm_st,'0')<>'3') and g.situation is null and p.park_id IS NOT NULL  and decode(nvl(h.rent_st,i.rent_st),'1','�ܱ�뿩','2','�������','3','������','9','�������','10','��������','4','�����뿩','5','�����뿩','6','��������','7','��������','8','������','11','������','12','����Ʈ','���') = '���'  AND decode(b.rm_st,'3','������','���') = '���'  /* AND nvl(b.prepare,'0')<>'2' */";
			}

			if(res_mon_yn.equals("Y4")){//����Ʈ5���̳���������
										query += " AND decode(nvl(h.rent_st,i.rent_st),'1',to_char(to_date(substr(h.ret_plan_dt,1,8),'YYYYMMDD')-5,'YYYYMMDD'), to_char(sysdate,'YYYYMMDD')) <= to_char(sysdate,'YYYYMMDD') ";
										query += " AND decode(nvl(h.rent_st,i.rent_st),'2',to_char(to_date(substr(h.ret_plan_dt,1,8),'YYYYMMDD')-5,'YYYYMMDD'), to_char(sysdate,'YYYYMMDD')) <= to_char(sysdate,'YYYYMMDD') ";
										query += " AND decode(nvl(h.rent_st,i.rent_st),'3',to_char(to_date(substr(h.ret_plan_dt,1,8),'YYYYMMDD')-5,'YYYYMMDD'), to_char(sysdate,'YYYYMMDD')) <= to_char(sysdate,'YYYYMMDD') ";
										query += " AND decode(nvl(h.rent_st,i.rent_st),'9',to_char(to_date(substr(h.ret_plan_dt,1,8),'YYYYMMDD')-5,'YYYYMMDD'), to_char(sysdate,'YYYYMMDD')) <= to_char(sysdate,'YYYYMMDD') ";
										query += " AND decode(nvl(h.rent_st,i.rent_st),'10',to_char(to_date(substr(h.ret_plan_dt,1,8),'YYYYMMDD')-5,'YYYYMMDD'), to_char(sysdate,'YYYYMMDD')) <= to_char(sysdate,'YYYYMMDD')   ";

										query += " AND decode(a.car_st,'4',to_char(to_date(substr(r.use_e_dt,1,8),'YYYYMMDD')-5,'YYYYMMDD'), to_char(sysdate,'YYYYMMDD')) <= to_char(sysdate,'YYYYMMDD') ";

				query += " and nvl(b.rm_yn, 'Y') <> 'N' and b.car_use='1' and (b.secondhand='1' or nvl(b.rm_st,'0')<>'3') and decode(nvl(h.rent_st,i.rent_st),'1','�ܱ�뿩','2','�������','3','������','9','�������','10','��������','4','�����뿩','5','�����뿩','6','��������','7','��������','8','������','11','������','12','����Ʈ','���')  IN ('���','��������','����Ʈ','�ܱ�뿩','�������','������','�������','��������') /* AND nvl(b.prepare,'0')<>'2' */ ";
			}

		}

		if(gubun.equals("car_no"))			query += " and b.car_no like '%"+gubun_nm+"%'";
		if(gubun.equals("jg_code"))			query += " and d.jg_code = '"+gubun_nm+"'";
		if(gubun.equals("car_nm"))			query += " and b.car_nm||d.car_name like '%"+gubun_nm+"%'";
		if(gubun.equals("init_reg_dt"))		query += " and b.init_reg_dt like replace('"+ gubun_nm +"','-','')||'%'";
		if(gubun.equals("park"))			query += " and decode(b.park,'6',substr(b.park_cont,1,5),nvl(cd.nm,b.park))  like '%'||replace('"+ gubun_nm +"','-','')||'%'";
		if(gubun.equals("park_condition"))	query += " and decode(p.park_id, '1', '����������-����', '2', '��������-����', '3', '�λ�����', '4', '��������', '5', '��������-����', '7', '�λ�ΰ�', '8', '�λ�뼺', '9', '��������','12','��������','13','�뱸����','14','������' ) like '%"+gubun_nm+"%'";
		if(gubun.equals("situ_nm"))			query += " and (m.user_nm like '%"+gubun_nm+"%' or g2.car_mng_id is not null) "; //������ �˻�
		if(gubun.equals("car_gu2"))			query += " and ac.car_mng_id is not null ";//�ڻ�������

		if(brch_id.equals("S1"))			query += " and decode(b.park,'1','S1','2','S1','3','B1','4','D1','5','S1','7','B1','8','B1','9','D1','12','J1','13','G1','14','J1', nvl(n.mng_br_id,a.brch_id)) = 'S1' ";
		if(brch_id.equals("B1"))			query += " and decode(b.park,'1','S1','2','S1','3','B1','4','D1','5','S1','7','B1','8','B1','9','D1','12','J1','13','G1','14','J1', nvl(n.mng_br_id,a.brch_id)) = 'B1' ";
		if(brch_id.equals("D1"))			query += " and decode(b.park,'1','S1','2','S1','3','B1','4','D1','5','S1','7','B1','8','B1','9','D1','12','J1','13','G1','14','J1', nvl(n.mng_br_id,a.brch_id)) = 'D1' ";
		if(brch_id.equals("J1"))				query += " and decode(b.park,'1','S1','2','S1','3','B1','4','D1','5','S1','7','B1','8','B1','9','D1','12','J1','13','G1','14','J1', nvl(n.mng_br_id,a.brch_id)) = 'J1' ";
		if(brch_id.equals("G1"))			query += " and decode(b.park,'1','S1','2','S1','3','B1','4','D1','5','S1','7','B1','8','B1','9','D1','12','J1','13','G1','14','J1', nvl(n.mng_br_id,a.brch_id)) = 'G1' ";

		if(gubun2.equals("1"))			query += " and d.jg_code like '4%' and d.car_comp_id <= '0005' and b.fuel_kd not in ('3','5','6')"; //�����¿�
		else if(gubun2.equals("2"))		query += " and d.jg_code like '3%' and d.car_comp_id <= '0005' and b.fuel_kd not in ('3','5','6')"; //�����¿�
		else if(gubun2.equals("3"))		query += " and d.jg_code between '1000000' and '2999999' and d.car_comp_id <= '0005' and b.fuel_kd not in ('3','5','6')"; //�����¿�
		else if(gubun2.equals("4"))		query += " and d.jg_code like '4%' and d.car_comp_id <= '0005' and b.fuel_kd in ('3','5','6')"; //�����¿�LPG
		else if(gubun2.equals("5"))		query += " and d.jg_code like '3%' and d.car_comp_id <= '0005' and b.fuel_kd in ('3','5','6')"; //���������¿�LPG
		else if(gubun2.equals("8"))		query += " and d.jg_code between '1000000' and '2999999' and d.car_comp_id <= '0005' and b.fuel_kd in ('3','5','6')"; //�����¿�LPG
		else if(gubun2.equals("6"))		query += " and d.jg_code between '5000000' and '9999999' and d.car_comp_id <= '0005' "; //���� RV�ױ�Ÿ(����,ȭ��)
		else if(gubun2.equals("7"))		query += " and d.car_comp_id > '0005' "; //������
		
		//������Ʈ�� ��� && ���డ�� �Ǹ� ���� �˻��ǰ�(20190924)
		if(agent_yn.equals("Y")){
			query +="		AND DECODE(a.car_st, '4','����Ʈ',decode(b.off_ls,'3','���'||o.actn_dt,'1','�Ű�����',decode(nvl(h.rent_st,i.rent_st),'1','�ܱ�뿩','2','�������','3','������','9','�������','10','��������','4','�����뿩','5','�����뿩','6','��������','7','��������','8','������','11','������','12','����Ʈ','���'))) = '���'	\n"+
						  "		AND decode(g.situation,'0','�����','1','���������','2','���Ȯ��','3','��࿬��','���డ��') = '���డ��' \n ";
		}

		if(sort_gubun.equals("car_kind")){

			//20101021 : ����LPG,����LPG,����LPG,����,����,����,RV,���� ������ ���� ����
			if(res_mon_yn.equals("Y")||res_mon_yn.equals("Y2")){

			query += " ORDER BY "+res_mon_order+" "+
					 "          decode(nvl(g.situation,'0'), '2',1, 0), "+ //���Ȯ���� �ǾƷ���
					 "          decode(d.car_comp_id, '0001',0, '0002',0, '0003',0, '0004',0, '0005',0, 1), "+ //�������� ��, �������� �Ʒ���
				     "          decode(b.fuel_kd, '3',0, '5',0, '6',0, 1), "+//LPG����
				     "          d.jg_code,f.rm1, d.car_b_p, d.car_name, b.init_reg_dt, b.car_mng_id ";
			}else{
			query += " ORDER BY "+res_mon_order+" "+
					 "          decode(nvl(g.situation,'0'), '2',1, 0), "+ //���Ȯ���� �ǾƷ���
					 "          decode(d.car_comp_id, '0001',0, '0002',0, '0003',0, '0004',0, '0005',0, 1), "+ //�������� ��, �������� �Ʒ���
				     "          decode(b.fuel_kd, '3',0, '5',0, '6',0, 1), "+//LPG����
				     "          d.jg_code,  d.car_b_p, d.car_name, b.init_reg_dt, b.car_mng_id ";
			}
		}else if(sort_gubun.equals("situation")){

			query += " order by "+res_mon_order+" decode(g.situation,'',1,'0',2,'1',3,'2',4) ";

			query += ", b.fuel_kd, b.dpm DESC, b.car_nm||d.car_name  ";

		}else{

			if(sort_gubun.equals("today_dist2")){
				query += " order by "+res_mon_order+" decode(nvl(g.situation,'0'),'2',1,0), decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(a.dlv_dt,b.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(a.dlv_dt,b.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD'))))";
			}else{
				query += " order by "+res_mon_order+" decode(nvl(g.situation,'0'),'2',1,0) ";

				if(sort_gubun.equals("car_nm"))				query += ", b.car_nm||d.car_name";
				else if(sort_gubun.equals("car_no"))		query += ", b.car_no ";
				else if(sort_gubun.equals("init_reg_dt"))	query += ", b.init_reg_dt ";
				else if(sort_gubun.equals("fuel_kd"))		query += ", cd2.nm   ";
				else if(sort_gubun.equals("dpm"))			query += ", b.fuel_kd, b.dpm desc, b.car_nm||d.car_name  ";
				else if(sort_gubun.equals("secondhand_dt"))	query += ", b.secondhand_dt ";
				else if(sort_gubun.equals("colo"))			query += ", c.colo ";
				else if(sort_gubun.equals("fee_amt"))		query += ", decode(f.rb36, 0,f.lb36, -1,f.lb36, f.rb36) ";
				else										query += ", b.fuel_kd, b.dpm DESC, b.car_nm||d.car_name  ";
			}

			//20101021 : ����LPG,����LPG,����LPG,����,����,����,RV,���� ������ ���� ����
			query += "   , decode(d.car_comp_id, '0001',0, '0002',0, '0003',0, '0004',0, '0005',0, 1), "+ //�������� ��, �������� �Ʒ���
				     "          decode(b.fuel_kd, '3',0, '5',0, '6',0, 1), "+//LPG����
				     "          d.jg_code, d.car_b_p, d.car_name, b.init_reg_dt, b.car_mng_id ";


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
			System.out.println("[SecondhandDatabase:getSecondhandList_20120821]\n"+e);
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
	*	����Ʈ ���뿩���� ������
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
			System.out.println("[SecondhandDatabase:getEstiRmDayPers]"+e);
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


	//������ �������� ��ȸ
	public Vector getAccidServAmts(String car_mng_id, String rent_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String res_mon_order = "";

		query = "         SELECT  b.tot_amt "+
				"         FROM    ACCIDENT a, SERVICE b "+
				"         WHERE   a.car_mng_id='"+car_mng_id+"' and b.serv_dt <='"+rent_dt+"' "+
				"                 AND a.car_mng_id=b.car_mng_id AND a.accid_id=b.accid_id "+
				"                 AND b.tot_amt>0 "+
				"                 AND b.serv_st not in ('7','12') "+
                "         union all "+
                "         SELECT  b.accid_serv_amt as tot_amt "+
                "         FROM    cont a, car_etc b "+
                "         WHERE   a.car_mng_id='"+car_mng_id+"' "+
                "                 AND a.car_gu='2' "+
                "                 and a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd "+
                "                 AND nvl(b.accid_serv_amt,0)>0 "+
				"         ORDER BY 1 desc "+
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
			System.out.println("[SecondhandDatabase:getAccidServAmts]\n"+e);
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

	//�縮��������Ȳ -
	public Vector getShResMngList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String gubun4)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String search = "";
		String what = "";

    		query = " select b.CAR_NO, b.CAR_NM, a.*, \n"+
    				"        decode(c.car_st,'1','��Ʈ','2','����','3','����','4','����Ʈ','-') car_st, \n"+
    			    "        decode(a.SITUATION,'0','�����','2','���Ȯ��','3','��࿬��') SITUATION_st, \n"+
                    "        decode(a.USE_YN,'Y','����','N','����','���') use_st, \n"+
    				"        decode(a.DAMDANG_ID,'','�̹���','HP','����������',d.user_nm) user_nm, \n"+
    			    "        CASE WHEN INSTR(a.MEMO,'����Ʈ')>0 THEN '����Ʈ' ELSE '�縮��' END res_st, \n"+
    			    "        DECODE(p.EST_AREA, '����/������','S1','����/���Ǳ�','S1','����/���α�','S1','����/��õ��','S1','����/���۱�','S1','����/������',"+
    			    "        'S1','����/���빮��','S5','����/��õ��','S1','����/��������','S1',"+
    			    "        '����/��걸','S5','����/����','S5','����/���ϱ�','S5','����/�����','S5','����/������','S5','����/���ϱ�','S5',"+
    			    "        '����/���α�','S5','����/�߱�','S5' ,'����/������','S2','����/������','S6','����/������','S6','����/���빮��','S5',"+
    			    "        '����/���ʱ�','S2','����/������','S2','����/���ı�','S6','����/�߶���','S5' ,'���/����','S1','���/�����','S1',"+
    			    "        '���/�Ⱦ��','S1','���/���ֽ�','S1','���/����','S6','���/������','S6','���/�����ֽ�','S6','���/����õ��','S5',"+
    			    "        '���/���ֽ�','S5','���/����','S6','���/��õ��','S5','���/�����ν�','S5','���/��õ��','S5' ,'���/��õ��','S2',"+
    			    "        '���/���ֽ�','S6','���/������','S6','���/�ϳ���','S6' ,'���/������','I1','���/��õ��','I1','���/�����','I1' ,"+
    			    "        '���/������','K3','���/������','K3','���/�Ȼ��','K3','���/�ȼ���','K3','���/���ֱ�','K3','���/�����','K3',"+
    			    "        '���/���ν�','K3','���/�ǿս�','K3','���/��õ��','K3','���/���ý�','K3','���/ȭ����','K3' ,'����/ö����','S6',"+
    			    "        '����/ȭõ��','S6','����/��õ��','S6','����/�籸��','S6','����/ȫõ��','S6','����/������','S6','����/����','S6',"+
    			    "        '����/���ʽ�','S6','����/��籺','S6','����/���ֽ�','K3','����/Ⱦ����','K3','����/��â��','K3','����/������','K3',"+
    			    "        '����/������','K3','����/������','K3','����/���ؽ�','K3','����/��ô��','K3','����/�¹��','K3' ,'��õ/�߱�','I1',"+
    			    "        '��õ/����','I1','��õ/����','I1','��õ/������','I1','��õ/������','I1','��õ/����','I1','��õ/��籸','I1',"+
    			    "        '��õ/����','I1','��õ/��ȭ��','I1','��õ/������','I1' ,'�λ�/�߱�','B1','�λ�/����','B1','�λ�/����','B1',"+
    			    "        '�λ�/������','B1','�λ�/�λ�����','B1','�λ�/������','B1','�λ�/����','B1','�λ�/�ϱ�','B1','�λ�/�ؿ�뱸','B1',"+
    			    "        '�λ�/���ϱ�','B1','�λ�/������','B1','�λ�/������','B1','�λ�/������','B1','�λ�/������','B1','�λ�/���','B1',"+
    			    "        '�λ�/���屺','B1' ,'���/�߱�','B1','���/����','B1','���/�ϱ�','B1','���/����','B1','���/���ֱ�','B1' ,"+
    			    "        '�泲/â����','B1','�泲/���ֽ�','B1','�泲/�뿵��','B1','�泲/��õ��','B1','�泲/���ؽ�','B1','�泲/�о��','B1',"+
    			    "        '�泲/������','B1','�泲/����','B1','�泲/�Ƿɱ�','B1' ,'�泲/�Ծȱ�','B1','�泲/â�籺','B1','�泲/����','B1',"+
    			    "        '�泲/���ر�','B1','�泲/�ϵ���','B1','�泲/��û��','B1','�泲/�Ծ籺','B1','�泲/��â��','B1','�泲/��õ��','B1' ,"+
    			    "        '�泲/�����','B1','�泲/����','B1','�泲/���ؽ�','B1','����/���ֽ�','J1','����/��������','J1','����/�����ֱ�','J1',"+
    			    "        '����/�����ֱ�','J1' ,'����/����','J1','����/����','J1','����/����','J1','����/�ϱ�','J1','����/���걸','J1' ,"+
    			    "        '����/���ֽ�','J1','����/�����','J1','����/�ͻ��','J1','����/������','J1' ,'����/������','J1','����/������','J1',"+
    			    "        '����/���ֱ�','J1','����/���ȱ�','J1','����/���ֱ�','J1','����/�����','J1','����/�ӽǱ�','J1','����/��â��','J1',"+
    			    "        '����/��â��','J1','����/�ξȱ�','J1' ,'����/������','J1','����/������','J1','����/��õ��','J1','����/���ֽ�','J1',"+
    			    "        '����/�����','J1','����/��籺','J1','����/���','J1','����/���ʱ�','J1','����/���ﱺ','J1','����/������','J1' ,"+
    			    "        '����/ȭ����','J1','����/���ﱺ','J1','����/������','J1','����/�س���','J1','����/���ϱ�','J1','����/���ȱ�','J1',"+
    			    "        '����/����','J1','����/������','J1','����/�强��','J1','����/�ϵ���','J1' ,'����/������','J1','����/�žȱ�','J1' ,"+
    			    "        '�뱸/�߱�','G1','�뱸/����','G1','�뱸/����','G1','�뱸/����','G1','�뱸/�ϱ�','G1','�뱸/������','G1','�뱸/�޼���','G1',"+
    			    "        '�뱸/�޼���','G1' ,'���/���׽�','G1','���/���ֽ�','G1','���/�ȵ���','G1','���/���̽�','G1','���/���ֽ�','G1',"+
    			    "        '���/��õ��','G1','���/���ֽ�','G1','���/�����','G1','���/����','G1','���/������','G1' ,'���/�Ǽ���','G1',"+
    			    "        '���/û�۱�','G1','���/���籺','G1','���/���ﱺ','G1','���/û����','G1','���/��ɱ�','G1','���/���ֱ�','G1',"+
    			    "        '���/ĥ�','G1','���/��õ��','G1','���/��ȭ��','G1' ,'���/������','G1','���/�︪��','G1' ,'���/��õ��','D1' ,"+
    			    "        '����/����','D1','����/�߱�','D1','����/����','D1','����/������','D1','����/�����','D1' ,'���/û�ֽ�','D1',"+
    			    "        '���/���ֽ�','D1' ,'���/��õ��','D1','���/û����','D1','���/������','D1','���/��õ��','D1','���/������','D1',"+
    			    "        '���/����','D1','���/��õ��','D1','���/���걺','D1','���/������','D1','���/�ܾ籺','D1' ,'�泲/õ�Ƚ�','D1',"+
    			    "        '�泲/���ֽ�','D1','�泲/���ɽ�','D1','�泲/�ƻ��','D1','�泲/�����','D1','�泲/����','D1','�泲/����','D1',"+
    			    "        '�泲/������','D1','�泲/�ݻ걺','D1','�泲/�ο���','D1' ,'�泲/��õ��','D1','�泲/û�籺','D1','�泲/ȫ����','D1',"+
    			    "        '�泲/���걺','D1','�泲/�¾ȱ�','D1','����/����Ư����ġ��','D1' ) AS BR_ID,"+
					"        SUBSTR(p.addr1, 1, INSTR(p.addr1, ' ', 1, 1) - 1) est_area1, "+
                    "        SUBSTR(p.addr1, INSTR(p.addr1, ' ', 1, 1) + 1, INSTR(p.addr1, ' ', 1, 2) - INSTR(p.addr1, ' ', 1, 1) - 1) est_area2, "+
                    "        p.reg_dt reg_time "+
    				" from   sh_res a, car_reg b, (select car_mng_id, car_st from cont where use_yn='Y' or use_yn is null) c, users d, sh_base e, esti_spe p \n"+
    				" where  a.car_mng_id=b.car_mng_id and a.car_mng_id=c.car_mng_id(+) \n"+
    				"   AND  a.DAMDANG_ID=d.user_id(+) "+
    				"   AND  a.car_mng_id = e.car_mng_id (+)" +
    				"   AND  a.est_id = p.est_id (+) " +
				" "	;

			if(gubun1.equals("1"))	query += " and a.use_yn='Y' and c.car_mng_id is not null ";         //����
			if(gubun1.equals("2"))	query += " and a.use_yn is null and c.car_mng_id is not null ";     //���
			if(gubun1.equals("3"))	query += " and a.use_yn='N' and c.car_mng_id is not null ";         //����
			if(gubun1.equals("4"))	query += " and (a.use_yn='Y' or a.use_yn is null) and c.car_mng_id is not null ";         //����+���

			if(!gubun2.equals(""))	query += " and a.SITUATION='"+gubun2+"' ";			//�������

			if(gubun3.equals("1"))	query += " and INSTR(a.MEMO,'����Ʈ')=0 ";			//�縮��
			if(gubun3.equals("2"))	query += " and INSTR(a.MEMO,'����Ʈ')>0 ";			//����Ʈ

			if(gubun4.equals("0"))  query += " and a.DAMDANG_ID IS NULL"; //����� �̹���
			if(gubun4.equals("1"))  query += " and a.DAMDANG_ID IS NOT NULL"; //����� �����Ϸ�
			
			if(s_kd.equals("1"))	what = "a.cust_nm";
			if(s_kd.equals("2"))	what = "a.cust_tel";
			if(s_kd.equals("3"))	what = "b.car_no";
			if(s_kd.equals("4"))	what = "b.car_nm";
			if(s_kd.equals("5"))	what = "a.memo";
			if(s_kd.equals("6"))	what = "d.user_nm";
			if(s_kd.equals("7"))	what = "a.reg_dt";
			if(s_kd.equals("8"))	what = "a.res_st_dt";
			if(s_kd.equals("9"))	what = "a.res_end_dt";


			if(!what.equals("") && !t_wd.equals("")){
				if(t_wd.indexOf("'") != -1)					t_wd = AddUtil.replace(t_wd,"'","");

				if(s_kd.equals("2")){
					query += " and replace("+what+",'-','') like replace('%"+t_wd+"%','-','') \n";
				}else if(s_kd.equals("7") || s_kd.equals("8") || s_kd.equals("9")){
					query += " and "+what+" like replace('%"+t_wd+"%','-','') \n";
				}else{
					query += " and "+what+" like '%"+t_wd+"%' \n";
				}
			}
			query += " ORDER BY decode(e.car_comp_id, '0001',0, '0002',0, '0003',0, '0004',0, '0005',0, 1), b.CAR_NO, SEQ";


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
			System.out.println("[SecondhandDatabase:getShResMngList]\n"+e);
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
	*	 ������������ ��ȸ
	*/
	public ShResBean getShResEst(String est_id){
		getConnection();
		ShResBean bean = new ShResBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT car_mng_id, seq, damdang_id, situation, memo, reg_dt, res_end_dt, "+
				"        nvl(add_cnt,0) add_cnt, nvl(add_cnt_s,0) add_cnt_s, res_st_dt, use_yn, cust_nm, cust_tel, est_id, reg_code "+
				" FROM   sh_res  "+
				" WHERE  est_id = ? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, est_id);
			rs = pstmt.executeQuery();
			if(rs.next()){
				bean.setCar_mng_id	(rs.getString("CAR_MNG_ID"));
				bean.setSeq			(rs.getString("SEQ"));
				bean.setDamdang_id	(rs.getString("DAMDANG_ID"));
				bean.setSituation	(rs.getString("SITUATION"));
				bean.setMemo		(rs.getString("MEMO"));
				bean.setReg_dt		(rs.getString("REG_DT"));
				bean.setRes_end_dt	(rs.getString("RES_END_DT")==null?"":rs.getString("RES_END_DT"));
				bean.setRes_st_dt	(rs.getString("RES_ST_DT")==null?"":rs.getString("RES_ST_DT"));
				bean.setUse_yn		(rs.getString("USE_YN")==null?"":rs.getString("USE_YN"));
				bean.setCust_nm		(rs.getString("CUST_NM")==null?"":rs.getString("CUST_NM"));
				bean.setCust_tel	(rs.getString("CUST_TEL")==null?"":rs.getString("CUST_TEL"));
				bean.setEst_id 		(rs.getString("EST_ID")==null?"":rs.getString("EST_ID"));
				bean.setReg_code	(rs.getString("REG_CODE")==null?"":rs.getString("REG_CODE"));
				bean.setAdd_cnt		(rs.getString("add_cnt")==null?0:Integer.parseInt(rs.getString("add_cnt")));
				bean.setAdd_cnt_s	(rs.getString("add_cnt_s")==null?0:Integer.parseInt(rs.getString("add_cnt_s")));
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[SecondhandDatabase:getShResEst(String est_id)]"+e);
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

	//�縮��������Ȳ
	public Vector getShResList(String car_mng_id, String reg_code, String est_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.car_mng_id, seq, a.damdang_id, a.situation, a.reg_dt, a.res_st_dt, a.res_end_dt, nvl(a.use_yn,'') use_yn, a.memo, a.cust_nm, a.cust_tel, "+
				"        nvl(a.add_cnt,0) add_cnt, nvl(add_cnt_s,0) add_cnt_s, a.est_id, a.reg_code, nvl(b.res_num,'') res_num  "+
				" from   sh_res a, "+
                "        (select car_mng_id, rownum as res_num, est_id, reg_code from sh_res where car_mng_id='"+car_mng_id+"' and nvl(use_yn,'Y')='Y') b "+
				" where  a.car_mng_id='"+car_mng_id+"' "+
				"        and a.reg_code='"+reg_code+"' "+
				"        and a.est_id='"+est_id+"' "+
				"        and a.situation in ('0','2','3')"+
			    "        and a.car_mng_id=b.car_mng_id(+) and a.reg_code=b.reg_code(+) and a.est_id=b.est_id(+) "+
				" order by a.seq";

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
			System.out.println("[SecondhandDatabase:getShResList]\n"+e);
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
	

    public Vector getShResListByCarNum(String car_number){

        getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Vector vt = new Vector();
        String query = "";

        query = " SELECT   *  "+
                " FROM     SH_RES A, "+
                "          CAR_REG B "+
                " WHERE    a.CAR_MNG_ID = b.CAR_MNG_ID (+) "+
                "   AND    NVL(a.USE_YN,'Y') <> 'N'" +
                "   AND    b.CAR_NO LIKE '%" + car_number + "%' " +
                "   AND    a.EST_ID IS NOT NULL " +
                " ORDER BY b.CAR_NO, a.REG_DT desc";

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
            System.out.println("[SecondhandDatabase:getShResListByCarNum]\n"+e);
            e.printStackTrace();
            
        } finally {
            try{
                if ( rs != null )       rs.close();
                if ( pstmt != null )    pstmt.close();
            }catch(Exception ignore){}
            closeConnection();
            return vt;
        }       
        
    }
  
    public int insertExistCustomerInfo(String prevEstId, String estName, String estTel, String newEstId, String carName){
        getConnection();
        PreparedStatement pstmt = null;
        String query = "";
        int result = 0;
        
        query = "INSERT INTO ESTI_SPE(EST_ID, EST_ST, EST_NM, EST_SSN, EST_AGNT, EST_TEL, EST_BUS, CAR_NM," +
                                      "EST_YEAR, REG_DT, EST_AREA, EST_FAX, EST_EMAIL, ZIPCODE, ADDR1," + 
                                      "ADDR2, ACCOUNT, BANK, DRIVER_YEAR, URGEN_TEL) " + 
                "SELECT ?, EST_ST, ?, EST_SSN, EST_AGNT, ?, EST_BUS, ?," +
                        "EST_YEAR, TO_CHAR(sysdate,'yyyymmdd'), EST_AREA, EST_FAX, EST_EMAIL, ZIPCODE, ADDR1," +
                        "ADDR2, ACCOUNT, BANK, DRIVER_YEAR, URGEN_TEL" +
                "  FROM ESTI_SPE " + 
                " WHERE EST_ID = ?";
                
        try{
            conn.setAutoCommit(false);

            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, newEstId);
            pstmt.setString(2, estName);
            pstmt.setString(3, estTel);
            pstmt.setString(4, carName);
            pstmt.setString(5, prevEstId);
            
            result = pstmt.executeUpdate();
			pstmt.close();

            conn.commit();

        }catch(SQLException e){
            System.out.println("[SecondhandDatabase:insertExistCustomerInfo]"+e);
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


    public int insertSecondhandEstiInfo(String estId, String estName, String estTel, String regCode, String carManagedId){

        getConnection();
        PreparedStatement pstmt = null;
        String query = "";
        int result = 0;
        
        query = " insert into  ESTIMATE_CU ( EST_ID, EST_NM, EST_SSN, EST_TEL, EST_FAX, "+
                "              CAR_COMP_ID,CAR_CD,CAR_ID,CAR_SEQ,CAR_AMT,OPT,OPT_SEQ,OPT_AMT,COL,COL_SEQ,COL_AMT,DC,DC_SEQ,DC_AMT,O_1, "+
                "              A_A,A_B,A_H,PP_ST,PP_AMT,PP_PER,RG_8,INS_GOOD,INS_AGE,INS_DJ,RO_13,G_10,CAR_JA,GI_AMT,GI_FEE,LPG_YN,GI_YN,GTR_AMT, "+
                "              PP_S_AMT,PP_V_AMT,IFEE_S_AMT,IFEE_V_AMT,FEE_S_AMT,FEE_V_AMT,REG_ID,REG_DT,UPDATE_ID,UPDATE_DT,TALK_TEL,RO_13_AMT,RG_8_AMT,FEE_DC_PER, "+
                "              SPR_YN,MGR_NM,MGR_SSN,JOB,RENT_DT,O_11,LPG_KIT,EST_ST,EST_FROM,TODAY_DIST,O_13,UDT_ST,OVER_RUN_AMT,AGREE_DIST,CLS_PER,RENT_MNG_ID, "+
                "              RENT_L_CD,RENT_ST,REG_CODE,INS_PER,OVER_SERV_AMT,CLS_N_PER,OVER_RUN_DAY,ONE_SELF,DOC_TYPE,VALI_TYPE,OPT_CHK,FEE_OPT_AMT,GI_PER, "+
                "              SET_CODE,EST_EMAIL,EST_TYPE,CAROFF_EMP_YN,PRINT_TYPE,CTR_S_AMT,CTR_V_AMT,USE_YN,COMPARE_YN,B_AGREE_DIST,B_O_13,LOC_ST, "+
                "              TINT_B_YN,TINT_S_YN,TINT_N_YN,SPE_DC_PER,IN_COL,BUS_YN,BUS_CAU,ACCID_SERV_AMT1,ACCID_SERV_AMT2,ACCID_SERV_ZERO,INSURANT, "+
                "              BUS_CAU_DT,CHA_ST_DT,B_DIST,JG_OPT_ST,JG_COL_ST,BUS_CAU_SCORE,MAX_USE_MON,TAX_DC_AMT,ECAR_LOC_ST,ECAR_PUR_SUB_AMT,ECAR_PUR_SUB_ST,CONTI_RAT ) "+
                "    SELECT    ?, ?,'',?,'',"+
                "              CAR_COMP_ID,CAR_CD,CAR_ID,CAR_SEQ,CAR_AMT,OPT,OPT_SEQ,OPT_AMT,COL,COL_SEQ,COL_AMT,DC,DC_SEQ,DC_AMT,O_1, "+
                "              A_A,A_B,A_H,PP_ST,PP_AMT,PP_PER,RG_8,INS_GOOD,INS_AGE,INS_DJ,RO_13,G_10,CAR_JA,GI_AMT,GI_FEE,LPG_YN,GI_YN,GTR_AMT, "+
                "              PP_S_AMT,PP_V_AMT,IFEE_S_AMT,IFEE_V_AMT,FEE_S_AMT,FEE_V_AMT,REG_ID,TO_CHAR(sysdate,'yyyymmdd'),UPDATE_ID,UPDATE_DT,TALK_TEL,RO_13_AMT,RG_8_AMT,FEE_DC_PER, "+
                "              SPR_YN,MGR_NM,MGR_SSN,JOB,RENT_DT,O_11,LPG_KIT,EST_ST,EST_FROM,TODAY_DIST,O_13,UDT_ST,OVER_RUN_AMT,AGREE_DIST,CLS_PER,RENT_MNG_ID, "+
                "              RENT_L_CD,RENT_ST,?,INS_PER,OVER_SERV_AMT,CLS_N_PER,OVER_RUN_DAY,ONE_SELF,DOC_TYPE,VALI_TYPE,OPT_CHK,FEE_OPT_AMT,GI_PER, "+
                "              ?,EST_EMAIL,EST_TYPE,CAROFF_EMP_YN,PRINT_TYPE,CTR_S_AMT,CTR_V_AMT,USE_YN,COMPARE_YN,B_AGREE_DIST,B_O_13,LOC_ST, "+
                "              TINT_B_YN,TINT_S_YN,TINT_N_YN,SPE_DC_PER,IN_COL,BUS_YN,BUS_CAU,ACCID_SERV_AMT1,ACCID_SERV_AMT2,ACCID_SERV_ZERO,INSURANT, "+
                "              BUS_CAU_DT,CHA_ST_DT,B_DIST,JG_OPT_ST,JG_COL_ST,BUS_CAU_SCORE,MAX_USE_MON,TAX_DC_AMT,ECAR_LOC_ST,ECAR_PUR_SUB_AMT,ECAR_PUR_SUB_ST,CONTI_RAT "+
                "      FROM    ESTIMATE_SH             "+
                "     WHERE    REG_CODE = ?            "+
                "      AND     MGR_NM = ?              "+
                "      AND     MGR_SSN = ?             "+
                "      AND     ROWNUM = 1              "+
                "      AND     EST_TYPE = ?            ";
        try{
            conn.setAutoCommit(false);

            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, estId);
            pstmt.setString(2, estName);
            pstmt.setString(3, estTel);
            pstmt.setString(4, estId+"1");
            pstmt.setString(5, estId+"1");
            pstmt.setString(6, regCode);
            pstmt.setString(7, carManagedId);
            pstmt.setString(8, "rm1");
            pstmt.setString(9, "S");
            
            result = pstmt.executeUpdate();
			pstmt.close();
            conn.commit();

        }catch(SQLException e){
            System.out.println("[SecondhandDatabase:insertSecondhandEstiInfo]"+e);
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
     * ���ν��� ȣ��
     */
	public String call_sp_sh_res_rm_cont_reg(String car_mng_id, String seq)
	{
    	getConnection();

    	String query = "{CALL P_SH_RES_RM_CONT_REG(?, ?, ?)}";

		String sResult = "";

		CallableStatement cstmt = null;

		try {

			cstmt = conn.prepareCall(query);
			cstmt.setString(1, car_mng_id);
			cstmt.setString(2, seq);
			cstmt.registerOutParameter( 3, java.sql.Types.VARCHAR );
			cstmt.execute();

			sResult = cstmt.getString(3); // �����

			cstmt.close();


		} catch (SQLException e) {
			System.out.println("[SecondhandDatabase:call_sp_sh_res_rm_cont_reg]\n"+e);
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
     * ���ν��� ȣ��
     */
	public String call_sp_sh_res_rm_cont_del(String car_mng_id, String seq)
	{
    	getConnection();

    	String query = "{CALL P_SH_RES_RM_CONT_DEL(?, ?, ?)}";

		String sResult = "";

		CallableStatement cstmt = null;

		try {

			cstmt = conn.prepareCall(query);
			cstmt.setString(1, car_mng_id);
			cstmt.setString(2, seq);
			cstmt.registerOutParameter( 3, java.sql.Types.VARCHAR );
			cstmt.execute();

			sResult = cstmt.getString(3); // �����

			cstmt.close();


		} catch (SQLException e) {
			System.out.println("[SecondhandDatabase:call_sp_sh_res_rm_cont_del]\n"+e);
			e.printStackTrace();
		} finally {
			try{
			     if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}
    
	public String getRmContYn(String est_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String rent_l_cd = "";
		String query = "";

		query = " SELECT a.rent_l_cd FROM cont_etc a, cont b WHERE a.spe_est_id=? and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(b.use_yn,'Y')='Y' ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, est_id);
			rs = pstmt.executeQuery();

			while(rs.next()){
				rent_l_cd = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt.close();

		}catch(SQLException e){
			System.out.println("[SecondhandDatabase:getRmContYn(String est_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return rent_l_cd;
		}
	}

	//����Ʈ ������ ���� ��ȸ
    public Vector getMonthRentDriverInfo(String est_id)
    {
        getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Vector vt = new Vector();
        String query = "";

        query = "  SELECT EST_ID, SEQ, DRIVER_NUM, DRIVER_CELL, DRIVER_NM"+
                "    FROM ESTI_MGR "+
                "   WHERE EST_ID = ?"+
                "ORDER BY SEQ";

        try {
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, est_id);
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
            System.out.println("[SecondhandDatabase:getMonthRentDriverInfo]\n"+e);
            e.printStackTrace();

        } finally {
            try{
                if ( rs != null )       rs.close();
                if ( pstmt != null )    pstmt.close();
            }catch(Exception ignore){}
            closeConnection();
            return vt;
        }
    }

    public int insertExistDriverInfo(String prevEstId, String estId){
        getConnection();
        PreparedStatement pstmt = null;
        String query = "";
        int result = 0;
        
        query = "  INSERT INTO (ID, EST_ID, SEQ, DRIVER_NUM, DRIVER_CELL, DRIVER_NM) " +
                "  SELECT EST_MGR_SQ.NEXTVAL, ?, SEQ, DRIVER_NUM, DRIVER_CELL, DRIVER_NM  "+
                "    FROM ESTI_MGR "+
                "   WHERE EST_ID = ?  "+
                " ORDER BY SEQ ";
                
        try{
            conn.setAutoCommit(false);

            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, estId);
            pstmt.setString(2, prevEstId);
            
            result = pstmt.executeUpdate();
			pstmt.close();

            conn.commit();

        }catch(SQLException e){
            System.out.println("[SecondhandDatabase:insertExistDriverInfo]"+e);
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
	*	�ڻ������� ��ȸ
	*/
	public Hashtable getCarAcInfo(String car_mng_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();

		String query =  " SELECT a.rent_mng_id, a.rent_l_cd, a.car_mng_id, e.car_off_nm, b.SH_INIT_REG_DT, c.sh_base_dt, '�ڻ��� ����' as driver, b.accid_serv_amt, b.accid_serv_cont "+
						" FROM   cont a, car_etc b, commi c, car_off_emp d, car_off e "+
						" WHERE  a.car_gu='2' AND a.car_mng_id='"+car_mng_id+"' "+
						"        AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd "+
						"        AND a.rent_mng_id=c.rent_mng_id AND a.rent_l_cd=c.rent_l_cd AND c.AGNT_ST='6' "+
						"        AND c.emp_id=d.emp_id "+
						"        AND d.car_off_id=e.car_off_id ";

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
			System.out.println("[SecondhandDatabase:getCarAcInfo(String car_mng_id)]"+e);
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
	*	�縮�� ���� ���� ������
	*/
	public String getSearchEstId(String car_mng_id, String a_a, String a_b, String o_1, String today_dist, String rent_dt, String amt, String reg_code){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String est_id = "";

		String query =  " select a.est_id from estimate a, esti_compare b where a.est_type = 'S' and a.est_id=b.est_id and a.reg_id is null"+
						" and a.mgr_nm = '"+car_mng_id+"' "+
						" and a.a_a = '"+a_a+"' "+
						" and a.a_b = '"+a_b+"' "+
						" and a.o_1	= "+o_1+" "+
						" and a.rent_dt	= '"+rent_dt+"' "+
						" and a.fee_s_amt = "+amt+" "+
						" and nvl(a.mgr_ssn,' ')<>'rm1'"+
						" ";

		if(!reg_code.equals(""))	query += " and a.reg_code	= "+reg_code+" ";
		if(!today_dist.equals("0"))	query += " and a.today_dist	= "+today_dist+" ";

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();

			if(rs.next())
			{				
				 est_id = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
            pstmt.close();

		}catch(Exception e){
			System.out.println("[SecondhandDatabase:getSearchEstId]"+e);

			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return est_id;
		}
	}

	/**
	*	�縮�� ���� ���� ������
	*/
	public String getSearchEstIdSh(String car_mng_id, String a_a, String a_b, String o_1, String today_dist, String rent_dt, String amt, String reg_code){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String est_id = "";

		String query =  " select a.est_id from estimate_sh a, esti_compare_sh b where a.est_type = 'S' and a.est_id=b.est_id "+
						" and a.mgr_nm = '"+car_mng_id+"' "+
						" and a.a_a = '"+a_a+"' "+
						" and a.a_b = '"+a_b+"' "+
						" and a.o_1	= "+o_1+" "+
						" and a.rent_dt	= '"+rent_dt+"' "+
						" and a.fee_s_amt = "+amt+" "+
						" and nvl(a.mgr_ssn,' ')<>'rm1'"+
						" ";

		if(!reg_code.equals(""))	query += " and a.reg_code	= "+reg_code+" ";
		if(!today_dist.equals("") && !today_dist.equals("0"))	query += " and a.today_dist	= "+today_dist+" ";

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();

			if(rs.next())
			{				
				 est_id = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
            pstmt.close();

		}catch(Exception e){
			System.out.println("[SecondhandDatabase:getSearchEstIdSh]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return est_id;
		}
	}

	/**
	*	�縮�� ���� ���� ������
	*/
	public String getSearchEstIdRm(String car_mng_id, String a_a, String a_b, String o_1, String today_dist, String rent_dt, String amt, String reg_code){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String est_id = "";

		String query =  " select a.est_id from estimate a, esti_compare b where a.est_type = 'S' and a.est_id=b.est_id(+) "+
						" and a.mgr_nm = '"+car_mng_id+"' "+
						" and a.a_a = '"+a_a+"' "+
						" and a.a_b = '"+a_b+"' "+
						" and a.rent_dt	= '"+rent_dt+"' "+
						" and a.fee_s_amt = "+amt+" "+
						" and a.mgr_ssn='rm1'"+
						" ";

		if(!reg_code.equals(""))	query += " and a.reg_code	= "+reg_code+" ";
		if(!today_dist.equals("0") && !today_dist.equals(""))	query += " and a.today_dist	= "+today_dist+" ";

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();

			if(rs.next())
			{				
				 est_id = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
            pstmt.close();

		}catch(Exception e){
			System.out.println("[SecondhandDatabase:getSearchEstIdRm]"+e);

			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return est_id;
		}
	}

/**
	 *	��������
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
				"        a.dpm, c.colo||decode(c.in_col,'','','(����:'||c.in_col||')') as colo, \n"+
				"        c.opt, c.add_opt, d.car_comp_id, d.car_id, d.car_seq, d.section, '' max_dt, h.serv_dt, \n"+
				"        e.imgfile1, e.imgfile2, e.imgfile3, e.imgfile4, e.imgfile5, \n"+
				"        decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(b.dlv_dt,a.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(b.dlv_dt,a.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as today_dist, \n"+
				"        f2.nm as fuel_kd, \n"+
				"        b.brch_id, f.code, a.car_end_dt, a.test_st_dt, a.test_end_dt, \n"+
				"        a.maint_st_dt, a.maint_end_dt, b.rent_dt, a.park, a.park_cont, nvl(a.m1_chk, 0) m1_chk, a.m1_dt,  \n"+
				"        p.fee_s_amt, round(p.fee_s_amt/30,-3) day_s_amt, a.car_use, d.section, b.rent_mng_id, b.rent_l_cd, a.secondhand, d.car_b, c.opt, a.rm_st, a.rm_cont  \n"+
				" from   CAR_REG a, CONT b, CAR_ETC c, CAR_NM d, APPRSL e, (select * from code where c_st='0001' and code<>'0000') f, CAR_MNG k, v_tot_dist vt,  \n"+
					" (select a.car_mng_id, a.serv_dt, a.tot_dist from SERVICE a where a.serv_dt||a.serv_id=(select max(serv_dt||serv_id) from service where car_mng_id=a.car_mng_id and tot_dist > 0)) h,  \n"+
                    //�Ϲݴ������
					" ( select a.*  \n"+
					"   from   estimate_sh a,  \n"+
					"          (select est_ssn, max(est_id) est_id from estimate_sh where est_ssn='"+c_id+"' and est_from ='res_car' and est_fax='Y' and rent_dt like to_char(sysdate,'YYYYMM')||'%' group by est_ssn ) b  \n"+
					"   where  a.est_ssn='"+c_id+"' and a.est_from ='res_car' and a.est_fax='Y' and a.rent_dt like to_char(sysdate,'YYYYMM')||'%' and  a.est_ssn=b.est_ssn and a.est_id=b.est_id) p,  \n"+
					" (select * from code where c_st='0039') f2 "+
				" where  \n"+
					" a.car_mng_id='"+c_id+"' and a.car_mng_id=b.car_mng_id \n"+
					" and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd \n"+
					" and c.car_id=d.car_id and c.car_seq=d.car_seq and d.car_comp_id=k.car_comp_id and d.car_cd=k.code \n"+
					" and d.car_comp_id=f.code  \n"+ 
					" and a.car_mng_id=vt.car_mng_id(+) \n"+
					" and a.car_mng_id=e.car_mng_id(+) \n"+
					" and a.car_mng_id=h.car_mng_id(+) \n"+
					" and a.car_mng_id=p.est_ssn(+) \n"+
					" and a.fuel_kd=f2.nm_cd  \n"+
					"  ";



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
	
	//���� ������ġ ���ϱ�
	public Vector getCarCurrentArea(String car_no){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query =  " select f.reg_dt,"+
						" 		 decode(NVL(i.park_id,b.park),'1','S1','2','S1','3','B1','4','D1','5','S1','7','B1','8','B1','9','D1','10','S1','12','J1','13','G1','14','J1', nvl(g.mng_br_id,f.brch_id)) br_id, "+
						" 		 decode(decode(NVL(i.park_id,b.park),'1','S1','2','S1','3','B1','4','D1','5','S1','7','B1','8','B1','9','D1','10','S1','12','J1','13','G1','14','J1', nvl(g.mng_br_id,f.brch_id)),'S1','������','S2','������','S3','������','S4','������','S5','������','S6','������','I1','������','D1','����','G1','�뱸','J1','����','B1','�λ�') br_nm "+
						" 	FROM   CONT f, CAR_REG b, CONT_ETC g, PARK_CONDITION i "+
						"  	WHERE f.car_mng_id=b.car_mng_id"+
						" 	  and f.rent_mng_id=g.rent_mng_id and f.rent_l_cd=g.rent_l_cd "+
						" 	  and b.car_mng_id=i.car_mng_id(+) "+
						" 	  AND b.car_no = '"+car_no+"'" +
						"	ORDER BY f.reg_dt desc";
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
		}catch(Exception e){
			System.out.println("[SecondhandDatabase:getCarCurrentArea(String car_no)]"+e);
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

	public int sucRes_i(ShResBean bean){
		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		int result = 0;

		query = "INSERT INTO car_pur_com_suc_res(com_con_no, seq, reg_id, situation, memo, reg_dt, cust_nm, cust_tel) "+
				" SELECT ?,nvl(max(seq)+1,1),?,?,?,sysdate,?,? FROM car_pur_com_suc_res WHERE com_con_no=? ";
		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, bean.getCar_mng_id());
			pstmt.setString(2, bean.getDamdang_id());
			pstmt.setString(3, bean.getSituation());
			pstmt.setString(4, bean.getMemo());
			pstmt.setString(5, bean.getCust_nm());
			pstmt.setString(6, bean.getCust_tel());
			pstmt.setString(7, bean.getCar_mng_id());
			
			result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		}catch(SQLException e){
			System.out.println("[SecondhandDatabase:sucRes_i(ShResBean bean)]"+e);
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
	
	public int sucRes_u(ShResBean bean){
		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		int result = 0;

		query = " UPDATE car_pur_com_suc_res "+
				" SET reg_id=?, situation=?, memo=?, cust_nm=?, cust_tel=? "+
				" WHERE com_con_no=? AND seq=? ";

		try{

			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, bean.getDamdang_id());
			pstmt.setString(2, bean.getSituation());
			pstmt.setString(3, bean.getMemo());
			pstmt.setString(4, bean.getCust_nm());
			pstmt.setString(5, bean.getCust_tel());
			pstmt.setString(6, bean.getCar_mng_id());
			pstmt.setString(7, bean.getSeq());
			result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		}catch(SQLException e){
			System.out.println("[SecondhandDatabase:sucRes_u(ShResBean bean)]"+e);
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
     * ���ν��� ȣ��
     */
	public String call_sp_suc_res(String gubun, String com_con_no, String seq, String reg_id, String reg_dt)
	{
    	getConnection();
    	String query = "{CALL P_SUC_RES(?, ?, ?, ?, ?)}";
		String sResult = "0";
		CallableStatement cstmt = null;
		try {
			cstmt = conn.prepareCall(query);
			cstmt.setString(1, gubun);
			cstmt.setString(2, com_con_no);
			cstmt.setString(3, seq);
			cstmt.setString(4, reg_id);
			cstmt.setString(5, reg_dt);
			cstmt.execute();
			cstmt.close();
		} catch (SQLException e) {
			System.out.println("[SecondhandDatabase:call_sp_suc_res]\n"+e);
			e.printStackTrace();
			sResult = "1";
		} finally {
			try{
			     if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}

	public int sucRes_2cng(String com_con_no, String seq){
		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		int result = 0;

		query = " UPDATE car_pur_com_suc_res "+
				" SET situation='2'"+
				" WHERE com_con_no=? AND seq=? ";

		try{

			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, com_con_no);
			pstmt.setInt   (2, AddUtil.parseInt(seq));
			result = pstmt.executeUpdate();

			pstmt.close();
			conn.commit();

		}catch(SQLException e){
			System.out.println("[SecondhandDatabase:sucRes_2cng]"+e);
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

	public int sucRes_3cng(String com_con_no, String seq){
		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		int result = 0;

		query = " UPDATE car_pur_com_suc_res "+
				" SET situation='3'"+
				" WHERE com_con_no=? AND seq=? ";

		try{

			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, com_con_no);
			pstmt.setInt   (2, AddUtil.parseInt(seq));
			result = pstmt.executeUpdate();

			pstmt.close();
			conn.commit();

		}catch(SQLException e){
			System.out.println("[SecondhandDatabase:sucRes_3cng]"+e);
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

	//��������� ���� �뿩������ ������ ��������Ÿ�	
	public Hashtable getBase(String car_mng_id, String rent_dt, String mode, String f_rent_start_dt, int f_over_bas_km, int agree_dist){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		
		String query =  " select "+
                        "        ROUND("+f_over_bas_km+"+((vt.tot_dist-"+f_over_bas_km+")/to_number(to_date(vt.tot_dt,'YYYYMMDD')-to_date('"+f_rent_start_dt+"','YYYYMMDD'))*to_number(to_date('"+rent_dt+"','YYYYMMDD')-to_date('"+f_rent_start_dt+"','YYYYMMDD')))) as TODAY_DIST "+
						" from ( select distinct a.car_mng_id, a.tot_dt, a.tot_dist "+
						"		 from   v_dist a, (select car_mng_id, max(tot_dt||tot_dist) tot from v_dist where tot_dt<='"+rent_dt+"' group by car_mng_id) b "+
						"        where  a.car_mng_id='"+car_mng_id+"'  "+
						"               and a.tot_dt<='"+rent_dt+"' "+
						"               and a.car_mng_id=b.car_mng_id and a.tot_dt||a.tot_dist=b.tot "+
						"      ) vt "+
						" ";
		
		if(mode.contentEquals("2")) {
			query =  " select "+
                    "        ROUND("+f_over_bas_km+"+(("+agree_dist+"/365)*to_number(to_date('"+rent_dt+"','YYYYMMDD')-to_date('"+f_rent_start_dt+"','YYYYMMDD'))*0.87)) as TODAY_DIST "+
					" from ( select distinct a.car_mng_id, a.tot_dt, a.tot_dist "+
					"		 from   v_dist a, (select car_mng_id, max(tot_dt||tot_dist) tot from v_dist where tot_dt<='"+rent_dt+"' group by car_mng_id) b "+
					"        where  a.car_mng_id='"+car_mng_id+"'  "+
					"               and a.tot_dt<='"+rent_dt+"' "+
					"               and a.car_mng_id=b.car_mng_id and a.tot_dt||a.tot_dist=b.tot "+
					"      ) vt "+
					" ";
		}

		try{
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

		}catch(Exception e){
			System.out.println("[SecondhandDatabase:getBase(String car_mng_id, String rent_dt, String mode, String rent_start_dt, int over_bas_km)]"+e);
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
	*	��������� ����Ʈ ������
	*/
	public Hashtable getTaeCarRmAmt(String est_id) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();

		String query = 
				" SELECT " +
					" a.fee_s_amt, " + //--���������������
					" a.fee_v_amt, " + //--��������������� �ΰ���
		            " NVL(a.fee_s_amt, 0) + NVL(a.fee_v_amt, 0) AS fee_t_amt, " + //--��������������� �ΰ��� �ջ�ݾ�
					" NVL(b.br_cons_amt, 0) AS br_cons_amt, " + //--�������̵�Ź�۷� 
					" NVL(b.k_mo, 0) AS a_grt_eff_amt, " + //--������ȿ��(-�ݾ�)
					" NVL(b.k_so, 0) AS a_pp_eff_amt, " +  //--������ȿ��(-�ݾ�)
					" NVL(b.k_wo, 0) AS a_ifee_eff_amt, " + //--���ô뿩��ȿ��(-�ݾ�) 
					" NVL(c.fee_s_amt, 0) AS rm_fee_s_amt, " + //--����Ʈ���� ������
					//" NVL(c.fee_s_amt, 0)+NVL(b.br_cons_amt, 0)+NVL(b.k_mo, 0)+NVL(b.k_so, 0)+NVL(b.k_wo, 0) r_rm_fee_s_amt " + //--������������� ������� ��� (����Ʈ���+����������������̵�Ź�۷�+�������������������ȿ��)                
					" (NVL(c.fee_s_amt, 0)+NVL(b.br_cons_amt, 0)+ROUND(NVL(b.k_mo, 0)+NVL(b.k_so, 0)+NVL(b.k_wo, 0), -2)) * 1.1 as r_rm_fee_s_amt " + //--������������� ������� ��� (����Ʈ���+����������������̵�Ź�۷�+�������������������ȿ��)                
				" FROM " + 
					"estimate a, esti_exam b, (SELECT * FROM estimate_sh WHERE mgr_ssn='rm1') c " +
				" WHERE " +
					" a.EST_ID = ? " + //--��������������� ������ȣ
					" AND a.est_id=b.est_id " +
					" AND a.rent_dt=c.rent_dt(+) AND a.mgr_nm=c.mgr_nm(+) "; 

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, est_id);
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
			System.out.println("[SecondhandDatabase:getTaeCarRmAmt]"+e);
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
	*	�縮�� �������� est_id �˻�
	*/
	public String getSearchEstId(String reg_code){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String est_id = "";

		String query =  " select est_id from estimate where reg_code = '"+reg_code+"' "+
						" ";

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();

			if(rs.next())
			{				
				 est_id = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
            pstmt.close();

		}catch(Exception e){
			System.out.println("[SecondhandDatabase:getSearchEstId(String reg_code)]"+e);

			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return est_id;
		}
	}
	
}

