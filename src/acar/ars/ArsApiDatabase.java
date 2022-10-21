package acar.ars;

import acar.database.*;
import acar.exception.DataSourceEmptyException;
import acar.exception.DatabaseException;
import acar.kakao.AlimTalkBean;

import java.sql.*;
import java.util.*;

/*
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;
import java.util.Vector;
*/

public class ArsApiDatabase {

	private static final String ORG_NAME = "아마존카";
	private static final String ORG_UUID = "@아마존카";

	private Connection conn = null;
	public static ArsApiDatabase db;

	public static ArsApiDatabase getInstance() {
		if (ArsApiDatabase.db == null)
			ArsApiDatabase.db = new ArsApiDatabase();
		return ArsApiDatabase.db;
	}

	private DBConnectionManager connMgr = null;

	private void getConnection() {
		try {
			if (connMgr == null)
				connMgr = DBConnectionManager.getInstance();
			if (conn == null)
				conn = connMgr.getConnection("acar");
		} catch (Exception e) {
			System.out.println("i can't get a connection........");
		}
	}

	private void closeConnection() {
		if (conn != null) {
			connMgr.freeConnection("acar", conn);
		}
	}
	
	//고객 연락처 검색(장기렌트,월렌트,업무대여) - 사용자 인증
	public List<ArsApiBean> selectSearchClientNumInfo(String search_type, String number) {
		
		getConnection();
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		List<ArsApiBean> ArsBeanList = new ArrayList<ArsApiBean>();
		
		String query = " SELECT DISTINCT b.client_id, a.firm_nm, c.br_id, c.user_id, c.user_nm, REPLACE(c.user_m_tel,'-','') user_m_tel " +
				" FROM   client a, cont b, users c " +
				" WHERE  ( " +
				" REPLACE(a.o_tel,'-','')='" + number + "' OR " +
				" REPLACE(a.h_tel,'-','')='" + number + "' OR " +
				" REPLACE(a.m_tel,'-','')='" + number + "' OR " +
				" REPLACE(a.con_agnt_o_tel,'-','')='" + number + "' OR " +
				" REPLACE(a.con_agnt_m_tel,'-','')='" + number + "' OR " +
				" REPLACE(a.con_agnt_o_tel2,'-','')='" + number + "' OR " +
				" REPLACE(a.con_agnt_m_tel2,'-','')='" + number + "' " +
				" ) " +
				" AND a.client_id=b.client_id " + 
				" AND b.bus_id2=c.user_id " +
				" AND (b.use_yn='Y' OR b.use_yn IS null) " +
				" AND b.car_st<>'2' ";
		
		//System.out.println("selectSearchClientNumInfo query = " + query);
		
		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				ArsApiBean ArsBean = new ArsApiBean();
				
				ArsBean.setClient_id(rs.getString("CLIENT_ID"));
				ArsBean.setFirm_nm(rs.getString("FIRM_NM"));
				ArsBean.setBr_id(rs.getString("BR_ID"));
				ArsBean.setUser_id(rs.getString("USER_ID"));
				ArsBean.setUser_nm(rs.getString("USER_NM"));
				ArsBean.setUser_m_tel(rs.getString("USER_M_TEL"));
				
				ArsBeanList.add(ArsBean);
			}
			rs.close();
			pstmt.close();
		} catch (Exception e) {
			System.out.println("[ArsApiDatabase:selectSearchClientNumInfo()]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			
			return ArsBeanList;
		}
	}	
	
	//고객 연락처 검색(장기렌트,월렌트,업무대여) - 차량번호 인증
	public List<ArsApiBean> selectSearchClientNumInfo2(String search_type, String number, String car_no) {
		
		getConnection();
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		List<ArsApiBean> ArsBeanList = new ArrayList<ArsApiBean>();
		
		String query = " SELECT DISTINCT b.rent_mng_id, b.rent_l_cd, b.car_mng_id, b.client_id, e.car_no, a.firm_nm, c.br_id, c.user_id, c.user_nm, REPLACE(c.user_m_tel,'-','') user_m_tel, c.ars_group " +
				" FROM   client a, cont b, users c, car_reg e " +
				" WHERE  ( " +
				" REPLACE(a.o_tel,'-','')='" + number + "' OR " +
				" REPLACE(a.h_tel,'-','')='" + number + "' OR " +
				" REPLACE(a.m_tel,'-','')='" + number + "' OR " +
				" REPLACE(a.con_agnt_o_tel,'-','')='" + number + "' OR " +
				" REPLACE(a.con_agnt_m_tel,'-','')='" + number + "' OR " +
				" REPLACE(a.con_agnt_o_tel2,'-','')='" + number + "' OR " +
				" REPLACE(a.con_agnt_m_tel2,'-','')='" + number + "' " +
				" ) " +
				" AND a.client_id=b.client_id " + 
				" AND b.car_mng_id=e.car_mng_id " + 
				" AND b.bus_id2=c.user_id " +
				" AND (b.use_yn='Y' OR b.use_yn IS null) " +
				" AND b.car_st<>'2' ";
		
		if (!car_no.equals("")) {
			query += " AND e.car_no LIKE '%" + car_no + "%' ";
		}
		
		//System.out.println("selectSearchClientNumInfo query = " + query);
		
		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				ArsApiBean ArsBean = new ArsApiBean();
				
				ArsBean.setRent_mng_id(rs.getString("RENT_MNG_ID"));
				ArsBean.setRent_l_cd(rs.getString("RENT_L_CD"));
				ArsBean.setCar_mng_id(rs.getString("CAR_MNG_ID"));
				ArsBean.setClient_id(rs.getString("CLIENT_ID"));
				ArsBean.setCar_no(rs.getString("CAR_NO"));
				
				ArsBean.setFirm_nm(rs.getString("FIRM_NM"));
				ArsBean.setBr_id(rs.getString("BR_ID"));
				ArsBean.setUser_id(rs.getString("USER_ID"));
				ArsBean.setUser_nm(rs.getString("USER_NM"));
				ArsBean.setUser_m_tel(rs.getString("USER_M_TEL"));
				ArsBean.setArs_group(rs.getString("ARS_GROUP"));
				
				ArsBeanList.add(ArsBean);
			}
			rs.close();
			pstmt.close();
		} catch (Exception e) {
			System.out.println("[ArsApiDatabase:selectSearchClientNumInfo()]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			
			return ArsBeanList;
		}
	}	
	
	//고객 지점 연락처 검색(장기렌트,월렌트,업무대여) - 사용자 인증
	public List<ArsApiBean> selectSearchClientDeptNumInfo(String search_type, String number) {
		
		getConnection();
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		List<ArsApiBean> ArsBeanList = new ArrayList<ArsApiBean>();
		
		String query = " SELECT DISTINCT b.client_id, a.r_site AS firm_nm, c.br_id, c.user_id, c.user_nm, REPLACE(c.user_m_tel,'-','') user_m_tel " +
				" FROM   client_site a, cont b, users c " +
				" WHERE  ( " +
				" REPLACE(a.tel,'-','')='" + number + "' OR " +
				" REPLACE(a.agnt_tel,'-','')='" + number + "' OR " +
				" REPLACE(a.agnt_m_tel,'-','')='" + number + "' OR " +
				" REPLACE(a.agnt_tel2,'-','')='" + number + "' OR " +
				" REPLACE(a.agnt_m_tel2,'-','')='" + number + "' " +
				" ) " +
				" AND a.client_id=b.client_id " + 
				" AND b.bus_id2=c.user_id " +
				" AND (b.use_yn='Y' OR b.use_yn IS null) " +
				" AND b.car_st<>'2' ";
		
		//System.out.println("selectSearchClientDeptNumInfo query = " + query);
		
		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				ArsApiBean ArsBean = new ArsApiBean();
				
				ArsBean.setClient_id(rs.getString("CLIENT_ID"));
				ArsBean.setFirm_nm(rs.getString("FIRM_NM"));
				ArsBean.setBr_id(rs.getString("BR_ID"));
				ArsBean.setUser_id(rs.getString("USER_ID"));
				ArsBean.setUser_nm(rs.getString("USER_NM"));
				ArsBean.setUser_m_tel(rs.getString("USER_M_TEL"));
				
				ArsBeanList.add(ArsBean);
			}
			rs.close();
			pstmt.close();
		} catch (Exception e) {
			System.out.println("[ArsApiDatabase:selectSearchClientDeptNumInfo()]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			
			return ArsBeanList;
		}
	}
	
	//고객 지점 연락처 검색(장기렌트,월렌트,업무대여) - 차량번호 인증
	public List<ArsApiBean> selectSearchClientDeptNumInfo2(String search_type, String number, String car_no) {
		
		getConnection();
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		List<ArsApiBean> ArsBeanList = new ArrayList<ArsApiBean>();
		
		String query = " SELECT DISTINCT b.rent_mng_id, b.rent_l_cd, b.car_mng_id, b.client_id, e.car_no, a.r_site AS firm_nm, c.br_id, c.user_id, c.user_nm, REPLACE(c.user_m_tel,'-','') user_m_tel, c.ars_group " +
				" FROM   client_site a, cont b, users c, car_reg e " +
				" WHERE  ( " +
				" REPLACE(a.tel,'-','')='" + number + "' OR " +
				" REPLACE(a.agnt_tel,'-','')='" + number + "' OR " +
				" REPLACE(a.agnt_m_tel,'-','')='" + number + "' OR " +
				" REPLACE(a.agnt_tel2,'-','')='" + number + "' OR " +
				" REPLACE(a.agnt_m_tel2,'-','')='" + number + "' " +
				" ) " +
				" AND a.client_id=b.client_id " + 
				" AND b.car_mng_id=e.car_mng_id " + 
				" AND b.bus_id2=c.user_id " +
				" AND (b.use_yn='Y' OR b.use_yn IS null) " +
				" AND b.car_st<>'2' ";
		
		if (!car_no.equals("")) {
			query += " AND e.car_no LIKE '%" + car_no + "%' ";
		}
		
		//System.out.println("selectSearchClientDeptNumInfo query = " + query);
		
		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				ArsApiBean ArsBean = new ArsApiBean();
				
				ArsBean.setRent_mng_id(rs.getString("RENT_MNG_ID"));
				ArsBean.setRent_l_cd(rs.getString("RENT_L_CD"));
				ArsBean.setCar_mng_id(rs.getString("CAR_MNG_ID"));
				ArsBean.setClient_id(rs.getString("CLIENT_ID"));
				ArsBean.setCar_no(rs.getString("CAR_NO"));
				
				ArsBean.setFirm_nm(rs.getString("FIRM_NM"));
				ArsBean.setBr_id(rs.getString("BR_ID"));
				ArsBean.setUser_id(rs.getString("USER_ID"));
				ArsBean.setUser_nm(rs.getString("USER_NM"));
				ArsBean.setUser_m_tel(rs.getString("USER_M_TEL"));
				ArsBean.setArs_group(rs.getString("ARS_GROUP"));
				
				ArsBeanList.add(ArsBean);
			}
			rs.close();
			pstmt.close();
		} catch (Exception e) {
			System.out.println("[ArsApiDatabase:selectSearchClientDeptNumInfo()]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			
			return ArsBeanList;
		}
	}
	
	//관계자 연락처 검색(장기렌트,월렌트,업무대여) - 사용자 인증
	public List<ArsApiBean> selectSearchClientManagerNumInfo(String search_type, String number) {
		
		getConnection();
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		List<ArsApiBean> ArsBeanList = new ArrayList<ArsApiBean>();
		
		String query = " SELECT DISTINCT b.client_id, d.firm_nm, c.br_id, c.user_id, c.user_nm, REPLACE(c.user_m_tel,'-','') user_m_tel " +
				" FROM   car_mgr a, cont b, users c, client d " +
				" WHERE  ( " +
				" REPLACE(a.mgr_tel,'-','')='" + number + "' OR " + 
				" REPLACE(a.mgr_m_tel,'-','')='" + number + "'  " +
				" ) " +
				" AND (a.use_yn='Y' OR a.use_yn IS NULL) " + //퇴사자제외
				" AND NVL(a.mgr_nm||a.mgr_dept||a.mgr_title||a.com_nm,'-') NOT LIKE '%퇴사%' " + //퇴사자(문구)제외
				" AND a.rent_mng_id=b.rent_mng_id " + 
				" AND a.rent_l_cd=b.rent_l_cd " + 
				" AND b.bus_id2=c.user_id " +
				" AND (b.use_yn='Y' OR b.use_yn IS null) " +
				" AND b.car_st<>'2' " +
				" AND b.client_id=d.client_id ";
		
		//System.out.println("selectSearchClientDeptNumInfo query = " + query);
		
		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				ArsApiBean ArsBean = new ArsApiBean();
				
				ArsBean.setClient_id(rs.getString("CLIENT_ID"));
				ArsBean.setFirm_nm(rs.getString("FIRM_NM"));
				ArsBean.setBr_id(rs.getString("BR_ID"));
				ArsBean.setUser_id(rs.getString("USER_ID"));
				ArsBean.setUser_nm(rs.getString("USER_NM"));
				ArsBean.setUser_m_tel(rs.getString("USER_M_TEL"));
				
				ArsBeanList.add(ArsBean);
			}
			rs.close();
			pstmt.close();
		} catch (Exception e) {
			System.out.println("[ArsApiDatabase:selectSearchClientDeptNumInfo()]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			
			return ArsBeanList;
		}
	}
	
	//관계자 연락처 검색(장기렌트,월렌트,업무대여) - 차량번호 인증
	public List<ArsApiBean> selectSearchClientManagerNumInfo2(String search_type, String number, String car_no) {
		
		getConnection();
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		List<ArsApiBean> ArsBeanList = new ArrayList<ArsApiBean>();
		
		String query = " SELECT DISTINCT b.rent_mng_id, b.rent_l_cd, b.car_mng_id, b.client_id, e.car_no, d.firm_nm, c.br_id, c.user_id, c.user_nm, REPLACE(c.user_m_tel,'-','') user_m_tel, c.ars_group " +
				" FROM   car_mgr a, cont b, users c, client d, car_reg e " +
				" WHERE  ( " +
				" REPLACE(a.mgr_tel,'-','')='" + number + "' OR " +
				" REPLACE(a.mgr_m_tel,'-','')='" + number + "'  " +
				" ) " +
				" AND (a.use_yn='Y' OR a.use_yn IS NULL) " + //퇴사자제외
				" AND NVL(a.mgr_nm||a.mgr_dept||a.mgr_title||a.com_nm,'-') NOT LIKE '%퇴사%' " + //퇴사자(문구)제외
				" AND a.rent_mng_id=b.rent_mng_id " +
				" AND b.car_mng_id=e.car_mng_id " +
				" AND a.rent_l_cd=b.rent_l_cd " +
				" AND b.bus_id2=c.user_id " +
				" AND (b.use_yn='Y' OR b.use_yn IS null) " +
				" AND b.car_st<>'2' " +
				" AND b.client_id=d.client_id ";
		
		if (!car_no.equals("")) {
			query += " AND e.car_no LIKE '%" + car_no + "%' ";
		}
		
		//System.out.println("selectSearchClientDeptNumInfo query = " + query);
		
		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				ArsApiBean ArsBean = new ArsApiBean();
				
				ArsBean.setRent_mng_id(rs.getString("RENT_MNG_ID"));
				ArsBean.setRent_l_cd(rs.getString("RENT_L_CD"));
				ArsBean.setCar_mng_id(rs.getString("CAR_MNG_ID"));
				ArsBean.setClient_id(rs.getString("CLIENT_ID"));
				ArsBean.setCar_no(rs.getString("CAR_NO"));
				
				ArsBean.setFirm_nm(rs.getString("FIRM_NM"));
				ArsBean.setBr_id(rs.getString("BR_ID"));
				ArsBean.setUser_id(rs.getString("USER_ID"));
				ArsBean.setUser_nm(rs.getString("USER_NM"));
				ArsBean.setUser_m_tel(rs.getString("USER_M_TEL"));
				ArsBean.setArs_group(rs.getString("ARS_GROUP"));
				
				ArsBeanList.add(ArsBean);
			}
			rs.close();
			pstmt.close();
		} catch (Exception e) {
			System.out.println("[ArsApiDatabase:selectSearchClientDeptNumInfo()]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			
			return ArsBeanList;
		}
	}
	
	//ARS 통화 종료 후 LOG insert
    public boolean arsInsertLog(ArsApiBean bean)
    {
        getConnection();

        boolean flag = true;
        PreparedStatement pstmt = null;
        String query = "";

        query = " INSERT INTO ARS_CALL_LOG ( " +
                    	" id, user_type, user_id, cid, redirect_number, " +
                    	" hangup_time, bill_duration, call_status, client_id, car_no, info_type, " +
                    	" called_number, access_number, call_date, dial_time, answer_time, call_duration, " +
                    	" dtmf_string, callback_flag " +
                    " ) " +
	                " VALUES ( " +
	                    " ?, ?, ?, ?, ?, " +
	                    " ?, ?, ?, ?, ?, ?, " +
	                    " ?, ?, ?, ?, ?, ?, " +
	                    " ?, ? " +
	                " ) ";

        try {
            
        	conn.setAutoCommit(false);

            pstmt = conn.prepareStatement(query);
            
            pstmt.setInt(1, bean.getId());
            pstmt.setString(2, bean.getUser_type());
            pstmt.setString(3, bean.getUser_id());
            pstmt.setString(4, bean.getCid());
            pstmt.setString(5, bean.getRedirect_number());
            pstmt.setString(6, bean.getHangup_time());
            pstmt.setInt(7, bean.getBill_duration());
            pstmt.setString(8, bean.getCall_status());
            pstmt.setString(9, bean.getClient_id());
            pstmt.setString(10, bean.getCar_no());
            pstmt.setString(11, bean.getInfo_type());
            
            pstmt.setString(12, bean.getCalled_number());
            pstmt.setString(13, bean.getAccess_number());
            pstmt.setString(14, bean.getCall_date());
            pstmt.setString(15, bean.getDial_time());
            pstmt.setString(16, bean.getAnswer_time());
            pstmt.setInt(17, bean.getCall_duration());
            pstmt.setString(18, bean.getDtmf_string());
            pstmt.setString(19, bean.getCallback_flag());

            pstmt.executeUpdate();
            pstmt.close();

            conn.commit();

        } catch (Exception e) {
            System.out.println("[ArsApiDatabase:arsInsertLog(ArsApiBean bean)]\n"+e);
            e.printStackTrace();
            flag = false;
            conn.rollback();
        } finally {
            try{
                conn.setAutoCommit(true);
                if ( pstmt != null )	pstmt.close();
            }catch(Exception ignore){}
            closeConnection();
            return flag;
        }
    }
    
    //ARS API CALL INSERT
    public boolean arsCallLogTempInsert(ArsApiBean bean)
    {
    	getConnection();
    	
    	boolean flag = true;
    	PreparedStatement pstmt = null;
    	String query = "";
    	
    	query = " INSERT INTO ARS_CALL_LOG_TEMP ( " +
    			" type, reg_date, result_code, api_call_url " +
    			" ) " +
    			" VALUES ( " +
    			" ?, sysdate, ?, ? " +
    			" ) ";
    	
    	try {
    		
    		conn.setAutoCommit(false);
    		
    		pstmt = conn.prepareStatement(query);
    		
    		pstmt.setString(1, bean.getType());
    		pstmt.setString(2, bean.getResult_code());
    		pstmt.setString(3, bean.getApi_call_url());
    		
    		pstmt.executeUpdate();
    		pstmt.close();
    		
    		conn.commit();
    		
    	} catch (Exception e) {
    		System.out.println("[ArsApiDatabase:arsCallLogTempInsert(ArsApiBean bean)]\n"+e);
    		e.printStackTrace();
    		flag = false;
    		conn.rollback();
    	} finally {
    		try{
    			conn.setAutoCommit(true);
    			if ( pstmt != null )	pstmt.close();
    		}catch(Exception ignore){}
    		closeConnection();
    		return flag;
    	}
    }
    
    /**
	 *	영업소 리스트 조회(공급자)
	 */
	public Hashtable getBranch(String access_number) throws DatabaseException, DataSourceEmptyException {
		
		getConnection();		

        String query = " SELECT * from BRANCH where REPLACE(access_number,'-','') = '" + access_number + "' ";

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		try {
			    pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			if(rs.next()) {				
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
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
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			closeConnection();
		}
		return ht;
	}

}
