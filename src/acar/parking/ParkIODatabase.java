/**
 * 주차장관리
 * @ author : Gill Sun Ryu
 * @ e-mail : gillsun@empal.com
 * @ create date : 2008. 9. 2
 * @ last modify date : 
 */

package acar.parking;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.exception.DatabaseException;
import acar.exception.DataSourceEmptyException;


public class ParkIODatabase
{
	private Connection conn = null;
	public static ParkIODatabase db;
	private DBConnectionManager connMgr = null;
	// Pool로 부터 Connection 객체를 가져올때 사용하는 Pool Name 
    private final String DATA_SOURCE = "acar"; 


	public static ParkIODatabase getInstance() throws DatabaseException 
	{
		if(ParkIODatabase.db == null)
			ParkIODatabase.db = new ParkIODatabase();
		return ParkIODatabase.db;
	}	
		

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
	 *	점검항목 안에 점검했던 리스트
	 */
	public Vector ParkingList(String car_mng_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.*, b.user_nm FROM parking a, users b "+
				" WHERE a.reg_id = b.user_id(+) and a.car_mng_id = '"+car_mng_id+"' AND a.gubun IN ( '1', '3', '2')"+
				" order by a.serv_seq desc";
				
		
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
			System.out.println("[ParkIODatabase:ParkingList]"+e);
			System.out.println("[ParkIODatabase:ParkingList]"+query);
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
	 *	점검항목 안에 점검리스트에서 선택해서 보여주기
	 */

	public Vector ParkingListSelect(String car_mng_id)
	{
		getConnection();

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


				query = " SELECT * FROM parking  WHERE car_mng_id = '"+car_mng_id+"'";

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
			System.out.println("[ParkIODatabase:ParkingListSelect]"+e);
			System.out.println("[ParkIODatabase:ParkingListSelect]"+query);
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
	 *	점검항목 입력하기
	 */

	public int insertParking(ParkingBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		
		ResultSet rs = null;
		Statement stmt = null;
		int count = 0;
		String query = "";
		String query_seq = "";
		
		int seq = 0;
		

 	  	query_seq = "select nvl(max(serv_seq)+1, 1)  from parking where car_mng_id = '" + bean.getCar_mng_id() + "'";	

		query = " insert into parking \n"+
				" (CAR_MNG_ID, SERV_SEQ, SERV_DT, PARK_ID, CAR_KM,  \n"+
				" E_OIL, COOL_WT, WS_WT, E_CLEAN, OUT_CLEAN, TIRE_AIR, TIRE_MAMO, LAMP, IN_CLEAN, WIPER, \n"+
				" CAR_SOUND, PANEL, FRONT_BP, BACK_BP, LH_FHD, LH_BHD, LH_FDOOR, LH_BDOOR, RH_FHD, RH_BHD, \n"+
				" RH_FDOOR, RH_BDOOR, ENERGY, GOODS1, GOODS2, GOODS3, GOODS4,  \n"+
				"  GOODS5, GOODS6, GOODS7, GOODS8, GOODS9, GOODS10, GOODS11, GOODS12, GOODS13, E_OIL_NY, COOL_WT_NY, WS_WT_NY, E_CLEAN_NY, OUT_CLEAN_NY, TIRE_AIR_NY, TIRE_MAMO_NY, \n"+
				" LAMP_NY, IN_CLEAN_NY, WIPER_NY, CAR_SOUND_NY, PANEL_NY, FRONT_BP_NY, BACK_BP_NY, LH_FHD_NY, LH_BHD_NY, LH_FDOOR_NY, \n"+
				" LH_BDOOR_NY, RH_FHD_NY, RH_BHD_NY, RH_FDOOR_NY, RH_BDOOR_NY, ENERGY_NY, GITA, REG_ID, REG_DT, GUBUN, PARK_SEQ, AREA, CAR_KEY, CAR_KEY_CAU "+
				" ) values ("+
				" ?, ?, substr(replace(?, '-', ''),0,8), ?, ?, "+
				" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
				" ?, sysdate, ?, ?, ?, ? ,? )";
		

		try 
		{			
			conn.setAutoCommit(false);
			
  			stmt = conn.createStatement();
            rs = stmt.executeQuery(query_seq);
         
            if(rs.next())
            	seq = rs.getInt(1);
            rs.close();
			stmt.close();
				
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getCar_mng_id());
			pstmt.setInt(2, seq);
			pstmt.setString(3, bean.getServ_dt());
			pstmt.setString(4, bean.getPark_id());
			pstmt.setInt(5, bean.getCar_km());
		
			pstmt.setString(6, bean.getE_oil());
			pstmt.setString(7, bean.getCool_wt());
			pstmt.setString(8, bean.getWs_wt());
			pstmt.setString(9, bean.getE_clean());
			pstmt.setString(10, bean.getOut_clean());
			pstmt.setString(11, bean.getTire_air());
			pstmt.setString(12, bean.getTire_mamo());
			pstmt.setString(13, bean.getLamp());
			pstmt.setString(14, bean.getIn_clean());
			pstmt.setString(15, bean.getWiper());
			
			pstmt.setString(16, bean.getCar_sound());
			pstmt.setString(17, bean.getPanel());
			pstmt.setString(18, bean.getFront_bp());
			pstmt.setString(19, bean.getBack_bp());
			pstmt.setString(20, bean.getLh_fhd());
			pstmt.setString(21, bean.getLh_bhd());
			pstmt.setString(22, bean.getLh_fdoor());
			pstmt.setString(23, bean.getLh_bdoor());
			pstmt.setString(24, bean.getRh_fhd());
			pstmt.setString(25, bean.getRh_bhd());
			
			pstmt.setString(26, bean.getRh_fdoor());
			pstmt.setString(27, bean.getRh_bdoor());
			pstmt.setString(28, bean.getEnergy());
			pstmt.setString(29, bean.getGoods1());
			pstmt.setString(30, bean.getGoods2());
			pstmt.setString(31, bean.getGoods3());
			pstmt.setString(32, bean.getGoods4());
			pstmt.setString(33, bean.getGoods5());
			pstmt.setString(34, bean.getGoods6());
			pstmt.setString(35, bean.getGoods7());
			
			pstmt.setString(36, bean.getGoods8());
			pstmt.setString(37, bean.getGoods9());
			pstmt.setString(38, bean.getGoods10());
			pstmt.setString(39, bean.getGoods11());
			pstmt.setString(40, bean.getGoods12());
			pstmt.setString(41, bean.getGoods13());
			pstmt.setString(42, bean.getE_oil_ny());
			pstmt.setString(43, bean.getCool_wt_ny());
			pstmt.setString(44, bean.getWs_wt_ny());
			pstmt.setString(45, bean.getE_clean_ny());
			
			pstmt.setString(46, bean.getOut_clean_ny());
			pstmt.setString(47, bean.getTire_air_ny());
			pstmt.setString(48, bean.getTire_mamo_ny());
			pstmt.setString(49, bean.getLamp_ny());
			pstmt.setString(50, bean.getIn_clean_ny());
			pstmt.setString(51, bean.getWiper_ny());
			pstmt.setString(52, bean.getCar_sound_ny());
			pstmt.setString(53, bean.getPanel_ny());
			pstmt.setString(54, bean.getFront_bp_ny());
			pstmt.setString(55, bean.getBack_bp_ny());
			
			pstmt.setString(56, bean.getLh_fhd_ny());
			pstmt.setString(57, bean.getLh_bhd_ny());
			pstmt.setString(58, bean.getLh_fdoor_ny());
			pstmt.setString(59, bean.getLh_bdoor_ny());
			pstmt.setString(60, bean.getRh_fhd_ny());
			pstmt.setString(61, bean.getRh_bhd_ny());
			pstmt.setString(62, bean.getRh_fdoor_ny());
			pstmt.setString(63, bean.getRh_bdoor_ny());
			pstmt.setString(64, bean.getEnergy_ny());
			pstmt.setString(65, bean.getGita());

			pstmt.setString(66, bean.getReg_id());
			pstmt.setString(67, bean.getGubun());
			pstmt.setInt(68, bean.getPark_seq());
			pstmt.setString(69, bean.getArea());
			pstmt.setString(70, bean.getCar_key());
			pstmt.setString(71, bean.getCar_key_cau());

			count = pstmt.executeUpdate();

			pstmt.close();

			conn.commit();

	

		} catch (SQLException e) {
			System.out.println("[ParkIODatabase:insertParking]\n"+e);
	  		e.printStackTrace();
	  		count = 0;
			conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(rs != null) rs.close();
             			if(stmt != null) stmt.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	/**
	 *	점검항목 입력하기
	 */

	public int updateParking(ParkingBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";

		query = " update parking set \n"+
				" CAR_KM = ?, "+
				" E_OIL = ?, "+
				" COOL_WT = ?, "+ 
				" WS_WT = ?, "+ 
				" E_CLEAN = ?, "+ 
				" OUT_CLEAN = ?, "+ 
				" TIRE_AIR = ?, "+ 
				" TIRE_MAMO = ?, "+ 
				" LAMP = ?, "+ 
				" IN_CLEAN = ?, "+ 
				" WIPER = ?, "+
				" CAR_SOUND = ?, "+
				" PANEL = ?, "+ 
				" FRONT_BP = ?, "+ 
				" BACK_BP = ?, "+ 
				" LH_FHD = ?, "+ 
				" LH_BHD = ?, "+ 
				" LH_FDOOR = ?, "+ 
				" LH_BDOOR = ?, "+
				" RH_FHD = ?, "+
				" RH_BHD = ?, "+
				" RH_FDOOR = ?, "+ 
				" RH_BDOOR = ?, "+
				" ENERGY = ?, "+ 
				" GOODS1 = ?, "+
				" GOODS2 = ?, "+
				" GOODS3 = ?, "+
				" GOODS4 = ?, "+
				" GOODS5 = ?, "+
				" GOODS6 = ?, "+
				" GOODS7 = ?, "+
				" GOODS8 = ?, "+
				" GOODS9 = ?, "+
				" GOODS10 = ?, "+
				" GOODS11 = ?, "+
				" GOODS12 = ?, "+
				" GOODS13 = ?, "+
				" E_OIL_NY = ?, "+
				" COOL_WT_NY = ?, "+
				" WS_WT_NY = ?, "+
				" E_CLEAN_NY = ?, "+
				" OUT_CLEAN_NY = ?, "+
				" TIRE_AIR_NY = ?, "+
				" TIRE_MAMO_NY = ?, "+
				" LAMP_NY = ?, "+
				" IN_CLEAN_NY = ?, "+
				" WIPER_NY = ?, "+
				" CAR_SOUND_NY = ?, "+
				" PANEL_NY = ?, "+
				" FRONT_BP_NY = ?, "+
				" BACK_BP_NY = ?, "+
				" LH_FHD_NY = ?, "+
				" LH_BHD_NY = ?, "+
				" LH_FDOOR_NY = ?, "+
				" LH_BDOOR_NY = ?, "+
				" RH_FHD_NY = ?, "+
				" RH_BHD_NY = ?, "+
				" RH_FDOOR_NY = ?, "+
				" RH_BDOOR_NY = ?, "+
				" ENERGY_NY = ?, "+
				" GITA = ?, \n"+
				" AREA = ?, \n"+
				" CAR_KEY = ?, \n"+
				" CAR_KEY_CAU = ? \n"+
				" where CAR_MNG_ID = ? and SERV_SEQ = ? and SERV_DT = ? and PARK_ID = ? ";


		try 
		{			
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);

			pstmt.setInt(1, bean.getCar_km());
			pstmt.setString(2, bean.getE_oil());
			pstmt.setString(3, bean.getCool_wt());
			pstmt.setString(4, bean.getWs_wt());
			pstmt.setString(5, bean.getE_clean());
			pstmt.setString(6, bean.getOut_clean());
			pstmt.setString(7, bean.getTire_air());
			pstmt.setString(8, bean.getTire_mamo());
			pstmt.setString(9, bean.getLamp());
			pstmt.setString(10, bean.getIn_clean());
			pstmt.setString(11, bean.getWiper());
			
			pstmt.setString(12, bean.getCar_sound());
			pstmt.setString(13, bean.getPanel());
			pstmt.setString(14, bean.getFront_bp());
			pstmt.setString(15, bean.getBack_bp());
			pstmt.setString(16, bean.getLh_fhd());
			pstmt.setString(17, bean.getLh_bhd());
			pstmt.setString(18, bean.getLh_fdoor());
			pstmt.setString(19, bean.getLh_bdoor());
			pstmt.setString(20, bean.getRh_fhd());
			pstmt.setString(21, bean.getRh_bhd());
			
			pstmt.setString(22, bean.getRh_fdoor());
			pstmt.setString(23, bean.getRh_bdoor());
			pstmt.setString(24, bean.getEnergy());
			pstmt.setString(25, bean.getGoods1());
			pstmt.setString(26, bean.getGoods2());
			pstmt.setString(27, bean.getGoods3());
			pstmt.setString(28, bean.getGoods4());
			pstmt.setString(29, bean.getGoods5());
			pstmt.setString(30, bean.getGoods6());
			pstmt.setString(31, bean.getGoods7());
			
			pstmt.setString(32, bean.getGoods8());
			pstmt.setString(33, bean.getGoods9());
			pstmt.setString(34, bean.getGoods10());
			pstmt.setString(35, bean.getGoods11());
			pstmt.setString(36, bean.getGoods12());
			pstmt.setString(37, bean.getGoods13());
			pstmt.setString(38, bean.getE_oil_ny());
			pstmt.setString(39, bean.getCool_wt_ny());
			pstmt.setString(40, bean.getWs_wt_ny());
			pstmt.setString(41, bean.getE_clean_ny());
			
			pstmt.setString(42, bean.getOut_clean_ny());
			pstmt.setString(43, bean.getTire_air_ny());
			pstmt.setString(44, bean.getTire_mamo_ny());
			pstmt.setString(45, bean.getLamp_ny());
			pstmt.setString(46, bean.getIn_clean_ny());
			pstmt.setString(47, bean.getWiper_ny());
			pstmt.setString(48, bean.getCar_sound_ny());
			pstmt.setString(49, bean.getPanel_ny());
			pstmt.setString(50, bean.getFront_bp_ny());
			pstmt.setString(51, bean.getBack_bp_ny());
			
			pstmt.setString(52, bean.getLh_fhd_ny());
			pstmt.setString(53, bean.getLh_bhd_ny());
			pstmt.setString(54, bean.getLh_fdoor_ny());
			pstmt.setString(55, bean.getLh_bdoor_ny());
			pstmt.setString(56, bean.getRh_fhd_ny());
			pstmt.setString(57, bean.getRh_bhd_ny());
			pstmt.setString(58, bean.getRh_fdoor_ny());
			pstmt.setString(59, bean.getRh_bdoor_ny());
			pstmt.setString(60, bean.getEnergy_ny());
			pstmt.setString(61, bean.getGita());
			pstmt.setString(62, bean.getArea());
			pstmt.setString(63, bean.getCar_key());
			pstmt.setString(64, bean.getCar_key_cau());

			pstmt.setString(65, bean.getCar_mng_id());
			pstmt.setInt(66, bean.getServ_seq());
			pstmt.setString(67, bean.getServ_dt());
			pstmt.setString(68, bean.getPark_id());

							

			count = pstmt.executeUpdate();

			pstmt.close();

			conn.commit();

	

		} catch (SQLException e) {
			System.out.println("[ParkIODatabase:updateParking]\n"+e);
			System.out.println("[ParkIODatabase:updateParking]\n"+query);
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
	 *	입/출고 입력하기
	 */
	public int insertParkIO(ParkIOBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Statement stmt = null;
		int count = 0;
		String query = "";
		String query_seq = "";

		int seq = 0;

 	  	query_seq = "select nvl(max(park_seq)+1, 1)  from park_io where car_mng_id = '" + bean.getCar_mng_id() + "'";	


		query = " insert into park_io \n"+
				" (CAR_MNG_ID, PARK_SEQ, PARK_ID, REG_ID, IO_GUBUN, CAR_ST, CAR_NO, CAR_NM, CAR_KM, \n"+
				" IO_DT, IO_SAU, USERS_COMP, START_PLACE, END_PLACE, DRIVER_NM, BR_ID, PARK_MNG, CAR_GITA \n"+
				" ,REG_DT, USE_YN, RENT_L_CD, CAR_KEY_CAU ) values ("+
				" ?, ?, ?, ?, ?, ?, ?, ?, ?,  "+
				" substr(replace(?, '-', ''),0,12), ?, ?, ?, ?, ?, ?, ?, ?,  "+
				" sysdate, ?, ?, ? )";		

		try 
		{			
			conn.setAutoCommit(false);
			
  			stmt = conn.createStatement();
            rs = stmt.executeQuery(query_seq);
         
            if(rs.next())
            	seq = rs.getInt(1);
            rs.close();
			stmt.close();
				
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getCar_mng_id());
			pstmt.setInt(2, seq);
			pstmt.setString(3, bean.getPark_id());
			pstmt.setString(4, bean.getReg_id());
			pstmt.setString(5, bean.getIo_gubun());
			pstmt.setString(6, bean.getCar_st());
			pstmt.setString(7, bean.getCar_no());
			pstmt.setString(8, bean.getCar_nm());
			pstmt.setInt(9, bean.getCar_km());
			
			pstmt.setString(10, bean.getIo_dt());
			pstmt.setString(11, bean.getIo_sau());
			pstmt.setString(12, bean.getUsers_comp());
			pstmt.setString(13, bean.getStart_place());
			pstmt.setString(14, bean.getEnd_place());
			pstmt.setString(15, bean.getDriver_nm());
			pstmt.setString(16, bean.getBr_id());
			pstmt.setString(17, bean.getPark_mng());
			pstmt.setString(18, bean.getCar_gita());

			pstmt.setString(19, bean.getUse_yn());
			pstmt.setString(20, bean.getRent_l_cd());
			pstmt.setString(21, bean.getCar_key_cau());
			
			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[ParkIODatabase:insertParkIO]\n"+e);
			System.out.println("[ParkIODatabase:insertParkIO]\n"+query);
	  		e.printStackTrace();
	  		seq = 0;
			conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(rs != null) rs.close();
                if(stmt != null) stmt.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return seq;
		}
	}


	/**
	 *	입고처리 클릭시 해당 차량정보 가져오기
	 */

	
	public Vector Parkingipgo(String car_mng_id, String rent_s_cd, String ret_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.*, b.* "+
				" from rent_cont a, car_reg b"+
				" where a.car_mng_id = b.car_mng_id and a.car_mng_id = '"+car_mng_id+"' and a.rent_s_cd = '"+rent_s_cd+"' ";


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
			System.out.println("[ParkIODatabase:Parkingipgo]"+e);
			System.out.println("[ParkIODatabase:Parkingipgo]"+query);
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
	 *	출고처리 클릭시 해당 차량정보 가져오기
	 */
	
	public Vector CarBasicInfo(String car_mng_id, String rent_s_cd, String deli_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select s.t_dist, a.car_mng_id, a.car_st, nvl(a.mng_id, bus_id2) mng_id, b.car_no, b.car_nm, b.car_num, b.init_reg_dt, b.dpm, b.FUEL_KD "+
				" from cont a, car_reg b, ( SELECT car_mng_id, max( tot_dist ) AS t_dist FROM service GROUP BY car_mng_id ) s"+
				" where a.car_mng_id = b.car_mng_id(+) and a.car_mng_id = s.car_mng_id(+) and nvl(a.use_yn,'Y') = 'Y' and a.car_mng_id = '"+car_mng_id+"' ";


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
			System.out.println("[ParkIODatabase:CarBasicInfo]"+e);
			System.out.println("[ParkIODatabase:CarBasicInfo]"+query);
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
	 *	출고처리 클릭시 해당 차량정보 가져오기
	 */
	
	public Vector CarBasicInfo(String car_mng_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select s.t_dist, a.car_mng_id, a.car_st, nvl(a.mng_id, bus_id2) mng_id, b.car_no, b.car_nm, b.car_num, b.init_reg_dt, b.dpm, b.FUEL_KD "+
				" from cont a, car_reg b, ( SELECT car_mng_id, max( tot_dist ) AS t_dist FROM service GROUP BY car_mng_id ) s"+
				" where a.car_mng_id = b.car_mng_id(+) and a.car_mng_id = s.car_mng_id(+) and nvl(a.use_yn,'Y') = 'Y' and a.car_mng_id = '"+car_mng_id+"' ";


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
			System.out.println("[ParkIODatabase:CarBasicInfo]"+e);
			System.out.println("[ParkIODatabase:CarBasicInfo]"+query);
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
	 *	출고처리 클릭시 해당 차량정보 가져오기
	 */
	 
	public String CarBasicMngId(String car_mng_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;		
		String query = "";		
		
		query = " select nvl(mng_id, bus_id2) mng_id from cont  "+			
				" where nvl(use_yn,'Y') = 'Y' and car_mng_id = '"+car_mng_id+"'";

		String mng_id = "";

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				mng_id = rs.getString(1)==null?"":rs.getString(1);
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
			return mng_id;
		}
	}

	
	/* 입고처리시 탁송에서 가져오기*/

	public Vector Consignmentipgo(String car_mng_id, String r_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		query = " select a.*,decode( a.cons_cau, '8', '지연대차회수','9', '정비대차회수', '10', '사고대차회수', '11', '정비차량회수','12', '사고차량회수', '13', '중도해지회수', '14', '만기반납','15', '대여차량회수', '16', '본사이동' ) AS cons_st_nm, d.USER_NM"+
				" from consignment a, (SELECT car_no, max( to_dt ) to_dt FROM consignment where cons_cau  in ('8','9','10','11','12','13','14','15','16') GROUP BY car_no) b, (select * from cont where use_yn = 'Y') c, users d"+
				" where a.car_no = b.car_no(+) and a.rent_l_cd = c.rent_l_cd and a.to_dt = b.to_dt and a.REG_ID = d.USER_ID"+
				" and a.to_dt IS NOT NULL and (a.to_place like '%파천%' or a.to_place like '%부산%' or a.to_place like '%대전%' or a.to_place like '%본사%') and a.car_mng_id='"+car_mng_id+"' and substr(a.to_dt, 1,8) = substr('"+r_dt+"',1,8) ";


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
			System.out.println("[ParkIODatabase:Consignmentipgo]"+e);
			System.out.println("[ParkIODatabase:Consignmentipgo]"+query);
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


/* 출고처리시 탁송에서 가져오기*/

public Vector Consignmentipgo2(String car_mng_id, String d_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		query = " select a.*,decode( a.cons_cau, '1', '대여차량인도', '3', '지연대차인도', '4', '정비대차인도', '5', '사고대차인도','6', '정비차량인도', '7', '사고차량인도', '17', '지점이동') AS cons_st_nm, d.USER_NM"+
				" from consignment a, (SELECT car_no, max( from_dt ) from_dt FROM consignment where cons_cau  in ('1','3','4','5','6','7','17') GROUP BY car_no) b, (select * from cont where use_yn = 'Y') c, users d"+
				" where a.car_no = b.car_no(+) and a.rent_l_cd = c.rent_l_cd and a.from_dt = b.from_dt and a.REG_ID = d.USER_ID"+
				" and a.from_dt IS NOT NULL and (a.from_place like '%파천%' or a.from_place like '%부산%' or a.from_place like '%대전%' or a.from_place like '%본사%') and a.car_mng_id='"+car_mng_id+"' and substr(a.from_dt, 1,8) = substr('"+d_dt+"',1,8) ";


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
			System.out.println("[ParkIODatabase:Consignmentipgo]"+e);
			System.out.println("[ParkIODatabase:Consignmentipgo]"+query);
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


/* 탁송정보 가져오기 */

public Hashtable ConsignmentInfo(String car_no, String d_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = "SELECT * FROM("+
				"SELECT * FROM CONSIGNMENT WHERE car_no='"+car_no+"' and substr(FROM_REQ_DT,1,8)='"+d_dt+"' order by reg_dt desc"+
				") where rownum = 1";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery(); 
			ResultSetMetaData rsmd = rs.getMetaData();

			if(rs.next()){	
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ParkIODatabase:getRentParkIOSearch]"+e);
			System.out.println("[ParkIODatabase:getRentParkIOSearch]"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )			rs.close();
                if(pstmt != null)		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}

	/**
     * 입고시 차량번호  중복 체크
     */ 

public Vector CheckCar_no(String car_mng_id) 
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";



		query = " select count(0) from park_io where car_mng_id='"+car_mng_id+"'";


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
			System.out.println("[ParkIODatabase:CheckCar_no]"+e);
			System.out.println("[ParkIODatabase:CheckCar_no]"+query);
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
	 *	차고지별 차량 현황 
	 */
	public Vector getRentParkRealList(String br_id, String gubun1, String start_dt, String end_dt, String s_cc,  int s_year, String s_kd, String brid, String t_wd, String sort_gubun, String asc )
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String p_nm = "";
		String park_in = "";


		if(brid.equals("1")){
			//p_nm = "목동";
			p_nm = "영남";
			park_in = "and a.park_id in ('1') " ;			
		}else if(brid.equals("3")){
			p_nm = "부산";
			park_in = "and a.park_id in ('3', '7', '8') " ;			
		}else if(brid.equals("4")){
			p_nm = "대전";
			park_in = "and a.park_id in ('4', '9') " ;			
		}

		query = " select t.car_key, t.car_key_cau, t.reg_dt, t.jg_code, t.p_sort, t.area, t.rent_mng_id, t.rent_l_cd, t.car_use, t.brch_id, t.p_p, t.uu_st, t.rr_st, t.brch_nm, t.car_mng_id, t.car_no, t.car_nm, t.init_reg_dt, \n "+
				" t.car_st, t.rent_dt, t.rent_start_dt, t.rent_end_dt, t.deli_plan_dt, t.ret_plan_dt, t.bus_nm, t.fuel_kd, t.dpm, t.taking_p, \n "+
			    " t.colo, t.use_st, t.rent_st, t.rent_s_cd, t.first_car_no, t.prepare, t.park, t.park_cont, t.car_stat, \n "+
			    " t.rent_st_nm, t.cust_nm, t.firm_nm, decode(t.car_stat, '배차', decode(t.rent_st_nm,'업무', t.cust_nm, t.firm_nm), t.park ) as park_nm, '' as park_mng, '' as users_comp, '' as driver_nm  , t.park_id   \n"+
			    " from (  \n"+
				"        select pk.car_key, pk.car_key_cau, nvl(to_char(po.reg_dt, 'yyyymmddhh24miss'), nvl(to_char(pk.reg_dt, 'yyyymmddhh24miss'), b.reg_dt ) )  reg_dt, r.jg_code, a.park park_id, decode(po.io_gubun, '2', '9' , '0') p_sort,  decode(nvl(q.mng_br_id,b.brch_id),'S1',1,'K1',1,'B1',2,'N1',2,'D1',3) brch_id, decode(nvl(a.prepare,'1'),'2','2','5','3','4','4','8','5','1') p_p, \n"+
				"        decode(i.use_st,'1','1','2','2','0') as uu_st, decode(i.use_st,'1',i.rent_st,'2',decode(i.rent_st,'6','0.1','7','0.2','8','0.3',i.rent_st),'0') rr_st,  \n"+
				"        decode(nvl(q.mng_br_id,b.brch_id),'S1','본사','K1','본사','B1','부산지점','N1','부산지점''D1','대전지점','S2','강남지점','J1','광주지점','G1','대구지점','I1','인천지점','S3','강서지점','S4','구로지점','U1','울산지점','S5','광화문지점','S6','송파지점') brch_nm, a.car_mng_id, a.car_no, a.car_nm, a.init_reg_dt, b.car_st, b.rent_dt, i.rent_start_dt, i.rent_end_dt, i.deli_plan_dt, i.ret_plan_dt, p.user_nm as bus_nm, b.rent_mng_id, b.rent_l_cd,\n"+
				"        cd2.nm as fuel_kd,  \n"+
				"        a.dpm, a.car_use, a.taking_p, c.colo,  i.use_st, i.rent_st, i.rent_s_cd, a.first_car_no, \n"+
				"        decode(a.prepare, '2','매각', '3','보관', '4','말소', '5','도난', '6','해지', '8','수해', '예비') prepare, " +
				"        decode(a.park,'6',substr(a.park_cont,1,5),nvl(cd.nm,a.park))  park, a.park_cont,  \n"+
				"        decode(i.use_st, '1','예약','2','배차',decode(a.prepare,'4','-','5','-','6','-','8','-','대기')) car_stat,  \n"+
				"        decode(a.prepare,'4','-','5','-','6','-','8','-', decode(i.rent_st,'1','단기','2','정비','3','사고','9','보험','10','지연','4','업무','5','업무','6','정비','7','정비','8','수리','11','대기')) rent_st_nm,  \n"+
				"        decode(i.cust_st, '', '조성희', '1',l.client_nm, '4',n.user_nm, m.cust_nm) cust_nm,  \n"+
				"        decode(i.cust_st, '', '아마존카', '1',replace(l.firm_nm,'(주)',''), '4','아마존카', m.firm_nm) firm_nm, pk.area  \n"+
				"        from car_reg a, cont b, car_etc c, client l, users n, rent_cust m, users p, cont_etc q, car_nm r,  \n"+
				"               ( select c_st, code, nm_cd, nm from code where c_st = '0027') cd,  \n"+  //주차장 
				"               ( select c_st, code, nm_cd, nm from code where c_st = '0039') cd2, \n"+
				"               (select a.* from park_io a, (select car_mng_id, max(park_seq) as seq from park_io where use_yn = 'Y'  group by car_mng_id ) p where  a.car_mng_id = p.car_mng_id and a.io_gubun = '2' and a.park_seq = p.seq   " + park_in + " ) po,  \n"+
				"               (select a.car_mng_id, a.area , a.reg_dt, A.CAR_KEY, a.car_key_cau from parking a, (select car_mng_id, max(serv_seq) as seq from parking  group by car_mng_id ) p where  a.car_mng_id = p.car_mng_id and a.serv_seq = p.seq   " + park_in + " ) pk,  \n"+
				"               (select a.* from rent_cont a, (select car_mng_id, max(use_st||nvl(deli_dt,decode(rent_st,'11','0000000000',deli_plan_dt))) deli_dt from rent_cont where use_st in ('1','2') group by car_mng_id) b where a.use_st in ('1','2') and a.car_mng_id=b.car_mng_id and a.use_st||nvl(a.deli_dt,decode(a.rent_st,'11','0000000000',a.deli_plan_dt))=b.deli_dt) i,  \n "+
				"               (select car_mng_id, count(0) as a_cnt from accident where accid_st='6' group by car_mng_id) k  \n"+
				"        where nvl(b.use_yn,'Y')='Y' and ( b.car_st='2'  or a.ip_chk  = 'Y' ) \n "+
				"        and nvl(a.off_ls,'0')='0' and a.car_mng_id=b.car_mng_id  \n"+
				"        and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd  \n"+
				"        and i.cust_id=l.client_id(+) and i.cust_id=n.user_id(+) and i.cust_id=m.cust_id(+)  \n"+
				"        and a.car_mng_id=i.car_mng_id(+)  \n"+
				"        and a.car_mng_id=po.car_mng_id(+) \n"+
				"        and a.car_mng_id=pk.car_mng_id(+) \n"+
				"        and a.car_mng_id=k.car_mng_id(+) and i.bus_id=p.user_id(+) \n"+
				"        and a.park = cd.nm_cd(+) \n"+  //주차장 코드 테이블 
				"        and a.fuel_kd = cd2.nm_cd \n"+
				"        and b.rent_mng_id=q.rent_mng_id(+) and b.rent_l_cd=q.rent_l_cd(+) AND c.car_id = r.car_id AND c.car_seq = r.car_seq \n"+
				" ) t \n"+
				" where t.car_stat != '배차' and   t.park  like '%"+p_nm+"%'";
				
		if(s_kd.equals("1"))	query += " and upper(t.car_no)||upper(t.first_car_no) like upper('%"+t_wd+"%')\n";		
		if(s_kd.equals("4"))	query += " and upper(t.car_nm) like upper('%"+t_wd+"%')\n";			

		
 	  query += " \n union all \n"+
				" select pk.car_key, pk.car_key_cau, to_char(a.reg_dt, 'yyyymmddhh24miss')  reg_dt, f.jg_code, case when a.io_gubun='3' then '88' else decode(a.car_st, '4', '99', '0' ) end p_sort,  pk.area, "+
				" c.rent_mng_id, NVL(c.rent_l_cd, a.RENT_L_CD) AS rent_l_cd, b.car_use, decode(a.br_id, 'S1', 1, 'K1', 1, 'B1', 2, 'N1', 2, 'D1', 3) brch_id, decode( nvl(b.prepare, '1' ), '2', '2', '5', '3', '4', '4', '8', '5', '1' ) p_p, '', '', \n" +
				" decode(a.br_id,'S1','본사','K1','본사','B1','부산지점','N1','부산지점''D1','대전지점','G1','대구지점','J1','광주지점','I1','인천지점','본사') as brch_nm, a.car_mng_id, nvl(b.car_no, a.car_no) car_no, nvl(b.car_nm, a.car_nm) car_nm, b.init_reg_dt,  a.car_st, "+
				" '', '', '', '', substr(a.io_dt, 1,8) as ret_plan_dt, '', cd2.nm AS fuel_kd, b.DPM, b.taking_p, d.colo, '', decode(a.io_sau, '1','단기대여','2','보험대차','3','지연대차','4','사고대차','5','정비대차','6','업무대여','7','장기대기','8','예약','9','차량정비','10','사고수리','11','임시','12','월렌트') AS rent_st, "+
				" '',  a.car_no as first_car_no, decode(b.prepare, '2', '매각', '3', '보관', '4', '말소',  '5', '도난', '6', '해지', '8', '수해', '임시' ) prepare, "+
				" decode( a.park_id, '1','영남주차장', '2','파천교', '3','부산지점', '4','대전지점', '5','신엠제이모터스', '7','부산부경','8','부산스타','9','대전현대' ,'11','대전금호', '12', '광주지점', '13', '대구지점', '14','상무현대','16','동화엠파크','17','웰메이드','18','본동자동차','19','타이어휠타운') AS park, "+
				" '', '',decode( a.io_gubun, '1', '입고', '2', '출고', '3','매각확정') AS rent_st_nm, '', '', decode( a.park_id, '1','영남주차장', '2','파천교', '3','부산지점', '4','대전지점', '5','신엠제이모터스', '7','부산부경','8','부산스타','9','대전현대','11','대전금호','12','광주지점','13','대구지점', '14','상무현대','16','동화엠파크','17','웰메이드','18','본동자동차','19','타이어휠타운' ) AS park_nm, a.park_mng, a.users_comp, a.driver_nm , a.park_id  \n"+
				" from park_io a, car_reg b, cont c, car_etc d, (select car_mng_id, max(park_seq) as seq from park_io where use_yn ='Y'  group by car_mng_id ) e, car_nm f , \n"+
				" (select a.car_mng_id, a.area, A.CAR_KEY, a.CAR_KEY_CAU  from parking a, (select car_mng_id, max(serv_seq) as seq from parking  group by car_mng_id ) p where  a.car_mng_id = p.car_mng_id and a.serv_seq = p.seq   " + park_in + " ) pk  \n"+
				"               ( select c_st, code, nm_cd, nm from code where c_st = '0039') cd2 \n"+
				" WHERE a.car_mng_id = e.car_mng_id and a.park_seq = e.seq and  a.car_mng_id = pk.car_mng_id(+) and a.use_yn ='Y' and nvl(c.use_yn, 'Y') = 'Y' and a.car_mng_id = b.car_mng_id(+) AND a.car_mng_id = c.car_mng_id(+) AND c.rent_l_cd = d.rent_l_cd(+) AND d.car_id = f.car_id(+) AND d.car_seq = f.car_seq(+) \n" +
				" and b.FUEL_KD=cd2.nm_cd "+
				" and a.io_gubun in ('1','3')   and a.park_id IN ('1','2','3','4','5','6','7','8','9')  " + park_in + " \n";


		if(s_kd.equals("1"))	query += " and upper(a.car_no)||upper(first_car_no) like upper('%"+t_wd+"%')\n";		
		if(s_kd.equals("4"))	query += " and upper(a.car_nm) like ('%"+t_wd+"%')\n";			

		if(sort_gubun.equals("5"))		query += " order by p_sort, jg_code desc, reg_dt, ret_plan_dt asc, prepare desc, rent_st_nm asc ";


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
			System.out.println("[ParkIODatabase:getRentParkRealList]"+e);
			System.out.println("[ParkIODatabase:getRentParkRealList]"+query);
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





//PARK_IO에서 car_mng_id 가져가기 //출고시
	public Hashtable getRentParkIOSearch(String car_mng_id, String brid)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		int count = 0;
		String query = "";
				
		String park_in = "";

		if(brid.equals("1")){
		
			park_in = " and a.park_id in ('1') " ;			
		}else if(brid.equals("3")){
		
			park_in = " and a.park_id in ('3', '7', '8' ,'17') " ;			
		}else if(brid.equals("4")){
		
			park_in = " and a.park_id in ('4', '9') " ;			
		}

		query +=" select a.* "+
				" from park_io a, (select car_mng_id, max(park_seq) seq from park_io where use_yn = 'Y' group by car_mng_id) b where a.CAR_MNG_ID = b.car_mng_id and a.park_seq = b.seq "+
				" and a.car_mng_id = '"+car_mng_id+"'  and a.io_gubun = '2'  " +park_in ;


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery(); 
			ResultSetMetaData rsmd = rs.getMetaData();

			if(rs.next()){	
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ParkIODatabase:getRentParkIOSearch]"+e);
			System.out.println("[ParkIODatabase:getRentParkIOSearch]"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )			rs.close();
                if(pstmt != null)		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}


	//PARK_IO에서 car_mng_id 가져가기 //입고시
	public Hashtable getRentParkIOSearch2(String car_mng_id )
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		int count = 0;
		String query = "";

		query +=" select a.* "+
				" from park_io a, (select car_mng_id, max(park_seq) seq from park_io where use_yn = 'Y' group by car_mng_id) b where a.CAR_MNG_ID = b.car_mng_id and a.park_seq = b.seq "+
				" and a.car_mng_id = '"+car_mng_id+"' and a.io_gubun in ('1','2') ";


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery(); 
			ResultSetMetaData rsmd = rs.getMetaData();

			if(rs.next()){	
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ParkIODatabase:getRentParkIOSearch2]"+e);
			System.out.println("[ParkIODatabase:getRentParkIOSearch2]"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )			rs.close();
                if(pstmt != null)		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}


	//PARK_IO에서 입고시 데이터 삭제
	public int UpdateParkIO(String car_mng_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count2 = 0;
		String query = "";

		query = " update  PARK_IO set use_yn = 'N' "+
				" where car_mng_id='"+car_mng_id+"' and io_gubun in ('1','2')  and use_yn = 'Y' ";

		try 
		{			
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			count2 = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
		} catch (SQLException e) {
			System.out.println("[ParkIODatabase:UpdateParkIO]\n"+e);
			System.out.println("[ParkIODatabase:UpdateParkIO]\n"+query);
	  		e.printStackTrace();
			conn.rollback();
	  	} catch (Exception e) {
		  	System.out.println("[ParkIODatabase:UpdateParkIO]\n"+e);
			System.out.println("[ParkIODatabase:UpdateParkIO]\n"+query);
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count2;
		}
	}
	
		
	//car_reg의 park 위치 수정
	public int UpdateCarRegPark(String car_mng_id, String park_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count2 = 0;
		String query = "";

		query = " update  car_reg  set  park = '"+ park_id + "' "+
				" where car_mng_id='"+car_mng_id+"' ";

		try 
		{			
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			count2 = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
		} catch (SQLException e) {
			System.out.println("[ParkIODatabase:UpdateCarRegPark]\n"+e);
			System.out.println("[ParkIODatabase:UpdateCarRegPark]\n"+query);
	  		e.printStackTrace();
			conn.rollback();
	  	} catch (Exception e) {
		  	System.out.println("[ParkIODatabase:UpdateCarRegPark]\n"+e);
			System.out.println("[ParkIODatabase:UpdateCarRegPark]\n"+query);
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count2;
		}
	}
	

	/**
	 *	차량별 운행현황 리스트
	 */
	public Vector getParking_car(String car_mng_id, String io_gubun, int park_seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select b.car_key, b.car_key_cau, A.CAR_MNG_ID, A.IO_GUBUN, A.CAR_NO, A.CAR_NM, A.CAR_KM, SUBSTR( A.IO_DT, 0, 8 ) IO_DT, " +
				" A.USERS_COMP, "+
				" A.PARK_MNG,DECODE( A.DRIVER_NM, 'S', '직원', 'C', '고객', 'T', '탁송업체', 'M', '신엠제이모터스', 'NO','알수없음', 'H','정일현대공업사', 'D','두꺼비공업사', 'G1','명광택', 'G2','플라이클럽', 'AT','오토크린', 'HD','현대카독크', 'DA', '다옴방', 'BK', '부경공업사', '1K','대전금호', 'BD','본동자동차','TW','타이어휠타운','NO','알수없음','-' ) DRIVER_NM , "+
				" DECODE( A.CAR_ST, '2', '예비차량', '고객차량' ) CAR_ST_NM , to_char(a.reg_dt, 'yyyy-mm-dd hh24:mi:ss') reg_dt , A.CAR_ST, A.PARK_SEQ "+
				" from park_io a, parking b "+
				" where a.CAR_MNG_ID = b.CAR_MNG_ID(+) AND a.PARK_SEQ = b.SERV_SEQ(+) and a.car_mng_id ='"+car_mng_id+"' and a.park_seq =" + park_seq ;


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
			System.out.println("[ParkIODatabase:getParking_car]"+e);
			System.out.println("[ParkIODatabase:getParking_car]"+query);
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


	//당산 ->목동주차장관리 입고차량번호 조회시 - 고객차량:관리담당자, 보유차인 경우: 대차의뢰자  - 명의변경된건은 제외 
	public Vector getParkSearch(String s_rent_l_cd, String s_client_nm, String s_car_no, String s_rent_s_dt, String s_kd, String t_wd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		
	
		  query = " select a.use_yn, nvl(a.mng_id, bus_id2) as mng_id, a.car_st, nvl(s.t_dist, 0) t_dist, TRIM(p.park_id) park_id, \n"+
				"        decode(a.use_yn,'N','해지','Y','대여','','대기') use_st, u.user_nm as mng_nm, u.user_m_tel, \n"+
				"        a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.rent_start_dt, a.rent_end_dt, \n"+
				"        nvl(b.car_no,nvl(g.est_car_no,nvl(g.car_num,g.rpt_no))) car_no, " +
				"        nvl(b.car_num,g.car_num) car_num, " +				
				"		 e.car_name, f.car_nm, \n"+
				"        b.car_y_form, REGEXP_REPLACE(b.INIT_REG_DT, '(....)(..)(..)', '\\1-\\2-\\3') INIT_REG_DT, c.firm_nm, c.client_nm, d.colo, \n"+
				"        decode(substr(b.init_reg_dt, 1,6), '','신차','신차아님') as shin_car, \n"+
				"        decode( a.car_gu, '1', '신차','신차아님' ) AS car_gu, \n"+
				"        i.cls_dt \n"+
				" from   cont a, car_reg b, car_etc d, client c, car_nm e, car_mng f, car_pur g, sui h, cls_cont i, users u, (select  car_mng_id, max(tot_dist) as t_dist from service group by car_mng_id) s, PARK_CONDITION p    \n"+
				" where  a.car_mng_id=b.car_mng_id(+)  \n"+
				"        and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd \n"+
				"        and a.client_id=c.client_id and a.CAR_MNG_ID = s.CAR_MNG_ID(+) \n"+
				"        and d.car_id=e.car_id and d.car_seq=e.car_seq \n"+
				"        and e.car_comp_id=f.car_comp_id and e.car_cd=f.code \n"+
				"        and a.rent_mng_id=g.rent_mng_id and a.rent_l_cd=g.rent_l_cd \n"+
				"        and a.rent_l_cd = p.rent_l_cd(+) \n"+
				"        and a.car_mng_id=h.car_mng_id(+)  \n"+	
				"		 and nvl(a.mng_id, bus_id2) = u.user_id  \n "+
				"        and a.rent_mng_id=i.rent_mng_id(+) and a.rent_l_cd=i.rent_l_cd(+) \n"+
				" ";
    		
		if(s_kd.equals("2"))		query += " and b.off_ls <> '6' and nvl(b.car_no,g.est_car_no)||b.first_car_no like '%"+t_wd+"%'";	
		else if(s_kd.equals("4"))	query += " and nvl(b.car_num,g.car_num) like '%"+t_wd+"%'";
		else if(s_kd.equals("5"))	query += " and a.rent_l_cd = '" + s_rent_l_cd + "'";
			
		if(s_kd.equals("2"))	query += "\n order by a.use_yn desc, a.rent_dt desc , 1 desc ";
		else						query += "\n order by  a.rent_dt desc, 1 desc";

		//System.out.println("[ParkIODatabase:getParkSearch]"+query);

		try {
			stmt = conn.createStatement();
		    rs = stmt.executeQuery(query);
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
			stmt.close();

		} catch (SQLException e) {
			System.out.println("[ParkIODatabase:getParking_car]"+e);
			System.out.println("[ParkIODatabase:getParking_car]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}	
   

//당산차량 삭제
	public int parking_del(String car_mng_id, int seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		
		ResultSet rs = null;
			
		int count2 = 0;
		String query = "";
		String query1 = "";
		String query2 = "";
		
		int park_seq = 0;

		query = " delete from PARKING "+
				" where car_mng_id='"+car_mng_id+"' and serv_seq = "+seq;
								
		query1 = " select nvl(max(park_seq), 0)  from PARKING "+
				" where car_mng_id='"+car_mng_id+"' and serv_seq ="+seq;	
					
		query2 = " delete from PARK_IO "+
				" where car_mng_id= ? and park_seq =  ? ";
				
		try 
		{			
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query1);
	    	rs = pstmt1.executeQuery();
			
			if(rs.next())
			{				
			    park_seq = rs.getInt(1);	
			}
			rs.close();
			pstmt1 .close();
			
			if (park_seq > 0 ) {
				
				pstmt2 = conn.prepareStatement(query2);
				pstmt2.setString(1, car_mng_id);
				pstmt2.setInt(2, park_seq);
				count2 = pstmt2.executeUpdate();
				pstmt2.close();				
			}				
					
			pstmt = conn.prepareStatement(query);
			count2 = pstmt.executeUpdate();
			pstmt.close();
			
			conn.commit();
		    
		} catch (SQLException e) {
			System.out.println("[ParkIODatabase:parking_del]\n"+e);
			System.out.println("[ParkIODatabase:parking_del]\n"+query);
	  		e.printStackTrace();
			conn.rollback();
	  	} catch (Exception e) {
		  	System.out.println("[ParkIODatabase:parking_del]\n"+e);
			System.out.println("[ParkIODatabase:parking_del]\n"+query);
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
                if(rs != null )		rs.close();
                if(pstmt1 != null)	pstmt1.close();
				if(pstmt2 != null)	pstmt2.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count2;
		}
	}
	
	
//매각차량 삭제
	public int parking_del2(String car_mng_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count2 = 0;
		String query = "";

		query = " delete from PARK_IO "+
				" where car_mng_id='"+car_mng_id+"' and io_gubun = '3' ";

		try 
		{			
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			count2 = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
		} catch (SQLException e) {
			System.out.println("[ParkIODatabase:parking_del2]\n"+e);
			System.out.println("[ParkIODatabase:parking_del2]\n"+query);
	  		e.printStackTrace();
			conn.rollback();
	  	} catch (Exception e) {
		  	System.out.println("[ParkIODatabase:parking_del2]\n"+e);
			System.out.println("[ParkIODatabase:parking_del2]\n"+query);
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count2;
		}
	}
	
	//보유차여부
	public int getRentReseach(String car_mng_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		int count = 0;
		String query = "";
				
				
		query +=" select count(0) cnt  from (   \n" +		  
	    		    " select a.car_mng_id	 \n" +		
	    		    " from car_reg a, cont b, \n" +				
					" (select a.* from rent_cont a, (select car_mng_id, max(nvl(deli_dt,decode(use_st,'1','0000000000',deli_plan_dt))) deli_dt from rent_cont where use_st in ('1','2') group by car_mng_id) b where a.use_st in ('1','2') and a.car_mng_id=b.car_mng_id and nvl(a.deli_dt,decode(a.use_st,'1','0000000000',a.deli_plan_dt))=b.deli_dt) i  \n "+
					" where nvl(b.use_yn,'Y')='Y' and ( b.car_st='2'  or a.ip_chk  = 'Y' ) \n "+
					" and nvl(a.off_ls,'0')='0' and a.car_mng_id=b.car_mng_id  \n"+			
					" and a.car_mng_id=i.car_mng_id(+)  and a.park <> '6' \n"+
					" and decode(i.use_st, '1','예약','2','배차',decode(a.prepare,'4','-','5','-','6','-','8','-','대기')) != '배차' \n"+
					" and a.car_mng_id ='"+car_mng_id+"' \n"+
					" union all     \n"+      
                	" select  a.car_mng_id  \n"+
				 	" from park_io a, car_reg b, cont c, car_etc d, (select car_mng_id, max(park_seq) as seq from park_io where use_yn ='Y'  group by car_mng_id ) e   \n"+
				 	" WHERE a.car_mng_id = e.car_mng_id and a.park_seq = seq   and a.use_yn ='Y' and nvl(c.use_yn, 'Y') = 'Y'  \n"+
                 	" and a.car_mng_id = b.car_mng_id(+) AND a.car_mng_id = c.car_mng_id(+) AND c.rent_l_cd = d.rent_l_cd(+) and io_gubun in ('1','3')  \n"+
                 	" and a.car_mng_id = '"+car_mng_id+"' ) t ";							
			
				
		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{				
			    count = rs.getInt(1);	
			}
			rs.close();
			pstmt.close();
	  	} catch (Exception e) {
			System.out.println("[ResSearchDatabase:getRentReseach(()]\n"+e);
			System.out.println("[ResSearchDatabase:getRentReseach(()]\n"+query);
			e.printStackTrace();
		} finally {
			try{	
				if(rs != null)		rs.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

		//보유차 배차여부 //입고시
	public Hashtable getRentReseach2(String car_mng_id )
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		int count = 0;
		String query = "";

		query += 	" select a.car_mng_id, a.park	 \n" +		
	    		    " from car_reg a, cont b, \n" +				
					" (select a.* from rent_cont a, (select car_mng_id, max(nvl(deli_dt,decode(use_st,'1','0000000000',deli_plan_dt))) deli_dt from rent_cont where use_st in ('1','2') group by car_mng_id) b where a.use_st in ('1','2') and a.car_mng_id=b.car_mng_id and nvl(a.deli_dt,decode(a.use_st,'1','0000000000',a.deli_plan_dt))=b.deli_dt) i  \n "+
					" where a.car_mng_id = '"+car_mng_id+"' and nvl(b.use_yn,'Y')='Y' and ( b.car_st in ('2','4')  or a.ip_chk  = 'Y' ) \n "+
					" and nvl(a.off_ls,'0')='0' and a.car_mng_id=b.car_mng_id  \n"+			
					" and a.car_mng_id=i.car_mng_id(+)  \n"+
					" and decode(i.use_st, '1','예약','2','배차',decode(a.prepare,'4','-','5','-','6','-','8','-','대기')) != '배차' \n"+
					" "; 
							   	


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery(); 
			ResultSetMetaData rsmd = rs.getMetaData();

			if(rs.next()){	
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ParkIODatabase:getRentReseach2]"+e);
			System.out.println("[ParkIODatabase:getRentReseach2]"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )			rs.close();
                if(pstmt != null)		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}

	
	/**
	 *	마감이 되었는지 여부 2003.4.7.Wed.
	 */
	public String existSave_dt(String br_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String park_in ="";
		if(br_id.equals("1")){
			park_in = "and park_id in ('1') " ;			
		}else if(br_id.equals("3")){
			park_in = "and park_id in ('3', '7', '8') " ;			
		}else if(br_id.equals("4")){
			park_in = "and park_id in ('4', '9') " ;			
		}

		String query = 	"SELECT distinct save_dt FROM park_magam WHERE save_dt=to_char(sysdate,'YYYYMMDD') "+park_in+" ";
		String save_dt = "";

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				save_dt = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ParkIODatabase:existSave_dt]\n"+e);
			System.out.println("[ParkIODatabase:existSave_dt]\n"+query);

	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return save_dt;
		}
	}
		
	/*
	 *	계약현황 마감 프로시져 호출  brid 1:본사,  3:부산지점, 4:대전지점, 5:광주지점, 6:대구지점
	*/
	public String call_p_park_magam()
	{
    	getConnection();
    	
    	String query = "{CALL P_PARK_MAGAM (?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
			cstmt = conn.prepareCall(query);
			
		
			cstmt.registerOutParameter( 1, java.sql.Types.VARCHAR );
			
			cstmt.execute();
			sResult = cstmt.getString(1); // 결과값
			cstmt.close();
		
	
		} catch (SQLException e) {
			System.out.println("[ParkIODatabase:call_p_park_magam]\n"+e);
			System.out.println("[ParkIODatabase:call_p_park_magam]\n"+query);
			e.printStackTrace();
		} finally {
			try{
			     if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}	

	public String call_p_park_magam(String brid)
	{
    	getConnection();
    	
    	String query = "{CALL P_PARK_MAGAM_TEST (?,?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
			cstmt = conn.prepareCall(query);
			
			cstmt.setString(1, brid);
			cstmt.registerOutParameter( 2, java.sql.Types.VARCHAR );			
			cstmt.execute();
			sResult = cstmt.getString(2); // 결과값
			cstmt.close();
		
	
		} catch (SQLException e) {
			System.out.println("[ParkIODatabase:call_p_park_magam]\n"+e);
			System.out.println("[ParkIODatabase:call_p_park_magam]\n"+query);
			e.printStackTrace();
		} finally {
			try{
			     if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}	



	/*
	 *	계약현황 마감 프로시져 호출(부산)
	*/
	public String call_p_park_magam_bs()
	{
    	getConnection();
    	
    	String query = "{CALL P_PARK_MAGAM_BS (?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
			cstmt = conn.prepareCall(query);
			
			cstmt.registerOutParameter( 1, java.sql.Types.VARCHAR );
			
			cstmt.execute();
			sResult = cstmt.getString(1); // 결과값
			cstmt.close();
		
	
		} catch (SQLException e) {
			System.out.println("[ParkIODatabase:call_p_park_magam_bs]\n"+e);
			System.out.println("[ParkIODatabase:call_p_park_magam_bs]\n"+query);
			e.printStackTrace();
		} finally {
			try{
			     if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}	

	/*
	 *	계약현황 마감 프로시져 호출(대전)
	*/
	public String call_p_park_magam_dj()
	{
    	getConnection();
    	
    	String query = "{CALL P_PARK_MAGAM_DJ (?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
			cstmt = conn.prepareCall(query);
			
			cstmt.registerOutParameter( 1, java.sql.Types.VARCHAR );
			
			cstmt.execute();
			sResult = cstmt.getString(1); // 결과값
			cstmt.close();
		
	
		} catch (SQLException e) {
			System.out.println("[ParkIODatabase:call_p_park_magam_dj]\n"+e);
			System.out.println("[ParkIODatabase:call_p_park_magam_dj]\n"+query);
			e.printStackTrace();
		} finally {
			try{
			     if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}	


	/*
	 *	계약현황 마감 프로시져 호출(대전)
	*/
	public String call_p_park_magam_kj()
	{
    	getConnection();
    	
    	String query = "{CALL P_PARK_MAGAM_KJ (?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
			cstmt = conn.prepareCall(query);
			
			cstmt.registerOutParameter( 1, java.sql.Types.VARCHAR );
			
			cstmt.execute();
			sResult = cstmt.getString(1); // 결과값
			cstmt.close();
		
	
		} catch (SQLException e) {
			System.out.println("[ParkIODatabase:call_p_park_magam_kj]\n"+e);
			System.out.println("[ParkIODatabase:call_p_park_magam_kj]\n"+query);
			e.printStackTrace();
		} finally {
			try{
			     if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}


	/*
	 *	계약현황 마감 프로시져 호출(대전)
	*/
	public String call_p_park_magam_dg()
	{
    	getConnection();
    	
    	String query = "{CALL P_PARK_MAGAM_DG (?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
			cstmt = conn.prepareCall(query);
			
			cstmt.registerOutParameter( 1, java.sql.Types.VARCHAR );
			
			cstmt.execute();
			sResult = cstmt.getString(1); // 결과값
			cstmt.close();
		
	
		} catch (SQLException e) {
			System.out.println("[ParkIODatabase:call_p_park_magam_dg]\n"+e);
			System.out.println("[ParkIODatabase:call_p_park_magam_dg]\n"+query);
			e.printStackTrace();
		} finally {
			try{
			     if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}

	/**
	 *	리스트조회
	 */
	public Vector getParkMList(String table_nm, String br_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		String park_in ="";

		if(br_id.equals("1")){
			park_in = "and park_id in ('1') " ;			
		}else if(br_id.equals("3")){
			park_in = "and park_id in ('3', '7', '8') " ;			
		}else if(br_id.equals("4")){
			park_in = "and park_id in ('4', '9') " ;			
		}

		query= " select"+
				" decode(save_dt, '', '', substr(save_dt, 1, 4)||'-'||substr(save_dt, 5, 2)||'-'||substr(save_dt, 7, 2)) save_dt";

		if(table_nm.equals("PARK_MAGAM")) query += " , max(reg_dt) reg_dt ";

		query += " from "+table_nm+" ";
	
		// 날짜 제한 2007년 이전은 안보이게	
		query += " where (save_dt > to_char(sysdate,'YYYY')-2||'1231' or substr(save_dt,5,4)='1231') "+park_in+" ";
	

		query += " group by save_dt order by save_dt desc ";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			while(rs.next())
			{				
				ParkBean sd = new ParkBean();
				sd.setSave_dt(rs.getString(1));		
				if(table_nm.equals("PARK_MAGAM")){
					sd.setReg_dt(rs.getString(2));		
				}
				vt.add(sd);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ParkIODatabase:getParkMList]"+table_nm+e);
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


//당산 ->목동주차장관리 입고차량번호 조회시
	public Vector Park_li_Magam(String save_dt, String t_wd, String br_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String park_in ="";

		if(br_id.equals("1")){
			park_in = "and a.park_id in ('1') " ;			
		}else if(br_id.equals("3")){
			park_in = "and a.park_id in ('3', '7', '8', '17') " ;			
		}else if(br_id.equals("4")){
			park_in = "and a.park_id in ('4', '9', '11') " ;
		}else if(br_id.equals("5")){
			park_in = " and a.park_id in ('12') " ;			
		}else if(br_id.equals("6")){
			park_in = " and a.park_id in ('13','20') " ;			
		}

		
		query =	" SELECT  case when a.io_gubun='3' then '88' else decode(a.car_st, '9', '99', '0' ) end p_sort1,  J.CLS_ST, f.FIRM_NM, h.IN_DT, d.rent_st, d.car_gu, d.rent_start_dt, g.user_nm, \n"+
				" a.*,decode( a.io_gubun, '1', '입고', '2', '출고', '3','매각확정') AS rent_st_nm,   b.car_use, \n"+				
				" decode( a.park_id, '1', '영남주차장', '2', '파천교', '3', '부산지점', '4', '대전지점', '5', '신엠제이모터스', '7', '부산부경', '8', '부산스타', '9', '대전현대', '11','대전금호' , 12, '광주지점', 13, '대구지점', '14','상무현대','16','동화엠파크','17','웰메이드','18','본동자동차','19','타이어휠타운') AS park_nm,   \n"+
				" b.dpm, decode(b.prepare, '2', '매각', '3', '보관', '4', '말소',  '5', '도난', '6', '해지', '8', '수해', '예비' ) prepare,    \n"+
				" k.nm as fuel_kd, \n"+
				" c.colo, decode(a.io_sau, '1','단기대여','2','보험대차','3','지연대차','4','사고대차','5','정비대차','6','업무대여','7','장기대기','8','예약','9','차량정비','10','사고수리','11','임시','12','월렌트') AS rent_st,   \n"+
				" decode(i.use_st, '1','예약','2','배차',decode(b.prepare,'4','-','5','-','6','-','8','-','대기')) car_stat, p.remarks     \n"+
				" FROM PARK_MAGAM a, park_magam_etc p,  car_reg b, car_etc c, cont d, car_nm e, client f, users g, \n"+
				"      (select * from car_call_in where out_dt is null) h, CLS_ETC J,   \n"+
				"      (select a.* from rent_cont a, (select car_mng_id, max(use_st||nvl(deli_dt,decode(rent_st,'11','0000000000',deli_plan_dt))) deli_dt from rent_cont where use_st in ('1','2') group by car_mng_id) b where a.use_st in ('1','2') and a.car_mng_id=b.car_mng_id and a.use_st||nvl(a.deli_dt,decode(a.rent_st,'11','0000000000',a.deli_plan_dt))=b.deli_dt) i, \n"+
				"      (select * from code where c_st='0039') k \n"+				
				"  where a.save_dt = replace('"+save_dt+"','-','')  "+park_in+" \n"+
				"  and a.car_mng_id = b.car_mng_id(+) /* and a.car_mng_id = d.car_mng_id(+) */ and a.rent_l_cd = d.rent_l_cd(+) and d.rent_mng_id = c.rent_mng_id(+)    \n"+
				"  and a.save_dt = p.save_dt(+) and '"+br_id +"'  = p.brid(+) " + 
				"  and d.rent_l_cd = c.rent_l_cd(+) AND c.car_id = e.car_id(+)  AND c.car_seq = e.car_seq(+)   \n"+
				"  and b.car_mng_id=i.car_mng_id(+) and d.client_id = f.client_id(+) and a.mng_id = g.USER_ID(+)  \n"+
				"  and d.RENT_MNG_ID = h.RENT_MNG_ID(+) and d.RENT_L_CD = h.RENT_L_CD(+)and d.RENT_MNG_ID = j.RENT_MNG_ID(+) and d.RENT_L_CD = j.RENT_L_CD(+) \n"+
				"  and b.FUEL_KD=k.nm_cd  \n"+
				" ";
				

				if(!t_wd.equals(""))	query += "  and upper(a.car_no) like upper('%"+t_wd+"%')\n";

				query +=" order by p_sort1 , e.jg_code desc, a.reg_dt , a.car_no, prepare desc, rent_st_nm asc";




		try {
			stmt = conn.createStatement();
		    rs = stmt.executeQuery(query);
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
			stmt.close();

		} catch (SQLException e) {
			System.out.println("[ParkIODatabase:Park_li_Magam]"+e);
			System.out.println("[ParkIODatabase:Park_li_Magam]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}	


/*마감처리 관련 끝*/

	/**
	 *	마감이 되었는지 여부 2003.4.7.Wed.
	 */
	public String GetRentContMngId(String rent_s_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	"SELECT nvl(bus_id, '') mng_id FROM rent_cont WHERE rent_s_cd = '"+ rent_s_cd+ "'";;
		String mng_id = "";

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				mng_id = rs.getString(1)==null?"":rs.getString(1);
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
			return mng_id;
		}
	}

	 public String getNewCarMngId()
	 {
       	getConnection();
		PreparedStatement pstmt = null;  
        ResultSet rs = null;
        String query = "";         
        int count = 0;
        String new_car_id = "";
        			
		query=" select 'XX'|| nvl(ltrim(to_char(to_number(max(substr(CAR_MNG_ID,3,6))+1), '0000')), '0001') from park_io where car_mng_id like 'XX%'";
			
		try{

			pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();
            if(rs.next()){
				new_car_id = rs.getString(1);
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
			return new_car_id;
		}
	}
    
		/**
	 *	차고지별 차량 현황 
	 */
	 
	public Vector getParkRealList(String br_id, String gubun1, String start_dt, String end_dt, String s_cc,  int s_year, String s_kd, String brid, String t_wd, String sort_gubun, String asc )
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String p_nm = "";
		String park_in = "";


		if(brid.equals("1")){
			p_nm = "영남";
			park_in = " and a.park_id in ('1') " ;			
		}else if(brid.equals("3")){
			p_nm = "부산";
			park_in = " and a.park_id in ('3', '7', '8', '17') " ;			
		}else if(brid.equals("4")){
			p_nm = "대전";
			park_in = " and a.park_id in ('4', '9', '11') " ;			
		}else if(brid.equals("5")){
			p_nm = "광주";
			park_in = " and a.park_id in ('12') " ;			
		}else if(brid.equals("6")){
			p_nm = "대구";
			park_in = " and a.park_id in ('13','20') " ;			

		}

                		  
           	query =	" SELECT case when a.io_gubun='3' then '88' else decode(a.car_st, '9', '77', '0' ) end p_sort1,k.imgfile1, f.FIRM_NM,  d.rent_st, d.car_gu, d.rent_start_dt, g.user_nm , \n"+
					"        a.*,decode( a.io_gubun, '1', '입고', '2', '출고', '3','매각확정') AS rent_st_nm,   b.car_use ,\n"+
					" decode(a.park_id, 1, '영남주차장', 2, '파천교', 3, '부산지점', 4, '대전지점', 5, '신엠제이모터스', 7, '부산부경', 8, '부산조양', 9, '대전현대', 10, '오토크린', 11, '대전금호', 12, '광주지점', 13, '대구지점', '14','상무현대','16','동화엠파크','17','웰메이드','18','본동자동차','19','타이어휠타운' ) AS park_nm, \n "+
					"        b.dpm, decode(b.prepare, '2', '매각', '3', '보관', '4', '말소',  '5', '도난', '6', '해지', '8', '수해', '예비' ) prepare,    \n"+
					"        m.nm as fuel_kd, \n"+
					"        c.colo, decode(a.io_sau, '1','단기대여','2','보험대차','3','지연대차','4','사고대차','5','정비대차','6','업무대여','7','장기대기','8','예약','9','차량정비','10','사고수리','11','임시','12','월렌트') AS rent_st,   \n"+
					"        decode(i.use_st, '1','예약','2','배차',decode(b.prepare,'4','-','5','-','6','-','8','-','대기')) car_stat , i.rent_s_cd, b.init_reg_dt, j.cls_st, j.cls_dt, h.in_dt , k.img_dt, b.secondhand  \n"+
					" FROM   PARK_CONDITION a, car_reg b, car_etc c, cont d, car_nm e, client f, users g, CLS_ETC j,( select * from car_call_in where out_dt is null) h,  \n"+
					"        (select a.* "+
					"                from rent_cont a, (select car_mng_id, max(use_st||nvl(deli_dt,decode(rent_st,'11','0000000000',deli_plan_dt))) deli_dt from rent_cont where use_st in ('1','2') group by car_mng_id) b \n"+
					"         where  a.use_st in ('1','2') and a.car_mng_id=b.car_mng_id and a.use_st||nvl(a.deli_dt,decode(a.rent_st,'11','0000000000',a.deli_plan_dt))=b.deli_dt) i , "+
					"        APPRSL k,  \n"+
					"        (select * from code where c_st='0039') m \n"+
					" where  a.car_mng_id = b.car_mng_id(+) and a.rent_l_cd = d.rent_l_cd(+) and d.rent_mng_id = c.rent_mng_id(+)    \n"+
					"        AND d.rent_mng_id=j.rent_mng_id(+) AND d.rent_l_cd=j.rent_l_cd(+) and d.RENT_MNG_ID = h.RENT_MNG_ID(+) and d.RENT_L_CD = h.RENT_L_CD(+) \n"+
					"        and d.rent_l_cd = c.rent_l_cd(+) AND c.car_id = e.car_id(+)  AND c.car_seq = e.car_seq(+)   AND b.CAR_MNG_ID =k.car_mng_id (+)    \n"+
					"        and b.car_mng_id=i.car_mng_id(+) and d.client_id = f.client_id(+) and a.mng_id = g.USER_ID(+)  "+park_in+" \n"+
					"        and b.FUEL_KD=m.nm_cd ";
					    

  		if(s_kd.equals("1"))	query += " and upper(a.car_no) like upper('%"+t_wd+"%')\n";		
		if(s_kd.equals("4"))	query += " and upper(a.car_nm) like ('%"+t_wd+"%')\n";			

		if(!gubun1.equals("")){
			query += " and a.area = '"+gubun1+"' \n";
		}
		
		if(sort_gubun.equals("5"))	query += "  order by p_sort1 , e.jg_code desc, a.reg_dt, a.car_no, prepare desc, rent_st_nm asc";	 
		
		
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
			System.out.println("[ParkIODatabase:getParkRealList]"+e);
			System.out.println("[ParkIODatabase:getParkRealList]"+query);
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
	 *	차고지별 차량 현황 
	 */
	 
	public Vector getParkRealList(String br_id, String gubun, String gubun1, String start_dt, String end_dt, String s_cc,  int s_year, String s_kd, String brid, String t_wd, String sort_gubun, String asc )
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String p_nm = "";
		String park_in = "";


		if(brid.equals("1")){
			//p_nm = "목동";
			p_nm = "영남";
			park_in = " and a.park_id in ('1') " ;			
		}else if(brid.equals("3")){
			p_nm = "부산";
			park_in = " and a.park_id in ('7', '8') " ;			
		}else if(brid.equals("4")){
			p_nm = "대전";
			park_in = " and a.park_id in ('4', '9', '11') " ;			
		}else if(brid.equals("5")){
			p_nm = "광주";
			park_in = " and a.park_id in ('12') " ;			
		}else if(brid.equals("6")){
			p_nm = "대구";
			park_in = " and a.park_id in ('13','20') " ;			
		}else if(brid.equals("7")){
			p_nm = "대구";
			park_in = " and a.park_id in ('2','5','10','14','14','16','18','19','21') " ;	

		}

           	query =	" SELECT case when a.io_gubun='3' then '88' else decode(a.car_st, '9', '77', '0' ) end p_sort1,k.imgfile1, f.FIRM_NM,  d.rent_st, d.car_gu, d.rent_start_dt, g.user_nm , \n"+
					"        to_char(sysdate,'YYYYMMDD') - TO_CHAR(TRUNC(TO_DATE(a.io_dt,'YYYYMMDD'), 'DY') +6 , 'YYYYMMDD') bb, a.*,decode( a.io_gubun, '1', '입고', '2', '출고', '3','매각확정') AS rent_st_nm,   b.car_use ,\n"+
					"        c2.nm park_nm, \n "+
					"        b.dpm, decode(b.prepare, '2', '매각', '3', '보관', '4', '말소',  '5', '도난', '6', '해지', '8', '수해', '예비' ) prepare,    \n"+
					"        c3.nm as fuel_kd,   \n"+
					"        c.colo, decode(a.io_sau, '1','단기대여','2','보험대차','3','지연대차','4','사고대차','5','정비대차','6','업무대여','7','장기대기','8','예약','9','차량정비','10','사고수리','11','임시','12','월렌트') AS rent_st,   \n"+
					"        decode(i.use_st, '1','예약','2','배차',decode(b.prepare,'4','-','5','-','6','-','8','-','대기')) car_stat , i.rent_s_cd, REGEXP_REPLACE(b.INIT_REG_DT, '(....)(..)(..)', '\\1-\\2-\\3') INIT_REG_DT, j.cls_st, j.cls_dt, h.in_dt , k.img_dt, b.secondhand, nvl(h2.pic_cnt,0) as pic_cnt, pic_reg_dt, "+
					"		 d.rent_mng_id  \n"+
					" FROM   PARK_CONDITION a, car_reg b, car_etc c, cont d, car_nm e, client f, users g, CLS_ETC j,( select * from car_call_in where out_dt is null) h,  \n"+
					"        (select a.* "+
					"                from rent_cont a, (select car_mng_id, max(use_st||nvl(deli_dt,decode(rent_st,'11','0000000000',deli_plan_dt))) deli_dt from rent_cont where use_st in ('1','2') group by car_mng_id) b \n"+
					"         where  a.use_st in ('1','2') and a.car_mng_id=b.car_mng_id and a.use_st||nvl(a.deli_dt,decode(a.rent_st,'11','0000000000',a.deli_plan_dt))=b.deli_dt) i , "+
					"        APPRSL k, \n"+
					"        (select * from code where c_st='0027') c2, \n"+
					"        (select * from code where c_st='0039') c3, \n"+
					"        (select SUBSTR(content_seq,1,6) car_mng_id, count(0) pic_cnt, TO_CHAR(MAX(reg_date),'YYYYMMDD') pic_reg_dt from ACAR_ATTACH_FILE where ISDELETED='N' and content_code='APPRSL' AND TO_CHAR(REG_DATE,'YYYYMMDD') >= TO_CHAR(add_months(sysdate, -6),'YYYYMMDD') group by SUBSTR(content_seq,1,6)) h2 \n"+
					" where  a.car_mng_id = b.car_mng_id(+) and a.rent_l_cd = d.rent_l_cd(+) and d.rent_mng_id = c.rent_mng_id(+)    \n"+
					"        AND d.rent_mng_id=j.rent_mng_id(+) AND d.rent_l_cd=j.rent_l_cd(+) and d.RENT_MNG_ID = h.RENT_MNG_ID(+) and d.RENT_L_CD = h.RENT_L_CD(+) \n"+
					"        and d.rent_l_cd = c.rent_l_cd(+) AND c.car_id = e.car_id(+)  AND c.car_seq = e.car_seq(+)   AND b.CAR_MNG_ID =k.car_mng_id (+)    \n"+
					"        and b.car_mng_id=i.car_mng_id(+) and b.car_mng_id=h2.car_mng_id(+) and d.client_id = f.client_id(+) and a.mng_id = g.USER_ID(+) 	\n"+
					"        and trim(a.park_id)=c2.nm_cd and b.FUEL_KD=c3.nm_cd  "+park_in+" \n";
					    

  		if(s_kd.equals("1"))	query += " and upper(a.car_no) like upper('%"+t_wd+"%')\n";		
		if(s_kd.equals("4"))	query += " and upper(a.car_nm) like ('%"+t_wd+"%')\n";			

		if(!gubun1.equals("")){
			query += " and a.area = '"+gubun1+"' \n";
		}
		
		if(gubun.equals("Y")){
			query += " and f.FIRM_NM <> '(주)아마존카' ";
		}

		if(sort_gubun.equals("5"))	query += "  order by p_sort1 , e.jg_code desc, a.reg_dt, a.car_no, prepare desc, rent_st_nm asc";	 
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
			System.out.println("[ParkIODatabase:getParkRealList]"+e);
			System.out.println("[ParkIODatabase:getParkRealList]"+query);
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
  *  차고지별 차량 현황 (모바일, /sh_photo)
  */
  
    public Vector getParkRealList_mobile(String br_id, String gubun, String gubun1, String start_dt, String end_dt, String s_cc,  int s_year, String s_kd, String brid, String t_wd, String sort_gubun, String asc, String picFlag)
    {
        getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Vector vt = new Vector();
        String query = "";
        String p_nm = "";
        String park_in = "";


        if(brid.equals("1")){
            //p_nm = "목동";
            p_nm = "영남";
            park_in = " and a.park_id in ('1') " ;          
        }else if(brid.equals("3")){
            p_nm = "부산";
            park_in = " and a.park_id in ('3', '7', '8', '17') " ;            
        }else if(brid.equals("4")){
            p_nm = "대전";
            park_in = " and a.park_id in ('4', '9', '11') " ;           
        }else if(brid.equals("5")){
            p_nm = "광주";
            park_in = " and a.park_id in ('12') " ;         
        }else if(brid.equals("6")){
            p_nm = "대구";
            park_in = " and a.park_id in ('13','20') " ;         

        }

            query = " SELECT case when a.io_gubun='3' then '88' else decode(a.car_st, '9', '77', '0' ) end p_sort1,k.imgfile1, f.FIRM_NM,  d.rent_st, d.car_gu, d.rent_start_dt, g.user_nm , \n"+
                    "        to_char(sysdate,'YYYYMMDD') - TO_CHAR(TRUNC(TO_DATE(a.io_dt,'YYYYMMDD'), 'DY') +6 , 'YYYYMMDD') bb, a.*,decode( a.io_gubun, '1', '입고', '2', '출고', '3','매각확정') AS rent_st_nm,   b.car_use ,\n"+
                    "        c2.nm as park_nm, \n "+
                    "        b.dpm, decode(b.prepare, '2', '매각', '3', '보관', '4', '말소',  '5', '도난', '6', '해지', '8', '수해', '예비' ) prepare,    \n"+
                    "        c3.nm as fuel_kd,   \n"+
                    "        c.colo, decode(a.io_sau, '1','단기대여','2','보험대차','3','지연대차','4','사고대차','5','정비대차','6','업무대여','7','장기대기','8','예약','9','차량정비','10','사고수리','11','임시','12','월렌트') AS rent_st,   \n"+
                    "        decode(i.use_st, '1','예약','2','배차',decode(b.prepare,'4','-','5','-','6','-','8','-','대기')) car_stat , i.rent_s_cd, b.init_reg_dt, j.cls_st, j.cls_dt, h.in_dt , k.img_dt, b.secondhand, nvl(h2.pic_cnt,0) as pic_cnt, pic_reg_dt  \n"+
                    " FROM   PARK_CONDITION a, car_reg b, car_etc c, cont d, car_nm e, client f, users g, CLS_ETC j,( select * from car_call_in where out_dt is null) h,  \n"+
                    "        (select a.* "+
                    "                from rent_cont a, (select car_mng_id, max(use_st||nvl(deli_dt,decode(rent_st,'11','0000000000',deli_plan_dt))) deli_dt from rent_cont where use_st in ('1','2') group by car_mng_id) b \n"+
                    "         where  a.use_st in ('1','2') and a.car_mng_id=b.car_mng_id and a.use_st||nvl(a.deli_dt,decode(a.rent_st,'11','0000000000',a.deli_plan_dt))=b.deli_dt) i , "+
                    "        APPRSL k,  \n"+
					"        (select * from code where c_st='0027') c2, \n"+
					"        (select * from code where c_st='0039') c3, \n"+                    
                    "        (select SUBSTR(content_seq,1,6) car_mng_id, count(0) pic_cnt, TO_CHAR(MAX(reg_date),'YYYYMMDD') pic_reg_dt from ACAR_ATTACH_FILE where ISDELETED='N' and content_code='APPRSL' AND TO_CHAR(REG_DATE,'YYYYMMDD') >= TO_CHAR(add_months(sysdate, -6),'YYYYMMDD') group by SUBSTR(content_seq,1,6)) h2 \n"+
                    " where  a.car_mng_id = b.car_mng_id(+) /* and a.car_mng_id = d.car_mng_id(+) */ and a.rent_l_cd = d.rent_l_cd(+) and d.rent_mng_id = c.rent_mng_id(+)    \n"+
                    "        AND d.rent_mng_id=j.rent_mng_id(+) AND d.rent_l_cd=j.rent_l_cd(+) and d.RENT_MNG_ID = h.RENT_MNG_ID(+) and d.RENT_L_CD = h.RENT_L_CD(+) \n"+
                    "        and d.rent_l_cd = c.rent_l_cd(+) AND c.car_id = e.car_id(+)  AND c.car_seq = e.car_seq(+)   AND b.CAR_MNG_ID =k.car_mng_id (+)    \n"+
                    "        and b.car_mng_id=i.car_mng_id(+) and b.car_mng_id=h2.car_mng_id(+) and d.client_id = f.client_id(+) and a.mng_id = g.USER_ID(+) \n"+
                    "        and trim(a.park_id)=c2.nm_cd and b.FUEL_KD=c3.nm_cd "+park_in+" \n ";
                        

        if(s_kd.equals("1"))    query += " and upper(a.car_no) like upper('%"+t_wd+"%')\n";     
        if(s_kd.equals("4"))    query += " and upper(a.car_nm) like ('%"+t_wd+"%')\n";          

        if(!gubun1.equals("")){
            query += " and a.area = '"+gubun1+"' \n";
        }
        
        if(gubun.equals("Y")){
            query += " and f.FIRM_NM <> '(주)아마존카' ";
        }
        
        if(picFlag.equals("0")){
            query += " and (pic_reg_dt < TO_CHAR(add_months(sysdate, -6),'YYYYMMDD')  or pic_reg_dt IS NULL) ";
        }else{
            query += " and (pic_reg_dt >= TO_CHAR(add_months(sysdate, -6),'YYYYMMDD') ) ";
        }
        
        if(sort_gubun.equals("5"))  query += "  order by p_sort1 , e.jg_code desc, a.reg_dt, a.car_no, prepare desc, rent_st_nm asc";    
        

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
            System.out.println("[ParkIODatabase:getParkRealList]"+e);
            System.out.println("[ParkIODatabase:getParkRealList]"+query);
            e.printStackTrace();
        } finally {
            try{
                if(rs != null )     rs.close();
                if(pstmt != null)   pstmt.close();
            }catch(Exception ignore){}
            closeConnection();
            return vt;
        }
    }   
	
	//PARK CONDITION에서 데이터 삭제
	public int DeleteParkConditon(String car_mng_id, String park_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count2 = 0;
		String query = "";

		query = " delete PARK_CONDITION  "+
				" where car_mng_id='"+car_mng_id + "'";

		try 
		{			
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			count2 = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
		} catch (SQLException e) {
			System.out.println("[ParkIODatabase:DeleteParkConditon]\n"+e);
			System.out.println("[ParkIODatabase:DeleteParkConditon]\n"+query);
	  		e.printStackTrace();
			conn.rollback();
	  	} catch (Exception e) {
		  	System.out.println("[ParkIODatabase:DeleteParkConditon]\n"+e);
			System.out.println("[ParkIODatabase:DeleteParkConditon]\n"+query);
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count2;
		}
	}
	
	
	//PARK CONDITION에  매각확정 표시
	public int updateParkConditionAuction(String car_mng_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count2 = 0;
		String query = "";

		query = " update PARK_CONDITION set io_gubun = '3'  "+
				" where car_mng_id='"+car_mng_id+"' ";

		try 
		{			
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			count2 = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
		} catch (SQLException e) {
			System.out.println("[ParkIODatabase:updateParkConditionAuction]\n"+e);
			System.out.println("[ParkIODatabase:updateParkConditionAuction]\n"+query);
	  		e.printStackTrace();
			conn.rollback();
	  	} catch (Exception e) {
		  	System.out.println("[ParkIODatabase:updateParkConditionAuction]\n"+e);
			System.out.println("[ParkIODatabase:updateParkConditionAuction]\n"+query);
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count2;
		}
	}
		
	/**
	 *	real park 입력하기
	 */

	public int insertParkCondition(ParkBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";
	 	
		query = " insert into park_condition \n"+
				" (RENT_L_CD, CAR_MNG_ID, CAR_NO, CAR_NM,   \n"+  //4
				" PARK_ID, REG_ID, IO_GUBUN, CAR_ST, CAR_KM, IO_DT, IO_SAU, MNG_ID, \n"+  //8
				" DRIVER_NM, USE_YN, AREA, FIRM_NM, USER_NM, CAR_KEY, CAR_KEY_CAU , REG_DT "+  //7
				" ) values ("+
				" ?, ?, ?, ?, "+
				" ?, ?, ?, ?, ?, replace(?, '-', ''), ?, ?, "+
				" ?, ?, ?, ?, ?, ?, ?, to_char(sysdate,'YYYYMMddhh24miss')	 "+
				" )";
		

		try 
		{			
			conn.setAutoCommit(false);
				
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getRent_l_cd());
			pstmt.setString(2, bean.getCar_mng_id());
			pstmt.setString(3, bean.getCar_no());
			pstmt.setString(4, bean.getCar_nm());
					
			pstmt.setString(5, bean.getPark_id());
			pstmt.setString(6, bean.getReg_id());
			pstmt.setString(7, bean.getIo_gubun());
			pstmt.setString(8, bean.getCar_st());
			pstmt.setInt(9, bean.getCar_km());
			pstmt.setString(10, bean.getIo_dt());
			pstmt.setString(11, bean.getIo_sau());
			pstmt.setString(12, bean.getMng_id());					
				
			pstmt.setString(13, bean.getDriver_nm());
			pstmt.setString(14, bean.getUse_yn());
			pstmt.setString(15, bean.getArea());			
			pstmt.setString(16, bean.getFirm_nm());
			pstmt.setString(17, bean.getUser_nm());
			pstmt.setString(18, bean.getCar_key());
			pstmt.setString(19, bean.getCar_key_cau());
								
			count = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
	

		} catch (SQLException e) {
			System.out.println("[ParkIODatabase:insertParkCondition]\n"+e);
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
	 *	입고입력시 park_condition 중복 마감이 되었는지 여부 2003.4.7.Wed.
	 */
	public int chkParkCondition(String car_mng_id, String park_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	"SELECT count(0)  FROM park_condition  where car_mng_id='"+car_mng_id+"' and park_id = '"+park_id + "' ";
		int  cnt = 0;

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				cnt = rs.getInt(1);
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
			return cnt;
		}
	}

	
	/**
	 *	max 마감일자
	 */
	public String getParkSaveDt(String br_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		String park_in ="";
		String save_dt = "";

		if(br_id.equals("1")){
			park_in = "where park_id in ('1') " ;			
		}else if(br_id.equals("3")){
			park_in = " where park_id in ('3', '7', '8') " ;			
		}else if(br_id.equals("4")){
			park_in = " where park_id in ('4', '9') " ;			
		}

		query= " select"+
				" max( decode(save_dt, '', '', substr(save_dt, 1, 4)||'-'||substr(save_dt, 5, 2)||'-'||substr(save_dt, 7, 2)) ) save_dt" +
				 " from PARK_MAGAM   "+park_in+" ";	

		try {
			pstmt = conn.prepareStatement(query);
	    		rs = pstmt.executeQuery();
			while(rs.next())
			{
				save_dt = rs.getString(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ParkIODatabase:getParkSaveDt]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return save_dt;
		}
	}
	
	//마감후 배차된 차량 정리
	public Vector ParkRentCont(String save_dt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String park_in ="";


/*
	query =	" select a.car_mng_id, p.car_mng_id, a.car_no, a.car_nm, i.mng_id, r.user_m_tel, r.user_nm \n" +	
			"  		     from car_reg a, cont b, 		\n" +	
			"				 (select a.* from rent_cont a, (select car_mng_id, max(nvl(deli_dt,decode(use_st,'1','0000000000',deli_plan_dt))) deli_dt from rent_cont where use_st in ('1','2') group by car_mng_id) b where a.use_st in ('1','2') and a.car_mng_id=b.car_mng_id and nvl(a.deli_dt,decode(a.use_st,'1','0000000000',a.deli_plan_dt))=b.deli_dt) i , \n" +	
			"			     (select car_mng_id from park_condition where park_id = '1')  p , users r \n" +	
		          "      where nvl(b.use_yn,'Y')='Y' and ( b.car_st='2'  or a.ip_chk  = 'Y' ) \n" +	
			"				 and nvl(a.off_ls,'0')='0' and a.car_mng_id=b.car_mng_id   	\n" +		
			"				 and a.car_mng_id=i.car_mng_id(+) AND i.mng_id = r.user_id(+)  \n" +	
			"				 and decode(i.use_st, '1','예약','2','배차',decode(a.prepare,'4','-','5','-','6','-','8','-','대기')) != '배차'  \n" +	
		          "        and a.park = '1' \n" +	
		           "         and a.car_mng_id=p.car_mng_id(+)\n" +	
	  		"   and p.car_mng_id is null ";
*/
		//예약시 관리담당자 없는 경우 cont의 담당자로 
	query =	" select a.*, u.user_m_tel, u.user_nm from (		\n" +			 
			" select a.car_mng_id, a.car_no, a.car_nm, nvl(i.mng_id, b.mng_id) mng_id  	\n" +	
			"			  		     from car_reg a, cont b, 		\n" +			
			"							 (select a.* from rent_cont a, (select car_mng_id, max(nvl(deli_dt,decode(use_st,'1','0000000000',deli_plan_dt))) deli_dt from rent_cont where use_st in ('1','2') group by car_mng_id) b where a.use_st in ('1','2') and a.car_mng_id=b.car_mng_id and nvl(a.deli_dt,decode(a.use_st,'1','0000000000',a.deli_plan_dt))=b.deli_dt) i , \n" +
			"						     (select car_mng_id from park_condition where park_id = '1')  p \n" +
			"		                where nvl(b.use_yn,'Y')='Y' and ( b.car_st='2'  or a.ip_chk  = 'Y' ) \n" +
			"							 and nvl(a.off_ls,'0')='0' and a.car_mng_id=b.car_mng_id  	\n" +
			"							 and a.car_mng_id=i.car_mng_id(+)    \n" +                     
			"							 and decode(i.use_st, '1','예약','2','배차',decode(a.prepare,'4','-','5','-','6','-','8','-','대기')) != '배차'  \n" +
			"		                     and a.park = '1' \n" +	
			"		                    and a.car_mng_id=p.car_mng_id(+) \n" +
			"	  		              and p.car_mng_id is null  ) a, users u  \n" +
			"     where a.mng_id = u.user_id(+)    ";     
			               
			               

		try {
			stmt = conn.createStatement();
		    rs = stmt.executeQuery(query);
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
			stmt.close();

		} catch (SQLException e) {
			System.out.println("[ParkIODatabase:ParkRentCont(]"+e);
			System.out.println("[ParkIODatabase:ParkRentCont(]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}	
	
		//PARK CONDITION에  매각확정 표시
	public int updateParkEtc(String save_dt, String brid, String remarks)
	{
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
			
		int count = 0;
		int cnt = 0;
		String query = "";
		
		String query1 = "";
		String query2 = "";				
			
		query = " select count(0) from park_magam_etc where save_dt = replace(?, '-', '') and brid = ? ";
		
		query1 = " insert  into PARK_MAGAM_ETC (save_dt, brid, remarks )   "+
				" values (replace(?,'-', ''),  ?, ? ) ";	

		query2 = " update PARK_MAGAM_ETC set remarks=?  "+
				" where save_dt =replace(?, '-', '') and brid = ? ";


		try 
		{			
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, save_dt);
			pstmt.setString(2, brid);
			rs = pstmt.executeQuery();
			while(rs.next())
			{
				cnt = rs.getInt(1);
			}
			rs.close();
           	pstmt.close();
           		 
			if ( cnt > 0) {
				pstmt1 = conn.prepareStatement(query2);
				pstmt1.setString(1, remarks);
				pstmt1.setString(2, save_dt);
				pstmt1.setString(3, brid);
				
			} else {
				pstmt1 = conn.prepareStatement(query1);
				pstmt1.setString(1, save_dt);
				pstmt1.setString(2, brid);
				pstmt1.setString(3, remarks);
			}	
			
			count = pstmt1.executeUpdate();	
			pstmt1.close();

			conn.commit();
					    
		} catch (SQLException e) {
			System.out.println("[ParkIODatabase:updateParkEtc]\n"+e);
	  		e.printStackTrace();
	  		count = 0;
			conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(rs != null) rs.close();
                if(pstmt != null) 	pstmt.close();
				if(pstmt1 != null)	pstmt1.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}
	
		
	/**
	 *	park_magam_etc
	 	 */
	public String getParkEtcRemarks(String save_dt, String brid)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String remarks = "";
	
		query= " select nvl(remarks, ' ')  from PARK_MAGAM_ETC  where save_dt =  replace(?, '-', '') and brid = ? ";	

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, save_dt);
			pstmt.setString(2, brid);
    		rs = pstmt.executeQuery();
			while(rs.next())
			{
				remarks = rs.getString(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ParkIODatabase:getParkEtcRemarks]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return remarks;
		}
	}
	
	/**
	 *	차량정보
	 */
	public Hashtable getParkCarKeyInfo(String c_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select \n"+
				" a.car_mng_id, a.car_no,  a.car_key, a.car_key_cau \n"+
				" from PARK_CONDITION a \n"+
				" where  \n"+
					" a.car_mng_id='"+c_id+"'";
					


		try {
			pstmt = conn.prepareStatement(query);
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
			System.out.println("[ParkIODatabase:getParkCarKeyInfo]"+e);
			System.out.println("[ParkIODatabase:getParkCarKeyInfo]"+query);
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


	//PARK CONDITION에  매각확정 표시
	public int updateParkCarKey(String car_mng_id, String car_key, String car_key_cau)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count2 = 0;
		String query = "";

		query = " update PARK_CONDITION set  car_key = '"+ car_key + "', car_key_cau = '" + car_key_cau + "'  "+
				" where car_mng_id='"+car_mng_id+"' ";

		try 
		{			
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			count2 = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
		} catch (SQLException e) {
			System.out.println("[ParkIODatabase:updateParkCarKey]\n"+e);
			System.out.println("[ParkIODatabase:updateParkCarKey]\n"+query);
	  		e.printStackTrace();
			conn.rollback();
	  	} catch (Exception e) {
		  	System.out.println("[ParkIODatabase:updateParkCarKey]\n"+e);
			System.out.println("[ParkIODatabase:updateParkCarKey]\n"+query);
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count2;
		}
	}



	/**
	 *	차량정보- 구역
	 */
	public Hashtable getParkAreaInfo(String c_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select \n"+
				" a.car_mng_id, a.car_no,  a.area \n"+
				" from PARK_CONDITION a \n"+
				" where  \n"+
				" a.car_mng_id='"+c_id+"'";
					


		try {
			pstmt = conn.prepareStatement(query);
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
			System.out.println("[ParkIODatabase:getParkAreaInfo]"+e);
			System.out.println("[ParkIODatabase:getParkAreaInfo]"+query);
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



	//주차구역 수정
	public int updateParkArea(String car_mng_id, String area)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count2 = 0;
		String query = "";

		query = " update PARK_CONDITION set  area = '"+ area + "'  "+
				" where car_mng_id='"+car_mng_id+"' ";

		try 
		{			
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			count2 = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
		} catch (SQLException e) {
			System.out.println("[ParkIODatabase:updateParkArea]\n"+e);
			System.out.println("[ParkIODatabase:updateParkArea]\n"+query);
	  		e.printStackTrace();
			conn.rollback();
	  	} catch (Exception e) {
		  	System.out.println("[ParkIODatabase:updateParkArea]\n"+e);
			System.out.println("[ParkIODatabase:updateParkArea]\n"+query);
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count2;
		}
	}

//-------------------------------- 출고(배차)증명서 발급

	/**
	 *	차고지별 차량 현황 
	 */
	public Vector getCaroutPrintlist(String br_id, String gubun1, String start_dt, String end_dt, String s_cc,  int s_year, String s_kd, String t_wd, String sort_gubun, String asc )
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select  t.car_use, t.brch_id, t.p_p, t.uu_st, t.rr_st, t.brch_nm, t.car_mng_id, t.car_no, t.car_nm, t.init_reg_dt, "+
				" t.car_st, t.rent_dt, t.rent_start_dt, t.rent_end_dt, t.deli_plan_dt, t.ret_plan_dt, t.bus_nm, t.fuel_kd, t.dpm, t.taking_p, "+
			    " t.colo, t.use_st, t.rent_st, t.rent_s_cd, t.first_car_no, t.prepare, t.park, t.park_cont, t.car_stat, "+
			    " t.rent_st_nm, t.cust_nm, t.firm_nm, decode(t.car_stat, '배차', decode(t.rent_st_nm,'업무', t.cust_nm, t.firm_nm), t.park ) as park_nm \n"+
			    " from (  \n"+
				"        select decode(nvl(q.mng_br_id,b.brch_id),'S1',1,'K1',1,'B1',2,'N1',2,'D1',3) brch_id, decode(nvl(a.prepare,'1'),'2','2','5','3','4','4','8','5','1') p_p, \n"+
				"        decode(i.use_st,'1','1','2','2','0') as uu_st, decode(i.use_st,'1',i.rent_st,'2',decode(i.rent_st,'6','0.1','7','0.2','8','0.3',i.rent_st),'0') rr_st,  \n"+
				"        decode(nvl(q.mng_br_id,b.brch_id),'S1','본사','K1','본사','B1','부산지점','N1','부산지점''D1','대전지점','S2','강남지점', 'J1', '광주지점', 'G1', '대구지점') brch_nm, a.car_mng_id, a.car_no, a.car_nm, a.init_reg_dt, b.car_st, b.rent_dt, i.rent_start_dt, i.rent_end_dt, i.deli_plan_dt, i.ret_plan_dt, p.user_nm as bus_nm, \n"+
				"        d.nm as fuel_kd,  \n"+
				"        a.dpm, a.car_use, a.taking_p, c.colo,  i.use_st, i.rent_st, i.rent_s_cd, a.first_car_no, \n"+
				"        decode(a.prepare, '2','매각', '3','보관', '4','말소', '5','도난', '6','해지', '8','수해', '예비') prepare, " +
				"        decode(a.park, '1','영남주차장', '2','정일현대', '3','부산지점', '4','대전지점', '5','신엠제이모터스', '7','부산부경','8','부산스타','9','대전현대','10','오토크린', '11','대전금호', '12', '광주지점', '13', '대구지점', '14','상무현대','16','동화엠파크','17','웰메이드','18','본동자동차','19','타이어휠타운', substr(a.park_cont,1,5)) park, a.park_cont,  \n"+
				"        decode(i.use_st, '1','예약','2','배차',decode(a.prepare,'4','-','5','-','6','-','8','-','대기')) car_stat,  \n"+
				"        decode(a.prepare,'4','-','5','-','6','-','8','-', decode(i.rent_st,'1','단기','2','정비','3','사고','9','보험','10','지연','4','업무','5','업무','6','정비','7','정비','8','수리','11','대기')) rent_st_nm,  \n"+
				"        decode(i.cust_st, '', '조성희', '1',l.client_nm, '4',n.user_nm, m.cust_nm) cust_nm,  \n"+
				"        decode(i.cust_st, '', '아마존카', '1',replace(l.firm_nm,'(주)',''), '4','아마존카', m.firm_nm) firm_nm \n"+
				"        from   car_reg a, cont b, car_etc c, client l, users n, rent_cust m, users p, cont_etc q, \n"+
				"               (select a.* from rent_cont a, (select car_mng_id, max(nvl(deli_dt,decode(use_st,'1','0000000000',deli_plan_dt))) deli_dt from rent_cont where use_st in ('1','2') group by car_mng_id) b where a.use_st in ('1','2') and a.car_mng_id=b.car_mng_id and nvl(a.deli_dt,decode(a.use_st,'1','0000000000',a.deli_plan_dt))=b.deli_dt) i,  \n "+
				"               (select car_mng_id, count(0) as a_cnt from accident where accid_st='6' group by car_mng_id) k,  \n"+
				"               (select * from code where c_st='0039') d "+
				"        where nvl(b.use_yn,'Y')='Y' and ( b.car_st='2'  or a.ip_chk  = 'Y' ) \n "+
				"        and nvl(a.off_ls,'0')='0' and a.car_mng_id=b.car_mng_id  \n"+
				"        and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd  \n"+
				"        and i.cust_id=l.client_id(+) and i.cust_id=n.user_id(+) and i.cust_id=m.cust_id(+)  \n"+
				"        and a.car_mng_id=i.car_mng_id(+)  \n"+
				"        and a.car_mng_id=k.car_mng_id(+) and i.bus_id=p.user_id(+) \n"+
				"        and b.rent_mng_id=q.rent_mng_id(+) and b.rent_l_cd=q.rent_l_cd(+) \n"+
				"        and a.fuel_kd=d.nm_cd "+
				"      ) t \n"+				
				" where (decode(t.car_stat, '배차', decode(t.rent_st_nm,'업무', t.cust_nm, t.firm_nm), t.park ) like '%영남%' OR decode(t.car_stat, '배차', decode(t.rent_st_nm,'업무', t.cust_nm, t.firm_nm), t.park ) like '%부산%' OR decode(t.car_stat, '배차', decode(t.rent_st_nm,'업무', t.cust_nm, t.firm_nm), t.park ) like '%대전%') \n"+
				" ";


		if(s_kd.equals("1"))	query += " and upper(t.car_no)||upper(t.first_car_no) like upper('%"+t_wd+"%')\n";		
		if(s_kd.equals("2"))	query += " and t.init_reg_dt like '"+t_wd+"%'\n";
		if(s_kd.equals("4"))	query += " and upper(t.car_nm) like upper('%"+t_wd+"%')\n";			
		if(s_kd.equals("5"))	query += " and decode(t.car_stat, '배차', decode(t.rent_st_nm,'업무', t.cust_nm, t.firm_nm), t.park ) like '%"+t_wd+"%'\n";		

			if(gubun1.equals("1"))		query += " and t.car_use = '1' ";
  			if(gubun1.equals("2"))		query += " and t.car_use = '2' ";
			if(gubun1.equals("11"))		query += " and t.car_st = '2' ";
  			if(gubun1.equals("12"))		query += " and t.car_st in ('1','3') ";
  			if(gubun1.equals("3"))		query += " and t.taking_p = 5 ";
  			if(gubun1.equals("4"))		query += " and t.taking_p = 7 ";
			if(gubun1.equals("5"))		query += " and t.taking_p >= 9 ";
  			if(gubun1.equals("6"))		query += " and t.taking_p <= 3 ";
  			if(gubun1.equals("7"))		query += " and t.fuel_kd like '휘발유' ";
  			if(gubun1.equals("8"))		query += " and t.fuel_kd like '%경유%' ";
			if(gubun1.equals("9"))		query += " and t.fuel_kd like '%LPG%' ";
  			if(gubun1.equals("10"))		query += " and t.fuel_kd like '%겸용%' ";

  			if(gubun1.equals("13"))		query += " and decode(t.car_stat, '배차', decode(t.rent_st_nm,'업무', t.cust_nm, t.firm_nm), t.park ) like '%영남%' ";
  			if(gubun1.equals("14"))		query += " and decode(t.car_stat, '배차', decode(t.rent_st_nm,'업무', t.cust_nm, t.firm_nm), t.park ) like '%부산%' ";
  			if(gubun1.equals("15"))		query += " and decode(t.car_stat, '배차', decode(t.rent_st_nm,'업무', t.cust_nm, t.firm_nm), t.park ) like '%대전%' ";

		
 	  query += " union "+
				" select "+
				"        b.car_use, decode(a.br_id, 'S1', 1, 'K1', 1, 'B1', 2, 'N1', 2, 'D1', 3) brch_id, \n"+
				"        decode( nvl(b.prepare, '1' ), '2', '2', '5', '3', '4', '4', '8', '5', '1' ) p_p, '', '', \n"+
				"        decode(a.br_id,'S1','본사','K1','본사','B1','부산지점','N1','부산지점','D1','대전지점','G1','대구지점','J1','광주지점','본사') brch_nm, \n"+
				"        a.car_mng_id, b.car_no, b.car_nm, b.init_reg_dt,  decode(c.car_st, 1,'1',2,'2' ) AS gubun, "+
				"        '', '', '', '', substr(a.io_dt, 1,8) as ret_plan_dt, '', \n"+
				"        d2.nm as fuel_kd, b.DPM, b.taking_p, d.colo, '', \n"+
				"        decode(a.io_sau, '1','단기대여','2','보험대차','3','지연대차','4','사고대차','5','정비대차','6','업무대여','7','장기대기','8','예약','9','차량정비','10','사고수리','11','임시','12','월렌트') AS rent_st, "+
				"        '',  a.car_no as first_car_no, decode(b.prepare, '2', '매각', '3', '보관', '4', '말소',  '5', '도난', '6', '해지', '8', '수해', '임시' ) prepare, "+
				"        decode( a.park_id, '1', '영남주차장', '2', '정일현대', '3', '본사지하', '4', '부산지점', '5', '대전지점', '6', '파주차고지', '7', '포천차고지', '8', '김해차고지' ) AS park, "+
				"        '', '',decode(a.io_sau, '1','단기대여','2','보험대차','3','지연대차','4','사고대차','5','정비대차','6','업무대여','7','장기대기','8','예약','9','차량정비','10','사고수리','11','임시','12','월렌트') AS rent_st_nm, '', '', \n"+
				"        decode( a.park_id, '1', '영남주차장', '2', '정일현대', '3', '본사지하', '4', '부산지점', '5', '대전지점', '6', '파주차고지', '7', '포천차고지', '8', '김해차고지' ) AS park_nm "+
				" from park_io a, car_reg b, cont c, car_etc d, (select car_mng_id, max(park_seq) as seq from park_io group by car_mng_id ) e, "+
				"               (select * from code where c_st='0039') d2 "+
				" WHERE a.car_mng_id = e.car_mng_id and mod(e.seq, 2) > 0 and a.park_seq = seq and a.car_mng_id = b.car_mng_id(+) AND a.car_mng_id = c.car_mng_id(+) \n"+
				"       AND c.rent_l_cd = d.rent_l_cd(+) and io_gubun = '1' and c.car_st = '2' and a.park_id IN ('1','2','3','4','5','6','7','8') and b.FUEL_KD=d2.nm_cd ";

		if(s_kd.equals("1"))	query += " and upper(a.car_no)||upper(first_car_no) like upper('%"+t_wd+"%')\n";		
		if(s_kd.equals("2"))	query += " and b.init_reg_dt like '"+t_wd+"%'\n";
		if(s_kd.equals("4"))	query += " and upper(a.car_nm) like ('%"+t_wd+"%')\n";			
		if(s_kd.equals("5"))	query += " and decode( a.park_id, '1', '영남주차장', '2', '정일현대', '3', '본사지하', '4', '부산지점', '5', '대전지점', '6', '파주차고지', '7', '포천차고지', '8', '김해차고지' )  like '%"+t_wd+"%'\n";

			if(gubun1.equals("1"))		query += " and b.car_use = '1' ";
  			if(gubun1.equals("2"))		query += " and b.car_use = '2' ";
			if(gubun1.equals("11"))		query += " and c.car_st = '2' ";
  			if(gubun1.equals("12"))		query += " and c.car_st in ('1','3') ";
  			if(gubun1.equals("3"))		query += " and b.taking_p = 5 ";
  			if(gubun1.equals("4"))		query += " and b.taking_p = 7 ";
			if(gubun1.equals("5"))		query += " and b.taking_p >= 9 ";
  			if(gubun1.equals("6"))		query += " and b.taking_p <= 3 ";
  			if(gubun1.equals("7"))		query += " and d2.nm like '휘발유' ";
  			if(gubun1.equals("8"))		query += " and d2.nm like '%경유%' ";
			if(gubun1.equals("9"))		query += " and d2.nm like '%LPG%' ";
  			if(gubun1.equals("10"))		query += " and d2.nm like '%겸용%' ";

  			if(gubun1.equals("13"))		query += " and a.park_id IN ('1','2','3','6','7') ";
  			if(gubun1.equals("14"))		query += " and a.park_id IN ('5') ";
  			if(gubun1.equals("15"))		query += " and a.park_id IN ('4','8') ";

 		if(sort_gubun.equals("5"))		query += " order by prepare  "+asc;


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
			System.out.println("[ParkIODatabase:getCaroutPrintlist]"+e);
			System.out.println("[ParkIODatabase:getCaroutPrintlist]"+query);
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
	 *	반차관리 리스트
	 */
	public Vector getRentMngList_New(String br_id, String gubun1, String gubun2, String brch_id, String start_dt, String end_dt, String car_comp_id, String code, String s_cc, int s_year, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select /*+ leading(A H F) index(a RENT_CONT_IDX4) index(i CAR_NM_IDX1) */ \n"+
				"        a.rent_s_cd, a.car_mng_id, a.etc, \n"+
				"        decode(a.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','장기대기','12','월렌트') rent_st,\n"+
				"        decode(a.cust_st, '','아마존카', '4',e.user_nm, d.client_nm) cust_nm, \n"+
				"        decode(a.cust_st, '','아마존카', '4',e.user_nm, d.firm_nm) firm_nm, \n"+
				"        a.rent_dt, a.rent_start_dt, a.rent_end_dt, a.deli_plan_dt, a.ret_plan_dt, a.deli_dt, a.ret_dt, b.rent_tot_amt, a.brch_id, a.bus_id, \n"+
				"        c.car_no, c.init_reg_dt, c.car_nm, i.car_name, g.user_nm as bus_nm, g2.user_nm as mng_nm, \n"+
				"        c2.car_no as d_car_no, c2.car_nm as d_car_nm, a.cust_id, e.loan_st, replace(a.sub_l_cd,' ','') as sub_l_cd \n"+
				" from   RENT_CONT a, RENT_FEE b, CAR_REG c, CLIENT d, USERS e, users g, users g2, \n"+
				"        (select a.* FROM CONT a, (SELECT car_mng_id, min(rent_l_cd) rent_l_cd from cont where car_st<>'4' group by car_mng_id) b WHERE a.car_mng_id=b.car_mng_id AND a.rent_l_cd=b.rent_l_cd) h, "+
				"        car_reg c2, \n"+
				"        car_etc f, \n"+
				"        car_nm i, CAR_MNG j \n"+
				" where  a.use_st='2' and a.rent_s_cd=b.rent_s_cd(+) and a.car_mng_id=c.car_mng_id and a.cust_id=d.client_id(+) and a.cust_id=e.user_id(+) \n"+
				"        and a.bus_id=g.user_id(+) and a.mng_id=g2.user_id(+) "+
				"		 and a.car_mng_id=h.car_mng_id "+
				"		 and a.sub_c_id=c2.car_mng_id(+) \n"+
				"        and h.rent_mng_id=f.rent_mng_id and h.rent_l_cd=f.rent_l_cd "+
				"	     and f.car_id=i.car_id and f.car_seq=i.car_seq and i.car_comp_id=j.car_comp_id and i.car_cd=j.code \n "+
				" ";

		if(!gubun2.equals("")){
			if(gubun2.equals("20"))								query += " and a.rent_st in ('1', '2', '3', '4', '5')";
  			else if(gubun2.equals("30"))						query += " and a.rent_st in ('6', '7', '8')";
  			else if(gubun2.equals("4"))							query += " and a.rent_st in ('4', '5')";
  			else if(gubun2.equals("6"))							query += " and a.rent_st in ('6', '7')";
			else												query += " and a.rent_st='"+gubun2+"'";
		}

		if(brch_id.equals("S1"))								query += " and a.brch_id in ('S1','K1')";
		if(brch_id.equals("S2"))								query += " and a.brch_id='S2'";
		if(brch_id.equals("B1"))								query += " and a.brch_id in ('B1','N1')";
		if(brch_id.equals("D1"))								query += " and a.brch_id='D1'";
		if(brch_id.equals("J1"))								query += " and a.brch_id='J1'";
		if(brch_id.equals("G1"))								query += " and a.brch_id='G1'";

		if(!start_dt.equals("") && !end_dt.equals(""))			query += " and a.deli_plan_dt between '"+start_dt+"00' and '"+end_dt+"24'";
		else if(!start_dt.equals("") && end_dt.equals(""))		query += " and a.deli_plan_dt like '"+start_dt+"%'";
		else if(start_dt.equals("") && end_dt.equals(""))		query += " AND SUBSTR(a.DELI_DT, 0, 8) = to_char(sysdate,'YYYYMMDD') ";

		if(!car_comp_id.equals(""))								query += " and j.car_comp_id='"+car_comp_id+"'";		
		if(!code.equals(""))									query += " and j.code='"+code+"'";		
				
		if(s_kd.equals("1"))									query += " and upper(c.car_no)||upper(c.first_car_no) like upper('%"+t_wd+"%')\n";		
		if(s_kd.equals("2"))									query += " and decode(a.cust_st, '','아마존카', '4',e.user_nm, d.client_nm) like '%"+t_wd+"%'\n";		
		if(s_kd.equals("3"))									query += " and decode(a.cust_st, '','아마존카', '4',e.user_nm, d.firm_nm) like '%"+t_wd+"%'\n";		
		if(s_kd.equals("4"))									query += " and g.user_nm like '%"+t_wd+"%'\n";		
		if(s_kd.equals("5"))									query += " and upper(c2.car_no)||upper(c2.first_car_no) like '%"+t_wd+"%'\n";		
		if(s_kd.equals("6"))									query += " and g2.user_nm like '%"+t_wd+"%'\n";		
		if(s_kd.equals("7"))									query += " and g.user_nm||g2.user_nm like '%"+t_wd+"%'\n";		
		if(s_kd.equals("8"))									query += " and a.rent_s_cd = '"+t_wd+"'\n";		


		if(sort_gubun.equals("d.car_no"))	sort_gubun = "c.car_no";


		if(!sort_gubun.equals(""))								query += " ORDER BY decode(a.rent_st,'4',1,0), decode(a.rent_st, '4', '00', '12', '01',  '99') desc , "+sort_gubun+" "+asc;
		else													query += " ORDER BY decode(a.rent_st,'4',1,0), decode(a.cust_st, '4',e.user_nm, d.firm_nm)";

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
			System.out.println("[ParkIODatabase:getRentMngList_New]"+e);
			System.out.println("[ParkIODatabase:getRentMngList_New]"+query);
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

   
   
	//매각확정 취소시 처리 : io_gubun :3-> ''로 변경 
	public int updateParkIoGubun(String car_mng_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count2 = 0;
		String query = "";

		query = " update PARK_CONDITION set  io_gubun = '' where car_mng_id='"+car_mng_id+"' ";


		try 
		{			
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			count2 = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
		} catch (SQLException e) {
			System.out.println("[ParkIODatabase:updateParkIoGubun]\n"+e);
			System.out.println("[ParkIODatabase:updateParkIoGubun]\n"+query);
	  		e.printStackTrace();
			conn.rollback();
	  	} catch (Exception e) {
		  	System.out.println("[ParkIODatabase:updateParkIoGubun]\n"+e);
			System.out.println("[ParkIODatabase:updateParkIoGubun]\n"+query);
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count2;
		}
	}





	//마감후 배차된 차량 정리
	public Vector Park_subOffice_list(String save_year, String save_mon, String gubun)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String park = "";
		String park_id= "";
		String udtst = "";
		String br_id = "";
		String rent_st_nm = "";
		

		if(gubun.equals("본사")){
			park = " AND park IN ('1') ";
			park_id = " AND park_id IN ('1') ";
			udtst = " and udt_st = '1' ";
			br_id = " and brch_nm = '본사' ";
			rent_st_nm = "차량정비";
		}else if(gubun.equals("부산")){
			park = " AND park IN ('7','8') ";
			park_id = " AND park_id IN ('7','8') ";
			udtst = " and udt_st = '2' ";
			br_id = " and brch_nm = '부산지점' ";
			rent_st_nm = "차량정비";
		}else if(gubun.equals("대구")){
			park = " AND park IN ('13','20') ";
			park_id = " AND park_id IN ('13','20') ";
			udtst = " and udt_st = '5' ";
			br_id = " and brch_nm = '대구지점' ";
			rent_st_nm = "차량정비";
		}else if(gubun.equals("대전")){
			park = " AND park IN ('9','11') ";
			park_id = " AND park_id IN ('9','11') ";
			udtst = " and udt_st = '3' ";
			br_id = " and brch_nm = '대전지점' ";
			rent_st_nm = "차량정비";
		}else if(gubun.equals("광주")){
			park = " AND park IN ('12') ";
			park_id = " AND park_id IN ('12') ";
			udtst = " and udt_st = '6' ";
			br_id = " and brch_nm = '광주지점' ";
			rent_st_nm = "차량정비";
		}

  	query =	" SELECT to_number(a.park_id) AS park_nm,  a.gubun, \n"+
			 " nvl(max(decode(substr(save_dt,7,8), '01',cnt)), 0) AS d1, \n"+
			 " nvl(max(decode(substr(save_dt,7,8), '02',cnt)), 0) AS d2,  \n"+
			 " nvl(max(decode(substr(save_dt,7,8), '03',cnt)), 0) AS d3,  \n"+
			 " nvl(max(decode(substr(save_dt,7,8), '04',cnt)), 0) AS d4,  \n"+
			 " nvl(max(decode(substr(save_dt,7,8), '05',cnt)), 0) AS d5,  \n"+
			 " nvl(max(decode(substr(save_dt,7,8), '06',cnt)), 0) AS d6,  \n"+
			 " nvl(max(decode(substr(save_dt,7,8), '07',cnt)), 0) AS d7,  \n"+
			 " nvl(max(decode(substr(save_dt,7,8), '08',cnt)), 0) AS d8,  \n"+
			 " nvl(max(decode(substr(save_dt,7,8), '09',cnt)), 0) AS d9,  \n"+
			 " nvl(max(decode(substr(save_dt,7,8), '10',cnt)), 0) AS d10, \n"+ 
			 " nvl(max(decode(substr(save_dt,7,8), '11',cnt)), 0) AS d11, \n"+ 
			 " nvl(max(decode(substr(save_dt,7,8), '12',cnt)), 0) AS d12, \n"+ 
			 " nvl(max(decode(substr(save_dt,7,8), '13',cnt)), 0) AS d13, \n"+ 
			 " nvl(max(decode(substr(save_dt,7,8), '14',cnt)), 0) AS d14, \n"+ 
			 " nvl(max(decode(substr(save_dt,7,8), '15',cnt)), 0) AS d15, \n"+ 
			 " nvl(max(decode(substr(save_dt,7,8), '16',cnt)), 0) AS d16, \n"+ 
			 " nvl(max(decode(substr(save_dt,7,8), '17',cnt)), 0) AS d17, \n"+ 
			 " nvl(max(decode(substr(save_dt,7,8), '18',cnt)), 0) AS d18, \n"+ 
			 " nvl(max(decode(substr(save_dt,7,8), '19',cnt)), 0) AS d19, \n"+ 
			 " nvl(max(decode(substr(save_dt,7,8), '20',cnt)), 0) AS d20, \n"+ 
			 " nvl(max(decode(substr(save_dt,7,8), '21',cnt)), 0) AS d21, \n"+ 
			 " nvl(max(decode(substr(save_dt,7,8), '22',cnt)), 0) AS d22, \n"+ 
			 " nvl(max(decode(substr(save_dt,7,8), '23',cnt)), 0) AS d23, \n"+ 
			 " nvl(max(decode(substr(save_dt,7,8), '24',cnt)), 0) AS d24, \n"+ 
			 " nvl(max(decode(substr(save_dt,7,8), '25',cnt)), 0) AS d25, \n"+ 
			 " nvl(max(decode(substr(save_dt,7,8), '26',cnt)), 0) AS d26, \n"+ 
			 " nvl(max(decode(substr(save_dt,7,8), '27',cnt)), 0) AS d27, \n"+ 
			 " nvl(max(decode(substr(save_dt,7,8), '28',cnt)), 0) AS d28, \n"+ 
			 " nvl(max(decode(substr(save_dt,7,8), '29',cnt)), 0) AS d29, \n"+ 
			 " nvl(max(decode(substr(save_dt,7,8), '30',cnt)), 0) AS d30, \n"+ 
			 " nvl(max(decode(substr(save_dt,7,8), '31',cnt)), 0) AS d31  \n"+
			 " FROM \n"+
		     " (SELECT save_dt, decode(trim(park_id), '7', '3', '8', '3' , '9' , '4', '11', '4', trim(park_id) ) park_id,  \n"+
             " DECODE(SUBSTR(car_mng_id,0,2),'XX','신차', DECODE(io_gubun,'3','매각확정', decode(trim(firm_nm), '(주)아마존카', '예비차', '고객차' ))) gubun, count(0) cnt \n"+		//매각확정차량 표기위해 수정(2018.02.01)
			 " FROM park_magam WHERE save_dt LIKE '"+save_year+save_mon+"%'  "+park_id+"  \n"+		//매각확정차량 표기위해 수정(2018.02.01)
		     " GROUP BY save_dt, decode(trim(park_id), '7', '3', '8', '3' , '9' , '4', '11', '4', trim(park_id) ), \n"+
             " DECODE(SUBSTR(car_mng_id,0,2),'XX','신차', DECODE(io_gubun,'3','매각확정', decode(trim(firm_nm), '(주)아마존카', '예비차', '고객차' )))   \n"+			//매각확정차량 표기위해 수정(2018.02.01)
           " UNION ALL \n"+   
              " (SELECT cons_dt as save_DT , decode(trim(park), '7', '3', '8', '3' , '9' , '4', '11', '4', trim(park) ) park_id,  \n"+  //매각만 
             " '매각' as gubun, count(0) cnt \n"+
			 " FROM car_reg WHERE  cons_dt  LIKE '"+save_year+save_mon+"%'  "+park+" \n"+  
		     " GROUP BY cons_dt, decode(trim(park), '7', '3', '8', '3' , '9' , '4', '11', '4', trim(park) )) \n"+                                   
			 " UNION ALL \n"+
			 "  SELECT c.INIT_REG_DT as save_dt , DECODE(a.udt_st,'1','1','2','3','3','4','5','13','6','12','4','100') AS park_id, '신차'AS gubun, COUNT(0) cnt  \n"+
			 " FROM CAR_PUR a, CONT b, CAR_REG c, (SELECT doc_id FROM doc_settle WHERE doc_st='4' AND doc_step='3' ) d \n"+
			 " WHERE a.RENT_MNG_ID = b.RENT_MNG_ID AND a.RENT_L_CD = b.RENT_L_CD AND b.CAR_MNG_ID = c.CAR_MNG_ID  \n"+
			 " AND c.INIT_REG_DT LIKE '"+save_year+save_mon+"%'  "+udtst+"  AND a.rent_l_cd=d.doc_id GROUP BY c.INIT_REG_DT, '', DECODE(a.udt_st,'1','1','2','3','3','4','5','13','6','12','4','100'), '신차'  \n"+
			 " UNION ALL \n"+
			 " SELECT to_char(to_date(save_dt,'yyyymmdd'), 'yyyymmdd') save_dt, DECODE(brch_nm, '본사','1','부산지점','3','대전지점','4',brch_nm) park_id, '입고대기' AS gubun, count(0) cnt \n"+
			 " FROM stat_car_prepare \n"+
			 " WHERE save_dt LIKE '"+save_year+save_mon+"%' "+br_id+" \n"+
			 " AND rent_st_nm = '" + rent_st_nm + "'  \n"+
			 " GROUP BY  to_char(to_date(save_dt,'yyyymmdd'), 'yyyymmdd'), DECODE(brch_nm, '본사','1','부산지점','3','대전지점','4', brch_nm ), '보유차' \n"+
			 " ) a \n"+
			 " GROUP BY to_number(a.park_id), a.gubun  \n"+
//			 " ORDER BY to_number(a.park_id), DECODE(a.gubun,'예비차',1,'신차',2,'고객차',3, '매각',4,5) ";
  			 " ORDER BY to_number(a.park_id), DECODE(a.gubun,'예비차',1,'신차',2,'고객차',3, '매각확정',4, '매각',5,6) ";		//매각확정차량 표기위해 수정(2018.02.01)




		try {
			stmt = conn.createStatement();
		    rs = stmt.executeQuery(query);
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
			stmt.close();

		} catch (SQLException e) {
			System.out.println("[ParkIODatabase:Park_subOffice_list(]"+e);
			System.out.println("[ParkIODatabase:Park_subOffice_list(]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}	

	
    //탁송기사 주차장 보유차량 사진 촬영 화면 - 로그인ID 추출
    public String getSHPhotoLoginId()
    {
        getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Vector vt = new Vector();
        String query = "";

        String loginId = "";
    
        query= " SELECT LPAD(NVL(MAX(LOGIN_ID)+1,1),6,0) FROM SH_PHOTO_LOGIN ";    

        try {
            pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();
            while(rs.next())
            {
                loginId = rs.getString(1);
            }
            rs.close();
            pstmt.close();
        } catch (SQLException e) {
            System.out.println("[ParkIODatabase:getSHPhotoLoginId]"+e);
            e.printStackTrace();
        } finally {
            try{
                if(rs != null )     rs.close();
                if(pstmt != null)   pstmt.close();
            }catch(Exception ignore){}
            closeConnection();
            return loginId;
        }
    }
    
	
    //탁송기사 주차장 보유차량 사진 촬영 화면 - 로그인 정보 입력
    public int insertSHPhotoLoginInfo(String name, String phone, String loginId, int coworkerCount)
    {
        getConnection();
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        ResultSet rs = null;
            
        int count2 = 0;
        String query1 = "";
        String query2 = "";
        
        int seq = 0;

        query1 = " SELECT NVL(MAX(SEQ)+1,1) FROM SH_PHOTO_LOGIN ";
        query2 = " INSERT INTO SH_PHOTO_LOGIN(SEQ, LOGIN_ID, NAME, PHONE, CO_CNT) \n" + 
                 "      VALUES(?, ?, ?, ?, ?) ";

        try 
        {           
            conn.setAutoCommit(false);

            pstmt1 = conn.prepareStatement(query1);
            rs = pstmt1.executeQuery();
            
            if(rs.next())
            {               
                seq = rs.getInt(1);    
            }
            rs.close();
            pstmt1 .close();
            
            pstmt2 = conn.prepareStatement(query2);
            pstmt2.setInt(1, seq);
            pstmt2.setString(2, loginId);
            pstmt2.setString(3, name);
            pstmt2.setString(4, phone);
            pstmt2.setInt(5, coworkerCount);
            
            count2 = pstmt2.executeUpdate();
            pstmt2.close();
            
            conn.commit();
            
        } catch (SQLException e) {
            System.out.println("[ParkIODatabase:insertSHPhotoLoginInfo]\n"+e);
            System.out.println("[ParkIODatabase:insertSHPhotoLoginInfo]\n"+query1);
            e.printStackTrace();
            conn.rollback();
        } catch (Exception e) {
            System.out.println("[ParkIODatabase:insertSHPhotoLoginInfo]\n"+e);
            System.out.println("[ParkIODatabase:insertSHPhotoLoginInfo]\n"+query1);
            e.printStackTrace();
            conn.rollback();
        } finally {
            try{
                conn.setAutoCommit(true);
                if(rs != null )		rs.close();
                if(pstmt1 != null)	pstmt1.close();
                if(pstmt2 != null)	pstmt2.close();            
            }catch(Exception ignore){}
            closeConnection();
            return count2;
        }
    }

    //탁송기사 주차장 보유차량 사진 촬영 화면 - 로그인 정보 입력
    public int insertSHPhotoWorkInfo(String loginId)
    {
        getConnection();
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        ResultSet rs = null;
            
        int count2 = 0;
        String query1 = "";
        String query2 = "";
        
        int seq = 0;

        query1 = " SELECT NVL(MAX(SEQ)+1,1) FROM SH_PHOTO_WORK ";
        query2 = " INSERT INTO SH_PHOTO_WORK(SEQ, LOGIN_ID, COUNT, LST_REG_DT) \n" + 
                 "      VALUES(?, ?, ?, sysdate) ";

        try 
        {           
            conn.setAutoCommit(false);

            pstmt1 = conn.prepareStatement(query1);
            rs = pstmt1.executeQuery();
            
            if(rs.next())
            {               
                seq = rs.getInt(1);    
            }
            rs.close();
            pstmt1 .close();
            
            pstmt2 = conn.prepareStatement(query2);
            pstmt2.setInt(1, seq);
            pstmt2.setString(2, loginId);
            pstmt2.setInt(3, 0);
            
            count2 = pstmt2.executeUpdate();
            pstmt2.close();
            
            conn.commit();
            
        } catch (SQLException e) {
            System.out.println("[ParkIODatabase:insertSHPhotoWorkInfo]\n"+e);
            System.out.println("[ParkIODatabase:insertSHPhotoWorkInfo]\n"+query1);
            e.printStackTrace();
            conn.rollback();
        } catch (Exception e) {
            System.out.println("[ParkIODatabase:insertSHPhotoWorkInfo]\n"+e);
            System.out.println("[ParkIODatabase:insertSHPhotoWorkInfo]\n"+query1);
            e.printStackTrace();
            conn.rollback();
        } finally {
            try{
                conn.setAutoCommit(true);
                if(rs != null )		rs.close();
                if(pstmt1 != null)	pstmt1.close();
                if(pstmt2 != null)	pstmt2.close();            
            
            }catch(Exception ignore){}
            closeConnection();
            return seq;
        }
    }

    /**
     *  점검항목 안에 점검했던 리스트
     */
    public Vector getSHPhotoHistory(String type, String month)
    {
        getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Vector vt = new Vector();
        String query = "";
        
        if(type.equals("date")){
            query = " SELECT REG_DT AS STD, SUM(COUNT) AS SUM " +
                    "   FROM( " +
                    "        SELECT COUNT, TO_CHAR(LST_REG_DT,'YYYYMMDD') REG_DT  " +
                    "          FROM SH_PHOTO_WORK  " +
                    "         WHERE TO_CHAR(LST_REG_DT,'YYYYMM') = '" + month + "'  " +
                    "       ) " +
                    " GROUP BY REG_DT " +
                    " ORDER BY REG_DT ASC ";            
        }else{
            query = " SELECT NAME AS STD, CO_CNT, SUM(COUNT)/CO_CNT AS SUM  " +
                    " FROM (  " +
                    "       SELECT *   " +
                    "         FROM SH_PHOTO_LOGIN lg, SH_PHOTO_WORK wk   " +
                    "        WHERE lg.LOGIN_ID = wk.LOGIN_ID   " +
                    "          AND TO_CHAR(LST_REG_DT,'YYYYMM') = '" + month + "'   " +
                    " )  " +
                    " GROUP BY NAME, CO_CNT " + 
                    " ORDER BY SUM, NAME DESC";
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
                     ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
                }
                vt.add(ht); 
            }
			rs.close();
			pstmt.close();

        } catch (SQLException e) {
            System.out.println("[ParkIODatabase:getSHPhotoHistory]"+e);
            System.out.println("[ParkIODatabase:getSHPhotoHistory]"+query);
            e.printStackTrace();
        } finally {
            try{
                if(rs != null )     rs.close();
                if(pstmt != null)   pstmt.close();
            }catch(Exception ignore){}
            closeConnection();
            return vt;
        }
    }   

    //PARK_IO에서 입고시 데이터 삭제
    public int updateSHPhotoWorkCount(String work_id, String login_id)
    {
        getConnection();
        PreparedStatement pstmt = null;
        int count2 = 0;
        String query = "";

        query = " UPDATE SH_PHOTO_WORK " +
                " SET(COUNT) = (SELECT COUNT + 1 " + 
                "                 FROM SH_PHOTO_WORK " + 
                "                WHERE SEQ = "+ work_id + " " +  
                "                  AND LOGIN_ID = '"+login_id+"')" +
                " WHERE SEQ = "+work_id+ " " +
                "   AND LOGIN_ID = '" + login_id +"'";

        try 
        {           
            conn.setAutoCommit(false);

            pstmt = conn.prepareStatement(query);
            count2 = pstmt.executeUpdate();
			pstmt.close();

            conn.commit();
            
        } catch (SQLException e) {
            System.out.println("[ParkIODatabase:updateSHPhotoWorkCount]\n"+e);
            System.out.println("[ParkIODatabase:updateSHPhotoWorkCount]\n"+query);
            e.printStackTrace();
            conn.rollback();
        } catch (Exception e) {
            System.out.println("[ParkIODatabase:updateSHPhotoWorkCount]\n"+e);
            System.out.println("[ParkIODatabase:updateSHPhotoWorkCount]\n"+query);
            e.printStackTrace();
            conn.rollback();
        } finally {
            try{
                conn.setAutoCommit(true);
                if(pstmt != null)   pstmt.close();
            }catch(Exception ignore){}
            closeConnection();
            return count2;
        }
    }
    
    public int insertSHPhotoWorkHistory(String work_id, String car_nm, String car_no, String car_mng_id){
        getConnection();
        PreparedStatement pstmt = null;
        int count2 = 0;
        String query = "";

        query = " INSERT INTO SH_PHOTO_WORK_HIS(WORK_SEQ, CAR_NM, CAR_NO, CAR_MNG_ID, REG_DT) "+
                " VALUES(?,?,?,?,sysdate)";

        try{           
            conn.setAutoCommit(false);

            pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, Integer.parseInt(work_id));
            pstmt.setString(2, car_nm);
            pstmt.setString(3, car_no);
            pstmt.setString(4, car_mng_id);
            
            count2 = pstmt.executeUpdate();
			pstmt.close();

            conn.commit();
            
        } catch (SQLException e) {
            System.out.println("[ParkIODatabase:insertSHPhotoWorkHistory]\n"+e);
            System.out.println("[ParkIODatabase:insertSHPhotoWorkHistory]\n"+query);
            e.printStackTrace();
            conn.rollback();
        } catch (Exception e) {
            System.out.println("[ParkIODatabase:insertSHPhotoWorkHistory]\n"+e);
            System.out.println("[ParkIODatabase:insertSHPhotoWorkHistory]\n"+query);
            e.printStackTrace();
            conn.rollback();
        } finally {
            try{
                conn.setAutoCommit(true);
                if(pstmt != null)   pstmt.close();
            }catch(Exception ignore){}
            closeConnection();
            return count2;
        }
    }
    
    //주차장 입출고현황 리스트 (2018.02.23)
    public Vector getPark_IO_list(String park_id, String gubun1, String gubun2, String io_gubun, String t_wd, String s_dt, String e_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";		
		
		query = " SELECT a.PARK_ID,a.car_mng_id, a.park_seq, a.reg_id, a.io_gubun, a.car_st, a.car_no, \r\n" + 
				"        a.car_nm, a.car_km, a.io_dt, a.io_sau, a.users_comp, a.start_place, \r\n" + 
				"		 DECODE(a.end_place, '0', '고객인수', '1', '영남주차장', '2', '정일현대', '4', '대전지점', '5', '신엠제이', '6', '기타', '7', '부산부경', '8', '웰메이드', '9', '대전현대', '10', '오토크린', '11', '대전금호', '12', '광주지점', '13', '대구지점', '14', '강서모터스', '18', '본동자동차', '19', '타이어휠타운', '20', '성서현대', '21', '아마존모터스', \r\n" + 
				"		 '000502', '현대글로비스(주)-시화', '013011', '현대글로비스(주)-분당', '020385', '에이제이셀카(주)', '022846', '롯데렌탈((구)케이티렌탈)', '알수없음') end_place, \r\n" + 	 	
				"        a.br_id, a.park_mng, a.car_gita, a.use_yn, a.rent_l_cd, b.car_key, a.car_key_cau, c.secondhand, \r\n" + 
				"        e.nm driver_nm ,\r\n" + 
				"        d.nm park_place,\r\n" + 
				"        DECODE(a.car_st,'9','신차','')AS new_car, \r\n" + 
				"        TO_CHAR(a.reg_dt,'YYYY-MM-DD [ HH24:MI ]') AS reg_dt, \r\n" + 
				" 		DECODE(c.prepare, '2', '매각', '3', '보관', '4', '말소',  '5', '도난', '6', '해지', '8', '수해', '예비' ) prepare \r\n" + 
				"   FROM park_io a, park_condition b, car_reg c , (SELECT * FROM code WHERE C_ST='0027') d, (SELECT * FROM code WHERE C_ST='0048') e\r\n" + 
				"   WHERE 1=1 \r\n" + 
				"		AND a.car_mng_id = b.car_mng_id(+) AND a.car_mng_id = c.car_mng_id(+)\r\n" + 
				"	  	AND TRIM(a.PARK_ID) = d.NM_CD(+) AND a.DRIVER_NM = e.NM_CD(+)\r\n ";
		//주차장 검색
		if(!park_id.equals("")){
			query += " AND a.park_id = '"+ park_id +"' \n";
		}
		
		if(!gubun1.equals("")){
			//차량번호 검색	
			if(gubun1.equals("1")){			query += " AND a.car_no like '%"+ t_wd +"%' \n";	}
			//차종 검색
			else if(gubun1.equals("2")){	query += " AND a.car_nm like '%"+ t_wd +"%' \n";	}
		}
		//입,출고 상태
		if(!io_gubun.equals("")){
			if(io_gubun.equals("1")){			query += " AND a.io_gubun = '1' \n";	}
			else if(io_gubun.equals("2")){		query += " AND a.io_gubun = '2' \n";	}
		}
		if(!gubun2.equals("")){
			//기간 검색
			if(gubun2.equals("1")){
				query += "	AND a.io_dt like to_char(sysdate,'YYYYMMDD')||'%' \n	";
			}else if(gubun2.equals("2")){
				query += "	AND a.io_dt like to_char(sysdate-1,'YYYYMMDD')||'%' \n	";
			}else if(gubun2.equals("3")){
				query += "	AND a.io_dt like to_char(sysdate,'YYYYMM')||'%' \n 	";
			}else if(gubun2.equals("4")){
				query += "	AND a.io_dt between replace('"+s_dt+"','-','') and replace('"+e_dt+"','-','')	";
			}
		}
		query += " ORDER BY a.REG_DT desc, TO_NUMBER(a.PARK_SEQ) DESC  ";
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
			System.out.println("[ParkIODatabase:getPark_IO_list]"+e);
			System.out.println("[ParkIODatabase:getPark_IO_list]"+query);
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
    
    // 세차현황 통계 20181212 (월별 일일통계)
    public Vector getParkWashStat(String park_id, String off_id, String s_yy, String s_mm)
    {
        getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Vector vt = new Vector();
        String query = "";
        String and_query = "";
        
        String year_mon = s_yy + s_mm;
        
        if (park_id.equals("") || park_id.equals("1")) {
        	park_id = "1";
        }
        
        if (!off_id.equals("")) {
        	and_query = " AND  off_id = '"+off_id+"' ";
        }
        
        query = 
					" SELECT nvl(to_char(WASH_START,'DD'),to_char(INCLEAN_START,'DD')) REQ_DD, " +
			        " COUNT(WASH_PAY) wash_cnt, COUNT(INCLEAN_PAY) inclean_cnt, COUNT(WASH_PAY) + COUNT(INCLEAN_PAY) total_cnt, " + 
			        " Sum(nvl(WASH_PAY,'0')) wash_dd_pay, Sum(NVL(INCLEAN_PAY,'0')) inclean_dd_pay , SUM(nvl(WASH_PAY,'0'))+SUM(NVL(INCLEAN_PAY,'0')) total_dd_pay "+
			        " FROM   park_wash  " +
			        " WHERE  park_id = '"+park_id+"' " + 
			        and_query +
			        " AND nvl(to_char(WASH_START,'YYYYMM'),to_char(INCLEAN_START,'YYYYMM'))  = '"+year_mon+"' " +
			        " AND gubun_st = '2' " +
			      /*  " --AND (INCLEAN_PAY ='30000' OR WASH_PAY='10000') " +*/
			        " GROUP  BY nvl(to_char(WASH_START,'DD'),to_char(INCLEAN_START,'DD'))  " +
			        " ORDER  BY nvl(to_char(WASH_START,'DD'),to_char(INCLEAN_START,'DD')) ASC ";
        
        try {
            pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();
            ResultSetMetaData rsmd = rs.getMetaData();
                
            while(rs.next()) {
                Hashtable ht = new Hashtable();
                for (int pos =1; pos <= rsmd.getColumnCount();pos++) {
                     String columnName = rsmd.getColumnName(pos);
                     ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
                }
                vt.add(ht);
            }
			rs.close();
			pstmt.close();

        } catch (SQLException e) {
            System.out.println("[ParkIODatabase:getParkWashStat]"+e);
            System.out.println("[ParkIODatabase:getParkWashStat]"+query);
            e.printStackTrace();
        } finally {
            try{
                if(rs != null )     rs.close();
                if(pstmt != null)   pstmt.close();
            }catch(Exception ignore){}
            closeConnection();
            return vt;
        }
    }
    
    
    // 세차현황 통계 20181212 (월별 합계) //사용보류
    public Vector getParkWashMonStat(String park_id, String off_id, String s_yy, String s_mm)
    {
    	 getConnection();
         PreparedStatement pstmt = null;
         ResultSet rs = null;
         Vector vt = new Vector();
         String query = "";
         String and_query = "";
         
         
         if (park_id.equals("") || park_id.equals("1")) {
         	park_id = "1";
         }
         
         if (!off_id.equals("")) {
         	and_query = " AND  off_id = '"+off_id+"' ";
         }
         
         query = 
 					" SELECT nvl(to_char(WASH_START,'MM'),to_char(INCLEAN_START,'MM')) REQ_MM, " +
 			        " COUNT(WASH_PAY) wash_cnt, COUNT(INCLEAN_PAY) inclean_cnt, COUNT(WASH_PAY) + COUNT(INCLEAN_PAY) total_cnt, " + 
 			        " Sum(nvl(WASH_PAY,'0')) wash_dd_pay, Sum(NVL(INCLEAN_PAY,'0')) inclean_dd_pay , SUM(nvl(WASH_PAY,'0'))+SUM(NVL(INCLEAN_PAY,'0')) total_dd_pay "+
 			        " FROM   park_wash  " +
 			        " WHERE  park_id = '"+park_id+"' " + 
 			        and_query +
 			        " AND nvl(to_char(WASH_START,'YYYY'),to_char(INCLEAN_START,'YYYY'))  = '"+s_yy+"' " +
 			        " AND gubun_st = '2' " +
 			       /* " --AND (INCLEAN_PAY ='30000' OR WASH_PAY='10000') " +*/
 			        " GROUP  BY nvl(to_char(WASH_START,'MM'),to_char(INCLEAN_START,'MM'))  " +
 			        " ORDER  BY nvl(to_char(WASH_START,'MM'),to_char(INCLEAN_START,'MM')) ASC ";
         
         try {
             pstmt = conn.prepareStatement(query);
             rs = pstmt.executeQuery();
             ResultSetMetaData rsmd = rs.getMetaData();
                 
             while(rs.next()) {
                 Hashtable ht = new Hashtable();
                 for (int pos =1; pos <= rsmd.getColumnCount();pos++) {
                      String columnName = rsmd.getColumnName(pos);
                      ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
                 }
                 vt.add(ht);
             }
 			rs.close();
 			pstmt.close();

         } catch (SQLException e) {
             System.out.println("[ParkIODatabase:getParkWashStat]"+e);
             System.out.println("[ParkIODatabase:getParkWashStat]"+query);
             e.printStackTrace();
         } finally {
             try{
                 if(rs != null )     rs.close();
                 if(pstmt != null)   pstmt.close();
             }catch(Exception ignore){}
             closeConnection();
             return vt;
         }
    }
    
    // 세차현황 통계 20181213 (월별 합계)
    public Hashtable  getParkWashTotalStat(String park_id, String off_id, String s_yy, String s_mm) throws DatabaseException, DataSourceEmptyException{
    	  getConnection();
          PreparedStatement pstmt = null;
          ResultSet rs = null;
          Hashtable ht = new Hashtable();
          int count = 0;
          String query = "";
          String and_query = "";
          
          String year_mon = s_yy + s_mm;
          
          if (park_id.equals("") || park_id.equals("1")) {
          	park_id = "1";
          }
          
          if (!off_id.equals("")) {
          	and_query = " AND  off_id = '"+off_id+"' ";
          }
          
          if (!s_mm.equals("0")) {
            	and_query += " AND TO_CHAR(nvl(WASH_START,INCLEAN_START), 'YYYYMM') = '"+year_mon+"' " ;
          }else {
        	    and_query +=" AND TO_CHAR(nvl(WASH_START,INCLEAN_START), 'YYYY') = '"+s_yy+"' " ;
          }
    
        query = " SELECT COUNT(WASH_PAY) wash_cnt, COUNT(INCLEAN_PAY) inclean_cnt, COUNT(WASH_PAY) + COUNT(INCLEAN_PAY) total_cnt, " + 
        		" Sum(nvl(WASH_PAY,'0')) wash_total_pay, Sum(NVL(INCLEAN_PAY,'0')) inclean_total_pay , SUM(nvl(WASH_PAY,'0'))+SUM(NVL(INCLEAN_PAY,'0')) total_pay " + 
        		" FROM PARK_WASH "+
    			" WHERE park_id = '"+park_id+"' "  +
    			and_query  +
    		/*	"-- AND (INCLEAN_PAY ='30000' OR WASH_PAY='10000') "+*/
    			" AND gubun_st = '2' ";
        
        try {
            pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();
            ResultSetMetaData rsmd = rs.getMetaData();
                
            if(rs.next()){	
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();

        } catch (SQLException e) {
            System.out.println("[ParkIODatabase:getParkWashMonStat]"+e);
            System.out.println("[ParkIODatabase:getParkWashMonStat]"+query);
            e.printStackTrace();
        } finally {
            try{
                if(rs != null )     rs.close();
                if(pstmt != null)   pstmt.close();
            }catch(Exception ignore){}
            closeConnection();
            return ht;
        }
    }
    
    //이미등록된건인지 확인
	public int getCheckOverParkWash(String car_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		String query = "";

		query = "	SELECT count(*) FROM PARK_WASH \r\n" + 
				"	WHERE REG_DT = to_char(sysdate,'YYYYMMDD')\r\n" + 
				"	AND CAR_NO = '"+car_no+"' ";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			if(rs.next())
			{				
				count = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			//System.out.println("[InsComDatabase:getCheckOverInsExcelCom]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null)		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}
  	
    
    
    
    // 일일 작업지시서 리스트 20181207
    public Vector getParkWashDayList(String park_id, String gubun1, String gubun2, String car_no, String start_dt, String end_dt, String off_id)
    {
        getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Vector vt = new Vector();
        String query = "";
        
        query = " SELECT a.SEQ, a.RENT_MNG_ID, a.RENT_L_CD, a.CAR_MNG_ID, a.CAR_ST, a.CAR_NO, a.CAR_NM, a.PARK_ID, p.AREA," +
        			 " DECODE(a.PARK_ID,'1 ','영남주차장','17','웰메이드','7 ','부산부경','4 ','대전지점','9 ','대전현대','12','광주지점','13','대구지점',a.PARK_ID) AS PARK_NM, " +
        			 " a.WASH_DT, a.WASH_PAY, a.INCLEAN_PAY , a.REG_DT, a.REG_ID, g.USER_NM, a.WASH_ETC, " +
        			 " c.REQ_DT, " +
        			 " to_char(c.REQ_DT,'YYYY-MM-DD HH24:MI') F_REQ_DT, " +
        			 " a.GUBUN_ST, " +
        			 " decode( a.GUBUN_ST, '0', '대기', '1', '진행', '2', '완료', gubun_st ) GUBUN_ST2, " +
        			 " a.wash_start, " +
        		     " a.wash_end, " +
        		     " CASE  \r\n" + 
        		     " 	WHEN to_number(to_char(nvl(a.WASH_START,a.INCLEAN_START+1),'yyyymmddhh24miss')) > to_number(to_char(nvl(a.INCLEAN_START,a.WASH_START+1) ,'yyyymmddhh24miss')) \r\n" + 
        		     " 	THEN to_char(a.INCLEAN_START,'YYYY-MM-DD HH24:MI') \r\n" + 
        		     " 	ELSE to_char(a.wash_start,'YYYY-MM-DD HH24:MI') \r\n" + 
        		     " END F_WASH_START,\r\n" + 
        		     " CASE  \r\n" + 
        		     " 	WHEN to_number(to_char(nvl(a.WASH_END,a.INCLEAN_END-1),'yyyymmddhh24miss')) < to_number(to_char(nvl(a.INCLEAN_END,a.WASH_END-1) ,'yyyymmddhh24miss')) \r\n" + 
        		     " 	THEN to_char(a.INCLEAN_END,'YYYY-MM-DD HH24:MI') \r\n" + 
        		     " 	ELSE to_char(a.WASH_END,'YYYY-MM-DD HH24:MI') \r\n" + 
        		     " END F_WASH_END \r\n,"+
        		     " TO_CHAR(TO_DATE(ROUND((a.WASH_END - a.WASH_START)*24*60*60),'sssss'),'HH24:mi') b_time, " +
        			 " DECODE ( a.GUBUN_ST, '2', to_date(a.reg_dt || '13' || '00', 'YYYYMMDDhh24mi' ), a.wash_start ) wash_start2, " +
        			 " DECODE ( a.GUBUN_ST, '2', to_date(a.reg_dt || '13' || '00', 'YYYYMMDDhh24mi' ), a.wash_end ) wash_end2, " +
        			 " a.MNG_ID, a.USERS_COMP, REGEXP_REPLACE(REPLACE(a.USER_M_TEL,'-',''), '(.{3})(.+)(.{4})', '\\1-\\2-\\3') USER_M_TEL, a.WASH_USER_ID, a.WASH_USER_NM, a.OFF_ID, " +
        		     " TRUNC(substr(TO_CHAR(a.REQ_DT,'YYYYMMDD'),1,6)) REQ_MONTH, " +
        		     " TRUNC(to_char(sysdate,'YYYYMM')) TODAY_MONTH, " +
        		     " TRUNC(to_char(sysdate,'YYYYMMDD')) TO_DAY, REASON, " +
        		     " TRUNC(TO_CHAR(to_date(TO_CHAR(a.REQ_DT,'YYYYMMDD'), 'YYYYMMDD') + 15, 'YYYYMMDD')) AFTER_DAY " +
        			 " FROM PARK_WASH a, USERS g, (SELECT seq, NVL(req_dt, to_date(reg_dt || '13' || '00', 'YYYYMMDDhh24mi' )) req_dt FROM park_wash) c, PARK_CONDITION p " +
        			 " WHERE 1=1 AND a.reg_id = g.USER_ID(+) AND a.seq = c.seq(+) AND a.rent_l_cd = p.RENT_L_CD(+)";        
        
        if (park_id.equals("")) {
    		query += " AND a.PARK_ID = '1' ";
    	} else {
    		query += " AND a.PARK_ID = '"+park_id+"' ";        		
    	}
        
        if (!car_no.equals("")) {
        	query += " AND a.car_no like '%"+car_no+"%' ";     
        }
        
        if (!off_id.equals("")) {
        	query += " AND a.off_id = '"+off_id+"' ";
        }
    	
    	if (gubun1.equals("1") || gubun1.equals("")) { // 당일
    		query += " AND TO_CHAR(c.REQ_DT, 'YYYY-MM-DD') = to_char(SYSDATE, 'YYYY-MM-DD') ";            	
        } else if (gubun1.equals("2")) { // 전일
        	query += " AND TO_CHAR(c.REQ_DT, 'YYYY-MM-DD') = to_char(SYSDATE - 1, 'YYYY-MM-DD') ";    
        } else if (gubun1.equals("3")) { // 당월
        	query += " AND to_char(c.REQ_DT, 'YYYYMM') = to_char(SYSDATE,'YYYYMM') ";    
        } else if (gubun1.equals("4")) { // 전월
        	query += " AND TO_CHAR(c.REQ_DT, 'YYYY-MM') = to_char(add_months(SYSDATE,-1), 'YYYY-MM') ";    
        } else if (gubun1.equals("5")) { // 기간    
        	query += " AND TO_CHAR(c.REQ_DT, 'YYYYMMDD') between replace('"+start_dt+"', '-', '') and replace('"+end_dt+"', '-', '') ";    
        }
    	
    		query += " ORDER BY a.seq desc ";
    	
        try {
            pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();
            ResultSetMetaData rsmd = rs.getMetaData();
                
            while(rs.next()) {
                Hashtable ht = new Hashtable();
                for (int pos =1; pos <= rsmd.getColumnCount();pos++) {
                     String columnName = rsmd.getColumnName(pos);
                     ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
                }
                vt.add(ht);
            }
			rs.close();
			pstmt.close();

        } catch (SQLException e) {
            System.out.println("[ParkIODatabase:getParkWashDayList]"+e);
            System.out.println("[ParkIODatabase:getParkWashDayList]"+query);
            e.printStackTrace();
        } finally {
            try{
                if(rs != null )     rs.close();
                if(pstmt != null)   pstmt.close();
            }catch(Exception ignore){}
            closeConnection();
            return vt;
        }
    }
    
    //세차등록 중복체크
	public int chkParkWash(String car_mng_id, String req_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	"SELECT  COUNT(0) cnt\r\n" + 
						"	FROM 	PARK_WASH a, USERS b, BRANCH c\r\n" + 
						"	WHERE 	1=1\r\n" + 
						"	AND 	a.CAR_MNG_ID ='"+car_mng_id+"' \r\n" + 
						"	AND 	a.REG_ID = b.USER_ID\r\n" + 
						"	AND 	b.BR_ID = c.BR_ID\r\n" + 
						"	AND 	GUBUN_ST <> 2\r\n" + 
						"	AND		nvl(REQ_DT, REG_DT) >= '"+req_dt+"'";
		int  cnt = 0;
		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				cnt = rs.getInt(1);
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
			return cnt;
		}
	}
    
    // 세차차량 리스트 20180704
    public Vector getParkWashList(String gubun1, String gubun2, String start_dt, String end_dt, String s_kd, String t_wd, String sort)
    {
        getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Vector vt = new Vector();
        String query = "";
        
        query = " SELECT a.SEQ, a.RENT_MNG_ID, a.RENT_L_CD, a.CAR_MNG_ID, a.CAR_ST, a.CAR_NO, a.CAR_NM, a.PARK_ID, " +
        			 " DECODE(a.PARK_ID,'1 ','영남주차장','8 ','부산조양','7 ','부산부경','4 ','대전지점','9 ','대전현대','12','광주지점','13','대구지점',a.PARK_ID) AS PARK_NM, " +
        			 " a.WASH_DT, a.WASH_PAY, a.REG_DT, a.REG_ID, g.USER_NM, a.WASH_ETC, a.REQ_DT, a.GUBUN_ST, " +
        		     " TRUNC(substr(a.REG_DT,1,6)) REG_MONTH, " +
        		     " TRUNC(to_char(sysdate,'YYYYMM')) TODAY_MONTH, " +
        		     " TRUNC(to_char(sysdate,'YYYYMMDD')) TO_DAY, " +
        		     " TRUNC(TO_CHAR(to_date(a.REG_DT, 'YYYYMMDD') + 15, 'YYYYMMDD')) AFTER_DAY " +
        			 " FROM PARK_WASH a, USERS g" +
        			 " WHERE 1=1 AND a.reg_id = g.USER_ID(+) ";
        
        if (gubun2.equals("1")) {
        	query += " AND WASH_DT like to_char(sysdate,'YYYYMM')||'%' ";
        } else if (gubun2.equals("2")) {
        	query += " AND WASH_DT = to_char(sysdate,'YYYYMMDD') ";
        } else if (gubun2.equals("3")) {
        	query += " AND WASH_DT like to_char(add_months(sysdate,-1), 'yyyymm')||'%' ";
        } else if (gubun2.equals("4")) {
        	query += " AND WASH_DT between replace('"+start_dt+"','-','') and replace('"+end_dt+"','-','') ";
        }
        
        if (!t_wd.equals("")) {
        	if (s_kd.equals("1")) {
            	query += " AND CAR_NO LIKE '%" + t_wd + "%' ";
            } else if (s_kd.equals("2")) {
            	query += " AND CAR_NM LIKE '%" + t_wd + "%' ";
            }
        }
        
        if (sort.equals("1")) {
        	query += " ORDER BY WASH_DT ASC ";
        } else if (sort.equals("2")) {
        	query += " ORDER BY WASH_DT DESC ";
        }
        
        try {
            pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();
            ResultSetMetaData rsmd = rs.getMetaData();
                
            while(rs.next()) {
                Hashtable ht = new Hashtable();
                for (int pos =1; pos <= rsmd.getColumnCount();pos++) {
                     String columnName = rsmd.getColumnName(pos);
                     ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
                }
                vt.add(ht);
            }
			rs.close();
			pstmt.close();

        } catch (SQLException e) {
            System.out.println("[ParkIODatabase:getParkWashList]"+e);
            System.out.println("[ParkIODatabase:getParkWashList]"+query);
            e.printStackTrace();
        } finally {
            try{
                if(rs != null )     rs.close();
                if(pstmt != null)   pstmt.close();
            }catch(Exception ignore){}
            closeConnection();
            return vt;
        }
    }
    
    // 세차차량 등록 20180704
    public int insertParkWash(ParkBean pbean)
	{
		getConnection();
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		int count3 = 0;
		String query1 = "";
		String query = "";
	 	
		int seq = 0;
		
		query1 = " SELECT NVL(MAX(SEQ)+1,1) FROM PARK_WASH ";
		query = "INSERT INTO PARK_WASH (	\r\n" + 
				"	 	SEQ, RENT_MNG_ID, RENT_L_CD, CAR_MNG_ID, CAR_ST, \r\n" + 
				"	 	CAR_NO, CAR_NM, PARK_ID, REG_DT, REG_ID, \r\n" + 
				"	 	WASH_ETC, REQ_DT, GUBUN_ST, MNG_ID, USERS_COMP, \r\n" + 
				"	 	USER_M_TEL, OFF_ID, WASH_PAY, INCLEAN_PAY, WASH_ST, INCLEAN_ST \r\n" + 
				" )VALUES( \r\n" + 
				" 		?, ?, ?, ?, ?, \r\n" + 
				" 		?, ?, ?, to_char(sysdate,'YYYYMMDD'), ?, \r\n" + 
				" 		?, to_date(replace( ?, '-', '' ) || ? || ?, 'YYYYMMDDhh24mi' ), ?, ?, ?,\r\n" + 
				" 		?, '011617', ?, ?, ?, ? \r\n" + 
				" ) ";
		try 
		{			
			conn.setAutoCommit(false);
			
			pstmt1 = conn.prepareStatement(query1);
            rs = pstmt1.executeQuery();
            
            if(rs.next()) {               
                seq = rs.getInt(1);
            }
            rs.close();
            pstmt1 .close();
				
			pstmt = conn.prepareStatement(query);

			pstmt.setInt(1, seq);
			pstmt.setString(2, pbean.getRent_mng_id());
			pstmt.setString(3, pbean.getRent_l_cd());
			pstmt.setString(4, pbean.getCar_mng_id());
			pstmt.setString(5, pbean.getCar_st());					
			pstmt.setString(6, pbean.getCar_no());
			pstmt.setString(7, pbean.getCar_nm());
			pstmt.setString(8, pbean.getPark_id());
			//pstmt.setString(9, wash_dt);
			//pstmt.setString(9, wash_pay);
			pstmt.setString(9, pbean.getUser_id());
			pstmt.setString(10, pbean.getWash_etc());
			pstmt.setString(11, pbean.getStart_dt());
			pstmt.setString(12, pbean.getStart_h());
			pstmt.setString(13, pbean.getStart_m());
			pstmt.setString(14, pbean.getGubun_st());
			pstmt.setString(15, pbean.getMng_id());
			pstmt.setString(16, pbean.getUsers_comp());
			pstmt.setString(17, pbean.getUser_m_tel());
			pstmt.setString(18, pbean.getWash_pay());
			pstmt.setString(19, pbean.getInclean_pay());
			pstmt.setString(20, pbean.getWash_st());
			pstmt.setString(21, pbean.getInclean_st());
								
			count3 = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();	

		} catch (SQLException e) {
			System.out.println("[ParkIODatabase:insertParkWash]\n"+e);
			System.out.println("[ParkIODatabase:insertParkWash]\n"+query);
	  		e.printStackTrace();
	  		count3 = 0;
			conn.rollback();
		
		} catch (Exception e) {
            System.out.println("[ParkIODatabase:insertParkWash]\n"+e);
            System.out.println("[ParkIODatabase:insertParkWash]\n"+query);
            e.printStackTrace();
            conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(rs != null )		rs.close();
                if(pstmt1 != null)	pstmt1.close();
				if(pstmt != null)	pstmt.close();
				
			}catch(Exception ignore){}
			closeConnection();
			
			return count3;
		}
	}
    
    // 세차차량 등록2 20190128
    public int insertParkWash2(String rent_mng_id, String rent_l_cd, String car_mng_id, String car_st, String car_no, String car_nm, String park_id, String user_id, String wash_etc, String start_dt, String start_h, String start_m, String gubun_st, String mng_id, String users_comp, String user_m_tel, String wash_pay, String inclean_pay, String reason)
	{
		getConnection();
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		int count3 = 0;
		String query1 = "";
		String query = "";
	 	
		int seq = 0;
		
		query1 = " SELECT NVL(MAX(SEQ)+1,1) FROM PARK_WASH ";
		query = " INSERT INTO PARK_WASH \n"+
				" ( SEQ, RENT_MNG_ID, RENT_L_CD, CAR_MNG_ID, " + 
				" CAR_ST, CAR_NO, CAR_NM, PARK_ID, REG_DT, " + 
				" REG_ID, WASH_ETC, REQ_DT, GUBUN_ST, MNG_ID, " + 
				" USERS_COMP, USER_M_TEL, WASH_START, WASH_END, OFF_ID, WASH_DT, WASH_PAY, WASH_USER_ID, WASH_USER_NM, INCLEAN_PAY, REASON )   \n"+
				" VALUES( " + 
				" ?, ?, ?, ?, " + 
				" ?, ?, ?, ?, to_char(sysdate,'YYYYMMDD'), " + 
				" ?, ?, sysdate, ?, ?, " + 
				" ?, ?, sysdate, sysdate, '011617', to_char(sysdate,'YYYYMMDD'), ? , '01033835843', '김태천', ?, ? ) ";
		
		try 
		{			
			conn.setAutoCommit(false);
			
			pstmt1 = conn.prepareStatement(query1);
            rs = pstmt1.executeQuery();
            
            if(rs.next()) {               
                seq = rs.getInt(1);
            }
            rs.close();
            pstmt1 .close();
				
			pstmt = conn.prepareStatement(query);

			pstmt.setInt(1, seq);
			pstmt.setString(2, rent_mng_id);
			pstmt.setString(3, rent_l_cd);
			pstmt.setString(4, car_mng_id);
			pstmt.setString(5, car_st);					
			pstmt.setString(6, car_no);
			pstmt.setString(7, car_nm);
			pstmt.setString(8, park_id);
			//pstmt.setString(9, wash_dt);
			//pstmt.setString(9, wash_pay);
			pstmt.setString(9, user_id);
			pstmt.setString(10, wash_etc);
			//pstmt.setString(11, start_dt);
			//pstmt.setString(12, start_h);
			//pstmt.setString(13, start_m);
			pstmt.setString(11, gubun_st);
			pstmt.setString(12, mng_id);
			pstmt.setString(13, users_comp);
			pstmt.setString(14, user_m_tel);
			pstmt.setString(15, wash_pay);
			pstmt.setString(16, inclean_pay);
			pstmt.setString(17, reason);
								
			count3 = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();	

		} catch (SQLException e) {
			System.out.println("[ParkIODatabase:insertParkWash2]\n"+e);
			System.out.println("[ParkIODatabase:insertParkWash2]\n"+query);
	  		e.printStackTrace();
	  		count3 = 0;
			conn.rollback();
		
		} catch (Exception e) {
            System.out.println("[ParkIODatabase:insertParkWash2]\n"+e);
            System.out.println("[ParkIODatabase:insertParkWash2]\n"+query);
            e.printStackTrace();
            conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(rs != null )		rs.close();
                if(pstmt1 != null)	pstmt1.close();
				if(pstmt != null)	pstmt.close();
				
			}catch(Exception ignore){}
			closeConnection();
			
			return count3;
		}
	}
    
    // 세차차량 수정 20180704
    public int updateParkWash(ParkBean bean)
    {
        getConnection();
        PreparedStatement pstmt = null;
        int count2 = 0;
        String query = "";

        query = " UPDATE PARK_WASH SET " +
		        			" PARK_ID = '"+bean.getPark_id()+"', " + 
		        			" UPDATE_DT = to_char(sysdate,'YYYYMMDD'), " + 
		        			//" WASH_PAY = '"+wash_pay+"', " + 
		        			" WASH_DT = replace('"+bean.getWash_dt()+"','-','') " + 
		        	" WHERE SEQ = " + bean.getPark_seq();

        try 
        {           
            conn.setAutoCommit(false);

            pstmt = conn.prepareStatement(query);
            count2 = pstmt.executeUpdate();
			pstmt.close();

            conn.commit();
            
        } catch (SQLException e) {
            System.out.println("[ParkIODatabase:updateParkWash]\n"+e);
            System.out.println("[ParkIODatabase:updateParkWash]\n"+query);
            e.printStackTrace();
            conn.rollback();
        } catch (Exception e) {
            System.out.println("[ParkIODatabase:updateParkWash]\n"+e);
            System.out.println("[ParkIODatabase:updateParkWash]\n"+query);
            e.printStackTrace();
            conn.rollback();
        } finally {
            try{
                conn.setAutoCommit(true);
                if(pstmt != null)   pstmt.close();
            }catch(Exception ignore){}
            closeConnection();
            return count2;
        }
    }
    
    // 세차차량 수정 20190226
    public int updateParkWashGubun(int park_seq, String wash_pay, String inclean_pay, String gubun_st)
    {
        getConnection();
        PreparedStatement pstmt = null;
        int count2 = 0;
        String query = "";

        query = " UPDATE PARK_WASH SET " +
		        			" WASH_PAY = '"+wash_pay+"', " + 
		        			" INCLEAN_PAY = '"+inclean_pay+"', " + 
		        			" GUBUN_ST = '"+gubun_st+"', " + 
		        			" UPDATE_DT = to_char(sysdate,'YYYYMMDD') " + 
		        	" WHERE SEQ = " + park_seq;

        try 
        {           
            conn.setAutoCommit(false);

            pstmt = conn.prepareStatement(query);
            count2 = pstmt.executeUpdate();
			pstmt.close();

            conn.commit();
            
        } catch (SQLException e) {
            System.out.println("[ParkIODatabase:updateParkWashGubun]\n"+e);
            System.out.println("[ParkIODatabase:updateParkWashGubun]\n"+query);
            e.printStackTrace();
            conn.rollback();
        } catch (Exception e) {
            System.out.println("[ParkIODatabase:updateParkWashGubun]\n"+e);
            System.out.println("[ParkIODatabase:updateParkWashGubun\n"+query);
            e.printStackTrace();
            conn.rollback();
        } finally {
            try{
                conn.setAutoCommit(true);
                if(pstmt != null)   pstmt.close();
            }catch(Exception ignore){}
            closeConnection();
            return count2;
        }
    }
    
    // 세차차량 삭제 20180704
    public int deleteParkWash(int pr_id) throws DatabaseException, DataSourceEmptyException{
    	getConnection();

		PreparedStatement pstmt = null;
        String query = "";
        int f_count = 0;
		int count = 0;
                
		query = " delete from park_wash  where seq = ? ";
    
       try{
    	   conn.setAutoCommit(false);
            			
            pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, pr_id);
			f_count = pstmt.executeUpdate();
			pstmt.close();             

			conn.commit();

        }catch(Exception se){
            try{
				System.out.println("[ParkIODatabase:deleteParkWash]\n"+se);
				conn.rollback();
				f_count = 0;
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
            	conn.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            conn = null;
        }
        return f_count;
    }
    
    // 세차업체별 단가계약내역 20181219
    public Vector getOffWashContList(String off_id)
    {
        getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Vector vt = new Vector();
        String query = "";
        
        query = " SELECT * FROM wash_cont WHERE off_id = '"+off_id+"' ORDER BY seq DESC ";
        
        try {
            pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();
            ResultSetMetaData rsmd = rs.getMetaData();
                
            while(rs.next()) {
                Hashtable ht = new Hashtable();
                for (int pos =1; pos <= rsmd.getColumnCount();pos++) {
                     String columnName = rsmd.getColumnName(pos);
                     ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
                }
                vt.add(ht);
            }
			rs.close();
			pstmt.close();

        } catch (SQLException e) {
            System.out.println("[ParkIODatabase:getOffWashContList]"+e);
            System.out.println("[ParkIODatabase:getOffWashContList]"+query);
            e.printStackTrace();
        } finally {
            try{
                if(rs != null )     rs.close();
                if(pstmt != null)   pstmt.close();
            }catch(Exception ignore){}
            closeConnection();
            return vt;
        }
    }
    
    // 세차업체별 단가계약등록 20181219
    public int insertOffWashCont(String off_id, String wash_pay, String apply_dt, String cont_etc, String est_st, String gubun)
	{
		getConnection();
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		int count3 = 0;
		String query1 = "";
		String query = "";
	 	
		int seq = 0;
		
		query1 = " SELECT NVL(MAX(SEQ)+1,1) FROM WASH_CONT ";
		query = " INSERT INTO WASH_CONT \n"+
				" ( SEQ, off_id, wash_pay, apply_dt, cont_etc, est_st, gubun )   \n"+
				" VALUES( ?, ?, ?, ?, ?, ?, ?) ";
		
		try 
		{			
			conn.setAutoCommit(false);
			
			pstmt1 = conn.prepareStatement(query1);
            rs = pstmt1.executeQuery();
            
            if(rs.next()) {               
                seq = rs.getInt(1);
            }
            rs.close();
            pstmt1 .close();
				
			pstmt = conn.prepareStatement(query);

			pstmt.setInt(1, seq);
			pstmt.setString(2, off_id);
			pstmt.setString(3, wash_pay);
			pstmt.setString(4, apply_dt);
			pstmt.setString(5, cont_etc);					
			pstmt.setString(6, est_st);
			pstmt.setString(7, gubun);
								
			count3 = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();	

		} catch (SQLException e) {
			System.out.println("[ParkIODatabase:insertOffWashUser]\n"+e);
			System.out.println("[ParkIODatabase:insertOffWashUser]\n"+query);
	  		e.printStackTrace();
	  		count3 = 0;
			conn.rollback();
		
		} catch (Exception e) {
            System.out.println("[ParkIODatabase:insertOffWashUser]\n"+e);
            System.out.println("[ParkIODatabase:insertOffWashUser]\n"+query);
            e.printStackTrace();
            conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(rs != null )		rs.close();
                if(pstmt1 != null)	pstmt1.close();
				if(pstmt != null)	pstmt.close();
				
			}catch(Exception ignore){}
			closeConnection();
			
			return count3;
		}
	}
    
    // 세차업체 종사자 리스트 20181219
    public Vector getOffWashUserList(String off_id)
    {
        getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Vector vt = new Vector();
        String query = "";
        
        query = " SELECT * FROM WASH_USER WHERE off_id = '"+off_id+"' ";
        
        try {
            pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();
            ResultSetMetaData rsmd = rs.getMetaData();
                
            while(rs.next()) {
                Hashtable ht = new Hashtable();
                for (int pos =1; pos <= rsmd.getColumnCount();pos++) {
                     String columnName = rsmd.getColumnName(pos);
                     ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
                }
                vt.add(ht);
            }
			rs.close();
			pstmt.close();

        } catch (SQLException e) {
            System.out.println("[ParkIODatabase:getOffWashUserList]"+e);
            System.out.println("[ParkIODatabase:getOffWashUserList]"+query);
            e.printStackTrace();
        } finally {
            try{
                if(rs != null )     rs.close();
                if(pstmt != null)   pstmt.close();
            }catch(Exception ignore){}
            closeConnection();
            return vt;
        }
    }
    
    // 세차업체 종사자등록 20181219
    public int insertOffWashUser(String off_id, String wash_user_nm, String wash_user_id, String wash_user_zip, String wash_user_addr, String wash_user_enter_dt)
	{
		getConnection();
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		int count3 = 0;
		String query1 = "";
		String query = "";
	 	
		int seq = 0;
		
		query1 = " SELECT NVL(MAX(SEQ)+1,1) FROM WASH_USER ";
		query = " INSERT INTO WASH_USER \n"+
				" ( SEQ, off_id, wash_user_nm, wash_user_id, wash_user_zip, wash_user_addr, wash_user_enter_dt )   \n"+
				" VALUES( ?, ?, ?, ?, ?, ?, ? ) ";
		
		try 
		{			
			conn.setAutoCommit(false);
			
			pstmt1 = conn.prepareStatement(query1);
            rs = pstmt1.executeQuery();
            
            if(rs.next()) {               
                seq = rs.getInt(1);
            }
            rs.close();
            pstmt1 .close();
				
			pstmt = conn.prepareStatement(query);

			pstmt.setInt(1, seq);
			pstmt.setString(2, off_id);
			pstmt.setString(3, wash_user_nm);
			pstmt.setString(4, wash_user_id);
			pstmt.setString(5, wash_user_zip);					
			pstmt.setString(6, wash_user_addr);
			pstmt.setString(7, wash_user_enter_dt);
								
			count3 = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();	

		} catch (SQLException e) {
			System.out.println("[ParkIODatabase:insertOffWashUser]\n"+e);
			System.out.println("[ParkIODatabase:insertOffWashUser]\n"+query);
	  		e.printStackTrace();
	  		count3 = 0;
			conn.rollback();
		
		} catch (Exception e) {
            System.out.println("[ParkIODatabase:insertOffWashUser]\n"+e);
            System.out.println("[ParkIODatabase:insertOffWashUser]\n"+query);
            e.printStackTrace();
            conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(rs != null )		rs.close();
                if(pstmt1 != null)	pstmt1.close();
				if(pstmt != null)	pstmt.close();
				
			}catch(Exception ignore){}
			closeConnection();
			
			return count3;
		}
	}
    
    // 세차업체 종사자수정 20181219
    public int updateOffWashUser(int seq, String wash_user_nm, String wash_user_id, String wash_user_zip, String wash_user_addr, String wash_user_enter_dt, String wash_user_end_dt)
    {
        getConnection();
        PreparedStatement pstmt = null;
        int count2 = 0;
        String query = "";

        query = " UPDATE WASH_USER SET " +
		        			" wash_user_id = '"+wash_user_id+"', " +  
		        			" wash_user_nm = '"+wash_user_nm+"', " + 
		        			" wash_user_zip = '"+wash_user_zip+"', " + 
		        			" wash_user_addr = '"+wash_user_addr+"', " + 
		        			" wash_user_enter_dt = '"+wash_user_enter_dt+"', " + 
		        			" wash_user_end_dt = '"+wash_user_end_dt+"' " + 
		        	" WHERE SEQ = " + seq;

        try 
        {           
            conn.setAutoCommit(false);

            pstmt = conn.prepareStatement(query);
            count2 = pstmt.executeUpdate();
			pstmt.close();

            conn.commit();
            
        } catch (SQLException e) {
            System.out.println("[ParkIODatabase:updateOffWashUser]\n"+e);
            System.out.println("[ParkIODatabase:updateOffWashUser]\n"+query);
            e.printStackTrace();
            conn.rollback();
        } catch (Exception e) {
            System.out.println("[ParkIODatabase:updateOffWashUser]\n"+e);
            System.out.println("[ParkIODatabase:updateOffWashUser]\n"+query);
            e.printStackTrace();
            conn.rollback();
        } finally {
            try{
                conn.setAutoCommit(true);
                if(pstmt != null)   pstmt.close();
            }catch(Exception ignore){}
            closeConnection();
            return count2;
        }
    }
    
  //주차장 입출고현황 리스트 (2019.01.11)
    public Vector getUser_list(String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";		
		
		query = " SELECT user_id, user_nm, user_work, use_yn FROM users WHERE user_nm LIKE '%"+t_wd+"%'";
		
		query += " ORDER BY user_id DESC ";
		
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
			System.out.println("[ParkIODatabase:getUser_list]"+e);
			System.out.println("[ParkIODatabase:getUser_list]"+query);
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
    
    public Hashtable getParkIOInfo(String car_mng_id){
    	getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		int count = 0;
		String query = "";
		
        query = " SELECT 	* \r\n" + 
        		"	FROM 	park_io a, \r\n" + 
        		" 	  		(	SELECT car_mng_id, max(park_seq) seq \r\n" + 
        		" 	  			FROM park_io where io_gubun in ('1','2') \r\n" + 
        		" 	  			GROUP BY car_mng_id) b \r\n" + 
        		"	WHERE a.CAR_MNG_ID = b.car_mng_id and a.park_seq = b.seq \r\n" + 
        		"	AND a.car_mng_id ='"+car_mng_id+"' ";

  	try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery(); 
			ResultSetMetaData rsmd = rs.getMetaData();

			if(rs.next()){	
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ParkIODatabase:getParkIOInfo]"+e);
			System.out.println("[ParkIODatabase:getParkIOInfo]"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )			rs.close();
                if(pstmt != null)		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
    }
    
    public int insertParkIOInfo(ParkIOBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Statement stmt = null;
		int count = 0;
		String query = "";
		String query_seq = "";
		System.out.println(bean.getCar_gita());
		int seq = 0;

 	  	query_seq = "select nvl(max(park_seq)+1, 1)  from park_io where car_mng_id = '" + bean.getCar_mng_id() + "'";	


		query = "	INSERT INTO PARK_IO \r\n" + 
				" (	\r\n" + 
				"	CAR_MNG_ID, PARK_SEQ, PARK_ID, REG_ID, IO_GUBUN, \r\n" + 
				"	CAR_ST, CAR_NO, CAR_NM, CAR_KM, IO_DT,\r\n" + 
				"	USERS_COMP, START_PLACE, END_PLACE, DRIVER_NM, BR_ID, \r\n" + 
				"	REG_DT, PARK_MNG, USE_YN,  RENT_L_CD, CAR_GITA \r\n" + 
				" \r\n" + 
				" )	VALUES   \r\n" + 
				" (	\r\n" + 
				" 	?, ?, ?, ?, ?, \r\n" + 
				"	?, ?, ?, ?, TO_CHAR(sysdate,'YYYYMMDD'), \r\n" + 
				"	?, ?, ?, ?, ?, \r\n" + 
				"	 SYSDATE,?, ?, ?, ? \r\n" + 
				" )";

		try 
		{			
			conn.setAutoCommit(false);
			
  			stmt = conn.createStatement();
            rs = stmt.executeQuery(query_seq);
         
            if(rs.next())
            	seq = rs.getInt(1);
            rs.close();
			stmt.close();
				
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getCar_mng_id());
			pstmt.setInt(2, seq);
			pstmt.setString(3, bean.getPark_id());
			pstmt.setString(4, bean.getReg_id());
			pstmt.setString(5, bean.getIo_gubun());
			pstmt.setString(6, bean.getCar_st());
			pstmt.setString(7, bean.getCar_no());
			pstmt.setString(8, bean.getCar_nm());
			pstmt.setInt(9, bean.getCar_km());
			
			pstmt.setString(10, bean.getUsers_comp());
			pstmt.setString(11, bean.getStart_place());
			pstmt.setString(12, bean.getEnd_place());
			pstmt.setString(13, bean.getDriver_nm());
			pstmt.setString(14, bean.getBr_id());

			pstmt.setString(15, bean.getPark_mng());
			pstmt.setString(16, bean.getUse_yn());
			pstmt.setString(17, bean.getRent_l_cd());
			pstmt.setString(18, bean.getCar_gita());
			
			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[ParkIODatabase:insertParkIO]\n"+e);
			System.out.println("[ParkIODatabase:insertParkIO]\n"+query);
	  		e.printStackTrace();
	  		seq = 0;
			conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(rs != null) rs.close();
                if(stmt != null) stmt.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return seq;
		}
	}

    // 세차현황 - 재리스/월렌트 출고예정현황
    public Vector getParkWashEstList()
    {
        getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Vector vt = new Vector();
        String query = "";
        
        query = " SELECT \r\n"
        		+ "       b.car_no, b.car_nm, DECODE(a.car_st,'4','월렌트','재리스') car_st, a.rent_l_cd, a.rent_dt, DECODE(a.car_st,'4',a.rent_dt,c.car_deli_est_dt) car_deli_est_dt, a.rent_start_dt, d.user_nm, a.reg_dt\r\n"
        		+ "FROM   cont a, car_reg b, cont_etc c, users d\r\n"
        		+ "WHERE  (a.use_yn IS NULL OR a.use_yn='Y')\r\n"
        		+ "AND (a.rent_start_dt = TO_CHAR(SYSDATE,'YYYYMMDD') OR a.rent_start_dt IS NULL) \r\n"
        		+ "AND (a.car_gu='0' OR a.car_st='4') \r\n"
        		+ "AND a.car_mng_id=b.car_mng_id \r\n"
        		+ "AND a.rent_mng_id=c.rent_mng_id AND a.rent_l_cd=c.rent_l_cd\r\n"
        		+ "AND a.bus_id=d.user_id \r\n"
        		+ "AND car_deli_est_dt >= to_char(sysdate,'YYYYMMDD') \r\n"
        		+ "ORDER BY a.rent_start_dt, DECODE(a.car_st,'4',a.rent_dt,c.car_deli_est_dt) ";        
               
        try {
            pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();
            ResultSetMetaData rsmd = rs.getMetaData();
                
            while(rs.next()) {
                Hashtable ht = new Hashtable();
                for (int pos =1; pos <= rsmd.getColumnCount();pos++) {
                     String columnName = rsmd.getColumnName(pos);
                     ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
                }
                vt.add(ht);
            }
			rs.close();
			pstmt.close();

        } catch (SQLException e) {
            System.out.println("[ParkIODatabase:getParkWashEstList]"+e);
            System.out.println("[ParkIODatabase:getParkWashEstList]"+query);
            e.printStackTrace();
        } finally {
            try{
                if(rs != null )     rs.close();
                if(pstmt != null)   pstmt.close();
            }catch(Exception ignore){}
            closeConnection();
            return vt;
        }
    }        
    
}