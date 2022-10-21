package acar.fee;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.cont.*;

public class FeeDatabase
{
	private Connection conn = null;
	public static FeeDatabase f_db;
	
	public static FeeDatabase getInstance()
	{
		if(FeeDatabase.f_db == null)
			FeeDatabase.f_db = new FeeDatabase();
		return FeeDatabase.f_db;	
	}	

 	private DBConnectionManager connMgr = null;

    private void getConnection()
    {
    	try
    	{
	    	if(connMgr == null)
				connMgr = DBConnectionManager.getInstance();
			if(conn == null)
			{
	        	conn = connMgr.getConnection("acar");				
	        }
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
	 *	한회차 대여료 insert
	 */
	public boolean insertFeeScd(FeeScdBean fee_scd)
	{
		getConnection();
		boolean flag = true;
		String query = " insert into SCD_FEE (RENT_MNG_ID, RENT_L_CD, FEE_TM, RENT_ST, TM_ST1, TM_ST2, FEE_EST_DT, FEE_S_AMT, "+
						" FEE_V_AMT, RC_YN, RC_DT, RC_AMT, DLY_DAYS, DLY_FEE, PAY_CNG_DT, PAY_CNG_CAU, R_FEE_EST_DT ) values ("+
						"?, ?, ?, ?, ?, ?, replace(?, '-', ''), ?, ?, ?, replace(?, '-', ''), "+
						"?, ?, ?, replace(?, '-', ''), ?, replace(?, '-', ''))";

		PreparedStatement pstmt = null;
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, fee_scd.getRent_mng_id());
			pstmt.setString(2, fee_scd.getRent_l_cd());
			pstmt.setString(3, fee_scd.getFee_tm());
			pstmt.setString(4, fee_scd.getRent_st());
			pstmt.setString(5, fee_scd.getTm_st1());
			pstmt.setString(6, fee_scd.getTm_st2());
			pstmt.setString(7, fee_scd.getFee_est_dt());
			pstmt.setInt   (8, fee_scd.getFee_s_amt());
			pstmt.setInt   (9, fee_scd.getFee_v_amt());
			pstmt.setString(10, fee_scd.getRc_yn());
			pstmt.setString(11, fee_scd.getRc_dt());
			pstmt.setInt   (12, fee_scd.getRc_amt());
			pstmt.setString(13, fee_scd.getDly_days());
			pstmt.setInt   (14, fee_scd.getDly_fee());
			pstmt.setString(15, fee_scd.getPay_cng_dt());
			pstmt.setString(16, fee_scd.getPay_cng_cau());
			pstmt.setString(17, fee_scd.getR_fee_est_dt());
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
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
	 *	대여료메모 insert
	 *	해당 고객 관련 계약 전체 insert (관련 계약 코드를 query해온 후, 가장 최근의 연체미수 라인에 메모를 추가한다)
	 */
	public boolean insertFeeMemoAll(FeeMemoBean fee_mm)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = " SELECT B.rent_mng_id rent_mng_id, B.rent_l_cd rent_l_cd, B.rent_st rent_st, B.fee_tm fee_tm, B.tm_st1 tm_st1"+
						" FROM"+
						 " ("+
							" SELECT C.rent_mng_id, C.rent_l_cd, F.rent_st"+
							" FROM CONT C, FEE F, CLIENT L"+
							" WHERE C.rent_mng_id = F.rent_mng_id AND"+
								  " C.rent_l_cd = F.rent_l_cd AND"+
								  " C.client_id = L.client_id AND"+
								  " L.client_id = (SELECT client_id FROM CONT WHERE rent_mng_id=? and rent_l_cd=?)"+
						" )A,"+
						" ("+										/* 회차: minimun값, 회차 안의 잔액회차: maximum값 */
							" SELECT rent_mng_id, rent_l_cd, rent_st, MIN(fee_tm) fee_tm, MAX(tm_st1) tm_st1"+
							" FROM SCD_FEE"+
							" WHERE NVL(TO_NUMBER(dly_days), 0) > 0 AND rc_yn='0' and rent_mng_id != ? and rent_l_cd != ?"+
							" GROUP BY rent_mng_id, rent_l_cd, rent_st"+
						" )B "+
						" WHERE A.rent_mng_id = B.rent_mng_id AND"+
							  " A.rent_l_cd = B.rent_l_cd AND"+
							  " A.rent_st = B.rent_st";
		try
		{
			
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, fee_mm.getRent_mng_id());
			pstmt.setString(2, fee_mm.getRent_l_cd());
			
			pstmt.setString(3, fee_mm.getRent_mng_id());
			pstmt.setString(4, fee_mm.getRent_l_cd());
//			pstmt.setString(5, fee_mm.getRent_st());
//			pstmt.setString(6, fee_mm.getFee_tm());
//			pstmt.setString(7, fee_mm.getTm_st1());
			
		    rs = pstmt.executeQuery();
		    
			while(rs.next())
			{
				fee_mm.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_mm.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_mm.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_mm.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_mm.setTm_st1(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));

				insertFeeMemo_IN(fee_mm);
			}
			rs.close();
			pstmt.close();
	  	} catch (Exception e) {
	  		e.printStackTrace();
	  		flag = false;
		} finally {
			try{	
				if(rs != null )		rs.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}	
	
	/**
	 *	대여료 메모 INSERT (내부메소드)
	 */
	private boolean insertFeeMemo_IN(FeeMemoBean fee_mm)
	{
		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		String s_seq = "";
		String query_id = " select nvl(ltrim(to_char(to_number(MAX(seq))+1, '000000')), '000001') ID from dly_mm";
		String query =  " insert into dly_mm ("+
						" RENT_MNG_ID, RENT_L_CD, RENT_ST, TM_ST1, SEQ, FEE_TM, REG_ID, REG_DT, CONTENT, SPEAKER,REG_DT_TIME)"+
						" values ( ?, ?, ?, ?, ?, ?, ?, replace(?, '-', ''), ?, ?, ?)";
		try {

			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query_id);
		    rs = pstmt1.executeQuery();
			while(rs.next())
			{
				s_seq = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt1.close();

			pstmt2 = conn.prepareStatement(query);
			pstmt2.setString(1, fee_mm.getRent_mng_id());
			pstmt2.setString(2, fee_mm.getRent_l_cd());
			pstmt2.setString(3, fee_mm.getRent_st());
			pstmt2.setString(4, fee_mm.getTm_st1());
			pstmt2.setString(5, s_seq);
			pstmt2.setString(6, fee_mm.getFee_tm());
			pstmt2.setString(7, fee_mm.getReg_id());
			pstmt2.setString(8, fee_mm.getReg_dt());
			pstmt2.setString(9, fee_mm.getContent());
			pstmt2.setString(10, fee_mm.getSpeaker());
			pstmt2.setString(11, s_seq);
			pstmt2.executeUpdate();
			pstmt2.close();

			conn.commit();
		    
	  	} catch (Exception e) {
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				if(rs != null )		rs.close();
				if(pstmt1 != null)	pstmt1.close();
				if(pstmt2 != null)	pstmt2.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			return flag;
		}
	}	
	
	/**	
	 *	대여료메모 insert
	 */
	public boolean insertFeeMemo(FeeMemoBean fee_mm)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		String s_seq = "";
		String query_id = " select nvl(ltrim(to_char(to_number(MAX(seq))+1, '000000')), '000001') ID from dly_mm";
		String query =  " insert into dly_mm ("+
						" RENT_MNG_ID, RENT_L_CD, RENT_ST, TM_ST1, SEQ, FEE_TM, REG_ID, REG_DT, CONTENT, SPEAKER, REG_DT_TIME)"+
						" values ( ?, ?, ?, ?, ?, ?, ?, replace(?, '-', ''), ?, ?, ?)";
		try {

			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query_id);
		    rs = pstmt1.executeQuery();
			while(rs.next())
			{
				s_seq = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt1.close();

			pstmt2 = conn.prepareStatement(query);
			pstmt2.setString(1, fee_mm.getRent_mng_id());
			pstmt2.setString(2, fee_mm.getRent_l_cd());
			pstmt2.setString(3, fee_mm.getRent_st());
			pstmt2.setString(4, fee_mm.getTm_st1());
			pstmt2.setString(5, s_seq);
			pstmt2.setString(6, fee_mm.getFee_tm());
			pstmt2.setString(7, fee_mm.getReg_id());
			pstmt2.setString(8, fee_mm.getReg_dt());
			pstmt2.setString(9, fee_mm.getContent());
			pstmt2.setString(10, fee_mm.getSpeaker());
			pstmt2.setString(11, s_seq);
		    pstmt2.executeUpdate();
			pstmt2.close();

			conn.commit();
		    
	  	} catch (Exception e) {
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				if(rs != null )		rs.close();
				if(pstmt1 != null)	pstmt1.close();
				if(pstmt2 != null)	pstmt2.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}	
	
	/**
	 *	한회차 대여료 update
	 */
	public boolean updateFeeScd(FeeScdBean fee_scd)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = " update scd_fee set "+
						" TM_ST2 = ?, "+
						" FEE_EST_DT = replace(?, '-', ''), "+
						" FEE_S_AMT = ?, "+
						" FEE_V_AMT = ?, "+
						" RC_YN = ?, "+
						" RC_DT = replace(?, '-', ''), "+
						" RC_AMT = ?, "+
						" DLY_DAYS = ?, "+
						" DLY_FEE = ?, "+
						" PAY_CNG_DT = replace(?, '-', ''), "+
						" PAY_CNG_CAU = ?, "+
						" R_FEE_EST_DT = replace(?, '-', '') "+
						" where "+
						" RENT_MNG_ID = ? and"+
						" RENT_L_CD = ? and"+
						" FEE_TM = ? and"+
						" RENT_ST = ? and"+
						" TM_ST1 = ? ";
		
		try {
				conn.setAutoCommit(false);
				
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1 , fee_scd.getTm_st2());
				pstmt.setString(2 , fee_scd.getFee_est_dt());
				pstmt.setInt(3 , fee_scd.getFee_s_amt());
				pstmt.setInt(4 , fee_scd.getFee_v_amt());
				pstmt.setString(5 , fee_scd.getRc_yn());
				pstmt.setString(6 , fee_scd.getRc_dt());
				pstmt.setInt(7 , fee_scd.getRc_amt());
				pstmt.setString(8 , fee_scd.getDly_days());
				pstmt.setInt(9 , fee_scd.getDly_fee());
				pstmt.setString(10, fee_scd.getPay_cng_dt());
				pstmt.setString(11, fee_scd.getPay_cng_cau());
				pstmt.setString(12, fee_scd.getR_fee_est_dt());
				pstmt.setString(13, fee_scd.getRent_mng_id());
				pstmt.setString(14, fee_scd.getRent_l_cd());
				pstmt.setString(15, fee_scd.getFee_tm());
				pstmt.setString(16, fee_scd.getRent_st());
				pstmt.setString(17, fee_scd.getTm_st1());
				int i = pstmt.executeUpdate();
				pstmt.close();
		    
		    	conn.commit();
	  	} catch (Exception e) {
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
	 *	한회차 대여료 update  -- 재계약
	 */
	public boolean updateFeeScd(FeeScdBean fee_scd, String old_rent_l_cd)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = " update scd_fee set"+
						" rent_mng_id=?,"+
						" rent_l_cd=?,"+
						" TM_ST2 = ?, "+
						" FEE_EST_DT = replace(?, '-', ''),"+
						" FEE_S_AMT = ?,"+
						" FEE_V_AMT = ?,"+
						" RC_YN = ?, "+
						" RC_DT = replace(?, '-', ''),"+
						" RC_AMT = ?,"+
						" DLY_DAYS = ?,"+
						" DLY_FEE = ?,"+
						" PAY_CNG_DT = replace(?, '-', ''),"+
						" PAY_CNG_CAU = ?,"+
						" R_FEE_EST_DT = replace(?, '-', '')"+
						" where"+
						" RENT_MNG_ID = ? and"+
						" RENT_L_CD = ? and"+
						" FEE_TM = ? and"+
						" RENT_ST = ? and"+
						" TM_ST1 = ? ";
		
		try {
				conn.setAutoCommit(false);
					
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1 , fee_scd.getRent_mng_id());
				pstmt.setString(2 , fee_scd.getRent_l_cd());
				pstmt.setString(3 , fee_scd.getTm_st2());
				pstmt.setString(4 , fee_scd.getFee_est_dt());
				pstmt.setInt(5 , fee_scd.getFee_s_amt());
				pstmt.setInt(6 , fee_scd.getFee_v_amt());
				pstmt.setString(7 , fee_scd.getRc_yn());
				pstmt.setString(8 , fee_scd.getRc_dt());
				pstmt.setInt(9 , fee_scd.getRc_amt());
				pstmt.setString(10 , fee_scd.getDly_days());
				pstmt.setInt(11 , fee_scd.getDly_fee());
				pstmt.setString(12, fee_scd.getPay_cng_dt());
				pstmt.setString(13, fee_scd.getPay_cng_cau());
				pstmt.setString(14, fee_scd.getR_fee_est_dt());
				pstmt.setString(15, fee_scd.getRent_mng_id());
				pstmt.setString(16, old_rent_l_cd);
				pstmt.setString(17, fee_scd.getFee_tm());
				pstmt.setString(18, fee_scd.getRent_st());
				pstmt.setString(19, fee_scd.getTm_st1());
				pstmt.executeUpdate();
				pstmt.close();
				
				conn.commit();
		    
	  	} catch (Exception e) {
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
	 *	한회차 대여료 delete
	 */
	public boolean dropFeeScd(String m_id, String l_cd, String r_st, String fee_tm, String tm_st1)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		String query1 = "delete from scd_fee where RENT_MNG_ID = ? and RENT_L_CD = ? and RENT_ST = ? and FEE_TM = ? and TM_ST1 = ?";
		String query2 = "update scd_fee set fee_tm=fee_tm-1 where RENT_MNG_ID = ? and RENT_L_CD = ? and FEE_TM > ?";
		
		try {
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query1);
			pstmt1.setString(1 , m_id);
			pstmt1.setString(2 , l_cd);
			pstmt1.setString(3 , r_st);
			pstmt1.setString(4 , fee_tm);
			pstmt1.setString(5 , tm_st1);
			pstmt1.executeUpdate();
			pstmt1.close();

			pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString(1 , m_id);
			pstmt2.setString(2 , l_cd);
			pstmt2.setString(3 , fee_tm);
			pstmt2.executeUpdate();
			pstmt2.close();

			conn.commit();
			
	  	} catch (Exception e) {
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt1 != null)	pstmt1.close();
				if(pstmt2 != null)	pstmt2.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
		
	/**
	 *	한회차 대여료 쿼리(한 라인)
	 */
	public FeeScdBean getScd(String m_id, String r_st, String fee_tm, String tm_st1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		FeeScdBean fee_scd = new FeeScdBean();
		String query = " select RENT_MNG_ID, RENT_L_CD, FEE_TM, RENT_ST, TM_ST1, TM_ST2, "+
						" decode(fee_est_dt, '', '', substr(FEE_EST_DT, 1, 4) || '-' || substr(FEE_EST_DT, 5, 2) || '-'||substr(FEE_EST_DT, 7, 2)) FEE_EST_DT, "+
						" FEE_S_AMT, FEE_V_AMT, RC_YN, "+
						" decode(RC_DT, '', '', substr(RC_DT, 1, 4) || '-' || substr(RC_DT, 5, 2) || '-'||substr(RC_DT, 7, 2)) RC_DT, "+
						" RC_AMT, DLY_DAYS, DLY_FEE, "+
						" decode(PAY_CNG_DT, '', '', substr(PAY_CNG_DT, 1, 4) || '-' || substr(PAY_CNG_DT, 5, 2) || '-'||substr(PAY_CNG_DT, 7, 2)) PAY_CNG_DT, "+
						" PAY_CNG_CAU, "+
						" substr(R_FEE_EST_DT, 1, 4) || '-' || substr(R_FEE_EST_DT, 5, 2) || '-'||substr(R_FEE_EST_DT, 7, 2) R_FEE_EST_DT "+
						" from scd_fee where RENT_MNG_ID = ? and RENT_ST = ? and FEE_TM = ? and TM_ST1 = ?";
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, m_id);
				pstmt.setString(2, r_st);
				pstmt.setString(3, fee_tm);
				pstmt.setString(4, tm_st1);
		    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				fee_scd.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_scd.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_scd.setTm_st1(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				fee_scd.setTm_st2(rs.getString("TM_ST2")==null?"":rs.getString("TM_ST2"));
				fee_scd.setFee_est_dt(rs.getString("FEE_EST_DT")==null?"":rs.getString("FEE_EST_DT"));
				fee_scd.setFee_s_amt(rs.getString("FEE_S_AMT")==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee_scd.setFee_v_amt(rs.getString("FEE_V_AMT")==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee_scd.setRc_yn(rs.getString("RC_YN")==null?"":rs.getString("RC_YN"));
				fee_scd.setRc_dt(rs.getString("RC_DT")==null?"":rs.getString("RC_DT"));
				fee_scd.setRc_amt(rs.getString("RC_AMT")==null?0:Integer.parseInt(rs.getString("RC_AMT")));
				fee_scd.setDly_days(rs.getString("DLY_DAYS")==null?"":rs.getString("DLY_DAYS"));
				fee_scd.setDly_fee(rs.getString("DLY_FEE")==null?0:Integer.parseInt(rs.getString("DLY_FEE")));
				fee_scd.setPay_cng_dt(rs.getString("PAY_CNG_DT")==null?"":rs.getString("PAY_CNG_DT"));
				fee_scd.setPay_cng_cau(rs.getString("PAY_CNG_CAU")==null?"":rs.getString("PAY_CNG_CAU"));
				fee_scd.setR_fee_est_dt(rs.getString("R_FEE_EST_DT")==null?"":rs.getString("R_FEE_EST_DT"));
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
			return fee_scd;
		}				
	}
	
	/**
	 *	입금변경을 위한 쿼리(한회에 속한 대여료 및 잔액 모두 포함 or 해당회차 이후의 모든 대여료 및 잔액 리턴)
	 *  gubun - ONE : 해당 회차에 속한 대여료 및 잔액만 리턴, ALL : 해당회차를 포함해 그 이후의 모든 대여료 및 잔액을 리턴
	 */
	public Vector getScdGroup(String m_id, String fee_tm, String gubun)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = " select RENT_MNG_ID, RENT_L_CD, FEE_TM, RENT_ST, TM_ST1, TM_ST2, "+
						" substr(FEE_EST_DT, 1, 4) || '-' || substr(FEE_EST_DT, 5, 2) || '-'||substr(FEE_EST_DT, 7, 2) FEE_EST_DT, "+
						" FEE_S_AMT, FEE_V_AMT, RC_YN, "+
						" substr(RC_DT, 1, 4) || '-' || substr(RC_DT, 5, 2) || '-'||substr(RC_DT, 7, 2) RC_DT, "+
						" RC_AMT, DLY_DAYS, DLY_FEE, "+
						" substr(PAY_CNG_DT, 1, 4) || '-' || substr(PAY_CNG_DT, 5, 2) || '-'||substr(PAY_CNG_DT, 7, 2) PAY_CNG_DT, "+
						" PAY_CNG_CAU, "+
						" substr(R_FEE_EST_DT, 1, 4) || '-' || substr(R_FEE_EST_DT, 5, 2) || '-'||substr(R_FEE_EST_DT, 7, 2) R_FEE_EST_DT "+
						" from scd_fee where RENT_MNG_ID = ? and rc_yn = '0'";
		if(gubun.equals("ALL"))
						query += " and to_number(FEE_TM) >= ?";
		else
						query += " and FEE_TM = ?";
				
						query += " order by to_number(fee_tm)";
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, m_id);
				pstmt.setString(2, fee_tm);
		    	rs = pstmt.executeQuery();
    			int i = 0;
			while(rs.next())
			{
				FeeScdBean fee_scd = new FeeScdBean();				
				fee_scd.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_scd.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_scd.setTm_st1(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				fee_scd.setTm_st2(rs.getString("TM_ST2")==null?"":rs.getString("TM_ST2"));
				fee_scd.setFee_est_dt(rs.getString("FEE_EST_DT")==null?"":rs.getString("FEE_EST_DT"));
				fee_scd.setFee_s_amt(rs.getString("FEE_S_AMT")==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee_scd.setFee_v_amt(rs.getString("FEE_V_AMT")==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee_scd.setRc_yn(rs.getString("RC_YN")==null?"":rs.getString("RC_YN"));
				fee_scd.setRc_dt(rs.getString("RC_DT")==null?"":rs.getString("RC_DT"));
				fee_scd.setRc_amt(rs.getString("RC_AMT")==null?0:Integer.parseInt(rs.getString("RC_AMT")));
				fee_scd.setDly_days(rs.getString("DLY_DAYS")==null?"":rs.getString("DLY_DAYS"));
				fee_scd.setDly_fee(rs.getString("DLY_FEE")==null?0:Integer.parseInt(rs.getString("DLY_FEE")));
				fee_scd.setPay_cng_dt(rs.getString("PAY_CNG_DT")==null?"":rs.getString("PAY_CNG_DT"));
				fee_scd.setPay_cng_cau(rs.getString("PAY_CNG_CAU")==null?"":rs.getString("PAY_CNG_CAU"));
				fee_scd.setR_fee_est_dt(rs.getString("R_FEE_EST_DT")==null?"":rs.getString("R_FEE_EST_DT"));
				vt.add(i, fee_scd);
				i++;
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
	 *	한 건에 대한 대여료 스케줄 쿼리
	 */
	//public Vector getFeeScd(String m_id, String l_cd)
	public Vector getFeeScd(String m_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = 	" select /*+use_hash(a b j)*/ "+
								" A.RENT_MNG_ID RENT_MNG_ID, A.RENT_L_CD RENT_L_CD, A.FEE_TM FEE_TM, A.RENT_ST RENT_ST,"+
								" A.TM_ST1 TM_ST1, A.TM_ST2 TM_ST2, A.FEE_EST_DT FEE_EST_DT, A.FEE_S_AMT FEE_S_AMT,"+
								" A.FEE_V_AMT FEE_V_AMT, A.RC_YN RC_YN, A.RC_DT RC_DT, A.RC_AMT RC_AMT, A.DLY_DAYS DLY_DAYS,"+
								" A.DLY_FEE DLY_FEE, A.PAY_CNG_DT PAY_CNG_DT, A.PAY_CNG_CAU PAY_CNG_CAU, A.R_FEE_EST_DT R_FEE_EST_DT,"+
								" decode(sign(B.tm-A.tm_st1), -1, '', 0, 'Y') ISLAST"+
						" from"+
							"(select RENT_MNG_ID, RENT_L_CD, FEE_TM, RENT_ST, TM_ST1, TM_ST2, "+
								" substr(FEE_EST_DT, 1, 4) || '-' || substr(FEE_EST_DT, 5, 2) || '-'||substr(FEE_EST_DT, 7, 2) FEE_EST_DT, "+
								" FEE_S_AMT, FEE_V_AMT, RC_YN, "+
								" substr(RC_DT, 1, 4) || '-' || substr(RC_DT, 5, 2) || '-'||substr(RC_DT, 7, 2) RC_DT, "+
								" RC_AMT, DLY_DAYS, DLY_FEE, "+
								" substr(PAY_CNG_DT, 1, 4) || '-' || substr(PAY_CNG_DT, 5, 2) || '-'||substr(PAY_CNG_DT, 7, 2) PAY_CNG_DT, "+
								" PAY_CNG_CAU, "+
								" substr(R_FEE_EST_DT, 1, 4) || '-' || substr(R_FEE_EST_DT, 5, 2) || '-'||substr(R_FEE_EST_DT, 7, 2) R_FEE_EST_DT "+
							" from scd_fee"+
								" where RENT_MNG_ID = ? order by FEE_TM"+
						" ) A,"+
						" ("+
							" select max(rent_mng_id) RENT_MNG_ID, max(rent_l_cd) RENT_L_CD, max(fee_tm) FEE_TM,"+
									" max(to_number(rent_st)) RENT_ST, max(tm_st1) TM_ST1, max(tm_st1) TM"+
							" from scd_fee"+
							" where rent_mng_id = ? and rc_yn = '1' "+
							" group by fee_tm"+
						" ) B"+
						" where"+
							" A.rent_mng_id = B.rent_mng_id(+) and"+
							" A.rent_l_cd = B.rent_l_cd(+) and"+
							" A.rent_st = B.rent_st(+) and"+
							" A.fee_tm = B.fee_tm(+)"+
						" order by to_number(FEE_TM), to_number(TM_ST1)";
						
						
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, m_id);
				pstmt.setString(2, m_id);
		    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				FeeScdBean fee_scd = new FeeScdBean();
				fee_scd.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_scd.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_scd.setTm_st1(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				fee_scd.setTm_st2(rs.getString("TM_ST2")==null?"":rs.getString("TM_ST2"));
				fee_scd.setFee_est_dt(rs.getString("FEE_EST_DT")==null?"":rs.getString("FEE_EST_DT"));
				fee_scd.setFee_s_amt(rs.getString("FEE_S_AMT")==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee_scd.setFee_v_amt(rs.getString("FEE_V_AMT")==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee_scd.setRc_yn(rs.getString("RC_YN")==null?"":rs.getString("RC_YN"));
				fee_scd.setRc_dt(rs.getString("RC_DT")==null?"":rs.getString("RC_DT"));
				fee_scd.setRc_amt(rs.getString("RC_AMT")==null?0:Integer.parseInt(rs.getString("RC_AMT")));
				fee_scd.setDly_days(rs.getString("DLY_DAYS")==null?"":rs.getString("DLY_DAYS"));
				fee_scd.setDly_fee(rs.getString("DLY_FEE")==null?0:Integer.parseInt(rs.getString("DLY_FEE")));
				fee_scd.setPay_cng_dt(rs.getString("PAY_CNG_DT")==null?"":rs.getString("PAY_CNG_DT"));
				fee_scd.setPay_cng_cau(rs.getString("PAY_CNG_CAU")==null?"":rs.getString("PAY_CNG_CAU"));
				fee_scd.setR_fee_est_dt(rs.getString("R_FEE_EST_DT")==null?"":rs.getString("R_FEE_EST_DT"));
				fee_scd.setIslast(rs.getString("ISLAST")==null?"":rs.getString("ISLAST"));
				vt.add(fee_scd);
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
	 *	계약해지후 재등록을 위해 장래미납대여료스케줄만 쿼리(연체아니면서 미수금인 스케줄)
	 */
	public Vector getFeeScdForward(String rent_mng_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = 	" select RENT_MNG_ID, RENT_L_CD, FEE_TM, RENT_ST, TM_ST1, TM_ST2,"+
								" substr(FEE_EST_DT, 1, 4) || '-' || substr(FEE_EST_DT, 5, 2) || '-'||substr(FEE_EST_DT, 7, 2) FEE_EST_DT,"+
								" FEE_S_AMT, FEE_V_AMT, RC_YN,"+
								" substr(RC_DT, 1, 4) || '-' || substr(RC_DT, 5, 2) || '-'||substr(RC_DT, 7, 2) RC_DT,"+
								" RC_AMT, DLY_DAYS, DLY_FEE,"+
								" substr(PAY_CNG_DT, 1, 4) || '-' || substr(PAY_CNG_DT, 5, 2) || '-'||substr(PAY_CNG_DT, 7, 2) PAY_CNG_DT,"+
								" PAY_CNG_CAU,"+
								" substr(R_FEE_EST_DT, 1, 4) || '-' || substr(R_FEE_EST_DT, 5, 2) || '-'||substr(R_FEE_EST_DT, 7, 2) R_FEE_EST_DT"+
						" from scd_fee"+
						" where rent_mng_id=?"+
						" and sign(trunc(to_date(r_fee_est_dt, 'YYYYMMDD')-sysdate))!= -1"+
						" and rc_yn ='0'"+
						" order by to_number(fee_tm), to_number(tm_st1)";
						
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, rent_mng_id);
//				pstmt.setString(2, rent_l_cd);
		    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				FeeScdBean fee_scd = new FeeScdBean();
				fee_scd.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_scd.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_scd.setTm_st1(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				fee_scd.setTm_st2(rs.getString("TM_ST2")==null?"":rs.getString("TM_ST2"));
				fee_scd.setFee_est_dt(rs.getString("FEE_EST_DT")==null?"":rs.getString("FEE_EST_DT"));
				fee_scd.setFee_s_amt(rs.getString("FEE_S_AMT")==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee_scd.setFee_v_amt(rs.getString("FEE_V_AMT")==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee_scd.setRc_yn(rs.getString("RC_YN")==null?"":rs.getString("RC_YN"));
				fee_scd.setRc_dt(rs.getString("RC_DT")==null?"":rs.getString("RC_DT"));
				fee_scd.setRc_amt(rs.getString("RC_AMT")==null?0:Integer.parseInt(rs.getString("RC_AMT")));
				fee_scd.setDly_days(rs.getString("DLY_DAYS")==null?"":rs.getString("DLY_DAYS"));
				fee_scd.setDly_fee(rs.getString("DLY_FEE")==null?0:Integer.parseInt(rs.getString("DLY_FEE")));
				fee_scd.setPay_cng_dt(rs.getString("PAY_CNG_DT")==null?"":rs.getString("PAY_CNG_DT"));
				fee_scd.setPay_cng_cau(rs.getString("PAY_CNG_CAU")==null?"":rs.getString("PAY_CNG_CAU"));
				fee_scd.setR_fee_est_dt(rs.getString("R_FEE_EST_DT")==null?"":rs.getString("R_FEE_EST_DT"));
				vt.add(fee_scd);
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
	 *	해지-재계약인 경우, 대여료 스케줄의 미납스케줄을 신규계약번호로 세팅한다.
	 *	(영업소 변경)
	 */

	public boolean updateReconFeeScd(String rent_mng_id, String old_rent_l_cd, String new_rent_l_cd)
	{
		int flag = 0;
		Vector scds = getFeeScdForward(rent_mng_id);
		int scd_size = scds.size();
		for(int i = 0 ; i < scd_size ; i++)
		{
			FeeScdBean scd = (FeeScdBean)scds.elementAt(i);
			scd.setRent_l_cd(new_rent_l_cd);
		
			if(!updateFeeScd(scd, old_rent_l_cd))	flag += 1;
		}
		if(flag == 0)	return true;
		else			return false;
	}	
	
	public String getFeeTotTm(String m_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String rtnStr = "";
		String query = "select max(to_number(nvl(fee_tm, '0'))) TOT_TM"+
						" from scd_fee"+
						" where rent_mng_id = ?";
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, m_id);
		    	rs = pstmt.executeQuery();
			while(rs.next())
			{
				rtnStr = rs.getString(1)==null?"":rs.getString(1);
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
			return rtnStr;
		}				
	}
	
	/**
	 *	한 건에 대한 대여료 스케줄 중 회차만 쿼리
	 */
	public Vector getFeeScdTm(String m_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = 	" select fee_tm"+
							" from scd_fee"+
							" where rc_yn = '0' and"+
								  	" tm_st1 ='0' and"+
								  	" rent_mng_id = ?"+
							" order by to_number(fee_tm)";
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, m_id);
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
	 *	대여료스케줄 통계(건별)
	 */
	//public Hashtable getFeeScdStat(String m_id, String l_cd)
	public Hashtable getFeeScdStat(String m_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = " select max(NC) NC, max(NS) NS, max(NV) NV, max(NS)+max(NV) N,"+
								" max(RC) RC, max(RS) RS, max(RV) RV, max(RS)+max(RV) R,"+
								" max(DC) DC, max(DT) DT, max(NC)+ max(RC) TC, max(NS)+ max(RS) TS, max(NV)+ max(RV) TV,"+
								" max(NS)+ max(RS)+max(NV)+ max(RV) TOT"+
								" from"+
								" ("+
									" select count(0) NC, sum(fee_s_amt) NS, sum(fee_v_amt) NV, 0 RC, 0 RS, 0 RV, 0 DC, 0 DT"+
									" from scd_fee"+
									" where rc_yn = '0' and"+
										  " rent_mng_id = ?"+
									" union"+
									" select 0 NC, 0 NS, 0 NV, count(0) RC, sum(trunc(rc_amt/1.1)) RS, sum(rc_amt-trunc(rc_amt/1.1)) RV, 0 DC, 0 DT"+
									" from scd_fee"+
									" where rc_yn = '1' and"+
										  " rent_mng_id = ?"+
									" union"+
									" select 0 NC, 0 NS, 0 NV, 0 RC, 0 RS, 0 RV, count(0) DC, sum(dly_fee) DT"+
									" from scd_fee"+
									" where rent_mng_id = ? and"+
										  "  nvl(to_number(dly_days), 0) > 0 "+
								" )";
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, m_id);
				pstmt.setString(2, m_id);
				pstmt.setString(3, m_id);
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
	 *	대여료 리스트
	 *	구분1:전체(0), 선수(1), 수금(2), 미수(3), 연체(4)
	 *	구분2:당일(0), 연체(1), 기간(2), 당일+연체(3)
	 *	st_dt, end_dt: 기간구분중 일정기간 선택일 경우 시작-종료기간
	 *  kd	  : 기타검색조건 구분(1:상호, 2: 계약자, 3:계약코드, 4:차량번호, 5:월대여료, 6:영업소코드, 7:사용본거지)
	 *  wd	  : 기타검색조건 검색어
	 *	sort_gubun : 정렬조건 (0:상호, 1:입금예정일, 2:수금일자, 3:월대여료)
  	 *   상호를 선택시 정렬순서는 "order by 상호, 수금일자, 입금예정일" 으로 한다.
     *  입금예정일을 선택시 정렬순서는 "order by 입금예정일, 수금일자, 상호" 으로 한다.
     *  수금일자을 선택시 정렬순서는 "order by 수금일자, 상호, 입금예정일" 으로 한다.
     *  월대여료를 선택시 정렬순서는 "order by 월대여료, 수금일자, 상호, 입금예정일" 으로 한다.
	 *	asc		: (0: 오름차순, 1:내림차순)
	 *
	 *	(구분1 & 2 매칭 가능 경우)
	 *	구분1	:	구분2
	 *	0		:	0, 2
	 *	1		:	0
	 *	2		:	0, 1, 2, 3
	 *	3		:	0, 1, 2, 3
	 *	4		:	0, 2
	 *
	 **	QUERY 정보 ***
	 *	subquery 임시 칼럼 값 ( where절에서 조건 구분에 쓰임)
	 *	입금예정일 : E(0:당일이전, 1:당일, 2:예정)--> 단순하게 입금예정일과 당일 비교
	 *	수금일 : R(0:당일이전, 1:당일, 2:예정) --> 단순하게 수금일과 당일 비교
	 *	연체구분 : D(1:연체, 0:연체아님) 	--> 수금인경우 수금일 > 입금예정일, 미수금인경우 현재날짜 > 입금예정일
	 *	선수구분 : F(1:선수, 0:선수아님)	--> 수금인경우 수금일 < 입금예정일
	 *	수금상태 : RC_YN(0:미수, 1: 수금)	--> Y/N로 표시
	 *	수정할일 있을 때 참고하세요.
	 *	getFeeList와 getFeeScdStat는 값이 일치해야 하므로 같은 조건을 줘야 한다.
	 */
	public Vector getFeeList(String gubun1, String gubun2, String st_dt, String end_dt, String kd, String wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query =" select\n"+
						" decode(rc_yn, '0', '미수', '1', '수금', '') gubun_st,\n"+
						" RENT_MNG_ID, RENT_L_CD, FIRM_NM, CAR_NO, CAR_NM, FEE_TM,\n"+
						" decode(tm_st1, '0', fee_tm||'회', fee_tm||'회(잔)') FEE_TM_NM,\n"+
						" substr(FEE_EST_DT, 1, 4) || '-' || substr(FEE_EST_DT, 5, 2) || '-'||substr(FEE_EST_DT, 7, 2) FEE_EST_DT,\n"+
						" FEE_S_AMT, FEE_V_AMT, FEE_AMT, BRCH_ID, R_FEE_EST_DT, RENT_ST, TM_ST1,\n"+
						" RC_YN, decode(sign(DLY_DAY), -1, (DLY_DAY*-1), DLY_DAY) DLY_DAY, R_SITE, client_nm,\n"+
						" decode(RC_DT, '', '', substr(RC_DT, 1, 4)||'-'||substr(RC_DT, 5, 2) ||'-'||substr(RC_DT, 7, 2)) RC_DT, D\n"+
					" from\n"+
					" (\n"+
					   " select\n"+
 							" decode(sign(TO_DATE(F.R_FEE_EST_DT, 'YYYYMMDD') - SYSDATE), 0, '1', 1, '2', -1, decode(sign(TO_DATE(F.R_FEE_EST_DT, 'YYYYMMDD') - SYSDATE+1), 1, '1', '0')) E,\n"+ 							
 							" DECODE(F.RC_DT, '', '', DECODE(SIGN(TRUNC(TO_DATE(F.RC_DT, 'YYYYMMDD') - SYSDATE)), -1, '0', 0, '1', '2')) R,\n"+
 							" DECODE(F.RC_YN, '0', DECODE(SIGN(TRUNC(SYSDATE-TO_DATE(F.R_FEE_EST_DT, 'YYYYMMDD'))), 1, 1, 0), '1', DECODE(SIGN(TRUNC(TO_DATE(F.RC_DT, 'YYYYMMDD')-TO_DATE(F.R_FEE_EST_DT, 'YYYYMMDD'))), 1, 1, 0), 0) D,\n"+
							" DECODE(F.RC_YN, '1', DECODE(SIGN(TRUNC(TO_DATE(F.RC_DT, 'YYYYMMDD') - TO_DATE(F.R_FEE_EST_DT, 'YYYYMMDD'))), -1, '1', '0'), 0) F,\n"+
					 	    " F.rent_mng_id RENT_MNG_ID, F.rent_l_cd RENT_L_CD, nvl(L.firm_nm, L.client_nm) FIRM_NM, R.car_no CAR_NO,\n"+
					 	    " R.car_nm CAR_NM, F.fee_tm FEE_TM, F.fee_est_dt FEE_EST_DT, F.fee_s_amt FEE_S_AMT, F.rent_st RENT_ST,\n"+
					 	    " F.fee_v_amt FEE_V_AMT, decode(F.RC_YN,'0',F.fee_s_amt+F.fee_v_amt,F.rc_amt) FEE_AMT, F.r_fee_est_dt R_FEE_EST_DT,\n"+
					 	    " C.brch_id BRCH_ID, F.tm_st1 TM_ST1, F.rc_dt, F.rc_yn, C.R_SITE, L.client_nm, F.dly_days dly_day\n"+
					   " from scd_fee F, cont C, client L, car_reg R\n"+
					   " where\n"+
					   		" C.rent_mng_id = F.rent_mng_id and\n"+
					 		" C.rent_l_cd =  F.rent_l_cd and\n"+
					 		" C.client_id = L.client_id and\n"+
					 		" C.car_mng_id = R.car_mng_id(+)\n"+
					" )"+
					" where ";
			
			if(gubun1.equals("0"))
			{
				if(gubun2.equals("0"))		//전체-당일((E:1 && F:0)|| (D:1 && R:1) || (D:1 && N))	입금예정일이 당일이고 선수가 아닌 데이터) & 연체된 데이타(연체수금:당일, 연체미수))
					query += " (E = 1 AND F = 0) OR (D = 1 AND R = 1) OR (D = 1 AND RC_YN = '0')";
				else if(gubun2.equals("2"))	query += "fee_est_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";	//전체-기간
			}
			else if(gubun1.equals("1"))
			{
				//선수-당일(F:1, R:1, Y)
				query += " F = 1 AND R = 1";
			}
			else if(gubun1.equals("2"))
			{
				if(gubun2.equals("0"))// 수금-당일(E:1, 2, R:1, Y)	수금일이 당일이고 입금예정일이 당일이거나 예정인것
					query += " (E = 1 OR E = 2) AND R = 1";
				else if(gubun2.equals("1"))// 수금-연체(D:1, R:1, Y)	수금일이 당일이고 연체된것
					query += " D = 1 AND R = 1";
				else if(gubun2.equals("2"))//수금-기간
					query += " RC_YN='1' AND RC_DT BETWEEN '"+st_dt+"' AND '"+end_dt+"'";	
				else if(gubun2.equals("3"))//수금-당일+연체((D:1, E:1, 2,  R:1, Y)
					query += " ((E = 1 OR E = 2) OR D = 1) AND R = 1";
			}
			else if(gubun1.equals("3"))
			{
				if(gubun2.equals("0"))//미수-당일(E:1, N)
					query += " E = 1 AND RC_YN = '0'";
				else if(gubun2.equals("1"))//미수-연체(D:1, N)
					query += " D = 1 AND RC_YN = '0'";
				else if(gubun2.equals("2"))//미수-기간
					query += " RC_YN='0' AND FEE_EST_DT BETWEEN '"+st_dt+"' AND '"+end_dt+"'";	
				else if(gubun2.equals("3"))//미수-당일+연체(E:0, 1,  N)
					query += " (E = 1 OR D = 1) AND RC_YN = '0'";
			}
			else if(gubun1.equals("4"))
			{
				if(gubun2.equals("0"))//연체-당일(E : 1)
					query += " E = 0 AND RC_YN = '0' ";
					
				else if(gubun2.equals("2"))//연체-기간
					query += " E = 0 AND FEE_EST_DT BETWEEN '"+st_dt+"' AND '"+end_dt+"' AND RC_YN = '0' ";
			}else if(gubun1.equals("5"))
			{
				query += " FEE_TM = '1' ";
			}
			
			if(kd.equals("2"))	query += " and nvl(client_nm, ' ') like '%"+wd+"%'";
			else if(kd.equals("3"))	query += " and upper(rent_l_cd) like upper('%"+wd+"%')";
			else if(kd.equals("4"))	query += " and nvl(car_no, ' ') like '%"+wd+"%'";
			else if(kd.equals("5"))	query += " and fee_amt = '"+wd+"'";
			else if(kd.equals("6"))	query += " and upper(brch_id) like upper('%"+wd+"%')";
			else if(kd.equals("7"))	query += " and nvl(R_SITE, ' ') like '%"+wd+"%'";
			else					query += " and nvl(firm_nm, ' ') like '%"+wd+"%'";

			String sort = asc.equals("0")?" asc":" desc";

	 		if(sort_gubun.equals("0"))		query += " order by fee_est_dt "+sort+", rc_dt, firm_nm";
			else if(sort_gubun.equals("1"))	query += " order by firm_nm "+sort+", rc_dt, fee_est_dt";
			else if(sort_gubun.equals("2"))	query += " order by rc_dt "+sort+", firm_nm, fee_est_dt";
			else if(sort_gubun.equals("3"))	query += " order by fee_amt "+sort+", rc_dt, firm_nm, fee_est_dt";

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
	 *	대여료스케줄 통계(전체)
	 *	R : 수금, N:미수금, T:당일, D:연체, CNT:건수, SUM:금액합계 
	 *
	 *	구분1:전체(0), 선수(1), 수금(2), 미수(3), 연체(4)
	 *	구분2:당일(0), 연체(1), 기간(2), 당일+연체(3)
	 *	st_dt, end_dt: 기간구분중 일정기간 선택일 경우 시작-종료기간
	 *  kd	  : 기타검색조건 구분(1:상호, 2: 계약자, 3:계약코드, 4:차량번호, 5:월대여료, 6:영업소코드, 7:사용본거지)
	 *  wd	  : 기타검색조건 검색어
	 *
	 *	(구분1 & 2 매칭 가능 경우)
	 *	구분1	:	구분2
	 *	0		:	0, 2
	 *	1		:	0
	 *	2		:	0, 1, 2, 3
	 *	3		:	0, 1, 2, 3
	 *	4		:	0, 2
	 *
	 **	QUERY 정보 ***
	 *	subquery 임시 칼럼 값 ( where절에서 조건 구분에 쓰임)
	 *	입금예정일 : E(0:당일이전, 1:당일, 2:예정)--> 단순하게 입금예정일과 당일 비교
	 *	수금일 : R(0:당일이전, 1:당일, 2:예정) --> 단순하게 수금일과 당일 비교
	 *	연체구분 : D(1:연체, 0:연체아님) 	--> 수금인경우 수금일 > 입금예정일, 미수금인경우 현재날짜 > 입금예정일
	 *	선수구분 : F(1:선수, 0:선수아님)	--> 수금인경우 수금일 < 입금예정일
	 *	수금상태 : RC_YN(0:미수, 1: 수금)	--> Y/N로 표시
	 *	수정할일 있을 때 참고하세요.
	 *	getFeeList와 getFeeScdStat는 값이 일치해야 하므로 같은 조건을 줘야 한다.							 	
	 */
	public Hashtable getFeeStat(String gubun1, String gubun2, String st_dt, String end_dt, String kd, String wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String inner_query = " SELECT fee_amt, rc_dt, rc_yn, E, R, F, D\n"+
							" FROM\n"+
							" (\n"+
								" SELECT\n"+
//			 							" DECODE(SIGN(TRUNC(TO_DATE(F.R_FEE_EST_DT, 'YYYYMMDD') - SYSDATE)), -1, '0', 0, '1', '2') E,\n"+ 							
			 							" decode(sign(TO_DATE(F.R_FEE_EST_DT, 'YYYYMMDD') - SYSDATE), 0, '1', 1, '2', -1, decode(sign(TO_DATE(F.R_FEE_EST_DT, 'YYYYMMDD') - SYSDATE+1), 1, '1', '0')) E,\n"+
			 							" DECODE(F.RC_DT, '', '', DECODE(SIGN(TRUNC(TO_DATE(F.RC_DT, 'YYYYMMDD') - SYSDATE)), -1, '0', 0, '1', '2')) R,\n"+
			 							" DECODE(F.RC_YN, '0', DECODE(SIGN(TRUNC(SYSDATE-TO_DATE(F.R_FEE_EST_DT, 'YYYYMMDD'))), 1, 1, 0), '1', DECODE(SIGN(TRUNC(TO_DATE(F.RC_DT, 'YYYYMMDD')-TO_DATE(F.R_FEE_EST_DT, 'YYYYMMDD'))), 1, 1, 0), 0) D,\n"+
										" DECODE(F.RC_YN, '1', DECODE(SIGN(TRUNC(TO_DATE(F.RC_DT, 'YYYYMMDD') - TO_DATE(F.R_FEE_EST_DT, 'YYYYMMDD'))), -1, '1', '0'), 0) F,\n"+
									 	" F.rent_mng_id RENT_MNG_ID, F.rent_l_cd RENT_L_CD, NVL(L.firm_nm, L.client_nm) FIRM_NM, R.car_no CAR_NO,\n"+
									 	" R.car_nm CAR_NM, F.fee_est_dt FEE_EST_DT, F.rent_st RENT_ST, F.fee_tm FEE_TM,\n"+
									 	" F.fee_s_amt+F.fee_v_amt FEE_AMT, F.r_fee_est_dt R_FEE_EST_DT,\n"+
									 	" C.brch_id BRCH_ID, F.rc_dt, F.rc_yn, C.R_SITE, L.client_nm, F.dly_days dly_days\n"+
								" FROM scd_fee F, cont C, client L, car_reg R\n"+
							 	" WHERE\n"+
									 " C.rent_mng_id = F.rent_mng_id AND\n"+
									 " C.rent_l_cd =  F.rent_l_cd AND\n"+
									 " C.client_id = L.client_id AND\n"+
									 " C.car_mng_id = R.car_mng_id(+)\n"+
							" ) where\n";

			if(gubun1.equals("0"))
			{
				if(gubun2.equals("0"))		//전체-당일((E:1 && F:0)|| (D:1 && R:1) || (D:1 && N))	입금예정일이 당일이고 선수가 아닌 데이터) & 연체된 데이타(연체수금:당일, 연체미수))
					inner_query += " (E = 1 AND F = 0) OR (D = 1 AND R = 1) OR (D = 1 AND RC_YN = '0')";
				else if(gubun2.equals("2"))	inner_query += "fee_est_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";	//전체-기간
			}
			else if(gubun1.equals("1"))
			{
				//선수-당일(F:1, R:1, Y)
				inner_query += " F = 1 AND R = 1";
			}
			else if(gubun1.equals("2"))
			{
				if(gubun2.equals("0"))// 수금-당일(E:1, 2, R:1, Y)	수금일이 당일이고 입금예정일이 당일이거나 예정인것
					inner_query += " (E = 1 OR E = 2) AND R = 1";
				else if(gubun2.equals("1"))// 수금-연체(D:1, R:1, Y)	수금일이 당일이고 연체된것
					inner_query += " D = 1 AND R = 1";
				else if(gubun2.equals("2"))//수금-기간
					inner_query += " RC_YN='1' AND RC_DT BETWEEN '"+st_dt+"' AND '"+end_dt+"'";	
				else if(gubun2.equals("3"))//수금-당일+연체((D:1, E:1, 2,  R:1, Y)
					inner_query += " ((E = 1 OR E = 2) OR D = 1) AND R = 1";
			}
			else if(gubun1.equals("3"))
			{
				if(gubun2.equals("0"))//미수-당일(E:1, N)
					inner_query += " E = 1 AND RC_YN = '0'";
				else if(gubun2.equals("1"))//미수-연체(D:1, N)
					inner_query += " D = 1 AND RC_YN = '0'";
				else if(gubun2.equals("2"))//미수-기간
					inner_query += " RC_YN='0' AND FEE_EST_DT BETWEEN '"+st_dt+"' AND '"+end_dt+"'";	
				else if(gubun2.equals("3"))//미수-당일+연체(E:0, 1,  N)
					inner_query += " (E = 1 OR D = 1) AND RC_YN = '0'";
			}
			else if(gubun1.equals("4"))
			{
				if(gubun2.equals("0"))//연체-당일(E : 1)
					inner_query += " E = 0 AND RC_YN = '0' ";
					
				else if(gubun2.equals("2"))//연체-기간
					inner_query += " E = 1 AND FEE_EST_DT BETWEEN '"+st_dt+"' AND '"+end_dt+"' AND RC_YN = '0'";
			}
			else if(gubun1.equals("5"))
			{
				inner_query += " FEE_TM = '1' ";
				//inner_query += " F = 1 AND R = 1";
			}
			
			if(kd.equals("2"))	inner_query += " and nvl(client_nm, ' ') like '%"+wd+"%'";
			else if(kd.equals("3"))	inner_query += " and upper(rent_l_cd) like upper('%"+wd+"%')";
			else if(kd.equals("4"))	inner_query += " and nvl(car_no, ' ') like '%"+wd+"%'";
			else if(kd.equals("5"))	inner_query += " and fee_amt = '"+wd+"'";
			else if(kd.equals("6"))	inner_query += " and upper(brch_id) like upper('%"+wd+"%')";
			else if(kd.equals("7"))	inner_query += " and nvl(R_SITE, ' ') like '%"+wd+"%'";
			else					inner_query += " and nvl(firm_nm, ' ') like '%"+wd+"%'";			
			
			String query =  "SELECT T_CNT, T_AMT, D_CNT, D_AMT, F_CNT, F_AMT, R_CNT, R_AMT, N_CNT, N_AMT, CNT, AMT,\n"+
									" RF_CNT, RT_CNT, RF_AMT, RT_AMT, RD_CNT, RD_AMT, NT_CNT, NT_AMT, ND_CNT, ND_AMT,\n"+
									" DECODE(RT_CNT, 0, 0, ROUND((RT_CNT/T_CNT)*100, 2)) RT_CNT_RATE, DECODE(RT_AMT, 0, 0, ROUND((RT_AMT/T_AMT)*100, 2)) RT_AMT_RATE,\n"+
									" DECODE(RD_CNT, 0, 0, ROUND((RD_CNT/D_CNT)*100, 2)) RD_CNT_RATE, DECODE(RD_AMT, 0, 0, ROUND((RD_AMT/D_AMT)*100, 2)) RD_AMT_RATE,\n"+
									" DECODE(R_CNT, 0, 0, ROUND((R_CNT/CNT)*100, 2)) R_CNT_RATE, DECODE(R_AMT, 0, 0, ROUND((R_AMT/AMT)*100, 2)) R_AMT_RATE, Z.C_FTOT , T.C_MTOT, DECODE(C_MTOT, 0, 0, ROUND((T.C_MTOT/Z.C_FTOT)*100, 2)) C_TTOT\n"+
						" FROM\n"+
						"(\n"+
							" SELECT\n"+
								" (RT_CNT+NT_CNT) T_CNT, (RT_AMT+NT_AMT) T_AMT, (RD_CNT+ND_CNT) D_CNT, (RD_AMT+ND_AMT) D_AMT,\n"+
								" RF_CNT F_CNT, RF_AMT F_AMT, \n"+
							 	" (RF_CNT+RT_CNT+RD_CNT) R_CNT, (RF_AMT+RT_AMT+RD_AMT) R_AMT, (NT_CNT+ND_CNT) N_CNT, (NT_AMT+ND_AMT) N_AMT,\n"+
							 	" (RF_CNT+RT_CNT+NT_CNT+RD_CNT+ND_CNT) CNT, (RF_AMT+RT_AMT+NT_AMT+RD_AMT+ND_AMT) AMT, RF_CNT, RT_CNT, RF_AMT, RT_AMT, RD_CNT, RD_AMT, NT_CNT, NT_AMT, ND_CNT, ND_AMT\n"+
							" FROM\n"+
							" (\n"+
							 	" SELECT MAX(RF_CNT) RF_CNT, MAX(RT_CNT) RT_CNT, MAX(RF_AMT) RF_AMT, MAX(RT_AMT) RT_AMT, MAX(RD_CNT) RD_CNT, MAX(RD_AMT) RD_AMT,\n"+
							 			" MAX(NT_CNT) NT_CNT,  MAX(NT_AMT) NT_AMT, MAX(ND_CNT) ND_CNT, MAX(ND_AMT) ND_AMT\n"+
							 	" FROM\n"+
							 	" (\n"+
							 		" (\n"+ 
							 			" SELECT COUNT(0) RF_CNT, 0 RT_CNT, SUM(fee_amt) RF_AMT, 0 RT_AMT, 0 RD_CNT, 0 RD_AMT, 0 NT_CNT, 0 NT_AMT, 0 ND_CNT, 0 ND_AMT\n"+
							 			" FROM\n"+
							 			" (\n"+ inner_query+
							 			" )\n"+
							 			" WHERE F = 1\n"+//선수
							 		" )\n"+
							 		" UNION ALL\n"+						 	
							 		" (\n"+ 
							 			" SELECT 0 RF_CNT, COUNT(0) RT_CNT, 0 RF_AMT, SUM(fee_amt) RT_AMT, 0 RD_CNT, 0 RD_AMT, 0 NT_CNT, 0 NT_AMT, 0 ND_CNT, 0 ND_AMT\n"+
							 			" FROM\n"+
							 			" (\n"+ inner_query+
							 			" )\n"+
							 			" WHERE F = 0 AND R = 1 AND E = 1\n"+
							 		" )\n"+
							 		" UNION ALL\n"+
							 		" ( \n"+
							 			" SELECT 0 RF_CNT, 0 RT_CNT, 0 RF_AMT, 0 RT_AMT, COUNT(0) RD_CNT, SUM(fee_amt) RD_AMT, 0 NT_CNT, 0 NT_AMT, 0 ND_CNT, 0 ND_AMT\n"+
							 			" FROM\n"+
							 			" (\n"+inner_query+
							 			" )\n"+
										" WHERE D = 1 AND RC_YN = '1'\n"+
							 		" )\n"+
							 		" UNION ALL\n"+
							 		" ( \n"+
							 			" SELECT 0 RF_CNT, 0 RT_CNT, 0 RF_AMT, 0 RT_AMT, 0 RD_CNT, 0 RD_AMT, COUNT(0) NT_CNT, SUM(fee_amt) NT_AMT, 0 ND_CNT, 0 ND_AMT\n"+
							 			" FROM\n"+
							 			" (\n"+inner_query+
							 			" )\n"+
							 			" WHERE E = 1 AND RC_YN = '0'\n"+
							 		" )\n"+
							 		" UNION ALL\n"+
							 		" ( \n"+
							 			" SELECT 0 RF_CNT, 0 RT_CNT, 0 RF_AMT, 0 RT_AMT, 0 RD_CNT, 0 RD_AMT, 0 NT_CNT, 0 NT_AMT, COUNT(0) ND_CNT, SUM(fee_amt) ND_AMT\n"+
							 			" FROM\n"+
							 			" (\n"+inner_query+
							 			" )\n"+
										" WHERE D = 1 AND RC_YN = '0'\n"+
							 		" )\n"+
							 	" )\n"+
							 " )\n"+
						 " ) K,\n"+
						 " (select sum(fee_s_amt+fee_v_amt) C_FTOT from scd_fee where rc_yn = '0') Z, \n" +
						 "(select sum(fee_s_amt+fee_v_amt) C_MTOT from scd_fee where rc_yn = '0' and r_fee_est_dt < to_char(sysdate,'yyyymmdd') ) T \n";
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
			System.out.println("[FeeDatabase:getFeeStat]"+e);
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
	
	public Hashtable getFeeStat()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query =  " SELECT (RT_CNT+NT_CNT) T_CNT, (RT_AMT+NT_AMT) T_AMT, (RD_CNT+ND_CNT) D_CNT, (RD_AMT+ND_AMT) D_AMT,\n"+
							" (RT_CNT+RD_CNT) R_CNT, (RT_AMT+RD_AMT) R_AMT, (NT_CNT+ND_CNT) N_CNT, (NT_AMT+ND_AMT) N_AMT, \n"+
							" (RT_CNT+NT_CNT+RD_CNT+ND_CNT) CNT, (RT_AMT+NT_AMT+RD_AMT+ND_AMT) AMT, RT_CNT, RT_AMT, RD_CNT, RD_AMT, NT_CNT, NT_AMT, ND_CNT, ND_AMT \n"+
						" FROM \n"+
							" ( \n"+
								" SELECT MAX(RT_CNT) RT_CNT, MAX(RT_AMT) RT_AMT, MAX(RD_CNT) RD_CNT, MAX(RD_AMT) RD_AMT, \n"+
									" MAX(NT_CNT) NT_CNT,  MAX(NT_AMT) NT_AMT, MAX(ND_CNT) ND_CNT, MAX(ND_AMT) ND_AMT \n"+
								" FROM \n"+
									" ( \n"+
										" ( SELECT COUNT(0) RT_CNT, SUM(fee_amt) RT_AMT, 0 RD_CNT, 0 RD_AMT, 0 NT_CNT, 0 NT_AMT, 0 ND_CNT, 0 ND_AMT \n"+
										  " FROM \n"+
										  	" ("+
										  		" SELECT DECODE(rc_yn,'0',DECODE(sign(TRUNC(TO_DATE(r_fee_est_dt, 'YYYYMMDD')) - TRUNC(SYSDATE)), -1, '00', 0, '01', '02'), '1',DECODE(sign(TRUNC(TO_DATE(r_fee_est_dt, 'YYYYMMDD')) - TRUNC(SYSDATE)), -1, '10', 0, '11', '12')) GUBUN, rc_yn, rc_dt, (fee_s_amt+fee_v_amt) FEE_AMT \n"+
										  		" FROM SCD_FEE \n"+
										  	" ) \n"+
										  " WHERE (gubun = '11' OR gubun = '12') AND rc_dt = to_char(sysdate,'YYYYMMDD')\n"+//수금당일
										" ) \n"+
										" UNION ALL \n"+
										" ( SELECT 0 RT_CNT, 0 RT_AMT, COUNT(0) RD_CNT, SUM(fee_amt) RD_AMT, 0 NT_CNT, 0 NT_AMT, 0 ND_CNT, 0 ND_AMT \n"+
										  " FROM \n"+
										 	" ( \n"+
										 		" SELECT DECODE(rc_yn,'0',DECODE(sign(TRUNC(TO_DATE(r_fee_est_dt, 'YYYYMMDD')) - TRUNC(SYSDATE)), -1, '00', 0, '01', '02'), '1',DECODE(sign(TRUNC(TO_DATE(r_fee_est_dt, 'YYYYMMDD')) - TRUNC(SYSDATE)), -1, '10', 0, '11', '12')) GUBUN, rc_yn, rc_dt, (fee_s_amt+fee_v_amt) FEE_AMT \n"+
										 		" FROM SCD_FEE \n"+
										 	" ) \n"+
										  " WHERE gubun = '10' AND rc_dt = to_char(sysdate,'YYYYMMDD')\n"+//수금연체
										 " ) \n"+
										 " UNION ALL \n"+
										 " ( SELECT 0 RT_CNT, 0 RT_AMT, 0 RD_CNT, 0 RD_AMT, COUNT(0) NT_CNT, SUM(fee_amt) NT_AMT, 0 ND_CNT, 0 ND_AMT \n"+
										 	" FROM \n"+
										 	" ( \n"+
										 		" SELECT DECODE(rc_yn,'0',DECODE(sign(TRUNC(TO_DATE(r_fee_est_dt, 'YYYYMMDD')) - TRUNC(SYSDATE)), -1, '00', 0, '01', '02'), '1',DECODE(sign(TRUNC(TO_DATE(r_fee_est_dt, 'YYYYMMDD')) - TRUNC(SYSDATE)), -1, '10', 0, '11', '12')) GUBUN, rc_yn, rc_dt, (fee_s_amt+fee_v_amt) FEE_AMT \n"+
										   		" FROM SCD_FEE \n"+
												" WHERE rc_yn='0' AND fee_est_dt = to_char(sysdate,'YYYYMMDD')\n"+
										 	" )\n"+
										 	" WHERE gubun = '01')\n"+//당일미수
										 " UNION ALL \n"+
										 " ( SELECT 0 RT_CNT, 0 RT_AMT, 0 RD_CNT, 0 RD_AMT, 0 NT_CNT, 0 NT_AMT, COUNT(0) ND_CNT, SUM(fee_amt) ND_AMT \n"+
										 	" FROM \n"+
										 	" ( \n"+
										 		" SELECT DECODE(rc_yn,'0',DECODE(sign(TRUNC(TO_DATE(r_fee_est_dt, 'YYYYMMDD')) - TRUNC(SYSDATE)), -1, '00', 0, '01', '02'), '1',DECODE(sign(TRUNC(TO_DATE(r_fee_est_dt, 'YYYYMMDD')) - TRUNC(SYSDATE)), -1, '10', 0, '11', '12')) GUBUN, rc_yn, rc_dt, (fee_s_amt+fee_v_amt) FEE_AMT \n"+
										 		 "  FROM SCD_FEE\n"+
										 	" ) \n"+
										 	" WHERE gubun = '00' )\n"+//연체미수
										 " )\n"+
						" )\n";
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
			System.out.println("[FeeDatabase:getFeeStat]"+e);
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
	 *	대여료메모
	 */
	public Vector getFeeMemo(String m_id, String l_cd, String r_st, String fee_tm, String tm_st1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = " select RENT_MNG_ID, RENT_L_CD, RENT_ST, TM_ST1, SEQ, FEE_TM, REG_ID, "+
						" substr(REG_DT, 1, 4) || '-' || substr(REG_DT, 5, 2) || '-'||substr(REG_DT, 7, 2) REG_DT, "+
						" CONTENT, SPEAKER"+
						" from dly_mm"+
						" where RENT_MNG_ID = '"+m_id+"' and RENT_L_CD = '"+l_cd+"' and RENT_ST = '"+r_st+"'"+
						" and (FEE_TM = '"+fee_tm+"' or FEE_TM = 'A') and TM_ST1 = '"+tm_st1+"' order by REG_DT desc, REG_DT_TIME desc ";		
		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
			while(rs.next())
			{
				FeeMemoBean fee_mm = new FeeMemoBean();
				fee_mm.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_mm.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_mm.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_mm.setTm_st1(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				fee_mm.setSeq(rs.getString("SEQ")==null?"":rs.getString("SEQ"));
				fee_mm.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_mm.setReg_id(rs.getString("REG_ID")==null?"":rs.getString("REG_ID"));
				fee_mm.setReg_dt(rs.getString("REG_DT")==null?"":rs.getString("REG_DT"));
				fee_mm.setContent(rs.getString("CONTENT")==null?"":rs.getString("CONTENT"));
				fee_mm.setSpeaker(rs.getString("SPEAKER")==null?"":rs.getString("SPEAKER"));
				vt.add(fee_mm);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[FeeDatabase:getFeeMemo]"+e);
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
	
	private String getSysDate()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "select to_char(sysdate, 'YYYY-MM-DD') from dual";
		String sysdate = "";
		
		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
			while(rs.next())
			{
				sysdate = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[FeeDatabase:getSysDate]"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sysdate;
		}
	}
	
	/**
	 *	현재날짜로 주일 및 공휴일을 건너뛰어 가장 가까운 평일 날짜를 리턴
	 */
	public String getValidDt()
	{
		String sysdate = getSysDate();
		boolean s_flag = false;
		boolean h_flag = false;
		String c_sysdate = "";
		String c_hol = "";
		while((!s_flag) || (!h_flag))
		{
			c_sysdate = checkSunday(sysdate);
			if(!c_sysdate.equals(sysdate))	/* 요일체크로 리턴된 날짜가 원래의 날짜와 다르다면 */
				sysdate = c_sysdate;
			else
				s_flag = true;
			
			if(s_flag && h_flag)	return sysdate;
				
			c_sysdate = checkHday(sysdate);
			if(!c_sysdate.equals(sysdate))	/* 휴일체크로 리턴된 날짜가 원래의 날짜와 다르다면 */
				sysdate = c_sysdate;
			else
				h_flag = true;
		}
		return sysdate;
	}
	
	/**
	 *	argument로 넘어온 날짜로 주일 및 공휴일을 건너뛰어 가장 가까운 평일 날짜를 리턴
	 */
	public String getValidDt(String dt)
	{	
		String sysdate = dt;
		boolean s_flag = false;
		boolean h_flag = false;
		String c_sysdate = "";
		String c_hol = "";
		while((!s_flag) || (!h_flag))
		{
			c_sysdate = checkSunday(sysdate);
			if(!c_sysdate.equals(sysdate))	/* 요일체크로 리턴된 날짜가 원래의 날짜와 다르다면 */
				sysdate = c_sysdate;
			else
				s_flag = true;
			
			if(s_flag && h_flag)	return sysdate;
				
			c_sysdate = checkHday(sysdate);
			if(!c_sysdate.equals(sysdate))	/* 휴일체크로 리턴된 날짜가 원래의 날짜와 다르다면 */
				sysdate = c_sysdate;
			else
				h_flag = true;
		}
		return sysdate;
	}
	

	/**
	 *	args로 넘어온 날짜가 일요일인지 체크해서 일요일인경우 +1 날짜를 리턴
	 */
	private String checkSunday(String dt)
	{
		getConnection();
		boolean flag = false;
		String sysdate = dt;
		String query;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String rtnStr = "";
					
		query = "select decode(to_char(to_date(?, 'YYYY-MM-DD'), 'D'),"+
					" '1', to_char(to_date(?, 'YYYY-MM-DD')+1, 'YYYY-MM-DD'), 'N')"+
					" from dual";
		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, sysdate);
			pstmt.setString(2, sysdate);
		    rs = pstmt.executeQuery();
			
			while(rs.next())
			{
				rtnStr = rs.getString(1)==null?"":rs.getString(1);
			}
			if(!rtnStr.equals("N"))	/* 일요일인 경우 하루를 더해준다 */
			sysdate = rtnStr;

			rs.close();
			pstmt.close();

		}catch (SQLException e){
			System.out.println("[FeeDatabase:checkSunday]"+e);
	  		e.printStackTrace();
		}finally{
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sysdate;
		}
	}
	
	/**
	 *	args로 넘어온 날짜가 휴일인경우 하루씩 더해서 가장 가까운 평일날짜를 리턴
	 */
	private String checkHday(String dt)
	{
		getConnection();
		boolean flag = false;
		String sysdate = dt;
		String query;
		String rStr;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String rtnStr = "";

		query = "select decode(count(0), 0, 'N', to_char(to_date(?, 'YYYY-MM-DD')+1, 'YYYY-MM-DD')) "+
				" from holiday "+
				" where hday = replace(?, '-', '')";
		try
		{
			while(!flag)
			{
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, sysdate);
				pstmt.setString(2, sysdate);
		    	rs = pstmt.executeQuery();
				while(rs.next())
				{
					rtnStr = rs.getString(1)==null?"":rs.getString(1);
				}
				if(!rtnStr.equals("N"))	sysdate = rtnStr;		/* 휴일인경우 하루를 더하고 다시 한번 휴일인지 확인 */
				else					flag = true;			/*  휴일이 아닌경우 loop를 빠져나온다. */
			}
			rs.close();
			pstmt.close();
		}catch (SQLException e)
		{
			System.out.println("[FeeDatabase:checkHday]"+e);
	  		e.printStackTrace();
		}
		finally
		{
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sysdate;
		}
	}	
	
	public Hashtable getFeebase(String m_id, String l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = " select\n"+
							" rent_l_cd, nvl(firm_nm, client_nm) firm_nm, client_nm, car_nm, fee_est_day, pp_amt, ex_pp_amt, grt_amt, ex_grt_amt,\n"+
							" fee_amt, ex_fee_amt, con_mon, ex_con_mon,\n"+
							" rent_way, rent_start_dt, rent_end_dt, init_reg_dt, ex_rent_start_dt, ex_rent_end_dt, rent_st, car_no, fee_req_day,\n"+
							" con_mon+ex_con_mon tot_con_mon,\n"+
							" (fee_amt*con_mon)+(ex_fee_amt*ex_con_mon) tot_fee_amt,\n"+
							" trunc(((fee_amt*con_mon)+(ex_fee_amt*ex_con_mon))/(con_mon+ex_con_mon)) avg_fee_amt,\n"+
							" decode( sign(sysdate - to_date(rent_start_dt, 'YYYY-MM-DD')), -1, '0', trunc(months_between(sysdate, to_date(rent_start_dt, 'YYYY-MM-DD')))) r_mon,\n"+
							" decode( sign(sysdate - to_date(rent_start_dt, 'YYYY-MM-DD')), -1, '0', trunc(sysdate-add_months(to_date(rent_start_dt, 'YYYY-MM-DD'), trunc(months_between(sysdate, to_date(rent_start_dt, 'YYYY-MM-DD')))))) r_day,\n"+
							" brch_id, ifee_amt, ex_ifee_amt, etc, client_id\n"+
						" from\n"+
						" (\n"+
							" select\n"+
								" max(rent_l_cd) rent_l_cd,\n"+
								" max(firm_nm) firm_nm,\n"+
								" max(client_nm) client_nm,\n"+ 
								" max(car_nm) car_nm,\n"+ 
								" max(fee_est_day) fee_est_day,\n"+  
								" max(pp_amt) pp_amt, max(ex_pp_amt) ex_pp_amt,\n"+ 
								" max(grt_amt) grt_amt, max(ex_grt_amt) ex_grt_amt,\n"+ 
								" max(fee_amt) fee_amt, max(ex_fee_amt) ex_fee_amt,\n"+ 
								" max(con_mon) con_mon, max(ex_con_mon) ex_con_mon,\n"+ 
								" max(rent_way) rent_way,\n"+ 
								" decode(max(rent_start_dt), '', '', substr(max(rent_start_dt), 1, 4) || '-' || substr(max(rent_start_dt), 5, 2) || '-'||substr(max(rent_start_dt), 7, 2)) RENT_START_DT,\n"+
								" decode(max(rent_end_dt), '', '', substr(max(rent_end_dt), 1, 4) || '-' || substr(max(rent_end_dt), 5, 2) || '-'||substr(max(rent_end_dt), 7, 2)) RENT_END_DT,\n"+
								" decode(max(init_reg_dt), '', '', substr(max(init_reg_dt), 1, 4) || '-' || substr(max(init_reg_dt), 5, 2) || '-'||substr(max(init_reg_dt), 7, 2)) INIT_REG_DT,\n"+
								" decode(max(ex_rent_start_dt), '', '', substr(max(ex_rent_start_dt), 1, 4) || '-' || substr(max(ex_rent_start_dt), 5, 2) || '-'||substr(max(ex_rent_start_dt), 7, 2)) EX_RENT_START_DT,\n"+
								" decode(max(ex_rent_end_dt), '', '', substr(max(ex_rent_end_dt), 1, 4) || '-' || substr(max(ex_rent_end_dt), 5, 2) || '-'||substr(max(ex_rent_end_dt), 7, 2)) EX_RENT_END_DT,\n"+
								" max(to_number(rent_st)) rent_st,\n"+
								" max(car_no) car_no,\n"+
								" max(fee_req_day) fee_req_day,\n"+
								" max(brch_id) brch_id, max(etc) etc, max(client_id) client_id,\n"+
								" max(ifee_amt) ifee_amt, max(ex_ifee_amt) ex_ifee_amt\n"+ 
							" from\n"+
							" (\n"+
									" select\n"+
										" decode(rent_st, 1, rent_l_cd, '') rent_l_cd,\n"+
										" decode(rent_st, 1, firm_nm, '') firm_nm,\n"+
										" decode(rent_st, 1, client_nm, '') client_nm,\n"+
										" decode(rent_st, 1, car_nm, '') car_nm,\n"+
										" decode(rent_st, 1, fee_est_day, '') fee_est_day,\n"+
										" decode(rent_st, 1, pp_amt, 0) pp_amt,\n"+
										" decode(rent_st, 1, grt_amt, 0) grt_amt,\n"+
										" decode(rent_st, 1, rent_way, '') rent_way,\n"+
										" decode(rent_st, 1, rent_start_dt, '') rent_start_dt,\n"+
										" decode(rent_st, 1, rent_end_dt, '') rent_end_dt,\n"+
										" decode(rent_st, 1, fee_amt, 0) fee_amt,\n"+
										" decode(rent_st, 1, init_reg_dt, '') INIT_REG_DT,\n"+
										" decode(rent_st, 1, car_no, '') car_no,\n"+
										" decode(rent_st, 1, fee_req_day, '') fee_req_day,\n"+
										" decode(rent_st, 1, con_mon, 0) con_mon,\n"+
										" decode(rent_st, 2, con_mon, 0) ex_con_mon,\n"+
										" decode(rent_st, 2, rent_start_dt, '') ex_rent_start_dt,\n"+
										" decode(rent_st, 2, rent_end_dt, '') ex_rent_end_dt,\n"+
										" decode(rent_st, 2, fee_amt, 0) ex_fee_amt,\n"+
										" decode(rent_st, 2, pp_amt, 0) ex_pp_amt,\n"+
										" decode(rent_st, 2, grt_amt, 0) ex_grt_amt,\n"+
										" rent_st,\n"+
										" brch_id, etc, client_id,\n"+
										" decode(rent_st, 1, ifee_amt, 0) ifee_amt,\n"+
										" decode(rent_st, 2, ifee_amt, 0) ex_ifee_amt\n"+
									" from\n"+
										" (\n"+
											" select F.rent_l_cd RENT_L_CD,\n"+
													" F.fee_st FEE_ST,\n"+
													" F.con_mon CON_MON,\n"+
													" F.fee_req_day FEE_REQ_DAY,\n"+
													" F.fee_est_day FEE_EST_DAY,\n"+
													" F.rent_way RENT_WAY,\n"+
													" F.rent_start_dt RENT_START_DT,\n"+
													" F.rent_end_dt RENT_END_DT,\n"+
													" F.pp_s_amt+F.pp_v_amt PP_AMT,\n"+
													" F.grt_amt_s grt_amt,\n"+
													" F.fee_s_amt+F.fee_v_amt FEE_AMT,\n"+
													" F.rent_st RENT_ST,\n"+
													" L.firm_nm FIRM_NM,\n"+
													" L.client_nm CLIENT_NM,\n"+
													" R.car_nm CAR_NM,\n"+
													" R.car_no CAR_NO,\n"+
													" R.init_reg_dt INIT_REG_DT,\n"+
													" C.brch_id BRCH_ID,\n"+
													" F.ifee_s_amt+F.ifee_v_amt IFEE_AMT, L.etc, L.client_id\n"+
											" from 	fee F, cont C, client L, car_reg R\n"+
											" where F.rent_mng_id = C.rent_mng_id and\n"+
													" F.rent_l_cd = C.rent_l_cd and\n"+
													" C.client_id = L.client_id and\n"+
													" C.car_mng_id = R.car_mng_id(+) and\n"+
													" F.rent_mng_id ='"+m_id+"' and F.rent_l_cd = '"+l_cd+"'\n"+
										" )\n"+ 
							" )\n"+
						" )\n";
		
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
			System.out.println("[FeeDatabase:getFeebase]"+e);
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
	 *	납부된 대여료,선납금,초기대여료
	 */			
	public Hashtable getPayedFee(String m_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = " select"+
							" A.sum fee_sum, A.cnt fee_cnt, B.sum pp_sum, B.cnt pp_cnt, C.sum ifee_sum, C.cnt ifee_cnt"+
						" from"+
							" ("+
							" select sum(rc_amt) sum, count(0) cnt"+
							" from scd_fee"+
							" where rent_mng_id=? and"+
									" rc_yn='1')A,"+
							" ("+
							" select sum(pp_pay_amt) sum, count(0) cnt"+
							" from scd_pre"+
							" where rent_mng_id=? and"+
									" pp_st='1' and pp_pay_amt <> 0)B,"+
							" ("+
							" select sum(pp_pay_amt) sum, count(0) cnt"+
							" from scd_pre"+
							" where rent_mng_id=? and"+
									" pp_st='2' and pp_pay_amt <> 0)C";
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, m_id);
				pstmt.setString(2, m_id);
				pstmt.setString(3, m_id);
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
			System.out.println("[FeeDatabase:getPayedFee]"+e);
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
	 *	대여료스케줄 조회 화면 펼쳐질때 호출. 연체료/일 계산.
	 */
	public boolean calDelay(String m_id, String l_cd)
	{
		getConnection();
		boolean flag = true;

		//연체일 있는 경우(입금:입금일>입금예정일, 미입금:현재날자>입금예정일)
		String query1 = " UPDATE SCD_FEE SET"+
							" dly_days = TRUNC(NVL(TO_DATE(rc_dt, 'YYYYMMDD'), SYSDATE) - TO_DATE(r_fee_est_dt, 'YYYYMMDD')),"+
							" dly_fee = (TRUNC(((fee_s_amt+fee_v_amt)*0.24*TRUNC(TO_DATE(r_fee_est_dt, 'YYYYMMDD')- NVL(TO_DATE(rc_dt, 'YYYYMMDD'), SYSDATE)))/365) * -1)"+
						" WHERE rent_mng_id = ? and rent_l_cd = ? and"+
						" SIGN(TRUNC(NVL(TO_DATE(rc_dt, 'YYYYMMDD'), SYSDATE) - TO_DATE(r_fee_est_dt, 'YYYYMMDD'))) > 0"+
						" and (rent_l_cd, rent_mng_id, rent_st) in (select a.rent_l_cd, a.rent_mng_id, a.rent_st from fee a, cont b, cont_etc c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=c.rent_l_cd and decode(c.rent_suc_dt,'',nvl(a.rent_dt,b.rent_dt),c.rent_suc_dt) < '20220101')" ;
	

		//연체일 있는 경우(입금:입금일>입금예정일, 미입금:현재날자>입금예정일)
		String query2 = " UPDATE SCD_FEE SET"+
							" dly_days = TRUNC(NVL(TO_DATE(rc_dt, 'YYYYMMDD'), SYSDATE) - TO_DATE(r_fee_est_dt, 'YYYYMMDD')),"+
							" dly_fee = (TRUNC(((fee_s_amt+fee_v_amt)*0.20*TRUNC(TO_DATE(r_fee_est_dt, 'YYYYMMDD')- NVL(TO_DATE(rc_dt, 'YYYYMMDD'), SYSDATE)))/365) * -1)"+
						" WHERE rent_mng_id = ? and rent_l_cd = ? and"+
						" SIGN(TRUNC(NVL(TO_DATE(rc_dt, 'YYYYMMDD'), SYSDATE) - TO_DATE(r_fee_est_dt, 'YYYYMMDD'))) > 0"+
						" and (rent_l_cd, rent_mng_id, rent_st) in (select a.rent_l_cd, a.rent_mng_id, a.rent_st from fee a, cont b, cont_etc c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=c.rent_l_cd and decode(c.rent_suc_dt,'',nvl(a.rent_dt,b.rent_dt),c.rent_suc_dt) >= '20220101')" ;


		//연체일 없는 경우(입금:입금일=입금예정일, 입금일<입금예정일(선수), 미입금:현재날짜<입금예정일)
		String query3 = " UPDATE SCD_FEE set"+
							" dly_days = '0',"+
							" dly_fee = 0"+
						" WHERE rent_mng_id = ? and rent_l_cd = ? and"+
							" SIGN(TRUNC(NVL(TO_DATE(rc_dt, 'YYYYMMDD'), SYSDATE) - TO_DATE(r_fee_est_dt, 'YYYYMMDD'))) < 1";

		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;

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

		    pstmt3 = conn.prepareStatement(query3);
			pstmt3.setString(1, m_id);
			pstmt3.setString(2, l_cd);
		    pstmt3.executeUpdate();
			pstmt3.close();

			conn.commit();
		    
	  	} catch (Exception e) {
	  		System.out.println("[FeeDatabase:calDelay]"+e);
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt1 != null )		pstmt1.close();
				if(pstmt2 != null)		pstmt2.close();
				if(pstmt3 != null)		pstmt3.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	/**
	 *	연체료/일 계산. -- 개별 row
	 */
	public boolean calDelay(String m_id, String l_cd, String fee_tm)
	{
		getConnection();
		boolean flag = true;

		String query = " UPDATE SCD_FEE SET"+
							" dly_days = DECODE(SIGN(TRUNC(NVL(TO_DATE(rc_dt, 'YYYYMMDD'), SYSDATE) - TO_DATE(r_fee_est_dt, 'YYYYMMDD'))) , 1, TRUNC(NVL(TO_DATE(rc_dt, 'YYYYMMDD'), SYSDATE) - TO_DATE(r_fee_est_dt, 'YYYYMMDD')), '0'),"+
							" dly_fee = DECODE(SIGN(TRUNC(NVL(TO_DATE(rc_dt, 'YYYYMMDD'), SYSDATE) - TO_DATE(r_fee_est_dt, 'YYYYMMDD'))) , 1, (TRUNC(((fee_s_amt+fee_v_amt)*0.24*TRUNC(TO_DATE(r_fee_est_dt, 'YYYYMMDD')- NVL(TO_DATE(rc_dt, 'YYYYMMDD'), SYSDATE)))/365) * -1), '0')"+
						" WHERE rent_mng_id=? AND"+
						  	" rent_l_cd=? AND"+
						  	" fee_tm=?"+
							" and (rent_l_cd, rent_mng_id, rent_st) in (select a.rent_l_cd, a.rent_mng_id, a.rent_st from fee a, cont b, cont_etc c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=c.rent_l_cd and decode(c.rent_suc_dt,'',nvl(a.rent_dt,b.rent_dt),c.rent_suc_dt) < '20220101')" ;

		String query2 = " UPDATE SCD_FEE SET"+
							" dly_days = DECODE(SIGN(TRUNC(NVL(TO_DATE(rc_dt, 'YYYYMMDD'), SYSDATE) - TO_DATE(r_fee_est_dt, 'YYYYMMDD'))) , 1, TRUNC(NVL(TO_DATE(rc_dt, 'YYYYMMDD'), SYSDATE) - TO_DATE(r_fee_est_dt, 'YYYYMMDD')), '0'),"+
							" dly_fee = DECODE(SIGN(TRUNC(NVL(TO_DATE(rc_dt, 'YYYYMMDD'), SYSDATE) - TO_DATE(r_fee_est_dt, 'YYYYMMDD'))) , 1, (TRUNC(((fee_s_amt+fee_v_amt)*0.20*TRUNC(TO_DATE(r_fee_est_dt, 'YYYYMMDD')- NVL(TO_DATE(rc_dt, 'YYYYMMDD'), SYSDATE)))/365) * -1), '0')"+
						" WHERE rent_mng_id=? AND"+
						  	" rent_l_cd=? AND"+
						  	" fee_tm=?"+
							" and (rent_l_cd, rent_mng_id, rent_st) in (select a.rent_l_cd, a.rent_mng_id, a.rent_st from fee a, cont b, cont_etc c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=c.rent_l_cd and decode(c.rent_suc_dt,'',nvl(a.rent_dt,b.rent_dt),c.rent_suc_dt) >= '20220101')" ;
		
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		try 
		{
			conn.setAutoCommit(false);
				
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, m_id);
			pstmt.setString(2, l_cd);
			pstmt.setString(3, fee_tm);
		    pstmt.executeUpdate();
			pstmt.close();

			pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString(1, m_id);
			pstmt2.setString(2, l_cd);
			pstmt2.setString(3, fee_tm);
		    pstmt2.executeUpdate();
			pstmt2.close();

			conn.commit();
	  	} catch (Exception e) {
	  		e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{	
				if(pstmt != null )		pstmt.close();
				if(pstmt2 != null )		pstmt2.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}	
}