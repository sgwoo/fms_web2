package acar.stat_bus;

import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.admin.*;

public class CampaignDatabase
{
	private Connection conn = null;
	public static CampaignDatabase db;
	
	public static CampaignDatabase getInstance()
	{
		if(CampaignDatabase.db == null)
			CampaignDatabase.db = new CampaignDatabase();
		return CampaignDatabase.db;
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
	    	System.out.println(" I can't get a connection........");
	    }
	}
	
	private void closeConnection()
	{
		if ( conn != null ) 
		{
			connMgr.freeConnection("acar", conn);
		}		
	}
	


	//변수관리------------------------------------------------------------------------------------------


	/**
	 *	변수조회
	 */
	public Hashtable getCampaignVar(){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();

		String query =  " SELECT  *  FROM campaign "+
						" WHERE (year||tm) in (select max(year||tm) from campaign)";

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
			System.out.println("[CampaignDatabase:getCampaignVar()]"+e);
			System.out.println("[CampaignDatabase:getCampaignVar()]"+query);
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
	 *	변수조회
	 */
	public Hashtable getCampaignVar(String year, String tm){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();

		String query =  " SELECT  *  FROM campaign "+
						" WHERE year = ? AND tm = ?";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, year);
			pstmt.setString(2, tm);
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
			System.out.println("[CampaignDatabase:getCampaignVar(String year, String tm)]"+e);
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
	 *	변수조회
	 */
	public Hashtable getCampaignVar(String year, String tm, String loan_st){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();

		String query =  " SELECT  *  FROM campaign_var "+
						" WHERE year = ? AND tm = ? AND loan_st = ?";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, year);
			pstmt.setString(2, tm);
			pstmt.setString(3, loan_st);
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
			System.out.println("[CampaignDatabase:getCampaignVar(String year, String tm, String loan_st)]"+e);
			System.out.println("[CampaignDatabase:getCampaignVar(String year, String tm, String loan_st)]"+query);
			System.out.println("year="+year);
			System.out.println("tm="+tm);
			System.out.println("loan_st="+loan_st);
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
	*	변수수정
	*/
	public int updateVar(String year, String tm, String cs_dt, String ce_dt, String bs_dt, String be_dt, String bs_dt2, String be_dt2, int amt, int bus_up_per, int bus_down_per, int mng_up_per, int mng_down_per, int bus_amt_per, int mng_amt_per, int new_bus_up_per, int new_bus_down_per, int new_bus_amt_per, int cnt1, int mon, String cnt2, float cmp_discnt_per, int car_amt, int max_dalsung, int bus_ga, int mng_ga, int bus_new_ga, String enter_dt, String ns_dt1, String ns_dt2, String ns_dt3, String ne_dt1, String ne_dt2, String ne_dt3, int nm_cnt1, int nm_cnt2, int nm_cnt3, int nb_cnt1, int nb_cnt2, int nb_cnt3){

		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = "UPDATE campaign "+
			" SET cs_dt=?, ce_dt=?, bs_dt=?, be_dt=? "+
			"	 ,amt=?, bus_up_per=?, bus_down_per=? "+
			"    ,mng_up_per=?, mng_down_per=?, bus_amt_per=?, mng_amt_per=? "+
			"	 ,new_bus_up_per=?, new_bus_down_per=?, new_bus_amt_per=? "+
			"	 ,cnt1=?, mon=?, cnt2=?, cmp_discnt_per=?, car_amt=? "+
			"	 , bs_dt2=?, be_dt2=?, max_dalsung=? "+
			"	 , bus_ga=?, mng_ga=?, bus_new_ga=?, enter_dt=? "+
			"	 , ns_dt1=?, ns_dt2=?, ns_dt3=?, ne_dt1=?, ne_dt2=?, ne_dt3=?, nm_cnt1=?, nm_cnt2=?, nm_cnt3=?, nb_cnt1=?, nb_cnt2=?, nb_cnt3=?"+
			" WHERE year=? and tm=? ";

		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, cs_dt);
			pstmt.setString(2, ce_dt);
			pstmt.setString(3, bs_dt);
			pstmt.setString(4, be_dt);
			pstmt.setInt(5, amt);
			pstmt.setInt(6, bus_up_per);
			pstmt.setInt(7, bus_down_per);
			pstmt.setInt(8, mng_up_per);
			pstmt.setInt(9, mng_down_per);
			pstmt.setInt(10, bus_amt_per);
			pstmt.setInt(11, mng_amt_per);
			pstmt.setInt(12, new_bus_up_per);
			pstmt.setInt(13, new_bus_down_per);
			pstmt.setInt(14, new_bus_amt_per);
			pstmt.setInt(15, cnt1);
			pstmt.setInt(16, mon);
			pstmt.setString(17, cnt2);
			pstmt.setFloat(18, cmp_discnt_per);
			pstmt.setInt(19, car_amt);
			pstmt.setString(20, bs_dt2);
			pstmt.setString(21, be_dt2);
			pstmt.setInt(22, max_dalsung);
			pstmt.setInt(23, bus_ga);
			pstmt.setInt(24, mng_ga);
			pstmt.setInt(25, bus_new_ga);
			pstmt.setString(26, enter_dt);
			pstmt.setString(27, ns_dt1);
			pstmt.setString(28, ns_dt2);
			pstmt.setString(29, ns_dt3);
			pstmt.setString(30, ne_dt1);
			pstmt.setString(31, ne_dt2);
			pstmt.setString(32, ne_dt3);
			pstmt.setInt   (33, nm_cnt1);
			pstmt.setInt   (34, nm_cnt2);
			pstmt.setInt   (35, nm_cnt3);
			pstmt.setInt   (36, nb_cnt1);
			pstmt.setInt   (37, nb_cnt2);
			pstmt.setInt   (38, nb_cnt3);
			pstmt.setString(39, year);
			pstmt.setString(40, tm);

			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		}catch(SQLException e){
			System.out.println("[CampaignDatabase:updateVar]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return result;
		}
	}

	/**
	*	변수수정
	*/
	public int updateVar(String year, String tm, String cs_dt, String ce_dt, String bs_dt, String be_dt, String bs_dt2, String be_dt2, int amt, int bus_up_per, int bus_down_per, int mng_up_per, int mng_down_per, int bus_amt_per, int mng_amt_per, int new_bus_up_per, int new_bus_down_per, int new_bus_amt_per, int cnt1, int mon, String cnt2, float cmp_discnt_per, int car_amt, int max_dalsung, int bus_ga, int mng_ga, int bus_new_ga, String enter_dt, String ns_dt1, String ns_dt2, String ns_dt3, String ns_dt4, String ne_dt1, String ne_dt2, String ne_dt3, String ne_dt4, int nm_cnt1, int nm_cnt2, int nm_cnt3, int nm_cnt4, int nb_cnt1, int nb_cnt2, int nb_cnt3, int nb_cnt4){

		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = "UPDATE campaign "+
			" SET cs_dt=?, ce_dt=?, bs_dt=?, be_dt=? "+
			"	 ,amt=?, bus_up_per=?, bus_down_per=? "+
			"    ,mng_up_per=?, mng_down_per=?, bus_amt_per=?, mng_amt_per=? "+
			"	 ,new_bus_up_per=?, new_bus_down_per=?, new_bus_amt_per=? "+
			"	 ,cnt1=?, mon=?, cnt2=?, cmp_discnt_per=?, car_amt=? "+
			"	 , bs_dt2=?, be_dt2=?, max_dalsung=? "+
			"	 , bus_ga=?, mng_ga=?, bus_new_ga=?, enter_dt=? "+
			"	 , ns_dt1=?, ns_dt2=?, ns_dt3=?, ne_dt1=?, ne_dt2=?, ne_dt3=?, nm_cnt1=?, nm_cnt2=?, nm_cnt3=?, nb_cnt1=?, nb_cnt2=?, nb_cnt3=?"+
			"    , ns_dt4=?, ne_dt4=?, nm_cnt4=?, nb_cnt4=?"+
			" WHERE year=? and tm=? ";

		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, cs_dt);
			pstmt.setString(2, ce_dt);
			pstmt.setString(3, bs_dt);
			pstmt.setString(4, be_dt);
			pstmt.setInt(5, amt);
			pstmt.setInt(6, bus_up_per);
			pstmt.setInt(7, bus_down_per);
			pstmt.setInt(8, mng_up_per);
			pstmt.setInt(9, mng_down_per);
			pstmt.setInt(10, bus_amt_per);
			pstmt.setInt(11, mng_amt_per);
			pstmt.setInt(12, new_bus_up_per);
			pstmt.setInt(13, new_bus_down_per);
			pstmt.setInt(14, new_bus_amt_per);
			pstmt.setInt(15, cnt1);
			pstmt.setInt(16, mon);
			pstmt.setString(17, cnt2);
			pstmt.setFloat(18, cmp_discnt_per);
			pstmt.setInt(19, car_amt);
			pstmt.setString(20, bs_dt2);
			pstmt.setString(21, be_dt2);
			pstmt.setInt(22, max_dalsung);
			pstmt.setInt(23, bus_ga);
			pstmt.setInt(24, mng_ga);
			pstmt.setInt(25, bus_new_ga);
			pstmt.setString(26, enter_dt);
			pstmt.setString(27, ns_dt1);
			pstmt.setString(28, ns_dt2);
			pstmt.setString(29, ns_dt3);
			pstmt.setString(30, ne_dt1);
			pstmt.setString(31, ne_dt2);
			pstmt.setString(32, ne_dt3);
			pstmt.setInt   (33, nm_cnt1);
			pstmt.setInt   (34, nm_cnt2);
			pstmt.setInt   (35, nm_cnt3);
			pstmt.setInt   (36, nb_cnt1);
			pstmt.setInt   (37, nb_cnt2);
			pstmt.setInt   (38, nb_cnt3);
			pstmt.setString(39, ns_dt4);
			pstmt.setString(40, ne_dt4);
			pstmt.setInt   (41, nm_cnt4);
			pstmt.setInt   (42, nb_cnt4);
			pstmt.setString(43, year);
			pstmt.setString(44, tm);

			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		}catch(SQLException e){
			System.out.println("[CampaignDatabase:updateVar]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return result;
		}
	}

	/**
	*	변수수정
	*/
	public int updateVar(String year, String tm, String cs_dt, String ce_dt, String bs_dt, String be_dt, String bs_dt2, String be_dt2, int amt, int bus_up_per, int bus_down_per, int mng_up_per, int mng_down_per, int bus_amt_per, int mng_amt_per, int new_bus_up_per, int new_bus_down_per, int new_bus_amt_per, int cnt1, int mon, String cnt2, float cmp_discnt_per, int car_amt, int max_dalsung, int bus_ga, int mng_ga, int bus_new_ga, String enter_dt, String ns_dt1, String ns_dt2, String ns_dt3, String ns_dt4, String ne_dt1, String ne_dt2, String ne_dt3, String ne_dt4, int nm_cnt1, int nm_cnt2, int nm_cnt3, int nm_cnt4, int nb_cnt1, int nb_cnt2, int nb_cnt3, int nb_cnt4, int cnt_per, int cost_per){

		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = "UPDATE campaign "+
			" SET cs_dt=?, ce_dt=?, bs_dt=?, be_dt=? "+
			"	 ,amt=?, bus_up_per=?, bus_down_per=? "+
			"    ,mng_up_per=?, mng_down_per=?, bus_amt_per=?, mng_amt_per=? "+
			"	 ,new_bus_up_per=?, new_bus_down_per=?, new_bus_amt_per=? "+
			"	 ,cnt1=?, mon=?, cnt2=?, cmp_discnt_per=?, car_amt=? "+
			"	 , bs_dt2=?, be_dt2=?, max_dalsung=? "+
			"	 , bus_ga=?, mng_ga=?, bus_new_ga=?, enter_dt=? "+
			"	 , ns_dt1=?, ns_dt2=?, ns_dt3=?, ne_dt1=?, ne_dt2=?, ne_dt3=?, nm_cnt1=?, nm_cnt2=?, nm_cnt3=?, nb_cnt1=?, nb_cnt2=?, nb_cnt3=?"+
			"    , ns_dt4=?, ne_dt4=?, nm_cnt4=?, nb_cnt4=?, cnt_per=?, cost_per=?"+
			" WHERE year=? and tm=? ";

		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, cs_dt);
			pstmt.setString(2, ce_dt);
			pstmt.setString(3, bs_dt);
			pstmt.setString(4, be_dt);
			pstmt.setInt(5, amt);
			pstmt.setInt(6, bus_up_per);
			pstmt.setInt(7, bus_down_per);
			pstmt.setInt(8, mng_up_per);
			pstmt.setInt(9, mng_down_per);
			pstmt.setInt(10, bus_amt_per);
			pstmt.setInt(11, mng_amt_per);
			pstmt.setInt(12, new_bus_up_per);
			pstmt.setInt(13, new_bus_down_per);
			pstmt.setInt(14, new_bus_amt_per);
			pstmt.setInt(15, cnt1);
			pstmt.setInt(16, mon);
			pstmt.setString(17, cnt2);
			pstmt.setFloat(18, cmp_discnt_per);
			pstmt.setInt(19, car_amt);
			pstmt.setString(20, bs_dt2);
			pstmt.setString(21, be_dt2);
			pstmt.setInt(22, max_dalsung);
			pstmt.setInt(23, bus_ga);
			pstmt.setInt(24, mng_ga);
			pstmt.setInt(25, bus_new_ga);
			pstmt.setString(26, enter_dt);
			pstmt.setString(27, ns_dt1);
			pstmt.setString(28, ns_dt2);
			pstmt.setString(29, ns_dt3);
			pstmt.setString(30, ne_dt1);
			pstmt.setString(31, ne_dt2);
			pstmt.setString(32, ne_dt3);
			pstmt.setInt   (33, nm_cnt1);
			pstmt.setInt   (34, nm_cnt2);
			pstmt.setInt   (35, nm_cnt3);
			pstmt.setInt   (36, nb_cnt1);
			pstmt.setInt   (37, nb_cnt2);
			pstmt.setInt   (38, nb_cnt3);
			pstmt.setString(39, ns_dt4);
			pstmt.setString(40, ne_dt4);
			pstmt.setInt   (41, nm_cnt4);
			pstmt.setInt   (42, nb_cnt4);
			pstmt.setInt   (43, cnt_per);
			pstmt.setInt   (44, cost_per);
			pstmt.setString(45, year);
			pstmt.setString(46, tm);

			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		}catch(SQLException e){
			System.out.println("[CampaignDatabase:updateVar]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return result;
		}
	}
	
	/**
	*	변수수정 - 1군(관리)
	*/
	
	public int updateVar2(String year, String tm, String cs_dt, String ce_dt, String bs_dt2, String be_dt2, int amt, int mng_up_per, int mng_down_per, int mng_amt_per, int new_bus_up_per, int new_bus_down_per, int new_bus_amt_per, int cnt1, int mon, String cnt2, float cmp_discnt_per, int car_amt2, int max_dalsung2,  int mng_ga, int mng_new_ga, String enter_dt, String ns_dt1, String ns_dt2, String ns_dt3, String ns_dt4, String ne_dt1, String ne_dt2, String ne_dt3, String ne_dt4, int nm_cnt1, int nm_cnt2, int nm_cnt3, int nm_cnt4, int cnt_per2, int cost_per2){

		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = " UPDATE campaign SET "+
							    " cs_dt=?, ce_dt=?, amt=?, mng_up_per=?, mng_down_per=?,  mng_amt_per=? "+  //6
								", new_bus_up_per=?, new_bus_down_per=?, new_bus_amt_per=? "+  //3
								", cnt1=?, mon=?, cnt2=?, cmp_discnt_per=?, car_amt2=? "+  //5
								", bs_dt2=?, be_dt2=?, max_dalsung2=? , mng_ga=?, mng_new_ga=?, enter_dt=? "+ //6
								", ns_dt1=?, ns_dt2=?, ns_dt3=?, ne_dt1=?, ne_dt2=?, ne_dt3=?, nm_cnt1=?, nm_cnt2=?, nm_cnt3=? "+  //9
								", ns_dt4=?, ne_dt4=?, nm_cnt4=?, cnt_per2=?, cost_per2=?"+  //5
						" WHERE year=? and tm=? ";
			
		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, cs_dt);
			pstmt.setString(2, ce_dt);
			pstmt.setInt   (3, amt);		
			pstmt.setInt   (4, mng_up_per);
			pstmt.setInt   (5, mng_down_per);		
			pstmt.setInt   (6, mng_amt_per);
			
			pstmt.setInt   (7, new_bus_up_per);
			pstmt.setInt   (8, new_bus_down_per);
			pstmt.setInt   (9, new_bus_amt_per);
			
			
			pstmt.setInt   (10, cnt1);
			pstmt.setInt   (11, mon);
			pstmt.setString(12, cnt2);
			pstmt.setFloat (13, cmp_discnt_per);
			pstmt.setInt   (14, car_amt2);
			
			pstmt.setString(15, bs_dt2);
			pstmt.setString(16, be_dt2);
			pstmt.setInt   (17, max_dalsung2);
			pstmt.setInt   (18, mng_ga);
			pstmt.setInt   (19, mng_new_ga);
			pstmt.setString(20, enter_dt);
			
			pstmt.setString(21, ns_dt1);
			pstmt.setString(22, ns_dt2);
			pstmt.setString(23, ns_dt3);
			pstmt.setString(24, ne_dt1);
			pstmt.setString(25, ne_dt2);
			pstmt.setString(26, ne_dt3);
			pstmt.setInt   (27, nm_cnt1);
			pstmt.setInt   (28, nm_cnt2);
			pstmt.setInt   (29, nm_cnt3);
			
			pstmt.setString(30, ns_dt4);
			pstmt.setString(31, ne_dt4);
			pstmt.setInt   (32, nm_cnt4);		
			pstmt.setInt   (33, cnt_per2);
			pstmt.setInt   (34, cost_per2);
			
			pstmt.setString(35, year);
			pstmt.setString(36, tm);

			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		}catch(SQLException e){
			System.out.println("[CampaignDatabase:updateVar2]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return result;
		}
	}
	
	/**
	*	변수수정 - 1군(관리)
	*/
	
	public int updateVar2(String year, String tm, String cs_dt, String ce_dt, String bs_dt2, String be_dt2, int amt, int mng_up_per, int mng_down_per, int mng_amt_per, int new_bus_up_per, int new_bus_down_per, int new_bus_amt_per, int cnt1, int mon, String cnt2, float cmp_discnt_per, int car_amt2, int max_dalsung2,  int mng_ga, int mng_new_ga, String enter_dt, String ns_dt1, String ns_dt2, String ns_dt3, String ns_dt4, String ne_dt1, String ne_dt2, String ne_dt3, String ne_dt4, int nm_cnt1, int nm_cnt2, int nm_cnt3, int nm_cnt4, int cnt_per2, int cost_per2, String base_end_dt1, String base_end_dt2, int mng_f_per){

		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = " UPDATE campaign SET "+
							    " cs_dt=?, ce_dt=?, amt=?, mng_up_per=?, mng_down_per=?,  mng_amt_per=? "+  //6
								", new_bus_up_per=?, new_bus_down_per=?, new_bus_amt_per=? "+  //3
								", cnt1=?, mon=?, cnt2=?, cmp_discnt_per=?, car_amt2=? "+  //5
								", bs_dt2=?, be_dt2=?, max_dalsung2=? , mng_ga=?, mng_new_ga=?, enter_dt=? "+ //6
								", ns_dt1=?, ns_dt2=?, ns_dt3=?, ne_dt1=?, ne_dt2=?, ne_dt3=?, nm_cnt1=?, nm_cnt2=?, nm_cnt3=? "+  //9
								", ns_dt4=?, ne_dt4=?, nm_cnt4=?, cnt_per2=?, cost_per2=?, base_end_dt1=?, base_end_dt2=?, mng_f_per=? "+  //5
						" WHERE year=? and tm=? ";
			
		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, cs_dt);
			pstmt.setString(2, ce_dt);
			pstmt.setInt   (3, amt);		
			pstmt.setInt   (4, mng_up_per);
			pstmt.setInt   (5, mng_down_per);		
			pstmt.setInt   (6, mng_amt_per);
			
			pstmt.setInt   (7, new_bus_up_per);
			pstmt.setInt   (8, new_bus_down_per);
			pstmt.setInt   (9, new_bus_amt_per);
			
			
			pstmt.setInt   (10, cnt1);
			pstmt.setInt   (11, mon);
			pstmt.setString(12, cnt2);
			pstmt.setFloat (13, cmp_discnt_per);
			pstmt.setInt   (14, car_amt2);
			
			pstmt.setString(15, bs_dt2);
			pstmt.setString(16, be_dt2);
			pstmt.setInt   (17, max_dalsung2);
			pstmt.setInt   (18, mng_ga);
			pstmt.setInt   (19, mng_new_ga);
			pstmt.setString(20, enter_dt);
			
			pstmt.setString(21, ns_dt1);
			pstmt.setString(22, ns_dt2);
			pstmt.setString(23, ns_dt3);
			pstmt.setString(24, ne_dt1);
			pstmt.setString(25, ne_dt2);
			pstmt.setString(26, ne_dt3);
			pstmt.setInt   (27, nm_cnt1);
			pstmt.setInt   (28, nm_cnt2);
			pstmt.setInt   (29, nm_cnt3);
			
			pstmt.setString(30, ns_dt4);
			pstmt.setString(31, ne_dt4);
			pstmt.setInt   (32, nm_cnt4);		
			pstmt.setInt   (33, cnt_per2);
			pstmt.setInt   (34, cost_per2);
			
			pstmt.setString(35, base_end_dt1);
			pstmt.setString(36, base_end_dt2);

			pstmt.setInt   (37, mng_f_per);

			pstmt.setString(38, year);
			pstmt.setString(39, tm);

			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		}catch(SQLException e){
			System.out.println("[CampaignDatabase:updateVar2]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return result;
		}
	}



	/**
	*	변수수정 - 2군
	*/
	
	public int updateVar3(String year, String tm, String cs_dt, String ce_dt, String bs_dt, String be_dt, int amt, int bus_up_per, int bus_down_per,  int bus_amt_per,  int new_bus_up_per, int new_bus_down_per, int new_bus_amt_per, int cnt1, int mon, String cnt2, float cmp_discnt_per, int car_amt, int max_dalsung, int bus_ga,  int bus_new_ga, String enter_dt, String ns_dt1, String ns_dt2, String ns_dt3, String ns_dt4, String ne_dt1, String ne_dt2, String ne_dt3, String ne_dt4, int nb_cnt1, int nb_cnt2, int nb_cnt3, int nb_cnt4, int cnt_per, int cost_per){

		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query =  "UPDATE campaign SET "+
						"      cs_dt=?, ce_dt=?, bs_dt=?, be_dt=? "+  //4
						"	 , amt=?, bus_up_per=?, bus_down_per=? "+  //3
						"    , bus_amt_per=?, new_bus_up_per=?, new_bus_down_per=?, new_bus_amt_per=? "+  //4
						"	 , cnt1=?, mon=?, cnt2=?, cmp_discnt_per=?, car_amt=? , max_dalsung=? "+  //6
						"	 , bus_ga=?, bus_new_ga=?, enter_dt=? "+  //3
						"	 , ns_dt1=?, ns_dt2=?, ns_dt3=?, ne_dt1=?, ne_dt2=?, ne_dt3=?, nb_cnt1=?, nb_cnt2=?, nb_cnt3=?"+  //9
						"    , ns_dt4=?, ne_dt4=?, nb_cnt4=?, cnt_per=?, cost_per=? "+ //5
						" WHERE year=? and tm=? ";  //2

		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, cs_dt);
			pstmt.setString(2, ce_dt);
			pstmt.setString(3, bs_dt);
			pstmt.setString(4, be_dt);
			
			pstmt.setInt   (5, amt);
			pstmt.setInt   (6, bus_up_per);
			pstmt.setInt   (7, bus_down_per);
			
			pstmt.setInt   (8, bus_amt_per);
			pstmt.setInt   (9, new_bus_up_per);
			pstmt.setInt   (10, new_bus_down_per);
			pstmt.setInt   (11, new_bus_amt_per);
			
			pstmt.setInt   (12, cnt1);
			pstmt.setInt   (13, mon);
			pstmt.setString(14, cnt2);
			pstmt.setFloat (15, cmp_discnt_per);
			pstmt.setInt   (16, car_amt);
			pstmt.setInt   (17, max_dalsung);
			
			pstmt.setInt   (18, bus_ga);
			pstmt.setInt   (19, bus_new_ga);
			pstmt.setString(20, enter_dt);
			
			pstmt.setString(21, ns_dt1);
			pstmt.setString(22, ns_dt2);
			pstmt.setString(23, ns_dt3);
			pstmt.setString(24, ne_dt1);
			pstmt.setString(25, ne_dt2);
			pstmt.setString(26, ne_dt3);
			pstmt.setInt   (27, nb_cnt1);
			pstmt.setInt   (28, nb_cnt2);
			pstmt.setInt   (29, nb_cnt3);
			
			pstmt.setString(30, ns_dt4);
			pstmt.setString(31, ne_dt4);
			pstmt.setInt   (32, nb_cnt4);
			pstmt.setInt   (33, cnt_per);
			pstmt.setInt   (34, cost_per);
			
			pstmt.setString(35, year);
			pstmt.setString(36, tm);

			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		}catch(SQLException e){
			System.out.println("[CampaignDatabase:updateVar3]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return result;
		}
	}
	
	/**
	*	변수수정 - 2군
	*/
	
	public int updateVar3(String year, String tm, String cs_dt, String ce_dt, String bs_dt, String be_dt, int amt, int bus_up_per, int bus_down_per,  int bus_amt_per,  int new_bus_up_per, int new_bus_down_per, int new_bus_amt_per, int cnt1, int mon, String cnt2, float cmp_discnt_per, int car_amt, int max_dalsung, int bus_ga,  int bus_new_ga, String enter_dt, String ns_dt1, String ns_dt2, String ns_dt3, String ns_dt4, String ne_dt1, String ne_dt2, String ne_dt3, String ne_dt4, int nb_cnt1, int nb_cnt2, int nb_cnt3, int nb_cnt4, int cnt_per, int cost_per, String base_end_dt1, String base_end_dt2, int bus_f_per){

		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query =  "UPDATE campaign SET "+
						"      cs_dt=?, ce_dt=?, bs_dt=?, be_dt=? "+  //4
						"	 , amt=?, bus_up_per=?, bus_down_per=? "+  //3
						"    , bus_amt_per=?, new_bus_up_per=?, new_bus_down_per=?, new_bus_amt_per=? "+  //4
						"	 , cnt1=?, mon=?, cnt2=?, cmp_discnt_per=?, car_amt=? , max_dalsung=? "+  //6
						"	 , bus_ga=?, bus_new_ga=?, enter_dt=? "+  //3
						"	 , ns_dt1=?, ns_dt2=?, ns_dt3=?, ne_dt1=?, ne_dt2=?, ne_dt3=?, nb_cnt1=?, nb_cnt2=?, nb_cnt3=?"+  //9
						"    , ns_dt4=?, ne_dt4=?, nb_cnt4=?, cnt_per=?, cost_per=?, base_end_dt1=?, base_end_dt2=?, bus_f_per=? "+ //5
						" WHERE year=? and tm=? ";  //2

		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, cs_dt);
			pstmt.setString(2, ce_dt);
			pstmt.setString(3, bs_dt);
			pstmt.setString(4, be_dt);
			
			pstmt.setInt   (5, amt);
			pstmt.setInt   (6, bus_up_per);
			pstmt.setInt   (7, bus_down_per);
			
			pstmt.setInt   (8, bus_amt_per);
			pstmt.setInt   (9, new_bus_up_per);
			pstmt.setInt   (10, new_bus_down_per);
			pstmt.setInt   (11, new_bus_amt_per);
			
			pstmt.setInt   (12, cnt1);
			pstmt.setInt   (13, mon);
			pstmt.setString(14, cnt2);
			pstmt.setFloat (15, cmp_discnt_per);
			pstmt.setInt   (16, car_amt);
			pstmt.setInt   (17, max_dalsung);
			
			pstmt.setInt   (18, bus_ga);
			pstmt.setInt   (19, bus_new_ga);
			pstmt.setString(20, enter_dt);
			
			pstmt.setString(21, ns_dt1);
			pstmt.setString(22, ns_dt2);
			pstmt.setString(23, ns_dt3);
			pstmt.setString(24, ne_dt1);
			pstmt.setString(25, ne_dt2);
			pstmt.setString(26, ne_dt3);
			pstmt.setInt   (27, nb_cnt1);
			pstmt.setInt   (28, nb_cnt2);
			pstmt.setInt   (29, nb_cnt3);
			
			pstmt.setString(30, ns_dt4);
			pstmt.setString(31, ne_dt4);
			pstmt.setInt   (32, nb_cnt4);
			pstmt.setInt   (33, cnt_per);
			pstmt.setInt   (34, cost_per);
			
			pstmt.setString(35, base_end_dt1);
			pstmt.setString(36, base_end_dt2);

			pstmt.setInt   (37, bus_f_per);

			pstmt.setString(38, year);
			pstmt.setString(39, tm);

			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		}catch(SQLException e){
			System.out.println("[CampaignDatabase:updateVar3]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return result;
		}
	}

	/**
	*	변수등록
	*/
	public int insertVar(String year, String tm, String cs_dt, String ce_dt, String bs_dt, String be_dt, String bs_dt2, String be_dt2, int amt, int bus_up_per, int bus_down_per, int mng_up_per, int mng_down_per, int bus_amt_per, int mng_amt_per, int new_bus_up_per, int new_bus_down_per, int new_bus_amt_per, int cnt1, int mon, String cnt2, float cmp_discnt_per, int car_amt, int max_dalsung, int bus_ga, int mng_ga, int bus_new_ga, String enter_dt, String ns_dt1, String ns_dt2, String ns_dt3, String ns_dt4, String ne_dt1, String ne_dt2, String ne_dt3, String ne_dt4, int nm_cnt1, int nm_cnt2, int nm_cnt3, int nm_cnt4, int nb_cnt1, int nb_cnt2, int nb_cnt3, int nb_cnt4, int cnt_per, int cost_per, int car_amt2, int cnt_per2, int cost_per2, int max_dalsung2, int mng_new_ga){

		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;

		String query = "insert into campaign "+
			" (  cs_dt, ce_dt, bs_dt, be_dt, "+
			"	 amt, bus_up_per, bus_down_per, "+
			"    mng_up_per, mng_down_per, bus_amt_per, mng_amt_per, "+
			"	 new_bus_up_per, new_bus_down_per, new_bus_amt_per, "+
			"	 cnt1, mon, cnt2, cmp_discnt_per, car_amt, "+
			"	 bs_dt2, be_dt2, max_dalsung, "+
			"	 bus_ga, mng_ga, bus_new_ga, enter_dt, "+
			"	 ns_dt1, ns_dt2, ns_dt3, ne_dt1, ne_dt2, ne_dt3, nm_cnt1, nm_cnt2, nm_cnt3, nb_cnt1, nb_cnt2, nb_cnt3,"+
			"    ns_dt4, ne_dt4, nm_cnt4, nb_cnt4, year, tm, cnt_per, cost_per, "+
			"    car_amt2, cnt_per2, cost_per2, max_dalsung2, mng_new_ga) "+
			" values "+
			" (  ?, ?, ?, ?, ?,  ?, ?, ?, ?, ?, "+
			"    ?, ?, ?, ?, ?,  ?, ?, ?, ?, ?, "+	
			"    ?, ?, ?, ?, ?,  ?, ?, ?, ?, ?, "+	
			"    ?, ?, ?, ?, ?,  ?, ?, ?, ?, ?, "+	
			"    ?, ?, ?, ?, ?,  ?, ?, ?, ?, ?, ?  "+	
			" )";

		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString (1, cs_dt);
			pstmt.setString (2, ce_dt);
			pstmt.setString (3, bs_dt);
			pstmt.setString (4, be_dt);
			pstmt.setInt	(5, amt);
			pstmt.setInt	(6, bus_up_per);
			pstmt.setInt	(7, bus_down_per);
			pstmt.setInt	(8, mng_up_per);
			pstmt.setInt	(9, mng_down_per);
			pstmt.setInt	(10, bus_amt_per);
			pstmt.setInt	(11, mng_amt_per);
			pstmt.setInt	(12, new_bus_up_per);
			pstmt.setInt	(13, new_bus_down_per);
			pstmt.setInt	(14, new_bus_amt_per);
			pstmt.setInt	(15, cnt1);
			pstmt.setInt	(16, mon);
			pstmt.setString (17, cnt2);
			pstmt.setFloat	(18, cmp_discnt_per);
			pstmt.setInt	(19, car_amt);
			pstmt.setString	(20, bs_dt2);
			pstmt.setString	(21, be_dt2);
			pstmt.setInt(22, max_dalsung);
			pstmt.setInt(23, bus_ga);
			pstmt.setInt(24, mng_ga);
			pstmt.setInt(25, bus_new_ga);
			pstmt.setString	(26, enter_dt);
			pstmt.setString	(27, ns_dt1);
			pstmt.setString	(28, ns_dt2);
			pstmt.setString	(29, ns_dt3);
			pstmt.setString	(30, ne_dt1);
			pstmt.setString	(31, ne_dt2);
			pstmt.setString	(32, ne_dt3);
			pstmt.setInt	(33, nm_cnt1);
			pstmt.setInt	(34, nm_cnt2);
			pstmt.setInt	(35, nm_cnt3);
			pstmt.setInt	(36, nb_cnt1);
			pstmt.setInt	(37, nb_cnt2);
			pstmt.setInt	(38, nb_cnt3);
			pstmt.setString	(39, ns_dt4);
			pstmt.setString	(40, ne_dt4);
			pstmt.setInt	(41, nm_cnt4);
			pstmt.setInt	(42, nb_cnt4);
			pstmt.setString	(43, year);
			pstmt.setString	(44, tm);
			pstmt.setInt	(45, cnt_per);
			pstmt.setInt	(46, cost_per);

			pstmt.setInt	(47, car_amt2);
			pstmt.setInt	(48, cnt_per2);
			pstmt.setInt	(49, cost_per2);
			pstmt.setInt    (50, max_dalsung2);
			pstmt.setInt    (51, bus_new_ga);

			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		}catch(SQLException e){
			System.out.println("[CampaignDatabase:insertVar]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return result;
		}
	}

	/**
	*	변수등록
	*/
	public int insertVar(String year, String tm, String cs_dt, String ce_dt, String bs_dt, String be_dt, String bs_dt2, String be_dt2, int amt, int bus_up_per, int bus_down_per, int mng_up_per, int mng_down_per, int bus_amt_per, int mng_amt_per, int new_bus_up_per, int new_bus_down_per, int new_bus_amt_per, int cnt1, int mon, String cnt2, float cmp_discnt_per, int car_amt, int max_dalsung, int bus_ga, int mng_ga, int bus_new_ga, String enter_dt, String ns_dt1, String ns_dt2, String ns_dt3, String ns_dt4, String ne_dt1, String ne_dt2, String ne_dt3, String ne_dt4, int nm_cnt1, int nm_cnt2, int nm_cnt3, int nm_cnt4, int nb_cnt1, int nb_cnt2, int nb_cnt3, int nb_cnt4, int cnt_per, int cost_per, int car_amt2, int cnt_per2, int cost_per2, int max_dalsung2, int mng_new_ga, String base_end_dt1, String base_end_dt2, int mng_f_per, int bus_f_per){

		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;

		String query = "insert into campaign "+
			" (  cs_dt, ce_dt, bs_dt, be_dt, "+
			"	 amt, bus_up_per, bus_down_per, "+
			"    mng_up_per, mng_down_per, bus_amt_per, mng_amt_per, "+
			"	 new_bus_up_per, new_bus_down_per, new_bus_amt_per, "+
			"	 cnt1, mon, cnt2, cmp_discnt_per, car_amt, "+
			"	 bs_dt2, be_dt2, max_dalsung, "+
			"	 bus_ga, mng_ga, bus_new_ga, enter_dt, "+
			"	 ns_dt1, ns_dt2, ns_dt3, ne_dt1, ne_dt2, ne_dt3, nm_cnt1, nm_cnt2, nm_cnt3, nb_cnt1, nb_cnt2, nb_cnt3,"+
			"    ns_dt4, ne_dt4, nm_cnt4, nb_cnt4, year, tm, cnt_per, cost_per, "+
			"    car_amt2, cnt_per2, cost_per2, max_dalsung2, mng_new_ga, base_end_dt1, base_end_dt2, mng_f_per, bus_f_per) "+
			" values "+
			" (  ?, ?, ?, ?, ?,  ?, ?, ?, ?, ?, "+
			"    ?, ?, ?, ?, ?,  ?, ?, ?, ?, ?, "+	
			"    ?, ?, ?, ?, ?,  ?, ?, ?, ?, ?, "+	
			"    ?, ?, ?, ?, ?,  ?, ?, ?, ?, ?, "+	
			"    ?, ?, ?, ?, ?,  ?, ?, ?, ?, ?, ?, ?, ?, ?, ?  "+	
			" )";

		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString (1, cs_dt);
			pstmt.setString (2, ce_dt);
			pstmt.setString (3, bs_dt);
			pstmt.setString (4, be_dt);
			pstmt.setInt	(5, amt);
			pstmt.setInt	(6, bus_up_per);
			pstmt.setInt	(7, bus_down_per);
			pstmt.setInt	(8, mng_up_per);
			pstmt.setInt	(9, mng_down_per);
			pstmt.setInt	(10, bus_amt_per);
			pstmt.setInt	(11, mng_amt_per);
			pstmt.setInt	(12, new_bus_up_per);
			pstmt.setInt	(13, new_bus_down_per);
			pstmt.setInt	(14, new_bus_amt_per);
			pstmt.setInt	(15, cnt1);
			pstmt.setInt	(16, mon);
			pstmt.setString (17, cnt2);
			pstmt.setFloat	(18, cmp_discnt_per);
			pstmt.setInt	(19, car_amt);
			pstmt.setString	(20, bs_dt2);
			pstmt.setString	(21, be_dt2);
			pstmt.setInt(22, max_dalsung);
			pstmt.setInt(23, bus_ga);
			pstmt.setInt(24, mng_ga);
			pstmt.setInt(25, bus_new_ga);
			pstmt.setString	(26, enter_dt);
			pstmt.setString	(27, ns_dt1);
			pstmt.setString	(28, ns_dt2);
			pstmt.setString	(29, ns_dt3);
			pstmt.setString	(30, ne_dt1);
			pstmt.setString	(31, ne_dt2);
			pstmt.setString	(32, ne_dt3);
			pstmt.setInt	(33, nm_cnt1);
			pstmt.setInt	(34, nm_cnt2);
			pstmt.setInt	(35, nm_cnt3);
			pstmt.setInt	(36, nb_cnt1);
			pstmt.setInt	(37, nb_cnt2);
			pstmt.setInt	(38, nb_cnt3);
			pstmt.setString	(39, ns_dt4);
			pstmt.setString	(40, ne_dt4);
			pstmt.setInt	(41, nm_cnt4);
			pstmt.setInt	(42, nb_cnt4);
			pstmt.setString	(43, year);
			pstmt.setString	(44, tm);
			pstmt.setInt	(45, cnt_per);
			pstmt.setInt	(46, cost_per);

			pstmt.setInt	(47, car_amt2);
			pstmt.setInt	(48, cnt_per2);
			pstmt.setInt	(49, cost_per2);
			pstmt.setInt    (50, max_dalsung2);
			pstmt.setInt    (51, bus_new_ga);

			pstmt.setString	(52, base_end_dt1);
			pstmt.setString	(53, base_end_dt2);

			pstmt.setInt	(54, mng_f_per);
			pstmt.setInt	(55, bus_f_per);


			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		}catch(SQLException e){
			System.out.println("[CampaignDatabase:insertVar]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return result;
		}
	}

	//담당자별리스트------------------------------------------------------------------------------------------


	/**
	 * 담당자별 계약건, 대여개시건 20050721.목
	 */
	public Vector getC_cntList(String bus_id, String cs_dt, String ce_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String subQuery="";

		if(!bus_id.equals(""))	subQuery = " and bus_id = '"+bus_id+"' ";

		query= " select gubun, rent_mng_id, rent_l_cd, firm_nm, bus_id, a.user_nm, rent_dt, rent_start_dt, "+
				"       decode(sign(to_number(rent_dt)-to_number('"+cs_dt+"')),0,1, 1,1, 0) rent_dt_cnt, "+
				"       decode(sign(to_number(rent_start_dt) - to_number('"+cs_dt+"')), 0,1, 1,1, 0) rent_start_dt_cnt "+
				" from "+
				"	("+
				"	 select decode(c.rent_st,'1','신규','2','연장(6개월이상)','3','대차','4','증차','5','연장(6개월미만)','6','보유차(6개월이상)','7','보유차(6개월미만)') gubun, "+
				"    c.rent_mng_id, c.rent_l_cd, nvl(d.firm_nm, d.client_nm) firm_nm, nvl(f.ext_agnt,c.bus_id) bus_id, u.user_nm, substr(nvl(f.rent_dt,c.rent_dt),1,8) rent_dt, nvl(f.rent_start_dt, e.car_rent_st) rent_start_dt "+
				"    from cont c, users u, client d, cls_cont l,"+
				"	 (select * from taecha where rent_fee>0) e, "+
				"	 (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
				"    where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd and c.rent_mng_id = e.rent_mng_id(+) and c.rent_l_cd=e.rent_l_cd(+) and nvl(e.no,'0')='0' "+
				"	 and c.rent_mng_id=l.rent_mng_id(+) and c.rent_l_cd=l.rent_l_cd(+) and nvl(l.cls_st,'0') not in ('3','4','5')"+
				"    and (nvl(f.rent_dt,c.rent_dt) between '"+cs_dt+"' and '"+ce_dt+"' or nvl(f.rent_start_dt, e.car_rent_st) between '"+cs_dt+"' and '"+ce_dt+"')"+
				"    and to_number(f.con_mon)>=6 "+
				"    and nvl(f.ext_agnt,c.bus_id) = u.user_id "+
				"    and c.client_id = d.client_id "+
				"    ) a, users u "+
				" where a.bus_id = u.user_id and u.use_yn = 'Y' and u.user_pos in ('사원','대리','과장') "+
				subQuery+
				" order by 5,4,7,8 ";

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
			System.out.println("[CampaignDatabase:getC_cntList(String bus_id, String cs_dt, String ce_dt)]"+e);
			System.out.println("[CampaignDatabase:getC_cntList(String bus_id, String cs_dt, String ce_dt)]"+query);
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
	 * 담당자별 계약후 출고전해지건 20060525.목
	 */
	public Vector getC_cntList2(String bus_id, String cs_dt, String ce_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String subQuery="";

		if(!bus_id.equals(""))	subQuery = " and bus_id = '"+bus_id+"' ";

		query= " select '출고전해지' gubun, b.rent_mng_id, b.rent_l_cd, nvl(c.firm_nm, c.client_nm) firm_nm, b.bus_id, u.user_nm, b.rent_dt, '' rent_start_dt "+
				" from cls_cont a, cont b, client c, users u "+
				" where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd "+
				" and b.client_id = c.client_id  "+
				" and b.bus_id = u.user_id "+
				" and a.cls_st in ('7','10')  "+
				" and a.cls_dt between '"+cs_dt+"' and '"+ce_dt+"' "+
				" and u.use_yn = 'Y' and u.user_pos in ('사원','대리','과장') "+
				subQuery+
				" order by 5,4,7,8 ";

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
			System.out.println("[CampaignDatabase:getC_cntList2(String bus_id, String cs_dt, String ce_dt)]"+e);
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
	 * 담당자별 6개월미만계약 실사용기간 6개월 초과건
	 */
	public Vector getC_cntList3(String bus_id, String cs_dt, String ce_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String subQuery="";

		if(!bus_id.equals(""))	subQuery = " and bus_id = '"+bus_id+"' ";

		query= " select gubun, rent_mng_id, rent_l_cd, firm_nm, bus_id, a.user_nm, rent_dt, rent_start_dt "+
				" from (select decode(c.rent_st,'1','신규','2','연장(6개월이상)','3','대차','4','증차','5','연장(6개월미만)','6','보유차(6개월이상)','7','보유차(6개월미만)') gubun, "+
				"           c.rent_mng_id, c.rent_l_cd, nvl(d.firm_nm, d.client_nm) firm_nm, nvl(f.ext_agnt,c.bus_id) bus_id, u.user_nm, substr(f.rent_dt,1,8) rent_dt, nvl(f.rent_start_dt, e.car_rent_st) as rent_start_dt "+
				"    from cont c, users u, client d, (select * from taecha where rent_fee>0) e, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f, cls_cont g "+
				"    where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd and c.rent_mng_id = e.rent_mng_id(+) and c.rent_l_cd=e.rent_l_cd(+) and nvl(e.no,'0')='0' and c.rent_l_cd=f.rent_l_cd(+) and c.rent_l_cd=g.rent_l_cd(+)"+

				"	 and trunc(months_between(nvl(to_date(g.cls_dt,'YYYYMMDD'),sysdate),to_date(nvl(f.rent_dt,c.rent_dt),'YYYYMMDD')-1),0)>=6 "+
				"	 and to_char(add_months(to_date(nvl(f.rent_dt,c.rent_dt),'YYYYMMDD'),6),'YYYYMMDD') between '"+cs_dt+"' and '"+ce_dt+"' "+
				"    and to_number(f.con_mon) < 6 "+

				"    and nvl(f.ext_agnt,c.bus_id) = u.user_id "+
				"    and c.client_id = d.client_id "+
				"    union "+
				"    select decode(c.rent_st,'1','신규','2','연장(6개월이상)','3','대차','4','증차','5','연장(6개월미만)','6','보유차(6개월이상)','7','보유차(6개월미만)') gubun, "+
				"           c.rent_mng_id, c.rent_l_cd, nvl(d.firm_nm, d.client_nm) firm_nm, nvl(f.ext_agnt,c.bus_id) bus_id, u.user_nm, substr(f.rent_dt,1,8) rent_dt, nvl(f.rent_start_dt, e.car_rent_st) as rent_start_dt "+
				"    from cont c, users u, client d, (select * from taecha where rent_fee>0) e, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f, cls_cont g "+
				"    where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd and c.rent_mng_id = e.rent_mng_id(+) and c.rent_l_cd=e.rent_l_cd(+) and nvl(e.no,'0')='0' and c.rent_l_cd=f.rent_l_cd(+) and c.rent_l_cd=g.rent_l_cd(+)"+

				"	 and trunc(months_between(nvl(to_date(g.cls_dt,'YYYYMMDD'),sysdate),to_date(nvl(f.rent_start_dt, e.car_rent_st),'YYYYMMDD')-1),0)>=6 "+//
				"	 and to_char(add_months(to_date(nvl(f.rent_start_dt, e.car_rent_st),'YYYYMMDD'),6),'YYYYMMDD') between '"+cs_dt+"' and '"+ce_dt+"' "+
				"    and to_number(f.con_mon) < 6 "+
				"    and nvl(f.ext_agnt,c.bus_id) = u.user_id "+
				"    and c.client_id = d.client_id "+
				"    ) a, users u "+
				" where a.bus_id = u.user_id and u.use_yn = 'Y' and u.user_pos in ('사원','대리','과장') "+
				subQuery+
				" order by 5,4,7,8 ";

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
			System.out.println("[CampaignDatabase:getC_cntList3(String bus_id, String cs_dt, String ce_dt)]"+e);
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
	 * 6개월이상계약 실이용기간 6개월 미만 감소 처리
	 */
	public Vector getC_cntList4(String bus_id, String cs_dt, String ce_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String subQuery="";

		if(!bus_id.equals(""))	subQuery = " and nvl(f.ext_agnt,b.bus_id) = '"+bus_id+"' ";

		query= " select '중도해지' gubun,"+
				" b.rent_mng_id, b.rent_l_cd, nvl(c.firm_nm, c.client_nm) firm_nm, nvl(f.ext_agnt,b.bus_id) bus_id, u.user_nm, f.rent_dt, f.rent_start_dt "+
				" from cls_cont a, cont b, client c, users u, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
				" where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd "+
				" and b.client_id = c.client_id  "+
				" and nvl(f.ext_agnt,b.bus_id) = u.user_id "+
				" and b.rent_mng_id=f.rent_mng_id and b.rent_l_cd=f.rent_l_cd"+
				" and a.cls_st in ('1','2') "+
				" and to_number(f.con_mon)>=6"+
				" and a.cls_dt between '"+cs_dt+"' and '"+ce_dt+"' "+
				" and to_char(add_months(to_date(nvl(f.rent_start_dt,b.rent_dt),'YYYYMMDD')-1,6),'YYYYMMDD') > a.cls_dt "+
				" and u.use_yn = 'Y' and u.user_pos in ('사원','대리','과장')"+// and f.rent_st='1' 
				subQuery+
				" order by 5,4,7,8 ";

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
			System.out.println("[CampaignDatabase:getC_cntList4(String bus_id, String cs_dt, String ce_dt)]"+e);
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


	//켐페인계산 kys------------------------------------------------------------------------------------------


	/**
	 * 결과
	*/
	public Vector getCampaign(String bs_dt, String be_dt, String bs_dt2, String be_dt2, String cs_dt, String ce_dt, int car_amt, int bus_up_per, int bus_down_per, int mng_up_per, int mng_down_per, int bus_amt_per, int mng_amt_per, int cnt1, int mon, String cnt2, float cmp_discnt_per, int max_dalsung, int bus_ga, int mng_ga, int bus_new_ga)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		double avg_dalsung = this.getAvg_Dalsung(bs_dt, be_dt, bs_dt2, be_dt2, cs_dt, ce_dt, car_amt, bus_up_per, bus_down_per, mng_up_per, mng_down_per, bus_amt_per, mng_amt_per, cnt1, mon, cnt2, cmp_discnt_per, max_dalsung, bus_ga, mng_ga, bus_new_ga);

		query=
"select dept_id, user_id, user_nm, cnt1, r_cnt, day, r_cnt2, pre_cmp, pre_cmp_ga, c_day, to_char(cmp_discnt_per,'90.99') cmp_discnt_per, "+
"		sum_cnt1, avg_cnt1, sum_r_cnt, avg_r_cnt, sum_bus, avg_bus, avg_low_bus, "+
"		to_char(c_cnt,'990.9') C_CNT, to_char(cr_cnt,'990.99') CR_CNT, to_char(dalsung*100,'9990.99') DALSUNG, round("+avg_dalsung+",4)*100 AVG_DALSUNG, "+
"		round(decode(sign("+avg_dalsung+" - dalsung), -1, decode(dept_id, '0001', amt*"+bus_amt_per+"/100, '0002',amt*"+mng_amt_per+"/100, 0), 0),-3) AMT "+
"  from "+
			//캠페인기간
"		(select u.dept_id, u.user_id, u.user_nm, rent_cnt, start_cnt, cnt1, r_rent_cnt, r_start_cnt, r_cnt, day, r_cnt2, pre_cmp, pre_cmp_ga, c_day, cmp_discnt_per, sum_cnt1, avg_cnt1, sum_r_cnt, avg_r_cnt, sum_bus, avg_bus, avg_low_bus, nvl(c_rent_cnt,0) C_RENT_CNT, nvl(c_start_cnt,0) C_START_CNT, nvl(c_cnt,0) C_CNT, nvl(cr_rent_cnt,0) CR_RENT_CNT, nvl(cr_start_cnt,0) CR_START_CNT, nvl(cr_cnt,0) CR_CNT, nvl(cr_cnt/cmp_discnt_per,0) ORG_DALSUNG, nvl(decode(sign("+max_dalsung+"/100-(cr_cnt/cmp_discnt_per)),-1, "+max_dalsung+"/100,(cr_cnt/cmp_discnt_per)),0) DALSUNG, "+
"				cr_cnt*nvl(decode(sign("+max_dalsung+"/100-(cr_cnt/cmp_discnt_per)),-1, "+max_dalsung+"/100, (cr_cnt/cmp_discnt_per)),0)*"+car_amt+" AMT "+
"			from (select u.user_id, u.user_nm, nvl(a.cnt,0) c_rent_cnt, nvl(b.cnt,0) c_start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 c_cnt, nvl(c.cnt,0)-nvl(e.cnt,0) cr_rent_cnt, nvl(d.cnt,0) cr_start_cnt, ((nvl(c.cnt,0)-nvl(e.cnt,0))+nvl(d.cnt,0))/2 cr_cnt "+
"		         from "+
"					(select nvl(f.ext_agnt,c.bus_id) bus_id, count(0) cnt "+
"					    from cont c, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"					    where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"					    and nvl(c.use_yn,'Y')='Y' and f.rent_dt between '"+cs_dt+"' and '"+ce_dt+"' "+
"					    and c.rent_st in ('1','2','3','4','6') "+
"					    group by nvl(f.ext_agnt,c.bus_id) "+
"					) a, "+//계약
"					(select nvl(f.ext_agnt,c.bus_id) bus_id, count(0) cnt "+
"					    from cont c, (select * from taecha where rent_fee>0) d, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"					    where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd and c.rent_mng_id = d.rent_mng_id(+) and c.rent_l_cd=d.rent_l_cd(+) and nvl(d.no,'0')='0' "+
"					    and nvl(c.use_yn,'Y')='Y' and nvl(f.rent_start_dt,d.car_rent_st) between '"+cs_dt+"' and '"+ce_dt+"' "+
"					    and c.rent_st in ('1','2','3','4','6') "+
"					    group by nvl(f.ext_agnt,c.bus_id) "+
"					) b, "+//개시
"					(select a.bus_id, nvl(sum(a.cnt),0) cnt "+
"					from (	select TEXT_DECRYPT(a.ssn, 'pw' )  ssn, nvl(f.ext_agnt,c.bus_id) bus_id, decode(count(0),0,0, 1,1, 2,1.5, 3,2, 4,2.5, 5,3, 6,3.5, 7,4, 8,4.5, 9,5, 10,5.5, 11,6, 12,6.5, 13,7, 14,7.5, 15,8, 16,8.5, 17,9, 18,9.5, 19,10, 10) cnt "+
"					        from cont c, client a, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"					        where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"					        and c.client_id = a.client_id and nvl(c.use_yn,'Y')='Y' "+
"					        and f.rent_dt between '"+cs_dt+"' and '"+ce_dt+"' "+
"					        and c.rent_st in ('1','2','3','4','6') "+
"					        group by TEXT_DECRYPT(a.ssn, 'pw' ) , nvl(f.ext_agnt,c.bus_id)"+
"					    ) a "+
"					group by a.bus_id "+
"					) c, "+//계약:고객한도
"					(select a.bus_id, nvl(sum(a.cnt),0) cnt "+
"					from (	select  TEXT_DECRYPT(a.ssn, 'pw' ) ssn, nvl(f.ext_agnt,c.bus_id) bus_id, decode(count(0),0,0, 1,1, 2,1.5, 3,2, 4,2.5, 5,3, 6,3.5, 7,4, 8,4.5, 9,5, 10,5.5, 11,6, 12,6.5, 13,7, 14,7.5, 15,8, 16,8.5, 17,9, 18,9.5, 19,10, 10) cnt "+
"					        from cont c, client a, (select * from taecha where rent_fee>0) d, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"					        where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd and c.rent_mng_id = d.rent_mng_id(+) and c.rent_l_cd=d.rent_l_cd(+) and nvl(d.no,'0')='0' "+
"					        and c.client_id = a.client_id and nvl(c.use_yn,'Y')='Y' "+
"					        and nvl(f.rent_start_dt,d.car_rent_st) between '"+cs_dt+"' and '"+ce_dt+"' "+
"					        and c.rent_st in ('1','2','3','4','6') "+
"					        group by TEXT_DECRYPT(a.ssn, 'pw' ) , nvl(f.ext_agnt,c.bus_id) "+
"					    ) a "+
"					group by a.bus_id "+
"					) d, "+//개시:고객한도
"					(select b.bus_id, count(0) cnt "+
"					from cls_cont a, cont b "+
"						where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd  "+
"						and cls_st in ('7','10')  "+
"						and cls_dt between '"+cs_dt+"' and '"+ce_dt+"' "+
"						and b.rent_dt between to_char(add_months('"+cs_dt+"',-3),'yyyymmdd') and to_char(add_months('"+ce_dt+"',-3),'yyyymmdd') "+
"					group by b.bus_id "+
"					) e, "+//출고전해지
"					users u  "+
"		    	where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id=c.bus_id(+) and u.user_id=d.bus_id(+) and u.user_id=e.bus_id(+) and u.dept_id in('0001','0002') and u.user_pos in ('사원','대리','과장') and u.use_yn='Y' and u.user_id not in ('000001','000015','000031')  "+
"		 		) v, "+
				//기준기간		
"				(select dept_id, user_id, user_nm, rent_cnt, start_cnt, cnt1, r_rent_cnt, r_start_cnt, r_cnt, day, r_cnt2, "+
"						decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+bus_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2)) pre_cmp, "+
"						decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+bus_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+bus_ga+"/100 pre_cmp_ga, "+
"						TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, "+
"						(decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+bus_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+bus_ga+"/100)*(TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1))) cmp_discnt_per "+
"						,sum_cnt1, avg_cnt1, sum_r_cnt, avg_r_cnt, sum_bus, avg_bus, avg_low_bus "+
"		        from "+
"		            (select u.dept_id, u.user_id, u.user_nm, nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1, nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"		                   TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+
"		            	   (nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2 "+
"		            from "+
"						(select nvl(f.ext_agnt,c.bus_id) bus_id, count(0) cnt "+
"						    from cont c, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"						    where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"						    and nvl(c.use_yn,'Y')='Y' and f.rent_dt between '"+bs_dt+"' and '"+be_dt+"' "+
"						    and c.rent_st in ('1','2','3','4','6') "+
"						    group by nvl(f.ext_agnt,c.bus_id) "+
"						) a, "+
"						(select nvl(f.ext_agnt,c.bus_id) bus_id, count(0) cnt "+
"						    from cont c, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"						    where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"						    and nvl(c.use_yn,'Y')='Y' and f.rent_start_dt between '"+bs_dt+"' and '"+be_dt+"' "+
"						    and c.rent_st in ('1','2','3','4','6') "+
"						    group by nvl(f.ext_agnt,c.bus_id) "+
"						) b, "+
"						(select a.bus_id, nvl(sum(a.cnt),0) cnt "+
"						from (	select TEXT_DECRYPT(a.ssn, 'pw' )  ssn, nvl(f.ext_agnt,c.bus_id) bus_id, decode(count(0),0,0, 1,1, 2,1.5, 3,2, 4,2.5, 5,3, 6,3.5, 7,4, 8,4.5, 9,5, 10,5.5, 11,6, 12,6.5, 13,7, 14,7.5, 15,8, 16,8.5, 17,9, 18,9.5, 19,10, 10) cnt "+
"						        from cont c, client a, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"						        where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"						        and c.client_id = a.client_id and nvl(c.use_yn,'Y')='Y' "+
"						        and f.rent_dt between '"+bs_dt+"' and '"+be_dt+"' "+
"						        and c.rent_st in ('1','2','3','4','6') "+
"						        group by TEXT_DECRYPT(a.ssn, 'pw' )  , nvl(f.ext_agnt,c.bus_id) "+
"						    ) a "+
"						group by a.bus_id "+
"						) c, "+
"						(select a.bus_id, nvl(sum(a.cnt),0) cnt "+
"						from (	select TEXT_DECRYPT(a.ssn, 'pw' )  ssn, nvl(f.ext_agnt,c.bus_id) bus_id, decode(count(0),0,0, 1,1, 2,1.5, 3,2, 4,2.5, 5,3, 6,3.5, 7,4, 8,4.5, 9,5, 10,5.5, 11,6, 12,6.5, 13,7, 14,7.5, 15,8, 16,8.5, 17,9, 18,9.5, 19,10, 10) cnt "+
"						        from cont c, client a, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"						        where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"						        and c.client_id = a.client_id and nvl(c.use_yn,'Y')='Y' "+
"						        and f.rent_start_dt between '"+bs_dt+"' and '"+be_dt+"' "+
"						        and c.rent_st in ('1','2','3','4','6') "+
"						        group by TEXT_DECRYPT(a.ssn, 'pw' ) , nvl(f.ext_agnt,c.bus_id) "+
"						    ) a "+
"						group by a.bus_id "+
"						) d, users u "+
"		            where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"		            and u.enter_dt<'20060331' and u.dept_id ='0001' and u.user_pos in ('사원','대리','과장') and u.use_yn='Y' "+
"		            ) s, "+
"		            (select  sum(cnt1) sum_cnt1, avg(cnt1) avg_cnt1, "+
"		                    sum(r_cnt) sum_r_cnt, avg(r_cnt) avg_r_cnt, "+
"		                    sum(r_cnt2) sum_bus, avg(r_cnt2) avg_bus, "+
"		                    avg(r_cnt2)*"+bus_down_per+"/100 avg_low_bus			 "+
"		            from (select u.dept_id, u.user_id, u.user_nm, nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1, nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"								TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+
"		            			(nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2 "+
"						from "+
"							(select nvl(f.ext_agnt,c.bus_id) bus_id, count(0) cnt "+
"							    from cont c, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"							    where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"							    and nvl(c.use_yn,'Y')='Y' and f.rent_dt between '"+bs_dt+"' and '"+be_dt+"' "+
"							    and c.rent_st in ('1','2','3','4','6') "+
"							    group by nvl(f.ext_agnt,c.bus_id) "+
"							) a, "+
"							(select nvl(f.ext_agnt,c.bus_id) bus_id, count(0) cnt "+
"							    from cont c, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"							    where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"							    and nvl(c.use_yn,'Y')='Y' and f.rent_start_dt between '"+bs_dt+"' and '"+be_dt+"' "+
"							    and c.rent_st in ('1','2','3','4','6') "+
"							    group by nvl(f.ext_agnt,c.bus_id) "+
"							) b, "+
"							(select a.bus_id, nvl(sum(a.cnt),0) cnt "+
"							from (	select TEXT_DECRYPT(a.ssn, 'pw' )  ssn, nvl(f.ext_agnt,c.bus_id) bus_id, decode(count(0),0,0, 1,1, 2,1.5, 3,2, 4,2.5, 5,3, 6,3.5, 7,4, 8,4.5, 9,5, 10,5.5, 11,6, 12,6.5, 13,7, 14,7.5, 15,8, 16,8.5, 17,9, 18,9.5, 19,10, 10) cnt "+
"							        from cont c, client a, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"							        where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"							        and c.client_id = a.client_id and nvl(c.use_yn,'Y')='Y' "+
"							        and f.rent_dt between '"+bs_dt+"' and '"+be_dt+"' "+
"							        and c.rent_st in ('1','2','3','4','6') "+
"							        group by TEXT_DECRYPT(a.ssn, 'pw' )  , nvl(f.ext_agnt,c.bus_id) "+
"							    ) a "+
"							group by a.bus_id "+
"							) c, "+
"							(select a.bus_id, nvl(sum(a.cnt),0) cnt "+
"							from (	select TEXT_DECRYPT(c.ssn, 'pw' )  ssn, nvl(f.ext_agnt,c.bus_id) bus_id, decode(count(0),0,0, 1,1, 2,1.5, 3,2, 4,2.5, 5,3, 6,3.5, 7,4, 8,4.5, 9,5, 10,5.5, 11,6, 12,6.5, 13,7, 14,7.5, 15,8, 16,8.5, 17,9, 18,9.5, 19,10, 10) cnt "+
"							        from cont c, client a, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"							        where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"							        and c.client_id = a.client_id and nvl(c.use_yn,'Y')='Y' "+
"							        and f.rent_start_dt between '"+bs_dt+"' and '"+be_dt+"' "+
"							        and c.rent_st in ('1','2','3','4','6') "+
"							        group by TEXT_DECRYPT(a.ssn, 'pw' ), nvl(f.ext_agnt,c.bus_id) "+
"							    ) a "+
"							group by a.bus_id "+
"							) d, users u "+
"						where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"						and u.enter_dt<'20060331' and u.dept_id ='0001' and u.user_pos in ('사원','대리','과장') and u.use_yn='Y' "+
"						) "+
"		            ) t "+
"				union "+	//여기까지 영업부
//-----------------------------------------------------------------------------------------
"				select dept_id, user_id, user_nm, rent_cnt, start_cnt, cnt1, r_rent_cnt, r_start_cnt, r_cnt, day, r_cnt2, "+
"						decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+mng_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2)) pre_cmp, "+
"						decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+mng_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+mng_ga+"/100 pre_cmp_ga, "+
"						TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, "+
"						(decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+mng_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+mng_ga+"/100)*(TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1))) cmp_discnt_per "+
"						,sum_cnt1, avg_cnt1, sum_r_cnt, avg_r_cnt, sum_bus, avg_bus, avg_low_bus "+
"		        from "+
"		            (select u.dept_id, u.user_id, u.user_nm, nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1, nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"		                   TRUNC(MONTHS_BETWEEN('"+be_dt2+"','"+bs_dt2+"') * 30.5) day, "+
"		            	   (nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt2+"','"+bs_dt2+"') * 30.5) r_cnt2 "+
"		            from "+
"						(select nvl(f.ext_agnt,c.bus_id) bus_id, count(0) cnt "+
"						    from cont c, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"						    where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"						    and nvl(c.use_yn,'Y')='Y' and f.rent_dt between '"+bs_dt2+"' and '"+be_dt2+"' "+
"						    and c.rent_st in ('1','2','3','4','6') "+
"						    group by nvl(f.ext_agnt,c.bus_id) "+
"						) a, "+
"						(select nvl(f.ext_agnt,c.bus_id) bus_id, count(0) cnt "+
"						    from cont c, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"						    where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"						    and nvl(c.use_yn,'Y')='Y' and f.rent_start_dt between '"+bs_dt2+"' and '"+be_dt2+"' "+
"						    and c.rent_st in ('1','2','3','4','6') "+
"						    group by nvl(f.ext_agnt,c.bus_id) "+
"						) b, "+
"						(select a.bus_id, nvl(sum(a.cnt),0) cnt "+
"						from (	select TEXT_DECRYPT(a.ssn, 'pw' )  ssn, nvl(f.ext_agnt,c.bus_id) bus_id, decode(count(0),0,0, 1,1, 2,1.5, 3,2, 4,2.5, 5,3, 6,3.5, 7,4, 8,4.5, 9,5, 10,5.5, 11,6, 12,6.5, 13,7, 14,7.5, 15,8, 16,8.5, 17,9, 18,9.5, 19,10, 10) cnt "+
"						        from cont c, client a, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"						        where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"						        and c.client_id = a.client_id and nvl(c.use_yn,'Y')='Y' "+
"						        and f.rent_dt between '"+bs_dt2+"' and '"+be_dt2+"' "+
"						        and c.rent_st in ('1','2','3','4','6') "+
"						        group by TEXT_DECRYPT(a.ssn, 'pw' )  , nvl(f.ext_agnt,c.bus_id) "+
"						    ) a "+
"						group by a.bus_id "+
"						) c, "+
"						(select a.bus_id, nvl(sum(a.cnt),0) cnt "+
"						from (	select TEXT_DECRYPT(a.ssn, 'pw' )  ssn, nvl(f.ext_agnt,c.bus_id) bus_id, decode(count(0),0,0, 1,1, 2,1.5, 3,2, 4,2.5, 5,3, 6,3.5, 7,4, 8,4.5, 9,5, 10,5.5, 11,6, 12,6.5, 13,7, 14,7.5, 15,8, 16,8.5, 17,9, 18,9.5, 19,10, 10) cnt "+
"						        from cont c, client a, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"						        where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"						        and c.client_id = a.client_id and nvl(c.use_yn,'Y')='Y' "+
"						        and f.rent_start_dt between '"+bs_dt2+"' and '"+be_dt2+"' "+
"						        and c.rent_st in ('1','2','3','4','6') "+
"						        group by TEXT_DECRYPT(a.ssn, 'pw' ) , nvl(f.ext_agnt,c.bus_id) "+
"						    ) a "+
"						group by a.bus_id "+
"						) d, users u "+
"		            where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"		            and u.enter_dt<'20060331' and u.dept_id ='0002' and u.user_pos in ('사원','대리','과장') and u.use_yn='Y' "+
"		            ) s, "+
"		            (select  sum(cnt1) sum_cnt1, avg(cnt1) avg_cnt1, "+
"		                    sum(r_cnt) sum_r_cnt, avg(r_cnt) avg_r_cnt, "+
"		                    sum(r_cnt2) sum_bus, avg(r_cnt2) avg_bus, "+
"		                    avg(r_cnt2)*"+mng_down_per+"/100 avg_low_bus			 "+
"		            from (select u.dept_id, u.user_id, u.user_nm, nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1, nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"								TRUNC(MONTHS_BETWEEN('"+be_dt2+"','"+bs_dt2+"') * 30.5) day, "+
"		            			(nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt2+"','"+bs_dt2+"') * 30.5) r_cnt2 "+
"							from "+
"							(select nvl(f.ext_agnt,c.bus_id) bus_id, count(0) cnt "+
"							    from cont c, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"							    where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"							    and nvl(c.use_yn,'Y')='Y' and f.rent_dt between '"+bs_dt2+"' and '"+be_dt2+"' "+
"							    and c.rent_st in ('1','2','3','4','6') "+
"							    group by nvl(f.ext_agnt,c.bus_id) "+
"							) a, "+
"							(select nvl(f.ext_agnt,c.bus_id) bus_id, count(0) cnt "+
"							    from cont c, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"							    where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"							    and nvl(c.use_yn,'Y')='Y' and f.rent_start_dt between '"+bs_dt2+"' and '"+be_dt2+"' "+
"							    and c.rent_st in ('1','2','3','4','6') "+
"							    group by nvl(f.ext_agnt,c.bus_id) "+
"							) b, "+
"							(select a.bus_id, nvl(sum(a.cnt),0) cnt "+
"							from (	select TEXT_DECRYPT(a.ssn, 'pw' )  ssn, nvl(f.ext_agnt,c.bus_id) bus_id, decode(count(0),0,0, 1,1, 2,1.5, 3,2, 4,2.5, 5,3, 6,3.5, 7,4, 8,4.5, 9,5, 10,5.5, 11,6, 12,6.5, 13,7, 14,7.5, 15,8, 16,8.5, 17,9, 18,9.5, 19,10, 10) cnt "+
"							        from cont c, client a, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"							        where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"							        and c.client_id = a.client_id and nvl(c.use_yn,'Y')='Y' "+
"							        and f.rent_dt between '"+bs_dt2+"' and '"+be_dt2+"' "+
"							        and c.rent_st in ('1','2','3','4','6') "+
"							        group by TEXT_DECRYPT(a.ssn, 'pw' ) , nvl(f.ext_agnt,c.bus_id) "+
"							    ) a "+
"							group by a.bus_id "+
"							) c, "+
"							(select a.bus_id, nvl(sum(a.cnt),0) cnt "+
"							from (	select TEXT_DECRYPT(a.ssn, 'pw' ) ssn, nvl(f.ext_agnt,c.bus_id) bus_id, decode(count(0),0,0, 1,1, 2,1.5, 3,2, 4,2.5, 5,3, 6,3.5, 7,4, 8,4.5, 9,5, 10,5.5, 11,6, 12,6.5, 13,7, 14,7.5, 15,8, 16,8.5, 17,9, 18,9.5, 19,10, 10) cnt "+
"							        from cont c, client a, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"							        where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"							        and c.client_id = a.client_id and nvl(c.use_yn,'Y')='Y' "+
"							        and f.rent_start_dt between '"+bs_dt2+"' and '"+be_dt2+"' "+
"							        and c.rent_st in ('1','2','3','4','6') "+
"							        group by TEXT_DECRYPT(a.ssn, 'pw' ) , nvl(f.ext_agnt,c.bus_id) "+
"							    ) a "+
"							group by a.bus_id "+
"							) d, users u "+
"						where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"						and u.enter_dt<'20060331' and u.dept_id ='0002' and u.user_pos in ('사원','대리','과장') and u.use_yn='Y' "+
"						) "+
"		            ) t "+
"				union "+	//여기까지 관리부, 아래는 신입사원 따로
//-----------------------------------------------------------------------------------------
"				select '0001' dept_id, '000059' user_id, '김영호' user_nm, "+cnt1+" rent_cnt, "+cnt1+" start_cnt, "+cnt1+" cnt1, "+cnt1+" r_rent_cnt, "+cnt1+" r_start_cnt, "+cnt1+" r_cnt, TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) pre_cmp, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100 pre_cmp_ga, TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, ("+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100)*TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) cmp_discnt_per, 0, 0, 0, 0, 0, 0, 0 from dual "+
"				union "+
"				select '0001' dept_id, '000060' user_id, '최인석' user_nm, "+cnt1+" rent_cnt, "+cnt1+" start_cnt, "+cnt1+" cnt1, "+cnt1+" r_rent_cnt, "+cnt1+" r_start_cnt, "+cnt1+" r_cnt, TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) pre_cmp, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100 pre_cmp_ga, TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, ("+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100)*TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) cmp_discnt_per, 0, 0, 0, 0, 0, 0, 0 from dual "+
"				union "+
"				select '0001' dept_id, '000061' user_id, '황선문' user_nm, "+cnt1+" rent_cnt, "+cnt1+" start_cnt, "+cnt1+" cnt1, "+cnt1+" r_rent_cnt, "+cnt1+" r_start_cnt, "+cnt1+" r_cnt, TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) pre_cmp, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100 pre_cmp_ga, TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, ("+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100)*TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) cmp_discnt_per, 0, 0, 0, 0, 0, 0, 0 from dual "+
//-----------------------------------------------------------------------------------------
"				) u "+
"			where u.user_id = v.user_id "+
"		) "+
"	order by ORG_DALSUNG desc, amt desc, cmp_discnt_per desc ";

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
			System.out.println("[CampaignDatabase:getCampaign(String bs_dt, String be_dt, String cs_dt, String ce_dt, int amt, int bus_up_per, int bus_down_per, int mng_up_per, int mng_down_per)]"+e);
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
	 * 결과 평균값 구하기
	*/
	public double getAvg_Dalsung(String bs_dt, String be_dt, String bs_dt2, String be_dt2, String cs_dt, String ce_dt, int car_amt, int bus_up_per, int bus_down_per, int mng_up_per, int mng_down_per, int bus_amt_per, int mng_amt_per, int cnt1, int mon, String cnt2, float cmp_discnt_per, int max_dalsung, int bus_ga, int mng_ga, int bus_new_ga)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		double avg = 0.0;
		String query = "";

		query=
"select avg(dalsung) AVG_DALSUNG "+
"	  from (select u.dept_id, u.user_id, u.user_nm, rent_cnt, start_cnt, cnt1, r_rent_cnt, r_start_cnt, r_cnt, day, r_cnt2, pre_cmp, pre_cmp_ga, c_day, cmp_discnt_per, sum_cnt1, avg_cnt1, sum_r_cnt, avg_r_cnt, sum_bus, avg_bus, avg_low_bus, nvl(c_rent_cnt,0) C_RENT_CNT, nvl(c_start_cnt,0) C_START_CNT, nvl(c_cnt,0) C_CNT, nvl(cr_rent_cnt,0) CR_RENT_CNT, nvl(cr_start_cnt,0) CR_START_CNT, nvl(cr_cnt,0) CR_CNT, nvl(decode(sign("+max_dalsung+"/100-(cr_cnt/cmp_discnt_per)),-1, "+max_dalsung+"/100,(cr_cnt/cmp_discnt_per)),0) DALSUNG, "+
"				cr_cnt*nvl(decode(sign("+max_dalsung+"/100-(cr_cnt/cmp_discnt_per)),-1, "+max_dalsung+"/100, (cr_cnt/cmp_discnt_per)),0)*"+car_amt+" AMT "+
"			from (select u.user_id, u.user_nm, nvl(a.cnt,0) c_rent_cnt, nvl(b.cnt,0) c_start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 c_cnt, nvl(c.cnt,0)-nvl(e.cnt,0) cr_rent_cnt, nvl(d.cnt,0) cr_start_cnt, ((nvl(c.cnt,0)-nvl(e.cnt,0))+nvl(d.cnt,0))/2 cr_cnt "+
"		         from "+
"					(select nvl(f.ext_agnt,c.bus_id) bus_id, count(0) cnt "+
"					    from cont c, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"					    where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"					    and nvl(c.use_yn,'Y')='Y' and f.rent_dt between '"+cs_dt+"' and '"+ce_dt+"' "+
"					    and c.rent_st in ('1','2','3','4','6') "+
"					    group by nvl(f.ext_agnt,c.bus_id) "+
"					) a, "+
"					(select nvl(f.ext_agnt,c.bus_id) bus_id, count(0) cnt "+
"					    from cont c, (select * from taecha where rent_fee>0) d, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"					    where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd and c.rent_mng_id = d.rent_mng_id(+) and c.rent_l_cd=d.rent_l_cd(+) and nvl(d.no,'0')='0' "+
"					    and nvl(c.use_yn,'Y')='Y' and nvl(f.rent_start_dt,d.car_rent_st) between '"+cs_dt+"' and '"+ce_dt+"' "+
"					    and c.rent_st in ('1','2','3','4','6') "+
"					    group by nvl(f.ext_agnt,c.bus_id) "+
"					) b, "+
"					(select a.bus_id, nvl(sum(a.cnt),0) cnt "+
"					from (	select a.ssn, nvl(f.ext_agnt,c.bus_id) bus_id, decode(count(0),0,0, 1,1, 2,1.5, 3,2, 4,2.5, 5,3, 6,3.5, 7,4, 8,4.5, 9,5, 10,5.5, 11,6, 12,6.5, 13,7, 14,7.5, 15,8, 16,8.5, 17,9, 18,9.5, 19,10, 10) cnt "+
"					        from cont c, client a, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"					        where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"					        and c.client_id = a.client_id and nvl(c.use_yn,'Y')='Y' "+
"					        and f.rent_dt between '"+cs_dt+"' and '"+ce_dt+"' "+
"					        and c.rent_st in ('1','2','3','4','6') "+
"					        group by a.ssn, nvl(f.ext_agnt,c.bus_id)"+
"					    ) a "+
"					group by a.bus_id "+
"					) c, "+
"					(select a.bus_id, nvl(sum(a.cnt),0) cnt "+
"					from (	select a.ssn, nvl(f.ext_agnt,c.bus_id) bus_id, decode(count(0),0,0, 1,1, 2,1.5, 3,2, 4,2.5, 5,3, 6,3.5, 7,4, 8,4.5, 9,5, 10,5.5, 11,6, 12,6.5, 13,7, 14,7.5, 15,8, 16,8.5, 17,9, 18,9.5, 19,10, 10) cnt "+
"					        from cont c, client a, (select * from taecha where rent_fee>0) d, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"					        where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd and c.rent_mng_id = d.rent_mng_id(+) and c.rent_l_cd=d.rent_l_cd(+) and nvl(d.no,'0')='0' "+
"					        and c.client_id = a.client_id and nvl(c.use_yn,'Y')='Y' "+
"					        and nvl(f.rent_start_dt,d.car_rent_st) between '"+cs_dt+"' and '"+ce_dt+"' "+
"					        and c.rent_st in ('1','2','3','4','6') "+
"					        group by a.ssn, nvl(f.ext_agnt,c.bus_id)"+
"					    ) a "+
"					group by a.bus_id "+
"					) d, "+
"					(select b.bus_id, count(0) cnt "+
"					from cls_cont a, cont b "+
"						where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd  "+
"						and cls_st='7'  "+
"						and cls_dt between '"+cs_dt+"' and '"+ce_dt+"' "+
"						and b.rent_dt between to_char(add_months('"+cs_dt+"',-3),'yyyymmdd') and to_char(add_months('"+ce_dt+"',-3),'yyyymmdd') "+
"					group by b.bus_id "+
"					) e, users u  "+
"		    	where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id=c.bus_id(+) and u.user_id=d.bus_id(+) and u.user_id=e.bus_id(+) and u.dept_id in('0001','0002') and u.user_pos in ('사원','대리','과장') and u.use_yn='Y' and u.user_id not in ('000001','000015','000031')  "+
"		 		) v, "+
"				(select dept_id, user_id, user_nm, rent_cnt, start_cnt, cnt1, r_rent_cnt, r_start_cnt, r_cnt, day, r_cnt2, "+
"						decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+bus_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2)) pre_cmp, "+
"						decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+bus_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+bus_ga+"/100 pre_cmp_ga, "+
"						TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, "+
"						(decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+bus_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+bus_ga+"/100)*(TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1))) cmp_discnt_per "+
"						,sum_cnt1, avg_cnt1, sum_r_cnt, avg_r_cnt, sum_bus, avg_bus, avg_low_bus "+
"		        from "+
"		            (select u.dept_id, u.user_id, u.user_nm, nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1, nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"		                   TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+
"		            	   (nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2 "+
"		            from "+
"						(select nvl(f.ext_agnt,c.bus_id) bus_id, count(0) cnt "+
"						    from cont c, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"						    where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"						    and nvl(c.use_yn,'Y')='Y' and f.rent_dt between '"+bs_dt+"' and '"+be_dt+"' "+
"						    and c.rent_st in ('1','2','3','4','6') "+
"						    group by nvl(f.ext_agnt,c.bus_id) "+
"						) a, "+
"						(select nvl(f.ext_agnt,c.bus_id) bus_id, count(0) cnt "+
"						    from cont c, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"						    where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"						    and nvl(c.use_yn,'Y')='Y' and f.rent_start_dt between '"+bs_dt+"' and '"+be_dt+"' "+
"						    and c.rent_st in ('1','2','3','4','6') "+
"						    group by nvl(f.ext_agnt,c.bus_id) "+
"						) b, "+
"						(select a.bus_id, nvl(sum(a.cnt),0) cnt "+
"						from (	select a.ssn, nvl(f.ext_agnt,c.bus_id) bus_id, decode(count(0),0,0, 1,1, 2,1.5, 3,2, 4,2.5, 5,3, 6,3.5, 7,4, 8,4.5, 9,5, 10,5.5, 11,6, 12,6.5, 13,7, 14,7.5, 15,8, 16,8.5, 17,9, 18,9.5, 19,10, 10) cnt "+
"						        from cont c, client a, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"						        where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"						        and c.client_id = a.client_id and nvl(c.use_yn,'Y')='Y' "+
"						        and f.rent_dt between '"+bs_dt+"' and '"+be_dt+"' "+
"						        and c.rent_st in ('1','2','3','4','6') "+
"						        group by a.ssn, nvl(f.ext_agnt,c.bus_id)"+
"						    ) a "+
"						group by a.bus_id "+
"						) c, "+
"						(select a.bus_id, nvl(sum(a.cnt),0) cnt "+
"						from (	select a.ssn, nvl(f.ext_agnt,c.bus_id) bus_id, decode(count(0),0,0, 1,1, 2,1.5, 3,2, 4,2.5, 5,3, 6,3.5, 7,4, 8,4.5, 9,5, 10,5.5, 11,6, 12,6.5, 13,7, 14,7.5, 15,8, 16,8.5, 17,9, 18,9.5, 19,10, 10) cnt "+
"						        from cont c, client a, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"						        where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"						        and c.client_id = a.client_id and nvl(c.use_yn,'Y')='Y' "+
"						        and f.rent_start_dt between '"+bs_dt+"' and '"+be_dt+"' "+
"						        and c.rent_st in ('1','2','3','4','6') "+
"						        group by a.ssn, nvl(f.ext_agnt,c.bus_id)"+
"						    ) a "+
"						group by a.bus_id "+
"						) d, users u "+
"		            where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"		            and u.enter_dt<'20051101' and u.dept_id ='0001' and u.user_pos in ('사원','대리','과장') and u.use_yn='Y' "+
"		            ) s, "+
"		            (select  sum(cnt1) sum_cnt1, avg(cnt1) avg_cnt1, "+
"		                    sum(r_cnt) sum_r_cnt, avg(r_cnt) avg_r_cnt, "+
"		                    sum(r_cnt2) sum_bus, avg(r_cnt2) avg_bus, "+
"		                    avg(r_cnt2)*"+bus_down_per+"/100 avg_low_bus			 "+
"		            from (select u.dept_id, u.user_id, u.user_nm, nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1, nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"								TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+
"		            			(nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2 "+
"						from "+
"							(select nvl(f.ext_agnt,c.bus_id) bus_id, count(0) cnt "+
"							    from cont c, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"							    where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"							    and nvl(c.use_yn,'Y')='Y' and f.rent_dt between '"+bs_dt+"' and '"+be_dt+"' "+
"							    and c.rent_st in ('1','2','3','4','6') "+
"							    group by nvl(f.ext_agnt,c.bus_id) "+
"							) a, "+
"							(select nvl(f.ext_agnt,c.bus_id) bus_id, count(0) cnt "+
"							    from cont c, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"							    where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"							    and nvl(c.use_yn,'Y')='Y' and f.rent_start_dt between '"+bs_dt+"' and '"+be_dt+"' "+
"							    and c.rent_st in ('1','2','3','4','6') "+
"							    group by nvl(f.ext_agnt,c.bus_id) "+
"							) b, "+
"							(select a.bus_id, nvl(sum(a.cnt),0) cnt "+
"							from (	select a.ssn, nvl(f.ext_agnt,c.bus_id) bus_id, decode(count(0),0,0, 1,1, 2,1.5, 3,2, 4,2.5, 5,3, 6,3.5, 7,4, 8,4.5, 9,5, 10,5.5, 11,6, 12,6.5, 13,7, 14,7.5, 15,8, 16,8.5, 17,9, 18,9.5, 19,10, 10) cnt "+
"							        from cont c, client a, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"							        where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"							        and c.client_id = a.client_id and nvl(c.use_yn,'Y')='Y' "+
"							        and f.rent_dt between '"+bs_dt+"' and '"+be_dt+"' "+
"							        and c.rent_st in ('1','2','3','4','6') "+
"							        group by a.ssn, nvl(f.ext_agnt,c.bus_id)"+
"							    ) a "+
"							group by a.bus_id "+
"							) c, "+
"							(select a.bus_id, nvl(sum(a.cnt),0) cnt "+
"							from (	select a.ssn, nvl(f.ext_agnt,c.bus_id) bus_id, decode(count(0),0,0, 1,1, 2,1.5, 3,2, 4,2.5, 5,3, 6,3.5, 7,4, 8,4.5, 9,5, 10,5.5, 11,6, 12,6.5, 13,7, 14,7.5, 15,8, 16,8.5, 17,9, 18,9.5, 19,10, 10) cnt "+
"							        from cont c, client a, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"							        where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"							        and c.client_id = a.client_id and nvl(c.use_yn,'Y')='Y' "+
"							        and f.rent_start_dt between '"+bs_dt+"' and '"+be_dt+"' "+
"							        and c.rent_st in ('1','2','3','4','6') "+
"							        group by a.ssn, nvl(f.ext_agnt,c.bus_id)"+
"							    ) a "+
"							group by a.bus_id "+
"							) d, users u "+
"						where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"						and u.enter_dt<'20051101' and u.dept_id ='0001' and u.user_pos in ('사원','대리','과장') and u.use_yn='Y' "+
"						) "+
"		            ) t "+
"				union "+	//여기까지 영업부
"				select dept_id, user_id, user_nm, rent_cnt, start_cnt, cnt1, r_rent_cnt, r_start_cnt, r_cnt, day, r_cnt2, "+
"						decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+mng_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2)) pre_cmp, "+
"						decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+mng_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+mng_ga+"/100 pre_cmp_ga, "+
"						TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, "+
"						(decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+mng_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+mng_ga+"/100)*(TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1))) cmp_discnt_per "+
"						,sum_cnt1, avg_cnt1, sum_r_cnt, avg_r_cnt, sum_bus, avg_bus, avg_low_bus "+
"		        from "+
"		            (select u.dept_id, u.user_id, u.user_nm, nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1, nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"		                   TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+
"		            	   (nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2 "+
"		            from "+
"						(select nvl(f.ext_agnt,c.bus_id) bus_id, count(0) cnt "+
"						    from cont c, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"						    where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"						    and nvl(c.use_yn,'Y')='Y' and f.rent_dt between '"+bs_dt2+"' and '"+be_dt2+"' "+
"						    and c.rent_st in ('1','2','3','4','6') "+
"						    group by nvl(f.ext_agnt,c.bus_id) "+
"						) a, "+
"						(select nvl(f.ext_agnt,c.bus_id) bus_id, count(0) cnt "+
"						    from cont c, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"						    where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"						    and nvl(c.use_yn,'Y')='Y' and f.rent_start_dt between '"+bs_dt2+"' and '"+be_dt2+"' "+
"						    and c.rent_st in ('1','2','3','4','6') "+
"						    group by nvl(f.ext_agnt,c.bus_id) "+
"						) b, "+
"						(select a.bus_id, nvl(sum(a.cnt),0) cnt "+
"						from (	select a.ssn, nvl(f.ext_agnt,c.bus_id) bus_id, decode(count(0),0,0, 1,1, 2,1.5, 3,2, 4,2.5, 5,3, 6,3.5, 7,4, 8,4.5, 9,5, 10,5.5, 11,6, 12,6.5, 13,7, 14,7.5, 15,8, 16,8.5, 17,9, 18,9.5, 19,10, 10) cnt "+
"						        from cont c, client a, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"						        where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"						        and c.client_id = a.client_id and nvl(c.use_yn,'Y')='Y' "+
"						        and f.rent_dt between '"+bs_dt2+"' and '"+be_dt2+"' "+
"						        and c.rent_st in ('1','2','3','4','6') "+
"						        group by a.ssn, nvl(f.ext_agnt,c.bus_id)"+
"						    ) a "+
"						group by a.bus_id "+
"						) c, "+
"						(select a.bus_id, nvl(sum(a.cnt),0) cnt "+
"						from (	select a.ssn, nvl(f.ext_agnt,c.bus_id) bus_id, decode(count(0),0,0, 1,1, 2,1.5, 3,2, 4,2.5, 5,3, 6,3.5, 7,4, 8,4.5, 9,5, 10,5.5, 11,6, 12,6.5, 13,7, 14,7.5, 15,8, 16,8.5, 17,9, 18,9.5, 19,10, 10) cnt "+
"						        from cont c, client a, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"						        where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"						        and c.client_id = a.client_id and nvl(c.use_yn,'Y')='Y' "+
"						        and f.rent_start_dt between '"+bs_dt2+"' and '"+be_dt2+"' "+
"						        and c.rent_st in ('1','2','3','4','6') "+
"						        group by a.ssn, nvl(f.ext_agnt,c.bus_id)"+
"						    ) a "+
"						group by a.bus_id "+
"						) d, users u "+
"		            where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"		            and u.enter_dt<'20051101' and u.dept_id ='0002' and u.user_pos in ('사원','대리','과장') and u.use_yn='Y' "+
"		            ) s, "+
"		            (select  sum(cnt1) sum_cnt1, avg(cnt1) avg_cnt1, "+
"		                    sum(r_cnt) sum_r_cnt, avg(r_cnt) avg_r_cnt, "+
"		                    sum(r_cnt2) sum_bus, avg(r_cnt2) avg_bus, "+
"		                    avg(r_cnt2)*"+mng_down_per+"/100 avg_low_bus			 "+
"		            from (select u.dept_id, u.user_id, u.user_nm, nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1, nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"								TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+
"		            			(nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2 "+
"							from "+
"							(select nvl(f.ext_agnt,c.bus_id) bus_id, count(0) cnt "+
"							    from cont c, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"							    where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"							    and nvl(c.use_yn,'Y')='Y' and f.rent_dt between '"+bs_dt2+"' and '"+be_dt2+"' "+
"							    and c.rent_st in ('1','2','3','4','6') "+
"							    group by nvl(f.ext_agnt,c.bus_id) "+
"							) a, "+
"							(select nvl(f.ext_agnt,c.bus_id) bus_id, count(0) cnt "+
"							    from cont c, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"							    where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"							    and nvl(c.use_yn,'Y')='Y' and f.rent_start_dt between '"+bs_dt2+"' and '"+be_dt2+"' "+
"							    and c.rent_st in ('1','2','3','4','6') "+
"							    group by nvl(f.ext_agnt,c.bus_id) "+
"							) b, "+
"							(select a.bus_id, nvl(sum(a.cnt),0) cnt "+
"							from (	select a.ssn, nvl(f.ext_agnt,c.bus_id) bus_id, decode(count(0),0,0, 1,1, 2,1.5, 3,2, 4,2.5, 5,3, 6,3.5, 7,4, 8,4.5, 9,5, 10,5.5, 11,6, 12,6.5, 13,7, 14,7.5, 15,8, 16,8.5, 17,9, 18,9.5, 19,10, 10) cnt "+
"							        from cont c, client a, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"							        where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"							        and c.client_id = a.client_id and nvl(c.use_yn,'Y')='Y' "+
"							        and f.rent_dt between '"+bs_dt2+"' and '"+be_dt2+"' "+
"							        and c.rent_st in ('1','2','3','4','6') "+
"								    group by a.ssn, nvl(f.ext_agnt,c.bus_id)"+
"							    ) a "+
"							group by a.bus_id "+
"							) c, "+
"							(select a.bus_id, nvl(sum(a.cnt),0) cnt "+
"							from (	select a.ssn, nvl(f.ext_agnt,c.bus_id) bus_id, decode(count(0),0,0, 1,1, 2,1.5, 3,2, 4,2.5, 5,3, 6,3.5, 7,4, 8,4.5, 9,5, 10,5.5, 11,6, 12,6.5, 13,7, 14,7.5, 15,8, 16,8.5, 17,9, 18,9.5, 19,10, 10) cnt "+
"							        from cont c, client a, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"							        where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"							        and c.client_id = a.client_id and nvl(c.use_yn,'Y')='Y' "+
"							        and f.rent_start_dt between '"+bs_dt2+"' and '"+be_dt2+"' "+
"							        and c.rent_st in ('1','2','3','4','6') "+
"								    group by a.ssn, nvl(f.ext_agnt,c.bus_id)"+
"							    ) a "+
"							group by a.bus_id "+
"							) d, users u "+
"						where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"						and u.enter_dt<'20051101' and u.dept_id ='0002' and u.user_pos in ('사원','대리','과장') and u.use_yn='Y' "+
"						) "+
"		            ) t "+
"				union "+	//여기까지 관리부, 아래는 신입사원 따로
"				select '0001' dept_id, '000052' user_id, '박영규' user_nm, "+cnt1+" rent_cnt, "+cnt1+" start_cnt, "+cnt1+" cnt1, "+cnt1+" r_rent_cnt, "+cnt1+" r_start_cnt, "+cnt1+" r_cnt, TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) pre_cmp, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100 pre_cmp_ga, TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, ("+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100)*TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) cmp_discnt_per, 0, 0, 0, 0, 0, 0, 0 from dual "+
"				union "+
"				select '0001' dept_id, '000053' user_id, '제인학' user_nm, "+cnt1+" rent_cnt, "+cnt1+" start_cnt, "+cnt1+" cnt1, "+cnt1+" r_rent_cnt, "+cnt1+" r_start_cnt, "+cnt1+" r_cnt, TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) pre_cmp, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100 pre_cmp_ga, TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, ("+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100)*TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) cmp_discnt_per, 0, 0, 0, 0, 0, 0, 0 from dual "+
"				union "+
"				select '0001' dept_id, '000054' user_id, '윤영탁' user_nm, "+cnt1+" rent_cnt, "+cnt1+" start_cnt, "+cnt1+" cnt1, "+cnt1+" r_rent_cnt, "+cnt1+" r_start_cnt, "+cnt1+" r_cnt, TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) pre_cmp, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100 pre_cmp_ga, TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, ("+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100)*TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) cmp_discnt_per, 0, 0, 0, 0, 0, 0, 0 from dual "+
"				union "+
"				select '0001' dept_id, '000055' user_id, '정동열' user_nm, "+cnt1+" rent_cnt, "+cnt1+" start_cnt, "+cnt1+" cnt1, "+cnt1+" r_rent_cnt, "+cnt1+" r_start_cnt, "+cnt1+" r_cnt, TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) pre_cmp, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100 pre_cmp_ga, TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, ("+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100)*TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) cmp_discnt_per, 0, 0, 0, 0, 0, 0, 0 from dual "+
"				) u "+
"			where u.user_id = v.user_id "+
"			)  ";


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			while(rs.next()){
				avg = rs.getDouble(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CampaignDatabase:getAvg_Dalsung(String bs_dt, String be_dt, String cs_dt, String ce_dt, int amt, int bus_up_per, int bus_down_per, int mng_up_per, int mng_down_per)]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return avg;
		}
	}	



	//계산식------------------------------------------------------------------------------------------


	/**
	 * 부서별 할인치,기준치,포상금액 --영업부, 관리부
	 */
	public Vector getCmpleteDept(String dept, String bs_dt, String be_dt, String bs_dt2, String be_dt2, String cs_dt, String ce_dt, int up_per, int down_per, int car_amt, int bus_ga, int mng_ga, int bus_new_ga)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		if(dept.equals("0002")){
			bs_dt = bs_dt2;
			be_dt = be_dt2;
			bus_ga = mng_ga;
		}

		query= 
"select u.dept_id, u.user_id, u.user_nm, "+
"       nvl(rent_cnt,0) rent_cnt, nvl(start_cnt,0) start_cnt, cnt1, nvl(r_rent_cnt,0) r_rent_cnt, nvl(r_start_cnt,0) r_start_cnt, to_char(r_cnt,'990.9') r_cnt, "+
"       day, to_char(r_cnt2,'90.9999') r_cnt2, "+
"       to_char(pre_cmp,'90.9999') pre_cmp, to_char(pre_cmp_ga,'90.9999') pre_cmp_ga, "+
"       c_day, to_char(cmp_discnt_per,'90.9999') cmp_discnt_per, "+
"       sum_cnt1, to_char(avg_cnt1,'90.9999') avg_cnt1, sum_r_cnt, to_char(avg_r_cnt, '90.9999') avg_r_cnt, to_char(sum_bus,'90.9999') sum_bus, to_char(avg_bus, '90.9999') avg_bus, to_char(avg_low_bus, '90.9999') avg_low_bus, "+
"       nvl(c_rent_cnt,0) C_RENT_CNT, nvl(c_start_cnt,0) C_START_CNT, nvl(c_cnt,0) C_CNT, "+
"       nvl(cr_rent_cnt,0) CR_RENT_CNT, nvl(cr_start_cnt,0) CR_START_CNT, nvl(cr_cnt,0) CR_CNT, "+
"       to_char(nvl(cr_cnt/cmp_discnt_per,0),'90.9999') DALSUNG, "+
"       round(cr_cnt*nvl(cr_cnt/cmp_discnt_per,0)*"+car_amt+",-3) AMT "+
"	from (select u.user_id, u.user_nm, nvl(a.cnt,0) c_rent_cnt, nvl(b.cnt,0) c_start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 c_cnt, nvl(c.cnt,0) cr_rent_cnt, nvl(d.cnt,0) cr_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 cr_cnt "+
"		         from "+
"					(select nvl(f.ext_agnt,c.bus_id) bus_id, count(0) cnt "+
"					    from cont c, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"					    where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"					    and nvl(c.use_yn,'Y')='Y' and f.rent_dt between '"+cs_dt+"' and '"+ce_dt+"' "+
"					    and c.rent_st in ('1','2','3','4','6') "+
"					    group by nvl(f.ext_agnt,c.bus_id) "+
"					) a, "+
"					(select nvl(f.ext_agnt,c.bus_id) bus_id, count(0) cnt "+
"					    from cont c, (select * from taecha where rent_fee>0) d, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"					    where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd and c.rent_mng_id = d.rent_mng_id(+) and c.rent_l_cd=d.rent_l_cd(+) and nvl(d.no,'0')='0' "+
"					    and nvl(c.use_yn,'Y')='Y' and nvl(f.rent_start_dt,d.car_rent_st) between '"+cs_dt+"' and '"+ce_dt+"' "+
"					    and c.rent_st in ('1','2','3','4','6') "+
"					    group by nvl(f.ext_agnt,c.bus_id) "+
"					) b, "+
"					(select a.bus_id, nvl(sum(a.cnt),0) cnt "+
"					from (	select a.ssn, nvl(f.ext_agnt,c.bus_id) bus_id, decode(count(0),0,0, 1,1, 2,1.5, 3,2, 4,2.5, 5,3, 6,3.5, 7,4, 8,4.5, 9,5, 10,5.5, 11,6, 12,6.5, 13,7, 14,7.5, 15,8, 16,8.5, 17,9, 18,9.5, 19,10, 10) cnt "+
"					        from cont c, client a, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"					        where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"					        and c.client_id = a.client_id and nvl(c.use_yn,'Y')='Y' "+
"					        and f.rent_dt between '"+cs_dt+"' and '"+ce_dt+"' "+
"					        and c.rent_st in ('1','2','3','4','6') "+
//"					        group by a.client_id "+
"					        group by a.ssn, nvl(f.ext_agnt,c.bus_id) "+
"					    ) a "+
"					group by a.bus_id "+
"					) c, "+
"					(select a.bus_id, nvl(sum(a.cnt),0) cnt "+
"					from (	select a.ssn, nvl(f.ext_agnt,c.bus_id) bus_id, decode(count(0),0,0, 1,1, 2,1.5, 3,2, 4,2.5, 5,3, 6,3.5, 7,4, 8,4.5, 9,5, 10,5.5, 11,6, 12,6.5, 13,7, 14,7.5, 15,8, 16,8.5, 17,9, 18,9.5, 19,10, 10) cnt "+
"					        from cont c, client a, (select * from taecha where rent_fee>0) d, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"					        where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd and c.rent_mng_id = d.rent_mng_id(+) and c.rent_l_cd=d.rent_l_cd(+) and nvl(d.no,'0')='0' "+
"					        and c.client_id = a.client_id and nvl(c.use_yn,'Y')='Y' "+
"					        and nvl(f.rent_start_dt,d.car_rent_st) between '"+cs_dt+"' and '"+ce_dt+"' "+
"					        and c.rent_st in ('1','2','3','4','6') "+
"					        group by a.ssn, nvl(f.ext_agnt,c.bus_id)"+
"					    ) a "+
"					group by a.bus_id "+
"					) d, users u "+
"		    	where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id=c.bus_id(+) and u.user_id=d.bus_id(+) and u.dept_id ='"+dept+"' and u.user_pos in ('사원','대리','과장') and u.use_yn='Y' and u.user_id not in ('000001','000015','000031') "+
"		 		) v, "+
"				(select dept_id, user_id, user_nm, rent_cnt, start_cnt, cnt1, r_rent_cnt, r_start_cnt, r_cnt, day, r_cnt2, "+
"						decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2)) pre_cmp, "+
"						decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+bus_ga+"/100 pre_cmp_ga, "+
"						TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, "+
"						(decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+bus_ga+"/100)*(TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1))) cmp_discnt_per "+
"						,sum_cnt1, avg_cnt1, sum_r_cnt, avg_r_cnt, sum_bus, avg_bus, avg_low_bus "+
"		        from "+
"		            (select u.dept_id, u.user_id, u.user_nm, nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1, nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"		                   TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+
"		            	   (nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2 "+
"		            from "+
"						(select nvl(f.ext_agnt,c.bus_id) bus_id, count(0) cnt "+
"						    from cont c, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"						    where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"						    and nvl(c.use_yn,'Y')='Y' and f.rent_dt between '"+bs_dt+"' and '"+be_dt+"' "+
"						    and c.rent_st in ('1','2','3','4','6') "+
"						    group by nvl(f.ext_agnt,c.bus_id) "+
"						) a, "+
"						(select nvl(f.ext_agnt,c.bus_id) bus_id, count(0) cnt "+
"						    from cont c, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"						    where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"						    and nvl(c.use_yn,'Y')='Y' and f.rent_start_dt between '"+bs_dt+"' and '"+be_dt+"' "+
"						    and c.rent_st in ('1','2','3','4','6') "+
"						    group by nvl(f.ext_agnt,c.bus_id) "+
"						) b, "+
"						(select a.bus_id, nvl(sum(a.cnt),0) cnt "+
"						from (	select a.ssn, nvl(f.ext_agnt,c.bus_id) bus_id, decode(count(0),0,0, 1,1, 2,1.5, 3,2, 4,2.5, 5,3, 6,3.5, 7,4, 8,4.5, 9,5, 10,5.5, 11,6, 12,6.5, 13,7, 14,7.5, 15,8, 16,8.5, 17,9, 18,9.5, 19,10, 10) cnt "+
"						        from cont c, client a, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"						        where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"						        and c.client_id = a.client_id and nvl(c.use_yn,'Y')='Y' "+
"						        and f.rent_dt between '"+bs_dt+"' and '"+be_dt+"' "+
"						        and c.rent_st in ('1','2','3','4','6') "+
"						        group by a.ssn, nvl(f.ext_agnt,c.bus_id) "+
"						    ) a "+
"						group by a.bus_id "+
"						) c, "+
"						(select a.bus_id, nvl(sum(a.cnt),0) cnt "+
"						from (	select a.ssn, nvl(f.ext_agnt,c.bus_id) bus_id, decode(count(0),0,0, 1,1, 2,1.5, 3,2, 4,2.5, 5,3, 6,3.5, 7,4, 8,4.5, 9,5, 10,5.5, 11,6, 12,6.5, 13,7, 14,7.5, 15,8, 16,8.5, 17,9, 18,9.5, 19,10, 10) cnt "+
"						        from cont c, client a, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"						        where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"						        and c.client_id = a.client_id and nvl(c.use_yn,'Y')='Y' "+
"						        and f.rent_start_dt between '"+bs_dt+"' and '"+be_dt+"' "+
"						        and c.rent_st in ('1','2','3','4','6') "+
"						        group by a.ssn, nvl(f.ext_agnt,c.bus_id)"+
"						    ) a "+
"						group by a.bus_id "+
"						) d, users u "+
"		            where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"		            and u.enter_dt<'20060331' and u.dept_id ='"+dept+"' and u.user_pos in ('사원','대리','과장') and u.use_yn='Y' "+
"		            ) s, "+
"		            (select  sum(cnt1) sum_cnt1, avg(cnt1) avg_cnt1, "+
"		                    sum(r_cnt) sum_r_cnt, avg(r_cnt) avg_r_cnt, "+
"		                    sum(r_cnt2) sum_bus, avg(r_cnt2) avg_bus, "+
"		                    avg(r_cnt2)*"+down_per+"/100 avg_low_bus			 "+
"		            from (select u.dept_id, u.user_id, u.user_nm, nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1, nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"								TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+
"		            			(nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2 "+
"						from "+
"							(select nvl(f.ext_agnt,c.bus_id) bus_id, count(0) cnt "+
"							    from cont c, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"							    where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"							    and nvl(c.use_yn,'Y')='Y' and f.rent_dt between '"+bs_dt+"' and '"+be_dt+"' "+
"							    and c.rent_st in ('1','2','3','4','6') "+
"							    group by nvl(f.ext_agnt,c.bus_id) "+
"							) a, "+
"							(select nvl(f.ext_agnt,c.bus_id) bus_id, count(0) cnt "+
"							    from cont c, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"							    where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"							    and nvl(c.use_yn,'Y')='Y' and f.rent_start_dt between '"+bs_dt+"' and '"+be_dt+"' "+
"							    and c.rent_st in ('1','2','3','4','6') "+
"							    group by nvl(f.ext_agnt,c.bus_id) "+
"							) b, "+
"							(select a.bus_id, nvl(sum(a.cnt),0) cnt "+
"							from (	select a.ssn, nvl(f.ext_agnt,c.bus_id) bus_id, decode(count(0),0,0, 1,1, 2,1.5, 3,2, 4,2.5, 5,3, 6,3.5, 7,4, 8,4.5, 9,5, 10,5.5, 11,6, 12,6.5, 13,7, 14,7.5, 15,8, 16,8.5, 17,9, 18,9.5, 19,10, 10) cnt "+
"							        from cont c, client a, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"							        where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"							        and c.client_id = a.client_id and nvl(c.use_yn,'Y')='Y' "+
"							        and f.rent_dt between '"+bs_dt+"' and '"+be_dt+"' "+
"							        and c.rent_st in ('1','2','3','4','6') "+
"							        group by a.ssn, nvl(f.ext_agnt,c.bus_id)"+
"							    ) a "+
"							group by a.bus_id "+
"							) c, "+
"							(select a.bus_id, nvl(sum(a.cnt),0) cnt "+
"							from (	select a.ssn, nvl(f.ext_agnt,c.bus_id) bus_id, decode(count(0),0,0, 1,1, 2,1.5, 3,2, 4,2.5, 5,3, 6,3.5, 7,4, 8,4.5, 9,5, 10,5.5, 11,6, 12,6.5, 13,7, 14,7.5, 15,8, 16,8.5, 17,9, 18,9.5, 19,10, 10) cnt "+
"							        from cont c, client a, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"							        where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"							        and c.client_id = a.client_id and nvl(c.use_yn,'Y')='Y' "+
"							        and f.rent_start_dt between '"+bs_dt+"' and '"+be_dt+"' "+
"							        and c.rent_st in ('1','2','3','4','6') "+
"							        group by a.ssn, nvl(f.ext_agnt,c.bus_id) "+
"							    ) a "+
"							group by a.bus_id "+
"							) d, users u "+
"						where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"						and u.enter_dt<'20060331' and u.dept_id ='"+dept+"' and u.user_pos in ('사원','대리','과장') and u.use_yn='Y' "+
"						) "+
"		            ) t "+
"		) u  "+
"	where u.user_id = v.user_id "+
"	order by dalsung desc, cmp_discnt_per ";

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
			System.out.println("[CampaignDatabase:getCmpleteDept(String bs_dt, String be_dt, String cs_dt, String ce_dt, int amt, int bus_up_per, int bus_down_per, int mng_up_per, int mng_down_per)]"+e);
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
	 * 부서별 할인치,기준치,포상금액 --영업부, 관리부
	 */
	public Vector getCmpleteDept2(String dept, String bs_dt, String be_dt, String bs_dt2, String be_dt2, String cs_dt, String ce_dt, int up_per, int down_per, int car_amt, int bus_ga, int mng_ga, int bus_new_ga)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		if(dept.equals("0002")){
			bs_dt = bs_dt2;
			be_dt = be_dt2;
			bus_ga = mng_ga;
		}

		query= 
"select u.dept_id, u.user_id, u.user_nm, "+
"       nvl(rent_cnt,0) rent_cnt, nvl(start_cnt,0) start_cnt, cnt1, nvl(r_rent_cnt,0) r_rent_cnt, nvl(r_start_cnt,0) r_start_cnt, to_char(r_cnt,'990.9') r_cnt, "+
"       day, to_char(r_cnt2,'90.9999') r_cnt2, "+
"       to_char(pre_cmp,'90.9999') pre_cmp, to_char(pre_cmp_ga,'90.9999') pre_cmp_ga, "+
"       c_day, to_char(cmp_discnt_per,'90.9999') cmp_discnt_per, "+
"       sum_cnt1, to_char(avg_cnt1,'90.9999') avg_cnt1, sum_r_cnt, to_char(avg_r_cnt, '90.9999') avg_r_cnt, to_char(sum_bus,'90.9999') sum_bus, to_char(avg_bus, '90.9999') avg_bus, to_char(avg_low_bus, '90.9999') avg_low_bus, "+
"       nvl(c_rent_cnt,0) C_RENT_CNT, nvl(c_start_cnt,0) C_START_CNT, nvl(c_cnt,0) C_CNT, "+
"       nvl(cr_rent_cnt,0) CR_RENT_CNT, nvl(cr_start_cnt,0) CR_START_CNT, nvl(cr_cnt,0) CR_CNT, "+
"       to_char(nvl(cr_cnt/cmp_discnt_per,0),'90.9999') DALSUNG, "+
"       round(cr_cnt*nvl(cr_cnt/cmp_discnt_per,0)*"+car_amt+",-3) AMT "+
"	from (select u.user_id, u.user_nm, nvl(a.cnt,0) c_rent_cnt, nvl(b.cnt,0) c_start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 c_cnt, nvl(c.cnt,0) cr_rent_cnt, nvl(d.cnt,0) cr_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 cr_cnt "+
"		         from "+
"					(select nvl(f.ext_agnt,c.bus_id) bus_id, count(0) cnt "+
"					    from cont c, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"					    where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"					    and nvl(c.use_yn,'Y')='Y' and f.rent_dt between '"+cs_dt+"' and '"+ce_dt+"' "+
"					    and c.rent_st in ('1','2','3','4','6') "+
"					    group by nvl(f.ext_agnt,c.bus_id) "+
"					) a, "+
"					(select nvl(f.ext_agnt,c.bus_id) bus_id, count(0) cnt "+
"					    from cont c, (select * from taecha where rent_fee>0) d, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"					    where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd and c.rent_mng_id = d.rent_mng_id(+) and c.rent_l_cd=d.rent_l_cd(+) and nvl(d.no,'0')='0' "+
"					    and nvl(c.use_yn,'Y')='Y' and nvl(f.rent_start_dt,d.car_rent_st) between '"+cs_dt+"' and '"+ce_dt+"' "+
"					    and c.rent_st in ('1','2','3','4','6') "+
"					    group by nvl(f.ext_agnt,c.bus_id) "+
"					) b, "+
"					(select a.bus_id, nvl(sum(a.cnt),0) cnt "+
"					from (	select a.ssn, nvl(f.ext_agnt,c.bus_id) bus_id, decode(count(0),0,0, 1,1, 2,1.5, 3,2, 4,2.5, 5,3, 6,3.5, 7,4, 8,4.5, 9,5, 10,5.5, 11,6, 12,6.5, 13,7, 14,7.5, 15,8, 16,8.5, 17,9, 18,9.5, 19,10, 10) cnt "+
"					        from cont c, client a, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"					        where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"					        and c.client_id = a.client_id and nvl(c.use_yn,'Y')='Y' "+
"					        and f.rent_dt between '"+cs_dt+"' and '"+ce_dt+"' "+
"					        and c.rent_st in ('1','2','3','4','6') "+
"					        group by a.ssn, nvl(f.ext_agnt,c.bus_id) "+
"					    ) a "+
"					group by a.bus_id "+
"					) c, "+
"					(select a.bus_id, nvl(sum(a.cnt),0) cnt "+
"					from (	select a.ssn, nvl(f.ext_agnt,c.bus_id) bus_id, decode(count(0),0,0, 1,1, 2,1.5, 3,2, 4,2.5, 5,3, 6,3.5, 7,4, 8,4.5, 9,5, 10,5.5, 11,6, 12,6.5, 13,7, 14,7.5, 15,8, 16,8.5, 17,9, 18,9.5, 19,10, 10) cnt "+
"					        from cont c, client a, (select * from taecha where rent_fee>0) d, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"					        where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd and c.rent_mng_id = d.rent_mng_id(+) and c.rent_l_cd=d.rent_l_cd(+) and nvl(d.no,'0')='0' "+
"					        and c.client_id = a.client_id and nvl(c.use_yn,'Y')='Y' "+
"					        and nvl(f.rent_start_dt,d.car_rent_st) between '"+cs_dt+"' and '"+ce_dt+"' "+
"					        and c.rent_st in ('1','2','3','4','6') "+
"					        group by a.ssn, nvl(f.ext_agnt,c.bus_id)"+
"					    ) a "+
"					group by a.bus_id "+
"					) d, users u "+
"		    	where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id=c.bus_id(+) and u.user_id=d.bus_id(+) and u.dept_id ='"+dept+"' and u.user_pos in ('사원','대리','과장') and u.use_yn='Y' and u.user_id not in ('000001','000015','000031') "+
"		 		) v, "+
"				(select dept_id, user_id, user_nm, rent_cnt, start_cnt, cnt1, r_rent_cnt, r_start_cnt, r_cnt, day, r_cnt2, "+
"						decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2)) pre_cmp, "+
"						decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+bus_ga+"/100 pre_cmp_ga, "+
"						TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, "+
"						(decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+bus_ga+"/100)*(TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1))) cmp_discnt_per "+
"						,sum_cnt1, avg_cnt1, sum_r_cnt, avg_r_cnt, sum_bus, avg_bus, avg_low_bus "+
"		        from "+
"		            (select u.dept_id, u.user_id, u.user_nm, nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1, nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"		                   TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+
"		            	   (nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2 "+
"		            from "+
"						(select nvl(f.ext_agnt,c.bus_id) bus_id, count(0) cnt "+
"						    from cont c, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"						    where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"						    and nvl(c.use_yn,'Y')='Y' and f.rent_dt between '"+bs_dt+"' and '"+be_dt+"' "+
"						    and c.rent_st in ('1','2','3','4','6') "+
"						    group by nvl(f.ext_agnt,c.bus_id) "+
"						) a, "+
"						(select nvl(f.ext_agnt,c.bus_id) bus_id, count(0) cnt "+
"						    from cont c, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"						    where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"						    and nvl(c.use_yn,'Y')='Y' and f.rent_start_dt between '"+bs_dt+"' and '"+be_dt+"' "+
"						    and c.rent_st in ('1','2','3','4','6') "+
"						    group by nvl(f.ext_agnt,c.bus_id) "+
"						) b, "+
"						(select a.bus_id, nvl(sum(a.cnt),0) cnt "+
"						from (	select a.ssn, nvl(f.ext_agnt,c.bus_id) bus_id, decode(count(0),0,0, 1,1, 2,1.5, 3,2, 4,2.5, 5,3, 6,3.5, 7,4, 8,4.5, 9,5, 10,5.5, 11,6, 12,6.5, 13,7, 14,7.5, 15,8, 16,8.5, 17,9, 18,9.5, 19,10, 10) cnt "+
"						        from cont c, client a, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"						        where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"						        and c.client_id = a.client_id and nvl(c.use_yn,'Y')='Y' "+
"						        and f.rent_dt between '"+bs_dt+"' and '"+be_dt+"' "+
"						        and c.rent_st in ('1','2','3','4','6') "+
"						        group by a.ssn, nvl(f.ext_agnt,c.bus_id) "+
"						    ) a "+
"						group by a.bus_id "+
"						) c, "+
"						(select a.bus_id, nvl(sum(a.cnt),0) cnt "+
"						from (	select a.ssn, nvl(f.ext_agnt,c.bus_id) bus_id, decode(count(0),0,0, 1,1, 2,1.5, 3,2, 4,2.5, 5,3, 6,3.5, 7,4, 8,4.5, 9,5, 10,5.5, 11,6, 12,6.5, 13,7, 14,7.5, 15,8, 16,8.5, 17,9, 18,9.5, 19,10, 10) cnt "+
"						        from cont c, client a, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"						        where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"						        and c.client_id = a.client_id and nvl(c.use_yn,'Y')='Y' "+
"						        and f.rent_start_dt between '"+bs_dt+"' and '"+be_dt+"' "+
"						        and c.rent_st in ('1','2','3','4','6') "+
"						        group by a.ssn, nvl(f.ext_agnt,c.bus_id)"+
"						    ) a "+
"						group by a.bus_id "+
"						) d, users u "+
"		            where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"		            and u.enter_dt<'20060331' and u.dept_id ='"+dept+"' and u.user_pos in ('사원','대리','과장') and u.use_yn='Y' "+
"		            ) s, "+
"		            (select  sum(cnt1) sum_cnt1, avg(cnt1) avg_cnt1, "+
"		                    sum(r_cnt) sum_r_cnt, avg(r_cnt) avg_r_cnt, "+
"		                    sum(r_cnt2) sum_bus, avg(r_cnt2) avg_bus, "+
"		                    avg(r_cnt2)*"+down_per+"/100 avg_low_bus			 "+
"		            from (select u.dept_id, u.user_id, u.user_nm, nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1, nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"								TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+
"		            			(nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2 "+
"						from "+
"							(select nvl(f.ext_agnt,c.bus_id) bus_id, count(0) cnt "+
"							    from cont c, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"							    where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"							    and nvl(c.use_yn,'Y')='Y' and f.rent_dt between '"+bs_dt+"' and '"+be_dt+"' "+
"							    and c.rent_st in ('1','2','3','4','6') "+
"							    group by nvl(f.ext_agnt,c.bus_id) "+
"							) a, "+
"							(select nvl(f.ext_agnt,c.bus_id) bus_id, count(0) cnt "+
"							    from cont c, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"							    where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"							    and nvl(c.use_yn,'Y')='Y' and f.rent_start_dt between '"+bs_dt+"' and '"+be_dt+"' "+
"							    and c.rent_st in ('1','2','3','4','6') "+
"							    group by nvl(f.ext_agnt,c.bus_id) "+
"							) b, "+
"							(select a.bus_id, nvl(sum(a.cnt),0) cnt "+
"							from (	select a.ssn, nvl(f.ext_agnt,c.bus_id) bus_id, decode(count(0),0,0, 1,1, 2,1.5, 3,2, 4,2.5, 5,3, 6,3.5, 7,4, 8,4.5, 9,5, 10,5.5, 11,6, 12,6.5, 13,7, 14,7.5, 15,8, 16,8.5, 17,9, 18,9.5, 19,10, 10) cnt "+
"							        from cont c, client a, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"							        where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"							        and c.client_id = a.client_id and nvl(c.use_yn,'Y')='Y' "+
"							        and f.rent_dt between '"+bs_dt+"' and '"+be_dt+"' "+
"							        and c.rent_st in ('1','2','3','4','6') "+
"							        group by a.ssn, nvl(f.ext_agnt,c.bus_id)"+
"							    ) a "+
"							group by a.bus_id "+
"							) c, "+
"							(select a.bus_id, nvl(sum(a.cnt),0) cnt "+
"							from (	select a.ssn, nvl(f.ext_agnt,c.bus_id) bus_id, decode(count(0),0,0, 1,1, 2,1.5, 3,2, 4,2.5, 5,3, 6,3.5, 7,4, 8,4.5, 9,5, 10,5.5, 11,6, 12,6.5, 13,7, 14,7.5, 15,8, 16,8.5, 17,9, 18,9.5, 19,10, 10) cnt "+
"							        from cont c, client a, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"							        where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"							        and c.client_id = a.client_id and nvl(c.use_yn,'Y')='Y' "+
"							        and f.rent_start_dt between '"+bs_dt+"' and '"+be_dt+"' "+
"							        and c.rent_st in ('1','2','3','4','6') "+
"							        group by a.ssn, nvl(f.ext_agnt,c.bus_id) "+
"							    ) a "+
"							group by a.bus_id "+
"							) d, users u "+
"						where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"						and u.enter_dt<'20060331' and u.dept_id ='"+dept+"' and u.user_pos in ('사원','대리','과장') and u.use_yn='Y' "+
"						) "+
"		            ) t "+
"		) u  "+
"	where u.user_id = v.user_id "+
"	order by dalsung desc, cmp_discnt_per ";

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
			System.out.println("[CampaignDatabase:getCmpleteDept2(String bs_dt, String be_dt, String cs_dt, String ce_dt, int amt, int bus_up_per, int bus_down_per, int mng_up_per, int mng_down_per)]"+e);
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
	 * 부서별 할인치,기준치,포상금액 --신입사원
	 */
	public Vector getCmpleteDeptNew(int cnt1, int mon, String cnt2, String cs_dt, String ce_dt, String bs_dt, String be_dt, float cmp_discnt_per, int car_amt, int bus_new_ga)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query= 
"	select dept_id, u.bus_id, u.user_nm, cnt1, to_char(cnt1,'990.9') r_cnt, day, to_char(r_cnt2,'90.9999') r_cnt2, to_char(pre_cmp,'90.9999') pre_cmp, to_char(pre_cmp_ga,'90.9999') pre_cmp_ga, c_day, to_char(cmp_discnt_per,'90.9999') cmp_discnt_per, "+
"			C_RENT_CNT, C_START_CNT, to_char(c_cnt,'990.9') C_CNT, to_char(cr_rent_cnt,'990.9') CR_RENT_CNT, to_char(cr_start_cnt,'990.9') CR_START_CNT, to_char(cr_cnt,'990.99') CR_CNT, to_char(nvl(cr_cnt/cmp_discnt_per,0),'90.9999') DALSUNG, round(cr_cnt*nvl(cr_cnt/cmp_discnt_per,0)*"+car_amt+",-3) AMT "+
"	from (select u.user_id, u.user_nm, nvl(a.cnt,0) c_rent_cnt, nvl(b.cnt,0) c_start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 c_cnt, nvl(c.cnt,0) cr_rent_cnt, nvl(d.cnt,0) cr_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 cr_cnt "+
"		         from "+
"					(select nvl(f.ext_agnt,c.bus_id) bus_id, count(0) cnt "+
"					    from cont c, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"					    where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"					    and nvl(c.use_yn,'Y')='Y' and f.rent_dt between '"+cs_dt+"' and '"+ce_dt+"' "+
"					    and c.rent_st in ('1','2','3','4','6') "+
"					    group by nvl(f.ext_agnt,c.bus_id) "+
"					) a, "+
"					(select nvl(f.ext_agnt,c.bus_id) bus_id, count(0) cnt "+
"					    from cont c, (select * from taecha where rent_fee>0) d, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"					    where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd and c.rent_mng_id = d.rent_mng_id(+) and c.rent_l_cd=d.rent_l_cd(+) and nvl(d.no,'0')='0' "+
"					    and nvl(c.use_yn,'Y')='Y' and nvl(f.rent_start_dt,d.car_rent_st) between '"+cs_dt+"' and '"+ce_dt+"' "+
"					    and c.rent_st in ('1','2','3','4','6') "+
"					    group by nvl(f.ext_agnt,c.bus_id) "+
"					) b, "+
"					(select a.bus_id, nvl(sum(a.cnt),0) cnt "+
"					from (	select a.ssn, nvl(f.ext_agnt,c.bus_id) bus_id, decode(count(0),0,0, 1,1, 2,1.5, 3,2, 4,2.5, 5,3, 6,3.5, 7,4, 8,4.5, 9,5, 10,5.5, 11,6, 12,6.5, 13,7, 14,7.5, 15,8, 16,8.5, 17,9, 18,9.5, 19,10, 10) cnt "+
"					        from cont c, client a, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"					        where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
"					        and c.client_id = a.client_id and nvl(c.use_yn,'Y')='Y' "+
"					        and f.rent_dt between '"+cs_dt+"' and '"+ce_dt+"' "+
"					        and c.rent_st in ('1','2','3','4','6') "+
"					        group by a.ssn, nvl(f.ext_agnt,c.bus_id) "+
"					    ) a "+
"					group by a.bus_id "+
"					) c, "+
"					(select a.bus_id, nvl(sum(a.cnt),0) cnt "+
"					from (	select a.ssn, nvl(f.ext_agnt,c.bus_id) bus_id, decode(count(0),0,0, 1,1, 2,1.5, 3,2, 4,2.5, 5,3, 6,3.5, 7,4, 8,4.5, 9,5, 10,5.5, 11,6, 12,6.5, 13,7, 14,7.5, 15,8, 16,8.5, 17,9, 18,9.5, 19,10, 10) cnt "+
"					        from cont c, client a, (select * from taecha where rent_fee>0) d, (select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
"					        where c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd and c.rent_mng_id = d.rent_mng_id(+) and c.rent_l_cd=d.rent_l_cd(+) and nvl(d.no,'0')='0' "+
"					        and c.client_id = a.client_id and nvl(c.use_yn,'Y')='Y' "+
"					        and nvl(f.rent_start_dt,d.car_rent_st) between '"+cs_dt+"' and '"+ce_dt+"' "+
"					        and c.rent_st in ('1','2','3','4','6') "+
"					        group by a.ssn, nvl(f.ext_agnt,c.bus_id) "+
"					    ) a "+
"					group by a.bus_id "+
"					) d, users u "+
"		    	where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id=c.bus_id(+) and u.user_id=d.bus_id(+) and u.dept_id ='0001' and u.user_pos in ('사원','대리','과장') and u.use_yn='Y' and u.user_id not in ('000001','000015','000031') "+
"		 ) v, "+
"		(	select '0001' dept_id, '000059' bus_id, '김영호' user_nm,"+cnt1+" cnt1, "+cnt1+" r_cnt, TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) pre_cmp, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100 pre_cmp_ga, TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, ("+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100)*TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) cmp_discnt_per from dual "+
"			union "+
"			select '0001' dept_id, '000060' bus_id, '최인석' user_nm,"+cnt1+" cnt1, "+cnt1+" r_cnt, TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) pre_cmp, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100 pre_cmp_ga, TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, ("+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100)*TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) cmp_discnt_per from dual "+
"			union "+
"			select '0001' dept_id, '000061' bus_id, '황선문' user_nm,"+cnt1+" cnt1, "+cnt1+" r_cnt, TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) pre_cmp, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100 pre_cmp_ga, TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, ("+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100)*TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) cmp_discnt_per from dual "+
"			order by 1 "+
"		) u "+
"	where u.bus_id = v.user_id "+
"	order by dalsung desc, cmp_discnt_per ";

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
			System.out.println("[CampaignDatabase:getCmpleteDeptNew(String bs_dt, String be_dt, String cs_dt, String ce_dt, int amt, int bus_up_per, int bus_down_per, int mng_up_per, int mng_down_per)]"+e);
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


	//켐페인계산 jhm------------------------------------------------------------------------------------------





	//영업증진캠페인 기간 조회 쿼리문 리턴 - 총실적
    public static String getCampaignQuery(String type, String start_dt, String end_dt) 
    {
    	String query = "";		

		query =		"SELECT"+
					"	bus_id, count(0) cnt "+
					"FROM ("+
					"	SELECT nvl(f.ext_agnt,c.bus_id) bus_id, f.rent_l_cd"+
					"	FROM cont c, cls_cont b,"+
					"		(select * from taecha where rent_fee>0) d, "+
					"		(select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
					"	WHERE "+
					"		c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd and c.rent_mng_id = d.rent_mng_id(+) and c.rent_l_cd=d.rent_l_cd(+) and nvl(d.no,'0')='0' and c.rent_l_cd=b.rent_l_cd(+)"+
					"		and nvl(b.cls_st,'0') not in ('3','4','5')"+
					"		and to_number(f.con_mon)>=6";

			if(type.equals("rent_dt"))		query += " and nvl(f.rent_dt,c.rent_dt) between '"+start_dt+"' and '"+end_dt+"' ";				
			else							query += " and nvl(f.rent_start_dt,d.car_rent_st) between '"+start_dt+"' and '"+end_dt+"' ";//nvl(f.rent_start_dt,d.car_rent_st)
			

		//6개월미만계약-실이용6개월초과시점 기간내
		query +=	"	UNION"+
					"	SELECT nvl(a.ext_agnt,b.bus_id) bus_id, a.rent_l_cd"+
					"	from fee a, cont b, (select rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_l_cd) c, cls_cont d"+
					"	where"+
					"	a.rent_l_cd=b.rent_l_cd"+
					"	and a.rent_l_cd=c.rent_l_cd and a.rent_st=c.rent_st"+
					"	and a.rent_l_cd=d.rent_l_cd(+)"+
					"	and to_char(add_months(to_date(a.rent_start_dt,'YYYYMMDD'),6),'YYYYMMDD') between '"+start_dt+"' and '"+end_dt+"'"+
					"	and b.car_st<>'2' "+
					"	and to_number(a.con_mon) < 6"+
					"	and trunc(months_between(nvl(to_date(d.cls_dt,'YYYYMMDD'),sysdate),to_date(a.rent_start_dt,'YYYYMMDD')-1),0)>=6";

		query +=	") GROUP BY bus_id";
		
    	return query;
    }

	//영업증진캠페인 기간 조회 쿼리문 리턴 - 유효실적
    public static String getCampaignQuery2(String type, String start_dt, String end_dt) 
    {
    	String query = "";		

		query =		"SELECT"+
					"	bus_id, nvl(sum(cnt),0) cnt "+
					"FROM ( "+
					"	SELECT"+
					"		ssn, bus_id, decode(count(0),0,0, 1,1, 2,1.5, 3,2, 4,2.5, 5,3, 6,3.5, 7,4, 8,4.5, 9,5, 10,5.5, 11,6, 12,6.5, 13,7, 14,7.5, 15,8, 16,8.5, 17,9, 18,9.5, 19,10, 10) cnt "+
					"	FROM ("+
					"		SELECT a.ssn, nvl(f.ext_agnt,c.bus_id) bus_id, c.rent_l_cd"+
					"		FROM "+
					"			cont c,  cls_cont b,"+
					"			client a, "+
					"			(select * from taecha where rent_fee>0) d, "+
					"			(select * from fee a where a.rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id=rent_mng_id and a.rent_l_cd=rent_l_cd) ) f "+
					"		WHERE "+
					"			c.rent_mng_id = f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
					"			and c.client_id = a.client_id and c.rent_mng_id = d.rent_mng_id(+) and c.rent_l_cd=d.rent_l_cd(+) and nvl(d.no,'0')='0' and c.rent_l_cd=b.rent_l_cd(+)"+
					"			and nvl(b.cls_st,'0') not in ('3','4','5')"+
					"			and to_number(f.con_mon)>=6";

		if(type.equals("rent_dt"))		query += " and nvl(f.rent_dt,c.rent_dt) between '"+start_dt+"' and '"+end_dt+"' ";
		else							query += " and nvl(f.rent_start_dt,d.car_rent_st) between '"+start_dt+"' and '"+end_dt+"' ";

			
		//6개월미만계약-실이용6개월초과시점 기간내
		query +=	"		UNION"+
					"		SELECT e.ssn, nvl(a.ext_agnt,b.bus_id) bus_id, a.rent_l_cd"+
					"		FROM fee a, cont b, (select rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_l_cd) c, cls_cont d, client e"+
					"		WHERE"+
					"			a.rent_l_cd=b.rent_l_cd and b.client_id=e.client_id"+
					"			and a.rent_l_cd=c.rent_l_cd and a.rent_st=c.rent_st"+
					"			and a.rent_l_cd=d.rent_l_cd(+)"+
					"			and b.car_st<>'2'"+
					"			and to_number(a.con_mon) < 6"+
					"			and trunc(months_between(nvl(to_date(d.cls_dt,'YYYYMMDD'),sysdate),to_date(a.rent_start_dt,'YYYYMMDD')-1),0)>=6"+
					"			and to_char(add_months(to_date(a.rent_start_dt,'YYYYMMDD'),6),'YYYYMMDD') between '"+start_dt+"' and '"+end_dt+"'";

		query +=	"	) GROUP BY ssn, bus_id"+
					") "+
					"GROUP BY bus_id order BY bus_id";

    	return query;
    }

	/**
	 * 결과 : 2006-12 6개월미만계약실사용6개월초과분인정/6개월이상실사용6개월이전해지감점 처리
	*/
	public Vector getCampaign_200612(String bs_dt, String be_dt, String bs_dt2, String be_dt2, String cs_dt, String ce_dt, int car_amt, int bus_up_per, int bus_down_per, int mng_up_per, int mng_down_per, int bus_amt_per, int mng_amt_per, int cnt1, int mon, String cnt2, float cmp_discnt_per, int max_dalsung, int bus_ga, int mng_ga, int bus_new_ga)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String client_11 = "";

		//-------------------------------------------------------------------------------------------
		//cs_dt~ce_dt  : 켐페인기간
		//bs_dt~be_dt  : 영업부 평가기준기간
		//bs_dt2~be_dt : 관리부 평가기준기간

		String a_cam	= getCampaignQuery("rent_dt",  cs_dt, ce_dt);
		String a_bas	= getCampaignQuery("rent_dt", bs_dt,  be_dt);
		String a_bas2	= getCampaignQuery("rent_dt", bs_dt2, be_dt2);

		String b_cam	= getCampaignQuery("rent_start_dt", cs_dt, ce_dt);
		String b_bas	= getCampaignQuery("rent_start_dt", bs_dt,  be_dt);
		String b_bas2	= getCampaignQuery("rent_start_dt", bs_dt2, be_dt2);

		String c_cam	= getCampaignQuery2("rent_dt", cs_dt, ce_dt);
		String c_bas	= getCampaignQuery2("rent_dt", bs_dt,  be_dt);
		String c_bas2	= getCampaignQuery2("rent_dt", bs_dt2, be_dt2);

		String d_cam	= getCampaignQuery2("rent_start_dt", cs_dt, ce_dt);
		String d_bas	= getCampaignQuery2("rent_start_dt", bs_dt,  be_dt);
		String d_bas2	= getCampaignQuery2("rent_start_dt", bs_dt2, be_dt2);

		//출고전해지 감소처리-캠페인기간:해지일기준-켐페인기간3개월전계약
		String e_cam =  "select b.bus_id, count(0) cnt "+
						"from cls_cont a, cont b "+
						"where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd  "+
						"	and cls_st in ('7','10')  "+
						"	and cls_dt between '"+cs_dt+"' and '"+ce_dt+"' "+
						"	and b.rent_dt between to_char(add_months('"+cs_dt+"',-3),'yyyymmdd') and to_char(add_months('"+ce_dt+"',-3),'yyyymmdd') "+
						"group by b.bus_id";

		//6개월전해지 감소처리-캠페인기간:대여개시일기준-6개월이전해지계약
		String f_cam =  "select nvl(a.ext_agnt,b.bus_id) bus_id, count(0) cnt "+
						"from fee a, cont b, (select rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_l_cd) c, cls_cont d "+
						"where "+
						"a.rent_l_cd=b.rent_l_cd "+
						"and a.rent_l_cd=c.rent_l_cd and a.rent_st=c.rent_st "+
						"and a.rent_l_cd=d.rent_l_cd "+
						"and b.car_st<>'2' "+
						"and d.cls_st in ('1','2') "+
						"and b.rent_st not in ('5','7') "+
						"and d.cls_dt between '"+cs_dt+"' and '"+ce_dt+"' "+
						"and to_char(add_months(to_date(b.rent_dt,'YYYYMMDD')-1,6),'YYYYMMDD') > d.cls_dt "+
						"group by nvl(a.ext_agnt,b.bus_id)";

		//신입사원 기준일자
		String enter_dt = "20060331";
		//-------------------------------------------------------------------------------------------

		String query = "";

		double avg_dalsung2 = this.getAvg_Dalsung2(bs_dt, be_dt, bs_dt2, be_dt2, cs_dt, ce_dt, car_amt, bus_up_per, bus_down_per, mng_up_per, mng_down_per, bus_amt_per, mng_amt_per, cnt1, mon, cnt2, cmp_discnt_per, max_dalsung, bus_ga, mng_ga, bus_new_ga);

		query=
"	select"+
"		dept_id, user_id, user_nm, cnt1, r_cnt, day, r_cnt2, pre_cmp, pre_cmp_ga, c_day, "+
"		to_char(cmp_discnt_per,'90.99') cmp_discnt_per, "+
"		sum_cnt1, avg_cnt1, sum_r_cnt, avg_r_cnt, sum_bus, avg_bus, avg_low_bus, "+
"		to_char(c_cnt,'990.9') C_CNT, to_char(cr_cnt,'990.99') CR_CNT, to_char(dalsung*100,'9990.99') DALSUNG,"+
"		round("+avg_dalsung2+",4)*100 AVG_DALSUNG, "+
"		round(decode(sign("+avg_dalsung2+" - dalsung), -1, decode(dept_id, '0001', amt*"+bus_amt_per+"/100, '0002',amt*"+mng_amt_per+"/100, 0), 0),-3) AMT "+
"	from "+
"		(select "+
"			u.dept_id, u.user_id, u.user_nm, rent_cnt, start_cnt, cnt1, r_rent_cnt, r_start_cnt, r_cnt, day, r_cnt2,"+
"			pre_cmp, pre_cmp_ga, c_day, cmp_discnt_per, sum_cnt1, avg_cnt1, sum_r_cnt, avg_r_cnt, sum_bus, avg_bus, avg_low_bus,"+
"			nvl(c_rent_cnt,0) C_RENT_CNT, nvl(c_start_cnt,0) C_START_CNT, nvl(c_cnt,0) C_CNT,"+
"			nvl(cr_rent_cnt,0) CR_RENT_CNT, nvl(cr_start_cnt,0) CR_START_CNT, nvl(cr_cnt,0) CR_CNT,"+
"			nvl(cr_cnt/cmp_discnt_per,0) ORG_DALSUNG,"+
"			nvl(decode(sign("+max_dalsung+"/100-(cr_cnt/cmp_discnt_per)),-1, "+max_dalsung+"/100,(cr_cnt/cmp_discnt_per)),0) DALSUNG, "+
"			cr_cnt*nvl(decode(sign("+max_dalsung+"/100-(cr_cnt/cmp_discnt_per)),-1, "+max_dalsung+"/100, (cr_cnt/cmp_discnt_per)),0)*"+car_amt+" AMT "+
"		from "+
			//v => 캠페인기간 실적조회 : a,b 무시 / c(a확대),d(b확대),e 활용
"			(select u.user_id, u.user_nm,"+
"				nvl(a.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0) c_rent_cnt,"+
"				nvl(b.cnt,0)-nvl(f.cnt,0) c_start_cnt, "+
"				( nvl(a.cnt,0)+nvl(b.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0)-nvl(f.cnt,0) )/2 c_cnt, "+
"				nvl(c.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0) cr_rent_cnt,"+
"				nvl(d.cnt,0)-nvl(f.cnt,0) cr_start_cnt,"+
"				( nvl(c.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0)+nvl(d.cnt,0)-nvl(f.cnt,0) )/2 cr_cnt "+
"			from "+
"				("+a_cam+") a, "+
"				("+b_cam+") b, "+
"				("+c_cam+") c, "+
"				("+d_cam+") d, "+
"				("+e_cam+") e, "+
"				("+f_cam+") f, "+
"				users u  "+
"		    where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id=c.bus_id(+) and u.user_id=d.bus_id(+) and u.user_id=e.bus_id(+) and u.user_id=f.bus_id(+)"+
"				and u.dept_id in('0001','0002') and u.user_pos in ('사원','대리','과장') and u.use_yn='Y' and u.user_id not in ('000001','000015','000031')  "+
"		 	) v, "+
			//u => 평가기준기간 실적조회 - 영업부 union 관리부 union 신입사원
"			("+
			//영업부 평가기준기간 실적조회
"			select"+
"				dept_id, user_id, user_nm,"+
"				rent_cnt, start_cnt, cnt1, r_rent_cnt, r_start_cnt, r_cnt, day, r_cnt2, "+
"				decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+bus_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2)) pre_cmp, "+
"				decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+bus_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+bus_ga+"/100 pre_cmp_ga, "+
"				TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, "+
"				(decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+bus_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+bus_ga+"/100)*(TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1))) cmp_discnt_per, "+
"				sum_cnt1, avg_cnt1, sum_r_cnt, avg_r_cnt, sum_bus, avg_bus, avg_low_bus "+
"		    from "+
				//s => 영업부직원별 평가기준기간 실적조회
"				(select u.dept_id, u.user_id, u.user_nm, "+
"					nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1,"+
"					nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"		            TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+
"		            (nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2 "+
"		        from "+
"					("+a_bas+") a, "+
"					("+b_bas+") b, "+
"					("+c_bas+") c, "+
"					("+d_bas+") d, "+
"					users u "+
"		        where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"					and u.enter_dt<'"+enter_dt+"' and u.dept_id ='0001' and u.user_pos in ('사원','대리','과장') and u.use_yn='Y' "+
"				) s, "+
				//t => 영업부직원별 평가기준기간 실적 합계 및 평균 조회
"		        (select "+
"					sum(cnt1) sum_cnt1, avg(cnt1) avg_cnt1, "+
"		            sum(r_cnt) sum_r_cnt, avg(r_cnt) avg_r_cnt, "+
"		            sum(r_cnt2) sum_bus, avg(r_cnt2) avg_bus, "+
"		            avg(r_cnt2)*"+bus_down_per+"/100 avg_low_bus "+
"		        from "+
"					(select u.dept_id, u.user_id, u.user_nm, "+
"						nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1,"+
"						nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"						TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+
"		            	(nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2 "+
"					from "+
"						("+a_bas+") a, "+
"						("+b_bas+") b, "+
"						("+c_bas+") c, "+
"						("+d_bas+") d, "+
"						users u "+
"					where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"						and u.enter_dt<'"+enter_dt+"' and u.dept_id ='0001' and u.user_pos in ('사원','대리','과장') and u.use_yn='Y' "+
"					) "+
"		        ) t "+
"			union "+
			//관리부 평가기준기간 실적조회
"			select dept_id, user_id, user_nm,"+
"				rent_cnt, start_cnt, cnt1, r_rent_cnt, r_start_cnt, r_cnt, day, r_cnt2, "+
"				decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+mng_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2)) pre_cmp, "+
"				decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+mng_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+mng_ga+"/100 pre_cmp_ga, "+
"				TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, "+
"				(decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+mng_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+mng_ga+"/100)*(TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1))) cmp_discnt_per, "+
"				sum_cnt1, avg_cnt1, sum_r_cnt, avg_r_cnt, sum_bus, avg_bus, avg_low_bus "+
"		    from "+
				//s => 관리부직원별 평가기준기간 실적조회
"				(select u.dept_id, u.user_id, u.user_nm,"+
"					nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1, "+
"					nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"		            TRUNC(MONTHS_BETWEEN('"+be_dt2+"','"+bs_dt2+"') * 30.5) day, "+
"		           (nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt2+"','"+bs_dt2+"') * 30.5) r_cnt2 "+
"		        from "+
"					("+a_bas2+") a, "+
"					("+b_bas2+") b, "+
"					("+c_bas2+") c, "+
"					("+d_bas2+") d, "+
"					users u "+
"		        where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"		            and u.enter_dt<'"+enter_dt+"' and u.dept_id ='0002' and u.user_pos in ('사원','대리','과장') and u.use_yn='Y' "+
"		        ) s, "+
				//t => 관리부직원별 평가기준기간 실적 합계 및 평균 조회
"		        (select "+
"					sum(cnt1) sum_cnt1, avg(cnt1) avg_cnt1, "+
"		            sum(r_cnt) sum_r_cnt, avg(r_cnt) avg_r_cnt, "+
"		            sum(r_cnt2) sum_bus, avg(r_cnt2) avg_bus, "+
"		            avg(r_cnt2)*"+mng_down_per+"/100 avg_low_bus "+
"		        from "+
"					(select u.dept_id, u.user_id, u.user_nm, "+
"						nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1, "+
"						nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"						TRUNC(MONTHS_BETWEEN('"+be_dt2+"','"+bs_dt2+"') * 30.5) day, "+
"		            	(nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt2+"','"+bs_dt2+"') * 30.5) r_cnt2 "+
"					from "+
"						("+a_bas2+") a, "+
"						("+b_bas2+") b, "+
"						("+c_bas2+") c, "+
"						("+d_bas2+") d, "+
"						users u "+
"					where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"						and u.enter_dt<'"+enter_dt+"' and u.dept_id ='0002' and u.user_pos in ('사원','대리','과장') and u.use_yn='Y' "+
"					) "+
"		        ) t "+
"			union "+	
			//신입사원 평가기준기간 고정셋팅
"			select '0001' dept_id, '000059' user_id, '김영호' user_nm, "+cnt1+" rent_cnt, "+cnt1+" start_cnt, "+cnt1+" cnt1, "+cnt1+" r_rent_cnt, "+cnt1+" r_start_cnt, "+cnt1+" r_cnt, TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) pre_cmp, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100 pre_cmp_ga, TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, ("+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100)*TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) cmp_discnt_per, 0, 0, 0, 0, 0, 0, 0 from dual "+
"			union "+
"			select '0001' dept_id, '000060' user_id, '최인석' user_nm, "+cnt1+" rent_cnt, "+cnt1+" start_cnt, "+cnt1+" cnt1, "+cnt1+" r_rent_cnt, "+cnt1+" r_start_cnt, "+cnt1+" r_cnt, TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) pre_cmp, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100 pre_cmp_ga, TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, ("+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100)*TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) cmp_discnt_per, 0, 0, 0, 0, 0, 0, 0 from dual "+
"			) u "+
"		where u.user_id = v.user_id "+
"	) "+
"	order by ORG_DALSUNG desc, amt desc, cmp_discnt_per desc ";


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
			System.out.println("[CampaignDatabase:getCampaign_200612(String bs_dt, String be_dt, String cs_dt, String ce_dt, int amt, int bus_up_per, int bus_down_per, int mng_up_per, int mng_down_per)]"+e);
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
	 * 결과 : 2007-04 - 김영호,최인석 신입에서 뺌
	*/
	public Vector getCampaign_200704(String bs_dt, String be_dt, String bs_dt2, String be_dt2, String cs_dt, String ce_dt, int car_amt, int bus_up_per, int bus_down_per, int mng_up_per, int mng_down_per, int bus_amt_per, int mng_amt_per, int cnt1, int mon, String cnt2, float cmp_discnt_per, int max_dalsung, int bus_ga, int mng_ga, int bus_new_ga)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String client_11 = "";

		//-------------------------------------------------------------------------------------------
		//cs_dt~ce_dt  : 켐페인기간
		//bs_dt~be_dt  : 영업부 평가기준기간
		//bs_dt2~be_dt : 관리부 평가기준기간

		String a_cam	= getCampaignQuery("rent_dt",  cs_dt, ce_dt);
		String a_bas	= getCampaignQuery("rent_dt", bs_dt,  be_dt);
		String a_bas2	= getCampaignQuery("rent_dt", bs_dt2, be_dt2);

		String b_cam	= getCampaignQuery("rent_start_dt", cs_dt, ce_dt);
		String b_bas	= getCampaignQuery("rent_start_dt", bs_dt,  be_dt);
		String b_bas2	= getCampaignQuery("rent_start_dt", bs_dt2, be_dt2);

		String c_cam	= getCampaignQuery2("rent_dt", cs_dt, ce_dt);
		String c_bas	= getCampaignQuery2("rent_dt", bs_dt,  be_dt);
		String c_bas2	= getCampaignQuery2("rent_dt", bs_dt2, be_dt2);

		String d_cam	= getCampaignQuery2("rent_start_dt", cs_dt, ce_dt);
		String d_bas	= getCampaignQuery2("rent_start_dt", bs_dt,  be_dt);
		String d_bas2	= getCampaignQuery2("rent_start_dt", bs_dt2, be_dt2);

		//출고전해지 감소처리-캠페인기간:해지일기준-켐페인기간3개월전계약
		String e_cam =  "select b.bus_id, count(0) cnt "+
						"from cls_cont a, cont b "+
						"where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd  "+
						"	and cls_st in ('7','10')  "+
						"	and cls_dt between '"+cs_dt+"' and '"+ce_dt+"' "+
						"	and b.rent_dt between to_char(add_months('"+cs_dt+"',-3),'yyyymmdd') and to_char(add_months('"+ce_dt+"',-3),'yyyymmdd') "+
						"group by b.bus_id";

		//6개월전해지 감소처리-캠페인기간:대여개시일기준-6개월이전해지계약
		String f_cam =  "select nvl(a.ext_agnt,b.bus_id) bus_id, count(0) cnt "+
						"from fee a, cont b, (select rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_l_cd) c, cls_cont d "+
						"where "+
						"a.rent_l_cd=b.rent_l_cd "+
						"and a.rent_l_cd=c.rent_l_cd and a.rent_st=c.rent_st "+
						"and a.rent_l_cd=d.rent_l_cd "+
						"and b.car_st<>'2' "+
						"and d.cls_st in ('1','2') "+
						"and b.rent_st not in ('5','7') "+
						"and d.cls_dt between '"+cs_dt+"' and '"+ce_dt+"' "+
						"and to_char(add_months(to_date(b.rent_dt,'YYYYMMDD')-1,6),'YYYYMMDD') > d.cls_dt "+
						"group by nvl(a.ext_agnt,b.bus_id)";

		//신입사원 기준일자
		String enter_dt = "20070101";
		//-------------------------------------------------------------------------------------------

		String query = "";

		double avg_dalsung2 = this.getAvg_Dalsung2(bs_dt, be_dt, bs_dt2, be_dt2, cs_dt, ce_dt, car_amt, bus_up_per, bus_down_per, mng_up_per, mng_down_per, bus_amt_per, mng_amt_per, cnt1, mon, cnt2, cmp_discnt_per, max_dalsung, bus_ga, mng_ga, bus_new_ga);

		query=
"	select"+
"		dept_id, user_id, user_nm, cnt1, r_cnt, day, r_cnt2, pre_cmp, pre_cmp_ga, c_day, "+
"		to_char(cmp_discnt_per,'90.99') cmp_discnt_per, "+
"		sum_cnt1, avg_cnt1, sum_r_cnt, avg_r_cnt, sum_bus, avg_bus, avg_low_bus, "+
"		to_char(c_cnt,'990.9') C_CNT, to_char(cr_cnt,'990.99') CR_CNT, to_char(dalsung*100,'9990.99') DALSUNG,"+
"		round("+avg_dalsung2+",4)*100 AVG_DALSUNG, "+
"		round(decode(sign("+avg_dalsung2+" - dalsung), -1, decode(dept_id, '0001', amt*"+bus_amt_per+"/100, '0002',amt*"+mng_amt_per+"/100, 0), 0),-3) AMT "+
"	from "+
"		(select "+
"			u.dept_id, u.user_id, u.user_nm, rent_cnt, start_cnt, cnt1, r_rent_cnt, r_start_cnt, r_cnt, day, r_cnt2,"+
"			pre_cmp, pre_cmp_ga, c_day, cmp_discnt_per, sum_cnt1, avg_cnt1, sum_r_cnt, avg_r_cnt, sum_bus, avg_bus, avg_low_bus,"+
"			nvl(c_rent_cnt,0) C_RENT_CNT, nvl(c_start_cnt,0) C_START_CNT, nvl(c_cnt,0) C_CNT,"+
"			nvl(cr_rent_cnt,0) CR_RENT_CNT, nvl(cr_start_cnt,0) CR_START_CNT, nvl(cr_cnt,0) CR_CNT,"+
"			nvl(cr_cnt/cmp_discnt_per,0) ORG_DALSUNG,"+
"			nvl(decode(sign("+max_dalsung+"/100-(cr_cnt/cmp_discnt_per)),-1, "+max_dalsung+"/100,(cr_cnt/cmp_discnt_per)),0) DALSUNG, "+
"			cr_cnt*nvl(decode(sign("+max_dalsung+"/100-(cr_cnt/cmp_discnt_per)),-1, "+max_dalsung+"/100, (cr_cnt/cmp_discnt_per)),0)*"+car_amt+" AMT "+
"		from "+
			//v => 캠페인기간 실적조회 : a,b 무시 / c(a확대),d(b확대),e 활용
"			(select u.user_id, u.user_nm,"+
"				nvl(a.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0) c_rent_cnt,"+
"				nvl(b.cnt,0)-nvl(f.cnt,0) c_start_cnt, "+
"				( nvl(a.cnt,0)+nvl(b.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0)-nvl(f.cnt,0) )/2 c_cnt, "+
"				nvl(c.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0) cr_rent_cnt,"+
"				nvl(d.cnt,0)-nvl(f.cnt,0) cr_start_cnt,"+
"				( nvl(c.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0)+nvl(d.cnt,0)-nvl(f.cnt,0) )/2 cr_cnt "+
"			from "+
"				("+a_cam+") a, "+
"				("+b_cam+") b, "+
"				("+c_cam+") c, "+
"				("+d_cam+") d, "+
"				("+e_cam+") e, "+
"				("+f_cam+") f, "+
"				users u  "+
"		    where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id=c.bus_id(+) and u.user_id=d.bus_id(+) and u.user_id=e.bus_id(+) and u.user_id=f.bus_id(+)"+
"				and u.dept_id in('0001','0002') and u.user_pos in ('사원','대리','과장') and u.use_yn='Y' and u.user_id not in ('000001','000015','000031')  "+
"		 	) v, "+
			//u => 평가기준기간 실적조회 - 영업부 union 관리부 union 신입사원
"			("+
			//영업부 평가기준기간 실적조회
"			select"+
"				dept_id, user_id, user_nm,"+
"				rent_cnt, start_cnt, cnt1, r_rent_cnt, r_start_cnt, r_cnt, day, r_cnt2, "+
"				decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+bus_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2)) pre_cmp, "+
"				decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+bus_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+bus_ga+"/100 pre_cmp_ga, "+
"				TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, "+
"				(decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+bus_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+bus_ga+"/100)*(TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1))) cmp_discnt_per, "+
"				sum_cnt1, avg_cnt1, sum_r_cnt, avg_r_cnt, sum_bus, avg_bus, avg_low_bus "+
"		    from "+
				//s => 영업부직원별 평가기준기간 실적조회
"				(select u.dept_id, u.user_id, u.user_nm, "+
"					nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1,"+
"					nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"		            TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+
"		            (nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2 "+
"		        from "+
"					("+a_bas+") a, "+
"					("+b_bas+") b, "+
"					("+c_bas+") c, "+
"					("+d_bas+") d, "+
"					users u "+
"		        where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"					and u.enter_dt<'"+enter_dt+"' and u.dept_id ='0001' and u.user_pos in ('사원','대리','과장') and u.use_yn='Y' "+
"				) s, "+
				//t => 영업부직원별 평가기준기간 실적 합계 및 평균 조회
"		        (select "+
"					sum(cnt1) sum_cnt1, avg(cnt1) avg_cnt1, "+
"		            sum(r_cnt) sum_r_cnt, avg(r_cnt) avg_r_cnt, "+
"		            sum(r_cnt2) sum_bus, avg(r_cnt2) avg_bus, "+
"		            avg(r_cnt2)*"+bus_down_per+"/100 avg_low_bus "+
"		        from "+
"					(select u.dept_id, u.user_id, u.user_nm, "+
"						nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1,"+
"						nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"						TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+
"		            	(nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2 "+
"					from "+
"						("+a_bas+") a, "+
"						("+b_bas+") b, "+
"						("+c_bas+") c, "+
"						("+d_bas+") d, "+
"						users u "+
"					where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"						and u.enter_dt<'"+enter_dt+"' and u.dept_id ='0001' and u.user_pos in ('사원','대리','과장') and u.use_yn='Y' "+
"					) "+
"		        ) t "+
"			union "+
			//관리부 평가기준기간 실적조회
"			select dept_id, user_id, user_nm,"+
"				rent_cnt, start_cnt, cnt1, r_rent_cnt, r_start_cnt, r_cnt, day, r_cnt2, "+
"				decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+mng_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2)) pre_cmp, "+
"				decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+mng_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+mng_ga+"/100 pre_cmp_ga, "+
"				TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, "+
"				(decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+mng_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+mng_ga+"/100)*(TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1))) cmp_discnt_per, "+
"				sum_cnt1, avg_cnt1, sum_r_cnt, avg_r_cnt, sum_bus, avg_bus, avg_low_bus "+
"		    from "+
				//s => 관리부직원별 평가기준기간 실적조회
"				(select u.dept_id, u.user_id, u.user_nm,"+
"					nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1, "+
"					nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"		            TRUNC(MONTHS_BETWEEN('"+be_dt2+"','"+bs_dt2+"') * 30.5) day, "+
"		           (nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt2+"','"+bs_dt2+"') * 30.5) r_cnt2 "+
"		        from "+
"					("+a_bas2+") a, "+
"					("+b_bas2+") b, "+
"					("+c_bas2+") c, "+
"					("+d_bas2+") d, "+
"					users u "+
"		        where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"		            and u.enter_dt<'"+enter_dt+"' and u.dept_id ='0002' and u.user_pos in ('사원','대리','과장') and u.use_yn='Y' "+
"		        ) s, "+
				//t => 관리부직원별 평가기준기간 실적 합계 및 평균 조회
"		        (select "+
"					sum(cnt1) sum_cnt1, avg(cnt1) avg_cnt1, "+
"		            sum(r_cnt) sum_r_cnt, avg(r_cnt) avg_r_cnt, "+
"		            sum(r_cnt2) sum_bus, avg(r_cnt2) avg_bus, "+
"		            avg(r_cnt2)*"+mng_down_per+"/100 avg_low_bus "+
"		        from "+
"					(select u.dept_id, u.user_id, u.user_nm, "+
"						nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1, "+
"						nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"						TRUNC(MONTHS_BETWEEN('"+be_dt2+"','"+bs_dt2+"') * 30.5) day, "+
"		            	(nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt2+"','"+bs_dt2+"') * 30.5) r_cnt2 "+
"					from "+
"						("+a_bas2+") a, "+
"						("+b_bas2+") b, "+
"						("+c_bas2+") c, "+
"						("+d_bas2+") d, "+
"						users u "+
"					where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"						and u.enter_dt<'"+enter_dt+"' and u.dept_id ='0002' and u.user_pos in ('사원','대리','과장') and u.use_yn='Y' "+
"					) "+
"		        ) t "+
"			) u "+
"		where u.user_id = v.user_id "+
"	) "+
"	order by ORG_DALSUNG desc, amt desc, cmp_discnt_per desc ";


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
			System.out.println("[CampaignDatabase:getCampaign_200704(String bs_dt, String be_dt, String cs_dt, String ce_dt, int amt, int bus_up_per, int bus_down_per, int mng_up_per, int mng_down_per)]"+e);
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
	 * 결과 : 2007-04 - 김영호,최인석 신입에서 뺌
	*/
	public Vector getCampaign_200705(String bs_dt, String be_dt, String bs_dt2, String be_dt2, String cs_dt, String ce_dt, int car_amt, int bus_up_per, int bus_down_per, int mng_up_per, int mng_down_per, int bus_amt_per, int mng_amt_per, int cnt1, int mon, String cnt2, float cmp_discnt_per, int max_dalsung, int bus_ga, int mng_ga, int bus_new_ga, String enter_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs2 = null;

		Vector vt = new Vector();
		Vector vt2 = new Vector();

		String client_11 = "";

		//-------------------------------------------------------------------------------------------
		//cs_dt~ce_dt  : 켐페인기간
		//bs_dt~be_dt  : 영업부 평가기준기간
		//bs_dt2~be_dt : 관리부 평가기준기간

		String a_cam	= getCampaignQuery("rent_dt",  cs_dt, ce_dt);
		String a_bas	= getCampaignQuery("rent_dt", bs_dt,  be_dt);
		String a_bas2	= getCampaignQuery("rent_dt", bs_dt2, be_dt2);

		String b_cam	= getCampaignQuery("rent_start_dt", cs_dt, ce_dt);
		String b_bas	= getCampaignQuery("rent_start_dt", bs_dt,  be_dt);
		String b_bas2	= getCampaignQuery("rent_start_dt", bs_dt2, be_dt2);

		String c_cam	= getCampaignQuery2("rent_dt", cs_dt, ce_dt);
		String c_bas	= getCampaignQuery2("rent_dt", bs_dt,  be_dt);
		String c_bas2	= getCampaignQuery2("rent_dt", bs_dt2, be_dt2);

		String d_cam	= getCampaignQuery2("rent_start_dt", cs_dt, ce_dt);
		String d_bas	= getCampaignQuery2("rent_start_dt", bs_dt,  be_dt);
		String d_bas2	= getCampaignQuery2("rent_start_dt", bs_dt2, be_dt2);

		//출고전해지 감소처리-캠페인기간:해지일기준-켐페인기간3개월전계약
		String e_cam =  "select b.bus_id, count(0) cnt "+
						"from cls_cont a, cont b "+
						"where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd  "+
						"	and cls_st in ('7','10')  "+
						"	and cls_dt between '"+cs_dt+"' and '"+ce_dt+"' "+
						//"	and b.rent_dt between to_char(add_months('"+cs_dt+"',-3),'yyyymmdd') and to_char(add_months('"+ce_dt+"',-3),'yyyymmdd') "+
						"group by b.bus_id";

		//6개월전해지 감소처리-캠페인기간:대여개시일기준-6개월이전해지계약
		String f_cam =  "select nvl(a.ext_agnt,b.bus_id) bus_id, count(0) cnt "+
						"from fee a, cont b, (select rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_l_cd) c, cls_cont d "+
						"where "+
						"a.rent_l_cd=b.rent_l_cd "+
						"and a.rent_l_cd=c.rent_l_cd and a.rent_st=c.rent_st "+
						"and a.rent_l_cd=d.rent_l_cd "+
						"and b.car_st<>'2' "+
						"and d.cls_st in ('1','2') "+
						"and b.rent_st not in ('5','7') "+
						"and d.cls_dt between '"+cs_dt+"' and '"+ce_dt+"' "+
						"and to_char(add_months(to_date(b.rent_dt,'YYYYMMDD')-1,6),'YYYYMMDD') > d.cls_dt "+
						"group by nvl(a.ext_agnt,b.bus_id)";

		//-------------------------------------------------------------------------------------------

		String query = "";

		//신입사원리스트
		String query2 = "select * from users where use_yn='Y' and loan_st is not null and enter_dt >= '"+enter_dt+"' and enter_dt < '20070601'";

		try {
			pstmt2 = conn.prepareStatement(query2);
	    	rs2 = pstmt2.executeQuery();

			ResultSetMetaData rsmd2 = rs2.getMetaData();    	
			while(rs2.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd2.getColumnCount();pos++)
				{
					 String columnName = rsmd2.getColumnName(pos);
					 ht.put(columnName, (rs2.getString(columnName))==null?"":rs2.getString(columnName));
				}
				vt2.add(ht);	
			}
			rs2.close();
			pstmt2.close();
		} catch (SQLException e) {
			System.out.println("[CampaignDatabase:getCampaign_200705(String bs_dt, String be_dt, String cs_dt, String ce_dt, int amt, int bus_up_per, int bus_down_per, int mng_up_per, int mng_down_per)]"+e);
			e.printStackTrace();
		} 
		
		//달성평균값
		double avg_dalsung2 = this.getAvg_Dalsung_200705(bs_dt, be_dt, bs_dt2, be_dt2, cs_dt, ce_dt, car_amt, bus_up_per, bus_down_per, mng_up_per, mng_down_per, bus_amt_per, mng_amt_per, cnt1, mon, cnt2, cmp_discnt_per, max_dalsung, bus_ga, mng_ga, bus_new_ga, enter_dt);

		query=
"	select"+
"		dept_id, user_id, user_nm, "+
"		rent_cnt, start_cnt, cnt1, r_rent_cnt, r_start_cnt, r_cnt, day,"+
"		trunc(r_cnt2,5) as r_cnt2, trunc(pre_cmp,5) as pre_cmp, trunc(pre_cmp_ga,5) as pre_cmp_ga,"+
"		c_day, to_char(cmp_discnt_per,'90.99') cmp_discnt_per, "+
"		c_rent_cnt, c_start_cnt, cr_rent_cnt, cr_start_cnt, "+
"		sum_cnt1, trunc(avg_cnt1,5) as avg_cnt1, sum_r_cnt, trunc(avg_r_cnt,5) as avg_r_cnt,"+
"		trunc(sum_bus,5) as sum_bus, trunc(avg_bus,5) as avg_bus, trunc(avg_low_bus,5) as avg_low_bus, "+
"		to_char(c_cnt,'990.9') C_CNT, to_char(cr_cnt,'990.99') CR_CNT,"+
"		to_char(dalsung*100,'9990.99') DALSUNG, to_char(ORG_DALSUNG*100,'9990.99') ORG_DALSUNG,"+
"		round("+avg_dalsung2+",4)*100 AVG_DALSUNG, "+
"		round(decode(sign("+avg_dalsung2+" - dalsung), -1, decode(loan_st, '2', amt*"+bus_amt_per+"/100, '1',amt*"+mng_amt_per+"/100, 0), 0),-3) AMT, "+
"		round(decode(sign("+avg_dalsung2+" - dalsung), -1, amt, 0),-3) AMT2 "+
"	from "+
"		(select "+
"			u.dept_id, u.user_id, u.user_nm, u.loan_st, rent_cnt, start_cnt, cnt1, r_rent_cnt, r_start_cnt, r_cnt, day, r_cnt2,"+
"			pre_cmp, pre_cmp_ga, c_day, cmp_discnt_per, sum_cnt1, avg_cnt1, sum_r_cnt, avg_r_cnt, sum_bus, avg_bus, avg_low_bus,"+
"			nvl(c_rent_cnt,0) C_RENT_CNT, nvl(c_start_cnt,0) C_START_CNT, nvl(c_cnt,0) C_CNT,"+
"			nvl(cr_rent_cnt,0) CR_RENT_CNT, nvl(cr_start_cnt,0) CR_START_CNT, nvl(cr_cnt,0) CR_CNT,"+
"			nvl(cr_cnt/cmp_discnt_per,0) ORG_DALSUNG,"+
"			nvl(decode(sign("+max_dalsung+"/100-(cr_cnt/cmp_discnt_per)),-1, "+max_dalsung+"/100,(cr_cnt/cmp_discnt_per)),0) DALSUNG, "+
"			cr_cnt*nvl(decode(sign("+max_dalsung+"/100-(cr_cnt/cmp_discnt_per)),-1, "+max_dalsung+"/100, (cr_cnt/cmp_discnt_per)),0)*"+car_amt+" AMT "+
"		from "+
			//v => 캠페인기간 실적조회 : a,b 무시 / c(a확대),d(b확대),e 활용
"			(select u.user_id, u.user_nm, u.loan_st,"+
"				nvl(a.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0) c_rent_cnt,"+
"				nvl(b.cnt,0)-nvl(f.cnt,0) c_start_cnt, "+
"				( nvl(a.cnt,0)+nvl(b.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0)-nvl(f.cnt,0) )/2 c_cnt, "+
"				nvl(c.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0) cr_rent_cnt,"+
"				nvl(d.cnt,0)-nvl(f.cnt,0) cr_start_cnt,"+
"				( nvl(c.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0)+nvl(d.cnt,0)-nvl(f.cnt,0) )/2 cr_cnt "+
"			from "+
"				("+a_cam+") a, "+
"				("+b_cam+") b, "+
"				("+c_cam+") c, "+
"				("+d_cam+") d, "+
"				("+e_cam+") e, "+
"				("+f_cam+") f, "+
"				users u  "+
"		    where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id=c.bus_id(+) and u.user_id=d.bus_id(+) and u.user_id=e.bus_id(+) and u.user_id=f.bus_id(+)"+
"				and u.use_yn='Y' "+
"				and u.loan_st is not null "+
"		 	) v, "+
			//u => 평가기준기간 실적조회 - 영업부 union 관리부 union 신입사원
"			("+
			//영업부 평가기준기간 실적조회
"			select"+
"				dept_id, user_id, user_nm, loan_st,"+
"				rent_cnt, start_cnt, cnt1, r_rent_cnt, r_start_cnt, r_cnt, day, r_cnt2, "+
"				decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+bus_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2)) pre_cmp, "+
"				decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+bus_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+bus_ga+"/100 pre_cmp_ga, "+
"				TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, "+
"				(decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+bus_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+bus_ga+"/100)*(TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1))) cmp_discnt_per, "+
"				sum_cnt1, avg_cnt1, sum_r_cnt, avg_r_cnt, sum_bus, avg_bus, avg_low_bus "+
"		    from "+
				//s => 영업부직원별 평가기준기간 실적조회
"				(select u.dept_id, u.user_id, u.user_nm, u.loan_st,"+
"					nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1,"+
"					nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"		            TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+
"		            (nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2 "+
"		        from "+
"					("+a_bas+") a, "+
"					("+b_bas+") b, "+
"					("+c_bas+") c, "+
"					("+d_bas+") d, "+
"					users u "+
"		        where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"					and u.enter_dt<'"+enter_dt+"' and u.use_yn='Y'"+
"					and u.loan_st='2'"+
"				) s, "+
				//t => 영업부직원별 평가기준기간 실적 합계 및 평균 조회
"		        (select "+
"					sum(cnt1) sum_cnt1, avg(cnt1) avg_cnt1, "+
"		            sum(r_cnt) sum_r_cnt, avg(r_cnt) avg_r_cnt, "+
"		            sum(r_cnt2) sum_bus, avg(r_cnt2) avg_bus, "+
"		            avg(r_cnt2)*"+bus_down_per+"/100 avg_low_bus "+
"		        from "+
"					(select u.dept_id, u.user_id, u.user_nm, u.loan_st,"+
"						nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1,"+
"						nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"						TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+
"		            	(nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2 "+
"					from "+
"						("+a_bas+") a, "+
"						("+b_bas+") b, "+
"						("+c_bas+") c, "+
"						("+d_bas+") d, "+
"						users u "+
"					where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"						and u.enter_dt<'"+enter_dt+"' and u.use_yn='Y'"+
"						and u.loan_st='2'"+
"					) "+
"		        ) t "+
"			union "+
			//관리부 평가기준기간 실적조회
"			select dept_id, user_id, user_nm,loan_st,"+
"				rent_cnt, start_cnt, cnt1, r_rent_cnt, r_start_cnt, r_cnt, day, r_cnt2, "+
"				decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+mng_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2)) pre_cmp, "+
"				decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+mng_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+mng_ga+"/100 pre_cmp_ga, "+
"				TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, "+
"				(decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+mng_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+mng_ga+"/100)*(TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1))) cmp_discnt_per, "+
"				sum_cnt1, avg_cnt1, sum_r_cnt, avg_r_cnt, sum_bus, avg_bus, avg_low_bus "+
"		    from "+
				//s => 관리부직원별 평가기준기간 실적조회
"				(select u.dept_id, u.user_id, u.user_nm,u.loan_st,"+
"					nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1, "+
"					nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"		            TRUNC(MONTHS_BETWEEN('"+be_dt2+"','"+bs_dt2+"') * 30.5) day, "+
"		           (nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt2+"','"+bs_dt2+"') * 30.5) r_cnt2 "+
"		        from "+
"					("+a_bas2+") a, "+
"					("+b_bas2+") b, "+
"					("+c_bas2+") c, "+
"					("+d_bas2+") d, "+
"					users u "+
"		        where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"		            and u.use_yn='Y' and u.enter_dt<'"+enter_dt+"'"+
"					and u.loan_st ='1' "+
"		        ) s, "+
				//t => 관리부직원별 평가기준기간 실적 합계 및 평균 조회
"		        (select "+
"					sum(cnt1) sum_cnt1, avg(cnt1) avg_cnt1, "+
"		            sum(r_cnt) sum_r_cnt, avg(r_cnt) avg_r_cnt, "+
"		            sum(r_cnt2) sum_bus, avg(r_cnt2) avg_bus, "+
"		            avg(r_cnt2)*"+mng_down_per+"/100 avg_low_bus "+
"		        from "+
"					(select u.dept_id, u.user_id, u.user_nm, u.loan_st,"+
"						nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1, "+
"						nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"						TRUNC(MONTHS_BETWEEN('"+be_dt2+"','"+bs_dt2+"') * 30.5) day, "+
"		            	(nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt2+"','"+bs_dt2+"') * 30.5) r_cnt2 "+
"					from "+
"						("+a_bas2+") a, "+
"						("+b_bas2+") b, "+
"						("+c_bas2+") c, "+
"						("+d_bas2+") d, "+
"						users u "+
"					where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"						and u.enter_dt<'"+enter_dt+"' and u.use_yn='Y'"+
"						and u.loan_st ='1' "+
"					) "+
"		        ) t ";

if(vt2.size()>0 && cnt1 >0){
	for(int i=0; i<vt2.size(); i++){
		Hashtable ht2 = (Hashtable)vt2.elementAt(i);
		query += " union select '"+String.valueOf(ht2.get("DEPT_ID"))+"' dept_id, '"+String.valueOf(ht2.get("USER_ID"))+"' user_id, '"+String.valueOf(ht2.get("USER_NM"))+"' user_nm, '"+String.valueOf(ht2.get("LOAN_ST"))+"' loan_st, "+cnt1+" rent_cnt, "+cnt1+" start_cnt, "+cnt1+" cnt1, "+cnt1+" r_rent_cnt, "+cnt1+" r_start_cnt, "+cnt1+" r_cnt, TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) pre_cmp, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100 pre_cmp_ga, TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, ("+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100)*TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) cmp_discnt_per, 0, 0, 0, 0, 0, 0, 0 from dual ";
	}
}


query += "			) u "+
"		where u.user_id = v.user_id "+
"	) "+
"	order by ORG_DALSUNG desc, amt desc, cmp_discnt_per desc ";


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
			System.out.println("[CampaignDatabase:getCampaign_200705(String bs_dt, String be_dt, String cs_dt, String ce_dt, int amt, int bus_up_per, int bus_down_per, int mng_up_per, int mng_down_per)]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
                if(rs2 != null )	rs2.close();
                if(pstmt2 != null)	pstmt2.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}	

	/**
	 * 결과 : 2007-05 마감테이블 조회
	*/
	public Vector getCampaign_200705(String save_dt, String loan_st, String enter_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query = " select b.dept_id, b.user_nm, b.user_id, b.loan_st, c.nm_cd, a.* from stat_bus_cmp a, users b, (select * from code where c_st='0002') c where a.bus_id=b.user_id and b.dept_id=c.code and a.save_dt='"+save_dt+"'";

		query += " and a.cnt1>0";

		if(!loan_st.equals("") && !enter_dt.equals(""))	query += " and b.loan_st='"+loan_st+"' and b.enter_dt < '"+enter_dt+"'";

		if(loan_st.equals("")  && !enter_dt.equals(""))	query += " and b.enter_dt >= '"+enter_dt+"'";
			
		query += " order by a.seq";

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
			System.out.println("[CampaignDatabase:getCampaign_200705(String save_dt, String loan_st, String enter_dt)]"+e);
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
	 * 결과 평균값 구하기
	*/
	public double getAvg_Dalsung2(String bs_dt, String be_dt, String bs_dt2, String be_dt2, String cs_dt, String ce_dt, int car_amt, int bus_up_per, int bus_down_per, int mng_up_per, int mng_down_per, int bus_amt_per, int mng_amt_per, int cnt1, int mon, String cnt2, float cmp_discnt_per, int max_dalsung, int bus_ga, int mng_ga, int bus_new_ga)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		double avg = 0.0;

		//-------------------------------------------------------------------------------------------
		//cs_dt~ce_dt  : 켐페인기간
		//bs_dt~be_dt  : 영업부 평가기준기간
		//bs_dt2~be_dt : 관리부 평가기준기간

		String a_cam	= getCampaignQuery("rent_dt",  cs_dt, ce_dt);
		String a_bas	= getCampaignQuery("rent_dt", bs_dt,  be_dt);
		String a_bas2	= getCampaignQuery("rent_dt", bs_dt2, be_dt2);

		String b_cam	= getCampaignQuery("rent_start_dt", cs_dt, ce_dt);
		String b_bas	= getCampaignQuery("rent_start_dt", bs_dt,  be_dt);
		String b_bas2	= getCampaignQuery("rent_start_dt", bs_dt2, be_dt2);

		String c_cam	= getCampaignQuery2("rent_dt", cs_dt, ce_dt);
		String c_bas	= getCampaignQuery2("rent_dt", bs_dt,  be_dt);
		String c_bas2	= getCampaignQuery2("rent_dt", bs_dt2, be_dt2);

		String d_cam	= getCampaignQuery2("rent_start_dt", cs_dt, ce_dt);
		String d_bas	= getCampaignQuery2("rent_start_dt", bs_dt,  be_dt);
		String d_bas2	= getCampaignQuery2("rent_start_dt", bs_dt2, be_dt2);

		//출고전해지 감소처리-캠페인기간:해지일기준-켐페인기간3개월전계약
		String e_cam =  "select b.bus_id, count(0) cnt "+
						"from cls_cont a, cont b "+
						"where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd  "+
						"	and cls_st in ('7','10')  "+
						"	and cls_dt between '"+cs_dt+"' and '"+ce_dt+"' "+
						"	and b.rent_dt between to_char(add_months('"+cs_dt+"',-3),'yyyymmdd') and to_char(add_months('"+ce_dt+"',-3),'yyyymmdd') "+
						"group by b.bus_id";

		//6개월전해지 감소처리-캠페인기간:대여개시일기준-6개월이전해지계약
		String f_cam =  "select b.bus_id, count(0) cnt "+
						"from fee a, cont b, (select rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_l_cd) c, cls_cont d "+
						"where "+
						"a.rent_l_cd=b.rent_l_cd "+
						"and a.rent_l_cd=c.rent_l_cd and a.rent_st=c.rent_st "+
						"and a.rent_l_cd=d.rent_l_cd "+
						"and b.car_st<>'2' "+
						"and d.cls_st in ('1','2') "+
						"and b.rent_st not in ('5','7') "+
						"and d.cls_dt between '"+cs_dt+"' and '"+ce_dt+"' "+
						"and to_char(add_months(to_date(a.rent_start_dt,'YYYYMMDD'),6),'YYYYMMDD') > d.cls_dt "+
						"group by b.bus_id";

		//신입사원 기준일자
		String enter_dt = "20060331";
		//-------------------------------------------------------------------------------------------
		
		String query = "";

		query=
"	select round(avg(dalsung),4) AVG_DALSUNG "+
"	from "+
"		(select u.dept_id, u.user_id, u.user_nm, "+
"			rent_cnt, start_cnt, cnt1, r_rent_cnt, r_start_cnt, r_cnt, day, r_cnt2, "+
"			pre_cmp, pre_cmp_ga, c_day, cmp_discnt_per, sum_cnt1, avg_cnt1, sum_r_cnt, avg_r_cnt, sum_bus, avg_bus, avg_low_bus,"+
"			nvl(c_rent_cnt,0) C_RENT_CNT, nvl(c_start_cnt,0) C_START_CNT, nvl(c_cnt,0) C_CNT, nvl(cr_rent_cnt,0) CR_RENT_CNT, nvl(cr_start_cnt,0) CR_START_CNT, nvl(cr_cnt,0) CR_CNT,"+
"			nvl(decode(sign("+max_dalsung+"/100-(cr_cnt/cmp_discnt_per)),-1, "+max_dalsung+"/100,(cr_cnt/cmp_discnt_per)),0) DALSUNG, "+
"			cr_cnt*nvl(decode(sign("+max_dalsung+"/100-(cr_cnt/cmp_discnt_per)),-1, "+max_dalsung+"/100, (cr_cnt/cmp_discnt_per)),0)*"+car_amt+" AMT "+
"			from "+
"				(select u.user_id, u.user_nm, "+
"				nvl(a.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0) c_rent_cnt,"+
"				nvl(b.cnt,0)-nvl(f.cnt,0) c_start_cnt, "+
"				( nvl(a.cnt,0)+nvl(b.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0)-nvl(f.cnt,0) )/2 c_cnt, "+
"				nvl(c.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0) cr_rent_cnt,"+
"				nvl(d.cnt,0)-nvl(f.cnt,0) cr_start_cnt,"+
"				( nvl(c.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0)+nvl(d.cnt,0)-nvl(f.cnt,0) )/2 cr_cnt "+
"		         from "+
"					("+a_cam+") a, "+
"					("+b_cam+") b, "+
"					("+c_cam+") c, "+
"					("+d_cam+") d, "+
"					("+e_cam+") e, "+
"					("+f_cam+") f, "+
"					users u  "+
"		    	where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id=c.bus_id(+) and u.user_id=d.bus_id(+) and u.user_id=e.bus_id(+) and u.user_id=f.bus_id(+)"+
"				and u.dept_id in('0001','0002') and u.user_pos in ('사원','대리','과장') and u.use_yn='Y' and u.user_id not in ('000001','000015','000031')  "+
"		 		) v, "+
"				(select dept_id, user_id, user_nm, rent_cnt, start_cnt, cnt1, r_rent_cnt, r_start_cnt, r_cnt, day, r_cnt2, "+
"						decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+bus_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2)) pre_cmp, "+
"						decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+bus_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+bus_ga+"/100 pre_cmp_ga, "+
"						TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, "+
"						(decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+bus_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+bus_ga+"/100)*(TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1))) cmp_discnt_per "+
"						,sum_cnt1, avg_cnt1, sum_r_cnt, avg_r_cnt, sum_bus, avg_bus, avg_low_bus "+
"		        from "+
"		            (select u.dept_id, u.user_id, u.user_nm, nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1, nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"		                   TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+
"		            	   (nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2 "+
"		            from "+
"						("+a_bas+") a, "+
"						("+b_bas+") b, "+
"						("+c_bas+") c, "+
"						("+d_bas+") d, users u "+
"		            where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"		            and u.enter_dt<'"+enter_dt+"' and u.dept_id ='0001' and u.user_pos in ('사원','대리','과장') and u.use_yn='Y' "+
"		            ) s, "+
"		            (select  sum(cnt1) sum_cnt1, avg(cnt1) avg_cnt1, "+
"		                    sum(r_cnt) sum_r_cnt, avg(r_cnt) avg_r_cnt, "+
"		                    sum(r_cnt2) sum_bus, avg(r_cnt2) avg_bus, "+
"		                    avg(r_cnt2)*"+bus_down_per+"/100 avg_low_bus			 "+
"		            from (select u.dept_id, u.user_id, u.user_nm, nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1, nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"								TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+
"		            			(nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2 "+
"						from "+
"							("+a_bas+") a, "+
"							("+b_bas+") b, "+
"							("+c_bas+") c, "+
"							("+d_bas+") d, users u "+
"						where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"						and u.enter_dt<'"+enter_dt+"' and u.dept_id ='0001' and u.user_pos in ('사원','대리','과장') and u.use_yn='Y' "+
"						) "+
"		            ) t "+
"				union "+	//여기까지 영업부
"				select dept_id, user_id, user_nm, rent_cnt, start_cnt, cnt1, r_rent_cnt, r_start_cnt, r_cnt, day, r_cnt2, "+
"						decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+mng_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2)) pre_cmp, "+
"						decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+mng_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+mng_ga+"/100 pre_cmp_ga, "+
"						TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, "+
"						(decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+mng_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+mng_ga+"/100)*(TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1))) cmp_discnt_per "+
"						,sum_cnt1, avg_cnt1, sum_r_cnt, avg_r_cnt, sum_bus, avg_bus, avg_low_bus "+
"		        from "+
"		            (select u.dept_id, u.user_id, u.user_nm, nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1, nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"		                   TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+
"		            	   (nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2 "+
"		            from "+
"						("+a_bas2+") a, "+
"						("+b_bas2+") b, "+
"						("+c_bas2+") c, "+
"						("+d_bas2+") d, users u "+
"		            where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"		            and u.enter_dt<'"+enter_dt+"' and u.dept_id ='0002' and u.user_pos in ('사원','대리','과장') and u.use_yn='Y' "+
"		            ) s, "+
"		            (select  sum(cnt1) sum_cnt1, avg(cnt1) avg_cnt1, "+
"		                    sum(r_cnt) sum_r_cnt, avg(r_cnt) avg_r_cnt, "+
"		                    sum(r_cnt2) sum_bus, avg(r_cnt2) avg_bus, "+
"		                    avg(r_cnt2)*"+mng_down_per+"/100 avg_low_bus			 "+
"		            from (select u.dept_id, u.user_id, u.user_nm, nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1, nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"								TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+
"		            			(nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2 "+
"							from "+
"							("+a_bas2+") a, "+
"							("+b_bas2+") b, "+
"							("+c_bas2+") c, "+
"							("+d_bas2+") d, users u "+
"						where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"						and u.enter_dt<'"+enter_dt+"' and u.dept_id ='0002' and u.user_pos in ('사원','대리','과장') and u.use_yn='Y' "+
"						) "+
"		            ) t "+
"		) u "+
"		where u.user_id = v.user_id "+
"	)  ";


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			while(rs.next()){
				avg = rs.getDouble(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CampaignDatabase:getAvg_Dalsung2(String bs_dt, String be_dt, String cs_dt, String ce_dt, int amt, int bus_up_per, int bus_down_per, int mng_up_per, int mng_down_per)]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return avg;
		}
	}	

	/**
	 * 결과 평균값 구하기
	*/
	public double getAvg_Dalsung_200705(String bs_dt, String be_dt, String bs_dt2, String be_dt2, String cs_dt, String ce_dt, int car_amt, int bus_up_per, int bus_down_per, int mng_up_per, int mng_down_per, int bus_amt_per, int mng_amt_per, int cnt1, int mon, String cnt2, float cmp_discnt_per, int max_dalsung, int bus_ga, int mng_ga, int bus_new_ga, String enter_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs2 = null;
		Vector vt2 = new Vector();
		double avg = 0.0;

		//-------------------------------------------------------------------------------------------
		//cs_dt~ce_dt  : 켐페인기간
		//bs_dt~be_dt  : 영업부 평가기준기간
		//bs_dt2~be_dt : 관리부 평가기준기간

		String a_cam	= getCampaignQuery("rent_dt",  cs_dt, ce_dt);
		String a_bas	= getCampaignQuery("rent_dt", bs_dt,  be_dt);
		String a_bas2	= getCampaignQuery("rent_dt", bs_dt2, be_dt2);

		String b_cam	= getCampaignQuery("rent_start_dt", cs_dt, ce_dt);
		String b_bas	= getCampaignQuery("rent_start_dt", bs_dt,  be_dt);
		String b_bas2	= getCampaignQuery("rent_start_dt", bs_dt2, be_dt2);

		String c_cam	= getCampaignQuery2("rent_dt", cs_dt, ce_dt);
		String c_bas	= getCampaignQuery2("rent_dt", bs_dt,  be_dt);
		String c_bas2	= getCampaignQuery2("rent_dt", bs_dt2, be_dt2);

		String d_cam	= getCampaignQuery2("rent_start_dt", cs_dt, ce_dt);
		String d_bas	= getCampaignQuery2("rent_start_dt", bs_dt,  be_dt);
		String d_bas2	= getCampaignQuery2("rent_start_dt", bs_dt2, be_dt2);

		//출고전해지 감소처리-캠페인기간:해지일기준-켐페인기간3개월전계약
		String e_cam =  "select b.bus_id, count(0) cnt "+
						"from cls_cont a, cont b "+
						"where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd  "+
						"	and cls_st in ('7','10')  "+
						"	and cls_dt between '"+cs_dt+"' and '"+ce_dt+"' "+
						"	and b.rent_dt between to_char(add_months('"+cs_dt+"',-3),'yyyymmdd') and to_char(add_months('"+ce_dt+"',-3),'yyyymmdd') "+
						"group by b.bus_id";

		//6개월전해지 감소처리-캠페인기간:대여개시일기준-6개월이전해지계약
		String f_cam =  "select b.bus_id, count(0) cnt "+
						"from fee a, cont b, (select rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_l_cd) c, cls_cont d "+
						"where "+
						"a.rent_l_cd=b.rent_l_cd "+
						"and a.rent_l_cd=c.rent_l_cd and a.rent_st=c.rent_st "+
						"and a.rent_l_cd=d.rent_l_cd "+
						"and b.car_st<>'2' "+
						"and d.cls_st in ('1','2') "+
						"and b.rent_st not in ('5','7') "+
						"and d.cls_dt between '"+cs_dt+"' and '"+ce_dt+"' "+
						"and to_char(add_months(to_date(a.rent_start_dt,'YYYYMMDD'),6),'YYYYMMDD') > d.cls_dt "+
						"group by b.bus_id";

		//-------------------------------------------------------------------------------------------
		
		String query = "";

		//신입사원리스트
		String query2 = "select * from users where use_yn='Y' and loan_st is not null and enter_dt >= '"+enter_dt+"' and enter_dt < '20070601'";//

		try {
			pstmt2 = conn.prepareStatement(query2);
	    	rs2 = pstmt2.executeQuery();

			ResultSetMetaData rsmd2 = rs2.getMetaData();    	
			while(rs2.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd2.getColumnCount();pos++)
				{
					 String columnName = rsmd2.getColumnName(pos);
					 ht.put(columnName, (rs2.getString(columnName))==null?"":rs2.getString(columnName));
				}
				vt2.add(ht);	
			}
			rs2.close();
			pstmt2.close();
		} catch (SQLException e) {
			System.out.println("[CampaignDatabase:getAvg_Dalsung_200705(String bs_dt, String be_dt, String cs_dt, String ce_dt, int amt, int bus_up_per, int bus_down_per, int mng_up_per, int mng_down_per)]"+e);
			e.printStackTrace();
		} 

		query=
"	select round(avg(dalsung),4) AVG_DALSUNG "+
"	from "+
"		(select u.dept_id, u.user_id, u.user_nm, "+
"			rent_cnt, start_cnt, cnt1, r_rent_cnt, r_start_cnt, r_cnt, day, r_cnt2, "+
"			pre_cmp, pre_cmp_ga, c_day, cmp_discnt_per, sum_cnt1, avg_cnt1, sum_r_cnt, avg_r_cnt, sum_bus, avg_bus, avg_low_bus,"+
"			nvl(c_rent_cnt,0) C_RENT_CNT, nvl(c_start_cnt,0) C_START_CNT, nvl(c_cnt,0) C_CNT, nvl(cr_rent_cnt,0) CR_RENT_CNT, nvl(cr_start_cnt,0) CR_START_CNT, nvl(cr_cnt,0) CR_CNT,"+
"			nvl(decode(sign("+max_dalsung+"/100-(cr_cnt/cmp_discnt_per)),-1, "+max_dalsung+"/100,(cr_cnt/cmp_discnt_per)),0) DALSUNG, "+
"			cr_cnt*nvl(decode(sign("+max_dalsung+"/100-(cr_cnt/cmp_discnt_per)),-1, "+max_dalsung+"/100, (cr_cnt/cmp_discnt_per)),0)*"+car_amt+" AMT "+
"			from "+
"				(select u.user_id, u.user_nm, "+
"				nvl(a.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0) c_rent_cnt,"+
"				nvl(b.cnt,0)-nvl(f.cnt,0) c_start_cnt, "+
"				( nvl(a.cnt,0)+nvl(b.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0)-nvl(f.cnt,0) )/2 c_cnt, "+
"				nvl(c.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0) cr_rent_cnt,"+
"				nvl(d.cnt,0)-nvl(f.cnt,0) cr_start_cnt,"+
"				( nvl(c.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0)+nvl(d.cnt,0)-nvl(f.cnt,0) )/2 cr_cnt "+
"		         from "+
"					("+a_cam+") a, "+
"					("+b_cam+") b, "+
"					("+c_cam+") c, "+
"					("+d_cam+") d, "+
"					("+e_cam+") e, "+
"					("+f_cam+") f, "+
"					users u  "+
"		    	where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id=c.bus_id(+) and u.user_id=d.bus_id(+) and u.user_id=e.bus_id(+) and u.user_id=f.bus_id(+)"+
"				and u.use_yn='Y' "+
"				and u.loan_st is not null "+
"		 		) v, "+
"				(select dept_id, user_id, user_nm, rent_cnt, start_cnt, cnt1, r_rent_cnt, r_start_cnt, r_cnt, day, r_cnt2, "+
"						decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+bus_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2)) pre_cmp, "+
"						decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+bus_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+bus_ga+"/100 pre_cmp_ga, "+
"						TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, "+
"						(decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+bus_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+bus_ga+"/100)*(TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1))) cmp_discnt_per "+
"						,sum_cnt1, avg_cnt1, sum_r_cnt, avg_r_cnt, sum_bus, avg_bus, avg_low_bus "+
"		        from "+
"		            (select u.dept_id, u.user_id, u.user_nm, nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1, nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"		                   TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+
"		            	   (nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2 "+
"		            from "+
"						("+a_bas+") a, "+
"						("+b_bas+") b, "+
"						("+c_bas+") c, "+
"						("+d_bas+") d, users u "+
"		            where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"		            and u.enter_dt<'"+enter_dt+"' and u.use_yn='Y'"+
"					and u.loan_st='2'"+
"		            ) s, "+
"		            (select  sum(cnt1) sum_cnt1, avg(cnt1) avg_cnt1, "+
"		                    sum(r_cnt) sum_r_cnt, avg(r_cnt) avg_r_cnt, "+
"		                    sum(r_cnt2) sum_bus, avg(r_cnt2) avg_bus, "+
"		                    avg(r_cnt2)*"+bus_down_per+"/100 avg_low_bus			 "+
"		            from (select u.dept_id, u.user_id, u.user_nm, nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1, nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"								TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+
"		            			(nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2 "+
"						from "+
"							("+a_bas+") a, "+
"							("+b_bas+") b, "+
"							("+c_bas+") c, "+
"							("+d_bas+") d, users u "+
"						where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"						and u.enter_dt<'"+enter_dt+"' and u.use_yn='Y'"+
"						and u.loan_st='2'"+
"						) "+
"		            ) t "+
"				union "+	//여기까지 영업부
"				select dept_id, user_id, user_nm, rent_cnt, start_cnt, cnt1, r_rent_cnt, r_start_cnt, r_cnt, day, r_cnt2, "+
"						decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+mng_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2)) pre_cmp, "+
"						decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+mng_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+mng_ga+"/100 pre_cmp_ga, "+
"						TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, "+
"						(decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+mng_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+mng_ga+"/100)*(TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1))) cmp_discnt_per "+
"						,sum_cnt1, avg_cnt1, sum_r_cnt, avg_r_cnt, sum_bus, avg_bus, avg_low_bus "+
"		        from "+
"		            (select u.dept_id, u.user_id, u.user_nm, nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1, nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"		                   TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+
"		            	   (nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2 "+
"		            from "+
"						("+a_bas2+") a, "+
"						("+b_bas2+") b, "+
"						("+c_bas2+") c, "+
"						("+d_bas2+") d, users u "+
"		            where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"		            and u.enter_dt<'"+enter_dt+"' and u.use_yn='Y'"+
"					and u.loan_st='1'"+
"		            ) s, "+
"		            (select  sum(cnt1) sum_cnt1, avg(cnt1) avg_cnt1, "+
"		                    sum(r_cnt) sum_r_cnt, avg(r_cnt) avg_r_cnt, "+
"		                    sum(r_cnt2) sum_bus, avg(r_cnt2) avg_bus, "+
"		                    avg(r_cnt2)*"+mng_down_per+"/100 avg_low_bus			 "+
"		            from (select u.dept_id, u.user_id, u.user_nm, nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1, nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"								TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+
"		            			(nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2 "+
"							from "+
"							("+a_bas2+") a, "+
"							("+b_bas2+") b, "+
"							("+c_bas2+") c, "+
"							("+d_bas2+") d, users u "+
"						where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"						and u.enter_dt<'"+enter_dt+"' and u.use_yn='Y'"+
"						and u.loan_st='1'"+
"						) "+
"		            ) t ";

if(vt2.size()>0 && cnt1 >0){
	for(int i=0; i<vt2.size(); i++){
		Hashtable ht2 = (Hashtable)vt2.elementAt(i);
		query += " union select '"+String.valueOf(ht2.get("DEPT_ID"))+"' dept_id, '"+String.valueOf(ht2.get("USER_ID"))+"' user_id, '"+String.valueOf(ht2.get("USER_NM"))+"' user_nm, "+cnt1+" rent_cnt, "+cnt1+" start_cnt, "+cnt1+" cnt1, "+cnt1+" r_rent_cnt, "+cnt1+" r_start_cnt, "+cnt1+" r_cnt, TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) pre_cmp, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100 pre_cmp_ga, TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, ("+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100)*TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) cmp_discnt_per, 0, 0, 0, 0, 0, 0, 0 from dual ";
	}
}


query += "		) u "+
"		where u.user_id = v.user_id "+
"	)  ";


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			while(rs.next()){
				avg = rs.getDouble(1);
			}	
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CampaignDatabase:getAvg_Dalsung_200705(String bs_dt, String be_dt, String cs_dt, String ce_dt, int amt, int bus_up_per, int bus_down_per, int mng_up_per, int mng_down_per)]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
                if(rs2 != null )	rs2.close();
                if(pstmt2 != null)	pstmt2.close();
			}catch(Exception ignore){}
			closeConnection();
			return avg;
		}
	}	

	/**
	 * 부서별 할인치,기준치,포상금액 --영업부, 관리부
	 */
	public Vector getCmpleteDept200612(String dept, String bs_dt, String be_dt, String bs_dt2, String be_dt2, String cs_dt, String ce_dt, int up_per, int down_per, int car_amt, int bus_ga, int mng_ga, int bus_new_ga)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		if(dept.equals("0002")){
			bs_dt = bs_dt2;
			be_dt = be_dt2;
			bus_ga = mng_ga;
		}

		//-------------------------------------------------------------------------------------------
		//cs_dt~ce_dt  : 켐페인기간
		//bs_dt~be_dt  : 영업부 평가기준기간
		//bs_dt2~be_dt : 관리부 평가기준기간

		String a_cam	= getCampaignQuery("rent_dt",  cs_dt, ce_dt);
		String a_bas	= getCampaignQuery("rent_dt", bs_dt,  be_dt);

		String b_cam	= getCampaignQuery("rent_start_dt", cs_dt, ce_dt);
		String b_bas	= getCampaignQuery("rent_start_dt", bs_dt,  be_dt);

		String c_cam	= getCampaignQuery2("rent_dt", cs_dt, ce_dt);
		String c_bas	= getCampaignQuery2("rent_dt", bs_dt,  be_dt);

		String d_cam	= getCampaignQuery2("rent_start_dt", cs_dt, ce_dt);
		String d_bas	= getCampaignQuery2("rent_start_dt", bs_dt,  be_dt);

		//출고전해지 감소처리-캠페인기간:해지일기준-켐페인기간3개월전계약
		String e_cam =  "select b.bus_id, count(0) cnt "+
						"from cls_cont a, cont b "+
						"where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd  "+
						"	and cls_st in ('7','10')  "+
						"	and cls_dt between '"+cs_dt+"' and '"+ce_dt+"' "+
						"	and b.rent_dt between to_char(add_months('"+cs_dt+"',-3),'yyyymmdd') and to_char(add_months('"+ce_dt+"',-3),'yyyymmdd') "+
						"group by b.bus_id";

		//6개월전해지 감소처리-캠페인기간:대여개시일기준-6개월이전해지계약
		String f_cam =  "select b.bus_id, count(0) cnt "+
						"from fee a, cont b, (select rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_l_cd) c, cls_cont d "+
						"where "+
						"a.rent_l_cd=b.rent_l_cd "+
						"and a.rent_l_cd=c.rent_l_cd and a.rent_st=c.rent_st "+
						"and a.rent_l_cd=d.rent_l_cd "+
						"and b.car_st<>'2' "+
						"and d.cls_st in ('1','2') "+
						"and b.rent_st not in ('5','7') "+
						"and d.cls_dt between '"+cs_dt+"' and '"+ce_dt+"' "+
						"and to_char(add_months(to_date(a.rent_start_dt,'YYYYMMDD'),6),'YYYYMMDD') > d.cls_dt "+
						"group by b.bus_id";

		//신입사원 기준일자
		String enter_dt = "20060331";
		//-------------------------------------------------------------------------------------------


		query= 
"select u.dept_id, u.user_id, u.user_nm, "+
"       nvl(rent_cnt,0) rent_cnt, nvl(start_cnt,0) start_cnt, cnt1, nvl(r_rent_cnt,0) r_rent_cnt, nvl(r_start_cnt,0) r_start_cnt, to_char(r_cnt,'990.9') r_cnt, "+
"       day, to_char(r_cnt2,'90.9999') r_cnt2, "+
"       to_char(pre_cmp,'90.9999') pre_cmp, to_char(pre_cmp_ga,'90.9999') pre_cmp_ga, "+
"       c_day, to_char(cmp_discnt_per,'90.9999') cmp_discnt_per, "+
"       sum_cnt1, to_char(avg_cnt1,'90.9999') avg_cnt1, sum_r_cnt, to_char(avg_r_cnt, '90.9999') avg_r_cnt, to_char(sum_bus,'90.9999') sum_bus, to_char(avg_bus, '90.9999') avg_bus, to_char(avg_low_bus, '90.9999') avg_low_bus, "+
"       nvl(c_rent_cnt,0) C_RENT_CNT, nvl(c_start_cnt,0) C_START_CNT, nvl(c_cnt,0) C_CNT, "+
"       nvl(cr_rent_cnt,0) CR_RENT_CNT, nvl(cr_start_cnt,0) CR_START_CNT, nvl(cr_cnt,0) CR_CNT, "+
"       to_char(nvl(cr_cnt/cmp_discnt_per,0),'90.9999') DALSUNG, "+
"       round(cr_cnt*nvl(cr_cnt/cmp_discnt_per,0)*"+car_amt+",-3) AMT "+
"	from (select u.user_id, u.user_nm, "+
"				nvl(a.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0) c_rent_cnt,"+
"				nvl(b.cnt,0)-nvl(f.cnt,0) c_start_cnt, "+
"				( nvl(a.cnt,0)+nvl(b.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0)-nvl(f.cnt,0) )/2 c_cnt, "+
"				nvl(c.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0) cr_rent_cnt,"+
"				nvl(d.cnt,0)-nvl(f.cnt,0) cr_start_cnt,"+
"				( nvl(c.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0)+nvl(d.cnt,0)-nvl(f.cnt,0) )/2 cr_cnt "+
"		         from "+
"					("+a_cam+") a, "+
"					("+b_cam+") b, "+
"					("+c_cam+") c, "+
"					("+d_cam+") d, "+
"					("+e_cam+") e, "+
"					("+f_cam+") f, "+
"					users u "+
"		    	where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id=c.bus_id(+) and u.user_id=d.bus_id(+) and u.user_id=e.bus_id(+) and u.user_id=f.bus_id(+)"+
"				and u.dept_id ='"+dept+"' and u.user_pos in ('사원','대리','과장') and u.use_yn='Y' and u.user_id not in ('000001','000015','000031') "+
"		 		) v, "+
"				(select dept_id, user_id, user_nm, rent_cnt, start_cnt, cnt1, r_rent_cnt, r_start_cnt, r_cnt, day, r_cnt2, "+
"						decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2)) pre_cmp, "+
"						decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+bus_ga+"/100 pre_cmp_ga, "+
"						TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, "+
"						(decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+bus_ga+"/100)*(TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1))) cmp_discnt_per "+
"						,sum_cnt1, avg_cnt1, sum_r_cnt, avg_r_cnt, sum_bus, avg_bus, avg_low_bus "+
"		        from "+
"		            (select u.dept_id, u.user_id, u.user_nm, nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1, nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"		                   TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+
"		            	   (nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2 "+
"		            from "+
"						("+a_bas+") a, "+
"						("+b_bas+") b, "+
"						("+c_bas+") c, "+
"						("+d_bas+") d, "+
"						users u "+
"		            where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"		            and u.enter_dt<'20060331' and u.dept_id ='"+dept+"' and u.user_pos in ('사원','대리','과장') and u.use_yn='Y' "+
"		            ) s, "+
"		            (select  sum(cnt1) sum_cnt1, avg(cnt1) avg_cnt1, "+
"		                    sum(r_cnt) sum_r_cnt, avg(r_cnt) avg_r_cnt, "+
"		                    sum(r_cnt2) sum_bus, avg(r_cnt2) avg_bus, "+
"		                    avg(r_cnt2)*"+down_per+"/100 avg_low_bus			 "+
"		            from (select u.dept_id, u.user_id, u.user_nm, nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1, nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"								TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+
"		            			(nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2 "+
"						from "+
"							("+a_bas+") a, "+
"							("+b_bas+") b, "+
"							("+c_bas+") c, "+
"							("+d_bas+") d, "+
"							users u "+
"						where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"						and u.enter_dt<'"+enter_dt+"' and u.dept_id ='"+dept+"' and u.user_pos in ('사원','대리','과장') and u.use_yn='Y' "+
"						) "+
"		            ) t "+
"		) u  "+
"	where u.user_id = v.user_id "+
"	order by dalsung desc, cmp_discnt_per ";

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
			System.out.println("[CampaignDatabase:getCmpleteDept2(String bs_dt, String be_dt, String cs_dt, String ce_dt, int amt, int bus_up_per, int bus_down_per, int mng_up_per, int mng_down_per)]"+e);
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
	 * 부서별 할인치,기준치,포상금액 --영업부, 관리부
	 */
	public Vector getCmpleteDept200704(String dept, String bs_dt, String be_dt, String bs_dt2, String be_dt2, String cs_dt, String ce_dt, int up_per, int down_per, int car_amt, int bus_ga, int mng_ga, int bus_new_ga)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		if(dept.equals("0002")){
			bs_dt = bs_dt2;
			be_dt = be_dt2;
			bus_ga = mng_ga;
		}

		//-------------------------------------------------------------------------------------------
		//cs_dt~ce_dt  : 켐페인기간
		//bs_dt~be_dt  : 영업부 평가기준기간
		//bs_dt2~be_dt : 관리부 평가기준기간

		String a_cam	= getCampaignQuery("rent_dt",  cs_dt, ce_dt);
		String a_bas	= getCampaignQuery("rent_dt", bs_dt,  be_dt);

		String b_cam	= getCampaignQuery("rent_start_dt", cs_dt, ce_dt);
		String b_bas	= getCampaignQuery("rent_start_dt", bs_dt,  be_dt);

		String c_cam	= getCampaignQuery2("rent_dt", cs_dt, ce_dt);
		String c_bas	= getCampaignQuery2("rent_dt", bs_dt,  be_dt);

		String d_cam	= getCampaignQuery2("rent_start_dt", cs_dt, ce_dt);
		String d_bas	= getCampaignQuery2("rent_start_dt", bs_dt,  be_dt);

		//출고전해지 감소처리-캠페인기간:해지일기준-켐페인기간3개월전계약
		String e_cam =  "select b.bus_id, count(0) cnt "+
						"from cls_cont a, cont b "+
						"where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd  "+
						"	and cls_st in ('7','10')  "+
						"	and cls_dt between '"+cs_dt+"' and '"+ce_dt+"' "+
						"	and b.rent_dt between to_char(add_months('"+cs_dt+"',-3),'yyyymmdd') and to_char(add_months('"+ce_dt+"',-3),'yyyymmdd') "+
						"group by b.bus_id";

		//6개월전해지 감소처리-캠페인기간:대여개시일기준-6개월이전해지계약
		String f_cam =  "select b.bus_id, count(0) cnt "+
						"from fee a, cont b, (select rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_l_cd) c, cls_cont d "+
						"where "+
						"a.rent_l_cd=b.rent_l_cd "+
						"and a.rent_l_cd=c.rent_l_cd and a.rent_st=c.rent_st "+
						"and a.rent_l_cd=d.rent_l_cd "+
						"and b.car_st<>'2' "+
						"and d.cls_st in ('1','2') "+
						"and b.rent_st not in ('5','7') "+
						"and d.cls_dt between '"+cs_dt+"' and '"+ce_dt+"' "+
						"and to_char(add_months(to_date(a.rent_start_dt,'YYYYMMDD'),6),'YYYYMMDD') > d.cls_dt "+
						"group by b.bus_id";

		//신입사원 기준일자
		String enter_dt = "20070101";
		//-------------------------------------------------------------------------------------------


		query= 
"select u.dept_id, u.user_id, u.user_nm, "+
"       nvl(rent_cnt,0) rent_cnt, nvl(start_cnt,0) start_cnt, cnt1, nvl(r_rent_cnt,0) r_rent_cnt, nvl(r_start_cnt,0) r_start_cnt, to_char(r_cnt,'990.9') r_cnt, "+
"       day, to_char(r_cnt2,'90.9999') r_cnt2, "+
"       to_char(pre_cmp,'90.9999') pre_cmp, to_char(pre_cmp_ga,'90.9999') pre_cmp_ga, "+
"       c_day, to_char(cmp_discnt_per,'90.9999') cmp_discnt_per, "+
"       sum_cnt1, to_char(avg_cnt1,'90.9999') avg_cnt1, sum_r_cnt, to_char(avg_r_cnt, '90.9999') avg_r_cnt, to_char(sum_bus,'90.9999') sum_bus, to_char(avg_bus, '90.9999') avg_bus, to_char(avg_low_bus, '90.9999') avg_low_bus, "+
"       nvl(c_rent_cnt,0) C_RENT_CNT, nvl(c_start_cnt,0) C_START_CNT, nvl(c_cnt,0) C_CNT, "+
"       nvl(cr_rent_cnt,0) CR_RENT_CNT, nvl(cr_start_cnt,0) CR_START_CNT, nvl(cr_cnt,0) CR_CNT, "+
"       to_char(nvl(cr_cnt/cmp_discnt_per,0),'90.9999') DALSUNG, "+
"       round(cr_cnt*nvl(cr_cnt/cmp_discnt_per,0)*"+car_amt+",-3) AMT "+
"	from (select u.user_id, u.user_nm, "+
"				nvl(a.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0) c_rent_cnt,"+
"				nvl(b.cnt,0)-nvl(f.cnt,0) c_start_cnt, "+
"				( nvl(a.cnt,0)+nvl(b.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0)-nvl(f.cnt,0) )/2 c_cnt, "+
"				nvl(c.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0) cr_rent_cnt,"+
"				nvl(d.cnt,0)-nvl(f.cnt,0) cr_start_cnt,"+
"				( nvl(c.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0)+nvl(d.cnt,0)-nvl(f.cnt,0) )/2 cr_cnt "+
"		         from "+
"					("+a_cam+") a, "+
"					("+b_cam+") b, "+
"					("+c_cam+") c, "+
"					("+d_cam+") d, "+
"					("+e_cam+") e, "+
"					("+f_cam+") f, "+
"					users u "+
"		    	where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id=c.bus_id(+) and u.user_id=d.bus_id(+) and u.user_id=e.bus_id(+) and u.user_id=f.bus_id(+)"+
"				and u.dept_id ='"+dept+"' and u.user_pos in ('사원','대리','과장') and u.use_yn='Y' and u.user_id not in ('000001','000015','000031') "+
"		 		) v, "+
"				(select dept_id, user_id, user_nm, rent_cnt, start_cnt, cnt1, r_rent_cnt, r_start_cnt, r_cnt, day, r_cnt2, "+
"						decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2)) pre_cmp, "+
"						decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+bus_ga+"/100 pre_cmp_ga, "+
"						TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, "+
"						(decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+bus_ga+"/100)*(TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1))) cmp_discnt_per "+
"						,sum_cnt1, avg_cnt1, sum_r_cnt, avg_r_cnt, sum_bus, avg_bus, avg_low_bus "+
"		        from "+
"		            (select u.dept_id, u.user_id, u.user_nm, nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1, nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"		                   TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+
"		            	   (nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2 "+
"		            from "+
"						("+a_bas+") a, "+
"						("+b_bas+") b, "+
"						("+c_bas+") c, "+
"						("+d_bas+") d, "+
"						users u "+
"		            where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"		            and u.enter_dt<'"+enter_dt+"' and u.dept_id ='"+dept+"' and u.user_pos in ('사원','대리','과장') and u.use_yn='Y' "+
"		            ) s, "+
"		            (select  sum(cnt1) sum_cnt1, avg(cnt1) avg_cnt1, "+
"		                    sum(r_cnt) sum_r_cnt, avg(r_cnt) avg_r_cnt, "+
"		                    sum(r_cnt2) sum_bus, avg(r_cnt2) avg_bus, "+
"		                    avg(r_cnt2)*"+down_per+"/100 avg_low_bus			 "+
"		            from (select u.dept_id, u.user_id, u.user_nm, nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1, nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"								TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+
"		            			(nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2 "+
"						from "+
"							("+a_bas+") a, "+
"							("+b_bas+") b, "+
"							("+c_bas+") c, "+
"							("+d_bas+") d, "+
"							users u "+
"						where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"						and u.enter_dt<'"+enter_dt+"' and u.dept_id ='"+dept+"' and u.user_pos in ('사원','대리','과장') and u.use_yn='Y' "+
"						) "+
"		            ) t "+
"		) u  "+
"	where u.user_id = v.user_id "+
"	order by to_number(dalsung) desc, cmp_discnt_per ";

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
			System.out.println("[CampaignDatabase:getCmpleteDept2(String bs_dt, String be_dt, String cs_dt, String ce_dt, int amt, int bus_up_per, int bus_down_per, int mng_up_per, int mng_down_per)]"+e);
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
	 * 부서별 할인치,기준치,포상금액 --신입사원
	 */
	public Vector getCmpleteDeptNew200612(int cnt1, int mon, String cnt2, String cs_dt, String ce_dt, String bs_dt, String be_dt, float cmp_discnt_per, int car_amt, int bus_new_ga)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		//-------------------------------------------------------------------------------------------
		//cs_dt~ce_dt  : 켐페인기간
		//bs_dt~be_dt  : 영업부 평가기준기간
		//bs_dt2~be_dt : 관리부 평가기준기간

		String a_cam	= getCampaignQuery("rent_dt",  cs_dt, ce_dt);
		String a_bas	= getCampaignQuery("rent_dt", bs_dt,  be_dt);

		String b_cam	= getCampaignQuery("rent_start_dt", cs_dt, ce_dt);
		String b_bas	= getCampaignQuery("rent_start_dt", bs_dt,  be_dt);

		String c_cam	= getCampaignQuery2("rent_dt", cs_dt, ce_dt);
		String c_bas	= getCampaignQuery2("rent_dt", bs_dt,  be_dt);

		String d_cam	= getCampaignQuery2("rent_start_dt", cs_dt, ce_dt);
		String d_bas	= getCampaignQuery2("rent_start_dt", bs_dt,  be_dt);

		//출고전해지 감소처리-캠페인기간:해지일기준-켐페인기간3개월전계약
		String e_cam =  "select b.bus_id, count(0) cnt "+
						"from cls_cont a, cont b "+
						"where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd  "+
						"	and cls_st in ('7','10')  "+
						"	and cls_dt between '"+cs_dt+"' and '"+ce_dt+"' "+
						"	and b.rent_dt between to_char(add_months('"+cs_dt+"',-3),'yyyymmdd') and to_char(add_months('"+ce_dt+"',-3),'yyyymmdd') "+
						"group by b.bus_id";

		//6개월전해지 감소처리-캠페인기간:대여개시일기준-6개월이전해지계약
		String f_cam =  "select b.bus_id, count(0) cnt "+
						"from fee a, cont b, (select rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_l_cd) c, cls_cont d "+
						"where "+
						"a.rent_l_cd=b.rent_l_cd "+
						"and a.rent_l_cd=c.rent_l_cd and a.rent_st=c.rent_st "+
						"and a.rent_l_cd=d.rent_l_cd "+
						"and b.car_st<>'2' "+
						"and d.cls_st in ('1','2') "+
						"and b.rent_st not in ('5','7') "+
						"and d.cls_dt between '"+cs_dt+"' and '"+ce_dt+"' "+
						"and to_char(add_months(to_date(a.rent_start_dt,'YYYYMMDD'),6),'YYYYMMDD') > d.cls_dt "+
						"group by b.bus_id";

		//신입사원 기준일자
		String enter_dt = "20060331";
		//-------------------------------------------------------------------------------------------

		query= 
"	select dept_id, u.bus_id, u.user_nm, cnt1, to_char(cnt1,'990.9') r_cnt, day, to_char(r_cnt2,'90.9999') r_cnt2, to_char(pre_cmp,'90.9999') pre_cmp, to_char(pre_cmp_ga,'90.9999') pre_cmp_ga, c_day, to_char(cmp_discnt_per,'90.9999') cmp_discnt_per, "+
"			C_RENT_CNT, C_START_CNT, to_char(c_cnt,'990.9') C_CNT, to_char(cr_rent_cnt,'990.9') CR_RENT_CNT, to_char(cr_start_cnt,'990.9') CR_START_CNT, to_char(cr_cnt,'990.99') CR_CNT, to_char(nvl(cr_cnt/cmp_discnt_per,0),'90.9999') DALSUNG, round(cr_cnt*nvl(cr_cnt/cmp_discnt_per,0)*"+car_amt+",-3) AMT "+
"	from (select u.user_id, u.user_nm, nvl(a.cnt,0) c_rent_cnt, nvl(b.cnt,0) c_start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 c_cnt, nvl(c.cnt,0) cr_rent_cnt, nvl(d.cnt,0) cr_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 cr_cnt "+
"		         from "+
"					("+a_cam+") a, "+
"					("+b_cam+") b, "+
"					("+c_cam+") c, "+
"					("+d_cam+") d, "+
"					users u "+
"		    	where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id=c.bus_id(+) and u.user_id=d.bus_id(+) and u.dept_id ='0001' and u.user_pos in ('사원','대리','과장') and u.use_yn='Y' and u.user_id not in ('000001','000015','000031') "+
"		 ) v, "+
"		(	select '0001' dept_id, '000059' bus_id, '김영호' user_nm,"+cnt1+" cnt1, "+cnt1+" r_cnt, TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) pre_cmp, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100 pre_cmp_ga, TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, ("+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100)*TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) cmp_discnt_per from dual "+
"			union "+
"			select '0001' dept_id, '000060' bus_id, '최인석' user_nm,"+cnt1+" cnt1, "+cnt1+" r_cnt, TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) pre_cmp, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100 pre_cmp_ga, TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, ("+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100)*TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) cmp_discnt_per from dual "+
"			order by 1 "+
"		) u "+
"	where u.bus_id = v.user_id "+
"	order by dalsung desc, cmp_discnt_per ";

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
			System.out.println("[CampaignDatabase:getCmpleteDeptNew2(String bs_dt, String be_dt, String cs_dt, String ce_dt, int amt, int bus_up_per, int bus_down_per, int mng_up_per, int mng_down_per)]"+e);
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
	 * 부서별 할인치,기준치,포상금액 --신입사원
	 */
	public Vector getCmpleteDeptNew200704(int cnt1, int mon, String cnt2, String cs_dt, String ce_dt, String bs_dt, String be_dt, float cmp_discnt_per, int car_amt, int bus_new_ga)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		//-------------------------------------------------------------------------------------------
		//cs_dt~ce_dt  : 켐페인기간
		//bs_dt~be_dt  : 영업부 평가기준기간
		//bs_dt2~be_dt : 관리부 평가기준기간

		String a_cam	= getCampaignQuery("rent_dt",  cs_dt, ce_dt);
		String a_bas	= getCampaignQuery("rent_dt", bs_dt,  be_dt);

		String b_cam	= getCampaignQuery("rent_start_dt", cs_dt, ce_dt);
		String b_bas	= getCampaignQuery("rent_start_dt", bs_dt,  be_dt);

		String c_cam	= getCampaignQuery2("rent_dt", cs_dt, ce_dt);
		String c_bas	= getCampaignQuery2("rent_dt", bs_dt,  be_dt);

		String d_cam	= getCampaignQuery2("rent_start_dt", cs_dt, ce_dt);
		String d_bas	= getCampaignQuery2("rent_start_dt", bs_dt,  be_dt);

		//출고전해지 감소처리-캠페인기간:해지일기준-켐페인기간3개월전계약
		String e_cam =  "select b.bus_id, count(0) cnt "+
						"from cls_cont a, cont b "+
						"where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd  "+
						"	and cls_st in ('7','10')  "+
						"	and cls_dt between '"+cs_dt+"' and '"+ce_dt+"' "+
						"	and b.rent_dt between to_char(add_months('"+cs_dt+"',-3),'yyyymmdd') and to_char(add_months('"+ce_dt+"',-3),'yyyymmdd') "+
						"group by b.bus_id";

		//6개월전해지 감소처리-캠페인기간:대여개시일기준-6개월이전해지계약
		String f_cam =  "select b.bus_id, count(0) cnt "+
						"from fee a, cont b, (select rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_l_cd) c, cls_cont d "+
						"where "+
						"a.rent_l_cd=b.rent_l_cd "+
						"and a.rent_l_cd=c.rent_l_cd and a.rent_st=c.rent_st "+
						"and a.rent_l_cd=d.rent_l_cd "+
						"and b.car_st<>'2' "+
						"and d.cls_st in ('1','2') "+
						"and b.rent_st not in ('5','7') "+
						"and d.cls_dt between '"+cs_dt+"' and '"+ce_dt+"' "+
						"and to_char(add_months(to_date(a.rent_start_dt,'YYYYMMDD'),6),'YYYYMMDD') > d.cls_dt "+
						"group by b.bus_id";

		//신입사원 기준일자
		String enter_dt = "20070101";
		//-------------------------------------------------------------------------------------------

		query= 
"	select dept_id, u.bus_id, u.user_nm, cnt1, to_char(cnt1,'990.9') r_cnt, day, to_char(r_cnt2,'90.9999') r_cnt2, to_char(pre_cmp,'90.9999') pre_cmp, to_char(pre_cmp_ga,'90.9999') pre_cmp_ga, c_day, to_char(cmp_discnt_per,'90.9999') cmp_discnt_per, "+
"			C_RENT_CNT, C_START_CNT, to_char(c_cnt,'990.9') C_CNT, to_char(cr_rent_cnt,'990.9') CR_RENT_CNT, to_char(cr_start_cnt,'990.9') CR_START_CNT, to_char(cr_cnt,'990.99') CR_CNT, to_char(nvl(cr_cnt/cmp_discnt_per,0),'90.9999') DALSUNG, round(cr_cnt*nvl(cr_cnt/cmp_discnt_per,0)*"+car_amt+",-3) AMT "+
"	from (select u.user_id, u.user_nm, nvl(a.cnt,0) c_rent_cnt, nvl(b.cnt,0) c_start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 c_cnt, nvl(c.cnt,0) cr_rent_cnt, nvl(d.cnt,0) cr_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 cr_cnt "+
"		         from "+
"					("+a_cam+") a, "+
"					("+b_cam+") b, "+
"					("+c_cam+") c, "+
"					("+d_cam+") d, "+
"					users u "+
"		    	where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id=c.bus_id(+) and u.user_id=d.bus_id(+) and u.dept_id ='0001' and u.user_pos in ('사원','대리','과장') and u.use_yn='Y' and u.user_id not in ('000001','000015','000031') "+
"		 ) v, "+
"		(	"+
"			select '0001' dept_id, '000059' bus_id, '김영호' user_nm,"+cnt1+" cnt1, "+cnt1+" r_cnt, TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) pre_cmp, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100 pre_cmp_ga, TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, ("+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100)*TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) cmp_discnt_per from dual "+
"			union "+
"			select '0001' dept_id, '000060' bus_id, '최인석' user_nm,"+cnt1+" cnt1, "+cnt1+" r_cnt, TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) pre_cmp, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100 pre_cmp_ga, TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, ("+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100)*TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) cmp_discnt_per from dual "+
"			order by 1 "+
"		) u "+
"	where u.bus_id = v.user_id "+
"	order by dalsung desc, cmp_discnt_per ";

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
			System.out.println("[CampaignDatabase:getCmpleteDeptNew200704(String bs_dt, String be_dt, String cs_dt, String ce_dt, int amt, int bus_up_per, int bus_down_per, int mng_up_per, int mng_down_per)]"+e);
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
	 *	영업캠페인 등록
	 */
	public boolean insertStatBusCmp(StatBusCmpBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query = " insert into stat_bus_cmp "+
						" (save_dt, seq, bus_id, rent_cnt, start_cnt, cnt1, r_rent_cnt, r_start_cnt, r_cnt, day,"+
						"  r_cnt2, pre_cmp, pre_cmp_ga, c_day, cmp_discnt_per, c_rent_cnt, c_start_cnt, c_cnt, cr_rent_cnt, cr_start_cnt,"+
						"  cr_cnt, dalsung, amt, avg_dalsung, amt2, sum_cnt1, sum_r_cnt, sum_bus, avg_cnt1, avg_r_cnt, "+
						"  avg_bus, avg_low_bus, v_bs_dt, v_be_dt, v_bs_dt2, v_be_dt2, v_cs_dt, v_ce_dt, v_car_amt, v_bus_up_per, "+
						"  v_bus_down_per, v_mng_up_per, v_mng_down_per, v_bus_amt_per, v_mng_amt_per, v_cnt1, v_mon, v_cnt2, v_cmp_discnt_per, v_max_dalsung, "+
						"  v_bus_ga, v_mng_ga, v_bus_new_ga, reg_dt, v_enter_dt, org_dalsung,"+
						"  v_ns_dt1, v_ns_dt2, v_ns_dt3, v_ne_dt1, v_ne_dt2, v_ne_dt3, v_nm_cnt1, v_nm_cnt2, v_nm_cnt3, v_nb_cnt1, v_nb_cnt2, v_nb_cnt3,"+
						"  day2, r_cost_cnt, c_cost_cnt, r_cnt2_1, r_cnt2_2, sum_cost_cnt, sum_bus_1, sum_bus_2, avg_cost_cnt, avg_bus_1, avg_bus_2, c_tot_cnt, "+
						"  v_cnt_per, v_cost_per, avg_car_cost_1, avg_car_cost_2, r_cost_amt, c_cost_amt, cost_cnt1, cost_cnt2, "+
						"  v_car_amt2, v_cnt_per2, v_cost_per2, v_max_dalsung2 "+
						" ) "+
						" values "+
						" ( "+
						"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
						"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
						"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
						"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
						"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
						"   ?, ?, ?, sysdate, ?, ?,"+
						"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
						"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
						"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?  "+
						"  )";


		try 
		{

			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1,  bean.getSave_dt				().trim());		
			pstmt.setString(2,  bean.getSeq					().trim());	
			pstmt.setString(3,  bean.getBus_id				().trim());
			pstmt.setString(4,  bean.getRent_cnt			().trim());
			pstmt.setString(5,  bean.getStart_cnt			().trim());
			pstmt.setString(6,  bean.getCnt1				().trim());
			pstmt.setString(7,  bean.getR_rent_cnt			().trim());
			pstmt.setString(8,  bean.getR_start_cnt			().trim());
			pstmt.setString(9,  bean.getR_cnt				().trim());		
			pstmt.setString(10, bean.getDay					().trim());
			pstmt.setString(11, bean.getR_cnt2				().trim());		
			pstmt.setString(12, bean.getPre_cmp				().trim());	
			pstmt.setString(13, bean.getPre_cmp_ga			().trim());
			pstmt.setString(14, bean.getC_day				().trim());
			pstmt.setString(15, bean.getCmp_discnt_per		().trim());
			pstmt.setString(16, bean.getC_rent_cnt			().trim());
			pstmt.setString(17, bean.getC_start_cnt			().trim());
			pstmt.setString(18, bean.getC_cnt				().trim());
			pstmt.setString(19, bean.getCr_rent_cnt			().trim());		
			pstmt.setString(20, bean.getCr_start_cnt		().trim());
			pstmt.setString(21, bean.getCr_cnt				().trim());		
			pstmt.setString(22, bean.getDalsung				().trim());	
			pstmt.setString(23, bean.getAmt					().trim());
			pstmt.setString(24, bean.getAvg_dalsung			().trim());
			pstmt.setString(25, bean.getAmt2				().trim());
			pstmt.setString(26, bean.getSum_cnt1			().trim());
			pstmt.setString(27, bean.getSum_r_cnt			().trim());
			pstmt.setString(28, bean.getSum_bus				().trim());
			pstmt.setString(29, bean.getAvg_cnt1			().trim());		
			pstmt.setString(30, bean.getAvg_r_cnt			().trim());
			pstmt.setString(31, bean.getAvg_bus				().trim());		
			pstmt.setString(32, bean.getAvg_low_bus			().trim());	
			pstmt.setString(33, bean.getV_bs_dt				().trim());
			pstmt.setString(34, bean.getV_be_dt				().trim());
			pstmt.setString(35, bean.getV_bs_dt2			().trim());
			pstmt.setString(36, bean.getV_be_dt2			().trim());
			pstmt.setString(37, bean.getV_cs_dt				().trim());
			pstmt.setString(38, bean.getV_ce_dt				().trim());
			pstmt.setString(39, bean.getV_car_amt			().trim());		
			pstmt.setString(40, bean.getV_bus_up_per		().trim());
			pstmt.setString(41, bean.getV_bus_down_per		().trim());		
			pstmt.setString(42, bean.getV_mng_up_per		().trim());	
			pstmt.setString(43, bean.getV_mng_down_per		().trim());
			pstmt.setString(44, bean.getV_bus_amt_per		().trim());
			pstmt.setString(45, bean.getV_mng_amt_per		().trim());
			pstmt.setString(46, bean.getV_cnt1				().trim());
			pstmt.setString(47, bean.getV_mon				().trim());
			pstmt.setString(48, bean.getV_cnt2				().trim());
			pstmt.setString(49, bean.getV_cmp_discnt_per	().trim());		
			pstmt.setString(50, bean.getV_max_dalsung		().trim());
			pstmt.setString(51, bean.getV_bus_ga			().trim());		
			pstmt.setString(52, bean.getV_mng_ga			().trim());	
			pstmt.setString(53, bean.getV_bus_new_ga		().trim());
			pstmt.setString(54, bean.getV_enter_dt			().trim());
			pstmt.setString(55, bean.getOrg_dalsung			().trim());
			pstmt.setString(56, bean.getV_ns_dt1			().trim());
			pstmt.setString(57, bean.getV_ns_dt2			().trim());
			pstmt.setString(58, bean.getV_ns_dt3			().trim());
			pstmt.setString(59, bean.getV_ne_dt1			().trim());
			pstmt.setString(60, bean.getV_ne_dt2			().trim());
			pstmt.setString(61, bean.getV_ne_dt3			().trim());
			pstmt.setString(62, bean.getV_nm_cnt1			().trim());
			pstmt.setString(63, bean.getV_nm_cnt2			().trim());
			pstmt.setString(64, bean.getV_nm_cnt3			().trim());
			pstmt.setString(65, bean.getV_nb_cnt1			().trim());
			pstmt.setString(66, bean.getV_nb_cnt2			().trim());
			pstmt.setString(67, bean.getV_nb_cnt3			().trim());

			pstmt.setString(68, bean.getDay2				().trim());
			pstmt.setString(69, bean.getR_cost_cnt			().trim());		
			pstmt.setString(70, bean.getC_cost_cnt			().trim());
			pstmt.setString(71, bean.getR_cnt2_1			().trim());		
			pstmt.setString(72, bean.getR_cnt2_2			().trim());	
			pstmt.setString(73, bean.getSum_cost_cnt		().trim());
			pstmt.setString(74, bean.getSum_bus_1			().trim());
			pstmt.setString(75, bean.getSum_bus_2			().trim());
			pstmt.setString(76, bean.getAvg_cost_cnt		().trim());
			pstmt.setString(77, bean.getAvg_bus_1			().trim());
			pstmt.setString(78, bean.getAvg_bus_2			().trim());
			pstmt.setString(79, bean.getC_tot_cnt			().trim());
			pstmt.setString(80, bean.getV_cnt_per			().trim());
			pstmt.setString(81, bean.getV_cost_per			().trim());
			pstmt.setString(82, bean.getAvg_car_cost_1		().trim());
			pstmt.setString(83, bean.getAvg_car_cost_2		().trim());
			pstmt.setString(84, bean.getR_cost_amt			().trim());		
			pstmt.setString(85, bean.getC_cost_amt			().trim());
			pstmt.setString(86, bean.getCost_cnt1			().trim());		
			pstmt.setString(87, bean.getCost_cnt2			().trim());
			
			pstmt.setString(88, bean.getV_car_amt2			().trim());		
			pstmt.setString(89, bean.getV_cnt_per2			().trim());
			pstmt.setString(90, bean.getV_cost_per2			().trim());
			pstmt.setString(91, bean.getV_max_dalsung2		().trim());


		    pstmt.executeUpdate();
			pstmt.close();

		    
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[CampaignDatabase:insertStatBusCmp]"+e);
			System.out.println("[bean.getSave_dt			()]"+bean.getSave_dt			());
			System.out.println("[bean.getSeq				()]"+bean.getSeq				());
			System.out.println("[bean.getBus_id				()]"+bean.getBus_id				());
			System.out.println("[bean.getRent_cnt			()]"+bean.getRent_cnt			());
			System.out.println("[bean.getStart_cnt			()]"+bean.getStart_cnt			());
			System.out.println("[bean.getCnt1				()]"+bean.getCnt1				());
			System.out.println("[bean.getR_rent_cnt			()]"+bean.getR_rent_cnt			());
			System.out.println("[bean.getR_start_cnt		()]"+bean.getR_start_cnt		());
			System.out.println("[bean.getR_cnt				()]"+bean.getR_cnt				());
			System.out.println("[bean.getDay				()]"+bean.getDay				());
			System.out.println("[bean.getR_cnt2				()]"+bean.getR_cnt2				());
			System.out.println("[bean.getPre_cmp			()]"+bean.getPre_cmp			());
			System.out.println("[bean.getPre_cmp_ga			()]"+bean.getPre_cmp_ga			());
			System.out.println("[bean.getC_day				()]"+bean.getC_day				());
			System.out.println("[bean.getCmp_discnt_per		()]"+bean.getCmp_discnt_per		());
			System.out.println("[bean.getC_rent_cnt			()]"+bean.getC_rent_cnt			());
			System.out.println("[bean.getC_start_cnt		()]"+bean.getC_start_cnt		());
			System.out.println("[bean.getC_cnt				()]"+bean.getC_cnt				());
			System.out.println("[bean.getCr_rent_cnt		()]"+bean.getCr_rent_cnt		());
			System.out.println("[bean.getCr_start_cnt		()]"+bean.getCr_start_cnt		());
			System.out.println("[bean.getCr_cnt				()]"+bean.getCr_cnt				());
			System.out.println("[bean.getDalsung			()]"+bean.getDalsung			());
			System.out.println("[bean.getAmt				()]"+bean.getAmt				());
			System.out.println("[bean.getAvg_dalsung		()]"+bean.getAvg_dalsung		());
			System.out.println("[bean.getAmt2				()]"+bean.getAmt2				());
			System.out.println("[bean.getSum_cnt1			()]"+bean.getSum_cnt1			());
			System.out.println("[bean.getSum_r_cnt			()]"+bean.getSum_r_cnt			());
			System.out.println("[bean.getSum_bus			()]"+bean.getSum_bus			());
			System.out.println("[bean.getAvg_cnt1			()]"+bean.getAvg_cnt1			());
			System.out.println("[bean.getAvg_r_cnt			()]"+bean.getAvg_r_cnt			());
			System.out.println("[bean.getAvg_bus			()]"+bean.getAvg_bus			());
			System.out.println("[bean.getAvg_low_bus		()]"+bean.getAvg_low_bus		());
			System.out.println("[bean.getV_bs_dt			()]"+bean.getV_bs_dt			());
			System.out.println("[bean.getV_be_dt			()]"+bean.getV_be_dt			());
			System.out.println("[bean.getV_bs_dt2			()]"+bean.getV_bs_dt2			());
			System.out.println("[bean.getV_be_dt2			()]"+bean.getV_be_dt2			());
			System.out.println("[bean.getV_cs_dt			()]"+bean.getV_cs_dt			());
			System.out.println("[bean.getV_ce_dt			()]"+bean.getV_ce_dt			());
			System.out.println("[bean.getV_car_amt			()]"+bean.getV_car_amt			());
			System.out.println("[bean.getV_bus_up_per		()]"+bean.getV_bus_up_per		());
			System.out.println("[bean.getV_bus_down_per		()]"+bean.getV_bus_down_per		());
			System.out.println("[bean.getV_mng_up_per		()]"+bean.getV_mng_up_per		());
			System.out.println("[bean.getV_mng_down_per		()]"+bean.getV_mng_down_per		());
			System.out.println("[bean.getV_bus_amt_per		()]"+bean.getV_bus_amt_per		());
			System.out.println("[bean.getV_mng_amt_per		()]"+bean.getV_mng_amt_per		());
			System.out.println("[bean.getV_cnt1				()]"+bean.getV_cnt1				());
			System.out.println("[bean.getV_mon				()]"+bean.getV_mon				());
			System.out.println("[bean.getV_cnt2				()]"+bean.getV_cnt2				());
			System.out.println("[bean.getV_cmp_discnt_per	()]"+bean.getV_cmp_discnt_per	());
			System.out.println("[bean.getV_max_dalsung		()]"+bean.getV_max_dalsung		());
			System.out.println("[bean.getV_bus_ga			()]"+bean.getV_bus_ga			());
			System.out.println("[bean.getV_mng_ga			()]"+bean.getV_mng_ga			());
			System.out.println("[bean.getV_bus_new_ga		()]"+bean.getV_bus_new_ga		());
			System.out.println("[bean.getDay2				()]"+bean.getDay2				());
			System.out.println("[bean.getR_cost_cnt			()]"+bean.getR_cost_cnt			());
			System.out.println("[bean.getC_cost_cnt			()]"+bean.getC_cost_cnt			());
			System.out.println("[bean.getR_cnt2_1			()]"+bean.getR_cnt2_1			());
			System.out.println("[bean.getR_cnt2_2			()]"+bean.getR_cnt2_2			());
			System.out.println("[bean.getSum_cost_cnt		()]"+bean.getSum_cost_cnt		());
			System.out.println("[bean.getSum_bus_1			()]"+bean.getSum_bus_1			());
			System.out.println("[bean.getSum_bus_2			()]"+bean.getSum_bus_2			());
			System.out.println("[bean.getAvg_cost_cnt		()]"+bean.getAvg_cost_cnt		());
			System.out.println("[bean.getAvg_bus_1			()]"+bean.getAvg_bus_1			());
			System.out.println("[bean.getAvg_bus_2			()]"+bean.getAvg_bus_2			());
			System.out.println("[bean.getC_tot_cnt			()]"+bean.getC_tot_cnt			());
			System.out.println("[bean.getV_cnt_per			()]"+bean.getV_cnt_per			());
			System.out.println("[bean.getV_cost_per			()]"+bean.getV_cost_per			());
			System.out.println("[bean.getAvg_car_cost_1		()]"+bean.getAvg_car_cost_1		());
			System.out.println("[bean.getAvg_car_cost_2		()]"+bean.getAvg_car_cost_2		());
			System.out.println("[bean.getR_cost_amt			()]"+bean.getR_cost_amt			());
			System.out.println("[bean.getC_cost_amt			()]"+bean.getC_cost_amt			());
			System.out.println("[bean.getCost_cnt1			()]"+bean.getCost_cnt1			());
			System.out.println("[bean.getCost_cnt2			()]"+bean.getCost_cnt2			());
			System.out.println("[bean.getV_car_amt2			()]"+bean.getV_car_amt2			());
			System.out.println("[bean.getV_cnt_per2			()]"+bean.getV_cnt_per2			());
			System.out.println("[bean.getV_cost_per2		()]"+bean.getV_cost_per2		());
			System.out.println("[bean.getV_max_dalsung2		()]"+bean.getV_max_dalsung2		());


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
	 * 결과 : 2007-04 - 김영호,최인석 신입에서 뺌
	*/
	public Vector getCampaign_200707(String bs_dt, String be_dt, String bs_dt2, String be_dt2, String cs_dt, String ce_dt, int car_amt, int bus_up_per, int bus_down_per, int mng_up_per, int mng_down_per, int bus_amt_per, int mng_amt_per, int cnt1, int mon, String cnt2, float cmp_discnt_per, int max_dalsung, int bus_ga, int mng_ga, int bus_new_ga, String enter_dt, String ns_dt1, String ns_dt2, String ns_dt3, String ne_dt1, String ne_dt2, String ne_dt3, int nm_cnt1, int nm_cnt2, int nm_cnt3, int nb_cnt1, int nb_cnt2, int nb_cnt3)
	{
		getConnection();

		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		PreparedStatement pstmt4 = null;
		ResultSet rs = null;
		ResultSet rs2 = null;
		ResultSet rs3 = null;
		ResultSet rs4= null;
		Vector vt = new Vector();
		Vector vt2 = new Vector();
		Vector vt3 = new Vector();
		Vector vt4 = new Vector();

		String client_11 = "";

		//-------------------------------------------------------------------------------------------
		//cs_dt~ce_dt  : 켐페인기간
		//bs_dt~be_dt  : 영업부 평가기준기간
		//bs_dt2~be_dt : 관리부 평가기준기간

		String a_cam	= getCampaignQuery("rent_dt",  cs_dt, ce_dt);
		String a_bas	= getCampaignQuery("rent_dt", bs_dt,  be_dt);
		String a_bas2	= getCampaignQuery("rent_dt", bs_dt2, be_dt2);

		String b_cam	= getCampaignQuery("rent_start_dt", cs_dt, ce_dt);
		String b_bas	= getCampaignQuery("rent_start_dt", bs_dt,  be_dt);
		String b_bas2	= getCampaignQuery("rent_start_dt", bs_dt2, be_dt2);

		String c_cam	= getCampaignQuery2("rent_dt", cs_dt, ce_dt);
		String c_bas	= getCampaignQuery2("rent_dt", bs_dt,  be_dt);
		String c_bas2	= getCampaignQuery2("rent_dt", bs_dt2, be_dt2);

		String d_cam	= getCampaignQuery2("rent_start_dt", cs_dt, ce_dt);
		String d_bas	= getCampaignQuery2("rent_start_dt", bs_dt,  be_dt);
		String d_bas2	= getCampaignQuery2("rent_start_dt", bs_dt2, be_dt2);

		//출고전해지 감소처리-캠페인기간:해지일기준-켐페인기간3개월전계약
		String e_cam =  "select b.bus_id, count(0) cnt "+
						"from cls_cont a, cont b "+
						"where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd  "+
						"	and cls_st in ('7','10')  "+
						"	and cls_dt between '"+cs_dt+"' and '"+ce_dt+"' "+
						"group by b.bus_id";

		//6개월전해지 감소처리-캠페인기간:대여개시일기준-6개월이전해지계약
		String f_cam =  "select nvl(a.ext_agnt,b.bus_id) bus_id, count(0) cnt "+
						"from fee a, cont b, (select rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_l_cd) c, cls_cont d "+
						"where "+
						"a.rent_l_cd=b.rent_l_cd "+
						"and a.rent_l_cd=c.rent_l_cd and a.rent_st=c.rent_st "+
						"and a.rent_l_cd=d.rent_l_cd "+
						"and b.car_st<>'2' "+
						"and d.cls_st in ('1','2') "+
						"and to_number(a.con_mon) >=6 "+
						"and d.cls_dt between '"+cs_dt+"' and '"+ce_dt+"' "+
						"and to_char(add_months(to_date(b.rent_dt,'YYYYMMDD')-1,6),'YYYYMMDD') > d.cls_dt "+
						"group by nvl(a.ext_agnt,b.bus_id)";

		//-------------------------------------------------------------------------------------------

		String query = "";

		//신입사원리스트
		String query2 = "select * from users where use_yn='Y' and loan_st is not null and sysdate-to_date(enter_dt,'YYYYMMDD') < 365 and enter_dt between '"+ns_dt1+"' and '"+ne_dt1+"'";
		String query3 = "select * from users where use_yn='Y' and loan_st is not null and sysdate-to_date(enter_dt,'YYYYMMDD') < 365 and enter_dt between '"+ns_dt2+"' and '"+ne_dt2+"'";
		String query4 = "select * from users where use_yn='Y' and loan_st is not null and sysdate-to_date(enter_dt,'YYYYMMDD') < 365 and enter_dt between '"+ns_dt3+"' and '"+ne_dt3+"'";

		try {

			if(!ns_dt1.equals("")){
				pstmt2 = conn.prepareStatement(query2);
		    	rs2 = pstmt2.executeQuery();

				ResultSetMetaData rsmd2 = rs2.getMetaData();    	
				while(rs2.next())
				{				
					Hashtable ht = new Hashtable();
					for(int pos =1; pos <= rsmd2.getColumnCount();pos++)
					{
						 String columnName = rsmd2.getColumnName(pos);
						 ht.put(columnName, (rs2.getString(columnName))==null?"":rs2.getString(columnName));
					}
					vt2.add(ht);	
				}
				rs2.close();
				pstmt2.close();
			}

			if(!ns_dt2.equals("")){
				pstmt3 = conn.prepareStatement(query3);
		    	rs3 = pstmt3.executeQuery();

				ResultSetMetaData rsmd3 = rs3.getMetaData();    	
				while(rs3.next())
				{				
					Hashtable ht = new Hashtable();
					for(int pos =1; pos <= rsmd3.getColumnCount();pos++)
					{
						 String columnName = rsmd3.getColumnName(pos);
						 ht.put(columnName, (rs3.getString(columnName))==null?"":rs3.getString(columnName));
					}
					vt3.add(ht);	
				}
				rs3.close();
				pstmt3.close();
			}

			if(!ns_dt3.equals("")){
				pstmt4 = conn.prepareStatement(query4);
		    	rs4 = pstmt4.executeQuery();

				ResultSetMetaData rsmd4 = rs4.getMetaData();    	
				while(rs4.next())
				{				
					Hashtable ht = new Hashtable();
					for(int pos =1; pos <= rsmd4.getColumnCount();pos++)
					{
						 String columnName = rsmd4.getColumnName(pos);
						 ht.put(columnName, (rs4.getString(columnName))==null?"":rs4.getString(columnName));
					}
					vt4.add(ht);	
				}
				rs4.close();
				pstmt4.close();
			}


		} catch (SQLException e) {
			System.out.println("[CampaignDatabase:getCampaign_200707(String bs_dt, String be_dt, String cs_dt, String ce_dt, int amt, int bus_up_per, int bus_down_per, int mng_up_per, int mng_down_per)]"+e);
			System.out.println("신입사원 조회 에러");
			e.printStackTrace();
		} 
		
		//달성평균값
		double avg_dalsung2 = this.getAvg_Dalsung_200707(bs_dt, be_dt, bs_dt2, be_dt2, cs_dt, ce_dt, car_amt, bus_up_per, bus_down_per, mng_up_per, mng_down_per, bus_amt_per, mng_amt_per, cnt1, mon, cnt2, cmp_discnt_per, max_dalsung, bus_ga, mng_ga, bus_new_ga, enter_dt, ns_dt1, ns_dt2, ns_dt3, ne_dt1, ne_dt2, ne_dt3, nm_cnt1, nm_cnt2, nm_cnt3, nb_cnt1, nb_cnt2, nb_cnt3);

		query=
"	select"+
"		dept_id, user_id, user_nm, "+
"		rent_cnt, start_cnt, cnt1, r_rent_cnt, r_start_cnt, r_cnt, day,"+
"		trunc(r_cnt2,5) as r_cnt2, trunc(pre_cmp,5) as pre_cmp, trunc(pre_cmp_ga,5) as pre_cmp_ga,"+
"		c_day, to_char(cmp_discnt_per,'90.99') cmp_discnt_per, "+
"		c_rent_cnt, c_start_cnt, cr_rent_cnt, cr_start_cnt, "+
"		sum_cnt1, trunc(avg_cnt1,5) as avg_cnt1, sum_r_cnt, trunc(avg_r_cnt,5) as avg_r_cnt,"+
"		trunc(sum_bus,5) as sum_bus, trunc(avg_bus,5) as avg_bus, trunc(avg_low_bus,5) as avg_low_bus, "+
"		to_char(c_cnt,'990.9') C_CNT, to_char(cr_cnt,'990.99') CR_CNT,"+
"		to_char(dalsung*100,'9990.99') DALSUNG, to_char(ORG_DALSUNG*100,'9990.99') ORG_DALSUNG,"+
"		round("+avg_dalsung2+",4)*100 AVG_DALSUNG, "+
"		round(decode(sign("+avg_dalsung2+" - dalsung), -1, decode(loan_st, '2', amt*"+bus_amt_per+"/100, '3', amt*"+bus_amt_per+"/100, '1',amt*"+mng_amt_per+"/100, 0), 0),-3) AMT, "+
"		round(decode(sign("+avg_dalsung2+" - dalsung), -1, amt, 0),-3) AMT2 "+
"	from "+
"		(select "+
"			u.dept_id, u.user_id, u.user_nm, u.loan_st, rent_cnt, start_cnt, cnt1, r_rent_cnt, r_start_cnt, r_cnt, day, r_cnt2,"+
"			pre_cmp, pre_cmp_ga, c_day, cmp_discnt_per, sum_cnt1, avg_cnt1, sum_r_cnt, avg_r_cnt, sum_bus, avg_bus, avg_low_bus,"+
"			nvl(c_rent_cnt,0) C_RENT_CNT, nvl(c_start_cnt,0) C_START_CNT, nvl(c_cnt,0) C_CNT,"+
"			nvl(cr_rent_cnt,0) CR_RENT_CNT, nvl(cr_start_cnt,0) CR_START_CNT, nvl(cr_cnt,0) CR_CNT,"+
"			nvl(cr_cnt/cmp_discnt_per,0) ORG_DALSUNG,"+
"			nvl(decode(sign("+max_dalsung+"/100-(cr_cnt/cmp_discnt_per)),-1, "+max_dalsung+"/100,(cr_cnt/cmp_discnt_per)),0) DALSUNG, "+
"			cr_cnt*nvl(decode(sign("+max_dalsung+"/100-(cr_cnt/cmp_discnt_per)),-1, "+max_dalsung+"/100, (cr_cnt/cmp_discnt_per)),0)*"+car_amt+" AMT "+
"		from "+
			//v => 캠페인기간 실적조회 : a,b 무시 / c(a확대),d(b확대),e 활용
"			(select u.user_id, u.user_nm, u.loan_st,"+
"				nvl(a.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0) c_rent_cnt,"+
"				nvl(b.cnt,0)-nvl(f.cnt,0) c_start_cnt, "+
"				( nvl(a.cnt,0)+nvl(b.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0)-nvl(f.cnt,0) )/2 c_cnt, "+
"				nvl(c.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0) cr_rent_cnt,"+
"				nvl(d.cnt,0)-nvl(f.cnt,0) cr_start_cnt,"+
"				( nvl(c.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0)+nvl(d.cnt,0)-nvl(f.cnt,0) )/2 cr_cnt "+
"			from "+
"				("+a_cam+") a, "+
"				("+b_cam+") b, "+
"				("+c_cam+") c, "+
"				("+d_cam+") d, "+
"				("+e_cam+") e, "+
"				("+f_cam+") f, "+
"				users u  "+
"		    where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id=c.bus_id(+) and u.user_id=d.bus_id(+) and u.user_id=e.bus_id(+) and u.user_id=f.bus_id(+)"+
"				and u.use_yn='Y' "+
"				and u.loan_st is not null "+
"		 	) v, "+
			//u => 평가기준기간 실적조회 - 영업부 union 관리부 union 신입사원
"			("+
			//영업부 평가기준기간 실적조회
"			select"+
"				dept_id, user_id, user_nm, loan_st,"+
"				rent_cnt, start_cnt, cnt1, r_rent_cnt, r_start_cnt, r_cnt, day, r_cnt2, "+
"				decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+bus_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2)) pre_cmp, "+
"				decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+bus_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+bus_ga+"/100 pre_cmp_ga, "+
"				TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, "+
"				(decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+bus_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+bus_ga+"/100)*(TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1))) cmp_discnt_per, "+
"				sum_cnt1, avg_cnt1, sum_r_cnt, avg_r_cnt, sum_bus, avg_bus, avg_low_bus "+
"		    from "+
				//s => 영업부직원별 평가기준기간 실적조회
"				(select u.dept_id, u.user_id, u.user_nm, u.loan_st,"+
"					nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1,"+
"					nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"		            TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+
"		            (nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2 "+
"		        from "+
"					("+a_bas+") a, "+
"					("+b_bas+") b, "+
"					("+c_bas+") c, "+
"					("+d_bas+") d, "+
"					users u "+
"		        where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"					and sysdate-to_date(u.enter_dt,'YYYYMMDD') >= 365 and u.use_yn='Y'"+
"					and u.loan_st in ('2','3')"+
"				) s, "+
				//t => 영업부직원별 평가기준기간 실적 합계 및 평균 조회
"		        (select "+
"					sum(cnt1) sum_cnt1, avg(cnt1) avg_cnt1, "+
"		            sum(r_cnt) sum_r_cnt, avg(r_cnt) avg_r_cnt, "+
"		            sum(r_cnt2) sum_bus, avg(r_cnt2) avg_bus, "+
"		            avg(r_cnt2)*"+bus_down_per+"/100 avg_low_bus "+
"		        from "+
"					(select u.dept_id, u.user_id, u.user_nm, u.loan_st,"+
"						nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1,"+
"						nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"						TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+
"		            	(nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2 "+
"					from "+
"						("+a_bas+") a, "+
"						("+b_bas+") b, "+
"						("+c_bas+") c, "+
"						("+d_bas+") d, "+
"						users u "+
"					where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"						and sysdate-to_date(u.enter_dt,'YYYYMMDD') >= 365 and u.use_yn='Y'"+
"						and u.loan_st in ('2','3')"+
"					) "+
"		        ) t "+
"			union "+
			//관리부 평가기준기간 실적조회
"			select dept_id, user_id, user_nm,loan_st,"+
"				rent_cnt, start_cnt, cnt1, r_rent_cnt, r_start_cnt, r_cnt, day, r_cnt2, "+
"				decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+mng_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2)) pre_cmp, "+
"				decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+mng_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+mng_ga+"/100 pre_cmp_ga, "+
"				TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, "+
"				(decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+mng_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+mng_ga+"/100)*(TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1))) cmp_discnt_per, "+
"				sum_cnt1, avg_cnt1, sum_r_cnt, avg_r_cnt, sum_bus, avg_bus, avg_low_bus "+
"		    from "+
				//s => 관리부직원별 평가기준기간 실적조회
"				(select u.dept_id, u.user_id, u.user_nm,u.loan_st,"+
"					nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1, "+
"					nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"		            TRUNC(MONTHS_BETWEEN('"+be_dt2+"','"+bs_dt2+"') * 30.5) day, "+
"		           (nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt2+"','"+bs_dt2+"') * 30.5) r_cnt2 "+
"		        from "+
"					("+a_bas2+") a, "+
"					("+b_bas2+") b, "+
"					("+c_bas2+") c, "+
"					("+d_bas2+") d, "+
"					users u "+
"		        where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"		            and sysdate-to_date(u.enter_dt,'YYYYMMDD') >= 365 and u.use_yn='Y' "+
"					and u.loan_st ='1' "+
"		        ) s, "+
				//t => 관리부직원별 평가기준기간 실적 합계 및 평균 조회
"		        (select "+
"					sum(cnt1) sum_cnt1, avg(cnt1) avg_cnt1, "+
"		            sum(r_cnt) sum_r_cnt, avg(r_cnt) avg_r_cnt, "+
"		            sum(r_cnt2) sum_bus, avg(r_cnt2) avg_bus, "+
"		            avg(r_cnt2)*"+mng_down_per+"/100 avg_low_bus "+
"		        from "+
"					(select u.dept_id, u.user_id, u.user_nm, u.loan_st,"+
"						nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1, "+
"						nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"						TRUNC(MONTHS_BETWEEN('"+be_dt2+"','"+bs_dt2+"') * 30.5) day, "+
"		            	(nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt2+"','"+bs_dt2+"') * 30.5) r_cnt2 "+
"					from "+
"						("+a_bas2+") a, "+
"						("+b_bas2+") b, "+
"						("+c_bas2+") c, "+
"						("+d_bas2+") d, "+
"						users u "+
"					where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"						and sysdate-to_date(u.enter_dt,'YYYYMMDD') >= 365 and u.use_yn='Y'"+
"						and u.loan_st ='1' "+
"					) "+
"		        ) t ";


if(vt2.size()>0 && nm_cnt1+nb_cnt1 >0){
	for(int i=0; i<vt2.size(); i++){
		Hashtable ht2 = (Hashtable)vt2.elementAt(i);
		if(String.valueOf(ht2.get("LOAN_ST")).equals("1"))	cnt1 = nm_cnt1;
		else												cnt1 = nb_cnt1;
		query += " union select '"+String.valueOf(ht2.get("DEPT_ID"))+"' dept_id, '"+String.valueOf(ht2.get("USER_ID"))+"' user_id, '"+String.valueOf(ht2.get("USER_NM"))+"' user_nm, '"+String.valueOf(ht2.get("LOAN_ST"))+"' loan_st, "+cnt1+" rent_cnt, "+cnt1+" start_cnt, "+cnt1+" cnt1, "+cnt1+" r_rent_cnt, "+cnt1+" r_start_cnt, "+cnt1+" r_cnt, TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) pre_cmp, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100 pre_cmp_ga, TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, ("+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100)*TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) cmp_discnt_per, 0, 0, 0, 0, 0, 0, 0 from dual ";
	}
}

if(vt3.size()>0 && nm_cnt2+nb_cnt2 >0){
	for(int i=0; i<vt3.size(); i++){
		Hashtable ht3 = (Hashtable)vt3.elementAt(i);
		if(String.valueOf(ht3.get("LOAN_ST")).equals("1"))	cnt1 = nm_cnt2;
		else												cnt1 = nb_cnt2;
		query += " union select '"+String.valueOf(ht3.get("DEPT_ID"))+"' dept_id, '"+String.valueOf(ht3.get("USER_ID"))+"' user_id, '"+String.valueOf(ht3.get("USER_NM"))+"' user_nm, '"+String.valueOf(ht3.get("LOAN_ST"))+"' loan_st, "+cnt1+" rent_cnt, "+cnt1+" start_cnt, "+cnt1+" cnt1, "+cnt1+" r_rent_cnt, "+cnt1+" r_start_cnt, "+cnt1+" r_cnt, TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) pre_cmp, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100 pre_cmp_ga, TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, ("+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100)*TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) cmp_discnt_per, 0, 0, 0, 0, 0, 0, 0 from dual ";
	}
}

if(vt4.size()>0 && nm_cnt3+nb_cnt3 >0){
	for(int i=0; i<vt4.size(); i++){
		Hashtable ht4 = (Hashtable)vt4.elementAt(i);
		if(String.valueOf(ht4.get("LOAN_ST")).equals("1"))	cnt1 = nm_cnt3;
		else												cnt1 = nb_cnt3;
		query += " union select '"+String.valueOf(ht4.get("DEPT_ID"))+"' dept_id, '"+String.valueOf(ht4.get("USER_ID"))+"' user_id, '"+String.valueOf(ht4.get("USER_NM"))+"' user_nm, '"+String.valueOf(ht4.get("LOAN_ST"))+"' loan_st, "+cnt1+" rent_cnt, "+cnt1+" start_cnt, "+cnt1+" cnt1, "+cnt1+" r_rent_cnt, "+cnt1+" r_start_cnt, "+cnt1+" r_cnt, TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) pre_cmp, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100 pre_cmp_ga, TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, ("+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100)*TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) cmp_discnt_per, 0, 0, 0, 0, 0, 0, 0 from dual ";
	}
}

query += "			) u "+
"		where u.user_id = v.user_id "+
"	) "+
"	order by ORG_DALSUNG desc, amt desc, cmp_discnt_per desc ";


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
			System.out.println("[CampaignDatabase:getCampaign_200707(String bs_dt, String be_dt, String cs_dt, String ce_dt, int amt, int bus_up_per, int bus_down_per, int mng_up_per, int mng_down_per)]"+e);
			System.out.println("영업캠페인 조회 에러");
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
                if(rs2 != null )	rs2.close();
                if(pstmt2 != null)	pstmt2.close();
                if(rs3 != null )	rs3.close();
                if(pstmt3 != null)	pstmt3.close();
                if(rs4 != null )	rs4.close();
                if(pstmt4 != null)	pstmt4.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}	

	/**
	 * 결과 평균값 구하기
	*/
	public double getAvg_Dalsung_200707(String bs_dt, String be_dt, String bs_dt2, String be_dt2, String cs_dt, String ce_dt, int car_amt, int bus_up_per, int bus_down_per, int mng_up_per, int mng_down_per, int bus_amt_per, int mng_amt_per, int cnt1, int mon, String cnt2, float cmp_discnt_per, int max_dalsung, int bus_ga, int mng_ga, int bus_new_ga, String enter_dt, String ns_dt1, String ns_dt2, String ns_dt3, String ne_dt1, String ne_dt2, String ne_dt3, int nm_cnt1, int nm_cnt2, int nm_cnt3, int nb_cnt1, int nb_cnt2, int nb_cnt3)
	{
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		PreparedStatement pstmt4 = null;
		ResultSet rs = null;
		ResultSet rs2 = null;
		ResultSet rs3 = null;
		ResultSet rs4= null;
		Vector vt2 = new Vector();
		Vector vt3 = new Vector();
		Vector vt4 = new Vector();

		double avg = 0.0;

		//-------------------------------------------------------------------------------------------
		//cs_dt~ce_dt  : 켐페인기간
		//bs_dt~be_dt  : 영업부 평가기준기간
		//bs_dt2~be_dt : 관리부 평가기준기간

		String a_cam	= getCampaignQuery("rent_dt",  cs_dt, ce_dt);
		String a_bas	= getCampaignQuery("rent_dt", bs_dt,  be_dt);
		String a_bas2	= getCampaignQuery("rent_dt", bs_dt2, be_dt2);

		String b_cam	= getCampaignQuery("rent_start_dt", cs_dt, ce_dt);
		String b_bas	= getCampaignQuery("rent_start_dt", bs_dt,  be_dt);
		String b_bas2	= getCampaignQuery("rent_start_dt", bs_dt2, be_dt2);

		String c_cam	= getCampaignQuery2("rent_dt", cs_dt, ce_dt);
		String c_bas	= getCampaignQuery2("rent_dt", bs_dt,  be_dt);
		String c_bas2	= getCampaignQuery2("rent_dt", bs_dt2, be_dt2);

		String d_cam	= getCampaignQuery2("rent_start_dt", cs_dt, ce_dt);
		String d_bas	= getCampaignQuery2("rent_start_dt", bs_dt,  be_dt);
		String d_bas2	= getCampaignQuery2("rent_start_dt", bs_dt2, be_dt2);

		//출고전해지 감소처리-캠페인기간:해지일기준-켐페인기간3개월전계약
		String e_cam =  "select b.bus_id, count(0) cnt "+
						"from cls_cont a, cont b "+
						"where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd  "+
						"	and cls_st in ('7','10')  "+
						"	and cls_dt between '"+cs_dt+"' and '"+ce_dt+"' "+
						"	and b.rent_dt between to_char(add_months('"+cs_dt+"',-3),'yyyymmdd') and to_char(add_months('"+ce_dt+"',-3),'yyyymmdd') "+
						"group by b.bus_id";

		//6개월전해지 감소처리-캠페인기간:대여개시일기준-6개월이전해지계약
		String f_cam =  "select b.bus_id, count(0) cnt "+
						"from fee a, cont b, (select rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_l_cd) c, cls_cont d "+
						"where "+
						"a.rent_l_cd=b.rent_l_cd "+
						"and a.rent_l_cd=c.rent_l_cd and a.rent_st=c.rent_st "+
						"and a.rent_l_cd=d.rent_l_cd "+
						"and b.car_st<>'2' "+
						"and d.cls_st in ('1','2') "+
						"and b.rent_st not in ('5','7') "+
						"and d.cls_dt between '"+cs_dt+"' and '"+ce_dt+"' "+
						"and to_char(add_months(to_date(a.rent_start_dt,'YYYYMMDD'),6),'YYYYMMDD') > d.cls_dt "+
						"group by b.bus_id";

		//-------------------------------------------------------------------------------------------
		
		String query = "";

		//신입사원리스트
		String query2 = "select * from users where use_yn='Y' and loan_st is not null and sysdate-to_date(enter_dt,'YYYYMMDD') < 365 and enter_dt between '"+ns_dt1+"' and '"+ne_dt1+"'";
		String query3 = "select * from users where use_yn='Y' and loan_st is not null and sysdate-to_date(enter_dt,'YYYYMMDD') < 365 and enter_dt between '"+ns_dt2+"' and '"+ne_dt2+"'";
		String query4 = "select * from users where use_yn='Y' and loan_st is not null and sysdate-to_date(enter_dt,'YYYYMMDD') < 365 and enter_dt between '"+ns_dt3+"' and '"+ne_dt3+"'";

		try {
			if(!ns_dt1.equals("")){
				pstmt2 = conn.prepareStatement(query2);
		    	rs2 = pstmt2.executeQuery();

				ResultSetMetaData rsmd2 = rs2.getMetaData();    	
				while(rs2.next())
				{				
					Hashtable ht = new Hashtable();
					for(int pos =1; pos <= rsmd2.getColumnCount();pos++)
					{
						 String columnName = rsmd2.getColumnName(pos);
						 ht.put(columnName, (rs2.getString(columnName))==null?"":rs2.getString(columnName));
					}
					vt2.add(ht);	
				}
				rs2.close();
				pstmt2.close();
			}

			if(!ns_dt2.equals("")){
				pstmt3 = conn.prepareStatement(query3);
		    	rs3 = pstmt3.executeQuery();

				ResultSetMetaData rsmd3 = rs3.getMetaData();    	
				while(rs3.next())
				{				
					Hashtable ht = new Hashtable();
					for(int pos =1; pos <= rsmd3.getColumnCount();pos++)
					{
						 String columnName = rsmd3.getColumnName(pos);
						 ht.put(columnName, (rs3.getString(columnName))==null?"":rs3.getString(columnName));
					}
					vt3.add(ht);	
				}
				rs3.close();
				pstmt3.close();
			}

			if(!ns_dt3.equals("")){
				pstmt4 = conn.prepareStatement(query4);
		    	rs4 = pstmt4.executeQuery();

				ResultSetMetaData rsmd4 = rs4.getMetaData();    	
				while(rs4.next())
				{				
					Hashtable ht = new Hashtable();
					for(int pos =1; pos <= rsmd4.getColumnCount();pos++)
					{
						 String columnName = rsmd4.getColumnName(pos);
						 ht.put(columnName, (rs4.getString(columnName))==null?"":rs4.getString(columnName));
					}
					vt4.add(ht);	
				}
				rs4.close();
				pstmt4.close();
			}

		} catch (SQLException e) {
			System.out.println("[CampaignDatabase:getAvg_Dalsung_200707(String bs_dt, String be_dt, String cs_dt, String ce_dt, int amt, int bus_up_per, int bus_down_per, int mng_up_per, int mng_down_per)]"+e);
			e.printStackTrace();
		} 

		query=
"	select round(avg(dalsung),4) AVG_DALSUNG "+
"	from "+
"		(select u.dept_id, u.user_id, u.user_nm, "+
"			rent_cnt, start_cnt, cnt1, r_rent_cnt, r_start_cnt, r_cnt, day, r_cnt2, "+
"			pre_cmp, pre_cmp_ga, c_day, cmp_discnt_per, sum_cnt1, avg_cnt1, sum_r_cnt, avg_r_cnt, sum_bus, avg_bus, avg_low_bus,"+
"			nvl(c_rent_cnt,0) C_RENT_CNT, nvl(c_start_cnt,0) C_START_CNT, nvl(c_cnt,0) C_CNT, nvl(cr_rent_cnt,0) CR_RENT_CNT, nvl(cr_start_cnt,0) CR_START_CNT, nvl(cr_cnt,0) CR_CNT,"+
"			nvl(decode(sign("+max_dalsung+"/100-(cr_cnt/cmp_discnt_per)),-1, "+max_dalsung+"/100,(cr_cnt/cmp_discnt_per)),0) DALSUNG, "+
"			cr_cnt*nvl(decode(sign("+max_dalsung+"/100-(cr_cnt/cmp_discnt_per)),-1, "+max_dalsung+"/100, (cr_cnt/cmp_discnt_per)),0)*"+car_amt+" AMT "+
"			from "+
"				(select u.user_id, u.user_nm, "+
"				nvl(a.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0) c_rent_cnt,"+
"				nvl(b.cnt,0)-nvl(f.cnt,0) c_start_cnt, "+
"				( nvl(a.cnt,0)+nvl(b.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0)-nvl(f.cnt,0) )/2 c_cnt, "+
"				nvl(c.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0) cr_rent_cnt,"+
"				nvl(d.cnt,0)-nvl(f.cnt,0) cr_start_cnt,"+
"				( nvl(c.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0)+nvl(d.cnt,0)-nvl(f.cnt,0) )/2 cr_cnt "+
"		         from "+
"					("+a_cam+") a, "+
"					("+b_cam+") b, "+
"					("+c_cam+") c, "+
"					("+d_cam+") d, "+
"					("+e_cam+") e, "+
"					("+f_cam+") f, "+
"					users u  "+
"		    	where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id=c.bus_id(+) and u.user_id=d.bus_id(+) and u.user_id=e.bus_id(+) and u.user_id=f.bus_id(+)"+
"				and u.use_yn='Y' "+
"				and u.loan_st is not null "+
"		 		) v, "+
"				(select dept_id, user_id, user_nm, rent_cnt, start_cnt, cnt1, r_rent_cnt, r_start_cnt, r_cnt, day, r_cnt2, "+
"						decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+bus_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2)) pre_cmp, "+
"						decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+bus_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+bus_ga+"/100 pre_cmp_ga, "+
"						TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, "+
"						(decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+bus_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+bus_ga+"/100)*(TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1))) cmp_discnt_per "+
"						,sum_cnt1, avg_cnt1, sum_r_cnt, avg_r_cnt, sum_bus, avg_bus, avg_low_bus "+
"		        from "+
"		            (select u.dept_id, u.user_id, u.user_nm, nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1, nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"		                   TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+
"		            	   (nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2 "+
"		            from "+
"						("+a_bas+") a, "+
"						("+b_bas+") b, "+
"						("+c_bas+") c, "+
"						("+d_bas+") d, users u "+
"		            where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"		            and sysdate-to_date(u.enter_dt,'YYYYMMDD') >= 365 and u.use_yn='Y'"+
"					and u.loan_st in ('2','3')"+
"		            ) s, "+
"		            (select  sum(cnt1) sum_cnt1, avg(cnt1) avg_cnt1, "+
"		                    sum(r_cnt) sum_r_cnt, avg(r_cnt) avg_r_cnt, "+
"		                    sum(r_cnt2) sum_bus, avg(r_cnt2) avg_bus, "+
"		                    avg(r_cnt2)*"+bus_down_per+"/100 avg_low_bus			 "+
"		            from (select u.dept_id, u.user_id, u.user_nm, nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1, nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"								TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+
"		            			(nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2 "+
"						from "+
"							("+a_bas+") a, "+
"							("+b_bas+") b, "+
"							("+c_bas+") c, "+
"							("+d_bas+") d, users u "+
"						where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"						and sysdate-to_date(u.enter_dt,'YYYYMMDD') >= 365 and u.use_yn='Y'"+
"						and u.loan_st in ('2','3')"+
"						) "+
"		            ) t "+
"				union "+	//여기까지 영업부
"				select dept_id, user_id, user_nm, rent_cnt, start_cnt, cnt1, r_rent_cnt, r_start_cnt, r_cnt, day, r_cnt2, "+
"						decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+mng_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2)) pre_cmp, "+
"						decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+mng_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+mng_ga+"/100 pre_cmp_ga, "+
"						TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, "+
"						(decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+mng_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+mng_ga+"/100)*(TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1))) cmp_discnt_per "+
"						,sum_cnt1, avg_cnt1, sum_r_cnt, avg_r_cnt, sum_bus, avg_bus, avg_low_bus "+
"		        from "+
"		            (select u.dept_id, u.user_id, u.user_nm, nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1, nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"		                   TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+
"		            	   (nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2 "+
"		            from "+
"						("+a_bas2+") a, "+
"						("+b_bas2+") b, "+
"						("+c_bas2+") c, "+
"						("+d_bas2+") d, users u "+
"		            where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"		            and sysdate-to_date(u.enter_dt,'YYYYMMDD') >= 365 and u.use_yn='Y'"+
"					and u.loan_st='1'"+
"		            ) s, "+
"		            (select  sum(cnt1) sum_cnt1, avg(cnt1) avg_cnt1, "+
"		                    sum(r_cnt) sum_r_cnt, avg(r_cnt) avg_r_cnt, "+
"		                    sum(r_cnt2) sum_bus, avg(r_cnt2) avg_bus, "+
"		                    avg(r_cnt2)*"+mng_down_per+"/100 avg_low_bus			 "+
"		            from (select u.dept_id, u.user_id, u.user_nm, nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1, nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"								TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+
"		            			(nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2 "+
"							from "+
"							("+a_bas2+") a, "+
"							("+b_bas2+") b, "+
"							("+c_bas2+") c, "+
"							("+d_bas2+") d, users u "+
"						where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"						and sysdate-to_date(u.enter_dt,'YYYYMMDD') >= 365 and u.use_yn='Y'"+
"						and u.loan_st='1'"+
"						) "+
"		            ) t ";

if(vt2.size()>0 && nm_cnt1+nb_cnt1 >0){
	for(int i=0; i<vt2.size(); i++){
		Hashtable ht2 = (Hashtable)vt2.elementAt(i);
		if(String.valueOf(ht2.get("LOAN_ST")).equals("1"))	cnt1 = nm_cnt1;
		else												cnt1 = nb_cnt1;
		query += " union select '"+String.valueOf(ht2.get("DEPT_ID"))+"' dept_id, '"+String.valueOf(ht2.get("USER_ID"))+"' user_id, '"+String.valueOf(ht2.get("USER_NM"))+"' user_nm, "+cnt1+" rent_cnt, "+cnt1+" start_cnt, "+cnt1+" cnt1, "+cnt1+" r_rent_cnt, "+cnt1+" r_start_cnt, "+cnt1+" r_cnt, TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) pre_cmp, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100 pre_cmp_ga, TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, ("+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100)*TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) cmp_discnt_per, 0, 0, 0, 0, 0, 0, 0 from dual ";
	}
}

if(vt3.size()>0 && nm_cnt2+nb_cnt2 >0){
	for(int i=0; i<vt3.size(); i++){
		Hashtable ht3 = (Hashtable)vt3.elementAt(i);
		if(String.valueOf(ht3.get("LOAN_ST")).equals("1"))	cnt1 = nm_cnt2;
		else												cnt1 = nb_cnt2;
		query += " union select '"+String.valueOf(ht3.get("DEPT_ID"))+"' dept_id, '"+String.valueOf(ht3.get("USER_ID"))+"' user_id, '"+String.valueOf(ht3.get("USER_NM"))+"' user_nm, "+cnt1+" rent_cnt, "+cnt1+" start_cnt, "+cnt1+" cnt1, "+cnt1+" r_rent_cnt, "+cnt1+" r_start_cnt, "+cnt1+" r_cnt, TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) pre_cmp, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100 pre_cmp_ga, TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, ("+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100)*TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) cmp_discnt_per, 0, 0, 0, 0, 0, 0, 0 from dual ";
	}
}

if(vt4.size()>0 && nm_cnt3+nb_cnt3 >0){
	for(int i=0; i<vt4.size(); i++){
		Hashtable ht4 = (Hashtable)vt4.elementAt(i);
		if(String.valueOf(ht4.get("LOAN_ST")).equals("1"))	cnt1 = nm_cnt3;
		else												cnt1 = nb_cnt3;
		query += " union select '"+String.valueOf(ht4.get("DEPT_ID"))+"' dept_id, '"+String.valueOf(ht4.get("USER_ID"))+"' user_id, '"+String.valueOf(ht4.get("USER_NM"))+"' user_nm, "+cnt1+" rent_cnt, "+cnt1+" start_cnt, "+cnt1+" cnt1, "+cnt1+" r_rent_cnt, "+cnt1+" r_start_cnt, "+cnt1+" r_cnt, TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) pre_cmp, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100 pre_cmp_ga, TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, ("+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100)*TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) cmp_discnt_per, 0, 0, 0, 0, 0, 0, 0 from dual ";
	}
}


query += "		) u "+
"		where u.user_id = v.user_id "+
"	)  ";


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			while(rs.next()){
				avg = rs.getDouble(1);
			}	
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CampaignDatabase:getAvg_Dalsung_200707(String bs_dt, String be_dt, String cs_dt, String ce_dt, int amt, int bus_up_per, int bus_down_per, int mng_up_per, int mng_down_per)]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
                if(rs2 != null )	rs2.close();
                if(pstmt2 != null)	pstmt2.close();
                if(rs3 != null )	rs3.close();
                if(pstmt3 != null)	pstmt3.close();
                if(rs4 != null )	rs4.close();
                if(pstmt4 != null)	pstmt4.close();
			}catch(Exception ignore){}
			closeConnection();
			return avg;
		}
	}	

	/**
	 * 결과 : 2007-07 마감테이블 조회
	*/
	public Vector getCampaign_200707(String save_dt, String loan_st, String ns_dt, String ne_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query = " select b.dept_id, b.user_nm, b.user_id, b.loan_st, c.nm_cd, a.* from stat_bus_cmp a, users b, (select * from code where c_st='0002') c where a.bus_id=b.user_id and b.dept_id=c.code and a.save_dt='"+save_dt+"'";

		query += " and a.cnt1>0";

		if(!loan_st.equals("") && ns_dt.equals(""))		query += " and sysdate-to_date(b.enter_dt,'YYYYMMDD') >= 365 and b.loan_st='"+loan_st+"'";

		if(loan_st.equals("") && !ns_dt.equals(""))		query += " and b.enter_dt between '"+ns_dt+"' and '"+ne_dt+"'";


		query += " order by a.seq";

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
			System.out.println("[CampaignDatabase:getCampaign_200707(String save_dt, String loan_st, String s_dt, String e_dt)]"+e);
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
	 * 결과 : 2008-01
	*/
	public Vector getCampaign_200801(String bs_dt, String be_dt, String bs_dt2, String be_dt2, String cs_dt, String ce_dt, int car_amt, int bus_up_per, int bus_down_per, int mng_up_per, int mng_down_per, int bus_amt_per, int mng_amt_per, int cnt1, int mon, String cnt2, float cmp_discnt_per, int max_dalsung, int bus_ga, int mng_ga, int bus_new_ga, String enter_dt, String ns_dt1, String ns_dt2, String ns_dt3, String ns_dt4, String ne_dt1, String ne_dt2, String ne_dt3, String ne_dt4, int nm_cnt1, int nm_cnt2, int nm_cnt3, int nm_cnt4, int nb_cnt1, int nb_cnt2, int nb_cnt3, int nb_cnt4)
	{
		getConnection();

		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		PreparedStatement pstmt4 = null;
		PreparedStatement pstmt5 = null;
		ResultSet rs = null;
		ResultSet rs2 = null;
		ResultSet rs3 = null;
		ResultSet rs4= null;
		ResultSet rs5= null;
		Vector vt = new Vector();
		Vector vt2 = new Vector();
		Vector vt3 = new Vector();
		Vector vt4 = new Vector();
		Vector vt5 = new Vector();

		String client_11 = "";

		//-------------------------------------------------------------------------------------------
		//cs_dt~ce_dt  : 켐페인기간
		//bs_dt~be_dt  : 영업부 평가기준기간
		//bs_dt2~be_dt : 관리부 평가기준기간

		String a_cam	= getCampaignQuery("rent_dt",  cs_dt, ce_dt);
		String a_bas	= getCampaignQuery("rent_dt", bs_dt,  be_dt);
		String a_bas2	= getCampaignQuery("rent_dt", bs_dt2, be_dt2);

		String b_cam	= getCampaignQuery("rent_start_dt", cs_dt, ce_dt);
		String b_bas	= getCampaignQuery("rent_start_dt", bs_dt,  be_dt);
		String b_bas2	= getCampaignQuery("rent_start_dt", bs_dt2, be_dt2);

		String c_cam	= getCampaignQuery2("rent_dt", cs_dt, ce_dt);
		String c_bas	= getCampaignQuery2("rent_dt", bs_dt,  be_dt);
		String c_bas2	= getCampaignQuery2("rent_dt", bs_dt2, be_dt2);

		String d_cam	= getCampaignQuery2("rent_start_dt", cs_dt, ce_dt);
		String d_bas	= getCampaignQuery2("rent_start_dt", bs_dt,  be_dt);
		String d_bas2	= getCampaignQuery2("rent_start_dt", bs_dt2, be_dt2);

		//출고전해지 감소처리-캠페인기간:해지일기준-켐페인기간3개월전계약
		String e_cam =  "select b.bus_id, count(0) cnt "+
						"from cls_cont a, cont b "+
						"where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd  "+
						"	and cls_st in ('7','10')  "+
						"	and cls_dt between '"+cs_dt+"' and '"+ce_dt+"' "+
						"group by b.bus_id";

		//6개월전해지 감소처리-캠페인기간:대여개시일기준-6개월이전해지계약
		String f_cam =  "select nvl(a.ext_agnt,b.bus_id) bus_id, count(0) cnt "+
						"from fee a, cont b, (select rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_l_cd) c, cls_cont d "+
						"where "+
						"a.rent_l_cd=b.rent_l_cd "+
						"and a.rent_l_cd=c.rent_l_cd and a.rent_st=c.rent_st "+
						"and a.rent_l_cd=d.rent_l_cd "+
						"and b.car_st<>'2' "+
						"and d.cls_st in ('1','2') "+
//						"and b.rent_st not in ('5','7') "+
						"and to_number(a.con_mon) >=6 "+
						"and d.cls_dt between '"+cs_dt+"' and '"+ce_dt+"' "+
						"and to_char(add_months(to_date(nvl(a.rent_start_dt,b.rent_dt),'YYYYMMDD')-1,6),'YYYYMMDD') > d.cls_dt "+
						"group by nvl(a.ext_agnt,b.bus_id)";

		//-------------------------------------------------------------------------------------------

		String query = "";

		//신입사원리스트
		String query2 = "select * from users where use_yn='Y' and loan_st is not null and enter_dt between '"+ns_dt1+"' and '"+ne_dt1+"'";//and sysdate-to_date(enter_dt,'YYYYMMDD') < 365 
		String query3 = "select * from users where use_yn='Y' and loan_st is not null and enter_dt between '"+ns_dt2+"' and '"+ne_dt2+"'";//and sysdate-to_date(enter_dt,'YYYYMMDD') < 365 
		String query4 = "select * from users where use_yn='Y' and loan_st is not null and enter_dt between '"+ns_dt3+"' and '"+ne_dt3+"'";//and sysdate-to_date(enter_dt,'YYYYMMDD') < 365 
		String query5 = "select * from users where use_yn='Y' and loan_st is not null and enter_dt between '"+ns_dt4+"' and '"+ne_dt4+"'";//and sysdate-to_date(enter_dt,'YYYYMMDD') < 365 

		try {

			if(!ns_dt1.equals("")){
				pstmt2 = conn.prepareStatement(query2);
		    	rs2 = pstmt2.executeQuery();

				ResultSetMetaData rsmd2 = rs2.getMetaData();    	
				while(rs2.next())
				{				
					Hashtable ht = new Hashtable();
					for(int pos =1; pos <= rsmd2.getColumnCount();pos++)
					{
						 String columnName = rsmd2.getColumnName(pos);
						 ht.put(columnName, (rs2.getString(columnName))==null?"":rs2.getString(columnName));
					}
					vt2.add(ht);	
				}
				rs2.close();
				pstmt2.close();
			}

			if(!ns_dt2.equals("")){
				pstmt3 = conn.prepareStatement(query3);
		    	rs3 = pstmt3.executeQuery();

				ResultSetMetaData rsmd3 = rs3.getMetaData();    	
				while(rs3.next())
				{				
					Hashtable ht = new Hashtable();
					for(int pos =1; pos <= rsmd3.getColumnCount();pos++)
					{
						 String columnName = rsmd3.getColumnName(pos);
						 ht.put(columnName, (rs3.getString(columnName))==null?"":rs3.getString(columnName));
					}
					vt3.add(ht);	
				}
				rs3.close();
				pstmt3.close();
			}

			if(!ns_dt3.equals("")){
				pstmt4 = conn.prepareStatement(query4);
		    	rs4 = pstmt4.executeQuery();

				ResultSetMetaData rsmd4 = rs4.getMetaData();    	
				while(rs4.next())
				{				
					Hashtable ht = new Hashtable();
					for(int pos =1; pos <= rsmd4.getColumnCount();pos++)
					{
						 String columnName = rsmd4.getColumnName(pos);
						 ht.put(columnName, (rs4.getString(columnName))==null?"":rs4.getString(columnName));
					}
					vt4.add(ht);	
				}
				rs4.close();
				pstmt4.close();
			}

			if(!ns_dt4.equals("")){
				pstmt5 = conn.prepareStatement(query5);
		    	rs5 = pstmt5.executeQuery();

				ResultSetMetaData rsmd5 = rs5.getMetaData();    	
				while(rs5.next())
				{				
					Hashtable ht = new Hashtable();
					for(int pos =1; pos <= rsmd5.getColumnCount();pos++)
					{
						 String columnName = rsmd5.getColumnName(pos);
						 ht.put(columnName, (rs5.getString(columnName))==null?"":rs5.getString(columnName));
					}
					vt5.add(ht);	
				}
				rs5.close();
				pstmt5.close();
			}

		} catch (SQLException e) {
			System.out.println("[CampaignDatabase:getCampaign_200801(String bs_dt, String be_dt, String cs_dt, String ce_dt, int amt, int bus_up_per, int bus_down_per, int mng_up_per, int mng_down_per)]"+e);
			System.out.println("신입사원 조회 에러");
			e.printStackTrace();
		} 
		
		//달성평균값
		double avg_dalsung2 = this.getAvg_Dalsung_200801(bs_dt, be_dt, bs_dt2, be_dt2, cs_dt, ce_dt, car_amt, bus_up_per, bus_down_per, mng_up_per, mng_down_per, bus_amt_per, mng_amt_per, cnt1, mon, cnt2, cmp_discnt_per, max_dalsung, bus_ga, mng_ga, bus_new_ga, enter_dt, ns_dt1, ns_dt2, ns_dt3, ns_dt4, ne_dt1, ne_dt2, ne_dt3, ne_dt4, nm_cnt1, nm_cnt2, nm_cnt3, nm_cnt4, nb_cnt1, nb_cnt2, nb_cnt3, nb_cnt4);

		query=
"	select"+
"		dept_id, user_id, user_nm, "+
"		rent_cnt, start_cnt, cnt1, r_rent_cnt, r_start_cnt, r_cnt, day,"+
"		trunc(r_cnt2,5) as r_cnt2, trunc(pre_cmp,5) as pre_cmp, trunc(pre_cmp_ga,5) as pre_cmp_ga,"+
"		c_day, to_char(cmp_discnt_per,'90.99') cmp_discnt_per, "+
"		c_rent_cnt, c_start_cnt, cr_rent_cnt, cr_start_cnt, "+
"		sum_cnt1, trunc(avg_cnt1,5) as avg_cnt1, sum_r_cnt, trunc(avg_r_cnt,5) as avg_r_cnt,"+
"		trunc(sum_bus,5) as sum_bus, trunc(avg_bus,5) as avg_bus, trunc(avg_low_bus,5) as avg_low_bus, "+
"		to_char(c_cnt,'990.9') C_CNT, to_char(cr_cnt,'990.99') CR_CNT,"+
"		to_char(dalsung*100,'9990.99') DALSUNG, to_char(ORG_DALSUNG*100,'9990.99') ORG_DALSUNG,"+
"		round("+avg_dalsung2+",4)*100 AVG_DALSUNG, "+
"		round(decode(sign("+avg_dalsung2+" - dalsung), -1, decode(loan_st, '2', amt*"+bus_amt_per+"/100, '3', amt*"+bus_amt_per+"/100, '1',amt*"+mng_amt_per+"/100, 0), 0),-3) AMT, "+
"		round(decode(sign("+avg_dalsung2+" - dalsung), -1, amt, 0),-3) AMT2 "+
"	from "+
"		(select "+
"			u.dept_id, u.user_id, u.user_nm, u.loan_st, rent_cnt, start_cnt, cnt1, r_rent_cnt, r_start_cnt, r_cnt, day, r_cnt2,"+
"			pre_cmp, pre_cmp_ga, c_day, cmp_discnt_per, sum_cnt1, avg_cnt1, sum_r_cnt, avg_r_cnt, sum_bus, avg_bus, avg_low_bus,"+
"			nvl(c_rent_cnt,0) C_RENT_CNT, nvl(c_start_cnt,0) C_START_CNT, nvl(c_cnt,0) C_CNT,"+
"			nvl(cr_rent_cnt,0) CR_RENT_CNT, nvl(cr_start_cnt,0) CR_START_CNT, nvl(cr_cnt,0) CR_CNT,"+
"			nvl(cr_cnt/cmp_discnt_per,0) ORG_DALSUNG,"+
"			nvl(decode(sign("+max_dalsung+"/100-(cr_cnt/cmp_discnt_per)),-1, "+max_dalsung+"/100,(cr_cnt/cmp_discnt_per)),0) DALSUNG, "+
"			cr_cnt*nvl(decode(sign("+max_dalsung+"/100-(cr_cnt/cmp_discnt_per)),-1, "+max_dalsung+"/100, (cr_cnt/cmp_discnt_per)),0)*"+car_amt+" AMT "+
"		from "+
			//v => 캠페인기간 실적조회 : a,b 무시 / c(a확대),d(b확대),e 활용
"			(select u.user_id, u.user_nm, u.loan_st,"+
"				nvl(a.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0) c_rent_cnt,"+
"				nvl(b.cnt,0)-nvl(f.cnt,0) c_start_cnt, "+
"				( nvl(a.cnt,0)+nvl(b.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0)-nvl(f.cnt,0) )/2 c_cnt, "+
"				nvl(c.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0) cr_rent_cnt,"+
"				nvl(d.cnt,0)-nvl(f.cnt,0) cr_start_cnt,"+
"				( nvl(c.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0)+nvl(d.cnt,0)-nvl(f.cnt,0) )/2 cr_cnt "+
"			from "+
"				("+a_cam+") a, "+
"				("+b_cam+") b, "+
"				("+c_cam+") c, "+
"				("+d_cam+") d, "+
"				("+e_cam+") e, "+
"				("+f_cam+") f, "+
"				users u  "+
"		    where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id=c.bus_id(+) and u.user_id=d.bus_id(+) and u.user_id=e.bus_id(+) and u.user_id=f.bus_id(+)"+
"				and u.use_yn='Y' "+
"				and u.loan_st is not null "+
"		 	) v, "+
			//u => 평가기준기간 실적조회 - 영업부 union 관리부 union 신입사원
"			("+
			//영업부 평가기준기간 실적조회
"			select"+
"				dept_id, user_id, user_nm, loan_st,"+
"				rent_cnt, start_cnt, cnt1, r_rent_cnt, r_start_cnt, r_cnt, day, r_cnt2, "+
"				decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+bus_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2)) pre_cmp, "+
"				decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+bus_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+bus_ga+"/100 pre_cmp_ga, "+
"				TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, "+
"				(decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+bus_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+bus_ga+"/100)*(TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1))) cmp_discnt_per, "+
"				sum_cnt1, avg_cnt1, sum_r_cnt, avg_r_cnt, sum_bus, avg_bus, avg_low_bus "+
"		    from "+
				//s => 영업부직원별 평가기준기간 실적조회
"				(select u.dept_id, u.user_id, u.user_nm, u.loan_st,"+
"					nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1,"+
"					nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"		            TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+
"		            (nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2 "+
"		        from "+
"					("+a_bas+") a, "+
"					("+b_bas+") b, "+
"					("+c_bas+") c, "+
"					("+d_bas+") d, "+
"					users u "+
"		        where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"					and u.enter_dt < '"+ns_dt1+"'"+
"					and u.use_yn='Y'"+
"					and u.loan_st in ('2','3')"+
"				) s, "+
				//t => 영업부직원별 평가기준기간 실적 합계 및 평균 조회
"		        (select "+
"					sum(cnt1) sum_cnt1, avg(cnt1) avg_cnt1, "+
"		            sum(r_cnt) sum_r_cnt, avg(r_cnt) avg_r_cnt, "+
"		            sum(r_cnt2) sum_bus, avg(r_cnt2) avg_bus, "+
"		            avg(r_cnt2)*"+bus_down_per+"/100 avg_low_bus "+
"		        from "+
"					(select u.dept_id, u.user_id, u.user_nm, u.loan_st,"+
"						nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1,"+
"						nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"						TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+
"		            	(nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2 "+
"					from "+
"						("+a_bas+") a, "+
"						("+b_bas+") b, "+
"						("+c_bas+") c, "+
"						("+d_bas+") d, "+
"						users u "+
"					where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"						and u.enter_dt < '"+ns_dt1+"'"+
"						and u.use_yn='Y'"+
"						and u.loan_st in ('2','3')"+
"					) "+
"		        ) t "+
"			union "+
			//관리부 평가기준기간 실적조회
"			select dept_id, user_id, user_nm,loan_st,"+
"				rent_cnt, start_cnt, cnt1, r_rent_cnt, r_start_cnt, r_cnt, day, r_cnt2, "+
"				decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+mng_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2)) pre_cmp, "+
"				decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+mng_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+mng_ga+"/100 pre_cmp_ga, "+
"				TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, "+
"				(decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+mng_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+mng_ga+"/100)*(TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1))) cmp_discnt_per, "+
"				sum_cnt1, avg_cnt1, sum_r_cnt, avg_r_cnt, sum_bus, avg_bus, avg_low_bus "+
"		    from "+
				//s => 관리부직원별 평가기준기간 실적조회
"				(select u.dept_id, u.user_id, u.user_nm,u.loan_st,"+
"					nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1, "+
"					nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"		            TRUNC(MONTHS_BETWEEN('"+be_dt2+"','"+bs_dt2+"') * 30.5) day, "+
"		           (nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt2+"','"+bs_dt2+"') * 30.5) r_cnt2 "+
"		        from "+
"					("+a_bas2+") a, "+
"					("+b_bas2+") b, "+
"					("+c_bas2+") c, "+
"					("+d_bas2+") d, "+
"					users u "+
"		        where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"					and u.enter_dt < '"+ns_dt1+"'"+
"					and u.use_yn='Y' "+
"					and u.loan_st ='1' "+
"		        ) s, "+
				//t => 관리부직원별 평가기준기간 실적 합계 및 평균 조회
"		        (select "+
"					sum(cnt1) sum_cnt1, avg(cnt1) avg_cnt1, "+
"		            sum(r_cnt) sum_r_cnt, avg(r_cnt) avg_r_cnt, "+
"		            sum(r_cnt2) sum_bus, avg(r_cnt2) avg_bus, "+
"		            avg(r_cnt2)*"+mng_down_per+"/100 avg_low_bus "+
"		        from "+
"					(select u.dept_id, u.user_id, u.user_nm, u.loan_st,"+
"						nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1, "+
"						nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"						TRUNC(MONTHS_BETWEEN('"+be_dt2+"','"+bs_dt2+"') * 30.5) day, "+
"		            	(nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt2+"','"+bs_dt2+"') * 30.5) r_cnt2 "+
"					from "+
"						("+a_bas2+") a, "+
"						("+b_bas2+") b, "+
"						("+c_bas2+") c, "+
"						("+d_bas2+") d, "+
"						users u "+
"					where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"						and u.enter_dt < '"+ns_dt1+"'"+
"						and u.use_yn='Y'"+
"						and u.loan_st ='1' "+
"					) "+
"		        ) t ";


if(vt2.size()>0 && nm_cnt1+nb_cnt1 >0){
	for(int i=0; i<vt2.size(); i++){
		Hashtable ht2 = (Hashtable)vt2.elementAt(i);
		if(String.valueOf(ht2.get("LOAN_ST")).equals("1"))	cnt1 = nm_cnt1;
		else												cnt1 = nb_cnt1;
		query += " union select '"+String.valueOf(ht2.get("DEPT_ID"))+"' dept_id, '"+String.valueOf(ht2.get("USER_ID"))+"' user_id, '"+String.valueOf(ht2.get("USER_NM"))+"' user_nm, '"+String.valueOf(ht2.get("LOAN_ST"))+"' loan_st, "+cnt1+" rent_cnt, "+cnt1+" start_cnt, "+cnt1+" cnt1, "+cnt1+" r_rent_cnt, "+cnt1+" r_start_cnt, "+cnt1+" r_cnt, TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) pre_cmp, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100 pre_cmp_ga, TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, ("+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100)*TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) cmp_discnt_per, 0, 0, 0, 0, 0, 0, 0 from dual ";
	}
}

if(vt3.size()>0 && nm_cnt2+nb_cnt2 >0){
	for(int i=0; i<vt3.size(); i++){
		Hashtable ht3 = (Hashtable)vt3.elementAt(i);
		if(String.valueOf(ht3.get("LOAN_ST")).equals("1"))	cnt1 = nm_cnt2;
		else												cnt1 = nb_cnt2;
		query += " union select '"+String.valueOf(ht3.get("DEPT_ID"))+"' dept_id, '"+String.valueOf(ht3.get("USER_ID"))+"' user_id, '"+String.valueOf(ht3.get("USER_NM"))+"' user_nm, '"+String.valueOf(ht3.get("LOAN_ST"))+"' loan_st, "+cnt1+" rent_cnt, "+cnt1+" start_cnt, "+cnt1+" cnt1, "+cnt1+" r_rent_cnt, "+cnt1+" r_start_cnt, "+cnt1+" r_cnt, TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) pre_cmp, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100 pre_cmp_ga, TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, ("+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100)*TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) cmp_discnt_per, 0, 0, 0, 0, 0, 0, 0 from dual ";
	}
}

if(vt4.size()>0 && nm_cnt3+nb_cnt3 >0){
	for(int i=0; i<vt4.size(); i++){
		Hashtable ht4 = (Hashtable)vt4.elementAt(i);
		if(String.valueOf(ht4.get("LOAN_ST")).equals("1"))	cnt1 = nm_cnt3;
		else												cnt1 = nb_cnt3;
		query += " union select '"+String.valueOf(ht4.get("DEPT_ID"))+"' dept_id, '"+String.valueOf(ht4.get("USER_ID"))+"' user_id, '"+String.valueOf(ht4.get("USER_NM"))+"' user_nm, '"+String.valueOf(ht4.get("LOAN_ST"))+"' loan_st, "+cnt1+" rent_cnt, "+cnt1+" start_cnt, "+cnt1+" cnt1, "+cnt1+" r_rent_cnt, "+cnt1+" r_start_cnt, "+cnt1+" r_cnt, TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) pre_cmp, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100 pre_cmp_ga, TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, ("+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100)*TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) cmp_discnt_per, 0, 0, 0, 0, 0, 0, 0 from dual ";
	}
}

if(vt5.size()>0 && nm_cnt4+nb_cnt4 >0){
	for(int i=0; i<vt5.size(); i++){
		Hashtable ht5 = (Hashtable)vt5.elementAt(i);
		if(String.valueOf(ht5.get("LOAN_ST")).equals("1"))	cnt1 = nm_cnt4;
		else												cnt1 = nb_cnt4;
		query += " union select '"+String.valueOf(ht5.get("DEPT_ID"))+"' dept_id, '"+String.valueOf(ht5.get("USER_ID"))+"' user_id, '"+String.valueOf(ht5.get("USER_NM"))+"' user_nm, '"+String.valueOf(ht5.get("LOAN_ST"))+"' loan_st, "+cnt1+" rent_cnt, "+cnt1+" start_cnt, "+cnt1+" cnt1, "+cnt1+" r_rent_cnt, "+cnt1+" r_start_cnt, "+cnt1+" r_cnt, TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) pre_cmp, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100 pre_cmp_ga, TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, ("+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100)*TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) cmp_discnt_per, 0, 0, 0, 0, 0, 0, 0 from dual ";
	}
}

query += "			) u "+
"		where u.user_id = v.user_id "+
"	) "+
"	order by ORG_DALSUNG desc, amt desc, cmp_discnt_per desc ";


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
			System.out.println("[CampaignDatabase:getCampaign_200801(String bs_dt, String be_dt, String cs_dt, String ce_dt, int amt, int bus_up_per, int bus_down_per, int mng_up_per, int mng_down_per)]"+e);
			System.out.println("영업캠페인 조회 에러"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
                if(rs2 != null )	rs2.close();
                if(pstmt2 != null)	pstmt2.close();
                if(rs3 != null )	rs3.close();
                if(pstmt3 != null)	pstmt3.close();
                if(rs4 != null )	rs4.close();
                if(pstmt4 != null)	pstmt4.close();
                if(rs5 != null )	rs5.close();
                if(pstmt5 != null)	pstmt5.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}	

	/**
	 * 결과 평균값 구하기
	*/
	public double getAvg_Dalsung_200801(String bs_dt, String be_dt, String bs_dt2, String be_dt2, String cs_dt, String ce_dt, int car_amt, int bus_up_per, int bus_down_per, int mng_up_per, int mng_down_per, int bus_amt_per, int mng_amt_per, int cnt1, int mon, String cnt2, float cmp_discnt_per, int max_dalsung, int bus_ga, int mng_ga, int bus_new_ga, String enter_dt, String ns_dt1, String ns_dt2, String ns_dt3, String ns_dt4, String ne_dt1, String ne_dt2, String ne_dt3, String ne_dt4, int nm_cnt1, int nm_cnt2, int nm_cnt3, int nm_cnt4, int nb_cnt1, int nb_cnt2, int nb_cnt3, int nb_cnt4)
	{
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		PreparedStatement pstmt4 = null;
		PreparedStatement pstmt5 = null;
		ResultSet rs = null;
		ResultSet rs2 = null;
		ResultSet rs3 = null;
		ResultSet rs4= null;
		ResultSet rs5= null;
		Vector vt2 = new Vector();
		Vector vt3 = new Vector();
		Vector vt4 = new Vector();
		Vector vt5 = new Vector();

		double avg = 0.0;

		//-------------------------------------------------------------------------------------------
		//cs_dt~ce_dt  : 켐페인기간
		//bs_dt~be_dt  : 영업부 평가기준기간
		//bs_dt2~be_dt : 관리부 평가기준기간

		String a_cam	= getCampaignQuery("rent_dt",  cs_dt, ce_dt);
		String a_bas	= getCampaignQuery("rent_dt", bs_dt,  be_dt);
		String a_bas2	= getCampaignQuery("rent_dt", bs_dt2, be_dt2);

		String b_cam	= getCampaignQuery("rent_start_dt", cs_dt, ce_dt);
		String b_bas	= getCampaignQuery("rent_start_dt", bs_dt,  be_dt);
		String b_bas2	= getCampaignQuery("rent_start_dt", bs_dt2, be_dt2);

		String c_cam	= getCampaignQuery2("rent_dt", cs_dt, ce_dt);
		String c_bas	= getCampaignQuery2("rent_dt", bs_dt,  be_dt);
		String c_bas2	= getCampaignQuery2("rent_dt", bs_dt2, be_dt2);

		String d_cam	= getCampaignQuery2("rent_start_dt", cs_dt, ce_dt);
		String d_bas	= getCampaignQuery2("rent_start_dt", bs_dt,  be_dt);
		String d_bas2	= getCampaignQuery2("rent_start_dt", bs_dt2, be_dt2);

		//출고전해지 감소처리-캠페인기간:해지일기준-켐페인기간3개월전계약
		String e_cam =  "select b.bus_id, count(0) cnt "+
						"from cls_cont a, cont b "+
						"where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd  "+
						"	and cls_st in ('7','10')  "+
						"	and cls_dt between '"+cs_dt+"' and '"+ce_dt+"' "+
						"	and b.rent_dt between to_char(add_months('"+cs_dt+"',-3),'yyyymmdd') and to_char(add_months('"+ce_dt+"',-3),'yyyymmdd') "+
						"group by b.bus_id";

		//6개월전해지 감소처리-캠페인기간:대여개시일기준-6개월이전해지계약
		String f_cam =  "select b.bus_id, count(0) cnt "+
						"from fee a, cont b, (select rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_l_cd) c, cls_cont d "+
						"where "+
						"a.rent_l_cd=b.rent_l_cd "+
						"and a.rent_l_cd=c.rent_l_cd and a.rent_st=c.rent_st "+
						"and a.rent_l_cd=d.rent_l_cd "+
						"and b.car_st<>'2' "+
						"and d.cls_st in ('1','2') "+
						"and b.rent_st not in ('5','7') "+
						"and d.cls_dt between '"+cs_dt+"' and '"+ce_dt+"' "+
						"and to_char(add_months(to_date(a.rent_start_dt,'YYYYMMDD'),6),'YYYYMMDD') > d.cls_dt "+
						"group by b.bus_id";

		//-------------------------------------------------------------------------------------------
		
		String query = "";

		//신입사원리스트
		String query2 = "select * from users where use_yn='Y' and loan_st is not null and enter_dt between '"+ns_dt1+"' and '"+ne_dt1+"'";
		String query3 = "select * from users where use_yn='Y' and loan_st is not null and enter_dt between '"+ns_dt2+"' and '"+ne_dt2+"'";
		String query4 = "select * from users where use_yn='Y' and loan_st is not null and enter_dt between '"+ns_dt3+"' and '"+ne_dt3+"'";
		String query5 = "select * from users where use_yn='Y' and loan_st is not null and enter_dt between '"+ns_dt4+"' and '"+ne_dt4+"'";

		try {
			if(!ns_dt1.equals("")){
				pstmt2 = conn.prepareStatement(query2);
		    	rs2 = pstmt2.executeQuery();

				ResultSetMetaData rsmd2 = rs2.getMetaData();    	
				while(rs2.next())
				{				
					Hashtable ht = new Hashtable();
					for(int pos =1; pos <= rsmd2.getColumnCount();pos++)
					{
						 String columnName = rsmd2.getColumnName(pos);
						 ht.put(columnName, (rs2.getString(columnName))==null?"":rs2.getString(columnName));
					}
					vt2.add(ht);	
				}
				rs2.close();
				pstmt2.close();
			}

			if(!ns_dt2.equals("")){
				pstmt3 = conn.prepareStatement(query3);
		    	rs3 = pstmt3.executeQuery();

				ResultSetMetaData rsmd3 = rs3.getMetaData();    	
				while(rs3.next())
				{				
					Hashtable ht = new Hashtable();
					for(int pos =1; pos <= rsmd3.getColumnCount();pos++)
					{
						 String columnName = rsmd3.getColumnName(pos);
						 ht.put(columnName, (rs3.getString(columnName))==null?"":rs3.getString(columnName));
					}
					vt3.add(ht);	
				}
				rs3.close();
				pstmt3.close();
			}

			if(!ns_dt3.equals("")){
				pstmt4 = conn.prepareStatement(query4);
		    	rs4 = pstmt4.executeQuery();

				ResultSetMetaData rsmd4 = rs4.getMetaData();    	
				while(rs4.next())
				{				
					Hashtable ht = new Hashtable();
					for(int pos =1; pos <= rsmd4.getColumnCount();pos++)
					{
						 String columnName = rsmd4.getColumnName(pos);
						 ht.put(columnName, (rs4.getString(columnName))==null?"":rs4.getString(columnName));
					}
					vt4.add(ht);	
				}
				rs4.close();
				pstmt4.close();
			}

			if(!ns_dt4.equals("")){
				pstmt5 = conn.prepareStatement(query5);
		    	rs5 = pstmt5.executeQuery();

				ResultSetMetaData rsmd5 = rs5.getMetaData();    	
				while(rs5.next())
				{				
					Hashtable ht = new Hashtable();
					for(int pos =1; pos <= rsmd5.getColumnCount();pos++)
					{
						 String columnName = rsmd5.getColumnName(pos);
						 ht.put(columnName, (rs5.getString(columnName))==null?"":rs5.getString(columnName));
					}
					vt5.add(ht);	
				}
				rs5.close();
				pstmt5.close();
			}

		} catch (SQLException e) {
			System.out.println("[CampaignDatabase:getAvg_Dalsung_200801(String bs_dt, String be_dt, String cs_dt, String ce_dt, int amt, int bus_up_per, int bus_down_per, int mng_up_per, int mng_down_per)]"+e);
			e.printStackTrace();
		} 

		query=
"	select round(avg(dalsung),4) AVG_DALSUNG "+
"	from "+
"		(select u.dept_id, u.user_id, u.user_nm, "+
"			rent_cnt, start_cnt, cnt1, r_rent_cnt, r_start_cnt, r_cnt, day, r_cnt2, "+
"			pre_cmp, pre_cmp_ga, c_day, cmp_discnt_per, sum_cnt1, avg_cnt1, sum_r_cnt, avg_r_cnt, sum_bus, avg_bus, avg_low_bus,"+
"			nvl(c_rent_cnt,0) C_RENT_CNT, nvl(c_start_cnt,0) C_START_CNT, nvl(c_cnt,0) C_CNT, nvl(cr_rent_cnt,0) CR_RENT_CNT, nvl(cr_start_cnt,0) CR_START_CNT, nvl(cr_cnt,0) CR_CNT,"+
"			nvl(decode(sign("+max_dalsung+"/100-(cr_cnt/cmp_discnt_per)),-1, "+max_dalsung+"/100,(cr_cnt/cmp_discnt_per)),0) DALSUNG, "+
"			cr_cnt*nvl(decode(sign("+max_dalsung+"/100-(cr_cnt/cmp_discnt_per)),-1, "+max_dalsung+"/100, (cr_cnt/cmp_discnt_per)),0)*"+car_amt+" AMT "+
"			from "+
"				(select u.user_id, u.user_nm, "+
"				nvl(a.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0) c_rent_cnt,"+
"				nvl(b.cnt,0)-nvl(f.cnt,0) c_start_cnt, "+
"				( nvl(a.cnt,0)+nvl(b.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0)-nvl(f.cnt,0) )/2 c_cnt, "+
"				nvl(c.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0) cr_rent_cnt,"+
"				nvl(d.cnt,0)-nvl(f.cnt,0) cr_start_cnt,"+
"				( nvl(c.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0)+nvl(d.cnt,0)-nvl(f.cnt,0) )/2 cr_cnt "+
"		         from "+
"					("+a_cam+") a, "+
"					("+b_cam+") b, "+
"					("+c_cam+") c, "+
"					("+d_cam+") d, "+
"					("+e_cam+") e, "+
"					("+f_cam+") f, "+
"					users u  "+
"		    	where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id=c.bus_id(+) and u.user_id=d.bus_id(+) and u.user_id=e.bus_id(+) and u.user_id=f.bus_id(+)"+
"				and u.use_yn='Y' "+
"				and u.loan_st is not null "+
"		 		) v, "+
"				(select dept_id, user_id, user_nm, rent_cnt, start_cnt, cnt1, r_rent_cnt, r_start_cnt, r_cnt, day, r_cnt2, "+
"						decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+bus_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2)) pre_cmp, "+
"						decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+bus_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+bus_ga+"/100 pre_cmp_ga, "+
"						TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, "+
"						(decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+bus_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+bus_ga+"/100)*(TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1))) cmp_discnt_per "+
"						,sum_cnt1, avg_cnt1, sum_r_cnt, avg_r_cnt, sum_bus, avg_bus, avg_low_bus "+
"		        from "+
"		            (select u.dept_id, u.user_id, u.user_nm, nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1, nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"		                   TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+
"		            	   (nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2 "+
"		            from "+
"						("+a_bas+") a, "+
"						("+b_bas+") b, "+
"						("+c_bas+") c, "+
"						("+d_bas+") d, users u "+
"		            where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"		            and u.enter_dt<'"+ns_dt1+"'"+
"					and u.use_yn='Y'"+
"					and u.loan_st in ('2','3')"+
"		            ) s, "+
"		            (select  sum(cnt1) sum_cnt1, avg(cnt1) avg_cnt1, "+
"		                    sum(r_cnt) sum_r_cnt, avg(r_cnt) avg_r_cnt, "+
"		                    sum(r_cnt2) sum_bus, avg(r_cnt2) avg_bus, "+
"		                    avg(r_cnt2)*"+bus_down_per+"/100 avg_low_bus			 "+
"		            from (select u.dept_id, u.user_id, u.user_nm, nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1, nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"								TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+
"		            			(nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2 "+
"						from "+
"							("+a_bas+") a, "+
"							("+b_bas+") b, "+
"							("+c_bas+") c, "+
"							("+d_bas+") d, users u "+
"						where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"					    and u.enter_dt<'"+ns_dt1+"'"+
"						and u.use_yn='Y'"+
"						and u.loan_st in ('2','3')"+
"						) "+
"		            ) t "+
"				union "+	//여기까지 영업부
"				select dept_id, user_id, user_nm, rent_cnt, start_cnt, cnt1, r_rent_cnt, r_start_cnt, r_cnt, day, r_cnt2, "+
"						decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+mng_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2)) pre_cmp, "+
"						decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+mng_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+mng_ga+"/100 pre_cmp_ga, "+
"						TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, "+
"						(decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+mng_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+mng_ga+"/100)*(TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1))) cmp_discnt_per "+
"						,sum_cnt1, avg_cnt1, sum_r_cnt, avg_r_cnt, sum_bus, avg_bus, avg_low_bus "+
"		        from "+
"		            (select u.dept_id, u.user_id, u.user_nm, nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1, nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"		                   TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+
"		            	   (nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2 "+
"		            from "+
"						("+a_bas2+") a, "+
"						("+b_bas2+") b, "+
"						("+c_bas2+") c, "+
"						("+d_bas2+") d, users u "+
"		            where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"				    and u.enter_dt<'"+ns_dt1+"'"+
"					and u.use_yn='Y'"+
"					and u.loan_st='1'"+
"		            ) s, "+
"		            (select  sum(cnt1) sum_cnt1, avg(cnt1) avg_cnt1, "+
"		                    sum(r_cnt) sum_r_cnt, avg(r_cnt) avg_r_cnt, "+
"		                    sum(r_cnt2) sum_bus, avg(r_cnt2) avg_bus, "+
"		                    avg(r_cnt2)*"+mng_down_per+"/100 avg_low_bus			 "+
"		            from (select u.dept_id, u.user_id, u.user_nm, nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1, nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"								TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+
"		            			(nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2 "+
"							from "+
"							("+a_bas2+") a, "+
"							("+b_bas2+") b, "+
"							("+c_bas2+") c, "+
"							("+d_bas2+") d, users u "+
"						where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"					    and u.enter_dt<'"+ns_dt1+"'"+
"						and u.use_yn='Y'"+
"						and u.loan_st='1'"+
"						) "+
"		            ) t ";

if(vt2.size()>0 && nm_cnt1+nb_cnt1 >0){
	for(int i=0; i<vt2.size(); i++){
		Hashtable ht2 = (Hashtable)vt2.elementAt(i);
		if(String.valueOf(ht2.get("LOAN_ST")).equals("1"))	cnt1 = nm_cnt1;
		else												cnt1 = nb_cnt1;
		query += " union select '"+String.valueOf(ht2.get("DEPT_ID"))+"' dept_id, '"+String.valueOf(ht2.get("USER_ID"))+"' user_id, '"+String.valueOf(ht2.get("USER_NM"))+"' user_nm, "+cnt1+" rent_cnt, "+cnt1+" start_cnt, "+cnt1+" cnt1, "+cnt1+" r_rent_cnt, "+cnt1+" r_start_cnt, "+cnt1+" r_cnt, TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) pre_cmp, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100 pre_cmp_ga, TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, ("+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100)*TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) cmp_discnt_per, 0, 0, 0, 0, 0, 0, 0 from dual ";
	}
}

if(vt3.size()>0 && nm_cnt2+nb_cnt2 >0){
	for(int i=0; i<vt3.size(); i++){
		Hashtable ht3 = (Hashtable)vt3.elementAt(i);
		if(String.valueOf(ht3.get("LOAN_ST")).equals("1"))	cnt1 = nm_cnt2;
		else												cnt1 = nb_cnt2;
		query += " union select '"+String.valueOf(ht3.get("DEPT_ID"))+"' dept_id, '"+String.valueOf(ht3.get("USER_ID"))+"' user_id, '"+String.valueOf(ht3.get("USER_NM"))+"' user_nm, "+cnt1+" rent_cnt, "+cnt1+" start_cnt, "+cnt1+" cnt1, "+cnt1+" r_rent_cnt, "+cnt1+" r_start_cnt, "+cnt1+" r_cnt, TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) pre_cmp, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100 pre_cmp_ga, TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, ("+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100)*TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) cmp_discnt_per, 0, 0, 0, 0, 0, 0, 0 from dual ";
	}
}

if(vt4.size()>0 && nm_cnt3+nb_cnt3 >0){
	for(int i=0; i<vt4.size(); i++){
		Hashtable ht4 = (Hashtable)vt4.elementAt(i);
		if(String.valueOf(ht4.get("LOAN_ST")).equals("1"))	cnt1 = nm_cnt3;
		else												cnt1 = nb_cnt3;
		query += " union select '"+String.valueOf(ht4.get("DEPT_ID"))+"' dept_id, '"+String.valueOf(ht4.get("USER_ID"))+"' user_id, '"+String.valueOf(ht4.get("USER_NM"))+"' user_nm, "+cnt1+" rent_cnt, "+cnt1+" start_cnt, "+cnt1+" cnt1, "+cnt1+" r_rent_cnt, "+cnt1+" r_start_cnt, "+cnt1+" r_cnt, TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) pre_cmp, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100 pre_cmp_ga, TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, ("+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100)*TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) cmp_discnt_per, 0, 0, 0, 0, 0, 0, 0 from dual ";
	}
}

if(vt5.size()>0 && nm_cnt4+nb_cnt4 >0){
	for(int i=0; i<vt5.size(); i++){
		Hashtable ht5 = (Hashtable)vt5.elementAt(i);
		if(String.valueOf(ht5.get("LOAN_ST")).equals("1"))	cnt1 = nm_cnt4;
		else												cnt1 = nb_cnt4;
		query += " union select '"+String.valueOf(ht5.get("DEPT_ID"))+"' dept_id, '"+String.valueOf(ht5.get("USER_ID"))+"' user_id, '"+String.valueOf(ht5.get("USER_NM"))+"' user_nm, "+cnt1+" rent_cnt, "+cnt1+" start_cnt, "+cnt1+" cnt1, "+cnt1+" r_rent_cnt, "+cnt1+" r_start_cnt, "+cnt1+" r_cnt, TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) pre_cmp, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100 pre_cmp_ga, TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, ("+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100)*TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) cmp_discnt_per, 0, 0, 0, 0, 0, 0, 0 from dual ";
	}
}


query += "		) u "+
"		where u.user_id = v.user_id "+
"	)  ";


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			while(rs.next()){
				avg = rs.getDouble(1);
			}

	
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CampaignDatabase:getAvg_Dalsung_200801(String bs_dt, String be_dt, String cs_dt, String ce_dt, int amt, int bus_up_per, int bus_down_per, int mng_up_per, int mng_down_per)]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
                if(rs2 != null )	rs2.close();
                if(pstmt2 != null)	pstmt2.close();
                if(rs3 != null )	rs3.close();
                if(pstmt3 != null)	pstmt3.close();
                if(rs4 != null )	rs4.close();
                if(pstmt4 != null)	pstmt4.close();
                if(rs5 != null )	rs5.close();
                if(pstmt5 != null)	pstmt5.close();
			}catch(Exception ignore){}
			closeConnection();
			return avg;
		}
	}	

	/**
	 * 결과 :마감테이블 조회
	*/
	public Vector getCampaign(String save_dt, String loan_st, String ns_dt, String ne_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query = " select b.dept_id, b.user_nm, b.user_id, b.loan_st, c.nm_cd, "+
						" a.SAVE_DT, a.SEQ, a.BUS_ID, a.RENT_CNT, a.START_CNT, a.CNT1, a.R_RENT_CNT, a.R_START_CNT, a.R_CNT, a.DAY, a.R_CNT2, a.PRE_CMP, a.PRE_CMP_GA,  "+
						" a.C_DAY, a.CMP_DISCNT_PER, a.C_RENT_CNT, a.C_START_CNT, a.C_CNT, a.CR_RENT_CNT, a.CR_START_CNT, a.CR_CNT, a.DALSUNG, to_char(to_number(a.AMT)) amt, a.AVG_DALSUNG, to_char(to_number(a.AMT2)) amt2,  "+
						" a.SUM_CNT1, a.SUM_R_CNT, a.SUM_BUS, a.AVG_CNT1, a.AVG_R_CNT, a.AVG_BUS, a.AVG_LOW_BUS,  "+
						" a.V_BS_DT, a.V_BE_DT, a.V_BS_DT2, a.V_BE_DT2, a.V_CS_DT, a.V_CE_DT, a.V_CAR_AMT,  "+
						" a.V_BUS_UP_PER, a.V_BUS_DOWN_PER, a.V_MNG_UP_PER, a.V_MNG_DOWN_PER, a.V_BUS_AMT_PER, a.V_MNG_AMT_PER, a.V_CNT1, a.V_MON, a.V_CNT2,  "+
						" a.V_CMP_DISCNT_PER, a.V_MAX_DALSUNG, a.V_BUS_GA, a.V_MNG_GA, a.V_BUS_NEW_GA, a.REG_DT, a.V_ENTER_DT, a.ORG_DALSUNG,  "+
						" a.V_NM_CNT3, a.V_NE_DT3, a.V_NS_DT3, a.V_NB_CNT2, a.V_NM_CNT2, a.V_NE_DT2, a.V_NS_DT2, a.V_NB_CNT1, a.V_NM_CNT1, a.V_NE_DT1, a.V_NS_DT1, a.V_NB_CNT3, a.BUS_ST "+
			           " from stat_bus_cmp a, users b, (select * from code where c_st='0002') c where a.bus_id=b.user_id and b.dept_id=c.code and a.save_dt='"+save_dt+"'";

		query += " and a.cnt1>0";

		if(!loan_st.equals("") && ns_dt.equals(""))		query += " and sysdate-to_date(b.enter_dt,'YYYYMMDD') >= 365 and b.loan_st='"+loan_st+"'";

		if(loan_st.equals("") && !ns_dt.equals(""))		query += " and b.enter_dt between '"+ns_dt+"' and '"+ne_dt+"'";


		query += " order by to_number(a.org_dalsung) desc, a.seq";

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
			System.out.println("[CampaignDatabase:getCampaign(String save_dt, String loan_st, String s_dt, String e_dt)]"+e);
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
	 * 결과 :마감테이블 조회
	*/
	public Vector getCampaign(String save_dt, String loan_st, String ns_dt, String ne_dt, String enter_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query = " select b.dept_id, b.user_nm, b.user_id, b.loan_st, c.nm_cd, a.* from stat_bus_cmp a, users b, (select * from code where c_st='0002') c where a.bus_id=b.user_id and b.dept_id=c.code and a.save_dt='"+save_dt+"'";

		query += " and a.cnt1>0";

		if(!loan_st.equals("") && ns_dt.equals(""))		query += " and b.enter_dt<'"+enter_dt+"' and b.loan_st='"+loan_st+"'";

		if(loan_st.equals("") && !ns_dt.equals(""))		query += " and b.enter_dt between '"+ns_dt+"' and '"+ne_dt+"'";


		query += " order by a.seq";

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
			System.out.println("[CampaignDatabase:getCampaign(String save_dt, String loan_st, String s_dt, String e_dt)]"+e);
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
	 * 결과 :마감테이블 조회
	*/
	public Vector getCampaignList_2008_09(String save_dt, String loan_st, String ns_dt, String ne_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query =  " select b.dept_id, b.user_nm, b.user_id, b.loan_st, decode(b.loan_st,'1','1군','2','2군') loan_st_nm, b.enter_dt, c.nm_cd, "+
						" a.SAVE_DT, a.SEQ, a.BUS_ID, a.RENT_CNT, a.START_CNT, a.CNT1, a.R_RENT_CNT, a.R_START_CNT, a.R_CNT, a.DAY, a.R_CNT2, a.PRE_CMP, a.PRE_CMP_GA,  "+
						" a.C_DAY, to_char(to_number(a.CMP_DISCNT_PER),decode(sign(1-to_number(a.CMP_DISCNT_PER)),-1,'99.999','0.999')) CMP_DISCNT_PER, a.C_RENT_CNT, a.C_START_CNT, "+
						" to_char(to_number(a.C_CNT),decode(sign(1-to_number(a.C_CNT)),-1,'99.999','0.999')) C_CNT, a.CR_RENT_CNT, a.CR_START_CNT, "+
						" to_char(to_number(a.CR_CNT),decode(sign(1-to_number(a.CR_CNT)),-1,'99.999','0.999')) CR_CNT, to_char(to_number(a.DALSUNG),decode(sign(1-to_number(a.DALSUNG)),-1,'999.99','0.99')) DALSUNG, to_char(to_number(a.AMT)) amt, a.AVG_DALSUNG, to_char(to_number(a.AMT2)) amt2,  "+
						" a.SUM_CNT1, a.SUM_R_CNT, a.SUM_BUS, a.AVG_CNT1, a.AVG_R_CNT, a.AVG_BUS, a.AVG_LOW_BUS,  "+
						" a.V_BS_DT, a.V_BE_DT, a.V_BS_DT2, a.V_BE_DT2, a.V_CS_DT, a.V_CE_DT, a.V_CAR_AMT,  "+
						" a.V_BUS_UP_PER, a.V_BUS_DOWN_PER, a.V_MNG_UP_PER, a.V_MNG_DOWN_PER, a.V_BUS_AMT_PER, a.V_MNG_AMT_PER, a.V_CNT1, a.V_MON, a.V_CNT2,  "+
						" a.V_CMP_DISCNT_PER, a.V_MAX_DALSUNG, a.V_BUS_GA, a.V_MNG_GA, a.V_BUS_NEW_GA, a.REG_DT, a.V_ENTER_DT, to_char(to_number(a.ORG_DALSUNG),'999.99') ORG_DALSUNG,  "+
						" a.V_NM_CNT3, a.V_NE_DT3, a.V_NS_DT3, a.V_NB_CNT2, a.V_NM_CNT2, a.V_NE_DT2, a.V_NS_DT2, a.V_NB_CNT1, a.V_NM_CNT1, a.V_NE_DT1, a.V_NS_DT1, a.V_NB_CNT3, a.BUS_ST "+
						" from "+
						" ("+
						"		select * from stat_bus_cmp where save_dt='"+save_dt+"'"+
						" ) a, "+
						" users b, (select * from code where c_st='0002') c "+
						" where a.bus_id=b.user_id and b.dept_id=c.code";

		query += " and a.cnt1>0";

		if(!loan_st.equals("") && ns_dt.equals(""))		query += " and sysdate-to_date(b.enter_dt,'YYYYMMDD') >= 365 and b.loan_st='"+loan_st+"'";

		if(loan_st.equals("") && !ns_dt.equals(""))		query += " and b.enter_dt between '"+ns_dt+"' and '"+ne_dt+"'";


		query += " order by to_number(a.org_dalsung) desc, a.seq";

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
			System.out.println("[CampaignDatabase:getCampaign(String save_dt, String loan_st, String s_dt, String e_dt)]"+e);
			System.out.println("[CampaignDatabase:getCampaign(String save_dt, String loan_st, String s_dt, String e_dt)]"+query);
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
	 * 결과 : 2008-01
	*/
	public Vector getCampaign_200809(String bs_dt, String be_dt, String bs_dt2, String be_dt2, String cs_dt, String ce_dt, int car_amt, int bus_up_per, int bus_down_per, int mng_up_per, int mng_down_per, int bus_amt_per, int mng_amt_per, int cnt1, int mon, String cnt2, float cmp_discnt_per, int max_dalsung, int bus_ga, int mng_ga, int bus_new_ga, String enter_dt, String ns_dt1, String ns_dt2, String ns_dt3, String ns_dt4, String ne_dt1, String ne_dt2, String ne_dt3, String ne_dt4, int nm_cnt1, int nm_cnt2, int nm_cnt3, int nm_cnt4, int nb_cnt1, int nb_cnt2, int nb_cnt3, int nb_cnt4)
	{
		getConnection();

		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		PreparedStatement pstmt4 = null;
		PreparedStatement pstmt5 = null;
		ResultSet rs = null;
		ResultSet rs2 = null;
		ResultSet rs3 = null;
		ResultSet rs4= null;
		ResultSet rs5= null;
		Vector vt = new Vector();
		Vector vt2 = new Vector();
		Vector vt3 = new Vector();
		Vector vt4 = new Vector();
		Vector vt5 = new Vector();

		String client_11 = "";

		//-------------------------------------------------------------------------------------------
		//cs_dt~ce_dt  : 켐페인기간
		//bs_dt~be_dt  : 영업부 평가기준기간
		//bs_dt2~be_dt : 관리부 평가기준기간

		String a_cam	= getCampaignQuery("rent_dt",  cs_dt, ce_dt);
		String a_bas	= getCampaignQuery("rent_dt", bs_dt,  be_dt);
		String a_bas2	= getCampaignQuery("rent_dt", bs_dt2, be_dt2);

		String b_cam	= getCampaignQuery("rent_start_dt", cs_dt, ce_dt);
		String b_bas	= getCampaignQuery("rent_start_dt", bs_dt,  be_dt);
		String b_bas2	= getCampaignQuery("rent_start_dt", bs_dt2, be_dt2);

		String c_cam	= getCampaignQuery2("rent_dt", cs_dt, ce_dt);
		String c_bas	= getCampaignQuery2("rent_dt", bs_dt,  be_dt);
		String c_bas2	= getCampaignQuery2("rent_dt", bs_dt2, be_dt2);

		String d_cam	= getCampaignQuery2("rent_start_dt", cs_dt, ce_dt);
		String d_bas	= getCampaignQuery2("rent_start_dt", bs_dt,  be_dt);
		String d_bas2	= getCampaignQuery2("rent_start_dt", bs_dt2, be_dt2);

		//출고전해지 감소처리-캠페인기간:해지일기준-켐페인기간3개월전계약
		String e_cam =  "select b.bus_id, count(0) cnt "+
						"from cls_cont a, cont b "+
						"where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd  "+
						"	and cls_st in ('7','10')  "+
						"	and cls_dt between '"+cs_dt+"' and '"+ce_dt+"' "+
						"group by b.bus_id";

		//6개월전해지 감소처리-캠페인기간:대여개시일기준-6개월이전해지계약
		String f_cam =  "select nvl(a.ext_agnt,b.bus_id) bus_id, count(0) cnt "+
						"from fee a, cont b, (select rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_l_cd) c, cls_cont d "+
						"where "+
						"a.rent_l_cd=b.rent_l_cd "+
						"and a.rent_l_cd=c.rent_l_cd and a.rent_st=c.rent_st "+
						"and a.rent_l_cd=d.rent_l_cd "+
						"and b.car_st<>'2' "+
						"and d.cls_st in ('1','2') "+
//						"and b.rent_st not in ('5','7') "+
						"and to_number(a.con_mon) >=6 "+
						"and d.cls_dt between '"+cs_dt+"' and '"+ce_dt+"' "+
						"and to_char(add_months(to_date(nvl(a.rent_start_dt,b.rent_dt),'YYYYMMDD')-1,6),'YYYYMMDD') > d.cls_dt "+
						"group by nvl(a.ext_agnt,b.bus_id)";

		//-------------------------------------------------------------------------------------------

		String query = "";

		//신입사원리스트
		String query2 = "select * from users where use_yn='Y' and loan_st is not null and enter_dt between '"+ns_dt1+"' and '"+ne_dt1+"'";
		String query3 = "select * from users where use_yn='Y' and loan_st is not null and enter_dt between '"+ns_dt2+"' and '"+ne_dt2+"'";
		String query4 = "select * from users where use_yn='Y' and loan_st is not null and enter_dt between '"+ns_dt3+"' and '"+ne_dt3+"'";
		String query5 = "select * from users where use_yn='Y' and loan_st is not null and enter_dt between '"+ns_dt4+"' and '"+ne_dt4+"'";

		try {

			if(!ns_dt1.equals("")){
				pstmt2 = conn.prepareStatement(query2);
		    	rs2 = pstmt2.executeQuery();

				ResultSetMetaData rsmd2 = rs2.getMetaData();    	
				while(rs2.next())
				{				
					Hashtable ht = new Hashtable();
					for(int pos =1; pos <= rsmd2.getColumnCount();pos++)
					{
						 String columnName = rsmd2.getColumnName(pos);
						 ht.put(columnName, (rs2.getString(columnName))==null?"":rs2.getString(columnName));
					}
					vt2.add(ht);	
				}
				rs2.close();
				pstmt2.close();
			}

			if(!ns_dt2.equals("")){
				pstmt3 = conn.prepareStatement(query3);
		    	rs3 = pstmt3.executeQuery();

				ResultSetMetaData rsmd3 = rs3.getMetaData();    	
				while(rs3.next())
				{				
					Hashtable ht = new Hashtable();
					for(int pos =1; pos <= rsmd3.getColumnCount();pos++)
					{
						 String columnName = rsmd3.getColumnName(pos);
						 ht.put(columnName, (rs3.getString(columnName))==null?"":rs3.getString(columnName));
					}
					vt3.add(ht);	
				}
				rs3.close();
				pstmt3.close();
			}

			if(!ns_dt3.equals("")){
				pstmt4 = conn.prepareStatement(query4);
		    	rs4 = pstmt4.executeQuery();

				ResultSetMetaData rsmd4 = rs4.getMetaData();    	
				while(rs4.next())
				{				
					Hashtable ht = new Hashtable();
					for(int pos =1; pos <= rsmd4.getColumnCount();pos++)
					{
						 String columnName = rsmd4.getColumnName(pos);
						 ht.put(columnName, (rs4.getString(columnName))==null?"":rs4.getString(columnName));
					}
					vt4.add(ht);	
				}
				rs4.close();
				pstmt4.close();
			}

			if(!ns_dt4.equals("")){
				pstmt5 = conn.prepareStatement(query5);
		    	rs5 = pstmt5.executeQuery();

				ResultSetMetaData rsmd5 = rs5.getMetaData();    	
				while(rs5.next())
				{				
					Hashtable ht = new Hashtable();
					for(int pos =1; pos <= rsmd5.getColumnCount();pos++)
					{
						 String columnName = rsmd5.getColumnName(pos);
						 ht.put(columnName, (rs5.getString(columnName))==null?"":rs5.getString(columnName));
					}
					vt5.add(ht);	
				}
				rs5.close();
				pstmt5.close();
			}

		} catch (SQLException e) {
			System.out.println("[CampaignDatabase:getCampaign_200809(String bs_dt, String be_dt, String cs_dt, String ce_dt, int amt, int bus_up_per, int bus_down_per, int mng_up_per, int mng_down_per)]"+e);
			System.out.println("신입사원 조회 에러");
			e.printStackTrace();
		} 
		
		//달성평균값
		double avg_dalsung2 = this.getAvg_Dalsung_200809(bs_dt, be_dt, bs_dt2, be_dt2, cs_dt, ce_dt, car_amt, bus_up_per, bus_down_per, mng_up_per, mng_down_per, bus_amt_per, mng_amt_per, cnt1, mon, cnt2, cmp_discnt_per, max_dalsung, bus_ga, mng_ga, bus_new_ga, enter_dt, ns_dt1, ns_dt2, ns_dt3, ns_dt4, ne_dt1, ne_dt2, ne_dt3, ne_dt4, nm_cnt1, nm_cnt2, nm_cnt3, nm_cnt4, nb_cnt1, nb_cnt2, nb_cnt3, nb_cnt4);

		query=
"	select"+
"		dept_id, user_id, user_nm, "+
"		rent_cnt, start_cnt, cnt1, r_rent_cnt, r_start_cnt, r_cnt, day,"+
"		trunc(r_cnt2,5) as r_cnt2, trunc(pre_cmp,5) as pre_cmp, trunc(pre_cmp_ga,5) as pre_cmp_ga,"+
"		c_day, to_char(cmp_discnt_per,'90.99') cmp_discnt_per, "+
"		c_rent_cnt, c_start_cnt, cr_rent_cnt, cr_start_cnt, "+
"		sum_cnt1, trunc(avg_cnt1,5) as avg_cnt1, sum_r_cnt, trunc(avg_r_cnt,5) as avg_r_cnt,"+
"		trunc(sum_bus,5) as sum_bus, trunc(avg_bus,5) as avg_bus, trunc(avg_low_bus,5) as avg_low_bus, "+
"		to_char(c_cnt,'990.9') C_CNT, to_char(cr_cnt,'990.99') CR_CNT,"+
"		to_char(dalsung*100,'9990.99') DALSUNG, to_char(ORG_DALSUNG*100,'9990.99') ORG_DALSUNG,"+
"		round("+avg_dalsung2+",4)*100 AVG_DALSUNG, "+
"		round(decode(sign("+avg_dalsung2+" - dalsung), -1, decode(loan_st, '2', amt*"+bus_amt_per+"/100, '3', amt*"+bus_amt_per+"/100, '1',amt*"+mng_amt_per+"/100, 0), 0),-3) AMT, "+
"		round(decode(sign("+avg_dalsung2+" - dalsung), -1, amt, 0),-3) AMT2 "+
"	from "+
"		(select "+
"			u.dept_id, u.user_id, u.user_nm, u.loan_st, rent_cnt, start_cnt, cnt1, r_rent_cnt, r_start_cnt, r_cnt, day, r_cnt2,"+
"			pre_cmp, pre_cmp_ga, c_day, cmp_discnt_per, sum_cnt1, avg_cnt1, sum_r_cnt, avg_r_cnt, sum_bus, avg_bus, avg_low_bus,"+
"			nvl(c_rent_cnt,0) C_RENT_CNT, nvl(c_start_cnt,0) C_START_CNT, nvl(c_cnt,0) C_CNT,"+
"			nvl(cr_rent_cnt,0) CR_RENT_CNT, nvl(cr_start_cnt,0) CR_START_CNT, nvl(cr_cnt,0) CR_CNT,"+
"			nvl(cr_cnt/cmp_discnt_per,0) ORG_DALSUNG,"+
"			nvl(decode(sign("+max_dalsung+"/100-(cr_cnt/cmp_discnt_per)),-1, "+max_dalsung+"/100,(cr_cnt/cmp_discnt_per)),0) DALSUNG, "+
"			cr_cnt*nvl(decode(sign("+max_dalsung+"/100-(cr_cnt/cmp_discnt_per)),-1, "+max_dalsung+"/100, (cr_cnt/cmp_discnt_per)),0)*"+car_amt+" AMT "+
"		from "+
			//v => 캠페인기간 실적조회 : a,b 무시 / c(a확대),d(b확대),e 활용
"			(select u.user_id, u.user_nm, u.loan_st,"+
"				nvl(a.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0) c_rent_cnt,"+
"				nvl(b.cnt,0)-nvl(f.cnt,0) c_start_cnt, "+
"				( nvl(a.cnt,0)+nvl(b.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0)-nvl(f.cnt,0) )/2 c_cnt, "+
"				nvl(c.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0) cr_rent_cnt,"+
"				nvl(d.cnt,0)-nvl(f.cnt,0) cr_start_cnt,"+
"				( nvl(c.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0)+nvl(d.cnt,0)-nvl(f.cnt,0) )/2 cr_cnt "+
"			from "+
"				("+a_cam+") a, "+
"				("+b_cam+") b, "+
"				("+c_cam+") c, "+
"				("+d_cam+") d, "+
"				("+e_cam+") e, "+
"				("+f_cam+") f, "+
"				users u  "+
"		    where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id=c.bus_id(+) and u.user_id=d.bus_id(+) and u.user_id=e.bus_id(+) and u.user_id=f.bus_id(+)"+
"				and u.use_yn='Y' "+
"				and u.loan_st is not null "+
"		 	) v, "+
			//u => 평가기준기간 실적조회 - 영업부 union 관리부 union 신입사원
"			("+
			//영업부 평가기준기간 실적조회
"			select"+
"				dept_id, user_id, user_nm, loan_st,"+
"				rent_cnt, start_cnt, cnt1, r_rent_cnt, r_start_cnt, r_cnt, day, r_cnt2, "+
"				decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+bus_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2)) pre_cmp, "+
"				decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+bus_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+bus_ga+"/100 pre_cmp_ga, "+
"				TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, "+
"				(decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+bus_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+bus_ga+"/100)*(TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1))) cmp_discnt_per, "+
"				sum_cnt1, avg_cnt1, sum_r_cnt, avg_r_cnt, sum_bus, avg_bus, avg_low_bus "+
"		    from "+
				//s => 영업부직원별 평가기준기간 실적조회
"				(select u.dept_id, u.user_id, u.user_nm, u.loan_st,"+
"					nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1,"+
"					nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"		            TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+
"		            (nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2 "+
"		        from "+
"					("+a_bas+") a, "+
"					("+b_bas+") b, "+
"					("+c_bas+") c, "+
"					("+d_bas+") d, "+
"					users u "+
"		        where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"					and u.enter_dt < '"+ns_dt1+"'"+
"					and u.use_yn='Y'"+
"					and u.loan_st in ('2','3')"+
"				) s, "+
				//t => 영업부직원별 평가기준기간 실적 합계 및 평균 조회
"		        (select "+
"					sum(cnt1) sum_cnt1, avg(cnt1) avg_cnt1, "+
"		            sum(r_cnt) sum_r_cnt, avg(r_cnt) avg_r_cnt, "+
"		            sum(r_cnt2) sum_bus, avg(r_cnt2) avg_bus, "+
"		            avg(r_cnt2)*"+bus_down_per+"/100 avg_low_bus "+
"		        from "+
"					(select u.dept_id, u.user_id, u.user_nm, u.loan_st,"+
"						nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1,"+
"						nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"						TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+
"		            	(nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2 "+
"					from "+
"						("+a_bas+") a, "+
"						("+b_bas+") b, "+
"						("+c_bas+") c, "+
"						("+d_bas+") d, "+
"						users u "+
"					where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"						and u.enter_dt < '"+ns_dt1+"'"+
"						and u.use_yn='Y'"+
"						and u.loan_st in ('2','3')"+
"					) "+
"		        ) t "+
"			union "+
			//관리부 평가기준기간 실적조회
"			select dept_id, user_id, user_nm,loan_st,"+
"				rent_cnt, start_cnt, cnt1, r_rent_cnt, r_start_cnt, r_cnt, day, r_cnt2, "+
"				decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+mng_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2)) pre_cmp, "+
"				decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+mng_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+mng_ga+"/100 pre_cmp_ga, "+
"				TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, "+
"				(decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+mng_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+mng_ga+"/100)*(TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1))) cmp_discnt_per, "+
"				sum_cnt1, avg_cnt1, sum_r_cnt, avg_r_cnt, sum_bus, avg_bus, avg_low_bus "+
"		    from "+
				//s => 관리부직원별 평가기준기간 실적조회
"				(select u.dept_id, u.user_id, u.user_nm,u.loan_st,"+
"					nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1, "+
"					nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"		            TRUNC(MONTHS_BETWEEN('"+be_dt2+"','"+bs_dt2+"') * 30.5) day, "+
"		           (nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt2+"','"+bs_dt2+"') * 30.5) r_cnt2 "+
"		        from "+
"					("+a_bas2+") a, "+
"					("+b_bas2+") b, "+
"					("+c_bas2+") c, "+
"					("+d_bas2+") d, "+
"					users u "+
"		        where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"					and u.enter_dt < '"+ns_dt1+"'"+
"					and u.use_yn='Y' "+
"					and u.loan_st ='1' "+
"		        ) s, "+
				//t => 관리부직원별 평가기준기간 실적 합계 및 평균 조회
"		        (select "+
"					sum(cnt1) sum_cnt1, avg(cnt1) avg_cnt1, "+
"		            sum(r_cnt) sum_r_cnt, avg(r_cnt) avg_r_cnt, "+
"		            sum(r_cnt2) sum_bus, avg(r_cnt2) avg_bus, "+
"		            avg(r_cnt2)*"+mng_down_per+"/100 avg_low_bus "+
"		        from "+
"					(select u.dept_id, u.user_id, u.user_nm, u.loan_st,"+
"						nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1, "+
"						nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"						TRUNC(MONTHS_BETWEEN('"+be_dt2+"','"+bs_dt2+"') * 30.5) day, "+
"		            	(nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt2+"','"+bs_dt2+"') * 30.5) r_cnt2 "+
"					from "+
"						("+a_bas2+") a, "+
"						("+b_bas2+") b, "+
"						("+c_bas2+") c, "+
"						("+d_bas2+") d, "+
"						users u "+
"					where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"						and u.enter_dt < '"+ns_dt1+"'"+
"						and u.use_yn='Y'"+
"						and u.loan_st ='1' "+
"					) "+
"		        ) t ";


if(vt2.size()>0 && nm_cnt1+nb_cnt1 >0){
	for(int i=0; i<vt2.size(); i++){
		Hashtable ht2 = (Hashtable)vt2.elementAt(i);
		if(String.valueOf(ht2.get("LOAN_ST")).equals("1"))	cnt1 = nm_cnt1;
		else												cnt1 = nb_cnt1;
		query += " union select '"+String.valueOf(ht2.get("DEPT_ID"))+"' dept_id, '"+String.valueOf(ht2.get("USER_ID"))+"' user_id, '"+String.valueOf(ht2.get("USER_NM"))+"' user_nm, '"+String.valueOf(ht2.get("LOAN_ST"))+"' loan_st, "+cnt1+" rent_cnt, "+cnt1+" start_cnt, "+cnt1+" cnt1, "+cnt1+" r_rent_cnt, "+cnt1+" r_start_cnt, "+cnt1+" r_cnt, TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) pre_cmp, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100 pre_cmp_ga, TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, ("+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100)*TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) cmp_discnt_per, 0, 0, 0, 0, 0, 0, 0 from dual ";
	}
}

if(vt3.size()>0 && nm_cnt2+nb_cnt2 >0){
	for(int i=0; i<vt3.size(); i++){
		Hashtable ht3 = (Hashtable)vt3.elementAt(i);
		if(String.valueOf(ht3.get("LOAN_ST")).equals("1"))	cnt1 = nm_cnt2;
		else												cnt1 = nb_cnt2;
		query += " union select '"+String.valueOf(ht3.get("DEPT_ID"))+"' dept_id, '"+String.valueOf(ht3.get("USER_ID"))+"' user_id, '"+String.valueOf(ht3.get("USER_NM"))+"' user_nm, '"+String.valueOf(ht3.get("LOAN_ST"))+"' loan_st, "+cnt1+" rent_cnt, "+cnt1+" start_cnt, "+cnt1+" cnt1, "+cnt1+" r_rent_cnt, "+cnt1+" r_start_cnt, "+cnt1+" r_cnt, TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) pre_cmp, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100 pre_cmp_ga, TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, ("+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100)*TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) cmp_discnt_per, 0, 0, 0, 0, 0, 0, 0 from dual ";
	}
}

if(vt4.size()>0 && nm_cnt3+nb_cnt3 >0){
	for(int i=0; i<vt4.size(); i++){
		Hashtable ht4 = (Hashtable)vt4.elementAt(i);
		if(String.valueOf(ht4.get("LOAN_ST")).equals("1"))	cnt1 = nm_cnt3;
		else												cnt1 = nb_cnt3;
		query += " union select '"+String.valueOf(ht4.get("DEPT_ID"))+"' dept_id, '"+String.valueOf(ht4.get("USER_ID"))+"' user_id, '"+String.valueOf(ht4.get("USER_NM"))+"' user_nm, '"+String.valueOf(ht4.get("LOAN_ST"))+"' loan_st, "+cnt1+" rent_cnt, "+cnt1+" start_cnt, "+cnt1+" cnt1, "+cnt1+" r_rent_cnt, "+cnt1+" r_start_cnt, "+cnt1+" r_cnt, TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) pre_cmp, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100 pre_cmp_ga, TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, ("+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100)*TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) cmp_discnt_per, 0, 0, 0, 0, 0, 0, 0 from dual ";
	}
}

if(vt5.size()>0 && nm_cnt4+nb_cnt4 >0){
	for(int i=0; i<vt5.size(); i++){
		Hashtable ht5 = (Hashtable)vt5.elementAt(i);
		if(String.valueOf(ht5.get("LOAN_ST")).equals("1"))	cnt1 = nm_cnt4;
		else												cnt1 = nb_cnt4;
		query += " union select '"+String.valueOf(ht5.get("DEPT_ID"))+"' dept_id, '"+String.valueOf(ht5.get("USER_ID"))+"' user_id, '"+String.valueOf(ht5.get("USER_NM"))+"' user_nm, '"+String.valueOf(ht5.get("LOAN_ST"))+"' loan_st, "+cnt1+" rent_cnt, "+cnt1+" start_cnt, "+cnt1+" cnt1, "+cnt1+" r_rent_cnt, "+cnt1+" r_start_cnt, "+cnt1+" r_cnt, TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) pre_cmp, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100 pre_cmp_ga, TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, ("+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100)*TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) cmp_discnt_per, 0, 0, 0, 0, 0, 0, 0 from dual ";
	}
}

query += "			) u "+
"		where u.user_id = v.user_id "+
"	) "+
"	order by ORG_DALSUNG desc, amt desc, cmp_discnt_per desc ";


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
			System.out.println("[CampaignDatabase:getCampaign_200809(String bs_dt, String be_dt, String cs_dt, String ce_dt, int amt, int bus_up_per, int bus_down_per, int mng_up_per, int mng_down_per)]"+e);
			System.out.println("영업캠페인 조회 에러"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
                if(rs2 != null )	rs2.close();
                if(pstmt2 != null)	pstmt2.close();
                if(rs3 != null )	rs3.close();
                if(pstmt3 != null)	pstmt3.close();
                if(rs4 != null )	rs4.close();
                if(pstmt4 != null)	pstmt4.close();
                if(rs5 != null )	rs5.close();
                if(pstmt5 != null)	pstmt5.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}	

	/**
	 * 결과 평균값 구하기
	*/
	public double getAvg_Dalsung_200809(String bs_dt, String be_dt, String bs_dt2, String be_dt2, String cs_dt, String ce_dt, int car_amt, int bus_up_per, int bus_down_per, int mng_up_per, int mng_down_per, int bus_amt_per, int mng_amt_per, int cnt1, int mon, String cnt2, float cmp_discnt_per, int max_dalsung, int bus_ga, int mng_ga, int bus_new_ga, String enter_dt, String ns_dt1, String ns_dt2, String ns_dt3, String ns_dt4, String ne_dt1, String ne_dt2, String ne_dt3, String ne_dt4, int nm_cnt1, int nm_cnt2, int nm_cnt3, int nm_cnt4, int nb_cnt1, int nb_cnt2, int nb_cnt3, int nb_cnt4)
	{
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		PreparedStatement pstmt4 = null;
		PreparedStatement pstmt5 = null;
		ResultSet rs = null;
		ResultSet rs2 = null;
		ResultSet rs3 = null;
		ResultSet rs4= null;
		ResultSet rs5= null;
		Vector vt2 = new Vector();
		Vector vt3 = new Vector();
		Vector vt4 = new Vector();
		Vector vt5 = new Vector();

		double avg = 0.0;

		//-------------------------------------------------------------------------------------------
		//cs_dt~ce_dt  : 켐페인기간
		//bs_dt~be_dt  : 영업부 평가기준기간
		//bs_dt2~be_dt : 관리부 평가기준기간

		String a_cam	= getCampaignQuery("rent_dt",  cs_dt, ce_dt);
		String a_bas	= getCampaignQuery("rent_dt", bs_dt,  be_dt);
		String a_bas2	= getCampaignQuery("rent_dt", bs_dt2, be_dt2);

		String b_cam	= getCampaignQuery("rent_start_dt", cs_dt, ce_dt);
		String b_bas	= getCampaignQuery("rent_start_dt", bs_dt,  be_dt);
		String b_bas2	= getCampaignQuery("rent_start_dt", bs_dt2, be_dt2);

		String c_cam	= getCampaignQuery2("rent_dt", cs_dt, ce_dt);
		String c_bas	= getCampaignQuery2("rent_dt", bs_dt,  be_dt);
		String c_bas2	= getCampaignQuery2("rent_dt", bs_dt2, be_dt2);

		String d_cam	= getCampaignQuery2("rent_start_dt", cs_dt, ce_dt);
		String d_bas	= getCampaignQuery2("rent_start_dt", bs_dt,  be_dt);
		String d_bas2	= getCampaignQuery2("rent_start_dt", bs_dt2, be_dt2);

		//출고전해지 감소처리-캠페인기간:해지일기준-켐페인기간3개월전계약
		String e_cam =  "select b.bus_id, count(0) cnt "+
						"from cls_cont a, cont b "+
						"where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd  "+
						"	and cls_st in ('7','10')  "+
						"	and cls_dt between '"+cs_dt+"' and '"+ce_dt+"' "+
						"	and b.rent_dt between to_char(add_months('"+cs_dt+"',-3),'yyyymmdd') and to_char(add_months('"+ce_dt+"',-3),'yyyymmdd') "+
						"group by b.bus_id";

		//6개월전해지 감소처리-캠페인기간:대여개시일기준-6개월이전해지계약
		String f_cam =  "select b.bus_id, count(0) cnt "+
						"from fee a, cont b, (select rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_l_cd) c, cls_cont d "+
						"where "+
						"a.rent_l_cd=b.rent_l_cd "+
						"and a.rent_l_cd=c.rent_l_cd and a.rent_st=c.rent_st "+
						"and a.rent_l_cd=d.rent_l_cd "+
						"and b.car_st<>'2' "+
						"and d.cls_st in ('1','2') "+
						"and b.rent_st not in ('5','7') "+
						"and d.cls_dt between '"+cs_dt+"' and '"+ce_dt+"' "+
						"and to_char(add_months(to_date(a.rent_start_dt,'YYYYMMDD'),6),'YYYYMMDD') > d.cls_dt "+
						"group by b.bus_id";

		//-------------------------------------------------------------------------------------------
		
		String query = "";

		//신입사원리스트
		String query2 = "select * from users where use_yn='Y' and loan_st is not null and enter_dt between '"+ns_dt1+"' and '"+ne_dt1+"'";
		String query3 = "select * from users where use_yn='Y' and loan_st is not null and enter_dt between '"+ns_dt2+"' and '"+ne_dt2+"'";
		String query4 = "select * from users where use_yn='Y' and loan_st is not null and enter_dt between '"+ns_dt3+"' and '"+ne_dt3+"'";
		String query5 = "select * from users where use_yn='Y' and loan_st is not null and enter_dt between '"+ns_dt4+"' and '"+ne_dt4+"'";

		try {
			if(!ns_dt1.equals("")){
				pstmt2 = conn.prepareStatement(query2);
		    	rs2 = pstmt2.executeQuery();

				ResultSetMetaData rsmd2 = rs2.getMetaData();    	
				while(rs2.next())
				{				
					Hashtable ht = new Hashtable();
					for(int pos =1; pos <= rsmd2.getColumnCount();pos++)
					{
						 String columnName = rsmd2.getColumnName(pos);
						 ht.put(columnName, (rs2.getString(columnName))==null?"":rs2.getString(columnName));
					}
					vt2.add(ht);	
				}
				rs2.close();
				pstmt2.close();
			}

			if(!ns_dt2.equals("")){
				pstmt3 = conn.prepareStatement(query3);
		    	rs3 = pstmt3.executeQuery();

				ResultSetMetaData rsmd3 = rs3.getMetaData();    	
				while(rs3.next())
				{				
					Hashtable ht = new Hashtable();
					for(int pos =1; pos <= rsmd3.getColumnCount();pos++)
					{
						 String columnName = rsmd3.getColumnName(pos);
						 ht.put(columnName, (rs3.getString(columnName))==null?"":rs3.getString(columnName));
					}
					vt3.add(ht);	
				}
				rs3.close();
				pstmt3.close();
			}

			if(!ns_dt3.equals("")){
				pstmt4 = conn.prepareStatement(query4);
		    	rs4 = pstmt4.executeQuery();

				ResultSetMetaData rsmd4 = rs4.getMetaData();    	
				while(rs4.next())
				{				
					Hashtable ht = new Hashtable();
					for(int pos =1; pos <= rsmd4.getColumnCount();pos++)
					{
						 String columnName = rsmd4.getColumnName(pos);
						 ht.put(columnName, (rs4.getString(columnName))==null?"":rs4.getString(columnName));
					}
					vt4.add(ht);	
				}
				rs4.close();
				pstmt4.close();
			}

			if(!ns_dt4.equals("")){
				pstmt5 = conn.prepareStatement(query5);
		    	rs5 = pstmt5.executeQuery();

				ResultSetMetaData rsmd5 = rs5.getMetaData();    	
				while(rs5.next())
				{				
					Hashtable ht = new Hashtable();
					for(int pos =1; pos <= rsmd5.getColumnCount();pos++)
					{
						 String columnName = rsmd5.getColumnName(pos);
						 ht.put(columnName, (rs5.getString(columnName))==null?"":rs5.getString(columnName));
					}
					vt5.add(ht);	
				}
				rs5.close();
				pstmt5.close();
			}

		} catch (SQLException e) {
			System.out.println("[CampaignDatabase:getAvg_Dalsung_200801(String bs_dt, String be_dt, String cs_dt, String ce_dt, int amt, int bus_up_per, int bus_down_per, int mng_up_per, int mng_down_per)]"+e);
			e.printStackTrace();
		} 

		query=
"	select round(avg(dalsung),4) AVG_DALSUNG "+
"	from "+
"		(select u.dept_id, u.user_id, u.user_nm, "+
"			rent_cnt, start_cnt, cnt1, r_rent_cnt, r_start_cnt, r_cnt, day, r_cnt2, "+
"			pre_cmp, pre_cmp_ga, c_day, cmp_discnt_per, sum_cnt1, avg_cnt1, sum_r_cnt, avg_r_cnt, sum_bus, avg_bus, avg_low_bus,"+
"			nvl(c_rent_cnt,0) C_RENT_CNT, nvl(c_start_cnt,0) C_START_CNT, nvl(c_cnt,0) C_CNT, nvl(cr_rent_cnt,0) CR_RENT_CNT, nvl(cr_start_cnt,0) CR_START_CNT, nvl(cr_cnt,0) CR_CNT,"+
"			nvl(decode(sign("+max_dalsung+"/100-(cr_cnt/cmp_discnt_per)),-1, "+max_dalsung+"/100,(cr_cnt/cmp_discnt_per)),0) DALSUNG, "+
"			cr_cnt*nvl(decode(sign("+max_dalsung+"/100-(cr_cnt/cmp_discnt_per)),-1, "+max_dalsung+"/100, (cr_cnt/cmp_discnt_per)),0)*"+car_amt+" AMT "+
"			from "+
"				(select u.user_id, u.user_nm, "+
"				nvl(a.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0) c_rent_cnt,"+
"				nvl(b.cnt,0)-nvl(f.cnt,0) c_start_cnt, "+
"				( nvl(a.cnt,0)+nvl(b.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0)-nvl(f.cnt,0) )/2 c_cnt, "+
"				nvl(c.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0) cr_rent_cnt,"+
"				nvl(d.cnt,0)-nvl(f.cnt,0) cr_start_cnt,"+
"				( nvl(c.cnt,0)-nvl(e.cnt,0)-nvl(f.cnt,0)+nvl(d.cnt,0)-nvl(f.cnt,0) )/2 cr_cnt "+
"		         from "+
"					("+a_cam+") a, "+
"					("+b_cam+") b, "+
"					("+c_cam+") c, "+
"					("+d_cam+") d, "+
"					("+e_cam+") e, "+
"					("+f_cam+") f, "+
"					users u  "+
"		    	where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id=c.bus_id(+) and u.user_id=d.bus_id(+) and u.user_id=e.bus_id(+) and u.user_id=f.bus_id(+)"+
"				and u.use_yn='Y' "+
"				and u.loan_st is not null "+
"		 		) v, "+
"				(select dept_id, user_id, user_nm, rent_cnt, start_cnt, cnt1, r_rent_cnt, r_start_cnt, r_cnt, day, r_cnt2, "+
"						decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+bus_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2)) pre_cmp, "+
"						decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+bus_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+bus_ga+"/100 pre_cmp_ga, "+
"						TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, "+
"						(decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+bus_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+bus_ga+"/100)*(TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1))) cmp_discnt_per "+
"						,sum_cnt1, avg_cnt1, sum_r_cnt, avg_r_cnt, sum_bus, avg_bus, avg_low_bus "+
"		        from "+
"		            (select u.dept_id, u.user_id, u.user_nm, nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1, nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"		                   TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+
"		            	   (nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2 "+
"		            from "+
"						("+a_bas+") a, "+
"						("+b_bas+") b, "+
"						("+c_bas+") c, "+
"						("+d_bas+") d, users u "+
"		            where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"		            and u.enter_dt<'"+ns_dt1+"'"+
"					and u.use_yn='Y'"+
"					and u.loan_st in ('2','3')"+
"		            ) s, "+
"		            (select  sum(cnt1) sum_cnt1, avg(cnt1) avg_cnt1, "+
"		                    sum(r_cnt) sum_r_cnt, avg(r_cnt) avg_r_cnt, "+
"		                    sum(r_cnt2) sum_bus, avg(r_cnt2) avg_bus, "+
"		                    avg(r_cnt2)*"+bus_down_per+"/100 avg_low_bus			 "+
"		            from (select u.dept_id, u.user_id, u.user_nm, nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1, nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"								TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+
"		            			(nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2 "+
"						from "+
"							("+a_bas+") a, "+
"							("+b_bas+") b, "+
"							("+c_bas+") c, "+
"							("+d_bas+") d, users u "+
"						where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"					    and u.enter_dt<'"+ns_dt1+"'"+
"						and u.use_yn='Y'"+
"						and u.loan_st in ('2','3')"+
"						) "+
"		            ) t "+
"				union "+	//여기까지 영업부
"				select dept_id, user_id, user_nm, rent_cnt, start_cnt, cnt1, r_rent_cnt, r_start_cnt, r_cnt, day, r_cnt2, "+
"						decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+mng_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2)) pre_cmp, "+
"						decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+mng_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+mng_ga+"/100 pre_cmp_ga, "+
"						TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, "+
"						(decode(sign(s.r_cnt2-avg_bus),1, avg_bus+(s.r_cnt2-avg_bus)*"+mng_up_per+"/100,decode(sign(s.r_cnt2-avg_low_bus),-1,avg_low_bus,s.r_cnt2))*"+mng_ga+"/100)*(TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1))) cmp_discnt_per "+
"						,sum_cnt1, avg_cnt1, sum_r_cnt, avg_r_cnt, sum_bus, avg_bus, avg_low_bus "+
"		        from "+
"		            (select u.dept_id, u.user_id, u.user_nm, nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1, nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"		                   TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+
"		            	   (nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2 "+
"		            from "+
"						("+a_bas2+") a, "+
"						("+b_bas2+") b, "+
"						("+c_bas2+") c, "+
"						("+d_bas2+") d, users u "+
"		            where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"				    and u.enter_dt<'"+ns_dt1+"'"+
"					and u.use_yn='Y'"+
"					and u.loan_st='1'"+
"		            ) s, "+
"		            (select  sum(cnt1) sum_cnt1, avg(cnt1) avg_cnt1, "+
"		                    sum(r_cnt) sum_r_cnt, avg(r_cnt) avg_r_cnt, "+
"		                    sum(r_cnt2) sum_bus, avg(r_cnt2) avg_bus, "+
"		                    avg(r_cnt2)*"+mng_down_per+"/100 avg_low_bus			 "+
"		            from (select u.dept_id, u.user_id, u.user_nm, nvl(a.cnt,0) rent_cnt, nvl(b.cnt,0) start_cnt, (nvl(a.cnt,0)+nvl(b.cnt,0))/2 cnt1, nvl(c.cnt,0) r_rent_cnt, nvl(d.cnt,0) r_start_cnt, (nvl(c.cnt,0)+nvl(d.cnt,0))/2 r_cnt, "+
"								TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+
"		            			(nvl(c.cnt,0)+nvl(d.cnt,0))/2/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2 "+
"							from "+
"							("+a_bas2+") a, "+
"							("+b_bas2+") b, "+
"							("+c_bas2+") c, "+
"							("+d_bas2+") d, users u "+
"						where u.user_id = a.bus_id(+) and u.user_id = b.bus_id(+) and u.user_id = c.bus_id(+) and u.user_id = d.bus_id(+) "+
"					    and u.enter_dt<'"+ns_dt1+"'"+
"						and u.use_yn='Y'"+
"						and u.loan_st='1'"+
"						) "+
"		            ) t ";

if(vt2.size()>0 && nm_cnt1+nb_cnt1 >0){
	for(int i=0; i<vt2.size(); i++){
		Hashtable ht2 = (Hashtable)vt2.elementAt(i);
		if(String.valueOf(ht2.get("LOAN_ST")).equals("1"))	cnt1 = nm_cnt1;
		else												cnt1 = nb_cnt1;
		query += " union select '"+String.valueOf(ht2.get("DEPT_ID"))+"' dept_id, '"+String.valueOf(ht2.get("USER_ID"))+"' user_id, '"+String.valueOf(ht2.get("USER_NM"))+"' user_nm, "+cnt1+" rent_cnt, "+cnt1+" start_cnt, "+cnt1+" cnt1, "+cnt1+" r_rent_cnt, "+cnt1+" r_start_cnt, "+cnt1+" r_cnt, TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) pre_cmp, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100 pre_cmp_ga, TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, ("+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100)*TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) cmp_discnt_per, 0, 0, 0, 0, 0, 0, 0 from dual ";
	}
}

if(vt3.size()>0 && nm_cnt2+nb_cnt2 >0){
	for(int i=0; i<vt3.size(); i++){
		Hashtable ht3 = (Hashtable)vt3.elementAt(i);
		if(String.valueOf(ht3.get("LOAN_ST")).equals("1"))	cnt1 = nm_cnt2;
		else												cnt1 = nb_cnt2;
		query += " union select '"+String.valueOf(ht3.get("DEPT_ID"))+"' dept_id, '"+String.valueOf(ht3.get("USER_ID"))+"' user_id, '"+String.valueOf(ht3.get("USER_NM"))+"' user_nm, "+cnt1+" rent_cnt, "+cnt1+" start_cnt, "+cnt1+" cnt1, "+cnt1+" r_rent_cnt, "+cnt1+" r_start_cnt, "+cnt1+" r_cnt, TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) pre_cmp, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100 pre_cmp_ga, TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, ("+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100)*TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) cmp_discnt_per, 0, 0, 0, 0, 0, 0, 0 from dual ";
	}
}

if(vt4.size()>0 && nm_cnt3+nb_cnt3 >0){
	for(int i=0; i<vt4.size(); i++){
		Hashtable ht4 = (Hashtable)vt4.elementAt(i);
		if(String.valueOf(ht4.get("LOAN_ST")).equals("1"))	cnt1 = nm_cnt3;
		else												cnt1 = nb_cnt3;
		query += " union select '"+String.valueOf(ht4.get("DEPT_ID"))+"' dept_id, '"+String.valueOf(ht4.get("USER_ID"))+"' user_id, '"+String.valueOf(ht4.get("USER_NM"))+"' user_nm, "+cnt1+" rent_cnt, "+cnt1+" start_cnt, "+cnt1+" cnt1, "+cnt1+" r_rent_cnt, "+cnt1+" r_start_cnt, "+cnt1+" r_cnt, TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) pre_cmp, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100 pre_cmp_ga, TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, ("+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100)*TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) cmp_discnt_per, 0, 0, 0, 0, 0, 0, 0 from dual ";
	}
}

if(vt5.size()>0 && nm_cnt4+nb_cnt4 >0){
	for(int i=0; i<vt5.size(); i++){
		Hashtable ht5 = (Hashtable)vt5.elementAt(i);
		if(String.valueOf(ht5.get("LOAN_ST")).equals("1"))	cnt1 = nm_cnt4;
		else												cnt1 = nb_cnt4;
		query += " union select '"+String.valueOf(ht5.get("DEPT_ID"))+"' dept_id, '"+String.valueOf(ht5.get("USER_ID"))+"' user_id, '"+String.valueOf(ht5.get("USER_NM"))+"' user_nm, "+cnt1+" rent_cnt, "+cnt1+" start_cnt, "+cnt1+" cnt1, "+cnt1+" r_rent_cnt, "+cnt1+" r_start_cnt, "+cnt1+" r_cnt, TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) day, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) r_cnt2, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5) pre_cmp, "+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100 pre_cmp_ga, TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) c_day, ("+cnt1+"/TRUNC(MONTHS_BETWEEN('"+be_dt+"','"+bs_dt+"') * 30.5)*"+bus_new_ga+"/100)*TRUNC(to_date(decode(sign(SYSDATE-TO_DATE('"+ce_dt+"', 'YYYYMMDD')),-1 , to_char(sysdate,'yyyymmdd'), '"+ce_dt+"')) - (to_date('"+cs_dt+"')-1)) cmp_discnt_per, 0, 0, 0, 0, 0, 0, 0 from dual ";
	}
}


query += "		) u "+
"		where u.user_id = v.user_id "+
"	)  ";


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			while(rs.next()){
				avg = rs.getDouble(1);
			}

	
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CampaignDatabase:getAvg_Dalsung_200809(String bs_dt, String be_dt, String cs_dt, String ce_dt, int amt, int bus_up_per, int bus_down_per, int mng_up_per, int mng_down_per)]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
                if(rs2 != null )	rs2.close();
                if(pstmt2 != null)	pstmt2.close();
                if(rs3 != null )	rs3.close();
                if(pstmt3 != null)	pstmt3.close();
                if(rs4 != null )	rs4.close();
                if(pstmt4 != null)	pstmt4.close();
                if(rs5 != null )	rs5.close();
                if(pstmt5 != null)	pstmt5.close();
			}catch(Exception ignore){}
			closeConnection();
			return avg;
		}
	}	

	/**
	 * 영업실적 마감 데이타 등록
	 */
	public boolean insertStatBusCmpBaseData(String bs_dt, String be_dt, String cs_dt, String ce_dt)
	{
		getConnection();
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		PreparedStatement pstmt4 = null;
		PreparedStatement pstmt5 = null;
		ResultSet rs1 = null;
		ResultSet rs2 = null;
		Vector vt = new Vector();
		boolean flag = true;
		int count = 0;
		String sub_query = "";
		String sub_query2 = "";
		String sub_query3 = "";
		String query1 = "";
		String query2 = "";
		String query3 = "";
		String query4 = "";
		String query5 = "";
		String query6 = "";

		query5 = " update cont_etc set bus_agnt_id='' where bus_agnt_id like '1%'";
		query6 = " update fee_etc set bus_agnt_id='' where bus_agnt_id like '1%'";

		query1 = " delete from stat_bus_cmp_base where bs_dt=replace(?,'-','') and ce_dt=replace(?,'-','')";


		sub_query =  " select"+
				"     a.rent_mng_id,"+
				"     a.rent_l_cd,"+
				"     a.client_id,"+
				"     i.ssn,"+
				"     b.rent_st,"+
				"     decode(b.rent_st,'1',a.bus_id,b.ext_agnt) bus_id,"+
				"     decode(decode(b.rent_st,'1',a.bus_id,b.ext_agnt),decode(b.rent_st,'1',e.bus_agnt_id,d.bus_agnt_id),'',decode(b.rent_st,'1',e.bus_agnt_id,d.bus_agnt_id)) bus_agnt_id,"+
				"     decode(b.rent_st,'1',a.rent_dt,b.rent_dt) rent_dt,"+
				"     nvl(b.rent_start_dt,h.car_rent_st) rent_start_dt,"+
				"     b.rent_end_dt,"+
				"     f.cls_dt,"+
				"     f.cls_st,"+
				"     b.con_mon,"+
				"     nvl(trunc(months_between(to_date(nvl(f.cls_dt,to_char(sysdate,'YYYYMMDD')),'YYYYMMDD')+1, to_date(b.rent_start_dt,'YYYYMMDD'))),0) use_mon,"+
				"     decode(sign(decode(b.rent_st,'1',a.rent_dt,b.rent_dt) - replace('"+bs_dt+"','-',''))+sign(replace('"+be_dt+"','-','')-decode(b.rent_st,'1',a.rent_dt,b.rent_dt) ),0,0,1) cnt1,"+
				"     decode(nvl(b.rent_start_dt,h.car_rent_st),'',0, decode(sign(nvl(b.rent_start_dt,h.car_rent_st)        - replace('"+bs_dt+"','-',''))+sign(replace('"+be_dt+"','-','')-nvl(b.rent_start_dt,h.car_rent_st) ),0,0,1)) cnt2,"+
				"     decode(sign(decode(b.rent_st,'1',a.rent_dt,b.rent_dt) - replace('"+cs_dt+"','-',''))+sign(replace('"+ce_dt+"','-','')-decode(b.rent_st,'1',a.rent_dt,b.rent_dt) ),0,0,1) cnt3,"+
				"     decode(nvl(b.rent_start_dt,h.car_rent_st),'',0, decode(sign(nvl(b.rent_start_dt,h.car_rent_st)        - replace('"+cs_dt+"','-',''))+sign(replace('"+ce_dt+"','-','')-nvl(b.rent_start_dt,h.car_rent_st) ),0,0,1)) cnt4,"+
				"	  d.bus_agnt_r_per"+
				" from"+
				"     cont a, fee b, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, min(rent_start_dt) rent_start_dt, max(rent_end_dt) rent_end_dt from fee group by rent_mng_id, rent_l_cd) c,"+
				"     fee_etc d, cont_etc e, cls_cont f,"+
				"     (select * from taecha where rent_fee>0) h,"+
				"     client i"+
				" where"+
				"     a.car_st<>'2'"+
				"     and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"     and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st"+
				"     and c.rent_mng_id=d.rent_mng_id(+) and c.rent_l_cd=d.rent_l_cd(+) and c.rent_st=d.rent_st(+)"+
				"     and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+)"+
				"     and a.rent_mng_id=f.rent_mng_id(+) and a.rent_l_cd=f.rent_l_cd(+)"+
				"     and a.rent_mng_id=h.rent_mng_id(+) and a.rent_l_cd=h.rent_l_cd(+) and nvl(h.no,'0')='0'"+
				"     and a.client_id=i.client_id"+
				"     and ( decode(b.rent_st,'1',a.rent_dt,b.rent_dt) >= replace('"+bs_dt+"','-','') or nvl(b.rent_start_dt,h.car_rent_st) >= replace('"+bs_dt+"','-',''))"+
				"     and ( decode(b.rent_st,'1',a.rent_dt,b.rent_dt) <= replace('"+ce_dt+"','-','') or nvl(b.rent_start_dt,h.car_rent_st) <= replace('"+ce_dt+"','-','')) ";

		//최초영업자
		sub_query2 = " select "+
				 " rent_mng_id, rent_l_cd, client_id, ssn, rent_st, bus_id, bus_agnt_id,"+
				 " rent_dt, rent_start_dt, rent_end_dt, cls_dt, cls_st, con_mon, use_mon, ";

		if(cs_dt.equals("20080701")){
			sub_query2 += " decode(cnt1,1,decode(bus_agnt_id,'',1,1),0) cnt1, "+
					      " decode(cnt2,1,decode(bus_agnt_id,'',1,1),0) cnt2, ";
		}else{
			if(cs_dt.equals("20090101")){
				sub_query2 += " decode(cnt1,1,decode(bus_agnt_id,'',1,0.8),0) cnt1, "+
						      " decode(cnt2,1,decode(bus_agnt_id,'',1,0.8),0) cnt2, ";
			}else{
				sub_query2 += " decode(cnt1,1,decode(bus_agnt_id,'',1,0.75),0) cnt1, "+
						      " decode(cnt2,1,decode(bus_agnt_id,'',1,0.75),0) cnt2, ";
			}
		}

		sub_query2 += " decode(cnt3,1,decode(bus_agnt_id,'',1,0.75),0) cnt3, "+
					  " decode(cnt4,1,decode(bus_agnt_id,'',1,0.75),0) cnt4, ";

		sub_query2 += " '1' bus_st"+
				      " from ("+sub_query+") "; 


		//영업대리인
		sub_query3 = " select "+
				 " rent_mng_id, rent_l_cd, client_id, ssn, rent_st, bus_agnt_id as bus_id, '' bus_agnt_id, "+
				 " rent_dt, rent_start_dt, rent_end_dt, cls_dt, cls_st, con_mon, use_mon, ";

		if(cs_dt.equals("20080701")){
			sub_query3 += " decode(cnt1,1,0,0) cnt1, "+
						  " decode(cnt2,1,0,0) cnt2, ";
		}else{
			if(cs_dt.equals("20090101")){
				sub_query3 += " decode(cnt1,1,0.2,0) cnt1, "+
							  " decode(cnt2,1,0.2,0) cnt2, ";
			}else{
				sub_query3 += " decode(cnt1,1,0.25,0) cnt1, "+
							  " decode(cnt2,1,0.25,0) cnt2, ";
			}
		}

		sub_query3 += " decode(cnt3,1,0.25,0) cnt3, "+
				      " decode(cnt4,1,0.25,0) cnt4, ";

		sub_query3 += " '2' bus_st"+
				       " from ("+sub_query+") where bus_agnt_id is not null"; 


		query2 = " select * from ( ("+sub_query2+") union all ("+sub_query3+") )";




		query3 = " insert into stat_bus_cmp_base "+
				 " (  bs_dt, ce_dt, rent_mng_id, rent_l_cd, client_id, ssn, rent_st, bus_id, bus_agnt_id, "+
				 "	  rent_dt, rent_start_dt, rent_end_dt, cls_dt, cls_st, con_mon, use_mon, cnt1, cnt2, cnt3, cnt4, bus_st "+
				 " )  values "+
				 " (  replace(?,'-',''), replace(?,'-',''), ?, ?, ?,     ?, ?, ?, ?, ?,    ?, ?, ?, ?, ?,   ?, ?, ?, ?, ?,   ? "+
				 " ) ";


		try {

			conn.setAutoCommit(false);
	

			//영업대리인 정리
			pstmt1 = conn.prepareStatement(query5);
			count = pstmt1.executeUpdate();
			pstmt1.close();

			//영업대리인 정리
			pstmt4 = conn.prepareStatement(query6);
			count = pstmt4.executeUpdate();
			pstmt4.close();

			//기존 기초데이타 삭제
			pstmt5 = conn.prepareStatement(query1);
			pstmt5.setString(1, bs_dt);
			pstmt5.setString(2, ce_dt);
			count = pstmt5.executeUpdate();
			pstmt5.close();

			//기초데이타 조회
			pstmt2 = conn.prepareStatement(query2);
	    	rs2 = pstmt2.executeQuery();
			//신규데이타 입력처리
			while(rs2.next())
			{				
				pstmt3 = conn.prepareStatement(query3);
	            pstmt3.setString(1,  bs_dt);
		        pstmt3.setString(2,  ce_dt);
	            pstmt3.setString(3,  rs2.getString("rent_mng_id"));
		        pstmt3.setString(4,  rs2.getString("rent_l_cd"));
			    pstmt3.setString(5,  rs2.getString("client_id"));
				pstmt3.setString(6,  rs2.getString("ssn"));
	            pstmt3.setString(7,  rs2.getString("rent_st"));
	            pstmt3.setString(8,  rs2.getString("bus_id"));
		        pstmt3.setString(9,  rs2.getString("bus_agnt_id"));
			    pstmt3.setString(10, rs2.getString("rent_dt"));
				pstmt3.setString(11, rs2.getString("rent_start_dt"));
	            pstmt3.setString(12, rs2.getString("rent_end_dt"));
	            pstmt3.setString(13, rs2.getString("cls_dt"));
		        pstmt3.setString(14, rs2.getString("cls_st"));
			    pstmt3.setString(15, rs2.getString("con_mon"));
				pstmt3.setString(16, rs2.getString("use_mon"));
				pstmt3.setString(17, rs2.getString("cnt1"));
				pstmt3.setString(18, rs2.getString("cnt2"));
				pstmt3.setString(19, rs2.getString("cnt3"));
				pstmt3.setString(20, rs2.getString("cnt4"));
				pstmt3.setString(21, rs2.getString("bus_st"));
				count = pstmt3.executeUpdate();
				pstmt3.close();
			}
			rs2.close();
			pstmt2.close();	


			conn.commit();

		} catch (SQLException e) {
			System.out.println("[CampaignDatabase:insertStatBusCmpBaseData]"+e);
			System.out.println("[CampaignDatabase:insertStatBusCmpBaseData]"+query2);
			e.printStackTrace();
			conn.rollback();
			flag = false;
		} finally {
			try{
				conn.setAutoCommit(true);
                if(rs1 != null )	rs1.close();
                if(rs2 != null )	rs2.close();
                if(pstmt1 != null)	pstmt1.close();
				if(pstmt2 != null)	pstmt2.close();
				if(pstmt3 != null)	pstmt3.close();
				if(pstmt4 != null)	pstmt4.close();
				if(pstmt5 != null)	pstmt5.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}	

	/**
	 * 영업실적 마감 데이타 조회
	 */
	public Vector getStatBusCmpBaseData(String bs_dt, String ce_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select * from stat_bus_cmp_base where bs_dt=replace(?,'-','') and ce_dt=replace(?,'-','')";


		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, bs_dt);
			pstmt.setString(2, ce_dt);
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
			System.out.println("[CampaignDatabase:getStatBusCmpBaseData]\n"+e);
			System.out.println("[CampaignDatabase:getStatBusCmpBaseData]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}	

	//영업증진캠페인 기초정보 기본쿼리문 리턴
    public static String getCmpBaseQuery(String mode, String bs_dt, String be_dt, String cs_dt, String ce_dt) 
    {

    	String query = "";
    	String query1 = "";
    	String query2 = "";
    	String query3 = "";
    	String where2 = "";
    	String where3 = "";

    	String where = " a.bs_dt=replace('"+bs_dt+"','-','') and a.ce_dt=replace('"+ce_dt+"','-','') and nvl(a.cls_st,'0') not in ('4','5','7','10') ";

		if(mode.equals("1")) where2 = " and a.cnt1<>'0'";
		if(mode.equals("2")) where2 = " and a.cnt2<>'0'";
		if(mode.equals("3")) where2 = " and a.cnt3<>'0'";
		if(mode.equals("4")) where2 = " and a.cnt4<>'0'";

		//정상계약
		query1 = " select '1' st, a.cnt1 as c_cnt1, a.cnt2 as c_cnt2, a.cnt3 as c_cnt3, a.cnt4 as c_cnt4, a.* from stat_bus_cmp_base a where "+where+" "+where2+" and a.con_mon>=6" ;

		//6개월미만 계약, 실경과월 6개월 이상
		query2 = " select '2' st, a.cnt1 as c_cnt1, a.cnt2 as c_cnt2, decode(a.cnt3,'0',a.cnt1,a.cnt3) as c_cnt3, decode(a.cnt4,'0',a.cnt2,a.cnt4) as c_cnt4, a.* from stat_bus_cmp_base a where "+where+" and a.con_mon<6 and a.use_mon>=6" ;

		//6개월이상 계약, 실경과월 6개월 미만(해지)
		query3 = " select '3' st, a.cnt1 as c_cnt1, a.cnt2 as c_cnt2, '-'||decode(a.cnt3,'0',a.cnt1,a.cnt3) as c_cnt3, '-'||decode(a.cnt4,'0',a.cnt2,a.cnt4) as c_cnt4, a.* from stat_bus_cmp_base a where "+where+" and a.cls_dt >= replace('"+cs_dt+"','-','') and a.con_mon>=6 and a.cls_dt is not null and a.use_mon<6" ;


		query =	" select"+
				"      a.*, "+
				"      b.min_rent_dt, c.min_start_dt, ";

	
		if(cs_dt.equals("20080701")){
			if(mode.equals("1"))	query += " decode(a.c_cnt1,'0','',decode(b.min_rent_dt, '',  a.c_cnt1/2, a.c_cnt1 )) r_cnt1";
			if(mode.equals("2"))	query += " decode(a.c_cnt2,'0','',decode(c.min_start_dt, '', a.c_cnt2/2, a.c_cnt2 )) r_cnt2";
		}else{
			if(mode.equals("1"))	query += " decode(a.c_cnt1,'0','',decode(b.min_rent_dt, '',  a.c_cnt1/2, a.c_cnt1 )) r_cnt1";
			if(mode.equals("2"))	query += " decode(a.c_cnt2,'0','',decode(c.min_start_dt, '', a.c_cnt2/2, a.c_cnt2 )) r_cnt2";
		}
		if(mode.equals("3"))		query += " decode(a.c_cnt3,'0','',decode(b.min_rent_dt, '',  a.c_cnt3/2, a.c_cnt3 )) r_cnt3";
		if(mode.equals("4"))		query += " decode(a.c_cnt4,'0','',decode(c.min_start_dt, '', a.c_cnt4/2, a.c_cnt4 )) r_cnt4";
		

		query +=" from "+
				"      ("+query1+" union all "+query2+" union all "+query3+") a, "+
				"      (select ssn, bus_id, min(rent_dt||rent_l_cd||st) min_rent_dt			from ("+query1+" union all "+query2+" union all "+query3+") group by ssn, bus_id ) b, "+
				"      (select ssn, bus_id, min(rent_start_dt||rent_l_cd||st) min_start_dt	from ("+query1+" union all "+query2+" union all "+query3+") group by ssn, bus_id ) c  "+
				" where "+
				       where+
				"      and a.ssn=b.ssn(+) and a.bus_id=b.bus_id(+) and a.rent_dt||a.rent_l_cd||a.st=b.min_rent_dt(+)"+
				"      and a.ssn=c.ssn(+) and a.bus_id=c.bus_id(+) and a.rent_start_dt||a.rent_l_cd||a.st=c.min_start_dt(+)";
		

		return query;

    }

	/**
	 * 영업실적 마감 데이타 조회
	 */
	public Vector getStatBusCmpAccountData(Hashtable var, String mode)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		String cs_dt 		= String.valueOf(var.get("CS_DT"));
		String ce_dt 		= String.valueOf(var.get("CE_DT"));
		String bs_dt 		= String.valueOf(var.get("BS_DT"));
		String be_dt 		= String.valueOf(var.get("BE_DT"));
		String bs_dt2 		= String.valueOf(var.get("BS_DT2"));
		String be_dt2 		= String.valueOf(var.get("BE_DT2"));
		String enter_dt		= String.valueOf(var.get("ENTER_DT"));
		String bus_up_per 	= String.valueOf(var.get("BUS_UP_PER"));
		String bus_down_per = String.valueOf(var.get("BUS_DOWN_PER"));
		String mng_up_per 	= String.valueOf(var.get("MNG_UP_PER"));
		String mng_down_per = String.valueOf(var.get("MNG_DOWN_PER"));
		String ns_dt1		= String.valueOf(var.get("NS_DT1"));
		String ns_dt2		= String.valueOf(var.get("NS_DT2"));
		String ns_dt3		= String.valueOf(var.get("NS_DT3"));
		String ns_dt4		= String.valueOf(var.get("NS_DT4"));
		String ne_dt1		= String.valueOf(var.get("NE_DT1"));
		String ne_dt2		= String.valueOf(var.get("NE_DT2"));
		String ne_dt3		= String.valueOf(var.get("NE_DT3"));
		String ne_dt4		= String.valueOf(var.get("NE_DT4"));
		String nm_cnt1		= String.valueOf(var.get("NM_CNT1"));
		String nm_cnt2		= String.valueOf(var.get("NM_CNT2"));
		String nm_cnt3		= String.valueOf(var.get("NM_CNT3"));
		String nm_cnt4		= String.valueOf(var.get("NM_CNT4"));
		String nb_cnt1		= String.valueOf(var.get("NB_CNT1"));
		String nb_cnt2		= String.valueOf(var.get("NB_CNT2"));
		String nb_cnt3		= String.valueOf(var.get("NB_CNT3"));
		String nb_cnt4		= String.valueOf(var.get("NB_CNT4"));

		//기준실적-계약
		String sub_query = " select"+
						"   f.enter_dt, f.loan_st, f.dept_id, f.user_nm, decode(sign(f.enter_dt-replace('"+enter_dt+"','-','')),-1,'','신입') enter_st, "+
						"   a.bus_id, "+
						"   nvl(b.cnt1,0) as 계약1, nvl(c.cnt2,0) as 개시1, (nvl(b.cnt1,0)+nvl(c.cnt2,0))/2 as 합계1, "+
						"   nvl(b.r_cnt1,0) as 유효계약1, nvl(c.r_cnt2,0) as 유효개시1, "+
						"   (nvl(b.r_cnt1,0)+nvl(c.r_cnt2,0))/2 as 유효합계1, "+
						"   a.b_day as 총일수, "+
						"   trunc(((nvl(b.r_cnt1,0)+nvl(c.r_cnt2,0))/2)/b_day,5) 일평균, "+
						"   a.c_day as 경과일수, "+
						"   nvl(d.cnt3,0) as 계약2, nvl(e.cnt4,0) as 개시2, (nvl(d.cnt3,0)+nvl(e.cnt4,0))/2 as 합계2, "+
						"   nvl(d.r_cnt3,0) as 유효계약2, nvl(e.r_cnt4,0) as 유효개시2, (nvl(d.r_cnt3,0)+nvl(e.r_cnt4,0))/2 as 유효합계2 "+
						" from"+
						"	( select bus_id, (to_date(replace('"+be_dt+"','-',''),'YYYYMMDD')-to_date(replace('"+bs_dt+"','-',''),'YYYYMMDD')+1) b_day, (to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(replace('"+cs_dt+"','-',''),'YYYYMMDD')+1) c_day from stat_bus_cmp_base where bs_dt=replace('"+bs_dt+"','-','') and ce_dt=replace('"+ce_dt+"','-','') group by bus_id) a,"+
						"   ( select bus_id, sum(cnt1) cnt1, sum(r_cnt1) r_cnt1 from ( select ssn, bus_id, sum(to_number(cnt1)) cnt1, sum(decode(sign(10-to_number(r_cnt1)),-1,10,to_number(r_cnt1))) r_cnt1 from ( "+getCmpBaseQuery("1", bs_dt, be_dt, cs_dt, ce_dt)+" ) group by ssn, bus_id ) group by bus_id ) b,"+
						"   ( select bus_id, sum(cnt2) cnt2, sum(r_cnt2) r_cnt2 from ( select ssn, bus_id, sum(to_number(cnt2)) cnt2, sum(decode(sign(10-to_number(r_cnt2)),-1,10,to_number(r_cnt2))) r_cnt2 from ( "+getCmpBaseQuery("2", bs_dt, be_dt, cs_dt, ce_dt)+" ) group by ssn, bus_id ) group by bus_id ) c,"+
						"   ( select bus_id, sum(cnt3) cnt3, sum(r_cnt3) r_cnt3 from ( select ssn, bus_id, sum(to_number(cnt3)) cnt3, sum(decode(sign(10-to_number(r_cnt3)),-1,10,to_number(r_cnt3))) r_cnt3 from ( "+getCmpBaseQuery("3", bs_dt, be_dt, cs_dt, ce_dt)+" ) group by ssn, bus_id ) group by bus_id ) d,"+
						"   ( select bus_id, sum(cnt4) cnt4, sum(r_cnt4) r_cnt4 from ( select ssn, bus_id, sum(to_number(cnt4)) cnt4, sum(decode(sign(10-to_number(r_cnt4)),-1,10,to_number(r_cnt4))) r_cnt4 from ( "+getCmpBaseQuery("4", bs_dt, be_dt, cs_dt, ce_dt)+" ) group by ssn, bus_id ) group by bus_id ) e,"+
						"   users f"+
						" where "+
						"   a.bus_id=b.bus_id(+) and a.bus_id=c.bus_id(+) and a.bus_id=d.bus_id(+) and a.bus_id=e.bus_id(+)"+
						"   and a.bus_id=f.user_id and f.loan_st in ('1','2') and nvl(f.out_dt,'99999999')>='"+ce_dt+"' ";


		if(mode.equals("")){//기존직원

			sub_query += " and f.enter_dt <= '"+enter_dt+"'";

			query = 	"  select a.*, "+
						"         b.부서소계합계1, b.부서소계유효합계1, b.부서소계일평균, "+
						"         b.부서평균합계1, b.부서평균유효합계1, b.부서평균일평균, b.부서최저할인치"+
						"  from "+
						"    ( "+sub_query+" ) a, "+
						"    ( select loan_st, sum(합계1) 부서소계합계1, sum(유효합계1) 부서소계유효합계1, sum(일평균) 부서소계일평균,"+
						"             trunc(avg(합계1),5) 부서평균합계1, trunc(avg(유효합계1),5) 부서평균유효합계1, "+
						"             trunc(avg(일평균),5) 부서평균일평균, "+
						"             trunc(avg(일평균)*decode(loan_st,'1',"+mng_down_per+"/100,"+bus_down_per+"/100),5) 부서최저할인치 "+
						"      from ( "+sub_query+" ) where enter_st is null group by loan_st) b"+
						"  where a.loan_st=b.loan_st(+)";

		}else{

			String ns_dt	= "";
			String ne_dt	= "";
			String nm_cnt	= "";
			String nb_cnt	= "";

			if(mode.equals("1")){//신입1
				ns_dt	= ns_dt1;   
				ne_dt	= ne_dt1;   
				nm_cnt	= nm_cnt1;  
				nb_cnt	= nb_cnt1;  
			}else if(mode.equals("2")){//신입2
				ns_dt	= ns_dt2;   
				ne_dt	= ne_dt2;   
				nm_cnt	= nm_cnt2;  
				nb_cnt	= nb_cnt2;  
			}else if(mode.equals("3")){//신입3
				ns_dt	= ns_dt3;   
				ne_dt	= ne_dt3;   
				nm_cnt	= nm_cnt3;  
				nb_cnt	= nb_cnt3;  
			}else if(mode.equals("4")){//신입4
				ns_dt	= ns_dt4;   
				ne_dt	= ne_dt4;   
				nm_cnt	= nm_cnt4;  
				nb_cnt	= nb_cnt4;  
			}
			
			sub_query += " and f.enter_dt between '"+ns_dt+"' and '"+ne_dt+"'";

			query =		"  select "+
						"         enter_dt, loan_st, dept_id, user_nm, enter_st, bus_id, "+
						"	      decode(loan_st,'1','"+nm_cnt+"', '"+nb_cnt+"') 계약1, "+
						"	      decode(loan_st,'1','"+nm_cnt+"', '"+nb_cnt+"') 개시1, "+
						"	      decode(loan_st,'1','"+nm_cnt+"', '"+nb_cnt+"') 합계1, "+
						"	      decode(loan_st,'1','"+nm_cnt+"', '"+nb_cnt+"') 유효계약1, "+
						"	      decode(loan_st,'1','"+nm_cnt+"', '"+nb_cnt+"') 유효개시1, "+
						"	      decode(loan_st,'1','"+nm_cnt+"', '"+nb_cnt+"') 유효합계1, "+
						"         trunc((decode(loan_st,'1',"+nm_cnt+", "+nb_cnt+")/총일수),5) 일평균, "+
						"         총일수, 경과일수, 계약2, 개시2, 합계2, 유효계약2, 유효개시2, 유효합계2,"+
						"         '' 부서소계합계1, '' 부서소계유효합계1, '' 부서소계일평균, "+
						"         '' 부서평균합계1, '' 부서평균유효합계1, '' 부서평균일평균, '' 부서최저할인치"+
						"   from "+
						"        ( "+sub_query+" ) ";

		}

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
			System.out.println("[CampaignDatabase:getStatBusCmpAccountData]\n"+e);
			System.out.println("[CampaignDatabase:getStatBusCmpAccountData]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}	

	/**
	 *	영업캠페인 임시 테이블 삭제
	 */
	public boolean deleteStatBusCmp(String today)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query = " delete from stat_bus_cmp where save_dt='"+today+"' ";

		try 
		{

			conn.setAutoCommit(false);

			if(!today.equals("")){
				pstmt = conn.prepareStatement(query);
			    pstmt.executeUpdate();
				pstmt.close();
			}   
			
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[CampaignDatabase:deleteStatBusCmp]"+e);
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
	 *	영업캠페인 임시 테이블 삭제
	 */
	public boolean updateStatBusCmpAmt(String save_dt)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		PreparedStatement pstmt4 = null;

		//1군
		String query1 = " update stat_bus_cmp set AVG_DALSUNG = (select trunc(AVG(DALSUNG),2) from stat_bus_cmp where save_dt='"+save_dt+"' and bus_id in (select user_id from users where loan_st='1') ) where save_dt='"+save_dt+"' and bus_id in (select user_id from users where loan_st='1')";

		String query2 = " update stat_bus_cmp set amt='0', amt2='0' where to_number(DALSUNG) < to_number(AVG_DALSUNG) and save_dt='"+save_dt+"' and bus_id in (select user_id from users where loan_st='1')";

		//2군
		String query3 = " update stat_bus_cmp set AVG_DALSUNG = (select trunc(AVG(DALSUNG),2) from stat_bus_cmp where save_dt='"+save_dt+"' and bus_id in (select user_id from users where loan_st='2') ) where save_dt='"+save_dt+"' and bus_id in (select user_id from users where loan_st='2')";

		String query4 = " update stat_bus_cmp set amt='0', amt2='0' where to_number(DALSUNG) < to_number(AVG_DALSUNG) and save_dt='"+save_dt+"' and bus_id in (select user_id from users where loan_st='2')";

		try 
		{

			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query1);
		    pstmt.executeUpdate();
			pstmt.close();
		    
			pstmt2 = conn.prepareStatement(query2);
		    pstmt2.executeUpdate();
			pstmt2.close();

			pstmt3 = conn.prepareStatement(query3);
		    pstmt3.executeUpdate();
			pstmt3.close();
		    
			pstmt4 = conn.prepareStatement(query4);
		    pstmt4.executeUpdate();
			pstmt4.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[CampaignDatabase:updateStatBusCmpAmt]"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
				if(pstmt2 != null)	pstmt2.close();
				if(pstmt3 != null)	pstmt3.close();
				if(pstmt4 != null)	pstmt4.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}



	/**
	 * 영업실적 마감 데이타 담당자별 리스트 조회
	 */
	public Vector getStatBusCmpBaseBusList(String bus_id, String mode, String bs_dt, String be_dt, String cs_dt, String ce_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
    	String query = "";
    	String query1 = "";
    	String query2 = "";
    	String query3 = "";
    	String where2 = "";
    	String where3 = "";

    	String where = " a.bs_dt=replace('"+bs_dt+"','-','') and a.ce_dt=replace('"+ce_dt+"','-','') and a.bus_id='"+bus_id+"' and nvl(a.cls_st,'0') not in ('4','5')  \n";


		if(mode.equals("b")) where2 = " and (a.rent_dt <= replace('"+be_dt+"','-','') or a.rent_start_dt <= replace('"+be_dt+"','-','')) \n";
		if(mode.equals("c")) where2 = " and (a.rent_dt > replace('"+be_dt+"','-','') or a.rent_start_dt > replace('"+be_dt+"','-','')) \n";

		//정상계약
		query1 = " select '1' st, \n"+
				 "        a.cnt3 as c_cnt3, a.cnt4 as c_cnt4,  \n"+
				 "        a.*  \n"+
				 " from   stat_bus_cmp_base a  \n"+
				 " where  "+where+" "+where2+" and a.con_mon>=6 \n"+
				 " ";

		//6개월미만 계약, 실경과월 6개월 이상
		query2 = " select '2' st,  \n"+
				 "        decode(a.cnt3,'0',a.cnt1,a.cnt3) as c_cnt3, decode(a.cnt4,'0',a.cnt2,a.cnt4) as c_cnt4,  \n"+
				 "        a.*  \n"+
				 " from   stat_bus_cmp_base a  \n"+
				 " where  "+where+" "+where3+" and a.con_mon<6 and a.use_mon>=6  \n"+
				 "        and to_char(add_months(to_date(a.rent_start_dt,'YYYYMMDD'),6),'YYYYMMDD') between '"+cs_dt+"' and '"+ce_dt+"' \n" ;

		//6개월이상 계약, 실경과월 6개월 미만(해지)
		query3 = " select '3' st,  \n"+
				 "        '-'||decode(a.cnt3,'0',a.cnt1,a.cnt3) as c_cnt3, '-'||decode(a.cnt4,'0',a.cnt2,a.cnt4) as c_cnt4,  \n"+
				 "        a.*  \n"+
				 " from   stat_bus_cmp_base a  \n"+
				 " where  "+where+" "+where3+" and a.con_mon>=6 and a.use_mon<6 and nvl(a.cls_st,'0') not in ('8')\n"+
				 "        and a.cls_dt between '"+cs_dt+"' and '"+ce_dt+"'  \n" ;


		query =	" select \n"+
				"      a.*,  \n"+
				"      a.c_cnt3 as cc_cnt3,  \n"+
				"      a.c_cnt4 as cc_cnt4,  \n"+
				"      nvl(decode(a.c_cnt3,'0','',decode(bb.min_rent_dt, '',  a.c_cnt3/2, a.c_cnt3 ))*decode(a.car_gu||a.rent_st,'01',1.5,1),0) as rr_cnt3,  \n"+
				" 	   nvl(decode(a.c_cnt4,'0','',decode(cc.min_start_dt, '', a.c_cnt4/2, a.c_cnt4 ))*decode(a.car_gu||a.rent_st,'01',1.5,1),0) as rr_cnt4,  \n"+
				"      b.firm_nm, decode(a.bus_st,'1',d.user_nm) as bus_nm,  \n"+
				"	   decode(a.bus_st,'1',e.user_nm,'2',d.user_nm) as bus_agnt_nm,  \n"+
				"	   decode(a.bus_st,'1',g.user_nm,'3',d.user_nm) as bus_nm2,  \n"+
				"      decode(a.st,'3','해지',decode(a.rent_st,'1',decode(c.car_gu,'0','재리스',decode(c.rent_st,'1','신규','3','대차','4','증차')),'연장')) gubun,  \n"+
				"      decode(a.bus_st,'1','주','부') gubun2,  \n"+
				"      nvl(f.ext_agnt,c.bus_id) f_bus_id  \n"+
				" from  \n"+
				"      ( "+query1+" union all "+query2+" union all "+query3+" )  a,  \n\n"+
				"      ( select ssn, bus_id, min(st||decode(cls_st,'7','1','10','1','0')||rent_dt||car_gu||rent_st||rent_mng_id||rent_l_cd)       min_rent_dt  from ( "+query1+" union all "+query2+" union all "+query3+" ) where decode(st,'3',cnt1,cnt3)<>'0' and rent_dt is not null group by ssn, bus_id ) bb,  \n\n"+
				"      ( select ssn, bus_id, min(st||rent_start_dt||car_gu||rent_st||rent_mng_id||rent_l_cd) min_start_dt from ( "+query1+" union all "+query2+" union all "+query3+" ) where decode(st,'3',cnt2,cnt4)<>'0' and rent_start_dt is not null group by ssn, bus_id ) cc,  \n\n"+
				"	   client b, cont c, users d, users e, fee f, users g  \n"+
				" where  \n"+
				       where+
				"      and a.ssn=bb.ssn(+) and a.bus_id=bb.bus_id(+) and a.st||decode(a.cls_st,'7','1','10','1','0')||a.rent_dt||a.car_gu||a.rent_st||a.rent_mng_id||a.rent_l_cd=bb.min_rent_dt(+) \n"+
				" 	   and a.ssn=cc.ssn(+) and a.bus_id=cc.bus_id(+) and a.st||a.rent_start_dt||a.car_gu||a.rent_st||a.rent_mng_id||a.rent_l_cd=cc.min_start_dt(+) \n"+
				"      and a.client_id=b.client_id and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and a.bus_id=d.user_id(+) and a.bus_agnt_id=e.user_id(+) \n"+
				"	   and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd and a.rent_st=f.rent_st and a.bus_id2=g.user_id(+) \n"+
				" order by a.st, decode(a.cls_dt,'',0,1), a.cls_dt, b.firm_nm, a.rent_dt, a.rent_start_dt, a.rent_mng_id \n";
				


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
			System.out.println("[CampaignDatabase:getStatBusCmpBaseBusList]\n"+e);
			System.out.println("[CampaignDatabase:getStatBusCmpBaseBusList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}	

	/**
	 * 결과 :마감테이블 조회
	*/
	public Vector getCampaignSik(String save_dt, String loan_st, String enter_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query = " select b.dept_id, b.user_nm, b.user_id, b.loan_st, c.nm_cd, "+
						" a.SAVE_DT, a.SEQ, a.BUS_ID, "+
						" to_char(to_number(a.RENT_CNT),'999.999') RENT_CNT, to_char(to_number(a.START_CNT),'999.999') START_CNT, to_char(to_number(CNT1),'999.999') CNT1, "+
						" to_char(to_number(a.R_RENT_CNT),'999.999') R_RENT_CNT, to_char(to_number(a.R_START_CNT),'999.999') R_START_CNT, to_char(to_number(R_CNT),'999.999') R_CNT, a.DAY, "+
						" to_char(to_number(a.R_CNT2),'0.99999') R_CNT2, to_char(to_number(a.PRE_CMP),'0.99999') PRE_CMP, to_char(to_number(a.PRE_CMP_GA),'0.99999') PRE_CMP_GA,  "+
						" a.C_DAY, to_char(to_number(a.CMP_DISCNT_PER),'99.999') CMP_DISCNT_PER, "+
						" to_char(to_number(a.C_RENT_CNT),'999.999') C_RENT_CNT, to_char(to_number(a.C_START_CNT),'999.999') C_START_CNT, to_char(to_number(a.C_CNT),'999.999') C_CNT, "+
						" to_char(to_number(a.CR_RENT_CNT),'999.999') CR_RENT_CNT, to_char(to_number(a.CR_START_CNT),'999.999') CR_START_CNT, to_char(to_number(a.CR_CNT),'999.999') CR_CNT, "+
						" to_char(to_number(a.DALSUNG),'999.999') DALSUNG, to_char(to_number(a.AMT)) amt, a.AVG_DALSUNG, to_char(to_number(a.AMT2)) amt2,  "+
						" a.SUM_CNT1, a.SUM_R_CNT, a.SUM_BUS, a.AVG_CNT1, a.AVG_R_CNT, a.AVG_BUS, a.AVG_LOW_BUS,  "+
						" a.V_BS_DT, a.V_BE_DT, a.V_BS_DT2, a.V_BE_DT2, a.V_CS_DT, a.V_CE_DT, a.V_CAR_AMT,  "+
						" a.V_BUS_UP_PER, a.V_BUS_DOWN_PER, a.V_MNG_UP_PER, a.V_MNG_DOWN_PER, a.V_BUS_AMT_PER, a.V_MNG_AMT_PER, a.V_CNT1, a.V_MON, a.V_CNT2,  "+
						" a.V_CMP_DISCNT_PER, a.V_MAX_DALSUNG, a.V_BUS_GA, a.V_MNG_GA, a.V_BUS_NEW_GA, a.REG_DT, a.V_ENTER_DT, to_char(to_number(a.ORG_DALSUNG),'9999.99') ORG_DALSUNG,  "+
						" a.V_NM_CNT3, a.V_NE_DT3, a.V_NS_DT3, a.V_NB_CNT2, a.V_NM_CNT2, a.V_NE_DT2, a.V_NS_DT2, a.V_NB_CNT1, a.V_NM_CNT1, a.V_NE_DT1, a.V_NS_DT1, a.V_NB_CNT3, a.BUS_ST "+
			           " from stat_bus_cmp a, users b, (select * from code where c_st='0002') c where a.bus_id=b.user_id and b.dept_id=c.code and a.save_dt='"+save_dt+"'";


		if(loan_st.equals("")){//신입
			query += " and b.enter_dt >= '"+enter_dt+"'";
		}else{
			query += " and b.loan_st='"+loan_st+"' and b.enter_dt < '"+enter_dt+"'";
		}

		query += " order by to_number(a.org_dalsung) desc, a.seq";

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
			System.out.println("[CampaignDatabase:getCampaign(String save_dt, String loan_st, String s_dt, String e_dt)]"+e);
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


	//----------------------------------------------------------------------------------------------------------------------------------------
	//----------------------------------------------------------------------------------------------------------------------------------------
	//영업캠페인에 영업효율 추가 반영 :: 통합영업캠페인 (2009-04-01부터)----------------------------------------------------------------------
	//----------------------------------------------------------------------------------------------------------------------------------------
	//----------------------------------------------------------------------------------------------------------------------------------------

	/**
	 * 결과 :마감테이블 조회
	*/
	public Hashtable getCampaignCase_2009_04(String save_dt, String bus_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();

		String query =  " select b.dept_id, b.user_nm, b.user_id, b.loan_st, c.nm_cd, "+
						"		 a.SAVE_DT, a.SEQ, a.BUS_ID, "+
						"		 to_char(to_number(a.RENT_CNT),'999.99') RENT_CNT, to_char(to_number(a.START_CNT),'999.99') START_CNT, to_char(to_number(CNT1),'999.99') CNT1, "+
						"		 to_char(to_number(a.R_RENT_CNT),'999.99') R_RENT_CNT, to_char(to_number(a.R_START_CNT),'999.99') R_START_CNT, to_char(to_number(R_CNT),'999.99') R_CNT, a.DAY, "+
						"		 to_char(to_number(a.R_CNT2),'0.99999') R_CNT2, to_char(to_number(a.PRE_CMP),'0.99999') PRE_CMP, to_char(to_number(a.PRE_CMP_GA),'0.99999') PRE_CMP_GA,  "+
						"		 a.C_DAY, to_char(to_number(a.CMP_DISCNT_PER),'999.99') CMP_DISCNT_PER, "+
						"		 to_char(to_number(a.C_RENT_CNT),'999.99') C_RENT_CNT, to_char(to_number(a.C_START_CNT),'999.99') C_START_CNT, to_char(to_number(a.C_CNT),'999.99') C_CNT, "+
						"		 to_char(to_number(a.CR_RENT_CNT),'999.99') CR_RENT_CNT, to_char(to_number(a.CR_START_CNT),'999.99') CR_START_CNT, to_char(to_number(a.CR_CNT),'999.99') CR_CNT, "+
						"		 to_char(to_number(a.DALSUNG),'999.99') DALSUNG, to_char(to_number(a.AMT)) amt, a.AVG_DALSUNG, to_char(to_number(a.AMT2)) amt2,  "+
						"		 a.SUM_CNT1, a.SUM_R_CNT, a.SUM_BUS, "+
						"		 a.AVG_CNT1, a.AVG_R_CNT, to_char(to_number(a.AVG_BUS),'0.99999') AVG_BUS, to_char(to_number(a.AVG_LOW_BUS),'0.99999') AVG_LOW_BUS,  "+
						"		 a.V_BS_DT, a.V_BE_DT, a.V_BS_DT2, a.V_BE_DT2, a.V_CS_DT, a.V_CE_DT, a.V_CAR_AMT,  "+
						"		 a.V_BUS_UP_PER, a.V_BUS_DOWN_PER, a.V_MNG_UP_PER, a.V_MNG_DOWN_PER, a.V_BUS_AMT_PER, a.V_MNG_AMT_PER, a.V_CNT1, a.V_MON, a.V_CNT2,  "+
						"		 a.V_CMP_DISCNT_PER, a.V_MAX_DALSUNG, a.V_BUS_GA, a.V_MNG_GA, a.V_BUS_NEW_GA, a.REG_DT, a.V_ENTER_DT, to_char(to_number(a.ORG_DALSUNG),'999.99') ORG_DALSUNG,  "+
						"		 a.V_NM_CNT3, a.V_NE_DT3, a.V_NS_DT3, a.V_NB_CNT2, a.V_NM_CNT2, a.V_NE_DT2, a.V_NS_DT2, a.V_NB_CNT1, a.V_NM_CNT1, a.V_NE_DT1, a.V_NS_DT1, a.V_NB_CNT3, a.BUS_ST, "+
			            "		 a.DAY2, to_char(to_number(a.R_COST_CNT),'999.99') R_COST_CNT, to_char(to_number(a.C_COST_CNT),'999.99') C_COST_CNT, "+
						"		 to_char(to_number(a.R_CNT2_1),'0.99999') R_CNT2_1, to_char(to_number(a.R_CNT2_2),'0.99999') R_CNT2_2, "+
						"		 a.SUM_COST_CNT, a.SUM_BUS_1, a.SUM_BUS_2, "+
						"		 a.AVG_COST_CNT, to_char(to_number(a.AVG_BUS_1),'0.99999') AVG_BUS_1, to_char(to_number(a.AVG_BUS_2),'0.99999') AVG_BUS_2, "+
						"		 to_char(to_number(a.C_TOT_CNT),'999.99') C_TOT_CNT, a.V_CNT_PER, a.V_COST_PER, a.AVG_CAR_COST_1, a.AVG_CAR_COST_2	"+
			            " from   stat_bus_cmp a, users b, (select * from code where c_st='0002') c where a.bus_id=b.user_id and b.dept_id=c.code "+
						" and    a.save_dt='"+save_dt+"' and a.bus_id='"+bus_id+"'";


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next())
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
			System.out.println("[CampaignDatabase:getCampaignCase_2009_04(String save_dt, String bus_id)]"+e);
			System.out.println("[CampaignDatabase:getCampaignCase_2009_04(String save_dt, String bus_id)]"+query);
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
	 * 결과 :마감테이블 조회
	*/
	public Vector getCampaignSik_2009_04(String save_dt, String loan_st, String enter_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query = " select b.dept_id, b.user_nm, b.user_id, b.loan_st, c.nm_cd, "+
						" a.SAVE_DT, a.SEQ, a.BUS_ID, "+
						" to_char(to_number(a.RENT_CNT),'999.99') RENT_CNT, to_char(to_number(a.START_CNT),'999.99') START_CNT, to_char(to_number(CNT1),'999.99') CNT1, "+
						" to_char(to_number(a.R_RENT_CNT),'999.99') R_RENT_CNT, to_char(to_number(a.R_START_CNT),'999.99') R_START_CNT, to_char(to_number(R_CNT),'999.99') R_CNT, a.DAY, "+
						" to_char(to_number(a.R_CNT2),'0.99999') R_CNT2, to_char(to_number(a.PRE_CMP),'0.99999') PRE_CMP, to_char(to_number(a.PRE_CMP_GA),'0.99999') PRE_CMP_GA,  "+
						" a.C_DAY, to_char(to_number(a.CMP_DISCNT_PER),'999.99') CMP_DISCNT_PER, "+
						" to_char(to_number(a.C_RENT_CNT),'999.99') C_RENT_CNT, to_char(to_number(a.C_START_CNT),'999.99') C_START_CNT, to_char(to_number(a.C_CNT),'999.99') C_CNT, "+
						" to_char(to_number(a.CR_RENT_CNT),'999.99') CR_RENT_CNT, to_char(to_number(a.CR_START_CNT),'999.99') CR_START_CNT, to_char(to_number(a.CR_CNT),'999.99') CR_CNT, "+
						" to_char(to_number(a.DALSUNG),'999.99') DALSUNG, to_char(to_number(a.AMT)) amt, a.AVG_DALSUNG, to_char(to_number(a.AMT2)) amt2,  "+
						" a.SUM_CNT1, a.SUM_R_CNT, a.SUM_BUS, "+
						" a.AVG_CNT1, a.AVG_R_CNT, to_char(to_number(a.AVG_BUS),'0.99999') AVG_BUS, to_char(to_number(a.AVG_LOW_BUS),'0.99999') AVG_LOW_BUS,  "+
						" a.V_BS_DT, a.V_BE_DT, a.V_BS_DT2, a.V_BE_DT2, a.V_CS_DT, a.V_CE_DT, a.V_CAR_AMT,  "+
						" a.V_BUS_UP_PER, a.V_BUS_DOWN_PER, a.V_MNG_UP_PER, a.V_MNG_DOWN_PER, a.V_BUS_AMT_PER, a.V_MNG_AMT_PER, a.V_CNT1, a.V_MON, a.V_CNT2,  "+
						" a.V_CMP_DISCNT_PER, a.V_MAX_DALSUNG, a.V_BUS_GA, a.V_MNG_GA, a.V_BUS_NEW_GA, a.REG_DT, a.V_ENTER_DT, to_char(to_number(a.ORG_DALSUNG),'9999.99') ORG_DALSUNG,  "+
						" a.V_NM_CNT3, a.V_NE_DT3, a.V_NS_DT3, a.V_NB_CNT2, a.V_NM_CNT2, a.V_NE_DT2, a.V_NS_DT2, a.V_NB_CNT1, a.V_NM_CNT1, a.V_NE_DT1, a.V_NS_DT1, a.V_NB_CNT3, a.BUS_ST, "+
			            " a.DAY2, to_char(to_number(a.R_COST_CNT),'999.99') R_COST_CNT, to_char(to_number(a.C_COST_CNT),'999.99') C_COST_CNT, "+
						" to_char(to_number(a.R_CNT2_1),'0.99999') R_CNT2_1, to_char(to_number(a.R_CNT2_2),'0.99999') R_CNT2_2, "+
						" a.SUM_COST_CNT, a.SUM_BUS_1, a.SUM_BUS_2, "+
						" a.AVG_COST_CNT, to_char(to_number(a.AVG_BUS_1),'0.99999') AVG_BUS_1, to_char(to_number(a.AVG_BUS_2),'0.99999') AVG_BUS_2, "+
						" to_char(to_number(a.C_TOT_CNT),'999.99') C_TOT_CNT, a.V_CNT_PER, a.V_COST_PER, a.AVG_CAR_COST_1, a.AVG_CAR_COST_2	"+
			           " from stat_bus_cmp a, users b, (select * from code where c_st='0002') c where a.bus_id=b.user_id and b.dept_id=c.code and a.save_dt='"+save_dt+"'";


		if(loan_st.equals("")){//신입
			query += " and b.enter_dt >= '"+enter_dt+"'";
		}else{
			query += " and b.loan_st='"+loan_st+"' and b.enter_dt < '"+enter_dt+"'";
		}

		query += " order by to_number(a.org_dalsung) desc, a.seq";

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
			System.out.println("[CampaignDatabase:getCampaignSik_2009_04(String save_dt, String loan_st, String enter_dt)]"+e);
			System.out.println("[CampaignDatabase:getCampaignSik_2009_04(String save_dt, String loan_st, String enter_dt)]"+query);
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
	 * 결과 :마감테이블 조회 - 1군
	*/
	public Vector getCampaignList_2009_04(String save_dt, String loan_st, String ns_dt, String ne_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query =  " select b.dept_id, b.user_nm, b.user_id, b.loan_st, decode(b.loan_st,'1','1군','2','2군') loan_st_nm, b.enter_dt, c.nm_cd, "+
						" a.SAVE_DT, a.SEQ, a.BUS_ID, a.RENT_CNT, a.START_CNT, a.CNT1, a.R_RENT_CNT, a.R_START_CNT, a.R_CNT, a.DAY, a.R_CNT2, a.PRE_CMP, a.PRE_CMP_GA,  "+
						" a.C_DAY, "+
						" a.C_RENT_CNT, a.C_START_CNT, "+
						" a.CR_RENT_CNT, a.CR_START_CNT, "+
						" a.SUM_CNT1, a.SUM_R_CNT, a.SUM_BUS, a.AVG_CNT1, a.AVG_R_CNT, a.AVG_BUS, a.AVG_LOW_BUS,  "+
						" a.V_BS_DT, a.V_BE_DT, a.V_BS_DT2, a.V_BE_DT2, a.V_CS_DT, a.V_CE_DT, a.V_CAR_AMT,  "+
						" a.V_BUS_UP_PER, a.V_BUS_DOWN_PER, a.V_MNG_UP_PER, a.V_MNG_DOWN_PER, a.V_BUS_AMT_PER, a.V_MNG_AMT_PER, a.V_CNT1, a.V_MON, a.V_CNT2,  "+
						" to_char(to_number(a.C_CNT),decode(sign(1-to_number(a.C_CNT)),-1,'999.99','0.99')) C_CNT, "+
						" to_char(to_number(a.CR_CNT),decode(sign(1-to_number(a.CR_CNT)),-1,'999.99','0.99')) CR_CNT, "+
						" to_char(to_number(a.DALSUNG),decode(sign(1-to_number(a.DALSUNG)),-1,'999.99','0.99')) DALSUNG, "+
						" to_char(to_number(a.CMP_DISCNT_PER),decode(sign(1-to_number(a.CMP_DISCNT_PER)),-1,'999.99','0.99')) CMP_DISCNT_PER, "+
						" to_char(to_number(a.ORG_DALSUNG),'999.99') ORG_DALSUNG,  "+
						" to_char(to_number(a.C_COST_CNT),decode(sign(1-to_number(a.C_COST_CNT)),-1,'999.99','0.99')) C_COST_CNT, "+
						" to_char(to_number(a.AMT)) amt, a.AVG_DALSUNG, to_char(to_number(a.AMT2)) amt2,  "+
						" a.V_CMP_DISCNT_PER, a.V_MAX_DALSUNG, a.V_BUS_GA, a.V_MNG_GA, a.V_BUS_NEW_GA, a.REG_DT, a.V_ENTER_DT, "+
						" a.V_NM_CNT3, a.V_NE_DT3, a.V_NS_DT3, a.V_NB_CNT2, a.V_NM_CNT2, a.V_NE_DT2, a.V_NS_DT2, a.V_NB_CNT1, a.V_NM_CNT1, a.V_NE_DT1, a.V_NS_DT1, a.V_NB_CNT3, a.BUS_ST, "+
			            " a.DAY2, a.R_COST_CNT, "+
						" a.C_COST_CNT as org_C_COST_CNT, "+
						" a.R_CNT2_1, a.R_CNT2_2, "+
						" a.SUM_COST_CNT, a.SUM_BUS_1, a.SUM_BUS_2, "+
						" a.AVG_COST_CNT, a.AVG_BUS_1, a.AVG_BUS_2, "+
						" to_char(to_number(a.C_TOT_CNT),decode(sign(1-to_number(a.C_TOT_CNT)),-1,'999.99','0.99')) C_TOT_CNT, "+
						" a.V_CNT_PER, a.V_COST_PER, a.AVG_CAR_COST_1, a.AVG_CAR_COST_2, a.cost_cnt1, a.cost_cnt2"+
						" from "+
						" ("+
						"		select * from stat_bus_cmp where save_dt='"+save_dt+"'"+
						" ) a, "+
						" users b, (select * from code where c_st='0002') c "+
						" where a.bus_id=b.user_id and b.dept_id=c.code  ";

		query += " and a.cnt1>0";

		if(!loan_st.equals("") && ns_dt.equals(""))		query += " and sysdate-to_date(b.enter_dt,'YYYYMMDD') >= 365 and b.loan_st='"+loan_st+"'";

		if(loan_st.equals("") && !ns_dt.equals(""))		query += " and b.enter_dt between '"+ns_dt+"' and '"+ne_dt+"'";


		query += " order by to_number(a.org_dalsung) desc, to_number(a.C_TOT_CNT) desc, to_number(a.CMP_DISCNT_PER) desc, b.enter_dt, b.user_id";

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
			System.out.println("[CampaignDatabase:getCampaignList_2009_04(String save_dt, String loan_st, String ns_dt, String ne_dt)]"+e);
			System.out.println("[CampaignDatabase:getCampaignList_2009_04(String save_dt, String loan_st, String ns_dt, String ne_dt)]"+query);
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
	 * 결과 :마감테이블 조회 - 1군(관리)
	*/
	public Vector getCampaignList_2009_06_sc2(String save_dt, String loan_st, String ns_dt, String ne_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query =  " select b.dept_id, b.user_nm, b.user_id, b.loan_st, decode(b.loan_st,'1','1군','2','2군') loan_st_nm, b.enter_dt, c.nm_cd, "+
						" a.SAVE_DT, a.SEQ, a.BUS_ID, a.RENT_CNT, a.START_CNT, a.CNT1, a.R_RENT_CNT, a.R_START_CNT, a.R_CNT, a.DAY, a.R_CNT2, a.PRE_CMP, a.PRE_CMP_GA,  "+
						" a.C_DAY, "+
						" a.C_RENT_CNT, a.C_START_CNT, "+
						" a.CR_RENT_CNT, a.CR_START_CNT, "+
						" a.SUM_CNT1, a.SUM_R_CNT, a.SUM_BUS, a.AVG_CNT1, a.AVG_R_CNT, a.AVG_BUS, a.AVG_LOW_BUS,  "+
						" a.V_BS_DT, a.V_BE_DT, a.V_BS_DT2, a.V_BE_DT2, a.V_CS_DT, a.V_CE_DT, a.V_CAR_AMT, a.V_CAR_AMT2,  "+
						" a.V_BUS_UP_PER, a.V_BUS_DOWN_PER, a.V_MNG_UP_PER, a.V_MNG_DOWN_PER, a.V_BUS_AMT_PER, a.V_MNG_AMT_PER, a.V_CNT1, a.V_MON, a.V_CNT2,  "+
						" to_char(to_number(a.C_CNT),decode(sign(1-to_number(a.C_CNT)),-1,'999.99','0.99')) C_CNT, "+
						" to_char(to_number(a.CR_CNT),decode(sign(1-to_number(a.CR_CNT)),-1,'999.99','0.99')) CR_CNT, "+
						" case when DALSUNG=0 then '0.00' when DALSUNG <0 then to_char(DALSUNG,'99.99') else to_char(DALSUNG,'999.99') end DALSUNG, "+
						" to_char(to_number(a.CMP_DISCNT_PER),decode(sign(1-to_number(a.CMP_DISCNT_PER)),-1,'999.99','0.99')) CMP_DISCNT_PER, "+
						" to_char(to_number(a.ORG_DALSUNG),'999.99') ORG_DALSUNG,  "+
						" to_char(to_number(a.C_COST_CNT),decode(sign(1-to_number(a.C_COST_CNT)),-1,'999.99','0.99')) C_COST_CNT, "+
						" to_char(to_number(a.AMT)) amt, a.AVG_DALSUNG, to_char(to_number(a.AMT2)) amt2,  "+
						" a.V_CMP_DISCNT_PER, a.V_MAX_DALSUNG, a.V_BUS_GA, a.V_MNG_GA, a.V_BUS_NEW_GA, a.REG_DT, a.V_ENTER_DT, "+
						" a.V_NM_CNT3, a.V_NE_DT3, a.V_NS_DT3, a.V_NB_CNT2, a.V_NM_CNT2, a.V_NE_DT2, a.V_NS_DT2, a.V_NB_CNT1, a.V_NM_CNT1, a.V_NE_DT1, a.V_NS_DT1, a.V_NB_CNT3, a.BUS_ST, "+
			            " a.DAY2, a.R_COST_CNT, "+
						" a.C_COST_CNT as org_C_COST_CNT, "+
						" a.R_CNT2_1, a.R_CNT2_2, "+
						" a.SUM_COST_CNT, a.SUM_BUS_1, a.SUM_BUS_2, "+
						" a.AVG_COST_CNT, a.AVG_BUS_1, a.AVG_BUS_2, "+
						" to_char(to_number(a.C_TOT_CNT),decode(sign(1-to_number(a.C_TOT_CNT)),-1,'999.99','0.99')) C_TOT_CNT, "+
						" a.V_CNT_PER, a.V_COST_PER, a.AVG_CAR_COST_1, a.AVG_CAR_COST_2, a.cost_cnt1, a.cost_cnt2"+
						" from "+
						" ("+
						"		select * from stat_bus_cmp where save_dt='"+save_dt+"'"+
						" ) a, "+
						" users b, (select * from code where c_st='0002') c "+
						" where a.bus_id=b.user_id and b.dept_id=c.code and b.loan_st = '1' ";

		query += " and a.cnt1>0";

		if(!loan_st.equals("") && ns_dt.equals(""))		query += " and sysdate-to_date(b.enter_dt,'YYYYMMDD') >= 365 and b.loan_st='"+loan_st+"'";

		if(loan_st.equals("") && !ns_dt.equals(""))		query += " and b.enter_dt between '"+ns_dt+"' and '"+ne_dt+"'";


		query += " order by to_number(a.org_dalsung) desc, to_number(a.C_TOT_CNT) desc, to_number(a.CMP_DISCNT_PER) desc, b.enter_dt, b.user_id";

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
			System.out.println("[CampaignDatabase:getCampaignList_2009_04(String save_dt, String loan_st, String ns_dt, String ne_dt)]"+e);
			System.out.println("[CampaignDatabase:getCampaignList_2009_04(String save_dt, String loan_st, String ns_dt, String ne_dt)]"+query);
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
	 * 결과 :마감테이블 조회 - 2군(영업)
	*/
	public Vector getCampaignList_2009_06_sc3(String save_dt, String loan_st, String ns_dt, String ne_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query =  " select b.dept_id, b.user_nm, b.user_id, b.loan_st, decode(b.loan_st,'1','1군','2','2군') loan_st_nm, b.enter_dt, c.nm_cd, "+
						" a.SAVE_DT, a.SEQ, a.BUS_ID, a.RENT_CNT, a.START_CNT, a.CNT1, a.R_RENT_CNT, a.R_START_CNT, a.R_CNT, a.DAY, a.R_CNT2, a.PRE_CMP, a.PRE_CMP_GA,  "+
						" a.C_DAY, "+
						" a.C_RENT_CNT, a.C_START_CNT, "+
						" a.CR_RENT_CNT, a.CR_START_CNT, "+
						" a.SUM_CNT1, a.SUM_R_CNT, a.SUM_BUS, a.AVG_CNT1, a.AVG_R_CNT, a.AVG_BUS, a.AVG_LOW_BUS,  "+
						" a.V_BS_DT, a.V_BE_DT, a.V_BS_DT2, a.V_BE_DT2, a.V_CS_DT, a.V_CE_DT, a.V_CAR_AMT, a.V_CAR_AMT2,  "+
						" a.V_BUS_UP_PER, a.V_BUS_DOWN_PER, a.V_MNG_UP_PER, a.V_MNG_DOWN_PER, a.V_BUS_AMT_PER, a.V_MNG_AMT_PER, a.V_CNT1, a.V_MON, a.V_CNT2,  "+
						" to_char(to_number(a.C_CNT),decode(sign(1-to_number(a.C_CNT)),-1,'999.99','0.99')) C_CNT, "+
						" to_char(to_number(a.CR_CNT),decode(sign(1-to_number(a.CR_CNT)),-1,'999.99','0.99')) CR_CNT, "+
						" to_char(to_number(a.DALSUNG),decode(sign(1-to_number(a.DALSUNG)),-1,'999.99','0.99')) DALSUNG, "+
						" to_char(to_number(a.CMP_DISCNT_PER),decode(sign(1-to_number(a.CMP_DISCNT_PER)),-1,'999.99','0.99')) CMP_DISCNT_PER, "+
						" to_char(to_number(a.ORG_DALSUNG),'999.99') ORG_DALSUNG,  "+
						" to_char(to_number(a.C_COST_CNT),decode(sign(1-to_number(a.C_COST_CNT)),-1,'999.99','0.99')) C_COST_CNT, "+
						" to_char(to_number(a.AMT)) amt, a.AVG_DALSUNG, to_char(to_number(a.AMT2)) amt2,  "+
						" a.V_CMP_DISCNT_PER, a.V_MAX_DALSUNG, a.V_BUS_GA, a.V_MNG_GA, a.V_BUS_NEW_GA, a.REG_DT, a.V_ENTER_DT, "+
						" a.V_NM_CNT3, a.V_NE_DT3, a.V_NS_DT3, a.V_NB_CNT2, a.V_NM_CNT2, a.V_NE_DT2, a.V_NS_DT2, a.V_NB_CNT1, a.V_NM_CNT1, a.V_NE_DT1, a.V_NS_DT1, a.V_NB_CNT3, a.BUS_ST, "+
			            " a.DAY2, a.R_COST_CNT, "+
						" a.C_COST_CNT as org_C_COST_CNT, "+
						" a.R_CNT2_1, a.R_CNT2_2, "+
						" a.SUM_COST_CNT, a.SUM_BUS_1, a.SUM_BUS_2, "+
						" a.AVG_COST_CNT, a.AVG_BUS_1, a.AVG_BUS_2, "+
						" to_char(to_number(a.C_TOT_CNT),decode(sign(1-to_number(a.C_TOT_CNT)),-1,'999.99','0.99')) C_TOT_CNT, "+
						" a.V_CNT_PER, a.V_COST_PER, a.AVG_CAR_COST_1, a.AVG_CAR_COST_2, a.cost_cnt1, a.cost_cnt2"+
						" from "+
						" ("+
						"		select * from stat_bus_cmp where save_dt='"+save_dt+"'"+
						" ) a, "+
						" users b, (select * from code where c_st='0002') c "+
						" where a.bus_id=b.user_id and b.dept_id=c.code and b.loan_st = '2' ";

		query += " and a.cnt1>0";

		if(!loan_st.equals("") && ns_dt.equals(""))		query += " and sysdate-to_date(b.enter_dt,'YYYYMMDD') >= 365 and b.loan_st='"+loan_st+"'";

		if(loan_st.equals("") && !ns_dt.equals(""))		query += " and b.enter_dt between '"+ns_dt+"' and '"+ne_dt+"'";


		query += " order by to_number(a.org_dalsung) desc, to_number(a.C_TOT_CNT) desc, to_number(a.CMP_DISCNT_PER) desc, b.enter_dt, b.user_id";

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
			System.out.println("[CampaignDatabase:getCampaignList_2009_04(String save_dt, String loan_st, String ns_dt, String ne_dt)]"+e);
			System.out.println("[CampaignDatabase:getCampaignList_2009_04(String save_dt, String loan_st, String ns_dt, String ne_dt)]"+query);
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
	 * 영업실적 마감 데이타 조회
	 */
	public Vector getStatBusCmpAccountData_2009_04(Hashtable var, String mode)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";
		String sub_query_cost_b = "";
		String sub_query_cost_c = "";
		String sub_query_car_cost = "";

		String cs_dt 		= String.valueOf(var.get("CS_DT"));
		String ce_dt 		= String.valueOf(var.get("CE_DT"));
		String bs_dt 		= String.valueOf(var.get("BS_DT"));
		String be_dt 		= String.valueOf(var.get("BE_DT"));
		String bs_dt2 		= String.valueOf(var.get("BS_DT2"));
		String be_dt2 		= String.valueOf(var.get("BE_DT2"));
		String enter_dt		= String.valueOf(var.get("ENTER_DT"));
		String bus_up_per 	= String.valueOf(var.get("BUS_UP_PER"));
		String bus_down_per = String.valueOf(var.get("BUS_DOWN_PER"));
		String mng_up_per 	= String.valueOf(var.get("MNG_UP_PER"));
		String mng_down_per = String.valueOf(var.get("MNG_DOWN_PER"));
		String ns_dt1		= String.valueOf(var.get("NS_DT1"));
		String ns_dt2		= String.valueOf(var.get("NS_DT2"));
		String ns_dt3		= String.valueOf(var.get("NS_DT3"));
		String ns_dt4		= String.valueOf(var.get("NS_DT4"));
		String ne_dt1		= String.valueOf(var.get("NE_DT1"));
		String ne_dt2		= String.valueOf(var.get("NE_DT2"));
		String ne_dt3		= String.valueOf(var.get("NE_DT3"));
		String ne_dt4		= String.valueOf(var.get("NE_DT4"));
		String nm_cnt1		= String.valueOf(var.get("NM_CNT1"));
		String nm_cnt2		= String.valueOf(var.get("NM_CNT2"));
		String nm_cnt3		= String.valueOf(var.get("NM_CNT3"));
		String nm_cnt4		= String.valueOf(var.get("NM_CNT4"));
		String nb_cnt1		= String.valueOf(var.get("NB_CNT1"));
		String nb_cnt2		= String.valueOf(var.get("NB_CNT2"));
		String nb_cnt3		= String.valueOf(var.get("NB_CNT3"));
		String nb_cnt4		= String.valueOf(var.get("NB_CNT4"));
		String cnt_per		= String.valueOf(var.get("CNT_PER"));
		String cost_per		= String.valueOf(var.get("COST_PER"));

		//영업효율기본정보
		sub_query_cost_b = getCmpCostBaseQuery(mode, "b", bs_dt, be_dt, cs_dt, ce_dt, enter_dt);
		sub_query_cost_c = getCmpCostBaseQuery(mode, "c", bs_dt, be_dt, cs_dt, ce_dt, enter_dt);

		//기준실적-계약
		sub_query = " select \n"+
					"       f.enter_dt, f.loan_st, f.dept_id, f.user_nm, decode(sign(f.enter_dt-replace('"+enter_dt+"','-','')),-1,'','신입') enter_st, a.bus_id, \n"+
					"		nvl(b.cnt1,0)   as 계약1,     nvl(c.cnt2,0)   as 개시1,     trunc((nvl(b.cnt1,0)+nvl(c.cnt2,0))/2,2)     as 합계1,     \n"+
					"		nvl(b.r_cnt1,0) as 유효계약1, nvl(c.r_cnt2,0) as 유효개시1, trunc((nvl(b.r_cnt1,0)+nvl(c.r_cnt2,0))/2,2) as 유효합계1, \n"+
					"		nvl(d.cnt3,0)   as 계약2,     nvl(e.cnt4,0)   as 개시2,     trunc((nvl(d.cnt3,0)+nvl(e.cnt4,0))/2,2)     as 합계2,     \n"+
					"		nvl(d.r_cnt3,0) as 유효계약2, nvl(e.r_cnt4,0) as 유효개시2, trunc((nvl(d.r_cnt3,0)+nvl(e.r_cnt4,0))/2,2) as 유효합계2, \n"+
					"		a.b_day as 총일수1, a.b_day 총일수2, a.c_day as 경과일수,  \n"+
					"		nvl(g.cost_cnt,0) 영업대수1, nvl(g.cost_amt,0) 영업효율1, \n"+
					"		nvl(h.cost_cnt,0) 영업대수2, nvl(h.cost_amt,0) 영업효율2 \n"+
					" from \n"+
					"		( select bus_id, (to_date(replace('"+be_dt+"','-',''),'YYYYMMDD')-to_date(replace('"+bs_dt+"','-',''),'YYYYMMDD')+1) b_day, (to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(replace('"+cs_dt+"','-',''),'YYYYMMDD')+1) c_day from stat_bus_cmp_base where bs_dt=replace('"+bs_dt+"','-','') and ce_dt=replace('"+ce_dt+"','-','') group by bus_id) a, \n"+
					"		( select bus_id, sum(cnt1) cnt1, sum(r_cnt1) r_cnt1 from ( select ssn, bus_id, sum(to_number(cnt1)) cnt1, sum(decode(sign(10-to_number(r_cnt1)),-1,10,to_number(r_cnt1))) r_cnt1 from ( "+getCmpBaseQuery("1", bs_dt, be_dt, cs_dt, ce_dt)+" ) group by ssn, bus_id ) group by bus_id ) b, \n"+
					"		( select bus_id, sum(cnt2) cnt2, sum(r_cnt2) r_cnt2 from ( select ssn, bus_id, sum(to_number(cnt2)) cnt2, sum(decode(sign(10-to_number(r_cnt2)),-1,10,to_number(r_cnt2))) r_cnt2 from ( "+getCmpBaseQuery("2", bs_dt, be_dt, cs_dt, ce_dt)+" ) group by ssn, bus_id ) group by bus_id ) c, \n"+
					"		( select bus_id, sum(cnt3) cnt3, sum(r_cnt3) r_cnt3 from ( select ssn, bus_id, sum(to_number(cnt3)) cnt3, sum(decode(sign(10-to_number(r_cnt3)),-1,10,to_number(r_cnt3))) r_cnt3 from ( "+getCmpBaseQuery("3", bs_dt, be_dt, cs_dt, ce_dt)+" ) group by ssn, bus_id ) group by bus_id ) d, \n"+
					"		( select bus_id, sum(cnt4) cnt4, sum(r_cnt4) r_cnt4 from ( select ssn, bus_id, sum(to_number(cnt4)) cnt4, sum(decode(sign(10-to_number(r_cnt4)),-1,10,to_number(r_cnt4))) r_cnt4 from ( "+getCmpBaseQuery("4", bs_dt, be_dt, cs_dt, ce_dt)+" ) group by ssn, bus_id ) group by bus_id ) e, \n"+
					"		( select bus_id, cost_cnt, cost_amt from ( "+sub_query_cost_b+" )  ) g, \n"+
					"		( select bus_id, cost_cnt, cost_amt from ( "+sub_query_cost_c+" )  ) h, \n"+
					"		users f \n"+
					" where  \n"+
					"		a.bus_id=b.bus_id(+) and a.bus_id=c.bus_id(+) and a.bus_id=d.bus_id(+) and a.bus_id=e.bus_id(+) \n"+
					"		and a.bus_id=g.bus_id(+) and a.bus_id=h.bus_id(+) \n"+
					"		and a.bus_id=f.user_id and f.loan_st in ('1','2') and nvl(f.out_dt,'99999999')>='"+ce_dt+"'  \n"+
					" ";


		if(mode.equals("")){//기존직원

			sub_query += " and f.enter_dt <= '"+enter_dt+"' \n";

			sub_query_car_cost=	"    select loan_st,  \n"+
								"			trunc(sum(영업효율1)/sum(영업대수1),0) 부서대당영업효율1, \n"+
								"			trunc(sum(영업효율2)/sum(영업대수2),0) 부서대당영업효율2  \n"+
								"      from ( "+sub_query+" ) "+
								"	   group by loan_st ";

			query = 	"  select a.*,  \n"+
					    "         trunc(a.영업효율1/b.부서대당영업효율1,5) 평가기준효율실적, \n"+
						"         trunc(a.유효합계1/a.총일수1,5) 일평균1,  \n"+
					    "         trunc(a.영업효율1/b.부서대당영업효율1/a.총일수2,5) 일평균2, \n"+
						"         trunc(trunc(a.유효합계1/a.총일수1*"+cnt_per+"/100,5)+trunc(a.영업효율1/b.부서대당영업효율1/a.총일수2*"+cost_per+"/100,5),5) 일평균, \n"+
						"		  trunc(a.유효합계2,2) 캠페인대수실적,  \n"+
						"         trunc(a.영업효율2/b.부서대당영업효율2,6) 캠페인효율실적,  \n"+
						"         trunc(trunc(a.유효합계2*"+cnt_per+"/100,2)+trunc(a.영업효율2/b.부서대당영업효율2*"+cost_per+"/100,2),6) 캠페인유효실적, \n"+
						"         b.부서대당영업효율1, b.부서대당영업효율2, \n"+
						"         b.부서소계합계1, b.부서소계유효합계1, b.부서소계영업실적1, b.부서소계일평균1, b.부서소계일평균2, b.부서소계일평균,  \n"+
						"         b.부서평균합계1, b.부서평균유효합계1, b.부서평균영업실적1, b.부서평균일평균1, b.부서평균일평균2, b.부서평균일평균,  \n"+
						"         b.부서최저할인치 \n"+
						"  from  \n"+
						"         ( "+sub_query+" ) a,  \n"+
						"         ( select b1.loan_st, min(b2.부서대당영업효율1) 부서대당영업효율1, min(b2.부서대당영업효율2) 부서대당영업효율2, \n"+
						"			       sum(b1.합계1)														부서소계합계1,		\n"+
						"			       sum(b1.유효합계1)													부서소계유효합계1,  \n"+
						"			       sum(trunc(b1.영업효율1/b2.부서대당영업효율1,2))						부서소계영업실적1,  \n"+
						"                  sum(trunc(b1.유효합계1/b1.총일수1,5))								부서소계일평균1,	\n"+
						"                  sum(trunc(trunc(b1.영업효율1/b2.부서대당영업효율1,2)/b1.총일수2,5))	부서소계일평균2, \n"+
						"                  sum(trunc((trunc(b1.유효합계1/b1.총일수1*"+cnt_per+"/100,5)+trunc(trunc(b1.영업효율1/b2.부서대당영업효율1,2)/b1.총일수2*"+cost_per+"/100,5)),5)) 부서소계일평균, \n"+
						"                  trunc(avg(b1.합계1),2)												부서평균합계1,		\n"+
						"		           trunc(avg(b1.유효합계1),2)											부서평균유효합계1,  \n"+
						"		           trunc(avg(trunc(b1.영업효율1/b2.부서대당영업효율1,2)),2)				부서평균영업실적1,  \n"+
						"                  trunc(avg(trunc(b1.유효합계1/b1.총일수1,5)),5)						부서평균일평균1,  \n"+
						"                  trunc(avg(trunc(trunc(b1.영업효율1/b2.부서대당영업효율1,2)/b1.총일수2,5)),5) 부서평균일평균2, \n"+
						"                  trunc(avg((trunc(b1.유효합계1/b1.총일수1*"+cnt_per+"/100,5)+trunc(trunc(b1.영업효율1/b2.부서대당영업효율1,2)/b1.총일수2*"+cost_per+"/100,5))),5) 부서평균일평균, \n"+
						"                  trunc(avg((trunc(b1.유효합계1/b1.총일수1*"+cnt_per+"/100,5)+trunc(trunc(b1.영업효율1/b2.부서대당영업효율1,2)/b1.총일수2*"+cost_per+"/100,5)))*decode(b1.loan_st,'1',"+mng_down_per+"/100,"+bus_down_per+"/100),5) 부서최저할인치  \n"+
						"           from   ( "+sub_query+" ) b1, ( "+sub_query_car_cost+" ) b2"+
						"	        where  b1.loan_st=b2.loan_st \n"+
						"	        group by b1.loan_st \n"+
						"         ) b \n"+
						"  where  a.loan_st=b.loan_st(+) \n";




		}else{

			String ns_dt	= "";
			String ne_dt	= "";
			String nm_cnt	= "";
			String nb_cnt	= "";

			if(mode.equals("1")){//신입1
				ns_dt	= ns_dt1;   
				ne_dt	= ne_dt1;   
				nm_cnt	= nm_cnt1;  
				nb_cnt	= nb_cnt1;  
			}else if(mode.equals("2")){//신입2
				ns_dt	= ns_dt2;   
				ne_dt	= ne_dt2;   
				nm_cnt	= nm_cnt2;  
				nb_cnt	= nb_cnt2;  
			}else if(mode.equals("3")){//신입3
				ns_dt	= ns_dt3;   
				ne_dt	= ne_dt3;   
				nm_cnt	= nm_cnt3;  
				nb_cnt	= nb_cnt3;  
			}else if(mode.equals("4")){//신입4
				ns_dt	= ns_dt4;   
				ne_dt	= ne_dt4;   
				nm_cnt	= nm_cnt4;  
				nb_cnt	= nb_cnt4;  
			}
			
			sub_query += " and f.enter_dt between '"+ns_dt+"' and '"+ne_dt+"' \n";

			sub_query_car_cost=	"    select loan_st,  \n"+
								"			trunc(sum(영업효율1)/sum(영업대수1),0) 부서대당영업효율1, \n"+
								"			trunc(sum(영업효율2)/sum(영업대수2),0) 부서대당영업효율2  \n"+
								"      from ( "+sub_query+" ) "+
								"	   group by loan_st ";

			query =		"  select "+
						"         a.enter_dt, a.loan_st, a.dept_id, a.user_nm, a.enter_st, a.bus_id,  \n"+
						"	      decode(a.loan_st,'1','"+nm_cnt+"', '"+nb_cnt+"') 계약1,  \n"+
						"	      decode(a.loan_st,'1','"+nm_cnt+"', '"+nb_cnt+"') 개시1,  \n"+
						"	      decode(a.loan_st,'1','"+nm_cnt+"', '"+nb_cnt+"') 합계1,  \n"+
						"	      decode(a.loan_st,'1','"+nm_cnt+"', '"+nb_cnt+"') 유효계약1,  \n"+
						"	      decode(a.loan_st,'1','"+nm_cnt+"', '"+nb_cnt+"') 유효개시1,  \n"+
						"	      decode(a.loan_st,'1','"+nm_cnt+"', '"+nb_cnt+"') 유효합계1,  \n"+
						"	      decode(a.loan_st,'1','"+nm_cnt+"', '"+nb_cnt+"') 영업효율실적1,  \n"+
						"         trunc(((decode(a.loan_st,'1',"+nm_cnt+", "+nb_cnt+")/a.총일수1)+(decode(a.loan_st,'1',"+nm_cnt+", "+nb_cnt+")/a.총일수2))/2,5) 일평균,  \n"+
						"         trunc((decode(a.loan_st,'1',"+nm_cnt+", "+nb_cnt+")/a.총일수1),5) 일평균1,  \n"+
						"         trunc((decode(a.loan_st,'1',"+nm_cnt+", "+nb_cnt+")/a.총일수2),5) 일평균2,  \n"+
						"         a.총일수1, a.총일수2, a.경과일수, a.계약2, a.개시2, a.합계2, a.유효계약2, a.유효개시2, a.유효합계2, \n"+
						"		  trunc(a.유효합계2,2) 캠페인대수실적,  \n"+
						"         trunc(a.영업효율2/b.부서대당영업효율2,6) 캠페인효율실적,  \n"+
						"         trunc(trunc(a.유효합계2*"+cnt_per+"/100,2)+trunc(a.영업효율2/b.부서대당영업효율2*"+cost_per+"/100,2),6) 캠페인유효실적, \n"+
						"         '' 부서소계합계1, '' 부서소계유효합계1, '' 부서소계일평균1, '' 부서소계일평균2, '' 부서소계일평균,  \n"+
						"         '' 부서평균합계1, '' 부서평균유효합계1, '' 부서평균일평균1, '' 부서평균일평균2, '' 부서평균일평균, '' 부서최저할인치,  \n"+
						"   from  \n"+
						"        ( "+sub_query+" ) a, \n"+
						"        ( "+sub_query_car_cost+" ) b\n"+
						"   where  a.loan_st=b.loan_st \n"+
						"  ";

		}

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
			System.out.println("[CampaignDatabase:getStatBusCmpAccountData_2009_04]\n"+e);
			System.out.println("[CampaignDatabase:getStatBusCmpAccountData_2009_04]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 * 영업실적 마감 데이타 조회
	 */
	public Vector getStatBusCmpAccountData_2009_06(Hashtable var, String mode)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";
		String sub_query_cost_b = "";
		String sub_query_cost_c = "";
		String sub_query_car_cost = "";

		String cs_dt 		= String.valueOf(var.get("CS_DT"));
		String ce_dt 		= String.valueOf(var.get("CE_DT"));
		String bs_dt 		= String.valueOf(var.get("BS_DT"));
		String be_dt 		= String.valueOf(var.get("BE_DT"));
		String bs_dt2 		= String.valueOf(var.get("BS_DT2"));
		String be_dt2 		= String.valueOf(var.get("BE_DT2"));
		String enter_dt		= String.valueOf(var.get("ENTER_DT"));
		String bus_up_per 	= String.valueOf(var.get("BUS_UP_PER"));
		String bus_down_per = String.valueOf(var.get("BUS_DOWN_PER"));
		String mng_up_per 	= String.valueOf(var.get("MNG_UP_PER"));
		String mng_down_per = String.valueOf(var.get("MNG_DOWN_PER"));
		String ns_dt1		= String.valueOf(var.get("NS_DT1"));
		String ns_dt2		= String.valueOf(var.get("NS_DT2"));
		String ns_dt3		= String.valueOf(var.get("NS_DT3"));
		String ns_dt4		= String.valueOf(var.get("NS_DT4"));
		String ne_dt1		= String.valueOf(var.get("NE_DT1"));
		String ne_dt2		= String.valueOf(var.get("NE_DT2"));
		String ne_dt3		= String.valueOf(var.get("NE_DT3"));
		String ne_dt4		= String.valueOf(var.get("NE_DT4"));
		String nm_cnt1		= String.valueOf(var.get("NM_CNT1"));
		String nm_cnt2		= String.valueOf(var.get("NM_CNT2"));
		String nm_cnt3		= String.valueOf(var.get("NM_CNT3"));
		String nm_cnt4		= String.valueOf(var.get("NM_CNT4"));
		String nb_cnt1		= String.valueOf(var.get("NB_CNT1"));
		String nb_cnt2		= String.valueOf(var.get("NB_CNT2"));
		String nb_cnt3		= String.valueOf(var.get("NB_CNT3"));
		String nb_cnt4		= String.valueOf(var.get("NB_CNT4"));
		String cnt_per		= String.valueOf(var.get("CNT_PER"));
		String cost_per		= String.valueOf(var.get("COST_PER"));
		String cnt_per2		= String.valueOf(var.get("CNT_PER2"));
		String cost_per2	= String.valueOf(var.get("COST_PER2"));

		//영업효율기본정보
		sub_query_cost_b = getCmpCostBaseQuery(mode, "b", bs_dt, be_dt, cs_dt, ce_dt, enter_dt);
		sub_query_cost_c = getCmpCostBaseQuery(mode, "c", bs_dt, be_dt, cs_dt, ce_dt, enter_dt);

		//기준실적-계약
		sub_query = " select \n"+
					"       f.enter_dt, f.loan_st, f.dept_id, f.user_nm, decode(sign(f.enter_dt-replace('"+enter_dt+"','-','')),-1,'','신입') enter_st, a.bus_id, \n"+
					"		nvl(b.cnt1,0)   as 계약1,     nvl(c.cnt2,0)   as 개시1,     trunc((nvl(b.cnt1,0)+nvl(c.cnt2,0))/2,2)     as 합계1,     \n"+
					"		nvl(b.r_cnt1,0) as 유효계약1, nvl(c.r_cnt2,0) as 유효개시1, trunc((nvl(b.r_cnt1,0)+nvl(c.r_cnt2,0))/2,2) as 유효합계1, \n"+
					"		nvl(d.cnt3,0)   as 계약2,     nvl(e.cnt4,0)   as 개시2,     trunc((nvl(d.cnt3,0)+nvl(e.cnt4,0))/2,2)     as 합계2,     \n"+
					"		nvl(d.r_cnt3,0) as 유효계약2, nvl(e.r_cnt4,0) as 유효개시2, trunc((nvl(d.r_cnt3,0)+nvl(e.r_cnt4,0))/2,2) as 유효합계2, \n"+
					"		a.b_day as 총일수1, a.b_day 총일수2, a.c_day as 경과일수,  \n"+
					"		nvl(g.cost_cnt,0) 영업대수1, nvl(g.cost_amt,0) 영업효율1, \n"+
					"		nvl(h.cost_cnt,0) 영업대수2, nvl(h.cost_amt,0) 영업효율2 \n"+
					" from \n"+
					"		( select bus_id, (to_date(replace('"+be_dt+"','-',''),'YYYYMMDD')-to_date(replace('"+bs_dt+"','-',''),'YYYYMMDD')+1) b_day, (to_date(decode(sign(to_date('"+ce_dt+"','YYYYMMDD')-sysdate),-1,'"+ce_dt+"',to_char(sysdate,'YYYYMMDD')),'YYYYMMDD')-to_date(replace('"+cs_dt+"','-',''),'YYYYMMDD')+1) c_day from stat_bus_cmp_base where bs_dt=replace('"+bs_dt+"','-','') and ce_dt=replace('"+ce_dt+"','-','') group by bus_id) a, \n"+
					"		( select bus_id, sum(cnt1) cnt1, sum(r_cnt1) r_cnt1 from ( select ssn, bus_id, sum(to_number(c_cnt1)) cnt1, sum(decode(sign(10-to_number(r_cnt1)),-1,10,to_number(r_cnt1))) r_cnt1 from ( "+getCmpBaseQuery("1", bs_dt, be_dt, cs_dt, ce_dt)+" ) group by ssn, bus_id ) group by bus_id ) b, \n"+
					"		( select bus_id, sum(cnt2) cnt2, sum(r_cnt2) r_cnt2 from ( select ssn, bus_id, sum(to_number(c_cnt2)) cnt2, sum(decode(sign(10-to_number(r_cnt2)),-1,10,to_number(r_cnt2))) r_cnt2 from ( "+getCmpBaseQuery("2", bs_dt, be_dt, cs_dt, ce_dt)+" ) group by ssn, bus_id ) group by bus_id ) c, \n"+
					"		( select bus_id, sum(cnt3) cnt3, sum(r_cnt3) r_cnt3 from ( select ssn, bus_id, sum(to_number(c_cnt3)) cnt3, sum(decode(sign(10-to_number(r_cnt3)),-1,10,to_number(r_cnt3))) r_cnt3 from ( "+getCmpBaseQuery("3", bs_dt, be_dt, cs_dt, ce_dt)+" ) group by ssn, bus_id ) group by bus_id ) d, \n"+
					"		( select bus_id, sum(cnt4) cnt4, sum(r_cnt4) r_cnt4 from ( select ssn, bus_id, sum(to_number(c_cnt4)) cnt4, sum(decode(sign(10-to_number(r_cnt4)),-1,10,to_number(r_cnt4))) r_cnt4 from ( "+getCmpBaseQuery("4", bs_dt, be_dt, cs_dt, ce_dt)+" ) group by ssn, bus_id ) group by bus_id ) e, \n"+
					"		( select bus_id, cost_cnt, cost_amt from ( "+sub_query_cost_b+" )  ) g, \n"+
					"		( select bus_id, cost_cnt, cost_amt from ( "+sub_query_cost_c+" )  ) h, \n"+
					"		users f \n"+
					" where  \n"+
					"		a.bus_id=b.bus_id(+) and a.bus_id=c.bus_id(+) and a.bus_id=d.bus_id(+) and a.bus_id=e.bus_id(+) \n"+
					"		and a.bus_id=g.bus_id(+) and a.bus_id=h.bus_id(+) \n"+
					"		and a.bus_id=f.user_id and f.loan_st in ('1','2') and nvl(f.out_dt,'99999999')>='"+ce_dt+"'  \n"+
					"       and f.user_id not in ('000083')"+
					" ";


		if(mode.equals("")){//기존직원

			sub_query += " and f.enter_dt <= '"+enter_dt+"' \n";

			sub_query_car_cost=	"    select loan_st,  \n"+
								"			trunc(sum(영업효율1)/sum(영업대수1),0) 부서대당영업효율1, \n"+
								"			trunc(sum(영업효율2)/sum(영업대수2),0) 부서대당영업효율2  \n"+
								"      from ( "+sub_query+" ) "+
								"	   group by loan_st ";

			query = 	"  select a.*,  \n"+
					    "         trunc(a.영업효율1/b.부서대당영업효율1,5) 평가기준효율실적, \n"+
						"         trunc(a.유효합계1/a.총일수1,5) 일평균1,  \n"+
					    "         trunc(a.영업효율1/b.부서대당영업효율1/a.총일수2,5) 일평균2, \n"+
						"         trunc(trunc(a.유효합계1/a.총일수1*decode(b.loan_st,'1',"+cnt_per2+","+cnt_per+")/100,5)+trunc(a.영업효율1/b.부서대당영업효율1/a.총일수2*decode(b.loan_st,'1',"+cost_per2+","+cost_per+")/100,5),5) 일평균, \n"+
						"		  trunc(a.유효합계2,2) 캠페인대수실적,  \n"+
						"         trunc(a.영업효율2/b.부서대당영업효율2,6) 캠페인효율실적,  \n"+
						"         trunc(trunc(a.유효합계2*decode(b.loan_st,'1',"+cnt_per2+","+cnt_per+")/100,2)+trunc(a.영업효율2/b.부서대당영업효율2*decode(b.loan_st,'1',"+cost_per2+","+cost_per+")/100,2),6) 캠페인유효실적, \n"+
						"         b.부서대당영업효율1, b.부서대당영업효율2, \n"+
						"         b.부서소계합계1, b.부서소계유효합계1, b.부서소계영업실적1, b.부서소계일평균1, b.부서소계일평균2, b.부서소계일평균,  \n"+
						"         b.부서평균합계1, b.부서평균유효합계1, b.부서평균영업실적1, b.부서평균일평균1, b.부서평균일평균2, b.부서평균일평균,  \n"+
						"         b.부서최저할인치 \n"+
						"  from  \n"+
						"         ( "+sub_query+" ) a,  \n"+
						"         ( select b1.loan_st, min(b2.부서대당영업효율1) 부서대당영업효율1, min(b2.부서대당영업효율2) 부서대당영업효율2, \n"+
						"			       sum(b1.합계1)														부서소계합계1,		\n"+
						"			       sum(b1.유효합계1)													부서소계유효합계1,  \n"+
						"			       sum(trunc(b1.영업효율1/b2.부서대당영업효율1,2))						부서소계영업실적1,  \n"+
						"                  sum(trunc(b1.유효합계1/b1.총일수1,5))								부서소계일평균1,	\n"+
						"                  sum(trunc(trunc(b1.영업효율1/b2.부서대당영업효율1,2)/b1.총일수2,5))	부서소계일평균2, \n"+
						"                  sum(trunc((trunc(b1.유효합계1/b1.총일수1*decode(b1.loan_st,'1',"+cnt_per2+","+cnt_per+")/100,5)+trunc(trunc(b1.영업효율1/b2.부서대당영업효율1,2)/b1.총일수2*decode(b1.loan_st,'1',"+cost_per2+","+cost_per+")/100,5)),5)) 부서소계일평균, \n"+
						"                  trunc(avg(b1.합계1),2)												부서평균합계1,		\n"+
						"		           trunc(avg(b1.유효합계1),2)											부서평균유효합계1,  \n"+
						"		           trunc(avg(trunc(b1.영업효율1/b2.부서대당영업효율1,2)),2)				부서평균영업실적1,  \n"+
						"                  trunc(avg(trunc(b1.유효합계1/b1.총일수1,5)),5)						부서평균일평균1,  \n"+
						"                  trunc(avg(trunc(trunc(b1.영업효율1/b2.부서대당영업효율1,2)/b1.총일수2,5)),5) 부서평균일평균2, \n"+
						"                  trunc(avg((trunc(b1.유효합계1/b1.총일수1*decode(b1.loan_st,'1',"+cnt_per2+","+cnt_per+")/100,5)+trunc(trunc(b1.영업효율1/b2.부서대당영업효율1,2)/b1.총일수2*decode(b1.loan_st,'1',"+cost_per2+","+cost_per+")/100,5))),5) 부서평균일평균, \n"+
						"                  trunc(avg((trunc(b1.유효합계1/b1.총일수1*decode(b1.loan_st,'1',"+cnt_per2+","+cnt_per+")/100,5)+trunc(trunc(b1.영업효율1/b2.부서대당영업효율1,2)/b1.총일수2*decode(b1.loan_st,'1',"+cost_per2+","+cost_per+")/100,5)))*decode(b1.loan_st,'1',"+mng_down_per+"/100,"+bus_down_per+"/100),5) 부서최저할인치  \n"+
						"           from   ( "+sub_query+" ) b1, ( "+sub_query_car_cost+" ) b2"+
						"	        where  b1.loan_st=b2.loan_st \n"+
						"	        group by b1.loan_st \n"+
						"         ) b \n"+
						"  where  a.loan_st=b.loan_st(+) \n";




		}else{

			String ns_dt	= "";
			String ne_dt	= "";
			String nm_cnt	= "";
			String nb_cnt	= "";

			if(mode.equals("1")){//신입1
				ns_dt	= ns_dt1;   
				ne_dt	= ne_dt1;   
				nm_cnt	= nm_cnt1;  
				nb_cnt	= nb_cnt1;  
			}else if(mode.equals("2")){//신입2
				ns_dt	= ns_dt2;   
				ne_dt	= ne_dt2;   
				nm_cnt	= nm_cnt2;  
				nb_cnt	= nb_cnt2;  
			}else if(mode.equals("3")){//신입3
				ns_dt	= ns_dt3;   
				ne_dt	= ne_dt3;   
				nm_cnt	= nm_cnt3;  
				nb_cnt	= nb_cnt3;  
			}else if(mode.equals("4")){//신입4
				ns_dt	= ns_dt4;   
				ne_dt	= ne_dt4;   
				nm_cnt	= nm_cnt4;  
				nb_cnt	= nb_cnt4;  
			}
			
			sub_query += " and f.enter_dt between '"+ns_dt+"' and '"+ne_dt+"' \n";

			sub_query_car_cost=	"    select loan_st,  \n"+
								"			trunc(sum(영업효율1)/sum(영업대수1),0) 부서대당영업효율1, \n"+
								"			trunc(sum(영업효율2)/sum(영업대수2),0) 부서대당영업효율2  \n"+
								"      from ( "+sub_query+" ) "+
								"	   group by loan_st ";

			query =		"  select "+
						"         a.enter_dt, a.loan_st, a.dept_id, a.user_nm, a.enter_st, a.bus_id,  \n"+
						"	      decode(a.loan_st,'1','"+nm_cnt+"', '"+nb_cnt+"') 계약1,  \n"+
						"	      decode(a.loan_st,'1','"+nm_cnt+"', '"+nb_cnt+"') 개시1,  \n"+
						"	      decode(a.loan_st,'1','"+nm_cnt+"', '"+nb_cnt+"') 합계1,  \n"+
						"	      decode(a.loan_st,'1','"+nm_cnt+"', '"+nb_cnt+"') 유효계약1,  \n"+
						"	      decode(a.loan_st,'1','"+nm_cnt+"', '"+nb_cnt+"') 유효개시1,  \n"+
						"	      decode(a.loan_st,'1','"+nm_cnt+"', '"+nb_cnt+"') 유효합계1,  \n"+
						"	      decode(a.loan_st,'1','"+nm_cnt+"', '"+nb_cnt+"') 영업효율실적1,  \n"+
						"         trunc(((decode(a.loan_st,'1',"+nm_cnt+", "+nb_cnt+")/a.총일수1)+(decode(a.loan_st,'1',"+nm_cnt+", "+nb_cnt+")/a.총일수2))/2,5) 일평균,  \n"+
						"         trunc((decode(a.loan_st,'1',"+nm_cnt+", "+nb_cnt+")/a.총일수1),5) 일평균1,  \n"+
						"         trunc((decode(a.loan_st,'1',"+nm_cnt+", "+nb_cnt+")/a.총일수2),5) 일평균2,  \n"+
						"         a.총일수1, a.총일수2, a.경과일수, a.계약2, a.개시2, a.합계2, a.유효계약2, a.유효개시2, a.유효합계2, \n"+
						"		  trunc(a.유효합계2,2) 캠페인대수실적,  \n"+
						"         trunc(a.영업효율2/b.부서대당영업효율2,6) 캠페인효율실적,  \n"+
						"         trunc(trunc(a.유효합계2*decode(b.loan_st,'1',"+cnt_per2+","+cnt_per+")/100,2)+trunc(a.영업효율2/b.부서대당영업효율2*decode(b.loan_st,'1',"+cost_per2+","+cost_per+")/100,2),6) 캠페인유효실적, \n"+
						"         '' 부서소계합계1, '' 부서소계유효합계1, '' 부서소계일평균1, '' 부서소계일평균2, '' 부서소계일평균,  \n"+
						"         '' 부서평균합계1, '' 부서평균유효합계1, '' 부서평균일평균1, '' 부서평균일평균2, '' 부서평균일평균, '' 부서최저할인치  \n"+
						"   from  \n"+
						"        ( "+sub_query+" ) a, \n"+
						"        ( "+sub_query_car_cost+" ) b\n"+
						"   where  a.loan_st=b.loan_st \n"+
						"  ";

		}

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
			System.out.println("[CampaignDatabase:getStatBusCmpAccountData_2009_06]\n"+e);
			System.out.println("[CampaignDatabase:getStatBusCmpAccountData_2009_06]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	//영업증진캠페인 영업효율 기초정보 기본쿼리문 리턴
    public static String getCmpCostBaseQuery(String mode, String st, String bs_dt, String be_dt, String cs_dt, String ce_dt, String enter_dt) 
    {


    	String query = "";
    	String sub_query1 = "";
    	String sub_query2 = "";
		String where = "";

		if(st.equals("b"))	where = " and a.cmp_dt between replace('"+bs_dt+"','-','') and replace('"+be_dt+"','-','') ";
		if(st.equals("c"))	where = " and a.cmp_dt between replace('"+cs_dt+"','-','') and replace('"+ce_dt+"','-','') ";



		//신차/재리스/연장
		sub_query1	 = " select a.bus_id, \n"+
					   "        decode(a.cost_st,'1',decode(sign(f.con_mon-6),-1,0,1),0) cost_cnt, \n"+		//영업대수
					   "        nvl(a.amt8-a.amt21+amt30,0) cost_amt  \n"+					//영업효율
					   " from   stat_bus_cost_cmp_base a, fee f, cont d, cls_cont e \n"+
					   " where  a.gubun = '2' and a.cost_st in ('1') \n"+
						        where +
					   "	    and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_st = f.rent_st \n"+
					   "	    and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd \n"+
					   "	    and a.rent_mng_id = e.rent_mng_id(+) and a.rent_l_cd = e.rent_l_cd(+) "+
					   "	    and nvl(e.cls_st,'0') not in ('7','10') \n"+				//계약승계 계약제외
					   " ";


		//기타영업효율
		sub_query2	 =	" select a.bus_id, \n"+
						"        0 cost_cnt, "+
						" nvl(a.amt8-a.amt21+amt30,0) cost_amt  \n"+ //영업효율
						" from   stat_bus_cost_cmp_base a \n"+
						" where  a.gubun = '2' and a.cost_st not in ('1','6') \n"+
						         where +
						" ";


		query = " select bus_id, sum(cost_cnt) cost_cnt, sum(cost_amt) cost_amt from ("+sub_query1+" union all "+sub_query2+") group by bus_id";


    	return query;
    }


	/**
	 * 영업실적 마감 데이타 (영업효율) 담당자별 리스트 조회
	 */
	public Vector getStatBusCmpBaseBusCostList(String bus_id, String mode, String bs_dt, String be_dt, String cs_dt, String ce_dt, float avg_cost_cnt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

    	    	String query = "";
    	String sub_query = "";
    	String sub_query1 = "";
    	String sub_query2 = "";
		String sub_query_car_cost = "";
		String where = "";
		String where2 = "";

		if(mode.equals("b"))	where = " and a.cmp_dt between replace('"+bs_dt+"','-','') and replace('"+be_dt+"','-','') ";
		if(mode.equals("c"))	where = " and a.cmp_dt between replace('"+cs_dt+"','-','') and replace('"+ce_dt+"','-','') ";

		if(!bus_id.equals(""))	where2 = " and a.bus_id = '"+bus_id+"' ";


		//신차/재리스/연장
		sub_query1	 = " select b.loan_st, a.*, decode(f.rent_st,'1',decode(d.car_gu,'1','신차','재리스'),'연장') cmp_st  \n"+ //영업효율
					   " from   stat_bus_cost_cmp_base a, fee f, cont d, cls_cont e, users b \n"+
					   " where  a.gubun = '2' and a.cost_st in ('1') \n"+
						        where + " " + where2 +
					   "	    and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_st = f.rent_st \n"+
					   "	    and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd \n"+
					   "	    and a.rent_mng_id = e.rent_mng_id(+) and a.rent_l_cd = e.rent_l_cd(+) "+
					   "	    and a.bus_id=b.user_id \n"+
					   "	    and nvl(e.cls_st,'0') not in ('7','10') \n"+	//출고전해지,개시전해지 계약제외
					   " ";


		//기타영업효율
		sub_query2	 = " select b.loan_st, a.*, '기타' cmp_st \n"+
					   " from   stat_bus_cost_cmp_base a, users b \n"+
					   " where  a.gubun = '2' and a.cost_st not in ('1','6') and a.bus_id=b.user_id \n"+
						        where + " " + where2 +
					   " ";


		if(avg_cost_cnt>0){
			query =			"  select \n"+
							"         a.*, "+
				            "         DECODE(NVL(a.cmp_ea_amt,0),0,nvl(nvl(a.amt8,0)-nvl(a.amt21,0)+nvl(a.amt30,0),0),a.cmp_ea_amt) cost_amt, "+
							"         to_char(to_number(round(DECODE(NVL(a.cmp_ea_amt,0),0,nvl(nvl(a.amt8,0)-nvl(a.amt21,0)+nvl(a.amt30,0),0),a.cmp_ea_amt)/"+avg_cost_cnt+",2)),decode(sign(1-to_number(round(DECODE(NVL(a.cmp_ea_amt,0),0,nvl(nvl(a.amt8,0)-nvl(a.amt21,0)+nvl(a.amt30,0),0),a.cmp_ea_amt)/"+avg_cost_cnt+",2))),-1,'999.99','999.99')) cost_cnt, "+
							"         d.firm_nm, decode(a.cost_st,'9',e2.car_no,e.car_no) car_no, decode(a.cost_st,'9',e2.car_nm,e.car_nm) car_nm, "+
							"	      decode(a.cost_st,'1', a.cmp_st, "+
							"        	               '7', decode(a.rent_st,'1',decode(c.car_gu,'1','신차','재리스'),'연장')||'정산', "+
							"        	               '8', decode(a.rent_st,'1',decode(c.car_gu,'1','신차','재리스'),'연장')||'승계정산', "+
							"                          '2', '추가이용',   '5', '승계수수료', "+
							"                          '3', decode(s.cls_st,'1','만기정산금발생','중도정산금발생'), "+
							"                          '4', decode(s.cls_st,'1','만기정산금수금','중도정산금수금'), "+
							"                          '9', '출고지연대차', "+
							"                          '10', '재리스수리비추가', "+
							"                          '11', '해지정산경감원계약자', "+
							"                          '12', '해지정산경감부담자', "+
							"                          '13', '월렌트'||decode(a.rent_st,'1','','연장'), "+
							"                          '14', '월렌트' "+
							"         ) cmp_st_nm \n"+
							"  from  \n"+
							"         ( "+sub_query1+" union all "+sub_query2+" ) a, \n"+
							"		  cont c, client d, taecha t, car_reg e, cls_cont s, car_reg e2 \n"+
							"  where  "+
							"         a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd "+
							"         and c.client_id=d.client_id "+
							"         and a.rent_mng_id=t.rent_mng_id(+) and a.rent_l_cd=t.rent_l_cd(+) and nvl(t.no,'0')='0' "+
							"         and c.car_mng_id=e.car_mng_id(+)"+
							"         and t.car_mng_id=e2.car_mng_id(+)"+
							"         and a.rent_mng_id=s.rent_mng_id(+) and a.rent_l_cd=s.rent_l_cd(+) "+
							"  order by to_number(a.cost_st), a.car_off_enp_no, a.cmp_dt";
		}else{
			query =			"  select \n"+
							"         a.*, "+
				            "         DECODE(NVL(a.cmp_ea_amt,0),0,nvl(nvl(a.amt8,0)-nvl(a.amt21,0)+nvl(a.amt30,0),0),a.cmp_ea_amt) cost_amt, "+
							"         0 cost_cnt, "+
							"         d.firm_nm, decode(a.cost_st,'9',e2.car_no,e.car_no) car_no, decode(a.cost_st,'9',e2.car_nm,e.car_nm) car_nm, "+
							"	      decode(a.cost_st,'1', a.cmp_st, "+
							"        	               '7', decode(a.rent_st,'1',decode(c.car_gu,'1','신차','재리스'),'연장')||'정산', "+
							"        	               '8', decode(a.rent_st,'1',decode(c.car_gu,'1','신차','재리스'),'연장')||'승계정산', "+
							"                          '2', '추가이용',   '5', '승계수수료', "+
							"                          '3', decode(s.cls_st,'1','만기정산금발생','중도정산금발생'), "+
							"                          '4', decode(s.cls_st,'1','만기정산금수금','중도정산금수금'), "+
							"                          '9', '출고지연대차', "+
							"                          '10', '재리스수리비추가', "+
							"                          '11', '해지정산경감원계약자', "+
							"                          '12', '해지정산경감부담자', "+
							"                          '13', '월렌트', "+
							"                          '14', '월렌트' "+
							"         ) cmp_st_nm \n"+
							"  from  \n"+
							"         ( "+sub_query1+" union all "+sub_query2+" ) a, \n"+
							"		  cont c, client d, taecha t, car_reg e, cls_cont s, car_reg e2 \n"+
							"  where  "+
							"         a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd "+
							"         and c.client_id=d.client_id "+
							"         and a.rent_mng_id=t.rent_mng_id(+) and a.rent_l_cd=t.rent_l_cd(+) and nvl(t.no,'0')='0' "+
							"         and c.car_mng_id=e.car_mng_id(+)"+
							"         and t.car_mng_id=e2.car_mng_id(+)"+
							"         and a.rent_mng_id=s.rent_mng_id(+) and a.rent_l_cd=s.rent_l_cd(+) "+
							"  order by to_number(a.cost_st), a.car_off_enp_no, a.cmp_dt";
		}

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
			System.out.println("[CampaignDatabase:getStatBusCmpBaseBusCostList]\n"+e);
			System.out.println("[CampaignDatabase:getStatBusCmpBaseBusCostList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}	

	/**
	 * 영업실적 마감 데이타 (영업효율) 담당자별 리스트 조회
	 */
	public Vector getStatBusCmpBaseBusCostListRm(String bus_id, String mode, String bs_dt, String be_dt, String cs_dt, String ce_dt, float avg_cost_cnt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

    	String query = "";
    	String sub_query = "";
		String sub_query_car_cost = "";
		String where = "";
		String where2 = "";

		if(mode.equals("b"))	where = " and a.cmp_dt between replace('"+bs_dt+"','-','') and replace('"+be_dt+"','-','') ";
		if(mode.equals("c"))	where = " and a.cmp_dt between replace('"+cs_dt+"','-','') and replace('"+ce_dt+"','-','') ";

		if(!bus_id.equals(""))	where2 = " and a.bus_id = '"+bus_id+"' ";



		//월렌트영업효율
		sub_query	 = " select b.loan_st, a.*, '월렌트' cmp_st \n"+
					   " from   stat_bus_cost_cmp_base a, users b \n"+
					   " where  a.gubun = '2' and a.cost_st in ('13','14') and a.bus_id=b.user_id \n"+
						        where + " " + where2 +
					   " ";


		if(avg_cost_cnt>0){
			query =			"  select \n"+
							"         a.*, (nvl(a.amt8,0)-nvl(a.amt21,0)+nvl(a.amt30,0)) cost_amt, "+
							"         to_char(to_number(round((nvl(a.amt8,0)-nvl(a.amt21,0)+nvl(amt30,0))/"+avg_cost_cnt+",2)),decode(sign(1-to_number(round((nvl(a.amt8,0)-nvl(a.amt21,0)+nvl(amt30,0))/"+avg_cost_cnt+",2))),-1,'999.99','999.99')) cost_cnt, "+
							"         d.firm_nm, e.car_no, e.car_nm, "+
							"	      '월렌트'||decode(a.rent_st,'1','신규','s','정산','연장') cmp_st_nm \n"+
							"  from  \n"+
							"         ( "+sub_query+" ) a, \n"+
							"		  rent_cont c, client d, car_reg e \n"+
							"  where  "+
							"         a.rent_mng_id=c.car_mng_id and a.rent_l_cd=c.rent_s_cd "+
							"         and c.cust_id=d.client_id "+
							"         and c.car_mng_id=e.car_mng_id "+
							"  order by to_number(a.cost_st), a.cmp_dt";
		}else{
			query =			"  select \n"+
							"         a.*, (nvl(a.amt8,0)-nvl(a.amt21,0)+nvl(amt30,0)) cost_amt, 0 cost_cnt, "+
							"         d.firm_nm, e.car_no, e.car_nm, "+
							"	      '월렌트'||decode(a.rent_st,'1','신규','s','정산','연장') cmp_st_nm \n"+
							"  from  \n"+
							"         ( "+sub_query+" ) a, \n"+
							"		  rent_cont c, client d, car_reg e \n"+
							"  where  "+
							"         a.rent_mng_id=c.car_mng_id and a.rent_l_cd=c.rent_s_cd "+
							"         and c.cust_id=d.client_id "+
							"         and c.car_mng_id=e.car_mng_id "+
							"  order by to_number(a.cost_st), a.cmp_dt";
		}

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
			System.out.println("[CampaignDatabase:getStatBusCmpBaseBusCostListRm]\n"+e);
			System.out.println("[CampaignDatabase:getStatBusCmpBaseBusCostListRm]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 * 영업실적 마감 데이타 조회
	 */
	public Vector getStatBusCmpAccountData_2009_04_1ch(Hashtable var, String mode)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";
		String sub_query_cost_b = "";
		String sub_query_cost_c = "";

		String cs_dt 		= String.valueOf(var.get("CS_DT"));
		String ce_dt 		= String.valueOf(var.get("CE_DT"));
		String bs_dt 		= String.valueOf(var.get("BS_DT"));
		String be_dt 		= String.valueOf(var.get("BE_DT"));
		String bs_dt2 		= String.valueOf(var.get("BS_DT2"));
		String be_dt2 		= String.valueOf(var.get("BE_DT2"));
		String enter_dt		= String.valueOf(var.get("ENTER_DT"));
		String bus_up_per 	= String.valueOf(var.get("BUS_UP_PER"));
		String bus_down_per = String.valueOf(var.get("BUS_DOWN_PER"));
		String mng_up_per 	= String.valueOf(var.get("MNG_UP_PER"));
		String mng_down_per = String.valueOf(var.get("MNG_DOWN_PER"));
		String ns_dt1		= String.valueOf(var.get("NS_DT1"));
		String ns_dt2		= String.valueOf(var.get("NS_DT2"));
		String ns_dt3		= String.valueOf(var.get("NS_DT3"));
		String ns_dt4		= String.valueOf(var.get("NS_DT4"));
		String ne_dt1		= String.valueOf(var.get("NE_DT1"));
		String ne_dt2		= String.valueOf(var.get("NE_DT2"));
		String ne_dt3		= String.valueOf(var.get("NE_DT3"));
		String ne_dt4		= String.valueOf(var.get("NE_DT4"));
		String nm_cnt1		= String.valueOf(var.get("NM_CNT1"));
		String nm_cnt2		= String.valueOf(var.get("NM_CNT2"));
		String nm_cnt3		= String.valueOf(var.get("NM_CNT3"));
		String nm_cnt4		= String.valueOf(var.get("NM_CNT4"));
		String nb_cnt1		= String.valueOf(var.get("NB_CNT1"));
		String nb_cnt2		= String.valueOf(var.get("NB_CNT2"));
		String nb_cnt3		= String.valueOf(var.get("NB_CNT3"));
		String nb_cnt4		= String.valueOf(var.get("NB_CNT4"));
		String cnt_per		= String.valueOf(var.get("CNT_PER"));
		String cost_per		= String.valueOf(var.get("COST_PER"));

		sub_query_cost_b = getCmpCostBaseQuery_1ch(mode, "b", bs_dt, be_dt, cs_dt, ce_dt, enter_dt);
		sub_query_cost_c = getCmpCostBaseQuery_1ch(mode, "c", bs_dt, be_dt, cs_dt, ce_dt, enter_dt);

		//기준실적-계약
		sub_query = " select \n"+
					"       f.enter_dt, f.loan_st, f.dept_id, f.user_nm, decode(sign(f.enter_dt-replace('"+enter_dt+"','-','')),-1,'','신입') enter_st, a.bus_id, \n"+

					"		nvl(b.cnt1,0)   as 계약1,     nvl(c.cnt2,0)   as 개시1,     trunc((nvl(b.cnt1,0)+nvl(c.cnt2,0))/2,2)     as 합계1,     \n"+
					"		nvl(b.r_cnt1,0) as 유효계약1, nvl(c.r_cnt2,0) as 유효개시1, trunc((nvl(b.r_cnt1,0)+nvl(c.r_cnt2,0))/2,2) as 유효합계1, \n"+
					"		nvl(d.cnt3,0)   as 계약2,     nvl(e.cnt4,0)   as 개시2,     trunc((nvl(d.cnt3,0)+nvl(e.cnt4,0))/2,2)     as 합계2,     \n"+
					"		nvl(d.r_cnt3,0) as 유효계약2, nvl(e.r_cnt4,0) as 유효개시2, trunc((nvl(d.r_cnt3,0)+nvl(e.r_cnt4,0))/2,2) as 유효합계2, \n"+

					"		a.b_day as 총일수1, decode(replace('"+cs_dt+"','-',''),'20090101',31,'20090401',90,a.b_day) 총일수2, a.c_day as 경과일수,  \n"+

					"		g.cost_cnt 영업효율대수1, g.cost_amt 영업효율1, g.avg_cost_cnt 부서평균대당영업효율1, g.r_cost_cnt 유효영업효율대수1, \n"+
					"		h.cost_cnt 영업효율대수2, h.cost_amt 영업효율2, h.avg_cost_cnt 부서평균대당영업효율2, h.r_cost_cnt 유효영업효율대수2  \n"+

					" from \n"+
					"		( select bus_id, (to_date(replace('"+be_dt+"','-',''),'YYYYMMDD')-to_date(replace('"+bs_dt+"','-',''),'YYYYMMDD')+1) b_day, (to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(replace('"+cs_dt+"','-',''),'YYYYMMDD')+1) c_day from stat_bus_cmp_base where bs_dt=replace('"+bs_dt+"','-','') and ce_dt=replace('"+ce_dt+"','-','') group by bus_id) a, \n"+
					"		( select bus_id, sum(cnt1) cnt1, sum(r_cnt1) r_cnt1 from ( select ssn, bus_id, sum(to_number(cnt1)) cnt1, sum(decode(sign(10-to_number(r_cnt1)),-1,10,to_number(r_cnt1))) r_cnt1 from ( "+getCmpBaseQuery("1", bs_dt, be_dt, cs_dt, ce_dt)+" ) group by ssn, bus_id ) group by bus_id ) b, \n"+
					"		( select bus_id, sum(cnt2) cnt2, sum(r_cnt2) r_cnt2 from ( select ssn, bus_id, sum(to_number(cnt2)) cnt2, sum(decode(sign(10-to_number(r_cnt2)),-1,10,to_number(r_cnt2))) r_cnt2 from ( "+getCmpBaseQuery("2", bs_dt, be_dt, cs_dt, ce_dt)+" ) group by ssn, bus_id ) group by bus_id ) c, \n"+
					"		( select bus_id, sum(cnt3) cnt3, sum(r_cnt3) r_cnt3 from ( select ssn, bus_id, sum(to_number(cnt3)) cnt3, sum(decode(sign(10-to_number(r_cnt3)),-1,10,to_number(r_cnt3))) r_cnt3 from ( "+getCmpBaseQuery("3", bs_dt, be_dt, cs_dt, ce_dt)+" ) group by ssn, bus_id ) group by bus_id ) d, \n"+
					"		( select bus_id, sum(cnt4) cnt4, sum(r_cnt4) r_cnt4 from ( select ssn, bus_id, sum(to_number(cnt4)) cnt4, sum(decode(sign(10-to_number(r_cnt4)),-1,10,to_number(r_cnt4))) r_cnt4 from ( "+getCmpBaseQuery("4", bs_dt, be_dt, cs_dt, ce_dt)+" ) group by ssn, bus_id ) group by bus_id ) e, \n"+
					"		( select a.bus_id, a.cost_cnt, a.cost_amt, b.avg_cost_cnt, trunc(a.cost_amt/b.avg_cost_cnt,2) as r_cost_cnt from ( "+sub_query_cost_b+" ) a, ( select loan_st, trunc(sum(cost_amt)/sum(cost_cnt),0) avg_cost_cnt from ("+sub_query_cost_b+") group by loan_st ) b where a.loan_st=b.loan_st ) g, \n"+
					"		( select a.bus_id, a.cost_cnt, a.cost_amt, b.avg_cost_cnt, trunc(a.cost_amt/b.avg_cost_cnt,2) as r_cost_cnt from ( "+sub_query_cost_c+" ) a, ( select loan_st, trunc(sum(cost_amt)/sum(cost_cnt),0) avg_cost_cnt from ("+sub_query_cost_c+") group by loan_st ) b where a.loan_st=b.loan_st ) h, \n"+
					"		users f \n"+
					" where  \n"+
					"		a.bus_id=b.bus_id(+) and a.bus_id=c.bus_id(+) and a.bus_id=d.bus_id(+) and a.bus_id=e.bus_id(+) \n"+
					"		and a.bus_id=g.bus_id(+) and a.bus_id=h.bus_id(+) \n"+
					"		and a.bus_id=f.user_id and f.loan_st in ('1','2') and nvl(f.out_dt,'99999999')>='"+ce_dt+"'  \n"+
					" ";


		if(mode.equals("")){//기존직원

			sub_query += " and f.enter_dt <= '"+enter_dt+"' \n";

			query = 	"  select a.*,  \n"+
						"         trunc(a.유효합계1/a.총일수1,5) 일평균1,  \n"+
					    "         trunc(a.유효영업효율대수1/a.총일수2,5) 일평균2, \n"+
						"         trunc(trunc(a.유효합계1/a.총일수1*"+cnt_per+"/100,5)+trunc(a.유효영업효율대수1/a.총일수2*"+cost_per+"/100,5),5) 일평균, \n"+
						"		  trunc(a.유효합계2,2) 캠페인대수실적,  \n"+
						"         trunc(a.유효영업효율대수2,2) 캠페인효율실적,  \n"+
						"         trunc(trunc(a.유효합계2*"+cnt_per+"/100,2)+trunc(a.유효영업효율대수2*"+cost_per+"/100,2),2) 캠페인유효실적, \n"+
						"         b.부서소계합계1, b.부서소계유효합계1, b.부서소계영업실적1, b.부서소계일평균1, b.부서소계일평균2, b.부서소계일평균,  \n"+
						"         b.부서평균합계1, b.부서평균유효합계1, b.부서평균영업실적1, b.부서평균일평균1, b.부서평균일평균2, b.부서평균일평균,  \n"+
						"         b.부서최저할인치 \n"+
						"  from  \n"+
						"    ( "+sub_query+" ) a,  \n"+
						"    ( select loan_st,  \n"+

						"			  sum(합계1)						부서소계합계1,		\n"+
						"			  sum(유효합계1)					부서소계유효합계1,  \n"+
						"			  sum(유효영업효율대수1)			부서소계영업실적1,  \n"+
						"             sum(trunc(유효합계1/총일수1,5))	부서소계일평균1, \n"+
						"             sum(trunc(유효영업효율대수1/총일수2,5)) 부서소계일평균2, \n"+
						"             sum(trunc((trunc(유효합계1/총일수1*"+cnt_per+"/100,5)+trunc(유효영업효율대수1/총일수2*"+cost_per+"/100,5))/2,5)) 부서소계일평균, \n"+

						"             trunc(avg(합계1),2)				부서평균합계1,		\n"+
						"		      trunc(avg(유효합계1),2)			부서평균유효합계1,  \n"+
						"		      trunc(avg(유효영업효율대수1),2)	부서평균영업실적1,  \n"+
						"             trunc(avg(trunc(유효합계1/총일수1,5)),5) 부서평균일평균1,  \n"+
						"             trunc(avg(trunc(유효영업효율대수1/총일수2,5)),5) 부서평균일평균2, \n"+
						"             trunc(avg((trunc(유효합계1/총일수1*"+cnt_per+"/100,5)+trunc(유효영업효율대수1/총일수2*"+cost_per+"/100,5))/2),5) 부서평균일평균, \n"+

						"             trunc(avg((trunc(유효합계1/총일수1*"+cnt_per+"/100,5)+trunc(유효영업효율대수1/총일수2*"+cost_per+"/100,5))/2)*decode(loan_st,'1',"+mng_down_per+"/100,"+bus_down_per+"/100),5) 부서최저할인치  \n"+

						"      from ( "+sub_query+" ) where enter_st is null group by loan_st) b \n"+
						"  where a.loan_st=b.loan_st(+) \n";

		}else{

			String ns_dt	= "";
			String ne_dt	= "";
			String nm_cnt	= "";
			String nb_cnt	= "";

			if(mode.equals("1")){//신입1
				ns_dt	= ns_dt1;   
				ne_dt	= ne_dt1;   
				nm_cnt	= nm_cnt1;  
				nb_cnt	= nb_cnt1;  
			}else if(mode.equals("2")){//신입2
				ns_dt	= ns_dt2;   
				ne_dt	= ne_dt2;   
				nm_cnt	= nm_cnt2;  
				nb_cnt	= nb_cnt2;  
			}else if(mode.equals("3")){//신입3
				ns_dt	= ns_dt3;   
				ne_dt	= ne_dt3;   
				nm_cnt	= nm_cnt3;  
				nb_cnt	= nb_cnt3;  
			}else if(mode.equals("4")){//신입4
				ns_dt	= ns_dt4;   
				ne_dt	= ne_dt4;   
				nm_cnt	= nm_cnt4;  
				nb_cnt	= nb_cnt4;  
			}
			
			sub_query += " and f.enter_dt between '"+ns_dt+"' and '"+ne_dt+"' \n";

			query =		"  select "+
						"         a.enter_dt, a.loan_st, a.dept_id, a.user_nm, a.enter_st, a.bus_id,  \n"+
						"	      decode(a.loan_st,'1','"+nm_cnt+"', '"+nb_cnt+"') 계약1,  \n"+
						"	      decode(a.loan_st,'1','"+nm_cnt+"', '"+nb_cnt+"') 개시1,  \n"+
						"	      decode(a.loan_st,'1','"+nm_cnt+"', '"+nb_cnt+"') 합계1,  \n"+
						"	      decode(a.loan_st,'1','"+nm_cnt+"', '"+nb_cnt+"') 유효계약1,  \n"+
						"	      decode(a.loan_st,'1','"+nm_cnt+"', '"+nb_cnt+"') 유효개시1,  \n"+
						"	      decode(a.loan_st,'1','"+nm_cnt+"', '"+nb_cnt+"') 유효합계1,  \n"+
						"	      decode(a.loan_st,'1','"+nm_cnt+"', '"+nb_cnt+"') 영업효율실적1,  \n"+
						"         trunc(((decode(a.loan_st,'1',"+nm_cnt+", "+nb_cnt+")/a.총일수1)+(decode(a.loan_st,'1',"+nm_cnt+", "+nb_cnt+")/a.총일수2))/2,5) 일평균,  \n"+
						"         trunc((decode(a.loan_st,'1',"+nm_cnt+", "+nb_cnt+")/a.총일수1),5) 일평균1,  \n"+
						"         trunc((decode(a.loan_st,'1',"+nm_cnt+", "+nb_cnt+")/a.총일수2),5) 일평균2,  \n"+
						"         a.총일수1, a.총일수2, a.경과일수, a.계약2, a.개시2, a.합계2, a.유효계약2, a.유효개시2, a.유효합계2, \n"+
						"         a.유효영업효율대수2, \n"+
						"		  trunc(a.유효합계2,2) 캠페인대수실적,  \n"+
						"         trunc(a.유효영업효율대수2,2) 캠페인효율실적,  \n"+
						"         trunc(trunc(a.유효합계2*"+cnt_per+"/100,2)+trunc(a.유효영업효율대수2*"+cost_per+"/100,2),2) 캠페인유효실적, \n"+
						"         '' 부서소계합계1, '' 부서소계유효합계1, '' 부서소계일평균1, '' 부서소계일평균2, '' 부서소계일평균,  \n"+
						"         '' 부서평균합계1, '' 부서평균유효합계1, '' 부서평균일평균1, '' 부서평균일평균2, '' 부서평균일평균, '' 부서최저할인치,  \n"+
						"   from  \n"+
						"        ( "+sub_query+" ) a \n"+
						"  ";

		}

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
			System.out.println("[CampaignDatabase:getStatBusCmpAccountData_2009_04_1ch]\n"+e);
			System.out.println("[CampaignDatabase:getStatBusCmpAccountData_2009_04_1ch]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	//영업증진캠페인 영업효율 기초정보 기본쿼리문 리턴
    public static String getCmpCostBaseQuery_1ch(String mode, String st, String bs_dt, String be_dt, String cs_dt, String ce_dt, String enter_dt) 
    {


    	String query = "";
    	String sub_query = "";
		String where = "";

		if(st.equals("b"))	where = " and a.cmp_dt between replace('"+bs_dt+"','-','') and replace('"+be_dt+"','-','') ";
		if(st.equals("c"))	where = " and a.cmp_dt between replace('"+cs_dt+"','-','') and replace('"+ce_dt+"','-','') ";


		sub_query = " select    c.loan_st, a.bus_id, \n"+
					   "        count  (decode(a.cost_st,'1',decode(sign(f.con_mon-6),-1,'',a.rent_l_cd))) cost_cnt, \n"+		//영업대수
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(f.con_mon-6),-1,0,a.amt8-a.amt21+amt30  ),a.amt8-a.amt21+amt30 )),0) cost_amt  \n"+ //영업효율 
					   " from   stat_bus_cost_cmp_base a, fee f, users c, cont d, cls_cont e \n"+
					   " where  a.gubun = '2' and a.cost_st not in ('6') \n"+
						        where +
					   "	    and a.rent_mng_id = f.rent_mng_id(+) and a.rent_l_cd = f.rent_l_cd(+) and a.rent_st = f.rent_st(+)  \n"+
					   "        and a.bus_id=c.user_id"+
					   "	    and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd and d.rent_start_dt is not null  \n"+
					   "	    and a.rent_mng_id = e.rent_mng_id(+) and a.rent_l_cd = e.rent_l_cd(+) and nvl(e.cls_st,'0') not in ('7','10')  \n"+
					   " group by c.loan_st, a.bus_id";

		
			query =		"  select \n"+
						"         a.*, b.avg_cost_cnt, trunc(a.cost_amt/b.avg_cost_cnt,2) r_cost_cnt \n"+
						"  from  \n"+
						"         ( "+sub_query+" ) a, \n"+
						"		  ( select  \n"+
						"                  loan_st, trunc(avg(trunc(decode(cost_cnt,0,0,cost_amt/cost_cnt),2)),0) avg_cost_cnt  \n"+
						"		    from   ( "+sub_query+" ) "+
						"           group by loan_st " +
						"		  ) b \n"+
						"  where  a.loan_st=b.loan_st "+
						"  order by a.loan_st, a.bus_id "+
						"  ";


    	return query;
    }

	/**
	 * 영업실적 마감 데이타 (영업효율) 담당자별 리스트 조회
	 */
	public Vector getStatBusCmpBaseBusCostList_1ch(String bus_id, String mode, String bs_dt, String be_dt, String cs_dt, String ce_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

    	String query = "";
    	String sub_query = "";
		String where = "";
		String where2 = "";

		if(mode.equals("b"))	where = " and a.cmp_dt between replace('"+bs_dt+"','-','') and replace('"+be_dt+"','-','') ";
		if(mode.equals("c"))	where = " and a.cmp_dt between replace('"+cs_dt+"','-','') and replace('"+ce_dt+"','-','') ";

		if(!bus_id.equals(""))	where2 = " and a.bus_id = '"+bus_id+"' ";

		sub_query = " select    c.loan_st, c.user_nm, a.*, \n"+
					   "        decode(a.cost_st,'1',decode(sign(f.con_mon-6),-1,0,1),0) cost_cnt, \n"+										//영업대수
					   "        nvl(decode(a.cost_st,'1',decode(sign(f.con_mon-6),-1,0,a.amt8-a.amt21+amt30  ),a.amt8-a.amt21+amt30 ),0) cost_amt  \n"+ //영업효율 
					   " from   stat_bus_cost_cmp_base a, fee f, users c, cont d, cls_cont e \n"+
					   " where  a.gubun = '2' and a.cost_st not in ('6') \n"+
						        where +
					   "	    and a.rent_mng_id = f.rent_mng_id(+) and a.rent_l_cd = f.rent_l_cd(+) and a.rent_st = f.rent_st(+)  \n"+
					   "        and a.bus_id=c.user_id"+
					   "	    and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd and d.rent_start_dt is not null  \n"+
					   "	    and a.rent_mng_id = e.rent_mng_id(+) and a.rent_l_cd = e.rent_l_cd(+) and nvl(e.cls_st,'0') not in ('7','10')  \n"+
					   " ";	

			query =		"  select \n"+
						"         a.*, d.firm_nm, e.car_no, e.car_nm, "+
						"         b.avg_cost_cnt, \n"+
					    "         decode(a.cost_st,'1','신차/재리스/연장','3','신차미수령위약금','4','실수령위약금','2','추가이용','6','재리스/연장정산','5','승계수수료') cmp_st_nm  \n"+
						"  from  \n"+
						"         ( "+sub_query+" "+where2+" ) a, \n"+
						"		  ( select  \n"+
						"                  loan_st, trunc(avg(trunc(decode(cost_cnt,0,0,cost_amt/cost_cnt),2)),0) avg_cost_cnt  \n"+
						"		    from   ( select loan_st, bus_id, sum(cost_cnt) cost_cnt, sum(cost_amt) cost_amt from ("+sub_query+") group by loan_st, bus_id ) "+
						"           group by loan_st " +
						"		  ) b, cont c, client d, car_reg e \n"+
						"  where  a.loan_st=b.loan_st "+
						"         and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and c.client_id=d.client_id and c.car_mng_id=e.car_mng_id(+)"+
						"  order by a.cost_st, a.cmp_dt";
				

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
			System.out.println("[CampaignDatabase:getStatBusCmpBaseBusCostList_1ch]\n"+e);
			System.out.println("[CampaignDatabase:getStatBusCmpBaseBusCostList_1ch]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}	

	/**
	 * 결과 :마감테이블 조회
	*/
	public Vector getCampaignSik_2009_06(String save_dt, String loan_st, String enter_st, String enter_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query = " select b.dept_id, b.user_nm, b.user_id, b.loan_st, c.nm_cd, "+
						" a.SAVE_DT, a.SEQ, a.BUS_ID, "+
						" to_char(to_number(a.RENT_CNT),'999.99') RENT_CNT, to_char(to_number(a.START_CNT),'999.99') START_CNT, to_char(to_number(CNT1),'999.99') CNT1, "+
						" to_char(to_number(a.R_RENT_CNT),'999.99') R_RENT_CNT, to_char(to_number(a.R_START_CNT),'999.99') R_START_CNT, to_char(to_number(R_CNT),'999.99') R_CNT, a.DAY, "+
						" to_char(to_number(a.R_CNT2),'0.99999') R_CNT2, to_char(to_number(a.PRE_CMP),'0.99999') PRE_CMP, to_char(to_number(a.PRE_CMP_GA),'0.99999') PRE_CMP_GA,  "+
						" a.C_DAY, to_char(to_number(a.CMP_DISCNT_PER),'999.99') CMP_DISCNT_PER, "+
						" to_char(to_number(a.C_RENT_CNT),'999.99') C_RENT_CNT, to_char(to_number(a.C_START_CNT),'999.99') C_START_CNT, to_char(to_number(a.C_CNT),'999.99') C_CNT, "+
						" to_char(to_number(a.CR_RENT_CNT),'999.99') CR_RENT_CNT, to_char(to_number(a.CR_START_CNT),'999.99') CR_START_CNT, to_char(to_number(a.CR_CNT),'999.99') CR_CNT, "+
						" to_char(to_number(a.DALSUNG),'999.99') DALSUNG, to_char(to_number(a.AMT)) amt, a.AVG_DALSUNG, to_char(to_number(a.AMT2)) amt2,  "+
						" a.SUM_CNT1, a.SUM_R_CNT, a.SUM_BUS, "+
						" a.AVG_CNT1, a.AVG_R_CNT, to_char(to_number(a.AVG_BUS),'0.99999') AVG_BUS, to_char(to_number(a.AVG_LOW_BUS),'0.99999') AVG_LOW_BUS,  "+
						" a.V_BS_DT, a.V_BE_DT, a.V_BS_DT2, a.V_BE_DT2, a.V_CS_DT, a.V_CE_DT, a.V_CAR_AMT,  "+
						" a.V_BUS_UP_PER, a.V_BUS_DOWN_PER, a.V_MNG_UP_PER, a.V_MNG_DOWN_PER, a.V_BUS_AMT_PER, a.V_MNG_AMT_PER, a.V_CNT1, a.V_MON, a.V_CNT2,  "+
						" a.V_CMP_DISCNT_PER, a.V_MAX_DALSUNG, a.V_BUS_GA, a.V_MNG_GA, a.V_BUS_NEW_GA, a.REG_DT, a.V_ENTER_DT, to_char(to_number(a.ORG_DALSUNG),'9999.99') ORG_DALSUNG,  "+
						" a.V_NM_CNT3, a.V_NE_DT3, a.V_NS_DT3, a.V_NB_CNT2, a.V_NM_CNT2, a.V_NE_DT2, a.V_NS_DT2, a.V_NB_CNT1, a.V_NM_CNT1, a.V_NE_DT1, a.V_NS_DT1, a.V_NB_CNT3, a.BUS_ST, "+
			            " a.DAY2, to_char(to_number(a.R_COST_CNT),'999.99') R_COST_CNT, to_char(to_number(a.C_COST_CNT),'999.99') C_COST_CNT, "+
						" to_char(to_number(a.R_CNT2_1),'0.99999') R_CNT2_1, to_char(to_number(a.R_CNT2_2),'0.99999') R_CNT2_2, "+
						" a.SUM_COST_CNT, a.SUM_BUS_1, a.SUM_BUS_2, "+
						" a.AVG_COST_CNT, to_char(to_number(a.AVG_BUS_1),'0.99999') AVG_BUS_1, to_char(to_number(a.AVG_BUS_2),'0.99999') AVG_BUS_2, "+
						" to_char(to_number(a.C_TOT_CNT),'999.99') C_TOT_CNT, a.V_CNT_PER, a.V_COST_PER, a.AVG_CAR_COST_1, a.AVG_CAR_COST_2	"+
			           " from stat_bus_cmp a, users b, (select * from code where c_st='0002') c where a.bus_id=b.user_id and b.dept_id=c.code and a.save_dt='"+save_dt+"'";

		if(enter_st.equals("n")){//신입
			if(loan_st.equals("")){
				query += " and b.enter_dt >= '"+enter_dt+"'";
			}else{
				query += " and b.loan_st='"+loan_st+"' and b.enter_dt >= '"+enter_dt+"'";
			}			
		}else{
			if(loan_st.equals("")){
				query += " and b.enter_dt < '"+enter_dt+"'";
			}else{
				query += " and b.loan_st='"+loan_st+"' and b.enter_dt < '"+enter_dt+"'";
			}				
		}

		query += " order by to_number(a.org_dalsung) desc, a.seq";

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
			System.out.println("[CampaignDatabase:getCampaignSik_2009_06(String save_dt, String loan_st, String enter_dt)]"+e);
			System.out.println("[CampaignDatabase:getCampaignSik_2009_06(String save_dt, String loan_st, String enter_dt)]"+query);
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


	//----------------------------------------------------------------------------------------------------------------------------------------
	//----------------------------------------------------------------------------------------------------------------------------------------
	// :: 통합영업캠페인 (2011-05-01부터)----------------------------------------------------------------------
	//----------------------------------------------------------------------------------------------------------------------------------------
	//---------------------------------------------------------------------

	
	/**
	 * 결과 :마감테이블 조회 - 1군(관리)
	*/
	public Vector getCampaignList_2011_05_sc2(String save_dt, String loan_st, String ns_dt, String ne_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query =  " select b.dept_id, b.user_nm, b.user_id, b.loan_st, decode(b.loan_st,'1','1군','2','2군') loan_st_nm, b.enter_dt, c.nm_cd, "+
						" a.SAVE_DT, a.SEQ, a.BUS_ID, a.RENT_CNT, a.START_CNT, a.CNT1, a.R_RENT_CNT, a.R_START_CNT, a.R_CNT, a.DAY, a.R_CNT2, a.PRE_CMP, a.PRE_CMP_GA,  "+
						" a.C_DAY, "+
						" a.C_RENT_CNT, a.C_START_CNT, "+
						" a.CR_RENT_CNT, a.CR_START_CNT, "+
						" a.SUM_CNT1, a.SUM_R_CNT, a.SUM_BUS, a.AVG_CNT1, a.AVG_R_CNT, a.AVG_BUS, a.AVG_LOW_BUS,  "+
						" a.V_BS_DT, a.V_BE_DT, a.V_BS_DT2, a.V_BE_DT2, a.V_CS_DT, a.V_CE_DT, a.V_CAR_AMT, a.V_CAR_AMT2,  "+
						" a.V_BUS_UP_PER, a.V_BUS_DOWN_PER, a.V_MNG_UP_PER, a.V_MNG_DOWN_PER, a.V_BUS_AMT_PER, a.V_MNG_AMT_PER, a.V_CNT1, a.V_MON, a.V_CNT2,  "+
						" to_char(to_number(a.C_CNT),decode(sign(1-to_number(a.C_CNT)),-1,'999.99','0.99')) C_CNT, "+
						" to_char(to_number(a.CR_CNT),decode(sign(1-to_number(a.CR_CNT)),-1,'999.99','0.99')) CR_CNT, "+
						" to_char(to_number(a.DALSUNG),decode(sign(1-to_number(a.DALSUNG)),-1,'999.99','0.99')) DALSUNG, "+
						" to_char(to_number(a.CMP_DISCNT_PER),decode(sign(1-to_number(a.CMP_DISCNT_PER)),-1,'999.99','0.99')) CMP_DISCNT_PER, "+
						" to_char(to_number(a.ORG_DALSUNG),decode(sign(1-to_number(a.ORG_DALSUNG)),-1,'999.99','0.99')) ORG_DALSUNG, "+
						" to_char(to_number(a.C_COST_CNT),decode(sign(1-to_number(a.C_COST_CNT)),-1,'999.99','0.99')) C_COST_CNT, "+
						" to_char(to_number(a.AMT)) amt, a.AVG_DALSUNG, to_char(to_number(a.AMT2)) amt2,  "+
						" a.V_CMP_DISCNT_PER, a.V_MAX_DALSUNG, a.V_BUS_GA, a.V_MNG_GA, a.V_BUS_NEW_GA, a.REG_DT, a.V_ENTER_DT, "+
						" a.V_NM_CNT3, a.V_NE_DT3, a.V_NS_DT3, a.V_NB_CNT2, a.V_NM_CNT2, a.V_NE_DT2, a.V_NS_DT2, a.V_NB_CNT1, a.V_NM_CNT1, a.V_NE_DT1, a.V_NS_DT1, a.V_NB_CNT3, a.BUS_ST, "+
			            " a.DAY2, a.R_COST_CNT, "+
						" a.C_COST_CNT as org_C_COST_CNT, "+
						" a.R_CNT2_1, a.R_CNT2_2, "+
						" a.SUM_COST_CNT, a.SUM_BUS_1, a.SUM_BUS_2, "+
						" a.AVG_COST_CNT, a.AVG_BUS_1, a.AVG_BUS_2, "+
						" to_char(to_number(a.C_TOT_CNT),decode(sign(1-to_number(a.C_TOT_CNT)),-1,'999.99','0.99')) C_TOT_CNT, "+
						" a.V_CNT_PER, a.V_COST_PER, a.AVG_CAR_COST_1, a.AVG_CAR_COST_2, a.cost_cnt1, a.cost_cnt2"+
						" from "+
						" ("+
						"		select * from stat_bus_cmp where save_dt='"+save_dt+"'"+
						" ) a, "+
						" users b, (select * from code where c_st='0002') c "+
						" where a.bus_id=b.user_id and b.dept_id=c.code and b.loan_st = '1' "+
						" ";


		if(!loan_st.equals("") && ns_dt.equals(""))		query += " and sysdate-to_date(b.enter_dt,'YYYYMMDD') >= 365 and b.loan_st='"+loan_st+"'";

		if(loan_st.equals("") && !ns_dt.equals(""))		query += " and b.enter_dt between '"+ns_dt+"' and '"+ne_dt+"'";


		query += " order by decode(sign(to_date(a.v_cs_dt,'YYYYMMDD')-add_months(to_date(b.enter_dt,'YYYYMMDD'),to_number(v_mng_f_mon))),-1,b.enter_dt,'00000000'), "+
			     "          to_number(a.org_dalsung) desc, to_number(a.C_TOT_CNT) desc, to_number(a.CMP_DISCNT_PER) desc, b.enter_dt, b.user_id";

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
			System.out.println("[CampaignDatabase:getCampaignList_2011_05_sc2(String save_dt, String loan_st, String ns_dt, String ne_dt)]"+e);
			System.out.println("[CampaignDatabase:getCampaignList_2011_05_sc2(String save_dt, String loan_st, String ns_dt, String ne_dt)]"+query);
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
	 * 결과 :마감테이블 조회 - 2군(영업)
	*/
	public Vector getCampaignList_2011_05_sc3(String save_dt, String loan_st, String ns_dt, String ne_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query =  " select b.dept_id, b.user_nm, b.user_id, b.loan_st, decode(b.loan_st,'1','1군','2','2군') loan_st_nm, b.enter_dt, c.nm_cd, "+
						" a.SAVE_DT, a.SEQ, a.BUS_ID, a.RENT_CNT, a.START_CNT, a.CNT1, a.R_RENT_CNT, a.R_START_CNT, a.R_CNT, a.DAY, a.R_CNT2, a.PRE_CMP, a.PRE_CMP_GA,  "+
						" a.C_DAY, "+
						" a.C_RENT_CNT, a.C_START_CNT, "+
						" a.CR_RENT_CNT, a.CR_START_CNT, "+
						" a.SUM_CNT1, a.SUM_R_CNT, a.SUM_BUS, a.AVG_CNT1, a.AVG_R_CNT, a.AVG_BUS, a.AVG_LOW_BUS,  "+
						" a.V_BS_DT, a.V_BE_DT, a.V_BS_DT2, a.V_BE_DT2, a.V_CS_DT, a.V_CE_DT, a.V_CAR_AMT, a.V_CAR_AMT2,  "+
						" a.V_BUS_UP_PER, a.V_BUS_DOWN_PER, a.V_MNG_UP_PER, a.V_MNG_DOWN_PER, a.V_BUS_AMT_PER, a.V_MNG_AMT_PER, a.V_CNT1, a.V_MON, a.V_CNT2,  "+
						" to_char(to_number(a.C_CNT),decode(sign(1-to_number(a.C_CNT)),-1,'999.99','0.99')) C_CNT, "+
						" to_char(to_number(a.CR_CNT),decode(sign(1-to_number(a.CR_CNT)),-1,'999.99','0.99')) CR_CNT, "+
						" to_char(to_number(a.DALSUNG),decode(sign(1-to_number(a.DALSUNG)),-1,'999.99','0.99')) DALSUNG, "+
						" to_char(to_number(a.CMP_DISCNT_PER),decode(sign(1-to_number(a.CMP_DISCNT_PER)),-1,'999.99','0.99')) CMP_DISCNT_PER, "+
						" to_char(to_number(a.ORG_DALSUNG),'999.99') ORG_DALSUNG,  "+
						" to_char(to_number(a.C_COST_CNT),decode(sign(1-to_number(a.C_COST_CNT)),-1,'999.99','0.99')) C_COST_CNT, "+
						" to_char(to_number(a.AMT)) amt, a.AVG_DALSUNG, to_char(to_number(a.AMT2)) amt2,  "+
						" a.V_CMP_DISCNT_PER, a.V_MAX_DALSUNG, a.V_BUS_GA, a.V_MNG_GA, a.V_BUS_NEW_GA, a.REG_DT, a.V_ENTER_DT, "+
						" a.V_NM_CNT3, a.V_NE_DT3, a.V_NS_DT3, a.V_NB_CNT2, a.V_NM_CNT2, a.V_NE_DT2, a.V_NS_DT2, a.V_NB_CNT1, a.V_NM_CNT1, a.V_NE_DT1, a.V_NS_DT1, a.V_NB_CNT3, a.BUS_ST, "+
			            " a.DAY2, a.R_COST_CNT, "+
						" a.C_COST_CNT as org_C_COST_CNT, "+
						" a.R_CNT2_1, a.R_CNT2_2, "+
						" a.SUM_COST_CNT, a.SUM_BUS_1, a.SUM_BUS_2, "+
						" a.AVG_COST_CNT, a.AVG_BUS_1, a.AVG_BUS_2, "+
						" to_char(to_number(a.C_TOT_CNT),decode(sign(1-to_number(a.C_TOT_CNT)),-1,'999.99','0.99')) C_TOT_CNT, "+
						" a.V_CNT_PER, a.V_COST_PER, a.AVG_CAR_COST_1, a.AVG_CAR_COST_2, a.cost_cnt1, a.cost_cnt2"+
						" from "+
						" ("+
						"		select * from stat_bus_cmp where save_dt='"+save_dt+"'"+
						" ) a, "+
						" users b, (select * from code where c_st='0002') c "+
						" where a.bus_id=b.user_id and b.dept_id=c.code and b.loan_st = '2' ";


		if(!loan_st.equals("") && ns_dt.equals(""))		query += " and sysdate-to_date(b.enter_dt,'YYYYMMDD') >= 365 and b.loan_st='"+loan_st+"'";

		if(loan_st.equals("") && !ns_dt.equals(""))		query += " and b.enter_dt between '"+ns_dt+"' and '"+ne_dt+"'";


		query += " order by decode(a.CMP_DISCNT_PER,'',1,0), decode(a.org_dalsung,0,2,'',2,1), "+
			     "          to_number(a.org_dalsung) desc, "+
				 "	        to_number(a.C_TOT_CNT) desc, "+
				 "          to_number(a.CMP_DISCNT_PER) desc, b.enter_dt, b.user_id";

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
			System.out.println("[CampaignDatabase:getCampaignList_2011_05_sc3(String save_dt, String loan_st, String ns_dt, String ne_dt)]"+e);
			System.out.println("[CampaignDatabase:getCampaignList_2011_05_sc3(String save_dt, String loan_st, String ns_dt, String ne_dt)]"+query);
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
	 * 결과 :마감테이블 조회
	*/
	public Hashtable getCampaignCase_2011_05(String save_dt, String bus_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();

		String query =  " select b.dept_id, b.user_nm, b.user_id, b.loan_st, c.nm_cd, "+
						"		 a.SAVE_DT, a.SEQ, a.BUS_ID, "+
						"		 to_char(to_number(a.RENT_CNT),'999.99') RENT_CNT, to_char(to_number(a.START_CNT),'999.99') START_CNT, to_char(to_number(CNT1),'999.99') CNT1, "+
						"		 to_char(to_number(a.R_RENT_CNT),'999.99') R_RENT_CNT, to_char(to_number(a.R_START_CNT),'999.99') R_START_CNT, to_char(to_number(R_CNT),'999.99') R_CNT, a.DAY, "+
						"		 to_char(to_number(a.R_CNT2),'0.99999') R_CNT2, to_char(to_number(a.PRE_CMP),'0.99999') PRE_CMP, to_char(to_number(a.PRE_CMP_GA),'0.99999') PRE_CMP_GA,  "+
						"		 a.C_DAY, to_char(to_number(a.CMP_DISCNT_PER),'999.99') CMP_DISCNT_PER, "+
						"		 to_char(to_number(a.C_RENT_CNT),'999.99') C_RENT_CNT, to_char(to_number(a.C_START_CNT),'999.99') C_START_CNT, to_char(to_number(a.C_CNT),'999.99') C_CNT, "+
						"		 to_char(to_number(a.CR_RENT_CNT),'999.99') CR_RENT_CNT, to_char(to_number(a.CR_START_CNT),'999.99') CR_START_CNT, to_char(to_number(a.CR_CNT),'999.99') CR_CNT, "+
						"		 to_char(to_number(a.DALSUNG),'999.99') DALSUNG, to_char(to_number(a.AMT)) amt, a.AVG_DALSUNG, to_char(to_number(a.AMT2)) amt2,  "+
						"		 a.SUM_CNT1, a.SUM_R_CNT, a.SUM_BUS, "+
						"		 a.AVG_CNT1, a.AVG_R_CNT, to_char(to_number(a.AVG_BUS),'0.99999') AVG_BUS, to_char(to_number(a.AVG_LOW_BUS),'0.99999') AVG_LOW_BUS,  "+
						"		 a.V_BS_DT, a.V_BE_DT, a.V_BS_DT2, a.V_BE_DT2, a.V_CS_DT, a.V_CE_DT, a.V_CAR_AMT,  "+
						"		 a.V_BUS_UP_PER, a.V_BUS_DOWN_PER, a.V_MNG_UP_PER, a.V_MNG_DOWN_PER, a.V_BUS_AMT_PER, a.V_MNG_AMT_PER, a.V_CNT1, a.V_MON, a.V_CNT2,  "+
						"		 a.V_CMP_DISCNT_PER, a.V_MAX_DALSUNG, a.V_BUS_GA, a.V_MNG_GA, a.V_BUS_NEW_GA, a.REG_DT, a.V_ENTER_DT, to_char(to_number(a.ORG_DALSUNG),'999.99') ORG_DALSUNG,  "+
						"		 a.V_NM_CNT3, a.V_NE_DT3, a.V_NS_DT3, a.V_NB_CNT2, a.V_NM_CNT2, a.V_NE_DT2, a.V_NS_DT2, a.V_NB_CNT1, a.V_NM_CNT1, a.V_NE_DT1, a.V_NS_DT1, a.V_NB_CNT3, a.BUS_ST, "+
			            "		 a.DAY2, to_char(to_number(a.R_COST_CNT),'999.99') R_COST_CNT, to_char(to_number(a.C_COST_CNT),'999.99') C_COST_CNT, "+
						"		 to_char(to_number(a.R_CNT2_1),'0.99999') R_CNT2_1, to_char(to_number(a.R_CNT2_2),'0.99999') R_CNT2_2, "+
						"		 a.SUM_COST_CNT, a.SUM_BUS_1, a.SUM_BUS_2, "+
						"		 a.AVG_COST_CNT, to_char(to_number(a.AVG_BUS_1),'0.99999') AVG_BUS_1, to_char(to_number(a.AVG_BUS_2),'0.99999') AVG_BUS_2, "+
						"		 to_char(to_number(a.C_TOT_CNT),'999.99') C_TOT_CNT, a.V_CNT_PER, a.V_COST_PER, a.AVG_CAR_COST_1, a.AVG_CAR_COST_2	"+
			            " from   stat_bus_cmp a, users b, (select * from code where c_st='0002') c where a.bus_id=b.user_id and b.dept_id=c.code "+
						" and    a.save_dt='"+save_dt+"' and a.bus_id='"+bus_id+"'";


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next())
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
			System.out.println("[CampaignDatabase:getCampaignCase_2011_05(String save_dt, String bus_id)]"+e);
			System.out.println("[CampaignDatabase:getCampaignCase_2011_05(String save_dt, String bus_id)]"+query);
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
	 * 결과 :마감테이블 조회
	*/
	public Vector getCampaignSik_2011_05(String save_dt, String loan_st, String enter_st, String enter_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query = " select b.dept_id, b.user_nm, b.user_id, b.loan_st, c.nm_cd, "+
						" a.SAVE_DT, a.SEQ, a.BUS_ID, "+
						" to_char(to_number(a.RENT_CNT),'999.99') RENT_CNT, to_char(to_number(a.START_CNT),'999.99') START_CNT, to_char(to_number(CNT1),'999.99') CNT1, "+
						" to_char(to_number(a.R_RENT_CNT),'999.99') R_RENT_CNT, to_char(to_number(a.R_START_CNT),'999.99') R_START_CNT, to_char(to_number(R_CNT),'999.99') R_CNT, a.DAY, "+
						" to_char(to_number(a.R_CNT2),'0.99999') R_CNT2, to_char(to_number(a.PRE_CMP),'0.99999') PRE_CMP, to_char(to_number(a.PRE_CMP_GA),'0.99999') PRE_CMP_GA,  "+
						" a.C_DAY, to_char(to_number(a.CMP_DISCNT_PER),'999.99') CMP_DISCNT_PER, "+
						" to_char(to_number(a.C_RENT_CNT),'999.99') C_RENT_CNT, to_char(to_number(a.C_START_CNT),'999.99') C_START_CNT, to_char(to_number(a.C_CNT),'999.99') C_CNT, "+
						" to_char(to_number(a.CR_RENT_CNT),'999.99') CR_RENT_CNT, to_char(to_number(a.CR_START_CNT),'999.99') CR_START_CNT, to_char(to_number(a.CR_CNT),'999.99') CR_CNT, "+
						" to_char(to_number(a.DALSUNG),'999.99') DALSUNG, to_char(to_number(a.AMT)) amt, a.AVG_DALSUNG, to_char(to_number(a.AMT2)) amt2,  "+
						" a.SUM_CNT1, a.SUM_R_CNT, a.SUM_BUS, "+
						" a.AVG_CNT1, a.AVG_R_CNT, to_char(to_number(a.AVG_BUS),'0.99999') AVG_BUS, to_char(to_number(a.AVG_LOW_BUS),'0.99999') AVG_LOW_BUS,  "+
						" a.V_BS_DT, a.V_BE_DT, a.V_BS_DT2, a.V_BE_DT2, a.V_CS_DT, a.V_CE_DT, a.V_CAR_AMT,  "+
						" a.V_BUS_UP_PER, a.V_BUS_DOWN_PER, a.V_MNG_UP_PER, a.V_MNG_DOWN_PER, a.V_BUS_AMT_PER, a.V_MNG_AMT_PER, a.V_CNT1, a.V_MON, a.V_CNT2,  "+
						" a.V_CMP_DISCNT_PER, a.V_MAX_DALSUNG, a.V_BUS_GA, a.V_MNG_GA, a.V_BUS_NEW_GA, a.REG_DT, a.V_ENTER_DT, to_char(to_number(a.ORG_DALSUNG),'9999.99') ORG_DALSUNG,  "+
						" a.V_NM_CNT3, a.V_NE_DT3, a.V_NS_DT3, a.V_NB_CNT2, a.V_NM_CNT2, a.V_NE_DT2, a.V_NS_DT2, a.V_NB_CNT1, a.V_NM_CNT1, a.V_NE_DT1, a.V_NS_DT1, a.V_NB_CNT3, a.BUS_ST, "+
			            " a.DAY2, to_char(to_number(a.R_COST_CNT),'999.99') R_COST_CNT, to_char(to_number(a.C_COST_CNT),'999.99') C_COST_CNT, "+
						" to_char(to_number(a.R_CNT2_1),'0.99999') R_CNT2_1, to_char(to_number(a.R_CNT2_2),'0.99999') R_CNT2_2, "+
						" a.SUM_COST_CNT, a.SUM_BUS_1, a.SUM_BUS_2, "+
						" a.AVG_COST_CNT, to_char(to_number(a.AVG_BUS_1),'0.99999') AVG_BUS_1, to_char(to_number(a.AVG_BUS_2),'0.99999') AVG_BUS_2, "+
						" to_char(to_number(a.C_TOT_CNT),'999.99') C_TOT_CNT, a.V_CNT_PER, a.V_COST_PER, a.AVG_CAR_COST_1, a.AVG_CAR_COST_2	"+
			           " from stat_bus_cmp a, users b, (select * from code where c_st='0002') c where a.bus_id=b.user_id and b.dept_id=c.code and a.save_dt='"+save_dt+"'";

		if(!loan_st.equals("")){
			query += " and b.loan_st='"+loan_st+"' ";
		}

		if(enter_st.equals("n")){//신입
				query += " and decode(b.user_id,'000136','20100601',b.enter_dt) >= '"+enter_dt+"'";
		}else{
				query += " and decode(b.user_id,'000136','20100601',b.enter_dt) < '"+enter_dt+"'";
		}

		query += " order by decode(a.org_dalsung,0,2,'',2,1), to_number(a.org_dalsung) desc, a.seq";

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
			System.out.println("[CampaignDatabase:getCampaignSik_2011_05(String save_dt, String loan_st, String enter_dt)]"+e);
			System.out.println("[CampaignDatabase:getCampaignSik_2011_05(String save_dt, String loan_st, String enter_dt)]"+query);
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
	*	변수등록
	*/
	public int insertVar_2011_05(String year, String tm, String cs_dt, String ce_dt, String bs_dt, String be_dt, String bs_dt2, String be_dt2, int amt, int bus_up_per, int bus_down_per, int mng_up_per, int mng_down_per, int bus_amt_per, int mng_amt_per, int new_bus_up_per, int new_bus_down_per, int new_bus_amt_per, int cnt1, int mon, String cnt2, float cmp_discnt_per, int car_amt, int max_dalsung, int bus_ga, int mng_ga, int bus_new_ga, String enter_dt, String ns_dt1, String ns_dt2, String ns_dt3, String ns_dt4, String ne_dt1, String ne_dt2, String ne_dt3, String ne_dt4, int nm_cnt1, int nm_cnt2, int nm_cnt3, int nm_cnt4, int nb_cnt1, int nb_cnt2, int nb_cnt3, int nb_cnt4, int cnt_per, int cost_per, int car_amt2, int cnt_per2, int cost_per2, int max_dalsung2, int mng_new_ga, String base_end_dt1, String base_end_dt2, int mng_f_per, int bus_f_per, int mng_f_mon, int bus_f_mon){

		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;

		String query = "insert into campaign "+
			" (  cs_dt, ce_dt, bs_dt, be_dt, "+
			"	 amt, bus_up_per, bus_down_per, "+
			"    mng_up_per, mng_down_per, bus_amt_per, mng_amt_per, "+
			"	 new_bus_up_per, new_bus_down_per, new_bus_amt_per, "+
			"	 cnt1, mon, cnt2, cmp_discnt_per, car_amt, "+
			"	 bs_dt2, be_dt2, max_dalsung, "+
			"	 bus_ga, mng_ga, bus_new_ga, enter_dt, "+
			"	 ns_dt1, ns_dt2, ns_dt3, ne_dt1, ne_dt2, ne_dt3, nm_cnt1, nm_cnt2, nm_cnt3, nb_cnt1, nb_cnt2, nb_cnt3,"+
			"    ns_dt4, ne_dt4, nm_cnt4, nb_cnt4, year, tm, cnt_per, cost_per, "+
			"    car_amt2, cnt_per2, cost_per2, max_dalsung2, mng_new_ga, base_end_dt1, base_end_dt2, mng_f_per, bus_f_per, mng_f_mon, bus_f_mon) "+
			" values "+
			" (  ?, ?, ?, ?, ?,  ?, ?, ?, ?, ?, "+
			"    ?, ?, ?, ?, ?,  ?, ?, ?, ?, ?, "+	
			"    ?, ?, ?, ?, ?,  ?, ?, ?, ?, ?, "+	
			"    ?, ?, ?, ?, ?,  ?, ?, ?, ?, ?, "+	
			"    ?, ?, ?, ?, ?,  ?, ?, ?, ?, ?, "+
			"    ?, ?, ?, ?, ?, ?, ?  "+	
			" )";

		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString (1, cs_dt);
			pstmt.setString (2, ce_dt);
			pstmt.setString (3, bs_dt);
			pstmt.setString (4, be_dt);
			pstmt.setInt	(5, amt);
			pstmt.setInt	(6, bus_up_per);
			pstmt.setInt	(7, bus_down_per);
			pstmt.setInt	(8, mng_up_per);
			pstmt.setInt	(9, mng_down_per);
			pstmt.setInt	(10, bus_amt_per);
			pstmt.setInt	(11, mng_amt_per);
			pstmt.setInt	(12, new_bus_up_per);
			pstmt.setInt	(13, new_bus_down_per);
			pstmt.setInt	(14, new_bus_amt_per);
			pstmt.setInt	(15, cnt1);
			pstmt.setInt	(16, mon);
			pstmt.setString (17, cnt2);
			pstmt.setFloat	(18, cmp_discnt_per);
			pstmt.setInt	(19, car_amt);
			pstmt.setString	(20, bs_dt2);
			pstmt.setString	(21, be_dt2);
			pstmt.setInt(22, max_dalsung);
			pstmt.setInt(23, bus_ga);
			pstmt.setInt(24, mng_ga);
			pstmt.setInt(25, bus_new_ga);
			pstmt.setString	(26, enter_dt);
			pstmt.setString	(27, ns_dt1);
			pstmt.setString	(28, ns_dt2);
			pstmt.setString	(29, ns_dt3);
			pstmt.setString	(30, ne_dt1);
			pstmt.setString	(31, ne_dt2);
			pstmt.setString	(32, ne_dt3);
			pstmt.setInt	(33, nm_cnt1);
			pstmt.setInt	(34, nm_cnt2);
			pstmt.setInt	(35, nm_cnt3);
			pstmt.setInt	(36, nb_cnt1);
			pstmt.setInt	(37, nb_cnt2);
			pstmt.setInt	(38, nb_cnt3);
			pstmt.setString	(39, ns_dt4);
			pstmt.setString	(40, ne_dt4);
			pstmt.setInt	(41, nm_cnt4);
			pstmt.setInt	(42, nb_cnt4);
			pstmt.setString	(43, year);
			pstmt.setString	(44, tm);
			pstmt.setInt	(45, cnt_per);
			pstmt.setInt	(46, cost_per);

			pstmt.setInt	(47, car_amt2);
			pstmt.setInt	(48, cnt_per2);
			pstmt.setInt	(49, cost_per2);
			pstmt.setInt    (50, max_dalsung2);
			pstmt.setInt    (51, bus_new_ga);

			pstmt.setString	(52, base_end_dt1);
			pstmt.setString	(53, base_end_dt2);

			pstmt.setInt	(54, mng_f_per);
			pstmt.setInt	(55, bus_f_per);

			pstmt.setInt	(56, mng_f_mon);
			pstmt.setInt	(57, bus_f_mon);

			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		}catch(SQLException e){
			System.out.println("[CampaignDatabase:insertVar_2011_05]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return result;
		}
	}

	/**
	*	변수수정 - 1군(관리)
	*/
	
	public int updateVar2_2011_05(String year, String tm, String cs_dt, String ce_dt, String bs_dt2, String be_dt2, int amt, int mng_up_per, int mng_down_per, int mng_amt_per, int new_bus_up_per, int new_bus_down_per, int new_bus_amt_per, int cnt1, int mon, String cnt2, float cmp_discnt_per, int car_amt2, int max_dalsung2,  int mng_ga, int mng_new_ga, String enter_dt, String ns_dt1, String ns_dt2, String ns_dt3, String ns_dt4, String ne_dt1, String ne_dt2, String ne_dt3, String ne_dt4, int nm_cnt1, int nm_cnt2, int nm_cnt3, int nm_cnt4, int cnt_per2, int cost_per2, String base_end_dt1, String base_end_dt2, int mng_f_per, int mng_f_mon){

		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = " UPDATE campaign SET "+
							    " cs_dt=?, ce_dt=?, amt=?, mng_up_per=?, mng_down_per=?,  mng_amt_per=? "+  //6
								", new_bus_up_per=?, new_bus_down_per=?, new_bus_amt_per=? "+  //3
								", cnt1=?, mon=?, cnt2=?, cmp_discnt_per=?, car_amt2=? "+  //5
								", bs_dt2=?, be_dt2=?, max_dalsung2=? , mng_ga=?, mng_new_ga=?, enter_dt=? "+ //6
								", ns_dt1=?, ns_dt2=?, ns_dt3=?, ne_dt1=?, ne_dt2=?, ne_dt3=?, nm_cnt1=?, nm_cnt2=?, nm_cnt3=? "+  //9
								", ns_dt4=?, ne_dt4=?, nm_cnt4=?, cnt_per2=?, cost_per2=?, base_end_dt1=?, base_end_dt2=?, mng_f_per=?, mng_f_mon=? "+  //5
						" WHERE year=? and tm=? ";
			
		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, cs_dt);
			pstmt.setString(2, ce_dt);
			pstmt.setInt   (3, amt);		
			pstmt.setInt   (4, mng_up_per);
			pstmt.setInt   (5, mng_down_per);		
			pstmt.setInt   (6, mng_amt_per);
			
			pstmt.setInt   (7, new_bus_up_per);
			pstmt.setInt   (8, new_bus_down_per);
			pstmt.setInt   (9, new_bus_amt_per);
			
			
			pstmt.setInt   (10, cnt1);
			pstmt.setInt   (11, mon);
			pstmt.setString(12, cnt2);
			pstmt.setFloat (13, cmp_discnt_per);
			pstmt.setInt   (14, car_amt2);
			
			pstmt.setString(15, bs_dt2);
			pstmt.setString(16, be_dt2);
			pstmt.setInt   (17, max_dalsung2);
			pstmt.setInt   (18, mng_ga);
			pstmt.setInt   (19, mng_new_ga);
			pstmt.setString(20, enter_dt);
			
			pstmt.setString(21, ns_dt1);
			pstmt.setString(22, ns_dt2);
			pstmt.setString(23, ns_dt3);
			pstmt.setString(24, ne_dt1);
			pstmt.setString(25, ne_dt2);
			pstmt.setString(26, ne_dt3);
			pstmt.setInt   (27, nm_cnt1);
			pstmt.setInt   (28, nm_cnt2);
			pstmt.setInt   (29, nm_cnt3);
			
			pstmt.setString(30, ns_dt4);
			pstmt.setString(31, ne_dt4);
			pstmt.setInt   (32, nm_cnt4);		
			pstmt.setInt   (33, cnt_per2);
			pstmt.setInt   (34, cost_per2);
			
			pstmt.setString(35, base_end_dt1);
			pstmt.setString(36, base_end_dt2);

			pstmt.setInt   (37, mng_f_per);
			pstmt.setInt   (38, mng_f_mon);

			pstmt.setString(39, year);
			pstmt.setString(40, tm);

			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		}catch(SQLException e){
			System.out.println("[CampaignDatabase:updateVar2_2011_05]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return result;
		}
	}

	
	/**
	*	변수수정 - 2군
	*/
	
	public int updateVar3_2011_05(String year, String tm, String cs_dt, String ce_dt, String bs_dt, String be_dt, int amt, int bus_up_per, int bus_down_per,  int bus_amt_per,  int new_bus_up_per, int new_bus_down_per, int new_bus_amt_per, int cnt1, int mon, String cnt2, float cmp_discnt_per, int car_amt, int max_dalsung, int bus_ga,  int bus_new_ga, String enter_dt, String ns_dt1, String ns_dt2, String ns_dt3, String ns_dt4, String ne_dt1, String ne_dt2, String ne_dt3, String ne_dt4, int nb_cnt1, int nb_cnt2, int nb_cnt3, int nb_cnt4, int cnt_per, int cost_per, String base_end_dt1, String base_end_dt2, int bus_f_per, int bus_f_mon){

		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query =  "UPDATE campaign SET "+
						"      cs_dt=?, ce_dt=?, bs_dt=?, be_dt=? "+  //4
						"	 , amt=?, bus_up_per=?, bus_down_per=? "+  //3
						"    , bus_amt_per=?, new_bus_up_per=?, new_bus_down_per=?, new_bus_amt_per=? "+  //4
						"	 , cnt1=?, mon=?, cnt2=?, cmp_discnt_per=?, car_amt=? , max_dalsung=? "+  //6
						"	 , bus_ga=?, bus_new_ga=?, enter_dt=? "+  //3
						"	 , ns_dt1=?, ns_dt2=?, ns_dt3=?, ne_dt1=?, ne_dt2=?, ne_dt3=?, nb_cnt1=?, nb_cnt2=?, nb_cnt3=?"+  //9
						"    , ns_dt4=?, ne_dt4=?, nb_cnt4=?, cnt_per=?, cost_per=?, base_end_dt1=?, base_end_dt2=?, bus_f_per=?, bus_f_mon=? "+ //5
						" WHERE year=? and tm=? ";  //2

		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, cs_dt);
			pstmt.setString(2, ce_dt);
			pstmt.setString(3, bs_dt);
			pstmt.setString(4, be_dt);
			
			pstmt.setInt   (5, amt);
			pstmt.setInt   (6, bus_up_per);
			pstmt.setInt   (7, bus_down_per);
			
			pstmt.setInt   (8, bus_amt_per);
			pstmt.setInt   (9, new_bus_up_per);
			pstmt.setInt   (10, new_bus_down_per);
			pstmt.setInt   (11, new_bus_amt_per);
			
			pstmt.setInt   (12, cnt1);
			pstmt.setInt   (13, mon);
			pstmt.setString(14, cnt2);
			pstmt.setFloat (15, cmp_discnt_per);
			pstmt.setInt   (16, car_amt);
			pstmt.setInt   (17, max_dalsung);
			
			pstmt.setInt   (18, bus_ga);
			pstmt.setInt   (19, bus_new_ga);
			pstmt.setString(20, enter_dt);
			
			pstmt.setString(21, ns_dt1);
			pstmt.setString(22, ns_dt2);
			pstmt.setString(23, ns_dt3);
			pstmt.setString(24, ne_dt1);
			pstmt.setString(25, ne_dt2);
			pstmt.setString(26, ne_dt3);
			pstmt.setInt   (27, nb_cnt1);
			pstmt.setInt   (28, nb_cnt2);
			pstmt.setInt   (29, nb_cnt3);
			
			pstmt.setString(30, ns_dt4);
			pstmt.setString(31, ne_dt4);
			pstmt.setInt   (32, nb_cnt4);
			pstmt.setInt   (33, cnt_per);
			pstmt.setInt   (34, cost_per);
			
			pstmt.setString(35, base_end_dt1);
			pstmt.setString(36, base_end_dt2);

			pstmt.setInt   (37, bus_f_per);
			pstmt.setInt   (38, bus_f_mon);

			pstmt.setString(39, year);
			pstmt.setString(40, tm);

			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		}catch(SQLException e){
			System.out.println("[CampaignDatabase:updateVar3_2011_05]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return result;
		}
	}

	/**
	 * 영업실적 마감 데이타 담당자별 리스트 조회
	 */
	public Vector getStatBusCmpBaseBusList_20110824(String bus_id, String mode, String bs_dt, String be_dt, String cs_dt, String ce_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
    	String query = "";
    	String query1 = "";
    	String query2 = "";
    	String query3 = "";
    	String where2 = "";
    	String where3 = "";

    	String where = " a.bs_dt=replace('"+bs_dt+"','-','') and a.ce_dt=replace('"+ce_dt+"','-','') and a.bus_id='"+bus_id+"' and nvl(a.cls_st,'0') not in ('4','5')  \n";


		if(mode.equals("b")) where2 = " and (a.rent_dt <= replace('"+be_dt+"','-','') or a.rent_start_dt <= replace('"+be_dt+"','-','')) \n";
		if(mode.equals("c")) where2 = " and (a.rent_dt > replace('"+be_dt+"','-','') or a.rent_start_dt > replace('"+be_dt+"','-','')) \n";

		//정상계약
		query1 = " select '1' st, \n"+
				 "        a.cnt3 as c_cnt3,		\n"+
				"         a.cnt4 as c_cnt4,		\n"+
				 "        a.v_cnt3 as r_cnt3,	\n"+
				"         a.v_cnt4 as r_cnt4,	\n"+
				 "        a.*  \n"+
				 " from   stat_bus_cmp_base a  \n"+
				 " where  "+where+" "+where2+" and a.con_mon>=6 \n"+
				 " ";

		//6개월미만 계약, 실경과월 6개월 이상
		query2 = " select '2' st,  \n"+
				 "        case when a.use_mon > 11 then '1' else '.5' end c_cnt3, \n"+
				 "        case when a.use_mon > 11 then '1' else '.5' end c_cnt4, \n"+
				 "        case when a.use_mon > 11 then '1' else '.5' end r_cnt3, \n"+
				 "        case when a.use_mon > 11 then '1' else '.5' end r_cnt4, \n"+
				 "        a.*  \n"+
				 " from   stat_bus_cmp_base a  \n"+
				 " where  "+where+" "+where3+" and a.con_mon<6 and a.use_mon>=6  \n"+
				 "        and to_char(add_months(to_date(a.rent_start_dt,'YYYYMMDD'),6),'YYYYMMDD') between '"+cs_dt+"' and '"+ce_dt+"' \n" ;

		//6개월이상 계약, 실경과월 6개월 미만(해지)
		query3 = " select '3' st,  \n"+
				 "        case when a.con_mon > 11 then '-1' else '-.5' end as c_cnt3, \n"+
				"         decode(a.rent_start_dt,'','0',case when a.con_mon > 11 then '-1' else '-.5' end) as c_cnt4, \n"+
				 "        case when a.con_mon > 11 then '-1' else '-.5' end as r_cnt3, \n"+
				"         decode(a.rent_start_dt,'','0',case when a.con_mon > 11 then '-1' else '-.5' end) as r_cnt4, \n"+
				 "        a.*  \n"+
				 " from   stat_bus_cmp_base a  \n"+
				 " where  "+where+" "+where3+" and a.con_mon>=6 and a.use_mon<6 and nvl(a.cls_st,'0') not in ('8')\n"+
				 "        and a.cls_dt between '"+cs_dt+"' and '"+ce_dt+"'  \n" ;


		query =	" select \n"+
				"      a.*,  \n"+
				"      a.c_cnt3 as cc_cnt3,  \n"+
				"      a.c_cnt4 as cc_cnt4,  \n"+
				"      a.r_cnt3 as rr_cnt3,  \n"+
				"      a.r_cnt4 as rr_cnt4,  \n"+
				"      b.firm_nm, decode(a.bus_st,'1',d.user_nm) as bus_nm,  \n"+
				"	   decode(a.bus_st,'1',e.user_nm,'2',d.user_nm) as bus_agnt_nm,  \n"+
				"	   decode(a.bus_st,'1',g.user_nm,'3',d.user_nm) as bus_nm2,  \n"+
				"      decode(a.st,'3','해지',decode(a.rent_st,'1',decode(c.car_gu,'0','재리스',decode(c.rent_st,'1','신규','3','대차','4','증차')),'연장')) gubun,  \n"+
				"      decode(a.bus_st,'1','주','부') gubun2,  \n"+
				"      nvl(f.ext_agnt,c.bus_id) f_bus_id  \n"+
				" from  \n"+
				"      ( "+query1+" union all "+query2+" union all "+query3+" )  a, \n"+
				"	   client b, cont c, users d, users e, fee f, users g  \n"+
				" where  \n"+
				       where+
				"      and a.client_id=b.client_id and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and a.bus_id=d.user_id(+) and a.bus_agnt_id=e.user_id(+) \n"+
				"	   and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd and a.rent_st=f.rent_st and a.bus_id2=g.user_id(+) \n"+
				" order by a.st, decode(a.cls_dt,'',0,1), a.cls_dt, b.firm_nm, a.rent_dt, a.rent_start_dt, a.rent_mng_id \n";
				


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
			System.out.println("[CampaignDatabase:getStatBusCmpBaseBusList_20110824]\n"+e);
			System.out.println("[CampaignDatabase:getStatBusCmpBaseBusList_20110824]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}	

	/**
	 * 영업실적 마감 데이타 담당자별 리스트 조회
	 */
	public Vector getStatBusCmpBaseBusList_20111101(String bus_id, String mode, String bs_dt, String be_dt, String cs_dt, String ce_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
    	String query = "";
    	String query1 = "";
    	String query2 = "";
    	String query3 = "";
		String query4 = "";
    	String where2 = "";
    	String where3 = "";

    	String where = " a.bs_dt=replace('"+bs_dt+"','-','') and a.ce_dt=replace('"+ce_dt+"','-','') and a.bus_id='"+bus_id+"' and nvl(a.cls_st,'0') not in ('4','5')  \n";


		if(mode.equals("b")) where2 = " and (a.rent_dt <= replace('"+be_dt+"','-','') or a.rent_start_dt <= replace('"+be_dt+"','-','')) \n";
		if(mode.equals("c")) where2 = " and (a.rent_dt > replace('"+be_dt+"','-','') or a.rent_start_dt > replace('"+be_dt+"','-','')) \n";

		//정상계약
		query1 = " select '1' st, \n"+
				 "        a.cnt3   as c_cnt3,		\n"+
				"         a.cnt4   as c_cnt4,		\n"+
				 "        a.v_cnt3 as r_cnt3,	\n"+
				"         a.v_cnt4 as r_cnt4,	\n"+
				 "        a.*  \n"+
				 " from   stat_bus_cmp_base a  \n"+
				 " where  "+where+" "+where2+" and a.con_mon>=6 \n"+
				 " ";

		//6개월미만 계약, 실경과월 6개월 이상
		query2 = " select '2' st,  \n"+
				 "        case when a.use_mon > 11 then '1' else '.5' end c_cnt3, \n"+
				 "        case when a.use_mon > 11 then '1' else '.5' end c_cnt4, \n"+
				 "        case when a.use_mon > 11 then '1' else '.5' end r_cnt3, \n"+
				 "        case when a.use_mon > 11 then '1' else '.5' end r_cnt4, \n"+
				 "        a.*  \n"+
				 " from   stat_bus_cmp_base a  \n"+
				 " where  "+where+" "+where3+" and a.con_mon<6 and a.use_mon>=6  \n"+
				 "        and to_char(add_months(to_date(a.rent_start_dt,'YYYYMMDD'),6),'YYYYMMDD') between '"+cs_dt+"' and '"+ce_dt+"' \n" ;

		//6개월이상 계약, 실경과월 6개월 미만(해지) - 기준기간에 계약
		query3 = " select '3' st,  \n"+
				 "        '-'||a.cnt1 as c_cnt3, \n"+
				"         decode(a.rent_start_dt,'','0','-'||a.cnt2) as c_cnt4, \n"+
				 "        '-'||a.v_cnt1 as r_cnt3, \n"+
				"         decode(a.rent_start_dt,'','0','-'||a.v_cnt2) as r_cnt4, \n"+
				 "        a.*  \n"+
				 " from   stat_bus_cmp_base a  \n"+
				 " where  "+where+" "+where3+" and a.con_mon>=6 and a.use_mon<6 and nvl(a.cls_st,'0') not in ('8')\n"+
				 "        and a.cls_dt between '"+cs_dt+"' and '"+ce_dt+"'  \n"+
				 "        and (a.rent_dt < replace('"+cs_dt+"','-','') or a.rent_start_dt < replace('"+cs_dt+"','-','')) \n";


		//6개월이상 계약, 실경과월 6개월 미만(해지) - 캠페인기간에 계약
		query4 = " select '3' st,  \n"+
				 "        '-'||a.cnt3 as c_cnt3, \n"+
				"         decode(a.rent_start_dt,'','0','-'||a.cnt4) as c_cnt4, \n"+
				 "        '-'||a.v_cnt3 as r_cnt3, \n"+
				"         decode(a.rent_start_dt,'','0','-'||a.v_cnt4) as r_cnt4, \n"+
				 "        a.*  \n"+
				 " from   stat_bus_cmp_base a  \n"+
				 " where  "+where+" "+where3+" and a.con_mon>=6 and a.use_mon<6 and nvl(a.cls_st,'0') not in ('8')\n"+
				 "        and a.cls_dt between '"+cs_dt+"' and '"+ce_dt+"'  \n"+
				 "        and (a.rent_dt > replace('"+be_dt+"','-','') or a.rent_start_dt > replace('"+be_dt+"','-','')) \n";


		query =	" select \n"+
				"      a.*,  \n"+
				"      a.c_cnt3 as cc_cnt3,  \n"+
				"      a.c_cnt4 as cc_cnt4,  \n"+
				"      a.r_cnt3 as rr_cnt3,  \n"+
				"      a.r_cnt4 as rr_cnt4,  \n"+
				"      b.firm_nm, decode(a.bus_st,'1',d.user_nm) as bus_nm,  \n"+
				"	   decode(a.bus_st,'1',e.user_nm,'2',d.user_nm) as bus_agnt_nm,  \n"+
				"	   decode(a.bus_st,'1',g.user_nm,'3',d.user_nm) as bus_nm2,  \n"+
				"      decode(a.st,'3','해지',decode(a.rent_st,'1',decode(c.car_gu,'0','재리스',decode(c.rent_st,'1','신규','3','대차','4','증차')),'연장')) gubun,  \n"+
				"      decode(a.bus_st,'1','주','부') gubun2,  \n"+
				"      nvl(f.ext_agnt,c.bus_id) f_bus_id  \n"+
				" from  \n"+
				"      ( "+query1+" union all "+query2+" union all "+query3+"  union all "+query4+" )  a, \n"+
				"	   client b, cont c, users d, users e, fee f, users g  \n"+
				" where  \n"+
				       where+
				"      and a.client_id=b.client_id and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and a.bus_id=d.user_id(+) and a.bus_agnt_id=e.user_id(+) \n"+
				"	   and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd and a.rent_st=f.rent_st and a.bus_id2=g.user_id(+) \n"+
				" order by a.st, decode(a.cls_dt,'',0,1), a.cls_dt, b.firm_nm, a.rent_dt, a.rent_start_dt, a.rent_mng_id \n";
				


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
			System.out.println("[CampaignDatabase:getStatBusCmpBaseBusList_20111101]\n"+e);
			System.out.println("[CampaignDatabase:getStatBusCmpBaseBusList_20111101]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}	


	//----------------------------------------------------------------------------------------------------------------------------------------
	//----------------------------------------------------------------------------------------------------------------------------------------
	// :: 통합영업캠페인 (2012-05-01부터)----------------------------------------------------------------------
	//----------------------------------------------------------------------------------------------------------------------------------------
	//---------------------------------------------------------------------

	
	/**
	 * 결과 :마감테이블 조회 - 1군(관리)
	*/
	public Vector getCampaignList_2012_05_sc2(String save_dt, String loan_st, String ns_dt, String ne_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query =  " select b.dept_id, b.user_nm, b.user_id, b.loan_st, decode(b.loan_st,'1','1군','2','2군') loan_st_nm, b.enter_dt, c.nm_cd, "+
						" a.SAVE_DT, a.SEQ, a.BUS_ID, a.RENT_CNT, a.START_CNT, a.CNT1, a.R_RENT_CNT, a.R_START_CNT, a.R_CNT, a.DAY, a.R_CNT2, a.PRE_CMP, a.PRE_CMP_GA,  "+
						" a.C_DAY, "+
						" a.C_RENT_CNT, a.C_START_CNT, "+
						" a.CR_RENT_CNT, a.CR_START_CNT, "+
						" a.SUM_CNT1, a.SUM_R_CNT, a.SUM_BUS, a.AVG_CNT1, a.AVG_R_CNT, a.AVG_BUS, a.AVG_LOW_BUS,  "+
						" a.V_BS_DT, a.V_BE_DT, a.V_BS_DT2, a.V_BE_DT2, a.V_CS_DT, a.V_CE_DT, a.V_CAR_AMT, a.V_CAR_AMT2,  "+
						" a.V_BUS_UP_PER, a.V_BUS_DOWN_PER, a.V_MNG_UP_PER, a.V_MNG_DOWN_PER, a.V_BUS_AMT_PER, a.V_MNG_AMT_PER, a.V_CNT1, a.V_MON, a.V_CNT2,  "+
						" to_char(to_number(a.C_CNT),decode(sign(1-to_number(a.C_CNT)),-1,'999.99','0.99')) C_CNT, "+
						" to_char(to_number(a.CR_CNT),decode(sign(1-to_number(a.CR_CNT)),-1,'999.99','0.99')) CR_CNT, "+
						" to_char(to_number(a.DALSUNG),decode(sign(1-to_number(a.DALSUNG)),-1,'999.99','0.99')) DALSUNG, "+
						" to_char(to_number(a.CMP_DISCNT_PER),decode(sign(1-to_number(a.CMP_DISCNT_PER)),-1,'999.99','0.99')) CMP_DISCNT_PER, "+
						" to_char(to_number(a.ORG_DALSUNG),decode(sign(1-to_number(a.ORG_DALSUNG)),-1,'999.99',1,'999.99','0.99')) ORG_DALSUNG, "+
						" to_char(to_number(a.C_COST_CNT),decode(sign(1-to_number(a.C_COST_CNT)),-1,'999.99','0.99')) C_COST_CNT, "+
						" to_char(to_number(a.AMT)) amt, a.AVG_DALSUNG, to_char(to_number(a.AMT2)) amt2,  "+
						" a.V_CMP_DISCNT_PER, a.V_MAX_DALSUNG, a.V_BUS_GA, a.V_MNG_GA, a.V_BUS_NEW_GA, a.REG_DT, a.V_ENTER_DT, "+
						" a.V_NM_CNT3, a.V_NE_DT3, a.V_NS_DT3, a.V_NB_CNT2, a.V_NM_CNT2, a.V_NE_DT2, a.V_NS_DT2, a.V_NB_CNT1, a.V_NM_CNT1, a.V_NE_DT1, a.V_NS_DT1, a.V_NB_CNT3, a.BUS_ST, "+
			            " a.DAY2, a.R_COST_CNT, "+
						" a.C_COST_CNT as org_C_COST_CNT, "+
						" a.R_CNT2_1, a.R_CNT2_2, "+
						" a.SUM_COST_CNT, a.SUM_BUS_1, a.SUM_BUS_2, "+
						" a.AVG_COST_CNT, a.AVG_BUS_1, a.AVG_BUS_2, "+
						" to_char(to_number(a.C_TOT_CNT),decode(sign(1-to_number(a.C_TOT_CNT)),-1,'999.99','0.99')) C_TOT_CNT, "+
						" a.V_CNT_PER, a.V_COST_PER, a.AVG_CAR_COST_1, a.AVG_CAR_COST_2, a.cost_cnt1, a.cost_cnt2, "+
						" substr(a.V_CS_DT,1,4) year, substr(a.V_CS_DT,5,2) tm "+
						" from "+
						" ("+
						"		select * from stat_bus_cmp where save_dt='"+save_dt+"'"+
						" ) a, "+
						" users b, (select * from code where c_st='0002') c "+			
						" where a.bus_id=b.user_id and b.dept_id=c.code  and b.loan_st = '1' "+
						" ";


		if(!loan_st.equals("") && ns_dt.equals(""))		query += " and sysdate-to_date(b.enter_dt,'YYYYMMDD') >= 365 and b.loan_st='"+loan_st+"'";

		if(loan_st.equals("") && !ns_dt.equals(""))		query += " and b.enter_dt between '"+ns_dt+"' and '"+ne_dt+"'";


		query += " order by decode(a.CMP_DISCNT_PER,'',1,0), decode(a.org_dalsung,0,2,'',2,1), decode(sign(to_date(a.v_cs_dt,'YYYYMMDD')-add_months(to_date(b.enter_dt,'YYYYMMDD'),to_number(v_mng_f_mon))),-1,b.enter_dt,'00000000'), "+
			     "          to_number(a.org_dalsung) desc, to_number(a.C_TOT_CNT) desc, to_number(a.CMP_DISCNT_PER) desc, b.enter_dt, b.user_id";

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
			System.out.println("[CampaignDatabase:getCampaignList_2012_05_sc2(String save_dt, String loan_st, String ns_dt, String ne_dt)]"+e);
			System.out.println("[CampaignDatabase:getCampaignList_2012_05_sc2(String save_dt, String loan_st, String ns_dt, String ne_dt)]"+query);
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
	 * 결과 :마감테이블 조회 - 2군(영업-서울)
	*/
	public Vector getCampaignList_2012_05_sc3(String save_dt, String loan_st, String ns_dt, String ne_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query =  " select b.dept_id, b.user_nm, b.user_id, b.loan_st, decode(b.loan_st,'1','1군','2','2군') loan_st_nm, b.enter_dt, c.nm_cd, "+
						" a.SAVE_DT, a.SEQ, a.BUS_ID, a.RENT_CNT, a.START_CNT, a.CNT1, a.R_RENT_CNT, a.R_START_CNT, a.R_CNT, a.DAY, a.R_CNT2, a.PRE_CMP, a.PRE_CMP_GA,  "+
						" a.C_DAY, "+
						" a.C_RENT_CNT, a.C_START_CNT, "+
						" a.CR_RENT_CNT, a.CR_START_CNT, "+
						" a.SUM_CNT1, a.SUM_R_CNT, a.SUM_BUS, a.AVG_CNT1, a.AVG_R_CNT, a.AVG_BUS, a.AVG_LOW_BUS,  "+
						" a.V_BS_DT, a.V_BE_DT, a.V_BS_DT2, a.V_BE_DT2, a.V_CS_DT, a.V_CE_DT, a.V_CAR_AMT, a.V_CAR_AMT2,  "+
						" a.V_BUS_UP_PER, a.V_BUS_DOWN_PER, a.V_MNG_UP_PER, a.V_MNG_DOWN_PER, a.V_BUS_AMT_PER, a.V_MNG_AMT_PER, a.V_CNT1, a.V_MON, a.V_CNT2,  "+
						" to_char(to_number(a.C_CNT),decode(sign(1-to_number(a.C_CNT)),-1,'999.99','0.99')) C_CNT, "+
						" to_char(to_number(a.CR_CNT),decode(sign(1-to_number(a.CR_CNT)),-1,'999.99','0.99')) CR_CNT, "+
						" to_char(to_number(a.DALSUNG),decode(sign(1-to_number(a.DALSUNG)),-1,'999.99','0.99')) DALSUNG, "+
						" to_char(to_number(a.CMP_DISCNT_PER),decode(sign(1-to_number(a.CMP_DISCNT_PER)),-1,'999.99','0.99')) CMP_DISCNT_PER, "+
						" to_char(to_number(a.ORG_DALSUNG),'999.99') ORG_DALSUNG,  "+
						" to_char(to_number(a.C_COST_CNT),decode(sign(1-to_number(a.C_COST_CNT)),-1,'999.99','0.99')) C_COST_CNT, "+
						" to_char(to_number(a.AMT)) amt, a.AVG_DALSUNG, to_char(to_number(a.AMT2)) amt2,  "+
						" a.V_CMP_DISCNT_PER, a.V_MAX_DALSUNG, a.V_BUS_GA, a.V_MNG_GA, a.V_BUS_NEW_GA, a.REG_DT, a.V_ENTER_DT, "+
						" a.V_NM_CNT3, a.V_NE_DT3, a.V_NS_DT3, a.V_NB_CNT2, a.V_NM_CNT2, a.V_NE_DT2, a.V_NS_DT2, a.V_NB_CNT1, a.V_NM_CNT1, a.V_NE_DT1, a.V_NS_DT1, a.V_NB_CNT3, a.BUS_ST, "+
			            " a.DAY2, a.R_COST_CNT, "+
						" a.C_COST_CNT as org_C_COST_CNT, "+
						" a.R_CNT2_1, a.R_CNT2_2, "+
						" a.SUM_COST_CNT, a.SUM_BUS_1, a.SUM_BUS_2, "+
						" a.AVG_COST_CNT, a.AVG_BUS_1, a.AVG_BUS_2, "+
						" to_char(to_number(a.C_TOT_CNT),decode(sign(1-to_number(a.C_TOT_CNT)),-1,'999.99','0.99')) C_TOT_CNT, "+
						" a.V_CNT_PER, a.V_COST_PER, a.AVG_CAR_COST_1, a.AVG_CAR_COST_2, a.cost_cnt1, a.cost_cnt2, "+
						" substr(a.V_CS_DT,1,4) year, substr(a.V_CS_DT,5,2) tm "+
						" from "+
						" ("+
						"		select * from stat_bus_cmp where save_dt='"+save_dt+"'"+
						" ) a, "+
						" users b, (select * from code where c_st='0002') c "+
						" where a.bus_id=b.user_id and b.dept_id=c.code and b.loan_st = '2' "+
				        "       and b.br_id in ('S1','S2','I1','K3','S3','S4','S5','S6')"+
						" ";


		if(!loan_st.equals("") && ns_dt.equals(""))		query += " and sysdate-to_date(b.enter_dt,'YYYYMMDD') >= 365 and b.loan_st='"+loan_st+"'";

		if(loan_st.equals("") && !ns_dt.equals(""))		query += " and b.enter_dt between '"+ns_dt+"' and '"+ne_dt+"'";


		query += " order by decode(a.CMP_DISCNT_PER,'',1,0), decode(a.org_dalsung,0,2,'',2,1), "+
			     "          to_number(a.org_dalsung) desc, "+
				 "	        to_number(a.C_TOT_CNT) desc, "+
				 "          to_number(a.CMP_DISCNT_PER) desc, b.enter_dt, b.user_id";

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
			System.out.println("[CampaignDatabase:getCampaignList_2012_05_sc3(String save_dt, String loan_st, String ns_dt, String ne_dt)]"+e);
			System.out.println("[CampaignDatabase:getCampaignList_2012_05_sc3(String save_dt, String loan_st, String ns_dt, String ne_dt)]"+query);
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
	 * 결과 :마감테이블 조회 - 2군(영업-지방)
	*/
	public Vector getCampaignList_2012_05_sc4(String save_dt, String loan_st, String ns_dt, String ne_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query =  " select b.dept_id, b.user_nm, b.user_id, b.loan_st, decode(b.loan_st,'1','1군','2','2군') loan_st_nm, b.enter_dt, c.nm_cd, "+
						" a.SAVE_DT, a.SEQ, a.BUS_ID, a.RENT_CNT, a.START_CNT, a.CNT1, a.R_RENT_CNT, a.R_START_CNT, a.R_CNT, a.DAY, a.R_CNT2, a.PRE_CMP, a.PRE_CMP_GA,  "+
						" a.C_DAY, "+
						" a.C_RENT_CNT, a.C_START_CNT, "+
						" a.CR_RENT_CNT, a.CR_START_CNT, "+
						" a.SUM_CNT1, a.SUM_R_CNT, a.SUM_BUS, a.AVG_CNT1, a.AVG_R_CNT, a.AVG_BUS, a.AVG_LOW_BUS,  "+
						" a.V_BS_DT, a.V_BE_DT, a.V_BS_DT2, a.V_BE_DT2, a.V_CS_DT, a.V_CE_DT, a.V_CAR_AMT, a.V_CAR_AMT2,  "+
						" a.V_BUS_UP_PER, a.V_BUS_DOWN_PER, a.V_MNG_UP_PER, a.V_MNG_DOWN_PER, a.V_BUS_AMT_PER, a.V_MNG_AMT_PER, a.V_CNT1, a.V_MON, a.V_CNT2,  "+
						" to_char(to_number(a.C_CNT),decode(sign(1-to_number(a.C_CNT)),-1,'999.99','0.99')) C_CNT, "+
						" to_char(to_number(a.CR_CNT),decode(sign(1-to_number(a.CR_CNT)),-1,'999.99','0.99')) CR_CNT, "+
						" to_char(to_number(a.DALSUNG),decode(sign(1-to_number(a.DALSUNG)),-1,'999.99','0.99')) DALSUNG, "+
						" to_char(to_number(a.ORG_DALSUNG),'999.99') ORG_DALSUNG,  "+
						" to_char(to_number(a.CMP_DISCNT_PER),decode(sign(1-to_number(a.CMP_DISCNT_PER)),-1,'999.99','0.99')) CMP_DISCNT_PER, "+
						" to_char(to_number(a.C_COST_CNT),decode(sign(1-to_number(a.C_COST_CNT)),-1,'999.99','0.99')) C_COST_CNT, "+
						" to_char(to_number(a.AMT)) amt, a.AVG_DALSUNG, to_char(to_number(a.AMT2)) amt2,  "+
						" a.V_CMP_DISCNT_PER, a.V_MAX_DALSUNG, a.V_BUS_GA, a.V_MNG_GA, a.V_BUS_NEW_GA, a.REG_DT, a.V_ENTER_DT, "+
						" a.V_NM_CNT3, a.V_NE_DT3, a.V_NS_DT3, a.V_NB_CNT2, a.V_NM_CNT2, a.V_NE_DT2, a.V_NS_DT2, a.V_NB_CNT1, a.V_NM_CNT1, a.V_NE_DT1, a.V_NS_DT1, a.V_NB_CNT3, a.BUS_ST, "+
			            " a.DAY2, a.R_COST_CNT, "+
						" a.C_COST_CNT as org_C_COST_CNT, "+
						" a.R_CNT2_1, a.R_CNT2_2, "+
						" a.SUM_COST_CNT, a.SUM_BUS_1, a.SUM_BUS_2, "+
						" a.AVG_COST_CNT, a.AVG_BUS_1, a.AVG_BUS_2, "+
						" to_char(to_number(a.C_TOT_CNT),decode(sign(1-to_number(a.C_TOT_CNT)),-1,'999.99','0.99')) C_TOT_CNT, "+
						" a.V_CNT_PER, a.V_COST_PER, a.AVG_CAR_COST_1, a.AVG_CAR_COST_2, a.cost_cnt1, a.cost_cnt2, "+
						" substr(a.V_CS_DT,1,4) year, substr(a.V_CS_DT,5,2) tm "+
						" from "+
						" ("+
						"		select * from stat_bus_cmp where save_dt='"+save_dt+"'"+
						" ) a, "+
						" users b, (select * from code where c_st='0002') c "+
						" where a.bus_id=b.user_id and b.dept_id=c.code and b.loan_st = '2' "+
				        "       and b.br_id not in ('S1','S2','I1','K3','S3','S4','S5','S6')"+
						" ";


		if(!loan_st.equals("") && ns_dt.equals(""))		query += " and sysdate-to_date(b.enter_dt,'YYYYMMDD') >= 365 and b.loan_st='"+loan_st+"'";

		if(loan_st.equals("") && !ns_dt.equals(""))		query += " and b.enter_dt between '"+ns_dt+"' and '"+ne_dt+"'";


		query += " order by decode(a.CMP_DISCNT_PER,'',1,0), decode(a.org_dalsung,0,2,'',2,1), "+
			     "          to_number(a.org_dalsung) desc, "+
				 "	        to_number(a.C_TOT_CNT) desc, "+
				 "          to_number(a.CMP_DISCNT_PER) desc, b.enter_dt, b.user_id";

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
			System.out.println("[CampaignDatabase:getCampaignList_2012_05_sc4(String save_dt, String loan_st, String ns_dt, String ne_dt)]"+e);
			System.out.println("[CampaignDatabase:getCampaignList_2012_05_sc4(String save_dt, String loan_st, String ns_dt, String ne_dt)]"+query);
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
	 * 영업실적 마감 데이타 담당자별 리스트 조회
	 */
	public Vector getStatBusCmpBaseBusList_2012_05(String bus_id, String mode, String bs_dt, String be_dt, String cs_dt, String ce_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
    	String query = "";
    	String query1 = "";
    	String query2 = "";
    	String query3 = "";
		String query4 = "";
    	String where2 = "";
    	String where3 = "";

    	String where = " a.bs_dt=replace('"+bs_dt+"','-','') and a.ce_dt=replace('"+ce_dt+"','-','') and a.bus_id='"+bus_id+"' and nvl(a.cls_st,'0') not in ('4','5')  \n";


		if(mode.equals("b")) where2 = " and (a.rent_dt <= replace('"+be_dt+"','-','') or a.rent_start_dt <= replace('"+be_dt+"','-','')) \n";
		if(mode.equals("c")) where2 = " and (a.rent_dt > replace('"+be_dt+"','-','') or a.rent_start_dt > replace('"+be_dt+"','-','')) \n";

		//정상계약
		query1 = " select '1' st, \n"+
				 "        a.cnt3   as c_cnt3,		\n"+
				"         a.cnt4   as c_cnt4,		\n"+
				 "        a.v_cnt3 as r_cnt3,	\n"+
				"         a.v_cnt4 as r_cnt4,	\n"+
				 "        a.*  \n"+
				 " from   stat_bus_cmp_base a  \n"+
				 " where  "+where+" "+where2+" and a.con_mon>=6 \n"+
				 " ";

		//6개월미만 계약, 실경과월 6개월 이상
		query2 = " select '2' st,  \n"+
				 "        case when a.use_mon > 11 then '1' else '.5' end c_cnt3, \n"+
				 "        case when a.use_mon > 11 then '1' else '.5' end c_cnt4, \n"+
				 "        case when a.use_mon > 11 then '1' else '.5' end r_cnt3, \n"+
				 "        case when a.use_mon > 11 then '1' else '.5' end r_cnt4, \n"+
				 "        a.*  \n"+
				 " from   stat_bus_cmp_base a  \n"+
				 " where  "+where+" "+where3+" and a.con_mon<6 and a.use_mon>=6  \n"+
				 "        and to_char(add_months(to_date(a.rent_start_dt,'YYYYMMDD'),6),'YYYYMMDD') between '"+cs_dt+"' and '"+ce_dt+"' \n" ;

		//6개월이상 계약, 실경과월 6개월 미만(해지) - 기준기간에 계약
		query3 = " select '3' st,  \n"+
				 "        '-'||DECODE(a.bus_st||b.bus_st,'12',b.cnt1,'22',0,a.cnt1) as c_cnt3, \n"+
				"         decode(a.rent_start_dt,'','0','-'||DECODE(a.bus_st||b.bus_st,'12',b.cnt2,'22',0,a.cnt2)) as c_cnt4, \n"+
				 "        '-'||DECODE(a.bus_st||b.bus_st,'12',b.v_cnt1,'22',0,a.v_cnt1) as r_cnt3, \n"+
				"         decode(a.rent_start_dt,'','0','-'||DECODE(a.bus_st||b.bus_st,'12',b.v_cnt2,'22',0,a.v_cnt2)) as r_cnt4, \n"+
				 "        a.*  \n"+
				 " from   stat_bus_cmp_base a, (SELECT * FROM STAT_BUS_CMP_BASE WHERE bus_st='2') b  \n"+
				 " where  "+where+" "+where3+" and a.con_mon>=6 and a.use_mon<6 and nvl(a.cls_st,'0') not in ('8')\n"+
				 "        and a.cls_dt between '"+cs_dt+"' and '"+ce_dt+"'  \n"+
				 "        and (a.rent_dt < replace('"+cs_dt+"','-','') or a.rent_start_dt < replace('"+cs_dt+"','-','')) \n"+
				 "        AND a.bs_dt=b.bs_dt(+) AND a.ce_dt=b.ce_dt(+) AND a.rent_mng_id=b.rent_mng_id(+) AND a.rent_l_cd=b.rent_l_cd(+) \n"+
				 " ";


		//6개월이상 계약, 실경과월 6개월 미만(해지) - 캠페인기간에 계약
		query4 = " select '3' st,  \n"+
				 "        '-'||DECODE(a.bus_st||b.bus_st,'12',b.cnt3,'22',0,a.cnt3) as c_cnt3, \n"+
				"         decode(a.rent_start_dt,'','0','-'||DECODE(a.bus_st||b.bus_st,'12',b.cnt4,'22',0,a.cnt4)) as c_cnt4, \n"+
				 "        '-'||DECODE(a.bus_st||b.bus_st,'12',b.v_cnt3,'22',0,a.v_cnt3) as r_cnt3, \n"+
				"         decode(a.rent_start_dt,'','0','-'||DECODE(a.bus_st||b.bus_st,'12',b.v_cnt4,'22',0,a.v_cnt4)) as r_cnt4, \n"+
				 "        a.*  \n"+
				 " from   stat_bus_cmp_base a, (SELECT * FROM STAT_BUS_CMP_BASE WHERE bus_st='2') b  \n"+
				 " where  "+where+" "+where3+" and a.con_mon>=6 and a.use_mon<6 and nvl(a.cls_st,'0') not in ('8')\n"+
				 "        and a.cls_dt between '"+cs_dt+"' and '"+ce_dt+"'  \n"+
				 "        and (a.rent_dt > replace('"+be_dt+"','-','') or a.rent_start_dt > replace('"+be_dt+"','-','')) \n"+
				 "        AND a.bs_dt=b.bs_dt(+) AND a.ce_dt=b.ce_dt(+) AND a.rent_mng_id=b.rent_mng_id(+) AND a.rent_l_cd=b.rent_l_cd(+) \n"+
				 " ";


		query =	" select \n"+
				"      a.*,  \n"+
				"      a.c_cnt3 as cc_cnt3,  \n"+
				"      a.c_cnt4 as cc_cnt4,  \n"+
				"      a.r_cnt3 as rr_cnt3,  \n"+
				"      a.r_cnt4 as rr_cnt4,  \n"+
				"      b.firm_nm, decode(a.bus_st,'1',d.user_nm) as bus_nm,  \n"+
				"	   decode(a.bus_st,'1',e.user_nm,'2',d.user_nm) as bus_agnt_nm,  \n"+
				"	   decode(a.bus_st,'1',g.user_nm,'3',d.user_nm) as bus_nm2,  \n"+
				"      decode(a.st,'3','해지',decode(a.rent_st,'1',decode(c.car_gu,'0','재리스',decode(c.rent_st,'1','신규','3','대차','4','증차')),'연장')) gubun,  \n"+
				"      decode(a.bus_st,'1','주','부') gubun2,  \n"+
				"      nvl(f.ext_agnt,c.bus_id) f_bus_id  \n"+
				" from  \n"+
				"      ( "+query1+" union all "+query2+" union all "+query3+"  union all "+query4+" )  a, \n"+
				"	   client b, cont c, users d, users e, fee f, users g  \n"+
				" where  \n"+
				       where+
				"      and a.client_id=b.client_id and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and a.bus_id=d.user_id(+) and a.bus_agnt_id=e.user_id(+) \n"+
				"	   and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd and a.rent_st=f.rent_st and a.bus_id2=g.user_id(+) \n"+
				" order by a.st, decode(a.cls_dt,'',0,1), a.cls_dt, b.firm_nm, a.rent_dt, a.rent_start_dt, a.rent_mng_id \n";
				


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
			System.out.println("[CampaignDatabase:getStatBusCmpBaseBusList_2012_05]\n"+e);
			System.out.println("[CampaignDatabase:getStatBusCmpBaseBusList_2012_05]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}	

	/**
	 * 결과 :마감테이블 조회
	*/
	public Hashtable getCampaignCase_2012_05(String save_dt, String bus_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();

		String query =  " select b.dept_id, b.user_nm, b.user_id, b.loan_st, c.nm_cd, "+
						"		 a.SAVE_DT, a.SEQ, a.BUS_ID, "+
						"		 to_char(to_number(a.RENT_CNT),'999.99') RENT_CNT, to_char(to_number(a.START_CNT),'999.99') START_CNT, to_char(to_number(CNT1),'999.99') CNT1, "+
						"		 to_char(to_number(a.R_RENT_CNT),'999.99') R_RENT_CNT, to_char(to_number(a.R_START_CNT),'999.99') R_START_CNT, to_char(to_number(R_CNT),'999.99') R_CNT, a.DAY, "+
						"		 to_char(to_number(a.R_CNT2),'0.99999') R_CNT2, to_char(to_number(a.PRE_CMP),'0.99999') PRE_CMP, to_char(to_number(a.PRE_CMP_GA),'0.99999') PRE_CMP_GA,  "+
						"		 a.C_DAY, to_char(to_number(a.CMP_DISCNT_PER),'999.99') CMP_DISCNT_PER, "+
						"		 to_char(to_number(a.C_RENT_CNT),'999.99') C_RENT_CNT, to_char(to_number(a.C_START_CNT),'999.99') C_START_CNT, to_char(to_number(a.C_CNT),'999.99') C_CNT, "+
						"		 to_char(to_number(a.CR_RENT_CNT),'999.99') CR_RENT_CNT, to_char(to_number(a.CR_START_CNT),'999.99') CR_START_CNT, to_char(to_number(a.CR_CNT),'999.99') CR_CNT, "+
						"		 to_char(to_number(a.DALSUNG),'999.99') DALSUNG, to_char(to_number(a.AMT)) amt, a.AVG_DALSUNG, to_char(to_number(a.AMT2)) amt2,  "+
						"		 a.SUM_CNT1, a.SUM_R_CNT, a.SUM_BUS, "+
						"		 a.AVG_CNT1, a.AVG_R_CNT, to_char(to_number(a.AVG_BUS),'0.99999') AVG_BUS, to_char(to_number(a.AVG_LOW_BUS),'0.99999') AVG_LOW_BUS,  "+
						"		 a.V_BS_DT, a.V_BE_DT, a.V_BS_DT2, a.V_BE_DT2, a.V_CS_DT, a.V_CE_DT, a.V_CAR_AMT,  "+
						"		 a.V_BUS_UP_PER, a.V_BUS_DOWN_PER, a.V_MNG_UP_PER, a.V_MNG_DOWN_PER, a.V_BUS_AMT_PER, a.V_MNG_AMT_PER, a.V_CNT1, a.V_MON, a.V_CNT2,  "+
						"		 a.V_CMP_DISCNT_PER, a.V_MAX_DALSUNG, a.V_BUS_GA, a.V_MNG_GA, a.V_BUS_NEW_GA, a.REG_DT, a.V_ENTER_DT, to_char(to_number(a.ORG_DALSUNG),'999.99') ORG_DALSUNG,  "+
						"		 a.V_NM_CNT3, a.V_NE_DT3, a.V_NS_DT3, a.V_NB_CNT2, a.V_NM_CNT2, a.V_NE_DT2, a.V_NS_DT2, a.V_NB_CNT1, a.V_NM_CNT1, a.V_NE_DT1, a.V_NS_DT1, a.V_NB_CNT3, a.BUS_ST, "+
			            "		 a.DAY2, to_char(to_number(a.R_COST_CNT),'999.99') R_COST_CNT, to_char(to_number(a.C_COST_CNT),'999.99') C_COST_CNT, "+
						"		 to_char(to_number(a.R_CNT2_1),'0.99999') R_CNT2_1, to_char(to_number(a.R_CNT2_2),'0.99999') R_CNT2_2, "+
						"		 a.SUM_COST_CNT, a.SUM_BUS_1, a.SUM_BUS_2, "+
						"		 a.AVG_COST_CNT, to_char(to_number(a.AVG_BUS_1),'0.99999') AVG_BUS_1, to_char(to_number(a.AVG_BUS_2),'0.99999') AVG_BUS_2, "+
						"		 to_char(to_number(a.C_TOT_CNT),'999.99') C_TOT_CNT, a.V_CNT_PER, a.V_COST_PER, a.AVG_CAR_COST_1, a.AVG_CAR_COST_2	"+
			            " from   stat_bus_cmp a, users b, (select * from code where c_st='0002') c where a.bus_id=b.user_id and b.dept_id=c.code "+
						" and    a.save_dt='"+save_dt+"' and a.bus_id='"+bus_id+"'";


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next())
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
			System.out.println("[CampaignDatabase:getCampaignCase_2012_05(String save_dt, String bus_id)]"+e);
			System.out.println("[CampaignDatabase:getCampaignCase_2012_05(String save_dt, String bus_id)]"+query);
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
	 * 결과 :마감테이블 조회
	*/
	public Vector getCampaignSik_2012_05(String save_dt, String loan_st, String enter_st, String enter_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query = " select b.dept_id, b.user_nm, b.user_id, b.loan_st, c.nm_cd, "+
						" a.SAVE_DT, a.SEQ, a.BUS_ID, "+
						" to_char(to_number(a.RENT_CNT),'999.99') RENT_CNT, to_char(to_number(a.START_CNT),'999.99') START_CNT, to_char(to_number(CNT1),'999.99') CNT1, "+
						" to_char(to_number(a.R_RENT_CNT),'999.99') R_RENT_CNT, to_char(to_number(a.R_START_CNT),'999.99') R_START_CNT, to_char(to_number(R_CNT),'999.99') R_CNT, a.DAY, "+
						" to_char(to_number(a.R_CNT2),'0.99999') R_CNT2, to_char(to_number(a.PRE_CMP),'0.99999') PRE_CMP, to_char(to_number(a.PRE_CMP_GA),'0.99999') PRE_CMP_GA,  "+
						" a.C_DAY, to_char(to_number(a.CMP_DISCNT_PER),'999.99') CMP_DISCNT_PER, "+
						" to_char(to_number(a.C_RENT_CNT),'999.99') C_RENT_CNT, to_char(to_number(a.C_START_CNT),'999.99') C_START_CNT, to_char(to_number(a.C_CNT),'999.99') C_CNT, "+
						" to_char(to_number(a.CR_RENT_CNT),'999.99') CR_RENT_CNT, to_char(to_number(a.CR_START_CNT),'999.99') CR_START_CNT, to_char(to_number(a.CR_CNT),'999.99') CR_CNT, "+
						" to_char(to_number(a.DALSUNG),'999.99') DALSUNG, to_char(to_number(a.AMT)) amt, a.AVG_DALSUNG, to_char(to_number(a.AMT2)) amt2,  "+
						" a.SUM_CNT1, a.SUM_R_CNT, a.SUM_BUS, "+
						" a.AVG_CNT1, a.AVG_R_CNT, to_char(to_number(a.AVG_BUS),'0.99999') AVG_BUS, to_char(to_number(a.AVG_LOW_BUS),'0.99999') AVG_LOW_BUS,  "+
						" a.V_BS_DT, a.V_BE_DT, a.V_BS_DT2, a.V_BE_DT2, a.V_CS_DT, a.V_CE_DT, a.V_CAR_AMT,  "+
						" a.V_BUS_UP_PER, a.V_BUS_DOWN_PER, a.V_MNG_UP_PER, a.V_MNG_DOWN_PER, a.V_BUS_AMT_PER, a.V_MNG_AMT_PER, a.V_CNT1, a.V_MON, a.V_CNT2,  "+
						" a.V_CMP_DISCNT_PER, a.V_MAX_DALSUNG, a.V_BUS_GA, a.V_MNG_GA, a.V_BUS_NEW_GA, a.REG_DT, a.V_ENTER_DT, to_char(to_number(a.ORG_DALSUNG),'9999.99') ORG_DALSUNG,  "+
						" a.V_NM_CNT3, a.V_NE_DT3, a.V_NS_DT3, a.V_NB_CNT2, a.V_NM_CNT2, a.V_NE_DT2, a.V_NS_DT2, a.V_NB_CNT1, a.V_NM_CNT1, a.V_NE_DT1, a.V_NS_DT1, a.V_NB_CNT3, a.BUS_ST, "+
			            " a.DAY2, to_char(to_number(a.R_COST_CNT),'999.99') R_COST_CNT, to_char(to_number(a.C_COST_CNT),'999.99') C_COST_CNT, "+
						" to_char(to_number(a.R_CNT2_1),'0.99999') R_CNT2_1, to_char(to_number(a.R_CNT2_2),'0.99999') R_CNT2_2, "+
						" a.SUM_COST_CNT, a.SUM_BUS_1, a.SUM_BUS_2, "+
						" a.AVG_COST_CNT, to_char(to_number(a.AVG_BUS_1),'0.99999') AVG_BUS_1, to_char(to_number(a.AVG_BUS_2),'0.99999') AVG_BUS_2, "+
						" to_char(to_number(a.C_TOT_CNT),'999.99') C_TOT_CNT, a.V_CNT_PER, a.V_COST_PER, a.AVG_CAR_COST_1, a.AVG_CAR_COST_2	"+
			           " from stat_bus_cmp a, users b, (select * from code where c_st='0002') c where a.bus_id=b.user_id and b.dept_id=c.code and a.save_dt='"+save_dt+"'";

		if(loan_st.equals("1")){
			query += " and b.loan_st='1' ";
		}else if(loan_st.equals("2")){
			query += " and b.loan_st='2' ";
		}else if(loan_st.equals("2_1")){
			query += " and b.loan_st='2' and b.br_id in ('S1','S2','I1','K3','S3','S4','S5','S6')";
		}else if(loan_st.equals("2_2")){
			query += " and b.loan_st='2' and b.br_id not in ('S1','S2','I1','K3','S3','S4','S5','S6') ";
		}

		if(enter_st.equals("n")){//신입
				query += " and decode(b.user_id,'000136','20100601',b.enter_dt) >= '"+enter_dt+"'";
		}else{
				query += " and decode(b.user_id,'000136','20100601',b.enter_dt) < '"+enter_dt+"'";
		}

		query += " order by decode(a.org_dalsung,0,2,'',2,1), to_number(a.org_dalsung) desc, a.seq";

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
			System.out.println("[CampaignDatabase:getCampaignSik_2012_05(String save_dt, String loan_st, String enter_dt)]"+e);
			System.out.println("[CampaignDatabase:getCampaignSik_2012_05(String save_dt, String loan_st, String enter_dt)]"+query);
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
	*	변수수정 - 1군(관리)
	*/
	
	public int updateCampaignVar(String year, String tm, String loan_st, String cs_dt, String ce_dt, String bs_dt, String be_dt, int up_per, int down_per, int amt_per, int car_amt, int max_dalsung, int ga, int new_ga, String ns_dt1, String ns_dt2, String ns_dt3, String ns_dt4, String ne_dt1, String ne_dt2, String ne_dt3, String ne_dt4, int n_cnt1, int n_cnt2, int n_cnt3, int n_cnt4, int cnt_per, int cost_per, String base_end_dt1, String base_end_dt2){


		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = " UPDATE campaign_var SET "+
							    " cs_dt=?, ce_dt=?, up_per=?, down_per=?, amt_per=?, car_amt=?, "+
								" bs_dt=?, be_dt=?, max_dalsung=?, ga=?, new_ga=?, "+
								" ns_dt1=?, ns_dt2=?, ns_dt3=?, ns_dt4=?, ne_dt1=?, ne_dt2=?, ne_dt3=?, ne_dt4=?, "+
								" n_cnt1=?, n_cnt2=?, n_cnt3=?, n_cnt4=?,  "+
								" cnt_per=?, cost_per=?, base_end_dt1=?, base_end_dt2=? "+
						" WHERE year=? and tm=? and loan_st=? ";
			
		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  cs_dt);
			pstmt.setString(2,  ce_dt);
			pstmt.setInt   (3,  up_per);
			pstmt.setInt   (4,  down_per);		
			pstmt.setInt   (5,  amt_per);
			pstmt.setInt   (6,  car_amt);			
			pstmt.setString(7,  bs_dt);
			pstmt.setString(8,  be_dt);
			pstmt.setInt   (9,  max_dalsung);
			pstmt.setInt   (10, ga);
			pstmt.setInt   (11, new_ga);			
			pstmt.setString(12, ns_dt1);
			pstmt.setString(13, ns_dt2);
			pstmt.setString(14, ns_dt3);
			pstmt.setString(15, ns_dt4);
			pstmt.setString(16, ne_dt1);
			pstmt.setString(17, ne_dt2);
			pstmt.setString(18, ne_dt3);
			pstmt.setString(19, ne_dt4);
			pstmt.setInt   (20, n_cnt1);
			pstmt.setInt   (21, n_cnt2);
			pstmt.setInt   (22, n_cnt3);			
			pstmt.setInt   (23, n_cnt4);		
			pstmt.setInt   (24, cnt_per);
			pstmt.setInt   (25, cost_per);			
			pstmt.setString(26, base_end_dt1);
			pstmt.setString(27, base_end_dt2);
			pstmt.setString(28, year);
			pstmt.setString(29, tm);
			pstmt.setString(30, loan_st);
			result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		}catch(SQLException e){
			System.out.println("[CampaignDatabase:updateCampaignVar]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return result;
		}
	}

	/**
	*	변수수정 - 1군(관리)
	*/
	
	public int updateCampaignVar_20120801(String year, String tm, String loan_st, String cs_dt, String ce_dt, String bs_dt, String be_dt, int up_per, int down_per, int amt_per, int car_amt, int max_dalsung, int ga, int new_ga, String ns_dt1, String ns_dt2, String ns_dt3, String ns_dt4, String ne_dt1, String ne_dt2, String ne_dt3, String ne_dt4, int n_cnt1, int n_cnt2, int n_cnt3, int n_cnt4, int cnt_per, int cost_per, String base_end_dt1, String base_end_dt2, int min_dalsung){


		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = " UPDATE campaign_var SET "+
							    " cs_dt=?, ce_dt=?, up_per=?, down_per=?, amt_per=?, car_amt=?, "+
								" bs_dt=?, be_dt=?, max_dalsung=?, ga=?, new_ga=?, "+
								" ns_dt1=?, ns_dt2=?, ns_dt3=?, ns_dt4=?, ne_dt1=?, ne_dt2=?, ne_dt3=?, ne_dt4=?, "+
								" n_cnt1=?, n_cnt2=?, n_cnt3=?, n_cnt4=?,  "+
								" cnt_per=?, cost_per=?, base_end_dt1=?, base_end_dt2=?, min_dalsung=? "+
						" WHERE year=? and tm=? and loan_st=? ";
			
		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  cs_dt);
			pstmt.setString(2,  ce_dt);
			pstmt.setInt   (3,  up_per);
			pstmt.setInt   (4,  down_per);		
			pstmt.setInt   (5,  amt_per);
			pstmt.setInt   (6,  car_amt);			
			pstmt.setString(7,  bs_dt);
			pstmt.setString(8,  be_dt);
			pstmt.setInt   (9,  max_dalsung);
			pstmt.setInt   (10, ga);
			pstmt.setInt   (11, new_ga);			
			pstmt.setString(12, ns_dt1);
			pstmt.setString(13, ns_dt2);
			pstmt.setString(14, ns_dt3);
			pstmt.setString(15, ns_dt4);
			pstmt.setString(16, ne_dt1);
			pstmt.setString(17, ne_dt2);
			pstmt.setString(18, ne_dt3);
			pstmt.setString(19, ne_dt4);
			pstmt.setInt   (20, n_cnt1);
			pstmt.setInt   (21, n_cnt2);
			pstmt.setInt   (22, n_cnt3);			
			pstmt.setInt   (23, n_cnt4);		
			pstmt.setInt   (24, cnt_per);
			pstmt.setInt   (25, cost_per);			
			pstmt.setString(26, base_end_dt1);
			pstmt.setString(27, base_end_dt2);
			pstmt.setInt   (28, min_dalsung);
			pstmt.setString(29, year);
			pstmt.setString(30, tm);
			pstmt.setString(31, loan_st);
			result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		}catch(SQLException e){
			System.out.println("[CampaignDatabase:updateCampaignVar_20120801]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return result;
		}
	}

	/**
	*	변수등록
	*/
	public int insertCampaignVar(String year, String tm, String loan_st, String cs_dt, String ce_dt, String bs_dt, String be_dt, int up_per, int down_per, int amt_per, int car_amt, int max_dalsung, int ga, int new_ga, String ns_dt1, String ns_dt2, String ns_dt3, String ns_dt4, String ne_dt1, String ne_dt2, String ne_dt3, String ne_dt4, int n_cnt1, int n_cnt2, int n_cnt3, int n_cnt4, int cnt_per, int cost_per, String base_end_dt1, String base_end_dt2){

		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;

		String query = "insert into campaign_var "+
			" (  year, tm, loan_st, cs_dt, ce_dt, bs_dt, be_dt, "+
			"	 up_per, down_per, amt_per, car_amt, max_dalsung, ga, new_ga, "+
			"	 ns_dt1, ns_dt2, ns_dt3, ns_dt4, ne_dt1, ne_dt2, ne_dt3, ne_dt4, n_cnt1, n_cnt2, n_cnt3, n_cnt4, "+
			"    cnt_per, cost_per, base_end_dt1, base_end_dt2 "+
			"    ) "+
			" values "+
			" (  ?, ?, ?, ?, ?, ?, ?, "+
			"    ?, ?, ?, ?, ?, ?, ?, "+
			"    ?, ?, ?, ?, ?,  ?, ?, ?, ?, ?, ?, ?, "+	
			"    ?, ?, ?, ? "+
			" )";

		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,  year);
			pstmt.setString	(2,  tm);
			pstmt.setString	(3,  loan_st);
			pstmt.setString (4,  cs_dt);
			pstmt.setString (5,  ce_dt);
			pstmt.setString (6,  bs_dt);
			pstmt.setString (7,  be_dt);
			pstmt.setInt	(8,  up_per);
			pstmt.setInt	(9,  down_per);
			pstmt.setInt	(10, amt_per);
			pstmt.setInt	(11, car_amt);
			pstmt.setInt	(12, max_dalsung);
			pstmt.setInt	(13, ga);
			pstmt.setInt	(14, new_ga);
			pstmt.setString	(15, ns_dt1);
			pstmt.setString	(16, ns_dt2);
			pstmt.setString	(17, ns_dt3);
			pstmt.setString	(18, ns_dt4);
			pstmt.setString	(19, ne_dt1);
			pstmt.setString	(20, ne_dt2);
			pstmt.setString	(21, ne_dt3);
			pstmt.setString	(22, ne_dt4);
			pstmt.setInt	(23, n_cnt1);
			pstmt.setInt	(24, n_cnt2);
			pstmt.setInt	(25, n_cnt3);
			pstmt.setInt	(26, n_cnt4);
			pstmt.setInt	(27, cnt_per);
			pstmt.setInt	(28, cost_per);
			pstmt.setString	(29, base_end_dt1);
			pstmt.setString	(30, base_end_dt2);
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		}catch(SQLException e){
			System.out.println("[CampaignDatabase:insertCampaignVar]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return result;
		}
	}

	/**
	*	변수등록
	*/
	public int insertCampaignVar_20120801(String year, String tm, String loan_st, String cs_dt, String ce_dt, String bs_dt, String be_dt, int up_per, int down_per, int amt_per, int car_amt, int max_dalsung, int ga, int new_ga, String ns_dt1, String ns_dt2, String ns_dt3, String ns_dt4, String ne_dt1, String ne_dt2, String ne_dt3, String ne_dt4, int n_cnt1, int n_cnt2, int n_cnt3, int n_cnt4, int cnt_per, int cost_per, String base_end_dt1, String base_end_dt2, int min_dalsung){

		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;

		String query = "insert into campaign_var "+
			" (  year, tm, loan_st, cs_dt, ce_dt, bs_dt, be_dt, "+
			"	 up_per, down_per, amt_per, car_amt, max_dalsung, ga, new_ga, "+
			"	 ns_dt1, ns_dt2, ns_dt3, ns_dt4, ne_dt1, ne_dt2, ne_dt3, ne_dt4, n_cnt1, n_cnt2, n_cnt3, n_cnt4, "+
			"    cnt_per, cost_per, base_end_dt1, base_end_dt2, min_dalsung "+
			"    ) "+
			" values "+
			" (  ?, ?, ?, ?, ?, ?, ?, "+
			"    ?, ?, ?, ?, ?, ?, ?, "+
			"    ?, ?, ?, ?, ?,  ?, ?, ?, ?, ?, ?, ?, "+	
			"    ?, ?, ?, ?, ? "+
			" )";

		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,  year);
			pstmt.setString	(2,  tm);
			pstmt.setString	(3,  loan_st);
			pstmt.setString (4,  cs_dt);
			pstmt.setString (5,  ce_dt);
			pstmt.setString (6,  bs_dt);
			pstmt.setString (7,  be_dt);
			pstmt.setInt	(8,  up_per);
			pstmt.setInt	(9,  down_per);
			pstmt.setInt	(10, amt_per);
			pstmt.setInt	(11, car_amt);
			pstmt.setInt	(12, max_dalsung);
			pstmt.setInt	(13, ga);
			pstmt.setInt	(14, new_ga);
			pstmt.setString	(15, ns_dt1);
			pstmt.setString	(16, ns_dt2);
			pstmt.setString	(17, ns_dt3);
			pstmt.setString	(18, ns_dt4);
			pstmt.setString	(19, ne_dt1);
			pstmt.setString	(20, ne_dt2);
			pstmt.setString	(21, ne_dt3);
			pstmt.setString	(22, ne_dt4);
			pstmt.setInt	(23, n_cnt1);
			pstmt.setInt	(24, n_cnt2);
			pstmt.setInt	(25, n_cnt3);
			pstmt.setInt	(26, n_cnt4);
			pstmt.setInt	(27, cnt_per);
			pstmt.setInt	(28, cost_per);
			pstmt.setString	(29, base_end_dt1);
			pstmt.setString	(30, base_end_dt2);
			pstmt.setInt	(31, min_dalsung);
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		}catch(SQLException e){
			System.out.println("[CampaignDatabase:insertCampaignVar_20120801]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return result;
		}
	}


	//----------------------------------------------------------------------------------------------------------------------------------------
	//----------------------------------------------------------------------------------------------------------------------------------------
	// :: 통합영업캠페인 (2013-01-24부터)----------------------------------------------------------------------
	//----------------------------------------------------------------------------------------------------------------------------------------
	//---------------------------------------------------------------------



	/**
	 * 결과 :마감테이블 조회 - 1군(관리)
	*/
	public Vector getCampaignList_2013_01_sc2(String save_dt, String loan_st, String ns_dt, String ne_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query =  " select b.dept_id, b.user_nm, b.user_id, b.loan_st, decode(b.loan_st,'1','1군','2','2군') loan_st_nm, b.enter_dt, c.nm_cd, "+
						" a.SAVE_DT, a.SEQ, a.BUS_ID, a.RENT_CNT, a.START_CNT, a.CNT1, a.R_RENT_CNT, a.R_START_CNT, a.R_CNT, a.DAY, a.R_CNT2, a.PRE_CMP, a.PRE_CMP_GA,  "+
						" a.C_DAY, "+
						" a.C_RENT_CNT, a.C_START_CNT, "+
						" a.CR_RENT_CNT, a.CR_START_CNT, "+
						" a.SUM_CNT1, a.SUM_R_CNT, a.SUM_BUS, a.AVG_CNT1, a.AVG_R_CNT, a.AVG_BUS, a.AVG_LOW_BUS,  "+
						" a.V_BS_DT, a.V_BE_DT, a.V_BS_DT2, a.V_BE_DT2, a.V_CS_DT, a.V_CE_DT, a.V_CAR_AMT, a.V_CAR_AMT2,  "+
						" a.V_BUS_UP_PER, a.V_BUS_DOWN_PER, a.V_MNG_UP_PER, a.V_MNG_DOWN_PER, a.V_BUS_AMT_PER, a.V_MNG_AMT_PER, a.V_CNT1, a.V_MON, a.V_CNT2,  "+
						" to_char(to_number(a.C_CNT),decode(sign(1-to_number(a.C_CNT)),-1,'999.99','0.99')) C_CNT, "+
						" to_char(to_number(a.CR_CNT),decode(sign(1-to_number(a.CR_CNT)),-1,'999.99','0.99')) CR_CNT, "+
						" to_char(to_number(a.DALSUNG),decode(sign(1-to_number(a.DALSUNG)),-1,'999.99','0.99')) DALSUNG, "+
						" to_char(to_number(a.CMP_DISCNT_PER),decode(sign(1-to_number(a.CMP_DISCNT_PER)),-1,'999.99','0.99')) CMP_DISCNT_PER, "+
						" to_char(to_number(a.ORG_DALSUNG),decode(sign(1-to_number(a.ORG_DALSUNG)),-1,'999.99',1,'999.99','0.99')) ORG_DALSUNG, "+
						" to_char(to_number(a.C_COST_CNT),decode(sign(1-to_number(a.C_COST_CNT)),-1,'999.99','0.99')) C_COST_CNT, "+
						" to_char(to_number(a.AMT)) amt, a.AVG_DALSUNG, to_char(to_number(a.AMT2)) amt2,  "+
						" a.V_CMP_DISCNT_PER, a.V_MAX_DALSUNG, a.V_BUS_GA, a.V_MNG_GA, a.V_BUS_NEW_GA, a.REG_DT, a.V_ENTER_DT, "+
						" a.V_NM_CNT3, a.V_NE_DT3, a.V_NS_DT3, a.V_NB_CNT2, a.V_NM_CNT2, a.V_NE_DT2, a.V_NS_DT2, a.V_NB_CNT1, a.V_NM_CNT1, a.V_NE_DT1, a.V_NS_DT1, a.V_NB_CNT3, a.BUS_ST, "+
			            " a.DAY2, a.R_COST_CNT, "+
						" a.C_COST_CNT as org_C_COST_CNT, "+
						" a.R_CNT2_1, a.R_CNT2_2, "+
						" a.SUM_COST_CNT, a.SUM_BUS_1, a.SUM_BUS_2, "+
						" a.AVG_COST_CNT, a.AVG_BUS_1, a.AVG_BUS_2, "+
						" to_char(to_number(a.C_TOT_CNT),decode(sign(1-to_number(a.C_TOT_CNT)),-1,'999.99','0.99')) C_TOT_CNT, "+
						" a.V_CNT_PER, a.V_COST_PER, a.AVG_CAR_COST_1, a.AVG_CAR_COST_2, a.cost_cnt1, a.cost_cnt2, "+
						" substr(a.V_CS_DT,1,4) year, substr(a.V_CS_DT,5,2) tm "+
						" from "+
						" ("+
						"		select * from stat_bus_cmp where save_dt='"+save_dt+"'"+
						" ) a, "+
						" users b, (select * from code where c_st='0002') c "+
						" where a.bus_id=b.user_id and b.dept_id=c.code and b.loan_st = '1' "+
						" ";


		if(!loan_st.equals("") && ns_dt.equals(""))		query += " and sysdate-to_date(b.enter_dt,'YYYYMMDD') >= 365 and b.loan_st='"+loan_st+"'";

		if(loan_st.equals("") && !ns_dt.equals(""))		query += " and b.enter_dt between '"+ns_dt+"' and '"+ne_dt+"'";


		query += " order by decode(a.CMP_DISCNT_PER,'',1,0), "+
				 "          decode(a.dalsung,0,2,'',2,1), "+
				 "          decode(a.org_dalsung,0,2,'',2,1), "+
			     "          to_number(a.org_dalsung) desc, to_number(a.C_TOT_CNT) desc, to_number(a.CMP_DISCNT_PER) desc, b.enter_dt, b.user_id";

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
			System.out.println("[CampaignDatabase:getCampaignList_2013_01_sc2(String save_dt, String loan_st, String ns_dt, String ne_dt)]"+e);
			System.out.println("[CampaignDatabase:getCampaignList_2013_01_sc2(String save_dt, String loan_st, String ns_dt, String ne_dt)]"+query);
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
	 * 결과 :마감테이블 조회 - 2군(영업-서울)
	*/
	public Vector getCampaignList_2013_01_sc3(String save_dt, String loan_st, String ns_dt, String ne_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query =  " select b.dept_id, b.user_nm, b.user_id, b.loan_st, decode(b.loan_st,'1','1군','2','2군') loan_st_nm, b.enter_dt, c.nm_cd, "+
						" a.SAVE_DT, a.SEQ, a.BUS_ID, a.RENT_CNT, a.START_CNT, a.CNT1, a.R_RENT_CNT, a.R_START_CNT, a.R_CNT, a.DAY, a.R_CNT2, a.PRE_CMP, a.PRE_CMP_GA,  "+
						" a.C_DAY, "+
						" a.C_RENT_CNT, a.C_START_CNT, "+
						" a.CR_RENT_CNT, a.CR_START_CNT, "+
						" a.SUM_CNT1, a.SUM_R_CNT, a.SUM_BUS, a.AVG_CNT1, a.AVG_R_CNT, a.AVG_BUS, a.AVG_LOW_BUS,  "+
						" a.V_BS_DT, a.V_BE_DT, a.V_BS_DT2, a.V_BE_DT2, a.V_CS_DT, a.V_CE_DT, a.V_CAR_AMT, a.V_CAR_AMT2,  "+
						" a.V_BUS_UP_PER, a.V_BUS_DOWN_PER, a.V_MNG_UP_PER, a.V_MNG_DOWN_PER, a.V_BUS_AMT_PER, a.V_MNG_AMT_PER, a.V_CNT1, a.V_MON, a.V_CNT2,  "+
						" to_char(to_number(a.C_CNT),decode(sign(1-to_number(a.C_CNT)),-1,'999.99','0.99')) C_CNT, "+
						" to_char(to_number(a.CR_CNT),decode(sign(1-to_number(a.CR_CNT)),-1,'999.99','0.99')) CR_CNT, "+
						" to_char(to_number(a.DALSUNG),decode(sign(1-to_number(a.DALSUNG)),-1,'999.99','0.99')) DALSUNG, "+
						" to_char(to_number(a.CMP_DISCNT_PER),decode(sign(1-to_number(a.CMP_DISCNT_PER)),-1,'999.99','0.99')) CMP_DISCNT_PER, "+
						" to_char(to_number(a.ORG_DALSUNG),'999.99') ORG_DALSUNG,  "+
						" to_char(to_number(a.C_COST_CNT),decode(sign(1-to_number(a.C_COST_CNT)),-1,'999.99','0.99')) C_COST_CNT, "+
						" to_char(to_number(a.AMT)) amt, a.AVG_DALSUNG, to_char(to_number(a.AMT2)) amt2,  "+
						" a.V_CMP_DISCNT_PER, a.V_MAX_DALSUNG, a.V_BUS_GA, a.V_MNG_GA, a.V_BUS_NEW_GA, a.REG_DT, a.V_ENTER_DT, "+
						" a.V_NM_CNT3, a.V_NE_DT3, a.V_NS_DT3, a.V_NB_CNT2, a.V_NM_CNT2, a.V_NE_DT2, a.V_NS_DT2, a.V_NB_CNT1, a.V_NM_CNT1, a.V_NE_DT1, a.V_NS_DT1, a.V_NB_CNT3, a.BUS_ST, "+
			            " a.DAY2, a.R_COST_CNT, "+
						" a.C_COST_CNT as org_C_COST_CNT, "+
						" a.R_CNT2_1, a.R_CNT2_2, "+
						" a.SUM_COST_CNT, a.SUM_BUS_1, a.SUM_BUS_2, "+
						" a.AVG_COST_CNT, a.AVG_BUS_1, a.AVG_BUS_2, "+
						" to_char(to_number(a.C_TOT_CNT),decode(sign(1-to_number(a.C_TOT_CNT)),-1,'999.99','0.99')) C_TOT_CNT, "+
						" a.V_CNT_PER, a.V_COST_PER, a.AVG_CAR_COST_1, a.AVG_CAR_COST_2, a.cost_cnt1, a.cost_cnt2, "+
						" substr(a.V_CS_DT,1,4) year, substr(a.V_CS_DT,5,2) tm "+
						" from "+
						" ("+
						"		select * from stat_bus_cmp where save_dt='"+save_dt+"'"+
						" ) a, "+
						" users b, (select * from code where c_st='0002') c "+
						" where a.bus_id=b.user_id and b.dept_id=c.code and b.loan_st = '2' "+
				        "       and b.br_id in ('S1','S2','I1','K3','S3','S4','S5','S6')"+
						" ";


		if(!loan_st.equals("") && ns_dt.equals(""))		query += " and sysdate-to_date(b.enter_dt,'YYYYMMDD') >= 365 and b.loan_st='"+loan_st+"'";

		if(loan_st.equals("") && !ns_dt.equals(""))		query += " and b.enter_dt between '"+ns_dt+"' and '"+ne_dt+"'";


		query += " order by decode(a.CMP_DISCNT_PER,'',1,0), "+
				 "          decode(a.dalsung,0,2,'',2,1), "+
				 "          decode(a.org_dalsung,0,2,'',2,1), "+
			     "          to_number(a.org_dalsung) desc, "+
				 "	        to_number(a.C_TOT_CNT) desc, "+
				 "          to_number(a.CMP_DISCNT_PER) desc, b.enter_dt, b.user_id";

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
			System.out.println("[CampaignDatabase:getCampaignList_2013_01_sc3(String save_dt, String loan_st, String ns_dt, String ne_dt)]"+e);
			System.out.println("[CampaignDatabase:getCampaignList_2013_01_sc3(String save_dt, String loan_st, String ns_dt, String ne_dt)]"+query);
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
	 * 결과 :마감테이블 조회 - 2군(영업-지방)
	*/
	public Vector getCampaignList_2013_01_sc4(String save_dt, String loan_st, String ns_dt, String ne_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query =  " select b.dept_id, b.user_nm, b.user_id, b.loan_st, decode(b.loan_st,'1','1군','2','2군') loan_st_nm, b.enter_dt, c.nm_cd, "+
						" a.SAVE_DT, a.SEQ, a.BUS_ID, a.RENT_CNT, a.START_CNT, a.CNT1, a.R_RENT_CNT, a.R_START_CNT, a.R_CNT, a.DAY, a.R_CNT2, a.PRE_CMP, a.PRE_CMP_GA,  "+
						" a.C_DAY, "+
						" a.C_RENT_CNT, a.C_START_CNT, "+
						" a.CR_RENT_CNT, a.CR_START_CNT, "+
						" a.SUM_CNT1, a.SUM_R_CNT, a.SUM_BUS, a.AVG_CNT1, a.AVG_R_CNT, a.AVG_BUS, a.AVG_LOW_BUS,  "+
						" a.V_BS_DT, a.V_BE_DT, a.V_BS_DT2, a.V_BE_DT2, a.V_CS_DT, a.V_CE_DT, a.V_CAR_AMT, a.V_CAR_AMT2,  "+
						" a.V_BUS_UP_PER, a.V_BUS_DOWN_PER, a.V_MNG_UP_PER, a.V_MNG_DOWN_PER, a.V_BUS_AMT_PER, a.V_MNG_AMT_PER, a.V_CNT1, a.V_MON, a.V_CNT2,  "+
						" to_char(to_number(a.C_CNT),decode(sign(1-to_number(a.C_CNT)),-1,'999.99','0.99')) C_CNT, "+
						" to_char(to_number(a.CR_CNT),decode(sign(1-to_number(a.CR_CNT)),-1,'999.99','0.99')) CR_CNT, "+
						" to_char(to_number(a.DALSUNG),decode(sign(1-to_number(a.DALSUNG)),-1,'999.99','0.99')) DALSUNG, "+
						" to_char(to_number(a.ORG_DALSUNG),'999.99') ORG_DALSUNG,  "+
						" to_char(to_number(a.CMP_DISCNT_PER),decode(sign(1-to_number(a.CMP_DISCNT_PER)),-1,'999.99','0.99')) CMP_DISCNT_PER, "+
						" to_char(to_number(a.C_COST_CNT),decode(sign(1-to_number(a.C_COST_CNT)),-1,'999.99','0.99')) C_COST_CNT, "+
						" to_char(to_number(a.AMT)) amt, a.AVG_DALSUNG, to_char(to_number(a.AMT2)) amt2,  "+
						" a.V_CMP_DISCNT_PER, a.V_MAX_DALSUNG, a.V_BUS_GA, a.V_MNG_GA, a.V_BUS_NEW_GA, a.REG_DT, a.V_ENTER_DT, "+
						" a.V_NM_CNT3, a.V_NE_DT3, a.V_NS_DT3, a.V_NB_CNT2, a.V_NM_CNT2, a.V_NE_DT2, a.V_NS_DT2, a.V_NB_CNT1, a.V_NM_CNT1, a.V_NE_DT1, a.V_NS_DT1, a.V_NB_CNT3, a.BUS_ST, "+
			            " a.DAY2, a.R_COST_CNT, "+
						" a.C_COST_CNT as org_C_COST_CNT, "+
						" a.R_CNT2_1, a.R_CNT2_2, "+
						" a.SUM_COST_CNT, a.SUM_BUS_1, a.SUM_BUS_2, "+
						" a.AVG_COST_CNT, a.AVG_BUS_1, a.AVG_BUS_2, "+
						" to_char(to_number(a.C_TOT_CNT),decode(sign(1-to_number(a.C_TOT_CNT)),-1,'999.99','0.99')) C_TOT_CNT, "+
						" a.V_CNT_PER, a.V_COST_PER, a.AVG_CAR_COST_1, a.AVG_CAR_COST_2, a.cost_cnt1, a.cost_cnt2, "+
						" substr(a.V_CS_DT,1,4) year, substr(a.V_CS_DT,5,2) tm "+
						" from "+
						" ("+
						"		select * from stat_bus_cmp where save_dt='"+save_dt+"'"+
						" ) a, "+
						" users b, (select * from code where c_st='0002') c "+
						" where a.bus_id=b.user_id and b.dept_id=c.code and b.loan_st = '2' "+
				        "       and b.br_id not in ('S1','S2','I1','K3','S3','S4','S5','S6') and b.user_id not in ('000167')"+
						" ";


		if(!loan_st.equals("") && ns_dt.equals(""))		query += " and sysdate-to_date(b.enter_dt,'YYYYMMDD') >= 365 and b.loan_st='"+loan_st+"'";

		if(loan_st.equals("") && !ns_dt.equals(""))		query += " and b.enter_dt between '"+ns_dt+"' and '"+ne_dt+"'";


		query += " order by decode(nvl(a.CMP_DISCNT_PER,''),'',1,0), "+
				 "          decode(nvl(a.dalsung,0),0,2,'',2,1), "+
			     "          to_number(nvl(a.org_dalsung,'0')) desc, "+
				 "	        to_number(nvl(a.C_TOT_CNT,'0')) desc, "+
				 "          to_number(nvl(a.CMP_DISCNT_PER,'0')) desc, b.enter_dt, b.user_id";

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
			System.out.println("[CampaignDatabase:getCampaignList_2013_01_sc4(String save_dt, String loan_st, String ns_dt, String ne_dt)]"+e);
			System.out.println("[CampaignDatabase:getCampaignList_2013_01_sc4(String save_dt, String loan_st, String ns_dt, String ne_dt)]"+query);
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
	 * 영업실적 마감 데이타 담당자별 리스트 조회
	 */
	public Vector getStatBusCmpBaseBusList_2013_01(String bus_id, String mode, String bs_dt, String be_dt, String cs_dt, String ce_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
    	String query = "";
    	String query1 = "";
    	String query2 = "";
    	String query3 = "";
		String query4 = "";
		String query5 = "";
    	String where2 = "";
    	String where3 = "";

    	String where = " a.bs_dt=replace('"+bs_dt+"','-','') and a.ce_dt=replace('"+ce_dt+"','-','') and a.bus_id='"+bus_id+"' and nvl(a.cls_st,'0') not in ('4','5')  \n";


		if(mode.equals("b")) where2 = " and (a.rent_dt <= replace('"+be_dt+"','-','') or a.rent_start_dt <= replace('"+be_dt+"','-','')) \n";
		if(mode.equals("c")) where2 = " and (a.rent_dt > replace('"+be_dt+"','-','') or a.rent_start_dt > replace('"+be_dt+"','-','')) \n";

		//정상계약
		query1 = " select '1' st, \n"+
				 "        a.cnt3   as c_cnt3,		\n"+
				"         a.cnt4   as c_cnt4,		\n"+
				 "        a.v_cnt3 as r_cnt3,	\n"+
				"         a.v_cnt4 as r_cnt4,	\n"+
				 "        a.*  \n"+
				 " from   stat_bus_cmp_base a  \n"+
				 " where  "+where+" "+where2+" and a.con_mon>=6 AND a.car_gu<>'3' "+
				 " and a.rent_start_dt is not null "+
				 " ";

		//6개월미만 계약, 실경과월 6개월 이상
		query2 = " select '2' st,  \n"+
				 "        case when a.use_mon > 11 then '1' else '.5' end c_cnt3, \n"+
				 "        case when a.use_mon > 11 then '1' else '.5' end c_cnt4, \n"+
				 "        case when a.use_mon > 11 then '1' else '.5' end r_cnt3, \n"+
				 "        case when a.use_mon > 11 then '1' else '.5' end r_cnt4, \n"+
				 "        a.*  \n"+
				 " from   stat_bus_cmp_base a  \n"+
				 " where  "+where+" "+where3+" and a.con_mon<6 and a.use_mon>=6 AND a.car_gu<>'3'  \n"+
				 "        and to_char(add_months(to_date(a.rent_start_dt,'YYYYMMDD'),6),'YYYYMMDD') between '"+cs_dt+"' and '"+ce_dt+"' \n" ;

		//6개월이상 계약, 실경과월 6개월 미만(해지) - 기준기간에 계약
		query3 = " select '3' st,  \n"+
				 "        '-'||DECODE(a.bus_st||b.bus_st,'12',b.cnt1,'22',0,a.cnt1) as c_cnt3, \n"+
				"         decode(a.rent_start_dt,'','0','-'||DECODE(a.bus_st||b.bus_st,'12',b.cnt2,'22',0,a.cnt2)) as c_cnt4, \n"+
				 "        '-'||DECODE(a.bus_st||b.bus_st,'12',b.v_cnt1,'22',0,a.v_cnt1) as r_cnt3, \n"+
				"         decode(a.rent_start_dt,'','0','-'||DECODE(a.bus_st||b.bus_st,'12',b.v_cnt2,'22',0,a.v_cnt2)) as r_cnt4, \n"+
				 "        a.*  \n"+
				 " from   stat_bus_cmp_base a, (SELECT * FROM STAT_BUS_CMP_BASE WHERE bus_st='2') b  \n"+
				 " where  "+where+" "+where3+" and a.con_mon>=6 and a.use_mon<6 and nvl(a.cls_st,'0') not in ('8') AND a.car_gu<>'3' \n"+
				 "        and a.cls_dt between '"+cs_dt+"' and '"+ce_dt+"'  \n"+
				 "        and (a.rent_dt < replace('"+cs_dt+"','-','') or a.rent_start_dt < replace('"+cs_dt+"','-','')) \n"+
				 "        AND a.bs_dt=b.bs_dt(+) AND a.ce_dt=b.ce_dt(+) AND a.rent_mng_id=b.rent_mng_id(+) AND a.rent_l_cd=b.rent_l_cd(+) \n"+
				 "        and a.rent_start_dt is not null "+
				 " ";


		//6개월이상 계약, 실경과월 6개월 미만(해지) - 캠페인기간에 계약
		query4 = " select '3' st,  \n"+
				 "        '-'||DECODE(a.bus_st||b.bus_st,'12',b.cnt3,'22',0,a.cnt3) as c_cnt3, \n"+
				"         decode(a.rent_start_dt,'','0','-'||DECODE(a.bus_st||b.bus_st,'12',b.cnt4,'22',0,a.cnt4)) as c_cnt4, \n"+
				 "        '-'||DECODE(a.bus_st||b.bus_st,'12',b.v_cnt3,'22',0,a.v_cnt3) as r_cnt3, \n"+
				"         decode(a.rent_start_dt,'','0','-'||DECODE(a.bus_st||b.bus_st,'12',b.v_cnt4,'22',0,a.v_cnt4)) as r_cnt4, \n"+
				 "        a.*  \n"+
				 " from   stat_bus_cmp_base a, (SELECT * FROM STAT_BUS_CMP_BASE WHERE bus_st='2') b  \n"+
				 " where  "+where+" "+where3+" and a.con_mon>=6 and a.use_mon<6 and nvl(a.cls_st,'0') not in ('8') AND a.car_gu<>'3' \n"+
				 "        and a.cls_dt between '"+cs_dt+"' and '"+ce_dt+"'  \n"+
				 "        and (a.rent_dt > replace('"+be_dt+"','-','') or a.rent_start_dt > replace('"+be_dt+"','-','')) \n"+
				 "        AND a.bs_dt=b.bs_dt(+) AND a.ce_dt=b.ce_dt(+) AND a.rent_mng_id=b.rent_mng_id(+) AND a.rent_l_cd=b.rent_l_cd(+) \n"+
				 "        and a.rent_start_dt is not null "+
				 " ";

		//월렌트
		query5 = " select '4' st, \n"+
				 "        a.cnt3   as c_cnt3,		\n"+
				"         a.cnt4   as c_cnt4,		\n"+
				 "        a.v_cnt3 as r_cnt3,	\n"+
				"         a.v_cnt4 as r_cnt4,	\n"+
				 "        a.*  \n"+
				 " from   stat_bus_cmp_base a  \n"+
				 " where  "+where+" "+where2+" AND a.car_gu='3' \n"+
				 " ";


		query =	" select \n"+
				"      a.*,  \n"+
				"      a.c_cnt3 as cc_cnt3,  \n"+
				"      a.c_cnt4 as cc_cnt4,  \n"+
				"      a.r_cnt3 as rr_cnt3,  \n"+
				"      a.r_cnt4 as rr_cnt4,  \n"+
				"      b.firm_nm, decode(a.car_gu,'3',d.user_nm,decode(a.bus_st,'1',d.user_nm)) as bus_nm,  \n"+
				"	   decode(a.car_gu,'3','',decode(a.bus_st,'1',e.user_nm,'2',d.user_nm)) as bus_agnt_nm,  \n"+
				"	   decode(a.car_gu,'3','',decode(a.bus_st,'1',g.user_nm,'3',d.user_nm)) as bus_nm2,  \n"+
				"      decode(a.st,'3','해지' ,'4',decode(a.rent_st,'1','월렌트','월렌트(연장)'), decode(a.rent_st,'1',decode(c.car_gu,'0','재리스',decode(c.rent_st,'1','신규','3','대차','4','증차')),'연장')) gubun,  \n"+
				"      decode(a.bus_st,'1','주',decode(a.car_gu,'3','주','부')) gubun2,  \n"+
				"      nvl(f.ext_agnt,c.bus_id) f_bus_id,  \n"+
				"      decode(a.bus_emp_id,'','','있음') bus_emp_id_yn, decode(f.rent_way,'1','일반식','기본식') rent_way_nm "+
				" from  \n"+
				"      ( "+query1+" union all "+query2+" "+
				"        union all "+query4+"  union all "+query5+" )  a, \n"+
				"	   client b, cont c, users d, users e, fee f, users g  \n"+
				" where  \n"+
				       where+
				"      and a.client_id=b.client_id "+
				"      and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) "+
				"      and a.bus_id=d.user_id(+) and a.bus_agnt_id=e.user_id(+) \n"+
				"	   and a.rent_mng_id=f.rent_mng_id(+) and a.rent_l_cd=f.rent_l_cd(+) and a.rent_st=f.rent_st(+) "+
				"      and a.bus_id2=g.user_id(+) \n"+
				" order by a.st, decode(a.cls_dt,'',0,1), a.cls_dt, b.firm_nm, a.rent_dt, a.rent_start_dt, a.rent_mng_id \n";
				


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
			System.out.println("[CampaignDatabase:getStatBusCmpBaseBusList_2013_01]\n"+e);
			System.out.println("[CampaignDatabase:getStatBusCmpBaseBusList_2013_01]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}	

	/**
	 * 결과 :마감테이블 조회
	*/
	public Hashtable getCampaignCase_2013_01(String save_dt, String bus_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();

		String query =  " select b.dept_id, b.user_nm, b.user_id, b.loan_st, c.nm_cd, "+
						"		 a.SAVE_DT, a.SEQ, a.BUS_ID, "+
						"		 to_char(to_number(a.RENT_CNT),'999.99') RENT_CNT, to_char(to_number(a.START_CNT),'999.99') START_CNT, to_char(to_number(CNT1),'999.99') CNT1, "+
						"		 to_char(to_number(a.R_RENT_CNT),'999.99') R_RENT_CNT, to_char(to_number(a.R_START_CNT),'999.99') R_START_CNT, to_char(to_number(R_CNT),'999.99') R_CNT, a.DAY, "+
						"		 to_char(to_number(a.R_CNT2),'0.99999') R_CNT2, to_char(to_number(a.PRE_CMP),'0.99999') PRE_CMP, to_char(to_number(a.PRE_CMP_GA),'0.99999') PRE_CMP_GA,  "+
						"		 a.C_DAY, to_char(to_number(a.CMP_DISCNT_PER),'999.99') CMP_DISCNT_PER, "+
						"		 to_char(to_number(a.C_RENT_CNT),'999.99') C_RENT_CNT, to_char(to_number(a.C_START_CNT),'999.99') C_START_CNT, to_char(to_number(a.C_CNT),'999.99') C_CNT, "+
						"		 to_char(to_number(a.CR_RENT_CNT),'999.99') CR_RENT_CNT, to_char(to_number(a.CR_START_CNT),'999.99') CR_START_CNT, to_char(to_number(a.CR_CNT),'999.99') CR_CNT, "+
						"		 to_char(to_number(a.DALSUNG),'999.99') DALSUNG, to_char(to_number(a.AMT)) amt, a.AVG_DALSUNG, to_char(to_number(a.AMT2)) amt2,  "+
						"		 a.SUM_CNT1, a.SUM_R_CNT, a.SUM_BUS, "+
						"		 a.AVG_CNT1, a.AVG_R_CNT, to_char(to_number(a.AVG_BUS),'0.99999') AVG_BUS, to_char(to_number(a.AVG_LOW_BUS),'0.99999') AVG_LOW_BUS,  "+
						"		 a.V_BS_DT, a.V_BE_DT, a.V_BS_DT2, a.V_BE_DT2, a.V_CS_DT, a.V_CE_DT, a.V_CAR_AMT,  "+
						"		 a.V_BUS_UP_PER, a.V_BUS_DOWN_PER, a.V_MNG_UP_PER, a.V_MNG_DOWN_PER, a.V_BUS_AMT_PER, a.V_MNG_AMT_PER, a.V_CNT1, a.V_MON, a.V_CNT2,  "+
						"		 a.V_CMP_DISCNT_PER, a.V_MAX_DALSUNG, a.V_BUS_GA, a.V_MNG_GA, a.V_BUS_NEW_GA, a.REG_DT, a.V_ENTER_DT, to_char(to_number(a.ORG_DALSUNG),'999.99') ORG_DALSUNG,  "+
						"		 a.V_NM_CNT3, a.V_NE_DT3, a.V_NS_DT3, a.V_NB_CNT2, a.V_NM_CNT2, a.V_NE_DT2, a.V_NS_DT2, a.V_NB_CNT1, a.V_NM_CNT1, a.V_NE_DT1, a.V_NS_DT1, a.V_NB_CNT3, a.BUS_ST, "+
			            "		 a.DAY2, to_char(to_number(a.R_COST_CNT),'999.99') R_COST_CNT, to_char(to_number(a.C_COST_CNT),'999.99') C_COST_CNT, "+
						"		 to_char(to_number(a.R_CNT2_1),'0.99999') R_CNT2_1, to_char(to_number(a.R_CNT2_2),'0.99999') R_CNT2_2, "+
						"		 a.SUM_COST_CNT, a.SUM_BUS_1, a.SUM_BUS_2, "+
						"		 a.AVG_COST_CNT, to_char(to_number(a.AVG_BUS_1),'0.99999') AVG_BUS_1, to_char(to_number(a.AVG_BUS_2),'0.99999') AVG_BUS_2, "+
						"		 to_char(to_number(a.C_TOT_CNT),'999.99') C_TOT_CNT, a.V_CNT_PER, a.V_COST_PER, a.AVG_CAR_COST_1, a.AVG_CAR_COST_2	"+
			            " from   stat_bus_cmp a, users b, (select * from code where c_st='0002') c where a.bus_id=b.user_id and b.dept_id=c.code "+
						" and    a.save_dt='"+save_dt+"' and a.bus_id='"+bus_id+"'";


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next())
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
			System.out.println("[CampaignDatabase:getCampaignCase_2013_01(String save_dt, String bus_id)]"+e);
			System.out.println("[CampaignDatabase:getCampaignCase_2013_01(String save_dt, String bus_id)]"+query);
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
	 * 결과 :마감테이블 조회
	*/
	public Vector getCampaignSik_2013_01(String save_dt, String loan_st, String enter_st, String enter_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query = " select b.dept_id, b.user_nm, b.user_id, b.loan_st, c.nm_cd, "+
						" a.SAVE_DT, a.SEQ, a.BUS_ID, "+
						" to_char(to_number(a.RENT_CNT),'999.99') RENT_CNT, to_char(to_number(a.START_CNT),'999.99') START_CNT, to_char(to_number(CNT1),'999.99') CNT1, "+
						" to_char(to_number(a.R_RENT_CNT),'999.99') R_RENT_CNT, to_char(to_number(a.R_START_CNT),'999.99') R_START_CNT, to_char(to_number(R_CNT),'999.99') R_CNT, a.DAY, "+
						" to_char(to_number(a.R_CNT2),'0.99999') R_CNT2, to_char(to_number(a.PRE_CMP),'0.99999') PRE_CMP, to_char(to_number(a.PRE_CMP_GA),'0.99999') PRE_CMP_GA,  "+
						" a.C_DAY, to_char(to_number(a.CMP_DISCNT_PER),'999.99') CMP_DISCNT_PER, "+
						" to_char(to_number(a.C_RENT_CNT),'999.99') C_RENT_CNT, to_char(to_number(a.C_START_CNT),'999.99') C_START_CNT, to_char(to_number(a.C_CNT),'999.99') C_CNT, "+
						" to_char(to_number(a.CR_RENT_CNT),'999.99') CR_RENT_CNT, to_char(to_number(a.CR_START_CNT),'999.99') CR_START_CNT, to_char(to_number(a.CR_CNT),'999.99') CR_CNT, "+
						" to_char(to_number(a.DALSUNG),'999.99') DALSUNG, to_char(to_number(a.AMT)) amt, a.AVG_DALSUNG, to_char(to_number(a.AMT2)) amt2,  "+
						" a.SUM_CNT1, a.SUM_R_CNT, a.SUM_BUS, "+
						" a.AVG_CNT1, a.AVG_R_CNT, to_char(to_number(a.AVG_BUS),'0.99999') AVG_BUS, to_char(to_number(a.AVG_LOW_BUS),'0.99999') AVG_LOW_BUS,  "+
						" a.V_BS_DT, a.V_BE_DT, a.V_BS_DT2, a.V_BE_DT2, a.V_CS_DT, a.V_CE_DT, a.V_CAR_AMT,  "+
						" a.V_BUS_UP_PER, a.V_BUS_DOWN_PER, a.V_MNG_UP_PER, a.V_MNG_DOWN_PER, a.V_BUS_AMT_PER, a.V_MNG_AMT_PER, a.V_CNT1, a.V_MON, a.V_CNT2,  "+
						" a.V_CMP_DISCNT_PER, a.V_MAX_DALSUNG, a.V_BUS_GA, a.V_MNG_GA, a.V_BUS_NEW_GA, a.REG_DT, a.V_ENTER_DT, to_char(to_number(a.ORG_DALSUNG),'9999.99') ORG_DALSUNG,  "+
						" a.V_NM_CNT3, a.V_NE_DT3, a.V_NS_DT3, a.V_NB_CNT2, a.V_NM_CNT2, a.V_NE_DT2, a.V_NS_DT2, a.V_NB_CNT1, a.V_NM_CNT1, a.V_NE_DT1, a.V_NS_DT1, a.V_NB_CNT3, a.BUS_ST, "+
			            " a.DAY2, to_char(to_number(a.R_COST_CNT),'999.99') R_COST_CNT, to_char(to_number(a.C_COST_CNT),'999.99') C_COST_CNT, "+
						" to_char(to_number(a.R_CNT2_1),'0.99999') R_CNT2_1, to_char(to_number(a.R_CNT2_2),'0.99999') R_CNT2_2, "+
						" a.SUM_COST_CNT, a.SUM_BUS_1, a.SUM_BUS_2, "+
						" a.AVG_COST_CNT, to_char(to_number(a.AVG_BUS_1),'0.99999') AVG_BUS_1, to_char(to_number(a.AVG_BUS_2),'0.99999') AVG_BUS_2, "+
						" to_char(to_number(a.C_TOT_CNT),'999.99') C_TOT_CNT, a.V_CNT_PER, a.V_COST_PER, a.AVG_CAR_COST_1, a.AVG_CAR_COST_2	"+
			           " from stat_bus_cmp a, users b, (select * from code where c_st='0002') c where a.bus_id=b.user_id and b.dept_id=c.code and a.save_dt='"+save_dt+"'";

		if(loan_st.equals("1")){
			query += " and b.loan_st='1' ";
		}else if(loan_st.equals("2")){
			query += " and b.loan_st='2' ";
		}else if(loan_st.equals("2_1")){
			query += " and b.loan_st='2' and b.br_id in ('S1','S2','I1','K3','S3','S4','S5','S6')";
		}else if(loan_st.equals("2_2")){
			query += " and b.loan_st='2' and b.br_id not in ('S1','S2','I1','K3','S3','S4','S5','S6') ";
		}

		if(enter_st.equals("n")){//신입
				query += " and a.DALSUNG is null";
		}else{
				query += " and a.DALSUNG is not null";
		}

		query += " order by decode(a.org_dalsung,0,2,'',2,1), to_number(a.org_dalsung) desc, a.seq";

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
			System.out.println("[CampaignDatabase:getCampaignSik_2013_01(String save_dt, String loan_st, String enter_dt)]"+e);
			System.out.println("[CampaignDatabase:getCampaignSik_2013_01(String save_dt, String loan_st, String enter_dt)]"+query);
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



	//----------------------------------------------------------------------------------------------------------------------------------------
	//----------------------------------------------------------------------------------------------------------------------------------------
	// :: 통합영업캠페인 (2014-02-01부터) 20140325                      ----------------------------------------------------------------------
	//----------------------------------------------------------------------------------------------------------------------------------------
	//----------------------------------------------------------------------------------------------------------------------------------------


	/**
	 * 영업실적 마감 데이타 담당자별 리스트 조회
	 */
	public Vector getStatBusCmpBaseBusList_2014_02(String bus_id, String mode, String bs_dt, String be_dt, String cs_dt, String ce_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
    	String query = "";
    	String query1 = "";
    	String query2 = "";
    	String query3 = "";
		String query4 = "";
		String query5 = "";
    	String where2 = "";
    	String where3 = "";

    	String where = " a.bs_dt=replace('"+bs_dt+"','-','') and a.ce_dt=replace('"+ce_dt+"','-','') and a.bus_id='"+bus_id+"' and nvl(a.cls_st,'0') not in ('4','5')  \n";


		if(mode.equals("c")) where2 = " and a.rent_start_dt > replace('"+be_dt+"','-','') \n";

		//정상계약
		query1 = " select '1' st, \n"+
				 "        a.cnt3   as c_cnt3,	\n"+
				"         a.cnt4   as c_cnt4,	\n"+
				"         a.v_cnt4 as r_cnt4,	\n"+
				 "        a.*  \n"+
				 " from   stat_bus_cmp_base a  \n"+
				 " where  "+where+" "+where2+" AND a.car_gu<>'3' "+
				 " and a.rent_start_dt is not null "+
				 " and TO_NUMBER(a.cnt3)+TO_NUMBER(a.cnt4)+TO_NUMBER(a.v_cnt4) <> 0 \n"+
				 " ";

		//6개월미만 계약, 실경과월 6개월 이상
		query2 = " select '2' st,  \n"+
                 "        case when a.use_mon > 11 then DECODE(rent_st,'1','2','1') else DECODE(rent_st,'1','1','0.5') end c_cnt3,\n"+
                 "        case when a.use_mon > 11 then DECODE(rent_st,'1','2','1') else DECODE(rent_st,'1','1','0.5') end c_cnt4,\n"+
                 "        case when a.use_mon > 11 then DECODE(rent_st,'1','2','1') else DECODE(rent_st,'1','1','0.5') end r_cnt4,\n"+
				 "        a.*  \n"+
				 " from   stat_bus_cmp_base a  \n"+
				 " where  "+where+" and a.con_mon<6 and a.use_mon>=6 AND a.car_gu<>'3'  \n"+
				 "        and to_char(add_months(to_date(a.rent_start_dt,'YYYYMMDD'),6),'YYYYMMDD') between '"+cs_dt+"' and '"+ce_dt+"' \n"+
				 "        and a.rent_start_dt between '"+bs_dt+"' and '"+be_dt+"' \n"+
			     " ";

		//6개월이상 계약, 실경과월 6개월 미만(해지) - 캠페인기간에 계약하고 해지
		query4 = " select '3' st,  \n"+
				 "        '-'||DECODE(a.bus_st||b.bus_st,'12',b.cnt3,'22',0,a.cnt3) as c_cnt3, \n"+
				"         '-'||DECODE(a.bus_st||b.bus_st,'12',b.cnt4,'22',0,a.cnt4) as c_cnt4, \n"+
				"         '-'||DECODE(a.bus_st||b.bus_st,'12',b.v_cnt4,'22',0,a.v_cnt4) as r_cnt4, \n"+
				 "        a.*  \n"+
				 " from   stat_bus_cmp_base a, (SELECT * FROM STAT_BUS_CMP_BASE WHERE bus_st='2') b  \n"+
				 " where  "+where+" and a.con_mon>=6 and a.use_mon<6 and nvl(a.cls_st,'0') not in ('8') AND a.car_gu<>'3' \n"+
				 "        and a.cls_dt between '"+cs_dt+"' and '"+ce_dt+"'  \n"+
				 "        and a.rent_start_dt > replace('"+be_dt+"','-','') \n"+
			     "        and TO_NUMBER(a.cnt3)+TO_NUMBER(a.cnt4)+TO_NUMBER(a.v_cnt4) <> 0 "+
				 "        AND a.bs_dt=b.bs_dt(+) AND a.ce_dt=b.ce_dt(+) AND a.rent_mng_id=b.rent_mng_id(+) AND a.rent_l_cd=b.rent_l_cd(+) \n"+
				 "        and a.rent_start_dt is not null "+
				 " ";

		//월렌트
		query5 = " select '4' st, \n"+
				 "        a.cnt3   as c_cnt3,	\n"+
				"         a.cnt4   as c_cnt4,	\n"+
				"         a.v_cnt4 as r_cnt4,	\n"+
				 "        a.*  \n"+
				 " from   stat_bus_cmp_base a  \n"+
				 " where  "+where+" "+where2+" AND a.car_gu='3' \n"+
				 " ";


		query =	" select \n"+
				"      a.*,  \n"+
				"      a.c_cnt3 as cc_cnt3,  \n"+
				"      a.c_cnt4 as cc_cnt4,  \n"+
				"      a.r_cnt4 as rr_cnt4,  \n"+
				"      b.firm_nm, decode(a.car_gu,'3',d.user_nm,decode(a.bus_st,'1',d.user_nm)) as bus_nm,  \n"+
				"	   decode(a.car_gu,'3','',decode(a.bus_st,'1',e.user_nm,'2',d.user_nm)) as bus_agnt_nm,  \n"+
				"	   decode(a.car_gu,'3','',decode(a.bus_st,'1',g.user_nm,'3',d.user_nm)) as bus_nm2,  \n"+
				"      decode(a.st,'3','해지' ,'4',decode(a.bus_st,'1','월렌트','월렌트(연장)'), decode(a.rent_st,'1',decode(c.car_gu,'0','재리스',decode(c.rent_st,'1','신규','3','대차','4','증차')),'연장')) gubun,  \n"+
				"      decode(a.bus_st,'1','주',decode(a.car_gu,'3','주','부')) gubun2,  \n"+
				"      nvl(f.ext_agnt,c.bus_id) f_bus_id,  \n"+
				"      decode(a.bus_emp_id,'','','있음') bus_emp_id_yn, decode(a.rent_way,'1','일반식','기본식') rent_way_nm "+
				" from  \n"+
				"      ( "+query1+" union all "+query2+" "+
				"        union all "+query4+"  union all "+query5+" )  a, \n"+
				"	   client b, cont c, users d, users e, fee f, users g  \n"+
				" where  \n"+
				       where+
				"      and a.client_id=b.client_id "+
				"      and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) "+
				"      and a.bus_id=d.user_id(+) and a.bus_agnt_id=e.user_id(+) \n"+
				"	   and a.rent_mng_id=f.rent_mng_id(+) and a.rent_l_cd=f.rent_l_cd(+) and a.rent_st=f.rent_st(+) "+
				"      and a.bus_id2=g.user_id(+) \n"+
				" order by a.st, decode(a.cls_dt,'',0,1), a.cls_dt, b.firm_nm, a.rent_dt, a.rent_start_dt, a.rent_mng_id \n";
				


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
			System.out.println("[CampaignDatabase:getStatBusCmpBaseBusList_2014_02]\n"+e);
			System.out.println("[CampaignDatabase:getStatBusCmpBaseBusList_2014_02]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}	

	/**
	 * 결과 :마감테이블 조회 - 1군(관리)
	*/
	public Vector getCampaignList_2014_02_sc2(String save_dt, String loan_st, String ns_dt, String ne_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query =  " select b.dept_id, b.user_nm, b.user_id, b.loan_st, decode(b.loan_st,'1','1군','2','2군') loan_st_nm, b.enter_dt, c.nm_cd, "+
						" a.SAVE_DT, a.SEQ, a.BUS_ID, a.RENT_CNT, a.START_CNT, a.CNT1, a.R_RENT_CNT, a.R_START_CNT, a.R_CNT, a.DAY, a.R_CNT2, a.PRE_CMP, a.PRE_CMP_GA,  "+
						" a.C_DAY, "+
						" a.C_RENT_CNT, a.C_START_CNT, "+
						" a.CR_RENT_CNT, a.CR_START_CNT, "+
						" a.SUM_CNT1, a.SUM_R_CNT, a.SUM_BUS, a.AVG_CNT1, a.AVG_R_CNT, a.AVG_BUS, a.AVG_LOW_BUS,  "+
						" a.V_BS_DT, a.V_BE_DT, a.V_BS_DT2, a.V_BE_DT2, a.V_CS_DT, a.V_CE_DT, a.V_CAR_AMT, a.V_CAR_AMT2,  "+
						" a.V_BUS_UP_PER, a.V_BUS_DOWN_PER, a.V_MNG_UP_PER, a.V_MNG_DOWN_PER, a.V_BUS_AMT_PER, a.V_MNG_AMT_PER, a.V_CNT1, a.V_MON, a.V_CNT2,  "+
						" to_char(to_number(a.C_CNT),decode(sign(1-to_number(a.C_CNT)),-1,'999.99','0.99')) C_CNT, "+
						" to_char(to_number(a.CR_CNT),decode(sign(1-to_number(a.CR_CNT)),-1,'999.99','0.99')) CR_CNT, "+
						" to_char(to_number(a.DALSUNG),decode(sign(1-to_number(a.DALSUNG)),-1,'999.99','0.99')) DALSUNG, "+
						" to_char(to_number(a.CMP_DISCNT_PER),decode(sign(1-to_number(a.CMP_DISCNT_PER)),-1,'999.99','0.99')) CMP_DISCNT_PER, "+
						" to_char(to_number(a.ORG_DALSUNG),decode(sign(1-to_number(a.ORG_DALSUNG)),-1,'999.99',1,'999.99','0.99')) ORG_DALSUNG, "+
						" to_char(to_number(a.C_COST_CNT),decode(sign(1-to_number(a.C_COST_CNT)),-1,'999.99','0.99')) C_COST_CNT, "+
						" to_char(to_number(a.AMT)) amt, a.AVG_DALSUNG, to_char(to_number(a.AMT2)) amt2,  "+
						" a.V_CMP_DISCNT_PER, a.V_MAX_DALSUNG, a.V_BUS_GA, a.V_MNG_GA, a.V_BUS_NEW_GA, a.REG_DT, a.V_ENTER_DT, "+
						" a.V_NM_CNT3, a.V_NE_DT3, a.V_NS_DT3, a.V_NB_CNT2, a.V_NM_CNT2, a.V_NE_DT2, a.V_NS_DT2, a.V_NB_CNT1, a.V_NM_CNT1, a.V_NE_DT1, a.V_NS_DT1, a.V_NB_CNT3, a.BUS_ST, "+
			            " a.DAY2, a.R_COST_CNT, "+
						" a.C_COST_CNT as org_C_COST_CNT, "+
						" a.R_CNT2_1, a.R_CNT2_2, "+
						" a.SUM_COST_CNT, a.SUM_BUS_1, a.SUM_BUS_2, "+
						" a.AVG_COST_CNT, a.AVG_BUS_1, a.AVG_BUS_2, "+
						" to_char(to_number(a.C_TOT_CNT),decode(sign(1-to_number(a.C_TOT_CNT)),-1,'999.99','0.99')) C_TOT_CNT, "+
						" a.V_CNT_PER, a.V_COST_PER, a.AVG_CAR_COST_1, a.AVG_CAR_COST_2, a.cost_cnt1, a.cost_cnt2, "+
						" substr(a.V_CS_DT,1,4) year, substr(a.V_CS_DT,5,2) tm "+
						" from "+
						" ("+
						"		select * from stat_bus_cmp where save_dt='"+save_dt+"'"+
						" ) a, "+
						" users b, (select * from code where c_st='0002') c "+
						" where a.bus_id=b.user_id and b.dept_id=c.code and b.loan_st = '1' "+
						" ";


		if(!loan_st.equals("") && ns_dt.equals(""))		query += " and sysdate-to_date(b.enter_dt,'YYYYMMDD') >= 365 and b.loan_st='"+loan_st+"'";

		if(loan_st.equals("") && !ns_dt.equals(""))		query += " and b.enter_dt between '"+ns_dt+"' and '"+ne_dt+"'";


		query += " order by decode(a.CMP_DISCNT_PER,'',1,0), "+
				 "          decode(a.dalsung,0,2,'',2,1), "+
				 "          decode(a.org_dalsung,0,2,'',2,1), "+
			     "          to_number(a.org_dalsung) desc, to_number(a.C_TOT_CNT) desc, to_number(a.CMP_DISCNT_PER) desc, b.enter_dt, b.user_id";

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
			System.out.println("[CampaignDatabase:getCampaignList_2014_02_sc2(String save_dt, String loan_st, String ns_dt, String ne_dt)]"+e);
			System.out.println("[CampaignDatabase:getCampaignList_2014_02_sc2(String save_dt, String loan_st, String ns_dt, String ne_dt)]"+query);
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
	 * 결과 :마감테이블 조회 - 2군(영업-서울)
	*/
	public Vector getCampaignList_2014_02_sc3(String save_dt, String loan_st, String ns_dt, String ne_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query =  " select b.dept_id, b.user_nm, b.user_id, b.loan_st, decode(b.loan_st,'1','1군','2','2군') loan_st_nm, b.enter_dt, c.nm_cd, "+
						" a.SAVE_DT, a.SEQ, a.BUS_ID, a.RENT_CNT, a.START_CNT, a.CNT1, a.R_RENT_CNT, a.R_START_CNT, a.R_CNT, a.DAY, a.R_CNT2, a.PRE_CMP, a.PRE_CMP_GA,  "+
						" a.C_DAY, "+
						" a.C_RENT_CNT, a.C_START_CNT, "+
						" a.CR_RENT_CNT, a.CR_START_CNT, "+
						" a.SUM_CNT1, a.SUM_R_CNT, a.SUM_BUS, a.AVG_CNT1, a.AVG_R_CNT, a.AVG_BUS, a.AVG_LOW_BUS,  "+
						" a.V_BS_DT, a.V_BE_DT, a.V_BS_DT2, a.V_BE_DT2, a.V_CS_DT, a.V_CE_DT, a.V_CAR_AMT, a.V_CAR_AMT2,  "+
						" a.V_BUS_UP_PER, a.V_BUS_DOWN_PER, a.V_MNG_UP_PER, a.V_MNG_DOWN_PER, a.V_BUS_AMT_PER, a.V_MNG_AMT_PER, a.V_CNT1, a.V_MON, a.V_CNT2,  "+
						" to_char(to_number(a.C_CNT),decode(sign(1-to_number(a.C_CNT)),-1,'999.99','0.99')) C_CNT, "+
						" to_char(to_number(a.CR_CNT),decode(sign(1-to_number(a.CR_CNT)),-1,'999.99','0.99')) CR_CNT, "+
						" to_char(to_number(a.DALSUNG),decode(sign(1-to_number(a.DALSUNG)),-1,'999.99','0.99')) DALSUNG, "+
						" to_char(to_number(a.CMP_DISCNT_PER),decode(sign(1-to_number(a.CMP_DISCNT_PER)),-1,'999.99','0.99')) CMP_DISCNT_PER, "+
						" to_char(to_number(a.ORG_DALSUNG),'999.99') ORG_DALSUNG,  "+
						" to_char(to_number(a.C_COST_CNT),decode(sign(1-to_number(a.C_COST_CNT)),-1,'999.99','0.99')) C_COST_CNT, "+
						" to_char(to_number(a.AMT)) amt, a.AVG_DALSUNG, to_char(to_number(a.AMT2)) amt2,  "+
						" a.V_CMP_DISCNT_PER, a.V_MAX_DALSUNG, a.V_BUS_GA, a.V_MNG_GA, a.V_BUS_NEW_GA, a.REG_DT, a.V_ENTER_DT, "+
						" a.V_NM_CNT3, a.V_NE_DT3, a.V_NS_DT3, a.V_NB_CNT2, a.V_NM_CNT2, a.V_NE_DT2, a.V_NS_DT2, a.V_NB_CNT1, a.V_NM_CNT1, a.V_NE_DT1, a.V_NS_DT1, a.V_NB_CNT3, a.BUS_ST, "+
			            " a.DAY2, a.R_COST_CNT, "+
						" a.C_COST_CNT as org_C_COST_CNT, "+
						" a.R_CNT2_1, a.R_CNT2_2, "+
						" a.SUM_COST_CNT, a.SUM_BUS_1, a.SUM_BUS_2, "+
						" a.AVG_COST_CNT, a.AVG_BUS_1, a.AVG_BUS_2, "+
						" to_char(to_number(a.C_TOT_CNT),decode(sign(1-to_number(a.C_TOT_CNT)),-1,'999.99','0.99')) C_TOT_CNT, "+
						" a.V_CNT_PER, a.V_COST_PER, a.AVG_CAR_COST_1, a.AVG_CAR_COST_2, a.cost_cnt1, a.cost_cnt2, "+
						" substr(a.V_CS_DT,1,4) year, substr(a.V_CS_DT,5,2) tm "+
						" from "+
						" ("+
						"		select * from stat_bus_cmp where save_dt='"+save_dt+"'"+
						" ) a, "+
						" users b, (select * from code where c_st='0002') c "+
						" where a.bus_id=b.user_id and b.dept_id=c.code and b.loan_st = '2' "+
				        "       and b.br_id in ('S1','S2','I1','K3','S3','S4','S5','S6')"+
						" ";


		if(!loan_st.equals("") && ns_dt.equals(""))		query += " and sysdate-to_date(b.enter_dt,'YYYYMMDD') >= 365 and b.loan_st='"+loan_st+"'";

		if(loan_st.equals("") && !ns_dt.equals(""))		query += " and b.enter_dt between '"+ns_dt+"' and '"+ne_dt+"'";


		query += " order by decode(a.CMP_DISCNT_PER,'',1,0), "+
				 "          decode(a.dalsung,0,2,'',2,1), "+
				 "          decode(a.org_dalsung,0,2,'',2,1), "+
			     "          to_number(a.org_dalsung) desc, "+
				 "	        to_number(a.C_TOT_CNT) desc, "+
				 "          to_number(a.CMP_DISCNT_PER) desc, b.enter_dt, b.user_id";

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
			System.out.println("[CampaignDatabase:getCampaignList_2014_02_sc3(String save_dt, String loan_st, String ns_dt, String ne_dt)]"+e);
			System.out.println("[CampaignDatabase:getCampaignList_2014_02_sc3(String save_dt, String loan_st, String ns_dt, String ne_dt)]"+query);
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
	 * 결과 :마감테이블 조회 - 2군(영업-지방)
	*/
	public Vector getCampaignList_2014_02_sc4(String save_dt, String loan_st, String ns_dt, String ne_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query =  " select b.dept_id, b.user_nm, b.user_id, b.loan_st, decode(b.loan_st,'1','1군','2','2군') loan_st_nm, b.enter_dt, c.nm_cd, "+
						" a.SAVE_DT, a.SEQ, a.BUS_ID, a.RENT_CNT, a.START_CNT, a.CNT1, a.R_RENT_CNT, a.R_START_CNT, a.R_CNT, a.DAY, a.R_CNT2, a.PRE_CMP, a.PRE_CMP_GA,  "+
						" a.C_DAY, "+
						" a.C_RENT_CNT, a.C_START_CNT, "+
						" a.CR_RENT_CNT, a.CR_START_CNT, "+
						" a.SUM_CNT1, a.SUM_R_CNT, a.SUM_BUS, a.AVG_CNT1, a.AVG_R_CNT, a.AVG_BUS, a.AVG_LOW_BUS,  "+
						" a.V_BS_DT, a.V_BE_DT, a.V_BS_DT2, a.V_BE_DT2, a.V_CS_DT, a.V_CE_DT, a.V_CAR_AMT, a.V_CAR_AMT2,  "+
						" a.V_BUS_UP_PER, a.V_BUS_DOWN_PER, a.V_MNG_UP_PER, a.V_MNG_DOWN_PER, a.V_BUS_AMT_PER, a.V_MNG_AMT_PER, a.V_CNT1, a.V_MON, a.V_CNT2,  "+
						" to_char(to_number(a.C_CNT),decode(sign(1-to_number(a.C_CNT)),-1,'999.99','0.99')) C_CNT, "+
						" to_char(to_number(a.CR_CNT),decode(sign(1-to_number(a.CR_CNT)),-1,'999.99','0.99')) CR_CNT, "+
						" to_char(to_number(a.DALSUNG),decode(sign(1-to_number(a.DALSUNG)),-1,'999.99','0.99')) DALSUNG, "+
						" to_char(to_number(a.ORG_DALSUNG),'999.99') ORG_DALSUNG,  "+
						" to_char(to_number(a.CMP_DISCNT_PER),decode(sign(1-to_number(a.CMP_DISCNT_PER)),-1,'999.99','0.99')) CMP_DISCNT_PER, "+
						" to_char(to_number(a.C_COST_CNT),decode(sign(1-to_number(a.C_COST_CNT)),-1,'999.99','0.99')) C_COST_CNT, "+
						" to_char(to_number(a.AMT)) amt, a.AVG_DALSUNG, to_char(to_number(a.AMT2)) amt2,  "+
						" a.V_CMP_DISCNT_PER, a.V_MAX_DALSUNG, a.V_BUS_GA, a.V_MNG_GA, a.V_BUS_NEW_GA, a.REG_DT, a.V_ENTER_DT, "+
						" a.V_NM_CNT3, a.V_NE_DT3, a.V_NS_DT3, a.V_NB_CNT2, a.V_NM_CNT2, a.V_NE_DT2, a.V_NS_DT2, a.V_NB_CNT1, a.V_NM_CNT1, a.V_NE_DT1, a.V_NS_DT1, a.V_NB_CNT3, a.BUS_ST, "+
			            " a.DAY2, a.R_COST_CNT, "+
						" a.C_COST_CNT as org_C_COST_CNT, "+
						" a.R_CNT2_1, a.R_CNT2_2, "+
						" a.SUM_COST_CNT, a.SUM_BUS_1, a.SUM_BUS_2, "+
						" a.AVG_COST_CNT, a.AVG_BUS_1, a.AVG_BUS_2, "+
						" to_char(to_number(a.C_TOT_CNT),decode(sign(1-to_number(a.C_TOT_CNT)),-1,'999.99','0.99')) C_TOT_CNT, "+
						" a.V_CNT_PER, a.V_COST_PER, a.AVG_CAR_COST_1, a.AVG_CAR_COST_2, a.cost_cnt1, a.cost_cnt2, "+
						" substr(a.V_CS_DT,1,4) year, substr(a.V_CS_DT,5,2) tm "+
						" from "+
						" ("+
						"		select * from stat_bus_cmp where save_dt='"+save_dt+"'"+
						" ) a, "+
						" users b, (select * from code where c_st='0002') c "+
						" where a.bus_id=b.user_id and b.dept_id=c.code and b.loan_st = '2' "+
				        "       and b.br_id not in ('S1','S2','I1','K3','S3','S4','S5','S6') and b.user_id not in ('000167')"+
						" ";


		if(!loan_st.equals("") && ns_dt.equals(""))		query += " and sysdate-to_date(b.enter_dt,'YYYYMMDD') >= 365 and b.loan_st='"+loan_st+"'";

		if(loan_st.equals("") && !ns_dt.equals(""))		query += " and b.enter_dt between '"+ns_dt+"' and '"+ne_dt+"'";


		query += " order by decode(nvl(a.CMP_DISCNT_PER,''),'',1,0), "+
				 "          decode(nvl(a.dalsung,0),0,2,'',2,1), "+
			     "          to_number(nvl(a.org_dalsung,'0')) desc, "+
				 "	        to_number(nvl(a.C_TOT_CNT,'0')) desc, "+
				 "          to_number(nvl(a.CMP_DISCNT_PER,'0')) desc, b.enter_dt, b.user_id";

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
			System.out.println("[CampaignDatabase:getCampaignList_2014_02_sc4(String save_dt, String loan_st, String ns_dt, String ne_dt)]"+e);
			System.out.println("[CampaignDatabase:getCampaignList_2014_02_sc4(String save_dt, String loan_st, String ns_dt, String ne_dt)]"+query);
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
	 * 결과 :마감테이블 조회
	*/
	public Vector getCampaignSik_2014_02(String save_dt, String loan_st, String enter_st, String enter_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query = " select b.dept_id, b.user_nm, b.user_id, b.loan_st, c.nm_cd, "+
						" a.SAVE_DT, a.SEQ, a.BUS_ID, "+
						" to_char(to_number(a.RENT_CNT),'999.99') RENT_CNT, to_char(to_number(a.START_CNT),'999.99') START_CNT, to_char(to_number(CNT1),'999.99') CNT1, "+
						" to_char(to_number(a.R_RENT_CNT),'999.99') R_RENT_CNT, to_char(to_number(a.R_START_CNT),'999.99') R_START_CNT, to_char(to_number(R_CNT),'999.99') R_CNT, a.DAY, "+
						" to_char(to_number(a.R_CNT2),'0.99999') R_CNT2, to_char(to_number(a.PRE_CMP),'0.99999') PRE_CMP, to_char(to_number(a.PRE_CMP_GA),'0.99999') PRE_CMP_GA,  "+
						" a.C_DAY, to_char(to_number(a.CMP_DISCNT_PER),'999.99') CMP_DISCNT_PER, "+
						" to_char(to_number(a.C_RENT_CNT),'999.99') C_RENT_CNT, to_char(to_number(a.C_START_CNT),'999.99') C_START_CNT, to_char(to_number(a.C_CNT),'999.99') C_CNT, "+
						" to_char(to_number(a.CR_RENT_CNT),'999.99') CR_RENT_CNT, to_char(to_number(a.CR_START_CNT),'999.99') CR_START_CNT, to_char(to_number(a.CR_CNT),'999.99') CR_CNT, "+
						" to_char(to_number(a.DALSUNG),'999.99') DALSUNG, to_char(to_number(a.AMT)) amt, a.AVG_DALSUNG, to_char(to_number(a.AMT2)) amt2,  "+
						" a.SUM_CNT1, a.SUM_R_CNT, a.SUM_BUS, "+
						" a.AVG_CNT1, a.AVG_R_CNT, to_char(to_number(a.AVG_BUS),'0.99999') AVG_BUS, to_char(to_number(a.AVG_LOW_BUS),'0.99999') AVG_LOW_BUS,  "+
						" a.V_BS_DT, a.V_BE_DT, a.V_BS_DT2, a.V_BE_DT2, a.V_CS_DT, a.V_CE_DT, a.V_CAR_AMT,  "+
						" a.V_BUS_UP_PER, a.V_BUS_DOWN_PER, a.V_MNG_UP_PER, a.V_MNG_DOWN_PER, a.V_BUS_AMT_PER, a.V_MNG_AMT_PER, a.V_CNT1, a.V_MON, a.V_CNT2,  "+
						" a.V_CMP_DISCNT_PER, a.V_MAX_DALSUNG, a.V_BUS_GA, a.V_MNG_GA, a.V_BUS_NEW_GA, a.REG_DT, a.V_ENTER_DT, to_char(to_number(a.ORG_DALSUNG),'9999.99') ORG_DALSUNG,  "+
						" a.V_NM_CNT3, a.V_NE_DT3, a.V_NS_DT3, a.V_NB_CNT2, a.V_NM_CNT2, a.V_NE_DT2, a.V_NS_DT2, a.V_NB_CNT1, a.V_NM_CNT1, a.V_NE_DT1, a.V_NS_DT1, a.V_NB_CNT3, a.BUS_ST, "+
			            " a.DAY2, to_char(to_number(a.R_COST_CNT),'999.99') R_COST_CNT, to_char(to_number(a.C_COST_CNT),'999.99') C_COST_CNT, "+
						" to_char(to_number(a.R_CNT2_1),'0.99999') R_CNT2_1, to_char(to_number(a.R_CNT2_2),'0.99999') R_CNT2_2, "+
						" a.SUM_COST_CNT, a.SUM_BUS_1, a.SUM_BUS_2, "+
						" a.AVG_COST_CNT, to_char(to_number(a.AVG_BUS_1),'0.99999') AVG_BUS_1, to_char(to_number(a.AVG_BUS_2),'0.99999') AVG_BUS_2, "+
						" to_char(to_number(a.C_TOT_CNT),'999.99') C_TOT_CNT, a.V_CNT_PER, a.V_COST_PER, a.AVG_CAR_COST_1, a.AVG_CAR_COST_2	"+
			           " from stat_bus_cmp a, users b, (select * from code where c_st='0002') c where a.bus_id=b.user_id and b.dept_id=c.code and a.save_dt='"+save_dt+"'";

		if(loan_st.equals("1")){
			query += " and b.loan_st='1' ";
		}else if(loan_st.equals("2")){
			query += " and b.loan_st='2' ";
		}else if(loan_st.equals("2_1")){
			query += " and b.loan_st='2' and b.br_id in ('S1','S2','I1','K3','S3','S4','S5','S6')";
		}else if(loan_st.equals("2_2")){
			query += " and b.loan_st='2' and b.br_id not in ('S1','S2','I1','K3','S3','S4','S5','S6') ";
		}

		if(enter_st.equals("n")){//신입
				query += " and a.DALSUNG is null";
		}else{
				query += " and a.DALSUNG is not null";
		}

		query += " order by decode(a.org_dalsung,0,2,'',2,1), to_number(a.org_dalsung) desc, a.seq";

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
			System.out.println("[CampaignDatabase:getCampaignSik_2014_02(String save_dt, String loan_st, String enter_dt)]"+e);
			System.out.println("[CampaignDatabase:getCampaignSik_2014_02(String save_dt, String loan_st, String enter_dt)]"+query);
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
	 * 결과 :마감테이블 조회 - 1군 서울(관리)
	*/
	public Vector getCampaignList_2014_05_sc1(String save_dt, String loan_st, String ns_dt, String ne_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query =  " select b.dept_id, b.user_nm, b.user_id, b.loan_st, decode(b.loan_st,'1','1군','2','2군') loan_st_nm, b.enter_dt, c.nm_cd, "+
						" a.SAVE_DT, a.SEQ, a.BUS_ID, a.RENT_CNT, a.START_CNT, a.CNT1, a.R_RENT_CNT, a.R_START_CNT, a.R_CNT, a.DAY, a.R_CNT2, a.PRE_CMP, a.PRE_CMP_GA,  "+
						" a.C_DAY, "+
						" a.C_RENT_CNT, a.C_START_CNT, "+
						" a.CR_RENT_CNT, a.CR_START_CNT, "+
						" a.SUM_CNT1, a.SUM_R_CNT, a.SUM_BUS, a.AVG_CNT1, a.AVG_R_CNT, a.AVG_BUS, a.AVG_LOW_BUS,  "+
						" a.V_BS_DT, a.V_BE_DT, a.V_BS_DT2, a.V_BE_DT2, a.V_CS_DT, a.V_CE_DT, a.V_CAR_AMT, a.V_CAR_AMT2,  "+
						" a.V_BUS_UP_PER, a.V_BUS_DOWN_PER, a.V_MNG_UP_PER, a.V_MNG_DOWN_PER, a.V_BUS_AMT_PER, a.V_MNG_AMT_PER, a.V_CNT1, a.V_MON, a.V_CNT2,  "+
						" to_char(to_number(a.C_CNT),decode(sign(1-to_number(a.C_CNT)),-1,'999.99','0.99')) C_CNT, "+
						" to_char(to_number(a.CR_CNT),decode(sign(1-to_number(a.CR_CNT)),-1,'999.99','0.99')) CR_CNT, "+
						" to_char(to_number(a.CR_CNT2),decode(sign(1-to_number(a.CR_CNT2)),-1,'999.99','0.99')) CR_CNT2, "+
						" to_char(to_number(a.DALSUNG),decode(sign(1-to_number(a.DALSUNG)),-1,'999.99','0.99')) DALSUNG, "+
						" to_char(to_number(a.CMP_DISCNT_PER),decode(sign(1-to_number(a.CMP_DISCNT_PER)),-1,'999.99','0.99')) CMP_DISCNT_PER, "+
						" to_char(to_number(a.ORG_DALSUNG),decode(sign(1-to_number(a.ORG_DALSUNG)),-1,'999.99',1,'999.99','0.99')) ORG_DALSUNG, "+
						" to_char(to_number(a.C_COST_CNT),decode(sign(1-to_number(a.C_COST_CNT)),-1,'999.99','0.99')) C_COST_CNT, "+
						" to_char(to_number(a.AMT)) amt, a.AVG_DALSUNG, to_char(to_number(a.AMT2)) amt2,  "+
						" a.V_CMP_DISCNT_PER, a.V_MAX_DALSUNG, a.V_BUS_GA, a.V_MNG_GA, a.V_BUS_NEW_GA, a.REG_DT, a.V_ENTER_DT, "+
						" a.V_NM_CNT3, a.V_NE_DT3, a.V_NS_DT3, a.V_NB_CNT2, a.V_NM_CNT2, a.V_NE_DT2, a.V_NS_DT2, a.V_NB_CNT1, a.V_NM_CNT1, a.V_NE_DT1, a.V_NS_DT1, a.V_NB_CNT3, a.BUS_ST, "+
			            " a.DAY2, a.R_COST_CNT, "+
						" a.C_COST_CNT as org_C_COST_CNT, "+
						" a.R_CNT2_1, a.R_CNT2_2, "+
						" a.SUM_COST_CNT, a.SUM_BUS_1, a.SUM_BUS_2, "+
						" a.AVG_COST_CNT, a.AVG_BUS_1, a.AVG_BUS_2, "+
						" to_char(to_number(a.C_TOT_CNT),decode(sign(1-to_number(a.C_TOT_CNT)),-1,'999.99','0.99')) C_TOT_CNT, "+
						" a.V_CNT_PER, a.V_COST_PER, a.AVG_CAR_COST_1, a.AVG_CAR_COST_2, a.cost_cnt1, a.cost_cnt2, "+
						" substr(a.V_CS_DT,1,4) year, substr(a.V_CS_DT,5,2) tm "+
						" from "+
						" ("+
						"		select * from stat_bus_cmp where save_dt='"+save_dt+"'"+
						" ) a, "+
						" users b, (select * from code where c_st='0002') c "+
						" where a.bus_id=b.user_id and b.dept_id=c.code and b.loan_st = '1' and b.br_id in ('S1','S2','S3','S4','S5','S6','I1') "+
						" ";


		if(!loan_st.equals("") && ns_dt.equals(""))		query += " and sysdate-to_date(b.enter_dt,'YYYYMMDD') >= 365 and b.loan_st='"+loan_st+"'";

		if(loan_st.equals("") && !ns_dt.equals(""))		query += " and b.enter_dt between '"+ns_dt+"' and '"+ne_dt+"'";


		query += " order by decode(a.CMP_DISCNT_PER,'',1,0), "+
				 "          decode(a.dalsung,0,2,'',2,1), "+
				 "          decode(a.org_dalsung,0,2,'',2,1), "+
			     "          to_number(a.org_dalsung) desc, to_number(a.C_TOT_CNT) desc, to_number(a.CMP_DISCNT_PER) desc, b.enter_dt, b.user_id";

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
			System.out.println("[CampaignDatabase:getCampaignList_2014_05_sc1(String save_dt, String loan_st, String ns_dt, String ne_dt)]"+e);
			System.out.println("[CampaignDatabase:getCampaignList_2014_05_sc1(String save_dt, String loan_st, String ns_dt, String ne_dt)]"+query);
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
	 * 결과 :마감테이블 조회 - 1군 지점(관리)
	*/
	public Vector getCampaignList_2014_05_sc2(String save_dt, String loan_st, String ns_dt, String ne_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query =  " select b.dept_id, b.user_nm, b.user_id, b.loan_st, decode(b.loan_st,'1','1군','2','2군') loan_st_nm, b.enter_dt, c.nm_cd, "+
						" a.SAVE_DT, a.SEQ, a.BUS_ID, a.RENT_CNT, a.START_CNT, a.CNT1, a.R_RENT_CNT, a.R_START_CNT, a.R_CNT, a.DAY, a.R_CNT2, a.PRE_CMP, a.PRE_CMP_GA,  "+
						" a.C_DAY, "+
						" a.C_RENT_CNT, a.C_START_CNT, "+
						" a.CR_RENT_CNT, a.CR_START_CNT, "+
						" a.SUM_CNT1, a.SUM_R_CNT, a.SUM_BUS, a.AVG_CNT1, a.AVG_R_CNT, a.AVG_BUS, a.AVG_LOW_BUS,  "+
						" a.V_BS_DT, a.V_BE_DT, a.V_BS_DT2, a.V_BE_DT2, a.V_CS_DT, a.V_CE_DT, a.V_CAR_AMT, a.V_CAR_AMT2,  "+
						" a.V_BUS_UP_PER, a.V_BUS_DOWN_PER, a.V_MNG_UP_PER, a.V_MNG_DOWN_PER, a.V_BUS_AMT_PER, a.V_MNG_AMT_PER, a.V_CNT1, a.V_MON, a.V_CNT2,  "+
						" to_char(to_number(a.C_CNT),decode(sign(1-to_number(a.C_CNT)),-1,'999.99','0.99')) C_CNT, "+
						" to_char(to_number(a.CR_CNT),decode(sign(1-to_number(a.CR_CNT)),-1,'999.99','0.99')) CR_CNT, "+
						" to_char(to_number(a.CR_CNT2),decode(sign(1-to_number(a.CR_CNT2)),-1,'999.99','0.99')) CR_CNT2, "+
						" to_char(to_number(a.DALSUNG),decode(sign(1-to_number(a.DALSUNG)),-1,'999.99','0.99')) DALSUNG, "+
						" to_char(to_number(a.CMP_DISCNT_PER),decode(sign(1-to_number(a.CMP_DISCNT_PER)),-1,'999.99','0.99')) CMP_DISCNT_PER, "+
						" to_char(to_number(a.ORG_DALSUNG),decode(sign(1-to_number(a.ORG_DALSUNG)),-1,'999.99',1,'999.99','0.99')) ORG_DALSUNG, "+
						" to_char(to_number(a.C_COST_CNT),decode(sign(1-to_number(a.C_COST_CNT)),-1,'999.99','0.99')) C_COST_CNT, "+
						" to_char(to_number(a.AMT)) amt, a.AVG_DALSUNG, to_char(to_number(a.AMT2)) amt2,  "+
						" a.V_CMP_DISCNT_PER, a.V_MAX_DALSUNG, a.V_BUS_GA, a.V_MNG_GA, a.V_BUS_NEW_GA, a.REG_DT, a.V_ENTER_DT, "+
						" a.V_NM_CNT3, a.V_NE_DT3, a.V_NS_DT3, a.V_NB_CNT2, a.V_NM_CNT2, a.V_NE_DT2, a.V_NS_DT2, a.V_NB_CNT1, a.V_NM_CNT1, a.V_NE_DT1, a.V_NS_DT1, a.V_NB_CNT3, a.BUS_ST, "+
			            " a.DAY2, a.R_COST_CNT, "+
						" a.C_COST_CNT as org_C_COST_CNT, "+
						" a.R_CNT2_1, a.R_CNT2_2, "+
						" a.SUM_COST_CNT, a.SUM_BUS_1, a.SUM_BUS_2, "+
						" a.AVG_COST_CNT, a.AVG_BUS_1, a.AVG_BUS_2, "+
						" to_char(to_number(a.C_TOT_CNT),decode(sign(1-to_number(a.C_TOT_CNT)),-1,'999.99','0.99')) C_TOT_CNT, "+
						" a.V_CNT_PER, a.V_COST_PER, a.AVG_CAR_COST_1, a.AVG_CAR_COST_2, a.cost_cnt1, a.cost_cnt2, "+
						" substr(a.V_CS_DT,1,4) year, substr(a.V_CS_DT,5,2) tm "+
						" from "+
						" ("+
						"		select * from stat_bus_cmp where save_dt='"+save_dt+"'"+
						" ) a, "+
						" users b, (select * from code where c_st='0002') c "+
						" where a.bus_id=b.user_id and b.dept_id=c.code and b.loan_st = '1' and b.br_id not in ('S1','S2','S3','S4','S5','S6','I1') "+
						" ";


		if(!loan_st.equals("") && ns_dt.equals(""))		query += " and sysdate-to_date(b.enter_dt,'YYYYMMDD') >= 365 and b.loan_st='"+loan_st+"'";

		if(loan_st.equals("") && !ns_dt.equals(""))		query += " and b.enter_dt between '"+ns_dt+"' and '"+ne_dt+"'";


		query += " order by decode(a.CMP_DISCNT_PER,'',1,0), "+
				 "          decode(a.dalsung,0,2,'',2,1), "+
				 "          decode(a.org_dalsung,0,2,'',2,1), "+
			     "          to_number(a.org_dalsung) desc, to_number(a.C_TOT_CNT) desc, to_number(a.CMP_DISCNT_PER) desc, b.enter_dt, b.user_id";

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
			System.out.println("[CampaignDatabase:getCampaignList_2014_05_sc2(String save_dt, String loan_st, String ns_dt, String ne_dt)]"+e);
			System.out.println("[CampaignDatabase:getCampaignList_2014_05_sc2(String save_dt, String loan_st, String ns_dt, String ne_dt)]"+query);
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
	 * 결과 :마감테이블 조회 - 2군(영업-서울)
	*/
	public Vector getCampaignList_2014_05_sc3(String save_dt, String loan_st, String ns_dt, String ne_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query =  " select b.dept_id, b.user_nm, b.user_id, b.loan_st, decode(b.loan_st,'1','1군','2','2군') loan_st_nm, b.enter_dt, c.nm_cd, "+
						" a.SAVE_DT, a.SEQ, a.BUS_ID, a.RENT_CNT, a.START_CNT, a.CNT1, a.R_RENT_CNT, a.R_START_CNT, a.R_CNT, a.DAY, a.R_CNT2, a.PRE_CMP, a.PRE_CMP_GA,  "+
						" a.C_DAY, "+
						" a.C_RENT_CNT, a.C_START_CNT, "+
						" a.CR_RENT_CNT, a.CR_START_CNT, "+
						" a.SUM_CNT1, a.SUM_R_CNT, a.SUM_BUS, a.AVG_CNT1, a.AVG_R_CNT, a.AVG_BUS, a.AVG_LOW_BUS,  "+
						" a.V_BS_DT, a.V_BE_DT, a.V_BS_DT2, a.V_BE_DT2, a.V_CS_DT, a.V_CE_DT, a.V_CAR_AMT, a.V_CAR_AMT2,  "+
						" a.V_BUS_UP_PER, a.V_BUS_DOWN_PER, a.V_MNG_UP_PER, a.V_MNG_DOWN_PER, a.V_BUS_AMT_PER, a.V_MNG_AMT_PER, a.V_CNT1, a.V_MON, a.V_CNT2,  "+
						" to_char(to_number(a.C_CNT),decode(sign(1-to_number(a.C_CNT)),-1,'999.99',DECODE(substr(a.C_CNT,1,1),'-','999.99','0.99'))) C_CNT, "+
						" to_char(to_number(a.CR_CNT),decode(sign(1-to_number(a.CR_CNT)),-1,'999.99',DECODE(substr(a.CR_CNT,1,1),'-','999.99','0.99'))) CR_CNT, "+
						" to_char(to_number(a.CR_CNT2),decode(sign(1-to_number(a.CR_CNT2)),-1,'999.99',DECODE(substr(a.CR_CNT2,1,1),'-','999.99','0.99'))) CR_CNT2, "+
						" to_char(to_number(a.DALSUNG),decode(sign(1-to_number(a.DALSUNG)),-1,'999.99',DECODE(substr(a.DALSUNG,1,1),'-','999.99','0.99'))) DALSUNG, "+
						" to_char(to_number(a.CMP_DISCNT_PER),decode(sign(1-to_number(a.CMP_DISCNT_PER)),-1,'999.99',DECODE(substr(a.CMP_DISCNT_PER,1,1),'-','999.99','0.99'))) CMP_DISCNT_PER, "+
						" to_char(to_number(a.ORG_DALSUNG),'999.99') ORG_DALSUNG,  "+
						" to_char(to_number(a.C_COST_CNT),decode(sign(1-to_number(a.C_COST_CNT)),-1,'999.99',DECODE(substr(a.C_COST_CNT,1,1),'-','999.99','0.99'))) C_COST_CNT, "+
						" to_char(to_number(a.AMT)) amt, a.AVG_DALSUNG, to_char(to_number(a.AMT2)) amt2,  "+
						" a.V_CMP_DISCNT_PER, a.V_MAX_DALSUNG, a.V_BUS_GA, a.V_MNG_GA, a.V_BUS_NEW_GA, a.REG_DT, a.V_ENTER_DT, "+
						" a.V_NM_CNT3, a.V_NE_DT3, a.V_NS_DT3, a.V_NB_CNT2, a.V_NM_CNT2, a.V_NE_DT2, a.V_NS_DT2, a.V_NB_CNT1, a.V_NM_CNT1, a.V_NE_DT1, a.V_NS_DT1, a.V_NB_CNT3, a.BUS_ST, "+
			            " a.DAY2, a.R_COST_CNT, "+
						" a.C_COST_CNT as org_C_COST_CNT, "+
						" a.R_CNT2_1, a.R_CNT2_2, "+
						" a.SUM_COST_CNT, a.SUM_BUS_1, a.SUM_BUS_2, "+
						" a.AVG_COST_CNT, a.AVG_BUS_1, a.AVG_BUS_2, "+
						" to_char(to_number(a.C_TOT_CNT),decode(sign(1-to_number(a.C_TOT_CNT)),-1,'999.99',DECODE(substr(a.C_TOT_CNT,1,1),'-','999.99','0.99'))) C_TOT_CNT, "+
						" a.V_CNT_PER, a.V_COST_PER, a.AVG_CAR_COST_1, a.AVG_CAR_COST_2, a.cost_cnt1, a.cost_cnt2, "+
						" substr(a.V_CS_DT,1,4) year, substr(a.V_CS_DT,5,2) tm "+
						" from "+
						" ("+
						"		select * from stat_bus_cmp where save_dt='"+save_dt+"'"+
						" ) a, "+
						" users b, (select * from code where c_st='0002') c "+
						" where a.bus_id=b.user_id and b.dept_id=c.code and b.loan_st = '2' "+
				        "       and b.br_id in ('S1','S2','I1','S3','S4','S5','S6')"+
						" ";


		if(!loan_st.equals("") && ns_dt.equals(""))		query += " and sysdate-to_date(b.enter_dt,'YYYYMMDD') >= 365 and b.loan_st='"+loan_st+"'";

		if(loan_st.equals("") && !ns_dt.equals(""))		query += " and b.enter_dt between '"+ns_dt+"' and '"+ne_dt+"'";


		query += " order by decode(a.CMP_DISCNT_PER,'',1,0), "+
				 "          decode(a.dalsung,0,2,'',2,1), "+
				 "          decode(a.org_dalsung,0,2,'',2,1), "+
			     "          to_number(a.org_dalsung) desc, "+
				 "	        to_number(a.C_TOT_CNT) desc, "+
				 "          to_number(a.CMP_DISCNT_PER) desc, b.enter_dt, b.user_id";

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
			System.out.println("[CampaignDatabase:getCampaignList_2014_05_sc3(String save_dt, String loan_st, String ns_dt, String ne_dt)]"+e);
			System.out.println("[CampaignDatabase:getCampaignList_2014_05_sc3(String save_dt, String loan_st, String ns_dt, String ne_dt)]"+query);
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
	 * 결과 :마감테이블 조회 - 2군(영업-지방)
	*/
	public Vector getCampaignList_2014_05_sc4(String save_dt, String loan_st, String ns_dt, String ne_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query =  " select b.dept_id, b.user_nm, b.user_id, b.loan_st, decode(b.loan_st,'1','1군','2','2군') loan_st_nm, b.enter_dt, c.nm_cd, "+
						" a.SAVE_DT, a.SEQ, a.BUS_ID, a.RENT_CNT, a.START_CNT, a.CNT1, a.R_RENT_CNT, a.R_START_CNT, a.R_CNT, a.DAY, a.R_CNT2, a.PRE_CMP, a.PRE_CMP_GA,  "+
						" a.C_DAY, "+
						" a.C_RENT_CNT, a.C_START_CNT, "+
						" a.CR_RENT_CNT, a.CR_START_CNT, "+
						" a.SUM_CNT1, a.SUM_R_CNT, a.SUM_BUS, a.AVG_CNT1, a.AVG_R_CNT, a.AVG_BUS, a.AVG_LOW_BUS,  "+
						" a.V_BS_DT, a.V_BE_DT, a.V_BS_DT2, a.V_BE_DT2, a.V_CS_DT, a.V_CE_DT, a.V_CAR_AMT, a.V_CAR_AMT2,  "+
						" a.V_BUS_UP_PER, a.V_BUS_DOWN_PER, a.V_MNG_UP_PER, a.V_MNG_DOWN_PER, a.V_BUS_AMT_PER, a.V_MNG_AMT_PER, a.V_CNT1, a.V_MON, a.V_CNT2,  "+
						" to_char(to_number(a.C_CNT),decode(sign(1-to_number(a.C_CNT)),-1,'999.99','0.99')) C_CNT, "+
						" to_char(to_number(a.CR_CNT),decode(sign(1-to_number(a.CR_CNT)),-1,'999.99','0.99')) CR_CNT, "+
						" to_char(to_number(a.CR_CNT2),decode(sign(1-to_number(a.CR_CNT2)),-1,'999.99','0.99')) CR_CNT2, "+
						" to_char(to_number(a.DALSUNG),decode(sign(1-to_number(a.DALSUNG)),-1,'999.99','0.99')) DALSUNG, "+
						" to_char(to_number(a.ORG_DALSUNG),'999.99') ORG_DALSUNG,  "+
						" to_char(to_number(a.CMP_DISCNT_PER),decode(sign(1-to_number(a.CMP_DISCNT_PER)),-1,'999.99','0.99')) CMP_DISCNT_PER, "+
						" to_char(to_number(a.C_COST_CNT),decode(sign(1-to_number(a.C_COST_CNT)),-1,'999.99','0.99')) C_COST_CNT, "+
						" to_char(to_number(a.AMT)) amt, a.AVG_DALSUNG, to_char(to_number(a.AMT2)) amt2,  "+
						" a.V_CMP_DISCNT_PER, a.V_MAX_DALSUNG, a.V_BUS_GA, a.V_MNG_GA, a.V_BUS_NEW_GA, a.REG_DT, a.V_ENTER_DT, "+
						" a.V_NM_CNT3, a.V_NE_DT3, a.V_NS_DT3, a.V_NB_CNT2, a.V_NM_CNT2, a.V_NE_DT2, a.V_NS_DT2, a.V_NB_CNT1, a.V_NM_CNT1, a.V_NE_DT1, a.V_NS_DT1, a.V_NB_CNT3, a.BUS_ST, "+
			            " a.DAY2, a.R_COST_CNT, "+
						" a.C_COST_CNT as org_C_COST_CNT, "+
						" a.R_CNT2_1, a.R_CNT2_2, "+
						" a.SUM_COST_CNT, a.SUM_BUS_1, a.SUM_BUS_2, "+
						" a.AVG_COST_CNT, a.AVG_BUS_1, a.AVG_BUS_2, "+
						" to_char(to_number(a.C_TOT_CNT),decode(sign(1-to_number(a.C_TOT_CNT)),-1,'999.99','0.99')) C_TOT_CNT, "+
						" a.V_CNT_PER, a.V_COST_PER, a.AVG_CAR_COST_1, a.AVG_CAR_COST_2, a.cost_cnt1, a.cost_cnt2, "+
						" substr(a.V_CS_DT,1,4) year, substr(a.V_CS_DT,5,2) tm "+
						" from "+
						" ("+
						"		select * from stat_bus_cmp where save_dt='"+save_dt+"'"+
						" ) a, "+
						" users b, (select * from code where c_st='0002') c "+
						" where a.bus_id=b.user_id and b.dept_id=c.code and b.loan_st = '2' "+
				        "       and b.br_id not in ('S1','S2','I1','S3','S4','S5','S6') and b.user_id not in ('000167')"+
						" ";


		if(!loan_st.equals("") && ns_dt.equals(""))		query += " and sysdate-to_date(b.enter_dt,'YYYYMMDD') >= 365 and b.loan_st='"+loan_st+"'";

		if(loan_st.equals("") && !ns_dt.equals(""))		query += " and b.enter_dt between '"+ns_dt+"' and '"+ne_dt+"'";


		query += " order by decode(nvl(a.CMP_DISCNT_PER,''),'',1,0), "+
				 "          decode(nvl(a.dalsung,0),0,2,'',2,1), "+
			     "          to_number(nvl(a.org_dalsung,'0')) desc, "+
				 "	        to_number(nvl(a.C_TOT_CNT,'0')) desc, "+
				 "          to_number(nvl(a.CMP_DISCNT_PER,'0')) desc, b.enter_dt, b.user_id";

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
			System.out.println("[CampaignDatabase:getCampaignList_2014_05_sc4(String save_dt, String loan_st, String ns_dt, String ne_dt)]"+e);
			System.out.println("[CampaignDatabase:getCampaignList_2014_05_sc4(String save_dt, String loan_st, String ns_dt, String ne_dt)]"+query);
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
	 * 결과 :마감테이블 조회
	*/
	public Vector getCampaignSik_2014_05(String save_dt, String loan_st, String enter_st, String enter_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query = " select b.dept_id, b.user_nm, b.user_id, b.loan_st, c.nm_cd, "+
						" a.SAVE_DT, a.SEQ, a.BUS_ID, "+
						" to_char(to_number(a.RENT_CNT),'999.99') RENT_CNT, to_char(to_number(a.START_CNT),'999.99') START_CNT, to_char(to_number(CNT1),'999.99') CNT1, "+
						" to_char(to_number(a.R_RENT_CNT),'999.99') R_RENT_CNT, to_char(to_number(a.R_START_CNT),'999.99') R_START_CNT, to_char(to_number(R_CNT),'999.99') R_CNT, a.DAY, "+
						" to_char(to_number(a.R_CNT2),'0.99999') R_CNT2, to_char(to_number(a.PRE_CMP),'0.99999') PRE_CMP, to_char(to_number(a.PRE_CMP_GA),'0.99999') PRE_CMP_GA,  "+
						" a.C_DAY, to_char(to_number(a.CMP_DISCNT_PER),'999.99') CMP_DISCNT_PER, "+
						" to_char(to_number(a.C_RENT_CNT),'999.99') C_RENT_CNT, to_char(to_number(a.C_START_CNT),'999.99') C_START_CNT, to_char(to_number(a.C_CNT),'999.99') C_CNT, "+
						" to_char(to_number(a.CR_RENT_CNT),'999.99') CR_RENT_CNT, to_char(to_number(a.CR_START_CNT),'999.99') CR_START_CNT, to_char(to_number(a.CR_CNT),'999.99') CR_CNT, "+
						" to_char(to_number(a.CR_CNT2),'999.99') CR_CNT2, a.AVG_CAR_CNT, "+
						" to_char(to_number(a.DALSUNG),'999.99') DALSUNG, to_char(to_number(a.AMT)) amt, a.AVG_DALSUNG, to_char(to_number(a.AMT2)) amt2,  "+
						" a.SUM_CNT1, a.SUM_R_CNT, a.SUM_BUS, "+
						" a.AVG_CNT1, a.AVG_R_CNT, to_char(to_number(a.AVG_BUS),'0.99999') AVG_BUS, to_char(to_number(a.AVG_LOW_BUS),'0.99999') AVG_LOW_BUS,  "+
						" a.V_BS_DT, a.V_BE_DT, a.V_BS_DT2, a.V_BE_DT2, a.V_CS_DT, a.V_CE_DT, a.V_CAR_AMT,  "+
						" a.V_BUS_UP_PER, a.V_BUS_DOWN_PER, a.V_MNG_UP_PER, a.V_MNG_DOWN_PER, a.V_BUS_AMT_PER, a.V_MNG_AMT_PER, a.V_CNT1, a.V_MON, a.V_CNT2,  "+
						" a.V_CMP_DISCNT_PER, a.V_MAX_DALSUNG, a.V_BUS_GA, a.V_MNG_GA, a.V_BUS_NEW_GA, a.REG_DT, a.V_ENTER_DT, to_char(to_number(a.ORG_DALSUNG),'9999.99') ORG_DALSUNG,  "+
						" a.V_NM_CNT3, a.V_NE_DT3, a.V_NS_DT3, a.V_NB_CNT2, a.V_NM_CNT2, a.V_NE_DT2, a.V_NS_DT2, a.V_NB_CNT1, a.V_NM_CNT1, a.V_NE_DT1, a.V_NS_DT1, a.V_NB_CNT3, a.BUS_ST, "+
			            " a.DAY2, to_char(to_number(a.R_COST_CNT),'999.99') R_COST_CNT, to_char(to_number(a.C_COST_CNT),'999.99') C_COST_CNT, "+
						" to_char(to_number(a.R_CNT2_1),'0.99999') R_CNT2_1, to_char(to_number(a.R_CNT2_2),'0.99999') R_CNT2_2, "+
						" a.SUM_COST_CNT, a.SUM_BUS_1, a.SUM_BUS_2, "+
						" a.AVG_COST_CNT, to_char(to_number(a.AVG_BUS_1),'0.99999') AVG_BUS_1, to_char(to_number(a.AVG_BUS_2),'0.99999') AVG_BUS_2, "+
						" to_char(to_number(a.C_TOT_CNT),'999.99') C_TOT_CNT, a.V_CNT_PER, a.V_COST_PER, a.AVG_CAR_COST_1, a.AVG_CAR_COST_2	"+
			           " from stat_bus_cmp a, users b, (select * from code where c_st='0002') c where a.bus_id=b.user_id and b.dept_id=c.code and a.save_dt='"+save_dt+"'";

		if(loan_st.equals("1")){
			query += " and b.loan_st='1' ";
		}else if(loan_st.equals("2")){
			query += " and b.loan_st='2' ";
		}else if(loan_st.equals("1_1")){
			query += " and b.loan_st='1' and b.br_id in ('S1','S2','S3','S4','S5','S6','I1')";
		}else if(loan_st.equals("1_2")){
			query += " and b.loan_st='1' and b.br_id not in ('S1','S2','S3','S4','S5','S6','I1') ";
		}else if(loan_st.equals("2_1")){
			query += " and b.loan_st='2' and b.br_id in ('S1','S2','I1','S3','S4','S5','S6')";
		}else if(loan_st.equals("2_2")){
			query += " and b.loan_st='2' and b.br_id not in ('S1','S2','I1','S3','S4','S5','S6') ";
		}

		if(enter_st.equals("n")){//신입
				query += " and a.DALSUNG is null";
		}else{
				query += " and a.DALSUNG is not null";
		}

		query += " order by decode(a.org_dalsung,0,2,'',2,1), to_number(a.org_dalsung) desc, a.seq";

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
			System.out.println("[CampaignDatabase:getCampaignSik_2014_05(String save_dt, String loan_st, String enter_dt)]"+e);
			System.out.println("[CampaignDatabase:getCampaignSik_2014_05(String save_dt, String loan_st, String enter_dt)]"+query);
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
	*	변수수정 - 1군(관리)
	*/
	
	public int updateCampaignVar_20140501(String year, String tm, String loan_st, String cs_dt, String ce_dt, String bs_dt, String be_dt, int up_per, int down_per, int amt_per, int car_amt, int max_dalsung, int ga, int new_ga, String ns_dt1, String ns_dt2, String ns_dt3, String ns_dt4, String ne_dt1, String ne_dt2, String ne_dt3, String ne_dt4, int n_cnt1, int n_cnt2, int n_cnt3, int n_cnt4, int cnt_per, int cost_per, String base_end_dt1, String base_end_dt2, int min_dalsung){


		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = " UPDATE campaign_var SET "+
							    " cs_dt=?, ce_dt=?, up_per=?, down_per=?, amt_per=?, car_amt=?, "+
								" bs_dt=?, be_dt=?, max_dalsung=?, ga=?, new_ga=?, "+
								" ns_dt1=?, ns_dt2=?, ns_dt3=?, ns_dt4=?, ne_dt1=?, ne_dt2=?, ne_dt3=?, ne_dt4=?, "+
								" n_cnt1=?, n_cnt2=?, n_cnt3=?, n_cnt4=?,  "+
								" cnt_per=?, cost_per=?, base_end_dt1=?, base_end_dt2=?, min_dalsung=? "+
						" WHERE year=? and tm=? and loan_st=? ";
			
		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  cs_dt);
			pstmt.setString(2,  ce_dt);
			pstmt.setInt   (3,  up_per);
			pstmt.setInt   (4,  down_per);		
			pstmt.setInt   (5,  amt_per);
			pstmt.setInt   (6,  car_amt);			
			pstmt.setString(7,  bs_dt);
			pstmt.setString(8,  be_dt);
			pstmt.setInt   (9,  max_dalsung);
			pstmt.setInt   (10, ga);
			pstmt.setInt   (11, new_ga);			
			pstmt.setString(12, ns_dt1);
			pstmt.setString(13, ns_dt2);
			pstmt.setString(14, ns_dt3);
			pstmt.setString(15, ns_dt4);
			pstmt.setString(16, ne_dt1);
			pstmt.setString(17, ne_dt2);
			pstmt.setString(18, ne_dt3);
			pstmt.setString(19, ne_dt4);
			pstmt.setInt   (20, n_cnt1);
			pstmt.setInt   (21, n_cnt2);
			pstmt.setInt   (22, n_cnt3);			
			pstmt.setInt   (23, n_cnt4);		
			pstmt.setInt   (24, cnt_per);
			pstmt.setInt   (25, cost_per);			
			pstmt.setString(26, base_end_dt1);
			pstmt.setString(27, base_end_dt2);
			pstmt.setInt   (28, min_dalsung);
			pstmt.setString(29, year);
			pstmt.setString(30, tm);
			pstmt.setString(31, loan_st);
			result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		}catch(SQLException e){
			System.out.println("[CampaignDatabase:updateCampaignVar_20140501]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return result;
		}
	}

	/**
	*	변수등록
	*/
	public int insertCampaignVar_20140501(String year, String tm, String loan_st, String cs_dt, String ce_dt, String bs_dt, String be_dt, int up_per, int down_per, int amt_per, int car_amt, int max_dalsung, int ga, int new_ga, String ns_dt1, String ns_dt2, String ns_dt3, String ns_dt4, String ne_dt1, String ne_dt2, String ne_dt3, String ne_dt4, int n_cnt1, int n_cnt2, int n_cnt3, int n_cnt4, int cnt_per, int cost_per, String base_end_dt1, String base_end_dt2, int min_dalsung){

		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;

		String query = "insert into campaign_var "+
			" (  year, tm, loan_st, cs_dt, ce_dt, bs_dt, be_dt, "+
			"	 up_per, down_per, amt_per, car_amt, max_dalsung, ga, new_ga, "+
			"	 ns_dt1, ns_dt2, ns_dt3, ns_dt4, ne_dt1, ne_dt2, ne_dt3, ne_dt4, n_cnt1, n_cnt2, n_cnt3, n_cnt4, "+
			"    cnt_per, cost_per, base_end_dt1, base_end_dt2, min_dalsung "+
			"    ) "+
			" values "+
			" (  ?, ?, ?, ?, ?, ?, ?, "+
			"    ?, ?, ?, ?, ?, ?, ?, "+
			"    ?, ?, ?, ?, ?,  ?, ?, ?, ?, ?, ?, ?, "+	
			"    ?, ?, ?, ?, ? "+
			" )";

		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,  year);
			pstmt.setString	(2,  tm);
			pstmt.setString	(3,  loan_st);
			pstmt.setString (4,  cs_dt);
			pstmt.setString (5,  ce_dt);
			pstmt.setString (6,  bs_dt);
			pstmt.setString (7,  be_dt);
			pstmt.setInt	(8,  up_per);
			pstmt.setInt	(9,  down_per);
			pstmt.setInt	(10, amt_per);
			pstmt.setInt	(11, car_amt);
			pstmt.setInt	(12, max_dalsung);
			pstmt.setInt	(13, ga);
			pstmt.setInt	(14, new_ga);
			pstmt.setString	(15, ns_dt1);
			pstmt.setString	(16, ns_dt2);
			pstmt.setString	(17, ns_dt3);
			pstmt.setString	(18, ns_dt4);
			pstmt.setString	(19, ne_dt1);
			pstmt.setString	(20, ne_dt2);
			pstmt.setString	(21, ne_dt3);
			pstmt.setString	(22, ne_dt4);
			pstmt.setInt	(23, n_cnt1);
			pstmt.setInt	(24, n_cnt2);
			pstmt.setInt	(25, n_cnt3);
			pstmt.setInt	(26, n_cnt4);
			pstmt.setInt	(27, cnt_per);
			pstmt.setInt	(28, cost_per);
			pstmt.setString	(29, base_end_dt1);
			pstmt.setString	(30, base_end_dt2);
			pstmt.setInt	(31, min_dalsung);
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		}catch(SQLException e){
			System.out.println("[CampaignDatabase:insertCampaignVar_20140501]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return result;
		}
	}

	/**
	 * 영업실적 마감 데이타 담당자별 리스트 조회
	 */
	public Vector getStatBusCmpBaseBusList_2014_05(String bus_id, String mode, String bs_dt, String be_dt, String cs_dt, String ce_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
    	String query = "";
    	String query1 = "";
    	String query2 = "";
    	String query3 = "";
		String query4 = "";
		String query5 = "";
    	String where2 = "";
    	String where3 = "";

    	String where = " a.bs_dt=replace('"+bs_dt+"','-','') and a.ce_dt=replace('"+ce_dt+"','-','') and a.bus_id='"+bus_id+"' and nvl(a.cls_st,'0') not in ('4','5')  \n";


		if(mode.equals("c")) where2 = " and a.rent_start_dt > replace('"+be_dt+"','-','') \n";

		//정상계약
		query1 = " select '1' st, \n"+
				 "        a.cnt3   as c_cnt3,	\n"+
				"         a.cnt4   as c_cnt4,	\n"+
				"         a.v_cnt4 as r_cnt4,	\n"+
				 "        a.*  \n"+
				 " from   stat_bus_cmp_base a  \n"+
				 " where  "+where+" "+where2+" AND a.car_gu<>'3' "+
				 " and a.rent_start_dt is not null "+
				 " and TO_NUMBER(a.cnt3)+TO_NUMBER(a.cnt4)+TO_NUMBER(a.v_cnt4) <> 0 \n"+
				 " ";

		//6개월미만 계약, 실경과월 6개월 이상
		query2 = " select '2' st,  \n"+
                 "        case when a.use_mon > 11 then DECODE(rent_st,'1','2','1') else DECODE(rent_st,'1','1','0.5') end c_cnt3,\n"+
                 "        case when a.use_mon > 11 then DECODE(rent_st,'1','2','1') else DECODE(rent_st,'1','1','0.5') end c_cnt4,\n"+
                 "        case when a.use_mon > 11 then DECODE(rent_st,'1','2','1') else DECODE(rent_st,'1','1','0.5') end r_cnt4,\n"+
				 "        a.*  \n"+
				 " from   stat_bus_cmp_base a  \n"+
				 " where  "+where+" and a.con_mon<6 and a.use_mon>=6 AND a.car_gu<>'3'  \n"+
				 "        and to_char(add_months(to_date(a.rent_start_dt,'YYYYMMDD'),6),'YYYYMMDD') between '"+cs_dt+"' and '"+ce_dt+"' \n"+
				 "        and a.rent_start_dt between '"+bs_dt+"' and '"+be_dt+"' \n"+
			     " ";

		//6개월이상 계약, 실경과월 6개월 미만(해지) - 캠페인기간에 계약하고 해지
		query4 = " select '3' st,  \n"+
				 "        '-'||DECODE(a.bus_st||b.bus_st,'12',b.cnt3,'22',0,a.cnt3) as c_cnt3, \n"+
				"         '-'||DECODE(a.bus_st||b.bus_st,'12',b.cnt4,'22',0,a.cnt4) as c_cnt4, \n"+
				"         '-'||DECODE(a.bus_st||b.bus_st,'12',b.v_cnt4,'22',0,a.v_cnt4) as r_cnt4, \n"+
				 "        a.*  \n"+
				 " from   stat_bus_cmp_base a, (SELECT * FROM STAT_BUS_CMP_BASE WHERE bus_st='2') b  \n"+
				 " where  "+where+" and a.con_mon>=6 and a.use_mon<6 and nvl(a.cls_st,'0') not in ('8') AND a.car_gu<>'3' \n"+
				 "        and a.cls_dt between '"+cs_dt+"' and '"+ce_dt+"'  \n"+
				 "        and a.rent_start_dt > replace('"+be_dt+"','-','') \n"+
			     "        and TO_NUMBER(a.cnt3)+TO_NUMBER(a.cnt4)+TO_NUMBER(a.v_cnt4) <> 0 "+
				 "        AND a.bs_dt=b.bs_dt(+) AND a.ce_dt=b.ce_dt(+) AND a.rent_mng_id=b.rent_mng_id(+) AND a.rent_l_cd=b.rent_l_cd(+) \n"+
				 "        and a.rent_start_dt is not null "+
				 " ";

		//월렌트
		query5 = " select '4' st, \n"+
				 "        a.cnt3   as c_cnt3,	\n"+
				"         a.cnt4   as c_cnt4,	\n"+
				"         a.v_cnt4 as r_cnt4,	\n"+
				 "        a.*  \n"+
				 " from   stat_bus_cmp_base a  \n"+
				 " where  "+where+" "+where2+" AND a.car_gu='3' \n"+
				 " ";


		query =	" select \n"+
				"      a.*,  \n"+
				"      a.c_cnt3 as cc_cnt3,  \n"+
				"      a.c_cnt4 as cc_cnt4,  \n"+
				"      a.r_cnt4 as rr_cnt4,  \n"+
				"      b.firm_nm,  \n"+
                "      decode(a.car_gu,'3',decode(substr(a.bus_st,1,2),'21',h.user_nm,d.user_nm),decode(a.bus_st,'1',d.user_nm)) as bus_nm,  \n"+
				"	   decode(a.car_gu,'3',decode(substr(a.bus_st,1,2),'11',e.user_nm,'21',e.USER_NM,''),decode(a.bus_st,'1',e.user_nm,'2',d.user_nm,'3',e.user_nm)) as bus_agnt_nm,   \n"+
				"	   decode(a.car_gu,'3','',decode(a.bus_st,'1',g.user_nm,'3',d.user_nm,'2',g.user_nm)) as bus_nm2,  \n"+
				"      decode(a.st,'3','해지' ,'4',decode(substr(a.bus_st,2),'1','월렌트','월렌트(연장)'), decode(a.rent_st,'1',decode(c.car_gu,'0','재리스',decode(c.rent_st,'1','신규','3','대차','4','증차')),'연장')) gubun,  \n"+
				"      decode(a.car_gu,'3',decode(a.bus_st,'11','최초계약자','21','영업대리인','관리담당자'),decode(a.bus_st,'1','최초계약자','2','영업대리인','3','영업담당자')) gubun2,  \n"+
				"      nvl(f.ext_agnt,c.bus_id) f_bus_id,  \n"+
				"      decode(a.bus_emp_id,'','','있음') bus_emp_id_yn, decode(a.rent_way,'1','일반식','기본식') rent_way_nm "+
				" from  \n"+
				"      ( "+query1+" union all "+query2+" "+
				"        union all "+query4+"  union all "+query5+" )  a, \n"+
				"	   client b, cont c, users d, users e, fee f, users g, users h  \n"+
				" where  \n"+
				       where+
				"      and a.client_id=b.client_id "+
				"      and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) "+
				"      and a.bus_id=d.user_id(+) and a.bus_agnt_id=e.user_id(+) \n"+
				"	   and a.rent_mng_id=f.rent_mng_id(+) and a.rent_l_cd=f.rent_l_cd(+) and a.rent_st=f.rent_st(+) "+
				"      and a.bus_id2=g.user_id(+) \n"+
				"      and c.bus_id=h.user_id(+) \n"+
                "      and CASE WHEN a.bus_st='3' and e.user_nm=d.user_nm and a.r_cnt4=0 then 'N' else 'Y' end = 'Y' "+
				" order by a.st, decode(a.cls_dt,'',0,1), a.cls_dt, b.firm_nm, a.rent_dt, a.rent_start_dt, a.rent_mng_id \n";
				


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
			System.out.println("[CampaignDatabase:getStatBusCmpBaseBusList_2014_05]\n"+e);
			System.out.println("[CampaignDatabase:getStatBusCmpBaseBusList_2014_05]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}	

	/**
	 * 결과 :영업캠페인 마감테이블 조회
	*/
	public Vector getCampaignList_2019_05_sc(String save_dt, String loan_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query =  " select b.dept_id, b.user_nm, b.user_id, b.loan_st, decode(b.loan_st,'1','1군','2','2군') loan_st_nm, b.enter_dt, b.bus_cmp_yn, c.nm_cd, "+
						" a.SAVE_DT, a.SEQ, a.BUS_ID, a.RENT_CNT, a.START_CNT, a.CNT1, a.R_RENT_CNT, a.R_START_CNT, a.R_CNT, a.DAY, a.R_CNT2, a.PRE_CMP, a.PRE_CMP_GA,  "+
						" a.C_DAY, "+
						" a.C_RENT_CNT, a.C_START_CNT, "+
						" a.CR_RENT_CNT, a.CR_START_CNT, "+
						" a.SUM_CNT1, a.SUM_R_CNT, a.SUM_BUS, a.AVG_CNT1, a.AVG_R_CNT, a.AVG_BUS, a.AVG_LOW_BUS,  "+
						" a.V_BS_DT, a.V_BE_DT, a.V_BS_DT2, a.V_BE_DT2, a.V_CS_DT, a.V_CE_DT, a.V_CAR_AMT, a.V_CAR_AMT2,  "+
						" a.V_BUS_UP_PER, a.V_BUS_DOWN_PER, a.V_MNG_UP_PER, a.V_MNG_DOWN_PER, a.V_BUS_AMT_PER, a.V_MNG_AMT_PER, a.V_CNT1, a.V_MON, a.V_CNT2,  "+
						" to_char(to_number(a.C_CNT),decode(sign(1-to_number(a.C_CNT)),-1,'999.99','0.99')) C_CNT, "+
						" to_char(to_number(a.CR_CNT),decode(sign(1-to_number(a.CR_CNT)),-1,'999.99','0.99')) CR_CNT, "+
						" to_char(to_number(a.CR_CNT2),decode(sign(1-to_number(a.CR_CNT2)),-1,'999.99','0.99')) CR_CNT2, "+
						" to_char(to_number(a.DALSUNG),decode(sign(1-to_number(a.DALSUNG)),-1,'999.99','0.99')) DALSUNG, "+
						" to_char(to_number(a.CMP_DISCNT_PER),decode(sign(1-to_number(a.CMP_DISCNT_PER)),-1,'999.99','0.99')) CMP_DISCNT_PER, "+
						" to_char(to_number(a.ORG_DALSUNG),decode(sign(1-to_number(a.ORG_DALSUNG)),-1,'999.99',1,'999.99','0.99')) ORG_DALSUNG, "+
						" to_char(to_number(a.C_COST_CNT),decode(sign(1-to_number(a.C_COST_CNT)),-1,'999.99','0.99')) C_COST_CNT, "+
						" to_char(to_number(a.AMT)) amt, a.AVG_DALSUNG, to_char(to_number(a.AMT2)) amt2,  "+
						" a.V_CMP_DISCNT_PER, a.V_MAX_DALSUNG, a.V_BUS_GA, a.V_MNG_GA, a.V_BUS_NEW_GA, a.REG_DT, a.V_ENTER_DT, "+
						" a.V_NM_CNT3, a.V_NE_DT3, a.V_NS_DT3, a.V_NB_CNT2, a.V_NM_CNT2, a.V_NE_DT2, a.V_NS_DT2, a.V_NB_CNT1, a.V_NM_CNT1, a.V_NE_DT1, a.V_NS_DT1, a.V_NB_CNT3, a.BUS_ST, "+
			            " a.DAY2, a.R_COST_CNT, "+
						" a.C_COST_CNT as org_C_COST_CNT, "+
						" a.R_CNT2_1, a.R_CNT2_2, "+
						" a.SUM_COST_CNT, a.SUM_BUS_1, a.SUM_BUS_2, "+
						" a.AVG_COST_CNT, a.AVG_BUS_1, a.AVG_BUS_2, "+
						" to_char(to_number(a.C_TOT_CNT),decode(sign(1-to_number(a.C_TOT_CNT)),-1,'999.99','0.99')) C_TOT_CNT, "+
						" a.V_CNT_PER, a.V_COST_PER, a.AVG_CAR_COST_1, a.AVG_CAR_COST_2, a.cost_cnt1, a.cost_cnt2, "+
						" substr(a.V_CS_DT,1,4) year, substr(a.V_CS_DT,5,2) tm, "+
						" decode(a.PRE_CMP_ga,0,'',to_char(1-a.PRE_CMP_ga,'0.99')) ga, a.avg_car_cnt "+
						" from "+
						" ("+
						"		select * from stat_bus_cmp_v19 where save_dt='"+save_dt+"'"+
						" ) a, "+
						" users b, (select * from code where c_st='0002') c "+
						" where a.bus_id=b.user_id and b.dept_id=c.code and b.loan_st = '"+loan_st+"'  "+
						" ";


		query += " order by nvl(b.bus_cmp_yn,'Y') desc, decode(a.CMP_DISCNT_PER,'',1,0), "+
				 "          decode(a.dalsung,0,2,'',2,1), "+
				 "          decode(a.org_dalsung,0,2,'',2,1), "+
			     "          to_number(a.org_dalsung) desc, to_number(a.C_TOT_CNT) desc, to_number(a.CMP_DISCNT_PER) desc, b.enter_dt, b.user_id";

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
			System.out.println("[CampaignDatabase:getCampaignList_2019_05_sc(String save_dt, String loan_st)]"+e);
			System.out.println("[CampaignDatabase:getCampaignList_2019_05_sc(String save_dt, String loan_st)]"+query);
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
	 * 결과 :마감테이블 조회
	*/
	public Vector getCampaignSik_2019_05(String save_dt, String loan_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query = " select b.dept_id, b.user_nm, b.user_id, b.loan_st, c.nm_cd, "+
						" a.SAVE_DT, a.SEQ, a.BUS_ID, "+
						" to_char(to_number(a.RENT_CNT),'999.99') RENT_CNT, to_char(to_number(a.START_CNT),'999.99') START_CNT, to_char(to_number(CNT1),'999.99') CNT1, "+
						" to_char(to_number(a.R_RENT_CNT),'999.99') R_RENT_CNT, to_char(to_number(a.R_START_CNT),'999.99') R_START_CNT, to_char(to_number(R_CNT),'999.99') R_CNT, a.DAY, "+
						" to_char(to_number(a.R_CNT2),'0.99999') R_CNT2, to_char(to_number(a.PRE_CMP),'0.99999') PRE_CMP, to_char(to_number(a.PRE_CMP_GA),'0.99999') PRE_CMP_GA,  "+
						" a.C_DAY, to_char(to_number(a.CMP_DISCNT_PER),'999.99') CMP_DISCNT_PER, "+
						" to_char(to_number(a.C_RENT_CNT),'999.99') C_RENT_CNT, to_char(to_number(a.C_START_CNT),'999.99') C_START_CNT, to_char(to_number(a.C_CNT),'999.99') C_CNT, "+
						" to_char(to_number(a.CR_RENT_CNT),'999.99') CR_RENT_CNT, to_char(to_number(a.CR_START_CNT),'999.99') CR_START_CNT, to_char(to_number(a.CR_CNT),'999.99') CR_CNT, "+
						" to_char(to_number(a.CR_CNT2),'999.99') CR_CNT2, a.AVG_CAR_CNT, "+
						" to_char(to_number(a.DALSUNG),'999.99') DALSUNG, to_char(to_number(a.AMT)) amt, a.AVG_DALSUNG, to_char(to_number(a.AMT2)) amt2,  "+
						" a.SUM_CNT1, a.SUM_R_CNT, a.SUM_BUS, "+
						" a.AVG_CNT1, a.AVG_R_CNT, to_char(to_number(a.AVG_BUS),'0.99999') AVG_BUS, to_char(to_number(a.AVG_LOW_BUS),'0.99999') AVG_LOW_BUS,  "+
						" a.V_BS_DT, a.V_BE_DT, a.V_BS_DT2, a.V_BE_DT2, a.V_CS_DT, a.V_CE_DT, a.V_CAR_AMT,  "+
						" a.V_BUS_UP_PER, a.V_BUS_DOWN_PER, a.V_MNG_UP_PER, a.V_MNG_DOWN_PER, a.V_BUS_AMT_PER, a.V_MNG_AMT_PER, a.V_CNT1, a.V_MON, a.V_CNT2,  "+
						" a.V_CMP_DISCNT_PER, a.V_MAX_DALSUNG, a.V_BUS_GA, a.V_MNG_GA, a.V_BUS_NEW_GA, a.REG_DT, a.V_ENTER_DT, to_char(to_number(a.ORG_DALSUNG),'9999.99') ORG_DALSUNG,  "+
						" a.V_NM_CNT3, a.V_NE_DT3, a.V_NS_DT3, a.V_NB_CNT2, a.V_NM_CNT2, a.V_NE_DT2, a.V_NS_DT2, a.V_NB_CNT1, a.V_NM_CNT1, a.V_NE_DT1, a.V_NS_DT1, a.V_NB_CNT3, a.BUS_ST, "+
			            " a.DAY2, to_char(to_number(a.R_COST_CNT),'999.99') R_COST_CNT, to_char(to_number(a.C_COST_CNT),'999.99') C_COST_CNT, "+
						" to_char(to_number(a.R_CNT2_1),'0.99999') R_CNT2_1, to_char(to_number(a.R_CNT2_2),'0.99999') R_CNT2_2, "+
						" a.SUM_COST_CNT, a.SUM_BUS_1, a.SUM_BUS_2, "+
						" a.AVG_COST_CNT, to_char(to_number(a.AVG_BUS_1),'0.99999') AVG_BUS_1, to_char(to_number(a.AVG_BUS_2),'0.99999') AVG_BUS_2, "+
						" to_char(to_number(a.C_TOT_CNT),'999.99') C_TOT_CNT, a.V_CNT_PER, a.V_COST_PER, a.AVG_CAR_COST_1, a.AVG_CAR_COST_2	"+
			           " from stat_bus_cmp_v19 a, users b, (select * from code where c_st='0002') c where a.bus_id=b.user_id and b.dept_id=c.code and a.save_dt='"+save_dt+"'";

		if(loan_st.equals("1")){
			query += " and b.loan_st='1' ";
		}else if(loan_st.equals("2")){
			query += " and b.loan_st='2' ";
		}

		query += " order by decode(a.org_dalsung,0,2,'',2,1), to_number(a.org_dalsung) desc, a.seq";

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
			System.out.println("[CampaignDatabase:getCampaignSik_2019_05(String save_dt, String loan_st)]"+e);
			System.out.println("[CampaignDatabase:getCampaignSik_2019_05(String save_dt, String loan_st)]"+query);
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
	 * 결과 :마감테이블 조회
	*/
	public Hashtable getCampaignCase_2019_05(String save_dt, String bus_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();

		String query =  " select b.dept_id, b.user_nm, b.user_id, b.loan_st, c.nm_cd, "+
						"		 a.SAVE_DT, a.SEQ, a.BUS_ID, "+
						"		 to_char(to_number(a.RENT_CNT),'999.99') RENT_CNT, to_char(to_number(a.START_CNT),'999.99') START_CNT, to_char(to_number(CNT1),'999.99') CNT1, "+
						"		 to_char(to_number(a.R_RENT_CNT),'999.99') R_RENT_CNT, to_char(to_number(a.R_START_CNT),'999.99') R_START_CNT, to_char(to_number(R_CNT),'999.99') R_CNT, a.DAY, "+
						"		 to_char(to_number(a.R_CNT2),'0.99999') R_CNT2, to_char(to_number(a.PRE_CMP),'0.99999') PRE_CMP, to_char(to_number(a.PRE_CMP_GA),'0.99999') PRE_CMP_GA,  "+
						"		 a.C_DAY, to_char(to_number(a.CMP_DISCNT_PER),'999.99') CMP_DISCNT_PER, "+
						"		 to_char(to_number(a.C_RENT_CNT),'999.99') C_RENT_CNT, to_char(to_number(a.C_START_CNT),'999.99') C_START_CNT, to_char(to_number(a.C_CNT),'999.99') C_CNT, "+
						"		 to_char(to_number(a.CR_RENT_CNT),'999.99') CR_RENT_CNT, to_char(to_number(a.CR_START_CNT),'999.99') CR_START_CNT, to_char(to_number(a.CR_CNT),'999.99') CR_CNT, "+
						"		 to_char(to_number(a.DALSUNG),'999.99') DALSUNG, to_char(to_number(a.AMT)) amt, a.AVG_DALSUNG, to_char(to_number(a.AMT2)) amt2,  "+
						"		 a.SUM_CNT1, a.SUM_R_CNT, a.SUM_BUS, "+
						"		 a.AVG_CNT1, a.AVG_R_CNT, to_char(to_number(a.AVG_BUS),'0.99999') AVG_BUS, to_char(to_number(a.AVG_LOW_BUS),'0.99999') AVG_LOW_BUS,  "+
						"		 a.V_BS_DT, a.V_BE_DT, a.V_BS_DT2, a.V_BE_DT2, a.V_CS_DT, a.V_CE_DT, a.V_CAR_AMT,  "+
						"		 a.V_BUS_UP_PER, a.V_BUS_DOWN_PER, a.V_MNG_UP_PER, a.V_MNG_DOWN_PER, a.V_BUS_AMT_PER, a.V_MNG_AMT_PER, a.V_CNT1, a.V_MON, a.V_CNT2,  "+
						"		 a.V_CMP_DISCNT_PER, a.V_MAX_DALSUNG, a.V_BUS_GA, a.V_MNG_GA, a.V_BUS_NEW_GA, a.REG_DT, a.V_ENTER_DT, to_char(to_number(a.ORG_DALSUNG),'999.99') ORG_DALSUNG,  "+
						"		 a.V_NM_CNT3, a.V_NE_DT3, a.V_NS_DT3, a.V_NB_CNT2, a.V_NM_CNT2, a.V_NE_DT2, a.V_NS_DT2, a.V_NB_CNT1, a.V_NM_CNT1, a.V_NE_DT1, a.V_NS_DT1, a.V_NB_CNT3, a.BUS_ST, "+
			            "		 a.DAY2, to_char(to_number(a.R_COST_CNT),'999.99') R_COST_CNT, to_char(to_number(a.C_COST_CNT),'999.99') C_COST_CNT, "+
						"		 to_char(to_number(a.R_CNT2_1),'0.99999') R_CNT2_1, to_char(to_number(a.R_CNT2_2),'0.99999') R_CNT2_2, "+
						"		 a.SUM_COST_CNT, a.SUM_BUS_1, a.SUM_BUS_2, "+
						"		 a.AVG_COST_CNT, to_char(to_number(a.AVG_BUS_1),'0.99999') AVG_BUS_1, to_char(to_number(a.AVG_BUS_2),'0.99999') AVG_BUS_2, "+
						"		 to_char(to_number(a.C_TOT_CNT),'999.99') C_TOT_CNT, a.V_CNT_PER, a.V_COST_PER, a.AVG_CAR_COST_1, a.AVG_CAR_COST_2	"+
			            " from   stat_bus_cmp_v19 a, users b, (select * from code where c_st='0002') c where a.bus_id=b.user_id and b.dept_id=c.code "+
						" and    a.save_dt='"+save_dt+"' and a.bus_id='"+bus_id+"'";


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next())
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
			System.out.println("[CampaignDatabase:getCampaignCase_2019_05(String save_dt, String bus_id)]"+e);
			System.out.println("[CampaignDatabase:getCampaignCase_2019_05(String save_dt, String bus_id)]"+query);
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
	 * 영업실적 마감 데이타 담당자별 리스트 조회
	 */
	public Vector getStatBusCmpBaseBusList_2019_05(String bus_id, String mode, String bs_dt, String be_dt, String cs_dt, String ce_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
    	String query = "";
    	String query1 = "";
    	String query2 = "";
		String query4 = "";
		String query5 = "";
    	String where2 = "";

    	String where = " a.bs_dt=replace('"+bs_dt+"','-','') and a.ce_dt=replace('"+ce_dt+"','-','') and a.bus_id='"+bus_id+"' and nvl(a.cls_st,'0') not in ('4','5')  \n";


		if(mode.equals("c")) where2 = " and a.rent_start_dt > replace('"+be_dt+"','-','') \n";

		//정상계약
		query1 = " select '1' st, \n"+
				 "        a.cnt3   as c_cnt3,	\n"+
				"         a.cnt4   as c_cnt4,	\n"+
				"         a.v_cnt4 as r_cnt4,	\n"+
				 "        a.*  \n"+
				 " from   stat_bus_cmp_base a  \n"+
				 " where  "+where+" "+where2+" AND a.car_gu<>'3' "+
				 " and a.rent_start_dt is not null "+
				 " and TO_NUMBER(a.cnt3)+TO_NUMBER(a.cnt4)+TO_NUMBER(a.v_cnt4) <> 0 \n"+
				 " ";

		//6개월미만 계약, 실경과월 6개월 이상
		query2 = " select '2' st,  \n"+
                 "        case when a.use_mon > 11 then DECODE(rent_st,'1','2','1') else DECODE(rent_st,'1','1','0.5') end c_cnt3,\n"+
                 "        case when a.use_mon > 11 then DECODE(rent_st,'1','2','1') else DECODE(rent_st,'1','1','0.5') end c_cnt4,\n"+
                 "        case when a.use_mon > 11 then DECODE(rent_st,'1','2','1') else DECODE(rent_st,'1','1','0.5') end r_cnt4,\n"+
				 "        a.*  \n"+
				 " from   stat_bus_cmp_base a  \n"+
				 " where  "+where+" and a.con_mon<6 and a.use_mon>=6 AND a.car_gu<>'3'  \n"+
				 "        and to_char(add_months(to_date(a.rent_start_dt,'YYYYMMDD'),6),'YYYYMMDD') between '"+cs_dt+"' and '"+ce_dt+"' \n"+
				 "        and a.rent_start_dt between '"+bs_dt+"' and '"+be_dt+"' \n"+
			     " ";

		//6개월이상 계약, 실경과월 6개월 미만(해지) - 캠페인기간에 계약하고 해지
		query4 = " select '3' st,  \n"+
				 "        '-'||DECODE(a.bus_st||b.bus_st,'12',b.cnt3,'22',0,a.cnt3) as c_cnt3, \n"+
				"         '-'||DECODE(a.bus_st||b.bus_st,'12',b.cnt4,'22',0,a.cnt4) as c_cnt4, \n"+
				"         '-'||DECODE(a.bus_st||b.bus_st,'12',b.v_cnt4,'22',0,a.v_cnt4) as r_cnt4, \n"+
				 "        a.*  \n"+
				 " from   stat_bus_cmp_base a, (SELECT * FROM STAT_BUS_CMP_BASE WHERE bus_st='2') b  \n"+
				 " where  "+where+" and a.con_mon>=6 and a.use_mon<6 and nvl(a.cls_st,'0') not in ('8') AND a.car_gu<>'3' \n"+
				 "        and a.cls_dt between '"+cs_dt+"' and '"+ce_dt+"'  \n"+
				 "        and a.rent_start_dt > replace('"+be_dt+"','-','') \n"+
			     "        and TO_NUMBER(a.cnt3)+TO_NUMBER(a.cnt4)+TO_NUMBER(a.v_cnt4) <> 0 "+
				 "        AND a.bs_dt=b.bs_dt(+) AND a.ce_dt=b.ce_dt(+) AND a.rent_mng_id=b.rent_mng_id(+) AND a.rent_l_cd=b.rent_l_cd(+) \n"+
				 "        and a.rent_start_dt is not null "+
				 " ";

		//월렌트
		query5 = " select '4' st, \n"+
				 "        a.cnt3   as c_cnt3,	\n"+
				"         a.cnt4   as c_cnt4,	\n"+
				"         a.v_cnt4 as r_cnt4,	\n"+
				 "        a.*  \n"+
				 " from   stat_bus_cmp_base a  \n"+
				 " where  "+where+" "+where2+" AND a.car_gu='3' \n"+
				 " ";


		query =	" select \n"+
				"      a.*,  \n"+
				"      a.c_cnt3 as cc_cnt3,  \n"+
				"      a.c_cnt4 as cc_cnt4,  \n"+
				"      a.r_cnt4 as rr_cnt4,  \n"+
				"      b.firm_nm,  \n"+
                "      decode(a.car_gu,'3',decode(substr(a.bus_st,1,2),'21',h.user_nm,d.user_nm),decode(a.bus_st,'1',d.user_nm)) as bus_nm,  \n"+
				"	   decode(a.car_gu,'3',decode(substr(a.bus_st,1,2),'11',e.user_nm,'21',e.USER_NM,''),decode(a.bus_st,'1',e.user_nm,'2',d.user_nm,'3',e.user_nm)) as bus_agnt_nm,   \n"+
				"	   decode(a.car_gu,'3','',decode(a.bus_st,'1',g.user_nm,'3',d.user_nm,'2',g.user_nm)) as bus_nm2,  \n"+
				"      decode(a.st,'3','해지' ,'4',decode(substr(a.bus_st,2),'1','월렌트','월렌트(연장)'), decode(a.rent_st,'1',decode(c.car_gu,'0','재리스',decode(c.rent_st,'1','신규','3','대차','4','증차')),'연장')) gubun,  \n"+
				"      decode(a.car_gu,'3',decode(a.bus_st,'11','최초계약자','21','영업대리인','관리담당자'),decode(a.bus_st,'1','최초계약자','2','영업대리인','3','영업담당자')) gubun2,  \n"+
				"      nvl(f.ext_agnt,c.bus_id) f_bus_id,  \n"+
				"      decode(a.bus_emp_id,'','','있음') bus_emp_id_yn, decode(a.rent_way,'1','일반식','기본식') rent_way_nm, b2.first_rent_start_dt2 "+
				" from  \n"+
				"      ( "+query1+" union all "+query2+" "+
				"        union all "+query4+"  union all "+query5+" )  a, \n"+
				"	   client b, cont c, users d, users e, fee f, users g, users h, (select client_id, min(rent_dt) first_rent_start_dt2 from cont group by client_id) b2   \n"+
				" where  \n"+
				       where+
				"      and a.client_id=b.client_id and a.client_id=b2.client_id "+
				"      and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) "+
				"      and a.bus_id=d.user_id(+) and a.bus_agnt_id=e.user_id(+) \n"+
				"	   and a.rent_mng_id=f.rent_mng_id(+) and a.rent_l_cd=f.rent_l_cd(+) and a.rent_st=f.rent_st(+) "+
				"      and a.bus_id2=g.user_id(+) \n"+
				"      and c.bus_id=h.user_id(+) \n"+
                "      and CASE WHEN a.bus_st='3' and e.user_nm=d.user_nm and a.r_cnt4=0 then 'N' else 'Y' end = 'Y' "+
				" order by a.car_off_enp_no, a.rent_start_dt, a.st, decode(a.cls_dt,'',0,1), a.cls_dt, b.firm_nm, a.rent_dt, a.rent_start_dt, a.rent_mng_id \n";
				


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
			System.out.println("[CampaignDatabase:getStatBusCmpBaseBusList_2019_05]\n"+e);
			System.out.println("[CampaignDatabase:getStatBusCmpBaseBusList_2019_05]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}
	
	/**
	*	변수등록
	*/
	public int insertCampaignVar_201905(String year, String tm, String loan_st, String cs_dt, String ce_dt, String bs_dt, String be_dt, int up_per, int down_per, int amt_per, int car_amt, int max_dalsung, int ga, int new_ga, String ns_dt1, String ns_dt2, String ns_dt3, String ns_dt4, String ne_dt1, String ne_dt2, String ne_dt3, String ne_dt4, int n_cnt1, int n_cnt2, int n_cnt3, int n_cnt4, int cnt_per, int cost_per, String base_end_dt1, String base_end_dt2, int min_dalsung, float new_mon_ga){

		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;

		String query = "insert into campaign_var "+
			" (  year, tm, loan_st, cs_dt, ce_dt, bs_dt, be_dt, "+
			"	 up_per, down_per, amt_per, car_amt, max_dalsung, ga, new_ga, "+
			"	 ns_dt1, ns_dt2, ns_dt3, ns_dt4, ne_dt1, ne_dt2, ne_dt3, ne_dt4, n_cnt1, n_cnt2, n_cnt3, n_cnt4, "+
			"    cnt_per, cost_per, base_end_dt1, base_end_dt2, min_dalsung, new_mon_ga "+
			"    ) "+
			" values "+
			" (  ?, ?, ?, ?, ?, ?, ?, "+
			"    ?, ?, ?, ?, ?, ?, ?, "+
			"    ?, ?, ?, ?, ?,  ?, ?, ?, ?, ?, ?, ?, "+	
			"    ?, ?, ?, ?, ?, ? "+
			" )";

		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,  year);
			pstmt.setString	(2,  tm);
			pstmt.setString	(3,  loan_st);
			pstmt.setString (4,  cs_dt);
			pstmt.setString (5,  ce_dt);
			pstmt.setString (6,  bs_dt);
			pstmt.setString (7,  be_dt);
			pstmt.setInt	(8,  up_per);
			pstmt.setInt	(9,  down_per);
			pstmt.setInt	(10, amt_per);
			pstmt.setInt	(11, car_amt);
			pstmt.setInt	(12, max_dalsung);
			pstmt.setInt	(13, ga);
			pstmt.setInt	(14, new_ga);
			pstmt.setString	(15, ns_dt1);
			pstmt.setString	(16, ns_dt2);
			pstmt.setString	(17, ns_dt3);
			pstmt.setString	(18, ns_dt4);
			pstmt.setString	(19, ne_dt1);
			pstmt.setString	(20, ne_dt2);
			pstmt.setString	(21, ne_dt3);
			pstmt.setString	(22, ne_dt4);
			pstmt.setInt	(23, n_cnt1);
			pstmt.setInt	(24, n_cnt2);
			pstmt.setInt	(25, n_cnt3);
			pstmt.setInt	(26, n_cnt4);
			pstmt.setInt	(27, cnt_per);
			pstmt.setInt	(28, cost_per);
			pstmt.setString	(29, base_end_dt1);
			pstmt.setString	(30, base_end_dt2);
			pstmt.setInt	(31, min_dalsung);
			pstmt.setFloat	(32, new_mon_ga);
			
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		}catch(SQLException e){
			System.out.println("[CampaignDatabase:insertCampaignVar_201905]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return result;
		}
	}	
	
	/**
	*	변수수정 - 1군(관리)
	*/
	
	public int updateCampaignVar_201905(String year, String tm, String loan_st, String cs_dt, String ce_dt, String bs_dt, String be_dt, int up_per, int down_per, int amt_per, int car_amt, int max_dalsung, int ga, int new_ga, String ns_dt1, String ns_dt2, String ns_dt3, String ns_dt4, String ne_dt1, String ne_dt2, String ne_dt3, String ne_dt4, int n_cnt1, int n_cnt2, int n_cnt3, int n_cnt4, int cnt_per, int cost_per, String base_end_dt1, String base_end_dt2, int min_dalsung, float new_mon_ga){


		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = " UPDATE campaign_var SET "+
							    " cs_dt=?, ce_dt=?, up_per=?, down_per=?, amt_per=?, car_amt=?, "+
								" bs_dt=?, be_dt=?, max_dalsung=?, ga=?, new_ga=?, "+
								" ns_dt1=?, ns_dt2=?, ns_dt3=?, ns_dt4=?, ne_dt1=?, ne_dt2=?, ne_dt3=?, ne_dt4=?, "+
								" n_cnt1=?, n_cnt2=?, n_cnt3=?, n_cnt4=?,  "+
								" cnt_per=?, cost_per=?, base_end_dt1=?, base_end_dt2=?, min_dalsung=?, new_mon_ga=? "+
						" WHERE year=? and tm=? and loan_st=? ";
			
		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  cs_dt);
			pstmt.setString(2,  ce_dt);
			pstmt.setInt   (3,  up_per);
			pstmt.setInt   (4,  down_per);		
			pstmt.setInt   (5,  amt_per);
			pstmt.setInt   (6,  car_amt);			
			pstmt.setString(7,  bs_dt);
			pstmt.setString(8,  be_dt);
			pstmt.setInt   (9,  max_dalsung);
			pstmt.setInt   (10, ga);
			pstmt.setInt   (11, new_ga);			
			pstmt.setString(12, ns_dt1);
			pstmt.setString(13, ns_dt2);
			pstmt.setString(14, ns_dt3);
			pstmt.setString(15, ns_dt4);
			pstmt.setString(16, ne_dt1);
			pstmt.setString(17, ne_dt2);
			pstmt.setString(18, ne_dt3);
			pstmt.setString(19, ne_dt4);
			pstmt.setInt   (20, n_cnt1);
			pstmt.setInt   (21, n_cnt2);
			pstmt.setInt   (22, n_cnt3);			
			pstmt.setInt   (23, n_cnt4);		
			pstmt.setInt   (24, cnt_per);
			pstmt.setInt   (25, cost_per);			
			pstmt.setString(26, base_end_dt1);
			pstmt.setString(27, base_end_dt2);
			pstmt.setInt   (28, min_dalsung);
			pstmt.setFloat (29, new_mon_ga);
			pstmt.setString(30, year);
			pstmt.setString(31, tm);
			pstmt.setString(32, loan_st);
			result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		}catch(SQLException e){
			System.out.println("[CampaignDatabase:updateCampaignVar_201905]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return result;
		}
	}	
	
	/**
	 * 영업실적 마감 데이타 (영업효율) 담당자별 리스트 조회
	 */
	public Vector getStatBusCmpBaseBusCostListRmRetroact(String bus_id, String mode, String bs_dt, String be_dt, String cs_dt, String ce_dt, float avg_cost_cnt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

    	    	String query = "";
    	String sub_query = "";
    	String sub_query2 = "";
		String where = "";
		String where2 = "";

		if(mode.equals("b"))	where = " and a.cmp_dt between replace('"+bs_dt+"','-','') and replace('"+be_dt+"','-','') ";
		if(mode.equals("c"))	where = " and a.cmp_dt between replace('"+cs_dt+"','-','') and replace('"+ce_dt+"','-','') ";

		if(!bus_id.equals(""))	where2 = " and a.bus_id = '"+bus_id+"' ";


		//월렌트 - 누락분
		sub_query2	 = " select b.loan_st, a.*, '월렌트' cmp_st \n"+
					   " from   stat_bus_cost_cmp_base a, users b \n"+
					   " where  a.gubun = '2' and a.cost_st in ('14') and a.bus_id=b.user_id \n"+
						        where + " " + where2 +
					   " ";


		if(avg_cost_cnt>0){
			query =			"  select \n"+
							"         a.*, "+
				            "         DECODE(NVL(a.cmp_ea_amt,0),0,nvl(nvl(a.amt8,0)-nvl(a.amt21,0)+nvl(a.amt30,0),0),a.cmp_ea_amt) cost_amt, "+
							"         to_char(to_number(round(DECODE(NVL(a.cmp_ea_amt,0),0,nvl(nvl(a.amt8,0)-nvl(a.amt21,0)+nvl(a.amt30,0),0),a.cmp_ea_amt)/"+avg_cost_cnt+",2)),decode(sign(1-to_number(round(DECODE(NVL(a.cmp_ea_amt,0),0,nvl(nvl(a.amt8,0)-nvl(a.amt21,0)+nvl(a.amt30,0),0),a.cmp_ea_amt)/"+avg_cost_cnt+",2))),-1,'999.99','999.99')) cost_cnt, "+
							"         d.firm_nm, decode(a.cost_st,'9',e2.car_no,e.car_no) car_no, decode(a.cost_st,'9',e2.car_nm,e.car_nm) car_nm, "+
							"	      decode(a.cost_st,'1', a.cmp_st, "+
							"        	               '7', decode(a.rent_st,'1',decode(c.car_gu,'1','신차','재리스'),'연장')||'정산', "+
							"        	               '8', decode(a.rent_st,'1',decode(c.car_gu,'1','신차','재리스'),'연장')||'승계정산', "+
							"                          '2', '추가이용',   '5', '승계수수료', "+
							"                          '3', decode(s.cls_st,'1','만기정산금발생','중도정산금발생'), "+
							"                          '4', decode(s.cls_st,'1','만기정산금수금','중도정산금수금'), "+
							"                          '9', '출고지연대차', "+
							"                          '10', '재리스수리비추가', "+
							"                          '11', '해지정산경감원계약자', "+
							"                          '12', '해지정산경감부담자', "+
							"                          '13', '월렌트'||decode(a.rent_st,'1','','연장'), "+
							"                          '14', '월렌트' "+
							"         ) cmp_st_nm \n"+
							"  from  \n"+
							"         ( "+sub_query2+" ) a, \n"+
							"		  cont c, client d, taecha t, car_reg e, cls_cont s, car_reg e2 \n"+
							"  where  "+
							"         a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd "+
							"         and c.client_id=d.client_id "+
							"         and a.rent_mng_id=t.rent_mng_id(+) and a.rent_l_cd=t.rent_l_cd(+) and nvl(t.no,'0')='0' "+
							"         and c.car_mng_id=e.car_mng_id(+)"+
							"         and t.car_mng_id=e2.car_mng_id(+)"+
							"         and a.rent_mng_id=s.rent_mng_id(+) and a.rent_l_cd=s.rent_l_cd(+) "+
							"  order by to_number(a.cost_st), a.cmp_dt";
		}else{
			query =			"  select \n"+
							"         a.*, "+
				            "         DECODE(NVL(a.cmp_ea_amt,0),0,nvl(nvl(a.amt8,0)-nvl(a.amt21,0)+nvl(a.amt30,0),0),a.cmp_ea_amt) cost_amt, "+
							"         0 cost_cnt, "+
							"         d.firm_nm, decode(a.cost_st,'9',e2.car_no,e.car_no) car_no, decode(a.cost_st,'9',e2.car_nm,e.car_nm) car_nm, "+
							"	      decode(a.cost_st,'1', a.cmp_st, "+
							"        	               '7', decode(a.rent_st,'1',decode(c.car_gu,'1','신차','재리스'),'연장')||'정산', "+
							"        	               '8', decode(a.rent_st,'1',decode(c.car_gu,'1','신차','재리스'),'연장')||'승계정산', "+
							"                          '2', '추가이용',   '5', '승계수수료', "+
							"                          '3', decode(s.cls_st,'1','만기정산금발생','중도정산금발생'), "+
							"                          '4', decode(s.cls_st,'1','만기정산금수금','중도정산금수금'), "+
							"                          '9', '출고지연대차', "+
							"                          '10', '재리스수리비추가', "+
							"                          '11', '해지정산경감원계약자', "+
							"                          '12', '해지정산경감부담자', "+
							"                          '13', '월렌트', "+
							"                          '14', '월렌트' "+
							"         ) cmp_st_nm \n"+
							"  from  \n"+
							"         ( "+sub_query2+" ) a, \n"+
							"		  cont c, client d, taecha t, car_reg e, cls_cont s, car_reg e2 \n"+
							"  where  "+
							"         a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd "+
							"         and c.client_id=d.client_id "+
							"         and a.rent_mng_id=t.rent_mng_id(+) and a.rent_l_cd=t.rent_l_cd(+) and nvl(t.no,'0')='0' "+
							"         and c.car_mng_id=e.car_mng_id(+)"+
							"         and t.car_mng_id=e2.car_mng_id(+)"+
							"         and a.rent_mng_id=s.rent_mng_id(+) and a.rent_l_cd=s.rent_l_cd(+) "+
							"  order by to_number(a.cost_st), a.cmp_dt";
		}

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
			System.out.println("[CampaignDatabase:getStatBusCmpBaseBusCostListRmCont]\n"+e);
			System.out.println("[CampaignDatabase:getStatBusCmpBaseBusCostListRmCont]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}	
	
	/**
	*	변수수정 - 1군(관리)
	*/
	
	public int updateBusCamYnUser(String user_id, String bus_cmp_yn){


		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = " UPDATE users SET bus_cmp_yn=? WHERE user_id=? ";
			
		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  bus_cmp_yn);
			pstmt.setString(2,  user_id);
			result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		}catch(SQLException e){
			System.out.println("[CampaignDatabase:updateBusCamYnUser]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return result;
		}
	}		
	
	/**
	*	영업캠페인 실제 마감데이타 (마감 포상시 생성) 
	*/
	
	public int insertMagamBus(String save_dt )
	{
			
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = " insert into  STAT_BUS_CMP_v19_MAGAM   select * from STAT_BUS_CMP_v19  where  save_dt = ? " ;                
		
		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, save_dt);
					
			result = pstmt.executeUpdate();
	
			pstmt.close();
			conn.commit();
	
		}catch(SQLException e){
			System.out.println("[CostDatabase:insertMagamBus]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
	            if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return result;
		}
	}
	
	/**
	 * 영업실적 마감 데이타 담당자별 리스트 조회 s_kd, t_wd, st_dt, end_dt, gubun1, gubun2
	 */
	public Vector getSaleBusMngList(String s_kd, String t_wd, String st_dt, String end_dt, String gubun1, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
    	String query = "";
    	String where = "";   	
		String dt1 = "";
		String dt2 = "";
		String what = "";
		
		dt1		= "substr(a.rent_start_dt,1,6)";
		dt2		= "a.rent_start_dt";
		
		if(gubun1.equals("4")){
			dt1		= "substr(a.ce_dt,1,6)";
			dt2		= "a.ce_dt";
		}

		if(gubun2.equals("2"))			where += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%' ";
		else if(gubun2.equals("6"))		where += " and "+dt2+" like to_char(add_months(sysdate,-1),'YYYYMM')||'%' ";
		else if(gubun2.equals("1"))		where += " and "+dt2+" = to_char(sysdate,'YYYYMMDD') ";
		else if(gubun2.equals("4"))		where += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";		
		else if(gubun2.equals("3")){
			if(!st_dt.equals("") && end_dt.equals(""))	where += " and "+dt2+" like replace('"+st_dt+"%', '-','') \n";
			if(!st_dt.equals("") && !end_dt.equals("")) where += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','') \n";
		}

		query =	" select \n"+
				"      a.*,  \n"+
				"      b.firm_nm,  \n"+
                "      decode(a.car_gu,'3',decode(substr(a.bus_st,1,2),'21',h.user_nm,d.user_nm),decode(a.bus_st,'1',d.user_nm)) as bus_nm,  \n"+
				"	   decode(a.car_gu,'3',decode(substr(a.bus_st,1,2),'11',e.user_nm,'21',e.USER_NM,''),decode(a.bus_st,'1',e.user_nm,'2',d.user_nm,'3',e.user_nm)) as bus_agnt_nm,   \n"+
				"	   decode(a.car_gu,'3','',decode(a.bus_st,'1',g.user_nm,'3',d.user_nm,'2',g.user_nm)) as bus_nm2,  \n"+
				"      decode(c.car_st,'4',decode(substr(a.bus_st,2),'1','월렌트','월렌트(연장)'), decode(a.rent_st,'1',decode(c.car_gu,'0','재리스',decode(c.rent_st,'1','신규','3','대차','4','증차')),'연장')) gubun,  \n"+
				"      decode(a.car_gu,'3',decode(a.bus_st,'11','최초계약자','21','영업대리인','관리담당자'),decode(a.bus_st,'1','최초계약자','2','영업대리인','3','영업담당자')) gubun2,  \n"+
				"      nvl(f.ext_agnt,c.bus_id) f_bus_id,  \n"+
				"      decode(a.bus_emp_id,'','','있음') bus_emp_id_yn, decode(a.rent_way,'1','일반식','기본식') rent_way_nm, b2.first_rent_start_dt2 "+
				" from  \n"+
				"      stat_bus_cmp_base  a, \n"+
				"	   client b, cont c, users d, users e, fee f, users g, users h, car_reg i, (select client_id, min(rent_dt) first_rent_start_dt2 from cont group by client_id) b2  \n"+
				" where 1=1 \n"+
				       where+
				"      and a.client_id=b.client_id and a.client_id=b2.client_id "+
				"      and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) "+
				"      and a.bus_id=d.user_id(+) and a.bus_agnt_id=e.user_id(+) \n"+
				"	   and a.rent_mng_id=f.rent_mng_id(+) and a.rent_l_cd=f.rent_l_cd(+) and a.rent_st=f.rent_st(+) "+
				"      and a.bus_id2=g.user_id(+) \n"+
				"      and c.bus_id=h.user_id(+) and c.car_mng_id=i.car_mng_id(+) \n"+
				"  \n";
				
		if(s_kd.equals("1"))	what += "b.firm_nm";	
		if(s_kd.equals("2"))	what += "i.car_nm";	
		if(s_kd.equals("3"))	what += "i.car_no";	
		if(s_kd.equals("4"))	what += "d.user_nm";
		if(s_kd.equals("5"))	what += "e.user_nm";
		if(s_kd.equals("6"))	what += "a.rent_l_cd";
			
		if(!s_kd.equals("") && !t_wd.equals("")){
			if(s_kd.equals("6")) {
				query += " and "+what+" like upper('%"+t_wd+"%')  \n";
			}else {
				query += " and "+what+" like '%"+t_wd+"%'  \n";
			}
		}	
		
		query += " order by decode(a.cls_dt,'',0,1), a.cls_dt, b.firm_nm, a.rent_dt, a.rent_start_dt, a.rent_mng_id";

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
			System.out.println("[CampaignDatabase:getSaleBusMngList]\n"+e);
			System.out.println("[CampaignDatabase:getSaleBusMngList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}
	
	
}


