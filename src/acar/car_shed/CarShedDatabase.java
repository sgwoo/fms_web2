package acar.car_shed;

import java.sql.*;
import java.util.*;
import acar.database.*;

public class CarShedDatabase
{
	private Connection conn = null;
	public static CarShedDatabase db;
	
	public static CarShedDatabase getInstance()
	{
		if(CarShedDatabase.db == null)
			CarShedDatabase.db = new CarShedDatabase();
		return CarShedDatabase.db;
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
	 *	차고지 INSERT
	 */

	public boolean insertCarShed(CarShedBean shed)
	{
		getConnection();
		boolean flag = true;
		String query_seq = "SELECT LTRIM(NVL(TO_CHAR(MAX(TO_NUMBER(shed_id))+1, '0000'), '0001')) id"+
							" FROM CAR_SHED";

		String query = "insert into CAR_SHED (SHED_ID, SHED_NM, MNG_OFF, MNG_AGNT, LEA_NM, LEA_COMP_NM, LEA_STA,"+
						" LEA_SSN, LEA_ENT_NO, LEA_ITEM, LEA_H_POST, LEA_H_ADDR, LEA_H_TEL, LEA_O_POST, LEA_O_ADDR,"+
						" LEA_O_TEL, LEA_TAX_ST, LEA_FAX, LEA_M_TEL, LEA_ST, LEA_ST_DT, LEA_END_DT, LEND_OWN_NM,"+
						" LEND_COMP_NM, LEND_STA, LEND_SSN, LEND_ENT_NO, LEND_ITEM, LEND_H_POST, LEND_H_ADDR,"+
						" LEND_O_POST, LEND_O_ADDR, LEND_POST, LEND_ADDR, LEND_H_TEL, LEND_O_TEL, LEND_M_TEL,"+
						" LEND_TAX, LEND_REL, LEND_FAX, LEND_TOT_AR, LEND_MNG_AGNT, LEND_REGION, LEND_CAP_AR,"+
						" LEND_GOV, LEND_CLA, SHED_ST, BJG_AMT, WSG_AMT, HSJSG_AMT, CAR_LEND, CAR_LEND_AMT, CAR_LEND_DT, IM_IN_DT, "+
						" USE_YN, LEND_CAP_CAR, CONT_AMT "+	//20190711
						") values"+
						" (?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
						" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
						" replace(?, '-', ''), replace(?, '-', ''), ?, ?, ?, ?, ?, ?, ?, ?,"+
						" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
						" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, replace(?, '-', ''), replace(?, '-', ''),?,?,?)";
						
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
				shed.setShed_id(rs.getString("id")==null?"0001":rs.getString("id"));
			}
			rs.close();
			pstmt1.close();

			pstmt2 = conn.prepareStatement(query);
			pstmt2.setString(1,  shed.getShed_id());
			pstmt2.setString(2,  shed.getShed_nm());
			pstmt2.setString(3,  shed.getMng_off());
			pstmt2.setString(4,  shed.getMng_agnt());
			pstmt2.setString(5,  shed.getLea_nm());
			pstmt2.setString(6,  shed.getLea_comp_nm());
			pstmt2.setString(7,  shed.getLea_sta());
			pstmt2.setString(8,  shed.getLea_ssn());
			pstmt2.setString(9,  shed.getLea_ent_no());
			pstmt2.setString(10, shed.getLea_item());
			pstmt2.setString(11, shed.getLea_h_post());
			pstmt2.setString(12, shed.getLea_h_addr());
			pstmt2.setString(13, shed.getLea_h_tel());
			pstmt2.setString(14, shed.getLea_o_post());
			pstmt2.setString(15, shed.getLea_o_addr());
			pstmt2.setString(16, shed.getLea_o_tel());
			pstmt2.setString(17, shed.getLea_tax_st());
			pstmt2.setString(18, shed.getLea_fax());
			pstmt2.setString(19, shed.getLea_m_tel());
			pstmt2.setString(20, shed.getLea_st());
			pstmt2.setString(21, shed.getLea_st_dt());
			pstmt2.setString(22, shed.getLea_end_dt());
			pstmt2.setString(23, shed.getLend_own_nm());
			pstmt2.setString(24, shed.getLend_comp_nm());
			pstmt2.setString(25, shed.getLend_sta());
			pstmt2.setString(26, shed.getLend_ssn());
			pstmt2.setString(27, shed.getLend_ent_no());
			pstmt2.setString(28, shed.getLend_item());
			pstmt2.setString(29, shed.getLend_h_post());
			pstmt2.setString(30, shed.getLend_h_addr());
			pstmt2.setString(31, shed.getLend_o_post());
			pstmt2.setString(32, shed.getLend_o_addr());
			pstmt2.setString(33, shed.getLend_post());
			pstmt2.setString(34, shed.getLend_addr());
			pstmt2.setString(35, shed.getLend_h_tel());
			pstmt2.setString(36, shed.getLend_o_tel());
			pstmt2.setString(37, shed.getLend_m_tel());
			pstmt2.setString(38, shed.getLend_tax());
			pstmt2.setString(39, shed.getLend_rel());
			pstmt2.setString(40, shed.getLend_fax());
			pstmt2.setString(41, shed.getLend_tot_ar());
			pstmt2.setString(42, shed.getLend_mng_agnt());
			pstmt2.setString(43, shed.getLend_region());
			pstmt2.setString(44, shed.getLend_cap_ar());
			pstmt2.setString(45, shed.getLend_gov());
			pstmt2.setString(46, shed.getLend_cla());

			pstmt2.setString(47, shed.getShed_st());
			pstmt2.setInt(48, shed.getBjg_amt());
			pstmt2.setInt(49, shed.getWsg_amt());
			pstmt2.setInt(50, shed.getHsjsg_amt());
			pstmt2.setString(51, shed.getCar_lend());
			pstmt2.setInt(52, shed.getCar_lend_amt());
			pstmt2.setString(53, shed.getCar_lend_dt());
			pstmt2.setString(54, shed.getIm_in_dt());
			pstmt2.setString(55, shed.getUse_yn());
			pstmt2.setString(56, shed.getLend_cap_car());
			pstmt2.setString(57, shed.getCont_amt());

		    pstmt2.executeUpdate();
			pstmt2.close();



			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[CarShedDatabase:insertCarShed]\n"+e);			
			System.out.println("[CarShedDatabase:insertCarShed]\n"+query);
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
	 *	차고지 UPDATE
	 */
	public boolean updateCarShed(CarShedBean shed)
	{
		getConnection();
		boolean flag = true;
		String query = "update CAR_SHED set"+
							" shed_nm = ?,"+
							" mng_off = ?,"+
							" mng_agnt = ?,"+
							" lea_nm = ?,"+
							" lea_comp_nm = ?,"+
							" lea_sta = ?,"+
							" lea_ssn = ?,"+
							" lea_ent_no = ?,"+
							" lea_item = ?,"+
							" lea_h_post = ?,"+
							" lea_h_addr = ?,"+
							" lea_h_tel = ?,"+
							" lea_o_post = ?,"+
							" lea_o_addr = ?,"+
							" lea_o_tel = ?,"+
							" lea_tax_st = ?,"+
							" lea_fax = ?,"+
							" lea_m_tel = ?,"+
							" lea_st = ?,"+
							" lea_st_dt = replace(?, '-', ''),"+
							" lea_end_dt = replace(?, '-', ''),"+
							" lend_own_nm = ?,"+
							" lend_comp_nm = ?,"+
							" lend_sta = ?,"+
							" lend_ssn = ?,"+
							" lend_ent_no = ?,"+
							" lend_item = ?,"+
							" lend_h_post = ?,"+
							" lend_h_addr = ?,"+
							" lend_o_post = ?,"+
							" lend_o_addr = ?,"+
							" lend_post = ?,"+
							" lend_addr = ?,"+
							" lend_h_tel = ?,"+
							" lend_o_tel = ?,"+
							" lend_m_tel = ?,"+
							" lend_tax = ?,"+
							" lend_rel = ?,"+
							" lend_fax = ?,"+
							" lend_tot_ar = ?,"+
							" lend_mng_agnt = ?,"+
							" lend_region = ?,"+
							" lend_cap_ar = ?,"+
							" lend_gov = ?,"+
							" lend_cla = ?,"+

							" shed_st = ?,"+
							" bjg_amt =  ?,"+
							" wsg_amt =  ?,"+
							" hsjsg_amt =  ?,"+
							" car_lend = ?,"+
							" car_lend_amt =  ?,"+
							" car_lend_dt = replace(?, '-', ''),"+
							" im_in_dt = replace(?, '-', ''),"+
							" use_yn = ?, "+	//	20190711
							" lend_cap_car = ?, "+	
							" cont_amt = ? "+		

						" where shed_id = ?";
							
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  shed.getShed_nm());
			pstmt.setString(2,  shed.getMng_off());
			pstmt.setString(3,  shed.getMng_agnt());
			pstmt.setString(4,  shed.getLea_nm());
			pstmt.setString(5,  shed.getLea_comp_nm());
			pstmt.setString(6,  shed.getLea_sta());
			pstmt.setString(7,  shed.getLea_ssn());
			pstmt.setString(8,  shed.getLea_ent_no());
			pstmt.setString(9,  shed.getLea_item());
			pstmt.setString(10, shed.getLea_h_post());
			pstmt.setString(11, shed.getLea_h_addr());
			pstmt.setString(12, shed.getLea_h_tel());
			pstmt.setString(13, shed.getLea_o_post());
			pstmt.setString(14, shed.getLea_o_addr());
			pstmt.setString(15, shed.getLea_o_tel());
			pstmt.setString(16, shed.getLea_tax_st());
			pstmt.setString(17, shed.getLea_fax());
			pstmt.setString(18, shed.getLea_m_tel());
			pstmt.setString(19, shed.getLea_st());
			pstmt.setString(20, shed.getLea_st_dt());
			pstmt.setString(21, shed.getLea_end_dt());
			pstmt.setString(22, shed.getLend_own_nm());
			pstmt.setString(23, shed.getLend_comp_nm());
			pstmt.setString(24, shed.getLend_sta());
			pstmt.setString(25, shed.getLend_ssn());
			pstmt.setString(26, shed.getLend_ent_no());
			pstmt.setString(27, shed.getLend_item());
			pstmt.setString(28, shed.getLend_h_post());
			pstmt.setString(29, shed.getLend_h_addr());
			pstmt.setString(30, shed.getLend_o_post());
			pstmt.setString(31, shed.getLend_o_addr());
			pstmt.setString(32, shed.getLend_post());
			pstmt.setString(33, shed.getLend_addr());
			pstmt.setString(34, shed.getLend_h_tel());
			pstmt.setString(35, shed.getLend_o_tel());
			pstmt.setString(36, shed.getLend_m_tel());
			pstmt.setString(37, shed.getLend_tax());
			pstmt.setString(38, shed.getLend_rel());
			pstmt.setString(39, shed.getLend_fax());
			pstmt.setString(40, shed.getLend_tot_ar());
			pstmt.setString(41, shed.getLend_mng_agnt());
			pstmt.setString(42, shed.getLend_region());
			pstmt.setString(43, shed.getLend_cap_ar());
			pstmt.setString(44, shed.getLend_gov());
			pstmt.setString(45, shed.getLend_cla());

			pstmt.setString(46, shed.getShed_st());
			pstmt.setInt(47, shed.getBjg_amt());
			pstmt.setInt(48, shed.getWsg_amt());
			pstmt.setInt(49, shed.getHsjsg_amt());
			pstmt.setString(50, shed.getCar_lend());
			pstmt.setInt(51, shed.getCar_lend_amt());
			pstmt.setString(52, shed.getCar_lend_dt());
			pstmt.setString(53, shed.getIm_in_dt());
			pstmt.setString(54, shed.getUse_yn());
			pstmt.setString(55, shed.getLend_cap_car());
			pstmt.setString(56, shed.getCont_amt());

			pstmt.setString(57, shed.getShed_id());

			pstmt.executeUpdate();
			pstmt.close();
		    
			conn.commit();
	  	} catch (Exception e) {

			System.out.println("[CarShedDatabase:updateCarShed]\n"+e);			
			System.out.println("[CarShedDatabase:updateCarShed]\n"+query);		
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
	 * 차고지 SELECT
	 */
	public CarShedBean getCarShed(String shed_id)
	{
		getConnection();
		CarShedBean shed = new CarShedBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	" SELECT SHED_ID, SHED_NM, MNG_OFF, MNG_AGNT, LEA_NM, LEA_COMP_NM, LEA_STA, LEA_SSN, LEA_ENT_NO,"+
								" LEA_ITEM, LEA_H_POST, LEA_H_ADDR, LEA_H_TEL, LEA_O_POST, LEA_O_ADDR, LEA_O_TEL, LEA_TAX_ST,"+
								" LEA_FAX, LEA_M_TEL, LEA_ST, LEND_OWN_NM, LEND_COMP_NM, LEND_STA,"+
								" LEND_SSN, LEND_ENT_NO, LEND_ITEM, LEND_H_POST, LEND_H_ADDR, LEND_O_POST, LEND_O_ADDR,"+
								" LEND_POST, LEND_ADDR, LEND_H_TEL, LEND_O_TEL, LEND_M_TEL, LEND_TAX, LEND_REL, LEND_FAX,"+
								" LEND_TOT_AR, LEND_MNG_AGNT, LEND_REGION, LEND_CAP_AR, LEND_GOV, LEND_CLA, USE_YN, LEND_CAP_CAR, CONT_AMT,"+
						 		" decode(LEA_ST_DT, '', '', substr(LEA_ST_DT, 1, 4)||'-'||substr(LEA_ST_DT, 5, 2)||'-'||substr(LEA_ST_DT, 7, 2)) LEA_ST_DT,"+
						 		" decode(LEA_END_DT, '', '', substr(LEA_END_DT, 1, 4)||'-'||substr(LEA_END_DT, 5, 2)||'-'||substr(LEA_END_DT, 7, 2)) LEA_END_DT "+
								" FROM CAR_SHED"+
								" WHERE SHED_ID = '"+shed_id+"'";
		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
			while(rs.next())
			{
				shed.setShed_id(rs.getString("SHED_ID")==null?"":rs.getString("SHED_ID"));
				shed.setShed_nm(rs.getString("SHED_NM")==null?"":rs.getString("SHED_NM"));
				shed.setMng_off(rs.getString("MNG_OFF")==null?"":rs.getString("MNG_OFF"));
				shed.setMng_agnt(rs.getString("MNG_AGNT")==null?"":rs.getString("MNG_AGNT"));
				shed.setLea_nm(rs.getString("LEA_NM")==null?"":rs.getString("LEA_NM"));
				shed.setLea_comp_nm(rs.getString("LEA_COMP_NM")==null?"":rs.getString("LEA_COMP_NM"));
				shed.setLea_sta(rs.getString("LEA_STA")==null?"":rs.getString("LEA_STA"));
				shed.setLea_ssn(rs.getString("LEA_SSN")==null?"":rs.getString("LEA_SSN"));
				shed.setLea_ent_no(rs.getString("LEA_ENT_NO")==null?"":rs.getString("LEA_ENT_NO"));
				shed.setLea_item(rs.getString("LEA_ITEM")==null?"":rs.getString("LEA_ITEM"));
				shed.setLea_h_post(rs.getString("LEA_H_POST")==null?"":rs.getString("LEA_H_POST"));
				shed.setLea_h_addr(rs.getString("LEA_H_ADDR")==null?"":rs.getString("LEA_H_ADDR"));
				shed.setLea_h_tel(rs.getString("LEA_H_TEL")==null?"":rs.getString("LEA_H_TEL"));
				shed.setLea_o_post(rs.getString("LEA_O_POST")==null?"":rs.getString("LEA_O_POST"));
				shed.setLea_o_addr(rs.getString("LEA_O_ADDR")==null?"":rs.getString("LEA_O_ADDR"));
				shed.setLea_o_tel(rs.getString("LEA_O_TEL")==null?"":rs.getString("LEA_O_TEL"));
				shed.setLea_tax_st(rs.getString("LEA_TAX_ST")==null?"":rs.getString("LEA_TAX_ST"));
				shed.setLea_fax(rs.getString("LEA_FAX")==null?"":rs.getString("LEA_FAX"));
				shed.setLea_m_tel(rs.getString("LEA_M_TEL")==null?"":rs.getString("LEA_M_TEL"));
				shed.setLea_st(rs.getString("LEA_ST")==null?"":rs.getString("LEA_ST"));
				shed.setLea_st_dt(rs.getString("LEA_ST_DT")==null?"":rs.getString("LEA_ST_DT"));
				shed.setLea_end_dt(rs.getString("LEA_END_DT")==null?"":rs.getString("LEA_END_DT"));
				shed.setLend_own_nm(rs.getString("LEND_OWN_NM")==null?"":rs.getString("LEND_OWN_NM"));
				shed.setLend_comp_nm(rs.getString("LEND_COMP_NM")==null?"":rs.getString("LEND_COMP_NM"));
				shed.setLend_sta(rs.getString("LEND_STA")==null?"":rs.getString("LEND_STA"));
				shed.setLend_ssn(rs.getString("LEND_SSN")==null?"":rs.getString("LEND_SSN"));
				shed.setLend_ent_no(rs.getString("LEND_ENT_NO")==null?"":rs.getString("LEND_ENT_NO"));
				shed.setLend_item(rs.getString("LEND_ITEM")==null?"":rs.getString("LEND_ITEM"));
				shed.setLend_h_post(rs.getString("LEND_H_POST")==null?"":rs.getString("LEND_H_POST"));
				shed.setLend_h_addr(rs.getString("LEND_H_ADDR")==null?"":rs.getString("LEND_H_ADDR"));
				shed.setLend_o_post(rs.getString("LEND_O_POST")==null?"":rs.getString("LEND_O_POST"));
				shed.setLend_o_addr(rs.getString("LEND_O_ADDR")==null?"":rs.getString("LEND_O_ADDR"));
				shed.setLend_post(rs.getString("LEND_POST")==null?"":rs.getString("LEND_POST"));
				shed.setLend_addr(rs.getString("LEND_ADDR")==null?"":rs.getString("LEND_ADDR"));
				shed.setLend_h_tel(rs.getString("LEND_H_TEL")==null?"":rs.getString("LEND_H_TEL"));
				shed.setLend_o_tel(rs.getString("LEND_O_TEL")==null?"":rs.getString("LEND_O_TEL"));
				shed.setLend_m_tel(rs.getString("LEND_M_TEL")==null?"":rs.getString("LEND_M_TEL"));
				shed.setLend_tax(rs.getString("LEND_TAX")==null?"":rs.getString("LEND_TAX"));
				shed.setLend_rel(rs.getString("LEND_REL")==null?"":rs.getString("LEND_REL"));
				shed.setLend_fax(rs.getString("LEND_FAX")==null?"":rs.getString("LEND_FAX"));
				shed.setLend_tot_ar(rs.getString("LEND_TOT_AR")==null?"":rs.getString("LEND_TOT_AR"));
				shed.setLend_mng_agnt(rs.getString("LEND_MNG_AGNT")==null?"":rs.getString("LEND_MNG_AGNT"));
				shed.setLend_region(rs.getString("LEND_REGION")==null?"":rs.getString("LEND_REGION"));
				shed.setLend_cap_ar(rs.getString("LEND_CAP_AR")==null?"":rs.getString("LEND_CAP_AR"));
				shed.setLend_gov(rs.getString("LEND_GOV")==null?"":rs.getString("LEND_GOV"));
				shed.setLend_cla(rs.getString("LEND_CLA")==null?"":rs.getString("LEND_CLA"));
				shed.setUse_yn(rs.getString("USE_YN")==null?"":rs.getString("USE_YN"));	//20190711
				shed.setLend_cap_car(rs.getString("LEND_CAP_CAR")==null?"":rs.getString("LEND_CAP_CAR"));
				shed.setCont_amt(rs.getString("CONT_AMT")==null?"":rs.getString("CONT_AMT"));
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
			return shed;
		}
	}


	/**
	 *	차고지 리스트
	 */
	public Vector getCarShedList(String brch, String shed_st, String gubun1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = " SELECT C.shed_id shed_id, nvl(C.shed_nm,'-') shed_nm, B.br_nm br_nm, C.mng_agnt mng_agnt, C.lend_tot_ar lend_tot_ar, C.lend_cap_ar lend_cap_ar,"+
								" C.lend_cap_car, "+	//20190711
								" decode(C.lea_st_dt, '', '', substr(C.lea_st_dt, 1, 4)||'-'||substr(C.lea_st_dt, 5, 2)||'-'||substr(C.lea_st_dt, 7, 2)) lea_st_dt,"+
								" decode(C.lea_end_dt, '', '', substr(C.lea_end_dt, 1, 4)||'-'||substr(C.lea_end_dt, 5, 2)||'-'||substr(C.lea_end_dt, 7, 2)) lea_end_dt,"+
								" decode(C.use_yn,'N','종료','진행') use_yn, c.shed_st, C.lea_st "+
						" FROM  car_shed C, branch B"+
						" WHERE C.mng_off = B.br_id(+)";
		
		if(!brch.equals("")) 			query += " and C.mng_off like '%"+brch+"%'";
		if(!shed_st.equals("")) 		query += " and C.shed_st like '%"+shed_st+"%'";
		if(!gubun1.equals("")){	//진행중, 계약만료 구분(20190711)
			if(gubun1.equals("1"))		query += " AND C.use_yn = 'Y' ";
			if(gubun1.equals("2"))		query += " AND C.use_yn = 'N' ";
		}

		query += " order by C.lea_end_dt desc ";

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
	 *	건물관리 월별관리비 입력
	 */

	public boolean insertCarShedAmt(CarShedAmtBean sheda)

	{
		getConnection();
		boolean flag = true;

		String query = "insert into CAR_SHED_AMT (SHED_ID, REG_ID, REG_DT, MNG_DT, M_AMT, P_AMT, H_AMT, S_AMT, U_AMT, C_AMT"+
						") values"+
						" (?, ?, to_char(sysdate,'YYYYMMDD'), to_char(sysdate,'YYYYMM'), ?, ?, ?, ?, ?, ? )";
							
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1,  sheda.getShed_id());
			pstmt.setString(2,  sheda.getReg_id());
			pstmt.setInt(3,  sheda.getM_amt());
			pstmt.setInt(4,  sheda.getP_amt());
			pstmt.setInt(5,  sheda.getH_amt());
			pstmt.setInt(6,  sheda.getS_amt());
			pstmt.setInt(7,  sheda.getU_amt());
			pstmt.setInt(8,  sheda.getC_amt());

			pstmt.executeUpdate();
			pstmt.close();
		    
			conn.commit();
	  	} catch (Exception e) {

	System.out.println("CarShedDatabase:insertCarShedAmt="+e);
	System.out.println("CarShedDatabase:insertCarShedAmt="+query);

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



public Vector getCarShedAmtList(String shed_id, String save_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select * from car_shed_amt where shed_id = '"+shed_id+"' AND substr(mng_dt,0,4) = '"+save_dt+"' order by mng_dt asc";

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
			System.out.println("[CarShedDatabase:getCarShedAmtList]\n"+e);
			System.out.println("[CarShedDatabase:getCarShedAmtList]\n"+query);
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



/*건물관리 불러오기*/
public Hashtable  getCarShedlist(String shed_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";


		query = " select * from car_shed where shed_id = '"+shed_id+"'";

      
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
			System.out.println("[CarShedDatabase:getCarShedlist]\n"+e);			
			System.out.println("[CarShedDatabase:getCarShedlist]\n"+query);			
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
	 *	리스트조회
	 */
	 public Vector getStatList(String table_nm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query= " select"+
				" DISTINCT decode(reg_dt, '', '', substr(reg_dt, 1, 4)) save_dt  ";

		if(table_nm.equals("car_shed_amt")) query += " , max(substr(reg_dt, 1, 4)) reg_dt  ";

		query += " from "+table_nm+" ";
	
		// 날짜 제한 2007년 이전은 안보이게	
		query += " where (reg_dt > to_char(sysdate,'YYYY')-3||'1231' or substr(reg_dt,5,4)='1231')";


		query += " group by reg_dt order by reg_dt desc ";




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
			System.out.println("[CarShedDatabase:getStatList]\n"+e);
			System.out.println("[CarShedDatabase:getStatList]\n"+query);
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
