/**
 * 차량정비
 */
package acar.car_service;

import java.util.*;
import java.sql.*;
import acar.util.*;
import acar.common.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.UnknownDataException;
import acar.exception.DatabaseException;
import acar.cont.*;

public class AddCarServDatabase {

    private static AddCarServDatabase instance;
    private DBConnectionManager connMgr;   
    private final String DATA_SOURCE = "acar"; 
 
    public static synchronized AddCarServDatabase getInstance() throws DatabaseException {
        if (instance == null)
            instance = new AddCarServDatabase();
        return instance;
    }
    
    private AddCarServDatabase() throws DatabaseException {
        connMgr = DBConnectionManager.getInstance();
    }

	// BEAN -------------------------------------------------------------------------------------------------
	
	/**
     * 서비스
     */    
    private ServiceBean makeServiceBean(ResultSet results) throws DatabaseException {
        try {
            ServiceBean bean = new ServiceBean();
		    bean.setCar_mng_id(results.getString("CAR_MNG_ID")); 					
			bean.setServ_id(results.getString("SERV_ID")); 
			bean.setAccid_id(results.getString("ACCID_ID")); 
			bean.setRent_mng_id(results.getString("RENT_MNG_ID")); 
			bean.setRent_l_cd(results.getString("RENT_L_CD")); 
			bean.setOff_id(results.getString("OFF_ID"));
			bean.setOff_nm(results.getString("OFF_NM")); 
			bean.setServ_dt(results.getString("SERV_DT")); 
			bean.setServ_st(results.getString("SERV_ST")); 
			bean.setChecker(results.getString("CHECKER")); 
			bean.setTot_dist(results.getString("TOT_DIST")); 
			bean.setRep_nm(results.getString("REP_NM")); 
			bean.setRep_tel(results.getString("REP_TEL")); 
			bean.setRep_m_tel(results.getString("REP_M_TEL")); 
			bean.setRep_amt(results.getInt("REP_AMT")); 
			bean.setSup_amt(results.getInt("SUP_AMT")); 
			bean.setAdd_amt(results.getInt("ADD_AMT")); 
			bean.setDc(results.getInt("DC")); 
			bean.setTot_amt(results.getInt("TOT_AMT")); 
			bean.setSup_dt(results.getString("SUP_DT")); 
			bean.setSet_dt(results.getString("SET_DT")); 
			bean.setBank(results.getString("BANK")); 
			bean.setAcc_no(results.getString("ACC_NO")); 
			bean.setAcc_nm(results.getString("ACC_NM")); 
			bean.setRep_item(results.getString("REP_ITEM")); 
			bean.setRep_cont(results.getString("REP_CONT")); 
			bean.setCust_plan_dt(results.getString("CUST_PLAN_DT")); 
			bean.setCust_amt(results.getInt("CUST_AMT")); 
			bean.setCust_agnt(results.getString("CUST_AGNT"));
			bean.setAccid_dt(results.getString("ACCID_DT"));
			//추가
			bean.setOff_tel(results.getString("OFF_TEL"));
			bean.setOff_fax(results.getString("OFF_FAX")); 
			bean.setCust_req_dt(results.getString("CUST_REQ_DT"));
			bean.setCust_pay_dt(results.getString("CUST_PAY_DT"));
			bean.setReg_dt(results.getString("REG_DT"));
			bean.setReg_id(results.getString("REG_ID"));
			bean.setUpdate_dt(results.getString("UPDATE_DT"));
			bean.setUpdate_id(results.getString("UPDATE_ID"));
			bean.setScan_file(results.getString("SCAN_FILE"));
			bean.setNo_dft_yn(results.getString("NO_DFT_YN"));
			bean.setNo_dft_cau(results.getString("NO_DFT_CAU"));
			bean.setBill_doc_yn(results.getString("BILL_DOC_YN"));
			bean.setBill_mon(results.getString("BILL_MON"));
			bean.setExt_amt(results.getInt("EXT_AMT")); 
			bean.setCls_amt(results.getInt("CLS_AMT")); 
			
			bean.setR_labor(results.getInt("r_labor"));  
			bean.setR_amt(results.getInt("r_amt"));  
			bean.setR_j_amt(results.getInt("r_j_amt"));  	
			
			bean.setCust_s_amt(results.getInt("cust_s_amt"));  	
			bean.setCust_v_amt(results.getInt("cust_v_amt"));  	
			bean.setCls_s_amt(results.getInt("cls_s_amt"));  	
			bean.setCls_v_amt(results.getInt("cls_v_amt"));  
			bean.setExt_cau(results.getString("ext_cau"));	
			bean.setSac_yn(results.getString("sac_yn"));	
			bean.setSac_dt(results.getString("sac_dt"));	
			
			bean.setPaid_st(results.getString("paid_st"));	
			bean.setBus_id2(results.getString("bus_id2"));	
			bean.setPaid_type(results.getString("paid_type"));				

			bean.setSaleebill_yn(results.getString("saleebill_yn"));				 //입금표발행 요청 
			bean.setAgnt_email(results.getString("agnt_email"));				 //입금표발행 요청 

		
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}

	/**
     * 서비스 건별 간편 조회
     */    
    private ServiceBean makeServiceBeanCase(ResultSet results) throws DatabaseException {
        try {
            ServiceBean bean = new ServiceBean();
			bean.setOff_nm(results.getString("OFF_NM")); 
			bean.setServ_dt(results.getString("SERV_DT")); 
			bean.setServ_st(results.getString("SERV_ST")); 
			bean.setChecker(results.getString("CHECKER")); 
			bean.setTot_dist(results.getString("TOT_DIST")); 
			bean.setRep_cont(results.getString("REP_CONT")); 
			//추가
			bean.setOff_tel(results.getString("OFF_TEL"));
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}

	// 조회 -------------------------------------------------------------------------------------------------

    /**
     * 서비스 개별조회 : car_accid_all_u.jsp
     */
    public ServiceBean getService( String car_mng_id, String accid_id ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		ServiceBean sb = new ServiceBean();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = " select"+
				" a.car_mng_id, a.serv_id, a.accid_id, a.rent_mng_id, a.rent_l_cd, a.off_id, b.off_nm, b.off_tel, b.off_fax,"+
				" nvl2(a.serv_dt,substr(a.serv_dt,1,4)||'-'||substr(a.serv_dt,5,2)||'-'||substr(a.serv_dt,7,2),'') SERV_DT,"+
				" a.serv_st, a.checker, a.tot_dist, a.rep_nm, a.rep_tel, a.rep_m_tel, a.rep_amt, a.sup_amt,"+
				" a.add_amt, a.dc, a.tot_amt, nvl2(a.sup_dt,substr(a.sup_dt,1,4)||'-'||substr(a.sup_dt,5,2)||'-'||substr(a.sup_dt,7,2),'') SUP_DT,"+
				" nvl2(a.set_dt,substr(a.set_dt,1,4)||'-'||substr(a.set_dt,5,2)||'-'||substr(a.set_dt,7,2),'') SET_DT,"+
				" a.bank, a.acc_no, a.acc_nm, a.rep_item, a.rep_cont, a.ext_amt, "+
				" nvl2(a.cust_plan_dt,substr(a.cust_plan_dt,1,4)||'-'||substr(a.cust_plan_dt,5,2)||'-'||substr(a.cust_plan_dt,7,2),'') CUST_PLAN_DT,"+
				" a.cust_amt, a.cust_agnt, a.accid_dt, cust_req_dt, cust_pay_dt, a.reg_dt, a.reg_id, update_dt, update_id, scan_file, no_dft_yn, no_dft_cau, bill_doc_yn, bill_mon, a.cls_amt, \n"+ 
				" a.r_labor, a.r_amt, a.r_j_amt, a.cust_s_amt, a.cust_v_amt, a.cls_s_amt, a.cls_v_amt, a.ext_cau, a.sac_yn, a.sac_dt, a.paid_st, a.bus_id2, a.paid_type , a.saleebill_yn , a.agnt_email \n"+ 
				" from service a, serv_off b\n"+
				" where a.car_mng_id='"+car_mng_id+"' and a.accid_id='"+accid_id+"'\n"+
				" and a.off_id=b.off_id  order by a.tot_amt desc \n";
				

        try{

			
			pstmt = con.prepareStatement(query);
    		rs = pstmt.executeQuery();
            if (rs.next()){
                sb = makeServiceBean(rs);
			}
            
            rs.close();
            pstmt.close();

        }catch(SQLException se){
			System.out.println("[AddCarServDatabase:getService]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return sb;
    }

    /**
     * 서비스 개별조회 : car_accid_all_u.jsp
     */
    public ServiceBean getService( String car_mng_id, String accid_id, String serv_id ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		ServiceBean sb = new ServiceBean();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = " select"+
				" a.car_mng_id, a.serv_id, a.accid_id, a.rent_mng_id, a.rent_l_cd, a.off_id, b.off_nm, b.off_tel, b.off_fax,"+
				" nvl2(a.serv_dt,substr(a.serv_dt,1,4)||'-'||substr(a.serv_dt,5,2)||'-'||substr(a.serv_dt,7,2),'') SERV_DT,"+
				" a.serv_st, a.checker, a.tot_dist, a.rep_nm, a.rep_tel, a.rep_m_tel, a.rep_amt, a.sup_amt,"+
				" a.add_amt, a.dc, a.tot_amt, nvl2(a.sup_dt,substr(a.sup_dt,1,4)||'-'||substr(a.sup_dt,5,2)||'-'||substr(a.sup_dt,7,2),'') SUP_DT,"+
				" nvl2(a.set_dt,substr(a.set_dt,1,4)||'-'||substr(a.set_dt,5,2)||'-'||substr(a.set_dt,7,2),'') SET_DT,"+
				" a.bank, a.acc_no, a.acc_nm, a.rep_item, a.rep_cont, a.ext_amt, "+
				" nvl2(a.cust_plan_dt,substr(a.cust_plan_dt,1,4)||'-'||substr(a.cust_plan_dt,5,2)||'-'||substr(a.cust_plan_dt,7,2),'') CUST_PLAN_DT,"+
				" a.cust_amt, a.cust_agnt, a.accid_dt, a.cust_req_dt, a.cust_pay_dt, a.reg_dt, a.reg_id, update_dt, update_id, scan_file, no_dft_yn, no_dft_cau, bill_doc_yn, bill_mon, a.cls_amt, \n"+ 
				" a.r_labor, a.r_amt, a.r_j_amt, a.cust_s_amt, a.cust_v_amt, a.cls_s_amt, a.cls_v_amt, a.ext_cau, a.sac_yn, a.sac_dt, a.paid_st, a.bus_id2 , a.paid_type , a.saleebill_yn , a.agnt_email \n"+ 
				" from service a, serv_off b \n"+
				" where a.car_mng_id='"+car_mng_id+"' and a.accid_id='"+accid_id+"' and a.serv_id='"+serv_id+"'\n"+
				" and a.off_id=b.off_id(+)  order by a.tot_amt desc \n";
				

        try{

			
			pstmt = con.prepareStatement(query);
    		rs = pstmt.executeQuery();
            if (rs.next()){
                sb = makeServiceBean(rs);
			}
            
            rs.close();
            pstmt.close();

        }catch(SQLException se){
			System.out.println("[AddCarServDatabase:getService]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return sb;
    }
    
    
     public int  getService( String car_mng_id, String accid_id, String serv_id, String gubun ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

	    PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        int cnt = 0;
        
        query = " select count(0) cnt "+			
				" from service a, serv_off b\n"+
				" where a.car_mng_id='"+car_mng_id+"' and a.accid_id='"+accid_id+"' and a.serv_id='"+serv_id+"'\n"+
				" and a.off_id=b.off_id(+)  order by a.tot_amt desc \n";
				

        try{

			pstmt = con.prepareStatement(query);
    		rs = pstmt.executeQuery();
            if (rs.next()){
                cnt =  rs.getInt(1);
			}
            
            rs.close();
            pstmt.close();

        }catch(SQLException se){
			System.out.println("[AddCarServDatabase:getService]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return cnt;
    }

 //면책금 청구여부 -선청구후 또 면책금 청구 방지위해...	 선청구가 있을 때만 적용 (20140326)
    public int  getServCustCnt( String car_mng_id, String accid_id ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

	    PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        int cnt = 0;
        
        query = " select count(*) cnt "+			
				" from service a\n"+
				" where a.car_mng_id='"+car_mng_id+"' and a.accid_id='"+accid_id+"'  and  a.cust_amt > 0  and  a.off_id is null ";
								
        try{

			pstmt = con.prepareStatement(query);
    		rs = pstmt.executeQuery();
            if (rs.next()){
                cnt =  rs.getInt(1);
			}
            
            rs.close();
            pstmt.close();

        }catch(SQLException se){
			System.out.println("[AddCarServDatabase:getSgetServCustCntervice]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return cnt;
    }
    	

    /**
     * 서비스 개별 간단 조회 : sub_cont.jsp
     */
    public ServiceBean getServiceCase(String rent_l_cd, String car_mng_id, String accid_id, String serv_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		ServiceBean sb = new ServiceBean();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = " select"+
				" b.off_nm, b.off_tel, a.rep_cont, a.serv_st, a.checker, a.tot_dist,"+
				" nvl2(a.serv_dt,substr(a.serv_dt,1,4)||'-'||substr(a.serv_dt,5,2)||'-'||substr(a.serv_dt,7,2),'') serv_dt"+
				" from service a, serv_off b\n"+
				" where a.rent_l_cd='"+rent_l_cd+"' and a.car_mng_id='"+car_mng_id+"' and a.accid_id='"+accid_id+"' and a.serv_id='"+serv_id+"'\n"+
				" and a.off_id=b.off_id\n";

        try{

			pstmt = con.prepareStatement(query);
    		rs = pstmt.executeQuery();
            if (rs.next()){
                sb = makeServiceBeanCase(rs);
			}
            
            rs.close();
            pstmt.close();

        }catch(SQLException se){
			System.out.println("[AddCarServDatabase:getServiceCase]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return sb;
    }


	// 등록 -------------------------------------------------------------------------------------------------

	/**
     * 각종수리 등록 : car_accid_all_i_a.jsp
     */
    public String insertService(ServiceBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
        PreparedStatement pstmt1 = null;
        ResultSet rs = null;
        String query = "";
        String query1 = "";
        String serv_id = "";
        int count = 0;
                
        query = " INSERT INTO service ("+
				"		CAR_MNG_ID, SERV_ID, ACCID_ID, RENT_MNG_ID, RENT_L_CD,"+
				"		OFF_ID, SERV_DT, SERV_ST, CHECKER, TOT_DIST,"+
				"		REP_NM, REP_TEL, REP_M_TEL, REP_AMT, SUP_AMT,"+
				"		ADD_AMT, DC, TOT_AMT, SUP_DT, SET_DT,"+
				"		BANK, ACC_NO, ACC_NM, REP_ITEM, REP_CONT,"+
				"		CUST_PLAN_DT, CUST_AMT, CUST_AGNT, ACCID_DT,"+//29
				"		CUST_REQ_DT, CUST_PAY_DT, REG_DT, REG_ID, UPDATE_DT, UPDATE_ID, "+
				"	    SCAN_FILE, NO_DFT_YN, NO_DFT_CAU,"+//38
				"		BILL_DOC_YN, BILL_MON, cust_s_amt, cust_v_amt, cls_s_amt, cls_v_amt, ext_cau "+
				"     )\n"+
				" values "+
				"     (	?, ?, ?, ?, ?, "+//CAR_MNG_ID
				"	    ?, replace(?,'-',''), ?, ?, ?, "+//OFF_ID
				"	    ?, ?, ?, ?, ?, "+//REP_NM
				"	    ?, ?, ?, replace(?,'-',''), replace(?,'-',''), "+//ADD_AMT
				"	    ?, ?, ?, ?, ?, "+//BANK
				"	    replace(?,'-',''), ?, ?, replace(?,'-',''),"+//CUST_PLAN_DT
				"		replace(?,'-',''), replace(?,'-',''), nvl(replace(?,'-',''),to_char(sysdate,'YYYYMMDD')), ?, replace(?,'-',''), ?, "+//CUST_REQ_DT
				"	    ?, ?, ?,"+//SCAN_FILE
				"       ?, ?, ?, ?, ?, ?, ? "+//BILL_DOC_YN
				"	  )\n";

		query1="select nvl(lpad(max(SERV_ID)+1,6,'0'),'000001') from service where car_mng_id=? and serv_id not like 'N%'";

		try{

			con.setAutoCommit(false);

            pstmt1 = con.prepareStatement(query1);
            pstmt1.setString(1, bean.getCar_mng_id().trim());
			rs = pstmt1.executeQuery();
            if(rs.next()){
				serv_id = rs.getString(1);
            }
            rs.close();
            pstmt1.close();

			pstmt = con.prepareStatement(query);
            pstmt.setString(1, bean.getCar_mng_id().trim());
            pstmt.setString(2, serv_id.trim());
			pstmt.setString(3, bean.getAccid_id().trim());
			pstmt.setString(4, bean.getRent_mng_id().trim());
			pstmt.setString(5, bean.getRent_l_cd().trim());
			pstmt.setString(6, bean.getOff_id().trim());
			pstmt.setString(7, bean.getServ_dt().trim());
			pstmt.setString(8, bean.getServ_st().trim());
			pstmt.setString(9, bean.getChecker().trim());
			pstmt.setString(10, bean.getTot_dist().trim());
			pstmt.setString(11, bean.getRep_nm().trim());
			pstmt.setString(12, bean.getRep_tel().trim());
			pstmt.setString(13, bean.getRep_m_tel().trim());
			pstmt.setInt   (14, bean.getRep_amt());
			pstmt.setInt   (15, bean.getSup_amt());
			pstmt.setInt   (16, bean.getAdd_amt());
			pstmt.setInt   (17, bean.getDc());
			pstmt.setInt   (18, bean.getTot_amt());
			pstmt.setString(19, bean.getSup_dt().trim());
			pstmt.setString(20, bean.getSet_dt().trim());
			pstmt.setString(21, bean.getBank().trim());
			pstmt.setString(22, bean.getAcc_no().trim());
			pstmt.setString(23, bean.getAcc_nm().trim());
			pstmt.setString(24, bean.getRep_item().trim());
			pstmt.setString(25, bean.getRep_cont().trim());
			pstmt.setString(26, bean.getCust_plan_dt().trim());
			pstmt.setInt   (27, bean.getCust_amt());
			pstmt.setString(28, bean.getCust_agnt().trim());
			pstmt.setString(29, bean.getAccid_dt().trim());
			pstmt.setString(30, bean.getCust_req_dt().trim());
			pstmt.setString(31, bean.getCust_pay_dt().trim());
			pstmt.setString(32, bean.getReg_dt().trim());
			pstmt.setString(33, bean.getReg_id().trim());
			pstmt.setString(34, bean.getUpdate_dt().trim());
			pstmt.setString(35, bean.getUpdate_id().trim());
			pstmt.setString(36, bean.getScan_file().trim());            
			pstmt.setString(37, bean.getNo_dft_yn().trim());            
			pstmt.setString(38, bean.getNo_dft_cau().trim());            
			pstmt.setString(39, bean.getBill_doc_yn().trim());            
			pstmt.setString(40, bean.getBill_mon().trim());   			
			pstmt.setInt   (41, bean.getCust_s_amt());
			pstmt.setInt   (42, bean.getCust_v_amt());
			pstmt.setInt   (43, bean.getCls_s_amt());
			pstmt.setInt   (44, bean.getCls_v_amt());
			pstmt.setString(45, bean.getExt_cau().trim());   							         
            count = pstmt.executeUpdate();             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[AddCarServDatabase:insertService]\n"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
                if(pstmt1 != null) pstmt1.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return serv_id;
    }


	// 수정 -------------------------------------------------------------------------------------------------

    /**
     * 각종수리 수정 : car_accid_all_u_a.jsp
     */    
    public int updateService(ServiceBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " UPDATE service SET "+
				" ACCID_ID=?, RENT_MNG_ID=?, RENT_L_CD=?, OFF_ID=?, SERV_DT=replace(?,'-',''), SERV_ST=?, CHECKER=?, TOT_DIST=?, REP_NM=?, REP_TEL=?,"+  //10
				" REP_M_TEL=?, REP_AMT=?, SUP_AMT=?, ADD_AMT=?, DC=?, TOT_AMT=?, SUP_DT=replace(?,'-',''), SET_DT=replace(?,'-',''), BANK=?, ACC_NO=?,"+ //10
				" ACC_NM=?, REP_ITEM=?, REP_CONT=?, CUST_PLAN_DT=replace(?,'-',''), CUST_AMT=?, CUST_AGNT=?, ACCID_DT=replace(?,'-',''), "+ //7
				" CUST_REQ_DT=replace(?,'-',''), CUST_PAY_DT=replace(?,'-',''), UPDATE_DT=replace(?,'-',''), UPDATE_ID=?, SCAN_FILE=?,"+//5
				" NO_DFT_YN=?, NO_DFT_CAU=?, BILL_DOC_YN=?, BILL_MON=? , EXT_AMT=? , CLS_AMT = ?, "+//8
				" EXT_CAU= ?, CLS_S_AMT= ? , CLS_V_AMT = ?, CUST_S_AMT = ?, CUST_V_AMT = ?, SAC_YN = ?,  SAC_DT=replace(?,'-',''), PAID_ST = ? , " + //7
				" bus_id2 = ? , paid_type = ? , saleebill_yn = ? , agnt_email = ?   "+//3
				" WHERE CAR_MNG_ID=? AND SERV_ID=?\n";
            
       try{

				
            con.setAutoCommit(false);

            pstmt = con.prepareStatement(query);            
			pstmt.setString(1, bean.getAccid_id().trim());
			pstmt.setString(2, bean.getRent_mng_id().trim());
			pstmt.setString(3, bean.getRent_l_cd().trim());
			pstmt.setString(4, bean.getOff_id().trim());
			pstmt.setString(5, bean.getServ_dt().trim());
			pstmt.setString(6, bean.getServ_st().trim());
			pstmt.setString(7, bean.getChecker().trim());
			pstmt.setString(8, bean.getTot_dist().trim());
			pstmt.setString(9, bean.getRep_nm().trim());
			pstmt.setString(10, bean.getRep_tel().trim());
			
			pstmt.setString(11, bean.getRep_m_tel().trim());
			pstmt.setInt(12, bean.getRep_amt());
			pstmt.setInt(13, bean.getSup_amt());
			pstmt.setInt(14, bean.getAdd_amt());
			pstmt.setInt(15, bean.getDc());
			pstmt.setInt(16, bean.getTot_amt());
			pstmt.setString(17, bean.getSup_dt().trim());
			pstmt.setString(18, bean.getSet_dt().trim());
			pstmt.setString(19, bean.getBank().trim());
			pstmt.setString(20, bean.getAcc_no().trim());
			
			pstmt.setString(21, bean.getAcc_nm().trim());
			pstmt.setString(22, bean.getRep_item().trim());
			pstmt.setString(23, bean.getRep_cont().trim());
			pstmt.setString(24, bean.getCust_plan_dt().trim());
			pstmt.setInt(25, bean.getCust_amt());
			pstmt.setString(26, bean.getCust_agnt().trim());
			pstmt.setString(27, bean.getAccid_dt().trim());
			
			pstmt.setString(28, bean.getCust_req_dt().trim());
			pstmt.setString(29, bean.getCust_pay_dt().trim());
			pstmt.setString(30, bean.getUpdate_dt().trim());
			pstmt.setString(31, bean.getUpdate_id().trim());
			pstmt.setString(32, bean.getScan_file().trim());
			
			pstmt.setString(33, bean.getNo_dft_yn().trim());
			pstmt.setString(34, bean.getNo_dft_cau().trim());
			pstmt.setString(35, bean.getBill_doc_yn().trim());
			pstmt.setString(36, bean.getBill_mon().trim());			
			pstmt.setInt(37, bean.getExt_amt());
			pstmt.setInt(38, bean.getCls_amt());
			
			pstmt.setString(39, bean.getExt_cau().trim());
			pstmt.setInt(40, bean.getCls_s_amt());
			pstmt.setInt(41, bean.getCls_v_amt());
			pstmt.setInt(42, bean.getCust_s_amt());
			pstmt.setInt(43, bean.getCust_v_amt());			
			pstmt.setString(44, bean.getSac_yn().trim());
			pstmt.setString(45, bean.getSac_dt().trim());			
			pstmt.setString(46, bean.getPaid_st().trim());
			pstmt.setString(47, bean.getBus_id2().trim());
			pstmt.setString(48, bean.getPaid_type().trim());
			pstmt.setString(49, bean.getSaleebill_yn().trim());
			pstmt.setString(50, bean.getAgnt_email().trim());
			
			pstmt.setString(51, bean.getCar_mng_id().trim());
          pstmt.setString(52, bean.getServ_id().trim());

			count = pstmt.executeUpdate();
                                 
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[AddCarServDatabase:updateService]\n"+se);
			/*	System.out.println( bean.getAccid_id().trim());
				System.out.println( bean.getRent_mng_id().trim());
				System.out.println( bean.getRent_l_cd().trim());
				System.out.println( bean.getOff_id().trim());
				System.out.println( bean.getServ_dt().trim());
				System.out.println( bean.getServ_st().trim());
				System.out.println( bean.getChecker().trim());
				System.out.println( bean.getTot_dist().trim());
				System.out.println( bean.getRep_nm().trim());
				System.out.println( bean.getRep_tel().trim());
				
				System.out.println( bean.getRep_m_tel().trim());
				System.out.println( bean.getRep_amt());
				System.out.println( bean.getSup_amt());
				System.out.println( bean.getAdd_amt());
				System.out.println( bean.getDc());
				System.out.println( bean.getTot_amt());
				System.out.println( bean.getSup_dt().trim());
				System.out.println( bean.getSet_dt().trim());
				System.out.println( bean.getBank().trim());
				System.out.println( bean.getAcc_no().trim());
				
				System.out.println( bean.getAcc_nm().trim());
				System.out.println( bean.getRep_item().trim());
				System.out.println( bean.getRep_cont().trim());
				System.out.println( bean.getCust_plan_dt().trim());
				System.out.println( bean.getCust_amt());
				System.out.println( bean.getCust_agnt().trim());
				System.out.println( bean.getAccid_dt().trim());
				
				System.out.println( bean.getCust_req_dt().trim());
				System.out.println( bean.getCust_pay_dt().trim());
				System.out.println( bean.getUpdate_dt().trim());
				System.out.println( bean.getUpdate_id().trim());
				System.out.println( bean.getScan_file().trim());
				
				System.out.println( bean.getReg_dt().trim());
				System.out.println( bean.getReg_id().trim());
				System.out.println( bean.getNo_dft_yn().trim());
				System.out.println( bean.getNo_dft_cau().trim());
				System.out.println( bean.getBill_doc_yn().trim());
				System.out.println( bean.getBill_mon().trim());			
				System.out.println( bean.getExt_amt());
				System.out.println( bean.getCls_amt());
				
				System.out.println( bean.getExt_cau().trim());
				System.out.println( bean.getCls_s_amt());
				System.out.println( bean.getCls_v_amt());
				System.out.println( bean.getCust_s_amt());
				System.out.println( bean.getCust_v_amt());
				
				System.out.println( bean.getSac_yn().trim());
				System.out.println( bean.getSac_dt().trim());
				
				System.out.println( bean.getCar_mng_id().trim());
	            System.out.println( bean.getServ_id().trim());*/
            
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }


	 /**
     * 면책금 스케쥴 생성내역 insert (
     */
    public int insertServiceScdExt(ServiceBean bean) throws DatabaseException, DataSourceEmptyException{
         Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        String query = "";
           
        int count = 0;
                
        query = " INSERT INTO SCD_EXT"+
				" (RENT_MNG_ID, RENT_L_CD, RENT_ST, RENT_SEQ, EXT_ST, "+
				" EXT_ID, EXT_TM, EXT_S_AMT, EXT_V_AMT, EXT_EST_DT,"+	
				" DLY_DAYS, DLY_AMT, BILL_YN , UPDATE_DT, UPDATE_ID ) "+			
				" values(?, ?, '9', '1', '3',"+					
				" ?, '1', ?, ?, replace(?,'-',''),"+
				" '0', 0, ?, to_char(sysdate,'YYYYMMDD'), ?)";		
	    
        try{
            con.setAutoCommit(false);
         
            pstmt = con.prepareStatement(query);
          	pstmt.setString(1, bean.getRent_mng_id().trim());
			pstmt.setString(2, bean.getRent_l_cd().trim());
			pstmt.setString(3, bean.getServ_id().trim());
			
			int s_amt = 0;
      		int v_amt = 0;
        	int n_amt = bean.getCust_amt();	
         	int n_s_amt = bean.getCust_s_amt();	
        	
        //	if (bean.getBill_doc_yn().equals("0") ) {        		
        	s_amt = n_amt;
			v_amt = n_amt - s_amt;        		
      //  	} else {	        					
			//	s_amt = (new Double(n_amt/1.1)).intValue();
		//		s_amt = n_s_amt;
		//		v_amt = n_amt - s_amt;
		//	}
			
			pstmt.setInt(4, s_amt);
			pstmt.setInt(5, v_amt);	
			
			String ext_est_dt ="";
			ext_est_dt = bean.getCust_plan_dt().trim();
			
			if (ext_est_dt.equals("")) {
				ext_est_dt = bean.getCust_req_dt().trim();
			}
			
			pstmt.setString(6, ext_est_dt);	
			
			String bill_yn = "Y";
			
			if ( bean.getNo_dft_yn().trim().equals("Y") || n_amt == 0 ) {
				bill_yn = "N";
			}
			pstmt.setString(7, bill_yn);	
			
		    pstmt.setString(8, bean.getReg_id().trim());
		    count = pstmt.executeUpdate();
            
            pstmt.close(); 
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[AddCarServDatabase:insertServiceScdExt]\n"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
         }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
         }
         return count;
    }
    
    
     /**
     * 면책금 스케쥴 생성내역 여부 확인 (
     */
    public int getServiceScdExt(ServiceBean bean) throws DatabaseException, DataSourceEmptyException{
         Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
           
        int count = 0;
                
        query = " select count(*) cnt from scd_ext "+
				" where ext_st = '3' and rent_mng_id = ? and rent_l_cd = ? and ext_id = ?  and ext_tm = '1' ";
					
	    
        try{
                 
            pstmt = con.prepareStatement(query);
          	pstmt.setString(1, bean.getRent_mng_id().trim());
			pstmt.setString(2, bean.getRent_l_cd().trim());
			pstmt.setString(3, bean.getServ_id().trim());
			
			rs = pstmt.executeQuery();
            if (rs.next()){
                count = rs.getInt("cnt");
			}
            
            rs.close();
            pstmt.close();
		
	    }catch(SQLException se){
			System.out.println("[AddCarServDatabase:getServiceScdExt]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

	 /**
     * 면책금 스케쥴 생성내역 update (
     */
    public int updateServiceScdExt(ServiceBean bean) throws DatabaseException, DataSourceEmptyException{
         Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
        
        query = " UPDATE scd_ext SET"+
				" bill_yn = 'N',"+
				" UPDATE_DT=replace(?,'-',''), UPDATE_ID=? "+//38
				" where ext_st = '3' and rent_mng_id = ? and rent_l_cd = ? and ext_id = ?  and ext_pay_dt is null ";
			
            
       try{

            con.setAutoCommit(false);

            pstmt = con.prepareStatement(query);            
		
			pstmt.setString(1, bean.getUpdate_dt().trim());
			pstmt.setString(2, bean.getUpdate_id().trim());
			pstmt.setString(3, bean.getRent_mng_id().trim());
			pstmt.setString(4, bean.getRent_l_cd().trim());
		    pstmt.setString(5, bean.getServ_id().trim());

			count = pstmt.executeUpdate();
            
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[AddCarServDatabase:updateServiceScdExt]\n"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }
   
    /**
     * 면책금 스케쥴 생성내역 여부 확인 (
     */
    public int getServiceScdExtAmt(ServiceBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        PreparedStatement pstmt1 = null;
        ResultSet rs = null;
        String query = "";
        String query1 = "";
              
        int ext_s_amt= 0;
        int ext_v_amt= 0;
        int count = 0;
                
        query = " select ext_s_amt, ext_v_amt from scd_ext "+
				" where ext_st = '3' and rent_mng_id = ? and rent_l_cd = ? and ext_id = ?  and ext_tm = '1' and ext_pay_dt is null ";
				
	    query1 = " update scd_ext set ext_s_amt = ? , ext_v_amt = ? , ext_est_dt = replace(?,'-',''), UPDATE_DT=replace(?,'-',''), UPDATE_ID=?, bill_yn = 'Y' "+
	           	 " where ext_st = '3' and rent_mng_id = ? and rent_l_cd = ? and ext_id = ?  and ext_tm = '1' and ext_pay_dt is null ";
				
        try{
        
        	con.setAutoCommit(false);
                 
            pstmt = con.prepareStatement(query);
          	pstmt.setString(1, bean.getRent_mng_id().trim());
			pstmt.setString(2, bean.getRent_l_cd().trim());
			pstmt.setString(3, bean.getServ_id().trim());			
			rs = pstmt.executeQuery();
            if (rs.next()){
                ext_s_amt = rs.getInt("ext_s_amt");
                ext_v_amt = rs.getInt("ext_v_amt");
			}            
            rs.close();
            pstmt.close();
                                   
            int s_amt = 0;
       		int v_amt = 0;
        	  int n_amt = bean.getCust_amt();	
        	
       // 	if (bean.getBill_doc_yn().equals("0") ) {
        		s_amt = n_amt;
				v_amt = n_amt - s_amt;        		
       // 	} else {	        					
		//		s_amt = (new Double(n_amt/1.1)).intValue();
		//		v_amt = n_amt - s_amt;
		//	}
			
			
	            pstmt1 = con.prepareStatement(query1);
	            pstmt1.setInt(1, s_amt);
				pstmt1.setInt(2, v_amt);	
	        	pstmt1.setString(3, bean.getCust_plan_dt().trim());
				pstmt1.setString(4, bean.getUpdate_dt().trim());
				pstmt1.setString(5, bean.getUpdate_id().trim());
	          	pstmt1.setString(6, bean.getRent_mng_id().trim());
				pstmt1.setString(7, bean.getRent_l_cd().trim());
				pstmt1.setString(8, bean.getServ_id().trim());				            
	            count = pstmt1.executeUpdate();	            
	            pstmt1.close();
	            con.commit();

          }catch(Exception se){
            try{
				System.out.println("[AddCarServDatabase:getServiceScdExtAmt]\n"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
                if(pstmt1 != null) pstmt1.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }  
    
    
    /**
	 *	면책금 확정- serv_st:13 제외
	 */
	
	public boolean updateServiceSac(String car_mng_id, String serv_id )throws DatabaseException, DataSourceEmptyException{
        
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		boolean flag = true;
		String query = "update service set  sac_yn = 'Y', sac_dt = to_char(sysdate,'YYYYMMdd') "+
						" where car_mng_id = ? and serv_id = ? and sac_dt is null   ";  //2
		
		PreparedStatement pstmt = null;

		try 
		{
			con.setAutoCommit(false);

			pstmt = con.prepareStatement(query);
				
			pstmt.setString(1, car_mng_id);
			pstmt.setString(2, serv_id);
			
		    pstmt.executeUpdate();
			pstmt.close();

			con.commit();
		
		}catch(Exception se){
            try{
				System.out.println("[AddCarServDatabase:updateServiceSac]\n"+se);
				flag = false;
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
              
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return flag;
    }  
    
  
  	 // 면책금 선청구건
 
 	 public int insertService( String car_mng_id, String accid_id, String serv_id, String rent_mng_id, String rent_l_cd, String user_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;    
        String query = "";     
  
        int count = 0;
                            
        query = " INSERT INTO service("+
				" CAR_MNG_ID, SERV_ID, ACCID_ID, RENT_MNG_ID, RENT_L_CD, REG_ID, REG_DT , SERV_ST , REP_CONT) "+
				" values(?, ?, ?, ?, ?, ?, to_char(sysdate,'YYYYMMdd'), '13', '면책금 선청구분' )";
			
		try{

			con.setAutoCommit(false);		
            
			pstmt = con.prepareStatement(query);
		    pstmt.setString(1, car_mng_id);
		    pstmt.setString(2, serv_id);
			pstmt.setString(3, accid_id);
			pstmt.setString(4, rent_mng_id);
			pstmt.setString(5, rent_l_cd);
			pstmt.setString(6, user_id);
										         
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[AddCarServDatabase:insertService]\n"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
              
                if(pstmt != null) pstmt.close();
              
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }
    
     // 면책금 선청구건 - 차량하나에 선청구 면책금건 check

 	 public String getRealServId( String car_mng_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
     
        ResultSet rs = null;
        String query = "";
         
        int count = 0;
        String serv_id = "";
            
			
		query=" select 'NN'|| nvl(ltrim(to_char(to_number(max(substr(SERV_ID,3,6))+1), '0000')), '0001') from service where car_mng_id=? and serv_id like 'NN%'";
			
		try{

			pstmt = con.prepareStatement(query);
            pstmt.setString(1, car_mng_id);
			rs = pstmt.executeQuery();
            if(rs.next()){
				serv_id = rs.getString(1);
            }
                                    
	        rs.close();
            pstmt.close();
		
	    }catch(SQLException se){
			System.out.println("[AddCarServDatabase:getRealServId]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return serv_id;
    }
      
    /**
	 *	정비 견적서 삭제
	 */
	
	public boolean deleteScanFile(String car_mng_id, String serv_id )throws DatabaseException, DataSourceEmptyException{
        
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		boolean flag = true;

		String query = "update service set  file_path='', scan_file = '', estimate_num = '' where car_mng_id = ? and serv_id = ?  ";  //2
		
		PreparedStatement pstmt = null;

		try 
		{
			con.setAutoCommit(false);

			pstmt = con.prepareStatement(query);
				
			pstmt.setString(1, car_mng_id);
			pstmt.setString(2, serv_id);
			
		    pstmt.executeUpdate();
			pstmt.close();

			con.commit();
		
		}catch(Exception se){
            try{
				System.out.println("[AddCarServDatabase:deleteScanFile]\n"+se);
				flag = false;
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
              
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return flag;
    }  
    	
    	
     /**
     * 과태료/범칙금 - 일일 아마존카 대납관련 납부에정일 등록, 청구월: 납부일 + 15일 후 돌아오는 대여료 출금일 - 선납분은 청구일계산, 
     */
    public String  getCustPlanDt(String car_mng_id, String rent_mng_id, String rent_l_cd, String serv_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
             
                     
     	String sResult = "";
		CallableStatement cstmt = null;
		 
                    
       try{
                                
            cstmt = con.prepareCall("{ ? =  call F_getServicePlanDt( ?, ?, ?, ? ) }");

			cstmt.registerOutParameter( 1, java.sql.Types.VARCHAR );			
		    cstmt.setString(2, rent_mng_id );
            cstmt.setString(3, rent_l_cd );
            cstmt.setString(4, car_mng_id );
            cstmt.setString(5, serv_id );
           
           	cstmt.execute();
           	sResult = cstmt.getString(1); // 결과값
           	cstmt.close();
        
           }catch(SQLException se){
			System.out.println("[AddCarServDatabase:getCustPlanDt]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(cstmt != null) cstmt.close();
                
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return sResult;
    }
	
    /**
     * 과태료/범칙금 - 일일 아마존카 대납관련 납부에정일 등록, 청구월: 납부일 + 15일 후 돌아오는 대여료 출금일 - 선납분은 청구일계산, 
     */
   /* 
    public String  getCustPlanDt(String req_dt , String car_mng_id, String rent_mng_id, String rent_l_cd, String serv_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
             
                     
     	String sResult = "";
		CallableStatement cstmt = null;
		 
                    
       try{
                                
            cstmt = con.prepareCall("{ ? =  call F_getServicePlanDt2( ?, ?, ?, ?, ? ) }");

			cstmt.registerOutParameter( 1, java.sql.Types.VARCHAR );	
		    cstmt.setString(2, req_dt );
		    cstmt.setString(3, rent_mng_id );
            cstmt.setString(4, rent_l_cd );
            cstmt.setString(5, car_mng_id );
            cstmt.setString(6, serv_id );
           
           	cstmt.execute();
           	sResult = cstmt.getString(1); // 결과값
           	cstmt.close();
        
           }catch(SQLException se){
			System.out.println("[AddCarServDatabase:getCustPlanDt]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(cstmt != null) cstmt.close();
                
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return sResult;
    }
    */
    
    //면책금 등록전 입금예정일 확인  
    public String  getCustPlanDt(String req_dt, String car_mng_id, String rent_mng_id, String rent_l_cd, String accid_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
             
                     
     	String sResult = "";
		CallableStatement cstmt = null;		 
                    
       try{
                                
            cstmt = con.prepareCall("{ ? =  call F_getServicePlanDt1( ?, ?, ?, ?, ? ) }");

			cstmt.registerOutParameter( 1, java.sql.Types.VARCHAR );	
			cstmt.setString(2, req_dt );
		    cstmt.setString(3, rent_mng_id );
            cstmt.setString(4, rent_l_cd );
            cstmt.setString(5, car_mng_id );
            cstmt.setString(6, accid_id );
           
           	cstmt.execute();
           	sResult = cstmt.getString(1); // 결과값
           	cstmt.close();
        
           }catch(SQLException se){
			System.out.println("[AddCarServDatabase:getCustPlanDt]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(cstmt != null) cstmt.close();
                
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return sResult;
    }
    
	public String getCustPlanDt(String serv_dt, int add_day ) throws DatabaseException, DataSourceEmptyException{
	    Connection con = connMgr.getConnection(DATA_SOURCE);
	
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
                            
     	String sResult = "";
		CallableStatement cstmt = null;
		
		try{
                                
        //    cstmt = con.prepareCall("{ ? =  call F_getAfterDay( ?, ? ) }");
            cstmt = con.prepareCall("{ ? =  call F_getAfterDay1( ?, ? ) }");

			cstmt.registerOutParameter( 1, java.sql.Types.VARCHAR );			
		    cstmt.setString(2, serv_dt );
            cstmt.setInt(3, add_day );
                      
           	cstmt.execute();
           	sResult = cstmt.getString(1); // 결과값
           	cstmt.close();
        
           }catch(SQLException se){
			System.out.println("[AddCarServDatabase:getCustPlanDt]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(cstmt != null) cstmt.close();
                
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return sResult;
    }
   
     /**
     *   대여료 출금일 (기본식정비대차)
     */
    public String  getCustPlanDtBSD(String rent_mng_id, String rent_l_cd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
             
                     
     	String sResult = "";
		CallableStatement cstmt = null;
		 
                    
       try{
                                
            cstmt = con.prepareCall("{ ? =  call F_getAfterDayBSD( ?, ? ) }");

			cstmt.registerOutParameter( 1, java.sql.Types.VARCHAR );			
		    cstmt.setString(2, rent_mng_id );
            cstmt.setString(3, rent_l_cd );
           
           	cstmt.execute();
           	sResult = cstmt.getString(1); // 결과값
           	cstmt.close();
        
           }catch(SQLException se){
			System.out.println("[AddCarServDatabase:getCustPlanDtBSD]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(cstmt != null) cstmt.close();
                
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return sResult;
    }
	
		
	  /**
	 *	정비 내역이 없는 경우 면책금 삭제
	 */
	
	public boolean deleteServCust(String car_mng_id, String serv_id )throws DatabaseException, DataSourceEmptyException{
        
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		boolean flag = true;

		String query = "delete service  where car_mng_id = ? and serv_id = ?  ";  //2
		
		PreparedStatement pstmt = null;

		try 
		{
			con.setAutoCommit(false);

			pstmt = con.prepareStatement(query);
				
			pstmt.setString(1, car_mng_id);
			pstmt.setString(2, serv_id);
			
		    pstmt.executeUpdate();
			pstmt.close();
			con.commit();
		
		}catch(Exception se){
            try{
				System.out.println("[AddCarServDatabase:deleteServCust]\n"+se);
				flag = false;
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
              
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return flag;
    }  	
		
	
	  /**
	 *	정비 내역이 없는 경우 면책금 삭제 - 입금이 안된경우만 
	 */
	
	public boolean deleteServCustExt(String rent_mng_id , String rent_l_cd , String serv_id )throws DatabaseException, DataSourceEmptyException{
        
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		boolean flag = true;

		String query = "delete scd_ext  where ext_st = '3' and rent_mng_id = ? and rent_l_cd = ? and ext_id = ?  and ext_pay_dt is null   ";  //2
		
		PreparedStatement pstmt = null;

		try 
		{
			con.setAutoCommit(false);

			pstmt = con.prepareStatement(query);
				
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
			pstmt.setString(3, serv_id);
			
		    pstmt.executeUpdate();
			pstmt.close();

			con.commit();
		
		}catch(Exception se){
            try{
				System.out.println("[AddCarServDatabase:deleteServCustExt]\n"+se);
				flag = false;
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
              
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return flag;
    }  	
		
		
}