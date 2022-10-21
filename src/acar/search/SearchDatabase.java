package acar.search;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.search.*;

public class SearchDatabase
{
	private Connection conn = null;
	public static SearchDatabase db;
	
	public static SearchDatabase getInstance()
	{
		if(SearchDatabase.db == null)
			SearchDatabase.db = new SearchDatabase();
		return SearchDatabase.db;	
	}	
	
 	private DBConnectionManager connMgr = null;

    private void getConnection()
    {
    	try
    	{
	    	if(connMgr == null)
				connMgr = DBConnectionManager.getInstance();
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

	public Vector getSearchList(String s_rent_l_cd, String s_client_nm, String s_car_no, String s_rent_s_dt, String s_kd, String s_wd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector rtn = new Vector();
		String query = "";
		query =	"select "+
				"DISTINCT a.rent_mng_id, a.rent_l_cd, a.bus_id2, a.mng_id, d.car_no, d.car_num, d.car_nm, d.car_mng_id, "+
				"nvl(e.firm_nm, e.client_nm) FIRM_NM, e.client_nm as CLIENT_NM, f.fee_s_amt, f.fee_v_amt, "+
				"decode(a.rent_dt,'','',substr(a.rent_dt,1,4)||'-'||substr(a.rent_dt,5,2)||'-'||substr(a.rent_dt,7,2)) RENT_DT, "+
				"decode(f.rent_start_dt,'','',substr(f.rent_start_dt,1,4)||'-'||substr(f.rent_start_dt,5,2)||'-'||substr(f.rent_start_dt,7,2)) RENT_START_DT , h.FROM_PLACE, h.FROM_COMP, h.DRIVER_NM \n"+
				"from cont a, car_reg d, client e, fee f, allot g , consignment h \n"+
				"where "+
				"a.car_mng_id = d.car_mng_id(+) "+
				" and a.rent_l_cd = h.rent_l_cd(+)"+
				"and a.client_id = e.client_id "+
				"and a.rent_l_cd = f.rent_l_cd(+) "+
				"and a.rent_l_cd = g.rent_l_cd "+
				"and a.use_yn = 'Y' "+
				"and f.rent_st <> '2'";

		if(!s_rent_l_cd.equals(""))	query += " and upper(nvl(a.rent_l_cd, ' ')) like upper('%"+ s_rent_l_cd +"%')";
		if(!s_client_nm.equals(""))	query += " and nvl(e.firm_nm, ' ') like '%"+ s_client_nm +"%' ";
		if(!s_car_no.equals(""))	query += " and nvl(d.car_no, ' ') || upper(a.rent_l_cd) like '%"+ s_car_no +"%' ";
		if(!s_rent_s_dt.equals(""))	query += " and nvl(a.rent_dt, ' ') like '%"+ s_rent_s_dt +"%' ";

		if(s_kd.equals("1"))		query += " and nvl(f.rent_start_dt, ' ') like '%"+ s_wd +"%' ";
		else if(s_kd.equals("2"))	query += " and nvl(d.init_reg_dt, ' ') like '%"+ s_wd +"%' ";
		else if(s_kd.equals("3"))	query += " and nvl(d.car_num, ' ') like '%"+ s_wd +"%' ";
		else if(s_kd.equals("4"))	query += " and nvl(f.con_mon, ' ') like '%"+ s_wd +"%' ";
		else if(s_kd.equals("5"))	query += " and nvl(g.cpt_cd, ' ') like '%"+ s_wd +"%' ";
		else if(s_kd.equals("6"))	query += " and nvl(f.rent_end_dt, ' ') like '%"+ s_wd +"%' ";
		else if(s_kd.equals("7"))	query += " and a.brch_id like '%"+ s_wd +"%'";
		else if(s_kd.equals("8"))	query += " and a.bus_id2 like '%"+ s_wd +"%'";
		else if(s_kd.equals("9"))	query += " and a.mng_id like '%"+ s_wd +"%'";


		try 
		{
			stmt = conn.createStatement();
		    rs = stmt.executeQuery(query);

            while(rs.next())
            {
				SearchListBean bean = new SearchListBean(); 

			    bean.setRent_mng_id(rs.getString("RENT_MNG_ID"));		//계약관리ID
			    bean.setRent_l_cd(rs.getString("RENT_L_CD"));			//계약코드
			    bean.setRent_dt(rs.getString("RENT_DT"));				//계약일자
				bean.setBus_nm(rs.getString("BUS_ID2"));				//영업담당자
				bean.setMng_nm(rs.getString("MNG_ID"));					//관리담당자
				bean.setCar_no(rs.getString("CAR_NO"));					//차량번호
				bean.setCar_nm(rs.getString("CAR_NM"));					//차명
				bean.setCar_mng_id(rs.getString("CAR_MNG_ID"));			//자동차관리ID
				bean.setFirm_nm(rs.getString("FIRM_NM"));				//상호
				bean.setClient_nm(rs.getString("CLIENT_NM"));			//고객 대표자명
				bean.setFee_s_amt(rs.getInt("FEE_S_AMT"));				//대여료 공급가
				bean.setFee_v_amt(rs.getInt("FEE_V_AMT"));				//대여료 부가세
				bean.setRent_start_dt(rs.getString("RENT_START_DT"));	//대여개시일
    
			    rtn.add(bean);
            }
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[SearchDatabase:getSearchList]"+e);
			System.out.println("[SearchDatabase:getSearchList]"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return rtn;
		}
    }

}