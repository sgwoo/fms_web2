package acar.debt;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.cont.*;

public class DebtDatabase
{
	private Connection conn = null;
	public static DebtDatabase d_db;
	
	public static DebtDatabase getInstance()
	{
		if(DebtDatabase.d_db == null)
			DebtDatabase.d_db = new DebtDatabase();
		return DebtDatabase.d_db;	
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
	 *	할부스케줄 insert
	 */
	public boolean insertDebtScd(DebtScdBean debt)
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
			pstmt2.setString(1, debt.getCar_mng_id());
			pstmt2.setString(2, debt.getAlt_tm());
	    	rs = pstmt2.executeQuery();
			if(rs.next()){
				chk = rs.getInt(1);	
			}
			rs.close();
			pstmt2.close();
			
			if(chk==0){

				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, debt.getCar_mng_id());
				pstmt.setString(2, debt.getAlt_tm());
				pstmt.setString(3, debt.getAlt_est_dt());
				pstmt.setInt   (4, debt.getAlt_prn());
				pstmt.setInt   (5, debt.getAlt_int());
				pstmt.setString(6, debt.getPay_yn());
				pstmt.setString(7, debt.getPay_dt());
				pstmt.setInt   (8, debt.getAlt_rest());
				pstmt.setString(9, debt.getR_alt_est_dt());
				pstmt.executeUpdate();
				pstmt.close();
			}
						
			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[DebtDatabase:insertScdAltCase]"+e);
			System.out.println("[DebtDatabase:insertScdAltCase]"+query+" "+debt.getCar_mng_id());
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
	
	public boolean insertDebtScdEtc(DebtScdBean debt)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		int chk = 0;

		String query = "insert into scd_alt_etc (CAR_MNG_ID, ALT_TM, ALT_EST_DT, ALT_PRN, ALT_INT, PAY_YN, PAY_DT, ALT_REST, R_ALT_EST_DT) values"+
						" (?, ?, replace(?, '-', ''), ?, ?, ?, replace(?, '-', ''), ?, replace(?, '-', ''))";

		//입력체크
		String query2 = "select count(*) from scd_alt_etc where CAR_MNG_ID=? and ALT_TM=?";

		try 
		{
			conn.setAutoCommit(false);

			pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString(1, debt.getCar_mng_id());
			pstmt2.setString(2, debt.getAlt_tm());
	    	rs = pstmt2.executeQuery();
			if(rs.next()){
				chk = rs.getInt(1);	
			}
			rs.close();
			pstmt2.close();
			
			if(chk==0){

				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, debt.getCar_mng_id());
				pstmt.setString(2, debt.getAlt_tm());
				pstmt.setString(3, debt.getAlt_est_dt());
				pstmt.setInt   (4, debt.getAlt_prn());
				pstmt.setInt   (5, debt.getAlt_int());
				pstmt.setString(6, debt.getPay_yn());
				pstmt.setString(7, debt.getPay_dt());
				pstmt.setInt   (8, debt.getAlt_rest());
				pstmt.setString(9, debt.getR_alt_est_dt());
				pstmt.executeUpdate();
				pstmt.close();
			}
						
			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[DebtDatabase:insertScdAltEtc]"+e);
			System.out.println("[DebtDatabase:insertScdAltEtc]"+query+" "+debt.getCar_mng_id());
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
	 *	할부스케줄 update
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
			pstmt.setInt   (2, debt.getAlt_prn());
			pstmt.setInt   (3, debt.getAlt_int());
			pstmt.setString(4, debt.getPay_yn());
			pstmt.setString(5, debt.getPay_dt());
			pstmt.setInt   (6, debt.getAlt_rest());
			pstmt.setString(7, debt.getR_alt_est_dt());
			pstmt.setString(8, debt.getCar_mng_id());
			pstmt.setString(9, debt.getAlt_tm());
		    pstmt.executeUpdate();
		    pstmt.close();
		    conn.commit();
	  	} catch (Exception e) {
	  		System.out.println("[DebtDatabase:updateDebtScd]"+e);
	  		e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)   pstmt.close();	
			
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}	
	
	public boolean updateDebtScdEtc(DebtScdBean debt)
	{
		getConnection();
		boolean flag = true;
		String query = "update scd_alt_etc set"+
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
			pstmt.setInt   (2, debt.getAlt_prn());
			pstmt.setInt   (3, debt.getAlt_int());
			pstmt.setString(4, debt.getPay_yn());
			pstmt.setString(5, debt.getPay_dt());
			pstmt.setInt   (6, debt.getAlt_rest());
			pstmt.setString(7, debt.getR_alt_est_dt());
			pstmt.setString(8, debt.getCar_mng_id());
			pstmt.setString(9, debt.getAlt_tm());
		    pstmt.executeUpdate();
		    pstmt.close();
		    conn.commit();
	  	} catch (Exception e) {
	  		System.out.println("[DebtDatabase:updateDebtScdEtc]"+e);
	  		e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)   pstmt.close();	
			
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}

	/**
	 *	한 건에 대한 한회차 할부금 스케줄 쿼리 -- 출금처리위한
	 *	car_id : 차량관리번호, alt_tm : 회차
	 */
	public Hashtable getADebtScdPay(String car_id, String alt_tm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = " select C.rent_l_cd RENT_L_CD, nvl(L.firm_nm, L.client_nm) FIRM_NM, R.car_no CAR_NO,"+
							   	" S.alt_tm ALT_TM, S.alt_prn ALT_PRN, S.alt_int ALT_INT, (S.alt_prn+S.alt_int) ALT_AMT, "+
							   	" decode(S.ALT_EST_DT, '', '', substr(S.ALT_EST_DT, 1, 4) || '-' || substr(S.ALT_EST_DT, 5, 2) || '-'||substr(S.ALT_EST_DT, 7, 2)) ALT_EST_DT,"+
							   	" decode(S.PAY_DT, '', '', substr(S.PAY_DT, 1, 4) || '-' || substr(S.PAY_DT, 5, 2) || '-'||substr(S.PAY_DT, 7, 2)) PAY_DT"+
						" from car_reg R, cont C, scd_alt_case S, client L"+
						" where S.car_mng_id = R.car_mng_id and"+
							  	" R.car_mng_id = C.car_mng_id and"+
							  	" C.client_id = L.client_id and"+
								" S.car_mng_id = '"+car_id+"' and S.alt_tm = '"+alt_tm+"'";
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
	 *	한 건에 대한 한회차 할부금 스케줄 쿼리 -- 출금처리위한
	 *	car_id : 차량관리번호, alt_tm : 회차
	 */
	public Hashtable getADebtScdPay_bank(String lend_id, String alt_tm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = " select\n"+
							" C.rent_l_cd RENT_L_CD, nvl(L.firm_nm, L.client_nm) FIRM_NM, R.car_no CAR_NO,"+
							" S.alt_tm ALT_TM, S.alt_prn_amt ALT_PRN, S.alt_int_amt ALT_INT, (S.alt_prn_amt+S.alt_int_amt) ALT_AMT, "+
							" decode(S.ALT_EST_DT, '', '', substr(S.ALT_EST_DT, 1, 4) || '-' || substr(S.ALT_EST_DT, 5, 2) || '-'||substr(S.ALT_EST_DT, 7, 2)) ALT_EST_DT,"+
							" decode(S.PAY_DT, '', '', substr(S.PAY_DT, 1, 4) || '-' || substr(S.PAY_DT, 5, 2) || '-'||substr(S.PAY_DT, 7, 2)) PAY_DT"+
						" from car_reg R, cont C, client L, car_bank N, lend_bank B, bank_sche S\n"+
						" where R.car_mng_id = C.car_mng_id and\n"+
							" C.client_id = L.client_id and\n"+
							" R.car_mng_id = N.car_mng_id and\n"+
							" N.lend_id = B.lend_id and\n"+
							" S.lend_id = B.lend_id and\n"+
							" S.lend_id = '"+lend_id+"' and S.alt_tm='"+alt_tm+"'";
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
							" CAR_MNG_ID, ALT_TM, ALT_EST_DT, ALT_PRN, ALT_INT, PAY_YN, PAY_DT, ALT_REST, R_ALT_EST_DT "+
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
				debt.setR_alt_est_dt(rs.getString("R_ALT_EST_DT")==null?"":rs.getString("R_ALT_EST_DT"));
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
	
	public DebtScdBean getADebtScdEtc(String car_id, String alt_tm)
	{
		getConnection();
		DebtScdBean debt = new DebtScdBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	" select"+
							" CAR_MNG_ID, ALT_TM, ALT_EST_DT, ALT_PRN, ALT_INT, PAY_YN, PAY_DT, ALT_REST, R_ALT_EST_DT "+
							" from scd_alt_etc "+
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
				debt.setR_alt_est_dt(rs.getString("R_ALT_EST_DT")==null?"":rs.getString("R_ALT_EST_DT"));
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
							" decode(PAY_DT, '', '', substr(PAY_DT, 1, 4) || '-' || substr(PAY_DT, 5, 2) || '-'||substr(PAY_DT, 7, 2)) PAY_DT, cls_rtn_dt"+
							" from scd_alt_case "+
							" where car_mng_id = ?"+
							" order by to_number(ALT_TM)";
											
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, car_id);
		    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				DebtScdBean debt = new DebtScdBean();
				debt.setCar_mng_id(rs.getString("CAR_MNG_ID")==null?"":rs.getString("CAR_MNG_ID"));
				debt.setAlt_tm(rs.getString("ALT_TM")==null?"":rs.getString("ALT_TM"));
				debt.setAlt_est_dt(rs.getString("ALT_EST_DT")==null?"":rs.getString("ALT_EST_DT"));
				debt.setAlt_prn(rs.getString("ALT_PRN")==null?0:Integer.parseInt(rs.getString("ALT_PRN")));
				debt.setAlt_int(rs.getString("ALT_INT")==null?0:Integer.parseInt(rs.getString("ALT_INT")));
				debt.setPay_yn(rs.getString("PAY_YN")==null?"":rs.getString("PAY_YN"));
				debt.setPay_dt(rs.getString("PAY_DT")==null?"":rs.getString("PAY_DT"));
				debt.setAlt_rest(rs.getString("ALT_REST")==null?0:Integer.parseInt(rs.getString("ALT_REST")));
				debt.setCls_rtn_dt(rs.getString("cls_rtn_dt")==null?"":rs.getString("cls_rtn_dt"));
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
	
	public Vector getDebtScdEtc(String car_id)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	" select"+
							" CAR_MNG_ID, ALT_TM,"+
							" decode(ALT_EST_DT, '', '', substr(ALT_EST_DT, 1, 4) || '-' || substr(ALT_EST_DT, 5, 2) || '-'||substr(ALT_EST_DT, 7, 2)) ALT_EST_DT,"+
							" ALT_PRN, ALT_INT, PAY_YN, ALT_REST,"+
							" decode(PAY_DT, '', '', substr(PAY_DT, 1, 4) || '-' || substr(PAY_DT, 5, 2) || '-'||substr(PAY_DT, 7, 2)) PAY_DT, cls_rtn_dt"+
							" from scd_alt_etc "+
							" where car_mng_id = ?"+
							" order by to_number(ALT_TM)";
											
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, car_id);
		    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				DebtScdBean debt = new DebtScdBean();
				debt.setCar_mng_id(rs.getString("CAR_MNG_ID")==null?"":rs.getString("CAR_MNG_ID"));
				debt.setAlt_tm(rs.getString("ALT_TM")==null?"":rs.getString("ALT_TM"));
				debt.setAlt_est_dt(rs.getString("ALT_EST_DT")==null?"":rs.getString("ALT_EST_DT"));
				debt.setAlt_prn(rs.getString("ALT_PRN")==null?0:Integer.parseInt(rs.getString("ALT_PRN")));
				debt.setAlt_int(rs.getString("ALT_INT")==null?0:Integer.parseInt(rs.getString("ALT_INT")));
				debt.setPay_yn(rs.getString("PAY_YN")==null?"":rs.getString("PAY_YN"));
				debt.setPay_dt(rs.getString("PAY_DT")==null?"":rs.getString("PAY_DT"));
				debt.setAlt_rest(rs.getString("ALT_REST")==null?0:Integer.parseInt(rs.getString("ALT_REST")));
				debt.setCls_rtn_dt(rs.getString("cls_rtn_dt")==null?"":rs.getString("cls_rtn_dt"));
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
	 *	--차량등록이 안된경우 할부금스케줄작성 리스트에서 볼수 없다..--
	 *	할부금 등록여부와 함께 계약 건 리스트 리턴
	 *	kd - 1:상호, 2:고객명, 3:금융사, 4:대출일, 5:계약코드
	 *	reg_yn - Y:할부금스케줄등록상태, N:할부금스케줄미등록상태
	 */
	public Vector getAllotListByCase(String kd, String wd, String reg_yn)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = " select"+
						 	" X.rent_mng_id RENT_MNG_ID, X.rent_l_cd RENT_L_CD, X.car_mng_id CAR_MNG_ID,"+
						 	" nvl(X.firm_nm, X.client_nm) FIRM_NM, X.client_nm CLIENT_NM, X.car_nm CAR_NM, X.cpt_cd CPT_CD,"+
						 	" decode(X.lend_dt, '', '', substr(X.lend_dt, 1, 4)||'-'||substr(X.lend_dt, 5, 2)||'-'||substr(X.lend_dt, 7, 2)) LEND_DT,"+
						 	" X.lend_prn LEND_PRN, X.alt_amt ALT_AMT,"+
						 	" decode(Y.car_mng_id, '', 'N', 'Y') REG_YN,"+
						 	" decode(Y.pay_yn, 'N', '진행중', 'Y', '납부완료') ALL_YN,"+
						 	" X.allot_st ALLOT_ST"+
						" from"+
							" ("+
								" select A.rent_mng_id RENT_MNG_ID, A.rent_l_cd RENT_L_CD, R.car_mng_id CAR_MNG_ID,"+
										" L.firm_nm FIRM_NM, L.client_nm CLIENT_NM, R.car_nm CAR_NM, A.cpt_cd CPT_CD,"+ 
										" A.lend_dt LEND_DT, A.lend_prn LEND_PRN, A.alt_amt ALT_AMT, A.allot_st ALLOT_ST"+
								" from"+
										" allot A, cont C, car_reg R, client L"+
								" where"+
										" A.rent_mng_id = C.rent_mng_id and"+
										" A.rent_l_cd = C.rent_l_cd and"+
										" C.use_yn = 'Y' and"+
										" C.car_mng_id = R.car_mng_id and"+
										" C.client_id = L.client_id"+
							" )X,"+
							" ("+
								//" select decode(sum(pay_yn), max(to_number(alt_tm)), 'Y', 'N') PAY_YN, car_mng_id"+
								" select DECODE(SUM(DECODE(pay_yn, 'Y', 1, 'N', 0)), MAX(TO_NUMBER(alt_tm)), 'Y', 'N') PAY_YN, car_mng_id"+
								" from scd_alt_case"+
								" group by car_mng_id"+
							" )Y"+
						" where"+
								" X.car_mng_id = Y.car_mng_id(+)";
					  
		if(kd.equals("1"))		query += " and nvl(X.firm_nm, ' ') like '%"+wd+"%'";
		else if(kd.equals("2"))	query += " and nvl(X.client_nm, ' ') like '%%"+wd+"%'";
		else if(kd.equals("3"))
		{
			if(wd.equals(""))	query += " and X.allot_st = '1'";							//현금구매
			else				query += " and X.cpt_cd like '%"+wd+"%' and X.allot_st = '2'";	//일반할부구매
	  	}
	  	else if(kd.equals("4"))	query += " and nvl(X.lend_dt, ' ') like '%"+wd+"%'";
	  	else if(kd.equals("5"))	query += " and upper(X.rent_l_cd) like upper('%"+wd+"%')";
			
		if(reg_yn.equals("Y"))		query += " and Y.car_mng_id is not null";
		else if(reg_yn.equals("N"))	query += " and Y.car_mng_id is null";
				
		
		query += " order by X.rent_mng_id desc";
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
	 *	할부금 납부처리를 위한 리스트
	 *	dt	-		납입예정일(0:전체, 1:당일, 2:기간)
	 *	rc	-		출금구분(0:전체, 1:출금, 2:미출금)
	 *	kd	-		기타검색항목(1:상호, 2:계약코드, 3:차량번호, 4:금융사, 5:월할부금)
	 *	wd	-		기타검색항목 검색어
	 *	st_dt, end_dt	- 납입예정일 시작일-종료일
	 */
	public Vector getAllotPayList(String dt, String rc, String kd, String wd, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = 	" select car_mng_id, alt_tm, rent_mng_id, rent_l_cd, firm_nm, client_nm, car_nm, cpt_cd, cpt_nm, car_no, alt_prn,\n"+
								" alt_int, alt_amt, alt_rest, pay_dt, alt_est_dt, pay_yn, client_id, lend_id, gubun\n"+
						" from\n"+
						" (\n"+
							" SELECT\n"+
								" S.car_mng_id CAR_MNG_ID, S.alt_tm ALT_TM, A.rent_mng_id RENT_MNG_ID, L.client_id CLIENT_ID,\n"+
								" A.rent_l_cd RENT_L_CD, NVL(L.firm_nm, L.client_nm) FIRM_NM, L.client_nm CLIENT_NM, R.CAR_NM CAR_NM,\n"+
								" A.cpt_cd CPT_CD, D.nm CPT_NM, R.car_no CAR_NO,\n"+
								" S.alt_prn ALT_PRN, S.alt_int ALT_INT,(S.alt_prn+S.alt_int) ALT_AMT, S.ALT_REST ALT_REST,\n"+
								" DECODE(S.pay_dt, '', '-', SUBSTR(S.pay_dt, 1, 4)||'-'||SUBSTR(S.pay_dt, 5, 2)||'-'||SUBSTR(S.pay_dt, 7, 2)) PAY_DT,\n"+
								" DECODE(S.ALT_EST_DT, '', '-', SUBSTR(S.ALT_EST_DT, 1, 4)||'-'||SUBSTR(S.ALT_EST_DT, 5, 2)||'-'||SUBSTR(S.ALT_EST_DT, 7, 2)) ALT_EST_DT,\n"+
								" S.pay_dt PAY_DT1, S.alt_est_dt ALT_EST_DT1, S.pay_yn PAY_YN, '' lend_id, 0 gubun\n"+
							" FROM SCD_ALT_CASE S, ALLOT A, CONT C, CAR_REG R, CLIENT L, CODE D\n"+
							" WHERE R.car_mng_id = S.car_mng_id AND\n"+
								" A.rent_mng_id = C.rent_mng_id AND\n"+
								" A.rent_l_cd = C.rent_l_cd AND\n"+
								" C.use_yn = 'Y' AND\n"+
								" C.car_mng_id = R.car_mng_id AND\n"+
								" C.client_id = L.client_id AND\n"+
								" D.c_st = '0003' AND D.CODE <> '0000' AND\n"+
								" D.CODE = A.cpt_cd\n"+
							" UNION\n"+
							" SELECT decode(D.CODE,'0000','','') CAR_MNG_ID, S.alt_tm ALT_TM, C.rent_mng_id RENT_MNG_ID, L.client_id CLIENT_ID,\n"+
									" decode(D.CODE,'0000','', B.LEND_ID ) RENT_L_CD, decode(D.CODE,'0000','','') FIRM_NM, decode(D.CODE,'0000','','') CLIENT_NM, decode(D.CODE,'0000','','') CAR_NM,\n"+
									" B.cont_bn CPT_CD, D.nm CPT_NM, decode(D.CODE,'0000','','') CAR_NO,\n"+
									" S.alt_prn_amt ALT_PRN, S.alt_int_amt ALT_INT, (S.alt_prn_amt+S.alt_int_amt) ALT_AMT, S.alt_rest ALT_REST,\n"+
									" DECODE(S.pay_dt, '', '-', SUBSTR(S.pay_dt, 1, 4)||'-'||SUBSTR(S.pay_dt, 5, 2)||'-'||SUBSTR(S.pay_dt, 7, 2)) PAY_DT,\n"+
									" DECODE(S.ALT_EST_DT, '', '-', SUBSTR(S.ALT_EST_DT, 1, 4)||'-'||SUBSTR(S.ALT_EST_DT, 5, 2)||'-'||SUBSTR(S.ALT_EST_DT, 7, 2)) ALT_EST_DT,\n"+
									" S.pay_dt PAY_DT1, S.alt_est_dt ALT_EST_DT1, S.pay_yn PAY_YN, B.lend_id lend_id, 1 gubun\n"+
							" FROM CONT C, CAR_REG R, CAR_BANK N, LEND_BANK B , BANK_SCHE S, CLIENT L, CODE D\n"+
							" WHERE  R.car_mng_id = N.car_mng_id AND\n"+
								   " C.car_mng_id = R.car_mng_id AND\n"+
								   " N.lend_id = B.lend_id AND\n"+
								   " B.lend_id = S.lend_id AND\n"+
								   " C.client_id = L.client_id AND\n"+
									" D.c_st = '0003' AND D.CODE <> '0000' AND\n"+
									" D.CODE = B.cont_bn\n"+
						"  )\n";

		if(rc.equals("0"))
		{
			if(dt.equals("1"))		query += " where alt_est_dt1 = to_char(sysdate,'YYYYMMDD')";
			else if(dt.equals("2"))	query += " where alt_est_dt1 between '"+st_dt+"' and '"+end_dt+"'";
			else					query += " where alt_est_dt1 = alt_est_dt1";
		}
		if(rc.equals("1"))		
		{
			query += " where pay_yn = '1'";

			if(dt.equals("1"))		query += " and pay_dt1 = to_char(sysdate,'YYYYMMDD')";
			else if(dt.equals("2"))	query += " and pay_dt1 between '"+st_dt+"' and '"+end_dt+"'";
		}
		else if(rc.equals("2"))
		{
			query += " where pay_yn = '0'";
			
			if(dt.equals("1"))		query += " and alt_est_dt1 = to_char(sysdate,'YYYYMMDD')";
			else if(dt.equals("2"))	query += " and alt_est_dt1 between '"+st_dt+"' and '"+end_dt+"'";
		}

		if(kd.equals("1"))		query += " and firm_nm like '%"+wd+"%'";
		else if(kd.equals("2"))	query += " and upper(rent_l_cd) like upper('%"+wd+"%')";
		else if(kd.equals("3"))	query += " and car_no like '%"+wd+"%'";
		else if(kd.equals("4"))	query += " and cpt_cd = '"+wd+"'";
		else if(kd.equals("5"))	query += " and ALT_AMT ="+wd;
		query += " order by client_id, cpt_cd, to_number(alt_tm)";
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
	 *	할부금 납부처리를 위한 리스트 --- 통계
	 *	dt	-		납입예정일(0:전체, 1:당일, 2:기간)
	 *	rc	-		출금구분(0:전체, 1:출금, 2:미출금)
	 *	kd	-		기타검색항목(1:상호, 2:계약코드, 3:차량번호, 4:금융사, 5:월할부금)
	 *	wd	-		기타검색항목 검색어
	 *	st_dt, end_dt	- 납입예정일 시작일-종료일
	 */
	public Hashtable getAllotPayStat(String dt, String rc, String kd, String wd, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = " select\n"+
							" nvl(SUM(n_cnt), 0) N_CNT, nvl(sum(n_alt_prn), 0) N_ALT_PRN1, nvl(sum(n_alt_int), 0) N_ALT_INT1, nvl(sum(n_alt_amt), 0) N_ALT_AMT1, \n"+ //nvl(sum(n_alt_rest), 0) N_ALT_REST,\n"+
							" nvl(SUM(y_cnt), 0) Y_CNT, nvl(sum(y_alt_prn), 0) Y_ALT_PRN2, nvl(sum(y_alt_int), 0) Y_ALT_INT2, nvl(sum(y_alt_amt), 0) Y_ALT_AMT2, \n"+ //nvl(sum(y_alt_rest), 0) Y_ALT_REST,\n"+
							" nvl(SUM(n_cnt+y_cnt), 0) CNT, nvl(sum(n_alt_prn+y_alt_prn), 0) ALT_PRN1, nvl(sum(n_alt_int+y_alt_int), 0) ALT_INT1,\n"+
							" nvl(sum(n_alt_amt+y_alt_amt), 0) ALT_AMT1\n"+ //, nvl(sum(n_alt_rest+y_alt_rest), 0) ALT_REST\n"+
						" from \n"+
							"( select rent_l_cd, car_no, pay_yn, alt_est_dt, pay_dt, firm_nm, cpt_cd, alt_int, alt_prn,\n"+
										" N_CNT, Y_CNT, N_ALT_PRN, Y_ALT_PRN, N_ALT_INT, Y_ALT_INT, N_ALT_AMT, Y_ALT_AMT \n"+ //, N_ALT_REST, Y_ALT_REST\n"+
							" from\n"+
							"(\n"+
								"  select\n"+
									" C.rent_l_cd, R.car_no, S.pay_yn, S.alt_est_dt, S.pay_dt, nvl(L.firm_nm, L.client_nm) firm_nm, A.cpt_cd cpt_cd, S.alt_int alt_int, S.alt_prn alt_prn,\n"+
									" decode(S.pay_yn, '0', 1, 0) N_CNT, decode(S.pay_yn, '1', 1, 0) Y_CNT,\n"+
									" decode(S.pay_yn, '0', S.alt_prn, 0) N_ALT_PRN, decode(S.pay_yn, '1', S.alt_prn, 0) Y_ALT_PRN,\n"+
									" decode(S.pay_yn, '0', S.alt_int, 0) N_ALT_INT, decode(S.pay_yn, '1', S.alt_int, 0) Y_ALT_INT,\n"+
									" decode(S.pay_yn, '0', (S.alt_prn+S.alt_int), 0) N_ALT_AMT,decode(S.pay_yn, '1', (S.alt_prn+S.alt_int), 0) Y_ALT_AMT,\n"+
									" DECODE(S.pay_yn, '0', S.ALT_REST, 0) N_ALT_REST, DECODE(S.pay_yn, '1', S.ALT_REST, 0) Y_ALT_REST\n"+
									//" decode(S.pay_yn, '0', S.ALT_REST, 0) N_ALT_REST, decode(S.pay_yn, '1', S.ALT_REST, 0) Y_ALT_REST\n"+
								"  from scd_alt_case S, allot A, cont C, car_reg R, client L , code D \n"+
									" where R.car_mng_id = S.car_mng_id and\n"+
									" A.rent_mng_id = C.rent_mng_id and\n"+
									" A.rent_l_cd = C.rent_l_cd and\n"+
									" C.car_mng_id = R.car_mng_id and\n";
										query += " C.client_id = L.client_id  \n"+ //))\n";//+ 
										//query += " C.client_id = L.client_id)  \n"; //))\n";//+ 
									
																	
								"  union \n"+
								"  SELECT\n"+
										" decode(D.CODE,'0000','','') rent_l_cd, decode(D.CODE,'0000','','') car_no, S.pay_yn, S.alt_est_dt, S.pay_dt, decode(D.CODE,'0000','','') firm_nm, B.cont_bn cpt_cd, S.alt_int_amt alt_int, S.alt_prn_amt alt_prn,\n"+
										" DECODE(S.pay_yn, '0', 1, 0) N_CNT, DECODE(S.pay_yn, '1', 1, 0) Y_CNT,\n"+
										" DECODE(S.pay_yn, '0', S.alt_prn_amt, 0) N_ALT_PRN, DECODE(S.pay_yn, '1', S.alt_prn_amt, 0) Y_ALT_PRN,\n"+
										" DECODE(S.pay_yn, '0', S.alt_int_amt, 0) N_ALT_INT, DECODE(S.pay_yn, '1', S.alt_int_amt, 0) Y_ALT_INT,\n"+
										" DECODE(S.pay_yn, '0', (S.alt_prn_amt+S.alt_int_amt), 0) N_ALT_AMT,DECODE(S.pay_yn, '1', (S.alt_prn_amt+S.alt_int_amt), 0) Y_ALT_AMT,\n"+
										" DECODE(S.pay_yn, '0', S.ALT_REST, 0) N_ALT_REST, DECODE(S.pay_yn, '1', S.ALT_REST, 0) Y_ALT_REST\n"+
								" FROM CONT C, CAR_REG R, CAR_BANK N, LEND_BANK B , BANK_SCHE S, CLIENT L, CODE D \n"+
								" WHERE  R.car_mng_id = N.car_mng_id AND\n"+
										" C.car_mng_id = R.car_mng_id AND\n"+
										" N.lend_id = B.lend_id AND\n"+
										" B.lend_id = S.lend_id AND\n"+
										" C.client_id = L.client_id and\n"+
										" D.c_st = '0003' AND D.CODE <> '0000' AND \n"+
										" D.CODE = B.cont_bn";
								/*if(!rc.equals("0")) {
									query +=" )\n";
								}*/
									
								

		if(rc.equals("0"))
		{
					
			if(dt.equals("1"))		query += " and S.alt_est_dt = to_char(sysdate,'YYYYMMDD')";
			else if(dt.equals("2"))	query += " and S.alt_est_dt between '"+st_dt+"' and '"+end_dt+"' )";
			//else					query += " and S.alt_est_dt = alt_est_dt";
		}
		if(rc.equals("1"))		
		{
			query += ") where pay_yn = '1'";

			if(dt.equals("1"))		query += " and pay_dt = to_char(sysdate,'YYYYMMDD')";
			else if(dt.equals("2"))	query += " and pay_dt between '"+st_dt+"' and '"+end_dt+"'";
		}
		if(rc.equals("2"))
		{
			query += ") where pay_yn = '0'";
			
			if(dt.equals("1"))		query += " and alt_est_dt = to_char(sysdate,'YYYYMMDD')";
			else if(dt.equals("2"))	query += " and alt_est_dt between '"+st_dt+"' and '"+end_dt+"'";
		}
		
		if (rc.equals("0")) {
			if(kd.equals("1"))		query += " ) where firm_nm like '%"+wd+"%'";
			else if(kd.equals("2"))	query += " ) where upper(rent_l_cd) like upper('%"+wd+"%')";
			else if(kd.equals("3"))	query += " ) where car_no like '%"+wd+"%'";
			else if(kd.equals("4"))	query += " ) where cpt_cd = '"+wd+"'";
			else if(kd.equals("5"))	query += " ) where (alt_prn +alt_int) ="+wd; 
		}
		else {
			if(kd.equals("1"))		query += " and firm_nm like '%"+wd+"%'";
			else if(kd.equals("2"))	query += " and upper(rent_l_cd) like upper('%"+wd+"%')";
			else if(kd.equals("3"))	query += " and car_no like '%"+wd+"%'";
			else if(kd.equals("4"))	query += " and cpt_cd = '"+wd+"'";
			else if(kd.equals("5"))	query += " and (alt_prn +alt_int) ="+wd; 
		}
		
		query += ")";
		
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
     *	할부현황
     *	s_kd - 검색조건(1:상호, 2:금융사ID, 3:차종)
     *	t_wd - 검색어
     */
    public Vector getDebtStatics(String s_kd, String t_wd)
    {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "select X.rent_l_cd rent_l_cd, X.firm_nm firm_nm, X.car_id car_id, X.car_amt car_amt,"+
								" X.sd_amt sd_amt, X.dc_amt dc_amt, X.tot_amt tot_amt, Y.nm cpt_nm, X.rtn_way rtn_way,"+
								" X.lend_int lend_int, X.lend_int_amt lend_int_amt, X.pp_amt pp_amt, X.lend_prn lend_prn,"+
								" X.alt_fee alt_fee, X.stp_fee stp_fee, X.car_nm car_nm, "+
								" decode(X.dlv_dt, '', '', substr(X.dlv_dt, 1, 4) || '-' || substr(X.dlv_dt, 5, 2) || '-'||substr(X.dlv_dt, 7, 2)) dlv_dt"+
					" from"+
					" ("+
						" select C.rent_l_cd, nvl(L.firm_nm, L.client_nm) firm_nm, E.car_id, (E.CAR_CS_AMT+E.CAR_CV_AMT) car_amt, C.dlv_dt,"+
						    	" (E.SD_CS_AMT+E.SD_CV_AMT) sd_amt, (E.DC_CS_AMT+E.DC_CV_AMT) dc_amt,"+
								" (E.CAR_CS_AMT+E.CAR_CV_AMT+E.OPT_CS_AMT+E.OPT_CV_AMT+E.CLR_CS_AMT+E.CLR_CV_AMT+E.SD_CS_AMT+E.SD_CV_AMT-E.DC_CS_AMT-E.DC_CV_AMT-(E.tax_dc_s_amt+E.tax_dc_v_amt)) tot_amt,"+
								" A.cpt_cd, decode(A.rtn_way, '1', '자동이체', '2', '지로', '3', '기타') rtn_way,"+
								" A.lend_int, A.lend_int_amt, (F.PP_S_AMT+F.PP_V_AMT) pp_amt, A.lend_prn, A.alt_fee, A.stp_fee, R.car_nm"+
						" from cont C, client L, car_etc E, allot A, fee F, car_reg R"+
						" where C.rent_mng_id = E.rent_mng_id and"+
							  " C.rent_l_cd = E.rent_l_cd and"+
							  " C.rent_mng_id = A.rent_mng_id and"+
							  " C.rent_l_cd = A.rent_l_cd and"+
							  " C.rent_mng_id = F.rent_mng_id and"+
							  " C.car_mng_id = R.car_mng_id and"+
							  " C.rent_l_cd = F.rent_l_cd and"+
							  " C.client_id = L.client_id and"+
							  " C.use_yn = 'Y'"+
					" )X,"+
					" ("+
						" select code, nm from code where c_st='0003'"+
					" ) Y"+
					" where X.cpt_cd = Y.code(+)";
		if(s_kd.equals("1"))		query += " and X.firm_nm like '%"+t_wd+"%'";
		else if(s_kd.equals("2"))	query += " and X.cpt_cd = '"+t_wd+"'";
		else if(s_kd.equals("3"))	query += " and nvl(X.car_nm, ' ') like '%"+t_wd+"%'";
		
		query += " order by  dlv_dt ";
		
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
	 *	할부스케줄 insert
	 */
	public boolean insertDebtScdAdd(DebtScdBean debt)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
	
		
		int chk = 0;

		String query = "insert into scd_alt_case (CAR_MNG_ID, ALT_TM, ALT_EST_DT, ALT_PRN, ALT_INT, PAY_YN, PAY_DT, ALT_REST, R_ALT_EST_DT) values"+
						" (?, ?, replace(?, '-', ''), ?, ?, ?, replace(?, '-', ''), ?, replace(?, '-', ''))";

	
		try 
		{
			conn.setAutoCommit(false);		

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, debt.getCar_mng_id());
			pstmt.setString(2, debt.getAlt_tm());
			pstmt.setString(3, debt.getAlt_est_dt());
			pstmt.setInt   (4, debt.getAlt_prn());
			pstmt.setInt   (5, debt.getAlt_int());
			pstmt.setString(6, debt.getPay_yn());
			pstmt.setString(7, debt.getPay_dt());
			pstmt.setInt   (8, debt.getAlt_rest());
			pstmt.setString(9, debt.getR_alt_est_dt());
			pstmt.executeUpdate();
			pstmt.close();
		
						
			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[DebtDatabase:insertDebtScdAdd]"+e);
			System.out.println("[DebtDatabase:insertDebtScdAdd]"+query+" "+debt.getCar_mng_id());
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
   
	public Vector getDebtScdBacth(String lend_no)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	" select"+
							" CAR_MNG_ID, ALT_TM,"+
							" decode(ALT_EST_DT, '', '', substr(ALT_EST_DT, 1, 4) || '-' || substr(ALT_EST_DT, 5, 2) || '-'||substr(ALT_EST_DT, 7, 2)) ALT_EST_DT,"+
							" ALT_PRN, ALT_INT, PAY_YN, ALT_REST,"+
							" decode(PAY_DT, '', '', substr(PAY_DT, 1, 4) || '-' || substr(PAY_DT, 5, 2) || '-'||substr(PAY_DT, 7, 2)) PAY_DT, cls_rtn_dt, r_alt_est_dt "+
							" from scd_alt_case "+
							" where car_mng_id IN (SELECT b.car_mng_id FROM allot a, cont b WHERE a.lend_no=? AND a.rent_l_cd=b.rent_l_cd GROUP BY b.car_mng_id) and alt_tm<>'0'"+
							" order by to_number(ALT_TM)";
											
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, lend_no);
		    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				DebtScdBean debt = new DebtScdBean();
				debt.setCar_mng_id(rs.getString("CAR_MNG_ID")==null?"":rs.getString("CAR_MNG_ID"));
				debt.setAlt_tm(rs.getString("ALT_TM")==null?"":rs.getString("ALT_TM"));
				debt.setAlt_est_dt(rs.getString("ALT_EST_DT")==null?"":rs.getString("ALT_EST_DT"));
				debt.setAlt_prn(rs.getString("ALT_PRN")==null?0:Integer.parseInt(rs.getString("ALT_PRN")));
				debt.setAlt_int(rs.getString("ALT_INT")==null?0:Integer.parseInt(rs.getString("ALT_INT")));
				debt.setPay_yn(rs.getString("PAY_YN")==null?"":rs.getString("PAY_YN"));
				debt.setPay_dt(rs.getString("PAY_DT")==null?"":rs.getString("PAY_DT"));
				debt.setAlt_rest(rs.getString("ALT_REST")==null?0:Integer.parseInt(rs.getString("ALT_REST")));
				debt.setCls_rtn_dt(rs.getString("cls_rtn_dt")==null?"":rs.getString("cls_rtn_dt"));
				debt.setR_alt_est_dt(rs.getString("R_ALT_EST_DT")==null?"":rs.getString("R_ALT_EST_DT"));
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
	
}