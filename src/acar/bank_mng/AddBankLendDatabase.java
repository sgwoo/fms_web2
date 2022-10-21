package acar.bank_mng;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
//import acar.pos_client.*;
import acar.util.*;
import acar.cont.*;
import acar.debt.*;

public class AddBankLendDatabase
{
	private Connection conn = null;
	public static AddBankLendDatabase db;
	
	public static AddBankLendDatabase getInstance()
	{
		if(AddBankLendDatabase.db == null)
			AddBankLendDatabase.db = new AddBankLendDatabase();
		return AddBankLendDatabase.db;
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
	 *	리스트 : 은행대출리스트 (bank_id : 은행코드) ==> bank_sc_in.jsp에서 호출
	 */
	public Vector getBankLendList(String bank_id, String gubun1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
			
		query = " SELECT A.lend_id, A.cont_bn, decode(C.lend_id, '', 'N', 'Y') scd_yn, A.bank_nm, A.cont_st, A.move_st, A.bn_br, A.cont_term, A.seq,"+
				" A.lend_int, A.rtn_st, E.rtn_tot_amt, A.cont_amt, A.cont_dt, A.cont_start_dt, A.rtn_change, B.ba_nm,"+
				" nvl(D.pm_rest_amt,0) pm_rest_amt, (A.cont_amt-nvl(D.pm_rest_amt,0)) charge_amt, nvl(F.rtn_su,'0') rtn_su,"+
				" (A.cont_amt-nvl(D.pm_rest_amt,0)) alt_pay_amt, A.file_type, A.file_name, nvl(C.scd_rest_amt,0) scd_rest_amt, "+
				" decode(G.fund_id,'','N','Y') fund_yn, G.fund_no, h2.attach_seq, h2.attach_type "+
				" FROM"+
				" ("+
					" SELECT L.lend_id, L.cont_bn, C.nm_cd bank_nm, L.bn_br, L.cont_amt, L.rtn_change,"+
			 		"        DECODE(L.cont_dt, '', '', SUBSTR(L.cont_dt, 1, 4)||'-'||SUBSTR(L.cont_dt, 5, 2)||'-'||SUBSTR(L.cont_dt, 7, 2)) cont_dt,"+
					"        DECODE(L.cont_st, '0','신규', '1','연장') cont_st, DECODE(L.move_st, '0','진행', '1','완료') move_st, "+
					"        L.pm_amt, L.pm_rest_amt, R.seq, R.cont_term, R.rtn_tot_amt, L.lend_int, decode(L.rtn_st, '0','전체', '1','순차','2','분할') rtn_st,"+
					"        DECODE(R.cont_start_dt, '', '', SUBSTR(R.cont_start_dt, 1, 4)||'-'||SUBSTR(R.cont_start_dt, 5, 2)||'-'||SUBSTR(R.cont_start_dt, 7, 2)) cont_start_dt, "+
					"        L.file_type, L.file_name, L.FUND_ID "+
					" FROM LEND_BANK L, CODE C, (select * from BANK_RTN where seq='1') R "+
					" WHERE L.cont_bn = C.CODE AND"+
					"        C.c_st = '0003' AND"+
					"        C.CODE <> '0000' AND"+
					"        C.CODE LIKE '%"+bank_id+"%' AND"+
					"        L.LEND_ID = R.LEND_ID(+)"+
				" ) A,"+
				" ("+
					" SELECT ba_nm, lend_id FROM BANK_AGNT WHERE seq = '0'"+
				" ) B,"+
				" ("+
					" SELECT lend_id, rtn_seq, SUM(DECODE(pay_yn,'0',alt_prn_amt,0)) scd_rest_amt FROM SCD_BANK group by lend_id, rtn_seq "+
				" ) C,"+
				" ("+
					" select  lend_id, sum(lend_prn) pm_rest_amt from allot a, (select max(rent_l_cd) rent_l_cd from allot group by car_mng_id) b where a.rent_l_cd=b.rent_l_cd group by lend_id"+//and lend_id='0013'
				" ) D,"+
				" ("+
					" select lend_id, sum(rtn_tot_amt) rtn_tot_amt from BANK_RTN GROUP BY lend_id"+
				" ) E,"+
				" ("+
					" select lend_id, count(*) rtn_su from bank_rtn group by lend_id"+
				" ) F,  "+
				" WORKING_FUND G, "+

				"        (select seq as attach_seq, file_type as attach_type, content_seq as lend_id from ACAR_ATTACH_FILE where ISDELETED='N' and content_code='LEND_BANK' ) h2 "+

				
				" WHERE A.lend_id = B.lend_id(+) AND"+
				" A.lend_id = C.lend_id(+) AND A.seq=C.rtn_seq(+) AND"+
				" A.lend_id = D.lend_id(+) AND "+
				" A.lend_id = E.lend_id(+) AND "+
				" A.lend_id = F.lend_id(+) and "+
				" A.FUND_ID = G.FUND_ID(+) "+
                " and A.lend_id=h2.lend_id(+) "+
				" ";

		if(gubun1.equals("0")) query += " and A.move_st ='진행' and nvl(C.scd_rest_amt,0)>0";
		if(gubun1.equals("1")) query += " and (A.move_st ='완료' or nvl(C.scd_rest_amt,0)=0)";

		query += " order by a.lend_id desc ";

	//System.out.println("[AddBankLendDatabase:getBankLendList]"+query);
				
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
//			System.out.println("[AddBankLendDatabase:getBankLendList]"+query);
		} catch (SQLException e) {
			System.out.println("[AddBankLendDatabase:getBankLendList]"+e);
			System.out.println("[AddBankLendDatabase:getBankLendList]"+query);
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
	 *	리스트 : 은행대출리스트 (bank_id : 은행코드) ==> bank_sc_in.jsp에서 호출
	 */
	public Vector getBankLendList2(String bank_id, String gubun1, String gubun)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String subQuery = "";
		

		if(gubun.equals("1") || gubun.equals("2") || gubun.equals("3") || gubun.equals("4")) subQuery += " and k.GUBUN='"+gubun+"'\n";
			
		query = " SELECT A.lend_id, A.cont_bn, decode(C.lend_id, '', 'N', 'Y') scd_yn, A.bank_nm, A.cont_st, A.move_st, A.bn_br, A.cont_term, A.seq,\n"+
				" A.lend_int, A.rtn_st, E.rtn_tot_amt, A.cont_amt, A.cont_dt, A.cont_start_dt, A.rtn_change, B.ba_nm,\n"+
				" nvl(D.pm_rest_amt,0) pm_rest_amt, (A.cont_amt-nvl(D.pm_rest_amt,0)) charge_amt, nvl(F.rtn_su,'0') rtn_su,\n"+
				" (A.cont_amt-nvl(D.pm_rest_amt,0)) alt_pay_amt, A.file_type, A.file_name, nvl(C.scd_rest_amt,0) scd_rest_amt,\n "+
				" decode(G.fund_id,'','N','Y') fund_yn, G.fund_no, h2.attach_seq, h2.attach_type\n "+
				" FROM"+
				" ("+
					" SELECT L.lend_id, L.cont_bn, C.nm_cd bank_nm, L.bn_br, L.cont_amt, L.rtn_change,\n "+
			 		"        DECODE(L.cont_dt, '', '', SUBSTR(L.cont_dt, 1, 4)||'-'||SUBSTR(L.cont_dt, 5, 2)||'-'||SUBSTR(L.cont_dt, 7, 2)) cont_dt,\n"+
					"        DECODE(L.cont_st, '0','신규', '1','연장') cont_st, DECODE(L.move_st, '0','진행', '1','완료') move_st,\n "+
					"        L.pm_amt, L.pm_rest_amt, R.seq, R.cont_term, R.rtn_tot_amt, L.lend_int, decode(L.rtn_st, '0','전체', '1','순차','2','분할') rtn_st,\n"+
					"        DECODE(R.cont_start_dt, '', '', SUBSTR(R.cont_start_dt, 1, 4)||'-'||SUBSTR(R.cont_start_dt, 5, 2)||'-'||SUBSTR(R.cont_start_dt, 7, 2)) cont_start_dt,\n "+
					"        L.file_type, L.file_name, L.FUND_ID \n"+
					" FROM LEND_BANK L, CODE C, (select * from BANK_RTN where seq='1') R, CODE_ETC K \n"+
					" WHERE L.cont_bn = C.CODE AND\n"+
					"        C.c_st = '0003' AND\n"+
					"        C.CODE <> '0000' AND\n"+
					"        C.CODE LIKE '%"+bank_id+"%' AND\n"+
					"        L.LEND_ID = R.LEND_ID(+) AND\n"+
					"        c.C_ST=k.C_ST(+) and c.CODE=k.CODE(+) \n"+subQuery+
				" ) A,"+
				" ("+
					" SELECT ba_nm, lend_id FROM BANK_AGNT WHERE seq = '0'\n"+
				" ) B,"+
				" ("+
					" SELECT lend_id, SUM(DECODE(pay_yn,'0',alt_prn_amt,0)) scd_rest_amt FROM SCD_BANK group by lend_id \n "+
				" ) C,"+
				" ("+
					" select  lend_id, sum(lend_prn) pm_rest_amt from allot a, (select max(rent_l_cd) rent_l_cd from allot group by car_mng_id) b where a.rent_l_cd=b.rent_l_cd group by lend_id\n"+//and lend_id='0013'
				" ) D,"+
				" ("+
					" select lend_id, sum(rtn_tot_amt) rtn_tot_amt from BANK_RTN GROUP BY lend_id\n"+
				" ) E,"+
				" ("+
					" select lend_id, count(*) rtn_su from bank_rtn group by lend_id\n"+
				" ) F,  "+
				" WORKING_FUND G, \n"+

				"        (select seq as attach_seq, file_type as attach_type, content_seq as lend_id from ACAR_ATTACH_FILE where ISDELETED='N' and content_code='LEND_BANK' ) h2 \n"+

				
				" WHERE A.lend_id = B.lend_id(+) AND\n"+
				" A.lend_id = C.lend_id(+) AND\n"+
				" A.lend_id = D.lend_id(+) AND \n"+
				" A.lend_id = E.lend_id(+) AND \n"+
				" A.lend_id = F.lend_id(+) and \n"+
				" A.FUND_ID = G.FUND_ID(+) \n"+
                " and A.lend_id=h2.lend_id(+) \n"+
				" ";

		if(gubun1.equals("0")) query += " and A.move_st ='진행' and nvl(C.scd_rest_amt,0)>0\n";
		if(gubun1.equals("1")) query += " and (A.move_st ='완료' or nvl(C.scd_rest_amt,0)=0)\n";

		query += " order by a.lend_id desc \n";

//	System.out.println("[AddBankLendDatabase:getBankLendList]"+query);
				
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

//			System.out.println("[AddBankLendDatabase:getBankLendList]"+query);
		} catch (SQLException e) {
			System.out.println("[AddBankLendDatabase:getBankLendList]"+e);
			System.out.println("[AddBankLendDatabase:getBankLendList]"+query);
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
	 *	등록 : 은행대출 INSERT
	 */
	public BankLendBean insertBankLend(BankLendBean bl)
	{
		getConnection();
		String query_seq = "SELECT NVL(TO_CHAR(MAX(TO_NUMBER(lend_id))+1, '0000'), '0001') lend_id"+
							" FROM LEND_BANK";

		String query = "insert into LEND_BANK "+
							"(LEND_ID,		CONT_DT,	CONT_BN,		CONT_ST,	BN_BR,"+
							" BN_TEL,		BN_FAX,		LEND_NO,		CONT_AMT,	LEND_INT_AMT,"+
							" LEND_INT,		F_RAT,"+
							" CONDI,		DOCS,		PM_AMT,			LEND_A_AMT, PM_REST_AMT,"+
							" CHARGE_AMT,	NTRL_FEE,	STP_FEE,		BOND_GET_ST,FST_PAY_DT,"+
							" FST_PAY_AMT,	CONT_BN_ST, BR_ID,			MNG_ID,		CL_LIM,"+
							" CL_LIM_SUB,	PS_LIM,		LEND_AMT_LIM,	MAX_CLTR_RAT,LEND_LIM_ST,"+
							" LEND_LIM_ET,	CRE_DOCS,	NOTE,			F_AMT,		F_START_DT,"+	
							" F_END_DT,		RTN_ST,		BOND_GET_ST_SUB, MOVE_ST,	LEND_LIM,	RTN_SU,"+
							" RTN_CHANGE,   CLS_RTN_FEE_INT, CLS_RTN_ETC, fund_id ) values"+
							" (?, replace(?, '-', ''), ?, ?, ?,"+
							" ?, ?, ?, ?, ?,"+
							" ?, ?,"+
							" ?, ?, ?, ?, ?,"+
							" ?, ?, ?, ?, replace(?, '-', ''),"+
							" ?, ?, ?, ?, ?,"+
							" ?, ?, ?, ?, replace(?, '-', ''),"+
							" replace(?, '-', ''), ?, ?, ?, replace(?, '-', ''),"+
							" replace(?, '-', ''), ?, ?, ?, ?, ?,"+
							" ?, ?, ?, ? )";

		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query_seq);
		    rs = pstmt1.executeQuery();
			if(rs.next())
			{
				bl.setLend_id(rs.getString("lend_id")==null?"0001":rs.getString("lend_id").trim());
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
			pstmt2.setLong   (9, bl.getCont_amt());
			pstmt2.setInt   (10, bl.getLend_int_amt());
			pstmt2.setString(11, bl.getLend_int());
			pstmt2.setString(12, bl.getF_rat());
			pstmt2.setString(13, bl.getCondi());
			pstmt2.setString(14, bl.getDocs());
			pstmt2.setInt   (15, bl.getPm_amt());
			pstmt2.setLong  (16, bl.getLend_a_amt());
			pstmt2.setLong  (17, bl.getPm_rest_amt());
			pstmt2.setInt   (18, bl.getCharge_amt());
			pstmt2.setInt   (19, bl.getNtrl_fee());
			pstmt2.setInt   (20, bl.getStp_fee());
			pstmt2.setString(21, bl.getBond_get_st());
			pstmt2.setString(22, "");//bl.getFst_pay_dt());
			pstmt2.setInt   (23,0);// bl.getFst_pay_amt());						
			pstmt2.setString(24, bl.getCont_bn_st());				
			pstmt2.setString(25, bl.getBr_id());				
			pstmt2.setString(26, bl.getMng_id());				
			pstmt2.setString(27, bl.getCl_lim());				
			pstmt2.setString(28, bl.getCl_lim_sub());				
			pstmt2.setString(29, bl.getPs_lim());				
			pstmt2.setString(30, bl.getLend_amt_lim());				
			pstmt2.setString(31, bl.getMax_cltr_rat());				
			pstmt2.setString(32, bl.getLend_lim_st());				
			pstmt2.setString(33, bl.getLend_lim_et());				
			pstmt2.setString(34, bl.getCre_docs());				
			pstmt2.setString(35, bl.getNote());				
			pstmt2.setInt   (36, bl.getF_amt());				
			pstmt2.setString(37, bl.getF_start_dt());				
			pstmt2.setString(38, bl.getF_end_dt());				
			pstmt2.setString(39, bl.getRtn_st());				
			pstmt2.setString(40, bl.getBond_get_st_sub());				
			pstmt2.setString(41, bl.getMove_st());				
			pstmt2.setString(42, bl.getLend_lim());				
			pstmt2.setString(43, bl.getRtn_su());
			pstmt2.setString(44, bl.getRtn_change());
			pstmt2.setString(45, bl.getCls_rtn_fee_int());
			pstmt2.setString(46, bl.getCls_rtn_etc());
			pstmt2.setString(47, bl.getFund_id());
			pstmt2.executeUpdate();
			pstmt2.close();
		    
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[AddBankLendDatabase:insertBankLend]"+e);
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
	 *	수정 : 은행대출 UPDATE
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
						" FST_PAY_AMT = ?,"+
						" CONT_BN_ST = ?,"+
						" BR_ID = ?,"+
						" MNG_ID = ?,"+
						" CL_LIM = ?,"+
						" CL_LIM_SUB = ?,"+
						" PS_LIM = ?,"+
						" LEND_AMT_LIM = ?,"+
						" MAX_CLTR_RAT = ?,"+
						" LEND_LIM_ST = replace(?, '-', ''),"+
						" LEND_LIM_ET = replace(?, '-', ''),"+
						" CRE_DOCS = ?,"+
						" NOTE = ?,"+
						" F_AMT = ?,"+
						" F_START_DT = replace(?, '-', ''),"+
						" F_END_DT = replace(?, '-', ''),"+
						" RTN_ST = ?,"+
						" BOND_GET_ST_SUB = ?,"+
						" MOVE_ST = ?,"+
						" LEND_LIM = ?,"+
						" RTN_SU = ?,"+
						" RTN_CHANGE = ?,"+
						" AUTODOC_YN=?, BANK_CODE=?, DEPOSIT_NO=?, ACCT_CODE=?, "+
						" cls_rtn_fee_int=?, cls_rtn_etc=?, p_bank_id=?, p_bank_nm=?, p_bank_no=?  "+
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
			pstmt.setString(11, bl.getF_rat());
			pstmt.setString(12, bl.getCondi());
			pstmt.setString(13, bl.getDocs());
			pstmt.setInt(14, bl.getPm_amt());
			pstmt.setLong(15, bl.getLend_a_amt());
			pstmt.setLong(16, bl.getPm_rest_amt());
			pstmt.setInt(17, bl.getCharge_amt());
			pstmt.setInt(18, bl.getNtrl_fee());
			pstmt.setInt(19, bl.getStp_fee());
			pstmt.setString(20, bl.getBond_get_st());
			pstmt.setString(21, bl.getFst_pay_dt());
			pstmt.setInt(22, bl.getFst_pay_amt());
			//추가
			pstmt.setString(23, bl.getCont_bn_st());				
			pstmt.setString(24, bl.getBr_id());				
			pstmt.setString(25, bl.getMng_id());				
			pstmt.setString(26, bl.getCl_lim());				
			pstmt.setString(27, bl.getCl_lim_sub());				
			pstmt.setString(28, bl.getPs_lim());				
			pstmt.setString(29, bl.getLend_amt_lim());				
			pstmt.setString(30, bl.getMax_cltr_rat());				
			pstmt.setString(31, bl.getLend_lim_st());				
			pstmt.setString(32, bl.getLend_lim_et());				
			pstmt.setString(33, bl.getCre_docs());				
			pstmt.setString(34, bl.getNote());				
			pstmt.setInt(35, bl.getF_amt());				
			pstmt.setString(36, bl.getF_start_dt());				
			pstmt.setString(37, bl.getF_end_dt());				
			pstmt.setString(38, bl.getRtn_st());				
			pstmt.setString(39, bl.getBond_get_st_sub());				
			pstmt.setString(40, bl.getMove_st());				
			pstmt.setString(41, bl.getLend_lim());				
			pstmt.setString(42, bl.getRtn_su());				
			pstmt.setString(43, bl.getRtn_change());				
			pstmt.setString(44, bl.getAutodoc_yn());
			pstmt.setString(45, bl.getBank_code());
			pstmt.setString(46, bl.getDeposit_no_d());
			pstmt.setString(47, bl.getAcct_code());
			pstmt.setString(48, bl.getCls_rtn_fee_int());
			pstmt.setString(49, bl.getCls_rtn_etc());
			pstmt.setString(50, bl.getP_bank_id());
			pstmt.setString(51, bl.getP_bank_nm());
			pstmt.setString(52, bl.getP_bank_no());
			pstmt.setString(53, bl.getLend_id());
			
			
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddBankLendDatabase:updateBankLend]"+e);
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
	 * 조회 : 은행대출 SELECT ==> bank_lend_u.jsp에서 호출
	 */
	public BankLendBean getBankLend(String lend_id) 
	{
		getConnection();
		BankLendBean bl = new BankLendBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
			
	
		
			query = " SELECT a.LEND_ID, a.CONT_BN, a.CONT_ST, a.BN_BR, a.BN_TEL, a.BN_FAX, a.LEND_NO, a.CONT_AMT,"+
					" a.LEND_INT_AMT, a.LEND_INT,"+
					" a.F_RAT, a.CONDI, a.DOCS, a.PM_AMT,"+
					" b.pm_rest_amt as lend_a_amt,"+
					" (a.cont_amt-nvl(b.pm_rest_amt,0)) PM_REST_AMT,"+
			 		" decode(a.CONT_DT, '', '', substr(a.CONT_DT, 1, 4)||'-'||substr(a.CONT_DT, 5, 2)||'-'||substr(a.CONT_DT, 7, 2)) CONT_DT,"+
			 		" a.CHARGE_AMT, a.NTRL_FEE, a.STP_FEE, a.BOND_GET_ST, a.FST_PAY_AMT,"+
			 		" decode(a.FST_PAY_DT, '', '', substr(a.FST_PAY_DT, 1, 4)||'-'||substr(a.FST_PAY_DT, 5, 2)||'-'||substr(a.FST_PAY_DT, 7, 2)) FST_PAY_DT,"+
					" a.CONT_BN_ST, a.BR_ID, a.MNG_ID, a.CL_LIM, a.CL_LIM_SUB, a.PS_LIM, a.LEND_AMT_LIM, a.MAX_CLTR_RAT,"+
			 		" decode(a.LEND_LIM_ST, '', '', substr(a.LEND_LIM_ST, 1, 4)||'-'||substr(a.LEND_LIM_ST, 5, 2)||'-'||substr(a.LEND_LIM_ST, 7, 2)) LEND_LIM_ST,"+
			 		" decode(a.LEND_LIM_ET, '', '', substr(a.LEND_LIM_ET, 1, 4)||'-'||substr(a.LEND_LIM_ET, 5, 2)||'-'||substr(a.LEND_LIM_ET, 7, 2)) LEND_LIM_ET,"+
					" a.CRE_DOCS, a.NOTE, a.F_AMT,"+
			 		" decode(a.F_START_DT, '', '', substr(a.F_START_DT, 1, 4)||'-'||substr(a.F_START_DT, 5, 2)||'-'||substr(a.F_START_DT, 7, 2)) F_START_DT,"+
			 		" decode(a.F_END_DT, '', '', substr(a.F_END_DT, 1, 4)||'-'||substr(a.F_END_DT, 5, 2)||'-'||substr(a.F_END_DT, 7, 2)) F_END_DT,"+
					" a.RTN_ST, a.BOND_GET_ST_SUB, a.MOVE_ST, a.LEND_LIM, a.RTN_SU, a.RTN_CHANGE, 0 as ALT_PAY_AMT, "+
					" a.autodoc_yn, a.acct_code, a.bank_code, a.deposit_no, a.cls_rtn_fee_int, a.cls_rtn_etc, a.file_name, a.file_type, a.fund_id, a.p_bank_id, a.p_bank_nm, a.p_bank_no "+
				" FROM LEND_BANK a,"+
				" (select  lend_id, sum(lend_prn) pm_rest_amt from allot a, (select max(rent_l_cd) rent_l_cd from allot group by car_mng_id) b where a.rent_l_cd=b.rent_l_cd group by lend_id) b "+//and lend_id='0013'
				" WHERE a.LEND_ID=b.LEND_ID(+) AND a.LEND_ID = ?";	
				
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, lend_id);
		   	rs = pstmt.executeQuery();
	//   	System.out.println (query);
		   	
			while(rs.next())
			{
				bl.setLend_id			(rs.getString("LEND_ID")==null?"":rs.getString("LEND_ID"));
				bl.setCont_dt			(rs.getString("CONT_DT")==null?"":rs.getString("CONT_DT"));
				bl.setCont_bn			(rs.getString("CONT_BN")==null?"":rs.getString("CONT_BN"));
				bl.setCont_st			(rs.getString("CONT_ST")==null?"":rs.getString("CONT_ST"));
				bl.setBn_br				(rs.getString("BN_BR")==null?"":rs.getString("BN_BR"));
				bl.setBn_tel			(rs.getString("BN_TEL")==null?"":rs.getString("BN_TEL"));
				bl.setBn_fax			(rs.getString("BN_FAX")==null?"":rs.getString("BN_FAX"));
				bl.setLend_no			(rs.getString("LEND_NO"));
				bl.setCont_amt			(rs.getLong("CONT_AMT"));
				bl.setLend_int_amt		(rs.getInt("LEND_INT_AMT"));
				bl.setLend_int			(rs.getString("LEND_INT")==null?"":rs.getString("LEND_INT"));
				bl.setF_rat				(rs.getString("F_RAT")==null?"":rs.getString("F_RAT"));
				bl.setCondi				(rs.getString("CONDI")==null?"":rs.getString("CONDI"));
				bl.setDocs				(rs.getString("DOCS")==null?"":rs.getString("DOCS"));
				bl.setPm_amt			(rs.getInt("PM_AMT"));
				bl.setLend_a_amt		(rs.getLong("LEND_A_AMT"));
				bl.setPm_rest_amt		(rs.getLong("PM_REST_AMT"));
				bl.setCharge_amt		(rs.getInt("CHARGE_AMT"));
				bl.setNtrl_fee			(rs.getInt("NTRL_FEE"));
				bl.setStp_fee			(rs.getInt("STP_FEE"));
				bl.setBond_get_st		(rs.getString("BOND_GET_ST")==null?"":rs.getString("BOND_GET_ST"));
				bl.setFst_pay_dt		(rs.getString("FST_PAY_DT")==null?"":rs.getString("FST_PAY_DT"));
				bl.setFst_pay_amt		(rs.getString("FST_PAY_AMT")==null?0:Integer.parseInt(rs.getString("FST_PAY_AMT")));
				//추가
				bl.setCont_bn_st		(rs.getString("CONT_BN_ST")==null?"":rs.getString("CONT_BN_ST"));
				bl.setBr_id				(rs.getString("BR_ID")==null?"":rs.getString("BR_ID"));
				bl.setMng_id			(rs.getString("MNG_ID")==null?"":rs.getString("MNG_ID"));
				bl.setCl_lim			(rs.getString("CL_LIM")==null?"":rs.getString("CL_LIM"));
				bl.setCl_lim_sub		(rs.getString("CL_LIM_SUB")==null?"":rs.getString("CL_LIM_SUB"));
				bl.setPs_lim			(rs.getString("PS_LIM")==null?"":rs.getString("PS_LIM"));
				bl.setLend_amt_lim		(rs.getString("LEND_AMT_LIM")==null?"":rs.getString("LEND_AMT_LIM"));
				bl.setMax_cltr_rat		(rs.getString("MAX_CLTR_RAT")==null?"":rs.getString("MAX_CLTR_RAT"));
				bl.setLend_lim_st		(rs.getString("LEND_LIM_ST")==null?"":rs.getString("LEND_LIM_ST"));
				bl.setLend_lim_et		(rs.getString("LEND_LIM_ET")==null?"":rs.getString("LEND_LIM_ET"));
				bl.setCre_docs			(rs.getString("CRE_DOCS")==null?"":rs.getString("CRE_DOCS"));
				bl.setNote				(rs.getString("NOTE")==null?"":rs.getString("NOTE"));
				bl.setF_amt				(rs.getString("F_AMT")==null?0:Integer.parseInt(rs.getString("F_AMT")));
				bl.setF_start_dt		(rs.getString("F_START_DT")==null?"":rs.getString("F_START_DT"));
				bl.setF_end_dt			(rs.getString("F_END_DT")==null?"":rs.getString("F_END_DT"));
				bl.setRtn_st			(rs.getString("RTN_ST")==null?"":rs.getString("RTN_ST"));
				bl.setBond_get_st_sub	(rs.getString("BOND_GET_ST_SUB")==null?"":rs.getString("BOND_GET_ST_SUB"));
				bl.setMove_st			(rs.getString("MOVE_ST")==null?"":rs.getString("MOVE_ST"));
				bl.setLend_lim			(rs.getString("LEND_LIM")==null?"":rs.getString("LEND_LIM"));
				bl.setRtn_su			(rs.getString("RTN_SU")==null?"":rs.getString("RTN_SU"));
				bl.setRtn_change		(rs.getString("RTN_CHANGE")==null?"":rs.getString("RTN_CHANGE"));
				bl.setAlt_pay_amt		(rs.getString("ALT_PAY_AMT")==null?0:Integer.parseInt(rs.getString("ALT_PAY_AMT")));
				bl.setAutodoc_yn		(rs.getString("autodoc_yn")==null?"":rs.getString("autodoc_yn"));
				bl.setBank_code			(rs.getString("bank_code")==null?"":rs.getString("bank_code"));
				bl.setDeposit_no_d		(rs.getString("deposit_no")==null?"":rs.getString("deposit_no"));
				bl.setAcct_code			(rs.getString("acct_code")==null?"":rs.getString("acct_code"));
				//추가
				bl.setCls_rtn_fee_int	(rs.getString("cls_rtn_fee_int")==null?"":rs.getString("cls_rtn_fee_int"));
				bl.setCls_rtn_etc		(rs.getString("cls_rtn_etc")==null?"":rs.getString("cls_rtn_etc"));
				bl.setFile_name			(rs.getString("file_name")==null?"":rs.getString("file_name"));
				bl.setFile_type			(rs.getString("file_type")==null?"":rs.getString("file_type"));
				bl.setFund_id			(rs.getString("fund_id")==null?"":rs.getString("fund_id"));
				bl.setP_bank_id	        (rs.getString("p_bank_id")==null?"":rs.getString("p_bank_id"));
				bl.setP_bank_no	        (rs.getString("p_bank_no")==null?"":rs.getString("p_bank_no"));
				bl.setP_bank_nm	        (rs.getString("p_bank_nm")==null?"":rs.getString("p_bank_nm"));

			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddBankLendDatabase:getBankLend(lend_id)]"+e);
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
	 * 조회 : 은행대출 SELECT - 스케줄 등록 ==> bank_scd_i.jsp, bank_scd_u.jsp에서 호출
	 */
	public BankLendBean getBankLendScd(String lend_id, String seq)
	{
		getConnection();
		BankLendBean bl = new BankLendBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		query = " SELECT L.LEND_ID, L.CONT_BN, L.CONT_ST, L.BN_BR, L.BN_TEL, L.BN_FAX, nvl(L.LEND_NO,' ') LEND_NO, L.CONT_AMT,"+
					" L.LEND_INT_AMT, L.LEND_INT,"+
					" L.F_RAT, L.CONDI, L.DOCS, L.PM_AMT, L.LEND_A_AMT, L.PM_REST_AMT,"+
			 		" decode(L.CONT_DT, '', '', substr(L.CONT_DT, 1, 4)||'-'||substr(L.CONT_DT, 5, 2)||'-'||substr(L.CONT_DT, 7, 2)) CONT_DT,"+
			 		" L.CHARGE_AMT, L.NTRL_FEE, L.STP_FEE, L.BOND_GET_ST,"+
					" L.CONT_BN_ST, L.BR_ID, L.MNG_ID, L.CL_LIM, L.CL_LIM_SUB, L.PS_LIM, L.LEND_AMT_LIM, L.MAX_CLTR_RAT,"+
			 		" decode(L.LEND_LIM_ST, '', '', substr(L.LEND_LIM_ST, 1, 4)||'-'||substr(L.LEND_LIM_ST, 5, 2)||'-'||substr(L.LEND_LIM_ST, 7, 2)) LEND_LIM_ST,"+
			 		" decode(L.LEND_LIM_ET, '', '', substr(L.LEND_LIM_ET, 1, 4)||'-'||substr(L.LEND_LIM_ET, 5, 2)||'-'||substr(L.LEND_LIM_ET, 7, 2)) LEND_LIM_ET,"+
					" L.CRE_DOCS, L.NOTE, L.F_AMT,"+
			 		" decode(L.F_START_DT, '', '', substr(L.F_START_DT, 1, 4)||'-'||substr(L.F_START_DT, 5, 2)||'-'||substr(L.F_START_DT, 7, 2)) F_START_DT,"+
			 		" decode(L.F_END_DT, '', '', substr(L.F_END_DT, 1, 4)||'-'||substr(L.F_END_DT, 5, 2)||'-'||substr(L.F_END_DT, 7, 2)) F_END_DT,"+
					" L.RTN_ST, L.BOND_GET_ST_SUB, L.MOVE_ST, L.LEND_LIM, L.RTN_SU, "+
					" R.RTN_CONT_AMT, R.RTN_TOT_AMT, R.CONT_TERM, R.ALT_AMT,"+
					" R.RTN_CDT, R.RTN_WAY, R.RTN_EST_DT,"+
		 			" decode(R.CONT_START_DT, '', '', substr(R.CONT_START_DT, 1, 4)||'-'||substr(R.CONT_START_DT, 5, 2)||'-'||substr(R.CONT_START_DT, 7, 2)) CONT_START_DT,"+
		 			" decode(R.CONT_END_DT, '', '', substr(R.CONT_END_DT, 1, 4)||'-'||substr(R.CONT_END_DT, 5, 2)||'-'||substr(R.CONT_END_DT, 7, 2)) CONT_END_DT,"+
			 		" decode(R.FST_PAY_DT, '', '', substr(R.FST_PAY_DT, 1, 4)||'-'||substr(R.FST_PAY_DT, 5, 2)||'-'||substr(R.FST_PAY_DT, 7, 2)) FST_PAY_DT,"+
			 		" decode(R.RTN_ONE_DT, '', '', substr(R.RTN_ONE_DT, 1, 4)||'-'||substr(R.RTN_ONE_DT, 5, 2)||'-'||substr(R.RTN_ONE_DT, 7, 2)) RTN_ONE_DT,"+
			 		" decode(R.LOAN_START_DT, '', '', substr(R.LOAN_START_DT, 1, 4)||'-'||substr(R.LOAN_START_DT, 5, 2)||'-'||substr(R.LOAN_START_DT, 7, 2)) LOAN_START_DT,"+
			 		" decode(R.LOAN_END_DT, '', '', substr(R.LOAN_END_DT, 1, 4)||'-'||substr(R.LOAN_END_DT, 5, 2)||'-'||substr(R.LOAN_END_DT, 7, 2)) LOAN_END_DT,"+
					" R.CLS_RTN_CONDI, R.RTN_ONE_AMT, R.RTN_TWO_AMT, R.FST_PAY_AMT, R.RTN_MOVE_ST, R.deposit_no, R.ven_code, L.cls_rtn_fee_int, L.cls_rtn_etc, "+
			 		" L.p_bank_id, L.p_bank_nm, L.p_bank_no "+
				" FROM LEND_BANK L, BANK_RTN R"+
				" WHERE L.LEND_ID=R.LEND_ID and L.LEND_ID = ? and R.SEQ= ?";
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, lend_id);
			pstmt.setString(2, seq);
			rs = pstmt.executeQuery();
			if(rs.next()){
				bl.setLend_id(rs.getString("LEND_ID")==null?"":rs.getString("LEND_ID"));
				bl.setCont_dt(rs.getString("CONT_DT")==null?"":rs.getString("CONT_DT"));
				bl.setCont_bn(rs.getString("CONT_BN")==null?"":rs.getString("CONT_BN"));
				bl.setCont_st(rs.getString("CONT_ST")==null?"":rs.getString("CONT_ST"));
				bl.setBn_br(rs.getString("BN_BR")==null?"":rs.getString("BN_BR"));
				bl.setBn_tel(rs.getString("BN_TEL")==null?"":rs.getString("BN_TEL"));
				bl.setBn_fax(rs.getString("BN_FAX")==null?"":rs.getString("BN_FAX"));
				bl.setLend_no(rs.getString("LEND_NO"));
				bl.setCont_amt(rs.getLong("CONT_AMT"));
				bl.setLend_int_amt(rs.getInt("LEND_INT_AMT"));
				bl.setLend_int(rs.getString("LEND_INT")==null?"":rs.getString("LEND_INT"));
//				bl.setRtn_tot_amt(rs.getInt("RTN_TOT_AMT"));
				bl.setL_rtn_tot_amt(rs.getLong("RTN_TOT_AMT"));
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
				bl.setLend_a_amt(rs.getLong("LEND_A_AMT"));
				bl.setPm_rest_amt(rs.getLong("PM_REST_AMT"));
				bl.setCharge_amt(rs.getInt("CHARGE_AMT"));
				bl.setNtrl_fee(rs.getInt("NTRL_FEE"));
				bl.setStp_fee(rs.getInt("STP_FEE"));
				bl.setBond_get_st(rs.getString("BOND_GET_ST")==null?"":rs.getString("BOND_GET_ST"));
				bl.setFst_pay_dt(rs.getString("FST_PAY_DT")==null?"":rs.getString("FST_PAY_DT"));
				bl.setFst_pay_amt(rs.getString("FST_PAY_AMT")==null?0:Integer.parseInt(rs.getString("FST_PAY_AMT")));
				//추가
				bl.setCont_bn_st(rs.getString("CONT_BN_ST")==null?"":rs.getString("CONT_BN_ST"));
				bl.setBr_id(rs.getString("BR_ID")==null?"":rs.getString("BR_ID"));
				bl.setMng_id(rs.getString("MNG_ID")==null?"":rs.getString("MNG_ID"));
				bl.setCl_lim(rs.getString("CL_LIM")==null?"":rs.getString("CL_LIM"));
				bl.setCl_lim_sub(rs.getString("CL_LIM_SUB")==null?"":rs.getString("CL_LIM_SUB"));
				bl.setPs_lim(rs.getString("PS_LIM")==null?"":rs.getString("PS_LIM"));
				bl.setLend_amt_lim(rs.getString("LEND_AMT_LIM")==null?"":rs.getString("LEND_AMT_LIM"));
				bl.setMax_cltr_rat(rs.getString("MAX_CLTR_RAT")==null?"":rs.getString("MAX_CLTR_RAT"));
				bl.setLend_lim_st(rs.getString("LEND_LIM_ST")==null?"":rs.getString("LEND_LIM_ST"));
				bl.setLend_lim_et(rs.getString("LEND_LIM_ET")==null?"":rs.getString("LEND_LIM_ET"));
				bl.setCre_docs(rs.getString("CRE_DOCS")==null?"":rs.getString("CRE_DOCS"));
				bl.setNote(rs.getString("NOTE")==null?"":rs.getString("NOTE"));
				bl.setF_amt(rs.getString("F_AMT")==null?0:Integer.parseInt(rs.getString("F_AMT")));
				bl.setF_start_dt(rs.getString("F_START_DT")==null?"":rs.getString("F_START_DT"));
				bl.setF_end_dt(rs.getString("F_END_DT")==null?"":rs.getString("F_END_DT"));
				bl.setRtn_st(rs.getString("RTN_ST")==null?"":rs.getString("RTN_ST"));
				bl.setBond_get_st_sub(rs.getString("BOND_GET_ST_SUB")==null?"":rs.getString("BOND_GET_ST_SUB"));
				bl.setCls_rtn_condi(rs.getString("CLS_RTN_CONDI")==null?"":rs.getString("CLS_RTN_CONDI"));
				bl.setRtn_one_amt(rs.getString("RTN_ONE_AMT")==null?0:Integer.parseInt(rs.getString("RTN_ONE_AMT")));
				bl.setRtn_one_dt(rs.getString("RTN_ONE_DT")==null?"":rs.getString("RTN_ONE_DT"));
				bl.setRtn_two_amt(rs.getString("RTN_TWO_AMT")==null?0:Integer.parseInt(rs.getString("RTN_TWO_AMT")));
				bl.setRtn_cont_amt(rs.getString("RTN_CONT_AMT")==null?0:Integer.parseInt(rs.getString("RTN_CONT_AMT")));
				bl.setMove_st(rs.getString("move_st")==null?"":rs.getString("move_st"));
				bl.setLend_lim(rs.getString("lend_lim")==null?"":rs.getString("lend_lim"));
				bl.setRtn_su(rs.getString("rtn_su")==null?"":rs.getString("rtn_su"));
				bl.setLoan_start_dt(rs.getString("loan_start_dt")==null?"":rs.getString("loan_start_dt"));
				bl.setLoan_end_dt(rs.getString("loan_end_dt")==null?"":rs.getString("loan_end_dt"));
				bl.setRtn_move_st(rs.getString("rtn_move_st")==null?"":rs.getString("rtn_move_st"));
				bl.setDeposit_no(rs.getString("deposit_no")==null?"":rs.getString("deposit_no"));
				bl.setVen_code(rs.getString("ven_code")==null?"":rs.getString("ven_code"));
				bl.setCls_rtn_fee_int(rs.getString("cls_rtn_fee_int")==null?"":rs.getString("cls_rtn_fee_int"));
				bl.setCls_rtn_etc(rs.getString("cls_rtn_etc")==null?"":rs.getString("cls_rtn_etc"));
				bl.setP_bank_id(rs.getString("p_bank_id")==null?"":rs.getString("p_bank_id"));
				bl.setP_bank_nm(rs.getString("p_bank_nm")==null?"":rs.getString("p_bank_nm"));
				bl.setP_bank_no(rs.getString("p_bank_no")==null?"":rs.getString("p_bank_no"));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddBankLendDatabase:getBankLend(lend_id,seq)]"+e);
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
	 *	등록 : 은행대출 상환 INSERT
	 */
	public boolean insertBankRtn(BankRtnBean br)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
		query = "insert into BANK_RTN "+
				"(LEND_ID, SEQ, RTN_CONT_AMT, RTN_TOT_AMT, CONT_START_DT,"+
				" CONT_END_DT, CONT_TERM, RTN_EST_DT, ALT_AMT, RTN_CDT,"+
				" RTN_WAY, CLS_RTN_CONDI, RTN_ONE_AMT, RTN_ONE_DT, RTN_TWO_AMT,"+
				" LOAN_START_DT, LOAN_END_DT, RTN_MOVE_ST, DEPOSIT_NO, VEN_CODE"+
				" ) values"+
				" (?, ?, ?, ?, replace(?, '-', ''),"+
				" replace(?, '-', ''), ?, replace(?, '-', ''), ?, ?,"+
				" ?, ?, ?, replace(?, '-', ''), ?,"+
				" replace(?, '-', ''), replace(?, '-', ''), ?, ?, ?)";
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, br.getLend_id().trim());
			pstmt.setString(2, br.getSeq().trim());		
			pstmt.setLong  (3, br.getRtn_cont_amt());
			pstmt.setLong  (4, br.getRtn_tot_amt());
			pstmt.setString(5, br.getCont_start_dt().trim());
			pstmt.setString(6, br.getCont_end_dt().trim());
			pstmt.setString(7, br.getCont_term());
			pstmt.setString(8, br.getRtn_est_dt());
			pstmt.setInt   (9, br.getAlt_amt());
			pstmt.setString(10, br.getRtn_cdt());
			pstmt.setString(11, br.getRtn_way());
			pstmt.setString(12, br.getCls_rtn_condi());				
			pstmt.setInt   (13, br.getRtn_one_amt());				
			pstmt.setString(14, br.getRtn_one_dt());				
			pstmt.setInt   (15, br.getRtn_two_amt());				
			pstmt.setString(16, br.getLoan_start_dt());				
			pstmt.setString(17, br.getLoan_end_dt());				
			pstmt.setString(18, br.getRtn_move_st());				
			pstmt.setString(19, br.getDeposit_no());
			pstmt.setString(20, br.getVen_code());
			pstmt.executeUpdate();
			pstmt.close();
		    
			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[AddBankLendDatabase:insertBankRtn]"+e);
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
	 *	수정 : 은행대출 상환 UPDATE
	 */
	public boolean updateBankRtn(BankRtnBean br)
	{
		getConnection();
		boolean flag = true;
		String query = "update BANK_RTN set"+
						" RTN_CONT_AMT = ?,"+
						" RTN_TOT_AMT = ?,"+
						" CONT_START_DT = replace(?, '-', ''),"+
						" CONT_END_DT = replace(?, '-', ''),"+
						" CONT_TERM = ?,"+
						" RTN_EST_DT = ?,"+
						" ALT_AMT = ?,"+
						" RTN_CDT = ?,"+
						" RTN_WAY = ?,"+
						" CLS_RTN_CONDI = ?,"+
						" RTN_ONE_AMT = ?,"+
						" RTN_ONE_dt = replace(?, '-', ''),"+
						" RTN_TWO_AMT = ?,"+
						" LOAN_START_DT = replace(?, '-', ''),"+
						" LOAN_END_DT = replace(?, '-', ''),"+
						" RTN_MOVE_ST = ?,"+
						" DEPOSIT_NO = ?,"+
						" VEN_CODE = ?"+
						" where LEND_ID = ? and SEQ = ?";
			
		PreparedStatement pstmt = null;
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setLong(1, br.getRtn_cont_amt());
			pstmt.setLong(2, br.getRtn_tot_amt());
			pstmt.setString(3, br.getCont_start_dt().trim());
			pstmt.setString(4, br.getCont_end_dt().trim());
			pstmt.setString(5, br.getCont_term());
			pstmt.setString(6, br.getRtn_est_dt());
			pstmt.setInt(7, br.getAlt_amt());
			pstmt.setString(8, br.getRtn_cdt());
			pstmt.setString(9, br.getRtn_way());
			pstmt.setString(10, br.getCls_rtn_condi());				
			pstmt.setInt(11, br.getRtn_one_amt());				
			pstmt.setString(12, br.getRtn_one_dt());				
			pstmt.setInt(13, br.getRtn_two_amt());				
			pstmt.setString(14, br.getLoan_start_dt());				
			pstmt.setString(15, br.getLoan_end_dt());				
			pstmt.setString(16, br.getRtn_move_st());
			pstmt.setString(17, br.getDeposit_no());
			pstmt.setString(18, br.getVen_code());
			pstmt.setString(19, br.getLend_id().trim());
			pstmt.setString(20, br.getSeq().trim());		
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddBankLendDatabase:updateBankRtn]"+e);
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
	 *	수정 : 은행대출별 매핑계약 상환 1회차 결정일,상환금액 UPDATE
	 */
	public boolean updateAllot_fst(ContDebtBean debt)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "update ALLOT set"+
						" FST_PAY_DT = replace(?, '-', ''),"+
						" FST_PAY_AMT = ?"+
						" where rent_mng_id = ? and rent_l_cd = ?";			
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, debt.getFst_pay_dt());
			pstmt.setInt(2, debt.getFst_pay_amt());
			pstmt.setString(3, debt.getRent_mng_id());
			pstmt.setString(4, debt.getRent_l_cd());		
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddBankLendDatabase:updateAllot_fst]"+e);
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
	 *	수정 : 은행대출 상환 1회차 결정일,상환금액 UPDATE
	 */
	public boolean updateBankRtn_fst(BankRtnBean br)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "update BANK_RTN set"+
						" FST_PAY_DT = replace(?, '-', ''),"+
						" FST_PAY_AMT = ?"+
						" where LEND_ID = ? and SEQ = ?";			
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, br.getFst_pay_dt());
			pstmt.setInt   (2, br.getFst_pay_amt());
			pstmt.setString(3, br.getLend_id().trim());
			pstmt.setString(4, br.getSeq().trim());		
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddBankLendDatabase:updateBankRtn_fst]"+e);
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
	 * 조회 : 은행대출 상환 SELECT
	 */
	public Vector getBankRtn(String lend_id)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		query = " SELECT a.SEQ, a.RTN_CONT_AMT, a.RTN_TOT_AMT, a.CONT_TERM, a.RTN_EST_DT, a.ALT_AMT,"+
	 			" decode(a.CONT_START_DT, '', '', substr(a.CONT_START_DT, 1, 4)||'-'||substr(a.CONT_START_DT, 5, 2)||'-'||substr(a.CONT_START_DT, 7, 2)) CONT_START_DT,"+
	 			" decode(a.CONT_END_DT, '', '', substr(a.CONT_END_DT, 1, 4)||'-'||substr(a.CONT_END_DT, 5, 2)||'-'||substr(a.CONT_END_DT, 7, 2)) CONT_END_DT,"+
	 			" decode(a.RTN_ONE_DT, '', '', substr(a.RTN_ONE_DT, 1, 4)||'-'||substr(a.RTN_ONE_DT, 5, 2)||'-'||substr(a.RTN_ONE_DT, 7, 2)) RTN_ONE_DT,"+
	 			" decode(a.LOAN_START_DT, '', '', substr(a.LOAN_START_DT, 1, 4)||'-'||substr(a.LOAN_START_DT, 5, 2)||'-'||substr(a.LOAN_START_DT, 7, 2)) LOAN_START_DT,"+
	 			" decode(a.LOAN_END_DT, '', '', substr(a.LOAN_END_DT, 1, 4)||'-'||substr(a.LOAN_END_DT, 5, 2)||'-'||substr(a.LOAN_END_DT, 7, 2)) LOAN_END_DT,"+
				" a.RTN_CDT, a.RTN_WAY, a.CLS_RTN_CONDI, nvl(a.RTN_ONE_AMT,0) RTN_ONE_AMT, nvl(a.RTN_TWO_AMT,0) RTN_TWO_AMT, a.RTN_MOVE_ST, "+
				" 'N' cls_yn, a.deposit_no, a.ven_code"+
				" FROM BANK_RTN a"+
				" WHERE a.LEND_ID = ?";
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, lend_id);
	    	rs = pstmt.executeQuery();
			while(rs.next())
			{
				BankRtnBean br = new BankRtnBean();

				br.setSeq			(rs.getString("SEQ")==null?"":rs.getString("SEQ"));
				br.setRtn_cont_amt	(rs.getLong("RTN_CONT_AMT"));
				br.setRtn_tot_amt	(rs.getLong("RTN_TOT_AMT"));
				br.setCont_start_dt	(rs.getString("CONT_START_DT")==null?"":rs.getString("CONT_START_DT"));
				br.setCont_end_dt	(rs.getString("CONT_END_DT")==null?"":rs.getString("CONT_END_DT"));
				br.setCont_term		(rs.getString("CONT_TERM")==null?"":rs.getString("CONT_TERM"));
				br.setRtn_est_dt	(rs.getString("RTN_EST_DT")==null?"":rs.getString("RTN_EST_DT").trim());
				br.setAlt_amt		(rs.getInt("ALT_AMT"));
				br.setRtn_cdt		(rs.getString("RTN_CDT")==null?"":rs.getString("RTN_CDT"));
				br.setRtn_way		(rs.getString("RTN_WAY")==null?"":rs.getString("RTN_WAY"));
				br.setCls_rtn_condi	(rs.getString("CLS_RTN_CONDI")==null?"":rs.getString("CLS_RTN_CONDI"));
				br.setRtn_one_amt	(rs.getInt("RTN_ONE_AMT"));
				br.setRtn_one_dt	(rs.getString("RTN_ONE_DT")==null?"":rs.getString("RTN_ONE_DT"));
				br.setRtn_two_amt	(rs.getInt("RTN_TWO_AMT"));
				br.setLoan_start_dt	(rs.getString("LOAN_START_DT")==null?"":rs.getString("LOAN_START_DT"));
				br.setLoan_end_dt	(rs.getString("LOAN_END_DT")==null?"":rs.getString("LOAN_END_DT"));
				br.setRtn_move_st	(rs.getString("RTN_MOVE_ST")==null?"":rs.getString("RTN_MOVE_ST"));
				br.setCls_yn		(rs.getString("CLS_YN")==null?"":rs.getString("CLS_YN"));
				br.setDeposit_no	(rs.getString("deposit_no")==null?"":rs.getString("deposit_no"));
				br.setVen_code		(rs.getString("ven_code")==null?"":rs.getString("ven_code"));
				vt.add(br);

//				System.out.println("[lend_id]"+lend_id);
//				System.out.println("[RTN_CONT_AMT]"+rs.getLong("RTN_CONT_AMT"));
//				System.out.println("[RTN_CONT_AMT]"+br.getRtn_cont_amt());
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddBankLendDatabase:getBankRtn]"+e);
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
	 * 조회 : 은행대출 상환 건별 SELECT
	 */
	public BankRtnBean getBankRtn(String lend_id, String seq) 
	{
		getConnection();
		BankRtnBean br = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		query = " SELECT SEQ, RTN_CONT_AMT, RTN_TOT_AMT, CONT_TERM, RTN_EST_DT, ALT_AMT, RTN_ONE_DT, "+
	 			" decode(CONT_START_DT, '', '', substr(CONT_START_DT, 1, 4)||'-'||substr(CONT_START_DT, 5, 2)||'-'||substr(CONT_START_DT, 7, 2)) CONT_START_DT,"+
	 			" decode(CONT_END_DT, '', '', substr(CONT_END_DT, 1, 4)||'-'||substr(CONT_END_DT, 5, 2)||'-'||substr(CONT_END_DT, 7, 2)) CONT_END_DT,"+
	 			" decode(RTN_ONE_DT, '', '', substr(RTN_ONE_DT, 1, 4)||'-'||substr(RTN_ONE_DT, 5, 2)||'-'||substr(RTN_ONE_DT, 7, 2)) CONT_END_DT,"+
	 			" decode(LOAN_START_DT, '', '', substr(LOAN_START_DT, 1, 4)||'-'||substr(LOAN_START_DT, 5, 2)||'-'||substr(LOAN_START_DT, 7, 2)) LOAN_START_DT,"+
	 			" decode(LOAN_END_DT, '', '', substr(LOAN_END_DT, 1, 4)||'-'||substr(LOAN_END_DT, 5, 2)||'-'||substr(LOAN_END_DT, 7, 2)) LOAN_END_DT,"+
				" RTN_CDT, RTN_WAY, CLS_RTN_CONDI, nvl(RTN_ONE_AMT,0) RTN_ONE_AMT, nvl(RTN_TWO_AMT,0) RTN_TWO_AMT, ven_code, fst_pay_dt "+
				" FROM BANK_RTN"+
				" WHERE LEND_ID = ? and SEQ = ?";
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, lend_id);
			pstmt.setString(2, seq);
			rs = pstmt.executeQuery();
			while(rs.next())
			{
				br = new BankRtnBean();

				br.setSeq(rs.getString("SEQ")==null?"":rs.getString("SEQ"));
				br.setRtn_cont_amt(rs.getLong("RTN_CONT_AMT"));
				br.setRtn_tot_amt(rs.getLong("RTN_TOT_AMT"));
				br.setCont_start_dt(rs.getString("CONT_START_DT")==null?"":rs.getString("CONT_START_DT"));
				br.setCont_end_dt(rs.getString("CONT_END_DT")==null?"":rs.getString("CONT_END_DT"));
				br.setCont_term(rs.getString("CONT_TERM")==null?"":rs.getString("CONT_TERM"));
				br.setRtn_est_dt(rs.getString("RTN_EST_DT")==null?"":rs.getString("RTN_EST_DT"));
				br.setAlt_amt(rs.getInt("ALT_AMT"));
				br.setRtn_cdt(rs.getString("RTN_CDT")==null?"":rs.getString("RTN_CDT"));
				br.setRtn_way(rs.getString("RTN_WAY")==null?"":rs.getString("RTN_WAY"));
				br.setCls_rtn_condi(rs.getString("CLS_RTN_CONDI")==null?"":rs.getString("CLS_RTN_CONDI"));
				br.setRtn_one_amt(rs.getInt("RTN_ONE_AMT"));
				br.setRtn_one_dt(rs.getString("RTN_ONE_DT")==null?"":rs.getString("RTN_ONE_DT"));
				br.setRtn_two_amt(rs.getInt("RTN_TWO_AMT"));
				br.setLoan_start_dt(rs.getString("LOAN_START_DT")==null?"":rs.getString("LOAN_START_DT"));
				br.setLoan_end_dt(rs.getString("LOAN_END_DT")==null?"":rs.getString("LOAN_END_DT"));
				br.setVen_code(rs.getString("ven_code")==null?"":rs.getString("ven_code"));
				br.setFst_pay_dt(rs.getString("fst_pay_dt")==null?"":rs.getString("fst_pay_dt"));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddBankLendDatabase:getBankRtn]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return br;
		}
	}

	/**
	 *	등록 : 은행대출 관리자 INSERT
	 */
	public boolean insertBankAgnt(BankAgntBean ba)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;

		String query_seq = "SELECT ltrim(NVL(TO_CHAR(MAX(TO_NUMBER(seq))+1, '0'), '0')) seq"+
							" FROM BANK_AGNT"+
							" WHERE lend_id=?";

		String query = "insert into BANK_AGNT (LEND_ID, SEQ, BA_NM, BA_TITLE, BA_TEL, BA_EMAIL) values"+
						" (?, ?, ?, ?, ?, ?)";
		try 
		{
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query_seq);
			pstmt1.setString(1, ba.getLend_id());
		    rs = pstmt1.executeQuery();
			while(rs.next())
			{
				ba.setSeq(rs.getString("seq"));
			}
			rs.close();
			pstmt1.close();

			pstmt2 = conn.prepareStatement(query);
			pstmt2.setString(1, ba.getLend_id().trim());
			pstmt2.setString(2, ba.getSeq().trim());
			pstmt2.setString(3, ba.getBa_nm());
			pstmt2.setString(4, ba.getBa_title());
			pstmt2.setString(5, ba.getBa_tel());
			pstmt2.setString(6, ba.getBa_email());
			pstmt2.executeUpdate();
			pstmt2.close();

		    conn.commit();

	  	} catch (Exception e) {
			System.out.println("[AddBankLendDatabase:insertBankAgnt]"+e);
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
	 *	수정 : 은행대출 관리자 UPDATE
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
			System.out.println("[AddBankLendDatabase:updateBankAgnt]"+e);
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
	 *	조회 : 은행대출별 관리자
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
			System.out.println("[AddBankLendDatabase:getBankAgnt]"+e);
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
	 *	리스트 : 은행대출별 관리자 리스트
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
			System.out.println("[AddBankLendDatabase:getBankAgnts]"+e);
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
	 *	리스트 : 은행대출과 매핑할 계약 리스트
	 */
	public Vector getMappingContList(String cont_bn)
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
							  " A.cpt_cd='"+cont_bn+"' AND"+
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
			System.out.println("[AddBankLendDatabase:getMappingContList]"+e);
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
	 *	등록 : 은행대출 스케줄 INSERT
	 */
	public boolean insertBankScd(BankScdBean bs)
	{
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		boolean flag = true;
		int count = 0;

		String query2 = "select count(*) from SCD_BANK where LEND_ID=? and RTN_SEQ=? and ALT_TM=?";

		String query = "insert into SCD_BANK (LEND_ID, ALT_TM, ALT_EST_DT, ALT_PRN_AMT, ALT_INT_AMT, PAY_DT, PAY_YN, ALT_REST, RTN_SEQ, R_ALT_EST_DT) values"+
						" (?, ?, replace(?, '-', ''), ?, ?, replace(?, '-', ''), ?, ?, ?, replace(?, '-', ''))";


		try 
		{
			conn.setAutoCommit(false);

			pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString(1, bs.getLend_id());
			pstmt2.setString(2, bs.getRtn_seq());
			pstmt2.setString(3, bs.getAlt_tm());
		    rs = pstmt2.executeQuery();
			if(rs.next())
			{				
				count = rs.getInt(1);
			}
			rs.close();
			pstmt2.close();

			if(count == 0){
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, bs.getLend_id());
				pstmt.setString(2, bs.getAlt_tm());
				pstmt.setString(3, bs.getAlt_est_dt());
				pstmt.setInt   (4, bs.getAlt_prn_amt());
				pstmt.setInt   (5, bs.getAlt_int_amt());
				pstmt.setString(6, bs.getPay_dt());
				pstmt.setString(7, bs.getPay_yn());
				pstmt.setLong   (8, bs.getAlt_rest());
				pstmt.setString(9, bs.getRtn_seq());
				pstmt.setString(10, bs.getR_alt_est_dt());
			    pstmt.executeUpdate();
				pstmt.close();
			}

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddBankLendDatabase:insertBankScd]"+e);
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(rs != null)		rs.close();
				if(pstmt2 != null)	pstmt2.close();
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
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query_seq = "update SCD_BANK set"+
								" ALT_EST_DT = replace(?, '-', ''),"+
								" ALT_PRN_AMT = ?,"+
								" ALT_INT_AMT = ?,"+
								" PAY_DT = replace(?, '-', ''),"+
								" PAY_YN = ?,"+
								" ALT_REST = ?,"+
								" R_ALT_EST_DT = replace(?, '-', '')"+
								" where LEND_ID = ? and RTN_SEQ = ?and ALT_TM = ?";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query_seq);
			pstmt.setString(1, bs.getAlt_est_dt());
			pstmt.setInt   (2, bs.getAlt_prn_amt());
			pstmt.setInt   (3, bs.getAlt_int_amt());
			pstmt.setString(4, bs.getPay_dt());
			pstmt.setString(5, bs.getPay_yn());
			pstmt.setLong   (6, bs.getAlt_rest());
			pstmt.setString(7, bs.getR_alt_est_dt());
			pstmt.setString(8, bs.getLend_id());
			pstmt.setString(9, bs.getRtn_seq());
			pstmt.setString(10, bs.getAlt_tm());
			
		    pstmt.executeUpdate();
			pstmt.close();
		    
		   	conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddBankLendDatabase:updateBankScd]"+e);
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
	 *	은행대출 스케줄 delete 
	 */
	public boolean deleteBankScd(BankScdBean bs)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query_seq = " delete from SCD_BANK "+
								" where LEND_ID = ? and RTN_SEQ = ? and ALT_TM = ? and pay_dt is null ";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query_seq);
			pstmt.setString(1, bs.getLend_id());
			pstmt.setString(2, bs.getRtn_seq());
			pstmt.setString(3, bs.getAlt_tm());			
		    pstmt.executeUpdate();
			pstmt.close();
		    
		   	conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddBankLendDatabase:deleteBankScd]"+e);
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
	public boolean updateBankScd(String table, BankScdBean bs)
	{
		getConnection();
		boolean flag = true;
		String query_seq = "update "+table+" set"+
								" ALT_EST_DT = replace(?, '-', ''),"+
								" ALT_PRN_AMT = ?,"+
								" ALT_INT_AMT = ?,"+
								" PAY_DT = replace(?, '-', ''),"+
								" PAY_YN = ?,"+
								" ALT_REST = ?,"+
								" R_ALT_EST_DT = replace(?, '-', '')"+
								" where LEND_ID = ? and RTN_SEQ = ? and ALT_TM = ?";
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
			pstmt.setString(7, bs.getR_alt_est_dt());
			pstmt.setString(8, bs.getLend_id());
			pstmt.setString(9, bs.getRtn_seq());
			pstmt.setString(10, bs.getAlt_tm());
			
		    pstmt.executeUpdate();
			pstmt.close();
		    
			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[AddBankLendDatabase:updateBankScd]"+e);
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
	 *	등록 : 은행대출 스케줄 INSERT(건별)
	 */
	public boolean insertScdAltCase(DebtScdBean dscd)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		int chk = 0;

		String query = "insert into scd_alt_case (CAR_MNG_ID, ALT_TM, ALT_EST_DT, ALT_PRN, ALT_INT, PAY_YN, PAY_DT, ALT_REST, R_ALT_EST_DT) values"+
						" (?, ?, replace(?, '-', ''), ?, ?, ?, replace(?, '-', ''), ?, replace(?, '-', ''))";
		//입력체크
		String query2 = "select count(*) from scd_alt_case where CAR_MNG_ID=? and ALT_TM=?";

		try 
		{
			conn.setAutoCommit(false);

			pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString(1, dscd.getCar_mng_id());
			pstmt2.setString(2, dscd.getAlt_tm());
	    	rs = pstmt2.executeQuery();
			if(rs.next()){
				chk = rs.getInt(1);	
			}
			rs.close();
			pstmt2.close();

			if(chk==0){
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, dscd.getCar_mng_id());
				pstmt.setString(2, dscd.getAlt_tm());
				pstmt.setString(3, dscd.getAlt_est_dt());
				pstmt.setInt   (4, dscd.getAlt_prn());
				pstmt.setInt   (5, dscd.getAlt_int());
				pstmt.setString(6, dscd.getPay_yn());
				pstmt.setString(7, dscd.getPay_dt());
				pstmt.setInt   (8, dscd.getAlt_rest());
				pstmt.setString(9, dscd.getR_alt_est_dt());
				pstmt.executeUpdate();
				pstmt.close();
			}

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddBankLendDatabase:insertScdAltCase]"+e);
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(rs != null)		rs.close();
				if(pstmt != null)	pstmt.close();
				if(pstmt2 != null)	pstmt2.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}
	
	/**
	 *	은행대출 스케줄 UPDATE(건별)
	 */
	public boolean updateScdAltCase(BankScdBean bs)
	{
		getConnection();
		boolean flag = true;
		String query_seq = "update SCD_BANK set"+
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
			System.out.println("[AddBankLendDatabase:updateScdAltCase]"+e);
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
	public Vector getBankScds(String lend_id, String rtn_seq)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String table = "scd_bank";

		String query = 	" select"+
							" LEND_ID, ALT_TM, ALT_PRN_AMT, ALT_INT_AMT, PAY_YN, ALT_REST,"+
							" decode(ALT_EST_DT, '', '', substr(ALT_EST_DT, 1, 4)||'-'||substr(ALT_EST_DT, 5, 2)||'-'||substr(ALT_EST_DT, 7, 2)) ALT_EST_DT,"+
							" decode(PAY_DT, '', '', substr(PAY_DT, 1, 4)||'-'||substr(PAY_DT, 5, 2)||'-'||substr(PAY_DT, 7, 2)) PAY_DT, cls_rtn_dt"+
							" from "+table+
							" where LEND_ID=? and rtn_seq=? order by to_number(alt_tm)";
						
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, lend_id);
				pstmt.setString(2, rtn_seq);
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
				bs.setAlt_rest(rs.getLong("ALT_REST"));
				bs.setCls_rtn_dt(rs.getString("cls_rtn_dt")==null?"":rs.getString("cls_rtn_dt"));

				vt.add(bs);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddBankLendDatabase:getBankScds]"+e);
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
	 *	은행대출 스케줄
	 */
	public Vector getBankClsBScds(String lend_id, String rtn_seq, String cls_rtn_dt)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String table = "scd_bank_cls_b";

		String query = 	" select"+
							" LEND_ID, ALT_TM, ALT_PRN_AMT, ALT_INT_AMT, PAY_YN, ALT_REST,"+
							" decode(ALT_EST_DT, '', '', substr(ALT_EST_DT, 1, 4)||'-'||substr(ALT_EST_DT, 5, 2)||'-'||substr(ALT_EST_DT, 7, 2)) ALT_EST_DT,"+
							" decode(PAY_DT, '', '', substr(PAY_DT, 1, 4)||'-'||substr(PAY_DT, 5, 2)||'-'||substr(PAY_DT, 7, 2)) PAY_DT, cls_rtn_dt"+
							" from "+table+
							" where LEND_ID=? and rtn_seq=? and cls_rtn_dt=replace(?, '-', '') order by to_number(alt_tm)";
						
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, lend_id);
				pstmt.setString(2, rtn_seq);
				pstmt.setString(3, cls_rtn_dt);
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
				bs.setAlt_rest(rs.getLong("ALT_REST"));
				bs.setCls_rtn_dt(rs.getString("cls_rtn_dt")==null?"":rs.getString("cls_rtn_dt"));

				vt.add(bs);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AddBankLendDatabase:getBankClsBScds]"+e);
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
	public BankScdBean getBankScd(String lend_id, String rtn_seq, String alt_tm)
	{
		getConnection();
		BankScdBean bs = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	" select"+
							" LEND_ID, RTN_SEQ, ALT_TM, ALT_EST_DT, ALT_PRN_AMT, ALT_INT_AMT, PAY_DT, PAY_YN, ALT_REST, R_ALT_EST_DT"+
							" from SCD_BANK"+
							" where LEND_ID=? and RTN_SEQ = ? and ALT_TM = ?";
						
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, lend_id);
				pstmt.setString(2, rtn_seq);
				pstmt.setString(3, alt_tm);
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
				bs.setAlt_rest(rs.getLong("ALT_REST"));
				bs.setRtn_seq(rs.getString("RTN_SEQ")==null?"":rs.getString("RTN_SEQ"));
				bs.setR_alt_est_dt(rs.getString("R_ALT_EST_DT")==null?"":rs.getString("R_ALT_EST_DT"));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddBankLendDatabase:getBankScd]"+e);
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
	 *	은행대출 스케줄(개별)
	 */
	public BankScdBean getBankScd(String table, String lend_id, String rtn_seq, String alt_tm)
	{
		getConnection();
		BankScdBean bs = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	" select"+
							" LEND_ID, RTN_SEQ, ALT_TM, ALT_EST_DT, ALT_PRN_AMT, ALT_INT_AMT, PAY_DT, PAY_YN, ALT_REST, R_ALT_EST_DT"+
							" from "+table+" where LEND_ID=? and RTN_SEQ = ? and ALT_TM = ?";
						
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, lend_id);
				pstmt.setString(2, rtn_seq);
				pstmt.setString(3, alt_tm);
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
				bs.setAlt_rest(rs.getLong("ALT_REST"));
				bs.setRtn_seq(rs.getString("RTN_SEQ")==null?"":rs.getString("RTN_SEQ"));
				bs.setR_alt_est_dt(rs.getString("R_ALT_EST_DT")==null?"":rs.getString("R_ALT_EST_DT"));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddBankLendDatabase:getBankScd]"+e);		
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
	 *	리스트 : 은행대출리스트 리스트
	 */
	public Vector getCarbankList(String s_kd, String t_wd, String s_rtn, String gubun, String lend_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "select * from car_bank_view";

		//등록
		if(gubun.equals("reg")){	query += " where lend_st='N' and allot_st='N' ";
		//리스트
		}else{						query += " where lend_st='Y' and allot_st='Y' and lend_id='"+lend_id+"' ";
			if(!s_rtn.equals("")){
									query += " and rtn_seq = '"+s_rtn+"'";
			}
		}
		
		//기타항목 검색 
		if(s_kd.equals("1"))	query += " and nvl(firm_nm, ' ') like '%"+t_wd+"%'";
		if(s_kd.equals("2"))	query += " and nvl(car_no, ' ') like '%"+t_wd+"%'";

		query += " order by loan_dt, rent_mng_id desc";

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
			System.out.println("[AddBankLendDatabase:getCarbankList]"+e);
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
	 * 조회 : 은행대출 SELECT - 은행대출 매핑 등록
	 */
	public BankMappingBean getBankLend_mapping_info(String m_id, String l_cd)
	{
		getConnection();
		BankMappingBean bm = new BankMappingBean();
		Statement stmt = null;
		ResultSet rs = null;
		String query =  " select"+
						" car_mng_id, firm_nm, client_nm, rent_dt, dlv_dt, car_nm, car_name, car_no, fee_amt, spe_amt, sup_amt, sup_amt_85per, sup_amt_70per, sup_v_amt"+
						" from car_bank_view "+
						" where rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"'";
		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);
			if(rs.next()){
				bm.setCar_mng_id(rs.getString("car_mng_id")==null?"":rs.getString("car_mng_id"));
				bm.setFirm_nm(rs.getString("firm_nm")==null?"":rs.getString("firm_nm"));
				bm.setClient_nm(rs.getString("client_nm")==null?"":rs.getString("client_nm"));
				bm.setRent_dt(rs.getString("rent_dt")==null?"":rs.getString("rent_dt"));
				bm.setDlv_dt(rs.getString("dlv_dt")==null?"":rs.getString("dlv_dt"));
				bm.setCar_nm(rs.getString("car_nm")==null?"":rs.getString("car_nm"));
				bm.setCar_name(rs.getString("car_name")==null?"":rs.getString("car_name"));
				bm.setCar_no(rs.getString("car_no")==null?"":rs.getString("car_no"));
				bm.setFee_amt(rs.getInt("fee_amt"));
				bm.setSpe_amt(rs.getInt("spe_amt"));
				bm.setSup_amt(rs.getInt("sup_amt"));
				bm.setSup_amt_85per(rs.getInt("sup_amt_85per"));
				bm.setSup_amt_70per(rs.getInt("sup_amt_70per"));
				bm.setSup_v_amt(rs.getInt("sup_v_amt"));
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddBankLendDatabase:getBankLend_mapping_info]"+e);
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bm;
		}
	}

	/**
	 *	매핑 테이블 INSERT (allot 통합)
	 */
	public boolean updateBankMapping_allot(ContDebtBean debt)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		String car_id=debt.getCar_mng_id();
		String imsi_car_id="";
		String imsi_chk="0";

		String query_id = "select nvl(lpad(substr(max(car_mng_id),2,6)+1,5,0), '00001') "+
							" from ALLOT where substr(car_mng_id,1,1)='A'";//imsi_chk='1' and 

		String query = "";
		query = " update ALLOT set "+
				" ALLOT_ST=?, CPT_CD=?,	LEND_INT=?, LEND_PRN=?, ALT_FEE=?,"+
				" RTN_TOT_AMT=?, LOAN_DEBTOR=?,	RTN_CDT=?, RTN_WAY=?, RTN_EST_DT=replace(?,'-',''),"+
				" LEND_NO=?, NTRL_FEE=?, STP_FEE=?, LEND_DT=replace(?,'-',''), LEND_INT_AMT=?,"+
				" ALT_AMT=?, TOT_ALT_TM=?, ALT_START_DT=replace(?,'-',''), ALT_END_DT=replace(?,'-',''), BOND_GET_ST=?,"+
				" FST_PAY_DT=replace(?,'-',''), FST_PAY_AMT=?,"+//22
				" CPT_CD_ST=?, LEND_ID=?, CAR_MNG_ID=?,"+
				" LOAN_ST_DT=replace(?,'-',''), LOAN_SCH_AMT=?, PAY_SCH_AMT=?, DIF_AMT=?, IMSI_CHK=?,"+
				" RTN_SEQ=?, LOAN_ST=?,"+//32
				" BOND_GET_ST_SUB=?, CLS_RTN_DT=replace(?,'-',''), CLS_RTN_AMT=?, CLS_RTN_FEE=?, NOTE=?,"+
				" CLS_RTN_CAU=?, RIMITTER=?, LEND_INT_VAT=?"+	//40
				" where RENT_MNG_ID=? and RENT_L_CD=?";
		try 
		{
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query_id);
			rs = pstmt1.executeQuery();
			if(rs.next()){
				imsi_car_id = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt1.close();

			if(car_id.equals("")){ //미등록차량일 경우 임시코드로 등록한다.
				car_id = "A"+imsi_car_id;
				imsi_chk = "1";
			}

			pstmt2 = conn.prepareStatement(query);
			pstmt2.setString(1, debt.getAllot_st());
			pstmt2.setString(2, debt.getCpt_cd());
			pstmt2.setString(3, debt.getLend_int());
			pstmt2.setInt   (4, debt.getLend_prn());
			pstmt2.setInt   (5, debt.getAlt_fee());
			pstmt2.setInt   (6, debt.getRtn_tot_amt());
			pstmt2.setString(7, debt.getLoan_debtor());
			pstmt2.setString(8, debt.getRtn_cdt());
			pstmt2.setString(9, debt.getRtn_way());
			pstmt2.setString(10, debt.getRtn_est_dt());
			pstmt2.setString(11, debt.getLend_no());
			pstmt2.setInt   (12, debt.getNtrl_fee());
			pstmt2.setInt   (13, debt.getStp_fee());
			pstmt2.setString(14, debt.getLend_dt());
			pstmt2.setInt   (15, debt.getLend_int_amt());
			pstmt2.setInt   (16, debt.getAlt_amt());
			pstmt2.setString(17, debt.getTot_alt_tm());
			pstmt2.setString(18, debt.getAlt_start_dt());
			pstmt2.setString(19, debt.getAlt_end_dt());
			pstmt2.setString(20, debt.getBond_get_st());
			pstmt2.setString(21, debt.getFst_pay_dt());
			pstmt2.setInt   (22, debt.getFst_pay_amt());
			pstmt2.setString(23, debt.getCpt_cd_st());
			pstmt2.setString(24, debt.getLend_id());
			pstmt2.setString(25, car_id);			
			pstmt2.setString(26, debt.getLoan_st_dt());
			pstmt2.setInt   (27, debt.getLoan_sch_amt());
			pstmt2.setInt   (28, debt.getPay_sch_amt());
			pstmt2.setInt   (29, debt.getDif_amt());
			pstmt2.setString(30, imsi_chk);
			pstmt2.setString(31, debt.getRtn_seq());
			pstmt2.setString(32, debt.getLoan_st());
			pstmt2.setString(33, debt.getBond_get_st_sub());
			pstmt2.setString(34, debt.getCls_rtn_dt());
			pstmt2.setInt   (35, debt.getCls_rtn_amt());
			pstmt2.setInt   (36, debt.getCls_rtn_fee());
			pstmt2.setString(37, debt.getNote());
			pstmt2.setString(38, debt.getCls_rtn_cau());
			pstmt2.setString(39, debt.getRimitter());
			pstmt2.setInt   (40, debt.getLend_int_vat());
			pstmt2.setString(41, debt.getRent_mng_id());
			pstmt2.setString(42, debt.getRent_l_cd());
			pstmt2.executeUpdate();
			pstmt2.close();

			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[AddBankLendDatabase:updateBankMapping_allot]"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(rs != null )		rs.close();
				if(pstmt1 != null )	pstmt1.close();
				if(pstmt2 != null )	pstmt2.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}

	/**
	 *	매핑 테이블 조회 (allot 통합)
	 */
	public ContDebtBean getBankLend_mapping_allot(String m_id, String l_cd)
	{
		getConnection();
		ContDebtBean debt = new ContDebtBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		query = " SELECT"+
				" allot_st, cpt_cd, lend_int, lend_prn, alt_fee, rtn_tot_amt, loan_debtor, rtn_cdt, rtn_way,"+
				" lend_no, ntrl_fee, stp_fee, lend_int_amt, alt_amt, tot_alt_tm, bond_get_st, rtn_est_dt,"+
		 		" decode(lend_dt, '', '', substr(lend_dt, 1, 4)||'-'||substr(lend_dt, 5, 2)||'-'||substr(lend_dt, 7, 2)) lend_dt,"+
		 		" decode(alt_start_dt, '', '', substr(alt_start_dt, 1, 4)||'-'||substr(alt_start_dt, 5, 2)||'-'||substr(alt_start_dt, 7, 2)) alt_start_dt,"+
		 		" decode(alt_end_dt, '', '', substr(alt_end_dt, 1, 4)||'-'||substr(alt_end_dt, 5, 2)||'-'||substr(alt_end_dt, 7, 2)) alt_end_dt,"+
				" fst_pay_amt, bond_get_st_sub, cls_rtn_amt, cls_rtn_fee, note, cpt_cd_st, lend_id, car_mng_id,"+
		 		" decode(fst_pay_dt, '', '', substr(fst_pay_dt, 1, 4)||'-'||substr(fst_pay_dt, 5, 2)||'-'||substr(fst_pay_dt, 7, 2)) fst_pay_dt,"+
		 		" decode(cls_rtn_dt, '', '', substr(cls_rtn_dt, 1, 4)||'-'||substr(cls_rtn_dt, 5, 2)||'-'||substr(cls_rtn_dt, 7, 2)) cls_rtn_dt,"+
		 		" decode(loan_st_dt, '', '', substr(loan_st_dt, 1, 4)||'-'||substr(loan_st_dt, 5, 2)||'-'||substr(loan_st_dt, 7, 2)) loan_st_dt,"+
				" loan_sch_amt, pay_sch_amt, dif_amt, imsi_chk, rtn_seq, loan_st,"+
				" cls_rtn_cau, rimitter, lend_int_vat"+
				" FROM ALLOT"+
				" WHERE rent_mng_id=? and rent_l_cd=?";
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, m_id);
			pstmt.setString(2, l_cd);
		   	rs = pstmt.executeQuery();
			if(rs.next()){
				debt.setAllot_st(rs.getString("ALLOT_ST")==null?"":rs.getString("ALLOT_ST"));	
				debt.setCpt_cd(rs.getString("CPT_CD")==null?"":rs.getString("CPT_CD"));	
				debt.setLend_int(rs.getString("LEND_INT")==null?"":rs.getString("LEND_INT"));	
				debt.setLend_prn(rs.getString("LEND_PRN")==null?0:Integer.parseInt(rs.getString("LEND_PRN")));			
				debt.setAlt_fee(rs.getString("ALT_FEE")==null?0:Integer.parseInt(rs.getString("ALT_FEE")));			
				debt.setRtn_tot_amt(rs.getString("RTN_TOT_AMT")==null?0:Integer.parseInt(rs.getString("RTN_TOT_AMT")));		
				debt.setLoan_debtor(rs.getString("LOAN_DEBTOR")==null?"":rs.getString("LOAN_DEBTOR"));
				debt.setRtn_cdt(rs.getString("RTN_CDT")==null?"":rs.getString("RTN_CDT"));	
				debt.setRtn_way(rs.getString("RTN_WAY")==null?"":rs.getString("RTN_WAY"));	
				debt.setRtn_est_dt(rs.getString("RTN_EST_DT")==null?"":rs.getString("RTN_EST_DT"));
				debt.setLend_no(rs.getString("LEND_NO")==null?"":rs.getString("LEND_NO"));			
				debt.setNtrl_fee(rs.getString("NTRL_FEE")==null?0:Integer.parseInt(rs.getString("NTRL_FEE")));			
				debt.setStp_fee(rs.getString("STP_FEE")==null?0:Integer.parseInt(rs.getString("STP_FEE")));			
				debt.setLend_dt(rs.getString("LEND_DT")==null?"":rs.getString("LEND_DT"));	
				debt.setLend_int_amt(rs.getString("LEND_INT_AMT")==null?0:Integer.parseInt(rs.getString("LEND_INT_AMT")));		
				debt.setAlt_amt(rs.getString("ALT_AMT")==null?0:Integer.parseInt(rs.getString("ALT_AMT")));			
				debt.setTot_alt_tm(rs.getString("TOT_ALT_TM")==null?"":rs.getString("TOT_ALT_TM"));
				debt.setAlt_start_dt(rs.getString("ALT_START_DT")==null?"":rs.getString("ALT_START_DT"));
				debt.setAlt_end_dt(rs.getString("ALT_END_DT")==null?"":rs.getString("ALT_END_DT"));
				debt.setBond_get_st(rs.getString("BOND_GET_ST")==null?"":rs.getString("BOND_GET_ST"));
				debt.setFst_pay_dt(rs.getString("FST_PAY_DT")==null?"":rs.getString("FST_PAY_DT"));	
				debt.setFst_pay_amt(rs.getString("FST_PAY_AMT")==null?0:Integer.parseInt(rs.getString("FST_PAY_AMT")));		
				debt.setBond_get_st_sub(rs.getString("BOND_GET_ST_SUB")==null?"":rs.getString("BOND_GET_ST_SUB"));	
				debt.setCls_rtn_dt(rs.getString("CLS_RTN_DT")==null?"":rs.getString("CLS_RTN_DT"));	
				debt.setCls_rtn_amt(rs.getString("CLS_RTN_AMT")==null?0:Integer.parseInt(rs.getString("CLS_RTN_AMT")));			
				debt.setCls_rtn_fee(rs.getString("CLS_RTN_FEE")==null?0:Integer.parseInt(rs.getString("CLS_RTN_FEE")));			
				debt.setNote(rs.getString("NOTE")==null?"":rs.getString("NOTE"));	
				debt.setCpt_cd_st(rs.getString("CPT_CD_ST")==null?"":rs.getString("CPT_CD_ST"));	
				debt.setLend_id(rs.getString("LEND_ID")==null?"":rs.getString("LEND_ID"));	
				debt.setCar_mng_id(rs.getString("CAR_MNG_ID")==null?"":rs.getString("CAR_MNG_ID"));	
				debt.setLoan_st_dt(rs.getString("LOAN_ST_DT")==null?"":rs.getString("LOAN_ST_DT"));	
				debt.setLoan_sch_amt(rs.getString("LOAN_SCH_AMT")==null?0:Integer.parseInt(rs.getString("LOAN_SCH_AMT")));			
				debt.setPay_sch_amt(rs.getString("PAY_SCH_AMT")==null?0:Integer.parseInt(rs.getString("PAY_SCH_AMT")));			
				debt.setDif_amt(rs.getString("DIF_AMT")==null?0:Integer.parseInt(rs.getString("DIF_AMT")));			
				debt.setImsi_chk(rs.getString("IMSI_CHK")==null?"":rs.getString("IMSI_CHK"));	
				debt.setRtn_seq(rs.getString("RTN_SEQ")==null?"":rs.getString("RTN_SEQ"));	
				debt.setLoan_st(rs.getString("LOAN_ST")==null?"":rs.getString("LOAN_ST"));				
				debt.setCls_rtn_cau(rs.getString("cls_rtn_cau")==null?"":rs.getString("cls_rtn_cau"));				
				debt.setRimitter(rs.getString("rimitter")==null?"":rs.getString("rimitter"));				
				debt.setLend_int_vat(rs.getString("LEND_INT_VAT")==null?0:Integer.parseInt(rs.getString("LEND_INT_VAT")));			
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddBankLendDatabase:getBankLend_mapping_allot]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return debt;
		}
	}

	/**
	 *	매핑 테이블 INSERT -> 할부 수정
	 */
	public boolean updateBankMapping_allot2(BankMappingBean bm)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "update ALLOT set allot_st='2', lend_id=? where rent_mng_id=? and rent_l_cd=?";
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, bm.getLend_id());
			pstmt.setString(2, bm.getRent_mng_id());
			pstmt.setString(3, bm.getRent_l_cd());
			pstmt.executeUpdate();
			pstmt.close();
		    
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[AddBankLendDatabase:updateBankMapping_allot2]"+e);
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
	 *	매핑 테이블 INSERT -> 근저당설정 추가
	 */
	public boolean insertBankMapping_cltr(CltrBean cltr)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		String cltr_id="";

		String query_id = "select nvl(ltrim(to_char(max(cltr_id)+1, '00')), '01') ID from cltr\n "+
						  " where rent_mng_id =? and rent_l_cd=?" ;

		String query = "insert into CLTR \n"+
						" (RENT_MNG_ID, RENT_L_CD, CLTR_ID, CLTR_AMT, CLTR_PER_LOAN,\n"+
						" CLTR_EXP_DT, CLTR_SET_DT, REG_TAX, CLTR_DOCS_DT, CLTR_F_AMT,\n"+
						" CLTR_EXP_CAU, MORT_LANK, CLTR_USER, CLTR_OFFICE, CLTR_OFFI_MAN,\n"+
						" CLTR_OFFI_TEL, CLTR_OFFI_FAX, SET_STP_FEE, EXP_TAX, EXP_STP_FEE,\n"+
						" CLTR_ST, CLTR_NUM)\n"+
						" values\n"+
						" (?, ?, ?, ?, ?,"+
						" replace(?,'-',''), replace(?,'-',''), ?, replace(?,'-',''), ?,"+
						" ?, ?, ?, ?, ?,"+
						" ?, ?, ?, ?, ?,"+
						" ?, ?)";//22
		try 
		{
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query_id);
			pstmt1.setString(1, cltr.getRent_mng_id());
			pstmt1.setString(2, cltr.getRent_l_cd());
			rs = pstmt1.executeQuery();
			if(rs.next()){
				cltr_id = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt1.close();

			pstmt2 = conn.prepareStatement(query);
			pstmt2.setString(1, cltr.getRent_mng_id());
			pstmt2.setString(2, cltr.getRent_l_cd());
			pstmt2.setString(3, cltr_id);
			pstmt2.setInt   (4, cltr.getCltr_amt());
			pstmt2.setString(5, cltr.getCltr_per_loan());
			pstmt2.setString(6, cltr.getCltr_exp_dt());
			pstmt2.setString(7, cltr.getCltr_set_dt());
			pstmt2.setInt   (8, cltr.getReg_tax());
			pstmt2.setString(9, cltr.getCltr_docs_dt());
			pstmt2.setInt   (10, cltr.getCltr_f_amt());
			pstmt2.setString(11, cltr.getCltr_exp_cau());
			pstmt2.setString(12, cltr.getMort_lank());
			pstmt2.setString(13, cltr.getCltr_user());
			pstmt2.setString(14, cltr.getCltr_office());
			pstmt2.setString(15, cltr.getCltr_offi_man());
			pstmt2.setString(16, cltr.getCltr_offi_tel());
			pstmt2.setString(17, cltr.getCltr_offi_fax());
			pstmt2.setInt   (18, cltr.getSet_stp_fee());
			pstmt2.setInt   (19, cltr.getExp_tax());
			pstmt2.setInt   (20, cltr.getExp_stp_fee());
			pstmt2.setString(21, cltr.getCltr_st());
			pstmt2.setString(22, cltr.getCltr_num());
			pstmt2.executeUpdate();
			pstmt2.close();
		    
			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[AddBankLendDatabase:insertBankMapping_cltr]"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(rs != null )		rs.close();
				if(pstmt1 != null )	pstmt1.close();
				if(pstmt2 != null )	pstmt2.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}

	/**
	 *	매핑 테이블 update -> 근저당설정 수정
	 */
	public boolean updateBankMapping_cltr(CltrBean cltr)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "update CLTR set\n"+
						" CLTR_AMT=?, CLTR_PER_LOAN=?, CLTR_EXP_DT=replace(?,'-',''), CLTR_SET_DT=replace(?,'-',''), REG_TAX=?,\n"+
						" CLTR_DOCS_DT=replace(?,'-',''), CLTR_F_AMT=?, CLTR_EXP_CAU=?, MORT_LANK=?, CLTR_USER=?,\n"+
						" CLTR_OFFICE=?, CLTR_OFFI_MAN=?, CLTR_OFFI_TEL=?, CLTR_OFFI_FAX=?, SET_STP_FEE=?,\n"+
						" EXP_TAX=?, EXP_STP_FEE=?, CLTR_ST=?, CLTR_NUM=?\n"+
						" where rent_mng_id=? and rent_l_cd=? and cltr_id=?";//21
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, cltr.getCltr_amt());
			pstmt.setString(2, cltr.getCltr_per_loan());
			pstmt.setString(3, cltr.getCltr_exp_dt());
			pstmt.setString(4, cltr.getCltr_set_dt());
			pstmt.setInt(5, cltr.getReg_tax());
			pstmt.setString(6, cltr.getCltr_docs_dt());
			pstmt.setInt(7, cltr.getCltr_f_amt());
			pstmt.setString(8, cltr.getCltr_exp_cau());
			pstmt.setString(9, cltr.getMort_lank());
			pstmt.setString(10, cltr.getCltr_user());
			pstmt.setString(11, cltr.getCltr_office());
			pstmt.setString(12, cltr.getCltr_offi_man());
			pstmt.setString(13, cltr.getCltr_offi_tel());
			pstmt.setString(14, cltr.getCltr_offi_fax());
			pstmt.setInt(15, cltr.getSet_stp_fee());
			pstmt.setInt(16, cltr.getExp_tax());
			pstmt.setInt(17, cltr.getExp_stp_fee());
			pstmt.setString(18, cltr.getCltr_st());
			pstmt.setString(19, cltr.getCltr_num());
			pstmt.setString(20, cltr.getRent_mng_id());
			pstmt.setString(21, cltr.getRent_l_cd());
			pstmt.setString(22, cltr.getCltr_id());
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddBankLendDatabase:updateBankMapping_cltr]"+e);
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
	 *	매핑 테이블 조회 (근저당설정)
	 */
	public CltrBean getBankLend_mapping_cltr(String m_id, String l_cd)
	{
		getConnection();
		CltrBean cltr = new CltrBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		query = " select"+
				" cltr_id, cltr_amt, cltr_per_loan, reg_tax, cltr_f_amt, cltr_exp_cau, mort_lank,"+
				" cltr_user, cltr_office, cltr_offi_man, cltr_offi_tel, cltr_offi_fax,"+
				" set_stp_fee, exp_tax, exp_stp_fee, cltr_st, cltr_num,"+
				" decode(cltr_exp_dt, '', '', substr(cltr_exp_dt, 1, 4) || '-' || substr(cltr_exp_dt, 5, 2) || '-'||substr(cltr_exp_dt, 7, 2)) cltr_exp_dt,"+
				" decode(cltr_set_dt, '', '', substr(cltr_set_dt, 1, 4) || '-' || substr(cltr_set_dt, 5, 2) || '-'||substr(cltr_set_dt, 7, 2)) cltr_set_dt,"+
				" decode(cltr_docs_dt, '', '', substr(cltr_docs_dt, 1, 4) || '-' || substr(cltr_docs_dt, 5, 2) || '-'||substr(cltr_docs_dt, 7, 2)) cltr_docs_dt"+
				" from cltr"+
				" where rent_mng_id=? and rent_l_cd=?";
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, m_id);
			pstmt.setString(2, l_cd);
		   	rs = pstmt.executeQuery();
			if(rs.next()){
				cltr.setCltr_id(rs.getString("CLTR_ID")==null?"":rs.getString("CLTR_ID"));
				cltr.setCltr_amt(rs.getString("CLTR_AMT")==null?0:Integer.parseInt(rs.getString("CLTR_AMT")));
				cltr.setCltr_per_loan(rs.getString("CLTR_PER_LOAN")==null?"":rs.getString("CLTR_PER_LOAN"));
				cltr.setCltr_exp_dt(rs.getString("CLTR_EXP_DT")==null?"":rs.getString("CLTR_EXP_DT"));
				cltr.setCltr_set_dt(rs.getString("CLTR_SET_DT")==null?"":rs.getString("CLTR_SET_DT"));
				cltr.setReg_tax(rs.getString("REG_TAX")==null?0:Integer.parseInt(rs.getString("REG_TAX")));
				cltr.setCltr_docs_dt(rs.getString("CLTR_DOCS_DT")==null?"":rs.getString("CLTR_DOCS_DT"));
				cltr.setCltr_f_amt(rs.getString("CLTR_F_AMT")==null?0:Integer.parseInt(rs.getString("CLTR_F_AMT")));
				cltr.setCltr_exp_cau(rs.getString("CLTR_EXP_CAU")==null?"":rs.getString("CLTR_EXP_CAU"));
				cltr.setMort_lank(rs.getString("MORT_LANK")==null?"":rs.getString("MORT_LANK"));
				cltr.setCltr_user(rs.getString("CLTR_USER")==null?"":rs.getString("CLTR_USER"));
				cltr.setCltr_office(rs.getString("CLTR_OFFICE")==null?"":rs.getString("CLTR_OFFICE"));
				cltr.setCltr_offi_man(rs.getString("CLTR_OFFI_MAN")==null?"":rs.getString("CLTR_OFFI_MAN"));
				cltr.setCltr_offi_tel(rs.getString("CLTR_OFFI_TEL")==null?"":rs.getString("CLTR_OFFI_TEL"));
				cltr.setCltr_offi_fax(rs.getString("CLTR_OFFI_FAX")==null?"":rs.getString("CLTR_OFFI_FAX"));
				cltr.setSet_stp_fee(rs.getString("SET_STP_FEE")==null?0:Integer.parseInt(rs.getString("SET_STP_FEE")));
				cltr.setExp_tax(rs.getString("EXP_TAX")==null?0:Integer.parseInt(rs.getString("EXP_TAX")));
				cltr.setExp_stp_fee(rs.getString("EXP_STP_FEE")==null?0:Integer.parseInt(rs.getString("EXP_STP_FEE")));
				cltr.setCltr_st(rs.getString("CLTR_ST")==null?"":rs.getString("CLTR_ST"));
				cltr.setCltr_num(rs.getString("CLTR_NUM")==null?"":rs.getString("CLTR_NUM"));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddBankLendDatabase:getBankLend_mapping_cltr]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return cltr;
		}
	}

	/**
	 *	매핑 테이블 UPDATE
	 */
	public boolean updateBankMapping(BankMappingBean bm)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "update CAR_BANK set"+
							" LOAN_ST_DT = replace(?, '-', ''),"+
							" SUP_AMT = ?,"+
							" LOAN_AMT = ?,"+
							" LOAN_END_DT = replace(?, '-', ''),"+
							" DIF_AMT = ?,"+
							" LOAN_ACK_DT = replace(?, '-', ''),"+
							" SPE_AMT = ?,"+
							" LOAN_SCH_AMT = ?,"+
							" PAY_SCH_AMT = ?,"+
							" LEND_INT = ?"+
							" where CAR_MNG_ID = ? and LEND_ID = ?";
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, bm.getLoan_st_dt());
			pstmt.setInt(2, bm.getSup_amt());
			pstmt.setInt(3, bm.getLoan_amt());
			pstmt.setString(4, bm.getLoan_end_dt());
			pstmt.setInt(5, bm.getDif_amt());
			pstmt.setString(6, bm.getLoan_ack_dt());
			pstmt.setInt(7, bm.getSpe_amt());
			pstmt.setInt(8, bm.getLoan_sch_amt());
			pstmt.setInt(9, bm.getPay_sch_amt());
			pstmt.setString(10, bm.getLend_int());
			pstmt.setString(11, bm.getCar_mng_id());
			pstmt.setString(12, bm.getLend_id());
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
	 *	은행 매핑 테이블 SELECT
	 */
	public BankMappingBean getBankMapping(String lend_id, String car_mng_id)
	{
		getConnection();
		BankMappingBean bm = null;
		Statement stmt = null;
		ResultSet rs = null;

		String query =  " select"+
						" a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.firm_nm, a.client_nm, a.rent_dt, a.dlv_dt, a.car_nm, a.car_name, a.car_no, a.fee_amt, a.rtn_seq,"+
						" b.sup_amt, b.loan_amt, b.dif_amt, b.spe_amt, b.loan_sch_amt, b.pay_sch_amt, b.lend_int,"+
						" decode(b.LOAN_ST_DT, '', '', substr(b.LOAN_ST_DT, 1, 4)||'-'||substr(b.LOAN_ST_DT, 5, 2)||'-'||substr(b.LOAN_ST_DT, 7, 2)) LOAN_ST_DT,"+
						" decode(b.LOAN_END_DT, '', '', substr(b.LOAN_END_DT, 1, 4)||'-'||substr(b.LOAN_END_DT, 5, 2)||'-'||substr(b.LOAN_END_DT, 7, 2)) LOAN_END_DT,"+
						" decode(b.LOAN_ACK_DT, '', '', substr(b.LOAN_ACK_DT, 1, 4)||'-'||substr(b.LOAN_ACK_DT, 5, 2)||'-'||substr(b.LOAN_ACK_DT, 7, 2)) LOAN_ACK_DT,"+
						" b.cpt_cd, c.cltr_amt, c.cltr_per_loan max_cltr_rat"+
						" from car_bank_view a, car_bank b, cltr c"+
						" where a.car_mng_id=b.car_mng_id and a.lend_id=b.lend_id"+
						" and a.car_mng_id='"+car_mng_id+"' and a.lend_id='"+lend_id+"'";

		try {
				stmt = conn.createStatement();
		    	rs = stmt.executeQuery(query);
    	
			while(rs.next())
			{
				bm = new BankMappingBean();
				bm.setRent_mng_id(rs.getString("rent_mng_id")==null?"":rs.getString("rent_mng_id"));
				bm.setRent_l_cd(rs.getString("rent_l_cd")==null?"":rs.getString("rent_l_cd"));
				bm.setCar_mng_id(rs.getString("car_mng_id")==null?"":rs.getString("car_mng_id"));
				bm.setFirm_nm(rs.getString("firm_nm")==null?"":rs.getString("firm_nm"));
				bm.setClient_nm(rs.getString("client_nm")==null?"":rs.getString("client_nm"));
				bm.setRent_dt(rs.getString("rent_dt")==null?"":rs.getString("rent_dt"));
				bm.setDlv_dt(rs.getString("dlv_dt")==null?"":rs.getString("dlv_dt"));
				bm.setCar_nm(rs.getString("car_nm")==null?"":rs.getString("car_nm"));
				bm.setCar_name(rs.getString("car_name")==null?"":rs.getString("car_name"));
				bm.setCar_no(rs.getString("car_no")==null?"":rs.getString("car_no"));
				bm.setRtn_seq(rs.getString("rtn_seq")==null?"":rs.getString("rtn_seq"));
				bm.setFee_amt(rs.getInt("fee_amt"));
				bm.setSup_amt(rs.getInt("sup_amt"));
				bm.setLoan_amt(rs.getInt("loan_amt"));
				bm.setDif_amt(rs.getInt("dif_amt"));
				bm.setSpe_amt(rs.getInt("spe_amt"));
				bm.setLoan_sch_amt(rs.getInt("loan_sch_amt"));
				bm.setPay_sch_amt(rs.getInt("pay_sch_amt"));
				bm.setLend_int(rs.getString("lend_int")==null?"":rs.getString("lend_int"));
				bm.setLoan_st_dt(rs.getString("LOAN_ST_DT")==null?"":rs.getString("LOAN_ST_DT"));
				bm.setLoan_end_dt(rs.getString("LOAN_END_DT")==null?"":rs.getString("LOAN_END_DT"));
				bm.setLoan_ack_dt(rs.getString("LOAN_ACK_DT")==null?"":rs.getString("LOAN_ACK_DT"));
				bm.setCpt_cd(rs.getString("cpt_cd")==null?"":rs.getString("cpt_cd"));			
				bm.setCltr_amt(rs.getInt("cltr_amt"));
				bm.setMax_cltr_rat(rs.getString("max_cltr_rat")==null?"":rs.getString("max_cltr_rat"));			
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bm;
		}
	}		

	/**
	 *	매핑 테이블 update -> 지출일자 수정
	 */
	public boolean updateBankMapping_pay(String gubun, String m_id, String l_cd, String pay_dt)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query_pur_l = " update car_pur set pur_st='2', pur_pay_dt=replace(?, '-', '') "+
								" where rent_mng_id=? and rent_l_cd=?";
		String query_pur_r = " update car_pur set pur_pay_dt=replace(?, '-', '') "+
								" where rent_mng_id=? and rent_l_cd=?";

		try 
		{
			conn.setAutoCommit(false);
					
			if(gubun.equals("list")){
				pstmt = conn.prepareStatement(query_pur_l);
			}else{
				pstmt = conn.prepareStatement(query_pur_r);
			}
				pstmt.setString(1, pay_dt);
				pstmt.setString(2, m_id);
				pstmt.setString(3, l_cd);
			    pstmt.executeUpdate();
				pstmt.close();
			    
			    conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddBankLendDatabase:updateBankMapping_pay]"+e);
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

	//은행대출 상환별 스케줄 생성 여부 ==> bank_lend_u.jsp에서 호출
	public String getRtnScdYn(String lend_id, String seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String rtnStr = "";

		String table = "scd_bank";
		

		String query = " select count(*) "+
						" from "+table+" where lend_id = ? and rtn_seq = ?";
		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, lend_id);
			pstmt.setString(2, seq);
		   	rs = pstmt.executeQuery();
			while(rs.next())
			{
				rtnStr = rs.getString(1)==null?"":rs.getString(1);
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
			return rtnStr;
		}							
	} 

	/**
	 *	순차상환일 경우 상환별 대출금액 조회 ==> bank_lend_u.jsp에서 호출
	 */
	public int getRtn_cont_amt(String lend_id, int rtn_seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int rtn_cont_amt = 0;
		String query = 	" select sum(lend_prn) rtn_cont_amt from allot "+
						" where loan_st='2' and lend_id=? and rtn_seq=?";
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, lend_id);
			pstmt.setInt(2, rtn_seq);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next()){
				rtn_cont_amt = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddBankLendDatabase:getRtn_cont_amt]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return rtn_cont_amt;
		}
	}


	/**
	 *	은행 매핑 상환정보
	 */
	public Hashtable getBankRtn_info(String lend_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		query = " select nvl(a.rtn_st,''), nvl(b.rtn_su,'')"+ 
				" from lend_bank a, (select count(*) rtn_su from bank_rtn where lend_id='"+lend_id+"') b"+
				" where a.lend_id='"+lend_id+"'";
		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
			if(rs.next()){			
				ht.put("RTN_ST", rs.getString(1)==null?"":rs.getString(1));
				ht.put("RTN_SU", rs.getString(2)==null?"":rs.getString(2));
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddBankLendDatabase:getBankRtn_info]\n"+e);
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
	 * 진행중인 상환번호 가져오기
	 */
	public Vector getRtn_move_st_ok(String lend_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "SELECT seq FROM bank_rtn where lend_id='"+lend_id+"' and rtn_move_st='0'";
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			while(rs.next()){				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put("SEQ", (rs.getString(1)==null?"":rs.getString(1)));
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddBankLendDatabase:getRtn_move_st_ok]\n"+e);
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
	 *	한 건에 대한 할부금 스케줄 쿼리
	 *	car_id : 차량관리번호, alt_tm : 회차
	 */
	public Vector getDebtScd(String car_id)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	" select"+
							" CAR_MNG_ID, ALT_TM,"+
							" decode(ALT_EST_DT, '', '', substr(ALT_EST_DT, 1, 4) || '-' || substr(ALT_EST_DT, 5, 2) || '-'||substr(ALT_EST_DT, 7, 2)) ALT_EST_DT,"+
							" ALT_PRN, ALT_INT, PAY_YN, ALT_REST,"+
							" decode(PAY_DT, '', '', substr(PAY_DT, 1, 4) || '-' || substr(PAY_DT, 5, 2) || '-'||substr(PAY_DT, 7, 2)) PAY_DT"+
							" from scd_alt_case "+
							" where car_mng_id = ?"+
							" order by to_number(ALT_TM)";											
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_id);
	    	rs = pstmt.executeQuery();    	
			while(rs.next()){
				DebtScdBean debt = new DebtScdBean();
				debt.setCar_mng_id(rs.getString("CAR_MNG_ID")==null?"":rs.getString("CAR_MNG_ID"));
				debt.setAlt_tm(rs.getString("ALT_TM")==null?"":rs.getString("ALT_TM"));
				debt.setAlt_est_dt(rs.getString("ALT_EST_DT")==null?"":rs.getString("ALT_EST_DT"));
				debt.setAlt_prn(rs.getString("ALT_PRN")==null?0:Integer.parseInt(rs.getString("ALT_PRN")));
				debt.setAlt_int(rs.getString("ALT_INT")==null?0:Integer.parseInt(rs.getString("ALT_INT")));
				debt.setPay_yn(rs.getString("PAY_YN")==null?"":rs.getString("PAY_YN"));
				debt.setPay_dt(rs.getString("PAY_DT")==null?"":rs.getString("PAY_DT"));
				debt.setAlt_rest(rs.getString("ALT_REST")==null?0:Integer.parseInt(rs.getString("ALT_REST")));
				vt.add(debt);
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
	 *	한 건에 대한 한회차 할부금 스케줄 쿼리
	 *	car_id : 차량관리번호, alt_tm : 회차
	 */
	public DebtScdBean getADebtScd(String car_id, String alt_tm)
	{
		getConnection();
		DebtScdBean debt = new DebtScdBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	" select"+
							" CAR_MNG_ID, ALT_TM, ALT_EST_DT, ALT_PRN, ALT_INT, PAY_YN, PAY_DT, ALT_REST "+
							" from scd_alt_case "+
							" where car_mng_id = ? and alt_tm = ?";											
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, car_id);
				pstmt.setString(2, alt_tm);
		    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				debt.setCar_mng_id(rs.getString("CAR_MNG_ID")==null?"":rs.getString("CAR_MNG_ID"));
				debt.setAlt_tm(rs.getString("ALT_TM")==null?"":rs.getString("ALT_TM"));
				debt.setAlt_est_dt(rs.getString("ALT_EST_DT")==null?"":rs.getString("ALT_EST_DT"));
				debt.setAlt_prn(rs.getString("ALT_PRN")==null?0:Integer.parseInt(rs.getString("ALT_PRN")));
				debt.setAlt_int(rs.getString("ALT_INT")==null?0:Integer.parseInt(rs.getString("ALT_INT")));
				debt.setPay_yn(rs.getString("PAY_YN")==null?"":rs.getString("PAY_YN"));
				debt.setPay_dt(rs.getString("PAY_DT")==null?"":rs.getString("PAY_DT"));
				debt.setAlt_rest(rs.getString("ALT_REST")==null?0:Integer.parseInt(rs.getString("ALT_REST")));
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
			return debt;
		}
	}

	/**
	 *	대여료스케줄 update
	 */
	public boolean updateDebtScd(DebtScdBean debt)
	{
		getConnection();
		boolean flag = true;
		String query = "update scd_alt_case set"+
						" ALT_EST_DT = replace(?, '-', ''),"+
						" ALT_PRN = ?,"+
						" ALT_INT = ?,"+
						" PAY_YN = ?,"+
						" PAY_DT = replace(?, '-', ''),"+
						" ALT_REST = ?,"+
						" R_ALT_EST_DT = replace(?, '-', '')"+
						" where CAR_MNG_ID = ? and ALT_TM = ?";
						
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, debt.getAlt_est_dt());
			pstmt.setInt(2, debt.getAlt_prn());
			pstmt.setInt(3, debt.getAlt_int());
			pstmt.setString(4, debt.getPay_yn());
			pstmt.setString(5, debt.getPay_dt());
			pstmt.setInt(6, debt.getAlt_rest());
			pstmt.setString(7, debt.getR_alt_est_dt());
			pstmt.setString(8, debt.getCar_mng_id());
			pstmt.setString(9, debt.getAlt_tm());
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

	//계약 변경 : 중도해지 조회
	public Hashtable getBankClsinfo(String lend_id, String rtn_seq)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		query = " select"+
				" decode(a.cont_bn_st, '','', '1','제1금융권', '2','제2금융권') cont_bn_st, a.cont_bn, a.bn_br, a.lend_int,"+
				" decode(a.rtn_st, '','', '0','전체', '1','순차','2','분할') rtn_st, b.rtn_cont_amt, c.alt_tm,"+
				" decode(a.cont_dt, '', '', substr(a.cont_dt, 1, 4) || '-' || substr(a.cont_dt, 5, 2) || '-'||substr(a.cont_dt, 7, 2)) cont_dt, a.cls_rtn_fee_int, a.cls_rtn_etc"+
				" from lend_bank a, bank_rtn b,"+
				" (select lend_id, rtn_seq, max(to_number(alt_tm)) alt_tm from scd_bank where pay_yn='1' group by lend_id, rtn_seq) c"+
				" where a.lend_id=b.lend_id(+) and b.lend_id=c.lend_id(+) and b.seq=c.rtn_seq(+)"+
				" and a.lend_id='"+lend_id+"' and b.seq='"+rtn_seq+"'";


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
			System.out.println("[AddBankLendDatabase:getBankClsinfo]\n"+e);			
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

	//계약 변경 : 중도해지 조회 - 미상환금
	public Hashtable getBankNalt_rest(String lend_id, String rtn_seq, String alt_tm)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		if(alt_tm.equals("")) alt_tm="1";

		String query = "select a.alt_rest, b.nalt_rest_1, b.nalt_rest_2, "+
						" decode(a.pay_dt, '', '', substr(a.pay_dt, 1, 4) || '-' || substr(a.pay_dt, 5, 2) || '-'||substr(a.pay_dt, 7, 2)) pay_dt"+
						" from scd_bank a, "+
						" (select sum(decode(substr(alt_est_dt,1,4),to_char(sysdate,'YYYY'),alt_prn_amt)) nalt_rest_1, "+
                        "         sum(decode(substr(alt_est_dt,1,4),to_char(sysdate,'YYYY'),0,alt_prn_amt)) nalt_rest_2 "+
						"  from scd_bank where lend_id='"+lend_id+"' and rtn_seq='"+rtn_seq+"' and pay_yn='0') b "+
						" where a.lend_id='"+lend_id+"' and a.rtn_seq='"+rtn_seq+"' and a.alt_tm='"+alt_tm+"'";
/*
		String query = "select alt_rest,"+
						" decode(pay_dt, '', '', substr(pay_dt, 1, 4) || '-' || substr(pay_dt, 5, 2) || '-'||substr(pay_dt, 7, 2)) pay_dt"+
						" from scd_bank where lend_id='"+lend_id+"' and rtn_seq='"+rtn_seq+"' and alt_tm='"+alt_tm+"'";
*/
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
			System.out.println("[AddBankLendDatabase:getBankNalt_rest]\n"+e);			
			System.out.println("[AddBankLendDatabase:getBankNalt_rest]\n"+query);			
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

	//계약 변경 : 중도해지 조회 - 연체할부금
	public int getBankDly_alt(String lend_id, String rtn_seq)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		int dly_alt = 0;
		String query = "select sum(alt_prn_amt+alt_int_amt) dly_alt from scd_bank where lend_id='"+lend_id+"' and rtn_seq='"+rtn_seq+"' and pay_yn='0' and alt_est_dt<to_char(sysdate,'yyyymmdd')";

		try {
			stmt = conn.createStatement();
		   	rs = stmt.executeQuery(query);
			if(rs.next()){				
				dly_alt= rs.getInt(1);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddBankLendDatabase:getBankDly_alt]\n"+e);			
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return dly_alt;
		}	
	}

	//계약 변경 : 중도해지 조회 - 선수금
	public int getBankBe_alt(String lend_id, String rtn_seq)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		int be_alt = 0;
		String query = "select sum(alt_prn_amt+alt_int_amt) be_alt from scd_bank where lend_id='"+lend_id+"' and rtn_seq='"+rtn_seq+"' and pay_yn='1' and alt_est_dt>to_char(sysdate,'yyyymmdd') and alt_est_dt > pay_dt";

		try {
			stmt = conn.createStatement();
		   	rs = stmt.executeQuery(query);
			if(rs.next()){				
				be_alt= rs.getInt(1);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddBankLendDatabase:getBankBe_alt]\n"+e);			
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return be_alt;
		}	
	}

	/**
	 *	한 건에 대한 한회차 할부금 스케줄 쿼리 -- 출금처리위한
	 *	lend_id : 은행대출ID, rtn_seq : 상환번호, alt_tm : 회차
	 */
	public Hashtable getADebtScdPay_bank(String lend_id, String rtn_seq, String alt_tm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		query = " select a.lend_id, a.cont_bn, decode(a.rtn_st, '','', '0','전체', '1','순차', '2','분할') rtn_st, c.alt_tm, c.alt_prn_amt, c.alt_int_amt, (c.alt_prn_amt+c.alt_int_amt) alt_amt,"+ 
				" decode(c.alt_est_dt, '', '', substr(c.alt_est_dt, 1, 4) || '-' || substr(c.alt_est_dt, 5, 2) || '-'||substr(c.alt_est_dt, 7, 2)) alt_est_dt,"+
				" decode(c.pay_dt, '', '', substr(c.pay_dt, 1, 4) || '-' || substr(c.pay_dt, 5, 2) || '-'||substr(c.pay_dt, 7, 2)) pay_dt"+
				" from lend_bank a, bank_rtn b, scd_bank c"+
				" where a.lend_id=b.lend_id(+) and b.lend_id=c.lend_id(+) and b.seq=c.rtn_seq(+)"+
				" and a.lend_id = '"+lend_id+"' and c.rtn_seq='"+rtn_seq+"' and c.alt_tm='"+alt_tm+"'";
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
			System.out.println("[AddBankLendDatabase:getADebtScdPay_bank]\n"+e);			
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
	 *	리스트 : 자동차관리 - 저당권설정 리스트
	 */
	public Vector getCltr_list(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query = " SELECT a.cltr_user, a.cltr_amt, a.cltr_set_dt, a.cltr_exp_dt, a.cltr_exp_cau, b.lend_dt"+
						" FROM CLTR a, ALLOT b"+
						" WHERE a.cltr_st='Y' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
					  " and a.rent_mng_id='"+rent_mng_id+"' and a.rent_l_cd='"+rent_l_cd+"'";

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
			System.out.println("[AddBankLendDatabase:getCltr_list]"+e);
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
	 *	리스트 : 자동차관리 - 저당권설정 리스트
	 */
	public Vector getCltr_list2(String car_mng_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query = " select a.cltr_user, a.cltr_amt, a.cltr_set_dt, a.cltr_exp_dt, a.cltr_exp_cau, f.lend_dt"+
//						" c.car_no, c.first_car_no, e.firm_nm,"+
//						" b.use_yn, d.cls_st, d.cls_dt, a.*"+
						" from cltr a, cont b, car_reg c, cls_cont d, client e, allot f"+
						" where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd "+
						" and b.car_mng_id=c.car_mng_id"+
						" and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+)"+
						" and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd"+
						" and b.client_id=e.client_id"+
						" and c.car_mng_id='"+car_mng_id+"'"+
						" and a.cltr_st='Y'";

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
			System.out.println("[AddBankLendDatabase:getCltr_list2]"+e);
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
	
	//잔액이 있을 수 있음. -대구은행은 약정액으로 20120511
	public Vector getBankLendList(String st_dt, String end_dt, String bank_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
				
		/*  20160517 묶음대출 -  allot 제외 
		query = " SELECT "+
				"        '1' gubun, L.lend_id, L.cont_dt, L.cont_st,  L.cont_bn cpt_cd, C.nm_cd bank_nm, L.bn_br,  decode( L.cont_bn , '0026',  l.cont_amt,  case when l.cont_amt <> b1.pm_rest_amt then b1.pm_rest_amt else l.cont_amt end) cont_amt, L.acct_code, \n"+
			  	"	     L.lend_int, R.cont_start_dt, R.cont_term, L.f_acct_yn , '' lend_no,  '' rent_mng_id, ''firm_nm, r.ven_code, s.scd_cnt \n"+
				" FROM   LEND_BANK L, CODE C, (select * from BANK_RTN where seq='1') R , (select lend_id, count(*) scd_cnt from scd_bank group by lend_id) S,    \n"+
				"   	  (select  lend_id, sum(lend_prn) pm_rest_amt from allot a, (select max(rent_l_cd) rent_l_cd from allot group by car_mng_id) b where a.rent_l_cd=b.rent_l_cd group by lend_id) b1  \n"+
				" WHERE  L.cont_bn = C.CODE AND C.c_st = '0003' AND	 C.CODE <> '0000' \n"+
				"        AND   C.CODE LIKE '%"+bank_id+"%' AND	 L.LEND_ID = R.LEND_ID(+)  and l.lend_id = s.lend_id(+) \n"+
				"        AND   replace(L.cont_dt, '-', '') between replace('" + st_dt +"', '-', '')  and replace('"+ end_dt +"', '-', '')  \n"+
				"   	 and l.LEND_ID=b1.LEND_ID(+) \n"+
				" union \n"+
				" select +
				"        '2' gubun, a.rent_l_cd lend_id, a.lend_dt cont_dt, '' cont_st, a.cpt_cd, C.nm_cd bank_nm, cr.car_no bn_br, a.lend_prn cont_amt, a.acct_code, \n"+
			    "        a.lend_int, a.alt_start_dt cont_start_dt, a.tot_alt_tm cont_term,  a.f_acct_yn,  a.lend_no,  a.rent_mng_id, v.firm_nm , a.ven_code, r.scd_cnt \n"+
			 	" from   ALLOT a, CODE C, car_reg cr,  cont_n_view v, cont_etc ce, (select  car_mng_id, count(*) scd_cnt  from scd_alt_case group by car_mng_id) R  \n"+
			 	" WHERE  a.rent_mng_id = v.rent_mng_id and a.rent_l_cd = v.rent_l_cd and a.cpt_cd= C.CODE AND C.c_st = '0003' AND C.CODE <> '0000' and v.car_mng_id = r.car_mng_id(+)\n"+ //and a.lend_id is  null  
			 	" 		and a.rent_mng_id = ce.rent_mng_id and a.rent_l_cd =ce.rent_l_cd and ce.rent_suc_dt is null \n"+ //승계가 아닌 원계약이면 
			 	"		and v.car_mng_id = cr.car_mng_id(+) and v.reg_dt <= a.lend_dt \n"+  //승계등이 있다....
			 	"        AND C.CODE LIKE '%"+bank_id+"%' and replace(a.lend_dt, '-', '') between replace('" + st_dt +"', '-', '')  and replace('"+ end_dt +"', '-', '')  \n"+
 				" ORDER BY  1, 3, 2";
 	*/			
 		
 		query = " SELECT "+
	//			"        '1' gubun, L.lend_id, L.cont_dt, L.cont_st,  L.cont_bn cpt_cd, C.nm_cd bank_nm, L.bn_br,  decode( L.cont_bn , '0026',  l.cont_amt,  case when l.cont_amt <> b1.pm_rest_amt then b1.pm_rest_amt else l.cont_amt end) cont_amt, L.acct_code, \n"+
				"        '1' gubun, L.lend_id, L.cont_dt, L.cont_st,  L.cont_bn cpt_cd, C.nm_cd bank_nm, L.bn_br,   l.cont_amt,   L.acct_code, \n"+
			  	"	     L.lend_int, R.cont_start_dt, R.cont_term, L.f_acct_yn , '' lend_no,  '' rent_mng_id, ''firm_nm, r.ven_code, s.scd_cnt , s.alt_prn  debt_amt \n"+
				" FROM   LEND_BANK L, CODE C, (select * from BANK_RTN where seq='1') R , (select lend_id, count(*) scd_cnt , sum(alt_prn_amt) alt_prn  from scd_bank group by lend_id) S    \n"+
	//			"   	  (select  lend_id, sum(lend_prn) pm_rest_amt from allot a, (select max(rent_l_cd) rent_l_cd from allot group by car_mng_id) b where a.rent_l_cd=b.rent_l_cd group by lend_id) b1  \n"+
				" WHERE  L.cont_bn = C.CODE AND C.c_st = '0003' AND	 C.CODE <> '0000' \n"+
				"        AND   C.CODE LIKE '%"+bank_id+"%' AND	 L.LEND_ID = R.LEND_ID(+)  and l.lend_id = s.lend_id(+) \n"+
				"        AND   replace(L.cont_dt, '-', '') between replace('" + st_dt +"', '-', '')  and replace('"+ end_dt +"', '-', '')  \n"+
		//		"   	 and l.LEND_ID=b1.LEND_ID(+) \n"+
				" union \n"+
				" select /*+  merge(v) */ "+
				"        '2' gubun, a.rent_l_cd lend_id, a.lend_dt cont_dt, '' cont_st, a.cpt_cd, C.nm_cd bank_nm, cr.car_no bn_br, a.lend_prn cont_amt, a.acct_code, \n"+
			    "        a.lend_int, a.alt_start_dt cont_start_dt, a.tot_alt_tm cont_term,  a.f_acct_yn,  a.lend_no,  a.rent_mng_id, v.firm_nm , a.ven_code, r.scd_cnt,  r.alt_prn  debt_amt  \n"+
			 	" from   ALLOT a, CODE C, car_reg cr,  cont_n_view v, cont_etc ce, (select  car_mng_id, count(*) scd_cnt , sum(alt_prn) alt_prn  from scd_alt_case group by car_mng_id) R   \n"+			
			 	" WHERE  a.rent_mng_id = v.rent_mng_id and a.rent_l_cd = v.rent_l_cd and a.cpt_cd= C.CODE AND C.c_st = '0003' AND C.CODE <> '0000' and v.car_mng_id = r.car_mng_id(+)\n"+ //and a.lend_id is  null  
			 	" 		and a.rent_mng_id = ce.rent_mng_id and a.rent_l_cd =ce.rent_l_cd and ce.rent_suc_dt is null and v.car_gu <> '0'  \n"+ //승계가 아닌 원계약이면 	, 재리스가 아니면 		.
			 	"		and v.car_mng_id = cr.car_mng_id(+) and v.reg_dt <= a.lend_dt and a.lend_id is null \n"+  //승계등이 있다....
			 	"        AND C.CODE LIKE '%"+bank_id+"%' and replace(a.lend_dt, '-', '') between replace('" + st_dt +"', '-', '')  and replace('"+ end_dt +"', '-', '')  \n"+
				" union \n"+
				" select /*+  merge(v) */ "+
				"        '3' gubun, a.rent_l_cd lend_id, a.lend_dt cont_dt, '' cont_st, a.cpt_cd, C.nm_cd bank_nm, cr.car_no bn_br, a.alt_etc_amt cont_amt, a.acct_code, \n"+
			    "        a.lend_int, a.alt_start_dt cont_start_dt, a.tot_alt_tm cont_term,  a.f_acct_yn,  a.lend_no,  a.rent_mng_id, v.firm_nm , a.ven_code, r.scd_cnt ,  r.alt_prn  debt_amt  \n"+
			 	" from   ALLOT a, CODE C, car_reg cr,  cont_n_view v, cont_etc ce, (select  car_mng_id, count(0) scd_cnt, sum(alt_prn) alt_prn, sum(alt_int) alt_int  from scd_alt_etc group by car_mng_id) R   \n"+			
			 	" WHERE  a.rent_mng_id = v.rent_mng_id and a.rent_l_cd = v.rent_l_cd and a.cpt_cd= C.CODE AND C.c_st = '0003' AND C.CODE <> '0000' and v.car_mng_id = r.car_mng_id(+)\n"+ //and a.lend_id is  null  
			 	" 		and a.rent_mng_id = ce.rent_mng_id and a.rent_l_cd =ce.rent_l_cd and ce.rent_suc_dt is null and v.car_gu <> '0'  \n"+ //승계가 아닌 원계약이면 	, 재리스가 아니면 		.
			 	"		and v.car_mng_id = cr.car_mng_id(+) and v.reg_dt <= a.lend_dt and a.lend_id is null \n"+  //승계등이 있다....
			 	"       and a.alt_etc_amt is not null and a.alt_etc_amt >0 \n"+
			 	"        AND C.CODE LIKE '%"+bank_id+"%' and replace(a.lend_dt, '-', '') between replace('" + st_dt +"', '-', '')  and replace('"+ end_dt +"', '-', '')  \n"+
 				" ORDER BY  1, 3, 2"; 						
					
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
		  		System.out.println("[AddBankLendDatabase:getBankLendList]"+query);
			} finally {
				try{
	                if(rs != null )		rs.close();
	                if(pstmt != null)	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return vt;
			}
	}	

		
	public Hashtable getBankLendAcctList(String lend_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";	
		
		//약정잔액이 있는 경우도 있음.
		/* 20160517 수정  - 묶은대출인 경우 allot 제외 
		query = " select "+
			//	"        a.lend_id, a.cont_dt, a.cont_amt, b.ven_code, a.acct_code, '' car_no,  \n"+
				"        a.lend_id, a.cont_dt,  decode( a.cont_bn , '0026',  a.cont_amt,  case when a.cont_amt <> b1.pm_rest_amt then b1.pm_rest_amt else a.cont_amt end) cont_amt ,  b.ven_code, a.acct_code, '' car_no,  \n"+
				"        sum(case when substr(a.cont_dt,0,4) = substr(c.alt_est_dt, 0,4) then c.alt_prn_amt else  0 end)  b_amt, sum(case when substr(a.cont_dt,0,4) = substr(c.alt_est_dt, 0,4) then  0 else  c.alt_prn_amt end)  a_amt \n"+
				" from   lend_bank a,  bank_rtn b , scd_bank c ,  \n"+
				"   	  (select  lend_id, sum(lend_prn) pm_rest_amt from allot a, (select max(rent_l_cd) rent_l_cd from allot group by car_mng_id) b where a.rent_l_cd=b.rent_l_cd group by lend_id) b1  \n"+
        		" where  a.lend_id = b.lend_id and a.lend_id = '"+lend_id+"' and a.lend_id = c.lend_id and b.seq = c.rtn_seq \n"+
        		"   and a.LEND_ID=b1.LEND_ID(+) \n"+
         		" group by     a.lend_id, a.cont_bn, a.cont_dt, a.cont_amt, b1.pm_rest_amt, b.ven_code , a.acct_code \n"+  
         		" union \n"+
         		" select 
				"        a.rent_l_cd lend_id, a.lend_dt cont_dt, a.lend_prn cont_amt, a.ven_code, a.acct_code, cr.car_no, \n"+  
 				"        sum(case when substr(a.lend_dt,0,4) = substr(b.alt_est_dt, 0,4) then b.alt_prn else  0 end ) b_amt,  sum(case when substr(a.lend_dt,0,4) = substr(b.alt_est_dt, 0,4) then  0 else  b.alt_prn end) a_amt \n"+
				" from   allot a, scd_alt_case b, cont_n_view v, car_reg cr  \n"+
 				" where  a.rent_l_cd = '"+lend_id+"'  and a.rent_mng_id = v.rent_mng_id and a.rent_l_cd = v.rent_l_cd \n"+
  				"        and v.car_mng_id = b.car_mng_id and v.car_mng_id = cr.car_mng_id(+) \n"+
   				" group by a.rent_l_cd, a.lend_dt, a.lend_prn, a.ven_code, a.acct_code, cr.car_no ";
	*/	
		
			//약정잔액이 있는 경우도 있음.
		query = " select "+
				"        a.lend_id, a.cont_dt, a.cont_amt, b.ven_code, a.acct_code, '' car_no,  '' car_use ,  \n"+
			//	"        a.lend_id, a.cont_dt,  decode( a.cont_bn , '0026',  a.cont_amt,  case when a.cont_amt <> b1.pm_rest_amt then b1.pm_rest_amt else a.cont_amt end) cont_amt ,  b.ven_code, a.acct_code, '' car_no,  \n"+
				"        sum(case when substr(a.cont_dt,0,4) = substr(c.alt_est_dt, 0,4) then c.alt_prn_amt else  0 end)  b_amt, sum(case when substr(a.cont_dt,0,4) = substr(c.alt_est_dt, 0,4) then  0 else  c.alt_prn_amt end)  a_amt \n"+
				" from   lend_bank a,  bank_rtn b , scd_bank c  \n"+
		//		"   	  (select  lend_id, sum(lend_prn) pm_rest_amt from allot a, (select max(rent_l_cd) rent_l_cd from allot group by car_mng_id) b where a.rent_l_cd=b.rent_l_cd group by lend_id) b1  \n"+
        		" where  a.lend_id = b.lend_id and a.lend_id = '"+lend_id+"' and a.lend_id = c.lend_id and b.seq = c.rtn_seq \n"+
  //      		"   and a.LEND_ID=b1.LEND_ID(+) \n"+
         		" group by     a.lend_id, a.cont_bn, a.cont_dt, a.cont_amt,  b.ven_code , a.acct_code \n"+  
         		" union \n"+
         		" select /*+  merge(v) */ "+
				"        a.rent_l_cd lend_id, a.lend_dt cont_dt, a.lend_prn cont_amt, a.ven_code, a.acct_code, cr.car_no, cr.car_use , \n"+  
 				"        sum(case when substr(a.lend_dt,0,4) = substr(b.alt_est_dt, 0,4) then b.alt_prn else  0 end ) b_amt,  sum(case when substr(a.lend_dt,0,4) = substr(b.alt_est_dt, 0,4) then  0 else  b.alt_prn end) a_amt \n"+
				" from   allot a, scd_alt_case b, cont_n_view v, car_reg cr  \n"+
 				" where  a.rent_l_cd = '"+lend_id+"'  and a.rent_mng_id = v.rent_mng_id and a.rent_l_cd = v.rent_l_cd \n"+
  				"        and v.car_mng_id = b.car_mng_id and v.car_mng_id = cr.car_mng_id(+) \n"+
   				" group by a.rent_l_cd, a.lend_dt, a.lend_prn, a.ven_code, a.acct_code, cr.car_no , cr.car_use  ";
		
		
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
			System.out.println("[AddBankLendDatabase:getBankLendAcctList]\n"+e);			
			System.out.println("[AddBankLendDatabase:getBankLendAcctList]\n"+query);			
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
	
	//기타비용
	public Hashtable getBankLendAcctListEtc(String lend_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";	
		
		query = " select /*+  merge(v) */ "+
				"        a.rent_l_cd lend_id, a.lend_dt cont_dt, a.alt_etc_amt cont_amt, a.ven_code, a.acct_code, cr.car_no, cr.car_use , \n"+  
 				"        sum(case when substr(a.lend_dt,0,4) = substr(b.alt_est_dt, 0,4) then b.alt_prn else  0 end ) b_amt,  sum(case when substr(a.lend_dt,0,4) = substr(b.alt_est_dt, 0,4) then  0 else  b.alt_prn end) a_amt \n"+
				" from   allot a, scd_alt_etc b, cont_n_view v, car_reg cr  \n"+
 				" where  a.rent_l_cd = '"+lend_id+"'  and a.rent_mng_id = v.rent_mng_id and a.rent_l_cd = v.rent_l_cd \n"+
  				"        and v.car_mng_id = b.car_mng_id and v.car_mng_id = cr.car_mng_id(+) \n"+
   				" group by a.rent_l_cd, a.lend_dt, a.alt_etc_amt, a.ven_code, a.acct_code, cr.car_no , cr.car_use  ";
		
		
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
			System.out.println("[AddBankLendDatabase:getBankLendAcctListEtc]\n"+e);			
			System.out.println("[AddBankLendDatabase:getBankLendAcctListEtc]\n"+query);			
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
	 *	선수금 전표발행
	 */
	public boolean updateFacctYn(String lend_id, String gubun )
	{
		getConnection();
		boolean flag = true;
		String query = "";
		
		if (gubun.equals("1")) {						
			 query = "update lend_bank set f_acct_yn = 'Y' "+
						" where lend_id = ?  ";  //2
		} else{
			 query = "update allot set f_acct_yn = 'Y' "+
						" where rent_l_cd = ?  ";  //2
	   }
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
				
			pstmt.setString(1, lend_id);		
					
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
	 *	수정 : 은행대출 상환 UPDATE
	 */
	public boolean updateBankRtnVencode(String lend_id, String rtn_seq, String ven_code)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query = " update BANK_RTN set VEN_CODE = ? where LEND_ID = ? ";

		if(!rtn_seq.equals(""))	query += " and SEQ = ?";
			
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, ven_code);
			pstmt.setString(2, lend_id);
			if(!rtn_seq.equals("")){
				pstmt.setString(3, rtn_seq);		
			}
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddBankLendDatabase:updateBankRtnVencode]"+e);
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
	
	/*====================================================================

		                           자금관리

	  ====================================================================*/

	/**
	 *	자금관리리스트
	 */
	public Vector getWorkingFundList(String gubun1, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
			
		query = " SELECT a.fund_no, a.fund_id, decode(a.fund_type,'1','운용자금','2','시설자금') fund_type, d.nm as bank_nm, a.cont_amt, b.app_b_st, b.fund_int, b.app_b_dt, a.ba_agnt \n"+
				" FROM   WORKING_FUND a, WORKING_FUND_INT b, (SELECT fund_id, max(seq) seq FROM WORKING_FUND_INT GROUP BY fund_id) c, \n"+
				"        (SELECT * FROM CODE WHERE c_st='0003' AND CODE<>'0000') d \n"+
				" WHERE  a.fund_id=b.fund_id \n"+
				"        AND b.fund_id=c.fund_id AND b.seq=c.seq \n"+
				"        AND a.cont_bn=d.code ";

		if(!gubun1.equals("")) query += " and a.cont_bn ='"+gubun1+"'";

		if(gubun2.equals("0")) query += " and a.cls_dt is null ";		//진행
		if(gubun2.equals("1")) query += " and a.cls_dt is not null ";	//종료

		query += " order by a.cont_dt desc, a.fund_id ";


				
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
	 *	자금관리리스트
	 */
	public Vector getWorkingFundList(String gubun1, String gubun2, String bank_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String subQuery = "";
		
		if(!gubun1.equals("")) subQuery += " and e.GUBUN='"+gubun1+"'\n";
			
		query = " SELECT a.fund_no, a.fund_id, decode(a.fund_type,'1','운용자금','2','시설자금') fund_type, d.nm as bank_nm, a.cont_amt, b.app_b_st, b.fund_int, b.app_b_dt, a.ba_agnt, e.gubun \n"+
				" FROM   WORKING_FUND a, WORKING_FUND_INT b, (SELECT fund_id, max(seq) seq FROM WORKING_FUND_INT GROUP BY fund_id) c, \n"+
				"        (SELECT * FROM CODE WHERE c_st='0003' AND CODE<>'0000') d, CODE_ETC e \n"+
				" WHERE  a.fund_id=b.fund_id \n"+
				"        AND b.fund_id=c.fund_id AND b.seq=c.seq \n"+
				"        AND a.cont_bn=d.code \n"+
				"        AND d.C_ST=e.C_ST(+) and d.CODE=e.CODE(+)"+subQuery;

		if(!bank_id.equals("")) query += " and a.cont_bn ='"+bank_id+"'";

		if(gubun2.equals("0")) query += " and a.cls_dt is null ";		//진행
		if(gubun2.equals("1")) query += " and a.cls_dt is not null ";	//종료

		query += " order by a.cont_dt desc, a.fund_id ";
				
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
	 *	자금관리리스트
	 */
	public Vector getWorkingFundList(String gubun1, String gubun2, String bank_id, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String subQuery = "";
		
		if(!gubun1.equals("")) subQuery += " and e.GUBUN='"+gubun1+"'\n";
			
		query = " SELECT a.fund_no, a.fund_id, decode(a.fund_type,'1','운용자금','2','시설자금') fund_type, d.nm as bank_nm, a.cont_amt, b.app_b_st, b.fund_int, b.app_b_dt, a.ba_agnt, e.gubun \n"+
				" FROM   WORKING_FUND a, WORKING_FUND_INT b, (SELECT fund_id, max(seq) seq FROM WORKING_FUND_INT GROUP BY fund_id) c, \n"+
				"        (SELECT * FROM CODE WHERE c_st='0003' AND CODE<>'0000') d, CODE_ETC e \n"+
				" WHERE  a.fund_id=b.fund_id \n"+
				"        AND b.fund_id=c.fund_id AND b.seq=c.seq \n"+
				"        AND a.cont_bn=d.code \n"+
				"        AND d.C_ST=e.C_ST(+) and d.CODE=e.CODE(+)"+subQuery;

		if(!bank_id.equals("")) query += " and a.cont_bn ='"+bank_id+"'";

		if(gubun2.equals("0")) query += " and a.cls_dt is null ";		//진행
		if(gubun2.equals("1")) query += " and a.cls_dt is not null ";	//종료

		if(!st_dt.equals("") && end_dt.equals(""))	query += " and a.cont_dt like replace('"+st_dt+"%', '-','') \n";
		if(!st_dt.equals("") && !end_dt.equals("")) query += " and a.cont_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','') \n";

		query += " order by a.cont_dt desc, a.fund_id ";
				
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
	 *	등록 : 자금관리 INSERT
	 */
	public WorkingFundBean insertWorkingFund(WorkingFundBean wf)
	{
		getConnection();
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;

		String query_seq = "SELECT NVL(TO_CHAR(MAX(TO_NUMBER(fund_id))+1, '0000'), '0001') fund_id FROM WORKING_FUND ";

		String query =  " insert into WORKING_FUND "+
						"        ( FUND_ID,REG_ID,REG_DT,FUND_TYPE,CONT_ST,CONT_BN_ST,CONT_BN,BN_BR,BN_TEL,BN_FAX,BA_AGNT,BA_TITLE, "+ //12
						"          CONT_AMT,CONT_DT,RENEW_DT,CLS_EST_DT,CLS_DT,REST_AMT,REST_B_DT,BANK_CODE,DEPOSIT_NO,PAY_ST,SECURITY_ST1,SECURITY_ST2,SECURITY_ST3,NOTE, "+//14
						"          GUA_ORG,GUA_S_DT,GUA_E_DT,GUA_INT,GUA_AMT,GUA_FEE,GUA_AGNT,GUA_TITLE,GUA_TEL,GUA_EST_DT,GUA_DOCS, "+//11
						"          REALTY_NM,REALTY_ZIP,REALTY_ADDR,CLTR_AMT,CLTR_DT,CLTR_ST,CLTR_USER,CLTR_LANK,FUND_NO,REVOLVING "+//10
						"        ) values "+
						"        ( ?, ?, to_char(sysdate,'YYYYMMDD'), ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
						"          ?, replace(?, '-', ''), replace(?, '-', ''), replace(?, '-', ''), replace(?, '-', ''), ?, replace(?, '-', ''), ?, ?, ?, ?, ?, ?, ?, "+
						"          ?, replace(?, '-', ''), replace(?, '-', ''), ?, ?, ?, ?, ?, ?, replace(?, '-', ''), ?, "+
						"          ?, replace(?, '-', ''), ?, ?, replace(?, '-', ''), ?, ?, ?, ?, ? "+
						"        )";


		try 
		{
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query_seq);
		    rs = pstmt1.executeQuery();
			if(rs.next())
			{
				wf.setFund_id(rs.getString("fund_id")==null?"0001":rs.getString("fund_id").trim());
			}
			rs.close();
			pstmt1.close();

			pstmt2 = conn.prepareStatement(query);
			pstmt2.setString(1,  wf.getFund_id			());
			pstmt2.setString(2,  wf.getReg_id			());		
			pstmt2.setString(3,  wf.getFund_type		());	
			pstmt2.setString(4,  wf.getCont_st			());
			pstmt2.setString(5,  wf.getCont_bn_st		());
			pstmt2.setString(6,  wf.getCont_bn			());
			pstmt2.setString(7,  wf.getBn_br			());
			pstmt2.setString(8,  wf.getBn_tel			());
			pstmt2.setString(9,  wf.getBn_fax			());
			pstmt2.setString(10, wf.getBa_agnt			());
			pstmt2.setString(11, wf.getBa_title			());
			pstmt2.setLong  (12, wf.getCont_amt			());
			pstmt2.setString(13, wf.getCont_dt			());
			pstmt2.setString(14, wf.getRenew_dt			());
			pstmt2.setString(15, wf.getCls_est_dt		());
			pstmt2.setString(16, wf.getCls_dt			());
			pstmt2.setLong  (17, wf.getRest_amt			());
			pstmt2.setString(18, wf.getRest_b_dt		());
			pstmt2.setString(19, wf.getBank_code		());
			pstmt2.setString(20, wf.getDeposit_no		());
			pstmt2.setString(21, wf.getPay_st			());
			pstmt2.setString(22, wf.getSecurity_st1		());
			pstmt2.setString(23, wf.getSecurity_st2		());
			pstmt2.setString(24, wf.getSecurity_st3		());				
			pstmt2.setString(25, wf.getNote				());				
			pstmt2.setString(26, wf.getGua_org			());				
			pstmt2.setString(27, wf.getGua_s_dt			());				
			pstmt2.setString(28, wf.getGua_e_dt			());				
			pstmt2.setString(29, wf.getGua_int			());				
			pstmt2.setLong  (30, wf.getGua_amt			());				
			pstmt2.setLong  (31, wf.getGua_fee			());				
			pstmt2.setString(32, wf.getGua_agnt			());				
			pstmt2.setString(33, wf.getGua_title		());				
			pstmt2.setString(34, wf.getGua_tel			());				
			pstmt2.setString(35, wf.getGua_est_dt		());				
			pstmt2.setString(36, wf.getGua_docs			());				
			pstmt2.setString(37, wf.getRealty_nm		());				
			pstmt2.setString(38, wf.getRealty_zip		());				
			pstmt2.setString(39, wf.getRealty_addr		());				
			pstmt2.setLong  (40, wf.getCltr_amt			());				
			pstmt2.setString(41, wf.getCltr_dt			());				
			pstmt2.setString(42, wf.getCltr_st			());				
			pstmt2.setString(43, wf.getCltr_user		());
			pstmt2.setString(44, wf.getCltr_lank		());
			pstmt2.setString(45, wf.getFund_no			());
			pstmt2.setString(46, wf.getRevolving		());
			pstmt2.executeUpdate();
			pstmt2.close();
		    
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[AddBankLendDatabase:insertWorkingFund]"+e);
	  		e.printStackTrace();
	  		wf = null;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(rs != null )		rs.close();
				if(pstmt1 != null)	pstmt1.close();
				if(pstmt2 != null)	pstmt2.close();
			}catch(Exception ignore){}
			closeConnection();
			return wf;
		}			
	}


	/**
	 *	등록 : 자금관리 INSERT
	 */
	public WorkingFundIntBean insertWorkingFundInt(WorkingFundIntBean wf_int)
	{
		getConnection();
		PreparedStatement pstmt2 = null;

		String query =  " insert into WORKING_FUND_INT "+
						"        ( fund_id,seq,reg_id,reg_dt,fund_int,validity_s_dt,validity_e_dt,int_st,spread,spread_int,app_b_st,app_b_dt,note "+ //13
						"        ) values "+
						"        ( ?, ?, ?, to_char(sysdate,'YYYYMMDD'), ?, replace(?, '-', ''), replace(?, '-', ''), ?, ?, ?, ?, replace(?, '-', ''), ? "+
						"        )";

		try 
		{
			conn.setAutoCommit(false);

			pstmt2 = conn.prepareStatement(query);
			pstmt2.setString(1,  wf_int.getFund_id			());
			pstmt2.setInt   (2,  wf_int.getSeq				());		
			pstmt2.setString(3,  wf_int.getReg_id			());	
			pstmt2.setString(4,  wf_int.getFund_int			());
			pstmt2.setString(5,  wf_int.getValidity_s_dt	());
			pstmt2.setString(6,  wf_int.getValidity_e_dt	());
			pstmt2.setString(7,  wf_int.getInt_st			());
			pstmt2.setString(8,  wf_int.getSpread			());
			pstmt2.setString(9,  wf_int.getSpread_int		());
			pstmt2.setString(10, wf_int.getApp_b_st			());
			pstmt2.setString(11, wf_int.getApp_b_dt			());
			pstmt2.setString(12, wf_int.getNote				());
			pstmt2.executeUpdate();
			pstmt2.close();
		    
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[AddBankLendDatabase:insertWorkingFundInt]"+e);
	  		e.printStackTrace();
	  		wf_int = null;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt2 != null)	pstmt2.close();
			}catch(Exception ignore){}
			closeConnection();
			return wf_int;
		}			
	}

	/**
	 *	등록 : 자금관리 INSERT
	 */
	public WorkingFundIntBean insertWorkingFundRe(WorkingFundIntBean wf_int)
	{
		getConnection();
		PreparedStatement pstmt = null;

		String query =  " insert into WORKING_FUND_RE "+
						"        ( fund_id,seq,reg_id,reg_dt,renew_dt,a_cont_amt,b_cont_amt,a_cls_est_dt,b_cls_est_dt,a_fund_int,b_fund_int "+ //11
						"        ) values "+
						"        ( ?, ?, ?, to_char(sysdate,'YYYYMMDD'), replace(?, '-', ''), ?, ?, replace(?, '-', ''), replace(?, '-', ''), ?, ? "+
						"        )";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  wf_int.getFund_id			());
			pstmt.setInt   (2,  wf_int.getSeq				());		
			pstmt.setString(3,  wf_int.getReg_id			());	
			pstmt.setString(4,  wf_int.getRenew_dt			());
			pstmt.setLong  (5,  wf_int.getA_cont_amt		());
			pstmt.setLong  (6,  wf_int.getB_cont_amt		());
			pstmt.setString(7,  wf_int.getA_cls_est_dt		());
			pstmt.setString(8,  wf_int.getB_cls_est_dt		());
			pstmt.setString(9,  wf_int.getA_fund_int		());
			pstmt.setString(10, wf_int.getB_fund_int		());
			pstmt.executeUpdate();
			pstmt.close();
		    
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[AddBankLendDatabase:insertWorkingFundRe]"+e);
	  		e.printStackTrace();
	  		wf_int = null;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return wf_int;
		}			
	}

	/**
	 *	수정 : 자금관리 update
	 */
	public boolean updateWorkingFund(WorkingFundBean wf)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;

		String query =  " update WORKING_FUND set "+
						"        BN_BR=?, BN_TEL=?, BA_AGNT=?, BA_TITLE=?, "+ 
						"        CONT_AMT=?, CONT_DT=replace(?, '-', ''), CLS_EST_DT=replace(?, '-', ''), REST_AMT=?, REST_B_DT=replace(?, '-', ''), "+
						"        DEPOSIT_NO=?, PAY_ST=?, SECURITY_ST1=?, SECURITY_ST2=?, SECURITY_ST3=?, NOTE=?, CONT_BN_ST=?, FUND_TYPE=?, REVOLVING=? "+
						"        where FUND_ID=? "+
						"        ";


		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  wf.getBn_br				());
			pstmt.setString(2,  wf.getBn_tel			());
			pstmt.setString(3,  wf.getBa_agnt			());
			pstmt.setString(4,  wf.getBa_title			());
			pstmt.setLong  (5,  wf.getCont_amt			());
			pstmt.setString(6,  wf.getCont_dt			());
			pstmt.setString(7,  wf.getCls_est_dt		());
			pstmt.setLong  (8,  wf.getRest_amt			());
			pstmt.setString(9,  wf.getRest_b_dt			());
			pstmt.setString(10, wf.getDeposit_no		());
			pstmt.setString(11, wf.getPay_st			());
			pstmt.setString(12, wf.getSecurity_st1		());
			pstmt.setString(13, wf.getSecurity_st2		());
			pstmt.setString(14, wf.getSecurity_st3		());				
			pstmt.setString(15, wf.getNote				());				
			pstmt.setString(16, wf.getCont_bn_st		());				
			pstmt.setString(17, wf.getFund_type			());	
			pstmt.setString(18, wf.getRevolving			());	
			pstmt.setString(19, wf.getFund_id			());
			pstmt.executeUpdate();
			pstmt.close();
		    
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[AddBankLendDatabase:updateWorkingFund]"+e);
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
	 *	수정 : 자금관리 update
	 */
	public boolean updateWorkingFundRenew(WorkingFundBean wf)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;

		String query =  " update WORKING_FUND set "+
						"        CONT_ST=?, RENEW_DT=replace(?, '-', '') "+
						"        where FUND_ID=? "+
						"        ";


		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  wf.getCont_st			());
			pstmt.setString(2,  wf.getRenew_dt			());
			pstmt.setString(3,  wf.getFund_id			());
			pstmt.executeUpdate();
			pstmt.close();
		    
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[AddBankLendDatabase:updateWorkingFundRenew]"+e);
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
	 *	수정 : 자금관리 update
	 */
	public boolean updateWorkingFundCls(WorkingFundBean wf)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;

		String query =  " update WORKING_FUND set "+
						"        CLS_DT=replace(?, '-', '') "+
						"        where FUND_ID=? "+
						"        ";


		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  wf.getCls_dt			());
			pstmt.setString(2,  wf.getFund_id			());
			pstmt.executeUpdate();
			pstmt.close();
		    
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[AddBankLendDatabase:updateWorkingFundCls]"+e);
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
	 *	수정 : 자금관리 update
	 */
	public boolean updateWorkingFundGua(WorkingFundBean wf)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;

		String query =  " update WORKING_FUND set "+
						"        GUA_ORG=?, GUA_S_DT=replace(?, '-', ''), GUA_E_DT=replace(?, '-', ''), GUA_INT=?, GUA_AMT=?, GUA_FEE=?, "+
						"        GUA_AGNT=?, GUA_TITLE=?, GUA_TEL=?, GUA_EST_DT=replace(?, '-', ''), GUA_DOCS=? "+ 
						"        where FUND_ID=? "+
						"        ";


		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  wf.getGua_org			());				
			pstmt.setString(2,  wf.getGua_s_dt			());				
			pstmt.setString(3,  wf.getGua_e_dt			());				
			pstmt.setString(4,  wf.getGua_int			());				
			pstmt.setLong  (5,  wf.getGua_amt			());				
			pstmt.setLong  (6,  wf.getGua_fee			());				
			pstmt.setString(7,  wf.getGua_agnt			());				
			pstmt.setString(8,  wf.getGua_title			());				
			pstmt.setString(9,  wf.getGua_tel			());				
			pstmt.setString(10, wf.getGua_est_dt		());				
			pstmt.setString(11, wf.getGua_docs			());				
			pstmt.setString(12, wf.getFund_id			());
			pstmt.executeUpdate();
			pstmt.close();
		    
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[AddBankLendDatabase:updateWorkingFundGua]"+e);
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
	 *	수정 : 자금관리 update
	 */
	public boolean updateWorkingFundRealty(WorkingFundBean wf)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;

		String query =  " update WORKING_FUND set "+
						"        REALTY_NM=?, REALTY_ZIP=?, REALTY_ADDR=?, CLTR_AMT=?, CLTR_DT=replace(?, '-', ''), CLTR_ST=?, CLTR_USER=?, CLTR_LANK=? "+
						"        where FUND_ID=? "+
						"        ";


		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  wf.getRealty_nm			());				
			pstmt.setString(2,  wf.getRealty_zip		());				
			pstmt.setString(3,  wf.getRealty_addr		());				
			pstmt.setLong  (4,  wf.getCltr_amt			());				
			pstmt.setString(5,  wf.getCltr_dt			());				
			pstmt.setString(6,  wf.getCltr_st			());				
			pstmt.setString(7,  wf.getCltr_user			());
			pstmt.setString(8,  wf.getCltr_lank			());
			pstmt.setString(9,  wf.getFund_id			());
			pstmt.executeUpdate();
			pstmt.close();
		    
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[AddBankLendDatabase:updateWorkingFundRealty]"+e);
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
	 *	수정 : 자금관리 update
	 */
	public boolean updateWorkingFundInt(WorkingFundIntBean wf_int)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;

		String query =  " update WORKING_FUND_INT set "+
						"        fund_int=?, validity_s_dt=replace(?, '-', ''), validity_e_dt=replace(?, '-', ''), "+
						"        int_st=?, spread=?, spread_int=?, app_b_st=?, app_b_dt=replace(?, '-', ''), note=? "+
						"        where FUND_ID=? and SEQ=? "+
						"        ";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  wf_int.getFund_int			());
			pstmt.setString(2,  wf_int.getValidity_s_dt		());
			pstmt.setString(3,  wf_int.getValidity_e_dt		());
			pstmt.setString(4,  wf_int.getInt_st			());
			pstmt.setString(5,  wf_int.getSpread			());
			pstmt.setString(6,  wf_int.getSpread_int		());
			pstmt.setString(7,  wf_int.getApp_b_st			());
			pstmt.setString(8,  wf_int.getApp_b_dt			());
			pstmt.setString(9,  wf_int.getNote				());
			pstmt.setString(10, wf_int.getFund_id			());
			pstmt.setInt   (11, wf_int.getSeq				());		
			pstmt.executeUpdate();
			pstmt.close();
		    
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[AddBankLendDatabase:updateWorkingFundInt]"+e);
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
	 *	수정 : 자금관리 update
	 */
	public boolean updateWorkingFundReIntSeq(WorkingFundIntBean wf_int, int re_seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;

		String query =  " update WORKING_FUND_RE set "+
						"        int_seq=? "+
						"        where FUND_ID=? and SEQ=? "+
						"        ";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setInt   (1,  wf_int.getSeq				());
			pstmt.setString(2,  wf_int.getFund_id			());
			pstmt.setInt   (3,  re_seq                        );
			pstmt.executeUpdate();
			pstmt.close();
		    
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[AddBankLendDatabase:updateWorkingFundReIntSeq]"+e);
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
	 * 조회 : 자금관리 한건 조회
	 */
	public WorkingFundBean getWorkingFundBean(String fund_id) 
	{
		getConnection();
		WorkingFundBean wf = new WorkingFundBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
					
		query = " SELECT a.* from WORKING_FUND a where a.fund_id=? ";
				
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, fund_id);
		   	rs = pstmt.executeQuery();
		   	
			if(rs.next())
			{
				wf.setFund_id			(rs.getString("fund_id")	==null?"":rs.getString("fund_id"));
				wf.setReg_id			(rs.getString("reg_id")		==null?"":rs.getString("reg_id"));
				wf.setReg_dt			(rs.getString("reg_dt")		==null?"":rs.getString("reg_dt"));
				wf.setFund_type			(rs.getString("fund_type")	==null?"":rs.getString("fund_type"));
				wf.setCont_st			(rs.getString("cont_st")	==null?"":rs.getString("cont_st"));
				wf.setCont_bn_st		(rs.getString("cont_bn_st")	==null?"":rs.getString("cont_bn_st"));
				wf.setCont_bn			(rs.getString("cont_bn")	==null?"":rs.getString("cont_bn"));
				wf.setBn_br				(rs.getString("bn_br")		==null?"":rs.getString("bn_br"));
				wf.setBn_tel			(rs.getString("bn_tel")		==null?"":rs.getString("bn_tel"));
				wf.setBn_fax			(rs.getString("bn_fax")		==null?"":rs.getString("bn_fax"));
				wf.setBa_agnt			(rs.getString("ba_agnt")	==null?"":rs.getString("ba_agnt"));
				wf.setBa_title			(rs.getString("ba_title")	==null?"":rs.getString("ba_title"));
				wf.setCont_amt			(rs.getString("cont_amt")	==null?0:AddUtil.parseLong(rs.getString("cont_amt")));
				wf.setCont_dt			(rs.getString("cont_dt")	==null?"":rs.getString("cont_dt"));
				wf.setRenew_dt			(rs.getString("renew_dt")	==null?"":rs.getString("renew_dt"));
				wf.setCls_est_dt		(rs.getString("cls_est_dt")	==null?"":rs.getString("cls_est_dt"));
				wf.setCls_dt			(rs.getString("cls_dt")		==null?"":rs.getString("cls_dt"));
				wf.setRest_amt			(rs.getString("rest_amt")	==null?0:AddUtil.parseLong(rs.getString("rest_amt")));
				wf.setRest_b_dt			(rs.getString("rest_b_dt")	==null?"":rs.getString("rest_b_dt"));
				wf.setBank_code			(rs.getString("bank_code")	==null?"":rs.getString("bank_code"));
				wf.setDeposit_no		(rs.getString("deposit_no")	==null?"":rs.getString("deposit_no"));
				wf.setPay_st			(rs.getString("pay_st")		==null?"":rs.getString("pay_st"));
				wf.setSecurity_st1		(rs.getString("security_st1")==null?"":rs.getString("security_st1"));
				wf.setSecurity_st2		(rs.getString("security_st2")==null?"":rs.getString("security_st2"));
				wf.setSecurity_st3		(rs.getString("security_st3")==null?"":rs.getString("security_st3"));
				wf.setNote				(rs.getString("note")		==null?"":rs.getString("note"));
				wf.setGua_org			(rs.getString("gua_org")	==null?"":rs.getString("gua_org"));
				wf.setGua_s_dt			(rs.getString("gua_s_dt")	==null?"":rs.getString("gua_s_dt"));
				wf.setGua_e_dt			(rs.getString("gua_e_dt")	==null?"":rs.getString("gua_e_dt"));
				wf.setGua_int			(rs.getString("gua_int")	==null?"":rs.getString("gua_int"));
				wf.setGua_amt			(rs.getString("gua_amt")	==null?0:AddUtil.parseLong(rs.getString("gua_amt")));
				wf.setGua_fee			(rs.getString("gua_fee")	==null?0:AddUtil.parseLong(rs.getString("gua_fee")));
				wf.setGua_agnt			(rs.getString("gua_agnt")	==null?"":rs.getString("gua_agnt"));
				wf.setGua_title			(rs.getString("gua_title")	==null?"":rs.getString("gua_title"));
				wf.setGua_tel			(rs.getString("gua_tel")	==null?"":rs.getString("gua_tel"));
				wf.setGua_est_dt		(rs.getString("gua_est_dt")	==null?"":rs.getString("gua_est_dt"));
				wf.setGua_docs			(rs.getString("gua_docs")	==null?"":rs.getString("gua_docs"));
				wf.setRealty_nm			(rs.getString("realty_nm")	==null?"":rs.getString("realty_nm"));
				wf.setRealty_zip		(rs.getString("realty_zip")	==null?"":rs.getString("realty_zip"));
				wf.setRealty_addr		(rs.getString("realty_addr")==null?"":rs.getString("realty_addr"));
				wf.setCltr_amt			(rs.getString("cltr_amt")	==null?0:AddUtil.parseLong(rs.getString("cltr_amt")));
				wf.setCltr_dt			(rs.getString("cltr_dt")	==null?"":rs.getString("cltr_dt"));
				wf.setCltr_st			(rs.getString("cltr_st")	==null?"":rs.getString("cltr_st"));
				wf.setCltr_user			(rs.getString("cltr_user")	==null?"":rs.getString("cltr_user"));
				wf.setCltr_lank			(rs.getString("cltr_lank")	==null?"":rs.getString("cltr_lank"));
				wf.setFund_no			(rs.getString("fund_no")	==null?"":rs.getString("fund_no"));				   
				wf.setRevolving			(rs.getString("revolving")	==null?"":rs.getString("revolving"));				   
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddBankLendDatabase:getWorkingFundBean]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return wf;
		}
	}

	/**
	 * 조회 : 자금관리 한건 조회
	 */
	public WorkingFundIntBean getWorkingFundIntBean(String fund_id, int seq) 
	{
		getConnection();
		WorkingFundIntBean wf = new WorkingFundIntBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
					
		query = " SELECT a.* from WORKING_FUND_INT a where a.fund_id=? and a.seq=? ";
				
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, fund_id);
			pstmt.setInt   (2, seq);
		   	rs = pstmt.executeQuery();
		   	
			if(rs.next())
			{
				wf.setFund_id			(rs.getString("fund_id")		==null?"":rs.getString("fund_id"));
				wf.setSeq				(rs.getString("seq")			==null?0:Integer.parseInt(rs.getString("seq")));
				wf.setReg_id			(rs.getString("reg_id")			==null?"":rs.getString("reg_id"));    
				wf.setReg_dt			(rs.getString("reg_dt")			==null?"":rs.getString("reg_dt"));    
				wf.setFund_int			(rs.getString("fund_int")		==null?"":rs.getString("fund_int"));
				wf.setValidity_s_dt		(rs.getString("validity_s_dt")	==null?"":rs.getString("validity_s_dt"));
				wf.setValidity_e_dt		(rs.getString("validity_e_dt")	==null?"":rs.getString("validity_e_dt"));
				wf.setInt_st			(rs.getString("int_st")			==null?"":rs.getString("int_st"));
				wf.setSpread			(rs.getString("spread")			==null?"":rs.getString("spread"));
				wf.setSpread_int		(rs.getString("spread_int")		==null?"":rs.getString("spread_int"));
				wf.setApp_b_st			(rs.getString("app_b_st")		==null?"":rs.getString("app_b_st"));
				wf.setApp_b_dt			(rs.getString("app_b_dt")		==null?"":rs.getString("app_b_dt"));
				wf.setNote				(rs.getString("note")			==null?"":rs.getString("note"));
				   
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddBankLendDatabase:getWorkingFundIntBean]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return wf;
		}
	}

	public Vector getWorkingFundInt(String fund_id)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT a.* from WORKING_FUND_INT a where a.fund_id=? order by a.seq ";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, fund_id);
	    	rs = pstmt.executeQuery();
			while(rs.next())
			{
				WorkingFundIntBean wf = new WorkingFundIntBean();

				wf.setFund_id			(rs.getString("fund_id")		==null?"":rs.getString("fund_id"));
				wf.setSeq				(rs.getString("seq")			==null?0:Integer.parseInt(rs.getString("seq")));
				wf.setReg_id			(rs.getString("reg_id")			==null?"":rs.getString("reg_id"));    
				wf.setReg_dt			(rs.getString("reg_dt")			==null?"":rs.getString("reg_dt"));    
				wf.setFund_int			(rs.getString("fund_int")		==null?"":rs.getString("fund_int"));
				wf.setValidity_s_dt		(rs.getString("validity_s_dt")	==null?"":rs.getString("validity_s_dt"));
				wf.setValidity_e_dt		(rs.getString("validity_e_dt")	==null?"":rs.getString("validity_e_dt"));
				wf.setInt_st			(rs.getString("int_st")			==null?"":rs.getString("int_st"));
				wf.setSpread			(rs.getString("spread")			==null?"":rs.getString("spread"));
				wf.setSpread_int		(rs.getString("spread_int")		==null?"":rs.getString("spread_int"));
				wf.setApp_b_st			(rs.getString("app_b_st")		==null?"":rs.getString("app_b_st"));
				wf.setApp_b_dt			(rs.getString("app_b_dt")		==null?"":rs.getString("app_b_dt"));
				wf.setNote				(rs.getString("note")			==null?"":rs.getString("note"));

				vt.add(wf);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AddBankLendDatabase:getWorkingFundInt]"+e);
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

	public Vector getWorkingFundRe(String fund_id)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT a.* from WORKING_FUND_RE a where a.fund_id=? order by a.seq";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, fund_id);
	    	rs = pstmt.executeQuery();
			while(rs.next())
			{
				WorkingFundIntBean wf = new WorkingFundIntBean();

				wf.setFund_id			(rs.getString("fund_id")		==null?"":rs.getString("fund_id"));
				wf.setSeq				(rs.getString("seq")			==null?0:Integer.parseInt(rs.getString("seq")));
				wf.setReg_id			(rs.getString("reg_id")			==null?"":rs.getString("reg_id"));    
				wf.setReg_dt			(rs.getString("reg_dt")			==null?"":rs.getString("reg_dt"));    
				wf.setRenew_dt			(rs.getString("renew_dt")		==null?"":rs.getString("renew_dt"));
				wf.setA_cont_amt		(rs.getString("a_cont_amt")		==null?0:AddUtil.parseLong(rs.getString("a_cont_amt")));
				wf.setB_cont_amt		(rs.getString("b_cont_amt")		==null?0:AddUtil.parseLong(rs.getString("b_cont_amt")));
				wf.setA_cls_est_dt		(rs.getString("a_cls_est_dt")	==null?"":rs.getString("a_cls_est_dt"));
				wf.setB_cls_est_dt		(rs.getString("b_cls_est_dt")	==null?"":rs.getString("b_cls_est_dt"));
				wf.setA_fund_int		(rs.getString("a_fund_int")		==null?"":rs.getString("a_fund_int"));
				wf.setB_fund_int		(rs.getString("b_fund_int")		==null?"":rs.getString("b_fund_int"));
				wf.setInt_seq			(rs.getString("int_seq")		==null?0:Integer.parseInt(rs.getString("int_seq")));

				vt.add(wf);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AddBankLendDatabase:getWorkingFundRe]"+e);
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


	//관리번호가져오기
	public String getFundNoNext(String cont_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String fund_no = "";
		String query = "";
		String fund_dt = "";

		int len=cont_dt.length();

		if(len == 8){
			fund_dt = "to_char(to_date('"+cont_dt+"','YYYYMMDD'),'YYYYMM')";
		}else if(len == 10){
			fund_dt = "to_char(to_date('"+cont_dt+"','YYYY-MM-DD'),'YYYYMM')";
		}

		if(fund_dt.equals("")) fund_dt = "to_char(sysdate,'YYYYMM')";

		query = " select "+fund_dt+"||'-'||nvl(ltrim(to_char(to_number(max(substr(fund_no,8,10))+1), '000')), '001') fund_no"+
				" from WORKING_FUND "+
				" where substr(fund_no,1,7)="+fund_dt+"||'-'";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
   	
			if(rs.next())
			{				
				fund_no = rs.getString(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AddBankLendDatabase:getFundNoNext]\n"+e);
	  		e.printStackTrace();
			
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return fund_no;
		}		
	}

	/**
	 *	자금관리 실행리스트(은행대출관리) 리스트
	 */
	public Vector getWorkingFundLendBankList(String fund_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
			
		query = " SELECT * FROM LEND_BANK WHERE fund_id='"+fund_id+"' order by cont_dt, lend_id ";
				
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
			System.out.println("[AddBankLendDatabase:getWorkingFundLendBankList]\n"+e);	
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
	 *	수정 : 은행대출 UPDATE
	 */
	public boolean updateBankLendFundId(BankLendBean bl, String fund_id)
	{
		getConnection();
		boolean flag = true;
		String query = "update LEND_BANK set"+
						" fund_id = ? "+
						" where LEND_ID = ?";
			
		PreparedStatement pstmt = null;
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, fund_id);		
			pstmt.setString(2, bl.getLend_id());			
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddBankLendDatabase:updateBankLendFundId]"+e);
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
	 *	리스트 : 은행대출리스트 (bank_id : 은행코드)
	 */
	public Vector getBankLendListSet(String bank_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " SELECT"+
				" A.lend_id, decode(C.lend_id, '', 'N', 'Y') scd_yn, A.bank_nm, A.cont_st, A.bn_br, A.cont_term,"+
				" A.seq, A.rtn_tot_amt, A.cont_amt, A.cont_dt, A.pm_amt,"+
				" A.pm_rest_amt, A.cont_start_dt, B.ba_nm, D.pm_rest_amt, (A.cont_amt-D.pm_rest_amt) charge_amt "+
				" FROM"+
				" ("+
					" SELECT L.lend_id, C.nm_cd bank_nm, L.bn_br, L.cont_amt,"+
			 		" DECODE(L.cont_dt, '', '', SUBSTR(L.cont_dt, 1, 4)||'-'||SUBSTR(L.cont_dt, 5, 2)||'-'||SUBSTR(L.cont_dt, 7, 2)) cont_dt,"+
					" DECODE(L.cont_st, '0','신규', '1','연장') cont_st,"+
					" L.pm_amt, L.pm_rest_amt, R.seq, R.cont_term, R.rtn_tot_amt,"+
					" DECODE(R.cont_start_dt, '', '', SUBSTR(R.cont_start_dt, 1, 4)||'-'||SUBSTR(R.cont_start_dt, 5, 2)||'-'||SUBSTR(R.cont_start_dt, 7, 2)) cont_start_dt"+
					" FROM TEST_LEND_BANK L, CODE C, TEST_BANK_RTN R "+
					" WHERE L.cont_bn = C.CODE AND"+
					" C.c_st = '0003' AND"+
					" C.CODE <> '0000' AND"+
					" C.CODE LIKE '%"+bank_id+"%' AND"+
					" L.LEND_ID = R.LEND_ID AND"+
					" L.LEND_LIM_ST <= to_char(sysdate,'YYYYMMDD') AND to_char(sysdate,'YYYYMMDD') <= L.LEND_LIM_ET"+					
				" ) A,"+
				" ("+
					" SELECT ba_nm, lend_id FROM TEST_BANK_AGNT WHERE seq = '0'"+
				" ) B,"+
				" ("+
					" SELECT lend_id, rtn_seq FROM TEST_SCD_BANK WHERE alt_tm = '1'"+
				" ) C,"+
				" ("+
					" select lend_id, sum(loan_amt) pm_rest_amt from car_bank GROUP BY lend_id"+
				" ) D"+
				" WHERE A.lend_id = B.lend_id(+) AND"+
				" A.lend_id = C.lend_id(+) AND A.seq=C.rtn_seq(+) AND"+
				" A.lend_id = D.lend_id(+)"+
				" order by a.lend_id ";
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
			System.out.println("[AddBankLendDatabase:getBankLendListSet]"+e);
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
	 *	자금관리 실행리스트(신용카드할부 ) 리스트
	 */
	public Vector getWorkingFundFineDocList(String fund_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
			
		query = " SELECT a.fund_id, a.cont_bn, a.cont_dt, a.cont_amt, b.doc_id, b.doc_dt, c.min_end_dt, c.max_end_dt, c.cnt, c.amt4, c.trf_cnt, c.trf_amt, b.app_dt \r\n" + 
				"FROM   WORKING_FUND a, \r\n" + 
				"       fine_doc b, \r\n" + 
				"       (SELECT a.doc_id, COUNT(0) cnt, SUM(a.amt4) amt4, "+
				"               min(a.end_dt) min_end_dt, max(a.end_dt) max_end_dt, "+				
				"               count(DECODE(b.trf_st1,'7',b.rent_l_cd,DECODE(b.trf_st2,'7',b.rent_l_cd))) trf_cnt,\r\n" + 
				"               SUM(DECODE(b.trf_st1,'7',b.trf_amt1,0)+DECODE(b.trf_st2,'7',b.trf_amt2,0)) trf_amt\r\n" +
				"        FROM   fine_doc_list a, car_pur b, card c\r\n" + 
				"        WHERE a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd\r\n" + 
				"        AND b.cardno1=c.cardno(+)\r\n" + 
				"        GROUP BY a.doc_id\r\n" + 
				"       ) c\r\n" + 
				"WHERE  a.fund_id='"+fund_id+"'\r\n" + 
				"       AND a.CONT_BN=b.gov_id \r\n" + 
				"       AND b.end_dt BETWEEN  a.cont_dt AND CASE when a.cls_dt IS NOT NULL THEN a.cls_dt when a.cls_est_dt IS NOT NULL THEN a.cls_est_dt ELSE TO_CHAR(SYSDATE,'YYYYMMDD') END\r\n" + 
				"       AND b.doc_id=c.doc_id  \r\n" + 
				"ORDER BY b.doc_dt ";
				
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
			System.out.println("[AddBankLendDatabase:getWorkingFundFineDocList]\n"+e);	
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
	 *	자금관리 실행리스트(신용카드할부 ) 리스트
	 */
	public Vector getWorkingFundFineCardDocList(String fund_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector(); 
		String query = "";
			
		query = " SELECT a.fund_id, a.cont_bn, a.cont_dt, a.cont_amt, b.doc_id, b.doc_dt, c.min_end_dt, c.max_end_dt, c.cnt, c.amt4, c.trf_cnt, c.trf_amt, b.app_dt \r\n" + 
				"FROM   WORKING_FUND a, \r\n" + 
				"       fine_doc b, \r\n" + 
				"       (SELECT a.doc_id, COUNT(0) cnt, SUM(a.amt4) amt4, "+
				"               min(a.end_dt) min_end_dt, max(a.end_dt) max_end_dt, "+
				"               count(DECODE(b.trf_st1,'7',b.rent_l_cd,DECODE(b.trf_st2,'7',b.rent_l_cd))) trf_cnt,\r\n" + 
				"               SUM(DECODE(b.trf_st1,'7',b.trf_amt1,0)+DECODE(b.trf_st2,'7',b.trf_amt2,0)) trf_amt\r\n" +
				"        FROM   fine_doc_list a, car_pur b, card c\r\n" + 
				"        WHERE a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd\r\n" + 
				"        AND b.cardno1=c.cardno(+)\r\n" + 
				"        GROUP BY a.doc_id\r\n" + 
				"       ) c\r\n" + 
				"WHERE  a.fund_id='"+fund_id+"'\r\n" + 
				"       AND a.CONT_BN=b.gov_id and b.card_yn='Y' \r\n" + 
				"       AND b.end_dt BETWEEN  a.cont_dt AND CASE when a.cls_dt IS NOT NULL THEN a.cls_dt when a.cls_est_dt IS NOT NULL THEN a.cls_est_dt ELSE TO_CHAR(SYSDATE,'YYYYMMDD') END\r\n" + 
				"       AND b.doc_id=c.doc_id  \r\n" + 
				"ORDER BY b.doc_dt ";
				
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
			System.out.println("[AddBankLendDatabase:getWorkingFundFineDocList]\n"+e);	
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
	 *	건별대출실행현황 리스트
	 */
	public Vector getWorkingFundAllotCaseList(String fund_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
			
		query = " SELECT a.fund_id, a.cont_bn, a.cont_dt, a.cont_amt, b.lend_dt, b.cnt, b.lend_prn, b.lend_int  \r\n" + 
				"FROM   WORKING_FUND a,\r\n" + 
				"       (SELECT a.cpt_cd, a.lend_dt, COUNT(0) cnt, SUM(a.lend_prn) lend_prn, max(a.lend_int) lend_int\r\n" + 
				"        FROM   allot a, DOC_SETTLE b  \r\n" + 
				"        where a.lend_id IS NULL AND a.rent_l_cd=b.doc_id AND b.DOC_ST='4' AND b.doc_step='3' \r\n" + 
				"        GROUP BY a.cpt_cd, a.lend_dt\r\n" + 
				"       ) b\r\n" + 
				"WHERE  a.fund_id='"+fund_id+"'\r\n" + 
				"AND a.cont_bn=b.cpt_cd\r\n" + 
				"AND b.lend_dt BETWEEN  a.cont_dt AND CASE when a.cls_dt IS NOT NULL THEN a.cls_dt when a.cls_est_dt IS NOT NULL THEN a.cls_est_dt ELSE TO_CHAR(SYSDATE,'YYYYMMDD') END\r\n" + 
				"ORDER BY b.lend_dt";
				
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
			System.out.println("[AddBankLendDatabase:getWorkingFundAllotCaseList]\n"+e);	
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
	
}

