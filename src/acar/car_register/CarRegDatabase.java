/**
 * �ڵ������
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.car_register;

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

import acar.common.RentListBean;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.DatabaseException;
import acar.exception.UnknownDataException;
import acar.util.Util;

public class CarRegDatabase {

    private static CarRegDatabase instance;
    private DBConnectionManager connMgr;   
    // Pool�� ���� Connection ��ü�� �����ö� ����ϴ� Pool Name 
    private final String DATA_SOURCE = "acar"; 

    // �̱��� Ŭ������ ���� 
    // �����ڸ� private �� ����
    public static synchronized CarRegDatabase getInstance() throws DatabaseException {
        if (instance == null)
            instance = new CarRegDatabase();
        return instance;
    }
    
    private CarRegDatabase() throws DatabaseException {
        connMgr = DBConnectionManager.getInstance();
    }
    
    /**
     * Ư�� ���ڵ带 Bean�� �����Ͽ� Bean�� �����ϴ� �޼ҵ�
     */
	/**
     * �ڵ������
     */
    private CarRegBean makeCarRegBean(ResultSet results) throws DatabaseException {

        try {
            CarRegBean bean = new CarRegBean();

		    bean.setCar_mng_id(results.getString("CAR_MNG_ID")); 					//�ڵ���������ȣ
			bean.setCar_no(results.getString("CAR_NO")); 						//������ȣ
			bean.setCar_num(results.getString("CAR_NUM")); 					//�����ȣ
			bean.setInit_reg_dt(results.getString("INIT_REG_DT")); 				//���ʵ����
			bean.setCar_kd(results.getString("CAR_KD")); 						//����
			bean.setCar_use(results.getString("CAR_USE")); 					//�뵵
			bean.setCar_nm(results.getString("CAR_NM")); 						//����
			bean.setCar_form(results.getString("CAR_FORM")); 					//���� 
			bean.setCar_y_form(results.getString("CAR_Y_FORM")); 					//����
			bean.setMot_form(results.getString("MOT_FORM")); 					//����������
			bean.setDpm(results.getString("DPM")); 						//���_��ⷮ
			bean.setTaking_p(results.getInt("TAKING_P")); 					//���_��������
			bean.setTire(results.getString("TIRE")); 						//���_Ÿ�̾�
			bean.setFuel_kd(results.getString("FUEL_KD")); 					//���_����������
			bean.setConti_rat(results.getString("CONTI_RAT")); 					//���_����
			bean.setMort_st(results.getString("MORT_ST")); 					//�����_����
			bean.setMort_dt(results.getString("MORT_DT")); 					//�����_����
			bean.setLoan_st(results.getString("LOAN_ST")); 					//��ϼ�����_��ä����
			bean.setLoan_b_amt(results.getInt("LOAN_B_AMT")); 					//��ϼ�����_��ä���Խ�
			bean.setLoan_s_amt(results.getInt("LOAN_S_AMT")); 					//��ϼ�����_��ä���ν�
			bean.setLoan_s_rat(results.getString("LOAN_S_RAT")); 					//��ϼ�����_��ä������
			bean.setReg_amt(results.getInt("REG_AMT")); 					//��ϼ�����_��ϼ�
			bean.setAcq_amt(results.getInt("ACQ_AMT")); 					//��ϼ�����_��漼
			bean.setNo_m_amt(results.getInt("NO_M_AMT")); 					//��ϼ�����_��ȣ�����ۺ�
			bean.setStamp_amt(results.getInt("STAMP_AMT")); 					//��ϼ�����_��������
			bean.setEtc(results.getInt("ETC")); 						//��ϼ�����_��Ÿ
			bean.setMaint_st_dt(results.getString("MAINT_ST_DT")); 				//�˻���ȿ�Ⱓ1
			bean.setMaint_end_dt(results.getString("MAINT_END_DT")); 				//�˻���ȿ�Ⱓ2
			bean.setFirst_car_no(results.getString("FIRST_CAR_NO")); 					//��������ȣ
			bean.setCha_no2(results.getString("CHA_NO2")); 					//��������ȣ2
			bean.setCar_end_dt(results.getString("CAR_END_DT")); 					//���ɸ�����
			bean.setTest_st_dt(results.getString("TEST_ST_DT")); 					//������ȿ�Ⱓ1
			bean.setTest_end_dt(results.getString("TEST_END_DT")); 				//������ȿ�Ⱓ2
			bean.setAcq_std(results.getString("ACQ_STD")); 					//��漼_����ǥ��
			bean.setAcq_acq(results.getInt("ACQ_ACQ")); 					//��漼_��漼
			bean.setAcq_f_dt(results.getString("ACQ_F_DT")); 					//��漼_��������
			bean.setAcq_ex_dt(results.getString("ACQ_EX_DT")); 					//��漼_��������
			bean.setAcq_re(results.getString("ACQ_RE")); 						//��漼_����ó
			bean.setAcq_is_p(results.getString("ACQ_IS_P")); 					//��漼_�������߱���
			bean.setAcq_is_o(results.getString("ACQ_IS_O")); 					//��漼_�߱�ó
			bean.setReg_dt(results.getString("REG_DT")); 						//�ۼ�����
			bean.setReg_nm(results.getString("REG_NM")); 						//�ۼ���
			bean.setGuar_gen_y(results.getString("GUAR_GEN_Y"));				//�Ϲݼ�����(��)
			bean.setGuar_gen_km(results.getString("GUAR_GEN_KM"));				//�Ϲݼ�����(��)
			bean.setGuar_endur_y(results.getString("GUAR_ENDUR_Y"));				//�Ϲݼ�����(��)
			bean.setGuar_endur_km(results.getString("GUAR_ENDUR_KM"));				//�Ϲݼ�����(��)
			bean.setCar_ext(results.getString("CAR_EXT"));							//����
			bean.setCar_doc_no(results.getString("CAR_DOC_NO"));					//�����������ȣ
			bean.setReg_pay_dt(results.getString("REG_PAY_DT"));					//��Ϻ��������
			bean.setCar_a_yn(results.getString("CAR_A_YN"));						//��ǥ��������
			bean.setMax_kg(results.getString("max_kg"));							//�ִ����緮
			bean.setPrepare(results.getString("prepare"));
			bean.setOff_ls(results.getString("off_ls"));
			bean.setPark(results.getString("park"));
			bean.setSecondhand_dt(results.getString("secondhand_dt"));
			bean.setReg_amt_card(results.getString("reg_amt_card"));
			bean.setNo_amt_card(results.getString("no_amt_card"));
			bean.setGps(results.getString("gps"));
			bean.setAcq_amt_card(results.getString("acq_amt_card"));
			bean.setDist_cng(results.getString("dist_cng"));
			bean.setSecondhand(results.getString("secondhand"));
			bean.setImport_car_amt(results.getInt("import_car_amt")); 				//������-��������
			bean.setImport_tax_amt(results.getInt("import_tax_amt")); 				//������-����
			bean.setImport_tax_dt(results.getString("import_tax_dt")); 				//������-�����Ű�����
			bean.setImport_spe_tax_amt(results.getInt("import_spe_tax_amt")); 		//������-����
			bean.setCar_end_yn(results.getString("car_end_yn"));                    //���ɿ��� �Ϸ� ���� - 2ȸ����Ϸ�
			bean.setSpe_dc_st		(results.getString("spe_dc_st"));               //Ư�����ο���
			bean.setSpe_dc_cau		(results.getString("spe_dc_cau"));              //Ư�����λ���
			bean.setSpe_dc_per		(results.getFloat("spe_dc_per"));               //Ư������ �뿩��DC
			bean.setSpe_dc_s_dt		(results.getString("spe_dc_s_dt"));               //Ư�����α��ѽ�����
			bean.setSpe_dc_d_dt		(results.getString("spe_dc_d_dt"));               //Ư�����α���������
			bean.setNcar_spe_dc_cau(results.getString("ncar_spe_dc_cau"));              //�����μ��ź� Ư������ ����
			bean.setNcar_spe_dc_amt(results.getInt("ncar_spe_dc_amt")); 				//�����μ��ź� Ư������ ����
			bean.setNcar_spe_dc_day(results.getInt("ncar_spe_dc_day")); 				//�����μ��ź� Ư������ ����
			bean.setNcar_spe_dc_dt (results.getString("ncar_spe_dc_dt"));               //�����μ��ź� Ư������ ����
			bean.setCar_length(results.getInt("car_length")); 						//����-����
			bean.setCar_width(results.getInt("car_width")); 						//����-�ʺ�
		    
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}	
	/**
     * ������������
     */
    private CarMaintBean makeCarMaintBean(ResultSet results) throws DatabaseException {

        try {
            CarMaintBean bean = new CarMaintBean();

			    bean.setCar_mng_id(results.getString("CAR_MNG_ID")); 					//�ڵ���������ȣ
				bean.setSeq_no(results.getInt("SEQ_NO"));				//SEQ_NO
				bean.setChe_kd(results.getString("CHE_KD"));				//��������
				bean.setChe_st_dt(results.getString("CHE_ST_DT"));			//����������ȿ�Ⱓ1
				bean.setChe_end_dt(results.getString("CHE_END_DT"));			//����������ȿ�Ⱓ2
				bean.setChe_dt(results.getString("CHE_DT"));				//����������������
				bean.setChe_no(results.getString("CHE_NO"));				//�ǽ��ڰ�����ȣ
				bean.setChe_comp(results.getString("CHE_COMP"));				//�ǽ��ھ�ü��
				bean.setChe_amt(results.getInt("CHE_AMT"));				//�ǽú��ݾ� //�߰� 2004.01.07.
				bean.setChe_km(results.getInt("CHE_KM"));				//�ǽú��ݾ� //�߰� 2004.01.13.		
			   bean.setChe_remark(results.getString("CHE_REMARK"));				//Ư�̻���  //�߰� 2004.01.13.		
		
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}
	/**
     * ������ġ����
     */
    private CarChaBean makeCarChaBean(ResultSet results) throws DatabaseException {

        try {
            CarChaBean bean = new CarChaBean();

		    bean.setCar_mng_id	(results.getString("CAR_MNG_ID")); 			//�ڵ���������ȣ
			bean.setSeq_no		(results.getInt   ("SEQ_NO"));				//SEQ_NO
			bean.setCha_item	(results.getString("CHA_ITEM"));			//������ġ�������_����
			bean.setCha_st_dt	(results.getString("CHA_ST_DT"));			//�����˻�����1
			bean.setCha_end_dt	(results.getString("CHA_END_DT"));			//�����˻�����2
			bean.setCha_nm		(results.getString("CHA_NM"));				//�����˻�å����
			bean.setCha_st		(results.getString("CHA_ST"));
			bean.setCha_amt		(results.getInt   ("CHA_AMT"));
			bean.setCha_v_amt	(results.getInt   ("CHA_V_AMT"));
			bean.setOff_nm		(results.getString("OFF_NM"));   //�����ü
			bean.setB_dist		(results.getInt   ("B_DIST"));    //��ü�� ����Ÿ�
		    
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}
	/**
     * �ڵ�����Ϲ�ȣ ���� ���
     */
    private CarHisBean makeCarHisBean(ResultSet results) throws DatabaseException {

        try {
            CarHisBean bean = new CarHisBean();

		    bean.setCar_mng_id(results.getString("CAR_MNG_ID")); 					//�ڵ���������ȣ
			bean.setCha_seq(results.getString("CHA_SEQ"));								
			bean.setCha_dt(results.getString("CHA_DT"));								
			bean.setCha_cau(results.getString("CHA_CAU"));								
			bean.setCha_cau_sub(results.getString("CHA_CAU_SUB"));								
			bean.setCha_car_no(results.getString("CAR_NO"));
			bean.setReg_id(results.getString("REG_ID"));
			bean.setReg_dt(results.getString("REG_DT"));
			bean.setUse_yn(results.getString("USE_YN"));
			bean.setScanfile(results.getString("SCANFILE"));
			bean.setFile_type(results.getString("FILE_TYPE"));

			
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}	

	/**
     * ����ǵ��
     */
    private CarMortBean makeCarMortBean(ResultSet results) throws DatabaseException {

        try {
            CarMortBean bean = new CarMortBean();

		    bean.setCar_mng_id(results.getString("CAR_MNG_ID")); 					//�ڵ���������ȣ
			bean.setSeq_no(results.getInt("SEQ_NO"));				//SEQ_NO
			bean.setMort_st(results.getString("MORT_ST"));			//������ġ�������_����
			bean.setMort_dt(results.getString("MORT_DT"));			//�����˻�����1
			
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}	
	/**
     * ����
     */
    private InsurBean makeInsurBean(ResultSet results) throws DatabaseException {

        try {
            InsurBean bean = new InsurBean();

		    bean.setCar_mng_id(results.getString("CAR_MNG_ID")); 					//�ڵ���������ȣ
			bean.setIns_st(results.getString("INS_ST")); 			//���豸��
			bean.setIns_sts(results.getString("INS_STS")); 			//����
			bean.setAge_scp(results.getString("AGE_SCP")); 			//���ɹ���
			bean.setCar_use(results.getString("CAR_USE")); 			//�����뵵
			bean.setIns_com_id(results.getString("INS_COM_ID")); 			//����ȸ��
			bean.setIns_con_no(results.getString("INS_CON_NO")); 			//�������ȣ
			bean.setConr_nm(results.getString("CONR_NM")); 			//�����
			bean.setIns_start_dt(results.getString("INS_START_DT")); 			//���������
			bean.setIns_exp_dt(results.getString("INS_EXP_DT")); 			//���踸����
			bean.setRins_pcp_amt(results.getInt("RINS_PCP_AMT")); 			//å�Ӻ���_���ι��_����
			bean.setVins_pcp_amt(results.getInt("VINS_PCP_AMT")); 			//���Ǻ���_���ι��_����
			bean.setVins_pcp_kd(results.getString("VINS_PCP_KD")); 			//���Ǻ���_���ι��_����
			bean.setVins_gcp_amt(results.getInt("VINS_GCP_AMT")); 			//���Ǻ���_�빰���_����
			bean.setVins_gcp_kd(results.getString("VINS_GCP_KD")); 			//���Ǻ���_�빰���_����
			bean.setVins_bacdt_amt(results.getInt("VINS_BACDT_AMT")); 			//���Ǻ���_�ڱ��ü���_����
			bean.setVins_bacdt_kd(results.getString("VINS_BACDT_KD")); 			//���Ǻ���_�ڱ��ü���_����
			bean.setVins_cacdt_amt(results.getInt("VINS_CACDT_AMT")); 			//���Ǻ���_�ڱ���������_����(������å��)
			bean.setVins_canoisr_amt(results.getInt("VINS_CANOISR_AMT"));			//���Ǻ���_������������_����
			bean.setVins_cacdt_car_amt(results.getInt("VINS_CACDT_CAR_AMT"));		//���Ǻ���_�ڱ���������_����_����
			bean.setVins_cacdt_me_amt(results.getInt("VINS_CACDT_ME_AMT"));			//���Ǻ���_�ڱ���������_�ڱ�δ��_����
			bean.setVins_cacdt_cm_amt(results.getInt("VINS_CACDT_CM_AMT"));			//���Ǻ���_�ڱ��������ر�(����+�ڱ�δ��)
			bean.setPay_tm(results.getString("PAY_TM")); 			//����Ƚ��
			bean.setChange_dt(results.getString("CHANGE_DT")); 			//����ắ����
			bean.setChange_cau(results.getString("CHANGE_CAU")); 			//����ắ�����
			bean.setChange_itm_kd1(results.getString("CHANGE_ITM_KD1")); 			//����ắ���׸�1_����
			bean.setChange_itm_amt1(results.getInt("CHANGE_ITM_AMT1")); 			//����ắ���׸�1_����
			bean.setChange_itm_kd2(results.getString("CHANGE_ITM_KD2")); 			//����ắ���׸�2_����
			bean.setChange_itm_amt2(results.getInt("CHANGE_ITM_AMT2")); 			//����ắ���׸�2_����
			bean.setChange_itm_kd3(results.getString("CHANGE_ITM_KD3")); 			//����ắ���׸�3_����
			bean.setChange_itm_amt3(results.getInt("CHANGE_ITM_AMT3")); 			//����ắ���׸�3_����
			bean.setChange_itm_kd4(results.getString("CHANGE_ITM_KD4")); 			//����ắ���׸�4_����
			bean.setChange_itm_amt4(results.getInt("CHANGE_ITM_AMT4")); 			//����ắ���׸�4_����
			bean.setCar_rate(results.getString("CAR_RATE")); 			//���԰����
			bean.setIns_rate(results.getString("INS_RATE")); 			//������
			bean.setExt_rate(results.getString("EXT_RATE")); 			//����������
			bean.setAir_ds_yn(results.getString("AIR_DS_YN")); 			//���������_������
			bean.setAir_as_yn(results.getString("AIR_AS_YN")); 			//���������������
			bean.setAgnt_nm(results.getString("AGNT_NM")); 			//��������_�̸�
			bean.setAgnt_tel(results.getString("AGNT_TEL")); 			//��������_��ȭ��ȣ
			bean.setAgnt_imgn_tel(results.getString("AGNT_IMGN_TEL")); 			//��������_�����ȭ��ȣ
			bean.setAgnt_fax(results.getString("AGNT_FAX")); 			//	��������_FAX
			bean.setExp_dt(results.getString("EXP_DT")); 			//��������
			bean.setExp_cau(results.getString("EXP_CAU")); 			//��������
			bean.setRtn_amt(results.getInt("RTN_AMT")); 			//����ȯ�ޱ�
			bean.setRtn_dt(results.getString("RTN_DT")); 			//����ȯ������
		    
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}
    /**
     * ���轺����
     */
    private ScdInsBean makeScdInsBean(ResultSet results) throws DatabaseException {

        try {
            ScdInsBean bean = new ScdInsBean();

		    bean.setCar_mng_id	(results.getString("CAR_MNG_ID")); 		//�ڵ���������ȣ
			bean.setIns_st		(results.getString("INS_ST"));			//���豸��
			bean.setIns_tm		(results.getString("INS_TM"));			//ȸ��
			bean.setIns_est_dt	(results.getString("INS_EST_DT"));		//���ο�����
			bean.setPay_amt		(results.getString("PAY_AMT"));			//���αݾ�
			bean.setPay_yn		(results.getString("PAY_YN"));			//���ο���
			bean.setPay_dt		(results.getString("PAY_DT"));			//�ǳ�����
            
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

}
/**
     * �ڵ��� ��� ����Ʈ ( 2001/12/28 ) - Kim JungTae
     */
    private RentListBean makeRegListBean(ResultSet results) throws DatabaseException {

        try {
            RentListBean bean = new RentListBean();

		    bean.setRent_mng_id		(results.getString("RENT_MNG_ID"));					//������ID
		    bean.setRent_l_cd		(results.getString("RENT_L_CD"));					//����ڵ�
		    bean.setRent_dt			(results.getString("RENT_DT"));						//�������
		    bean.setDlv_dt			(results.getString("DLV_DT"));						//�������
		    bean.setDlv_est_dt		(results.getString("DLV_EST_DT"));					//���������
		    bean.setClient_id		(results.getString("CLIENT_ID"));					//��ID
		    bean.setClient_nm		(results.getString("CLIENT_NM"));					//�� ��ǥ�ڸ�
		    bean.setFirm_nm			(results.getString("FIRM_NM"));						//��ȣ
		    bean.setO_tel			(results.getString("O_TEL"));						//�繫����ȭ
		    bean.setFax				(results.getString("FAX"));							//FAX
		    bean.setBr_id			(results.getString("BR_ID"));						//
		    bean.setCar_mng_id		(results.getString("CAR_MNG_ID"));					//�ڵ�������ID
		    bean.setInit_reg_dt		(results.getString("INIT_REG_DT"));					//���ʵ����
		    bean.setReg_gubun		(results.getString("REG_GUBUN"));					//���ʵ����
		    bean.setCar_no			(results.getString("CAR_NO"));						//������ȣ
		    bean.setCar_num			(results.getString("CAR_NUM"));						//�����ȣ
		    bean.setR_st			(results.getString("R_ST"));
		    bean.setRent_way		(results.getString("RENT_WAY"));					//�뿩���
		    bean.setCon_mon			(results.getString("CON_MON"));						//�뿩����
		    bean.setCar_id			(results.getString("CAR_ID"));						//����ID
		    bean.setImm_amt			(results.getInt("IMM_AMT"));						//������å��
		    bean.setCar_name		(results.getString("CAR_NAME"));					//����
		    bean.setCar_nm			(results.getString("CAR_NM"));
		    bean.setRent_start_dt	(results.getString("RENT_START_DT"));				//�뿩������
		    bean.setRent_end_dt		(results.getString("RENT_END_DT"));					//�뿩������
		    bean.setReg_ext_dt		(results.getString("REG_EXT_DT"));					//��Ͽ�����
		    bean.setRpt_no			(results.getString("RPT_NO"));						//�����ȣ
		    bean.setCpt_cd			(results.getString("CPT_CD"));						//�����ڵ�
		    bean.setReg_id			(results.getString("REG_ID"));
		    bean.setCar_end_dt		(results.getString("CAR_END_DT"));					//���ɸ�����
		    bean.setCar_ext			(results.getString("CAR_EXT"));						//�������
		    bean.setCar_st			(results.getString("CAR_ST"));	
		    bean.setBus_nm			(results.getString("bus_nm"));	
			bean.setCar_doc_no		(results.getString("car_doc_no"));	
			bean.setMigr_dt			(results.getString("migr_dt"));	
			bean.setOff_ls			(results.getString("OFF_LS"));	
			bean.setEmp_nm			(results.getString("emp_nm"));						//��������� �ٸ� �뵵�� - ���ɰ˻��� ���ؼ� 
			bean.setRrm				(results.getString("rrm"));							//����Ʈ
			bean.setCar_end_yn		(results.getString("CAR_END_YN"));					//���ɸ��Ῥ�����Ῡ��
			bean.setPrepare			(results.getString("PREPARE"));						//����������
			bean.setJg_g_16			(results.getString("jg_g_16"));
			bean.setEnd_req_dt		(results.getString("end_req_dt"));
		    
            return bean;
        }catch (SQLException e) {
			System.out.println(e);
			throw new DatabaseException(e.getMessage());
        }

	}
	
	/**
     * �ڵ��� ��� ����Ʈ - �����ǥ
     */
    private RentListBean makeRegListBean3(ResultSet results) throws DatabaseException {

        try {
            RentListBean bean = new RentListBean();

		    bean.setRent_mng_id(results.getString("RENT_MNG_ID"));					//������ID
		    bean.setRent_l_cd(results.getString("RENT_L_CD"));					//����ڵ�
		    bean.setRent_dt(results.getString("RENT_DT"));					//�������
		    bean.setDlv_dt(results.getString("DLV_DT"));					//�������
		    bean.setDlv_est_dt(results.getString("DLV_EST_DT"));					//���������
		    bean.setClient_id(results.getString("CLIENT_ID"));					//��ID
		    bean.setClient_nm(results.getString("CLIENT_NM"));					//�� ��ǥ�ڸ�
		    bean.setFirm_nm(results.getString("FIRM_NM"));						//��ȣ
		    bean.setO_tel(results.getString("O_TEL"));						//�繫����ȭ
		    bean.setFax(results.getString("FAX"));						//FAX
		    bean.setBr_id(results.getString("BR_ID"));						//
		    bean.setCar_mng_id(results.getString("CAR_MNG_ID"));					//�ڵ�������ID
		    bean.setInit_reg_dt(results.getString("INIT_REG_DT"));					//���ʵ����
		    bean.setReg_gubun(results.getString("REG_GUBUN"));					//���ʵ����
		    bean.setCar_no(results.getString("CAR_NO"));						//������ȣ
		    bean.setCar_num(results.getString("CAR_NUM"));						//�����ȣ
		    bean.setR_st(results.getString("R_ST"));
		    bean.setRent_way(results.getString("RENT_WAY"));					//�뿩���
		    bean.setCon_mon(results.getString("CON_MON"));						//�뿩����
		    bean.setCar_id(results.getString("CAR_ID"));						//����ID
		    bean.setImm_amt(results.getInt("IMM_AMT"));						//������å��
		    bean.setCar_name(results.getString("CAR_NAME"));					//����
		    bean.setCar_nm(results.getString("CAR_NM"));
		    bean.setRent_start_dt(results.getString("RENT_START_DT"));				//�뿩������
		    bean.setRent_end_dt(results.getString("RENT_END_DT"));					//�뿩������
		    bean.setReg_ext_dt(results.getString("REG_EXT_DT"));					//��Ͽ�����
		    bean.setRpt_no(results.getString("RPT_NO"));						//�����ȣ
		    bean.setCpt_cd(results.getString("CPT_CD"));						//�����ڵ�
		    bean.setReg_id(results.getString("REG_ID"));
		    bean.setBr_id(results.getString("BRCH_ID"));
		    bean.setCar_end_dt(results.getString("CAR_END_DT"));					//���ɸ�����
		    bean.setCar_ext(results.getString("CAR_EXT"));					//�������
		    bean.setReg_amt(results.getInt("REG_AMT"));					//��ϱݾ�
		    bean.setAcq_amt(results.getInt("ACQ_AMT"));					//��漼
		    bean.setNo_m_amt(results.getInt("NO_M_AMT"));					//��ȣ���ۺ�
		    bean.setCar_a_yn(results.getString("CAR_A_YN"));				//��ǥ
		    bean.setReg_amt_card(results.getString("REG_AMT_CARD"));			//��ϼ� ī��ó��
		    bean.setNo_amt_card(results.getString("NO_AMT_CARD"));				//��ȣ�Ǵ� ī��ó��
		    bean.setBus_nm(results.getString("BUS_NM"));				//���ʰ����
		    bean.setSh_base_dt(results.getString("SH_BASE_DT"));					//�߰��� 
		    
		    bean.setEtc(results.getInt("ETC"));				//��Ÿ��� 
		    bean.setLoan_s_amt(results.getInt("LOAN_S_AMT"));				//��ä���ν�
            return bean;
        }catch (SQLException e) {
			System.out.println(e);
			throw new DatabaseException(e.getMessage());
        }

	}
	
	/**
     * �ڵ��� ��� ����Ʈ ( 2003/1/3) - ������
     */
    private RentListBean makeRegListBean2(ResultSet results) throws DatabaseException {

        try {
            RentListBean bean = new RentListBean();

		    bean.setRent_mng_id(results.getString("RENT_MNG_ID"));					//������ID
		    bean.setRent_l_cd(results.getString("RENT_L_CD"));					//����ڵ�
		    bean.setRent_dt(results.getString("RENT_DT"));					//�������
		    bean.setDlv_dt(results.getString("DLV_DT"));					//�������
		    bean.setDlv_est_dt(results.getString("DLV_EST_DT"));					//���������
		    bean.setClient_id(results.getString("CLIENT_ID"));					//��ID
		    bean.setClient_nm(results.getString("CLIENT_NM"));					//�� ��ǥ�ڸ�
		    bean.setFirm_nm(results.getString("FIRM_NM"));						//��ȣ
		    bean.setO_tel(results.getString("O_TEL"));						//�繫����ȭ
		    bean.setFax(results.getString("FAX"));						//FAX
		    bean.setBr_id(results.getString("BR_ID"));						//
		    bean.setCar_mng_id(results.getString("CAR_MNG_ID"));					//�ڵ�������ID
		    bean.setInit_reg_dt(results.getString("INIT_REG_DT"));					//���ʵ����
		    bean.setReg_gubun(results.getString("REG_GUBUN"));					//���ʵ����
		    bean.setCar_no(results.getString("CAR_NO"));						//������ȣ
		    bean.setCar_num(results.getString("CAR_NUM"));						//�����ȣ
		    bean.setR_st(results.getString("R_ST"));
		    bean.setRent_way(results.getString("RENT_WAY"));					//�뿩���
		    bean.setCon_mon(results.getString("CON_MON"));						//�뿩����
		    bean.setCar_id(results.getString("CAR_ID"));						//����ID
		    bean.setImm_amt(results.getInt("IMM_AMT"));						//������å��
		    bean.setCar_name(results.getString("CAR_NAME"));					//����
		    bean.setCar_nm(results.getString("CAR_NM"));
		    bean.setRent_start_dt(results.getString("RENT_START_DT"));				//�뿩������
		    bean.setRent_end_dt(results.getString("RENT_END_DT"));					//�뿩������
		    bean.setReg_ext_dt(results.getString("REG_EXT_DT"));					//��Ͽ�����
		    bean.setRpt_no(results.getString("RPT_NO"));						//�����ȣ
		    bean.setCpt_cd(results.getString("CPT_CD"));						//�����ڵ�
		    bean.setReg_id(results.getString("REG_ID"));
		    bean.setCha_seq(results.getString("CHA_SEQ"));
            return bean;
        }catch (SQLException e) {
			System.out.println(e);
            throw new DatabaseException(e.getMessage());
        }

	}

    /**
     * ������, �ڵ��� ��� ����Ʈ ��ȸ ( 2002/1/3 ) - Kim JungTae
     */
    public RentListBean [] getRegListAll( String st, String ref_dt1, String ref_dt2, String gubun, String gubun_nm, String q_sort_nm, String q_sort ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String subQuery = "";
        String gubunQuery = "";
        String sortQuery = "";
        
        String query = "";
        
        if(st.equals("1")){
        	subQuery = "and a.car_mng_id is null and a.dlv_dt is not null\n";
        }else if(st.equals("2")){
        	subQuery = "and a.car_mng_id is not null\n";
        }else if(st.equals("3")){
        	subQuery = "and a.car_mng_id is null and a.dlv_dt is null\n";
        }else{
        	subQuery = "";
        }

        if(gubun.equals("firm_nm"))
        {
        	gubunQuery = "and (nvl(c.firm_nm,' ') like '%" + gubun_nm + "%' or nvl(c.client_nm,' ') like '%" + gubun_nm + "%')\n";
        }else if(gubun.equals("client_nm")){
        	gubunQuery = "and nvl(c.client_nm,' ') like '%" + gubun_nm + "%'\n";
        }else if(gubun.equals("car_no")){
        	gubunQuery = "and nvl(b.car_no,' ') like '%" + gubun_nm + "%'\n";
        }else if(gubun.equals("car_nm")){
        	gubunQuery = "and nvl(h.car_name,' ') like '%" + gubun_nm + "%'\n";
        }else if(gubun.equals("dlv_dt")){
        	gubunQuery = "and a.dlv_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 +"','-','')\n";
        }else if(gubun.equals("init_reg_dt")){
        	gubunQuery = "and b.init_reg_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 +"','-','')\n";
		}else if(gubun.equals("brch_id")){
        	gubunQuery = "and nvl(a.brch_id,' ') like '%" + gubun_nm +"%'\n";
        }else if(gubun.equals("rent_l_cd")){
        	gubunQuery = "and nvl(a.rent_l_cd,' ') like '%" + gubun_nm +"%'\n";
        }else if(gubun.equals("car_num")){
        	gubunQuery = "and nvl(b.car_num,' ') like '%" + gubun_nm +"%'\n";
        }else if(gubun.equals("emp_nm")){
        	gubunQuery = "and nvl(l.emp_nm,' ') like '%" + gubun_nm +"%'\n";
        }else{
        	gubunQuery = "and b.car_mng_id=''\n";
        }
        /* ���� */
        if (!st.equals("3")) {
        	if(q_sort_nm.equals("firm_nm"))
        	{
        		sortQuery = "order by c.firm_nm " + q_sort + "\n";
        	}else if(q_sort_nm.equals("car_no")){
        		sortQuery = "order by b.car_no " + q_sort + "\n";
        	}else if(q_sort_nm.equals("dlv_dt")){
        		sortQuery = "order by a.dlv_dt " + q_sort + "\n";
        	}else if(q_sort_nm.equals("init_reg_dt")){
        		sortQuery = "order by b.init_reg_dt " + q_sort + "\n";
        	}else if(q_sort_nm.equals("car_nm")){
        		sortQuery = "order by h.car_name " + q_sort + "\n";
        	}else if(q_sort_nm.equals("emp_nm")){
        		sortQuery = "order by l.emp_nm " + q_sort + "\n";
        	}else{
        		sortQuery = "order by b.init_reg_dt, c.firm_nm " + q_sort + "\n";
        	}
        }else{
        	if(q_sort_nm.equals("firm_nm"))
        	{
        		sortQuery = "order by f.dlv_est_dt, c.firm_nm " + q_sort + "\n";
        	}else if(q_sort_nm.equals("car_no")){
        		sortQuery = "order by f.dlv_est_dt, b.car_no " + q_sort + "\n";
        	}else if(q_sort_nm.equals("dlv_dt")){
        		sortQuery = "order by f.dlv_est_dt, a.dlv_dt " + q_sort + "\n";
        	}else if(q_sort_nm.equals("init_reg_dt")){
        		sortQuery = "order by f.dlv_est_dt, b.init_reg_dt " + q_sort + "\n";
        	}else if(q_sort_nm.equals("car_nm")){
        		sortQuery = "order by f.dlv_est_dt, h.car_name " + q_sort + "\n";
        	}else if(q_sort_nm.equals("emp_nm")){
        		sortQuery = "order by f.dlv_est_dt, l.emp_nm " + q_sort + "\n";
        	}else{
        		sortQuery = "order by dlv_est_dt, b.init_reg_dt, c.firm_nm " + q_sort + "\n";
        	}
		}        
        						
        query = "select  a.car_st, a.brch_id, a.rent_mng_id as RENT_MNG_ID, a.rent_l_cd as RENT_L_CD, decode(a.rent_dt,null,'',substr(a.rent_dt,1,4)||'-'||substr(a.rent_dt,5,2)||'-'||substr(a.rent_dt,7,2)) as RENT_DT, decode(a.dlv_dt,null,'',substr(a.dlv_dt,1,4)||'-'||substr(a.dlv_dt,5,2)||'-'||substr(a.dlv_dt,7,2)) as DLV_DT, a.client_id as CLIENT_ID,a.reg_id as REG_ID,\n" 
        + "c.client_nm as CLIENT_NM, nvl(c.firm_nm,c.client_nm) as FIRM_NM,c.o_tel as O_TEL,c.fax as FAX,e.br_id as BR_ID, e.user_nm as bus_nm, \n" 
		+ "b.car_mng_id as CAR_MNG_ID, nvl2(b.init_reg_dt,substr(b.init_reg_dt,1,4)||'-'||substr(b.init_reg_dt,5,2)||'-'||substr(b.init_reg_dt,7,2),'') as INIT_REG_DT, nvl2(b.init_reg_dt,'ud','id') as REG_GUBUN, nvl2(b.car_no,b.car_no,nvl2(a.dlv_dt,'�̵��','�����')) as CAR_NO, b.car_num as CAR_NUM,\n"
		+ "d.rent_st as R_ST,d.rent_way as RENT_WAY,nvl(d.con_mon,'-') as CON_MON, decode(d.rent_start_dt,null,'',substr(d.rent_start_dt,1,4)||'-'||substr(d.rent_start_dt,5,2)||'-'||substr(d.rent_start_dt,7,2)) as RENT_START_DT, decode(d.rent_end_dt,null,'',substr(d.rent_end_dt,1,4)||'-'||substr(d.rent_end_dt,5,2)||'-'||substr(d.rent_end_dt,7,2)) as RENT_END_DT,\n"
		+ "decode(f.dlv_est_dt,'','',substr(f.dlv_est_dt,1,4)||'-'||substr(f.dlv_est_dt,5,2)||'-'||substr(f.dlv_est_dt,7,2)) as DLV_EST_DT, g.car_id as CAR_ID, g.imm_amt as IMM_AMT, decode(f.reg_ext_dt,null,'',substr(f.reg_ext_dt,1,4)||'-'||substr(f.reg_ext_dt,5,2)||'-'||substr(f.reg_ext_dt,7,2)) as REG_EXT_DT, f.rpt_no as RPT_NO, h.car_name as CAR_NAME, j.car_nm as CAR_NM,\n"//
		+ "i.cpt_cd as CPT_CD,l.emp_nm, b.car_end_dt, b.car_doc_no, k.migr_dt , a.car_st rrm, decode(b.car_end_yn,'Y','��������','') car_end_yn, decode(b.prepare,'4','����','5','����','9','��ȸ��','') prepare, \n"
		+ " '' jg_g_16 , b.end_req_dt \n"
		+ "from cont a, car_reg b, client c, fee d, users e, car_pur f, car_etc g, allot i, car_nm h, car_mng j,\n"//--, code j
		+ "(select a.rent_mng_id,a.rent_l_cd,a.emp_id,a.agnt_st,b.emp_nm, b.car_off_id, c.car_off_nm,c.car_off_tel\n"
		+ " from commi a, car_off_emp b, car_off c\n" 
		+ " where a.agnt_st='2'\n"
		+ " and a.emp_id=b.emp_id\n"
		+ " and b.car_off_id=c.car_off_id) l, sui k \n"
		+ "where a.rent_mng_id like '%'\n"
		+ "and nvl(a.use_yn,'Y')='Y' and a.car_gu='1'\n"
		+ subQuery
		+ gubunQuery
		+ "and a.car_mng_id = b.car_mng_id(+)\n"
		+ "and a.client_id = c.client_id\n"
		+ "and d.rent_st='1' and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd\n"
		+ "and a.bus_id = e.user_id\n"
		+ "and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_mng_id = g.rent_mng_id and a.rent_l_cd = g.rent_l_cd\n"
		+ "and g.car_id = h.car_id(+) and h.car_comp_id=j.car_comp_id(+) and h.car_cd=j.code(+)\n"
		+ "and a.rent_mng_id = i.rent_mng_id and a.rent_l_cd = i.rent_l_cd \n"
		+ "and a.rent_mng_id = l.rent_mng_id(+) and a.rent_l_cd = l.rent_l_cd(+)\n"
		+ "and b.car_mng_id=k.car_mng_id(+)\n"
		+ sortQuery;

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
			con = null;
        }
        return (RentListBean[])col.toArray(new RentListBean[0]);
    }

    /**
     * ������, �ڵ��� ��� ����Ʈ ��ȸ - ������ ���� br_id, st, ref_dt1, ref_dt2, gubun, gubun_nm, q_sort_nm, q_sort
	 * - 2003.08.20 ��.(�ǿ��) :��ȸ�� getRegListAllCount()�� ��ġ�� �����ʾ� car_change ���̺� ����.  -- 9
     */
    public RentListBean [] getRegListAll2(String br_id, String st, String ref_dt1, String ref_dt2, String gubun, String gubun_nm, String gubun3, String q_sort_nm, String q_sort ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String subQuery = "";
        String gubunQuery = "";
        String sortQuery = "";
        
        String query = "";
        
        if(st.equals("1")){			subQuery = "and nvl(a.use_yn,'Y')='Y' and a.car_mng_id is null and a.dlv_dt is not null\n";			}
        else if(st.equals("2")){	subQuery = "and nvl(a.use_yn,'Y')='Y' and a.car_mng_id is not null and b.init_reg_dt is not null and nvl(b.prepare,'1')<>'4'\n";	}
        else if(st.equals("3")){	subQuery = "and nvl(a.use_yn,'Y')='Y' and a.car_mng_id is null and a.dlv_dt is null\n";				}
        else if(st.equals("4")){	subQuery = "and nvl(a.use_yn,'Y')='N' and s.cls_st ='6' and a.car_mng_id is not null\n";			}
        else if(st.equals("5")){	subQuery = "and nvl(a.use_yn,'Y')='N' and s.cls_st ='8' and a.car_mng_id is not null\n";			}
        else if(st.equals("6")){	subQuery = "and nvl(a.use_yn,'Y')='N' and s.cls_st ='9' and a.car_mng_id is not null\n";			}
        else if(st.equals("7")){	subQuery = "and nvl(a.use_yn,'Y')='Y' and b.prepare ='4'\n";										}
        else{        				subQuery = "and nvl(a.use_yn,'Y')='Y'";																}

        if(gubun.equals("firm_nm")){					gubunQuery = "and c.firm_nm||c.client_nm like '%" + gubun_nm + "%' \n";														}        
        else if(gubun.equals("client_nm")){				gubunQuery = "and c.client_nm like '%" + gubun_nm + "%'\n";																	}
        else if(gubun.equals("car_no")){				gubunQuery = "and b.car_no||b.first_car_no like '%" + gubun_nm + "%'\n";													}
        else if(gubun.equals("car_doc_no")){			gubunQuery = "and b.car_doc_no like '%" + gubun_nm + "%'\n";																}	//<--�߰�(2017.12.07)
        else if(gubun.equals("car_nm")){				gubunQuery = "and j.car_nm||h.car_name like '%" + gubun_nm + "%'\n";														}
        else if(gubun.equals("dlv_dt")){				gubunQuery = "and a.dlv_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 +"','-','')\n";				}
        else if(gubun.equals("init_reg_dt")){			gubunQuery = "and b.init_reg_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 +"','-','')\n";			}
        else if(gubun.equals("car_end_dt")){			gubunQuery = "and b.car_end_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 +"','-','')\n";			}
    	else if(gubun.equals("brch_id")){				gubunQuery = "and a.brch_id like '%" + gubun_nm +"%'\n";															}
    	else if(gubun.equals("car_ext")){				gubunQuery = "and decode(nvl(b.car_ext,g.car_ext),'1','����','2','����','3','�λ�','4','����','5','����','6','��õ','7','��õ','8','����','9','����','10','�뱸') like '%" + gubun_nm +"%'\n";	}
        else if(gubun.equals("rent_l_cd")){				gubunQuery = "and a.rent_l_cd like '%" + gubun_nm +"%'\n";															}
        else if(gubun.equals("car_num")){				gubunQuery = "and b.car_num like '%" + gubun_nm +"%'\n";															}
        else if(gubun.equals("emp_nm")){				gubunQuery = "and l.emp_nm like '%" + gubun_nm +"%'\n";															}
        else if(gubun.equals("rpt_no")){				gubunQuery = "and f.rpt_no like '%" + gubun_nm +"%'\n";															}
        else if(gubun.equals("fuel_kd")){				gubunQuery = "and m.nm like '%" + gubun_nm +"%'\n";										}
		else if(gubun.equals("gps")){					gubunQuery = "and b.gps='Y'\n";																								}
		else if(gubun.equals("bus_nm")){				gubunQuery = "and e.user_nm like '%" + gubun_nm +"%'\n";															}
		else if(gubun.equals("bus_nm2")){				gubunQuery = "and e2.user_nm like '%" + gubun_nm +"%'\n";															}
		else if(gubun.equals("mng_nm")){				gubunQuery = "and nvl(e3.user_nm,e2.user_nm) like '%" + gubun_nm +"%'\n";											}
		else if(gubun.equals("car_kd")){				gubunQuery = "and n.nm like '%" + gubun_nm +"%'\n";					}
        else{											gubunQuery = "and b.car_mng_id=''\n";																						}
        
        /* ���� */
        if (!st.equals("3") && !st.equals("1")){
        	if(q_sort_nm.equals("firm_nm")){			sortQuery = "order by c.firm_nm " + q_sort + "\n";				}
        	else if(q_sort_nm.equals("car_no")){		sortQuery = "order by b.car_no " + q_sort + "\n";								}
        	else if(q_sort_nm.equals("car_doc_no")){	sortQuery = "order by b.car_doc_no " + q_sort + "\n";							}	//<-- �߰�(2017.12.07)
        	else if(q_sort_nm.equals("dlv_dt")){		sortQuery = "order by a.dlv_dt " + q_sort + "\n";								}
        	else if(q_sort_nm.equals("init_reg_dt")){	sortQuery = "order by b.init_reg_dt " + q_sort + "\n";							}
        	else if(q_sort_nm.equals("car_end_dt")){	sortQuery = "order by decode(b.car_use,'1',decode(length(replace(b.car_end_dt,' ','')),8,b.car_end_dt,decode(sign(b.dpm-2000),1,to_char(to_date(b.init_reg_dt,'YYYYMMDD')+(365*8),'YYYYMMDD'),to_char(to_date(b.init_reg_dt,'YYYYMMDD')+(365*5),'YYYYMMDD')))) " + q_sort + "\n";							}
        	else if(q_sort_nm.equals("car_nm")){		sortQuery = "order by j.car_nm||h.car_name " + q_sort + "\n";					}
        	else if(q_sort_nm.equals("emp_nm")){		sortQuery = "order by l.emp_nm " + q_sort + "\n";								}
        	else if(q_sort_nm.equals("car_ext")){		sortQuery = "order by b.car_ext " + q_sort + "\n";								}	
        	else{										sortQuery = "order by b.init_reg_dt, c.firm_nm " + q_sort + "\n";				}        	
        }else{
        	if(q_sort_nm.equals("firm_nm")){			sortQuery = "order by g.car_ext, f.dlv_est_dt, c.firm_nm " + q_sort + "\n";					}
        	else if(q_sort_nm.equals("car_no")){		sortQuery = "order by g.car_ext, f.dlv_est_dt, b.car_no " + q_sort + "\n";					}
        	else if(q_sort_nm.equals("car_doc_no")){	sortQuery = "order by g.car_ext, f.dlv_est_dt, b.car_doc_no " + q_sort + "\n";				}	//<-- �߰�(2017.12.07)
        	else if(q_sort_nm.equals("dlv_dt")){		sortQuery = "order by g.car_ext, f.dlv_est_dt, a.dlv_dt " + q_sort + "\n";					}
        	else if(q_sort_nm.equals("init_reg_dt")){	sortQuery = "order by g.car_ext, f.dlv_est_dt, b.init_reg_dt " + q_sort + "\n";				}
      		else if(q_sort_nm.equals("car_end_dt")){	sortQuery = "order by g.car_ext, f.dlv_est_dt, b.car_end_dt " + q_sort + "\n";				}
        	else if(q_sort_nm.equals("car_nm")){		sortQuery = "order by g.car_ext, f.dlv_est_dt, h.car_name " + q_sort + "\n";				}
        	else if(q_sort_nm.equals("emp_nm")){		sortQuery = "order by g.car_ext, f.dlv_est_dt, l.emp_nm " + q_sort + "\n";					}
        	else if(q_sort_nm.equals("car_ext")){		sortQuery = "order by g.car_ext, f.dlv_est_dt, b.car_ext " + q_sort + "\n";					}
        	else{										sortQuery = "order by g.car_ext, f.dlv_est_dt, b.init_reg_dt, c.firm_nm " + q_sort + "\n";	}        	
		}        

		if(gubun3.equals("3")){	
			subQuery = "and v2.jg_g_16='1'\n";	
		}else{
	        if(!gubun3.equals("")){			subQuery += "and decode(b.car_use,'',decode(a.car_st,'1','1','3','2'),b.car_use)='"+gubun3+"'";			}
		}

		if(gubun.equals("car_no")){
	        query = " select   "+
					" decode(b.car_use,'',decode(a.car_st,'1','��Ʈ','3','����','2','����','5','�����뿩'),'1','��Ʈ','2','����') car_st, "+
				    " nvl(b.car_ext, g.car_ext) car_ext, a.brch_id, a.rent_mng_id as RENT_MNG_ID, a.rent_l_cd as RENT_L_CD, decode(a.rent_dt,null,'',substr(a.rent_dt,1,4)||'-'||substr(a.rent_dt,5,2)||'-'||substr(a.rent_dt,7,2)) as RENT_DT, decode(a.dlv_dt,null,'',substr(a.dlv_dt,1,4)||'-'||substr(a.dlv_dt,5,2)||'-'||substr(a.dlv_dt,7,2)) as DLV_DT, a.client_id as CLIENT_ID,a.reg_id as REG_ID,\n" 
		    + "c.client_nm as CLIENT_NM, nvl(c.firm_nm,c.client_nm) as FIRM_NM,c.o_tel as O_TEL,c.fax as FAX,e.br_id as BR_ID, e.user_nm as bus_nm, \n" 
			+ "b.car_mng_id as CAR_MNG_ID, nvl2(b.init_reg_dt,substr(b.init_reg_dt,1,4)||'-'||substr(b.init_reg_dt,5,2)||'-'||substr(b.init_reg_dt,7,2),'') as INIT_REG_DT, nvl2(b.init_reg_dt,'ud','id') as REG_GUBUN, nvl2(b.car_no,b.car_no,nvl2(a.dlv_dt,'�̵��','�����')) as CAR_NO, b.car_num as CAR_NUM,\n"
			+ "d.rent_st as R_ST,d.rent_way as RENT_WAY,nvl(d.con_mon,'-') as CON_MON, decode(d.rent_start_dt,null,'',substr(d.rent_start_dt,1,4)||'-'||substr(d.rent_start_dt,5,2)||'-'||substr(d.rent_start_dt,7,2)) as RENT_START_DT, decode(d.rent_end_dt,null,'',substr(d.rent_end_dt,1,4)||'-'||substr(d.rent_end_dt,5,2)||'-'||substr(d.rent_end_dt,7,2)) as RENT_END_DT,\n"
			+ "decode(f.dlv_est_dt,'','',substr(f.dlv_est_dt,1,4)||'-'||substr(f.dlv_est_dt,5,2)||'-'||substr(f.dlv_est_dt,7,2)) as DLV_EST_DT, g.car_id as CAR_ID, g.imm_amt as IMM_AMT, decode(f.reg_ext_dt,null,'',substr(f.reg_ext_dt,1,4)||'-'||substr(f.reg_ext_dt,5,2)||'-'||substr(f.reg_ext_dt,7,2)) as REG_EXT_DT, f.rpt_no as RPT_NO, h.car_name as CAR_NAME, j.car_nm as CAR_NM,\n"//
			+ "i.cpt_cd as CPT_CD,l.emp_nm,\n"
			+ "decode(b.car_use,'1',decode(length(replace(b.car_end_dt,' ','')),8,b.car_end_dt,decode(sign(b.dpm-2000),1,to_char(to_date(b.init_reg_dt,'YYYYMMDD')+(365*8),'YYYYMMDD'),to_char(to_date(b.init_reg_dt,'YYYYMMDD')+(365*5),'YYYYMMDD'))),'-') car_end_dt,\n"
			+ "e2.user_nm as bus_nm2, e3.user_nm as mng_nm, b.car_doc_no, k.migr_dt, b.off_ls, a.car_st rrm, decode(b.car_end_yn,'Y','��������','') car_end_yn, decode(b.prepare,'4','����','5','����','9','��ȸ��','') prepare, "
			+ "decode(v2.jg_g_16,'1','[������]') jg_g_16 , b.end_req_dt \n"
			+ "from cont a, car_reg b, client c, fee d, users e, users e2, users e3, car_pur f, car_etc g, allot i, car_nm h, car_mng j, cls_cont s, \n"
			+ "     (select a.rent_mng_id,a.rent_l_cd,a.emp_id,a.agnt_st,b.emp_nm, b.car_off_id, c.car_off_nm,c.car_off_tel\n"
			+ "		  from commi a, car_off_emp b, car_off c\n" 
			+ "		  where a.agnt_st='2'\n"
			+ "		  and a.emp_id=b.emp_id\n"
			+ "		  and b.car_off_id=c.car_off_id) l, sui k, \n"
			+ "     esti_jg_var v2, (select sh_code, max(seq) seq FROM esti_jg_var GROUP BY sh_code) v3, \n"
			+ "     (select * from code where c_st='0039') m, "
			+ "     (select * from code where c_st='0041') n  "
			+ "where a.rent_mng_id like '%'\n"
			+ subQuery
			+ gubunQuery
			+ "and a.car_mng_id = b.car_mng_id(+)\n"
			+ "and a.client_id = c.client_id\n"
			+ "and d.rent_st='1' and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd\n"
			+ "and a.bus_id = e.user_id\n"
			+ "and a.bus_id2 = e2.user_id(+)\n"
			+ "and a.mng_id = e3.user_id(+)\n"
			+ "and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_mng_id = g.rent_mng_id and a.rent_l_cd = g.rent_l_cd\n"
			+ "and g.car_id = h.car_id(+) and g.car_seq=h.car_seq(+) and h.car_comp_id=j.car_comp_id(+) and h.car_cd=j.code(+)\n"
			+ "and a.rent_mng_id = i.rent_mng_id(+) and a.rent_l_cd = i.rent_l_cd(+) \n"
			+ "and a.rent_mng_id = l.rent_mng_id(+) and a.rent_l_cd = l.rent_l_cd(+)\n"
			+ "and b.car_mng_id = k.car_mng_id(+)\n"
			+ "and a.rent_mng_id = s.rent_mng_id(+) and a.rent_l_cd = s.rent_l_cd(+)\n"
			+ "and h.jg_code=v2.sh_code and v2.sh_code=v3.sh_code and v2.seq=v3.seq \n"
			+ "and b.fuel_kd=m.nm_cd and b.car_kd=n.nm_cd "
			+ sortQuery;
		}else{
	        query = "select  "+
					" decode(b.car_use,'',decode(a.car_st,'1','��Ʈ','3','����','2','����','5','�����뿩'),'1','��Ʈ','2','����') car_st, "+
					" nvl(b.car_ext, g.car_ext) car_ext, a.brch_id, a.rent_mng_id as RENT_MNG_ID, a.rent_l_cd as RENT_L_CD, decode(a.rent_dt,null,'',substr(a.rent_dt,1,4)||'-'||substr(a.rent_dt,5,2)||'-'||substr(a.rent_dt,7,2)) as RENT_DT, decode(a.dlv_dt,null,'',substr(a.dlv_dt,1,4)||'-'||substr(a.dlv_dt,5,2)||'-'||substr(a.dlv_dt,7,2)) as DLV_DT, a.client_id as CLIENT_ID,a.reg_id as REG_ID,\n" 
		    + "c.client_nm as CLIENT_NM, nvl(c.firm_nm,c.client_nm) as FIRM_NM,c.o_tel as O_TEL,c.fax as FAX,e.br_id as BR_ID, e.user_nm as bus_nm, \n" 
			+ "b.car_mng_id as CAR_MNG_ID, nvl2(b.init_reg_dt,substr(b.init_reg_dt,1,4)||'-'||substr(b.init_reg_dt,5,2)||'-'||substr(b.init_reg_dt,7,2),'') as INIT_REG_DT, nvl2(b.init_reg_dt,'ud','id') as REG_GUBUN, nvl2(b.car_no,b.car_no,nvl2(a.dlv_dt,'�̵��','�����')) as CAR_NO, b.car_num as CAR_NUM,\n"
			+ "d.rent_st as R_ST,d.rent_way as RENT_WAY,nvl(d.con_mon,'-') as CON_MON, decode(d.rent_start_dt,null,'',substr(d.rent_start_dt,1,4)||'-'||substr(d.rent_start_dt,5,2)||'-'||substr(d.rent_start_dt,7,2)) as RENT_START_DT, decode(d.rent_end_dt,null,'',substr(d.rent_end_dt,1,4)||'-'||substr(d.rent_end_dt,5,2)||'-'||substr(d.rent_end_dt,7,2)) as RENT_END_DT,\n"
			+ "decode(f.dlv_est_dt,'','',substr(f.dlv_est_dt,1,4)||'-'||substr(f.dlv_est_dt,5,2)||'-'||substr(f.dlv_est_dt,7,2)) as DLV_EST_DT, g.car_id as CAR_ID, g.imm_amt as IMM_AMT, decode(f.reg_ext_dt,null,'',substr(f.reg_ext_dt,1,4)||'-'||substr(f.reg_ext_dt,5,2)||'-'||substr(f.reg_ext_dt,7,2)) as REG_EXT_DT, nvl(f.rpt_no, f.est_car_no)  as RPT_NO, h.car_name as CAR_NAME, j.car_nm as CAR_NM,\n"//
			+ "i.cpt_cd as CPT_CD,l.emp_nm,\n"
			+ "decode(b.car_use,'1',decode(length(replace(b.car_end_dt,' ','')),8,b.car_end_dt,decode(sign(b.dpm-2000),1,to_char(to_date(b.init_reg_dt,'YYYYMMDD')+(365*8),'YYYYMMDD'),to_char(to_date(b.init_reg_dt,'YYYYMMDD')+(365*5),'YYYYMMDD'))),'-') car_end_dt,\n"
			+ "e2.user_nm as bus_nm2, e3.user_nm as mng_nm, b.car_doc_no, k.migr_dt, b.off_ls ,  a.car_st rrm, decode(b.car_end_yn,'Y','��������','') car_end_yn, decode(b.prepare,'4','����','5','����','9','��ȸ��','') prepare, "
			+ "decode(v2.jg_g_16,'1','[������]') jg_g_16 , b.end_req_dt \n"
			+ "from cont a, car_reg b, client c, fee d, users e, users e2, users e3, car_pur f, car_etc g, allot i, car_nm h, car_mng j, cls_cont s,\n"//--, code j
			+ "(select a.rent_mng_id,a.rent_l_cd,a.emp_id,a.agnt_st,b.emp_nm, b.car_off_id, c.car_off_nm,c.car_off_tel\n"
			+ "		from commi a, car_off_emp b, car_off c\n" 
			+ "		where a.agnt_st='2'\n"
			+ "		and a.emp_id=b.emp_id\n"
			+ "		and b.car_off_id=c.car_off_id) l, sui k, \n"
			+ " esti_jg_var v2, (select sh_code, max(seq) seq FROM esti_jg_var GROUP BY sh_code) v3, \n"
			+ "     (select * from code where c_st='0039') m, "
			+ "     (select * from code where c_st='0041') n  "			
			+ "where a.rent_mng_id like '%'\n"
			+ subQuery
			+ gubunQuery
			+ "and a.car_mng_id = b.car_mng_id(+)\n"
			+ "and a.client_id = c.client_id\n"
			+ "and d.rent_st='1' and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd\n"
			+ "and a.bus_id = e.user_id\n"
			+ "and a.bus_id2 = e2.user_id(+)\n"
			+ "and a.mng_id = e3.user_id(+)\n"
			+ "and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_mng_id = g.rent_mng_id and a.rent_l_cd = g.rent_l_cd\n"
			+ "and g.car_id = h.car_id(+) and g.car_seq=h.car_seq(+) and h.car_comp_id=j.car_comp_id(+) and h.car_cd=j.code(+)\n"
			+ "and a.rent_mng_id = i.rent_mng_id(+) and a.rent_l_cd = i.rent_l_cd(+) \n"
			+ "and a.rent_mng_id = l.rent_mng_id(+) and a.rent_l_cd = l.rent_l_cd(+)\n"
			+ "and a.rent_mng_id = s.rent_mng_id(+) and a.rent_l_cd = s.rent_l_cd(+)\n"
			+ "and b.car_mng_id = k.car_mng_id(+)\n"
			+ "and h.jg_code=v2.sh_code and v2.sh_code=v3.sh_code and v2.seq=v3.seq \n"
			+ "and b.fuel_kd=m.nm_cd(+) and b.car_kd=n.nm_cd(+) "
			+ sortQuery;
		}
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
			con = null;
        }
        return (RentListBean[])col.toArray(new RentListBean[0]);
    }

	  /**
     * ������, �ڵ��� ��� ����Ʈ ��ȸ -  ��� ��ǥ  ���� -- 7
	 * -.
     */
    public RentListBean [] getRegListAll2(String br_id, String ref_dt1, String ref_dt2, String gubun, String gubun_nm, String q_sort_nm, String q_sort ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String subQuery = "";
        String gubunQuery = "";
        String sortQuery = "";
        
        String query = "";
        
        subQuery = "and nvl(a.use_yn,'Y')='Y' and a.car_mng_id is not null and nvl(b.prepare,'1')<>'4'\n";	

        if(gubun.equals("1")){					gubunQuery = "and (nvl(c.firm_nm,' ') like '%" + gubun_nm + "%' or nvl(c.client_nm,' ') like '%" + gubun_nm + "%')\n";		}        
        else{									gubunQuery = "and  (nvl(c.firm_nm,' ') like '%'";																						}
              
    	if(q_sort_nm.equals("1")){			sortQuery = "order by 11  " + q_sort + "\n";				}
    	else if(q_sort_nm.equals("5")){	    sortQuery = "order by 1  " + q_sort + "\n";							}
    	else if(q_sort_nm.equals("6")){	    sortQuery = "order by 18  " + q_sort + "\n";							}
       	else{								sortQuery = "order by 1, 10, 18 " + q_sort + "\n";				}        	
      
      
      		
		  query = "select   nvl2(b.init_reg_dt,substr(b.init_reg_dt,1,4)||'-'||substr(b.init_reg_dt,5,2)||'-'||substr(b.init_reg_dt,7,2),'') as INIT_REG_DT,  g.car_ext, a.brch_id, a.rent_mng_id as RENT_MNG_ID, a.rent_l_cd as RENT_L_CD, decode(a.rent_dt,null,'',substr(a.rent_dt,1,4)||'-'||substr(a.rent_dt,5,2)||'-'||substr(a.rent_dt,7,2)) as RENT_DT, decode(a.dlv_dt,null,'',substr(a.dlv_dt,1,4)||'-'||substr(a.dlv_dt,5,2)||'-'||substr(a.dlv_dt,7,2)) as DLV_DT, a.client_id as CLIENT_ID,a.reg_id as REG_ID,\n" 
		    + "c.client_nm as CLIENT_NM, nvl(c.firm_nm,c.client_nm) as FIRM_NM,c.o_tel as O_TEL,c.fax as FAX,e.br_id as BR_ID,e.user_nm as bus_nm,\n" 
			+ " b.car_mng_id as CAR_MNG_ID, nvl2(b.init_reg_dt,'ud','id') as REG_GUBUN, nvl2(b.car_no,b.car_no,nvl2(a.dlv_dt,'�̵��','�����')) as CAR_NO, b.car_num as CAR_NUM,\n"
		   + "  '' as SH_BASE_DT, \n"
			+ "d.rent_st as R_ST,d.rent_way as RENT_WAY,nvl(d.con_mon,'-') as CON_MON, decode(d.rent_start_dt,null,'',substr(d.rent_start_dt,1,4)||'-'||substr(d.rent_start_dt,5,2)||'-'||substr(d.rent_start_dt,7,2)) as RENT_START_DT, decode(d.rent_end_dt,null,'',substr(d.rent_end_dt,1,4)||'-'||substr(d.rent_end_dt,5,2)||'-'||substr(d.rent_end_dt,7,2)) as RENT_END_DT,\n"
			+ "decode(f.dlv_est_dt,'','',substr(f.dlv_est_dt,1,4)||'-'||substr(f.dlv_est_dt,5,2)||'-'||substr(f.dlv_est_dt,7,2)) as DLV_EST_DT, g.car_id as CAR_ID, g.imm_amt as IMM_AMT, decode(f.reg_ext_dt,null,'',substr(f.reg_ext_dt,1,4)||'-'||substr(f.reg_ext_dt,5,2)||'-'||substr(f.reg_ext_dt,7,2)) as REG_EXT_DT, f.rpt_no as RPT_NO, h.car_name as CAR_NAME, j.car_nm as CAR_NM,\n"//
			+ " '' as CPT_CD, '' as emp_nm,\n"
			+ "decode(b.car_use,'1',decode(length(replace(b.car_end_dt,' ','')),8,b.car_end_dt,decode(sign(b.dpm-2000),1,to_char(to_date(b.init_reg_dt,'YYYYMMDD')+(365*8),'YYYYMMDD'),to_char(to_date(b.init_reg_dt,'YYYYMMDD')+(365*5),'YYYYMMDD'))),'-') car_end_dt,\n"
			+ "b.reg_amt, nvl(b.car_a_yn, '0') as car_a_yn,  nvl(b.reg_amt_card, '0') reg_amt_card, nvl(b.no_amt_card, '0') no_amt_card, \n"
			+ "decode(b.acq_ex_dt, null, 0 , b.acq_amt) acq_amt,   nvl(b.no_m_amt, 0) no_m_amt , b.off_ls  , nvl(b.etc, 0) etc  , nvl(b.loan_s_amt, 0) loan_s_amt \n"
			+ "from cont a, car_reg b, client c, fee d, users e, car_pur f, car_etc g, allot i, car_nm h, car_mng j, cls_cont s,\n"
			+ "(select a.rent_mng_id,a.rent_l_cd,a.emp_id,a.agnt_st,b.emp_nm, b.car_off_id, c.car_off_nm,c.car_off_tel\n"
			+ "		from commi a, car_off_emp b, car_off c\n" 
			+ "		where a.agnt_st='2'\n"
			+ "		and a.emp_id=b.emp_id\n"
			+ "		and b.car_off_id=c.car_off_id) l\n"
			+ "where a.rent_mng_id like '%'\n"
			+ " and  b.init_reg_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 +"','-','')\n"
			+ gubunQuery
			+ "and a.car_mng_id = b.car_mng_id(+)\n"
			+ "and a.client_id = c.client_id\n"
			+ "and d.rent_st='1' and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd\n"
			+ "and a.bus_id = e.user_id\n"
			+ "and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_mng_id = g.rent_mng_id and a.rent_l_cd = g.rent_l_cd\n"
			+ "and g.car_id = h.car_id(+) and g.car_seq=h.car_seq(+) and h.car_comp_id=j.car_comp_id(+) and h.car_cd=j.code(+)\n"
			+ "and a.rent_mng_id = i.rent_mng_id(+) and a.rent_l_cd = i.rent_l_cd(+) \n"
			+ "and a.rent_mng_id = l.rent_mng_id(+) and a.rent_l_cd = l.rent_l_cd(+)\n"
			+ "and a.rent_mng_id = s.rent_mng_id(+) and a.rent_l_cd = s.rent_l_cd(+)\n"
	      + "union all \n"
	      + "select 	 nvl2(b.init_reg_dt,substr(b.init_reg_dt,1,4)||'-'||substr(b.init_reg_dt,5,2)||'-'||substr(b.init_reg_dt,7,2),'') as INIT_REG_DT, g.car_ext, a.brch_id, a.rent_mng_id as RENT_MNG_ID, a.rent_l_cd as RENT_L_CD, decode(a.rent_dt,null,'',substr(a.rent_dt,1,4)||'-'||substr(a.rent_dt,5,2)||'-'||substr(a.rent_dt,7,2)) as RENT_DT, decode(a.dlv_dt,null,'',substr(a.dlv_dt,1,4)||'-'||substr(a.dlv_dt,5,2)||'-'||substr(a.dlv_dt,7,2)) as DLV_DT, a.client_id as CLIENT_ID,a.reg_id as REG_ID,\n" 
		    + "c.client_nm as CLIENT_NM, nvl(c.firm_nm,c.client_nm) as FIRM_NM,c.o_tel as O_TEL,c.fax as FAX,e.br_id as BR_ID,e.user_nm as bus_nm,\n" 
			+ " b.car_mng_id as CAR_MNG_ID, nvl2(b.init_reg_dt,'ud','id') as REG_GUBUN, nvl2(b.car_no,b.car_no,nvl2(a.dlv_dt,'�̵��','�����')) as CAR_NO, b.car_num as CAR_NUM,\n"
			+ "  nvl2(l.sh_base_dt,substr(l.sh_base_dt,1,4)||'-'||substr(l.sh_base_dt,5,2)||'-'||substr(l.sh_base_dt,7,2),'') as SH_BASE_DT, \n"
			+ "d.rent_st as R_ST,d.rent_way as RENT_WAY,nvl(d.con_mon,'-') as CON_MON, decode(d.rent_start_dt,null,'',substr(d.rent_start_dt,1,4)||'-'||substr(d.rent_start_dt,5,2)||'-'||substr(d.rent_start_dt,7,2)) as RENT_START_DT, decode(d.rent_end_dt,null,'',substr(d.rent_end_dt,1,4)||'-'||substr(d.rent_end_dt,5,2)||'-'||substr(d.rent_end_dt,7,2)) as RENT_END_DT,\n"
			+ "decode(f.dlv_est_dt,'','',substr(f.dlv_est_dt,1,4)||'-'||substr(f.dlv_est_dt,5,2)||'-'||substr(f.dlv_est_dt,7,2)) as DLV_EST_DT, g.car_id as CAR_ID, g.imm_amt as IMM_AMT, decode(f.reg_ext_dt,null,'',substr(f.reg_ext_dt,1,4)||'-'||substr(f.reg_ext_dt,5,2)||'-'||substr(f.reg_ext_dt,7,2)) as REG_EXT_DT, f.rpt_no as RPT_NO, h.car_name as CAR_NAME, j.car_nm as CAR_NM,\n"//
			+ " '' as CPT_CD, '' emp_nm,\n"
			+ "decode(b.car_use,'1',decode(length(replace(b.car_end_dt,' ','')),8,b.car_end_dt,decode(sign(b.dpm-2000),1,to_char(to_date(b.init_reg_dt,'YYYYMMDD')+(365*8),'YYYYMMDD'),to_char(to_date(b.init_reg_dt,'YYYYMMDD')+(365*5),'YYYYMMDD'))),'-') car_end_dt,\n"
			+ "b.reg_amt, nvl(b.car_a_yn, '0') as car_a_yn,  nvl(b.reg_amt_card, '0') reg_amt_card, nvl(b.no_amt_card, '0') no_amt_card, \n"
			+ "decode(b.acq_ex_dt, null, 0 , b.acq_amt) acq_amt,   nvl(b.no_m_amt, 0) no_m_amt , b.off_ls , nvl(b.etc, 0) etc  , nvl(b.loan_s_amt, 0) loan_s_amt \n"
			+ "from cont a, car_reg b, client c, fee d, users e, car_pur f, car_etc g, car_nm h, car_mng j, \n"
	       + " ( select rent_mng_id, rent_l_cd, sh_base_dt from commi where agnt_st = '6' )  l\n"
			+ "where a.rent_mng_id like '%'\n"
			+ " and    b.reg_pay_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 +"','-','')         \n"   //�߰��� �߰� 
					+ gubunQuery
			+ "and a.car_mng_id = b.car_mng_id(+)\n"
			+ "and a.client_id = c.client_id\n"
			+ "and d.rent_st='1' and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd\n"
			+ "and a.bus_id = e.user_id\n"
			+ "and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_mng_id = g.rent_mng_id and a.rent_l_cd = g.rent_l_cd\n"
			+ "and g.car_id = h.car_id(+) and g.car_seq=h.car_seq(+) and h.car_comp_id=j.car_comp_id(+) and h.car_cd=j.code(+)\n"
			+ "and a.rent_mng_id = l.rent_mng_id and a.rent_l_cd = l.rent_l_cd\n"

			+ sortQuery;
			
        Collection<RentListBean> col = new ArrayList<RentListBean>();
        try{
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery(query);
            while(rs.next()){
				col.add(makeRegListBean3(rs));
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
        return (RentListBean[])col.toArray(new RentListBean[0]);
    }
    
    
    /**
     * �ڵ������ ��ȸ�Ǽ� ( 2002/1/3 ) - Kim JungTae
     */
    public String getRegListAllCount(String br_id, String st, String ref_dt1, String ref_dt2, String gubun, String gubun_nm ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String subQuery = "";
        String gubunQuery = "";
        
        String query = "";
        String count = "";
        
        if(st.equals("1")){			subQuery = "and nvl(a.use_yn,'Y')='Y' and a.car_mng_id is null and a.dlv_dt is not null\n";	}
        else if(st.equals("2")){	subQuery = "and nvl(a.use_yn,'Y')='Y' and a.car_mng_id is not null and nvl(b.prepare,'1')<>'4'\n";						}
        else if(st.equals("3")){	subQuery = "and nvl(a.use_yn,'Y')='Y' and a.car_mng_id is null and a.dlv_dt is null\n";		}
        else if(st.equals("4")){	subQuery = "and a.use_yn='N' and s.cls_st ='6' and a.car_mng_id is not null and a.dlv_dt is not null\n";		}
        else if(st.equals("5")){	subQuery = "and a.use_yn='N' and s.cls_st ='8' and a.car_mng_id is not null and a.dlv_dt is not null\n";		}
        else if(st.equals("6")){	subQuery = "and a.use_yn='N' and s.cls_st ='9' and a.car_mng_id is not null and a.dlv_dt is not null\n";		}
        else if(st.equals("7")){	subQuery = "and nvl(a.use_yn,'Y')='Y' and b.prepare ='4'\n";													}
        else{        				subQuery = "and nvl(a.use_yn,'Y')='Y'";														}

        if(gubun.equals("firm_nm"))
        {
        	gubunQuery = "and (nvl(c.firm_nm,' ') like '%" + gubun_nm + "%' or nvl(c.client_nm,' ') like '%" + gubun_nm + "%')\n";
        }else if(gubun.equals("client_nm")){
        	gubunQuery = "and nvl(c.client_nm,' ') like '%" + gubun_nm + "%'\n";
        }else if(gubun.equals("car_no")){
        	gubunQuery = "and nvl(b.car_no,' ') like '%" + gubun_nm + "%'\n";
        }else if(gubun.equals("car_nm")){
        	gubunQuery = "and nvl(h.car_name,' ') like '%" + gubun_nm + "%'\n";
        }else if(gubun.equals("dlv_dt")){
        	gubunQuery = "and a.dlv_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 +"','-','')\n";
        }else if(gubun.equals("init_reg_dt")){
        	gubunQuery = "and b.init_reg_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 +"','-','')\n";
		}else if(gubun.equals("br_id")){
        	gubunQuery = "and nvl(e.br_id,' ') like '%" + gubun_nm +"%'\n";
        }else if(gubun.equals("rent_l_cd")){
        	gubunQuery = "and nvl(a.rent_l_cd,' ') like '%" + gubun_nm +"%'\n";
        }else if(gubun.equals("car_num")){
        	gubunQuery = "and nvl(b.car_num,' ') like '%" + gubun_nm +"%'\n";
        }else if(gubun.equals("emp_nm")){
        	gubunQuery = "and nvl(l.emp_nm,' ') like '%" + gubun_nm +"%'\n";
        }else{
        	gubunQuery = "and b.car_mng_id=''\n";
        }
        
        query = "select count(a.rent_mng_id)\n"//,j.nm as BANK_NM
		+ "from cont a, car_reg b, client c, fee d, users e, car_pur f, car_etc g, allot i, car_nm h, car_mng j, cls_cont s,\n"//--, code j
		+ "(select a.rent_mng_id,a.rent_l_cd,a.emp_id,a.agnt_st,b.emp_nm, b.car_off_id, c.car_off_nm,c.car_off_tel\n"
		+ "from commi a, car_off_emp b, car_off c\n" 
		+ "where a.agnt_st='2'\n"
		+ "and a.emp_id=b.emp_id\n"
		+ "and b.car_off_id=c.car_off_id) l\n"
		+ "where a.rent_mng_id like '%'\n"
		+ subQuery
		+ gubunQuery
		+ "and a.car_mng_id = b.car_mng_id(+)\n"
		+ "and a.client_id = c.client_id\n"
		+ "and d.rent_st='1' and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd\n"
		+ "and a.bus_id = e.user_id\n"
		+ "and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_mng_id = g.rent_mng_id and a.rent_l_cd = g.rent_l_cd\n"
		+ "and g.car_id = h.car_id(+) and g.car_seq=h.car_seq(+) and h.car_comp_id=j.car_comp_id(+) and h.car_cd=j.code(+)\n"
		+ "and a.rent_mng_id = i.rent_mng_id(+) and a.rent_l_cd = i.rent_l_cd(+) \n"
		+ "and a.rent_mng_id = l.rent_mng_id(+) and a.rent_l_cd = l.rent_l_cd(+)\n"
		+ "and a.rent_mng_id = s.rent_mng_id(+) and a.rent_l_cd = s.rent_l_cd(+)\n";
        try{
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery(query);

            if(rs.next()){
                
				count = rs.getString(1);
 
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
        return count;
    }
    /**
     * �ڵ��� ��� ��ȸ
     */    
    public CarRegBean getCarRegBean(String car_mng_id) throws UnknownDataException, DataSourceEmptyException, DatabaseException {
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null) 
            throw new DataSourceEmptyException("Can't get connection.!!");

        CarRegBean crb = new CarRegBean();

        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
		query = " select CAR_MNG_ID,CAR_NO,CAR_NUM,"+
				" CAR_KD,CAR_USE,CAR_NM,CAR_FORM,MOT_FORM,CAR_Y_FORM,DPM,TAKING_P,TIRE,FUEL_KD,CONTI_RAT,MORT_ST,"+
				" LOAN_ST,LOAN_B_AMT,LOAN_S_AMT,LOAN_S_RAT,REG_AMT,ACQ_AMT,NO_M_AMT,STAMP_AMT,ETC,"+
				" CHA_NO1,CHA_NO2,ACQ_STD,ACQ_ACQ,FIRST_CAR_NO,"+
				" decode(INIT_REG_DT,null,'',substr(INIT_REG_DT,1,4)||'-'||substr(INIT_REG_DT,5,2)||'-'||substr(INIT_REG_DT,7,2)) as INIT_REG_DT,"+
				" decode(MORT_DT,null,'',substr(MORT_DT,1,4)||'-'||substr(MORT_DT,5,2)||'-'||substr(MORT_DT,7,2)) as MORT_DT,"+
				" decode(MAINT_ST_DT,null,'',substr(MAINT_ST_DT,1,4)||'-'||substr(MAINT_ST_DT,5,2)||'-'||substr(MAINT_ST_DT,7,2)) as MAINT_ST_DT,"+
				" decode(MAINT_END_DT,null,'',substr(MAINT_END_DT,1,4)||'-'||substr(MAINT_END_DT,5,2)||'-'||substr(MAINT_END_DT,7,2)) as MAINT_END_DT,"+
				" decode(CAR_END_DT,null,'',substr(CAR_END_DT,1,4)||'-'||substr(CAR_END_DT,5,2)||'-'||substr(CAR_END_DT,7,2)) as CAR_END_DT,"+
				" decode(TEST_ST_DT,null,'',substr(TEST_ST_DT,1,4)||'-'||substr(TEST_ST_DT,5,2)||'-'||substr(TEST_ST_DT,7,2)) as TEST_ST_DT,"+
				" decode(TEST_END_DT,null,'',substr(TEST_END_DT,1,4)||'-'||substr(TEST_END_DT,5,2)||'-'||substr(TEST_END_DT,7,2)) as TEST_END_DT,"+
				" decode(ACQ_F_DT,null,'',substr(ACQ_F_DT,1,4)||'-'||substr(ACQ_F_DT,5,2)||'-'||substr(ACQ_F_DT,7,2)) as ACQ_F_DT,"+
				" decode(ACQ_EX_DT,null,'',substr(ACQ_EX_DT,1,4)||'-'||substr(ACQ_EX_DT,5,2)||'-'||substr(ACQ_EX_DT,7,2)) as ACQ_EX_DT,"+
				" decode(REG_PAY_DT,null,'',substr(REG_PAY_DT,1,4)||'-'||substr(REG_PAY_DT,5,2)||'-'||substr(REG_PAY_DT,7,2)) as REG_PAY_DT,"+
				" ACQ_RE,ACQ_IS_P,ACQ_IS_O,REG_DT,REG_NM, CAR_DOC_NO, ACQ_AMT_CARD, "+
				" GUAR_GEN_Y, GUAR_GEN_KM, GUAR_ENDUR_Y, GUAR_ENDUR_KM, CAR_EXT, "+
				" decode(CAR_A_YN,null,'',CAR_A_YN) as CAR_A_YN, max_kg, prepare, off_ls, park, secondhand_dt, reg_amt_card, no_amt_card, gps, "+
				" dist_cng, secondhand, import_car_amt, import_tax_amt, import_tax_dt, import_spe_tax_amt,  car_end_yn, spe_dc_st, spe_dc_cau, spe_dc_per, spe_dc_s_dt, spe_dc_d_dt, "+
				" ncar_spe_dc_cau, ncar_spe_dc_amt, ncar_spe_dc_day, ncar_spe_dc_dt, car_length, car_width "+
				" from car_reg"+
				" where car_mng_id='" + car_mng_id + "'";
        try {
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
    
            if (rs.next())
                crb = makeCarRegBean(rs);
 
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

        return crb;
    }
    /**
     * ���� ��ȸ
     */    
    public InsurBean getInsurBean(String car_mng_id) throws UnknownDataException, DataSourceEmptyException, DatabaseException {
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null) 
            throw new DataSourceEmptyException("Can't get connection.!!");

        InsurBean isb = new InsurBean();

        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
		query = "select CAR_MNG_ID,INS_ST,INS_STS,AGE_SCP,CAR_USE,INS_COM_ID,INS_CON_NO,CONR_NM,INS_START_DT,INS_EXP_DT,RINS_PCP_AMT,VINS_PCP_KD,VINS_PCP_AMT,VINS_GCP_KD,VINS_GCP_AMT,VINS_BACDT_KD,VINS_BACDT_AMT,VINS_CACDT_AMT,VINS_CANOISR_AMT,VINS_CACDT_CAR_AMT,VINS_CACDT_ME_AMT,VINS_CACDT_CM_AMT,PAY_TM,CHANGE_DT,CHANGE_CAU,CHANGE_ITM_KD1,CHANGE_ITM_AMT1,CHANGE_ITM_KD2,CHANGE_ITM_AMT2,CHANGE_ITM_KD3,CHANGE_ITM_AMT3,CHANGE_ITM_KD4,CHANGE_ITM_AMT4,CAR_RATE,INS_RATE,EXT_RATE,AIR_DS_YN,AIR_AS_YN,AGNT_NM,AGNT_TEL,AGNT_IMGN_TEL,AGNT_FAX,EXP_DT,EXP_CAU,RTN_AMT,RTN_DT\n"
				+ " from insur\n"
				+ " where car_mng_id='" + car_mng_id + "'\n";
        try {
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
    
            if (rs.next())
                isb = makeInsurBean(rs);
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

        return isb;
    }
    /**
     * ���� ���� �Ǵ�
     */    
    public int getInsurTF(String car_mng_id) throws UnknownDataException, DataSourceEmptyException, DatabaseException {
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null) 
            throw new DataSourceEmptyException("Can't get connection.!!");

        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        int tf = 0;
		query = "select count(CAR_MNG_ID) from insur where car_mng_id='" + car_mng_id + "'\n";
        try {
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
    
            if (rs.next())
                tf = rs.getInt(1);
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

        return tf;
    }
    
    
       /**
     * 5���̻�
     */    
    public String getR_year5_dt(String init_reg_dt) throws UnknownDataException, DataSourceEmptyException, DatabaseException {
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null) 
            throw new DataSourceEmptyException("Can't get connection.!!");

        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        String  r_y5 = "";
        
	query = "select to_char(add_months(to_date( '"+init_reg_dt + "' ) , 60 ) , 'yyyymmdd') from dual ";
        try {
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
    
            if (rs.next())
                 r_y5 = rs.getString(1);
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

        return r_y5;
    }
    
    
    
    /**
     * ������������ ��ü ��ȸ.
     */
    public CarMaintBean [] getCarMaintAll(String car_mng_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = "SELECT  a.car_mng_id as CAR_MNG_ID,a.seq_no as SEQ_NO,a.che_kd as CHE_KD,decode(a.che_st_dt,null,'',substr(a.che_st_dt,1,4)||'-'||substr(a.che_st_dt,5,2)||'-'||substr(a.che_st_dt,7,2)) as CHE_ST_DT,decode(a.che_end_dt,null,'',substr(a.che_end_dt,1,4)||'-'||substr(a.che_end_dt,5,2)||'-'||substr(a.che_end_dt,7,2)) as CHE_END_DT,decode(a.che_dt,null,'',substr(a.che_dt,1,4)||'-'||substr(a.che_dt,5,2)||'-'||substr(a.che_dt,7,2)) as CHE_DT,a.che_no as CHE_NO,a.che_comp as CHE_COMP, a.che_amt CHE_AMT, a.che_remark as CHE_REMARK ,  a.che_km CHE_KM\n"
				+ " FROM car_maint a\n"
				+ " where  a.car_mng_id='" + car_mng_id + "'\n";

        Collection<CarMaintBean> col = new ArrayList<CarMaintBean>();
        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
                
				col.add(makeCarMaintBean(rs));
 
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
        return (CarMaintBean[])col.toArray(new CarMaintBean[0]);
    }

    /**
     * ������������ �Ǻ� ��ȸ. 2004.8.3.
     */
    public CarMaintBean getCarMaint(String car_mng_id, String seq_no) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
		CarMaintBean bean = new CarMaintBean();
        
        String query = "";
        
        query = "SELECT  a.car_mng_id as CAR_MNG_ID,a.seq_no as SEQ_NO,a.che_kd as CHE_KD,decode(a.che_st_dt,null,'',substr(a.che_st_dt,1,4)||'-'||substr(a.che_st_dt,5,2)||'-'||substr(a.che_st_dt,7,2)) as CHE_ST_DT,decode(a.che_end_dt,null,'',substr(a.che_end_dt,1,4)||'-'||substr(a.che_end_dt,5,2)||'-'||substr(a.che_end_dt,7,2)) as CHE_END_DT,decode(a.che_dt,null,'',substr(a.che_dt,1,4)||'-'||substr(a.che_dt,5,2)||'-'||substr(a.che_dt,7,2)) as CHE_DT,a.che_no as CHE_NO,a.che_comp as CHE_COMP, a.che_amt CHE_AMT, a.che_remark as CHE_REMARK ,  a.che_km CHE_KM\n"
				+ "FROM car_maint a \n"
				+ "where  a.car_mng_id='" + car_mng_id + "' and a.seq_no='"+seq_no+"'\n";


        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
                
				bean = makeCarMaintBean(rs);
 
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
        return bean;
    }

    /**
     * ������ġ���� ��ü ��ȸ.
     */
    public CarChaBean [] getCarChaAll(String car_mng_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = "SELECT a.car_mng_id as CAR_MNG_ID,a.seq_no as SEQ_NO,a.cha_item as CHA_ITEM,decode(a.cha_st_dt,null,'',substr(a.cha_st_dt,1,4)||'-'||substr(a.cha_st_dt,5,2)||'-'||substr(a.cha_st_dt,7,2)) as CHA_ST_DT,decode(a.cha_end_dt,null,'',substr(a.cha_end_dt,1,4)||'-'||substr(a.cha_end_dt,5,2)||'-'||substr(a.cha_end_dt,7,2)) as CHA_END_DT,a.cha_nm as CHA_NM, a.cha_amt, a.cha_v_amt, \n"
        				+ " a.cha_st, a.cha_amt, a.cha_v_amt, a.b_dist, a.off_nm \n"
				+ "FROM car_cha a\n"
				+ "where a.car_mng_id='" + car_mng_id + "'\n";

        Collection<CarChaBean> col = new ArrayList<CarChaBean>();
        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
                
				col.add(makeCarChaBean(rs));
 
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
        return (CarChaBean[])col.toArray(new CarChaBean[0]);
    }

	/**
     * �ڵ�����Ϻ�ȣ �Ѱ� ��ȸ. 20050422. Yongsoon Kwon.
     */
    public CarHisBean getCarHis(String car_mng_id, String cha_seq) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
		CarHisBean bean = new CarHisBean();
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";        
        query = "SELECT car_mng_id, cha_seq, decode(cha_dt,null,'',substr(cha_dt,1,4)||'-'||substr(cha_dt,5,2)||'-'||substr(cha_dt,7,2)) as cha_dt, cha_cau, cha_cau_sub, car_no, reg_id, reg_dt, use_yn, scanfile, file_type "
				+ " FROM car_change"
				+ " where car_mng_id='" + car_mng_id + "' AND cha_seq = '" + cha_seq +"' \n";

        try{
			stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){                
				bean = makeCarHisBean(rs);
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
        return bean;
    }


	/**
     * �ڵ�����Ϻ�ȣ ��ü ��ȸ.
     */
    public CarHisBean [] getCarHisAll(String car_mng_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";        
        query = "SELECT car_mng_id, cha_seq, decode(cha_dt,null,'',substr(cha_dt,1,4)||'-'||substr(cha_dt,5,2)||'-'||substr(cha_dt,7,2)) as cha_dt, cha_cau, cha_cau_sub, car_no, reg_id, reg_dt, use_yn, scanfile, file_type "
				+ " FROM car_change"
				+ " where car_mng_id='" + car_mng_id + "' order by cha_seq \n";


        Collection<CarHisBean> col = new ArrayList<CarHisBean>();
        try{
			stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){                
				col.add(makeCarHisBean(rs));
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
        return (CarHisBean[])col.toArray(new CarHisBean[0]);
    }

	/**
     * ����ǵ�� ��ü ��ȸ.
     */
    public CarMortBean [] getCarMortAll(String car_mng_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = "SELECT a.car_mng_id as CAR_MNG_ID,a.seq_no as SEQ_NO,a.mort_st as MORT_ST,decode(a.mort_dt,null,'',substr(a.mort_dt,1,4)||'-'||substr(a.mort_dt,5,2)||'-'||substr(a.mort_dt,7,2)) as MORT_DT\n"
				+ "FROM car_mort a\n"
				+ "where a.car_mng_id='" + car_mng_id + "'\n";

        Collection<CarMortBean> col = new ArrayList<CarMortBean>();
        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
                
				col.add(makeCarMortBean(rs));
 
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
        return (CarMortBean[])col.toArray(new CarMortBean[0]);
    }
    /**
     * ���轺���� ��ȸ.
     */
    public ScdInsBean [] getScdInsAll(String car_mng_id, String ims_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = "SELECT CAR_MNG_ID,INS_TM,INS_ST,decode(INS_EST_DT,null,'',substr(INS_EST_DT,1,4)||'-'||substr(INS_EST_DT,5,2)||'-'||substr(INS_EST_DT,7,2)) as INS_EST_DT,PAY_AMT,PAY_YN,decode(PAY_DT,null,'',substr(PAY_DT,1,4)||'-'||substr(PAY_DT,5,2)||'-'||substr(PAY_DT,7,2)) as PAY_DT\n"
				+ "FROM scd_ins\n"
				+ "where car_mng_id='" + car_mng_id + "' and ins_st='" + ims_st + "'\n";

        Collection<ScdInsBean> col = new ArrayList<ScdInsBean>();
        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
                
				col.add(makeScdInsBean(rs));
 
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
        return (ScdInsBean[])col.toArray(new ScdInsBean[0]);
    }    
    /**
     * �ڵ������ ���.
     */
    public String insertCarReg(CarRegBean bean, String rent_mng_id, String rent_l_cd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        PreparedStatement pstmt3 = null;
        PreparedStatement pstmt4 = null;
    	Statement stmt = null;
    	ResultSet rs = null;
    	ResultSet rs2 = null;
        String query = "";
        String query1 = "";
        String query2 = "";
   		String query3 = "";
	    String query4 = "";
        String fineQuery = "";
   		String cb_query = "";
	    String cb_query2 = "";
        String car_mng_id = "";
        String car_mng_id2 = "";
   		String car_l_cd = "";
        int count = 0;
                
        query = " INSERT INTO CAR_REG("+
				" CAR_MNG_ID, CAR_NO, CAR_NUM, INIT_REG_DT, CAR_KD, CAR_USE, CAR_NM, CAR_FORM, MOT_FORM, CAR_Y_FORM,"+
				" DPM, TAKING_P, TIRE, FUEL_KD,	CONTI_RAT, LOAN_ST, LOAN_B_AMT,	LOAN_S_AMT, LOAN_S_RAT, REG_AMT,"+
				" ACQ_AMT, ACQ_AMT_CARD, NO_M_AMT, STAMP_AMT,	ETC, MAINT_ST_DT, MAINT_END_DT, FIRST_CAR_NO, CAR_END_DT, TEST_ST_DT, TEST_END_DT,"+
				" REG_DT, REG_NM, CAR_L_CD, GUAR_GEN_Y, GUAR_GEN_KM, GUAR_ENDUR_Y, GUAR_ENDUR_KM, CAR_EXT)\n"+
				" VALUES("+
				" ?,?,upper(?),replace(?,'-',''),?,?,upper(?),upper(?),upper(?),?,"+
				" ?,?,?,?,?,?,?,?,?,?,"+
				" ?,?,?,?,?,replace(?,'-',''),replace(?,'-',''),?,replace(?,'-',''),replace(?,'-',''),replace(?,'-',''),"+
				" to_char(sysdate,'YYYYMMDD'),?,?,?,?,?,?,?)\n";

    	query1="UPDATE CONT SET CAR_MNG_ID=? WHERE RENT_MNG_ID=? AND RENT_L_CD=?";

		query2="SELECT nvl(lpad(max(CAR_MNG_ID)+1,6,'0'),'000001') car_mng_id,"+
				" decode(to_char(sysdate,'yy'), substr(max(car_l_cd),1,2), to_char(sysdate,'yy')||lpad(substr(max(car_l_cd),3,6)+1,4,0), to_char(sysdate,'yy')||'0001') car_l_cd"+
				" FROM CAR_REG";


    	query4 = "select car_mng_id from allot where rent_mng_id='"+rent_mng_id+"' and rent_l_cd='"+rent_l_cd+"'";

		fineQuery = "insert into fine_call(car_mng_id) values(?)";

    	cb_query = "update allot set car_mng_id=?, imsi_chk='0' where rent_l_cd=?";

		cb_query2 = "update scd_alt_case set car_mng_id=? where car_mng_id=?";

            
       try{
            con.setAutoCommit(false);

            //CAR_MNG_ID, CAR_L_CD
            stmt = con.createStatement();
            rs = stmt.executeQuery(query2);
            if(rs.next()){
            	car_mng_id = rs.getString(1).trim();
				car_l_cd = rs.getString(2).trim();
			}
			rs.close();

			//CAR_REG ���ڵ� ����
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
			pstmt.setString(2, bean.getCar_no().trim());
			pstmt.setString(3, bean.getCar_num().trim());
			pstmt.setString(4, bean.getInit_reg_dt().trim());
			pstmt.setString(5, bean.getCar_kd().trim());
			pstmt.setString(6, bean.getCar_use().trim());
			pstmt.setString(7, bean.getCar_nm().trim());
			pstmt.setString(8, bean.getCar_form().trim());
			pstmt.setString(9, bean.getMot_form().trim());
			pstmt.setString(10, bean.getCar_y_form().trim());
			pstmt.setString(11, bean.getDpm().trim());
			pstmt.setInt   (12, bean.getTaking_p());
			pstmt.setString(13, bean.getTire().trim());
			pstmt.setString(14, bean.getFuel_kd().trim());
			pstmt.setString(15, bean.getConti_rat().trim());
			pstmt.setString(16, bean.getLoan_st().trim());
			pstmt.setInt   (17, bean.getLoan_b_amt());
			pstmt.setInt   (18, bean.getLoan_s_amt());
			pstmt.setString(19, bean.getLoan_s_rat().trim());
			pstmt.setInt   (20, bean.getReg_amt());
			pstmt.setInt   (21, bean.getAcq_amt());
			pstmt.setString(22, bean.getAcq_amt_card());
			pstmt.setInt   (23, bean.getNo_m_amt());
			pstmt.setInt   (24, bean.getStamp_amt());
			pstmt.setInt   (25, bean.getEtc());
			pstmt.setString(26, bean.getMaint_st_dt().trim());
			pstmt.setString(27, bean.getMaint_end_dt().trim());
			pstmt.setString(28, bean.getCar_no().trim());
			pstmt.setString(29, bean.getCar_end_dt().trim());
			pstmt.setString(30, bean.getTest_st_dt().trim());
			pstmt.setString(31, bean.getTest_end_dt().trim());
			pstmt.setString(32, bean.getReg_nm().trim());
			pstmt.setString(33, car_l_cd);
			pstmt.setString(34, bean.getGuar_gen_y().trim());
			pstmt.setString(35, bean.getGuar_gen_km().trim());
			pstmt.setString(36, bean.getGuar_endur_y().trim());
			pstmt.setString(37, bean.getGuar_endur_km().trim());
			pstmt.setString(38, bean.getCar_ext().trim());
            count = pstmt.executeUpdate();
			pstmt.close();

			//CONT car_mng_id ����
			pstmt1 = con.prepareStatement(query1);
            pstmt1.setString(1, car_mng_id);
			pstmt1.setString(2, rent_mng_id);
			pstmt1.setString(3, rent_l_cd);						
			pstmt1.executeUpdate();
			pstmt1.close();


			//�ڵ�����Ϲ�ȣ(�Һε��)�ӽù�ȣ����
            rs2 = stmt.executeQuery(query4);            
            if(rs2.next()){
            	car_mng_id2 = rs2.getString(1).trim();
			}
			rs2.close();
			stmt.close();
			
			if(!car_mng_id2.equals("") && car_mng_id2.substring(0,1).equals("A")){

				pstmt2 = con.prepareStatement(fineQuery);
				pstmt2.setString(1, car_mng_id);						
				pstmt2.executeUpdate();
				pstmt2.close();
			
				pstmt3 = con.prepareStatement(cb_query);
				pstmt3.setString(1, car_mng_id);						
				pstmt3.setString(2, rent_l_cd);						
				pstmt3.executeUpdate();
				pstmt3.close();

				pstmt4 = con.prepareStatement(cb_query2);
				pstmt4.setString(1, car_mng_id);						
				pstmt4.setString(2, car_mng_id2);						
				pstmt4.executeUpdate();
				pstmt4.close();

			}
            
            con.commit();

		}catch(Exception se){
            try{
				System.out.println("[CarRegDatabase:insertCarReg]="+se);
			    con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(rs != null) rs.close();
                if(rs2 != null) rs2.close();
                if(stmt != null) stmt.close();
                if(pstmt != null) pstmt.close();
                if(pstmt1 != null) pstmt1.close();
                if(pstmt2 != null) pstmt2.close();
                if(pstmt3 != null) pstmt3.close();
                if(pstmt4 != null) pstmt4.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return car_mng_id;
    }
    
    /**
     * �ڵ������ ���� ����.
     */
    public int updateCarMain(CarRegBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query =	" UPDATE CAR_REG SET\n"+
        		" CAR_NO=?,CAR_NUM=upper(?),INIT_REG_DT=replace(?,'-',''),CAR_KD=?,CAR_USE=?,CAR_NM=upper(?),CAR_FORM=upper(?),"+
				" MOT_FORM=upper(?),CAR_Y_FORM=?,DPM=?,TAKING_P=?,TIRE=?,FUEL_KD=?,CONTI_RAT=?,MORT_ST=?,MORT_DT=replace(?,'-',''),"+
				" LOAN_ST=?,LOAN_B_AMT=?,LOAN_S_AMT=?,LOAN_S_RAT=?,REG_AMT=?,ACQ_AMT=?,NO_M_AMT=?,STAMP_AMT=?,ETC=?,MAINT_ST_DT=replace(?,'-',''),"+
				" MAINT_END_DT=replace(?,'-',''),FIRST_CAR_NO=?,CHA_NO2=?,CAR_END_DT=replace(?,'-',''),TEST_ST_DT=replace(?,'-',''),"+
				" TEST_END_DT=replace(?,'-',''),REG_DT=replace(?,'-',''),REG_NM=?,\n"+
				" GUAR_GEN_Y=?,GUAR_GEN_KM=?,GUAR_ENDUR_Y=?,GUAR_ENDUR_KM=?,CAR_EXT=?,CAR_DOC_NO=?,REG_PAY_DT=replace(?,'-',''),max_kg=?,"+
				" reg_amt_card=?, no_amt_card=?, gps=?, update_id = ? , update_dt = sysdate, "+
				" import_car_amt=?,import_tax_amt=?,import_tax_dt=replace(?,'-',''),import_spe_tax_amt=?, car_end_yn = ?, car_length = ?, car_width = ? "+
				" WHERE CAR_MNG_ID=?\n";

       try{
            con.setAutoCommit(false);
            
            pstmt = con.prepareStatement(query);

            pstmt.setString(1, bean.getCar_no().trim());
			pstmt.setString(2, bean.getCar_num().trim());
			pstmt.setString(3, bean.getInit_reg_dt().trim());
			pstmt.setString(4, bean.getCar_kd().trim());
			pstmt.setString(5, bean.getCar_use().trim());
			pstmt.setString(6, bean.getCar_nm().trim());
			pstmt.setString(7, bean.getCar_form().trim());
			pstmt.setString(8, bean.getMot_form().trim());
			pstmt.setString(9, bean.getCar_y_form().trim());
			pstmt.setString(10, bean.getDpm().trim());
			pstmt.setInt(11, bean.getTaking_p());
			pstmt.setString(12, bean.getTire().trim());
			pstmt.setString(13, bean.getFuel_kd().trim());
			pstmt.setString(14, bean.getConti_rat().trim());
			pstmt.setString(15, bean.getMort_st().trim());
			pstmt.setString(16, bean.getMort_dt().trim());
			pstmt.setString(17, bean.getLoan_st().trim());
			pstmt.setInt(18, bean.getLoan_b_amt());
			pstmt.setInt(19, bean.getLoan_s_amt());
			pstmt.setString(20, bean.getLoan_s_rat().trim());
			pstmt.setInt(21, bean.getReg_amt());
			pstmt.setInt(22, bean.getAcq_amt());
			pstmt.setInt(23, bean.getNo_m_amt());
			pstmt.setInt(24, bean.getStamp_amt());
			pstmt.setInt(25, bean.getEtc());
			pstmt.setString(26, bean.getMaint_st_dt().trim());
			pstmt.setString(27, bean.getMaint_end_dt().trim());
			pstmt.setString(28, bean.getFirst_car_no().trim());
			pstmt.setString(29, bean.getCha_no2().trim());
			pstmt.setString(30, bean.getCar_end_dt().trim());
			pstmt.setString(31, bean.getTest_st_dt().trim());
			pstmt.setString(32, bean.getTest_end_dt().trim());
			pstmt.setString(33, bean.getReg_dt().trim());
			pstmt.setString(34, bean.getReg_nm().trim());
			pstmt.setString(35, bean.getGuar_gen_y().trim());
			pstmt.setString(36, bean.getGuar_gen_km().trim());
			pstmt.setString(37, bean.getGuar_endur_y().trim());
			pstmt.setString(38, bean.getGuar_endur_km().trim());
			pstmt.setString(39, bean.getCar_ext().trim());
			pstmt.setString(40, bean.getCar_doc_no().trim());
			pstmt.setString(41, bean.getReg_pay_dt().trim());
			pstmt.setString(42, bean.getMax_kg().trim());
			pstmt.setString(43, bean.getReg_amt_card().trim());
			pstmt.setString(44, bean.getNo_amt_card().trim());
			pstmt.setString(45, bean.getGps().trim());
			pstmt.setString(46, bean.getUpdate_id().trim());
			pstmt.setInt   (47, bean.getImport_car_amt());
			pstmt.setInt   (48, bean.getImport_tax_amt());
			pstmt.setString(49, bean.getImport_tax_dt().trim());
			pstmt.setInt   (50, bean.getImport_spe_tax_amt());
			pstmt.setString(51, bean.getCar_end_yn().trim());
			
			pstmt.setInt   (52, bean.getCar_length());
			pstmt.setInt   (53, bean.getCar_width());

			pstmt.setString(54, bean.getCar_mng_id().trim());
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
     * �ڵ������ ��漼 ����.
     */
    public int updateCarAcq(CarRegBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query="UPDATE CAR_REG \n"
        		+ " SET ACQ_STD=?, ACQ_ACQ=?,ACQ_F_DT=replace(?,'-',''),ACQ_EX_DT=replace(?,'-',''),ACQ_RE=?,ACQ_IS_P=?,ACQ_IS_O=?, ACQ_AMT_CARD = ? \n"
			+ "WHERE CAR_MNG_ID=?\n";
           
       try{
            con.setAutoCommit(false);
            
            pstmt = con.prepareStatement(query);
			pstmt.setString(1, bean.getAcq_std().trim());
			pstmt.setInt   (2, bean.getAcq_acq());
			pstmt.setString(3, bean.getAcq_f_dt().trim());
			pstmt.setString(4, bean.getAcq_ex_dt().trim());
			pstmt.setString(5, bean.getAcq_re().trim());
			pstmt.setString(6, bean.getAcq_is_p().trim());
			pstmt.setString(7, bean.getAcq_is_o().trim());
			pstmt.setString(8, bean.getAcq_amt_card());
			pstmt.setString(9, bean.getCar_mng_id().trim());
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
     * �ڵ������ �ڵ���ǥ ����.
     */
    public boolean updateCarAutoDocu(CarRegBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
        boolean flag = true;
                
        query="UPDATE CAR_REG\n"
        		+ "SET CAR_A_YN= ?\n"
			+ "WHERE CAR_MNG_ID=?\n";
           
       try{
            con.setAutoCommit(false);
            
            pstmt = con.prepareStatement(query);
            
			pstmt.setString(1, bean.getCar_a_yn().trim());
			pstmt.setString(2, bean.getCar_mng_id().trim());
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(SQLException se){
            try{
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
     * ������������ ���.
     */
    public int insertCarMaint(CarMaintBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        String car_mng_id = "";
        int count = 0;
        car_mng_id = bean.getCar_mng_id().trim();
                
        query="INSERT INTO CAR_MAINT(CAR_MNG_ID,SEQ_NO,CHE_KD,CHE_ST_DT,CHE_END_DT,CHE_DT,CHE_NO,CHE_COMP,che_amt,che_km,reg_dt, reg_id)\n"
            + "SELECT '" + car_mng_id + "',nvl(max(SEQ_NO)+1,1),?,replace(?,'-',''),replace(?,'-',''),replace(?,'-',''),?,?,?,?,to_char(sysdate,'YYYYMMDD') , ? \n"
            + "FROM CAR_MAINT WHERE CAR_MNG_ID='" + car_mng_id + "'\n";
            
       try{
	            con.setAutoCommit(false);

	            pstmt = con.prepareStatement(query);
	
	            pstmt.setString(1, bean.getChe_kd().trim());
	            pstmt.setString(2, bean.getChe_st_dt().trim());
	            pstmt.setString(3, bean.getChe_end_dt().trim());
	            pstmt.setString(4, bean.getChe_dt().trim());
	            pstmt.setString(5, bean.getChe_no().trim());
	            pstmt.setString(6, bean.getChe_comp().trim());
		  pstmt.setInt   (7, bean.getChe_amt());
		  pstmt.setInt   (8, bean.getChe_km());
		  pstmt.setString   (9, bean.getReg_id());
            
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
     * ������ġ������� ���.
     */
    public int insertCarCha(CarChaBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        String car_mng_id = "";
        int count = 0;
        car_mng_id = bean.getCar_mng_id().trim();
                
        query="INSERT INTO CAR_CHA(CAR_MNG_ID,SEQ_NO,CHA_ITEM,CHA_ST_DT,CHA_END_DT,CHA_NM,CHA_ST,CHA_AMT,CHA_V_AMT)\n"
            + "SELECT '" + car_mng_id + "',nvl(max(SEQ_NO)+1,1),?,replace(?,'-',''),replace(?,'-',''),?,?,?,?\n"
            + "FROM CAR_CHA WHERE CAR_MNG_ID='" + car_mng_id + "'\n";
            
       try{
            con.setAutoCommit(false);
            
            pstmt = con.prepareStatement(query);

            pstmt.setString(1, bean.getCha_item().trim());
            pstmt.setString(2, bean.getCha_st_dt().trim());
            pstmt.setString(3, bean.getCha_end_dt().trim());
            pstmt.setString(4, bean.getCha_nm().trim());
            pstmt.setString(5, bean.getCha_st().trim());
            pstmt.setInt   (6, bean.getCha_amt());
            pstmt.setInt   (7, bean.getCha_v_amt());
            
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
     * ��Ϲ�ȣ���� �̷� ��� 
     */
    public int insertCarHis(CarHisBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        ResultSet rs = null;
		Statement stmt = null;
		PreparedStatement pstmt = null;
		String car_mng_id = "";
		String seq = "";
        int count = 0;
        car_mng_id = bean.getCar_mng_id().trim();
	
		String query_seq = "select nvl(max(cha_seq)+1,'1') from car_change where car_mng_id='" + car_mng_id + "'";		
        String query="INSERT INTO CAR_CHANGE(CAR_MNG_ID,CHA_SEQ,CHA_DT,CHA_CAU,CHA_CAU_SUB,CAR_NO,REG_ID,REG_DT,USE_YN,SCANFILE,FILE_TYPE,CAR_EXT) "+
					" VALUES (?,?,replace(?,'-',''),?,?,?,?,replace(?,'-',''),?,?,?,?)";
	   try{
			con.setAutoCommit(false);

			stmt = con.createStatement();
            rs = stmt.executeQuery(query_seq);
            if(rs.next())
            	seq = rs.getString(1).trim();
            rs.close();
			stmt.close();

			pstmt = con.prepareStatement(query);
            pstmt.setString(1,  car_mng_id);
            pstmt.setString(2,  seq);
            pstmt.setString(3,  bean.getCha_dt().trim());            
            pstmt.setString(4,  bean.getCha_cau().trim());            
            pstmt.setString(5,  bean.getCha_cau_sub().trim());            
            pstmt.setString(6,  bean.getCha_car_no().trim());            
			pstmt.setString(7,  bean.getReg_id());
			pstmt.setString(8,  bean.getReg_dt());
			pstmt.setString(9,  bean.getUse_yn());
			pstmt.setString(10, bean.getScanfile());
			pstmt.setString(11, bean.getFile_type());
			pstmt.setString(12, bean.getCar_ext());
			count = pstmt.executeUpdate();

			pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
				System.out.println(se);
				con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
				if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return count;
    }

    /**
     * ��Ϲ�ȣ �̷� ���� 20050422. Yongsoon Kwon.
     */
    public int deleteCarHis(String car_mng_id, String cha_seq) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
        int count = 0;
	
        String query="DELETE car_change WHERE car_mng_id=? AND cha_seq = ? ";
	   try{
		   con.setAutoCommit(false);
			pstmt = con.prepareStatement(query);
            pstmt.setString(1, car_mng_id);
            pstmt.setString(2, cha_seq);
			count = pstmt.executeUpdate();

			pstmt.close();
			con.commit();

        }catch(SQLException se){
            try{
				System.out.println(se);
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
     * ��Ϲ�ȣ �̷� ���� 20050422. Yongsoon Kwon.
     */
    public int updateCarHis(CarHisBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
        int count = 0;
	
        String query="UPDATE car_change SET cha_dt=REPLACE(?,'-',''), "+
							" cha_cau		=?, "+
							" cha_cau_sub	=?, "+
							" car_no		=?	"+
					 " WHERE car_mng_id=? AND cha_seq = ? ";
	   try{
		   con.setAutoCommit(false);
			pstmt = con.prepareStatement(query);
            pstmt.setString(1, bean.getCha_dt().trim());            
            pstmt.setString(2, bean.getCha_cau().trim());            
            pstmt.setString(3, bean.getCha_cau_sub().trim());            
            pstmt.setString(4, bean.getCha_car_no().trim());            
            pstmt.setString(5, bean.getCar_mng_id());
            pstmt.setString(6, bean.getCha_seq());
			count = pstmt.executeUpdate();

			pstmt.close();
			con.commit();

        }catch(SQLException se){
            try{
				System.out.println(se);
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
     * ����� ���.
     */
    public int insertCarMort(CarMortBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        String car_mng_id = "";
        int count = 0;
        car_mng_id = bean.getCar_mng_id().trim();
                
        query="INSERT INTO CAR_MORT(CAR_MNG_ID,SEQ_NO,MORT_ST,MORT_DT)\n"
            + "SELECT '" + car_mng_id + "',nvl(max(SEQ_NO)+1,1),?,replace(?,'-','')\n"
            + "FROM CAR_MORT WHERE CAR_MNG_ID='" + car_mng_id + "'\n";
            
       try{
            con.setAutoCommit(false);
            
            pstmt = con.prepareStatement(query);

            pstmt.setString(1, bean.getMort_st().trim());
            pstmt.setString(2, bean.getMort_dt().trim());
            
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
     * ���� ���.
     */
    public int insertInsur(InsurBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        String car_mng_id = "";
        int count = 0;
        car_mng_id = bean.getCar_mng_id().trim();
                
        query="insert into insur(CAR_MNG_ID,INS_ST,INS_STS,AGE_SCP,CAR_USE,INS_COM_ID,INS_CON_NO,CONR_NM,INS_START_DT,INS_EXP_DT,RINS_PCP_AMT,VINS_PCP_AMT,VINS_PCP_KD,VINS_GCP_KD,VINS_GCP_AMT,VINS_BACDT_KD,VINS_BACDT_AMT,VINS_CACDT_AMT,PAY_TM,CHANGE_DT,CHANGE_CAU,CHANGE_ITM_KD1,CHANGE_ITM_AMT1,CHANGE_ITM_KD2,CHANGE_ITM_AMT2,CHANGE_ITM_KD3,CHANGE_ITM_AMT3,CHANGE_ITM_KD4,CHANGE_ITM_AMT4,CAR_RATE,INS_RATE,EXT_RATE,AIR_DS_YN,AIR_AS_YN,AGNT_NM,AGNT_TEL,AGNT_IMGN_TEL,AGNT_FAX,EXP_DT,EXP_CAU,RTN_AMT,RTN_DT,VINS_CANOISR_AMT,VINS_CACDT_CAR_AMT,VINS_CACDT_ME_AMT,VINS_CACDT_CM_AMT)\n"
				+ "values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,nvl(?,'N'),nvl(?,'N'),?,?,?,?,?,?,?,?)";
            
       try{
            con.setAutoCommit(false);
           
            pstmt = con.prepareStatement(query);
            pstmt.setString(1, bean.getCar_mng_id().trim());
            pstmt.setString(2, "0");
            pstmt.setString(3, "1");
            pstmt.setString(4, bean.getAge_scp().trim());
            pstmt.setString(5, bean.getCar_use().trim());
           	pstmt.setString(6, bean.getIns_com_id().trim());
            pstmt.setString(7, bean.getIns_con_no().trim());
            pstmt.setString(8, "�Ƹ���ī");
            pstmt.setString(9, bean.getIns_start_dt().trim());
            pstmt.setString(10, bean.getIns_exp_dt().trim());
            pstmt.setInt   (11, bean.getRins_pcp_amt());
            pstmt.setInt   (12, bean.getVins_pcp_amt());
            pstmt.setString(13, bean.getVins_pcp_kd().trim());
            pstmt.setString(14, bean.getVins_gcp_kd().trim());
            pstmt.setInt   (15, bean.getVins_gcp_amt());
            pstmt.setString(16, bean.getVins_bacdt_kd().trim());
            pstmt.setInt   (17, bean.getVins_bacdt_amt());
            pstmt.setInt   (18, bean.getVins_cacdt_amt());
            pstmt.setString(19, bean.getPay_tm().trim());
            pstmt.setString(20, bean.getChange_dt().trim());            
            pstmt.setString(21, bean.getChange_cau().trim());
            pstmt.setString(22, bean.getChange_itm_kd1().trim());
            pstmt.setInt   (23, bean.getChange_itm_amt1());
            pstmt.setString(24, bean.getChange_itm_kd2().trim());
            pstmt.setInt   (25, bean.getChange_itm_amt2());
            pstmt.setString(26, bean.getChange_itm_kd3().trim());
            pstmt.setInt   (27, bean.getChange_itm_amt3());
            pstmt.setString(28, bean.getChange_itm_kd4().trim());
            pstmt.setInt   (29, bean.getChange_itm_amt4());
            pstmt.setString(30, bean.getCar_rate().trim());
            pstmt.setString(31, bean.getIns_rate().trim());
            pstmt.setString(32, bean.getExt_rate().trim());
            pstmt.setString(33, bean.getAir_ds_yn().trim());
            pstmt.setString(34, bean.getAir_as_yn().trim());
            pstmt.setString(35, bean.getAgnt_nm().trim());
            pstmt.setString(36, bean.getAgnt_tel().trim());
            pstmt.setString(37, bean.getAgnt_imgn_tel().trim());
            pstmt.setString(38, bean.getAgnt_fax().trim());
            pstmt.setString(39, bean.getExp_dt().trim());
            pstmt.setString(40, bean.getExp_cau().trim());
            pstmt.setInt   (41, bean.getRtn_amt());
            pstmt.setString(42, bean.getRtn_dt().trim());
			pstmt.setInt   (43, bean.getVins_canoisr_amt());
			pstmt.setInt   (44, bean.getVins_cacdt_car_amt());
			pstmt.setInt   (45, bean.getVins_cacdt_me_amt());
			pstmt.setInt   (46, bean.getVins_cacdt_cm_amt());

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
     * ���� ����.
     */
    public int updateInsur(InsurBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        String car_mng_id = "";
        int count = 0;
        car_mng_id = bean.getCar_mng_id().trim();
                
        query="update insur set INS_STS=?,AGE_SCP=?,CAR_USE=?,INS_COM_ID=?,INS_CON_NO=?,CONR_NM=?,INS_START_DT=?,INS_EXP_DT=?,RINS_PCP_AMT=?,VINS_PCP_AMT=?,VINS_PCP_KD=?,VINS_GCP_KD=?,VINS_GCP_AMT=?,VINS_BACDT_KD=?,VINS_BACDT_AMT=?,VINS_CACDT_AMT=?,PAY_TM=?,CHANGE_DT=?,CHANGE_CAU=?,CHANGE_ITM_KD1=?,CHANGE_ITM_AMT1=?,CHANGE_ITM_KD2=?,CHANGE_ITM_AMT2=?,CHANGE_ITM_KD3=?,CHANGE_ITM_AMT3=?,CHANGE_ITM_KD4=?,CHANGE_ITM_AMT4=?,CAR_RATE=?,INS_RATE=?,EXT_RATE=?,AIR_DS_YN=nvl(?,'N'),AIR_AS_YN=nvl(?,'N'),AGNT_NM=?,AGNT_TEL=?,AGNT_IMGN_TEL=?,AGNT_FAX=?,EXP_DT=?,EXP_CAU=?,RTN_AMT=?,RTN_DT=?,VINS_CANOISR_AMT=?,VINS_CACDT_CAR_AMT=?,VINS_CACDT_ME_AMT=?,VINS_CACDT_CM_AMT=?\n"
				+ "where car_mng_id=? and ins_st=?";

	   try{
            con.setAutoCommit(false);
           
            pstmt = con.prepareStatement(query);
            
            pstmt.setString(1, "1");
            pstmt.setString(2, bean.getAge_scp().trim());
            pstmt.setString(3, bean.getCar_use().trim());
           	pstmt.setString(4, bean.getIns_com_id().trim());
            pstmt.setString(5, bean.getIns_con_no().trim());
            pstmt.setString(6, "�Ƹ���ī");
            pstmt.setString(7, bean.getIns_start_dt().trim());
            pstmt.setString(8, bean.getIns_exp_dt().trim());
            pstmt.setInt(9, bean.getRins_pcp_amt());
            pstmt.setInt(10, bean.getVins_pcp_amt());
            pstmt.setString(11, bean.getVins_pcp_kd().trim());
            pstmt.setString(12, bean.getVins_gcp_kd().trim());
            pstmt.setInt(13, bean.getVins_gcp_amt());
            pstmt.setString(14, bean.getVins_bacdt_kd().trim());
            pstmt.setInt(15, bean.getVins_bacdt_amt());
            pstmt.setInt(16, bean.getVins_cacdt_amt());
            pstmt.setString(17, bean.getPay_tm().trim());
            pstmt.setString(18, bean.getChange_dt().trim());
            
            pstmt.setString(19, bean.getChange_cau().trim());
            pstmt.setString(20, bean.getChange_itm_kd1().trim());
            pstmt.setInt(21, bean.getChange_itm_amt1());
            pstmt.setString(22, bean.getChange_itm_kd2().trim());
            pstmt.setInt(23, bean.getChange_itm_amt2());
            pstmt.setString(24, bean.getChange_itm_kd3().trim());
            pstmt.setInt(25, bean.getChange_itm_amt3());
            pstmt.setString(26, bean.getChange_itm_kd4().trim());
            pstmt.setInt(27, bean.getChange_itm_amt4());
            pstmt.setString(28, bean.getCar_rate().trim());
            pstmt.setString(29, bean.getIns_rate().trim());
            pstmt.setString(30, bean.getExt_rate().trim());
            pstmt.setString(31, bean.getAir_ds_yn().trim());
            pstmt.setString(32, bean.getAir_as_yn().trim());
            pstmt.setString(33, bean.getAgnt_nm().trim());
            pstmt.setString(34, bean.getAgnt_tel().trim());
            pstmt.setString(35, bean.getAgnt_imgn_tel().trim());
            pstmt.setString(36, bean.getAgnt_fax().trim());
            pstmt.setString(37, bean.getExp_dt().trim());
            pstmt.setString(38, bean.getExp_cau().trim());
            pstmt.setInt(39, bean.getRtn_amt());
            pstmt.setString(40, bean.getRtn_dt().trim());
			pstmt.setInt(41, bean.getVins_canoisr_amt());
			pstmt.setInt(42, bean.getVins_cacdt_car_amt());
			pstmt.setInt(43, bean.getVins_cacdt_me_amt());
			pstmt.setInt(44, bean.getVins_cacdt_cm_amt());
			pstmt.setString(45, bean.getCar_mng_id().trim());
            pstmt.setString(46, "0");

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
     * ���轺���� ���
     */
    public void insertScdIns(String car_mng_id, Vector v) throws DatabaseException, DataSourceEmptyException, UnknownDataException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
		
        int count = 0;
        
        String query = "insert into scd_ins(CAR_MNG_ID,INS_ST,INS_TM,INS_EST_DT,PAY_AMT,PAY_YN,PAY_DT)\n"
                         +" values(?,?,?,replace(?,'-',''),?,nvl2(?,'1','0'),replace(?,'-',''))";

        try{
            con.setAutoCommit(false);
            
            pstmt = con.prepareStatement(query);

            for(int i=0; i<v.size(); i++){
                String val [] = (String [])v.elementAt(i);
				String ins_tm = "";
				ins_tm = (i+1) + "";
                pstmt.setString(1, car_mng_id.trim());
                pstmt.setString(2, "0");
                pstmt.setString(3, ins_tm.trim());
                pstmt.setString(4, val[0].trim());
                pstmt.setString(5, val[1].trim());
                pstmt.setString(6, val[2].trim());
                pstmt.setString(7, val[2].trim());

                count = pstmt.executeUpdate();

            }

            pstmt.close();
            con.commit();
        }catch(Exception se){
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
    }
    /**
     * ���轺���� ����
     */
    public void updateScdIns(String car_mng_id, Vector v) throws DatabaseException, DataSourceEmptyException, UnknownDataException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
		
        int count = 0;
        
        String query = "update scd_ins set INS_EST_DT=replace(?,'-',''),PAY_AMT=?,PAY_YN=nvl2(?,'1','0'),PAY_DT=replace(?,'-','')\n"
                         +"where car_mng_id=? and ins_st=? and ins_tm=?";

        try{
            con.setAutoCommit(false);
            
            pstmt = con.prepareStatement(query);
            for(int i=0; i<v.size(); i++){
                String val [] = (String [])v.elementAt(i);
				String ins_tm = "";
				ins_tm = (i+1) + "";
                
                
                pstmt.setString(1, val[0].trim());
                pstmt.setString(2, val[1].trim());
                pstmt.setString(3, val[2].trim());
                pstmt.setString(4, val[2].trim());
				pstmt.setString(5, car_mng_id.trim());
                pstmt.setString(6, "0");
                pstmt.setString(7, ins_tm.trim());
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
    }
    /**
     * ����� ����.
     */
    public int updateCarMort(CarMortBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query="UPDATE CAR_MORT SET MORT_ST=?,MORT_DT=replace(?,'-','') WHERE CAR_MNG_ID=? AND SEQ_NO=?\n";
            
       try{
            con.setAutoCommit(false);
            
            pstmt = con.prepareStatement(query);

            pstmt.setString(1, bean.getMort_st().trim());
            pstmt.setString(2, bean.getMort_dt().trim());
            pstmt.setString(3, bean.getCar_mng_id().trim());
            pstmt.setInt(4, bean.getSeq_no());
            
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
     * ������������ ����.
     */
    public int updateCarMaint(CarMaintBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";

        int count = 0;
                
        query="UPDATE CAR_MAINT SET CHE_KD=?,CHE_ST_DT=replace(?,'-',''),CHE_END_DT=replace(?,'-',''),CHE_DT=replace(?,'-',''),CHE_NO=?,CHE_COMP=?, che_amt=?, che_km=? , reg_id = ? , reg_dt = to_char(sysdate, 'yyymmdd' )  WHERE CAR_MNG_ID=? AND SEQ_NO=?\n";
            
       try{
		            con.setAutoCommit(false);
		
		            pstmt = con.prepareStatement(query);
		
		            pstmt.setString(1, bean.getChe_kd().trim());
		            pstmt.setString(2, bean.getChe_st_dt().trim());
		            pstmt.setString(3, bean.getChe_end_dt().trim());
		            pstmt.setString(4, bean.getChe_dt().trim());
		            pstmt.setString(5, bean.getChe_no().trim());
		            pstmt.setString(6, bean.getChe_comp().trim());
			  pstmt.setInt(7, bean.getChe_amt());				//�߰� 2004.01.07.
			  pstmt.setInt(8, bean.getChe_km());				//�߰� 2004.01.13.
			  pstmt.setString(9, bean.getReg_id().trim());
		            pstmt.setString(10, bean.getCar_mng_id().trim());
		            pstmt.setInt(11, bean.getSeq_no());
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
     * ������ġ������� ����.
     */
    public int updateCarCha(CarChaBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        String car_mng_id = "";
        int count = 0;
        car_mng_id = bean.getCar_mng_id().trim();
                
        query="UPDATE CAR_CHA SET CHA_ITEM=?,CHA_ST_DT=replace(?,'-',''),CHA_END_DT=replace(?,'-',''),CHA_NM=?,CHA_ST=?, CHA_AMT=?, CHA_V_AMT=? WHERE CAR_MNG_ID=? AND SEQ_NO=?\n";
         
       try{
            con.setAutoCommit(false);
            pstmt = con.prepareStatement(query);

            pstmt.setString(1, bean.getCha_item().trim());
            pstmt.setString(2, bean.getCha_st_dt().trim());
            pstmt.setString(3, bean.getCha_end_dt().trim());
            pstmt.setString(4, bean.getCha_nm().trim());
			pstmt.setString(5, bean.getCha_st().trim());
			pstmt.setInt   (6, bean.getCha_amt());
			pstmt.setInt   (7, bean.getCha_v_amt());
            pstmt.setString(8, bean.getCar_mng_id().trim());
            pstmt.setInt   (9, bean.getSeq_no());
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
     * �ڵ��� ��� ��ȸ
     */    
    public CarRegBean getCarRegDocNoBean(String car_doc_no, String car_no) throws UnknownDataException, DataSourceEmptyException, DatabaseException {
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null) 
            throw new DataSourceEmptyException("Can't get connection.!!");

        CarRegBean crb = new CarRegBean();

        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
		query = "select CAR_MNG_ID,CAR_NO,CAR_NUM,"+
				" CAR_KD,CAR_USE,CAR_NM,CAR_FORM,MOT_FORM,CAR_Y_FORM,DPM,TAKING_P,TIRE,FUEL_KD,CONTI_RAT,MORT_ST,"+
				" LOAN_ST,LOAN_B_AMT,LOAN_S_AMT,LOAN_S_RAT,REG_AMT,ACQ_AMT,NO_M_AMT,STAMP_AMT,ETC,"+
				" CHA_NO1,CHA_NO2,ACQ_STD,ACQ_ACQ,FIRST_CAR_NO,"+
				" decode(INIT_REG_DT,null,'',substr(INIT_REG_DT,1,4)||'-'||substr(INIT_REG_DT,5,2)||'-'||substr(INIT_REG_DT,7,2)) as INIT_REG_DT,"+
				" decode(MORT_DT,null,'',substr(MORT_DT,1,4)||'-'||substr(MORT_DT,5,2)||'-'||substr(MORT_DT,7,2)) as MORT_DT,"+
				" decode(MAINT_ST_DT,null,'',substr(MAINT_ST_DT,1,4)||'-'||substr(MAINT_ST_DT,5,2)||'-'||substr(MAINT_ST_DT,7,2)) as MAINT_ST_DT,"+
				" decode(MAINT_END_DT,null,'',substr(MAINT_END_DT,1,4)||'-'||substr(MAINT_END_DT,5,2)||'-'||substr(MAINT_END_DT,7,2)) as MAINT_END_DT,"+
				" decode(CAR_END_DT,null,'',substr(CAR_END_DT,1,4)||'-'||substr(CAR_END_DT,5,2)||'-'||substr(CAR_END_DT,7,2)) as CAR_END_DT,"+
				" decode(TEST_ST_DT,null,'',substr(TEST_ST_DT,1,4)||'-'||substr(TEST_ST_DT,5,2)||'-'||substr(TEST_ST_DT,7,2)) as TEST_ST_DT,"+
				" decode(TEST_END_DT,null,'',substr(TEST_END_DT,1,4)||'-'||substr(TEST_END_DT,5,2)||'-'||substr(TEST_END_DT,7,2)) as TEST_END_DT,"+
				" decode(ACQ_F_DT,null,'',substr(ACQ_F_DT,1,4)||'-'||substr(ACQ_F_DT,5,2)||'-'||substr(ACQ_F_DT,7,2)) as ACQ_F_DT,"+
				" decode(ACQ_EX_DT,null,'',substr(ACQ_EX_DT,1,4)||'-'||substr(ACQ_EX_DT,5,2)||'-'||substr(ACQ_EX_DT,7,2)) as ACQ_EX_DT,"+
				" decode(REG_PAY_DT,null,'',substr(REG_PAY_DT,1,4)||'-'||substr(REG_PAY_DT,5,2)||'-'||substr(REG_PAY_DT,7,2)) as REG_PAY_DT,"+
				" ACQ_RE,ACQ_IS_P,ACQ_IS_O,REG_DT,REG_NM, CAR_DOC_NO, ACQ_AMT_CARD,"+
				" GUAR_GEN_Y, GUAR_GEN_KM, GUAR_ENDUR_Y, GUAR_ENDUR_KM, CAR_EXT, "+
				" decode(CAR_A_YN,null,'',CAR_A_YN) as CAR_A_YN, max_kg, prepare, off_ls, park, secondhand_dt, reg_amt_card, no_amt_card, gps, "+
				" dist_cng, secondhand, import_car_amt, import_tax_amt, import_tax_dt, import_spe_tax_amt, car_end_yn, spe_dc_st, spe_dc_cau, spe_dc_per, spe_dc_s_dt, spe_dc_d_dt,  "+
				" ncar_spe_dc_cau, ncar_spe_dc_amt, ncar_spe_dc_day, ncar_spe_dc_dt, car_length, car_width "+
				" from car_reg"+
				" where car_doc_no='" + car_doc_no + "' and car_no='" + car_no + "' and car_mng_id in (select car_mng_id from cont where car_st<>'4' group by car_mng_id)";
        try {
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
    
            if (rs.next())
                crb = makeCarRegBean(rs);
 
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

        return crb;
    }

	/**
     * �ڵ�����Ϻ�ȣ �Ѱ� ��ȸ. 20050422. Yongsoon Kwon.
     */
    public CarHisBean getCarHisSearch(String car_mng_id, String car_no, String cng_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
		CarHisBean bean = new CarHisBean();
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";        
        query = "SELECT car_mng_id, cha_seq, decode(cha_dt,null,'',substr(cha_dt,1,4)||'-'||substr(cha_dt,5,2)||'-'||substr(cha_dt,7,2)) as cha_dt, cha_cau, cha_cau_sub, car_no, reg_id, reg_dt, use_yn, scanfile, file_type "
				+ " FROM car_change"
				+ " where car_mng_id='" + car_mng_id + "' AND car_no = '" + car_no +"' and cha_dt = replace('"+cng_dt+"','-','')\n";

        try{
			stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){                
				bean = makeCarHisBean(rs);
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
        return bean;
    }

	/**
     * ������ġ
     */
    public CarChaBean getCarCha(String car_mng_id, String cha_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
		CarChaBean bean = new CarChaBean();
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "SELECT a.car_mng_id as CAR_MNG_ID,a.seq_no as SEQ_NO,a.cha_item as CHA_ITEM,decode(a.cha_st_dt,null,'',substr(a.cha_st_dt,1,4)||'-'||substr(a.cha_st_dt,5,2)||'-'||substr(a.cha_st_dt,7,2)) as CHA_ST_DT,decode(a.cha_end_dt,null,'',substr(a.cha_end_dt,1,4)||'-'||substr(a.cha_end_dt,5,2)||'-'||substr(a.cha_end_dt,7,2)) as CHA_END_DT,a.cha_nm as CHA_NM, \n"
        						+ " a.cha_st, a.cha_amt, a.cha_v_amt,  a.off_nm, a.b_dist \n"
						+ "FROM car_cha a\n"
						+ "where a.car_mng_id='" + car_mng_id + "' and a.cha_st='" + cha_st + "'\n";


        try{
			stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){                
				bean = makeCarChaBean(rs);
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
        return bean;
    }

    /**
     * ������������ �Ǻ� ��ȸ. 2004.8.3.
     */
    public CarMaintBean getCarMaintPay(String car_mng_id, String maint_dt, int che_amt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
		CarMaintBean bean = new CarMaintBean();
        
        String query = "";
        
        query = "SELECT a.car_mng_id as CAR_MNG_ID,a.seq_no as SEQ_NO,a.che_kd as CHE_KD,decode(a.che_st_dt,null,'',substr(a.che_st_dt,1,4)||'-'||substr(a.che_st_dt,5,2)||'-'||substr(a.che_st_dt,7,2)) as CHE_ST_DT,decode(a.che_end_dt,null,'',substr(a.che_end_dt,1,4)||'-'||substr(a.che_end_dt,5,2)||'-'||substr(a.che_end_dt,7,2)) as CHE_END_DT,decode(a.che_dt,null,'',substr(a.che_dt,1,4)||'-'||substr(a.che_dt,5,2)||'-'||substr(a.che_dt,7,2)) as CHE_DT,a.che_no as CHE_NO,a.che_comp as CHE_COMP, a.che_amt CHE_AMT, a.che_remark as CHE_REMARK , a.che_km CHE_KM\n"
				+ "FROM car_maint a \n"
				+ "where  a.car_mng_id='" + car_mng_id + "' and a.che_dt=replace('"+maint_dt+"','-','') and a.che_amt="+che_amt+" ";

        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
                
				bean = makeCarMaintBean(rs);
 
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
        return bean;
    }

/**
     * �ڵ�����Ϻ�ȣ ��ü ��ȸ.
     */
    public CarHisBean [] getCarHisAll_mc(String car_mng_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";        
        query = " SELECT a.car_mng_id, a.cha_seq, decode(a.cha_dt,null,'',substr(a.cha_dt,1,4)||'-'||substr(a.cha_dt,5,2)||'-'||substr(a.cha_dt,7,2)) as cha_dt, a.cha_cau, a.cha_cau_sub, a.car_no, a.reg_id, a.reg_dt, a.use_yn, a.scanfile, a.file_type, b.max_seq \n"+
				" FROM car_change a, (select max(cha_seq) as max_seq from car_change where car_mng_id='" + car_mng_id + "' ) b \n"+
				" where car_mng_id='" + car_mng_id + "' and a.cha_seq = b.max_seq ";

        Collection<CarHisBean> col = new ArrayList<CarHisBean>();
        try{
			stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){                
				col.add(makeCarHisBean(rs));
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
        return (CarHisBean[])col.toArray(new CarHisBean[0]);
    }



/**
     * ������, �ڵ��� ��� ����Ʈ ��ȸ - ������ ���� //String gubun3  ���� ��Ŵ.(2009.11.06)-���漱 ����
	 * - 2003.08.20 ��.(�ǿ��) :��ȸ�� getRegListAllCount()�� ��ġ�� �����ʾ� car_change ���̺� ����. -- 8
     */
    public RentListBean [] getRegListAll2(String br_id, String st, String ref_dt1, String ref_dt2, String gubun, String gubun_nm, String q_sort_nm, String q_sort ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String subQuery = "";
        String gubunQuery = "";
        String sortQuery = "";
        
        String query = "";
        
        if(st.equals("1")){			subQuery = "and nvl(a.use_yn,'Y')='Y' and a.car_mng_id is null and a.dlv_dt is not null\n";			}
        else if(st.equals("2")){	subQuery = "and nvl(a.use_yn,'Y')='Y' and a.car_mng_id is not null and nvl(b.prepare,'1')<>'4'\n";	}
        else if(st.equals("3")){	subQuery = "and nvl(a.use_yn,'Y')='Y' and a.car_mng_id is null and a.dlv_dt is null\n";				}
        else if(st.equals("4")){	subQuery = "and nvl(a.use_yn,'Y')='N' and s.cls_st ='6' and a.car_mng_id is not null\n";				}
        else if(st.equals("5")){	subQuery = "and nvl(a.use_yn,'Y')='N' and s.cls_st ='8' and a.car_mng_id is not null\n";				}
        else if(st.equals("6")){	subQuery = "and nvl(a.use_yn,'Y')='N' and s.cls_st ='9' and a.car_mng_id is not null\n";				}
        else if(st.equals("7")){	subQuery = "and nvl(a.use_yn,'Y')='Y' and b.prepare ='4'\n";											}
        else{        				subQuery = "and nvl(a.use_yn,'Y')='Y'";																}

        if(gubun.equals("firm_nm")){					gubunQuery = "and (nvl(c.firm_nm,' ') like '%" + gubun_nm + "%' or nvl(c.client_nm,' ') like '%" + gubun_nm + "%')\n";		}        
        else if(gubun.equals("client_nm")){				gubunQuery = "and nvl(c.client_nm,' ') like '%" + gubun_nm + "%'\n";														}
        else if(gubun.equals("car_no")){				gubunQuery = "and nvl(b.car_no,' ') like '%" + gubun_nm + "%'\n";															}
        else if(gubun.equals("car_nm")){				gubunQuery = "and j.car_nm||h.car_name like '%" + gubun_nm + "%'\n";														}
        else if(gubun.equals("dlv_dt")){				gubunQuery = "and a.dlv_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 +"','-','')\n";				}
        else if(gubun.equals("init_reg_dt")){			gubunQuery = "and b.init_reg_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 +"','-','')\n";			}
        else if(gubun.equals("car_end_dt")){			gubunQuery = "and (b.car_end_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 +"','-','')   or b.car_end_dt <= to_char(sysdate,'YYYYMMdd') )  \n";			}
    	else if(gubun.equals("brch_id")){				gubunQuery = "and nvl(a.brch_id,' ') like '%" + gubun_nm +"%'\n";															}
    	else if(gubun.equals("car_ext")){				gubunQuery = "and decode(nvl(b.car_ext,g.car_ext),'1','����','2','����','3','�λ�','4','����','5','����','6','��õ','7','��õ','8','����','9','����','10','�뱸') like '%" + gubun_nm +"%'\n";	}
        else if(gubun.equals("rent_l_cd")){				gubunQuery = "and nvl(a.rent_l_cd,' ') like '%" + gubun_nm +"%'\n";															}
        else if(gubun.equals("car_num")){				gubunQuery = "and nvl(b.car_num,' ') like '%" + gubun_nm +"%'\n";															}
        else if(gubun.equals("emp_nm")){				gubunQuery = "and nvl(l.emp_nm,' ') like '%" + gubun_nm +"%'\n";															}
        else if(gubun.equals("rpt_no")){				gubunQuery = "and nvl(f.rpt_no,' ') like '%" + gubun_nm +"%'\n";															}
        else if(gubun.equals("fuel_kd")){				gubunQuery = "and m.nm like '%" + gubun_nm +"%'\n";					}
		else if(gubun.equals("gps")){					gubunQuery = "and b.gps='Y'\n";															}
        else{											gubunQuery = "and b.car_mng_id=''\n";																						}
        
        /* ���� */
        if (!st.equals("3") && !st.equals("1")){
        	if(q_sort_nm.equals("firm_nm")){			sortQuery = "order by nvl(c.firm_nm,client_nm) " + q_sort + "\n";				}
        	else if(q_sort_nm.equals("car_no")){		sortQuery = "order by b.car_no " + q_sort + "\n";								}	
        	else if(q_sort_nm.equals("dlv_dt")){		sortQuery = "order by a.dlv_dt " + q_sort + "\n";								}
        	else if(q_sort_nm.equals("init_reg_dt")){	sortQuery = "order by b.init_reg_dt " + q_sort + "\n";							}
        	else if(q_sort_nm.equals("car_end_dt")){	sortQuery = "order by decode(b.car_use,'1',decode(length(replace(b.car_end_dt,' ','')),8,b.car_end_dt,decode(sign(b.dpm-2000),1,to_char(to_date(b.init_reg_dt,'YYYYMMDD')+(365*8),'YYYYMMDD'),to_char(to_date(b.init_reg_dt,'YYYYMMDD')+(365*5),'YYYYMMDD')))) " + q_sort + "\n";							}
        	else if(q_sort_nm.equals("car_nm")){		sortQuery = "order by j.car_nm||h.car_name " + q_sort + "\n";					}
        	else if(q_sort_nm.equals("emp_nm")){		sortQuery = "order by l.emp_nm " + q_sort + "\n";								}
        	else if(q_sort_nm.equals("car_ext")){		sortQuery = "order by b.car_ext " + q_sort + "\n";								}	
        	else{										sortQuery = "order by b.init_reg_dt, c.firm_nm " + q_sort + "\n";				}        	
        }else{
        	if(q_sort_nm.equals("firm_nm")){			sortQuery = "order by g.car_ext, f.dlv_est_dt, c.firm_nm " + q_sort + "\n";				}
        	else if(q_sort_nm.equals("car_no")){		sortQuery = "order by g.car_ext, f.dlv_est_dt, b.car_no " + q_sort + "\n";					}
        	else if(q_sort_nm.equals("dlv_dt")){		sortQuery = "order by g.car_ext, f.dlv_est_dt, a.dlv_dt " + q_sort + "\n";					}
        	else if(q_sort_nm.equals("init_reg_dt")){	sortQuery = "order by g.car_ext, f.dlv_est_dt, b.init_reg_dt " + q_sort + "\n";			}
      		else if(q_sort_nm.equals("car_end_dt")){	sortQuery = "order by g.car_ext, f.dlv_est_dt, b.car_end_dt " + q_sort + "\n";				}
        	else if(q_sort_nm.equals("car_nm")){		sortQuery = "order by g.car_ext, f.dlv_est_dt, h.car_name " + q_sort + "\n";				}
        	else if(q_sort_nm.equals("emp_nm")){		sortQuery = "order by g.car_ext, f.dlv_est_dt, l.emp_nm " + q_sort + "\n";					}
        	else if(q_sort_nm.equals("car_ext")){		sortQuery = "order by g.car_ext, f.dlv_est_dt, b.car_ext " + q_sort + "\n";					}
        	else{										sortQuery = "order by g.car_ext, f.dlv_est_dt, b.init_reg_dt, c.firm_nm " + q_sort + "\n";	}        	
		}        


		if(gubun.equals("car_no")){
	        query = "select     decode(sign(add_months(to_date(b.car_end_dt) , -3) - last_day(sysdate)) , -1, 'Y', 'N')  emp_nm,  decode(a.car_st,'1','��Ʈ','2',decode(b.car_use,'1','��Ʈ','2','����','����'),'3','����',decode(b.car_use,'1','��Ʈ','2','����')) car_st, nvl(b.car_ext, g.car_ext) car_ext, a.brch_id, a.rent_mng_id as RENT_MNG_ID, a.rent_l_cd as RENT_L_CD, decode(a.rent_dt,null,'',substr(a.rent_dt,1,4)||'-'||substr(a.rent_dt,5,2)||'-'||substr(a.rent_dt,7,2)) as RENT_DT, decode(a.dlv_dt,null,'',substr(a.dlv_dt,1,4)||'-'||substr(a.dlv_dt,5,2)||'-'||substr(a.dlv_dt,7,2)) as DLV_DT, a.client_id as CLIENT_ID,a.reg_id as REG_ID,\n" 
		    + "c.client_nm as CLIENT_NM, nvl(c.firm_nm,c.client_nm) as FIRM_NM,c.o_tel as O_TEL,c.fax as FAX,e.br_id as BR_ID, e.user_nm as bus_nm, \n" 
			+ "b.car_mng_id as CAR_MNG_ID, nvl2(b.init_reg_dt,substr(b.init_reg_dt,1,4)||'-'||substr(b.init_reg_dt,5,2)||'-'||substr(b.init_reg_dt,7,2),'') as INIT_REG_DT, nvl2(b.init_reg_dt,'ud','id') as REG_GUBUN, nvl2(b.car_no,b.car_no,nvl2(a.dlv_dt,'�̵��','�����')) as CAR_NO, b.car_num as CAR_NUM,\n"
			+ "d.rent_st as R_ST,d.rent_way as RENT_WAY,nvl(d.con_mon,'-') as CON_MON, decode(d.rent_start_dt,null,'',substr(d.rent_start_dt,1,4)||'-'||substr(d.rent_start_dt,5,2)||'-'||substr(d.rent_start_dt,7,2)) as RENT_START_DT, decode(d.rent_end_dt,null,'',substr(d.rent_end_dt,1,4)||'-'||substr(d.rent_end_dt,5,2)||'-'||substr(d.rent_end_dt,7,2)) as RENT_END_DT,\n"
			+ "decode(f.dlv_est_dt,'','',substr(f.dlv_est_dt,1,4)||'-'||substr(f.dlv_est_dt,5,2)||'-'||substr(f.dlv_est_dt,7,2)) as DLV_EST_DT, g.car_id as CAR_ID, g.imm_amt as IMM_AMT, decode(f.reg_ext_dt,null,'',substr(f.reg_ext_dt,1,4)||'-'||substr(f.reg_ext_dt,5,2)||'-'||substr(f.reg_ext_dt,7,2)) as REG_EXT_DT, f.rpt_no as RPT_NO, h.car_name as CAR_NAME, j.car_nm as CAR_NM,\n"//
			+ "i.cpt_cd as CPT_CD,  \n" 
			+ "decode(b.car_use,'1',decode(length(replace(b.car_end_dt,' ','')),8,b.car_end_dt,decode(sign(b.dpm-2000),1,to_char(to_date(b.init_reg_dt,'YYYYMMDD')+(365*8),'YYYYMMDD'),to_char(to_date(b.init_reg_dt,'YYYYMMDD')+(365*5),'YYYYMMDD'))),'-') car_end_dt, \n"
			+ "b.car_doc_no, k.migr_dt, b.OFF_LS, b.DPM , a.car_st rrm, decode(b.car_end_yn,'Y','��������','') car_end_yn, decode(b.prepare,'4','����','5','����','9','��ȸ��','') prepare, "
			+ " '' jg_g_16 , b.end_req_dt \n"
 			+ "from cont a, car_reg b, client c, fee d, users e, car_pur f, car_etc g, allot i, car_nm h, car_mng j, cls_cont s, \n"
			+ "(select a.rent_mng_id,a.rent_l_cd,a.emp_id,a.agnt_st,b.emp_nm, b.car_off_id, c.car_off_nm,c.car_off_tel\n"
			+ "		from commi a, car_off_emp b, car_off c\n" 
			+ "		where a.agnt_st='2'\n"
			+ "		and a.emp_id=b.emp_id\n"
			+ "		and b.car_off_id=c.car_off_id) l, sui k, \n"
			+ "     (select * from code where c_st='0039') m \n"			
			+ "where a.rent_mng_id like '%' \n"
			+ subQuery
			+ gubunQuery
			+ "and a.car_mng_id = b.car_mng_id(+)\n"
			+ "and a.client_id = c.client_id\n"
			+ "and d.rent_st='1' and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd\n"
			+ "and a.mng_id = e.user_id\n" 
			+ "and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_mng_id = g.rent_mng_id and a.rent_l_cd = g.rent_l_cd\n"
			+ "and g.car_id = h.car_id(+) and g.car_seq=h.car_seq(+) and h.car_comp_id=j.car_comp_id(+) and h.car_cd=j.code(+)\n"
			+ "and a.rent_mng_id = i.rent_mng_id(+) and a.rent_l_cd = i.rent_l_cd(+) \n"
			+ "and a.rent_mng_id = l.rent_mng_id(+) and a.rent_l_cd = l.rent_l_cd(+)\n"
			+ "and b.car_mng_id = k.car_mng_id(+)\n"
			+ "and a.rent_mng_id = s.rent_mng_id(+) and a.rent_l_cd = s.rent_l_cd(+)\n"
			+ "and b.fuel_kd=m.nm_cd "
			+ sortQuery;
		}else{
	        query = "select      decode(sign(add_months(to_date(b.car_end_dt) , -3) - last_day(sysdate)) , -1, 'Y', 'N')   emp_nm,   decode(a.car_st,'1','��Ʈ','2',decode(b.car_use,'1','��Ʈ','2','����','����'),'3','����',decode(b.car_use,'1','��Ʈ','2','����')) car_st, nvl(b.car_ext, g.car_ext) car_ext, a.brch_id, a.rent_mng_id as RENT_MNG_ID, a.rent_l_cd as RENT_L_CD, decode(a.rent_dt,null,'',substr(a.rent_dt,1,4)||'-'||substr(a.rent_dt,5,2)||'-'||substr(a.rent_dt,7,2)) as RENT_DT, decode(a.dlv_dt,null,'',substr(a.dlv_dt,1,4)||'-'||substr(a.dlv_dt,5,2)||'-'||substr(a.dlv_dt,7,2)) as DLV_DT, a.client_id as CLIENT_ID,a.reg_id as REG_ID,\n" 
		    + "c.client_nm as CLIENT_NM, nvl(c.firm_nm,c.client_nm) as FIRM_NM,c.o_tel as O_TEL,c.fax as FAX,e.br_id as BR_ID, e.user_nm as bus_nm, \n" 
			+ "b.car_mng_id as CAR_MNG_ID, nvl2(b.init_reg_dt,substr(b.init_reg_dt,1,4)||'-'||substr(b.init_reg_dt,5,2)||'-'||substr(b.init_reg_dt,7,2),'') as INIT_REG_DT, nvl2(b.init_reg_dt,'ud','id') as REG_GUBUN, nvl2(b.car_no,b.car_no,nvl2(a.dlv_dt,'�̵��','�����')) as CAR_NO, b.car_num as CAR_NUM,\n"
			+ "d.rent_st as R_ST,d.rent_way as RENT_WAY,nvl(d.con_mon,'-') as CON_MON, decode(d.rent_start_dt,null,'',substr(d.rent_start_dt,1,4)||'-'||substr(d.rent_start_dt,5,2)||'-'||substr(d.rent_start_dt,7,2)) as RENT_START_DT, decode(d.rent_end_dt,null,'',substr(d.rent_end_dt,1,4)||'-'||substr(d.rent_end_dt,5,2)||'-'||substr(d.rent_end_dt,7,2)) as RENT_END_DT,\n"
			+ "decode(f.dlv_est_dt,'','',substr(f.dlv_est_dt,1,4)||'-'||substr(f.dlv_est_dt,5,2)||'-'||substr(f.dlv_est_dt,7,2)) as DLV_EST_DT, g.car_id as CAR_ID, g.imm_amt as IMM_AMT, decode(f.reg_ext_dt,null,'',substr(f.reg_ext_dt,1,4)||'-'||substr(f.reg_ext_dt,5,2)||'-'||substr(f.reg_ext_dt,7,2)) as REG_EXT_DT, f.rpt_no as RPT_NO, h.car_name as CAR_NAME, j.car_nm as CAR_NM,\n"//
			+ "i.cpt_cd as CPT_CD,   \n" 
			+ "decode(b.car_use,'1',decode(length(replace(b.car_end_dt,' ','')),8,b.car_end_dt,decode(sign(b.dpm-2000),1,to_char(to_date(b.init_reg_dt,'YYYYMMDD')+(365*8),'YYYYMMDD'),to_char(to_date(b.init_reg_dt,'YYYYMMDD')+(365*5),'YYYYMMDD'))),'-') car_end_dt,\n"
			+ "b.car_doc_no, k.migr_dt, b.OFF_LS, b.DPM , a.car_st rrm, decode(b.car_end_yn,'Y','��������','') car_end_yn, decode(b.prepare,'4','����','5','����','9','��ȸ��','') prepare, "
			+ " '' jg_g_16 , b.end_req_dt \n"
			+ "from cont a, car_reg b, client c, fee d, users e, car_pur f, car_etc g, allot i, car_nm h, car_mng j, cls_cont s,\n"
			+ "(select a.rent_mng_id,a.rent_l_cd,a.emp_id,a.agnt_st,b.emp_nm, b.car_off_id, c.car_off_nm,c.car_off_tel\n"
			+ "		from commi a, car_off_emp b, car_off c\n" 
			+ "		where a.agnt_st='2'\n"
			+ "		and a.emp_id=b.emp_id\n"
			+ "		and b.car_off_id=c.car_off_id) l, sui k, \n"
			+ "     (select * from code where c_st='0039') m \n"			
			+ "where a.rent_mng_id like '%' \n"
			+ subQuery
			+ gubunQuery
			+ "and a.car_mng_id = b.car_mng_id(+)\n"
			+ "and a.client_id = c.client_id\n"
			+ "and d.rent_st='1' and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd\n"
			+ "and nvl(a.mng_id2, a.mng_id) = e.user_id\n"
			+ "and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_mng_id = g.rent_mng_id and a.rent_l_cd = g.rent_l_cd\n"
			+ "and g.car_id = h.car_id(+) and g.car_seq=h.car_seq(+) and h.car_comp_id=j.car_comp_id(+) and h.car_cd=j.code(+)\n"
			+ "and a.rent_mng_id = i.rent_mng_id(+) and a.rent_l_cd = i.rent_l_cd(+) \n"
			+ "and a.rent_mng_id = l.rent_mng_id(+) and a.rent_l_cd = l.rent_l_cd(+)\n"
			+ "and a.rent_mng_id = s.rent_mng_id(+) and a.rent_l_cd = s.rent_l_cd(+)\n"
			+ "and b.car_mng_id = k.car_mng_id(+)\n"
			+ "and b.fuel_kd=m.nm_cd "
			+ sortQuery;
		}


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
			con = null;
        }
        return (RentListBean[])col.toArray(new RentListBean[0]);
    }
    
    /**
     * ������ �߰� 11(���ɸ����� �˻��׸��߰�-������ȣ, ����)
     * ������, �ڵ��� ��� ����Ʈ ��ȸ - ������ ���� //String gubun3  ���� ��Ŵ.(2009.11.06)-���漱 ����
	 * - 2003.08.20 ��.(�ǿ��) :��ȸ�� getRegListAllCount()�� ��ġ�� �����ʾ� car_change ���̺� ����. -- 11
     */
    public RentListBean [] getRegListAll2(String br_id, String st, String ref_dt1, String ref_dt2, String gubun, String gubun_nm, String q_sort_nm, String q_sort, String s_kd, String t_wd, String brid) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String subQuery = "";
        String gubunQuery = "";
        String sortQuery = "";
        
        String query = "";
        
        if(st.equals("1")){			subQuery = "and nvl(a.use_yn,'Y')='Y' and a.car_mng_id is null and a.dlv_dt is not null\n";			}
        else if(st.equals("2")){	subQuery = "and nvl(a.use_yn,'Y')='Y' and a.car_mng_id is not null and nvl(b.prepare,'1')<>'4'\n";	}
        else if(st.equals("3")){	subQuery = "and nvl(a.use_yn,'Y')='Y' and a.car_mng_id is null and a.dlv_dt is null\n";				}
        else if(st.equals("4")){	subQuery = "and nvl(a.use_yn,'Y')='N' and s.cls_st ='6' and a.car_mng_id is not null\n";				}
        else if(st.equals("5")){	subQuery = "and nvl(a.use_yn,'Y')='N' and s.cls_st ='8' and a.car_mng_id is not null\n";				}
        else if(st.equals("6")){	subQuery = "and nvl(a.use_yn,'Y')='N' and s.cls_st ='9' and a.car_mng_id is not null\n";				}
        else if(st.equals("7")){	subQuery = "and nvl(a.use_yn,'Y')='Y' and b.prepare ='4'\n";											}
        else{        				subQuery = "and nvl(a.use_yn,'Y')='Y'";																}

        if(gubun.equals("firm_nm")){					gubunQuery = "and (nvl(c.firm_nm,' ') like '%" + gubun_nm + "%' or nvl(c.client_nm,' ') like '%" + gubun_nm + "%')\n";		}        
        else if(gubun.equals("client_nm")){				gubunQuery = "and nvl(c.client_nm,' ') like '%" + gubun_nm + "%'\n";														}
        else if(gubun.equals("car_no")){				gubunQuery = "and nvl(b.car_no,' ') like '%" + gubun_nm + "%'\n";															}
        else if(gubun.equals("car_nm")){				gubunQuery = "and j.car_nm||h.car_name like '%" + gubun_nm + "%'\n";														}
        else if(gubun.equals("dlv_dt")){				gubunQuery = "and a.dlv_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 +"','-','')\n";				}
        else if(gubun.equals("init_reg_dt")){			gubunQuery = "and b.init_reg_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 +"','-','')\n";			}
        else if(gubun.equals("car_end_dt")){			gubunQuery = "and (b.car_end_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 +"','-','')   or b.car_end_dt <= to_char(sysdate,'YYYYMMdd') )  \n";			}
    	else if(gubun.equals("brch_id")){				gubunQuery = "and nvl(a.brch_id,' ') like '%" + gubun_nm +"%'\n";															}
    	else if(gubun.equals("car_ext")){				gubunQuery = "and decode(nvl(b.car_ext,g.car_ext),'1','����','2','����','3','�λ�','4','����','5','����','6','��õ','7','��õ','8','����','9','����','10','�뱸') like '%" + gubun_nm +"%'\n";	}
        else if(gubun.equals("rent_l_cd")){				gubunQuery = "and nvl(a.rent_l_cd,' ') like '%" + gubun_nm +"%'\n";															}
        else if(gubun.equals("car_num")){				gubunQuery = "and nvl(b.car_num,' ') like '%" + gubun_nm +"%'\n";															}
        else if(gubun.equals("emp_nm")){				gubunQuery = "and nvl(l.emp_nm,' ') like '%" + gubun_nm +"%'\n";															}
        else if(gubun.equals("rpt_no")){				gubunQuery = "and nvl(f.rpt_no,' ') like '%" + gubun_nm +"%'\n";															}
        else if(gubun.equals("fuel_kd")){				gubunQuery = "and m.nm like '%" + gubun_nm +"%'\n";					}
		else if(gubun.equals("gps")){					gubunQuery = "and b.gps='Y'\n";															}
        else{											gubunQuery = "and b.car_mng_id=''\n";																						}
        
        if (gubun.equals("car_end_dt")){	
        	
        		if (!t_wd.equals("")){
        			if (s_kd.equals("1")) {
        				gubunQuery += "and nvl(b.car_no,' ') like '%" + t_wd + "%'\n";  //������ȣ
        			} else if (s_kd.equals("2")) {
        				gubunQuery += "and nvl(e.user_nm,' ') like '%" + t_wd + "%'\n";   //�����
        			} else {
        				gubunQuery += "and decode(nvl(b.car_ext,g.car_ext),'1','����','2','����','3','�λ�','4','����','5','����','6','��õ','7','��õ','8','����','9','����','10','�뱸') like '%" + t_wd + "%'\n";   //����
        			}
        		}
        	 
        	if (!brid.equals("")){
	        	if (brid.equals("3")){
	        		gubunQuery += "and nvl(e.br_id,'')='B1' ";
	        	} else if (brid.equals("4")){
	        		gubunQuery += "and nvl(e.br_id,'')='D1' ";
	        	} else if (brid.equals("5")){
	        		gubunQuery += "and nvl(e.br_id,'')='J1' ";
	        	} else if (brid.equals("6")){
	        		gubunQuery += "and nvl(e.br_id,'')='G1' ";
	        	} else {
	        		gubunQuery += "and nvl(e.br_id,'') in ('S1', 'S2', 'S3', 'S4', 'S5', 'S6', 'I1', 'K3') ";
	        	}
        	}	
        }
        
        /* ���� */
        if (!st.equals("3") && !st.equals("1")){
        	if(q_sort_nm.equals("firm_nm")){			sortQuery = "order by nvl(c.firm_nm,client_nm) " + q_sort + "\n";				}
        	else if(q_sort_nm.equals("car_no")){		sortQuery = "order by b.car_no " + q_sort + "\n";								}	
        	else if(q_sort_nm.equals("dlv_dt")){		sortQuery = "order by a.dlv_dt " + q_sort + "\n";								}
        	else if(q_sort_nm.equals("init_reg_dt")){	sortQuery = "order by b.init_reg_dt " + q_sort + "\n";							}
        	else if(q_sort_nm.equals("car_end_dt")){	sortQuery = "order by decode(b.car_use,'1',decode(length(replace(b.car_end_dt,' ','')),8,b.car_end_dt,decode(sign(b.dpm-2000),1,to_char(to_date(b.init_reg_dt,'YYYYMMDD')+(365*8),'YYYYMMDD'),to_char(to_date(b.init_reg_dt,'YYYYMMDD')+(365*5),'YYYYMMDD')))) " + q_sort + "\n";							}
        	else if(q_sort_nm.equals("car_nm")){		sortQuery = "order by j.car_nm||h.car_name " + q_sort + "\n";					}
        	else if(q_sort_nm.equals("emp_nm")){		sortQuery = "order by l.emp_nm " + q_sort + "\n";								}
        	else if(q_sort_nm.equals("car_ext")){		sortQuery = "order by b.car_ext " + q_sort + "\n";								}	
        	else{										sortQuery = "order by b.init_reg_dt, c.firm_nm " + q_sort + "\n";				}        	
        }else{
        	if(q_sort_nm.equals("firm_nm")){			sortQuery = "order by g.car_ext, f.dlv_est_dt, c.firm_nm " + q_sort + "\n";				}
        	else if(q_sort_nm.equals("car_no")){		sortQuery = "order by g.car_ext, f.dlv_est_dt, b.car_no " + q_sort + "\n";					}
        	else if(q_sort_nm.equals("dlv_dt")){		sortQuery = "order by g.car_ext, f.dlv_est_dt, a.dlv_dt " + q_sort + "\n";					}
        	else if(q_sort_nm.equals("init_reg_dt")){	sortQuery = "order by g.car_ext, f.dlv_est_dt, b.init_reg_dt " + q_sort + "\n";			}
      		else if(q_sort_nm.equals("car_end_dt")){	sortQuery = "order by g.car_ext, f.dlv_est_dt, b.car_end_dt " + q_sort + "\n";				}
        	else if(q_sort_nm.equals("car_nm")){		sortQuery = "order by g.car_ext, f.dlv_est_dt, h.car_name " + q_sort + "\n";				}
        	else if(q_sort_nm.equals("emp_nm")){		sortQuery = "order by g.car_ext, f.dlv_est_dt, l.emp_nm " + q_sort + "\n";					}
        	else if(q_sort_nm.equals("car_ext")){		sortQuery = "order by g.car_ext, f.dlv_est_dt, b.car_ext " + q_sort + "\n";					}
        	else{										sortQuery = "order by g.car_ext, f.dlv_est_dt, b.init_reg_dt, c.firm_nm " + q_sort + "\n";	}        	
		}        

		if(gubun.equals("car_no")){
	        query = "select     decode(sign(add_months(to_date(b.car_end_dt) , -3) - last_day(sysdate)) , -1, 'Y', 'N')  emp_nm,  decode(a.car_st,'1','��Ʈ','2',decode(b.car_use,'1','��Ʈ','2','����','����'),'3','����',decode(b.car_use,'1','��Ʈ','2','����')) car_st, nvl(b.car_ext, g.car_ext) car_ext, a.brch_id, a.rent_mng_id as RENT_MNG_ID, a.rent_l_cd as RENT_L_CD, decode(a.rent_dt,null,'',substr(a.rent_dt,1,4)||'-'||substr(a.rent_dt,5,2)||'-'||substr(a.rent_dt,7,2)) as RENT_DT, decode(a.dlv_dt,null,'',substr(a.dlv_dt,1,4)||'-'||substr(a.dlv_dt,5,2)||'-'||substr(a.dlv_dt,7,2)) as DLV_DT, a.client_id as CLIENT_ID,a.reg_id as REG_ID,\n" 
		    + "c.client_nm as CLIENT_NM, nvl(c.firm_nm,c.client_nm) as FIRM_NM,c.o_tel as O_TEL,c.fax as FAX,e.br_id as BR_ID, e.user_nm as bus_nm, \n" 
			+ "b.car_mng_id as CAR_MNG_ID, nvl2(b.init_reg_dt,substr(b.init_reg_dt,1,4)||'-'||substr(b.init_reg_dt,5,2)||'-'||substr(b.init_reg_dt,7,2),'') as INIT_REG_DT, nvl2(b.init_reg_dt,'ud','id') as REG_GUBUN, nvl2(b.car_no,b.car_no,nvl2(a.dlv_dt,'�̵��','�����')) as CAR_NO, b.car_num as CAR_NUM,\n"
			+ "d.rent_st as R_ST,d.rent_way as RENT_WAY,nvl(d.con_mon,'-') as CON_MON, decode(d.rent_start_dt,null,'',substr(d.rent_start_dt,1,4)||'-'||substr(d.rent_start_dt,5,2)||'-'||substr(d.rent_start_dt,7,2)) as RENT_START_DT, decode(d.rent_end_dt,null,'',substr(d.rent_end_dt,1,4)||'-'||substr(d.rent_end_dt,5,2)||'-'||substr(d.rent_end_dt,7,2)) as RENT_END_DT,\n"
			+ "decode(f.dlv_est_dt,'','',substr(f.dlv_est_dt,1,4)||'-'||substr(f.dlv_est_dt,5,2)||'-'||substr(f.dlv_est_dt,7,2)) as DLV_EST_DT, g.car_id as CAR_ID, g.imm_amt as IMM_AMT, decode(f.reg_ext_dt,null,'',substr(f.reg_ext_dt,1,4)||'-'||substr(f.reg_ext_dt,5,2)||'-'||substr(f.reg_ext_dt,7,2)) as REG_EXT_DT, f.rpt_no as RPT_NO, h.car_name as CAR_NAME, j.car_nm as CAR_NM,\n"//
			+ "i.cpt_cd as CPT_CD,  \n"
			+ "decode(b.car_use,'1',decode(length(replace(b.car_end_dt,' ','')),8,b.car_end_dt,decode(sign(b.dpm-2000),1,to_char(to_date(b.init_reg_dt,'YYYYMMDD')+(365*8),'YYYYMMDD'),to_char(to_date(b.init_reg_dt,'YYYYMMDD')+(365*5),'YYYYMMDD'))),'-') car_end_dt, \n"
			+ "b.car_doc_no, k.migr_dt, b.OFF_LS, b.DPM , a.car_st rrm, decode(b.car_end_yn,'Y','��������','') car_end_yn, decode(b.prepare,'4','����','5','����','9','��ȸ��','') prepare, "
			+ " '' jg_g_16 \n"
 			+ "from cont a, car_reg b, client c, fee d, users e, car_pur f, car_etc g, allot i, car_nm h, car_mng j, cls_cont s, \n"//--, code j car_change k, 
 			+ " (select rent_l_cd,  max(to_number(rent_st)) KEEP( DENSE_RANK FIRST  ORDER BY rent_l_cd, to_number(rent_st) DESC) rent_st   from   fee  group by rent_l_cd) ll , \n"
			+ "(select a.rent_mng_id,a.rent_l_cd,a.emp_id,a.agnt_st,b.emp_nm, b.car_off_id, c.car_off_nm,c.car_off_tel\n"
			+ "		from commi a, car_off_emp b, car_off c\n" 
			+ "		where a.agnt_st='2'\n"
			+ "		and a.emp_id=b.emp_id\n"
			+ "		and b.car_off_id=c.car_off_id) l, sui k, \n"
			+ "     (select * from code where c_st='0039') m \n"
			+ "where a.rent_mng_id like '%' \n"
			+ subQuery
			+ gubunQuery
			+ "and a.car_mng_id = b.car_mng_id(+)\n"
			+ "and a.client_id = c.client_id\n"
			+ "and  a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd \n"
			+ "and a.mng_id = e.user_id\n" 
			+ "and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_mng_id = g.rent_mng_id and a.rent_l_cd = g.rent_l_cd\n"
			+ "and g.car_id = h.car_id(+) and g.car_seq=h.car_seq(+) and h.car_comp_id=j.car_comp_id(+) and h.car_cd=j.code(+)\n"
			+ "and a.rent_mng_id = i.rent_mng_id(+) and a.rent_l_cd = i.rent_l_cd(+) \n"
			+ "and a.rent_mng_id = l.rent_mng_id(+) and a.rent_l_cd = l.rent_l_cd(+)\n"
			+ "and b.car_mng_id = k.car_mng_id(+)\n"
			+ "and d.rent_l_cd = ll.rent_l_cd and d.rent_st = ll.rent_st \n"
			+ "and a.rent_mng_id = s.rent_mng_id(+) and a.rent_l_cd = s.rent_l_cd(+) and b.fuel_kd=m.nm_cd \n"
			+ sortQuery;
		}else{
	        query = "select      decode(sign(add_months(to_date(b.car_end_dt) , -3) - last_day(sysdate)) , -1, 'Y', 'N')   emp_nm,   decode(a.car_st,'1','��Ʈ','2',decode(b.car_use,'1','��Ʈ','2','����','����'),'3','����',decode(b.car_use,'1','��Ʈ','2','����')) car_st, nvl(b.car_ext, g.car_ext) car_ext, a.brch_id, a.rent_mng_id as RENT_MNG_ID, a.rent_l_cd as RENT_L_CD, decode(a.rent_dt,null,'',substr(a.rent_dt,1,4)||'-'||substr(a.rent_dt,5,2)||'-'||substr(a.rent_dt,7,2)) as RENT_DT, decode(a.dlv_dt,null,'',substr(a.dlv_dt,1,4)||'-'||substr(a.dlv_dt,5,2)||'-'||substr(a.dlv_dt,7,2)) as DLV_DT, a.client_id as CLIENT_ID,a.reg_id as REG_ID,\n" 
		    + " c.client_nm as CLIENT_NM, nvl(c.firm_nm,c.client_nm) as FIRM_NM,c.o_tel as O_TEL,c.fax as FAX,e.br_id as BR_ID, e.user_nm as bus_nm, \n" 
			+ " b.car_mng_id as CAR_MNG_ID, nvl2(b.init_reg_dt,substr(b.init_reg_dt,1,4)||'-'||substr(b.init_reg_dt,5,2)||'-'||substr(b.init_reg_dt,7,2),'') as INIT_REG_DT, nvl2(b.init_reg_dt,'ud','id') as REG_GUBUN, nvl2(b.car_no,b.car_no,nvl2(a.dlv_dt,'�̵��','�����')) as CAR_NO, b.car_num as CAR_NUM,\n"
			+ " d.rent_st as R_ST,d.rent_way as RENT_WAY,nvl(d.con_mon,'-') as CON_MON, decode(d.rent_start_dt,null,'',substr(d.rent_start_dt,1,4)||'-'||substr(d.rent_start_dt,5,2)||'-'||substr(d.rent_start_dt,7,2)) as RENT_START_DT, decode(d.rent_end_dt,null,'',substr(d.rent_end_dt,1,4)||'-'||substr(d.rent_end_dt,5,2)||'-'||substr(d.rent_end_dt,7,2)) as RENT_END_DT,\n"
			+ " decode(f.dlv_est_dt,'','',substr(f.dlv_est_dt,1,4)||'-'||substr(f.dlv_est_dt,5,2)||'-'||substr(f.dlv_est_dt,7,2)) as DLV_EST_DT, g.car_id as CAR_ID, g.imm_amt as IMM_AMT, decode(f.reg_ext_dt,null,'',substr(f.reg_ext_dt,1,4)||'-'||substr(f.reg_ext_dt,5,2)||'-'||substr(f.reg_ext_dt,7,2)) as REG_EXT_DT, f.rpt_no as RPT_NO, h.car_name as CAR_NAME, j.car_nm as CAR_NM,\n"//
			+ " i.cpt_cd as CPT_CD,   \n" 
			+ " decode(b.car_use,'1',decode(length(replace(b.car_end_dt,' ','')),8,b.car_end_dt,decode(sign(b.dpm-2000),1,to_char(to_date(b.init_reg_dt,'YYYYMMDD')+(365*8),'YYYYMMDD'),to_char(to_date(b.init_reg_dt,'YYYYMMDD')+(365*5),'YYYYMMDD'))),'-') car_end_dt,\n"
			+ " b.car_doc_no, k.migr_dt, b.OFF_LS, b.DPM , a.car_st rrm, decode(b.car_end_yn,'Y','��������','') car_end_yn, decode(b.prepare,'4','����','5','����','9','��ȸ��','') prepare, \n" 
			+ " '' jg_g_16 \n"
			+ " from cont a, car_reg b, client c, fee d, users e, car_pur f, car_etc g, allot i, car_nm h, car_mng j, cls_cont s,\n"//--, code j
			+ " (select rent_l_cd,  max(to_number(rent_st)) KEEP( DENSE_RANK FIRST  ORDER BY rent_l_cd, to_number(rent_st) DESC) rent_st   from   fee  group by rent_l_cd) ll , \n"
			+ " (select a.rent_mng_id,a.rent_l_cd,a.emp_id,a.agnt_st,b.emp_nm, b.car_off_id, c.car_off_nm,c.car_off_tel\n"
			+ "		from commi a, car_off_emp b, car_off c\n" 
			+ "		where a.agnt_st='2'\n"
			+ "		and a.emp_id=b.emp_id\n"
			+ "		and b.car_off_id=c.car_off_id) l, sui k, \n"
			+ "     (select * from code where c_st='0039') m \n"
			+ "where a.rent_mng_id like '%' \n"
			+ subQuery
			+ gubunQuery
			+ "and a.car_mng_id = b.car_mng_id(+)\n"
			+ "and a.client_id = c.client_id\n"
			+ "and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd\n"
			+ "and nvl(a.mng_id2, a.mng_id) = e.user_id\n"
			+ "and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_mng_id = g.rent_mng_id and a.rent_l_cd = g.rent_l_cd\n"
			+ "and g.car_id = h.car_id(+) and g.car_seq=h.car_seq(+) and h.car_comp_id=j.car_comp_id(+) and h.car_cd=j.code(+)\n"
			+ "and a.rent_mng_id = i.rent_mng_id(+) and a.rent_l_cd = i.rent_l_cd(+) \n"
			+ "and d.rent_l_cd = ll.rent_l_cd and d.rent_st = ll.rent_st \n"
			+ "and a.rent_mng_id = l.rent_mng_id(+) and a.rent_l_cd = l.rent_l_cd(+)\n"
			+ "and a.rent_mng_id = s.rent_mng_id(+) and a.rent_l_cd = s.rent_l_cd(+) and b.fuel_kd=m.nm_cd \n"
			+ "and b.car_mng_id = k.car_mng_id(+)\n"
			+ sortQuery;
		}


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
			con = null;
        }
        return (RentListBean[])col.toArray(new RentListBean[0]);
    }

    /**
     *  �߰� 12 (���ɸ����� �˻��׸��߰�-������ȣ, ����, �����Ȳ, ���Ǻ����� ���Կɼǵ�����(2022-08))
     */
    public RentListBean [] getRegListAll2(String br_id, String st, String ref_dt1, String ref_dt2, String gubun, String gubun_nm, String q_sort_nm, String q_sort, String s_kd, String t_wd, String brid, String actn) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String subQuery = "";
        String subQuery1 = "";
        String gubunQuery = "";
        String sortQuery = "";
        
        String query = "";
        
        //���Ǻ����� ���Կɼ� ���� 
        subQuery1 = " and a.car_mng_id is not null and nvl(b.prepare,'1')<>'4'  and  ( nvl(a.use_yn,'Y') ='Y' or ( s.cls_st ='8' and k.migr_dt is null and b.car_use = '1' )  )   \n";	
        
        if(st.equals("1")){			subQuery = " and nvl(a.use_yn,'Y')='Y' and a.car_mng_id is null and a.dlv_dt is not null\n";			}        
        else if(st.equals("2")){	subQuery = " and nvl(a.use_yn,'Y')='Y' and a.car_mng_id is not null and nvl(b.prepare,'1')<>'4'\n";	}     
        else if(st.equals("3")){	subQuery = "and nvl(a.use_yn,'Y')='Y' and a.car_mng_id is null and a.dlv_dt is null\n";				}
        else if(st.equals("4")){	subQuery = "and nvl(a.use_yn,'Y')='N' and s.cls_st ='6' and a.car_mng_id is not null\n";				}
        else if(st.equals("5")){	subQuery = "and nvl(a.use_yn,'Y')='N' and s.cls_st ='8' and a.car_mng_id is not null\n";				}
        else if(st.equals("6")){	subQuery = "and nvl(a.use_yn,'Y')='N' and s.cls_st ='9' and a.car_mng_id is not null\n";				}
        else if(st.equals("7")){	subQuery = "and nvl(a.use_yn,'Y')='Y' and b.prepare ='4'\n";											}
        else{        				subQuery = "and nvl(a.use_yn,'Y')='Y'";																}
               

        if(gubun.equals("firm_nm")){					gubunQuery = "and (nvl(c.firm_nm,' ') like '%" + gubun_nm + "%' or nvl(c.client_nm,' ') like '%" + gubun_nm + "%')\n";		}        
        else if(gubun.equals("client_nm")){				gubunQuery = "and nvl(c.client_nm,' ') like '%" + gubun_nm + "%'\n";														}
        else if(gubun.equals("car_no")){				gubunQuery = "and nvl(b.car_no,' ') like '%" + gubun_nm + "%'\n";															}
        else if(gubun.equals("car_nm")){				gubunQuery = "and j.car_nm||h.car_name like '%" + gubun_nm + "%'\n";														}
        else if(gubun.equals("dlv_dt")){				gubunQuery = "and a.dlv_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 +"','-','')\n";				}
        else if(gubun.equals("init_reg_dt")){			gubunQuery = "and b.init_reg_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 +"','-','')\n";			}
        else if(gubun.equals("car_end_dt")){			gubunQuery = "and (b.car_end_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 +"','-','')   or b.car_end_dt <= to_char(sysdate,'YYYYMMdd') )  \n";			}
    	else if(gubun.equals("brch_id")){				gubunQuery = "and nvl(a.brch_id,' ') like '%" + gubun_nm +"%'\n";															}
    	else if(gubun.equals("car_ext")){				gubunQuery = "and decode(nvl(b.car_ext,g.car_ext),'1','����','2','����','3','�λ�','4','����','5','����','6','��õ','7','��õ','8','����','9','����','10','�뱸') like '%" + gubun_nm +"%'\n";	}
        else if(gubun.equals("rent_l_cd")){				gubunQuery = "and nvl(a.rent_l_cd,' ') like '%" + gubun_nm +"%'\n";															}
        else if(gubun.equals("car_num")){				gubunQuery = "and nvl(b.car_num,' ') like '%" + gubun_nm +"%'\n";															}
        else if(gubun.equals("emp_nm")){				gubunQuery = "and nvl(l.emp_nm,' ') like '%" + gubun_nm +"%'\n";															}
        else if(gubun.equals("rpt_no")){				gubunQuery = "and nvl(f.rpt_no,' ') like '%" + gubun_nm +"%'\n";															}
        else if(gubun.equals("fuel_kd")){				gubunQuery = "and m.nm like '%" + gubun_nm +"%'\n";					}
		else if(gubun.equals("gps")){					gubunQuery = "and b.gps='Y'\n";															}
        else{											gubunQuery = "and b.car_mng_id=''\n";																						}
        
        if (gubun.equals("car_end_dt")){	
        	
        		if (!t_wd.equals("")){
        			if (s_kd.equals("1")) {
        				gubunQuery += "and nvl(b.car_no,' ') like '%" + t_wd + "%'\n";  //������ȣ
        			} else if (s_kd.equals("2")) {
        				gubunQuery += "and nvl(e.user_nm,' ') like '%" + t_wd + "%'\n";   //�����
        			} else if (s_kd.equals("4")) {  //ó�������� 
        				gubunQuery += "and nvl(b.end_req_dt,' ') like '%" + t_wd + "%'\n";    
        			} else {
        				gubunQuery += "and decode(nvl(b.car_ext,g.car_ext),'1','����','2','����','3','�λ�','4','����','5','����','6','��õ','7','��õ','8','����','9','����','10','�뱸') like '%" + t_wd + "%'\n";   //����
        			}
        		}
        	 
        	if (!brid.equals("")){
	        	if (brid.equals("3")){
	        		gubunQuery += "and nvl(e.br_id,'')='B1' ";
	        	} else if (brid.equals("4")){
	        		gubunQuery += "and nvl(e.br_id,'')='D1' ";
	        	} else if (brid.equals("5")){
	        		gubunQuery += "and nvl(e.br_id,'')='J1' ";
	        	} else if (brid.equals("6")){
	        		gubunQuery += "and nvl(e.br_id,'')='G1' ";
	        	} else {
	        		gubunQuery += "and nvl(e.br_id,'') in ('S1', 'S2', 'S3', 'S4', 'S5', 'S6', 'I1', 'K3') ";
	        	}
        	}	
        	
        	if (!actn.equals("")){
	        	if (actn.equals("5")){
	        		gubunQuery += "and b.OFF_LS='5' ";
	        	} else if (actn.equals("3")){
	        		gubunQuery += "and b.OFF_LS='3' ";	  
	        	} else if (actn.equals("6")){
	        		gubunQuery += "and b.OFF_LS not in ('3' , '5' )  ";	 	
	        //	} else {
	        //		gubunQuery += "and nvl(e.br_id,'') in ('S1', 'S2', 'S3', 'S4', 'S5', 'S6', 'I1', 'K3') ";
	        	}
        	}	
        }
        
        /* ���� */
        if (!st.equals("3") && !st.equals("1")){
        	if(q_sort_nm.equals("firm_nm")){			sortQuery = "order by nvl(c.firm_nm,client_nm) " + q_sort + "\n";				}
        	else if(q_sort_nm.equals("car_no")){		sortQuery = "order by b.car_no " + q_sort + "\n";								}	
        	else if(q_sort_nm.equals("dlv_dt")){		sortQuery = "order by a.dlv_dt " + q_sort + "\n";								}
        	else if(q_sort_nm.equals("init_reg_dt")){	sortQuery = "order by b.init_reg_dt " + q_sort + "\n";							}
        //	else if(q_sort_nm.equals("car_end_dt")){	sortQuery = "order by decode(b.car_use,'1',decode(length(replace(b.car_end_dt,' ','')),8,b.car_end_dt, b.car_doc_no, decode(sign(b.dpm-2000),1,to_char(to_date(b.init_reg_dt,'YYYYMMDD')+(365*8),'YYYYMMDD'),to_char(to_date(b.init_reg_dt,'YYYYMMDD')+(365*5),'YYYYMMDD')))) , b.car_doc_no  " + q_sort + "\n";	
        	else if(q_sort_nm.equals("car_end_dt")){	sortQuery = "order by 35, 36 " + q_sort + "\n";			}
        	else if(q_sort_nm.equals("car_nm")){		sortQuery = "order by j.car_nm||h.car_name " + q_sort + "\n";					}
        	else if(q_sort_nm.equals("emp_nm")){		sortQuery = "order by l.emp_nm " + q_sort + "\n";								}
        	else if(q_sort_nm.equals("car_ext")){		sortQuery = "order by b.car_ext " + q_sort + "\n";								}	
        	else{										sortQuery = "order by b.init_reg_dt, c.firm_nm " + q_sort + "\n";				}        	
        }else{
        	if(q_sort_nm.equals("firm_nm")){			sortQuery = "order by g.car_ext, f.dlv_est_dt, c.firm_nm " + q_sort + "\n";				}
        	else if(q_sort_nm.equals("car_no")){		sortQuery = "order by g.car_ext, f.dlv_est_dt, b.car_no " + q_sort + "\n";					}
        	else if(q_sort_nm.equals("dlv_dt")){		sortQuery = "order by g.car_ext, f.dlv_est_dt, a.dlv_dt " + q_sort + "\n";					}
        	else if(q_sort_nm.equals("init_reg_dt")){	sortQuery = "order by g.car_ext, f.dlv_est_dt, b.init_reg_dt " + q_sort + "\n";			}
      		else if(q_sort_nm.equals("car_end_dt")){	sortQuery = "order by g.car_ext, f.dlv_est_dt, b.car_end_dt " + q_sort + "\n";				}
        	else if(q_sort_nm.equals("car_nm")){		sortQuery = "order by g.car_ext, f.dlv_est_dt, h.car_name " + q_sort + "\n";				}
        	else if(q_sort_nm.equals("emp_nm")){		sortQuery = "order by g.car_ext, f.dlv_est_dt, l.emp_nm " + q_sort + "\n";					}
        	else if(q_sort_nm.equals("car_ext")){		sortQuery = "order by g.car_ext, f.dlv_est_dt, b.car_ext " + q_sort + "\n";					}
        	else{										sortQuery = "order by g.car_ext, f.dlv_est_dt, b.init_reg_dt, c.firm_nm " + q_sort + "\n";	}        	
		}        

		if(gubun.equals("car_no")){
	        query = "select     decode(sign(add_months(to_date(b.car_end_dt) , -3) - last_day(sysdate)) , -1, 'Y', 'N')  emp_nm,  decode(a.car_st,'1','��Ʈ','2',decode(b.car_use,'1','��Ʈ','2','����','����'),'3','����',decode(b.car_use,'1','��Ʈ','2','����')) car_st, nvl(b.car_ext, g.car_ext) car_ext, a.brch_id, a.rent_mng_id as RENT_MNG_ID, a.rent_l_cd as RENT_L_CD, decode(a.rent_dt,null,'',substr(a.rent_dt,1,4)||'-'||substr(a.rent_dt,5,2)||'-'||substr(a.rent_dt,7,2)) as RENT_DT, decode(a.dlv_dt,null,'',substr(a.dlv_dt,1,4)||'-'||substr(a.dlv_dt,5,2)||'-'||substr(a.dlv_dt,7,2)) as DLV_DT, a.client_id as CLIENT_ID,a.reg_id as REG_ID,\n" 
		    + "c.client_nm as CLIENT_NM, nvl(c.firm_nm,c.client_nm) as FIRM_NM,c.o_tel as O_TEL,c.fax as FAX,e.br_id as BR_ID, e.user_nm as bus_nm, \n" 
			+ "b.car_mng_id as CAR_MNG_ID, nvl2(b.init_reg_dt,substr(b.init_reg_dt,1,4)||'-'||substr(b.init_reg_dt,5,2)||'-'||substr(b.init_reg_dt,7,2),'') as INIT_REG_DT, nvl2(b.init_reg_dt,'ud','id') as REG_GUBUN, nvl2(b.car_no,b.car_no,nvl2(a.dlv_dt,'�̵��','�����')) as CAR_NO, b.car_num as CAR_NUM,\n"
			+ "d.rent_st as R_ST,d.rent_way as RENT_WAY,nvl(d.con_mon,'-') as CON_MON, decode(d.rent_start_dt,null,'',substr(d.rent_start_dt,1,4)||'-'||substr(d.rent_start_dt,5,2)||'-'||substr(d.rent_start_dt,7,2)) as RENT_START_DT, decode(d.rent_end_dt,null,'',substr(d.rent_end_dt,1,4)||'-'||substr(d.rent_end_dt,5,2)||'-'||substr(d.rent_end_dt,7,2)) as RENT_END_DT,\n"
			+ "decode(f.dlv_est_dt,'','',substr(f.dlv_est_dt,1,4)||'-'||substr(f.dlv_est_dt,5,2)||'-'||substr(f.dlv_est_dt,7,2)) as DLV_EST_DT, g.car_id as CAR_ID, g.imm_amt as IMM_AMT, decode(f.reg_ext_dt,null,'',substr(f.reg_ext_dt,1,4)||'-'||substr(f.reg_ext_dt,5,2)||'-'||substr(f.reg_ext_dt,7,2)) as REG_EXT_DT, f.rpt_no as RPT_NO, h.car_name as CAR_NAME, j.car_nm as CAR_NM,\n"//
			+ "i.cpt_cd as CPT_CD,  \n"
			+ "decode(b.car_use,'1',decode(length(replace(b.car_end_dt,' ','')),8,b.car_end_dt,decode(sign(b.dpm-2000),1,to_char(to_date(b.init_reg_dt,'YYYYMMDD')+(365*8),'YYYYMMDD'),to_char(to_date(b.init_reg_dt,'YYYYMMDD')+(365*5),'YYYYMMDD'))),'-') car_end_dt, \n"
			+ "b.car_doc_no, k.migr_dt, b.OFF_LS, b.DPM , a.car_st rrm, decode(b.car_end_yn,'Y','��������','') car_end_yn, decode(b.prepare,'4','����','5','����','9','��ȸ��','') prepare, "
			+ " '' jg_g_16 , b.end_req_dt \n"
 			+ "from cont a, car_reg b, client c, fee d, users e, car_pur f, car_etc g, allot i, car_nm h, car_mng j, cls_cont s, \n"//--, code j car_change k, 
 			+ " (select rent_l_cd,  max(to_number(rent_st)) KEEP( DENSE_RANK FIRST  ORDER BY rent_l_cd, to_number(rent_st) DESC) rent_st   from   fee  group by rent_l_cd) ll , \n"
			+ "(select a.rent_mng_id,a.rent_l_cd,a.emp_id,a.agnt_st,b.emp_nm, b.car_off_id, c.car_off_nm,c.car_off_tel\n"
			+ "		from commi a, car_off_emp b, car_off c\n" 
			+ "		where a.agnt_st='2'\n"
			+ "		and a.emp_id=b.emp_id\n"
			+ "		and b.car_off_id=c.car_off_id) l, sui k, \n"
			+ "     (select * from code where c_st='0039') m \n"
			+ "where a.rent_mng_id like '%' \n"
			+ subQuery
			+ gubunQuery
			+ "and a.car_mng_id = b.car_mng_id(+)\n"
			+ "and a.client_id = c.client_id\n"
			+ "and  a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd \n"
			+ "and a.mng_id = e.user_id\n" 
			+ "and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_mng_id = g.rent_mng_id and a.rent_l_cd = g.rent_l_cd\n"
			+ "and g.car_id = h.car_id(+) and g.car_seq=h.car_seq(+) and h.car_comp_id=j.car_comp_id(+) and h.car_cd=j.code(+)\n"
			+ "and a.rent_mng_id = i.rent_mng_id(+) and a.rent_l_cd = i.rent_l_cd(+) \n"
			+ "and a.rent_mng_id = l.rent_mng_id(+) and a.rent_l_cd = l.rent_l_cd(+)\n"
			+ "and b.car_mng_id = k.car_mng_id(+)\n"
			+ "and d.rent_l_cd = ll.rent_l_cd and d.rent_st = ll.rent_st \n"
			+ "and a.rent_mng_id = s.rent_mng_id(+) and a.rent_l_cd = s.rent_l_cd(+) and b.fuel_kd=m.nm_cd \n"
			+ sortQuery;
		}else{
	        query = "select      decode(sign(add_months(to_date(b.car_end_dt) , -3) - last_day(sysdate)) , -1, 'Y', 'N')   emp_nm,   decode(a.car_st,'1','��Ʈ','2',decode(b.car_use,'1','��Ʈ','2','����','����'),'3','����',decode(b.car_use,'1','��Ʈ','2','����')) car_st, nvl(b.car_ext, g.car_ext) car_ext, a.brch_id, a.rent_mng_id as RENT_MNG_ID, a.rent_l_cd as RENT_L_CD, decode(a.rent_dt,null,'',substr(a.rent_dt,1,4)||'-'||substr(a.rent_dt,5,2)||'-'||substr(a.rent_dt,7,2)) as RENT_DT, decode(a.dlv_dt,null,'',substr(a.dlv_dt,1,4)||'-'||substr(a.dlv_dt,5,2)||'-'||substr(a.dlv_dt,7,2)) as DLV_DT, a.client_id as CLIENT_ID,a.reg_id as REG_ID,\n" 
		    + " c.client_nm as CLIENT_NM, nvl(c.firm_nm,c.client_nm) as FIRM_NM,c.o_tel as O_TEL,c.fax as FAX,e.br_id as BR_ID, e.user_nm as bus_nm, \n" 
			+ " b.car_mng_id as CAR_MNG_ID, nvl2(b.init_reg_dt,substr(b.init_reg_dt,1,4)||'-'||substr(b.init_reg_dt,5,2)||'-'||substr(b.init_reg_dt,7,2),'') as INIT_REG_DT, nvl2(b.init_reg_dt,'ud','id') as REG_GUBUN, nvl2(b.car_no,b.car_no,nvl2(a.dlv_dt,'�̵��','�����')) as CAR_NO, b.car_num as CAR_NUM,\n"
			+ " d.rent_st as R_ST,d.rent_way as RENT_WAY,nvl(d.con_mon,'-') as CON_MON, decode(d.rent_start_dt,null,'',substr(d.rent_start_dt,1,4)||'-'||substr(d.rent_start_dt,5,2)||'-'||substr(d.rent_start_dt,7,2)) as RENT_START_DT, decode(d.rent_end_dt,null,'',substr(d.rent_end_dt,1,4)||'-'||substr(d.rent_end_dt,5,2)||'-'||substr(d.rent_end_dt,7,2)) as RENT_END_DT,\n"
			+ " decode(f.dlv_est_dt,'','',substr(f.dlv_est_dt,1,4)||'-'||substr(f.dlv_est_dt,5,2)||'-'||substr(f.dlv_est_dt,7,2)) as DLV_EST_DT, g.car_id as CAR_ID, g.imm_amt as IMM_AMT, decode(f.reg_ext_dt,null,'',substr(f.reg_ext_dt,1,4)||'-'||substr(f.reg_ext_dt,5,2)||'-'||substr(f.reg_ext_dt,7,2)) as REG_EXT_DT, f.rpt_no as RPT_NO, h.car_name as CAR_NAME, j.car_nm as CAR_NM,\n"//
			+ " i.cpt_cd as CPT_CD,   \n" 
			+ " decode(b.car_use,'1',decode(length(replace(b.car_end_dt,' ','')),8,b.car_end_dt,decode(sign(b.dpm-2000),1,to_char(to_date(b.init_reg_dt,'YYYYMMDD')+(365*8),'YYYYMMDD'),to_char(to_date(b.init_reg_dt,'YYYYMMDD')+(365*5),'YYYYMMDD'))),'-') car_end_dt,\n"
			+ " b.car_doc_no, k.migr_dt, b.OFF_LS, b.DPM , a.car_st rrm, decode(b.car_end_yn,'Y','��������','') car_end_yn, decode(b.prepare,'4','����','5','����','9','��ȸ��','') prepare, \n" 
			+ " '' jg_g_16 , b.end_req_dt \n"
			+ " from cont a, car_reg b, client c, fee d, users e, car_pur f, car_etc g, allot i, car_nm h, car_mng j, cls_cont s,\n"//--, code j
			+ " (select rent_l_cd,  max(to_number(rent_st)) KEEP( DENSE_RANK FIRST  ORDER BY rent_l_cd, to_number(rent_st) DESC) rent_st   from   fee  group by rent_l_cd) ll , \n"
			+ " (select a.rent_mng_id,a.rent_l_cd,a.emp_id,a.agnt_st,b.emp_nm, b.car_off_id, c.car_off_nm,c.car_off_tel\n"
			+ "		from commi a, car_off_emp b, car_off c\n" 
			+ "		where a.agnt_st='2'\n"
			+ "		and a.emp_id=b.emp_id\n"
			+ "		and b.car_off_id=c.car_off_id) l, sui k, \n"
			+ "     (select * from code where c_st='0039') m \n"
			+ "where a.rent_mng_id like '%' \n"
			+ subQuery
			+ gubunQuery
			+" and a.car_mng_id = b.car_mng_id(+)\n"
			+ "and a.client_id = c.client_id\n"
			+ "and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd\n"
			+ "and nvl(a.mng_id2, a.mng_id) = e.user_id\n"
			+ "and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_mng_id = g.rent_mng_id and a.rent_l_cd = g.rent_l_cd\n"
			+ "and g.car_id = h.car_id(+) and g.car_seq=h.car_seq(+) and h.car_comp_id=j.car_comp_id(+) and h.car_cd=j.code(+)\n"
			+ "and a.rent_mng_id = i.rent_mng_id(+) and a.rent_l_cd = i.rent_l_cd(+) \n"
			+ "and d.rent_l_cd = ll.rent_l_cd and d.rent_st = ll.rent_st \n"
			+ "and a.rent_mng_id = l.rent_mng_id(+) and a.rent_l_cd = l.rent_l_cd(+)\n"
			+ "and a.rent_mng_id = s.rent_mng_id(+) and a.rent_l_cd = s.rent_l_cd(+) and b.fuel_kd=m.nm_cd \n"
			+ "and b.car_mng_id = k.car_mng_id(+)\n";
	        
	        if (gubun.equals("car_end_dt")){	//���Կɼ��� ��� - ���������� ���� 
	          query = query +  " union all \n"	          
	                + " select      decode(sign(add_months(to_date(b.car_end_dt) , -3) - last_day(sysdate)) , -1, 'Y', 'N')   emp_nm,   decode(a.car_st,'1','��Ʈ','2',decode(b.car_use,'1','��Ʈ','2','����','����'),'3','����',decode(b.car_use,'1','��Ʈ','2','����')) car_st, nvl(b.car_ext, g.car_ext) car_ext, a.brch_id, a.rent_mng_id as RENT_MNG_ID, a.rent_l_cd as RENT_L_CD, decode(a.rent_dt,null,'',substr(a.rent_dt,1,4)||'-'||substr(a.rent_dt,5,2)||'-'||substr(a.rent_dt,7,2)) as RENT_DT, decode(a.dlv_dt,null,'',substr(a.dlv_dt,1,4)||'-'||substr(a.dlv_dt,5,2)||'-'||substr(a.dlv_dt,7,2)) as DLV_DT, a.client_id as CLIENT_ID,a.reg_id as REG_ID,\n" 
	      		    + " c.client_nm as CLIENT_NM, nvl(c.firm_nm,c.client_nm) as FIRM_NM,c.o_tel as O_TEL,c.fax as FAX,e.br_id as BR_ID, e.user_nm as bus_nm, \n" 
	      			+ " b.car_mng_id as CAR_MNG_ID, nvl2(b.init_reg_dt,substr(b.init_reg_dt,1,4)||'-'||substr(b.init_reg_dt,5,2)||'-'||substr(b.init_reg_dt,7,2),'') as INIT_REG_DT, nvl2(b.init_reg_dt,'ud','id') as REG_GUBUN, nvl2(b.car_no,b.car_no,nvl2(a.dlv_dt,'�̵��','�����')) as CAR_NO, b.car_num as CAR_NUM,\n"
	      			+ " d.rent_st as R_ST,d.rent_way as RENT_WAY,nvl(d.con_mon,'-') as CON_MON, decode(d.rent_start_dt,null,'',substr(d.rent_start_dt,1,4)||'-'||substr(d.rent_start_dt,5,2)||'-'||substr(d.rent_start_dt,7,2)) as RENT_START_DT, decode(d.rent_end_dt,null,'',substr(d.rent_end_dt,1,4)||'-'||substr(d.rent_end_dt,5,2)||'-'||substr(d.rent_end_dt,7,2)) as RENT_END_DT,\n"
	      			+ " decode(f.dlv_est_dt,'','',substr(f.dlv_est_dt,1,4)||'-'||substr(f.dlv_est_dt,5,2)||'-'||substr(f.dlv_est_dt,7,2)) as DLV_EST_DT, g.car_id as CAR_ID, g.imm_amt as IMM_AMT, decode(f.reg_ext_dt,null,'',substr(f.reg_ext_dt,1,4)||'-'||substr(f.reg_ext_dt,5,2)||'-'||substr(f.reg_ext_dt,7,2)) as REG_EXT_DT, f.rpt_no as RPT_NO, h.car_name as CAR_NAME, j.car_nm as CAR_NM,\n"//
	      			+ " i.cpt_cd as CPT_CD,   \n" 
	      			+ " decode(b.car_use,'1',decode(length(replace(b.car_end_dt,' ','')),8,b.car_end_dt,decode(sign(b.dpm-2000),1,to_char(to_date(b.init_reg_dt,'YYYYMMDD')+(365*8),'YYYYMMDD'),to_char(to_date(b.init_reg_dt,'YYYYMMDD')+(365*5),'YYYYMMDD'))),'-') car_end_dt,\n"
	      			+ " b.car_doc_no, k.migr_dt, b.OFF_LS, b.DPM , a.car_st rrm, decode(b.car_end_yn,'Y','��������','') car_end_yn,  '���Կɼ�' prepare, \n" 
	      			+ " '' jg_g_16 , b.end_req_dt \n"
	      			+ " from cont a, car_reg b, client c, fee d, users e, car_pur f, car_etc g, allot i, car_nm h, car_mng j, cls_cont s,\n"//--, code j
	      			+ " (select rent_l_cd,  max(to_number(rent_st)) KEEP( DENSE_RANK FIRST  ORDER BY rent_l_cd, to_number(rent_st) DESC) rent_st   from   fee  group by rent_l_cd) ll , \n"
	      			+ " (select a.rent_mng_id,a.rent_l_cd,a.emp_id,a.agnt_st,b.emp_nm, b.car_off_id, c.car_off_nm,c.car_off_tel\n"
	      			+ "		from commi a, car_off_emp b, car_off c\n" 
	      			+ "		where a.agnt_st='2'\n"
	      			+ "		and a.emp_id=b.emp_id\n"
	      			+ "		and b.car_off_id=c.car_off_id) l, sui k, \n"
	      			+ "     (select * from code where c_st='0039') m \n"
	      			+ " where a.rent_mng_id like '%' \n"
	      			+ " and nvl(a.use_yn,'Y')='N' and s.cls_st ='8' and a.car_mng_id is not null and k.migr_dt is null \n"
	      			+ " and b.car_end_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 +"','-','')   \n" 
	      			+ " and a.car_mng_id = b.car_mng_id\n"
	      			+ " and a.client_id = c.client_id\n"
	      			+ " and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd\n"
	      			+ " and nvl(a.mng_id2, a.mng_id) = e.user_id\n"
	      			+ " and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_mng_id = g.rent_mng_id and a.rent_l_cd = g.rent_l_cd\n"
	      			+ " and g.car_id = h.car_id(+) and g.car_seq=h.car_seq(+) and h.car_comp_id=j.car_comp_id(+) and h.car_cd=j.code(+)\n"
	      			+ " and a.rent_mng_id = i.rent_mng_id(+) and a.rent_l_cd = i.rent_l_cd(+) \n"
	      			+ " and d.rent_l_cd = ll.rent_l_cd and d.rent_st = ll.rent_st \n"
	      			+ " and a.rent_mng_id = l.rent_mng_id(+) and a.rent_l_cd = l.rent_l_cd(+)\n"
	      			+ " and a.rent_mng_id = s.rent_mng_id(+) and a.rent_l_cd = s.rent_l_cd(+) and b.fuel_kd=m.nm_cd \n"
	      			+ " and b.car_mng_id = k.car_mng_id \n";
	          	          
	        }
					
			query = query + sortQuery;
		}

	//	System.out.println("query=" + query);
		
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
			con = null;
        }
        return (RentListBean[])col.toArray(new RentListBean[0]);
    }
    
	/**
     * �ڵ�����Ϻ�ȣ �Ѱ� ��ȸ.
     */
    public CarHisBean getCarChangeLast(String car_mng_id, String car_no, String car_nm, String req_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
		CarHisBean bean = new CarHisBean();
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";        
        query = " SELECT a.car_mng_id, a.cha_seq, decode(a.cha_dt,null,'',substr(a.cha_dt,1,4)||'-'||substr(a.cha_dt,5,2)||'-'||substr(a.cha_dt,7,2)) as cha_dt, "+
				"        a.cha_cau, a.cha_cau_sub, a.car_no, a.reg_id, a.reg_dt, a.use_yn, a.scanfile, a.file_type "+
				" FROM   car_change a, car_reg b "+
				" where  a.car_no like '%" + car_no + "%'  "+ 
				"        and a.car_mng_id=b.car_mng_id \n";

		if(!car_mng_id.equals(""))	query += " and a.car_mng_id = '"+car_mng_id+"' ";

		query += " and a.cha_dt = ( select max(a.cha_dt) cha_dt from car_change a, car_reg b where a.car_no like '%" + car_no + "%' and a.car_mng_id=b.car_mng_id "; 

		if(!car_mng_id.equals(""))	query += " and a.car_mng_id = '"+car_mng_id+"' ";

		query += " )";

        try{

			stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){                
				bean = makeCarHisBean(rs);
            }
            rs.close();
            stmt.close();
			
        }catch(SQLException se){
            try{
				System.out.println("[CarRegDatabase:getCarChangeLast]="+se);
			    con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }
		
    /**
     * �ڵ������ Ư������
     */
    public int updateCarSpeDc(CarRegBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query   = " UPDATE CAR_REG SET \n"
        		+ "        SPE_DC_ST=?, SPE_DC_CAU=?, SPE_DC_PER=?, SPE_DC_S_DT=replace(?,'-',''), SPE_DC_D_DT=replace(?,'-','') \n"
				+ " WHERE  CAR_MNG_ID=?\n";
           
       try{
            con.setAutoCommit(false);
            
            pstmt = con.prepareStatement(query);
            
			pstmt.setString(1, bean.getSpe_dc_st().trim());
			pstmt.setString(2, bean.getSpe_dc_cau().trim());
			pstmt.setFloat (3, bean.getSpe_dc_per());
			pstmt.setString(4, bean.getSpe_dc_s_dt().trim());
			pstmt.setString(5, bean.getSpe_dc_d_dt().trim());
			pstmt.setString(6, bean.getCar_mng_id().trim());
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
     * �ڵ������ Ư������
     */
    public int updateNewCarSpeDc(CarRegBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query   = " UPDATE CAR_REG SET \n"
        		+ "        NCAR_SPE_DC_CAU=?, NCAR_SPE_DC_AMT=?, NCAR_SPE_DC_DAY=?, NCAR_SPE_DC_DT=decode(NCAR_SPE_DC_DT,'',to_char(sysdate,'YYYYMMDD'),NCAR_SPE_DC_DT) \n"
				+ " WHERE  CAR_MNG_ID=?\n";
        
        if(bean.getNcar_spe_dc_amt() == 0) {
            query   = " UPDATE CAR_REG SET \n"
            		+ "        NCAR_SPE_DC_CAU=?, NCAR_SPE_DC_AMT=?, NCAR_SPE_DC_DAY=?, NCAR_SPE_DC_DT='' \n"
    				+ " WHERE  CAR_MNG_ID=?\n";        	
        }
                   
       try{
            con.setAutoCommit(false);
            
            pstmt = con.prepareStatement(query);
            
			pstmt.setString(1, bean.getNcar_spe_dc_cau());
			pstmt.setInt   (2, bean.getNcar_spe_dc_amt());
			pstmt.setInt   (3, bean.getNcar_spe_dc_day());
			pstmt.setString(4, bean.getCar_mng_id());
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
     * �ڵ������ �κм���
     */
    public int updateCarUse(String car_mng_id, String car_use) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query =	" UPDATE CAR_REG SET 	 CAR_USE=?  WHERE CAR_MNG_ID=?  ";

       try{
            con.setAutoCommit(false);
            
            pstmt = con.prepareStatement(query);

			pstmt.setString(1, car_use		);
			pstmt.setString(2, car_mng_id	);
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
     * �ڵ������ �κм���
     */
    public int updateCarExt(String car_mng_id, String car_ext) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query =	" UPDATE CAR_REG SET  CAR_EXT=?  WHERE CAR_MNG_ID=?  ";

       try{
            con.setAutoCommit(false);
            
            pstmt = con.prepareStatement(query);

			pstmt.setString(1, car_ext		);
			pstmt.setString(2, car_mng_id	);
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
    
    //���ɸ����� �ϰ����� �˾� - ����Ʈ ȣ��
    public Vector getModifyCarEndDtList(String car_mng_id) throws UnknownDataException, DataSourceEmptyException, DatabaseException {
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null) 
            throw new DataSourceEmptyException("Can't get connection.!!");

        Vector vt = new Vector();

        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
		query = " SELECT a.car_no,\n" + 
				" DECODE(a.CAR_END_DT,null,'',substr(a.CAR_END_DT,1,4)||'-'||substr(a.CAR_END_DT,5,2)||'-'||substr(a.CAR_END_DT,7,2)) as CAR_END_DT, \n" +
				" DECODE(a.car_end_yn,'Y','��������','') AS CAR_END_YN, \n" +
				" b.rent_l_cd, b.rent_mng_id, c.car_id, d.car_name, e.car_nm, a.car_doc_no, \n" +
				" (SELECT decode(cha_dt,null,'',substr(cha_dt,1,4)||'-'||substr(cha_dt,5,2)||'-'||substr(cha_dt,7,2)) as cha_dt \n" +
				"    FROM car_change \n" + 
				"    WHERE cha_seq=(SELECT Max(cha_seq) FROM car_change WHERE car_mng_id='" + car_mng_id + "' AND cha_cau_sub LIKE '%����%%����%') \n" + 
				"  	   AND car_mng_id = '" + car_mng_id + "') AS cha_dt, \n" +
				" (SELECT cha_seq \n" +
				"    FROM car_change \n" + 
				"    WHERE cha_seq=(SELECT Max(cha_seq) FROM car_change WHERE car_mng_id='" + car_mng_id + "' AND cha_cau_sub LIKE '%����%%����%') \n" + 
				"  	   AND car_mng_id = '" + car_mng_id + "') AS cha_seq \n" +
				" FROM car_reg a, cont b, car_etc c, car_nm d, car_mng e, code f \n" +
				" WHERE a.car_mng_id = b.car_mng_id \n" +
				"   AND nvl(b.use_yn, 'Y')  = 'Y' \n" +
				"   AND b.RENT_L_CD = c.RENT_L_CD AND b.rent_mng_id = c.RENT_MNG_ID \n" +
				"   AND c.car_id = d.car_id \n" +
				"   AND d.car_comp_id=e.car_comp_id and d.car_cd=e.code \n" +
				"   and e.car_comp_id=f.code and f.c_st = '0001' \n" +
				"   and d.car_id=c.car_id and d.car_seq=c.car_seq \n" +
				"   AND a.car_mng_id ='" + car_mng_id + "'\n" +
				"  ";
        try {
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

        return vt;
    }
    
    //���ɸ����� ���忡 ���� �����丮�� FETCH
    public CarHisBean [] getCarHisCarEndDt(String car_mng_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";        
        query = "SELECT car_mng_id, cha_seq, decode(cha_dt,null,'',substr(cha_dt,1,4)||'-'||substr(cha_dt,5,2)||'-'||substr(cha_dt,7,2)) as cha_dt, cha_cau, cha_cau_sub, car_no, reg_id, reg_dt, use_yn, scanfile, file_type "
				+ " FROM car_change"
				+ " WHERE car_mng_id='" + car_mng_id + "'\n"
        		+ " AND cha_cau_sub LIKE '%����%%����%' \n"
        		+ " ORDER BY cha_dt DESC";

        Collection<CarHisBean> col = new ArrayList<CarHisBean>();
        try{
			stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){                
				col.add(makeCarHisBean(rs));
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
        return (CarHisBean[])col.toArray(new CarHisBean[0]);
    }
    
    //���ɸ����� �ϰ�����
    public boolean updateCarEndDt(String car_end_dt, String update_id, String car_end_yn, String car_mng_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
        boolean flag = true;
                
        query =	" UPDATE CAR_REG SET\n"+
        		" CAR_END_DT=replace(?,'-',''),"+
				" update_id = ? , update_dt = sysdate, car_end_yn = ?, end_req_dt = null "+
				" WHERE CAR_MNG_ID=?\n";
       try{
            con.setAutoCommit(false);
            pstmt = con.prepareStatement(query);

            pstmt.setString(1, car_end_dt.trim());
			pstmt.setString(2, update_id.trim());
			pstmt.setString(3, car_end_yn.trim());
			pstmt.setString(4, car_mng_id.trim());
            count = pstmt.executeUpdate();
            pstmt.close();
            con.commit();

        }catch(SQLException se){
            try{
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
    
   //��Ϲ�ȣ���� �̷� ���2(���ɸ����� �ϰ������, 1�⿬�������θ� ����)
   public boolean insertCarHisForCarEndDt(String car_mng_id, String car_end_dt, String car_no, String user_id, String car_ext) 
    		throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        ResultSet rs = null;
		Statement stmt = null;
		PreparedStatement pstmt = null;
		String seq = "";
        int count = 0;
        boolean flag = true;
	
		String query_seq = "select nvl(max(cha_seq)+1,'1') from car_change where car_mng_id='" + car_mng_id + "'";		
        String query="INSERT INTO CAR_CHANGE(CAR_MNG_ID,CHA_SEQ,CHA_DT,CHA_CAU,CHA_CAU_SUB,CAR_NO,REG_ID,REG_DT,USE_YN,SCANFILE,FILE_TYPE,CAR_EXT) "+
					" VALUES (?,?,to_char(sysdate,'YYYYMMDD'),'3','���ɸ����� 1�� ����',?,?,replace(?,'-',''),'','','',?) ";
	   try{
			con.setAutoCommit(false);

			stmt = con.createStatement();
            rs = stmt.executeQuery(query_seq);
            if(rs.next())
            	seq = rs.getString(1).trim();
            rs.close();
			stmt.close();

			pstmt = con.prepareStatement(query);
            pstmt.setString(1,  car_mng_id);
            pstmt.setString(2,  seq);
            pstmt.setString(3,  car_no);            
            pstmt.setString(4,  user_id);            
            pstmt.setString(5,  null);            
			pstmt.setString(6,  car_ext);
			
			count = pstmt.executeUpdate();

			pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
            	flag = false;
				System.out.println(se);
				con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
				if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return flag;
    }
   
   //2ȸ ���ɿ��忩�� ����
   public boolean updateCarEndYn(String update_id, String car_mng_id) throws DatabaseException, DataSourceEmptyException{
       Connection con = connMgr.getConnection(DATA_SOURCE);

       if(con == null)
           throw new DataSourceEmptyException("Can't get Connection !!");
       PreparedStatement pstmt = null;
       String query = "";
       int count = 0;
       boolean flag = true;
               
       query =	" UPDATE CAR_REG SET\n"+
				" update_id = ? , update_dt = sysdate, car_end_yn = 'Y' "+
				" WHERE CAR_MNG_ID=?\n";
      try{
           con.setAutoCommit(false);
           
           pstmt = con.prepareStatement(query);
           
			pstmt.setString(1, update_id.trim());			
			pstmt.setString(2, car_mng_id.trim());
           count = pstmt.executeUpdate();
           pstmt.close();
           con.commit();

       }catch(SQLException se){
           try{
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
   
   
   //�ڵ��� ��ȣ�̷� �������ڸ� ����(�ϰ�������)
   public int updateCarHis_cha_dt(String car_mng_id, String cha_seq, String cha_dt) throws DatabaseException, DataSourceEmptyException{
       Connection con = connMgr.getConnection(DATA_SOURCE);

       if(con == null)
           throw new DataSourceEmptyException("Can't get Connection !!");

	   PreparedStatement pstmt = null;
       int count = 0;
	
       String query="UPDATE car_change SET cha_dt=REPLACE(?,'-','') "+
					 " WHERE car_mng_id=? AND cha_seq = ? ";
	   try{	
		   	con.setAutoCommit(false);
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, cha_dt);            
            pstmt.setString(2, car_mng_id);            
            pstmt.setString(3, cha_seq);
			count = pstmt.executeUpdate();
			pstmt.close();
			con.commit();

       }catch(SQLException se){
           try{
				System.out.println(se);
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
   
   //���ɸ��� ����  ó�������� ��� 
   public boolean updateCarEndReqDt(String end_req_dt, String upd_id, String car_mng_id) throws DatabaseException, DataSourceEmptyException{
       Connection con = connMgr.getConnection(DATA_SOURCE);

       if(con == null)
           throw new DataSourceEmptyException("Can't get Connection !!");
       PreparedStatement pstmt = null;
       String query = "";
       int count = 0;
       boolean flag = true;
               
       query =	" UPDATE CAR_REG SET\n"+
				" end_req_dt = replace(?, '-', '') , update_id = ? , update_dt = sysdate "+
				" WHERE CAR_MNG_ID=?\n";
      try{
           con.setAutoCommit(false);
           
           pstmt = con.prepareStatement(query);
           
			pstmt.setString(1, end_req_dt);	
			pstmt.setString(2, upd_id.trim());	
			pstmt.setString(3, car_mng_id.trim());
           count = pstmt.executeUpdate();
           pstmt.close();
           con.commit();

       }catch(SQLException se){
           try{
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
