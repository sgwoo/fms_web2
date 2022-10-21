/**
 * 차량정비
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2002. 3. 4
 * @ last modify date : 
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

public class CarServDatabase {

    private static CarServDatabase instance;
    private DBConnectionManager connMgr;   
    // Pool로 부터 Connection 객체를 가져올때 사용하는 Pool Name 
    private final String DATA_SOURCE = "acar"; 
 
    // 싱글톤 클래스로 구현 
    // 생성자를 private 로 선언
    public static synchronized CarServDatabase getInstance() throws DatabaseException {
        if (instance == null)
            instance = new CarServDatabase();
        return instance;
    }
    
    private CarServDatabase() throws DatabaseException {
        connMgr = DBConnectionManager.getInstance();
    }
    
    /**
     * 특정 레코드를 Bean에 저장하여 Bean을 리턴하는 메소드
     */
	/**
     * 서비스
     */
    
    private ServiceBean makeServiceBean(ResultSet results) throws DatabaseException {

        try {
            ServiceBean bean = new ServiceBean();

		    bean.setCar_mng_id(results.getString("CAR_MNG_ID")); 					//자동차관리번호
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
			bean.setBill_doc_yn(results.getString("BILL_DOC_YN"));
			bean.setBill_mon(results.getString("BILL_MON"));
			bean.setServ_jc(results.getString("SERV_JC"));
			bean.setCust_serv_dt(results.getString("CUST_SERV_DT"));
			bean.setNext_serv_dt(results.getString("NEXT_SERV_DT"));
			bean.setNext_rep_cont(results.getString("NEXT_REP_CONT"));
			bean.setSpd_chk(results.getString("SPDCHK"));  
			bean.setJung_st(results.getString("JUNG_ST"));  
			bean.setCar_comp_id(results.getString("CAR_COMP_ID"));
			bean.setSac_yn(results.getString("SAC_YN"));  

            return bean;
        }catch (SQLException e) {
			e.printStackTrace();
            throw new DatabaseException(e.getMessage());
        }
	}
	/**
     * 계약정보
     */
	
	private ContInfoBean makeContInfoBean(ResultSet results) throws DatabaseException {

        try {
            ContInfoBean bean = new ContInfoBean();

		    bean.setRent_mng_id(results.getString("RENT_MNG_ID"));
			bean.setRent_l_cd(results.getString("RENT_L_CD"));
			bean.setClient_id(results.getString("CLIENT_ID"));
			bean.setCar_mng_id(results.getString("CAR_MNG_ID"));
			bean.setInit_reg_dt(results.getString("INIT_REG_DT"));
			bean.setCar_no(results.getString("CAR_NO"));
			bean.setCar_form(results.getString("CAR_FORM"));
			bean.setCar_num(results.getString("CAR_NUM"));
			bean.setFuel_kd(results.getString("FUEL_KD"));
			bean.setClient_nm(results.getString("CLIENT_NM"));
			bean.setFirm_nm(results.getString("FIRM_NM"));
			bean.setRent_way(results.getString("RENT_WAY"));
			bean.setCon_mon(results.getString("CON_MON"));
			bean.setRent_start_dt(results.getString("RENT_START_DT"));
			bean.setCar_id(results.getString("CAR_ID"));
			bean.setCar_name(results.getString("CAR_NAME"));
			bean.setOff_id(results.getString("OFF_ID"));
			bean.setOff_nm(results.getString("OFF_NM"));
			bean.setOff_tel(results.getString("OFF_TEL"));
			bean.setTot_dist(results.getString("TOT_DIST"));
			bean.setAverage_dist(results.getString("AVERAGE_DIST"));
			bean.setToday_dist(results.getString("TODAY_DIST"));
			bean.setIns_com_nm(results.getString("INS_COM_NM"));
			bean.setIns_exp_dt(results.getString("INS_EXP_DT"));
			bean.setAgnt_imgn_tel(results.getString("AGNT_IMGN_TEL"));

	      return bean;
        }catch (SQLException e) {
			e.printStackTrace();
            throw new DatabaseException(e.getMessage());
        }
	}
	
   
	/**
     * 점검품목
     */
	private ServItemBean makeServItemBean(ResultSet results) throws DatabaseException {

        try {
            ServItemBean bean = new ServItemBean();

		    bean.setCar_mng_id(results.getString("CAR_MNG_ID"));
			bean.setServ_id(results.getString("SERV_ID"));
			bean.setSeq_no(results.getInt("SEQ_NO"));
			bean.setItem(results.getString("ITEM"));
			bean.setStd(results.getString("STD"));
			bean.setUnit(results.getString("UNIT"));
			bean.setCount(results.getInt("COUNT"));
			bean.setPrice(results.getInt("PRICE"));
			bean.setSup_amt(results.getInt("SUP_AMT"));
			bean.setTax(results.getInt("TAX"));

            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}
	/**
     * 견적서 빈 생성 2003.10.8.
     */
	private ServItem2Bean makeServItem2Bean(ResultSet results) throws DatabaseException {

        try {
            ServItem2Bean bean = new ServItem2Bean();

		    bean.setCar_mng_id(results.getString("CAR_MNG_ID"));
			bean.setServ_id(results.getString("SERV_ID"));
			bean.setSeq_no(results.getInt("SEQ_NO"));
			bean.setItem(results.getString("ITEM"));
			bean.setBpm(results.getString("BPM"));
			bean.setCount(results.getInt("COUNT"));
			bean.setPrice(results.getInt("PRICE"));
			bean.setAmt(results.getInt("AMT"));
			bean.setLabor(results.getInt("LABOR"));

            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}

    /**
     * 파일
     */
/*
	private FileAddBean makeFileAddBean(ResultSet results) throws DatabaseException {

        try {
            FileAddBean bean = new FileAddBean();

		    bean.setCar_mng_id(results.getString("CAR_MNG_ID"));
			bean.setServ_id(results.getString("SERV_ID"));
			bean.setSeq_no(results.getInt("SEQ_NO"));
			bean.setFile_nm(results.getString("FILE_NM"));
			bean.setDir(results.getString("DIR"));
			bean.setExec(results.getString("EXEC"));
			bean.setCont(results.getString("CONT"));

            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}
  */
    /**
     *	계약정보 조회
     */
	
    public ContInfoBean getContInfo(String rent_mng_id, String rent_l_cd, String car_mng_id) throws DatabaseException, DataSourceEmptyException{
    	Connection con = connMgr.getConnection(DATA_SOURCE);
    	
    	if(con == null)
    		throw new DataSourceEmptyException("Can't get Connection !!");

    	ContInfoBean cib = new ContInfoBean();
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
    	String query = "";

    	query="select  a.rent_mng_id RENT_MNG_ID, a.rent_l_cd RENT_L_CD, a.client_id CLIENT_ID,\n"
					+ "b.car_mng_id CAR_MNG_ID,substr(b.init_reg_dt,1,4) || '-' || substr(b.init_reg_dt,5,2) || '-' || substr(b.init_reg_dt,7,2) INIT_REG_DT, b.car_no CAR_NO,b.car_num CAR_NUM,b.fuel_kd FUEL_KD,\n"
					+ "c.client_nm CLIENT_NM,c.firm_nm FIRM_NM,\n"
					+ "decode(f.rent_way,'1','일반식','2','맞춤식','기타') RENT_WAY, f.con_mon CON_MON, substr(i.rent_start_dt,1,4) || '-' || substr(i.rent_start_dt,5,2) || '-' || substr(i.rent_start_dt,7,2) RENT_START_DT,\n"
					+ "d.car_id CAR_ID,e.car_name CAR_NAME, b.car_form CAR_FORM, \n"
					+ "h.off_id OFF_ID,h.off_nm OFF_NM,h.off_tel OFF_TEL,\n"
					+ "vt.tot_dist as TOT_DIST, "
					+ "decode(vt.tot_dist,'0',0,decode(vt.tot_dt,nvl(a.dlv_dt,b.init_reg_dt),0,round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(a.dlv_dt,b.init_reg_dt),'YYYYMMDD'))))) as AVERAGE_DIST,\n"
					+ "decode(vt.tot_dist,'0',0,decode(vt.tot_dt,nvl(a.dlv_dt,b.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(a.dlv_dt,b.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST,\n"
					+ "k.ins_com_nm as INS_COM_NM, j.ins_exp_dt as INS_EXP_DT, j.agnt_imgn_tel as AGNT_IMGN_TEL \n"
			+ "from    cont a, car_reg b, client c, car_etc d, car_nm e, fee f, cust_serv g, serv_off h, v_tot_dist vt, \n"
					+ "(select car_mng_id, ins_com_id, ins_exp_dt, agnt_imgn_tel from insur a where ins_st =(select max(ins_st) from insur where a.car_mng_id = car_mng_id)) j, ins_com k, \n"
					+ "(select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, min(rent_start_dt) rent_start_dt, max(rent_end_dt) rent_end_dt, sum(con_mon) con_mon from fee group by rent_mng_id, rent_l_cd) i \n"
			+ "where   a.rent_mng_id=? and a.rent_l_cd=?  and a.car_st not like 'RM%' \n"
					+ "and b.car_mng_id=? \n"
					+ "and a.car_mng_id=b.car_mng_id \n"
					+ "and a.client_id=c.client_id \n"
					+ "and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd \n"
					+ "and d.car_id=e.car_id and d.car_seq=e.car_seq \n"
					+ "and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd \n"
					+ "and b.car_mng_id=g.car_mng_id(+) \n"
					+ "and g.off_id=h.off_id(+) \n"
					+ "and a.car_mng_id=vt.car_mng_id(+) \n"
					+ "and a.car_mng_id=j.car_mng_id(+) and j.ins_com_id=k.ins_com_id(+) \n"
					+ "and f.rent_mng_id=i.rent_mng_id and f.rent_l_cd=i.rent_l_cd and f.rent_st=i.rent_st \n"
					+ " ";
    	try{

    		pstmt = con.prepareStatement(query);
    		pstmt.setString(1, rent_mng_id.trim());
    		pstmt.setString(2, rent_l_cd.trim());
    		pstmt.setString(3, car_mng_id.trim());
    		rs = pstmt.executeQuery();
    		
		 if (rs.next())       cib = makeContInfoBean(rs);
		            
	            rs.close();
	            pstmt.close();
	     }catch(SQLException se){
				System.out.println("[CarServDatabase:getContInfo]"+se);
				se.printStackTrace();
			    throw new DatabaseException();			 
	     }finally{
	            try{
	                if(rs != null ) rs.close();
	                if(pstmt != null) pstmt.close();
	            }catch(SQLException _ignored){}
	            connMgr.freeConnection(DATA_SOURCE, con);
				con = null;
	      }
	       return cib;
     }
  
    /**
     * 서비스조회
     */
    public ServiceBean [] getServiceAll( String car_mng_id ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
		query = "select b.car_comp_id, a.car_mng_id CAR_MNG_ID, a.serv_id SERV_ID, a.accid_id ACCID_ID, a.rent_mng_id RENT_MNG_ID, a.rent_l_cd RENT_L_CD, a.off_id OFF_ID, b.off_nm OFF_NM, nvl(a.serv_dt,decode(serv_st,'4',a.accid_dt)) SERV_DT, nvl(a.serv_st, '9') SERV_ST, a.checker CHECKER, a.tot_dist TOT_DIST, a.rep_nm REP_NM, a.rep_tel REP_TEL, a.rep_m_tel REP_M_TEL, a.rep_amt REP_AMT, a.sup_amt SUP_AMT, a.add_amt ADD_AMT, a.dc DC, a.tot_amt TOT_AMT, nvl2(a.sup_dt,substr(a.sup_dt,1,4)||'-'||substr(a.sup_dt,5,2)||'-'||substr(a.sup_dt,7,2),'') SUP_DT, nvl2(a.set_dt,substr(a.set_dt,1,4)||'-'||substr(a.set_dt,5,2)||'-'||substr(a.set_dt,7,2),'') SET_DT, a.bank BANK, a.acc_no ACC_NO, a.acc_nm ACC_NM, a.rep_item REP_ITEM, a.rep_cont REP_CONT, nvl2(a.cust_plan_dt,substr(a.cust_plan_dt,1,4)||'-'||substr(a.cust_plan_dt,5,2)||'-'||substr(a.cust_plan_dt,7,2),'') CUST_PLAN_DT, a.cust_amt CUST_AMT, a.cust_agnt CUST_AGNT, a.accid_dt ACCID_DT, a.bill_doc_yn, a.bill_mon, a.serv_jc SERV_JC, a.cust_serv_dt CUST_SERV_DT, a.next_serv_dt NEXT_SERV_DT, a.next_rep_cont NEXT_REP_CONT, a.spdchk SPDCHK, a.jung_st, a.sac_yn \n"
				+ "from service a, serv_off b\n"
				+ "where a.car_mng_id=?\n"
				+ "  and a.serv_dt is not null \n"
				+ "and a.off_id=b.off_id(+) order by nvl(serv_dt,'00000000') desc\n"; 

        Collection<ServiceBean> col = new ArrayList<ServiceBean>();
        try{
            pstmt = con.prepareStatement(query);
    		pstmt.setString(1, car_mng_id.trim());
    		
    		rs = pstmt.executeQuery();

            while(rs.next()){
                
				col.add(makeServiceBean(rs));
 
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
        return (ServiceBean[])col.toArray(new ServiceBean[0]);
    }


//off_id 추가 2010.12.07
	 public ServiceBean [] getServiceAll_off_id( String car_mng_id , String off_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
		query = "select b.car_comp_id, a.car_mng_id CAR_MNG_ID, a.serv_id SERV_ID, a.accid_id ACCID_ID, a.rent_mng_id RENT_MNG_ID, a.rent_l_cd RENT_L_CD, a.off_id OFF_ID, b.off_nm OFF_NM, nvl(a.serv_dt,decode(serv_st,'4',a.accid_dt)) SERV_DT, nvl(a.serv_st, '9') SERV_ST, a.checker CHECKER, a.tot_dist TOT_DIST, a.rep_nm REP_NM, a.rep_tel REP_TEL, a.rep_m_tel REP_M_TEL, a.rep_amt REP_AMT, a.sup_amt SUP_AMT, a.add_amt ADD_AMT, a.dc DC, a.tot_amt TOT_AMT, nvl2(a.sup_dt,substr(a.sup_dt,1,4)||'-'||substr(a.sup_dt,5,2)||'-'||substr(a.sup_dt,7,2),'') SUP_DT, nvl2(a.set_dt,substr(a.set_dt,1,4)||'-'||substr(a.set_dt,5,2)||'-'||substr(a.set_dt,7,2),'') SET_DT, a.bank BANK, a.acc_no ACC_NO, a.acc_nm ACC_NM, a.rep_item REP_ITEM, a.rep_cont REP_CONT, nvl2(a.cust_plan_dt,substr(a.cust_plan_dt,1,4)||'-'||substr(a.cust_plan_dt,5,2)||'-'||substr(a.cust_plan_dt,7,2),'') CUST_PLAN_DT, a.cust_amt CUST_AMT, a.cust_agnt CUST_AGNT, a.accid_dt ACCID_DT, a.bill_doc_yn, a.bill_mon, a.serv_jc SERV_JC, a.cust_serv_dt CUST_SERV_DT, a.next_serv_dt NEXT_SERV_DT, a.next_rep_cont NEXT_REP_CONT, a.spdchk SPDCHK, a.jung_st, a.sac_yn \n"
				+ "from service a, serv_off b\n"
				+ "where a.car_mng_id=? and a.off_id = '"+off_id.trim()+"'\n"
				+ "  and a.serv_dt is not null \n"
				+ "and a.off_id=b.off_id(+) order by nvl(serv_dt,'00000000') desc\n"; 

        Collection<ServiceBean> col = new ArrayList<ServiceBean>();
        try{
            pstmt = con.prepareStatement(query);
    		pstmt.setString(1, car_mng_id.trim());
    		
    		rs = pstmt.executeQuery();

            while(rs.next()){
                
				col.add(makeServiceBean(rs));
 
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
        return (ServiceBean[])col.toArray(new ServiceBean[0]);
    }

    /**
     * 서비스조회2
	 * 고객접속 fms에서 2004/10/27 Yongsoon Kwon.
     */
    public ServiceBean [] getServiceAll_custfms( String car_mng_id ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
		query = "select b.car_comp_id, a.car_mng_id CAR_MNG_ID, a.serv_id SERV_ID, a.accid_id ACCID_ID, a.rent_mng_id RENT_MNG_ID, a.rent_l_cd RENT_L_CD, a.off_id OFF_ID, b.off_nm OFF_NM, nvl(a.serv_dt,decode(serv_st,'4',a.accid_dt)) SERV_DT, a.serv_st SERV_ST, a.checker CHECKER, a.tot_dist TOT_DIST, a.rep_nm REP_NM, a.rep_tel REP_TEL, a.rep_m_tel REP_M_TEL, a.rep_amt REP_AMT, a.sup_amt SUP_AMT, a.add_amt ADD_AMT, a.dc DC, a.tot_amt TOT_AMT, nvl2(a.sup_dt,substr(a.sup_dt,1,4)||'-'||substr(a.sup_dt,5,2)||'-'||substr(a.sup_dt,7,2),'') SUP_DT, nvl2(a.set_dt,substr(a.set_dt,1,4)||'-'||substr(a.set_dt,5,2)||'-'||substr(a.set_dt,7,2),'') SET_DT, a.bank BANK, a.acc_no ACC_NO, a.acc_nm ACC_NM, a.rep_item REP_ITEM, a.rep_cont REP_CONT, nvl2(a.cust_plan_dt,substr(a.cust_plan_dt,1,4)||'-'||substr(a.cust_plan_dt,5,2)||'-'||substr(a.cust_plan_dt,7,2),'') CUST_PLAN_DT, a.cust_amt CUST_AMT, a.cust_agnt CUST_AGNT, a.accid_dt ACCID_DT, a.bill_doc_yn, a.bill_mon, a.serv_jc SERV_JC, a.cust_serv_dt CUST_SERV_DT, a.next_serv_dt NEXT_SERV_DT, a.next_rep_cont NEXT_REP_CONT, a.spdchk SPDCHK, a.jung_st, a.sac_yn \n"
				+ "from service a, serv_off b\n"
				+ "where a.car_mng_id=? and a.serv_dt is not null \n"
				+ "and a.off_id=b.off_id(+) order by nvl(serv_dt,'00000000') desc\n"; 

        Collection<ServiceBean> col = new ArrayList<ServiceBean>();
        try{
            pstmt = con.prepareStatement(query);
    		pstmt.setString(1, car_mng_id.trim());
    		
    		rs = pstmt.executeQuery();

            while(rs.next()){
                
				col.add(makeServiceBean(rs));
 
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
        return (ServiceBean[])col.toArray(new ServiceBean[0]);
    }

    /**
     * 서비스조회
     */
    public ServiceBean [] getServiceAll( String car_mng_id, String sort ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = "select b.car_comp_id, a.car_mng_id CAR_MNG_ID, a.serv_id SERV_ID, a.accid_id ACCID_ID, a.rent_mng_id RENT_MNG_ID, a.rent_l_cd RENT_L_CD, a.off_id OFF_ID, b.off_nm OFF_NM, nvl(a.serv_dt,decode(serv_st,'4',a.accid_dt)) SERV_DT, a.serv_st SERV_ST, a.checker CHECKER, a.tot_dist TOT_DIST, a.rep_nm REP_NM, a.rep_tel REP_TEL, a.rep_m_tel REP_M_TEL, a.rep_amt REP_AMT, a.sup_amt SUP_AMT, a.add_amt ADD_AMT, a.dc DC, a.tot_amt TOT_AMT, nvl2(a.sup_dt,substr(a.sup_dt,1,4)||'-'||substr(a.sup_dt,5,2)||'-'||substr(a.sup_dt,7,2),'') SUP_DT, nvl2(a.set_dt,substr(a.set_dt,1,4)||'-'||substr(a.set_dt,5,2)||'-'||substr(a.set_dt,7,2),'') SET_DT, a.bank BANK, a.acc_no ACC_NO, a.acc_nm ACC_NM, a.rep_item REP_ITEM, a.rep_cont REP_CONT, nvl2(a.cust_plan_dt,substr(a.cust_plan_dt,1,4)||'-'||substr(a.cust_plan_dt,5,2)||'-'||substr(a.cust_plan_dt,7,2),'') CUST_PLAN_DT, a.cust_amt CUST_AMT, a.cust_agnt CUST_AGNT, a.accid_dt ACCID_DT, a.bill_doc_yn, a.bill_mon, a.serv_jc SERV_JC, a.cust_serv_dt CUST_SERV_DT, a.next_serv_dt NEXT_SERV_DT, a.next_rep_cont NEXT_REP_CONT, a.spdchk SPDCHK, a.jung_st , a.sac_yn \n"
				+ "from service a, serv_off b\n"
				+ "where a.car_mng_id=?\n"
				+ "and a.off_id=b.off_id(+) order by a.serv_dt\n";


        Collection<ServiceBean> col = new ArrayList<ServiceBean>();
        try{
            pstmt = con.prepareStatement(query);
    		pstmt.setString(1, car_mng_id.trim());
    		
    		rs = pstmt.executeQuery();

            while(rs.next()){
                
				col.add(makeServiceBean(rs));
 
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
        return (ServiceBean[])col.toArray(new ServiceBean[0]);
    }

    /**
     * 서비스 개별조회
     */
    public ServiceBean getService( String car_mng_id, String serv_id ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        ServiceBean sb = new ServiceBean();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
     //   System.out.println("serv_id=" + serv_id);
        
        query = "select b.car_comp_id, a.car_mng_id CAR_MNG_ID, a.serv_id SERV_ID, a.accid_id ACCID_ID, a.rent_mng_id RENT_MNG_ID, a.rent_l_cd RENT_L_CD, a.off_id OFF_ID, b.off_nm OFF_NM,nvl2(a.serv_dt,substr(a.serv_dt,1,4)||'-'||substr(a.serv_dt,5,2)||'-'||substr(a.serv_dt,7,2),'') SERV_DT, a.serv_st SERV_ST, a.checker CHECKER, a.tot_dist TOT_DIST, a.rep_nm REP_NM, a.rep_tel REP_TEL, a.rep_m_tel REP_M_TEL, a.rep_amt REP_AMT, a.sup_amt SUP_AMT, a.add_amt ADD_AMT, a.dc DC, a.tot_amt TOT_AMT, nvl2(a.sup_dt,substr(a.sup_dt,1,4)||'-'||substr(a.sup_dt,5,2)||'-'||substr(a.sup_dt,7,2),'') SUP_DT, nvl2(a.set_dt,substr(a.set_dt,1,4)||'-'||substr(a.set_dt,5,2)||'-'||substr(a.set_dt,7,2),'') SET_DT, a.bank BANK, a.acc_no ACC_NO, a.acc_nm ACC_NM, a.rep_item REP_ITEM, a.rep_cont REP_CONT, nvl2(a.cust_plan_dt,substr(a.cust_plan_dt,1,4)||'-'||substr(a.cust_plan_dt,5,2)||'-'||substr(a.cust_plan_dt,7,2),'') CUST_PLAN_DT, a.cust_amt CUST_AMT, a.cust_agnt CUST_AGNT, a.accid_dt ACCID_DT, a.bill_doc_yn, a.bill_mon, a.serv_jc SERV_JC, a.cust_serv_dt CUST_SERV_DT, a.next_serv_dt NEXT_SERV_DT, a.next_rep_cont NEXT_REP_CONT, a.spdchk SPDCHK, a.jung_st, a.sac_yn \n" 
				+ "from service a, serv_off b\n"
				+ "where a.car_mng_id=? and a.serv_id=?\n"
				+ "and a.off_id=b.off_id(+)\n";

        try{
            pstmt = con.prepareStatement(query);
    		pstmt.setString(1, car_mng_id.trim());
    		pstmt.setString(2, serv_id.trim());
    		
    		rs = pstmt.executeQuery();

            if (rs.next())  sb = makeServiceBean(rs);
            
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[CarServDatabase:getService( String car_mng_id, String serv_id )]"+se);
			se.printStackTrace();
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
     * 품목조회
     */
    public ServItemBean [] getServItemAll( String car_mng_id, String serv_id ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = "select CAR_MNG_ID, SERV_ID, SEQ_NO, ITEM, STD, UNIT, COUNT, PRICE, SUP_AMT, TAX\n" 
				+ "from serv_item\n"
				+ "where car_mng_id=?\n"
				+ "and serv_id=?\n";

        Collection<ServItemBean> col = new ArrayList<ServItemBean>();
        try{
            pstmt = con.prepareStatement(query);
    		pstmt.setString(1, car_mng_id.trim());
    		pstmt.setString(2, serv_id.trim());
    		
    		rs = pstmt.executeQuery();

            while(rs.next()){
                
				col.add(makeServItemBean(rs));
 
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
        return (ServItemBean[])col.toArray(new ServItemBean[0]);
    }

    /**
     * 파일조회
     */
/*
    public FileAddBean [] getFileAddAll( String car_mng_id, String serv_id ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = "select CAR_MNG_ID, SERV_ID, SEQ_NO, FILE_NM, DIR, EXEC, CONT\n" 
				+ "from file_add\n"
				+ "where car_mng_id=?\n"
				+ "and serv_id=?\n";

        Collection col = new ArrayList();
        try{
            pstmt = con.prepareStatement(query);
    		pstmt.setString(1, car_mng_id.trim());
    		pstmt.setString(2, serv_id.trim());
    		
    		rs = pstmt.executeQuery();

            while(rs.next()){
                
				col.add(makeFileAddBean(rs));
 
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
        return (FileAddBean[])col.toArray(new FileAddBean[0]);
    }
	*/
    /**
     * 관리자조회
     */
    public Vector getCarMgr(String mng_id, String l_cd) throws DatabaseException, DataSourceEmptyException{
		 Connection conn = connMgr.getConnection(DATA_SOURCE);
		if(conn == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector rtn = new Vector();
		String query = " select RENT_MNG_ID, RENT_L_CD, MGR_ID, rtrim(MGR_ST) MGR_ST, MGR_NM, MGR_DEPT, MGR_TITLE, MGR_TEL, MGR_M_TEL, MGR_EMAIL"+
						 " from CAR_MGR"+
						 " where RENT_MNG_ID = ? and RENT_L_CD = ?"+
						 " order by MGR_ID";
		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, mng_id);
			pstmt.setString(2, l_cd);
		    rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				CarMgrBean car_mgr = new CarMgrBean();
				car_mgr.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				car_mgr.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));	
				car_mgr.setMgr_id(rs.getString("MGR_ID")==null?"":rs.getString("MGR_ID"));
				car_mgr.setMgr_st(rs.getString("MGR_ST")==null?"":rs.getString("MGR_ST"));
				car_mgr.setMgr_nm(rs.getString("MGR_NM")==null?"":rs.getString("MGR_NM"));
				car_mgr.setMgr_dept(rs.getString("MGR_DEPT")==null?"":rs.getString("MGR_DEPT"));
				car_mgr.setMgr_title(rs.getString("MGR_TITLE")==null?"":rs.getString("MGR_TITLE"));
				car_mgr.setMgr_tel(rs.getString("MGR_TEL")==null?"":rs.getString("MGR_TEL"));
				car_mgr.setMgr_m_tel(rs.getString("MGR_M_TEL")==null?"":rs.getString("MGR_M_TEL"));
				car_mgr.setMgr_email(rs.getString("MGR_EMAIL")==null?"":rs.getString("MGR_EMAIL"));
				rtn.add(car_mgr);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
	  		throw new DatabaseException();
		}finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, conn);
			conn = null;
        }		
        return rtn;
	}	
	
    /**
     * 각종수리 등록.
     */
    public String insertService(ServiceBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        ResultSet rs = null;
        String query = "";
        String query1, query2 = "";
        String serv_id = "";
        int count = 0;
                
        query="INSERT INTO SERVICE(car_mng_id, serv_id, rent_mng_id, rent_l_cd, serv_jc, serv_st, checker, serv_dt, \n"
			+ "                    tot_dist,tot_amt,cust_serv_dt,off_id,next_serv_dt,next_rep_cont,rep_cont,jung_st, reg_dt, reg_id, spdchk_dt)\n"
            + "VALUES(?,?,?,?,?,?,?,replace(?,'-',''), \n"
			+ "       ?,?,?,?,?,?,?,?,to_char(sysdate,'YYYYMMDD'),?, replace(?,'-',''))\n";

        query1="SELECT NVL(LPAD(MAX(serv_id)+1,6,'0'),'000001') FROM service WHERE car_mng_id=? and serv_id not like 'N%'";

		query2="UPDATE serv_item SET serv_id=? WHERE car_mng_id=? AND serv_id='999999' ";

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
            pstmt.setString(1,  bean.getCar_mng_id().trim()		);
            pstmt.setString(2,  serv_id.trim()					);
			pstmt.setString(3,  bean.getRent_mng_id().trim()	);
			pstmt.setString(4,  bean.getRent_l_cd().trim()		);
			pstmt.setString(5,  bean.getServ_jc().trim()		);
			pstmt.setString(6,  bean.getServ_st().trim()		);
			pstmt.setString(7,  bean.getChecker().trim()		);
			pstmt.setString(8,  bean.getServ_dt().trim()		);
			pstmt.setString(9,  bean.getTot_dist().trim()		);
			pstmt.setInt   (10, bean.getTot_amt()				);
			pstmt.setString(11, bean.getCust_serv_dt().trim()	);
			pstmt.setString(12, bean.getOff_id().trim()			);
			pstmt.setString(13, bean.getNext_serv_dt().trim()	);
			pstmt.setString(14, bean.getNext_rep_cont().trim()	);
			pstmt.setString(15, bean.getRep_cont().trim()		);			
			pstmt.setString(16, bean.getJung_st().trim()		);			
			pstmt.setString(17, bean.getReg_id().trim()			);			
			pstmt.setString(18, bean.getSpdchk_dt()				);
            count = pstmt.executeUpdate();
            pstmt.close();

			//견적서먼저등록시 default='999999' serv_id수정
			pstmt2 = con.prepareStatement(query2);
			pstmt2.setString(1,serv_id.trim());
			pstmt2.setString(2,bean.getCar_mng_id().trim());
			pstmt2.executeUpdate();           
            pstmt2.close();
            con.commit();

        }catch(Exception se){
            try{
                con.rollback();
				System.out.println("[CarServDatabase:insertService(ServiceBean bean)]"+se);
				System.out.println("[bean.getCar_mng_id().trim()	]"+bean.getCar_mng_id().trim()		);
				System.out.println("[serv_id.trim()					]"+serv_id.trim()					);
				System.out.println("[bean.getRent_mng_id().trim()	]"+bean.getRent_mng_id().trim()		);
				System.out.println("[bean.getRent_l_cd().trim()		]"+bean.getRent_l_cd().trim()		);
				System.out.println("[bean.getServ_jc().trim()		]"+bean.getServ_jc().trim()			);
				System.out.println("[bean.getServ_st().trim()		]"+bean.getServ_st().trim()			);
				System.out.println("[bean.getChecker().trim()		]"+bean.getChecker().trim()			);
				System.out.println("[bean.getServ_dt().trim()		]"+bean.getServ_dt().trim()			);
				System.out.println("[bean.getTot_dist().trim()		]"+bean.getTot_dist().trim()		);
				System.out.println("[bean.getTot_amt()				]"+bean.getTot_amt()				);
				System.out.println("[bean.getCust_serv_dt().trim()	]"+bean.getCust_serv_dt().trim()	);
				System.out.println("[bean.getOff_id().trim()		]"+bean.getOff_id().trim()			);
				System.out.println("[bean.getNext_serv_dt().trim()	]"+bean.getNext_serv_dt().trim()	);
				System.out.println("[bean.getNext_rep_cont().trim()	]"+bean.getNext_rep_cont().trim()	);
				System.out.println("[bean.getRep_cont().trim()		]"+bean.getRep_cont().trim()		);
				System.out.println("[bean.getJung_st().trim()		]"+bean.getJung_st().trim()			);

				se.printStackTrace();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
                if(pstmt1 != null) pstmt1.close();
                if(pstmt2 != null) pstmt2.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return serv_id;
    }
    /**
     * 각종수리 수정.
     */    
    public int updateService(ServiceBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query="UPDATE SERVICE SET ACCID_ID=?, RENT_MNG_ID=?, RENT_L_CD=?, OFF_ID=?, SERV_DT=replace(?,'-',''), SERV_ST=?, CHECKER=?, TOT_DIST=?, REP_NM=?, REP_TEL=?, REP_M_TEL=?, REP_AMT=?, SUP_AMT=?, ADD_AMT=?, DC=?, TOT_AMT=?, SUP_DT=replace(?,'-',''), SET_DT=replace(?,'-',''), BANK=?, ACC_NO=?, ACC_NM=?, REP_ITEM=?, REP_CONT=?, CUST_PLAN_DT=replace(?,'-',''), CUST_AMT=?, CUST_AGNT=?, ACCID_DT=replace(?,'-',''), BILL_DOC_YN=?, BILL_MON=? \n"
            + "WHERE CAR_MNG_ID=? AND SERV_ID=?\n";
            
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
			pstmt.setString(28, bean.getBill_doc_yn().trim());
			pstmt.setString(29, bean.getBill_mon().trim());
            pstmt.setString(30, bean.getCar_mng_id().trim());
            pstmt.setString(31, bean.getServ_id().trim());

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
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return count;
    }
    /**
     * 견적서등록.
     */
    
    public int insertServItem(ServItemBean bean) throws DatabaseException, DataSourceEmptyException{
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
                
        query="INSERT INTO serv_item(CAR_MNG_ID, SERV_ID, SEQ_NO, ITEM, STD, UNIT, COUNT, PRICE, SUP_AMT, TAX)\n"
            + "values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)\n";

        query1="select nvl(max(seq_no)+1,1) from serv_item where car_mng_id=? and serv_id=?";

       try{
            con.setAutoCommit(false);

            pstmt1 = con.prepareStatement(query1);
            pstmt1.setString(1, bean.getCar_mng_id().trim());
            pstmt1.setString(2, bean.getServ_id().trim());
			rs = pstmt1.executeQuery();
            if(rs.next()){
				seq_no = rs.getInt(1);
            }
            rs.close();
            pstmt1.close(); 

            pstmt = con.prepareStatement(query);
            pstmt.setString(1, bean.getCar_mng_id().trim());
            pstmt.setString(2, bean.getServ_id().trim());
            pstmt.setInt   (3, seq_no);
            pstmt.setString(4, bean.getItem().trim());
            pstmt.setString(5, bean.getStd().trim());
            pstmt.setString(6, bean.getUnit().trim());
            pstmt.setInt   (7, bean.getCount());
            pstmt.setInt   (8, bean.getPrice());
            pstmt.setInt   (9, bean.getSup_amt());
            pstmt.setInt   (10, bean.getTax());            
            count = pstmt.executeUpdate();            
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
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
        return count;
    }
    /**
     * 견적서 수정
     */
    
    public int updateServItem(ServItemBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query="UPDATE SERV_ITEM SET ITEM=?, STD=?, UNIT=?, COUNT=?, PRICE=?, SUP_AMT=?, TAX=?\n"
            + "WHERE CAR_MNG_ID=? AND SERV_ID=? AND SEQ_NO=?\n";
            
       try{
            con.setAutoCommit(false);
            
            pstmt = con.prepareStatement(query);

			pstmt.setString(1, bean.getItem().trim());
			pstmt.setString(2, bean.getStd().trim());
			pstmt.setString(3, bean.getUnit().trim());
			pstmt.setInt(4, bean.getCount());
			pstmt.setInt(5, bean.getPrice());
			pstmt.setInt(6, bean.getSup_amt());
			pstmt.setInt(7, bean.getTax());
            pstmt.setString(8, bean.getCar_mng_id().trim());
            pstmt.setString(9, bean.getServ_id().trim());
            pstmt.setInt(10,bean.getSeq_no());
            
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
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }


	/**
     * 정비건 삭제
    */    
    public int serviceDel(String car_mng_id,String serv_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        PreparedStatement pstmt2 = null;
        String query,query1 = "";
        int count = -1;
                
        query="DELETE service WHERE car_mng_id=? AND serv_id=? ";

		query1 = "DELETE serv_item WHERE car_mng_id=? AND serv_id=? ";

       try{
            con.setAutoCommit(false);            
            pstmt = con.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
			pstmt.setString(2, serv_id);           
            count = pstmt.executeUpdate();
			pstmt.close();

			pstmt2 = con.prepareStatement(query1);
			pstmt2.setString(1,car_mng_id);
			pstmt2.setString(2,serv_id);
			count = pstmt2.executeUpdate();
            pstmt2.close();             
            
            con.commit();

        }catch(SQLException se){
            try{
                con.rollback();
            }catch(SQLException _ignored){}
				
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
                if(pstmt2 != null) pstmt2.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return count;
    }

	 /**
     * 견적서 조회 2003.10.08.
     */
    public ServItem2Bean [] getServItem2All( String car_mng_id, String serv_id ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = "SELECT car_mng_id, serv_id, seq_no, item, bpm, count, price, amt, labor\n" 
				+ "FROM serv_item\n"
				+ "WHERE car_mng_id=?\n"
				+ "AND serv_id=?\n";

        Collection<ServItem2Bean> col = new ArrayList<ServItem2Bean>();
        try{
            pstmt = con.prepareStatement(query);
    		pstmt.setString(1, car_mng_id.trim());
    		pstmt.setString(2, serv_id.trim());
    		
    		rs = pstmt.executeQuery();

            while(rs.next()){
                
				col.add(makeServItem2Bean(rs));
 
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
        return (ServItem2Bean[])col.toArray(new ServItem2Bean[0]);
    }

	/**
    * 견적서 등록.2003.10.08.
    */    
    public int insertServItem2(ServItem2Bean bean) throws DatabaseException, DataSourceEmptyException{
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
                
        query="INSERT INTO serv_item(car_mng_id, serv_id, seq_no, item, bpm, count, price, amt, labor)\n"
            + "VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)\n";

        query1="SELECT NVL(MAX(seq_no)+1,1) FROM serv_item WHERE car_mng_id=? AND serv_id=?";

       try{
            con.setAutoCommit(false);

            pstmt1 = con.prepareStatement(query1);
            pstmt1.setString(1, bean.getCar_mng_id().trim());
            pstmt1.setString(2, bean.getServ_id().trim());
			rs = pstmt1.executeQuery();
            if(rs.next()){
				seq_no = rs.getInt(1);
            }
            rs.close();
            pstmt1.close();

            pstmt = con.prepareStatement(query);
            pstmt.setString(1, bean.getCar_mng_id().trim());
            pstmt.setString(2, bean.getServ_id().trim());
            pstmt.setInt   (3, seq_no);
            pstmt.setString(4, bean.getItem().trim());
			pstmt.setString(5, bean.getBpm().trim());
            pstmt.setInt   (6, bean.getCount());
            pstmt.setInt   (7, bean.getPrice());
            pstmt.setInt   (8, bean.getAmt());
            pstmt.setInt   (9, bean.getLabor());            
            count = pstmt.executeUpdate();             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
                con.rollback();
            }catch(SQLException _ignored){}
			System.out.println("CarServDatabase:insertServItem2()"+se);
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
        return count;
    }

	/**
     * 견적서 수정 2003.10.08.
    */    
    public int updateServItem2(ServItem2Bean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query="UPDATE serv_item SET item=?, bpm=?, count=?, price=?, amt=?, labor=?\n"
            + "WHERE car_mng_id=? AND serv_id=? AND seq_no=?\n";
            
       try{
            con.setAutoCommit(false);
            
            pstmt = con.prepareStatement(query);

			pstmt.setString(1, bean.getItem().trim());
			pstmt.setString(2, bean.getBpm().trim());
			pstmt.setInt(3, bean.getCount());
			pstmt.setInt(4, bean.getPrice());
			pstmt.setInt(5, bean.getAmt());
			pstmt.setInt(6, bean.getLabor());
            pstmt.setString(7, bean.getCar_mng_id().trim());
            pstmt.setString(8, bean.getServ_id().trim());
            pstmt.setInt(9,bean.getSeq_no());
            
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
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return count;
    }

	/**
     * 견적서 삭제 2003.10.13.
    */    
    public int deleteServItem2(ServItem2Bean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query="DELETE serv_item WHERE car_mng_id=? AND serv_id=? AND seq_no=?\n";
            
       try{
            con.setAutoCommit(false);
            
            pstmt = con.prepareStatement(query);

            pstmt.setString(1, bean.getCar_mng_id().trim());
            pstmt.setString(2, bean.getServ_id().trim());
            pstmt.setInt(3,bean.getSeq_no());
            
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
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return count;
    }

    /**
     * 정비건 수정. 2003.10.13.
     */    
    public String updateService2(ServiceBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query="UPDATE service SET tot_dist=?,next_serv_dt=?,spdchk=?,update_id=?,update_dt=to_char(sysdate,'yyyymmdd')\n"
            + "WHERE car_mng_id=? AND serv_id=? AND rent_mng_id=? AND rent_l_cd=? \n";

       try{
            con.setAutoCommit(false);
            
            pstmt = con.prepareStatement(query);

			pstmt.setString(1, bean.getTot_dist().trim());
			pstmt.setString(2, bean.getNext_serv_dt().trim());
			pstmt.setString(3, bean.getSpd_chk().trim()); 
			pstmt.setString(4, bean.getChecker().trim());
            pstmt.setString(5, bean.getCar_mng_id().trim());
			pstmt.setString(6, bean.getServ_id().trim());
			pstmt.setString(7, bean.getRent_mng_id().trim());
			pstmt.setString(8, bean.getRent_l_cd().trim());

            count = pstmt.executeUpdate();
	            
            pstmt.close();
            con.commit();

        }catch(SQLException se){
            try{
				se.printStackTrace();
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
        return bean.getServ_id();
    }

    /**
     * 정비건 수정2. 2003.10.13.
     */    
    public String updateService3(ServiceBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query="UPDATE service SET rent_mng_id=?,rent_l_cd=?,serv_jc=?,serv_st=?,checker=?,serv_dt=?,tot_dist=?,tot_amt=?,cust_serv_dt=?,off_id=?,next_serv_dt=?,next_rep_cont=?,rep_cont=?\n"
            + "WHERE car_mng_id=? AND serv_id=?\n";

       try{
            con.setAutoCommit(false);
            
            pstmt = con.prepareStatement(query);

			pstmt.setString(1, bean.getRent_mng_id().trim());
			pstmt.setString(2, bean.getRent_l_cd().trim());
			pstmt.setString(3, bean.getServ_jc().trim());
			pstmt.setString(4, bean.getServ_st().trim());
			pstmt.setString(5, bean.getChecker().trim());
			pstmt.setString(6, bean.getServ_dt().trim());
			pstmt.setString(7, bean.getTot_dist().trim());
			pstmt.setInt(8, bean.getTot_amt());
			pstmt.setString(9, bean.getCust_serv_dt().trim());
			pstmt.setString(10, bean.getOff_id().trim());
			pstmt.setString(11, bean.getNext_serv_dt().trim());
			pstmt.setString(12, bean.getNext_rep_cont().trim());
			pstmt.setString(13, bean.getRep_cont().trim());
            pstmt.setString(14, bean.getCar_mng_id().trim());
            pstmt.setString(15, bean.getServ_id().trim());

            count = pstmt.executeUpdate();
            
            pstmt.close();
            con.commit();

        }catch(SQLException se){
            try{
				se.printStackTrace();
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
        return bean.getServ_id();
    }

	/**
     * 순회점검 등록. 2003.12.30.
     */
    public String insertService2(ServiceBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        PreparedStatement pstmt1 = null;
        ResultSet rs = null;
        String query = "";
        String query1, query2 = "";
        String serv_id = "";
        int count = 0;
                
        query="INSERT INTO SERVICE(car_mng_id,serv_id,rent_mng_id,rent_l_cd,serv_st,checker,serv_dt,tot_dist,off_id,next_serv_dt,spdchk,reg_id,reg_dt)\n"
            + "VALUES(?,?,?,?,?,?,?,?,?,?,?,?,to_char(sysdate,'yyyymmdd'))\n";

        query1="SELECT NVL(LPAD(MAX(serv_id)+1,6,'0'),'000001') FROM service WHERE car_mng_id=? and serv_id not like 'N%'";

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
			pstmt.setString(3, bean.getRent_mng_id().trim());
			pstmt.setString(4, bean.getRent_l_cd().trim());
			pstmt.setString(5, bean.getServ_st().trim());
			pstmt.setString(6, bean.getChecker().trim());
			pstmt.setString(7, bean.getServ_dt().trim());
			pstmt.setString(8, bean.getTot_dist().trim());
			pstmt.setString(9, bean.getOff_id().trim());
			pstmt.setString(10, bean.getNext_serv_dt().trim());
			pstmt.setString(11, bean.getSpd_chk().trim());
			pstmt.setString(12, bean.getChecker().trim());			
            count = pstmt.executeUpdate();		             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
                con.rollback();
				System.out.println("[CarServDatabase:insertService2(ServiceBean bean)]"+se);
				se.printStackTrace();
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

	/**
     * 정비비합계 조회 2004.01.06.
     */
    public long getTot_amt( String car_mng_id ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
		long tot_amt = 0;
        
        query = "SELECT nvl(sum(tot_amt),0) FROM service WHERE car_mng_id =?";

        try{
            pstmt = con.prepareStatement(query);
    		pstmt.setString(1, car_mng_id.trim());
    		
    		rs = pstmt.executeQuery();

            while(rs.next()){
                
				tot_amt = rs.getInt(1);
 
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
        return tot_amt;
    }

	/**
     * 정비비 내역별 합계 조회 2010.02.22
     */
    public long getServ_amt( String car_mng_id, String serv_st ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
		long tot_amt = 0;
        
        query = "SELECT nvl(sum(tot_amt),0) as serv_amt FROM service WHERE car_mng_id = ? and serv_st = '"+serv_st+"' ";

//System.out.println("getServ_amt= "+query);
        try{
            pstmt = con.prepareStatement(query);
    		pstmt.setString(1, car_mng_id.trim());
    		
    		rs = pstmt.executeQuery();

            while(rs.next()){
                
				tot_amt = rs.getInt(1);
 
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
        return tot_amt;
    }


/**
	 * 차량 최종 주행거리 가져오기
     */

	public Hashtable getCarInfo(String car_mng_id)throws DatabaseException, DataSourceEmptyException{
	
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	

		Statement stmt = null;
		ResultSet rs = null;

		Hashtable ht = new Hashtable();
		int count = 0;

		String query = "";

		 query = " SELECT car_mng_id, MAX(serv_dt) AS serv_dt,  MAX(tot_dist) AS tot_dist "+
				" FROM SERVICE  WHERE car_mng_id = '"+car_mng_id.trim()+"' GROUP BY car_mng_id \n"; 



//System.out.println("getCarInfo="+query);

		try {
			stmt = con.createStatement();
            rs = stmt.executeQuery(query);
			ResultSetMetaData rsmd = rs.getMetaData();

			if(rs.next()){	
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
            rs.close();
            stmt.close();

		} catch (SQLException e) {
			System.out.println("[CarServDatabase:getCarInfo]"+e);
			System.out.println("[CarServDatabase:getCarInfo]"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )			rs.close();
                if(stmt != null)		stmt.close();
			 }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
			return ht;
		}
	}

	/**
	 * 차량 최종 주행거리 가져오기 -카드 유류대인 경우는 별도처리 - 안팀장님 요청사항 
    */

	public Hashtable getCarInfoOil(String car_mng_id)throws DatabaseException, DataSourceEmptyException{
	
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
           throw new DataSourceEmptyException("Can't get Connection !!");
	
		Statement stmt = null;
		ResultSet rs = null;

		Hashtable ht = new Hashtable();
		int count = 0;

		String query = "";

		 query = " SELECT item_code car_mng_id, MAX(buy_dt) AS serv_dt,  MAX(tot_dist) AS tot_dist "+
				" FROM card_doc  WHERE item_code = '"+car_mng_id.trim()+"' GROUP BY item_code \n"; 


//System.out.println("getCarInfo="+query);

		try {
			stmt = con.createStatement();
           rs = stmt.executeQuery(query);
			ResultSetMetaData rsmd = rs.getMetaData();

			if(rs.next()){	
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
           rs.close();
           stmt.close();

		} catch (SQLException e) {
			System.out.println("[CarServDatabase:getCarInfo]"+e);
			System.out.println("[CarServDatabase:getCarInfo]"+query);
	  		e.printStackTrace();
		} finally {
			try{
               if(rs != null )			rs.close();
               if(stmt != null)		stmt.close();
			 }catch(SQLException _ignored){}
           connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
			return ht;
		}
	}


/**
     * 각종수리 등록 : car_accid_all_i_a.jsp
     */
    public String insertServiceDist(ServiceBean bean) throws DatabaseException, DataSourceEmptyException{
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
                
        query = "  INSERT INTO service("+
				"        CAR_MNG_ID, SERV_ID, ACCID_ID, RENT_MNG_ID, RENT_L_CD,"+
				"        OFF_ID, SERV_DT, SERV_ST, CHECKER, TOT_DIST,"+
				"        REP_CONT, next_serv_dt,"+
				"        REG_DT, REG_ID"+
				"  )\n"+
				"  values(?, ?, ?, ?, ?, "+
				"         ?, replace(?,'-',''), ?, ?, replace(?,',',''), "+
				"         ?, replace(?,'-',''), "+
				"         to_char(sysdate,'YYYYMMDD'), ? "+
				"  )\n";

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
            pstmt.setString(1,  bean.getCar_mng_id	().trim());
            pstmt.setString(2,  serv_id.trim());
			pstmt.setString(3,  bean.getAccid_id	().trim());
			pstmt.setString(4,  bean.getRent_mng_id	().trim());
			pstmt.setString(5,  bean.getRent_l_cd	().trim());
			pstmt.setString(6,  bean.getOff_id		().trim());
			pstmt.setString(7,  bean.getServ_dt		().trim());
			pstmt.setString(8,  bean.getServ_st		().trim());
			pstmt.setString(9,  bean.getChecker		().trim());
			pstmt.setString(10, bean.getTot_dist	().trim());
			pstmt.setString(11, bean.getRep_cont	().trim());
			pstmt.setString(12, bean.getNext_serv_dt().trim());
			pstmt.setString(13, bean.getReg_id		().trim());
							         
            count = pstmt.executeUpdate();             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[CarServDatabase:insertServiceDist]\n"+se);
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


	/****************************************************************************************
	*******************************************   smart
    ****************************************************************************************/
/**
     * 서비스 건별 간편 조회
     */    
    private ServiceBean makeServiceBeanCase(ResultSet results) throws DatabaseException {
        try {
			ServiceBean bean = new ServiceBean();
			bean.setCar_mng_id	(results.getString("car_mng_id")); 
			bean.setServ_id		(results.getString("serv_id")); 
			bean.setRent_mng_id	(results.getString("rent_mng_id")); 
			bean.setRent_l_cd	(results.getString("rent_l_cd")); 
			bean.setOff_nm		(results.getString("OFF_NM")); 
			bean.setServ_dt		(results.getString("SERV_DT")); 
			bean.setServ_st		(results.getString("SERV_ST")); 
			bean.setChecker		(results.getString("CHECKER")); 
			bean.setTot_dist	(results.getString("TOT_DIST")); 
			bean.setRep_cont	(results.getString("REP_CONT")); 
			bean.setOff_tel		(results.getString("OFF_TEL"));
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}

	 /**
     * 서비스 개별 간단 조회
     */
    public ServiceBean getServiceDist(String car_mng_id, String serv_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		ServiceBean sb = new ServiceBean();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = " select"+
				" a.car_mng_id, a.serv_id, a.rent_mng_id, a.rent_l_cd, b.off_nm, b.off_tel, a.rep_cont, a.serv_st, a.checker, a.tot_dist,"+
				" nvl2(a.serv_dt,substr(a.serv_dt,1,4)||'-'||substr(a.serv_dt,5,2)||'-'||substr(a.serv_dt,7,2),'') serv_dt"+
				" from service a, serv_off b\n"+
				" where a.car_mng_id='"+car_mng_id+"' and a.serv_id='"+serv_id+"'\n"+
				" and a.off_id=b.off_id(+)\n";

        try{

			pstmt = con.prepareStatement(query);
    		rs = pstmt.executeQuery();
            if (rs.next()){
                sb = makeServiceBeanCase(rs);
			}
            
            rs.close();
            pstmt.close();

        }catch(SQLException se){
			System.out.println("[CarServDatabase:getServiceDist]\n"+se);
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
     * 서비스조회
     */
    public ServiceBean [] getServiceAll_OtherDist( String car_mng_id ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
		query = " select decode(st,'cls','해지','cons','탁송','maint','검사') as off_nm, car_mng_id, tot_dt as serv_dt, tot_dist, reg_dt "+
				" from v_dist where car_mng_id='"+car_mng_id+"' and st<>'service' order by tot_dt "; 

			

		Collection<ServiceBean> col = new ArrayList<ServiceBean>();
        try{

            pstmt = con.prepareStatement(query);    		
    		rs = pstmt.executeQuery();

            while(rs.next()){
                
				col.add(makeServiceOtherDistBean(rs));
 
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
            con = null ;
        }
        return (ServiceBean[])col.toArray(new ServiceBean[0]);
    }

    private ServiceBean makeServiceOtherDistBean(ResultSet results) throws DatabaseException {

        try {
            ServiceBean bean = new ServiceBean();

		    bean.setCar_mng_id	(results.getString("CAR_MNG_ID")); 					//자동차관리번호
			bean.setOff_nm		(results.getString("OFF_NM")); 
			bean.setServ_dt		(results.getString("SERV_DT")); 
			bean.setTot_dist	(results.getString("TOT_DIST")); 
			bean.setReg_dt		(results.getString("REG_DT")); 

            return bean;
        }catch (SQLException e) {
			e.printStackTrace();
            throw new DatabaseException(e.getMessage());
        }
	}



}
