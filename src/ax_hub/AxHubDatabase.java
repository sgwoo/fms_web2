package ax_hub;


import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;


public class AxHubDatabase 
{

	private Connection conn = null;
	public static AxHubDatabase db;
	
	public static AxHubDatabase getInstance()
	{
		if(AxHubDatabase.db == null)
			AxHubDatabase.db = new AxHubDatabase();
		return AxHubDatabase.db;
	}	
	
 	private DBConnectionManager connMgr = null;


	private void getConnection()
	{
    		try
    		{
	    		if(connMgr == null)
			{
				connMgr = DBConnectionManager.getInstance();
			}

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

	public Hashtable getCarRegCase(String car_mng_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " SELECT a.*, '***'||SUBSTR(a.car_no,LENGTH(a.car_no)-3) car_no2, SUBSTR(a.car_no,LENGTH(a.car_no)-3) car_no3 from car_reg a where a.car_mng_id=? ";

		try 
		{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  car_mng_id);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next())
			{								
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
		    rs.close();
            pstmt.close();	

		} catch (SQLException e) {
			System.out.println("[AxHubDatabase:getCarRegCase]\n"+e);
			System.out.println("[AxHubDatabase:getCarRegCase]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
    }

	public Hashtable getClientCase(String client_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " SELECT * from client where client_id=? ";

		try 
		{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  client_id);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next())
			{								
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
		    rs.close();
            pstmt.close();	

		} catch (SQLException e) {
			System.out.println("[AxHubDatabase:getClientCase]\n"+e);
			System.out.println("[AxHubDatabase:getClientCase]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
    }

	public Hashtable getContViewCase(String car_mng_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " SELECT * from cont_n_view where car_mng_id=? and nvl(use_yn,'Y')='Y' ";

		try 
		{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  car_mng_id);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next())
			{								
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
		    rs.close();
            pstmt.close();	

		} catch (SQLException e) {
			System.out.println("[AxHubDatabase:getContViewCase]\n"+e);
			System.out.println("[AxHubDatabase:getContViewCase]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
    }

	public Hashtable getContViewCase(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " SELECT * from cont_n_view where rent_mng_id=? and rent_l_cd=? ";

		try 
		{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  rent_mng_id);
			pstmt.setString(2,  rent_l_cd);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next())
			{								
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
		    rs.close();
            pstmt.close();	

		} catch (SQLException e) {
			System.out.println("[AxHubDatabase:getContViewCase]\n"+e);
			System.out.println("[AxHubDatabase:getContViewCase]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
    }

	public Hashtable getRentContCase(String rent_s_cd, String car_mng_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " SELECT * from rent_cont where rent_s_cd=? and car_mng_id=? ";

		try 
		{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  rent_s_cd);
			pstmt.setString(2,  car_mng_id);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next())
			{								
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
		    rs.close();
            pstmt.close();	

		} catch (SQLException e) {
			System.out.println("[AxHubDatabase:getRentContCase]\n"+e);
			System.out.println("[AxHubDatabase:getRentContCase]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
    }

	public Hashtable getVTotDistCase(String car_mng_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " SELECT * from V_TOT_DIST where car_mng_id=? ";

		try 
		{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  car_mng_id);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next())
			{								
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
		    rs.close();
            pstmt.close();	

		} catch (SQLException e) {
			System.out.println("[AxHubDatabase:getVTotDistCase]\n"+e);
			System.out.println("[AxHubDatabase:getVTotDistCase]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
    }

	public Hashtable getUserCase(String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " SELECT * from users where user_id=? ";

		try 
		{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  user_id);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next())
			{								
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
		    rs.close();
            pstmt.close();	

		} catch (SQLException e) {
			System.out.println("[AxHubDatabase:getUserCase]\n"+e);
			System.out.println("[AxHubDatabase:getUserCase]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
    }

	public Hashtable getArsCard(String ars_code)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " SELECT * from ars_card where ars_code=? ";

		try 
		{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  ars_code);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next())
			{								
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
		    rs.close();
            pstmt.close();	

		} catch (SQLException e) {
			System.out.println("[AxHubDatabase:getArsCard]\n"+e);
			System.out.println("[AxHubDatabase:getArsCard]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
    }

	//결제시스템 등록
	public boolean insertAxHub(AxHubBean ax_bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;

		String query =  " insert into ax_hub "+
						" ( req_tx, ordr_idxx, pay_method, good_name, good_mny, buyr_name, buyr_tel1, buyr_tel2, buyr_mail, "+
						"   tax_flag, comm_tax_mny, comm_fee_mny, comm_vat_mny, good_cd, good_expr, "+
                        "   tno, amount, card_cd, card_name, app_time, app_no, noinf, quota, "+   
                        "   am_ax_code, am_good_st, am_good_id1, am_good_Id2, am_good_s_amt, am_good_v_amt, am_good_m_amt, am_good_amt, reg_id, reg_dt ) values "+
						" ( ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
						"   ?, ?, ?, ?, ?, ?, "+
						"   ?, ?, ?, ?, ?, ?, ?, ?, "+
						"   ?, ?, ?, ?, ?, ?, ?, ?, ?, sysdate ) ";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1,  ax_bean.getReq_tx			());
			pstmt.setString(2,  ax_bean.getOrdr_idxx		());
			pstmt.setString(3,  ax_bean.getPay_method		());
			pstmt.setString(4,  ax_bean.getGood_name		());
			pstmt.setInt   (5,  ax_bean.getGood_mny			());
			pstmt.setString(6,  ax_bean.getBuyr_name		());
			pstmt.setString(7,  ax_bean.getBuyr_tel1		());
			pstmt.setString(8,  ax_bean.getBuyr_tel2		());
			pstmt.setString(9,  ax_bean.getBuyr_mail		());
			pstmt.setString(10, ax_bean.getTax_flag			());
			pstmt.setInt   (11, ax_bean.getComm_tax_mny		());
			pstmt.setInt   (12, ax_bean.getComm_fee_mny		());
			pstmt.setInt   (13, ax_bean.getComm_vat_mny		());
			pstmt.setString(14, ax_bean.getGood_cd			());
			pstmt.setString(15, ax_bean.getGood_expr		());
			pstmt.setString(16, ax_bean.getTno				());
			pstmt.setInt   (17, ax_bean.getAmount			());
			pstmt.setString(18, ax_bean.getCard_cd			());
			pstmt.setString(19, ax_bean.getCard_name		());
			pstmt.setString(20, ax_bean.getApp_time			());
			pstmt.setString(21, ax_bean.getApp_no			());
			pstmt.setString(22, ax_bean.getNoinf			());
			pstmt.setString(23, ax_bean.getQuota			());
			pstmt.setString(24, ax_bean.getAm_ax_code		());
			pstmt.setString(25, ax_bean.getAm_good_st		());
			pstmt.setString(26, ax_bean.getAm_good_id1		());
			pstmt.setString(27, ax_bean.getAm_good_id2		());
			pstmt.setInt   (28, ax_bean.getAm_good_s_amt	());
			pstmt.setInt   (29, ax_bean.getAm_good_v_amt	());
			pstmt.setInt   (30, ax_bean.getAm_good_m_amt	());
			pstmt.setInt   (31, ax_bean.getAm_good_amt  	());
			pstmt.setString(32, ax_bean.getReg_id    		());

			pstmt.executeUpdate();
			pstmt.close();
					    
			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AxHubDatabase:insertAxHub]\n"+e);
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
	

	//결제시스템 등록
	public boolean updateAxHub(AxHubBean ax_bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;

		String query =  " update ax_hub set "+
						"        req_tx=?, ordr_idxx=?, pay_method=?, good_name=?, good_mny=?, buyr_name=?, buyr_tel1=?, buyr_tel2=?, buyr_mail=?, "+
						"        tax_flag=?, comm_tax_mny=?, comm_fee_mny=?, comm_vat_mny=?, good_cd=?, good_expr=?, "+
                        "        tno=?, amount=?, card_cd=?, card_name=?, app_time=?, app_no=?, noinf=?, quota=?, "+   
						"        am_card_kind=?, am_card_sign=?, am_card_rel=? "+
                        " where am_ax_code=? ";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1,  ax_bean.getReq_tx			());
			pstmt.setString(2,  ax_bean.getOrdr_idxx		());
			pstmt.setString(3,  ax_bean.getPay_method		());
			pstmt.setString(4,  ax_bean.getGood_name		());
			pstmt.setInt   (5,  ax_bean.getGood_mny			());
			pstmt.setString(6,  ax_bean.getBuyr_name		());
			pstmt.setString(7,  ax_bean.getBuyr_tel1		());
			pstmt.setString(8,  ax_bean.getBuyr_tel2		());
			pstmt.setString(9,  ax_bean.getBuyr_mail		());
			pstmt.setString(10, ax_bean.getTax_flag			());
			pstmt.setInt   (11, ax_bean.getComm_tax_mny		());
			pstmt.setInt   (12, ax_bean.getComm_fee_mny		());
			pstmt.setInt   (13, ax_bean.getComm_vat_mny		());
			pstmt.setString(14, ax_bean.getGood_cd			());
			pstmt.setString(15, ax_bean.getGood_expr		());
			pstmt.setString(16, ax_bean.getTno				());
			pstmt.setInt   (17, ax_bean.getAmount			());
			pstmt.setString(18, ax_bean.getCard_cd			());
			pstmt.setString(19, ax_bean.getCard_name		());
			pstmt.setString(20, ax_bean.getApp_time			());
			pstmt.setString(21, ax_bean.getApp_no			());
			pstmt.setString(22, ax_bean.getNoinf			());
			pstmt.setString(23, ax_bean.getQuota			());
			pstmt.setString(24, ax_bean.getAm_card_kind		());
			pstmt.setString(25, ax_bean.getAm_card_sign		());
			pstmt.setString(26, ax_bean.getAm_card_rel		());
			pstmt.setString(27, ax_bean.getAm_ax_code		());

			pstmt.executeUpdate();
			pstmt.close();
					    
			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AxHubDatabase:updateAxHub]\n"+e);
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

	
	public String getSearchVarCode(String var1, String var2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String code = "";
		String query = "";
		
		query = " select am_ax_code from ax_hub where replace(am_m_tel,'-','')=replace(?,'-','') and am_ax_code=? ";
				
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, var1);
			pstmt.setString(2, var2);
	    	rs = pstmt.executeQuery();		
			if(rs.next())
			{			
				 code = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
            pstmt.close();	
		} catch (SQLException e) {
			System.out.println("[AxHubDatabase:getSearchVarCode(String var1, String var2)]\n"+e);
			System.out.println("[AxHubDatabase:getSearchVarCode(String var1, String var2)]\n"+query);
			code = "error";
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return code;
		}		
	}	
	
	public AxHubBean getAxHubCase(String am_ax_code)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		AxHubBean bean = new AxHubBean();
		String query = "";

		query = " select * from ax_hub where am_ax_code=? ";

				
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, am_ax_code);
	    	rs = pstmt.executeQuery();		
			if(rs.next())
			{			
				 bean.setAm_ax_code		(rs.getString(1)==null?"":rs.getString(1));
				 bean.setAm_good_st		(rs.getString(2)==null?"":rs.getString(2));
				 bean.setAm_good_id1	(rs.getString(3)==null?"":rs.getString(3));
				 bean.setAm_good_id2	(rs.getString(4)==null?"":rs.getString(4));
				 bean.setAm_good_s_amt	(rs.getInt(5));
				 bean.setAm_good_v_amt	(rs.getInt(6));
				 bean.setAm_good_m_amt	(rs.getInt(7));
				 bean.setAm_good_amt	(rs.getInt(8));
				 bean.setReg_id			(rs.getString(9)==null?"":rs.getString(9));
				 bean.setReg_dt			(rs.getString(10)==null?"":rs.getString(10));
				 bean.setReq_tx			(rs.getString(11)==null?"":rs.getString(11));
				 bean.setOrdr_idxx		(rs.getString(12)==null?"":rs.getString(12));
				 bean.setPay_method		(rs.getString(13)==null?"":rs.getString(13));
				 bean.setGood_name		(rs.getString(14)==null?"":rs.getString(14));
				 bean.setGood_mny		(rs.getInt(15));
				 bean.setBuyr_name		(rs.getString(16)==null?"":rs.getString(16));
				 bean.setBuyr_tel1		(rs.getString(17)==null?"":rs.getString(17));
				 bean.setBuyr_tel2		(rs.getString(18)==null?"":rs.getString(18));
				 bean.setBuyr_mail		(rs.getString(19)==null?"":rs.getString(19));
				 bean.setTax_flag		(rs.getString(20)==null?"":rs.getString(20));
				 bean.setComm_tax_mny	(rs.getInt(21));
				 bean.setComm_fee_mny	(rs.getInt(22));
				 bean.setComm_vat_mny	(rs.getInt(23));
				 bean.setGood_cd		(rs.getString(24)==null?"":rs.getString(24));
				 bean.setGood_expr		(rs.getString(25)==null?"":rs.getString(25));
				 bean.setTno			(rs.getString(26)==null?"":rs.getString(26));
				 bean.setAmount			(rs.getInt(27));
				 bean.setCard_cd		(rs.getString(28)==null?"":rs.getString(28));
				 bean.setCard_name		(rs.getString(29)==null?"":rs.getString(29));
				 bean.setApp_time		(rs.getString(30)==null?"":rs.getString(30));
				 bean.setApp_no			(rs.getString(31)==null?"":rs.getString(31));
				 bean.setNoinf			(rs.getString(33)==null?"":rs.getString(33));
				 bean.setQuota			(rs.getString(34)==null?"":rs.getString(34));
				 bean.setAm_card_kind	(rs.getString(35)==null?"":rs.getString(35));
				 bean.setAm_card_sign	(rs.getString(36)==null?"":rs.getString(36));
				 bean.setAm_card_rel	(rs.getString(37)==null?"":rs.getString(37));
				 bean.setAm_m_tel		(rs.getString(38)==null?"":rs.getString(38));

			}
			rs.close();
            pstmt.close();	
		} catch (SQLException e) {
			System.out.println("[AxHubDatabase:getAxHubCase]\n"+e);
			System.out.println("[AxHubDatabase:getAxHubCase]\n"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}		
	}	

	public AxHubBean getAxHubCase(String am_m_tel, String am_ax_code)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		AxHubBean bean = new AxHubBean();
		String query = "";

		query = " select * from ax_hub where replace(am_m_tel,'-','')=replace(?,'-','') and am_ax_code=? ";

				
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, am_m_tel);
			pstmt.setString(2, am_ax_code);
	    	rs = pstmt.executeQuery();		
			if(rs.next())
			{			
				 bean.setAm_ax_code		(rs.getString(1)==null?"":rs.getString(1));
				 bean.setAm_good_st		(rs.getString(2)==null?"":rs.getString(2));
				 bean.setAm_good_id1	(rs.getString(3)==null?"":rs.getString(3));
				 bean.setAm_good_id2	(rs.getString(4)==null?"":rs.getString(4));
				 bean.setAm_good_s_amt	(rs.getInt(5));
				 bean.setAm_good_v_amt	(rs.getInt(6));
				 bean.setAm_good_m_amt	(rs.getInt(7));
				 bean.setAm_good_amt	(rs.getInt(8));
				 bean.setReg_id			(rs.getString(9)==null?"":rs.getString(9));
				 bean.setReg_dt			(rs.getString(10)==null?"":rs.getString(10));
				 bean.setReq_tx			(rs.getString(11)==null?"":rs.getString(11));
				 bean.setOrdr_idxx		(rs.getString(12)==null?"":rs.getString(12));
				 bean.setPay_method		(rs.getString(13)==null?"":rs.getString(13));
				 bean.setGood_name		(rs.getString(14)==null?"":rs.getString(14));
				 bean.setGood_mny		(rs.getInt(15));
				 bean.setBuyr_name		(rs.getString(16)==null?"":rs.getString(16));
				 bean.setBuyr_tel1		(rs.getString(17)==null?"":rs.getString(17));
				 bean.setBuyr_tel2		(rs.getString(18)==null?"":rs.getString(18));
				 bean.setBuyr_mail		(rs.getString(19)==null?"":rs.getString(19));
				 bean.setTax_flag		(rs.getString(20)==null?"":rs.getString(20));
				 bean.setComm_tax_mny	(rs.getInt(21));
				 bean.setComm_fee_mny	(rs.getInt(22));
				 bean.setComm_vat_mny	(rs.getInt(23));
				 bean.setGood_cd		(rs.getString(24)==null?"":rs.getString(24));
				 bean.setGood_expr		(rs.getString(25)==null?"":rs.getString(25));
				 bean.setTno			(rs.getString(26)==null?"":rs.getString(26));
				 bean.setAmount			(rs.getInt(27));
				 bean.setCard_cd		(rs.getString(28)==null?"":rs.getString(28));
				 bean.setCard_name		(rs.getString(29)==null?"":rs.getString(29));
				 bean.setApp_time		(rs.getString(30)==null?"":rs.getString(30));
				 bean.setApp_no			(rs.getString(31)==null?"":rs.getString(31));
				 bean.setNoinf			(rs.getString(33)==null?"":rs.getString(33));
				 bean.setQuota			(rs.getString(34)==null?"":rs.getString(34));
				 bean.setAm_card_kind	(rs.getString(35)==null?"":rs.getString(35));
				 bean.setAm_card_sign	(rs.getString(36)==null?"":rs.getString(36));
				 bean.setAm_card_rel	(rs.getString(37)==null?"":rs.getString(37));
				 bean.setAm_m_tel		(rs.getString(38)==null?"":rs.getString(38));

			}
			rs.close();
            pstmt.close();	
		} catch (SQLException e) {
			System.out.println("[AxHubDatabase:getAxHubCase]\n"+e);
			System.out.println("[AxHubDatabase:getAxHubCase]\n"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}		
	}	

	//결제시스템 등록
	public boolean sendMemo(String send_id, String rece_id, String title, String content)
	{
		getConnection();
		PreparedStatement pstmt = null;
		Statement stmt = null;
		ResultSet rs = null;
		boolean flag = true;
		String memo_id = "";

		String query_seq= " SELECT ltrim(NVL(TO_CHAR(MAX(TO_NUMBER(memo_id))+1, '000000'), '000001')) memo_id FROM memo ";

		String query = " INSERT INTO memo(memo_id, send_id, rece_id, title, content, memo_dt) VALUES "+
					   "                 (?, ?, ?, ?, ?, TO_CHAR(SYSDATE,'YYYYMMDD'))";

		try 
		{
			conn.setAutoCommit(false);

			stmt = conn.createStatement();
			rs = stmt.executeQuery(query_seq);
			if(rs.next())
			{
				memo_id = rs.getString("MEMO_ID")==null?"000001":rs.getString("MEMO_ID");
			}
			stmt.close();

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  memo_id);
			pstmt.setString(2,  send_id);
			pstmt.setString(3,  rece_id);
			pstmt.setString(4,  title);
			pstmt.setString(5,  content);
			pstmt.executeUpdate();
			pstmt.close();
					    
			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AxHubDatabase:insertAxHub]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				if(pstmt != null)	pstmt.close();
				if(stmt != null)	stmt.close();
				if(rs != null )		rs.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

}