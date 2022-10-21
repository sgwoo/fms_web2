package tax;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;


public class Tax_PostDatabase
{
	private Connection conn = null;
	public static Tax_PostDatabase db;
	
	public static Tax_PostDatabase getInstance()
	{
		if(Tax_PostDatabase.db == null)
			Tax_PostDatabase.db = new Tax_PostDatabase();
		return Tax_PostDatabase.db;
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
	    	System.out.println("I can't get a connection........");
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


	
	//우편물 조회
	public Vector getTax_FirmList(String gubun, String s_kd, String s_kd2, String t_wd, String sort, String asc)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
			

	    query = " select distinct b.CON_AGNT_EMAIL, d.agnt_email, decode(a.brch_id, 'S1','본사','B1','부산','D1','대전') brch_id, b.client_id, b.client_st, b.FIRM_NM, b.CLIENT_NM, b.ENP_NO, b.O_TEL, b.fax, b.HO_ADDR, nvl(b.CON_AGNT_EMAIL, d.agnt_email) con_agnt_email1, "+ 
				" decode( b.client_st, '1', '법인', '2', '개인', '3', '개인법인', '4', '개인법인', '5', '개인법인', '6', '기타' ) AS CLIENT_GB, e.user_nm "+
				" from cont a, client b, fee f,  (select rent_mng_id, rent_l_cd from scd_fee_stop where cancel_dt is  null ) c,"+
				" client_site d, users e, (select rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_l_cd) g "+
				" where "+
				" nvl(a.use_yn,'Y')='Y'	"+			//살아있는계약
				" and a.car_st<>'2'		"+			//보유차제외
				" and a.client_id=b.client_id and a.MNG_ID = e.USER_ID "+
				" and b.client_id = d.client_id(+)"+
				" and a.rent_mng_id = c.rent_mng_id(+) and a.rent_l_cd = c.rent_l_cd(+)  "+
				" and a.rent_l_cd=f.rent_l_cd "+
				" and f.rent_l_cd=g.rent_l_cd and f.rent_st=g.rent_st ";
				

		if(s_kd.equals("1")){	query += " and FIRM_NM LIKE '%"+t_wd+"%' \n";
		}else if(s_kd.equals("2")){	query += " and e.user_nm LIKE '%"+t_wd+"%' \n";
		}

		if(s_kd2.equals("1")){		query += " and a.brch_id like 'S1' \n";	
		}else if(s_kd2.equals("2")){		query += " and a.brch_id like 'B1' \n";	
		}else if(s_kd2.equals("3")){		query += " and a.brch_id like 'D1' \n";	
		}

		if(gubun.equals("1")){		query += " and client_st = '1' ";
		}else if(gubun.equals("2")){		query += " and client_st in ('3','4','5') ";
		}else if(gubun.equals("3")){		query += " and client_st = '2' ";
		}else if(gubun.equals("4")){		query += " and client_st = '6' ";
		}

		query += " AND (( b.CON_AGNT_EMAIL IS NOT NULL AND NOT b.con_agnt_email LIKE '%@%' )  OR (b.con_agnt_email IS NULL AND d.agnt_email IS NULL) or b.CON_AGNT_EMAIL like '%@%' and (LENGTH(b.con_agnt_email)< 6 or LENGTH(d.agnt_email)< 6))";
        query += "ORDER BY decode( b.client_st, '1', '1', '2', '5', '3', '2', '4', '3', '5', '4', '6', '6' ) ASC, decode(brch_id,'본사','1','부산','2','대전','3' )asc, CON_AGNT_EMAIL desc ";


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
			System.out.println("[Tax_PostDatabase:getTax_FirmList]\n"+e);
			System.out.println("[Tax_PostDatabase:getTax_FirmList]\n"+query);
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
	 *	채권채무미수  금액
	 */	
	public Vector getTaxRemainAmt(String t_wd )
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
	
		query = " select   reccoregno, firm_nm, r_site,  ven_code, sum(req_amt) req_amt, sum(pay_amt) pay_amt , sum(non_amt) non_amt, sum(est_amt) est_amt, sum(ext_amt) ext_amt  from ( \n "+
		   		"	 select d.firm_nm, e.r_site,  \n "+
				"      decode(decode(b.reccoregno,'0000000000',b.reccossn,b.reccoregno),'',decode(e.seq,'',decode(d.client_st,'2',TEXT_DECRYPT(d.ssn, 'pw' ) ,d.enp_no), nvl(TEXT_DECRYPT(e.enp_no, 'pw' ) ,decode(d.client_st,'2',TEXT_DECRYPT(d.ssn, 'pw' ) ,d.enp_no))),decode(b.reccoregno,'0000000000',b.reccossn,b.reccoregno)) reccoregno,  \n "+
				"      decode(e.seq,'',d.ven_code, nvl(e.ven_code,d.ven_code)) ven_code, \n "+
				"      sum(a.item_supply+a.item_value) req_amt, sum(nvl(c.pay_amt,0)) pay_amt,  sum(nvl(c.non_amt,0)) non_amt, sum(a.item_supply+a.item_value)-sum(nvl(c.pay_amt,0))-sum(nvl(c.non_amt,0)) est_amt,  \n "+
			  	"      sum(nvl(se.ext_amt,0)) ext_amt   \n "+
				"		from   tax_item_list a, tax b, \n "+
				"        ( select rent_mng_id, rent_l_cd ,sum(ext_pay_amt) ext_amt from scd_ext where ext_st = '0'  group by rent_mng_id, rent_l_cd ) se,   \n "+
				"        ( select rent_mng_id, rent_l_cd, rent_st, rent_seq, fee_tm, sum(rc_amt) pay_amt, sum(decode(bill_yn,'N',fee_s_amt+fee_v_amt)) non_amt  \n "+
				"          from   scd_fee  group by rent_mng_id, rent_l_cd, rent_st, rent_seq, fee_tm  ) c,  client d, client_site e  \n "+
				"		 where  a.gubun='1' and a.item_id=b.item_id and b.tax_st='O'   \n "+
			 	"	    and a.rent_l_cd=c.rent_l_cd and a.rent_st=c.rent_st and a.rent_seq=c.rent_seq and a.tm=c.fee_tm  \n "+
				"        and b.client_id=d.client_id  \n "+
				"        and b.client_id=e.client_id(+) and b.seq=e.seq(+)  \n "+
				"        and a.item_supply+a.item_value-nvl(c.pay_amt,0)-nvl(c.non_amt,0) > 0  \n "+
				"       and  a.rent_l_cd = se.rent_l_cd(+) \n "+
				"        and d.firm_nm LIKE '%"+t_wd+"%' \n "+
				"		 group by d.firm_nm, e.r_site,  \n "+
				"            decode(decode(b.reccoregno,'0000000000',b.reccossn,b.reccoregno),'',decode(e.seq,'',decode(d.client_st,'2',TEXT_DECRYPT(d.ssn, 'pw' ) ,d.enp_no), nvl(TEXT_DECRYPT(e.enp_no, 'pw' ) ,decode(d.client_st,'2',TEXT_DECRYPT(d.ssn, 'pw' ) ,d.enp_no))),decode(b.reccoregno,'0000000000',b.reccossn,b.reccoregno)),  \n "+
				"            decode(e.seq,'',d.ven_code, nvl(e.ven_code,d.ven_code))    \n "+        
				"    union all     \n "+      
			    "       select    d.firm_nm, e.r_site, \n "+
			    "       decode(decode(b.reccoregno,'0000000000',b.reccossn,b.reccoregno),'',decode(e.seq,'',decode(d.client_st,'2',TEXT_DECRYPT(d.ssn, 'pw' ),d.enp_no), nvl(TEXT_DECRYPT(e.enp_no, 'pw' ) ,decode(d.client_st,'2',TEXT_DECRYPT(d.ssn, 'pw' ),d.enp_no))),decode(b.reccoregno,'0000000000',b.reccossn,b.reccoregno)) reccoregno, \n "+
			    "       decode(e.seq,'',d.ven_code, nvl(e.ven_code,d.ven_code)) ven_code, \n "+
			    "       sum(a.item_supply+a.item_value) req_amt, sum(nvl(c.pay_amt,0)) pay_amt,   sum(nvl(c.non_amt,0)) non_amt, \n "+
			    "       sum(a.item_supply+a.item_value)-sum(nvl(c.pay_amt,0))-sum(nvl(c.non_amt,0)) est_amt ,\n "+
			    "      0  ext_amt  \n "+
			    "		 from   tax_item_list a, tax b, \n "+
			    "     	  ( select rent_mng_id, rent_l_cd, rent_st, rent_seq, ext_id, sum(ext_pay_amt) pay_amt, sum(decode(bill_yn,'N',ext_s_amt+ext_v_amt)) non_amt \n "+
			    "         from   scd_ext  where  ext_st='3' group by rent_mng_id, rent_l_cd, rent_st, rent_seq, ext_id   ) c,  client d, client_site e \n "+
			    "      where  a.gubun in ('7') and a.item_id=b.item_id and b.tax_st='O' \n "+
			    "       and a.rent_l_cd=c.rent_l_cd and a.tm=c.ext_id \n "+
			    "       and b.client_id=d.client_id \n "+
			    "       and b.client_id=e.client_id(+) and b.seq=e.seq(+) \n "+
			    "       and a.item_supply+a.item_value-nvl(c.pay_amt,0)-nvl(c.non_amt,0) > 0 \n "+
			    "       and d.firm_nm LIKE '%"+t_wd+"%'  \n "+
			    "		group by d.firm_nm, e.r_site, \n "+
			    "         decode(decode(b.reccoregno,'0000000000',b.reccossn,b.reccoregno),'',decode(e.seq,'',decode(d.client_st,'2',TEXT_DECRYPT(d.ssn, 'pw' ),d.enp_no), nvl(TEXT_DECRYPT(e.enp_no, 'pw' ),decode(d.client_st,'2',TEXT_DECRYPT(d.ssn, 'pw' ),d.enp_no))),decode(b.reccoregno,'0000000000',b.reccossn,b.reccoregno)),  \n "+
			    "         decode(e.seq,'',d.ven_code, nvl(e.ven_code,d.ven_code))   \n "+
				"   ) a  \n "+
				" group by reccoregno, firm_nm, r_site,  ven_code  \n "+  			              
				" order by  2 desc ";

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
			System.out.println("[Tax_PostDatabase:getTaxRemainAmt]\n"+e);
			System.out.println("[Tax_PostDatabase:getTaxRemainAmt]\n"+query);
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

