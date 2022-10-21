package acar.insur;

import java.util.*;
import java.sql.*;
import acar.util.*;
import acar.common.*;
import acar.con_ins_m.*;
import acar.car_service.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.UnknownDataException;
import acar.exception.DatabaseException;


public class CarInsDatabase{

    private static CarInsDatabase instance;
    private DBConnectionManager connMgr;   
    private final String DATA_SOURCE = "acar"; 
 
    public static synchronized CarInsDatabase getInstance() throws DatabaseException {
        if (instance == null)
            instance = new CarInsDatabase();
        return instance;
    }
    
    private CarInsDatabase() throws DatabaseException {
        connMgr = DBConnectionManager.getInstance();
    }

	//자동차별 보험 한건 조회
    public InsurBean getInsCase(String c_id, String ins_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
		InsurBean ins = new InsurBean();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
		query = "select * from insur where car_mng_id=? and ins_st=?";
        
        try{

			pstmt = con.prepareStatement(query);
			pstmt.setString(1, c_id);
			pstmt.setString(2, ins_st);
    		rs = pstmt.executeQuery();
            if (rs.next()){
				ins.setCar_mng_id(rs.getString("CAR_MNG_ID")==null?"":rs.getString("CAR_MNG_ID"));
				ins.setIns_st(rs.getString("INS_ST")==null?"":rs.getString("INS_ST"));
				ins.setIns_sts(rs.getString("INS_STS")==null?"":rs.getString("INS_STS"));
				ins.setAge_scp(rs.getString("AGE_SCP")==null?"":rs.getString("AGE_SCP"));
				ins.setCar_use(rs.getString("CAR_USE")==null?"":rs.getString("CAR_USE"));
				ins.setIns_com_id(rs.getString("INS_COM_ID")==null?"":rs.getString("INS_COM_ID"));
				ins.setIns_con_no(rs.getString("INS_CON_NO")==null?"":rs.getString("INS_CON_NO"));
				ins.setConr_nm(rs.getString("CONR_NM")==null?"":rs.getString("CONR_NM"));
				ins.setIns_start_dt(rs.getString("INS_START_DT")==null?"":rs.getString("INS_START_DT"));
				ins.setIns_exp_dt(rs.getString("INS_EXP_DT")==null?"":rs.getString("INS_EXP_DT"));
				ins.setRins_pcp_amt(rs.getInt("RINS_PCP_AMT"));
				ins.setVins_pcp_kd(rs.getString("VINS_PCP_KD")==null?"":rs.getString("VINS_PCP_KD"));
				ins.setVins_pcp_amt(rs.getInt("VINS_PCP_AMT"));
				ins.setVins_gcp_kd(rs.getString("VINS_GCP_KD")==null?"":rs.getString("VINS_GCP_KD"));
				ins.setVins_gcp_amt(rs.getInt("VINS_GCP_AMT"));
				ins.setVins_bacdt_kd(rs.getString("VINS_BACDT_KD")==null?"":rs.getString("VINS_BACDT_KD"));
				ins.setVins_bacdt_amt(rs.getInt("VINS_BACDT_AMT"));
				ins.setVins_cacdt_amt(rs.getInt("VINS_CACDT_AMT"));
				ins.setPay_tm(rs.getString("PAY_TM")==null?"":rs.getString("PAY_TM"));
				ins.setChange_dt(rs.getString("CHANGE_DT")==null?"":rs.getString("CHANGE_DT"));
				ins.setChange_cau(rs.getString("CHANGE_CAU")==null?"":rs.getString("CHANGE_CAU"));
				ins.setChange_itm_kd1(rs.getString("CHANGE_ITM_KD1")==null?"":rs.getString("CHANGE_ITM_KD1"));
				ins.setChange_itm_amt1(rs.getInt("CHANGE_ITM_AMT1"));
				ins.setChange_itm_kd2(rs.getString("CHANGE_ITM_KD2")==null?"":rs.getString("CHANGE_ITM_KD2"));
				ins.setChange_itm_amt2(rs.getInt("CHANGE_ITM_AMT2"));
				ins.setChange_itm_kd3(rs.getString("CHANGE_ITM_KD3")==null?"":rs.getString("CHANGE_ITM_KD3"));
				ins.setChange_itm_amt3(rs.getInt("CHANGE_ITM_AMT3"));
				ins.setChange_itm_kd4(rs.getString("CHANGE_ITM_KD4")==null?"":rs.getString("CHANGE_ITM_KD4"));
				ins.setChange_itm_amt4(rs.getInt("CHANGE_ITM_AMT4"));
				ins.setCar_rate(rs.getString("CAR_RATE")==null?"":rs.getString("CAR_RATE"));
				ins.setIns_rate(rs.getString("INS_RATE")==null?"":rs.getString("INS_RATE"));
				ins.setExt_rate(rs.getString("EXT_RATE")==null?"":rs.getString("EXT_RATE"));
				ins.setAir_ds_yn(rs.getString("AIR_DS_YN")==null?"":rs.getString("AIR_DS_YN"));
				ins.setAir_as_yn(rs.getString("AIR_AS_YN")==null?"":rs.getString("AIR_AS_YN"));
				ins.setAgnt_nm(rs.getString("AGNT_NM")==null?"":rs.getString("AGNT_NM"));
				ins.setAgnt_tel(rs.getString("AGNT_TEL")==null?"":rs.getString("AGNT_TEL"));
				ins.setAgnt_imgn_tel(rs.getString("AGNT_IMGN_TEL")==null?"":rs.getString("AGNT_IMGN_TEL"));
				ins.setAgnt_fax(rs.getString("AGNT_FAX")==null?"":rs.getString("AGNT_FAX"));
				ins.setExp_dt(rs.getString("EXP_DT")==null?"":rs.getString("EXP_DT"));
				ins.setExp_cau(rs.getString("EXP_CAU")==null?"":rs.getString("EXP_CAU"));
				ins.setRtn_amt(rs.getInt("RTN_AMT"));
				ins.setRtn_dt(rs.getString("RTN_DT")==null?"":rs.getString("RTN_DT"));
				ins.setEnable_renew(rs.getString("ENABLE_RENEW")==null?"":rs.getString("ENABLE_RENEW"));				
				ins.setCon_f_nm(rs.getString("CON_F_NM")==null?"":rs.getString("CON_F_NM"));
				ins.setAcc_tel(rs.getString("ACC_TEL")==null?"":rs.getString("ACC_TEL"));
				ins.setAgnt_dept(rs.getString("AGNT_DEPT")==null?"":rs.getString("AGNT_DEPT"));
				ins.setVins_canoisr_amt(rs.getInt("VINS_CANOISR_AMT"));
				ins.setVins_cacdt_car_amt(rs.getInt("VINS_CACDT_CAR_AMT"));
				ins.setVins_cacdt_me_amt(rs.getInt("VINS_CACDT_ME_AMT"));
				ins.setVins_cacdt_cm_amt(rs.getInt("VINS_CACDT_CM_AMT"));
				ins.setVins_bacdt_kc2(rs.getString("VINS_BACDT_KC2")==null?"":rs.getString("VINS_BACDT_KC2"));
				ins.setVins_spe(rs.getString("VINS_SPE")==null?"":rs.getString("VINS_SPE"));
				ins.setVins_spe_amt(rs.getInt("VINS_SPE_AMT"));
				ins.setScan_file(rs.getString("SCAN_FILE")==null?"":rs.getString("SCAN_FILE"));
				ins.setUpdate_id(rs.getString("UPDATE_ID")==null?"":rs.getString("UPDATE_ID"));
				ins.setUpdate_dt(rs.getString("UPDATE_DT")==null?"":rs.getString("UPDATE_DT"));
				ins.setChange_dt1(rs.getString("CHANGE_DT1")==null?"":rs.getString("CHANGE_DT1"));
				ins.setChange_dt2(rs.getString("CHANGE_DT2")==null?"":rs.getString("CHANGE_DT2"));
				ins.setChange_dt3(rs.getString("CHANGE_DT3")==null?"":rs.getString("CHANGE_DT3"));
				ins.setChange_dt4(rs.getString("CHANGE_DT4")==null?"":rs.getString("CHANGE_DT4"));
				ins.setChange_ins_no1(rs.getString("CHANGE_INS_NO1")==null?"":rs.getString("CHANGE_INS_NO1"));
				ins.setChange_ins_no2(rs.getString("CHANGE_INS_NO2")==null?"":rs.getString("CHANGE_INS_NO2"));
				ins.setChange_ins_no3(rs.getString("CHANGE_INS_NO3")==null?"":rs.getString("CHANGE_INS_NO3"));
				ins.setChange_ins_no4(rs.getString("CHANGE_INS_NO4")==null?"":rs.getString("CHANGE_INS_NO4"));
				ins.setChange_ins_start_dt1(rs.getString("CHANGE_INS_START_DT1")==null?"":rs.getString("CHANGE_INS_START_DT1"));
				ins.setChange_ins_start_dt2(rs.getString("CHANGE_INS_START_DT2")==null?"":rs.getString("CHANGE_INS_START_DT2"));
				ins.setChange_ins_start_dt3(rs.getString("CHANGE_INS_START_DT3")==null?"":rs.getString("CHANGE_INS_START_DT3"));
				ins.setChange_ins_start_dt4(rs.getString("CHANGE_INS_START_DT4")==null?"":rs.getString("CHANGE_INS_START_DT4"));
				ins.setChange_ins_exp_dt1(rs.getString("CHANGE_INS_EXP_DT1")==null?"":rs.getString("CHANGE_INS_EXP_DT1"));
				ins.setChange_ins_exp_dt2(rs.getString("CHANGE_INS_EXP_DT2")==null?"":rs.getString("CHANGE_INS_EXP_DT2"));
				ins.setChange_ins_exp_dt3(rs.getString("CHANGE_INS_EXP_DT3")==null?"":rs.getString("CHANGE_INS_EXP_DT3"));
				ins.setChange_ins_exp_dt4(rs.getString("CHANGE_INS_EXP_DT4")==null?"":rs.getString("CHANGE_INS_EXP_DT4"));
				ins.setIns_kd(rs.getString("INS_KD")==null?"":rs.getString("INS_KD"));
				ins.setReg_cau(rs.getString("REG_CAU")==null?"":rs.getString("REG_CAU"));
			}            
            rs.close();
            pstmt.close();

        }catch(SQLException se){
			System.out.println("[CarInsDatabase:getInsCase]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return ins;
    }

	//자동차별 보험 해지 한건 조회
    public InsurClsBean getInsurClsCase(String c_id, String ins_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
		InsurClsBean bean = new InsurClsBean();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
		query = " select * from ins_cls where car_mng_id=? and ins_st=?";
        
        try{

			pstmt = con.prepareStatement(query);
			pstmt.setString(1, c_id);
			pstmt.setString(2, ins_st);
    		rs = pstmt.executeQuery();
            if (rs.next()){
			    bean.setCar_mng_id	(rs.getString(1)==null?"":rs.getString(1));
			    bean.setIns_st		(rs.getString(2)==null?"":rs.getString(2));
			    bean.setExp_st		(rs.getString(3)==null?"":rs.getString(3));
			    bean.setExp_aim		(rs.getString(4)==null?"":rs.getString(4));
			    bean.setExp_dt		(rs.getString(5)==null?"":rs.getString(5));
			    bean.setReq_dt		(rs.getString(6)==null?"":rs.getString(6));
			    bean.setUse_day1	(rs.getInt   (7));		
			    bean.setUse_day2	(rs.getInt   (8));		
			    bean.setUse_day3	(rs.getInt   (9));		
			    bean.setUse_day4	(rs.getInt   (10));		
			    bean.setUse_day5	(rs.getInt   (11));		
			    bean.setUse_day6	(rs.getInt   (12));		
			    bean.setUse_day7	(rs.getInt   (13));		
			    bean.setUse_amt1	(rs.getInt   (14));		
			    bean.setUse_amt2	(rs.getInt   (15));		
			    bean.setUse_amt3	(rs.getInt   (16));		
			    bean.setUse_amt4	(rs.getInt   (17));		
			    bean.setUse_amt5	(rs.getInt   (18));		
			    bean.setUse_amt6	(rs.getInt   (19));		
			    bean.setUse_amt7	(rs.getInt   (20));		
			    bean.setExp_yn1		(rs.getString(21)==null?"":rs.getString(21));
			    bean.setExp_yn2		(rs.getString(22)==null?"":rs.getString(22));
			    bean.setExp_yn3		(rs.getString(23)==null?"":rs.getString(23));
				bean.setExp_yn4		(rs.getString(24)==null?"":rs.getString(24));
				bean.setExp_yn5		(rs.getString(25)==null?"":rs.getString(25));
				bean.setExp_yn6		(rs.getString(26)==null?"":rs.getString(26));
				bean.setExp_yn7		(rs.getString(27)==null?"":rs.getString(27));
				bean.setTot_ins_amt	(rs.getInt   (28));		
			    bean.setTot_use_amt	(rs.getInt   (29));		
			    bean.setNopay_amt	(rs.getInt   (30));		
			    bean.setRtn_est_amt	(rs.getInt   (31));		
			    bean.setRtn_amt		(rs.getInt   (32));		
			    bean.setRtn_dt		(rs.getString(33)==null?"":rs.getString(33));
			    bean.setDif_amt		(rs.getInt   (34));		
			    bean.setDif_cau		(rs.getString(35)==null?"":rs.getString(35));
			    bean.setReg_id		(rs.getString(36)==null?"":rs.getString(36));
			    bean.setReg_dt		(rs.getString(37)==null?"":rs.getString(37));
			    bean.setUpd_id		(rs.getString(38)==null?"":rs.getString(38));
			    bean.setUpd_dt		(rs.getString(39)==null?"":rs.getString(39));
			}            
            rs.close();
            pstmt.close();

        }catch(SQLException se){
			System.out.println("[CarInsDatabase:getInsurClsCase]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }

	//차량별 자동차보험스케줄
    public Vector getInsScds(String c_id, String ins_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";

		query = 	" select"+
							" CAR_MNG_ID, INS_TM, INS_ST, PAY_AMT,"+
							" decode(INS_EST_DT, '', '', substr(INS_EST_DT, 1, 4) || '-' || substr(INS_EST_DT, 5, 2) || '-'||substr(INS_EST_DT, 7, 2)) INS_EST_DT,"+
							" decode(R_INS_EST_DT, '', '', substr(R_INS_EST_DT, 1, 4) || '-' || substr(R_INS_EST_DT, 5, 2) || '-'||substr(R_INS_EST_DT, 7, 2)) R_INS_EST_DT,"+
							" decode(PAY_DT, '', '', substr(PAY_DT, 1, 4) || '-' || substr(PAY_DT, 5, 2) || '-'||substr(PAY_DT, 7, 2)) PAY_DT,"+
							" PAY_YN, INS_TM2"+
							" from scd_ins "+
							" where CAR_MNG_ID = ? and INS_ST = ? order by ins_st, ins_tm, ins_est_dt";

        try{

            con.setAutoCommit(false);

			pstmt = con.prepareStatement(query);
			pstmt.setString(1, c_id);
			pstmt.setString(2, ins_st);
	    	rs = pstmt.executeQuery();

			while(rs.next())
			{				
				InsurScdBean scd = new InsurScdBean();
				scd.setCar_mng_id(rs.getString("CAR_MNG_ID")==null?"":rs.getString("CAR_MNG_ID"));
				scd.setIns_tm(rs.getString("INS_TM")==null?"":rs.getString("INS_TM"));
				scd.setIns_st(rs.getString("INS_ST")==null?"":rs.getString("INS_ST"));
				scd.setIns_est_dt(rs.getString("INS_EST_DT")==null?"":rs.getString("INS_EST_DT"));
				scd.setR_ins_est_dt(rs.getString("R_INS_EST_DT")==null?"":rs.getString("R_INS_EST_DT"));
				scd.setPay_amt(rs.getInt("PAY_AMT"));
				scd.setPay_yn(rs.getString("PAY_YN")==null?"":rs.getString("PAY_YN"));
				scd.setPay_dt(rs.getString("PAY_DT")==null?"":rs.getString("PAY_DT"));
				scd.setIns_tm2(rs.getString("INS_TM2")==null?"":rs.getString("INS_TM2"));
				vt.add(scd);
			}
            rs.close();
            pstmt.close();

        }catch(SQLException se){
			System.out.println("[InsDatabase:getInsScds]"+ se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

}