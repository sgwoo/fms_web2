package acar.cust_rent;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;

public class CustRentDatabase
{
	private Connection conn = null;
	public static CustRentDatabase db;
	
	public static CustRentDatabase getInstance()
	{
		if(CustRentDatabase.db == null)
			CustRentDatabase.db = new CustRentDatabase();
		return CustRentDatabase.db;
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
	 *  계약리스트 조회
	 *	user_id : 고객 user_id
	 *	기간 : st_dt, end_dt
	 */
	public Vector getContList(String user_id, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = " SELECT C.rent_mng_id rent_mng_id, C.rent_l_cd rent_l_cd, L.client_id client_id, F.con_mon con_mon,\n"+
							" R.CAR_NM CAR_NM, L.firm_nm firm_nm, L.client_nm client_nm,\n"+
							" decode(F.rent_way, '1', '일반식', '2', '맞춤식') rent_way,\n"+
							" decode(F.rent_start_dt, '', '', substr(F.rent_start_dt, 1, 4)||'-'||substr(F.rent_start_dt, 5, 2)||'-'||substr(F.rent_start_dt, 7, 2)) rent_start_dt,\n"+
							" decode(R.init_reg_dt, '', '', substr(R.init_reg_dt, 1, 4)||'-'||substr(R.init_reg_dt, 5, 2)||'-'||substr(R.init_reg_dt, 7, 2)) init_reg_dt\n"+
					" FROM CONT C, CLIENT L, CL_USER U, CAR_REG R, FEE F\n"+
					" WHERE C.client_id = L.client_id AND\n"+
						  " C.car_mng_id = R.car_mng_id(+) AND\n"+
						  " C.client_id = U.client_id AND\n"+
						  " C.rent_mng_id = F.rent_mng_id AND\n"+
						  " C.rent_l_cd = F.rent_l_cd AND\n"+
						  " F.rent_st = '1' and\n"+
						  " U.user_id = '"+user_id+"' and\n"+
						  " F.rent_start_dt between ? and ?";
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, st_dt);
				pstmt.setString(2, end_dt);
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
	 *	계약정보화면
	 */

	public CustRentBean getContInfo(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		CustRentBean cust_rent = new CustRentBean();
		String query = " SELECT A.rent_l_cd rent_l_cd, A.rent_mng_id rent_mng_id, A.brch_nm brch_nm, A.bus_nm bus_nm, A.CAR_NM CAR_NM,\n"+
							" A.opt opt, A.colo colo, A.car_price car_price,\n"+
							" DECODE(A.dlv_est_dt, '', '', SUBSTR(A.dlv_est_dt, 1, 4)||'-'||SUBSTR(A.dlv_est_dt, 5, 2)||'-'||SUBSTR(A.dlv_est_dt, 7, 2)) dlv_est_dt,\n"+
							" A.fee_s_amt fee_s_amt, A.fee_v_amt fee_v_amt, A.grt_amt grt_amt, A.pp_s_amt pp_s_amt, A.pp_v_amt pp_v_amt,\n"+
							" A.fee_pay_tm fee_pay_tm, A.fee_est_day fee_est_day,\n"+
							" DECODE(A.fee_pay_start_dt, '', '', SUBSTR(A.fee_pay_start_dt, 1, 4)||'-'||SUBSTR(A.fee_pay_start_dt, 5, 2)||'-'||SUBSTR(A.fee_pay_start_dt, 7, 2)) fee_pay_start_dt,\n"+
							" DECODE(A.fee_pay_end_dt, '', '', SUBSTR(A.fee_pay_end_dt, 1, 4)||'-'||SUBSTR(A.fee_pay_end_dt, 5, 2)||'-'||SUBSTR(A.fee_pay_end_dt, 7, 2)) fee_pay_end_dt,\n"+
							" DECODE(B.ins_start_dt, '', '', SUBSTR(B.ins_start_dt, 1, 4)||'-'||SUBSTR(B.ins_start_dt, 5, 2)||'-'||SUBSTR(B.ins_start_dt, 7, 2)) ins_start_dt,\n"+
							" DECODE(B.ins_exp_dt, '', '', SUBSTR(B.ins_exp_dt, 1, 4)||'-'||SUBSTR(B.ins_exp_dt, 5, 2)||'-'||SUBSTR(B.ins_exp_dt, 7, 2)) ins_exp_dt,\n"+
							" B.ins_com_nm ins_com_nm, B.age_scp age_scp, A.imm_amt imm_amt, B.agnt_tel agnt_tel, B.agnt_imgn_tel agnt_imgn_tel,\n"+
							" A.p_addr p_addr, A.p_zip p_zip, A.r_site r_site\n"+
						" FROM\n"+
						" (\n"+
							" SELECT C.rent_l_cd rent_l_cd, C.rent_mng_id rent_mng_id, B.br_nm brch_nm, U.user_nm bus_nm, N.car_name CAR_NM, E.opt opt, E.colo colo,\n"+
								" (E.car_fs_amt+E.car_fv_amt+E.opt_fs_amt+E.opt_fv_amt+E.clr_fs_amt+E.clr_fv_amt+E.sd_fs_amt+E.sd_fv_amt-E.dc_fs_amt-E.dc_fv_amt) car_price,\n"+
							   	" P.dlv_est_dt dlv_est_dt, F.FEE_S_AMT fee_s_amt, FEE_V_AMT fee_v_amt, F.grt_amt_s grt_amt, F.pp_s_amt pp_s_amt, F.pp_v_amt pp_v_amt,\n"+
							   	" F.fee_pay_tm fee_pay_tm, F.fee_est_day fee_est_day, F.fee_pay_start_dt fee_pay_start_dt, F.fee_pay_end_dt fee_pay_end_dt , E.imm_amt imm_amt,\n"+
							   	" C.p_addr p_addr, C.p_zip p_zip, C.r_site r_site\n"+
							" FROM CONT C, CAR_ETC E, CAR_PUR P, FEE F, BRANCH B, USERS U, CAR_NM N\n"+
							" WHERE C.rent_l_cd = E.rent_l_cd AND\n"+
							  	" C.rent_mng_id = E.rent_mng_id AND\n"+
							  	" C.rent_mng_id = P.rent_mng_id AND\n"+
							  	" C.rent_l_cd = P.rent_l_cd AND\n"+
							  	" C.rent_mng_id = F.rent_mng_id AND\n"+
							  	" C.rent_l_cd = F.rent_l_cd AND\n"+
							  	" C.brch_id = B.br_id(+) AND\n"+
							  	" U.user_id = C.bus_id(+) AND\n"+
							  	" E.car_id = N.car_id(+) AND\n"+
							  //연장대여료 관련 사항
								" C.rent_l_cd = ? AND C.rent_mng_id = ?\n"+
						" )A,\n"+
						" (\n"+
							" SELECT C.rent_mng_id rent_mng_id, C.rent_l_cd rent_l_cd, M.ins_com_nm ins_com_nm,\n"+
								" DECODE(I.age_scp, '1', '21세이상', '2', '26세이상', '3', '모든운전자') age_scp,\n"+
								" I.agnt_tel agnt_tel, I.agnt_imgn_tel agnt_imgn_tel, I.ins_start_dt ins_start_dt, I.ins_exp_dt ins_exp_dt\n"+
							" FROM CONT C, CAR_REG R, INSUR I, INS_COM M\n"+
							" WHERE C.car_mng_id = R.car_mng_id AND\n"+
								  " R.car_mng_id = I.car_mng_id AND\n"+
								  " I.ins_com_id = M.ins_com_id(+) AND\n"+
								  //갱신관련사항
								  " C.rent_l_cd = ? AND C.rent_mng_id = ?\n"+	  
						" )B\n"+
						" WHERE A.rent_mng_id = B.rent_mng_id(+) AND A.rent_l_cd = B.rent_l_cd(+)\n";
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, rent_l_cd);
				pstmt.setString(2, rent_mng_id);
				pstmt.setString(3, rent_l_cd);
				pstmt.setString(4, rent_mng_id);
		    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				cust_rent.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				cust_rent.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				cust_rent.setBrch_nm(rs.getString("BRCH_NM")==null?"":rs.getString("BRCH_NM"));
				cust_rent.setBus_nm(rs.getString("BUS_NM")==null?"":rs.getString("BUS_NM"));
				cust_rent.setCar_nm(rs.getString("CAR_NM")==null?"":rs.getString("CAR_NM"));
				cust_rent.setOpt(rs.getString("OPT")==null?"":rs.getString("OPT"));
				cust_rent.setColo(rs.getString("COLO")==null?"":rs.getString("COLO"));
				cust_rent.setCar_price(rs.getInt("CAR_PRICE"));
				cust_rent.setDlv_est_dt(rs.getString("DLV_EST_DT")==null?"":rs.getString("DLV_EST_DT"));
				cust_rent.setFee_s_amt(rs.getInt("FEE_S_AMT"));
				cust_rent.setFee_v_amt(rs.getInt("FEE_V_AMT"));
				cust_rent.setGrt_amt(rs.getInt("GRT_AMT"));
				cust_rent.setPp_s_amt(rs.getInt("PP_S_AMT"));
				cust_rent.setPp_v_amt(rs.getInt("PP_V_AMT"));
				cust_rent.setFee_pay_tm(rs.getString("FEE_PAY_TM")==null?"":rs.getString("FEE_PAY_TM"));
				cust_rent.setFee_est_day(rs.getString("FEE_EST_DAY")==null?"":rs.getString("FEE_EST_DAY"));
				cust_rent.setFee_pay_start_dt(rs.getString("FEE_PAY_START_DT")==null?"":rs.getString("FEE_PAY_START_DT"));
				cust_rent.setFee_pay_end_dt(rs.getString("FEE_PAY_END_DT")==null?"":rs.getString("FEE_PAY_END_DT"));
				cust_rent.setIns_com_nm(rs.getString("INS_COM_NM")==null?"":rs.getString("INS_COM_NM"));
				cust_rent.setAge_scp(rs.getString("AGE_SCP")==null?"":rs.getString("AGE_SCP"));
				cust_rent.setImm_amt(rs.getInt("IMM_AMT"));
				cust_rent.setAgnt_tel(rs.getString("AGNT_TEL")==null?"":rs.getString("AGNT_TEL"));
				cust_rent.setAgnt_imgn_tel(rs.getString("AGNT_IMGN_TEL")==null?"":rs.getString("AGNT_IMGN_TEL"));
				cust_rent.setP_zip(rs.getString("P_ZIP")==null?"":rs.getString("P_ZIP"));
				cust_rent.setP_addr(rs.getString("P_ADDR")==null?"":rs.getString("P_ADDR"));
				cust_rent.setR_site(rs.getString("R_SITE")==null?"":rs.getString("R_SITE"));
				cust_rent.setIns_start_dt(rs.getString("INS_START_DT")==null?"":rs.getString("INS_START_DT"));
				cust_rent.setIns_exp_dt(rs.getString("INS_EXP_DT")==null?"":rs.getString("INS_EXP_DT"));
			}
			rs.close();
			pstmt.close();	
		} catch (SQLException e) {
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return cust_rent;
		}
	}

}