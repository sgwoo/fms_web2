package acar.con_ins;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;

public class InsurDatabase
{
	private Connection conn = null;
	public static InsurDatabase db;
	
	public static InsurDatabase getInstance()
	{
		if(InsurDatabase.db == null)
			InsurDatabase.db = new InsurDatabase();
		return InsurDatabase.db;
	}	
	

 	private DBConnectionManager connMgr = null;

    private void getConnection()
    {
    	try
    	{
	    	if(connMgr == null)
				connMgr = DBConnectionManager.getInstance();
			if(conn == null)
	        	conn = connMgr.getConnection("acar");				
	    }catch(Exception e){
	    	System.out.println(" i can't get a connection........");
	    }
	}
	
	private void closeConnection()
	{
		if ( conn != null ) 
		{
			connMgr.freeConnection("acar", conn);
			conn = null;
		}		
	}
	
	/**
	 *	보험료스케줄생성
	 */
	public boolean insertInsScd(InsurScdBean scd)
	{
		getConnection();
		boolean flag = true;
		String query = "insert into scd_ins (CAR_MNG_ID, INS_TM, INS_ST, INS_EST_DT, PAY_AMT, PAY_YN, PAY_DT) values"+
						" (?, ?, ?, replace(?, '-', ''), ?, ?, replace(?, '-', ''))";
		PreparedStatement pstmt = null;
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, scd.getCar_mng_id());
			pstmt.setString(2, scd.getIns_tm());
			pstmt.setString(3, scd.getIns_st());
			pstmt.setString(4, scd.getIns_est_dt());
			pstmt.setInt(5, scd.getPay_amt());
			pstmt.setString(6, scd.getPay_yn());
			pstmt.setString(7, scd.getPay_dt());
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}
	
	/**
	 *	보험료스케줄생성
	 */
	public boolean dropInsScd(String car_mng_id, String ins_st, String ins_tm)
	{
		getConnection();
		boolean flag = true;
		String query = " delete from scd_ins"+
						" where car_mng_id = ? and"+
								" ins_st = ? and"+
								" ins_tm = ?";
		PreparedStatement pstmt = null;
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
			pstmt.setString(2, ins_st);
			pstmt.setString(3, ins_tm);
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}	
	
	/**
	 * 보험료 스케줄 UPDATE
	 */
	public boolean updateInsScd(InsurScdBean scd)
	{
		getConnection();
		boolean flag = true;
		String query = "update scd_ins set"+
						" INS_EST_DT= replace(?, '-', ''),"+
						" PAY_AMT= ?,"+
						" PAY_YN= ?,"+
						" PAY_DT= replace(?, '-', '')"+
						" where CAR_MNG_ID = ? and INS_ST= ? and INS_TM = ?";
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);
				
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, scd.getIns_est_dt());
			pstmt.setInt(2, scd.getPay_amt());
			pstmt.setString(3, scd.getPay_yn());
			pstmt.setString(4, scd.getPay_dt());
			pstmt.setString(5, scd.getCar_mng_id());
			pstmt.setString(6, scd.getIns_st());
			pstmt.setString(7, scd.getIns_tm());
		    pstmt.executeUpdate();
			pstmt.close();
		    
		    conn.commit();
	  	} catch (Exception e) {
	  		e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}

	/**
	 *	한회차 보험료스케줄 select
	 */
	public InsurScdBean getInsScd(String car_mng_id, String ins_st, String ins_tm)
	{
		getConnection();
		InsurScdBean scd = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	" select"+
							" CAR_MNG_ID, INS_TM, INS_ST, INS_EST_DT, PAY_AMT, PAY_YN, PAY_DT "+
							" from scd_ins "+
							" where CAR_MNG_ID = ? and INS_ST = ? and INS_TM = ?";
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, car_mng_id);
				pstmt.setString(2, ins_st);
				pstmt.setString(3, ins_tm);
		    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				scd = new InsurScdBean();
				scd.setCar_mng_id(rs.getString("CAR_MNG_ID")==null?"":rs.getString("CAR_MNG_ID"));
				scd.setIns_tm(rs.getString("INS_TM")==null?"":rs.getString("INS_TM"));
				scd.setIns_st(rs.getString("INS_ST")==null?"":rs.getString("INS_ST"));
				scd.setIns_est_dt(rs.getString("INS_EST_DT")==null?"":rs.getString("INS_EST_DT"));
				scd.setPay_amt(rs.getInt("PAY_AMT"));
				scd.setPay_yn(rs.getString("PAY_YN")==null?"":rs.getString("PAY_YN"));
				scd.setPay_dt(rs.getString("PAY_DT")==null?"":rs.getString("PAY_DT"));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return scd;
		}
	}
	
	/**
	 *	보험계약별 스케줄 리스트 select
	 */
	public Vector getInsScds(String car_mng_id, String ins_st)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	" select"+
							" CAR_MNG_ID, INS_TM, INS_ST, PAY_AMT,"+
							" decode(INS_EST_DT, '', '', substr(INS_EST_DT, 1, 4) || '-' || substr(INS_EST_DT, 5, 2) || '-'||substr(INS_EST_DT, 7, 2)) INS_EST_DT,"+
							" decode(PAY_DT, '', '', substr(PAY_DT, 1, 4) || '-' || substr(PAY_DT, 5, 2) || '-'||substr(PAY_DT, 7, 2)) PAY_DT,"+
							" PAY_YN"+
							" from scd_ins "+
							" where CAR_MNG_ID = ? and INS_ST = ? order by to_number(ins_tm)";
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, car_mng_id);
				pstmt.setString(2, ins_st);
		    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				InsurScdBean scd = new InsurScdBean();
				scd.setCar_mng_id(rs.getString("CAR_MNG_ID")==null?"":rs.getString("CAR_MNG_ID"));
				scd.setIns_tm(rs.getString("INS_TM")==null?"":rs.getString("INS_TM"));
				scd.setIns_st(rs.getString("INS_ST")==null?"":rs.getString("INS_ST"));
				scd.setIns_est_dt(rs.getString("INS_EST_DT")==null?"":rs.getString("INS_EST_DT"));
				scd.setPay_amt(rs.getInt("PAY_AMT"));
				scd.setPay_yn(rs.getString("PAY_YN")==null?"":rs.getString("PAY_YN"));
				scd.setPay_dt(rs.getString("PAY_DT")==null?"":rs.getString("PAY_DT"));
				vt.add(scd);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}	

	/**
	 * 보험료 INSERT
	 */
	public boolean insertIns(InsurBean ins)
	{
		getConnection();
		boolean flag = true;
		String query = "insert into insur (CAR_MNG_ID, INS_ST, INS_STS, AGE_SCP, CAR_USE, INS_COM_ID, INS_CON_NO, CONR_NM,"+
						" INS_START_DT, INS_EXP_DT, RINS_PCP_AMT, VINS_PCP_KD, VINS_PCP_AMT, VINS_GCP_KD, VINS_GCP_AMT,"+
						" VINS_BACDT_KD, VINS_BACDT_AMT, VINS_CACDT_AMT, PAY_TM, CHANGE_DT, CHANGE_CAU, CHANGE_ITM_KD1,"+
						" CHANGE_ITM_AMT1, CHANGE_ITM_KD2, CHANGE_ITM_AMT2, CHANGE_ITM_KD3, CHANGE_ITM_AMT3, CHANGE_ITM_KD4,"+
						" CHANGE_ITM_AMT4, CAR_RATE, INS_RATE, EXT_RATE, AIR_DS_YN, AIR_AS_YN, AGNT_NM, AGNT_TEL, AGNT_IMGN_TEL,"+
						" AGNT_FAX, EXP_DT, EXP_CAU, RTN_AMT, RTN_DT, ENABLE_RENEW, CON_F_NM, AGNT_DEPT, ACC_TEL) values("+
						" ?, ?, ?, ?, ?, ?, ?, ?, replace(?, '-', ''), replace(?, '-', ''),"+
						" ?, ?, ?, ?, ?, ?, ?, ?, ?, replace(?, '-', ''),"+
						" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
						" ?, ?, ?, ?, ?, ?, ?, ?, replace(?, '-', ''), ?,"+
						" ?, replace(?, '-', ''), ?, ?, ?, ?)";
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, ins.getCar_mng_id());
			pstmt.setString(2, ins.getIns_st());
		    pstmt.setString(3, ins.getIns_sts());
			pstmt.setString(4, ins.getAge_scp());
			pstmt.setString(5, ins.getCar_use());
			pstmt.setString(6, ins.getIns_com_id());
			pstmt.setString(7, ins.getIns_con_no());
			pstmt.setString(8, ins.getConr_nm());
			pstmt.setString(9, ins.getIns_start_dt());
			pstmt.setString(10, ins.getIns_exp_dt());
			pstmt.setInt(11, ins.getRins_pcp_amt());
			pstmt.setString(12, ins.getVins_pcp_kd());
			pstmt.setInt(13, ins.getVins_pcp_amt());
			pstmt.setString(14, ins.getVins_gcp_kd());
			pstmt.setInt(15, ins.getVins_gcp_amt());
			pstmt.setString(16, ins.getVins_bacdt_kd());
			pstmt.setInt(17, ins.getVins_bacdt_amt());
			pstmt.setInt(18, ins.getVins_cacdt_amt());
			pstmt.setString(19, ins.getPay_tm());
			pstmt.setString(20, ins.getChange_dt());
			pstmt.setString(21, ins.getChange_cau());
			pstmt.setString(22, ins.getChange_itm_kd1());
			pstmt.setInt(23, ins.getChange_itm_amt1());
			pstmt.setString(24, ins.getChange_itm_kd2());
			pstmt.setInt(25, ins.getChange_itm_amt2());
			pstmt.setString(26, ins.getChange_itm_kd3());
			pstmt.setInt(27, ins.getChange_itm_amt3());
			pstmt.setString(28, ins.getChange_itm_kd4());
			pstmt.setInt(29, ins.getChange_itm_amt4());
			pstmt.setString(30, ins.getCar_rate());
			pstmt.setString(31, ins.getIns_rate());
			pstmt.setString(32, ins.getExt_rate());
			pstmt.setString(33, ins.getAir_ds_yn());
			pstmt.setString(34, ins.getAir_as_yn());
			pstmt.setString(35, ins.getAgnt_nm());
			pstmt.setString(36, ins.getAgnt_tel());
			pstmt.setString(37, ins.getAgnt_imgn_tel());
			pstmt.setString(38, ins.getAgnt_fax());
			pstmt.setString(39, ins.getExp_dt());
			pstmt.setString(40, ins.getExp_cau());
			pstmt.setInt(41, ins.getRtn_amt());
			pstmt.setString(42, ins.getRtn_dt());
			pstmt.setString(43, ins.getEnable_renew());
			pstmt.setString(44, ins.getCon_f_nm());
			pstmt.setString(45, ins.getAcc_tel());	
			pstmt.setString(46, ins.getAgnt_dept());
			
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}
	
	/**
	 * 보험료 UPDATE
	 */
	public boolean updateIns(InsurBean ins)
	{
		getConnection();
		boolean flag = true;
		String query = "update insur set"+
							" INS_STS = ?,"+
							" AGE_SCP = ?,"+
							" CAR_USE = ?,"+
							" INS_COM_ID = ?,"+
							" INS_CON_NO = ?,"+
							" CONR_NM = ?,"+
							" INS_START_DT = replace(?, '-', ''),"+
							" INS_EXP_DT = replace(?, '-', ''),"+
							" RINS_PCP_AMT = ?,"+
							" VINS_PCP_KD = ?,"+
							" VINS_PCP_AMT = ?,"+
							" VINS_GCP_KD = ?,"+
							" VINS_GCP_AMT = ?,"+
							" VINS_BACDT_KD = ?,"+
							" VINS_BACDT_KC2 = ?,"+
							" VINS_BACDT_AMT = ?,"+
							" VINS_CACDT_AMT = ?,"+
							" PAY_TM = ?,"+
							" CHANGE_DT = replace(?, '-', ''),"+
							" CHANGE_CAU = ?,"+
							" CHANGE_ITM_KD1 = ?,"+
							" CHANGE_ITM_AMT1 = ?,"+
							" CHANGE_ITM_KD2 = ?,"+
							" CHANGE_ITM_AMT2 = ?,"+
							" CHANGE_ITM_KD3 = ?,"+
							" CHANGE_ITM_AMT3 = ?,"+
							" CHANGE_ITM_KD4 = ?,"+
							" CHANGE_ITM_AMT4 = ?,"+
							" CAR_RATE = ?,"+
							" INS_RATE = ?,"+
							" EXT_RATE = ?,"+
							" AIR_DS_YN = ?,"+
							" AIR_AS_YN = ?,"+
							" AGNT_NM = ?,"+
							" AGNT_TEL = ?,"+
							" AGNT_IMGN_TEL = ?,"+
							" AGNT_FAX = ?,"+
							" EXP_DT = replace(?, '-', ''),"+
							" EXP_CAU = ?,"+
							" RTN_AMT = ?,"+
							" RTN_DT = replace(?, '-', ''),"+
//							" USE_YN = ?,"+
							" ENABLE_RENEW = ?,"+
							" CON_F_NM = ?,"+
							" AGNT_DEPT = ?,"+
							" ACC_TEL = ?,"+
							" VINS_SPE = ?,"+
							" VINS_SPE_AMT = ?"+
							" where CAR_MNG_ID = ? and INS_ST = ?";
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);
				
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, ins.getIns_sts());
			pstmt.setString(2, ins.getAge_scp());
			pstmt.setString(3, ins.getCar_use());
			pstmt.setString(4, ins.getIns_com_id());
			pstmt.setString(5, ins.getIns_con_no());
			pstmt.setString(6, ins.getConr_nm());
			pstmt.setString(7, ins.getIns_start_dt());
			pstmt.setString(8, ins.getIns_exp_dt());
			pstmt.setInt(9, ins.getRins_pcp_amt());
			pstmt.setString(10, ins.getVins_pcp_kd());
			pstmt.setInt(11, ins.getVins_pcp_amt());
			pstmt.setString(12, ins.getVins_gcp_kd());
			pstmt.setInt(13, ins.getVins_gcp_amt());
			pstmt.setString(14, ins.getVins_bacdt_kd());
			pstmt.setString(15, ins.getVins_bacdt_kc2());
			pstmt.setInt(16, ins.getVins_bacdt_amt());
			pstmt.setInt(17, ins.getVins_cacdt_amt());
			pstmt.setString(18, ins.getPay_tm());
			pstmt.setString(19, ins.getChange_dt());
			pstmt.setString(20, ins.getChange_cau());
			pstmt.setString(21, ins.getChange_itm_kd1());
			pstmt.setInt(22, ins.getChange_itm_amt1());
			pstmt.setString(23, ins.getChange_itm_kd2());
			pstmt.setInt(24, ins.getChange_itm_amt2());
			pstmt.setString(25, ins.getChange_itm_kd3());
			pstmt.setInt(26, ins.getChange_itm_amt3());
			pstmt.setString(27, ins.getChange_itm_kd4());
			pstmt.setInt(28, ins.getChange_itm_amt4());
			pstmt.setString(29, ins.getCar_rate());
			pstmt.setString(30, ins.getIns_rate());
			pstmt.setString(31, ins.getExt_rate());
			pstmt.setString(32, ins.getAir_ds_yn());
			pstmt.setString(33, ins.getAir_as_yn());
			pstmt.setString(34, ins.getAgnt_nm());
			pstmt.setString(35, ins.getAgnt_tel());
			pstmt.setString(36, ins.getAgnt_imgn_tel());
			pstmt.setString(37, ins.getAgnt_fax());
			pstmt.setString(38, ins.getExp_dt());
			pstmt.setString(39, ins.getExp_cau());
			pstmt.setInt(40, ins.getRtn_amt());
			pstmt.setString(41, ins.getRtn_dt());
//			pstmt.setString(41, ins.getUse_yn());
			pstmt.setString(42, ins.getEnable_renew());
			pstmt.setString(43, ins.getCon_f_nm());
			pstmt.setString(44, ins.getAgnt_dept());
			pstmt.setString(45, ins.getAcc_tel());
			pstmt.setString(46, ins.getVins_spe());
			pstmt.setInt(47, ins.getVins_spe_amt());
			pstmt.setString(48, ins.getCar_mng_id());
			pstmt.setString(49, ins.getIns_st());

		    pstmt.executeUpdate();
			pstmt.close();
		    
		    conn.commit();
		    	
	  	} catch (Exception e) {
	  		e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{	
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}

	/**
	 *	보험료 select
	 */
	public InsurBean getIns(String car_mng_id, String ins_st)
	{
		getConnection();
		InsurBean ins = new InsurBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	"";
		query = " select /*+  merge(C) */ \n"+
				"        I.CAR_MNG_ID, I.INS_ST, I.INS_STS, I.AGE_SCP,\n"+
				"        I.CAR_USE, I.INS_COM_ID, I.INS_CON_NO,\n"+
				"        I.CONR_NM, I.INS_START_DT, I.INS_EXP_DT,\n"+
				"        DECODE(I.INS_START_DT, '', '', SUBSTR(I.INS_START_DT, 1, 4)||'-'||SUBSTR(I.INS_START_DT, 5, 2)||'-'||SUBSTR(I.INS_START_DT, 7, 2)) INS_START_DT2,\n"+
				"        DECODE(I.INS_EXP_DT, '', '', SUBSTR(I.INS_EXP_DT, 1, 4)||'-'||SUBSTR(I.INS_EXP_DT, 5, 2)||'-'||SUBSTR(I.INS_EXP_DT, 7, 2)) INS_EXP_DT2,\n"+
				"        I.RINS_PCP_AMT, I.VINS_PCP_KD, I.VINS_PCP_AMT,\n"+
				"        I.VINS_GCP_KD, I.VINS_GCP_AMT, I.VINS_BACDT_KD, I.VINS_BACDT_AMT, I.VINS_CACDT_AMT,\n"+
				"        I.VINS_BACDT_KC2, I.VINS_SPE, I.VINS_SPE_AMT,\n"+
				"        I.PAY_TM,\n"+
				"        DECODE(I.CHANGE_DT, '', '', SUBSTR(I.CHANGE_DT, 1, 4)||'-'||SUBSTR(I.CHANGE_DT, 5, 2)||'-'||SUBSTR(I.CHANGE_DT, 7, 2)) CHANGE_DT,\n"+
				"        I.CHANGE_CAU, I.CHANGE_ITM_KD1,\n"+
				"        I.CHANGE_ITM_AMT1, I.CHANGE_ITM_KD2,\n"+
				"        I.CHANGE_ITM_AMT2, I.CHANGE_ITM_KD3,\n"+
				"        I.CHANGE_ITM_AMT3, I.CHANGE_ITM_KD4,\n"+
				"        I.CHANGE_ITM_AMT4, CHANGE_ITM_AMT4, I.CAR_RATE, I.INS_RATE,\n"+
				"        I.EXT_RATE, I.AIR_DS_YN, I.AIR_AS_YN, I.AGNT_NM,\n"+
				"        I.AGNT_TEL, I.AGNT_IMGN_TEL, I.AGNT_FAX,\n"+
				"        DECODE(I.EXP_DT, '', '', SUBSTR(I.EXP_DT, 1, 4)||'-'||SUBSTR(I.EXP_DT, 5, 2)||'-'||SUBSTR(I.EXP_DT, 7, 2)) EXP_DT,\n"+
				"        I.EXP_CAU, I.RTN_AMT,\n"+
				"        (I.CHANGE_ITM_AMT1+I.CHANGE_ITM_AMT2+I.CHANGE_ITM_AMT3+I.CHANGE_ITM_AMT4) change_amt,\n"+
				"        I.CON_F_NM, I.AGNT_DEPT, I.ACC_TEL, I.RTN_DT, I.enable_renew,\n"+
				"        DECODE(SIGN(TRUNC(TO_DATE(I.ins_exp_dt, 'YYYYMMDD')-SYSDATE)), -1, 'N', 'Y') use_yn,\n"+	//Y:유효, N:만료
				"        C.FIRM_NM, C.CLIENT_NM, cr.car_num, cn.CAR_NAME,\n"+
				"        C.RENT_L_CD, C.car_ja, cr.car_no, cr.car_nm, M.ins_com_nm\n"+
				" from   insur I, cont_n_view C, INS_COM M, (select max(rent_l_cd) rent_l_cd from cont where car_st<>'4' group by car_mng_id) E, car_reg cr,  car_etc g, car_nm cn \n"+
				" where  "+
				"        I.CAR_MNG_ID = ? and I.INS_ST = ? and \n"+
				"	I.car_mng_id = C.car_mng_id and \n"+
				"        C.rent_l_cd = E.rent_l_cd and \n"+
				"        I.ins_com_id = M.ins_com_id and \n"+
				"	i.car_mng_id = cr.car_mng_id  and c.rent_mng_id = g.rent_mng_id(+)  and c.rent_l_cd = g.rent_l_cd(+)  \n"+
                       		"	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+)  \n"+
				" ";

		try{
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, car_mng_id);
				pstmt.setString(2, ins_st);
		    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
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
				ins.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				ins.setFirm_nm(rs.getString("FIRM_NM")==null?"":rs.getString("FIRM_NM"));
				ins.setCar_num(rs.getString("CAR_NUM")==null?"":rs.getString("CAR_NUM"));
				ins.setClient_nm(rs.getString("CLIENT_NM")==null?"":rs.getString("CLIENT_NM"));
				ins.setCar_no(rs.getString("CAR_NO")==null?"":rs.getString("CAR_NO"));
				ins.setCar_nm(rs.getString("CAR_NM")==null?"":rs.getString("CAR_NM"));
				ins.setCar_name(rs.getString("CAR_NAME")==null?"":rs.getString("CAR_NAME"));
				ins.setChange_amt(rs.getInt("CHANGE_AMT"));
				ins.setIns_com_nm(rs.getString("INS_COM_NM")==null?"":rs.getString("INS_COM_NM"));
				ins.setIns_start_dt2(rs.getString("INS_START_DT2")==null?"":rs.getString("INS_START_DT2"));
				ins.setIns_exp_dt2(rs.getString("INS_EXP_DT2")==null?"":rs.getString("INS_EXP_DT2"));
				
				ins.setUse_yn(rs.getString("USE_YN")==null?"":rs.getString("USE_YN"));
				ins.setEnable_renew(rs.getString("ENABLE_RENEW")==null?"":rs.getString("ENABLE_RENEW"));
				
				ins.setCon_f_nm(rs.getString("CON_F_NM")==null?"":rs.getString("CON_F_NM"));
				ins.setAcc_tel(rs.getString("ACC_TEL")==null?"":rs.getString("ACC_TEL"));
				ins.setAgnt_dept(rs.getString("AGNT_DEPT")==null?"":rs.getString("AGNT_DEPT"));
				ins.setVins_bacdt_kc2(rs.getString("VINS_BACDT_KC2")==null?"":rs.getString("VINS_BACDT_KC2"));
				ins.setVins_spe(rs.getString("VINS_SPE")==null?"":rs.getString("VINS_SPE"));
				ins.setVins_spe_amt(rs.getInt("VINS_SPE_AMT"));
				ins.setCar_ja(rs.getInt("CAR_JA"));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ins;
		}
	}
	
	/**
	 *	보험리스트조회
	 *	gubun 	- (0:수금리스트, 2:갱신리스트)
	 *	s_kd	- 검색조건 ( 1: 계약코드, 2:상호, 3:차량번호, 4:보험계약일, 5:보험만료일, 6:납부일, 7:보험사, 8:회차)
	 *	t_wd	- 검색어
	 *	term	- 기간(납부일)(0:전체, 1:당일, 2:주간, 3:당월)
	 */
	public Vector getInsList(String gubun, String s_kd, String t_wd, String term)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		if(gubun.equals("0"))// 현행(만료되지 않은 보험계약)
		{
			query += 	" SELECT C.rent_mng_id rent_mng_id, C.rent_l_cd rent_l_cd, L.firm_nm firm_nm, I.ins_tm ins_tm,\n"+
								" R.car_no car_no, M.ins_com_nm ins_com_nm, I.pay_yn pay_yn, S.car_mng_id car_mng_id, S.ins_st ins_st,\n"+
								" DECODE(S.ins_start_dt, '', '', SUBSTR(S.ins_start_dt, 1, 4)||'-'||SUBSTR(S.ins_start_dt, 5, 2)||'-'||SUBSTR(S.ins_start_dt, 7, 2)) ins_start_dt,\n"+
								" DECODE(I.ins_est_dt, '', '', SUBSTR(I.ins_est_dt, 1, 4)||'-'||SUBSTR(I.ins_est_dt, 5, 2)||'-'||SUBSTR(I.ins_est_dt, 7, 2)) ins_est_dt,\n"+
								" DECODE(I.pay_dt, '', '', SUBSTR(I.pay_dt, 1, 4)||'-'||SUBSTR(I.pay_dt, 5, 2)||'-'||SUBSTR(I.pay_dt, 7, 2)) pay_dt,\n"+
								" I.pay_amt pay_amt, R.car_nm car_nm, S.age_scp age_scp, DECODE(S.air_ds_yn, 'Y', DECODE(S.air_as_yn, 'Y', '2', '1'), DECODE(S.air_as_yn, 'Y', '1', '0')) air\n"+
						" FROM SCD_INS I, CONT C, CAR_REG R, CLIENT L, INSUR S, INS_COM M\n"+
						" WHERE C.car_mng_id = R.car_mng_id AND\n"+
							  " I.car_mng_id = R.car_mng_id AND\n"+
							  " C.client_id = L.client_id AND\n"+
							  " S.car_mng_id = I.car_mng_id AND\n"+
							  " S.ins_st = I.ins_st AND\n"+
							  " S.ins_com_id = M.ins_com_id AND\n"+
							  " S.ins_exp_dt >= to_char(sysdate,'YYYYMMDD')";		//만료일이 현재일과 같거나 큰것
			if(s_kd.equals("1"))		query += " AND UPPER(C.rent_l_cd) LIKE UPPER('%"+t_wd+"%')\n";
			else if(s_kd.equals("2"))	query += " AND NVL(L.firm_nm, L.client_nm) LIKE '%"+t_wd+"%'\n";
			else if(s_kd.equals("3"))	query += " AND R.car_no LIKE '%"+t_wd+"%'\n";
			else if(s_kd.equals("4"))	query += " AND S.ins_start_dt LIKE '"+t_wd+"%'\n";
			else if(s_kd.equals("5"))	query += " AND S.ins_exp_dt LIKE '"+t_wd+"%'\n";
			else if(s_kd.equals("6"))	query += " AND I.ins_est_dt LIKE '"+t_wd+"%'\n";
			else if(s_kd.equals("7"))	query += " AND S.ins_com_id = '"+t_wd+"'\n";
			else if(s_kd.equals("8"))	query += " AND to_number(I.ins_tm) = "+t_wd;
	
			if(term.equals("1"))		query += " AND I.ins_est_dt	LIKE to_char(sysdate,'YYYYMMDD')\n";	//당일
		  	else if(term.equals("2"))	query += " AND I.ins_est_dt BETWEEN\n"+
												 " TO_CHAR(DECODE(TO_CHAR(SYSDATE, 'DY'), '일', SYSDATE, '월', SYSDATE-1, '화', SYSDATE-2, '수', SYSDATE-3, '목', SYSDATE-4, '금', SYSDATE-5 , '토', SYSDATE-6), 'YYYYMMDD')\n"+
												 " AND TO_CHAR(DECODE(TO_CHAR(SYSDATE, 'DY'), '일', SYSDATE+6, '월', SYSDATE+5, '화', SYSDATE+4, '수', SYSDATE+3, '목', SYSDATE+2, '금', SYSDATE+1 , '토', SYSDATE), 'YYYYMMDD')\n";	//주간
			else if(term.equals("3"))	query += " AND I.ins_est_dt	LIKE to_char(sysdate,'YYYYMM')||'%'\n";	//당월
			query += " order by L.firm_nm, S.ins_st";
		}
		else	//만료된 보험계약	
		/*갱신 리스트 --> 갱신횟수 1회에서 끝나는지 무한대인지 확인하고, field추가할것. */
		{
			query += " SELECT A.rent_mng_id rent_mng_id, A.rent_l_cd rent_l_cd, A.firm_nm firm_nm, A.ins_st ins_st, A.car_mng_id car_mng_id,\n"+
								" A.car_no car_no, A.ins_start_dt ins_start_dt, A.ins_exp_dt ins_exp_dt, A.ins_com_nm,\n"+
							    " A.CAR_NM CAR_NM, A.age_scp age_scp, A.air air, DECODE(B.car_mng_id, '', decode(A.enable_renew, 'Y', 'ENABLE', 'DISABLE'), 'Y') remake\n"+
						" FROM\n"+
						" (\n"+
							" SELECT C.rent_mng_id rent_mng_id, C.rent_l_cd rent_l_cd, NVL(L.firm_nm, L.client_nm) firm_nm, S.ins_st ins_st, C.car_mng_id car_mng_id,\n"+
									" R.car_no car_no, M.ins_com_nm ins_com_nm,\n"+
									" DECODE(S.ins_start_dt, '', '', SUBSTR(S.ins_start_dt, 1, 4)||'-'||SUBSTR(S.ins_start_dt, 5, 2)||'-'||SUBSTR(S.ins_start_dt, 7, 2)) ins_start_dt,\n"+
									" DECODE(S.ins_exp_dt, '', '', SUBSTR(S.ins_exp_dt, 1, 4)||'-'||SUBSTR(S.ins_exp_dt, 5, 2)||'-'||SUBSTR(S.ins_exp_dt, 7, 2)) ins_exp_dt,\n"+
								    " R.CAR_NM CAR_NM, S.age_scp age_scp, DECODE(S.air_ds_yn, 'Y', DECODE(S.air_as_yn, 'Y', '2', '1'), DECODE(S.air_as_yn, 'Y', '1', '0')) air, S.enable_renew, S.ins_com_id ins_com_id\n"+
							" FROM CONT C, CAR_REG R, CLIENT L, INSUR S, INS_COM M\n"+
							" WHERE C.car_mng_id = R.car_mng_id AND\n"+
									" C.client_id = L.client_id AND\n"+
									" C.car_mng_id = S.car_mng_id AND\n"+
									" S.ins_com_id = M.ins_com_id AND\n"+
									" S.ins_exp_dt <= to_char(sysdate,'YYYYMMDD') AND\n"+
									" S.exp_dt is null\n"+
						 " )A,\n"+
						" (\n"+
							" SELECT car_mng_id, ins_st\n"+
							" FROM INSUR\n"+
							" WHERE ins_st <> '0'\n"+
						" )B\n"+
							" WHERE A.car_mng_id = B.car_mng_id(+) AND\n"+
									" TO_NUMBER(A.ins_st+1) = TO_NUMBER(B.ins_st(+))\n";

			if(s_kd.equals("1"))		query += " AND UPPER(A.rent_l_cd) LIKE UPPER('%"+t_wd+"%')";
			else if(s_kd.equals("2"))	query += " AND A.firm_nm LIKE '%"+t_wd+"%'";
			else if(s_kd.equals("3"))	query += " AND A.car_no LIKE '%"+t_wd+"%'";
			else if(s_kd.equals("4"))	query += " AND A.ins_start_dt LIKE '"+t_wd+"%'";
			else if(s_kd.equals("5"))	query += " AND A.ins_exp_dt LIKE '"+t_wd+"%'";
			else if(s_kd.equals("7"))	query += " AND A.ins_com_id = '"+t_wd+"'";
			query += " order by A.firm_nm";
		}
		try {
				pstmt = conn.prepareStatement(query);
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
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}	
	
	/**
	 *	보험계약현황
	 *	s_kd	- 검색조건 ( 1:상호, 2: 계약코드, 3:차량번호, 4:보험사명, 5:계약개시일, 6:계약만료일)
	 *	t_wd	- 검색어
	 */
/*
	만료된 계약 표시?
	ins_sts --> 자동으로 만료처리 되지 않음.
	ins_sts는 1:유효, 3:중도해지만 있음. ---> 1/2로 바꿔야되겟네
	아무튼, 1일경우 ins_exp_dt로 만료됬는지 구분해줘야겟음
	
*/
	public Vector getInsConStat(String s_kd, String t_wd, String gubun)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = 	" SELECT C.rent_l_cd rent_l_cd, NVL(L.firm_nm, L.client_nm) firm_nm, I.ins_con_no ins_con_no,\n"+
								" R.car_mng_id rent_mng_id, DECODE(I.air_as_yn, 'Y', DECODE(I.air_ds_yn, 'Y', '2', '1'), DECODE(I.air_ds_yn, 'Y', '1', '0')) air,\n"+
								" DECODE(I.age_scp, '1', '21세이상', '2', '26세이상', '3', '모든운전자') age,\n"+
								" R.car_no car_no, I.ins_com_id ins_com_id, M.ins_com_nm ins_com_nm, I.rins_pcp_amt rins_amt,\n"+
								" (I.VINS_PCP_AMT+I.VINS_GCP_AMT+I.VINS_BACDT_AMT+I.VINS_CACDT_AMT) vins_amt,\n"+
								" (I.rins_pcp_amt+I.VINS_PCP_AMT+I.VINS_GCP_AMT+I.VINS_BACDT_AMT+I.VINS_CACDT_AMT) ins_amt,\n"+
								" DECODE(I.ins_start_dt, '', '', SUBSTR(I.ins_start_dt, 1, 4)||'-'||  SUBSTR(I.ins_start_dt, 5, 2)||'-'||  SUBSTR(I.ins_start_dt, 7, 2)) ins_start_dt,\n"+
								" DECODE(I.ins_exp_dt, '', '', SUBSTR(I.ins_exp_dt, 1, 4)||'-'||  SUBSTR(I.ins_exp_dt, 5, 2)||'-'||  SUBSTR(I.ins_exp_dt, 7, 2)) ins_exp_dt,\n"+
								" I.ins_start_dt ins_start_dt_f, I.ins_exp_dt ins_exp_dt_f, I.pay_tm pay_tm,\n"+
								" DECODE(I.ins_sts, '1',  DECODE(SIGN(TRUNC(TO_DATE(I.ins_exp_dt, 'YYYYMMDD')-SYSDATE)), -1, '만료', DECODE(I.ins_st, '0', '신규', '갱신')), '2', '중도해지') ins_sts\n"+
						" FROM CONT C, CAR_REG R, INSUR I, CLIENT L, INS_COM M\n"+
						" WHERE C.car_mng_id = R.car_mng_id AND\n"+
							  " R.car_mng_id = I.car_mng_id AND\n"+
							  " C.client_id = L.client_id AND\n"+
							  " I.ins_com_id = M.ins_com_id\n";

			if(!t_wd.equals("")){
				if(s_kd.equals("1"))		query += " AND nvl(L.firm_nm, L.client_nm) LIKE '%"+t_wd+"%'";
				else if(s_kd.equals("2"))	query += " AND upper(C.rent_l_cd) LIKE upper('%"+t_wd+"%')";
				else if(s_kd.equals("3"))	query += " AND R.car_no LIKE '%"+t_wd+"%'";
				else if(s_kd.equals("4"))	query += " AND I.ins_com_id LIKE '%"+t_wd+"%'";
				else if(s_kd.equals("5"))	query += " AND I.ins_start_dt_f LIKE '%"+t_wd+"%'";
				else if(s_kd.equals("6"))	query += " AND I.ins_exp_dt_f LIKE '%"+t_wd+"%'";
			}
			

			if(gubun.equals("1"))		query += " AND I.ins_st = '0' and I.ins_sts= '1' and SIGN(TRUNC(TO_DATE(I.ins_exp_dt, 'YYYYMMDD')-SYSDATE )) <> -1 ";
			else if(gubun.equals("2"))	query += " AND I.ins_st <> '0' and I.ins_sts= '1' and SIGN(TRUNC(TO_DATE(I.ins_exp_dt, 'YYYYMMDD')-SYSDATE )) <> -1 ";
			else if(gubun.equals("3"))	query += " AND I.ins_sts = '2'";
			else if(gubun.equals("4"))	query += " AND I.ins_sts = '1' and SIGN(TRUNC(TO_DATE(I.ins_exp_dt, 'YYYYMMDD')-SYSDATE )) = -1 ";
			else						query += " AND I.ins_sts = '1'";

			query += " order by I.ins_start_dt";


		try {
				pstmt = conn.prepareStatement(query);
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
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}		
}