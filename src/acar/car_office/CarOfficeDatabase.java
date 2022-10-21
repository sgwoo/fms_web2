/*
 * 사용자등록, 메뉴관리, 권한관리
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.car_office;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Hashtable;
import java.util.Vector;

import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.DatabaseException;
import acar.exception.UnknownDataException;
import acar.util.AddUtil;

public class CarOfficeDatabase {

    private static CarOfficeDatabase instance;
    private DBConnectionManager connMgr;   
    // Pool로 부터 Connection 객체를 가져올때 사용하는 Pool Name 
    private final String DATA_SOURCE = "acar"; 
 
    // 싱글톤 클래스로 구현 
    // 생성자를 private 로 선언
    public static synchronized CarOfficeDatabase getInstance() throws DatabaseException {
        if (instance == null)
            instance = new CarOfficeDatabase();
        return instance;
    }
    
    private CarOfficeDatabase() throws DatabaseException {
        connMgr = DBConnectionManager.getInstance();
    }
    
    /**
     * 특정 레코드를 Bean에 저장하여 Bean을 리턴하는 메소드
     */
	/**
     * 자동차회사
     */
    private CarCompBean makeCarCompBean(ResultSet results) throws DatabaseException {

        try {
            CarCompBean bean = new CarCompBean();

            bean.setC_st	(results.getString("C_ST"));					//코드분류
		    bean.setCode	(results.getString("CODE"));					//코드(순차적증가)
		    bean.setNm_cd	(results.getString("NM_CD"));					//사용코드명
		    bean.setNm		(results.getString("NM"));						//부서이름
		    bean.setEtc		(results.getString("ETC"));						//비고
		    bean.setApp_st	(results.getString("APP_ST"));					//출처
		    bean.setCms_bk	(results.getString("CMS_BK"));					//견적여부
			bean.setBigo	(results.getString("BIGO"));					//제조사DC반영내용
		    
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}	
	/**
     * 자동차회사 영업소
     */
    private CarOffBean makeCarOffBean(ResultSet results) throws DatabaseException {

        try {
            CarOffBean bean = new CarOffBean();

		    bean.setCar_off_id	(results.getString("CAR_OFF_ID"));					//영업소ID
		    bean.setCar_comp_id	(results.getString("CAR_COMP_ID"));					//자동차회사ID
		    bean.setCar_comp_nm	(results.getString("CAR_COMP_NM"));					//자동차회사이름
		    bean.setCar_off_nm	(results.getString("CAR_OFF_NM"));					//영업소명
		    bean.setCar_off_st	(results.getString("CAR_OFF_ST"));					//영업소구분
		    bean.setOwner_nm	(results.getString("OWNER_NM"));					//관할지점
		    bean.setCar_off_tel	(results.getString("CAR_OFF_TEL"));					//사무실전화
		    bean.setCar_off_fax	(results.getString("CAR_OFF_FAX"));					//팩스
		    bean.setCar_off_post(results.getString("CAR_OFF_POST"));				//우편번호
		    bean.setCar_off_addr(results.getString("CAR_OFF_ADDR"));				//주소
		    bean.setBank		(results.getString("BANK"));						//계좌개설은행
		    bean.setAcc_no		(results.getString("ACC_NO"));						//계좌번호
		    bean.setAcc_nm		(results.getString("ACC_NM"));						//예금주
		    bean.setVen_code	(results.getString("VEN_CODE"));					//네오엠거래처코드
			bean.setManager		(results.getString("MANAGER"));						//소장명
		    bean.setAgnt_nm		(results.getString("AGNT_NM"));						//출고실무자
		    bean.setAgnt_m_tel	(results.getString("AGNT_M_TEL"));					//출고실무자핸드폰
			bean.setEnp_no		(results.getString("ENP_NO"));						//사업자등록번호		    
		    bean.setReg_id		(results.getString("REG_ID"));						//등록자         
		    bean.setReg_dt		(results.getString("REG_DT"));						//등록일         
		    bean.setAgent_st	(results.getString("AGENT_ST"));					//소속구분       
			bean.setEnp_st		(results.getString("ENP_ST"));						//사업자구분     
		    bean.setEnp_reg_st	(results.getString("ENP_REG_ST"));					//사업자등록구분 
		    bean.setDoc_st		(results.getString("DOC_ST"));						//증빙구분       
		    bean.setEst_day		(results.getString("EST_DAY"));						//지급예정일     
		    bean.setReq_st		(results.getString("REQ_ST"));						//수취여부       
		    bean.setPay_st		(results.getString("PAY_ST"));						//지급구분       
		    bean.setAgnt_email	(results.getString("AGNT_EMAIL"));					//출고실무자메일
		    bean.setWork_st		(results.getString("WORK_ST"));						//업무구분       
			bean.setUse_yn		(results.getString("USE_YN"));						//거래구분      
		    bean.setEst_mon_st	(results.getString("EST_MON_ST"));					//지급월기준
		    bean.setBank_cd		(results.getString("BANK_CD"));


			return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}
	/**
     * 자동차회사 영업소 사원
     */
    private CarOffEmpBean makeCarOffEmpBean(ResultSet results) throws DatabaseException {

        try {
            CarOffEmpBean bean = new CarOffEmpBean();

		    bean.setEmp_id(results.getString("EMP_ID"));						//영업사원ID
		    bean.setCar_off_id(results.getString("CAR_OFF_ID"));					//영업소ID
		    bean.setCar_off_nm(results.getString("CAR_OFF_NM"));					//영업소명칭
			bean.setCar_off_st(results.getString("CAR_OFF_ST"));					//영업소구분
			bean.setOwner_nm(results.getString("OWNER_NM"));					//지점장
			bean.setCar_comp_id(results.getString("CAR_COMP_ID"));					//자동차회사ID
		    bean.setCar_comp_nm(results.getString("CAR_COMP_NM"));					//자동차회사 명칭
		    bean.setCust_st(results.getString("CUST_ST"));						//고객구분
		    bean.setEmp_nm(results.getString("EMP_NM"));						//성명
		    bean.setEmp_ssn(results.getString("EMP_SSN"));						//주민등록번호
		    bean.setCar_off_tel(results.getString("CAR_OFF_TEL"));					//사무실전화
    		bean.setCar_off_fax(results.getString("CAR_OFF_FAX"));					//팩스
		    bean.setEmp_m_tel(results.getString("EMP_M_TEL"));					//핸드폰
		    bean.setEmp_pos(results.getString("EMP_POS"));						//직위
		    bean.setEmp_email(results.getString("EMP_EMAIL"));					//이메일
		    bean.setEmp_bank(results.getString("EMP_BANK"));					//은행
		    bean.setEmp_acc_no(results.getString("EMP_ACC_NO"));					//계좌번호
		    bean.setEmp_acc_nm(results.getString("EMP_ACC_NM"));					//예금주
		    bean.setEmp_post(results.getString("EMP_POST"));
		    bean.setEmp_addr(results.getString("EMP_ADDR"));
		    bean.setEtc(results.getString("ETC"));
		    bean.setCar_off_post(results.getString("CAR_OFF_POST"));			//영업소 우편번호
		    bean.setCar_off_addr(results.getString("CAR_OFF_ADDR"));			//영업소 주소
			bean.setReg_dt(results.getString("REG_DT"));
			bean.setReg_id(results.getString("REG_ID"));
			bean.setUpd_dt(results.getString("UPD_DT"));
			bean.setUpd_id(results.getString("UPD_ID"));
			bean.setEmp_h_tel(results.getString("EMP_H_TEL"));
			bean.setEmp_sex(results.getString("EMP_SEX"));
			bean.setUse_yn(results.getString("USE_YN"));
			bean.setSms_denial_rsn(results.getString("SMS_DENIAL_RSN"));
			//담당자지정사유
			bean.setSeq(results.getString("SEQ"));
			bean.setDamdang_id(results.getString("DAMDANG_ID"));
			bean.setCng_rsn(results.getString("CNG_RSN"));
			bean.setCng_dt(results.getString("CNG_DT"));
			bean.setFile_name1(results.getString("FILE_NAME1"));
			bean.setFile_name2(results.getString("FILE_NAME2"));
			bean.setFile_gubun1(results.getString("FILE_GUBUN1"));
			bean.setFile_gubun2(results.getString("FILE_GUBUN2"));
			bean.setOne_self_yn(results.getString("ONE_SELF_YN"));
			bean.setAgent_id(results.getString("AGENT_ID"));
			bean.setEmp_dept(results.getString("EMP_DEPT"));
			bean.setFraud_care(results.getString("FRAUD_CARE"));
			bean.setBank_cd(results.getString("BANK_CD"));
						
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}
	/**
     * 자동차회사 영업소 사원 문일지
     */
    private CarOffEmpVisBean makeCarOffEmpVisBean(ResultSet results) throws DatabaseException {

        try {
            CarOffEmpVisBean bean = new CarOffEmpVisBean();

		    bean.setEmp_id(results.getString("EMP_ID"));						//영업사원ID
		    bean.setSeq_no(results.getInt("SEQ_NO"));
			bean.setVis_nm(results.getString("VIS_NM"));
			bean.setVis_dt(results.getString("VIS_DT"));
			bean.setSub(results.getString("SUB"));
			bean.setVis_cont(results.getString("VIS_CONT"));
		    
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}
	/**
     * 영업사원 지급수수료
     */
    private CommiBean makeCommiBean(ResultSet results) throws DatabaseException {

        try {
            CommiBean bean = new CommiBean();
		    
		    bean.setRent_mng_id(results.getString("RENT_MNG_ID")); 				//계약관리번호
			bean.setRent_l_cd(results.getString("RENT_L_CD"));					//영업소사원ID
			bean.setEmp_id(results.getString("EMP_ID"));						//계약번호
			bean.setAgnt_st(results.getString("AGNT_ST"));						//담당자구분
			bean.setCommi(results.getInt("COMMI"));							//지급수수료
			bean.setInc_amt(results.getInt("INC_AMT"));						//소득세
			bean.setRes_amt(results.getInt("RES_AMT"));							//주민세
			bean.setTot_amt(results.getInt("TOT_AMT"));							//합계
			bean.setDif_amt(results.getInt("DIF_AMT"));							//차인지급액
			bean.setSup_dt(results.getString("SUP_DT"));						//지급일짜
			bean.setRel(results.getString("REL"));   							//영업담당자와의 관계
		    bean.setCon_mon(results.getString("CON_MON"));
		    bean.setRent_dt(results.getString("RENT_DT"));
		    bean.setDlv_dt(results.getString("DLV_DT"));						//계약일자
			bean.setFirm_nm(results.getString("FIRM_NM"));						//상호
			bean.setClient_nm(results.getString("CLIENT_NM"));					//계약자
			bean.setCar_name(results.getString("CAR_NAME"));					//차명
			bean.setInit_reg_dt(results.getString("INIT_REG_DT"));				//등록일
			bean.setClient_st(results.getString("CLIENT_ST"));					//고객구분
			bean.setUser_nm(results.getString("USER_NM"));						//영업부 담담자
			bean.setCar_no(results.getString("CAR_NO"));
			bean.setEmp_acc_nm(results.getString("EMP_ACC_NM"));
			bean.setEmp_nm(results.getString("EMP_NM"));
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}
	/**
     * 영업사원 담당자 변경 이력 20050818.
     */
    private CarOffEdhBean makeCarOffEdhBean(ResultSet results) throws DatabaseException {

        try {
            CarOffEdhBean bean = new CarOffEdhBean();

		    bean.setEmp_id(results.getString("EMP_ID"));						//영업사원ID
		    bean.setSeq(results.getString("SEQ"));
			bean.setDamdang_id(results.getString("DAMDANG_ID"));
			bean.setCng_dt(results.getString("CNG_DT"));
			bean.setCng_rsn(results.getString("CNG_RSN"));
			bean.setReg_id(results.getString("REG_ID"));
			bean.setReg_dt(results.getString("REG_DT"));
		    
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}

	/**
     * 제조사 전체 조회.
     */
    public CarCompBean [] getCarCompAll() throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = "SELECT C_ST, CODE, NM_CD, NM, ETC, APP_ST, CMS_BK, BIGO  \n"
        		+ "FROM CODE a\n"
        		+ "where C_ST='0001'\n"
        		+ "and CODE <> '0000' and nm is not null and nvl(cms_bk,'Y')='Y' order by app_st, code ";

        Collection<CarCompBean> col = new ArrayList<CarCompBean>();
        try{
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery(query);
            while(rs.next()){
                
				col.add(makeCarCompBean(rs));
 
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
        return (CarCompBean[])col.toArray(new CarCompBean[0]);
    }


	/**
     * 제조사 전체 조회.
     */
    public CarCompBean [] getCarCompAll_Esti() throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = " SELECT C_ST, CODE, NM_CD, NM, ETC, APP_ST, CMS_BK, BIGO FROM CODE where C_ST='0001' and cms_bk='Y' ORDER BY app_st, code ";
//        		+ "and CODE <> '0000' and (code < '0006' or code in ('0013','0007','0027','0018','0044','0011','0021','0033','0025','0048','0047','0034','0049','0006','0050','0051','0052')) order by code ";

        Collection<CarCompBean> col = new ArrayList<CarCompBean>();
        try{
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery(query);
            while(rs.next()){
                
				col.add(makeCarCompBean(rs));
 
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
        return (CarCompBean[])col.toArray(new CarCompBean[0]);
    }

    /**
     * 영업소 조회
     */    
    public CarOffBean getCarOffBean(String car_off_id) throws UnknownDataException, DataSourceEmptyException, DatabaseException {
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null) 
            throw new DataSourceEmptyException("Can't get connection.!!");

        CarOffBean umb;

        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        query = "SELECT a.car_off_id as CAR_OFF_ID,\n" 
						+ "a.car_comp_id as CAR_COMP_ID,\n" 
						+ "b.nm as CAR_COMP_NM,\n" 
						+ "a.car_off_nm as CAR_OFF_NM,\n" 
						+ "a.car_off_st as CAR_OFF_ST,\n" 
						+ "a.owner_nm as OWNER_NM, \n"
						+ "a.car_off_tel as CAR_OFF_TEL,\n" 
						+ "a.car_off_fax as CAR_OFF_FAX,\n"
						+ "a.car_off_post as CAR_OFF_POST,\n"
						+ "a.car_off_addr as CAR_OFF_ADDR,\n"
						+ "a.bank as BANK,\n" 
						+ "a.acc_no as ACC_NO,\n" 
						+ "a.acc_nm as ACC_NM, \n"
						+ "a.use_yn as USE_YN, a.VEN_CODE, a.MANAGER, a.AGNT_NM, a.AGNT_M_TEL, a.enp_no, \n"
						+ "a.reg_id, a.reg_dt, a.agent_st, a.enp_st, a.enp_reg_st, a.doc_st, a.est_day, a.req_st, a.pay_st, \n"
						+ "a.AGNT_EMAIL, a.work_st, a.est_mon_st, a.bank_cd \n"
				+ "FROM car_off a, code b\n"
				+ "where a.car_off_id = '" + car_off_id + "'\n"
				+ "and a.car_comp_id=b.code\n"
				+ "and b.c_st = '0001'\n";
        try {
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
    
            if (rs.next())
                umb = makeCarOffBean(rs);
            else
                throw new UnknownDataException("Could not find Appcode # " + car_off_id );
 
 			rs.close();
            stmt.close();
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }finally{
            try{
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){} 
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return umb;
    }
    
    /**
     * 영업소 전체 조회.
     */
    public CarOffBean [] getCarOffAll(String cc_id, String gubun, String gubun_nm) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String subQuery = "";
        String query = "";
        
        if(gubun.equals("owner_nm")){
        	subQuery = "and nvl(a.owner_nm, ' ') like '%" + gubun_nm + "%'\n";
        }else if(gubun.equals("car_off_nm")){
        	subQuery = "and nvl(a.car_off_nm, ' ') like '%" + gubun_nm + "%'\n";
        }else{
        	subQuery = "and a.car_off_nm like '%" + gubun_nm + "%'\n";
        }
		if(cc_id.equals("") && gubun.equals("") && gubun_nm.equals("")) subQuery = " and a.car_off_nm='99' ";
        
        query = "SELECT a.car_off_id as CAR_OFF_ID,\n" 
						+ "a.car_comp_id as CAR_COMP_ID,\n" 
						+ "b.nm as CAR_COMP_NM,\n" 
						+ "a.car_off_nm as CAR_OFF_NM,\n" 
						+ "a.car_off_st as CAR_OFF_ST,\n" 
						+ "a.owner_nm as OWNER_NM, \n"
						+ "a.car_off_tel as CAR_OFF_TEL,\n" 
						+ "a.car_off_fax as CAR_OFF_FAX,\n"
						+ "a.car_off_post as CAR_OFF_POST,\n"
						+ "a.car_off_addr as CAR_OFF_ADDR,\n"
						+ "a.bank as BANK,\n" 
						+ "a.acc_no as ACC_NO,\n" 
						+ "a.acc_nm as ACC_NM, a.use_yn as USE_YN, a.VEN_CODE, a.MANAGER, a.AGNT_NM, a.AGNT_M_TEL, a.enp_no, \n"
						+ "a.reg_id, a.reg_dt, a.agent_st, a.enp_st, a.enp_reg_st, a.doc_st, a.est_day, a.req_st, a.pay_st, \n"
						+ "a.AGNT_EMAIL, a.work_st, a.est_mon_st, a.bank_cd \n"
				+ "FROM car_off a, code b\n"
				+ "where a.car_comp_id like '%" + cc_id + "%'\n"
				+ subQuery
				+ "and a.car_comp_id=b.code\n"
				+ "and b.c_st = '0001'\n order by a.owner_nm, a.car_off_nm";

        Collection<CarOffBean> col = new ArrayList<CarOffBean>();
        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
                
				col.add(makeCarOffBean(rs));
 
            }
            
            rs.close();
            stmt.close();
        }catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (CarOffBean[])col.toArray(new CarOffBean[0]);
    }

    /**
     * 영업소 전체 조회.
     */
    public CarOffBean [] getCarOffAllList(String gubun1, String gubun2, String gubun3, String gubun4, String s_kd, String t_wd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String subQuery = "";
        String query = "";
        
		if(gubun1.equals("") && gubun2.equals("") && gubun3.equals("") && s_kd.equals("") && t_wd.equals("")) subQuery = " and a.car_off_nm='99' ";
		
		if(!t_wd.equals("")){
	        if(s_kd.equals("owner_nm")){	      		subQuery = "and nvl(a.owner_nm, ' ') like '%" + t_wd + "%'\n";
		    }else if(s_kd.equals("car_off_nm")){        subQuery = "and nvl(a.car_off_nm, ' ') like '%" + t_wd + "%'\n";
			}else{        								subQuery = "and a.car_off_nm like '%" + t_wd + "%'\n";
	        }	
		}

		if(!gubun1.equals(""))	subQuery += " and a.car_off_addr like '%" + gubun1.trim() + "%'";

		if(!gubun2.equals(""))	subQuery += " and a.car_off_addr like '%" + gubun2.trim() + "%'";
        
		if(!gubun3.equals(""))	subQuery += " and a.car_comp_id = '" + gubun3 + "'";

		if(!gubun4.equals("0"))	subQuery += " and a.car_off_st = '" + gubun4 + "'";

		query = "SELECT a.car_off_id as CAR_OFF_ID,\n" 
						+ "a.car_comp_id as CAR_COMP_ID,\n" 
						+ "b.nm as CAR_COMP_NM,\n" 
						+ "a.car_off_nm as CAR_OFF_NM,\n" 
						+ "a.car_off_st as CAR_OFF_ST,\n" 
						+ "a.owner_nm as OWNER_NM, \n"
						+ "a.car_off_tel as CAR_OFF_TEL,\n" 
						+ "a.car_off_fax as CAR_OFF_FAX,\n"
						+ "a.car_off_post as CAR_OFF_POST,\n"
						+ "a.car_off_addr as CAR_OFF_ADDR,\n"
						+ "a.bank as BANK,\n" 
						+ "a.acc_no as ACC_NO,\n" 
						+ "a.acc_nm as ACC_NM, \n"
						+ "a.use_yn as USE_YN, a.VEN_CODE, a.MANAGER, a.AGNT_NM, a.AGNT_M_TEL, a.enp_no, \n"
						+ "a.reg_id, a.reg_dt, a.agent_st, a.enp_st, a.enp_reg_st, a.doc_st, a.est_day, a.req_st, a.pay_st, \n"
						+ "a.AGNT_EMAIL, a.work_st, a.est_mon_st, a.bank_cd \n"
				+ "FROM car_off a, code b\n"
				+ "where "//a.use_yn='Y' and 
				+ "a.car_comp_id=b.code\n"
				+ "and b.c_st = '0001' and a.car_comp_id <> '1000' \n "
				+ subQuery + "\n"
				+ "order by a.use_yn desc, a.owner_nm, a.car_off_nm";

		Collection<CarOffBean> col = new ArrayList<CarOffBean>();

        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
                
				col.add(makeCarOffBean(rs));
 
            }
            
            rs.close();
            stmt.close();
        }catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (CarOffBean[])col.toArray(new CarOffBean[0]);
    }

    /**
     * 영업소 전체 조회.-문자보내기 검색 조회화면 에서
     */
    public CarOffBean [] getCarOffAll2(String sido, String gugun, String cc_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String subQuery = "";
        String query = "";
        
		if(!sido.equals("")&&!gugun.equals(""))	subQuery = " and a.car_off_addr like '%"+sido+" "+gugun+"%' ";
		else if(!sido.equals(""))	subQuery = " and a.car_off_addr like '%"+sido+"%' ";

		if(!cc_id.equals(""))		subQuery += " and a.car_comp_id = '"+cc_id+"' ";
        
        query = "SELECT a.car_off_id as CAR_OFF_ID,\n" 
						+ "a.car_comp_id as CAR_COMP_ID,\n" 
						+ "b.nm as CAR_COMP_NM,\n" 
						+ "a.car_off_nm as CAR_OFF_NM,\n" 
						+ "a.car_off_st as CAR_OFF_ST,\n" 
						+ "a.owner_nm as OWNER_NM, \n"
						+ "a.car_off_tel as CAR_OFF_TEL,\n" 
						+ "a.car_off_fax as CAR_OFF_FAX,\n"
						+ "a.car_off_post as CAR_OFF_POST,\n"
						+ "a.car_off_addr as CAR_OFF_ADDR,\n"
						+ "a.bank as BANK,\n" 
						+ "a.acc_no as ACC_NO,\n" 
						+ "a.acc_nm as ACC_NM, a.use_yn as USE_YN, a.VEN_CODE, a.MANAGER, a.AGNT_NM, a.AGNT_M_TEL, a.enp_no, \n"
						+ "a.reg_id, a.reg_dt, a.agent_st, a.enp_st, a.enp_reg_st, a.doc_st, a.est_day, a.req_st, a.pay_st, \n"
						+ "a.AGNT_EMAIL, a.work_st, a.est_mon_st, a.bank_cd \n"
				+ "FROM car_off a, code b\n"
				+ "where a.car_comp_id=b.code\n"
				+ subQuery
				+ "and b.c_st = '0001'\n order by a.owner_nm, a.car_off_nm";

        Collection<CarOffBean> col = new ArrayList<CarOffBean>();

        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
                
				col.add(makeCarOffBean(rs));
 
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (CarOffBean[])col.toArray(new CarOffBean[0]);
    }


    /**
     * 영업소 사원 조회
     */    
    public CarOffEmpBean getCarOffEmpBean(String emp_id) throws UnknownDataException, DataSourceEmptyException, DatabaseException {
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null) 
            throw new DataSourceEmptyException("Can't get connection.!!");

        CarOffEmpBean umb;

        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
		query = "select a.emp_id as EMP_ID,\n"
						+ "a.car_off_id as CAR_OFF_ID,\n" 
						+ "b.car_off_nm as CAR_OFF_NM, b.car_off_st, b.owner_nm as OWNER_NM,\n"
						+ "b.car_comp_id as CAR_COMP_ID,\n"
						+ "c.nm as CAR_COMP_NM,\n"
						+ "a.cust_st as CUST_ST,\n"
						+ "a.emp_nm as EMP_NM,\n"
						+ "a.emp_ssn as EMP_SSN,\n"
						+ "b.car_off_tel as CAR_OFF_TEL,\n"
						+ "b.car_off_fax as CAR_OFF_FAX,\n"
						+ "a.emp_m_tel as EMP_M_TEL,\n"
						+ "a.emp_pos as EMP_POS,\n"
						+ "a.emp_email as EMP_EMAIL,\n"
						+ "a.emp_bank as EMP_BANK,\n"
						+ "a.emp_acc_no as EMP_ACC_NO,\n"
						+ "a.emp_acc_nm as EMP_ACC_NM,a.emp_post as EMP_POST,a.emp_addr as EMP_ADDR, a.etc as ETC,\n"
						+ "b.car_off_post as CAR_OFF_POST, b.car_off_addr as CAR_OFF_ADDR, \n"
						+ "a.reg_dt, a.reg_id, a.upd_dt, a.upd_id, \n"
						+ "a.emp_h_tel, a.emp_sex, a.use_yn, a.sms_denial_rsn, '' SEQ, '' DAMDANG_ID, '' CNG_RSN, '' CNG_DT \n"
						+ ", a.file_name1, a.file_name2, a.file_gubun1, a.file_gubun2, b.one_self_yn, a.agent_id, a.emp_dept, a.fraud_care, a.bank_cd \n"
				+ "from car_off_emp a, car_off b, code c\n"
				+ "where a.emp_id='" + emp_id + "'\n \n"
				+ "and a.car_off_id = b.car_off_id \n"
				+ "and b.car_comp_id = c.code\n"
				+ "and c.c_st = '0001'\n";

        try {
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
    
            if (rs.next())
                umb = makeCarOffEmpBean(rs);
            else
                throw new UnknownDataException("Could not find Appcode # " + emp_id );
 			rs.close();
            stmt.close();
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());

        }finally{
            try{
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){} 
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return umb;
    }
    
    /**
     * 영업소 사원 전체 조회.
     */
    public CarOffEmpBean [] getCarOffEmpAll(String gubun, String gu_nm, String sort_gubun, String sort, String cng_rsn) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String subQuery = "";
		if(!gu_nm.equals("")){
			if(gubun.equals("car_comp")){
				subQuery = "and c.nm like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("car_off")){
				subQuery = "and b.car_off_nm like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("emp_nm")){
				subQuery = "and nvl(a.emp_nm,' ') like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("mix")){
				subQuery = "and a.emp_nm||b.car_off_nm||a.emp_m_tel like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("emp_email")){
				subQuery = "and nvl(a.emp_email,' ') like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("emp_m_tel")){
				subQuery = "and nvl(a.emp_m_tel,' ') like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("car_off_nm")){
				subQuery = "and nvl(b.car_off_nm,' ') like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("damdang_id")){
				subQuery = "and d.damdang_id ='"+ gu_nm + "' \n";
			}else{
				subQuery = "";
			}
		}else{
			subQuery = " and nvl(a.reg_dt, a.upd_dt)=to_char(sysdate,'yyyymmdd') ";
		}

		if(!cng_rsn.equals("")){
			subQuery += " and d.cng_rsn ='"+ cng_rsn + "' \n";
		}
		String query = "";
        query = "select a.emp_id as EMP_ID,\n"
						+ "a.car_off_id as CAR_OFF_ID,\n" 
						+ "b.car_off_nm as CAR_OFF_NM, b.car_off_st, b.owner_nm as OWNER_NM,\n"
						+ "b.car_comp_id as CAR_COMP_ID,\n"
						+ "c.nm as CAR_COMP_NM,\n"
						+ "a.cust_st as CUST_ST,\n"
						+ "a.emp_nm as EMP_NM,\n"
						+ "a.emp_ssn as EMP_SSN,\n"
						+ "b.car_off_tel as CAR_OFF_TEL,\n"
						+ "b.car_off_fax as CAR_OFF_FAX,\n"
						+ "a.emp_m_tel as EMP_M_TEL,\n"
						+ "a.emp_pos as EMP_POS,\n"
						+ "a.emp_email as EMP_EMAIL,\n"
						+ "a.emp_bank as EMP_BANK,\n"
						+ "a.emp_acc_no as EMP_ACC_NO,\n"
						+ "a.emp_acc_nm as EMP_ACC_NM,a.emp_post as EMP_POST,a.emp_addr as EMP_ADDR, a.etc as ETC,\n"
						+ "b.car_off_post as CAR_OFF_POST, b.car_off_addr as CAR_OFF_ADDR, \n"
						+ "nvl(a.reg_dt,'-') reg_dt, a.reg_id, a.upd_dt, a.upd_id, \n"
						+ "a.emp_h_tel, a.emp_sex, a.use_yn, a.sms_denial_rsn \n"
						+ ", d.seq, d.damdang_id, d.cng_rsn, d.cng_dt "
						+ ", a.file_name1, a.file_name2, a.file_gubun1, a.file_gubun2, b.one_self_yn, a.agent_id, a.emp_dept, a.fraud_care, a.bank_cd \n"
				+ "from car_off_emp a, car_off b, code c, "
				+ "		(select emp_id, seq, damdang_id, cng_rsn, cng_dt from car_off_edh a where a.seq=(select max(seq) from car_off_edh b where a.emp_id=b.emp_id)) d "
				+ "where a.car_off_id = b.car_off_id \n"
				+ "and b.car_comp_id = c.code\n"
				+ "and c.c_st = '0001'\n"
				+ "and a.emp_id = d.emp_id(+) "
				+ subQuery;
		
		if(!sort_gubun.equals("")) query += " order by nvl(a.upd_dt,a.reg_dt) desc, "+sort_gubun+" "+sort;
		Collection<CarOffEmpBean> col = new ArrayList<CarOffEmpBean>();
        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
                
				col.add(makeCarOffEmpBean(rs));
 
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			System.out.println("[CarOfficeDatabase:getCarOffEmpAll(String gubun, String gu_nm)]"+se);
			System.out.println("[CarOfficeDatabase:getCarOffEmpAll(String gubun, String gu_nm)]"+query);
			se.printStackTrace();
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (CarOffEmpBean[])col.toArray(new CarOffEmpBean[0]);
    }

    /**
     * 영업소 사원 전체 조회.
     */
    public CarOffEmpBean [] getCarOffEmpAllList(String gubun1, String gubun2, String gubun3, String gubun4, String gubun, String gu_nm, String sort_gubun, String sort, String cng_rsn) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String subQuery = "";


		if(gubun1.equals("") && gubun2.equals("") && gubun3.equals("") && gubun.equals("") && gu_nm.equals("")) subQuery = " and nvl(a.reg_dt, a.upd_dt)=to_char(sysdate,'yyyymmdd') ";
		
		if(!gu_nm.equals("")){
			if(gubun.equals("car_comp")){				subQuery = "and c.nm like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("car_off")){			subQuery = "and b.car_off_nm like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("emp_nm")){			subQuery = "and nvl(a.emp_nm,' ') like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("emp_email")){		subQuery = "and nvl(a.emp_email,' ') like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("emp_m_tel")){		subQuery = "and nvl(a.emp_m_tel,' ') like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("car_off_nm")){		subQuery = "and nvl(b.car_off_nm,' ') like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("damdang_id")){		subQuery = "and d.damdang_id ='"+ gu_nm + "' \n";
			}
		}

		if(!gubun1.equals(""))	subQuery += " and b.car_off_addr like '%" + gubun1.trim() + "%'";

		if(!gubun2.equals(""))	subQuery += " and b.car_off_addr like '%" + gubun2.trim() + "%'";
        
		if(!gubun3.equals(""))	subQuery += " and b.car_comp_id = '" + gubun3 + "'";

		if(!gubun4.equals("0"))	subQuery += " and b.car_off_st = '" + gubun4 + "'";


		if(!cng_rsn.equals("")){
			subQuery += " and d.cng_rsn ='"+ cng_rsn + "' \n";
		}

		String query = "";
        query = "select a.emp_id as EMP_ID,\n"
						+ "a.car_off_id as CAR_OFF_ID,\n" 
						+ "b.car_off_nm as CAR_OFF_NM, b.car_off_st, b.owner_nm as OWNER_NM,\n"
						+ "b.car_comp_id as CAR_COMP_ID,\n"
						+ "c.nm as CAR_COMP_NM,\n"
						+ "a.cust_st as CUST_ST,\n"
						+ "a.emp_nm as EMP_NM,\n"
						+ "a.emp_ssn as EMP_SSN,\n"
						+ "b.car_off_tel as CAR_OFF_TEL,\n"
						+ "b.car_off_fax as CAR_OFF_FAX,\n"
						+ "a.emp_m_tel as EMP_M_TEL,\n"
						+ "a.emp_pos as EMP_POS,\n"
						+ "a.emp_email as EMP_EMAIL,\n"
						+ "a.emp_bank as EMP_BANK,\n"
						+ "a.emp_acc_no as EMP_ACC_NO,\n"
						+ "a.emp_acc_nm as EMP_ACC_NM,a.emp_post as EMP_POST,a.emp_addr as EMP_ADDR, a.etc as ETC,\n"
						+ "b.car_off_post as CAR_OFF_POST, b.car_off_addr as CAR_OFF_ADDR, \n"
						+ "nvl(a.reg_dt,'-') reg_dt, a.reg_id, a.upd_dt, a.upd_id, \n"
						+ "a.emp_h_tel, a.emp_sex, a.use_yn, a.sms_denial_rsn \n"
						+ ", d.seq, d.damdang_id, d.cng_rsn, d.cng_dt "
						+ ", a.file_name1, a.file_name2, a.file_gubun1, a.file_gubun2, b.one_self_yn, a.agent_id, a.emp_dept, a.fraud_care, a.bank_cd \n"
				+ "from car_off_emp a, car_off b, code c, "
				+ "		(select emp_id, seq, damdang_id, cng_rsn, cng_dt from car_off_edh a where a.seq=(select max(seq) from car_off_edh b where a.emp_id=b.emp_id)) d "
				+ "where a.car_off_id = b.car_off_id \n"
				+ "and b.car_comp_id = c.code\n"
				+ "and c.c_st = '0001'\n"
				+ "and a.emp_id = d.emp_id(+) "
				+ subQuery;
		
		if(!sort_gubun.equals("")) query += " order by nvl(a.upd_dt,a.reg_dt) desc, "+sort_gubun+" "+sort;

		Collection<CarOffEmpBean> col = new ArrayList<CarOffEmpBean>();
        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
                
				col.add(makeCarOffEmpBean(rs));
 
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			System.out.println("[CarOfficeDatabase:getCarOffEmpAllList(String gubun, String gu_nm)]"+se);
			se.printStackTrace();
			throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (CarOffEmpBean[])col.toArray(new CarOffEmpBean[0]);
    }
    /**
     * 영업소 사원 전체 조회.
     */
    public CarOffEmpBean [] getCarOffEmpAllList2(String gubun1, String gubun2, String gubun3, String gubun4, String gubun, String gu_nm, String sort_gubun, String sort, String cng_rsn, String st_dt, String end_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String subQuery = "";


		if(gubun1.equals("") && gubun2.equals("") && gubun3.equals("") && gu_nm.equals("") && st_dt.equals("") && end_dt.equals("")) subQuery = " and nvl(a.reg_dt, a.upd_dt)=to_char(sysdate,'yyyymmdd') ";
		
		if(!gu_nm.equals("")){
			if(gubun.equals("car_comp")){				subQuery = "and c.nm like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("car_off")){			subQuery = "and b.car_off_nm like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("emp_nm")){			subQuery = "and nvl(a.emp_nm,' ') like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("emp_email")){		subQuery = "and nvl(a.emp_email,' ') like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("emp_m_tel")){		subQuery = "and nvl(a.emp_m_tel,' ') like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("car_off_nm")){		subQuery = "and nvl(b.car_off_nm,' ') like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("damdang_id")){		subQuery = "and e.user_nm like '%" + gu_nm + "%'\n";
			}
		}

		if(!gubun1.equals(""))	subQuery += " and b.car_off_addr like '%" + gubun1.trim() + "%'";

		if(!gubun2.equals(""))	subQuery += " and b.car_off_addr like '%" + gubun2.trim() + "%'";
        
		if(!gubun3.equals(""))	subQuery += " and b.car_comp_id = '" + gubun3 + "'";

		if(!gubun4.equals("0"))	subQuery += " and b.car_off_st = '" + gubun4 + "'";

		//담당자지정사유, 지정(변경)일
		if(st_dt.equals(""))	st_dt ="00000000";
		if(end_dt.equals(""))	end_dt="99999999";
		if(!cng_rsn.equals("")){
			subQuery += " and d.cng_rsn ='"+ cng_rsn + "' \n";			
		}
		if((!st_dt.equals(""))&&(!end_dt.equals(""))){
			subQuery += " and d.cng_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') ";
		}

		String query = "";
        query = "select a.emp_id as EMP_ID,\n"
						+ "a.car_off_id as CAR_OFF_ID,\n" 
						+ "b.car_off_nm as CAR_OFF_NM, b.car_off_st, b.owner_nm as OWNER_NM,\n"
						+ "b.car_comp_id as CAR_COMP_ID,\n"
						+ "c.nm as CAR_COMP_NM,\n"
						+ "a.cust_st as CUST_ST,\n"
						+ "a.emp_nm as EMP_NM,\n"
						+ "a.emp_ssn as EMP_SSN,\n"
						+ "b.car_off_tel as CAR_OFF_TEL,\n"
						+ "b.car_off_fax as CAR_OFF_FAX,\n"
						+ "a.emp_m_tel as EMP_M_TEL,\n"
						+ "a.emp_pos as EMP_POS,\n"
						+ "a.emp_email as EMP_EMAIL,\n"
						+ "a.emp_bank as EMP_BANK,\n"
						+ "a.emp_acc_no as EMP_ACC_NO,\n"
						+ "a.emp_acc_nm as EMP_ACC_NM,a.emp_post as EMP_POST,a.emp_addr as EMP_ADDR, a.etc as ETC,\n"
						+ "b.car_off_post as CAR_OFF_POST, b.car_off_addr as CAR_OFF_ADDR, \n"
						+ "nvl(a.reg_dt,'-') reg_dt, a.reg_id, a.upd_dt, a.upd_id, \n"
						+ "a.emp_h_tel, a.emp_sex, a.use_yn, a.sms_denial_rsn \n"
						+ ", d.seq, d.damdang_id, d.cng_rsn, d.cng_dt "
						+ ", a.file_name1, a.file_name2, a.file_gubun1, a.file_gubun2, b.one_self_yn, a.agent_id, a.emp_dept, a.fraud_care, a.bank_cd \n"
				+ "from car_off_emp a, car_off b, code c, users e, "
				+ "		(select emp_id, seq, damdang_id, cng_rsn, cng_dt from car_off_edh a where a.seq=(select max(seq) from car_off_edh b where a.emp_id=b.emp_id)) d "
				+ "where a.car_off_id = b.car_off_id \n"
				+ "and b.car_comp_id = c.code\n"
				+ "and c.c_st = '0001'\n"
				+ "and d.damdang_id = e.user_id(+) \n"
				+ "and a.emp_id = d.emp_id(+) "
				+ subQuery;
		
		if(!sort_gubun.equals("") && sort_gubun.equals("damdang_id")){	 
			query += " order by "+sort_gubun+" "+sort;
		}else{
			query += " order by nvl(a.upd_dt,a.reg_dt) desc";
			if(!sort_gubun.equals(""))	query += ", "+sort_gubun+" "+sort;
		}

		Collection<CarOffEmpBean> col = new ArrayList<CarOffEmpBean>();
        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
                
				col.add(makeCarOffEmpBean(rs));
 
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			System.out.println("[CarOfficeDatabase:getCarOffEmpAllList2(String gubun, String gu_nm)]"+se);
			System.out.println("[CarOfficeDatabase:getCarOffEmpAllList2(String gubun, String gu_nm)]"+query);
			se.printStackTrace();
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (CarOffEmpBean[])col.toArray(new CarOffEmpBean[0]);
    }

	/**
     * 발송구분 최대값 20050721.목
     */
    public int getMax_gubun() throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
		int max_result = 0;
        
        String query = " select max(to_number(gubun)) from car_off_emp ";
        
        try{
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery(query);
			while(rs.next()){
				max_result = rs.getInt(1);
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
        return max_result;
    }

    /**
     * 영업소 사원 전체 조회. 20050720.
     */
    public Vector getCarOffEmpAll(String cc_id, String[] sido, String[] gugun, String[] send_gubun, String commi_yn, String cng_rsn, String user_id) 
		throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String subQuery = "", subQuery2="", subQuery3="", subQuery4="", subQuery5="", subQuery6="";
		String query = "";
		Vector vt = new Vector();

		//자동차회사
		if(!cc_id.equals(""))	subQuery = " and b.car_comp_id like '%"+cc_id+"%' ";
		//시,도
		if(sido!=null && sido.length>0 && !sido[0].equals("")){
			subQuery2 = " and substr(b.car_off_post,1,1) in ('";
			for(int i=0 ; i<sido.length ; i++){
				if(i == (sido.length -1))	subQuery2 += sido[i]; 
				else						subQuery2 += sido[i]+"', '";
			}
			subQuery2 += "') ";
		}
		//구,군
		if(gugun!=null && gugun.length>0 && !gugun[0].equals("")){
			subQuery3 = " and substr(b.car_off_post,1,3) in ('";
			for(int i=0 ; i<gugun.length ; i++){
				if(i == (gugun.length -1))	subQuery3 += gugun[i]; 
				else						subQuery3 += gugun[i]+"', '";
			}
			subQuery3 += "') ";
		}
		//발송구분
		if(send_gubun!=null && send_gubun.length>0 && !send_gubun[0].equals("")){
			subQuery4 = " and a.gubun in ('";
			for(int i=0 ; i<send_gubun.length ; i++){
				if(i == (send_gubun.length -1))	subQuery4 += send_gubun[i]; 
				else							subQuery4 += send_gubun[i]+"', '";
			}
			subQuery4 += "') ";
		}
		//지정사유
		if(!cng_rsn.equals(""))		subQuery4 += " and e.cng_rsn = '"+cng_rsn+"' ";

		//거래유무
		if(commi_yn.equals("Y"))		subQuery5 = " and d.cnt > 0 ";
		else if(commi_yn.equals("N"))	subQuery5 = " and nvl(d.cnt,0) = 0 ";

		//담당자
		if(!user_id.equals(""))			subQuery6 = " and nvl(e.damdang_id, a.reg_id) = '"+user_id+"' ";

		//처음시작시
		//if(cc_id.equals("") && sido==null && gugun==null)	subQuery += "  ";

		query = "SELECT a.emp_id, c.code, c.nm CAR_COMP_NM, b.car_off_post, "+
				" substr(car_off_addr,1,instr(car_off_addr,' '))|| substr(car_off_addr,instr(car_off_addr,' ')+1,instr(substr(car_off_addr,instr(car_off_addr,' ')+1),' ')) addr, "+
				"	   b.car_off_nm, a.emp_nm, a.emp_m_tel, a.gubun, e.cng_rsn, nvl(d.cnt,0) commi_cnt "+
				" FROM car_off_emp a, car_off b, code c, (SELECT emp_id, count(*) cnt FROM commi group by emp_id) d, "+
				"		(select emp_id, seq, damdang_id, cng_rsn from car_off_edh a where a.seq=(select max(seq) from car_off_edh b where a.emp_id=b.emp_id)) e "+
				" WHERE a.car_off_id = b.car_off_id  "+
				" and b.car_comp_id = c.code "+
				" and c.c_st = '0001'  and nvl(a.use_yn,'Y')='Y' "+
				" and a.emp_id = d.emp_id(+) "+
				" and a.emp_id = e.emp_id(+) "+
				subQuery+
				subQuery2+
				subQuery3+
				subQuery4+
				subQuery5+
				subQuery6+
				" order by 1,3,5 ";

        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
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
            stmt.close();
        }catch(SQLException se){
			System.out.println("[CarOfficeDatabase:getCarOffEmpAll(String gubun, String gu_nm)]"+se);
			System.out.println("[CarOfficeDatabase:getCarOffEmpAll(String gubun, String gu_nm)]"+query);
			se.printStackTrace();
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

    /**
     * 영업소 사원 휴대폰 중복건 조회. 20050720.
     */
    public Vector checkEmpDouble(String cc_id, String[] sido, String[] gugun, String[] send_gubun, String commi_yn, String user_id) 
		throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String subQuery = "", subQuery2="", subQuery3="", subQuery4="", subQuery5="", subQuery6="";
		String query = "";
		Vector vt = new Vector();

		//자동차회사
		if(!cc_id.equals(""))	subQuery = " and b.car_comp_id like '%"+cc_id+"%' ";
		//시,도
		if(sido!=null && sido.length>0 && !sido[0].equals("")){
			subQuery2 = " and substr(b.car_off_post,1,1) in ('";
			for(int i=0 ; i<sido.length ; i++){
				if(i == (sido.length -1))	subQuery2 += sido[i]; 
				else						subQuery2 += sido[i]+"', '";
			}
			subQuery2 += "') ";
		}
		//구,군
		if(gugun!=null && gugun.length>0 && !gugun[0].equals("")){
			subQuery3 = " and substr(b.car_off_post,1,3) in ('";
			for(int i=0 ; i<gugun.length ; i++){
				if(i == (gugun.length -1))	subQuery3 += gugun[i]; 
				else						subQuery3 += gugun[i]+"', '";
			}
			subQuery3 += "') ";
		}
		//발송구분
		if(send_gubun!=null && send_gubun.length>0 && !send_gubun[0].equals("")){
			subQuery4 = " and a.gubun in ('";
			for(int i=0 ; i<send_gubun.length ; i++){
				if(i == (send_gubun.length -1))	subQuery4 += send_gubun[i]; 
				else							subQuery4 += send_gubun[i]+"', '";
			}
			subQuery4 += "') ";
		}
		//거래유무
		if(commi_yn.equals("Y"))		subQuery5 = " and d.cnt > 0 ";
		else if(commi_yn.equals("N"))	subQuery5 = " and nvl(d.cnt,0) = 0 ";

		//담당자
		if(!user_id.equals(""))			subQuery6 = " and nvl(a.upd_id, a.reg_id) = '"+user_id+"' ";

		//처음시작시
		//if(cc_id.equals("") && sido==null && gugun==null)	subQuery += "  ";

		query = "SELECT a.emp_id, a.code, a.car_comp_nm, a.car_off_post, a.addr, a.car_off_nm, a.emp_nm, a.emp_m_tel, a.gubun, a.commi_cnt, b.cnt "+
			" FROM	(SELECT a.emp_id, c.code, c.nm CAR_COMP_NM, b.car_off_post, "+
				"			substr(car_off_addr,1,instr(car_off_addr,' '))|| substr(car_off_addr,instr(car_off_addr,' ')+1,instr(substr(car_off_addr,instr(car_off_addr,' ')+1),' ')) addr, "+
				"			   b.car_off_nm, a.emp_nm, a.emp_m_tel, a.gubun, nvl(d.cnt,0) commi_cnt "+
				"		FROM car_off_emp a, car_off b, code c, (SELECT emp_id, count(*) cnt FROM commi group by emp_id) d "+
				"		WHERE a.car_off_id = b.car_off_id  "+
				"		and b.car_comp_id = c.code "+
				"		and c.c_st = '0001' and nvl(a.use_yn,'Y')='Y' "+
				"		and a.emp_id = d.emp_id(+) "+
						subQuery+
						subQuery2+
						subQuery3+
						subQuery4+
						subQuery5+
						subQuery6+
				"		) a, "+
				"		(SELECT emp_m_tel, count(*) cnt "+
				"		FROM (SELECT a.emp_id, c.code, c.nm CAR_COMP_NM, b.car_off_post, "+
				"					substr(car_off_addr,1,instr(car_off_addr,' '))|| substr(car_off_addr,instr(car_off_addr,' ')+1,instr(substr(car_off_addr,instr(car_off_addr,' ')+1),' ')) addr, "+
				"					   b.car_off_nm, a.emp_nm, a.emp_m_tel, a.gubun, nvl(d.cnt,0) commi_cnt "+
				"				FROM car_off_emp a, car_off b, code c, (SELECT emp_id, count(*) cnt FROM commi group by emp_id) d "+
				"				WHERE a.car_off_id = b.car_off_id  "+
				"				and b.car_comp_id = c.code "+
				"				and c.c_st = '0001' and nvl(a.use_yn,'Y')='Y' "+
				"				and a.emp_id = d.emp_id(+) "+
								subQuery+
								subQuery2+
								subQuery3+
								subQuery4+
								subQuery5+
								subQuery6+
				"			  ) "+	
				"		GROUP BY emp_m_tel "+
				"		) b "+
				" WHERE a.emp_m_tel = b.emp_m_tel and b.cnt>1 "+
				" order by emp_m_tel ";

        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
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
            stmt.close();
        }catch(SQLException se){
			System.out.println("[CarOfficeDatabase:checkEmpDouble(String gubun, String gu_nm)]"+se);
			se.printStackTrace();
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }
    /**
     * 영업소 사원 핸드폰 번호 오류건 조회. 20050722.
     */
    public Vector checkEmpNum(String cc_id, String[] sido, String[] gugun, String[] send_gubun, String commi_yn, String user_id) 
		throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String subQuery = "", subQuery2="", subQuery3="", subQuery4="", subQuery5="", subQuery6="";
		String query = "";
		Vector vt = new Vector();

		//자동차회사
		if(!cc_id.equals(""))	subQuery = " and b.car_comp_id like '%"+cc_id+"%' ";
		//시,도
		if(sido!=null && sido.length>0 && !sido[0].equals("")){
			subQuery2 = " and substr(b.car_off_post,1,1) in ('";
			for(int i=0 ; i<sido.length ; i++){
				if(i == (sido.length -1))	subQuery2 += sido[i]; 
				else						subQuery2 += sido[i]+"', '";
			}
			subQuery2 += "') ";
		}
		//구,군
		if(gugun!=null && gugun.length>0 && !gugun[0].equals("")){
			subQuery3 = " and substr(b.car_off_post,1,3) in ('";
			for(int i=0 ; i<gugun.length ; i++){
				if(i == (gugun.length -1))	subQuery3 += gugun[i]; 
				else						subQuery3 += gugun[i]+"', '";
			}
			subQuery3 += "') ";
		}
		//발송구분
		if(send_gubun!=null && send_gubun.length>0 && !send_gubun[0].equals("")){
			subQuery4 = " and a.gubun in ('";
			for(int i=0 ; i<send_gubun.length ; i++){
				if(i == (send_gubun.length -1))	subQuery4 += send_gubun[i]; 
				else							subQuery4 += send_gubun[i]+"', '";
			}
			subQuery4 += "') ";
		}
		//거래유무
		if(commi_yn.equals("Y"))		subQuery5 = " and d.cnt > 0 ";
		else if(commi_yn.equals("N"))	subQuery5 = " and nvl(d.cnt,0) = 0 ";

		//담당자
		if(!user_id.equals(""))			subQuery6 = " and nvl(a.upd_id, a.reg_id) = '"+user_id+"' ";

		//처음시작시
		//if(cc_id.equals("") && sido==null && gugun==null)	subQuery += "  ";

		query = "SELECT a.emp_id, c.code, c.nm CAR_COMP_NM, b.car_off_post, "+
				"			substr(car_off_addr,1,instr(car_off_addr,' '))|| substr(car_off_addr,instr(car_off_addr,' ')+1,instr(substr(car_off_addr,instr(car_off_addr,' ')+1),' ')) addr, "+
				"			   b.car_off_nm, a.emp_nm, a.emp_m_tel, a.gubun, nvl(d.cnt,0) commi_cnt "+
				"		FROM car_off_emp a, car_off b, code c, (SELECT emp_id, count(*) cnt FROM commi group by emp_id) d "+
				"		WHERE a.car_off_id = b.car_off_id  "+
				"		and b.car_comp_id = c.code "+
				"		and c.c_st = '0001' and nvl(a.use_yn,'Y')='Y' "+
				"		and a.emp_id = d.emp_id(+) "+
						subQuery+
						subQuery2+
						subQuery3+
						subQuery4+
						subQuery5+
						subQuery6+
				"		and length(emp_m_tel)<10 "+
				" order by 2,6,9 ";

        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
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
            stmt.close();
        }catch(SQLException se){
			System.out.println("[CarOfficeDatabase:checkEmpDouble(String gubun, String gu_nm)]"+se);
			se.printStackTrace();
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

    /**
     * 영업사원(1), 개별(2) 조회. 20050722.금
     */
    public Vector getCarOffEmpAll2(String gubun, String gu_nm, String sort_gubun, String sort, String[] send_gubun, String commi_yn) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String subQuery = "", subQuery4="", subQuery5="";
		String query = "";
		Vector vt = new Vector();

		if(!gu_nm.equals("")){
			if(gubun.equals("car_comp")){
				subQuery = "and c.nm like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("car_off")){
				subQuery = "and b.car_off_nm like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("emp_nm")){
				subQuery = "and nvl(a.emp_nm,' ') like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("emp_email")){
				subQuery = "and nvl(a.emp_email,' ') like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("emp_m_tel")){
				subQuery = "and nvl(a.emp_m_tel,' ') like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("car_off_nm")){
				subQuery = "and nvl(b.car_off_nm,' ') like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("reg_id")){
				subQuery = "and a.reg_id ='"+ gu_nm + "' \n";
			}else if(gubun.equals("upd_id")){
				subQuery = "and a.upd_id ='"+ gu_nm + "' \n";
			}else{
				subQuery = "";
			}
		}
/*		//발송구분
		if(send_gubun!=null && send_gubun.length>0 && !send_gubun[0].equals("")){
			subQuery4 = " and a.gubun in ('";
			for(int i=0 ; i<send_gubun.length ; i++){
				if(i == (send_gubun.length -1))	subQuery4 += send_gubun[i]; 
				else							subQuery4 += send_gubun[i]+"', '";
			}
			subQuery4 += "') ";
		}
		//거래유무
		if(commi_yn.equals("Y"))		subQuery5 = " and d.cnt > 0 ";
		else if(commi_yn.equals("N"))	subQuery5 = " and nvl(d.cnt,0) = 0 ";
*/
		query = "SELECT a.emp_id, c.code, c.nm CAR_COMP_NM, b.car_off_post, "+
				" substr(car_off_addr,1,instr(car_off_addr,' '))|| substr(car_off_addr,instr(car_off_addr,' ')+1,instr(substr(car_off_addr,instr(car_off_addr,' ')+1),' ')) addr, "+
				"	   b.car_off_nm, a.emp_nm, a.emp_m_tel, a.gubun, e.cng_rsn, nvl(d.cnt,0) commi_cnt "+
				" FROM car_off_emp a, car_off b, code c, (SELECT emp_id, count(*) cnt FROM commi group by emp_id) d, "+
				"		(select emp_id, seq, damdang_id, cng_rsn from car_off_edh a where a.seq=(select max(seq) from car_off_edh b where a.emp_id=b.emp_id)) e "+
				" WHERE a.car_off_id = b.car_off_id  "+
				" and b.car_comp_id = c.code "+
				" and c.c_st = '0001' and nvl(a.use_yn,'Y')='Y' "+
				" and a.emp_id = d.emp_id(+) "+
				" and a.emp_id = e.emp_id(+) "+
				subQuery+
				subQuery4+
				subQuery5+
				" order by 1,3,5 ";

        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
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
            stmt.close();
        }catch(SQLException se){
			System.out.println("[CarOfficeDatabase:getCarOffEmpAll2(String gubun, String gu_nm)]"+se);
			se.printStackTrace();
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }
    /**
     * 영업사원(1), 개별(2) 조회. 20050722.금
     */
    public Vector getCarOffEmpAll_20090702(String gubun, String gu_nm, String sort_gubun, String sort, String[] send_gubun, String commi_yn, String cng_rsn, String st_dt, String end_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String subQuery = "", subQuery4="", subQuery5="";
		String query = "";
		Vector vt = new Vector();

		if(!gu_nm.equals("")){
			if(gubun.equals("car_comp")){
				subQuery = "and c.nm like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("car_off")){
				subQuery = "and b.car_off_nm like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("emp_nm")){
				subQuery = "and nvl(a.emp_nm,' ') like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("emp_email")){
				subQuery = "and nvl(a.emp_email,' ') like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("emp_m_tel")){
				subQuery = "and nvl(a.emp_m_tel,' ') like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("car_off_nm")){
				subQuery = "and nvl(b.car_off_nm,' ') like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("reg_id")){
				subQuery = "and a.reg_id ='"+ gu_nm + "' \n";
			}else if(gubun.equals("upd_id")){
				//subQuery = "and a.upd_id ='"+ gu_nm + "' \n";
				subQuery = "and e.damdang_id ='"+ gu_nm + "' \n";
			}else{
				subQuery = "";
			}
		}

		/*
		//발송구분
		if(send_gubun!=null && send_gubun.length>0 && !send_gubun[0].equals("")){
			subQuery4 = " and a.gubun in ('";
			for(int i=0 ; i<send_gubun.length ; i++){
				if(i == (send_gubun.length -1))	subQuery4 += send_gubun[i]; 
				else							subQuery4 += send_gubun[i]+"', '";
			}
			subQuery4 += "') ";
		}*/

		//담당자지정사유, 지정(변경)일
		if(st_dt.equals(""))	st_dt ="00000000";
		if(end_dt.equals(""))	end_dt="99999999";
		if(!cng_rsn.equals("")){
			subQuery += " and e.cng_rsn ='"+ cng_rsn + "' \n";			
		}
		if((!st_dt.equals(""))&&(!end_dt.equals(""))){
			subQuery += " and e.cng_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') ";
		}

		//거래유무
		if(commi_yn.equals("Y"))		subQuery5 = " and nvl(d.cnt,0) > 0 ";
		else if(commi_yn.equals("N"))	subQuery5 = " and nvl(d.cnt,0) = 0 ";

		query = "SELECT a.emp_id, c.code, c.nm CAR_COMP_NM, b.car_off_post, "+
				"       substr(car_off_addr,1,instr(car_off_addr,' '))|| substr(car_off_addr,instr(car_off_addr,' ')+1,instr(substr(car_off_addr,instr(car_off_addr,' ')+1),' ')) addr, "+
				"	    b.car_off_nm, a.emp_nm, a.emp_m_tel, a.gubun, e.cng_rsn, nvl(d.cnt,0) commi_cnt "+
				" FROM  car_off_emp a, car_off b, code c, "+
			    "       (SELECT emp_id, count(*) cnt FROM commi group by emp_id) d, "+
				"		(select emp_id, seq, damdang_id, cng_rsn, cng_dt from car_off_edh a where a.seq=(select max(seq) from car_off_edh b where a.emp_id=b.emp_id)) e "+
				" WHERE a.car_off_id = b.car_off_id  "+
				"       and b.car_comp_id = c.code "+
				"       and c.c_st = '0001' and nvl(a.use_yn,'Y')='Y' "+
				"       and a.emp_id = d.emp_id(+) "+
				"       and a.emp_id = e.emp_id(+) "+
				subQuery+
				subQuery4+
				subQuery5+
				" order by 1,3,5 ";

        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
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
            stmt.close();
        }catch(SQLException se){
			System.out.println("[CarOfficeDatabase:getCarOffEmpAll_20090702(String gubun, String gu_nm)]"+se);
			se.printStackTrace();
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

    /**
     * 영업사원(1), 개별(2) 중복체크 조회. - 20050725.
     */
    public Vector checkEmpDouble2(String gubun, String gu_nm, String sort_gubun, String sort) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String subQuery = "";
		String query = "";
		Vector vt = new Vector();

		if(!gu_nm.equals("")){
			if(gubun.equals("car_comp")){
				subQuery = "and c.nm like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("car_off")){
				subQuery = "and b.car_off_nm like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("emp_nm")){
				subQuery = "and nvl(a.emp_nm,' ') like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("emp_email")){
				subQuery = "and nvl(a.emp_email,' ') like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("emp_m_tel")){
				subQuery = "and nvl(a.emp_m_tel,' ') like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("car_off_nm")){
				subQuery = "and nvl(b.car_off_nm,' ') like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("reg_id")){
				subQuery = "and a.reg_id ='"+ gu_nm + "' \n";
			}else if(gubun.equals("upd_id")){
				subQuery = "and a.upd_id ='"+ gu_nm + "' \n";
			}else{
				subQuery = "";
			}
		}

		query = "SELECT a.emp_id, a.code, a.car_comp_nm, a.car_off_post, a.addr, a.car_off_nm, a.emp_nm, a.emp_m_tel, a.gubun, a.commi_cnt, b.cnt "+
				"FROM (SELECT a.emp_id, c.code, c.nm CAR_COMP_NM, b.car_off_post, "+
				"			substr(car_off_addr,1,instr(car_off_addr,' '))|| substr(car_off_addr,instr(car_off_addr,' ')+1,instr(substr(car_off_addr,instr(car_off_addr,' ')+1),' ')) addr, "+
				"			b.car_off_nm, a.emp_nm, a.emp_m_tel, a.gubun, nvl(d.cnt,0) commi_cnt "+
				"		FROM car_off_emp a, car_off b, code c, (SELECT emp_id, count(*) cnt FROM commi group by emp_id) d "+
				"		WHERE a.car_off_id = b.car_off_id  "+
				"		and b.car_comp_id = c.code "+
				"		and c.c_st = '0001' and nvl(a.use_yn,'Y')='Y' "+
				"		and a.emp_id = d.emp_id(+) "+
						subQuery+
				"		) a, "+
				"		(SELECT emp_m_tel, count(*) cnt "+
				"		FROM (SELECT a.emp_id, c.code, c.nm CAR_COMP_NM, b.car_off_post, "+
				"				substr(car_off_addr,1,instr(car_off_addr,' '))|| substr(car_off_addr,instr(car_off_addr,' ')+1,instr(substr(car_off_addr,instr(car_off_addr,' ')+1),' ')) addr, "+
				"				b.car_off_nm, a.emp_nm, a.emp_m_tel, a.gubun, nvl(d.cnt,0) commi_cnt "+
				"			FROM car_off_emp a, car_off b, code c, (SELECT emp_id, count(*) cnt FROM commi group by emp_id) d "+
				"			WHERE a.car_off_id = b.car_off_id  "+
				"			and b.car_comp_id = c.code "+
				"			and c.c_st = '0001' and nvl(a.use_yn,'Y')='Y' "+
				"			and a.emp_id = d.emp_id(+) "+
							subQuery+
				"			) "+
				"		GROUP BY emp_m_tel "+
				"		) b "+
				" WHERE a.emp_m_tel = b.emp_m_tel and b.cnt>1 "+
				" order by emp_m_tel ";

        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
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
            stmt.close();
        }catch(SQLException se){
			System.out.println("[CarOfficeDatabase:getCarOffEmpAll2(String gubun, String gu_nm)]"+se);
			se.printStackTrace();
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

    /**
     * 영업사원(1), 개별(2) 중복체크 조회. - 20050725.
     */
    public Vector checkEmpDouble_20090702(String gubun, String gu_nm, String sort_gubun, String sort, String commi_yn, String cng_rsn, String st_dt, String end_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String subQuery = "";
		String query = "";
		Vector vt = new Vector();

		if(!gu_nm.equals("")){
			if(gubun.equals("car_comp")){
				subQuery = "and c.nm like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("car_off")){
				subQuery = "and b.car_off_nm like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("emp_nm")){
				subQuery = "and nvl(a.emp_nm,' ') like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("emp_email")){
				subQuery = "and nvl(a.emp_email,' ') like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("emp_m_tel")){
				subQuery = "and nvl(a.emp_m_tel,' ') like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("car_off_nm")){
				subQuery = "and nvl(b.car_off_nm,' ') like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("reg_id")){
				subQuery = "and a.reg_id ='"+ gu_nm + "' \n";
			}else if(gubun.equals("upd_id")){
				subQuery = "and e.damdang_id ='"+ gu_nm + "' \n";
			}else{
				subQuery = "";
			}
		}

		//담당자지정사유, 지정(변경)일
		if(st_dt.equals(""))	st_dt ="00000000";
		if(end_dt.equals(""))	end_dt="99999999";
		if(!cng_rsn.equals("")){
			subQuery += " and e.cng_rsn ='"+ cng_rsn + "' \n";			
		}
		if((!st_dt.equals(""))&&(!end_dt.equals(""))){
			subQuery += " and e.cng_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') ";
		}

		//거래유무
		if(commi_yn.equals("Y"))		subQuery += " and nvl(d.cnt,0) > 0 ";
		else if(commi_yn.equals("N"))	subQuery += " and nvl(d.cnt,0) = 0 ";

		query = "SELECT a.emp_id, a.code, a.car_comp_nm, a.car_off_post, a.addr, a.car_off_nm, a.emp_nm, a.emp_m_tel, a.gubun, a.commi_cnt, b.cnt "+
				"FROM (SELECT a.emp_id, c.code, c.nm CAR_COMP_NM, b.car_off_post, "+
				"			  substr(car_off_addr,1,instr(car_off_addr,' '))|| substr(car_off_addr,instr(car_off_addr,' ')+1,instr(substr(car_off_addr,instr(car_off_addr,' ')+1),' ')) addr, "+
				"			  b.car_off_nm, a.emp_nm, a.emp_m_tel, a.gubun, nvl(d.cnt,0) commi_cnt "+
				"	   FROM   car_off_emp a, car_off b, code c, (SELECT emp_id, count(*) cnt FROM commi group by emp_id) d, "+
				"		      (select emp_id, seq, damdang_id, cng_rsn, cng_dt from car_off_edh a where a.seq=(select max(seq) from car_off_edh b where a.emp_id=b.emp_id)) e "+
				"	   WHERE  a.car_off_id = b.car_off_id  "+
				"		      and b.car_comp_id = c.code "+
				"		      and c.c_st = '0001' and nvl(a.use_yn,'Y')='Y' "+
				"		      and a.emp_id = d.emp_id(+) "+
				"             and a.emp_id = e.emp_id(+) "+
						      subQuery+
				"	  ) a, "+
				"	  (SELECT emp_m_tel, count(*) cnt "+
				"	   FROM (SELECT a.emp_id, c.code, c.nm CAR_COMP_NM, b.car_off_post, "+
				"				    substr(car_off_addr,1,instr(car_off_addr,' '))|| substr(car_off_addr,instr(car_off_addr,' ')+1,instr(substr(car_off_addr,instr(car_off_addr,' ')+1),' ')) addr, "+
				"				    b.car_off_nm, a.emp_nm, a.emp_m_tel, a.gubun, nvl(d.cnt,0) commi_cnt "+
				"			 FROM   car_off_emp a, car_off b, code c, (SELECT emp_id, count(*) cnt FROM commi group by emp_id) d, "+
				"		            (select emp_id, seq, damdang_id, cng_rsn, cng_dt from car_off_edh a where a.seq=(select max(seq) from car_off_edh b where a.emp_id=b.emp_id)) e "+
				"			 WHERE a.car_off_id = b.car_off_id  "+
				"			       and b.car_comp_id = c.code "+
				"			       and c.c_st = '0001' and nvl(a.use_yn,'Y')='Y' "+
				"			       and a.emp_id = d.emp_id(+) "+
				"                  and a.emp_id = e.emp_id(+) "+
							       subQuery+
				"			) "+
				"		GROUP BY emp_m_tel "+
				"		) b "+
				" WHERE a.emp_m_tel = b.emp_m_tel and b.cnt>1 "+
				" order by emp_m_tel ";

        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
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
            stmt.close();
        }catch(SQLException se){
			System.out.println("[CarOfficeDatabase:checkEmpDouble_20090702(String gubun, String gu_nm)]"+se);
			se.printStackTrace();
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

    /**
     * 영업사원(1), 개별(2) 번호오류체크. 20050725.금
     */
    public Vector checkEmpNum2(String gubun, String gu_nm, String sort_gubun, String sort) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String subQuery = "";
		String query = "";
		Vector vt = new Vector();

		if(!gu_nm.equals("")){
			if(gubun.equals("car_comp")){
				subQuery = "and c.nm like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("car_off")){
				subQuery = "and b.car_off_nm like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("emp_nm")){
				subQuery = "and nvl(a.emp_nm,' ') like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("emp_email")){
				subQuery = "and nvl(a.emp_email,' ') like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("emp_m_tel")){
				subQuery = "and nvl(a.emp_m_tel,' ') like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("car_off_nm")){
				subQuery = "and nvl(b.car_off_nm,' ') like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("reg_id")){
				subQuery = "and a.reg_id ='"+ gu_nm + "' \n";
			}else if(gubun.equals("upd_id")){
				subQuery = "and a.upd_id ='"+ gu_nm + "' \n";
			}else{
				subQuery = "";
			}
		}

		query = "SELECT a.emp_id, c.code, c.nm CAR_COMP_NM, b.car_off_post, "+
				" substr(car_off_addr,1,instr(car_off_addr,' '))|| substr(car_off_addr,instr(car_off_addr,' ')+1,instr(substr(car_off_addr,instr(car_off_addr,' ')+1),' ')) addr, "+
				"	   b.car_off_nm, a.emp_nm, a.emp_m_tel, a.gubun, nvl(d.cnt,0) commi_cnt "+
				" FROM car_off_emp a, car_off b, code c, (SELECT emp_id, count(*) cnt FROM commi group by emp_id) d "+
				" WHERE a.car_off_id = b.car_off_id  "+
				" and b.car_comp_id = c.code "+
				" and c.c_st = '0001' and nvl(a.use_yn,'Y')='Y' "+
				" and a.emp_id = d.emp_id(+) "+
				subQuery+
				" and length(emp_m_tel)<10 "+
				" order by 1,3,5 ";

        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
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
            stmt.close();
        }catch(SQLException se){
			System.out.println("[CarOfficeDatabase:getCarOffEmpAll2(String gubun, String gu_nm)]"+se);
			se.printStackTrace();
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

    /**
     * 영업사원(1), 개별(2) 번호오류체크. 20050725.금
     */
    public Vector checkEmpNum_20090702(String gubun, String gu_nm, String sort_gubun, String sort, String commi_yn, String cng_rsn, String st_dt, String end_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String subQuery = "";
		String query = "";
		Vector vt = new Vector();

		if(!gu_nm.equals("")){
			if(gubun.equals("car_comp")){
				subQuery = "and c.nm like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("car_off")){
				subQuery = "and b.car_off_nm like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("emp_nm")){
				subQuery = "and nvl(a.emp_nm,' ') like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("emp_email")){
				subQuery = "and nvl(a.emp_email,' ') like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("emp_m_tel")){
				subQuery = "and nvl(a.emp_m_tel,' ') like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("car_off_nm")){
				subQuery = "and nvl(b.car_off_nm,' ') like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("reg_id")){
				subQuery = "and a.reg_id ='"+ gu_nm + "' \n";
			}else if(gubun.equals("upd_id")){
				subQuery = "and e.damdang_id ='"+ gu_nm + "' \n";
			}else{
				subQuery = "";
			}
		}

		//담당자지정사유, 지정(변경)일
		if(st_dt.equals(""))	st_dt ="00000000";
		if(end_dt.equals(""))	end_dt="99999999";
		if(!cng_rsn.equals("")){
			subQuery += " and e.cng_rsn ='"+ cng_rsn + "' \n";			
		}
		if((!st_dt.equals(""))&&(!end_dt.equals(""))){
			subQuery += " and e.cng_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') ";
		}

		//거래유무
		if(commi_yn.equals("Y"))		subQuery += " and nvl(d.cnt,0) > 0 ";
		else if(commi_yn.equals("N"))	subQuery += " and nvl(d.cnt,0) = 0 ";

		query = "SELECT a.emp_id, c.code, c.nm CAR_COMP_NM, b.car_off_post, "+
				" substr(car_off_addr,1,instr(car_off_addr,' '))|| substr(car_off_addr,instr(car_off_addr,' ')+1,instr(substr(car_off_addr,instr(car_off_addr,' ')+1),' ')) addr, "+
				"	   b.car_off_nm, a.emp_nm, a.emp_m_tel, a.gubun, nvl(d.cnt,0) commi_cnt "+
				" FROM car_off_emp a, car_off b, code c, (SELECT emp_id, count(*) cnt FROM commi group by emp_id) d, "+
				"		(select emp_id, seq, damdang_id, cng_rsn, cng_dt from car_off_edh a where a.seq=(select max(seq) from car_off_edh b where a.emp_id=b.emp_id)) e "+
				" WHERE a.car_off_id = b.car_off_id  "+
				"       and b.car_comp_id = c.code "+
				"       and c.c_st = '0001' and nvl(a.use_yn,'Y')='Y' "+
				"       and a.emp_id = d.emp_id(+) "+
				"       and a.emp_id = e.emp_id(+) "+
				subQuery+
				" and length(emp_m_tel)<10 "+
				" order by 1,3,5 ";

        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
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
            stmt.close();
        }catch(SQLException se){
			System.out.println("[CarOfficeDatabase:checkEmpNum_20090702(String gubun, String gu_nm)]"+se);
			se.printStackTrace();
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }


    /**
     * 당사직원(3) 조회. 20050725.금
     */
    public Vector getEmpAll(String gubun, String gu_nm, String sort_gubun, String sort) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String subQuery = "";
		String query = "";
		Vector vt = new Vector();

		if(!gu_nm.equals("")){
			if(gubun.equals("car_comp")){
				subQuery = "and c.nm like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("car_off")){
				subQuery = "and b.car_off_nm like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("emp_nm")){
				subQuery = "and nvl(a.emp_nm,' ') like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("emp_email")){
				subQuery = "and nvl(a.emp_email,' ') like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("emp_m_tel")){
				subQuery = "and nvl(a.emp_m_tel,' ') like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("car_off_nm")){
				subQuery = "and nvl(b.car_off_nm,' ') like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("reg_id")){
				subQuery = "and a.reg_id ='"+ gu_nm + "' \n";
			}else if(gubun.equals("upd_id")){
				subQuery = "and a.upd_id ='"+ gu_nm + "' \n";
			}else{
				subQuery = "";
			}
		}

		query = "SELECT a.emp_id, c.code, c.nm CAR_COMP_NM, b.car_off_post, "+
				" substr(car_off_addr,1,instr(car_off_addr,' '))|| substr(car_off_addr,instr(car_off_addr,' ')+1,instr(substr(car_off_addr,instr(car_off_addr,' ')+1),' ')) addr, "+
				"	   b.car_off_nm, a.emp_nm, a.emp_m_tel, a.gubun, nvl(d.cnt,0) commi_cnt "+
				" FROM car_off_emp a, car_off b, code c, (SELECT emp_id, count(*) cnt FROM commi group by emp_id) d "+
				" WHERE a.car_off_id = b.car_off_id  "+
				" and b.car_comp_id = c.code "+
				" and c.c_st = '0001' and nvl(a.use_yn,'Y')='Y' "+
				" and a.emp_id = d.emp_id(+) "+
				subQuery+
				" order by 1,3,5 ";

        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
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
            stmt.close();
        }catch(SQLException se){
			System.out.println("[CarOfficeDatabase:getCarOffEmpAll2(String gubun, String gu_nm)]"+se);
			se.printStackTrace();
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

    /**
     * 자동차영업소 사원 휴대폰번호 수정 20050722.금
     */
    public int updateCarOffEmp(String emp_id, String emp_m_tel) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        int count = 0;
                
        query=" UPDATE car_off_emp SET emp_m_tel = ? WHERE emp_id=? ";
            
       try{
            con.setAutoCommit(false);

            pstmt = con.prepareStatement(query);
			pstmt.setString(1, emp_m_tel);
            pstmt.setString(2, emp_id);
            count = pstmt.executeUpdate();             

			pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception: updateCarOffEmp(String emp_id, String emp_m_tel)");
        }finally{
            try{
                con.setAutoCommit(true);
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return count;
    }

    /**
     * 자동차영업소 사원 메일주소 수정
     */
    public int updateCarOffEmpMail(String emp_id, String emp_email) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        int count = 0;
                
        query=" UPDATE car_off_emp SET emp_email = ? WHERE emp_id=? ";
            
       try{
            con.setAutoCommit(false);

            pstmt = con.prepareStatement(query);
			pstmt.setString(1, emp_email);
            pstmt.setString(2, emp_id);
            count = pstmt.executeUpdate();             

			pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception: updateCarOffEmpMail(String emp_id, String emp_email)");
        }finally{
            try{
                con.setAutoCommit(true);
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return count;
    }

    /**
     * 자동차영업소 사원 소스삭제 20050722.
     */
    public int delSourceCarOffEmp(String emp_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        int count = 0;
                
        query="DELETE car_off_emp WHERE emp_id=? ";
            
       try{
            con.setAutoCommit(false);

            pstmt = con.prepareStatement(query);
            pstmt.setString(1, emp_id);           
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
			con = null;
        }

        return count;
    }
    /**
     * 자동차영업소 사원 리스트삭제(수신거부) 20050722.
     */
    public int delListCarOffEmp(String emp_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        int count = 0;
                
        query="UPDATE car_off_emp SET use_yn='N' WHERE emp_id=? ";
            
       try{
            con.setAutoCommit(false);

            pstmt = con.prepareStatement(query);
            pstmt.setString(1, emp_id);           
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
			con = null;
        }

        return count;
    }

    /**
     * 문자보내기 20050721.
     */
    public int[] sendMail(String sendphone, String sendname, String[] destphone, String[] destname, String msg, String[] pr) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int[] count = new int[2];
                
        query="INSERT INTO uds_data(serial, sendphone, sendname, destphone, destname, rqdate, status, msgtype, msg) "
            + " VALUES (uds_seq.nextval, replace(?,'-',''), ?, replace(?,'-',''), ?, '0', 0, 0, ?) ";
			
       try{
            con.setAutoCommit(false);

            pstmt = con.prepareStatement(query);
            
			for(int i=0; i<destphone.length; i++){
				if(!destphone[i].equals("")){
					for(int j=0; j<pr.length; j++){
						if(i==AddUtil.parseInt(pr[j])){
							pstmt.setString(1, sendphone);
							pstmt.setString(2, sendname);
							pstmt.setString(3, destphone[i]);
							pstmt.setString(4, destname[i]);
							pstmt.setString(5, msg);
				   
							count[0] = pstmt.executeUpdate();
							count[1] += count[0];
							
							break;

						}
					}
				}
			}
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
                con.rollback();
            }catch(SQLException _ignored){}
				se.printStackTrace();
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
     * 문자보내기 20090623
     */
    public int[] sendMail2(String sendphone, String sendname, String[] destphone, String[] destname, String msg, String[] pr, String rqdate) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int[] count = new int[2];
                
        query="INSERT INTO uds_data(serial, sendphone, sendname, destphone, destname, rqdate, status, msgtype, msg) "
            + " VALUES (uds_seq.nextval, replace(?,'-',''), ?, replace(?,'-',''), ?, to_char(sysdate"+rqdate+",'YYYYMMDDhh24miss'), 0, 0, ?) ";
			
       try{
            con.setAutoCommit(false);

            pstmt = con.prepareStatement(query);
            
			for(int i=0; i<destphone.length; i++){
				if(!destphone[i].equals("")){
					for(int j=0; j<pr.length; j++){
						if(i==AddUtil.parseInt(pr[j])){
							pstmt.setString(1, sendphone);
							pstmt.setString(2, sendname);
							pstmt.setString(3, destphone[i]);
							pstmt.setString(4, destname[i]);
							pstmt.setString(5, msg);
				   
							count[0] = pstmt.executeUpdate();
							count[1] += count[0];
							
							break;

						}
					}
				}
			}
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
                con.rollback();
            }catch(SQLException _ignored){}
				se.printStackTrace();
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

	/*
	*	문자결과(수신)  Yongsoon Kwon 20050725.
	*/
	public Vector getSmsResult2(String gubun, String dest_gubun, String rslt_dt, String st_dt, String end_dt, String dest_nm, String sort, String sort_gubun) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", subQuery="", subQuery2="";

		//발송대상구분
		if(!dest_gubun.equals(""))	subQuery += " and etc2 = '"+dest_gubun+"' ";
		//수신일자구분 1:당일, 2:전일, 3:기간, 4:당월
		if(rslt_dt.equals("1"))			subQuery2 += " and substr(rsltdate,1,8)=to_char(sysdate,'yyyymmdd') ";
		else if(rslt_dt.equals("2"))	subQuery2 += " and substr(rsltdate,1,8)=to_char(sysdate-1,'yyyymmdd') ";
		else if(rslt_dt.equals("3"))	subQuery2 += " and substr(rsltdate,1,8) between '"+st_dt+"' and '"+end_dt+"' ";
		else if(rslt_dt.equals("4"))	subQuery2 += " and substr(rsltdate,1,8) between to_char(sysdate,'yyyymm')||'01' and to_char(sysdate,'yyyymmdd') ";

		//정렬
		if(sort.equals("1"))		subQuery += " order by sendname "+sort_gubun;
		else if(sort.equals("2"))	subQuery += " order by rsltdate "+sort_gubun;
		else						subQuery += " order by rsltdate desc ";

		query = " SELECT * from uds_sms_log where destname='"+dest_nm+"'  "+subQuery2+subQuery;

		try {
			pstmt = con.prepareStatement(query);
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
			System.out.println("[CarOfficeDatabase:getSmsResult2()]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}	

	/*
	*	문자결과-(발신) Yongsoon Kwon 20050725.
	*/
	public Vector getSmsResult(String gubun, String dest_gubun, String send_dt, String st_dt, String end_dt, String s_bus, String sort, String sort_gubun) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", subQuery="", subQuery2="", subQuery3="";

		//발송대상구분
		if(!dest_gubun.equals(""))	subQuery += " and etc2 = '"+dest_gubun+"' ";
		//발송일자구분 1:당일, 2:전일, 3:기간, 4:당월
		if(send_dt.equals("1")){
			subQuery2 += " where substr(senddate,1,8)=to_char(sysdate,'yyyymmdd') ";
			subQuery3 += " where substr(senddate,1,8)=to_char(sysdate,'yyyymmdd') and ";
		}else if(send_dt.equals("2")){
			subQuery2 += " where substr(senddate,1,8)=to_char(sysdate-1,'yyyymmdd') ";
			subQuery3 += " where substr(senddate,1,8)=to_char(sysdate-1,'yyyymmdd') and ";
		}else if(send_dt.equals("3")){
			subQuery2 += " where substr(senddate,1,8) between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') ";
			subQuery3 += " where substr(senddate,1,8) between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') and ";
		}else if(send_dt.equals("4")){
			subQuery2 += " where substr(senddate,1,8) between to_char(sysdate,'yyyymm')||'01' and to_char(sysdate,'yyyymmdd') ";
			subQuery3 += " where substr(senddate,1,8) between to_char(sysdate,'yyyymm')||'01' and to_char(sysdate,'yyyymmdd') and ";
		}else{
			subQuery2 += " ";
			subQuery3 += " where ";
		}
		//발신자
		if(!s_bus.equals(""))	subQuery += " and sendname ='"+s_bus+"' ";
		//정렬
		if(sort.equals("1"))		subQuery += " order by sendname "+sort_gubun;
		else if(sort.equals("2"))	subQuery += " order by cnt "+sort_gubun;
		else if(sort.equals("3"))	subQuery += " order by r_cnt "+sort_gubun;
		else if(sort.equals("4"))	subQuery += " order by senddate "+sort_gubun;
		else						subQuery += " order by senddate desc ";

		query = 
" select nvl(d.user_nm,a.sendname) sendname, b.cnt, c.cnt R_CNT, b.msg, a.senddate "+
" from uds_sms_log a, "+
" 	(select min(serial) serial, msg, count(*) cnt  "+
" 	 from uds_sms_log "+subQuery2+
" 	 group by msg ) b, "+
" 	(select min(serial) serial, msg, count(*) cnt  "+
" 	 from uds_sms_log "+subQuery3+" rslt=0 "+
" 	 group by msg ) c, users d   "+
" where a.msg = b.msg "+
" and a.serial = b.serial "+
" and a.msg = c.msg "+
" and a.serial = c.serial  "+
" and a.sendname=d.user_id(+)"+
subQuery;

 	
		try {
			pstmt = con.prepareStatement(query);
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
			System.out.println("[CarOfficeDatabase:getSmsResult()]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}
	/*
	*	문자결과-(발신)
	*/
	public Vector getSmsResult_20090507(String gubun, String dest_gubun, String send_dt, String st_dt, String end_dt, String s_bus, String sort, String sort_gubun, String s_bus_nm) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", subQuery="", subQuery2="", subQuery3="";

		//발송대상구분
		if(!dest_gubun.equals(""))	subQuery += " and etc2 = '"+dest_gubun+"' ";
		//발송일자구분 1:당일, 2:전일, 3:기간, 4:당월
		if(send_dt.equals("1")){
			subQuery2 += " where substr(senddate,1,8)=to_char(sysdate,'yyyymmdd') ";
			subQuery3 += " where substr(senddate,1,8)=to_char(sysdate,'yyyymmdd') and ";
		}else if(send_dt.equals("2")){
			subQuery2 += " where substr(senddate,1,8)=to_char(sysdate-1,'yyyymmdd') ";
			subQuery3 += " where substr(senddate,1,8)=to_char(sysdate-1,'yyyymmdd') and ";
		}else if(send_dt.equals("3")){
			subQuery2 += " where substr(senddate,1,8) between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') ";
			subQuery3 += " where substr(senddate,1,8) between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') and ";
		}else if(send_dt.equals("4")){
			subQuery2 += " where substr(senddate,1,8) between to_char(sysdate,'yyyymm')||'01' and to_char(sysdate,'yyyymmdd') ";
			subQuery3 += " where substr(senddate,1,8) between to_char(sysdate,'yyyymm')||'01' and to_char(sysdate,'yyyymmdd') and ";
		}else{
			subQuery2 += " ";
			subQuery3 += " where ";
		}
		//발신자
		if(!s_bus.equals(""))	subQuery += " and (sendname ='"+s_bus+"' or sendname like '%"+s_bus_nm+"%')";
		//정렬
		if(sort.equals("1"))		subQuery += " order by sendname "+sort_gubun;
		else if(sort.equals("2"))	subQuery += " order by cnt "+sort_gubun;
		else if(sort.equals("3"))	subQuery += " order by r_cnt "+sort_gubun;
		else if(sort.equals("4"))	subQuery += " order by senddate "+sort_gubun;
		else						subQuery += " order by senddate desc ";

		query = 
" select nvl(d.user_nm,a.sendname) sendname, b.cnt, c.cnt R_CNT, b.msg, a.senddate "+
" from uds_sms_log a, "+
" 	(select min(serial) serial, msg, count(*) cnt  "+
" 	 from uds_sms_log "+subQuery2+
" 	 group by msg ) b, "+
" 	(select min(serial) serial, msg, count(*) cnt  "+
" 	 from uds_sms_log "+subQuery3+" rslt=0 "+
" 	 group by msg ) c, users d   "+
" where a.msg = b.msg "+
" and a.serial = b.serial "+
" and a.msg = c.msg "+
" and a.serial = c.serial  "+
" and a.sendname=d.user_id(+)"+
subQuery;

 	
		try {
			pstmt = con.prepareStatement(query);
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
			System.out.println("[CarOfficeDatabase:getSmsResult_20090507()]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}	
	
	/*
	*	문자결과-메세지별 발송건수  Yongsoon Kwon 20050725.
	*/
	public Hashtable getSmsResult2(String msg) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = 
" select a.* "+
" from uds_sms_log a, "+
" 	(select min(serial) serial, msg, count(*) cnt  "+
" 	 from uds_sms_log  "+
" 	 group by msg ) b, "+
" 	(select min(serial) serial, msg, count(*) cnt  "+
" 	 from uds_sms_log where rslt=0 "+
" 	 group by msg ) c   "+
" where a.msg = b.msg "+
" and a.serial = b.serial "+
" and a.msg = c.msg "+
" and a.serial = c.serial  "+
" and a.msg = ? ";

		try {
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, msg);
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
			System.out.println("[CarOfficeDatabase:getSmsResult2(String msg)]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return ht;
	}	

	/*
	*	문자결과-메세지별 발송건수  Yongsoon Kwon 20050725.
	*/
	public Vector getSmsResult_msg(String msg) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = 
" SELECT * "+
" from uds_sms_log a, "+
" 	 (select min(serial) serial, msg, count(*) cnt from uds_sms_log	group by msg having msg=?) b "+
" where a.msg = b.msg "+
" order by a.destname ";
 	
		try {
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, msg);
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
			System.out.println("[CarOfficeDatabase:getSmsResult_msg(String msg)]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}	

    /**
     * 영업소 사원 조회.
     */
    public CarOffEmpBean [] getCarOffEmpAll(String car_off_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";
        query = "select a.emp_id as EMP_ID,\n"
						+ "a.car_off_id as CAR_OFF_ID,\n" 
						+ "b.car_off_nm as CAR_OFF_NM, b.car_off_st, b.owner_nm as OWNER_NM,\n"
						+ "b.car_comp_id as CAR_COMP_ID,\n"
						+ "c.nm as CAR_COMP_NM,\n"
						+ "a.cust_st as CUST_ST,\n"
						+ "a.emp_nm as EMP_NM,\n"
						+ "a.emp_ssn as EMP_SSN,\n"
						+ "b.car_off_tel as CAR_OFF_TEL,\n"
						+ "b.car_off_fax as CAR_OFF_FAX,\n"
						+ "a.emp_m_tel as EMP_M_TEL,\n"
						+ "a.emp_pos as EMP_POS,\n"
						+ "a.emp_email as EMP_EMAIL,\n"
						+ "a.emp_bank as EMP_BANK,\n"
						+ "a.emp_acc_no as EMP_ACC_NO,\n"
						+ "a.emp_acc_nm as EMP_ACC_NM,a.emp_post as EMP_POST,a.emp_addr as EMP_ADDR, a.etc as ETC,\n"
						+ "b.car_off_post as CAR_OFF_POST, b.car_off_addr as CAR_OFF_ADDR, \n"
						+ "a.reg_dt, a.reg_id, a.upd_dt, a.upd_id, \n"
						+ "a.emp_h_tel, a.emp_sex, a.use_yn, a.sms_denial_rsn, '' SEQ, '' DAMDANG_ID, '' CNG_RSN, '' CNG_DT  \n"
						+ ", a.file_name1, a.file_name2, a.file_gubun1, a.file_gubun2, b.one_self_yn, a.agent_id, a.emp_dept, a.fraud_care, a.bank_cd \n"
				+ "from car_off_emp a, car_off b, code c\n"
				+ "where a.car_off_id = b.car_off_id and nvl(a.use_yn,'Y')='Y' \n"
				+ "and b.car_comp_id = c.code\n"
				+ "and c.c_st = '0001'\n"
				+ "and b.car_off_id='" + car_off_id + "'\n";

        Collection col = new ArrayList();
        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
                
				col.add(makeCarOffEmpBean(rs));
 
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			System.out.println("[CarOfficeDatabase:getCarOffEmpAll(String car_off_id)]"+se);
			System.out.println("[CarOfficeDatabase:getCarOffEmpAll(String car_off_id)]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (CarOffEmpBean[])col.toArray(new CarOffEmpBean[0]);
    }

    /**
     * 영업소 사원 방문일지 조회.
     */
    public CarOffEmpVisBean [] getCarOffEmpVisAll(String emp_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";
        query = "select a.emp_id as EMP_ID, a.seq_no as SEQ_NO, a.vis_nm as VIS_NM, substr(a.vis_dt,1,4)||'-'||substr(a.vis_dt,5,2)||'-'||substr(a.vis_dt,7,2) as VIS_DT, a.sub as SUB, a.vis_cont as VIS_CONT\n"
				+ "from vis_d a\n"
				+ "where a.emp_id='" + emp_id + "' order by seq_no \n";

        Collection col = new ArrayList();
        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
                
				col.add(makeCarOffEmpVisBean(rs));
 
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (CarOffEmpVisBean[])col.toArray(new CarOffEmpVisBean[0]);
    }
    /**
     * 영업사원 계약 전체조회.
     */
    public CommiBean [] getCommiAll(String emp_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";
        query = "select '' as CON_MON,substr(b.rent_dt,1,4)||'-'||substr(b.rent_dt,5,2)||'-'||substr(b.rent_dt,7,2) as RENT_DT,b.dlv_dt as DLV_DT,\n"
				        + "c.firm_nm as FIRM_NM,\n"
				        + "c.client_nm as CLIENT_NM,\n"
				        + "c.client_st as CLIENT_ST,\n"
				        + "h.car_nm||' '||e.car_name as CAR_NAME,\n"
				        + "f.user_nm as USER_NM,\n"
				        + "substr(g.INIT_REG_DT,1,4)||'-'||substr(g.INIT_REG_DT,5,2)||'-'||substr(g.INIT_REG_DT,7,2) as INIT_REG_DT, g.car_no as CAR_NO,\n"
        				+ "a.rent_mng_id as RENT_MNG_ID,\n" 
				        + "a.rent_l_cd as RENT_L_CD,\n"
				        + "a.emp_id as EMP_ID,\n"
				        + "a.agnt_st as AGNT_ST,\n"
				        + "a.commi as COMMI,\n"
				        + "a.inc_amt as INC_AMT,\n"
				        + "a.res_amt as RES_AMT,\n"
				        + "a.tot_amt as TOT_AMT,\n"
				        + "a.dif_amt as DIF_AMT,\n"
				        + "a.sup_dt as SUP_DT,\n"
				        + "a.rel as REL, decode(a.emp_acc_nm,i.emp_nm,'',a.emp_acc_nm) emp_acc_nm, i.emp_nm \n"
				+ "from commi a, cont b, client c, car_etc d, car_nm e, users f, car_reg g, car_mng h, car_off_emp i \n"
				+ "where a.emp_id='" + emp_id + "'\n"
				+ "and a.agnt_st = '1'\n"
				+ "and a.rent_mng_id = b.rent_mng_id\n"
				+ "and a.rent_l_cd = b.rent_l_cd\n"
				+ "and b.client_id = c.client_id\n"
				+ "and a.rent_mng_id = d.rent_mng_id(+)\n"
				+ "and a.rent_l_cd = d.rent_l_cd\n"
				+ "and d.car_id = e.car_id(+) and d.car_seq=e.car_seq(+)\n"
				+ "and b.bus_id = f.user_id\n"
				+ "and b.car_mng_id = g.car_mng_id(+)\n"
				+ "and e.car_comp_id=h.car_comp_id and e.car_cd=h.code and a.emp_id=i.emp_id ";

        Collection col = new ArrayList();
        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
                
				col.add(makeCommiBean(rs));
 
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (CommiBean[])col.toArray(new CommiBean[0]);
    }
    /**
     * 영업사원 계약 전체조회.
     */
    public CommiBean [] getCommiAll(String emp_id, String emp_ssn) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";
        query = "select '' as CON_MON,substr(b.rent_dt,1,4)||'-'||substr(b.rent_dt,5,2)||'-'||substr(b.rent_dt,7,2) as RENT_DT,b.dlv_dt as DLV_DT,\n"
				        + "c.firm_nm as FIRM_NM,\n"
				        + "c.client_nm as CLIENT_NM,\n"
				        + "c.client_st as CLIENT_ST,\n"
				        + "h.car_nm||' '||e.car_name as CAR_NAME,\n"
				        + "f.user_nm as USER_NM,\n"
				        + "substr(g.INIT_REG_DT,1,4)||'-'||substr(g.INIT_REG_DT,5,2)||'-'||substr(g.INIT_REG_DT,7,2) as INIT_REG_DT, g.car_no as CAR_NO,\n"
        				+ "a.rent_mng_id as RENT_MNG_ID,\n" 
				        + "a.rent_l_cd as RENT_L_CD,\n"
				        + "a.emp_id as EMP_ID,\n"
				        + "a.agnt_st as AGNT_ST,\n"
				        + "a.commi as COMMI,\n"
				        + "a.inc_amt as INC_AMT,\n"
				        + "a.res_amt as RES_AMT,\n"
				        + "a.tot_amt as TOT_AMT,\n"
				        + "a.dif_amt as DIF_AMT,\n"
				        + "a.sup_dt as SUP_DT,\n"
				        + "a.rel as REL, decode(a.emp_acc_nm,i.emp_nm,'',a.emp_acc_nm) emp_acc_nm, i.emp_nm \n"
				+ "from commi a, cont b, client c, car_etc d, car_nm e, users f, car_reg g, car_mng h, car_off_emp i \n"
				+ "where a.emp_id<>'" + emp_id + "' and replace(a.rec_ssn,'-','')=replace('"+emp_ssn+"','-','') \n"
				+ "and a.agnt_st = '1'\n"
				+ "and a.rent_mng_id = b.rent_mng_id\n"
				+ "and a.rent_l_cd = b.rent_l_cd\n"
				+ "and b.client_id = c.client_id\n"
				+ "and a.rent_mng_id = d.rent_mng_id(+)\n"
				+ "and a.rent_l_cd = d.rent_l_cd\n"
				+ "and d.car_id = e.car_id(+) and d.car_seq=e.car_seq(+)\n"
				+ "and b.bus_id = f.user_id\n"
				+ "and b.car_mng_id = g.car_mng_id(+)\n"
				+ "and e.car_comp_id=h.car_comp_id and e.car_cd=h.code and a.emp_id=i.emp_id ";

        Collection col = new ArrayList();
        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
                
				col.add(makeCommiBean(rs));
 
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (CommiBean[])col.toArray(new CommiBean[0]);
    }    
    /**
     * 자동차회사 등록.
     */
    public int insertCarComp(CarCompBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query="INSERT INTO CODE(C_ST,\n"
								+ "CODE,\n"
								+ "NM_CD,\n"
								+ "NM,\n"
								+ "ETC,app_st,cms_bk,bigo)\n"
            + "SELECT '0001',nvl(lpad(max(CODE)+1,4,'0'),'0001'),UPPER(?),?,?,?,?,?\n"
            + "FROM CODE\n"
            + "WHERE C_ST='0001' and code<>'1000'\n";
            
       try{
            con.setAutoCommit(false);            
            
            pstmt = con.prepareStatement(query);
            pstmt.setString(1, bean.getNm_cd().trim());
            pstmt.setString(2, bean.getNm().trim());
            pstmt.setString(3, bean.getEtc().trim());
            pstmt.setString(4, bean.getApp_st().trim());
            pstmt.setString(5, bean.getCms_bk().trim());
            pstmt.setString(6, bean.getBigo().trim());
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
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }
    /**
     * 자동차영업소 등록.
     */
    public int insertCarOff(CarOffBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query="INSERT INTO CAR_OFF(CAR_OFF_ID,\n"
								+ "CAR_COMP_ID,\n"
								+ "CAR_OFF_NM,\n"
								+ "CAR_OFF_ST,\n"
								+ "OWNER_NM,\n"
								+ "CAR_OFF_TEL,\n"
								+ "CAR_OFF_FAX,\n"
								+ "CAR_OFF_POST,\n"
								+ "CAR_OFF_ADDR,\n"
								+ "BANK,\n"
								+ "ACC_NO,\n"
								+ "ACC_NM,\n"
								+ "USE_YN,\n"
								+ "VEN_CODE, manager, agnt_nm, agnt_m_tel, enp_no,\n"
								+ "reg_id, reg_dt, agent_st, enp_st, enp_reg_st, doc_st, est_day, req_st, pay_st, agnt_email, work_st, est_mon_st, bank_cd )\n"
            + "SELECT nvl(lpad(max(CAR_OFF_ID)+1,5,'0'),'00001'),?,?,?,?,?,?,?,?,?,?,?,?,?, ?, ?, ?, ?, \n"
			+ "       ?, replace(?,'-',''), ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? \n"
            + "FROM CAR_OFF\n";
            
       try{
            con.setAutoCommit(false);
            
            pstmt = con.prepareStatement(query);

            pstmt.setString(1,  bean.getCar_comp_id	().trim());
            pstmt.setString(2,  bean.getCar_off_nm	().trim());
            pstmt.setString(3,  bean.getCar_off_st	().trim());
            pstmt.setString(4,  bean.getOwner_nm	().trim());
            pstmt.setString(5,  bean.getCar_off_tel	().trim());
            pstmt.setString(6,  bean.getCar_off_fax	().trim());
            pstmt.setString(7,  bean.getCar_off_post().trim());
            pstmt.setString(8,  bean.getCar_off_addr().trim());
            pstmt.setString(9,  bean.getBank		().trim());
            pstmt.setString(10, bean.getAcc_no		().trim());
            pstmt.setString(11, bean.getAcc_nm		().trim());
			pstmt.setString(12, bean.getUse_yn		().trim());
            pstmt.setString(13, bean.getVen_code	().trim());
            pstmt.setString(14, bean.getManager		().trim());
            pstmt.setString(15, bean.getAgnt_nm		().trim());
            pstmt.setString(16, bean.getAgnt_m_tel	().trim());
			pstmt.setString(17, bean.getEnp_no		().trim());
            pstmt.setString(18, bean.getReg_id		().trim());
            pstmt.setString(19, bean.getReg_dt		().trim());
            pstmt.setString(20, bean.getAgent_st	().trim());
            pstmt.setString(21, bean.getEnp_st		().trim());
            pstmt.setString(22, bean.getEnp_reg_st	().trim());
            pstmt.setString(23, bean.getDoc_st		().trim());
			pstmt.setString(24, bean.getEst_day		().trim());
			pstmt.setString(25, bean.getReq_st		().trim());
			pstmt.setString(26, bean.getPay_st		().trim());
            pstmt.setString(27, bean.getAgnt_email	().trim());
			pstmt.setString(28, bean.getWork_st		().trim());
			pstmt.setString(29, bean.getEst_mon_st	().trim());
			pstmt.setString(30, bean.getBank_cd		().trim());
		   
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
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

    /**
     * 자동차영업소 사원 등록.
     */
    public String insertCarOffEmp(CarOffEmpBean bean, CarOffEdhBean bean2) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        PreparedStatement pstmt3 = null;
        ResultSet rs = null;
		String emp_id = "";
        String query = "", query1 = "", query2 = "";
        int count = 0;

		query2 = "INSERT INTO car_off_edh VALUES(?,1,?,?,?,?,?) ";
		query1 = "SELECT nvl(lpad(max(EMP_ID)+1,6,'0'),'000001') FROM car_off_emp ";   
        query  = "INSERT INTO CAR_OFF_EMP(EMP_ID,\n"
								+ "CAR_OFF_ID,\n"
								+ "CUST_ST,\n"
								+ "EMP_NM,\n"
								+ "EMP_SSN,\n"
								+ "EMP_M_TEL,\n"
								+ "EMP_POS,\n"
								+ "EMP_EMAIL,\n"
								+ "EMP_BANK,\n"
								+ "EMP_ACC_NO,\n"
								+ "EMP_ACC_NM,EMP_POST,EMP_ADDR,ETC,reg_dt,reg_id,emp_h_tel,emp_sex,use_yn, sms_denial_rsn, bank_cd)\n"
            + " VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";
            
       try{
            con.setAutoCommit(false);
            
            pstmt1 = con.prepareStatement(query1);
			rs = pstmt1.executeQuery();
			while(rs.next()){
				emp_id = rs.getString(1);
			}
			rs.close();
            pstmt1.close();

			pstmt2 = con.prepareStatement(query);
			pstmt2.setString(1, emp_id);
            pstmt2.setString(2, bean.getCar_off_id().trim());
            pstmt2.setString(3, bean.getCust_st().trim());
            pstmt2.setString(4, bean.getEmp_nm().trim());
            pstmt2.setString(5, bean.getEmp_ssn().trim());
            pstmt2.setString(6, bean.getEmp_m_tel().trim());
            pstmt2.setString(7, bean.getEmp_pos().trim());
            pstmt2.setString(8, bean.getEmp_email().trim());
            pstmt2.setString(9, bean.getEmp_bank().trim());
            pstmt2.setString(10, bean.getEmp_acc_no().trim());
            pstmt2.setString(11, bean.getEmp_acc_nm().trim());
            pstmt2.setString(12, bean.getEmp_post().trim());
            pstmt2.setString(13, bean.getEmp_addr().trim());
            pstmt2.setString(14, bean.getEtc().trim());
			pstmt2.setString(15, bean.getReg_dt().trim());
			pstmt2.setString(16, bean.getReg_id().trim());
			pstmt2.setString(17, bean.getEmp_h_tel().trim());
			pstmt2.setString(18, bean.getEmp_sex().trim());
			pstmt2.setString(19, bean.getUse_yn());
			pstmt2.setString(20, bean.getSms_denial_rsn());           
			pstmt2.setString(21, bean.getBank_cd());           
            count = pstmt2.executeUpdate();
			pstmt2.close();

			if(count>0){
				pstmt3 = con.prepareStatement(query2);
				pstmt3.setString(1, emp_id);
				pstmt3.setString(2, bean2.getDamdang_id());
				pstmt3.setString(3, bean2.getCng_dt());
				pstmt3.setString(4, bean2.getCng_rsn());
				pstmt3.setString(5, bean2.getReg_id());
				pstmt3.setString(6, bean2.getReg_dt());
				count = pstmt3.executeUpdate();
				pstmt3.close();
				if(count>0)	con.commit();
				else		con.rollback();
			}else{
				con.rollback();
			}
            
        }catch(Exception se){
			System.out.println("[CarOfficeDatabase:insertCarOffEmp]"+ se);
			se.printStackTrace();
            try{
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(rs != null) rs.close();
                if(pstmt1 != null) pstmt1.close();
                if(pstmt2 != null) pstmt2.close();
                if(pstmt3 != null) pstmt3.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return emp_id;
    }
    /**
     * 자동차영업소 사원 방문일지 등록.
     */
    public int insertCarOffEmpVis(CarOffEmpVisBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query="INSERT INTO VIS_D(EMP_ID,\n"
								+ "SEQ_NO,\n"
								+ "VIS_NM,\n"
								+ "VIS_DT,\n"
								+ "SUB,\n"
								+ "VIS_CONT)\n"
            + "SELECT ?,nvl(max(SEQ_NO)+1,'1'),?,replace(?,'-',''),?,?\n"
            + "FROM VIS_D WHERE EMP_ID=?\n";
            
       try{
            con.setAutoCommit(false);
            
            pstmt = con.prepareStatement(query);

            pstmt.setString(1, bean.getEmp_id().trim());
            pstmt.setString(2, bean.getVis_nm().trim());
            pstmt.setString(3, bean.getVis_dt().trim());
            pstmt.setString(4, bean.getSub().trim());
            pstmt.setString(5, bean.getVis_cont().trim());
            pstmt.setString(6, bean.getEmp_id().trim());                       
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
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

     /**
     * 자동차영업소 사원 방문일지 수정
     */
    public int updateCarOffEmpVis(CarOffEmpVisBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query="UPDATE VIS_D SET VIS_NM=?,\n"
								+ "VIS_DT=replace(?,'-',''),\n"
								+ "SUB=?,\n"
								+ "VIS_CONT=?\n"
            + "WHERE EMP_ID=? AND SEQ_NO=?\n";
            
       try{
            con.setAutoCommit(false);
            
            pstmt = con.prepareStatement(query);


            pstmt.setString(1, bean.getVis_nm().trim());
            pstmt.setString(2, bean.getVis_dt().trim());
            pstmt.setString(3, bean.getSub().trim());
            pstmt.setString(4, bean.getVis_cont().trim());
            pstmt.setString(5, bean.getEmp_id().trim());
            pstmt.setInt(6, bean.getSeq_no());
            
           
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
     * 자동차영업소 수정.
     */
    public int updateCarOff(CarOffBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query="UPDATE CAR_OFF\n"
        		+ "SET CAR_COMP_ID=?,\n"
					+ "CAR_OFF_NM=?,\n"
					+ "CAR_OFF_ST=?,\n"
					+ "OWNER_NM=?,\n"
					+ "CAR_OFF_TEL=?,\n"
					+ "CAR_OFF_FAX=?,\n"
					+ "CAR_OFF_POST=?,\n"
					+ "CAR_OFF_ADDR=?,\n"
					+ "BANK=?,\n"
					+ "ACC_NO=?,\n"
					+ "ACC_NM=?, USE_YN=?, VEN_CODE=?, MANAGER=?, AGNT_NM=?, AGNT_M_TEL=?, enp_no=replace(?,'-',''), \n"
					+ "agent_st=?, enp_st=?, enp_reg_st=?, doc_st=?, est_day=?, req_st=?, pay_st=?, AGNT_email=?, work_st=?, est_mon_st=?, bank_cd=? \n"
				+ "WHERE CAR_OFF_ID=?\n";
            
       try{
            con.setAutoCommit(false);
            
            pstmt = con.prepareStatement(query);

            pstmt.setString(1, bean.getCar_comp_id	().trim());
            pstmt.setString(2, bean.getCar_off_nm	().trim());
            pstmt.setString(3, bean.getCar_off_st	().trim());
            pstmt.setString(4, bean.getOwner_nm		().trim());
            pstmt.setString(5, bean.getCar_off_tel	().trim());
            pstmt.setString(6, bean.getCar_off_fax	().trim());
            pstmt.setString(7, bean.getCar_off_post	().trim());
            pstmt.setString(8, bean.getCar_off_addr	().trim());
            pstmt.setString(9, bean.getBank			().trim());
            pstmt.setString(10, bean.getAcc_no		().trim());
            pstmt.setString(11, bean.getAcc_nm		().trim());
			pstmt.setString(12, bean.getUse_yn		().trim());
            pstmt.setString(13, bean.getVen_code	().trim());
            pstmt.setString(14, bean.getManager		().trim());
            pstmt.setString(15, bean.getAgnt_nm		().trim());
            pstmt.setString(16, bean.getAgnt_m_tel	().trim());
            pstmt.setString(17, bean.getEnp_no		().trim());
            pstmt.setString(18, bean.getAgent_st	().trim());
            pstmt.setString(19, bean.getEnp_st		().trim());
            pstmt.setString(20, bean.getEnp_reg_st	().trim());
            pstmt.setString(21, bean.getDoc_st		().trim());
			pstmt.setString(22, bean.getEst_day		().trim());
			pstmt.setString(23, bean.getReq_st		().trim());
			pstmt.setString(24, bean.getPay_st		().trim());
            pstmt.setString(25, bean.getAgnt_email	().trim());
			pstmt.setString(26, bean.getWork_st		().trim());
			pstmt.setString(27, bean.getEst_mon_st	().trim());
			pstmt.setString(28, bean.getBank_cd		().trim());
            pstmt.setString(29, bean.getCar_off_id	().trim());
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
     * 자동차영업소 사원 수정. 담당이력추가20050818.
     */
    public String updateCarOffEmp(CarOffEmpBean bean, CarOffEdhBean bean2) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        PreparedStatement pstmt3 = null;
        PreparedStatement pstmt4 = null;
        PreparedStatement pstmt5 = null;
        ResultSet rs = null, rs2=null;
        String query,query1,query2="", query3="", query4="";
		String old_emp_pos= "";
		String old_car_off_id = "", damdang_id="", cng_dt="", cng_rsn="";
        int count = 0;
        
		query1 = "SELECT car_off_id, emp_pos FROM car_off_emp WHERE emp_id = ?";

        query  = "UPDATE CAR_OFF_EMP\n"
        		+ "SET CAR_OFF_ID=?,\n"
					+ "CUST_ST=?,\n"
					+ "EMP_NM=?,\n"
					+ "EMP_SSN=?,\n"
					+ "EMP_M_TEL=?,\n"
					+ "EMP_POS=?,\n"
					+ "EMP_EMAIL=?,\n"
					+ "EMP_BANK=?,\n"
					+ "EMP_ACC_NO=?,\n"
					+ "EMP_ACC_NM=?,EMP_POST=?,EMP_ADDR=?,ETC=?,UPD_DT=replace(?, '-', ''),UPD_ID=?,EMP_H_TEL=?,EMP_SEX=?,USE_YN=?, \n"
					+ "sms_denial_rsn=?, fraud_care=?, bank_cd=? \n"
				+ "WHERE EMP_ID=?\n";
           
		query2 = "INSERT INTO car_off_cng VALUES(?,(select nvl(max(seq)+1,1) from car_off_cng where emp_id=?),?,?,replace(?, '-', ''),?) ";

		query4 = "SELECT * FROM car_off_edh a WHERE emp_id=? AND a.seq=(select max(b.seq) from car_off_edh b where a.emp_id = b.emp_id) ";

		query3 = "INSERT INTO car_off_edh VALUES(?,(select nvl(max(seq)+1,1) from car_off_edh where emp_id=?),?,replace(?, '-', ''),?,?, replace(?, '-', '')) ";

       try{
            con.setAutoCommit(false);

			pstmt1 = con.prepareStatement(query1);
			pstmt1.setString(1, bean.getEmp_id());
			rs = pstmt1.executeQuery();
			if(rs.next()){
				old_car_off_id = rs.getString(1);
				old_emp_pos = rs.getString(2);
			}
			rs.close();
			pstmt1.close();

            
            pstmt2 = con.prepareStatement(query);
            pstmt2.setString(1, bean.getCar_off_id().trim());
            pstmt2.setString(2, bean.getCust_st().trim());
            pstmt2.setString(3, bean.getEmp_nm().trim());
            pstmt2.setString(4, bean.getEmp_ssn().trim());
            pstmt2.setString(5, bean.getEmp_m_tel().trim());
            pstmt2.setString(6, bean.getEmp_pos().trim());
            pstmt2.setString(7, bean.getEmp_email().trim());
            pstmt2.setString(8, bean.getEmp_bank().trim());
            pstmt2.setString(9, bean.getEmp_acc_no().trim());
            pstmt2.setString(10, bean.getEmp_acc_nm().trim());
            pstmt2.setString(11, bean.getEmp_post().trim());
            pstmt2.setString(12, bean.getEmp_addr().trim());
            pstmt2.setString(13, bean.getEtc().trim());
			pstmt2.setString(14, bean.getUpd_dt());
			pstmt2.setString(15, bean.getUpd_id());
			pstmt2.setString(16, bean.getEmp_h_tel());
			pstmt2.setString(17, bean.getEmp_sex());
			pstmt2.setString(18, bean.getUse_yn());
			pstmt2.setString(19, bean.getSms_denial_rsn());
			pstmt2.setString(20, bean.getFraud_care());
			pstmt2.setString(21, bean.getBank_cd());
            pstmt2.setString(22, bean.getEmp_id().trim());                                    
            count = pstmt2.executeUpdate();
			pstmt2.close();



			if(!old_car_off_id.equals(bean.getCar_off_id())){
				pstmt3 = con.prepareStatement(query2);
				pstmt3.setString(1, bean.getEmp_id());
				pstmt3.setString(2, bean.getEmp_id());
				pstmt3.setString(3, old_car_off_id);
				pstmt3.setString(4, old_emp_pos);
				pstmt3.setString(5, bean.getUpd_dt());
				pstmt3.setString(6, bean.getUpd_id());
				count = pstmt3.executeUpdate();
				pstmt3.close();


            }

			if(count>0){
				pstmt4 = con.prepareStatement(query4);
				pstmt4.setString(1, bean2.getEmp_id());
				rs2 = pstmt4.executeQuery();
				if(rs2.next()){
					damdang_id	= rs2.getString("DAMDANG_ID")==null?"":rs2.getString("DAMDANG_ID");
					cng_dt		= rs2.getString("CNG_DT")==null?"":rs2.getString("CNG_DT");
					cng_rsn		= rs2.getString("CNG_RSN")==null?"":rs2.getString("CNG_RSN");
				}
				rs2.close();
				pstmt4.close();


				if(damdang_id.equals(bean2.getDamdang_id()) && cng_dt.equals(bean2.getCng_dt()) && cng_rsn.equals(bean2.getCng_rsn())){
					con.commit();
				}else{
					pstmt5 = con.prepareStatement(query3);
					pstmt5.setString(1, bean2.getEmp_id		());
					pstmt5.setString(2, bean2.getEmp_id		());
					pstmt5.setString(3, bean2.getDamdang_id	());
					pstmt5.setString(4, bean2.getCng_dt		());
					pstmt5.setString(5, bean2.getCng_rsn	());
					pstmt5.setString(6, bean2.getReg_id		());
					pstmt5.setString(7, bean2.getReg_dt		());
					count = pstmt5.executeUpdate();
					pstmt5.close();
					if(count>0)	con.commit();
					else		con.rollback();
				}
			}else{
				con.rollback();
			}

        }catch(Exception se){
            try{
                con.rollback();
            }catch(SQLException _ignored){}
				System.out.println("[CarOfficeDatabase:updateCarOffEmp(CarOffEmpBean bean, bean2)]"+ se);
				System.out.println("[CarOfficeDatabase:updateCarOffEmp(CarOffEmpBean bean, bean2)]"+ bean.getEmp_id());
				throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(rs != null) rs.close();
				if(rs2 != null) rs2.close();
                if(pstmt1 != null) pstmt1.close();
                if(pstmt2 != null) pstmt2.close();
                if(pstmt3 != null) pstmt3.close();
                if(pstmt4 != null) pstmt4.close();
                if(pstmt5 != null) pstmt5.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return bean.getEmp_id();
    }
    /**
     * 자동차회사 수정.
     */
    public int updateCarComp(CarCompBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query="UPDATE CODE\n"
        	+ "SET NM_CD=?,\n"
				+ "NM=?,\n"
				+ "ETC=?, app_st=?, cms_bk=?, bigo=?\n"
            + "WHERE C_ST='0001'\n"
            + "AND CODE=?";
            
       try{
            con.setAutoCommit(false);
            
            
            pstmt = con.prepareStatement(query);

            pstmt.setString(1, bean.getNm_cd().trim());
            pstmt.setString(2, bean.getNm().trim());
            pstmt.setString(3, bean.getEtc().trim());
            pstmt.setString(4, bean.getApp_st().trim());
            pstmt.setString(5, bean.getCms_bk().trim());
            pstmt.setString(6, bean.getBigo().trim());
            pstmt.setString(7, bean.getCode().trim());
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
     * 성명 중복체크 20040818
     */
    public Vector getNameList(String name) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
		Vector vt = new Vector();
        
        String query = "";
        
        query = "SELECT F_getCarCompName(b.car_comp_id) car_comp_nm, b.car_off_nm, a.emp_id, a.emp_nm,a.emp_m_tel,a.emp_email "+
				" FROM car_off_emp a, car_off b WHERE a.car_off_id=b.car_off_id and emp_nm LIKE '%"+name+"%'";

        try{
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery(query);
			ResultSetMetaData rsmd = rs.getMetaData();
			while(rs.next()){
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
        return vt;
    }

	/**
     * 근무지역 주소 가져오기 20040819
     */
    public Hashtable getCar_off_addr(String car_off_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
		Hashtable ht = new Hashtable();
        
        String query = "";
        
        query = " select substr(car_off_addr,1,instr(car_off_addr,' ')) ADDR1, "+
				"        substr(car_off_addr,instr(car_off_addr,' ')+1,instr(substr(car_off_addr,instr(car_off_addr,' ')+1),' ')) ADDR2, "+
				"        bank, acc_no, acc_nm, bank_cd "+
				" from   car_off "+
				" WHERE  car_off_id='"+car_off_id+"'";

        try{
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery(query);
			ResultSetMetaData rsmd = rs.getMetaData();
			while(rs.next()){
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
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
        return ht;
    }

	/*
	//지급수수료 납부 리스트 조회 : con_ins_sc_in.jsp
	*/
	public Vector getCommiList(String emp_id) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String est_dt = "a.sup_dt";

		query = " select /*+  merge(b) */ "+
				"        b.rent_mng_id, b.rent_l_cd, b.car_mng_id, b.use_yn, b.firm_nm, b.dlv_dt, cr.car_no, cr.car_nm, cn.car_name,"+
				"        e.nm com_nm, d.car_off_nm, c.emp_nm, a.emp_id, a.commi, (a.inc_amt+a.res_amt) as commi_fee, a.dif_amt,"+
				"        DECODE(a.sup_dt,'','',SUBSTR(a.sup_dt,1,4)||'-'||SUBSTR(a.sup_dt,5,2)||'-'||SUBSTR(a.sup_dt,7,2)) as sup_dt"+
				" from   commi a, cont_n_view b, car_off_emp c, car_off d, code e , car_reg cr,  car_etc g, car_nm cn \n"+ 
				" where  c.emp_id = '"+emp_id+"' and a.agnt_st='1'"+
				"        and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"        and a.emp_id=c.emp_id"+
				"        and c.car_off_id=d.car_off_id"+
				"        and d.car_comp_id=e.code and e.c_st='0001' and e.code<>'0000' "+
				"	and b.car_mng_id = cr.car_mng_id  and a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+)  \n"+
                       		"	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+)  "+
				" order by a.sup_dt, b.dlv_dt";

	
		try {
				pstmt = con.prepareStatement(query);
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
			System.out.println("[CarOfficeDatabase:getCommiList(String emp_id)]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}	
	
	public Vector getCommiList(String emp_id, String emp_ssn) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String est_dt = "a.sup_dt";

		query = " select /*+  merge(b) */ "+
				"        b.rent_mng_id, b.rent_l_cd, b.car_mng_id, b.use_yn, b.firm_nm, b.dlv_dt, cr.car_no, cr.car_nm, cn.car_name,"+
				"        e.nm com_nm, d.car_off_nm, c.emp_nm, a.emp_id, a.commi, (a.inc_amt+a.res_amt) as commi_fee, a.dif_amt,"+
				"        DECODE(a.sup_dt,'','',SUBSTR(a.sup_dt,1,4)||'-'||SUBSTR(a.sup_dt,5,2)||'-'||SUBSTR(a.sup_dt,7,2)) as sup_dt, a.emp_acc_nm"+
				" from   commi a, cont_n_view b, car_off_emp c, car_off d, code e , car_reg cr,  car_etc g, car_nm cn \n"+ 
				" where  a.emp_id <> '"+emp_id+"' and replace(a.rec_ssn,'-','')=replace('"+emp_ssn+"','-','') and a.agnt_st='1' "+
				"        and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"        and a.emp_id=c.emp_id"+
				"        and c.car_off_id=d.car_off_id"+
				"        and d.car_comp_id=e.code and e.c_st='0001' and e.code<>'0000' "+
				"	and b.car_mng_id = cr.car_mng_id  and a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+)  \n"+
                       		"	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+)  "+
				" order by a.sup_dt, b.dlv_dt";

	
		try {
				pstmt = con.prepareStatement(query);
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
			System.out.println("[CarOfficeDatabase:getCommiList(String emp_id, String emp_ssn)]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}		

    /**
     * 영업사원 근무처관리 20040824. Yongsoon Kwon.
     */
    public CarOffCngBean[] getCarOffCng(String emp_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
		String query = "SELECT a.emp_id, a.seq, a.car_off_id, a.emp_pos FROM car_off_cng a, car_off b WHERE a.emp_id='"+emp_id+"' AND a.car_off_id=b.car_off_id ";

        Collection col = new ArrayList();
        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);

            while(rs.next()){
				CarOffCngBean bean = new CarOffCngBean();
				bean.setEmp_id(rs.getString(1));
				bean.setSeq(rs.getInt(2));
				bean.setCar_off_id(rs.getString(3));
				bean.setEmp_pos(rs.getString(4));

				col.add(bean);
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (CarOffCngBean[])col.toArray(new CarOffCngBean[0]);
    }

	/*
	*	변경등록 이력 조회, 20040824, Yongsoon Kwon
	*/
	public Vector getUpdateList(String emp_id) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT emp_id,reg_dt,reg_id,'1' st FROM car_off_cng WHERE emp_id=? \n"+
				" UNION ALL \n"+
				" SELECT emp_id,vis_dt,vis_nm,'2' st FROM vis_d WHERE emp_id=? \n"+
				" ORDER BY 2 ";
	
		try {
			pstmt = con.prepareStatement(query);
			pstmt.setString(1,emp_id);
			pstmt.setString(2,emp_id);
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
			System.out.println("[CarOfficeDatabase:getUpdateList(String emp_id)]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

	//담당자이력
	/*
	*	담당자이력 조회, 20050818, Yongsoon Kwon
	*/
	public CarOffEdhBean[] getCar_off_edh(String emp_id) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Collection col = new ArrayList();
		String query = "";

		query = " SELECT emp_id, seq, damdang_id, cng_dt, cng_rsn, reg_id, reg_dt "+
				" FROM car_off_edh WHERE emp_id=? order by to_number(seq)";
	
		try {
			pstmt = con.prepareStatement(query);
			pstmt.setString(1,emp_id);
			rs = pstmt.executeQuery();

			while(rs.next())
			{				
				col.add(makeCarOffEdhBean(rs));
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CarOfficeDatabase:getUpdateList(String emp_id)]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return (CarOffEdhBean[])col.toArray(new CarOffEdhBean[0]);
	}


	//영업소 현황---------------------------------------------------------------------------------------------------------------------------
	//                                                                                                                   (2005.08.29 정현미)

	/*
	*	자동차영업소 현황1
	*/
	public Vector getCarOffStat1(String gubun1, String gubun2, String gubun3, String gubun4, String s_kd,  String t_wd) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String b_query = "";

		b_query = " select "+
				" count(decode(car_comp_id,'0001',decode(car_off_st,'1',car_off_id))) cnt11,"+
				" count(decode(car_comp_id,'0001',decode(car_off_st,'2',car_off_id))) cnt12,"+
				" count(decode(car_comp_id,'0002',decode(car_off_st,'1',car_off_id))) cnt21,"+
				" count(decode(car_comp_id,'0002',decode(car_off_st,'2',car_off_id))) cnt22,"+
				" count(decode(car_comp_id,'0003',decode(car_off_st,'1',car_off_id))) cnt31,"+
				" count(decode(car_comp_id,'0003',decode(car_off_st,'2',car_off_id))) cnt32,"+
				" count(decode(car_comp_id,'0004',decode(car_off_st,'1',car_off_id))) cnt41,"+
				" count(decode(car_comp_id,'0004',decode(car_off_st,'2',car_off_id))) cnt42,"+
				" count(decode(car_comp_id,'0005',decode(car_off_st,'1',car_off_id))) cnt51,"+
				" count(decode(car_comp_id,'0005',decode(car_off_st,'2',car_off_id))) cnt52,"+
				" count(decode(sign('0005'-car_comp_id),-1,decode(car_off_st,'1',car_off_id))) cnt61,"+
				" count(decode(sign('0005'-car_comp_id),-1,decode(car_off_st,'2',car_off_id))) cnt62"+
				" from car_off";

		query = b_query + " where use_yn='Y' and car_off_addr like '서울%' union all"+
				b_query + " where use_yn='Y' and car_off_addr like '경기%' union all"+
				b_query + " where use_yn='Y' and car_off_addr like '인천%' union all"+
				b_query + " where use_yn='Y' and substr(car_off_post,1,1) not in ('1','4')";
	
		try {
			pstmt = con.prepareStatement(query);
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
			System.out.println("[CarOfficeDatabase:getCarOffStat1]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

	/*
	*	자동차영업소 현황1
	*/
	public Hashtable getCarOffStat2(String gubun1, String gubun2, String gubun3, String gubun4, String s_kd,  String t_wd) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select "+
				" count(car_off_id) cnt00,"+
				" count(decode(car_off_st,'1',car_off_id)) cnt01,"+
				" count(decode(car_off_st,'2',car_off_id)) cnt02,"+
//				" count(decode(substr(car_off_post,1,1),'1',car_off_id)) cnt03,"+
//				" count(decode(substr(car_off_post,1,1),'4',decode(sign(410-substr(car_off_post,1,3)),-1,decode(substr(car_off_post,1,3),'417','',car_off_id)))) cnt04,"+
//				" count(decode(substr(car_off_post,1,1),'4',decode(sign(408-substr(car_off_post,1,3)),1,car_off_id))) cnt05,"+
//				" count(decode(substr(car_off_post,1,1),'1','','4','',car_off_id)) cnt06,"+
				" count(decode(substr(car_off_addr,1,2),'서울',car_off_id)) cnt03,"+
				" count(decode(substr(car_off_addr,1,2),'경기',car_off_id)) cnt04,"+
				" count(decode(substr(car_off_addr,1,2),'인천',car_off_id)) cnt05,"+
				" count(decode(substr(car_off_addr,1,2),'서울','','경기','','인천','',car_off_id)) cnt06,"+
//				" count(decode(car_off_st,'1',decode(substr(car_off_post,1,1),'1',car_off_id))) cnt11,"+
//				" count(decode(car_off_st,'2',decode(substr(car_off_post,1,1),'1',car_off_id))) cnt12,"+
//				" count(decode(car_off_st,'1',decode(substr(car_off_post,1,1),'4',decode(sign(410-substr(car_off_post,1,3)),-1,decode(substr(car_off_post,1,3),'417','',car_off_id))))) cnt21,"+
//				" count(decode(car_off_st,'2',decode(substr(car_off_post,1,1),'4',decode(sign(410-substr(car_off_post,1,3)),-1,decode(substr(car_off_post,1,3),'417','',car_off_id))))) cnt22,"+
//				" count(decode(car_off_st,'1',decode(substr(car_off_post,1,1),'4',decode(sign(408-substr(car_off_post,1,3)),1,car_off_id)))) cnt31,"+
//				" count(decode(car_off_st,'2',decode(substr(car_off_post,1,1),'4',decode(sign(408-substr(car_off_post,1,3)),1,car_off_id)))) cnt32,"+
//				" count(decode(car_off_st,'1',decode(substr(car_off_post,1,1),'4',decode(substr(car_off_post,1,3),'417',car_off_id)))) cnt33,"+
//				" count(decode(car_off_st,'2',decode(substr(car_off_post,1,1),'4',decode(substr(car_off_post,1,3),'417',car_off_id)))) cnt34,"+
//				" count(decode(car_off_st,'1',decode(substr(car_off_post,1,1),'1','','4','',car_off_id))) cnt41,"+
//				" count(decode(car_off_st,'2',decode(substr(car_off_post,1,1),'1','','4','',car_off_id))) cnt42"+
				" count(decode(car_off_st,'1',decode(substr(car_off_addr,1,2),'서울',car_off_id))) cnt11,"+
				" count(decode(car_off_st,'2',decode(substr(car_off_addr,1,2),'서울',car_off_id))) cnt12,"+
				" count(decode(car_off_st,'1',decode(substr(car_off_addr,1,2),'경기',car_off_id))) cnt21,"+
				" count(decode(car_off_st,'2',decode(substr(car_off_addr,1,2),'경기',car_off_id))) cnt22,"+
				" count(decode(car_off_st,'1',decode(substr(car_off_addr,1,2),'인천',car_off_id))) cnt31,"+
				" count(decode(car_off_st,'2',decode(substr(car_off_addr,1,2),'인천',car_off_id))) cnt32,"+
				" count(decode(car_off_st,'1',decode(substr(car_off_addr,1,2),'서울','','경기','','인천','',car_off_id))) cnt41,"+
				" count(decode(car_off_st,'2',decode(substr(car_off_addr,1,2),'서울','','경기','','인천','',car_off_id))) cnt42"+
				" from car_off where use_yn='Y' and car_comp_id='"+gubun3+"'";
	
		try {
			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next())
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
			System.out.println("[CarOfficeDatabase:getCarOffStat2]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return ht;
	}

	/*
	*	자동차영업소 현황3
	*/
	public Vector getCarOffStatLoc(String gubun1, String gubun2, String gubun3, String gubun4, String s_kd,  String t_wd) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String b_query = "";
		String query1 = "";
		String query2 = "";

		b_query = " select"+
				" c.sido, nvl(c.gugun,'기타') gugun,"+
				" count(*) off_cnt,"+
				" sum(b.emp_cnt) emp_cnt"+
				" from car_off a, "+
				" (select car_off_id, count(*) emp_cnt from car_off_emp group by car_off_id) b, "+
				" (select zip_cd, min(sido) sido, min(gugun) gugun from zip group by zip_cd) c"+
				" where "+
				" a.car_off_id=b.car_off_id(+)"+
				" and a.car_off_post = c.zip_cd(+)"+
				" and nvl(a.use_yn,'Y')='Y'";
		
		if(!gubun1.equals("") && !gubun1.equals("기타"))	b_query += " and substr(a.car_off_addr,1,2) = '"+gubun1+"'";

		if(gubun1.equals("기타"))							b_query += " and substr(a.car_off_addr,1,2) not in ('서울','경기','인천')";

		if(!gubun3.equals(""))								b_query += " and a.car_comp_id='"+gubun3+"'";

		query1 = b_query + " and a.car_off_st = '1' group by c.sido, c.gugun";	

		query2 = b_query + " and a.car_off_st = '2' group by c.sido, c.gugun";	

	
		query = " select a.sido, a.gugun, nvl(a.off_cnt,0) as o_cnt1, nvl(b.off_cnt,0) as o_cnt2, nvl(a.emp_cnt,0) as e_cnt1, nvl(b.emp_cnt,0) as e_cnt2"+
				" from ("+query1+") a, ("+query2+") b where a.gugun=b.gugun(+) order by decode(a.gugun,'기타','히',a.gugun)";


		try {
			pstmt = con.prepareStatement(query);
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
			System.out.println("[CarOfficeDatabase:getCarOffStatLoc]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
			return vt;
	}

	//공문---------------------------------------------------------------------------------------------------------


	//해지보험공문 한건 등록
    public boolean insertCarPurDocList(CarPurDocListBean bean, String doc_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        boolean flag = true;
                
		query = " INSERT INTO car_pur_doc_list "+
				" (      doc_id, rent_mng_id, rent_l_cd, agnt_st, car_nm, opt, colo, purc_gu, req_dt, bus_nm, "+
				"        reg_id, reg_dt, auto, car_off_nm, car_amt, doc_st, cng_code, udt_st "+
				" ) VALUES "+
				" (      ?, ?, ?, ?, ?,    ?, ?, ?, ?, ?,   ?, to_char(sysdate,'YYYYMMDD'), ?, ?, ?, ?, ?, ? "+
				" )";
            
       try{
            con.setAutoCommit(false);            
            
            pstmt = con.prepareStatement(query);

			pstmt.setString	(1,		bean.getDoc_id 		());
			pstmt.setString	(2,		bean.getRent_mng_id	());
			pstmt.setString	(3,		bean.getRent_l_cd	());
			pstmt.setString	(4,		bean.getAgnt_st		());
			pstmt.setString	(5,		bean.getCar_nm		());
			pstmt.setString	(6,		bean.getOpt			());
			pstmt.setString	(7,		bean.getColo		());
			pstmt.setString	(8,		bean.getPurc_gu		());
			pstmt.setString	(9,		bean.getReq_dt		());
			pstmt.setString	(10,	bean.getBus_nm		());
			pstmt.setString	(11,	bean.getReg_id		());
			pstmt.setString	(12,	bean.getAuto		());
			pstmt.setString	(13,	bean.getCar_off_nm	());
			pstmt.setString	(14,	bean.getCar_amt		());
			pstmt.setString	(15,	bean.getDoc_st		());
			pstmt.setString	(16,	bean.getCng_code	());
			pstmt.setString	(17,	bean.getUdt_st		());

            pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
                con.rollback();
		  		flag = false;
				System.out.println("[CarOfficeDatabase:insertCarPurDocList]\n"+se);

				System.out.println("[bean.getDoc_id 		()]\n"+bean.getDoc_id 		());
				System.out.println("[bean.getRent_mng_id	()]\n"+bean.getRent_mng_id	());
				System.out.println("[bean.getRent_l_cd		()]\n"+bean.getRent_l_cd	());
				System.out.println("[bean.getAgnt_st		()]\n"+bean.getAgnt_st		());
				System.out.println("[bean.getCar_nm			()]\n"+bean.getCar_nm		());
				System.out.println("[bean.getOpt			()]\n"+bean.getOpt			());
				System.out.println("[bean.getColo			()]\n"+bean.getColo			());
				System.out.println("[bean.getPurc_gu		()]\n"+bean.getPurc_gu		());
				System.out.println("[bean.getReq_dt			()]\n"+bean.getReq_dt		());
				System.out.println("[bean.getBus_nm			()]\n"+bean.getBus_nm		());
				System.out.println("[bean.getReg_id			()]\n"+bean.getReg_id		());
				System.out.println("[bean.getAuto			()]\n"+bean.getAuto			());
				System.out.println("[bean.getCar_off_nm		()]\n"+bean.getCar_off_nm	());

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

	//해지보험공문 한건 수정
    public boolean updateCarPurDocList(CarPurDocListBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        boolean flag = true;
                
		query = " update car_pur_doc_list set "+
				"	     car_nm=?, opt=?, colo=?, purc_gu=?, req_dt=?, "+
				"        upd_id=?, upd_dt=to_char(sysdate,'YYYYMMDD'), auto=?, car_amt=?, udt_st=? "+
				" where doc_id=? and rent_mng_id=? and rent_l_cd=? ";
            
       try{
            con.setAutoCommit(false);            
            
            pstmt = con.prepareStatement(query);

			pstmt.setString	(1,		bean.getCar_nm		());
			pstmt.setString	(2,		bean.getOpt			());
			pstmt.setString	(3,		bean.getColo		());
			pstmt.setString	(4,		bean.getPurc_gu		());
			pstmt.setString	(5,		bean.getReq_dt		());
			pstmt.setString	(6,		bean.getUpd_id		());
			pstmt.setString	(7,		bean.getAuto		());
			pstmt.setString	(8,		bean.getCar_amt		());
			pstmt.setString	(9,		bean.getUdt_st		());
			pstmt.setString	(10,	bean.getDoc_id 		());
			pstmt.setString	(11,	bean.getRent_mng_id	());
			pstmt.setString	(12,	bean.getRent_l_cd	());

            pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
                con.rollback();
		  		flag = false;
				System.out.println("[CarOfficeDatabase:updateCarPurDocList]\n"+se);
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

	//해지보험공문 한건 삭제
    public boolean deleteCarPurDocList(CarPurDocListBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        boolean flag = true;
                
		query = " delete from car_pur_doc_list "+
				" where doc_id=? and rent_mng_id=? and rent_l_cd=? ";
            
       try{
            con.setAutoCommit(false);            
            
            pstmt = con.prepareStatement(query);

			pstmt.setString	(1,	bean.getDoc_id 		());
			pstmt.setString	(2,	bean.getRent_mng_id	());
			pstmt.setString	(3,	bean.getRent_l_cd	());

            pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
                con.rollback();
		  		flag = false;
				System.out.println("[CarOfficeDatabase:deleteCarPurDocList]\n"+se);
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

	/*
	*	자동차납품공문 계약리스트
	*/
	public Vector getCarPurDocLists(String doc_id) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String dt = "";
					
		query = " select b.dlv_dt, SUBSTR(a.RENT_L_CD,1,8) rent_l_cd1, SUBSTR(a.RENT_L_CD,9) rent_l_cd2, c.firm_nm, e.user_nm, f.cng_cau, "+
				"        a.*  "+
				" from   car_pur_doc_list a, cont b, client c, users e, car_pur_cng_list f "+
				" where  a.doc_id='"+doc_id+"' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.client_id=c.client_id and b.bus_id=e.user_id "+
				"        and a.rent_l_cd=f.rent_l_cd(+) and a.cng_code=f.cng_code(+) "+
				" order by a.rent_l_cd ";


		try {
			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next()){
				CarPurDocListBean bean = new CarPurDocListBean();
				bean.setDlv_dt			(rs.getString(1)==null?"":rs.getString(1));
				bean.setRent_l_cd1		(rs.getString(2)==null?"":rs.getString(2));
				bean.setRent_l_cd2		(rs.getString(3)==null?"":rs.getString(3));
				bean.setFirm_nm			(rs.getString(4)==null?"":rs.getString(4));
				bean.setBus_nm			(rs.getString(5));
				bean.setCng_cau			(rs.getString(6)==null?"":rs.getString(6));
				bean.setDoc_id 			(rs.getString(7));
				bean.setRent_mng_id		(rs.getString(8));
				bean.setRent_l_cd		(rs.getString(9));
				bean.setAgnt_st			(rs.getString(10));
				bean.setCar_nm			(rs.getString(11));
				bean.setOpt				(rs.getString(12));
				bean.setColo			(rs.getString(13));
				bean.setPurc_gu			(rs.getString(14));
				bean.setReq_dt			(rs.getString(15));
//				bean.setBus_nm			(rs.getString(16));
				bean.setReg_id			(rs.getString(17));
				bean.setReg_dt			(rs.getString(18));
				bean.setUpd_id			(rs.getString(19));
				bean.setUpd_dt			(rs.getString(20));
				bean.setAuto			(rs.getString(21)==null?"":rs.getString(21));
				bean.setCar_off_nm		(rs.getString(22)==null?"":rs.getString(22));
				bean.setCar_amt			(rs.getString(23)==null?"":rs.getString(23));
				bean.setDoc_st			(rs.getString(24)==null?"":rs.getString(24));
				bean.setCng_code		(rs.getString(25)==null?"":rs.getString(25));
				bean.setUdt_st			(rs.getString(26)==null?"":rs.getString(26));

				vt.add(bean);
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CarOfficeDatabase:getCarPurDocLists]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

	/*
	*	자동차납품공문 계약리스트
	*/
	public CarPurDocListBean getCarPurDocList(String doc_id, String rent_mng_id, String rent_l_cd) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		CarPurDocListBean bean = new CarPurDocListBean();
		String query = "";
					
		query = " select a.*  "+
				" from   car_pur_doc_list a "+
				" where  a.doc_id='"+doc_id+"' and a.rent_mng_id='"+rent_mng_id+"' and a.rent_l_cd='"+rent_l_cd+"' ";

		try {
			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();

			if(rs.next()){
				bean.setDoc_id 			(rs.getString(1));
				bean.setRent_mng_id		(rs.getString(2));
				bean.setRent_l_cd		(rs.getString(3));
				bean.setAgnt_st			(rs.getString(4));
				bean.setCar_nm			(rs.getString(5));
				bean.setOpt				(rs.getString(6)==null?"":rs.getString(6));
				bean.setColo			(rs.getString(7)==null?"":rs.getString(7));
				bean.setPurc_gu			(rs.getString(8)==null?"":rs.getString(8));
				bean.setReq_dt			(rs.getString(9)==null?"":rs.getString(9));
				bean.setBus_nm			(rs.getString(10)==null?"":rs.getString(10));
				bean.setReg_id			(rs.getString(11));
				bean.setReg_dt			(rs.getString(12));
				bean.setUpd_id			(rs.getString(13));
				bean.setUpd_dt			(rs.getString(14));
				bean.setAuto			(rs.getString(15)==null?"":rs.getString(15));
				bean.setCar_off_nm		(rs.getString(16)==null?"":rs.getString(16));
				bean.setCar_amt			(rs.getString(17)==null?"":rs.getString(17));
				bean.setDoc_st			(rs.getString(18)==null?"":rs.getString(18));
				bean.setCng_code		(rs.getString(19)==null?"":rs.getString(19));
				bean.setUdt_st			(rs.getString(20)==null?"":rs.getString(20));
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CarOfficeDatabase:getCarPurDocList]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return bean;
	}

	/*
	*	자동차납품공문 계약리스트
	*/
	public Vector getCarContList(String emp_nm, String gubun1, String gubun2, String st_dt, String end_dt) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String dt = "";
					
			query = " select"+
					"        a.rent_mng_id, a.rent_l_cd, b.agnt_st, f.car_nm, e.car_name, d.opt, d.colo, decode(d.purc_gu,'0','면세','1','과세') purc_gu,"+
					"        g.user_nm as bus_nm, a.rent_dt, a.dlv_dt, b.emp_id, c.emp_nm, i.doc_dt, j.firm_nm, k.car_no, l.rpt_no"+
					" from   cont a, commi b, car_off_emp c, car_etc d, car_nm e, car_mng f, users g, car_pur_doc_list h, fine_doc i, client j, car_reg k, car_pur l "+
					" where  nvl(a.use_yn,'Y')='Y' and b.agnt_st='2' and a.rent_l_cd=b.rent_l_cd(+) and b.emp_id=c.emp_id "+
					"        and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd"+
					"        and d.car_id=e.car_id and d.car_seq=e.car_seq and e.car_comp_id=f.car_comp_id and e.car_cd=f.code"+
					"        and b.rent_mng_id=h.rent_mng_id(+) and b.rent_l_cd=h.rent_l_cd(+) and b.agnt_st=h.agnt_st(+) and h.doc_id=i.doc_id(+)"+
					"        and a.bus_id=g.user_id and a.client_id=j.client_id and a.car_mng_id=k.car_mng_id(+)"+// and a.rent_dt > '20050911'
					"        and a.rent_mng_id=l.rent_mng_id(+) and a.rent_l_cd=l.rent_l_cd(+)";


			if(!emp_nm.equals(""))									query += " and c.emp_nm='"+emp_nm+"'";

			if(gubun1.equals("1"))									query += " and a.rent_dt > '20050901' and i.doc_dt is not null";
			if(gubun1.equals("2"))									query += " and a.rent_dt > '20050901' and i.doc_dt is null";
			if(gubun1.equals("3"))									query += " and a.rent_dt > '20050901' and a.dlv_dt is null";

			if(gubun2.equals("1"))		dt = "a.rent_dt";
			if(gubun2.equals("2"))		dt = "a.dlv_dt";

			if(!st_dt.equals("") && !end_dt.equals(""))				query += " and "+dt+" between '"+st_dt+"' and '"+end_dt+"'";
			if(!st_dt.equals("") && end_dt.equals(""))				query += " and "+dt+" like '%"+st_dt+"%'";

			if(gubun2.equals("1"))		query += " order by a.rent_dt";
			if(gubun2.equals("2"))		query += " order by a.dlv_dt";

		try {
			pstmt = con.prepareStatement(query);
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
			System.out.println("[CarOfficeDatabase:getCarContList]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

	/*
	*	자동차납품공문 계약리스트
	*/
	public Vector getCarPurContList(String emp_nm, String gubun1, String gubun2, String st_dt, String end_dt) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String dt = "";
					
			query = " SELECT \n"+
					"        a.rent_mng_id, a.rent_l_cd, a.rent_dt, g.user_nm as bus_nm, \n"+
					"        c.firm_nm, \n"+
					"        b.pur_req_dt, \n"+
					"        f.car_nm, e.car_name, i.doc_dt, \n"+
					"        (nvl(d.car_cs_amt,0) + nvl(d.car_cv_amt,0) + nvl(d.opt_cs_amt,0)+nvl(d.opt_cv_amt,0) + nvl(d.clr_cs_amt,0) + nvl(d.clr_cv_amt,0) - nvl(d.tax_dc_s_amt,0) - nvl(d.tax_dc_v_amt,0)) car_amt, \n"+
					"        j.car_off_nm, j.car_off_tel \n"+
					" from   cont a, car_pur b, client c, car_etc d, car_nm e, car_mng f, users g, car_pur_doc_list h, fine_doc i, \n"+
					"        (select a.rent_mng_id, a.rent_l_cd, b.emp_nm, c.car_off_nm, c.car_off_tel from commi a, car_off_emp b, car_off c where a.agnt_st='2' and a.emp_id=b.emp_id and b.car_off_id=c.car_off_id ) j "+
					" where  nvl(a.use_yn,'Y')='Y' and a.car_gu='1' and a.car_mng_id is NULL and a.dlv_dt is null \n"+
					"        and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
					"        and a.client_id=c.client_id \n"+
					"        and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd \n"+
					"        and d.car_id=e.car_id and d.car_seq=e.car_seq \n"+
					"        AND e.car_comp_id='0001' \n"+
					"        and e.car_comp_id=f.car_comp_id and e.car_cd=f.code \n"+
					"        and a.bus_id=g.user_id \n"+
					"        and b.rent_mng_id=h.rent_mng_id(+) and b.rent_l_cd=h.rent_l_cd(+) and '2'=h.agnt_st(+)  \n"+
					"        and h.doc_id=i.doc_id(+) \n"+
					"        and a.rent_mng_id=j.rent_mng_id(+) and a.rent_l_cd=j.rent_l_cd(+) \n"+
					"        and a.rent_dt >= '20121220'"+
					" ";


			if(gubun1.equals("1"))									query += " and i.doc_dt is not null";
			if(gubun1.equals("2"))									query += " and i.doc_dt is null";
			if(gubun1.equals("3"))									query += " and a.dlv_dt is null";

			if(gubun2.equals("1"))		dt = "a.rent_dt";
			if(gubun2.equals("2"))		dt = "b.pur_req_dt";

			if(!st_dt.equals("") && !end_dt.equals(""))				query += " and "+dt+" between '"+st_dt+"' and '"+end_dt+"'";
			if(!st_dt.equals("") && end_dt.equals(""))				query += " and "+dt+" like '%"+st_dt+"%'";

			if(gubun2.equals("1"))		query += " order by a.rent_dt, b.pur_req_dt, a.rent_l_cd ";
			if(gubun2.equals("2"))		query += " order by b.pur_req_dt, a.rent_dt, a.rent_l_cd ";

		try {
			pstmt = con.prepareStatement(query);
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
			System.out.println("[CarOfficeDatabase:getCarPurContList]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

	/*
	*	자동차납품공문 계약리스트
	*/
	public Hashtable getCarContListCase(String rent_mng_id, String rent_l_cd) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		String dt = "";
					
			query = " select"+
					" a.rent_mng_id, a.rent_l_cd, b.agnt_st, f.car_nm, e.car_name, d.opt, d.colo, decode(d.purc_gu,'0','면세','1','과세') purc_gu,"+
					" g.user_nm as bus_nm, a.rent_dt, a.dlv_dt, b.emp_id, c.emp_nm, i.doc_dt, j.firm_nm, k.car_no"+
					" from cont a, commi b, car_off_emp c, car_etc d, car_nm e, car_mng f, users g, car_pur_doc_list h, fine_doc i, client j, car_reg k  "+
					" where b.agnt_st='2' and a.rent_l_cd=b.rent_l_cd(+) and b.emp_id=c.emp_id "+
					" and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd"+
					" and d.car_id=e.car_id and d.car_seq=e.car_seq and e.car_comp_id=f.car_comp_id and e.car_cd=f.code"+
					" and b.rent_mng_id=h.rent_mng_id(+) and b.rent_l_cd=h.rent_l_cd(+) and b.agnt_st=h.agnt_st(+) and h.doc_id=i.doc_id(+)"+
					" and a.bus_id=g.user_id and a.client_id=j.client_id and a.car_mng_id=k.car_mng_id(+)"+
					" and a.rent_mng_id='"+rent_mng_id+"' and a.rent_l_cd='"+rent_l_cd+"'";


		try {
			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next())
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
			System.out.println("[CarOfficeDatabase:getCarContListCase]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return ht;
	}

	/*
	*	자동차납품공문 계약리스트
	*/
	public Hashtable getCarPurContListCase(String rent_mng_id, String rent_l_cd) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		String dt = "";
					
			query = " SELECT \n"+
					"        a.rent_mng_id, a.rent_l_cd, a.rent_dt, g.user_nm as bus_nm, "+
					"        decode(b.udt_st,'1','서울','2','부산','3','대전','4','이용자',decode(g.br_id,'S1','서울','B1','부산','D1','대전','서울')) as udt_st, \n"+
					"        c.firm_nm, c.o_addr, c.o_tel, c.con_agnt_nm, \n"+
					"        decode(b.pur_req_dt,'','즉시',to_char(to_date(b.pur_req_dt,'YYYYMMDD'),'MM/DD')) pur_req_dt, \n"+
					"        decode(b.pur_bus_st,'1','자체영업','2','영업사원영업','3','실적이관','4','에이전트영업') pur_bus_st, \n"+
					"        f.car_nm, e.car_name, e.car_comp_id, \n"+
                    "        CASE WHEN e.auto_yn = 'Y' THEN 'A/T' \n"+
                    "             WHEN e.auto_yn = 'N' AND INSTR(REPLACE(e.CAR_B,' ',''),'자동변속기') >0 THEN 'A/T' \n"+
                    "             WHEN e.auto_yn = 'N' AND INSTR(REPLACE(d.opt,' ',''),'변속기') >0 THEN 'A/T' \n"+
                    "             WHEN e.auto_yn = 'N' AND INSTR(REPLACE(UPPER(d.opt),' ',''),'DCT') >0 THEN 'A/T' \n"+
                    "             WHEN e.auto_yn = 'N' AND INSTR(REPLACE(UPPER(d.opt),' ',''),'C-TECH') >0 THEN 'A/T' \n"+
                    "             WHEN e.auto_yn = 'N' AND INSTR(REPLACE(UPPER(d.opt),' ',''),'A/T') >0 THEN 'A/T' \n"+
                    "             WHEN e.auto_yn = 'N' AND INSTR(REPLACE(e.CAR_B,' ',''),'무단변속기') >0 THEN 'A/T' \n"+
                    "             ELSE 'M/T' \n"+
                    "        END auto, \n"+
					"        d.opt, d.colo, d.in_col, d.garnish_col, decode(d.purc_gu,'0','면세','1','과세') purc_gu, \n"+
					"        h.agnt_st, h.emp_id, h.emp_nm, h.car_off_id, h.car_off_nm, \n"+
					"        h2.agnt_st as agnt_st2, h2.emp_id as emp_id2, h2.emp_nm as emp_nm2, h2.car_off_id as car_off_id2, h2.car_off_nm as car_off_nm2, \n"+					
					"        (nvl(d.car_cs_amt,0) + nvl(d.car_cv_amt,0) + nvl(d.opt_cs_amt,0)+nvl(d.opt_cv_amt,0) + nvl(d.clr_cs_amt,0) + nvl(d.clr_cv_amt,0) - nvl(d.tax_dc_s_amt,0) - nvl(d.tax_dc_v_amt,0)) car_amt \n"+
					" from   cont a, car_pur b, client c, car_etc d, car_nm e, car_mng f, users g,  \n"+
					"        (SELECT aa.agnt_st, aa.rent_mng_id, aa.rent_l_cd, bb.emp_id, bb.emp_nm, cc.car_off_id, cc.car_off_nm, dd.nm \n"+
					"         FROM   COMMI aa, CAR_OFF_EMP bb, CAR_OFF cc, CODE dd  \n"+
					"         WHERE  aa.agnt_st='1' AND aa.emp_id=bb.emp_id AND bb.car_off_id=cc.car_off_id AND cc.car_comp_id=DD.CODE AND dd.c_st='0001' \n"+
					"                AND dd.code='0001' \n"+
					"        ) h, \n"+
					"        (SELECT aa.agnt_st, aa.rent_mng_id, aa.rent_l_cd, bb.emp_id, bb.emp_nm, cc.car_off_id, cc.car_off_nm, dd.nm \n"+
					"         FROM   COMMI aa, CAR_OFF_EMP bb, CAR_OFF cc, CODE dd  \n"+
					"         WHERE  aa.agnt_st='2' AND aa.emp_id=bb.emp_id AND bb.car_off_id=cc.car_off_id AND cc.car_comp_id=DD.CODE AND dd.c_st='0001' \n"+
					"                AND dd.code='0001' \n"+
					"        ) h2 \n"+
					" where  a.rent_mng_id='"+rent_mng_id+"' and a.rent_l_cd='"+rent_l_cd+"' \n"+
					"        and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
					"        and a.client_id=c.client_id \n"+
					"        and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd \n"+
					"        and d.car_id=e.car_id and d.car_seq=e.car_seq \n"+
					"        AND e.car_comp_id='0001' \n"+
					"        and e.car_comp_id=f.car_comp_id and e.car_cd=f.code \n"+
					"        and a.bus_id=g.user_id \n"+
					"        AND a.rent_mng_id=h.rent_mng_id(+) AND a.rent_l_cd=h.rent_l_cd(+) \n"+
					"        AND a.rent_mng_id=h2.rent_mng_id(+) AND a.rent_l_cd=h2.rent_l_cd(+) \n"+					
					" ";


		try {
			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next())
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
			System.out.println("[CarOfficeDatabase:getCarPurContListCase]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return ht;
	}

	/*
	*	자동차납품공문 계약리스트
	*/
	public Hashtable getCarOffEmpGovNm(String emp_id) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		String dt = "";
					
			query = " select"+
					" a.*, b.car_off_nm, b.car_comp_id, c.nm as car_comp_nm"+
					" from car_off_emp a, car_off b, code c"+
					" where a.car_off_id=b.car_off_id and c.c_st='0001' and b.car_comp_id=c.code "+
					" and a.emp_id='"+emp_id+"'";

			if(emp_id.equals("0001")){
				query = " select"+
						" '특판팀' car_off_nm, c.nm||'(주)' as car_comp_nm"+
						" from code c"+
						" where c.c_st='0001' "+
						" and c.code='"+emp_id+"'";					
			}

		try {
			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next())
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
			System.out.println("[CarOfficeDatabase:getCarOffEmpGovNm]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return ht;
	}

	/*
	*	아르바이트- 영업사원 이메일 수집 20060202
	*/
	public Vector getCarEmpEmail(String emp_nm) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String dt = "";
					
			query = " SELECT b.emp_id, c.nm, a.car_off_st, a.car_off_nm, b.emp_nm, nvl(d.cont_cnt,0) cnt, a.car_off_tel, b.emp_m_tel, b.emp_email, b.use_yn "+
					" FROM car_off a, car_off_emp b, code c, "+
					"	 (select emp_id, count(*) cont_cnt from commi where agnt_st='1' group by emp_id) d "+
					" WHERE a.car_off_id=b.car_off_id "+
					" AND a.car_comp_id = c.code and c.C_ST='0001' "+
					" AND b.emp_id = d.emp_id(+) ";

			if(!emp_nm.equals(""))	query += " and b.emp_nm like '%"+emp_nm+"%'";
			else					query += " and b.emp_nm ='걍' ";

			query += " order by c.code,6 desc ";


		try {
			pstmt = con.prepareStatement(query);
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
			System.out.println("[CarOfficeDatabase:getCarEmpEmail]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}
     /**
     * 아르바이트- 영업사원 이메일 수집 20060202
     */
    public int updCarEmpEmail(String emp_id, String emp_email, String use_yn) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query="UPDATE car_off_emp SET emp_email=?, use_yn=? WHERE EMP_ID=? ";
            
       try{
            con.setAutoCommit(false);
            
            pstmt = con.prepareStatement(query);

			pstmt.setString(1, emp_email);
            pstmt.setString(2, use_yn);
            pstmt.setString(3, emp_id);
           
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

	//영업사원별 계약현황------------------------------------------------------------------------------------------------------------------------

    /**
     * 영업사원별 계약현황
     */
    public Vector getCarOffEmpRentStat(String dt, String ref_dt1, String ref_dt2, String gubun2, String gubun3, String gubun4, String gubun5, String sort, String gubun_nm) 
		throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
		String query = "";
		Vector vt = new Vector();

		String where = "";		

		if(!gubun2.equals(""))	where = " and b.agnt_st='"+gubun2+"'";

		if(dt.equals("1"))	where += " and a.rent_dt = to_char(sysdate,'YYYYMMDD')";
		if(dt.equals("2"))	where += " and a.rent_dt like to_char(sysdate,'YYYYMM')||'%'";
		if(dt.equals("4"))	where += " and a.rent_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')";


		query = " select"+
				" a.emp_id, e.nm, d.car_off_nm, c.emp_nm, c.emp_pos, a.cont_cnt, f.damdang_id, h.user_nm,"+
				" decode(f.cng_rsn,'1','최근계약','2','대면상담','3','최초등록','4','SMS배정','5','기타') cng_rsn, decode(c.agent_id,'','','에이전트') agent_st "+
				" from"+
				" ( select b.emp_id, count(*) cont_cnt "+
				"		   from cont a, commi b, cls_cont  cc,  "+
				"		   (select car_mng_id, max(rent_l_cd) rent_l_cd from cont where car_st<>'4' group by car_mng_id) c"+ //월렌트계약제외
				"   where  nvl(a.use_yn,'Y') in ('Y', 'N' ) and a.car_st in ('1','3') and a.rent_l_cd not like 'RM%' "+
				"          and a.rent_mng_id= cc.rent_mng_id(+) and a.rent_l_cd = cc.rent_l_cd(+) and nvl(cc.cls_st, '9')  not in ( '5', '7', '10', '4') \n"+
				"	"+where+" "+
				"   and a.car_mng_id=c.car_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) and a.rent_l_cd=b.rent_l_cd group by b.emp_id"+
				" ) a,"+
				" car_off_emp c, car_off d, (select * from code where c_st='0001') e,"+
				" car_off_edh f, (select emp_id, max(seq) seq from car_off_edh group by emp_id) g, users h"+
				" where a.emp_id=c.emp_id"+
				" and c.car_off_id=d.car_off_id and d.car_comp_id=e.code"+
				" and c.emp_id=f.emp_id and f.emp_id=g.emp_id and f.seq=g.seq and f.damdang_id=h.user_id";

		if(!gubun_nm.equals(""))	query += " and c.emp_nm like '%"+gubun_nm+"%' "; //이름검색 추가 2009. 07. 08 Gillsun

		if(!gubun3.equals(""))	query += " and d.car_comp_id='"+gubun3+"'";

		query += " order by a.cont_cnt desc, e.code, d.car_off_nm, c.emp_nm";

        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
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
            stmt.close();
        }catch(SQLException se){
			System.out.println("[CarOfficeDatabase:getCarOffEmpRentStat]"+se);
			se.printStackTrace();
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

    /**
     * 영업사원 계약 전체조회.
     */
    public CommiBean [] getCommiAll(String emp_id, String dt, String ref_dt1, String ref_dt2, String gubun2) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";

		String where = "";		

		if(dt.equals("1"))	where = " and b.rent_dt = to_char(sysdate,'YYYYMMDD')";
		if(dt.equals("2"))	where = " and b.rent_dt like to_char(sysdate,'YYYYMM')||'%' ";
		if(dt.equals("4"))	where = " and b.rent_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')";

		if(!gubun2.equals("")) where += " and a.agnt_st = '"+gubun2+"'";

        query = "select '' as CON_MON,substr(b.rent_dt,1,4)||'-'||substr(b.rent_dt,5,2)||'-'||substr(b.rent_dt,7,2) as RENT_DT,b.dlv_dt as DLV_DT,\n"
				        + "c.firm_nm as FIRM_NM,\n"
				        + "c.client_nm as CLIENT_NM,\n"
				        + "c.client_st as CLIENT_ST,\n"
				        + "h.car_nm||' '||e.car_name as CAR_NAME,\n"
				        + "f.user_nm as USER_NM,\n"
				        + "substr(g.INIT_REG_DT,1,4)||'-'||substr(g.INIT_REG_DT,5,2)||'-'||substr(g.INIT_REG_DT,7,2) as INIT_REG_DT, g.car_no as CAR_NO,\n"
        				+ "a.rent_mng_id as RENT_MNG_ID,\n" 
				        + "a.rent_l_cd as RENT_L_CD,\n"
				        + "a.emp_id as EMP_ID,\n"
				        + "a.agnt_st as AGNT_ST,\n"
				        + "a.commi as COMMI,\n"
				        + "a.inc_amt as INC_AMT,\n"
				        + "a.res_amt as RES_AMT,\n"
				        + "a.tot_amt as TOT_AMT,\n"
				        + "a.dif_amt as DIF_AMT,\n"
				        + "a.sup_dt as SUP_DT,\n"
				        + "a.rel as REL, decode(a.emp_acc_nm,i.emp_nm,'',a.emp_acc_nm) emp_acc_nm, i.emp_nm \n"
				+ "from commi a, cont b, client c, car_etc d, car_nm e, users f, car_reg g, car_mng h , cls_cont cc, car_off_emp i  \n"
				+ "where a.emp_id='" + emp_id + "' "+where+" \n"
				+ "and b.car_st not in ('2' , '4' )  and nvl(b.use_yn,'Y') in ('Y', 'N') \n"//and a.agnt_st = '1' 
				+ "and a.rent_mng_id = b.rent_mng_id\n"
				+ "and a.rent_l_cd = b.rent_l_cd\n"
				+ "and b.client_id = c.client_id\n"
				+ "and a.rent_mng_id = d.rent_mng_id(+)\n"
				+ "and a.rent_l_cd = d.rent_l_cd\n"
				+ "and d.car_id = e.car_id(+) and d.car_seq=e.car_seq(+)\n"
				+ "and b.bus_id = f.user_id\n"
				+ "and b.car_mng_id = g.car_mng_id(+)\n"
				+ "and e.car_comp_id=h.car_comp_id and e.car_cd=h.code and a.emp_id=i.emp_id "
				+ " and  a.rent_mng_id= cc.rent_mng_id(+) and a.rent_l_cd = cc.rent_l_cd(+) and nvl(cc.cls_st, '9')  not in ( '5', '7', '10', '4') \n"
				+ " order by b.use_yn desc, b.rent_dt";

        Collection col = new ArrayList();
        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
                
				col.add(makeCommiBean(rs));
 
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			System.out.println("[CarOfficeDatabase:getCommiAll(String emp_id, String dt)]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (CommiBean[])col.toArray(new CommiBean[0]);
    }

	/**
     * 제조사 전체 조회.
     */
    public CarCompBean [] getCarCompAllNew(String car_origin) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = "SELECT C_ST, CODE, NM_CD, NM, ETC, APP_ST, CMS_BK, BIGO \n"
        		+ "FROM CODE a\n"
        		+ "where C_ST='0001'\n"
        		+ "and CODE <> '0000' and code<>'1000'";

		if(!car_origin.equals("")) query += " and app_st='"+car_origin+"'";

		query += " ORDER BY NM";



        Collection col = new ArrayList();
        try{
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery(query);
            while(rs.next()){
                
				col.add(makeCarCompBean(rs));
 
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
        return (CarCompBean[])col.toArray(new CarCompBean[0]);
    }

    /**
     * 자동차영업소 사원 등록.
     */
    public String insertCarOffEmp(CarOffEmpBean bean, CarOffEdhBean bean2, CarOffBean bean3) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        PreparedStatement pstmt3 = null;
        PreparedStatement pstmt4 = null;
        ResultSet rs = null;
		String emp_id = "";
        String query = "", query1 = "", query2 = "", query3 = "";
        int count = 0;

        query3="INSERT INTO CAR_OFF(CAR_OFF_ID,\n"
								+ "CAR_COMP_ID,\n"
								+ "CAR_OFF_NM,\n"
								+ "CAR_OFF_ST,\n"
								+ "OWNER_NM,\n"
								+ "CAR_OFF_TEL,\n"
								+ "CAR_OFF_FAX,\n"
								+ "CAR_OFF_POST,\n"
								+ "CAR_OFF_ADDR,\n"
								+ "BANK,\n"
								+ "ACC_NO,\n"
								+ "ACC_NM,\n"
								+ "USE_YN, enp_no, bank_cd )\n"
            + "SELECT nvl(lpad(max(CAR_OFF_ID)+1,5,'0'),'00001'),?,?,?,?,?,?,?,?,?,?,?,'Y',?, ? \n"
            + "FROM CAR_OFF\n";

		query2 = "INSERT INTO car_off_edh VALUES(?,1,?,?,?,?,?) ";
		query1 = "SELECT nvl(lpad(max(EMP_ID)+1,6,'0'),'000001') FROM car_off_emp ";   
        query  = "INSERT INTO CAR_OFF_EMP(EMP_ID,\n"
								+ "CAR_OFF_ID,\n"
								+ "CUST_ST,\n"
								+ "EMP_NM,\n"
								+ "EMP_SSN,\n"
								+ "EMP_M_TEL,\n"
								+ "EMP_POS,\n"
								+ "EMP_EMAIL,\n"
								+ "EMP_BANK,\n"
								+ "EMP_ACC_NO,\n"
								+ "EMP_ACC_NM,EMP_POST,EMP_ADDR,ETC,reg_dt,reg_id,emp_h_tel,emp_sex,use_yn, sms_denial_rsn, bank_cd)\n"
            + " VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";
            
       try{
            con.setAutoCommit(false);
            
            pstmt4 = con.prepareStatement(query3);
            pstmt4.setString(1,  bean3.getCar_comp_id().trim());
            pstmt4.setString(2,  bean3.getCar_off_nm().trim());
            pstmt4.setString(3,  bean3.getCar_off_st().trim());
            pstmt4.setString(4,  bean3.getOwner_nm().trim());
            pstmt4.setString(5,  bean3.getCar_off_tel().trim());
            pstmt4.setString(6,  bean3.getCar_off_fax().trim());
            pstmt4.setString(7,  bean3.getCar_off_post().trim());
            pstmt4.setString(8,  bean3.getCar_off_addr().trim());
            pstmt4.setString(9,  bean3.getBank().trim());
            pstmt4.setString(10, bean3.getAcc_no().trim());
            pstmt4.setString(11, bean3.getAcc_nm().trim());           
            pstmt4.setString(12, bean3.getEnp_no().trim());           
            pstmt4.setString(13, bean3.getBank_cd().trim());           
            count = pstmt4.executeUpdate();
			pstmt4.close();

            pstmt1 = con.prepareStatement(query1);
			rs = pstmt1.executeQuery();
			while(rs.next()){
				emp_id = rs.getString(1);
			}
			rs.close();
			pstmt1.close();

			pstmt2 = con.prepareStatement(query);
			pstmt2.setString(1, emp_id);
            pstmt2.setString(2, bean.getCar_off_id().trim());
            pstmt2.setString(3, bean.getCust_st().trim());
            pstmt2.setString(4, bean.getEmp_nm().trim());
            pstmt2.setString(5, bean.getEmp_ssn().trim());
            pstmt2.setString(6, bean.getEmp_m_tel().trim());
            pstmt2.setString(7, bean.getEmp_pos().trim());
            pstmt2.setString(8, bean.getEmp_email().trim());
            pstmt2.setString(9, bean.getEmp_bank().trim());
            pstmt2.setString(10, bean.getEmp_acc_no().trim());
            pstmt2.setString(11, bean.getEmp_acc_nm().trim());
            pstmt2.setString(12, bean.getEmp_post().trim());
            pstmt2.setString(13, bean.getEmp_addr().trim());
            pstmt2.setString(14, bean.getEtc().trim());
			pstmt2.setString(15, bean.getReg_dt().trim());
			pstmt2.setString(16, bean.getReg_id().trim());
			pstmt2.setString(17, bean.getEmp_h_tel().trim());
			pstmt2.setString(18, bean.getEmp_sex().trim());
			pstmt2.setString(19, bean.getUse_yn());
			pstmt2.setString(20, bean.getSms_denial_rsn());          
            pstmt2.setString(21, bean.getBank_cd().trim());           
            count = pstmt2.executeUpdate();
			pstmt2.close();

			if(count>0){
				pstmt3 = con.prepareStatement(query2);
				pstmt3.setString(1, emp_id);
				pstmt3.setString(2, bean2.getDamdang_id());
				pstmt3.setString(3, bean2.getCng_dt());
				pstmt3.setString(4, bean2.getCng_rsn());
				pstmt3.setString(5, bean2.getReg_id());
				pstmt3.setString(6, bean2.getReg_dt());
				count = pstmt3.executeUpdate();
				pstmt3.close();
				if(count>0)	con.commit();
				else		con.rollback();
			}else{
				con.rollback();
			}
            
        }catch(Exception se){
			System.out.println("[CarOfficeDatabase:insertCarOffEmp(CarOffEmpBean bean, CarOffEdhBean bean2, CarOffBean bean3)]"+ se);
			se.printStackTrace();
            try{
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt4 != null) pstmt4.close();
				if(rs != null) rs.close();
                if(pstmt1 != null) pstmt1.close();
                if(pstmt2 != null) pstmt2.close();
                if(pstmt3 != null) pstmt3.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return emp_id;
    }


    /**
     * 자동차영업소 사원 휴대폰번호 수정 20050722.금
     */
    public int updateCarOffEmp(String emp_id, String file_st, String file_name, String file_gubun) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
		if(file_st.equals("1")){
	        query=" UPDATE car_off_emp SET file_name1 = ?, file_gubun1 = ? WHERE emp_id=? ";
		}else if(file_st.equals("2")){
	        query=" UPDATE car_off_emp SET file_name2 = ?, file_gubun2 = ? WHERE emp_id=? ";				
		}else if(file_st.equals("3")){
	        query=" UPDATE car_off_emp SET emp_ssn = replace(?,'-','') WHERE emp_id=? ";				
		}else if(file_st.equals("4")){
	        query=" UPDATE car_off_emp SET emp_post=?, emp_addr = replace(?,'-','') WHERE emp_id=? ";				
		}else if(file_st.equals("5")){
	        query=" UPDATE car_off_emp SET cust_st = ? WHERE emp_id=? ";				
		}
            
       try{
            con.setAutoCommit(false);

            pstmt = con.prepareStatement(query);
			pstmt.setString(1, file_name);
			if(file_st.equals("3") || file_st.equals("5")){
		        pstmt.setString(2, emp_id);
			}else{
				pstmt.setString(2, file_gubun);
				pstmt.setString(3, emp_id);
			}
            count = pstmt.executeUpdate();             
			pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
                con.rollback();

				System.out.println("emp_id="+emp_id);
				System.out.println("file_st="+file_st);
				System.out.println("file_name="+file_name);
				System.out.println("file_gubun="+file_gubun);

            }catch(SQLException _ignored){}
              throw new DatabaseException("exception:updateCarOffEmp(String emp_id, String file_st, String file_name)");
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
     * 자동차영업소 사원 수정. 담당이력추가20050818.
     */
    public int updateCarOffEmp(CarOffEmpBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query="";
        int count = 0;
        
        query  = "UPDATE CAR_OFF_EMP\n"
        		+ "SET CAR_OFF_ID=?,\n"
					+ "CUST_ST=?,\n"
					+ "EMP_NM=?,\n"
					+ "EMP_SSN=?,\n"
					+ "EMP_M_TEL=?,\n"
					+ "EMP_POS=?,\n"
					+ "EMP_EMAIL=?,\n"
					+ "EMP_BANK=?,\n"
					+ "EMP_ACC_NO=?,\n"
					+ "EMP_ACC_NM=?,EMP_POST=?,EMP_ADDR=?,ETC=?,UPD_DT=replace(?, '-', ''),UPD_ID=?,EMP_H_TEL=?,EMP_SEX=?,USE_YN=?, sms_denial_rsn=? \n"
				+ "WHERE EMP_ID=?\n";
           

       try{
            con.setAutoCommit(false);

            
            pstmt = con.prepareStatement(query);
            pstmt.setString(1, bean.getCar_off_id().trim());
            pstmt.setString(2, bean.getCust_st().trim());
            pstmt.setString(3, bean.getEmp_nm().trim());
            pstmt.setString(4, bean.getEmp_ssn().trim());
            pstmt.setString(5, bean.getEmp_m_tel().trim());
            pstmt.setString(6, bean.getEmp_pos().trim());
            pstmt.setString(7, bean.getEmp_email().trim());
            pstmt.setString(8, bean.getEmp_bank().trim());
            pstmt.setString(9, bean.getEmp_acc_no().trim());
            pstmt.setString(10, bean.getEmp_acc_nm().trim());
            pstmt.setString(11, bean.getEmp_post().trim());
            pstmt.setString(12, bean.getEmp_addr().trim());
            pstmt.setString(13, bean.getEtc().trim());
			pstmt.setString(14, bean.getUpd_dt());
			pstmt.setString(15, bean.getUpd_id());
			pstmt.setString(16, bean.getEmp_h_tel());
			pstmt.setString(17, bean.getEmp_sex());
			pstmt.setString(18, bean.getUse_yn());
			pstmt.setString(19, bean.getSms_denial_rsn());
            pstmt.setString(20, bean.getEmp_id().trim());                                    
            count = pstmt.executeUpdate();
			pstmt.close();
	    	con.commit();
        }catch(Exception se){
            try{
                con.rollback();
            }catch(SQLException _ignored){}
				System.out.println("[CarOfficeDatabase:updateCarOffEmp(CarOffEmpBean bean)]"+ se);
				System.out.println("[CarOfficeDatabase:updateCarOffEmp(CarOffEmpBean bean)]"+ bean.getEmp_id());
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
     * 문자보내기
     */
    public int[] sendMail_V5(String sendphone, String sendname, String[] destphone, String[] destname, String msg, String[] pr, String rqdate) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;

        String query = "";
		String query2 = "";
		String cmid = "";

        int[] count = new int[2];
                
		query2 = " select to_char(sysdate,'YYYYMMDDhh24miss')||nvl(ltrim(to_char(to_number(max(substr(cmid,15,5))+1), '000')), '001') cmid"+
				 " from   ums_data "+
				 " where  cmid LIKE to_char(sysdate,'YYYYMMDDhh24miss')||'%'";

        query=" INSERT INTO ums_data "+
				" ( cmid, send_phone, send_name, dest_phone, dest_name, request_time, status, msg_type, msg_body ) "
            + " VALUES "+
				" ( ?, replace(?,'-',''), substr(?,1,10), replace(?,'-',''), substr(?,1,10), to_char(sysdate"+rqdate+",'YYYYMMDDhh24miss'), 0, 0, ?) ";

		if(sendphone.equals(""))	sendphone = "027570802";
		if(sendname.equals(""))		sendname  = "아마존카";

       try{
            con.setAutoCommit(false);

            pstmt = con.prepareStatement(query);
			pstmt2 = con.prepareStatement(query2);
            
			for(int i=0; i<destphone.length; i++){
				if(!destphone[i].equals("")){
					for(int j=0; j<pr.length; j++){
						if(i==AddUtil.parseInt(pr[j])){							
							rs = pstmt2.executeQuery();
							if(rs.next())
							{				
								cmid	 = rs.getString(1);
							}
							rs.close();

							pstmt.setString(1, cmid		);
							pstmt.setString(2, sendphone);
							pstmt.setString(3, sendname);
							pstmt.setString(4, destphone[i]);
							pstmt.setString(5, destname[i]);
							pstmt.setString(6, msg);
				   
							count[0] = pstmt.executeUpdate();
							count[1] += count[0];
							
							break;

						}
					}
				}
			}
             
            pstmt.close();
			pstmt2.close();
            con.commit();

        }catch(Exception se){
            try{
                con.rollback();
            }catch(SQLException _ignored){}
				se.printStackTrace();
				throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
				if(rs != null)		rs.close();
				if(pstmt2 != null)	pstmt2.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return count;
    }

    /**
     * 문자보내기
     */
    public int[] sendMail_V5_req(String sendphone, String sendname, String[] destphone, String[] destname, String msg, String[] pr, String req_time, String rqdate) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;

        String query = "";
		String query2 = "";
		String cmid = "";

        int[] count = new int[2];
                
		query2 = " select to_char(sysdate,'YYYYMMDDhh24miss')||nvl(ltrim(to_char(to_number(max(substr(cmid,15,5))+1), '000')), '001') cmid"+
				 " from   ums_data "+
				 " where  cmid LIKE to_char(sysdate,'YYYYMMDDhh24miss')||'%'";

        query=" INSERT INTO ums_data "+
				" ( cmid, send_phone, send_name, dest_phone, dest_name, request_time, status, msg_type, msg_body, etc1 ) "
            + " VALUES "+
				" ( ?, replace(?,'-',''), substr(?,1,10), replace(?,'-',''), substr(?,1,10), to_char(to_date('"+req_time+"','YYYYMMDDhh24miss')"+rqdate+",'YYYYMMDDhh24miss'), 0, 0, ?, 'req') ";

		if(sendphone.equals(""))	sendphone = "027570802";
		if(sendname.equals(""))		sendname  = "아마존카";

       try{
            con.setAutoCommit(false);

            pstmt = con.prepareStatement(query);
			pstmt2 = con.prepareStatement(query2);
            
			for(int i=0; i<destphone.length; i++){
				if(!destphone[i].equals("")){
					for(int j=0; j<pr.length; j++){
						if(i==AddUtil.parseInt(pr[j])){							
							rs = pstmt2.executeQuery();   	
							if(rs.next())
							{				
								cmid	 = rs.getString(1);
							}
							rs.close();

							pstmt.setString(1, cmid		);
							pstmt.setString(2, sendphone);
							pstmt.setString(3, sendname);
							pstmt.setString(4, destphone[i]);
							pstmt.setString(5, destname[i]);
							pstmt.setString(6, msg);
				   
							count[0] = pstmt.executeUpdate();
							count[1] += count[0];
							
							break;

						}
					}
				}
			}
			pstmt2.close();             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
                con.rollback();
            }catch(SQLException _ignored){}
				se.printStackTrace();
				throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
				if(rs != null)		rs.close();
				if(pstmt2 != null)	pstmt2.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return count;
    }

	/*
	*	문자결과-(발신)
	*/
	public Vector getSmsResult_V5(String gubun, String dest_gubun, String send_dt, String st_dt, String end_dt, String s_bus, String sort, String sort_gubun, String s_bus_nm) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", subQuery="", subQuery2="", subQuery3="";

		//발송대상구분
		//if(!dest_gubun.equals(""))	subQuery += " and etc2 = '"+dest_gubun+"' ";
		//발송일자구분 1:당일, 2:전일, 3:기간, 4:당월
		if(send_dt.equals("1")){
			subQuery2 += " where to_char(send_time, 'yyyymmdd') = to_char(sysdate,'yyyymmdd') ";
			subQuery3 += " where to_char(send_time, 'yyyymmdd')=to_char(sysdate,'yyyymmdd') and ";
		}else if(send_dt.equals("2")){
			subQuery2 += " where to_char(send_time, 'yyyymmdd') =to_char(sysdate-1,'yyyymmdd') ";
			subQuery3 += " where to_char(send_time, 'yyyymmdd')=to_char(sysdate-1,'yyyymmdd') and ";
		}else if(send_dt.equals("3")){
			subQuery2 += " where to_char(send_time, 'yyyymmdd')  between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') ";
			subQuery3 += " where to_char(send_time, 'yyyymmdd') between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') and ";
		}else if(send_dt.equals("4")){
			subQuery2 += " where to_char(send_time, 'yyyymmdd') between to_char(sysdate,'yyyymm')||'01' and to_char(sysdate,'yyyymmdd') ";
			subQuery3 += " where to_char(send_time, 'yyyymmdd') between to_char(sysdate,'yyyymm')||'01' and to_char(sysdate,'yyyymmdd') and ";
		}else{
			subQuery2 += " ";
			subQuery3 += " where ";
		}
		//발신자
		if(!s_bus.equals(""))	subQuery += " and (send_name ='"+s_bus+"' or send_name like '%"+s_bus_nm+"%')";
		//정렬
		if(sort.equals("1"))		subQuery += " order by send_name "+sort_gubun;
		else if(sort.equals("2"))	subQuery += " order by cnt "+sort_gubun;
		else if(sort.equals("3"))	subQuery += " order by r_cnt "+sort_gubun;
		else if(sort.equals("4"))	subQuery += " order by send_time "+sort_gubun;
		else						subQuery += " order by send_time desc ";

		query = 
" select nvl(d.user_nm,a.send_name) send_name, b.cnt, c.cnt R_CNT, b.msg_body, a.send_time, decode(a.msg_type,'5','장문자','단문자') msg_type "+
" from ums_log a, "+
" 	(select min(cmid) cmid, msg_body, count(*) cnt  "+
" 	 from ums_log "+subQuery2+
" 	 group by msg_body ) b, "+
" 	(select min(cmid) cmid, msg_body, count(*) cnt  "+
" 	 from ums_log "+subQuery3+" call_result in (4100,6600) "+
" 	 group by msg_body ) c, users d   "+
" where a.msg_body = b.msg_body "+
" and a.cmid = b.cmid "+
" and a.msg_body = c.msg_body "+
" and a.cmid = c.cmid  "+
" and a.send_name=d.user_id(+)"+
subQuery;

 	
		try {
			pstmt = con.prepareStatement(query);
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
//			System.out.println("[CarOfficeDatabase:getSmsResult_V5()]"+ query);
		} catch (SQLException e) {
			System.out.println("[CarOfficeDatabase:getSmsResult_V5()]"+ e);
			System.out.println("[CarOfficeDatabase:getSmsResult_V5()]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}	

	/*
	*	문자결과-(발신)
	*/
	public Vector getSmsResult_V5_req(String gubun, String dest_gubun, String send_dt, String st_dt, String end_dt, String s_bus, String sort, String sort_gubun, String s_bus_nm) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", subQuery="", subQuery2="", subQuery3="";

		//발송대상구분
		//if(!dest_gubun.equals(""))	subQuery += " and etc2 = '"+dest_gubun+"' ";
		//발송일자구분 1:당일, 2:전일, 3:기간, 4:당월
		if(send_dt.equals("1")){
			subQuery2 += " where to_char(send_time, 'yyyymmdd') = to_char(sysdate,'yyyymmdd') ";
			subQuery3 += " where to_char(send_time, 'yyyymmdd')=to_char(sysdate,'yyyymmdd') and ";
		}else if(send_dt.equals("2")){
			subQuery2 += " where to_char(send_time, 'yyyymmdd') =to_char(sysdate-1,'yyyymmdd') ";
			subQuery3 += " where to_char(send_time, 'yyyymmdd')=to_char(sysdate-1,'yyyymmdd') and ";
		}else if(send_dt.equals("3")){
			subQuery2 += " where to_char(send_time, 'yyyymmdd')  between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') ";
			subQuery3 += " where to_char(send_time, 'yyyymmdd') between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') and ";
		}else if(send_dt.equals("4")){
			subQuery2 += " where to_char(send_time, 'yyyymmdd') between to_char(sysdate,'yyyymm')||'01' and to_char(sysdate,'yyyymmdd') ";
			subQuery3 += " where to_char(send_time, 'yyyymmdd') between to_char(sysdate,'yyyymm')||'01' and to_char(sysdate,'yyyymmdd') and ";
		}else{
			subQuery2 += " ";
			subQuery3 += " where ";
		}

		//발신자
		if(!s_bus.equals(""))	subQuery += " and (send_name ='"+s_bus+"' or send_name like '%"+s_bus_nm+"%')";

		if(dest_gubun.equals("0")) subQuery += " and a.etc1='req' and a.status=0 ";
		if(dest_gubun.equals("1")) subQuery += " and a.etc1='req' and a.status=1 ";
		if(dest_gubun.equals("9")) subQuery += " and a.etc1 is null ";

		//정렬
		if(sort.equals("1"))		subQuery += " order by send_name "+sort_gubun;
		else if(sort.equals("2"))	subQuery += " order by cnt "+sort_gubun;
		else if(sort.equals("4"))	subQuery += " order by request_time "+sort_gubun;
		else						subQuery += " order by request_time desc ";

		query = 
" select a.cmid, nvl(d.user_nm,a.send_name) send_name, b.cnt, b.msg_body, a.send_time, a.request_time, a.status, decode(a.msg_type,'5','장문자','단문자') msg_type "+
" from ums_data a, "+
" 	(select min(cmid) cmid, msg_body, count(*) cnt  "+
" 	 from ums_data "+subQuery2+
" 	 group by msg_body ) b, "+
" 	 users d   "+
" where a.msg_body = b.msg_body "+
" and a.cmid = b.cmid "+
" and a.send_name=d.user_id(+)"+
subQuery;

 	
		try {
			pstmt = con.prepareStatement(query);
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
			System.out.println("[CarOfficeDatabase:getSmsResult_V5_req()]"+ e);
			System.out.println("[CarOfficeDatabase:getSmsResult_V5_req()]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}	

	/*
	*	문자결과(수신) 
	*/
	public Vector getSmsResult2_V5(String gubun, String dest_gubun, String rslt_dt, String st_dt, String end_dt, String dest_nm, String sort, String sort_gubun) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", subQuery="", subQuery2="";

		//발송대상구분
		if(!dest_gubun.equals(""))	subQuery += " and etc2 = '"+dest_gubun+"' ";
		//수신일자구분 1:당일, 2:전일, 3:기간, 4:당월
		if(rslt_dt.equals("1"))			subQuery2 += " and  to_char(report_time, 'yyyymmdd')  =to_char(sysdate,'yyyymmdd') ";
		else if(rslt_dt.equals("2"))	subQuery2 += " and  to_char(report_time, 'yyyymmdd') =to_char(sysdate-1,'yyyymmdd') ";
		else if(rslt_dt.equals("3"))	subQuery2 += " and  to_char(report_time, 'yyyymmdd')  between '"+st_dt+"' and '"+end_dt+"' ";
		else if(rslt_dt.equals("4"))	subQuery2 += " and  to_char(report_time, 'yyyymmdd')  between to_char(sysdate,'yyyymm')||'01' and to_char(sysdate,'yyyymmdd') ";

		//정렬
		if(sort.equals("1"))		subQuery += " order by send_name "+sort_gubun;
		else if(sort.equals("2"))	subQuery += " order by report_time "+sort_gubun;
		else						subQuery += " order by report_time desc ";

		query = " SELECT * from ums_log where dest_name='"+dest_nm+"'  "+subQuery2+subQuery;

		try {
			pstmt = con.prepareStatement(query);
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
			System.out.println("[CarOfficeDatabase:getSmsResult2_V5()]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}	

	/*
	*	문자결과-메세지별 발송건수
	*/
	public Hashtable getSmsResult_V5(String msg, String senddate) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = 
				" select a.* "+
				" from ums_log a, "+
				" 	(select min(cmid) cmid, msg_body, request_time, count(*) cnt  "+
				" 	 from ums_log  "+
				" 	 group by msg_body, request_time ) b, "+
				" 	(select min(cmid) cmid, msg_body, request_time, count(*) cnt  "+
				" 	 from ums_log where call_result in (4100,6600) "+
				" 	 group by msg_body, request_time ) c   "+
				" where "+
				" a.msg_body = ?  "+
				" and a.msg_body = b.msg_body and a.request_time = b.request_time and a.cmid = b.cmid "+
				" and a.msg_body = c.msg_body and a.request_time = b.request_time and a.cmid = c.cmid  ";


		try {
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, msg);
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
			System.out.println("[CarOfficeDatabase:getSmsResult_V5(String msg, String senddate)]"+ e);
			System.out.println("[CarOfficeDatabase:getSmsResult_V5(String msg, String senddate)]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return ht;
	}	

	/*
	*	문자결과-메세지별 발송건수
	*/
	public Hashtable getSmsResult_V5_req(String cmid, String senddate) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = 
				" select a.* "+
				" from ums_data a, "+
				" 	(select min(cmid) cmid, msg_body, request_time, count(*) cnt  "+
				" 	 from ums_data  "+
				" 	 group by msg_body, request_time ) b   "+
				" where "+
				"  a.cmid = ?  "+
				" and a.msg_body = b.msg_body and a.request_time = b.request_time and a.cmid = b.cmid ";


		try {
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, cmid);
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
//			System.out.println("[CarOfficeDatabase:getSmsResult_V5_req(String msg, String senddate)]"+ query);
		} catch (SQLException e) {
			System.out.println("[CarOfficeDatabase:getSmsResult_V5_req(String msg, String senddate)]"+ e);
			System.out.println("[CarOfficeDatabase:getSmsResult_V5_req(String msg, String senddate)]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return ht;
	}	

	/*
	*	문자결과-메세지별 발송건수
	*/
	public Vector getSmsResult_msg_V5(String msg) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = 
				" SELECT * "+
				" from ums_log a, "+
				" 	 (select min(cmid) cmid, msg_body, request_time, count(*) cnt from ums_log group by msg_body, request_time) b "+
				" where "+
				" a.msg_body=? "+
				" and a.msg_body = b.msg_body and a.request_time = b.request_time "+
				" order by a.dest_name ";
 	
		try {
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, msg);
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
			System.out.println("[CarOfficeDatabase:getSmsResult_msg_V5(String msg)]"+ e);
			System.out.println("[CarOfficeDatabase:getSmsResult_msg_V5(String msg)]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}	

	/*
	*	문자결과-메세지별 발송건수
	*/
	public Vector getSmsResult_msg_V5_req(String cmid) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = 
				" SELECT a.*, to_char(a.request_time, 'yyyymmdd') req_dt, substr(to_char(a.request_time, 'yyyymmddhh24miss') ,9,2) req_dt_h, substr(to_char(a.request_time, 'yyyymmddhh24miss'),11,2) req_dt_s "+
				" from ums_data a, "+
				" 	 (select min(cmid) cmid, msg_body, request_time, count(*) cnt from ums_data group by msg_body, request_time) b "+
				" where "+
				" a.msg_body in (select msg_body from ums_data where cmid='"+cmid+"') "+
				" and a.msg_body = b.msg_body and a.request_time = b.request_time "+
				" order by a.status, a.dest_name ";
 	
		try {
			pstmt = con.prepareStatement(query);
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
			System.out.println("[CarOfficeDatabase:getSmsResult_msg_V5_req(String msg)]"+ e);
			System.out.println("[CarOfficeDatabase:getSmsResult_msg_V5_req(String msg)]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}	

    /**
     * 문자보내기
     */
    public int[] sendMail_V5(String sendphone, String sendname, String[] destphone, String[] destname, String msg_type, String msg_subject, String msg, String[] pr, String rqdate, String user_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;

        String query = "";
		String query2 = "";
		String cmid = "";

        int[] count = new int[2];
                
		query2 = " select to_char(sysdate,'YYYYMMDDhh24miss')||nvl(ltrim(to_char(to_number(max(substr(cmid,15,5))+1), '000')), '001') cmid"+
				 " from   ums_data "+
				 " where  cmid LIKE to_char(sysdate,'YYYYMMDDhh24miss')||'%'";

        query=" INSERT INTO ums_data "+
				" ( cmid, send_phone, send_name, dest_phone, dest_name, request_time, status, msg_type, subject, msg_body, etc4 ) "
            + " VALUES "+
				" ( ?, replace(?,'-',''), substr(?,1,10), replace(?,'-',''), substr(?,1,10), sysdate"+rqdate+", 0, ?, ?, ?, ?) ";

		if(sendphone.equals(""))	sendphone = "027570802";
		if(sendname.equals(""))		sendname  = "아마존카";

       try{
            con.setAutoCommit(false);

            pstmt = con.prepareStatement(query);
			pstmt2 = con.prepareStatement(query2);
            
			for(int i=0; i<destphone.length; i++){
				if(!destphone[i].equals("")){
					for(int j=0; j<pr.length; j++){
						if(i==AddUtil.parseInt(pr[j])){
							rs = pstmt2.executeQuery();
							if(rs.next())
							{				
								cmid	 = rs.getString(1);
							}
							rs.close();

							pstmt.setString(1, cmid		);
							pstmt.setString(2, sendphone);
							pstmt.setString(3, sendname);
							pstmt.setString(4, destphone[i]);
							pstmt.setString(5, destname[i]);
							pstmt.setString(6, msg_type		);
							pstmt.setString(7, msg_subject	);
							pstmt.setString(8, msg);
							pstmt.setString(9, user_id);
				   
							count[0] = pstmt.executeUpdate();
							count[1] += count[0];
							
							break;

						}
					}
				}
			}
			pstmt2.close();             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
                con.rollback();
            }catch(SQLException _ignored){}
				se.printStackTrace();
				throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
				if(rs != null)		rs.close();
				if(pstmt2 != null)	pstmt2.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return count;
    }

    /**
     * 문자보내기
     */
    public int[] sendMail_V5(String sendphone, String sendname, String[] destphone, String[] destname, String msg_type, String msg_subject, String msg, String[] pr, String rqdate, String user_id, String dest_gubun) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;

        String query = "";
		String query2 = "";
		String cmid = "";

        int[] count = new int[2];
                
		query2 = " select to_char(sysdate,'YYYYMMDDhh24miss')||nvl(ltrim(to_char(to_number(max(substr(cmid,15,5))+1), '000')), '001') cmid"+
				 " from   ums_data "+
				 " where  cmid LIKE to_char(sysdate,'YYYYMMDDhh24miss')||'%'";

        query=" INSERT INTO ums_data "+
				" ( cmid, send_phone, send_name, dest_phone, dest_name, request_time, status, msg_type, subject, msg_body, etc4, etc5 ) "
            + " VALUES "+
				" ( ?, replace(?,'-',''), substr(?,1,10), replace(?,'-',''), substr(?,1,10), sysdate"+rqdate+", 0, ?, ?, ?, ?, ?) ";

		if(sendphone.equals(""))	sendphone = "027570802";
		if(sendname.equals(""))		sendname  = "아마존카";

       try{
            con.setAutoCommit(false);

            pstmt = con.prepareStatement(query);
			pstmt2 = con.prepareStatement(query2);
            
			for(int i=0; i<destphone.length; i++){
				if(!destphone[i].equals("")){
					for(int j=0; j<pr.length; j++){
						if(i==AddUtil.parseInt(pr[j])){
							rs = pstmt2.executeQuery();  	
							if(rs.next())
							{				
								cmid	 = rs.getString(1);
							}
							rs.close();							

							pstmt.setString(1, cmid			);
							pstmt.setString(2, sendphone	);
							pstmt.setString(3, sendname		);
							pstmt.setString(4, destphone[i]	);
							pstmt.setString(5, destname[i]	);
							pstmt.setString(6, msg_type		);
							pstmt.setString(7, msg_subject	);
							pstmt.setString(8, msg			);
							pstmt.setString(9, user_id		);
							pstmt.setString(10,dest_gubun	);
				   
							count[0] = pstmt.executeUpdate();
							count[1] += count[0];
							
							break;

						}
					}
				}
			}
            pstmt2.close(); 
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
                con.rollback();
            }catch(SQLException _ignored){}
				se.printStackTrace();
				throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
				if(rs != null)		rs.close();
				if(pstmt2 != null)	pstmt2.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return count;
    }

    /**
     * 문자보내기
     */
    public int[] sendMail_V5(String sendphone, String sendname, String[] destphone, String[] destname, String msg_type, String msg_subject, String msg, String[] pr, String rqdate, String user_id, String dest_gubun, String dest_gubun2, String[] excel_msg) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;

        String query = "";
		String query2 = "";
		String cmid = "";

        int[] count = new int[2];
                
		query2 = " select to_char(sysdate,'YYYYMMDDhh24miss')||nvl(ltrim(to_char(to_number(max(substr(cmid,15,5))+1), '000')), '001') cmid"+
				 " from   ums_data "+
				 " where  cmid LIKE to_char(sysdate,'YYYYMMDDhh24miss')||'%'";

        query=" INSERT INTO ums_data "+
				" ( cmid, send_phone, send_name, dest_phone, dest_name, request_time, status, msg_type, subject, msg_body, etc4, etc5 ) "
            + " VALUES "+
				" ( ?, replace(?,'-',''), substr(?,1,10), replace(?,'-',''), substr(?,1,10), sysdate"+rqdate+", 0, ?, ?, ?, ?, ?) ";

		if(sendphone.equals(""))	sendphone = "027570802";
		if(sendname.equals(""))		sendname  = "아마존카";

       try{
            con.setAutoCommit(false);

            pstmt = con.prepareStatement(query);
			pstmt2 = con.prepareStatement(query2);
            
			for(int i=0; i<destphone.length; i++){
				if(!destphone[i].equals("")){
					for(int j=0; j<pr.length; j++){
						if(i==AddUtil.parseInt(pr[j])){							
							rs = pstmt2.executeQuery();   	
							if(rs.next())
							{				
								cmid	 = rs.getString(1);
							}
							rs.close();
							
							pstmt.setString(1, cmid			);
							pstmt.setString(2, sendphone	);
							pstmt.setString(3, sendname		);
							pstmt.setString(4, destphone[i]	);
							pstmt.setString(5, destname[i]	);
							pstmt.setString(6, msg_type		);
							pstmt.setString(7, msg_subject	);

							String v_excel_msg 		= excel_msg[i] ==null?"":excel_msg[i];
							if(dest_gubun.equals("4") && dest_gubun2.equals("3") && !v_excel_msg.equals("")){
								pstmt.setString(8, v_excel_msg	);
							}else{
								pstmt.setString(8, msg			);
							}

							pstmt.setString(9, user_id		);
							pstmt.setString(10,dest_gubun	);
				   
							count[0] = pstmt.executeUpdate();
							count[1] += count[0];
							
							break;

						}
					}
				}
			}
            pstmt2.close(); 
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
                con.rollback();
            }catch(SQLException _ignored){}
				se.printStackTrace();
				throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
				if(rs != null)		rs.close();
				if(pstmt2 != null)	pstmt2.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return count;
    }

    /**
     * 문자보내기
     */
    public int[] sendMail_V5_req(String sendphone, String sendname, String[] destphone, String[] destname, String msg_type, String msg_subject, String msg, String[] pr, String req_time, String rqdate, String user_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;

        String query = "";
		String query2 = "";
		String cmid = "";

        int[] count = new int[2];
                
		query2 = " select to_char(sysdate,'YYYYMMDDhh24miss')||nvl(ltrim(to_char(to_number(max(substr(cmid,15,5))+1), '000')), '001') cmid"+
				 " from   ums_data "+
				 " where  cmid LIKE to_char(sysdate,'YYYYMMDDhh24miss')||'%'";

        query=" INSERT INTO ums_data "+
				" ( cmid, send_phone, send_name, dest_phone, dest_name, request_time, status, msg_type, subject, msg_body, etc1, etc4 ) "
            + " VALUES "+
				" ( ?, replace(?,'-',''), substr(?,1,10), replace(?,'-',''), substr(?,1,10), to_date(to_char(to_date('"+req_time+"','YYYYMMDDhh24miss')"+rqdate+",'YYYYMMDDhh24miss')), 0, ?, ?, ?, 'req', ?) ";

		if(sendphone.equals(""))	sendphone = "027570802";
		if(sendname.equals(""))		sendname  = "아마존카";

       try{
            con.setAutoCommit(false);

            pstmt = con.prepareStatement(query);
			pstmt2 = con.prepareStatement(query2);
            
			for(int i=0; i<destphone.length; i++){
				if(!destphone[i].equals("")){
					for(int j=0; j<pr.length; j++){
						if(i==AddUtil.parseInt(pr[j])){							
							rs = pstmt2.executeQuery();
   	
							if(rs.next())
							{				
								cmid	 = rs.getString(1);
							}
							rs.close();
							

							pstmt.setString(1, cmid		);
							pstmt.setString(2, sendphone);
							pstmt.setString(3, sendname);
							pstmt.setString(4, destphone[i]);
							pstmt.setString(5, destname[i]);
							pstmt.setString(6, msg_type		);
							pstmt.setString(7, msg_subject	);
							pstmt.setString(8, msg);
							pstmt.setString(9, user_id);
				   
							count[0] = pstmt.executeUpdate();
							count[1] += count[0];
							
							break;

						}
					}
				}
			}
            pstmt2.close(); 
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
                con.rollback();
            }catch(SQLException _ignored){}
				se.printStackTrace();
				throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
				if(rs != null)		rs.close();
				if(pstmt2 != null)	pstmt2.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return count;
    }

    /**
     * 문자보내기
     */
    public int[] sendMail_V5_req(String sendphone, String sendname, String[] destphone, String[] destname, String msg_type, String msg_subject, String msg, String[] pr, String req_time, String rqdate, String user_id, String dest_gubun) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;

        String query = "";
		String query2 = "";
		String cmid = "";

        int[] count = new int[2];
                
		query2 = " select to_char(sysdate,'YYYYMMDDhh24miss')||nvl(ltrim(to_char(to_number(max(substr(cmid,15,5))+1), '000')), '001') cmid"+
				 " from   ums_data "+
				 " where  cmid LIKE to_char(sysdate,'YYYYMMDDhh24miss')||'%'";

        query=" INSERT INTO ums_data "+
				" ( cmid, send_phone, send_name, dest_phone, dest_name, request_time, status, msg_type, subject, msg_body, etc1, etc4, etc5 ) "
            + " VALUES "+
				" ( ?, replace(?,'-',''), substr(?,1,10), replace(?,'-',''), substr(?,1,10), to_date(to_char(to_date('"+req_time+"','YYYYMMDDhh24miss')"+rqdate+",'YYYYMMDDhh24miss')), 0, ?, ?, ?, 'req', ?, ?) ";

		if(sendphone.equals(""))	sendphone = "027570802";
		if(sendname.equals(""))		sendname  = "아마존카";

       try{
            con.setAutoCommit(false);

            pstmt = con.prepareStatement(query);
			pstmt2 = con.prepareStatement(query2);
            
			for(int i=0; i<destphone.length; i++){
				if(!destphone[i].equals("")){
					for(int j=0; j<pr.length; j++){
						if(i==AddUtil.parseInt(pr[j])){							
							rs = pstmt2.executeQuery();   	
							if(rs.next())
							{				
								cmid	 = rs.getString(1);
							}
							rs.close();
							

							pstmt.setString(1, cmid			);
							pstmt.setString(2, sendphone	);
							pstmt.setString(3, sendname		);
							pstmt.setString(4, destphone[i]	);
							pstmt.setString(5, destname[i]	);
							pstmt.setString(6, msg_type		);
							pstmt.setString(7, msg_subject	);
							pstmt.setString(8, msg			);
							pstmt.setString(9, user_id		);
							pstmt.setString(10,dest_gubun	);
				   
							count[0] = pstmt.executeUpdate();
							count[1] += count[0];
							
							break;

						}
					}
				}
			}
            pstmt2.close(); 
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
                con.rollback();
            }catch(SQLException _ignored){}
				se.printStackTrace();
				throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
				if(rs != null)		rs.close();
				if(pstmt2 != null)	pstmt2.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return count;
    }

    /**
     * 문자보내기
     */
    public int[] sendMail_V5_req(String sendphone, String sendname, String[] destphone, String[] destname, String msg_type, String msg_subject, String msg, String[] pr, String req_time, String rqdate, String user_id, String dest_gubun, String dest_gubun2, String[] excel_msg) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;

        String query = "";
		String query2 = "";
		String cmid = "";

        int[] count = new int[2];
                
		query2 = " select to_char(sysdate,'YYYYMMDDhh24miss')||nvl(ltrim(to_char(to_number(max(substr(cmid,15,5))+1), '000')), '001') cmid"+
				 " from   ums_data "+
				 " where  cmid LIKE to_char(sysdate,'YYYYMMDDhh24miss')||'%'";

        query=" INSERT INTO ums_data "+
				" ( cmid, send_phone, send_name, dest_phone, dest_name, request_time, status, msg_type, subject, msg_body, etc1, etc4, etc5 ) "
            + " VALUES "+
				" ( ?, replace(?,'-',''), substr(?,1,10), replace(?,'-',''), substr(?,1,10), to_date(to_char(to_date('"+req_time+"','YYYYMMDDhh24miss')"+rqdate+",'YYYYMMDDhh24miss')), 0, ?, ?, ?, 'req', ?, ?) ";

		if(sendphone.equals(""))	sendphone = "027570802";
		if(sendname.equals(""))		sendname  = "아마존카";

       try{
            con.setAutoCommit(false);

            pstmt = con.prepareStatement(query);
			pstmt2 = con.prepareStatement(query2);
            
			for(int i=0; i<destphone.length; i++){
				if(!destphone[i].equals("")){
					for(int j=0; j<pr.length; j++){
						if(i==AddUtil.parseInt(pr[j])){							
							rs = pstmt2.executeQuery();   	
							if(rs.next())
							{				
								cmid	 = rs.getString(1);
							}
							rs.close();
							
							pstmt.setString(1, cmid			);
							pstmt.setString(2, sendphone	);
							pstmt.setString(3, sendname		);
							pstmt.setString(4, destphone[i]	);
							pstmt.setString(5, destname[i]	);
							pstmt.setString(6, msg_type		);
							pstmt.setString(7, msg_subject	);

							String v_excel_msg 		= excel_msg[i] ==null?"":excel_msg[i];
							if(dest_gubun.equals("4") && dest_gubun2.equals("3") && !v_excel_msg.equals("")){
								pstmt.setString(8, v_excel_msg	);
							}else{
								pstmt.setString(8, msg			);
							}

							pstmt.setString(9, user_id		);
							pstmt.setString(10,dest_gubun	);
				   
							count[0] = pstmt.executeUpdate();
							count[1] += count[0];
							
							break;

						}
					}
				}
			}
            pstmt2.close(); 
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
                con.rollback();
            }catch(SQLException _ignored){}
				se.printStackTrace();
				throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
				if(rs != null)		rs.close();
				if(pstmt2 != null)	pstmt2.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return count;
    }
	
	/*
	*	경매장매각 차량출고 용도
	*/
	public Vector getCarContListOffls(String emp_nm, String gubun1, String gubun2, String st_dt, String end_dt) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String dt = "";
					
			query = " select"+
					" a.rent_mng_id, a.rent_l_cd, b.agnt_st, f.car_nm, e.car_name, d.opt, d.colo, decode(d.purc_gu,'0','면세','1','과세') purc_gu,\n"+
					" g.user_nm as bus_nm, a.rent_dt, a.dlv_dt, b.emp_id, c.emp_nm, j.firm_nm, k.car_no, l.rpt_no \n"+
					" from cont a, commi b, car_off_emp c, car_etc d, car_nm e, car_mng f, users g,  client j, car_reg k, car_pur l, auction_pur fd \n"+
					" where nvl(a.use_yn,'Y')='Y' and b.agnt_st='2' and a.rent_l_cd=b.rent_l_cd(+) and b.emp_id=c.emp_id \n"+
					" and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd \n"+
					" and d.car_id=e.car_id and d.car_seq=e.car_seq and e.car_comp_id=f.car_comp_id and e.car_cd=f.code \n"+
					" and a.bus_id=g.user_id and a.client_id=j.client_id and a.car_mng_id=k.car_mng_id(+) and a.dlv_dt > '20100430' \n"+
					" and a.rent_mng_id=fd.rent_mng_id(+) and a.rent_l_cd=fd.rent_l_cd(+) and  fd.rpt_no is null \n"+
					" and a.rent_mng_id=l.rent_mng_id(+) and a.rent_l_cd=l.rent_l_cd(+)";


			if(!emp_nm.equals(""))									query += " and c.emp_nm='"+emp_nm+"'";

			if(gubun2.equals("1"))		dt = "a.rent_dt";
			if(gubun2.equals("2"))		dt = "a.dlv_dt";

			if(!st_dt.equals("") && !end_dt.equals(""))				query += " and "+dt+" between '"+st_dt+"' and '"+end_dt+"'";
			if(!st_dt.equals("") && end_dt.equals(""))				query += " and "+dt+" like '%"+st_dt+"%'";

			if(gubun2.equals("1"))		query += " order by a.rent_dt";
			if(gubun2.equals("2"))		query += " order by a.dlv_dt";

		try {
						
			pstmt = con.prepareStatement(query);							
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
			System.out.println("[CarOfficeDatabase:getCarContListOffls]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}
	
	/*
	*	문자관리 리스트
	*/
	public Vector getSmsListV5(String gubun, String dest_gubun, String send_dt, String st_dt, String end_dt, String s_bus, String sort, String sort_gubun, String s_bus_nm, String s_kd, String t_wd) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String what = "";

		query = " select cmid, b.firm_nm, c.user_nm, \n"+
				"        decode(c.user_nm,'',a.send_name,c.user_nm) send_name2, \n"+
				"        decode(a.dest_name,b.firm_nm,nvl(a.dest_name,a.dest_phone),b.firm_nm||' '||a.dest_name) dest_name2, \n"+
				"        a.* \n"+
				" from   ums_log a, client b, users c \n"+
				" where  a.etc3=b.client_id(+) and a.etc4=c.user_id(+)"+
				" ";

		//발송대상구분
		if(!dest_gubun.equals("")) query += " and etc5='"+dest_gubun+"'";

		//발송일자구분 1:당일, 2:전일, 3:기간, 4:당월
		if(send_dt.equals("1")){
			query += " and to_char(a.send_time, 'yyyymmdd')=to_char(sysdate,'yyyymmdd') ";
		}else if(send_dt.equals("2")){
			query += " and to_char(a.send_time, 'yyyymmdd') =to_char(sysdate-1,'yyyymmdd') ";
		}else if(send_dt.equals("3")){
			if(!st_dt.equals("") && !end_dt.equals(""))		query += " and to_char(a.send_time, 'yyyymmdd') between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') ";
			if(!st_dt.equals("") && end_dt.equals(""))		query += " and to_char(a.send_time, 'yyyymmdd') like replace('"+st_dt+"%', '-','') ";
		}else if(send_dt.equals("4")){
			query += " and  to_char(send_time, 'yyyymm')=to_char(sysdate,'yyyymm') ";
		}
			

		if(s_kd.equals("1"))	what = "upper(nvl(a.send_name||c.user_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(a.dest_name||b.firm_nm, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(a.send_phone, ' '))";	
		if(s_kd.equals("4"))	what = "upper(nvl(a.dest_phone, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(a.msg_body, ' '))";	

		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		//정렬
		if(sort.equals("1"))		query += " order by decode(c.user_nm,'',a.send_name,c.user_nm) "+sort_gubun+", a.send_time, a.cmid";
		else if(sort.equals("2"))	query += " order by decode(b.firm_nm,'',a.dest_name,b.firm_nm||c.user_nm) "+sort_gubun+", a.send_time, a.cmid";
		else if(sort.equals("4"))	query += " order by a.send_time "+sort_gubun+", a.cmid";
		else if(sort.equals("5"))	query += " order by a.cmid "+sort_gubun+"";
 	
		try {
			pstmt = con.prepareStatement(query);
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
//			System.out.println("[CarOfficeDatabase:getSmsListV5()]"+ query);
		} catch (SQLException e) {
			System.out.println("[CarOfficeDatabase:getSmsListV5()]"+ e);
			System.out.println("[CarOfficeDatabase:getSmsListV5()]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}	

	/*
	*	문자관리 리스트
	*/
	public Vector getSmsListV5Data(String gubun, String dest_gubun, String send_dt, String st_dt, String end_dt, String s_bus, String sort, String sort_gubun, String s_bus_nm, String s_kd, String t_wd) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String what = "";

		query = " select cmid, b.firm_nm, c.user_nm, \n"+
				"        decode(c.user_nm,'',a.send_name,c.user_nm) send_name2, \n"+
				"        decode(a.dest_name,b.firm_nm,nvl(a.dest_name,a.dest_phone),b.firm_nm||' '||a.dest_name) dest_name2, \n"+
				"        a.* \n"+
				" from   ums_data a, client b, users c \n"+
				" where  a.etc3=b.client_id(+) and a.etc4=c.user_id(+)"+
				" ";

		//발송대상구분
		if(!dest_gubun.equals("")) query += " and etc5='"+dest_gubun+"'";

		if(s_kd.equals("1"))	what = "upper(nvl(decode(c.user_nm,'',a.send_name,c.user_nm), ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(decode(a.dest_name,b.firm_nm,nvl(a.dest_name,a.dest_phone),b.firm_nm||' '||a.dest_name), ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(a.send_phone, ' '))";	
		if(s_kd.equals("4"))	what = "upper(nvl(a.dest_phone, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(a.msg_body, ' '))";	

		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		//정렬
		if(sort.equals("1"))		query += " order by decode(c.user_nm,'',a.send_name,c.user_nm) "+sort_gubun+", a.send_time, a.cmid";
		else if(sort.equals("2"))	query += " order by decode(b.firm_nm,'',a.dest_name,b.firm_nm||c.user_nm) "+sort_gubun+", a.send_time, a.cmid";
		else if(sort.equals("4"))	query += " order by a.send_time "+sort_gubun+", a.cmid";
		else if(sort.equals("5"))	query += " order by a.cmid "+sort_gubun+"";
 	
		try {
			pstmt = con.prepareStatement(query);
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
//			System.out.println("[CarOfficeDatabase:getSmsListV5Data()]"+ query);
		} catch (SQLException e) {
			System.out.println("[CarOfficeDatabase:getSmsListV5Data()]"+ e);
			System.out.println("[CarOfficeDatabase:getSmsListV5Data()]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}	

	/*
	*	문자관리
	*/
	public Hashtable getSmsV5(String cmid, String cmst) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		String table = "ums_log";

		if(cmst.equals("data"))		table = "ums_data";
		
		query = " select b.firm_nm, c.user_nm, \n"+
				"        decode(c.user_nm,'',a.send_name,c.user_nm) send_name2, \n"+
				"        decode(a.dest_name,b.firm_nm,nvl(a.dest_name,a.dest_phone),b.firm_nm||' '||a.dest_name) dest_name2, \n"+
				"        a.*, cs.* \n"+
				" from   "+table+" a, client b, users c, credit_score cs \n"+
				" where  a.cmid='"+cmid+"' and a.etc3=b.client_id(+) and a.etc4=c.user_id(+) and a.cmid = cs.cmid(+) "+
				" ";

		try {
			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next())
			{								
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}
		    rs.close();
            pstmt.close();
//			System.out.println("[CarOfficeDatabase:getSmsV5()]"+ query);
		} catch (SQLException e) {
			System.out.println("[CarOfficeDatabase:getSmsV5()]"+ e);
			System.out.println("[CarOfficeDatabase:getSmsV5()]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return ht;
	}	

    /**
     * 영업소 사원 전체 조회.
     */
    public CarOffEmpBean [] getCarOffEmpOneSelfAll(String gubun, String gu_nm, String sort_gubun, String sort, String cng_rsn) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String subQuery = "";

		if(!gu_nm.equals("")){
			if(gubun.equals("mix")){
				subQuery = "and a.emp_nm||b.car_off_nm||a.emp_m_tel like '%" + gu_nm + "%'\n";
			}
		}

		if(!cng_rsn.equals("")){
			subQuery = "and b.car_comp_id ='" + cng_rsn + "'\n";
		}

		String query = "";

        query = "select a.emp_id as EMP_ID,\n"
						+ "a.car_off_id as CAR_OFF_ID,\n" 
						+ "b.car_off_nm as CAR_OFF_NM, b.car_off_st, b.owner_nm as OWNER_NM,\n"
						+ "b.car_comp_id as CAR_COMP_ID,\n"
						+ "c.nm as CAR_COMP_NM,\n"
						+ "a.cust_st as CUST_ST,\n"
						+ "a.emp_nm as EMP_NM,\n"
						+ "a.emp_ssn as EMP_SSN,\n"
						+ "b.car_off_tel as CAR_OFF_TEL,\n"
						+ "b.car_off_fax as CAR_OFF_FAX,\n"
						+ "a.emp_m_tel as EMP_M_TEL,\n"
						+ "a.emp_pos as EMP_POS,\n"
						+ "a.emp_email as EMP_EMAIL,\n"
						+ "a.emp_bank as EMP_BANK,\n"
						+ "a.emp_acc_no as EMP_ACC_NO,\n"
						+ "a.emp_acc_nm as EMP_ACC_NM,a.emp_post as EMP_POST,a.emp_addr as EMP_ADDR, a.etc as ETC,\n"
						+ "b.car_off_post as CAR_OFF_POST, b.car_off_addr as CAR_OFF_ADDR, \n"
						+ "nvl(a.reg_dt,'-') reg_dt, a.reg_id, a.upd_dt, a.upd_id, \n"
						+ "a.emp_h_tel, a.emp_sex, a.use_yn, a.sms_denial_rsn \n"
						+ ", '' seq, '' damdang_id, '' cng_rsn, '' cng_dt "
						+ ", a.file_name1, a.file_name2, a.file_gubun1, a.file_gubun2, b.one_self_yn, a.agent_id, a.emp_dept, a.fraud_care, a.bank_cd \n"
				+ "from car_off b, car_off_emp a, code c "
				+ "where \n"
				+ " b.one_self_yn='Y' and b.use_yn='Y' \n"
				+ "and b.car_off_id = a.car_off_id \n"
				+ "and b.manager = a.emp_nm  \n"
				+ "and b.car_comp_id = c.code\n"
				+ "and c.c_st = '0001'\n"
				+ subQuery;
		
		if(!sort_gubun.equals("")) query += " order by b.car_comp_id, "+sort_gubun+" "+sort;

		Collection col = new ArrayList();
        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
                
				col.add(makeCarOffEmpBean(rs));
 
            }
            rs.close();
            stmt.close();

        }catch(SQLException se){
			System.out.println("[CarOfficeDatabase:getCarOffEmpOneSelfAll(String gubun, String gu_nm, String sort_gubun, String sort, String cng_rsn)]"+se);
			System.out.println("[CarOfficeDatabase:getCarOffEmpOneSelfAll(String gubun, String gu_nm, String sort_gubun, String sort, String cng_rsn)]"+query);
			se.printStackTrace();
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (CarOffEmpBean[])col.toArray(new CarOffEmpBean[0]);
    }

	/*
	*	문자관리 리스트
	*/
	public Vector getSmsCreListV5(String gubun, String dest_gubun, String send_dt, String st_dt, String end_dt, String s_bus, String sort, String sort_gubun, String s_bus_nm, String s_kd, String t_wd) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String what = "";

		query = " select cmid, b.firm_nm, c.user_nm, \n"+
				"        decode(c.user_nm,'',a.send_name,c.user_nm) send_name2, \n"+
				"        decode(a.dest_name,b.firm_nm,nvl(a.dest_name,a.dest_phone),b.firm_nm||' '||a.dest_name) dest_name2, \n"+
				"        a.* \n"+
				" from   ums_log a, client b, users c \n"+
				" where  a.etc3=b.client_id(+) and a.etc4=c.user_id(+) "+
				"        and a.etc5='cre' "+
				" ";


		//발송일자구분 1:당일, 2:전일, 3:기간, 4:당월
		if(send_dt.equals("1")){
			query += " and to_char(a.send_time, 'yyyymmdd')=to_char(sysdate,'yyyymmdd') ";
		}else if(send_dt.equals("2")){
			query += " and to_char(a.send_time, 'yyyymmdd')=to_char(sysdate-1,'yyyymmdd') ";
		}else if(send_dt.equals("3")){
			if(!st_dt.equals("") && !end_dt.equals(""))		query += " and to_char(a.send_time, 'yyyymmdd') between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') ";
			if(!st_dt.equals("") && end_dt.equals(""))		query += " and to_char(a.send_time, 'yyyymmdd') like replace('"+st_dt+"%', '-','') ";
		}else if(send_dt.equals("4")){
			query += " and to_char(a.send_time, 'yyyymm')=to_char(sysdate,'yyyymm') ";
		}

		if(s_kd.equals("1"))	what = "upper(nvl(a.send_name||c.user_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(a.dest_name||b.firm_nm, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(a.send_phone, ' '))";	
		if(s_kd.equals("4"))	what = "upper(nvl(a.dest_phone, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(a.msg_body, ' '))";	

		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		//정렬
		if(sort.equals("1"))		query += " order by decode(c.user_nm,'',a.send_name,c.user_nm) "+sort_gubun+", a.send_time, a.cmid";
		else if(sort.equals("2"))	query += " order by decode(b.firm_nm,'',a.dest_name,b.firm_nm||c.user_nm) "+sort_gubun+", a.send_time, a.cmid";
		else if(sort.equals("4"))	query += " order by a.send_time "+sort_gubun+", a.cmid";
		else if(sort.equals("5"))	query += " order by a.cmid "+sort_gubun+"";
 	
		try {
			pstmt = con.prepareStatement(query);
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
//			System.out.println("[CarOfficeDatabase:getSmsCreListV5()]"+ query);
		} catch (SQLException e) {
			System.out.println("[CarOfficeDatabase:getSmsCreListV5()]"+ e);
			System.out.println("[CarOfficeDatabase:getSmsCreListV5()]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}	

	/*
	*	문자관리 리스트
	*/
	public Vector getSmsCreListV5Data(String gubun, String dest_gubun, String send_dt, String st_dt, String end_dt, String s_bus, String sort, String sort_gubun, String s_bus_nm, String s_kd, String t_wd) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String what = "";

		query = " select cmid, b.firm_nm, c.user_nm, \n"+
				"        decode(c.user_nm,'',a.send_name,c.user_nm) send_name2, \n"+
				"        decode(a.dest_name,b.firm_nm,nvl(a.dest_name,a.dest_phone),b.firm_nm||' '||a.dest_name) dest_name2, \n"+
				"        a.* \n"+
				" from   ums_data a, client b, users c \n"+
				" where  a.etc3=b.client_id(+) and a.etc4=c.user_id(+)"+
				"        and a.etc5='cre' "+
				" ";


		if(s_kd.equals("1"))	what = "upper(nvl(decode(c.user_nm,'',a.send_name,c.user_nm), ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(decode(a.dest_name,b.firm_nm,nvl(a.dest_name,a.dest_phone),b.firm_nm||' '||a.dest_name), ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(a.send_phone, ' '))";	
		if(s_kd.equals("4"))	what = "upper(nvl(a.dest_phone, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(a.msg_body, ' '))";	

		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		//정렬
		if(sort.equals("1"))		query += " order by decode(c.user_nm,'',a.send_name,c.user_nm) "+sort_gubun+", a.send_time, a.cmid";
		else if(sort.equals("2"))	query += " order by decode(b.firm_nm,'',a.dest_name,b.firm_nm||c.user_nm) "+sort_gubun+", a.send_time, a.cmid";
		else if(sort.equals("4"))	query += " order by a.send_time "+sort_gubun+", a.cmid";
		else if(sort.equals("5"))	query += " order by a.cmid "+sort_gubun+"";
 	
		try {
			pstmt = con.prepareStatement(query);
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
//			System.out.println("[CarOfficeDatabase:getSmsCreListV5Data()]"+ query);
		} catch (SQLException e) {
			System.out.println("[CarOfficeDatabase:getSmsCreListV5Data()]"+ e);
			System.out.println("[CarOfficeDatabase:getSmsCreListV5Data()]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}	

    /**
     * 영업사원별 계약현황
     */
    public Vector getRentCommRtStat(String mode, String gubun1, String gubun2, String s_dt, String e_dt) 
		throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
		String query = "";
		Vector vt = new Vector();

		String dt = "a.dlv_dt";

		query = " SELECT DECODE(one_self,'Y','자체출고','영업사원출고') one_self, \n"+
				"        DECODE(car_st,'1','렌트','리스') car_st, \n"+
				"        DECODE(bus_st,'2','영업사원','') bus_st, \n"+
				"        comm_rt, comm_r_rt, COUNT(*) cnt \n"+
				" FROM \n"+ 
				"        ( \n"+
				"          SELECT a.rent_l_cd, a.dlv_dt, a.car_st, a.bus_st, nvl(b.one_self,'N') one_self, c.commi, c.sup_dt, NVL(c.comm_r_rt,0) comm_r_rt, decode(c.comm_rt,'','미등록',c.comm_rt) comm_rt \n"+
				"          FROM   CONT a, CAR_PUR b, (SELECT * FROM COMMI WHERE agnt_st='1') c, \n"+
				"                 (select * from cls_cont where cls_st in ('4','5')) o, (select * from cls_cont where cls_st in ('7','10')) o2 \n"+			
				"          WHERE  a.car_st in ('1','3') AND a.car_gu='1' \n";

		//자체출고-렌트
		if(mode.equals("1"))		query += " and nvl(b.one_self,'N')='Y' and a.car_st='1' ";
		//자체출고-리스
		if(mode.equals("2"))		query += " and nvl(b.one_self,'N')='Y' and a.car_st='3' ";
		//영업사원출고-렌트
		if(mode.equals("3"))		query += " and nvl(b.one_self,'N')='N' and a.car_st='1' ";
		//영업사원출고-리스
		if(mode.equals("4"))		query += " and nvl(b.one_self,'N')='N' and a.car_st='3' ";
		//영업사원출고-렌트
		if(mode.equals("5"))		query += " and b.one_self is null and a.car_st='1' ";
		//영업사원출고-리스
		if(mode.equals("6"))		query += " and b.one_self is null and a.car_st='3' ";
	

		if(gubun1.equals("1"))		dt = "a.rent_dt";
		if(gubun1.equals("3"))		dt = "a.rent_start_dt";

		if(gubun2.equals("1"))		query += " and "+dt+" like to_char(sysdate,'YYYYMM')||'%'  ";
		if(gubun2.equals("2"))		query += " and "+dt+" like TO_CHAR(add_months(sysdate,-1),'YYYYMM')||'%'  ";
		if(gubun2.equals("3")){
			if(!s_dt.equals("") && e_dt.equals(""))		query += " and "+dt+" like replace('"+s_dt+"%', '-','') \n";
			if(!s_dt.equals("") && !e_dt.equals(""))	query += " and "+dt+" between replace('"+s_dt+"', '-','') and replace('"+e_dt+"', '-','') \n";
		}


		query += "                AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd \n"+
				"                 AND a.rent_mng_id=c.rent_mng_id(+) AND a.rent_l_cd=c.rent_l_cd(+) \n"+
				"                 and a.rent_mng_id=o.rent_mng_id(+) and a.reg_dt=o.reg_dt(+) and o.rent_l_cd is null \n"+
				"                 and a.rent_mng_id=o2.rent_mng_id(+) and a.rent_l_cd=o2.rent_l_cd(+) and o2.rent_l_cd is null \n"+
				"        ) \n"+               
				" GROUP BY one_self, car_st, DECODE(bus_st,'2','영업사원',''), comm_rt, comm_r_rt \n"+       
				" ORDER BY one_self desc, car_st, DECODE(bus_st,'2','영업사원',''), comm_rt, comm_r_rt \n"+
				" ";


        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
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
            stmt.close();
//			System.out.println("[CarOfficeDatabase:getRentCommRtStat]"+query);
        }catch(SQLException se){
			System.out.println("[CarOfficeDatabase:getRentCommRtStat]"+se);
			System.out.println("[CarOfficeDatabase:getRentCommRtStat]"+query);
			se.printStackTrace();
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

    /**
     * 영업사원별 계약현황
     */
    public Vector getRentCommRtCont(String mode, String gubun1, String gubun2, String s_dt, String e_dt, String car_st, String bus_st, String comm_rt, String comm_r_rt) 
		throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
		String query = "";
		Vector vt = new Vector();

		String dt = "a.dlv_dt";

		query = " SELECT a.use_yn, a.rent_dt, a.rent_l_cd, a.dlv_dt, a.car_st, b.one_self, \n"+
				"        c.commi, c.sup_dt, NVL(c.comm_r_rt,0) comm_r_rt, decode(c.comm_rt,'','미등록',c.comm_rt) comm_rt, c.ch_remark, \n"+
				"        d.car_no, nvl(d.car_nm,j.car_nm) car_nm, e.firm_nm, f.user_nm as bus_nm, decode(a.car_st,'1',i.Jg_f,i.jg_g)*100 jg_fg, \n"+
				"        decode(a.bus_st, '1','인터넷','2','영업사원','3','업체소개','4','카달로그','5','전화상담','6','기존업체','7','에이젼트','8','모바일') bus_st, \n"+
				"        m.car_off_nm, k.emp_nm \n"+
				" FROM   CONT a, CAR_PUR b, (SELECT * FROM COMMI WHERE agnt_st='1') c, car_reg d, client e, users f, \n"+          
				"        CAR_ETC g, CAR_NM h, ESTI_JG_VAR i, car_mng j, car_off_emp k, car_off m, \n"+
				"        (select * from cls_cont where cls_st in ('4','5')) o, (select * from cls_cont where cls_st in ('7','10')) o2 \n"+			
				" WHERE  a.car_st in ('1','3') AND a.car_gu='1' \n";//NVL(a.use_yn,'Y')='Y' AND 

		//자체출고-렌트
		if(mode.equals("1"))		query += " and nvl(b.one_self,'N')='Y' and a.car_st='1' ";
		//자체출고-리스
		if(mode.equals("2"))		query += " and nvl(b.one_self,'N')='Y' and a.car_st='3' ";
		//영업사원출고-렌트
		if(mode.equals("3"))		query += " and nvl(b.one_self,'N')='N' and a.car_st='1' ";
		//영업사원출고-리스
		if(mode.equals("4"))		query += " and nvl(b.one_self,'N')='N' and a.car_st='3' ";
		//영업사원출고-렌트
		if(mode.equals("5"))		query += " and b.one_self is null and a.car_st='1' ";
		//영업사원출고-리스
		if(mode.equals("6"))		query += " and b.one_self is null and a.car_st='3' ";
	

		if(gubun1.equals("1"))		dt = "a.rent_dt";
		if(gubun1.equals("3"))		dt = "a.rent_start_dt";

		if(gubun2.equals("1"))		query += " and "+dt+" like to_char(sysdate,'YYYYMM')||'%'  ";
		if(gubun2.equals("2"))		query += " and "+dt+" like TO_CHAR(add_months(sysdate,-1),'YYYYMM')||'%'  ";
		if(gubun2.equals("3")){
			if(!s_dt.equals("") && e_dt.equals(""))		query += " and "+dt+" like replace('"+s_dt+"%', '-','') \n";
			if(!s_dt.equals("") && !e_dt.equals(""))	query += " and "+dt+" between replace('"+s_dt+"', '-','') and replace('"+e_dt+"', '-','') \n";
		}


		if(bus_st.equals("영업사원"))		query += " and a.bus_st='2' ";
		if(bus_st.equals(""))				query += " and a.bus_st<>'2' ";


		if(comm_rt.equals("미등록")) 		query += " and decode(c.comm_rt,'','미등록',c.comm_rt) = '미등록' ";
		else 								query += " and decode(c.comm_rt,'','미등록',c.comm_rt) = '"+comm_rt+"' ";

		query += " and NVL(c.comm_r_rt,0) = "+comm_r_rt+" ";
		

		query += "       AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd \n"+
				"        AND a.rent_mng_id=c.rent_mng_id(+) AND a.rent_l_cd=c.rent_l_cd(+) \n"+
				"        and a.car_mng_id=d.car_mng_id(+) and a.client_id=e.client_id and a.bus_id=f.user_id \n"+
				"        AND a.rent_mng_id=g.rent_mng_id and a.rent_l_cd=g.rent_l_cd \n"+
				"        AND g.car_id=h.car_id AND g.car_seq=h.car_seq \n"+
				"        AND h.jg_code=i.sh_code \n"+
				"        AND (i.sh_code, i.reg_dt) IN (SELECT sh_code, MAX(reg_dt) reg_dt FROM ESTI_JG_VAR WHERE a.rent_dt>reg_dt GROUP BY sh_code) \n"+
				"        and h.car_comp_id=j.car_comp_id and h.car_cd=j.code "+
				"        and c.emp_id=k.emp_id(+) and k.car_off_id=m.car_off_id(+) "+
				"        and a.rent_mng_id=o.rent_mng_id(+) and a.reg_dt=o.reg_dt(+) and o.rent_l_cd is null \n"+
				"        and a.rent_mng_id=o2.rent_mng_id(+) and a.rent_l_cd=o2.rent_l_cd(+) and o2.rent_l_cd is null \n"+
				" ORDER BY b.one_self desc, a.car_st, DECODE(a.bus_st,'2','영업사원',''), c.comm_rt, c.comm_r_rt \n"+
				" ";


        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
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
            stmt.close();
//			System.out.println("[CarOfficeDatabase:getRentCommRtCont]"+query);
        }catch(SQLException se){
			System.out.println("[CarOfficeDatabase:getRentCommRtCont]"+se);
			System.out.println("[CarOfficeDatabase:getRentCommRtCont]"+query);
			se.printStackTrace();
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }



	/*
	*	문자관리 리스트
	*/
	public Vector getSmsCreListV5No(String gubun, String dest_gubun, String send_dt, String st_dt, String end_dt, String s_bus, String sort, String sort_gubun, String s_bus_nm, String s_kd, String t_wd) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String what = "";

		query = " SELECT b.user_nm, c.user_nm AS send_nm,  a.*  "+
				" FROM   CREDIT_SCORE a, users b, USERS c  "+
				" WHERE  a.bus_id=b.USER_ID(+) AND a.reg_id = c.user_id(+)  AND a.MMS_GB = 'Y'  "+
				" ";
//System.out.println("send_dt: "+send_dt);

		//발송일자구분 1:당일, 2:전일, 3:기간, 4:당월
		if(send_dt.equals("1")){
			query += " and a.cmid like to_char(sysdate,'yyyymmdd')||'%' ";
		}else if(send_dt.equals("2")){
			query += " and a.cmid like to_char(sysdate-1,'yyyymmdd')||'%' ";
		}else if(send_dt.equals("3")){
			if(!st_dt.equals("") && !end_dt.equals(""))		query += " and a.cmid between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') ";
			if(!st_dt.equals("") && end_dt.equals(""))		query += " and a.cmid like replace('"+st_dt+"%', '-','') ";
		}else if(send_dt.equals("4")){
			query += " and a.cmid like to_char(sysdate,'yyyymm')||'%' ";
		}

		if(s_kd.equals("2"))	what = "upper(a.dest_name)";	
		if(s_kd.equals("4"))	what = "upper(a.dest_phone)";	
		if(s_kd.equals("5"))	what = "upper(a.msg_body)";	
		if(s_kd.equals("6"))	what = "upper(b.user_nm)";	

		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		//정렬
		query += " order by a.cmid "+sort_gubun+"";
 	
		try {
			pstmt = con.prepareStatement(query);
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
//			System.out.println("[CarOfficeDatabase:getSmsCreListV5()]"+ query);
		} catch (SQLException e) {
			System.out.println("[CarOfficeDatabase:getSmsCreListV5()]"+ e);
			System.out.println("[CarOfficeDatabase:getSmsCreListV5()]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}	


/*
	*	문자관리
	*/
	public Hashtable getSmsV5No(String cmid, String cmst) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " SELECT b.user_nm, c.user_nm AS send_nm, c.hot_tel as SEND_PHONE, \n"+
			    "        a.cmid, a.umid, a.msg_type, a.status, a.dest_phone, a.dest_name, a.subject, a.msg_body, a.bus_id, replace(a.score,' ','') score, replace(a.score2,' ','') score2, a.mms_gb, a.reg_id, a.reg_dt, a.key_no \n"+
				" FROM CREDIT_SCORE a, users b , USERS c  \n"+
				" WHERE a.bus_id=b.USER_ID(+)  \n"+
				" AND a.reg_id = c.user_id(+)  \n"+
				" AND a.MMS_GB = 'Y' \n"+
				" and a.cmid='"+cmid+"' "+
				" ";

		try {
			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next())
			{								
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}
		    rs.close();
            pstmt.close();
//			System.out.println("[CarOfficeDatabase:getSmsV5()]"+ query);
		} catch (SQLException e) {
			System.out.println("[CarOfficeDatabase:getSmsV5()]"+ e);
			System.out.println("[CarOfficeDatabase:getSmsV5()]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return ht;
	}

	/*
	*	자동차납품공문 계약리스트
	*/
	public Vector getSearchCarPurDocLists(String rent_mng_id, String rent_l_cd) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String dt = "";
				
		query = " select b.dlv_dt, SUBSTR(a.RENT_L_CD,1,8) rent_l_cd1, SUBSTR(a.RENT_L_CD,9) rent_l_cd2, c.firm_nm, "+
				"        a.*  "+
				" from   car_pur_doc_list a, cont b, client c "+
				" where  a.rent_mng_id='"+rent_mng_id+"' and a.rent_l_cd='"+rent_l_cd+"' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.client_id=c.client_id order by a.doc_id ";
					

		try {
			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next()){
				CarPurDocListBean bean = new CarPurDocListBean();
				bean.setDlv_dt			(rs.getString(1)==null?"":rs.getString(1));
				bean.setRent_l_cd1		(rs.getString(2)==null?"":rs.getString(2));
				bean.setRent_l_cd2		(rs.getString(3)==null?"":rs.getString(3));
				bean.setFirm_nm			(rs.getString(4)==null?"":rs.getString(4));
				bean.setDoc_id 			(rs.getString(5));
				bean.setRent_mng_id		(rs.getString(6));
				bean.setRent_l_cd		(rs.getString(7));
				bean.setAgnt_st			(rs.getString(8));
				bean.setCar_nm			(rs.getString(9));
				bean.setOpt				(rs.getString(10));
				bean.setColo			(rs.getString(11));
				bean.setPurc_gu			(rs.getString(12));
				bean.setReq_dt			(rs.getString(13));
				bean.setBus_nm			(rs.getString(14));
				bean.setReg_id			(rs.getString(15));
				bean.setReg_dt			(rs.getString(16));
				bean.setUpd_id			(rs.getString(17));
				bean.setUpd_dt			(rs.getString(18));
				bean.setAuto			(rs.getString(19)==null?"":rs.getString(19));
				bean.setCar_off_nm		(rs.getString(20)==null?"":rs.getString(20));
				bean.setCar_amt			(rs.getString(21)==null?"":rs.getString(21));
				bean.setDoc_st			(rs.getString(22)==null?"":rs.getString(22));
				vt.add(bean);
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CarOfficeDatabase:getSearchCarPurDocLists]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

	//해지보험공문 한건 등록
    public boolean insertCarPurCngList(CarPurDocListBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        boolean flag = true;
                
		query = " INSERT INTO car_pur_cng_list "+
				" (      p_doc_id, rent_mng_id, rent_l_cd, car_nm, opt, colo, purc_gu, req_dt, bus_nm, "+
				"        reg_id, reg_dt, auto, car_off_nm, car_amt, doc_st, cng_code, cng_cau "+
				" ) VALUES "+
				" (      ?, ?, ?, ?,    ?, ?, ?, ?, ?,   ?, to_char(sysdate,'YYYYMMDD'), ?, ?, ?, ?, ?, ? "+
				" )";
            
       try{
            con.setAutoCommit(false);            
            
            pstmt = con.prepareStatement(query);

			pstmt.setString	(1,		bean.getDoc_id 		());
			pstmt.setString	(2,		bean.getRent_mng_id	());
			pstmt.setString	(3,		bean.getRent_l_cd	());
			pstmt.setString	(4,		bean.getCar_nm		());
			pstmt.setString	(5,		bean.getOpt			());
			pstmt.setString	(6,		bean.getColo		());
			pstmt.setString	(7,		bean.getPurc_gu		());
			pstmt.setString	(8,		bean.getReq_dt		());
			pstmt.setString	(9,	    bean.getBus_nm		());
			pstmt.setString	(10,	bean.getReg_id		());
			pstmt.setString	(11,	bean.getAuto		());
			pstmt.setString	(12,	bean.getCar_off_nm	());
			pstmt.setString	(13,	bean.getCar_amt		());
			pstmt.setString	(14,	bean.getDoc_st		());
			pstmt.setString	(15,	bean.getCng_code	());
			pstmt.setString	(16,	bean.getCng_cau		());

            pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
                con.rollback();
		  		flag = false;
				System.out.println("[CarOfficeDatabase:insertCarPurCngList]\n"+se);

				System.out.println("[bean.getDoc_id 		()]\n"+bean.getDoc_id 		());
				System.out.println("[bean.getRent_mng_id	()]\n"+bean.getRent_mng_id	());
				System.out.println("[bean.getRent_l_cd		()]\n"+bean.getRent_l_cd	());
				System.out.println("[bean.getAgnt_st		()]\n"+bean.getAgnt_st		());
				System.out.println("[bean.getCar_nm			()]\n"+bean.getCar_nm		());
				System.out.println("[bean.getOpt			()]\n"+bean.getOpt			());
				System.out.println("[bean.getColo			()]\n"+bean.getColo			());
				System.out.println("[bean.getPurc_gu		()]\n"+bean.getPurc_gu		());
				System.out.println("[bean.getReq_dt			()]\n"+bean.getReq_dt		());
				System.out.println("[bean.getBus_nm			()]\n"+bean.getBus_nm		());
				System.out.println("[bean.getReg_id			()]\n"+bean.getReg_id		());
				System.out.println("[bean.getAuto			()]\n"+bean.getAuto			());
				System.out.println("[bean.getCar_off_nm		()]\n"+bean.getCar_off_nm	());

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

	/*
	*	자동차납품공문 계약리스트
	*/
	public Vector getCarPurCngContList(String emp_nm, String gubun1, String gubun2, String st_dt, String end_dt) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String dt = "";
					
			query = " SELECT d.user_nm, e.doc_dt, DECODE(a.doc_st,'cng','변경','cls','해지') doc_st_nm, f.firm_nm, a.* \n"+
					" FROM   car_pur_cng_list a, CAR_PUR_DOC_LIST b, CONT c, USERS d, FINE_DOC e, client f \n"+
					" WHERE  a.cng_code=b.cng_code(+) AND b.cng_code IS NULL \n"+
					"        AND a.rent_mng_id=c.rent_mng_id AND a.rent_l_cd=c.rent_l_cd AND c.car_mng_id IS NULL  \n"+
					"        AND a.reg_id=d.user_id \n"+
					"        AND a.p_doc_id=e.doc_id \n"+
					"        AND c.client_id=f.client_id "+
					" ";


			if(gubun1.equals("1"))		query += " and a.doc_st='cng' ";
			if(gubun1.equals("2"))		query += " and a.doc_st='cls' ";

			if(gubun2.equals("1"))		dt = "a.reg_dt";

			if(!st_dt.equals("") && !end_dt.equals(""))				query += " and "+dt+" between '"+st_dt+"' and '"+end_dt+"'";
			if(!st_dt.equals("") && end_dt.equals(""))				query += " and "+dt+" like '%"+st_dt+"%'";

			if(gubun2.equals("1"))		query += " order by a.reg_dt, e.doc_dt, a.rent_l_cd ";


		try {
			pstmt = con.prepareStatement(query);
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
			System.out.println("[CarOfficeDatabase:getCarPurCngContList]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

	/*
	*	자동차납품공문 계약리스트
	*/
	public Hashtable getCarPurCngContListCase(String cng_code) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		String dt = "";
					
			query = " SELECT \n"+
					"        decode(a.doc_st,'cng','변경','cls','해지') doc_st_nm, b.dlv_dt, \n"+
					"        a.* \n"+
					" from   car_pur_cng_list a, cont b  \n"+
					" where  a.cng_code='"+cng_code+"' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
					" ";


		try {
			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next())
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
			System.out.println("[CarOfficeDatabase:getCarPurCngContListCase]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return ht;
	}


	/*
	*	협력업체-계출관리---------------------------------------------------------------------------------------------------------------------------------------------------------------
	*/
	

	/*
	*	자동차납품공문 계약리스트
	*/
	public CarPurDocListBean getCarPurDocCngBeforeList(String doc_id, String rent_mng_id, String rent_l_cd) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		CarPurDocListBean bean = new CarPurDocListBean();
		String query = "";
					
		query = " SELECT * \n"+
				" FROM   CAR_PUR_DOC_LIST  \n"+
				" WHERE  (doc_id, rent_mng_id, rent_l_cd) IN ( SELECT p_doc_id, rent_mng_id, rent_l_cd FROM CAR_PUR_CNG_LIST  \n"+
				"                                              WHERE  cng_code = (SELECT cng_code FROM CAR_PUR_DOC_LIST WHERE doc_id=? AND rent_mng_id=? and rent_l_cd=?) \n"+
				"                                            )  ";

		try {
			pstmt = con.prepareStatement(query);
			pstmt.setString(1,  doc_id);
			pstmt.setString(2,  rent_mng_id);
			pstmt.setString(3,  rent_l_cd);
			rs = pstmt.executeQuery();

			if(rs.next()){
				bean.setDoc_id 			(rs.getString(1));
				bean.setRent_mng_id		(rs.getString(2));
				bean.setRent_l_cd		(rs.getString(3));
				bean.setAgnt_st			(rs.getString(4));
				bean.setCar_nm			(rs.getString(5));
				bean.setOpt				(rs.getString(6)==null?"":rs.getString(6));
				bean.setColo			(rs.getString(7)==null?"":rs.getString(7));
				bean.setPurc_gu			(rs.getString(8)==null?"":rs.getString(8));
				bean.setReq_dt			(rs.getString(9)==null?"":rs.getString(9));
				bean.setBus_nm			(rs.getString(10)==null?"":rs.getString(10));
				bean.setReg_id			(rs.getString(11));
				bean.setReg_dt			(rs.getString(12));
				bean.setUpd_id			(rs.getString(13));
				bean.setUpd_dt			(rs.getString(14));
				bean.setAuto			(rs.getString(15)==null?"":rs.getString(15));
				bean.setCar_off_nm		(rs.getString(16)==null?"":rs.getString(16));
				bean.setCar_amt			(rs.getString(17)==null?"":rs.getString(17));
				bean.setDoc_st			(rs.getString(18)==null?"":rs.getString(18));
				bean.setCng_code		(rs.getString(19)==null?"":rs.getString(19));
				bean.setUdt_st			(rs.getString(20)==null?"":rs.getString(20));
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CarOfficeDatabase:getCarPurDocCngBeforeList]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return bean; 
	}

	//협럽업체 계출관리 한건 등록
    public boolean insertCarPurCom(CarPurDocListBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        boolean flag = true;
        
		query = " INSERT INTO car_pur_com "+
				" (      rent_mng_id, rent_l_cd, com_con_no, car_nm, opt, colo, purc_gu, auto, "+
				"        car_c_amt, car_f_amt, dc_amt, add_dc_amt, car_d_amt, car_g_amt, cons_amt,  "+
				"        dlv_st, dlv_est_dt, dlv_con_dt, dlv_ext, dlv_mng_id, "+
				"        udt_st, udt_mng_id, udt_firm, udt_addr, "+
				"        reg_id, reg_dt, use_yn, udt_mng_nm, udt_mng_tel, car_comp_id, stock_yn, bigo, stock_st, car_off_id, "+
				"        order_car "+
				" ) VALUES "+
				" (      ?, ?, upper(?), ?, ?, ?, ?, ?,    ?, ?, ?, ?, ?, ?, ?,   "+
				"        ?, replace(?,'-',''), replace(?,'-',''), ?, ?,    ?, ?, ?, ?,    ?, sysdate, ?, ?, ?, ?, ?, ?, ?, ?, "+
				"        ? "+
				" )";
            
       try{
            con.setAutoCommit(false);            
            
            pstmt = con.prepareStatement(query);

			pstmt.setString	(1,		bean.getRent_mng_id	());
			pstmt.setString	(2,		bean.getRent_l_cd	());
			pstmt.setString	(3,		bean.getCom_con_no	().trim());
			pstmt.setString	(4,		bean.getCar_nm		());
			pstmt.setString	(5,		bean.getOpt			());
			pstmt.setString	(6,		bean.getColo		());
			pstmt.setString	(7,		bean.getPurc_gu		());
			pstmt.setString	(8,		bean.getAuto		());
			pstmt.setInt	(9,		bean.getCar_c_amt	());
			pstmt.setInt	(10,	bean.getCar_f_amt	());
			pstmt.setInt	(11,	bean.getDc_amt		());
			pstmt.setInt	(12,	bean.getAdd_dc_amt	());
			pstmt.setInt	(13,	bean.getCar_d_amt	());
			pstmt.setInt	(14,	bean.getCar_g_amt	());
			pstmt.setInt	(15,	bean.getCons_amt	());
			pstmt.setString	(16,	bean.getDlv_st		());
			pstmt.setString	(17,	bean.getDlv_est_dt	());
			pstmt.setString	(18,	bean.getDlv_con_dt	());
			pstmt.setString	(19,	bean.getDlv_ext		());
			pstmt.setString	(20,	bean.getDlv_mng_id	());
			pstmt.setString	(21,	bean.getUdt_st		());
			pstmt.setString	(22,	bean.getUdt_mng_id	());
			pstmt.setString	(23,	bean.getUdt_firm	());
			pstmt.setString	(24,	bean.getUdt_addr	());
			pstmt.setString	(25,	bean.getReg_id		());
			pstmt.setString	(26,	bean.getUse_yn		());
			pstmt.setString	(27,	bean.getUdt_mng_nm	());
			pstmt.setString	(28,	bean.getUdt_mng_tel ());
			pstmt.setString	(29,	bean.getCar_comp_id ());
			pstmt.setString	(30,	bean.getStock_yn	());
			pstmt.setString	(31,	bean.getBigo		());
			pstmt.setString	(32,	bean.getStock_st	());
			pstmt.setString	(33,	bean.getCar_off_id	());
			pstmt.setString	(34,	bean.getOrder_car	());

            pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
                con.rollback();
		  		flag = false;
				System.out.println("[CarOfficeDatabase:insertCarPurCom]\n"+se);
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
    
  //협럽업체 계출관리 한건 등록
    public boolean insertCarPurCom2(CarPurDocListBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        boolean flag = true;
        
            
		query = " INSERT INTO car_pur_com "+
				" (      rent_mng_id, rent_l_cd, com_con_no, car_nm, opt, colo, purc_gu, auto, "+
				"        car_c_amt, car_f_amt, dc_amt, add_dc_amt, car_d_amt, car_g_amt, cons_amt,  "+
				"        dlv_st, dlv_est_dt, dlv_con_dt, dlv_ext, dlv_mng_id, "+
				"        udt_st, udt_mng_id, udt_firm, udt_addr, "+
				"        reg_id, reg_dt, use_yn, udt_mng_nm, udt_mng_tel, car_comp_id, stock_yn, bigo, stock_st, car_off_id, "+
				"        order_car "+
				" ) VALUES "+
				" (      ?, ?, upper(?), ?, ?, ?, ?, ?,    ?, ?, ?, ?, ?, ?, ?,   "+
				"        ?, replace(?,'-',''), replace(?,'-',''), ?, ?,    ?, ?, ?, ?,    ?, to_date(?,'YYYYMMDD'), ?, ?, ?, ?, ?, ?, ?, ?, "+
				"        ? "+
				" )";
            
       try{
            con.setAutoCommit(false);            
            
            pstmt = con.prepareStatement(query);

			pstmt.setString	(1,		bean.getRent_mng_id	());
			pstmt.setString	(2,		bean.getRent_l_cd	());
			pstmt.setString	(3,		bean.getCom_con_no	().trim());
			pstmt.setString	(4,		bean.getCar_nm		());
			pstmt.setString	(5,		bean.getOpt			());
			pstmt.setString	(6,		bean.getColo		());
			pstmt.setString	(7,		bean.getPurc_gu		());
			pstmt.setString	(8,		bean.getAuto		());
			pstmt.setInt	(9,		bean.getCar_c_amt	());
			pstmt.setInt	(10,	bean.getCar_f_amt	());
			pstmt.setInt	(11,	bean.getDc_amt		());
			pstmt.setInt	(12,	bean.getAdd_dc_amt	());
			pstmt.setInt	(13,	bean.getCar_d_amt	());
			pstmt.setInt	(14,	bean.getCar_g_amt	());
			pstmt.setInt	(15,	bean.getCons_amt	());
			pstmt.setString	(16,	bean.getDlv_st		());
			pstmt.setString	(17,	bean.getDlv_est_dt	());
			pstmt.setString	(18,	bean.getDlv_con_dt	());
			pstmt.setString	(19,	bean.getDlv_ext		());
			pstmt.setString	(20,	bean.getDlv_mng_id	());
			pstmt.setString	(21,	bean.getUdt_st		());
			pstmt.setString	(22,	bean.getUdt_mng_id	());
			pstmt.setString	(23,	bean.getUdt_firm	());
			pstmt.setString	(24,	bean.getUdt_addr	());
			pstmt.setString	(25,	bean.getReg_id		());
			pstmt.setString	(26,	bean.getUpd_dt		());
			pstmt.setString	(27,	bean.getUse_yn		());
			pstmt.setString	(28,	bean.getUdt_mng_nm	());
			pstmt.setString	(29,	bean.getUdt_mng_tel ());
			pstmt.setString	(30,	bean.getCar_comp_id ());
			pstmt.setString	(31,	bean.getStock_yn	());
			pstmt.setString	(32,	bean.getBigo		());
			pstmt.setString	(33,	bean.getStock_st	());
			pstmt.setString	(34,	bean.getCar_off_id	());
			pstmt.setString	(35,	bean.getOrder_car	());

            pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
                con.rollback();
		  		flag = false;
				System.out.println("[CarOfficeDatabase:insertCarPurCom2]\n"+se);
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


	//해지보험공문 한건 등록
    public boolean insertCarPurComCng(CarPurDocListBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        boolean flag = true;
                
		query = " INSERT INTO car_pur_com_cng "+
				" (      rent_mng_id, rent_l_cd, com_con_no, seq, cng_st, cng_cont, "+
				"        car_nm, opt, colo, purc_gu, auto, "+
				"        car_c_amt, car_f_amt, dc_amt, add_dc_amt, car_d_amt, car_g_amt,  "+
				"        reg_id, reg_dt, pur_req_dt, bigo "+
				" ) VALUES "+
				" (      ?, ?, upper(?), ?, ?, ?,     ?, ?, ?, ?, ?,   "+
				"        ?, ?, ?, ?, ?, ?,  ?, sysdate, replace(?,'-',''), ?  "+
				" )";
            
       try{
            con.setAutoCommit(false);            
            
            pstmt = con.prepareStatement(query);

			pstmt.setString	(1,		bean.getRent_mng_id	());
			pstmt.setString	(2,		bean.getRent_l_cd	());
			pstmt.setString	(3,		bean.getCom_con_no	().trim());
			pstmt.setInt	(4,		bean.getSeq			());
			pstmt.setString	(5,		bean.getCng_st		());
			pstmt.setString	(6,		bean.getCng_cont	());
			pstmt.setString	(7,		bean.getCar_nm		());
			pstmt.setString	(8,		bean.getOpt			());
			pstmt.setString	(9,		bean.getColo		());
			pstmt.setString	(10,	bean.getPurc_gu		());
			pstmt.setString	(11,	bean.getAuto		());
			pstmt.setInt	(12,	bean.getCar_c_amt	());
			pstmt.setInt	(13,	bean.getCar_f_amt	());
			pstmt.setInt	(14,	bean.getDc_amt		());
			pstmt.setInt	(15,	bean.getAdd_dc_amt	());
			pstmt.setInt	(16,	bean.getCar_d_amt	());
			pstmt.setInt	(17,	bean.getCar_g_amt	());
			pstmt.setString	(18,	bean.getReg_id		());
			pstmt.setString	(19,	bean.getReq_dt		());
			pstmt.setString	(20,	bean.getBigo		());

            pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
                con.rollback();
		  		flag = false;
				System.out.println("[CarOfficeDatabase:insertCarPurComCng]\n"+se);
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
    
	//해지보험공문 한건 등록
    public boolean insertCarPurComCng2(CarPurDocListBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        boolean flag = true;
                
		query = " INSERT INTO car_pur_com_cng "+
				" (      rent_mng_id, rent_l_cd, com_con_no, seq, cng_st, cng_cont, car_nm, opt, colo, purc_gu, auto, "+
				"        car_c_amt, car_f_amt, dc_amt, add_dc_amt, car_d_amt, car_g_amt,  "+
				"        reg_id, reg_dt, pur_req_dt, bigo, cng_id, cng_dt, cng_yn "+
				" ) VALUES "+
				" (      ?, ?, upper(?), ?, ?, ?,     ?, ?, ?, ?, ?,   "+
				"        ?, ?, ?, ?, ?, ?,   "+
				"        ?, to_date(?,'YYYYMMDD'), ?, ?, ?, to_date(?,'YYYYMMDD'), ? "+
				" )";
            
       try{
            con.setAutoCommit(false);            
            
            pstmt = con.prepareStatement(query);

			pstmt.setString	(1,		bean.getRent_mng_id	());
			pstmt.setString	(2,		bean.getRent_l_cd	());
			pstmt.setString	(3,		bean.getCom_con_no	().trim());
			pstmt.setInt	(4,		bean.getSeq			());
			pstmt.setString	(5,		bean.getCng_st		());
			pstmt.setString	(6,		bean.getCng_cont	());
			pstmt.setString	(7,		bean.getCar_nm		());
			pstmt.setString	(8,		bean.getOpt			());
			pstmt.setString	(9,		bean.getColo		());
			pstmt.setString	(10,	bean.getPurc_gu		());
			pstmt.setString	(11,	bean.getAuto		());
			pstmt.setInt	(12,	bean.getCar_c_amt	());
			pstmt.setInt	(13,	bean.getCar_f_amt	());
			pstmt.setInt	(14,	bean.getDc_amt		());
			pstmt.setInt	(15,	bean.getAdd_dc_amt	());
			pstmt.setInt	(16,	bean.getCar_d_amt	());
			pstmt.setInt	(17,	bean.getCar_g_amt	());
			pstmt.setString	(18,	bean.getReg_id		());
			pstmt.setString	(19,	bean.getReg_dt		());
			pstmt.setString	(20,	bean.getReq_dt		());
			pstmt.setString	(21,	bean.getBigo		());
			pstmt.setString	(22,	bean.getCng_id		());
			pstmt.setString	(23,	bean.getCng_dt		());
			pstmt.setString	(24,	bean.getCng_yn		());

            pstmt.executeUpdate();
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
                con.rollback();
		  		flag = false;
				System.out.println("[CarOfficeDatabase:insertCarPurComCng2]\n"+se);
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
    
	//해지보험공문 한건 수정
    public boolean updateCarPurCom(CarPurDocListBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        boolean flag = true;
                
		query = " update car_pur_com set "+
				"        car_nm=?, opt=?, colo=?, purc_gu=?, auto=?, "+
				"        car_c_amt=?, car_f_amt=?, dc_amt=?, add_dc_amt=?, car_d_amt=?, car_g_amt=?, cons_amt=?,  "+
				"        dlv_st=?, dlv_est_dt=replace(?,'-',''), dlv_con_dt=replace(?,'-',''), dlv_ext=?, dlv_mng_id=?, "+
				"        udt_st=?, udt_mng_id=?, udt_firm=?, udt_addr=?, "+
				"        use_yn=?, udt_mng_nm=?, udt_mng_tel=?, dlv_dt=replace(?,'-',''), "+
				"        update_id=?, update_dt=sysdate, stock_yn=?, bigo=?, stock_st=?, order_car=?, suc_yn=? "+
				" where  rent_mng_id=? and rent_l_cd=? and com_con_no=upper(?)  "+
				" ";
            
       try{
            con.setAutoCommit(false);            
            
            pstmt = con.prepareStatement(query);

			pstmt.setString	(1,		bean.getCar_nm		());
			pstmt.setString	(2,		bean.getOpt			());
			pstmt.setString	(3,		bean.getColo		());
			pstmt.setString	(4,		bean.getPurc_gu		());
			pstmt.setString	(5,		bean.getAuto		());
			pstmt.setInt	(6,		bean.getCar_c_amt	());
			pstmt.setInt	(7,		bean.getCar_f_amt	());
			pstmt.setInt	(8,		bean.getDc_amt		());
			pstmt.setInt	(9,	    bean.getAdd_dc_amt	());
			pstmt.setInt	(10,	bean.getCar_d_amt	());
			pstmt.setInt	(11,	bean.getCar_g_amt	());
			pstmt.setInt	(12,	bean.getCons_amt	());
			pstmt.setString	(13,	bean.getDlv_st		());
			pstmt.setString	(14,	bean.getDlv_est_dt	());
			pstmt.setString	(15,	bean.getDlv_con_dt	());
			pstmt.setString	(16,	bean.getDlv_ext		());
			pstmt.setString	(17,	bean.getDlv_mng_id	());
			pstmt.setString	(18,	bean.getUdt_st		());
			pstmt.setString	(19,	bean.getUdt_mng_id	());
			pstmt.setString	(20,	bean.getUdt_firm	());
			pstmt.setString	(21,	bean.getUdt_addr	());
			pstmt.setString	(22,	bean.getUse_yn		());
			pstmt.setString	(23,	bean.getUdt_mng_nm	());
			pstmt.setString	(24,	bean.getUdt_mng_tel ());
			pstmt.setString	(25,	bean.getDlv_dt		());
			pstmt.setString	(26,	bean.getReg_id		());
			pstmt.setString	(27,	bean.getStock_yn	());
			pstmt.setString	(28,	bean.getBigo		());
			pstmt.setString	(29,	bean.getStock_st	());
			pstmt.setString	(30,	bean.getOrder_car	());
			pstmt.setString	(31,	bean.getSuc_yn		());
			pstmt.setString	(32,	bean.getRent_mng_id	());
			pstmt.setString	(33,	bean.getRent_l_cd	());
			pstmt.setString	(34,	bean.getCom_con_no	());



            pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
                con.rollback();
		  		flag = false;
				System.out.println("[CarOfficeDatabase:updateCarPurCom]\n"+se);
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


	/*
	*	협력업체계출관리 한건
	*/
	public CarPurDocListBean getCarPurCom(String rent_mng_id, String rent_l_cd, String com_con_no) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		CarPurDocListBean bean = new CarPurDocListBean();
		String query = "";
					
		query = " select a.*, to_char(a.reg_dt,'YYYYMMDD') reg_dt2  "+
				" from   car_pur_com a "+
				" where  a.rent_mng_id='"+rent_mng_id+"' and a.rent_l_cd='"+rent_l_cd+"' and com_con_no='"+com_con_no+"' ";

		try {
			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();

			if(rs.next()){

				bean.setRent_mng_id	(rs.getString(1));
				bean.setRent_l_cd	(rs.getString(2));
				bean.setCom_con_no	(rs.getString(3)==null?"":rs.getString(3));
				bean.setCar_nm		(rs.getString(4)==null?"":rs.getString(4));
				bean.setOpt			(rs.getString(5)==null?"":rs.getString(5));
				bean.setColo		(rs.getString(6)==null?"":rs.getString(6));
				bean.setPurc_gu		(rs.getString(7)==null?"":rs.getString(7));
				bean.setAuto		(rs.getString(8)==null?"":rs.getString(8));
				bean.setCar_c_amt	(rs.getInt   (9));
				bean.setCar_f_amt	(rs.getInt   (10));
				bean.setDc_amt		(rs.getInt   (11));
				bean.setAdd_dc_amt	(rs.getInt   (12));
				bean.setCar_d_amt	(rs.getInt   (13));
				bean.setCar_g_amt	(rs.getInt   (14));
				bean.setCons_amt	(rs.getInt   (15));
				bean.setDlv_st		(rs.getString(16)==null?"":rs.getString(16));
				bean.setDlv_est_dt	(rs.getString(17)==null?"":rs.getString(17));
				bean.setDlv_con_dt	(rs.getString(18)==null?"":rs.getString(18));
				bean.setDlv_ext		(rs.getString(19)==null?"":rs.getString(19));
				bean.setDlv_mng_id	(rs.getString(20)==null?"":rs.getString(20));
				bean.setUdt_st		(rs.getString(21)==null?"":rs.getString(21));
				bean.setUdt_mng_id	(rs.getString(22)==null?"":rs.getString(22));
				bean.setUdt_firm	(rs.getString(23)==null?"":rs.getString(23));
				bean.setUdt_addr	(rs.getString(24)==null?"":rs.getString(24));
				bean.setReg_id      (rs.getString(25)==null?"":rs.getString(25));
				bean.setReg_dt      (rs.getString(26)==null?"":rs.getString(26));
				bean.setCon_id      (rs.getString(27)==null?"":rs.getString(27));
				bean.setCon_dt      (rs.getString(28)==null?"":rs.getString(28));
				bean.setUse_yn      (rs.getString(29)==null?"":rs.getString(29));
				bean.setUdt_mng_nm	(rs.getString(30)==null?"":rs.getString(30));
				bean.setUdt_mng_tel	(rs.getString(31)==null?"":rs.getString(31));
				bean.setDlv_dt		(rs.getString(32)==null?"":rs.getString(32));
				bean.setSettle_id   (rs.getString(33)==null?"":rs.getString(33));
				bean.setSettle_dt   (rs.getString(34)==null?"":rs.getString(34));			
				bean.setCar_comp_id (rs.getString(35)==null?"":rs.getString(35));			
//				bean.setUpd_id      (rs.getString(36)==null?"":rs.getString(36));
//				bean.setUpd_dt      (rs.getString(37)==null?"":rs.getString(37));
				bean.setStock_yn    (rs.getString(38)==null?"":rs.getString(38));
				bean.setBigo	    (rs.getString(39)==null?"":rs.getString(39));
				bean.setStock_st    (rs.getString(40)==null?"":rs.getString(40));
				bean.setCar_off_id  (rs.getString(41)==null?"":rs.getString(41));			
				bean.setCons_off_nm (rs.getString(42)==null?"":rs.getString(42));			
				bean.setCons_off_tel(rs.getString(43)==null?"":rs.getString(43));			
				bean.setOrder_car	(rs.getString(44)==null?"":rs.getString(44));
				bean.setOrder_req_id(rs.getString(45)==null?"":rs.getString(45));
				bean.setOrder_req_dt(rs.getString(46)==null?"":rs.getString(46));			
				bean.setOrder_chk_id(rs.getString(47)==null?"":rs.getString(47));
				bean.setOrder_chk_dt(rs.getString(48)==null?"":rs.getString(48));			
				bean.setSuc_yn      (rs.getString(49)==null?"":rs.getString(49));
				bean.setUpd_dt      (rs.getString(50)==null?"":rs.getString(50));
				

			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CarOfficeDatabase:getCarPurCom]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return bean;
	}

	/*
	*	협력업체계출관리 한건
	*/
	public CarPurDocListBean getCarPurCom(String com_con_no) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		CarPurDocListBean bean = new CarPurDocListBean();
		String query = "";
					
		query = " select a.*  "+
				" from   car_pur_com a "+
				" where  a.com_con_no='"+com_con_no+"' and (a.use_yn<>'N' or (a.use_yn='N' and a.suc_yn='D') )";

		try {
			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();

			if(rs.next()){

				bean.setRent_mng_id	(rs.getString(1));
				bean.setRent_l_cd	(rs.getString(2));
				bean.setCom_con_no	(rs.getString(3)==null?"":rs.getString(3));
				bean.setCar_nm		(rs.getString(4)==null?"":rs.getString(4));
				bean.setOpt			(rs.getString(5)==null?"":rs.getString(5));
				bean.setColo		(rs.getString(6)==null?"":rs.getString(6));
				bean.setPurc_gu		(rs.getString(7)==null?"":rs.getString(7));
				bean.setAuto		(rs.getString(8)==null?"":rs.getString(8));
				bean.setCar_c_amt	(rs.getInt   (9));
				bean.setCar_f_amt	(rs.getInt   (10));
				bean.setDc_amt		(rs.getInt   (11));
				bean.setAdd_dc_amt	(rs.getInt   (12));
				bean.setCar_d_amt	(rs.getInt   (13));
				bean.setCar_g_amt	(rs.getInt   (14));
				bean.setCons_amt	(rs.getInt   (15));
				bean.setDlv_st		(rs.getString(16)==null?"":rs.getString(16));
				bean.setDlv_est_dt	(rs.getString(17)==null?"":rs.getString(17));
				bean.setDlv_con_dt	(rs.getString(18)==null?"":rs.getString(18));
				bean.setDlv_ext		(rs.getString(19)==null?"":rs.getString(19));
				bean.setDlv_mng_id	(rs.getString(20)==null?"":rs.getString(20));
				bean.setUdt_st		(rs.getString(21)==null?"":rs.getString(21));
				bean.setUdt_mng_id	(rs.getString(22)==null?"":rs.getString(22));
				bean.setUdt_firm	(rs.getString(23)==null?"":rs.getString(23));
				bean.setUdt_addr	(rs.getString(24)==null?"":rs.getString(24));
				bean.setReg_id      (rs.getString(25)==null?"":rs.getString(25));
				bean.setReg_dt      (rs.getString(26)==null?"":rs.getString(26));
				bean.setCon_id      (rs.getString(27)==null?"":rs.getString(27));
				bean.setCon_dt      (rs.getString(28)==null?"":rs.getString(28));
				bean.setUse_yn      (rs.getString(29)==null?"":rs.getString(29));
				bean.setUdt_mng_nm	(rs.getString(30)==null?"":rs.getString(30));
				bean.setUdt_mng_tel	(rs.getString(31)==null?"":rs.getString(31));
				bean.setDlv_dt		(rs.getString(32)==null?"":rs.getString(32));
				bean.setSettle_id   (rs.getString(33)==null?"":rs.getString(33));
				bean.setSettle_dt   (rs.getString(34)==null?"":rs.getString(34));			
				bean.setCar_comp_id (rs.getString(35)==null?"":rs.getString(35));			
//				bean.setUpd_id      (rs.getString(36)==null?"":rs.getString(36));
//				bean.setUpd_dt      (rs.getString(37)==null?"":rs.getString(37));
				bean.setStock_yn    (rs.getString(38)==null?"":rs.getString(38));
				bean.setBigo	    (rs.getString(39)==null?"":rs.getString(39));
				bean.setStock_st    (rs.getString(40)==null?"":rs.getString(40));
				bean.setCar_off_id  (rs.getString(41)==null?"":rs.getString(41));			
				bean.setCons_off_nm (rs.getString(42)==null?"":rs.getString(42));			
				bean.setCons_off_tel(rs.getString(43)==null?"":rs.getString(43));			
				bean.setOrder_car	(rs.getString(44)==null?"":rs.getString(44));
				bean.setOrder_req_id(rs.getString(45)==null?"":rs.getString(45));
				bean.setOrder_req_dt(rs.getString(46)==null?"":rs.getString(46));			
				bean.setOrder_chk_id(rs.getString(47)==null?"":rs.getString(47));
				bean.setOrder_chk_dt(rs.getString(48)==null?"":rs.getString(48));			
				bean.setSuc_yn      (rs.getString(49)==null?"":rs.getString(49));

			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CarOfficeDatabase:getCarPurCom]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return bean;
	}

	/*
	*	배정관리 차종변경번호 
	*/
	public int getCarPurComCngNextSeq(String rent_mng_id, String rent_l_cd, String com_con_no) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int seq = 0;
		String query = "";
					
		query = " SELECT nvl(max(seq)+1,1) as next_seq from car_pur_com_cng where rent_mng_id=? and rent_l_cd=? and com_con_no=? ";


		try {
			pstmt = con.prepareStatement(query);
			pstmt.setString	(1,	rent_mng_id);
			pstmt.setString	(2,	rent_l_cd);
			pstmt.setString	(3,	com_con_no);
			rs = pstmt.executeQuery();
			
			if(rs.next())
			{				
				seq = rs.getInt("next_seq");
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CarOfficeDatabase:getCarPurComCngNextSeq]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return seq;
	}


	/*
	*	협력업체-계출관리-변경계약
	*/
	public Vector getCarPurComCngs(String rent_mng_id, String rent_l_cd, String com_con_no) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

					
		query = " SELECT to_char(reg_dt,'YYYYMMDD') reg_dt2, to_char(cng_dt,'YYYYMMDD') cng_dt2, a.* from car_pur_com_cng a where a.rent_mng_id=? and a.rent_l_cd=? and a.com_con_no=? order by a.seq ";



		try {
			pstmt = con.prepareStatement(query);
			pstmt.setString	(1,	rent_mng_id);
			pstmt.setString	(2,	rent_l_cd);
			pstmt.setString	(3,	com_con_no);
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
			System.out.println("[CarOfficeDatabase:getCarPurComCngs]"+ e);
			System.out.println("[CarOfficeDatabase:getCarPurComCngs]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}
	
	/*
	 *	협력업체-계출관리-변경계약 한건
	 */
	public Vector getCarPurComCngsNew(String rent_mng_id, String rent_l_cd, String com_con_no) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
			throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = " SELECT * " +
					" FROM( " +
						" SELECT a.*, ROW_NUMBER() OVER(ORDER BY a.seq desc) AS RNUM " +
						" FROM car_pur_com_cng a where  a.rent_mng_id=? and a.rent_l_cd=? and a.com_con_no=? AND a.cng_st = '1' " +
					" ) " +
					" WHERE RNUM = 1 ";
		
		try {
			pstmt = con.prepareStatement(query);
			pstmt.setString	(1,	rent_mng_id);
			pstmt.setString	(2,	rent_l_cd);
			pstmt.setString	(3,	com_con_no);
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
			System.out.println("[CarOfficeDatabase:getCarPurComCngsNew]"+ e);
			System.out.println("[CarOfficeDatabase:getCarPurComCngsNew]"+ query);
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

	/*
	*	협력업체계출관리 한건
	*/
	public CarPurDocListBean getCarPurComCng(String rent_mng_id, String rent_l_cd, String com_con_no, String seq) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		CarPurDocListBean bean = new CarPurDocListBean();
		String query = "";
					
		query = " select a.*  "+
				" from   car_pur_com_cng a "+
				" where  a.rent_mng_id='"+rent_mng_id+"' and a.rent_l_cd='"+rent_l_cd+"' and a.com_con_no='"+com_con_no+"' and a.seq="+seq+" ";

		try {
			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();

			if(rs.next()){

				bean.setRent_mng_id	(rs.getString(1));
				bean.setRent_l_cd	(rs.getString(2));
				bean.setCom_con_no	(rs.getString(3));
				bean.setSeq      	(rs.getInt   (4));
				bean.setCng_st		(rs.getString(5)==null?"":rs.getString(5));
				bean.setCng_cont	(rs.getString(6)==null?"":rs.getString(6));
				bean.setCar_nm		(rs.getString(7)==null?"":rs.getString(7));
				bean.setOpt			(rs.getString(8)==null?"":rs.getString(8));
				bean.setColo		(rs.getString(9)==null?"":rs.getString(9));
				bean.setPurc_gu		(rs.getString(10)==null?"":rs.getString(10));
				bean.setAuto		(rs.getString(11)==null?"":rs.getString(11));
				bean.setCar_c_amt	(rs.getInt   (12));
				bean.setCar_f_amt	(rs.getInt   (13));
				bean.setDc_amt		(rs.getInt   (14));
				bean.setAdd_dc_amt	(rs.getInt   (15));
				bean.setCar_d_amt	(rs.getInt   (16));
				bean.setCar_g_amt	(rs.getInt   (17));
				bean.setReg_id      (rs.getString(18)==null?"":rs.getString(18));
				bean.setReg_dt      (rs.getString(19)==null?"":rs.getString(19));
				bean.setCng_id      (rs.getString(20)==null?"":rs.getString(20));
				bean.setCng_dt      (rs.getString(21)==null?"":rs.getString(21));
				bean.setCng_yn      (rs.getString(22)==null?"":rs.getString(22));
			
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CarOfficeDatabase:getCarPurComCng]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return bean;
	}

	//해지보험공문 한건 수정
    public boolean updateCarPurComCngAct(CarPurDocListBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        boolean flag = true;
                
		query = " update car_pur_com_cng set "+
				"        cng_dt=sysdate, cng_id=?, cng_yn='Y' "+
				" where  rent_mng_id=? and rent_l_cd=? and com_con_no=? and seq=?  "+
				" ";
            
       try{
            con.setAutoCommit(false);            
            
            pstmt = con.prepareStatement(query);
			pstmt.setString	(1,	bean.getCng_id		());
			pstmt.setString	(2,	bean.getRent_mng_id	());
			pstmt.setString	(3,	bean.getRent_l_cd	());
			pstmt.setString	(4,	bean.getCom_con_no	());
			pstmt.setInt	(5,	bean.getSeq			());

            pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
                con.rollback();
		  		flag = false;
				System.out.println("[CarOfficeDatabase:updateCarPurComCngAct]\n"+se);
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

	//해지보험공문 한건 수정
    public boolean updateCarPurComCngSucN(CarPurDocListBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        boolean flag = true;
                
		query = " update car_pur_com_cng set "+
				"        cng_cont=?, bigo=?, reg_dt=sysdate "+
				" where  rent_mng_id=? and rent_l_cd=? and com_con_no=? and seq=?  "+
				" ";
            
       try{
            con.setAutoCommit(false);            
            
            pstmt = con.prepareStatement(query);
			pstmt.setString	(1,	bean.getCng_cont	());
			pstmt.setString	(2,	bean.getBigo		());
			pstmt.setString	(3,	bean.getRent_mng_id	());
			pstmt.setString	(4,	bean.getRent_l_cd	());
			pstmt.setString	(5,	bean.getCom_con_no	());
			pstmt.setInt	(6,	bean.getSeq			());

            pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
                con.rollback();
		  		flag = false;
				System.out.println("[CarOfficeDatabase:updateCarPurComCngSucN]\n"+se);
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

	//해지보험공문 한건 수정
    public boolean updateCarPurComDlv(CarPurDocListBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        boolean flag = true;
                
		query = " update car_pur_com set "+
				"        settle_dt=sysdate, settle_id=?, dlv_dt=replace(?,'-','') "+
				" where  rent_mng_id=? and rent_l_cd=? and com_con_no=?  "+
				" ";
            
       try{
            con.setAutoCommit(false);            
            
            pstmt = con.prepareStatement(query);
			pstmt.setString	(1,	bean.getSettle_id	());
			pstmt.setString	(2,	bean.getDlv_dt   	());
			pstmt.setString	(3,	bean.getRent_mng_id	());
			pstmt.setString	(4,	bean.getRent_l_cd	());
			pstmt.setString	(5,	bean.getCom_con_no	());

            pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
                con.rollback();
		  		flag = false;
				System.out.println("[CarOfficeDatabase:updateCarPurComDlv]\n"+se);
				System.out.println("[bean.getSettle_id		()]\n"+bean.getSettle_id	());
				System.out.println("[bean.getDlv_dt   		()]\n"+bean.getDlv_dt   	());
				System.out.println("[bean.getRent_mng_id	()]\n"+bean.getRent_mng_id	());
				System.out.println("[bean.getRent_l_cd		()]\n"+bean.getRent_l_cd	());
				System.out.println("[bean.getCom_con_no		()]\n"+bean.getCom_con_no	());
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

	/*
	*	특판계약번호 중복체크
	*/
	public int checkComConNo(String com_con_no) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		String query = "";
					
		query = " SELECT count(0) cnt from car_pur_com where upper(com_con_no)=upper(?) and nvl(use_yn,'Y')<>'N' and nvl(suc_yn,'N') not in ('D','Y')  ";


		try {
			pstmt = con.prepareStatement(query);
			pstmt.setString	(1,	com_con_no);
			rs = pstmt.executeQuery();
			
			if(rs.next())
			{				
				count = rs.getInt("cnt");
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CarOfficeDatabase:checkComConNo]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return count;
	}

	//해지보험공문 한건 수정
    public boolean updateCarPurComCng(CarPurDocListBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        boolean flag = true;
                
		query = " update car_pur_com_cng set "+
				"        car_nm=?, opt=?, colo=?, purc_gu=?, auto=?, "+
				"        car_c_amt=?, car_f_amt=?, dc_amt=?, add_dc_amt=?, car_d_amt=?, car_g_amt=? "+
				" where  rent_mng_id=? and rent_l_cd=? and com_con_no=? and seq=?  "+
				" ";
            
       try{
            con.setAutoCommit(false);            
            
            pstmt = con.prepareStatement(query);

			pstmt.setString	(1,		bean.getCar_nm		());
			pstmt.setString	(2,		bean.getOpt			());
			pstmt.setString	(3,		bean.getColo		());
			pstmt.setString	(4,		bean.getPurc_gu		());
			pstmt.setString	(5,		bean.getAuto		());
			pstmt.setInt	(6,		bean.getCar_c_amt	());
			pstmt.setInt	(7,		bean.getCar_f_amt	());
			pstmt.setInt	(8,		bean.getDc_amt		());
			pstmt.setInt	(9,	    bean.getAdd_dc_amt	());
			pstmt.setInt	(10,	bean.getCar_d_amt	());
			pstmt.setInt	(11,	bean.getCar_g_amt	());
			pstmt.setString	(12,	bean.getRent_mng_id	());
			pstmt.setString	(13,	bean.getRent_l_cd	());
			pstmt.setString	(14,	bean.getCom_con_no	());
			pstmt.setInt	(15,	bean.getSeq			());

            pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
                con.rollback();
		  		flag = false;
				System.out.println("[CarOfficeDatabase:updateCarPurComCng]\n"+se);
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


	/*
	*	협력업체-계출관리-계약
	*/
	public Hashtable getPurComCont(String rent_mng_id, String rent_l_cd) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

					
			query = " SELECT \n"+
					"        DECODE(a.use_yn,'Y','신규','C','변경','N',decode(a.suc_yn,'D','변경','Y','변경','해지')) use_yn_st, \n"+
					"        DECODE(c.rent_l_cd,'',a.car_nm,c.car_nm) r_car_nm, \n"+
					"        DECODE(c.rent_l_cd,'',a.opt,c.opt) r_opt, \n"+
					"        DECODE(c.rent_l_cd,'',a.colo,c.colo) r_colo, \n"+
					"        DECODE(c.rent_l_cd,'',a.auto,c.auto) r_auto, \n"+
					"        DECODE(c.rent_l_cd,'',a.purc_gu,c.purc_gu) r_purc_gu, \n"+
					"        DECODE(c.rent_l_cd,'',a.car_c_amt,c.car_c_amt) r_car_c_amt, \n"+
					"        DECODE(c.rent_l_cd,'',a.car_f_amt,c.car_f_amt) r_car_f_amt, \n"+
					"        DECODE(c.rent_l_cd,'',a.dc_amt,c.dc_amt) r_dc_amt, \n"+
					"        DECODE(c.rent_l_cd,'',a.add_dc_amt,c.add_dc_amt) r_add_dc_amt, \n"+
					"        DECODE(c.rent_l_cd,'',a.car_d_amt,c.car_d_amt) r_car_d_amt, \n"+
					"        DECODE(c.rent_l_cd,'',a.car_g_amt,c.car_g_amt) r_car_g_amt, \n"+
					"        DECODE(d.rent_l_cd,'',c2.reg_dt,d.reg_dt) cng_reg_dt, \n"+
					"        DECODE(d.rent_l_cd,'',c2.cng_dt,d.cng_dt) cng_app_dt, \n"+
					"        DECODE(d.rent_l_cd,'',c2.cng_cont,d.cng_cont) cng_cont, \n"+
					"        b.rent_dt, e.firm_nm, f.user_nm AS bus_nm, \n"+
					"        decode(a.dlv_st,'1','예정','2','배정') dlv_st_nm, "+
					"        decode(a.udt_st,'1','서울본사','2','부산지점','3','대전지점','4','고객','5','대구지점','6','광주지점') udt_st_nm, "+
					"        g.user_id as car_off_user_id, "+
					"        a.* \n"+
					" FROM   CAR_PUR_COM a, CONT b,    \n"+
					"        (select * from CAR_PUR_COM_CNG a where a.cng_st='1' and a.cng_cont<>'배달지' AND a.seq = (select max(seq) from CAR_PUR_COM_CNG WHERE cng_st='1' and cng_cont<>'배달지' and rent_mng_id=a.rent_mng_id AND rent_l_cd=a.rent_l_cd and com_con_no=a.com_con_no)) c, \n"+
					"        (select * from CAR_PUR_COM_CNG a where a.cng_st in ('1','3','4','5') AND a.seq = (select max(seq) from CAR_PUR_COM_CNG WHERE cng_st in ('1','3','4','5') and rent_mng_id=a.rent_mng_id AND rent_l_cd=a.rent_l_cd and com_con_no=a.com_con_no)) c2, \n"+
					"        (SELECT * FROM CAR_PUR_COM_CNG a WHERE a.cng_st='2' and a.cng_cont<>'신차취소현황으로 보내기') d, \n"+
					"        CLIENT e, USERS f, USERS g \n"+
					" WHERE  a.rent_mng_id=? and a.rent_l_cd=? and a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd "+
					"        AND a.rent_mng_id=c.rent_mng_id(+) AND a.rent_l_cd=c.rent_l_cd(+) and a.com_con_no=c.com_con_no(+) \n"+
					"        AND a.rent_mng_id=c2.rent_mng_id(+) AND a.rent_l_cd=c2.rent_l_cd(+) and a.com_con_no=c2.com_con_no(+) \n"+
					"        AND a.rent_mng_id=d.rent_mng_id(+) AND a.rent_l_cd=d.rent_l_cd(+) and a.com_con_no=d.com_con_no(+) \n"+
					"        AND b.client_id=e.client_id AND b.BUS_ID=f.user_id "+
				    "        and nvl(d.cng_yn,'N')='N' and a.suc_yn is null "+
					"        and a.car_off_id=g.sa_code "+
					" ";


		try {
			pstmt = con.prepareStatement(query);
			pstmt.setString	(1,		rent_mng_id);
			pstmt.setString	(2,		rent_l_cd);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next())
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
			System.out.println("[CarOfficeDatabase:getPurComCont]"+ e);
			System.out.println("[CarOfficeDatabase:getPurComCont]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return ht;
	}

	/*
	*	협력업체-계출관리-등록계약  
	*/
	public Vector getPurComLcFirmList(String s_kd, String t_wd, String sort, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String dt = "";
					

			query = " SELECT  \n"+
					"        a.rent_mng_id, a.rent_l_cd, a.reg_dt, a.rent_dt, g.user_nm as bus_nm, decode(g.br_id,'S1','서울','B1','부산','D1','대전','서울') udt_st, \n"+
					"        decode(c.client_st,'1','법인','2','개인','3','개인사업자') client_st_nm, c.firm_nm, b.pur_req_yn, b.dir_pur_yn, \n"+
					"        decode(b.pur_req_dt,'','즉시',to_char(to_date(b.pur_req_dt,'YYYYMMDD'),'MM/DD')) pur_req_dt, \n"+
					"        decode(b.pur_bus_st,'1','자체영업','2','영업사원영업','3','실적이관','4','에이전트영업') pur_bus_st, \n"+
					"        decode(b.one_self,'Y','자체출고','N','영업사원출고') one_self, \n"+
					"        decode(b.dir_pur_yn,'Y','특판출고','기타자체출고') dir_pur_yn_nm, \n"+
					"        f.car_nm||' '||e.car_name as car_name, \n"+
                    "        CASE WHEN e.auto_yn = 'Y' THEN 'A/T' \n"+
                    "             WHEN e.auto_yn = 'N' AND INSTR(REPLACE(e.CAR_B,' ',''),'자동변속기') >0 THEN 'A/T' \n"+
                    "             WHEN e.auto_yn = 'N' AND INSTR(REPLACE(d.opt,' ',''),'변속기') >0 THEN 'A/T' \n"+
                    "             WHEN e.auto_yn = 'N' AND INSTR(REPLACE(UPPER(d.opt),' ',''),'DCT') >0 THEN 'A/T' \n"+
                    "             WHEN e.auto_yn = 'N' AND INSTR(REPLACE(UPPER(d.opt),' ',''),'C-TECH') >0 THEN 'A/T' \n"+
                    "             WHEN e.auto_yn = 'N' AND INSTR(REPLACE(UPPER(d.opt),' ',''),'A/T') >0 THEN 'A/T' \n"+
                    "             WHEN e.auto_yn = 'N' AND INSTR(REPLACE(e.CAR_B,' ',''),'무단변속기') >0 THEN 'A/T' \n"+
                    "             ELSE 'M/T' \n"+
                    "        END auto, \n"+
					"        d.opt, d.colo, d.in_col, d.garnish_col, decode(d.purc_gu,'0','면세','1','과세',decode(a.car_st,'3','과세','면세')) purc_gu, \n"+
					"        h.agnt_st, h.emp_id, h.emp_nm, h.car_off_nm, h.nm as car_comp_nm, \n"+
					"        (nvl(d.car_cs_amt,0) + nvl(d.car_cv_amt,0) + nvl(d.opt_cs_amt,0)+nvl(d.opt_cv_amt,0) + nvl(d.clr_cs_amt,0) + nvl(d.clr_cv_amt,0) - nvl(d.tax_dc_s_amt,0) - nvl(d.tax_dc_v_amt,0)) car_amt, \n"+
					"        decode(i2.rent_l_cd,'','','취소건') cls_yn "+
					" from   cont a, car_pur b, client c, car_etc d, car_nm e, car_mng f, users g,  \n"+
					"        (SELECT aa.agnt_st, aa.rent_mng_id, aa.rent_l_cd, bb.emp_id, bb.emp_nm, cc.car_off_id, cc.car_off_nm, dd.nm \n"+
					"         FROM   COMMI aa, CAR_OFF_EMP bb, CAR_OFF cc, CODE dd  \n"+
					"         WHERE  aa.agnt_st='2' AND aa.emp_id=bb.emp_id AND bb.car_off_id=cc.car_off_id AND cc.car_comp_id=DD.CODE AND dd.c_st='0001' \n"+
					"                AND dd.code in ('0001','0002','0004') \n"+		//지엠강서구청점 추가 (2018.03.22)
					"        ) h, \n"+
					"        (select rent_mng_id, rent_l_cd from car_pur_com where nvl(use_yn,'Y') in ('Y','C') group by rent_mng_id, rent_l_cd) i, \n"+
					"        (select a.rent_mng_id, a.rent_l_cd from car_pur_com a, car_pur_com_cng b where a.use_yn='N' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.com_con_no=b.com_con_no and b.cng_st='2' and b.cng_cont<>'차종변경' group by a.rent_mng_id, a.rent_l_cd) i2 \n"+
					" where  nvl(a.use_yn,'Y')='Y' and a.car_gu='1'  "+
					"        and a.dlv_dt is null \n"+
					"        and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
					"        and a.client_id=c.client_id  "+
					"        and b.pur_com_firm is null \n"+
					"        and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd \n"+
					"        and d.car_id=e.car_id and d.car_seq=e.car_seq \n"+
					"        AND e.car_comp_id = '0001' \n"+
					"        and e.car_comp_id=f.car_comp_id and e.car_cd=f.code \n"+
					"        and a.bus_id=g.user_id \n"+
					"        AND a.rent_mng_id=h.rent_mng_id AND a.rent_l_cd=h.rent_l_cd \n"+
					"        AND a.rent_mng_id=i.rent_mng_id(+) and a.rent_l_cd=i.rent_l_cd(+) and i.rent_l_cd is null "+
					"        AND a.rent_mng_id=i2.rent_mng_id(+) and a.rent_l_cd=i2.rent_l_cd(+) "+
					"        AND h.car_off_id = '03900' "+		//현대법인특판팀만 으로 수정(20190521)
					"        and decode(i2.rent_l_cd,'','0','1')||decode(b.pur_req_dt,'','1','0')<>'11' "+
					" ";

			if(!gubun4.equals(""))	query += " AND h.car_off_id='"+gubun4+"' ";

			String search = "";
			String what = "";
			String dt1 = "";
			String dt2 = "";

			if(gubun1.equals("1")){
				dt1 = "substr(a.reg_dt,1,6)";
				dt2 = "a.reg_dt";
			}else if(gubun1.equals("2")){
				dt1 = "substr(b.pur_req_dt,1,6)";
				dt2 = "b.pur_req_dt";
			}

			//당일
			if(gubun2.equals("1"))				query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
			//전일
			else if(gubun2.equals("2"))			query += " and "+dt2+" = to_char(sysdate-1,'YYYYMM')";		
			//당월
			else if(gubun2.equals("3"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%' ";
			//기간
			else if(gubun2.equals("4")){
				if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
				if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
			}

			if(s_kd.equals("1"))	what = "upper(nvl(c.firm_nm, ' '))";
			if(s_kd.equals("2"))	what = "upper(nvl(a.rent_l_cd, ' '))";	
			if(s_kd.equals("3"))	what = "upper(nvl(f.car_nm||e.car_name, ' '))";		
			if(s_kd.equals("4"))	what = "upper(nvl(g.user_nm, ' '))";	
			if(s_kd.equals("5"))	what = "upper(nvl(a.rent_dt, ' '))";		
			if(s_kd.equals("6"))	what = "upper(nvl(b.pur_req_dt, ' '))";	
			if(s_kd.equals("7"))	what = "(nvl(d.car_cs_amt,0) + nvl(d.car_cv_amt,0) + nvl(d.opt_cs_amt,0)+nvl(d.opt_cv_amt,0) + nvl(d.clr_cs_amt,0) + nvl(d.clr_cv_amt,0) - nvl(d.tax_dc_s_amt,0) - nvl(d.tax_dc_v_amt,0))";	
			
			if(!s_kd.equals("") && !t_wd.equals("")){
				if(s_kd.equals("7")){
					query += " and "+what+" = "+t_wd+" ";
				}else{
					query += " and "+what+" like upper('%"+t_wd+"%') ";
				}
			}

			if(sort.equals("1"))		query += " order by e.car_comp_id, h.car_off_id, a.reg_dt, b.pur_req_dt, c.firm_nm ";
			if(sort.equals("2"))		query += " order by e.car_comp_id, h.car_off_id, b.pur_req_dt, a.reg_dt, c.firm_nm ";
			if(sort.equals("3"))		query += " order by e.car_comp_id, h.car_off_id, e.jg_code, a.reg_dt, b.pur_req_dt, c.firm_nm ";


		try {
			pstmt = con.prepareStatement(query);
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
//			System.out.println("[CarOfficeDatabase:getPurComLcFirmList]"+ query);
		} catch (SQLException e) {
			System.out.println("[CarOfficeDatabase:getPurComLcFirmList]"+ e);
			System.out.println("[CarOfficeDatabase:getPurComLcFirmList]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

	/*
	*	협력업체-계출관리-신규계약
	*/
	public Vector getPurComLcRentList(String s_kd, String t_wd, String sort, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String dt = "";
					

			query = " SELECT  \n"+
					"        a.rent_mng_id, a.rent_l_cd, a.reg_dt, a.rent_dt, a.agent_emp_id, g.user_nm as bus_nm, decode(g.br_id,'S1','서울','B1','부산','D1','대전','서울') udt_st, \n"+
					"        c.firm_nm, nvl(b.pur_com_firm,c.firm_nm) pur_com_firm, b.pur_req_yn, b.dir_pur_yn, \n"+
					"        decode(b.pur_req_dt,'','즉시',to_char(to_date(b.pur_req_dt,'YYYYMMDD'),'MM/DD')) pur_req_dt, \n"+
					"        decode(b.pur_bus_st,'1','자체영업','2','영업사원영업','3','실적이관','4','에이전트영업') pur_bus_st, \n"+
					"        f.car_nm||' '||e.car_name as car_name, \n"+
                    "        CASE WHEN e.auto_yn = 'Y' THEN 'A/T' \n"+
                    "             WHEN e.auto_yn = 'N' AND INSTR(REPLACE(e.CAR_B,' ',''),'자동변속기') >0 THEN 'A/T' \n"+
                    "             WHEN e.auto_yn = 'N' AND INSTR(REPLACE(d.opt,' ',''),'변속기') >0 THEN 'A/T' \n"+
                    "             WHEN e.auto_yn = 'N' AND INSTR(REPLACE(UPPER(d.opt),' ',''),'DCT') >0 THEN 'A/T' \n"+
                    "             WHEN e.auto_yn = 'N' AND INSTR(REPLACE(UPPER(d.opt),' ',''),'C-TECH') >0 THEN 'A/T' \n"+
                    "             WHEN e.auto_yn = 'N' AND INSTR(REPLACE(UPPER(d.opt),' ',''),'A/T') >0 THEN 'A/T' \n"+
                    "             WHEN e.auto_yn = 'N' AND INSTR(REPLACE(e.CAR_B,' ',''),'무단변속기') >0 THEN 'A/T' \n"+
                    "             ELSE 'M/T' \n"+
                    "        END auto, \n"+
					"        d.opt, d.colo, d.in_col, d.garnish_col, decode(d.purc_gu,'0','면세','1','과세',decode(a.car_st,'3','과세','면세')) purc_gu, \n"+
					"        h.agnt_st, h.emp_id, h.emp_nm, h.car_off_nm, h.nm as car_comp_nm, \n"+
					"        (nvl(d.car_cs_amt,0) + nvl(d.car_cv_amt,0) + nvl(d.opt_cs_amt,0)+nvl(d.opt_cv_amt,0) + nvl(d.clr_cs_amt,0) + nvl(d.clr_cv_amt,0) - nvl(d.tax_dc_s_amt,0) - nvl(d.tax_dc_v_amt,0)) car_amt, \n"+
					"        nvl(d.dc_cs_amt,0)+nvl(d.dc_cv_amt,0) dc_c_amt,\r\n"
					+ "                  nvl(d.car_fs_amt,0)+nvl(d.car_fv_amt,0) car_f_amt,\r\n"
					+ "                  nvl(d.car_fs_amt,0)+nvl(d.car_fv_amt,0)-nvl(d.dc_cs_amt,0)-nvl(d.dc_cv_amt,0) car_r_amt, "+
					"        decode(i2.rent_l_cd,'','','취소건') cls_yn "+
					" from   cont a, car_pur b, client c, car_etc d, car_nm e, car_mng f, users g,  \n"+
					"        (SELECT aa.agnt_st, aa.rent_mng_id, aa.rent_l_cd, bb.emp_id, bb.emp_nm, cc.car_off_id, cc.car_off_nm, dd.nm \n"+
					"         FROM   COMMI aa, CAR_OFF_EMP bb, CAR_OFF cc, CODE dd  \n"+
					"         WHERE  aa.agnt_st='2' AND aa.emp_id=bb.emp_id AND bb.car_off_id=cc.car_off_id AND cc.car_comp_id=DD.CODE AND dd.c_st='0001' \n"+
					"                AND dd.code in ('0001','0002','0004') \n"+	//지엠강서구청점 추가 (2018.03.22)
					"        ) h, \n"+
					"        (select rent_mng_id, rent_l_cd from car_pur_com where nvl(use_yn,'Y') in ('Y','C') group by rent_mng_id, rent_l_cd) i, \n"+
					"        (select a.rent_mng_id, a.rent_l_cd from car_pur_com a, car_pur_com_cng b where a.use_yn='N' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.com_con_no=b.com_con_no and b.cng_st='2' and b.cng_cont<>'차종변경' group by a.rent_mng_id, a.rent_l_cd) i2 \n"+
					" where  nvl(a.use_yn,'Y')='Y' and a.car_gu='1'  "+
					"        and a.dlv_dt is null \n"+
					"        and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd "+
					"		 AND ((h.car_off_id = '03900' AND decode(e.car_comp_id,'0001',decode(c.client_st,'1',decode(c.client_id,'000228',b.pur_com_firm,b.pur_com_firm),b.pur_com_firm),c.firm_nm) is not NULL "+
					"					)OR h.car_off_id <> '03900' )\n" +	//수정(20190521)
					"        and a.client_id=c.client_id \n"+
					"        and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd \n"+
					"        and d.car_id=e.car_id and d.car_seq=e.car_seq \n"+
					"        AND e.car_comp_id in ('0001','0002','0004') \n"+	//지엠강서구청점 추가 (2018.03.22)
					"        and e.car_comp_id=f.car_comp_id and e.car_cd=f.code \n"+
					"        and a.bus_id=g.user_id \n"+
					"        AND a.rent_mng_id=h.rent_mng_id AND a.rent_l_cd=h.rent_l_cd \n"+
					"        AND a.rent_mng_id=i.rent_mng_id(+) and a.rent_l_cd=i.rent_l_cd(+) and i.rent_l_cd is null "+
					"        AND a.rent_mng_id=i2.rent_mng_id(+) and a.rent_l_cd=i2.rent_l_cd(+) "+
					"        AND h.car_off_id in ('03900','00998','01129','03579','03954','04500','03548','02176','00588','00631','00623') "+		//20190624(현대한강)
					"        and decode(i2.rent_l_cd,'','0','1')||decode(b.pur_req_dt,'','1','0')<>'11' "+
					" ";

			if(!gubun4.equals(""))	query += " AND h.car_off_id='"+gubun4+"' ";

			String search = "";
			String what = "";
			String dt1 = "";
			String dt2 = "";

			if(gubun1.equals("1")){
				dt1 = "substr(a.reg_dt,1,6)";
				dt2 = "a.reg_dt";
			}else if(gubun1.equals("2")){
				dt1 = "substr(b.pur_req_dt,1,6)";
				dt2 = "b.pur_req_dt";
			}

			//당일
			if(gubun2.equals("1"))				query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
			//전일
			else if(gubun2.equals("2"))			query += " and "+dt2+" = to_char(sysdate-1,'YYYYMM')";		
			//당월
			else if(gubun2.equals("3"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%' ";
			//기간
			else if(gubun2.equals("4")){
				if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
				if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
			}

			if(s_kd.equals("1"))	what = "upper(nvl(b.pur_com_firm||c.firm_nm, ' '))";	
			if(s_kd.equals("2"))	what = "upper(nvl(a.rent_l_cd, ' '))";	
			if(s_kd.equals("3"))	what = "upper(nvl(f.car_nm||e.car_name, ' '))";		
			if(s_kd.equals("4"))	what = "upper(nvl(g.user_nm, ' '))";	
			if(s_kd.equals("5"))	what = "upper(nvl(a.rent_dt, ' '))";		
			if(s_kd.equals("6"))	what = "upper(nvl(nvl(b.pur_com_firm,c.firm_nm), ' '))";	

			
			if(!s_kd.equals("") && !t_wd.equals("")){
				if(s_kd.equals("7")){
					query += " and "+what+" = "+t_wd+" ";
				}else{
					query += " and "+what+" like upper('%"+t_wd+"%') ";
				}
			}

			if(sort.equals("1"))		query += " order by e.car_comp_id, h.car_off_id, a.reg_dt, b.pur_req_dt, c.firm_nm ";
			if(sort.equals("2"))		query += " order by e.car_comp_id, h.car_off_id, b.pur_req_dt, a.reg_dt, c.firm_nm ";
			if(sort.equals("3"))		query += " order by e.car_comp_id, h.car_off_id, e.jg_code, a.reg_dt, b.pur_req_dt, c.firm_nm ";


		try {
			pstmt = con.prepareStatement(query);
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
//			System.out.println("[CarOfficeDatabase:getPurComLcRentList]"+ query);
		} catch (SQLException e) {
			System.out.println("[CarOfficeDatabase:getPurComLcRentList]"+ e);
			System.out.println("[CarOfficeDatabase:getPurComLcRentList]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

	/*
	*	협력업체-계출관리-신규계약
	*/
	public Vector getPurComEstDtList(String s_kd, String t_wd, String sort, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

					
			query = " SELECT  \n"+
					"        DECODE(a.use_yn,'Y','신규','C','변경','N',decode(a.suc_yn,'D','변경','Y','변경','해지')) use_yn_st, \n"+
					"        DECODE(a.stock_yn,'Y','있음','') stock_yn_st, \n"+
					"        DECODE(a.order_car,'Y','주문차','') order_car_st, \n"+
					"        DECODE(c.rent_l_cd,'',a.car_nm,c.car_nm) r_car_nm, \n"+
					"        DECODE(c.rent_l_cd,'',a.opt,c.opt) r_opt, \n"+
					"        DECODE(c.rent_l_cd,'',a.colo,c.colo) r_colo, \n"+
					"        DECODE(c.rent_l_cd,'',a.auto,c.auto) r_auto, \n"+
					"        DECODE(c.rent_l_cd,'',a.purc_gu,c.purc_gu) r_purc_gu, \n"+
					"        DECODE(c.rent_l_cd,'',a.car_c_amt,c.car_c_amt) r_car_c_amt, \n"+
					"        DECODE(c.rent_l_cd,'',a.car_f_amt,c.car_f_amt) r_car_f_amt, \n"+
					"        DECODE(c.rent_l_cd,'',a.car_g_amt,c.car_g_amt) r_car_g_amt, \n"+
					"        DECODE(c.rent_l_cd,'',a.dc_amt+a.add_dc_amt,c.dc_amt+c.add_dc_amt) r_dc_amt, \n"+
					"        DECODE(c.rent_l_cd,'',a.dc_amt,c.dc_amt) r_dc_amt2, \n"+
					"        DECODE(c.rent_l_cd,'',a.add_dc_amt,c.add_dc_amt) r_add_dc_amt, \n"+
					"        DECODE(c.rent_l_cd,'',a.car_g_amt+a.cons_amt,c.car_g_amt+a.cons_amt) r_car_g_amt2, \n"+
					"        to_char(DECODE(d.rent_l_cd,'',c2.reg_dt,d.reg_dt),'YYYYMMDD') cng_reg_dt, \n"+
					"        to_char(DECODE(d.rent_l_cd,'',c2.cng_dt,d.cng_dt),'YYYYMMDD') cng_app_dt, \n"+
					"        DECODE(d.rent_l_cd,'',c2.cng_cont,d.cng_cont) cng_cont, \n"+
					"        b.reg_dt as rent_reg_dt, b.rent_dt, g.dlv_est_dt as pur_dlv_est_dt, e.firm_nm, e.client_st, nvl(g.pur_com_firm,e.firm_nm) pur_com_firm, f.user_nm AS bus_nm, \n"+
					"        decode(a.dlv_st,'1','예정','2','배정') dlv_st_nm, "+
					"        decode(a.udt_st,'1','서울본사','2','부산지점','3','대전지점','4','고객','5','대구지점','6','광주지점') udt_st_nm, "+
					"        (nvl(h.car_cs_amt,0) + nvl(h.car_cv_amt,0) + nvl(h.opt_cs_amt,0)+nvl(h.opt_cv_amt,0) + nvl(h.clr_cs_amt,0) + nvl(h.clr_cv_amt,0) - nvl(h.tax_dc_s_amt,0) - nvl(h.tax_dc_v_amt,0)) f_car_amt, \n"+
					"        a.*, g.pur_req_dt, i.nm as car_comp_nm, j.car_off_nm, to_char(a.reg_dt,'YYYYMMDD') as com_reg_dt  \n"+
					" FROM   CAR_PUR_COM a, CONT b, car_etc h,   \n"+
					"        (select * from CAR_PUR_COM_CNG a where a.cng_st='1' and a.cng_cont<>'배달지' AND a.seq = (select max(seq) from CAR_PUR_COM_CNG WHERE cng_st='1' and cng_cont<>'배달지' and rent_mng_id=a.rent_mng_id AND rent_l_cd=a.rent_l_cd and com_con_no=a.com_con_no)) c, \n"+
					"        (select * from CAR_PUR_COM_CNG a where a.cng_st in ('1','3','4','5') AND a.seq = (select max(seq) from CAR_PUR_COM_CNG WHERE cng_st in ('1','3','4','5') and rent_mng_id=a.rent_mng_id AND rent_l_cd=a.rent_l_cd and com_con_no=a.com_con_no)) c2, \n"+
					"        (SELECT * FROM CAR_PUR_COM_CNG a WHERE a.cng_st='2' and a.cng_cont<>'신차취소현황으로 보내기') d, \n"+
					"        CLIENT e, USERS f, car_pur g, (select * from code where c_st='0001') i, car_off j \n"+
					" WHERE  a.dlv_st='1' and a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd "+
					"        AND a.settle_dt IS NULL  AND DECODE(a.use_yn||a.suc_yn,'N','N','NN','N','NY','N','Y')='Y'\n"+
                    "        and b.rent_mng_id=h.rent_mng_id AND b.rent_l_cd=h.rent_l_cd "+
					"        AND a.rent_mng_id=c.rent_mng_id(+) AND a.rent_l_cd=c.rent_l_cd(+) and a.com_con_no=c.com_con_no(+) \n"+
					"        AND a.rent_mng_id=c2.rent_mng_id(+) AND a.rent_l_cd=c2.rent_l_cd(+) and a.com_con_no=c2.com_con_no(+) \n"+
					"        AND a.rent_mng_id=d.rent_mng_id(+) AND a.rent_l_cd=d.rent_l_cd(+) and a.com_con_no=d.com_con_no(+) \n"+
					"        AND b.client_id=e.client_id AND b.BUS_ID=f.user_id "+
				    "        and nvl(d.cng_yn,'N')='N'"+
					"        AND b.rent_mng_id=g.rent_mng_id AND b.rent_l_cd=g.rent_l_cd \n"+
					"        AND a.car_comp_id=i.code "+
					"        and a.car_off_id=j.car_off_id "+
					" ";

			if(!gubun4.equals(""))		query += " and a.car_off_id='"+gubun4+"'";



			String search = "";
			String what = "";
			String dt1 = "";
			String dt2 = "";

			if(gubun1.equals("1")){
				dt1 = "substr(b.reg_dt,1,6)";
				dt2 = "b.reg_dt";
			}else if(gubun1.equals("2")){
				dt1 = "substr(a.dlv_est_dt,1,6)";
				dt2 = "a.dlv_est_dt";
			}else if(gubun1.equals("3")){
				dt1 = "to_char(c.reg_dt,'YYYYMM')";
				dt2 = "to_char(c.reg_dt,'YYYYMMDD')";
			}else if(gubun1.equals("4")){
				dt1 = "to_char(d.reg_dt,'YYYYMM')";
				dt2 = "to_char(d.reg_dt,'YYYYMMDD')";
			}else if(gubun1.equals("5")){
				dt1 = "to_char(a.reg_dt,'YYYYMM')";
				dt2 = "to_char(a.reg_dt,'YYYYMMDD')";
			}

			//당일
			if(gubun2.equals("1"))				query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
			//전일
			else if(gubun2.equals("2"))			query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";		
			//당월
			else if(gubun2.equals("3"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%' ";
			//기간
			else if(gubun2.equals("4")){
				if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
				if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
			}

			if(s_kd.equals("1"))	what = "upper(nvl(g.pur_com_firm||e.firm_nm, ' '))";	
			if(s_kd.equals("2"))	what = "upper(nvl(a.rent_l_cd, ' '))";	
			if(s_kd.equals("3"))	what = "upper(nvl(DECODE(c.rent_l_cd,'',a.car_nm,c.car_nm), ' '))";		
			if(s_kd.equals("4"))	what = "upper(nvl(f.user_nm, ' '))";	
			if(s_kd.equals("5"))	what = "upper(nvl(a.com_con_no, ' '))";	
			if(s_kd.equals("6"))	what = "upper(nvl(nvl(g.pur_com_firm,e.firm_nm), ' '))";	
			
			if(!s_kd.equals("") && !t_wd.equals("")){
				query += " and "+what+" like upper('%"+t_wd+"%') ";
			}

			if(sort.equals("1"))		query += " order by b.reg_dt, a.dlv_est_dt, e.firm_nm ";
			if(sort.equals("2"))		query += " order by a.dlv_est_dt, b.reg_dt, e.firm_nm ";


		try {
			pstmt = con.prepareStatement(query);
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
			System.out.println("[CarOfficeDatabase:getPurComEstDtList]"+ e);
			System.out.println("[CarOfficeDatabase:getPurComEstDtList]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

	/*
	*	협력업체-계출관리-신규계약
	*/
	public Vector getPurComConList(String s_kd, String t_wd, String sort, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

					
			query = " SELECT  \n"+
					"        DECODE(a.use_yn,'Y','신규','C','변경','N',decode(a.suc_yn,'D','변경','Y','변경','해지')) use_yn_st, \n"+
					"        DECODE(a.stock_yn,'Y','있음','') stock_yn_st, \n"+
					"        DECODE(a.order_car,'Y','주문차','') order_car_st, \n"+
					"        DECODE(c.rent_l_cd,'',a.car_nm,c.car_nm) r_car_nm, \n"+
					"        DECODE(c.rent_l_cd,'',a.opt,c.opt) r_opt, \n"+
					"        DECODE(c.rent_l_cd,'',a.colo,c.colo) r_colo, \n"+
					"        DECODE(c.rent_l_cd,'',a.auto,c.auto) r_auto, \n"+
					"        DECODE(c.rent_l_cd,'',a.purc_gu,c.purc_gu) r_purc_gu, \n"+
					"        DECODE(c.rent_l_cd,'',a.car_c_amt,c.car_c_amt) r_car_c_amt, \n"+
					"        DECODE(c.rent_l_cd,'',a.car_f_amt,c.car_f_amt) r_car_f_amt, \n"+
					"        DECODE(c.rent_l_cd,'',a.car_g_amt,c.car_g_amt) r_car_g_amt, \n"+
					"        DECODE(c.rent_l_cd,'',a.dc_amt+a.add_dc_amt,c.dc_amt+c.add_dc_amt) r_dc_amt, \n"+
					"        DECODE(c.rent_l_cd,'',a.dc_amt,c.dc_amt) r_dc_amt2, \n"+
					"        DECODE(c.rent_l_cd,'',a.add_dc_amt,c.add_dc_amt) r_add_dc_amt, \n"+
					"        DECODE(c.rent_l_cd,'',a.car_g_amt+a.cons_amt,c.car_g_amt+a.cons_amt) r_car_g_amt2, \n"+
					"        DECODE(d.rent_l_cd,'',c2.reg_dt,d.reg_dt) cng_reg_dt, \n"+
					"        DECODE(d.rent_l_cd,'',c2.cng_dt,d.cng_dt) cng_app_dt, \n"+
					"        DECODE(d.rent_l_cd,'',c2.cng_cont,d.cng_cont) cng_cont, \n"+
					"        b.reg_dt as rent_reg_dt, b.rent_dt, g.pur_req_dt, a.dlv_dt, e.firm_nm, e.client_st, nvl(g.pur_com_firm,e.firm_nm) pur_com_firm, f.user_nm AS bus_nm, \n"+
					"        decode(a.dlv_st,'1','예정','2','배정') dlv_st_nm, "+
					"        decode(a.udt_st,'1','서울본사','2','부산지점','3','대전지점','4','고객','5','대구지점','6','광주지점') udt_st_nm, "+
					"        (nvl(h.car_cs_amt,0) + nvl(h.car_cv_amt,0) + nvl(h.opt_cs_amt,0)+nvl(h.opt_cv_amt,0) + nvl(h.clr_cs_amt,0) + nvl(h.clr_cv_amt,0) - nvl(h.tax_dc_s_amt,0) - nvl(h.tax_dc_v_amt,0)) f_car_amt, \n"+
					"        i.nm as car_comp_nm, j.driver_nm, j.driver_ssn, j.driver_m_tel, g.off_nm, k.car_off_nm, "+
					"        a.* \n"+
					" FROM   CAR_PUR_COM a, CONT b,    \n"+
					"        (select * from CAR_PUR_COM_CNG a where a.cng_st='1' and a.cng_cont<>'배달지' AND a.seq = (select max(seq) from CAR_PUR_COM_CNG WHERE cng_st='1' and cng_cont<>'배달지' and rent_mng_id=a.rent_mng_id AND rent_l_cd=a.rent_l_cd and com_con_no=a.com_con_no)) c, \n"+
					"        (select * from CAR_PUR_COM_CNG a where a.cng_st in ('1','3','4','5') AND a.seq = (select max(seq) from CAR_PUR_COM_CNG WHERE cng_st in ('1','3','4','5') and rent_mng_id=a.rent_mng_id AND rent_l_cd=a.rent_l_cd and com_con_no=a.com_con_no)) c2, \n"+
					"        (SELECT * FROM CAR_PUR_COM_CNG a WHERE a.cng_st='2' and a.cng_cont<>'신차취소현황으로 보내기') d, \n"+
					"        CLIENT e, USERS f, car_pur g, car_etc h, \n"+
				    "        (select * from doc_settle where doc_st='5') dh, (select * from code where c_st='0001') i, "+
					"        (select * from cons_pur where cancel_dt is null) j, car_off k "+
					" WHERE  a.dlv_st='2' and a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd "+
					"        AND a.settle_dt IS NULL AND DECODE(a.use_yn||a.suc_yn,'N','N','NN','N','NY','N','Y')='Y'\n"+
					"        AND a.rent_mng_id=c.rent_mng_id(+) AND a.rent_l_cd=c.rent_l_cd(+) and a.com_con_no=c.com_con_no(+) \n"+
					"        AND a.rent_mng_id=c2.rent_mng_id(+) AND a.rent_l_cd=c2.rent_l_cd(+) and a.com_con_no=c2.com_con_no(+) \n"+
					"        AND a.rent_mng_id=d.rent_mng_id(+) AND a.rent_l_cd=d.rent_l_cd(+) and a.com_con_no=d.com_con_no(+) \n"+
					"        AND b.client_id=e.client_id AND b.BUS_ID=f.user_id "+
				    "        and nvl(d.cng_yn,'N')='N'"+
					"        AND b.rent_mng_id=g.rent_mng_id AND b.rent_l_cd=g.rent_l_cd \n"+
                    "        and b.rent_mng_id=h.rent_mng_id AND b.rent_l_cd=h.rent_l_cd "+
 				    "        and g.req_code=dh.doc_id(+) AND a.car_comp_id=i.code "+
					"        AND a.rent_mng_id=j.rent_mng_id(+) AND a.rent_l_cd=j.rent_l_cd(+) \n"+
					"        and a.car_off_id=k.car_off_id "+
					" ";

			if(!gubun4.equals(""))		query += " and a.car_off_id='"+gubun4+"'";

			String search = "";
			String what = "";
			String dt1 = "";
			String dt2 = "";

			if(gubun1.equals("1")){
				dt1 = "substr(b.reg_dt,1,6)";
				dt2 = "b.reg_dt";
			}else if(gubun1.equals("2")){
				dt1 = "substr(a.dlv_con_dt,1,6)";
				dt2 = "a.dlv_con_dt";
			}

			//당일
			if(gubun2.equals("1"))				query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
			//전일
			else if(gubun2.equals("2"))			query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";		
			//당월
			else if(gubun2.equals("3"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%' ";
			//기간
			else if(gubun2.equals("4")){
				if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
				if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
			}

			if(s_kd.equals("1"))	what = "upper(nvl(g.pur_com_firm||e.firm_nm, ' '))";	
			if(s_kd.equals("2"))	what = "upper(nvl(a.rent_l_cd, ' '))";	
			if(s_kd.equals("3"))	what = "upper(nvl(DECODE(c.rent_l_cd,'',a.car_nm,c.car_nm), ' '))";		
			if(s_kd.equals("4"))	what = "upper(nvl(f.user_nm, ' '))";	
			if(s_kd.equals("5"))	what = "upper(nvl(a.com_con_no, ' '))";	
			if(s_kd.equals("6"))	what = "upper(nvl(nvl(g.pur_com_firm,e.firm_nm), ' '))";	
			
			if(!s_kd.equals("") && !t_wd.equals("")){
				query += " and "+what+" like upper('%"+t_wd+"%') ";
			}

			if(sort.equals("1"))		query += " order by b.reg_dt, a.dlv_con_dt, e.firm_nm ";
			if(sort.equals("2"))		query += " order by a.dlv_con_dt, b.reg_dt, e.firm_nm ";


		try {
			pstmt = con.prepareStatement(query);
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
			System.out.println("[CarOfficeDatabase:getPurComConList]"+ e);
			System.out.println("[CarOfficeDatabase:getPurComConList]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}


	/*
	*	협력업체-계출관리-신규계약
	*/
	public Vector getPurComDlvList(String s_kd, String t_wd, String sort, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

					
			query = " SELECT  \n"+
					"        DECODE(a.use_yn,'Y','신규','C','변경','N',decode(a.suc_yn,'D','변경','Y','변경','해지')) use_yn_st, \n"+
					"        DECODE(c.rent_l_cd,'',a.car_nm,c.car_nm) r_car_nm, \n"+
					"        DECODE(c.rent_l_cd,'',a.opt,c.opt) r_opt, \n"+
					"        DECODE(c.rent_l_cd,'',a.colo,c.colo) r_colo, \n"+
					"        DECODE(c.rent_l_cd,'',a.auto,c.auto) r_auto, \n"+
					"        DECODE(c.rent_l_cd,'',a.purc_gu,c.purc_gu) r_purc_gu, \n"+
					"        DECODE(c.rent_l_cd,'',a.car_c_amt,c.car_c_amt) r_car_c_amt, \n"+
					"        DECODE(c.rent_l_cd,'',a.car_f_amt,c.car_f_amt) r_car_f_amt, \n"+
					"        DECODE(c.rent_l_cd,'',a.car_g_amt,c.car_g_amt) r_car_g_amt, \n"+
					"        DECODE(c.rent_l_cd,'',a.dc_amt+a.add_dc_amt,c.dc_amt+c.add_dc_amt) r_dc_amt, \n"+
					"        DECODE(c.rent_l_cd,'',a.car_g_amt+a.cons_amt,c.car_g_amt+a.cons_amt) r_car_g_amt2, \n"+
					"        b.reg_dt as rent_reg_dt, b.rent_dt, e.firm_nm, nvl(g.pur_com_firm,e.firm_nm) pur_com_firm, f.user_nm AS bus_nm, \n"+
					"        decode(a.dlv_st,'1','예정','2','배정') dlv_st_nm, "+
					"        decode(a.udt_st,'1','서울본사','2','부산지점','3','대전지점','4','고객','5','대구지점','6','광주지점') udt_st_nm, "+
					"        decode(g.pur_pay_dt, '',substr(g.pur_est_dt,1,8), g.pur_pay_dt) pur_pay_dt, "+
					"        g.cardno1, g.card_kind1, g.trf_amt1, g.cardno2, g.card_kind2, g.trf_amt2, "+
					"        SUBSTR(i.card_edate,5,2)||'/'||SUBSTR(i.card_edate,3,2) card_dt, "+
					"        SUBSTR(i.card_edate,5,2)||'월 '||SUBSTR(i.card_edate,3,2)||'년' card_dt2, "+
					"        SUBSTR(i2.card_edate,5,2)||'/'||SUBSTR(i2.card_edate,3,2) card_dt3, "+
					"        SUBSTR(i2.card_edate,5,2)||'월 '||SUBSTR(i2.card_edate,3,2)||'년' card_dt4, "+
					"        j.nm as car_comp_nm, g.off_id, g.off_nm, h.driver_nm, h.driver_ssn, h.driver_m_tel, k.car_off_nm, "+
					"        a.* \n"+
					" FROM   CAR_PUR_COM a, CONT b,    \n"+
					"        (select * from CAR_PUR_COM_CNG a where a.cng_st='1' and a.cng_cont<>'배달지' AND a.seq = (select max(seq) from CAR_PUR_COM_CNG WHERE cng_st='1' and cng_cont<>'배달지' and rent_mng_id=a.rent_mng_id AND rent_l_cd=a.rent_l_cd and com_con_no=a.com_con_no)) c, \n"+
					"        (select * from CAR_PUR_COM_CNG a where a.cng_st in ('1','3','4','5') AND a.seq = (select max(seq) from CAR_PUR_COM_CNG WHERE cng_st in ('1','3','4','5') and rent_mng_id=a.rent_mng_id AND rent_l_cd=a.rent_l_cd and com_con_no=a.com_con_no)) c2, \n"+
					"        (SELECT * FROM CAR_PUR_COM_CNG a WHERE a.cng_st='2' and a.cng_cont<>'신차취소현황으로 보내기') d, \n"+
					"        CLIENT e, USERS f, car_pur g, \n"+
					"        (select /*+ index(doc_settle DOC_SETTLE_IDX2  ) */ * from doc_settle where doc_st='4' and doc_step='3') dc, "+
				    "        (select * from doc_settle where doc_st='5') dh, card i, card i2, (select * from code where c_st='0001') j, "+
					"        (select * from cons_pur where cancel_dt is null) h, car_off k "+
					" WHERE  "+
					"        a.settle_dt is not null AND DECODE(a.use_yn||a.suc_yn,'N','N','NN','N','NY','N','Y')='Y' "+
					"        and a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd "+
					"        AND a.rent_mng_id=c.rent_mng_id(+) AND a.rent_l_cd=c.rent_l_cd(+) and a.com_con_no=c.com_con_no(+) \n"+
					"        AND a.rent_mng_id=c2.rent_mng_id(+) AND a.rent_l_cd=c2.rent_l_cd(+) and a.com_con_no=c2.com_con_no(+) \n"+
					"        AND a.rent_mng_id=d.rent_mng_id(+) AND a.rent_l_cd=d.rent_l_cd(+) and a.com_con_no=d.com_con_no(+) \n"+
					"        AND b.client_id=e.client_id AND b.BUS_ID=f.user_id "+
				    "        and nvl(d.cng_yn,'N')='N' "+
					"        AND b.rent_mng_id=g.rent_mng_id AND b.rent_l_cd=g.rent_l_cd \n"+
				    "        and g.rent_l_cd=dc.doc_id(+) "+
 				    "        and g.req_code=dh.doc_id(+) "+
				    "        AND g.cardno1=i.cardno(+) AND g.cardno2=i2.cardno(+) AND a.car_comp_id=j.code "+
					"        and a.rent_mng_id=h.rent_mng_id(+) and a.rent_l_cd=h.rent_l_cd(+) "+
					"        and a.car_off_id=k.car_off_id  "+
					" ";

			if(!gubun4.equals(""))		query += " and a.car_off_id='"+gubun4+"'";

			if(gubun3.equals("1"))				query += " and b.dlv_dt is null ";
			if(gubun3.equals("2"))				query += " and b.dlv_dt is not null ";


			String search = "";
			String what = "";
			String dt1 = "";
			String dt2 = "";

			if(gubun1.equals("1")){
				dt1 = "decode(g.pur_pay_dt, '',substr(g.pur_est_dt,1,6), substr(g.pur_pay_dt,1,6))";
				dt2 = "decode(g.pur_pay_dt, '',substr(g.pur_est_dt,1,8), g.pur_pay_dt)";
			}else if(gubun1.equals("2")){
				dt1 = "substr(a.dlv_dt,1,6)";
				dt2 = "a.dlv_dt";
			}

			//당일
			if(gubun2.equals("1"))				query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
			//전일
			else if(gubun2.equals("2"))			query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";		
			//당월
			else if(gubun2.equals("3"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%' ";
			//기간
			else if(gubun2.equals("4")){
				if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
				if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
			}

			if(s_kd.equals("1"))	what = "upper(nvl(g.pur_com_firm||e.firm_nm, ' '))";	
			if(s_kd.equals("2"))	what = "upper(nvl(a.rent_l_cd, ' '))";	
			if(s_kd.equals("3"))	what = "upper(nvl(DECODE(c.rent_l_cd,'',a.car_nm,c.car_nm), ' '))";		
			if(s_kd.equals("4"))	what = "upper(nvl(f.user_nm, ' '))";	
			if(s_kd.equals("5"))	what = "upper(nvl(a.com_con_no, ' '))";	
			if(s_kd.equals("6"))	what = "upper(nvl(nvl(g.pur_com_firm,e.firm_nm), ' '))";	
			
			if(!s_kd.equals("") && !t_wd.equals("")){
				query += " and "+what+" like upper('%"+t_wd+"%') ";
			}

			if(sort.equals("1"))		query += " order by decode(g.pur_pay_dt, '',substr(g.pur_est_dt,1,8), g.pur_pay_dt), g.cardno1, a.udt_st, a.dlv_dt, e.firm_nm ";
			if(sort.equals("2"))		query += " order by a.dlv_dt, decode(g.pur_pay_dt, '',substr(g.pur_est_dt,1,8), g.pur_pay_dt), g.cardno1, a.udt_st, decode(g.pur_pay_dt, '',substr(g.pur_est_dt,1,8), g.pur_pay_dt), b.rent_dt, e.firm_nm ";


		try {
			pstmt = con.prepareStatement(query);
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
			System.out.println("[CarOfficeDatabase:getPurComDlvList]"+ e);
			System.out.println("[CarOfficeDatabase:getPurComDlvList]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}


	/*
	*	협력업체-계출관리-변경계약
	*/
	public Vector getPurComCngList(String s_kd, String t_wd, String sort, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

					

			query = " SELECT  \n"+
					"        b.com_con_no, b.dlv_est_dt, b.dlv_con_dt, \n"+
					"        decode(b.dlv_st,'1','예정','2','배정') dlv_st_nm, \n"+
					"        decode(b.use_yn,'Y','','C','변경','N','해지') use_yn_st, \n"+
					"        c.dlv_dt, c.car_mng_id, d.firm_nm, nvl(g.pur_com_firm,d.firm_nm) pur_com_firm, e.user_nm AS bus_nm, \n"+
					"        DECODE(f.cng_st,'1',f.car_nm,b.car_nm) r_car_nm, \n"+
					"        DECODE(f.cng_st,'1',f.opt,b.opt) r_opt, \n"+
					"        DECODE(f.cng_st,'1',f.colo,b.colo) r_colo, \n"+
					"        DECODE(f.cng_st,'1',f.auto,b.auto) r_auto, \n"+
					"        DECODE(f.cng_st,'1',f.purc_gu,b.purc_gu) r_purc_gu, \n"+
					"        DECODE(f.cng_st,'1',f.car_c_amt,b.car_c_amt) r_car_c_amt, \n"+
					"        DECODE(f.cng_st,'1',f.car_f_amt,b.car_f_amt) r_car_f_amt, \n"+
					"        DECODE(f.cng_st,'1',f.car_g_amt,b.car_g_amt) r_car_g_amt, \n"+
					"        DECODE(f.cng_st,'1',f.dc_amt+f.add_dc_amt,b.dc_amt+b.add_dc_amt) r_dc_amt, \n"+
					"        DECODE(f.cng_st,'1',f.car_g_amt+b.cons_amt,b.car_g_amt+b.cons_amt) r_car_g_amt2, \n"+
					"        DECODE(a.cng_yn,'','미반영',to_char(a.reg_dt,'YYYYMMDD')) cng_yn_nm,  \n"+
					"        i.nm as car_comp_nm, j.car_off_nm, \n"+
					"        a.* \n"+
					" FROM   CAR_PUR_COM_CNG a, CAR_PUR_COM b, CONT c, CLIENT d, USERS e, \n"+
					"        (select * from CAR_PUR_COM_CNG a where a.cng_st='1' and a.cng_cont<>'배달지' AND a.seq = (select max(seq) from CAR_PUR_COM_CNG WHERE cng_st='1' and cng_cont<>'배달지' and rent_mng_id=a.rent_mng_id AND rent_l_cd=a.rent_l_cd and com_con_no=a.com_con_no)) f, \n"+
					"        (select * from code where c_st='0001') i, car_off j, car_pur g "+
					" WHERE  a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd and a.com_con_no=b.com_con_no \n"+
					"        AND a.rent_mng_id=c.rent_mng_id AND a.rent_l_cd=c.rent_l_cd \n"+
					"        AND c.client_id=d.client_id \n"+
					"        AND c.BUS_ID=e.user_id "+
					"        AND a.rent_mng_id=f.rent_mng_id(+) AND a.rent_l_cd=f.rent_l_cd(+) and a.com_con_no=f.com_con_no(+) AND b.car_comp_id=i.code \n"+
					"        and b.car_off_id=j.car_off_id "+
					"        and a.rent_mng_id=g.rent_mng_id and a.rent_l_cd=g.rent_l_cd "+
					"        and nvl(b.suc_yn,'-') not in ('D','Y') "+
					" ";

			if(!gubun4.equals(""))		query += " and b.car_off_id='"+gubun4+"'";

			if(gubun3.equals("1")) query += " and a.cng_dt is null ";
			if(gubun3.equals("2")) query += " and a.cng_dt is not null ";

			String search = "";
			String what = "";
			String dt1 = "";
			String dt2 = "";

			if(gubun1.equals("1")){
				dt1 = "to_char(a.reg_dt,'YYYYMM')";
				dt2 = "to_char(a.reg_dt,'YYYYMMDD')";
			}else if(gubun1.equals("2")){
				dt1 = "to_char(a.cng_dt,'YYYYMM')";
				dt2 = "to_char(a.cng_dt,'YYYYMMDD')";
			}

			//당일
			if(gubun2.equals("1"))				query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
			//전일
			else if(gubun2.equals("2"))			query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";		
			//당월
			else if(gubun2.equals("3"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%' ";
			//기간
			else if(gubun2.equals("4")){
				if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
				if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
			}

			if(s_kd.equals("1"))	what = "upper(nvl(g.pur_com_firm||d.firm_nm, ' '))";	
			if(s_kd.equals("2"))	what = "upper(nvl(a.rent_l_cd, ' '))";	
			if(s_kd.equals("3"))	what = "upper(nvl(a.car_nm, ' '))";		
			if(s_kd.equals("4"))	what = "upper(nvl(e.user_nm, ' '))";	
			if(s_kd.equals("5"))	what = "upper(nvl(b.com_con_no, ' '))";	
			if(s_kd.equals("6"))	what = "upper(nvl(nvl(g.pur_com_firm,d.firm_nm), ' '))";	
			
			if(!s_kd.equals("") && !t_wd.equals("")){
				query += " and "+what+" like upper('%"+t_wd+"%') ";
			}

			if(sort.equals("1"))		query += " order by a.reg_dt, a.cng_dt ";
			if(sort.equals("2"))		query += " order by a.cng_dt, a.reg_dt ";


		try {
			pstmt = con.prepareStatement(query);
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
			System.out.println("[CarOfficeDatabase:getPurComCngList]"+ e);
			System.out.println("[CarOfficeDatabase:getPurComCngList]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

	/*
	*	협력업체-계출관리-해지현황
	*/
	public Vector getPurComClsList(String s_kd, String t_wd, String sort, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

					
			query = " SELECT  \n"+
					"        b.com_con_no, b.dlv_est_dt, b.dlv_con_dt, \n"+
					"        decode(b.dlv_st,'1','예정','2','배정') dlv_st_nm, \n"+
					"        decode(b.use_yn,'Y','','C','변경','N','해지') use_yn_st, \n"+
					"        c.dlv_dt, c.car_mng_id, d.firm_nm, nvl(g.pur_com_firm,d.firm_nm) pur_com_firm, e.user_nm AS bus_nm, \n"+
					"        DECODE(a.cng_st,'1',a.car_nm,b.car_nm) r_car_nm, \n"+
					"        DECODE(a.cng_yn,'','미반영',to_char(a.reg_dt,'YYYYMMDD')) cng_yn_nm,  \n"+
					"        i.nm as car_comp_nm, j.car_off_nm, \n"+
					"        a.* \n"+
					" FROM   CAR_PUR_COM_CNG a, CAR_PUR_COM b, CONT c, CLIENT d, USERS e, (select * from code where c_st='0001') i, car_off j, car_pur g \n"+
					" WHERE  a.cng_st='2' and a.cng_dt is not null "+
					"        and a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd and a.com_con_no=b.com_con_no \n"+
					"        AND a.rent_mng_id=c.rent_mng_id AND a.rent_l_cd=c.rent_l_cd \n"+
					"        AND c.client_id=d.client_id \n"+
					"        AND c.BUS_ID=e.user_id AND b.car_comp_id=i.code"+
					"        and b.car_off_id=j.car_off_id "+
					"        AND a.rent_mng_id=g.rent_mng_id AND a.rent_l_cd=g.rent_l_cd \n"+
					//"        and nvl(b.suc_yn,'-') not in ('D','Y') "+
					"        AND DECODE(b.use_yn||b.suc_yn,'N','N','NN','N','Y')='N'"+
					" ";

			if(!gubun4.equals(""))		query += " and b.car_off_id='"+gubun4+"'";

			String search = "";
			String what = "";
			String dt1 = "";
			String dt2 = "";

			if(gubun1.equals("1")){
				dt1 = "to_char(a.reg_dt,'YYYYMM')";
				dt2 = "to_char(a.reg_dt,'YYYYMMDD')";
			}else if(gubun1.equals("2")){
				dt1 = "to_char(a.cng_dt,'YYYYMM')";
				dt2 = "to_char(a.cng_dt,'YYYYMMDD')";
			}

			//당일
			if(gubun2.equals("1"))				query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
			//전일
			else if(gubun2.equals("2"))			query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";		
			//당월
			else if(gubun2.equals("3"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%'";
			//기간
			else if(gubun2.equals("4")){
				if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
				if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
			}

			if(s_kd.equals("1"))	what = "upper(nvl(g.pur_com_firm||d.firm_nm, ' '))";	
			if(s_kd.equals("2"))	what = "upper(nvl(a.rent_l_cd, ' '))";	
			if(s_kd.equals("3"))	what = "upper(nvl(a.car_nm, ' '))";		
			if(s_kd.equals("4"))	what = "upper(nvl(e.user_nm, ' '))";	
			if(s_kd.equals("5"))	what = "upper(nvl(b.com_con_no, ' '))";	
			if(s_kd.equals("6"))	what = "upper(nvl(nvl(g.pur_com_firm,d.firm_nm), ' '))";	
			
			if(!s_kd.equals("") && !t_wd.equals("")){
				query += " and "+what+" like upper('%"+t_wd+"%') ";
			}

			if(sort.equals("1"))		query += " order by a.reg_dt, a.cng_dt ";
			if(sort.equals("2"))		query += " order by a.cng_dt, a.reg_dt ";


		try {
			pstmt = con.prepareStatement(query);
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
			System.out.println("[CarOfficeDatabase:getPurComClsList]"+ e);
			System.out.println("[CarOfficeDatabase:getPurComClsList]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}


	/*
	*	협력업체-계출관리-영업담당자별현황
	*/
	public Vector getPurComBusList() throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

					
			query = " SELECT  \n"+
					"        f.loan_st, g.br_nm, f.dept_id, h.nm as dept_nm, b.bus_id, f.user_nm, COUNT(*) cnt, \n"+
					"        COUNT(DECODE(a.dlv_st,'1',DECODE(a.use_yn,'N','',a.rent_l_cd))) dlv_st1_cnt, \n"+
					"        COUNT(DECODE(a.dlv_st,'2',DECODE(a.use_yn,'N','',a.rent_l_cd))) dlv_st2_cnt, \n"+
					"        COUNT(DECODE(c.rent_l_cd,'','',DECODE(c.cng_dt,'',c.rent_l_cd))) cng_reg_cnt, \n"+
					"        COUNT(DECODE(c.rent_l_cd,'','',DECODE(c.cng_dt,'','',c.rent_l_cd))) cng_app_cnt, \n"+
					"        COUNT(DECODE(d.rent_l_cd,'','',DECODE(d.cng_dt,'',d.rent_l_cd))) cls_reg_cnt, \n"+
					"        COUNT(DECODE(d.rent_l_cd,'','',DECODE(d.cng_dt,'','',d.rent_l_cd))) cls_app_cnt \n"+
					" FROM   CAR_PUR_COM a, CONT b, \n"+
					"        (select * from CAR_PUR_COM_CNG a where a.cng_st in ('1','3','4','5') AND a.seq = (select max(seq) from CAR_PUR_COM_CNG WHERE cng_st in ('1','3','4','5') and rent_mng_id=a.rent_mng_id AND rent_l_cd=a.rent_l_cd and com_con_no=a.com_con_no)) c,  \n"+
					"        (SELECT * FROM CAR_PUR_COM_CNG a WHERE a.cng_st='2' and a.cng_cont<>'신차취소현황으로 보내기') d,  \n"+
					"        CLIENT e, USERS f, BRANCH g, (SELECT * FROM CODE WHERE c_st='0002') h  \n"+
					" WHERE    \n"+
					"        a.use_yn in ('Y','C') and a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd AND DECODE(a.use_yn||a.suc_yn,'N','N','NN','N','NY','N','Y')='Y' \n"+
					"        and b.dlv_dt is null and a.settle_dt is null "+
					"        AND a.rent_mng_id=c.rent_mng_id(+) AND a.rent_l_cd=c.rent_l_cd(+) and a.com_con_no=c.com_con_no(+)  \n"+
					"        AND a.rent_mng_id=d.rent_mng_id(+) AND a.rent_l_cd=d.rent_l_cd(+) and a.com_con_no=d.com_con_no(+)  \n"+
					"        AND b.client_id=e.client_id AND b.BUS_ID=f.user_id \n"+
					"        AND f.br_id=g.br_id AND f.dept_id=h.CODE  \n"+
					" GROUP BY f.loan_st, g.br_nm, f.dept_id, h.nm, b.bus_id, f.user_nm        \n"+
					" ORDER BY f.loan_st desc, f.dept_id, b.bus_id, f.user_nm \n"+
					" ";


		try {
			pstmt = con.prepareStatement(query);
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
			System.out.println("[CarOfficeDatabase:getPurComBusList]"+ e);
			System.out.println("[CarOfficeDatabase:getPurComBusList]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

	//해지보험공문 한건 수정
    public boolean updateCarPurComSettleCancel(String rent_mng_id, String rent_l_cd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        boolean flag = true;
                
		query = " update car_pur_com set "+
				"        settle_id='', settle_dt='' "+
				" where  rent_mng_id=? and rent_l_cd=?  "+
				" ";
            
       try{
            con.setAutoCommit(false);            
            
            pstmt = con.prepareStatement(query);

			pstmt.setString	(1,	rent_mng_id	);
			pstmt.setString	(2,	rent_l_cd	);

            pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
                con.rollback();
		  		flag = false;
				System.out.println("[CarOfficeDatabase:updateCarPurComSettleCancel]\n"+se);
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

	/*
	*	협력업체-계출관리-법인고객 조회
	*/
	public Vector getCustSubList(String bus_id) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
				
		query = " select * \n"+
				" from  \n"+
				"        (   \n"+
				"          select    \n"+
				" 			      c.firm_nm, MAX(a.rent_dt) rent_dt   \n"+
				"          from   cont a, fee b, CLIENT c \n"+
				"          where  a.bus_id='"+bus_id+"'  \n"+
				"                 AND a.car_st in ('1','3','4') AND nvl(a.use_yn,'Y')='Y' \n"+
				"                 AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd  \n"+
				"                 and a.rent_l_cd in (select rent_l_cd from fee group by rent_l_cd having count(*)=1)  \n"+
				"                 AND a.client_id=c.client_id and c.client_st='1' \n"+
				"                 AND c.firm_nm IN (SELECT firm_nm FROM CLIENT WHERE client_st='1' GROUP BY firm_nm HAVING COUNT(*)=1) \n"+
                "  GROUP BY c.firm_nm   \n"+
				"          order by DBMS_RANDOM.VALUE  \n"+
				" )   \n"+
				" where  ROWNUM<31 \n"+
				" order by rent_dt desc "+
				" ";
					
		try {
			pstmt = con.prepareStatement(query);
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
			System.out.println("[CarOfficeDatabase:getCustSubList]"+ e);
			System.out.println("[CarOfficeDatabase:getCustSubList]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}


    /**
     * 영업사원별 계약현황
     */
    public Vector getCarAgentAllList(String gubun1, String gubun2, String gubun3, String gubun4, String s_kd, String t_wd) 
		throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
		Vector vt = new Vector();
        String subQuery = "";
        String subQuery2 = "";
        String query = "";
        
		//디폴트 제로
		//if(gubun1.equals("") && s_kd.equals("") && t_wd.equals("")) subQuery = " and a.car_off_nm='99' ";
		
		if(!t_wd.equals("")){
		    if(s_kd.equals("car_off_nm"))        subQuery = "and nvl(a.car_off_nm, ' ') like '%" + t_wd + "%'\n";
		}

		if(!gubun1.equals(""))	subQuery += " and a.car_off_st = '" + gubun1 + "'";
		
		if(!gubun2.equals("all"))  subQuery2 += " and a.USE_YN = '" + gubun2 + "'";

		query = " SELECT a.*, \n"+ 
				"        decode(a.car_off_st,'3','법인','4','개인사업자') as car_off_st_nm, "+
				"        decode(a.agent_st,'1','에이전트','프리랜서') as agent_st_nm, "+
				"        decode(a.enp_st,'1','개인','법인') as enp_st_nm, "+
				"        decode(a.use_yn,'Y','거래','미거래') as use_yn_nm "+
				" FROM   car_off a \n" +
				" where "+
				"        a.car_comp_id='1000' \n"+
				subQuery + " \n"+
				subQuery2 + " \n"+
				"order by a.use_yn desc, a.car_off_id";

        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
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
            stmt.close();
        }catch(SQLException se){
			System.out.println("[CarOfficeDatabase:getCarAgentAllList]"+se);
			se.printStackTrace();
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

    /**
     * 영업소 사원 조회.
     */
    public CarOffEmpBean [] getCarAgentEmpAll(String car_off_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";
        query = "select a.emp_id as EMP_ID,\n"
						+ "a.car_off_id as CAR_OFF_ID,\n" 
						+ "b.car_off_nm as CAR_OFF_NM, b.car_off_st, b.owner_nm as OWNER_NM,\n"
						+ "b.car_comp_id as CAR_COMP_ID,\n"
						+ "c.nm as CAR_COMP_NM,\n"
						+ "a.cust_st as CUST_ST,\n"
						+ "a.emp_nm as EMP_NM,\n"
						+ "a.emp_ssn as EMP_SSN,\n"
						+ "b.car_off_tel as CAR_OFF_TEL,\n"
						+ "b.car_off_fax as CAR_OFF_FAX,\n"
						+ "a.emp_m_tel as EMP_M_TEL,\n"
						+ "a.emp_pos as EMP_POS,\n"
						+ "a.emp_email as EMP_EMAIL,\n"
						+ "a.emp_bank as EMP_BANK,\n"
						+ "a.emp_acc_no as EMP_ACC_NO,\n"
						+ "a.emp_acc_nm as EMP_ACC_NM,a.emp_post as EMP_POST,a.emp_addr as EMP_ADDR, a.etc as ETC,\n"
						+ "b.car_off_post as CAR_OFF_POST, b.car_off_addr as CAR_OFF_ADDR, \n"
						+ "a.reg_dt, a.reg_id, a.upd_dt, a.upd_id, \n"
						+ "a.emp_h_tel, a.emp_sex, a.use_yn, a.sms_denial_rsn, '' SEQ, '' DAMDANG_ID, '' CNG_RSN, '' CNG_DT  \n"
						+ ", a.file_name1, a.file_name2, a.file_gubun1, a.file_gubun2, b.one_self_yn, a.agent_id, a.emp_dept, a.fraud_care, a.bank_cd \n"
				+ "from car_off_emp a, car_off b, code c\n"
				+ "where a.agent_id = b.car_off_id \n"
				+ "and b.car_comp_id = c.code\n"
				+ "and c.c_st = '0001'\n"
				+ "and b.car_off_id='" + car_off_id + "'\n"
				+ " order by a.use_yn desc, a.car_off_id ";

        Collection col = new ArrayList();
        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
                
				col.add(makeCarOffEmpBean(rs));
 
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			System.out.println("[CarOfficeDatabase:getCarAgentEmpAll(String car_off_id)]"+se);
			System.out.println("[CarOfficeDatabase:getCarAgentEmpAll(String car_off_id)]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (CarOffEmpBean[])col.toArray(new CarOffEmpBean[0]);
    }

    /**
     * 영업소 사원 전체 조회.
     */
    public CarOffEmpBean [] getCarOffEmpAgentAll(String gubun, String gu_nm, String sort_gubun, String sort, String cng_rsn) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String subQuery = "";

		if(!gu_nm.equals("")){
			if(gubun.equals("mix")){
				subQuery = "and a.emp_nm||b.car_off_nm||a.emp_m_tel like '%" + gu_nm + "%'\n";
			}
		}

		if(!cng_rsn.equals("")){
			subQuery = "and d.user_id ='" + cng_rsn + "'\n";
		}

		String query = "";

        query = "select a.emp_id as EMP_ID,\n"
						+ "a.car_off_id as CAR_OFF_ID,\n" 
						+ "b.car_off_nm as CAR_OFF_NM, b.car_off_st, b.owner_nm as OWNER_NM,\n"
						+ "b.car_comp_id as CAR_COMP_ID,\n"
						+ "c.nm as CAR_COMP_NM,\n"
						+ "a.cust_st as CUST_ST,\n"
						+ "a.emp_nm as EMP_NM,\n"
						+ "a.emp_ssn as EMP_SSN,\n"
						+ "b.car_off_tel as CAR_OFF_TEL,\n"
						+ "b.car_off_fax as CAR_OFF_FAX,\n"
						+ "a.emp_m_tel as EMP_M_TEL,\n"
						+ "a.emp_pos as EMP_POS,\n"
						+ "a.emp_email as EMP_EMAIL,\n"
						+ "decode(b2.doc_st,'2',b2.bank,a.emp_bank) as EMP_BANK,\n"
						+ "decode(b2.doc_st,'2',b2.acc_no,a.emp_acc_no) as EMP_ACC_NO,\n"
						+ "decode(b2.doc_st,'2',b2.acc_nm,a.emp_acc_nm) as EMP_ACC_NM,\n"
						+ "a.emp_post as EMP_POST,a.emp_addr as EMP_ADDR, a.etc as ETC,\n"
						+ "b.car_off_post as CAR_OFF_POST, b.car_off_addr as CAR_OFF_ADDR, \n"
						+ "nvl(a.reg_dt,'-') reg_dt, a.reg_id, a.upd_dt, a.upd_id, \n"
						+ "a.emp_h_tel, a.emp_sex, a.use_yn, a.sms_denial_rsn, \n"
						+ "'' seq, '' damdang_id, '' cng_rsn, '' cng_dt, "
						+ "a.file_name1, a.file_name2, a.file_gubun1, a.file_gubun2, b.one_self_yn, a.agent_id, a.emp_dept, a.fraud_care, \n"
						+ "decode(b2.doc_st,'2',b2.bank_cd,a.bank_cd) as bank_cd \n"
				+ "from car_off_emp a, car_off b, code c, car_off b2, (select * from users where dept_id='1000') d "
				+ "where \n"
				+ " a.agent_id is not null and b.use_yn='Y' \n"
				+ "and a.car_off_id = b.car_off_id \n"
				+ "and b.car_comp_id = c.code\n"
				+ "and c.c_st = '0001'\n"
				+ "and a.agent_id=b2.car_off_id and a.emp_id=d.sa_code "
				+ subQuery;
		
		if(!sort_gubun.equals("")) query += " order by b.car_comp_id, "+sort_gubun+" "+sort;

		Collection col = new ArrayList();
        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
                
				col.add(makeCarOffEmpBean(rs));
 
            }
            rs.close();
            stmt.close();

        }catch(SQLException se){
			System.out.println("[CarOfficeDatabase:getCarOffEmpAgentAll(String gubun, String gu_nm, String sort_gubun, String sort, String cng_rsn)]"+se);
			System.out.println("[CarOfficeDatabase:getCarOffEmpAgentAll(String gubun, String gu_nm, String sort_gubun, String sort, String cng_rsn)]"+query);
			se.printStackTrace();
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (CarOffEmpBean[])col.toArray(new CarOffEmpBean[0]);
    }

    /**
     * 영업소 사원 조회
     */    
    public CarOffEmpBean getCarOffEmpBean(String car_off_id, String emp_nm) throws UnknownDataException, DataSourceEmptyException, DatabaseException {
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null) 
            throw new DataSourceEmptyException("Can't get connection.!!");

        CarOffEmpBean umb;

        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
		query = "select a.emp_id as EMP_ID,\n"
						+ "a.car_off_id as CAR_OFF_ID,\n" 
						+ "b.car_off_nm as CAR_OFF_NM, b.car_off_st, b.owner_nm as OWNER_NM,\n"
						+ "b.car_comp_id as CAR_COMP_ID,\n"
						+ "c.nm as CAR_COMP_NM,\n"
						+ "a.cust_st as CUST_ST,\n"
						+ "a.emp_nm as EMP_NM,\n"
						+ "a.emp_ssn as EMP_SSN,\n"
						+ "b.car_off_tel as CAR_OFF_TEL,\n"
						+ "b.car_off_fax as CAR_OFF_FAX,\n"
						+ "a.emp_m_tel as EMP_M_TEL,\n"
						+ "a.emp_pos as EMP_POS,\n"
						+ "a.emp_email as EMP_EMAIL,\n"
						+ "a.emp_bank as EMP_BANK,\n"
						+ "a.emp_acc_no as EMP_ACC_NO,\n"
						+ "a.emp_acc_nm as EMP_ACC_NM,a.emp_post as EMP_POST,a.emp_addr as EMP_ADDR, a.etc as ETC,\n"
						+ "b.car_off_post as CAR_OFF_POST, b.car_off_addr as CAR_OFF_ADDR, \n"
						+ "a.reg_dt, a.reg_id, a.upd_dt, a.upd_id, \n"
						+ "a.emp_h_tel, a.emp_sex, a.use_yn, a.sms_denial_rsn, '' SEQ, '' DAMDANG_ID, '' CNG_RSN, '' CNG_DT \n"
						+ ", a.file_name1, a.file_name2, a.file_gubun1, a.file_gubun2, b.one_self_yn, a.agent_id, a.emp_dept, a.fraud_care, a.bank_cd \n"
				+ "from  car_off_emp a, car_off b, code c\n"
				+ "where a.car_off_id='"+car_off_id+"' and a.emp_nm='"+emp_nm+"' and a.use_yn='Y' \n"
				+ "and a.car_off_id = b.car_off_id \n"
				+ "and b.car_comp_id = c.code\n"
				+ "and c.c_st = '0001'\n";

        try {
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
    
            if (rs.next())
                umb = makeCarOffEmpBean(rs);
            else
                throw new UnknownDataException("Could not find Appcode # " + car_off_id + emp_nm );
 			rs.close();
            stmt.close();
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());

        }finally{
            try{
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){} 
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return umb;
    }

	/**
     * 명함관리 인덱스 조회 (C_ST = '0025')=ryu gill sun
     */
    public CarCompBean [] getServ_empAll() throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = "SELECT C_ST, CODE, NM_CD, NM, ETC, APP_ST, CMS_BK, BIGO \n"
        		+ "FROM CODE a\n"
        		+ "where C_ST='0025'\n"
        		+ "order by code ";

        Collection col = new ArrayList();
        try{
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery(query);
            while(rs.next()){
                
				col.add(makeCarCompBean(rs));
 
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
        return (CarCompBean[])col.toArray(new CarCompBean[0]);
    }


  /*
	*	협력업체-계출관리-신규계약  - agent
	*/
	public Vector getPurComEstDtList(String s_kd, String t_wd, String sort, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String ck_acar_id) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

					
			query = " SELECT  \n"+
					"        DECODE(a.use_yn,'Y','신규','C','변경','N',decode(a.suc_yn,'D','변경','Y','변경','해지')) use_yn_st, \n"+
					"        DECODE(a.stock_yn,'Y','있음','') stock_yn_st, \n"+
					"        DECODE(a.order_car,'Y','주문차','') order_car_st, \n"+
					"        DECODE(c.rent_l_cd,'',a.car_nm,c.car_nm) r_car_nm, \n"+
					"        DECODE(c.rent_l_cd,'',a.opt,c.opt) r_opt, \n"+
					"        DECODE(c.rent_l_cd,'',a.colo,c.colo) r_colo, \n"+
					"        DECODE(c.rent_l_cd,'',a.auto,c.auto) r_auto, \n"+
					"        DECODE(c.rent_l_cd,'',a.purc_gu,c.purc_gu) r_purc_gu, \n"+
					"        DECODE(c.rent_l_cd,'',a.car_c_amt,c.car_c_amt) r_car_c_amt, \n"+
					"        DECODE(c.rent_l_cd,'',a.car_f_amt,c.car_f_amt) r_car_f_amt, \n"+
					"        DECODE(c.rent_l_cd,'',a.car_g_amt,c.car_g_amt) r_car_g_amt, \n"+
					"        DECODE(c.rent_l_cd,'',a.dc_amt+a.add_dc_amt,c.dc_amt+c.add_dc_amt) r_dc_amt, \n"+
					"        DECODE(c.rent_l_cd,'',a.car_g_amt+a.cons_amt,c.car_g_amt+a.cons_amt) r_car_g_amt2, \n"+
					"        to_char(DECODE(d.rent_l_cd,'',c2.reg_dt,d.reg_dt),'YYYYMMDD') cng_reg_dt, \n"+
					"        to_char(DECODE(d.rent_l_cd,'',c2.cng_dt,d.cng_dt),'YYYYMMDD') cng_app_dt, \n"+
					"        DECODE(d.rent_l_cd,'',c2.cng_cont,d.cng_cont) cng_cont, \n"+
					"        b.reg_dt as rent_reg_dt, b.rent_dt, g.dlv_est_dt as pur_dlv_est_dt, e.firm_nm, nvl(g.pur_com_firm,e.firm_nm) pur_com_firm, f.user_nm AS bus_nm, \n"+
					"        decode(a.dlv_st,'1','예정','2','배정') dlv_st_nm, "+
					"        decode(a.udt_st,'1','서울본사','2','부산지점','3','대전지점','4','고객','5','대구지점','6','광주지점') udt_st_nm, "+
					"        (nvl(h.car_cs_amt,0) + nvl(h.car_cv_amt,0) + nvl(h.opt_cs_amt,0)+nvl(h.opt_cv_amt,0) + nvl(h.clr_cs_amt,0) + nvl(h.clr_cv_amt,0) - nvl(h.tax_dc_s_amt,0) - nvl(h.tax_dc_v_amt,0)) f_car_amt, \n"+
					"        a.*, g.pur_req_dt, i.nm as car_comp_nm  \n"+
					" FROM   CAR_PUR_COM a, CONT b, car_etc h,   \n"+
					"        (select * from CAR_PUR_COM_CNG a where a.cng_st='1' and a.cng_cont<>'배달지' AND a.seq = (select max(seq) from CAR_PUR_COM_CNG WHERE cng_st='1' and cng_cont<>'배달지' and rent_mng_id=a.rent_mng_id AND rent_l_cd=a.rent_l_cd and com_con_no=a.com_con_no)) c, \n"+
					"        (select * from CAR_PUR_COM_CNG a where a.cng_st in ('1','3','4','5') AND a.seq = (select max(seq) from CAR_PUR_COM_CNG WHERE cng_st in ('1','3','4','5') and rent_mng_id=a.rent_mng_id AND rent_l_cd=a.rent_l_cd and com_con_no=a.com_con_no)) c2, \n"+
					"        (SELECT * FROM CAR_PUR_COM_CNG a WHERE a.cng_st='2' and a.cng_cont<>'신차취소현황으로 보내기') d, \n"+
					"        CLIENT e, USERS f, car_pur g, (select * from code where c_st='0001') i \n"+
					" WHERE  a.dlv_st='1' and a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd and b.bus_id='"+ck_acar_id+"'"+
					"        AND a.settle_dt IS NULL AND DECODE(a.use_yn||a.suc_yn,'N','N','NN','N','NY','N','Y')='Y'\n"+
                    "        and b.rent_mng_id=h.rent_mng_id AND b.rent_l_cd=h.rent_l_cd "+
					"        AND a.rent_mng_id=c.rent_mng_id(+) AND a.rent_l_cd=c.rent_l_cd(+) and a.com_con_no=c.com_con_no(+) \n"+
					"        AND a.rent_mng_id=c2.rent_mng_id(+) AND a.rent_l_cd=c2.rent_l_cd(+) and a.com_con_no=c2.com_con_no(+) \n"+
					"        AND a.rent_mng_id=d.rent_mng_id(+) AND a.rent_l_cd=d.rent_l_cd(+) and a.com_con_no=d.com_con_no(+) \n"+
					"        AND b.client_id=e.client_id AND b.BUS_ID=f.user_id "+
				    "        and nvl(d.cng_yn,'N')='N'"+
					"        AND b.rent_mng_id=g.rent_mng_id AND b.rent_l_cd=g.rent_l_cd \n"+
					"        AND a.car_comp_id=i.code "+
					" ";

			if(!gubun4.equals(""))	query += " AND a.car_off_id='"+gubun4+"' ";		//제조회사가 아닌 출고영업소로 수정(2018.03.22)


			String search = "";
			String what = "";
			String dt1 = "";
			String dt2 = "";

			if(gubun1.equals("1")){
				dt1 = "substr(b.reg_dt,1,6)";
				dt2 = "b.reg_dt";
			}else if(gubun1.equals("2")){
				dt1 = "substr(a.dlv_est_dt,1,6)";
				dt2 = "a.dlv_est_dt";
			}else if(gubun1.equals("3")){
				dt1 = "to_char(c.reg_dt,'YYYYMM')";
				dt2 = "to_char(c.reg_dt,'YYYYMMDD')";
			}else if(gubun1.equals("4")){
				dt1 = "to_char(d.reg_dt,'YYYYMM')";
				dt2 = "to_char(d.reg_dt,'YYYYMMDD')";
			}

			//당일
			if(gubun2.equals("1"))				query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
			//전일
			else if(gubun2.equals("2"))			query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";		
			//당월
			else if(gubun2.equals("3"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%' ";
			//기간
			else if(gubun2.equals("4")){
				if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
				if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
			}

			if(s_kd.equals("1"))	what = "upper(nvl(g.pur_com_firm||e.firm_nm, ' '))";	
			if(s_kd.equals("2"))	what = "upper(nvl(a.rent_l_cd, ' '))";	
			if(s_kd.equals("3"))	what = "upper(nvl(DECODE(c.rent_l_cd,'',a.car_nm,c.car_nm), ' '))";		
			if(s_kd.equals("4"))	what = "upper(nvl(f.user_nm, ' '))";	
			if(s_kd.equals("5"))	what = "upper(nvl(a.com_con_no, ' '))";	
			if(s_kd.equals("6"))	what = "upper(nvl(nvl(g.pur_com_firm,e.firm_nm), ' '))";	
			
			if(!s_kd.equals("") && !t_wd.equals("")){
				query += " and "+what+" like upper('%"+t_wd+"%') ";
			}

			if(sort.equals("1"))		query += " order by b.reg_dt, a.dlv_est_dt, e.firm_nm ";
			if(sort.equals("2"))		query += " order by a.dlv_est_dt, b.reg_dt, e.firm_nm ";


		try {
			pstmt = con.prepareStatement(query);
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
			System.out.println("[CarOfficeDatabase:getPurComEstDtList]"+ e);
			System.out.println("[CarOfficeDatabase:getPurComEstDtList]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}


	/*
	*	협력업체-계출관리-신규계약
	*/
	public Vector getPurComConList(String s_kd, String t_wd, String sort, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String ck_acar_id) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

					
			query = " SELECT \n"+
					"        DECODE(a.use_yn,'Y','신규','C','변경','N',decode(a.suc_yn,'D','변경','Y','변경','해지')) use_yn_st, \n"+
					"        DECODE(a.stock_yn,'Y','있음','') stock_yn_st, \n"+
					"        DECODE(a.order_car,'Y','주문차','') order_car_st, \n"+
					"        DECODE(c.rent_l_cd,'',a.car_nm,c.car_nm) r_car_nm, \n"+
					"        DECODE(c.rent_l_cd,'',a.opt,c.opt) r_opt, \n"+
					"        DECODE(c.rent_l_cd,'',a.colo,c.colo) r_colo, \n"+
					"        DECODE(c.rent_l_cd,'',a.auto,c.auto) r_auto, \n"+
					"        DECODE(c.rent_l_cd,'',a.purc_gu,c.purc_gu) r_purc_gu, \n"+
					"        DECODE(c.rent_l_cd,'',a.car_c_amt,c.car_c_amt) r_car_c_amt, \n"+
					"        DECODE(c.rent_l_cd,'',a.car_f_amt,c.car_f_amt) r_car_f_amt, \n"+
					"        DECODE(c.rent_l_cd,'',a.car_g_amt,c.car_g_amt) r_car_g_amt, \n"+
					"        DECODE(c.rent_l_cd,'',a.dc_amt+a.add_dc_amt,c.dc_amt+c.add_dc_amt) r_dc_amt, \n"+
					"        DECODE(c.rent_l_cd,'',a.car_g_amt+a.cons_amt,c.car_g_amt+a.cons_amt) r_car_g_amt2, \n"+
					"        DECODE(d.rent_l_cd,'',c2.reg_dt,d.reg_dt) cng_reg_dt, \n"+
					"        DECODE(d.rent_l_cd,'',c2.cng_dt,d.cng_dt) cng_app_dt, \n"+
					"        DECODE(d.rent_l_cd,'',c2.cng_cont,d.cng_cont) cng_cont, \n"+
					"        b.reg_dt as rent_reg_dt, b.rent_dt, g.pur_req_dt, a.dlv_dt, e.firm_nm, nvl(g.pur_com_firm,e.firm_nm) pur_com_firm, f.user_nm AS bus_nm, \n"+
					"        decode(a.dlv_st,'1','예정','2','배정') dlv_st_nm, "+
					"        decode(a.udt_st,'1','서울본사','2','부산지점','3','대전지점','4','고객','5','대구지점','6','광주지점') udt_st_nm, "+
					"        (nvl(h.car_cs_amt,0) + nvl(h.car_cv_amt,0) + nvl(h.opt_cs_amt,0)+nvl(h.opt_cv_amt,0) + nvl(h.clr_cs_amt,0) + nvl(h.clr_cv_amt,0) - nvl(h.tax_dc_s_amt,0) - nvl(h.tax_dc_v_amt,0)) f_car_amt, \n"+
					"        a.*, i.nm as car_comp_nm \n"+
					" FROM   CAR_PUR_COM a, CONT b,    \n"+
					"        (select * from CAR_PUR_COM_CNG a where a.cng_st='1' and a.cng_cont<>'배달지' AND a.seq = (select max(seq) from CAR_PUR_COM_CNG WHERE cng_st='1' and cng_cont<>'배달지' and rent_mng_id=a.rent_mng_id AND rent_l_cd=a.rent_l_cd and com_con_no=a.com_con_no)) c, \n"+
					"        (select * from CAR_PUR_COM_CNG a where a.cng_st in ('1','3','4','5') AND a.seq = (select max(seq) from CAR_PUR_COM_CNG WHERE cng_st in ('1','3','4','5') and rent_mng_id=a.rent_mng_id AND rent_l_cd=a.rent_l_cd and com_con_no=a.com_con_no)) c2, \n"+
					"        (SELECT * FROM CAR_PUR_COM_CNG a WHERE a.cng_st='2' and a.cng_cont<>'신차취소현황으로 보내기') d, \n"+
					"        CLIENT e, USERS f, car_pur g, car_etc h, \n"+
				    "        (select * from doc_settle where doc_st='5') dh, (select * from code where c_st='0001') i "+
					" WHERE  a.dlv_st='2' and a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd and b.bus_id='"+ck_acar_id+"' "+
					"        AND a.settle_dt IS NULL AND DECODE(a.use_yn||a.suc_yn,'N','N','NN','N','NY','N','Y')='Y' \n"+
					"        AND a.rent_mng_id=c.rent_mng_id(+) AND a.rent_l_cd=c.rent_l_cd(+) and a.com_con_no=c.com_con_no(+) \n"+
					"        AND a.rent_mng_id=c2.rent_mng_id(+) AND a.rent_l_cd=c2.rent_l_cd(+) and a.com_con_no=c2.com_con_no(+) \n"+
					"        AND a.rent_mng_id=d.rent_mng_id(+) AND a.rent_l_cd=d.rent_l_cd(+) and a.com_con_no=d.com_con_no(+) \n"+
					"        AND b.client_id=e.client_id AND b.BUS_ID=f.user_id "+
				    "        and nvl(d.cng_yn,'N')='N'"+
					"        AND b.rent_mng_id=g.rent_mng_id AND b.rent_l_cd=g.rent_l_cd \n"+
                    "        and b.rent_mng_id=h.rent_mng_id AND b.rent_l_cd=h.rent_l_cd "+
 				    "        and g.req_code=dh.doc_id(+) AND a.car_comp_id=i.code "+
					" ";

			if(!gubun4.equals(""))		query += " AND a.car_off_id='"+gubun4+"' ";		//제조회사가 아닌 출고영업소로 수정(2018.03.22)

			String search = "";
			String what = "";
			String dt1 = "";
			String dt2 = "";

			if(gubun1.equals("1")){
				dt1 = "substr(b.reg_dt,1,6)";
				dt2 = "b.reg_dt";
			}else if(gubun1.equals("2")){
				dt1 = "substr(a.dlv_con_dt,1,6)";
				dt2 = "a.dlv_con_dt";
			}

			//당일
			if(gubun2.equals("1"))				query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
			//전일
			else if(gubun2.equals("2"))			query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";		
			//당월
			else if(gubun2.equals("3"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%' ";
			//기간
			else if(gubun2.equals("4")){
				if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
				if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
			}

			if(s_kd.equals("1"))	what = "upper(nvl(g.pur_com_firm||e.firm_nm, ' '))";	
			if(s_kd.equals("2"))	what = "upper(nvl(a.rent_l_cd, ' '))";	
			if(s_kd.equals("3"))	what = "upper(nvl(DECODE(c.rent_l_cd,'',a.car_nm,c.car_nm), ' '))";		
			if(s_kd.equals("4"))	what = "upper(nvl(f.user_nm, ' '))";	
			if(s_kd.equals("5"))	what = "upper(nvl(a.com_con_no, ' '))";	
			if(s_kd.equals("6"))	what = "upper(nvl(nvl(g.pur_com_firm,e.firm_nm), ' '))";	
			
			if(!s_kd.equals("") && !t_wd.equals("")){
				query += " and "+what+" like upper('%"+t_wd+"%') ";
			}

			if(sort.equals("1"))		query += " order by b.reg_dt, a.dlv_con_dt, e.firm_nm ";
			if(sort.equals("2"))		query += " order by a.dlv_con_dt, b.reg_dt, e.firm_nm ";

		try {
			pstmt = con.prepareStatement(query);
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
			System.out.println("[CarOfficeDatabase:getPurComConList]"+ e);
			System.out.println("[CarOfficeDatabase:getPurComConList]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

   /****************************************************************************************
	*******************************************   smart
    ****************************************************************************************/

	/**
     * 영업소 사원 담당자 조회
     */    
    public String getCarOffEmpDamdangId(String emp_id) throws UnknownDataException, DataSourceEmptyException, DatabaseException {
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null) 
            throw new DataSourceEmptyException("Can't get connection.!!");


        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        String damdang_id = "";
		query = " SELECT a.damdang_id \n"+
                " FROM   car_off_edh a, (select emp_id, max(seq) seq from car_off_edh group by emp_id) b \n"+
                " WHERE  a.emp_id='" + emp_id + "' and a.emp_id=b.emp_id and a.seq=b.seq  \n"+
				" ";

        try {
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
    
            if (rs.next())
                damdang_id = rs.getString("damdang_id")==null?"":rs.getString("damdang_id");
            else
                throw new UnknownDataException("Could not find Appcode # " + emp_id );
 			rs.close();
            stmt.close();
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());

        }finally{
            try{
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){} 
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return damdang_id;
    }


/*
	*	협력업체-계출관리-신규계약
	*/
	public Vector getPurComEstDtList(String s_kd, String t_wd, String sort, String gubun1, String gubun2, String gubun3, String st_dt, String end_dt) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

					
			query = " SELECT  \n"+
					"        DECODE(a.use_yn,'Y','신규','C','변경','N',decode(a.suc_yn,'D','변경','Y','변경','해지')) use_yn_st, \n"+
					"        DECODE(c.rent_l_cd,'',a.car_nm,c.car_nm) r_car_nm, \n"+
					"        DECODE(c.rent_l_cd,'',a.opt,c.opt) r_opt, \n"+
					"        DECODE(c.rent_l_cd,'',a.colo,c.colo) r_colo, \n"+
					"        DECODE(c.rent_l_cd,'',a.auto,c.auto) r_auto, \n"+
					"        DECODE(c.rent_l_cd,'',a.purc_gu,c.purc_gu) r_purc_gu, \n"+
					"        DECODE(c.rent_l_cd,'',a.car_c_amt,c.car_c_amt) r_car_c_amt, \n"+
					"        DECODE(c.rent_l_cd,'',a.car_f_amt,c.car_f_amt) r_car_f_amt, \n"+
					"        DECODE(c.rent_l_cd,'',a.car_g_amt,c.car_g_amt) r_car_g_amt, \n"+
					"        DECODE(d.rent_l_cd,'',c2.reg_dt,d.reg_dt) cng_reg_dt, \n"+
					"        DECODE(d.rent_l_cd,'',c2.cng_dt,d.cng_dt) cng_app_dt, \n"+
					"        DECODE(d.rent_l_cd,'',c2.cng_cont,d.cng_cont) cng_cont, \n"+
					"        b.rent_dt, e.firm_nm, f.user_nm AS bus_nm, \n"+
					"        decode(a.dlv_st,'1','예정','2','배정') dlv_st_nm, "+
					"        decode(a.udt_st,'1','서울본사','2','부산지점','3','대전지점','4','고객') udt_st_nm, "+
					"        a.* \n"+
					" FROM   CAR_PUR_COM a, CONT b,    \n"+
					"        (select * from CAR_PUR_COM_CNG a where a.cng_st='1' and a.cng_cont<>'배달지' AND a.seq = (select max(seq) from CAR_PUR_COM_CNG WHERE cng_st='1' and cng_cont<>'배달지' and rent_mng_id=a.rent_mng_id AND rent_l_cd=a.rent_l_cd and com_con_no=a.com_con_no)) c, \n"+
					"        (select * from CAR_PUR_COM_CNG a where a.cng_st in ('1','3','4','5') AND a.seq = (select max(seq) from CAR_PUR_COM_CNG WHERE cng_st in ('1','3','4','5') and rent_mng_id=a.rent_mng_id AND rent_l_cd=a.rent_l_cd and com_con_no=a.com_con_no)) c2, \n"+
					"        (SELECT * FROM CAR_PUR_COM_CNG a WHERE a.cng_st='2' and a.cng_cont<>'신차취소현황으로 보내기') d, \n"+
					"        CLIENT e, USERS f \n"+
					" WHERE  a.use_yn in ('Y','C') and a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd "+
					"        AND b.dlv_dt IS NULL AND DECODE(a.use_yn||a.suc_yn,'N','N','NN','N','NY','N','Y')='Y'\n"+
					"        AND a.rent_mng_id=c.rent_mng_id(+) AND a.rent_l_cd=c.rent_l_cd(+) and a.com_con_no=c.com_con_no(+) \n"+
					"        AND a.rent_mng_id=c2.rent_mng_id(+) AND a.rent_l_cd=c2.rent_l_cd(+) and a.com_con_no=c2.com_con_no(+) \n"+
					"        AND a.rent_mng_id=d.rent_mng_id(+) AND a.rent_l_cd=d.rent_l_cd(+) and a.com_con_no=d.com_con_no(+) \n"+
					"        AND b.client_id=e.client_id AND b.BUS_ID=f.user_id "+
					" ";

			if(gubun3.equals("1"))	query += " and a.dlv_st='1' ";
			if(gubun3.equals("2"))	query += " and a.dlv_st='2' ";
			if(gubun3.equals("3"))	query += " and c.reg_dt is null and c.cng_dt is not null ";
			if(gubun3.equals("4"))	query += " and c.reg_dt is null and c.cng_dt is null ";
			if(gubun3.equals("5"))	query += " and d.reg_dt is null and d.cng_dt is not null ";
			if(gubun3.equals("6"))	query += " and d.reg_dt is null and d.cng_dt is null ";

			if(gubun3.length()==5){
					query += " and a.dlv_st||f.dept_id='"+gubun3+"' ";
			}


			String what = "";

			if(s_kd.equals("1"))	what = "upper(nvl(e.firm_nm, ' '))";
			if(s_kd.equals("2"))	what = "upper(nvl(a.rent_l_cd, ' '))";	
			if(s_kd.equals("3"))	what = "upper(nvl(DECODE(c.rent_l_cd,'',a.car_nm,c.car_nm), ' '))";		
			if(s_kd.equals("4"))	what = "upper(nvl(f.user_nm, ' '))";	
			if(s_kd.equals("5"))	what = "upper(nvl(a.com_con_no, ' '))";	
			
			if(!s_kd.equals("") && !t_wd.equals("")){
				query += " and "+what+" like upper('%"+t_wd+"%') ";
			}

//			if(gubun3.equals("1"))	query += " order by a.dlv_est_dt ";
//			if(gubun3.equals("2"))	query += " order by a.dlv_con_dt ";
//			if(gubun3.equals("3"))	query += " order by c2.reg_dt ";
//			if(gubun3.equals("4"))	query += " order by c2.cng_dt ";
//			if(gubun3.equals("5"))	
				query += " order by d.reg_dt desc ";
//			if(gubun3.equals("6"))	query += " order by d.cng_dt ";

//System.out.println("[CarOfficeDatabase:getPurComEstDtList]"+ query);


		try {
			pstmt = con.prepareStatement(query);
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
			System.out.println("[CarOfficeDatabase:getPurComEstDtList]"+ e);
			System.out.println("[CarOfficeDatabase:getPurComEstDtList]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

	/**
     * 제조사 전체 조회.
     */
    public CarCompBean [] getCarCompAll(String comp_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = "SELECT C_ST, CODE, NM_CD, NM, ETC, APP_ST, CMS_BK, BIGO \n"
        		+ "FROM CODE a\n"
        		+ "where C_ST='0001'\n"
        		+ "and CODE <> '0000' and nm is not null and nvl(cms_bk,'Y')='Y'  and code='" + comp_id + "' order by app_st, code ";

        Collection col = new ArrayList();
        try{
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery(query);
            while(rs.next()){
                
				col.add(makeCarCompBean(rs));
 
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
        return (CarCompBean[])col.toArray(new CarCompBean[0]);
    }
    
    /**
     * 제조사 단건 조회.
     */
    public CarCompBean getCarComp(String comp_id) throws DatabaseException, DataSourceEmptyException{
    	Connection con = connMgr.getConnection(DATA_SOURCE);
    	if(con == null)
    		throw new DataSourceEmptyException("Can't get Connection !!");
    	
    	CarCompBean bean = new CarCompBean();
    	
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
    	
    	String query = "";
    	
    	query = "SELECT C_ST, CODE, NM_CD, NM, ETC, APP_ST, CMS_BK, BIGO \n"
    			+ "FROM CODE a\n"
    			+ "where C_ST='0001'\n"
    			+ "AND code='" + comp_id + "'";
    	
    	try{
    		pstmt = con.prepareStatement(query);
    		rs = pstmt.executeQuery(query);
    		while(rs.next()){
    			
    			bean.setC_st(rs.getString(1));
    			bean.setCode(rs.getString(2));
    			bean.setNm_cd(rs.getString(3));
    			bean.setNm(rs.getString(4));
    			bean.setEtc(rs.getString(5));
    			bean.setApp_st(rs.getString(6));
    			bean.setCms_bk(rs.getString(7));
    			bean.setBigo(rs.getString(8));
    			
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
    	return bean;
    }

    
    /**
     * 제조사 비고 조회
     * date : 2017년 1월 9일
     * author : 성승현
     * from :getCarOffEmpDamdangId(String emp_id) & getCarCompAll(String comp_id)
     */    
    public String getCarCompOne(String comp_id) throws UnknownDataException, DataSourceEmptyException, DatabaseException {
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null) 
            throw new DataSourceEmptyException("Can't get connection.!!");


        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        String etc = "";
		query = " SELECT ETC \n"+
                " FROM  CODE \n"+
                "where C_ST='0001' \n"+
                "and CODE <> '0000' and nm is not null and nvl(cms_bk,'Y')='Y'  and code='" + comp_id + "' order by app_st, code ";

		
        try {
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
    
            if (rs.next())
                etc = rs.getString("etc")==null?"":rs.getString("etc");
            else
                throw new UnknownDataException("Could not find Appcode # " + comp_id );
 			rs.close();
            stmt.close();
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());

        }finally{
            try{
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){} 
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return etc;
    }

    /**
     * 영업수당수수료현황 
     */
    public Hashtable getCarCompCase(String comp_id) 
		throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
		String query = "";
		Hashtable ht = new Hashtable();

		query = " SELECT * from code where c_st='0001' and code='" + comp_id + "' ";
				 
        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
			ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next())
			{								
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}
            rs.close();
            stmt.close();
        }catch(SQLException se){
			System.out.println("[CarOfficeDatabase:getCarCompCase]"+se);
			System.out.println("[CarOfficeDatabase:getCarCompCase]"+query);
			se.printStackTrace();
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return ht;
    }

    /**
     * 영업수당수수료현황 
     */
    public Hashtable getRentCommRtStat_20150923(String mode, String bus_st, String dlv_st, String car_st, String gubun1, String gubun2, String s_dt, String e_dt) 
		throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
		String query = "";
		String b_query = "";
		Hashtable ht = new Hashtable();


		b_query = " SELECT decode(b.pur_bus_st, '1','2', '2','1', '4','1', decode(a.bus_st, '2','1', '7','1', '2')) bus_st, \n"+
				  "        nvl(b.one_self,'N') one_self, a.car_st, NVL(c.comm_r_rt,0) comm_r_rt, decode(nvl(c.dlv_con_commi,0), 0,'N', 'Y') dlv_con_commi_yn, \n"+
                  "        CASE WHEN NVL(c.comm_r_rt,0) = 0 THEN '0' "+
				  "             WHEN NVL(c.comm_r_rt,0) > 0 AND NVL(c.comm_r_rt,0) <= 1 THEN '1' "+
				  "             WHEN NVL(c.comm_r_rt,0) > 1 AND NVL(c.comm_r_rt,0) <= 2 THEN '2' "+
				  "             WHEN NVL(c.comm_r_rt,0) > 2 THEN '3' "+
				  "        END comm_rt_range \n"+            
				  " FROM   CONT a, CAR_PUR b, (SELECT * FROM COMMI WHERE agnt_st='1') c, \n"+
				  "        (select * from cls_cont where cls_st in ('4','5')) o, \n"+
				  "	       (select * from cls_cont where cls_st in ('7','10')) o2 \n"+			
				  " WHERE  a.car_st not in ('2','4') AND a.car_gu='1' \n";
	
		String dt = "a.dlv_dt";
		if(gubun1.equals("1"))		dt = "a.rent_dt";
		if(gubun1.equals("3"))		dt = "a.rent_start_dt";

		if(gubun2.equals("1"))		b_query += " and "+dt+" like to_char(sysdate,'YYYYMM')||'%'  ";
		if(gubun2.equals("2"))		b_query += " and "+dt+" like TO_CHAR(add_months(sysdate,-1),'YYYYMM')||'%'  ";
		if(gubun2.equals("3")){
			if(!s_dt.equals("") && e_dt.equals(""))		b_query += " and "+dt+" like replace('"+s_dt+"%', '-','') \n";
			if(!s_dt.equals("") && !e_dt.equals(""))	b_query += " and "+dt+" between replace('"+s_dt+"', '-','') and replace('"+e_dt+"', '-','') \n";
		}

		b_query += "       AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd \n"+
				"          AND a.rent_mng_id=c.rent_mng_id(+) AND a.rent_l_cd=c.rent_l_cd(+) \n"+
				"          and a.rent_mng_id=o.rent_mng_id(+) and a.reg_dt=o.reg_dt(+) and o.rent_l_cd is null \n"+
				"          and a.rent_mng_id=o2.rent_mng_id(+) and a.rent_l_cd=o2.rent_l_cd(+) and o2.rent_l_cd is null \n"+
				" ";



		query = " SELECT "+
				"         COUNT(DECODE(comm_rt_range,'0',0)) cnt0,  \n"+
				"         COUNT(DECODE(comm_rt_range,'1',0)) cnt1,  \n"+
				"         COUNT(DECODE(comm_rt_range,'2',0)) cnt2,  \n"+
				"         COUNT(DECODE(comm_rt_range,'3',0)) cnt3,  \n"+
				"         decode(count(0),0,0,TRUNC(COUNT(DECODE(comm_rt_range,'0',0))/COUNT(0)*100,1)) per0, \n"+
				"         decode(count(0),0,0,TRUNC(COUNT(DECODE(comm_rt_range,'1',0))/COUNT(0)*100,1)) per1, \n"+
				"         decode(count(0),0,0,TRUNC(COUNT(DECODE(comm_rt_range,'2',0))/COUNT(0)*100,1)) per2, \n"+
				"         decode(count(0),0,0,TRUNC(COUNT(DECODE(comm_rt_range,'3',0))/COUNT(0)*100,1)) per3, \n"+
				"         COUNT(DECODE(comm_rt_range,'0',decode(dlv_con_commi_yn,'Y',0))) d_cnt0, \n"+
				"         COUNT(DECODE(comm_rt_range,'1',decode(dlv_con_commi_yn,'Y',0))) d_cnt1, \n"+
				"         COUNT(DECODE(comm_rt_range,'2',decode(dlv_con_commi_yn,'Y',0))) d_cnt2, \n"+
				"         COUNT(DECODE(comm_rt_range,'3',decode(dlv_con_commi_yn,'Y',0))) d_cnt3 \n"+
				" FROM \n"+ 
				"        ( "+b_query+" ) \n"+
				" ";

		query += " where bus_st='"+bus_st+"' and one_self='"+dlv_st+"' and car_st='"+car_st+"' ";



		if(bus_st.equals("2")){

			query = " SELECT count(0) cnt \n"+
					" FROM \n"+ 
					"        ( "+b_query+" ) \n"+
			        " where bus_st='"+bus_st+"' and one_self='"+dlv_st+"' and car_st='"+car_st+"' "+
					" ";
		}


        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
			ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next())
			{								
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}
            rs.close();
            stmt.close();
        }catch(SQLException se){
			System.out.println("[CarOfficeDatabase:getRentCommRtStat_20150923]"+se);
			System.out.println("[CarOfficeDatabase:getRentCommRtStat_20150923]"+query);
			se.printStackTrace();
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return ht;
    }
    
    /**
     * 영업수당수수료현황 
     */
    public Hashtable getRentCommRtStat_2019(String mode, String bus_st, String dlv_st, String car_st, String gubun1, String gubun2, String s_dt, String e_dt) 
		throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
		String query = "";
		String b_query = "";
		Hashtable ht = new Hashtable();

		b_query = " SELECT decode(b.pur_bus_st, '1','3', '2','1', '4','2', decode(a.bus_st, '2','1', '7','2', '3')) bus_st, \n"+
				  "        nvl(b.one_self,'N') one_self, a.car_st, NVL(c.comm_r_rt,0) comm_r_rt, decode(nvl(c.dlv_con_commi,0), 0,'N', 'Y') dlv_con_commi_yn, \n"+
                  "        CASE WHEN NVL(c.comm_r_rt,0) = 0 THEN '0' "+
				  "             WHEN NVL(c.comm_r_rt,0) > 0 AND NVL(c.comm_r_rt,0) <= 1 THEN '1' "+
				  "             WHEN NVL(c.comm_r_rt,0) > 1 AND NVL(c.comm_r_rt,0) <= 2 THEN '2' "+
				  "             WHEN NVL(c.comm_r_rt,0) > 2 THEN '3' "+
				  "        END comm_rt_range \n"+            
				  " FROM   CONT a, CAR_PUR b, (SELECT * FROM COMMI WHERE agnt_st='1') c, \n"+
				  "        (select * from cls_cont where cls_st in ('4','5')) o, \n"+
				  "	       (select * from cls_cont where cls_st in ('7','10')) o2 \n"+			
				  " WHERE  a.car_st not in ('2','4') AND a.car_gu='1' \n";
	
		String dt = "a.dlv_dt";
		if(gubun1.equals("1"))		dt = "a.rent_dt";
		if(gubun1.equals("3"))		dt = "a.rent_start_dt";

		if(gubun2.equals("1"))		b_query += " and "+dt+" like to_char(sysdate,'YYYYMM')||'%'  ";
		if(gubun2.equals("2"))		b_query += " and "+dt+" like TO_CHAR(add_months(sysdate,-1),'YYYYMM')||'%'  ";
		if(gubun2.equals("3")){
			if(!s_dt.equals("") && e_dt.equals(""))		b_query += " and "+dt+" like replace('"+s_dt+"%', '-','') \n";
			if(!s_dt.equals("") && !e_dt.equals(""))	b_query += " and "+dt+" between replace('"+s_dt+"', '-','') and replace('"+e_dt+"', '-','') \n";
		}

		b_query += "       AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd \n"+
				"          AND a.rent_mng_id=c.rent_mng_id(+) AND a.rent_l_cd=c.rent_l_cd(+) \n"+
				"          and a.rent_mng_id=o.rent_mng_id(+) and a.reg_dt=o.reg_dt(+) and o.rent_l_cd is null \n"+
				"          and a.rent_mng_id=o2.rent_mng_id(+) and a.rent_l_cd=o2.rent_l_cd(+) and o2.rent_l_cd is null \n"+
				" ";



		query = " SELECT "+
				"         COUNT(DECODE(comm_rt_range,'0',0)) cnt0,  \n"+
				"         COUNT(DECODE(comm_rt_range,'1',0)) cnt1,  \n"+
				"         COUNT(DECODE(comm_rt_range,'2',0)) cnt2,  \n"+
				"         COUNT(DECODE(comm_rt_range,'3',0)) cnt3,  \n"+
				"         decode(count(0),0,0,TRUNC(COUNT(DECODE(comm_rt_range,'0',0))/COUNT(0)*100,1)) per0, \n"+
				"         decode(count(0),0,0,TRUNC(COUNT(DECODE(comm_rt_range,'1',0))/COUNT(0)*100,1)) per1, \n"+
				"         decode(count(0),0,0,TRUNC(COUNT(DECODE(comm_rt_range,'2',0))/COUNT(0)*100,1)) per2, \n"+
				"         decode(count(0),0,0,TRUNC(COUNT(DECODE(comm_rt_range,'3',0))/COUNT(0)*100,1)) per3, \n"+
				"         COUNT(DECODE(comm_rt_range,'0',decode(dlv_con_commi_yn,'Y',0))) d_cnt0, \n"+
				"         COUNT(DECODE(comm_rt_range,'1',decode(dlv_con_commi_yn,'Y',0))) d_cnt1, \n"+
				"         COUNT(DECODE(comm_rt_range,'2',decode(dlv_con_commi_yn,'Y',0))) d_cnt2, \n"+
				"         COUNT(DECODE(comm_rt_range,'3',decode(dlv_con_commi_yn,'Y',0))) d_cnt3 \n"+
				" FROM \n"+ 
				"        ( "+b_query+" ) \n"+
				" ";

		query += " where bus_st='"+bus_st+"' and one_self='"+dlv_st+"' and car_st='"+car_st+"' ";



		if(bus_st.equals("3")){

			query = " SELECT count(0) cnt \n"+
					" FROM \n"+ 
					"        ( "+b_query+" ) \n"+
			        " where bus_st='"+bus_st+"' and one_self='"+dlv_st+"' and car_st='"+car_st+"' "+
					" ";
		}


        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
			ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next())
			{								
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}
            rs.close();
            stmt.close();
        }catch(SQLException se){
			System.out.println("[CarOfficeDatabase:getRentCommRtStat_2019]"+se);
			System.out.println("[CarOfficeDatabase:getRentCommRtStat_2019]"+query);
			se.printStackTrace();
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return ht;
    }    

    /**
     * 영업사원별 계약현황
     */
    public Vector getRentCommRtCont_20150923(String bus_st, String dlv_st, String car_st, String comm_r_rt, String gubun1, String gubun2, String s_dt, String e_dt) 
		throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
		Vector vt = new Vector();

		String b_query = "";
		String query = "";


		b_query = " SELECT decode(b.pur_bus_st, '1','2', '2','1', '4','1', decode(a.bus_st, '2','1', '7','1', '2')) bus_st, \n"+
				  "        nvl(b.one_self,'N') one_self, a.car_st, NVL(c.comm_r_rt,0) comm_r_rt, decode(nvl(c.dlv_con_commi,0), 0,'N', 'Y') dlv_con_commi_yn, \n"+
                  "        CASE WHEN NVL(c.comm_r_rt,0) = 0 THEN '0' "+
				  "             WHEN NVL(c.comm_r_rt,0) > 0 AND NVL(c.comm_r_rt,0) <= 1 THEN '1' "+
				  "             WHEN NVL(c.comm_r_rt,0) > 1 AND NVL(c.comm_r_rt,0) <= 2 THEN '2' "+
				  "             WHEN NVL(c.comm_r_rt,0) > 2 THEN '3' "+
				  "        END comm_rt_range, \n"+            
 			      "        a.use_yn, a.rent_dt, a.rent_l_cd, a.dlv_dt, \n"+
				  "        c.commi, nvl(c.dlv_con_commi,0) dlv_con_commi, c.sup_dt, decode(c.comm_rt,'','미등록',c.comm_rt) comm_rt, c.ch_remark, \n"+
				  "        d.car_no, nvl(d.car_nm,j.car_nm) car_nm, e.firm_nm, f.user_nm as bus_nm, decode(a.car_st,'1',i.Jg_f,i.jg_g)*100 jg_fg, \n"+
				  "        decode(a.bus_st, '1','인터넷','2','영업사원','3','업체소개','4','카달로그','5','전화상담','6','기존업체','7','에이젼트','8','모바일') bus_st_nm, \n"+
				  "        m.car_off_nm, k.emp_nm \n"+
				  " FROM   CONT a, CAR_PUR b, (SELECT * FROM COMMI WHERE agnt_st='1') c, car_reg d, client e, users f, \n"+          
				  "        CAR_ETC g, CAR_NM h, ESTI_JG_VAR i, car_mng j, car_off_emp k, car_off m, \n"+
				  "        (select * from cls_cont where cls_st in ('4','5')) o, (select * from cls_cont where cls_st in ('7','10')) o2 \n"+			
				  " WHERE  a.car_st in ('1','3','4') AND a.car_gu='1' \n";
	
		String dt = "a.dlv_dt";
		if(gubun1.equals("1"))		dt = "a.rent_dt";
		if(gubun1.equals("3"))		dt = "a.rent_start_dt";

		if(gubun2.equals("1"))		b_query += " and "+dt+" like to_char(sysdate,'YYYYMM')||'%'  ";
		if(gubun2.equals("2"))		b_query += " and "+dt+" like TO_CHAR(add_months(sysdate,-1),'YYYYMM')||'%'  ";
		if(gubun2.equals("3")){
			if(!s_dt.equals("") && e_dt.equals(""))		b_query += " and "+dt+" like replace('"+s_dt+"%', '-','') \n";
			if(!s_dt.equals("") && !e_dt.equals(""))	b_query += " and "+dt+" between replace('"+s_dt+"', '-','') and replace('"+e_dt+"', '-','') \n";
		}

		b_query += "     AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd \n"+
				"        AND a.rent_mng_id=c.rent_mng_id(+) AND a.rent_l_cd=c.rent_l_cd(+) \n"+
				"        and a.car_mng_id=d.car_mng_id(+) and a.client_id=e.client_id and a.bus_id=f.user_id \n"+
				"        AND a.rent_mng_id=g.rent_mng_id and a.rent_l_cd=g.rent_l_cd \n"+
				"        AND g.car_id=h.car_id AND g.car_seq=h.car_seq \n"+
				"        AND h.jg_code=i.sh_code \n"+
				"        AND (i.sh_code, i.reg_dt) IN (SELECT sh_code, MAX(reg_dt) reg_dt FROM ESTI_JG_VAR WHERE a.rent_dt>reg_dt GROUP BY sh_code) \n"+
				"        and h.car_comp_id=j.car_comp_id and h.car_cd=j.code "+
				"        and c.emp_id=k.emp_id(+) and k.car_off_id=m.car_off_id(+) "+
				"        and a.rent_mng_id=o.rent_mng_id(+) and a.reg_dt=o.reg_dt(+) and o.rent_l_cd is null \n"+
				"        and a.rent_mng_id=o2.rent_mng_id(+) and a.rent_l_cd=o2.rent_l_cd(+) and o2.rent_l_cd is null \n"+
				" ";



		query = " SELECT "+
				"         bus_st, one_self, car_st, comm_r_rt, dlv_con_commi_yn, comm_rt_range, \n"+
				"         use_yn, rent_dt, rent_l_cd, dlv_dt, commi, dlv_con_commi, sup_dt, comm_rt, ch_remark, \n"+
				"         car_no, car_nm, firm_nm, bus_nm, jg_fg, bus_st_nm, car_off_nm, emp_nm \n"+
				" FROM \n"+ 
				"        ( "+b_query+" ) \n"+
				" ";

		query += " where bus_st='"+bus_st+"' and one_self='"+dlv_st+"' and car_st='"+car_st+"' ";

		if(!comm_r_rt.equals(""))	query += " and comm_rt_range='"+comm_r_rt+"' ";

		query += " ORDER BY one_self desc, car_st, DECODE(bus_st_nm,'2','영업사원',''), comm_rt, comm_r_rt ";



        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
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
            stmt.close();

        }catch(SQLException se){
			System.out.println("[CarOfficeDatabase:getRentCommRtCont_20150923]"+se);
			System.out.println("[CarOfficeDatabase:getRentCommRtCont_20150923]"+query);
			se.printStackTrace();
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }
    
    /**
     * 영업사원별 계약현황
     */
    public Vector getRentCommRtCont_2019(String bus_st, String dlv_st, String car_st, String comm_r_rt, String gubun1, String gubun2, String s_dt, String e_dt, String jg_reg_dt) 
		throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
		Vector vt = new Vector();

		String b_query = "";
		String query = "";


		b_query = " SELECT decode(b.pur_bus_st, '1','3', '2','1', '4','2', decode(a.bus_st, '2','1', '7','2', '3')) bus_st, \n"+
				  "        nvl(b.one_self,'N') one_self, a.car_st, NVL(c.comm_r_rt,0) comm_r_rt, decode(nvl(c.dlv_con_commi,0), 0,'N', 'Y') dlv_con_commi_yn, \n"+
                  "        CASE WHEN NVL(c.comm_r_rt,0) = 0 THEN '0' "+
				  "             WHEN NVL(c.comm_r_rt,0) > 0 AND NVL(c.comm_r_rt,0) <= 1 THEN '1' "+
				  "             WHEN NVL(c.comm_r_rt,0) > 1 AND NVL(c.comm_r_rt,0) <= 2 THEN '2' "+
				  "             WHEN NVL(c.comm_r_rt,0) > 2 THEN '3' "+
				  "        END comm_rt_range, \n"+            
 			      "        a.use_yn, a.rent_dt, a.rent_l_cd, a.dlv_dt, \n"+
				  "        c.commi, nvl(c.dlv_con_commi,0) dlv_con_commi, c.sup_dt, decode(c.comm_rt,'','미등록',c.comm_rt) comm_rt, c.ch_remark, \n"+
				  "        d.car_no, nvl(d.car_nm,j.car_nm) car_nm, e.firm_nm, f.user_nm as bus_nm, decode(a.car_st,'1',i.Jg_f,i.jg_g)*100 jg_fg, \n"+
				  "        decode(a.bus_st, '1','인터넷','2','영업사원','3','업체소개','4','카달로그','5','전화상담','6','기존업체','7','에이젼트','8','모바일') bus_st_nm, \n"+
				  "        m.car_off_nm, k.emp_nm \n"+
				  " FROM   CONT a, CAR_PUR b, (SELECT * FROM COMMI WHERE agnt_st='1') c, car_reg d, client e, users f, \n"+          
				  "        CAR_ETC g, CAR_NM h, ESTI_JG_VAR i, car_mng j, car_off_emp k, car_off m, \n"+
				  "        (select * from cls_cont where cls_st in ('4','5')) o, (select * from cls_cont where cls_st in ('7','10')) o2 \n"+			
				  " WHERE  a.car_st in ('1','3','4') AND a.car_gu='1' \n";
	
		String dt = "a.dlv_dt";
		if(gubun1.equals("1"))		dt = "a.rent_dt";
		if(gubun1.equals("3"))		dt = "a.rent_start_dt";

		if(gubun2.equals("1"))		b_query += " and "+dt+" like to_char(sysdate,'YYYYMM')||'%'  ";
		if(gubun2.equals("2"))		b_query += " and "+dt+" like TO_CHAR(add_months(sysdate,-1),'YYYYMM')||'%'  ";
		if(gubun2.equals("3")){
			if(!s_dt.equals("") && e_dt.equals(""))		b_query += " and "+dt+" like replace('"+s_dt+"%', '-','') \n";
			if(!s_dt.equals("") && !e_dt.equals(""))	b_query += " and "+dt+" between replace('"+s_dt+"', '-','') and replace('"+e_dt+"', '-','') \n";
		}

		b_query += "     AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd \n"+
				"        AND a.rent_mng_id=c.rent_mng_id(+) AND a.rent_l_cd=c.rent_l_cd(+) \n"+
				"        and a.car_mng_id=d.car_mng_id(+) and a.client_id=e.client_id and a.bus_id=f.user_id \n"+
				"        AND a.rent_mng_id=g.rent_mng_id and a.rent_l_cd=g.rent_l_cd \n"+
				"        AND g.car_id=h.car_id AND g.car_seq=h.car_seq \n"+
				"        AND h.jg_code=i.sh_code \n"+
				"        AND i.reg_dt='"+jg_reg_dt+"'\n"+
				"        and h.car_comp_id=j.car_comp_id and h.car_cd=j.code "+
				"        and c.emp_id=k.emp_id(+) and k.car_off_id=m.car_off_id(+) "+
				"        and a.rent_mng_id=o.rent_mng_id(+) and a.reg_dt=o.reg_dt(+) and o.rent_l_cd is null \n"+
				"        and a.rent_mng_id=o2.rent_mng_id(+) and a.rent_l_cd=o2.rent_l_cd(+) and o2.rent_l_cd is null \n"+
				" ";



		query = " SELECT "+
				"         bus_st, one_self, car_st, comm_r_rt, dlv_con_commi_yn, comm_rt_range, \n"+
				"         use_yn, rent_dt, rent_l_cd, dlv_dt, commi, dlv_con_commi, sup_dt, comm_rt, ch_remark, \n"+
				"         car_no, car_nm, firm_nm, bus_nm, jg_fg, bus_st_nm, car_off_nm, emp_nm \n"+
				" FROM \n"+ 
				"        ( "+b_query+" ) \n"+
				" ";

		query += " where bus_st='"+bus_st+"' and one_self='"+dlv_st+"' and car_st='"+car_st+"' ";

		if(!comm_r_rt.equals(""))	query += " and comm_rt_range='"+comm_r_rt+"' ";

		query += " ORDER BY one_self desc, car_st, DECODE(bus_st_nm,'2','영업사원',''), comm_rt, comm_r_rt ";



        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
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
            stmt.close();

        }catch(SQLException se){
			System.out.println("[CarOfficeDatabase:getRentCommRtCont_2019]"+se);
			System.out.println("[CarOfficeDatabase:getRentCommRtCont_2019]"+query);
			se.printStackTrace();
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }    


   
	/**
     * 제조사 수입만 조회
     */
    public CarCompBean [] getCarCompAll_EstiSIP() throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = "SELECT C_ST, CODE, NM_CD, NM, ETC, APP_ST, CMS_BK, BIGO \n"
        		+ "FROM CODE a\n"
        		+ "where C_ST='0001'\n"
        		+ "and CODE <> '0000' and code IN ('0006','0013','0007','0027','0018','0044','0011','0021','0033','0025','0048','0047','0034','0049','0050','0051','0052','0056') \n" 
				+" order by decode(code,'0013',1,'0027',2,'0018',3,'0011',4,'0044',5,'0033',6,'0025',7,'0007',8,'0049',9,'0048',10,'0047',11,'0021',12,'0034',13,'0006','14') ";

        Collection col = new ArrayList();
        try{
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery(query);
            while(rs.next()){
                
				col.add(makeCarCompBean(rs));
 
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
        return (CarCompBean[])col.toArray(new CarCompBean[0]);
    }

	/**
     * 제조사 국산만 조회
     */
public CarCompBean [] getCarCompAll_EstiKS() throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = "SELECT C_ST, CODE, NM_CD, NM, ETC, APP_ST, CMS_BK, BIGO \n"
        		+ "FROM CODE a\n"
        		+ "where C_ST='0001'\n"
        		+ "and CODE <> '0000' and code <= '0005' ";

        Collection col = new ArrayList();
        try{
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery(query);
            while(rs.next()){
                
				col.add(makeCarCompBean(rs));
 
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
        return (CarCompBean[])col.toArray(new CarCompBean[0]);
    }

	//특판 계출관리 계약번호 변경
    public boolean updateCarPurComConNo(String o_com_con_no, String n_com_con_no, int vt_size) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        String query2 = "";
        boolean flag = true;
                
		query = " update car_pur_com set com_con_no=? where com_con_no=? ";

		query2 = " update car_pur_com_cng set com_con_no=? where com_con_no=? ";
            
       try{
            con.setAutoCommit(false);            
            
            pstmt = con.prepareStatement(query);
			pstmt.setString	(1,	n_com_con_no);
			pstmt.setString	(2,	o_com_con_no);
            pstmt.executeUpdate();

			if(vt_size >0){				
	            pstmt = con.prepareStatement(query2);
				pstmt.setString	(1,	n_com_con_no);
				pstmt.setString	(2,	o_com_con_no);
				pstmt.executeUpdate();
			}
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
                con.rollback();
		  		flag = false;
				System.out.println("[CarOfficeDatabase:updateCarPurComConNo]\n"+se);
				System.out.println("[CarOfficeDatabase:updateCarPurComConNo]update car_pur_com set com_con_no='"+n_com_con_no+"' where com_con_no='"+o_com_con_no+"'");
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

	//특판 계출관리 계약번호 변경
    public boolean updateCarPurComConNo(String rent_l_cd, String o_com_con_no, String n_com_con_no, int vt_size) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        PreparedStatement pstmt2 = null;
        String query = "";
        String query2 = "";
        boolean flag = true;
                
		query  = " update car_pur_com     set com_con_no=? where com_con_no=? and rent_l_cd=? ";

		query2 = " update car_pur_com_cng set com_con_no=? where com_con_no=? and rent_l_cd=? ";
            
       try{
            con.setAutoCommit(false);            
            
            pstmt = con.prepareStatement(query);
			pstmt.setString	(1,	n_com_con_no);
			pstmt.setString	(2,	o_com_con_no);
			pstmt.setString	(3,	rent_l_cd);
            pstmt.executeUpdate();
            pstmt.close();

            pstmt2 = con.prepareStatement(query2);
			pstmt2.setString	(1,	n_com_con_no);
			pstmt2.setString	(2,	o_com_con_no);
			pstmt2.setString	(3,	rent_l_cd);
			pstmt2.executeUpdate();
			pstmt2.close();
            
            con.commit();

        }catch(Exception se){
            try{
                con.rollback();
		  		flag = false;
				System.out.println("[CarOfficeDatabase:updateCarPurComConNo]\n"+se);
				System.out.println("[CarOfficeDatabase:updateCarPurComConNo]update car_pur_com set com_con_no='"+n_com_con_no+"' where com_con_no='"+o_com_con_no+"' and rent_l_cd='"+rent_l_cd+"' ");
				System.out.println("[CarOfficeDatabase:updateCarPurComConNo]\n"+vt_size);
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
        return flag;
    }

	//특판 계출관리 계약번호 변경
    public boolean updateCarPurComConNoCase1(String rent_l_cd, String o_com_con_no, String n_com_con_no) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        boolean flag = true;
                
		query  = " update car_pur_com     set com_con_no=? where com_con_no=? and rent_l_cd=? ";
            
       try{
            con.setAutoCommit(false);            
            
            pstmt = con.prepareStatement(query);
			pstmt.setString	(1,	n_com_con_no);
			pstmt.setString	(2,	o_com_con_no);
			pstmt.setString	(3,	rent_l_cd);
            pstmt.executeUpdate();
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
                con.rollback();
		  		flag = false;
				System.out.println("[CarOfficeDatabase:updateCarPurComConNoCase1]\n"+se);
				System.out.println("[CarOfficeDatabase:updateCarPurComConNoCase1]update car_pur_com set com_con_no='"+n_com_con_no+"' where com_con_no='"+o_com_con_no+"' and rent_l_cd='"+rent_l_cd+"' ");
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

	//특판 계출관리 계약번호 변경
    public boolean updateCarPurComConNoCase2(String rent_l_cd, String o_com_con_no, String n_com_con_no) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        boolean flag = true;
                
		query  = " update car_pur_com_cng set com_con_no=? where com_con_no=? and rent_l_cd=? ";
            
       try{
            con.setAutoCommit(false);            
            
            pstmt = con.prepareStatement(query);
			pstmt.setString	(1,	n_com_con_no);
			pstmt.setString	(2,	o_com_con_no);
			pstmt.setString	(3,	rent_l_cd);
            pstmt.executeUpdate();
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
                con.rollback();
		  		flag = false;
				System.out.println("[CarOfficeDatabase:updateCarPurComConNoCase2]\n"+se);
				System.out.println("[CarOfficeDatabase:updateCarPurComConNoCase2]update car_pur_com_cng set com_con_no='"+n_com_con_no+"' where com_con_no='"+o_com_con_no+"' and rent_l_cd='"+rent_l_cd+"' ");
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

    public boolean updateCarPurComConsOff(CarPurDocListBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        boolean flag = true;
                
		query = " update car_pur_com set "+
				"        cons_off_nm=?, cons_off_tel=? "+
				" where  rent_mng_id=? and rent_l_cd=? and com_con_no=?  "+
				" ";
            
       try{
            con.setAutoCommit(false);            
            
            pstmt = con.prepareStatement(query);
			pstmt.setString	(1,	bean.getCons_off_nm	());
			pstmt.setString	(2,	bean.getCons_off_tel());
			pstmt.setString	(3,	bean.getRent_mng_id	());
			pstmt.setString	(4,	bean.getRent_l_cd	());
			pstmt.setString	(5,	bean.getCom_con_no	());

            pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
                con.rollback();
		  		flag = false;
				System.out.println("[CarOfficeDatabase:updateCarPurComConsOff]\n"+se);
				System.out.println("[bean.getCons_off_nm	()]\n"+bean.getCons_off_nm	());
				System.out.println("[bean.getCons_off_tel	()]\n"+bean.getCons_off_tel	());
				System.out.println("[bean.getRent_mng_id	()]\n"+bean.getRent_mng_id	());
				System.out.println("[bean.getRent_l_cd		()]\n"+bean.getRent_l_cd	());
				System.out.println("[bean.getCom_con_no		()]\n"+bean.getCom_con_no	());
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
	
	//주문차 고객확인
    public boolean updateCarPurComOrderReq(CarPurDocListBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        boolean flag = true;
                
		query = " update car_pur_com set "+
				"        order_req_dt=sysdate, order_req_id=? "+
				" where  rent_mng_id=? and rent_l_cd=? and com_con_no=?  "+
				" ";
            
       try{
            con.setAutoCommit(false);            
            
            pstmt = con.prepareStatement(query);
			pstmt.setString	(1,	bean.getOrder_req_id());
			pstmt.setString	(2,	bean.getRent_mng_id	());
			pstmt.setString	(3,	bean.getRent_l_cd	());
			pstmt.setString	(4,	bean.getCom_con_no	());

            pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
                con.rollback();
		  		flag = false;
				System.out.println("[CarOfficeDatabase:updateCarPurComOrderReq]\n"+se);
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

	//주문차 고객확인
    public boolean updateCarPurComOrderChk(CarPurDocListBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        boolean flag = true;
                
		query = " update car_pur_com set "+
				"        order_chk_dt=sysdate, order_chk_id=? "+
				" where  rent_mng_id=? and rent_l_cd=? and com_con_no=?  "+
				" ";
            
       try{
            con.setAutoCommit(false);            
            
            pstmt = con.prepareStatement(query);
			pstmt.setString	(1,	bean.getOrder_chk_id());
			pstmt.setString	(2,	bean.getRent_mng_id	());
			pstmt.setString	(3,	bean.getRent_l_cd	());
			pstmt.setString	(4,	bean.getCom_con_no	());

            pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
                con.rollback();
		  		flag = false;
				System.out.println("[CarOfficeDatabase:updateCarPurComOrderChk]\n"+se);
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

	/*
	*	협력업체-계출관리-주문차계약
	*/
	public Vector getPurComOrderList(String s_kd, String t_wd, String sort, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

					

			query = " SELECT  \n"+
					"        b.*,  \n"+
					"        decode(b.dlv_st,'1','예정','2','배정') dlv_st_nm, \n"+
					"        decode(b.use_yn,'Y','','C','변경','N','해지') use_yn_st, \n"+
					"        c.dlv_dt, c.car_mng_id, d.firm_nm, nvl(g.pur_com_firm,d.firm_nm) pur_com_firm, e.user_nm AS bus_nm, \n"+
					"        i.nm as car_comp_nm, j.car_off_nm \n"+
					" FROM   CAR_PUR_COM b, CONT c, CLIENT d, USERS e, \n"+
					"        (select * from code where c_st='0001') i, car_off j, car_pur g "+
					" WHERE  b.order_car='Y' \n"+
					"        AND b.rent_mng_id=c.rent_mng_id AND b.rent_l_cd=c.rent_l_cd \n"+
					"        AND c.client_id=d.client_id \n"+
					"        AND c.BUS_ID=e.user_id "+
					"        AND b.car_comp_id=i.code \n"+
					"        and b.car_off_id=j.car_off_id "+
					"        and b.rent_mng_id=g.rent_mng_id and b.rent_l_cd=g.rent_l_cd "+
					" ";

			if(!gubun4.equals(""))		query += " and b.car_off_id='"+gubun4+"'";

			if(gubun3.equals("1")) query += " and b.order_chk_dt is null and b.order_req_dt is null and b.use_yn<>'N' and c.car_mng_id is null ";
			if(gubun3.equals("2")) query += " and (b.order_chk_dt is not null or b.order_req_dt is not null or b.use_yn='N' and c.car_mng_id is not null ) ";

			String search = "";
			String what = "";
			String dt1 = "";
			String dt2 = "";

			if(gubun1.equals("1")){
				dt1 = "to_char(b.order_req_dt,'YYYYMM')";
				dt2 = "to_char(b.order_req_dt,'YYYYMMDD')";
			}else if(gubun1.equals("2")){
				dt1 = "to_char(b.order_chk_dt,'YYYYMM')";
				dt2 = "to_char(b.order_chk_dt,'YYYYMMDD')";
			}

			//당일
			if(gubun2.equals("1"))				query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
			//전일
			else if(gubun2.equals("2"))			query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";		
			//당월
			else if(gubun2.equals("3"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%'";
			//기간
			else if(gubun2.equals("4")){
				if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
				if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
			}

			if(s_kd.equals("1"))	what = "upper(nvl(g.pur_com_firm||d.firm_nm, ' '))";	
			if(s_kd.equals("2"))	what = "upper(nvl(b.rent_l_cd, ' '))";	
			if(s_kd.equals("3"))	what = "upper(nvl(b.car_nm, ' '))";		
			if(s_kd.equals("4"))	what = "upper(nvl(e.user_nm, ' '))";	
			if(s_kd.equals("5"))	what = "upper(nvl(b.com_con_no, ' '))";	
			if(s_kd.equals("6"))	what = "upper(nvl(nvl(g.pur_com_firm,d.firm_nm), ' '))";	
			
			if(!s_kd.equals("") && !t_wd.equals("")){
				query += " and "+what+" like upper('%"+t_wd+"%') ";
			}

			if(sort.equals("1"))		query += " order by b.order_req_dt, b.reg_dt ";
			if(sort.equals("2"))		query += " order by b.order_chk_dt, b.order_req_dt, b.reg_dt ";


		try {
			pstmt = con.prepareStatement(query);
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
			System.out.println("[CarOfficeDatabase:getPurComOrderList]"+ e);
			System.out.println("[CarOfficeDatabase:getPurComOrderList]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

	/*
	*	협력업체-계출관리-신차취소현황
	*/
	public Vector getPurComShList(String s_kd, String t_wd, String sort, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String gubun7, String gubun8, String gubun9, String gubun10, String st_dt, String end_dt) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

					
			query = " SELECT b.car_off_nm, d.user_nm, nvl(c.situation,'대기') situation, c.res_end_dt, \n"+
					"        decode(a.dlv_st,'1','예정','2','배정') dlv_st_nm, decode(a.dlv_st,'1',a.dlv_est_dt,'2',a.dlv_con_dt) dlv_st_dt, \n"+
					"        a.* \n"+
					" FROM   car_pur_com a, car_off b, \n"+
					"        (select com_con_no, reg_id, res_end_dt, decode(situation,'0','상담중','1','계약진행중','2','계약확정','3','계약연동','예약가능') situation FROM car_pur_com_suc_res WHERE use_yn='Y') c, \n"+
					"        users d \n"+
					" WHERE  a.use_yn in ('N','C') and a.suc_yn is not null \n"+
					"        and a.car_off_id=b.car_off_id AND a.com_con_no=c.com_con_no(+) AND c.reg_id=d.user_id(+)  \n"+
					" ";


			if(!gubun4.equals(""))		query += " and a.car_off_id='"+gubun4+"'";

			if(!gubun3.equals("") && gubun6.equals(""))		query += " and a.car_nm like '%"+gubun3+"%'";
			if(!gubun3.equals("") && !gubun6.equals(""))	query += " and (a.car_nm like '%"+gubun3+"%' or a.car_nm like '%"+gubun6+"%')";

			if(!gubun7.equals("") || !gubun8.equals("") || !gubun9.equals("") || !gubun10.equals("")){

				query += " and ( a.opt like '%"+gubun7+"%' ";
				
				if(!gubun8.equals(""))	query += " or a.opt like '%"+gubun8+"%' ";
				if(!gubun9.equals(""))	query += " or a.opt like '%"+gubun9+"%' ";
				if(!gubun10.equals(""))	query += " or a.opt like '%"+gubun10+"%' ";

				query += " ) ";
			}

			if(gubun5.equals("D"))		query += " and a.suc_yn='D' ";
			if(gubun5.equals("D1"))		query += " and a.suc_yn='D' and c.reg_id is null ";
			if(gubun5.equals("D2"))		query += " and a.suc_yn='D' and c.reg_id is not null ";
			if(gubun5.equals("Y"))		query += " and a.suc_yn='Y' ";
			if(gubun5.equals("N"))		query += " and a.suc_yn='N' ";

			String search = "";
			String what = "";
			String dt1 = "";
			String dt2 = "";

			if(gubun1.equals("1")){
				dt1 = "substr(nvl(a.dlv_con_dt,nvl(a.dlv_est_dt,to_char(a.reg_dt,'YYYYMMDD'))),1,6) ";
				dt1 = "nvl(a.dlv_con_dt,nvl(a.dlv_est_dt,to_char(a.reg_dt,'YYYYMMDD'))) ";
			}

			//당일
			if(gubun2.equals("1"))				query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
			//전일
			else if(gubun2.equals("2"))			query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";		
			//당월
			else if(gubun2.equals("3"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%' ";
			//기간
			else if(gubun2.equals("4")){
				if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
				if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
			}

			if(s_kd.equals("1"))	what = "upper(nvl(a.com_con_no, ' '))";	
			if(s_kd.equals("2"))	what = "upper(nvl(a.colo, ' '))";		
			if(s_kd.equals("3"))	what = "upper(nvl(d.user_nm, ' '))";	
			
			if(!what.equals("") && !t_wd.equals("")){
				query += " and "+what+" like upper('%"+t_wd+"%') ";
			}

			if(sort.equals("1"))		query += " order by nvl(a.dlv_con_dt,nvl(a.dlv_est_dt,to_char(a.reg_dt,'YYYYMMDD'))) ";


		try {
			pstmt = con.prepareStatement(query);
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
			System.out.println("[CarOfficeDatabase:getPurComShList]"+ e);
			System.out.println("[CarOfficeDatabase:getPurComShList]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}
	
	/*
	 *	협력업체-계출관리-신차취소현황NEW
	 */
	public Vector getPurComShListNew(String s_kd, String t_wd, String sort, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String gubun7, String gubun8, String gubun9, String gubun10, String st_dt, String end_dt) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
			throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = " SELECT " +
						" b.car_off_nm, d.user_nm, nvl(c.situation,'대기') situation, c.res_end_dt, " + 
						" decode(a.dlv_st,'1','예정','2','배정') dlv_st_nm, decode(a.dlv_st,'1',a.dlv_est_dt,'2',a.dlv_con_dt) dlv_st_dt, " +
						        
						" DECODE(e.rent_mng_id,'',a.rent_mng_id, e.rent_mng_id) rent_mng_id, " +
						" DECODE(e.rent_l_cd,'',a.rent_l_cd, e.rent_l_cd) rent_l_cd, " +
				        " DECODE(e.com_con_no,'',a.com_con_no, e.com_con_no) com_con_no, " +
				        " DECODE(e.rent_l_cd,'',a.car_nm, e.car_nm) car_nm, " +
				        " DECODE(e.rent_l_cd,'',a.opt, e.opt) opt, " +
				        " DECODE(e.rent_l_cd,'',a.colo, e.colo) colo, " +      
				        " DECODE(e.rent_l_cd,'',a.purc_gu, e.purc_gu) purc_gu, " +
				        " DECODE(e.rent_l_cd,'',a.auto, e.auto) auto, " +
				        " DECODE(e.rent_l_cd,'',a.car_c_amt, e.car_c_amt) car_c_amt, " +
				        " DECODE(e.rent_l_cd,'',a.car_f_amt, e.car_f_amt) car_f_amt, " +
				        " DECODE(e.rent_l_cd,'',a.dc_amt, e.dc_amt) dc_amt, " +
				        " DECODE(e.rent_l_cd,'',a.add_dc_amt, e.add_dc_amt) add_dc_amt, " +
				        " DECODE(e.rent_l_cd,'',a.car_d_amt, e.car_d_amt) car_d_amt, " +
				        " DECODE(e.rent_l_cd,'',a.car_g_amt, e.car_g_amt) car_g_amt, " +
				        
						" a.cons_amt,  a.dlv_st, a.dlv_est_dt, a.dlv_con_dt, a.dlv_ext, a.dlv_mng_id, a.udt_st, a.udt_mng_id, a.udt_firm, a.udt_addr, " +
				        " a.REG_ID, a.reg_dt, a.con_id, a.con_dt, a.USE_YN, a.udt_mng_nm, a.udt_mng_tel, a.dlv_dt, a.SETTLE_id, a.SETTLE_DT, " +
				        " a.CAR_COMP_ID, a.UPDATE_ID, a.update_dt, a.STOCK_YN, a.bigo, a.STOCK_ST, a.car_off_id, a.cons_off_nm, " +
				        " a.cons_off_tel, a.order_car, a.order_req_id, a.order_req_dt, a.order_chk_id, a.order_chk_dt, a.SUC_YN " +
			        
				" FROM " +
				    	" car_pur_com a, car_off b, " + 
				    	" (select com_con_no, reg_id, res_end_dt, decode(situation,'0','상담중','1','계약진행중','2','계약확정','3','계약연동','예약가능') situation FROM car_pur_com_suc_res WHERE use_yn='Y') c, " + 
				        " users d, " +
				        " (select * from CAR_PUR_COM_CNG a where a.cng_st='1' and a.cng_cont<>'배달지' AND a.seq = (select max(seq) from CAR_PUR_COM_CNG WHERE cng_st='1' and cng_cont<>'배달지' and rent_mng_id=a.rent_mng_id AND rent_l_cd=a.rent_l_cd and com_con_no=a.com_con_no)) e, " +
				        " (select * from CAR_PUR_COM_CNG a where a.cng_st in ('1','3','4','5') AND a.seq = (select max(seq) from CAR_PUR_COM_CNG WHERE cng_st in ('1','3','4','5') and rent_mng_id=a.rent_mng_id AND rent_l_cd=a.rent_l_cd and com_con_no=a.com_con_no)) e2 " +
				" WHERE  a.use_yn in ('N','C') " +
						" and a.suc_yn is not NULL " +
						" AND a.rent_mng_id=e.rent_mng_id(+) AND a.rent_l_cd=e.rent_l_cd(+) and a.com_con_no=e.com_con_no(+) " +
						" AND a.rent_mng_id=e2.rent_mng_id(+) AND a.rent_l_cd=e2.rent_l_cd(+) and a.com_con_no=e2.com_con_no(+) " +
						" AND a.car_off_id=b.car_off_id  " +
						" AND a.com_con_no=c.com_con_no(+) " + 
						" AND c.reg_id=d.user_id(+) ";		
		
		if(!gubun4.equals(""))		query += " and a.car_off_id='"+gubun4+"'";
		
		if(!gubun3.equals("") && gubun6.equals(""))		query += " and a.car_nm like '%"+gubun3+"%'";
		if(!gubun3.equals("") && !gubun6.equals(""))	query += " and (a.car_nm like '%"+gubun3+"%' or a.car_nm like '%"+gubun6+"%')";
		
		if(!gubun7.equals("") || !gubun8.equals("") || !gubun9.equals("") || !gubun10.equals("")){
			
			query += " and ( a.opt like '%"+gubun7+"%' ";
			
			if(!gubun8.equals(""))	query += " or a.opt like '%"+gubun8+"%' ";
			if(!gubun9.equals(""))	query += " or a.opt like '%"+gubun9+"%' ";
			if(!gubun10.equals(""))	query += " or a.opt like '%"+gubun10+"%' ";
			
			query += " ) ";
		}
		
		if(gubun5.equals("D"))		query += " and a.suc_yn='D' ";
		if(gubun5.equals("D1"))		query += " and a.suc_yn='D' and c.reg_id is null ";
		if(gubun5.equals("D2"))		query += " and a.suc_yn='D' and c.reg_id is not null ";
		if(gubun5.equals("Y"))		query += " and a.suc_yn='Y' ";
		if(gubun5.equals("N"))		query += " and a.suc_yn='N' ";
		
		String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";
		
		if(gubun1.equals("1")){
			dt1 = "substr(nvl(a.dlv_con_dt,nvl(a.dlv_est_dt,to_char(a.reg_dt,'YYYYMMDD'))),1,6) ";
			dt2 = "nvl(a.dlv_con_dt,nvl(a.dlv_est_dt,to_char(a.reg_dt,'YYYYMMDD'))) ";
		}
		
		//당일
		if(gubun2.equals("1"))				query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
		//전일
		else if(gubun2.equals("2"))			query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";		
		//당월
		else if(gubun2.equals("3"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%'";
		//기간
		else if(gubun2.equals("4")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}
		
		if(s_kd.equals("1"))	what = "upper(nvl(a.com_con_no, ' '))";	
		if(s_kd.equals("2"))	what = "upper(nvl(a.colo, ' '))";		
		if(s_kd.equals("3"))	what = "upper(nvl(d.user_nm, ' '))";	
		
		if(!what.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}
		
		if(sort.equals("1"))		query += " order by nvl(a.dlv_con_dt,nvl(a.dlv_est_dt,to_char(a.reg_dt,'YYYYMMDD'))) ";
		
		
		try {
			pstmt = con.prepareStatement(query);
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
			System.out.println("[CarOfficeDatabase:getPurComShListNew]"+ e);
			System.out.println("[CarOfficeDatabase:getPurComShListNew]"+ query);
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

	/*
	*	협력업체-계출관리-신차취소현황 예약리스트
	*/
	public Vector getSucResList(String com_con_no) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select com_con_no, seq, reg_id, situation, reg_dt, res_st_dt, res_end_dt, nvl(use_yn,'') use_yn, memo, cust_nm, cust_tel, nvl(add_cnt,0) add_cnt, nvl(add_cnt_s,0) add_cnt_s "+
				" from   car_pur_com_suc_res "+
				" where  com_con_no='"+com_con_no+"' and nvl(use_yn,'Y')='Y' and situation in ('0','2','3')"+
				" order by seq";

		try {
			pstmt = con.prepareStatement(query);
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
			System.out.println("[CarOfficeDatabase:getSucResList]"+ e);
			System.out.println("[CarOfficeDatabase:getSucResList]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

	/*
	*	협력업체-계출관리-신차취소현황 예약리스트
	*/
	public Vector getSucResHList(String com_con_no) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select com_con_no, seq, reg_id, situation, reg_dt, res_st_dt, res_end_dt, nvl(use_yn,'') use_yn, memo, cust_nm, cust_tel, nvl(add_cnt,0) add_cnt, nvl(add_cnt_s,0) add_cnt_s "+
				" from   car_pur_com_suc_res "+
				" where  com_con_no='"+com_con_no+"' "+
				" order by seq desc ";

		try {
			pstmt = con.prepareStatement(query);
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
			System.out.println("[CarOfficeDatabase:getSucResHList]"+ e);
			System.out.println("[CarOfficeDatabase:getSucResHList]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

	/*
	*	협력업체-계출관리-신차취소현황 예약
	*/
	public Hashtable getSucRes(String com_con_no) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select com_con_no, seq, reg_id, situation, reg_dt, res_st_dt, res_end_dt, nvl(use_yn,'') use_yn, memo, cust_nm, cust_tel, nvl(add_cnt,0) add_cnt, nvl(add_cnt_s,0) add_cnt_s "+
				" from   car_pur_com_suc_res "+
				" where  com_con_no='"+com_con_no+"' and use_yn='Y'"+
				" order by seq";

		try {
			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next())
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
			System.out.println("[CarOfficeDatabase:getSucRes]"+ e);
			System.out.println("[CarOfficeDatabase:getSucRes]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return ht;
	}

	/*
	*	협력업체-계출관리-신차취소현황 예약
	*/
	public Hashtable getSucRes(String com_con_no, String seq) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select com_con_no, seq, reg_id, situation, reg_dt, to_char(reg_dt,'YYYYMMDD') r_reg_dt, res_st_dt, res_end_dt, nvl(use_yn,'') use_yn, memo, cust_nm, cust_tel, nvl(add_cnt,0) add_cnt, nvl(add_cnt_s,0) add_cnt_s "+
				" from   car_pur_com_suc_res "+
				" where  com_con_no='"+com_con_no+"' and seq="+seq+" "+
				" order by seq";

		try {
			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next())
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
			System.out.println("[CarOfficeDatabase:getSucRes]"+ e);
			System.out.println("[CarOfficeDatabase:getSucRes]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return ht;
	}

	//자체출고관리 변경분 삭제
    public boolean deleteCarPurComCng(CarPurDocListBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        boolean flag = true;
                
		query = " delete from car_pur_com_cng where  rent_mng_id=? and rent_l_cd=? and com_con_no=? and seq=?  "+
				" ";
            
       try{
            con.setAutoCommit(false);                        
            pstmt = con.prepareStatement(query);
			pstmt.setString	(1,	bean.getRent_mng_id	());
			pstmt.setString	(2,	bean.getRent_l_cd	());
			pstmt.setString	(3,	bean.getCom_con_no	());
			pstmt.setInt	(4,	bean.getSeq			());
            pstmt.executeUpdate();             
            pstmt.close();
            con.commit();
        }catch(Exception se){
            try{
                con.rollback();
		  		flag = false;
				System.out.println("[CarOfficeDatabase:deleteCarPurComCng]\n"+se);
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

