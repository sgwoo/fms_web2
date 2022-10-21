/**
 * 정기검사기록
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2002. 3. 4
 * @ last modify date : 
 */
package acar.car_maint;

import java.util.*;
import java.sql.*;
import acar.util.*;
import acar.common.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.UnknownDataException;
import acar.exception.DatabaseException;


public class CarMaintDatabase {

    private static CarMaintDatabase instance;
    private DBConnectionManager connMgr;   
    // Pool로 부터 Connection 객체를 가져올때 사용하는 Pool Name 
    private final String DATA_SOURCE = "acar"; 
 
    // 싱글톤 클래스로 구현 
    // 생성자를 private 로 선언
    public static synchronized CarMaintDatabase getInstance() throws DatabaseException {
        if (instance == null)
            instance = new CarMaintDatabase();
        return instance;
    }
    
    private CarMaintDatabase() throws DatabaseException {
        connMgr = DBConnectionManager.getInstance();
    }
    
    /**
     * 특정 레코드를 Bean에 저장하여 Bean을 리턴하는 메소드
     */
    /**
     * 정기검사 ( 2001/12/28 ) - Kim JungTae
     */
    
    private CarMaintBean makeCarMaintBean(ResultSet results) throws DatabaseException {

        try {
            CarMaintBean bean = new CarMaintBean();

		    bean.setRent_mng_id(results.getString("RENT_MNG_ID"));
			bean.setRent_l_cd(results.getString("RENT_L_CD"));
			bean.setBrch_id(results.getString("BRCH_ID"));
			bean.setMng_id(results.getString("MNG_ID"));
			bean.setCar_mng_id(results.getString("CAR_MNG_ID"));
			bean.setCar_no(results.getString("CAR_NO"));
			bean.setInit_reg_dt(results.getString("INIT_REG_DT"));
			bean.setMaint_st_dt(results.getString("MAINT_ST_DT"));
			bean.setMaint_end_dt(results.getString("MAINT_END_DT"));
			bean.setClient_nm(results.getString("CLIENT_NM"));
			bean.setFirm_nm(results.getString("FIRM_NM"));
			bean.setUser_nm(results.getString("USER_NM"));
		   	
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}
     
	
    /**
     * 정기검사 전체조회
     */
    
    public CarMaintBean [] getCarMaintAll(String gubun, String gubun_nm, String ref_dt1, String ref_dt2) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        String subQuery = "";
        
        if(gubun.equals("day"))
        {
        	subQuery = "and b.maint_end_dt = to_char(sysdate,'YYYYMMDD') order by c.firm_nm\n";
        	
        }else if(gubun.equals("month")){
        	subQuery = "and b.maint_end_dt like to_char(sysdate,'YYYYMM')||'%' order by b.maint_end_dt, c.firm_nm\n";
    	}else if(gubun.equals("car_no")){
    		subQuery = "and b.car_no like '%" + gubun_nm +"%' order by c.firm_nm\n";
    	}else if(gubun.equals("firm_nm")){
    		subQuery = "and c.firm_nm like '%" + gubun_nm +"%' order by b.maint_end_dt\n";
    	}else if(gubun.equals("ref_dt")){
    		subQuery = "and b.maint_end_dt between replace('"+ ref_dt1 +"','-','') and replace('" + ref_dt2 +"','-','') order by b.maint_end_dt, c.firm_nm\n";
    	}else{
    		subQuery = "and b.maint_end_dt = to_char(sysdate,'YYYYMMDD') order by c.firm_nm\n";
    	}
        
        query = "select a.rent_mng_id as RENT_MNG_ID, a.rent_l_cd as RENT_L_CD,a.brch_id as BRCH_ID, a.mng_id as MNG_ID, b.car_mng_id as CAR_MNG_ID, b.car_no as CAR_NO, substr(b.init_reg_dt,1,4)||'-'||substr(b.init_reg_dt,5,2)||'-'||substr(b.init_reg_dt,7,2) as INIT_REG_DT,substr(b.maint_st_dt,1,4)||'-'||substr(b.maint_st_dt,5,2)||'-'||substr(b.maint_st_dt,7,2) as MAINT_ST_DT, substr(b.maint_end_dt,1,4)||'-'||substr(b.maint_end_dt,5,2)||'-'||substr(b.maint_end_dt,7,2) as MAINT_END_DT,c.client_nm as CLIENT_NM, c.firm_nm as FIRM_NM, d.user_nm as USER_NM\n"
				+ "from cont a, car_reg b, client c, users d\n"
				+ "where a.car_mng_id=b.car_mng_id\n"
				+ "and a.client_id=c.client_id\n"
				+ "and a.mng_id=d.user_id(+)\n"
				+ subQuery;
        Collection<CarMaintBean> col = new ArrayList<CarMaintBean>();
        try{
            pstmt = con.prepareStatement(query);
    		
    		rs = pstmt.executeQuery();

            while(rs.next()){
                
				col.add(makeCarMaintBean(rs));
 
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (CarMaintBean[])col.toArray(new CarMaintBean[0]);
    }
    
}
