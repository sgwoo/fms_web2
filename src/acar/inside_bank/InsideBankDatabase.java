package acar.inside_bank;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;
import acar.common.*;
import oracle.jdbc.*;
import oracle.sql.*;

public class InsideBankDatabase
{
	private Connection conn = null;
	public static InsideBankDatabase db;
	
	public static InsideBankDatabase getInstance()
	{
		if(InsideBankDatabase.db == null)
			InsideBankDatabase.db = new InsideBankDatabase();
		return InsideBankDatabase.db;
	}	
	

 	private DBConnectionManager connMgr = null;

    private void getConnection()
    {
    	try
    	{
	    	if(connMgr == null)
				connMgr = DBConnectionManager.getInstance();
			if(conn == null)
	        	conn = connMgr.getConnection("ebank");				
	    }catch(Exception e){
	    	System.out.println(" i can't get a connection........");
	    }
	}
	
	private void closeConnection()
	{
		if ( conn != null ) 
		{
			connMgr.freeConnection("ebank", conn);
			conn = null;
		}		
	}

	//대량이체등록과 결과가 분리되었을때 - 대량이체등록 표준1
	public boolean insertIbBulkTranReg(IbBulkTranBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;

		String query = " insert into ebank.IB_BULK_TRAN "+
						" ( "+
						"		 group_nm, tran_ip_bank_id, tran_ip_acct_nb, tran_remittee_nm,	 "+
						"        tran_amt, tran_ji_naeyong, tran_ip_naeyong,  "+
						"        tran_cms_cd, tran_memo, upche_key, tran_status, tran_type_cd "+
						" )"+
						" values"+
						" ("+
						"        ?, ?, replace(?,'-',''), ?, "+
						"        ?, ?, ?,  "+
						"        ?, ?, ?, '00', '23101' "+
						" )";
		
		//수취인성명조회결과
		String query2 = " insert into ebank.IB_REMITTEE_NM "+
				" ( "+
				"		 udk01, udk02, udk03, ip_bank_id, ip_acct_nb, remittee_nm,	 "+
				"        tran_amt, cms_cd, MATCH_YN "+
				" )"+
				" values"+
				" ("+
				"        ?, ?, ?, ?, replace(?,'-',''), ?, "+
				"        ?, ?, 'X'  "+
				" )";		
		
		//수취인성명조회결과-중복분제거
		String query3 = " delete ebank.IB_REMITTEE_NM where udk01=? ";

		try 
		{

			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  bean.getGroup_nm        ());
			pstmt.setString(2,  bean.getTran_ip_bank_id ());
			pstmt.setString(3,  bean.getTran_ip_acct_nb ());
			pstmt.setString(4,  bean.getTran_remittee_nm());
			pstmt.setString(5,  bean.getTran_amt        ());
			pstmt.setString(6,  bean.getTran_ji_naeyong ());
			pstmt.setString(7,  bean.getTran_ip_naeyong ());
			pstmt.setString(8,  bean.getTran_cms_cd     ());
			pstmt.setString(9,  bean.getTran_memo       ());
			pstmt.setString(10, bean.getUpche_key       ());
		    pstmt.executeUpdate();
			pstmt.close();
			
			pstmt3 = conn.prepareStatement(query3);
			pstmt3.setString(1,  bean.getUpche_key       ());
		    pstmt3.executeUpdate();
			pstmt3.close();	
			
			pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString(1,  bean.getUpche_key       ());
			pstmt2.setString(2,  bean.getUpche_key       ());
			pstmt2.setString(3,  bean.getUpche_key       ());
			pstmt2.setString(4,  bean.getTran_ip_bank_id ());
			pstmt2.setString(5,  bean.getTran_ip_acct_nb ());
			pstmt2.setString(6,  bean.getTran_remittee_nm());
			pstmt2.setString(7,  bean.getTran_amt        ());
			pstmt2.setString(8,  bean.getTran_cms_cd     ());
		    pstmt2.executeUpdate();
			pstmt2.close();			

			conn.commit();
			

	  	} catch (Exception e) {
			System.out.println("[InsideBankDatabase:insertIbBulkTranReg]"+ e);
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
           		if(pstmt != null)		pstmt.close();
           		if(pstmt2 != null)		pstmt2.close();
           		if(pstmt3 != null)		pstmt3.close();
			}catch(Exception ignore){}			
				closeConnection();
			return flag;
		}			
	}

	//대량이체등록과 결과가 합친것 - 대량이체처리결과 표준2
	public boolean insertIbBulkTran(IbBulkTranBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		PreparedStatement pstmt4 = null;
		ResultSet rs1 = null;
		String tran_dt_seq = "0";

		String query1 = " select to_char(nvl(max(to_number(tran_dt_seq))+1,1)) as tran_dt_seq from ebank.IB_BULK_TRAN where tran_dt=replace(?,'-','')";

		String query2 = " insert into ebank.IB_BULK_TRAN "+
						" ( "+
						"		 tran_dt, tran_dt_seq, group_nm, "+
						"        tran_ip_bank_id, tran_ip_acct_nb, tran_remittee_nm, "+
						"        tran_amt_req, tran_ji_naeyong, tran_ip_naeyong,  "+
						"        tran_cms_cd, tran_memo, upche_key, "+
						"        list_nb, list_nb_seq, tran_status "+
						" )"+
						" values"+
						" ("+
						"        replace(?,'-',''), ?, ?, "+
						"        ?, replace(?,'-',''), ?, "+
						"        ?, ?, ?,  "+
						"        ?, ?, ?,  "+
						"        '0','0', '00'   "+
						" )";

		//수취인성명조회결과
		String query3 = " insert into ebank.IB_REMITTEE_NM "+
				" ( "+
				"		 udk01, udk02, udk03, ip_bank_id, ip_acct_nb, remittee_nm,	 "+
				"        tran_amt, cms_cd, MATCH_YN "+
				" )"+
				" values"+
				" ("+
				"        ?, ?, ?, ?, replace(?,'-',''), ?, "+
				"        ?, ?, 'X'  "+
				" )";	
		

		//수취인성명조회결과-중복분제거
		String query4 = " delete ebank.IB_REMITTEE_NM where udk01=? ";
		
		
		try 
		{

			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query1);
			pstmt1.setString(1,	bean.getTran_dt());
	    	rs1 = pstmt1.executeQuery();
			if(rs1.next())
			{
				tran_dt_seq = rs1.getString(1);
			}
			rs1.close(); 
			pstmt1.close();

			pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString(1,  bean.getTran_dt            ());
			pstmt2.setString(2,  tran_dt_seq                  );
			pstmt2.setString(3,  bean.getGroup_nm			());
			pstmt2.setString(4,  bean.getTran_ip_bank_id	());
			pstmt2.setString(5,  bean.getTran_ip_acct_nb	());
			pstmt2.setString(6,  bean.getTran_remittee_nm	());
			pstmt2.setString(7,  bean.getTran_amt_req		());
			pstmt2.setString(8,  bean.getTran_ji_naeyong	());
			pstmt2.setString(9,  bean.getTran_ip_naeyong	());
			pstmt2.setString(10, bean.getTran_cms_cd		());
			pstmt2.setString(11, bean.getTran_memo			());
			pstmt2.setString(12, bean.getUpche_key			());
		    pstmt2.executeUpdate();
			pstmt2.close();
			
			pstmt4 = conn.prepareStatement(query4);
			pstmt4.setString(1,  bean.getUpche_key       ());
		    pstmt4.executeUpdate();
			pstmt4.close();			
			
			pstmt3 = conn.prepareStatement(query3);
			pstmt3.setString(1,  bean.getUpche_key       	());
			pstmt3.setString(2,  bean.getUpche_key      	());
			pstmt3.setString(3,  bean.getUpche_key      	());
			pstmt3.setString(4,  bean.getTran_ip_bank_id 	());
			pstmt3.setString(5,  bean.getTran_ip_acct_nb 	());
			pstmt3.setString(6,  bean.getTran_remittee_nm	());
			pstmt3.setString(7,  bean.getTran_amt_req    	());
			pstmt3.setString(8,  bean.getTran_cms_cd     	());
		    pstmt3.executeUpdate();
			pstmt3.close();					

			conn.commit(); 
			
	  	} catch (Exception e) {
			System.out.println("[InsideBankDatabase:insertIbBulkTran]"+ e);
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
                if(rs1 != null )		rs1.close();
           		if(pstmt1 != null)		pstmt1.close();
				if(pstmt2 != null)		pstmt2.close();
				if(pstmt3 != null)		pstmt3.close();
				if(pstmt4 != null)		pstmt4.close();
			}catch(Exception ignore){}			
				closeConnection();
			return flag;
		}			
	}

	public boolean updateIbBulkTran(IbBulkTranBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query = " update ebank.IB_BULK_TRAN set "+
						"        tran_ji_acct_nb 	= replace(?,'-',''), "+
						"        tran_ip_bank_id 	= ?, "+
						"        tran_ip_acct_nb 	= replace(?,'-',''), "+
						"        tran_remittee_nm	= ?, "+
						"        tran_amt_req      	= ?, "+
						"        tran_ip_naeyong 	= ?, "+
						"        tran_cms_cd     	= ?  "+
						" where upche_key = ?"+
						" ";

		try 
		{

			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  bean.getTran_ji_acct_nb		().trim());
			pstmt.setString(2,  bean.getTran_ip_bank_id		());
			pstmt.setString(3,  bean.getTran_ip_acct_nb		().trim());
			pstmt.setString(4,  bean.getTran_remittee_nm	());
			pstmt.setString(5,  bean.getTran_amt_req		());
			pstmt.setString(6,  bean.getTran_ip_naeyong		());
			pstmt.setString(7,  bean.getTran_cms_cd			());
			pstmt.setString(8,  bean.getUpche_key			());

		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
			

	  	} catch (Exception e) {
			System.out.println("[InsideBankDatabase:updateIbBulkTran]"+ e);
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
           		if(pstmt != null)		pstmt.close();
			}catch(Exception ignore){}			
				closeConnection();
			return flag;
		}			
	}

	public boolean deleteIbBulkTran(String actseq)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query = " delete from ebank.IB_BULK_TRAN "+
					   " where upche_key = ? and tran_status<>'02' "+
					   " ";
		try 
		{

			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  actseq);

		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
			

	  	} catch (Exception e) {
			System.out.println("[InsideBankDatabase:deleteIbBulkTran]"+ e);
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
           		if(pstmt != null)		pstmt.close();
			}catch(Exception ignore){}			
				closeConnection();
			return flag;
		}			
	}


	/* 신한 - 입출금내역(일반사용자조회) 
     */
	public Vector getIbAcctAllTrDdList(String s_kd, String t_wd, String s_wd, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		
		query = "select decode(a.acct_nb , '14989003035104', '05',  trim(a.bank_id) ) bank_id, a.tr_ipji_gbn, a.naeyong naeyong, \n " +
		       "  a.bank_nm bank_name, decode( a.acct_nb , '14989003035104' , '02822080807', a.acct_nb )   acct_nb,  \n " + 
		       "  b.bank_nm, b.bank_no, a.tr_date, a.tr_date_seq, a.acct_seq, a.jukyo jukyo, decode(a.tr_ipji_gbn, '1', round(a.tr_amt), 0) ip_amt, decode(a.tr_ipji_gbn, '2',  round(a.tr_amt), 0) out_amt , round(a.tr_af_amt) tran_remain, trim(a.br_nm) tran_branch, a.erp_fms_yn \n"+
				" from EBANK.IB_ACCTALL_TR_DD a, amazoncar.erp_bank  b  \n"+
				" where a.tr_date > '20100908' and  decode(a.acct_nb , '14989003035104', '05', trim(a.bank_id) )  = b.bank_id(+)  \n " + 
				"      and decode( a.acct_nb , '14989003035104' , '02822080807', a.acct_nb )  = b.acct_num(+) and a.acct_nb <> '140007754041'  ";
		
		if(s_kd.equals("1"))			query += " and a.tr_date like '%"+t_wd+"%'";
		else if(s_kd.equals("2"))		query += " and a.bank_nm like '%"+t_wd+"%'";
	
		if(!s_wd.equals(""))			query += " and trim(a.naeyong) like '%"+s_wd+"%' and a.tr_ipji_gbn = '1' ";
		
		query += " order by  a.bank_id, a.acct_nb, a.tr_date desc , to_number(trim(a.tr_date_seq))  ";

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
			System.out.println("[InsideBankDatabase:getIbAcctAllTrDdList]\n"+e);			
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
		
	//외근자 조회		
	public Vector getIbAcctAllTrDdList(String dt, String st_dt, String end_dt, String s_wd, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		
		query = "select trim(a.bank_id) bank_id, a.tr_ipji_gbn, a.naeyong naeyong, a.bank_nm bank_name, a.acct_nb acct_nb,  b.bank_nm, b.bank_no, a.tr_date, a.tr_date_seq, a.acct_seq, a.jukyo jukyo, decode(a.tr_ipji_gbn, '1', round(a.tr_amt), 0) ip_amt, decode(a.tr_ipji_gbn, '2',  round(a.tr_amt), 0) out_amt , \n"+
		      "  round(a.tr_af_amt) tran_remain, trim(a.br_nm) tran_branch, a.erp_fms_yn , ic.jung_type \n"+
				" from EBANK.IB_ACCTALL_TR_DD a, amazoncar.erp_bank  b , amazoncar.incom ic  \n"+
				" where a.tr_date > '20100908' and  trim(a.bank_id) = b.bank_id(+) and a.acct_nb = b.acct_num(+) and a.acct_nb <> '140007754041'  \n"+
				"  and  trim(a.acct_seq) = ic.acct_seq(+) and a.tr_date = ic.incom_dt(+) and trim(a.tr_date_seq) = ic.tr_date_seq(+) ";
		
		if(dt.equals("2"))			query += " and a.tr_date like to_char(sysdate,'YYYYMM')||'%'";
		else if(dt.equals("1"))		query += " and a.tr_date = to_char(sysdate,'YYYYMMDD')";
		else if(dt.equals("4"))		query += " and a.tr_date = to_char(to_date(to_char(sysdate,'YYYYMMDD')) - 1, 'yyyymmdd') ";
		else if(dt.equals("5"))		query += " and a.tr_date like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' ";
		else if(dt.equals("3")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and a.tr_date like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and a.tr_date between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}
			
		if(!s_wd.equals(""))			query += " and ( a.naeyong like '%"+s_wd+"%'  or  to_char(decode(a.tr_ipji_gbn, '1', round(a.tr_amt), 0) ) = replace('" + s_wd + "' , ',' , '') )    and a.tr_ipji_gbn = '1' ";
		
		query += " order by   a.bank_id, a.acct_nb, a.tr_date desc , to_number(trim(a.tr_date_seq))  ";
		
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
			System.out.println("[InsideBankDatabase:getIbAcctAllTrDdList]\n"+e);			
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
	
	
	/* 신한 - 입출금내역(일반사용자조회) 
     */
	public Vector getIbAcctAllTrDdEtcList(String s_kd, String t_wd, String s_wd, String s_bank,  String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
				
		query = "select decode(a.acct_nb , '14989003035104', '05',  trim(a.bank_id) ) bank_id, a.tr_ipji_gbn, a.naeyong, to_single_byte(a.naeyong) t_naeyong, \n " +
		       "  a.bank_nm bank_name, decode( a.acct_nb , '14989003035104' , '02822080807', a.acct_nb )   acct_nb,  \n " + 
		       "  b.bank_nm, b.bank_no, a.tr_date, trim(a.tr_date_seq) tr_date_seq, trim(a.acct_seq) acct_seq , a.jukyo, decode(a.tr_ipji_gbn, '1', round(a.tr_amt), 0) ip_amt, decode(a.tr_ipji_gbn, '2',  round(a.tr_amt), 0) out_amt , round(a.tr_af_amt) tran_remain, trim(a.br_nm) tran_branch, a.erp_fms_yn \n"+
				" from EBANK.IB_ACCTALL_TR_DD a, amazoncar.erp_bank  b  \n"+
				" where a.tr_date > '20100908' and  decode(a.acct_nb , '14989003035104', '05', trim(a.bank_id) )  = b.bank_id(+)  \n " + 
				"      and decode( a.acct_nb , '14989003035104' , '02822080807', a.acct_nb )  = b.acct_num(+) and a.acct_nb <> '140007754041'  ";
		
		if(s_kd.equals("1"))			query += " and a.tr_date like '%"+t_wd+"%'";
		else if(s_kd.equals("2"))	query += " and a.bank_nm like '%"+t_wd+"%'";		
		
		if(!s_bank.equals(""))			query += " and b.bank_nm like '"+s_bank+"%' ";
	
		if(!s_wd.equals("")){
		    if (s_wd.equals("matching") ) {
		    	query += " and a.tr_ipji_gbn = '1' and  a.erp_fms_yn = 'N' ";
		    } else {
		    	query += " and to_single_byte(a.naeyong) like '%"+s_wd+"%' and a.tr_ipji_gbn = '1' ";
		    }					
		}		
						
		query += " order by   a.bank_id, a.acct_nb , a.tr_date desc , to_number(trim(a.tr_date_seq))  ";
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
			System.out.println("[InsideBankDatabase:getIbAcctAllTrDdList]\n"+e);			
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
			
	/* 신한 집금 처리 완료등록  
     */
    public boolean updateIbAcctTallTrDdFmsYn(String acct_seq,  String tr_date , String tr_date_seq) 
    {
      	getConnection();
        PreparedStatement pstmt = null;
        String query = "";
        boolean flag = true;
 		                
        query = " update EBANK.IB_ACCTALL_TR_DD set erp_fms_yn = 'Y'  where  trim(acct_seq) =  ? and tr_date = replace(?, '-', '') and trim(tr_date_seq) = ? ";			 
         
       try{
            conn.setAutoCommit(false);
           
            pstmt = conn.prepareStatement(query);            
            pstmt.setString(1, acct_seq.trim()	);               
            pstmt.setString(2, tr_date	);
            pstmt.setString(3, tr_date_seq.trim()	);               
                       
            pstmt.executeUpdate();
             
            pstmt.close();
            conn.commit();

    
    	} catch (Exception e) {
    		System.out.println("[InsideBankDatabase:updateIbAcctTallTrDdFmsYn]\n"+e);
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

	/* 신한 집금 처리 완료등록  
     */
    public boolean updateIbAcctTallTrDdFmsYnCardCashback(String tr_seq) 
    {
      	getConnection();
        PreparedStatement pstmt = null;
        String query = "";
        boolean flag = true;
 		                
        query = " update EBANK.IB_ACCTALL_TR_DD set erp_fms_yn = 'Y'  where  trim(acct_seq)||tr_date||trim(tr_date_seq) =  replace(replace(?,' ',''),'-','') ";			 
         
       try{
            conn.setAutoCommit(false);
           
            pstmt = conn.prepareStatement(query);            
            pstmt.setString(1, tr_seq.trim()	);                                      
            pstmt.executeUpdate();
             
            pstmt.close();
            conn.commit();

    
    	} catch (Exception e) {
    		System.out.println("[InsideBankDatabase:updateIbAcctTallTrDdFmsYnCardCashback]\n"+e);
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

	public IbBulkTranBean getIbBulkTranCase(String actseq)
	{
		getConnection();
		IbBulkTranBean bean = new IbBulkTranBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	"";

		query = " select * from EBANK.IB_BULK_TRAN where upche_key=? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString   (1, actseq);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next()){
				bean.setTran_dt				(rs.getString(1) ==null?"":rs.getString(1));
				bean.setTran_dt_seq			(rs.getString(2) ==null?"":rs.getString(2));
				bean.setGroup_nm			(rs.getString(3) ==null?"":rs.getString(3));
				bean.setList_nb				(rs.getString(4) ==null?"":rs.getString(4));
				bean.setList_nb_seq			(rs.getString(5) ==null?"":rs.getString(5));
				bean.setTran_ji_acct_nb		(rs.getString(6) ==null?"":rs.getString(6));
				bean.setTran_ip_bank_id		(rs.getString(7) ==null?"":rs.getString(7));
				bean.setTran_ip_acct_nb		(rs.getString(8) ==null?"":rs.getString(8));
				bean.setTran_amt_req		(rs.getString(9) ==null?"":rs.getString(9));
				bean.setTran_amt			(rs.getString(10)==null?"":rs.getString(10));
				bean.setTran_amt_err		(rs.getString(11)==null?"":rs.getString(11));
				bean.setTran_fee			(rs.getString(12)==null?"":rs.getString(12));
				bean.setTran_remittee_nm	(rs.getString(13)==null?"":rs.getString(13));
				bean.setTran_ji_naeyong		(rs.getString(14)==null?"":rs.getString(14));
				bean.setTran_ip_naeyong		(rs.getString(15)==null?"":rs.getString(15));
				bean.setTran_cms_cd			(rs.getString(16)==null?"":rs.getString(16));
				bean.setTran_memo			(rs.getString(17)==null?"":rs.getString(17));
				bean.setUpche_key			(rs.getString(18)==null?"":rs.getString(18));
				bean.setTr_date				(rs.getString(19)==null?"":rs.getString(19));
				bean.setTr_time				(rs.getString(20)==null?"":rs.getString(20));
				bean.setTran_reg_date		(rs.getString(21)==null?"":rs.getString(21));
				bean.setTran_reg_time		(rs.getString(22)==null?"":rs.getString(22));
				bean.setTran_status			(rs.getString(23)==null?"":rs.getString(23));
				bean.setTran_type_cd		(rs.getString(24)==null?"":rs.getString(24));
				bean.setTran_result_cd		(rs.getString(25)==null?"":rs.getString(25));
            }
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[InsideBankDatabase:getIbBulkTranCase]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null)		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}
	}


        //삼성카드 - 승인내역
         	public Vector getTbAckInfoList(String s_kd, String t_wd, String s_wd, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
				
		query = "   select  a.cardno, a.ackno,  a.ackdate, a.ackamount, a.csamount, a.csvat, a.mercsocno, a.mercname, a.mercrepr ,  \n"+
				" a.vattype,  decode(a.vattype, '1', '일반과세자', '2', '간이과세자',  '3', '면세사업자', '6', '비영리법인', '확인요망'   )  vatname,  a.mercaddr1||a.mercaddr2  mercaddr,  a.erp_fms_yn  from EBANK.TBLACKINFO  a		 \n"+
				" where a.ackdate > '20130820'  ";
		
		
		
		if(s_kd.equals("1"))			query += " and a.ackdate like '%"+t_wd+"%'";
			
		
		query += " order by  a.cardno, a.ackdate  ";

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
			System.out.println("[InsideBankDatabase:getTbAckInfoList]\n"+e);			
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