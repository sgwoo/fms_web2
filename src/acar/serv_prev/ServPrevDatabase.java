/**
 * 예방정비
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2002. 3. 4
 * @ last modify date : 
 */
package acar.serv_prev;

import java.util.*;
import java.sql.*;
import acar.util.*;
import acar.common.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.UnknownDataException;
import acar.exception.DatabaseException;


public class ServPrevDatabase {

    private static ServPrevDatabase instance;
    private DBConnectionManager connMgr;   
    // Pool로 부터 Connection 객체를 가져올때 사용하는 Pool Name 
    private final String DATA_SOURCE = "acar"; 
 
    // 싱글톤 클래스로 구현 
    // 생성자를 private 로 선언
    public static synchronized ServPrevDatabase getInstance() throws DatabaseException {
        if (instance == null)
            instance = new ServPrevDatabase();
        return instance;
    }
    
    private ServPrevDatabase() throws DatabaseException {
        connMgr = DBConnectionManager.getInstance();
    }
    
    /**
     * 특정 레코드를 Bean에 저장하여 Bean을 리턴하는 메소드
     */
    /**
     * 예방정비 ( 2001/12/28 ) - Kim JungTae
     */
    
    private ServPrevBean makeServPrevBean(ResultSet results) throws DatabaseException {

        try {
            ServPrevBean bean = new ServPrevBean();

		    bean.setRent_mng_id(results.getString("RENT_MNG_ID"));
			bean.setRent_l_cd(results.getString("RENT_L_CD"));
			bean.setCar_mng_id(results.getString("CAR_MNG_ID"));
			bean.setCar_no(results.getString("CAR_NO"));
			bean.setInit_reg_dt(results.getString("INIT_REG_DT"));
			bean.setClient_nm(results.getString("CLIENT_NM"));
			bean.setFirm_nm(results.getString("FIRM_NM"));
			bean.setCar_name(results.getString("CAR_NAME"));
			bean.setCar_nm(results.getString("CAR_NM"));
			bean.setTot_dist(results.getString("TOT_DIST"));
			bean.setAverage_dist(results.getString("AVERAGE_DIST"));
			bean.setToday_dist(results.getString("TODAY_DIST"));
			
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}

	
    /**
     * 예방정비 전체조회
     */
    
    public ServPrevBean [] getServPrevAll(String gubun, String gubun_nm, String ref_dt1, String ref_dt2) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        String subQuery = "";
        
		query = " select"+
				" a.RENT_MNG_ID, a.RENT_L_CD, a.CAR_MNG_ID,"+
				" b.CAR_NO, b.CAR_NM, b.car_nm as CAR_NAME, b.INIT_REG_DT,"+
				" c.FIRM_NM, c.CLIENT_NM,"+
				" vt.tot_dist TOT_DIST, "+
				" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(a.dlv_dt,b.init_reg_dt),0,round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(a.dlv_dt,b.init_reg_dt),'YYYYMMDD'))))) as AVERAGE_DIST, "+
				" decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(a.dlv_dt,b.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(a.dlv_dt,b.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST "+
				" from cont a, car_reg b, client c, v_tot_dist vt, "+
				" (select a.* from fee a, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st) d,"+
				" (select a.* from service a, (select car_mng_id,max(serv_id) serv_id from service group by car_mng_id) b where a.car_mng_id=b.car_mng_id and a.serv_id=b.serv_id) e"+
				" where nvl(a.use_yn,'Y')='Y' and to_number(e.tot_dist)>0 and nvl(a.dlv_dt,b.init_reg_dt) is not null and nvl(a.dlv_dt,b.init_reg_dt)<>e.serv_dt";

		if(!gubun_nm.equals("")){
			if(gubun.equals("car_no")){
				query += "and b.car_no like '%" + gubun_nm +"%'\n";
    		}else if(gubun.equals("firm_nm")){
	    		query += "and c.firm_nm like '%" + gubun_nm +"%'\n";
			}else if(gubun.equals("client_nm")){
    			query += "and c.client_nm like '%" + gubun_nm +"%'\n";
	    	}
		}

		query += " and a.car_mng_id=b.car_mng_id"+
				" and a.client_id=c.client_id"+
				" and a.car_mng_id=vt.car_mng_id(+)"+
				" and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd"+
				" and a.car_mng_id=e.car_mng_id"+
				" ";

        query += " order by 11 desc";

        Collection<ServPrevBean> col = new ArrayList<ServPrevBean>();
        try{
            pstmt = con.prepareStatement(query);    		
    		rs = pstmt.executeQuery();
			
            while(rs.next()){                
				col.add(makeServPrevBean(rs));
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			 throw new DatabaseException();
			 //System.out.println("ServPrevDatabase:getServPrevAll"+se);
			 //System.out.println("ServPrevDatabase:getServPrevAll"+query);
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (ServPrevBean[])col.toArray(new ServPrevBean[0]);
    }          
}
