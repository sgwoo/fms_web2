package acar.pos_client;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;

public class PclDatabase
{
	private Connection conn = null;
	public static PclDatabase db;
	
	public static PclDatabase getInstance()
	{
		if(PclDatabase.db == null)
			PclDatabase.db = new PclDatabase();
		return PclDatabase.db;
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
	 *	가망업체 INSERT
	 */
	public boolean insertPcl(PclBean pcl)
	{
		getConnection();
		boolean flag = true;
		String query_seq = "SELECT LTRIM(NVL(TO_CHAR(MAX(TO_NUMBER(pos_id))+1, '0000'), '0001')) id"+
							" FROM POS_CLIENT";

		String query = "insert into POS_CLIENT (POS_ID, USER_ID, FIRM_NM, POS_AGNT, ADDR, ZIP_CD, H_TEL, M_TEL, FAX, PCAR_ID, BUS_ST, INIT_REG_DT, ETC) values"+
						" (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, replace(?, '-', ''), ?)";
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
				pcl.setPos_id(rs.getString("id")==null?"0001":rs.getString("id"));
			}
			rs.close();
			pstmt1.close();

			pstmt2 = conn.prepareStatement(query);
			pstmt2.setString(1, pcl.getPos_id());
			pstmt2.setString(2, pcl.getUser_id());
			pstmt2.setString(3, pcl.getFirm_nm());
			pstmt2.setString(4, pcl.getPos_agnt());
			pstmt2.setString(5, pcl.getAddr());
			pstmt2.setString(6, pcl.getZip_cd());
			pstmt2.setString(7, pcl.getH_tel());
			pstmt2.setString(8, pcl.getM_tel());
			pstmt2.setString(9, pcl.getFax());
			pstmt2.setString(10, pcl.getPcar_id());
			pstmt2.setString(11, pcl.getBus_st());
			pstmt2.setString(12, pcl.getInit_reg_dt());
			pstmt2.setString(13, pcl.getEtc());			
		    pstmt2.executeUpdate();
			pstmt2.close();
		    conn.commit();
		
		 }catch(Exception se){
           try{
				System.out.println("[PclDatabase:insertPcl]"+se);
				se.printStackTrace();
				flag = false;
                conn.rollback();
            }catch(SQLException _ignored){}
              	
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
	 *	가망업체 UPDATE
	 */
	public boolean updatePcl(PclBean pcl)
	{
		getConnection();
		boolean flag = true;
		String query = "update POS_CLIENT set"+
							" USER_ID = ?,"+
							" FIRM_NM = ?,"+
							" POS_AGNT = ?,"+
							" ADDR = ?,"+
							" ZIP_CD = ?,"+
							" H_TEL = ?,"+
							" M_TEL = ?,"+
							" FAX = ?,"+
							" PCAR_ID = ?,"+
							" BUS_ST = ?,"+
							" INIT_REG_DT = replace(?, '-', ''),"+
							" ETC = ?"+							
							" where"+
							" POS_ID= ?";
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, pcl.getUser_id());
			pstmt.setString(2, pcl.getFirm_nm());
			pstmt.setString(3, pcl.getPos_agnt());
			pstmt.setString(4, pcl.getAddr());
			pstmt.setString(5, pcl.getZip_cd());
			pstmt.setString(6, pcl.getH_tel());
			pstmt.setString(7, pcl.getM_tel());
			pstmt.setString(8, pcl.getFax());
			pstmt.setString(9,  pcl.getPcar_id());
			pstmt.setString(10, pcl.getBus_st());
			pstmt.setString(11, pcl.getInit_reg_dt());
			pstmt.setString(12, pcl.getEtc());
		    pstmt.setString(13, pcl.getPos_id());
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		 
		 }catch(Exception se){
           try{
				System.out.println("[PclDatabase:updatePcl]"+se);
				se.printStackTrace();
				flag = false;
                conn.rollback();
            }catch(SQLException _ignored){}
            
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
	 * 가망업체 SELECT
	 */
	public PclBean getPcl(String pos_id)
	{
		getConnection();
		PclBean pcl = new PclBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	" SELECT P.POS_ID pos_id, P.user_id user_id, P.FIRM_NM firm_nm, P.POS_AGNT pos_agnt,"+
						 		" P.ADDR addr, P.ZIP_CD zip_cd, P.H_TEL h_tel, P.M_TEL m_tel, P.FAX fax,"+
						 		" P.pcar_id pcar_id, P.bus_st BUS_ST,"+
						 		" c.car_comp_id car_com, P.etc ETC,"+
						 		" decode(P.init_reg_dt, '', '', substr(P.init_reg_dt, 1, 4)||'-'||substr(P.init_reg_dt, 5, 2)||'-'||substr(P.init_reg_dt, 7, 2)) INIT_REG_DT"+
						 " FROM POS_CLIENT P, CAR_NM C"+
						 " WHERE P.pcar_id = C.car_id  AND"+
								" P.pos_id = '"+pos_id+"'";
		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
			while(rs.next())
			{
				pcl.setPos_id(rs.getString("POS_ID")==null?"":rs.getString("POS_ID"));
				pcl.setUser_id(rs.getString("USER_ID")==null?"":rs.getString("USER_ID"));
				pcl.setFirm_nm(rs.getString("FIRM_NM")==null?"":rs.getString("FIRM_NM"));
				pcl.setPos_agnt(rs.getString("POS_AGNT")==null?"":rs.getString("POS_AGNT"));
				pcl.setAddr(rs.getString("ADDR")==null?"":rs.getString("ADDR"));
				pcl.setZip_cd(rs.getString("ZIP_CD")==null?"":rs.getString("ZIP_CD"));
				pcl.setH_tel(rs.getString("H_TEL")==null?"":rs.getString("H_TEL"));
				pcl.setM_tel(rs.getString("M_TEL")==null?"":rs.getString("M_TEL"));
				pcl.setFax(rs.getString("FAX")==null?"":rs.getString("FAX"));
				pcl.setPcar_id(rs.getString("PCAR_ID")==null?"":rs.getString("PCAR_ID"));
				pcl.setBus_st(rs.getString("BUS_ST")==null?"":rs.getString("BUS_ST"));
				pcl.setCar_com(rs.getString("CAR_COM")==null?"":rs.getString("CAR_COM"));
				pcl.setInit_reg_dt(rs.getString("INIT_REG_DT")==null?"":rs.getString("INIT_REG_DT"));
				pcl.setEtc(rs.getString("ETC")==null?"":rs.getString("ETC"));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[PclDatabase:getPcl]"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return pcl;
		}
	}

	/**
	 *	가망업체 리스트(한 업체에 대한 모든 메모)
	 *	s_kd - 1: 상호, 2: 담당자	, 3: 위치, 4:이동전화번호, 5:영업사원이름, 6:가망차종	
	 */
	public Vector getPcls(String s_kd, String t_wd)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	"SELECT POS_ID, U.user_nm USER_NM, FIRM_NM, POS_AGNT, ADDR, ZIP_CD, H_TEL, M_TEL, FAX, C.car_name CAR_NM,"+
								" decode(BUS_ST, '1', '전화상담', '2', '직접방문', '3', '영업소소개', '') BUS_ST"+
						 " FROM POS_CLIENT P, USERS U, CAR_NM C"+
						 " WHERE P.user_id = U.user_id AND"+
								" P.pcar_id = C.car_id";
		if(s_kd.equals("1"))		query += " AND  firm_nm LIKE '%"+t_wd+"%'";
		else if(s_kd.equals("2"))	query += " AND P.pos_agnt LIKE '%"+t_wd+"%'";
		else if(s_kd.equals("3"))	query += " AND P.addr LIKE '%"+t_wd+"%'";
		else if(s_kd.equals("4"))	query += " AND P.m_tel LIKE '%"+t_wd+"%'";
		else if(s_kd.equals("5"))	query += " AND U.user_nm LIKE '%"+t_wd+"%'";
		else if(s_kd.equals("6"))	query += " AND C.car_name LIKE '%"+t_wd+"%'";
		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				PclBean pcl = new PclBean();
				pcl.setPos_id(rs.getString("POS_ID")==null?"":rs.getString("POS_ID"));
				pcl.setUser_id(rs.getString("USER_NM")==null?"":rs.getString("USER_NM"));
				pcl.setFirm_nm(rs.getString("FIRM_NM")==null?"":rs.getString("FIRM_NM"));
				pcl.setPos_agnt(rs.getString("POS_AGNT")==null?"":rs.getString("POS_AGNT"));
				pcl.setAddr(rs.getString("ADDR")==null?"":rs.getString("ADDR"));
				pcl.setZip_cd(rs.getString("ZIP_CD")==null?"":rs.getString("ZIP_CD"));
				pcl.setH_tel(rs.getString("H_TEL")==null?"":rs.getString("H_TEL"));
				pcl.setM_tel(rs.getString("M_TEL")==null?"":rs.getString("M_TEL"));
				pcl.setFax(rs.getString("FAX")==null?"":rs.getString("FAX"));
				pcl.setPcar_id(rs.getString("CAR_NM")==null?"":rs.getString("CAR_NM"));
				pcl.setBus_st(rs.getString("BUS_ST")==null?"":rs.getString("BUS_ST"));
				vt.add(pcl);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[PclDatabase:getPcls]"+e);
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
	 *	가망업체 메모(한 업체에 대한 모든 메모)
	 */
	public Vector getPclMMs(String pos_id)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	" select"+
							" POS_ID, SEQ, REG_ID, SPEAKER, CONTENT,"+
							" decode(REG_DT, '', '', substr(REG_DT, 1, 4)||'-'||substr(REG_DT, 5, 2)||'-'||substr(REG_DT, 7, 2)) REG_DT"+
							" from pc_mm "+
							" where POS_ID='"+pos_id+"'";
						
		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				PclMMBean p_mm = new PclMMBean();
				p_mm.setPos_id(rs.getString("POS_ID")==null?"":rs.getString("POS_ID"));
				p_mm.setSeq(rs.getString("SEQ")==null?"":rs.getString("SEQ"));
				p_mm.setReg_id(rs.getString("REG_ID")==null?"":rs.getString("REG_ID"));
				p_mm.setReg_dt(rs.getString("REG_DT")==null?"":rs.getString("REG_DT"));
				p_mm.setSpeaker(rs.getString("SPEAKER")==null?"":rs.getString("SPEAKER"));
				p_mm.setContent(rs.getString("CONTENT")==null?"":rs.getString("CONTENT"));

				vt.add(p_mm);
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
	 *	가망업체 메모 INSERT
	 */
	public boolean insertPMM(PclMMBean p_mm)
	{
		getConnection();
		boolean flag = true;
		String query_seq = "SELECT LTRIM(NVL(TO_CHAR(MAX(TO_NUMBER(SEQ))+1, '0000'), '0001')) seq"+
							" FROM PC_MM"+
							" WHERE POS_ID='"+p_mm.getPos_id()+"'";

		String query = "insert into PC_MM (POS_ID, SEQ, REG_ID, REG_DT, SPEAKER, CONTENT) values"+
						" (?, ?, ?, replace(?, '-', ''), ?, ?)";
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		try 
		{
			conn.setAutoCommit(false);
			
			pstmt1 = conn.prepareStatement(query_seq);
			//pstmt1.setString(1, p_mm.getPos_id());
		    rs = pstmt1.executeQuery();

			while(rs.next())
			{
				p_mm.setSeq(rs.getString("seq")==null?"0001":rs.getString("seq"));
			}
			rs.close();
			pstmt1.close();

			pstmt2 = conn.prepareStatement(query);
			pstmt2.setString(1, p_mm.getPos_id());
			pstmt2.setString(2, p_mm.getSeq());
			pstmt2.setString(3, p_mm.getReg_id());
			pstmt2.setString(4, p_mm.getReg_dt());
			pstmt2.setString(5, p_mm.getSpeaker());
			pstmt2.setString(6, p_mm.getContent());
		    pstmt2.executeUpdate();
			pstmt2.close();
		    conn.commit();
		    
	  	} catch (Exception e) {
	  		System.out.println("[PclDatabase:insertPMM]"+e);
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
}