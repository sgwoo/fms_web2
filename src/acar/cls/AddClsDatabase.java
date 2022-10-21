package acar.cls;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.cont.*;
import acar.fee.*;
import acar.util.AddUtil;
import acar.account.*;

public class AddClsDatabase
{
	private Connection conn = null;
	public static AddClsDatabase s_db;
	
	public static AddClsDatabase getInstance()
	{
		if(AddClsDatabase.s_db == null)
			AddClsDatabase.s_db = new AddClsDatabase();
		return AddClsDatabase.s_db;	
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

	/*-------------------------------------------------------------------------------------------------------*/	
	/*영업지원 ----------------------------------------------------------------------------------------------*/
  /*-------------------------------------------------------------------------------------------------------*/	

	/* 계약변경 검색 : 중도해지 리스트
	 *	r_cls 	- 0:해약, 1:미해약(조회구분)
	 *	cls_st	- 1:계약만료, 2:중도해약, 3:영엽소변경, 4:차종변경, 5:계약이관, 6:매각 (해지구분)
	 *  s_kd 	- 1: 상호, 2: 고객명, 3: 차량번호, 4: 계약일, 5: 대여개시일, 6: 해약일, 7: 영업담당자, 8: 계약코드, 9: 영업소	
	 */	 
	public Vector getClsList(String r_cls, String cls_st, String s_kd, String t_wd, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select"+
				" rent_mng_id, rent_l_cd, nvl(firm_nm, client_nm) firm_nm, client_nm, car_nm, user_nm,"+
				" car_no, in_cls, cls_st, cls_st_nm, term_yn, brch_id, pp_st, "+
				" decode(init_reg_dt, '', '', substr(init_reg_dt, 1, 4) || '-' || substr(init_reg_dt, 5, 2) ||'-'||substr(init_reg_dt, 7, 2)) init_reg_dt,"+
				" decode(rent_dt, '', '', substr(rent_dt, 1, 4) || '-' || substr(rent_dt, 5, 2) ||'-'||substr(rent_dt, 7, 2)) rent_dt,"+
				" decode(dlv_dt, '', '', substr(dlv_dt, 1, 4) || '-' || substr(dlv_dt, 5, 2) || '-'||substr(dlv_dt, 7, 2)) dlv_dt,"+
				" decode(rent_start_dt, '', '', substr(rent_start_dt, 1, 4) || '-' || substr(rent_start_dt, 5, 2) || '-'||substr(rent_start_dt, 7, 2)) rent_start_dt,"+
				" decode(cls_dt, '', '', substr(cls_dt, 1, 4) || '-' || substr(cls_dt, 5, 2) || '-'||substr(cls_dt, 7, 2)) cls_dt,"+
				" decode(rent_way, '1','일반식', '2','맞춤식') rent_way, con_mon, rent_st"+
				" from"+
					" ("+
						" select"+
					 	" C.rent_mng_id, C.rent_l_cd, C.brch_id, C.rent_dt, C.dlv_dt, C.rent_start_dt, "+
					 	" L.firm_nm, L.client_nm, "+
						" R.car_nm, R.car_no, R.init_reg_dt, "+
						" U.user_nm, "+
					 	" decode(S.rent_l_cd, '','N', 'Y') IN_CLS, S.cls_st, S.cls_dt, S.pp_st, S.term_yn, "+
					 	" decode(S.cls_st, '1','출고전해지', '2','중도해지', '3','출고전차종변경', '4','출고후차종변경', '5','고객변경','6','영업소변경') CLS_ST_NM,"+
						" F.rent_st, F.rent_way, F.con_mon "+
						" from cont C, client L, car_reg R, users U, cls_cont S, fee F"+
						" where C.client_id = L.client_id and"+
						" C.car_mng_id = R.car_mng_id(+) and"+
						" C.bus_id = U.user_id and"+
						" C.rent_mng_id = S.rent_mng_id(+) and"+
						" C.rent_l_cd = S.rent_l_cd(+) and"+
						" C.rent_mng_id = F.rent_mng_id and"+
						" C.rent_l_cd = F.rent_l_cd and"+
						" F.rent_st = '1'"+
					" )"+
				" where";

		if(r_cls.equals("0"))	 		query += " in_cls = 'Y' ";
		else if(r_cls.equals("1"))	 	query += " in_cls = 'N' ";

		if(cls_st.equals("1"))			query += " and cls_st = '1' ";
		else if(cls_st.equals("2"))		query += " and cls_st = '2' ";
		else if(cls_st.equals("3"))		query += " and cls_st = '3' ";
		else if(cls_st.equals("4"))		query += " and cls_st = '4' ";
		else if(cls_st.equals("5"))		query += " and cls_st = '5' ";

		if(s_kd.equals("1"))			query += " and firm_nm like '%"+t_wd+"%'";
		else if(s_kd.equals("2"))		query += " and client_nm like '%"+t_wd+"%'";
		else if(s_kd.equals("3"))		query += " and car_no like '%"+t_wd+"%'";
		else if(s_kd.equals("4"))		query += " and rent_dt between '"+st_dt+"' and '"+end_dt+"'";
		else if(s_kd.equals("5"))		query += " and rent_start_dt between '"+st_dt+"' and '"+end_dt+"'";
		else if(s_kd.equals("6"))		query += " and cls_dt between '"+st_dt+"' and '"+end_dt+"'";
		else if(s_kd.equals("7"))		query += " and user_nm like '%"+t_wd+"%'";
		else if(s_kd.equals("8"))		query += " and rent_l_cd like '%"+t_wd+"%'";
		else if(s_kd.equals("9"))		query += " and brch_id = '"+t_wd+"'";

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
			System.out.println("[AddClsDatabase:getClsList]\n"+e);			
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

	//계약 변경 : 중도해지 조회
	public Hashtable getFeebasecls2(String m_id, String l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		query = " select"+
				" rent_l_cd, nvl(firm_nm, client_nm) firm_nm, client_nm, car_no, car_nm, rent_way, rent_start_dt,"+
				" rent_end_dt, init_reg_dt, pp_pay_amt, pp_amt, ex_pp_amt, ifee_amt, ex_ifee_amt,"+
				" grt_amt, ex_grt_amt, fee_amt, ex_fee_amt, con_mon, ex_con_mon, ex_rent_start_dt, ex_rent_end_dt,"+
				" rent_st, con_mon+ex_con_mon tot_con_mon,"+
				" (fee_amt*con_mon)+(ex_fee_amt*ex_con_mon)+(pp_amt) tot_fee_amt,"+
				" trunc(((fee_amt*con_mon)+(ex_fee_amt*ex_con_mon)+(pp_amt))/(con_mon+ex_con_mon)) avg_fee_amt,"+
				" decode( sign(sysdate - to_date(rent_start_dt, 'YYYY-MM-DD')), -1, '0', trunc(months_between(sysdate, to_date(rent_start_dt, 'YYYY-MM-DD')))) r_mon,"+
				" decode( sign(sysdate - to_date(rent_start_dt, 'YYYY-MM-DD')), -1, '0', trunc(sysdate-add_months(to_date(rent_start_dt, 'YYYY-MM-DD'), trunc(months_between(sysdate, to_date(rent_start_dt, 'YYYY-MM-DD')))))) r_day,"+
				" brch_id, car_mng_id, s_mon, s_day, fee_chk, client_id, opt_amt, opt_per"+
				" from"+
				" ("+
					" select"+
					" max(rent_l_cd) rent_l_cd, max(firm_nm) firm_nm, max(client_nm) client_nm,"+
					" max(car_no) car_no, max(car_nm) car_nm, max(rent_way) rent_way,"+
					" max(rent_start_dt) rent_start_dt, max(rent_end_dt) rent_end_dt,"+
					" max(init_reg_dt) init_reg_dt, max(rent_st) rent_st,"+
					" max(pp_amt) pp_amt, max(ex_pp_amt) ex_pp_amt,"+ 
					" max(ifee_amt) ifee_amt, max(ex_ifee_amt) ex_ifee_amt,"+ 
					" max(pp_pay_amt) pp_pay_amt, max(ex_pp_pay_amt) ex_pp_pay_amt,"+ 
					" max(grt_amt) grt_amt, max(ex_grt_amt) ex_grt_amt,"+ 
					" max(fee_amt) fee_amt, max(ex_fee_amt) ex_fee_amt,"+ 
					" max(con_mon) con_mon, max(ex_con_mon) ex_con_mon,"+ 
					" max(ex_rent_start_dt) ex_rent_start_dt, max(ex_rent_end_dt) ex_rent_end_dt,"+
					" max(brch_id) brch_id, max(car_mng_id) car_mng_id, max(fee_chk) fee_chk,"+
					" max(s_mon) s_mon, max(s_day) s_day, max(client_id) client_id,"+
					" max(opt_amt) opt_amt, max(opt_per) opt_per"+
					" from"+
					" ("+
						" select"+
						" rent_st,"+
						" decode(rent_st, 1, rent_l_cd, '') rent_l_cd,"+
						" decode(rent_st, 1, firm_nm, '') firm_nm,"+
						" decode(rent_st, 1, client_nm, '') client_nm,"+
						" decode(rent_st, 1, car_no, '') car_no,"+
						" decode(rent_st, 1, car_nm, '') car_nm,"+
						" decode(rent_st, 1, rent_way, '') rent_way,"+
						" decode(rent_st, 1, rent_start_dt, '') rent_start_dt,"+
						" decode(rent_st, 1, rent_end_dt, '') rent_end_dt,"+
						" decode(rent_st, 1, con_mon, 0) con_mon,"+
						" decode(rent_st, 1, fee_amt, 0) fee_amt,"+
						" decode(rent_st, 1, grt_amt, 0) grt_amt,"+
						" decode(rent_st, 1, pp_amt, 0) pp_amt,"+
						" decode(rent_st, 1, ifee_amt, 0) ifee_amt,"+
						" decode(rent_st, 1, pp_pay_amt, 0) pp_pay_amt,"+
						" decode(rent_st, 1, init_reg_dt, '') INIT_REG_DT,"+
						" decode(rent_st, 2, rent_start_dt, '') ex_rent_start_dt,"+
						" decode(rent_st, 2, rent_end_dt, '') ex_rent_end_dt,"+
						" decode(rent_st, 2, con_mon, 0) ex_con_mon,"+
						" decode(rent_st, 2, fee_amt, 0) ex_fee_amt,"+
						" decode(rent_st, 2, grt_amt, 0) ex_grt_amt,"+
						" decode(rent_st, 2, pp_amt, 0) ex_pp_amt,"+
						" decode(rent_st, 2, ifee_amt, 0) ex_ifee_amt,"+
						" decode(rent_st, 2, pp_pay_amt, 0) ex_pp_pay_amt,"+
						" brch_id, car_mng_id, s_mon, s_day, fee_chk, client_id, opt_amt, opt_per"+
						" from"+
						" ("+
							" select"+
							" F.rent_l_cd, F.con_mon, F.rent_way, F.fee_chk, "+
							" decode(F.rent_end_dt, '','', substr(F.rent_end_dt,1,4)||'-'||substr(F.rent_end_dt,5,2)||'-'||substr(F.rent_end_dt,7,2)) rent_end_dt,"+
							" F.pp_s_amt+F.pp_v_amt as pp_amt, F.ifee_s_amt+F.ifee_v_amt as ifee_amt,"+
							" F.grt_amt_s as grt_amt, F.fee_s_amt+F.fee_v_amt as fee_amt, F.rent_st,"+
							" decode(F.rent_start_dt, '','', substr(F.rent_start_dt,1,4)||'-'||substr(F.rent_start_dt,5,2)||'-'||substr(F.rent_start_dt,7,2)) rent_start_dt,"+
							" C.brch_id, C.car_mng_id, L.client_id, L.firm_nm, L.client_nm, N.car_name as car_nm, R.car_no,"+
							" decode(R.init_reg_dt, '','', substr(R.init_reg_dt,1,4)||'-'||substr(R.init_reg_dt,5,2)||'-'||substr(R.init_reg_dt,7,2)) init_reg_dt,"+
							" S.s_mon, S.s_day, P.pp_pay_amt, (F.opt_s_amt+F.opt_v_amt) opt_amt, F.opt_per"+
							" from fee F, cont C, client L, car_reg R, car_etc E, car_nm N,"+
							" ("+
								" select"+
								" count(*) as s_mon, decode(max(fee_est_dt), '', 0, trunc(sysdate-add_months(to_date(max(fee_est_dt), 'YYYYMMDD'), trunc(months_between(sysdate, to_date(max(fee_est_dt), 'YYYYMMDD')))))) as s_day"+
								" from scd_fee"+
								" where rent_l_cd='"+l_cd+"'"+
								" and fee_est_dt < to_char(sysdate,'YYYYMMDD')"+
								" and rc_amt = 0"+
								" and tm_st1 = 0"+
							" ) S,"+
							" ("+
								" select sum(ext_pay_amt) as pp_pay_amt from scd_ext where ext_st in ('1', '2' ) and rent_mng_id ='"+m_id+"' and rent_l_cd='"+l_cd+"'"+
							" ) P"+
							" where F.rent_mng_id = C.rent_mng_id and"+
							" F.rent_l_cd = C.rent_l_cd and"+
							" C.client_id = L.client_id and"+
							" C.car_mng_id = R.car_mng_id(+) and"+
							" F.rent_mng_id = E.rent_mng_id and"+
							" F.rent_l_cd = E.rent_l_cd and"+
							" E.car_id = N.car_id and"+
							" F.rent_mng_id ='"+m_id+"' and F.rent_l_cd = '"+l_cd+"'"+
						" )"+ 
					" )"+
				" )";		

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
			System.out.println("[AddClsDatabase:getFeebasecls2]\n"+e);			
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
	 *	해지 insert
	 */
	public boolean insertCls(ClsBean cls)
	{
		getConnection();
		boolean flag = true;
		String query = "insert into cls_cont ("+
							" RENT_MNG_ID, RENT_L_CD, CLS_ST, TERM_YN, CLS_DT, "+
							" REG_ID, CLS_CAU, P_BRCH_CD, NEW_BRCH_CD, TRF_DT, "+
						 	" IFEE_S_AMT, IFEE_V_AMT, IFEE_ETC, PP_S_AMT, PP_V_AMT, PP_ETC, PDED_S_AMT, PDED_V_AMT,"+
						 	" PDED_ETC, TPDED_S_AMT, TPDED_V_AMT, TPDED_ETC, RFEE_S_AMT, RFEE_V_AMT, RFEE_ETC, DFEE_TM,"+
						 	" DFEE_S_AMT, DFEE_V_AMT, NFEE_TM, NFEE_S_AMT, NFEE_V_AMT, NFEE_MON, NFEE_DAY, NFEE_AMT,"+
						 	" TFEE_AMT, MFEE_AMT, RCON_MON, RCON_DAY, TRFEE_AMT, DFT_INT, DFT_AMT, NO_DFT_YN, NO_DFT_CAU,"+
						 	" FDFT_AMT1, FDFT_DC_AMT, FDFT_AMT2, PAY_DT, NFEE_DAYS, RCON_DAYS, REG_DT, r_mon, r_day, fine_amt, tot_dist, grt_amt \n "+
						 	" ex_di_amt, rifee_s_amt , rifee_v_amt , over_amt, over_v_amt  "+  //5
						 	") values ("+
						 	" ?, ?, ?, ?, replace(?, '-', ''), ?, ?, ?, ?, replace(?, '-', ''),"+
						 	" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+ 
						 	" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
						 	" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
						 	" ?, ?, ?, ?, ?, ?, replace(?, '-', ''), ?, ?, to_char(sysdate,'YYYYMMDD') , ?, ? , ?, ?, ? "+
						 	" ?, ? , ?, ?, ? " +  //2022-04
						 	" )";
		
		PreparedStatement pstmt = null;

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
			pstmt.setString(8, cls.getP_brch_cd());
			pstmt.setString(9, cls.getNew_brch_cd());
			pstmt.setString(10, cls.getTrf_dt());
			pstmt.setInt   (11, cls.getIfee_s_amt());
			pstmt.setInt   (12, cls.getIfee_v_amt());
			pstmt.setString(13, cls.getIfee_etc());
			pstmt.setInt   (14, cls.getPp_s_amt());
			pstmt.setInt   (15, cls.getPp_v_amt());
			pstmt.setString(16, cls.getPp_etc());
			pstmt.setInt   (17, cls.getPded_s_amt());
			pstmt.setInt   (18, cls.getPded_v_amt());
			pstmt.setString(19, cls.getPded_etc());
			pstmt.setInt   (20, cls.getTpded_s_amt());
			pstmt.setInt   (21, cls.getTpded_v_amt());
			pstmt.setString(22, cls.getTpded_etc());
			pstmt.setInt   (23, cls.getRfee_s_amt());
			pstmt.setInt   (24, cls.getRfee_v_amt());
			pstmt.setString(25, cls.getRfee_etc());
			pstmt.setString(26, cls.getDfee_tm());
			pstmt.setInt   (27, cls.getDfee_s_amt());
			pstmt.setInt   (28, cls.getDfee_v_amt());
			pstmt.setString(29, cls.getNfee_tm());
			pstmt.setInt   (30, cls.getNfee_s_amt());
			pstmt.setInt   (31, cls.getNfee_v_amt());
			pstmt.setString(32, cls.getNfee_mon());
			pstmt.setString(33, cls.getNfee_day());
			pstmt.setInt   (34, cls.getNfee_amt());
			pstmt.setInt   (35, cls.getTfee_amt());
			pstmt.setInt   (36, cls.getMfee_amt());
			pstmt.setString(37, cls.getRcon_mon());
			pstmt.setString(38, cls.getRcon_day());
			pstmt.setInt   (39, cls.getTrfee_amt());
			pstmt.setString(40, cls.getDft_int());
			pstmt.setInt   (41, cls.getDft_amt());
			pstmt.setString(42, cls.getNo_dft_yn());
			pstmt.setString(43, cls.getNo_dft_cau());
			pstmt.setInt   (44, cls.getFdft_amt1());
			pstmt.setInt   (45, cls.getFdft_dc_amt());
			pstmt.setInt   (46, cls.getFdft_amt2());
			pstmt.setString(47, cls.getPay_dt());
			pstmt.setString(48, cls.getNfee_days());
			pstmt.setString(49, cls.getRcon_days());
			pstmt.setString(50, cls.getR_mon());
			pstmt.setString(51, cls.getR_day());
			pstmt.setInt   (52, cls.getFine_amt());
			pstmt.setInt   (53, cls.getTot_dist());
			pstmt.setInt   (54, cls.getGrt_amt());			
		
			pstmt.setInt   (55, cls.getEx_di_amt());
			pstmt.setInt   (56, cls.getRifee_s_amt());
			pstmt.setInt   (57, cls.getRifee_v_amt());
			pstmt.setInt   (58, cls.getOver_amt());
			pstmt.setInt   (59, cls.getOver_v_amt());  //5
						
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
	 *	해지 insert - 합산정산
	 */
	public boolean insertCls2(ClsBean cls)
	{
		getConnection();
		boolean flag = true;
		String query = "insert into cls_cont ("+
							" RENT_MNG_ID,	RENT_L_CD,	CLS_ST,		TERM_YN,	CLS_DT, "+
							" REG_ID,		CLS_CAU,	P_BRCH_CD,	NEW_BRCH_CD,TRF_DT, "+
						 	" IFEE_S_AMT,	IFEE_V_AMT, IFEE_ETC,	PP_S_AMT,	PP_V_AMT, "+
							" PP_ETC,		PDED_S_AMT, PDED_V_AMT, PDED_ETC,	TPDED_S_AMT,"+
						 	" TPDED_V_AMT,	TPDED_ETC,	RFEE_S_AMT, RFEE_V_AMT, RFEE_ETC, "+
						 	" DFEE_TM,		DFEE_S_AMT, DFEE_V_AMT, NFEE_TM,	NFEE_S_AMT, "+
							" NFEE_V_AMT,	NFEE_MON,	NFEE_DAY,	NFEE_AMT,	TFEE_AMT, "+
						 	" MFEE_AMT,		RCON_MON,	RCON_DAY,	TRFEE_AMT,	DFT_INT, "+
							" DFT_AMT,		NO_DFT_YN,	NO_DFT_CAU,	FDFT_AMT1,	FDFT_DC_AMT,"+
						 	" FDFT_AMT2,	PAY_DT,		NFEE_DAYS,	RCON_DAYS,	PP_ST,"+
							" CLS_EST_DT,	VAT_ST,		EXT_DT,		EXT_ID,		GRT_AMT,"+
							" CLS_DOC_YN,	OPT_PER,	OPT_AMT,	OPT_DT,		OPT_MNG,"+
							" dly_amt, no_v_amt, car_ja_amt, r_mon, r_day, cls_s_amt, cls_v_amt, etc_amt, fine_amt, ex_di_amt,"+
							" ifee_mon, ifee_day, ifee_ex_amt, rifee_s_amt, cancel_yn, reg_dt, etc2_amt, etc3_amt, etc4_amt, etc5_amt , fdft_amt3, tot_dist, cms_chk, " +
						 	" rifee_v_amt , over_amt ,  over_v_amt  "+  //3
							") values( "+
						 	" ?, ?, ?, ?, replace(?, '-', ''), "+
							" ?, ?, ?, ?, replace(?, '-', ''), "+
						 	" ?, ?, ?, ?, ?, "+
							" ?, ?, ?, ?, ?, "+ 
						 	" ?, ?, ?, ?, ?, "+
							" ?, ?, ?, ?, ?, "+
						 	" ?, ?, ?, ?, ?, "+
							" ?, ?, ?, ?, ?, "+
						 	" ?, ?, ?, ?, ?, "+
							" ?, replace(?, '-', ''), ?, ?, ?,"+
							" replace(?, '-', ''), ?, replace(?, '-', ''), ?, ?,"+
						 	" ?, ?, ?, replace(?, '-', ''), ?,"+
							" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
							" ?, ?, ?, ?, ?, to_char(sysdate,'YYYYMMDD'), ?, ?, ?, ?, ?, ?, ?, "+
							" ?, ?, ? " +
							" ) ";

		
		String query_in = " INSERT INTO scd_ext"+
							" (rent_mng_id, rent_l_cd, rent_st, rent_seq, ext_st, ext_id, ext_tm,"+
							"  ext_s_amt, ext_v_amt, ext_est_dt, bill_yn, update_id, update_dt)"+
							" values "+
							" ( ?, ?, '1', '1', '4', '0', '1',"+
							"   ?, ?, replace(?, '-', ''), 'Y', ?, to_char(sysdate,'YYYYMMDD') )";			

		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;

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
			pstmt.setString(8, cls.getP_brch_cd());
			pstmt.setString(9, cls.getNew_brch_cd());
			pstmt.setString(10, cls.getTrf_dt());
			pstmt.setInt   (11, cls.getIfee_s_amt());
			pstmt.setInt   (12, cls.getIfee_v_amt());
			pstmt.setString(13, cls.getIfee_etc());
			pstmt.setInt   (14, cls.getPp_s_amt());
			pstmt.setInt   (15, cls.getPp_v_amt());
			pstmt.setString(16, cls.getPp_etc());
			pstmt.setInt   (17, cls.getPded_s_amt());
			pstmt.setInt   (18, cls.getPded_v_amt());
			pstmt.setString(19, cls.getPded_etc());
			pstmt.setInt   (20, cls.getTpded_s_amt());
			pstmt.setInt   (21, cls.getTpded_v_amt());
			pstmt.setString(22, cls.getTpded_etc());
			pstmt.setInt   (23, cls.getRfee_s_amt());
			pstmt.setInt   (24, cls.getRfee_v_amt());
			pstmt.setString(25, cls.getRfee_etc());
			pstmt.setString(26, cls.getDfee_tm());
			pstmt.setInt   (27, cls.getDfee_s_amt());
			pstmt.setInt   (28, cls.getDfee_v_amt());
			pstmt.setString(29, cls.getNfee_tm());
			pstmt.setInt   (30, cls.getNfee_s_amt());
			pstmt.setInt   (31, cls.getNfee_v_amt());
			pstmt.setString(32, cls.getNfee_mon());
			pstmt.setString(33, cls.getNfee_day());
			pstmt.setInt   (34, cls.getNfee_amt());
			pstmt.setInt   (35, cls.getTfee_amt());
			pstmt.setInt   (36, cls.getMfee_amt());
			pstmt.setString(37, cls.getRcon_mon());
			pstmt.setString(38, cls.getRcon_day());
			pstmt.setInt   (39, cls.getTrfee_amt());
			pstmt.setString(40, cls.getDft_int());
			pstmt.setInt   (41, cls.getDft_amt());
			pstmt.setString(42, cls.getNo_dft_yn());
			pstmt.setString(43, cls.getNo_dft_cau());
			pstmt.setInt   (44, cls.getFdft_amt1());
			pstmt.setInt   (45, cls.getFdft_dc_amt());
			pstmt.setInt   (46, cls.getFdft_amt2());
			pstmt.setString(47, cls.getPay_dt());
			pstmt.setString(48, cls.getNfee_days());
			pstmt.setString(49, cls.getRcon_days());
			pstmt.setString(50, cls.getPp_st());			
			pstmt.setString(51, cls.getCls_est_dt());			
			pstmt.setString(52, cls.getVat_st());			
			pstmt.setString(53, cls.getExt_dt());			
			pstmt.setString(54, cls.getExt_id());			
			pstmt.setInt   (55, cls.getGrt_amt());
			pstmt.setString(56, cls.getCls_doc_yn());			
			pstmt.setString(57, cls.getOpt_per());			
			pstmt.setInt   (58, cls.getOpt_amt());
			pstmt.setString(59, cls.getOpt_dt());			
			pstmt.setString(60, cls.getOpt_mng());			
			pstmt.setInt   (61, cls.getDly_amt());
			pstmt.setInt   (62, cls.getNo_v_amt());
			pstmt.setInt   (63, cls.getCar_ja_amt());
			pstmt.setString(64, cls.getR_mon());			
			pstmt.setString(65, cls.getR_day());			
			pstmt.setInt   (66, cls.getCls_s_amt());
			pstmt.setInt   (67, cls.getCls_v_amt());
			pstmt.setInt   (68, cls.getEtc_amt());
			pstmt.setInt   (69, cls.getFine_amt());
			pstmt.setInt   (70, cls.getEx_di_amt());
			pstmt.setString(71, cls.getIfee_mon());			
			pstmt.setString(72, cls.getIfee_day());			
			pstmt.setInt   (73, cls.getIfee_ex_amt());
			pstmt.setInt   (74, cls.getRifee_s_amt());
			pstmt.setString(75, cls.getCancel_yn());
			pstmt.setInt   (76, cls.getEtc2_amt());
			pstmt.setInt   (77, cls.getEtc3_amt());
			pstmt.setInt   (78, cls.getEtc4_amt());
			pstmt.setInt   (79, cls.getEtc5_amt());
			pstmt.setInt   (80, cls.getFdft_amt3());
			pstmt.setInt   (81, cls.getTot_dist());	
			pstmt.setString(82, cls.getCms_chk());	
				
			pstmt.setInt   (83, cls.getRifee_v_amt());
			pstmt.setInt   (84, cls.getOver_amt());
			pstmt.setInt   (85, cls.getOver_v_amt());  //3
							
			pstmt.executeUpdate();
			pstmt.close();

			int n_cls_amt = 0;
			int n_cls_s_amt = 0;
			int n_cls_v_amt = 0;

//			if(cls.getCls_st().equals("2")){//중도해약
/*				n_cls_amt = cls.getFdft_amt2();
				if(cls.getVat_st().equals("1")){//부가세포함
					n_cls_s_amt = (new Double(n_cls_amt/1.1)).intValue();
					n_cls_v_amt = n_cls_amt-n_cls_s_amt;
				}else{
					n_cls_s_amt = n_cls_amt;
				}
*/
/*			}else if(cls.getCls_st().equals("8")){//매입옵션
				n_cls_amt = cls.getOpt_amt();
				n_cls_s_amt = (new Double(n_cls_amt/1.1)).intValue();
				n_cls_v_amt = n_cls_amt-n_cls_s_amt;
			}
*/
			//매입옵션인 경우 해지스케쥴 생성 안함. 15:말소
			if(!cls.getCls_st().equals("8") && !cls.getCls_st().equals("4") && !cls.getCls_st().equals("5") && !cls.getCls_st().equals("9")  && !cls.getCls_st().equals("15") ) {
			
		//		if( cls.getCls_s_amt() + cls.getCls_v_amt() != 0){
	
					pstmt2 = conn.prepareStatement(query_in);
					pstmt2.setString(1, cls.getRent_mng_id());
					pstmt2.setString(2, cls.getRent_l_cd());
					pstmt2.setInt   (3, cls.getCls_s_amt());
					pstmt2.setInt   (4, cls.getCls_v_amt());
					pstmt2.setString(5, cls.getCls_est_dt());
					pstmt2.setString(6, cls.getReg_id());
	
					pstmt2.executeUpdate();
					pstmt2.close();
				
		//		}
			}
			
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[AddClsDatabase:insertCls2]\n"+e);			
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
                if(pstmt2 != null)	pstmt2.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}


/**
	 *	해지 insert - 구분정산
	 */
	public boolean insertCls2(ClsBean cls, int h5_amt , int h7_amt, String jung_st)
	{
		getConnection();
		boolean flag = true;
		String query = "insert into cls_cont ("+
							" RENT_MNG_ID,	RENT_L_CD,	CLS_ST,		TERM_YN,	CLS_DT, "+
							" REG_ID,		CLS_CAU,	P_BRCH_CD,	NEW_BRCH_CD,TRF_DT, "+
						 	" IFEE_S_AMT,	IFEE_V_AMT, IFEE_ETC,	PP_S_AMT,	PP_V_AMT, "+
							" PP_ETC,		PDED_S_AMT, PDED_V_AMT, PDED_ETC,	TPDED_S_AMT,"+
						 	" TPDED_V_AMT,	TPDED_ETC,	RFEE_S_AMT, RFEE_V_AMT, RFEE_ETC, "+
						 	" DFEE_TM,		DFEE_S_AMT, DFEE_V_AMT, NFEE_TM,	NFEE_S_AMT, "+
							" NFEE_V_AMT,	NFEE_MON,	NFEE_DAY,	NFEE_AMT,	TFEE_AMT, "+
						 	" MFEE_AMT,		RCON_MON,	RCON_DAY,	TRFEE_AMT,	DFT_INT, "+
							" DFT_AMT,		NO_DFT_YN,	NO_DFT_CAU,	FDFT_AMT1,	FDFT_DC_AMT,"+
						 	" FDFT_AMT2,	PAY_DT,		NFEE_DAYS,	RCON_DAYS,	PP_ST,"+
							" CLS_EST_DT,	VAT_ST,		EXT_DT,		EXT_ID,		GRT_AMT,"+
							" CLS_DOC_YN,	OPT_PER,	OPT_AMT,	OPT_DT,		OPT_MNG,"+
							" dly_amt, no_v_amt, car_ja_amt, r_mon, r_day, cls_s_amt, cls_v_amt, etc_amt, fine_amt, ex_di_amt,"+
							" ifee_mon, ifee_day, ifee_ex_amt, rifee_s_amt, cancel_yn, reg_dt, etc2_amt, etc3_amt, etc4_amt, etc5_amt , fdft_amt3, tot_dist, cms_chk, \n"+
							" rifee_v_amt , over_amt , over_v_amt  "+  //4
							"  ) values("+
						 	" ?, ?, ?, ?, replace(?, '-', ''), "+
							" ?, ?, ?, ?, replace(?, '-', ''), "+
						 	" ?, ?, ?, ?, ?, "+
							" ?, ?, ?, ?, ?, "+ 
						 	" ?, ?, ?, ?, ?, "+
							" ?, ?, ?, ?, ?, "+
						 	" ?, ?, ?, ?, ?, "+
							" ?, ?, ?, ?, ?, "+
						 	" ?, ?, ?, ?, ?, "+
							" ?, replace(?, '-', ''), ?, ?, ?,"+
							" replace(?, '-', ''), ?, replace(?, '-', ''), ?, ?,"+
						 	" ?, ?, ?, replace(?, '-', ''), ?,"+
							" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
							" ?, ?, ?, ?, ?, to_char(sysdate,'YYYYMMDD'), ?, ?, ?, ?, ?, ?, ?, "+
							" ?, ?, ?   ) ";

		//환불
		String query_in = " INSERT INTO scd_ext"+
							" (rent_mng_id, rent_l_cd, rent_st, rent_seq, ext_st, ext_id, ext_tm,"+
							"  ext_s_amt, ext_v_amt, ext_est_dt, bill_yn, update_id, update_dt, gubun)"+
							" values "+
							" ( ?, ?, '1', '1', '4', '0', '1',"+
							"   ?, 0, replace(?, '-', ''), 'Y', ?, to_char(sysdate,'YYYYMMDD') , ? )";			
			
		//청구					
		String query_in2 = " INSERT INTO scd_ext"+
							" (rent_mng_id, rent_l_cd, rent_st, rent_seq, ext_st, ext_id, ext_tm,"+
							"  ext_s_amt, ext_v_amt, ext_est_dt, bill_yn, update_id, update_dt, gubun )"+
							" values "+
							" ( ?, ?, '1', '1', '4', '0', '2',"+
							"   ?, 0, replace(?, '-', ''), 'Y', ?, to_char(sysdate,'YYYYMMDD') , ? )";								

		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;

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
			pstmt.setString(8, cls.getP_brch_cd());
			pstmt.setString(9, cls.getNew_brch_cd());
			pstmt.setString(10, cls.getTrf_dt());
			pstmt.setInt   (11, cls.getIfee_s_amt());
			pstmt.setInt   (12, cls.getIfee_v_amt());
			pstmt.setString(13, cls.getIfee_etc());
			pstmt.setInt   (14, cls.getPp_s_amt());
			pstmt.setInt   (15, cls.getPp_v_amt());
			pstmt.setString(16, cls.getPp_etc());
			pstmt.setInt   (17, cls.getPded_s_amt());
			pstmt.setInt   (18, cls.getPded_v_amt());
			pstmt.setString(19, cls.getPded_etc());
			pstmt.setInt   (20, cls.getTpded_s_amt());
			pstmt.setInt   (21, cls.getTpded_v_amt());
			pstmt.setString(22, cls.getTpded_etc());
			pstmt.setInt   (23, cls.getRfee_s_amt());
			pstmt.setInt   (24, cls.getRfee_v_amt());
			pstmt.setString(25, cls.getRfee_etc());
			pstmt.setString(26, cls.getDfee_tm());
			pstmt.setInt   (27, cls.getDfee_s_amt());
			pstmt.setInt   (28, cls.getDfee_v_amt());
			pstmt.setString(29, cls.getNfee_tm());
			pstmt.setInt   (30, cls.getNfee_s_amt());
			pstmt.setInt   (31, cls.getNfee_v_amt());
			pstmt.setString(32, cls.getNfee_mon());
			pstmt.setString(33, cls.getNfee_day());
			pstmt.setInt   (34, cls.getNfee_amt());
			pstmt.setInt   (35, cls.getTfee_amt());
			pstmt.setInt   (36, cls.getMfee_amt());
			pstmt.setString(37, cls.getRcon_mon());
			pstmt.setString(38, cls.getRcon_day());
			pstmt.setInt   (39, cls.getTrfee_amt());
			pstmt.setString(40, cls.getDft_int());
			pstmt.setInt   (41, cls.getDft_amt());
			pstmt.setString(42, cls.getNo_dft_yn());
			pstmt.setString(43, cls.getNo_dft_cau());
			pstmt.setInt   (44, cls.getFdft_amt1());
			pstmt.setInt   (45, cls.getFdft_dc_amt());
			pstmt.setInt   (46, cls.getFdft_amt2());
			pstmt.setString(47, cls.getPay_dt());
			pstmt.setString(48, cls.getNfee_days());
			pstmt.setString(49, cls.getRcon_days());
			pstmt.setString(50, cls.getPp_st());			
			pstmt.setString(51, cls.getCls_est_dt());			
			pstmt.setString(52, cls.getVat_st());			
			pstmt.setString(53, cls.getExt_dt());			
			pstmt.setString(54, cls.getExt_id());			
			pstmt.setInt   (55, cls.getGrt_amt());
			pstmt.setString(56, cls.getCls_doc_yn());			
			pstmt.setString(57, cls.getOpt_per());			
			pstmt.setInt   (58, cls.getOpt_amt());
			pstmt.setString(59, cls.getOpt_dt());			
			pstmt.setString(60, cls.getOpt_mng());			
			pstmt.setInt   (61, cls.getDly_amt());
			pstmt.setInt   (62, cls.getNo_v_amt());
			pstmt.setInt   (63, cls.getCar_ja_amt());
			pstmt.setString(64, cls.getR_mon());			
			pstmt.setString(65, cls.getR_day());			
			pstmt.setInt   (66, cls.getCls_s_amt());
			pstmt.setInt   (67, cls.getCls_v_amt());
			pstmt.setInt   (68, cls.getEtc_amt());
			pstmt.setInt   (69, cls.getFine_amt());
			pstmt.setInt   (70, cls.getEx_di_amt());
			pstmt.setString(71, cls.getIfee_mon());			
			pstmt.setString(72, cls.getIfee_day());			
			pstmt.setInt   (73, cls.getIfee_ex_amt());
			pstmt.setInt   (74, cls.getRifee_s_amt());
			pstmt.setString(75, cls.getCancel_yn());
			pstmt.setInt   (76, cls.getEtc2_amt());
			pstmt.setInt   (77, cls.getEtc3_amt());
			pstmt.setInt   (78, cls.getEtc4_amt());
			pstmt.setInt   (79, cls.getEtc5_amt());
			pstmt.setInt   (80, cls.getFdft_amt3());
			pstmt.setInt   (81, cls.getTot_dist());	
			pstmt.setString(82, cls.getCms_chk());	
			
			pstmt.setInt   (83, cls.getRifee_v_amt());
			pstmt.setInt   (84, cls.getOver_amt());
			pstmt.setInt   (85, cls.getOver_v_amt());  //4
		
			pstmt.executeUpdate();
			pstmt.close();

			int n_cls_amt = 0;
			int n_cls_s_amt = 0;
			int n_cls_v_amt = 0;

//			if(cls.getCls_st().equals("2")){//중도해약
/*				n_cls_amt = cls.getFdft_amt2();
				if(cls.getVat_st().equals("1")){//부가세포함
					n_cls_s_amt = (new Double(n_cls_amt/1.1)).intValue();
					n_cls_v_amt = n_cls_amt-n_cls_s_amt;
				}else{
					n_cls_s_amt = n_cls_amt;
				}
*/
/*			}else if(cls.getCls_st().equals("8")){//매입옵션
				n_cls_amt = cls.getOpt_amt();
				n_cls_s_amt = (new Double(n_cls_amt/1.1)).intValue();
				n_cls_v_amt = n_cls_amt-n_cls_s_amt;
			}
*/
			//매입옵션인 경우 해지스케쥴 생성 안함. 15:말소
			if(!cls.getCls_st().equals("8") && !cls.getCls_st().equals("4") && !cls.getCls_st().equals("5") && !cls.getCls_st().equals("9")  && !cls.getCls_st().equals("15") ) {
			
		//		if( cls.getCls_s_amt() + cls.getCls_v_amt() != 0){
	
					pstmt1 = conn.prepareStatement(query_in);
					pstmt1.setString(1, cls.getRent_mng_id());
					pstmt1.setString(2, cls.getRent_l_cd());
					pstmt1.setInt   (3, h5_amt);
					pstmt1.setString(4, cls.getCls_est_dt());
					pstmt1.setString(5, cls.getReg_id());
					pstmt1.setString(6, jung_st);
	
					pstmt1.executeUpdate();
					pstmt1.close();
										
					pstmt2 = conn.prepareStatement(query_in2);
					pstmt2.setString(1, cls.getRent_mng_id());
					pstmt2.setString(2, cls.getRent_l_cd());
					pstmt2.setInt   (3, h7_amt);
					pstmt2.setString(4, cls.getCls_est_dt());
					pstmt2.setString(5, cls.getReg_id());
					pstmt2.setString(6, jung_st);
		
					pstmt2.executeUpdate();
					pstmt2.close();
				
		//		}
			}
			
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[AddClsDatabase:insertCls2]\n"+e);			
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
                if(pstmt1 != null)	pstmt1.close();
                if(pstmt2 != null)	pstmt2.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}

	/**
	 *	해지 update
	 */
	public boolean updateCls(ClsBean cls)
	{
		getConnection();
		boolean flag = true;
		String query = " update cls_cont set "+
						" term_yn = ?,"+
						" cls_dt = replace(?, '-', ''),"+
						" reg_id = ?,"+
						" cls_cau = ?,"+
						" p_brch_cd = ?,"+
						" new_brch_cd = ?,"+
						" trf_dt = replace(?, '-', ''),"+
						" ifee_s_amt = ?,"+
						" ifee_v_amt = ?,"+
						" ifee_etc = ?,"+
						" pp_s_amt = ?,"+
						" pp_v_amt = ?,"+
						" pp_etc = ?,"+
						" pded_s_amt = ?,"+
						" pded_v_amt = ?,"+
						" pded_etc = ?,"+
						" tpded_s_amt = ?,"+
						" tpded_v_amt = ?,"+
						" tpded_etc = ?,"+
						" rfee_s_amt = ?,"+
						" rfee_v_amt = ?,"+
						" rfee_etc = ?,"+
						" dfee_tm = ?,"+
						" dfee_s_amt = ?,"+
						" dfee_v_amt = ?,"+
						" nfee_tm = ?,"+
						" nfee_s_amt = ?,"+
						" nfee_v_amt = ?,"+
						" nfee_mon = ?,"+
						" nfee_day = ?,"+
						" nfee_amt = ?,"+
						" tfee_amt = ?,"+
						" mfee_amt = ?,"+
						" rcon_mon = ?,"+
						" rcon_day = ?,"+
						" trfee_amt = ?,"+
						" dft_int = ?,"+
						" dft_amt = ?,"+
						" no_dft_yn = ?,"+
						" no_dft_cau = ?,"+
						" fdft_amt1 = ?,"+
						" fdft_dc_amt = ?,"+
						" fdft_amt2 = ?,"+
						" pay_dt = replace(?, '-', ''),"+
						" nfee_days = ?,"+
						" rcon_days = ?,"+
						" pp_st = ?,"+
						" cls_est_dt = replace(?, '-', ''),"+
						" vat_st = ?,"+
						" ext_dt = replace(?, '-', ''),"+
						" ext_id = ?,"+
						" grt_amt = ?,"+
						" cls_doc_yn = ?,"+
						" opt_per = ?,"+
						" opt_amt = ?,"+
						" opt_dt = replace(?, '-', ''),"+
						" opt_mng = ?,"+
						" dly_amt = ?, no_v_amt = ?, car_ja_amt = ?, r_mon = ?, r_day = ?, cls_s_amt = ?, cls_v_amt = ?,"+
						" etc_amt = ?, fine_amt = ?, ex_di_amt = ?,"+
						" ifee_mon = ?, ifee_day = ?, ifee_ex_amt = ?, rifee_s_amt = ?, cancel_yn = ?, cls_st = ?,"+
						" etc2_amt = ?, etc3_amt = ?, etc4_amt = ?, etc5_amt = ?, "+
						" tot_dist = ?, cms_chk = ? , over_amt = ? ,  "+
						" rifee_v_amt = ?, over_v_amt = ? "+						
						" where rent_mng_id = ? and rent_l_cd = ?";
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, cls.getTerm_yn());
			pstmt.setString(2, cls.getCls_dt());
			pstmt.setString(3, cls.getReg_id());
			pstmt.setString(4, cls.getCls_cau());
			pstmt.setString(5, cls.getP_brch_cd());

			pstmt.setString(6, cls.getNew_brch_cd());
			pstmt.setString(7, cls.getTrf_dt());
			pstmt.setInt   (8, cls.getIfee_s_amt());
			pstmt.setInt   (9, cls.getIfee_v_amt());
			pstmt.setString(10, cls.getIfee_etc());

			pstmt.setInt   (11, cls.getPp_s_amt());
			pstmt.setInt   (12, cls.getPp_v_amt());
			pstmt.setString(13, cls.getPp_etc());
			pstmt.setInt   (14, cls.getPded_s_amt());
			pstmt.setInt   (15, cls.getPded_v_amt());
			
			pstmt.setString(16, cls.getPded_etc());
			pstmt.setInt   (17, cls.getTpded_s_amt());
			pstmt.setInt   (18, cls.getTpded_v_amt());
			pstmt.setString(19, cls.getTpded_etc());
			pstmt.setInt   (20, cls.getRfee_s_amt());
			
			pstmt.setInt   (21, cls.getRfee_v_amt());
			pstmt.setString(22, cls.getRfee_etc());
			pstmt.setString(23, cls.getDfee_tm());
			pstmt.setInt   (24, cls.getDfee_s_amt());
			pstmt.setInt   (25, cls.getDfee_v_amt());
			
			pstmt.setString(26, cls.getNfee_tm());
			pstmt.setInt   (27, cls.getNfee_s_amt());
			pstmt.setInt   (28, cls.getNfee_v_amt());
			pstmt.setString(29, cls.getNfee_mon());
			pstmt.setString(30, cls.getNfee_day());
			
			pstmt.setInt   (31, cls.getNfee_amt());
			pstmt.setInt   (32, cls.getTfee_amt());
			pstmt.setInt   (33, cls.getMfee_amt());
			pstmt.setString(34, cls.getRcon_mon());
			pstmt.setString(35, cls.getRcon_day());
			
			pstmt.setInt   (36, cls.getTrfee_amt());
			pstmt.setString(37, cls.getDft_int());
			pstmt.setInt   (38, cls.getDft_amt());
			pstmt.setString(39, cls.getNo_dft_yn());
			pstmt.setString(40, cls.getNo_dft_cau());
			
			pstmt.setInt   (41, cls.getFdft_amt1());
			pstmt.setInt   (42, cls.getFdft_dc_amt());
			pstmt.setInt   (43, cls.getFdft_amt2());
			pstmt.setString(44, cls.getPay_dt());
			pstmt.setString(45, cls.getNfee_days());
			
			pstmt.setString(46, cls.getRcon_days());
			pstmt.setString(47, cls.getPp_st());
			pstmt.setString(48, cls.getCls_est_dt());
			pstmt.setString(49, cls.getVat_st());
			pstmt.setString(50, cls.getExt_dt());
			pstmt.setString(51, cls.getExt_id());
			pstmt.setInt   (52, cls.getGrt_amt());

			pstmt.setString(53, cls.getCls_doc_yn());
			pstmt.setString(54, cls.getOpt_per());
			pstmt.setInt   (55, cls.getOpt_amt());
			pstmt.setString(56, cls.getOpt_dt());
			pstmt.setString(57, cls.getOpt_mng());

			pstmt.setInt   (58, cls.getDly_amt());
			pstmt.setInt   (59, cls.getNo_v_amt());
			pstmt.setInt   (60, cls.getCar_ja_amt());
			pstmt.setString(61, cls.getR_mon());
			pstmt.setString(62, cls.getR_day());
			pstmt.setInt   (63, cls.getCls_s_amt());
			pstmt.setInt   (64, cls.getCls_v_amt());
			pstmt.setInt   (65, cls.getEtc_amt());
			pstmt.setInt   (66, cls.getFine_amt());
			pstmt.setInt   (67, cls.getEx_di_amt());
			pstmt.setString(68, cls.getIfee_mon());
			pstmt.setString(69, cls.getIfee_day());
			pstmt.setInt   (70, cls.getIfee_ex_amt());
			pstmt.setInt   (71, cls.getRifee_s_amt());
			pstmt.setString(72, cls.getCancel_yn());
			pstmt.setString(73, cls.getCls_st());

			pstmt.setInt   (74, cls.getEtc2_amt());
			pstmt.setInt   (75, cls.getEtc3_amt());
			pstmt.setInt   (76, cls.getEtc4_amt());
			pstmt.setInt   (77, cls.getEtc5_amt());
			
			pstmt.setInt   (78, cls.getTot_dist());
			pstmt.setString(79, cls.getCms_chk());
			pstmt.setInt   (80, cls.getOver_amt());
			
			pstmt.setInt   (81, cls.getRifee_v_amt());
			pstmt.setInt   (82, cls.getOver_v_amt());
						
			pstmt.setString(83, cls.getRent_mng_id());
			pstmt.setString(84, cls.getRent_l_cd());
			
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddClsDatabase:updateCls]\n"+e);			
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
	 *	해지 delete(취소)
	 */
	public boolean deleteCls(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		boolean flag = true;
		String query = " delete cls_cont where rent_mng_id = ? and rent_l_cd = ?";
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
		    pstmt.executeUpdate();
		    pstmt.close();
		   	conn.commit();
		    
	  	} catch (Exception e) {
	  		System.out.println("[AddClsDatabase:deleteCls]\n"+e);			
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

	/*해지 수정페이지 조회 : 해지건 query - rent_mng_id, rent_l_cd  */
	public ClsBean getClsCase(String m_id, String l_cd)
	{
		getConnection();
		ClsBean cls = new ClsBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		query = " select"+
				" a.RENT_MNG_ID, a.RENT_L_CD, a.TERM_YN, "+ 
				" decode(a.CLS_ST, '1','계약만료', '2','중도해약', '3','영업소변경', '4','차종변경', '5','계약승계', '6','매각', '7','출고전해지(신차)', '8','매입옵션', '9', '폐차', '10' , '개시전해지(재리스)','14' , '월렌트해지', '15', '말소' ) CLS_ST,"+
				" decode(a.CLS_DT, '', '', substr(a.CLS_DT, 1, 4) || '-' || substr(a.CLS_DT, 5, 2) || '-'||substr(a.CLS_DT, 7, 2)) CLS_DT,"+
				" a.REG_ID, a.reg_dt, a.CLS_CAU, a.P_BRCH_CD, a.NEW_BRCH_CD,"+
				" decode(a.TRF_DT, '', '', substr(a.TRF_DT, 1, 4) || '-' || substr(a.TRF_DT, 5, 2) || '-'||substr(a.TRF_DT, 7, 2)) TRF_DT,"+
				" a.IFEE_S_AMT, a.IFEE_V_AMT, a.IFEE_ETC, a.PP_S_AMT, a.PP_V_AMT, a.PP_ETC,"+
				" a.PDED_S_AMT, a.PDED_V_AMT, a.PDED_ETC, a.TPDED_S_AMT, a.TPDED_V_AMT, a.TPDED_ETC, a.RFEE_S_AMT,"+
				" a.RFEE_V_AMT, a.RFEE_ETC, a.DFEE_TM, a.DFEE_S_AMT, a.DFEE_V_AMT, a.NFEE_TM, a.NFEE_S_AMT, a.NFEE_V_AMT,"+
				" rtrim(a.NFEE_MON) NFEE_MON, rtrim(a.NFEE_DAY) NFEE_DAY, a.NFEE_AMT, a.TFEE_AMT, a.MFEE_AMT, a.NO_V_AMT,"+
				" rtrim(a.RCON_MON) RCON_MON, rtrim(a.RCON_DAY) RCON_DAY,"+
				" a.TRFEE_AMT, a.DFT_INT, a.DFT_AMT, a.NO_DFT_YN, a.NO_DFT_CAU, a.FDFT_AMT1, a.FDFT_DC_AMT, a.FDFT_AMT2,"+
				" decode(b.PAY_DT, '', '', substr(b.PAY_DT, 1, 4) || '-' || substr(b.PAY_DT, 5, 2) || '-'||substr(b.PAY_DT, 7, 2)) PAY_DT,"+
				" decode(a.opt_dt, '', '', substr(a.opt_dt, 1, 4) || '-' || substr(a.opt_dt, 5, 2) || '-'||substr(a.opt_dt, 7, 2)) opt_dt,"+
				" a.NFEE_DAYS, a.RCON_DAYS, a.PP_ST, a.cls_est_dt, a.ext_dt, a.ext_id, a.vat_st, a.grt_amt, a.cls_doc_yn, a.opt_per, a.opt_amt, a.opt_mng,"+
				" a.dly_amt, a.no_v_amt, a.car_ja_amt, a.etc_amt, a.r_mon, a.r_day, a.cls_s_amt, a.cls_v_amt, a.fine_amt, a.ex_di_amt, a.ifee_mon, a.ifee_day, a.ifee_ex_amt, a.rifee_s_amt, a.cancel_yn, "+
				" a.etc2_amt, a.etc3_amt, a.etc4_amt, a.etc5_amt , nvl(a.cms_chk, 'N') cms_chk,  a.over_amt , a.tot_dist , "+	
				" a.rifee_v_amt , a.over_v_amt  " +
				" from cls_cont a, (select RENT_L_CD, max(ext_pay_dt) PAY_DT from scd_ext where ext_st = '4' group by rent_l_cd) b"+
				" where a.RENT_L_CD=b.RENT_L_CD(+) and a.RENT_MNG_ID = ? and a.RENT_L_CD = ?";
						
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, m_id);
			pstmt.setString(2, l_cd);
	    	rs = pstmt.executeQuery();
	    	
			while(rs.next())
			{
				cls.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				cls.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				cls.setCls_st(rs.getString("CLS_ST")==null?"":rs.getString("CLS_ST"));	
				cls.setTerm_yn(rs.getString("TERM_YN")==null?"":rs.getString("TERM_YN"));	
				cls.setCls_dt(rs.getString("CLS_DT")==null?"":rs.getString("CLS_DT"));	
				cls.setReg_id(rs.getString("REG_ID")==null?"":rs.getString("REG_ID"));	
				cls.setReg_dt(rs.getString("REG_DT")==null?"":rs.getString("REG_DT"));
				cls.setCls_cau(rs.getString("CLS_CAU")==null?"":rs.getString("CLS_CAU"));	
				cls.setP_brch_cd(rs.getString("P_BRCH_CD")==null?"":rs.getString("P_BRCH_CD"));
				cls.setNew_brch_cd(rs.getString("NEW_BRCH_CD")==null?"":rs.getString("NEW_BRCH_CD"));
				cls.setTrf_dt(rs.getString("TRF_DT")==null?"":rs.getString("TRF_DT"));	
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
				cls.setDfee_s_amt(rs.getInt("DFEE_S_AMT"));
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
				cls.setCls_doc_yn(rs.getString("cls_doc_yn")==null?"":rs.getString("cls_doc_yn"));
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
				cls.setEtc5_amt(rs.getInt("etc5_amt"));
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
				cls.setCms_chk(rs.getString("cms_chk")==null?"":rs.getString("cms_chk"));
				cls.setOver_amt(rs.getInt("over_amt"));
				cls.setTot_dist(rs.getInt("tot_dist"));
				
				cls.setRifee_v_amt(rs.getInt("rifee_v_amt"));
				cls.setOver_v_amt(rs.getInt("over_v_amt"));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddClsDatabase:getClsCase]\n"+e);			
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
	
	//계약 변경 : 중도해지 조회
	public Hashtable getFeeSettle(String m_id, String l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		query = " select"+
				" max(ifee_s_amt) ifee_s_amt,"+
				" max(ifee_v_amt) ifee_v_amt,"+
				" max(ifee_s_amt+ifee_v_amt) ifee_amt,"+
				" max(grt_amt_s) grt_amt_s,"+
				" max(pp_s_amt) pp_s_amt,"+
				" max(pp_v_amt) pp_v_amt,"+
				" max(pp_s_amt+pp_v_amt) pp_amt,"+
				" sum(del_amt) del_amt,"+
				" round(sum(del_amt)/1.1, 0) del_s_amt,"+
				" (sum(del_amt) - round(sum(del_amt)/1.1, 0)) del_v_amt,"+
				" sum(rest_amt) rest_amt,"+
				" round(sum(rest_amt)/1.1, 0) rest_s_amt,"+
				" (sum(rest_amt) - round(sum(rest_amt)/1.1, 0)) rest_v_amt,"+
				" sum(del_cnt) del_cnt,"+
				" sum(rest_cnt) rest_cnt, "+
				" round(sum(del_amt)/1.1, 0)+round(sum(rest_amt)/1.1, 0) tot_s_amt,"+
				" (sum(del_amt) - round(sum(del_amt)/1.1, 0))+(sum(rest_amt) - round(sum(rest_amt)/1.1, 0)) tot_v_amt,"+
				" sum(rest_amt)+sum(del_amt) tot_amt,"+
				" sum(del_cnt)+sum(rest_cnt) tot_cnt"+
				" from"+
				" ("+
					" select F.ifee_s_amt, F.ifee_v_amt, F.grt_amt_s, F.pp_s_amt, F.pp_v_amt,"+
					" decode(sign(trunc(to_date(S.r_fee_est_dt, 'YYYYMMDD')-sysdate)), -1, S.fee_s_amt+S.fee_v_amt, 0) del_amt,"+
					" decode(sign(trunc(to_date(S.r_fee_est_dt, 'YYYYMMDD')-sysdate)), -1, 0, S.fee_s_amt+S.fee_v_amt) rest_amt,"+
					" decode(sign(trunc(to_date(S.r_fee_est_dt, 'YYYYMMDD')-sysdate)), -1, 1, 0) del_cnt,"+
					" decode(sign(trunc(to_date(S.r_fee_est_dt, 'YYYYMMDD')-sysdate)), -1, 0, 1) rest_cnt"+
					" from fee F, cont C, scd_fee S"+
					" where F.rent_mng_id = C.rent_mng_id and "+
					" F.rent_l_cd = C.rent_l_cd and"+
					" F.rent_mng_id = S.rent_mng_id and"+
					" F.rent_l_cd = S.rent_l_cd and"+
					" F.rent_st = "+
					" ("+
						"select max(to_number(rent_st)) from fee where rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"'"+
					" ) and"+
					" F.rent_mng_id='"+m_id+"' and"+
					" F.rent_l_cd='"+l_cd+"' and"+
					" S.rc_yn = '0'"+
				" )";

		try {
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

		} catch (SQLException e) {
			System.out.println("[AddClsDatabase:getFeeSettle]\n"+e);			
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
	 *	계약중도해지시 처리
	 *	cls_st - 해약구분(1:계약만료 2:중도해지 3:영업소변경, 4:차종변경, 5:계약이관, 6:매각, 7:출고전해지, 8:매입옵션, 9:폐차,  10:개시전해지(재리스) ), 14:월렌트해지, 15:말소 
	 *	1:해지테이블에 처리구분 flag 변경, 
	 *	2:계약기초테이블 flag 변경, 
	 *	3: 대여료 or 선납금 스케줄 중 미납(예정) 스케줄 삭제
	 */
	public boolean closeCont(String rent_mng_id, String rent_l_cd, String cls_st, String dly_count, String dly_value, String car_no, String cls_dt)
	{
		if(cls_st.equals("6") || cls_st.equals("7") || cls_st.equals("8") || cls_st.equals("9")  )		
			return closeContNoRecon(rent_mng_id, rent_l_cd); 
		else if(cls_st.equals("1") || cls_st.equals("2") || cls_st.equals("10")  || cls_st.equals("14"))
			return closeContRecon(rent_mng_id, rent_l_cd, dly_count, dly_value, car_no, cls_dt, cls_st);
		else if(cls_st.equals("3"))
			return closeContReconBrch(rent_mng_id, rent_l_cd);
		else if(cls_st.equals("15"))  //말소는 차량만 말소로 
			return closeContCarReg(rent_mng_id, rent_l_cd, car_no, cls_dt);	
		else if(cls_st.equals("4") || cls_st.equals("5")   )
			return closeContReconAfterDlv(rent_mng_id, rent_l_cd, cls_st, cls_dt);
		else
			return false;
	}

	
	
	/** 6:매각, 7:출고전해지, 8:매입옵션
	 *	A. 계약중도해지처리시 재계약 없는 경우.(1:출고전해지, 2:중도해지)
	 *	B. 재계약있는경우	(재계약 등록후 처리 3:출고전 차종변경)
	 *	1:해지테이블에 처리구분 flag 변경, 
	 *	2:계약기초테이블 flag 변경, 
	 *	3: 대여료 스케줄 중 미납(예정) 스케줄 삭제
	 *	4: 선납금 스케줄 중 미납 스케줄 삭제
	 */	
	public boolean closeContNoRecon(String rent_mng_id, String rent_l_cd)
	{
		boolean flag = true;
		getConnection();
		PreparedStatement cls_pstmt = null;
		PreparedStatement cont_pstmt = null;
		PreparedStatement fee_pstmt = null;
		PreparedStatement pp_pstmt = null;

		String cls_qry	= "update cls_cont set term_yn = 'Y' where rent_mng_id=? and rent_l_cd = ?";
		String cont_qry = "update cont set use_yn = 'N' where rent_mng_id=? and rent_l_cd = ?";
		String fee_qry	= "update scd_fee	set bill_yn='N' where rent_mng_id=? and rent_l_cd = ? and rc_yn='0'";
		String pp_qry	= "update scd_ext	set bill_yn='N' where ext_st in ('0', '1', '2' ) and rent_mng_id=? and rent_l_cd = ? and ext_PAY_AMT =0";

		try {
			conn.setAutoCommit(false);
			
				
			cls_pstmt = conn.prepareStatement(cls_qry);
			cls_pstmt.setString(1 , rent_mng_id);
			cls_pstmt.setString(2 , rent_l_cd);
			cls_pstmt.executeUpdate();

			cont_pstmt = conn.prepareStatement(cont_qry);
			cont_pstmt.setString(1 , rent_mng_id);
			cont_pstmt.setString(2 , rent_l_cd);
			cont_pstmt.executeUpdate();

			fee_pstmt = conn.prepareStatement(fee_qry);
			fee_pstmt.setString(1 , rent_mng_id);
			fee_pstmt.setString(2 , rent_l_cd);
			fee_pstmt.executeUpdate();

			pp_pstmt = conn.prepareStatement(pp_qry);
			pp_pstmt.setString(1 , rent_mng_id);
			pp_pstmt.setString(2 , rent_l_cd);
			pp_pstmt.executeUpdate();

			cls_pstmt.close(); 
			cont_pstmt.close();
			fee_pstmt.close(); 
			pp_pstmt.close();  
			
			conn.commit();
				
	  	} catch (Exception e) {
			System.out.println("[AddClsDatabase:closeContNoRecon]\n"+e);			
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
                if(cls_pstmt != null)	cls_pstmt.close();
                if(cont_pstmt != null)	cont_pstmt.close();
                if(fee_pstmt != null)	fee_pstmt.close();
                if(pp_pstmt != null)	pp_pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}		
	}
	
	/**
	 *	계약중도해지처리 -- 계약만료, 중도해지 -> 예비차로 재등록 - 본사고객지원팀인 경우 mng_id는 해지시점의 bus_id2로 일단 처리 - 영업,지점은???
	 *	1:해지테이블에 처리구분 flag 변경, 
	 *	2:계약기초테이블 flag 변경, 
	 *	3:새 계약코드와 기존 내용으로 계약 base insert.
	 */	
	public boolean closeContRecon(String rent_mng_id, String old_rent_l_cd, String dly_count, String dly_value, String car_no, String cls_dt, String cls_st)
	{
		String new_rent_l_cd = getNextRent_l_cd(old_rent_l_cd.substring(0, 7)+"S");		//신규계약코드
		//해지계약 정보
		ClsBean cls = getClsCase(rent_mng_id, old_rent_l_cd);
		
		getConnection();
		int flag = 0;
		PreparedStatement cls_pstmt = null;
		PreparedStatement cont_pstmt = null;
		PreparedStatement fee_pstmt = null;
		PreparedStatement pp_pstmt = null;
		PreparedStatement fee_add_pstmt = null;
		PreparedStatement fine_pstmt = null;
		PreparedStatement serv_pstmt = null;
		PreparedStatement serv1_pstmt = null;
		PreparedStatement dly_pstmt = null;
		PreparedStatement cid_pstmt = null;
		PreparedStatement cid_cnt_pstmt = null;
			
		ResultSet rs = null;
		ResultSet rs1 = null;
		ResultSet rs2 = null;
		
		String seq = "";
		String car_mng_id = "";
		 int cid_cnt = 0;
		
		int dly = 0;
		String cls_qry	= "update cls_cont set term_yn = 'Y' where rent_mng_id=? and rent_l_cd= ?";
		String cont_qry = "update cont set use_yn = 'N' where rent_mng_id=? and rent_l_cd= ?";
		
		//대여료 대손처리
	//	String fee_qry	= "update scd_fee	set bill_yn='N' where rent_mng_id=? and rent_l_cd = ? and rc_yn='0' and dly_days='0'";

		//선수금 대손처리
		String pp_qry	= "update scd_ext	set bill_yn='N' where ext_st in ('0', '1', '2' ) and rent_mng_id=? and rent_l_cd = ? and ext_PAY_AMT =0";

		//과태료 대손처리
		String fine_qry	= "update fine		set bill_yn='N', note=note || ' - 해지정산시 포함' where rent_mng_id=? and rent_l_cd = ? and paid_amt > 0 and coll_dt is null and nvl(no_paid_yn,'N')<>'Y' and paid_st in ('3','4')";
		//면책금 대손처리
		String serv_qry	= "update service	set bill_yn='N', no_dft_cau = '기청구분 해지정산시 포함'  where rent_mng_id=? and rent_l_cd = ? and cust_amt > 0 and cust_pay_dt is null and nvl(no_dft_yn,'N')<>'Y'";
		String serv1_qry= "update scd_ext	set bill_yn='N'  where ext_st='3' and  rent_mng_id=? and rent_l_cd = ? and (ext_s_amt + ext_v_amt )> 0 and ext_pay_dt is null ";
	
		//(대여료)연체료 대체납처리
		String dly_qry = " insert into SCD_DLY (RENT_MNG_ID, RENT_L_CD, SEQ, PAY_DT, PAY_AMT, REG_ID, REG_DT, ETC)"+
							" values (?, ?, ?, replace(?, '-', ''), ?, ?, to_char(sysdate,'YYYYMMDD'), ?)";
		String dly_seq = " select nvl(to_char(max(to_number(seq))+1),'1') seq from scd_dly where rent_mng_id=? and rent_l_cd=?";
				
		String  cid_qry = " select  nvl(car_mng_id, 'X' )  from cont where  rent_mng_id=? and rent_l_cd=? ";
		
		String cid_cnt_qry = " select count(*) from cont where car_st = '2' and use_yn = 'Y' and car_mng_id =  ? ";
			
		try {
			
			conn.setAutoCommit(false);
				
			//해지계약 마감
			cls_pstmt = conn.prepareStatement(cls_qry);
			cls_pstmt.setString(1, rent_mng_id);
			cls_pstmt.setString(2, old_rent_l_cd);
			cls_pstmt.executeUpdate();
			//계약 사용여부 수정
			cont_pstmt = conn.prepareStatement(cont_qry);
			cont_pstmt.setString(1, rent_mng_id);
			cont_pstmt.setString(2, old_rent_l_cd);
			cont_pstmt.executeUpdate();

			//중도해지시 대손처리(2005-07-18 정현미 수정) :만기해지도 포함 (20081209)
			if(cls_st.equals("1") || cls_st.equals("2")  || cls_st.equals("14")    || cls_st.equals("10")  ){
		//	if(cls_st.equals("2")){
/*
				fee_pstmt = conn.prepareStatement(fee_qry);
				fee_pstmt.setString(1 , rent_mng_id);
				fee_pstmt.setString(2 , old_rent_l_cd);
				fee_pstmt.executeUpdate();
*/
				pp_pstmt = conn.prepareStatement(pp_qry);
				pp_pstmt.setString(1 , rent_mng_id);
				pp_pstmt.setString(2 , old_rent_l_cd);
				pp_pstmt.executeUpdate();

				fine_pstmt = conn.prepareStatement(fine_qry);
				fine_pstmt.setString(1 , rent_mng_id);
				fine_pstmt.setString(2 , old_rent_l_cd);
				fine_pstmt.executeUpdate();

/*				serv_pstmt = conn.prepareStatement(serv_qry);
				serv_pstmt.setString(1 , rent_mng_id);
				serv_pstmt.setString(2 , old_rent_l_cd);
				serv_pstmt.executeUpdate();
				
				serv1_pstmt = conn.prepareStatement(serv1_qry);
				serv1_pstmt.setString(1 , rent_mng_id);
				serv1_pstmt.setString(2 , old_rent_l_cd);
				serv1_pstmt.executeUpdate();
*/		
				if ( dly_value.equals("")) {
					dly_value = "0";
				}						  
			    
			        dly= cls.getDly_amt() - Integer.parseInt(dly_value);
				
				if ( dly > 0) {				
									
					dly_pstmt = conn.prepareStatement(dly_seq);
					dly_pstmt.setString(1 , rent_mng_id);
					dly_pstmt.setString(2 , old_rent_l_cd);
					rs = dly_pstmt.executeQuery();
					if(rs.next()){
						seq = rs.getString(1);
					}
	
					dly_pstmt = conn.prepareStatement(dly_qry);
					dly_pstmt.setString(1, rent_mng_id);
					dly_pstmt.setString(2, old_rent_l_cd);
					dly_pstmt.setString(3, seq);
					dly_pstmt.setString(4, cls.getCls_dt());
					dly_pstmt.setInt   (5, dly);
			//		dly_pstmt.setInt   (5, cls.getDly_amt());
					dly_pstmt.setString(6, cls.getReg_id());
					dly_pstmt.setString(7, "해지정산");
					dly_pstmt.executeUpdate();
				}	
			}
										
			conn.commit();
				
			//예비용으로 전환한다. - 중복체크
			// car_st = '2' . use_yn = 'Y' 가 있으면 insert 안함.
			
			cid_pstmt = conn.prepareStatement(cid_qry);
			cid_pstmt.setString(1 , rent_mng_id);
			cid_pstmt.setString(2 , old_rent_l_cd);
			rs1 = cid_pstmt.executeQuery();
			if(rs1.next()){
					car_mng_id = rs1.getString(1);
			//		System.out.println(car_mng_id);
			}
			
			if(!car_mng_id.equals("X")){
			         			 
			       cid_cnt_pstmt = conn.prepareStatement(cid_cnt_qry);
			       cid_cnt_pstmt.setString(1 , car_mng_id);
			 
			       rs2 = cid_cnt_pstmt.executeQuery();
			       if(rs2.next()){
						cid_cnt = rs2.getInt(1);
				//		System.out.println("cid_cnt=" + cid_cnt);
			        }
			        
			        if ( cid_cnt < 1) {
			        		
					if(!AddContDatabase.getInstance().insertReContEtcRows2(rent_mng_id, old_rent_l_cd, new_rent_l_cd, cls_dt))	flag += 1;		
				}	

			}
			
			//출고후대차일때 처리
/*			if(!car_no.equals("")){
				//연체대여료중 면제분 삭제
				if(!dly_count.equals("")){//대손처리로 넘김
					StringTokenizer tokenizer = new StringTokenizer(dly_value, ",");
					String dly = "";
					int i = 0;
					String fee_add_qry = "delete scd_fee where rent_mng_id=? and rent_l_cd = ? and rc_yn='0' and dly_days!='0' "+
										" and rent_st=? and fee_tm=? and tm_st1=? ";
					while(tokenizer.hasMoreTokens()){
						dly = tokenizer.nextToken();	
						fee_add_pstmt = conn.prepareStatement(fee_add_qry);
						fee_add_pstmt.setString(1 , rent_mng_id);
						fee_add_pstmt.setString(2 , old_rent_l_cd);
						fee_add_pstmt.setString(3 , dly.substring(0,1));
						if(dly.length() == 3){
							fee_add_pstmt.setString(4 , dly.substring(1,2));
							fee_add_pstmt.setString(5 , dly.substring(2,3));
						}else{
							fee_add_pstmt.setString(4 , dly.substring(1,3));
							fee_add_pstmt.setString(5 , dly.substring(3,4));
						}
						fee_add_pstmt.executeUpdate();		
					}
				}			
			}				
*/
/* nullpoint exception
			rs.close();           
			rs1.close();          
			rs2.close();          
			cls_pstmt.close();    
			cont_pstmt.close();   
			fee_pstmt.close();    
			pp_pstmt.close();     
			fine_pstmt.close();   
			serv_pstmt.close();   
			serv1_pstmt.close();  
			dly_pstmt.close();    
			fee_add_pstmt.close();
			cid_pstmt.close();    
			cid_cnt_pstmt.close();
*/


		} catch (Exception e) {
			System.out.println("[AddClsDatabase:closeContRecon]\n"+e);			
			e.printStackTrace();
	  		flag += 1;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
                		   if(rs != null)				rs.close();
                       	   if(rs1 != null)				rs1.close();
                           if(rs2 != null)				rs2.close();
				           if(cls_pstmt != null)		cls_pstmt.close();
		                   if(cont_pstmt != null)		cont_pstmt.close();
		                   if(fee_pstmt != null)		fee_pstmt.close();
		                   if(pp_pstmt != null)			pp_pstmt.close();
		                   if(fine_pstmt != null)		fine_pstmt.close();
		                   if(serv_pstmt != null)		serv_pstmt.close();
		                   if(serv1_pstmt != null)		serv1_pstmt.close();
		                   if(dly_pstmt != null)		dly_pstmt.close();
		                   if(fee_add_pstmt != null)	fee_add_pstmt.close();
		                   if(cid_pstmt != null)		cid_pstmt.close();
                 		   if(cid_cnt_pstmt != null)	cid_cnt_pstmt.close();

			}catch(Exception ignore){}
			closeConnection();
			if(flag == 0)	return true;
			else			return false;
		}		
	}
	
	
	
	
	
	/**
	 *	재계약있는경우	(재계약 등록후 처리 4:출고후 차종변경 5:계약이관  )
	 *	1:해지테이블에 처리구분 flag 변경, 
	 *	2:계약기초테이블 flag 변경, 
	 *	3: 선납금 스케줄은.. 출고후까지 미납된 선납금 내역은 없다고 전제함. 따라서 선납금스케줄은 무관..
	 */	
	public boolean closeContReconAfterDlv(String rent_mng_id, String rent_l_cd, String cls_st, String cls_dt)
	{
		String new_rent_l_cd = getNextRent_l_cd(rent_l_cd.substring(0, 7)+"S");		//신규계약코드

		boolean flag = true;
		getConnection();
		PreparedStatement cls_pstmt = null;
		PreparedStatement cont_pstmt = null;
		String cls_qry = "update cls_cont set term_yn = 'Y' where rent_mng_id=? and rent_l_cd = ?";
		String cont_qry = "update cont set use_yn = 'N' where rent_mng_id=? and rent_l_cd = ?";

		try {
			conn.setAutoCommit(false);
			
			cls_pstmt = conn.prepareStatement(cls_qry);
			cls_pstmt.setString(1 , rent_mng_id);
			cls_pstmt.setString(2 , rent_l_cd);
			cls_pstmt.executeUpdate();
			cls_pstmt.close();

			cont_pstmt = conn.prepareStatement(cont_qry);
			cont_pstmt.setString(1 , rent_mng_id);
			cont_pstmt.setString(2 , rent_l_cd);
			cont_pstmt.executeUpdate();
			cont_pstmt.close();

			conn.commit();
				
			//예비용으로 전환한다. :차종변경이 되면 변경전 차는 보유차로 등록
			if(   cls_st.equals("4")  && !cls_dt.equals("")){
				if(!AddContDatabase.getInstance().insertReContEtcRows2(rent_mng_id, rent_l_cd, new_rent_l_cd, cls_dt))	flag = false;			
			}
			
	  	} catch (Exception e) {
			System.out.println("[AddClsDatabase:closeContReconAfterDlv]\n"+e);			
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(cls_pstmt != null)	cls_pstmt.close();
                if(cont_pstmt != null)	cont_pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}		
	}		
	
	/**
	 *	계약중도해지처리 -- 5. 영업소변경 : 사용안함 . 5:계약승계로 사용 - 해당 method 호출하지 않음. 승계처리하는 페이지에서 계약생성함. 
	 *	1:해지테이블에 처리구분 flag 변경, 
	 *	2:계약기초테이블 flag 변경, 
	 *	3:새 계약코드와 기존 내용으로 계약 base insert.
	 *	4: 대여료 스케줄 중 미납(예정) 스케줄 update(old 스케줄중 납부되거나 연체된 스케줄 + new 스케줄)
	 */	
	public boolean closeContReconBrch(String rent_mng_id, String old_rent_l_cd)
	{
		String new_brch_id = getNewBrchId(rent_mng_id, old_rent_l_cd);							//신규영업소코드
		String new_rent_l_cd = getNextRent_l_cd(new_brch_id+old_rent_l_cd.substring(2, 8));		//신규계약코드
		
		getConnection();
		int flag = 0;
		PreparedStatement cls_pstmt = null;
		PreparedStatement cont_pstmt = null;
		String cls_qry = "update cls_cont set term_yn = 'Y' where rent_mng_id=? and rent_l_cd= ?";
		String cont_qry = "update cont set use_yn = 'N' where rent_mng_id=? and rent_l_cd= ?";
		
		try {
			
			conn.setAutoCommit(false);
			
			cls_pstmt = conn.prepareStatement(cls_qry);
			cls_pstmt.setString(1, rent_mng_id);
			cls_pstmt.setString(2, old_rent_l_cd);
			cls_pstmt.executeUpdate();
			cls_pstmt.close();

			cont_pstmt = conn.prepareStatement(cont_qry);
			cont_pstmt.setString(1, rent_mng_id);
			cont_pstmt.setString(2, old_rent_l_cd);
			cont_pstmt.executeUpdate();
			cont_pstmt.close();
			
			conn.commit();
				
			if(!AddContDatabase.getInstance().insertReContEtcRows(rent_mng_id, old_rent_l_cd, new_rent_l_cd)) 	flag += 1;
			
			if(!AddFeeDatabase.getInstance().updateReconFeeScd(rent_mng_id, old_rent_l_cd, new_rent_l_cd))		flag += 1;

			//영업소코드수정
			if(!updateReconBrchId(rent_mng_id, new_rent_l_cd, new_brch_id))		flag += 1;

				
	  	} catch (Exception e) {
			System.out.println("[AddClsDatabase:closeContReconBrch]\n"+e);			
			e.printStackTrace();
	  		flag += 1;
	  		conn.rollback();
	  			
		} finally {
			try{
				conn.setAutoCommit(true);
				if(cls_pstmt != null)	cls_pstmt.close();
                if(cont_pstmt != null)	cont_pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			if(flag == 0)	return true;
			else			return false;
		}		
	}
	
	//cls_st:15 차량말소 - 차량만 말소 처리 
	public boolean closeContCarReg(String rent_mng_id, String rent_l_cd, String car_no, String cls_dt)
	{
		String new_rent_l_cd = getNextRent_l_cd(rent_l_cd.substring(0, 7)+"S");		//신규계약코드

		boolean flag = true;
		getConnection();

		PreparedStatement cid_pstmt = null;
		PreparedStatement car_pstmt = null;
		PreparedStatement cls_pstmt = null;
		PreparedStatement cont_pstmt = null;
	
		
		ResultSet rs = null;  
		ResultSet rs1 = null;
		
		String car_mng_id = "";
		String conts = cls_dt + " - 차량말소처리 ";  
				 
		String  cid_qry = " select  nvl(car_mng_id, 'X' )  from cont where  rent_mng_id=? and rent_l_cd=? ";
		String car_qry = "update car_reg set prepare= '4' , park_cont = ?   where car_mng_id = ? ";
		String cls_qry = "update cls_cont set term_yn = 'Y' where rent_mng_id=? and rent_l_cd= ?";
		String cont_qry = "update cont set use_yn = 'N' where rent_mng_id=? and rent_l_cd= ?";

		try {
			
			conn.setAutoCommit(false);
			
			cid_pstmt = conn.prepareStatement(cid_qry);
			cid_pstmt.setString(1 , rent_mng_id);
			cid_pstmt.setString(2 , rent_l_cd);
			rs1 = cid_pstmt.executeQuery();
			if(rs1.next()){
					car_mng_id = rs1.getString(1);			
			}
			
			if(!car_mng_id.equals("X")){			         			 
			      	car_pstmt = conn.prepareStatement(car_qry);
			     	car_pstmt.setString(1, conts);			
					car_pstmt.setString(2, car_mng_id);				
					car_pstmt.executeUpdate();
					car_pstmt.close();	
			}
					
			cls_pstmt = conn.prepareStatement(cls_qry);
			cls_pstmt.setString(1 , rent_mng_id);
			cls_pstmt.setString(2 , rent_l_cd);
			cls_pstmt.executeUpdate();
			cls_pstmt.close();

			cont_pstmt = conn.prepareStatement(cont_qry);
			cont_pstmt.setString(1 , rent_mng_id);
			cont_pstmt.setString(2 , rent_l_cd);
			cont_pstmt.executeUpdate();
			cont_pstmt.close();
									
			conn.commit();
			
		//	if(!AddContDatabase.getInstance().insertReContEtcRows(rent_mng_id, rent_l_cd, new_rent_l_cd))	flag = false;			
			if(!AddContDatabase.getInstance().insertReContEtcRows2(rent_mng_id, rent_l_cd, new_rent_l_cd, cls_dt))	flag = false;			
						
	  	} catch (Exception e) {
			System.out.println("[AddClsDatabase:closeContCarReg]\n"+e);			
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
			   if(rs1 != null)				rs1.close();
				if(cid_pstmt != null)		cid_pstmt.close();
              if(car_pstmt != null)	car_pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}		
	}		
	
	public String getNextRent_l_cd(String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String rtnStr = "";
		String query = "";
		query = "select '"+rent_l_cd.substring(0, 8)+"'|| nvl(ltrim(to_char(to_number(substr(max(rent_l_cd), 9, 13)+1), '00000')), '00001') ID "+
				" from cont "+
				" where rent_l_cd like '%"+rent_l_cd.substring(0, 7)+"%'";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			while(rs.next())
			{
				rtnStr = rs.getString(1)==null?"":rs.getString(1);
			}
			
			rs.close();    
			pstmt.close(); 

		} catch (SQLException e) {
			System.out.println("[AddClsDatabase:getNextRent_l_cd]\n"+e);			
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return rtnStr;
		}
	}	
	
	public String getNewBrchId(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String rtnStr = "";
		String query = " select rtrim(new_brch_cd) from cls_cont where rent_mng_id='"+rent_mng_id+"' and rent_l_cd='"+rent_l_cd+"'";
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			while(rs.next())
			{
				rtnStr = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();    
			pstmt.close(); 

		} catch (SQLException e) {
			System.out.println("[AddClsDatabase:getNewBrchId]\n"+e);			
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return rtnStr;
		}
	}

	public boolean updateReconBrchId(String rent_mng_id, String rent_l_cd, String brch_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;

		String query = " update cont set brch_id=? where rent_mng_id=? and rent_l_cd=?";
		try {
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, brch_id);
			pstmt.setString(2, rent_mng_id);
			pstmt.setString(3, rent_l_cd);
			pstmt.executeUpdate();
			pstmt.close();
			
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[AddClsDatabase:updateReconBrchId]\n"+e);			
	  		e.printStackTrace();
			conn.rollback();
			flag = false;
		} finally {
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//할부금 중도해지----------------------------------------------------------------------------------------

	/**
	 *	할부금 중도 해지 insert
	 */
	public boolean insertClsAllot(ClsAllotBean cls)
	{
		getConnection();
		boolean flag = true;
		String query = "insert into cls_allot ("+
							" RENT_MNG_ID,	RENT_L_CD,	CAR_MNG_ID,	CLS_RTN_DT,	NALT_REST, "+
							" CLS_RTN_INT,	MAX_PAY_DT,	CLS_RTN_FEE,CLS_RTN_INT_AMT,DLY_ALT, "+
						 	" BE_ALT,		CLS_RTN_AMT,BK_CODE,	ACNT_NO,	ACNT_USER, "+
							" CLS_RTN_CAU,	CLS_RTN_FEE_INT, REG_ID,REG_DT, NALT_REST_1, NALT_REST_2, cls_etc_fee"+
					 	" ) values("+
						 	" ?, ?, ?, replace(?, '-', ''), ?,"+
							" ?, replace(?, '-', ''), ?, ?, ?, "+
						 	" ?, ?, ?, ?, ?, "+
							" ?, ?, ?, replace(?, '-', ''), ?, ?, ? "+
					 	" )";
		
		PreparedStatement pstmt = null;
		PreparedStatement pstmt3 = null;
		ResultSet rs2 = null;

		//입력체크
		String query2 = "select count(0) from cls_allot where RENT_MNG_ID=? and RENT_L_CD=?";
		int chk = 0;

		try 
		{
			conn.setAutoCommit(false);

			pstmt3 = conn.prepareStatement(query2);
			pstmt3.setString(1, cls.getRent_mng_id());
			pstmt3.setString(2, cls.getRent_l_cd());
	    	rs2 = pstmt3.executeQuery();
			if(rs2.next()){
				chk = rs2.getInt(1);	
			}

			if(chk==0){

				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, cls.getRent_mng_id());
				pstmt.setString(2, cls.getRent_l_cd());
				pstmt.setString(3, cls.getCar_mng_id());
				pstmt.setString(4, cls.getCls_rtn_dt());
				pstmt.setInt   (5, cls.getNalt_rest());
				pstmt.setString(6, cls.getCls_rtn_int());
				pstmt.setString(7, cls.getMax_pay_dt());
				pstmt.setInt   (8, cls.getCls_rtn_fee());
				pstmt.setInt   (9, cls.getCls_rtn_int_amt());
				pstmt.setInt   (10, cls.getDly_alt());
				pstmt.setInt   (11, cls.getBe_alt());
				pstmt.setInt   (12, cls.getCls_rtn_amt());
				pstmt.setString(13, cls.getBk_code());
				pstmt.setString(14, cls.getAcnt_no());
				pstmt.setString(15, cls.getAcnt_user());
				pstmt.setString(16, cls.getCls_rtn_cau());
				pstmt.setString(17, cls.getCls_rtn_fee_int());
				pstmt.setString(18, cls.getReg_id());
				pstmt.setString(19, cls.getReg_dt());
				pstmt.setInt   (20, cls.getNalt_rest_1());
				pstmt.setInt   (21, cls.getNalt_rest_2());
				pstmt.setInt   (22, cls.getCls_etc_fee());
				pstmt.executeUpdate();
			}

			rs2.close();    
			pstmt3.close(); 
			pstmt.close();  

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddClsDatabase:insertClsAllot]\n"+e);			
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(rs2 != null)	    rs2.close();
				if(pstmt3 != null)	pstmt3.close();
				if(pstmt != null)	pstmt.close();
				
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}

	/**
	 *	할부금 중도해지시 처리
	 *	1:할부스케줄 삭제
	 */	
	public boolean closeAllot(ClsAllotBean cls)
	{
		getConnection();
		int flag = 0;
		PreparedStatement allot_pstmt1 = null;
		PreparedStatement allot_pstmt2 = null;
		PreparedStatement allot_pstmt3 = null;
		ResultSet rs = null;
		String alt_tm = "";

		String allot_qry1 = " delete scd_alt_case where car_mng_id='"+cls.getCar_mng_id()+"' and pay_yn='0'";
		
		String allot_qry2 = " select max(to_number(alt_tm))+1 from scd_alt_case where car_mng_id='"+cls.getCar_mng_id()+"'";

		String allot_qry3 = " insert into scd_alt_case"+
							" (car_mng_id, alt_tm, alt_est_dt, alt_prn, alt_int, pay_yn, cls_rtn_dt, r_alt_est_dt, alt_rest)"+
							" values"+
							" (?, ?, replace(?, '-', ''), ?, ?, ?, replace(?, '-', ''), replace(?, '-', ''), ?)";

		try {

			conn.setAutoCommit(false);

			allot_pstmt1 = conn.prepareStatement(allot_qry1);
			allot_pstmt1.executeUpdate();

			allot_pstmt2 = conn.prepareStatement(allot_qry2);
	    	rs = allot_pstmt2.executeQuery();
			if(rs.next()){
				alt_tm = rs.getString(1);
			}

			allot_pstmt3 = conn.prepareStatement(allot_qry3);
            allot_pstmt3.setString(1, cls.getCar_mng_id());
            allot_pstmt3.setString(2, alt_tm);
            allot_pstmt3.setString(3, cls.getCls_rtn_dt());
            allot_pstmt3.setInt   (4, cls.getNalt_rest());
            allot_pstmt3.setInt   (5, cls.getCls_rtn_fee()+cls.getCls_rtn_int_amt()+cls.getCls_etc_fee());
            allot_pstmt3.setString(6, "0");
            allot_pstmt3.setString(7, cls.getCls_rtn_dt());
            allot_pstmt3.setString(8, cls.getCls_rtn_dt());
            allot_pstmt3.setInt   (9, 0);
			allot_pstmt3.executeUpdate();

			rs.close();          
			allot_pstmt1.close();
			allot_pstmt2.close();
			allot_pstmt3.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[AddClsDatabase:closeAllot]\n"+e);			
			e.printStackTrace();
	  		flag += 1;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
                if(rs != null )		        rs.close();
				if(allot_pstmt1 != null)	allot_pstmt1.close();
				if(allot_pstmt2 != null)	allot_pstmt2.close();
				if(allot_pstmt3 != null)	allot_pstmt3.close();
			}catch(Exception ignore){}
			closeConnection();
			if(flag == 0)	return true;
			else			return false;
		}		
	}

	/**
	 *	할부금 중도 해지 select
	 */
	public ClsAllotBean getClsAllot(String m_id, String l_cd)
	{
		getConnection();
		ClsAllotBean cls = new ClsAllotBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		query = " select "+
				"        nalt_rest, cls_rtn_int, cls_rtn_fee, cls_rtn_int_amt, dly_alt, be_alt,"+
				"        cls_rtn_amt, bk_code, acnt_no, acnt_user, cls_rtn_cau, cls_rtn_fee_int, nalt_rest_1, nalt_rest_2, nvl(cls_etc_fee,0) cls_etc_fee, "+
				"        decode(cls_rtn_dt, '', '', substr(cls_rtn_dt, 1, 4) || '-' || substr(cls_rtn_dt, 5, 2) || '-'||substr(cls_rtn_dt, 7, 2)) cls_rtn_dt,"+
				"        decode(max_pay_dt, '', '', substr(max_pay_dt, 1, 4) || '-' || substr(max_pay_dt, 5, 2) || '-'||substr(max_pay_dt, 7, 2)) max_pay_dt"+
				" from   cls_allot"+
				" where  RENT_MNG_ID = ? and RENT_L_CD = ?";
						
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, m_id);
			pstmt.setString(2, l_cd);
			rs = pstmt.executeQuery();
			if(rs.next())
			{
				cls.setNalt_rest		(rs.getInt("nalt_rest"));	
				cls.setCls_rtn_int		(rs.getString("cls_rtn_int")==null?"":rs.getString("cls_rtn_int"));	
				cls.setCls_rtn_fee		(rs.getInt("cls_rtn_fee"));	
				cls.setCls_rtn_int_amt	(rs.getInt("cls_rtn_int_amt"));	
				cls.setDly_alt			(rs.getInt("dly_alt"));	
				cls.setBe_alt			(rs.getInt("be_alt"));
				cls.setCls_rtn_amt		(rs.getInt("cls_rtn_amt"));
				cls.setBk_code			(rs.getString("bk_code")==null?"":rs.getString("bk_code"));	
				cls.setAcnt_no			(rs.getString("acnt_no")==null?"":rs.getString("acnt_no"));	
				cls.setAcnt_user		(rs.getString("acnt_user")==null?"":rs.getString("acnt_user"));	
				cls.setCls_rtn_cau		(rs.getString("cls_rtn_cau")==null?"":rs.getString("cls_rtn_cau"));	
				cls.setCls_rtn_fee_int	(rs.getString("cls_rtn_fee_int")==null?"":rs.getString("cls_rtn_fee_int"));	
				cls.setCls_rtn_dt		(rs.getString("cls_rtn_dt")==null?"":rs.getString("cls_rtn_dt"));	
				cls.setMax_pay_dt		(rs.getString("max_pay_dt")==null?"":rs.getString("max_pay_dt"));	
				cls.setNalt_rest		(rs.getInt("nalt_rest_1"));	
				cls.setNalt_rest		(rs.getInt("nalt_rest_2"));	
				cls.setCls_etc_fee		(rs.getInt("cls_etc_fee"));
			}
			rs.close();   
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AddClsDatabase:getClsAllot]\n"+e);			
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

	/**
	 *	할부금 중도 해지 update
	 */
	public boolean updateClsAllot(ClsAllotBean cls)
	{
		getConnection();
		boolean flag = true;
		String query = "update cls_allot set"+
						" CLS_RTN_DT=replace(?, '-', ''), NALT_REST=?, CLS_RTN_INT=?,"+
						" MAX_PAY_DT=replace(?, '-', ''), CLS_RTN_FEE=?, CLS_RTN_INT_AMT=?,"+
						" DLY_ALT=?, BE_ALT=?, CLS_RTN_AMT=?,"+
						" BK_CODE=?, ACNT_NO=?,	ACNT_USER=?,"+
						" CLS_RTN_CAU=?, CLS_RTN_FEE_INT=?, NALT_REST_1=?, NALT_REST_2=?, CLS_ETC_FEE=?"+//15
					 	" where rent_mng_id=? and rent_l_cd=?";
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, cls.getCls_rtn_dt());
			pstmt.setInt(2, cls.getNalt_rest());
			pstmt.setString(3, cls.getCls_rtn_int());
			pstmt.setString(4, cls.getMax_pay_dt());
			pstmt.setInt(5, cls.getCls_rtn_fee());
			pstmt.setInt(6, cls.getCls_rtn_int_amt());
			pstmt.setInt(7, cls.getDly_alt());
			pstmt.setInt(8, cls.getBe_alt());
			pstmt.setInt(9, cls.getCls_rtn_amt());
			pstmt.setString(10, cls.getBk_code());
			pstmt.setString(11, cls.getAcnt_no());
			pstmt.setString(12, cls.getAcnt_user());
			pstmt.setString(13, cls.getCls_rtn_cau());
			pstmt.setString(14, cls.getCls_rtn_fee_int());
			pstmt.setInt(15, cls.getNalt_rest_1());
			pstmt.setInt(16, cls.getNalt_rest_2());
			pstmt.setInt(17, cls.getCls_etc_fee());
			pstmt.setString(18, cls.getRent_mng_id());
			pstmt.setString(19, cls.getRent_l_cd());

			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddClsDatabase:updateClsAllot]\n"+e);			
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

	/**
	 *	은행대출 중도 해지 insert
	 */
	public boolean insertClsBank(ClsBankBean cls)
	{
		getConnection();
		boolean flag = true;
		String query = "insert into cls_bank ("+
						" LEND_ID,		RTN_SEQ,	CLS_RTN_DT,		NALT_REST,	CLS_RTN_INT,"+
						" MAX_PAY_DT,	CLS_RTN_FEE,CLS_RTN_INT_AMT,DLY_ALT,	BE_ALT,"+
					 	" CLS_RTN_AMT,	BK_CODE,	ACNT_NO,		ACNT_USER,	CLS_RTN_CAU,"+
						" CLS_RTN_FEE_INT, REG_ID,REG_DT, NALT_REST_1, NALT_REST_2, CLS_ETC_FEE) values("+//19
					 	" ?, ?, replace(?, '-', ''), ?,"+
						" ?, replace(?, '-', ''), ?, ?, ?, "+
					 	" ?, ?, ?, ?, ?, "+
						" ?, ?, ?, replace(?, '-', ''), ?, ?, ? )";
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, cls.getLend_id());
			pstmt.setString(2, cls.getRtn_seq());
			pstmt.setString(3, cls.getCls_rtn_dt());
			pstmt.setInt   (4, cls.getNalt_rest());
			pstmt.setString(5, cls.getCls_rtn_int());
			pstmt.setString(6, cls.getMax_pay_dt());
			pstmt.setInt   (7, cls.getCls_rtn_fee());
			pstmt.setInt   (8, cls.getCls_rtn_int_amt());
			pstmt.setInt   (9, cls.getDly_alt());
			pstmt.setInt   (10, cls.getBe_alt());
			pstmt.setInt   (11, cls.getCls_rtn_amt());
			pstmt.setString(12, cls.getBk_code());
			pstmt.setString(13, cls.getAcnt_no());
			pstmt.setString(14, cls.getAcnt_user());
			pstmt.setString(15, cls.getCls_rtn_cau());
			pstmt.setString(16, cls.getCls_rtn_fee_int());
			pstmt.setString(17, cls.getReg_id());
			pstmt.setString(18, cls.getReg_dt());
			pstmt.setInt   (19, cls.getNalt_rest_1());
			pstmt.setInt   (20, cls.getNalt_rest_2());
			pstmt.setInt   (21, cls.getCls_etc_fee());
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddClsDatabase:insertClsBank]\n"+e);			
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

	/**
	 *	은행대출 중도 해지 insert
	 */
	public boolean updateScdBank(ClsBankBean cls, String alt_tm)
	{
		getConnection();
		boolean flag = true;

		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		//String alt_tm = "";

		String query1 = " select min(to_number(alt_tm)) alt_tm from scd_bank "+
						" where lend_id=? and rtn_seq=? and alt_est_dt > replace(?,'-','') ";

		String query2 = " update scd_bank set alt_tm=alt_tm+1"+
						" where lend_id=? and rtn_seq=? and to_number(alt_tm) >= to_number(?)";

		String query3 = " insert into scd_bank ("+
						"	LEND_ID, RTN_SEQ, alt_tm, alt_est_dt, r_alt_est_dt, pay_yn, pay_dt,"+
						"	alt_prn_amt, alt_int_amt, cls_rtn_dt "+
						" ) values("+
					 	"	?, ?, ?, replace(?, '-', ''), replace(?, '-', ''), ?, '',"+
						"	?, ?, replace(?, '-', '') "+
						" )";		

		String query4 = " INSERT INTO SCD_BANK_CLS_B (lend_id, alt_tm, alt_est_dt, alt_prn_amt, alt_int_amt, pay_dt, pay_yn, alt_rest, rtn_seq, r_alt_est_dt, cls_rtn_dt, reg_dt, reg_id) "+
				                             " SELECT lend_id, alt_tm, alt_est_dt, alt_prn_amt, alt_int_amt, pay_dt, pay_yn, alt_rest, rtn_seq, r_alt_est_dt, replace(?, '-', ''), sysdate, ? FROM SCD_BANK where lend_id=? and rtn_seq=? and to_number(alt_tm) >= to_number(?) ";


		try 
		{
			conn.setAutoCommit(false);

			pstmt2 = conn.prepareStatement(query1);
			pstmt2.setString(1, cls.getLend_id());
			pstmt2.setString(2, cls.getRtn_seq());
			pstmt2.setString(3, cls.getCls_rtn_dt());
			rs = pstmt2.executeQuery();
			if(rs.next())
			{
				alt_tm = rs.getString("alt_tm")==null?"":rs.getString("alt_tm");	
			}
			rs.close();
			pstmt2.close();

			//System.out.println("은행대출 중도상환1--------");
			//System.out.println(alt_tm);

			if(!alt_tm.equals("")){
				//변경전 스케줄 이력 남긴다.
				pstmt = conn.prepareStatement(query4);
				pstmt.setString(1, cls.getCls_rtn_dt());
				pstmt.setString(2, cls.getReg_id());
				pstmt.setString(3, cls.getLend_id());
				pstmt.setString(4,  cls.getRtn_seq());
				pstmt.setString(5, alt_tm);
				pstmt.executeUpdate();

				//회차를 늘린다.
				pstmt = conn.prepareStatement(query2);
				pstmt.setString(1, cls.getLend_id());
				pstmt.setString(2, cls.getRtn_seq());
				pstmt.setString(3, alt_tm);
				pstmt.executeUpdate();

				//System.out.println("은행대출 중도상환2--------");
				//중도상환분스케줄 생성한다.
				pstmt = conn.prepareStatement(query3);
				pstmt.setString(1, cls.getLend_id());
				pstmt.setString(2, cls.getRtn_seq());
				pstmt.setString(3, alt_tm);
				pstmt.setString(4, cls.getCls_rtn_dt());
				pstmt.setString(5, cls.getCls_rtn_dt());
				pstmt.setString(6, "0");
				pstmt.setInt   (7, cls.getNalt_rest());
				pstmt.setInt   (8, cls.getCls_rtn_amt()-cls.getNalt_rest());
				pstmt.setString(9, cls.getCls_rtn_dt());
				pstmt.executeUpdate();	

				//System.out.println("은행대출 중도상환3--------");
				
				pstmt.close();
			}

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddClsDatabase:updateScdBank]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				if(rs != null)		rs.close();
				if(pstmt != null)	pstmt.close();
				if(pstmt2 != null)	pstmt2.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}

	/**
	 *	할부금 중도해지시 처리
	 *	1:할부스케줄 삭제
	 */	
	public boolean closeBank(String lend_id, String rtn_seq)
	{
		getConnection();
		int flag = 0;
		PreparedStatement pstmt = null;
		String allot_qry = "delete scd_bank where lend_id='"+lend_id+"' and rtn_seq='"+rtn_seq+"' and pay_yn='0'";

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(allot_qry);
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[AddClsDatabase:closeBank]\n"+e);			
			e.printStackTrace();
	  		flag += 1;
			conn.rollback();
		} finally {
			try{
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			if(flag == 0)	return true;
			else			return false;
		}		
	}

	/**
	 *	할부금 중도 해지 select
	 */
	public ClsBankBean getClsBank(String lend_id, String rtn_seq)
	{
		getConnection();
		ClsBankBean cls = new ClsBankBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		query = " select"+
				" nalt_rest, cls_rtn_int, cls_rtn_fee, cls_rtn_int_amt, dly_alt, be_alt, nalt_rest_1, nalt_rest_2, nvl(cls_etc_fee,0) cls_etc_fee, "+
				" cls_rtn_amt, bk_code, acnt_no, acnt_user, cls_rtn_cau, cls_rtn_fee_int,"+
				" decode(cls_rtn_dt, '', '', substr(cls_rtn_dt, 1, 4) || '-' || substr(cls_rtn_dt, 5, 2) || '-'||substr(cls_rtn_dt, 7, 2)) cls_rtn_dt,"+
				" decode(max_pay_dt, '', '', substr(max_pay_dt, 1, 4) || '-' || substr(max_pay_dt, 5, 2) || '-'||substr(max_pay_dt, 7, 2)) max_pay_dt"+
				" from cls_bank"+
				" where lend_id = ? and rtn_seq = ?";
						
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, lend_id);
			pstmt.setString(2, rtn_seq);
			rs = pstmt.executeQuery();
			if(rs.next())
			{
				cls.setNalt_rest(rs.getInt("nalt_rest"));	
				cls.setCls_rtn_int(rs.getString("cls_rtn_int")==null?"":rs.getString("cls_rtn_int"));	
				cls.setCls_rtn_fee(rs.getInt("cls_rtn_fee"));	
				cls.setCls_rtn_int_amt(rs.getInt("cls_rtn_int_amt"));	
				cls.setDly_alt(rs.getInt("dly_alt"));	
				cls.setBe_alt(rs.getInt("be_alt"));
				cls.setCls_rtn_amt(rs.getInt("cls_rtn_amt"));
				cls.setBk_code(rs.getString("bk_code")==null?"":rs.getString("bk_code"));	
				cls.setAcnt_no(rs.getString("acnt_no")==null?"":rs.getString("acnt_no"));	
				cls.setAcnt_user(rs.getString("acnt_user")==null?"":rs.getString("acnt_user"));	
				cls.setCls_rtn_cau(rs.getString("cls_rtn_cau")==null?"":rs.getString("cls_rtn_cau"));	
				cls.setCls_rtn_fee_int(rs.getString("cls_rtn_fee_int")==null?"":rs.getString("cls_rtn_fee_int"));	
				cls.setCls_rtn_dt(rs.getString("cls_rtn_dt")==null?"":rs.getString("cls_rtn_dt"));	
				cls.setMax_pay_dt(rs.getString("max_pay_dt")==null?"":rs.getString("max_pay_dt"));	
				cls.setNalt_rest_1(rs.getInt("nalt_rest_1"));	
				cls.setNalt_rest_2(rs.getInt("nalt_rest_2"));	
				cls.setCls_etc_fee(rs.getInt("cls_etc_fee"));
			}
			rs.close();   
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddClsDatabase:getClsBank]\n"+e);			
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

	/**
	 *	할부금 중도 해지 select
	 */
	public ClsBankBean getClsBankCase(String lend_id, String rtn_seq, String cls_rtn_dt)
	{
		getConnection();
		ClsBankBean cls = new ClsBankBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		query = " select"+
				" nalt_rest, cls_rtn_int, cls_rtn_fee, cls_rtn_int_amt, dly_alt, be_alt, nalt_rest_1, nalt_rest_2, nvl(cls_etc_fee,0) cls_etc_fee, "+
				" cls_rtn_amt, bk_code, acnt_no, acnt_user, cls_rtn_cau, cls_rtn_fee_int,"+
				" decode(cls_rtn_dt, '', '', substr(cls_rtn_dt, 1, 4) || '-' || substr(cls_rtn_dt, 5, 2) || '-'||substr(cls_rtn_dt, 7, 2)) cls_rtn_dt,"+
				" decode(max_pay_dt, '', '', substr(max_pay_dt, 1, 4) || '-' || substr(max_pay_dt, 5, 2) || '-'||substr(max_pay_dt, 7, 2)) max_pay_dt,"+
				" reg_dt, reg_id "+
				" from cls_bank"+
				" where lend_id = ? and rtn_seq = ? and cls_rtn_dt = replace(?, '-', '')";
						
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, lend_id);
			pstmt.setString(2, rtn_seq);
			pstmt.setString(3, cls_rtn_dt);
			rs = pstmt.executeQuery();
			if(rs.next())
			{
				cls.setNalt_rest(rs.getInt("nalt_rest"));	
				cls.setCls_rtn_int(rs.getString("cls_rtn_int")==null?"":rs.getString("cls_rtn_int"));	
				cls.setCls_rtn_fee(rs.getInt("cls_rtn_fee"));	
				cls.setCls_rtn_int_amt(rs.getInt("cls_rtn_int_amt"));	
				cls.setDly_alt(rs.getInt("dly_alt"));	
				cls.setBe_alt(rs.getInt("be_alt"));
				cls.setCls_rtn_amt(rs.getInt("cls_rtn_amt"));
				cls.setBk_code(rs.getString("bk_code")==null?"":rs.getString("bk_code"));	
				cls.setAcnt_no(rs.getString("acnt_no")==null?"":rs.getString("acnt_no"));	
				cls.setAcnt_user(rs.getString("acnt_user")==null?"":rs.getString("acnt_user"));	
				cls.setCls_rtn_cau(rs.getString("cls_rtn_cau")==null?"":rs.getString("cls_rtn_cau"));	
				cls.setCls_rtn_fee_int(rs.getString("cls_rtn_fee_int")==null?"":rs.getString("cls_rtn_fee_int"));	
				cls.setCls_rtn_dt(rs.getString("cls_rtn_dt")==null?"":rs.getString("cls_rtn_dt"));	
				cls.setMax_pay_dt(rs.getString("max_pay_dt")==null?"":rs.getString("max_pay_dt"));	
				cls.setNalt_rest_1(rs.getInt("nalt_rest_1"));	
				cls.setNalt_rest_2(rs.getInt("nalt_rest_2"));	
				cls.setReg_dt(rs.getString("reg_dt")==null?"":rs.getString("reg_dt"));	
				cls.setReg_id(rs.getString("reg_id")==null?"":rs.getString("reg_id"));	
				cls.setCls_etc_fee(rs.getInt("cls_etc_fee"));

			}
			rs.close();   
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddClsDatabase:getClsBankCase]\n"+e);			
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


	/**
	 *	할부금 중도 해지 update
	 */
	public boolean updateClsBank(ClsBankBean cls)
	{
		getConnection();
		boolean flag = true;
		String query = "update cls_bank set"+
						" CLS_RTN_DT=replace(?, '-', ''), NALT_REST=?, CLS_RTN_INT=?,"+
						" MAX_PAY_DT=replace(?, '-', ''), CLS_RTN_FEE=?, CLS_RTN_INT_AMT=?,"+
						" DLY_ALT=?, BE_ALT=?, CLS_RTN_AMT=?,"+
						" BK_CODE=?, ACNT_NO=?,	ACNT_USER=?,"+
						" CLS_RTN_CAU=?, CLS_RTN_FEE_INT=?, NALT_REST_1=?, NALT_REST_2=?, CLS_ETC_FEE=?"+//15
					 	" where lend_id=? and rtn_seq=? and CLS_RTN_DT=replace(?, '-', '')";
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, cls.getCls_rtn_dt());
			pstmt.setInt(2, cls.getNalt_rest());
			pstmt.setString(3, cls.getCls_rtn_int());
			pstmt.setString(4, cls.getMax_pay_dt());
			pstmt.setInt(5, cls.getCls_rtn_fee());
			pstmt.setInt(6, cls.getCls_rtn_int_amt());
			pstmt.setInt(7, cls.getDly_alt());
			pstmt.setInt(8, cls.getBe_alt());
			pstmt.setInt(9, cls.getCls_rtn_amt());
			pstmt.setString(10, cls.getBk_code());
			pstmt.setString(11, cls.getAcnt_no());
			pstmt.setString(12, cls.getAcnt_user());
			pstmt.setString(13, cls.getCls_rtn_cau());
			pstmt.setString(14, cls.getCls_rtn_fee_int());
			pstmt.setInt(15, cls.getNalt_rest_1());
			pstmt.setInt(16, cls.getNalt_rest_2());
			pstmt.setInt(17, cls.getCls_etc_fee());
			pstmt.setString(18, cls.getLend_id());
			pstmt.setString(19, cls.getRtn_seq());
			pstmt.setString(20, cls.getCls_rtn_dt());

			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddClsDatabase:updateClsBank]\n"+e);			
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


	/*-------------------------------------------------------------------------------------------------------*/	

	/*재무회계 ----------------------------------------------------------------------------------------------*/
	
	/*-------------------------------------------------------------------------------------------------------*/	


	// 조회 -------------------------------------------------------------------------------------------------

	// 중도해지위약금 리스트 조회
	public Vector getClsScdList(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query =		" select /*+  merge(b) */ \n"+
					" a.rent_mng_id, a.rent_l_cd, b.car_mng_id, b.firm_nm, b.client_nm, b.client_id,\n"+
					" c.car_no, c.car_nm, decode(a.ext_dt, '','미수금','수금') gubun, (a.ext_s_amt+a.ext_v_amt) as cls_amt,"+
					" a.ext_tm, a.dly_amt, a.dly_days, b.bus_id2, b.rent_st,\n"+
					" nvl2(d.cls_dt,substr(d.cls_dt,1,4)||'-'||substr(d.cls_dt,5,2)||'-'||substr(d.cls_dt,7,2),'') cls_dt,\n"+
					" nvl2(a.ext_est_dt,substr(a.ext_est_dt,1,4)||'-'||substr(a.ext_est_dt,5,2)||'-'||substr(a.ext_est_dt,7,2),'') cls_est_dt,\n"+
					" nvl2(a.pay_dt,substr(a.pay_dt,1,4)||'-'||substr(a.pay_dt,5,2)||'-'||substr(a.pay_dt,7,2),'') pay_dt\n"+
					" from scd_ext a, cont_n_view b, cls_cont d , car_reg c \n"+
					" where\n"+
					" a.ext_st = '4' "+
					" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd\n"+
					" and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd\n"+
					" and  b.car_mng_id = c.car_mng_id \n"+
					" and a.ext_s_amt != 0 and nvl(d.no_dft_yn,'N') <> 'Y' and  ";//d.cls_dt > '20030531'


		/*상세조회&&세부조회*/

		//당월-계획
		if(gubun2.equals("1") && gubun3.equals("1")){		query += " and a.ext_est_dt like to_char(sysdate,'YYYYMM')||'%' ";
		//당월-수금
		}else if(gubun2.equals("1") && gubun3.equals("2")){	query += " and a.ext_est_dt like to_char(sysdate,'YYYYMM')||'%'  and a.pay_dt is not null";
		//당월-미수금
		}else if(gubun2.equals("1") && gubun3.equals("3")){	query += " and a.ext_est_dt like to_char(sysdate,'YYYYMM')||'%'  and a.pay_dt is null";
		//당일-계획
		}else if(gubun2.equals("2") && gubun3.equals("1")){	query += " and a.ext_est_dt = to_char(sysdate,'YYYYMMDD')";
		//당일-수금
		}else if(gubun2.equals("2") && gubun3.equals("2")){	query += " and a.ext_est_dt = to_char(sysdate,'YYYYMMDD') and a.pay_dt = to_char(sysdate,'YYYYMMDD')";
		//당일-미수금
		}else if(gubun2.equals("2") && gubun3.equals("3")){	query += " and a.ext_est_dt = to_char(sysdate,'YYYYMMDD') and a.pay_dt is null";
		//연체-계획
		}else if(gubun2.equals("3") && gubun3.equals("1")){	query += " and a.ext_est_dt < to_char(sysdate,'YYYYMMDD') and (a.pay_dt is null or a.pay_dt = to_char(sysdate,'YYYYMMDD'))";
		//연체-수금
		}else if(gubun2.equals("3") && gubun3.equals("2")){	query += " and a.ext_est_dt < to_char(sysdate,'YYYYMMDD') and a.pay_dt = to_char(sysdate,'YYYYMMDD')";
		//연체-미수금
		}else if(gubun2.equals("3") && gubun3.equals("3")){	query += " and a.ext_est_dt < to_char(sysdate,'YYYYMMDD') and a.pay_dt is null";
		//기간-계획
		}else if(gubun2.equals("4") && gubun3.equals("1")){	query += " and a.ext_est_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		//기간-수금
		}else if(gubun2.equals("4") && gubun3.equals("2")){	query += " and a.ext_est_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.pay_dt not null";
		//기간-미수금
		}else if(gubun2.equals("4") && gubun3.equals("3")){	query += " and a.ext_est_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.pay_dt is null";
		//당일+연체-계획
		}else if(gubun2.equals("6") && gubun3.equals("1")){	query += " and a.ext_est_dt <= to_char(sysdate,'YYYYMMDD') and (a.pay_dt is null or a.pay_dt = to_char(sysdate,'YYYYMMDD'))";
		//당일+연체-수금
		}else if(gubun2.equals("6") && gubun3.equals("2")){	query += " and a.ext_est_dt <= to_char(sysdate,'YYYYMMDD') and a.pay_dt = to_char(sysdate,'YYYYMMDD')";
		//당일+연체-미수금
		}else if(gubun2.equals("6") && gubun3.equals("3")){	query += " and a.ext_est_dt <= to_char(sysdate,'YYYYMMDD') and a.pay_dt is null";
		//검색
		}

		/*연체조회*/

		if(gubun2.equals("3")){
				if(gubun4.equals("2")){	//일반연체	
					query += " and a.dly_days between 1 and 30";
				}else if(gubun4.equals("3")){ //부실연체
					query += " and a.dly_days between 31 and 60";
				}else if(gubun4.equals("4")){ //악성연체
					query += " and a.dly_days between 61 and 1000";
				}else{}
		}

		/*검색조건*/
			
		if(s_kd.equals("2"))		query += " and nvl(b.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(b.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and nvl(c.car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("5"))	query += " and a.ext_est_dt like '"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	query += " and upper(b.brch_id) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("7"))	query += " and nvl(b.r_site, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("8"))	query += " and b.mng_id= '"+t_wd+"'\n";
		else if(s_kd.equals("9"))	query += " and nvl(c.car_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("10"))	query += " and nvl(d.cls_dt, '') like '%"+t_wd+"%'\n";
		else						query += " and nvl(b.firm_nm, '') like '%"+t_wd+"%'\n";			

		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		/*정렬조건*/

		if(sort_gubun.equals("0"))		query += " order by b.use_yn desc, a.cls_est_dt "+sort+", a.pay_dt, b.firm_nm";
		else if(sort_gubun.equals("1"))	query += " order by b.use_yn desc, b.firm_nm "+sort+", a.pay_dt, a.ext_est_dt";
		else if(sort_gubun.equals("2"))	query += " order by b.use_yn desc, a.pay_dt "+sort+", b.firm_nm, a.ext_est_dt";
		else if(sort_gubun.equals("3"))	query += " order by b.use_yn desc, a.ext_s_amt "+sort+", a.pay_dt, b.firm_nm, a.ext_est_dt";
//		else if(sort_gubun.equals("4"))	query += " order by b.use_yn desc, dly_day "+sort+", rc_dt, firm_nm, fee_est_dt";
	
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
			System.out.println("[AddClsDatabase:getClsScdList]\n"+e);
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


	// 중도해지위약금 리스트 조회 + 해지대여료 포함
	public Vector getClsScdList2(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		//정산금
		String query1 = "";

		query1 = " select /*+  merge(b) */ \n"+
					"     '정산금' cls_gubun, a.rent_mng_id, a.rent_l_cd, b.car_mng_id, b.firm_nm, b.client_nm, b.client_id,\n"+
					"     c.car_no, c.car_nm, cn.car_name, decode(a.pay_dt, '','미수금','수금') gubun, a.ext_s_amt as s_amt, (nvl(a.ext_s_amt,0)+nvl(a.ext_v_amt,0)) as amt,"+
					"     a.cls_tm as tm, decode(a.ext_tm,'1','','(잔)') tm_st, a.dly_amt, to_number(a.dly_days) as dly_days, b.bus_id2, b.rent_st, b.r_site, b.mng_id, b.use_yn, \n"+
					"     d.cls_dt cls_dt, a.ext_est_dt est_dt, a.pay_dt pay_dt\n"+
					" from scd_ext a, cont_n_view b, cls_cont d ,  car_reg c,  car_etc g, car_nm cn \n"+
					" where\n"+
					"     a.ext_st = '4' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
					"     and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd"+
					"	and b.car_mng_id = c.car_mng_id  and a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+)  \n"+
                       			"	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+)  \n"+
					"     and a.ext_s_amt is not null and d.cls_doc_yn='Y' and nvl(a.bill_yn,'Y')='Y'";//d.cls_dt > '20030531' 
		//해지대여료
		String query2 = "";
		query2 = " select  /*+  merge(c) */ "+
					"      '대여료' cls_gubun, a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.firm_nm, a.client_nm, '' client_id,"+
					"      cr.car_no, cr.car_nm, cn.car_name, decode(a.rc_yn, '1', '수금','미수금') gubun, a.fee_s_amt as s_amt, a.fee_amt as amt,"+
					"      a.fee_tm as tm, decode(a.tm_st1,'0','','(잔)') tm_st, 0 dly_amt, a.dly_day as dly_days, a.bus_id2, a.rent_st, c.r_site, c.mng_id, c.use_yn,"+
					"      b.cls_dt cls_dt, a.fee_est_dt as est_dt, a.rc_dt as pay_dt"+
					" from fee_view a, cls_cont b, cont_n_view c ,   car_reg cr,  car_etc g, car_nm cn \n"+
					" where \n"+
					"      b.cls_st = '2' and a.use_yn='N' and nvl(a.bill_yn,'Y')='Y'"+
					"      and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd "+
					"      and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd "+
					"	and c.car_mng_id = cr.car_mng_id  and b.rent_mng_id = g.rent_mng_id(+)  and b.rent_l_cd = g.rent_l_cd(+)  \n"+
                       			"	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+) ";
				

		//합체
		String query = " select * from ( \n"+query1+"\n union all \n"+query2+"\n ) where s_amt is not null ";		

	
		/*상세조회&&세부조회*/

		//당월-계획
		if(gubun2.equals("1") && gubun3.equals("1")){		query += " and substr(est_dt,1,7) = to_char(sysdate,'YYYYMM')";
		//당월-수금
		}else if(gubun2.equals("1") && gubun3.equals("2")){	query += " and substr(est_dt,1,7) = to_char(sysdate,'YYYYMM') and pay_dt is not null";
		//당월-미수금
		}else if(gubun2.equals("1") && gubun3.equals("3")){	query += " and substr(est_dt,1,7) = to_char(sysdate,'YYYYMM') and pay_dt is null";
		//당일-계획
		}else if(gubun2.equals("2") && gubun3.equals("1")){	query += " and est_dt = to_char(sysdate,'YYYYMMDD')";
		//당일-수금
		}else if(gubun2.equals("2") && gubun3.equals("2")){	query += " and est_dt = to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD')";
		//당일-미수금
		}else if(gubun2.equals("2") && gubun3.equals("3")){	query += " and est_dt = to_char(sysdate,'YYYYMMDD') and pay_dt is null";
		//연체-계획
		}else if(gubun2.equals("3") && gubun3.equals("1")){	query += " and est_dt < to_char(sysdate,'YYYYMMDD') and (pay_dt is null or pay_dt = to_char(sysdate,'YYYYMMDD'))";
		//연체-수금
		}else if(gubun2.equals("3") && gubun3.equals("2")){	query += " and est_dt < to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD')";
		//연체-미수금
		}else if(gubun2.equals("3") && gubun3.equals("3")){	query += " and est_dt < to_char(sysdate,'YYYYMMDD') and pay_dt is null";
		//기간-계획
		}else if(gubun2.equals("4") && gubun3.equals("1")){	query += " and est_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		//기간-수금
		}else if(gubun2.equals("4") && gubun3.equals("2")){	query += " and est_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and pay_dt is not null";
		//기간-미수금
		}else if(gubun2.equals("4") && gubun3.equals("3")){	query += " and est_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and pay_dt is null";
		//당일+연체-계획
		}else if(gubun2.equals("6") && gubun3.equals("1")){	query += " and est_dt <= to_char(sysdate,'YYYYMMDD') and (pay_dt is null or pay_dt = to_char(sysdate,'YYYYMMDD'))";
		//당일+연체-수금
		}else if(gubun2.equals("6") && gubun3.equals("2")){	query += " and est_dt <= to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD')";
		//당일+연체-미수금
		}else if(gubun2.equals("6") && gubun3.equals("3")){	query += " and est_dt <= to_char(sysdate,'YYYYMMDD') and pay_dt is null";
		//검색-수금
		}else if(gubun2.equals("5") && gubun3.equals("2")){	query += " and pay_dt is not null";
		//검색-미수금
		}else if(gubun2.equals("5") && gubun3.equals("3")){	query += " and pay_dt is null";
		}

		/*연체조회*/
		if(gubun2.equals("3")){
				if(gubun4.equals("2")){	//일반연체	
					query += " and dly_days between 1 and 30";
				}else if(gubun4.equals("3")){ //부실연체
					query += " and dly_days between 31 and 60";
				}else if(gubun4.equals("4")){ //악성연체
					query += " and dly_days between 61 and 1000";
				}else{}
		}

		/*검색조건*/
			
		if(s_kd.equals("2"))		query += " and nvl(client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and nvl(car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("5"))	query += " and est_dt like '"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	query += " and substr(rent_l_cd,1,2) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("7"))	query += " and nvl(r_site, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("8"))	query += " and bus_id2= '"+t_wd+"'\n";
		else if(s_kd.equals("11"))	query += " and mng_id= '"+t_wd+"'\n";
		else if(s_kd.equals("9"))	query += " and car_nm||car_name like '%"+t_wd+"%'\n";
		else if(s_kd.equals("10"))	query += " and nvl(cls_dt, '') like '%"+t_wd+"%'\n";
		else						query += " and nvl(firm_nm, '') like '%"+t_wd+"%'\n";			

		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		/*정렬조건*/

		if(sort_gubun.equals("0"))		query += " order by use_yn desc, est_dt "+sort+", pay_dt, firm_nm";
		else if(sort_gubun.equals("1"))	query += " order by use_yn desc, firm_nm "+sort+", pay_dt, est_dt";
		else if(sort_gubun.equals("2"))	query += " order by use_yn desc, pay_dt "+sort+", firm_nm, est_dt";
		else if(sort_gubun.equals("3"))	query += " order by use_yn desc, amt "+sort+", pay_dt, firm_nm, est_dt";
	
		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
    		ResultSetMetaData rsmd = rs.getMetaData();    	

			int i =0;
			while(rs.next())
			{		
				i++;
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
			System.out.println("[AddClsDatabase:getClsScdList2]\n"+e);
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
	
	// 중도해지위약금 리스트 통계
	public Vector getClsScdStat(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String sub_query = "";
		sub_query = " select /*+  merge(b) */ \n"+
					"        a.rent_mng_id, a.rent_l_cd, b.car_mng_id, nvl(b.firm_nm, b.client_nm) firm_nm, b.client_nm, b.client_id,\n"+
					"        c.car_no, c.car_nm, decode(a.pay_dt, '','미수금','수금') gubun, (a.ext_s_amt+a.ext_v_amt) as cls_amt,"+
					"        a.cls_tm, a.dly_amt, a.dly_days, b.bus_id2, b.rent_st,\n"+
					"        nvl2(d.cls_dt,substr(d.cls_dt,1,4)||'-'||substr(d.cls_dt,5,2)||'-'||substr(d.cls_dt,7,2),'') cls_dt,\n"+
					"        nvl2(a.ext_est_dt,substr(a.ext_est_dt,1,4)||'-'||substr(a.ext_est_dt,5,2)||'-'||substr(a.ext_est_dt,7,2),'') cls_est_dt,\n"+
					"        nvl2(a.pay_dt,substr(a.pay_dt,1,4)||'-'||substr(a.pay_dt,5,2)||'-'||substr(a.pay_dt,7,2),'') pay_dt\n"+
					" from scd_ext a, cont_n_view b, cls_cont d , car_reg c \n"+
					" where\n"+
					"        a.ext_st = '4' and a.ext_s_amt != 0 and nvl(d.no_dft_yn,'N') <> 'Y'"+
					"        and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd\n"+
					"        and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd\n"+
					"        and b.car_mng_id = c.car_mng_id " +
					"         ";

		/*상세조회&&세부조회*/

		//당월-계획
		if(gubun2.equals("1") && gubun3.equals("1")){		sub_query += " and a.ext_est_dt like to_char(sysdate,'YYYYMM')||'%' ";
		//당월-수금
		}else if(gubun2.equals("1") && gubun3.equals("2")){	sub_query += " and a.ext_est_dt like to_char(sysdate,'YYYYMM')||'%'  and a.pay_dt is not null";
		//당월-미수금
		}else if(gubun2.equals("1") && gubun3.equals("3")){	sub_query += " and a.ext_est_dt like to_char(sysdate,'YYYYMM')||'%'  and a.pay_dt is null";
		//당일-계획
		}else if(gubun2.equals("2") && gubun3.equals("1")){	sub_query += " and a.ext_est_dt = to_char(sysdate,'YYYYMMDD')";
		//당일-수금
		}else if(gubun2.equals("2") && gubun3.equals("2")){	sub_query += " and a.ext_est_dt = to_char(sysdate,'YYYYMMDD') and a.pay_dt = to_char(sysdate,'YYYYMMDD')";
		//당일-미수금
		}else if(gubun2.equals("2") && gubun3.equals("3")){	sub_query += " and a.ext_est_dt = to_char(sysdate,'YYYYMMDD') and a.pay_dt is null";
		//연체-계획
		}else if(gubun2.equals("3") && gubun3.equals("1")){	sub_query += " and a.ext_est_dt < to_char(sysdate,'YYYYMMDD') and (a.pay_dt is null or a.pay_dt = to_char(sysdate,'YYYYMMDD'))";
		//연체-수금
		}else if(gubun2.equals("3") && gubun3.equals("2")){	sub_query += " and a.ext_est_dt < to_char(sysdate,'YYYYMMDD') and a.pay_dt = to_char(sysdate,'YYYYMMDD')";
		//연체-미수금
		}else if(gubun2.equals("3") && gubun3.equals("3")){	sub_query += " and a.ext_est_dt < to_char(sysdate,'YYYYMMDD') and a.pay_dt is null";
		//기간-계획
		}else if(gubun2.equals("4") && gubun3.equals("1")){	sub_query += " and a.ext_est_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		//기간-수금
		}else if(gubun2.equals("4") && gubun3.equals("2")){	sub_query += " and a.ext_est_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.pay_dt not null";
		//기간-미수금
		}else if(gubun2.equals("4") && gubun3.equals("3")){	sub_query += " and a.ext_est_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.pay_dt is null";
		//당일+연체-계획
		}else if(gubun2.equals("6") && gubun3.equals("1")){	sub_query += " and a.ext_est_dt <= to_char(sysdate,'YYYYMMDD') and (a.pay_dt is null or a.pay_dt = to_char(sysdate,'YYYYMMDD'))";
		//당일+연체-수금
		}else if(gubun2.equals("6") && gubun3.equals("2")){	sub_query += " and a.ext_est_dt <= to_char(sysdate,'YYYYMMDD') and a.pay_dt = to_char(sysdate,'YYYYMMDD')";
		//당일+연체-미수금
		}else if(gubun2.equals("6") && gubun3.equals("3")){	sub_query += " and a.ext_est_dt <= to_char(sysdate,'YYYYMMDD') and a.pay_dt is null";
		//검색
		}

		/*연체조회*/

		if(gubun2.equals("3")){
			if(calDelay()){
				if(gubun4.equals("2")){	//일반연체	
					sub_query += " and a.dly_days between 1 and 30";				
				}else if(gubun4.equals("3")){ //부실연체
					sub_query += " and a.dly_days between 1 and 30";
				}else if(gubun4.equals("4")){ //악성연체
					sub_query += " and a.dly_days between 1 and 30";
				}else{}
			}else{
			}
		}

		/*검색조건*/
			
		if(s_kd.equals("2"))		sub_query += " and nvl(b.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	sub_query += " and upper(b.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	sub_query += " and nvl(c.car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("5"))	sub_query += " and a.ext_est_dt like '"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	sub_query += " and upper(b.brch_id) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("7"))	sub_query += " and nvl(b.r_site, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("8"))	sub_query += " and b.mng_id= '"+t_wd+"'\n";
		else if(s_kd.equals("9"))	sub_query += " and nvl(c.car_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("10"))	sub_query += " and nvl(d.cls_dt, '') like '"+t_wd+"%'\n";
		else						sub_query += " and nvl(b.firm_nm, '') like '%"+t_wd+"%'\n";			

		String query = "";
		query = " select '계획' gubun, a.*, b.*, c.*\n"+
				" from\n"+
					" ( select count(*) tot_su1, nvl(sum(cls_amt),0) tot_amt1 from ("+sub_query+") where substr(cls_est_dt,1,7) = to_char(SYSDATE, 'YYYY-MM') ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(cls_amt),0) tot_amt2 from ("+sub_query+") where cls_est_dt = to_char(SYSDATE, 'YYYY-MM-DD') ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(cls_amt),0) tot_amt3 from ("+sub_query+") where cls_est_dt < to_char(SYSDATE, 'YYYY-MM-DD') and (pay_dt is null or pay_dt = to_char(SYSDATE, 'YYYY-MM-DD')) ) c\n"+
				" union all\n"+
				" select '수금' gubun, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(cls_amt),0) tot_amt1 from ("+sub_query+") where substr(cls_est_dt,1,7) = to_char(SYSDATE, 'YYYY-MM') and pay_dt is not null) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(cls_amt),0) tot_amt2 from ("+sub_query+") where cls_est_dt = to_char(SYSDATE, 'YYYY-MM-DD') and pay_dt = to_char(SYSDATE, 'YYYY-MM-DD') ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(cls_amt),0) tot_amt3 from ("+sub_query+") where cls_est_dt < to_char(SYSDATE, 'YYYY-MM-DD') and pay_dt = to_char(SYSDATE, 'YYYY-MM-DD') ) c\n"+
				" union all\n"+
				" select '미수금' gubun, a.*, b.*, c.*\n"+
				" from \n"+
					" ( select count(*) tot_su1, nvl(sum(cls_amt),0) tot_amt1 from ("+sub_query+") where substr(cls_est_dt,1,7) = to_char(SYSDATE, 'YYYY-MM') and pay_dt is null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(cls_amt),0) tot_amt2 from ("+sub_query+") where cls_est_dt = to_char(SYSDATE, 'YYYY-MM-DD') and pay_dt is null) b,\n"+
					" ( select count(*) tot_su3, nvl(sum(cls_amt),0) tot_amt3 from ("+sub_query+") where cls_est_dt < to_char(SYSDATE, 'YYYY-MM-DD') and pay_dt is null ) c\n"+
				" union all\n"+
				" select '비율' gubun, a.*, b.*, c.*\n"+
				" from \n"+
					" ( select decode(a.tot_su1, 0,0, to_number(to_char((b.tot_su1/a.tot_su1)*100, 999.99))) tot_su1, decode(a.tot_amt1, 0,0, to_number(to_char((b.tot_amt1/a.tot_amt1)*100, 999.99))) tot_amt1 from \n"+
						" ( select count(*) tot_su1, nvl(sum(cls_amt),0) tot_amt1 from ("+sub_query+") where substr(cls_est_dt,1,7) = to_char(SYSDATE, 'YYYY-MM') ) a,\n"+
						" ( select count(*) tot_su1, nvl(sum(cls_amt),0) tot_amt1 from ("+sub_query+") where substr(cls_est_dt,1,7) = to_char(SYSDATE, 'YYYY-MM') and pay_dt is not null ) b\n"+
					" ) a,\n"+
					" ( select decode(a.tot_su2, 0,0, to_number(to_char((b.tot_su2/a.tot_su2)*100, 999.99))) tot_su2, decode(a.tot_amt2, 0,0, to_number(to_char((b.tot_amt2/a.tot_amt2)*100, 999.99))) tot_amt2 from \n"+
						" ( select count(*) tot_su2, nvl(sum(cls_amt),0) tot_amt2 from ("+sub_query+") where cls_est_dt = to_char(SYSDATE, 'YYYY-MM-DD') ) a,\n"+
						" ( select count(*) tot_su2, nvl(sum(cls_amt),0) tot_amt2 from ("+sub_query+") where cls_est_dt = to_char(SYSDATE, 'YYYY-MM-DD') and pay_dt = to_char(SYSDATE, 'YYYY-MM-DD') ) b\n"+
					" ) b,\n"+
					" ( select decode(a.tot_su3, 0,0, to_number(to_char((b.tot_su3/a.tot_su3)*100, 999.99))) tot_su3, decode(a.tot_amt3, 0,0, to_number(to_char((b.tot_amt3/a.tot_amt3)*100, 999.99))) tot_amt3 from \n"+
						" ( select count(*) tot_su3, nvl(sum(cls_amt),0) tot_amt3 from ("+sub_query+") where cls_est_dt < to_char(SYSDATE, 'YYYY-MM-DD') and (pay_dt is null or pay_dt = to_char(SYSDATE, 'YYYY-MM-DD')) ) a,\n"+
						" ( select count(*) tot_su3, nvl(sum(cls_amt),0) tot_amt3 from ("+sub_query+") where cls_est_dt < to_char(SYSDATE, 'YYYY-MM-DD') and pay_dt = to_char(SYSDATE, 'YYYY-MM-DD') ) b\n"+
					" ) c";
		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();

			while(rs.next())
			{
				IncomingBean fee = new IncomingBean();
				fee.setGubun(rs.getString(1));
				fee.setTot_su1(rs.getInt(2));
				fee.setTot_amt1(rs.getInt(3));
				fee.setTot_su2(rs.getInt(4));
				fee.setTot_amt2(rs.getInt(5));
				fee.setTot_su3(rs.getInt(6));
				fee.setTot_amt3(rs.getInt(7));
				vt.add(fee);
			}
			rs.close();   
			pstmt.close();

			
		} catch (SQLException e) {
			System.out.println("[AddClsDatabase:getClsScdStat]\n"+e);
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

	// 중도해지위약금 건별 스케줄 리스트 조회
	public Vector getClsScd(String m_id, String l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query =  " select decode(a.pay_dt, '','미수금', '수금') gubun, a.ext_tm cls_tm,"+
						" a.ext_s_amt cls_s_amt , a.ext_v_amt cls_v_amt, a.pay_amt, a.dly_amt, nvl(a.dly_days,'0') dly_days,"+
						" nvl2(a.ext_est_dt,substr(a.ext_est_dt,1,4)||'-'||substr(a.ext_est_dt,5,2)||'-'||substr(a.ext_est_dt,7,2),' ') cls_est_dt,\n"+
						" nvl2(k.tax_dt,substr(k.tax_dt,1,4)||'-'||substr(k.tax_dt,5,2)||'-'||substr(k.tax_dt,7,2),' ') ext_dt,\n"+
						" nvl2(a.pay_dt,substr(a.pay_dt,1,4)||'-'||substr(a.pay_dt,5,2)||'-'||substr(a.pay_dt,7,2),' ') pay_dt\n"+
						" from scd_ext a,"+
						" (select aa.rent_l_cd, min(aa.tax_dt) tax_dt from tax aa where aa.tax_st<>'C' and aa.tax_bigo like '%중도해지%' and aa.tax_supply > 0 group by aa.rent_l_cd) k"+
						" where a.ext_st = '4' and a.rent_mng_id='"+m_id+"' and a.rent_l_cd='"+l_cd+"' and nvl(a.bill_yn,'Y')<>'N' and a.rent_l_cd=k.rent_l_cd(+) ";

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
			while(rs.next())
			{				
	            ClsScdBean bean = new ClsScdBean();

				bean.setRent_mng_id(m_id); 
				bean.setRent_l_cd(l_cd); 
				bean.setGubun(rs.getString("gubun")); 
				bean.setCls_tm(rs.getString("cls_tm")); 					
				bean.setCls_s_amt(rs.getInt("cls_s_amt")); 
				bean.setCls_v_amt(rs.getInt("cls_v_amt")); 
				bean.setCls_est_dt(rs.getString("cls_est_dt").trim());
				bean.setExt_dt(rs.getString("ext_dt").trim());
				bean.setPay_amt(rs.getInt("pay_amt")); 
				bean.setPay_dt(rs.getString("pay_dt").trim());
				bean.setDly_amt(rs.getInt("dly_amt")); 
				bean.setDly_days(rs.getString("dly_days")); 
				vt.add(bean);	
			}
			rs.close();   
			stmt.close();

		} catch (SQLException e) {
			System.out.println("[AddClsDatabase:getClsScd]\n"+e);
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

	// 중도해지위약금 건별 스케줄 리스트 통계
	public IncomingBean getClsScdCaseStat(String m_id, String l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		IncomingBean ins_m = new IncomingBean();

		String sub_query = "";
		sub_query = " select a.* from scd_ext a, cls_cont b"+
					" where a.ext_st = '4' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.cls_st in ('2', '1') and nvl(a.bill_yn,'Y')='Y'"+
					" and a.rent_mng_id=? and b.rent_l_cd=? ";

		String query = "";
		query = " select a.*, b.*, c.* from\n"+
					" ( select count(*) tot_su1, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt1 from ("+sub_query+") where ext_pay_dt is null) a, \n"+
					" ( select count(*) tot_su2, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt2 from ("+sub_query+") where ext_pay_dt is not null) b, \n"+
					" ( select count(*) tot_su3, nvl(sum(dly_amt),0) tot_amt3 from ("+sub_query+") where dly_amt > 0) c";
		
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, m_id);
			pstmt.setString(2, l_cd);
			pstmt.setString(3, m_id);
			pstmt.setString(4, l_cd);
			pstmt.setString(5, m_id);
			pstmt.setString(6, l_cd);
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{
				ins_m.setTot_su1(rs.getInt(1));
				ins_m.setTot_amt1(rs.getInt(2));
				ins_m.setTot_su2(rs.getInt(3));
				ins_m.setTot_amt2(rs.getInt(4));
				ins_m.setTot_su3(rs.getInt(5));
				ins_m.setTot_amt3(rs.getInt(6));
			}
			rs.close();   
			pstmt.close();

			
		} catch (SQLException e) {
			System.out.println("[AddClsDatabase:getClsScdCaseStat]\n"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ins_m;
		}
	}

	/**
	 *	중도해지위약금 건별 스케줄 한회차 면책금 쿼리(한 라인)
	 */
	public ClsScdBean getScd(String m_id, String l_cd, String cls_tm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ClsScdBean cls_scd = new ClsScdBean();
		String query =  " select * from scd_ext"+
						" where ext_st = '4' and RENT_MNG_ID=? and RENT_L_CD=? and ext_TM=?";
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, m_id);
			pstmt.setString(2, l_cd);
			pstmt.setString(3, cls_tm);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{
				cls_scd.setRent_mng_id(m_id); 
				cls_scd.setRent_l_cd(l_cd); 
				cls_scd.setCls_tm(cls_tm); 					
				cls_scd.setCls_s_amt(rs.getInt("ext_s_amt")); 
				cls_scd.setCls_v_amt(rs.getInt("ext_v_amt")); 
				cls_scd.setCls_est_dt(rs.getString("ext_est_dt"));
				cls_scd.setPay_amt(rs.getInt("pay_amt")); 
				cls_scd.setPay_dt(rs.getString("pay_dt"));
				cls_scd.setDly_amt(rs.getInt("dly_amt")); 
				cls_scd.setDly_days(rs.getString("dly_days")); 
			}
			rs.close();   
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AddClsDatabase:getScd]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return cls_scd;
		}				
	}

	/**
	 *	해지시 실이용기간 조회
	 */
	public String getMonDay(String sdt, String edt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ClsScdBean cls_scd = new ClsScdBean();
		String monday = "";
		String query =  " select"+ 
						" nvl(decode( sign(to_date('"+edt+"','YYYY-MM-DD') - to_date('"+sdt+"','YYYY-MM-DD')), -1, '0', trunc(months_between(to_date('"+edt+"','YYYY-MM-DD')+1, to_date('"+sdt+"', 'YYYY-MM-DD')))),0) mon,"+
						" nvl(decode( sign(to_date('"+edt+"','YYYY-MM-DD') - to_date('"+sdt+"','YYYY-MM-DD')), -1, '0', trunc(to_date('"+edt+"','YYYY-MM-DD')+1-add_months(to_date('"+sdt+"', 'YYYY-MM-DD'), trunc(months_between(to_date('"+edt+"','YYYY-MM-DD')+1, to_date('"+sdt+"', 'YYYY-MM-DD')))))),0) day"+
						" from dual";

		if(sdt.equals("") || edt.equals("")){
		   return "";
		}

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next()){
				monday = rs.getString("mon")+"/"+rs.getString("day");
			}
			rs.close();   
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AddClsDatabase:getMonDay]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return monday;
		}				
	}

	// 수정 -------------------------------------------------------------------------------------------------
	
	/**
	 *	중도해지위약금 연체료 계산 : cls_c.jsp
	 */
	public boolean calDelay(String m_id, String l_cd){
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;

		//연체일 있는 경우(입금:입금일>입금예정일, 미입금:현재날자>입금예정일)
		String query1 = "";
		query1= " UPDATE scd_ext SET"+
				" dly_days=TRUNC(NVL(TO_DATE(ext_pay_dt, 'YYYYMMDD'), SYSDATE) - TO_DATE(ext_est_dt, 'YYYYMMDD')),"+
				" dly_amt=(TRUNC(((ext_s_amt)*0.18*TRUNC(TO_DATE(ext_est_dt, 'YYYYMMDD')- NVL(TO_DATE(ext_pay_dt, 'YYYYMMDD'), SYSDATE)))/365) * -1)"+
				" WHERE ext_st = '3' and rent_mng_id=? and rent_l_cd=?"+
//        " and cls_est_dt is not null and (pay_dt is null or cls_est_dt < pay_dt)";
				" and SIGN(TRUNC(NVL(TO_DATE(ext_pay_dt, 'YYYYMMDD'), SYSDATE) - NVL(TO_DATE(ext_est_dt, 'YYYYMMDD'), SYSDATE))) > 0";
	
		//연체일 없는 경우(입금:입금일=입금예정일, 입금일<입금예정일(선수), 미입금:현재날짜<입금예정일)
		String query2 = "";
		query2= " UPDATE scd_ext set"+
				" dly_days = '0',"+
				" dly_amt = 0"+
				" WHERE ext_st = '4' and rent_mng_id=? and rent_l_cd=?"+
//      " and (cls_est_dt is null or cls_est_dt >= pay_dt)";
				" and SIGN(TRUNC(NVL(TO_DATE(ext_pay_dt, 'YYYYMMDD'), SYSDATE) - NVL(TO_DATE(ext_est_dt, 'YYYYMMDD'), SYSDATE))) < 1";        
		try 
		{
			conn.setAutoCommit(false);
				
			pstmt1 = conn.prepareStatement(query1);
			pstmt1.setString(1, m_id);
			pstmt1.setString(2, l_cd);
		    pstmt1.executeUpdate();
			pstmt1.close();

		    pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString(1, m_id);
			pstmt2.setString(2, l_cd);
		    pstmt2.executeUpdate();
			pstmt2.close();
		    
		    conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddClsDatabase:calDelay case]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);	
                if(pstmt1 != null)	pstmt1.close();
                if(pstmt2 != null)	pstmt2.close();
			}
			
			catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	/**
	 *	중도해지위약금 연체료 일괄 계산 : cls_sc.jsp
	 */
	public boolean calDelay(){
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;

		//연체일 있는 경우(입금:입금일>입금예정일, 미입금:현재날자>입금예정일)
		String query1 = "";
		query1= " UPDATE scd_ext SET"+
				" dly_days=TRUNC(NVL(TO_DATE(ext_pay_dt, 'YYYYMMDD'), SYSDATE) - TO_DATE(ext_est_dt, 'YYYYMMDD')),"+
				" dly_amt=(TRUNC(((ext_s_amt)*0.18*TRUNC(TO_DATE(ext_est_dt, 'YYYYMMDD')- NVL(TO_DATE(ext_pay_dt, 'YYYYMMDD'), SYSDATE)))/365) * -1)"+
				" WHERE SIGN(TRUNC(NVL(TO_DATE(ext_pay_dt, 'YYYYMMDD'), SYSDATE) - TO_DATE(ext_est_dt, 'YYYYMMDD'))) > 0";
	
		//연체일 없는 경우(입금:입금일=입금예정일, 입금일<입금예정일(선수), 미입금:현재날짜<입금예정일)
		String query2 = "";
		query2= " UPDATE scd_ext set"+
				" dly_days = '0',"+
				" dly_amt = 0"+
				" WHERE SIGN(TRUNC(NVL(TO_DATE(ext_pay_dt, 'YYYYMMDD'), SYSDATE) - TO_DATE(ext_est_dt, 'YYYYMMDD'))) < 1";
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
			System.out.println("[AddClsDatabase:calDelay all]\n"+e);
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
	

	// 중도해지위약금 리스트 조회
	public Hashtable getFeeNoAmt(String m_id, String l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		query = " select * from "+
				" (select -sum(fee_s_amt) ex_amt from scd_fee where rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"' and fee_est_dt>= to_char(sysdate,'YYYYMMDD') and rc_yn='1') a,"+
				" (select sum(fee_s_amt) di_amt from scd_fee where rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"' and rc_yn='0' and tm_st1='1') b,"+	
				" (select sum(dly_fee) dly_amt from scd_fee where rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"') c,"+
				" (select -sum(pay_amt) pay_amt from scd_dly where rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"') d";

		try {
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
		} catch (SQLException e) {
			System.out.println("[AddClsDatabase:getFeeNoAmt]\n"+e);
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

	//중도해지정산 조회  //20170420일이후 계약건은 서비스 1일 추가로 인해 해지일 -1	
	public Hashtable getSettleBase(String m_id, String l_cd, String cls_dt, String dly_c_dt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		String cls_dt1 = "";
		String cls_dt2 = "";
		String cls_dt3 = "";
		
		String dly_dt1 = "";
		String dly_dt2 = "";
	

		if(cls_dt.equals("")){
			cls_dt1 = "to_date(to_char(sysdate,'YYYYMMdd'))";
			cls_dt2 = "to_char(sysdate,'YYYYMMDD')";
			cls_dt3 = cls_dt2;
		}else{
			cls_dt1 = "to_date('"+cls_dt+"', 'YYYYMMDD')";
			cls_dt2 = cls_dt;
			cls_dt3 =   "'"+cls_dt+"'";
		}

		if  (!dly_c_dt.equals("")) {
			 dly_dt1 = "to_date('"+dly_c_dt+"', 'YYYYMMDD')";
			 dly_dt2 = dly_c_dt;
			
		} else {
			dly_dt1 = cls_dt1;
			dly_dt2 = cls_dt2;
			
		}		
		
	 	//r_mon , r_day: 사용(이용)기간,  n_mon, n_day:잔여대여기간  , m_mon, m_day : 선납 경과  기간  
		// m - max(fee), o - min(fee), f - full(fee)
		//rcon_mon , rcon_day :잔여대여기간 
		
		query = " select a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.r_site as site_id, a.tax_type,\n"+
				" nvl(b.firm_nm,b.client_nm) firm_nm, b.enp_no, b.ssn, b.ven_code, b.client_st,\n"+
				" c.car_no, c.car_nm as car_nm2, c.car_nm||e.car_name car_nm,\n"+
				" TRUNC(MONTHS_BETWEEN("+cls_dt1 + ", TO_DATE(replace(c.init_reg_dt,'-',''), 'YYYYMMDD'))) car_mon, \n"+
				" decode(f.rent_way,'1','일반식','2','맞춤식','3','기본식') rent_way,\n"+
				" a.brch_id, o.opt_per, (o.opt_s_amt+o.opt_v_amt) opt_amt,\n"+
				" f.rent_start_dt, f.rent_end_dt, f.con_mon, o.br_id, m.cls_per, nvl(m.cls_r_per, '30') cls_r_per, m.fee_s_amt,  \n "+  		
				" m.fee_s_amt*m.con_mon  tfee_s_amt, m.fee_s_amt mfee_s_amt,  m.pere_r_mth, \n"+		
				" g.grt_amt, g.pp_s_amt , g.ifee_s_amt, g.pp_amt, g.ifee_amt, \n "+  		//pp_amt , ifee_amt 사용??
				" " +cls_dt3 +  " cls_dt, \n"+
				// 대여료가 0인경우 선납금으로 역산,   선납(개시, 선납금이 적용되는 개월수) - lfee_mon
				" m.con_mon lfee_mon, " +cls_dt1+" - to_date(f.rent_start_dt, 'YYYYMMDD')  rent_days, "+
				//선납 경과기간 계산관련 -잔여대여기간 을 역으로 하여 계산 - 더이상 사용안함 - 20190828
			//	" decode( sign("+cls_dt1+" - to_date(m.rent_start_dt, 'YYYYMMDD')), -1, '0', trunc(months_between("+cls_dt1+"+1, to_date(m.rent_start_dt, 'YYYYMMDD')))) m_mon,\n"+
			//	" decode( sign("+cls_dt1+" - to_date(m.rent_start_dt, 'YYYYMMDD')), -1, '0', trunc("+cls_dt1+"+1-add_months(to_date(m.rent_start_dt, 'YYYYMMDD'), trunc(months_between("+cls_dt1+"+1, to_date(m.rent_start_dt, 'YYYYMMDD')))))) m_day,\n"+
							
		//		" decode( sign("+cls_dt1+" - to_date(f.rent_start_dt, 'YYYYMMDD')   ), -1, '0', trunc(months_between("+cls_dt1+"+1, to_date(f.rent_start_dt, 'YYYYMMDD')))) r_mon,\n"+
		//		" decode( sign("+cls_dt1+" - to_date(f.rent_start_dt, 'YYYYMMDD')   ), -1, '0', trunc("+cls_dt1+"+1-add_months(to_date(f.rent_start_dt, 'YYYYMMDD'), trunc(months_between("+cls_dt1+"+1, to_date(f.rent_start_dt, 'YYYYMMDD')))))) r_day,\n"+
				
				//20170420  사용일 +1 서비스 		
				" decode( sign("+cls_dt1+" - case when f.rent_start_dt > '20170420' then  to_date(f.rent_start_dt, 'YYYYMMDD') +1 else to_date(f.rent_start_dt, 'YYYYMMDD') end  ), -1, '0', trunc(months_between("+cls_dt1+"+1, case when f.rent_start_dt > '20170420' then  to_date(f.rent_start_dt, 'YYYYMMDD') +1 else to_date(f.rent_start_dt, 'YYYYMMDD') end ))) r_mon,\n"+
				" decode( sign("+cls_dt1+" - case when f.rent_start_dt > '20170420' then  to_date(f.rent_start_dt, 'YYYYMMDD') +1 else to_date(f.rent_start_dt, 'YYYYMMDD') end  ), -1, '0', trunc("+cls_dt1+"+1-add_months(case when f.rent_start_dt > '20170420' then  to_date(f.rent_start_dt, 'YYYYMMDD') +1 else to_date(f.rent_start_dt, 'YYYYMMDD') end, trunc(months_between("+cls_dt1+"+1, case when f.rent_start_dt > '20170420' then  to_date(f.rent_start_dt, 'YYYYMMDD') +1 else to_date(f.rent_start_dt, 'YYYYMMDD') end  ))))) r_day,\n"+
													
			//	" decode( sign(to_date(f.rent_end_dt, 'YYYYMMDD') - "+cls_dt1+"+1), -1, '0', trunc(months_between(to_date(f.rent_end_dt, 'YYYYMMDD')+1, "+cls_dt1+"+1))) n_mon,\n"+
			//	" decode( sign(to_date(f.rent_end_dt, 'YYYYMMDD') - "+cls_dt1+"+1), -1, '0', trunc(to_date(f.rent_end_dt, 'YYYYMMDD')+1-add_months("+cls_dt1+"+1, trunc(months_between(to_date(f.rent_end_dt, 'YYYYMMDD')+1, "+cls_dt1+"+1))))) n_day,\n"+
			
				" h.nfee_s_amt, h.di_amt, h.nfee_v_amt, h.di_v_amt,  h.s_mon s_mon , h.s_day s_day, hs.hs_mon hs_mon, hs.hs_day hs_day, \n"+	
				" ii.ex_s_amt , ii.ex_v_amt,  case when (nvl(j.dly_fee,0)-nvl(k.pay_amt,0))  < 0 then 0 else (nvl(j.dly_fee,0)-nvl(k.pay_amt,0))  end  dly_amt,\n"+
				" nvl(l.fine_cnt,0) fine_cnt, l.fine_amt, nvl(n.serv_cnt,0) serv_cnt, n.car_ja_amt, ov.use_s_dt, ov.use_e_dt, \n"+
				"  nvl(dv.dly_s_dt, '99999999') dly_s_dt, \n"+
				" TRUNC(MONTHS_BETWEEN( "+cls_dt1+", TO_DATE(ov.use_e_dt, 'YYYYMMDD')))  r_con_mon ,   \n"+
				"  rc.rc_s_amt, rc.rc_v_amt ,  trunc(rr.rr_amt) rr_amt, trunc(rr.rr_amt/1.1)  rr_s_amt,  trunc(rr.rr_amt) - trunc(rr.rr_amt/1.1)  rr_v_amt ,  \n"+
				"  F_getBetweenYMD(f.rent_end_dt, "+cls_dt2+" ) r_ymd ,  F_getBetweenYMD2(f.rent_end_dt, "+cls_dt2+" ) r2_ymd , oe.use_oe_dt  " +      //두날짜간 차이 년^월^일 로 표시 		
				" from cont a, client b, car_reg c, car_etc d, car_nm e, fee m, fee o,\n"+
				" (select rent_mng_id, rent_l_cd, min(rent_start_dt) rent_start_dt, max(rent_end_dt) rent_end_dt, min(rent_way) rent_way, sum(con_mon) con_mon, max(fee_s_amt) fee_s_amt, sum(fee_s_amt*con_mon) tfee_s_amt from fee where con_mon is not null group by rent_mng_id, rent_l_cd) f,\n"+
//선납금 관련 :연장시 보증금 승계인 경우에는 보증금일부 환불도 있음, 보증금 입금이 다 안될때도 있음. sum 	, 연장이 아닌 경우도 sum, 연장이 되면서 보증금이 들어오는 경우도 발생됨.-	보증금승계이외는 보증금입금분으로		
			    " ( select a.rent_mng_id, a.rent_l_cd, sum(decode(a.ext_st,'0', decode(f.rent_st, '1', a.ext_pay_amt, decode(f.grt_suc_yn, 0,  f.grt_amt_s, 1, a.ext_pay_amt, decode(f.rent_st, '1', a.ext_pay_amt, 0)))))  grt_amt,  \n"+
				"	 sum(decode(a.ext_st,'1', case when a.rent_st = f.rent_st then round(a.ext_pay_amt/1.1) else 0 end )) pp_s_amt, sum(decode(a.ext_st,'2', case when a.rent_st = f.rent_st then round(a.ext_pay_amt/1.1) else 0 end )) ifee_s_amt , \n"+
				"	 sum(decode(a.ext_st,'1', case when a.rent_st = f.rent_st then round(a.ext_pay_amt) else 0 end )) pp_amt, sum(decode(a.ext_st,'2', case when a.rent_st = f.rent_st then round(a.ext_pay_amt) else 0 end )) ifee_amt  \n"+
				"   	from scd_ext a, (select f.rent_mng_id, f.rent_l_cd, f.grt_suc_yn, f.rent_st, f.grt_amt_s from  cont_n_view c, fee f where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd = f.rent_l_cd and c.fee_rent_st = f.rent_st) f \n"+
				"	 where a.rent_mng_id= f.rent_mng_id and a.rent_l_cd = f.rent_l_cd  and a.ext_st in ('0', '1', '2') and a.rent_st = f.rent_st  and nvl(a.bill_yn, 'Y') = 'Y' Group by a.rent_mng_id, a.rent_l_cd ) g, \n"+		    
//미납대여료 --tm_st2:2 출고전대차 
				" (select a.rent_mng_id, a.rent_l_cd, sum(decode(a.tm_st1,'0',a.fee_s_amt)) nfee_s_amt, sum(decode(a.tm_st1,'0',0,a.fee_s_amt)) di_amt, \n "+
				"		 sum(decode(a.tm_st1,'0',a.fee_v_amt)) nfee_v_amt, sum(decode(a.tm_st1,'0',0,a.fee_v_amt)) di_v_amt,\n"+ //잔액
				"		trunc( months_between( "+cls_dt1+"+1,"+
				"			   to_date(min(decode(a.use_s_dt, '', to_char(add_months(to_date(b.rent_start_dt,'YYYYMMDD'),  (a.fee_tm-nvl(c.p_cnt,0)-1)),'YYYYMMDD'),a.use_s_dt)),'YYYYMMDD')"+
				"		) ) s_mon,\n"+
				"		trunc( "+cls_dt1+"+1"+
				"		       -"+
				"		       add_months( to_date(min(decode(a.use_s_dt, '', to_char(add_months(to_date(b.rent_start_dt,'YYYYMMDD'),  (a.fee_tm-nvl(c.p_cnt,0)-1)),'YYYYMMDD'),a.use_s_dt)),'YYYYMMDD'),"+
				"		                   trunc( months_between( "+cls_dt1+"+1, to_date(min(decode(a.use_s_dt, '', to_char(add_months(to_date(b.rent_start_dt,'YYYYMMDD'),  (a.fee_tm-nvl(c.p_cnt,0)-1)),'YYYYMMDD'),a.use_s_dt)),'YYYYMMDD') ) )"+
				"		                 )"+
				"		) s_day \n"+
				"		from scd_fee a, fee b, (select rent_l_cd, count(*) p_cnt from scd_fee where tm_st2='2' group by rent_l_cd) c, \n"+
				"		( select rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_l_cd) l		 \n"+  //연장했는데 미납이 걸쳐있는 경우도 있음 20090616 추가
				"		where\n"+
				"		decode(a.use_s_dt, '', to_char(add_months(to_date(b.rent_start_dt,'YYYYMMDD'),  (a.fee_tm-nvl(c.p_cnt,0)-1)),'YYYYMMDD'), a.use_s_dt) <= "+cls_dt3+""+
				"		and a.tm_st2 <> '4' and  a.fee_s_amt > 0 and a.rc_amt = 0 and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd(+) and a.rent_l_cd=l.rent_l_cd(+) and b.rent_st = l.rent_st group by a.rent_mng_id, a.rent_l_cd) h, \n"+
		
		//미납대여일자 - 잔액제외한 경우
				" (select a.rent_mng_id, a.rent_l_cd, \n"+ //잔액
				"		trunc( months_between( "+cls_dt1+"+1,"+
				"			   to_date(min(decode(a.use_s_dt, '', to_char(add_months(to_date(b.rent_start_dt,'YYYYMMDD'),  (a.fee_tm-nvl(c.p_cnt,0)-1)),'YYYYMMDD'),a.use_s_dt)),'YYYYMMDD')"+
				"		) ) hs_mon,\n"+
				"		trunc( "+cls_dt1+"+1"+
				"		       -"+
				"		       add_months( to_date(min(decode(a.use_s_dt, '', to_char(add_months(to_date(b.rent_start_dt,'YYYYMMDD'),  (a.fee_tm-nvl(c.p_cnt,0)-1)),'YYYYMMDD'),a.use_s_dt)),'YYYYMMDD'),"+
				"		                   trunc( months_between( "+cls_dt1+"+1, to_date(min(decode(a.use_s_dt, '', to_char(add_months(to_date(b.rent_start_dt,'YYYYMMDD'),  (a.fee_tm-nvl(c.p_cnt,0)-1)),'YYYYMMDD'),a.use_s_dt)),'YYYYMMDD') ) )"+
				"		                 )"+
				"		) hs_day \n"+
				"		from scd_fee a, fee b, (select rent_l_cd, count(*) p_cnt from scd_fee where tm_st2='2'  group by rent_l_cd) c, \n"+
				"		( select rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_l_cd) l		 \n"+  //연장했는데 미납이 걸쳐있는 경우도 있음 20090616 추가
				"		where\n"+
				"		decode(a.use_s_dt, '', to_char(add_months(to_date(b.rent_start_dt,'YYYYMMDD'),  (a.fee_tm-nvl(c.p_cnt,0)-1)),'YYYYMMDD'), a.use_s_dt) <= "+cls_dt3+""+
				"		and a.tm_st2  <> '4' and  a.fee_s_amt > 0  and a.rc_amt = 0 and a.tm_st1 ='0' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd(+) and a.rent_l_cd=l.rent_l_cd(+) and b.rent_st = l.rent_st group by a.rent_mng_id, a.rent_l_cd) hs, \n"+
				//선납 - 해지일이후 스케쥴	 - ii	
				"( select rent_mng_id, rent_l_cd, trunc(sum(decode(sign(rc_amt-ex_amt),-1,rc_amt,ex_amt))) ex_s_amt, trunc(sum(decode(sign(rc_v_amt-ex_v_amt),-1,rc_v_amt,ex_v_amt))) ex_v_amt \n"+
				"  from ( \n"+
 				"	select  a.rent_mng_id, a.rent_l_cd, trunc(a.rc_amt/1.1) rc_amt , (a.rc_amt - trunc(a.rc_amt/1.1)) rc_v_amt,  \n"+
 	      	 //   " 		decode( sign(to_date(use_e_dt,'YYYYMMDD') - "+cls_dt1+"), -1, '0', trunc(months_between(to_date(use_e_dt,'YYYYMMDD'), "+cls_dt1+"))) e_mon,"+
			//	" 		decode( sign(to_date(use_e_dt,'YYYYMMDD') - "+cls_dt1+"), -1, '0', trunc(to_date(use_e_dt,'YYYYMMDD')-add_months("+cls_dt1+", trunc(months_between(to_date(use_e_dt,'YYYYMMDD'), "+cls_dt1+"))))) e_day,\n"+
				" 		(b.fee_s_amt * (decode( sign(to_date(use_e_dt,'YYYYMMDD') - "+cls_dt1+"), -1, '0', trunc(months_between(to_date(use_e_dt,'YYYYMMDD'), "+cls_dt1+")))+decode( sign(to_date(use_e_dt,'YYYYMMDD') - "+cls_dt1+"), -1, '0', trunc(to_date(use_e_dt,'YYYYMMDD')-add_months("+cls_dt1+", trunc(months_between(to_date(use_e_dt,'YYYYMMDD'), "+cls_dt1+")))))/(  to_date(use_e_dt,'YYYYMMDD') - to_date(use_s_dt,'YYYYMMDD') + 1    )) ) ex_amt,\n"+
				" 		(b.fee_v_amt * (decode( sign(to_date(use_e_dt,'YYYYMMDD') - "+cls_dt1+"), -1, '0', trunc(months_between(to_date(use_e_dt,'YYYYMMDD'), "+cls_dt1+")))+decode( sign(to_date(use_e_dt,'YYYYMMDD') - "+cls_dt1+"), -1, '0', trunc(to_date(use_e_dt,'YYYYMMDD')-add_months("+cls_dt1+", trunc(months_between(to_date(use_e_dt,'YYYYMMDD'), "+cls_dt1+")))))/(  to_date(use_e_dt,'YYYYMMDD') - to_date(use_s_dt,'YYYYMMDD') + 1    )) )  ex_v_amt\n"+
				"	   from  scd_fee b, ( select rent_mng_id, rent_l_cd, rent_st, fee_tm, rent_seq, sum(rc_amt) rc_amt from scd_fee where tm_st2 not in ( '2' , '4' )  and rc_yn ='1' and use_s_dt > "+cls_dt3+"" +
 				" 	   group by rent_mng_id, rent_l_cd, rent_st, fee_tm, rent_seq ) a \n"+
 				" where b.rent_mng_id = a.rent_mng_id and b.rent_l_cd = a.rent_l_cd and b.rent_st = a.rent_st and b.fee_tm = a.fee_tm and b.rent_seq = b.rent_seq and b.tm_st1 = '0' and tm_st2 <> '4'  ) group by rent_mng_id, rent_l_cd \n"+
 				" ) ii, \n"+	
 				//총받은 금액
				" (select rent_mng_id, rent_l_cd,  sum(trunc(rc_amt/1.1)) rc_s_amt, sum(rc_amt-trunc(rc_amt/1.1)) rc_v_amt from scd_fee    where tm_st2 <> '4' and fee_s_amt > 0 and rc_yn = '1' group by rent_mng_id, rent_l_cd) rc,   \n"+
  				//   --해지일자전 스케줄 받을금액 합계
				"  (SELECT a.rent_mng_id, a.rent_l_cd,   \n"+
				"	      trunc( SUM( CASE WHEN a.use_e_dt<= "+cls_dt3+"  AND a.tm_st1=0 THEN a.fee_s_amt + a.fee_v_amt  \n"+
				"	                 WHEN "+cls_dt3+"  BETWEEN a.use_s_dt AND a.use_e_dt AND a.tm_st1=0 THEN  \n"+
				"	                      ((b.fee_s_amt+ b.fee_v_amt)*decode( sign(to_date(substr(replace("+cls_dt3+"  ,'-',''),1,8), 'YYYYMMDD') - to_date(substr(replace(a.use_s_dt,'-',''),1,8), 'YYYYMMDD')), -1, '0', trunc(months_between(to_date(substr(replace("+cls_dt3+" ,'-',''),1,8), 'YYYYMMDD')+1, to_date(substr(replace(a.use_s_dt,'-',''),1,8), 'YYYYMMDD')))))   \n"+
				"	                      + \n"+
				"	                      ((b.fee_s_amt+ b.fee_v_amt )/30*decode( sign(to_date(substr(REPLACE("+cls_dt3+" ,'-',''),1,8), 'YYYYMMDD') - to_date(substr(replace(a.use_s_dt,'-',''),1,8), 'YYYYMMDD')), -1, '0', trunc(to_date(substr(replace("+cls_dt3+" ,'-',''),1,8), 'YYYYMMDD')+1-add_months(to_date(substr(replace(a.use_s_dt,'-',''),1,8), 'YYYYMMDD'), trunc(months_between(to_date(substr(replace("+cls_dt3+" ,'-',''),1,8), 'YYYYMMDD')+1, to_date(substr(replace(a.use_s_dt,'-',''),1,8), 'YYYYMMDD')))))))   \n"+
				"	                 ELSE 0   end     ) ) rr_amt      \n"+ 
				"	    FROM   SCD_FEE a, FEE b \n"+
				"	    WHERE   nvl(a.bill_yn, 'Y') ='Y' AND a.tm_st2 <> '4' and  a.rent_mng_id=b.rent_mng_id AND a.RENT_L_CD=b.rent_l_cd AND a.rent_st=b.rent_st  \n"+
				"	    GROUP BY a.rent_mng_id, a.rent_l_cd ) rr   ,   \n"+
				//연체료 	 (case when decode(c.rent_suc_dt,'',nvl(f.rent_dt,b.rent_dt),c.rent_suc_dt)	
				" (select a.rent_mng_id, a.rent_l_cd, sum((TRUNC(((decode(nvl(a.rc_amt,0),0,a.fee_s_amt+a.fee_v_amt,a.rc_amt))*(case when decode(c.rent_suc_dt,'',decode(f.rent_st,'1',b.rent_dt,f.rent_dt),c.rent_suc_dt) >= '20220101' then 0.20 else 0.24 end)*TRUNC(TO_DATE(a.r_fee_est_dt, 'YYYYMMDD')- NVL(TO_DATE(a.rc_dt, 'YYYYMMDD'), "+dly_dt1+")))/365) * -1)) dly_fee from scd_fee a, cont b, fee f, cont_etc c WHERE a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd  and  a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_l_cd=c.rent_l_cd  and  a.bill_yn  = 'Y' and a.tm_st2 <> '4' and a.rent_st = f.rent_st and nvl(a.rc_dt,"+dly_dt2+") > a.r_fee_est_dt group by a.rent_mng_id, a.rent_l_cd ) j,\n"+
				" (select rent_mng_id,  rent_l_cd, sum(pay_amt) pay_amt from scd_dly group by rent_mng_id, rent_l_cd ) k,\n"+
//대차추가-20091224	- 과태료
			    " ( SELECT nvl(dd.rent_mng_id, a.rent_mng_id ) rent_mng_id, nvl(dd.rent_l_cd, a.rent_l_cd) rent_l_cd, count(*) fine_cnt,  sum(a.paid_amt) fine_amt FROM fine a, rent_cont g, cont dd \n" +
           		"	WHERE  (dd.rent_mng_id='"+m_id+"' or a.rent_mng_id='"+m_id+"') and (dd.rent_l_cd='"+l_cd+"' or a.rent_l_cd='"+l_cd+"') "+
				"	       and a.coll_dt is null and nvl(a.no_paid_yn,'N')<>'Y' and nvl(a.fault_st,'1')='1' and a.paid_st in ('3','4')   and a.paid_amt > 0 and a.rent_s_cd=g.rent_s_cd(+) and g.sub_l_cd=dd.rent_l_cd(+)   \n" +
				"	group by nvl(dd.rent_mng_id, a.rent_mng_id ), nvl(dd.rent_l_cd, a.rent_l_cd)  ) l, \n"+
//대차추가-20091224	- 면책금
				" ( SELECT nvl(dd.rent_mng_id, se.rent_mng_id ) rent_mng_id, nvl(dd.rent_l_cd, se.rent_l_cd) rent_l_cd,  count(*) serv_cnt, sum(se.ext_s_amt + se.ext_v_amt) car_ja_amt FROM service a, scd_ext se, accident e, rent_cont g , cont dd  \n" +
           		"	WHERE  (dd.rent_mng_id='"+m_id+"' or se.rent_mng_id='"+m_id+"') and (dd.rent_l_cd='"+l_cd+"' or se.rent_l_cd='"+l_cd+"') "+
				"	       and se.ext_st = '3' and se.rent_mng_id = a.rent_mng_id and se.rent_l_cd = a.rent_l_cd and se.ext_id = a.serv_id and (se.ext_s_amt + se.ext_v_amt)  <> 0  and se.ext_pay_dt is null and nvl(a.no_dft_yn,'N')<>'Y' and nvl(se.bill_yn, 'Y') = 'Y' and a.car_mng_id = e.car_mng_id and a.accid_id=e.accid_id and e.rent_s_cd=g.rent_s_cd(+) and g.sub_l_cd=dd.rent_l_cd(+)   \n" +
				"	group by nvl(dd.rent_mng_id, se.rent_mng_id ) ,  nvl(dd.rent_l_cd, se.rent_l_cd)  ) n,\n"+
					
				" (select rent_mng_id, rent_l_cd, max(use_s_dt) use_s_dt,   max(use_e_dt) use_e_dt   from scd_fee group by rent_mng_id, rent_l_cd) ov, \n"+	
				" (select rent_mng_id, rent_l_cd,   max(use_e_dt) use_oe_dt   from scd_fee where tm_st2 != '3' group by rent_mng_id, rent_l_cd) oe, \n"+	 //임의연장제외
				" (select rent_mng_id, rent_l_cd, min(use_s_dt) dly_s_dt from scd_fee where rc_yn='0' and fee_s_amt > 0 group by rent_mng_id, rent_l_cd) dv \n"+		
			
				" where a.rent_mng_id='"+m_id+"' and a.rent_l_cd='"+l_cd+"'"+
				" and a.client_id=b.client_id \n"+
				" and a.car_mng_id=c.car_mng_id(+)\n"+
				" and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd\n"+
				" and d.car_id=e.car_id and d.car_seq=e.car_seq\n"+
				" and a.rent_mng_id=f.rent_mng_id(+) and a.rent_l_cd=f.rent_l_cd(+)\n"+
				" and a.rent_mng_id=g.rent_mng_id(+) and a.rent_l_cd=g.rent_l_cd(+)\n"+
				" and a.rent_mng_id=h.rent_mng_id(+) and a.rent_l_cd=h.rent_l_cd(+)\n"+
				" and a.rent_mng_id=hs.rent_mng_id(+) and a.rent_l_cd=hs.rent_l_cd(+)\n"+
				" and a.rent_mng_id=ii.rent_mng_id(+) and a.rent_l_cd=ii.rent_l_cd(+)\n"+	
				" and a.rent_mng_id=j.rent_mng_id(+) and a.rent_l_cd=j.rent_l_cd(+) \n"+
				" and a.rent_mng_id=k.rent_mng_id(+) and a.rent_l_cd=k.rent_l_cd(+) \n"+
				" and a.rent_mng_id=l.rent_mng_id(+) and a.rent_l_cd=l.rent_l_cd(+)\n"+
				" and a.rent_mng_id=n.rent_mng_id(+) and a.rent_l_cd=n.rent_l_cd(+)\n"+
				" and a.rent_mng_id=m.rent_mng_id(+) and a.rent_l_cd=m.rent_l_cd(+) and m.rent_st=(select max(to_number(rent_st)) from fee where rent_l_cd=a.rent_l_cd)\n"+
				" and a.rent_mng_id=o.rent_mng_id(+) and a.rent_l_cd=o.rent_l_cd(+) and o.rent_st=(select min(to_number(rent_st)) from fee where rent_l_cd=a.rent_l_cd)\n"+
				" and a.rent_mng_id=ov.rent_mng_id(+) and a.rent_l_cd=ov.rent_l_cd(+)\n"+	
				" and a.rent_mng_id=dv.rent_mng_id(+) and a.rent_l_cd=dv.rent_l_cd(+)\n"+		
				" and a.rent_mng_id=oe.rent_mng_id(+) and a.rent_l_cd=oe.rent_l_cd(+)\n"+			
				" and a.rent_mng_id=rc.rent_mng_id(+) and a.rent_l_cd=rc.rent_l_cd(+)\n"+			
				" and a.rent_mng_id=rr.rent_mng_id(+) and a.rent_l_cd=rr.rent_l_cd(+)";	
    						
String out_query = " select a.rent_mng_id, a.rent_l_cd,\n"+
				"		sum(decode(a.tm_st1,'0',a.fee_s_amt)) nfee_s_amt,\n"+
				"		sum(decode(a.tm_st1,'0',0,a.fee_s_amt)) di_amt,\n"+
				"		trunc( months_between( "+cls_dt1+"+1,\n"+
				"			   to_date(min(decode(a.use_s_dt, '', to_char(add_months(to_date(b.rent_start_dt,'YYYYMMDD'),  (a.fee_tm-nvl(c.p_cnt,0)-1)),'YYYYMMDD'),a.use_s_dt)),'YYYYMMDD')"+
				"		) ) s_mon,\n"+	
				"		trunc( "+cls_dt1+"+1"+
				"		       -"+
				"		       add_months( to_date(min(decode(a.use_s_dt, '', to_char(add_months(to_date(b.rent_start_dt,'YYYYMMDD'),  (a.fee_tm-nvl(c.p_cnt,0)-1)),'YYYYMMDD'),a.use_s_dt)),'YYYYMMDD'),"+
				"		                   trunc( months_between( "+cls_dt1+"+1, to_date(min(decode(a.use_s_dt, '', to_char(add_months(to_date(b.rent_start_dt,'YYYYMMDD'),  (a.fee_tm-nvl(c.p_cnt,0)-1)),'YYYYMMDD'),a.use_s_dt)),'YYYYMMDD') ) )"+
				"		                 )"+
				"		) s_day \n"+	
				"		from scd_fee a, fee b, (select rent_l_cd, count(*) p_cnt from scd_fee where tm_st2='2' group by rent_l_cd) c\n"+
				"		where a.rent_mng_id='"+m_id+"' and a.rent_l_cd='"+l_cd+"' \n"+
				"		and decode(a.use_s_dt, '', to_char(add_months(to_date(b.rent_start_dt,'YYYYMMDD'),  (a.fee_tm-nvl(c.p_cnt,0)-1)),'YYYYMMDD'), a.use_s_dt) <= "+cls_dt3+""+
				"		and a.tm_st2 <> '4' and  a.rc_amt = 0 and a.tm_st1='0' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd(+) group by a.rent_mng_id, a.rent_l_cd";


      //  System.out.println("query="+query);
        
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
			System.out.println("[AddClsDatabase:getSettleBase]\n"+e);			
			System.out.println("[AddClsDatabase:getSettleBase]\n"+query);			
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


	//중도해지정산 조회
	public Hashtable getSettleBaseRm(String m_id, String l_cd, String cls_dt, String dly_c_dt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		String cls_dt1 = "";
		String cls_dt2 = "";
		String cls_dt3 = "";
		
		String dly_dt1 = "";
		String dly_dt2 = "";
	
		if(cls_dt.equals("")){
			cls_dt1 = "to_date(to_char(sysdate,'YYYYMMdd'))";
			cls_dt2 = "to_char(sysdate,'YYYYMMDD')";
			cls_dt3 = cls_dt2;
		}else{
			cls_dt1 = "to_date('"+cls_dt+"', 'YYYYMMDD')";
			cls_dt2 = cls_dt;
			cls_dt3 =   "'"+cls_dt+"'";
		}

		if  (!dly_c_dt.equals("")) {
			 dly_dt1 = "to_date('"+dly_c_dt+"', 'YYYYMMDD')";
			 dly_dt2 = dly_c_dt;
			
		} else {
			dly_dt1 = cls_dt1;
			dly_dt2 = cls_dt2;
			
		}	
	
		// m - max(fee), o - min(fee), f - full(fee)

		query = " select a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.r_site as site_id, a.tax_type,\n"+
				" nvl(b.firm_nm,b.client_nm) firm_nm, b.enp_no, b.ssn, b.ven_code, b.client_st,\n"+
				" c.car_no, c.car_nm as car_nm2, c.car_nm||e.car_name car_nm,\n"+
				" TRUNC(MONTHS_BETWEEN("+cls_dt1 + ", TO_DATE(replace(c.init_reg_dt,'-',''), 'YYYYMMDD'))) car_mon, \n"+
				" decode(f.rent_way,'1','일반식','2','맞춤식','3','기본식') rent_way,\n"+
		//		"  // o.br_id, o.opt_per, (o.opt_s_amt+o.opt_v_amt) opt_amt,\n"+
				" a.brch_id,  f.rent_start_dt, f.rent_end_dt, f.con_mon,  m.cls_per, nvl(m.cls_r_per, '10') cls_r_per, m.fee_s_amt,\n "+
				" iii.mtot_s_amt  tfee_s_amt,     nvl(decode(m.rent_st, '1' ,  decode(mt.rent_st, '1',  mt.fee_s_amt, m.fee_s_amt) , m.fee_s_amt) , m.fee_s_amt)  mfee_s_amt,\n"+	
				" g.grt_amt,decode(g.pp_s_amt, 0 , g.pp_s_amt, m.pp_s_amt) pp_s_amt, decode(g.ifee_s_amt, 0, g.ifee_s_amt, m.ifee_s_amt) ifee_s_amt,\n"+
				" to_char(sysdate,'YYYY-MM-DD') cls_dt, \n"+
				// 대여료가 0인경우 선납금으로 역산
				" m.con_mon lfee_mon, " +cls_dt1+" - to_date(f.rent_start_dt, 'YYYYMMDD')  rent_days, "+
				" decode( sign("+cls_dt1+" - to_date(f.rent_start_dt, 'YYYYMMDD')), -1, '0', trunc(months_between("+cls_dt1+"+1, to_date(f.rent_start_dt, 'YYYYMMDD')))) r_mon,\n"+
				" decode( sign("+cls_dt1+" - to_date(f.rent_start_dt, 'YYYYMMDD')), -1, '0', trunc("+cls_dt1+"+1-add_months(to_date(f.rent_start_dt, 'YYYYMMDD'), trunc(months_between("+cls_dt1+"+1, to_date(f.rent_start_dt, 'YYYYMMDD')))))) r_day,\n"+
						
				" decode( sign(to_date(ov.use_e_dt, 'YYYYMMDD') - "+cls_dt1+"+1), -1, '0', trunc(months_between(to_date(ov.use_e_dt, 'YYYYMMDD')+1, "+cls_dt1+"+1))) n_mon,\n"+
				" decode( sign(to_date(ov.use_e_dt, 'YYYYMMDD') - "+cls_dt1+"+1), -1, '0', trunc(to_date(ov.use_e_dt, 'YYYYMMDD')+1-add_months("+cls_dt1+"+1, trunc(months_between(to_date(ov.use_e_dt, 'YYYYMMDD')+1, "+cls_dt1+"+1))))) n_day,\n"+
				
				" h.nfee_s_amt, h.di_amt, h.nfee_v_amt, h.di_v_amt,  h.s_mon s_mon , h.s_day s_day, hs.hs_mon hs_mon, hs.hs_day hs_day, \n"+		
				" ii.ex_mon, ii.ex_day, ii.ex_s_amt , ii.ex_v_amt,   \n"+		
					
				" case when (nvl(j.dly_fee,0)-nvl(k.pay_amt,0))  < 0 then 0 else (nvl(j.dly_fee,0)-nvl(k.pay_amt,0))  end  dly_amt,\n"+
				"  nvl(l.fine_cnt,0) fine_cnt, l.fine_amt, nvl(n.serv_cnt,0) serv_cnt, n.car_ja_amt, ov.use_s_dt, ov.use_e_dt, nvl(dv.dly_s_dt, '99999999') dly_s_dt, \n"+
				"  rc.rc_s_amt, rc.rc_amt - rc.rc_s_amt rc_v_amt,  rc.rc_amt , trunc(rr.rr_amt) rr_amt, trunc(rr.rr_amt/1.1)  rr_s_amt,  trunc(rr.rr_amt) - trunc(rr.rr_amt/1.1)  rr_v_amt   \n"+
				" from cont a, client b, car_reg c, car_etc d, car_nm e, fee m, \n"+ // fee o,\n"+
				" (select rent_mng_id, rent_l_cd, min(rent_start_dt) rent_start_dt, max(rent_end_dt) rent_end_dt, min(rent_way) rent_way, sum(con_mon) con_mon, max(fee_s_amt) fee_s_amt, sum(fee_s_amt*con_mon) tfee_s_amt from fee where con_mon is not null group by rent_mng_id, rent_l_cd) f,\n"+
//선납금 관련 :연장시 보증금 승계인 경우에는 보증금일부 환불도 있음, 보증금 입금이 다 안될때도 있음. sum 	, 연장이 아닌 경우도 sum, 연장이 되면서 보증금이 들어오는 경우도 발생됨.-	보증금승계이외는 보증금입금분으로		
			    " ( select a.rent_mng_id, a.rent_l_cd, sum(decode(a.ext_st,'0', decode(f.rent_st, '1', a.ext_pay_amt, decode(f.grt_suc_yn, 0,  f.grt_amt_s, 1, a.ext_pay_amt, decode(f.rent_st, '1', a.ext_pay_amt, 0)))))  grt_amt,  \n"+
				"	 sum(decode(a.ext_st,'1', case when a.rent_st = f.rent_st then round(a.ext_pay_amt/1.1) else 0 end )) pp_s_amt, sum(decode(a.ext_st,'2', case when a.rent_st = f.rent_st then round(a.ext_pay_amt/1.1) else 0 end )) ifee_s_amt \n"+
				"   	from scd_ext a, (select f.rent_mng_id, f.rent_l_cd, f.grt_suc_yn, f.rent_st, f.grt_amt_s from  cont_n_view c, fee f where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd = f.rent_l_cd and c.fee_rent_st = f.rent_st) f \n"+
				"	 where a.rent_mng_id= f.rent_mng_id and a.rent_l_cd = f.rent_l_cd  and a.ext_st in ('0', '1', '2') and a.rent_st = f.rent_st  and nvl(a.bill_yn, 'Y') = 'Y' Group by a.rent_mng_id, a.rent_l_cd ) g, \n"+		    
//미납대여료
				" (select a.rent_mng_id, a.rent_l_cd, sum(decode(a.tm_st1,'0',a.fee_s_amt)) nfee_s_amt, sum(decode(a.tm_st1,'0',0,a.fee_s_amt)) di_amt, \n "+
				"		 sum(decode(a.tm_st1,'0',a.fee_v_amt)) nfee_v_amt, sum(decode(a.tm_st1,'0',0,a.fee_v_amt)) di_v_amt,\n"+ //잔액
//				"		trunc(months_between("+cls_dt1+", to_date(min(to_char(add_months(to_date(b.rent_start_dt,'YYYYMMDD'),  (a.fee_tm-nvl(c.p_cnt,0)-1)),'YYYYMMDD')),'YYYYMMDD'))) s_mon,"+
//				"		decode(max(a.r_fee_est_dt), '', 0, trunc("+cls_dt1+"-add_months(add_months(to_date(min(b.rent_start_dt),'YYYYMMDD'),  max(a.fee_tm-nvl(c.p_cnt,0))-1), trunc(months_between("+cls_dt1+", add_months(to_date(min(b.rent_start_dt),'YYYYMMDD'), max(a.fee_tm-nvl(c.p_cnt,0))-1)))))+1) as s_day "+
				"		trunc( months_between( "+cls_dt1+"+1,"+
				"			   to_date(min(decode(a.use_s_dt, '', to_char(add_months(to_date(b.rent_start_dt,'YYYYMMDD'),  (a.fee_tm-nvl(c.p_cnt,0)-1)),'YYYYMMDD'),a.use_s_dt)),'YYYYMMDD')"+
				"		) ) s_mon,\n"+
				"		trunc( "+cls_dt1+"+1"+
				"		       -"+
				"		       add_months( to_date(min(decode(a.use_s_dt, '', to_char(add_months(to_date(b.rent_start_dt,'YYYYMMDD'),  (a.fee_tm-nvl(c.p_cnt,0)-1)),'YYYYMMDD'),a.use_s_dt)),'YYYYMMDD'),"+
				"		                   trunc( months_between( "+cls_dt1+"+1, to_date(min(decode(a.use_s_dt, '', to_char(add_months(to_date(b.rent_start_dt,'YYYYMMDD'),  (a.fee_tm-nvl(c.p_cnt,0)-1)),'YYYYMMDD'),a.use_s_dt)),'YYYYMMDD') ) )"+
				"		                 )"+
				"		) s_day \n"+
				"		from scd_fee a, fee b, (select rent_l_cd, count(*) p_cnt from scd_fee where tm_st2='2' group by rent_l_cd) c, \n"+
				"		( select rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_l_cd) l		 \n"+  //연장했는데 미납이 걸쳐있는 경우도 있음 20090616 추가
				"		where\n"+
				"		decode(a.use_s_dt, '', to_char(add_months(to_date(b.rent_start_dt,'YYYYMMDD'),  (a.fee_tm-nvl(c.p_cnt,0)-1)),'YYYYMMDD'), a.use_s_dt) <= "+cls_dt3+""+		
				"		and a.fee_s_amt > 0 and a.rc_amt = 0 and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd(+) and a.rent_l_cd=l.rent_l_cd(+) and b.rent_st = l.rent_st group by a.rent_mng_id, a.rent_l_cd) h, \n"+
		//		"		and a.rc_amt = 0 and a.tm_st1='0' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd(+) group by a.rent_mng_id, a.rent_l_cd) h, \n"+		
		
		//  연장없이 1개월 임의연장할 때 
				" (select rent_mng_id , rent_l_cd , max(fee_s_amt) fee_s_amt, max(to_number(rent_st))  rent_st   from scd_fee b \n"+	
			 	"	where b.tm_st2 = '3' and b.tm_st1 = '0'  and to_date(b.use_e_dt, 'yyyymmdd')- to_date(b.use_s_dt, 'yyyymmdd' )  > 28 group by rent_mng_id , rent_l_cd  ) mt, \n"+	
             		
		//미납대여일자 - 잔액제외한 경우
				" (select a.rent_mng_id, a.rent_l_cd, \n"+ //잔액
				"		trunc( months_between( "+cls_dt1+"+1,"+
				"			   to_date(min(decode(a.use_s_dt, '', to_char(add_months(to_date(b.rent_start_dt,'YYYYMMDD'),  (a.fee_tm-nvl(c.p_cnt,0)-1)),'YYYYMMDD'),a.use_s_dt)),'YYYYMMDD')"+
				"		) ) hs_mon,\n"+
				"		trunc( "+cls_dt1+"+1"+
				"		       -"+
				"		       add_months( to_date(min(decode(a.use_s_dt, '', to_char(add_months(to_date(b.rent_start_dt,'YYYYMMDD'),  (a.fee_tm-nvl(c.p_cnt,0)-1)),'YYYYMMDD'),a.use_s_dt)),'YYYYMMDD'),"+
				"		                   trunc( months_between( "+cls_dt1+"+1, to_date(min(decode(a.use_s_dt, '', to_char(add_months(to_date(b.rent_start_dt,'YYYYMMDD'),  (a.fee_tm-nvl(c.p_cnt,0)-1)),'YYYYMMDD'),a.use_s_dt)),'YYYYMMDD') ) )"+
				"		                 )"+
				"		) hs_day \n"+
				"		from scd_fee a, fee b, (select rent_l_cd, count(*) p_cnt from scd_fee where tm_st2='2' group by rent_l_cd) c, \n"+
				"		( select rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_l_cd) l		 \n"+  //연장했는데 미납이 걸쳐있는 경우도 있음 20090616 추가
				"		where\n"+
				"		decode(a.use_s_dt, '', to_char(add_months(to_date(b.rent_start_dt,'YYYYMMDD'),  (a.fee_tm-nvl(c.p_cnt,0)-1)),'YYYYMMDD'), a.use_s_dt) <= "+cls_dt3+""+
				"		and a.fee_s_amt > 0 and a.rc_amt = 0 and a.tm_st1 ='0' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd(+) and a.rent_l_cd=l.rent_l_cd(+) and b.rent_st = l.rent_st group by a.rent_mng_id, a.rent_l_cd) hs, \n"+
				//선납-해지일 이후 스케쥴입금액 		
				"( select rent_mng_id, rent_l_cd, trunc(sum(decode(sign(rc_amt-ex_amt),-1,rc_amt,ex_amt))) ex_s_amt, trunc(sum(decode(sign(rc_v_amt-ex_v_amt),-1,rc_v_amt,ex_v_amt))) ex_v_amt, sum(e_mon)+trunc(sum(e_day)/30) ex_mon, mod(sum(e_day),30) ex_day \n"+
				"  from ( \n"+
 				"	select  a.rent_mng_id, a.rent_l_cd, trunc(a.rc_amt/1.1) rc_amt , (a.rc_amt - trunc(a.rc_amt/1.1)) rc_v_amt,  \n"+
 	      		         " 		decode( sign(to_date(use_e_dt,'YYYYMMDD') - "+cls_dt1+"), -1, '0', trunc(months_between(to_date(use_e_dt,'YYYYMMDD'), "+cls_dt1+"))) e_mon,"+
				" 		decode( sign(to_date(use_e_dt,'YYYYMMDD') - "+cls_dt1+"), -1, '0', trunc(to_date(use_e_dt,'YYYYMMDD')-add_months("+cls_dt1+", trunc(months_between(to_date(use_e_dt,'YYYYMMDD'), "+cls_dt1+"))))) e_day,\n"+
				" 		(b.fee_s_amt * (decode( sign(to_date(use_e_dt,'YYYYMMDD') - "+cls_dt1+"), -1, '0', trunc(months_between(to_date(use_e_dt,'YYYYMMDD'), "+cls_dt1+")))+decode( sign(to_date(use_e_dt,'YYYYMMDD') - "+cls_dt1+"), -1, '0', trunc(to_date(use_e_dt,'YYYYMMDD')-add_months("+cls_dt1+", trunc(months_between(to_date(use_e_dt,'YYYYMMDD'), "+cls_dt1+")))))/(  to_date(use_e_dt,'YYYYMMDD') - to_date(use_s_dt,'YYYYMMDD') + 1    )) ) ex_amt,\n"+
				" 		(b.fee_v_amt * (decode( sign(to_date(use_e_dt,'YYYYMMDD') - "+cls_dt1+"), -1, '0', trunc(months_between(to_date(use_e_dt,'YYYYMMDD'), "+cls_dt1+")))+decode( sign(to_date(use_e_dt,'YYYYMMDD') - "+cls_dt1+"), -1, '0', trunc(to_date(use_e_dt,'YYYYMMDD')-add_months("+cls_dt1+", trunc(months_between(to_date(use_e_dt,'YYYYMMDD'), "+cls_dt1+")))))/(  to_date(use_e_dt,'YYYYMMDD') - to_date(use_s_dt,'YYYYMMDD') + 1    )) )  ex_v_amt\n"+
				"	   from  scd_fee b, ( select rent_mng_id, rent_l_cd, rent_st, fee_tm, rent_seq, sum(rc_amt) rc_amt from scd_fee where rc_yn ='1' and use_s_dt > "+cls_dt3+"" +
 				" 	   group by rent_mng_id, rent_l_cd, rent_st, fee_tm, rent_seq ) a \n"+
 				" where b.rent_mng_id = a.rent_mng_id and b.rent_l_cd = a.rent_l_cd and b.rent_st = a.rent_st and b.fee_tm = a.fee_tm and b.rent_seq = b.rent_seq and b.tm_st1 = '0'  ) group by rent_mng_id, rent_l_cd \n"+
 				" ) ii, \n"+	
 				
				//총받은 금액
				" (select rent_mng_id, rent_l_cd, trunc(sum(rc_amt/1.1)) rc_s_amt, sum(rc_amt) rc_amt from scd_fee    where fee_s_amt > 0 and rc_yn = '1' group by rent_mng_id, rent_l_cd) rc,   \n"+
  				//   --해지일자전 스케줄 받을금액 합계 - 임의연장이 1달이 안되는 경우는 원래대여료로 계산
				"  (SELECT a.rent_mng_id, a.rent_l_cd,   \n"+
				"	       SUM( CASE WHEN a.use_e_dt <= "+cls_dt3+"  AND a.tm_st1=0 THEN a.fee_s_amt + a.fee_v_amt \n"+
				"	                 WHEN "+cls_dt3+"  BETWEEN a.use_s_dt AND a.use_e_dt AND a.tm_st1=0 THEN  \n"+
				"	                      ((   decode(a.tm_st2, '3', case when to_date(a.use_e_dt, 'yyyymmdd')- to_date(a.use_s_dt, 'yyyymmdd' )  > 27 and to_number(a.fee_tm) > 2  then  a.fee_s_amt+a.fee_v_amt else b.fee_s_amt+b.fee_v_amt end,  b.fee_s_amt+b.fee_v_amt)  )*decode( sign(to_date(substr(replace("+cls_dt3+"  ,'-',''),1,8), 'YYYYMMDD') - to_date(substr(replace(a.use_s_dt,'-',''),1,8), 'YYYYMMDD')), -1, '0', trunc(months_between(to_date(substr(replace("+cls_dt3+" ,'-',''),1,8), 'YYYYMMDD')+1, to_date(substr(replace(a.use_s_dt,'-',''),1,8), 'YYYYMMDD')))))   \n"+
				"	                      + \n"+
				"	                      ((  decode(a.tm_st2, '3', case when to_date(a.use_e_dt, 'yyyymmdd')- to_date(a.use_s_dt, 'yyyymmdd' )  > 27 and to_number(a.fee_tm) > 2  then  a.fee_s_amt+a.fee_v_amt else b.fee_s_amt+b.fee_v_amt end, b.fee_s_amt+ b.fee_v_amt ))/30*decode( sign(to_date(substr(REPLACE("+cls_dt3+" ,'-',''),1,8), 'YYYYMMDD') - to_date(substr(replace(a.use_s_dt,'-',''),1,8), 'YYYYMMDD')), -1, '0', trunc(to_date(substr(replace("+cls_dt3+" ,'-',''),1,8), 'YYYYMMDD')+1-add_months(to_date(substr(replace(a.use_s_dt,'-',''),1,8), 'YYYYMMDD'), trunc(months_between(to_date(substr(replace("+cls_dt3+" ,'-',''),1,8), 'YYYYMMDD')+1, to_date(substr(replace(a.use_s_dt,'-',''),1,8), 'YYYYMMDD')))))))   \n"+
				"	                 ELSE 0   end     ) rr_amt      \n"+ 
				"	    FROM   SCD_FEE a, FEE b \n"+
				"	    WHERE   nvl(a.bill_yn, 'Y') ='Y' AND a.rent_mng_id=b.rent_mng_id AND a.RENT_L_CD=b.rent_l_cd AND a.rent_st=b.rent_st  \n"+
				"	    GROUP BY a.rent_mng_id, a.rent_l_cd ) rr   ,   \n"+
				
				// 월렌트 대여료 총액
				" ( select a.rent_mng_id, a.rent_l_cd, sum(a.fee_s_amt) mtot_s_amt from scd_fee a, cont b where  a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd and b.car_st = '4' and a.fee_s_amt > 0  and tm_st1 = '0' and nvl(bill_yn, 'Y') = 'Y' \n"+
				" and a.rent_l_cd = '"+l_cd + "' group by a.rent_mng_id, a.rent_l_cd ) iii , \n"+
				                 //연체이자도 rent_mng_id, rent_l_cd 로 처리 - 20140307 
				" (select a.rent_mng_id, a.rent_l_cd, sum((TRUNC(((decode(nvl(a.rc_amt,0),0,a.fee_s_amt+a.fee_v_amt,a.rc_amt))*(case when decode(c.rent_suc_dt,'',nvl(f.rent_dt,b.rent_dt),c.rent_suc_dt) >= '20220101' then 0.20 else 0.24 end)*TRUNC(TO_DATE(a.r_fee_est_dt, 'YYYYMMDD')- NVL(TO_DATE(a.rc_dt, 'YYYYMMDD'), "+dly_dt1+")))/365) * -1)) dly_fee from scd_fee a, cont b, fee f, cont_etc c WHERE a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd  and  a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_l_cd = c.rent_l_cd and  a.bill_yn  = 'Y' and a.rent_st = f.rent_st and nvl(a.rc_dt,"+dly_dt2+") > a.r_fee_est_dt group by a.rent_mng_id, a.rent_l_cd ) j,\n"+
				" (select rent_mng_id,  rent_l_cd, sum(pay_amt) pay_amt from scd_dly group by rent_mng_id, rent_l_cd ) k,\n"+
//대차추가-20091224	- 과태료
			    " ( SELECT nvl(dd.rent_mng_id, a.rent_mng_id ) rent_mng_id, nvl(dd.rent_l_cd, a.rent_l_cd) rent_l_cd, count(*) fine_cnt,  sum(a.paid_amt) fine_amt FROM fine a, rent_cont g, cont dd \n" +
           		"	WHERE  (dd.rent_mng_id='"+m_id+"' or a.rent_mng_id='"+m_id+"') and (dd.rent_l_cd='"+l_cd+"' or a.rent_l_cd='"+l_cd+"') "+
           		"	       and a.coll_dt is null and nvl(a.no_paid_yn,'N')<>'Y' and nvl(a.fault_st,'1')='1' and a.paid_st in ('3','4')   and a.paid_amt > 0 and a.rent_s_cd=g.rent_s_cd(+) and g.sub_l_cd=dd.rent_l_cd(+)   \n" +
           		"   group by nvl(dd.rent_mng_id, a.rent_mng_id ), nvl(dd.rent_l_cd, a.rent_l_cd)  ) l, \n"+
//대차추가-20091224	- 면책금
				" ( SELECT nvl(dd.rent_mng_id, se.rent_mng_id ) rent_mng_id, nvl(dd.rent_l_cd, se.rent_l_cd) rent_l_cd,  count(*) serv_cnt, sum(se.ext_s_amt + se.ext_v_amt) car_ja_amt FROM service a, scd_ext se, accident e, rent_cont g , cont dd  \n" +
           		"	WHERE  (dd.rent_mng_id='"+m_id+"' or se.rent_mng_id='"+m_id+"') and (dd.rent_l_cd='"+l_cd+"' or se.rent_l_cd='"+l_cd+"') "+
    			"          and se.ext_st = '3' and se.rent_mng_id = a.rent_mng_id and se.rent_l_cd = a.rent_l_cd and se.ext_id = a.serv_id and (se.ext_s_amt + se.ext_v_amt)  <> 0  and se.ext_pay_dt is null and nvl(a.no_dft_yn,'N')<>'Y' and nvl(se.bill_yn, 'Y') = 'Y' and a.car_mng_id = e.car_mng_id and a.accid_id=e.accid_id and e.rent_s_cd=g.rent_s_cd(+) and g.sub_l_cd=dd.rent_l_cd(+)   \n" +
          		"   group by nvl(dd.rent_mng_id, se.rent_mng_id ) ,  nvl(dd.rent_l_cd, se.rent_l_cd)  ) n,\n"+					
				" (select rent_mng_id, rent_l_cd, max(use_s_dt) use_s_dt,   max(use_e_dt) use_e_dt   from scd_fee group by rent_mng_id, rent_l_cd) ov, \n"+	
				" (select rent_mng_id, rent_l_cd, min(use_s_dt) dly_s_dt from scd_fee where rc_yn='0' and fee_s_amt > 0 group by rent_mng_id, rent_l_cd) dv \n"+	
			" where a.rent_mng_id='"+m_id+"' and a.rent_l_cd='"+l_cd+"'"+
				" and a.client_id=b.client_id  and a.car_st = '4' \n"+
				" and a.car_mng_id=c.car_mng_id(+)\n"+
				" and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd\n"+
				" and d.car_id=e.car_id and d.car_seq=e.car_seq\n"+
				" and a.rent_mng_id=f.rent_mng_id(+) and a.rent_l_cd=f.rent_l_cd(+)\n"+
				" and a.rent_mng_id=g.rent_mng_id(+) and a.rent_l_cd=g.rent_l_cd(+)\n"+
				" and a.rent_mng_id=h.rent_mng_id(+) and a.rent_l_cd=h.rent_l_cd(+)\n"+
				" and a.rent_mng_id=hs.rent_mng_id(+) and a.rent_l_cd=hs.rent_l_cd(+)\n"+		
				" and a.rent_mng_id=ii.rent_mng_id(+) and a.rent_l_cd=ii.rent_l_cd(+)\n"+		
				" and a.rent_mng_id=iii.rent_mng_id(+) and a.rent_l_cd=iii.rent_l_cd(+)\n"+ //월렌트대여료총액(스케쥴총액으로 계산)
				" and a.rent_mng_id=j.rent_mng_id(+) and a.rent_l_cd=j.rent_l_cd(+) \n"+
				" and a.rent_mng_id=k.rent_mng_id(+) and a.rent_l_cd=k.rent_l_cd(+) \n"+
				" and a.rent_mng_id=l.rent_mng_id(+) and a.rent_l_cd=l.rent_l_cd(+)\n"+
				" and a.rent_mng_id=n.rent_mng_id(+) and a.rent_l_cd=n.rent_l_cd(+)\n"+
				" and a.rent_mng_id=m.rent_mng_id(+) and a.rent_l_cd=m.rent_l_cd(+) and m.rent_st=(select max(to_number(rent_st)) from fee where rent_l_cd=a.rent_l_cd)\n"+
	//			" and a.rent_mng_id=o.rent_mng_id(+) and a.rent_l_cd=o.rent_l_cd(+) and o.rent_st=(select min(to_number(rent_st)) from fee where rent_l_cd=a.rent_l_cd)\n"+
				" and a.rent_mng_id=ov.rent_mng_id(+) and a.rent_l_cd=ov.rent_l_cd(+)\n"+				
				" and a.rent_mng_id=dv.rent_mng_id(+) and a.rent_l_cd=dv.rent_l_cd(+)\n"+			
				" and a.rent_mng_id=rc.rent_mng_id(+) and a.rent_l_cd=rc.rent_l_cd(+)\n"+			
				" and a.rent_mng_id=rr.rent_mng_id(+) and a.rent_l_cd=rr.rent_l_cd(+)\n"+			
				" and a.rent_mng_id=mt.rent_mng_id(+) and a.rent_l_cd=mt.rent_l_cd(+)  ";		//월렌트 5% dc - 임의연장만 있는경우	

String out_query = " select a.rent_mng_id, a.rent_l_cd,\n"+
				"		sum(decode(a.tm_st1,'0',a.fee_s_amt)) nfee_s_amt,\n"+
				"		sum(decode(a.tm_st1,'0',0,a.fee_s_amt)) di_amt,\n"+
//				"		trunc(months_between("+cls_dt1+", to_date(min(to_char(add_months(to_date(b.rent_start_dt,'YYYYMMDD'),  (a.fee_tm-nvl(c.p_cnt,0)-1)),'YYYYMMDD')),'YYYYMMDD'))) s_mon,"+
//				"		decode(max(a.r_fee_est_dt), '', 0, trunc("+cls_dt1+"-add_months(add_months(to_date(min(b.rent_start_dt),'YYYYMMDD'),  max(a.fee_tm-nvl(c.p_cnt,0))-1), trunc(months_between("+cls_dt1+", add_months(to_date(min(b.rent_start_dt),'YYYYMMDD'), max(a.fee_tm-nvl(c.p_cnt,0))-1)))))+1) as s_day "+
				"		trunc( months_between( "+cls_dt1+"+1,\n"+
				"			   to_date(min(decode(a.use_s_dt, '', to_char(add_months(to_date(b.rent_start_dt,'YYYYMMDD'),  (a.fee_tm-nvl(c.p_cnt,0)-1)),'YYYYMMDD'),a.use_s_dt)),'YYYYMMDD')"+
				"		) ) s_mon,"+
				"		trunc( "+cls_dt1+"+1"+
				"		       -"+
				"		       add_months( to_date(min(decode(a.use_s_dt, '', to_char(add_months(to_date(b.rent_start_dt,'YYYYMMDD'),  (a.fee_tm-nvl(c.p_cnt,0)-1)),'YYYYMMDD'),a.use_s_dt)),'YYYYMMDD'),"+
				"		                   trunc( months_between( "+cls_dt1+"+1, to_date(min(decode(a.use_s_dt, '', to_char(add_months(to_date(b.rent_start_dt,'YYYYMMDD'),  (a.fee_tm-nvl(c.p_cnt,0)-1)),'YYYYMMDD'),a.use_s_dt)),'YYYYMMDD') ) )"+
				"		                 )"+
				"		) s_day"+
				"		from scd_fee a, fee b, (select rent_l_cd, count(*) p_cnt from scd_fee where tm_st2='2' group by rent_l_cd) c\n"+
				"		where"+
				"		decode(a.use_s_dt, '', to_char(add_months(to_date(b.rent_start_dt,'YYYYMMDD'),  (a.fee_tm-nvl(c.p_cnt,0)-1)),'YYYYMMDD'), a.use_s_dt) <= "+cls_dt3+""+
				"		and a.rc_amt = 0 and a.tm_st1='0' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd(+) group by a.rent_mng_id, a.rent_l_cd";

	//		System.out.println("[AddClsDatabase:getSettleBase-미납대여료]\n"+out_query);			

		try {
		//	System.out.println("basesettlerm=" + query);
			
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
			System.out.println("[AddClsDatabase:getSettleBaseRm]\n"+e);			
			System.out.println("[AddClsDatabase:getSettleBaseRm]\n"+query);			
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

	//중도해지정산 조회  //20170420일이후 계약건은 서비스 1일 추가로 인해 해지일 -1	
	public Hashtable getSettleBase2(String m_id, String l_cd, String cls_dt, String dly_c_dt)
		{
			getConnection();
			Statement stmt = null;
			ResultSet rs = null;
			Hashtable ht = new Hashtable();
			String query = "";
			String cls_dt1 = "";
			String cls_dt2 = "";
			String cls_dt3 = "";
			
			String dly_dt1 = "";
			String dly_dt2 = "";
		

			if(cls_dt.equals("")){
				cls_dt1 = "to_date(to_char(sysdate,'YYYYMMdd'))";
				cls_dt2 = "to_char(sysdate,'YYYYMMDD')";
				cls_dt3 = cls_dt2;
			}else{
				cls_dt1 = "to_date('"+cls_dt+"', 'YYYYMMDD')";
				cls_dt2 = cls_dt;
				cls_dt3 =   "'"+cls_dt+"'";
			}

			if  (!dly_c_dt.equals("")) {
				 dly_dt1 = "to_date('"+dly_c_dt+"', 'YYYYMMDD')";
				 dly_dt2 = dly_c_dt;
				
			} else {
				dly_dt1 = cls_dt1;
				dly_dt2 = cls_dt2;
				
			}		
			
		 	//r_mon , r_day: 사용(이용)기간,  n_mon, n_day:잔여대여기간  , m_mon, m_day : 선납 경과  기간  
			// m - max(fee), o - min(fee), f - full(fee)
			//rcon_mon , rcon_day :잔여대여기간 
			
			query = " select a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.r_site as site_id, \n"+
					" TRUNC(MONTHS_BETWEEN("+cls_dt1 + ", TO_DATE(replace(c.init_reg_dt,'-',''), 'YYYYMMDD'))) car_mon \n"+				
					" from cont a, car_reg c \n"+			
					" where a.rent_mng_id='"+m_id+"' and a.rent_l_cd='"+l_cd+"'"+				
					" and a.car_mng_id=c.car_mng_id(+)\n";	
	    						
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
				System.out.println("[AddClsDatabase:getSettleBase2]\n"+e);			
				System.out.println("[AddClsDatabase:getSettleBase2]\n"+query);			
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
		
	
	// 중도해지위약금 리스트 조회
	public String getRent_mng_id(String l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String m_id = "";
		String query = "";
		query = " select rent_mng_id from cont where rent_l_cd='"+l_cd+"'";

		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{		
				m_id = rs.getString(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AddClsDatabase:getRent_mng_id]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return m_id;
		}
	}
	
	/**
	 *	해지 insert
	 */
	public boolean insertNewCls(ClsBean cls)
	{
		getConnection();
		boolean flag = true;
		String query = "insert into cls_cont ("+
							" RENT_MNG_ID,	RENT_L_CD,	CLS_ST,		TERM_YN,	CLS_DT, "+
							" REG_ID,		CLS_CAU,	P_BRCH_CD,	NEW_BRCH_CD,TRF_DT, "+
						 	" IFEE_S_AMT,	IFEE_V_AMT, IFEE_ETC,	PP_S_AMT,	PP_V_AMT, "+
							" PP_ETC,		PDED_S_AMT, PDED_V_AMT, PDED_ETC,	TPDED_S_AMT,"+
						 	" TPDED_V_AMT,	TPDED_ETC,	RFEE_S_AMT, RFEE_V_AMT, RFEE_ETC, "+
						 	" DFEE_TM,		DFEE_S_AMT, DFEE_V_AMT, NFEE_TM,	NFEE_S_AMT, "+
							" NFEE_V_AMT,	NFEE_MON,	NFEE_DAY,	NFEE_AMT,	TFEE_AMT, "+
						 	" MFEE_AMT,		RCON_MON,	RCON_DAY,	TRFEE_AMT,	DFT_INT, "+
							" DFT_AMT,		NO_DFT_YN,	NO_DFT_CAU,	FDFT_AMT1,	FDFT_DC_AMT,"+
						 	" FDFT_AMT2,	PAY_DT,		NFEE_DAYS,	RCON_DAYS,	PP_ST,"+
							" CLS_EST_DT,	VAT_ST,		EXT_DT,		EXT_ID,		GRT_AMT,"+
							" CLS_DOC_YN,	OPT_PER,	OPT_AMT,	OPT_DT,		OPT_MNG,"+
							" dly_amt, no_v_amt, car_ja_amt, r_mon, r_day, cls_s_amt, cls_v_amt, etc_amt, fine_amt, ex_di_amt,"+
							" ifee_mon, ifee_day, ifee_ex_amt, rifee_s_amt, cancel_yn, reg_dt, etc2_amt, etc3_amt, etc4_amt, etc5_amt ) values("+
						 	" ?, ?, ?, ?, replace(?, '-', ''), "+
							" ?, ?, ?, ?, replace(?, '-', ''), "+
						 	" ?, ?, ?, ?, ?, "+
							" ?, ?, ?, ?, ?, "+ 
						 	" ?, ?, ?, ?, ?, "+
							" ?, ?, ?, ?, ?, "+
						 	" ?, ?, ?, ?, ?, "+
							" ?, ?, ?, ?, ?, "+
						 	" ?, ?, ?, ?, ?, "+
							" ?, replace(?, '-', ''), ?, ?, ?,"+
							" replace(?, '-', ''), ?, replace(?, '-', ''), ?, ?,"+
						 	" ?, ?, ?, replace(?, '-', ''), ?,"+
							" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, to_char(sysdate,'YYYYMMDD'), ?, ?, ?, ? ) ";
	
		PreparedStatement pstmt = null;
			
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
			pstmt.setString(8, cls.getP_brch_cd());
			pstmt.setString(9, cls.getNew_brch_cd());
			pstmt.setString(10, cls.getTrf_dt());
			pstmt.setInt   (11, cls.getIfee_s_amt());
			pstmt.setInt   (12, cls.getIfee_v_amt());
			pstmt.setString(13, cls.getIfee_etc());
			pstmt.setInt   (14, cls.getPp_s_amt());
			pstmt.setInt   (15, cls.getPp_v_amt());
			pstmt.setString(16, cls.getPp_etc());
			pstmt.setInt   (17, cls.getPded_s_amt());
			pstmt.setInt   (18, cls.getPded_v_amt());
			pstmt.setString(19, cls.getPded_etc());
			pstmt.setInt   (20, cls.getTpded_s_amt());
			pstmt.setInt   (21, cls.getTpded_v_amt());
			pstmt.setString(22, cls.getTpded_etc());
			pstmt.setInt   (23, cls.getRfee_s_amt());
			pstmt.setInt   (24, cls.getRfee_v_amt());
			pstmt.setString(25, cls.getRfee_etc());
			pstmt.setString(26, cls.getDfee_tm());
			pstmt.setInt   (27, cls.getDfee_s_amt());
			pstmt.setInt   (28, cls.getDfee_v_amt());
			pstmt.setString(29, cls.getNfee_tm());
			pstmt.setInt   (30, cls.getNfee_s_amt());
			pstmt.setInt   (31, cls.getNfee_v_amt());
			pstmt.setString(32, cls.getNfee_mon());
			pstmt.setString(33, cls.getNfee_day());
			pstmt.setInt   (34, cls.getNfee_amt());
			pstmt.setInt   (35, cls.getTfee_amt());
			pstmt.setInt   (36, cls.getMfee_amt());
			pstmt.setString(37, cls.getRcon_mon());
			pstmt.setString(38, cls.getRcon_day());
			pstmt.setInt   (39, cls.getTrfee_amt());
			pstmt.setString(40, cls.getDft_int());
			pstmt.setInt   (41, cls.getDft_amt());
			pstmt.setString(42, cls.getNo_dft_yn());
			pstmt.setString(43, cls.getNo_dft_cau());
			pstmt.setInt   (44, cls.getFdft_amt1());
			pstmt.setInt   (45, cls.getFdft_dc_amt());
			pstmt.setInt   (46, cls.getFdft_amt2());
			pstmt.setString(47, cls.getPay_dt());
			pstmt.setString(48, cls.getNfee_days());
			pstmt.setString(49, cls.getRcon_days());
			pstmt.setString(50, cls.getPp_st());			
			pstmt.setString(51, cls.getCls_est_dt());			
			pstmt.setString(52, cls.getVat_st());			
			pstmt.setString(53, cls.getExt_dt());			
			pstmt.setString(54, cls.getExt_id());			
			pstmt.setInt   (55, cls.getGrt_amt());
			pstmt.setString(56, cls.getCls_doc_yn());			
			pstmt.setString(57, cls.getOpt_per());			
			pstmt.setInt   (58, cls.getOpt_amt());
			pstmt.setString(59, cls.getOpt_dt());			
			pstmt.setString(60, cls.getOpt_mng());			
			pstmt.setInt   (61, cls.getDly_amt());
			pstmt.setInt   (62, cls.getNo_v_amt());
			pstmt.setInt   (63, cls.getCar_ja_amt());
			pstmt.setString(64, cls.getR_mon());			
			pstmt.setString(65, cls.getR_day());			
			pstmt.setInt   (66, cls.getCls_s_amt());
			pstmt.setInt   (67, cls.getCls_v_amt());
			pstmt.setInt   (68, cls.getEtc_amt());
			pstmt.setInt   (69, cls.getFine_amt());
			pstmt.setInt   (70, cls.getEx_di_amt());
			pstmt.setString(71, cls.getIfee_mon());			
			pstmt.setString(72, cls.getIfee_day());			
			pstmt.setInt   (73, cls.getIfee_ex_amt());
			pstmt.setInt   (74, cls.getRifee_s_amt());
			pstmt.setString(75, cls.getCancel_yn());
			pstmt.setInt   (76, cls.getEtc2_amt());
			pstmt.setInt   (77, cls.getEtc3_amt());
			pstmt.setInt   (78, cls.getEtc4_amt());
			pstmt.setInt   (79, cls.getEtc5_amt());							

			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[AddClsDatabase:insertNewCls]\n"+e);			
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


	public boolean closeContReconSh(String rent_mng_id, String old_rent_l_cd, String cls_dt)
	{
		String new_rent_l_cd = getNextRent_l_cd(old_rent_l_cd.substring(0, 7)+"S");		//신규계약코드
		//해지계약 정보
		ClsBean cls = getClsCase(rent_mng_id, old_rent_l_cd);
		
		getConnection();
		int flag = 0;
	
				
		try {
									
			//예비용으로 전환한다.
			if(!AddContDatabase.getInstance().insertReContEtcRows2(rent_mng_id, old_rent_l_cd, new_rent_l_cd, cls_dt))	flag += 1;			
	

		} catch (Exception e) {
			System.out.println("[AddClsDatabase:closeContReconSh]\n"+e);			
			e.printStackTrace();
	  		flag += 1;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);			
			}catch(Exception ignore){}
			closeConnection();
			if(flag == 0)	return true;
			else			return false;
		}		
	}
	
	/**
	 *	할부금 중도 해지 select
	 */
	public Vector getClsBankList(String lend_id)
	{
		getConnection();
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" nalt_rest, cls_rtn_int, cls_rtn_fee, cls_rtn_int_amt, dly_alt, be_alt, nalt_rest_1, nalt_rest_2, nvl(cls_etc_fee,0) cls_etc_fee, "+
				" cls_rtn_amt, bk_code, acnt_no, acnt_user, cls_rtn_cau, cls_rtn_fee_int,"+
				" decode(cls_rtn_dt, '', '', substr(cls_rtn_dt, 1, 4) || '-' || substr(cls_rtn_dt, 5, 2) || '-'||substr(cls_rtn_dt, 7, 2)) cls_rtn_dt,"+
				" decode(max_pay_dt, '', '', substr(max_pay_dt, 1, 4) || '-' || substr(max_pay_dt, 5, 2) || '-'||substr(max_pay_dt, 7, 2)) max_pay_dt"+
				" from cls_bank"+
				" where lend_id = ? order by cls_rtn_dt";
						
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, lend_id);
			rs = pstmt.executeQuery();

			while(rs.next())
			{
				ClsBankBean cls = new ClsBankBean();	
				cls.setNalt_rest(rs.getInt("nalt_rest"));	
				cls.setCls_rtn_int(rs.getString("cls_rtn_int")==null?"":rs.getString("cls_rtn_int"));	
				cls.setCls_rtn_fee(rs.getInt("cls_rtn_fee"));	
				cls.setCls_rtn_int_amt(rs.getInt("cls_rtn_int_amt"));	
				cls.setDly_alt(rs.getInt("dly_alt"));	
				cls.setBe_alt(rs.getInt("be_alt"));
				cls.setCls_rtn_amt(rs.getInt("cls_rtn_amt"));
				cls.setBk_code(rs.getString("bk_code")==null?"":rs.getString("bk_code"));	
				cls.setAcnt_no(rs.getString("acnt_no")==null?"":rs.getString("acnt_no"));	
				cls.setAcnt_user(rs.getString("acnt_user")==null?"":rs.getString("acnt_user"));	
				cls.setCls_rtn_cau(rs.getString("cls_rtn_cau")==null?"":rs.getString("cls_rtn_cau"));	
				cls.setCls_rtn_fee_int(rs.getString("cls_rtn_fee_int")==null?"":rs.getString("cls_rtn_fee_int"));	
				cls.setCls_rtn_dt(rs.getString("cls_rtn_dt")==null?"":rs.getString("cls_rtn_dt"));	
				cls.setMax_pay_dt(rs.getString("max_pay_dt")==null?"":rs.getString("max_pay_dt"));	
				cls.setNalt_rest_1(rs.getInt("nalt_rest_1"));	
				cls.setNalt_rest_2(rs.getInt("nalt_rest_2"));	
				cls.setCls_etc_fee(rs.getInt("cls_etc_fee"));	
				vt.add(cls);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddClsDatabase:getClsBank]\n"+e);			
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

	public boolean updateClsSt(String rent_mng_id, String rent_l_cd, String cls_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;

		String query = " update cls_cont set cls_st =? where rent_mng_id=? and rent_l_cd=?";
		try {
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, cls_st);
			pstmt.setString(2, rent_mng_id);
			pstmt.setString(3, rent_l_cd);
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[AddClsDatabase:updateClsSt]\n"+e);			
	  		e.printStackTrace();
			conn.rollback();
			flag = false;
		} finally {
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	
	// 조회 -------------------------------------------------------------------------------------------------

	// 잔존해지정산금 리스트 조회
	public Vector getClsList(String client_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query =		" select /*+  merge(b) */ \n"+
					" a.rent_mng_id, a.rent_l_cd, b.car_mng_id, b.firm_nm, b.client_id,\n"+
					" c.car_no, c.car_nm, (a.ext_s_amt+a.ext_v_amt) as cls_amt, b.bus_id2, d.cls_dt \n"+
					" from scd_ext a, cont_n_view b, cls_cont d, car_reg c \n"+
					" where\n"+
					" a.ext_st = '4' "+
					" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd\n"+
					" and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd\n"+
					" and b.car_mng_id = c.car_mng_id \n"+
					" and (a.ext_s_amt+a.ext_v_amt) > 0 and nvl(a.bill_yn,'Y')='Y' and  a.ext_pay_dt is null \n"+
					" and b.client_id = '" + client_id + "'";			

		query += " order by   d.cls_dt ";
	
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
		
	
	// 잔존해지정산금 리스트 조회
		public Vector getClsList(String client_id, String rent_l_cd)
		{
			getConnection();
			Statement stmt = null;
			ResultSet rs = null;
			Vector vt = new Vector();
			String query = "";
			query =		" select /*+  merge(b) */ \n"+
						" a.rent_mng_id, a.rent_l_cd, b.car_mng_id, b.firm_nm, b.client_id,\n"+
						" c.car_no, c.car_nm, (a.ext_s_amt+a.ext_v_amt) as cls_amt, b.bus_id2, d.cls_dt \n"+
						" from scd_ext a, cont_n_view b, cls_cont d, car_reg c \n"+
						" where\n"+
						" a.ext_st = '4' "+
						" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd\n"+
						" and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd\n"+
						" and b.car_mng_id = c.car_mng_id and a.rent_l_cd not in ( '" + rent_l_cd + "')  \n"+
						" and (a.ext_s_amt+a.ext_v_amt) > 0 and nvl(a.bill_yn,'Y')='Y' and  a.ext_pay_dt is null \n"+
						" and b.client_id = '" + client_id + "'";			

			query += " order by   d.cls_dt ";
		
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
			
		
		//해지정산 조회 - 받을금액  구하기 
	public int  getReceiveAmt(String m_id, String l_cd, String cls_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
	
		String cls_dt1 = "";
		String cls_dt2 = "";
		String cls_dt3 = "";
		
		int r_amt =0;
			
	//	if(cls_dt.equals("")){
	//		cls_dt1 = "to_date(to_char(sysdate,'YYYYMMdd'))";
	//		cls_dt2 = "to_char(sysdate,'YYYYMMDD')";
	//		cls_dt3 = cls_dt2;
	//	}else{
	//		cls_dt1 = "to_date('"+cls_dt+"', 'YYYYMMDD')";
	//		cls_dt2 = cls_dt;
	//		cls_dt3 =   "'"+cls_dt+"'";
//		}		 	
	
	   if ( cls_dt.equals("") ) cls_dt = "9";
	   
    	query = "  select  F_GETRECEIVEAMT ( ?, ?, ?  ) from dual " ;
    	 
   // 	System.out.println("cls_dt2=" + cls_dt2 );
    	 
    	 try{
			pstmt = conn.prepareStatement(query);		
			
			pstmt.setString(1, m_id);		
			pstmt.setString(2, l_cd);		
			pstmt.setString(3, cls_dt);		
							    						
		   	rs = pstmt.executeQuery();
			while(rs.next())
			{
				r_amt = rs.getInt(1);
			
			}
			rs.close();
			pstmt.close();

		}catch(SQLException e){
	  		e.printStackTrace();
		}finally{
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return r_amt;
		}							
	
	  
	}

	//은행대출 중도상환 스케줄 잔액 정리	
	public String call_sp_bank_scd_rest(String lend_id, String rtn_seq, String alt_tm)
	{
		getConnection();
		CallableStatement cstmt = null;
		String sResult = "";
		Random random = new Random();        
    	String query1 = "{CALL P_BANK_SCD_REST(?, ?, ?)}";
		    	 
    	 try{
			cstmt = conn.prepareCall(query1);		
			cstmt.setString(1, lend_id);			
			cstmt.setString(2, rtn_seq);			
			cstmt.setString(3, alt_tm);			
			cstmt.execute();
			cstmt.close();
		}catch(SQLException e){
	  		e.printStackTrace();
			System.out.println("[EstiDatabase:call_sp_bank_scd_rest] lend_id="+lend_id);
			System.out.println("[EstiDatabase:call_sp_bank_scd_rest] rtn_seq="+rtn_seq);
			System.out.println("[EstiDatabase:call_sp_bank_scd_rest] alt_tm="+alt_tm);
			System.out.println("[EstiDatabase:call_sp_bank_scd_rest]"+e);
		}finally{
			try{
                if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}									  
	}

	/**
	 *	개별대출 중도 해지 insert
	 */
	public boolean updateScdAllot(ClsAllotBean cls, String alt_tm)
	{
		getConnection();
		boolean flag = true;

		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		PreparedStatement pstmt4 = null;
		PreparedStatement pstmt5 = null;
		PreparedStatement pstmt6 = null;
		ResultSet rs = null;
		ResultSet rs2 = null;
		String alt_tm2 = "";
		int alt_rest = 0;

		String query1 = " select min(to_number(alt_tm)) alt_tm from scd_alt_case "+
						" where car_mng_id=? and alt_est_dt > replace(?,'-','') ";

		String query2 = " update scd_alt_case set alt_tm=alt_tm+1"+
						" where car_mng_id=? and to_number(alt_tm) >= to_number(?)";

		String query3 = " insert into scd_alt_case ("+
						"	car_mng_id, alt_tm, alt_est_dt, r_alt_est_dt, pay_yn, pay_dt,"+
						"	alt_prn, alt_int, cls_rtn_dt "+
						" ) values("+
					 	"	?, ?, replace(?, '-', ''), replace(?, '-', ''), ?, '',"+
						"	?, ?, replace(?, '-', '') "+
						" )";	
				
		//취득세+인지세 스케줄
		String query4 = " select min(to_number(alt_tm)) alt_tm, min(alt_rest) alt_rest from scd_alt_etc "+
				" where car_mng_id=? and alt_est_dt > replace(?,'-','') ";
		

		String query5 = " update scd_alt_etc set alt_tm=alt_tm+1"+
				" where car_mng_id=? and to_number(alt_tm) >= to_number(?)";

		String query6 = " insert into scd_alt_etc ("+
				"	car_mng_id, alt_tm, alt_est_dt, r_alt_est_dt, pay_yn, pay_dt,"+
				"	alt_prn, alt_int, cls_rtn_dt "+
				" ) values("+
			 	"	?, ?, replace(?, '-', ''), replace(?, '-', ''), ?, '',"+
				"	?, ?, replace(?, '-', '') "+
				" )";	
			

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query1);
			pstmt.setString(1, cls.getCar_mng_id());
			pstmt.setString(2, cls.getCls_rtn_dt());
			rs = pstmt.executeQuery();
			if(rs.next())
			{
				alt_tm = rs.getString("alt_tm")==null?"":rs.getString("alt_tm");	
			}
			rs.close();
			pstmt.close();

			if(!alt_tm.equals("")){
				//회차를 늘린다.
				pstmt2 = conn.prepareStatement(query2);
				pstmt2.setString(1, cls.getCar_mng_id());
				pstmt2.setString(2, alt_tm);
				pstmt2.executeUpdate();
				pstmt2.close();
				//System.out.println("개별대출 중도상환2--------");
				//중도상환분스케줄 생성한다.
				pstmt3 = conn.prepareStatement(query3);
				pstmt3.setString(1, cls.getCar_mng_id());
				pstmt3.setString(2, alt_tm);
				pstmt3.setString(3, cls.getCls_rtn_dt());
				pstmt3.setString(4, cls.getCls_rtn_dt());
				pstmt3.setString(5, "0");
				pstmt3.setInt   (6, cls.getNalt_rest());
				pstmt3.setInt   (7, cls.getCls_rtn_amt()-cls.getNalt_rest());
				pstmt3.setString(8, cls.getCls_rtn_dt());
				pstmt3.executeUpdate();	
				pstmt3.close();
				//System.out.println("개별대출 중도상환3--------");
			}
			
			//취득세+인지세 스케줄
			pstmt4 = conn.prepareStatement(query4);
			pstmt4.setString(1, cls.getCar_mng_id());
			pstmt4.setString(2, cls.getCls_rtn_dt());
			rs2 = pstmt4.executeQuery();
			if(rs2.next())
			{
				alt_tm2 = rs2.getString("alt_tm")==null?"":rs2.getString("alt_tm");
				alt_rest = rs2.getString("alt_rest")==null?0:AddUtil.parseInt(rs.getString("alt_rest"));
			}
			rs2.close();
			pstmt4.close();
			
			if(!alt_tm2.equals("")){
				//회차를 늘린다.
				pstmt5 = conn.prepareStatement(query5);
				pstmt5.setString(1, cls.getCar_mng_id());
				pstmt5.setString(2, alt_tm2);
				pstmt5.executeUpdate();
				pstmt5.close();
				//System.out.println("개별대출 중도상환2--------");
				//중도상환분스케줄 생성한다.
				pstmt6 = conn.prepareStatement(query6);
				pstmt6.setString(1, cls.getCar_mng_id());
				pstmt6.setString(2, alt_tm2);
				pstmt6.setString(3, cls.getCls_rtn_dt());
				pstmt6.setString(4, cls.getCls_rtn_dt());
				pstmt6.setString(5, "0");
				pstmt6.setInt   (6, alt_rest);
				pstmt6.setInt   (7, 0);
				pstmt6.setString(8, cls.getCls_rtn_dt());
				pstmt6.executeUpdate();	
				pstmt6.close();
				//System.out.println("개별대출 중도상환3--------");
			}

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddClsDatabase:updateScdAllot]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				if(rs != null)		rs.close();
				if(pstmt != null)	pstmt.close();
				if(pstmt2 != null)	pstmt2.close();
				if(pstmt3 != null)	pstmt3.close();				
				if(rs2 != null)		rs2.close();
				if(pstmt4 != null)	pstmt4.close();
				if(pstmt5 != null)	pstmt5.close();
				if(pstmt6 != null)	pstmt6.close();				
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}		

}
