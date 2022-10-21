/**
 * 견적서관리
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2002. 3. 4
 * @ last modify date : 
 */
package acar.estimate_mng;

import java.util.*;
import java.sql.*;
import acar.util.*;
import java.io.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.UnknownDataException;
import acar.exception.DatabaseException;

public class EstimateDatabase {

    private static EstimateDatabase instance;
    private DBConnectionManager connMgr;   
    // Pool로 부터 Connection 객체를 가져올때 사용하는 Pool Name 
    private final String DATA_SOURCE = "acar"; 
 
    // 싱글톤 클래스로 구현 
    // 생성자를 private 로 선언
    public static synchronized EstimateDatabase getInstance() throws DatabaseException {
        if (instance == null)
            instance = new EstimateDatabase();
        return instance;
    }
    
    private EstimateDatabase() throws DatabaseException {
        connMgr = DBConnectionManager.getInstance();
    }

/*
	//견적서 ( 2001/12/28 ) - Kim JungTae
    private EstimateBean makeEstimateBean(ResultSet results) throws DatabaseException {

        try {
            EstimateBean bean = new EstimateBean();

			bean.setEst_id(results.getInt("EST_ID"));
		    bean.setUser_id(results.getString("USER_ID"));
		    bean.setUser_nm(results.getString("USER_NM"));
		    bean.setEst_nm(results.getString("EST_NM"));
		    bean.setEst_tel(results.getString("EST_TEL"));
		    bean.setEst_fax(results.getString("EST_FAX"));
		    bean.setEst_car_st(results.getString("EST_CAR_ST"));
		    bean.setCar_b_amt(results.getInt("CAR_B_AMT"));
		    bean.setRent_term(results.getString("RENT_TERM"));
		    bean.setOpt(results.getString("OPT"));
		    bean.setOpt_amt(results.getInt("OPT_AMT"));
		    bean.setCar_amt(results.getInt("CAR_AMT"));
		    bean.setSup_amt(results.getInt("SUP_AMT"));
		    bean.setAdd_amt(results.getInt("ADD_AMT"));
		    bean.setRent_tot_amt(results.getInt("RENT_TOT_AMT"));
		    bean.setF_rec_amt(results.getInt("F_REC_AMT"));
	   		bean.setReg_dt(results.getString("REG_DT"));
		    
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}

	//견적서 메모 ( 2001/12/28 ) - Kim JungTae
    private EstiMBean makeEstiMBean(ResultSet results) throws DatabaseException {

        try {
            EstiMBean bean = new EstiMBean();

			bean.setEst_id(results.getInt("EST_ID"));
		    bean.setUser_id(results.getString("USER_ID"));
		    bean.setSeq_no(results.getInt("SEQ_NO"));
		    bean.setSub(results.getString("SUB"));
		    bean.setNote(results.getString("NOTE"));
		    bean.setReg_dt(results.getString("REG_DT"));
		    
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}

    //견적서전체조회
    public EstimateBean [] getEstiAll(String gubun_nm, String ref_dt1, String ref_dt2) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = "select a.est_id EST_ID, a.user_id USER_ID, b.user_nm USER_NM, a.est_nm EST_NM, a.est_tel EST_TEL, a.est_fax EST_FAX, a.est_car_st EST_CAR_ST, a.car_b_amt CAR_B_AMT, a.rent_term RENT_TERM, a.opt OPT, a.opt_amt OPT_AMT, a.car_amt CAR_AMT, a.sup_amt SUP_AMT, a.add_amt ADD_AMT, a.rent_tot_amt RENT_TOT_AMT, a.f_rec_amt F_REC_AMT, a.reg_dt REG_DT\n"
				+ "from esti a, users b\n"
				+ "where a.user_id=b.user_id\n";

        Collection col = new ArrayList();
        try{
            pstmt = con.prepareStatement(query);
    		//pstmt.setString(1, start_year.trim());
    		
    		
    		rs = pstmt.executeQuery();

            while(rs.next()){
				col.add(makeEstimateBean(rs));
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
        }
        return (EstimateBean[])col.toArray(new EstimateBean[0]);
    }
	//견적서 메모 전체조회
    public EstiMBean [] getEstiMAll(int est_id, String user_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = "select EST_ID, USER_ID, SEQ_NO, SUB, NOTE, REG_DT\n"
				+ "from esti_m\n"
				+ "where est_id=? and user_id=?\n";

        Collection col = new ArrayList();
        try{
            pstmt = con.prepareStatement(query);
    		pstmt.setInt(1, est_id);
    		pstmt.setString(2, user_id);
    		
    		
    		rs = pstmt.executeQuery();

            while(rs.next()){
				col.add(makeEstiMBean(rs));
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
        }
        return (EstiMBean[])col.toArray(new EstiMBean[0]);
    }
    //견적서 세부조회
    public EstimateBean getEstimateBean(int est_id, String user_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        EstimateBean eb;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
       query = "select a.est_id EST_ID, a.user_id USER_ID, b.user_nm USER_NM, a.est_nm EST_NM, a.est_tel EST_TEL, a.est_fax EST_FAX, a.est_car_st EST_CAR_ST, a.car_b_amt CAR_B_AMT, a.rent_term RENT_TERM, a.opt OPT, a.opt_amt OPT_AMT, a.car_amt CAR_AMT, a.sup_amt SUP_AMT, a.add_amt ADD_AMT, a.rent_tot_amt RENT_TOT_AMT, a.f_rec_amt F_REC_AMT, a.reg_dt REG_DT\n"
				+ "from esti a, users b\n"
				+ "where a.est_id=? and a.user_id=? and a.user_id=b.user_id\n";
        try{
            pstmt = con.prepareStatement(query);
    		pstmt.setInt(1, est_id);
    		pstmt.setString(2, user_id.trim());
    		
    		rs = pstmt.executeQuery();

            if (rs.next())
                eb = makeEstimateBean(rs);
            else
                throw new UnknownDataException("Could not find Appcode # " + est_id );
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
        }
        return eb;
    }
	//견적서등록
    public int insertEsti(EstimateBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        PreparedStatement pstmt1 = null;
        ResultSet rs = null;
        String query = "";
        String query1 = "";
        int est_id = 0;
        int count = 0;
                
        query="insert into esti(EST_ID, USER_ID, EST_NM, EST_TEL, EST_FAX, EST_CAR_ST, CAR_B_AMT, RENT_TERM, OPT, OPT_AMT, CAR_AMT, SUP_AMT, ADD_AMT, RENT_TOT_AMT, F_REC_AMT, REG_DT)\n"
			+ "values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, to_char(sysdate,'YYYYMMDD'))\n";
        query1="select nvl(max(est_id)+1,1) from esti where user_id=?";
        try{
            con.setAutoCommit(false);
            pstmt1 = con.prepareStatement(query1);
            pstmt1.setString(1, bean.getUser_id().trim());
            
			rs = pstmt1.executeQuery();

            if(rs.next()){
				est_id = rs.getInt(1);
            }
			

            pstmt = con.prepareStatement(query);

			pstmt.setInt(1, est_id);
			pstmt.setString(2, bean.getUser_id().trim());
			pstmt.setString(3, bean.getEst_nm().trim());
			pstmt.setString(4, bean.getEst_tel().trim());
			pstmt.setString(5, bean.getEst_fax().trim());
			pstmt.setString(6, bean.getEst_car_st().trim());
			pstmt.setInt(7, bean.getCar_b_amt());
			pstmt.setString(8, bean.getRent_term().trim());
			pstmt.setString(9, bean.getOpt().trim());
			pstmt.setInt(10, bean.getOpt_amt());
			pstmt.setInt(11, bean.getCar_amt());
			pstmt.setInt(12, bean.getSup_amt());
			pstmt.setInt(13, bean.getAdd_amt());
			pstmt.setInt(14, bean.getRent_tot_amt());
			pstmt.setInt(15, bean.getF_rec_amt());
           
            count = pstmt.executeUpdate();
             
            rs.close();
            pstmt1.close();
            pstmt.close();
            con.commit();

        }catch(SQLException se){
            try{
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(rs != null) rs.close();
                if(pstmt1 != null) pstmt1.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
        }

        return count;
    }

    //스케쥴수정
    public int updateEsti(EstimateBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        int count = 0;
                
        query="UPDATE ESTI SET EST_NM=?, EST_TEL=?, EST_FAX=?, EST_CAR_ST=?, CAR_B_AMT=?, RENT_TERM=?, OPT=?, OPT_AMT=?, CAR_AMT=?, SUP_AMT=?, ADD_AMT=?, RENT_TOT_AMT=?, F_REC_AMT=?\n"
            + "where ust_id=?, user_id=?\n";
        
       try{
            con.setAutoCommit(false);
            
            pstmt = con.prepareStatement(query);

			pstmt.setString(1, bean.getEst_nm().trim());
			pstmt.setString(2, bean.getEst_tel().trim());
			pstmt.setString(3, bean.getEst_fax().trim());
			pstmt.setString(4, bean.getEst_car_st().trim());
			pstmt.setInt(5, bean.getCar_b_amt());
			pstmt.setString(6, bean.getRent_term().trim());
			pstmt.setString(7, bean.getOpt().trim());
			pstmt.setInt(8, bean.getOpt_amt());
			pstmt.setInt(9, bean.getCar_amt());
			pstmt.setInt(10, bean.getSup_amt());
			pstmt.setInt(11, bean.getAdd_amt());
			pstmt.setInt(12, bean.getRent_tot_amt());
			pstmt.setInt(13, bean.getF_rec_amt());
          	pstmt.setInt(14, bean.getEst_id());
			pstmt.setString(15, bean.getUser_id().trim()); 
            
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(SQLException se){
            try{
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
        }

        return count;
    }
	//견적서 메모 등록
    public int insertEstiM(EstiMBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        PreparedStatement pstmt1 = null;
        ResultSet rs = null;
        String query = "";
        String query1 = "";
        int seq_no = 0;
        int count = 0;
                
        query="insert into esti_m(EST_ID, USER_ID, SEQ_NO, SUB, NOTE, REG_DT)\n"
			+ "values(?, ?, ?, ?, ?, to_char(sysdate,'YYYYMMDD'))\n";
        query1="select nvl(max(seq_no)+1,1) from esti_m where est_id=? and user_id=?";
        try{
            con.setAutoCommit(false);
            pstmt1 = con.prepareStatement(query1);
            pstmt1.setInt(1, bean.getEst_id());
            pstmt1.setString(2, bean.getUser_id().trim());
            
			rs = pstmt1.executeQuery();

            if(rs.next()){
				seq_no = rs.getInt(1);
            }
			

            pstmt = con.prepareStatement(query);
			pstmt.setInt(1, bean.getEst_id());
			pstmt.setString(2, bean.getUser_id().trim());
			pstmt.setInt(3, seq_no);
			pstmt.setString(4, bean.getSub().trim());
			pstmt.setString(5, bean.getNote().trim());
			//pstmt.setString(6, bean.getReg_dt().trim());
			           
            count = pstmt.executeUpdate();
             
            rs.close();
            pstmt1.close();
            pstmt.close();
            con.commit();

        }catch(SQLException se){
            try{
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(rs != null) rs.close();
                if(pstmt1 != null) pstmt1.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
        }

        return count;
    }
*/
}
