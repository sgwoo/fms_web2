/**
 * 정비기록
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2002. 3. 4
 * @ last modify date : 
 */
package acar.serv_daily;

import java.util.*;
import java.sql.*;
import acar.util.*;
import acar.common.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.UnknownDataException;
import acar.exception.DatabaseException;


public class ServDailyDatabase {

    private static ServDailyDatabase instance;
    private DBConnectionManager connMgr;   
    // Pool로 부터 Connection 객체를 가져올때 사용하는 Pool Name 
    private final String DATA_SOURCE = "acar"; 
 
    // 싱글톤 클래스로 구현 
    // 생성자를 private 로 선언
    public static synchronized ServDailyDatabase getInstance() throws DatabaseException {
        if (instance == null)
            instance = new ServDailyDatabase();
        return instance;
    }
    
    private ServDailyDatabase() throws DatabaseException {
        connMgr = DBConnectionManager.getInstance();
    }
    
    /**
     * 특정 레코드를 Bean에 저장하여 Bean을 리턴하는 메소드
     */
    /**
     * 정기검사 ( 2001/12/28 ) - Kim JungTae
     */
    
    private ServDailyBean makeServDailyBean(ResultSet results) throws DatabaseException {

        try {
            ServDailyBean bean = new ServDailyBean();

		    bean.setRent_mng_id(results.getString("RENT_MNG_ID"));
			bean.setRent_l_cd(results.getString("RENT_L_CD"));
			bean.setCar_mng_id(results.getString("CAR_MNG_ID"));
			bean.setCar_no(results.getString("CAR_NO"));
			bean.setInit_reg_dt(results.getString("INIT_REG_DT"));
			bean.setClient_nm(results.getString("CLIENT_NM"));
			bean.setFirm_nm(results.getString("FIRM_NM"));
			bean.setServ_dt(results.getString("SERV_DT"));
			bean.setServ_dt1(results.getString("SERV_DT1"));
			bean.setServ_dt2(results.getString("SERV_DT2"));
			bean.setServ_dt3(results.getString("SERV_DT3"));
			bean.setServ_dt4(results.getString("SERV_DT4"));
			bean.setServ_dt5(results.getString("SERV_DT5"));
		   	bean.setServ_dt_c(results.getString("SERV_DT_C"));
			bean.setServ_dt1_c(results.getString("SERV_DT1_C"));
			bean.setServ_dt2_c(results.getString("SERV_DT2_C"));
			bean.setServ_dt3_c(results.getString("SERV_DT3_C"));
			bean.setServ_dt4_c(results.getString("SERV_DT4_C"));
			bean.setServ_dt5_c(results.getString("SERV_DT5_C"));
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}
    /**
     * 정기검사  월별 세부조회( 2001/12/28 ) - Kim JungTae
     */
    
    private ServDailyDetailBean makeServDailyDetailBean(ResultSet results) throws DatabaseException {

        try {
            ServDailyDetailBean bean = new ServDailyDetailBean();

		    bean.setRent_mng_id(results.getString("RENT_MNG_ID"));
			bean.setRent_l_cd(results.getString("RENT_L_CD"));
			bean.setCar_mng_id(results.getString("CAR_MNG_ID"));
			bean.setServ_id(results.getString("SERV_ID"));
			bean.setServ_st(results.getString("SERV_ST"));
			bean.setAccid_id(results.getString("ACCID_ID"));
			bean.setServ_dt(results.getString("SERV_DT"));
			bean.setChecker(results.getString("CHECKER"));
			bean.setTot_dist(results.getString("TOT_DIST"));
			bean.setRep_cont(results.getString("REP_CONT"));
		   	
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	} 
	
    /**
     * 정기검사 전체조회
     */
    
    public ServDailyBean [] getServDailyAll(String gubun, String gubun_nm, String ref_dt1, String ref_dt2) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        String subQuery = "";
        
        if(gubun.equals("car_no")){
    		subQuery = "and b.car_no like '%" + gubun_nm +"%'\n";
    	}else if(gubun.equals("firm_nm")){
    		subQuery = "and c.firm_nm like '%" + gubun_nm +"%'\n";
    	}else if(gubun.equals("client_nm")){
    		subQuery = "and c.client_nm like '%" + gubun_nm +"%'\n";
    	}else if(gubun.equals("user_nm")){
    		subQuery = "and d.user_nm like '%" + gubun_nm +"%' and d.user_id = a.mng_id \n";
    	}else if(gubun.equals("dt")){
    		subQuery = "\n";
    	}else{
    		subQuery = "and a.car_mng_id = ''\n";
    	}
        
        query = "select a.rent_mng_id as RENT_MNG_ID, a.rent_l_cd as RENT_L_CD,\n"
				+ "b.car_mng_id as CAR_MNG_ID, b.car_no as CAR_NO,\n" 
				+ "substr(b.init_reg_dt,1,4)||'-'||substr(b.init_reg_dt,5,2)||'-'||substr(b.init_reg_dt,7,2) as INIT_REG_DT,\n"
				+ "c.client_nm as CLIENT_NM, c.firm_nm as FIRM_NM, \n"
				+ "max(e.serv_dt) as SERV_DT, max(e1.serv_dt) as SERV_DT1, max(e2.serv_dt) as SERV_DT2,\n"
				+ "max(e3.serv_dt) as SERV_DT3, max(e4.serv_dt) as SERV_DT4, max(e5.serv_dt) as SERV_DT5,\n"
				+ "decode(max(e.serv_dt), null, decode(max(e1.serv_dt), null,decode(max(e2.serv_dt), null,'#ffffe0','#E7EFFF'),'#E7EFFF'),'#E7EFFF') as SERV_DT_C,\n"
				+ "decode(max(e1.serv_dt), null, decode(max(e2.serv_dt), null,decode(max(e3.serv_dt), null,'#ffffe0','#E7EFFF'),'#E7EFFF'),'#E7EFFF') as SERV_DT1_C,\n"
				+ "decode(max(e2.serv_dt), null, decode(max(e3.serv_dt), null,decode(max(e4.serv_dt), null,'#ffffe0','#E7EFFF'),'#E7EFFF'),'#E7EFFF') as SERV_DT2_C,\n"
				+ "decode(max(e3.serv_dt), null, decode(max(e4.serv_dt), null,decode(max(e5.serv_dt), null,'#ffffe0','#E7EFFF'),'#E7EFFF'),'#E7EFFF') as SERV_DT3_C,\n"
				+ "decode(max(e4.serv_dt), null, decode(max(e5.serv_dt), null,decode(max(e6.serv_dt), null,'#ffffe0','#E7EFFF'),'#E7EFFF'),'#E7EFFF') as SERV_DT4_C,\n"
				+ "decode(max(e5.serv_dt), null, decode(max(e6.serv_dt), null,decode(max(e7.serv_dt), null,'#ffffe0','#E7EFFF'),'#E7EFFF'),'#E7EFFF') as SERV_DT5_C\n"
				+ "from cont a, car_reg b, client c, users d, service e, service e1, service e2, service e3, service e4, service e5, service e6, service e7\n"
				+ "where a.car_mng_id=b.car_mng_id\n"
				+ "and a.client_id=c.client_id\n"
				+ "and a.car_mng_id = e.car_mng_id(+)\n"
				+ "and substr(e.serv_dt(+),1,6) = to_char(sysdate,'YYYYMM')\n"
				+ "and a.car_mng_id = e1.car_mng_id(+)\n"
				+ "and substr(e1.serv_dt(+),1,6) = to_char(add_months(sysdate,-1), 'YYYYMM')\n"
				+ "and a.car_mng_id = e2.car_mng_id(+)\n"
				+ "and substr(e2.serv_dt(+),1,6) = to_char(add_months(sysdate,-2), 'YYYYMM')\n"
				+ "and a.car_mng_id = e3.car_mng_id(+)\n"
				+ "and substr(e3.serv_dt(+),1,6) = to_char(add_months(sysdate,-3), 'YYYYMM')\n"
				+ "and a.car_mng_id = e4.car_mng_id(+)\n"
				+ "and substr(e4.serv_dt(+),1,6) = to_char(add_months(sysdate,-4), 'YYYYMM')\n"
				+ "and a.car_mng_id = e5.car_mng_id(+)\n"
				+ "and substr(e5.serv_dt(+),1,6) = to_char(add_months(sysdate,-5), 'YYYYMM')\n"
				+ "and a.car_mng_id = e6.car_mng_id(+)\n"
				+ "and substr(e6.serv_dt(+),1,6) = to_char(add_months(sysdate,-5), 'YYYYMM')\n"
				+ "and a.car_mng_id = e7.car_mng_id(+)\n"
				+ "and substr(e7.serv_dt(+),1,6) = to_char(add_months(sysdate,-5), 'YYYYMM')\n"
				+ subQuery
				+ "group by a.rent_mng_id, a.rent_l_cd , b.car_mng_id, b.car_no, b.init_reg_dt, c.client_nm, c.firm_nm \n"
				+ "order by a.rent_mng_id, a.rent_l_cd , b.car_mng_id, b.car_no, b.init_reg_dt, c.client_nm, c.firm_nm \n"
				+ " ";
        Collection<ServDailyBean> col = new ArrayList<ServDailyBean>();
        try{
            pstmt = con.prepareStatement(query);
    		//pstmt.setString(1, car_mng_id.trim());
    		
    		rs = pstmt.executeQuery();

            while(rs.next()){
                
				col.add(makeServDailyBean(rs));
 
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
        return (ServDailyBean[])col.toArray(new ServDailyBean[0]);
    }
    
    /**
     * 정비조회 월별
     */
    
    public ServDailyDetailBean [] getServDailyDetail(String car_mng_id, String rent_mng_id, String rent_l_cd, String serv_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        String subQuery = "";
        
        query = "select car_mng_id as CAR_MNG_ID, serv_id SERV_ID, serv_st SERV_ST, accid_id ACCID_ID, rent_mng_id RENT_MNG_ID, rent_l_cd RENT_L_CD, substr(serv_dt,1,4)||'-'||substr(serv_dt,5,2)||'-'||substr(serv_dt,7,2) SERV_DT, checker CHECKER, tot_dist TOT_DIST, rep_cont REP_CONT\n"
				+ "from service\n"
				+ "where car_mng_id=?\n"
				+ "and rent_mng_id=?\n"
				+ "and rent_l_cd=?\n"
				+ "and serv_dt like substr(?,1,6)||'%' \n"
				+ "and serv_st in ('1','2','3', '4')\n";
        Collection<ServDailyDetailBean> col = new ArrayList<ServDailyDetailBean>();
        try{
            pstmt = con.prepareStatement(query);
    		pstmt.setString(1, car_mng_id.trim());
    		pstmt.setString(2, rent_mng_id.trim());
    		pstmt.setString(3, rent_l_cd.trim());
    		pstmt.setString(4, serv_dt.trim());
    		
    		rs = pstmt.executeQuery();

            while(rs.next()){
                
				col.add(makeServDailyDetailBean(rs));
 
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
        return (ServDailyDetailBean[])col.toArray(new ServDailyDetailBean[0]);
    }
}
