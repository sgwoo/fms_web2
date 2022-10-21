package acar.con_car;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.exception.DatabaseException;
import acar.exception.DataSourceEmptyException;

public class CarDatabase
{
	private Connection conn = null;
	public static CarDatabase db;
	
	public static CarDatabase getInstance()
	{
		if(CarDatabase.db == null)
			CarDatabase.db = new CarDatabase();
		return CarDatabase.db;
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
	*	차량현황 Bean에 데이터 넣기 2003.4.6.Tue.
	*/
	 private CarBean makeCarBean(ResultSet results) throws DatabaseException {

        try {
            CarBean bean = new CarBean();

			bean.setRent_l_cd(results.getString("RENT_L_CD")==null?"":results.getString("RENT_L_CD"));
			bean.setClient_nm(results.getString("CLIENT_NM")==null?"":results.getString("CLIENT_NM"));
			bean.setCar_no(results.getString("CAR_NO")==null?"":results.getString("CAR_NO"));
			bean.setInit_reg_dt(results.getString("INIT_REG_DT")==null?"":results.getString("INIT_REG_DT"));
			bean.setCar_nm(results.getString("CAR_NM")==null?"":results.getString("CAR_NM"));
			bean.setCon_mon(results.getString("CON_MON")==null?"":results.getString("CON_MON"));
			bean.setFee_mon(results.getInt("FEE_MON"));
			bean.setAllot_jan(results.getInt("ALLOT_JAN"));
			bean.setAllot_bank(results.getString("ALLOT_BANK")==null?"":results.getString("ALLOT_BANK"));
			bean.setRent_start_dt(results.getString("RENT_START_DT")==null?"":results.getString("RENT_START_DT"));
			bean.setRent_end_dt(results.getString("RENT_END_DT")==null?"":results.getString("RENT_END_DT"));
			bean.setRent_st(results.getString("RENT_ST")==null?"":results.getString("RENT_ST"));
			bean.setPp_amt(results.getInt("PP_AMT"));
			bean.setIfee_amt(results.getInt("IFEE_AMT"));
			bean.setGrt_amt(results.getInt("GRT_AMT"));
			bean.setBus_nm(results.getString("BUS_NM")==null?"":results.getString("BUS_NM"));

			return bean;

        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}

	/**
	 *	현황 select 2003.4.6.Tue.
	 */
	public CarBean[] getCar(String s_kd, String t_wd)
	{
		getConnection();
		Collection<CarBean> col = new ArrayList<CarBean>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String subQuery = " WHERE ";
		String query = "";

		if(s_kd.equals("0")) subQuery = "";
		else if(s_kd.equals("1")) subQuery += " client_nm LIKE '%"+t_wd+"%'";
		else if(s_kd.equals("2")) subQuery += " rent_l_cd LIKE '%"+t_wd+"%'";
		else if(s_kd.equals("3")) subQuery += " car_no LIKE '%"+t_wd+"%'";

		query = "SELECT * FROM v_get_car "+subQuery;
		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				col.add(makeCarBean(rs));
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
			return (CarBean[])col.toArray(new CarBean[0]);
		}
	}
	
	/**
	*	마감(저장)하기 2003.4.7.Wed.
	*/
	public int saveCar()
	{
		getConnection();
		PreparedStatement pstmt = null;
		CarBean[] cars = this.getCar("0","");
		String query = "";
		int result = 0;

		query = "INSERT INTO car_condition(save_dt, rent_l_cd, client_nm, car_no, init_reg_dt, car_nm, con_mon, fee_mon, allot_jan, allot_bank, rent_start_dt, rent_end_dt, rent_st, pp_amt, ifee_amt, grt_amt, bus_nm) "+
			" VALUES(to_char(sysdate,'YYYYMMDD'),?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";

		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			for(int i=0; i<cars.length; i++){
				pstmt.setString(1,cars[i].getRent_l_cd());
				pstmt.setString(2,cars[i].getClient_nm());
				pstmt.setString(3,cars[i].getCar_no());
				pstmt.setString(4,cars[i].getInit_reg_dt());
				pstmt.setString(5,cars[i].getCar_nm());
				pstmt.setString(6,cars[i].getCon_mon());
				pstmt.setInt   (7,cars[i].getFee_mon());
				pstmt.setInt   (8,cars[i].getAllot_jan());
				pstmt.setString(9,cars[i].getAllot_bank());
				pstmt.setString(10,cars[i].getRent_start_dt());
				pstmt.setString(11,cars[i].getRent_end_dt());
				pstmt.setString(12,cars[i].getRent_st());
				pstmt.setInt   (13,cars[i].getPp_amt());
				pstmt.setInt   (14,cars[i].getIfee_amt());
				pstmt.setInt   (15,cars[i].getGrt_amt());
				pstmt.setString(16,cars[i].getBus_nm());
				result = pstmt.executeUpdate();
				if(result==0) break;
			}    	
			conn.commit();
		    pstmt.close();
		    
		} catch (Exception e) {
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return result;
		}
	}

	/**
	 *	마감이 되었는지 여부 2003.4.7.Wed.
	 */
	public String existSave_dt()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	"SELECT distinct save_dt FROM car_condition WHERE save_dt=to_char(sysdate,'YYYYMMDD')";
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

}