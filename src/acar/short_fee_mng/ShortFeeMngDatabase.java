package acar.short_fee_mng;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;


public class ShortFeeMngDatabase
{
	private Connection conn = null;
	public static ShortFeeMngDatabase db;
	
	public static ShortFeeMngDatabase getInstance()
	{
		if(ShortFeeMngDatabase.db == null)
			ShortFeeMngDatabase.db = new ShortFeeMngDatabase();
		return ShortFeeMngDatabase.db;
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
	 *	단기대여요금 리스트
	 */
	public Vector getShortFeeMngList()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select DISTINCT a.kind, b.code, b.nm_cd, b.nm, a.section, a.use_yn, a.stand_car"+//, decode(a.fee_st,'1','대여요금총액','2','1개월대여요금') fee_st
				" from short_fee_mng a, code b"+
				" where a.kind=b.code and b.c_st='0007' and b.code<>'0000'"+
				" order by a.kind, a.section";
		
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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim()/**/);
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ShortFeeMngDatabase:getResSearchList]"+e);
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
	 *	단기대여요금 차량구분별 차량 리스트
	 */
	public String getSectionCarList(String section)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String car_list = "";
		String query = "";

		query = " select car_nm from car_mng where section='"+section+"'";
		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			while(rs.next())
			{				
				if(!car_list.equals("")) car_list = car_list+",";
				car_list = car_list + rs.getString(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ShortFeeMngDatabase:getSectionCarList]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return car_list;
		}
	}	

	/**
	 *	단기대여요금 차량구분별 요금 정보
	 */
	public ShortFeeMngBean getShortFeeMngCase(String section, String fee_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ShortFeeMngBean bean = new ShortFeeMngBean();
		String query = "";

		query = " select a.*, b.code, b.nm_cd, b.nm"+
				" from   short_fee_mng a, code b, (select kind, section, fee_st, max(reg_dt) reg_dt from short_fee_mng group by kind, section, fee_st ) c"+
				" where  a.kind=b.code and b.c_st='0007' and b.code<>'0000' and a.section='"+section+"' and a.fee_st='"+fee_st+"'"+
				" AND    a.kind=c.kind AND a.section=C.SECTION AND a.fee_st=c.fee_st AND a.reg_dt=c.reg_dt "+
				" ";
		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{				
				bean.setKind(rs.getString("kind"));
				bean.setSection(rs.getString("section"));
				bean.setFee_st(rs.getString("fee_st"));
				bean.setAmt_12h(rs.getInt("amt_12h"));
				bean.setAmt_01d(rs.getInt("amt_01d"));
				bean.setAmt_02d(rs.getInt("amt_02d"));
				bean.setAmt_03d(rs.getInt("amt_03d"));
				bean.setAmt_04d(rs.getInt("amt_04d"));
				bean.setAmt_05d(rs.getInt("amt_05d"));
				bean.setAmt_06d(rs.getInt("amt_06d"));
				bean.setAmt_07d(rs.getInt("amt_07d"));
				bean.setAmt_08d(rs.getInt("amt_08d"));
				bean.setAmt_09d(rs.getInt("amt_09d"));
				bean.setAmt_10d(rs.getInt("amt_10d"));
				bean.setAmt_11d(rs.getInt("amt_11d"));
				bean.setAmt_12d(rs.getInt("amt_12d"));
				bean.setAmt_13d(rs.getInt("amt_13d"));
				bean.setAmt_14d(rs.getInt("amt_14d"));
				bean.setAmt_15d(rs.getInt("amt_15d"));
				bean.setAmt_16d(rs.getInt("amt_16d"));
				bean.setAmt_17d(rs.getInt("amt_17d"));
				bean.setAmt_18d(rs.getInt("amt_18d"));
				bean.setAmt_19d(rs.getInt("amt_19d"));
				bean.setAmt_20d(rs.getInt("amt_20d"));
				bean.setAmt_21d(rs.getInt("amt_21d"));
				bean.setAmt_22d(rs.getInt("amt_22d"));
				bean.setAmt_23d(rs.getInt("amt_23d"));
				bean.setAmt_24d(rs.getInt("amt_24d"));
				bean.setAmt_25d(rs.getInt("amt_25d"));
				bean.setAmt_26d(rs.getInt("amt_26d"));
				bean.setAmt_27d(rs.getInt("amt_27d"));
				bean.setAmt_28d(rs.getInt("amt_28d"));
				bean.setAmt_29d(rs.getInt("amt_29d"));
				bean.setAmt_30d(rs.getInt("amt_30d"));
				bean.setAmt_01m(rs.getInt("amt_01m"));
				bean.setAmt_02m(rs.getInt("amt_02m"));
				bean.setAmt_03m(rs.getInt("amt_03m"));
				bean.setAmt_04m(rs.getInt("amt_04m"));
				bean.setAmt_05m(rs.getInt("amt_05m"));
				bean.setAmt_06m(rs.getInt("amt_06m"));
				bean.setAmt_07m(rs.getInt("amt_07m"));
				bean.setAmt_08m(rs.getInt("amt_08m"));
				bean.setAmt_09m(rs.getInt("amt_09m"));
				bean.setAmt_10m(rs.getInt("amt_10m"));
				bean.setAmt_11m(rs.getInt("amt_11m"));
				bean.setStand_car(rs.getString("stand_car")==null?"":rs.getString("stand_car"));
				bean.setNm(rs.getString("nm")==null?"":rs.getString("nm"));
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ShortFeeMngDatabase:getShortFeeMngCase]"+e);
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

	/**
	 *	단기대여요금 차량구분별 요금 정보
	 */
	public ShortFeeMngBean getShortFeeMngCase(String section, String fee_st, String req_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ShortFeeMngBean bean = new ShortFeeMngBean();
		String query = "";

		query = " select a.*, b.code, b.nm_cd, b.nm"+
				" from   short_fee_mng a, code b, "+
				"        (select kind, section, fee_st, max(reg_dt) reg_dt from short_fee_mng where reg_dt <= replace(nvl('"+req_dt+"',to_char(sysdate,'YYYYMMDD')),'-','') group by kind, section, fee_st ) c"+
				" where  a.kind=b.code and b.c_st='0007' and b.code<>'0000' and a.section='"+section+"' and a.fee_st='"+fee_st+"'"+
				" AND    a.kind=c.kind AND a.section=C.SECTION AND a.fee_st=c.fee_st AND a.reg_dt=c.reg_dt "+
				" ";
		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{				
				bean.setKind(rs.getString("kind"));
				bean.setSection(rs.getString("section"));
				bean.setFee_st(rs.getString("fee_st"));
				bean.setAmt_12h(rs.getInt("amt_12h"));
				bean.setAmt_01d(rs.getInt("amt_01d"));
				bean.setAmt_02d(rs.getInt("amt_02d"));
				bean.setAmt_03d(rs.getInt("amt_03d"));
				bean.setAmt_04d(rs.getInt("amt_04d"));
				bean.setAmt_05d(rs.getInt("amt_05d"));
				bean.setAmt_06d(rs.getInt("amt_06d"));
				bean.setAmt_07d(rs.getInt("amt_07d"));
				bean.setAmt_08d(rs.getInt("amt_08d"));
				bean.setAmt_09d(rs.getInt("amt_09d"));
				bean.setAmt_10d(rs.getInt("amt_10d"));
				bean.setAmt_11d(rs.getInt("amt_11d"));
				bean.setAmt_12d(rs.getInt("amt_12d"));
				bean.setAmt_13d(rs.getInt("amt_13d"));
				bean.setAmt_14d(rs.getInt("amt_14d"));
				bean.setAmt_15d(rs.getInt("amt_15d"));
				bean.setAmt_16d(rs.getInt("amt_16d"));
				bean.setAmt_17d(rs.getInt("amt_17d"));
				bean.setAmt_18d(rs.getInt("amt_18d"));
				bean.setAmt_19d(rs.getInt("amt_19d"));
				bean.setAmt_20d(rs.getInt("amt_20d"));
				bean.setAmt_21d(rs.getInt("amt_21d"));
				bean.setAmt_22d(rs.getInt("amt_22d"));
				bean.setAmt_23d(rs.getInt("amt_23d"));
				bean.setAmt_24d(rs.getInt("amt_24d"));
				bean.setAmt_25d(rs.getInt("amt_25d"));
				bean.setAmt_26d(rs.getInt("amt_26d"));
				bean.setAmt_27d(rs.getInt("amt_27d"));
				bean.setAmt_28d(rs.getInt("amt_28d"));
				bean.setAmt_29d(rs.getInt("amt_29d"));
				bean.setAmt_30d(rs.getInt("amt_30d"));
				bean.setAmt_01m(rs.getInt("amt_01m"));
				bean.setAmt_02m(rs.getInt("amt_02m"));
				bean.setAmt_03m(rs.getInt("amt_03m"));
				bean.setAmt_04m(rs.getInt("amt_04m"));
				bean.setAmt_05m(rs.getInt("amt_05m"));
				bean.setAmt_06m(rs.getInt("amt_06m"));
				bean.setAmt_07m(rs.getInt("amt_07m"));
				bean.setAmt_08m(rs.getInt("amt_08m"));
				bean.setAmt_09m(rs.getInt("amt_09m"));
				bean.setAmt_10m(rs.getInt("amt_10m"));
				bean.setAmt_11m(rs.getInt("amt_11m"));
				bean.setStand_car(rs.getString("stand_car")==null?"":rs.getString("stand_car"));
				bean.setNm(rs.getString("nm")==null?"":rs.getString("nm"));
				bean.setReg_dt(rs.getString("reg_dt")==null?"":rs.getString("reg_dt"));
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ShortFeeMngDatabase:getShortFeeMngCase]"+e);
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

	/**
	 *	단기대여요금 update
	 */
	public boolean updateShortFeeMng(ShortFeeMngBean bean)
	{
		getConnection();
		boolean flag = true;
		String query = " update short_fee_mng set "+
						" amt_12h=?, amt_01d=?, amt_02d=?, amt_03d=?, amt_04d=?, amt_05d=?, amt_06d=?, amt_07d=?, amt_08d=?, amt_09d=?, amt_10d=?,"+//11
						" amt_11d=?, amt_12d=?, amt_13d=?, amt_14d=?, amt_15d=?, amt_16d=?, amt_17d=?, amt_18d=?, amt_19d=?, amt_20d=?,"+//10
						" amt_21d=?, amt_22d=?, amt_23d=?, amt_24d=?, amt_25d=?, amt_26d=?, amt_27d=?, amt_28d=?, amt_29d=?, amt_30d=?,"+//10
						" amt_01m=?, amt_02m=?, amt_03m=?, amt_04m=?, amt_05m=?, amt_06m=?, amt_07m=?, amt_08m=?, amt_09m=?, amt_10m=?, amt_11m=?,"+//11
						" stand_car=?, update_id=?, update_dt=to_char(sysdate,'YYYYMMDD')"+
						" where kind = ? and section = ? and fee_st=? and reg_dt=?";
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);

			pstmt.setInt(1, bean.getAmt_12h());
			pstmt.setInt(2, bean.getAmt_01d());
			pstmt.setInt(3, bean.getAmt_02d());
			pstmt.setInt(4, bean.getAmt_03d());
			pstmt.setInt(5, bean.getAmt_04d());
			pstmt.setInt(6, bean.getAmt_05d());
			pstmt.setInt(7, bean.getAmt_06d());
			pstmt.setInt(8, bean.getAmt_07d());
			pstmt.setInt(9, bean.getAmt_08d());
			pstmt.setInt(10, bean.getAmt_09d());
			pstmt.setInt(11, bean.getAmt_10d());
			pstmt.setInt(12, bean.getAmt_11d());
			pstmt.setInt(13, bean.getAmt_12d());
			pstmt.setInt(14, bean.getAmt_13d());
			pstmt.setInt(15, bean.getAmt_14d());
			pstmt.setInt(16, bean.getAmt_15d());
			pstmt.setInt(17, bean.getAmt_16d());
			pstmt.setInt(18, bean.getAmt_17d());
			pstmt.setInt(19, bean.getAmt_18d());
			pstmt.setInt(20, bean.getAmt_19d());
			pstmt.setInt(21, bean.getAmt_20d());
			pstmt.setInt(22, bean.getAmt_21d());
			pstmt.setInt(23, bean.getAmt_22d());
			pstmt.setInt(24, bean.getAmt_23d());
			pstmt.setInt(25, bean.getAmt_24d());
			pstmt.setInt(26, bean.getAmt_25d());
			pstmt.setInt(27, bean.getAmt_26d());
			pstmt.setInt(28, bean.getAmt_27d());
			pstmt.setInt(29, bean.getAmt_28d());
			pstmt.setInt(30, bean.getAmt_29d());
			pstmt.setInt(31, bean.getAmt_30d());
			pstmt.setInt(32, bean.getAmt_01m());
			pstmt.setInt(33, bean.getAmt_02m());
			pstmt.setInt(34, bean.getAmt_03m());
			pstmt.setInt(35, bean.getAmt_04m());
			pstmt.setInt(36, bean.getAmt_05m());
			pstmt.setInt(37, bean.getAmt_06m());
			pstmt.setInt(38, bean.getAmt_07m());
			pstmt.setInt(39, bean.getAmt_08m());
			pstmt.setInt(40, bean.getAmt_09m());
			pstmt.setInt(41, bean.getAmt_10m());
			pstmt.setInt(42, bean.getAmt_11m());
			pstmt.setString(43, bean.getStand_car());
			pstmt.setString(44, bean.getUpdate_id());
			pstmt.setString(45, bean.getKind());
			pstmt.setString(46, bean.getSection());
			pstmt.setString(47, bean.getFee_st());
			pstmt.setString(48, bean.getReg_dt());
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[ShortFeeMngDatabase:updateShortFeeMng]\n"+e);			
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
	 *	단기대여요금 update
	 */
	public boolean insertShortFeeMng(ShortFeeMngBean bean)
	{
		getConnection();
		boolean flag = true;
		String query =  " INSERT INTO SHORT_FEE_MNG "+
						" ( KIND, SECTION, FEE_ST,"+
						"   AMT_12H,AMT_01D,AMT_02D,AMT_03D,AMT_04D,AMT_05D,AMT_06D,AMT_07D,AMT_08D,AMT_09D,AMT_10D,"+
						"   AMT_11D,AMT_12D,AMT_13D,AMT_14D,AMT_15D,AMT_16D,AMT_17D,AMT_18D,AMT_19D,AMT_20D,"+
						"   AMT_21D,AMT_22D,AMT_23D,AMT_24D,AMT_25D,AMT_26D,AMT_27D,AMT_28D,AMT_29D,AMT_30D,"+
						"   AMT_01M,AMT_02M,AMT_03M,AMT_04M,AMT_05M,AMT_06M,AMT_07M,AMT_08M,AMT_09M,AMT_10M,"+
						"   AMT_11M,"+
						"   USE_YN,REG_ID,REG_DT,UPDATE_ID,UPDATE_DT,STAND_CAR "+
						" ) "+
						" VALUES "+
						" ( "+
						"   ?, ?, ?, "+
						"   ?, ?, ?, ?, ?,  ?, ?, ?, ?, ?,  ?, "+
						"   ?, ?, ?, ?, ?,  ?, ?, ?, ?, ?, "+
						"   ?, ?, ?, ?, ?,  ?, ?, ?, ?, ?, "+
						"   ?, ?, ?, ?, ?,  ?, ?, ?, ?, ?, "+
						"   ?, "+
						"   'Y', ?, to_char(sysdate,'YYYYMMDD'), '', '', ?  "+
						" ) ";
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);

			pstmt.setString	(1,  bean.getKind		());
			pstmt.setString	(2,  bean.getSection	());
			pstmt.setString	(3,  bean.getFee_st		());
			pstmt.setInt	(4,  bean.getAmt_12h	());
			pstmt.setInt	(5,  bean.getAmt_01d	());
			pstmt.setInt	(6,  bean.getAmt_02d	());
			pstmt.setInt	(7,  bean.getAmt_03d	());
			pstmt.setInt	(8,  bean.getAmt_04d	());
			pstmt.setInt	(9,  bean.getAmt_05d	());
			pstmt.setInt	(10, bean.getAmt_06d	());
			pstmt.setInt	(11, bean.getAmt_07d	());
			pstmt.setInt	(12, bean.getAmt_08d	());
			pstmt.setInt	(13, bean.getAmt_09d	());
			pstmt.setInt	(14, bean.getAmt_10d	());
			pstmt.setInt	(15, bean.getAmt_11d	());
			pstmt.setInt	(16, bean.getAmt_12d	());
			pstmt.setInt	(17, bean.getAmt_13d	());
			pstmt.setInt	(18, bean.getAmt_14d	());
			pstmt.setInt	(19, bean.getAmt_15d	());
			pstmt.setInt	(20, bean.getAmt_16d	());
			pstmt.setInt	(21, bean.getAmt_17d	());
			pstmt.setInt	(22, bean.getAmt_18d	());
			pstmt.setInt	(23, bean.getAmt_19d	());
			pstmt.setInt	(24, bean.getAmt_20d	());
			pstmt.setInt	(25, bean.getAmt_21d	());
			pstmt.setInt	(26, bean.getAmt_22d	());
			pstmt.setInt	(27, bean.getAmt_23d	());
			pstmt.setInt	(28, bean.getAmt_24d	());
			pstmt.setInt	(29, bean.getAmt_25d	());
			pstmt.setInt	(30, bean.getAmt_26d	());
			pstmt.setInt	(31, bean.getAmt_27d	());
			pstmt.setInt	(32, bean.getAmt_28d	());
			pstmt.setInt	(33, bean.getAmt_29d	());
			pstmt.setInt	(34, bean.getAmt_30d	());
			pstmt.setInt	(35, bean.getAmt_01m	());
			pstmt.setInt	(36, bean.getAmt_02m	());
			pstmt.setInt	(37, bean.getAmt_03m	());
			pstmt.setInt	(38, bean.getAmt_04m	());
			pstmt.setInt	(39, bean.getAmt_05m	());
			pstmt.setInt	(40, bean.getAmt_06m	());
			pstmt.setInt	(41, bean.getAmt_07m	());
			pstmt.setInt	(42, bean.getAmt_08m	());
			pstmt.setInt	(43, bean.getAmt_09m	());
			pstmt.setInt	(44, bean.getAmt_10m	());
			pstmt.setInt	(45, bean.getAmt_11m	());
			pstmt.setString	(46, bean.getUpdate_id	());
			pstmt.setString	(47, bean.getStand_car	());
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[ShortFeeMngDatabase:insertShortFeeMng]\n"+e);			
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


	//차종 연결--------------------------------------------------------------------------------------------------------

	/**
	 *	차량구분 코드 리스트
	 */
	public Vector getSectionList()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.section, b.nm from short_fee_mng a, code b"+
				" where a.kind=b.code and a.fee_st='1' and b.c_st='0007' and b.code<>'0000' order by a.kind, a.section";
		
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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim()/**/);
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ShortFeeMngDatabase:getResSearchList]"+e);
			System.out.println("[ShortFeeMngDatabase:query]"+e);
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


  //예약시스템------------------------------------------------------------------------------------------
	/**
	 *	단기대여요금 차량, 기간별 대여료 조회
	 */
	public int getShortFeeAmt(String section, String gubun, String fee_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int fee_amt = 0;
		String query = "";

		query = " select "+gubun+" from short_fee_mng where section='"+section+"' and fee_st='"+fee_st+"'";
		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{				
				fee_amt = rs.getInt(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ShortFeeMngDatabase:getShortFeeAmt]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return fee_amt;
		}
	}

	/**
	 *	단기대여요금 차량, 기간별 대여료 조회
	 */
	public int getShortFeeAmt(String section, String gubun, String fee_st, String reg_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int fee_amt = 0;
		String query = "";

		query = " select "+gubun+" from short_fee_mng where section='"+section+"' and fee_st='"+fee_st+"'";

		if(reg_dt.equals("")){
			query += " and reg_dt in (select max(reg_dt) reg_dt from short_fee_mng where section='"+section+"' and fee_st='"+fee_st+"')";
		}else{
			query += " and reg_dt=replace('"+reg_dt+"','-','') ";		
		}
		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{				
				fee_amt = rs.getInt(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ShortFeeMngDatabase:getShortFeeAmt]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return fee_amt;
		}
	}
	
	/**
	 *	차량구분 코드 리스트
	 */
	public Vector getSectionRegDtList()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select reg_dt from short_fee_mng group by reg_dt order by reg_dt desc ";

		
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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim()/**/);
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ShortFeeMngDatabase:getSectionRegDtList]"+e);
			System.out.println("[ShortFeeMngDatabase:query]"+query);
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
	 *	단기대여요금 리스트
	 */
	public Vector getShortFeeMngList(String gubun1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select DISTINCT a.kind, b.code, b.nm_cd, b.nm, a.section, a.use_yn, a.stand_car, a.reg_dt"+
				" from short_fee_mng a, code b"+
				" where a.kind=b.code and b.c_st='0007' and b.code<>'0000'";

		if(gubun1.equals("")){
			query += " and a.reg_dt = (select max(reg_dt) from short_fee_mng)";
		}else{
			query += " and a.reg_dt=replace('"+gubun1+"','-','')";
		}

		query += " order by a.kind, a.section";
		
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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim()/**/);
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ShortFeeMngDatabase:getResSearchList]"+e);
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
