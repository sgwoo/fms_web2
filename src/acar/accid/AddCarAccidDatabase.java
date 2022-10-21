package acar.accid;

import java.util.*;
import java.sql.*;
import acar.util.*;
import acar.common.*;
import acar.con_ins_m.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.UnknownDataException;
import acar.exception.DatabaseException;


public class AddCarAccidDatabase{

    private static AddCarAccidDatabase instance;
    private DBConnectionManager connMgr;   
    private final String DATA_SOURCE = "acar"; 
 
    public static synchronized AddCarAccidDatabase getInstance() throws DatabaseException {
        if (instance == null)
            instance = new AddCarAccidDatabase();
        return instance;
    }
    
    private AddCarAccidDatabase() throws DatabaseException {
        connMgr = DBConnectionManager.getInstance();
    }


	// BEAN -------------------------------------------------------------------------------------------------

	/**
    * 사고기록 리스트 bean : car_accid_s_sc_in.jsp
    */    
    private AccidentBean makeAccidentListBean(ResultSet results) throws DatabaseException {
        try {
            AccidentBean bean = new AccidentBean();
		    bean.setCar_mng_id(results.getString("CAR_MNG_ID")); 					
			bean.setAccid_id(results.getString("ACCID_ID"));
			bean.setRent_mng_id(results.getString("RENT_MNG_ID"));
			bean.setRent_l_cd(results.getString("RENT_L_CD"));
			bean.setCar_no(results.getString("CAR_NO"));
			bean.setFirm_nm(results.getString("FIRM_NM"));
			bean.setClient_nm(results.getString("CLIENT_NM"));
			bean.setAccid_dt(results.getString("ACCID_DT"));			
			bean.setAccid_st(results.getString("ACCID_ST"));			
			bean.setOur_fault_per(results.getInt("OUR_FAULT_PER"));			

            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}

	/**
    * 차량별 사고기록 리스트 bean : car_accid_list.jsp
    */    
    private AccidentBean makeCarAccidListBean(ResultSet results) throws DatabaseException {
        try {
            AccidentBean bean = new AccidentBean();
			bean.setRent_mng_id(results.getString("RENT_MNG_ID"));
			bean.setRent_l_cd(results.getString("RENT_L_CD"));
			bean.setFirm_nm(results.getString("FIRM_NM"));
			bean.setClient_nm(results.getString("CLIENT_NM"));
			bean.setCar_no(results.getString("CAR_NO"));
			bean.setCar_mng_id(results.getString("CAR_MNG_ID")); 					
			bean.setAccid_id(results.getString("ACCID_ID"));
			bean.setAccid_st(results.getString("ACCID_ST"));			
			bean.setOur_driver(results.getString("OUR_DRIVER"));
			bean.setAccid_dt(results.getString("ACCID_DT"));
			bean.setAccid_addr(results.getString("ACCID_ADDR"));
			bean.setAccid_cont(results.getString("ACCID_CONT"));
			bean.setAccid_cont2(results.getString("ACCID_CONT2"));			
			bean.setSub_rent_gu(results.getString("SUB_RENT_GU"));			
			bean.setSub_firm_nm(results.getString("SUB_FIRM_NM"));			
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}

	/**
    * 차량별 사고기록 건별 bean : sub_cont.jsp
    */    
    private AccidentBean makeAccidentBeanCase(ResultSet results) throws DatabaseException {
        try {
            AccidentBean bean = new AccidentBean();
			bean.setAccid_st(results.getString("ACCID_ST"));			
			bean.setOur_driver(results.getString("OUR_DRIVER"));
			bean.setAccid_dt(results.getString("ACCID_DT"));
			bean.setAccid_addr(results.getString("ACCID_ADDR"));
			bean.setAccid_cont(results.getString("ACCID_CONT"));
			bean.setAccid_cont2(results.getString("ACCID_CONT2"));			
			bean.setSub_rent_gu(results.getString("SUB_RENT_GU"));			
			bean.setSub_firm_nm(results.getString("SUB_FIRM_NM"));			
			bean.setOur_fault_per(results.getInt("OUR_FAULT_PER"));			
			bean.setOt_pol_st(results.getString("OT_POL_ST"));			
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}

	/**
    * 사고기록 리스트 bean : car_accid_all_i.jsp
    */    
    private AccidentBean makeConeListBean(ResultSet results) throws DatabaseException {
        try {
            AccidentBean bean = new AccidentBean();
			bean.setRent_mng_id(results.getString("RENT_MNG_ID"));
			bean.setRent_l_cd(results.getString("RENT_L_CD"));
			bean.setCar_mng_id(results.getString("CAR_MNG_ID"));
			bean.setCar_no(results.getString("CAR_NO"));
			bean.setFirm_nm(results.getString("FIRM_NM"));
			bean.setClient_nm(results.getString("CLIENT_NM"));
			bean.setOur_car_nm(results.getString("CAR_NM"));			
			bean.setOur_car_name(results.getString("CAR_NAME"));						
			bean.setCls_st(results.getString("CLS_ST"));			
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}

	/**
    * 사고기록 bean : 원본
    */    
    private AccidentBean makeAccidentBean(ResultSet results, String gubun) throws DatabaseException {
        try {
            AccidentBean bean = new AccidentBean();
		    bean.setCar_mng_id(results.getString("CAR_MNG_ID")); 					
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
    * 사고기록 bean : 추가 필드 포함
    */    
    private AccidentBean makeAccidentBean2(ResultSet results) throws DatabaseException {
        try {
            AccidentBean bean = new AccidentBean();

		    bean.setCar_mng_id(results.getString("CAR_MNG_ID")); 					//자동차관리번호
			bean.setAccid_id(results.getString("ACCID_ID"));
			bean.setRent_mng_id(results.getString("RENT_MNG_ID"));
			bean.setRent_l_cd(results.getString("RENT_L_CD"));
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
			bean.setSub_rent_gu(results.getString("SUB_RENT_GU"));
			bean.setSub_firm_nm(results.getString("SUB_FIRM_NM"));
			bean.setSub_rent_st(results.getString("SUB_RENT_ST"));
			bean.setSub_rent_et(results.getString("SUB_RENT_ET"));
			bean.setSub_etc(results.getString("SUB_ETC"));
			bean.setReg_dt(results.getString("REG_DT"));
			bean.setReg_id(results.getString("REG_ID"));
			bean.setUpdate_dt(results.getString("UPDATE_DT"));
			bean.setUpdate_id(results.getString("UPDATE_ID"));
			bean.setOur_lic_dt(results.getString("OUR_LIC_DT"));
			bean.setOur_tel2(results.getString("OUR_TEL2"));
			bean.setOt_ssn(results.getString("OT_SSN"));
			bean.setOt_lic_kd(results.getString("OT_LIC_KD"));
			bean.setOt_lic_no(results.getString("OT_LIC_NO"));
			bean.setOt_tel2(results.getString("OT_TEL2"));
			bean.setOur_dam_st(results.getString("OUR_DAM_ST"));
			bean.setOt_dam_st(results.getString("OT_DAM_ST"));
			bean.setAccid_addr(results.getString("ACCID_ADDR"));
			bean.setAccid_cont2(results.getString("ACCID_CONT2"));
			bean.setImp_fault_st(results.getString("IMP_FAULT_ST"));
			bean.setImp_fault_sub(results.getString("IMP_FAULT_SUB"));
			bean.setOur_fault_per(results.getInt("OUR_FAULT_PER"));
			bean.setOt_pol_st(results.getString("OT_POL_ST"));
			bean.setOt_pol_num(results.getString("OT_POL_NUM"));
			bean.setOt_pol_fax(results.getString("OT_POL_FAX"));
			bean.setR_site(results.getString("R_SITE"));
			bean.setMemo(results.getString("MEMO"));
			//추가20040225
			bean.setCar_in_dt(results.getString("CAR_IN_DT"));
			bean.setCar_out_dt(results.getString("CAR_OUT_DT"));
			bean.setIns_end_dt(results.getString("INS_END_DT"));

		
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}

	/**
    * 사고기록 bean : 추가 필드 포함 (보험청구내역까지 포함)
    */    
    private AccidentBean makeAccidentBeanAll(ResultSet results, String gubun) throws DatabaseException {
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
			bean.setSub_rent_gu(results.getString("SUB_RENT_GU"));
			bean.setSub_firm_nm(results.getString("SUB_FIRM_NM"));
			bean.setSub_rent_st(results.getString("SUB_RENT_ST"));
			bean.setSub_rent_et(results.getString("SUB_RENT_ET"));
			bean.setSub_etc(results.getString("SUB_ETC"));
			bean.setReg_dt(results.getString("REG_DT"));
			bean.setReg_id(results.getString("REG_ID"));
			bean.setUpdate_dt(results.getString("UPDATE_DT"));
			bean.setUpdate_id(results.getString("UPDATE_ID"));
			bean.setOur_lic_dt(results.getString("OUR_LIC_DT"));
			bean.setOur_tel2(results.getString("OUR_TEL2"));
			bean.setOt_ssn(results.getString("OT_SSN"));
			bean.setOt_lic_kd(results.getString("OT_LIC_KD"));
			bean.setOt_lic_no(results.getString("OT_LIC_NO"));
			bean.setOt_tel2(results.getString("OT_TEL2"));
			bean.setOur_dam_st(results.getString("OUR_DAM_ST"));
			bean.setOt_dam_st(results.getString("OT_DAM_ST"));
			bean.setAccid_addr(results.getString("ACCID_ADDR"));
			bean.setAccid_cont2(results.getString("ACCID_CONT2"));
			bean.setImp_fault_st(results.getString("IMP_FAULT_ST"));
			bean.setImp_fault_sub(results.getString("IMP_FAULT_SUB"));
			bean.setOur_fault_per(results.getInt("OUR_FAULT_PER"));
			bean.setOt_pol_st(results.getString("OT_POL_ST"));
			bean.setOt_pol_num(results.getString("OT_POL_NUM"));
			bean.setOt_pol_fax(results.getString("OT_POL_FAX"));
			bean.setIns_req_gu(results.getString("INS_REQ_GU"));
			bean.setIns_req_st(results.getString("INS_REQ_ST"));
			bean.setIns_car_nm(results.getString("INS_CAR_NM"));
			bean.setIns_car_no(results.getString("INS_CAR_NO"));
			bean.setIns_day_amt(results.getInt("INS_DAY_AMT"));
			bean.setIns_use_st(results.getString("INS_USE_ST"));
			bean.setIns_use_et(results.getString("INS_USE_ET"));
			bean.setIns_nm(results.getString("INS_NM"));
			bean.setIns_tel(results.getString("INS_TEL"));
			bean.setIns_req_amt(results.getInt("INS_REQ_AMT"));
			bean.setIns_req_dt(results.getString("INS_REQ_DT"));
			bean.setIns_pay_amt(results.getInt("INS_PAY_AMT"));
			bean.setIns_pay_dt(results.getString("INS_PAY_DT"));
			bean.setIns_use_day(results.getString("INS_USE_DAY"));		
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}

	/**
    * 사고기록 bean : 자기신체사고-자손 
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
			bean.setOne_accid_st(results.getString("ONE_ACCID_ST"));							
			return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}
	
	/**
    * 사고기록 bean : 보험 청구 내역 (휴차료/대차료)
    */    
    private MyAccidBean makeMyAccidBean(ResultSet results) throws DatabaseException {
        try {
            MyAccidBean bean = new MyAccidBean();
		    bean.setCar_mng_id(results.getString("CAR_MNG_ID")); 					
			bean.setAccid_id(results.getString("ACCID_ID"));
			bean.setIns_req_gu(results.getString("REQ_GU"));
			bean.setIns_req_st(results.getString("REQ_ST"));
			bean.setIns_car_nm(results.getString("CAR_NM"));
			bean.setIns_car_no(results.getString("CAR_NO"));
			bean.setIns_day_amt(results.getInt("DAY_AMT"));
			bean.setIns_use_st(results.getString("USE_ST"));
			bean.setIns_use_et(results.getString("USE_ET"));
			bean.setIns_use_day(results.getString("USE_DAY"));		
			bean.setIns_nm(results.getString("INS_NM"));
			bean.setIns_tel(results.getString("INS_TEL"));
			bean.setIns_tel2(results.getString("INS_TEL2"));
			bean.setIns_fax(results.getString("INS_FAX"));
			bean.setIns_addr(results.getString("INS_ADDR"));
			bean.setIns_req_amt(results.getInt("REQ_AMT"));
			bean.setIns_req_dt(results.getString("REQ_DT"));
			bean.setIns_pay_amt(results.getInt("PAY_AMT"));
			bean.setIns_pay_dt(results.getString("PAY_DT"));
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}


	// 조회 -------------------------------------------------------------------------------------------------
	
	/**
     * 사고기록 전체조회 : car_accid_s_sc_in.jsp
     */
    public AccidentBean [] getAccidentAll(String br_id, String gubun1, String gubun2, String st_dt, String end_dt, String s_kd, String t_wd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        String subQuery = "";
        
		/*조회구분*/

		/*당일*/if(gubun1.equals("1")){			subQuery = " and a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%'";
		/*당월*/}else if(gubun1.equals("2")){		subQuery = " and a.accid_dt like to_char(sysdate,'YYYYMM')||'%'";
		/*기간*/}else if(gubun1.equals("3")){		subQuery = " and a.accid_dt between '"+st_dt+"' and '"+end_dt+"'";
				}

		/*상세조회*/

		/*피해자*/if(gubun2.equals("1")){			subQuery += " and a.accid_st='1'";
		/*가해자*/}else if(gubun2.equals("2")){	subQuery += " and a.accid_st='2'";
		/*쌍  방*/}else if(gubun2.equals("3")){	subQuery += " and a.accid_st='3'";
		/*자  차*/}else if(gubun2.equals("4")){	subQuery += " and a.accid_st='4'";
		          }
		
		/*검색조건*/

		if(s_kd.equals("1"))		subQuery += " and b.firm_nm like '%"+t_wd+"%'\n";			
		else if(s_kd.equals("2"))	subQuery += " and b.rent_l_cd like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("3"))	subQuery += " and a.accid_dt like '"+t_wd+"%'\n";
		else if(s_kd.equals("4"))	subQuery += " and a.our_car_nm like '%"+t_wd+"%'\n";
		else if(s_kd.equals("5"))	subQuery += " and c.car_no like '%"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	subQuery += " and a.our_driver like '%"+t_wd+"%'\n";
		else if(s_kd.equals("7"))	subQuery += " and a.ot_car_no like '%"+t_wd+"%'\n";
		else if(s_kd.equals("8"))	subQuery += " and a.ot_driver like '%"+t_wd+"%'\n";
		else if(s_kd.equals("9"))	subQuery += " and b.mng_id = '"+t_wd+"'\n";
		else if(s_kd.equals("10"))	subQuery += " and a.our_ins like '%"+t_wd+"%'\n";
		
		if(!br_id.equals("S1") && !br_id.equals(""))		subQuery += " and b.brch_id = '"+br_id+"'"; 
       
        query = " select  /*+  merge(b) */ "+
				" a.car_mng_id, a.accid_id, a.rent_mng_id, a.rent_l_cd, a.accid_st, a.our_fault_per, c.car_no, b.client_nm, b.firm_nm,\n"+
				" nvl2(a.accid_dt,substr(a.accid_dt,1,4)||'-'||substr(a.accid_dt,5,2)||'-'||substr(a.accid_dt,7,2)||' '||substr(a.accid_dt,9,2)||':'||substr(a.accid_dt,11,2),'') as accid_dt\n"+
				" from accident a, cont_n_view b,  car_reg c \n"+
				" where a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				"	and a.car_mng_id = c.car_mng_id    \n"+                       		
				  subQuery;

		Collection<AccidentBean> col = new ArrayList<AccidentBean>();

        try{

			pstmt = con.prepareStatement(query);   		

    		rs = pstmt.executeQuery();

            while(rs.next()){                
				col.add(makeAccidentListBean(rs));
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
        return (AccidentBean[])col.toArray(new AccidentBean[0]);
    }

	/**
     * 사고등록시 계약번호, 상호, 차량번호로 계약리스트 조회 : car_rent_list.jsp
     */
    public AccidentBean [] getCarRentListAll( String gubun, String rent_l_cd, String firm_nm, String car_no ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
       	String query =	" select /*+  merge(a) */ "+
						"        decode(cc.cls_st,'1','계약만료','2','중도해약','3','영업소변경','4','출고후차종변경','5','계약이관','6','매각','7','출고전해지',decode(a.use_yn,'N','(전)보유','대여')) cls_st,"+
						"        a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.firm_nm, a.client_nm, c.car_no, c.car_nm, cn.car_name"+
						" from   cont_n_view a,  cls_cont cc, car_reg c,  car_etc g, car_nm cn \n"+
						" where  a.rent_l_cd like upper('%" + rent_l_cd + "%') "+
						"        and c.car_no like '%" + car_no + "%' "+
						"        and a.firm_nm like '%" + firm_nm + "%' "+
						"	and a.car_mng_id = c.car_mng_id  and a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+)  \n"+
                       				"	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+) \n"+
                       				"	and a.rent_mng_id = cc.rent_mng_id(+)  and a.rent_l_cd = cc.rent_l_cd(+) ";                       				

		Collection<AccidentBean> col = new ArrayList<AccidentBean>();

        try{

			pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery(query);
            while(rs.next()){               
				col.add(makeConeListBean(rs)); 
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
        return (AccidentBean[])col.toArray(new AccidentBean[0]);
    }
	
	// (등록시) 계약관련 자료 조회 : car_accid_all_i.jsp
	public RentListBean getCont_View(String m_id, String l_cd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		RentListBean bean = new RentListBean();
		
       	String query =  " select "+
						"        a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.car_st, a.car_ja, a.client_id,"+
						"        a.firm_nm, a.client_nm, c.car_no, c.init_reg_dt, a.mng_id, a.mng_id2, "+
						"        a.r_site, c.car_nm, cn.car_name"+
					    " from   cont_n_view a , car_reg c,  car_etc g, car_nm cn \n"+
						" where  a.rent_mng_id='"+m_id+"' and a.rent_l_cd='"+l_cd+"'  \n"+
						"	and a.car_mng_id = c.car_mng_id  and a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+)  \n"+
                       				"	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+) ";

		try 
		{

			pstmt = con.prepareStatement(query);
		    rs = pstmt.executeQuery();
            if(rs.next())
            {
			    bean.setRent_mng_id(rs.getString("RENT_MNG_ID"));		//계약관리ID
			    bean.setRent_l_cd(rs.getString("RENT_L_CD"));			//계약코드
			    bean.setCar_mng_id(rs.getString("CAR_MNG_ID"));			//차량관리ID
			    bean.setCar_st(rs.getString("CAR_ST"));					//대여차량구분
			    bean.setCar_ja(rs.getInt("CAR_JA"));					//자차면책금
			    bean.setClient_id(rs.getString("CLIENT_ID"));			//상호
				bean.setFirm_nm(rs.getString("FIRM_NM"));				//상호
			    bean.setClient_nm(rs.getString("CLIENT_NM"));			//고객 대표자명
			    bean.setCar_no(rs.getString("CAR_NO"));					//차량번호
			    bean.setInit_reg_dt(rs.getString("INIT_REG_DT"));		//최초등록일
			    bean.setMng_id(rs.getString("MNG_ID"));					
			    bean.setMng_id2(rs.getString("MNG_ID2"));					
			    bean.setCar_nm(rs.getString("CAR_NM"));								    
			    bean.setCar_name(rs.getString("CAR_NAME"));								    			    
			    bean.setR_site(rs.getString("R_SITE"));								    

			}
		 rs.close();
            	pstmt.close();	

		} catch (SQLException e) {
			System.out.println("[AddCarAccidDatabase:getCont_View]\n"+e);
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

    /**
     * 사고기록 개별조회 : car_accid_all_u.jsp
     */
    public AccidentBean getAccidentBean(String car_mng_id, String accid_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        AccidentBean ab = new AccidentBean();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = " select"+
				" a.car_mng_id, a.accid_id, a.rent_mng_id, a.rent_l_cd, a.accid_st, a.our_car_nm, a.our_driver,"+
				" a.our_tel, a.our_m_tel, a.our_ssn, a.our_lic_kd, a.our_lic_no, a.our_ins, a.our_num, a.our_post,"+
				" a.our_addr, a.accid_dt, a.accid_city, a.accid_gu, a.accid_dong, a.accid_point, a.accid_cont,"+
				" a.ot_car_no, a.ot_car_nm, a.ot_driver, a.ot_tel, a.ot_m_tel, a.ot_ins, a.ot_num, a.ot_ins_nm,"+
				" a.ot_ins_tel, a.ot_ins_m_tel, a.ot_pol_sta, a.ot_pol_nm, a.ot_pol_tel, a.ot_pol_m_tel,"+
				" a.hum_amt, a.hum_nm, a.hum_tel, a.mat_amt, a.mat_nm, a.mat_tel, a.one_amt, a.one_nm, a.one_tel,"+
				" a.my_amt, a.my_nm, a.my_tel, a.ref_dt, a.ex_tot_amt, a.tot_amt, a.rec_amt, a.rec_dt, a.rec_plan_dt,"+
				" a.sup_amt, a.sup_dt, a.ins_sup_amt, a.ins_sup_dt, a.ins_tot_amt,\n"+
				" a.sub_rent_gu, a.sub_firm_nm, a.sub_rent_st, a.sub_rent_et, a.sub_etc,"+
				" a.reg_dt, a.reg_id, a.update_dt, a.update_id,"+
				" a.our_lic_dt, a.our_tel2, a.ot_ssn, a.ot_lic_no, a.ot_lic_kd, a.ot_tel2, a.our_dam_st, a.ot_dam_st,"+
				" a.accid_addr, a.accid_cont2, a.imp_fault_st, a.imp_fault_sub, a.our_fault_per, a.ot_pol_st, a.ot_pol_num, a.ot_pol_fax, a.r_site, a.memo, "+
				" a.car_in_dt, a.car_out_dt, a.ins_end_dt"+
				" from accident a\n"+
				" where "+
				" car_mng_id=? and a.accid_id=?\n";
        
        try{

			pstmt = con.prepareStatement(query);
    		pstmt.setString(1, car_mng_id.trim());
    		pstmt.setString(2, accid_id.trim());
    		rs = pstmt.executeQuery();
            if (rs.next()){
                ab = makeAccidentBean2(rs);
			}
            
            rs.close();
            pstmt.close();

        }catch(SQLException se){
			System.out.println("[AddCarAccidDatabase:getAccidentBean]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return ab;
    }

    /**
     * 자손 조회 : car_accid_all_u.jsp
     */
    public OneAccidBean [] getOneAccid(String car_mng_id, String accid_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = " select"+
				" car_mng_id, accid_id, seq_no, nm, sex, hosp, hosp_tel, ins_nm, ins_tel, tel, age, relation, diagnosis, etc, one_accid_st\n"+
				" from one_accid a\n"+
				" where car_mng_id=? and accid_id=?\n";

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
			System.out.println("[AddCarAccidDatabase:getOneAccid]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (OneAccidBean[])col.toArray(new OneAccidBean[0]);
    }


    /**
     * 보험청구내역 (휴차료/대차료) : car_accid_all_u.jsp
     */
    public MyAccidBean getMyAccid(String car_mng_id, String accid_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        MyAccidBean mb = new MyAccidBean();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = " select car_mng_id, accid_id, req_gu, req_st, car_nm, car_no, day_amt, use_st, use_et, use_day,"+
				" ins_nm, ins_tel, ins_tel2, ins_fax, ins_addr, req_amt, req_dt, pay_amt, pay_dt"+
				" from my_accid"+
				" where car_mng_id=? and accid_id=?";
        
        try{

            pstmt = con.prepareStatement(query);
    		pstmt.setString(1, car_mng_id.trim());
    		pstmt.setString(2, accid_id.trim());
    		rs = pstmt.executeQuery();
            if (rs.next())
                mb = makeMyAccidBean(rs);
            
            rs.close();
            pstmt.close();

        }catch(SQLException se){
			System.out.println("[AddCarAccidDatabase:getMyAccid]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return mb;
    }

	/**
     * 차량별 사고 리스트 조회 : car_accid_list.jsp
     */
    public AccidentBean [] getCarAccidList(String car_mng_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
       	String query =	" select /*+  merge(a) */ "+
						"        a.rent_mng_id, a.rent_l_cd, a.firm_nm, a.client_nm, c.car_no, a.car_mng_id,"+
						"        b.accid_id, decode(b.accid_st, '1','피해', '2','가해', '3','쌍방', '6','수해', '8','단독', ' ') accid_st,"+
						"        b.our_driver, b.accid_dt, b.accid_addr, b.accid_cont, b.accid_cont2,"+
						"        decode(b.sub_rent_gu, '1','출고전대차', '2','단기대여', '3','기타', ' ') sub_rent_gu, b.sub_firm_nm"+
						" from   cont_n_view a, accident b , car_reg c"+
						" where  b.car_mng_id like '%" + car_mng_id + "%'"+
						"        and a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.car_mng_id = c.car_mng_id " +
						" order by b.accid_dt";

		Collection<AccidentBean> col = new ArrayList<AccidentBean>();

        try{

			pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery(query);
            while(rs.next()){               
				col.add(makeCarAccidListBean(rs)); 
            }

            rs.close();
            pstmt.close();

        }catch(SQLException se){
			System.out.println("[AddCarAccidDatabase:getCarAccidList]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (AccidentBean[])col.toArray(new AccidentBean[0]);
    }

	/**
     * 차량별 사고 건별 조회 : sub_cont.jsp
     */
    public AccidentBean getCarAccidCase(String car_mng_id, String accid_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        AccidentBean ab = new AccidentBean();       
        PreparedStatement pstmt = null;
        ResultSet rs = null;
       	String query =	" select decode(accid_st, '1','피해', '2','가해', '3','쌍방', '6','수해', '8','단독',  ' ') accid_st,"+
						" our_driver, accid_dt, accid_addr, accid_cont, accid_cont2,"+
						" decode(sub_rent_gu, '1','출고전대차', '2','단기대여', '3','기타', ' ') sub_rent_gu, sub_firm_nm, our_fault_per, decode(ot_pol_st, '0','미신고','신고') ot_pol_st"+
						" from accident"+
						" where car_mng_id='"+car_mng_id+"' and accid_id='"+accid_id+"'";
        try{

			pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery(query);
            if(rs.next()){               
                ab = makeAccidentBeanCase(rs);
            }

            rs.close();
            pstmt.close();

        }catch(SQLException se){
			System.out.println("[AddCarAccidDatabase:getCarAccidCase]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
	   }
        return ab;
    }


	// 등록 -------------------------------------------------------------------------------------------------

	/**
     * 사고기록 등록 : car_accid_all_i_a.jsp
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
                
        query = " INSERT INTO accident"+
				" (CAR_MNG_ID, ACCID_ID, RENT_MNG_ID, RENT_L_CD, ACCID_ST,"+
				" OUR_CAR_NM, OUR_DRIVER, OUR_TEL, OUR_M_TEL, OUR_SSN,"+	//10
				" OUR_LIC_KD, OUR_LIC_NO, OUR_INS, OUR_NUM, OUR_POST,"+
				" OUR_ADDR, ACCID_DT, ACCID_CITY, ACCID_GU, ACCID_DONG,"+	//20
				" ACCID_POINT, ACCID_CONT, OT_CAR_NO, OT_CAR_NM, OT_DRIVER,"+
				" OT_TEL, OT_M_TEL, OT_INS, OT_NUM, OT_INS_NM,"+			//30
				" OT_INS_TEL, OT_INS_M_TEL, OT_POL_STA, OT_POL_NM, OT_POL_TEL,"+
				" OT_POL_M_TEL, HUM_AMT, HUM_NM, HUM_TEL, MAT_AMT,"+		//40
				" MAT_NM, MAT_TEL, ONE_AMT, ONE_NM, ONE_TEL,"+
				" MY_AMT, MY_NM, MY_TEL, REF_DT, EX_TOT_AMT,"+				//50
				" TOT_AMT, REC_AMT, REC_DT, REC_PLAN_DT, SUP_AMT,"+
				" SUP_DT, INS_SUP_AMT, INS_SUP_DT, INS_TOT_AMT,"+			//59	
				//추가
				" SUB_RENT_GU, SUB_FIRM_NM, SUB_RENT_ST, SUB_RENT_ET, SUB_ETC,"+	//64
				" REG_DT, REG_ID, UPDATE_DT, UPDATE_ID, OUR_LIC_DT, "+				//69
				" OUR_TEL2, OT_SSN, OT_LIC_KD, OT_LIC_NO, OT_TEL2,"+				//74
				" OUR_DAM_ST, OT_DAM_ST, ACCID_ADDR, ACCID_CONT2, IMP_FAULT_ST,"+	//79
				" IMP_FAULT_SUB, OUR_FAULT_PER, OT_POL_ST, OT_POL_NUM, OT_POL_FAX, R_SITE, MEMO"+//86*/
				" )\n"+			
				" values(?, ?, ?, ?, ?, ?, ?, ?, ?, replace(?,'-',''),"+
				" ?, ?, ?, ?, ?, ?, replace(?,'-',''), ?, ?, ?,"+
				" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				" ?, ?, ?, ?, ?, ?, ?, ?, ?,"+		//59
				//추가
				" ?, ?, replace(?,'-',''), replace(?,'-',''), ?,"+
				" replace(?,'-',''), ?, replace(?,'-',''), ?, replace(?,'-',''),"+	//69
				" ?, replace(?,'-',''), ?, ?, ?, ?, ?, ?, ?, ?,"+					//79
				" ?, ?, ?, ?, ?, ?, ?"+										//86
				" )\n";

		query1 = " select nvl(lpad(max(ACCID_ID)+1,6,'0'),'000001') from accident ";
    
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
			pstmt.setInt   (37, bean.getHum_amt());
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
			//추가
			pstmt.setString(60, bean.getSub_rent_gu().trim());
			pstmt.setString(61, bean.getSub_firm_nm().trim());
			pstmt.setString(62, bean.getSub_rent_st().trim());
			pstmt.setString(63, bean.getSub_rent_et().trim());
			pstmt.setString(64, bean.getSub_etc().trim());
			pstmt.setString(65, bean.getReg_dt().trim());
			pstmt.setString(66, bean.getReg_id().trim());
			pstmt.setString(67, bean.getUpdate_dt().trim());
			pstmt.setString(68, bean.getUpdate_id().trim());
			pstmt.setString(69, bean.getOur_lic_dt().trim());
			pstmt.setString(70, bean.getOur_tel2().trim());
			pstmt.setString(71, bean.getOt_ssn().trim());
			pstmt.setString(72, bean.getOt_lic_kd().trim());
			pstmt.setString(73, bean.getOt_lic_no().trim());
			pstmt.setString(74, bean.getOt_tel2().trim());
			pstmt.setString(75, bean.getOur_dam_st().trim());
			pstmt.setString(76, bean.getOt_dam_st().trim());
			pstmt.setString(77, bean.getAccid_addr().trim());
			pstmt.setString(78, bean.getAccid_cont2().trim());
			pstmt.setString(79, bean.getImp_fault_st().trim());
			pstmt.setString(80, bean.getImp_fault_sub().trim());
			pstmt.setInt(81, bean.getOur_fault_per());
			pstmt.setString(82, bean.getOt_pol_st().trim());
			pstmt.setString(83, bean.getOt_pol_num().trim());
			pstmt.setString(84, bean.getOt_pol_fax().trim());
			pstmt.setString(85, bean.getR_site().trim());
			pstmt.setString(86, bean.getMemo().trim());
            count = pstmt.executeUpdate();             
            pstmt.close();
            con.commit();

		}catch(Exception se){
            try{
				System.out.println("[AddCarAccidDatabase:insertAccident]\n"+se);
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
        return accid_id;
    }

    /**
     * 자기신체사고-자손 등록.
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
                
        query = " INSERT INTO one_accid(CAR_MNG_ID, ACCID_ID, SEQ_NO, NM, SEX,"+
				" HOSP, HOSP_TEL, INS_NM, INS_TEL, TEL,"+
				" AGE, RELATION, DIAGNOSIS, ETC)\n"+
				" values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)\n";

		query1= " select nvl(max(seq_no)+1,1) from one_accid where car_mng_id=? and accid_id=?";
    
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
				System.out.println("[AddCarAccidDatabase:insertOneAccid]\n"+se);
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
        return count;
    }

    /**
     * 보험금청구내역 insert (휴차/대차료 보험회사 청부 내용)
     */
    public int insertMyAccid(MyAccidBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " INSERT INTO MY_ACCID"+
				" (CAR_MNG_ID, ACCID_ID, REQ_GU, REQ_ST, CAR_NM,"+
				" CAR_NO, DAY_AMT, USE_ST, USE_ET, INS_NM,"+	
				" INS_TEL, REQ_AMT, REQ_DT, PAY_AMT, PAY_DT,"+	
				" USE_DAY, INS_TEL2, INS_FAX, INS_ADDR"+				
				" )\n"+			
				" values(?, ?, ?, ?, ?,"+					
				" ?, ?, replace(?,'-',''), replace(?,'-',''), ?,"+
				" ?, ?, replace(?,'-',''), ?, replace(?,'-',''),"+		
				" ?, ?, ?, ?)\n";
    
       try{
            con.setAutoCommit(false);

            pstmt = con.prepareStatement(query);
            pstmt.setString(1, bean.getCar_mng_id().trim());
			pstmt.setString(2, bean.getAccid_id().trim());
			pstmt.setString(3, bean.getIns_req_gu().trim());
			pstmt.setString(4, bean.getIns_req_st().trim());
			pstmt.setString(5, bean.getIns_car_nm().trim());
			pstmt.setString(6, bean.getIns_car_no().trim());
			pstmt.setInt(7, bean.getIns_day_amt());
			pstmt.setString(8, bean.getIns_use_st().trim());
			pstmt.setString(9, bean.getIns_use_et().trim());
			pstmt.setString(10, bean.getIns_nm().trim());
			pstmt.setString(11, bean.getIns_tel().trim());
			pstmt.setInt(12, bean.getIns_req_amt());
			pstmt.setString(13, bean.getIns_req_dt().trim());
			pstmt.setInt(14, bean.getIns_pay_amt());
			pstmt.setString(15, bean.getIns_pay_dt().trim());
			pstmt.setString(16, bean.getIns_use_day().trim());  
			pstmt.setString(17, bean.getIns_tel2().trim());
			pstmt.setString(18, bean.getIns_fax().trim());
			pstmt.setString(19, bean.getIns_addr().trim());
			
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(SQLException se){
            try{
				System.out.println("[AddCarAccidDatabase:insertMyAccid]\n"+se);
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

	// 수정 -------------------------------------------------------------------------------------------------

	/**
     * 사고기록 수정 : car_accid_all_u_a.jsp.
     */
    public int updateAccident(AccidentBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " update accident set"+
				" RENT_MNG_ID=?, RENT_L_CD=?, ACCID_ST=?, OUR_CAR_NM=?, OUR_DRIVER=?,"+
				" OUR_TEL=?, OUR_M_TEL=?, OUR_SSN=replace(?,'-',''), OUR_LIC_KD=?, OUR_LIC_NO=?,"+
				" OUR_INS=?, OUR_NUM=?, OUR_POST=?, OUR_ADDR=?, ACCID_DT=replace(?,'-',''),"+
				" ACCID_CITY=?, ACCID_GU=?, ACCID_DONG=?, ACCID_POINT=?, ACCID_CONT=?,"+
				" OT_CAR_NO=?, OT_CAR_NM=?, OT_DRIVER=?, OT_TEL=?, OT_M_TEL=?,"+
				" OT_INS=?, OT_NUM=?, OT_INS_NM=?, OT_INS_TEL=?, OT_INS_M_TEL=?,"+
				" OT_POL_STA=?, OT_POL_NM=?, OT_POL_TEL=?, OT_POL_M_TEL=?, HUM_AMT=?,"+
				" HUM_NM=?, HUM_TEL=?, MAT_AMT=?, MAT_NM=?, MAT_TEL=?,"+
				" ONE_AMT=?, ONE_NM=?, ONE_TEL=?, MY_AMT=?, MY_NM=?,"+
				" MY_TEL=?, REF_DT=replace(?,'-',''), EX_TOT_AMT=?, TOT_AMT=?, REC_AMT=?,"+
				" REC_DT=replace(?,'-',''), REC_PLAN_DT=replace(?,'-',''), SUP_AMT=?, SUP_DT=replace(?,'-',''), INS_SUP_AMT=?,"+
				" INS_SUP_DT=replace(?,'-',''), INS_TOT_AMT=?\n,"+//57
				" SUB_RENT_GU=?, SUB_FIRM_NM=?, SUB_RENT_ST=replace(?,'-',''), SUB_RENT_ET=replace(?,'-',''), SUB_ETC=?,"+
				" REG_DT=replace(?,'-',''), REG_ID=?, UPDATE_DT=replace(?,'-',''), UPDATE_ID=?, OUR_LIC_DT=replace(?,'-',''),"+
				" OUR_TEL2=?, OT_SSN=replace(?,'-',''), OT_LIC_NO=?, OT_LIC_KD=?, OT_TEL2=?,"+
				" OUR_DAM_ST=?, OT_DAM_ST=?, ACCID_ADDR=?, ACCID_CONT2=?, IMP_FAULT_ST=?,"+
				" IMP_FAULT_SUB=?, OUR_FAULT_PER=?, OT_POL_ST=?, OT_POL_NUM=?, OT_POL_FAX=?, MEMO=?,"+
				" CAR_IN_DT=replace(?,'-',''), CAR_OUT_DT=replace(?,'-',''), INS_END_DT=replace(?,'-','') "+//83+3
				" where car_mng_id=? and accid_id=?\n";
    
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
			//추가start
			pstmt.setString(58, bean.getSub_rent_gu().trim());
			pstmt.setString(59, bean.getSub_firm_nm().trim());
			pstmt.setString(60, bean.getSub_rent_st().trim());
			pstmt.setString(61, bean.getSub_rent_et().trim());
			pstmt.setString(62, bean.getSub_etc().trim());
			pstmt.setString(63, bean.getReg_dt().trim());
			pstmt.setString(64, bean.getReg_id().trim());
			pstmt.setString(65, bean.getUpdate_dt().trim());
			pstmt.setString(66, bean.getUpdate_id().trim());
			pstmt.setString(67, bean.getOur_lic_dt().trim());
			pstmt.setString(68, bean.getOur_tel2().trim());
			pstmt.setString(69, bean.getOt_ssn().trim());
			pstmt.setString(70, bean.getOt_lic_no().trim());
			pstmt.setString(71, bean.getOt_lic_kd().trim());
			pstmt.setString(72, bean.getOt_tel2().trim());
			pstmt.setString(73, bean.getOur_dam_st().trim());
			pstmt.setString(74, bean.getOt_dam_st().trim());
			pstmt.setString(75, bean.getAccid_addr().trim());
			pstmt.setString(76, bean.getAccid_cont2().trim());
			pstmt.setString(77, bean.getImp_fault_st().trim());
			pstmt.setString(78, bean.getImp_fault_sub().trim());
			pstmt.setInt(79, bean.getOur_fault_per());
			pstmt.setString(80, bean.getOt_pol_st().trim());
			pstmt.setString(81, bean.getOt_pol_num().trim());
			pstmt.setString(82, bean.getOt_pol_fax().trim());
			pstmt.setString(83, bean.getMemo().trim());
			pstmt.setString(84, bean.getCar_in_dt().trim());
			pstmt.setString(85, bean.getCar_out_dt().trim());
			pstmt.setString(86, bean.getIns_end_dt().trim());
          	pstmt.setString(87, bean.getCar_mng_id().trim());
			pstmt.setString(88, bean.getAccid_id().trim());

			count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(SQLException se){
            try{
				System.out.println("[AddCarAccidDatabase:updateAccident]\n"+se);
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
     * 자손 수정  : car_accid_all_u_a.jsp
     */
    public int updateOneAccid(OneAccidBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " update one_accid set"+
				" NM=?, SEX=?, HOSP=?, HOSP_TEL=?, INS_NM=?, INS_TEL=?, TEL=?, AGE=?, RELATION=?, DIAGNOSIS=?,"+
				" ETC=?, ONE_ACCID_ST=?\n"+
				" where car_mng_id=? and accid_id=? and seq_no=?\n";

    
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
			pstmt.setString(12, bean.getOne_accid_st().trim());
			pstmt.setString(13, bean.getCar_mng_id().trim());
			pstmt.setString(14, bean.getAccid_id().trim());
			pstmt.setInt(15, bean.getSeq_no());

            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(SQLException se){
            try{
				System.out.println("[AddCarAccidDatabase:updateOneAccid]\n"+se);
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
     * 보험금청구내역 update (휴차/대차료 보험회사 청구내용)
     */
    public int updateMyAccid(MyAccidBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " UPDATE MY_ACCID SET"+
				" REQ_GU=?, REQ_ST=?, CAR_NM=?, CAR_NO=?, DAY_AMT=?,"+
				" USE_ST=replace(?,'-',''), USE_ET=replace(?,'-',''), INS_NM=?, INS_TEL=?, REQ_AMT=?,"+	
				" REQ_DT=replace(?,'-',''), PAY_AMT=?, PAY_DT=replace(?,'-',''), USE_DAY=?, INS_TEL2=?, INS_FAX=?, INS_ADDR=?"+				
				" where car_mng_id=? and accid_id=?\n";
    
       try{
            con.setAutoCommit(false);

            pstmt = con.prepareStatement(query);
			pstmt.setString(1, bean.getIns_req_gu().trim());
			pstmt.setString(2, bean.getIns_req_st().trim());
			pstmt.setString(3, bean.getIns_car_nm().trim());
			pstmt.setString(4, bean.getIns_car_no().trim());
			pstmt.setInt(5, bean.getIns_day_amt());
			pstmt.setString(6, bean.getIns_use_st().trim());
			pstmt.setString(7, bean.getIns_use_et().trim());
			pstmt.setString(8, bean.getIns_nm().trim());
			pstmt.setString(9, bean.getIns_tel().trim());
			pstmt.setInt(10, bean.getIns_req_amt());
			pstmt.setString(11, bean.getIns_req_dt().trim());
			pstmt.setInt(12, bean.getIns_pay_amt());
			pstmt.setString(13, bean.getIns_pay_dt().trim());
			pstmt.setString(14, bean.getIns_use_day().trim());  
			pstmt.setString(15, bean.getIns_tel2().trim());
			pstmt.setString(16, bean.getIns_fax().trim());
			pstmt.setString(17, bean.getIns_addr().trim());			
            pstmt.setString(18, bean.getCar_mng_id().trim());
			pstmt.setString(19, bean.getAccid_id().trim());

            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(SQLException se){
            try{
				System.out.println("[AddCarAccidDatabase:updateMyAccid]\n"+se);
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
	 *	면책금/휴차료/대차료 메모
	 */
	public Vector getInsMemo(String m_id, String l_cd, String c_id, String tm_st, String accid_id, String serv_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query =	" select * from tel_mm"+
						" where RENT_MNG_ID='"+m_id+"' and RENT_L_CD='"+l_cd+"' and CAR_MNG_ID='"+c_id+"'"+
						" ";

		query += " order by REG_DT desc, REG_DT_TIME desc ";		

		try {
			pstmt = con.prepareStatement(query);
	   		rs = pstmt.executeQuery();
			while(rs.next())
			{
				InsMemoBean ins_mm = new InsMemoBean();
				ins_mm.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				ins_mm.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				ins_mm.setCar_mng_id(rs.getString("CAR_MNG_ID")==null?"":rs.getString("CAR_MNG_ID"));
				ins_mm.setTm_st(rs.getString("TM_ST")==null?"":rs.getString("TM_ST"));
				ins_mm.setAccid_id(rs.getString("ACCID_ID")==null?"":rs.getString("ACCID_ID"));
				ins_mm.setServ_id(rs.getString("SERV_ID")==null?"":rs.getString("SERV_ID"));
				ins_mm.setSeq(rs.getString("SEQ")==null?"":rs.getString("SEQ"));
				ins_mm.setReg_id(rs.getString("REG_ID")==null?"":rs.getString("REG_ID"));
				ins_mm.setReg_dt(rs.getString("REG_DT")==null?"":rs.getString("REG_DT"));
				ins_mm.setContent(rs.getString("CONTENT")==null?"":rs.getString("CONTENT"));
				ins_mm.setSpeaker(rs.getString("SPEAKER")==null?"":rs.getString("SPEAKER"));
				vt.add(ins_mm);
			}
			 rs.close();
          		  pstmt.close();
		} catch (SQLException e) {
            try{
				System.out.println("[AddCarAccidDatabase:getInsMemo]\n"+e);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
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
	 *	면책금/휴차료/대차료 메모 insert
	 */
	public boolean insertInsMemo(InsMemoBean ins_mm) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		String s_seq = "";
		String query_id = " select nvl(ltrim(to_char(to_number(MAX(seq))+1, '000000')), '000001') ID from tel_mm "+
						  " where rent_mng_id='"+ins_mm.getRent_mng_id()+"' AND rent_l_cd='"+ins_mm.getRent_l_cd()+"'";

		String query =  " insert into tel_mm ("+
						" RENT_MNG_ID, RENT_L_CD, CAR_MNG_ID, ACCID_ID, SERV_ID,"+
						" TM_ST, SEQ, REG_ID, REG_DT, CONTENT, SPEAKER, REG_DT_TIME)"+//12
						" values ( ?, ?, ?, ?, ?,  ?, ?, ?, replace(?, '-', ''), ?, ?, ?)";
		try {
			con.setAutoCommit(false);

			pstmt1 = con.prepareStatement(query_id);
	    	rs = pstmt1.executeQuery();
			while(rs.next())
			{
				s_seq = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt1.close();

			pstmt2 = con.prepareStatement(query);
			pstmt2.setString(1, ins_mm.getRent_mng_id());
			pstmt2.setString(2, ins_mm.getRent_l_cd());
			pstmt2.setString(3, ins_mm.getCar_mng_id());
			pstmt2.setString(4, ins_mm.getAccid_id());
			pstmt2.setString(5, ins_mm.getServ_id());
			pstmt2.setString(6, ins_mm.getTm_st());
			pstmt2.setString(7, s_seq);
			pstmt2.setString(8, ins_mm.getReg_id());
			pstmt2.setString(9, ins_mm.getReg_dt());
			pstmt2.setString(10, ins_mm.getContent());
			pstmt2.setString(11, ins_mm.getSpeaker());
			pstmt2.setString(12, s_seq);
		    pstmt2.executeUpdate();
			pstmt2.close();
		    
            con.commit();

	  	} catch (Exception e) {
            try{
		  		flag = false;
				System.out.println("[AddCarAccidDatabase:insertInsMemo]\n"+e);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
		} finally {
			try{	
				con.setAutoCommit(true);
                if(rs != null )		rs.close();
                if(pstmt1 != null)	pstmt1.close();
                if(pstmt2 != null)	pstmt2.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return flag;
	}	

	/**
	*	사고등록수정시 누적주행거리 조회 - 2003.8.28.Thu.
	*/
	public String getTot_dist(String car_mng_id) throws DatabaseException, DataSourceEmptyException{

        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String tot_dist = "";

		query = "SELECT tot_dist FROM service a "+
				" WHERE a.serv_id = (SELECT max(b.serv_id) FROM service b WHERE a.car_mng_id = b.car_mng_id) "+
				" AND car_mng_id = ? ";
		try{
			pstmt = con.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				tot_dist = rs.getString(1)==null?"":rs.getString(1);
			}			
			rs.close();
            pstmt.close();
            
		}catch(SQLException e){
			try{
				System.out.println("[AddCarAccidDatabase:getTot_dist(String car_mng_id)]"+e);
				e.printStackTrace();			
				con.rollback();
			}catch(SQLException _ignored){}
              throw new DatabaseException("exception");
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}		
		return tot_dist;
	}

}
