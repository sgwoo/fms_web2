/**
 * 해지정산 관리
 */
package acar.credit;

import java.sql.*;
import java.util.*;
import acar.database.*;

public class AccuDatabase
{
	private Connection conn = null;
	public static AccuDatabase c_db;
	
	public static AccuDatabase getInstance()
	{
		if(AccuDatabase.c_db == null)
			AccuDatabase.c_db = new AccuDatabase();
		return AccuDatabase.c_db;	
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
	 *	차량회수 insert
	 */
	public boolean insertCarReco(CarRecoBean cr)
	{
		getConnection();
		boolean flag = true;
		String query = "insert into car_reco ("+
							" RENT_MNG_ID, RENT_L_CD, reco_st, reco_d1_st, reco_d2_st, "+
							" reco_cau, reco_dt, reco_id, ip_dt, "+
						 	" etc2_d1_amt,  etc_d1_amt, reg_dt, reg_id, park, park_cont ) values("+
						 	" ?, ?, ?, ?, ?,"+   //5
						 	" ?, replace(?, '-', ''), ?, replace(?, '-', ''),"+  //4 
						 	" ?, ?, to_char(sysdate,'YYYYMMDD'), ?, ?, ? )";  //6(5)
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, cr.getRent_mng_id());
			pstmt.setString(2, cr.getRent_l_cd());
			pstmt.setString(3, cr.getReco_st());
			pstmt.setString(4, cr.getReco_d1_st());
			pstmt.setString(5, cr.getReco_d2_st());
			pstmt.setString(6, cr.getReco_cau());
			pstmt.setString(7, cr.getReco_dt());
			pstmt.setString(8, cr.getReco_id());
			pstmt.setString(9, cr.getIp_dt());
			
			pstmt.setInt(10, cr.getEtc2_d1_amt());
			pstmt.setInt(11, cr.getEtc_d1_amt());
			pstmt.setString(12, cr.getReg_id());
			
			pstmt.setString(13, cr.getPark());
			pstmt.setString(14, cr.getPark_cont());
		    pstmt.executeUpdate();

			conn.commit();
		    
	  	} catch (Exception e) {
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
	 *	차량채권 insert
	 */
	public boolean insertCarCredit(CarCreditBean cr)
	{
		getConnection();
		boolean flag = true;
		String query = "insert into car_credit ( "+
							" RENT_MNG_ID, RENT_L_CD, gi_amt, gi_c_amt, gi_j_amt, c_ins, c_ins_d_nm, c_ins_tel, "+
						 	" crd_reg_gu1, crd_reg_gu2, crd_reg_gu3, crd_reg_gu4, crd_reg_gu5, crd_reg_gu6,"+
						  	" crd_remark1, crd_remark2, crd_remark3, crd_remark4, crd_remark5, crd_remark6,"+
					 	          " crd_req_gu1, crd_req_gu2, crd_req_gu3, crd_req_gu4, crd_req_gu5, crd_req_gu6,"+
						  	" crd_pri1, crd_pri2, crd_pri3, crd_pri4, crd_pri5, crd_pri6,"+
						 	" crd_id, crd_reason, reg_dt, reg_id, guar_st) values("+
						 	" ?, ?, ?, ?, ?, ?, ?, ?,"+
						 	" ?, ?, ?, ?, ?, ?,"+ 
							" ?, ?, ?, ?, ?, ?,"+			
							" ?, ?, ?, ?, ?, ?,"+ 
							" ?, ?, ?, ?, ?, ?,"+					
						 	" ?, ?, to_char(sysdate,'YYYYMMDD'), ? , ?   )";
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, cr.getRent_mng_id());
			pstmt.setString(2, cr.getRent_l_cd());
			pstmt.setInt(3,	cr.getGi_amt());
			pstmt.setInt(4, cr.getGi_c_amt());
			pstmt.setInt(5, cr.getGi_j_amt());
			pstmt.setString(6, cr.getC_ins());
			pstmt.setString(7, cr.getC_ins_d_nm());
			pstmt.setString(8, cr.getC_ins_tel());
			pstmt.setString(9, cr.getCrd_reg_gu1());
			pstmt.setString(10, cr.getCrd_reg_gu2());
			pstmt.setString(11, cr.getCrd_reg_gu3());
			pstmt.setString(12, cr.getCrd_reg_gu4());
			pstmt.setString(13, cr.getCrd_reg_gu5());
			pstmt.setString(14, cr.getCrd_reg_gu6());
			pstmt.setString(15, cr.getCrd_remark1());
			pstmt.setString(16, cr.getCrd_remark2());
			pstmt.setString(17, cr.getCrd_remark3());
			pstmt.setString(18, cr.getCrd_remark4());
			pstmt.setString(19, cr.getCrd_remark5());
			pstmt.setString(20, cr.getCrd_remark6());
			pstmt.setString(21, cr.getCrd_req_gu1());
			pstmt.setString(22, cr.getCrd_req_gu2());
			pstmt.setString(23, cr.getCrd_req_gu3());
			pstmt.setString(24, cr.getCrd_req_gu4());
			pstmt.setString(25, cr.getCrd_req_gu5());
			pstmt.setString(26, cr.getCrd_req_gu6());
			pstmt.setString(27, cr.getCrd_pri1());
			pstmt.setString(28, cr.getCrd_pri2());
			pstmt.setString(29, cr.getCrd_pri3());
			pstmt.setString(30, cr.getCrd_pri4());
			pstmt.setString(31, cr.getCrd_pri5());
			pstmt.setString(32, cr.getCrd_pri6());
			pstmt.setString(33, cr.getCrd_id());
			pstmt.setString(34, cr.getCrd_reason());
			pstmt.setString(35, cr.getReg_id());			
			pstmt.setString(36, cr.getGuar_st());			
			
		    	pstmt.executeUpdate();

			conn.commit();
		    
	  	} catch (Exception e) {
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
	 *	초과운행  insert
	 */
	public boolean insertClsEtcOver(ClsEtcOverBean co)
	{
		getConnection();
		boolean flag = true;
		String query = "insert into cls_etc_over ( "+
							" RENT_MNG_ID, RENT_L_CD, RENT_DAYS, CAL_DIST, FIRST_DIST, LAST_DIST, REAL_DIST,  "+ //7
						 	" OVER_DIST, ADD_DIST, JUNG_DIST, R_OVER_AMT,   M_OVER_AMT,  J_OVER_AMT, "+		//6		
						 	" M_SACTION_DT, M_SACTION_ID, M_REASON) values("+ //3
						 	" ?,  ?,  ?,  ?,  ?,  ?,  ?, "+
						 	" ?,  ?,  ?,  ?,  ?,  ?,  "+ 								
						 	" ?,  ?,  ?  )";
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, co.getRent_mng_id());
			pstmt.setString(2, co.getRent_l_cd());
			pstmt.setInt(3,	co.getRent_days());
			pstmt.setInt(4, co.getCal_dist());
			pstmt.setInt(5, co.getFirst_dist());
			pstmt.setInt(6, co.getLast_dist());
			pstmt.setInt(7, co.getReal_dist());
			pstmt.setInt(8, co.getOver_dist());
			pstmt.setInt(9, co.getAdd_dist());
			pstmt.setInt(10, co.getJung_dist());
			pstmt.setInt(11, co.getR_over_amt());
			pstmt.setInt(12, co.getM_over_amt());		
			pstmt.setInt(13, co.getJ_over_amt());
			pstmt.setString(14, co.getM_saction_dt());
			pstmt.setString(15, co.getM_saction_id());
			pstmt.setString(16, co.getM_reason());		
		 
		    	pstmt.executeUpdate();
			conn.commit();
		   
	  	} catch (Exception e) {
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
	 *	선수금정산 insert
	 */
	public boolean insertClsContEtc(ClsContEtcBean cct)
	{
		getConnection();
		boolean flag = true;
		String query = "insert into cls_cont_etc ( "+
							" RENT_MNG_ID, RENT_L_CD, jung_st, h1_amt, h2_amt, h3_amt,  "+
						 	" h4_amt, h5_amt, h6_amt, h7_amt, h_st, h_ip_dt , suc_gubun, suc_l_cd, delay_st, delay_type, delay_desc, refund_st , r_date )  values ( "+
						 	" ?, ?, ?, ?, ?, ?,  "+
						 	" ?, ?, ?, ?, ?, replace(?, '-', '')  , ?, ? , ?, ?, ?, ?, replace(?, '-', '') )";
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, cct.getRent_mng_id());
			pstmt.setString(2, cct.getRent_l_cd());
			pstmt.setString(3, cct.getJung_st());
			pstmt.setInt(4,	cct.getH1_amt());
			pstmt.setInt(5, cct.getH2_amt());
			pstmt.setInt(6, cct.getH3_amt());
			pstmt.setInt(7,	cct.getH4_amt());
			pstmt.setInt(8, cct.getH5_amt());
			pstmt.setInt(9, cct.getH6_amt());
			pstmt.setInt(10, cct.getH7_amt());
			pstmt.setString(11, cct.getH_st());			
			pstmt.setString(12, cct.getH_ip_dt());			
			pstmt.setString(13, cct.getSuc_gubun());			
			pstmt.setString(14, cct.getSuc_l_cd());		
			pstmt.setString(15, cct.getDelay_st());		
			pstmt.setString(16, cct.getDelay_type());		
			pstmt.setString(17, cct.getDelay_desc());			
			pstmt.setString(18, cct.getRefund_st());			
			pstmt.setString(19, cct.getR_date());			
			
		   	pstmt.executeUpdate();

			conn.commit();
		    
	  	} catch (Exception e) {
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
	 *	해지 insert
	 */
	
	public boolean insertClsEtc(ClsEtcBean cls)
	{
		getConnection();
		boolean flag = true;
		String query = "insert into cls_etc ("+
							" RENT_MNG_ID,	RENT_L_CD,	CLS_ST,		TERM_YN,	CLS_DT, "+ //5
							" REG_ID,		CLS_CAU,	TRF_DT, 	IFEE_S_AMT,	IFEE_V_AMT, IFEE_ETC,	PP_S_AMT,	PP_V_AMT, "+  //8
							" PP_ETC,		PDED_S_AMT, PDED_V_AMT, PDED_ETC,	TPDED_S_AMT,"+  //5
						 	" TPDED_V_AMT,	TPDED_ETC,	RFEE_S_AMT, RFEE_V_AMT, RFEE_ETC, "+  //5
						 	" DFEE_TM,		DFEE_V_AMT, NFEE_TM,	NFEE_S_AMT, "+ //4
							" NFEE_V_AMT,	NFEE_MON,	NFEE_DAY,	NFEE_AMT,	TFEE_AMT, "+  //5
						 	" MFEE_AMT,		RCON_MON,	RCON_DAY,	TRFEE_AMT,	DFT_INT, "+   //5
							" DFT_AMT,		NO_DFT_YN,	NO_DFT_CAU,	FDFT_AMT1,	FDFT_DC_AMT,"+ //5
						 	" FDFT_AMT2,	PAY_DT,		NFEE_DAYS,	RCON_DAYS,	"+   //4
							" CLS_EST_DT,	VAT_ST,		EXT_DT,		EXT_ID,		GRT_AMT, "+ //5
							" CLS_DOC_YN,	OPT_PER,	OPT_AMT,	OPT_DT,		OPT_MNG, "+ //5
							" dly_amt, no_v_amt, car_ja_amt, r_mon, r_day, cls_s_amt, cls_v_amt, etc_amt, fine_amt, ex_di_amt, "+  //10
							" ifee_mon, ifee_day, ifee_ex_amt, rifee_s_amt, cancel_yn, reg_dt, etc2_amt, etc3_amt, etc4_amt,  "+ //9(8)
							" DIV_ST, DIV_CNT, EST_DT, EST_AMT, EST_NM, GUR_NM, GUR_REL_TEL, GUR_REL, REMARK, "+ //9
					//		" SUI_ST, SUI_D1_AMT, SUI_D2_AMT, SUI_D3_AMT, SUI_D4_AMT, SUI_D5_AMT, SUI_D6_AMT, SUI_D7_AMT, SUI_D8_AMT, SUI_D_AMT, "+ //10
							" d_saction_id, d_reason, dfee_amt, "+ //3
							" fine_amt_1, car_ja_amt_1, dly_amt_1, etc_amt_1,  etc2_amt_1, dft_amt_1, ex_di_amt_1, nfee_amt_1,  "+ //8
							" etc3_amt_1, etc4_amt_1,  no_v_amt_1,  fdft_amt1_1, dfee_amt_1, "+ //5						
							" tax_chk0, tax_chk1, tax_chk2, tax_chk3, tax_chk4, tax_chk5, tax_chk6, "+//7
							" rifee_s_amt_s, rfee_s_amt_s, etc_amt_s,  etc2_amt_s,  "+ //4
							" dfee_amt_s, dft_amt_s, etc4_amt_s,  "+  //3
							" rifee_s_amt_v, rfee_s_amt_v, etc_amt_v,  etc2_amt_v,  "+ //4
							" dfee_amt_v, dft_amt_v, etc4_amt_v, car_ja_no_amt, dly_reason, dft_reason, dft_int_1, dly_saction_id, dft_saction_id, fdft_amt3, "+ //10
							" re_bank, re_acc_no, re_acc_nm, tot_dist, cms_chk , tax_reg_gu , sb_saction_id, dft_cost_id,  serv_st,  " + //9
							" over_amt, over_amt_1,  over_amt_s, over_amt_v,  match, ext_saction_id, ext_reason , serv_gubun , b_tot_dist, input_id ," + //10
							" rifee_v_amt, dfee_v_amt_1, over_v_amt ,over_v_amt_1  ) values( "+   //4
						 	" ?, ?, ?, ?, replace(?, '-', ''), "+  //5
							" ?, ?, replace(?, '-', ''), ?, ?, ?, ?, ?, "+  //8
						 	" ?, ?, ?, ?, ?, "+ //5
							" ?, ?, ?, ?, ?, "+ //5
						 	" ?, ?, ?, ?,  "+ //4
							" ?, ?, ?, ?, ?, "+ //5
						 	" ?, ?, ?, ?, ?, "+ //5
							" ?, ?, ?, ?, ?, "+ //5
						 	" ?, ?, ?, ?,  "+ //4
							" replace(?, '-', ''), ?, replace(?, '-', ''), ?, ?,"+ //5
						 	" ?, ?, ?, replace(?, '-', ''), ?,"+  //5
							" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+ //10
							" ?, ?, ?, ?, ?, to_char(sysdate,'YYYYMMDD'), ?, ?, ?, " + //9(8)
							" ?, ?, replace(?, '-', ''), ?, ?, ?, ?, ?, ?, " + //9
						//	" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,  " +  //10
							" ?, ?, ?, " +  //3
							" ?, ?, ?, ?, ?, ?, ?, ?, " + //8
							" ?, ?, ?, ?, ?, " +   //5					
							" ?, ?, ?, ?, ?, ?, ?, " + //7
							" ?, ?, ?, ?,  " +   //4
							" ?, ?, ?,  "+ //3
							" ?, ?, ?, ?, " +   //4
							" ?, ?, ? , ?, ?, ?, ?, ?, ?, ?, " + //10
							" ?, ?, ? , ?, ?, ?, ?, ? , ?,   "+  //12
							" ?, ?, ? , ? , ?, ?, ?, ?, ? , ?, " + //10
							" ?, ?, ? , ?  )"; //4

									
		PreparedStatement pstmt = null;
		
		ResultSet rs = null;
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, cls.getRent_mng_id());
			pstmt.setString(2, cls.getRent_l_cd());
			pstmt.setString(3, cls.getCls_st());
			pstmt.setString(4, cls.getTerm_yn());
			pstmt.setString(5, cls.getCls_dt());
			
			pstmt.setString(6, cls.getReg_id());
			pstmt.setString(7, cls.getCls_cau());
			pstmt.setString(8, cls.getTrf_dt());
			pstmt.setInt   (9, cls.getIfee_s_amt());
			pstmt.setInt   (10, cls.getIfee_v_amt());
			pstmt.setString(11, cls.getIfee_etc());
			pstmt.setInt   (12, cls.getPp_s_amt());
			pstmt.setInt   (13, cls.getPp_v_amt());
			
			pstmt.setString(14, cls.getPp_etc());
			pstmt.setInt   (15, cls.getPded_s_amt());
			pstmt.setInt   (16, cls.getPded_v_amt());
			pstmt.setString(17, cls.getPded_etc());
			pstmt.setInt   (18, cls.getTpded_s_amt());  //5
			
			pstmt.setInt   (19, cls.getTpded_v_amt());
			pstmt.setString(20, cls.getTpded_etc());
			pstmt.setInt   (21, cls.getRfee_s_amt());
			pstmt.setInt   (22, cls.getRfee_v_amt());
			pstmt.setString(23, cls.getRfee_etc());  //5
			
			pstmt.setString(24, cls.getDfee_tm());		
			pstmt.setInt   (25, cls.getDfee_v_amt());
			pstmt.setString(26, cls.getNfee_tm());
			pstmt.setInt   (27, cls.getNfee_s_amt()); //4
			
			pstmt.setInt   (28, cls.getNfee_v_amt());
			pstmt.setString(29, cls.getNfee_mon());
			pstmt.setString(30, cls.getNfee_day());
			pstmt.setInt   (31, cls.getNfee_amt());
			pstmt.setInt   (32, cls.getTfee_amt());  //5
			
			pstmt.setInt   (33, cls.getMfee_amt());
			pstmt.setString(34, cls.getRcon_mon());
			pstmt.setString(35, cls.getRcon_day());
			pstmt.setInt   (36, cls.getTrfee_amt());
			pstmt.setString(37, cls.getDft_int());  //5
			
			pstmt.setInt   (38, cls.getDft_amt());
			pstmt.setString(39, cls.getNo_dft_yn());
			pstmt.setString(40, cls.getNo_dft_cau());
			pstmt.setInt   (41, cls.getFdft_amt1());
			pstmt.setInt   (42, cls.getFdft_dc_amt());  //5
			
			pstmt.setInt   (43, cls.getFdft_amt2());
			pstmt.setString(44, cls.getPay_dt());
			pstmt.setString(45, cls.getNfee_days());
			pstmt.setString(46, cls.getRcon_days()); //4								
						
			pstmt.setString(47, cls.getCls_est_dt());			
			pstmt.setString(48, cls.getVat_st());			
			pstmt.setString(49, cls.getExt_dt());			
			pstmt.setString(50, cls.getExt_id());			
			pstmt.setInt   (51, cls.getGrt_amt());  //5
			
			pstmt.setString(52, cls.getCls_doc_yn());			
			pstmt.setString(53, cls.getOpt_per());			
			pstmt.setInt   (54, cls.getOpt_amt());
			pstmt.setString(55, cls.getOpt_dt());			
			pstmt.setString(56, cls.getOpt_mng());  //5
										
			pstmt.setInt   (57, cls.getDly_amt());
			pstmt.setInt   (58, cls.getNo_v_amt());
			pstmt.setInt   (59, cls.getCar_ja_amt());
			pstmt.setString(60, cls.getR_mon());			
			pstmt.setString(61, cls.getR_day());			
			pstmt.setInt   (62, cls.getCls_s_amt());
			pstmt.setInt   (63, cls.getCls_v_amt());
			pstmt.setInt   (64, cls.getEtc_amt());
			pstmt.setInt   (65, cls.getFine_amt());
			pstmt.setInt   (66, cls.getEx_di_amt());   //10
						
			pstmt.setString(67, cls.getIfee_mon());			
			pstmt.setString(68, cls.getIfee_day());			
			pstmt.setInt   (69, cls.getIfee_ex_amt());
			pstmt.setInt   (70, cls.getRifee_s_amt());
			pstmt.setString(71, cls.getCancel_yn());
			pstmt.setInt   (72, cls.getEtc2_amt());
			pstmt.setInt   (73, cls.getEtc3_amt());
			pstmt.setInt   (74, cls.getEtc4_amt());	  //9(8)
						
			pstmt.setString(75, cls.getDiv_st());			
			pstmt.setInt   (76, cls.getDiv_cnt());			
			pstmt.setString(77, cls.getEst_dt());
			pstmt.setInt   (78, cls.getEst_amt());
			pstmt.setString(79, cls.getEst_nm());
			pstmt.setString(80, cls.getGur_nm());
			pstmt.setString(81, cls.getGur_rel_tel());
			pstmt.setString(82, cls.getGur_rel());
			pstmt.setString(83, cls.getRemark());    //9
						
			pstmt.setString(84, cls.getD_saction_id());
			pstmt.setString(85, cls.getD_reason());     	
			pstmt.setInt   (86, cls.getDfee_amt());		//3
		
			pstmt.setInt   (87, cls.getFine_amt_1());
			pstmt.setInt   (88, cls.getCar_ja_amt_1());
			pstmt.setInt   (89, cls.getDly_amt_1());
			pstmt.setInt   (90, cls.getEtc_amt_1());
			pstmt.setInt   (91, cls.getEtc2_amt_1());
			pstmt.setInt   (92, cls.getDft_amt_1());
			pstmt.setInt   (93, cls.getEx_di_amt_1());  
			pstmt.setInt   (94, cls.getNfee_amt_1());  //8
			
			pstmt.setInt   (95, cls.getEtc3_amt_1());
			pstmt.setInt   (96, cls.getEtc4_amt_1());
			pstmt.setInt   (97, cls.getNo_v_amt_1());
			pstmt.setInt   (98, cls.getFdft_amt1_1());
			pstmt.setInt   (99, cls.getDfee_amt_1());  //5
							
			pstmt.setString(100, cls.getTax_chk0());	
			pstmt.setString(101, cls.getTax_chk1());	
			pstmt.setString(102, cls.getTax_chk2());	
			pstmt.setString(103, cls.getTax_chk3());	
			pstmt.setString(104, cls.getTax_chk4());	
			pstmt.setString(105, cls.getTax_chk5());	
			pstmt.setString(106, cls.getTax_chk6());	//7
								
			pstmt.setInt   (107, cls.getRifee_s_amt_s());
			pstmt.setInt   (108, cls.getRfee_s_amt_s());		
			pstmt.setInt   (109, cls.getEtc_amt_s());
			pstmt.setInt   (110, cls.getEtc2_amt_s());
			
			pstmt.setInt   (111, cls.getDfee_amt_s());
			pstmt.setInt   (112, cls.getDft_amt_s());
			pstmt.setInt   (113, cls.getEtc4_amt_s());
					
			pstmt.setInt   (114, cls.getRifee_s_amt_v());
			pstmt.setInt   (115, cls.getRfee_s_amt_v());		
			pstmt.setInt   (116, cls.getEtc_amt_v());
			pstmt.setInt   (117, cls.getEtc2_amt_v());
			
			pstmt.setInt   (118, cls.getDfee_amt_v());
			pstmt.setInt   (119, cls.getDft_amt_v());
			pstmt.setInt   (120, cls.getEtc4_amt_v());
			pstmt.setInt   (121, cls.getCar_ja_no_amt());
			
			pstmt.setString(122, cls.getDly_reason());	
			pstmt.setString(123, cls.getDft_reason());	
			pstmt.setString(124, cls.getDft_int_1());	
			pstmt.setString(125, cls.getDly_saction_id());	
			pstmt.setString(126, cls.getDft_saction_id());	
			pstmt.setInt   (127, cls.getFdft_amt3());
			
			pstmt.setString(128, cls.getRe_bank());	
			pstmt.setString(129, cls.getRe_acc_no());	
			pstmt.setString(130, cls.getRe_acc_nm());
			
			pstmt.setInt   (131, cls.getTot_dist());	
			pstmt.setString(132, cls.getCms_chk());	
			
			pstmt.setString(133, cls.getTax_reg_gu());	
			
			pstmt.setString(134, cls.getSb_saction_id());	
			pstmt.setString(135, cls.getDft_cost_id());	
			pstmt.setString(136, cls.getServ_st());  //9
					
			pstmt.setInt   (137, cls.getOver_amt());
			pstmt.setInt   (138, cls.getOver_amt_1());
			pstmt.setInt   (139, cls.getOver_amt_s());
			pstmt.setInt   (140, cls.getOver_amt_v());   	
			pstmt.setString(141, cls.getMatch());  //5
			
			pstmt.setString(142, cls.getExt_saction_id());  //선수금 후불처리
			pstmt.setString(143, cls.getExt_reason());  // 선수금 후불처리 사유
			
			pstmt.setString(144, cls.getServ_gubun());  // 예비차 적용형태 
			pstmt.setInt   (145, cls.getB_tot_dist());  //게기판 변경으로 인한 추가할 주행거리   
			pstmt.setString(146, cls.getInput_id());  //실제데이타 입력자
			
		//2022-04 추가 -부가세 개별 처리 
			pstmt.setInt   (147, cls.getRifee_v_amt());
			pstmt.setInt   (148, cls.getDfee_v_amt_1());
			pstmt.setInt   (149, cls.getOver_v_amt());
			pstmt.setInt   (150, cls.getOver_v_amt_1());   	
			
			pstmt.executeUpdate();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[AccuDatabase:insertClsEtc]\n"+e);			
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
	 *	해지상세내역 insert
	 */
	public boolean insertClsEtcSub(ClsEtcSubBean clss)
	{
		getConnection();
		boolean flag = true;
		String query_seq = "";
		int seq = 0;
	 
		String query = "insert into cls_etc_sub ("+
							" RENT_MNG_ID,	RENT_L_CD,	CLS_SEQ,	 "+ //3
							" fine_amt_1, car_ja_amt_1, dly_amt_1, etc_amt_1,  etc2_amt_1, dft_amt_1, dfee_amt_1,  "+ //7
							" etc3_amt_1, etc4_amt_1,  no_v_amt_1,  fdft_amt1_1, "+ //4	
							" reg_dt, reg_id , over_amt_1 ) values( "+  //3
						 	" ?, ?, ?, "+  //3
							" ?, ?, ?, ?, ?, ?, ?, " + //7
							" ?, ?, ?, ?,  " +  //4
							" to_char(sysdate,'YYYYMMDD'), ? , ?) ";  //3(2)

		query_seq = "select nvl(max(cls_seq)+1, 1)  from cls_etc_sub where rent_mng_id = '" + clss.getRent_mng_id() + "' and rent_l_cd = '" + clss.getRent_l_cd() + "'";	
		        		        							
		PreparedStatement pstmt = null;
			
		ResultSet rs = null;
		Statement stmt = null;
		
		try 
		{
			conn.setAutoCommit(false);
			
			stmt = conn.createStatement();
            rs = stmt.executeQuery(query_seq);
         //   System.out.println(query_seq);
            if(rs.next())
            	seq = rs.getInt(1);
            rs.close();
			stmt.close();

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, clss.getRent_mng_id());
			pstmt.setString(2, clss.getRent_l_cd());
			pstmt.setInt(3, seq);
	
			pstmt.setInt   (4, clss.getFine_amt_1());
			pstmt.setInt   (5, clss.getCar_ja_amt_1());
			pstmt.setInt   (6, clss.getDly_amt_1());
			pstmt.setInt   (7, clss.getEtc_amt_1());
			pstmt.setInt   (8, clss.getEtc2_amt_1());
			pstmt.setInt   (9, clss.getDft_amt_1());
			pstmt.setInt   (10, clss.getDfee_amt_1());
			
			pstmt.setInt   (11, clss.getEtc3_amt_1());
			pstmt.setInt   (12, clss.getEtc4_amt_1());
			pstmt.setInt   (13, clss.getNo_v_amt_1());
			pstmt.setInt   (14, clss.getFdft_amt1_1());
			
			pstmt.setString(15, clss.getReg_id());
			pstmt.setInt   (16, clss.getOver_amt_1());
								
			pstmt.executeUpdate();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[AccuDatabase:insertClsEtcSub]\n"+e);			
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(rs != null) 		rs.close();
                if(stmt != null) 	stmt.close();
                if(pstmt != null)	pstmt.close();
               
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}
 
 	
	/*해지의뢰 수정페이지 조회 :  rent_mng_id, rent_l_cd  */
	
	public ClsEtcBean getClsEtcCase(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		ClsEtcBean cls = new ClsEtcBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		query = " select"+
				" a.RENT_MNG_ID, a.RENT_L_CD, a.TERM_YN, a.cls_st cls_st_r,"+ 
				" decode(a.CLS_ST, '1','계약만료', '2','중도해약', '3','영업소변경', '4','차종변경', '5','계약승계', '6','매각', '7','출고전해지(신차)', '8','매입옵션', '9', '폐차', '10' , '개시전해지(재리스)',  '14' , '월렌트해지' ) CLS_ST,"+
		//		" decode(a.CLS_DT, '', '', substr(a.CLS_DT, 1, 4) || '-' || substr(a.CLS_DT, 5, 2) || '-'||substr(a.CLS_DT, 7, 2)) CLS_DT,"+
				" a.CLS_DT, a.REG_ID, a.CLS_CAU, "+
				" a.IFEE_S_AMT, a.IFEE_V_AMT, a.IFEE_ETC, a.PP_S_AMT, a.PP_V_AMT, a.PP_ETC,"+
				" a.PDED_S_AMT, a.PDED_V_AMT, a.PDED_ETC, a.TPDED_S_AMT, a.TPDED_V_AMT, a.TPDED_ETC, a.RFEE_S_AMT,"+
				" a.RFEE_V_AMT, a.RFEE_ETC, a.DFEE_TM, a.DFEE_V_AMT, a.NFEE_TM, a.NFEE_S_AMT, a.NFEE_V_AMT,"+
				" rtrim(a.NFEE_MON) NFEE_MON, rtrim(a.NFEE_DAY) NFEE_DAY, a.NFEE_AMT, a.TFEE_AMT, a.MFEE_AMT, a.NO_V_AMT,"+
				" rtrim(a.RCON_MON) RCON_MON, rtrim(a.RCON_DAY) RCON_DAY,"+
				" a.TRFEE_AMT, a.DFT_INT, a.DFT_AMT, a.NO_DFT_YN, a.NO_DFT_CAU, a.FDFT_AMT1, a.FDFT_DC_AMT, a.FDFT_AMT2,"+
				" decode(b.PAY_DT, '', '', substr(b.PAY_DT, 1, 4) || '-' || substr(b.PAY_DT, 5, 2) || '-'||substr(b.PAY_DT, 7, 2)) PAY_DT,"+
				" decode(a.opt_dt, '', '', substr(a.opt_dt, 1, 4) || '-' || substr(a.opt_dt, 5, 2) || '-'||substr(a.opt_dt, 7, 2)) opt_dt,"+
				" a.NFEE_DAYS, a.RCON_DAYS, a.cls_est_dt, a.ext_dt, a.ext_id, a.vat_st, a.grt_amt, a.opt_per, a.opt_amt, a.opt_mng,"+
				" a.dly_amt, a.no_v_amt, a.car_ja_amt, a.etc_amt, a.r_mon, a.r_day, a.cls_s_amt, a.cls_v_amt, a.fine_amt, a.ex_di_amt, a.ifee_mon, a.ifee_day, a.ifee_ex_amt, a.rifee_s_amt, a.cancel_yn, "+
				" a.etc2_amt, a.etc3_amt, a.etc4_amt, a.dfee_amt, a.FDFT_AMT1_1, "+
				" a.ex_di_amt_1, a.dly_amt_1, a.no_v_amt_1, a.car_ja_amt_1, a.etc_amt_1, a.fine_amt_1, a.etc2_amt_1, a.etc3_amt_1, a.etc4_amt_1, a.nfee_amt_1, a.dfee_amt_1, a.DFT_AMT_1, "+
				" decode(a.div_st, '1','일시납', '2','분납' ) DIV_ST, a.div_cnt, " +
				" decode(a.est_dt, '', '', substr(a.est_dt, 1, 4) || '-' || substr(a.est_dt, 5, 2) || '-'||substr(a.est_dt, 7, 2)) est_dt,"+
				" a.est_amt, a.est_nm, a.gur_nm, a.gur_rel_tel, a.gur_rel, a.remark , a.d_saction_id, a.d_reason, a.dfee_amt, "+
				" a.tax_chk0, a.tax_chk1, a.tax_chk2,a.tax_chk3, a.tax_chk4, a.tax_chk5, a.tax_chk6, "+
				" dft_amt_s, etc_amt_s, etc2_amt_s, etc4_amt_s, dft_amt_v, etc_amt_v, etc2_amt_v, etc4_amt_v , car_ja_no_amt, autodoc_yn, dly_reason, dft_reason, dft_int_1,  "+
				" a.dly_saction_id, a.dft_saction_id , a.fdft_amt3, "+
				" decode(a.opt_ip_dt1, '', '', substr(a.opt_ip_dt1, 1, 4) || '-' || substr(a.opt_ip_dt1, 5, 2) || '-'||substr(a.opt_ip_dt1, 7, 2)) opt_ip_dt1, a.opt_ip_amt1, a.opt_ip_bank1, a.opt_ip_bank_no1, "+
				" decode(a.opt_ip_dt2, '', '', substr(a.opt_ip_dt2, 1, 4) || '-' || substr(a.opt_ip_dt2, 5, 2) || '-'||substr(a.opt_ip_dt2, 7, 2)) opt_ip_dt2, a.opt_ip_amt2, a.opt_ip_bank2, a.opt_ip_bank_no2, "+
				" a.re_bank, a.re_acc_no, a.re_acc_nm,  a.dft_saction_dt, a.tax_reg_gu, a.tot_dist, a.cms_chk , a.ext_st , a.r_tax_dt, " +
				" a.sb_saction_id, a.sb_saction_dt , a.opt_s_amt, a.opt_v_amt , a.dft_cost_id , a.serv_st , " +
				" a.over_amt, a.over_amt_1 , a.match, a.ext_saction_id, a.ext_reason  , a.over_amt_s , a.over_amt_v , a.serv_gubun , a.cls_eff_amt , a.b_tot_dist, a.input_id ,"+
				" a.rifee_v_amt , a.dfee_v_amt_1, a.over_v_amt, a.over_v_amt_1 \n"+  //4
				" from cls_etc a, (select RENT_L_CD, max(ext_pay_dt) PAY_DT from scd_ext where ext_st = '4' group by rent_l_cd) b "+
				" where a.RENT_L_CD=b.RENT_L_CD(+) and a.RENT_MNG_ID = ? and a.RENT_L_CD = ? ";
						
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
	    	rs = pstmt.executeQuery();	 
	    	
  
	    	
			while(rs.next())
			{
				cls.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				cls.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				cls.setCls_st(rs.getString("CLS_ST")==null?"":rs.getString("CLS_ST"));	   
				cls.setCls_st_r(rs.getString("CLS_ST_R")==null?"":rs.getString("CLS_ST_R"));	      
				cls.setTerm_yn(rs.getString("TERM_YN")==null?"":rs.getString("TERM_YN"));	
				cls.setCls_dt(rs.getString("CLS_DT")==null?"":rs.getString("CLS_DT"));	
				cls.setReg_id(rs.getString("REG_ID")==null?"":rs.getString("REG_ID"));	
				cls.setCls_cau(rs.getString("CLS_CAU")==null?"":rs.getString("CLS_CAU"));	

				cls.setIfee_s_amt(rs.getInt("IFEE_S_AMT"));
				cls.setIfee_v_amt(rs.getInt("IFEE_V_AMT"));
				cls.setIfee_etc(rs.getString("IFEE_ETC")==null?"":rs.getString("IFEE_ETC"));	
				cls.setPp_s_amt(rs.getInt("PP_S_AMT"));
				cls.setPp_v_amt(rs.getInt("PP_V_AMT"));
				cls.setPp_etc(rs.getString("PP_ETC")==null?"":rs.getString("PP_ETC"));	
				cls.setPded_s_amt(rs.getInt("PDED_S_AMT"));
				cls.setPded_v_amt(rs.getInt("PDED_V_AMT"));
				cls.setPded_etc(rs.getString("PDED_ETC")==null?"":rs.getString("PDED_ETC"));	
				cls.setTpded_s_amt(rs.getInt("TPDED_S_AMT"));
				cls.setTpded_v_amt(rs.getInt("TPDED_V_AMT"));
				cls.setTpded_etc(rs.getString("TPDED_ETC")==null?"":rs.getString("TPDED_ETC"));
				cls.setRfee_s_amt(rs.getInt("RFEE_S_AMT"));
				cls.setRfee_v_amt(rs.getInt("RFEE_V_AMT"));
				cls.setRfee_etc(rs.getString("RFEE_ETC")==null?"":rs.getString("RFEE_ETC"));	
				cls.setDfee_tm(rs.getString("DFEE_TM")==null?"":rs.getString("DFEE_TM"));				
				cls.setDfee_v_amt(rs.getInt("DFEE_V_AMT"));
				cls.setDfee_amt(rs.getInt("dfee_amt"));
				cls.setNfee_tm(rs.getString("NFEE_TM")==null?"":rs.getString("NFEE_TM"));	
				cls.setNfee_s_amt(rs.getInt("NFEE_S_AMT"));
				cls.setNfee_v_amt(rs.getInt("NFEE_V_AMT"));
				cls.setNfee_mon(rs.getString("NFEE_MON")==null?"":rs.getString("NFEE_MON"));
				cls.setNfee_day(rs.getString("NFEE_DAY")==null?"":rs.getString("NFEE_DAY"));
				cls.setNfee_amt(rs.getInt("NFEE_AMT"));
				cls.setTfee_amt(rs.getInt("TFEE_AMT"));
				cls.setMfee_amt(rs.getInt("MFEE_AMT"));
				cls.setRcon_mon(rs.getString("RCON_MON")==null?"":rs.getString("RCON_MON"));
				cls.setRcon_day(rs.getString("RCON_DAY")==null?"":rs.getString("RCON_DAY"));
				cls.setTrfee_amt(rs.getInt("TRFEE_AMT"));
				cls.setDft_int(rs.getString("DFT_INT")==null?"":rs.getString("DFT_INT"));	
				cls.setDft_amt(rs.getInt("DFT_AMT"));
				cls.setNo_dft_yn(rs.getString("NO_DFT_YN")==null?"":rs.getString("NO_DFT_YN"));
				cls.setNo_dft_cau(rs.getString("NO_DFT_CAU")==null?"":rs.getString("NO_DFT_CAU"));
				cls.setFdft_amt1(rs.getInt("FDFT_AMT1"));
				cls.setFdft_dc_amt(rs.getInt("FDFT_DC_AMT"));
				cls.setFdft_amt2(rs.getInt("FDFT_AMT2"));
				cls.setPay_dt(rs.getString("PAY_DT")==null?"":rs.getString("PAY_DT"));
				
				cls.setNfee_days(rs.getString("NFEE_DAYS")==null?"":rs.getString("NFEE_DAYS"));
				cls.setRcon_days(rs.getString("RCON_DAYS")==null?"":rs.getString("RCON_DAYS"));
				cls.setCls_est_dt(rs.getString("CLS_EST_DT")==null?"":rs.getString("CLS_EST_DT"));
				cls.setExt_dt(rs.getString("ext_dt")==null?"":rs.getString("ext_dt"));
				cls.setExt_id(rs.getString("ext_id")==null?"":rs.getString("ext_id"));
				cls.setVat_st(rs.getString("vat_st")==null?"":rs.getString("vat_st"));
				cls.setGrt_amt(rs.getInt("grt_amt"));
			
				cls.setOpt_per(rs.getString("opt_per")==null?"":rs.getString("opt_per"));
				cls.setOpt_amt(rs.getInt("opt_amt"));
				cls.setOpt_dt(rs.getString("opt_dt")==null?"":rs.getString("opt_dt"));
				cls.setOpt_mng(rs.getString("opt_mng")==null?"":rs.getString("opt_mng"));
												
				cls.setDly_amt(rs.getInt("dly_amt"));
				cls.setNo_v_amt(rs.getInt("no_v_amt"));
				cls.setCar_ja_amt(rs.getInt("car_ja_amt"));
				cls.setFine_amt(rs.getInt("fine_amt"));
				cls.setEtc_amt(rs.getInt("etc_amt"));
				cls.setEtc2_amt(rs.getInt("etc2_amt"));
				cls.setEtc3_amt(rs.getInt("etc3_amt"));
				cls.setEtc4_amt(rs.getInt("etc4_amt"));
				cls.setR_mon(rs.getString("r_mon")==null?"":rs.getString("r_mon"));
				cls.setR_day(rs.getString("r_day")==null?"":rs.getString("r_day"));
				cls.setCls_s_amt(rs.getInt("cls_s_amt"));
				cls.setCls_v_amt(rs.getInt("cls_v_amt"));
				cls.setEx_di_amt(rs.getInt("ex_di_amt"));
				cls.setIfee_mon(rs.getString("ifee_mon")==null?"":rs.getString("ifee_mon"));
				cls.setIfee_day(rs.getString("ifee_day")==null?"":rs.getString("ifee_day"));
				cls.setIfee_ex_amt(rs.getInt("ifee_ex_amt"));
				cls.setRifee_s_amt(rs.getInt("rifee_s_amt"));
				cls.setCancel_yn(rs.getString("cancel_yn")==null?"":rs.getString("cancel_yn"));
				
				cls.setFdft_amt1_1(rs.getInt("FDFT_AMT1_1"));
				cls.setEx_di_amt_1(rs.getInt("ex_di_amt_1"));
				cls.setDly_amt_1(rs.getInt("dly_amt_1"));
				cls.setNo_v_amt_1(rs.getInt("no_v_amt_1"));
				cls.setCar_ja_amt_1(rs.getInt("car_ja_amt_1"));
				cls.setEtc_amt_1(rs.getInt("etc_amt_1"));
				cls.setFine_amt_1(rs.getInt("fine_amt_1"));
				cls.setEtc2_amt_1(rs.getInt("etc2_amt_1"));
				cls.setEtc3_amt_1(rs.getInt("etc3_amt_1"));
				cls.setEtc4_amt_1(rs.getInt("etc4_amt_1"));
				cls.setNfee_amt_1(rs.getInt("nfee_amt_1"));				
				cls.setDfee_amt_1(rs.getInt("dfee_amt_1"));		
				cls.setDft_amt_1(rs.getInt("DFT_AMT_1"));	
				cls.setDiv_st(rs.getString("div_st")==null?"":rs.getString("div_st"));		
				cls.setDiv_cnt(rs.getInt("div_cnt"));		
				cls.setEst_dt(rs.getString("est_dt")==null?"":rs.getString("est_dt"));		
				cls.setEst_amt(rs.getInt("est_amt"));	
				cls.setEst_nm(rs.getString("est_nm")==null?"":rs.getString("est_nm"));		
				cls.setGur_nm(rs.getString("gur_nm")==null?"":rs.getString("gur_nm"));		
				cls.setGur_rel_tel(rs.getString("gur_rel_tel")==null?"":rs.getString("gur_rel_tel"));		
				cls.setGur_rel(rs.getString("gur_rel")==null?"":rs.getString("gur_rel"));		
				cls.setRemark(rs.getString("remark")==null?"":rs.getString("remark"));		
										
				cls.setD_reason(rs.getString("d_reason")==null?"":rs.getString("d_reason"));	
				cls.setD_saction_id(rs.getString("d_saction_id")==null?"":rs.getString("d_saction_id"));						
				
				cls.setTax_chk0(rs.getString("tax_chk0")==null?"":rs.getString("tax_chk0"));	
				cls.setTax_chk1(rs.getString("tax_chk1")==null?"":rs.getString("tax_chk1"));
				cls.setTax_chk2(rs.getString("tax_chk2")==null?"":rs.getString("tax_chk2"));
				cls.setTax_chk3(rs.getString("tax_chk3")==null?"":rs.getString("tax_chk3"));
				cls.setTax_chk4(rs.getString("tax_chk4")==null?"":rs.getString("tax_chk4"));
				cls.setTax_chk5(rs.getString("tax_chk5")==null?"":rs.getString("tax_chk5"));
				cls.setTax_chk6(rs.getString("tax_chk6")==null?"":rs.getString("tax_chk6"));
			
				cls.setDft_amt_s(rs.getInt("dft_amt_s"));
				cls.setEtc_amt_s(rs.getInt("etc_amt_s"));
				cls.setEtc2_amt_s(rs.getInt("etc2_amt_s"));
				cls.setEtc4_amt_s(rs.getInt("etc4_amt_s"));
				cls.setDft_amt_v(rs.getInt("dft_amt_v"));
				cls.setEtc_amt_v(rs.getInt("etc_amt_v"));
				cls.setEtc2_amt_v(rs.getInt("etc2_amt_v"));
				cls.setEtc4_amt_v(rs.getInt("etc4_amt_v"));
				cls.setCar_ja_no_amt(rs.getInt("car_ja_no_amt"));
				cls.setAutodoc_yn(rs.getString("autodoc_yn")==null?"N":rs.getString("autodoc_yn"));
				
				cls.setDly_reason(rs.getString("dly_reason")==null?"":rs.getString("dly_reason"));
				cls.setDft_reason(rs.getString("dft_reason")==null?"":rs.getString("dft_reason"));
				cls.setDft_int_1(rs.getString("DFT_INT_1")==null?"":rs.getString("DFT_INT_1"));	
				
				
				cls.setDly_saction_id(rs.getString("dly_saction_id")==null?"":rs.getString("dly_saction_id"));		
				cls.setDft_saction_id(rs.getString("dft_saction_id")==null?"":rs.getString("dft_saction_id"));		
				cls.setFdft_amt3(rs.getInt("fdft_amt3"));	
				
				cls.setOpt_ip_dt1(rs.getString("opt_ip_dt1")==null?"":rs.getString("opt_ip_dt1"));	
				cls.setOpt_ip_amt1(rs.getInt("opt_ip_amt1"));	
				cls.setOpt_ip_bank1(rs.getString("opt_ip_bank1")==null?"":rs.getString("opt_ip_bank1"));		
				cls.setOpt_ip_bank_no1(rs.getString("opt_ip_bank_no1")==null?"":rs.getString("opt_ip_bank_no1"));		
				
				cls.setOpt_ip_dt2(rs.getString("opt_ip_dt2")==null?"":rs.getString("opt_ip_dt2"));	
				cls.setOpt_ip_amt2(rs.getInt("opt_ip_amt2"));	
				cls.setOpt_ip_bank2(rs.getString("opt_ip_bank2")==null?"":rs.getString("opt_ip_bank2"));		
				cls.setOpt_ip_bank_no2(rs.getString("opt_ip_bank_no2")==null?"":rs.getString("opt_ip_bank_no2"));	
				
				cls.setRe_bank(rs.getString("re_bank")==null?"":rs.getString("re_bank"));	
				cls.setRe_acc_no(rs.getString("re_acc_no")==null?"":rs.getString("re_acc_no"));	
				cls.setRe_acc_nm(rs.getString("re_acc_nm")==null?"":rs.getString("re_acc_nm"));		
			
				cls.setDft_saction_dt(rs.getString("dft_saction_dt")==null?"":rs.getString("dft_saction_dt"));		
				cls.setTax_reg_gu(rs.getString("TAX_REG_GU")==null?"N":rs.getString("TAX_REG_GU"));	
				cls.setTot_dist(rs.getInt("tot_dist"));	
				cls.setCms_chk(rs.getString("cms_chk")==null?"N":rs.getString("cms_chk"));	
				cls.setExt_st(rs.getString("ext_st")==null?"":rs.getString("ext_st"));	
				cls.setR_tax_dt(rs.getString("r_tax_dt")==null?"":rs.getString("r_tax_dt"));	
				
				cls.setSb_saction_id(rs.getString("sb_saction_id")==null?"":rs.getString("sb_saction_id"));	
				cls.setSb_saction_dt(rs.getString("sb_saction_dt")==null?"":rs.getString("sb_saction_dt"));	
										
				cls.setOpt_s_amt(rs.getInt("opt_s_amt"));
				cls.setOpt_v_amt(rs.getInt("opt_v_amt"));
				
				cls.setDft_cost_id(rs.getString("dft_cost_id")==null?"":rs.getString("dft_cost_id"));	
						
				cls.setServ_st(rs.getString("serv_st")==null?"":rs.getString("serv_st"));	
				
				cls.setOver_amt(rs.getInt("over_amt"));
				cls.setOver_amt_1(rs.getInt("over_amt_1"));
				cls.setOver_amt_s(rs.getInt("over_amt_s"));
				cls.setOver_amt_v(rs.getInt("over_amt_v"));
				
				cls.setMatch(rs.getString("match")==null?"":rs.getString("match"));	
				
				cls.setExt_reason(rs.getString("ext_reason")==null?"":rs.getString("ext_reason"));	
				cls.setExt_saction_id(rs.getString("ext_saction_id")==null?"":rs.getString("ext_saction_id"));		
				
				cls.setServ_gubun(rs.getString("serv_gubun")==null?"":rs.getString("serv_gubun"));		
				
				cls.setCls_eff_amt(rs.getInt("cls_eff_amt"));
				cls.setB_tot_dist(rs.getInt("b_tot_dist"));
				
				cls.setInput_id(rs.getString("input_id")==null?"":rs.getString("input_id"));	
				
				cls.setRifee_v_amt(rs.getInt("rifee_v_amt"));
				cls.setDfee_v_amt_1(rs.getInt("dfee_v_amt_1"));
				cls.setOver_v_amt(rs.getInt("over_v_amt"));
				cls.setOver_v_amt_1(rs.getInt("over_v_amt_1"));
			
			}
		} catch (SQLException e) {
			System.out.println("[AccuDatabase:getClsEtcCase]\n"+e);			
			System.out.println(query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return cls;
		}
	}
	
	
	public ClsEtcBean getClsEtcCase(String car_mng_id)
	{
		getConnection();
		ClsEtcBean cls = new ClsEtcBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		query = " select"+
				" a.RENT_MNG_ID, a.RENT_L_CD, a.TERM_YN, a.cls_st cls_st_r,"+ 
				" decode(a.CLS_ST, '1','계약만료', '2','중도해약', '3','영업소변경', '4','차종변경', '5','계약승계', '6','매각', '7','출고전해지(신차)', '8','매입옵션', '9', '폐차', '10' , '개시전해지(재리스)',  '14' , '월렌트해지' ) CLS_ST,"+
		//		" decode(a.CLS_DT, '', '', substr(a.CLS_DT, 1, 4) || '-' || substr(a.CLS_DT, 5, 2) || '-'||substr(a.CLS_DT, 7, 2)) CLS_DT,"+
				" a.CLS_DT, a.REG_ID, a.CLS_CAU, "+
				" a.IFEE_S_AMT, a.IFEE_V_AMT, a.IFEE_ETC, a.PP_S_AMT, a.PP_V_AMT, a.PP_ETC,"+
				" a.PDED_S_AMT, a.PDED_V_AMT, a.PDED_ETC, a.TPDED_S_AMT, a.TPDED_V_AMT, a.TPDED_ETC, a.RFEE_S_AMT,"+
				" a.RFEE_V_AMT, a.RFEE_ETC, a.DFEE_TM, a.DFEE_V_AMT, a.NFEE_TM, a.NFEE_S_AMT, a.NFEE_V_AMT,"+
				" rtrim(a.NFEE_MON) NFEE_MON, rtrim(a.NFEE_DAY) NFEE_DAY, a.NFEE_AMT, a.TFEE_AMT, a.MFEE_AMT, a.NO_V_AMT,"+
				" rtrim(a.RCON_MON) RCON_MON, rtrim(a.RCON_DAY) RCON_DAY,"+
				" a.TRFEE_AMT, a.DFT_INT, a.DFT_AMT, a.NO_DFT_YN, a.NO_DFT_CAU, a.FDFT_AMT1, a.FDFT_DC_AMT, a.FDFT_AMT2,"+
				" decode(b.PAY_DT, '', '', substr(b.PAY_DT, 1, 4) || '-' || substr(b.PAY_DT, 5, 2) || '-'||substr(b.PAY_DT, 7, 2)) PAY_DT,"+
				" decode(a.opt_dt, '', '', substr(a.opt_dt, 1, 4) || '-' || substr(a.opt_dt, 5, 2) || '-'||substr(a.opt_dt, 7, 2)) opt_dt,"+
				" a.NFEE_DAYS, a.RCON_DAYS, a.cls_est_dt, a.ext_dt, a.ext_id, a.vat_st, a.grt_amt, a.opt_per, a.opt_amt, a.opt_mng,"+
				" a.dly_amt, a.no_v_amt, a.car_ja_amt, a.etc_amt, a.r_mon, a.r_day, a.cls_s_amt, a.cls_v_amt, a.fine_amt, a.ex_di_amt, a.ifee_mon, a.ifee_day, a.ifee_ex_amt, a.rifee_s_amt, a.cancel_yn, "+
				" a.etc2_amt, a.etc3_amt, a.etc4_amt, a.dfee_amt, a.FDFT_AMT1_1, "+
				" a.ex_di_amt_1, a.dly_amt_1, a.no_v_amt_1, a.car_ja_amt_1, a.etc_amt_1, a.fine_amt_1, a.etc2_amt_1, a.etc3_amt_1, a.etc4_amt_1, a.nfee_amt_1, a.dfee_amt_1, a.DFT_AMT_1, "+
				" decode(a.div_st, '1','일시납', '2','분납' ) DIV_ST, a.div_cnt, " +
				" decode(a.est_dt, '', '', substr(a.est_dt, 1, 4) || '-' || substr(a.est_dt, 5, 2) || '-'||substr(a.est_dt, 7, 2)) est_dt,"+
				" a.est_amt, a.est_nm, a.gur_nm, a.gur_rel_tel, a.gur_rel, a.remark , a.d_saction_id, a.d_reason, a.dfee_amt, "+
				" a.tax_chk0, a.tax_chk1, a.tax_chk2,a.tax_chk3, a.tax_chk4, a.tax_chk5, a.tax_chk6, "+
				" dft_amt_s, etc_amt_s, etc2_amt_s, etc4_amt_s, dft_amt_v, etc_amt_v, etc2_amt_v, etc4_amt_v , car_ja_no_amt, autodoc_yn, dly_reason, dft_reason, dft_int_1,  "+
		//		" a.SUI_ST, a.SUI_D1_AMT, a.SUI_D2_AMT, a.SUI_D3_AMT, a.SUI_D4_AMT, a.SUI_D5_AMT, a.SUI_D6_AMT, a.SUI_D7_AMT, a.SUI_D8_AMT, a.SUI_D_AMT, "+ //10
				" a.dly_saction_id, a.dft_saction_id , a.fdft_amt3, "+
				" decode(a.opt_ip_dt1, '', '', substr(a.opt_ip_dt1, 1, 4) || '-' || substr(a.opt_ip_dt1, 5, 2) || '-'||substr(a.opt_ip_dt1, 7, 2)) opt_ip_dt1, a.opt_ip_amt1, a.opt_ip_bank1, a.opt_ip_bank_no1, "+
				" decode(a.opt_ip_dt2, '', '', substr(a.opt_ip_dt2, 1, 4) || '-' || substr(a.opt_ip_dt2, 5, 2) || '-'||substr(a.opt_ip_dt2, 7, 2)) opt_ip_dt2, a.opt_ip_amt2, a.opt_ip_bank2, a.opt_ip_bank_no2, "+
				" a.re_bank, a.re_acc_no, a.re_acc_nm,  a.dft_saction_dt, a.tax_reg_gu, a.tot_dist, a.cms_chk , a.ext_st , a.r_tax_dt, " +
				" a.sb_saction_id, a.sb_saction_dt , a.opt_s_amt, a.opt_v_amt , a.dft_cost_id ,  a.serv_st , " +
				" a.over_amt, a.over_amt_1 , a.match, a.ext_saction_id, a.ext_reason  , a.over_amt_s , a.over_amt_v , a.serv_gubun,  a.cls_eff_amt "+
				" from cls_etc a, cont c ,  (select RENT_L_CD, max(ext_pay_dt) PAY_DT from scd_ext where ext_st = '4' group by rent_l_cd) b "+
				" where a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd and  a.RENT_L_CD=b.RENT_L_CD(+) and c.car_mng_id = ? ";
						
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
		
	    	rs = pstmt.executeQuery();	 
	    	
  
	    	
			while(rs.next())
			{
				cls.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				cls.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				cls.setCls_st(rs.getString("CLS_ST")==null?"":rs.getString("CLS_ST"));	   
				cls.setCls_st_r(rs.getString("CLS_ST_R")==null?"":rs.getString("CLS_ST_R"));	      
				cls.setTerm_yn(rs.getString("TERM_YN")==null?"":rs.getString("TERM_YN"));	
				cls.setCls_dt(rs.getString("CLS_DT")==null?"":rs.getString("CLS_DT"));	
				cls.setReg_id(rs.getString("REG_ID")==null?"":rs.getString("REG_ID"));	
				cls.setCls_cau(rs.getString("CLS_CAU")==null?"":rs.getString("CLS_CAU"));	

				cls.setIfee_s_amt(rs.getInt("IFEE_S_AMT"));
				cls.setIfee_v_amt(rs.getInt("IFEE_V_AMT"));
				cls.setIfee_etc(rs.getString("IFEE_ETC")==null?"":rs.getString("IFEE_ETC"));	
				cls.setPp_s_amt(rs.getInt("PP_S_AMT"));
				cls.setPp_v_amt(rs.getInt("PP_V_AMT"));
				cls.setPp_etc(rs.getString("PP_ETC")==null?"":rs.getString("PP_ETC"));	
				cls.setPded_s_amt(rs.getInt("PDED_S_AMT"));
				cls.setPded_v_amt(rs.getInt("PDED_V_AMT"));
				cls.setPded_etc(rs.getString("PDED_ETC")==null?"":rs.getString("PDED_ETC"));	
				cls.setTpded_s_amt(rs.getInt("TPDED_S_AMT"));
				cls.setTpded_v_amt(rs.getInt("TPDED_V_AMT"));
				cls.setTpded_etc(rs.getString("TPDED_ETC")==null?"":rs.getString("TPDED_ETC"));
				cls.setRfee_s_amt(rs.getInt("RFEE_S_AMT"));
				cls.setRfee_v_amt(rs.getInt("RFEE_V_AMT"));
				cls.setRfee_etc(rs.getString("RFEE_ETC")==null?"":rs.getString("RFEE_ETC"));	
				cls.setDfee_tm(rs.getString("DFEE_TM")==null?"":rs.getString("DFEE_TM"));				
				cls.setDfee_v_amt(rs.getInt("DFEE_V_AMT"));
				cls.setNfee_tm(rs.getString("NFEE_TM")==null?"":rs.getString("NFEE_TM"));	
				cls.setNfee_s_amt(rs.getInt("NFEE_S_AMT"));
				cls.setNfee_v_amt(rs.getInt("NFEE_V_AMT"));
				cls.setNfee_mon(rs.getString("NFEE_MON")==null?"":rs.getString("NFEE_MON"));
				cls.setNfee_day(rs.getString("NFEE_DAY")==null?"":rs.getString("NFEE_DAY"));
				cls.setNfee_amt(rs.getInt("NFEE_AMT"));
				cls.setTfee_amt(rs.getInt("TFEE_AMT"));
				cls.setMfee_amt(rs.getInt("MFEE_AMT"));
				cls.setRcon_mon(rs.getString("RCON_MON")==null?"":rs.getString("RCON_MON"));
				cls.setRcon_day(rs.getString("RCON_DAY")==null?"":rs.getString("RCON_DAY"));
				cls.setTrfee_amt(rs.getInt("TRFEE_AMT"));
				cls.setDft_int(rs.getString("DFT_INT")==null?"":rs.getString("DFT_INT"));	
				cls.setDft_amt(rs.getInt("DFT_AMT"));
				cls.setNo_dft_yn(rs.getString("NO_DFT_YN")==null?"":rs.getString("NO_DFT_YN"));
				cls.setNo_dft_cau(rs.getString("NO_DFT_CAU")==null?"":rs.getString("NO_DFT_CAU"));
				cls.setFdft_amt1(rs.getInt("FDFT_AMT1"));
				cls.setFdft_dc_amt(rs.getInt("FDFT_DC_AMT"));
				cls.setFdft_amt2(rs.getInt("FDFT_AMT2"));
				cls.setPay_dt(rs.getString("PAY_DT")==null?"":rs.getString("PAY_DT"));
				
				cls.setNfee_days(rs.getString("NFEE_DAYS")==null?"":rs.getString("NFEE_DAYS"));
				cls.setRcon_days(rs.getString("RCON_DAYS")==null?"":rs.getString("RCON_DAYS"));
				cls.setCls_est_dt(rs.getString("CLS_EST_DT")==null?"":rs.getString("CLS_EST_DT"));
				cls.setExt_dt(rs.getString("ext_dt")==null?"":rs.getString("ext_dt"));
				cls.setExt_id(rs.getString("ext_id")==null?"":rs.getString("ext_id"));
				cls.setVat_st(rs.getString("vat_st")==null?"":rs.getString("vat_st"));
				cls.setGrt_amt(rs.getInt("grt_amt"));
			
				cls.setOpt_per(rs.getString("opt_per")==null?"":rs.getString("opt_per"));
				cls.setOpt_amt(rs.getInt("opt_amt"));
				cls.setOpt_dt(rs.getString("opt_dt")==null?"":rs.getString("opt_dt"));
				cls.setOpt_mng(rs.getString("opt_mng")==null?"":rs.getString("opt_mng"));
												
				cls.setDly_amt(rs.getInt("dly_amt"));
				cls.setNo_v_amt(rs.getInt("no_v_amt"));
				cls.setCar_ja_amt(rs.getInt("car_ja_amt"));
				cls.setFine_amt(rs.getInt("fine_amt"));
				cls.setEtc_amt(rs.getInt("etc_amt"));
				cls.setEtc2_amt(rs.getInt("etc2_amt"));
				cls.setEtc3_amt(rs.getInt("etc3_amt"));
				cls.setEtc4_amt(rs.getInt("etc4_amt"));
				cls.setR_mon(rs.getString("r_mon")==null?"":rs.getString("r_mon"));
				cls.setR_day(rs.getString("r_day")==null?"":rs.getString("r_day"));
				cls.setCls_s_amt(rs.getInt("cls_s_amt"));
				cls.setCls_v_amt(rs.getInt("cls_v_amt"));
				cls.setEx_di_amt(rs.getInt("ex_di_amt"));
				cls.setIfee_mon(rs.getString("ifee_mon")==null?"":rs.getString("ifee_mon"));
				cls.setIfee_day(rs.getString("ifee_day")==null?"":rs.getString("ifee_day"));
				cls.setIfee_ex_amt(rs.getInt("ifee_ex_amt"));
				cls.setRifee_s_amt(rs.getInt("rifee_s_amt"));
				cls.setCancel_yn(rs.getString("cancel_yn")==null?"":rs.getString("cancel_yn"));
											
				cls.setFdft_amt1_1(rs.getInt("FDFT_AMT1_1"));
				cls.setEx_di_amt_1(rs.getInt("ex_di_amt_1"));
				cls.setDly_amt_1(rs.getInt("dly_amt_1"));
				cls.setNo_v_amt_1(rs.getInt("no_v_amt_1"));
				cls.setCar_ja_amt_1(rs.getInt("car_ja_amt_1"));
				cls.setEtc_amt_1(rs.getInt("etc_amt_1"));
				cls.setFine_amt_1(rs.getInt("fine_amt_1"));
				cls.setEtc2_amt_1(rs.getInt("etc2_amt_1"));
				cls.setEtc3_amt_1(rs.getInt("etc3_amt_1"));
				cls.setEtc4_amt_1(rs.getInt("etc4_amt_1"));
				cls.setNfee_amt_1(rs.getInt("nfee_amt_1"));	
				cls.setDfee_amt_1(rs.getInt("dfee_amt_1"));		
				cls.setDft_amt_1(rs.getInt("DFT_AMT_1"));	
				cls.setDiv_st(rs.getString("div_st")==null?"":rs.getString("div_st"));		
				cls.setDiv_cnt(rs.getInt("div_cnt"));		
				cls.setEst_dt(rs.getString("est_dt")==null?"":rs.getString("est_dt"));		
				cls.setEst_amt(rs.getInt("est_amt"));	
				cls.setEst_nm(rs.getString("est_nm")==null?"":rs.getString("est_nm"));		
				cls.setGur_nm(rs.getString("gur_nm")==null?"":rs.getString("gur_nm"));		
				cls.setGur_rel_tel(rs.getString("gur_rel_tel")==null?"":rs.getString("gur_rel_tel"));		
				cls.setGur_rel(rs.getString("gur_rel")==null?"":rs.getString("gur_rel"));		
				cls.setRemark(rs.getString("remark")==null?"":rs.getString("remark"));		
							
				cls.setD_reason(rs.getString("d_reason")==null?"":rs.getString("d_reason"));	
				cls.setD_saction_id(rs.getString("d_saction_id")==null?"":rs.getString("d_saction_id"));		
			
				cls.setDfee_amt(rs.getInt("dfee_amt"));
				
				cls.setTax_chk0(rs.getString("tax_chk0")==null?"":rs.getString("tax_chk0"));	
				cls.setTax_chk1(rs.getString("tax_chk1")==null?"":rs.getString("tax_chk1"));
				cls.setTax_chk2(rs.getString("tax_chk2")==null?"":rs.getString("tax_chk2"));
				cls.setTax_chk3(rs.getString("tax_chk3")==null?"":rs.getString("tax_chk3"));
				cls.setTax_chk4(rs.getString("tax_chk4")==null?"":rs.getString("tax_chk4"));
				cls.setTax_chk5(rs.getString("tax_chk5")==null?"":rs.getString("tax_chk5"));
				cls.setTax_chk6(rs.getString("tax_chk6")==null?"":rs.getString("tax_chk6"));
			
				cls.setDft_amt_s(rs.getInt("dft_amt_s"));
				cls.setEtc_amt_s(rs.getInt("etc_amt_s"));
				cls.setEtc2_amt_s(rs.getInt("etc2_amt_s"));
				cls.setEtc4_amt_s(rs.getInt("etc4_amt_s"));
				cls.setDft_amt_v(rs.getInt("dft_amt_v"));
				cls.setEtc_amt_v(rs.getInt("etc_amt_v"));
				cls.setEtc2_amt_v(rs.getInt("etc2_amt_v"));
				cls.setEtc4_amt_v(rs.getInt("etc4_amt_v"));
				cls.setCar_ja_no_amt(rs.getInt("car_ja_no_amt"));
				cls.setAutodoc_yn(rs.getString("autodoc_yn")==null?"N":rs.getString("autodoc_yn"));
				
				cls.setDly_reason(rs.getString("dly_reason")==null?"":rs.getString("dly_reason"));
				cls.setDft_reason(rs.getString("dft_reason")==null?"":rs.getString("dft_reason"));
				cls.setDft_int_1(rs.getString("DFT_INT_1")==null?"":rs.getString("DFT_INT_1"));	
				
			/*	cls.setSui_st(rs.getString("SUI_ST")==null?"N":rs.getString("SUI_ST"));	
				cls.setSui_d1_amt(rs.getInt("sui_d1_amt"));
				cls.setSui_d2_amt(rs.getInt("sui_d2_amt"));
				cls.setSui_d3_amt(rs.getInt("sui_d3_amt"));
				cls.setSui_d4_amt(rs.getInt("sui_d4_amt"));
				cls.setSui_d5_amt(rs.getInt("sui_d5_amt"));
				cls.setSui_d6_amt(rs.getInt("sui_d6_amt"));
				cls.setSui_d7_amt(rs.getInt("sui_d7_amt"));
				cls.setSui_d8_amt(rs.getInt("sui_d8_amt"));
				cls.setSui_d_amt(rs.getInt("sui_d_amt")); */
				
				cls.setDly_saction_id(rs.getString("dly_saction_id")==null?"":rs.getString("dly_saction_id"));		
				cls.setDft_saction_id(rs.getString("dft_saction_id")==null?"":rs.getString("dft_saction_id"));		
				cls.setFdft_amt3(rs.getInt("fdft_amt3"));	
				
				cls.setOpt_ip_dt1(rs.getString("opt_ip_dt1")==null?"":rs.getString("opt_ip_dt1"));	
				cls.setOpt_ip_amt1(rs.getInt("opt_ip_amt1"));	
				cls.setOpt_ip_bank1(rs.getString("opt_ip_bank1")==null?"":rs.getString("opt_ip_bank1"));		
				cls.setOpt_ip_bank_no1(rs.getString("opt_ip_bank_no1")==null?"":rs.getString("opt_ip_bank_no1"));		
				
				cls.setOpt_ip_dt2(rs.getString("opt_ip_dt2")==null?"":rs.getString("opt_ip_dt2"));	
				cls.setOpt_ip_amt2(rs.getInt("opt_ip_amt2"));	
				cls.setOpt_ip_bank2(rs.getString("opt_ip_bank2")==null?"":rs.getString("opt_ip_bank2"));		
				cls.setOpt_ip_bank_no2(rs.getString("opt_ip_bank_no2")==null?"":rs.getString("opt_ip_bank_no2"));	
				
				cls.setRe_bank(rs.getString("re_bank")==null?"":rs.getString("re_bank"));	
				cls.setRe_acc_no(rs.getString("re_acc_no")==null?"":rs.getString("re_acc_no"));	
				cls.setRe_acc_nm(rs.getString("re_acc_nm")==null?"":rs.getString("re_acc_nm"));		
				
				cls.setDft_saction_dt(rs.getString("dft_saction_dt")==null?"":rs.getString("dft_saction_dt"));		
				cls.setTax_reg_gu(rs.getString("TAX_REG_GU")==null?"N":rs.getString("TAX_REG_GU"));	
				cls.setTot_dist(rs.getInt("tot_dist"));	
				cls.setCms_chk(rs.getString("cms_chk")==null?"N":rs.getString("cms_chk"));	
				cls.setExt_st(rs.getString("ext_st")==null?"":rs.getString("ext_st"));	
				cls.setR_tax_dt(rs.getString("r_tax_dt")==null?"":rs.getString("r_tax_dt"));	
				
				cls.setSb_saction_id(rs.getString("sb_saction_id")==null?"":rs.getString("sb_saction_id"));	
				cls.setSb_saction_dt(rs.getString("sb_saction_dt")==null?"":rs.getString("sb_saction_dt"));	
											
				cls.setOpt_s_amt(rs.getInt("opt_s_amt"));
				cls.setOpt_v_amt(rs.getInt("opt_v_amt"));
				
				cls.setDft_cost_id(rs.getString("dft_cost_id")==null?"":rs.getString("dft_cost_id"));	
							
				cls.setServ_st(rs.getString("serv_st")==null?"":rs.getString("serv_st"));	
				
				cls.setOver_amt(rs.getInt("over_amt"));
				cls.setOver_amt_1(rs.getInt("over_amt_1"));
				cls.setOver_amt_s(rs.getInt("over_amt_s"));
				cls.setOver_amt_v(rs.getInt("over_amt_v"));
				
				cls.setMatch(rs.getString("match")==null?"":rs.getString("match"));	
				
				cls.setExt_reason(rs.getString("ext_reason")==null?"":rs.getString("ext_reason"));	
				cls.setExt_saction_id(rs.getString("ext_saction_id")==null?"":rs.getString("ext_saction_id"));		
				
				cls.setServ_gubun(rs.getString("serv_gubun")==null?"":rs.getString("serv_gubun"));		
				
				cls.setCls_eff_amt(rs.getInt("cls_eff_amt"));
			
			}
		} catch (SQLException e) {
			System.out.println("[AccuDatabase:getClsEtcCase]\n"+e);			
			System.out.println(query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return cls;
		}
	} 
	
		
	/*해지의뢰 수정페이지 조회  : 차량회수정보  rent_mng_id, rent_l_cd  */
	public CarRecoBean getCarReco(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		CarRecoBean carReco = new CarRecoBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		query = " select "+
				" a.RENT_MNG_ID, a.RENT_L_CD, a.RECO_ID, a.reco_st, "+
				" decode(a.reco_d1_st, '1','정상회수',  '2' , '강제회수', '3', '협의회수') RECO_D1_ST, "+
				" decode(a.reco_d2_st, '1','도난', '2', '횡령', '3', '멸실') RECO_D2_ST, "+
				" decode(a.RECO_DT, '', '', substr(a.RECO_DT, 1, 4) || '-' || substr(a.RECO_DT, 5, 2) || '-'||substr(a.RECO_DT, 7, 2)) RECO_DT, "+
				" decode(a.IP_DT, '', '', substr(a.IP_DT, 1, 4) || '-' || substr(a.IP_DT, 5, 2) || '-'||substr(a.IP_DT, 7, 2)) IP_DT, "+
				" a.ETC2_D1_AMT, decode(a.ETC2_D1_DT, '', '', substr(a.ETC2_D1_DT, 1, 4) || '-' || substr(a.ETC2_D1_DT, 5, 2) || '-'||substr(a.ETC2_D1_DT, 7, 2)) ETC2_D1_DT, "+
				" a.ETC_D1_AMT,  decode(a.ETC_D1_DT, '', '', substr(a.ETC_D1_DT, 1, 4) || '-' || substr(a.ETC_D1_DT, 5, 2) || '-'||substr(a.ETC_D1_DT, 7, 2)) ETC_D1_DT , a.park PARK, a.park_cont PARK_CONT "+
				" from car_reco a where  a.RENT_MNG_ID = ? and a.RENT_L_CD = ? ";

//System.out.println("[AccuDatabase:getCarReco]\n"+query);
						
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
	    	rs = pstmt.executeQuery();
	    	        	
			while(rs.next())
			{
				
				carReco.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				carReco.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				carReco.setReco_id(rs.getString("RECO_ID")==null?"":rs.getString("RECO_ID"));
				carReco.setReco_st(rs.getString("RECO_ST")==null?"":rs.getString("RECO_ST"));	
				carReco.setReco_d1_st(rs.getString("RECO_D1_ST")==null?"":rs.getString("RECO_D1_ST"));	
				carReco.setReco_d2_st(rs.getString("RECO_D2_ST")==null?"":rs.getString("RECO_D2_ST"));	
				carReco.setReco_dt(rs.getString("RECO_DT")==null?"":rs.getString("RECO_DT"));								
				carReco.setIp_dt(rs.getString("IP_DT")==null?"":rs.getString("IP_DT"));	
				carReco.setEtc2_d1_amt(rs.getInt("ETC2_D1_AMT"));
				carReco.setEtc2_d1_dt(rs.getString("ETC2_D1_DT")==null?"":rs.getString("ETC2_D1_DT"));	
				carReco.setEtc_d1_amt(rs.getInt("ETC_D1_AMT"));
				carReco.setEtc_d1_dt(rs.getString("ETC_D1_DT")==null?"":rs.getString("ETC_D1_DT"));	
				carReco.setPark(rs.getString("PARK")==null?"":rs.getString("PARK"));	
				carReco.setPark_cont(rs.getString("PARK_CONT")==null?"":rs.getString("PARK_CONT"));		 
			
			}
		} catch (SQLException e) {
			System.out.println("[AccuDatabase:getCarReco]\n"+e);			
			System.out.println("[AccuDatabase:getCarReco]\n"+query);			
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return carReco;
		}
	}
	    
	
	/*해지의뢰 수정페이지 조회  : 차량채권정보  rent_mng_id, rent_l_cd  */
	public CarCreditBean getCarCredit(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		CarCreditBean carCre = new CarCreditBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		
		query = " select "+
				" a.RENT_MNG_ID, a.RENT_L_CD,  "+ 
				" a.gi_amt, a.gi_c_amt, a.gi_j_amt,  a.c_ins, a.c_ins_d_nm, a.c_ins_tel, "+
				" a.crd_reg_gu1, a.crd_reg_gu2, a.crd_reg_gu3,  a.crd_reg_gu4, a.crd_reg_gu5, a.crd_reg_gu6, "+
				" a.crd_remark1, a.crd_remark2, a.crd_remark3,  a.crd_remark4, a.crd_remark5, a.crd_remark6, "+
				" a.crd_req_gu1, a.crd_req_gu2, a.crd_req_gu3,  a.crd_req_gu4, a.crd_req_gu5, a.crd_req_gu6, "+
				" a.crd_pri1, a.crd_pri2, a.crd_pri3,  a.crd_pri4, a.crd_pri5, a.crd_pri6, "+
				" a.crd_id, crd_reason , a.guar_st "+
				" from car_credit a where  a.RENT_MNG_ID = ? and a.RENT_L_CD = ? ";
						
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
	    	rs = pstmt.executeQuery();
	    
	        	
			while(rs.next())
			{ 
				carCre.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				carCre.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				 
				carCre.setGi_amt(rs.getInt("gi_amt"));
				
				carCre.setGi_c_amt(rs.getInt("gi_c_amt"));
				carCre.setGi_j_amt(rs.getInt("gi_j_amt"));
				carCre.setC_ins(rs.getString("c_ins")==null?"":rs.getString("c_ins"));
				carCre.setC_ins_d_nm(rs.getString("c_ins_d_nm")==null?"":rs.getString("c_ins_d_nm"));	
				carCre.setC_ins_tel(rs.getString("c_ins_tel")==null?"":rs.getString("c_ins_tel"));	
				carCre.setCrd_reg_gu1(rs.getString("crd_reg_gu1")==null?"":rs.getString("crd_reg_gu1"));	
				carCre.setCrd_reg_gu2(rs.getString("crd_reg_gu2")==null?"":rs.getString("crd_reg_gu2"));	
				carCre.setCrd_reg_gu3(rs.getString("crd_reg_gu3")==null?"":rs.getString("crd_reg_gu3"));	
				carCre.setCrd_reg_gu4(rs.getString("crd_reg_gu4")==null?"":rs.getString("crd_reg_gu4"));	
				carCre.setCrd_reg_gu5(rs.getString("crd_reg_gu5")==null?"":rs.getString("crd_reg_gu5"));	
				carCre.setCrd_reg_gu6(rs.getString("crd_reg_gu6")==null?"":rs.getString("crd_reg_gu6"));	
				carCre.setCrd_remark1(rs.getString("crd_remark1")==null?"":rs.getString("crd_remark1"));	
				carCre.setCrd_remark2(rs.getString("crd_remark2")==null?"":rs.getString("crd_remark2"));	
				carCre.setCrd_remark3(rs.getString("crd_remark3")==null?"":rs.getString("crd_remark3"));	
				carCre.setCrd_remark4(rs.getString("crd_remark4")==null?"":rs.getString("crd_remark4"));	
				carCre.setCrd_remark5(rs.getString("crd_remark5")==null?"":rs.getString("crd_remark5"));	
				carCre.setCrd_remark6(rs.getString("crd_remark6")==null?"":rs.getString("crd_remark6"));
				carCre.setCrd_req_gu1(rs.getString("crd_req_gu1")==null?"":rs.getString("crd_req_gu1"));	
				carCre.setCrd_req_gu2(rs.getString("crd_req_gu2")==null?"":rs.getString("crd_req_gu2"));	
				carCre.setCrd_req_gu3(rs.getString("crd_req_gu3")==null?"":rs.getString("crd_req_gu3"));	
				carCre.setCrd_req_gu4(rs.getString("crd_req_gu4")==null?"":rs.getString("crd_req_gu4"));	
				carCre.setCrd_req_gu5(rs.getString("crd_req_gu5")==null?"":rs.getString("crd_req_gu5"));	
				carCre.setCrd_req_gu6(rs.getString("crd_req_gu6")==null?"":rs.getString("crd_req_gu6"));	
				carCre.setCrd_pri1(rs.getString("crd_pri1")==null?"":rs.getString("crd_pri1"));	
				carCre.setCrd_pri2(rs.getString("crd_pri2")==null?"":rs.getString("crd_pri2"));	
				carCre.setCrd_pri3(rs.getString("crd_pri3")==null?"":rs.getString("crd_pri3"));	
				carCre.setCrd_pri4(rs.getString("crd_pri4")==null?"":rs.getString("crd_pri4"));	
				carCre.setCrd_pri5(rs.getString("crd_pri5")==null?"":rs.getString("crd_pri5"));	
				carCre.setCrd_pri6(rs.getString("crd_pri6")==null?"":rs.getString("crd_pri6"));
			
				carCre.setCrd_id(rs.getString("crd_id")==null?"":rs.getString("crd_id"));
				carCre.setCrd_reason(rs.getString("crd_reason")==null?"":rs.getString("crd_reason"));	 
				
				carCre.setGuar_st(rs.getString("guar_st")==null?"":rs.getString("guar_st"));	 
	
			}
		} catch (SQLException e) {
			System.out.println("[AccuDatabase:getCarCredit]\n"+e);	
			System.out.println(query);		
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return carCre;
		}
	}
	
			
	/*해지의뢰 수정페이지 조회  : 선수금정산정보  rent_mng_id, rent_l_cd  */
	public ClsContEtcBean getClsContEtc(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		ClsContEtcBean cct = new ClsContEtcBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		query = " select "+
				" a.RENT_MNG_ID, a.RENT_L_CD,  a.jung_st, "+						
				" a.h1_amt, a.h2_amt, a.h3_amt, a.h4_amt, a.h5_amt, a.h6_amt, a.h7_amt ,"+
				" a.h_st, a.h_ip_dt ,  a.pay_st , a.suc_gubun, a.suc_l_cd, a.delay_st, a.delay_type, a.delay_desc , a.refund_st , a.r_date "+
				" from cls_cont_etc a where  a.RENT_MNG_ID = ? and a.RENT_L_CD = ? ";

//System.out.println("[AccuDatabase:getClsContEtc]\n"+query);
						
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
	    	rs = pstmt.executeQuery();
	    	        	
			while(rs.next())
			{
				
				cct.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				cct.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));			
				cct.setJung_st(rs.getString("JUNG_ST")==null?"":rs.getString("JUNG_ST"));	
						
				cct.setH1_amt(rs.getInt("H1_AMT"));
				cct.setH2_amt(rs.getInt("H2_AMT"));
				cct.setH3_amt(rs.getInt("H3_AMT"));
				cct.setH4_amt(rs.getInt("H4_AMT"));
				cct.setH5_amt(rs.getInt("H5_AMT"));
				cct.setH6_amt(rs.getInt("H6_AMT"));
				cct.setH7_amt(rs.getInt("H7_AMT"));
				cct.setH_st(rs.getString("H_ST")==null?"":rs.getString("H_ST"));		
				cct.setH_ip_dt(rs.getString("H_IP_DT")==null?"":rs.getString("H_IP_DT"));
				cct.setPay_st(rs.getString("PAY_ST")==null?"":rs.getString("PAY_ST"));		
				
				cct.setSuc_gubun(rs.getString("suc_gubun")==null?"":rs.getString("suc_gubun"));		
				cct.setSuc_l_cd(rs.getString("suc_l_cd")==null?"":rs.getString("suc_l_cd"));		
				cct.setRefund_st(rs.getString("refund_st")==null?"":rs.getString("refund_st"));
				cct.setDelay_st(rs.getString("delay_st")==null?"":rs.getString("delay_st"));		
				cct.setDelay_type(rs.getString("delay_type")==null?"":rs.getString("delay_type"));		
				cct.setDelay_desc(rs.getString("delay_desc")==null?"":rs.getString("delay_desc"));		
				cct.setR_date(rs.getString("r_date")==null?"":rs.getString("r_date"));		
			
			}
		} catch (SQLException e) {
			System.out.println("[AccuDatabase:getClsContEtc]\n"+e);			
			System.out.println("[AccuDatabase:getClsContEtc]\n"+query);			
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return cct;
		}
	}
	
	
	/*해지의뢰 수정페이지 조회  : 해지정산 more   rent_mng_id, rent_l_cd  */
	public ClsEtcMoreBean getClsEtcMore(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		ClsEtcMoreBean clsm = new ClsEtcMoreBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
			
		query = " select "+
				" a.RENT_MNG_ID, a.RENT_L_CD,  "+ 
				" a.re_file_name, a.etc4_file_name, a.remark_file_name,  "+
				" decode(a.ex_ip_dt, '', '', substr(a.ex_ip_dt, 1, 4) || '-' || substr(a.ex_ip_dt, 5, 2) || '-'||substr(a.ex_ip_dt, 7, 2)) ex_ip_dt, a.ex_ip_amt, a.ex_ip_bank, a.ex_ip_bank_no, "+
				" a.des_zip, a.des_addr, a.des_nm,  a.cms_after , a.m_dae_amt, a.ext_amt , a.status , a.des_tel , a.cms_amt , a.e_serv_amt , a.e_serv_rem , "+
				" s.conj_dt , s.est_dt ,  \n"+
				" a.sui_st, a.sui_d1_amt, a.sui_d2_amt, a.sui_d3_amt,a.sui_d4_amt,a.sui_d5_amt,a.sui_d6_amt,a.sui_d7_amt,a.sui_d8_amt, a.sui_d_amt , \n"+
				" a.match_l_cd  " + 
				" from cls_etc_more a , cont b , sui_etc s  where  a.RENT_MNG_ID = ? and a.RENT_L_CD = ?  \n"+
				"  and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd  and b.car_mng_id = s.car_mng_id(+)  \n"+
				"";
						
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
	    	rs = pstmt.executeQuery();
	        	
			while(rs.next())
			{ 
				clsm.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				clsm.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));					
			
				clsm.setRe_file_name(rs.getString("re_file_name")==null?"":rs.getString("re_file_name"));	
				clsm.setEtc4_file_name(rs.getString("etc4_file_name")==null?"":rs.getString("etc4_file_name"));	
				clsm.setRemark_file_name(rs.getString("remark_file_name")==null?"":rs.getString("remark_file_name"));	
				clsm.setEx_ip_dt(rs.getString("ex_ip_dt")==null?"":rs.getString("ex_ip_dt"));	
				clsm.setEx_ip_amt(rs.getInt("ex_ip_amt"));
				clsm.setEx_ip_bank(rs.getString("ex_ip_bank")==null?"":rs.getString("ex_ip_bank"));	
				clsm.setEx_ip_bank_no(rs.getString("ex_ip_bank_no")==null?"":rs.getString("ex_ip_bank_no"));	
				clsm.setDes_zip(rs.getString("des_zip")==null?"":rs.getString("des_zip"));	
				clsm.setDes_addr(rs.getString("des_addr")==null?"":rs.getString("des_addr"));	
				clsm.setDes_nm(rs.getString("des_nm")==null?"":rs.getString("des_nm"));	
				clsm.setCms_after(rs.getString("cms_after")==null?"":rs.getString("cms_after"));	
				clsm.setM_dae_amt(rs.getInt("m_dae_amt"));
				clsm.setExt_amt(rs.getInt("ext_amt"));
				clsm.setStatus(rs.getString("status")==null?"":rs.getString("status"));	
				clsm.setDes_tel(rs.getString("des_tel")==null?"":rs.getString("des_tel"));	
				clsm.setCms_amt(rs.getInt("cms_amt"));
				clsm.setE_serv_rem(rs.getString("e_serv_rem")==null?"":rs.getString("e_serv_rem"));	
				clsm.setE_serv_amt(rs.getInt("e_serv_amt"));
				clsm.setConj_dt(rs.getString("conj_dt")==null?"":rs.getString("conj_dt"));	 //매입옵션 서류 수령일
				clsm.setEst_dt(rs.getString("est_dt")==null?"":rs.getString("est_dt"));	  //매입옵션 서류 발송일 
				
				clsm.setSui_st(rs.getString("sui_st")==null?"N":rs.getString("sui_st"));	//매입옵션 이전관련 
				clsm.setSui_d1_amt(rs.getInt("sui_d1_amt"));
				clsm.setSui_d2_amt(rs.getInt("sui_d2_amt"));
				clsm.setSui_d3_amt(rs.getInt("sui_d3_amt"));
				clsm.setSui_d4_amt(rs.getInt("sui_d4_amt"));
				clsm.setSui_d5_amt(rs.getInt("sui_d5_amt"));
				clsm.setSui_d6_amt(rs.getInt("sui_d6_amt"));
				clsm.setSui_d7_amt(rs.getInt("sui_d7_amt"));
				clsm.setSui_d8_amt(rs.getInt("sui_d8_amt"));
				clsm.setSui_d_amt(rs.getInt("sui_d_amt"));
				
				clsm.setMatch_l_cd(rs.getString("match_l_cd")==null?"":rs.getString("match_l_cd"));	//만기매칭계약 
				
			}
		} catch (SQLException e) {
			System.out.println("[AccuDatabase:getClsEtcMore]\n"+e);	
			System.out.println(query);		
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return clsm;
		}
	}
	
	
	/**
	 *	해지의뢰 update
	 */
	
	public boolean updateClsEtc(ClsEtcBean cls)
	{
		getConnection();
		boolean flag = true;
		String query = " update cls_etc set "+
						" term_yn = ?, cls_dt = replace(?, '-', ''), upd_id = ?,  upd_dt = to_char(sysdate,'YYYYMMdd'), cls_cau = ?,"+  //5(4)
						" ifee_s_amt = ?, ifee_v_amt = ?, ifee_etc = ?, pp_s_amt = ?, pp_v_amt = ?, pp_etc = ?, "+  //6  --10
						" pded_s_amt = ?, pded_v_amt = ?, pded_etc = ?, tpded_s_amt = ?, tpded_v_amt = ?, tpded_etc = ?,"+  //6  --16
						" rfee_s_amt = ?, rfee_v_amt = ?, rfee_etc = ?, dfee_tm = ?,    dfee_v_amt = ?,"+  //5  --22
						" nfee_tm = ?,  nfee_s_amt = ?,  nfee_v_amt = ?, nfee_mon = ?, nfee_day = ?,   nfee_amt = ?,"+  //6  --28
						" tfee_amt = ?, mfee_amt = ?, rcon_mon = ?, rcon_day = ?, trfee_amt = ?, dft_int = ?, "+  //6  --34
						" dft_amt = ?, fdft_amt1 = ?, fdft_amt2 = ?, grt_amt = ?, opt_per = ?, opt_amt = ?, "+ //6  --40
						" dly_amt = ?, no_v_amt = ?, car_ja_amt = ?, r_mon = ?, r_day = ?, cls_s_amt = ?, cls_v_amt = ?,"+  //7   --47
						" etc_amt = ?, fine_amt = ?, ex_di_amt = ?, ifee_mon = ?, ifee_day = ?, ifee_ex_amt = ?, rifee_s_amt = ?, " + //7  --54
						" cancel_yn = ?, cls_st = ?, etc2_amt = ?, etc3_amt = ?, etc4_amt = ?, "+  //5   --59
						" fine_amt_1 = ?, car_ja_amt_1 = ?, dly_amt_1 = ?, etc_amt_1 = ?, etc2_amt_1 = ? , " +  //5  --64
						" dft_amt_1 = ?, ex_di_amt_1 = ?, nfee_amt_1 = ?, etc3_amt_1 = ?, etc4_amt_1 = ? , " +  //5  --69
						" no_v_amt_1 = ?, fdft_amt1_1 = ?, dfee_amt_1 = ?, DIV_ST = ?, DIV_CNT = ?, " +  //5   --74
						" EST_DT =replace(?, '-', ''), EST_AMT =? , EST_NM =? , GUR_NM =?, GUR_REL_TEL = ?, GUR_REL =?, REMARK =?, "+ //7  --81
						" tax_chk0 =?, tax_chk1 =?, tax_chk2 =?, tax_chk3 =?, tax_chk4 =?, tax_chk5 =?, tax_chk6 =? , car_ja_no_amt = ? , "+//7     --89
						" D_SACTION_ID =?, D_REASON =? , dly_reason = ?, dft_reason = ?, dft_int_1 = ?, "+//5
			//			" sui_st = ?, sui_d1_amt = ?, sui_d2_amt = ?, sui_d3_amt = ?, sui_d4_amt = ?, sui_d5_amt= ?, sui_d6_amt = ?, sui_d7_amt = ?, sui_d8_amt = ?, sui_d_amt = ?, "+//10
						" dly_saction_id = ?, dft_saction_id = ?, fdft_amt3 = ?, "+//3
						" re_bank = ?, re_acc_no = ?, re_acc_nm = ? , tot_dist = ? , cms_chk = ? , "+//5
						" dft_amt_s = ?, etc_amt_s  = ?,  etc2_amt_s = ?,  etc4_amt_s = ?, "+//4
						" dft_amt_v = ?, etc_amt_v  = ?,  etc2_amt_v = ?,  etc4_amt_v = ?, "+//4
						" dft_cost_id = ? ,  serv_st = ?,    "+//2
						" over_amt = ? ,  over_amt_1 = ?  , match = ? , ext_saction_id = ?,  ext_reason= ? ,  "+//5
						" over_amt_s = ?, over_amt_v  = ? ,  serv_gubun = ? ,"+//3
						" rifee_v_amt = ?,   dfee_v_amt_1 = ? , over_v_amt  = ? ,  over_v_amt_1 = ? "+//5
						" where rent_mng_id = ? and rent_l_cd = ? ";
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, cls.getTerm_yn());
			pstmt.setString(2, cls.getCls_dt());
			pstmt.setString(3, cls.getUpd_id());
			pstmt.setString(4, cls.getCls_cau());      //4
		
			pstmt.setInt   (5, cls.getIfee_s_amt());
			pstmt.setInt   (6, cls.getIfee_v_amt());
			pstmt.setString(7, cls.getIfee_etc());
			pstmt.setInt   (8, cls.getPp_s_amt());
			pstmt.setInt   (9, cls.getPp_v_amt());
			pstmt.setString(10, cls.getPp_etc());     //6
			
			pstmt.setInt   (11, cls.getPded_s_amt());
			pstmt.setInt   (12, cls.getPded_v_amt());
			pstmt.setString(13, cls.getPded_etc());
			pstmt.setInt   (14, cls.getTpded_s_amt());
			pstmt.setInt   (15, cls.getTpded_v_amt());
			pstmt.setString(16, cls.getTpded_etc());    //6
						
			pstmt.setInt   (17, cls.getRfee_s_amt());
			pstmt.setInt   (18, cls.getRfee_v_amt());
			pstmt.setString(19, cls.getRfee_etc());
			pstmt.setString(20, cls.getDfee_tm());		
			pstmt.setInt   (21, cls.getDfee_v_amt());  //5
			
			pstmt.setString(22, cls.getNfee_tm());
			pstmt.setInt   (23, cls.getNfee_s_amt());
			pstmt.setInt   (24, cls.getNfee_v_amt());
			pstmt.setString(25, cls.getNfee_mon());
			pstmt.setString(26, cls.getNfee_day()); 
			pstmt.setInt   (27, cls.getNfee_amt()); //6
						
			pstmt.setInt   (28, cls.getTfee_amt());
			pstmt.setInt   (29, cls.getMfee_amt());
			pstmt.setString(30, cls.getRcon_mon());
			pstmt.setString(31, cls.getRcon_day());
			pstmt.setInt   (32, cls.getTrfee_amt());
			pstmt.setString(33, cls.getDft_int());   //6
			
			pstmt.setInt   (34, cls.getDft_amt());
			pstmt.setInt   (35, cls.getFdft_amt1());
			pstmt.setInt   (36, cls.getFdft_amt2());
			pstmt.setInt   (37, cls.getGrt_amt());
			pstmt.setString(38, cls.getOpt_per());
			pstmt.setInt   (39, cls.getOpt_amt());  //6
		
			pstmt.setInt   (40, cls.getDly_amt());
			pstmt.setInt   (41, cls.getNo_v_amt());
			pstmt.setInt   (42, cls.getCar_ja_amt());
			pstmt.setString(43, cls.getR_mon());
			pstmt.setString(44, cls.getR_day());
			pstmt.setInt   (45, cls.getCls_s_amt());
			pstmt.setInt   (46, cls.getCls_v_amt());  //7
						
			pstmt.setInt   (47, cls.getEtc_amt());
			pstmt.setInt   (48, cls.getFine_amt());
			pstmt.setInt   (49, cls.getEx_di_amt());
			pstmt.setString(50, cls.getIfee_mon());
			pstmt.setString(51, cls.getIfee_day());
			pstmt.setInt   (52, cls.getIfee_ex_amt());
			pstmt.setInt   (53, cls.getRifee_s_amt());  //7
			
			pstmt.setString(54, cls.getCancel_yn());
			pstmt.setString(55, cls.getCls_st());
			pstmt.setInt   (56, cls.getEtc2_amt());
			pstmt.setInt   (57, cls.getEtc3_amt());
			pstmt.setInt   (58, cls.getEtc4_amt());  //5
							
			pstmt.setInt   (59, cls.getFine_amt_1());
			pstmt.setInt   (60, cls.getCar_ja_amt_1());
			pstmt.setInt   (61, cls.getDly_amt_1());
			pstmt.setInt   (62, cls.getEtc_amt_1());
			pstmt.setInt   (63, cls.getEtc2_amt_1()); //5
			
			pstmt.setInt   (64, cls.getDft_amt_1());
			pstmt.setInt   (65, cls.getEx_di_amt_1());
			pstmt.setInt   (66, cls.getNfee_amt_1());
			pstmt.setInt   (67, cls.getEtc3_amt_1());
			pstmt.setInt   (68, cls.getEtc4_amt_1()); //5
			
			pstmt.setInt   (69, cls.getNo_v_amt_1());
			pstmt.setInt   (70, cls.getFdft_amt1_1());
			pstmt.setInt   (71, cls.getDfee_amt_1());  
			pstmt.setString(72, cls.getDiv_st());
			pstmt.setInt   (73, cls.getDiv_cnt()); //5
						
			pstmt.setString(74, cls.getEst_dt());
			pstmt.setInt   (75, cls.getEst_amt()); 
			pstmt.setString(76, cls.getEst_nm());
			pstmt.setString(77, cls.getGur_nm());
			pstmt.setString(78, cls.getGur_rel_tel());
			pstmt.setString(79, cls.getGur_rel());
			pstmt.setString(80, cls.getRemark());  //7		
			
			pstmt.setString(81, cls.getTax_chk0());  
			pstmt.setString(82, cls.getTax_chk1());  
			pstmt.setString(83, cls.getTax_chk2()); 
			pstmt.setString(84, cls.getTax_chk3());  
			pstmt.setString(85, cls.getTax_chk4());  
			pstmt.setString(86, cls.getTax_chk5());   	
			pstmt.setString(87, cls.getTax_chk6());  //7			
			pstmt.setInt   (88, cls.getCar_ja_no_amt()); 
												
			pstmt.setString(89, cls.getD_saction_id());
			pstmt.setString(90, cls.getD_reason());
			pstmt.setString(91, cls.getDly_reason());
			pstmt.setString(92, cls.getDft_reason());
			pstmt.setString(93, cls.getDft_int_1());
									
			pstmt.setString(94, cls.getDly_saction_id());
			pstmt.setString(95, cls.getDft_saction_id());	
			pstmt.setInt   (96, cls.getFdft_amt3()); 
			
			pstmt.setString(97, cls.getRe_bank());	
			pstmt.setString(98, cls.getRe_acc_no());
			pstmt.setString(99, cls.getRe_acc_nm());	
			pstmt.setInt   (100, cls.getTot_dist()); 
			pstmt.setString(101, cls.getCms_chk());
			
			pstmt.setInt   (102, cls.getDft_amt_s()); 
			pstmt.setInt   (103, cls.getEtc_amt_s()); 
			pstmt.setInt   (104, cls.getEtc2_amt_s()); 
			pstmt.setInt   (105, cls.getEtc4_amt_s()); 
			
			pstmt.setInt   (106, cls.getDft_amt_v()); 
			pstmt.setInt   (107, cls.getEtc_amt_v()); 
			pstmt.setInt   (108, cls.getEtc2_amt_v()); 
			pstmt.setInt   (109, cls.getEtc4_amt_v()); 
			
			pstmt.setString(110, cls.getDft_cost_id());		
			pstmt.setString(111, cls.getServ_st());  //예비차 활용
						
			pstmt.setInt   (112, cls.getOver_amt()); 
			pstmt.setInt   (113, cls.getOver_amt_1());   //초과운행 확정 
			pstmt.setString(114, cls.getMatch());  //만기매칭
			pstmt.setString(115, cls.getExt_saction_id());  //선수금 후불처리
			pstmt.setString(116, cls.getExt_reason());  //선수금 후불처리
			
			pstmt.setInt   (117, cls.getOver_amt_s()); 			
			pstmt.setInt   (118, cls.getOver_amt_v()); 			
			pstmt.setString(119, cls.getServ_gubun());  //예비차 이용형태 
			
			pstmt.setInt   (120, cls.getRifee_v_amt()); 			
			pstmt.setInt   (121, cls.getDfee_v_amt_1()); 
			pstmt.setInt   (122, cls.getOver_v_amt()); 			
			pstmt.setInt   (123, cls.getOver_v_amt_1()); 
								
			pstmt.setString(124, cls.getRent_mng_id());
			pstmt.setString(125, cls.getRent_l_cd());

			pstmt.executeUpdate();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AccuDatabase:updateClsEtc]\n"+e);			
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
	
	public boolean updateClsEtcTermDt(String user_id, String cls_dt, String rent_mng_id, String rent_l_cd) {
		getConnection();
		boolean flag = true;
		String query = " update cls_etc set "+
						" upd_id = ?,  upd_dt = to_char(sysdate,'YYYYMMdd'), "+
						" cls_dt = replace(?, '-', '') " +
						" where rent_mng_id = ? and rent_l_cd = ?";
		
		PreparedStatement pstmt = null;

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, user_id);
			pstmt.setString(2, cls_dt);
								
			pstmt.setString(3, rent_mng_id);
			pstmt.setString(4, rent_l_cd);

			pstmt.executeUpdate();

			conn.commit();
			
		} catch (Exception e) {
			System.out.println("[AccuDatabase:updateClsEtcTerm]\n"+e);			
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
			
	
	public boolean updateClsCmsAfter(String rent_mng_id, String rent_l_cd, String cms_after) {
		getConnection();
		boolean flag = true;
		String query = " update cls_etc_more set cms_after = ? " +
						" where rent_mng_id = ? and rent_l_cd = ?";
		
		PreparedStatement pstmt = null;

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, cms_after);			
			pstmt.setString(2, rent_mng_id);
			pstmt.setString(3, rent_l_cd);

			pstmt.executeUpdate();

			conn.commit();
			
		} catch (Exception e) {
			System.out.println("[AccuDatabase:updateClsCmsAfter]\n"+e);			
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
		
	public boolean updateClsDesInfo(String rent_mng_id, String rent_l_cd, String des_zip, String des_addr, String  des_nm, String des_tel ) {
		getConnection();
		boolean flag = true;
		String query = " update cls_etc_more set des_zip = ?, des_addr = ? , des_nm= ?, des_tel = ?  " +
						" where rent_mng_id = ? and rent_l_cd = ?";
		
		PreparedStatement pstmt = null;

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, des_zip);			
			pstmt.setString(2, des_addr);			
			pstmt.setString(3, des_nm);			
			pstmt.setString(4, des_tel);			
			pstmt.setString(5, rent_mng_id);
			pstmt.setString(6, rent_l_cd);

			pstmt.executeUpdate();

			conn.commit();
			
		} catch (Exception e) {
			System.out.println("[AccuDatabase:updateClsDesInfo]\n"+e);			
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
	
	public boolean updateClsEtcCau(ClsEtcBean cls)
	{
		getConnection();
		boolean flag = true;
		String query = " update cls_etc set "+
						" reg_id = ? , upd_id = ?,  upd_dt = to_char(sysdate,'YYYYMMdd'), cls_cau = ?, "+  //4(3)
						" d_saction_id = ? , d_reason = ?,  dly_saction_id = ?,  dly_reason = ? , dft_saction_id = ?,  dft_reason = ?, remark = ? ,"+  //7
						" re_bank = ?,  re_acc_no = ?, re_acc_nm = ? , cls_dt = replace(?, '-', ''), r_mon = ? , r_day = ? , tot_dist = ? , cms_chk = ? , " +
						"  cls_st = ? , dft_cost_id = ? , match= ?, ext_saction_id = ?, ext_reason = ?  "+  //5
						" where rent_mng_id = ? and rent_l_cd = ?";
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, cls.getReg_id());
			pstmt.setString(2, cls.getUpd_id());
			pstmt.setString(3, cls.getCls_cau());      //4
			pstmt.setString(4, cls.getD_saction_id());      //
			pstmt.setString(5, cls.getD_reason());      //4
			pstmt.setString(6, cls.getDly_saction_id());      //4
			pstmt.setString(7, cls.getDly_reason());      //4
			pstmt.setString(8, cls.getDft_saction_id());      //4
			pstmt.setString(9, cls.getDft_reason());      //4
			pstmt.setString(10, cls.getRemark());      //4
			
			pstmt.setString(11, cls.getRe_bank());      //4
			pstmt.setString(12, cls.getRe_acc_no());      //4
			pstmt.setString(13, cls.getRe_acc_nm());      //4
			
			pstmt.setString(14, cls.getCls_dt());      //4
			pstmt.setString(15, cls.getR_mon());      //4
			pstmt.setString(16, cls.getR_day());      //4
			pstmt.setInt(17, cls.getTot_dist());      //4
			pstmt.setString(18, cls.getCms_chk());      //4
			
			pstmt.setString(19, cls.getCls_st());      //4
			pstmt.setString(20, cls.getDft_cost_id());      //4	
			pstmt.setString(21, cls.getMatch());      //4
			pstmt.setString(22, cls.getExt_saction_id());      //4
			pstmt.setString(23, cls.getExt_reason());      //4
								
			pstmt.setString(24, cls.getRent_mng_id());
			pstmt.setString(25, cls.getRent_l_cd());

			pstmt.executeUpdate();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AccuDatabase:updateClsEtcCau]\n"+e);			
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
	
	public boolean updateClsEtcGet(ClsEtcBean cls)
	{
		getConnection();
		boolean flag = true;
		String query = " update cls_etc set "+
						" upd_id = ?,  upd_dt = to_char(sysdate,'YYYYMMdd'),"+  //2(1)
						" DIV_ST = ?, DIV_CNT = ?, EST_DT =replace(?, '-', ''), EST_AMT =? , EST_NM =? , GUR_NM =?, GUR_REL_TEL = ?, GUR_REL =?, REMARK = ? "+ //9  
						" where rent_mng_id = ? and rent_l_cd = ?";
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, cls.getUpd_id());
				
			pstmt.setString(2, cls.getDiv_st());
			pstmt.setInt   (3, cls.getDiv_cnt()); //5
			pstmt.setString(4, cls.getEst_dt());
			pstmt.setInt   (5, cls.getEst_amt()); 
			pstmt.setString(6, cls.getEst_nm());
			pstmt.setString(7, cls.getGur_nm());
			pstmt.setString(8, cls.getGur_rel_tel());
			pstmt.setString(9, cls.getGur_rel());
			pstmt.setString(10, cls.getRemark());  //7		
														
			pstmt.setString(11, cls.getRent_mng_id());
			pstmt.setString(12, cls.getRent_l_cd());

			pstmt.executeUpdate();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AccuDatabase:updateClsEtcGet]\n"+e);			
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
	
	public boolean updateClsEtcAsset(ClsEtcBean cls)
	{
		getConnection();
		boolean flag = true;
		String query = " update cls_etc set "+
						" upd_id = ?, upd_dt = to_char(sysdate,'YYYYMMdd'),  opt_per = ?, opt_amt = ? "+  //4(3)
				//		" sui_st = ?, sui_d1_amt = ?, sui_d2_amt = ?, sui_d3_amt = ?, sui_d4_amt = ?, "+//5
				//		" sui_d5_amt= ?, sui_d6_amt = ?, sui_d7_amt = ?, sui_d8_amt = ?, sui_d_amt = ? "+//5
						" where rent_mng_id = ? and rent_l_cd = ?";
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
		
			pstmt.setString(1, cls.getUpd_id());
			pstmt.setString(2, cls.getOpt_per());
			pstmt.setInt   (3, cls.getOpt_amt());  //3
		
			/*
			pstmt.setString(4, cls.getSui_st());
			pstmt.setInt   (5, cls.getSui_d1_amt()); 
			pstmt.setInt   (6, cls.getSui_d2_amt()); 
			pstmt.setInt   (7, cls.getSui_d3_amt()); 
			pstmt.setInt   (8, cls.getSui_d4_amt()); 
			
			pstmt.setInt   (9, cls.getSui_d5_amt()); 
			pstmt.setInt   (10, cls.getSui_d6_amt()); 
			pstmt.setInt   (11, cls.getSui_d7_amt()); 
			pstmt.setInt   (12, cls.getSui_d8_amt()); 
			pstmt.setInt   (13, cls.getSui_d_amt()); 
		*/
			
			pstmt.setString(4, cls.getRent_mng_id());
			pstmt.setString(5, cls.getRent_l_cd());

			pstmt.executeUpdate();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AccuDatabase:updateClsEtcAsset]\n"+e);			
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
	 *	해지 update
	*/
	 
	public boolean updateClsEtcSub(ClsEtcSubBean clss)
	{
		getConnection();
		boolean flag = true;
		String query = " update cls_etc_sub set "+
						" FINE_AMT_1 = ?, CAR_JA_AMT_1 = ?, DLY_AMT_1 = ?, ETC_AMT_1 = ?, ETC2_AMT_1 = ?, DFT_AMT_1 = ?, "+  //6
						" DFEE_AMT_1 = ?, ETC3_AMT_1 = ?, ETC4_AMT_1 = ?, NO_V_AMT_1 = ?, FDFT_AMT1_1 = ?, "+  //5
						" FINE_AMT_2 = ?, CAR_JA_AMT_2 = ?, DLY_AMT_2 = ?, ETC_AMT_2 = ?, ETC2_AMT_2 = ?, DFT_AMT_2 = ? ,"+ //6
						" DFEE_AMT_2 = ?, ETC3_AMT_2 = ?, ETC4_AMT_2 = ?, NO_V_AMT_2 = ?, FDFT_AMT1_2 = ?, " +  //5
						" FINE_AMT_3 = ?, CAR_JA_AMT_3 = ?, DLY_AMT_3 = ?, ETC_AMT_3 = ?, ETC2_AMT_3 = ?, DFT_AMT_3 = ? ,"+ //6
						" DFEE_AMT_3 = ?, ETC3_AMT_3 = ?, ETC4_AMT_3 = ?, NO_V_AMT_3 = ?, FDFT_AMT1_3 = ?, " +  //5
						" DFEE_AMT_2_V = ?, DFT_AMT_2_V = ?, ETC_AMT_2_V = ?, ETC2_AMT_2_V = ?, ETC4_AMT_2_V = ?, " +  //5
						" RIFEE_AMT_2_V = ?, RFEE_AMT_2_V = ?, " +  //5
						" upd_id = ? , upd_dt=to_char(sysdate,'YYYYMMdd') ,"+  //2(1)
						" OVER_AMT_1 = ?, OVER_AMT_2 = ? , OVER_AMT_3 = ?,  over_amt_2_v = ?   " +  //3
						" where rent_mng_id = ? and rent_l_cd = ? and cls_seq = ? ";  //3
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setInt   (1, clss.getFine_amt_1());
			pstmt.setInt   (2, clss.getCar_ja_amt_1());
			pstmt.setInt   (3, clss.getDly_amt_1());
			pstmt.setInt   (4, clss.getEtc_amt_1());
			pstmt.setInt   (5, clss.getEtc2_amt_1());
			pstmt.setInt   (6, clss.getDft_amt_1());     //6
			
			pstmt.setInt   (7, clss.getDfee_amt_1());
			pstmt.setInt   (8, clss.getEtc3_amt_1());
			pstmt.setInt   (9, clss.getEtc4_amt_1());
			pstmt.setInt   (10, clss.getNo_v_amt_1());
			pstmt.setInt   (11, clss.getFdft_amt1_1());    //5
						
			pstmt.setInt   (12, clss.getFine_amt_2());
			pstmt.setInt   (13, clss.getCar_ja_amt_2());
			pstmt.setInt   (14, clss.getDly_amt_2());
			pstmt.setInt   (15, clss.getEtc_amt_2());
			pstmt.setInt   (16, clss.getEtc2_amt_2());
			pstmt.setInt   (17, clss.getDft_amt_2());     //6
			
			pstmt.setInt   (18, clss.getDfee_amt_2());
			pstmt.setInt   (19, clss.getEtc3_amt_2());
			pstmt.setInt   (20, clss.getEtc4_amt_2());
			pstmt.setInt   (21, clss.getNo_v_amt_2());
			pstmt.setInt   (22, clss.getFdft_amt1_2());    //5
			
			
			pstmt.setInt   (23, clss.getFine_amt_3());
			pstmt.setInt   (24, clss.getCar_ja_amt_3());
			pstmt.setInt   (25, clss.getDly_amt_3());
			pstmt.setInt   (26, clss.getEtc_amt_3());
			pstmt.setInt   (27, clss.getEtc2_amt_3());
			pstmt.setInt   (28, clss.getDft_amt_3());     //6
			
			pstmt.setInt   (29, clss.getDfee_amt_3());
			pstmt.setInt   (30, clss.getEtc3_amt_3());
			pstmt.setInt   (31, clss.getEtc4_amt_3());
			pstmt.setInt   (32, clss.getNo_v_amt_3());
			pstmt.setInt   (33, clss.getFdft_amt1_3());  //5
			   
			pstmt.setInt   (34, clss.getDfee_amt_2_v());    
			pstmt.setInt   (35, clss.getDft_amt_2_v());    
			pstmt.setInt   (36, clss.getEtc_amt_2_v());    
			pstmt.setInt   (37, clss.getEtc2_amt_2_v());    
			pstmt.setInt   (38, clss.getEtc4_amt_2_v());   //5 
			
			pstmt.setInt   (39, clss.getRifee_amt_2_v());    
			pstmt.setInt   (40, clss.getRfee_amt_2_v());  //2    
				
			pstmt.setString(41, clss.getUpd_id());
			
			pstmt.setInt   (42, clss.getOver_amt_1());    
			pstmt.setInt   (43, clss.getOver_amt_2());    
			pstmt.setInt   (44, clss.getOver_amt_3());   	
			pstmt.setInt   (45, clss.getOver_amt_2_v());   	
								
			pstmt.setString(46, clss.getRent_mng_id());
			pstmt.setString(47, clss.getRent_l_cd());
			pstmt.setInt   (48, clss.getCls_seq());  //3
	
			pstmt.executeUpdate();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AccuDatabase:updateClsEtcSub]\n"+e);			
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
	
	//해지정산 기타 추가 
	public boolean updateClsEtcMore(ClsEtcMoreBean clsm)
	{
		getConnection();
		boolean flag = true;
		String query = " update cls_etc_more set "+
						" re_file_name = ?,  etc4_file_name = ?, remark_file_name = ? ,  "+  //3
						" ex_ip_dt = ?, ex_ip_amt = ?, ex_ip_bank =? , ex_ip_bank_no =? , des_zip =?, des_addr = ?, des_nm =?, cms_after = ? ,"+ //8  
						" m_dae_amt = ?, ext_amt = ? , status = ? , des_tel = ? , cms_amt = ? , e_serv_rem = ? , e_serv_amt = ? ," +
						" sui_st = ?, sui_d1_amt = ?, sui_d2_amt = ?, sui_d3_amt = ?, sui_d4_amt = ?, "+//5
						" sui_d5_amt= ?, sui_d6_amt = ?, sui_d7_amt = ?, sui_d8_amt = ?, sui_d_amt = ?, "+//5
						" match_l_cd = ? " + //1
						" where rent_mng_id = ? and rent_l_cd = ?";
		
		PreparedStatement pstmt = null;
	
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, clsm.getRe_file_name());				
			pstmt.setString(2, clsm.getEtc4_file_name());
			pstmt.setString(3, clsm.getRemark_file_name()); //
			pstmt.setString(4, clsm.getEx_ip_dt());
			pstmt.setInt   (5, clsm.getEx_ip_amt()); 
			pstmt.setString(6, clsm.getEx_ip_bank());
			pstmt.setString(7, clsm.getEx_ip_bank_no());
			pstmt.setString(8, clsm.getDes_zip());
			pstmt.setString(9, clsm.getDes_addr());
			pstmt.setString(10, clsm.getDes_nm());  //
			pstmt.setString(11, clsm.getCms_after());  //	
			
			pstmt.setInt   (12, clsm.getM_dae_amt()); 
			pstmt.setInt   (13, clsm.getExt_amt()); 
			pstmt.setString(14, clsm.getStatus());  //	
			pstmt.setString(15, clsm.getDes_tel());  //연락처
			pstmt.setInt   (16, clsm.getCms_amt()); 			
			pstmt.setString(17, clsm.getE_serv_rem());  //사전수리항목
			pstmt.setInt   (18, clsm.getE_serv_amt());  //사전얘상수리
		
			pstmt.setString(19, clsm.getSui_st());
			pstmt.setInt   (20, clsm.getSui_d1_amt()); 
			pstmt.setInt   (21, clsm.getSui_d2_amt()); 
			pstmt.setInt   (22, clsm.getSui_d3_amt()); 
			pstmt.setInt   (23, clsm.getSui_d4_amt()); 
			
			pstmt.setInt   (24, clsm.getSui_d5_amt()); 
			pstmt.setInt   (25, clsm.getSui_d6_amt()); 
			pstmt.setInt   (26, clsm.getSui_d7_amt()); 
			pstmt.setInt   (27, clsm.getSui_d8_amt()); 
			pstmt.setInt   (28, clsm.getSui_d_amt()); 
			
			pstmt.setString(29, clsm.getMatch_l_cd());
					
			pstmt.setString(30, clsm.getRent_mng_id());
			pstmt.setString(31, clsm.getRent_l_cd());

			pstmt.executeUpdate();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AccuDatabase:updateClsEtcMore]\n"+e);			
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
	
	
	/*해지의뢰상세내역조회  */
	public ClsEtcSubBean getClsEtcSubCase(String rent_mng_id, String rent_l_cd, int cls_seq)
	{
		getConnection();
		ClsEtcSubBean clss = new ClsEtcSubBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		
		query = " select "+
				" a.RENT_MNG_ID, a.RENT_L_CD, a.cls_seq,  "+ 
				" a.FINE_AMT_1, a.CAR_JA_AMT_1 , a.DLY_AMT_1,  a.ETC_AMT_1,  a.ETC2_AMT_1, a.DFT_AMT_1, "+  //6
				" a.DFEE_AMT_1, a.ETC3_AMT_1,    a.ETC4_AMT_1, a.NO_V_AMT_1, a.FDFT_AMT1_1, "+  //5
				" a.FINE_AMT_2, a.CAR_JA_AMT_2,  a.DLY_AMT_2,  a.ETC_AMT_2,  a.ETC2_AMT_2, a.DFT_AMT_2,"+ //6
				" a.DFEE_AMT_2, a.ETC3_AMT_2,    a.ETC4_AMT_2, a.NO_V_AMT_2, a.FDFT_AMT1_2, " +  //5
				" a.FINE_AMT_3, a.CAR_JA_AMT_3,  a.DLY_AMT_3,  a.ETC_AMT_3,  a.ETC2_AMT_3, a.DFT_AMT_3,"+ //6
				" a.DFEE_AMT_3, a.ETC3_AMT_3,    a.ETC4_AMT_3, a.NO_V_AMT_3, a.FDFT_AMT1_3 , " +  //5
				" a.DFEE_AMT_2_V, a.DFT_AMT_2_V, a.ETC_AMT_2_V, a.ETC2_AMT_2_V, a.ETC4_AMT_2_V, " +  //5
				" a.RIFEE_AMT_2_V, a.RFEE_AMT_2_V, " +  //2
				" a.OVER_AMT_1, a.OVER_AMT_2 , a.OVER_AMT_3, a.OVER_AMT_2_V " +  //4
				" from cls_etc_sub a where  a.RENT_MNG_ID = ? and a.RENT_L_CD = ? and a.cls_seq = ? ";
						
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
			pstmt.setInt(3, cls_seq);
			 
	    	rs = pstmt.executeQuery();	    
	        	
			while(rs.next())
			{ 
				clss.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				clss.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				clss.setCls_seq(rs.getInt("cls_seq"));
				clss.setFine_amt_1(rs.getInt("FINE_AMT_1"));
				clss.setCar_ja_amt_1(rs.getInt("CAR_JA_AMT_1"));
				clss.setDly_amt_1(rs.getInt("DLY_AMT_1"));
				clss.setEtc_amt_1(rs.getInt("ETC_AMT_1"));
				clss.setEtc2_amt_1(rs.getInt("ETC2_AMT_1"));
				clss.setDft_amt_1(rs.getInt("DFT_AMT_1"));
				
				clss.setDfee_amt_1(rs.getInt("DFEE_AMT_1"));
				clss.setEtc3_amt_1(rs.getInt("ETC3_AMT_1"));
				clss.setEtc4_amt_1(rs.getInt("ETC4_AMT_1"));
				clss.setNo_v_amt_1(rs.getInt("NO_V_AMT_1"));
				clss.setFdft_amt1_1(rs.getInt("FDFT_AMT1_1"));
				
				clss.setFine_amt_2(rs.getInt("FINE_AMT_2"));
				clss.setCar_ja_amt_2(rs.getInt("CAR_JA_AMT_2"));
				clss.setDly_amt_2(rs.getInt("DLY_AMT_2"));
				clss.setEtc_amt_2(rs.getInt("ETC_AMT_2"));
				clss.setEtc2_amt_2(rs.getInt("ETC2_AMT_2"));
				clss.setDft_amt_2(rs.getInt("DFT_AMT_2"));
				clss.setDfee_amt_2(rs.getInt("DFEE_AMT_2"));
				clss.setEtc3_amt_2(rs.getInt("ETC3_AMT_2"));
				clss.setEtc4_amt_2(rs.getInt("ETC4_AMT_2"));
				clss.setNo_v_amt_2(rs.getInt("NO_V_AMT_2"));
				clss.setFdft_amt1_2(rs.getInt("FDFT_AMT1_2"));
				
				clss.setFine_amt_3(rs.getInt("FINE_AMT_3"));
				clss.setCar_ja_amt_3(rs.getInt("CAR_JA_AMT_3"));
				clss.setDly_amt_3(rs.getInt("DLY_AMT_3"));
				clss.setEtc_amt_3(rs.getInt("ETC_AMT_3"));
				clss.setEtc2_amt_3(rs.getInt("ETC2_AMT_3"));
				clss.setDft_amt_3(rs.getInt("DFT_AMT_3"));
				clss.setDfee_amt_3(rs.getInt("DFEE_AMT_3"));
				clss.setEtc3_amt_3(rs.getInt("ETC3_AMT_3"));
				clss.setEtc4_amt_3(rs.getInt("ETC4_AMT_3"));
				clss.setNo_v_amt_3(rs.getInt("NO_V_AMT_3"));
				clss.setFdft_amt1_3(rs.getInt("FDFT_AMT1_3"));
				
				clss.setRifee_amt_2_v(rs.getInt("RIFEE_AMT_2_V"));
				clss.setRfee_amt_2_v(rs.getInt("RFEE_AMT_2_V"));				
				clss.setDfee_amt_2_v(rs.getInt("DFEE_AMT_2_V"));
				clss.setDft_amt_2_v(rs.getInt("DFT_AMT_2_V"));
				clss.setEtc_amt_2_v(rs.getInt("ETC_AMT_2_V"));
				clss.setEtc2_amt_2_v(rs.getInt("ETC2_AMT_2_V"));
				clss.setEtc4_amt_2_v(rs.getInt("ETC4_AMT_2_V"));				
				
				clss.setOver_amt_1(rs.getInt("OVER_AMT_1"));				
				clss.setOver_amt_2(rs.getInt("OVER_AMT_2"));			
				clss.setOver_amt_3(rs.getInt("OVER_AMT_3"));		
				clss.setOver_amt_2_v(rs.getInt("OVER_AMT_2_V"));								
				
			}
		} catch (SQLException e) {
			System.out.println("[AccuDatabase:getClsEtcSub]\n"+e);	
			System.out.println(query);		
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return clss;
		}
	} 
	
	/**
	 *	차량회수 insert
	 */
	public boolean updateCarReco(CarRecoBean cr)
	{
		getConnection();
		boolean flag = true;
		String query = "update car_reco set "+
							" reco_st = ?, reco_d1_st =?, reco_d2_st = ?, "+  //3
							" reco_cau = ?, reco_dt = replace(?, '-', ''), reco_id = ?, ip_dt = replace(?, '-', ''), "+  //4
						 	" etc2_d1_amt = ?,  etc_d1_amt = ?, "+   //2
						 	" upd_id = ? , upd_dt=to_char(sysdate,'YYYYMMdd'), park = ?, park_cont = ?  "+  //2(1)
							" where rent_mng_id = ? and rent_l_cd = ?  ";  //2
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, cr.getReco_st());
			pstmt.setString(2, cr.getReco_d1_st());
			pstmt.setString(3, cr.getReco_d2_st()); 
			
			pstmt.setString(4, cr.getReco_cau());
			pstmt.setString(5, cr.getReco_dt());
			pstmt.setString(6, cr.getReco_id());
			pstmt.setString(7, cr.getIp_dt());
			
			pstmt.setInt(8, cr.getEtc2_d1_amt());
			pstmt.setInt(9, cr.getEtc_d1_amt());
			
					
			pstmt.setString(10, cr.getUpd_id());
			pstmt.setString(11, cr.getPark());
			pstmt.setString(12, cr.getPark_cont());
			
			pstmt.setString(13, cr.getRent_mng_id());
			pstmt.setString(14, cr.getRent_l_cd());
		
		    pstmt.executeUpdate();

			conn.commit();
		    
	  	} catch (Exception e) {
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
	 *	차량회수 insert (rent_mng_id, rent_l_cd, reco_dt, ip_dt, tot_dist)
	 */
	public boolean updateCarReco(String rent_mng_id, String rent_l_cd, String reco_dt, String ip_dt )
	{
		getConnection();
		boolean flag = true;
		String query = "update car_reco set "+						
							" reco_dt = replace(?, '-', ''), ip_dt = replace(?, '-', ''), "+  //2						
						 	" upd_dt=to_char(sysdate,'YYYYMMdd') "+  //2(1)
							" where rent_mng_id = ? and rent_l_cd = ?  ";  //2
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, reco_dt);
			pstmt.setString(2, ip_dt);
					
			pstmt.setString(3, rent_mng_id);
			pstmt.setString(4, rent_l_cd);
		
		    pstmt.executeUpdate();

			conn.commit();
		    
	  	} catch (Exception e) {
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
	 *	차량채권 insert
	 */
	public boolean updateCarCredit(CarCreditBean cr)
	{
		getConnection();
		boolean flag = true;
		String query = "update car_credit set "+
							" gi_amt = ? , gi_c_amt = ?, gi_j_amt = ?, c_ins = ?, c_ins_d_nm = ?, c_ins_tel = ?, "+  //6
						 	" crd_reg_gu1 = ?, crd_reg_gu2 = ?, crd_reg_gu3 = ?, crd_reg_gu4 = ?, crd_reg_gu5 = ?, crd_reg_gu6 = ?,"+ //6
						  	" crd_remark1 = ?, crd_remark2 = ?, crd_remark3 = ?, crd_remark4 = ?, crd_remark5 = ?, crd_remark6 = ?,"+ //6
						 	" crd_req_gu1 = ?, crd_req_gu2 = ?, crd_req_gu3 = ?, crd_req_gu4 = ?, crd_req_gu5 = ?, crd_req_gu6 = ?,"+ //6
						  	" crd_pri1 = ?, crd_pri2 = ?, crd_pri3 = ?, crd_pri4 = ?, crd_pri5 = ?, crd_pri6 = ?,"+ //6
						 	" crd_id = ?, crd_reason = ?, "+  //2
						 	" upd_id = ? , upd_dt=to_char(sysdate,'YYYYMMdd') ,  guar_st = ?  "+  //3(2)
							" where rent_mng_id = ? and rent_l_cd = ?  ";  //2
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
		
			pstmt.setInt(1,	cr.getGi_amt());
			pstmt.setInt(2, cr.getGi_c_amt());
			pstmt.setInt(3, cr.getGi_j_amt());
			pstmt.setString(4, cr.getC_ins());
			pstmt.setString(5, cr.getC_ins_d_nm());
			pstmt.setString(6, cr.getC_ins_tel());
			
			pstmt.setString(7, cr.getCrd_reg_gu1());
			pstmt.setString(8, cr.getCrd_reg_gu2());
			pstmt.setString(9, cr.getCrd_reg_gu3());
			pstmt.setString(10, cr.getCrd_reg_gu4());
			pstmt.setString(11, cr.getCrd_reg_gu5());
			pstmt.setString(12, cr.getCrd_reg_gu6());
			
			pstmt.setString(13, cr.getCrd_remark1());
			pstmt.setString(14, cr.getCrd_remark2());
			pstmt.setString(15, cr.getCrd_remark3());
			pstmt.setString(16, cr.getCrd_remark4());
			pstmt.setString(17, cr.getCrd_remark5());
			pstmt.setString(18, cr.getCrd_remark6());
			
			pstmt.setString(19, cr.getCrd_req_gu1());
			pstmt.setString(20, cr.getCrd_req_gu2());
			pstmt.setString(21, cr.getCrd_req_gu3());
			pstmt.setString(22, cr.getCrd_req_gu4());
			pstmt.setString(23, cr.getCrd_req_gu5());
			pstmt.setString(24, cr.getCrd_req_gu6());
			
			pstmt.setString(25, cr.getCrd_pri1());
			pstmt.setString(26, cr.getCrd_pri2());
			pstmt.setString(27, cr.getCrd_pri3());
			pstmt.setString(28, cr.getCrd_pri4());
			pstmt.setString(29, cr.getCrd_pri5());
			pstmt.setString(30, cr.getCrd_pri6());
			
			pstmt.setString(31, cr.getCrd_id());
			pstmt.setString(32, cr.getCrd_reason());
			
			pstmt.setString(33, cr.getUpd_id());			
			pstmt.setString(34, cr.getGuar_st());			
			
			pstmt.setString(35, cr.getRent_mng_id());
			pstmt.setString(36, cr.getRent_l_cd());
			
		    pstmt.executeUpdate();

			conn.commit();
		    
	  	} catch (Exception e) {
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
	 *	초과운행 insert
	 */
	public boolean updateClsEtcOver(ClsEtcOverBean co)
	{
		getConnection();
		boolean flag = true;
		String query = "update cls_etc_over  set "+
							" rent_days = ? , cal_dist = ?, first_dist = ?, last_dist = ?, real_dist = ?, over_dist = ?, "+  //6
						 	" add_dist = ?, jung_dist = ?, r_over_amt = ?, m_over_amt = ?, j_over_amt = ?,"+ //5				  
						 	" m_saction_id = ?,  m_saction_dt = ?,  m_reason= ?  "+  //3				
							" where rent_mng_id = ? and rent_l_cd = ?  ";  //2
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
		
			pstmt.setInt(1,	co.getRent_days());
			pstmt.setInt(2, co.getCal_dist());
			pstmt.setInt(3, co.getFirst_dist());
			pstmt.setInt(4, co.getLast_dist());
			pstmt.setInt(5, co.getReal_dist());
			pstmt.setInt(6, co.getOver_dist());
			
			pstmt.setInt(7, co.getAdd_dist());
			pstmt.setInt(8, co.getJung_dist());
			pstmt.setInt(9, co.getR_over_amt());
			pstmt.setInt(10, co.getM_over_amt());
			pstmt.setInt(11, co.getJ_over_amt());		
			
			pstmt.setString(12, co.getM_saction_id());
			pstmt.setString(13, co.getM_saction_dt());
			pstmt.setString(14, co.getM_reason());
		
			pstmt.setString(15, co.getRent_mng_id());
			pstmt.setString(16, co.getRent_l_cd());
			
		    pstmt.executeUpdate();

			conn.commit();
		    
	  	} catch (Exception e) {
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
	 *	선수금정산 수정
	 */
	public boolean updateClsContEtc(ClsContEtcBean cct)
	{
		getConnection();
		boolean flag = true;
		String query = "update cls_cont_etc set "+
							" jung_st = ?,  "+  //1
						 	" h1_amt = ?,  h2_amt = ?,   h3_amt = ? , h4_amt = ?,  h5_amt = ? , h6_amt = ?,  h7_amt = ?,  "+   //7
						 	" h_st = ?, h_ip_dt = replace(?, '-', '')  , pay_st = ? , "+  //3
						   " suc_gubun= ?, suc_l_cd = ?, delay_st = ?, delay_type = ?, delay_desc = ?, refund_st = ? ,  r_date = replace(?, '-', '')   "+  //7
							" where rent_mng_id = ? and rent_l_cd = ?  ";  //2
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, cct.getJung_st());
				
			pstmt.setInt(2, cct.getH1_amt());
			pstmt.setInt(3, cct.getH2_amt());
			pstmt.setInt(4, cct.getH3_amt());
			pstmt.setInt(5, cct.getH4_amt());
			pstmt.setInt(6, cct.getH5_amt());
			pstmt.setInt(7, cct.getH6_amt());
			pstmt.setInt(8, cct.getH7_amt());				
						
			pstmt.setString(9, cct.getH_st());
			pstmt.setString(10, cct.getH_ip_dt());
			pstmt.setString(11, cct.getPay_st());
			
			pstmt.setString(12, cct.getSuc_gubun());
			pstmt.setString(13, cct.getSuc_l_cd());
			pstmt.setString(14, cct.getDelay_st());
			pstmt.setString(15, cct.getDelay_type());
			pstmt.setString(16, cct.getDelay_desc());
			pstmt.setString(17, cct.getRefund_st());
			pstmt.setString(18, cct.getR_date());
					
			pstmt.setString(19, cct.getRent_mng_id());
			pstmt.setString(20, cct.getRent_l_cd());
		
		   	 pstmt.executeUpdate();

			conn.commit();
		    
	  	} catch (Exception e) {
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
	

	//해지정산시 과태료 상계처리 조회
	public Vector getForfeitDetailCls( String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";		
		
		query = " select seq_no, car_mng_id, vio_dt, vio_pla , nvl(proxy_dt,'') proxy_dt "+
				"	FROM fine  "+
				"	WHERE coll_dt is null  "+
				"	and nvl(no_paid_yn,'N')<>'Y'  "+
				"	and nvl(fault_st,'1')='1' and paid_st in ('3','4') and rent_mng_id='"+rent_mng_id+"' and rent_l_cd = '"+rent_l_cd+"'";	

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
		} catch (SQLException e) {
			System.out.println("[AccuDatabase:getForfeitDetailCls]\n"+e);			
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
	
	public Vector getForfeitDetailCls( String rent_mng_id, String rent_l_cd, int paid_amt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";		
		
		query = " select seq_no, paid_amt "+
				"	FROM fine  "+
				"	WHERE  paid_amt >= " + paid_amt + " and coll_dt is null  "+
				"	and nvl(no_paid_yn,'N')<>'Y'  "+
				"	and nvl(fault_st,'1')='1' and paid_st in ('3','4') and rent_mng_id='"+rent_mng_id+"' and rent_l_cd = '"+rent_l_cd+"'" +
				"  order by seq_no ";

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
		} catch (SQLException e) {
			System.out.println("[AccuDatabase:getForfeitDetailCls]\n"+e);			
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
     * 과태료/범칙금 입금처리 수정
     */
    public boolean updateForfeitDetailCls(String rent_mng_id, String rent_l_cd, int seq_no, String coll_dt, String user_id) 
    {
      	getConnection();
        PreparedStatement pstmt = null;
        String query = "";
        boolean flag = true;
 		                
        query = " update fine set coll_dt= replace(?, '-', ''), update_id = ?, update_dt = to_char(sysdate,'YYYYMMdd')  "+
				" where seq_no=? and rent_mng_id=? and rent_l_cd=?";
         
       try{
            conn.setAutoCommit(false);
           
            pstmt = conn.prepareStatement(query);            
            pstmt.setString(1, coll_dt	);
            pstmt.setString(2, user_id	);
            pstmt.setInt   (3, seq_no		);
            pstmt.setString(4, rent_mng_id	);
            pstmt.setString(5, rent_l_cd	);
            
            pstmt.executeUpdate();
             
            pstmt.close();
            conn.commit();

    
    	} catch (Exception e) {
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
    
    
	//해지정산시 면책금 상계처리 조회 (fms에 기입력된 면책금)
	public Vector getServiceDetailCls( String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";			
		
		query = " SELECT se.ext_id, (se.ext_s_amt + se.ext_v_amt) car_ja_amt, se.ext_tm ,nvl(a.bill_doc_yn, '0') bill_doc_yn "+
				"	FROM service a, scd_ext se  "+
				"	WHERE se.ext_st = '3' and se.rent_mng_id = a.rent_mng_id and se.rent_l_cd = a.rent_l_cd and se.ext_id = a.serv_id "+
				"	and (se.ext_s_amt + se.ext_v_amt)  <> 0 and se.ext_pay_dt is null "+
				"	and nvl(a.no_dft_yn,'N')<>'Y'  and  a.rent_mng_id='"+rent_mng_id+"' and a.rent_l_cd = '"+rent_l_cd+"'";	

		
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
		} catch (SQLException e) {
			System.out.println("[AccuDatabase:getServiceDetailCls]\n"+e);			
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
     * 면책금 입금처리 수정
     */
    public boolean updateServiceDetailCls(String rent_mng_id, String rent_l_cd, String serv_id, int car_ja_amt, String ext_tm, String cls_dt, String user_id) 
    {
      	getConnection();
      	PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
        boolean flag = true;
 		
		String query = "";
		query = " UPDATE scd_ext SET ext_pay_dt=replace(?, '-', ''), ext_pay_amt=?, "+
				" update_dt=to_char(sysdate,'YYYYMMDD'), update_id=? "+
				" WHERE ext_st = '3' and rent_mng_id=? and rent_l_cd=? and ext_id = ? and ext_tm = ? ";						
				
		String query1 = "";
		query1 = " UPDATE service SET cust_pay_dt =replace(?, '-', ''),  "+
				" update_dt=to_char(sysdate,'YYYYMMDD'), update_id=? "+
				" WHERE  rent_mng_id=? and rent_l_cd=? and serv_id = ?  ";		
             
       try{
            conn.setAutoCommit(false);           
        						 	
			pstmt1 = conn.prepareStatement(query);
			pstmt1.setString(1, cls_dt);
			pstmt1.setInt(2, car_ja_amt);
			pstmt1.setString(3, user_id);
			pstmt1.setString(4, rent_mng_id);
			pstmt1.setString(5, rent_l_cd);
			pstmt1.setString(6, serv_id);		
			pstmt1.setString(7, ext_tm);
		    pstmt1.executeUpdate();		   				   
		   
		   // 정비 테이블 변경	
		   	pstmt2 = conn.prepareStatement(query1);
			pstmt2.setString(1, cls_dt);
			pstmt2.setString(2, user_id);
			pstmt2.setString(3, rent_mng_id);
			pstmt2.setString(4, rent_l_cd);
			pstmt2.setString(5, serv_id); //서비스 id
			pstmt2.executeUpdate();	  
			
            pstmt1.close();
            pstmt2.close();
           
            conn.commit();

    
    	} catch (Exception e) {
			System.out.println("[AccuDatabase:updateServiceDetailCls]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{	
                if(pstmt1 != null)	pstmt1.close();
                if(pstmt2 != null)	pstmt2.close();
                conn.setAutoCommit(true);
			}
			catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	
	 /**
     * 면책금 입금처리 수정 - 해지정산금에 포함되도록 
     */
    public boolean updateServiceDetailCls2(String rent_mng_id, String rent_l_cd, String serv_id, int car_ja_amt, String ext_tm, String cls_dt, String user_id, String bill_doc_yn) 
    {
      	getConnection();
      	PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
        boolean flag = true;
                
        int car_s_amt = 0;
        int car_v_amt = 0;           
        
      	
		String query = "";
		query = " UPDATE scd_ext SET  "+
				" update_dt=to_char(sysdate,'YYYYMMDD'), update_id=? , bill_yn = 'N' "+
				" WHERE ext_st = '3' and rent_mng_id=? and rent_l_cd=? and ext_id = ? and ext_tm = ? ";						
				
		String query1 = "";
		query1 = " UPDATE service SET   "+
			//	" update_dt=to_char(sysdate,'YYYYMMDD'), update_id=?,  cls_amt = ?,  cls_s_amt = ?, cls_v_amt = ? "+
				" update_dt=to_char(sysdate,'YYYYMMDD'), update_id=?, "+
				" bill_yn = 'N', no_dft_cau = nvl(no_dft_cau, '* ') ||  ' 기청구분 해지정산시 포함'   "+
				" WHERE  rent_mng_id=? and rent_l_cd=? and serv_id = ?  ";		
             
       try{
            conn.setAutoCommit(false);           
        						 	
			pstmt1 = conn.prepareStatement(query);
			pstmt1.setString(1, user_id);
			pstmt1.setString(2, rent_mng_id);
			pstmt1.setString(3, rent_l_cd);
			pstmt1.setString(4, serv_id);		
			pstmt1.setString(5, ext_tm);
		    pstmt1.executeUpdate();		   				   
		
			if ( bill_doc_yn.equals("1") ) {  //계산서 발행				
				car_s_amt = (new Double(car_ja_amt/1.1)).intValue();
				car_v_amt = car_ja_amt-car_s_amt;		
							
			} else {
				car_s_amt = car_ja_amt;
				car_v_amt = 0;					
			}	
		   
		   // 정비 테이블 변경	
		   	pstmt2 = conn.prepareStatement(query1);		
			pstmt2.setString(1, user_id);
		//	pstmt2.setInt(2, car_ja_amt);
		//	pstmt2.setInt(3, car_s_amt);
		//	pstmt2.setInt(4, car_v_amt);
			pstmt2.setString(2, rent_mng_id);
			pstmt2.setString(3, rent_l_cd);
			pstmt2.setString(4, serv_id); //서비스 id
			pstmt2.executeUpdate();	  
			
            pstmt1.close();
            pstmt2.close();
           
            conn.commit();

    
    	} catch (Exception e) {
			System.out.println("[AccuDatabase:updateServiceDetailCls2]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{	
                if(pstmt1 != null)	pstmt1.close();
                if(pstmt2 != null)	pstmt2.close();
                conn.setAutoCommit(true);
			}
			catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	
	 /**
     * 연체료 상계 입금처리 수정
     */
    public boolean insertScdDlyCls(String rent_mng_id, String rent_l_cd, int dly_amt, String cls_dt, String user_id ) 
    {
      	getConnection();
      	PreparedStatement dly_pstmt = null;
        boolean flag = true;
       	ResultSet rs = null;
		String seq = "";
 	
		String dly_qry = " insert into SCD_DLY (RENT_MNG_ID, RENT_L_CD, SEQ, PAY_DT, PAY_AMT, REG_ID, REG_DT, ETC)"+
							" values (?, ?, ?, replace(?, '-', ''), ?, ?, to_char(sysdate,'YYYYMMDD'), ?)";
		String dly_seq = " select nvl(to_char(max(to_number(seq))+1),'1') seq from scd_dly where rent_mng_id=? and rent_l_cd=?";
             
       try{
            conn.setAutoCommit(false);           
        						 	
			dly_pstmt = conn.prepareStatement(dly_seq);
			dly_pstmt.setString(1 , rent_mng_id);
			dly_pstmt.setString(2 , rent_l_cd);
			rs = dly_pstmt.executeQuery();
			if(rs.next()){
				seq = rs.getString(1);
			}

			dly_pstmt = conn.prepareStatement(dly_qry);
			dly_pstmt.setString(1, rent_mng_id);
			dly_pstmt.setString(2, rent_l_cd);
			dly_pstmt.setString(3, seq);
			dly_pstmt.setString(4, cls_dt);
			dly_pstmt.setInt   (5, dly_amt);
			dly_pstmt.setString(6, user_id);
			dly_pstmt.setString(7, "해지정산시 상계정산");				
			
			
			dly_pstmt.executeUpdate();           
            conn.commit();

    
    	} catch (Exception e) {
			System.out.println("[AccuDatabase:insertScdDlyCls]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{	
			    if(rs != null)	rs.close();
                if(dly_pstmt != null)	dly_pstmt.close();
               
                conn.setAutoCommit(true);
			}
			catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}	 	
	 
	 /**
     * 연체료 상계 입금처리 수정
     */
    public boolean insertScdDlyCls(String rent_mng_id, String rent_l_cd, int dly_amt, String cls_dt, String user_id, String gubun ) 
    {
      	getConnection();
      	PreparedStatement dly_pstmt = null;
        boolean flag = true;
       	ResultSet rs = null;
		String seq = "";
 	
		String dly_qry = " insert into SCD_DLY (RENT_MNG_ID, RENT_L_CD, SEQ, PAY_DT, PAY_AMT, REG_ID, REG_DT, ETC)"+
							" values (?, ?, ?, replace(?, '-', ''), ?, ?, to_char(sysdate,'YYYYMMDD'), ?)";
		String dly_seq = " select nvl(to_char(max(to_number(seq))+1),'1') seq from scd_dly where rent_mng_id=? and rent_l_cd=?";
             
       try{
            conn.setAutoCommit(false);           
        						 	
			dly_pstmt = conn.prepareStatement(dly_seq);
			dly_pstmt.setString(1 , rent_mng_id);
			dly_pstmt.setString(2 , rent_l_cd);
			rs = dly_pstmt.executeQuery();
			if(rs.next()){
				seq = rs.getString(1);
			}

			dly_pstmt = conn.prepareStatement(dly_qry);
			dly_pstmt.setString(1, rent_mng_id);
			dly_pstmt.setString(2, rent_l_cd);
			dly_pstmt.setString(3, seq);
			dly_pstmt.setString(4, cls_dt);
			dly_pstmt.setInt   (5, dly_amt);
			dly_pstmt.setString(6, user_id);
			if (gubun.equals("1") ) {
				dly_pstmt.setString(7, "해지정산시 감면정산");
			} else {
				dly_pstmt.setString(7, "해지정산시 상계정산");				
			}	
			
			dly_pstmt.executeUpdate();           
            conn.commit();

    
    	} catch (Exception e) {
			System.out.println("[AccuDatabase:insertScdDlyCls]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{	
			    if(rs != null)	rs.close();
                if(dly_pstmt != null)	dly_pstmt.close();
               
                conn.setAutoCommit(true);
			}
			catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}	 
	 
	//해지정산시 미납대여료관련 기발행세금계산서 여부
	public String getMaxFeeTaxTm( String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";		
		String tm = "";
				
		query = " select  nvl(to_char(max(to_number(b.tm))),'999') tm "+
 				"  from   tax a, tax_item_list b "+
				"  where  a.item_id = b.item_id(+) "+
 				"    and  b.rent_l_cd= '"+rent_l_cd+"' and b.gubun= '1' and a.tax_st = 'O'"; //대여료
 			
 		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		if(rs.next())
			{		
				tm = rs.getString(1);
			}

		} catch (SQLException e) {
			System.out.println("[AccuDatabase:getMaxFeeTaxTm]\n"+e);
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
	 
		//해지정산시 미납대여료관련 기발행 세금계산서 관련
	public int  getRemainFeeDay( String rent_l_cd, String fee_tm, String cls_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";		
		int re_day = 0;
				
		query = " select  to_date(use_e_dt) - to_date('"+ cls_dt + "') "+
 				"  from   scd_fee "+
				"  where  rent_l_cd = '"+rent_l_cd+"' and fee_tm= '"+fee_tm+"' and tm_st1 = '0'  and rownum = 1";
				
 			
 		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		if(rs.next())
			{		
				re_day = rs.getInt(1);
			}

		} catch (SQLException e) {
			System.out.println("[AccuDatabase:getRemainFeeDay]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return re_day;
		}
	}
	
	public Hashtable  getScdFeeTaxVatAmt( String rent_mng_id, String rent_l_cd, String fee_tm)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";		
		
		query = " select  fee_s_amt, fee_v_amt, use_s_dt, use_e_dt, fee_tm "+
 				"  from   scd_fee "+
				"  where  rent_mng_id = '"+ rent_mng_id + "' and rent_l_cd = '"+rent_l_cd+"' and fee_tm= '"+fee_tm+"' and tm_st1 = '0' ";
		 			
 		
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
		} catch (SQLException e) {
			System.out.println("[AccDatabase:getScdFeeTaxVatAmt]\n"+e);			
			System.out.println("[AccDatabase:getScdFeeTaxVatAmt]\n"+query);			
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
	
	
		/*해지의뢰상세내역조회  */
	
	public ClsEtcTaxBean getClsEtcTax(String rent_mng_id, String rent_l_cd, int seq_no)
	{
		getConnection();
		ClsEtcTaxBean ct = new ClsEtcTaxBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		
		query = " select "+
				" a.RENT_MNG_ID, a.RENT_L_CD, a.seq_no,  "+ 
				" a.rifee_s_amt_s, a.rfee_s_amt_s , a.etc_amt_s,  a.etc2_amt_s,  a.dft_amt_s, a.dfee_amt_s, a.etc4_amt_s, "+  //7
				" a.rifee_s_amt_v, a.rfee_s_amt_v , a.etc_amt_v,  a.etc2_amt_v,  a.dft_amt_v, a.dfee_amt_v, a.etc4_amt_v, "+  //7
				" a.rifee_s_amt, a.rfee_s_amt , a.etc_amt,  a.etc2_amt,  a.dft_amt, a.dfee_amt, a.etc4_amt, "+  //7	
				" a.dfee_c_amt_s, a.dfee_c_amt_v , a.dfee_c_amt , "+  //3		
				" a.over_amt_s, a.over_amt_v , a.over_amt "+  //3		
				" from cls_etc_tax a where  a.RENT_MNG_ID = ? and a.RENT_L_CD = ?  and a.seq_no = ? ";
						
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
			pstmt.setInt(3, seq_no);
						 
	    	rs = pstmt.executeQuery();	    
	        	
			while(rs.next())
			{ 
				ct.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				ct.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				ct.setSeq_no(rs.getInt("seq_no"));		
				ct.setRifee_s_amt_s(rs.getInt("rifee_s_amt_s"));
				ct.setRfee_s_amt_s(rs.getInt("rfee_s_amt_s"));
				ct.setEtc_amt_s(rs.getInt("etc_amt_s"));
				ct.setEtc2_amt_s(rs.getInt("etc2_amt_s"));
				ct.setDft_amt_s(rs.getInt("dft_amt_s"));
				ct.setDfee_amt_s(rs.getInt("dfee_amt_s"));
				ct.setEtc4_amt_s(rs.getInt("etc4_amt_s"));
				ct.setRifee_s_amt_v(rs.getInt("rifee_s_amt_v"));
				ct.setRfee_s_amt_v(rs.getInt("rfee_s_amt_v"));
				ct.setEtc_amt_v(rs.getInt("etc_amt_v"));
				ct.setEtc2_amt_v(rs.getInt("etc2_amt_v"));
				ct.setDft_amt_v(rs.getInt("dft_amt_v"));
				ct.setDfee_amt_v(rs.getInt("dfee_amt_v"));
				ct.setEtc4_amt_v(rs.getInt("etc4_amt_v"));
				
				ct.setDfee_c_amt_s(rs.getInt("dfee_c_amt_s"));
				ct.setDfee_c_amt_v(rs.getInt("dfee_c_amt_v"));
				ct.setDfee_c_amt(rs.getInt("dfee_c_amt"));
				
				ct.setOver_amt_s(rs.getInt("over_amt_s"));
				ct.setOver_amt_v(rs.getInt("over_amt_v"));
				ct.setOver_amt(rs.getInt("over_amt"));								
				
			}
		} catch (SQLException e) {
			System.out.println("[AccuDatabase:getClsEtcTax]\n"+e);	
			System.out.println(query);		
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ct;
		}
	} 
	
	 
	/**
	 *	해지세금계산서내역 insert
	 */
	public boolean insertClsEtcTax(ClsEtcTaxBean ct)
	{
		getConnection();
		boolean flag = true;
	//	String query_seq = "";
	//	int seq = 0;
	 
		String query = "insert into cls_etc_tax ("+
							" RENT_MNG_ID,	RENT_L_CD,	seq_no,	 "+ //2
					//		" fine_amt_1, car_ja_amt_1, dly_amt_1, etc_amt_1,  etc2_amt_1, dft_amt_1, dfee_amt_1,  "+ //7
					//		" etc3_amt_1, etc4_amt_1,  no_v_amt_1,  fdft_amt1_1, "+ //4	
							" reg_dt, reg_id ) values( "+  //2
						 	" ?, ?, ?, "+  //2
					//		" ?, ?, ?, ?, ?, ?, ?, " + //7
					//		" ?, ?, ?, ?,  " +  //4
							" to_char(sysdate,'YYYYMMDD'), ? ) ";  //2(1)

//		query_seq = "select nvl(max(cls_seq)+1, 1)  from cls_etc_sub where rent_mng_id = '" + clss.getRent_mng_id() + "' and rent_l_cd = '" + clss.getRent_l_cd() + "'";	
		        
		        							
		PreparedStatement pstmt = null;
			
		
		try 
		{
			conn.setAutoCommit(false);
	
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, ct.getRent_mng_id());
			pstmt.setString(2, ct.getRent_l_cd());
			pstmt.setInt(3, ct.getSeq_no());
			
	//		pstmt.setInt   (4, clss.getFine_amt_1());
	//		pstmt.setInt   (5, clss.getCar_ja_amt_1());
	//		pstmt.setInt   (6, clss.getDly_amt_1());
	//		pstmt.setInt   (7, clss.getEtc_amt_1());
	//		pstmt.setInt   (8, clss.getEtc2_amt_1());
	//		pstmt.setInt   (9, clss.getDft_amt_1());
	//		pstmt.setInt   (10, clss.getDfee_amt_1());
			
	//		pstmt.setInt   (11, clss.getEtc3_amt_1());
	//		pstmt.setInt   (12, clss.getEtc4_amt_1());
	//		pstmt.setInt   (13, clss.getNo_v_amt_1());
	//		pstmt.setInt   (14, clss.getFdft_amt1_1());
			
			pstmt.setString(4, ct.getReg_id());
								
			pstmt.executeUpdate();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[AccuDatabase:insertClsEtcTax]\n"+e);			
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
			
	public boolean insertClsEtcMore(ClsEtcMoreBean cm)
	{
		getConnection();
		boolean flag = true;
	//	String query_seq = "";
	//	int seq = 0;
	  
    
		String query = "insert into cls_etc_more ("+
							" RENT_MNG_ID,	RENT_L_CD,	"+ //2
							" re_file_name, etc4_file_name, remark_file_name, ex_ip_dt,  ex_ip_amt, ex_ip_bank, ex_ip_bank_no,  "+ //7					
							" des_zip, des_addr , des_nm , cms_after, des_tel , cms_amt, \n" +
							" SUI_ST, SUI_D1_AMT, SUI_D2_AMT, SUI_D3_AMT, SUI_D4_AMT, SUI_D5_AMT, SUI_D6_AMT, SUI_D7_AMT, SUI_D8_AMT, SUI_D_AMT, \n" + //10
							" MATCH_L_CD "+
							" ) values( "+  //
						 	" ?, ?,  "+  //2
							" ?, ?, ?, ?, ?, ?, ?, " + //7
							" ?, ?, ?, ? , ? , ?, " +  //6
						    " ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, " +  //10
							" ? ) ";  //1
						        		        							
		PreparedStatement pstmt = null;
					
		try 
		{
			conn.setAutoCommit(false);
	
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, cm.getRent_mng_id());
			pstmt.setString(2, cm.getRent_l_cd());
			
			pstmt.setString(3, cm.getRe_file_name());
 			pstmt.setString   (4, cm.getEtc4_file_name());
			pstmt.setString   (5, cm.getRemark_file_name());
			pstmt.setString   (6, cm.getEx_ip_dt());
			pstmt.setInt   (7, cm.getEx_ip_amt());
			pstmt.setString   (8, cm.getEx_ip_bank());
			pstmt.setString   (9, cm.getEx_ip_bank_no());
			
			pstmt.setString   (10, cm.getDes_zip());
			pstmt.setString   (11, cm.getDes_addr());
			pstmt.setString   (12, cm.getDes_nm());
			pstmt.setString   (13, cm.getCms_after());
			pstmt.setString   (14, cm.getDes_tel());
			pstmt.setInt   (15, cm.getCms_amt());
			
			pstmt.setString   (16, cm.getSui_st());
			pstmt.setInt   (17, cm.getSui_d1_amt());
			pstmt.setInt   (18, cm.getSui_d2_amt());
			pstmt.setInt   (19, cm.getSui_d3_amt());
			pstmt.setInt   (20, cm.getSui_d4_amt());
			pstmt.setInt   (21, cm.getSui_d5_amt());
			pstmt.setInt   (22, cm.getSui_d6_amt());
			pstmt.setInt   (23, cm.getSui_d7_amt());
			pstmt.setInt   (24, cm.getSui_d8_amt());
			pstmt.setInt   (25, cm.getSui_d_amt());	
			pstmt.setString   (26, cm.getMatch_l_cd());
												
			pstmt.executeUpdate();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[AccuDatabase:insertClsEtcMore]\n"+e);			
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
	 *	차량채권 insert
	 */
	public boolean updateClsEtcTax(ClsEtcTaxBean ct)
	{
		getConnection();
		boolean flag = true;
		String query = "update cls_etc_tax set "+
							" tax_r_chk0 = ? , tax_r_chk1 = ?, tax_r_chk2 = ?, tax_r_chk3 = ?, tax_r_chk4 = ?, tax_r_chk5 = ?, tax_r_chk6 = ?, "+  //7
						 	" rifee_s_amt_s = ?, rfee_s_amt_s = ?, dfee_amt_s = ?, dft_amt_s = ?, etc_amt_s = ?, etc2_amt_s = ?, etc4_amt_s = ?,"+ //7
						 	" rifee_s_amt_v = ?, rfee_s_amt_v = ?, dfee_amt_v = ?, dft_amt_v = ?, etc_amt_v = ?, etc2_amt_v = ?, etc4_amt_v = ?,"+ //7
						 	" rifee_s_amt = ?,   rfee_s_amt = ?,   dfee_amt = ?,   dft_amt = ?,   etc_amt = ?,   etc2_amt = ?,   etc4_amt = ?, "+ //7
						 	" rifee_etc = ?,   rfee_etc = ?,   dfee_etc = ?,   dft_etc = ?,   etc_etc = ?,   etc2_etc = ?,   etc4_etc = ?, "+ //7
						 	" tax_r_chk7 = ?,   dfee_c_amt_s = ?,   dfee_c_amt_v = ?,   dfee_c_amt = ?,   dfee_c_etc = ?,  "+ //5
						 	" r_rifee_s_amt_s = ?, r_rfee_s_amt_s = ?, r_dfee_amt_s = ?, r_dft_amt_s = ?, r_etc_amt_s = ?, r_etc2_amt_s = ?, r_etc4_amt_s = ?, r_dfee_c_amt_s = ?, "+ //8
						  	" r_rifee_s_amt_v = ?, r_rfee_s_amt_v = ?, r_dfee_amt_v = ?, r_dft_amt_v = ?, r_etc_amt_v = ?, r_etc2_amt_v = ?, r_etc4_amt_v = ?, r_dfee_c_amt_v = ?, "+ //8
						 	" tax_r_chk8 = ?, over_amt_s = ?, over_amt_v = ?, r_over_amt_s = ?, r_over_amt_v = ?,  over_amt = ?,  over_etc  = ?, "+ //7
						 	" upd_id = ? , upd_dt=to_char(sysdate,'YYYYMMdd') "+  //2(1)
							" where rent_mng_id = ? and rent_l_cd = ? and seq_no = ? ";  //2
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
		
			pstmt.setString(1, ct.getTax_r_chk0());
			pstmt.setString(2, ct.getTax_r_chk1());
			pstmt.setString(3, ct.getTax_r_chk2());
			pstmt.setString(4, ct.getTax_r_chk3());
			pstmt.setString(5, ct.getTax_r_chk4());
			pstmt.setString(6, ct.getTax_r_chk5());
			pstmt.setString(7, ct.getTax_r_chk6()); //7
			
			pstmt.setInt(8,	 ct.getRifee_s_amt_s());
			pstmt.setInt(9,  ct.getRfee_s_amt_s());
			pstmt.setInt(10, ct.getDfee_amt_s());
			pstmt.setInt(11, ct.getDft_amt_s());
			pstmt.setInt(12, ct.getEtc_amt_s());
			pstmt.setInt(13, ct.getEtc2_amt_s());
			pstmt.setInt(14, ct.getEtc4_amt_s()); //7
			
			pstmt.setInt(15,	 ct.getRifee_s_amt_v());
			pstmt.setInt(16,  ct.getRfee_s_amt_v());
			pstmt.setInt(17, ct.getDfee_amt_v());
			pstmt.setInt(18, ct.getDft_amt_v());
			pstmt.setInt(19, ct.getEtc_amt_v());
			pstmt.setInt(20, ct.getEtc2_amt_v());
			pstmt.setInt(21, ct.getEtc4_amt_v()); //7
			
			pstmt.setInt(22, ct.getRifee_s_amt());
			pstmt.setInt(23, ct.getRfee_s_amt());
			pstmt.setInt(24, ct.getDfee_amt());
			pstmt.setInt(25, ct.getDft_amt());
			pstmt.setInt(26, ct.getEtc_amt());
			pstmt.setInt(27, ct.getEtc2_amt());
			pstmt.setInt(28, ct.getEtc4_amt()); //7
			
			pstmt.setString(29, ct.getRifee_etc());
			pstmt.setString(30, ct.getRfee_etc());
			pstmt.setString(31, ct.getDfee_etc());
			pstmt.setString(32, ct.getDft_etc());
			pstmt.setString(33, ct.getEtc_etc());
			pstmt.setString(34, ct.getEtc2_etc());
			pstmt.setString(35, ct.getEtc4_etc()); //7
			
			pstmt.setString(36, ct.getTax_r_chk7()); 
			pstmt.setInt(37, ct.getDfee_c_amt_s());
			pstmt.setInt(38, ct.getDfee_c_amt_v());
			pstmt.setInt(39, ct.getDfee_c_amt());
			pstmt.setString(40, ct.getDfee_c_etc());
					
			pstmt.setInt(41, ct.getR_rifee_s_amt_s());
			pstmt.setInt(42, ct.getR_rfee_s_amt_s());
			pstmt.setInt(43, ct.getR_dfee_amt_s());
			pstmt.setInt(44, ct.getR_dft_amt_s());
			pstmt.setInt(45, ct.getR_etc_amt_s());
			pstmt.setInt(46, ct.getR_etc2_amt_s());
			pstmt.setInt(47, ct.getR_etc4_amt_s());  
			pstmt.setInt(48, ct.getR_dfee_c_amt_s()); //8
			
			pstmt.setInt(49, ct.getR_rifee_s_amt_v());
			pstmt.setInt(50, ct.getR_rfee_s_amt_v());
			pstmt.setInt(51, ct.getR_dfee_amt_v());
			pstmt.setInt(52, ct.getR_dft_amt_v());
			pstmt.setInt(53, ct.getR_etc_amt_v());
			pstmt.setInt(54, ct.getR_etc2_amt_v());
			pstmt.setInt(55, ct.getR_etc4_amt_v());  	
			pstmt.setInt(56, ct.getR_dfee_c_amt_v());	 //8
			
			
			pstmt.setString(57, ct.getTax_r_chk8()); 
			pstmt.setInt(58, ct.getOver_amt_s());
			pstmt.setInt(59, ct.getOver_amt_v());
			pstmt.setInt(60, ct.getR_over_amt_s());
			pstmt.setInt(61, ct.getR_over_amt_v());
			pstmt.setInt(62, ct.getOver_amt());
			pstmt.setString(63, ct.getOver_etc());   //7 
								
			pstmt.setString(64, ct.getUpd_id());
			pstmt.setString(65, ct.getRent_mng_id());
			pstmt.setString(66, ct.getRent_l_cd());
			pstmt.setInt(67, ct.getSeq_no());
			
		    pstmt.executeUpdate();

			conn.commit();
		    
	  	} catch (Exception e) {
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
	 *	해지상세내역 insert - 집금시 추가
	 */
	public boolean insertClsEtcSubIncom(ClsEtcSubBean clss)
	{
		getConnection();
		boolean flag = true;
		String query_seq = "";
		int seq = 0;
	 
		String query = "insert into cls_etc_sub ("+
							" RENT_MNG_ID,	RENT_L_CD,	CLS_SEQ,	 "+ //3
							" fine_amt_1, car_ja_amt_1, dly_amt_1, etc_amt_1,  etc2_amt_1, dft_amt_1, dfee_amt_1,  "+ //7
							" etc3_amt_1, etc4_amt_1,  no_v_amt_1,  fdft_amt1_1, "+ //4	
							" fine_amt_2, car_ja_amt_2, dly_amt_2, etc_amt_2,  etc2_amt_2, dft_amt_2, dfee_amt_2,  "+ //7
							" etc3_amt_2, etc4_amt_2, no_v_amt_2,  fdft_amt1_2, "+ //4	
							" DFEE_AMT_2_V , DFT_AMT_2_V, ETC_AMT_2_V, ETC2_AMT_2_V , ETC4_AMT_2_V , " +  //5
							" reg_dt, reg_id, over_amt_1, over_amt_2, over_amt_2_v ) values( "+  //5
						 	" ?, ?, ?, "+  //3
							" ?, ?, ?, ?, ?, ?, ?, " + //7
							" ?, ?, ?, ?,  " +  //4
							" ?, ?, ?, ?, ?, ?, ?, " + //7
							" ?, ?, ?, ?,  " +  //4
							" ?, ?, ?, ?, ?, " +  //5
							" to_char(sysdate,'YYYYMMDD'), ? , ?, ?, ?) ";  //2(1)

		query_seq = "select nvl(max(cls_seq)+1, 1)  from cls_etc_sub where rent_mng_id = '" + clss.getRent_mng_id() + "' and rent_l_cd = '" + clss.getRent_l_cd() + "'";	
		        
		        							
		PreparedStatement pstmt = null;
			
		ResultSet rs = null;
		Statement stmt = null;
		
		try 
		{
			conn.setAutoCommit(false);
			
			stmt = conn.createStatement();
            rs = stmt.executeQuery(query_seq);
         //   System.out.println(query_seq);
            if(rs.next())
            	seq = rs.getInt(1);
            rs.close();
			stmt.close();

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, clss.getRent_mng_id());
			pstmt.setString(2, clss.getRent_l_cd());
			pstmt.setInt(3, seq);
	
			pstmt.setInt   (4, clss.getFine_amt_1());
			pstmt.setInt   (5, clss.getCar_ja_amt_1());
			pstmt.setInt   (6, clss.getDly_amt_1());
			pstmt.setInt   (7, clss.getEtc_amt_1());
			pstmt.setInt   (8, clss.getEtc2_amt_1());
			pstmt.setInt   (9, clss.getDft_amt_1());
			pstmt.setInt   (10, clss.getDfee_amt_1());
			
			pstmt.setInt   (11, clss.getEtc3_amt_1());
			pstmt.setInt   (12, clss.getEtc4_amt_1());
			pstmt.setInt   (13, clss.getNo_v_amt_1());
			pstmt.setInt   (14, clss.getFdft_amt1_1());
			
			pstmt.setInt   (15, clss.getFine_amt_2());
			pstmt.setInt   (16, clss.getCar_ja_amt_2());
			pstmt.setInt   (17, clss.getDly_amt_2());
			pstmt.setInt   (18, clss.getEtc_amt_2());
			pstmt.setInt   (19, clss.getEtc2_amt_2());
			pstmt.setInt   (20, clss.getDft_amt_2());
			pstmt.setInt   (21, clss.getDfee_amt_2());
			
			pstmt.setInt   (22, clss.getEtc3_amt_2());
			pstmt.setInt   (23, clss.getEtc4_amt_2());
			pstmt.setInt   (24, clss.getNo_v_amt_2());
			pstmt.setInt   (25, clss.getFdft_amt1_2());
						
			pstmt.setInt   (26, clss.getDfee_amt_2_v());
			pstmt.setInt   (27, clss.getDft_amt_2_v());
			pstmt.setInt   (28, clss.getEtc_amt_2_v());
			pstmt.setInt   (29, clss.getEtc2_amt_2_v());
			pstmt.setInt   (30, clss.getEtc4_amt_2_v());
			
			pstmt.setString(31, clss.getReg_id());
			
			pstmt.setInt   (32, clss.getOver_amt_1());
			pstmt.setInt   (33, clss.getOver_amt_2());
			pstmt.setInt   (34, clss.getOver_amt_2_v());
								
			pstmt.executeUpdate();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[AccuDatabase:insertClsEtcSubIncom]\n"+e);			
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(rs != null) 		rs.close();
                if(stmt != null) 	stmt.close();
                if(pstmt != null)	pstmt.close();
               
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}
	
	
	/**
	 *	금액확정
	 */
	public boolean updateClsEtcTermYn(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		boolean flag = true;
		String query = "update cls_etc set term_yn = '2' "+
						" where rent_mng_id = ? and rent_l_cd = ?  ";  //2
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
					
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
			
		    pstmt.executeUpdate();

			conn.commit();
		    
	  	} catch (Exception e) {
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
	 *	해지일이 아닌 계산서 발행일
	 */
	public boolean updateClsReTaxDt(String rent_mng_id, String rent_l_cd, String r_tax_dt)
	{
		getConnection();
		boolean flag = true;
		String query = "update cls_etc set r_tax_dt = replace(?, '-', '') "+
						" where rent_mng_id = ? and rent_l_cd = ?  ";  //2
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
					
			pstmt.setString(1, r_tax_dt);		
			pstmt.setString(2, rent_mng_id);
			pstmt.setString(3, rent_l_cd);
			
		    pstmt.executeUpdate();

			conn.commit();
		    
	  	} catch (Exception e) {
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
	 *	해지의뢰중도해지 위약금 결재
	 */
	public boolean updateClsEtcDft(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		boolean flag = true;
		String query = " update cls_etc set DFT_SACTION_DT = to_char(sysdate,'YYYYMMdd')  "+
						" where rent_mng_id = ? and rent_l_cd = ?  ";  //2
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
					
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
			
		    pstmt.executeUpdate();

			conn.commit();
		    
	  	} catch (Exception e) {
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
	 *	해지차량선수금정산관련삭제 -
	 */
	/*
	public boolean deleteClsContEtc(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		boolean flag = true;
		String query = "delete from cls_cont_etc "+
						" where rent_mng_id = ? and rent_l_cd = ?  ";  //2
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
					
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
			
		    pstmt.executeUpdate();

			conn.commit();
		    
	  	} catch (Exception e) {
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
	*/
	
	/**
	 *	취소할 카드 승인일 변경 -
	 */
	public boolean updateClsContEtcRdate(String rent_mng_id, String rent_l_cd, String r_date)
	{
		getConnection();
		boolean flag = true;
		String query = "update cls_cont_etc set r_date = replace('"+r_date+ "', '-', '')" +
						" where rent_mng_id = ? and rent_l_cd = ?  ";  //2
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
					
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
			
		    pstmt.executeUpdate();

			conn.commit();
		    
	  	} catch (Exception e) {
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
	 *	해지차량선수금정산관련  -
	 */
	public int  getCntClsContEtc(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
	
		String query = "select count(0)  from cls_cont_etc "+
						" where rent_mng_id = ? and rent_l_cd = ?  ";  //2
		
		PreparedStatement pstmt = null;
	   ResultSet rs = null;
	   	int cnt = 0;
		try 
		{
		
			pstmt = conn.prepareStatement(query);
					
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
			
		  rs = pstmt.executeQuery();
			if(rs.next()){
				cnt = rs.getInt(1);
			}    
		    
	  	} catch (Exception e) {
	  		e.printStackTrace();
	  		
		} finally {
			try{	
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return cnt;
		}			
	}
		
		
	// 
	public int countDocSettleCls(String rent_l_cd)
	{
		getConnection();
	
		String query = "select count(0) from doc_settle "+
						" where doc_st = '11' and doc_id= ?  ";  //2
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int cnt = 0;
		try 
		{
			pstmt = conn.prepareStatement(query);
					
			pstmt.setString(1, rent_l_cd);
						
		 	rs = pstmt.executeQuery();
			if(rs.next()){
				cnt = rs.getInt(1);
			}    
		    
	  	} catch (Exception e) {
	  		e.printStackTrace();
	  		
		} finally {
			try{	
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return cnt;
		}			
	}
		
	
	/**
	 *	해지의뢰 문서처리 삭제 - 담당자 기안 후 발신처 결제권자  삭제
	 */
	 
	public boolean deleteDocSettleCls(String rent_l_cd)
	{
		getConnection();
		boolean flag = true;
		String query = "delete from doc_settle "+
						" where doc_st = '11' and doc_id = ?  ";  //2
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
					
			pstmt.setString(1, rent_l_cd);
					
		    pstmt.executeUpdate();

			conn.commit();
		    
	  	} catch (Exception e) {
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
			
		//계약해지의뢰 결재요청 - term_yn ->
	public boolean updateClsEtcTerm(String rent_mng_id, String rent_l_cd, String term_yn, String reg_id)
	{
		getConnection();
		boolean flag = true;
		String query = "update cls_etc set "+
							" term_yn =? , " +  //3
						 	" upd_id = ? , upd_dt=to_char(sysdate,'YYYYMMdd') "+  //2(1)
							" where rent_mng_id = ? and rent_l_cd = ?  ";  //2
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, term_yn);	
			pstmt.setString(2, reg_id);		
			pstmt.setString(3, rent_mng_id);
			pstmt.setString(4, rent_l_cd);
			
		    pstmt.executeUpdate();

			conn.commit();
		    
	  	} catch (Exception e) {
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
	
	
			/*해지의뢰상세내역조회  */
	public ClsEtcTaxBean getClsEtcTaxCase(String rent_mng_id, String rent_l_cd, int cls_seq)
	{
		getConnection();
		ClsEtcTaxBean ct = new ClsEtcTaxBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		
		query = " select "+
				" a.RENT_MNG_ID, a.RENT_L_CD, a.seq_no,  "+ 
				" a.tax_r_chk0, a.tax_r_chk1 , a.tax_r_chk2,  a.tax_r_chk3,  a.tax_r_chk4, a.tax_r_chk5, a.tax_r_chk6, "+  //7
				" a.rifee_s_amt_s, a.rfee_s_amt_s, a.dfee_amt_s, a.dft_amt_s, a.etc_amt_s, a.etc2_amt_s, a.etc4_amt_s, "+  //7
				" a.rifee_s_amt_v, a.rfee_s_amt_v, a.dfee_amt_v, a.dft_amt_v, a.etc_amt_v, a.etc2_amt_v, a.etc4_amt_v, "+  //7
				" a.rifee_s_amt, a.rfee_s_amt, a.dfee_amt, a.dft_amt, a.etc_amt, a.etc2_amt, a.etc4_amt, "+  //7
				" a.rifee_etc, a.rfee_etc, a.dfee_etc, a.dft_etc, a.etc_etc, a.etc2_etc, a.etc4_etc, "+  //7
				" a.tax_r_chk7, a.dfee_c_amt_s, a.dfee_c_amt_v, a.dfee_c_amt, a.dfee_c_etc,  "+  //5
				" a.r_rifee_s_amt_s, a.r_rfee_s_amt_s, a.r_dfee_amt_s, a.r_dft_amt_s, a.r_etc_amt_s, a.r_etc2_amt_s, a.r_etc4_amt_s, a.r_dfee_c_amt_s, "+  //8
				" a.r_rifee_s_amt_v, a.r_rfee_s_amt_v, a.r_dfee_amt_v, a.r_dft_amt_v, a.r_etc_amt_v, a.r_etc2_amt_v, a.r_etc4_amt_v, a.r_dfee_c_amt_v, "+  //8
				" a.tax_r_chk8, a.over_amt_s, a.over_amt_v, a.r_over_amt_s, a.r_over_amt_v, a.over_amt, a.over_etc "+  //7 
				" from cls_etc_tax a where  a.RENT_MNG_ID = ? and a.RENT_L_CD = ? and a.seq_no = ? ";
						
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
			pstmt.setInt(3, cls_seq);
			 
	    	rs = pstmt.executeQuery();	    
	        	
			while(rs.next())
			{ 
				ct.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				ct.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				ct.setSeq_no(rs.getInt("seq_no"));
				
				ct.setTax_r_chk0(rs.getString("tax_r_chk0")==null?"":rs.getString("tax_r_chk0"));
				ct.setTax_r_chk1(rs.getString("tax_r_chk1")==null?"":rs.getString("tax_r_chk1"));
				ct.setTax_r_chk2(rs.getString("tax_r_chk2")==null?"":rs.getString("tax_r_chk2"));
				ct.setTax_r_chk3(rs.getString("tax_r_chk3")==null?"":rs.getString("tax_r_chk3"));
				ct.setTax_r_chk4(rs.getString("tax_r_chk4")==null?"":rs.getString("tax_r_chk4"));
				ct.setTax_r_chk5(rs.getString("tax_r_chk5")==null?"":rs.getString("tax_r_chk5"));
				ct.setTax_r_chk6(rs.getString("tax_r_chk6")==null?"":rs.getString("tax_r_chk6"));
				
				ct.setRifee_s_amt_s(rs.getInt("RIFEE_S_AMT_S"));
				ct.setRfee_s_amt_s(rs.getInt("RFEE_S_AMT_S"));
				ct.setDfee_amt_s(rs.getInt("DFEE_AMT_S"));
				ct.setDft_amt_s(rs.getInt("DFT_AMT_S"));
				ct.setEtc_amt_s(rs.getInt("ETC_AMT_S"));
				ct.setEtc2_amt_s(rs.getInt("ETC2_AMT_S"));						
				ct.setEtc4_amt_s(rs.getInt("ETC4_AMT_S"));
				
				ct.setRifee_s_amt_v(rs.getInt("RIFEE_S_AMT_V"));
				ct.setRfee_s_amt_v(rs.getInt("RFEE_S_AMT_V"));
				ct.setDfee_amt_v(rs.getInt("DFEE_AMT_V"));
				ct.setDft_amt_v(rs.getInt("DFT_AMT_V"));
				ct.setEtc_amt_v(rs.getInt("ETC_AMT_V"));
				ct.setEtc2_amt_v(rs.getInt("ETC2_AMT_V"));						
				ct.setEtc4_amt_v(rs.getInt("ETC4_AMT_V"));
				
				ct.setRifee_s_amt(rs.getInt("RIFEE_S_AMT"));
				ct.setRfee_s_amt(rs.getInt("RFEE_S_AMT"));
				ct.setDfee_amt(rs.getInt("DFEE_AMT"));
				ct.setDft_amt(rs.getInt("DFT_AMT"));
				ct.setEtc_amt(rs.getInt("ETC_AMT"));
				ct.setEtc2_amt(rs.getInt("ETC2_AMT"));						
				ct.setEtc4_amt(rs.getInt("ETC4_AMT"));
				
				ct.setRifee_etc(rs.getString("rifee_etc")==null?"":rs.getString("rifee_etc"));
				ct.setRfee_etc(rs.getString("rfee_etc")==null?"":rs.getString("rfee_etc"));
				ct.setDfee_etc(rs.getString("dfee_etc")==null?"":rs.getString("dfee_etc"));
				ct.setDft_etc(rs.getString("dft_etc")==null?"":rs.getString("dft_etc"));
				ct.setEtc_etc(rs.getString("etc_etc")==null?"":rs.getString("etc_etc"));
				ct.setEtc2_etc(rs.getString("etc2_etc")==null?"":rs.getString("etc2_etc"));
				ct.setEtc4_etc(rs.getString("etc4_etc")==null?"":rs.getString("etc4_etc"));	
				
				ct.setTax_r_chk7(rs.getString("tax_r_chk7")==null?"":rs.getString("tax_r_chk7"));
				ct.setDfee_c_amt_s(rs.getInt("DFEE_C_AMT_S"));
				ct.setDfee_c_amt_v(rs.getInt("DFEE_C_AMT_V"));
				ct.setDfee_c_amt(rs.getInt("DFEE_C_AMT"));
				ct.setDfee_c_etc(rs.getString("dfee_c_etc")==null?"":rs.getString("dfee_c_etc"));
									
				ct.setR_rifee_s_amt_s(rs.getInt("R_RIFEE_S_AMT_S"));
				ct.setR_rfee_s_amt_s(rs.getInt("R_RFEE_S_AMT_S"));
				ct.setR_dfee_amt_s(rs.getInt("R_DFEE_AMT_S"));
				ct.setR_dft_amt_s(rs.getInt("R_DFT_AMT_S"));
				ct.setR_etc_amt_s(rs.getInt("R_ETC_AMT_S"));
				ct.setR_etc2_amt_s(rs.getInt("R_ETC2_AMT_S"));						
				ct.setR_etc4_amt_s(rs.getInt("R_ETC4_AMT_S"));
				ct.setR_dfee_c_amt_s(rs.getInt("R_DFEE_C_AMT_S"));
				
				ct.setR_rifee_s_amt_v(rs.getInt("R_RIFEE_S_AMT_V"));
				ct.setR_rfee_s_amt_v(rs.getInt("R_RFEE_S_AMT_V"));
				ct.setR_dfee_amt_v(rs.getInt("R_DFEE_AMT_V"));
				ct.setR_dft_amt_v(rs.getInt("R_DFT_AMT_V"));
				ct.setR_etc_amt_v(rs.getInt("R_ETC_AMT_V"));
				ct.setR_etc2_amt_v(rs.getInt("R_ETC2_AMT_V"));						
				ct.setR_etc4_amt_v(rs.getInt("R_ETC4_AMT_V"));
				ct.setR_dfee_c_amt_v(rs.getInt("R_DFEE_C_AMT_V"));
				
				
				ct.setTax_r_chk8(rs.getString("tax_r_chk8")==null?"":rs.getString("tax_r_chk8"));
				ct.setOver_amt_s(rs.getInt("OVER_AMT_S"));
				ct.setOver_amt_v(rs.getInt("OVER_AMT_V"));
				ct.setR_over_amt_s(rs.getInt("R_OVER_AMT_S"));
				ct.setR_over_amt_v(rs.getInt("R_OVER_AMT_V"));
				ct.setOver_amt(rs.getInt("OVER_AMT"));
				ct.setOver_etc(rs.getString("OVER_ETC")==null?"":rs.getString("OVER_ETC"));
							
			}
		} catch (SQLException e) {
			System.out.println("[AccuDatabase:getClsEtcTaxCase]\n"+e);	
			System.out.println(query);		
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ct;
		}
	} 
	
	
	
		/*해지 초과운행 내역조회  */
	public ClsEtcOverBean getClsEtcOver(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		ClsEtcOverBean co = new ClsEtcOverBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		
		query = " select "+
				" a.RENT_MNG_ID, a.RENT_L_CD,  "+ 
				" a.rent_days, a.cal_dist, a.first_dist, a.last_dist, a.real_dist, a.over_dist,  "+  //7			
				" a.add_dist, a.jung_dist, a.r_over_amt, a.m_over_amt, a.j_over_amt, a.m_saction_id, a.m_saction_dt, a.m_reason "+  //7 
				" from cls_etc_over a where  a.RENT_MNG_ID = ? and a.RENT_L_CD = ?  ";
						
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
				 
	    		rs = pstmt.executeQuery();	    
	        	
			while(rs.next())
			{ 
				co.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				co.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
									
				co.setRent_days(rs.getInt("rent_days"));
				co.setCal_dist(rs.getInt("cal_dist"));
				co.setFirst_dist(rs.getInt("first_dist"));
				co.setLast_dist(rs.getInt("last_dist"));
				co.setReal_dist(rs.getInt("real_dist"));
				co.setOver_dist(rs.getInt("over_dist"));
				co.setAdd_dist(rs.getInt("add_dist"));
				co.setJung_dist(rs.getInt("jung_dist"));
				co.setR_over_amt(rs.getInt("r_over_amt"));
				co.setM_over_amt(rs.getInt("m_over_amt"));
				co.setJ_over_amt(rs.getInt("j_over_amt"));
							
				co.setM_saction_id(rs.getString("m_saction_id")==null?"":rs.getString("m_saction_id"));
				co.setM_saction_dt(rs.getString("m_saction_dt")==null?"":rs.getString("m_saction_dt"));
				co.setM_reason(rs.getString("m_reason")==null?"":rs.getString("m_reason"));
							
			}
		} catch (SQLException e) {
			System.out.println("[AccuDatabase:getClsEtcOver]\n"+e);	
			System.out.println(query);		
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return co;
		}
	} 
	
	 /**
     *  대여료 대손처리 = 미납+미도래 (해지정산금에 반영) 수정
     */
    public boolean updateScdFeeCls(String rent_mng_id, String rent_l_cd, String cls_dt, String user_id) 
    {
      	getConnection();
        PreparedStatement pstmt = null;
        String query = "";
      	boolean flag = true;
             
 	//	query = "update scd_fee	set bill_yn='N', update_id = ?, update_dt = to_char(sysdate,'YYYYMMdd') where rent_mng_id=? and rent_l_cd = ? and rc_yn='0' and dly_days <> '0'"; 

     	query = "update scd_fee	set bill_yn='N', update_id = ?, update_dt = to_char(sysdate,'YYYYMMdd')  where rent_mng_id=? and rent_l_cd = ? and rc_yn='0' "; 
     
         
       try{
            conn.setAutoCommit(false);
           
            pstmt = conn.prepareStatement(query);            
            pstmt.setString(1, user_id	);
            pstmt.setString(2, rent_mng_id	);
            pstmt.setString(3, rent_l_cd	);
            
            pstmt.executeUpdate();
             
            pstmt.close();
            conn.commit();

    
    	} catch (Exception e) {
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
     *  대여료 계산서 발행관련 처리 = 선납대여료 균등인 경우는 이미  입금은 처리됨  수정
     */
    public boolean updateScdFeeCls4(String rent_mng_id, String rent_l_cd, String fee_tm, String user_id) 
    {
      	getConnection();
        PreparedStatement pstmt = null;
        String query = "";
      	boolean flag = true;
        
      	int n_fee_tm = Integer.parseInt(fee_tm);
      	
 	//	query = "update scd_fee	set bill_yn='N', update_id = ?, update_dt = to_char(sysdate,'YYYYMMdd') where rent_mng_id=? and rent_l_cd = ? and rc_yn='0' and dly_days <> '0'"; 

     	query = "update scd_fee	set bill_yn='N', update_id = ?, update_dt = to_char(sysdate,'YYYYMMdd')  where rent_mng_id=? and rent_l_cd = ? and  tm_st2 = '4' and to_number(fee_tm) > ? ";
     
         
       try{
            conn.setAutoCommit(false);
           
            pstmt = conn.prepareStatement(query);            
            pstmt.setString(1, user_id	);
            pstmt.setString(2, rent_mng_id	);
            pstmt.setString(3, rent_l_cd	);
            pstmt.setInt(4, n_fee_tm	);
                        
            pstmt.executeUpdate();
             
            pstmt.close();
            conn.commit();

    
    	} catch (Exception e) {
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
     *  대여료n - 웰렌트인 경우 bill_yn = 'N'로 변경정
     */
    public boolean updateScdFeeClsBill(String rent_mng_id, String rent_l_cd, String cls_dt, String user_id) 
    {
      	getConnection();
        PreparedStatement pstmt = null;
        String query = "";
      	boolean flag = true;
             
 	//	query = "update scd_fee	set bill_yn='N', update_id = ?, update_dt = to_char(sysdate,'YYYYMMdd') where rent_mng_id=? and rent_l_cd = ? and rc_yn='0' and dly_days <> '0'"; 

     	query = "update scd_fee	set bill_yn='N', update_id = ?, update_dt = to_char(sysdate,'YYYYMMdd')  where rent_mng_id=? and rent_l_cd = ?  "; 
     
         
       try{
            conn.setAutoCommit(false);
           
            pstmt = conn.prepareStatement(query);            
            pstmt.setString(1, user_id	);
            pstmt.setString(2, rent_mng_id	);
            pstmt.setString(3, rent_l_cd	);
            
            pstmt.executeUpdate();
             
            pstmt.close();
            conn.commit();

    
    	} catch (Exception e) {
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
	
	
	public Hashtable getSettleTaxRemain(String m_id, String l_cd, String cls_dt, String fee_tm)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		String cls_dt1 = "";
		String cls_dt2 = "";
		String cls_dt3 = "";

		if(cls_dt.equals("")){
			cls_dt1 = "sysdate";
			cls_dt2 = "to_char(sysdate,'YYYYMMDD')";
			cls_dt3 = cls_dt2;
		}else{
			cls_dt1 = "to_date('"+cls_dt+"', 'YYYYMMDD')";
			cls_dt2 = cls_dt;
			cls_dt3 = "'"+cls_dt+"'";
		}

		query = " select /*+ INDEX(a.SCD_FEE_PK) */ a.rent_mng_id, a.rent_l_cd,"+
				"		trunc( months_between( "+cls_dt1+"+1,"+
				"			   to_date(min(decode(a.use_s_dt, '', to_char(add_months(to_date(b.rent_start_dt,'YYYYMMDD'),  (a.fee_tm-nvl(c.p_cnt,0)-1)),'YYYYMMDD'),a.use_s_dt)),'YYYYMMDD')"+
				"		) ) t_mon,\n"+
				"		trunc( "+cls_dt1+"+1"+
				"		       -"+
				"		       add_months( to_date(min(decode(a.use_s_dt, '', to_char(add_months(to_date(b.rent_start_dt,'YYYYMMDD'),  (a.fee_tm-nvl(c.p_cnt,0)-1)),'YYYYMMDD'),a.use_s_dt)),'YYYYMMDD'),"+
				"		                   trunc( months_between( "+cls_dt1+"+1, to_date(min(decode(a.use_s_dt, '', to_char(add_months(to_date(b.rent_start_dt,'YYYYMMDD'),  (a.fee_tm-nvl(c.p_cnt,0)-1)),'YYYYMMDD'),a.use_s_dt)),'YYYYMMDD') ) )"+
				"		                 )"+
				"		) t_day \n"+
				"		from scd_fee a, fee b, (select rent_l_cd, count(*) p_cnt from scd_fee where tm_st2='2' group by rent_l_cd) c \n"+
				"		where a.rent_mng_id='"+m_id+"' and a.rent_l_cd='"+l_cd+"' \n"+
				"		and decode(a.use_s_dt, '', to_char(add_months(to_date(b.rent_start_dt,'YYYYMMDD'),  (a.fee_tm-nvl(c.p_cnt,0)-1)),'YYYYMMDD'), a.use_s_dt) <= "+cls_dt3+""+
				"		and a.tm_st1='0' and to_number(a.fee_tm) > " + fee_tm + " and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd(+) group by a.rent_mng_id, a.rent_l_cd";
			//	"		and a.rc_amt = 0 and a.tm_st1='0' and to_number(a.fee_tm) > " + fee_tm + " and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd(+) group by a.rent_mng_id, a.rent_l_cd";
				
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
		} catch (SQLException e) {
			System.out.println("[AccDatabase:getSettleTaxRemain]\n"+e);			
			System.out.println("[AccDatabase:getSettleTaxRemain]\n"+query);			
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
			
    //해지정산시 미납대여료관련 기발행세금계산서 발행일, 사용기간
	public Hashtable getLastFeeTaxDt(String rent_l_cd, String fee_tm)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";		
						
		query = " select  a.tax_dt, b.item_dt1, b.item_dt2 , b.item_supply "+
 				"  from   tax a, tax_item_list b "+
				"  where  a.item_id = b.item_id(+) "+
 				"    and  b.rent_l_cd= '"+rent_l_cd+"' and b.gubun= '1' and a.tax_st = 'O' and b.tm = '"+ fee_tm + "' order by b.reg_dt desc "; //대여료
 			
 		
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
		} catch (SQLException e) {
			System.out.println("[AccDatabase:getSettleTaxRemain]\n"+e);			
			System.out.println("[AccDatabase:getSettleTaxRemain]\n"+query);			
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
	
		//해지정산시 기청구된 면책금중 계산서미발행 금액
	public int  getCarServiceBillNo( String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";		
		int car_ja_no_amt = 0;		
				
		query = " SELECT sum(se.ext_s_amt + se.ext_v_amt) car_ja_no_amt "+
				"	FROM service a, scd_ext se WHERE se.ext_st = '3' and se.rent_mng_id = a.rent_mng_id "+
				"	and se.rent_l_cd = a.rent_l_cd and se.ext_id = a.serv_id and (se.ext_s_amt + se.ext_v_amt)  <> 0 "+
				"	and se.ext_pay_dt is null and nvl(a.no_dft_yn,'N')<>'Y' "+
				"	and se.rent_mng_id = '"+ rent_mng_id + "' and se.rent_l_cd = '"+rent_l_cd+"' and nvl(a.bill_doc_yn, '0')='0'";
		 					
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		if(rs.next())
			{		
				car_ja_no_amt = rs.getInt(1);
			}

		} catch (SQLException e) {
			System.out.println("[AccuDatabase:getCarServiceBillNo]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return car_ja_no_amt;
		}
	}
	
		//해지정산시 기청구된 면책금중 계산서미발행 금액
	public int  getClsEtcCarNoAmt( String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";		
		int car_ja_no_amt = 0;		
				
		query = " SELECT car_ja_no_amt "+
				"	FROM cls_etc "+
				"	where rent_mng_id = '"+ rent_mng_id + "' and rent_l_cd = '"+rent_l_cd+"'";
		 					
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		if(rs.next())
			{		
				car_ja_no_amt = rs.getInt(1);
			}

		} catch (SQLException e) {
			System.out.println("[AccuDatabase:getClsEtcCarNoAmt]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return car_ja_no_amt;
		}
	}
	
	
		//해지정산시 기청구된 면책금중 계산서미발행 금액
	public int  getCarSoldCnt( String car_mng_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";		
		int car_cnt = 0;		
				
		query = " select count(a.tax_dt) "+
 			      "	  from   tax a, tax_item_list b "+
			       "	  where  a.item_id = b.item_id(+)  "+
 			      "	    and  a.car_mng_id= '"+car_mng_id+"'  and a.tax_st = 'O' and a.gubun = '6'  ";
 		 		
				 					
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		if(rs.next())
			{		
				car_cnt = rs.getInt(1);
			}

		} catch (SQLException e) {
			System.out.println("[AccuDatabase:getCarSoldCnt]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return car_cnt;
		}
	}
	
	/**
	 *	회계처리
	 */
	public boolean updateClsEtcAuto(String rent_mng_id, String rent_l_cd, String gubun)
	{
		getConnection();
		boolean flag = true;
		String query = "update cls_etc set autodoc_yn = ? "+
						" where rent_mng_id = ? and rent_l_cd = ?  ";  //2
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, gubun);		
			pstmt.setString(2, rent_mng_id);
			pstmt.setString(3, rent_l_cd);
			
		    pstmt.executeUpdate();

			conn.commit();
		    
	  	} catch (Exception e) {
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
	 *	 매입옵션일을 해지일로 변경
	 */
	public boolean updateClsContDt(String rent_mng_id, String rent_l_cd, String m_dt)
	{
		getConnection();
		boolean flag = true;
		String query = "update cls_cont set cls_dt = replace(?, '-', '') "+
						" where rent_mng_id = ? and rent_l_cd = ?  ";  //2
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, m_dt);		
			pstmt.setString(2, rent_mng_id);
			pstmt.setString(3, rent_l_cd);
			
		    pstmt.executeUpdate();

			conn.commit();
		    
	  	} catch (Exception e) {
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
	 *	회수된 차량인 경우 회수날짜 
	 */
	 
	 
	public boolean updateCarCallIn(String rent_mng_id, String rent_l_cd, String cls_dt)
	{
		getConnection();
		boolean flag = true;
		
		String query1 = " SELECT count(*) from car_call_in  where rent_mng_id =  '"+ rent_mng_id + "' and rent_l_cd = '"+rent_l_cd+"' and out_dt is null ";  //2
				
		String query = " update car_call_in set out_dt = replace(?, '-', ''), out_id = '999999' "+
						" where rent_mng_id = ? and rent_l_cd = ? and out_dt is null ";  //2
		
		PreparedStatement pstmt = null;
		Statement stmt = null;
		ResultSet rs = null;
 		int count = 0;
 		
		try 
		{
			conn.setAutoCommit(false);
			
			stmt = conn.createStatement();
		    rs = stmt.executeQuery(query1);

            if(rs.next())        	  count = rs.getInt(1);
     		  
      		if (count > 0)  {     		
				pstmt = conn.prepareStatement(query);
						
				pstmt.setString(1, cls_dt);		
				pstmt.setString(2, rent_mng_id);
				pstmt.setString(3, rent_l_cd);
				
			    pstmt.executeUpdate();
			    pstmt.close();
			}
			
			rs.close();
     		stmt.close();
      		
			conn.commit();
		    
	  	} catch (Exception e) {
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
				if(stmt != null)	stmt.close();
				if(rs != null )		rs.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	} 
	
			/*해지의뢰상세내역조회  */
	public ClsEtcTaxBean getClsEtcTaxCase(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		ClsEtcTaxBean ct = new ClsEtcTaxBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		
		
		query = "  select a.st_nm, a.cls_dt, a.rent_l_cd, a.rent_mng_id, a.rent_l_cd, a.brch_id, a.client_id, a.site_id, a.firm_nm, a.car_no, a.car_nm, \n"+
				"   '' tax_r_chk0, '' tax_r_chk1 , '' tax_r_chk2, '' tax_r_chk3,  '' tax_r_chk4, '' tax_r_chk5, '' tax_r_chk6, '' tax_r_chk7, \n"+  //8
				"   '' rifee_etc, '' rfee_etc , '' dfee_c_etc, '' dfee_etc,  '' dft_etc, '' etc_etc, '' etc2_etc, '' etc4_etc, \n"+//8
				"  0 rifee_s_amt_s, 0 rfee_s_amt_s, 0 dfee_c_amt_s ,  0 rifee_s_amt_v, 0 rfee_s_amt_v, 0 dfee_c_amt_v,  \n"+
				"  nvl(dfee_amt_s, nfee_amt) dfee_amt_s , nvl(dfee_amt_v, trunc(nfee_amt*0.1)) dfee_amt_v, \n"+
				"  nvl(dft_amt_s, dft_amt)   dft_amt_s ,  nvl(dft_amt_v, trunc(dft_amt*0.1)) dft_amt_v, \n"+
				"  nvl(etc_amt_s, etc_amt)   etc_amt_s ,  nvl(etc_amt_v, trunc(etc_amt*0.1)) etc_amt_v, \n"+
				"  nvl(etc2_amt_s, etc2_amt) etc2_amt_s , nvl(etc2_amt_v, trunc(etc2_amt*0.1)) etc2_amt_v, \n"+
				"  nvl(etc4_amt_s, etc4_amt) etc4_amt_s , nvl(etc4_amt_v, trunc(etc4_amt*0.1)) etc4_amt_v,  \n"+	  
				"  0 rifee_s_amt, 0  rfee_s_amt, 0 dfee_c_amt,  nvl(dfee_amt_s, nfee_amt) +  nvl(dfee_amt_v, trunc(nfee_amt*0.1)) dfee_amt, \n"+	 
				"  nvl(dft_amt_s, dft_amt) +  nvl(dft_amt_v, trunc(dft_amt*0.1)) dft_amt , nvl(etc_amt_s, etc_amt) + nvl(etc_amt_v, trunc(etc_amt*0.1)) etc_amt,  \n"+
				"  nvl(etc2_amt_s, etc2_amt)+ nvl(etc2_amt_v, trunc(etc2_amt*0.1)) etc2_amt, nvl(etc4_amt_s, etc4_amt) +  nvl(etc4_amt_v, trunc(etc4_amt*0.1)) etc4_amt,  \n"+
				"  0 r_rifee_s_amt_s, 0 r_rfee_s_amt_s, 0 r_dfee_c_amt_s ,  0 r_dfee_amt_s, 0 r_dft_amt_s, 0 r_etc_amt_s, 0 r_etc2_amt_s, 0 r_etc4_amt_s, \n"+
				"  0 r_rifee_s_amt_v, 0 r_rfee_s_amt_v, 0 r_dfee_c_amt_v ,  0 r_dfee_amt_v, 0 r_dft_amt_v, 0 r_etc_amt_v, 0 r_etc2_amt_v, 0 r_etc4_amt_v \n"+
				"		  from ( \n"+
				"		 select	 '해지정산' st_nm, a.cls_dt, a.rent_mng_id, c.rent_l_cd, c.brch_id, d.client_id, c.r_site as site_id, d.firm_nm, e.car_no, e.car_nm,  \n"+
				"				 ct.dfee_amt_s - ct.r_dfee_amt_s  as dfee_amt_s, \n"+
				"				 ct.dft_amt_s  - ct.r_dft_amt_s   as dft_amt_s, \n"+
				"				 ct.etc_amt_s  - ct.r_etc_amt_s   as etc_amt_s, \n"+
				"				 ct.etc2_amt_s - ct.r_etc2_amt_s  as etc2_amt_s, \n"+
				"				 ct.etc4_amt_s - ct.r_etc4_amt_s  as etc4_amt_s, \n"+
				"				 ct.dfee_amt_v - ct.r_dfee_amt_v  as dfee_amt_v, \n"+
				"				 ct.dft_amt_v  - ct.r_dft_amt_v   as dft_amt_v, \n"+
				"				 ct.etc_amt_v  - ct.r_etc_amt_v   as etc_amt_v, \n"+
				"				 ct.etc2_amt_v - ct.r_etc2_amt_v  as etc2_amt_v, \n"+
				"				 ct.etc4_amt_v - ct.r_etc4_amt_v  as etc4_amt_v, \n"+
				"				 a.nfee_amt, a.dft_amt, a.etc_amt, a.etc2_amt, a.etc4_amt \n"+
				"					 from cls_cont a, cont c, client d, car_reg e,  \n"+
				"					 (select aa.* from tax aa where aa.tax_st='O' and aa.tax_g like '%해지%위약금%' and aa.tax_supply <> 0) k ,  \n"+
				"					 (select rent_mng_id, rent_l_cd,  \n"+
				"	                      sum(decode(seq_no, 1, nvl(dfee_amt_s,0), 0)) as dfee_amt_s, sum(decode(seq_no, 1, nvl(dft_amt_s,0), 0))    as dft_amt_s, \n"+
				"	                      sum(decode(seq_no, 1, nvl(etc_amt_s,0) , 0)) as etc_amt_s,  sum(decode(seq_no, 1, nvl(etc2_amt_s,0), 0))   as etc2_amt_s, \n"+ 
				"	                      sum(decode(seq_no, 1, nvl(etc4_amt_s,0), 0)) as etc4_amt_s, \n"+
				"	                      sum(decode(seq_no, 1, nvl(dfee_amt_v,0), 0)) as dfee_amt_v, sum(decode(seq_no, 1, nvl(dft_amt_v,0), 0))    as dft_amt_v, \n"+
				"	                      sum(decode(seq_no, 1, nvl(etc_amt_v,0), 0))  as etc_amt_v,  sum(decode(seq_no, 1, nvl(etc2_amt_v,0), 0))   as etc2_amt_v, \n"+ 
				"	                      sum(decode(seq_no, 1, nvl(etc4_amt_v,0), 0)) as etc4_amt_v, \n"+
				"	                      sum(decode(tax_r_chk3, 'Y', nvl(r_dfee_amt_s,0), 0)) as r_dfee_amt_s,  sum(decode(tax_r_chk4, 'Y', nvl(r_dft_amt_s,0), 0))  as r_dft_amt_s, \n"+
				"	                      sum(decode(tax_r_chk5, 'Y', nvl(r_etc_amt_s,0), 0))  as r_etc_amt_s,   sum(decode(tax_r_chk6, 'Y', nvl(r_etc2_amt_s,0), 0)) as r_etc2_amt_s, \n"+
				"	                      sum(decode(tax_r_chk7, 'Y', nvl(r_etc4_amt_s,0), 0)) as r_etc4_amt_s, \n"+
				"	                      sum(decode(tax_r_chk3, 'Y', nvl(r_dfee_amt_v,0), 0)) as r_dfee_amt_v,  sum(decode(tax_r_chk4, 'Y', nvl(r_dft_amt_v,0), 0))  as r_dft_amt_v, \n"+
				"	                      sum(decode(tax_r_chk5, 'Y', nvl(r_etc_amt_v,0), 0))  as r_etc_amt_v,   sum(decode(tax_r_chk6, 'Y', nvl(r_etc2_amt_v,0), 0)) as r_etc2_amt_v, \n"+
				"	                      sum(decode(tax_r_chk7, 'Y', nvl(r_etc4_amt_v,0), 0)) as r_etc4_amt_v \n"+
				"	                      from cls_etc_tax  \n"+
				"	                      group by rent_mng_id, rent_l_cd   ) ct \n"+	  	 			 
				"					 where a.cls_st in ('1','2')  and a.fdft_amt2 > 0 \n"+
				"					 and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd  \n"+
				"					 and a.rent_mng_id=ct.rent_mng_id(+) and a.rent_l_cd=ct.rent_l_cd(+)  \n"+
				"					 and c.client_id=d.client_id  \n"+
				"					 and c.car_mng_id=e.car_mng_id(+)  \n"+
				"					 and c.client_id=k.client_id(+) and c.rent_l_cd=k.rent_l_cd(+) and k.rent_l_cd is null  \n"+
				"				     and a.cls_dt > '20071231'  ) a \n"+
				"			where  a.RENT_MNG_ID = ? and a.RENT_L_CD = ?  \n"+
				"			 order by a.cls_dt desc ";
	  									
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
	    	rs = pstmt.executeQuery();	    
	        	
			while(rs.next())
			{ 
				ct.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				ct.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
							
				ct.setTax_r_chk0(rs.getString("tax_r_chk0")==null?"":rs.getString("tax_r_chk0"));
				ct.setTax_r_chk1(rs.getString("tax_r_chk1")==null?"":rs.getString("tax_r_chk1"));
				ct.setTax_r_chk2(rs.getString("tax_r_chk2")==null?"":rs.getString("tax_r_chk2"));
				ct.setTax_r_chk3(rs.getString("tax_r_chk3")==null?"":rs.getString("tax_r_chk3"));
				ct.setTax_r_chk4(rs.getString("tax_r_chk4")==null?"":rs.getString("tax_r_chk4"));
				ct.setTax_r_chk5(rs.getString("tax_r_chk5")==null?"":rs.getString("tax_r_chk5"));
				ct.setTax_r_chk6(rs.getString("tax_r_chk6")==null?"":rs.getString("tax_r_chk6"));
				ct.setTax_r_chk7(rs.getString("tax_r_chk7")==null?"":rs.getString("tax_r_chk7"));
				
				ct.setRifee_s_amt_s(rs.getInt("RIFEE_S_AMT_S"));
				ct.setRfee_s_amt_s(rs.getInt("RFEE_S_AMT_S"));
				ct.setDfee_amt_s(rs.getInt("DFEE_AMT_S"));
				ct.setDft_amt_s(rs.getInt("DFT_AMT_S"));
				ct.setEtc_amt_s(rs.getInt("ETC_AMT_S"));
				ct.setEtc2_amt_s(rs.getInt("ETC2_AMT_S"));						
				ct.setEtc4_amt_s(rs.getInt("ETC4_AMT_S"));
				ct.setDfee_c_amt_s(rs.getInt("DFEE_C_AMT_S"));
				
				ct.setRifee_s_amt_v(rs.getInt("RIFEE_S_AMT_V"));
				ct.setRfee_s_amt_v(rs.getInt("RFEE_S_AMT_V"));
				ct.setDfee_amt_v(rs.getInt("DFEE_AMT_V"));
				ct.setDft_amt_v(rs.getInt("DFT_AMT_V"));
				ct.setEtc_amt_v(rs.getInt("ETC_AMT_V"));
				ct.setEtc2_amt_v(rs.getInt("ETC2_AMT_V"));						
				ct.setEtc4_amt_v(rs.getInt("ETC4_AMT_V"));
				ct.setDfee_c_amt_v(rs.getInt("DFEE_C_AMT_V"));
				
				ct.setRifee_s_amt(rs.getInt("RIFEE_S_AMT"));
				ct.setRfee_s_amt(rs.getInt("RFEE_S_AMT"));
				ct.setDfee_amt(rs.getInt("DFEE_AMT"));
				ct.setDft_amt(rs.getInt("DFT_AMT"));
				ct.setEtc_amt(rs.getInt("ETC_AMT"));
				ct.setEtc2_amt(rs.getInt("ETC2_AMT"));						
				ct.setEtc4_amt(rs.getInt("ETC4_AMT"));
				ct.setDfee_c_amt(rs.getInt("DFEE_C_AMT"));
				
				ct.setRifee_etc(rs.getString("rifee_etc")==null?"":rs.getString("rifee_etc"));
				ct.setRfee_etc(rs.getString("rfee_etc")==null?"":rs.getString("rfee_etc"));
				ct.setDfee_etc(rs.getString("dfee_etc")==null?"":rs.getString("dfee_etc"));
				ct.setDft_etc(rs.getString("dft_etc")==null?"":rs.getString("dft_etc"));
				ct.setEtc_etc(rs.getString("etc_etc")==null?"":rs.getString("etc_etc"));
				ct.setEtc2_etc(rs.getString("etc2_etc")==null?"":rs.getString("etc2_etc"));
				ct.setEtc4_etc(rs.getString("etc4_etc")==null?"":rs.getString("etc4_etc"));	
				ct.setDfee_c_etc(rs.getString("dfee_c_etc")==null?"":rs.getString("dfee_c_etc"));
																
				ct.setR_rifee_s_amt_s(rs.getInt("R_RIFEE_S_AMT_S"));
				ct.setR_rfee_s_amt_s(rs.getInt("R_RFEE_S_AMT_S"));
				ct.setR_dfee_amt_s(rs.getInt("R_DFEE_AMT_S"));
				ct.setR_dft_amt_s(rs.getInt("R_DFT_AMT_S"));
				ct.setR_etc_amt_s(rs.getInt("R_ETC_AMT_S"));
				ct.setR_etc2_amt_s(rs.getInt("R_ETC2_AMT_S"));						
				ct.setR_etc4_amt_s(rs.getInt("R_ETC4_AMT_S"));
				ct.setR_dfee_c_amt_s(rs.getInt("R_DFEE_C_AMT_S"));
				
				ct.setR_rifee_s_amt_v(rs.getInt("R_RIFEE_S_AMT_V"));
				ct.setR_rfee_s_amt_v(rs.getInt("R_RFEE_S_AMT_V"));
				ct.setR_dfee_amt_v(rs.getInt("R_DFEE_AMT_V"));
				ct.setR_dft_amt_v(rs.getInt("R_DFT_AMT_V"));
				ct.setR_etc_amt_v(rs.getInt("R_ETC_AMT_V"));
				ct.setR_etc2_amt_v(rs.getInt("R_ETC2_AMT_V"));						
				ct.setR_etc4_amt_v(rs.getInt("R_ETC4_AMT_V"));
				ct.setR_dfee_c_amt_v(rs.getInt("R_DFEE_C_AMT_V"));
							
			}
		} catch (SQLException e) {
			System.out.println("[AccuDatabase:getClsEtcTaxCase]\n"+e);	
			System.out.println(query);		
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ct;
		}
	} 
	
		/**
	 *	해지세금계산서내역 insert
	 */
	public boolean insertClsEtcTaxAfter(ClsEtcTaxBean ct)
	{
		getConnection();
		boolean flag = true;
		String query_seq = "";
		int seq = 0;
	 
		String query = "insert into cls_etc_tax ("+
							" RENT_MNG_ID,	RENT_L_CD,	seq_no,	 "+ //3
							" tax_r_chk0, tax_r_chk1, tax_r_chk2, tax_r_chk3, tax_r_chk4, tax_r_chk5, tax_r_chk6, tax_r_chk7,"+  //8
						 	" rifee_s_amt_s, rfee_s_amt_s, dfee_c_amt_s, dfee_amt_s, dft_amt_s, etc_amt_s, etc2_amt_s, etc4_amt_s,"+ //8
						 	" rifee_s_amt_v, rfee_s_amt_v, dfee_c_amt_v, dfee_amt_v, dft_amt_v, etc_amt_v, etc2_amt_v, etc4_amt_v,"+ //8
						 	" rifee_s_amt,   rfee_s_amt,   dfee_c_amt,   dfee_amt,   dft_amt,   etc_amt,   etc2_amt,   etc4_amt, "+ //8
						 	" rifee_etc,   rfee_etc,    dfee_c_etc,      dfee_etc,   dft_etc,   etc_etc,   etc2_etc,   etc4_etc, "+ //8
						 	" r_rifee_s_amt_s, r_rfee_s_amt_s, r_dfee_c_amt_s, r_dfee_amt_s, r_dft_amt_s, r_etc_amt_s, r_etc2_amt_s, r_etc4_amt_s, "+ //8
						  	" r_rifee_s_amt_v, r_rfee_s_amt_v, r_dfee_c_amt_v, r_dfee_amt_v, r_dft_amt_v, r_etc_amt_v, r_etc2_amt_v, r_etc4_amt_v,  "+ //8
							" reg_dt, reg_id ) values( "+  //2
						 	" ?, ?, ?, "+  //3
							" ?, ?, ?, ?, ?, ?, ?, ?, " + //8
						    " ?, ?, ?, ?, ?, ?, ?, ?, " + //8
							" ?, ?, ?, ?, ?, ?, ?, ?, " + //8
						    " ?, ?, ?, ?, ?, ?, ?, ?, " + //8
							" ?, ?, ?, ?, ?, ?, ?, ?, " + //8
							" ?, ?, ?, ?, ?, ?, ?, ?, " + //8
							" ?, ?, ?, ?, ?, ?, ?, ?, " + //8
							" to_char(sysdate,'YYYYMMDD'), ? ) ";  //2(1)


		query_seq = "select nvl(max(seq_no)+1, 1)  from cls_etc_tax where rent_mng_id = '" + ct.getRent_mng_id() + "' and rent_l_cd = '" + ct.getRent_l_cd() + "'";	
		        
		        							
		PreparedStatement pstmt = null;
			
		ResultSet rs = null;
		Statement stmt = null;
		
		try 
		{
			conn.setAutoCommit(false);
			
			stmt = conn.createStatement();
            rs = stmt.executeQuery(query_seq);
         //   System.out.println(query_seq);
            if(rs.next())
            	seq = rs.getInt(1);
            rs.close();
			stmt.close();
				
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, ct.getRent_mng_id());
			pstmt.setString(2, ct.getRent_l_cd());
			pstmt.setInt(3, seq);
			
			pstmt.setString(4, ct.getTax_r_chk0());
			pstmt.setString(5, ct.getTax_r_chk1());
			pstmt.setString(6, ct.getTax_r_chk2());
			pstmt.setString(7, ct.getTax_r_chk3());
			pstmt.setString(8, ct.getTax_r_chk4());
			pstmt.setString(9, ct.getTax_r_chk5());
			pstmt.setString(10, ct.getTax_r_chk6()); 
			pstmt.setString(11, ct.getTax_r_chk7());  //8
				
			pstmt.setInt(12, ct.getRifee_s_amt_s());
			pstmt.setInt(13, ct.getRfee_s_amt_s());
			pstmt.setInt(14, ct.getDfee_c_amt_s());
			pstmt.setInt(15, ct.getDfee_amt_s());
			pstmt.setInt(16, ct.getDft_amt_s());
			pstmt.setInt(17, ct.getEtc_amt_s());
			pstmt.setInt(18, ct.getEtc2_amt_s());
			pstmt.setInt(19, ct.getEtc4_amt_s()); //8
			
			pstmt.setInt(20, ct.getRifee_s_amt_v());
			pstmt.setInt(21, ct.getRfee_s_amt_v());
			pstmt.setInt(22, ct.getDfee_c_amt_v());
			pstmt.setInt(23, ct.getDfee_amt_v());
			pstmt.setInt(24, ct.getDft_amt_v());
			pstmt.setInt(25, ct.getEtc_amt_v());
			pstmt.setInt(26, ct.getEtc2_amt_v());
			pstmt.setInt(27, ct.getEtc4_amt_v()); //8
			
			pstmt.setInt(28, ct.getRifee_s_amt());
			pstmt.setInt(29, ct.getRfee_s_amt());			
			pstmt.setInt(30, ct.getDfee_c_amt());
			pstmt.setInt(31, ct.getDfee_amt());
			pstmt.setInt(32, ct.getDft_amt());
			pstmt.setInt(33, ct.getEtc_amt());
			pstmt.setInt(34, ct.getEtc2_amt());
			pstmt.setInt(35, ct.getEtc4_amt()); //8
			
			pstmt.setString(36, ct.getRifee_etc());
			pstmt.setString(37, ct.getRfee_etc());
			pstmt.setString(38, ct.getDfee_c_etc());
			pstmt.setString(39, ct.getDfee_etc());
			pstmt.setString(40, ct.getDft_etc());
			pstmt.setString(41, ct.getEtc_etc());
			pstmt.setString(42, ct.getEtc2_etc());
			pstmt.setString(43, ct.getEtc4_etc()); //8
							
			pstmt.setInt(44, ct.getR_rifee_s_amt_s());
			pstmt.setInt(45, ct.getR_rfee_s_amt_s());
			pstmt.setInt(46, ct.getR_dfee_c_amt_s());  
			pstmt.setInt(47, ct.getR_dfee_amt_s());
			pstmt.setInt(48, ct.getR_dft_amt_s());
			pstmt.setInt(49, ct.getR_etc_amt_s());
			pstmt.setInt(50, ct.getR_etc2_amt_s());
			pstmt.setInt(51, ct.getR_etc4_amt_s());  //8
					
			pstmt.setInt(52, ct.getR_rifee_s_amt_v());
			pstmt.setInt(53, ct.getR_rfee_s_amt_v());
			pstmt.setInt(54, ct.getR_dfee_c_amt_v());	  
			pstmt.setInt(55, ct.getR_dfee_amt_v());
			pstmt.setInt(56, ct.getR_dft_amt_v());
			pstmt.setInt(57, ct.getR_etc_amt_v());
			pstmt.setInt(58, ct.getR_etc2_amt_v());
			pstmt.setInt(59, ct.getR_etc4_amt_v());  	//8
					
			pstmt.setString(60, ct.getReg_id());
								
			pstmt.executeUpdate();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[AccuDatabase:insertClsEtcTaxAfter]\n"+e);			
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);		
			    if(rs != null)	rs.close();
				if(stmt != null)	stmt.close();	  
                if(pstmt != null)	pstmt.close();
               
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}
	
  
	/**
	 *	회계처리 - 젼표발생후 끝전의 문제 있는 경우
	 */
	public boolean updateClsContReJungsan(String rent_mng_id, String rent_l_cd, int no_v_amt, int fdft_amt1, int fdft_amt2, int cls_s_amt, int cls_v_amt, String user_id  )
	{
		getConnection();
		boolean flag = true;
		String query = "update cls_cont set no_v_amt = ?, fdft_amt1 = ?, fdft_amt2 = ?, cls_s_amt = ?, cls_v_amt = ?  "+
						" where rent_mng_id = ? and rent_l_cd = ?  ";  //2
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			
			pstmt.setInt(1, no_v_amt);
			pstmt.setInt(2, fdft_amt1);
			pstmt.setInt(3, fdft_amt2);
			pstmt.setInt(4, cls_s_amt);
			pstmt.setInt(5, cls_v_amt);
								
			pstmt.setString(6, rent_mng_id);
			pstmt.setString(7, rent_l_cd);
			
		    pstmt.executeUpdate();

			conn.commit();
		    
	  	} catch (Exception e) {
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
	
	public boolean updateClsEtcReJungsan(String rent_mng_id, String rent_l_cd, int no_v_amt, int fdft_amt1, int fdft_amt2, int cls_s_amt, int cls_v_amt, String user_id  )
	{
		getConnection();
		boolean flag = true;
		String query = "update cls_etc set no_v_amt_1 = ?, fdft_amt1_1 = ?, fdft_amt2 = ?, cls_s_amt = ?, cls_v_amt = ?, est_amt = ?, upd_id = ?, upd_dt =to_char(sysdate,'YYYYMMdd')  "+
						" where rent_mng_id = ? and rent_l_cd = ?  ";  //2
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			
			pstmt.setInt(1, no_v_amt);
			pstmt.setInt(2, fdft_amt1);
			pstmt.setInt(3, fdft_amt2);
			pstmt.setInt(4, cls_s_amt);
			pstmt.setInt(5, cls_v_amt);
			pstmt.setInt(6, fdft_amt2);
			pstmt.setString(7, user_id);							
			pstmt.setString(8, rent_mng_id);
			pstmt.setString(9, rent_l_cd);
			
		    pstmt.executeUpdate();

			conn.commit();
		    
	  	} catch (Exception e) {
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
	
		
	public boolean updateScdExtReJungsan(String rent_mng_id, String rent_l_cd, int cls_s_amt, int cls_v_amt, String user_id )	{
		getConnection();
		boolean flag = true;
		
		String query = "update scd_ext set ext_s_amt = ?, ext_v_amt = ?,  update_id = ?, update_dt =to_char(sysdate,'YYYYMMdd') "+
						" where rent_mng_id = ? and rent_l_cd = ? and ext_st = '4' and rent_st = '1' and ext_tm  = '1' ";  //2
		
		PreparedStatement pstmt = null;		 
		
		
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			
			pstmt.setInt(1, cls_s_amt);
			pstmt.setInt(2, cls_v_amt);
			pstmt.setString(3, user_id);
			pstmt.setString(4, rent_mng_id);
			pstmt.setString(5, rent_l_cd);
			
		    pstmt.executeUpdate();
					
			conn.commit();
		    
	  	} catch (Exception e) {
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
	
	//구분정산인 경우
	public boolean updateScdExtReJungsan2(String rent_mng_id, String rent_l_cd, int cls_s_amt, int cls_v_amt, String user_id )	{
		getConnection();
		boolean flag = true;
		
		String query = "update scd_ext set ext_s_amt = ?, ext_v_amt = ?,  update_id = ?, update_dt =to_char(sysdate,'YYYYMMdd') "+
						" where rent_mng_id = ? and rent_l_cd = ? and ext_st = '4' and rent_st = '1' and ext_tm  = '2' ";  //2
		
		PreparedStatement pstmt = null;		 
		
		
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			
			pstmt.setInt(1, cls_s_amt);
			pstmt.setInt(2, cls_v_amt);
			pstmt.setString(3, user_id);
			pstmt.setString(4, rent_mng_id);
			pstmt.setString(5, rent_l_cd);
			
		    pstmt.executeUpdate();
					
			conn.commit();
		    
	  	} catch (Exception e) {
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
	
	//해지정산금 예정일 수정
	public boolean updateScdExtReJungsan(String rent_mng_id, String rent_l_cd, String user_id , String est_dt )	{
		getConnection();
		boolean flag = true;
		
		String query = "update scd_ext set  update_id = ?, update_dt =to_char(sysdate,'YYYYMMdd') , ext_est_dt = replace(?, '-', '') "+
						" where rent_mng_id = ? and rent_l_cd = ? and ext_st = '4' and rent_st = '1' and ext_tm  = '1' ";  //2
		
		PreparedStatement pstmt = null;		 
		
		
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, user_id);		
			pstmt.setString(2, est_dt);							
			pstmt.setString(3, rent_mng_id);
			pstmt.setString(4, rent_l_cd);
			
		    pstmt.executeUpdate();
					
			conn.commit();
		    
	  	} catch (Exception e) {
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
		
		
	public boolean updateClsEtcJungSan(ClsEtcBean cls)
	{
		getConnection();
		boolean flag = true;
		String query = " update cls_etc set "+
						" upd_id = ?,  upd_dt = to_char(sysdate,'YYYYMMdd'), "+  //2(1)
						" ifee_s_amt = ?, ifee_v_amt = ?, ifee_etc = ?, pp_s_amt = ?, pp_v_amt = ?, pp_etc = ?, "+  //6   
						" pded_s_amt = ?, pded_v_amt = ?, pded_etc = ?, tpded_s_amt = ?, tpded_v_amt = ?, tpded_etc = ?,"+  //6   
						" rfee_s_amt = ?, rfee_v_amt = ?, rfee_etc = ?, dfee_tm = ?,   dfee_v_amt = ?,"+  //5  
						" nfee_tm = ?,  nfee_s_amt = ?,  nfee_v_amt = ?, nfee_mon = ?, nfee_day = ?,   nfee_amt = ?,"+  //6   
						" tfee_amt = ?, mfee_amt = ?, rcon_mon = ?, rcon_day = ?, trfee_amt = ?, dft_int = ?, "+  //6   
						" dft_amt = ?, fdft_amt1 = ?, fdft_amt2 = ?, grt_amt = ?, opt_per = ?, opt_amt = ?, "+ //6   
						" dly_amt = ?, no_v_amt = ?, car_ja_amt = ?, cls_s_amt = ?, cls_v_amt = ?,"+  //5   
						" etc_amt = ?, fine_amt = ?, ex_di_amt = ?, ifee_mon = ?, ifee_day = ?, ifee_ex_amt = ?, rifee_s_amt = ?, " + //7   
						" cancel_yn = ?,  etc2_amt = ?, etc3_amt = ?, etc4_amt = ?, "+  //5   
						" fine_amt_1 = ?, car_ja_amt_1 = ?, dly_amt_1 = ?, etc_amt_1 = ?, etc2_amt_1 = ? , " +  //5  
						" dft_amt_1 = ?, ex_di_amt_1 = ?, nfee_amt_1 = ?, etc3_amt_1 = ?, etc4_amt_1 = ? , " +  //5   
						" no_v_amt_1 = ?, fdft_amt1_1 = ?, dfee_amt_1 = ?,  EST_AMT =? , dfee_amt = ?, dft_int_1 = ? , fdft_amt3 = ?,  "+//7
						" over_amt = ? , over_amt_1 = ? , rifee_v_amt = ?, dfee_v_amt_1 = ? , over_v_amt = ? , over_v_amt_1 = ? "+//6
						" where rent_mng_id = ? and rent_l_cd = ?";
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, cls.getUpd_id());
				
			pstmt.setInt   (2, cls.getIfee_s_amt());
			pstmt.setInt   (3, cls.getIfee_v_amt());
			pstmt.setString(4, cls.getIfee_etc());
			pstmt.setInt   (5, cls.getPp_s_amt());
			pstmt.setInt   (6, cls.getPp_v_amt());
			pstmt.setString(7, cls.getPp_etc());     //6
			
			pstmt.setInt   (8, cls.getPded_s_amt());
			pstmt.setInt   (9, cls.getPded_v_amt());
			pstmt.setString(10, cls.getPded_etc());
			pstmt.setInt   (11, cls.getTpded_s_amt());
			pstmt.setInt   (12, cls.getTpded_v_amt());
			pstmt.setString(13, cls.getTpded_etc());    //6
						
			pstmt.setInt   (14, cls.getRfee_s_amt());
			pstmt.setInt   (15, cls.getRfee_v_amt());
			pstmt.setString(16, cls.getRfee_etc());
			pstmt.setString(17, cls.getDfee_tm());		
			pstmt.setInt   (18, cls.getDfee_v_amt());  //5
			
			pstmt.setString(19, cls.getNfee_tm());
			pstmt.setInt   (20, cls.getNfee_s_amt());
			pstmt.setInt   (21, cls.getNfee_v_amt());
			pstmt.setString(22, cls.getNfee_mon());
			pstmt.setString(23, cls.getNfee_day()); 
			pstmt.setInt   (24, cls.getNfee_amt()); //6
						
			pstmt.setInt   (25, cls.getTfee_amt());
			pstmt.setInt   (26, cls.getMfee_amt());
			pstmt.setString(27, cls.getRcon_mon());
			pstmt.setString(28, cls.getRcon_day());
			pstmt.setInt   (29, cls.getTrfee_amt());
			pstmt.setString(30, cls.getDft_int());   //6
			
			pstmt.setInt   (31, cls.getDft_amt());
			pstmt.setInt   (32, cls.getFdft_amt1());
			pstmt.setInt   (33, cls.getFdft_amt2());
			pstmt.setInt   (34, cls.getGrt_amt());
			pstmt.setString(35, cls.getOpt_per());
			pstmt.setInt   (36, cls.getOpt_amt());  //6
		
			pstmt.setInt   (37, cls.getDly_amt());
			pstmt.setInt   (38, cls.getNo_v_amt());
			pstmt.setInt   (39, cls.getCar_ja_amt());		
			pstmt.setInt   (40, cls.getCls_s_amt());
			pstmt.setInt   (41, cls.getCls_v_amt());  //5
						
			pstmt.setInt   (42, cls.getEtc_amt());
			pstmt.setInt   (43, cls.getFine_amt());
			pstmt.setInt   (44, cls.getEx_di_amt());
			pstmt.setString(45, cls.getIfee_mon());
			pstmt.setString(46, cls.getIfee_day());
			pstmt.setInt   (47, cls.getIfee_ex_amt());
			pstmt.setInt   (48, cls.getRifee_s_amt());  //7
			
			pstmt.setString(49, cls.getCancel_yn());	
			pstmt.setInt   (50, cls.getEtc2_amt());
			pstmt.setInt   (51, cls.getEtc3_amt());
			pstmt.setInt   (52, cls.getEtc4_amt());  //5
							
			pstmt.setInt   (53, cls.getFine_amt_1());
			pstmt.setInt   (54, cls.getCar_ja_amt_1());
			pstmt.setInt   (55, cls.getDly_amt_1());
			pstmt.setInt   (56, cls.getEtc_amt_1());
			pstmt.setInt   (57, cls.getEtc2_amt_1()); //5
			
			pstmt.setInt   (58, cls.getDft_amt_1());
			pstmt.setInt   (59, cls.getEx_di_amt_1());
			pstmt.setInt   (60, cls.getNfee_amt_1());
			pstmt.setInt   (61, cls.getEtc3_amt_1());
			pstmt.setInt   (62, cls.getEtc4_amt_1()); //5
			
			pstmt.setInt   (63, cls.getNo_v_amt_1());
			pstmt.setInt   (64, cls.getFdft_amt1_1());
			pstmt.setInt   (65, cls.getDfee_amt_1());  				
			pstmt.setInt   (66, cls.getEst_amt()); 
			pstmt.setInt   (67, cls.getDfee_amt()); 				
			pstmt.setString(68, cls.getDft_int_1());	
			pstmt.setInt   (69, cls.getFdft_amt3());	//7
			
			pstmt.setInt   (70, cls.getOver_amt());	
			pstmt.setInt   (71, cls.getOver_amt_1());		
			pstmt.setInt   (72, cls.getRifee_v_amt());	
			pstmt.setInt   (73, cls.getDfee_v_amt_1());	
			pstmt.setInt   (74, cls.getOver_v_amt());		
			pstmt.setInt   (75, cls.getOver_v_amt_1());		//6		
		
			pstmt.setString(76, cls.getRent_mng_id());
			pstmt.setString(77, cls.getRent_l_cd());

			pstmt.executeUpdate();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AccuDatabase:updateClsEtcJungSan]\n"+e);			
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
	
	
	public boolean updateClsEtcJungSanTax(ClsEtcBean cls)
	{
		getConnection();
		boolean flag = true;
		String query = " update cls_etc set "+
						" upd_id = ?,  upd_dt = to_char(sysdate,'YYYYMMdd'), "+  //2(1)
						" ifee_s_amt = ?, ifee_v_amt = ?, ifee_etc = ?, pp_s_amt = ?, pp_v_amt = ?, pp_etc = ?, "+  //6   
						" pded_s_amt = ?, pded_v_amt = ?, pded_etc = ?, tpded_s_amt = ?, tpded_v_amt = ?, tpded_etc = ?,"+  //6   
						" rfee_s_amt = ?, rfee_v_amt = ?, rfee_etc = ?, dfee_tm = ?,   dfee_v_amt = ?,"+  //5   
						" nfee_tm = ?,  nfee_s_amt = ?,  nfee_v_amt = ?, nfee_mon = ?, nfee_day = ?,   nfee_amt = ?,"+  //6   
						" tfee_amt = ?, mfee_amt = ?, rcon_mon = ?, rcon_day = ?, trfee_amt = ?, dft_int = ?, "+  //6   
						" dft_amt = ?, fdft_amt1 = ?, fdft_amt2 = ?, grt_amt = ?, opt_per = ?, opt_amt = ?, "+ //6   
						" dly_amt = ?, no_v_amt = ?, car_ja_amt = ?, cls_s_amt = ?, cls_v_amt = ?,"+  //7   
						" etc_amt = ?, fine_amt = ?, ex_di_amt = ?, ifee_mon = ?, ifee_day = ?, ifee_ex_amt = ?, rifee_s_amt = ?, " + //7   
						" cancel_yn = ?, cls_st = ?, etc2_amt = ?, etc3_amt = ?, etc4_amt = ?, "+  //5   
						" fine_amt_1 = ?, car_ja_amt_1 = ?, dly_amt_1 = ?, etc_amt_1 = ?, etc2_amt_1 = ? , " +  //5  
						" dft_amt_1 = ?, ex_di_amt_1 = ?, nfee_amt_1 = ?, etc3_amt_1 = ?, etc4_amt_1 = ? , " +  //5   
						" no_v_amt_1 = ?, fdft_amt1_1 = ?, dfee_amt_1 = ?, " +  //5    
						" EST_AMT =? , dfee_amt = ?, "+ //1   					
						" dft_int_1 = ? , fdft_amt3 = ?, "+//1
						" tax_chk0 = ?, tax_chk1 = ?, tax_chk2 = ?, tax_chk3 = ?, tax_chk4 = ?, tax_chk5 = ?, tax_chk6 = ?, "+//7
						" etc_amt_s = ?,  etc2_amt_s = ?,  dft_amt_s = ?, etc4_amt_s = ?,  "+  //4
						" etc_amt_v = ?,  etc2_amt_v = ?,  dft_amt_v = ?, etc4_amt_v  = ?, "+  //4
						" over_amt = ?,  over_amt_1 = ? , "+  //2
						" over_amt_s = ?,  over_amt_v =  ? "+  //2
						" where rent_mng_id = ? and rent_l_cd = ?";
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, cls.getUpd_id());
				
			pstmt.setInt   (2, cls.getIfee_s_amt());
			pstmt.setInt   (3, cls.getIfee_v_amt());
			pstmt.setString(4, cls.getIfee_etc());
			pstmt.setInt   (5, cls.getPp_s_amt());
			pstmt.setInt   (6, cls.getPp_v_amt());
			pstmt.setString(7, cls.getPp_etc());     //6
			
			pstmt.setInt   (8, cls.getPded_s_amt());
			pstmt.setInt   (9, cls.getPded_v_amt());
			pstmt.setString(10, cls.getPded_etc());
			pstmt.setInt   (11, cls.getTpded_s_amt());
			pstmt.setInt   (12, cls.getTpded_v_amt());
			pstmt.setString(13, cls.getTpded_etc());    //6
						
			pstmt.setInt   (14, cls.getRfee_s_amt());
			pstmt.setInt   (15, cls.getRfee_v_amt());
			pstmt.setString(16, cls.getRfee_etc());
			pstmt.setString(17, cls.getDfee_tm());
			pstmt.setInt   (18, cls.getDfee_v_amt());  //6
			
			pstmt.setString(19, cls.getNfee_tm());
			pstmt.setInt   (20, cls.getNfee_s_amt());
			pstmt.setInt   (21, cls.getNfee_v_amt());
			pstmt.setString(22, cls.getNfee_mon());
			pstmt.setString(23, cls.getNfee_day()); 
			pstmt.setInt   (24, cls.getNfee_amt()); //6
						
			pstmt.setInt   (25, cls.getTfee_amt());
			pstmt.setInt   (26, cls.getMfee_amt());
			pstmt.setString(27, cls.getRcon_mon());
			pstmt.setString(28, cls.getRcon_day());
			pstmt.setInt   (29, cls.getTrfee_amt());
			pstmt.setString(30, cls.getDft_int());   //6
			
			pstmt.setInt   (31, cls.getDft_amt());
			pstmt.setInt   (32, cls.getFdft_amt1());
			pstmt.setInt   (33, cls.getFdft_amt2());
			pstmt.setInt   (34, cls.getGrt_amt());
			pstmt.setString(35, cls.getOpt_per());
			pstmt.setInt   (36, cls.getOpt_amt());  //6
		
			pstmt.setInt   (37, cls.getDly_amt());
			pstmt.setInt   (38, cls.getNo_v_amt());
			pstmt.setInt   (39, cls.getCar_ja_amt());
		
			pstmt.setInt   (40, cls.getCls_s_amt());
			pstmt.setInt   (41, cls.getCls_v_amt());  //7
						
			pstmt.setInt   (42, cls.getEtc_amt());
			pstmt.setInt   (43, cls.getFine_amt());
			pstmt.setInt   (44, cls.getEx_di_amt());
			pstmt.setString(45, cls.getIfee_mon());
			pstmt.setString(46, cls.getIfee_day());
			pstmt.setInt   (47, cls.getIfee_ex_amt());
			pstmt.setInt   (48, cls.getRifee_s_amt());  //7
			
			pstmt.setString(49, cls.getCancel_yn());
			pstmt.setString(50, cls.getCls_st());
			pstmt.setInt   (51, cls.getEtc2_amt());
			pstmt.setInt   (52, cls.getEtc3_amt());
			pstmt.setInt   (53, cls.getEtc4_amt());  //5
							
			pstmt.setInt   (54, cls.getFine_amt_1());
			pstmt.setInt   (55, cls.getCar_ja_amt_1());
			pstmt.setInt   (56, cls.getDly_amt_1());
			pstmt.setInt   (57, cls.getEtc_amt_1());
			pstmt.setInt   (58, cls.getEtc2_amt_1()); //5
			
			pstmt.setInt   (59, cls.getDft_amt_1());
			pstmt.setInt   (60, cls.getEx_di_amt_1());
			pstmt.setInt   (61, cls.getNfee_amt_1());
			pstmt.setInt   (62, cls.getEtc3_amt_1());
			pstmt.setInt   (63, cls.getEtc4_amt_1()); //5
			
			pstmt.setInt   (64, cls.getNo_v_amt_1());
			pstmt.setInt   (65, cls.getFdft_amt1_1());
			pstmt.setInt   (66, cls.getDfee_amt_1());  
				
			pstmt.setInt   (67, cls.getEst_amt()); 
			pstmt.setInt   (68, cls.getDfee_amt()); 
						
			pstmt.setString(69, cls.getDft_int_1());	
			pstmt.setInt   (70, cls.getFdft_amt3());	
			
			pstmt.setString(71, cls.getTax_chk0());	
			pstmt.setString(72, cls.getTax_chk1());	
			pstmt.setString(73, cls.getTax_chk2());	
			pstmt.setString(74, cls.getTax_chk3());	
			pstmt.setString(75, cls.getTax_chk4());	
			pstmt.setString(76, cls.getTax_chk5());	
			pstmt.setString(77, cls.getTax_chk6());	//7
			
			pstmt.setInt   (78, cls.getEtc_amt_s());
			pstmt.setInt   (79, cls.getEtc2_amt_s());		
			pstmt.setInt   (80, cls.getDft_amt_s());
			pstmt.setInt   (81, cls.getEtc4_amt_s());
						
			pstmt.setInt   (82, cls.getEtc_amt_v());
			pstmt.setInt   (83, cls.getEtc2_amt_v());			
			pstmt.setInt   (84, cls.getDft_amt_v());
			pstmt.setInt   (85, cls.getEtc4_amt_v());				
			
			pstmt.setInt   (86, cls.getOver_amt());				
			pstmt.setInt   (87, cls.getOver_amt_1());		
			
			pstmt.setInt   (88, cls.getOver_amt_s());
						
			pstmt.setInt   (89, cls.getOver_amt_v());									
		
			pstmt.setString(90, cls.getRent_mng_id());
			pstmt.setString(91, cls.getRent_l_cd());

			pstmt.executeUpdate();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AccuDatabase:updateClsEtcJungSanTax]\n"+e);			
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
	
	
	public boolean updateClsEtcIp(ClsEtcBean cls)
	{
		getConnection();
		boolean flag = true;
		String query = " update cls_etc set "+
						" upd_id = ?,  upd_dt = to_char(sysdate,'YYYYMMdd'),  fdft_amt2 = ? "+  //2(1)
						" where rent_mng_id = ? and rent_l_cd = ?";
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, cls.getUpd_id());
			pstmt.setInt   (2, cls.getFdft_amt2()); 
								
			pstmt.setString(3, cls.getRent_mng_id());
			pstmt.setString(4, cls.getRent_l_cd());

			pstmt.executeUpdate();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AccuDatabase:updateClsEtcOpt]\n"+e);			
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
	
	
	
	
	public boolean updateClsEtcOpt(ClsEtcBean cls)
	{
		getConnection();
		boolean flag = true;
		String query = " update cls_etc set "+
						" upd_id = ?,  upd_dt = to_char(sysdate,'YYYYMMdd'), "+  //2(1)
						" opt_ip_dt1 = replace(?, '-', ''), opt_ip_amt1 = ?, opt_ip_bank1 =?,  opt_ip_bank_no1 =?, "+ //4    
						" opt_ip_dt2 = replace(?, '-', ''), opt_ip_amt2 = ?, opt_ip_bank2 =?,  opt_ip_bank_no2 =?, "+ //4   
						" ext_st  =? , est_amt = ?  "+ //1    
						" where rent_mng_id = ? and rent_l_cd = ?";
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, cls.getUpd_id());
								
			pstmt.setString(2, cls.getOpt_ip_dt1());
			pstmt.setInt   (3, cls.getOpt_ip_amt1()); 
			pstmt.setString(4, cls.getOpt_ip_bank1());
			pstmt.setString(5, cls.getOpt_ip_bank_no1());  //4	
			
			pstmt.setString(6, cls.getOpt_ip_dt2());
			pstmt.setInt   (7, cls.getOpt_ip_amt2()); 
			pstmt.setString(8, cls.getOpt_ip_bank2());
			pstmt.setString(9, cls.getOpt_ip_bank_no2());  //4	
			
			pstmt.setString(10, cls.getExt_st());  //1
			pstmt.setInt   (11, cls.getEst_amt()); 
		
			pstmt.setString(12, cls.getRent_mng_id());
			pstmt.setString(13, cls.getRent_l_cd());

			pstmt.executeUpdate();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AccuDatabase:updateClsEtcOpt]\n"+e);			
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
				
    //매입옵션시 공급받는자 
	public Hashtable getOffls_sui(String car_mng_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";		
		
		query = "SELECT  to_char(to_date(nvl(a.jan_pr_dt, a.cont_dt)), 'yyyy-mm-dd') m_sui_dt, a.client_id, a.sui_nm, text_decrypt(a.ssn, 'pw') ssn, a.enp_no, a.d_zip, a.d_addr, b.firm_nm, b.ven_code, b.BUS_CDT, b.BUS_ITM  "+ 
				" FROM sui a, client b WHERE a.client_id = b.client_id and a.car_mng_id = '" + car_mng_id + "' ";
			
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
		} catch (SQLException e) {
			System.out.println("[AccDatabase:getOffls_sui]\n"+e);			
			System.out.println("[AccDatabase:getOffls_sui]\n"+query);			
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
	
	
	 /**
     * 세금계산서 수정관련
     */
    public int updateClsEtcJungSanSubTax(String rent_mng_id, String rent_l_cd, int no_v_amt_1, int fdft_amt1_1 ) 
    {
       	getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        int count = 0;
                
	
	    query=" UPDATE  cls_etc_sub SET no_v_amt_1 = ? , fdft_amt1_1 = ? WHERE rent_mng_id =? and rent_l_cd = ? and cls_seq = 1 ";				
		
            
       try{
            conn.setAutoCommit(false);

            pstmt = conn.prepareStatement(query);
	pstmt.setInt(1, no_v_amt_1);
	pstmt.setInt(2, fdft_amt1_1);
            pstmt.setString(3, rent_mng_id);
            pstmt.setString(4, rent_l_cd);
            count = pstmt.executeUpdate();             

			pstmt.close();
			
			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AccuDatabase:updateClsEtcJungSanSubTax]\n"+e);			
	  		e.printStackTrace();
	  		count = 0;
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
	
	  
	//파일
	/*
	public String  getClsEtcScan( String rent_mng_id, String rent_l_cd, String gubun)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";		
		String re_file_name = "";		
		
		if ( gubun.equals("1") ) {		
			query = " SELECT re_file_name "+
					"	FROM cls_etc "+
					"	where rent_mng_id = '"+ rent_mng_id + "' and rent_l_cd = '"+rent_l_cd+"'";
		} else if  ( gubun.equals("2")) { 
				query = " SELECT etc4_file_name "+
					"	FROM cls_etc "+
					"	where rent_mng_id = '"+ rent_mng_id + "' and rent_l_cd = '"+rent_l_cd+"'";			
			
		} else  {
				query = " SELECT remark_file_name "+
					"	FROM cls_etc "+
					"	where rent_mng_id = '"+ rent_mng_id + "' and rent_l_cd = '"+rent_l_cd+"'";			
		}	 				
				
		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		if(rs.next())
			{		
				re_file_name = rs.getString(1);
			}

		} catch (SQLException e) {
			System.out.println("[AccuDatabase:getClsEtcScan]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return re_file_name;
		}
	}  
	*/
		
	
	/**
	 *	세금계산서 통합발행
	 */
	public boolean updateClsEtcTaxGu(String rent_mng_id, String rent_l_cd, String tax_reg_gu )
	{
		getConnection();
		boolean flag = true;
		String query = "update cls_etc set tax_reg_gu = ? "+
						" where rent_mng_id = ? and rent_l_cd = ?  ";  //2
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
				
			pstmt.setString(1, tax_reg_gu);		
			pstmt.setString(2, rent_mng_id);
			pstmt.setString(3, rent_l_cd);
			
		    pstmt.executeUpdate();

			conn.commit();
		    
	  	} catch (Exception e) {
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
	
	//계산서 발행여부  - 해지 위약금, 외부비용, 부대비용, 기타손해배상금 ,초과운행부담금 
	public Hashtable  getClsGetTaxYN( String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";		
		
		query = " select  tax_chk0, tax_chk1, tax_chk2, tax_chk3 , tax_chk4 "+
 				"  from   cls_etc "+
				"  where  rent_mng_id = '"+ rent_mng_id + "' and rent_l_cd = '"+rent_l_cd+"'";
		 			
 		
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
		} catch (SQLException e) {
			System.out.println("[AccDatabase:getClsGetTaxYN]\n"+e);			
			System.out.println("[AccDatabase:getClsGetTaxYN]\n"+query);			
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
		
	//연체료 입금표 발행여부
	public String  getClsPayEbillDly( String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";		
		String pubcode = "";	
		
		
		query = " select c.pubcode "+
				"  from cls_etc a, cls_etc_sub b, payebill c, incom_ebill d "+
				"	     where a.RENT_MNG_ID = '"+ rent_mng_id + "' and a.RENT_L_CD = '"+rent_l_cd+"' and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd and b.cls_seq = 1 "+
				"	       and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd and a.cls_dt = d.pay_dt "+
				"	       and b.dly_amt_2 > 0 and  d.gubun= 'dly' and c.seqid=d.seqid ";
		 					
		try {
		
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();	  
	    	
    		if(rs.next())
			{		
				pubcode = rs.getString(1);
			}

		} catch (SQLException e) {
			System.out.println("[AccuDatabase:getClsPayEbillDly]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return pubcode;
		}
	}  
	
	//입금표 발행여부 - 위약금, 회수외주비용, 회수부대비용, 기타손해배상금
	public String  getClsPayEbillNoTax(String rent_mng_id, String rent_l_cd, String tgubun)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";		
		String pubcode = "";	
		
		String sub_query="";
		
		if (tgubun.equals("dft") ) {
			sub_query = " and  b.dft_amt_2 > 0 and a.tax_chk0 = 'N' and d.gubun= 'dft'";			
		}else if (tgubun.equals("etc") ) {	
			sub_query = " and  b.etc_amt_2 > 0 and a.tax_chk1 = 'N' and d.gubun= 'etc'";
		}else if (tgubun.equals("etc2") ) {	
			sub_query = " and  b.etc2_amt_2 > 0 and a.tax_chk2 = 'N' and d.gubun= 'etc2'";
		}else if (tgubun.equals("etc4") ) {	
			sub_query = " and  b.etc4_amt_2 > 0 and a.tax_chk3 = 'N' and d.gubun= 'etc4'";		
		}		
				
		query = " select c.pubcode "+
				"  from cls_etc a, cls_etc_sub b, payebill c, incom_ebill d "+
				"	     where a.RENT_MNG_ID = '"+ rent_mng_id + "' and a.RENT_L_CD = '"+rent_l_cd+"' and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd and b.cls_seq = 1 "+
				"	       and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd and a.cls_dt = d.pay_dt "+ sub_query +
				"	       and  c.seqid=d.seqid ";
		 					
		try {
		
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();	        
	    	
    		if(rs.next())
			{		
				pubcode = rs.getString(1);
			}

		} catch (SQLException e) {
			System.out.println("[AccuDatabase:getClsPayEbillDly]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return pubcode;
		}
	}  
	
	//결재요청전 등록여부
	public int getClsEtcCnt(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		boolean flag = true;
		String query = "select count(*) from cls_etc "+
						" where rent_mng_id = ? and rent_l_cd= ?  ";  //2
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int cnt = 0;
		try 
		{
			pstmt = conn.prepareStatement(query);
					
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
						
		 	rs = pstmt.executeQuery();
			if(rs.next()){
				cnt = rs.getInt(1);
			}    
		    
	  	} catch (Exception e) {
	  		e.printStackTrace();
	  		
		} finally {
			try{	
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return cnt;
		}			
	}
	
	
	//해지정산시 선발행 거래명세서 여부
	public String getMaxFeeTaxItemTm(String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";		
		String tm = "";
					
		query = "	select nvl(to_char(max(to_number(tm))),'999') tm " +
				" from tax_item_list where rent_l_cd= '"+rent_l_cd+"' and gubun = '1'"; 	
 		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		if(rs.next())
			{		
				tm = rs.getString(1);
			}

		} catch (SQLException e) {
			System.out.println("[AccuDatabase:getMaxFeeTaxItemTm]\n"+e);
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
	
	
	    //해지정산시 미납대여료관련 기발행거래명세서 발행일, 사용기간
	public Hashtable getLastFeeTaxItemItemId(String rent_l_cd, String fee_tm)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";	
		
		query = " select a.item_id, c.tax_no, b.use_yn, a.item_dt1, a.item_dt2, a.item_supply, a.reg_dt from tax_item_list a, tax_item b , tax c  " +
		         "  where a.rent_l_cd =  '"+rent_l_cd+"' and a.tm = '"+ fee_tm + "' and a.item_id = b.item_id and b.item_id = c.item_id(+) order by a.reg_dt desc "; 
		 		
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
		} catch (SQLException e) {
			System.out.println("[AccDatabase:getLastFeeTaxItemItemId]\n"+e);			
			System.out.println("[AccDatabase:getLastFeeTaxItemItemId]\n"+query);			
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
	
	
	/**
	 *	기발행거래명세서 - N 으로 처리
	 */
	public boolean updateTaxItemUseYn(String item_id )
	{
		getConnection();
		boolean flag = true;
		String query = "update tax_item set use_yn = 'N' "+
						" where item_id = ? and use_yn = 'Y' ";  //2
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
				
			pstmt.setString(1, item_id);		
					
		    pstmt.executeUpdate();

			conn.commit();
		    
	  	} catch (Exception e) {
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
	 *	회계처리
	 */
	public boolean insertScdExtCls8(String rent_mng_id, String rent_l_cd, int ext_amt, String cls_dt, String user_id)
	{
		getConnection();
		boolean flag = true;
		int r_ext_amt = 0;
		String query = " INSERT INTO scd_ext"+
							" (rent_mng_id, rent_l_cd, rent_st, rent_seq, ext_st, ext_id, ext_tm,"+
							"  ext_s_amt, ext_v_amt, ext_est_dt, bill_yn, update_id, update_dt)"+
							" values "+
							" ( ?, ?, '1', '1', '4', '0', '1',"+
							"   ?, 0, replace(?, '-', ''), 'Y', ?, to_char(sysdate,'YYYYMMDD') )";		
						
				
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			
			r_ext_amt  = ext_amt * (-1);
				
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
			pstmt.setInt(3, r_ext_amt);
			pstmt.setString(4, cls_dt);
			pstmt.setString(5, user_id);
			
		    pstmt.executeUpdate();

			conn.commit();
		    
	  	} catch (Exception e) {
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
	 *	회계처리
	 */
	public boolean updateScdExtCls8(String rent_mng_id, String rent_l_cd, int ext_amt, String cls_dt, String user_id)
	{
		getConnection();
		boolean flag = true;
		int r_ext_amt = 0;
		
		String query = "update scd_ext set ext_s_amt = ?,   update_id = ?, update_dt =to_char(sysdate,'YYYYMMdd')  "+
						" where rent_mng_id = ? and rent_l_cd = ? and ext_st = '4' and rent_st = '1' and ext_tm  = '1' ";  //2
						
				
				
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			
			r_ext_amt  = ext_amt * (-1);
			
			pstmt.setInt(1, r_ext_amt);	
			pstmt.setString(2, user_id);
			pstmt.setString(3, rent_mng_id);
			pstmt.setString(4, rent_l_cd);
					
		    pstmt.executeUpdate();

			conn.commit();
		    
	  	} catch (Exception e) {
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
	
	
	
	//해지차량 회수일
	public String  getClsRecoDt( String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";		
		String reco_dt = "";	
		
		
		query = " select a.reco_dt "+
				"  from car_reco a "+
				"	     where a.RENT_MNG_ID = '"+ rent_mng_id + "' and a.RENT_L_CD = '"+rent_l_cd+"' and rownum = 1 ";
			
		 					
		try {
		
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();	  
	    	
    		if(rs.next())
			{		
				reco_dt = rs.getString(1);
			}

		} catch (SQLException e) {
			System.out.println("[AccuDatabase:getClsRecoDt]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return reco_dt;
		}
	} 
		
	//해지정산시 개시대여료,선납금 계산서 발행 여부
	public String getTaxGubunDt(String rent_l_cd, String gubun)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";		
		String tdt = "";
					
		query = "	select tax_dt " +
				" from tax where rent_l_cd= '"+rent_l_cd+"' and gubun = '" + gubun + "' and tax_st = 'O' and rownum = 1 order by 1 desc"; 	
 		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		if(rs.next())
			{		
				tdt = rs.getString(1);
			}

		} catch (SQLException e) {
			System.out.println("[AccuDatabase:getTaxGubunDt]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return tdt;
		}
	}
		
	//해지등록 등록여부
	public int getContClsCnt(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		boolean flag = true;
		String query = "select count(*) from cls_cont "+
						" where rent_mng_id = ? and rent_l_cd= ?  ";  //2
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int cnt = 0;
		try 
		{
			pstmt = conn.prepareStatement(query);
					
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
						
		 	rs = pstmt.executeQuery();
			if(rs.next()){
				cnt = rs.getInt(1);
			}    
		    
	  	} catch (Exception e) {
	  		e.printStackTrace();
	  		
		} finally {
			try{	
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return cnt;
		}			
	}
	
	
	//출고전해지(신차)인경우 대차청구시 스케쥴생성이 안되있는 건
	public int getClsEtcTaeChaCnt(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
			
		String query = " select count(*) from taecha t, scd_fee f "+
				 	   " where t.RENT_MNG_ID = ? "+
				 	   "  and  t.RENT_L_CD = ?	 "+
					   "  and  t.RENT_MNG_ID = f.RENT_MNG_ID(+) "+
					   "  and  t.RENT_L_CD = f.RENT_L_CD(+) "+
					   "  and  t.NO = f.TAE_NO(+) "+
		               "  and  t.REQ_ST = '1' "+
		               "  and  f.tm_st2 = '2' ";
                 
  		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int cnt = 0;
		try 
		{
			pstmt = conn.prepareStatement(query);
					
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
						
		 	rs = pstmt.executeQuery();
			if(rs.next()){
				cnt = rs.getInt(1);
			}    
		    
	  	} catch (Exception e) {
	  		e.printStackTrace();
	  		
		} finally {
			try{	
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return cnt;
		}			
	}
		
	
	//출고전해지(신차)인경우 대차청구시 스케쥴생성이 된 것의 max(use_e_dt)
	public String getClsEtcTaeChaUseEndDt(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
			
		String query = " select max(f.use_e_dt) from scd_fee f "+
				 	   " where f.RENT_MNG_ID = ? "+
				 	   "  and  f.RENT_L_CD = ?	 "+
					   "  and  f.tm_st2 = '2' ";
                 
  		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String tae_e_dt = "";
		try 
		{
			pstmt = conn.prepareStatement(query);
					
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
						
		 	rs = pstmt.executeQuery();
			if(rs.next()){
				tae_e_dt = rs.getString(1);
			}    
		    
	  	} catch (Exception e) {
	  		e.printStackTrace();
	  		
		} finally {
			try{	
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return tae_e_dt;
		}			
	}
		
		
	  //출고전해지(신차)시 지연대차 여부 및 정보
	public Hashtable  getClsEtcTaeCha(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";	
		
		query = " select a.car_mng_id, a.car_rent_dt, a.car_rent_st, a.car_rent_et, a.rent_fee, a.req_st, a.tae_st from taecha a where a.rent_mng_id =  '"+rent_mng_id+"' and a.rent_l_cd = '"+ rent_l_cd + "'"; 
			 		
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
		} catch (SQLException e) {
			System.out.println("[AccDatabase:getClsEtcTaeCha]\n"+e);			
			System.out.println("[AccDatabase:getClsEtcTaeCha]\n"+query);			
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
	
	/**
	 *	해지의뢰 출고전해지 지점장 결재
	 */
	public boolean updateClsEtcSb(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		boolean flag = true;
		String query = " update cls_etc set SB_SACTION_DT = to_char(sysdate,'YYYYMMdd')  "+
						" where rent_mng_id = ? and rent_l_cd = ?  ";  //2
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
					
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
			
		    pstmt.executeUpdate();

			conn.commit();
		    
	  	} catch (Exception e) {
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
	 *	해지의뢰 출고전해지 지점장 결재
	 */
	public boolean updateClsEtcExtSt(String rent_mng_id, String rent_l_cd, String ext_st)
	{
		getConnection();
		boolean flag = true;
		String query = " update cls_etc set ext_st = ?   "+
						" where rent_mng_id = ? and rent_l_cd = ?  ";  //2
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
				
			pstmt.setString(1, ext_st);		
			pstmt.setString(2, rent_mng_id);
			pstmt.setString(3, rent_l_cd);
			
		    pstmt.executeUpdate();

			conn.commit();
		    
	  	} catch (Exception e) {
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
	 *	영업팀해지인 경우 관리담당자 배정 메모
	 */
	
	public boolean sendMemo(String cls_dt, String car_no){
		getConnection();
		boolean flag = true;
		String query_seq="";
		String query="";
		Statement stmt1 = null;
		Statement stmt2 = null;
		ResultSet rs = null;
		String memo_id = "";
	    String n_Title = "";
	    String n_Content = "";	    	
		try 
		{
			conn.setAutoCommit(false);

			query_seq = "SELECT ltrim(NVL(TO_CHAR(MAX(TO_NUMBER(memo_id))+1, '000000'), '000001')) memo_id  FROM memo ";

			stmt1 = conn.createStatement();
			rs = stmt1.executeQuery(query_seq);
				
			if(rs.next()){
				memo_id = rs.getString("MEMO_ID");
			}    
										
			n_Title = "[보유차관리담당자배정요청] 차량번호 : "+ car_no +" 해지일: "+ cls_dt;
			n_Content = "[보유차관리담당자배정요청] 차량번호 : "+ car_no +" 해지일: "+ cls_dt + " 관리담당자만 배정(변경)해주세요. 영업담당자는 배정(변경)하지 마세요." ;
                
                     query = "insert into memo( memo_id, dept_id, send_id, rece_id, title, content, memo_dt) "+
                        " values ( '" + memo_id +"' , '', '999999', '000006', '"+ n_Title +"', '"+ n_Content +"', to_char(sysdate,'YYYYMMDD'))";
       
			stmt2 = conn.createStatement();
			stmt2.executeUpdate(query);

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[AccDatabase:sendMemo]\n"+e);	
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(rs != null ) rs.close();
                if(stmt1 != null) stmt1.close();
                if(stmt2 != null) stmt2.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}
		
	//매입옵션 환불건관련 결재요청전 등록여부
	public int getScdExtClsCnt(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		boolean flag = true;
		String query = "select count(*) from scd_ext "+
						" where rent_mng_id = ? and rent_l_cd= ? and  ext_st = '4' and rent_st = '1' and ext_tm  = '1' ";  //2
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int cnt = 0;
		try 
		{
			pstmt = conn.prepareStatement(query);
					
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
						
		 	rs = pstmt.executeQuery();
			if(rs.next()){
				cnt = rs.getInt(1);
			}    
		    
	  	} catch (Exception e) {
	  		e.printStackTrace();
	  		
		} finally {
			try{	
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return cnt;
		}			
	}
	
	
	/*
	 *	보유차 대여료 계산 호출 P_ESTI_REG_SH_RES
	*/
	public void call_sp_esti_reg_sh_res(String s_date, String car_mng_id)
	{
    	getConnection();
    	
    	String query = "{CALL P_ESTI_REG_SH_RES (?,?)}";	
		
	CallableStatement cstmt = null;
		
	try {
			cstmt = conn.prepareCall(query);
			
			cstmt.setString(1, s_date);
			cstmt.setString(2, car_mng_id);
						
			cstmt.execute();		
			cstmt.close();		
	
	} catch (SQLException e) {
			System.out.println("[AdminDatabase:call_sp_esti_reg_sh_res]\n"+e);
			e.printStackTrace();
	} finally {
			try{
			     if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
				closeConnection();		
			}
	}	
	
	
	/*
	 *	보유차 영업용 월렌트 대여료 계산 호출 P_ESTI_REG_SH_RES
	*/
	public void call_sp_esti_reg_sh( String car_mng_id)
	{
    	getConnection();
    	
    	String query = "{CALL P_ESTI_REG_SH(?)}";
        		
	CallableStatement cstmt = null;
		
	try {
			cstmt = conn.prepareCall(query);
			
			cstmt.setString(1, car_mng_id);
						
			cstmt.execute();		
			cstmt.close();		
	
	} catch (SQLException e) {
			System.out.println("[AdminDatabase:call_sp_esti_reg_sh]\n"+e);
			e.printStackTrace();
	} finally {
			try{
			     if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
				closeConnection();		
			}
	}	
	
			
	/**
     *월렌트 정산시 과태료/범칙금 처리 수정
     */
    public boolean updateForfeitDetailRentCls(String rent_mng_id, String rent_l_cd, int seq_no, String user_id) 
    {
      	getConnection();
        PreparedStatement pstmt = null;
        String query = "";
        boolean flag = true;
 		 
 	               
        query = " update fine set bill_yn='N', note= nvl(note ,'* ' )  || ' - 월렌트 정산시 포함' ,  update_id = ?, update_dt = to_char(sysdate,'YYYYMMdd')  "+
				" where seq_no=? and rent_mng_id=? and rent_l_cd=?";
         
       try{
            conn.setAutoCommit(false);
           
            pstmt = conn.prepareStatement(query);            
    
            pstmt.setString(1, user_id	);
            pstmt.setInt   (2, seq_no		);
            pstmt.setString(3, rent_mng_id	);
            pstmt.setString(4, rent_l_cd	);
            
            pstmt.executeUpdate();
             
            pstmt.close();
            conn.commit();

    
    	} catch (Exception e) {
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
	
	
	// 만기매칭 대차의 스케쥴 시작
	public String getClsEtcTaeChaStartDt(String rent_mng_id, String rent_l_cd, String car_mng_id)
	{
		getConnection();
			
		String query = " select car_rent_st  from taecha "+
				 	   " where RENT_MNG_ID = ? "+
				 	   "  and  RENT_L_CD = ?	" +				
				 	    "  and car_mng_id = ?	" ;				
                   		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String tae_s_dt = "";
		try 
		{
			pstmt = conn.prepareStatement(query);
					
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
			pstmt.setString(3, car_mng_id);
						
		 	rs = pstmt.executeQuery();
			if(rs.next()){
				tae_s_dt = rs.getString(1);
			}    
		    
	  	} catch (Exception e) {
	  		e.printStackTrace();
	  		
		} finally {
			try{	
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return tae_s_dt;
		}			
	}
	
	
	// 보상 여부
	public int getFuelCnt(String car_mng_id, String end_yn)
	{
		getConnection();
		boolean flag = true;
		String query = "select count(*) from ret_car_no "+
						" where car_mng_id = ? and nvl(end_yn, 'N' )  =  ? ";  //2
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int cnt = 0;
		try 
		{
			pstmt = conn.prepareStatement(query);
					
			pstmt.setString(1, car_mng_id);
			pstmt.setString(2, end_yn);
		
			rs = pstmt.executeQuery();
			if(rs.next()){
				cnt = rs.getInt(1);
			}    
		    
	  	} catch (Exception e) {
	  		e.printStackTrace();
	  		
		} finally {
			try{	
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return cnt;
		}			
	}
		
	/**
	 *	보상 완료
	 */
	public boolean updateFuelCng(String car_mng_id)
	{
		getConnection();
		boolean flag = true;
		String query = " update ret_car_no set end_yn  = 'Y'   "+
						" where car_mng_id = ?  ";  //2
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);					
		    	pstmt.executeUpdate();

			conn.commit();
		    
	  	} catch (Exception e) {
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
	
	// 보상금액, 차종  
	public Hashtable getFuelAmt(String car_mng_id, String end_yn)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";		
			
		
		query = "select  amt, remark  from ret_car_no "+
						" where car_mng_id =  '"+car_mng_id+"'  and nvl(end_yn, 'N' )  =  '"+ end_yn+ "'";  //2
		
					
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
		} catch (SQLException e) {
			System.out.println("[AccDatabase:getFuelAmt]\n"+e);			
			System.out.println("[AccDatabase:getFuelAmt]\n"+query);			
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
	
	
	
	//해지정산시 초과운행부담금 조회 - 월렌트 제외
	public Vector getClsOverList( String dt, String st_dt, String end_dt , String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";		
			
		query = " select  b.rent_l_cd, b.over_amt , b.cls_dt,  d.car_no, d.car_nm , b.reg_id , cl.firm_nm, \n "+
		               "  decode(b.cls_st, '1', '계약만료', '2', '중도해약', '8', '매입옵션', '' ) cls_st_nm , fe.agree_dist, fe.over_run_amt, co.jung_dist  \n" + 
							"	FROM   cls_cont b , cont c , car_reg d , client cl ,  cls_etc_over co, \n" + 				
							"  ( select  a.rent_mng_id, a.rent_l_cd , a.agree_dist,  a.over_run_amt from fee_etc a, ( select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee_etc group by  rent_mng_id, rent_l_cd ) b \n" + 
							"    where a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd and a.rent_st = b.rent_st  ) fe \n" + 
							"	WHERE    b.rent_mng_id = c.rent_mng_id and b.rent_l_cd = c.rent_l_cd \n  "+
							"  		and b.rent_mng_id  = co.rent_mng_id(+) and b.rent_l_cd = co.rent_l_cd(+)    \n  "+
							"  		and b.rent_mng_id = fe.rent_mng_id(+) and b.rent_l_cd = fe.rent_l_cd(+)  \n  "+
							"  		and c.car_mng_id= d.car_mng_id and c.client_id = cl.client_id(+)  and b.over_amt  > 0   and b.cls_st not in ('14') "+
							" " ;
	    /* 기간 */
        if(dt.equals("1"))        	query += " and b.cls_dt like to_char(sysdate,'YYYYMM')||'%' \n";
        else if(dt.equals("2"))		query += " and b.cls_dt like to_char(sysdate,'YYYY')||'%' \n";
        else if(dt.equals("3"))		query += " and b.cls_dt between replace('" + st_dt + "','-','') and replace('" + end_dt + "','-','')\n";
	     
		query += " order by b.cls_st, b.cls_dt ";

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
		} catch (SQLException e) {
			System.out.println("[AccuDatabase:getClsOverList]\n"+e);			
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
	
	
	 //해지정산후 환불금액 관련
	public Hashtable getPayMngDt(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";		
			
		query = 	" SELECT  c.p_pay_dt, DECODE(c.p_way,'1','현금','4','자동이체','5','계좌이체','') p_way ,   (a.ext_s_amt+a.EXT_V_AMT) ext_amt  \n " +			    
				"	FROM    SCD_EXT a, PAY_ITEM b, PAY c \n " +
				"	WHERE   a.ext_st='4' AND (a.ext_s_amt+a.EXT_V_AMT)<0 AND a.bill_yn='Y' \n " +
				 "           AND a.rent_mng_id=b.p_cd1 AND a.rent_l_cd=b.p_cd2  AND a.ext_st=b.p_cd3 AND a.ext_tm=b.p_cd4 and b.p_st1 = '31'   \n " +
				"	    AND a.rent_mng_id= '"+rent_mng_id+"'  AND a.rent_l_cd= '"+rent_l_cd+"'  \n " +
				"	    AND b.reqseq=c.reqseq         ";
		
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
		} catch (SQLException e) {
			System.out.println("[AccDatabase:getPayMngDt]\n"+e);			
			System.out.println("[AccDatabase:getPayMngDt]\n"+query);			
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
	
	
	/**
	 *	해지의뢰  -  예비차 사용방법 
	 */
	public boolean updateCarPreServ(String rent_mng_id, String rent_l_cd, String serv_st, String serv_gubun )
	{
		getConnection();
		boolean flag = true;
		String query = " update cls_etc set serv_st =  ?, serv_gubun = ?   "+
						" where rent_mng_id = ? and rent_l_cd = ?  ";  //2
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
					
			pstmt.setString(1, serv_st);
			pstmt.setString(2, serv_gubun);		
			pstmt.setString(3, rent_mng_id);
			pstmt.setString(4, rent_l_cd);
			
		    pstmt.executeUpdate();

			conn.commit();
		    
	  	} catch (Exception e) {
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
	*	해지정산시 예비차 적용 - 맥각예정선택시 월랜트 제외 (20161026)
		*/
	public int setCar_prepare(String c_id, String serv_gubun)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		
		String query = "";
		
     
       if ( serv_gubun.equals("2") ) {       	
       		query = "UPDATE car_reg SET prepare = '2', off_ls = '0' ,  rm_yn = 'N' WHERE car_mng_id = '"+c_id+"'";
       } else if ( serv_gubun.equals("1") ) {       	
       		query = "UPDATE car_reg SET secondhand = '1' , secondhand_dt = to_char(sysdate,'YYYYMMdd')   WHERE car_mng_id = '"+c_id+"'";
       } else {
       		query = "UPDATE car_reg SET rm_yn = 'Y' WHERE car_mng_id = '"+c_id+"'";       	
       }		

		
		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			result = pstmt.executeUpdate();

			conn.commit();
		 	} catch (Exception e) {
	  		System.out.println("[AccuDatabase:setCar_prepare]\n"+e);
			System.out.println("[AccuDatabase:setCar_prepare]\n"+query);
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return result;
		}
	}
	
	
	//   *************************  중도매입옵션관련   ******************************************
		
	 //중도매입관련 금액 구하기
	public Hashtable getVarAmt(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";		
			
			
		query = 	" select  d.k_r  tax_amt ,  d.c_s insur_amt, d.g_7 serv_amt  \n " +
						"		from   cont a, fee b, fee_etc c, esti_exam d  \n " +
						"		where   a.rent_mng_id= '"+rent_mng_id+"'  AND a.rent_l_cd= '"+rent_l_cd+"'  \n " +
						"		     and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.RENT_L_CD  \n " +
						"		      and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.RENT_L_CD and b.rent_st=c.rent_st   \n " +
						"		      and c.bc_est_id=d.est_id   \n " +
						"		      and b.rent_st = (select max(to_number(rent_st)) from fee where rent_l_cd= '"+rent_l_cd+"'  ) ";
           	
				
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
		} catch (SQLException e) {
			System.out.println("[AccDatabase:getVarAmt]\n"+e);			
			System.out.println("[AccDatabase:getVarAmt]\n"+query);			
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
			
	//중도매입옵션 정산시 대여료 스케쥴 조회
	public Vector getScdFeeList( String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";		
			
				
		 query = " select to_number(fee_tm) fee_tm , fee_est_dt r_fee_est_dt, fee_s_amt, fee_v_amt from scd_fee  \n " +
 						"where rent_mng_id = '"+ rent_mng_id + "' and rent_l_cd = '" + rent_l_cd + "' and rc_yn = '0'   \n " +
 						" order by to_number(fee_tm), tm_st1  ";				
	

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
		} catch (SQLException e) {
			System.out.println("[AccuDatabase:getScdFeeList]\n"+e);			
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
	 *	cls_etc 추가사항  
	 */
	public boolean insertClsEtcAdd(ClsEtcAddBean ca)
	{
		getConnection();
		boolean flag = true;
	//	String query_seq = "";
	//	int seq = 0;
	 				
		String query = "insert into cls_etc_add ("+
				" RENT_MNG_ID,	RENT_L_CD, a_f, old_opt_amt , add_saction_id ,	 "+ //5
				" rc_rate, mt, b_old_opt_amt , count1,  count2, m_r_fee_amt  ) values( "+  //6
			 	" ?, ?, ?, ?, ?,  "+  //5
				" ?, ?, ? , ? ,? ,? ) ";  //6

		        							
		PreparedStatement pstmt = null;
					
		try 
		{
			conn.setAutoCommit(false);
	
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, ca.getRent_mng_id());
			pstmt.setString(2, ca.getRent_l_cd());
			pstmt.setFloat(3, ca.getA_f());			
			pstmt.setInt(4, ca.getOld_opt_amt());
			pstmt.setString(5, ca.getAdd_saction_id());
			
			pstmt.setFloat(6, ca.getRc_rate());	
			pstmt.setString(7, ca.getMt());
			pstmt.setInt(8, ca.getB_old_opt_amt());
			pstmt.setInt(9, ca.getCount1());
			pstmt.setInt(10, ca.getCount2());
			pstmt.setInt(11, ca.getM_r_fee_amt());
								
			pstmt.executeUpdate();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[AccuDatabase:insertClsEtcAdd]\n"+e);			
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
		
	public boolean insertClsEtcDetail(ClsEtcDetailBean cd)
	{
		getConnection();
		boolean flag = true;
	//	String query_seq = "";
	//	int seq = 0;
	 
		String query = "insert into cls_etc_detail ("+
							" RENT_MNG_ID,	RENT_L_CD,	 "+ //2
							" S_FEE_TM, S_R_FEE_EST_DT, S_FEE_S_AMT, S_TAX_AMT,  S_IS_AMT, S_CAL_AMT,   " +   //6
							" S_R_FEE_S_AMT, S_R_FEE_V_AMT, S_R_FEE_AMT, S_RC_RATE,  S_CAL_DAYS,  " + //5
							" S_GRT_AMT, S_G_FEE_AMT ) values ( "+  //2
						 	" ?, ?, "+  //2
						 	" ?, replace(?, '-', ''), ?, ?, ?, ?, "+  //6
							" ?, ?, ?, ?, ? ,  "+  //5
							" ?, ? ) ";  //2 
		        							
		PreparedStatement pstmt = null;			
	    
		try 
		{
			conn.setAutoCommit(false);
	
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, cd.getRent_mng_id());
			pstmt.setString(2, cd.getRent_l_cd());
			pstmt.setInt(3, cd.getS_fee_tm());
			pstmt.setString(4, cd.getS_r_fee_est_dt());
			pstmt.setInt(5, cd.getS_fee_s_amt());
			pstmt.setInt(6, cd.getS_tax_amt());
			pstmt.setInt(7, cd.getS_is_amt());
			pstmt.setInt(8, cd.getS_cal_amt());
			pstmt.setInt(9, cd.getS_r_fee_s_amt());
			pstmt.setInt(10, cd.getS_r_fee_v_amt());
			pstmt.setInt(11, cd.getS_r_fee_amt());			
			pstmt.setFloat(12, cd.getS_rc_rate());			
			pstmt.setInt(13, cd.getS_cal_days());
			pstmt.setInt(14, cd.getS_grt_amt());			
			pstmt.setInt(15, cd.getS_g_fee_amt());			
								
			pstmt.executeUpdate();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[AccuDatabase:insertClsEtcDetail]\n"+e);			
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
	 *	해지의뢰세금계산서내역삭제 - 담당자 결재요청전
	 */
	/*
	public boolean deleteClsEtcAdd(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		boolean flag = true;
		String query = "delete from cls_etc_add "+
						" where rent_mng_id = ? and rent_l_cd = ?  ";  //2
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
					
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
			
		    pstmt.executeUpdate();

			conn.commit();
		    
	  	} catch (Exception e) {
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
	*/
		/**
	 *	해지의뢰  중도매입상세내역 - 담당자 결재요청전
	 */
	/*
	public boolean deleteClsEtcDetail(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		boolean flag = true;
		String query = "delete from cls_etc_detail  "+
						" where rent_mng_id = ? and rent_l_cd = ?  ";  //2
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
					
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
			
		    pstmt.executeUpdate();

			conn.commit();
		    
	  	} catch (Exception e) {
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
	*/
	
	/**
	 *	해지의뢰 추가 항목 
	 */
	/*
	public boolean deleteClsEtcMore(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		boolean flag = true;
		String query = "delete from cls_etc_more "+
						" where rent_mng_id = ? and rent_l_cd = ?  ";  //2
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
					
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
			
		    pstmt.executeUpdate();

			conn.commit();
		    
	  	} catch (Exception e) {
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
	} */
		
		//중도매입옵션  중도정산서회
	public Vector getClsEtcDetailList( String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";		
							
		query = " select * from cls_etc_detail  " +
 						"where rent_mng_id = '"+ rent_mng_id + "' and rent_l_cd = '" + rent_l_cd + "' \n " +
 						" order by to_number(s_fee_tm) ";				
	
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
		} catch (SQLException e) {
			System.out.println("[AccuDatabase:getClsEtcDetailList]\n"+e);			
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
		
		/*해지의뢰 수정페이지 조회  : 차량채권정보  rent_mng_id, rent_l_cd  */
	public ClsEtcAddBean getClsEtcAddInfo(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		ClsEtcAddBean clsa = new ClsEtcAddBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		
		query = " select "+
				" a.RENT_MNG_ID, a.RENT_L_CD,  "+ 
				" a.a_f, a.old_opt_amt, a.add_saction_id, a.add_saction_dt ,  "+
				" a.rc_rate, a.b_old_opt_amt, a.mt, a.count1, a.count2, a.m_r_fee_amt  "+  //6
				" from cls_etc_add a where  a.RENT_MNG_ID = ? and a.RENT_L_CD = ? ";
						
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
	    	rs = pstmt.executeQuery();
	    	        	
			while(rs.next())
			{ 
				clsa.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				clsa.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				 
				clsa.setA_f(rs.getFloat("a_f"));
				clsa.setOld_opt_amt(rs.getInt("old_opt_amt"));	
				clsa.setAdd_saction_id(rs.getString("add_saction_id")==null?"":rs.getString("add_saction_id"));
				clsa.setAdd_saction_dt(rs.getString("add_saction_dt")==null?"":rs.getString("add_saction_dt"));	
				
				clsa.setRc_rate(rs.getFloat("rc_rate"));
				clsa.setB_old_opt_amt(rs.getInt("b_old_opt_amt"));	
				clsa.setMt(rs.getString("mt")==null?"":rs.getString("mt"));
				clsa.setCount1(rs.getInt("count1"));	
				clsa.setCount2(rs.getInt("count2"));	
				clsa.setM_r_fee_amt(rs.getInt("m_r_fee_amt"));		
	
			}
		} catch (SQLException e) {
			System.out.println("[AccuDatabase:getClsEtcAddInfo]\n"+e);	
			System.out.println(query);		
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return clsa;
		}
	}
	
	/**
	 *	중도매입옵션 정산금  결재
	 */
	public boolean updateClsEtcAdd(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		boolean flag = true;
		String query = " update cls_etc_add set ADD_SACTION_DT = to_char(sysdate,'YYYYMMdd')  "+
						" where rent_mng_id = ? and rent_l_cd = ?  ";  //2
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
					
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
			
		    pstmt.executeUpdate();

			conn.commit();
		    
	  	} catch (Exception e) {
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
	
	
	public boolean updateClsEtcAdd(ClsEtcAddBean clsa)
	{
		getConnection();
		boolean flag = true;
		String query = " update cls_etc_add set "+
						" a_f = ?, old_opt_amt = ?, add_saction_id = ? "+ //9  
						" where rent_mng_id = ? and rent_l_cd = ?";
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			
			pstmt.setFloat  (1, clsa.getA_f()); //5			
			pstmt.setInt   (2, clsa.getOld_opt_amt()); 			
			pstmt.setString(3, clsa.getAdd_saction_id());  //7		
														
			pstmt.setString(4, clsa.getRent_mng_id());
			pstmt.setString(5, clsa.getRent_l_cd());

			pstmt.executeUpdate();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AccuDatabase:updateClsEtcAdd]\n"+e);			
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
	
	
	/**********************************        해지정산 사전 관리                                      ************************************/
	/**
	 *	해지 insert
	 */
	
	public boolean insertClsEst(ClsEstBean cls)
	{
		getConnection();
		boolean flag = true;
		String query = "insert into cls_est ("+
							" RENT_MNG_ID,	RENT_L_CD,	CLS_ST,		TERM_YN,	CLS_DT, "+ //5
							" REG_ID,		CLS_CAU,	TRF_DT, 	IFEE_S_AMT,	IFEE_V_AMT, IFEE_ETC,	PP_S_AMT,	PP_V_AMT, "+  //8
							" PP_ETC,		PDED_S_AMT, PDED_V_AMT, PDED_ETC,	TPDED_S_AMT,"+  //5
						 	" TPDED_V_AMT,	TPDED_ETC,	RFEE_S_AMT, RFEE_V_AMT, RFEE_ETC, "+  //5
						 	" DFEE_TM,		DFEE_V_AMT, NFEE_TM,	NFEE_S_AMT, "+ //4
							" NFEE_V_AMT,	NFEE_MON,	NFEE_DAY,	NFEE_AMT,	TFEE_AMT, "+  //5
						 	" MFEE_AMT,		RCON_MON,	RCON_DAY,	TRFEE_AMT,	DFT_INT, "+   //5
							" DFT_AMT,		NO_DFT_YN,	NO_DFT_CAU,	FDFT_AMT1,	FDFT_DC_AMT,"+ //5
						 	" FDFT_AMT2,	PAY_DT,		NFEE_DAYS,	RCON_DAYS,	"+   //4
							" CLS_EST_DT,	VAT_ST,		EXT_DT,		EXT_ID,		GRT_AMT, "+ //5
							" CLS_DOC_YN,	OPT_PER,	OPT_AMT,	OPT_DT,	 "+ //4
							" dly_amt, no_v_amt, car_ja_amt, r_mon, r_day, cls_s_amt, cls_v_amt, etc_amt, fine_amt, ex_di_amt, "+  //10
							" ifee_mon, ifee_day, ifee_ex_amt, rifee_s_amt, cancel_yn, reg_dt, etc2_amt, etc3_amt, etc4_amt,  "+ //9(8)
							" DIV_ST, DIV_CNT, EST_DT, EST_AMT, EST_NM, GUR_NM, GUR_REL_TEL, GUR_REL, REMARK, "+ //9
					 	    " dfee_amt, "+ //1
							" fine_amt_1, car_ja_amt_1, dly_amt_1, etc_amt_1,  etc2_amt_1, dft_amt_1, ex_di_amt_1, nfee_amt_1,  "+ //8
							" etc3_amt_1, etc4_amt_1,  no_v_amt_1,  fdft_amt1_1, dfee_amt_1, "+ //5					
							" tax_chk0, tax_chk1, tax_chk2, tax_chk3, tax_chk4, tax_chk5, tax_chk6, "+//7
							" rifee_s_amt_s, rfee_s_amt_s, etc_amt_s,  etc2_amt_s,  "+ //4
							" dfee_amt_s, dft_amt_s, etc4_amt_s,  "+  //3
							" rifee_s_amt_v, rfee_s_amt_v, etc_amt_v,  etc2_amt_v,  "+ //4
							" dfee_amt_v, dft_amt_v, etc4_amt_v, car_ja_no_amt, dft_int_1, fdft_amt3, "+ //6
							" tot_dist, cms_chk , tax_reg_gu , dft_cost_id,  serv_st,  " + //5
							"  over_amt, over_amt_1,  over_amt_s, over_amt_v,  match,  serv_gubun  ) values( "+   //6
						 	" ?, ?, ?, ?, replace(?, '-', ''), "+  //5
							" ?, ?, replace(?, '-', ''), ?, ?, ?, ?, ?, "+  //8
						 	" ?, ?, ?, ?, ?, "+ //5
							" ?, ?, ?, ?, ?, "+ //5
						 	" ?, ?, ?, ?,  "+ //4
							" ?, ?, ?, ?, ?, "+ //5
						 	" ?, ?, ?, ?, ?, "+ //5
							" ?, ?, ?, ?, ?, "+ //5
						 	" ?, ?, ?, ?,  "+ //4
							" replace(?, '-', ''), ?, replace(?, '-', ''), ?, ?,"+ //5
						 	" ?, ?, ?, replace(?, '-', ''), "+  //4
							" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+ //10
							" ?, ?, ?, ?, ?, to_char(sysdate,'YYYYMMDD'), ?, ?, ?, " + //9(8)
							" ?, ?, replace(?, '-', ''), ?, ?, ?, ?, ?, ?, " + //9				
							" ?, " +  //1
							" ?, ?, ?, ?, ?, ?, ?, ?, " + //8
							" ?, ?, ?, ?, ?, " +   //5					
							" ?, ?, ?, ?, ?, ?, ?, " + //7
							" ?, ?, ?, ?,  " +   //4
							" ?, ?, ?,  "+ //3
							" ?, ?, ?, ?, " +   //4
							" ?, ?, ? , ?, ?, ?,  " + //6
							" ?, ?, ? , ?, ?,  "+  //5
							" ?, ?, ? , ? , ?,  ?  )"; //6

									
		PreparedStatement pstmt = null;
		
		ResultSet rs = null;
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, cls.getRent_mng_id());
			pstmt.setString(2, cls.getRent_l_cd());
			pstmt.setString(3, cls.getCls_st());
			pstmt.setString(4, cls.getTerm_yn());
			pstmt.setString(5, cls.getCls_dt()); //5
			
			pstmt.setString(6, cls.getReg_id());
			pstmt.setString(7, cls.getCls_cau());
			pstmt.setString(8, cls.getTrf_dt());
			pstmt.setInt   (9, cls.getIfee_s_amt());
			pstmt.setInt   (10, cls.getIfee_v_amt());
			pstmt.setString(11, cls.getIfee_etc());
			pstmt.setInt   (12, cls.getPp_s_amt());
			pstmt.setInt   (13, cls.getPp_v_amt()); //8
			
			pstmt.setString(14, cls.getPp_etc());
			pstmt.setInt   (15, cls.getPded_s_amt());
			pstmt.setInt   (16, cls.getPded_v_amt());
			pstmt.setString(17, cls.getPded_etc());
			pstmt.setInt   (18, cls.getTpded_s_amt());  //5
			
			pstmt.setInt   (19, cls.getTpded_v_amt());
			pstmt.setString(20, cls.getTpded_etc());
			pstmt.setInt   (21, cls.getRfee_s_amt());
			pstmt.setInt   (22, cls.getRfee_v_amt());
			pstmt.setString(23, cls.getRfee_etc());  //5
			
			pstmt.setString(24, cls.getDfee_tm());		
			pstmt.setInt   (25, cls.getDfee_v_amt());
			pstmt.setString(26, cls.getNfee_tm());
			pstmt.setInt   (27, cls.getNfee_s_amt()); //4
			
			pstmt.setInt   (28, cls.getNfee_v_amt());
			pstmt.setString(29, cls.getNfee_mon());
			pstmt.setString(30, cls.getNfee_day());
			pstmt.setInt   (31, cls.getNfee_amt());
			pstmt.setInt   (32, cls.getTfee_amt());  //5
			
			pstmt.setInt   (33, cls.getMfee_amt());
			pstmt.setString(34, cls.getRcon_mon());
			pstmt.setString(35, cls.getRcon_day());
			pstmt.setInt   (36, cls.getTrfee_amt());
			pstmt.setString(37, cls.getDft_int());  //5
			
			pstmt.setInt   (38, cls.getDft_amt());
			pstmt.setString(39, cls.getNo_dft_yn());
			pstmt.setString(40, cls.getNo_dft_cau());
			pstmt.setInt   (41, cls.getFdft_amt1());
			pstmt.setInt   (42, cls.getFdft_dc_amt());  //5
			
			pstmt.setInt   (43, cls.getFdft_amt2());
			pstmt.setString(44, cls.getPay_dt());
			pstmt.setString(45, cls.getNfee_days());
			pstmt.setString(46, cls.getRcon_days()); //4								
						
			pstmt.setString(47, cls.getCls_est_dt());			
			pstmt.setString(48, cls.getVat_st());			
			pstmt.setString(49, cls.getExt_dt());			
			pstmt.setString(50, cls.getExt_id());			
			pstmt.setInt   (51, cls.getGrt_amt());  //5
			
			pstmt.setString(52, cls.getCls_doc_yn());			
			pstmt.setString(53, cls.getOpt_per());			
			pstmt.setInt   (54, cls.getOpt_amt());
			pstmt.setString(55, cls.getOpt_dt());			
												
			pstmt.setInt   (56, cls.getDly_amt());
			pstmt.setInt   (57, cls.getNo_v_amt());
			pstmt.setInt   (58, cls.getCar_ja_amt());
			pstmt.setString(59, cls.getR_mon());			
			pstmt.setString(60, cls.getR_day());			
			pstmt.setInt   (61, cls.getCls_s_amt());
			pstmt.setInt   (62, cls.getCls_v_amt());
			pstmt.setInt   (63, cls.getEtc_amt());
			pstmt.setInt   (64, cls.getFine_amt());
			pstmt.setInt   (65, cls.getEx_di_amt());   //10
						
			pstmt.setString(66, cls.getIfee_mon());			
			pstmt.setString(67, cls.getIfee_day());			
			pstmt.setInt   (68, cls.getIfee_ex_amt());
			pstmt.setInt   (69, cls.getRifee_s_amt());
			pstmt.setString(70, cls.getCancel_yn());
			pstmt.setInt   (71, cls.getEtc2_amt());
			pstmt.setInt   (72, cls.getEtc3_amt());
			pstmt.setInt   (73, cls.getEtc4_amt());	  //9(8)
						
			pstmt.setString(74, cls.getDiv_st());			
			pstmt.setInt   (75, cls.getDiv_cnt());			
			pstmt.setString(76, cls.getEst_dt());
			pstmt.setInt   (77, cls.getEst_amt());
			pstmt.setString(78, cls.getEst_nm());
			pstmt.setString(79, cls.getGur_nm());
			pstmt.setString(80, cls.getGur_rel_tel());
			pstmt.setString(81, cls.getGur_rel());
			pstmt.setString(82, cls.getRemark());    //9
							 	
			pstmt.setInt   (83, cls.getDfee_amt());		//1
		
			pstmt.setInt   (84, cls.getFine_amt_1());
			pstmt.setInt   (85, cls.getCar_ja_amt_1());
			pstmt.setInt   (86, cls.getDly_amt_1());
			pstmt.setInt   (87, cls.getEtc_amt_1());
			pstmt.setInt   (88, cls.getEtc2_amt_1());
			pstmt.setInt   (89, cls.getDft_amt_1());
			pstmt.setInt   (90, cls.getEx_di_amt_1());  
			pstmt.setInt   (91, cls.getNfee_amt_1());  //8
			
			pstmt.setInt   (92, cls.getEtc3_amt_1());
			pstmt.setInt   (93, cls.getEtc4_amt_1());
			pstmt.setInt   (94, cls.getNo_v_amt_1());
			pstmt.setInt   (95, cls.getFdft_amt1_1());
			pstmt.setInt   (96, cls.getDfee_amt_1());  //5
										
			pstmt.setString(97, cls.getTax_chk0());	
			pstmt.setString(98, cls.getTax_chk1());	
			pstmt.setString(99, cls.getTax_chk2());	
			pstmt.setString(100, cls.getTax_chk3());	
			pstmt.setString(101, cls.getTax_chk4());	
			pstmt.setString(102, cls.getTax_chk5());	
			pstmt.setString(103, cls.getTax_chk6());	//7
								
			pstmt.setInt   (104, cls.getRifee_s_amt_s());
			pstmt.setInt   (105, cls.getRfee_s_amt_s());		
			pstmt.setInt   (106, cls.getEtc_amt_s());
			pstmt.setInt   (107, cls.getEtc2_amt_s());
			
			pstmt.setInt   (108, cls.getDfee_amt_s());
			pstmt.setInt   (109, cls.getDft_amt_s());
			pstmt.setInt   (110, cls.getEtc4_amt_s());
					
			pstmt.setInt   (111, cls.getRifee_s_amt_v());
			pstmt.setInt   (112, cls.getRfee_s_amt_v());		
			pstmt.setInt   (113, cls.getEtc_amt_v());
			pstmt.setInt   (114, cls.getEtc2_amt_v());
			
			pstmt.setInt   (115, cls.getDfee_amt_v());
			pstmt.setInt   (116, cls.getDft_amt_v());
			pstmt.setInt   (117, cls.getEtc4_amt_v());
			pstmt.setInt   (118, cls.getCar_ja_no_amt());			
			pstmt.setString(119, cls.getDft_int_1());		
			pstmt.setInt   (120, cls.getFdft_amt3()); //6
					
			pstmt.setInt   (121, cls.getTot_dist());	
			pstmt.setString(122, cls.getCms_chk());				
			pstmt.setString(123, cls.getTax_reg_gu());				
			pstmt.setString(124, cls.getDft_cost_id());						
			pstmt.setString(125, cls.getServ_st());  //8
			
			pstmt.setInt   (126, cls.getOver_amt());
			pstmt.setInt   (127, cls.getOver_amt_1());
			pstmt.setInt   (128, cls.getOver_amt_s());
			pstmt.setInt   (129, cls.getOver_amt_v());   	
			pstmt.setString(130, cls.getMatch());  									
			pstmt.setString(131, cls.getServ_gubun());  // 예비차 적용형태 
					
			pstmt.executeUpdate();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[AccuDatabase:insertClsEst]\n"+e);			
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
	 *	초과운행  insert
	 */
	public boolean insertClsEstOver(ClsEtcOverBean co)
	{
		getConnection();
		boolean flag = true;
		String query = "insert into cls_est_over ( "+
							" RENT_MNG_ID, RENT_L_CD, RENT_DAYS, CAL_DIST, FIRST_DIST, LAST_DIST, REAL_DIST,  "+ //7
						 	" OVER_DIST, ADD_DIST, JUNG_DIST, R_OVER_AMT,   M_OVER_AMT,  J_OVER_AMT, "+		//6		
						 	" M_SACTION_DT, M_SACTION_ID, M_REASON) values("+ //3
						 	" ?,  ?,  ?,  ?,  ?,  ?,  ?, "+
						 	" ?,  ?,  ?,  ?,  ?,  ?,  "+ 								
						 	" ?,  ?,  ?  )";
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, co.getRent_mng_id());
			pstmt.setString(2, co.getRent_l_cd());
			pstmt.setInt(3,	co.getRent_days());
			pstmt.setInt(4, co.getCal_dist());
			pstmt.setInt(5, co.getFirst_dist());
			pstmt.setInt(6, co.getLast_dist());
			pstmt.setInt(7, co.getReal_dist());
			pstmt.setInt(8, co.getOver_dist());
			pstmt.setInt(9, co.getAdd_dist());
			pstmt.setInt(10, co.getJung_dist());
			pstmt.setInt(11, co.getR_over_amt());
			pstmt.setInt(12, co.getM_over_amt());		
			pstmt.setInt(13, co.getJ_over_amt());
			pstmt.setString(14, co.getM_saction_dt());
			pstmt.setString(15, co.getM_saction_id());
			pstmt.setString(16, co.getM_reason());		
		 
		    	pstmt.executeUpdate();
			conn.commit();
		   
	  	} catch (Exception e) {
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
	 *	cls_etc 추가사항  
	 */
	public boolean insertClsEstAdd(ClsEtcAddBean ca)
	{
		getConnection();
		boolean flag = true;
	//	String query_seq = "";
	//	int seq = 0;
	 
		String query = "insert into cls_est_add ("+
							" RENT_MNG_ID,	RENT_L_CD, a_f, old_opt_amt , add_saction_id ,	 "+ //5
							" rc_rate, mt, b_old_opt_amt , count1,  count2, m_r_fee_amt  ) values( "+  //6
						 	" ?, ?, ?, ? , ?,  "+  //5
							" ?, ? , ? , ? ,? ,? ) ";  //6
 
		        							
		PreparedStatement pstmt = null;		
		
		try 
		{
			conn.setAutoCommit(false);
	
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, ca.getRent_mng_id());
			pstmt.setString(2, ca.getRent_l_cd());
			pstmt.setFloat(3, ca.getA_f());			
			pstmt.setInt(4, ca.getOld_opt_amt());
			pstmt.setString(5, ca.getAdd_saction_id());
			
			pstmt.setFloat(6, ca.getRc_rate());	
			pstmt.setString(7, ca.getMt());
			pstmt.setInt(8, ca.getB_old_opt_amt());
			pstmt.setInt(9, ca.getCount1());
			pstmt.setInt(10, ca.getCount2());
			pstmt.setInt(11, ca.getM_r_fee_amt());
								
			pstmt.executeUpdate();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[AccuDatabase:insertClsEstAdd]\n"+e);			
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
		
	public boolean insertClsEstDetail(ClsEtcDetailBean cd)
	{
		getConnection();
		boolean flag = true;
	//	String query_seq = "";
	//	int seq = 0;
	 
		String query = "insert into cls_est_detail ("+
							" RENT_MNG_ID,	RENT_L_CD,	 "+ //2
							" S_FEE_TM, S_R_FEE_EST_DT, S_FEE_S_AMT, S_TAX_AMT,  S_IS_AMT, S_CAL_AMT,   " +   //6
							" S_R_FEE_S_AMT, S_R_FEE_V_AMT, S_R_FEE_AMT, S_RC_RATE,  S_CAL_DAYS,  " +   //5
							"  S_GRT_AMT, S_G_FEE_AMT ) values ( "+  //5
						 	" ?, ?, "+  //2
						 	" ?, replace(?, '-', ''), ?, ?, ?, ?, "+  //6
							" ?, ?, ?, ?, ?, "+  //5
							" ?, ?  ) ";  //5 
		        							
		PreparedStatement pstmt = null;			
	    
		try 
		{
			conn.setAutoCommit(false);
	
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, cd.getRent_mng_id());
			pstmt.setString(2, cd.getRent_l_cd());
			pstmt.setInt(3, cd.getS_fee_tm());
			pstmt.setString(4, cd.getS_r_fee_est_dt());
			pstmt.setInt(5, cd.getS_fee_s_amt());
			pstmt.setInt(6, cd.getS_tax_amt());
			pstmt.setInt(7, cd.getS_is_amt());
			pstmt.setInt(8, cd.getS_cal_amt());
			pstmt.setInt(9, cd.getS_r_fee_s_amt());
			pstmt.setInt(10, cd.getS_r_fee_v_amt());
			pstmt.setInt(11, cd.getS_r_fee_amt());			
			pstmt.setFloat(12, cd.getS_rc_rate());			
			pstmt.setInt(13, cd.getS_cal_days());
			pstmt.setInt(14, cd.getS_grt_amt());			
			pstmt.setInt(15, cd.getS_g_fee_amt());			
								
			pstmt.executeUpdate();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[AccuDatabase:insertClsEstDetail]\n"+e);			
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
	
	
//해지정산 사전관리 리스트 조회 - chk:1:계약해지  2:매입옵션, 3:월렌트
	public Vector getClsEstDocList(String s_kd, String t_wd, String gubun1, String andor, String chk)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select /*+  merge(a) */ b.term_yn, \n"+
				" a.rent_mng_id, a.rent_l_cd, a.client_id, a.car_mng_id, b.cls_dt,\n"+
				" a.rent_dt, a.firm_nm, c.car_no, c.car_nm, a.rent_start_dt, \n"+
				"  u.user_nm as bus_nm, b.cls_cau, \n"+
				" decode(a.use_yn,'Y','진행','N','해지','미결') use_st, b.cls_st, \n"+
				" decode(b.cls_st,'1','계약만료','2','중도해약', '8', '매입옵션', '7', '출고전해지(신차)', '10', '개시전해지(재리스)',  '14', '월렌트해지' ,  '') cls_st_nm,  c.fuel_kd  \n"+			
				" from cls_est b, users u,  car_reg c,  cont_n_view a \n"+			
				" where  b.rent_mng_id=a.RENT_MNG_ID and b.rent_l_cd=a.rent_l_cd \n"+
				" and  a.car_mng_id = c.car_mng_id(+) and b.reg_id = u.user_id " ;
			
		if(s_kd.equals("1"))	query += " and nvl(a.firm_nm, ' ') like '%"+t_wd+"%'";
		if(s_kd.equals("2"))	query += " and nvl(a.rent_l_cd, ' ') like '%"+t_wd+"%'";	
		if(s_kd.equals("3"))	query += " and nvl(c.car_no, ' ') like '%"+t_wd+"%'";	
		if(s_kd.equals("6"))	query += " and b.cls_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' ";	
			 					
		if(s_kd.equals("5") ) {
			if ( !t_wd.equals("")) {
				query += " and b.cls_dt like '"+t_wd+"%'";
			} else {
				query += " and b.cls_dt like to_char(sysdate, 'yyyy')||'%'" ;		
			}	
		
		}
			
		query += " order by b.cls_dt desc , a.rent_dt, a.rent_start_dt, a.rent_mng_id";

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
			System.out.println("[DocSettleDatabase:getClsEstDocList]\n"+e);
			System.out.println("[DocSettleDatabase:getClsEstDocList]\n"+query);
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
	
	
	public ClsEstBean getClsEstCase(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		ClsEstBean cls = new ClsEstBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		query = " select"+
				" a.RENT_MNG_ID, a.RENT_L_CD, a.TERM_YN, a.cls_st cls_st_r,"+ 
				" decode(a.CLS_ST, '1','계약만료', '2','중도해약', '3','영업소변경', '4','차종변경', '5','계약승계', '6','매각', '7','출고전해지(신차)', '8','매입옵션', '9', '폐차', '10' , '개시전해지(재리스)',  '14' , '월렌트해지' ) CLS_ST,"+
				" a.CLS_DT, a.REG_ID, a.CLS_CAU, "+
				" a.IFEE_S_AMT, a.IFEE_V_AMT, a.IFEE_ETC, a.PP_S_AMT, a.PP_V_AMT, a.PP_ETC,"+
				" a.PDED_S_AMT, a.PDED_V_AMT, a.PDED_ETC, a.TPDED_S_AMT, a.TPDED_V_AMT, a.TPDED_ETC, a.RFEE_S_AMT,"+
				" a.RFEE_V_AMT, a.RFEE_ETC, a.DFEE_TM, a.DFEE_V_AMT, a.NFEE_TM, a.NFEE_S_AMT, a.NFEE_V_AMT,"+
				" rtrim(a.NFEE_MON) NFEE_MON, rtrim(a.NFEE_DAY) NFEE_DAY, a.NFEE_AMT, a.TFEE_AMT, a.MFEE_AMT, a.NO_V_AMT,"+
				" rtrim(a.RCON_MON) RCON_MON, rtrim(a.RCON_DAY) RCON_DAY,"+
				" a.TRFEE_AMT, a.DFT_INT, a.DFT_AMT, a.NO_DFT_YN, a.NO_DFT_CAU, a.FDFT_AMT1, a.FDFT_DC_AMT, a.FDFT_AMT2,"+		
				" decode(a.opt_dt, '', '', substr(a.opt_dt, 1, 4) || '-' || substr(a.opt_dt, 5, 2) || '-'||substr(a.opt_dt, 7, 2)) opt_dt,"+
				" a.NFEE_DAYS, a.RCON_DAYS, a.cls_est_dt, a.ext_dt, a.ext_id, a.vat_st, a.grt_amt, a.opt_per, a.opt_amt,"+
				" a.dly_amt, a.no_v_amt, a.car_ja_amt, a.etc_amt, a.r_mon, a.r_day, a.cls_s_amt, a.cls_v_amt, a.fine_amt, a.ex_di_amt, a.ifee_mon, a.ifee_day, a.ifee_ex_amt, a.rifee_s_amt, a.cancel_yn, "+
				" a.etc2_amt, a.etc3_amt, a.etc4_amt, a.dfee_amt, a.FDFT_AMT1_1, "+
				" a.ex_di_amt_1, a.dly_amt_1, a.no_v_amt_1, a.car_ja_amt_1, a.etc_amt_1, a.fine_amt_1, a.etc2_amt_1, a.etc3_amt_1, a.etc4_amt_1, a.nfee_amt_1, a.dfee_amt_1, a.DFT_AMT_1, "+
				" decode(a.div_st, '1','일시납', '2','분납' ) DIV_ST, a.div_cnt, " +
				" decode(a.est_dt, '', '', substr(a.est_dt, 1, 4) || '-' || substr(a.est_dt, 5, 2) || '-'||substr(a.est_dt, 7, 2)) est_dt,"+
				" a.est_amt, a.est_nm, a.gur_nm, a.gur_rel_tel, a.gur_rel, a.remark , a.dfee_amt, "+
				" a.tax_chk0, a.tax_chk1, a.tax_chk2,a.tax_chk3, a.tax_chk4, a.tax_chk5, a.tax_chk6, "+
				" dft_amt_s, etc_amt_s, etc2_amt_s, etc4_amt_s, dft_amt_v, etc_amt_v, etc2_amt_v, etc4_amt_v , car_ja_no_amt, dft_int_1,  "+				
				"  a.fdft_amt3, "+
				"  a.tax_reg_gu, a.tot_dist, a.cms_chk , a.ext_st , a.r_tax_dt, " +
				"  a.opt_s_amt, a.opt_v_amt ,  a.serv_st ,  " +
				" a.over_amt, a.over_amt_1 ,a.over_amt_s , a.over_amt_v  "+
				" from cls_est a \n "+
				" where  a.RENT_MNG_ID = ? and a.RENT_L_CD = ? ";
						
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
	    	rs = pstmt.executeQuery();	 
	    	
  
	    	
			while(rs.next())
			{
				cls.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				cls.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				cls.setCls_st(rs.getString("CLS_ST")==null?"":rs.getString("CLS_ST"));	   
				cls.setCls_st_r(rs.getString("CLS_ST_R")==null?"":rs.getString("CLS_ST_R"));	      
				cls.setTerm_yn(rs.getString("TERM_YN")==null?"":rs.getString("TERM_YN"));	
				cls.setCls_dt(rs.getString("CLS_DT")==null?"":rs.getString("CLS_DT"));	
				cls.setReg_id(rs.getString("REG_ID")==null?"":rs.getString("REG_ID"));	
				cls.setCls_cau(rs.getString("CLS_CAU")==null?"":rs.getString("CLS_CAU"));	

				cls.setIfee_s_amt(rs.getInt("IFEE_S_AMT"));
				cls.setIfee_v_amt(rs.getInt("IFEE_V_AMT"));
				cls.setIfee_etc(rs.getString("IFEE_ETC")==null?"":rs.getString("IFEE_ETC"));	
				cls.setPp_s_amt(rs.getInt("PP_S_AMT"));
				cls.setPp_v_amt(rs.getInt("PP_V_AMT"));
				cls.setPp_etc(rs.getString("PP_ETC")==null?"":rs.getString("PP_ETC"));	
				cls.setPded_s_amt(rs.getInt("PDED_S_AMT"));
				cls.setPded_v_amt(rs.getInt("PDED_V_AMT"));
				cls.setPded_etc(rs.getString("PDED_ETC")==null?"":rs.getString("PDED_ETC"));	
				cls.setTpded_s_amt(rs.getInt("TPDED_S_AMT"));
				cls.setTpded_v_amt(rs.getInt("TPDED_V_AMT"));
				cls.setTpded_etc(rs.getString("TPDED_ETC")==null?"":rs.getString("TPDED_ETC"));
				cls.setRfee_s_amt(rs.getInt("RFEE_S_AMT"));
				cls.setRfee_v_amt(rs.getInt("RFEE_V_AMT"));
				cls.setRfee_etc(rs.getString("RFEE_ETC")==null?"":rs.getString("RFEE_ETC"));	
				cls.setDfee_tm(rs.getString("DFEE_TM")==null?"":rs.getString("DFEE_TM"));	
				cls.setDfee_v_amt(rs.getInt("DFEE_V_AMT"));
				cls.setNfee_tm(rs.getString("NFEE_TM")==null?"":rs.getString("NFEE_TM"));	
				cls.setNfee_s_amt(rs.getInt("NFEE_S_AMT"));
				cls.setNfee_v_amt(rs.getInt("NFEE_V_AMT"));
				cls.setNfee_mon(rs.getString("NFEE_MON")==null?"":rs.getString("NFEE_MON"));
				cls.setNfee_day(rs.getString("NFEE_DAY")==null?"":rs.getString("NFEE_DAY"));
				cls.setNfee_amt(rs.getInt("NFEE_AMT"));
				cls.setTfee_amt(rs.getInt("TFEE_AMT"));
				cls.setMfee_amt(rs.getInt("MFEE_AMT"));
				cls.setRcon_mon(rs.getString("RCON_MON")==null?"":rs.getString("RCON_MON"));
				cls.setRcon_day(rs.getString("RCON_DAY")==null?"":rs.getString("RCON_DAY"));
				cls.setTrfee_amt(rs.getInt("TRFEE_AMT"));
				cls.setDft_int(rs.getString("DFT_INT")==null?"":rs.getString("DFT_INT"));	
				cls.setDft_amt(rs.getInt("DFT_AMT"));
				cls.setNo_dft_yn(rs.getString("NO_DFT_YN")==null?"":rs.getString("NO_DFT_YN"));
				cls.setNo_dft_cau(rs.getString("NO_DFT_CAU")==null?"":rs.getString("NO_DFT_CAU"));
				cls.setFdft_amt1(rs.getInt("FDFT_AMT1"));
				cls.setFdft_dc_amt(rs.getInt("FDFT_DC_AMT"));
				cls.setFdft_amt2(rs.getInt("FDFT_AMT2"));			
				
				cls.setNfee_days(rs.getString("NFEE_DAYS")==null?"":rs.getString("NFEE_DAYS"));
				cls.setRcon_days(rs.getString("RCON_DAYS")==null?"":rs.getString("RCON_DAYS"));
				cls.setCls_est_dt(rs.getString("CLS_EST_DT")==null?"":rs.getString("CLS_EST_DT"));
				cls.setExt_dt(rs.getString("ext_dt")==null?"":rs.getString("ext_dt"));
				cls.setExt_id(rs.getString("ext_id")==null?"":rs.getString("ext_id"));
				cls.setVat_st(rs.getString("vat_st")==null?"":rs.getString("vat_st"));
				cls.setGrt_amt(rs.getInt("grt_amt"));
			
				cls.setOpt_per(rs.getString("opt_per")==null?"":rs.getString("opt_per"));
				cls.setOpt_amt(rs.getInt("opt_amt"));
				cls.setOpt_dt(rs.getString("opt_dt")==null?"":rs.getString("opt_dt"));
																
				cls.setDly_amt(rs.getInt("dly_amt"));
				cls.setNo_v_amt(rs.getInt("no_v_amt"));
				cls.setCar_ja_amt(rs.getInt("car_ja_amt"));
				cls.setFine_amt(rs.getInt("fine_amt"));
				cls.setEtc_amt(rs.getInt("etc_amt"));
				cls.setEtc2_amt(rs.getInt("etc2_amt"));
				cls.setEtc3_amt(rs.getInt("etc3_amt"));
				cls.setEtc4_amt(rs.getInt("etc4_amt"));
				cls.setR_mon(rs.getString("r_mon")==null?"":rs.getString("r_mon"));
				cls.setR_day(rs.getString("r_day")==null?"":rs.getString("r_day"));
				cls.setCls_s_amt(rs.getInt("cls_s_amt"));
				cls.setCls_v_amt(rs.getInt("cls_v_amt"));
				cls.setEx_di_amt(rs.getInt("ex_di_amt"));
				cls.setIfee_mon(rs.getString("ifee_mon")==null?"":rs.getString("ifee_mon"));
				cls.setIfee_day(rs.getString("ifee_day")==null?"":rs.getString("ifee_day"));
				cls.setIfee_ex_amt(rs.getInt("ifee_ex_amt"));
				cls.setRifee_s_amt(rs.getInt("rifee_s_amt"));
				cls.setCancel_yn(rs.getString("cancel_yn")==null?"":rs.getString("cancel_yn"));
											
				cls.setFdft_amt1_1(rs.getInt("FDFT_AMT1_1"));
				cls.setEx_di_amt_1(rs.getInt("ex_di_amt_1"));
				cls.setDly_amt_1(rs.getInt("dly_amt_1"));
				cls.setNo_v_amt_1(rs.getInt("no_v_amt_1"));
				cls.setCar_ja_amt_1(rs.getInt("car_ja_amt_1"));
				cls.setEtc_amt_1(rs.getInt("etc_amt_1"));
				cls.setFine_amt_1(rs.getInt("fine_amt_1"));
				cls.setEtc2_amt_1(rs.getInt("etc2_amt_1"));
				cls.setEtc3_amt_1(rs.getInt("etc3_amt_1"));
				cls.setEtc4_amt_1(rs.getInt("etc4_amt_1"));
				cls.setNfee_amt_1(rs.getInt("nfee_amt_1"));	
				cls.setDfee_amt_1(rs.getInt("dfee_amt_1"));		
				cls.setDft_amt_1(rs.getInt("DFT_AMT_1"));	
				cls.setDiv_st(rs.getString("div_st")==null?"":rs.getString("div_st"));		
				cls.setDiv_cnt(rs.getInt("div_cnt"));		
				cls.setEst_dt(rs.getString("est_dt")==null?"":rs.getString("est_dt"));		
				cls.setEst_amt(rs.getInt("est_amt"));	
				cls.setEst_nm(rs.getString("est_nm")==null?"":rs.getString("est_nm"));		
				cls.setGur_nm(rs.getString("gur_nm")==null?"":rs.getString("gur_nm"));		
				cls.setGur_rel_tel(rs.getString("gur_rel_tel")==null?"":rs.getString("gur_rel_tel"));		
				cls.setGur_rel(rs.getString("gur_rel")==null?"":rs.getString("gur_rel"));		
				cls.setRemark(rs.getString("remark")==null?"":rs.getString("remark"));					
				cls.setDfee_amt(rs.getInt("dfee_amt"));
				
				cls.setTax_chk0(rs.getString("tax_chk0")==null?"":rs.getString("tax_chk0"));	
				cls.setTax_chk1(rs.getString("tax_chk1")==null?"":rs.getString("tax_chk1"));
				cls.setTax_chk2(rs.getString("tax_chk2")==null?"":rs.getString("tax_chk2"));
				cls.setTax_chk3(rs.getString("tax_chk3")==null?"":rs.getString("tax_chk3"));
				cls.setTax_chk4(rs.getString("tax_chk4")==null?"":rs.getString("tax_chk4"));
				cls.setTax_chk5(rs.getString("tax_chk5")==null?"":rs.getString("tax_chk5"));
				cls.setTax_chk6(rs.getString("tax_chk6")==null?"":rs.getString("tax_chk6"));
			
				cls.setDft_amt_s(rs.getInt("dft_amt_s"));
				cls.setEtc_amt_s(rs.getInt("etc_amt_s"));
				cls.setEtc2_amt_s(rs.getInt("etc2_amt_s"));
				cls.setEtc4_amt_s(rs.getInt("etc4_amt_s"));
				cls.setDft_amt_v(rs.getInt("dft_amt_v"));
				cls.setEtc_amt_v(rs.getInt("etc_amt_v"));
				cls.setEtc2_amt_v(rs.getInt("etc2_amt_v"));
				cls.setEtc4_amt_v(rs.getInt("etc4_amt_v"));
				cls.setCar_ja_no_amt(rs.getInt("car_ja_no_amt"));
		
				cls.setDft_int_1(rs.getString("DFT_INT_1")==null?"":rs.getString("DFT_INT_1"));					
				cls.setFdft_amt3(rs.getInt("fdft_amt3"));	
													
				cls.setTax_reg_gu(rs.getString("TAX_REG_GU")==null?"N":rs.getString("TAX_REG_GU"));	
				cls.setTot_dist(rs.getInt("tot_dist"));	
				cls.setCms_chk(rs.getString("cms_chk")==null?"N":rs.getString("cms_chk"));	
				cls.setExt_st(rs.getString("ext_st")==null?"":rs.getString("ext_st"));	
				cls.setR_tax_dt(rs.getString("r_tax_dt")==null?"":rs.getString("r_tax_dt"));	
											
				cls.setOpt_s_amt(rs.getInt("opt_s_amt"));
				cls.setOpt_v_amt(rs.getInt("opt_v_amt"));
												
				cls.setServ_st(rs.getString("serv_st")==null?"":rs.getString("serv_st"));	
				
				cls.setOver_amt(rs.getInt("over_amt"));
				cls.setOver_amt_1(rs.getInt("over_amt_1"));
				cls.setOver_amt_s(rs.getInt("over_amt_s"));
				cls.setOver_amt_v(rs.getInt("over_amt_v"));									
			
			}
		} catch (SQLException e) {
			System.out.println("[AccuDatabase:getClsEstCase]\n"+e);			
			System.out.println(query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return cls;
		}
	}
	
	
		
		/*해지 초과운행 내역조회  */
	public ClsEtcOverBean getClsEstOver(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		ClsEtcOverBean co = new ClsEtcOverBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		
		query = " select "+
				" a.RENT_MNG_ID, a.RENT_L_CD,  "+ 
				" a.rent_days, a.cal_dist, a.first_dist, a.last_dist, a.real_dist, a.over_dist,  "+  //7			
				" a.add_dist, a.jung_dist, a.r_over_amt, a.m_over_amt, a.j_over_amt, a.m_saction_id, a.m_saction_dt, a.m_reason "+  //7 
				" from cls_est_over a where  a.RENT_MNG_ID = ? and a.RENT_L_CD = ?  ";
						
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
				 
	    		rs = pstmt.executeQuery();	    
	        	
			while(rs.next())
			{ 
				co.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				co.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
									
				co.setRent_days(rs.getInt("rent_days"));
				co.setCal_dist(rs.getInt("cal_dist"));
				co.setFirst_dist(rs.getInt("first_dist"));
				co.setLast_dist(rs.getInt("last_dist"));
				co.setReal_dist(rs.getInt("real_dist"));
				co.setOver_dist(rs.getInt("over_dist"));
				co.setAdd_dist(rs.getInt("add_dist"));
				co.setJung_dist(rs.getInt("jung_dist"));
				co.setR_over_amt(rs.getInt("r_over_amt"));
				co.setM_over_amt(rs.getInt("m_over_amt"));
				co.setJ_over_amt(rs.getInt("j_over_amt"));
							
				co.setM_saction_id(rs.getString("m_saction_id")==null?"":rs.getString("m_saction_id"));
				co.setM_saction_dt(rs.getString("m_saction_dt")==null?"":rs.getString("m_saction_dt"));
				co.setM_reason(rs.getString("m_reason")==null?"":rs.getString("m_reason"));
							
			}
		} catch (SQLException e) {
			System.out.println("[AccuDatabase:getClsEstOver]\n"+e);	
			System.out.println(query);		
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return co;
		}
	} 
	
	
		/*사전등록 해지의뢰 수정페이지 조회  : 차량채권정보  rent_mng_id, rent_l_cd  */
	public ClsEtcAddBean getClsEstAddInfo(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		ClsEtcAddBean clsa = new ClsEtcAddBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		
		query = " select "+
				" a.RENT_MNG_ID, a.RENT_L_CD,  "+ 
				" a.a_f, a.old_opt_amt, a.add_saction_id, a.add_saction_dt , "+
				" a.rc_rate, a.b_old_opt_amt, a.mt, a.count1, a.count2, a.m_r_fee_amt  "+  //6
				" from cls_est_add a where  a.RENT_MNG_ID = ? and a.RENT_L_CD = ? ";
						
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
	    	rs = pstmt.executeQuery();
	    	        	
			while(rs.next())
			{ 
				clsa.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				clsa.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				 
				clsa.setA_f(rs.getFloat("a_f"));
				clsa.setOld_opt_amt(rs.getInt("old_opt_amt"));	
				clsa.setAdd_saction_id(rs.getString("add_saction_id")==null?"":rs.getString("add_saction_id"));
				clsa.setAdd_saction_dt(rs.getString("add_saction_dt")==null?"":rs.getString("add_saction_dt"));			
				
				clsa.setRc_rate(rs.getFloat("rc_rate"));
				clsa.setB_old_opt_amt(rs.getInt("b_old_opt_amt"));	
				clsa.setMt(rs.getString("mt")==null?"":rs.getString("mt"));
				clsa.setCount1(rs.getInt("count1"));	
				clsa.setCount2(rs.getInt("count2"));	
				clsa.setM_r_fee_amt(rs.getInt("m_r_fee_amt"));					
	
			}
		} catch (SQLException e) {
			System.out.println("[AccuDatabase:getClsEstAddInfo]\n"+e);	
			System.out.println(query);		
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return clsa;
		}
	}
	
	
	//사전 중도매입옵션  중도정산서회
	public Vector getClsEstDetailList( String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";		
							
		query = " select * from cls_est_detail  " +
 						"where rent_mng_id = '"+ rent_mng_id + "' and rent_l_cd = '" + rent_l_cd + "' \n " +
 						" order by to_number(s_fee_tm) ";				
	
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
		} catch (SQLException e) {
			System.out.println("[AccuDatabase:getClsEstDetailList]\n"+e);			
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
	
	
		
	//결재요청전 등록여부
	public int getClsEstCnt(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		boolean flag = true;
		String query = "select count(*) from cls_est "+
						" where rent_mng_id = ? and rent_l_cd= ?  ";  //2
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int cnt = 0;
		try 
		{
			pstmt = conn.prepareStatement(query);
					
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
						
		 	rs = pstmt.executeQuery();
			if(rs.next()){
				cnt = rs.getInt(1);
			}    
		    
	  	} catch (Exception e) {
	  		e.printStackTrace();
	  		
		} finally {
			try{	
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return cnt;
		}			
	}
	
	
	 //중도매입옵션시 계산서발행금액 check
	public Hashtable getSettleTaxRemain(String rent_mng_id, String rent_l_cd, int fee_tm)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";		
						
		query = " select  sum(a.s_r_fee_s_amt) ts_r_fee_amt , sum(a.s_r_fee_v_amt) tv_r_fee_amt "+
 				"  from   cls_etc_detail a \n  "+
				"  where  a.rent_mng_id ='"+rent_mng_id+"'  and a.rent_l_cd = '" + rent_l_cd  + "' and s_fee_tm > " + fee_tm ;   
 				
 			
 		
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
		} catch (SQLException e) {
			System.out.println("[AccDatabase:getSettleTaxRemain]\n"+e);			
			System.out.println("[AccDatabase:getSettleTaxRemain]\n"+query);			
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
		
	//사전 중도매입옵션  중도정산서
	public Vector getCardCancel( String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";		
							
	/*
		query = " select  sum(a.rc_amt) r_amount , 'Y' f_tm_chk , '' appr_no, '' r_date \n"+
					 "		from scd_fee a , ( select rent_mng_id , rent_l_cd,  count(0) cnt2 from scd_fee where fee_tm > '1' and rc_amt > 0 group by rent_mng_id , rent_l_cd ) b \n"+
					 "		where  a.rent_l_cd =   '" + rent_l_cd + "'  and a.fee_tm = '1'  \n"+
                 "      and  a.rent_mng_id=b.rent_mng_id(+) and a.rent_l_cd = b.rent_l_cd(+) and nvl(b.cnt2,0)  = 0   \n"+
					 "		  group by a.rent_l_cd \n"+
				    "	union   \n"+
					 "		 select   a.r_amount r_amount   , 'N' f_tm_chk , a.appr_no, a.r_date   \n"+                          
					 " 		 from cms.CARD_CMS_PAY a 	 \n"+
					 " 		where a.user_no =  '" + rent_l_cd + "'  \n"+					 
					 "     and a.r_date  >  to_char(add_months(sysdate , -2) , 'yyyymmdd' ) \n"+
					 "     and a.result_info = '정상처리'  \n"+		
					 " 		and a.r_amount > 0 and a.pross = '1'  \n"+           
					 "     order by 4 asc ";
		*/			      				 	
		
		// 1회차이외에도 직접 카드 결재하는 것도 포함 - 20200728 - 최소 2개월 전
		query = "	select c.incom_amt r_amount,  decode(s.fee_tm , '1', 'Y', 'N' ) f_tm_chk , '' appr_no, c.incom_dt r_date  \n"+       
				"        from scd_fee s, incom c \n"+ 
				"		    where s.incom_dt = c.incom_dt and s.incom_seq = c.incom_seq and c.ip_method = '2' and c.card_cd not in ( '11')  \n"+  
				"			  and s.incom_dt >  to_char(add_months(sysdate , -2) , 'yyyymmdd' )    \n"+ 
				"           and s.rent_l_cd =  '" + rent_l_cd + "' \n"+       
				"	   	union   \n"+       
				"	select   a.r_amount r_amount   , 'N' f_tm_chk , a.appr_no, a.r_date   \n"+                   
				"         from cms.CARD_CMS_PAY a \n"+       
				"           where a.user_no =   '" + rent_l_cd + "'	\n"+       		 
				"           and a.r_date  >  to_char(add_months(sysdate , -2) , 'yyyymmdd' ) \n"+       
				"           and a.result_info = '정상처리' \n"+        	
				"             and a.r_amount > 0 and a.pross = '1'   \n"+          
				"           order by 4 desc ";
      
	
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
		} catch (SQLException e) {
			System.out.println("[AccuDatabase:getCardCancel]\n"+e);			
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
		
	//월렌트 마지막 결재시 결재 형태여부 (1:현금, 2:카드)
	public Vector getIpMethod( String rent_l_cd)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Vector vt = new Vector();
			String query = "";		
										
			// 1회차이외에도 직접 카드 결재하는 것도 포함 - 20200728 - 최소 2개월 전
			query = "	select c.incom_amt r_amount,  decode(s.fee_tm , '1', 'Y', 'N' ) f_tm_chk , '' appr_no, c.incom_dt r_date , c.ip_method \n"+       
					"        from scd_fee s, incom c \n"+ 
					"		    where s.incom_dt = c.incom_dt and s.incom_seq = c.incom_seq  \n"+  
					"			  and s.incom_dt >  to_char(add_months(sysdate , -2) , 'yyyymmdd' )    \n"+ 
					"             and s.rent_l_cd =  '" + rent_l_cd + "' \n"+ 
					"           order by 4 desc ";
	      
		
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
			} catch (SQLException e) {
				System.out.println("[AccuDatabase:getIpMethod]\n"+e);			
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
		
	 //카드 cms인경우 승인번호
	public String getCardAppr_no(String rent_l_cd, String r_date)
		{
			getConnection();
			Statement stmt = null;
			ResultSet rs = null;
			Vector vt = new Vector();
			String query = "";		
			String appr_no = "";					
					
			query = "		select appr_no  \n"+
						 "		from  CMS.card_cms_pay   \n"+
						 "		where  \n"+
						 "		  user_no =   '" + rent_l_cd + "' and result_info = '정상처리' and r_date = replace('" + r_date + "', '-', '') ";
				
			try 
			{
				stmt = conn.createStatement();
		    	rs = stmt.executeQuery(query);
				if(rs.next()){
					appr_no = rs.getString(1);					
				}    
			    
		  	} catch (Exception e) {
		  		e.printStackTrace();
		  		
			} finally {
				try{	
	                if(rs != null )		rs.close();
	                if(stmt != null)	stmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return appr_no;
			}			
	}
			
	
	//사전 중도매입옵션  중도정산서회
	public int  getCardCancelAmt(String rent_l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";		
		int cnt = 0;					
	
		query = "		select nvl(sum(a.rc_amt),0)  r_amount  \n"+
					 "		from scd_fee a  , CMS.CARD_CMS_MEM  c  \n"+
					 "		where  \n"+
					 "		  a.rent_l_cd =   '" + rent_l_cd + "' and a.rent_l_cd = c.cms_primary_seq  and a.fee_tm > '1'  ";
			
		try 
		{
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
			if(rs.next()){
				cnt = rs.getInt(1);
			}    
		    
	  	} catch (Exception e) {
	  		e.printStackTrace();
	  		
		} finally {
			try{	
                if(rs != null )		rs.close();
                if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return cnt;
		}			
	}
	
	
		//사전 중도매입옵션  중도정산서회
	public int  getCardCancelCnt(String rent_l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";		
		int cnt = 0;					
	
		query = "		select count(0) cnt  \n"+
					 "		from scd_fee a   \n"+
					 "		  where a.rent_l_cd =   '" + rent_l_cd + "' and a.fee_tm > '1' and a.rc_amt > 0  ";
			
		try 
		{
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
			if(rs.next()){
				cnt = rs.getInt(1);
			}    
		    
	  	} catch (Exception e) {
	  		e.printStackTrace();
	  		
		} finally {
			try{	
                if(rs != null )		rs.close();
                if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return cnt;
		}			
	}
	
	
		//전기차 여부  5:전기 6:수소 
	public int  getElecCnt(String rent_l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";		
		int cnt = 0;					
	
			
		query = "		select count(0) cnt   from cont a, car_etc c, car_nm n   \n"+
			" where a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd \n"+
		   " and c.car_id = n.car_id  and c.car_seq=n.car_seq and n.diesel_yn  in ( '5' , '6' ) \n"+
		    " and a.rent_l_cd =   '" + rent_l_cd + "'" ; 
  
  		
		try 
		{
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
			if(rs.next()){
				cnt = rs.getInt(1);
			}    
		    
	  	} catch (Exception e) {
	  		e.printStackTrace();
	  		
		} finally {
			try{	
                if(rs != null )		rs.close();
                if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return cnt;
		}			
	}
	
	
		
		// card cms  인출리스트 
	public Vector getCardCmsList(String rent_l_cd, String r_date )
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
			
		query =	" select  a.user_no,  a.amount, a.r_amount, a.r_date, a.appr_no, a.file_date, a.aipdate , b.cms_status||b.pross cms_status   \n"+
					   " from cms.CARD_CMS_PAY  a , cms.CARD_CMS_MEM  b  \n"+
					  " where a.user_no = b.cms_primary_seq  and   a.user_no = '" + rent_l_cd + "' and a.r_amount > 0 ";		
	
	   if ( !r_date.equals("") ) 	query += "  and a.r_date = replace('" + r_date + "' , '-', '')   ";
	  	
		query += " order by   a.r_date ";
	
		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
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
			stmt.close();

		} catch (SQLException e) {
			System.out.println("[AddClsDatabase:getClsList]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}
	
	
	/**
	 *	대차계약 보증금승계원계약 연동분 데이타 삭제 - 출고전해지 
	 */
	public boolean updateContEtcClear(String rent_mng_id, String rent_l_cd )
	{
		getConnection();
		boolean flag = true;
		String query = "update cont_etc set "+						
							" grt_suc_m_id ='', grt_suc_l_cd = '' "+ 						
							" where rent_mng_id = ? and rent_l_cd = ?  ";  //2
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
				
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
		
		    pstmt.executeUpdate();

			conn.commit();
		    
	  	} catch (Exception e) {
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
	
		/** 영업효율 정산금 경감금액 
	 */
	public boolean updateClsEffAmt(String rent_mng_id, String rent_l_cd , int cls_eff_amt )
	{
		getConnection();
		boolean flag = true;
		String query = "update cls_etc set  cls_eff_amt = ? "+ 						
							" where rent_mng_id = ? and rent_l_cd = ?  ";  //2
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
				
			pstmt.setInt(1, cls_eff_amt);	
			pstmt.setString(2, rent_mng_id);
			pstmt.setString(3, rent_l_cd);
		
		    pstmt.executeUpdate();

			conn.commit();
		    
	  	} catch (Exception e) {
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
	
	//계기판 교환건 확인 
	
	public int  getDashboardCnt(String car_mng_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";		
		int cnt = 0;					
	
			
		query = "	select count(0) cnt   from car_reg a \n"+
			" where a.dist_cng like '%계기판%'  and a.car_mng_id =   '" + car_mng_id + "'" ; 
    		
		try 
		{
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
			if(rs.next()){
				cnt = rs.getInt(1);
			}    
		    
	  	} catch (Exception e) {
	  		e.printStackTrace();
	  		
		} finally {
			try{	
                if(rs != null )		rs.close();
                if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return cnt;
		}			
	}
	
	
	//결재요청전 등록여부
	public int getFeeCnt3(String rent_mng_id, String rent_l_cd, int  rent_st)
		{
			getConnection();
			boolean flag = true;
			String query = "select count(0) from scd_fee "+
							" where rent_mng_id = ? and rent_l_cd= ?  and to_number(rent_st)  < ?  and tm_st1 ='0'  and tm_st2 = '3'";  //2
			
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			int cnt = 0;
			try 
			{
				pstmt = conn.prepareStatement(query);
						
				pstmt.setString(1, rent_mng_id);
				pstmt.setString(2, rent_l_cd);
				pstmt.setInt(3, rent_st);
							
			 	rs = pstmt.executeQuery();
				if(rs.next()){
					cnt = rs.getInt(1);
				}    
			    
		  	} catch (Exception e) {
		  		e.printStackTrace();
		  		
			} finally {
				try{	
	                if(rs != null )		rs.close();
	                if(pstmt != null)	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return cnt;
			}			
	}
	
	//삭제시 업체명, 차량번호 구하기 (메세지용 )		
	public Hashtable  getClsInfo( String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";		
		
		query = " select  nvl(b.firm_nm, b.client_nm) as firm_nm, c.car_no "+
 				"  from   cont a, client b, car_reg c  "+
				"  where  a.rent_mng_id = '"+ rent_mng_id + "' and a.rent_l_cd = '"+rent_l_cd+"' and a.client_id = b.client_id and a.car_mng_id = c.car_mng_id(+) ";
		 			 		
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
		} catch (SQLException e) {
			System.out.println("[AccDatabase:getClsInfo]\n"+e);			
			System.out.println("[AccDatabase:getClsInfo]\n"+query);			
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
		
    //삭제괸련  table 정리		
	public boolean deleteInfo(String rent_mng_id, String rent_l_cd, String table_nm)
	{
		getConnection();
		boolean flag = true;
		String query = "delete from "+table_nm+""+
						" where rent_mng_id = ? and rent_l_cd = ?  ";  //2
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
					
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
			
		    pstmt.executeUpdate();

			conn.commit();
		    
	  	} catch (Exception e) {
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
	
	 //사용기간 구하기 
	public String getBetweenYMD2(String end_dt, String start_dt)
	{
			getConnection();
			
			String sResult = "";			
			CallableStatement cstmt = null;
			
			try {
				
				  cstmt = conn.prepareCall("{ ? =  call F_getBetweenYMD2( ?, ? ) }");

				  cstmt.registerOutParameter( 1, java.sql.Types.VARCHAR );			
				  cstmt.setString(2, end_dt );
		          cstmt.setString(3, start_dt );
		           
		          cstmt.execute();
		          sResult = cstmt.getString(1); // 결과값
		          cstmt.close();
		        
			} catch (SQLException e) {
				System.out.println("[AccuDatabase:getBetweenYMD2]\n"+e);
				e.printStackTrace();
			} finally {
				try{
				     if(cstmt != null)	cstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return sResult;
			}			
		
	}	
			
}	