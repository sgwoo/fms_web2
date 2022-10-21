/**
 * 차량정비
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2002. 3. 4
 * @ last modify date : 
 */
package acar.serv_off;

import java.util.*;
import java.sql.*;
import acar.util.*;
import acar.common.*;
import acar.car_service.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.UnknownDataException;
import acar.exception.DatabaseException;

public class ServOffDatabase {

    private static ServOffDatabase instance;
    private DBConnectionManager connMgr;   
    // Pool로 부터 Connection 객체를 가져올때 사용하는 Pool Name 
    private final String DATA_SOURCE = "acar"; 
 
    // 싱글톤 클래스로 구현 
    // 생성자를 private 로 선언
    public static synchronized ServOffDatabase getInstance() throws DatabaseException {
        if (instance == null)
            instance = new ServOffDatabase();
        return instance;
    }
    
    private ServOffDatabase() throws DatabaseException {
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

		    bean.setCar_no(results.getString("CAR_NO"));
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

            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}
	/**
     * 정비업체
     */
    private ServOffBean makeServOffBean(ResultSet results) throws DatabaseException {

        try {
            ServOffBean bean = new ServOffBean();

		    bean.setOff_id(results.getString("OFF_ID")); 
			bean.setCar_comp_id(results.getString("CAR_COMP_ID")); 
			bean.setOff_nm(results.getString("OFF_NM")); 
			bean.setOff_st(results.getString("OFF_ST")); 
			bean.setOwn_nm(results.getString("OWN_NM")); 
			bean.setEnt_no(results.getString("ENT_NO")); 
			bean.setOff_sta(results.getString("OFF_STA")); 
			bean.setOff_item(results.getString("OFF_ITEM")); 
			bean.setOff_tel(results.getString("OFF_TEL")); 
			bean.setOff_fax(results.getString("OFF_FAX")); 
			bean.setHomepage(results.getString("HOMEPAGE")); 
			bean.setOff_post(results.getString("OFF_POST")); 
			bean.setOff_addr(results.getString("OFF_ADDR")); 
			bean.setBank(results.getString("BANK")); 
			bean.setAcc_no(results.getString("ACC_NO")); 
			bean.setNote(results.getString("NOTE"));
			bean.setAcc_nm(results.getString("ACC_NM")); 
			
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}
	/**
     * 정비업체,차량연결
     */
    private CustServBean makeCustServBean(ResultSet results, String arg) throws DatabaseException {

        try {
            CustServBean bean = new CustServBean();
			if(arg.equals("csr"))
			{
			    bean.setOff_id(results.getString("OFF_ID")); 
				bean.setSeq_no(results.getInt("SEQ_NO"));
			} 
			bean.setCar_mng_id(results.getString("CAR_MNG_ID")); 
			bean.setInit_reg_dt(results.getString("INIT_REG_DT"));
			bean.setCar_no(results.getString("CAR_NO")); 
			bean.setFirm_nm(results.getString("FIRM_NM"));
			bean.setClient_nm(results.getString("CLIENT_NM")); 
			bean.setMgr_nm(results.getString("MGR_NM")); 
			
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}
    /**
     * 정비업체 개별 조회
     */    
    public ServOffBean getServOff(String off_id) throws UnknownDataException, DataSourceEmptyException, DatabaseException {
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null) 
            throw new DataSourceEmptyException("Can't get connection.!!");

        ServOffBean sob = new ServOffBean();

        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        query = "select OFF_ID, CAR_COMP_ID, OFF_NM, OFF_ST, OWN_NM, substr(ent_no,1,3)||'-'||substr(ent_no,4,2)||'-'||substr(ent_no,6,5) as ENT_NO, OFF_STA, OFF_ITEM, OFF_TEL, OFF_FAX, HOMEPAGE, OFF_POST, OFF_ADDR, BANK, ACC_NO, ACC_NM, NOTE\n"
        		+ "from serv_off where off_id='" + off_id + "'\n";

        try {
        	stmt = con.createStatement();
            rs = stmt.executeQuery(query);

            if (rs.next()){
                sob = makeServOffBean(rs);
			}

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

        return sob;
    }
    
    /**
     * 정비업체 전체 조회.
     */
    public ServOffBean [] getServOffAll(String off_nm) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";
        String subQuery = "";
        
        if(off_nm.equals(""))
        {
        	subQuery = "where nvl(off_type,'1') = '1' and  off_nm ='"+off_nm+"'\n";
        }else{
        	subQuery = "where nvl(off_type, '1') = '1' and upper(off_nm)||ent_no like upper('%"+ off_nm+ "%')\n";
        }
        
        query = "select OFF_ID, CAR_COMP_ID, OFF_NM, OFF_ST, OWN_NM, substr(ent_no,1,3)||'-'||substr(ent_no,4,2)||'-'||substr(ent_no,6,5) as ENT_NO, OFF_STA, OFF_ITEM, OFF_TEL, OFF_FAX, HOMEPAGE, OFF_POST, OFF_ADDR, BANK, ACC_NO, ACC_NM, NOTE\n"
        		+ "from serv_off  \n"
        		+ subQuery;


        Collection<ServOffBean> col = new ArrayList<ServOffBean>();
        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
                
				col.add(makeServOffBean(rs));
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
        return (ServOffBean[])col.toArray(new ServOffBean[0]);
    }
    
    /**
     * 정비업체,차량연결
     */
    public CustServBean [] getCustServAll(String gubun, String gubun_nm) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";
        String subQuery = "";
        
        if(gubun.equals("car_no"))
        {
        	subQuery = "and a.car_no like '%" + gubun_nm + "%'\n";
        }else if(gubun.equals("firm_nm")){
        	subQuery = "and c.firm_nm like '%" + gubun_nm + "%'\n";
        }else if(gubun.equals("client_nm")){
        	subQuery = "and c.client_nm like '%" + gubun_nm + "%'\n";
        }else{
        	subQuery = "and a.car_mng_id=''\n";
        }
        
        query = "select a.car_mng_id as CAR_MNG_ID, a.init_reg_dt as INIT_REG_DT, a.car_no as CAR_NO, b.rent_mng_id as RENT_MNG_ID, b.rent_l_cd as RENT_L_CD, c.client_nm as CLIENT_NM, c.firm_nm as FIRM_NM, d.mgr_nm as MGR_NM\n"
				+ "from car_reg a, cont b, client c, car_mgr d\n"
				+ "where a.car_mng_id=b.car_mng_id\n"
				+ "and b.client_id=c.client_id\n"
				+ "and b.rent_mng_id=d.rent_mng_id\n"
				+ "and b.rent_l_cd=d.rent_l_cd\n"
				+ subQuery
				+ "and d.mgr_id='1'\n"
				+ "and not exists (select car_mng_id from cust_serv where a.car_mng_id=car_mng_id) order by c.firm_nm, c.client_nm\n";


        Collection<CustServBean> col = new ArrayList<CustServBean>();
        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
                
				col.add(makeCustServBean(rs,"cs"));
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
        return (CustServBean[])col.toArray(new CustServBean[0]);
    }
    /**
     * 정비업체,차량연결 등록리스트
     */
    public CustServBean [] getCustServReg(String off_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = "select e.off_id as OFF_ID,e.seq_no as SEQ_NO,a.car_mng_id as CAR_MNG_ID, a.init_reg_dt as INIT_REG_DT,a.car_no as CAR_NO, b.rent_mng_id as RENT_MNG_ID, b.rent_l_cd as RENT_L_CD, c.client_nm as CLIENT_NM, c.firm_nm as FIRM_NM, d.mgr_nm as MGR_NM\n"
				+ "from car_reg a, cont b, client c, car_mgr d, cust_serv e\n"
				+ "where e.off_id='" + off_id + "'\n"
				+ "and e.car_mng_id=a.car_mng_id\n"
				+ "and a.car_mng_id=b.car_mng_id\n"
				+ "and b.client_id=c.client_id\n"
				+ "and b.rent_mng_id=d.rent_mng_id\n"
				+ "and b.rent_l_cd=d.rent_l_cd\n"
				+ "and d.mgr_id='1' order by c.firm_nm, c.client_nm\n";
				

        Collection<CustServBean> col = new ArrayList<CustServBean>();
        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
                
				col.add(makeCustServBean(rs,"csr"));
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
        return (CustServBean[])col.toArray(new CustServBean[0]);
    }
    /**
     * 서비스조회
     */
    public ServiceBean [] getServiceAll( String off_id ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = "select c.car_no as CAR_NO, a.car_mng_id CAR_MNG_ID, a.serv_id SERV_ID, a.accid_id ACCID_ID, a.rent_mng_id RENT_MNG_ID, a.rent_l_cd RENT_L_CD, a.off_id OFF_ID, b.off_nm OFF_NM,decode(a.serv_st,'4',nvl2(a.accid_dt,substr(a.accid_dt,1,4)||'-'||substr(a.accid_dt,5,2)||'-'||substr(a.accid_dt,7,2),''),nvl2(a.serv_dt,substr(a.serv_dt,1,4)||'-'||substr(a.serv_dt,5,2)||'-'||substr(a.serv_dt,7,2),'')) SERV_DT, a.serv_st SERV_ST, a.checker CHECKER, a.tot_dist TOT_DIST, a.rep_nm REP_NM, a.rep_tel REP_TEL, a.rep_m_tel REP_M_TEL, a.rep_amt REP_AMT, a.sup_amt SUP_AMT, a.add_amt ADD_AMT, a.dc DC, a.tot_amt TOT_AMT, nvl2(a.sup_dt,substr(a.sup_dt,1,4)||'-'||substr(a.sup_dt,5,2)||'-'||substr(a.sup_dt,7,2),'') SUP_DT, nvl2(a.set_dt,substr(a.set_dt,1,4)||'-'||substr(a.set_dt,5,2)||'-'||substr(a.set_dt,7,2),'') SET_DT, a.bank BANK, a.acc_no ACC_NO, a.acc_nm ACC_NM, a.rep_item REP_ITEM, a.rep_cont REP_CONT, nvl2(a.cust_plan_dt,substr(a.cust_plan_dt,1,4)||'-'||substr(a.cust_plan_dt,5,2)||'-'||substr(a.cust_plan_dt,7,2),'') CUST_PLAN_DT, a.cust_amt CUST_AMT, a.cust_agnt CUST_AGNT\n" 
				+ "from service a, serv_off b, car_reg c\n"
				+ "where b.off_id=?\n"
				+ "and a.off_id=b.off_id and a.car_mng_id=c.car_mng_id\n";

        Collection<ServiceBean> col = new ArrayList<ServiceBean>();
        try{
            pstmt = con.prepareStatement(query);
    		pstmt.setString(1, off_id.trim());
    		
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
     * 정비업체 등록.
     */
    
    public String insertServOff(ServOffBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        PreparedStatement pstmt1 = null;
        ResultSet rs = null;
        String query = "";
        String query1 = "";
        String off_id = "";
        int count = 0;
                
        query="insert into serv_off(OFF_ID, CAR_COMP_ID, OFF_NM, OFF_ST, OWN_NM, ENT_NO, OFF_STA, OFF_ITEM, OFF_TEL, OFF_FAX, HOMEPAGE, OFF_POST, OFF_ADDR, BANK, ACC_NO, ACC_NM, NOTE)\n"
			+ "values(?, ?, ?, ?, ?, replace(?,'-',''), ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)\n";
   
        query1="select nvl(lpad(max(OFF_ID)+1,6,'0'),'000001') from serv_off";
       try{
            con.setAutoCommit(false);
			pstmt1 = con.prepareStatement(query1);
			rs = pstmt1.executeQuery();

            if(rs.next()){
				off_id = rs.getString(1);
            }
			
            pstmt = con.prepareStatement(query);
			
			pstmt.setString(1, off_id.trim());
			pstmt.setString(2, bean.getCar_comp_id().trim()); 
			pstmt.setString(3, bean.getOff_nm().trim()); 
			pstmt.setString(4, bean.getOff_st().trim()); 
			pstmt.setString(5, bean.getOwn_nm().trim()); 
			pstmt.setString(6, bean.getEnt_no().trim()); 
			pstmt.setString(7, bean.getOff_sta().trim()); 
			pstmt.setString(8, bean.getOff_item().trim()); 
			pstmt.setString(9, bean.getOff_tel().trim()); 
			pstmt.setString(10, bean.getOff_fax().trim()); 
			pstmt.setString(11, bean.getHomepage().trim()); 
			pstmt.setString(12, bean.getOff_post().trim()); 
			pstmt.setString(13, bean.getOff_addr().trim()); 
			pstmt.setString(14, bean.getBank().trim()); 
			pstmt.setString(15, bean.getAcc_no().trim()); 
			pstmt.setString(16, bean.getAcc_nm().trim()); 
			pstmt.setString(17, bean.getNote());
          
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
			con = null;
        }

        return off_id;
    }
    /**
     * 정비업체 수정.
     */
    
    public int updateServOff(ServOffBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
        PreparedStatement pstmt = null;
        String off_id = "";
        String query = "";
        int count = 0;
                
        query="update serv_off set CAR_COMP_ID=?, OFF_NM=?, OFF_ST=?, OWN_NM=?, ENT_NO=replace(?,'-',''), OFF_STA=?, OFF_ITEM=?, OFF_TEL=?, OFF_FAX=?, HOMEPAGE=?, OFF_POST=?, OFF_ADDR=?, BANK=?, ACC_NO=?, ACC_NM=?, NOTE=?\n"
			+ "where off_id=?\n";    
       try{
            con.setAutoCommit(false);
            
            pstmt = con.prepareStatement(query);
			
			pstmt.setString(1, bean.getCar_comp_id().trim()); 
			pstmt.setString(2, bean.getOff_nm().trim()); 
			pstmt.setString(3, bean.getOff_st().trim()); 
			pstmt.setString(4, bean.getOwn_nm().trim()); 
			pstmt.setString(5, bean.getEnt_no().trim()); 
			pstmt.setString(6, bean.getOff_sta().trim()); 
			pstmt.setString(7, bean.getOff_item().trim()); 
			pstmt.setString(8, bean.getOff_tel().trim()); 
			pstmt.setString(9, bean.getOff_fax().trim()); 
			pstmt.setString(10, bean.getHomepage().trim()); 
			pstmt.setString(11, bean.getOff_post().trim()); 
			pstmt.setString(12, bean.getOff_addr().trim()); 
			pstmt.setString(13, bean.getBank().trim()); 
			pstmt.setString(14, bean.getAcc_no().trim()); 
			pstmt.setString(15, bean.getAcc_nm().trim()); 
			pstmt.setString(16, bean.getNote().trim());
			pstmt.setString(17, bean.getOff_id().trim()); 
          
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
     * 차량등록.
     */
    public int insertCustServ(String off_id, Vector v) throws DatabaseException, DataSourceEmptyException, UnknownDataException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;

        int count = 0;
        
        String query = "insert into cust_serv(OFF_ID,SEQ_NO,CAR_MNG_ID)\n"
                         +"select ?,nvl(max(seq_no)+1,1),? from cust_serv";
        try{
            con.setAutoCommit(false);
               
            pstmt = con.prepareStatement(query);
            for(int i=0; i<v.size(); i++){
                String val [] = (String [])v.elementAt(i);
                pstmt.setString(1, off_id.trim());
                pstmt.setString(2, val[0].trim());
                count = pstmt.executeUpdate();
            }
            pstmt.close();

            con.commit();
        }catch(SQLException se){
            try{
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException(Util.getStackTrace(se));
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
     * 차량삭제.
     */
    public int deleteCustServ(String off_id, Vector v) throws DatabaseException, DataSourceEmptyException, UnknownDataException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;

        int count = 0;
        
        String query = "delete cust_serv where off_id=? and seq_no=?";

        try{
            con.setAutoCommit(false);
               
            pstmt = con.prepareStatement(query);
            for(int i=0; i<v.size(); i++){
                int val [] = (int [])v.elementAt(i);

                pstmt.setString(1, off_id.trim());
                pstmt.setInt(2, val[0]);
                count = pstmt.executeUpdate();
            }
            pstmt.close();

            con.commit();
        }catch(SQLException se){
            try{
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException(Util.getStackTrace(se));
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
     * 정비건등록시 새로운 정비업체 등록. 2003.10.09.
	 */    
    public ServOffBean insServOff(ServOffBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        PreparedStatement pstmt1 = null;
        ResultSet rs = null;
        String query = "";
        String query1 = "";
        String off_id = "";
        int count = 0;
                
        query="INSERT INTO serv_off(off_id,car_comp_id,off_nm,off_st,own_nm,ent_no,off_sta,off_item,off_tel,off_fax,homepage,off_post,off_addr,bank,acc_no,acc_nm,note, off_type)\n"
			+ "VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)\n";
   
        query1="SELECT NVL(LPAD(MAX(off_id)+1,6,'0'),'000001') FROM serv_off";

       try{
            con.setAutoCommit(false);
			pstmt1 = con.prepareStatement(query1);
			rs = pstmt1.executeQuery();

            if(rs.next()){
				off_id = rs.getString(1);
            }
			bean.setOff_id(off_id.trim());
			
            pstmt = con.prepareStatement(query);
			
			pstmt.setString(1, bean.getOff_id().trim());
			pstmt.setString(2, bean.getCar_comp_id().trim()); 
			pstmt.setString(3, bean.getOff_nm().trim()); 
			pstmt.setString(4, bean.getOff_st().trim()); 
			pstmt.setString(5, bean.getOwn_nm().trim()); 
			pstmt.setString(6, bean.getEnt_no().trim()); 
			pstmt.setString(7, bean.getOff_sta().trim()); 
			pstmt.setString(8, bean.getOff_item().trim()); 
			pstmt.setString(9, bean.getOff_tel().trim()); 
			pstmt.setString(10, bean.getOff_fax().trim()); 
			pstmt.setString(11, bean.getHomepage().trim()); 
			pstmt.setString(12, bean.getOff_post().trim()); 
			pstmt.setString(13, bean.getOff_addr().trim()); 
			pstmt.setString(14, bean.getBank().trim()); 
			pstmt.setString(15, bean.getAcc_no().trim()); 
			pstmt.setString(16, bean.getAcc_nm().trim()); 
			pstmt.setString(17, bean.getNote());
			pstmt.setString(18, bean.getOff_type());
          
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
			con = null;
        }

        return bean;
    }
}
