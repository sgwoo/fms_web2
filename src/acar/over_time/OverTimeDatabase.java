/**
 * 특근수당
 * @ author : Gill Sun Ryu
 * @ e-mail : gillsun@empal.com
 * @ create date : 2009. 03. 16
 * @ last modify date : 
 */

package acar.over_time;

import java.io.*;
import java.sql.*;
import java.util.*;
import java.text.*;
import acar.database.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.UnknownDataException;
import acar.exception.DatabaseException;

public class OverTimeDatabase
{
	private Connection conn = null;
	public static OverTimeDatabase db;
	
	public static OverTimeDatabase getInstance()
	{
		if(OverTimeDatabase.db == null)
			OverTimeDatabase.db = new OverTimeDatabase();
		return OverTimeDatabase.db;
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
	 *	조직관리 -> 특근수당 -> 미결재 조회 
	 */

	
	public Vector Over_List(String user_id, String st_year, String st_mon, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

			query =   " select a.user_id, a.id, e.br_nm, a.user_pos,  c.nm as dept_nm, \n"
						+ "  a.user_nm, b.doc_no, substr(b.reg_dt,1,4)||'-'||substr(b.reg_dt,5,2)||'-'||substr(b.reg_dt,7,2) reg_dt, b.over_cont, b.over_cr, "						
						+ " b.over_sjgj, b.over_sjgj_dt, b.over_sjgj_op, b.over_addr, b.over_card1_dt, b.over_card1_amt, b.over_cash1_dt, b.over_cash1_amt, b.over_cash1_file, b.over_cash1_cr_amt, b.over_cash1_cr_dt, b.over_cash1_cr_jpno, b.over_s_cash1_dt, b.over_s_cash1_amt, b.over_s_cash1_file, b.over_s_cash1_cr_amt, b.over_s_cash1_cr_jpno, "
						+ " b.over_card2_dt, b.over_card2_amt, b.over_cash2_dt, b.over_cash2_amt, b.over_cash2_file, b.over_cash2_cr_amt, b.over_cash2_cr_dt, b.over_cash2_cr_jpno, b.over_s_cash2_dt, b.over_s_cash2_amt, b.over_s_cash2_file, b.over_s_cash2_cr_amt, b.over_s_cash2_cr_jpno, "
						+ " b.over_card3_dt, b.over_card3_amt, b.over_cash3_dt, b.over_cash3_amt, b.over_cash3_file, b.over_cash3_cr_amt, b.over_cash3_cr_dt, b.over_cash3_cr_jpno, b.over_s_cash3_dt, b.over_s_cash3_amt, b.over_s_cash3_file, b.over_s_cash3_cr_amt, b.over_s_cash3_cr_jpno, "
						+ " b.over_card_tot, b.over_cash_tot, b.over_s_cash_tot, b.over_scgy, b.over_scgy_dt, b.over_scgy_pl_dt, b.s_check, b.s_check_dt, b.s_check_id, b.t_check, b.t_check_dt, b.t_check_id, b.s_check1, b.s_check1_dt, b.s_check1_id, b.t_check1, b.t_check1_dt, b.t_check1_id, b.t_check2, b.t_check2_dt, b.t_check2_id, b.t_check3, b.t_check3_dt, b.t_check3_id, b.t_check4, b.t_check4_dt, b.t_check4_id, \n"
						+ " trunc(round(to_number(to_date(b.end_dt ||b.end_h||b.end_m,'YYYYMMDDhh24mi')-to_date(b.start_dt||b.start_h||b.start_m,'YYYYMMDDhh24mi'))*24*60)/60) hh, \n"
						+ " trunc(mod(round(to_number(to_date(b.end_dt||b.end_h||b.end_m,'YYYYMMDDhh24mi')-to_date(b.start_dt||b.start_h||b.start_m,'YYYYMMDDhh24mi'))*24*60),60)) mi, \n"
						+ " b.start_dt, b.start_h, b.start_m, b.end_dt, b.end_h, b.end_m, b.over_time_year, b.over_time_mon, b.jb_time\n"
						+ " from users a, over_time b,  ( select c_st, code, nm_cd, nm from code where c_st = '0002' and code <> '0000'  ) c , branch e "
						+ " where a.user_id = b.user_id and b.t_check is null  and a.dept_id =c.code and a.br_id = e.br_id ";
			
	//		if(!st_year.equals(""))			query += " and b.over_time_year = '"+st_year+"' \n";
	//		if(!st_mon.equals(""))			query += " and to_number(b.over_time_mon) = '"+st_mon+"' \n";
			

			query += "order by b.over_time_year desc, b.over_time_mon desc, b.start_dt desc";


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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[OverTimeDatabase:Over_List]"+e);
			System.out.println("[OverTimeDatabase:Over_List]"+query);
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
	 *	조직관리 -> 특근수당 -> 결재완료 조회
	 */

	
	public Vector Over_List2(String user_id, String st_year, String st_mon, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		query =   " select a.user_id, a.id, e.br_nm, a.user_pos,  c.nm as dept_nm, \n"
				+ " a.user_nm, b.doc_no, substr(b.reg_dt,1,4)||'-'||substr(b.reg_dt,5,2)||'-'||substr(b.reg_dt,7,2) reg_dt, b.over_cont, b.over_cr, "						
				+ " b.over_sjgj, b.over_sjgj_dt, b.over_sjgj_op, b.over_addr, b.over_card1_dt, b.over_card1_amt, b.over_cash1_dt, b.over_cash1_amt, b.over_cash1_file, b.over_cash1_cr_amt, b.over_cash1_cr_dt, b.over_cash1_cr_jpno, b.over_s_cash1_dt, b.over_s_cash1_amt, b.over_s_cash1_file, b.over_s_cash1_cr_amt, b.over_s_cash1_cr_jpno, "
				+ " b.over_card2_dt, b.over_card2_amt, b.over_cash2_dt, b.over_cash2_amt, b.over_cash2_file, b.over_cash2_cr_amt, b.over_cash2_cr_dt, b.over_cash2_cr_jpno, b.over_s_cash2_dt, b.over_s_cash2_amt, b.over_s_cash2_file, b.over_s_cash2_cr_amt, b.over_s_cash2_cr_jpno, "
				+ " b.over_card3_dt, b.over_card3_amt, b.over_cash3_dt, b.over_cash3_amt, b.over_cash3_file, b.over_cash3_cr_amt, b.over_cash3_cr_dt, b.over_cash3_cr_jpno, b.over_s_cash3_dt, b.over_s_cash3_amt, b.over_s_cash3_file, b.over_s_cash3_cr_amt, b.over_s_cash3_cr_jpno, "
				+ " b.over_card_tot, b.over_cash_tot, b.over_s_cash_tot, b.over_scgy, b.over_scgy_dt, b.over_scgy_pl_dt, b.s_check, b.s_check_dt, b.s_check_id, b.t_check, b.t_check_dt, b.t_check_id, b.s_check1, b.s_check1_dt, b.s_check1_id, b.t_check1, b.t_check1_dt, b.t_check1_id, b.t_check2, b.t_check2_dt, b.t_check2_id, b.t_check3, b.t_check3_dt, b.t_check3_id, b.t_check4, b.t_check4_dt, b.t_check4_id, \n"
				+ " trunc(round(to_number(to_date(b.end_dt||b.end_h||b.end_m,'YYYYMMDDhh24mi')-to_date(b.start_dt||b.start_h||b.start_m,'YYYYMMDDhh24mi'))*24*60)/60) hh, \n"
				+ " trunc(mod(round(to_number(to_date(b.end_dt||b.end_h||b.end_m,'YYYYMMDDhh24mi')-to_date(b.start_dt||b.start_h||b.start_m,'YYYYMMDDhh24mi'))*24*60),60)) mi, \n"
				+ " b.start_dt, b.start_h, b.start_m, b.end_dt, b.end_h, b.end_m, b.over_time_year, b.over_time_mon, b.jb_time\n"
				+ ", (b.start_dt || ' '|| b.start_h ||':'||b.start_m) as start_dthm, (b.end_dt || ' '|| b.end_h ||':'||b.end_m) as end_dthm "
				+ ", (trunc( round( to_number( to_date(  b.end_dt ||  b.end_h || b.end_m, 'YYYYMMDDhh24mi' ) - to_date( b.start_dt  || b.start_h || b.start_m, 'YYYYMMDDhh24mi' )) * 24 * 60 ) / 60 ) ||':'||trunc( mod( round( to_number( to_date( b.end_dt || b.end_h || b.end_m, 'YYYYMMDDhh24mi' ) - to_date(  b.start_dt || b.start_h || b.start_m, 'YYYYMMDDhh24mi' )) * 24 * 60 ), 60 )) ) as hhmi "
				+ " from users a, over_time b, ( select c_st, code, nm_cd, nm from code where c_st = '0002' and code <> '0000'  ) c , branch e "
				+ " where a.user_id = b.user_id and b.t_check is not null and a.dept_id =c.code and a.br_id = e.br_id  ";

			if(!st_year.equals(""))			query += " and b.over_time_year = '"+st_year+"' \n";
			if(!st_mon.equals(""))			query += " and to_number(b.over_time_mon) = '"+st_mon+"' \n";
	
			query += "order by b.over_time_year desc, b.over_time_mon desc, b.start_dt desc";


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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[OverTimeDatabase:Over_List2]"+e);
			System.out.println("[OverTimeDatabase:Over_List2]"+query);
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
	 *	조직관리 -> 특근수당 -> 결재완료 조회
	 */

	
	public Vector Over_List_Excel(String user_id, String st_year, String st_mon, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		query =   " select a.user_id, a.id, e.br_nm, a.user_pos,  c.nm as dept_nm, \n"
				+ " a.user_nm, b.doc_no, substr(b.reg_dt,1,4)||'-'||substr(b.reg_dt,5,2)||'-'||substr(b.reg_dt,7,2) reg_dt, b.over_cont, b.over_cr, "						
				+ " b.over_sjgj, b.over_sjgj_dt, b.over_sjgj_op, b.over_addr, b.over_card1_dt, b.over_card1_amt, b.over_cash1_dt, b.over_cash1_amt, b.over_cash1_file, b.over_cash1_cr_amt, b.over_cash1_cr_dt, b.over_cash1_cr_jpno, b.over_s_cash1_dt, b.over_s_cash1_amt, b.over_s_cash1_file, b.over_s_cash1_cr_amt, b.over_s_cash1_cr_jpno, "
				+ " b.over_card2_dt, b.over_card2_amt, b.over_cash2_dt, b.over_cash2_amt, b.over_cash2_file, b.over_cash2_cr_amt, b.over_cash2_cr_dt, b.over_cash2_cr_jpno, b.over_s_cash2_dt, b.over_s_cash2_amt, b.over_s_cash2_file, b.over_s_cash2_cr_amt, b.over_s_cash2_cr_jpno, "
				+ " b.over_card3_dt, b.over_card3_amt, b.over_cash3_dt, b.over_cash3_amt, b.over_cash3_file, b.over_cash3_cr_amt, b.over_cash3_cr_dt, b.over_cash3_cr_jpno, b.over_s_cash3_dt, b.over_s_cash3_amt, b.over_s_cash3_file, b.over_s_cash3_cr_amt, b.over_s_cash3_cr_jpno, "
				+ " b.over_card_tot, b.over_cash_tot, b.over_s_cash_tot, b.over_scgy, b.over_scgy_dt, b.over_scgy_pl_dt, b.s_check, b.s_check_dt, b.s_check_id, b.t_check, b.t_check_dt, b.t_check_id, b.s_check1, b.s_check1_dt, b.s_check1_id, b.t_check1, b.t_check1_dt, b.t_check1_id, b.t_check2, b.t_check2_dt, b.t_check2_id, b.t_check3, b.t_check3_dt, b.t_check3_id, b.t_check4, b.t_check4_dt, b.t_check4_id, \n"
				+ " trunc(round(to_number(to_date(b.end_dt||b.end_h||b.end_m,'YYYYMMDDhh24mi')-to_date(b.start_dt||b.start_h||b.start_m,'YYYYMMDDhh24mi'))*24*60)/60) hh, \n"
				+ " trunc(mod(round(to_number(to_date(b.end_dt||b.end_h||b.end_m,'YYYYMMDDhh24mi')-to_date(b.start_dt||b.start_h||b.start_m,'YYYYMMDDhh24mi'))*24*60),60)) mi, \n"
				+ " b.start_dt, b.start_h, b.start_m, b.end_dt, b.end_h, b.end_m, b.over_time_year, b.over_time_mon, b.jb_time\n"
				+ ", (b.start_dt || ' '|| b.start_h ||':'||b.start_m) as start_dthm, (b.end_dt || ' '|| b.end_h ||':'||b.end_m) as end_dthm "
				+ ", (trunc( round( to_number( to_date(  b.end_dt ||  b.end_h || b.end_m, 'YYYYMMDDhh24mi' ) - to_date( b.start_dt  || b.start_h || b.start_m, 'YYYYMMDDhh24mi' )) * 24 * 60 ) / 60 ) ||':'||trunc( mod( round( to_number( to_date( b.end_dt || b.end_h || b.end_m, 'YYYYMMDDhh24mi' ) - to_date(  b.start_dt || b.start_h || b.start_m, 'YYYYMMDDhh24mi' )) * 24 * 60 ), 60 )) ) as hhmi "
				+ " from users a, over_time b, ( select c_st, code, nm_cd, nm from code where c_st = '0002' and code <> '0000'  ) c , branch e "
				+ " where a.user_id = b.user_id and b.t_check is not null and a.dept_id =c.code and a.br_id = e.br_id  ";

			if(!st_year.equals(""))			query += " and b.over_time_year = '"+st_year+"' \n";
			if(!st_mon.equals(""))			query += " and to_number(b.over_time_mon) = '"+st_mon+"' \n";
	
			query += "order by a.user_nm, b.START_DT||b.START_H||b.START_M, b.over_time_year desc, b.over_time_mon desc, b.start_dt desc";


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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[OverTimeDatabase:Over_List_Excel]"+e);
			System.out.println("[OverTimeDatabase:Over_List_Excel]"+query);
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
	 *	특근정보 입력하기
	 */

public String insertOver_time(Over_TimeBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Statement stmt = null;
		
		ResultSet rs1 = null;
		Statement stmt1 = null;
		
		int count = 0;
		String query = "";
		String query_seq = "";
		String query_jb = "";
		
		String doc_no = "";
		int  jb_time = 0;
		int seq = 0;

 	  	query_seq = " select to_char(sysdate,'YYYYMMDD')||nvl(ltrim(to_char(to_number(max(substr(doc_no,9,4))+1), '0000')), '0001') doc_no "//nvl(max(seq)+1, 1), 
				   +" from over_time where substr(doc_no,1,8)=to_char(sysdate,'YYYYMMDD')";	// and user_id = '" + bean.getUser_id() + "'
		
		query_jb = " select  trunc(round(to_number(to_date(replace('"+bean.getEnd_dt()+"', '-', '')||'"+ bean.getEnd_h()+"'||'"+ bean.getEnd_m()+"','YYYYMMDDhh24mi')-to_date(replace('"+bean.getStart_dt()+"', '-', '')||'"+ bean.getStart_h()+"'||'"+ bean.getStart_m()+"','YYYYMMDDhh24mi'))*24*60)/60) from dual";
		 		
		 		
		query = " insert into over_time \n"+
				" (user_id, doc_no, reg_dt, over_sjgj, over_sjgj_dt, over_sjgj_op, over_cont, over_cr,  \n"+//seq, 

				"  jb_time, jb_time2, over_addr, \n"+

				"  over_card1_dt, over_card1_amt, over_cash1_dt, over_cash1_amt, over_cash1_file, over_cash1_cr_amt, over_cash1_cr_dt, \n"+

				"  over_cash1_cr_jpno, over_s_cash1_dt, over_s_cash1_amt, over_s_cash1_file, over_s_cash1_cr_amt, over_s_cash1_cr_jpno,\n"+
				
				"  over_card2_dt, over_card2_amt, over_cash2_dt, over_cash2_amt, over_cash2_file, over_cash2_cr_amt, over_cash2_cr_dt, \n"+
				
				"  over_cash2_cr_jpno, over_s_cash2_dt, over_s_cash2_amt, over_s_cash2_file, over_s_cash2_cr_amt, over_s_cash2_cr_jpno, \n"+
				
				"  over_card3_dt, over_card3_amt, over_cash3_dt, over_cash3_amt, over_cash3_file, over_cash3_cr_amt, over_cash3_cr_dt, \n"+
				
				"  over_cash3_cr_jpno, over_s_cash3_dt, over_s_cash3_amt, over_s_cash3_file, over_s_cash3_cr_amt, over_s_cash3_cr_jpno, \n"+
				
				"  over_card_tot, over_cash_tot, over_s_cash_tot, start_dt, start_h, start_m, end_dt, end_h, end_m, over_time_year, over_time_mon \n"+
				
				" ) values ("+
				
				" ?, ?, to_char(sysdate,'YYYYMMDD'), ?, replace(?, '-', ''), ?, ?, ?, "+//?, 
				
				" ?, ?, ?, "+
				
				" ?, ?, ?, ?, ?, ?, ?, "+ 
				
				" ?, ?, ?, ?, ?, ?, "+
				
				" ?, ?, ?, ?, ?, ?, ?, "+
				
				" ?, ?, ?, ?, ?, ?, "+
				
				" ?, ?, ?, ?, ?, ?, ?, "+
				
				" ?, ?, ?, ?, ?, ?, "+
				
				" ?, ?, ?,  replace(?, '-', ''),   ?, ?,  replace(?, '-', ''), ?, ?, ?, ? "+
				
				" )";	
			
		try 
		{			
			conn.setAutoCommit(false);
			
  			stmt = conn.createStatement();
            rs = stmt.executeQuery(query_seq);
         
            if(rs.next())
				doc_no = rs.getString(1)==null?"":rs.getString(1);
            rs.close();
			stmt.close();
			
			stmt1 = conn.createStatement();
            rs1 = stmt1.executeQuery(query_jb);         
            if(rs1.next())
				jb_time = rs1.getInt(1);
            rs1.close();
			stmt1.close();
				
			pstmt = conn.prepareStatement(query);

			pstmt.setString	(1,  bean.getUser_id());
//			pstmt.setInt(2, seq);
			pstmt.setString	(2,  doc_no);
			pstmt.setString	(3,  bean.getOver_sjgj());
			pstmt.setString	(4,  bean.getOver_sjgj_dt());
			pstmt.setString	(5,  bean.getOver_sjgj_op());
			pstmt.setString	(6,  bean.getOver_cont());
			pstmt.setString	(7,  bean.getOver_cr());
			
		//	if (jb_time < 2) {
		//	    jb_time = 2;	
		//	}
			
			if (jb_time >= 8) {
				jb_time = 8;
			}
				
			pstmt.setString	(8,  Integer.toString(jb_time));  //인정근로시간
			pstmt.setString	(9,  bean.getJb_time2());
			pstmt.setString	(10, bean.getOver_addr());
			pstmt.setString	(11, bean.getOver_card1_dt());
			pstmt.setInt	(12, bean.getOver_card1_amt());
			pstmt.setString	(13, bean.getOver_cash1_dt());
			pstmt.setInt	(14, bean.getOver_cash1_amt());
			pstmt.setString	(15, bean.getOver_cash1_file());
			pstmt.setInt	(16, bean.getOver_cash1_cr_amt());
			pstmt.setString	(17, bean.getOver_cash1_cr_dt());
			pstmt.setString	(18, bean.getOver_cash1_cr_jpno());
			pstmt.setString	(19, bean.getOver_s_cash1_dt());
			pstmt.setInt	(20, bean.getOver_s_cash1_amt());
			pstmt.setString	(21, bean.getOver_s_cash1_file());
			pstmt.setInt	(22, bean.getOver_s_cash1_cr_amt());
			pstmt.setString	(23, bean.getOver_s_cash1_cr_jpno());
			pstmt.setString	(24, bean.getOver_card2_dt());
			pstmt.setInt	(25, bean.getOver_card2_amt());
			pstmt.setString	(26, bean.getOver_cash2_dt());
			pstmt.setInt	(27, bean.getOver_cash2_amt());
			pstmt.setString	(28, bean.getOver_cash2_file());
			pstmt.setInt	(29, bean.getOver_cash2_cr_amt());
			pstmt.setString	(30, bean.getOver_cash2_cr_dt());
			pstmt.setString	(31, bean.getOver_cash2_cr_jpno());
			pstmt.setString	(32, bean.getOver_s_cash2_dt());
			pstmt.setInt	(33, bean.getOver_s_cash2_amt());
			pstmt.setString	(34, bean.getOver_s_cash2_file());
			pstmt.setInt	(35, bean.getOver_s_cash2_cr_amt());
			pstmt.setString	(36, bean.getOver_s_cash2_cr_jpno());
			pstmt.setString	(37, bean.getOver_card3_dt());
			pstmt.setInt	(38, bean.getOver_card3_amt());
			pstmt.setString	(39, bean.getOver_cash3_dt());
			pstmt.setInt	(40, bean.getOver_cash3_amt());
			pstmt.setString	(41, bean.getOver_cash3_file());
			pstmt.setInt	(42, bean.getOver_cash3_cr_amt());
			pstmt.setString	(43, bean.getOver_cash3_cr_dt());
			pstmt.setString	(44, bean.getOver_cash3_cr_jpno());
			pstmt.setString	(45, bean.getOver_s_cash3_dt());
			pstmt.setInt	(46, bean.getOver_s_cash3_amt());
			pstmt.setString	(47, bean.getOver_s_cash3_file());
			pstmt.setInt	(48, bean.getOver_s_cash3_cr_amt());
			pstmt.setString	(49, bean.getOver_s_cash3_cr_jpno());
			pstmt.setInt	(50, bean.getOver_card_tot());
			pstmt.setInt	(51, bean.getOver_cash_tot());
			pstmt.setInt	(52, bean.getOver_s_cash_tot());
			pstmt.setString	(53, bean.getStart_dt());
			pstmt.setString	(54, bean.getStart_h());
			pstmt.setString	(55, bean.getStart_m());			
			pstmt.setString	(56, bean.getEnd_dt());
			pstmt.setString	(57, bean.getEnd_h());
			pstmt.setString	(58, bean.getEnd_m());
			pstmt.setString (59, bean.getOver_time_year());
			pstmt.setString (60, bean.getOver_time_mon());

			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[OverTimeDatabase:insertOver_time]\n"+e);
			System.out.println("[OverTimeDatabase:insertOver_time]\n"+query_jb);
			System.out.println("[OverTimeDatabase:insertOver_time]\n"+query);
	  		e.printStackTrace();
	  		count = 0;
			conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(rs != null) rs.close();
                if(stmt != null) stmt.close();
				if(rs1 != null) rs1.close();
                if(stmt1 != null) stmt1.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return doc_no;
		}
	}


	
	public Vector Over_Per(String user_id, String doc_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

				query =   " select  b.jb_time, a.user_id, decode( a.br_id, 'S1', '본사', 'B1', '부산','D1','대전','S2','강남','J1','광주','G1','대구','S3','강서','S4','구로','I1','인천','U1','울산' ) AS br_id, a.id, a.user_h_tel, a.user_m_tel, a.user_pos, \n"
				                   + " a.dept_id,  u.nm as dept_nm , a.user_nm, substr(b.reg_dt,1,4)||'-'||substr(b.reg_dt,5,2)||'-'||substr(b.reg_dt,7,2) reg_dt, b.over_cont, b.over_cr, "						
						+ " decode(b.over_sjgj, '1','정채달','2','김광수','3','안보국','4','제인학','5','박영규','6','부', '7','이종준', '8','윤영탁', '9','김은철', 'A','강주원', 'B','김욱', 'C','김우석', 'D', '류선' ) over_sjgj, b.over_sjgj_dt, decode(b.over_sjgj_op,'1','갑자기 발생한 업무','2','당장자와 통화 불능','3','해당 팀장과 통화 불능','4','기타','5','...','6','...')over_sjgj_op, b.over_addr, b.over_card1_dt, b.over_card1_amt, b.over_cash1_dt, b.over_cash1_amt, b.over_cash1_file, b.over_cash1_cr_amt, b.over_cash1_cr_dt, b.over_cash1_cr_jpno, b.over_s_cash1_dt, b.over_s_cash1_amt, b.over_s_cash1_file, b.over_s_cash1_cr_amt, b.over_s_cash1_cr_jpno, "
						+ " b.over_card2_dt, b.over_card2_amt, b.over_cash2_dt, b.over_cash2_amt, b.over_cash2_file, b.over_cash2_cr_amt, b.over_cash2_cr_dt, b.over_cash2_cr_jpno, b.over_s_cash2_dt, b.over_s_cash2_amt, b.over_s_cash2_file, b.over_s_cash2_cr_amt, b.over_s_cash2_cr_jpno, "
						+ " b.over_card3_dt, b.over_card3_amt, b.over_cash3_dt, b.over_cash3_amt, b.over_cash3_file, b.over_cash3_cr_amt, b.over_cash3_cr_dt, b.over_cash3_cr_jpno, b.over_s_cash3_dt, b.over_s_cash3_amt, b.over_s_cash3_file, b.over_s_cash3_cr_amt, b.over_s_cash3_cr_jpno, substr(b.reg_dt, 5, 2) as MON, to_number(substr(b.reg_dt, 7, 2)) as DAY, "
						+ " (b.over_card1_amt + b.over_card2_amt + b.over_card3_amt) as over_card_tot, (b.over_cash1_amt + b.over_cash2_amt + b.over_cash3_amt) as over_cash_tot, (b.over_s_cash1_amt + b.over_s_cash2_amt + b.over_s_cash3_amt) as over_s_cash_tot, b.over_scgy, b.over_scgy_dt, b.over_scgy_pl_dt, b.s_check, b.s_check_dt, b.s_check_id, b.t_check, b.t_check_dt, b.t_check_id, b.s_check1, b.s_check1_dt, b.s_check1_id, substr(b.s_check_dt,1,10) as jc_dt, b.t_check1, b.t_check1_dt, b.t_check1_id, b.t_check2, b.t_check2_dt, b.t_check2_id, b.t_check3, b.t_check3_dt, b.t_check3_id, b.t_check4, b.t_check4_dt, b.t_check4_id, b.doc_no, \n"
						+ " trunc(round(to_number(to_date(b.end_dt||b.end_h||b.end_m,'YYYYMMDDhh24mi')-to_date(b.start_dt||b.start_h||b.start_m,'YYYYMMDDhh24mi'))*24*60)/60) hh, \n"
						+ " trunc(mod(round(to_number(to_date(b.end_dt||b.end_h||b.end_m,'YYYYMMDDhh24mi')-to_date(b.start_dt||b.start_h||b.start_m,'YYYYMMDDhh24mi'))*24*60),60)) mi, \n"
						+ " b.start_dt, b.start_h, b.start_m, b.end_dt, b.end_h, b.end_m,  b.over_time_year, b.over_time_mon , c.user_nm2, c.user_id2, c.user_dt2,c.user_nm7, c.user_id7, c.user_dt7 \n"
						+ " from users a, over_time b, doc_settle c,   ( select c_st, code, nm_cd, nm from code where c_st = '0002' and code <> '0000'  ) u "
						+ " where a.user_id = b.user_id and b.doc_no = c.doc_id and c.DOC_ST in '8'  and a.dept_id = u.code(+) and b.user_id = '"+user_id+"' and b.doc_no = '"+doc_no+"'  ";


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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[OverTimeDatabase:Over_Per]"+e);
			System.out.println("[OverTimeDatabase:Over_Per]"+query);
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
	 *	특근신청 보고 승인
	 */

		public int updScheck(Over_TimeBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";


		query = " update over_time set\n"+
				" s_check = ?, \n"+
//				" over_time_year = ?, \n"+
//				" over_time_mon = ?, \n"+
				" jb_time = ? \n"+
				" where user_id=? and doc_no=?";		

		try 
		{		
			conn.setAutoCommit(false);	
		
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getS_check());
			pstmt.setString(2, bean.getJb_time());
//			pstmt.setInt(3, bean.getOver_time_year());
//			pstmt.setString(4, bean.getOver_time_mon());
			pstmt.setString(3, bean.getUser_id());
			pstmt.setString(4, bean.getDoc_no());

			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[OverTimeDatabase:S_check]\n"+e);
			System.out.println("[OverTimeDatabase:S_check]\n"+query);
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


		

	/**
	 *	조직관리 -> 특근수당 -> 한건 삭제
	 */

public int delTimedel(Over_TimeBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";
		String query_seq = "";


		query = " DELETE  FROM over_time \n"+
				" where user_id=? and doc_no=?";		

		try 
		{	
			conn.setAutoCommit(false);		
		
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getUser_id());
			pstmt.setString(2, bean.getDoc_no());

			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[OverTimeDatabase:Time_del]\n"+e);
			System.out.println("[OverTimeDatabase:Time_del]\n"+query);
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


	/**
	 *	특근신청 최종 승인 하기
	 */

public int updTimeok(Over_TimeBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";
		String query_seq = "";

		query = " update over_time set\n"+
				" t_check = ?, \n"+
//				" t_check_id = ?, \n"+
				" jb_time = ?, \n"+
				" over_time_mon = ? \n"+
//				" t_check_dt = sysdate \n"+
				" where user_id=? and doc_no=?";		

		try 
		{			
		
			conn.setAutoCommit(false);
				
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getT_check());
//			pstmt.setString(2, bean.getT_check_id());
			pstmt.setString(2, bean.getJb_time());
			pstmt.setString(3, bean.getOver_time_mon());
			pstmt.setString(4, bean.getUser_id());
			pstmt.setString(5, bean.getDoc_no());

			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[OverTimeDatabase:Time_ok]\n"+e);
			System.out.println("[OverTimeDatabase:Time_ok]\n"+query);
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
	
	/**
	 *	조직관리 -> 특근수당 -> 엑셀로 전환
	 */

	public Vector Over_List_Excel(String auth_rw, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


				query =   " select a.user_id, decode(a.br_id,'S1','본사','B1','부산','D1','대전','S2','강남','J1','광주','G1','대구','U1','울산','S6','송파','S5','종로','S4','구로','S3','강서','K3','수원','I1','인천')as br_id, a.user_pos, decode(a.dept_id,'0003','총무팀','0001','영업팀','0002','고객지원팀','0004','임원','0005','IT팀','0007','부산지점','0008','대전지점','0009','강남지점','0010','광주지점','0011','대구지점','0012','인천지점','0013','수원지점','0014','강서지점','0015','구로지점','0016','울산지점','0017','광화문지점','0018','송파지점','')as dept_id, a.user_nm, b.doc_no, b.reg_dt, b.over_cont, b.over_cr,\n"
						+ " b.over_sjgj, b.over_sjgj_dt, b.over_sjgj_op, b.over_addr, b.over_card1_dt, b.over_card1_amt, b.over_cash1_dt, b.over_cash1_amt, b.over_cash1_file, b.over_cash1_cr_amt, b.over_cash1_cr_dt, b.over_cash1_cr_jpno, b.over_s_cash1_dt, b.over_s_cash1_amt, b.over_s_cash1_file, b.over_s_cash1_cr_amt, b.over_s_cash1_cr_jpno, "
						+ " b.s_check, b.s_check_dt, b.s_check_id, b.t_check, b.t_check_dt, b.t_check_id, b.s_check1, b.s_check1_dt, b.s_check1_id, b.t_check1, b.t_check1_dt, b.t_check1_id, b.t_check2, b.t_check2_dt, b.t_check2_id, b.t_check3, b.t_check3_dt, b.t_check3_id, b.t_check4, b.t_check4_dt, b.t_check4_id"
						+ " from users a, over_time b \n"
						+ " where a.user_id = b.user_id\n ";

				query += "order by b.reg_dt desc";


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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[OverTimeDatabase:Over_List_Excel]"+e);
			System.out.println("[OverTimeDatabase:Over_List_Excel]"+query);
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
	 *	조직관리 -> 특근수당 -> 엑셀로 전환
	 */

	public Vector Over_Excel_User(String user_id, int st_year, int st_month, int st_day)
	{
		getConnection();

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

query = " select b.user_id, a.user_nm, a.id, "+
				" sum(decode(substr(b.start_dt, 7,2), '01', b.jb_time)) wt01, \n"+
				" sum(decode(substr(b.start_dt, 7,2), '02', b.jb_time)) wt02, \n"+
				" sum(decode(substr(b.start_dt, 7,2), '03', b.jb_time)) wt03, \n"+
				" sum(decode(substr(b.start_dt, 7,2), '04', b.jb_time)) wt04, \n"+
				" sum(decode(substr(b.start_dt, 7,2), '05', b.jb_time)) wt05, \n"+
				" sum(decode(substr(b.start_dt, 7,2), '06', b.jb_time)) wt06, \n"+
				" sum(decode(substr(b.start_dt, 7,2), '07', b.jb_time)) wt07, \n"+
				" sum(decode(substr(b.start_dt, 7,2), '08', b.jb_time)) wt08, \n"+
				" sum(decode(substr(b.start_dt, 7,2), '09', b.jb_time)) wt09, \n"+
				" sum(decode(substr(b.start_dt, 7,2), '10', b.jb_time)) wt10, \n"+
				" sum(decode(substr(b.start_dt, 7,2), '11', b.jb_time)) wt11, \n"+
				" sum(decode(substr(b.start_dt, 7,2), '12', b.jb_time)) wt12, \n"+
				" sum(decode(substr(b.start_dt, 7,2), '13', b.jb_time)) wt13, \n"+
				" sum(decode(substr(b.start_dt, 7,2), '14', b.jb_time)) wt14, \n"+
				" sum(decode(substr(b.start_dt, 7,2), '15', b.jb_time)) wt15, \n"+
				" sum(decode(substr(b.start_dt, 7,2), '16', b.jb_time)) wt16, \n"+
				" sum(decode(substr(b.start_dt, 7,2), '17', b.jb_time)) wt17, \n"+
				" sum(decode(substr(b.start_dt, 7,2), '18', b.jb_time)) wt18, \n"+
				" sum(decode(substr(b.start_dt, 7,2), '19', b.jb_time)) wt19, \n"+
				" sum(decode(substr(b.start_dt, 7,2), '20', b.jb_time)) wt20, \n"+
				" sum(decode(substr(b.start_dt, 7,2), '21', b.jb_time)) wt21, \n"+
				" sum(decode(substr(b.start_dt, 7,2), '22', b.jb_time)) wt22, \n"+
				" sum(decode(substr(b.start_dt, 7,2), '23', b.jb_time)) wt23, \n"+
				" sum(decode(substr(b.start_dt, 7,2), '24', b.jb_time)) wt24, \n"+
				" sum(decode(substr(b.start_dt, 7,2), '25', b.jb_time)) wt25, \n"+
				" sum(decode(substr(b.start_dt, 7,2), '26', b.jb_time)) wt26, \n"+
				" sum(decode(substr(b.start_dt, 7,2), '27', b.jb_time)) wt27, \n"+
				" sum(decode(substr(b.start_dt, 7,2), '28', b.jb_time)) wt28, \n"+
				" sum(decode(substr(b.start_dt, 7,2), '29', b.jb_time)) wt29, \n"+
				" sum(decode(substr(b.start_dt, 7,2), '30', b.jb_time)) wt30, \n"+
				" sum(decode(substr(b.start_dt, 7,2), '31', b.jb_time)) wt31 \n"+
				" from over_time b, users a \n"+
				"where a.user_id = b.user_id and b.t_check is not null and to_number(b.over_time_mon) = '"+st_month+"' and to_number(substr(b.start_dt, 1,4)) = '"+st_year+"'  ";

query += " group by b.user_id, a.user_nm, a.id order by b.user_id, a.user_nm, a.id";



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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[OverTimeDatabase:Over_Excel_User]"+e);
			System.out.println("[OverTimeDatabase:Over_Excel_User]"+query);
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
	 *	인정근로시간 수정
	 */

	public int UpdateJb_time(Over_TimeBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";


		query = " update over_time set\n"+
				" jb_time = ? \n"+
				" where user_id=? and doc_no=?";		

		try 
		{			
		conn.setAutoCommit(false);	
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getJb_time());
			pstmt.setString(2, bean.getUser_id());
			pstmt.setString(3, bean.getDoc_no());

			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[OverTimeDatabase:UpdateJb_time]\n"+e);
			System.out.println("[OverTimeDatabase:UpdateJb_time]\n"+query);
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


	/**
	 *	인정근로시간 수정
	 */

	public int UpdateOver_time_mon(Over_TimeBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";


		query = " update over_time set\n"+
				" over_time_year = ?, \n"+
				" over_time_mon = ? \n"+
				" where user_id=? and doc_no=?";		

		try 
		{			
		conn.setAutoCommit(false);	
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getOver_time_year());
			pstmt.setString(2, bean.getOver_time_mon());
			pstmt.setString(3, bean.getUser_id());
			pstmt.setString(4, bean.getDoc_no());

			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[OverTimeDatabase:UpdateOver_time_mon]\n"+e);
			System.out.println("[OverTimeDatabase:UpdateOver_time_mon]\n"+query);
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

	/**
	 *	특근 중복 등록 check
	 */
	public int getCntOver_time(String user_id, String start_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int cnt = 0;
		String query = "";
		ResultSet rs = null;
		
		query=" select count(0) from over_time where user_id = '"+user_id+"' and start_dt = '"+start_dt+"'";
		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();   
			
			if(rs.next())
			{				
				cnt	= rs.getInt(1);
			}		
			rs.close();
			pstmt.close();
    			
		} catch (SQLException e) {
			System.out.println("[OverTimeDatabase:getCntOver_time]"+e);
			System.out.println("[OverTimeDatabase:getCntOver_time]"+query);
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
	 *	특근등록 문서처리 삭제 - 
	 */
	 
	public boolean deleteDocSettleOverTime(String doc_no)
	{
		getConnection();
		boolean flag = true;
		String query = "delete from doc_settle "+
						" where doc_st = '8' and doc_id = ?  ";  //2
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(true);

			pstmt = conn.prepareStatement(query);
					
			pstmt.setString(1, doc_no);
					
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
	
	/** 2009-02-09
	 *	사용자 리스트 조회 - 특근 수당 신청시 메신져로 메세지 받아 볼 담당자 찾기
	 *  mode - CLIENT : 고객사용자, EMP : 사원사용자, BUS_EMP : 영업담당자, MNG_EMP : 관리담당자
	 */


public Vector getUserList_over_time(String dept, String br_id, String mode, String use_yn) 
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();


		String query = "select USER_ID, USER_NM, ID, DEPT_ID from USERS where user_id is not null";

        if(!use_yn.equals(""))				query += " and use_yn = '"+ use_yn +"' ";
        if(!dept.equals(""))				query += " and DEPT_ID = '"+ dept +"' ";
        if(!br_id.equals(""))				query += " and BR_ID = '"+ br_id +"' ";
		if(mode.equals("CLIENT"))			query += " and DEPT_ID is null ";
		else if(mode.equals("EMP"))			query += " and DEPT_ID is not null ";
		else if(mode.equals("BUS_EMP"))		query += " and DEPT_ID = '0001' ";
		else if(mode.equals("MNG_EMP"))		query += " and DEPT_ID = '0002' ";
		else if(mode.equals("GEN_EMP"))		query += " and DEPT_ID = '0003' ";
		else if(mode.equals("BUS_MNG_EMP")) query += " and DEPT_ID in ('0001','0002') ";
		else if(mode.equals("HEAD"))		query += " and USER_POS not in ('인턴사원','사원','대리','대표이사','주주','외부업체') ";
		else if(mode.equals("HEAD2"))		query += " and USER_ID in ('000003','000004','000005','000026','000052','000053') ";
		else if(mode.equals("BODY"))		query += " and USER_POS in ('사원','대리','과장') ";

		else if(mode.equals("BODY1"))		query += " and USER_ID in ('000004') "; //000004
		else if(mode.equals("BODY2"))		query += " and USER_ID in ('000005') "; //000005
		else if(mode.equals("BODY3"))		query += " and USER_ID in ('000026') "; //000026
		else if(mode.equals("BODY4"))		query += " and USER_ID in ('000053') "; //000053
		else if(mode.equals("BODY5"))		query += " and USER_ID in ('000052') "; //000052
		else if(mode.equals("BODY6"))		query += " and USER_ID in ('000003') "; //000003
		else if(mode.equals("BODY7"))		query += " and USER_ID in ('000063') "; //000063
		else if(mode.equals("BODY10"))		query += " and USER_ID in ('000020') "; //000063
		else if(mode.equals("BODY11"))		query += " and USER_ID in ('000054') "; //000063
		

		else if(mode.equals("BUS_ID"))		query += " and USER_ID in (select BUS_ID from cont group by BUS_ID) ";
		else if(mode.equals("BUS_ID2"))		query += " and USER_ID in (select BUS_ID2 from cont group by BUS_ID2) ";
		else if(mode.equals("MNG_ID"))		query += " and USER_ID in (select MNG_ID from cont group by MNG_ID) ";

		query += " ORDER BY dept_id, decode(user_pos,'사원',1,0) ";
		


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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[OverTimeDatabase:getUserList_over_time]"+e);
			System.out.println("[OverTimeDatabase:getUserList_over_time]"+query);
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