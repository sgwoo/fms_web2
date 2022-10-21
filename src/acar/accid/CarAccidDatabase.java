/**
 * 사고기록
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2002. 3. 4
 * @ last modify date : 
 */
package acar.accid;

import java.util.*;
import java.sql.*;
import acar.util.*;
import acar.common.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.UnknownDataException;
import acar.exception.DatabaseException;


public class CarAccidDatabase {

    private static CarAccidDatabase instance;
    private DBConnectionManager connMgr;   
    // Pool로 부터 Connection 객체를 가져올때 사용하는 Pool Name 
    private final String DATA_SOURCE = "acar"; 
 
    // 싱글톤 클래스로 구현 
    // 생성자를 private 로 선언
    public static synchronized CarAccidDatabase getInstance() throws DatabaseException {
        if (instance == null)
            instance = new CarAccidDatabase();
        return instance;
    }
    
    private CarAccidDatabase() throws DatabaseException {
        connMgr = DBConnectionManager.getInstance();
    }
    
    /**
     * 특정 레코드를 Bean에 저장하여 Bean을 리턴하는 메소드
     */
    /**
     * 자동차 등록 리스트 ( 2001/12/28 ) - Kim JungTae
     */
    private RentListBean makeRegListBean(ResultSet results) throws DatabaseException {

        try {
            RentListBean bean = new RentListBean();

		    bean.setRent_mng_id(results.getString("RENT_MNG_ID"));					//계약관리ID
		    bean.setRent_l_cd(results.getString("RENT_L_CD"));					//계약코드
		    bean.setRent_dt(results.getString("RENT_DT"));					//계약일자
		    bean.setDlv_dt(results.getString("DLV_DT"));					//출고일자
		    bean.setClient_id(results.getString("CLIENT_ID"));					//고객ID
		    bean.setClient_nm(results.getString("CLIENT_NM"));					//고객 대표자명
		    bean.setFirm_nm(results.getString("FIRM_NM"));						//상호
		    bean.setO_tel(results.getString("O_TEL"));						//사무실전화
		    bean.setFax(results.getString("FAX"));						//FAX
		    bean.setBr_id(results.getString("BR_ID"));						//
		    bean.setCar_mng_id(results.getString("CAR_MNG_ID"));					//자동차관리ID
		    bean.setInit_reg_dt(results.getString("INIT_REG_DT"));					//최초등록일
		    bean.setReg_gubun(results.getString("REG_GUBUN"));					//최초등록일
		    bean.setCar_no(results.getString("CAR_NO"));						//차량번호
		    bean.setCar_num(results.getString("CAR_NUM"));						//차대번호
		    bean.setRent_way(results.getString("RENT_WAY"));					//대여방식
		    bean.setCon_mon(results.getString("CON_MON"));						//대여개월
		    bean.setCar_id(results.getString("CAR_ID"));						//차명ID
		    bean.setImm_amt(results.getInt("IMM_AMT"));						//자차면책금
		    bean.setCar_name(results.getString("CAR_NAME"));					//차명
		    bean.setCar_nm(results.getString("CAR_NM"));
		    bean.setRent_start_dt(results.getString("RENT_START_DT"));				//대여개시일
		    bean.setRent_end_dt(results.getString("RENT_END_DT"));					//대여종료일
		    bean.setReg_ext_dt(results.getString("REG_EXT_DT"));					//등록예정일
		    bean.setRpt_no(results.getString("RPT_NO"));						//계출번호
		    bean.setCpt_cd(results.getString("CPT_CD"));						//은행코드
		    //bean.setBank_nm(results.getString("BANK_NM"));						//은행명
		    
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}
     /**
     * 서비스
     */
    
    private AccidentBean makeAccidentBean(ResultSet results, String gubun) throws DatabaseException {

        try {
            AccidentBean bean = new AccidentBean();

		    bean.setCar_mng_id(results.getString("CAR_MNG_ID")); 					//자동차관리번호
			bean.setAccid_id(results.getString("ACCID_ID"));
			bean.setRent_mng_id(results.getString("RENT_MNG_ID"));
			bean.setRent_l_cd(results.getString("RENT_L_CD"));
			bean.setCar_no(results.getString("CAR_NO"));
			bean.setFirm_nm(results.getString("FIRM_NM"));
			bean.setClient_nm(results.getString("CLIENT_NM"));
			bean.setAccid_st(results.getString("ACCID_ST"));
			bean.setOur_car_nm(results.getString("OUR_CAR_NM"));
			bean.setOur_driver(results.getString("OUR_DRIVER"));
			bean.setOur_tel(results.getString("OUR_TEL"));
			bean.setOur_m_tel(results.getString("OUR_M_TEL"));
			bean.setOur_ssn(results.getString("OUR_SSN"));
			bean.setOur_lic_kd(results.getString("OUR_LIC_KD"));
			bean.setOur_lic_no(results.getString("OUR_LIC_NO"));
			bean.setOur_ins(results.getString("OUR_INS"));
			bean.setOur_num(results.getString("OUR_NUM"));
			bean.setOur_post(results.getString("OUR_POST"));
			bean.setOur_addr(results.getString("OUR_ADDR"));
			bean.setAccid_dt(results.getString("ACCID_DT"));
			bean.setAccid_city(results.getString("ACCID_CITY"));
			bean.setAccid_gu(results.getString("ACCID_GU"));
			bean.setAccid_dong(results.getString("ACCID_DONG"));
			bean.setAccid_point(results.getString("ACCID_POINT"));
			bean.setAccid_cont(results.getString("ACCID_CONT"));
			bean.setOt_car_no(results.getString("OT_CAR_NO"));
			bean.setOt_car_nm(results.getString("OT_CAR_NM"));
			bean.setOt_driver(results.getString("OT_DRIVER"));
			bean.setOt_tel(results.getString("OT_TEL"));
			bean.setOt_m_tel(results.getString("OT_M_TEL"));
			bean.setOt_ins(results.getString("OT_INS"));
			bean.setOt_num(results.getString("OT_NUM"));
			bean.setOt_ins_nm(results.getString("OT_INS_NM"));
			bean.setOt_ins_tel(results.getString("OT_INS_TEL"));
			bean.setOt_ins_m_tel(results.getString("OT_INS_M_TEL"));
			bean.setOt_pol_sta(results.getString("OT_POL_STA"));
			bean.setOt_pol_nm(results.getString("OT_POL_NM"));
			bean.setOt_pol_tel(results.getString("OT_POL_TEL"));
			bean.setOt_pol_m_tel(results.getString("OT_POL_M_TEL"));
			bean.setHum_amt(results.getInt("HUM_AMT"));
			bean.setHum_nm(results.getString("HUM_NM"));
			bean.setHum_tel(results.getString("HUM_TEL"));
			bean.setMat_amt(results.getInt("MAT_AMT"));
			bean.setMat_nm(results.getString("MAT_NM"));
			bean.setMat_tel(results.getString("MAT_TEL"));
			bean.setOne_amt(results.getInt("ONE_AMT"));
			bean.setOne_nm(results.getString("ONE_NM"));
			bean.setOne_tel(results.getString("ONE_TEL"));
			bean.setMy_amt(results.getInt("MY_AMT"));
			bean.setMy_nm(results.getString("MY_NM"));
			bean.setMy_tel(results.getString("MY_TEL"));
			bean.setRef_dt(results.getString("REF_DT"));
			bean.setEx_tot_amt(results.getInt("EX_TOT_AMT"));
			bean.setTot_amt(results.getInt("TOT_AMT"));
			bean.setRec_amt(results.getInt("REC_AMT"));
			bean.setRec_dt(results.getString("REC_DT"));
			bean.setRec_plan_dt(results.getString("REC_PLAN_DT"));
			bean.setSup_amt(results.getInt("SUP_AMT"));
			bean.setSup_dt(results.getString("SUP_DT"));
			bean.setIns_sup_amt(results.getInt("INS_SUP_AMT"));
			bean.setIns_sup_dt(results.getString("INS_SUP_DT"));
			bean.setIns_tot_amt(results.getInt("INS_TOT_AMT"));
			bean.setOff_id(results.getString("OFF_ID"));
			bean.setOff_nm(results.getString("OFF_NM"));
			if(gubun.equals("c"))
			{
				bean.setServ_id(results.getString("SERV_ID"));
			}
			
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}
	/**
     * 자동차 등록 리스트 ( 2001/12/28 ) - Kim JungTae
     */
    private OneAccidBean makeOneAccidBean(ResultSet results) throws DatabaseException {

        try {
            OneAccidBean bean = new OneAccidBean();

		    bean.setCar_mng_id(results.getString("CAR_MNG_ID"));
			bean.setAccid_id(results.getString("ACCID_ID"));
			bean.setSeq_no(results.getInt("SEQ_NO"));
			bean.setNm(results.getString("NM"));
			bean.setSex(results.getString("SEX"));
			bean.setHosp(results.getString("HOSP"));
			bean.setHosp_tel(results.getString("HOSP_TEL"));
			bean.setIns_nm(results.getString("INS_NM"));
			bean.setIns_tel(results.getString("INS_TEL"));
			bean.setTel(results.getString("TEL"));
			bean.setAge(results.getString("AGE"));
			bean.setRelation(results.getString("RELATION"));
			bean.setDiagnosis(results.getString("DIAGNOSIS"));
			bean.setEtc(results.getString("ETC"));
		    
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}
	/**
     * 과태료 범칙금 등록시 계약 조회 ( 2002/1/10 ) - Kim JungTae
     */
    public RentListBean [] getCarRentListAll( String gubun, String rent_l_cd, String firm_nm, String car_no ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String subQuery = "";
        
        String query = "";
        
        query = "select a.rent_mng_id as RENT_MNG_ID, a.rent_l_cd as RENT_L_CD, decode(a.rent_dt,null,'',substr(a.rent_dt,1,4)||'-'||substr(a.rent_dt,5,2)||'-'||substr(a.rent_dt,7,2)) as RENT_DT, decode(a.dlv_dt,null,'',substr(a.dlv_dt,1,4)||'-'||substr(a.dlv_dt,5,2)||'-'||substr(a.dlv_dt,7,2)) as DLV_DT, a.client_id as CLIENT_ID,a.reg_id as REG_ID,\n" 
        + "c.client_nm as CLIENT_NM, c.firm_nm as FIRM_NM,c.o_tel as O_TEL,c.fax as FAX,e.br_id as BR_ID,\n" 
		+ "b.car_mng_id as CAR_MNG_ID, decode(b.init_reg_dt,null,'미등록',substr(b.init_reg_dt,1,4)||'-'||substr(b.init_reg_dt,5,2)||'-'||substr(b.init_reg_dt,7,2)) as INIT_REG_DT, decode(b.init_reg_dt,null,'id','ud') as REG_GUBUN, b.car_no as CAR_NO, b.car_num as CAR_NUM,\n"
		+ "d.rent_way as RENT_WAY,d.con_mon as CON_MON, decode(d.rent_start_dt,null,'',substr(d.rent_start_dt,1,4)||'-'||substr(d.rent_start_dt,5,2)||'-'||substr(d.rent_start_dt,7,2)) as RENT_START_DT, decode(d.rent_end_dt,null,'',substr(d.rent_end_dt,1,4)||'-'||substr(d.rent_end_dt,5,2)||'-'||substr(d.rent_end_dt,7,2)) as RENT_END_DT,\n"
		+ "g.car_id as CAR_ID, g.imm_amt as IMM_AMT, decode(f.reg_ext_dt,null,'',substr(f.reg_ext_dt,1,4)||'-'||substr(f.reg_ext_dt,5,2)||'-'||substr(f.reg_ext_dt,7,2)) as REG_EXT_DT, f.rpt_no as RPT_NO, h.car_name as CAR_NAME, j.car_nm as CAR_NM,\n"//
		+ "i.cpt_cd as CPT_CD\n"//,j.nm as BANK_NM
		+ "from cont a, car_reg b, client c, fee d, users e, car_pur f, car_etc g, allot i, car_nm h, car_mng j\n"//--, code j
		+ "where a.rent_mng_id like '%'\n"
		+ "and a.rent_l_cd like upper('%" + rent_l_cd + "%') and nvl(a.use_yn,'Y')='Y'\n"
		+ "and a.car_mng_id = b.car_mng_id and ( b.car_no like '%" + car_no + "%' or b.first_car_no like '%" + car_no + "%')\n"
		+ "and a.client_id = c.client_id and c.firm_nm like '%" + firm_nm + "%'\n"
		+ "and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd\n"
		+ "and a.bus_id = e.user_id\n"
		+ "and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_mng_id = g.rent_mng_id and a.rent_l_cd = g.rent_l_cd\n"
		+ "and g.car_id = h.car_id(+) and h.car_cd=j.code(+)\n"
		+ "and a.rent_mng_id = i.rent_mng_id and a.rent_l_cd = i.rent_l_cd\n";
		//+ "and j.c_st = '0003'\n"
		//+ "and j.code <> '0000'\n"
		//+ "and i.cpt_cd = j.code(+)\n"
        Collection<RentListBean> col = new ArrayList<RentListBean>();
        try{
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery(query);

            while(rs.next()){
                
				col.add(makeRegListBean(rs));
 
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
        return (RentListBean[])col.toArray(new RentListBean[0]);
    }
    /**
     * 사고기록 개별조회
     */
    public AccidentBean getAccidentBean(String car_mng_id, String accid_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        AccidentBean ab;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = "select a.car_mng_id CAR_MNG_ID, a.accid_id ACCID_ID, a.rent_mng_id RENT_MNG_ID, a.rent_l_cd RENT_L_CD, a.accid_st ACCID_ST, a.our_car_nm OUR_CAR_NM, a.our_driver OUR_DRIVER, a.our_tel OUR_TEL, a.our_m_tel OUR_M_TEL, a.our_ssn OUR_SSN, a.our_lic_kd OUR_LIC_KD, a.our_lic_no OUR_LIC_NO, a.our_ins OUR_INS, a.our_num OUR_NUM, a.our_post OUR_POST, a.our_addr OUR_ADDR, a.accid_dt ACCID_DT, a.accid_city ACCID_CITY, a.accid_gu ACCID_GU, a.accid_dong ACCID_DONG, a.accid_point ACCID_POINT, a.accid_cont ACCID_CONT, a.ot_car_no OT_CAR_NO, a.ot_car_nm OT_CAR_NM, a.ot_driver OT_DRIVER, a.ot_tel OT_TEL, a.ot_m_tel OT_M_TEL, a.ot_ins OT_INS, a.ot_num OT_NUM, a.ot_ins_nm OT_INS_NM, a.ot_ins_tel OT_INS_TEL, a.ot_ins_m_tel OT_INS_M_TEL, a.ot_pol_sta OT_POL_STA, a.ot_pol_nm OT_POL_NM, a.ot_pol_tel OT_POL_TEL, a.ot_pol_m_tel OT_POL_M_TEL, a.hum_amt HUM_AMT, a.hum_nm HUM_NM, a.hum_tel HUM_TEL, a.mat_amt MAT_AMT, a.mat_nm MAT_NM, a.mat_tel MAT_TEL, a.one_amt ONE_AMT, a.one_nm ONE_NM, a.one_tel ONE_TEL, a.my_amt MY_AMT, a.my_nm MY_NM, a.my_tel MY_TEL, a.ref_dt REF_DT, a.ex_tot_amt EX_TOT_AMT, a.tot_amt TOT_AMT, a.rec_amt REC_AMT, a.rec_dt REC_DT, a.rec_plan_dt REC_PLAN_DT, a.sup_amt SUP_AMT, a.sup_dt SUP_DT, a.ins_sup_amt INS_SUP_AMT, a.ins_sup_dt INS_SUP_DT, a.ins_tot_amt INS_TOT_AMT,\n" 
				+ "c.car_no CAR_NO, d.client_nm CLIENT_NM, d.firm_nm FIRM_NM, e.off_id OFF_ID, f.off_nm OFF_NM, g.serv_id SERV_ID\n"
				+ "from accident a, cont b, car_reg c, client d, cust_serv e, serv_off f, service g\n"
				+ "where a.car_mng_id=? and a.accid_id=? and a.car_mng_id=c.car_mng_id\n"
				+ "and a.rent_mng_id=b.rent_mng_id\n"
				+ "and a.rent_l_cd=b.rent_l_cd\n"
				+ "and b.client_id=d.client_id and a.car_mng_id=e.car_mng_id(+) and e.off_id=f.off_id(+) and a.car_mng_id=g.car_mng_id\n";

        
        try{
            pstmt = con.prepareStatement(query);
    		pstmt.setString(1, car_mng_id.trim());
    		pstmt.setString(2, accid_id.trim());
    		rs = pstmt.executeQuery();

            if (rs.next())
                ab = makeAccidentBean(rs,"c");
            else
                throw new UnknownDataException("Could not find Appcode # " + accid_id );
            
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
        return ab;
    }
    /**
     * 사고기록 전체조회
     */
    public AccidentBean [] getAccidentAll(String gubun, String gubun_nm) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        String subQuery = "";
        
        if(gubun.equals("car_no"))
        {
        	subQuery = "and c.car_no like '%" + gubun_nm +"%'\n";
        	
        }else if(gubun.equals("firm_nm")){
        	subQuery = "and d.firm_nm like '%" + gubun_nm +"%'\n";
        
    	}else if(gubun.equals("rent_l_cd")){
    		subQuery = "and b.rent_l_cd like '%" + gubun_nm +"%'\n";
    	}else{
    		subQuery = "and a.car_mng_id=''\n";
    	}
        
        query = "select a.car_mng_id CAR_MNG_ID, a.accid_id ACCID_ID, a.rent_mng_id RENT_MNG_ID, a.rent_l_cd RENT_L_CD, a.accid_st ACCID_ST, a.our_car_nm OUR_CAR_NM, a.our_driver OUR_DRIVER, a.our_tel OUR_TEL, a.our_m_tel OUR_M_TEL, a.our_ssn OUR_SSN, a.our_lic_kd OUR_LIC_KD, a.our_lic_no OUR_LIC_NO, a.our_ins OUR_INS, a.our_num OUR_NUM, a.our_post OUR_POST, a.our_addr OUR_ADDR, nvl2(a.accid_dt,substr(a.accid_dt,1,4)||'-'||substr(a.accid_dt,5,2)||'-'||substr(a.accid_dt,7,2)||' '||substr(a.accid_dt,9,2)||':'||substr(a.accid_dt,11,2),'') as ACCID_DT, a.accid_city ACCID_CITY, a.accid_gu ACCID_GU, a.accid_dong ACCID_DONG, a.accid_point ACCID_POINT, a.accid_cont ACCID_CONT, a.ot_car_no OT_CAR_NO, a.ot_car_nm OT_CAR_NM, a.ot_driver OT_DRIVER, a.ot_tel OT_TEL, a.ot_m_tel OT_M_TEL, a.ot_ins OT_INS, a.ot_num OT_NUM, a.ot_ins_nm OT_INS_NM, a.ot_ins_tel OT_INS_TEL, a.ot_ins_m_tel OT_INS_M_TEL, a.ot_pol_sta OT_POL_STA, a.ot_pol_nm OT_POL_NM, a.ot_pol_tel OT_POL_TEL, a.ot_pol_m_tel OT_POL_M_TEL, a.hum_amt HUM_AMT, a.hum_nm HUM_NM, a.hum_tel HUM_TEL, a.mat_amt MAT_AMT, a.mat_nm MAT_NM, a.mat_tel MAT_TEL, a.one_amt ONE_AMT, a.one_nm ONE_NM, a.one_tel ONE_TEL, a.my_amt MY_AMT, a.my_nm MY_NM, a.my_tel MY_TEL, a.ref_dt REF_DT, a.ex_tot_amt EX_TOT_AMT, a.tot_amt TOT_AMT, a.rec_amt REC_AMT, a.rec_dt REC_DT, a.rec_plan_dt REC_PLAN_DT, a.sup_amt SUP_AMT, a.sup_dt SUP_DT, a.ins_sup_amt INS_SUP_AMT, a.ins_sup_dt INS_SUP_DT, a.ins_tot_amt INS_TOT_AMT,\n" 
				+ "c.car_no CAR_NO, d.client_nm CLIENT_NM, d.firm_nm FIRM_NM, e.off_id OFF_ID, f.off_nm OFF_NM\n"
				+ "from accident a, cont b, car_reg c, client d, cust_serv e, serv_off f\n"
				+ "where a.car_mng_id=c.car_mng_id\n"
				+ "and a.rent_mng_id=b.rent_mng_id\n"
				+ "and a.rent_l_cd=b.rent_l_cd\n"
				+ subQuery
				+ "and b.client_id=d.client_id and a.car_mng_id=e.car_mng_id(+) and e.off_id=f.off_id(+)\n";
		
        Collection<AccidentBean> col = new ArrayList<AccidentBean>();
        try{
            pstmt = con.prepareStatement(query);
    		//pstmt.setString(1, car_mng_id.trim());
    		
    		rs = pstmt.executeQuery();

            while(rs.next()){
                
				col.add(makeAccidentBean(rs,"l"));
 
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
        return (AccidentBean[])col.toArray(new AccidentBean[0]);
    }
    /**
     * 자손 조회
     */
    public OneAccidBean [] getOneAccid(String car_mng_id, String accid_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = "select a.car_mng_id CAR_MNG_ID, a.accid_id ACCID_ID, a.seq_no SEQ_NO, a.nm NM, a.sex SEX, a.hosp HOSP, a.hosp_tel HOSP_TEL, a.ins_nm INS_NM, a.ins_tel INS_TEL, a.tel TEL, a.age AGE, a.relation RELATION, a.diagnosis DIAGNOSIS, a.etc ETC\n" 
				//+ "c.car_no CAR_NO, d.client_nm CLIENT_NM, d.firm_nm FIRM_NM\n"
				+ "from one_accid a\n"
				+ "where a.car_mng_id=? and a.accid_id=?\n";

        Collection<OneAccidBean> col = new ArrayList<OneAccidBean>();
        try{
            pstmt = con.prepareStatement(query);
    		pstmt.setString(1, car_mng_id.trim());
    		pstmt.setString(2, accid_id.trim());
    		
    		rs = pstmt.executeQuery();

            while(rs.next()){
                
				col.add(makeOneAccidBean(rs));
 
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
        return (OneAccidBean[])col.toArray(new OneAccidBean[0]);
    }
	/**
     * 사고기록 등록.
     */
    public String insertAccident(AccidentBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        PreparedStatement pstmt1 = null;
        ResultSet rs = null;
        String query = "";
        String query1 = "";
        String accid_id = "";
        int count = 0;
                
        query="INSERT INTO ACCIDENT(CAR_MNG_ID, ACCID_ID, RENT_MNG_ID, RENT_L_CD, ACCID_ST, OUR_CAR_NM, OUR_DRIVER, OUR_TEL, OUR_M_TEL, OUR_SSN, OUR_LIC_KD, OUR_LIC_NO, OUR_INS, OUR_NUM, OUR_POST, OUR_ADDR, ACCID_DT, ACCID_CITY, ACCID_GU, ACCID_DONG, ACCID_POINT, ACCID_CONT, OT_CAR_NO, OT_CAR_NM, OT_DRIVER, OT_TEL, OT_M_TEL, OT_INS, OT_NUM, OT_INS_NM, OT_INS_TEL, OT_INS_M_TEL, OT_POL_STA, OT_POL_NM, OT_POL_TEL, OT_POL_M_TEL, HUM_AMT, HUM_NM, HUM_TEL, MAT_AMT, MAT_NM, MAT_TEL, ONE_AMT, ONE_NM, ONE_TEL, MY_AMT, MY_NM, MY_TEL, REF_DT, EX_TOT_AMT, TOT_AMT, REC_AMT, REC_DT, REC_PLAN_DT, SUP_AMT, SUP_DT, INS_SUP_AMT, INS_SUP_DT, INS_TOT_AMT)\n"
            + "values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, replace(?,'-',''), ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)\n";
        query1="select nvl(lpad(max(ACCID_ID)+1,6,'0'),'000001') from accident";
    
       try{
            con.setAutoCommit(false);
            pstmt1 = con.prepareStatement(query1);
			rs = pstmt1.executeQuery();
            if(rs.next()){
				accid_id = rs.getString(1);
            }
            rs.close();
            pstmt1.close();
			
            pstmt = con.prepareStatement(query);

            pstmt.setString(1, bean.getCar_mng_id().trim());
			pstmt.setString(2, accid_id.trim());
			pstmt.setString(3, bean.getRent_mng_id().trim());
			pstmt.setString(4, bean.getRent_l_cd().trim());
			
			pstmt.setString(5, bean.getAccid_st().trim());
			pstmt.setString(6, bean.getOur_car_nm().trim());
			pstmt.setString(7, bean.getOur_driver().trim());
			pstmt.setString(8, bean.getOur_tel().trim());
			pstmt.setString(9, bean.getOur_m_tel().trim());
			pstmt.setString(10, bean.getOur_ssn().trim());
			pstmt.setString(11, bean.getOur_lic_kd().trim());
			pstmt.setString(12, bean.getOur_lic_no().trim());
			pstmt.setString(13, bean.getOur_ins().trim());
			pstmt.setString(14, bean.getOur_num().trim());
			pstmt.setString(15, bean.getOur_post().trim());
			pstmt.setString(16, bean.getOur_addr().trim());
			pstmt.setString(17, bean.getAccid_dt().trim());
			pstmt.setString(18, bean.getAccid_city().trim());
			pstmt.setString(19, bean.getAccid_gu().trim());
			pstmt.setString(20, bean.getAccid_dong().trim());
			pstmt.setString(21, bean.getAccid_point().trim());
			pstmt.setString(22, bean.getAccid_cont().trim());
			pstmt.setString(23, bean.getOt_car_no().trim());
			pstmt.setString(24, bean.getOt_car_nm().trim());
			pstmt.setString(25, bean.getOt_driver().trim());
			pstmt.setString(26, bean.getOt_tel().trim());
			pstmt.setString(27, bean.getOt_m_tel().trim());
			pstmt.setString(28, bean.getOt_ins().trim());
			pstmt.setString(29, bean.getOt_num().trim());
			pstmt.setString(30, bean.getOt_ins_nm().trim());
			pstmt.setString(31, bean.getOt_ins_tel().trim());
			pstmt.setString(32, bean.getOt_ins_m_tel().trim());
			pstmt.setString(33, bean.getOt_pol_sta().trim());
			pstmt.setString(34, bean.getOt_pol_nm().trim());
			pstmt.setString(35, bean.getOt_pol_tel().trim());
			pstmt.setString(36, bean.getOt_pol_m_tel().trim());
			pstmt.setInt(37, bean.getHum_amt());
			pstmt.setString(38, bean.getHum_nm().trim());
			pstmt.setString(39, bean.getHum_tel().trim());
			pstmt.setInt(40, bean.getMat_amt());
			pstmt.setString(41, bean.getMat_nm().trim());
			pstmt.setString(42, bean.getMat_tel().trim());
			pstmt.setInt(43, bean.getOne_amt());
			pstmt.setString(44, bean.getOne_nm().trim());
			pstmt.setString(45, bean.getOne_tel().trim());
			pstmt.setInt(46, bean.getMy_amt());
			pstmt.setString(47, bean.getMy_nm().trim());
			pstmt.setString(48, bean.getMy_tel().trim());
			pstmt.setString(49, bean.getRef_dt().trim());
			pstmt.setString(50, bean.getRec_plan_dt().trim());
			pstmt.setInt(51, bean.getEx_tot_amt());
			pstmt.setInt(52, bean.getTot_amt());
			pstmt.setInt(53, bean.getRec_amt());
			pstmt.setString(54, bean.getRec_dt().trim());
			pstmt.setInt(55, bean.getSup_amt());
			pstmt.setString(56, bean.getSup_dt().trim());
			pstmt.setInt(57, bean.getIns_sup_amt());
			pstmt.setString(58, bean.getIns_sup_dt().trim());
			pstmt.setInt(59, bean.getIns_tot_amt());
           
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
                if(pstmt1 != null) pstmt1.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
        }

        return accid_id;
    }
    
    /**
     * 자손 등록.
     */
    public int insertOneAccid(OneAccidBean bean) throws DatabaseException, DataSourceEmptyException{
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
                
        query="INSERT INTO ONE_ACCID(CAR_MNG_ID, ACCID_ID, SEQ_NO, NM, SEX, HOSP, HOSP_TEL, INS_NM, INS_TEL, TEL, AGE, RELATION, DIAGNOSIS, ETC)\n"
            + "values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)\n";
        query1="select nvl(max(seq_no)+1,1) from one_accid where car_mng_id=? and accid_id=?";
    
       try{
            con.setAutoCommit(false);
            pstmt1 = con.prepareStatement(query1);
            pstmt1.setString(1, bean.getCar_mng_id().trim());
            pstmt1.setString(2, bean.getAccid_id().trim());
			rs = pstmt1.executeQuery();
            if(rs.next()){
				seq_no = rs.getInt(1);
            }
            rs.close();
            pstmt1.close();

            pstmt = con.prepareStatement(query);
            pstmt.setString(1, bean.getCar_mng_id().trim());
			pstmt.setString(2, bean.getAccid_id().trim());
			pstmt.setInt(3, seq_no);
			pstmt.setString(4, bean.getNm().trim());
			pstmt.setString(5, bean.getSex().trim());
			pstmt.setString(6, bean.getHosp().trim());
			pstmt.setString(7, bean.getHosp_tel().trim());
			pstmt.setString(8, bean.getIns_nm().trim());
			pstmt.setString(9, bean.getIns_tel().trim());
			pstmt.setString(10, bean.getTel().trim());
			pstmt.setString(11, bean.getAge().trim());
			pstmt.setString(12, bean.getRelation().trim());
			pstmt.setString(13, bean.getDiagnosis().trim());
			pstmt.setString(14, bean.getEtc().trim());           
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
                if(pstmt1 != null) pstmt1.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
        }

        return count;
    }
    
    /**
     * 사고기록 수정.
     */
    public int updateAccident(AccidentBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query="update ACCIDENT set RENT_MNG_ID=?, RENT_L_CD=?, ACCID_ST=?, OUR_CAR_NM=?, OUR_DRIVER=?, OUR_TEL=?, OUR_M_TEL=?, OUR_SSN=?, OUR_LIC_KD=?, OUR_LIC_NO=?, OUR_INS=?, OUR_NUM=?, OUR_POST=?, OUR_ADDR=?, ACCID_DT=replace(?,'-',''), ACCID_CITY=?, ACCID_GU=?, ACCID_DONG=?, ACCID_POINT=?, ACCID_CONT=?, OT_CAR_NO=?, OT_CAR_NM=?, OT_DRIVER=?, OT_TEL=?, OT_M_TEL=?, OT_INS=?, OT_NUM=?, OT_INS_NM=?, OT_INS_TEL=?, OT_INS_M_TEL=?, OT_POL_STA=?, OT_POL_NM=?, OT_POL_TEL=?, OT_POL_M_TEL=?, HUM_AMT=?, HUM_NM=?, HUM_TEL=?, MAT_AMT=?, MAT_NM=?, MAT_TEL=?, ONE_AMT=?, ONE_NM=?, ONE_TEL=?, MY_AMT=?, MY_NM=?, MY_TEL=?, REF_DT=replace(?,'-',''), EX_TOT_AMT=?, TOT_AMT=?, REC_AMT=?, REC_DT=replace(?,'-',''), REC_PLAN_DT=replace(?,'-',''), SUP_AMT=?, SUP_DT=replace(?,'-',''), INS_SUP_AMT=?, INS_SUP_DT=replace(?,'-',''), INS_TOT_AMT=?\n"
            + "where car_mng_id=? and accid_id=?\n";

    
       try{
            con.setAutoCommit(false);
            			
            pstmt = con.prepareStatement(query);            
			pstmt.setString(1, bean.getRent_mng_id().trim());
			pstmt.setString(2, bean.getRent_l_cd().trim());
			pstmt.setString(3, bean.getAccid_st().trim());
			pstmt.setString(4, bean.getOur_car_nm().trim());
			pstmt.setString(5, bean.getOur_driver().trim());
			pstmt.setString(6, bean.getOur_tel().trim());
			pstmt.setString(7, bean.getOur_m_tel().trim());
			pstmt.setString(8, bean.getOur_ssn().trim());
			pstmt.setString(9, bean.getOur_lic_kd().trim());
			pstmt.setString(10, bean.getOur_lic_no().trim());
			pstmt.setString(11, bean.getOur_ins().trim());
			pstmt.setString(12, bean.getOur_num().trim());
			pstmt.setString(13, bean.getOur_post().trim());
			pstmt.setString(14, bean.getOur_addr().trim());
			pstmt.setString(15, bean.getAccid_dt().trim());
			pstmt.setString(16, bean.getAccid_city().trim());
			pstmt.setString(17, bean.getAccid_gu().trim());
			pstmt.setString(18, bean.getAccid_dong().trim());
			pstmt.setString(19, bean.getAccid_point().trim());
			pstmt.setString(20, bean.getAccid_cont().trim());
			pstmt.setString(21, bean.getOt_car_no().trim());
			pstmt.setString(22, bean.getOt_car_nm().trim());
			pstmt.setString(23, bean.getOt_driver().trim());
			pstmt.setString(24, bean.getOt_tel().trim());
			pstmt.setString(25, bean.getOt_m_tel().trim());
			pstmt.setString(26, bean.getOt_ins().trim());
			pstmt.setString(27, bean.getOt_num().trim());
			pstmt.setString(28, bean.getOt_ins_nm().trim());
			pstmt.setString(29, bean.getOt_ins_tel().trim());
			pstmt.setString(30, bean.getOt_ins_m_tel().trim());
			pstmt.setString(31, bean.getOt_pol_sta().trim());
			pstmt.setString(32, bean.getOt_pol_nm().trim());
			pstmt.setString(33, bean.getOt_pol_tel().trim());
			pstmt.setString(34, bean.getOt_pol_m_tel().trim());
			pstmt.setInt(35, bean.getHum_amt());
			pstmt.setString(36, bean.getHum_nm().trim());
			pstmt.setString(37, bean.getHum_tel().trim());
			pstmt.setInt(38, bean.getMat_amt());
			pstmt.setString(39, bean.getMat_nm().trim());
			pstmt.setString(40, bean.getMat_tel().trim());
			pstmt.setInt(41, bean.getOne_amt());
			pstmt.setString(42, bean.getOne_nm().trim());
			pstmt.setString(43, bean.getOne_tel().trim());
			pstmt.setInt(44, bean.getMy_amt());
			pstmt.setString(45, bean.getMy_nm().trim());
			pstmt.setString(46, bean.getMy_tel().trim());
			pstmt.setString(47, bean.getRef_dt().trim());
			pstmt.setInt(48, bean.getEx_tot_amt());
			pstmt.setInt(49, bean.getTot_amt());
			pstmt.setInt(50, bean.getRec_amt());
			pstmt.setString(51, bean.getRec_dt().trim());
			pstmt.setString(52, bean.getRec_plan_dt().trim());
			pstmt.setInt(53, bean.getSup_amt());
			pstmt.setString(54, bean.getSup_dt().trim());
			pstmt.setInt(55, bean.getIns_sup_amt());
			pstmt.setString(56, bean.getIns_sup_dt().trim());
			pstmt.setInt(57, bean.getIns_tot_amt());
          	pstmt.setString(58, bean.getCar_mng_id().trim());
			pstmt.setString(59, bean.getAccid_id().trim());
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
        }

        return count;
    }
    /**
     * 자차보험처리내역 수정.
     */
    public int updateAccidHist(AccidentBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query="update ACCIDENT set REC_AMT=?, REC_DT=replace(?,'-',''), REC_PLAN_DT=replace(?,'-',''), SUP_AMT=?, SUP_DT=replace(?,'-',''), INS_SUP_AMT=?, INS_SUP_DT=replace(?,'-',''), INS_TOT_AMT=?\n"
            + "where car_mng_id=? and accid_id=?\n";

    
       try{
            con.setAutoCommit(false);
            			
            pstmt = con.prepareStatement(query);

			pstmt.setInt(1, bean.getRec_amt());
			pstmt.setString(2, bean.getRec_dt().trim());
			pstmt.setString(3, bean.getRec_plan_dt().trim());
			pstmt.setInt(4, bean.getSup_amt());
			pstmt.setString(5, bean.getSup_dt().trim());
			pstmt.setInt(6, bean.getIns_sup_amt());
			pstmt.setString(7, bean.getIns_sup_dt().trim());
			pstmt.setInt(8, bean.getIns_tot_amt());
          	pstmt.setString(9, bean.getCar_mng_id().trim());
			pstmt.setString(10, bean.getAccid_id().trim());
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
        }

        return count;
    }
    /**
     * 사고기록 수정.
     */
    public int updateAccidIns(AccidentBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query="update ACCIDENT set HUM_AMT=?, HUM_NM=?, HUM_TEL=?, MAT_AMT=?, MAT_NM=?, MAT_TEL=?, ONE_AMT=?, ONE_NM=?, ONE_TEL=?, MY_AMT=?, MY_NM=?, MY_TEL=?, REF_DT=?, EX_TOT_AMT=?, TOT_AMT=?\n"
            + "where car_mng_id=? and accid_id=?\n";

    
       try{
            con.setAutoCommit(false);
            			
            pstmt = con.prepareStatement(query);
			
			pstmt.setInt(1, bean.getHum_amt());
			pstmt.setString(2, bean.getHum_nm().trim());
			pstmt.setString(3, bean.getHum_tel().trim());
			pstmt.setInt(4, bean.getMat_amt());
			pstmt.setString(5, bean.getMat_nm().trim());
			pstmt.setString(6, bean.getMat_tel().trim());
			pstmt.setInt(7, bean.getOne_amt());
			pstmt.setString(8, bean.getOne_nm().trim());
			pstmt.setString(9, bean.getOne_tel().trim());
			pstmt.setInt(10, bean.getMy_amt());
			pstmt.setString(11, bean.getMy_nm().trim());
			pstmt.setString(12, bean.getMy_tel().trim());
			pstmt.setString(13, bean.getRef_dt().trim());
			pstmt.setInt(14, bean.getEx_tot_amt());
			pstmt.setInt(15, bean.getTot_amt());
			pstmt.setString(16, bean.getCar_mng_id().trim());
			pstmt.setString(17, bean.getAccid_id().trim());
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
        }

        return count;
    }
    /**
     * 자손 수정.
     */
    public int updateOneAccid(OneAccidBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query="update one_accid set NM=?, SEX=?, HOSP=?, HOSP_TEL=?, INS_NM=?, INS_TEL=?, TEL=?, AGE=?, RELATION=?, DIAGNOSIS=?, ETC=?\n"
            + "where car_mng_id=? and accid_id=? ans seq_no=?\n";

    
       try{
            con.setAutoCommit(false);
            			
            pstmt = con.prepareStatement(query);            			
			pstmt.setString(1, bean.getNm().trim());
			pstmt.setString(2, bean.getSex().trim());
			pstmt.setString(3, bean.getHosp().trim());
			pstmt.setString(4, bean.getHosp_tel().trim());
			pstmt.setString(5, bean.getIns_nm().trim());
			pstmt.setString(6, bean.getIns_tel().trim());
			pstmt.setString(7, bean.getTel().trim());
			pstmt.setString(8, bean.getAge().trim());
			pstmt.setString(9, bean.getRelation().trim());
			pstmt.setString(10, bean.getDiagnosis().trim());
			pstmt.setString(11, bean.getEtc().trim());
			pstmt.setString(12, bean.getCar_mng_id().trim());
			pstmt.setString(13, bean.getAccid_id().trim());
			pstmt.setInt(14, bean.getSeq_no());
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
        }

        return count;
    }
    
}
