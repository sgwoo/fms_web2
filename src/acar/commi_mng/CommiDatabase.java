package acar.commi_mng;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.daily_sch.*;

public class CommiDatabase
{
	private Connection conn = null;
	public static CommiDatabase db;
	
	public static CommiDatabase getInstance()
	{
		if(CommiDatabase.db == null)
			CommiDatabase.db = new CommiDatabase();
		return CommiDatabase.db;
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
	 * 지급수수료 SELECT
	 */
	public CommiBean getCommi(String rent_mng_id, String rent_l_cd, String emp_id, String agnt_st)
	{
		getConnection();
		CommiBean commi = new CommiBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = " select RENT_MNG_ID, EMP_ID, RENT_L_CD, AGNT_ST, COMMI, INC_AMT, RES_AMT, TOT_AMT, DIF_AMT, SUP_DT, REL"+
						" from commi"+
						" where rent_mng_id = ? and"+
								" rent_l_cd = ? and"+
								" emp_id = ? and"+
								" agnt_st = ?";
						
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, rent_mng_id);
				pstmt.setString(2, rent_l_cd);
				pstmt.setString(3, emp_id);
				pstmt.setString(4, agnt_st);
		    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				commi.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				commi.setEmp_id(rs.getString("EMP_ID")==null?"":rs.getString("EMP_ID"));
				commi.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				commi.setAgnt_st(rs.getString("AGNT_ST")==null?"":rs.getString("AGNT_ST"));
				commi.setCommi(rs.getInt("COMMI"));
				commi.setInc_amt(rs.getInt("INC_AMT"));
				commi.setRes_amt(rs.getInt("RES_AMT"));
				commi.setTot_amt(rs.getInt("TOT_AMT"));
				commi.setDif_amt(rs.getInt("DIF_AMT"));
				commi.setSup_dt(rs.getString("SUP_DT")==null?"":rs.getString("SUP_DT"));
				commi.setRel(rs.getString("REL")==null?"":rs.getString("REL"));
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
			return commi;
		}
	}		
	
	/**
	 *	지급수수료 UPDATE
	 */
	public boolean updateCommi(CommiBean commi)
	{
		getConnection();
		boolean flag = true;
		String query = "update commi set"+
							" COMMI	= ?,"+
							" INC_AMT	= ?,"+
							" RES_AMT	= ?,"+
							" TOT_AMT	= ?,"+
							" DIF_AMT	= ?,"+
							" SUP_DT	= replace(?, '-', ''),"+
							" REL	= ?"+
							" where RENT_MNG_ID	= ? and"+
							" EMP_ID	= ? and"+
							" RENT_L_CD	= ? and"+
							" AGNT_ST	= ?";
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, commi.getCommi());
			pstmt.setInt(2, commi.getInc_amt());
			pstmt.setInt(3, commi.getRes_amt());
			pstmt.setInt(4, commi.getTot_amt());		
			pstmt.setInt(5, commi.getDif_amt());
			pstmt.setString(6, commi.getSup_dt());
			pstmt.setString(7, commi.getRel());	
			pstmt.setString(8, commi.getRent_mng_id());	
			pstmt.setString(9, commi.getEmp_id());
			pstmt.setString(10, commi.getRent_l_cd());
			pstmt.setString(11, commi.getAgnt_st());

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

	/**
	 * 사원정보
	 */
	public Hashtable getEmp(String emp_id)
	{
		getConnection();
		Hashtable ht = new Hashtable();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	" SELECT E.EMP_ID EMP_ID, E.CAR_OFF_ID CAR_OFF_ID, E.CUST_ST CUST_ST, E.EMP_NM EMP_NM,"+
								" E.EMP_SSN EMP_SSN, E.EMP_M_TEL EMP_M_TEL, E.EMP_POS EMP_POS, E.EMP_EMAIL EMP_EMAIL,"+
								" E.EMP_BANK EMP_BANK, E.EMP_ACC_NO EMP_ACC_NO, E.EMP_ACC_NM EMP_ACC_NM, C.nm CAR_COM,"+
								" O.car_off_nm CAR_OFF_NM, O.car_off_tel CAR_OFF_TEL, O.car_off_st CAR_OFF_ST"+
						" FROM CAR_OFF_EMP E, CAR_OFF O, CODE C"+
						" WHERE E.car_off_id = O.car_off_id AND"+
							  		" O.car_comp_id = C.CODE AND"+
									" C.c_st='0001' AND C.CODE <> '0000' AND"+
									" E.emp_id = ?";
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, emp_id);
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
	 * 사원별 지급수수료 리스트
	 */
	public Vector getCommis(String emp_id)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = " select"+
							" M.RENT_MNG_ID RENT_MNG_ID, M.EMP_ID EMP_ID, M.RENT_L_CD RENT_L_CD, M.AGNT_ST AGNT_ST, M.COMMI COMMI,"+
							" M.INC_AMT INC_AMT, M.RES_AMT RES_AMT, M.TOT_AMT TOT_AMT, M.DIF_AMT DIF_AMT, M.REL REL,"+
							" decode(M.SUP_DT, '', '', substr(M.SUP_DT, 1, 4)||'-'||substr(M.SUP_DT, 5, 2)||'-'||substr(M.SUP_DT, 7, 2)) SUP_DT,"+
							" nvl(L.firm_nm, L.client_nm) FIRM_NM, R.car_nm CAR_NM,"+
							" decode(C.DLV_DT, '', '', substr(C.DLV_DT, 1, 4)||'-'||substr(C.DLV_DT, 5, 2)||'-'||substr(C.DLV_DT, 7, 2)) DLV_DT"+
						" from COMMI M, cont C, client L, car_reg R"+
						" where C.rent_mng_id = M.rent_mng_id and"+
									" C.rent_l_cd = M.rent_l_cd and"+
									" C.client_id = L.client_id and"+
									" C.car_mng_id = R.car_mng_id and"+
									" C.use_yn = 'Y' and"+
									" EMP_ID = ?";
						
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, emp_id);
		    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				CommiBean commi = new CommiBean();
				commi.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				commi.setEmp_id(rs.getString("EMP_ID")==null?"":rs.getString("EMP_ID"));
				commi.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				commi.setAgnt_st(rs.getString("AGNT_ST")==null?"":rs.getString("AGNT_ST"));
				commi.setCommi(rs.getInt("COMMI"));
				commi.setInc_amt(rs.getInt("INC_AMT"));
				commi.setRes_amt(rs.getInt("RES_AMT"));
				commi.setTot_amt(rs.getInt("TOT_AMT"));
				commi.setDif_amt(rs.getInt("DIF_AMT"));
				commi.setSup_dt(rs.getString("SUP_DT")==null?"":rs.getString("SUP_DT"));
				commi.setRel(rs.getString("REL")==null?"":rs.getString("REL"));
				commi.setFirm_nm(rs.getString("FIRM_NM")==null?"":rs.getString("FIRM_NM"));
				commi.setDlv_dt(rs.getString("DLV_DT")==null?"":rs.getString("DLV_DT"));
				commi.setCar_nm(rs.getString("CAR_NM")==null?"":rs.getString("CAR_NM"));
				vt.add(commi);
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
	 *	지급수수료리스트조회
	 *	car_comp_id	- 자동차회사
	 *	car_off_id	- 영업소
	 *	emp_nm	- 사원명
	 */
	public Vector getCommiEmpList(String car_comp_id, String car_off_id, String emp_nm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = " SELECT E.emp_id EMP_ID, C.nm COM_NM, O.car_off_nm CAR_OFF_NM, E.emp_nm EMP_NM,"+
								" O.car_off_tel CAR_OFF_TEL, O.car_off_fax CAR_OFF_FAX, E.emp_m_tel EMP_M_TEL"+
						" FROM CAR_OFF_EMP E, CAR_OFF O, CODE C"+
						" WHERE E.car_off_id = O.car_off_id AND"+
									" O.car_comp_id = C.CODE AND"+
									" C.c_st='0001' AND C.CODE <> '0000' AND"+
									" E.emp_nm LIKE '%"+emp_nm+"%' AND"+
									" O.car_off_id like '%"+car_off_id+"%' AND"+
									" O.car_comp_id like '%"+car_comp_id+"%'";
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
}