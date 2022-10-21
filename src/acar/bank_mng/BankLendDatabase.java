package acar.bank_mng;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
//import acar.pos_client.*;

public class BankLendDatabase
{
	private Connection conn = null;
	public static BankLendDatabase db;
	
	public static BankLendDatabase getInstance()
	{
		if(BankLendDatabase.db == null)
			BankLendDatabase.db = new BankLendDatabase();
		return BankLendDatabase.db;
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
	 *	은행대출 INSERT
	 */
	public BankLendBean insertBankLend(BankLendBean bl)
	{
		getConnection();
		String query_seq = "SELECT NVL(TO_CHAR(MAX(TO_NUMBER(lend_id))+1, '0000'), '0001') lend_id"+
							" FROM LEND_BANK";

		String query = "insert into LEND_BANK (LEND_ID, CONT_DT, CONT_BN, CONT_ST, BN_BR, BN_TEL,"+
							" BN_FAX, LEND_NO, CONT_AMT, LEND_INT_AMT, LEND_INT, RTN_TOT_AMT,"+
							" CONT_START_DT, CONT_END_DT, CONT_TERM, RTN_EST_DT, ALT_AMT,"+
							" RTN_CDT, RTN_WAY, F_RAT, CONDI, DOCS, PM_AMT, LEND_A_AMT, PM_REST_AMT,"+
							" CHARGE_AMT, NTRL_FEE, STP_FEE, BOND_GET_ST, FST_PAY_DT, FST_PAY_AMT,"+
							" move_st, lend_lim, rtn_su) values"+
							" (?, replace(?, '-', ''), ?, ?, ?, ?, ?, ?, ?, ?,"+
							" ?, ?, replace(?, '-', ''), replace(?, '-', ''), ?, ?, ?, ?, ?, ?,"+
							" ?, ?, ?, ?, ?, ?, ?, ?, ?, replace(?, '-', ''), ?,"+
							" ?, ?, ?)";
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		try 
		{
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query_seq);
		    rs = pstmt1.executeQuery();
			while(rs.next())
			{
				bl.setLend_id(rs.getString("lend_id")==null?"0001":rs.getString("lend_id"));
			}
			rs.close();
			pstmt1.close();

			pstmt2 = conn.prepareStatement(query);
			pstmt2.setString(1, bl.getLend_id().trim());
			pstmt2.setString(2, bl.getCont_dt().trim());		
			pstmt2.setString(3, bl.getCont_bn());	
			pstmt2.setString(4, bl.getCont_st());
			pstmt2.setString(5, bl.getBn_br());
			pstmt2.setString(6, bl.getBn_tel());
			pstmt2.setString(7, bl.getBn_fax());
			pstmt2.setString(8, bl.getLend_no());
			pstmt2.setLong  (9, bl.getCont_amt());
			pstmt2.setInt   (10, bl.getLend_int_amt());
			pstmt2.setString(11, bl.getLend_int());
			pstmt2.setInt   (12, bl.getRtn_tot_amt());
			pstmt2.setString(13, bl.getCont_start_dt().trim());
			pstmt2.setString(14, bl.getCont_end_dt().trim());
			pstmt2.setString(15, bl.getCont_term());
			pstmt2.setString(16, bl.getRtn_est_dt());
			pstmt2.setInt   (17, bl.getAlt_amt());
			pstmt2.setString(18, bl.getRtn_cdt());
			pstmt2.setString(19, bl.getRtn_way());
			pstmt2.setString(20, bl.getF_rat());
			pstmt2.setString(21, bl.getCondi());
			pstmt2.setString(22, bl.getDocs());
			pstmt2.setInt   (23, bl.getPm_amt());
			pstmt2.setLong  (24, bl.getLend_a_amt());
			pstmt2.setLong  (25, bl.getPm_rest_amt());
			pstmt2.setInt   (26, bl.getCharge_amt());
			pstmt2.setInt   (27, bl.getNtrl_fee());
			pstmt2.setInt   (28, bl.getStp_fee());
			pstmt2.setString(29, bl.getBond_get_st());
			pstmt2.setString(30, "");//bl.getFst_pay_dt());
			pstmt2.setInt   (31,0);// bl.getFst_pay_amt());
			pstmt2.setString(32, bl.getMove_st());
			pstmt2.setString(33, bl.getLend_lim());
			pstmt2.setString(34, bl.getRtn_su());									
			pstmt2.executeUpdate();
		    pstmt2.close();

			conn.commit();

	  	} catch (Exception e) {
	  		e.printStackTrace();
	  		bl = null;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
                if(rs != null )		rs.close();
                if(pstmt1 != null)	pstmt1.close();
                if(pstmt2 != null)	pstmt2.close();
			}catch(Exception ignore){}
			closeConnection();
			return bl;
		}			
	}

	/**
	 *	은행대출 UPDATE
	 */
	public boolean updateBankLend(BankLendBean bl)
	{
		getConnection();
		boolean flag = true;
		String query = "update LEND_BANK set"+
						" CONT_DT = replace(?, '-', ''),"+
						" CONT_BN = ?,"+
						" CONT_ST = ?,"+
						" BN_BR = ?,"+
						" BN_TEL = ?,"+
						" BN_FAX = ?,"+
						" LEND_NO = ?,"+
						" CONT_AMT = ?,"+
						" LEND_INT_AMT = ?,"+
						" LEND_INT = ?,"+
						" RTN_TOT_AMT = ?,"+
						" CONT_START_DT = replace(?, '-', ''),"+
						" CONT_END_DT = replace(?, '-', ''),"+
						" CONT_TERM = ?,"+
						" RTN_EST_DT = ?,"+
						" ALT_AMT = ?,"+
						" RTN_CDT = ?,"+
						" RTN_WAY = ?,"+
						" F_RAT = ?,"+
						" CONDI = ?,"+
						" DOCS = ?,"+
						" PM_AMT = ?,"+
						" LEND_A_AMT = ?,"+
						" PM_REST_AMT = ?,"+
						" CHARGE_AMT = ?,"+
						" NTRL_FEE = ?,"+
						" STP_FEE = ?,"+
						" BOND_GET_ST = ?,"+
						" FST_PAY_DT = replace(?, '-', ''),"+
						" FST_PAY_AMT = ?"+
						" where LEND_ID = ?";
		PreparedStatement pstmt = null;
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, bl.getCont_dt());		
			pstmt.setString(2, bl.getCont_bn());	
			pstmt.setString(3, bl.getCont_st());
			pstmt.setString(4, bl.getBn_br());
			pstmt.setString(5, bl.getBn_tel());
			pstmt.setString(6, bl.getBn_fax());
			pstmt.setString(7, bl.getLend_no());
			pstmt.setLong(8, bl.getCont_amt());
			pstmt.setInt(9,  bl.getLend_int_amt());
			pstmt.setString(10, bl.getLend_int());
			pstmt.setInt(11, bl.getRtn_tot_amt());
			pstmt.setString(12, bl.getCont_start_dt());
			pstmt.setString(13, bl.getCont_end_dt());
			pstmt.setString(14, bl.getCont_term());
			pstmt.setString(15, bl.getRtn_est_dt());
			pstmt.setInt(16, bl.getAlt_amt());
			pstmt.setString(17, bl.getRtn_cdt());
			pstmt.setString(18, bl.getRtn_way());
			pstmt.setString(19, bl.getF_rat());
			pstmt.setString(20, bl.getCondi());
			pstmt.setString(21, bl.getDocs());
			pstmt.setInt(22, bl.getPm_amt());
			pstmt.setLong(23, bl.getLend_a_amt());
			pstmt.setLong(24, bl.getPm_rest_amt());
			pstmt.setInt(25, bl.getCharge_amt());
			pstmt.setInt(26, bl.getNtrl_fee());
			pstmt.setInt(27, bl.getStp_fee());
			pstmt.setString(28, bl.getBond_get_st());
			pstmt.setString(29, bl.getFst_pay_dt());
			pstmt.setInt(30, bl.getFst_pay_amt());
			pstmt.setString(31, bl.getLend_id());
			
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
	 * 은행대출 SELECT
	 */
	public BankLendBean getBankLend(String lend_id)
	{
		getConnection();
		BankLendBean bl = new BankLendBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	" SELECT LEND_ID, CONT_BN, CONT_ST, BN_BR, BN_TEL, BN_FAX, LEND_NO, CONT_AMT,"+
								" LEND_INT_AMT, LEND_INT, RTN_TOT_AMT, rtrim(CONT_TERM) cont_term, ALT_AMT,"+
								" RTN_CDT, RTN_WAY, F_RAT, CONDI, DOCS, PM_AMT, LEND_A_AMT, PM_REST_AMT,"+
						 		" decode(CONT_DT, '', '', substr(CONT_DT, 1, 4)||'-'||substr(CONT_DT, 5, 2)||'-'||substr(CONT_DT, 7, 2)) CONT_DT,"+
						 		" decode(CONT_START_DT, '', '', substr(CONT_START_DT, 1, 4)||'-'||substr(CONT_START_DT, 5, 2)||'-'||substr(CONT_START_DT, 7, 2)) CONT_START_DT,"+
						 		" decode(CONT_END_DT, '', '', substr(CONT_END_DT, 1, 4)||'-'||substr(CONT_END_DT, 5, 2)||'-'||substr(CONT_END_DT, 7, 2)) CONT_END_DT,"+
						 		" RTN_EST_DT, CHARGE_AMT, NTRL_FEE, STP_FEE, BOND_GET_ST, FST_PAY_AMT,"+
						 		" decode(FST_PAY_DT, '', '', substr(FST_PAY_DT, 1, 4)||'-'||substr(FST_PAY_DT, 5, 2)||'-'||substr(FST_PAY_DT, 7, 2)) FST_PAY_DT"+
						 " FROM LEND_BANK"+
						 " WHERE LEND_ID = ?";
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, lend_id);
		    	rs = pstmt.executeQuery();
			while(rs.next())
			{
				bl.setLend_id(rs.getString("LEND_ID")==null?"":rs.getString("LEND_ID"));
				bl.setCont_dt(rs.getString("CONT_DT")==null?"":rs.getString("CONT_DT"));
				bl.setCont_bn(rs.getString("CONT_BN")==null?"":rs.getString("CONT_BN"));
				bl.setCont_st(rs.getString("CONT_ST")==null?"":rs.getString("CONT_ST"));
				bl.setBn_br(rs.getString("BN_BR")==null?"":rs.getString("BN_BR"));
				bl.setBn_tel(rs.getString("BN_TEL")==null?"":rs.getString("BN_TEL"));
				bl.setBn_fax(rs.getString("BN_FAX")==null?"":rs.getString("BN_FAX"));
				bl.setLend_no(rs.getString("LEND_NO"));
				bl.setCont_amt(rs.getInt("CONT_AMT"));
				bl.setLend_int_amt(rs.getInt("LEND_INT_AMT"));
				bl.setLend_int(rs.getString("LEND_INT")==null?"":rs.getString("LEND_INT"));
				bl.setRtn_tot_amt(rs.getInt("RTN_TOT_AMT"));
				bl.setCont_start_dt(rs.getString("CONT_START_DT")==null?"":rs.getString("CONT_START_DT"));
				bl.setCont_end_dt(rs.getString("CONT_END_DT")==null?"":rs.getString("CONT_END_DT"));
				bl.setCont_term(rs.getString("CONT_TERM")==null?"":rs.getString("CONT_TERM"));
				bl.setRtn_est_dt(rs.getString("RTN_EST_DT")==null?"":rs.getString("RTN_EST_DT"));
				bl.setAlt_amt(rs.getInt("ALT_AMT"));
				bl.setRtn_cdt(rs.getString("RTN_CDT")==null?"":rs.getString("RTN_CDT"));
				bl.setRtn_way(rs.getString("RTN_WAY")==null?"":rs.getString("RTN_WAY"));
				bl.setF_rat(rs.getString("F_RAT")==null?"":rs.getString("F_RAT"));
				bl.setCondi(rs.getString("CONDI")==null?"":rs.getString("CONDI"));
				bl.setDocs(rs.getString("DOCS")==null?"":rs.getString("DOCS"));
				bl.setPm_amt(rs.getInt("PM_AMT"));
				bl.setLend_a_amt(rs.getInt("LEND_A_AMT"));
				bl.setPm_rest_amt(rs.getInt("PM_REST_AMT"));
				bl.setCharge_amt(rs.getInt("CHARGE_AMT"));
				bl.setNtrl_fee(rs.getInt("NTRL_FEE"));
				bl.setStp_fee(rs.getInt("STP_FEE"));
				bl.setBond_get_st(rs.getString("BOND_GET_ST")==null?"":rs.getString("BOND_GET_ST"));
				bl.setFst_pay_dt(rs.getString("FST_PAY_DT")==null?"":rs.getString("FST_PAY_DT"));
				bl.setFst_pay_amt(rs.getString("FST_PAY_AMT")==null?0:Integer.parseInt(rs.getString("FST_PAY_AMT")));

			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[BankLendDatabase:getBankLend(lend_id)]"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bl;
		}
	}

	
	/**
	 *	은행대출별 관리자
	 */
	public BankAgntBean getBankAgnt(String lend_id, String seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		BankAgntBean ba = null;
		String query = 	" select"+
							" LEND_ID, SEQ, BA_NM, BA_TITLE, BA_TEL, BA_EMAIL"+
							" from bank_agnt "+
							" where LEND_ID=? AND SEQ=?";
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, lend_id);
				pstmt.setString(2, seq);
		    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				ba = new BankAgntBean();
				ba.setLend_id(rs.getString("LEND_ID")==null?"":rs.getString("LEND_ID"));
				ba.setSeq(rs.getString("SEQ")==null?"":rs.getString("SEQ"));
				ba.setBa_nm(rs.getString("BA_NM")==null?"":rs.getString("BA_NM"));
				ba.setBa_title(rs.getString("BA_TITLE")==null?"":rs.getString("BA_TITLE"));
				ba.setBa_tel(rs.getString("BA_TEL")==null?"":rs.getString("BA_TEL"));
				ba.setBa_email(rs.getString("BA_EMAIL")==null?"":rs.getString("BA_EMAIL"));
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
			return ba;
		}
	}
	
	/**
	 *	은행대출별 관리자 리스트
	 */
	public Vector getBankAgnts(String lend_id)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	" select"+
							" LEND_ID, SEQ, BA_NM, BA_TITLE, BA_TEL, BA_EMAIL"+
							" from BANK_AGNT "+
							" where LEND_ID=?";
						
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, lend_id);
		    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				BankAgntBean ba = new BankAgntBean();
				ba.setLend_id(rs.getString("LEND_ID")==null?"":rs.getString("LEND_ID"));
				ba.setSeq(rs.getString("SEQ")==null?"":rs.getString("SEQ"));
				ba.setBa_nm(rs.getString("BA_NM")==null?"":rs.getString("BA_NM"));
				ba.setBa_title(rs.getString("BA_TITLE")==null?"":rs.getString("BA_TITLE"));
				ba.setBa_tel(rs.getString("BA_TEL")==null?"":rs.getString("BA_TEL"));
				ba.setBa_email(rs.getString("BA_EMAIL")==null?"":rs.getString("BA_EMAIL"));
				vt.add(ba);
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
	 *	은행대출 관리자 INSERT
	 */
	public boolean insertBankAgnt(BankAgntBean ba)
	{
		getConnection();
		boolean flag = true;
		String query_seq = "SELECT ltrim(NVL(TO_CHAR(MAX(TO_NUMBER(seq))+1, '0'), '0')) seq"+
							" FROM BANK_AGNT"+
							" WHERE lend_id=?";

		String query = "insert into BANK_AGNT (LEND_ID, SEQ, BA_NM, BA_TITLE, BA_TEL, BA_EMAIL) values"+
						" (?, ?, ?, ?, ?, ?)";
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		try 
		{
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query_seq);
			pstmt1.setString(1, ba.getLend_id());
		    rs = pstmt1.executeQuery();
			while(rs.next())
			{
				ba.setSeq(rs.getString("seq")==null?"0001":rs.getString("seq"));
			}
			rs.close();
			pstmt1.close();

			pstmt2 = conn.prepareStatement(query);
			pstmt2.setString(1, ba.getLend_id());
			pstmt2.setString(2, ba.getSeq());
			pstmt2.setString(3, ba.getBa_nm());
			pstmt2.setString(4, ba.getBa_title());
			pstmt2.setString(5, ba.getBa_tel());
			pstmt2.setString(6, ba.getBa_email());
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
				if(rs != null )		rs.close();
				if(pstmt1 != null)	pstmt1.close();
				if(pstmt2 != null)	pstmt2.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}
	
	/**
	 *	은행대출 관리자 UPDATE
	 */
	public boolean updateBankAgnt(BankAgntBean ba)
	{
		getConnection();
		boolean flag = true;
		String query_seq = "update bank_agnt set"+
								" BA_NM = ?,"+
								" BA_TITLE = ?,"+
								" BA_TEL = ?,"+
								" BA_EMAIL = ?"+
								" where LEND_ID = ? and SEQ = ?";
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);
					
			pstmt = conn.prepareStatement(query_seq);
			pstmt.setString(1, ba.getBa_nm());
			pstmt.setString(2, ba.getBa_title());
			pstmt.setString(3, ba.getBa_tel());
			pstmt.setString(4, ba.getBa_email());
			pstmt.setString(5, ba.getLend_id());
			pstmt.setString(6, ba.getSeq());
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
	 *	은행대출 스케줄 INSERT
	 */
	public boolean insertBankScd(BankScdBean bs)
	{
		getConnection();
		boolean flag = true;

		String query = "insert into BANK_SCHE (LEND_ID, ALT_TM, ALT_EST_DT, ALT_PRN_AMT, ALT_INT_AMT, PAY_DT, PAY_YN, ALT_REST) values"+
						" (?, ?, replace(?, '-', ''), ?, ?, replace(?, '-', ''), ?, ?)";
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, bs.getLend_id());
			pstmt.setString(2, bs.getAlt_tm());
			pstmt.setString(3, bs.getAlt_est_dt());
			pstmt.setInt(4, bs.getAlt_prn_amt());
			pstmt.setInt(5, bs.getAlt_int_amt());
			pstmt.setString(6, bs.getPay_dt());
			pstmt.setString(7, bs.getPay_yn());
			pstmt.setLong(8, bs.getAlt_rest());

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
	 *	은행대출 스케줄 UPDATE
	 */
	public boolean updateBankScd(BankScdBean bs)
	{
		getConnection();
		boolean flag = true;
		String query_seq = "update BANK_SCHE set"+
								" ALT_EST_DT = replace(?, '-', ''),"+
								" ALT_PRN_AMT = ?,"+
								" ALT_INT_AMT = ?,"+
								" PAY_DT = replace(?, '-', ''),"+
								" PAY_YN = ?,"+
								" ALT_REST = ?"+
								" where LEND_ID = ? and ALT_TM = ?";
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);
				
			pstmt = conn.prepareStatement(query_seq);
			pstmt.setString(1, bs.getAlt_est_dt());
			pstmt.setInt(2, bs.getAlt_prn_amt());
			pstmt.setInt(3, bs.getAlt_int_amt());
			pstmt.setString(4, bs.getPay_dt());
			pstmt.setString(5, bs.getPay_yn());
			pstmt.setLong(6, bs.getAlt_rest());
			pstmt.setString(7, bs.getLend_id());
			pstmt.setString(8, bs.getAlt_tm());
			
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
	 *	은행대출 스케줄
	 */
	public Vector getBankScds(String lend_id)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	" select"+
							" LEND_ID, ALT_TM, ALT_PRN_AMT, ALT_INT_AMT, PAY_YN, ALT_REST,"+
							" decode(ALT_EST_DT, '', '', substr(ALT_EST_DT, 1, 4)||'-'||substr(ALT_EST_DT, 5, 2)||'-'||substr(ALT_EST_DT, 7, 2)) ALT_EST_DT,"+
							" decode(PAY_DT, '', '', substr(PAY_DT, 1, 4)||'-'||substr(PAY_DT, 5, 2)||'-'||substr(PAY_DT, 7, 2)) PAY_DT, cls_rtn_dt"+
							" from BANK_SCHE"+
							" where LEND_ID=? order by to_number(alt_tm)";
						
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, lend_id);
		    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				BankScdBean bs = new BankScdBean();
				bs.setLend_id(rs.getString("LEND_ID")==null?"":rs.getString("LEND_ID"));
				bs.setAlt_tm(rs.getString("ALT_TM")==null?"":rs.getString("ALT_TM"));
				bs.setAlt_est_dt(rs.getString("ALT_EST_DT")==null?"":rs.getString("ALT_EST_DT"));
				bs.setAlt_prn_amt(rs.getInt("ALT_PRN_AMT"));
				bs.setAlt_int_amt(rs.getInt("ALT_INT_AMT"));
				bs.setPay_dt(rs.getString("PAY_DT")==null?"":rs.getString("PAY_DT"));
				bs.setPay_yn(rs.getString("PAY_YN")==null?"":rs.getString("PAY_YN"));
				bs.setAlt_rest(rs.getInt("ALT_REST"));
				bs.setCls_rtn_dt(rs.getString("cls_rtn_dt")==null?"":rs.getString("cls_rtn_dt"));

				vt.add(bs);
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
	 *	은행대출 스케줄(개별)
	 */
	public BankScdBean getBankScd(String lend_id, String alt_tm)
	{
		getConnection();
		BankScdBean bs = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	" select"+
							" LEND_ID, ALT_TM, ALT_EST_DT, ALT_PRN_AMT, ALT_INT_AMT, PAY_DT, PAY_YN, ALT_REST"+
							" from BANK_SCHE"+
							" where LEND_ID=? and ALT_TM = ?";
						
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, lend_id);
				pstmt.setString(2, alt_tm);
		    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				bs = new BankScdBean();
				bs.setLend_id(rs.getString("LEND_ID")==null?"":rs.getString("LEND_ID"));
				bs.setAlt_tm(rs.getString("ALT_TM")==null?"":rs.getString("ALT_TM"));
				bs.setAlt_est_dt(rs.getString("ALT_EST_DT")==null?"":rs.getString("ALT_EST_DT"));
				bs.setAlt_prn_amt(rs.getInt("ALT_PRN_AMT"));
				bs.setAlt_int_amt(rs.getInt("ALT_INT_AMT"));
				bs.setPay_dt(rs.getString("PAY_DT")==null?"":rs.getString("PAY_DT"));
				bs.setPay_yn(rs.getString("PAY_YN")==null?"":rs.getString("PAY_YN"));
				bs.setAlt_rest(rs.getInt("ALT_REST"));
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
			return bs;
		}
	}		
	
	/**
	 *	은행대출리스트
	 *	bank_id : 은행코드
	 */
	public Vector getBankLendList(String bank_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = " SELECT A.lend_id lend_id, decode(C.lend_id, '', 'N', 'Y') scd_yn, bank_nm, cont_st, bn_br, cont_term,"+
								" cont_amt, cont_dt, pm_amt, pm_rest_amt, cont_start_dt, B.ba_nm ba_nm"+
						" FROM"+
						" (SELECT L.lend_id lend_id, C.nm_cd bank_nm, L.cont_st cont_st, L.bn_br bn_br, L.cont_term cont_term,"+
						 		" L.cont_amt cont_amt, DECODE(L.cont_dt, '', '', SUBSTR(L.cont_dt, 1, 4)||'-'||SUBSTR(L.cont_dt, 5, 2)||'-'||SUBSTR(L.cont_dt, 7, 2)) cont_dt,"+
								" L.pm_amt pm_amt,L.pm_rest_amt pm_rest_amt,"+
								" DECODE(L.cont_start_dt, '', '', SUBSTR(L.cont_start_dt, 1, 4)||'-'||SUBSTR(L.cont_start_dt, 5, 2)||'-'||SUBSTR(L.cont_start_dt, 7, 2)) cont_start_dt"+
						" FROM LEND_BANK L, CODE C"+
						" WHERE L.cont_bn = C.CODE AND"+
							  " C.c_st = '0003' AND"+
							  " C.CODE <> '0000' AND"+
							  " c.CODE LIKE '%"+bank_id+"%')A,"+
						" (SELECT ba_nm, lend_id"+
						" FROM  BANK_AGNT"+
						" WHERE seq = '0')B,"+
						" (SELECT lend_id"+
						" FROM BANK_SCHE"+
						" WHERE alt_tm = '1')C"+
						" WHERE A.lend_id = B.lend_id(+) AND"+
							  	" A.lend_id = C.lend_id(+)";
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
	 *	은행대출과 매핑할 계약 리스트(현재는 하나은행으로 할부금이 등록된 계약리스트)
	 */
	public Vector getMappingContList()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = " SELECT R.car_mng_id car_mng_id,"+
							" DECODE(C.rent_dt, '', '', SUBSTR(C.rent_dt, 1, 4)||'-'||SUBSTR(C.rent_dt, 5, 2)||'-'||SUBSTR(C.rent_dt, 7, 2)) rent_dt,"+
							" C.rent_l_cd rent_l_cd, NVL(L.firm_nm, L.client_nm) firm_nm, R.CAR_NM car_nm, R.car_no car_no"+
							" FROM CONT C, ALLOT A, CLIENT L, CAR_REG R"+
						" WHERE C.rent_mng_id = A.rent_mng_id AND"+
								  " C.rent_l_cd = A.rent_l_cd AND"+
								  " C.client_id = L.client_id AND"+
								  " C.car_mng_id = R.car_mng_id AND"+
								  " A.cpt_cd='0001' AND"+			  //하나은행
								  " C.car_mng_id not in (select car_mng_id from car_bank)";
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
	 *	은행대출리스트
	 *	bank_id : 은행코드
	 */
	public Vector getContList(String bank_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = " SELECT C.rent_l_cd rent_l_cd, NVL(L.firm_nm, L.client_nm) firm_nm, R.CAR_NM CAR_NM,"+
								" R.car_no car_no, B.sup_amt sup_amt, B.loan_amt loan_amt, R.car_mng_id car_mng_id,"+
								" DECODE(B.loan_st_dt, '', '', SUBSTR(B.loan_st_dt, 1, 4)||'-'||SUBSTR(B.loan_st_dt, 5, 2)||'-'||SUBSTR(B.loan_st_dt, 7, 2)) loan_st_dt,"+
								" DECODE(B.loan_ack_dt, '', '', SUBSTR(B.loan_ack_dt, 1, 4)||'-'||SUBSTR(B.loan_ack_dt, 5, 2)||'-'||SUBSTR(B.loan_ack_dt, 7, 2)) loan_ack_dt,"+
								" DECODE(B.loan_rec_dt, '', '', SUBSTR(B.loan_rec_dt, 1, 4)||'-'||SUBSTR(B.loan_rec_dt, 5, 2)||'-'||SUBSTR(B.loan_rec_dt, 7, 2)) loan_rec_dt"+
								" FROM CAR_BANK B, CAR_REG R, CONT C, CLIENT L"+
						" WHERE B.car_mng_id = R.car_mng_id AND"+
								" C.car_mng_id = R.car_mng_id AND"+ 
								" C.client_id = L.client_id AND"+
						  		" lend_id = ?";
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, bank_id);
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
	 *	은행 매핑 테이블 SELECT
	 */

	public BankMappingBean getBankMapping(String lend_id, String car_mng_id)
	{
		getConnection();
		BankMappingBean bm = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	" select"+
							" B.CAR_MNG_ID CAR_MNG_ID, B.LEND_ID LEND_ID, B.SUP_AMT SUP_AMT, B.LOAN_AMT LOAN_AMT,"+
							" rtrim(B.F_RAT) F_RAT, B.F_AMT F_AMT, rtrim(B.F_TERM) F_TERM, B.DAYS DAYS, B.DIF_AMT DIF_AMT, B.NOTE NOTE,"+
							" decode(B.LOAN_ST_DT, '', '', substr(B.LOAN_ST_DT, 1, 4)||'-'||substr(B.LOAN_ST_DT, 5, 2)||'-'||substr(B.LOAN_ST_DT, 7, 2)) LOAN_ST_DT,"+
							" decode(B.REF_DT, '', '', substr(B.REF_DT, 1, 4)||'-'||substr(B.REF_DT, 5, 2)||'-'||substr(B.REF_DT, 7, 2)) REF_DT,"+
							" decode(B.SUP_DT, '', '', substr(B.SUP_DT, 1, 4)||'-'||substr(B.SUP_DT, 5, 2)||'-'||substr(B.SUP_DT, 7, 2)) SUP_DT,"+
							" decode(B.LOAN_END_DT, '', '', substr(B.LOAN_END_DT, 1, 4)||'-'||substr(B.LOAN_END_DT, 5, 2)||'-'||substr(B.LOAN_END_DT, 7, 2)) LOAN_END_DT,"+
							" decode(B.LOAN_ACK_DT, '', '', substr(B.LOAN_ACK_DT, 1, 4)||'-'||substr(B.LOAN_ACK_DT, 5, 2)||'-'||substr(B.LOAN_ACK_DT, 7, 2)) LOAN_ACK_DT,"+
							" decode(B.LOAN_REC_DT, '', '', substr(B.LOAN_REC_DT, 1, 4)||'-'||substr(B.LOAN_REC_DT, 5, 2)||'-'||substr(B.LOAN_REC_DT, 7, 2)) LOAN_REC_DT,"+
							" decode(C.RENT_DT, '', '', substr(C.RENT_DT, 1, 4)||'-'||substr(C.RENT_DT, 5, 2)||'-'||substr(C.RENT_DT, 7, 2)) RENT_DT,"+
							" C.rent_l_cd RENT_L_CD, nvl(L.firm_nm, L.client_nm) FIRM_NM, R.car_nm CAR_NM, R.car_no CAR_NO"+
							" from CAR_BANK B, cont c, car_reg R, client L"+
							" where B.car_mng_id = R.car_mng_id and"+
									" C.car_mng_id = R.car_mng_id and"+
									" C.client_id = L.client_id and"+
									" B.LEND_ID=? and B.CAR_MNG_ID = ?";
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, lend_id);
				pstmt.setString(2, car_mng_id);
		    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				bm = new BankMappingBean();
				bm.setCar_mng_id(rs.getString("CAR_MNG_ID")==null?"":rs.getString("CAR_MNG_ID"));
				bm.setLend_id(rs.getString("LEND_ID")==null?"":rs.getString("LEND_ID"));
				bm.setLoan_st_dt(rs.getString("LOAN_ST_DT")==null?"":rs.getString("LOAN_ST_DT"));
				bm.setSup_amt(rs.getInt("SUP_AMT"));
				bm.setLoan_amt(rs.getInt("LOAN_AMT"));
				bm.setRef_dt(rs.getString("REF_DT")==null?"":rs.getString("REF_DT"));
				bm.setSup_dt(rs.getString("SUP_DT")==null?"":rs.getString("SUP_DT"));
				bm.setLoan_end_dt(rs.getString("LOAN_END_DT")==null?"":rs.getString("LOAN_END_DT"));
				bm.setF_rat(rs.getString("F_RAT")==null?"":rs.getString("F_RAT"));
				bm.setF_amt(rs.getInt("F_AMT"));
				bm.setF_term(rs.getString("F_TERM")==null?"":rs.getString("F_TERM"));
				bm.setDays(rs.getString("DAYS")==null?"":rs.getString("DAYS"));
				bm.setDif_amt(rs.getInt("DIF_AMT"));
				bm.setLoan_ack_dt(rs.getString("LOAN_ACK_DT")==null?"":rs.getString("LOAN_ACK_DT"));
				bm.setLoan_rec_dt(rs.getString("LOAN_REC_DT")==null?"":rs.getString("LOAN_REC_DT"));
				bm.setNote(rs.getString("NOTE")==null?"":rs.getString("NOTE"));
				bm.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				bm.setRent_dt(rs.getString("RENT_DT")==null?"":rs.getString("RENT_DT"));
				bm.setFirm_nm(rs.getString("FIRM_NM")==null?"":rs.getString("FIRM_NM"));
				bm.setCar_nm(rs.getString("CAR_NM")==null?"":rs.getString("CAR_NM"));
				bm.setCar_no(rs.getString("CAR_NO")==null?"":rs.getString("CAR_NO"));
				
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
			return bm;
		}
	}	

}