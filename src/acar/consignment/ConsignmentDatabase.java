package acar.consignment;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;
import acar.common.*;
import oracle.jdbc.*;
import oracle.sql.*;

public class ConsignmentDatabase
{
	private Connection conn = null;
	public static ConsignmentDatabase db;
	
	private final String DATA_SOURCE	= "acar";
	private final String DATA_SOURCE1	= "biztalk";   //acar에서 biztalk으로 변경예정 
	
	public static ConsignmentDatabase getInstance()
	{
		if(ConsignmentDatabase.db == null)
			ConsignmentDatabase.db = new ConsignmentDatabase();
		return ConsignmentDatabase.db;
	}	
	
 	private DBConnectionManager connMgr = null;

    private void getConnection() {
    	try{
	    	if(connMgr == null)
				connMgr = DBConnectionManager.getInstance();
			if(conn == null)
	        	conn = connMgr.getConnection(DATA_SOURCE);				
	    }catch(Exception e){
	    	System.out.println(" i can't get a connection........");
	    }
	}
	
	private void closeConnection() {
		if ( conn != null ) {
			connMgr.freeConnection(DATA_SOURCE, conn);
			conn = null;
		}		
	}
	
	private void getConnection2() {
		try{
			if(connMgr == null)
				connMgr = DBConnectionManager.getInstance();
			if(conn == null)
				conn = connMgr.getConnection(DATA_SOURCE1);				
		}catch(Exception e){
			System.out.println(" i can't get a connection........");
		}
	}
	
	private void closeConnection2() {
		if ( conn != null ) {
			connMgr.freeConnection(DATA_SOURCE1, conn);
			conn = null;
		}		
	}
	
	//한건 조회
	public ConsignmentBean getConsignment(String cons_no, int seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ConsignmentBean bean = new ConsignmentBean();
		String query = "";
//		query = " select * from consignment where cons_no = ? and seq = ?";
		query = " SELECT a.parking_file, a.psoilamt_file, a.CONS_ST, a.CONS_SU, a.REG_CODE, a.OFF_ID, a.OFF_NM, a.CAR_MNG_ID, a.RENT_MNG_ID, a.RENT_L_CD, " +
					" a.CLIENT_ID, a.CAR_NO, a.CAR_NM, a.CONS_CAU, a.CONS_CAU_ETC, a.COST_ST, a.PAY_ST, a.FROM_ST, a.FROM_PLACE, a.FROM_COMP, a.FROM_TITLE, " +
					" a.FROM_MAN, a.FROM_TEL, a.FROM_M_TEL, a.FROM_REQ_DT, a.FROM_EST_DT, a.TO_ST, a.TO_PLACE, a.TO_COMP, a.TO_TITLE, a.TO_MAN, a.TO_TEL, " +
					" a.TO_M_TEL, a.TO_REQ_DT, a.TO_EST_DT, a.DRIVER_NM, a.DRIVER_M_TEL, a.WASH_YN, a.OIL_YN, a.OIL_LITER, a.OIL_EST_AMT, a.ETC, a.CONS_AMT, " +
					" a.WASH_AMT, a.OIL_AMT, a.OTHER_AMT, a.OTHER, a.TOT_AMT, a.PAY_DT, a.REQ_DT, a.REQ_CODE, a.CUST_AMT, a.CUST_PAY_DT, a.CONF_DT, a.CONS_COPY, " +
					" a.REG_ID, a.REG_DT, a.OUT_OK, a.CMP_APP, a.AFTER_YN, DECODE(b.DIST_KM, '',a.TOT_DIST, '0',a.TOT_DIST, b.DIST_KM) AS tot_dist, a.REQ_ID, a.F_MAN, " +
					" a.D_MAN, a.MM_SEQ, a.HIPASS_YN, a.HIPASS_AMT, a.M_DOC_CODE, a.M_AMT, a.OIL_CARD_AMT, a.CONS_NO, a.SEQ, " +
					" DECODE(b.START_DT, '', a.FROM_EST_DT,b.START_DT) AS from_dt, DECODE(b.END_DT, '', a.TO_EST_DT,b.END_DT) AS to_dt, a.agent_emp_id, " +
					" a.WASH_FEE, a.sub_l_cd , a.wash_card_amt , a.cons_other_amt , a.etc1_amt , a.etc2_amt  " +
					" FROM consignment a, CONS_OKSMS b where a.cons_no = b.CONS_NO(+) AND a.SEQ = b.SEQ(+) AND a.cons_no = ? and a.seq = ?";
		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, cons_no);
			pstmt.setInt   (2, seq);
		   	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{
				bean.setCons_no				(rs.getString("cons_no")			==null?"":rs.getString("cons_no"));
				bean.setSeq						(rs.getInt     ("seq"));
				bean.setCons_st				(rs.getString("cons_st")			==null?"":rs.getString("cons_st"));
				bean.setCons_su				(rs.getInt     ("cons_su"));
				bean.setReg_code				(rs.getString("reg_code")			==null?"":rs.getString("reg_code"));
	 			bean.setOff_id					(rs.getString("off_id")				==null?"":rs.getString("off_id"));	
	 			bean.setOff_nm				(rs.getString("off_nm")				==null?"":rs.getString("off_nm"));	
				bean.setCar_mng_id			(rs.getString("car_mng_id")		==null?"":rs.getString("car_mng_id"));
				bean.setRent_mng_id		(rs.getString("rent_mng_id")	==null?"":rs.getString("rent_mng_id"));
				bean.setRent_l_cd			(rs.getString("rent_l_cd")			==null?"":rs.getString("rent_l_cd"));
				bean.setClient_id				(rs.getString("client_id")			==null?"":rs.getString("client_id"));
				bean.setCar_no				(rs.getString("car_no")				==null?"":rs.getString("car_no"));	
				bean.setCar_nm				(rs.getString("car_nm")			==null?"":rs.getString("car_nm"));
				bean.setCons_cau				(rs.getString("cons_cau")			==null?"":rs.getString("cons_cau"));
				bean.setCons_cau_etc		(rs.getString("cons_cau_etc")	==null?"":rs.getString("cons_cau_etc"));
				bean.setCost_st				(rs.getString("cost_st")				==null?"":rs.getString("cost_st"));
				bean.setPay_st					(rs.getString("pay_st")				==null?"":rs.getString("pay_st"));
				bean.setFrom_st				(rs.getString("from_st")			==null?"":rs.getString("from_st"));
				bean.setFrom_place			(rs.getString("from_place")		==null?"":rs.getString("from_place"));	
				bean.setFrom_comp			(rs.getString("from_comp")		==null?"":rs.getString("from_comp"));	
				bean.setFrom_title			(rs.getString("from_title")			==null?"":rs.getString("from_title"));	
				bean.setFrom_man			(rs.getString("from_man")		==null?"":rs.getString("from_man"));	
				bean.setFrom_tel				(rs.getString("from_tel")			==null?"":rs.getString("from_tel"));	
				bean.setFrom_m_tel			(rs.getString("from_m_tel")		==null?"":rs.getString("from_m_tel"));	
				bean.setFrom_req_dt		(rs.getString("from_req_dt")		==null?"":rs.getString("from_req_dt"));
				bean.setFrom_est_dt		(rs.getString("from_est_dt")		==null?"":rs.getString("from_est_dt"));
				bean.setFrom_dt				(rs.getString("from_dt")			==null?"":rs.getString("from_dt"));
				bean.setTo_st					(rs.getString("to_st")				==null?"":rs.getString("to_st"));
				bean.setTo_place				(rs.getString("to_place")			==null?"":rs.getString("to_place"));	
				bean.setTo_comp				(rs.getString("to_comp")			==null?"":rs.getString("to_comp"));	
				bean.setTo_title				(rs.getString("to_title")				==null?"":rs.getString("to_title"));	
				bean.setTo_man				(rs.getString("to_man")			==null?"":rs.getString("to_man"));	
				bean.setTo_tel					(rs.getString("to_tel")				==null?"":rs.getString("to_tel"));	
				bean.setTo_m_tel				(rs.getString("to_m_tel")			==null?"":rs.getString("to_m_tel"));	
				bean.setTo_req_dt			(rs.getString("to_req_dt")			==null?"":rs.getString("to_req_dt"));
				bean.setTo_est_dt				(rs.getString("to_est_dt")			==null?"":rs.getString("to_est_dt"));
				bean.setTo_dt					(rs.getString("to_dt")				==null?"":rs.getString("to_dt"));
				bean.setDriver_nm			(rs.getString("driver_nm")		==null?"":rs.getString("driver_nm"));
				bean.setDriver_m_tel		(rs.getString("driver_m_tel")	==null?"":rs.getString("driver_m_tel"));
				bean.setWash_yn				(rs.getString("wash_yn")			==null?"":rs.getString("wash_yn"));
				bean.setOil_yn					(rs.getString("oil_yn")				==null?"":rs.getString("oil_yn"));
				bean.setOil_liter				(rs.getInt     ("oil_liter"));
				bean.setOil_est_amt			(rs.getInt     ("oil_est_amt"));
				bean.setEtc						(rs.getString("etc")					==null?"":rs.getString("etc"));
				bean.setCons_amt			(rs.getInt     ("cons_amt"));
				bean.setOil_amt				(rs.getInt     ("oil_amt"));
				bean.setWash_amt			(rs.getInt     ("wash_amt"));	
				bean.setOther					(rs.getString("other")				==null?"":rs.getString("other"));
				bean.setOther_amt			(rs.getInt     ("other_amt"));
				bean.setTot_amt				(rs.getInt     ("tot_amt"));	
				bean.setPay_dt					(rs.getString("pay_dt")				==null?"":rs.getString("pay_dt"));
				bean.setReq_dt					(rs.getString("req_dt")				==null?"":rs.getString("req_dt"));
				bean.setReq_code				(rs.getString("req_code")			==null?"":rs.getString("req_code"));
				bean.setCust_amt				(rs.getInt     ("cust_amt"));	
				bean.setCust_pay_dt		(rs.getString("cust_pay_dt")		==null?"":rs.getString("cust_pay_dt"));
				bean.setConf_dt				(rs.getString("conf_dt")			==null?"":rs.getString("conf_dt"));
				bean.setCons_copy			(rs.getString("cons_copy")		==null?"":rs.getString("cons_copy"));
				bean.setCmp_app				(rs.getString("cmp_app")			==null?"":rs.getString("cmp_app"));
				bean.setAfter_yn				(rs.getString("after_yn")			==null?"":rs.getString("after_yn"));
				bean.setTot_dist				(rs.getInt     ("tot_dist"));	
				bean.setReq_id					(rs.getString("req_id")				==null?"":rs.getString("req_id"));

				bean.setF_man					(rs.getString("f_man")				==null?"":rs.getString("f_man"));
				bean.setD_man					(rs.getString("d_man")				==null?"":rs.getString("d_man"));
				bean.setMm_seq				(rs.getString("mm_seq")			==null?"":rs.getString("mm_seq"));
				bean.setHipass_yn			(rs.getString("hipass_yn")		==null?"":rs.getString("hipass_yn"));
				bean.setHipass_amt			(rs.getInt     ("hipass_amt"));

				bean.setReg_id					(rs.getString("reg_id")				==null?"":rs.getString("reg_id"));
				bean.setM_doc_code			(rs.getString("m_doc_code")	==null?"":rs.getString("m_doc_code"));
				bean.setM_amt					(rs.getInt     ("m_amt"));
				bean.setOil_card_amt		(rs.getInt     ("oil_card_amt"));
				bean.setParking_file			(rs.getString("parking_file")		==null?"":rs.getString("parking_file"));
				bean.setPsoilamt_file		(rs.getString("psoilamt_file")	==null?"":rs.getString("psoilamt_file"));
				bean.setAgent_emp_id		(rs.getString("agent_emp_id")	==null?"":rs.getString("agent_emp_id"));
				bean.setWash_fee				(rs.getInt		("wash_fee"));				
				bean.setSub_l_cd		(rs.getString("sub_l_cd")	==null?"":rs.getString("sub_l_cd"));
				bean.setWash_card_amt		(rs.getInt		("wash_card_amt"));
				bean.setCons_other_amt		(rs.getInt		("cons_other_amt"));
				
				bean.setEtc1_amt		(rs.getInt		("etc1_amt"));
				bean.setEtc2_amt		(rs.getInt		("etc2_amt"));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ConsignmentDatabase:getConsignment]\n"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}				
	}

	public String insertConsignment(ConsignmentBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		String cons_no = "";
		String query =  " insert into consignment "+
						" ( cons_no, seq, cons_st, cons_su, reg_code, off_id, off_nm, car_mng_id, rent_mng_id, rent_l_cd, "+
						"   client_id, car_no, car_nm, cons_cau, cost_st, pay_st, from_st, from_place, from_comp, from_title,"+
						"	from_man, from_tel, from_m_tel, from_req_dt, from_est_dt, from_dt, to_st, to_place, to_comp, to_title,"+
						"   to_man, to_tel, to_m_tel, to_req_dt, to_est_dt, to_dt, driver_nm, driver_m_tel, wash_yn, oil_yn, "+
						"   oil_liter, oil_est_amt, etc, cons_amt, wash_amt, oil_amt, other, other_amt, tot_amt, pay_dt,"+
						"   cons_cau_etc, req_dt, req_code, cust_amt, cust_pay_dt, conf_dt, cons_copy, reg_id, reg_dt, cmp_app, after_yn, req_id, f_man, d_man, mm_seq, "+
						"   hipass_yn, hipass_amt, agent_emp_id, wash_fee, sub_l_cd "+
						" ) values "+
						" ( ?, ?, ?, ?, ?,    ?, ?, ?, ?, ?,					"+
						"   ?, ?, ?, ?, ?,    ?, ?, ?, ?, ?,					"+
						"   ?, ?, ?, replace(?,'-',''), replace(?,'-',''),    replace(?,'-',''), ?, ?, ?, ?,	"+
						"   ?, ?, ?, replace(?,'-',''), replace(?,'-',''),    replace(?,'-',''), ?, ?, ?, ?,	"+
						"   ?, ?, ?, ?, ?,    ?, ?, ?, ?, replace(?,'-',''),    "+
						"   ?, replace(?,'-',''), ?, ?, replace(?,'-',''), ?, ?, ?, replace(?,'-',''), ?, ?, ?, ?, ?, ?,  "+
						"   ?, ?, ?, ?, ? "+
						" )";

		String qry_id = " select to_char(sysdate,'YYYYMMDD')||nvl(ltrim(to_char(to_number(max(substr(cons_no,9,4))+1), '0000')), '0001') cons_no"+
						" from consignment "+
						" where substr(cons_no,1,8)=to_char(sysdate,'YYYYMMDD')";


		try
		{
			conn.setAutoCommit(false);
			pstmt1 = conn.prepareStatement(qry_id);
		   	rs = pstmt1.executeQuery();
			while(rs.next())
			{
				cons_no = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt1.close();
			conn.commit();
		}catch(Exception e){					
	        try{
				System.out.println("[ConsignmentDatabase:insertConsignment]"+e);
	            conn.rollback();
				e.printStackTrace();	
				flag = false;
	        }catch(SQLException _ignored){}
		}finally{
			try{
                if(rs != null )		rs.close();
	            if(pstmt1 != null)	pstmt1.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
		}

		try
		{
			conn.setAutoCommit(false);

			pstmt2 = conn.prepareStatement(query);
			
			if(bean.getCons_no().equals("")){
				pstmt2.setString(1,  cons_no		      );
			}else{
				pstmt2.setString(1,  bean.getCons_no	());
				cons_no = bean.getCons_no();
			}
			pstmt2.setInt   (2,  bean.getSeq						());
			pstmt2.setString(3,  bean.getCons_st				());
			pstmt2.setInt   (4,  bean.getCons_su					());
			pstmt2.setString(5,  bean.getReg_code				());
			pstmt2.setString(6,  bean.getOff_id					());
			pstmt2.setString(7,  bean.getOff_nm				());
			pstmt2.setString(8,  bean.getCar_mng_id			());
			pstmt2.setString(9,  bean.getRent_mng_id		());
			pstmt2.setString(10, bean.getRent_l_cd			());
			pstmt2.setString(11, bean.getClient_id				());
			pstmt2.setString(12, bean.getCar_no				());
			pstmt2.setString(13, bean.getCar_nm				());
			pstmt2.setString(14, bean.getCons_cau			());
			pstmt2.setString(15, bean.getCost_st				());
			pstmt2.setString(16, bean.getPay_st					());
			pstmt2.setString(17, bean.getFrom_st				());
			pstmt2.setString(18, bean.getFrom_place			());
			pstmt2.setString(19, bean.getFrom_comp			());
			pstmt2.setString(20, bean.getFrom_title			());
			pstmt2.setString(21, bean.getFrom_man			());
			pstmt2.setString(22, bean.getFrom_tel				());
			pstmt2.setString(23, bean.getFrom_m_tel		());
			pstmt2.setString(24, bean.getFrom_req_dt		());
			pstmt2.setString(25, bean.getFrom_est_dt		());
			pstmt2.setString(26, bean.getFrom_dt				());
			pstmt2.setString(27, bean.getTo_st					());
			pstmt2.setString(28, bean.getTo_place				());
			pstmt2.setString(29, bean.getTo_comp				());
			pstmt2.setString(30, bean.getTo_title				());
			pstmt2.setString(31, bean.getTo_man				());
			pstmt2.setString(32, bean.getTo_tel					());
			pstmt2.setString(33, bean.getTo_m_tel				());
			pstmt2.setString(34, bean.getTo_req_dt			());
			pstmt2.setString(35, bean.getTo_est_dt			());
			pstmt2.setString(36, bean.getTo_dt					());
			pstmt2.setString(37, bean.getDriver_nm			());
			pstmt2.setString(38, bean.getDriver_m_tel		());
			pstmt2.setString(39, bean.getWash_yn    			());
			pstmt2.setString(40, bean.getOil_yn     			());
			pstmt2.setInt   (41, bean.getOil_liter  				());
			pstmt2.setInt   (42, bean.getOil_est_amt			());
			pstmt2.setString(43, bean.getEtc						());
			pstmt2.setInt   (44, bean.getCons_amt				());
			pstmt2.setInt   (45, bean.getOil_amt					());
			pstmt2.setInt   (46, bean.getWash_amt				());
			pstmt2.setString(47, bean.getOther					());
			pstmt2.setInt   (48, bean.getOther_amt			());
			pstmt2.setInt   (49, bean.getTot_amt				());
			pstmt2.setString(50, bean.getPay_dt				());
			pstmt2.setString(51, bean.getCons_cau_etc		());
			pstmt2.setString(52, bean.getReq_dt				());
			pstmt2.setString(53, bean.getReq_code			());
			pstmt2.setInt   (54, bean.getCust_amt				());
			pstmt2.setString(55, bean.getCust_pay_dt		());
			pstmt2.setString(56, bean.getConf_dt				());
			pstmt2.setString(57, bean.getCons_copy			());
			pstmt2.setString(58, bean.getReg_id				());
			pstmt2.setString(59, bean.getReg_dt				());
			pstmt2.setString(60, bean.getCmp_app			());
			pstmt2.setString(61, bean.getAfter_yn				());
			pstmt2.setString(62, bean.getReq_id				());

			pstmt2.setString(63, bean.getF_man				());
			pstmt2.setString(64, bean.getD_man				());
			pstmt2.setString(65, bean.getMm_seq				());
			pstmt2.setString(66, bean.getHipass_yn			());
			pstmt2.setInt  	 (67, bean.getHipass_amt			());
			pstmt2.setString(68, bean.getAgent_emp_id		());
			pstmt2.setInt	 (69, bean.getWash_fee			());
			pstmt2.setString	 (70, bean.getSub_l_cd			());

			pstmt2.executeUpdate();			
			pstmt2.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[ConsignmentDatabase:insertConsignment]\n"+e);

			System.out.println("[bean.getCons_no		()]\n"+bean.getCons_no		());
			System.out.println("[bean.getSeq			()]\n"+bean.getSeq			());
			System.out.println("[bean.getCons_st		()]\n"+bean.getCons_st		());
			System.out.println("[bean.getCons_su		()]\n"+bean.getCons_su		());
			System.out.println("[bean.getReg_code		()]\n"+bean.getReg_code		());
			System.out.println("[bean.getOff_id			()]\n"+bean.getOff_id		());
			System.out.println("[bean.getOff_nm			()]\n"+bean.getOff_nm		());
			System.out.println("[bean.getCar_mng_id		()]\n"+bean.getCar_mng_id	());
			System.out.println("[bean.getRent_mng_id	()]\n"+bean.getRent_mng_id	());
			System.out.println("[bean.getRent_l_cd		()]\n"+bean.getRent_l_cd	());
			System.out.println("[bean.getClient_id		()]\n"+bean.getClient_id	());
			System.out.println("[bean.getCar_no			()]\n"+bean.getCar_no		());
			System.out.println("[bean.getCar_nm			()]\n"+bean.getCar_nm		());
			System.out.println("[bean.getCons_cau		()]\n"+bean.getCons_cau		());
			System.out.println("[bean.getCost_st		()]\n"+bean.getCost_st		());
			System.out.println("[bean.getPay_st			()]\n"+bean.getPay_st		());
			System.out.println("[bean.getFrom_st		()]\n"+bean.getFrom_st		());
			System.out.println("[bean.getFrom_place		()]\n"+bean.getFrom_place	());
			System.out.println("[bean.getFrom_comp		()]\n"+bean.getFrom_comp	());
			System.out.println("[bean.getFrom_title		()]\n"+bean.getFrom_title	());
			System.out.println("[bean.getFrom_man		()]\n"+bean.getFrom_man		());
			System.out.println("[bean.getFrom_tel		()]\n"+bean.getFrom_tel		());
			System.out.println("[bean.getFrom_m_tel		()]\n"+bean.getFrom_m_tel	());
			System.out.println("[bean.getFrom_req_dt	()]\n"+bean.getFrom_req_dt	());
			System.out.println("[bean.getFrom_est_dt	()]\n"+bean.getFrom_est_dt	());
			System.out.println("[bean.getFrom_dt		()]\n"+bean.getFrom_dt		());
			System.out.println("[bean.getTo_st			()]\n"+bean.getTo_st		());
			System.out.println("[bean.getTo_place		()]\n"+bean.getTo_place		());
			System.out.println("[bean.getTo_comp		()]\n"+bean.getTo_comp		());
			System.out.println("[bean.getTo_title		()]\n"+bean.getTo_title		());
			System.out.println("[bean.getTo_man			()]\n"+bean.getTo_man		());
			System.out.println("[bean.getTo_tel			()]\n"+bean.getTo_tel		());
			System.out.println("[bean.getTo_m_tel		()]\n"+bean.getTo_m_tel		());
			System.out.println("[bean.getTo_req_dt		()]\n"+bean.getTo_req_dt	());
			System.out.println("[bean.getTo_est_dt		()]\n"+bean.getTo_est_dt	());
			System.out.println("[bean.getTo_dt			()]\n"+bean.getTo_dt		());
			System.out.println("[bean.getDriver_nm		()]\n"+bean.getDriver_nm	());
			System.out.println("[bean.getDriver_m_tel	()]\n"+bean.getDriver_m_tel	());
			System.out.println("[bean.getWash_yn    	()]\n"+bean.getWash_yn    	());
			System.out.println("[bean.getOil_yn     	()]\n"+bean.getOil_yn     	());
			System.out.println("[bean.getOil_liter  	()]\n"+bean.getOil_liter  	());
			System.out.println("[bean.getOil_est_amt	()]\n"+bean.getOil_est_amt	());
			System.out.println("[bean.getEtc			()]\n"+bean.getEtc			());
			System.out.println("[bean.getCons_amt		()]\n"+bean.getCons_amt		());
			System.out.println("[bean.getOil_amt		()]\n"+bean.getOil_amt		());
			System.out.println("[bean.getWash_amt		()]\n"+bean.getWash_amt		());
			System.out.println("[bean.getOther			()]\n"+bean.getOther		());
			System.out.println("[bean.getOther_amt		()]\n"+bean.getOther_amt	());
			System.out.println("[bean.getTot_amt		()]\n"+bean.getTot_amt		());
			System.out.println("[bean.getPay_dt			()]\n"+bean.getPay_dt		());
			System.out.println("[bean.getCons_cau_etc	()]\n"+bean.getCons_cau_etc	());
			System.out.println("[bean.getReq_dt			()]\n"+bean.getReq_dt		());
			System.out.println("[bean.getReq_code		()]\n"+bean.getReq_code		());
			System.out.println("[bean.getCust_amt		()]\n"+bean.getCust_amt		());
			System.out.println("[bean.getCust_pay_dt	()]\n"+bean.getCust_pay_dt	());
			System.out.println("[bean.getConf_dt		()]\n"+bean.getConf_dt		());
			System.out.println("[bean.getCons_copy		()]\n"+bean.getCons_copy	());
			System.out.println("[bean.getReg_id			()]\n"+bean.getReg_id		());
			System.out.println("[bean.getReg_dt			()]\n"+bean.getReg_dt		());

			System.out.println("[bean.getF_man			()]\n"+bean.getF_man		());
			System.out.println("[bean.getD_man			()]\n"+bean.getD_man		());

			System.out.println("[bean.getHipass_yn		()]\n"+bean.getHipass_yn	());
			System.out.println("[bean.getHipass_amt		()]\n"+bean.getHipass_amt	());
			System.out.println("[bean.getSub_l_cd	()]\n"+bean.getSub_l_cd	());

			e.printStackTrace();
	  		flag = false;
			cons_no = "";
			conn.rollback();
		}finally{
			try{
	            if(pstmt2 != null)	pstmt2.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return cons_no;
		}
	}

	public boolean updateConsignment(ConsignmentBean bean)
	{
		ConsignmentBean consignment = getConsignment(bean.getCons_no(), bean.getSeq());
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		String query =  " update consignment set "+
						"	cons_st			= ?, "+
						"	cons_su			= ?, "+
						"	reg_code		= ?, "+
						"	off_id			= ?, "+
						"	off_nm			= ?, "+
						"	car_mng_id		= ?, "+
						"	rent_mng_id		= ?, "+
						"	rent_l_cd		= ?, "+
						"	client_id		= ?, "+
						"	car_no			= ?, "+
						"	car_nm			= ?, "+
						"	cons_cau		= ?, "+
						"	cost_st			= ?, "+
						"	pay_st			= ?, "+
						"	from_st			= ?, "+
						"	from_place		= ?, "+
						"	from_comp		= ?, "+
						"	from_title		= ?, "+
						"	from_man		= ?, "+
						"	from_tel		= ?, "+
						"	from_m_tel		= ?, "+
						"	from_req_dt		= replace(?,'-',''), "+
						"	from_est_dt		= replace(?,'-',''), "+
						"	from_dt			= replace(?,'-',''), "+
						"	to_st			= ?, "+
						"	to_place		= ?, "+
						"	to_comp			= ?, "+
						"	to_title		= ?, "+
						"	to_man			= ?, "+
						"	to_tel			= ?, "+
						"	to_m_tel		= ?, "+
						"	to_req_dt		= replace(?,'-',''), "+
						"	to_est_dt		= replace(?,'-',''), "+
						"	to_dt			= replace(?,'-',''), "+
						"	driver_nm		= ?, "+
						"	driver_m_tel	= ?, "+
						"	wash_yn			= ?, "+
						"	oil_yn			= ?, "+
						"	oil_liter		= ?, "+
						"	oil_est_amt		= ?, "+
						"	etc				= ?, "+
						"	cons_amt		= ?, "+
						"	wash_amt		= ?, "+
						"	oil_amt			= ?, "+
						"	other			= ?, "+
						"	other_amt		= ?, "+
						"	tot_amt			= ?, "+
						"	pay_dt			= replace(?,'-',''), "+
						"	req_dt			= replace(?,'-',''), "+
						"	cons_cau_etc	= ?, "+
						"	req_code		= ?, "+
						"	cust_amt		= ?, "+
						"	cust_pay_dt		= replace(?,'-',''),  "+
						"	cons_copy		= ?,  "+
						"	cmp_app			= ?,  "+
						"   tot_dist		= ?,  "+
						"	req_id			= ?,  "+
						"   hipass_yn		= ?,  "+
						"   oil_card_amt	= ?,   "+
						"   hipass_amt		= ?,   "+
						"   agent_emp_id	= ?,   "+
						"   sub_l_cd	= ?,   "+
						"   wash_fee	= ?,   "+
						"   wash_card_amt	= ? ,  "+
						"   cons_other_amt	= ? ,  "+
						"   etc1_amt	= ?  , "+
						"   etc2_amt	= ?   "+
						" where cons_no=? and seq=?";
		
		String query_oksms = "";
		String from_dt = bean.getFrom_dt().replace("-", "");
		String to_dt = bean.getTo_dt().replace("-", "");
		
		// 누적 주행거리, 출발일시, 도착일시 수정 시 cons_oksms 테이블에서 해당 컬럼 update                                        
		if(bean.getTot_dist() != consignment.getTot_dist() || !from_dt.equals(consignment.getFrom_dt()) || !to_dt.equals(consignment.getTo_dt()) ){
			query_oksms += "UPDATE CONS_OKSMS SET ";
			if(bean.getTot_dist() != consignment.getTot_dist()) query_oksms += " DIST_KM = "+ bean.getTot_dist() +" ";
			if(bean.getTot_dist() != consignment.getTot_dist() && (!from_dt.equals(consignment.getFrom_dt()) || !to_dt.equals(consignment.getTo_dt()))) query_oksms += ", ";
			if(!from_dt.equals(consignment.getFrom_dt())) query_oksms += " START_DT = " + from_dt + " ";
			if(!from_dt.equals(consignment.getFrom_dt()) && !to_dt.equals(consignment.getTo_dt())) query_oksms += ", ";
			if(!to_dt.equals(consignment.getTo_dt())) query_oksms += " END_DT = " + to_dt + " ";
			query_oksms += " WHERE CONS_NO = " + bean.getCons_no() + " AND SEQ = "+ bean.getSeq() + " ";
		}

		try
		{
			conn.setAutoCommit(false);
			pstmt1 = conn.prepareStatement(query);
			
			pstmt1.setString(1,  bean.getCons_st					());
			pstmt1.setInt     (2,  bean.getCons_su				());
			pstmt1.setString(3,  bean.getReg_code				());
			pstmt1.setString(4,  bean.getOff_id					());
			pstmt1.setString(5,  bean.getOff_nm					());
			pstmt1.setString(6,  bean.getCar_mng_id			());
			pstmt1.setString(7,  bean.getRent_mng_id			());
			pstmt1.setString(8,  bean.getRent_l_cd				());
			pstmt1.setString(9,  bean.getClient_id				());
			pstmt1.setString(10, bean.getCar_no					());
			pstmt1.setString(11, bean.getCar_nm					());
			pstmt1.setString(12, bean.getCons_cau				());
			pstmt1.setString(13, bean.getCost_st					());
			pstmt1.setString(14, bean.getPay_st					());
			pstmt1.setString(15, bean.getFrom_st				());
			pstmt1.setString(16, bean.getFrom_place			());
			pstmt1.setString(17, bean.getFrom_comp			());
			pstmt1.setString(18, bean.getFrom_title				());
			pstmt1.setString(19, bean.getFrom_man			());
			pstmt1.setString(20, bean.getFrom_tel				());
			pstmt1.setString(21, bean.getFrom_m_tel			());
			pstmt1.setString(22, bean.getFrom_req_dt			());
			pstmt1.setString(23, bean.getFrom_est_dt			());
			pstmt1.setString(24, bean.getFrom_dt				());
			pstmt1.setString(25, bean.getTo_st					());
			pstmt1.setString(26, bean.getTo_place				());
			pstmt1.setString(27, bean.getTo_comp				());
			pstmt1.setString(28, bean.getTo_title					());
			pstmt1.setString(29, bean.getTo_man					());
			pstmt1.setString(30, bean.getTo_tel	   	 			());
			pstmt1.setString(31, bean.getTo_m_tel				());
			pstmt1.setString(32, bean.getTo_req_dt				());
			pstmt1.setString(33, bean.getTo_est_dt				());
			pstmt1.setString(34, bean.getTo_dt					());
			pstmt1.setString(35, bean.getDriver_nm				());
			pstmt1.setString(36, bean.getDriver_m_tel			());
			pstmt1.setString(37, bean.getWash_yn    			());
			pstmt1.setString(38, bean.getOil_yn     				());
			pstmt1.setInt     (39, bean.getOil_liter  				());
			pstmt1.setInt     (40, bean.getOil_est_amt			());
			pstmt1.setString(41, bean.getEtc						());
			pstmt1.setInt     (42, bean.getCons_amt				());
			pstmt1.setInt     (43, bean.getWash_amt			());
			pstmt1.setInt     (44, bean.getOil_amt				());
			pstmt1.setString(45, bean.getOther					());
			pstmt1.setInt     (46, bean.getOther_amt			());
			pstmt1.setInt     (47, bean.getTot_amt				());
			pstmt1.setString(48, bean.getPay_dt					());
			pstmt1.setString(49, bean.getReq_dt					());
			pstmt1.setString(50, bean.getCons_cau_etc		());
			pstmt1.setString(51, bean.getReq_code				());
			pstmt1.setInt     (52, bean.getCust_amt				());
			pstmt1.setString(53, bean.getCust_pay_dt			());
			pstmt1.setString(54, bean.getCons_copy			());
			pstmt1.setString(55, bean.getCmp_app				());
			pstmt1.setInt     (56, bean.getTot_dist				());
			pstmt1.setString(57, bean.getReq_id					());
			pstmt1.setString(58, bean.getHipass_yn				());
			pstmt1.setInt     (59, bean.getOil_card_amt		());
			pstmt1.setInt     (60, bean.getHipass_amt			());
			pstmt1.setString(61, bean.getAgent_emp_id		());
			pstmt1.setString(62, bean.getSub_l_cd		());
			pstmt1.setInt		(63, bean.getWash_fee				());
			pstmt1.setInt		(64, bean.getWash_card_amt			());
			pstmt1.setInt		(65, bean.getCons_other_amt			());
			pstmt1.setInt		(66, bean.getEtc1_amt			());
			pstmt1.setInt		(67, bean.getEtc2_amt			());
			pstmt1.setString(68, bean.getCons_no				());
			pstmt1.setInt   	(69, bean.getSeq						());

			pstmt1.executeUpdate();	
			pstmt1.close();
			
			if(!query_oksms.equals("")){
				pstmt2 = conn.prepareStatement(query_oksms);
				
				pstmt2.executeUpdate();
				pstmt2.close();
			
			}

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[ConsignmentDatabase:updateConsignment]\n"+e);

			System.out.println("[bean.getCons_st		()]\n"+bean.getCons_st		());
			System.out.println("[bean.getCons_su		()]\n"+bean.getCons_su		());
			System.out.println("[bean.getReg_code		()]\n"+bean.getReg_code		());
			System.out.println("[bean.getOff_id			()]\n"+bean.getOff_id		());
			System.out.println("[bean.getOff_nm			()]\n"+bean.getOff_nm		());
			System.out.println("[bean.getCar_mng_id		()]\n"+bean.getCar_mng_id	());
			System.out.println("[bean.getRent_mng_id	()]\n"+bean.getRent_mng_id	());
			System.out.println("[bean.getRent_l_cd		()]\n"+bean.getRent_l_cd	());
			System.out.println("[bean.getClient_id		()]\n"+bean.getClient_id	());
			System.out.println("[bean.getCar_no			()]\n"+bean.getCar_no		());
		/*	System.out.println("[bean.getCar_nm			()]\n"+bean.getCar_nm		());
			System.out.println("[bean.getCons_cau		()]\n"+bean.getCons_cau		());
			System.out.println("[bean.getCost_st		()]\n"+bean.getCost_st		());
			System.out.println("[bean.getPay_st			()]\n"+bean.getPay_st		());
			System.out.println("[bean.getFrom_st		()]\n"+bean.getFrom_st		());
			System.out.println("[bean.getFrom_place		()]\n"+bean.getFrom_place	());
			System.out.println("[bean.getFrom_comp		()]\n"+bean.getFrom_comp	());
			System.out.println("[bean.getFrom_title		()]\n"+bean.getFrom_title	());
			System.out.println("[bean.getFrom_man		()]\n"+bean.getFrom_man		());
			System.out.println("[bean.getFrom_tel		()]\n"+bean.getFrom_tel		());
			System.out.println("[bean.getFrom_m_tel		()]\n"+bean.getFrom_m_tel	());
			System.out.println("[bean.getFrom_req_dt	()]\n"+bean.getFrom_req_dt	());
			System.out.println("[bean.getFrom_est_dt	()]\n"+bean.getFrom_est_dt	());
			System.out.println("[bean.getFrom_dt		()]\n"+bean.getFrom_dt		());
			System.out.println("[bean.getTo_st			()]\n"+bean.getTo_st		());
			System.out.println("[bean.getTo_place		()]\n"+bean.getTo_place		());
			System.out.println("[bean.getTo_comp		()]\n"+bean.getTo_comp		());
			System.out.println("[bean.getTo_title		()]\n"+bean.getTo_title		());
			System.out.println("[bean.getTo_man			()]\n"+bean.getTo_man		());
			System.out.println("[bean.getTo_tel			()]\n"+bean.getTo_tel	    ());
			System.out.println("[bean.getTo_m_tel		()]\n"+bean.getTo_m_tel		());
			System.out.println("[bean.getTo_req_dt		()]\n"+bean.getTo_req_dt	());
			System.out.println("[bean.getTo_est_dt		()]\n"+bean.getTo_est_dt	());
			System.out.println("[bean.getTo_dt			()]\n"+bean.getTo_dt		());
			System.out.println("[bean.getDriver_nm		()]\n"+bean.getDriver_nm	());
			System.out.println("[bean.getDriver_m_tel	()]\n"+bean.getDriver_m_tel	());
			System.out.println("[bean.getWash_yn    	()]\n"+bean.getWash_yn    	());
			System.out.println("[bean.getOil_yn     	()]\n"+bean.getOil_yn     	());
			System.out.println("[bean.getOil_liter  	()]\n"+bean.getOil_liter  	());
			System.out.println("[bean.getOil_est_amt	()]\n"+bean.getOil_est_amt	());
			System.out.println("[bean.getEtc			()]\n"+bean.getEtc			());
			System.out.println("[bean.getCons_amt		()]\n"+bean.getCons_amt		());
			System.out.println("[bean.getWash_amt		()]\n"+bean.getWash_amt		());
			System.out.println("[bean.getOil_amt		()]\n"+bean.getOil_amt		());
			System.out.println("[bean.getOther			()]\n"+bean.getOther		());
			System.out.println("[bean.getOther_amt		()]\n"+bean.getOther_amt	());
			System.out.println("[bean.getTot_amt		()]\n"+bean.getTot_amt		());
			System.out.println("[bean.getPay_dt			()]\n"+bean.getPay_dt		());
			System.out.println("[bean.getReq_dt			()]\n"+bean.getReq_dt		());
			System.out.println("[bean.getCons_cau_etc	()]\n"+bean.getCons_cau_etc	());
			System.out.println("[bean.getReq_code		()]\n"+bean.getReq_code		());
			System.out.println("[bean.getCust_amt		()]\n"+bean.getCust_amt		());
			System.out.println("[bean.getCust_pay_dt	()]\n"+bean.getCust_pay_dt	());
			System.out.println("[bean.getCons_copy		()]\n"+bean.getCons_copy	());
			System.out.println("[bean.getCmp_app		()]\n"+bean.getCmp_app		());
			System.out.println("[bean.getTot_dist		()]\n"+bean.getTot_dist		());
			System.out.println("[bean.getReq_id			()]\n"+bean.getReq_id		());*/
			System.out.println("[bean.getCons_no		()]\n"+bean.getCons_no		());
			System.out.println("[bean.getSeq			()]\n"+bean.getSeq			());

			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		}finally{
			try{
	            if(pstmt1 != null)	pstmt1.close();
	            if(pstmt2 != null)	pstmt2.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	public boolean updateConsignmentReq(String cons_no)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update consignment set req_dt=to_char(sysdate,'YYYYMMDD') where cons_no=?";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);		
			pstmt.setString(1,  cons_no);
			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[ConsignmentDatabase:updateConsignmentReq]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	public boolean updateConsignmentReqDt(String cons_no, String req_dt)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update consignment set req_dt=replace(?,'-','') where cons_no=?";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);		
			pstmt.setString(1,  req_dt);
			pstmt.setString(2,  cons_no);
			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[ConsignmentDatabase:updateConsignmentReqDt]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	public boolean updateConsignmentReqCode(String cons_no, String req_code)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update consignment set req_code=? where cons_no=?";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);		
			pstmt.setString(1,  req_code);
			pstmt.setString(2,  cons_no);
			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[ConsignmentDatabase:updateConsignmentReqCode]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}


	public boolean updateConsignmentConf(String cons_no)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update consignment set conf_dt=sysdate where cons_no=?";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);		
			pstmt.setString(1,  cons_no);
			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[ConsignmentDatabase:updateConsignmentConf]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	public boolean deleteConsignments(String cons_no)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " delete from consignment where cons_no=?";
		String query2 =  " delete from doc_settle where doc_st='2' and doc_id=?";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);		
			pstmt.setString(1,  cons_no);
			pstmt.executeUpdate();	
			
			pstmt = conn.prepareStatement(query2);		
			pstmt.setString(1,  cons_no);
			pstmt.executeUpdate();	

			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[ConsignmentDatabase:deleteConsignments]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	public boolean deleteConsignment(String cons_no)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " delete from consignment where cons_no=?";
		String query2 =  " delete from doc_settle where doc_st='2' and doc_id=?";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);		
			pstmt.setString(1,  cons_no);
			pstmt.executeUpdate();			

			pstmt = conn.prepareStatement(query2);		
			pstmt.setString(1,  cons_no);
			pstmt.executeUpdate();	

			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[ConsignmentDatabase:deleteConsignment]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	public boolean deleteConsignment(String cons_no, int seq)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query1 =  " delete from consignment where cons_no=? and seq=?";
//		String query2 =  " update consignment set cons_su=cons_su-1 where cons_no=?";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query1);		
			pstmt.setString(1,  cons_no);
			pstmt.setInt(2,  seq);
			pstmt.executeUpdate();			

//			pstmt = conn.prepareStatement(query2);		
//			pstmt.setString(1,  cons_no);
//			pstmt.executeUpdate();			

			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[ConsignmentDatabase:deleteConsignment]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}


	//한건 조회
	public ConsignmentBean getConsignmentMM(String seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ConsignmentBean bean = new ConsignmentBean();
		String query = "";
		query = " select * from cons_mm where seq = ?";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, seq);
		   	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{
				bean.setMm_seq			(rs.getString("seq")		==null?"":rs.getString("seq"));
				bean.setReg_id			(rs.getString("reg_id")		==null?"":rs.getString("reg_id"));
				bean.setReg_dt			(rs.getString("reg_dt")		==null?"":rs.getString("reg_dt"));
				bean.setMm_req_nm		(rs.getString("req_nm")		==null?"":rs.getString("req_nm"));
				bean.setMm_car_no1		(rs.getString("car_no1")	==null?"":rs.getString("car_no1"));	
				bean.setMm_car_no2		(rs.getString("car_no2")	==null?"":rs.getString("car_no2"));	
				bean.setMm_content		(rs.getString("content")	==null?"":rs.getString("content"));
				bean.setMm_cons_dt		(rs.getString("cons_dt")	==null?"":rs.getString("cons_dt"));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ConsignmentDatabase:getConsignmentMM]\n"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}				
	}

	public String insertConsignmentMM(ConsignmentBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		String seq = "";

		String qry_id = " select nvl(ltrim(to_char(to_number(max(seq)+1), '000000')), '000001') seq"+
						" from cons_mm "+
						" ";

		String query =  " insert into cons_mm "+
						" ( seq, reg_id, reg_dt, content, car_no1, car_no2, req_nm, cons_dt "+
						" ) values "+
						" ( ?, ?, to_char(sysdate,'YYYYMMDD'), ?, ?, ?, ?, replace(?,'-','') "+
						" )";

		try
		{
			conn.setAutoCommit(false);
			pstmt1 = conn.prepareStatement(qry_id);
		   	rs = pstmt1.executeQuery();
			if(rs.next())
			{
				seq = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt1.close();
			conn.commit();
		}catch(Exception e){					
	        try{
				System.out.println("[ConsignmentDatabase:insertConsignmentMM]"+e);
	            conn.rollback();
				e.printStackTrace();	
				flag = false;
	        }catch(SQLException _ignored){}
		}finally{
			try{
                if(rs != null )		rs.close();
	            if(pstmt1 != null)	pstmt1.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
		}

		try
		{
			conn.setAutoCommit(false);

			pstmt2 = conn.prepareStatement(query);
			
			pstmt2.setString(1,  seq					  );
			pstmt2.setString(2,  bean.getReg_id			());
			pstmt2.setString(3,  bean.getMm_content		());
			pstmt2.setString(4,  bean.getMm_car_no1		());
			pstmt2.setString(5,  bean.getMm_car_no2		());
			pstmt2.setString(6,  bean.getMm_req_nm		());
			pstmt2.setString(7,  bean.getMm_cons_dt		());

			pstmt2.executeUpdate();			
			pstmt2.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[ConsignmentDatabase:insertConsignmentMM]\n"+e);
			e.printStackTrace();
	  		flag = false;
			seq = "";
			conn.rollback();
		}finally{
			try{
	            if(pstmt2 != null)	pstmt2.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return seq;
		}
	}

	public boolean updateConsignmentMM(ConsignmentBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update cons_mm set "+
						"	content			= ?, "+
						"	car_no1			= ?, "+
						"	car_no2			= ?, "+
						"	req_nm			= ?, "+
						"	cons_dt			= replace(?,'-','')  "+
						" where seq=?";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1,  bean.getMm_content		());
			pstmt.setString(2,  bean.getMm_car_no1		());
			pstmt.setString(3,  bean.getMm_car_no2		());
			pstmt.setString(4,  bean.getMm_req_nm		());
			pstmt.setString(5,  bean.getMm_cons_dt		());
			pstmt.setString(6,  bean.getMm_seq			());

			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[ConsignmentDatabase:updateConsignmentMM]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	public boolean deleteConsignmentMM(ConsignmentBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " delete from cons_mm "+
						" where seq=?";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1,  bean.getMm_seq			());

			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[ConsignmentDatabase:deleteConsignmentMM]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}


	/**
	 * 아마존카 조회
	 */	
	public Vector getPlaceSearch1(String s_br, String s_kd, String t_wd, boolean isCapital)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";
		String where = "";

		query = " select * from"+
				" (select"+
				" '사무실' gubun, br_nm as nm, br_addr as addr, br_nm as mng_off, tel ";
		
		if(isCapital){
			query += ", CASE WHEN br_nm='영남주차장 사무실' THEN '1' ELSE '0' END isCapital";
		}
				
		query	 += " from branch where use_yn='Y'"+
				" union all"+
				" select"+
				" '차고지' gubun, a.shed_nm as nm, a.lend_addr as addr, b.br_nm as mng_off, b.tel ";
		
		if(isCapital){
			query += ", CASE WHEN shed_nm='영남주차장 사무실' THEN '1' ELSE '0' END isCapital";
		}
		
		query += " from car_shed a, branch b where a.use_yn='Y' and a.mng_off=b.br_id(+))";
	
		if(s_kd.equals("1"))		query += " where nm like '%"+t_wd+"%'";

		if(s_kd.equals("1"))		{
			query += " order by ";
			if(isCapital){
				query += " isCapital desc, ";
			}
			query += " gubun, nm";
		}

//System.out.println("[ConsignmentDatabase:getPlaceSearch1]\n"+query);

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
			System.out.println("[ConsignmentDatabase:getPlaceSearch1]\n"+e);
			System.out.println("[ConsignmentDatabase:getPlaceSearch1]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 * 고객 조회
	 */	
	public Vector getPlaceSearch2(String s_br, String s_kd, String t_wd, String chk_client)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "", query3 = "", query4 = "", query5 = "", query6 = "", query7 = "";
		String where = "";

		
		if(!t_wd.equals("") ) {			
			if(!chk_client.equals("") ) {
				where = " where c.client_id = '" + chk_client + "' and  b.firm_nm like '%"+t_wd+"%' ";
		  }
	     else {
	     			where = " where b.firm_nm like '%"+t_wd+"%' ";
	     }	     
	  }   		
		
		query1 = " select nvl(c.use_yn, 'Y')  use_yn, b.firm_nm, b.client_nm, b.m_tel, b.client_id, '사업장주소' gubun, b.o_addr as addr, b.o_tel as tel, '대표자' title, "
				+ " d.mgr_st AS mgr_st1, d.mgr_nm AS mgr_nm1, d.mgr_title AS mgr_title1, d.mgr_m_tel mgr_m_tel1, d.mgr_tel mgr_tel1, e.mgr_st AS mgr_st2, e.mgr_nm AS mgr_nm2, e.mgr_title AS mgr_title2, e.mgr_m_tel mgr_m_tel2, e.mgr_tel mgr_tel2 "
				+ " from client b, cont c, (SELECT * FROM car_mgr WHERE mgr_st = '차량이용자') d,	(SELECT * FROM car_mgr WHERE mgr_st = '차량관계자') e "
				+ where
				+ " and b.o_addr is not null and b.client_id = c.client_id AND c.rent_l_cd = d.rent_l_cd(+) AND c.rent_l_cd = e.rent_l_cd(+) and c.rent_l_cd not like 'RM%'  ";

		query2 = " select  nvl(c.use_yn, 'Y')  use_yn,   b.firm_nm, b.client_nm, b.m_tel, b.client_id, '본점주소' gubun, b.ho_addr as addr, b.o_tel as tel, '대표자' title, "
				+ " d.mgr_st AS mgr_st1, d.mgr_nm AS mgr_nm1, d.mgr_title AS mgr_title1, d.mgr_m_tel mgr_m_tel1, d.mgr_tel mgr_tel1, e.mgr_st AS mgr_st2, e.mgr_nm AS mgr_nm2, e.mgr_title AS mgr_title2, e.mgr_m_tel mgr_m_tel2, e.mgr_tel mgr_tel2 "
				+ " from client b , cont c, (SELECT * FROM car_mgr WHERE mgr_st = '차량이용자') d,	(SELECT * FROM car_mgr WHERE mgr_st = '차량관계자') e "
				+ where
				+ " and b.ho_addr is not null and b.o_addr<>b.ho_addr  and b.client_id = c.client_id AND c.rent_l_cd = d.rent_l_cd(+) AND c.rent_l_cd = e.rent_l_cd(+)  and c.rent_l_cd not like 'RM%' ";

		query3 = " select  nvl(c.use_yn, 'Y')  use_yn,  b.firm_nm, b.client_nm, b.m_tel, b.client_id, '대표자주소' gubun, b.repre_addr as addr, b.o_tel as tel, '대표자' title, "
				+ " d.mgr_st AS mgr_st1, d.mgr_nm AS mgr_nm1, d.mgr_title AS mgr_title1, d.mgr_m_tel mgr_m_tel1, d.mgr_tel mgr_tel1, e.mgr_st AS mgr_st2, e.mgr_nm AS mgr_nm2, e.mgr_title AS mgr_title2, e.mgr_m_tel mgr_m_tel2, e.mgr_tel mgr_tel2 "
				+ " from client b , cont c, (SELECT * FROM car_mgr WHERE mgr_st = '차량이용자') d, (SELECT * FROM car_mgr WHERE mgr_st = '차량관계자') e "
				+ where
				+ " and b.repre_addr is not null and b.client_id = c.client_id AND c.rent_l_cd = d.rent_l_cd(+) AND c.rent_l_cd = e.rent_l_cd(+) and c.rent_l_cd not like 'RM%' ";

		query4 = " select  nvl(c.use_yn, 'Y')  use_yn,  b.firm_nm, b.client_nm, b.m_tel, b.client_id, '직장주소' gubun, b.comm_addr||' '||b.com_nm as addr, b.m_tel as tel, '계약자' title, "
				+ " d.mgr_st AS mgr_st1, d.mgr_nm AS mgr_nm1, d.mgr_title AS mgr_title1, d.mgr_m_tel mgr_m_tel1, d.mgr_tel mgr_tel1, e.mgr_st AS mgr_st2, e.mgr_nm AS mgr_nm2, e.mgr_title AS mgr_title2, e.mgr_m_tel mgr_m_tel2, e.mgr_tel mgr_tel2 "
				+ " from client b , cont c, (SELECT * FROM car_mgr WHERE mgr_st = '차량이용자') d, (SELECT * FROM car_mgr WHERE mgr_st = '차량관계자') e "
				+ where
				+ " and b.comm_addr is not null  and b.client_id = c.client_id AND c.rent_l_cd = d.rent_l_cd(+) AND c.rent_l_cd = e.rent_l_cd(+)  and c.rent_l_cd not like 'RM%' ";

		query5 = " select  nvl(c.use_yn, 'Y')  use_yn,  b.firm_nm, nvl(a.site_jang,a.r_site) as client_nm, b.m_tel, b.client_id, '지점주소' gubun, a.addr||' '||a.r_site as addr, a.tel as tel, '지점' title, "
				+ " d.mgr_st AS mgr_st1, d.mgr_nm AS mgr_nm1, d.mgr_title AS mgr_title1, d.mgr_m_tel mgr_m_tel1, d.mgr_tel mgr_tel1, e.mgr_st AS mgr_st2, e.mgr_nm AS mgr_nm2, e.mgr_title AS mgr_title2, e.mgr_m_tel mgr_m_tel2, e.mgr_tel mgr_tel2 "
				+ " from client_site a, client b , cont c, (SELECT * FROM car_mgr WHERE mgr_st = '차량이용자') d,	(SELECT * FROM car_mgr WHERE mgr_st = '차량관계자') e "
				+ where
				+ " and a.client_id=b.client_id and a.addr is not null  and b.client_id = c.client_id  AND c.rent_l_cd = d.rent_l_cd(+) AND c.rent_l_cd = e.rent_l_cd(+) and c.rent_l_cd not like 'RM%' ";

//		query6 = " select distinct  nvl(c.use_yn, 'Y')  use_yn,  b.firm_nm, nvl(a.tax_agnt,b.client_nm) client_nm, b.m_tel, b.client_id, '우편물주소' gubun, a.p_addr as addr, b.o_tel as tel, '우편수령자' title from cont a, client b "+where+" and a.client_id=b.client_id and nvl(a.use_yn,'Y')='Y' and a.p_addr is not null";

//		query7 = " select distinct  nvl(c.use_yn, 'Y')  use_yn,  b.firm_nm, b.client_nm, c.mgr_m_tel m_tel, b.client_id, '차량이용자주소' gubun, c.mgr_addr as addr, c.mgr_tel as tel, '차량이용자' title from cont a, client b, car_mgr c "+where+" and a.client_id=b.client_id and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and nvl(a.use_yn,'Y')='Y' and c.mgr_st='차량이용자' and c.mgr_addr is not null and nvl(c.use_yn,'Y')='Y' ";

	//	query = query1+" union all "+query2+" union all "+query3+" union all "+query4+" union all "+query5+" union all "+query6+" union all "+query7  + "  order by 1" ;

		query = query1+" union all "+query2+" union all "+query3+" union all "+query4+" union all "+query5+"  order by 1 desc " ;

		if(s_kd.equals("2")){

			if(!t_wd.equals(""))		where = " where c.car_no like '%"+t_wd+"%' ";
			
			query1 = " select distinct '' use_yn, b.firm_nm, b.client_nm, b.m_tel, b.client_id, '단기' gubun, b.o_addr as addr, b.o_tel as tel, '대표자' title from rent_cont a, client b, car_reg c "+where+" and a.car_mng_id=c.car_mng_id and a.cust_id=b.client_id and b.o_addr is not null";

			query2 = " select distinct  '' use_yn, b.firm_nm, b.client_nm, b.m_tel, b.client_id, '장기' gubun, b.o_addr as addr, b.o_tel as tel, '대표자' title from cont a, client b, car_reg c "+where+" and a.car_mng_id=c.car_mng_id and a.client_id=b.client_id and b.o_addr is not null";

			query = query1+" union all "+query2 + "  " ;


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
			System.out.println("[ConsignmentDatabase:getPlaceSearch2]\n"+e);
			System.out.println("[ConsignmentDatabase:getPlaceSearch2]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}


	/**
	 * 고객 조회
	 */	
	public Vector getPlaceSearch2(String s_br, String s_kd, String t_wd )
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "", query3 = "", query4 = "", query5 = "", query6 = "", query7 = "";
		String where = "";

		if(!t_wd.equals(""))		where = " where b.firm_nm like '%"+t_wd+"%' ";

		query1 = " select nvl(c.use_yn, 'Y')  use_yn, b.firm_nm, b.client_nm, b.m_tel, b.client_id, '사업장주소' gubun, b.o_addr as addr, b.o_tel as tel, '대표자' title from client b, cont c "+where+" and b.o_addr is not null and b.client_id = c.client_id  and c.rent_l_cd not like 'RM%'  ";

		query2 = " select  nvl(c.use_yn, 'Y')  use_yn,   b.firm_nm, b.client_nm, b.m_tel, b.client_id, '본점주소' gubun, b.ho_addr as addr, b.o_tel as tel, '대표자' title from client b , cont c "+where+" and b.ho_addr is not null and b.o_addr<>b.ho_addr  and b.client_id = c.client_id  and c.rent_l_cd not like 'RM%' ";

		query3 = " select  nvl(c.use_yn, 'Y')  use_yn,  b.firm_nm, b.client_nm, b.m_tel, b.client_id, '대표자주소' gubun, b.repre_addr as addr, b.o_tel as tel, '대표자' title from client b , cont c "+where+" and b.repre_addr is not null and b.client_id = c.client_id  and c.rent_l_cd not like 'RM%' ";

		query4 = " select  nvl(c.use_yn, 'Y')  use_yn,  b.firm_nm, b.client_nm, b.m_tel, b.client_id, '직장주소' gubun, b.comm_addr||' '||com_nm as addr, b.m_tel as tel, '계약자' title from client b , cont c  "+where+" and b.comm_addr is not null  and b.client_id = c.client_id  and c.rent_l_cd not like 'RM%' ";

		query5 = " select  nvl(c.use_yn, 'Y')  use_yn,  b.firm_nm, nvl(a.site_jang,a.r_site) as client_nm, b.m_tel, b.client_id, '지점주소' gubun, a.addr||' '||a.r_site as addr, a.tel as tel, '지점' title from client_site a, client b , cont c "+where+" and a.client_id=b.client_id and a.addr is not null  and b.client_id = c.client_id  and c.rent_l_cd not like 'RM%' ";

//		query6 = " select distinct  nvl(c.use_yn, 'Y')  use_yn,  b.firm_nm, nvl(a.tax_agnt,b.client_nm) client_nm, b.m_tel, b.client_id, '우편물주소' gubun, a.p_addr as addr, b.o_tel as tel, '우편수령자' title from cont a, client b "+where+" and a.client_id=b.client_id and nvl(a.use_yn,'Y')='Y' and a.p_addr is not null";

//		query7 = " select distinct  nvl(c.use_yn, 'Y')  use_yn,  b.firm_nm, b.client_nm, c.mgr_m_tel m_tel, b.client_id, '차량이용자주소' gubun, c.mgr_addr as addr, c.mgr_tel as tel, '차량이용자' title from cont a, client b, car_mgr c "+where+" and a.client_id=b.client_id and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and nvl(a.use_yn,'Y')='Y' and c.mgr_st='차량이용자' and c.mgr_addr is not null and nvl(c.use_yn,'Y')='Y' ";

	//	query = query1+" union all "+query2+" union all "+query3+" union all "+query4+" union all "+query5+" union all "+query6+" union all "+query7  + "  order by 1" ;

		query = query1+" union all "+query2+" union all "+query3+" union all "+query4+" union all "+query5+"  order by 1 desc " ;

		if(s_kd.equals("2")){

			if(!t_wd.equals(""))		where = " where c.car_no like '%"+t_wd+"%' ";
			
			query1 = " select distinct '' use_yn, b.firm_nm, b.client_nm, b.m_tel, b.client_id, '단기' gubun, b.o_addr as addr, b.o_tel as tel, '대표자' title from rent_cont a, client b, car_reg c "+where+" and a.car_mng_id=c.car_mng_id and a.cust_id=b.client_id and b.o_addr is not null";

			query2 = " select distinct  '' use_yn, b.firm_nm, b.client_nm, b.m_tel, b.client_id, '장기' gubun, b.o_addr as addr, b.o_tel as tel, '대표자' title from cont a, client b, car_reg c "+where+" and a.car_mng_id=c.car_mng_id and a.client_id=b.client_id and b.o_addr is not null";

			query = query1+" union all "+query2 + "  " ;


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
			System.out.println("[ConsignmentDatabase:getPlaceSearch2]\n"+e);
			System.out.println("[ConsignmentDatabase:getPlaceSearch2]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 * 고객 조회
	 */	
	public Vector getPlaceSearch2Agent(String s_br, String s_kd, String t_wd, String user_id )
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "", query3 = "", query4 = "", query5 = "", query6 = "", query7 = "";
		String where = "";
                           //대여차량
		where = "	,	 ( SELECT '1' AS st, car_gu, rent_mng_id, rent_l_cd, car_mng_id, client_id, rent_start_dt, rent_end_dt FROM CONT WHERE bus_id='"+user_id+"' \n"+
                "          UNION all \n"+
					       //출고지연차량
                "          SELECT '2' AS st, '0' car_gu, c.rent_mng_id, c.rent_l_cd, c.car_mng_id, a.client_id, b.car_rent_st as rent_start_dt, b.car_rent_et as rent_end_dt FROM CONT a, TAECHA b, CONT c WHERE a.BUS_ID='"+user_id+"' AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd AND b.car_mng_id=c.car_mng_id AND c.car_st='2' \n"+
                "          UNION all \n"+
					       //대차계약원차량
                "          SELECT '3' AS st, c.car_gu, c.rent_mng_id, c.rent_l_cd, c.car_mng_id, c.client_id, c.rent_start_dt, c.rent_end_dt FROM CONT a, CONT_ETC b, CONT c WHERE a.BUS_ID='"+user_id+"' AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd AND b.grt_suc_m_id=c.rent_mng_id AND b.grt_suc_l_cd=c.rent_l_cd \n"+
                "          UNION all \n"+
					       //영업사원계약 영업담당 차량
				"          SELECT '4' AS st, a.car_gu, a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.rent_start_dt, a.rent_end_dt FROM CONT a, COMMI b, USERS c WHERE a.BUS_ID<>'"+user_id+"' AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd AND b.agnt_st='1' AND b.emp_id=c.sa_code and c.user_id='"+user_id+"' \n"+
                "        ) d "+
				"        where b.client_id=d.client_id \n";

		if(!t_wd.equals(""))		where += " and b.firm_nm like '%"+t_wd+"%' ";

		query1 = " select nvl(c.use_yn, 'Y')  use_yn, b.firm_nm, b.client_nm, b.m_tel, b.client_id, '사업장주소' gubun, b.o_addr as addr, b.o_tel as tel, '대표자' title, "
				+ " e.mgr_st AS mgr_st1, e.mgr_nm AS mgr_nm1, e.mgr_title AS mgr_title1, e.mgr_m_tel mgr_m_tel1, e.mgr_tel mgr_tel1, f.mgr_st AS mgr_st2, f.mgr_nm AS mgr_nm2, f.mgr_title AS mgr_title2, f.mgr_m_tel mgr_m_tel2, f.mgr_tel mgr_tel2 "
				+ "from client b, cont c "
				+ " , (SELECT * FROM car_mgr WHERE mgr_st = '차량이용자') e,	(SELECT * FROM car_mgr WHERE mgr_st = '차량관계자') f "
				+ where
				+ " and b.o_addr is not null and b.client_id = c.client_id  AND c.rent_l_cd = e.rent_l_cd(+) AND c.rent_l_cd = f.rent_l_cd(+) and c.rent_l_cd not like 'RM%'  ";

		query2 = " select  nvl(c.use_yn, 'Y')  use_yn,   b.firm_nm, b.client_nm, b.m_tel, b.client_id, '본점주소' gubun, b.ho_addr as addr, b.o_tel as tel, '대표자' title, "
				+ " e.mgr_st AS mgr_st1, e.mgr_nm AS mgr_nm1, e.mgr_title AS mgr_title1, e.mgr_m_tel mgr_m_tel1, e.mgr_tel mgr_tel1, f.mgr_st AS mgr_st2, f.mgr_nm AS mgr_nm2, f.mgr_title AS mgr_title2, f.mgr_m_tel mgr_m_tel2, f.mgr_tel mgr_tel2 "
				+ " from client b , cont c "
				+ " , (SELECT * FROM car_mgr WHERE mgr_st = '차량이용자') e,	(SELECT * FROM car_mgr WHERE mgr_st = '차량관계자') f "
				+ where
				+ " and b.ho_addr is not null and b.o_addr<>b.ho_addr  and b.client_id = c.client_id  AND c.rent_l_cd = e.rent_l_cd(+) AND c.rent_l_cd = f.rent_l_cd(+) and c.rent_l_cd not like 'RM%' ";

		query3 = " select  nvl(c.use_yn, 'Y')  use_yn,  b.firm_nm, b.client_nm, b.m_tel, b.client_id, '대표자주소' gubun, b.repre_addr as addr, b.o_tel as tel, '대표자' title, "
				+ " e.mgr_st AS mgr_st1, e.mgr_nm AS mgr_nm1, e.mgr_title AS mgr_title1, e.mgr_m_tel mgr_m_tel1, e.mgr_tel mgr_tel1, f.mgr_st AS mgr_st2, f.mgr_nm AS mgr_nm2, f.mgr_title AS mgr_title2, f.mgr_m_tel mgr_m_tel2, f.mgr_tel mgr_tel2 "
				+ " from client b , cont c "
				+ " , (SELECT * FROM car_mgr WHERE mgr_st = '차량이용자') e,	(SELECT * FROM car_mgr WHERE mgr_st = '차량관계자') f "
				+ where
				+ " and b.repre_addr is not null and b.client_id = c.client_id  AND c.rent_l_cd = e.rent_l_cd(+) AND c.rent_l_cd = f.rent_l_cd(+) and c.rent_l_cd not like 'RM%' ";

		query4 = " select  nvl(c.use_yn, 'Y')  use_yn,  b.firm_nm, b.client_nm, b.m_tel, b.client_id, '직장주소' gubun, b.comm_addr||' '||b.com_nm as addr, b.m_tel as tel, '계약자' title, "
				+ " e.mgr_st AS mgr_st1, e.mgr_nm AS mgr_nm1, e.mgr_title AS mgr_title1, e.mgr_m_tel mgr_m_tel1, e.mgr_tel mgr_tel1, f.mgr_st AS mgr_st2, f.mgr_nm AS mgr_nm2, f.mgr_title AS mgr_title2, f.mgr_m_tel mgr_m_tel2, f.mgr_tel mgr_tel2 "
				+ " from client b , cont c  "
				+ " , (SELECT * FROM car_mgr WHERE mgr_st = '차량이용자') e,	(SELECT * FROM car_mgr WHERE mgr_st = '차량관계자') f "
				+ where
				+ " and b.comm_addr is not null  and b.client_id = c.client_id  AND c.rent_l_cd = e.rent_l_cd(+) AND c.rent_l_cd = f.rent_l_cd(+) and c.rent_l_cd not like 'RM%' ";

		query5 = " select  nvl(c.use_yn, 'Y')  use_yn,  b.firm_nm, nvl(a.site_jang,a.r_site) as client_nm, b.m_tel, b.client_id, '지점주소' gubun, a.addr||' '||a.r_site as addr, a.tel as tel, '지점' title, "
				+ " e.mgr_st AS mgr_st1, e.mgr_nm AS mgr_nm1, e.mgr_title AS mgr_title1, e.mgr_m_tel mgr_m_tel1, e.mgr_tel mgr_tel1, f.mgr_st AS mgr_st2, f.mgr_nm AS mgr_nm2, f.mgr_title AS mgr_title2, f.mgr_m_tel mgr_m_tel2, f.mgr_tel mgr_tel2 "
				+ " from client_site a, client b , cont c "
				+ " , (SELECT * FROM car_mgr WHERE mgr_st = '차량이용자') e,	(SELECT * FROM car_mgr WHERE mgr_st = '차량관계자') f "
				+ where
				+ " and a.client_id=b.client_id and a.addr is not null  and b.client_id = c.client_id  AND c.rent_l_cd = e.rent_l_cd(+) AND c.rent_l_cd = f.rent_l_cd(+) and c.rent_l_cd not like 'RM%' ";

		query = query1+" union all "+query2+" union all "+query3+" union all "+query4+" union all "+query5+"  order by 1 desc " ;

		if(s_kd.equals("2")){

			if(!t_wd.equals(""))		where = " where c.car_no like '%"+t_wd+"%' ";
			
			query1 = " select distinct '' use_yn, b.firm_nm, b.client_nm, b.m_tel, b.client_id, '단기' gubun, b.o_addr as addr, b.o_tel as tel, '대표자' title from rent_cont a, client b, car_reg c "+where+" and a.car_mng_id=c.car_mng_id and a.cust_id=b.client_id and b.o_addr is not null";

			query2 = " select distinct  '' use_yn, b.firm_nm, b.client_nm, b.m_tel, b.client_id, '장기' gubun, b.o_addr as addr, b.o_tel as tel, '대표자' title from cont a, client b, car_reg c "+where+" and a.car_mng_id=c.car_mng_id and a.client_id=b.client_id and b.o_addr is not null";

			query = query1+" union all "+query2 + "  " ;


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
			System.out.println("[ConsignmentDatabase:getPlaceSearch2Agent]\n"+e);
			System.out.println("[ConsignmentDatabase:getPlaceSearch2Agent]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	
	/**
	 * 협력업체 조회
	 */	
	public Vector getPlaceSearch3(String s_br, String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";
		String where = "";

		query = " select  "+
				" off_nm, own_nm, ent_no, off_tel, off_addr"+
				" from serv_off"+
				" where nvl(off_type, '1') in ('1','3') and length(ent_no) =10  and off_id not in ( '000620' ) ";  //사용안하는  코드 제외 (명진 과거)

		if(s_kd.equals("1"))		query += " and upper(off_nm) like  upper('%"+ t_wd+ "%') \n"; 
		if(s_kd.equals("2"))		query += " and ent_no like '%"+t_wd+"%'";
		
		if(s_kd.equals("1"))		query += " order by decode(ent_no,'1071167628','000000000',ent_no)";

//	System.out.println("[ConsignmentDatabase:getPlaceSearch3]\n"+query);

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
			System.out.println("[ConsignmentDatabase:getPlaceSearch3]\n"+e);
			System.out.println("[ConsignmentDatabase:getPlaceSearch3]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 * 아마존카 사원 조회
	 */	
	public Vector getManSearch1(String s_br, String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";
		String where = "";

		query = " select"+
				" b.br_nm, c.nm, a.user_id, a.user_nm, a.user_pos, a.hot_tel as user_h_tel, a.user_m_tel"+
				" from users a, branch b, (select * from code where c_st='0002') c"+
				" where a.use_yn='Y' and a.br_id=b.br_id and a.dept_id=c.code"+
				" and a.br_id in ('S1','B1','D1','S2','J1','G1','I1','K3','S3','S4','U1','S5','S6') and a.dept_id not in ('8888','0004')";
	
		if(s_kd.equals("1")){
			if(t_wd.equals("본사")){
				query += " and a.br_id in ('S1','S2')";
			}else{
				query += " and b.br_nm like '%"+t_wd+"%'";
			}

		}
		if(s_kd.equals("2"))		query += " and a.user_nm like '%"+t_wd+"%'";

		if(s_kd.equals("2"))		query += " order by a.user_nm";
		else						query += " order by decode(b.br_nm,'본사','1','부산지점','2','대전지점','3','강남지점','4','광주지점','5','대구지점','6','인천지점','7','수원지점','8'), a.dept_id,"+
											 " decode(a.user_pos,'차장','1','부장','2','과장','3','대리','4','사원','5'), a.enter_dt, a.user_id";


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
			System.out.println("[ConsignmentDatabase:getManSearch1]\n"+e);
			System.out.println("[ConsignmentDatabase:getManSearch1]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 * 탁송지원자 아마존카 사원 조회
	 */	
	public Vector getManSearch4(String s_br, String s_kd, String t_wd, String cons_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";
		String where = "";

		query = " select"+
				" b.br_nm, c.nm, a.user_id, a.user_nm, a.user_pos, a.user_h_tel, a.user_m_tel, decode(d.standby_st,'1','FULL','2','오전','3','오후','') standby_st"+
				" from users a, branch b, (select * from code where c_st='0002') c, (select * from cons_standby where standby_dt=replace('"+cons_dt+"','-','')) d"+
				" where a.use_yn='Y' and a.br_id=b.br_id and a.dept_id=c.code and a.user_id=d.user_id(+)"+
				" and a.br_id in ('S1','B1','D1','S2','J1','G1','I1','K3','S3','S4','U1','S5','S6') and a.dept_id not in ('8888','0004') "+
				" and (a.loan_st is not null or a.user_id in ('000031','000038','000122','000124','000121'))"+ //1군,2군,이의상,박영식,우태종,이판귀,최은숙
				" ";
	
		if(s_kd.equals("1"))		query += " and b.br_nm like '%"+t_wd+"%'";
		if(s_kd.equals("2"))		query += " and a.user_nm like '%"+t_wd+"%'";

//		if(s_kd.equals("2"))		query += " order by a.user_nm";
								query += " order by decode(b.br_nm,'본사','1','부산지점','2','대전지점','3','강남지점','4','광주지점','5','대구지점','6'), a.dept_id,"+
											 " decode(a.user_pos,'차장','1','부장','2','과장','3','대리','4','사원','5'), a.enter_dt, a.user_id";


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
			System.out.println("[ConsignmentDatabase:getManSearch4]\n"+e);
			System.out.println("[ConsignmentDatabase:getManSearch4]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 * 고객 사원 조회 - 해지된 계약  제외 
	 */	
	public Vector getManSearch2(String s_br, String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "", query3 = "", query4 = "", query5 = "", query6 = "";
		String where = "";

		if(s_kd.equals("1") && !t_wd.equals(""))		where += " where b.firm_nm like '%"+t_wd+"%' ";
		if(s_kd.equals("3") && !t_wd.equals(""))		where += " where b.client_id in (select client_id from cont where rent_l_cd='"+t_wd+"') ";

		//query1 = " select '계약자' gubun, b.client_nm nm, '대표이사' title, b.o_tel tel, b.m_tel from client b , cont c  "+where+" and b.client_st<>'2' and b.client_id = c.client_id and and nvl(c.use_yn,'Y')='Y' ";
		query1 = " select '계약자' gubun, b.client_nm nm, '대표이사' title, b.o_tel tel, b.m_tel from client b , cont c  "+where+" and b.client_id = c.client_id and nvl(c.use_yn,'Y')='Y' ";

		query2 = " select '세금계산서' gubun, b.con_agnt_nm nm, b.con_agnt_dept||' '||b.con_agnt_title title, b.con_agnt_o_tel tel, b.con_agnt_m_tel m_tel from client b , cont c "+where+" and b.con_agnt_nm is not null  and b.client_id = c.client_id and nvl(c.use_yn,'Y')='Y' ";

		query3 = " select '지점' gubun, a.site_jang nm, '지점장' title, a.tel tel, '' m_tel from client_site a, client b , cont c  "+where+" and a.client_id=b.client_id and a.site_jang is not null   and b.client_id = c.client_id and nvl(c.use_yn,'Y')='Y' ";

		query4 = " select '세금계산서' gubun, a.agnt_nm nm, a.agnt_dept||' '||a.agnt_title title, a.tel tel, a.agnt_m_tel m_tel from client_site a, client b , cont c "+where+" and a.client_id=b.client_id and a.site_jang is not null  and b.client_id = c.client_id and nvl(c.use_yn,'Y')='Y' ";

	//	query5 = " select distinct c.mgr_st gubun, c.mgr_nm nm, c.mgr_dept||' '||c.mgr_title title, c.mgr_tel tel, c.mgr_m_tel m_tel from cont a, client b, car_mgr c "+where+" and a.client_id=b.client_id and nvl(a.use_yn,'Y')='Y' and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and c.mgr_nm is not null ";

		if(s_kd.equals("3") && !t_wd.equals(""))		query5 += " and a.rent_l_cd ='"+t_wd+"' ";

	//	query = query1+" union all "+query2+" union all "+query3+" union all "+query4+" union all "+query5;
		query = query1+" union all "+query2+" union all "+query3+" union all "+query4 ;


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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ConsignmentDatabase:getManSearch2]\n"+e);
			System.out.println("[ConsignmentDatabase:getManSearch2]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 * 고객 사원 조회
	 */	
	public Vector getManSearch2(String s_br, String s_kd, String t_wd, String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "", query3 = "", query4 = "", query5 = "", query6 = "";
		String where = "";

		if(s_kd.equals("1") && !t_wd.equals(""))		where += " where b.firm_nm like '%"+t_wd+"%' ";
		if(s_kd.equals("3") && !t_wd.equals(""))		where += " where b.client_id in (select client_id from cont where rent_l_cd='"+t_wd+"') ";
		if(s_kd.equals("2") && !t_wd.equals(""))		where += " where b.client_id in (select a.client_id from cont a, car_reg b where b.car_no like '%"+t_wd+"%' and a.car_mng_id=b.car_mng_id and a.car_st in ('1','3') and a.rent_l_cd not like 'RM%' and nvl(a.use_yn,'Y')='Y' ) ";

		//query1 = " select '1' seq, '' car_no, '계약자' gubun, b.client_nm nm, '대표이사' title, b.o_tel tel, b.m_tel from client b  "+where+" and b.client_st<>'2'";
		query1 = " select '5' seq, '' car_no, '계약자' gubun, b.client_nm nm, '대표이사' title, b.o_tel tel, b.m_tel from client b  "+where;

		query2 = " select '1' seq, '' car_no, '세금계산서' gubun, b.con_agnt_nm nm, b.con_agnt_dept||' '||b.con_agnt_title title, b.con_agnt_o_tel tel, b.con_agnt_m_tel m_tel from client b "+where+" and b.con_agnt_nm is not null";

		query3 = " select '2' seq, '' car_no, '지점' gubun, a.site_jang nm, '지점장' title, a.tel tel, '' m_tel from client_site a, client b "+where+" and a.client_id=b.client_id and a.site_jang is not null";

		query4 = " select '3' seq, '' car_no, '지점계산서' gubun, a.agnt_nm nm, a.agnt_dept||' '||a.agnt_title title, a.tel tel, a.agnt_m_tel m_tel from client_site a, client b "+where+" and a.client_id=b.client_id and a.site_jang is not null";

		query5 = " select '4' seq, d.car_no, c.mgr_st gubun, c.mgr_nm nm, c.mgr_dept||' '||c.mgr_title title, c.mgr_tel tel, c.mgr_m_tel m_tel from cont a, client b, car_mgr c, car_reg d "+where+" and a.client_id=b.client_id and nvl(a.use_yn,'Y')='Y' and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and c.mgr_nm is not null and a.car_mng_id=d.car_mng_id(+) and a.rent_l_cd<>'"+rent_l_cd+"'";

		if(s_kd.equals("2") && !t_wd.equals(""))		query5 += " and d.car_no like '%"+t_wd+"%' ";		
		if(s_kd.equals("3") && !t_wd.equals(""))		query5 += " and a.rent_l_cd ='"+t_wd+"' ";

		query = " select * from ( "+query1+" union all "+query2+" union all "+query3+" union all "+query4+" union all "+query5+ ") order by seq, car_no " ;


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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

//			System.out.println("[ConsignmentDatabase:getManSearch2]\n"+query);
		} catch (SQLException e) {
			System.out.println("[ConsignmentDatabase:getManSearch2]\n"+e);
			System.out.println("[ConsignmentDatabase:getManSearch2]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 * 협력업체 운전자 조회
	 */	
	public Vector getManSearch3(String s_br, String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select distinct '운전자' gubun, driver_nm  nm, '' title, '' tel, replace(driver_m_tel,'-','') as m_tel from consignment where driver_nm is not null and substr(from_req_dt,1,8) > to_char(add_months(sysdate,-1),'YYYYMMDD')";

		if(!t_wd.equals("")){
			if(t_wd.equals("에프앤티코리아(부산)"))		query += "and (off_nm like '일등전국탁송(부산)' or off_nm like '"+t_wd+"%')";
			else if(t_wd.equals("에프앤티코리아(광주)"))	query += "and (off_nm like '일등전국탁송(광주)' or off_nm like '"+t_wd+"%')";
			else if(t_wd.equals("에프앤티코리아(대구)"))	query += "and (off_nm like '일등전국탁송(대구)' or off_nm like '"+t_wd+"%')";
			else									query += " and off_nm like '"+t_wd+"%'";
		}

		query += " order by driver_nm";


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
			System.out.println("[ConsignmentDatabase:getManSearch3]\n"+e);
			System.out.println("[ConsignmentDatabase:getManSearch3]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		

	}


	//미수신현황 리스트 조회
	public Vector getConsignmentRecList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String st_dt, String end_dt, String sort)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select "+
				" a.cons_no, max ( decode ( a.seq, '1', a.car_no ) ) car_no,  min(a.off_nm) off_nm, decode(min(a.after_yn),'Y','사후입력') after_yn, decode(min(a.f_man),'Y','신차') f_man, decode(min(a.d_man),'Y','신차') d_man, decode(min(a.cons_st),'1','편도','2','왕복') as cons_st, min(a.cons_su) cons_su, min(c.user_nm) user_nm1, min(d.user_nm) user_nm2, min(b.user_dt1) req_dt, min(a.from_req_dt) from_req_dt, min(e.br_id) br_id, min(g.user_nm) mng_nm, min(a.car_nm) car_nm, max ( decode ( a.seq, '1', a.from_place ) ) from_place, max ( decode ( a.seq, '1', a.TO_PLACE ) ) to_place "+
				" from consignment a, doc_settle b, users c, users d, branch e, cont f, users g, car_pur i, car_reg j "+
				" where a.cons_no=b.doc_id(+) and b.doc_st='2' and b.user_id1=c.user_id(+) and b.user_id2=d.user_id(+) and c.br_id=e.br_id(+) and a.car_mng_id = f.car_mng_id(+) and a.rent_l_cd = f.rent_l_cd(+) and a.rent_mng_id = f.rent_mng_id(+) AND f.MNG_ID = g.USER_ID(+) AND a.rent_mng_id = i.rent_mng_id(+) AND a.rent_l_cd = i.rent_l_cd(+) AND a.car_mng_id = j.car_mng_id(+) "+
				" and ((a.off_id<>'003158' and b.user_dt2 is null) or (a.off_id='003158' and a.driver_nm is null))";

		String search = "";
		String what = "";
		String dt3 = "";

		if(gubun3.equals("1")){
			dt3		= "a.from_req_dt";
		}else{
			dt3		= "a.reg_dt";
		}

		if(gubun2.equals("1"))			query += " and "+dt3+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))		query += " and "+dt3+" like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun2.equals("4"))		query += " and "+dt3+" like to_char(sysdate+1,'YYYYMMDD')||'%'";
		else if(gubun2.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt3+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt3+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		if(gubun1.equals("일등전국탁송") || gubun1.equals("에프앤티코리아")){
			query += " and ( a.off_nm like '%에프앤티%' or a.off_nm like '%일등전국탁송%') ";
		}else if(gubun1.equals("(주)영원물류") || gubun1.equals("상원물류(주)")){
			query += " and ( a.off_nm like '%(주)영원물류%' or a.off_nm like '%상원물류(주)%') ";
		}else if(!gubun1.equals("")){
			query += " and a.off_nm like '%"+gubun1+"%'";
		}



		if(s_kd.equals("1"))	what = "upper(nvl(e.br_id||e.br_nm, ' '))";	
		if(s_kd.equals("2"))	what = "upper(nvl(c.user_nm, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(a.car_nm, ' '))";	
		if(s_kd.equals("4"))	what = "upper(nvl(a.car_no||i.est_car_no||j.car_no, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(a.from_place||a.to_place||a.from_comp||a.to_comp, ' '))";
			
		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		query += " group by a.cons_no";

		if(sort.equals("1"))	query += " order by min(a.off_nm), decode(min(e.br_id),'S1',1,'B1',2,'D1')";	
		if(sort.equals("2"))	query += " order by min(a.off_nm), min(c.user_nm)";	
		if(sort.equals("6"))	query += " order by min(a.off_nm), min(a.from_req_dt)";	
		if(sort.equals("7"))	query += " order by min(a.off_nm), min(b.user_dt1)";
		//출발지, 도착지 정렬조건 추가
		if(sort.equals("8"))	query += " order by min(a.off_nm), max(decode(a.seq,'1',a.from_place))";	//출발지
		if(sort.equals("9"))	query += " order by min(a.off_nm), max(decode(a.seq,'1',a.TO_PLACE))";		//도착지

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
			System.out.println("[ConsignmentDatabase:getConsignmentRecList]\n"+e);
			System.out.println("[ConsignmentDatabase:getConsignmentRecList]\n"+query);
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

	//미정산현황 리스트 조회
	public Vector getConsignmentSettleList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String st_dt, String end_dt, String sort)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select  h.user_nm as mng_nm, "+
				" a.*, c.user_nm as user_nm1, d.user_nm as user_nm2, b.user_dt1, b.user_dt2, f.nm as cons_cau_nm, decode(a.cons_st,'1','편도','2','왕복') as cons_st_nm"+
				" from consignment a, doc_settle b, users c, users d, branch e, (select * from code where c_st='0015' and code<>'0000') f, cont g, users h, car_pur i, car_reg j "+
				" where a.cons_no=b.doc_id(+) and b.doc_st='2' and b.user_id1=c.user_id(+) and b.user_id2=d.user_id(+) and c.br_id=e.br_id(+) and a.cons_cau=f.nm_cd(+)"+
				" and a.car_mng_id = g.car_mng_id(+) and a.rent_l_cd = g.rent_l_cd(+) and a.rent_mng_id = g.rent_mng_id(+) AND g.MNG_ID = h.USER_ID(+) AND a.rent_mng_id = i.rent_mng_id(+) AND a.rent_l_cd = i.rent_l_cd(+) AND g.car_mng_id = j.car_mng_id(+) and b.user_dt2 is not null "+
				" and b.user_dt3 is null"+
				" and a.off_id<>'003158'"+
				" ";

		String search = "";
		String what = "";
		String dt3 = "";

		if(gubun3.equals("1")){
			dt3		= "a.from_req_dt";
		}else if(gubun3.equals("3")){
			dt3		= "a.from_est_dt";
		}else{
			dt3		= "a.reg_dt";
		}

		if(gubun2.equals("1"))			query += " and "+dt3+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))		query += " and "+dt3+" like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun2.equals("4"))		query += " and "+dt3+" like to_char(sysdate+1,'YYYYMMDD')||'%'";
		else if(gubun2.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt3+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt3+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		if(gubun1.equals("일등전국탁송")||gubun1.equals("에프앤티코리아")){
			query += " and ( a.off_nm like '%에프앤티%' or a.off_nm like '%일등전국탁송%') ";
		} else if (gubun1.equals("(주)영원물류")||gubun1.equals("상원물류(주)")) {
			query += " and ( a.off_nm like '%(주)영원물류%' or a.off_nm like '%상원물류(주)%') ";
		}else if(!gubun1.equals("")){
			query += " and a.off_nm like '%"+gubun1+"%'";
		}

		if(s_kd.equals("1"))	what = "upper(nvl(e.br_id||e.br_nm, ' '))";	
		if(s_kd.equals("2"))	what = "upper(nvl(c.user_nm, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(a.car_nm, ' '))";	
		if(s_kd.equals("4"))	what = "upper(nvl(a.car_no||i.est_car_no||j.car_no, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(a.from_place||a.to_place||a.from_comp||a.to_comp, ' '))";
		if(s_kd.equals("6"))	what = "upper(nvl(a.driver_nm, ' '))";
			
		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		if(sort.equals("1"))	query += " order by a.off_nm, decode(e.br_id,'S1',1,'B1',2,'D1',3)";	
		if(sort.equals("2"))	query += " order by a.off_nm, c.user_nm";	
		if(sort.equals("5"))	query += " order by a.off_nm, a.from_est_dt";
		if(sort.equals("6"))	query += " order by a.off_nm, a.from_req_dt";
		if(sort.equals("7"))	query += " order by a.off_nm, b.user_dt1";	
		//출발지, 도착지 정렬조건 추가
		if(sort.equals("8"))	query += " order by a.off_nm, a.from_place";	//출발지
		if(sort.equals("9"))	query += " order by a.off_nm, a.TO_PLACE";		//도착지

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
			System.out.println("[ConsignmentDatabase:getConsignmentSettleList]\n"+e);
			System.out.println("[ConsignmentDatabase:getConsignmentSettleList]\n"+query);
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

	//청구서작성 리스트 조회
	public Vector getConsignmentReqList(String s_kd, String t_wd, String gubun1, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.CONS_ST, a.CONS_SU, a.REG_CODE, a.OFF_ID, a.OFF_NM, a.CAR_MNG_ID, a.RENT_MNG_ID, a.RENT_L_CD, a.CLIENT_ID, a.CAR_NO, a.CAR_NM, a.CONS_CAU, a.CONS_CAU_ETC, a.COST_ST, a.PAY_ST, a.FROM_ST, a.FROM_PLACE, a.FROM_COMP, a.FROM_TITLE, a.FROM_MAN, a.FROM_TEL, a.FROM_M_TEL, a.FROM_REQ_DT, a.FROM_EST_DT, a.TO_ST, a.TO_PLACE, a.TO_COMP, a.TO_TITLE, a.TO_MAN, a.TO_TEL, a.TO_M_TEL, a.TO_REQ_DT, a.TO_EST_DT, a.DRIVER_NM, a.DRIVER_M_TEL, a.WASH_YN, a.OIL_YN, a.OIL_LITER, a.OIL_EST_AMT, a.ETC, a.CONS_AMT, a.WASH_AMT, a.OIL_AMT, a.OTHER_AMT, a.OTHER, a.TOT_AMT, a.PAY_DT, a.REQ_DT, a.REQ_CODE, a.CUST_AMT, a.CUST_PAY_DT, a.CONF_DT, a.CONS_COPY, a.REG_ID, a.REG_DT, a.OUT_OK, a.CMP_APP, a.AFTER_YN, a.TOT_DIST, a.REQ_ID, a.F_MAN, a.D_MAN, a.MM_SEQ, a.HIPASS_YN, a.HIPASS_AMT, a.M_DOC_CODE, a.M_AMT, a.OIL_CARD_AMT, a.CONS_NO, a.SEQ, "+
				" DECODE(g.START_DT, '', a.FROM_EST_DT, g.START_DT) AS from_dt, DECODE(g.END_DT, '', a.FROM_EST_DT, g.END_DT) AS to_dt , a.WASH_FEE,"+
				" c.user_nm as user_nm1, d.user_nm as user_nm2, b.user_dt1, b.user_dt2, f.nm as cons_cau_nm, decode(a.cons_st,'1','편도','2','왕복') as cons_st_nm,"+
				" decode(a.pay_st,'1','선불','2','후불') pay_st_nm, decode(a.cost_st,'1','아마존카','2','고객') cost_st_nm , a.wash_card_amt , a.cons_other_amt "+
				" from consignment a, (select * from doc_settle where doc_st='2') b, users c, users d, branch e, (select * from code where c_st='0015' and code<>'0000') f ,  \n " +
				"  (   select a.* from cons_oksms a, ( select cons_no, seq, max(reg_dt) reg_dt from cons_oksms where cons_no like '201410310014%' group by cons_no, seq) b  where a.cons_no = b.cons_no and a.seq = b.seq and a.reg_dt = b.reg_dt  ) g "+
				" , car_pur i, car_reg j"+
				" where a.off_id<>'003158' and a.cons_no=b.doc_id(+) and b.user_id1=c.user_id(+) and b.user_id2=d.user_id(+) and c.br_id=e.br_id(+) and a.cons_cau=f.nm_cd(+) AND a.cons_no = g.CONS_NO (+) AND a.SEQ = g.SEQ(+)"+
				" AND a.rent_mng_id = i.rent_mng_id(+) AND a.rent_l_cd = i.rent_l_cd(+) AND a.car_mng_id = j.car_mng_id(+) "+
//				" and b.doc_step='3'"+
				" and a.req_dt is null and b.user_dt3 is not null";//b.user_id4 is not null and b.user_dt5 is null//a.req_dt is null and nvl(a.cost_st||a.pay_st,'12') not in ('21')

		// if(!gubun2.equals(""))	query += " and b.user_id2='"+gubun2+"'";
		
		if(!gubun2.equals("")) {
			if (gubun2.equals("000222")) {
				query += " and b.user_id2 in('000222','000308') ";
			} else if (gubun2.equals("000308")) {
				query += " and b.user_id2 in('000222','000308') ";
			} else {
				query += " and b.user_id2 = '"+gubun2+"' ";
			}
		}

		String search = "";
		String what = "";

		if(s_kd.equals("1"))	what = "upper(nvl(e.br_id||e.br_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(a.off_nm, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(a.from_place||a.to_place||a.from_comp||a.to_comp, ' '))";
		if(s_kd.equals("4"))	what = "upper(nvl(a.car_no||i.est_car_no||j.car_no, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(c.user_nm, ' '))";
		if(s_kd.equals("6"))	what = "to_char(b.user_dt1,'YYYYMMDD')";

			
		if(!s_kd.equals("") && !t_wd.equals("")){
			if(s_kd.equals("6")){
				query += " and "+what+" like replace('%"+t_wd+"%', '-','')";
			}else if(s_kd.equals("2")&&(t_wd.equals("일등전국탁송(광주)") ||t_wd.equals("에프앤티코리아(광주)"))){
				query += "  and ("+what+" like upper('%일등전국탁송(광주)%') or "+what+" like upper('%에프앤티코리아(광주)%')) ";
			}else if(s_kd.equals("2")&&(t_wd.equals("일등전국탁송(대구)") ||t_wd.equals("에프앤티코리아(대구)"))){
				query += "  and ("+what+" like upper('%일등전국탁송(대구)%') or "+what+" like upper('%에프앤티코리아(대구)%')) ";
			}else if(s_kd.equals("2")&&(t_wd.equals("일등전국탁송(부산)") ||t_wd.equals("에프앤티코리아(부산)"))){
				query += "  and ("+what+" like upper('%일등전국탁송(부산)%') or "+what+" like upper('%에프앤티코리아(부산)%')) ";
			}else if(s_kd.equals("2")&&(t_wd.contains("일등전국") ||t_wd.contains("에프앤티"))){
				query += "  and ("+what+" like upper('%일등전국%') or "+what+" like upper('%에프앤티%')) ";
			}else{
				query += " and "+what+" like upper('%"+t_wd+"%') ";
			}
		}else{

		}	

		query += " order by a.off_id, a.cons_no, a.seq";



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
			System.out.println("[ConsignmentDatabase:getConsignmentReqList]\n"+e);
			System.out.println("[ConsignmentDatabase:getConsignmentReqList]\n"+query);
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

	//청구서작성 리스트 조회
	public Vector getConsignmentReqList(String s_kd, String t_wd, String gubun1, String st_dt, String end_dt, String gubun2, String gubun3, String mode)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Vector vt = new Vector();
			String query = "";

			query = " select a.CONS_ST, a.CONS_SU, a.REG_CODE, a.OFF_ID, a.OFF_NM, a.CAR_MNG_ID, a.RENT_MNG_ID, a.RENT_L_CD, a.CLIENT_ID, a.CAR_NO, a.CAR_NM, a.CONS_CAU, a.CONS_CAU_ETC, a.COST_ST, a.PAY_ST, a.FROM_ST, a.FROM_PLACE, a.FROM_COMP, a.FROM_TITLE, a.FROM_MAN, a.FROM_TEL, a.FROM_M_TEL, a.FROM_REQ_DT, a.FROM_EST_DT, a.TO_ST, a.TO_PLACE, a.TO_COMP, a.TO_TITLE, a.TO_MAN, a.TO_TEL, a.TO_M_TEL, a.TO_REQ_DT, a.TO_EST_DT, a.DRIVER_NM, a.DRIVER_M_TEL, a.WASH_YN, a.OIL_YN, a.OIL_LITER, a.OIL_EST_AMT, a.ETC, a.CONS_AMT, a.WASH_AMT, a.OIL_AMT, a.OTHER_AMT, a.OTHER, a.TOT_AMT, a.PAY_DT, a.REQ_DT, a.REQ_CODE, a.CUST_AMT, a.CUST_PAY_DT, a.CONF_DT, a.CONS_COPY, a.REG_ID, a.REG_DT, a.OUT_OK, a.CMP_APP, a.AFTER_YN, a.TOT_DIST, a.REQ_ID, a.F_MAN, a.D_MAN, a.MM_SEQ, a.HIPASS_YN, a.HIPASS_AMT, a.M_DOC_CODE, a.M_AMT, a.OIL_CARD_AMT, a.CONS_NO, a.SEQ, "+
					" DECODE(g.START_DT, '', a.FROM_EST_DT, g.START_DT) AS from_dt, DECODE(g.END_DT, '', a.FROM_EST_DT, g.END_DT) AS to_dt , a.WASH_FEE,"+
					" c.user_nm as user_nm1, d.user_nm as user_nm2, b.user_dt1, b.user_dt2, f.nm as cons_cau_nm, decode(a.cons_st,'1','편도','2','왕복') as cons_st_nm,"+
					" decode(a.pay_st,'1','선불','2','후불') pay_st_nm, decode(a.cost_st,'1','아마존카','2','고객') cost_st_nm"+
					" from consignment a, (select * from doc_settle where doc_st='2') b, users c, users d, branch e, (select * from code where c_st='0015' and code<>'0000') f ,  \n " +
					"  (   select a.* from cons_oksms a, ( select cons_no, seq, max(reg_dt) reg_dt from cons_oksms where cons_no like '201410310014%' group by cons_no, seq) b  where a.cons_no = b.cons_no and a.seq = b.seq and a.reg_dt = b.reg_dt  ) g "+
					" where a.off_id<>'003158' and a.cons_no=b.doc_id(+) and b.user_id1=c.user_id(+) and b.user_id2=d.user_id(+) and c.br_id=e.br_id(+) and a.cons_cau=f.nm_cd(+) AND a.cons_no = g.CONS_NO (+) AND a.SEQ = g.SEQ(+)"+
					" and a.req_dt is null and b.user_dt3 is not null";

			
			String search = "";
			String what = "";
			String dt1 = "";
			String dt2 = "";
			String dt3 = "";

			if(gubun1.equals("4")){
				dt1		= "substr(a.from_req_dt,1,6)";
				dt2		= "substr(a.from_req_dt,1,8)";
				dt3		= "a.from_req_dt";
			}

			if(gubun3.equals("1"))			query += " and "+dt3+" like to_char(sysdate,'YYYYMM')||'%'";		
			else if(gubun3.equals("2")){
				if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt3+" like replace('"+st_dt+"%', '-','')";
				if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt3+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
			}
			
			if(!gubun2.equals("")) {
				if (gubun2.equals("000222")) {
					query += " and b.user_id2 in('000222','000308') ";
				} else if (gubun2.equals("000308")) {
					query += " and b.user_id2 in('000222','000308') ";
				} else {
					query += " and b.user_id2 = '"+gubun2+"' ";
				}
			}			
		
			if(s_kd.equals("1"))	what = "upper(nvl(e.br_id||e.br_nm, ' '))";
			if(s_kd.equals("2"))	what = "upper(nvl(a.off_nm, ' '))";	
			if(s_kd.equals("3"))	what = "upper(nvl(a.from_place||a.to_place||a.from_comp||a.to_comp, ' '))";
			if(s_kd.equals("4"))	what = "upper(nvl(a.car_no, ' '))";	
			if(s_kd.equals("5"))	what = "upper(nvl(c.user_nm, ' '))";
			if(s_kd.equals("6"))	what = "to_char(b.user_dt1,'YYYYMMDD')";

				
			if(!s_kd.equals("") && !t_wd.equals("")){
				if(s_kd.equals("6")){
					query += " and "+what+" like replace('%"+t_wd+"%', '-','')";
				}else if(s_kd.equals("2")&&(t_wd.equals("일등전국탁송(광주)") ||t_wd.equals("에프앤티코리아(광주)"))){
					query += "  and ("+what+" like upper('%일등전국탁송(광주)%') or "+what+" like upper('%에프앤티코리아(광주)%')) ";
				}else if(s_kd.equals("2")&&(t_wd.equals("일등전국탁송(대구)") ||t_wd.equals("에프앤티코리아(대구)"))){
					query += "  and ("+what+" like upper('%일등전국탁송(대구)%') or "+what+" like upper('%에프앤티코리아(대구)%')) ";
				}else if(s_kd.equals("2")&&(t_wd.equals("일등전국탁송(부산)") ||t_wd.equals("에프앤티코리아(부산)"))){
					query += "  and ("+what+" like upper('%일등전국탁송(부산)%') or "+what+" like upper('%에프앤티코리아(부산)%')) ";
				}else if(s_kd.equals("2")&&(t_wd.contains("일등전국") ||t_wd.contains("에프앤티"))){
					query += "  and ("+what+" like upper('%일등전국%') or "+what+" like upper('%에프앤티%')) ";
				}else{
					query += " and "+what+" like upper('%"+t_wd+"%') ";
				}
			}else{

			}	

			query += " order by a.off_id, a.cons_no, a.seq";

	

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
				System.out.println("[ConsignmentDatabase:getConsignmentReqList]\n"+e);
				System.out.println("[ConsignmentDatabase:getConsignmentReqList]\n"+query);
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
		
	//청구서작성 리스트 조회
	public Vector getConsignmentReqList2(String s_kd, String t_wd, String gubun1, String st_dt, String end_dt, String gubun2, String gubun3, String mode)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select "+	
				" a.CONS_ST, a.CONS_SU, a.REG_CODE, a.OFF_ID, a.OFF_NM, a.CAR_MNG_ID, a.RENT_MNG_ID, a.RENT_L_CD, a.CLIENT_ID, a.CAR_NO, a.CAR_NM, a.CONS_CAU, a.CONS_CAU_ETC, a.COST_ST, a.PAY_ST, a.FROM_ST, a.FROM_PLACE, "+
				" a.FROM_COMP, a.FROM_TITLE, a.FROM_MAN, a.FROM_TEL, a.FROM_M_TEL, a.FROM_REQ_DT, a.FROM_EST_DT, a.TO_ST, a.TO_PLACE, a.TO_COMP, a.TO_TITLE, a.TO_MAN, a.TO_TEL, a.TO_M_TEL, a.TO_REQ_DT, a.TO_EST_DT, "+
				" a.DRIVER_NM, a.DRIVER_M_TEL, a.WASH_YN, a.OIL_YN, a.OIL_LITER, a.OIL_EST_AMT, a.ETC, a.CONS_AMT, a.WASH_AMT, a.OIL_AMT, a.OTHER_AMT, a.OTHER, a.TOT_AMT, a.PAY_DT, a.REQ_DT, a.REQ_CODE, a.CUST_AMT, a.CUST_PAY_DT,"+
				" a.CONF_DT, a.CONS_COPY, a.REG_ID, a.REG_DT, a.OUT_OK, a.CMP_APP, a.AFTER_YN, a.TOT_DIST, a.REQ_ID, a.F_MAN, a.D_MAN, a.MM_SEQ, a.HIPASS_YN, a.HIPASS_AMT, a.M_DOC_CODE, a.M_AMT, a.OIL_CARD_AMT, a.CONS_NO, a.SEQ, "+
				" a.WASH_FEE, a.wash_card_amt, a.cons_other_amt, a.etc1_amt, a.etc2_amt , \n"+
				" DECODE(g.START_DT, '', a.FROM_EST_DT, g.START_DT) AS from_dt, DECODE(g.END_DT, '', a.FROM_EST_DT, g.END_DT) AS to_dt , "+
				" decode(a.off_nm,'코리아탁송','본사',e.br_nm) br_nm, b.doc_no, c.user_nm as user_nm1, d.user_nm as user_nm2, b.user_dt1, b.user_dt2, f.nm as cons_cau_nm, decode(a.cons_st,'1','편도','2','왕복') as cons_st_nm,"+
				" decode(a.conf_dt,'','미확인','확인') conf_st_nm, decode(b.user_dt6,'','미확인','확인') conf_st_nm2, decode(a.pay_st,'1','선불','2','후불') pay_st_nm, decode(a.cost_st,'1','아마존카','2','고객') cost_st_nm"+
				" from consignment a, (select * from doc_settle where doc_st='2') b, users c, users d, branch e, (select * from code where c_st='0015' and code<>'0000') f, "+
				" (SELECT DISTINCT cons_no AS cons_no_r, seq AS seq_r, a.* FROM cons_oksms a where a.dist_km IS NOT NULL AND a.end_dt IS not null) g, "+	//탁송기사 문자중복때문에 수정(20190716)
				" car_pur i, car_reg j " +
				" where a.off_id<>'003158' and a.cons_no=b.doc_id(+) and b.user_id1=c.user_id(+) and b.user_id2=d.user_id(+) and c.br_id=e.br_id(+) and a.cons_cau=f.nm_cd(+)  AND a.cons_no = g.CONS_NO_R (+) AND a.SEQ = g.SEQ_R(+) "+
				" AND a.rent_mng_id = i.rent_mng_id(+) AND a.rent_l_cd = i.rent_l_cd(+) AND a.car_mng_id = j.car_mng_id(+) "+
				" and a.req_dt is not null and a.pay_dt is null and b.user_dt7 is null "; 
				
				
		String search = "";
		String what = "";

		if(s_kd.equals("2"))	what = "upper(nvl(a.off_nm, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(a.from_place||a.to_place||a.from_comp||a.to_comp, ' '))";
		if(s_kd.equals("4"))	what = "upper(nvl(a.car_no||i.est_car_no||j.car_no, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(c.user_nm, ' '))";
		if(s_kd.equals("6"))	what = "upper(nvl(a.cons_no, ' '))";
		if(s_kd.equals("7"))	what = "upper(nvl(a.OTHER, ' '))";
		if(s_kd.equals("8"))	what = "upper(nvl(a.DRIVER_NM, ' '))";
		if(s_kd.equals("9"))	what = "a.tot_amt";		
		
			
		if(!s_kd.equals("") && !t_wd.equals("")){
			if(s_kd.equals("2") && (t_wd.equals("일등전국탁송(광주)") || t_wd.equals("에프앤티코리아(광주)"))){
				query += "  and ("+what+" like upper('%일등전국탁송(광주)%') or "+what+" like upper('%에프앤티코리아(광주)%')) ";
			}else if(s_kd.equals("2") && (t_wd.equals("일등전국탁송(대구)") || t_wd.equals("에프앤티코리아(대구)"))){
				query += "  and ("+what+" like upper('%일등전국탁송(대구)%') or "+what+" like upper('%에프앤티코리아(대구)%')) ";
			}else if(s_kd.equals("2") && (t_wd.equals("일등전국탁송(부산)") || t_wd.equals("에프앤티코리아(부산)"))){
				query += "  and ("+what+" like upper('%일등전국탁송(부산)%') or "+what+" like upper('%에프앤티코리아(부산)%')) ";
			}else if(s_kd.equals("2") && (t_wd.contains("일등전국") || t_wd.contains("에프앤티"))){
				query += "  and ("+what+" like upper('%일등전국%') or "+what+" like upper('%에프앤티%')) ";
			}else if(s_kd.equals("2") && (t_wd.equals("(주)영원물류") || t_wd.equals("상원물류(주)"))){
				query += "  and ("+what+" like upper('%(주)영원물류%') or "+what+" like upper('%상원물류(주)%')) ";
			}else{
				query += " and "+what+" like upper('%"+t_wd+"%') ";
			}
		}else if(s_kd.equals("") && !t_wd.equals("")){
				query += " and upper(nvl(a.off_nm, ' ')) like upper('"+t_wd+"%') ";
		}

		if(gubun1.equals("1"))			query += " and a.req_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun1.equals("3"))		query += " and a.req_dt = to_char(sysdate,'YYYYMMDD')";
		else if(gubun1.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and a.req_dt like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and a.req_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}else if(gubun1.equals("4")){ //탁송출발 일시를 기간으로 검색
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and a.from_dt like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and a.from_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		if(!gubun2.equals(""))			query += " and decode(a.off_nm,'코리아탁송','S1','(주)코리아탁송무역','S1',c.br_id)='"+gubun2+"'";

		if(gubun3.equals("1"))			query += " and b.user_dt5 is not null";
		if(gubun3.equals("2"))			query += " and b.user_dt6 is not null";
		if(gubun3.equals("3"))			query += " and b.user_dt5 is not null and b.user_dt6 is not null";
		if(gubun3.equals("4"))			query += " and b.user_dt5 is null";
		if(gubun3.equals("5"))			query += " and b.user_dt6 is null";
		if(gubun1.equals("4") && mode.equals("1")){			        query += " order by a.cons_no, a.req_dt, a.seq, a.from_dt ";

		}else if(gubun1.equals("4") && mode.equals("2")){			query += " order by a.car_no, a.req_dt, a.cons_no, a.seq, a.from_dt ";

		}else if(gubun1.equals("4") && mode.equals("3")){			query += " order by a.from_dt, a.req_dt, a.cons_no, a.seq ";
		
		}else if(mode.equals("8")){			query += " order by a.FROM_PLACE,  a.req_dt, a.cons_no, a.seq ";	//출발지 정렬 추가
		
		}else if(mode.equals("9")){			query += " order by a.TO_PLACE,  a.req_dt, a.cons_no, a.seq ";		//도착지 정렬 추가
		
		}else if(mode.equals("r")){			query += " order by decode(a.conf_dt,'',1,2), a.req_dt, a.cons_no, a.seq, a.from_dt ";
			
		}else if(mode.equals("p")){			query += " order by a.req_dt, a.cons_no, a.seq, a.from_dt ";//담당자미확인 우선정렬 추가

		}else{								query += " order by a.off_id, decode(decode(a.off_nm,'코리아탁송','S1',c.br_id),'S1',1,'B1',2,'D1',3), a.req_dt, a.cons_no, a.seq";

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
			System.out.println("[ConsignmentDatabase:getConsignmentReqList2]\n"+e);
			System.out.println("[ConsignmentDatabase:getConsignmentReqList2]\n"+query);
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

	//탁송미확인현황 리스트 조회
	public Vector getConsignmentConfList(String s_kd, String t_wd, String gubun1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" a.*, c.user_nm as user_nm1, d.user_nm as user_nm2, b.user_dt1, b.user_dt2, f.nm as cons_cau_nm, decode(a.cons_st,'1','편도','2','왕복') as cons_st_nm,"+
				" decode(a.pay_st,'1','선불','2','후불') pay_st_nm, decode(a.cost_st,'1','아마존카','2','고객') cost_st_nm, g.firm_nm"+
				" from consignment a, (select * from doc_settle where doc_st='2') b, users c, users d, branch e, (select * from code where c_st='0015' and code<>'0000') f, client g, car_pur i, car_reg j "+
				" where a.off_id<>'003158' and a.cons_no=b.doc_id(+) and b.user_id1=c.user_id(+) and b.user_id2=d.user_id(+) and c.br_id=e.br_id(+) and a.cons_cau=f.nm_cd(+) and a.client_id=g.client_id(+) AND a.rent_mng_id = i.rent_mng_id(+) AND a.rent_l_cd = i.rent_l_cd(+) AND a.car_mng_id = j.car_mng_id(+)"+
//				" and b.doc_step='2'"+
				" and a.req_dt is not null"+
				" and a.pay_dt is null and a.conf_dt is null";

		String search = "";
		String what = "";

		if(s_kd.equals("1"))	what = "upper(nvl(e.br_id||e.br_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(a.off_nm, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(a.from_place||a.to_place||a.from_comp||a.to_comp, ' '))";
		if(s_kd.equals("4"))	what = "upper(nvl(a.car_no||i.est_car_no||j.car_no, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(c.user_nm, ' '))";
		if(s_kd.equals("6"))	what = "to_char(b.user_dt1,'YYYYMMDD')";

			
		if(!s_kd.equals("") && !t_wd.equals("")){
			if(s_kd.equals("6")){
				query += " and "+what+" like replace('%"+t_wd+"%', '-','')";
			}else if(s_kd.equals("2")){
				if(t_wd.equals("일등전국탁송(광주)")||t_wd.equals("에프앤티코리아(광주)")){
					query += " and ("+what+" like upper('%에프앤티코리아(광주)%') or "+what+" like upper('%일등전국탁송(광주)%') )";
				}else if(t_wd.equals("일등전국탁송(대구)")||t_wd.equals("에프앤티코리아(대구)")){
					query += " and ("+what+" like upper('%에프앤티코리아(대구)%') or "+what+" like upper('%일등전국탁송(대구)%') )";
				}else if(t_wd.equals("일등전국탁송(부산)")||t_wd.equals("에프앤티코리아(부산)")){
					query += " and ("+what+" like upper('%에프앤티코리아(부산)%') or "+what+" like upper('%일등전국탁송(부산)%') )";
				}else if(t_wd.contains("일등전국")||t_wd.contains("에프앤티")){
					query += " and ("+what+" like upper('%에프앤티%') or "+what+" like upper('%일등전국%') )";
				}else{
					query += " and "+what+" like upper('%"+t_wd+"%') ";	
				}
			}else{
				query += " and "+what+" like upper('%"+t_wd+"%') ";
			}
		}else{

		}	

		query += " order by a.off_id, c.user_nm, a.cons_no, a.seq";

//System.out.println("getConsignmentConfList( "+query);

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
			System.out.println("[ConsignmentDatabase:getConsignmentConfList]\n"+e);
			System.out.println("[ConsignmentDatabase:getConsignmentConfList]\n"+query);
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

	//청구서작성 리스트 조회
	public Vector getConsignmentReqDocList(String req_code)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" a.*, c.user_nm as user_nm1, d.user_nm as user_nm2, b.user_dt1, b.user_dt2, f.nm as cons_cau_nm"+
				" from consignment a, (select * from doc_settle where doc_st='2') b, users c, users d, branch e, "+
				" (select * from code where c_st='0015' and code<>'0000') f, (select * from doc_settle where doc_st='3') g"+
				" where a.cons_no=b.doc_id(+) and b.user_id1=c.user_id(+) and b.user_id2=d.user_id(+) and c.br_id=e.br_id(+) and a.cons_cau=f.nm_cd(+) and a.req_code=g.doc_id"+
				" and a.req_dt is not null and a.conf_dt is not null and g.doc_id='"+req_code+"'";//and a.pay_dt is null 

		query += " order by a.off_id, a.from_dt, a.cons_no, a.seq";

			
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
			System.out.println("[ConsignmentDatabase:getConsignmentReqDocList]\n"+e);
			System.out.println("[ConsignmentDatabase:getConsignmentReqDocList]\n"+query);
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

	//청구서작성 리스트 조회
	public Vector getConsignmentReqDocList2(String req_code, String pay_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" a.*, c.user_nm as user_nm1, d.user_nm as user_nm2, b.user_dt1, b.user_dt2, f.nm as cons_cau_nm"+
				" from consignment a, (select * from doc_settle where doc_st='2') b, users c, users d, branch e, "+
				" (select * from code where c_st='0015' and code<>'0000') f, (select * from doc_settle where doc_st='3') g"+
				" where a.cons_no=b.doc_id(+) and b.user_id1=c.user_id(+) and b.user_id2=d.user_id(+) and c.br_id=e.br_id(+) and a.cons_cau=f.nm_cd(+) and a.req_code=g.doc_id"+
				" and a.req_dt is not null and a.conf_dt is not null and g.doc_id='"+req_code+"'";//and a.pay_dt is null 

		if(!pay_dt.equals(""))	query +=" and a.pay_dt = replace('"+pay_dt+"','-','')";
//		else					query +=" and a.pay_dt is null";

		query += " order by a.off_id, a.from_dt, a.cons_no, a.seq";

//System.out.println("[Con]:"+query);
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
			System.out.println("[ConsignmentDatabase:getConsignmentReqDocList]\n"+e);
			System.out.println("[ConsignmentDatabase:getConsignmentReqDocList]\n"+query);
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

	//청구서작성 리스트 조회
	public Vector getConsignmentReqDocList(String req_code, String br_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" a.*, c.user_nm as user_nm1, d.user_nm as user_nm2, b.user_dt1, b.user_dt2, f.nm as cons_cau_nm"+
				" from consignment a, (select * from doc_settle where doc_st='2') b, users c, users d, users h, branch e, (select * from code where c_st='0015' and code<>'0000') f, (select * from doc_settle where doc_st='3') g"+
				" where a.cons_no=b.doc_id(+) and b.user_id1=c.user_id(+) and b.user_id2=d.user_id(+) and b.user_id7=h.user_id(+) and d.br_id=e.br_id(+) and a.cons_cau=f.nm_cd(+) and a.req_code=g.doc_id"+
				" and a.req_dt is not null and a.conf_dt is not null and b.user_dt7 is not null and g.doc_id='"+req_code+"' and e.br_id='"+br_id+"'";//and a.pay_dt is null 

		query += " order by a.off_id, a.cons_no, a.seq";

			
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
			System.out.println("[ConsignmentDatabase:getConsignmentReqDocList]\n"+query);
		} catch (SQLException e) {
			System.out.println("[ConsignmentDatabase:getConsignmentReqDocList]\n"+e);
			System.out.println("[ConsignmentDatabase:getConsignmentReqDocList]\n"+query);
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

	//문서처리 리스트 조회
	public Vector getConsignmentReqDocList(String s_kd, String t_wd, String gubun1, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String sub_query = "";
		String query = "";

		sub_query = " select"+
				" f.doc_id as req_code, a.off_id, a.req_dt, decode(a.off_nm,'코리아탁송','S1',c.br_id) br_id, min(a.off_nm) off_nm, count(a.cons_no) cnt, "+
				" min(substr(a.from_dt,1,8)) min_dt, max(substr(a.to_dt,1,8)) max_dt, "+
				" sum(a.cons_amt) cons_amt, sum(a.cons_other_amt) cons_other_amt, sum(a.oil_amt) oil_amt, sum(a.wash_amt) wash_amt, sum(a.wash_fee) wash_fee, sum(a.hipass_amt) hipass_amt, sum(other_amt) other_amt,  sum(etc1_amt) etc1_amt,  sum(etc2_amt) etc2_amt,  sum(a.tot_amt) tot_amt"+
				" from consignment a, doc_settle b, users c, branch e, (select * from doc_settle where doc_st='3') f"+
				" where a.cons_no=b.doc_id(+) and b.doc_st='2' and b.user_id7=c.user_id(+) and c.br_id=e.br_id(+) and a.req_code=f.doc_id(+)"+
				" and a.req_dt is not null and a.conf_dt is not null and a.pay_dt is null and b.user_dt7 is not null and a.tot_amt>0";// and f.doc_no is null


		if(gubun1.equals("1"))							sub_query += " and a.req_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun1.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	sub_query += " and a.req_dt like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) sub_query += " and a.req_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		sub_query += " group by a.off_id, a.req_dt, decode(a.off_nm,'코리아탁송','S1',c.br_id), f.doc_id";

		query = " select"+
				" a.*, b.user_id1, b.user_id2, c.user_nm as user_nm1, d.user_nm as user_nm2, b.user_dt1, b.user_dt2, b.doc_no, e.br_nm"+
				" from ("+sub_query+") a, (select * from doc_settle where doc_st='3') b, users c, users d, branch e"+
				" where a.req_code=b.doc_id(+) and b.user_id1=c.user_id(+) and b.user_id2=d.user_id(+) and a.br_id=e.br_id(+)"+
				" and nvl(b.doc_step,'1') <> '3' ";

		//과거 미정리분 강제 20110210
		query += " and a.off_nm||a.req_dt||b.user_id1 not in ('코리아탁송20081218', '코리아탁송20090928')";

		String search = "";
		String what = "";

		if(s_kd.equals("1"))	what = "upper(nvl(a.br_id||e.br_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(a.off_nm, ' '))";	
		if(s_kd.equals("6"))	what = "a.req_dt";

			
		if(!s_kd.equals("") && !t_wd.equals("")){
			if(s_kd.equals("6"))	query += " and "+what+" like replace('%"+t_wd+"%', '-','')";
			else					query += " and "+what+" like upper('%"+t_wd+"%') ";
		}else{

		}	

		query += " order by a.off_id, a.req_dt, a.br_id";


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
//			System.out.println("[ConsignmentDatabase:getConsignmentReqDocList]\n"+query);
		} catch (SQLException e) {
			System.out.println("[ConsignmentDatabase:getConsignmentReqDocList]\n"+e);
			System.out.println("[ConsignmentDatabase:getConsignmentReqDocList]\n"+query);
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

	//미지급현황 리스트 조회
	public Vector getConsignmentNonPayList(String s_kd, String t_wd, String gubun1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String sub_query = "";
		String query = "";

		sub_query = " select"+
				" b2.doc_no as doc_s_no, a.req_code, a.off_id, a.req_dt, decode(a.off_nm,'코리아탁송','S1',c.br_id) br_id, min(a.off_nm) off_nm, count(a.cons_no) cnt, min(substr(a.from_dt,1,8)) min_dt, max(substr(a.to_dt,1,8)) max_dt, "+
				" sum(a.cons_amt) cons_amt, sum(a.cons_other_amt) cons_other_amt , sum(a.oil_amt) oil_amt, sum(a.wash_amt) wash_amt, sum(a.wash_fee) wash_fee, sum(a.hipass_amt) hipass_amt, sum(other_amt) other_amt, sum(etc1_amt) etc1_amt, sum(etc2_amt) etc2_amt, sum(a.tot_amt) tot_amt"+
				" from consignment a, doc_settle b, users c, branch e, (select * from doc_settle where doc_st='3') b2"+
				" where a.cons_no=b.doc_id(+) and b.doc_st='2' and b.user_id7=c.user_id(+) and c.br_id=e.br_id(+)"+
				" and b.user_dt2 is not null "+
				" and b.user_dt3 is not null "+
				" and a.req_code=b2.doc_id"+
				" and a.req_dt is not null and a.conf_dt is not null and a.pay_dt is null";


		sub_query += " group by b2.doc_no, a.req_code, a.off_id, a.req_dt, decode(a.off_nm,'코리아탁송','S1',c.br_id)";

		query = " select"+
				" a.*, c.user_nm as user_nm1, d.user_nm as user_nm2, b.user_dt1, b.user_dt2, b.doc_no, e.br_nm"+
				" from ("+sub_query+") a, (select * from doc_settle where doc_st='3') b, users c, users d, branch e"+
				" where a.req_code=b.doc_id and b.user_id1=c.user_id(+) and b.user_id2=d.user_id(+) and a.br_id=e.br_id(+)"+
				" and nvl(b.doc_step,'1') = '3' ";

		String search = "";
		String what = "";

		if(s_kd.equals("1"))	what = "upper(nvl(a.br_id||e.br_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(a.off_nm, ' '))";	
		if(s_kd.equals("6"))	what = "a.req_dt";

			
		if(!s_kd.equals("") && !t_wd.equals("")){
			if(s_kd.equals("6")){
				query += " and "+what+" like replace('%"+t_wd+"%', '-','')";
			}else if(s_kd.equals("2") && (t_wd.contains("에프앤티")||t_wd.contains("일등전국"))){
				query += " and ("+what+" like upper('%에프앤티%') or "+what+" like upper('%일등전국%') )";
			}else{
				query += " and "+what+" like upper('%"+t_wd+"%') ";
			}
		}else{

		}	

		query += " order by a.off_id, a.req_dt, a.br_id";
				
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
//			System.out.println("[ConsignmentDatabase:getConsignmentNonPayList]\n"+query);
		} catch (SQLException e) {
			System.out.println("[ConsignmentDatabase:getConsignmentNonPayList]\n"+e);
			System.out.println("[ConsignmentDatabase:getConsignmentNonPayList]\n"+query);
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

	//미지급현황 리스트 조회
	public Vector getConsignmentNotPayOffList(String off_id, String req_dt, String br_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" a.*, c.user_nm as user_nm1, d.user_nm as user_nm2, b.user_dt1, b.user_dt2, f.nm as cons_cau_nm,"+
				" decode(a.pay_st,'1','선불','2','후불') pay_st_nm, decode(a.cost_st,'1','아마존카','2','고객') cost_st_nm"+
				" from consignment a, doc_settle b, users c, users d, branch e, (select * from code where c_st='0015' and code<>'0000') f, users g, (select * from doc_settle where doc_st='3') b2"+
				" where a.cons_no=b.doc_id(+) and b.doc_st='2' and b.user_id1=c.user_id(+) and b.user_id2=d.user_id(+) and b.user_id7=g.user_id(+) and g.br_id=e.br_id(+) and a.cons_cau=f.nm_cd(+) "+
				" and b.user_dt2 is not null "+
				" and b.user_dt3 is not null "+
				" and a.req_dt is not null and a.pay_dt is null and a.conf_dt is not null and b.user_dt7 is not null"+
				" and a.req_code=b2.doc_id(+) and b2.doc_no is null"+
				" and a.off_id='"+off_id+"' and a.req_dt=replace('"+req_dt+"','-','') and decode(a.off_nm,'코리아탁송','S1',g.br_id)='"+br_id+"'"+
				" order by a.cons_no, a.seq";

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
			System.out.println("[ConsignmentDatabase:getConsignmentNotPayOffList]\n"+e);
			System.out.println("[ConsignmentDatabase:getConsignmentNotPayOffList]\n"+query);
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

	//지급현황 리스트 조회
	public Vector getConsignmentPayList(String s_kd, String t_wd, String gubun1, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String sub_query = "";
		String query = "";

		sub_query = " select \n"+
				" a.req_code, a.off_id, a.req_dt, decode(a.off_nm,'코리아탁송','S1',c.br_id) br_id, a.pay_dt, min(a.off_nm) off_nm, count(a.cons_no) cnt, min(substr(a.from_dt,1,8)) min_dt, max(substr(a.to_dt,1,8)) max_dt, \n"+
				" sum(a.cons_amt) cons_amt, sum(a.cons_other_amt) cons_other_amt, sum(a.oil_amt) oil_amt, sum(a.wash_amt) wash_amt, sum(a.wash_fee) wash_fee, sum(a.hipass_amt) hipass_amt, sum(other_amt) other_amt, sum(a.etc1_amt) etc1_amt,sum(a.etc2_amt) etc2_amt, sum(a.tot_amt) tot_amt, sum(a.oil_card_amt) oil_card_amt , sum(a.wash_card_amt) wash_card_amt \n"+
				" from consignment a, doc_settle b, users c, branch e \n"+
				" where a.cons_no=b.doc_id(+) and b.doc_st='2' and nvl(b.user_id7,b.user_id1)=c.user_id(+) and c.br_id=e.br_id(+) \n"+
				" and b.user_dt2 is not null \n"+
				" and b.user_dt3 is not null \n"+
				" and a.req_dt is not null and a.pay_dt is not null";

		sub_query += " group by a.req_code, a.off_id, a.req_dt, decode(a.off_nm,'코리아탁송','S1',c.br_id), a.pay_dt";

		query = " select \n"+
				" a.*, b.user_id1, b.user_id2, c.user_nm as user_nm1, d.user_nm as user_nm2, b.user_dt1, b.user_dt2, b.doc_no, e.br_nm \n"+
				" from ("+sub_query+") a, (select * from doc_settle where doc_st='3') b, users c, users d, branch e \n"+
				" where a.req_code=b.doc_id and b.user_id1=c.user_id(+) and b.user_id2=d.user_id(+) and a.br_id=e.br_id(+)"+
				" and nvl(b.doc_step,'1') = '3' ";

		String search = "";
		String what = "";

		if(s_kd.equals("1"))	what = "upper(nvl(a.br_id||e.br_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(a.off_nm, ' '))";	
		if(s_kd.equals("6"))	what = "a.req_dt";

			
		if(!s_kd.equals("") && !t_wd.equals("")){
			if(s_kd.equals("6"))	query += " and "+what+" like replace('%"+t_wd+"%', '-','')";
			else if(s_kd.equals("2")&&(t_wd.equals("일등전국탁송(광주)") || t_wd.equals("에프앤티코리아(광주)")))	 	query += " and ("+what+" like upper('%에프앤티코리아(광주)%') or "+what+" like upper('%일등전국탁송(광주)%') )";
			else if(s_kd.equals("2")&&(t_wd.equals("일등전국탁송(대구)") || t_wd.equals("에프앤티코리아(대구)")))	 	query += " and ("+what+" like upper('%에프앤티코리아(대구)%') or "+what+" like upper('%일등전국탁송(대구)%') )";
			else if(s_kd.equals("2")&&(t_wd.equals("일등전국탁송(부산)") || t_wd.equals("에프앤티코리아(부산)")))	 	query += " and ("+what+" like upper('%에프앤티코리아(부산)%') or "+what+" like upper('%일등전국탁송(부산)%') )";
			else if(s_kd.equals("2")&&(t_wd.equals("(주)영원물류") || t_wd.equals("상원물류(주)")))	 	query += " and ("+what+" like upper('%(주)영원물류%') or "+what+" like upper('%상원물류(주)%') )";
			else if(s_kd.equals("2")&&(t_wd.contains("일등전국") || t_wd.contains("에프앤티")))	 	query += " and ("+what+" like upper('%에프앤티%') or "+what+" like upper('%일등전국%') )";
			else					query += " and "+what+" like upper('%"+t_wd+"%') ";
		}else{

		}	

		if(gubun1.equals("1"))			query += " and a.pay_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun1.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and a.pay_dt like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and a.pay_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}		

	//	query += " order by  a.off_id, a.req_dt , a.pay_dt,  a.br_id";
		query += " order by a.req_dt , a.off_id, a.pay_dt,  a.br_id";

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
			System.out.println("[ConsignmentDatabase:getConsignmentPayList]\n"+e);
			System.out.println("[ConsignmentDatabase:getConsignmentPayList]\n"+query);
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

	//탁송현황 리스트 조회
	public Vector getConsignmentMngList(String s_kd, String t_wd, String gubun1, String st_dt, String end_dt, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" a.*, g.firm_nm,"+
				" nvl(a.from_dt,nvl(a.from_est_dt,a.from_req_dt)) f_dt,"+
				" nvl(a.to_dt,nvl(a.to_est_dt,a.to_req_dt)) t_dt,"+
				" c.br_id, b.user_id1, c.user_nm as user_nm1, d.user_nm as user_nm2, b.user_dt1, b.user_dt2, "+
				" f.nm as cons_cau_nm, decode(a.cons_st,'1','편도','2','왕복') as cons_st_nm,"+
				" decode(a.pay_st,'1','선불','2','후불') pay_st_nm, decode(a.cost_st,'1','아마존카','2','고객') cost_st_nm,"+
				" decode((decode(b.user_dt1,'',0,1)+decode(b.user_dt2,'',0,1)+decode(b.user_dt3,'',0,1)+decode(a.req_dt,'',0,1)+decode(a.conf_dt,'',0,1)+decode(h.user_dt1,'',0,1)+decode(h.user_dt2,'',decode(c.br_id,'S1',0,decode(h.user_dt1,'',0,1)),1)+decode(a.pay_dt,'',0,1))"+
				"        ,1,'의뢰', 2,'수신', 3,'정산', 4,'청구', 5,'확인', 6,'결재', 7,'결재', 8,'지급'"+
				" ) as step,"+
				" (decode(b.user_dt1,'',0,1)+decode(b.user_dt2,'',0,1)+decode(b.user_dt3,'',0,1)+decode(a.req_dt,'',0,1)+decode(a.conf_dt,'',0,1)+decode(h.user_dt1,'',0,1)+decode(h.user_dt2,'',decode(c.br_id,'S1',0,decode(h.user_dt1,'',0,1)),1)+decode(a.pay_dt,'',0,1)) cnt,"+
				" decode(substr(a.driver_nm,1,1),'0',i.user_nm,a.driver_nm) driver_nm2"+
				" from consignment a, client g,"+
				" (select * from doc_settle where doc_st='2') b, "+
				" users c, users d, branch e, users i,"+
				" (select * from doc_settle where doc_st='3') h, "+
				" (select * from code where c_st='0015' and code<>'0000') f, "+
				" car_pur k, car_reg j "+
				" where a.cons_no=b.doc_id(+) and b.user_id1=c.user_id(+) and b.user_id2=d.user_id(+) and c.br_id=e.br_id(+)"+
				" and a.req_code=h.doc_id(+)"+
				" and a.cons_cau=f.nm_cd(+) and a.client_id=g.client_id(+) and a.driver_nm=i.user_id(+)" +
				" AND a.rent_mng_id = k.rent_mng_id(+) AND a.rent_l_cd = k.rent_l_cd(+) AND a.car_mng_id = j.car_mng_id(+) ";

		String search = "";
		String what = "";

		if(s_kd.equals("1"))	what = "upper(nvl(e.br_id||e.br_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(a.off_nm, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(a.from_place||a.to_place||a.from_comp||a.to_comp, ' '))";
		if(s_kd.equals("4"))	what = "upper(nvl(a.car_no||k.est_car_no||j.car_no, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(c.user_nm, ' '))";
		if(s_kd.equals("6"))	what = "to_char(b.user_dt1,'YYYYMMDD')";
		if(s_kd.equals("7"))	what = "upper(nvl(g.firm_nm, ' '))";
		if(s_kd.equals("8"))	what = " a.cons_no ";

		if(s_kd.equals("c_id"))	what = "upper(nvl(a.car_mng_id, ' '))";

			
		if(!s_kd.equals("") && !t_wd.equals("")){
		//	if(s_kd.equals("2"))	query += " and "+what+" like upper('%"+t_wd+"%') ";
		//	else if(s_kd.equals("6"))	query += " and "+what+" like replace('%"+t_wd+"%', '-','')";
		//	else					query += " and "+what+" like upper('%"+t_wd+"%') ";


			if(s_kd.equals("2")){
				//if(t_wd.equals("일등전국탁송")){
				if(t_wd.equals("일등전국탁송(광주)")||t_wd.equals("에프앤티코리아(광주)")){
					query += " and ("+what+" like upper('%에프앤티코리아(광주)%') or "+what+" like upper('%일등전국탁송(광주)%') )";
				}else if(t_wd.equals("일등전국탁송(대구)")||t_wd.equals("에프앤티코리아(대구)")){
					query += " and ("+what+" like upper('%에프앤티코리아(대구)%') or "+what+" like upper('%일등전국탁송(대구)%') )";
				}else if(t_wd.equals("일등전국탁송(부산)")||t_wd.equals("에프앤티코리아(부산)")){
					query += " and ("+what+" like upper('%에프앤티코리아(부산)%') or "+what+" like upper('%일등전국탁송(부산)%') )";
				}else if(t_wd.equals("(주)영원물류")||t_wd.equals("상원물류(주)")){
					query += " and ("+what+" like upper('%(주)영원물류%') or "+what+" like upper('%상원물류(주)%') )";
				}else if(t_wd.contains("일등전국")||t_wd.contains("에프앤티")){
					query += " and ("+what+" like upper('%에프앤티%') or "+what+" like upper('%일등전국%') )";
				}else{
					query += " and "+what+" like upper('%"+t_wd+"%') ";
				}
			}else if(s_kd.equals("6")){	
				query += " and "+what+" like replace('%"+t_wd+"%', '-','')";
			}else{
				query += " and "+what+" like upper('%"+t_wd+"%') ";
			}

		}else{

		}	

		String dt1 = "substr(nvl(a.from_req_dt,a.from_dt),1,6)"; //<-- 등록한 탁송 건 탁송기사 매칭전 시간수정시 탁송현황에서 기간조회되지 않던것 수정(20180614)
		String dt2 = "substr(nvl(a.from_req_dt,a.from_dt),1,8)";

		if(gubun2.equals("1")){
			dt1 = "to_char(b.user_dt1,'YYYYMM')";
			dt2 = "to_char(b.user_dt1,'YYYYMMDD')";
		}else if(gubun2.equals("2")){
			dt1 = "to_char(b.user_dt2,'YYYYMM')";
			dt2 = "to_char(b.user_dt2,'YYYYMMDD')";
		}else if(gubun2.equals("3")){
			dt1 = "to_char(b.user_dt3,'YYYYMM')";
			dt2 = "to_char(b.user_dt3,'YYYYMMDD')";
		}else if(gubun2.equals("4")){
			dt1 = "to_char(b.user_dt4,'YYYYMM')";
			dt2 = "to_char(b.user_dt4,'YYYYMMDD')";
		}else if(gubun2.equals("5")){
			dt1 = "to_char(b.user_dt5,'YYYYMM')";
			dt2 = "to_char(b.user_dt5,'YYYYMMDD')";
		}else if(gubun2.equals("6")){
			dt1 = "to_char(h.user_dt1,'YYYYMM')";
			dt2 = "to_char(h.user_dt1,'YYYYMMDD')";
		}else if(gubun2.equals("8")){
			dt1 = "substr(a.pay_dt,1,6)";
			dt2 = "a.pay_dt";
		}

		if(gubun1.equals("1"))			query += " and "+dt1+" = to_char(sysdate,'YYYYMM')";
		else if(gubun1.equals("3"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
		else if(gubun1.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}
		else if(gubun1.equals("4"))		query += " and "+dt1+" = to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')";

		if(!gubun2.equals(""))			query += " and decode(b.user_dt1,'',0,1)+decode(b.user_dt2,'',0,1)+decode(b.user_dt3,'',0,1)+decode(a.req_dt,'',0,1)+decode(a.conf_dt,'',0,1)+decode(h.user_dt1,'',0,1)+decode(h.user_dt2,'',decode(c.br_id,'S1',0,decode(h.user_dt1,'',0,1)),1)+decode(a.pay_dt,'',0,1)='"+gubun2+"'";

		query += " order by a.cons_no desc, a.seq, a.off_id, nvl(a.from_dt,nvl(a.from_est_dt,a.from_req_dt))";
		
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
			System.out.println("[ConsignmentDatabase:getConsignmentMngList]\n"+e);
			System.out.println("[ConsignmentDatabase:getConsignmentMngList]\n"+query);
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

//주차장관리 탁송에서 입고 리스트 조회
	public Vector getConsignmentMngList2(String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.*,decode( a.cons_cau, '8', '지연대차회수','9', '정비대차회수', '10', '사고대차회수', '11', '정비차량회수','12', '사고차량회수', '13', '중도해지회수', '14', '만기반납','15', '대여차량회수', '16', '본사이동' ) AS cons_st_nm "+
				" from consignment a, (SELECT car_no, max( to_dt ) to_dt FROM consignment where cons_cau in ('8','9','10','11','12','13','14','15','16') GROUP BY car_no) b, (select * from cont where use_yn = 'Y') c"+
				" where a.car_no = b.car_no(+) and a.rent_l_cd = c.rent_l_cd and a.to_dt = b.to_dt"+
				//" and a.to_dt IS NOT NULL and a.to_place like '%목동%' and a.out_ok is null and a.to_dt >= '20081001'";
				" and a.to_dt IS NOT NULL and (a.to_place like '%목동%' OR a.to_place like '%영남%') and a.out_ok is null and a.to_dt >= '20081001'";
				

		if(s_kd.equals("1"))			query += " and upper(a.car_no) like upper('%"+t_wd+"%')\n";		
		if(s_kd.equals("2"))			query += " and upper(a.car_nm) like upper('%"+t_wd+"%')\n";		
		if(s_kd.equals("3"))			query += " and upper(a.to_place) like '%"+t_wd+"%'\n";	
		
	
		if(sort_gubun.equals("1"))		query += " order by a.car_no "+asc ;
		if(sort_gubun.equals("2"))		query += " order by a.car_nm "+asc ;
		if(sort_gubun.equals("3"))		query += " order by a.to_place "+asc ;
		
						
		
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
//			System.out.println("[ConsignmentDatabase:getConsignmentMngList2]\n"+query);
		} catch (SQLException e) {
			System.out.println("[ConsignmentDatabase:getConsignmentMngList]\n"+e);
//			System.out.println("[ConsignmentDatabase:getConsignmentMngList]\n"+query);
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

//주차장관리 탁송에서 출고 리스트 조회
	public Vector getConsignmentMngList3(String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = " select a.*,decode(a.cons_cau,'1','대여차량인도','3','지연대차인도','4','정비대차인도','5','사고대차인도','6','정비차량인도','7','사고차량인도','17','지점이동') AS cons_st_nm "+
				" from consignment a, (select car_no, max(from_dt) from_dt from consignment where cons_cau in ('1','3','4','5','6','7','17') group by car_no) b, (select * from cont where use_yn = 'Y') c "+
				" where a.car_no = b.car_no(+) and a.rent_l_cd = c.rent_l_cd and a.from_dt = b.from_dt"+
				//" and a.from_dt IS NOT NULL and a.from_place like '%목동%' and a.out_ok is null and a.from_dt >= '20081001'";
				" and a.from_dt IS NOT NULL and (a.from_place like '%목동%' or a.from_place like '%영남%') and a.out_ok is null and a.from_dt >= '20081001'";

		if(s_kd.equals("1"))			query += " and upper(a.car_no) like upper('%"+t_wd+"%')\n";		
		if(s_kd.equals("2"))			query += " and upper(a.car_nm) like upper('%"+t_wd+"%')\n";		
		if(s_kd.equals("3"))			query += " and upper(a.from_place) like '%"+t_wd+"%'\n";	
		
		if(sort_gubun.equals("1"))		query += " order by a.car_no "+asc ;
		if(sort_gubun.equals("2"))		query += " order by a.car_nm "+asc ;
		if(sort_gubun.equals("3"))		query += " order by a.from_place "+asc ;



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
//			System.out.println("[ConsignmentDatabase:getConsignmentMngList3]\n"+query);
		} catch (SQLException e) {
			System.out.println("[ConsignmentDatabase:getConsignmentMngList]\n"+e);
//			System.out.println("[ConsignmentDatabase:getConsignmentMngList]\n"+query);
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

	//고객탁송료현황 리스트 조회
	public Vector getConsignmentCustAmtList(String s_kd, String t_wd, String gubun1, String st_dt, String end_dt, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" a.*, "+
				" nvl(a.from_dt,nvl(a.from_est_dt,a.from_req_dt)) f_dt,"+
				" nvl(a.to_dt,nvl(a.to_est_dt,a.to_req_dt)) t_dt,"+
				" c.br_id, c.user_nm as user_nm1, d.user_nm as user_nm2, b.user_dt1, b.user_dt2, "+
				" f.nm as cons_cau_nm, decode(a.cons_st,'1','편도','2','왕복') as cons_st_nm,"+
				" decode(a.pay_st,'1','선불','2','후불') pay_st_nm, decode(a.cost_st,'1','아마존카','2','고객') cost_st_nm,"+
				" decode(decode(b.user_dt1,'',0,1)+decode(b.user_dt2,'',0,1)+decode(b.user_dt3,'',0,1)+decode(a.req_dt,'',0,1)+decode(a.conf_dt,'',0,1)+decode(h.user_dt1,'',0,1)+decode(h.user_dt2,'',decode(c.br_id,'S1',0,1),1)+decode(a.pay_dt,'',0,1)"+
				"        ,1,'의뢰',2,'수신',3,'정산',4,'청구',5,'확인',6,'결재',7,'결재',8,'지급'"+
				" ) as step,"+
				" decode(substr(a.driver_nm,1,1),'0',i.user_nm,a.driver_nm) driver_nm2"+
				" from consignment a, "+
				" (select * from doc_settle where doc_st='2') b, "+
				" users c, users d, branch e, users i,"+
				" (select * from doc_settle where doc_st='3') h, "+
				" (select * from code where c_st='0015' and code<>'0000') f"+
				" where a.cost_st='2' and a.cons_no=b.doc_id(+) and b.user_id1=c.user_id(+) and b.user_id2=d.user_id(+) and c.br_id=e.br_id(+)"+
				" and a.req_code=h.doc_id(+)"+
				" and a.cons_cau=f.nm_cd(+) and a.driver_nm=i.user_id(+)";

		String search = "";
		String what = "";

		if(s_kd.equals("1"))	what = "upper(nvl(e.br_id||e.br_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(a.off_nm, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(a.from_place||a.to_place||a.from_comp||a.to_comp, ' '))";
		if(s_kd.equals("4"))	what = "upper(nvl(a.car_no, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(c.user_nm, ' '))";
		if(s_kd.equals("6"))	what = "to_char(b.user_dt1,'YYYYMMDD')";

			
		if(!s_kd.equals("") && !t_wd.equals("")){
			if(s_kd.equals("6"))	query += " and "+what+" like replace('%"+t_wd+"%', '-','')";
			else					query += " and "+what+" like upper('%"+t_wd+"%') ";
		}else{

		}	


		if(gubun1.equals("1"))			query += " and to_char(b.user_dt1,'YYYYMM') = to_char(sysdate,'YYYYMM')";
		else if(gubun1.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and to_char(b.user_dt1,'YYYYMMDD') like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and to_char(b.user_dt1,'YYYYMMDD') between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		if(gubun2.equals("1"))			query += " and a.cust_amt > 0 and a.cust_pay_dt is null";
		if(gubun2.equals("2"))			query += " and a.cust_amt > 0 and a.cust_pay_dt is not null";

		

		query += " order by a.off_id, a.cons_no, a.seq";
//System.out.println("[ConsignmentDatabase:getConsignmentCustAmtList]\n"+s_kd);
//System.out.println("[ConsignmentDatabase:getConsignmentCustAmtList]\n"+t_wd);
//System.out.println("[ConsignmentDatabase:getConsignmentCustAmtList]\n"+query);

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
			System.out.println("[ConsignmentDatabase:getConsignmentCustAmtList]\n"+e);
			System.out.println("[ConsignmentDatabase:getConsignmentCustAmtList]\n"+query);
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

	//차량별 이력조회
	public Vector getConsignmentCarList(String car_no, String from_req_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" a.*, c.user_nm as user_nm1, d.user_nm as user_nm2, b.user_dt1, b.user_dt2, f.nm as cons_cau_nm"+
				" from consignment a, doc_settle b, users c, users d, branch e, (select * from code where c_st='0015' and code<>'0000') f"+
				" where a.cons_no=b.doc_id(+) and b.doc_st='2' and b.user_id1=c.user_id(+) and b.user_id2=d.user_id(+) and c.br_id=e.br_id(+) and a.cons_cau=f.nm_cd(+)"+
				" and a.car_no=? ";
		
		if(!from_req_dt.equals(""))		query += " and substr(a.from_req_dt,1,8)=replace('"+from_req_dt+"','-','')";

		try {
								
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  car_no);
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
			System.out.println("[ConsignmentDatabase:getConsignmentCarList]\n"+e);
			System.out.println("[ConsignmentDatabase:getConsignmentCarList]\n"+query);
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

	//청구서작성 리스트 조회
	public Vector getConsignmentReqTarget(String user_id, String req_code)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" b.user_id1"+
				" from consignment a, (select * from doc_settle where doc_st='2') b"+
				" where a.cons_no=b.doc_id and a.req_dt=to_char(sysdate,'YYYYMMDD') and a.conf_dt is null and b.user_id2='"+user_id+"' and a.req_code='"+req_code+"'"+
				" group by b.user_id1 order by b.user_id1";

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
			System.out.println("[ConsignmentDatabase:getConsignmentReqTarget]\n"+e);
			System.out.println("[ConsignmentDatabase:getConsignmentReqTarget]\n"+query);
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

	public boolean updateRegCng(String cons_no, String req_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = "";

		query = " update consignment set reg_id=? where cons_no=?";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, req_id);
			pstmt.setString(2, cons_no);
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[ConsignmentDatabase:updateRegCng]\n"+e);
			System.out.println("[ConsignmentDatabase:updateRegCng]\n"+query);
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

	public boolean updateRegOffCng(String cons_no, String off_id, String off_nm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = "";

		query = " update consignment set off_id=?, off_nm=? where cons_no=?";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, off_id);
			pstmt.setString(2, off_nm);
			pstmt.setString(3, cons_no);
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[ConsignmentDatabase:updateRegOffCng]\n"+e);
			System.out.println("[ConsignmentDatabase:updateRegOffCng]\n"+query);
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

	//월별 업체별 탁송료 현황
	public Vector getConsReqStat(String brch_id, String gubun1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " select"+
				" substr(a.from_req_dt,1,6) ym,"+

				" count(decode(a.off_nm,'(주)아마존카',a.cons_no)) cnt6,"+
				" sum(decode(a.off_nm,'(주)아마존카',a.tot_amt)) amt6,"+

				" count(decode(a.off_nm,'코리아탁송',a.cons_no)) cnt1,"+
				" sum(decode(a.off_nm,'코리아탁송',a.tot_amt)) amt1,"+

				" count(decode(a.off_nm,'전국',a.cons_no)) cnt2,"+
				" sum(decode(a.off_nm,'전국',a.tot_amt)) amt2,"+

				" count(decode(c.br_id,'S1',a.cons_no)) cnt3,"+
				" sum(decode(c.br_id,'S1',a.tot_amt)) amt3,"+

				" count(decode(c.br_id,'B1',a.cons_no)) cnt4,"+
				" sum(decode(c.br_id,'B1',a.tot_amt)) amt4,"+

				" count(decode(c.br_id,'D1',a.cons_no)) cnt5,"+
				" sum(decode(c.br_id,'D1',a.tot_amt)) amt5"+

				" from consignment a, doc_settle b, users c"+
				" where a.cons_no=b.doc_id and b.doc_st='2' and b.user_id1=c.user_id"+
				" ";

		if(!brch_id.equals(""))		query += " and c.br_id = '"+brch_id+"'";

		if(!gubun1.equals(""))		query += " and a.from_req_dt like '"+gubun1+"%'";

		query += " group by substr(a.from_req_dt,1,6) order by substr(a.from_req_dt,1,6)";

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
			
			System.out.println("[ConsignmentDatabase:getConsReqStat]"+ e);
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




	//월별 업체별 탁송료 현황
	public Vector getConsPayStat(String brch_id, String gubun1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " select"+
				" substr(a.pay_dt,1,6) ym,"+

				" count(decode(a.off_nm,'(주)아마존카',a.cons_no)) cnt6,"+
				" sum(decode(a.off_nm,'(주)아마존카',a.tot_amt)) amt6,"+

				" count(decode(a.off_nm,'코리아탁송',a.cons_no)) cnt1,"+
				" sum(decode(a.off_nm,'코리아탁송',a.tot_amt)) amt1,"+

				" count(decode(a.off_nm,'전국',a.cons_no)) cnt2,"+
				" sum(decode(a.off_nm,'전국',a.tot_amt)) amt2,"+

				" count(decode(c.br_id,'S1',a.cons_no)) cnt3,"+
				" sum(decode(c.br_id,'S1',a.tot_amt)) amt3,"+

				" count(decode(c.br_id,'B1',a.cons_no)) cnt4,"+
				" sum(decode(c.br_id,'B1',a.tot_amt)) amt4,"+

				" count(decode(c.br_id,'D1',a.cons_no)) cnt5,"+
				" sum(decode(c.br_id,'D1',a.tot_amt)) amt5"+

				" from consignment a, doc_settle b, users c"+
				" where a.cons_no=b.doc_id and b.doc_st='2' and b.user_id1=c.user_id and a.pay_dt is not null"+
				" ";

		if(!brch_id.equals(""))		query += " and c.br_id = '"+brch_id+"'";

		if(!gubun1.equals(""))		query += " and a.pay_dt like '"+gubun1+"%'";

		query += " group by substr(a.pay_dt,1,6)";

		query += " union all";

		query += " select"+
				" '예정' ym,"+

				" count(decode(a.off_nm,'(주)아마존카',a.cons_no)) cnt6,"+
				" sum(decode(a.off_nm,'(주)아마존카',a.tot_amt)) amt6,"+

				" count(decode(a.off_nm,'코리아탁송',a.cons_no)) cnt1,"+
				" sum(decode(a.off_nm,'코리아탁송',a.tot_amt)) amt1,"+

				" count(decode(a.off_nm,'전국',a.cons_no)) cnt2,"+
				" sum(decode(a.off_nm,'전국',a.tot_amt)) amt2,"+

				" count(decode(c.br_id,'S1',a.cons_no)) cnt3,"+
				" sum(decode(c.br_id,'S1',a.tot_amt)) amt3,"+

				" count(decode(c.br_id,'B1',a.cons_no)) cnt4,"+
				" sum(decode(c.br_id,'B1',a.tot_amt)) amt4,"+

				" count(decode(c.br_id,'D1',a.cons_no)) cnt5,"+
				" sum(decode(c.br_id,'D1',a.tot_amt)) amt5"+

				" from consignment a, doc_settle b, users c"+
				" where a.cons_no=b.doc_id and b.doc_st='2' and b.user_id1=c.user_id and a.pay_dt is null"+
				" ";
		if(!brch_id.equals(""))		query += " and c.br_id = '"+brch_id+"'";

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
			
			System.out.println("[ConsignmentDatabase:getConsPayStat]"+ e);
			System.out.println("[ConsignmentDatabase:getConsPayStat]"+ query);
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

	//사원별 탁송료 현황
	public Vector getConsReqUserStat(String brch_id, String gubun1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " select"+
				" d.nm, c.user_nm, c.user_id, "+

				" count(a.cons_no) cnt0,"+	
				" count(decode(substr(a.from_req_dt,5,2),'01',a.cons_no)) cnt1,"+
				" count(decode(substr(a.from_req_dt,5,2),'02',a.cons_no)) cnt2,"+
				" count(decode(substr(a.from_req_dt,5,2),'03',a.cons_no)) cnt3,"+
				" count(decode(substr(a.from_req_dt,5,2),'04',a.cons_no)) cnt4,"+
				" count(decode(substr(a.from_req_dt,5,2),'05',a.cons_no)) cnt5,"+
				" count(decode(substr(a.from_req_dt,5,2),'06',a.cons_no)) cnt6,"+
				" count(decode(substr(a.from_req_dt,5,2),'07',a.cons_no)) cnt7,"+
				" count(decode(substr(a.from_req_dt,5,2),'08',a.cons_no)) cnt8,"+
				" count(decode(substr(a.from_req_dt,5,2),'09',a.cons_no)) cnt9,"+
				" count(decode(substr(a.from_req_dt,5,2),'10',a.cons_no)) cnt10,"+
				" count(decode(substr(a.from_req_dt,5,2),'11',a.cons_no)) cnt11,"+
				" count(decode(substr(a.from_req_dt,5,2),'12',a.cons_no)) cnt12"+

				" from consignment a, doc_settle b, users c, (select * from code where c_st='0002' and code<>'0000') d"+
				" where a.cons_no=b.doc_id and b.doc_st='2' and b.user_id1=c.user_id and c.dept_id=d.code"+
				" ";

		if(!brch_id.equals(""))		query += " and c.br_id = '"+brch_id+"'";

		if(!gubun1.equals(""))		query += " and a.from_req_dt like '"+gubun1+"%'";

		query += " group by d.nm, c.user_nm, c.user_id";

		query += " order by count(a.cons_no) desc";

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
			
			System.out.println("[ConsignmentDatabase:getConsReqUserStat]"+ e);
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

	//사원별 탁송료 현황
	public Vector getConsReqUserStat2(String brch_id, String gubun1, String st_dt, String end_dt, String sort)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "", query3 = "";
					
		query1 = " select"+
				" b.user_id1, "+

				" count(a.cons_no) cnt0,"+	
				" sum(a.tot_amt) amt0,"+

				" count(decode(a.off_nm,'(주)아마존카',a.cons_no)) cnt4,"+
				" sum(decode(a.off_nm,'(주)아마존카',a.tot_amt)) amt4,"+

				" sum(decode(a.off_nm,'(주)아마존카',decode(a.driver_nm,b.user_id1,-c.app_st*decode(a.cons_st,'1',1,c.cms_bk), -c.app_st*decode(a.cons_st,'1',1,c.cms_bk)))) amt8,"+

				" count(decode(a.off_nm,'코리아탁송',a.cons_no)) cnt5,"+
				" sum(decode(a.off_nm,'코리아탁송',a.tot_amt)) amt5,"+

				" count(decode(a.off_nm,'전국',a.cons_no)) cnt6,"+
				" sum(decode(a.off_nm,'전국',a.tot_amt)) amt6"+

				" from consignment a, doc_settle b, (select * from code where c_st='0022') c"+
				" where a.seq=1 and a.cons_no=b.doc_id and a.cmp_app=c.nm_cd(+) and a.driver_nm is not null and b.doc_st='2' "+
				" ";

		if(!st_dt.equals(""))		query1 += " and substr(nvl(a.from_dt,a.from_req_dt),1,8) between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') ";

		query1 += " group by b.user_id1";

//		System.out.println("[ConsignmentDatabase:getConsReqUserStat2]"+ query1);

		//본인탁송
		query2 = " select"+
				" a.driver_nm, "+

				" count(decode(a.driver_nm,b.user_id1,a.cons_no)) cnt1,"+
				" sum(decode(a.driver_nm,b.user_id1,c.app_st*decode(a.cons_st,'1',1,c.cms_bk))) amt1,"+

				" count(decode(a.driver_nm,'','',b.user_id1,'',a.cons_no)) cnt2,"+
				" sum(decode(a.driver_nm,'','',b.user_id1,'',c.app_st*decode(a.cons_st,'1',1,c.cms_bk))) amt2"+

				" from consignment a, doc_settle b, (select * from code where c_st='0022') c"+
				" where a.seq=1 and a.cons_no=b.doc_id and a.cmp_app=c.nm_cd(+) and a.driver_nm is not null and b.doc_st='2' "+
				" and a.off_id='003158'"+
				" ";

		if(!st_dt.equals(""))		query2 += " and substr(nvl(a.from_dt,a.from_req_dt),1,8) between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') ";

		query2 += " group by a.driver_nm";


		//탁송대기
		query3 = " select user_id, count(*) cnt7 from cons_standby where standby_st <>'4' ";

		if(!st_dt.equals(""))		query3 += " and standby_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') ";

		query3 += " group by user_id";
		


		query = " select c.nm, c.user_nm, c.user_id, a.*, b.cnt1, b.amt1, b.cnt2, b.amt2, (b.cnt1+b.cnt2) cnt3, (nvl(b.amt1,0)+nvl(b.amt2,0)) amt3, d.cnt7, a.amt8, (nvl(b.amt1,0)+nvl(b.amt2,0)+nvl(a.amt8,0)) amt9 "+
				" from "+
				" (select b.nm, a.* from users a, (select * from code where c_st='0002' and code<>'0000') b where a.use_yn='Y' and (a.loan_st is not null or a.user_id in ('000031','000038')) and a.dept_id=b.code) c, "+
				" ("+query1+") a, ("+query2+") b, ("+query3+") d  "+
				" where c.user_id=a.user_id1(+) and c.user_id=b.driver_nm(+) and c.user_id=d.user_id(+) "+
				" and (nvl(d.cnt7,0)+nvl(b.cnt1,0)+nvl(b.cnt2,0)+nvl(a.cnt0,0))>0";

		if(!brch_id.equals(""))		query += " and c.br_id = '"+brch_id+"'";


		query += " order by (nvl(b.cnt1,0)+nvl(b.cnt2,0)) desc, nvl(d.cnt7,0) desc, nvl(a.cnt0,0) desc, decode(c.br_id,'S1',1,'B1',2,'D1',3), c.dept_id, c.enter_dt";

//System.out.println("[ConsignmentDatabase:getConsReqUserStat2]"+ query);

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
			System.out.println("[ConsignmentDatabase:getConsReqUserStat2]"+ e);
			System.out.println("[ConsignmentDatabase:getConsReqUserStat2]"+ query);
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

	//사원별 탁송료 현황
	public Vector getConsStandbyUserList(String brch_id, String standby_dt1, String standby_dt2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "", query3 = "";
					
		query1 = " select * from cons_standby where standby_dt = replace('"+standby_dt1+"','-','') ";

		query2 = " select * from cons_standby where standby_dt = replace('"+standby_dt2+"','-','') ";


		query = " select c.nm, c.user_nm, c.user_id, "+
				" decode(a.standby_st,'1','●') cnt1, "+
				" decode(a.standby_st,'2','●') cnt2, "+
				" decode(a.standby_st,'3','●') cnt3, "+
				" decode(a.standby_st,'4','●') cnt4, "+
				" decode(b.standby_st,'1','●') cnt5, "+
				" decode(b.standby_st,'2','●') cnt6, "+
				" decode(b.standby_st,'3','●') cnt7, "+
				" decode(b.standby_st,'4','●') cnt8 "+
				" from "+
				" (select b.nm, a.* from users a, (select * from code where c_st='0002' and code<>'0000') b where a.use_yn='Y' and (a.loan_st is not null or a.user_id in ('000031','000038')) and a.dept_id=b.code) c, "+
				" ("+query1+") a, ("+query2+") b  "+
				" where c.user_id=a.user_id(+) and c.user_id=b.user_id(+)";

		if(!brch_id.equals(""))		query += " and c.br_id = '"+brch_id+"'";


		query += " order by decode(c.br_id,'S1',1,'B1',2,'D1',3), c.dept_id, c.enter_dt";

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
			System.out.println("[ConsignmentDatabase:getConsStandbyUserList]"+ e);
			System.out.println("[ConsignmentDatabase:getConsStandbyUserList]"+ query);
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


//한건 조회2
	public ConsignmentBean getConsignment2(String cons_no, String car_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ConsignmentBean bean = new ConsignmentBean();
		String query = "";

	
		query = " select * from consignment where cons_no = ? and car_no = ? ";
		
		String query2 = " update consignment set out_ok='Y' where cons_no=? and car_no = ?";  //정상적으로 값이 넘어 갔으면 out_ok 에 Y를 넣어줌

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, cons_no);
			pstmt.setString(2, car_no);
		   	rs = pstmt.executeQuery();
   	
			pstmt = conn.prepareStatement(query2);
			pstmt.setString(1, cons_no);
			pstmt.setString(2, car_no);
		   	pstmt.executeUpdate();

			if(rs.next())
			{
				bean.setCons_no				(rs.getString("cons_no")			==null?"":rs.getString("cons_no"));
				bean.setSeq						(rs.getInt     ("seq"));
				bean.setCons_st				(rs.getString("cons_st")			==null?"":rs.getString("cons_st"));
				bean.setCons_su				(rs.getInt     ("cons_su"));
				bean.setReg_code				(rs.getString("reg_code")			==null?"":rs.getString("reg_code"));
	 			bean.setOff_id					(rs.getString("off_id")				==null?"":rs.getString("off_id"));	
	 			bean.setOff_nm				(rs.getString("off_nm")				==null?"":rs.getString("off_nm"));	
				bean.setCar_mng_id			(rs.getString("car_mng_id")		==null?"":rs.getString("car_mng_id"));
				bean.setRent_mng_id		(rs.getString("rent_mng_id")	==null?"":rs.getString("rent_mng_id"));
				bean.setRent_l_cd			(rs.getString("rent_l_cd")			==null?"":rs.getString("rent_l_cd"));
				bean.setClient_id				(rs.getString("client_id")			==null?"":rs.getString("client_id"));
				bean.setCar_no				(rs.getString("car_no")				==null?"":rs.getString("car_no"));	
				bean.setCar_nm				(rs.getString("car_nm")			==null?"":rs.getString("car_nm"));
				bean.setCons_cau				(rs.getString("cons_cau")			==null?"":rs.getString("cons_cau"));
				bean.setCons_cau_etc		(rs.getString("cons_cau_etc")	==null?"":rs.getString("cons_cau_etc"));
				bean.setCost_st				(rs.getString("cost_st")				==null?"":rs.getString("cost_st"));
				bean.setPay_st					(rs.getString("pay_st")				==null?"":rs.getString("pay_st"));
				bean.setFrom_st				(rs.getString("from_st")			==null?"":rs.getString("from_st"));
				bean.setFrom_place			(rs.getString("from_place")		==null?"":rs.getString("from_place"));	
				bean.setFrom_comp			(rs.getString("from_comp")		==null?"":rs.getString("from_comp"));	
				bean.setFrom_title			(rs.getString("from_title")			==null?"":rs.getString("from_title"));	
				bean.setFrom_man			(rs.getString("from_man")		==null?"":rs.getString("from_man"));	
				bean.setFrom_tel				(rs.getString("from_tel")			==null?"":rs.getString("from_tel"));	
				bean.setFrom_m_tel			(rs.getString("from_m_tel")		==null?"":rs.getString("from_m_tel"));	
				bean.setFrom_req_dt		(rs.getString("from_req_dt")		==null?"":rs.getString("from_req_dt"));
				bean.setFrom_est_dt		(rs.getString("from_est_dt")		==null?"":rs.getString("from_est_dt"));
				bean.setFrom_dt				(rs.getString("from_dt")			==null?"":rs.getString("from_dt"));
				bean.setTo_st					(rs.getString("to_st")				==null?"":rs.getString("to_st"));
				bean.setTo_place				(rs.getString("to_place")			==null?"":rs.getString("to_place"));	
				bean.setTo_comp				(rs.getString("to_comp")			==null?"":rs.getString("to_comp"));	
				bean.setTo_title				(rs.getString("to_title")				==null?"":rs.getString("to_title"));	
				bean.setTo_man				(rs.getString("to_man")			==null?"":rs.getString("to_man"));	
				bean.setTo_tel					(rs.getString("to_tel")				==null?"":rs.getString("to_tel"));	
				bean.setTo_m_tel				(rs.getString("to_m_tel")			==null?"":rs.getString("to_m_tel"));	
				bean.setTo_req_dt			(rs.getString("to_req_dt")			==null?"":rs.getString("to_req_dt"));
				bean.setTo_est_dt				(rs.getString("to_est_dt")			==null?"":rs.getString("to_est_dt"));
				bean.setTo_dt					(rs.getString("to_dt")				==null?"":rs.getString("to_dt"));
				bean.setDriver_nm			(rs.getString("driver_nm")		==null?"":rs.getString("driver_nm"));
				bean.setDriver_m_tel		(rs.getString("driver_m_tel")	==null?"":rs.getString("driver_m_tel"));
				bean.setWash_yn				(rs.getString("wash_yn")			==null?"":rs.getString("wash_yn"));
				bean.setOil_yn					(rs.getString("oil_yn")				==null?"":rs.getString("oil_yn"));
				bean.setOil_liter				(rs.getInt     ("oil_liter"));
				bean.setOil_est_amt			(rs.getInt     ("oil_est_amt"));
				bean.setEtc						(rs.getString("etc")					==null?"":rs.getString("etc"));
				bean.setCons_amt			(rs.getInt     ("cons_amt"));
				bean.setOil_amt				(rs.getInt     ("oil_amt"));
				bean.setWash_amt			(rs.getInt     ("wash_amt"));	
				bean.setOther					(rs.getString("other")				==null?"":rs.getString("other"));
				bean.setOther_amt			(rs.getInt     ("other_amt"));
				bean.setTot_amt				(rs.getInt     ("tot_amt"));	
				bean.setPay_dt					(rs.getString("pay_dt")				==null?"":rs.getString("pay_dt"));
				bean.setReq_dt					(rs.getString("req_dt")				==null?"":rs.getString("req_dt"));
				bean.setReq_code				(rs.getString("req_code")			==null?"":rs.getString("req_code"));
				bean.setCust_amt				(rs.getInt     ("cust_amt"));	
				bean.setCust_pay_dt		(rs.getString("cust_pay_dt")		==null?"":rs.getString("cust_pay_dt"));
				bean.setConf_dt				(rs.getString("conf_dt")			==null?"":rs.getString("conf_dt"));
				bean.setCons_copy			(rs.getString("cons_copy")		==null?"":rs.getString("cons_copy"));
				bean.setWash_fee				(rs.getInt     ("wash_fee"));
									
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ConsignmentDatabase:getConsignment]\n"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}				
	}
	
	//한건 조회3
	public ConsignmentBean getConsignment3(String cons_no, String car_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ConsignmentBean bean = new ConsignmentBean();
		String query = "";
	
		query = " select * from consignment where cons_no = ? and car_no = ? ";
		
		String query2 = " update consignment set out_ok='Y' where cons_no=? and car_no = ?";  //정상적으로 값이 넘어 갔으면 out_ok 에 Y를 넣어줌

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, cons_no);
			pstmt.setString(2, car_no);
		   	rs = pstmt.executeQuery();
   	
			pstmt = conn.prepareStatement(query2);
			pstmt.setString(1, cons_no);
			pstmt.setString(2, car_no);
		   	pstmt.executeUpdate();

			if(rs.next())
			{
				bean.setCons_no				(rs.getString("cons_no")			==null?"":rs.getString("cons_no"));
				bean.setSeq						(rs.getInt     ("seq"));
				bean.setCons_st				(rs.getString("cons_st")			==null?"":rs.getString("cons_st"));
				bean.setCons_su				(rs.getInt     ("cons_su"));
				bean.setReg_code				(rs.getString("reg_code")			==null?"":rs.getString("reg_code"));
	 			bean.setOff_id					(rs.getString("off_id")				==null?"":rs.getString("off_id"));	
	 			bean.setOff_nm				(rs.getString("off_nm")				==null?"":rs.getString("off_nm"));	
				bean.setCar_mng_id			(rs.getString("car_mng_id")		==null?"":rs.getString("car_mng_id"));
				bean.setRent_mng_id		(rs.getString("rent_mng_id")	==null?"":rs.getString("rent_mng_id"));
				bean.setRent_l_cd			(rs.getString("rent_l_cd")			==null?"":rs.getString("rent_l_cd"));
				bean.setClient_id				(rs.getString("client_id")			==null?"":rs.getString("client_id"));
				bean.setCar_no				(rs.getString("car_no")				==null?"":rs.getString("car_no"));	
				bean.setCar_nm				(rs.getString("car_nm")			==null?"":rs.getString("car_nm"));
				bean.setCons_cau				(rs.getString("cons_cau")			==null?"":rs.getString("cons_cau"));
				bean.setCons_cau_etc		(rs.getString("cons_cau_etc")	==null?"":rs.getString("cons_cau_etc"));
				bean.setCost_st				(rs.getString("cost_st")				==null?"":rs.getString("cost_st"));
				bean.setPay_st					(rs.getString("pay_st")				==null?"":rs.getString("pay_st"));
				bean.setFrom_st				(rs.getString("from_st")			==null?"":rs.getString("from_st"));
				bean.setFrom_place			(rs.getString("from_place")		==null?"":rs.getString("from_place"));	
				bean.setFrom_comp			(rs.getString("from_comp")		==null?"":rs.getString("from_comp"));	
				bean.setFrom_title			(rs.getString("from_title")			==null?"":rs.getString("from_title"));	
				bean.setFrom_man			(rs.getString("from_man")		==null?"":rs.getString("from_man"));	
				bean.setFrom_tel				(rs.getString("from_tel")			==null?"":rs.getString("from_tel"));	
				bean.setFrom_m_tel			(rs.getString("from_m_tel")		==null?"":rs.getString("from_m_tel"));	
				bean.setFrom_req_dt		(rs.getString("from_req_dt")		==null?"":rs.getString("from_req_dt"));
				bean.setFrom_est_dt		(rs.getString("from_est_dt")		==null?"":rs.getString("from_est_dt"));
				bean.setFrom_dt				(rs.getString("from_dt")			==null?"":rs.getString("from_dt"));
				bean.setTo_st					(rs.getString("to_st")				==null?"":rs.getString("to_st"));
				bean.setTo_place				(rs.getString("to_place")			==null?"":rs.getString("to_place"));	
				bean.setTo_comp				(rs.getString("to_comp")			==null?"":rs.getString("to_comp"));	
				bean.setTo_title				(rs.getString("to_title")				==null?"":rs.getString("to_title"));	
				bean.setTo_man				(rs.getString("to_man")			==null?"":rs.getString("to_man"));	
				bean.setTo_tel					(rs.getString("to_tel")				==null?"":rs.getString("to_tel"));	
				bean.setTo_m_tel				(rs.getString("to_m_tel")			==null?"":rs.getString("to_m_tel"));	
				bean.setTo_req_dt			(rs.getString("to_req_dt")			==null?"":rs.getString("to_req_dt"));
				bean.setTo_est_dt				(rs.getString("to_est_dt")			==null?"":rs.getString("to_est_dt"));
				bean.setTo_dt					(rs.getString("to_dt")				==null?"":rs.getString("to_dt"));
				bean.setDriver_nm			(rs.getString("driver_nm")		==null?"":rs.getString("driver_nm"));
				bean.setDriver_m_tel		(rs.getString("driver_m_tel")	==null?"":rs.getString("driver_m_tel"));
				bean.setWash_yn				(rs.getString("wash_yn")			==null?"":rs.getString("wash_yn"));
				bean.setOil_yn					(rs.getString("oil_yn")				==null?"":rs.getString("oil_yn"));
				bean.setOil_liter				(rs.getInt     ("oil_liter"));
				bean.setOil_est_amt			(rs.getInt     ("oil_est_amt"));
				bean.setEtc						(rs.getString("etc")					==null?"":rs.getString("etc"));
				bean.setCons_amt			(rs.getInt     ("cons_amt"));
				bean.setOil_amt				(rs.getInt     ("oil_amt"));
				bean.setWash_amt			(rs.getInt     ("wash_amt"));	
				bean.setOther					(rs.getString("other")				==null?"":rs.getString("other"));
				bean.setOther_amt			(rs.getInt     ("other_amt"));
				bean.setTot_amt				(rs.getInt     ("tot_amt"));	
				bean.setPay_dt					(rs.getString("pay_dt")				==null?"":rs.getString("pay_dt"));
				bean.setReq_dt					(rs.getString("req_dt")				==null?"":rs.getString("req_dt"));
				bean.setReq_code				(rs.getString("req_code")			==null?"":rs.getString("req_code"));
				bean.setCust_amt				(rs.getInt     ("cust_amt"));	
				bean.setCust_pay_dt		(rs.getString("cust_pay_dt")		==null?"":rs.getString("cust_pay_dt"));
				bean.setConf_dt				(rs.getString("conf_dt")			==null?"":rs.getString("conf_dt"));
				bean.setCons_copy			(rs.getString("cons_copy")		==null?"":rs.getString("cons_copy"));
				bean.setWash_fee				(rs.getInt     ("wash_fee"));
									
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ConsignmentDatabase:getConsignment]\n"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}				
	}
	
	//출고탁송 검색조건 조회
	public Vector getConsCostSearchList(String gubun, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		if(gubun.equals("1")){
			query = " select a.off_id as id, b.off_nm as nm from cons_cost a, serv_off b where a.off_id=b.off_id group by a.off_id, b.off_nm ";
		}else if(gubun.equals("2")){
			query = " select cost_b_dt as id, cost_b_dt as nm from cons_cost group by cost_b_dt";
		}else if(gubun.equals("3")){
			query = " select a.car_comp_id as id, b.nm as nm from cons_cost a, (select * from code where c_st='0001') b where a.car_comp_id=b.code group by a.car_comp_id, b.nm ";
		}else if(gubun.equals("4")){
			query = " select a.car_cd as id, b.car_nm as nm from cons_cost a, car_mng b where a.car_comp_id=b.car_comp_id and a.car_cd=b.code group by a.car_cd, b.car_nm ";
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
			System.out.println("[ConsignmentDatabase:getConsCostSearchList]\n"+e);
			System.out.println("[ConsignmentDatabase:getConsCostSearchList]\n"+query);
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

	public boolean insertConsCost(String off_id, String cost_b_dt, String car_comp_id, String car_cd, String from_place, int to_place1, int to_place2, int to_place3, String car_nm, String car_comp_nm)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query =  " insert into cons_cost "+
						" ( off_id, cost_b_dt, car_comp_id, car_cd, from_place, to_place1, to_place2, to_place3, car_nm, car_comp_nm ) "+
						"  values "+
						" ( ?, replace(?,'-',''), ?, ?, ?,    ?, ?, ?, ?, replace(?,'㈜','') "+
						" )";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);		
			pstmt.setString(1,  off_id);
			pstmt.setString(2,  cost_b_dt);
			pstmt.setString(3,  car_comp_id);
			pstmt.setString(4,  car_cd);
			pstmt.setString(5,  from_place);
			pstmt.setInt   (6,  to_place1);
			pstmt.setInt   (7,  to_place2);
			pstmt.setInt   (8,  to_place3);
			pstmt.setString(9,  car_nm);
			pstmt.setString(10, car_comp_nm);
			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[ConsignmentDatabase:insertConsCost]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	public boolean insertConsCost(String off_id, String cost_b_dt, String car_comp_id, String car_cd, String from_place, int to_place1, int to_place2, int to_place3, int to_place4, int to_place5, String car_nm, String car_comp_nm)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query =  " insert into cons_cost "+
						" ( off_id, cost_b_dt, car_comp_id, car_cd, from_place, to_place1, to_place2, to_place3, to_place4, to_place5, car_nm, car_comp_nm ) "+
						"  values "+
						" ( ?, replace(?,'-',''), ?, ?, ?,    ?, ?, ?, ?, ?, ?, replace(?,'㈜','') "+
						" )";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);		
			pstmt.setString(1,  off_id);
			pstmt.setString(2,  cost_b_dt);
			pstmt.setString(3,  car_comp_id);
			pstmt.setString(4,  car_cd);
			pstmt.setString(5,  from_place);
			pstmt.setInt   (6,  to_place1);
			pstmt.setInt   (7,  to_place2);
			pstmt.setInt   (8,  to_place3);
			pstmt.setInt   (9,  to_place4);
			pstmt.setInt   (10, to_place5);
			pstmt.setString(11, car_nm);
			pstmt.setString(12, car_comp_nm);
			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[ConsignmentDatabase:insertConsCost]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//출고탁송 리스트 조회
	public Vector getConsCostList(String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String s_kd, String t_wd, String sort)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" a.off_id, a.cost_b_dt, a.car_comp_id, a.car_cd, a.from_place, a.to_place1, a.to_place2, a.to_place3, a.to_place4, a.to_place5, a.car_nm, a.car_comp_nm, d.off_nm, nvl(a.use_yn,'Y') use_yn "+
				" from cons_cost a, serv_off d"+
				" where a.off_id=d.off_id";

		if(!gubun1.equals(""))	query += " and a.off_id			 like '%"+gubun1+"%'";
		if(!gubun2.equals(""))	query += " and a.cost_b_dt		 = '"+gubun2+"' ";
		if(!gubun3.equals(""))	query += " and a.car_comp_nm	 like '%"+gubun3+"%'";
		if(!gubun4.equals(""))	query += " and a.car_nm			 like '%"+gubun4+"%'";
		if(gubun5.equals("Y"))	query += " and nvl(a.use_yn,'Y')='Y'";
		if(gubun5.equals("N"))	query += " and nvl(a.use_yn,'Y')='N'";

		String search = "";
		String what = "";

		if(s_kd.equals("1"))	what = "upper(nvl(a.from_place, ' '))";
			
		if(!s_kd.equals("") && !t_wd.equals("")){
			if(s_kd.equals("6"))	query += " and "+what+" like replace('%"+t_wd+"%', '-','')";
			else					query += " and "+what+" like upper('%"+t_wd+"%') ";
		}else{

		}	

		query += " order by a.off_id, a.car_comp_id, a.car_cd, a.cost_b_dt";

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
			System.out.println("[ConsignmentDatabase:getConsCostList]\n"+e);
			System.out.println("[ConsignmentDatabase:getConsCostList]\n"+query);
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

	//출고탁송 리스트 조회
	public Vector getConsCostSearchList(String off_id, String car_comp_id, String car_cd, String dlv_ext, String udt_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" a.off_id, a.cost_b_dt, a.car_comp_id, a.car_cd, a.from_place, a.to_place1, a.to_place2, a.to_place3, a.to_place4, a.to_place5, nvl(a.car_nm,b.car_nm) car_nm, nvl(a.car_comp_nm,c.nm) car_comp_nm, d.off_nm "+
				" from cons_cost a, car_mng b, (select * from code where c_st='0001') c, serv_off d"+
				" where a.car_comp_id=b.car_comp_id(+) and a.car_cd=b.code(+) and a.car_comp_id=c.code(+)"+
				" and a.off_id=d.off_id";


		if(car_comp_id.equals("0000")){
			query += " and a.car_nm	= '지점간이동' ";
		}else{
			if(!off_id.equals(""))		query += " and a.off_id			= '"+off_id+"' ";
			if(!car_comp_id.equals(""))	query += " and a.car_comp_id	= '"+car_comp_id+"' ";
		}

		if(!off_id.equals("007751") && !off_id.equals("009026") && !off_id.equals("011372") && !off_id.equals("010265") && !off_id.equals("010266")){
			if(!car_cd.equals(""))		query += " and a.car_cd			= '"+car_cd+"' ";
		}

		if(!dlv_ext.equals(""))		query += " and a.from_place		= '"+dlv_ext+"' ";


		query += " and nvl(a.use_yn,'Y')<>'N'";

		query += " order by a.cost_b_dt, a.car_comp_id, a.car_cd, a.from_place, a.to_place1";



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
			System.out.println("[ConsignmentDatabase:getConsCostSearchList]\n"+e);
			System.out.println("[ConsignmentDatabase:getConsCostSearchList]\n"+query);
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

	//오늘탁송대기 조회
	public String getConsStandbySt(String user_id, String standby_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String standby_st = "";

		query = " select standby_st from cons_standby where user_id=? and standby_dt=replace(?,'-','')";

		try {
								
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  user_id);
			pstmt.setString(2,  standby_dt);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{	
				standby_st = rs.getString("standby_st")==null?"":rs.getString("standby_st");
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ConsignmentDatabase:getConsStandbySt]\n"+e);
			System.out.println("[ConsignmentDatabase:getConsStandbySt]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return standby_st;
		}		
	}

	public boolean insertConsStandby(String user_id, String standby_dt, String standby_st)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query =  " insert into cons_standby ( user_id, standby_dt, standby_st ) values ( ?, replace(?,'-',''), ? )";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);		
			pstmt.setString(1,  user_id);
			pstmt.setString(2,  standby_dt);
			pstmt.setString(3,  standby_st);
			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[ConsignmentDatabase:insertConsStandby]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	public boolean updateConsStandby(String user_id, String standby_dt, String standby_st)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query =  " update cons_standby set standby_st=? where user_id=? and standby_dt=replace(?,'-','')";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);		
			pstmt.setString(1,  standby_st);
			pstmt.setString(2,  user_id);
			pstmt.setString(3,  standby_dt);
			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[ConsignmentDatabase:updateConsStandby]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//자체출고대기자리스트
	public Vector getConsStandbyList(String br_id, String standby_dt, String standby_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" b.*"+
				" from cons_standby a, users b"+
				" where a.user_id=b.user_id "+
				" and a.standby_dt=replace('"+standby_dt+"','-','') and a.standby_st in ('1','"+standby_st+"')";

//		if(!br_id.equals("")) query+= " and b.br_id = '"+br_id+"' ";

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
			System.out.println("[ConsignmentDatabase:getConsStandbyList]\n"+e);
			System.out.println("[ConsignmentDatabase:getConsStandbyList]\n"+query);
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

	//납품청구현황 리스트 조회
	public Vector getConsReqDocSmsConfList(String s_kd, String t_wd, String gubun1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";

		sub_query = " select"+
					" a.*, b.user_id2, b.user_id1, c.user_nm as user_nm1, d.user_nm as user_nm2, b.user_dt1, b.user_dt2, f.nm as cons_cau_nm, decode(a.cons_st,'1','편도','2','왕복') as cons_st_nm,"+
					" decode(a.pay_st,'1','선불','2','후불') pay_st_nm, decode(a.cost_st,'1','아마존카','2','고객') cost_st_nm, g.firm_nm"+
					" from consignment a, (select * from doc_settle where doc_st='2') b, users c, users d, branch e, (select * from code where c_st='0015' and code<>'0000') f, client g"+
					" where a.off_id<>'003158' and a.cons_no=b.doc_id(+) and b.user_id1=c.user_id(+) and b.user_id2=d.user_id(+) and c.br_id=e.br_id(+) and a.cons_cau=f.nm_cd(+) and a.client_id=g.client_id(+)"+
					" and a.req_dt is not null"+
					" and a.pay_dt is null and a.conf_dt is null";

		String search = "";
		String what = "";

		if(s_kd.equals("1"))	what = "upper(nvl(e.br_id||e.br_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(a.off_nm, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(a.from_place||a.to_place||a.from_comp||a.to_comp, ' '))";
		if(s_kd.equals("4"))	what = "upper(nvl(a.car_no, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(c.user_nm, ' '))";
		if(s_kd.equals("6"))	what = "to_char(b.user_dt1,'YYYYMMDD')";

			
		if(!s_kd.equals("") && !t_wd.equals("")){
			if(s_kd.equals("6"))	query += " and "+what+" like replace('%"+t_wd+"%', '-','')";
			else					query += " and "+what+" like upper('%"+t_wd+"%') ";
		}else{

		}	


		query = " select off_nm, user_id2, user_id1, car_no from ( "+sub_query+" ) group by off_nm, user_id2, user_id1, car_no";

//System.out.println("[ConsignmentDatabase:getConsReqDocSmsConfList]\n"+query);

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
			System.out.println("[ConsignmentDatabase:getConsReqDocSmsConfList]\n"+e);
			System.out.println("[ConsignmentDatabase:getConsReqDocSmsConfList]\n"+query);
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


//탁송 미확인 담당자별 현황 건수 조회 - 탁송미확인 담당자 문자 보낼 수 조회
	public Vector getConsReqDocSmsConfList_SU(String s_kd, String t_wd, String gubun1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";

		sub_query = " select"+
					" a.*, b.user_id2, b.user_id1, c.user_nm as user_nm1, d.user_nm as user_nm2, b.user_dt1, b.user_dt2, f.nm as cons_cau_nm, decode(a.cons_st,'1','편도','2','왕복') as cons_st_nm,"+
					" decode(a.pay_st,'1','선불','2','후불') pay_st_nm, decode(a.cost_st,'1','아마존카','2','고객') cost_st_nm, g.firm_nm"+
					" from consignment a, (select * from doc_settle where doc_st='2') b, users c, users d, branch e, (select * from code where c_st='0015' and code<>'0000') f, client g"+
					" where a.off_id<>'003158' and a.cons_no=b.doc_id(+) and b.user_id1=c.user_id(+) and b.user_id2=d.user_id(+) and c.br_id=e.br_id(+) and a.cons_cau=f.nm_cd(+) and a.client_id=g.client_id(+)"+
					" and a.req_dt is not null"+
					" and a.pay_dt is null and a.conf_dt is null";

		String search = "";
		String what = "";

		if(s_kd.equals("1"))	what = "upper(nvl(e.br_id||e.br_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(a.off_nm, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(a.from_place||a.to_place||a.from_comp||a.to_comp, ' '))";
		if(s_kd.equals("4"))	what = "upper(nvl(a.car_no, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(c.user_nm, ' '))";
		if(s_kd.equals("6"))	what = "to_char(b.user_dt1,'YYYYMMDD')";

			
		if(!s_kd.equals("") && !t_wd.equals("")){
			if(s_kd.equals("6"))	query += " and "+what+" like replace('%"+t_wd+"%', '-','')";
			else					query += " and "+what+" like upper('%"+t_wd+"%') ";
		}else{

		}	


		query = " select user_id1, agent_emp_id, off_nm, count(user_id1) su from (select off_nm, user_id2, user_id1, agent_emp_id, car_no from ( "+sub_query+" ) group by off_nm, user_id2, user_id1, agent_emp_id, car_no) group by user_id1, agent_emp_id, off_nm ";

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
			System.out.println("[ConsignmentDatabase:getConsReqDocSmsConfList]\n"+e);
			System.out.println("[ConsignmentDatabase:getConsReqDocSmsConfList]\n"+query);
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


	/** 2009-11-16 류길선 추가
	 * 고객 사원 조회
	 */	
	public Vector getSManSearch(String s_br, String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "", query3 = "", query4 = "", query5 = "", query6 = "";
		String where = "";

		if(s_kd.equals("3") && !t_wd.equals(""))		where += " and b.client_id in (select client_id from cont where rent_l_cd='"+t_wd+"') ";


		query1 = " select '계약자' gubun, b.client_nm nm, '대표이사' title, b.o_tel tel, b.m_tel from client b where b.client_st<>'2' "+where+" ";

		query2 = " select '세금계산서' gubun, b.con_agnt_nm nm, b.con_agnt_dept||' '||b.con_agnt_title title, b.con_agnt_o_tel tel, b.con_agnt_m_tel m_tel from client b where b.con_agnt_nm is not null  "+where+" ";

		query3 = " select '지점' gubun, a.site_jang nm, '지점장' title, a.tel tel, '' m_tel from client_site a, client b where a.client_id=b.client_id and a.site_jang is not null  "+where+" ";

		query4 = " select '세금계산서' gubun, a.agnt_nm nm, a.agnt_dept||' '||a.agnt_title title, a.tel tel, a.agnt_m_tel m_tel from client_site a, client b where a.client_id=b.client_id and a.site_jang is not null  "+where+" ";

		query5 = " select distinct c.mgr_st gubun, c.mgr_nm nm, c.mgr_dept||' '||c.mgr_title title, c.mgr_tel tel, c.mgr_m_tel m_tel from cont a, client b, car_mgr c where a.client_id=b.client_id and nvl(a.use_yn,'Y')='Y' and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and c.mgr_nm is not null  "+where+" ";

		query6 = " select '최근이력' gubun , call_t_nm nm, '', call_t_tel tel, '' from card_doc_item where rent_l_cd = '"+t_wd+"' ";

		if(s_kd.equals("3") && !t_wd.equals(""))		query5 += " and a.rent_l_cd ='"+t_wd+"' ";

		query = query1+" union all "+query2+" union all "+query3+" union all "+query4+" union all "+query5+" union all "+query6;

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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ConsignmentDatabase:getManSearch2]\n"+e);
			System.out.println("[ConsignmentDatabase:getManSearch2]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	//사전전화요청 리스트 조회
	public Vector getConsignmentRegOffList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String st_dt, String end_dt, String sort)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select \n"+
                "        decode(b.mm_seq,'','미등록','등록') reg_st, c.user_nm, d.user_nm as req_nm2, a.* \n"+
                " from   cons_mm a, (select mm_seq from consignment where mm_seq is not null and seq=1) b, users c, users d \n"+
                " where  a.seq=b.mm_seq(+) \n"+
                " and    a.reg_id=c.user_id \n"+
                " and    a.req_nm=d.user_id \n"+
				" ";

		String search = "";
		String what = "";
		String dt1 = "";

		dt1		= "a.reg_dt";

		if(gubun2.equals("1"))			query += " and "+dt1+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))		query += " and "+dt1+" like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun2.equals("4"))		query += " and "+dt1+" like to_char(sysdate-1,'YYYYMMDD')||'%'";
		else if(gubun2.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt1+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt1+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		if(gubun1.equals("Y"))	query += " and b.mm_seq is not null ";
		if(gubun1.equals("N"))	query += " and b.mm_seq is null ";

		if(s_kd.equals("1"))		what = "upper(nvl(c.user_nm, ' '))";	
		else if(s_kd.equals("2"))	what = "upper(nvl(a.content, ' '))";	
		else if(s_kd.equals("3"))	what = "upper(nvl(d.user_nm, ' '))";	
			
		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	


		if(sort.equals("1"))	query += " order by c.user_nm";	
		if(sort.equals("2"))	query += " order by a.reg_dt, a.seq";	


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
//			System.out.println("[ConsignmentDatabase:getConsignmentRegOffList]\n"+query);
		} catch (SQLException e) {
			System.out.println("[ConsignmentDatabase:getConsignmentRegOffList]\n"+e);
			System.out.println("[ConsignmentDatabase:getConsignmentRegOffList]\n"+query);
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

	//사전전화요청 의뢰자 미등록 리스트 조회
	public Vector getConsignmentRegOffReqNmList(String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select \n"+
                "        decode(b.mm_seq,'미등록','등록') reg_st, c.user_nm, d.user_nm as req_nm2, a.* \n"+
                " from   cons_mm a, consignment b, users c, users d \n"+
                " where  a.req_nm='"+user_id+"' and a.seq=b.mm_seq(+) \n"+
                " and    a.reg_id=c.user_id \n"+
                " and    a.req_nm=d.user_id \n"+
				" and    b.mm_seq is null "+
				" order by a.reg_dt, a.seq ";


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
			System.out.println("[ConsignmentDatabase:getConsignmentRegOffReqNmList]\n"+e);
			System.out.println("[ConsignmentDatabase:getConsignmentRegOffReqNmList]\n"+query);
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

	//유류대경감문서관리
	public Vector getResCarOilReduceDocList(String s_kd, String t_wd, String gubun1, String gubun2, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String sub_query = "";
		String query = "";

		sub_query = "         SELECT 'card' st, a.cardno AS seq1, a.buy_id AS seq2, \n"+ //법인카드 차량유류대 예비차 지점이동
					"                a.buy_dt AS pay_dt, a.ven_name AS off_nm, a.buy_amt AS oil_amt, a.acct_cont AS amt_cont, \n"+        
					"                a.o_cau, a.buy_user_id, a.m_doc_code, a.m_amt \n"+        
					"         FROM   CARD_DOC a \n"+
					"         WHERE  ( ( a.acct_code = '00004' and a.acct_code_g2='12') or ( a.acct_code =  '00003'  and  a.acct_code_g in  ( '9', '10' )  )  )  \n"+ 	//예비차주유 
//					"                AND a.o_cau IN ('17') \n"+  						//지점이동
//					"                AND a.m_doc_code is not null \n"+					//경감요청분
					"                AND a.buy_dt > '20110931' \n"; 					//20111001부터 

		sub_query += "        UNION all \n";

		sub_query += "        SELECT 'cons' st, a.cons_no AS seq1, TO_CHAR(a.seq) AS seq2,  \n"+ //탁송 지점이동 유류대 발생분
					"                SUBSTR(a.to_dt,1,8) AS pay_dt, a.off_nm AS off_nm, a.oil_amt AS oil_amt, a.car_no||' '||a.car_nm||' '||a.from_place||'->'||a.to_place AS amt_cont, \n"+
					"                a.cons_cau AS o_cau, a.req_id AS buy_user_id, a.m_doc_code, a.m_amt \n"+
					"         FROM   CONSIGNMENT a \n"+
					"         WHERE  a.oil_amt>0 \n"+ 									//주유비있음 
//					"                AND a.cons_cau IN ('17') \n"+						//지점이동
//					"                AND a.m_doc_code is not null \n"+					//경감요청분
					"                and a.to_dt > '20110931'  \n"; 					//20111001부터

		sub_query += "        UNION all \n";

		sub_query += "        SELECT 'pay' st, a.reqseq AS seq1, TO_CHAR(f.i_seq) AS seq2,   \n"+ //출금 차량유류대 예비차 지점이동
					"                a.p_pay_dt AS pay_dt, a.off_nm AS off_nm, f.i_amt AS oil_amt, f.p_cont AS amt_cont, \n"+
					"                f.o_cau AS o_cau, f.buy_user_id, f.m_doc_code, f.m_amt \n"+
					"         FROM   PAY_ITEM f, PAY a \n"+
					"         WHERE  f.p_gubun='99' AND f.acct_code='45800' "+
					"	             AND f.acct_code_g2='12' \n"+ 						//예비차주유 
//					"                AND f.o_cau IN ('17') \n"+  						//지점이동
//					"                AND f.m_doc_code is not null \n"+					//경감요청분
					"                AND f.reqseq=a.reqseq \n"+  				
					"                AND a.p_pay_dt > '20110931' \n"; 					//20111001부터 

			

		query = " select "+
				"        a.*, \n"+
				"        decode(a.st,'card','카드','cons','탁송','pay','출금') st_nm, "+
				"        decode(g.ins_doc_st,'Y','승인','N','기각','') ins_doc_st_nm, "+
				"        e.user_nm AS buy_user_nm, \n"+
				"        b.doc_no, b.doc_id, b.doc_step, \n"+
				"        c.user_nm AS user_nm1, d.user_nm AS user_nm2,  \n"+
				"        to_char(b.user_dt1,'YYYYMMDD') user_dt1, \n"+
				"        to_char(b.user_dt2,'YYYYMMDD') user_dt2  "+
				" from   ("+sub_query+") a, \n"+
				"        (SELECT * FROM DOC_SETTLE WHERE doc_st='33') b, \n"+
				"        USERS c, USERS d, USERS e, branch f, \n"+
				"        (select * from ins_change_doc where doc_st='3') g \n"+
				" where  a.m_doc_code=b.doc_id \n"+
				"        and b.user_id1=c.user_id(+)  \n"+
				"        and b.user_id2=d.user_id(+) \n"+
				"        and a.buy_user_id=e.user_id(+) \n"+
				"        AND e.loan_st IS NOT null  \n"+
				"        and e.br_id=f.br_id(+)"+
				"        and a.m_doc_code=g.ins_doc_no(+)"+
				"   ";

		if(gubun1.equals("1"))							query += " and a.pay_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun1.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and to_char(b.user_dt1,'YYYYMMDD') like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and to_char(b.user_dt1,'YYYYMMDD') between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		if(gubun2.equals("1"))	query += " and NVL(b.doc_step,'0')<>'3'";
		if(gubun2.equals("2"))	query += " and NVL(b.doc_step,'0')='3'";

		String search = "";
		String what = "";

		if(s_kd.equals("1"))	what = "upper(nvl(c.user_nm, ' '))";	
		if(s_kd.equals("2"))	what = " upper(nvl(a.off_nm, ' '))";	
		if(s_kd.equals("6"))	what = " a.pay_dt";

			
		if(!what.equals("") && !t_wd.equals("")){
			if(s_kd.equals("6"))	query += " and "+what+" like replace('%"+t_wd+"%', '-','')";
			else					query += " and "+what+" like upper('%"+t_wd+"%') ";
		}else{

		}	

		query += " ORDER BY NVL(b.doc_step,'0'), to_char(b.user_dt1,'YYYYMMDD')  desc , a.pay_dt ";


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
//			System.out.println("[ConsignmentDatabase:getResCarOilReduceDocList]\n"+sub_query);
		} catch (SQLException e) {
			System.out.println("[ConsignmentDatabase:getResCarOilReduceDocList]\n"+e);
			System.out.println("[ConsignmentDatabase:getResCarOilReduceDocList]\n"+query);
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

	public boolean updateM_doc_code(String st, String seq1, String seq2, String m_doc_code)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = "";

		query = " update consignment set m_doc_code=? where cons_no=? and seq=to_number(?) ";

		if(st.equals("card")){
			query = " update card_doc set m_doc_code=? where cardno=? and buy_id=? ";	
		}else if(st.equals("pay")){
			query = " update pay_item set m_doc_code=? where reqseq=? and i_seq=to_number(?) ";	
		}

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, m_doc_code);
			pstmt.setString(2, seq1);
			pstmt.setString(3, seq2);
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[ConsignmentDatabase:updateM_doc_code]\n"+e);
			System.out.println("[ConsignmentDatabase:updateM_doc_code]\n"+query);
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

	public boolean updateM_amt(String st, String seq1, String seq2, int m_amt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = "";

		query = " update consignment set m_amt=? where cons_no=? and seq=to_number(?) ";

		if(st.equals("card")){
			query = " update card_doc set m_amt=? where cardno=? and buy_id=? ";	
		}else if(st.equals("pay")){
			query = " update pay_item set m_amt=? where reqseq=? and i_seq=to_number(?) ";	
		}

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setInt   (1, m_amt);
			pstmt.setString(2, seq1);
			pstmt.setString(3, seq2);
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[ConsignmentDatabase:updateM_amt]\n"+e);
			System.out.println("[ConsignmentDatabase:updateM_amt]\n"+query);
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

	//배달탁송 한건 조회
	public ConsignmentBean getConsignmentPur(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ConsignmentBean bean = new ConsignmentBean();
		String query = "";

		query = " select * from cons_pur where rent_mng_id = ? and rent_l_cd = ? and cancel_dt is null and return_dt is null ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
		   	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{
				bean.setCons_no			(rs.getString("cons_no")		==null?"":rs.getString("cons_no"));
				bean.setRent_mng_id		(rs.getString("rent_mng_id")	==null?"":rs.getString("rent_mng_id"));
				bean.setRent_l_cd		(rs.getString("rent_l_cd")		==null?"":rs.getString("rent_l_cd"));
				bean.setReq_id			(rs.getString("req_id")			==null?"":rs.getString("req_id"));
				bean.setReg_id			(rs.getString("reg_id")			==null?"":rs.getString("reg_id"));
				bean.setReg_dt			(rs.getString("reg_dt")			==null?"":rs.getString("reg_dt"));
				bean.setCancel_id		(rs.getString("cancel_id")		==null?"":rs.getString("cancel_id"));
				bean.setCancel_dt		(rs.getString("cancel_dt")		==null?"":rs.getString("cancel_dt"));
				bean.setEtc				(rs.getString("etc")			==null?"":rs.getString("etc"));
				bean.setDlv_dt			(rs.getString("dlv_dt")			==null?"":rs.getString("dlv_dt"));
				bean.setUdt_yn			(rs.getString("udt_yn")			==null?"":rs.getString("udt_yn"));
				bean.setUdt_dt			(rs.getString("udt_dt")			==null?"":rs.getString("udt_dt"));
				bean.setUdt_id			(rs.getString("udt_id")			==null?"":rs.getString("udt_id"));
				bean.setUdt_mng_id		(rs.getString("udt_mng_id")		==null?"":rs.getString("udt_mng_id"));
				bean.setUdt_mng_nm		(rs.getString("udt_mng_nm")		==null?"":rs.getString("udt_mng_nm"));
				bean.setUdt_mng_tel		(rs.getString("udt_mng_tel")	==null?"":rs.getString("udt_mng_tel"));
				bean.setUdt_firm		(rs.getString("udt_firm")		==null?"":rs.getString("udt_firm"));
				bean.setUdt_addr		(rs.getString("udt_addr")		==null?"":rs.getString("udt_addr"));
				bean.setDriver_nm		(rs.getString("driver_nm")		==null?"":rs.getString("driver_nm"));
				bean.setDriver_m_tel	(rs.getString("driver_m_tel")	==null?"":rs.getString("driver_m_tel"));
				bean.setDriver_ssn		(rs.getString("driver_ssn")		==null?"":rs.getString("driver_ssn"));
				bean.setSettle_dt		(rs.getString("settle_id")		==null?"":rs.getString("settle_id"));
				bean.setSettle_id		(rs.getString("settle_dt")		==null?"":rs.getString("settle_dt"));
				bean.setTo_est_dt		(rs.getString("to_est_dt")		==null?"":rs.getString("to_est_dt"));
				bean.setDriver_nm2		(rs.getString("driver_nm2")		==null?"":rs.getString("driver_nm2"));
				bean.setDriver_m_tel2	(rs.getString("driver_m_tel2")	==null?"":rs.getString("driver_m_tel2"));

			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ConsignmentDatabase:getConsignmentPur]\n"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}				
	}

	//배달탁송 한건 조회
	public ConsignmentBean getConsignmentPur(String cons_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ConsignmentBean bean = new ConsignmentBean();
		String query = "";

		query = " select * from cons_pur where cons_no = ? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, cons_no);
		   	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{
				bean.setCons_no			(rs.getString("cons_no")		==null?"":rs.getString("cons_no"));
				bean.setRent_mng_id		(rs.getString("rent_mng_id")	==null?"":rs.getString("rent_mng_id"));
				bean.setRent_l_cd		(rs.getString("rent_l_cd")		==null?"":rs.getString("rent_l_cd"));
				bean.setReq_id			(rs.getString("req_id")			==null?"":rs.getString("req_id"));
				bean.setReg_id			(rs.getString("reg_id")			==null?"":rs.getString("reg_id"));
				bean.setReg_dt			(rs.getString("reg_dt")			==null?"":rs.getString("reg_dt"));
				bean.setCancel_id		(rs.getString("cancel_id")		==null?"":rs.getString("cancel_id"));
				bean.setCancel_dt		(rs.getString("cancel_dt")		==null?"":rs.getString("cancel_dt"));
				bean.setEtc				(rs.getString("etc")			==null?"":rs.getString("etc"));
				bean.setDlv_dt			(rs.getString("dlv_dt")			==null?"":rs.getString("dlv_dt"));
				bean.setUdt_yn			(rs.getString("udt_yn")			==null?"":rs.getString("udt_yn"));
				bean.setUdt_dt			(rs.getString("udt_dt")			==null?"":rs.getString("udt_dt"));
				bean.setUdt_id			(rs.getString("udt_id")			==null?"":rs.getString("udt_id"));
				bean.setUdt_mng_id		(rs.getString("udt_mng_id")		==null?"":rs.getString("udt_mng_id"));
				bean.setUdt_mng_nm		(rs.getString("udt_mng_nm")		==null?"":rs.getString("udt_mng_nm"));
				bean.setUdt_mng_tel		(rs.getString("udt_mng_tel")	==null?"":rs.getString("udt_mng_tel"));
				bean.setUdt_firm		(rs.getString("udt_firm")		==null?"":rs.getString("udt_firm"));
				bean.setUdt_addr		(rs.getString("udt_addr")		==null?"":rs.getString("udt_addr"));
				bean.setDriver_nm		(rs.getString("driver_nm")		==null?"":rs.getString("driver_nm"));
				bean.setDriver_m_tel	(rs.getString("driver_m_tel")	==null?"":rs.getString("driver_m_tel"));
				bean.setDriver_ssn		(rs.getString("driver_ssn")		==null?"":rs.getString("driver_ssn"));
				bean.setSettle_dt		(rs.getString("settle_id")		==null?"":rs.getString("settle_id"));
				bean.setSettle_id		(rs.getString("settle_dt")		==null?"":rs.getString("settle_dt"));
				bean.setTo_est_dt		(rs.getString("to_est_dt")		==null?"":rs.getString("to_est_dt"));
				bean.setDriver_nm2		(rs.getString("driver_nm2")		==null?"":rs.getString("driver_nm2"));
				bean.setDriver_m_tel2	(rs.getString("driver_m_tel2")	==null?"":rs.getString("driver_m_tel2"));				
				bean.setReturn_dt		(rs.getString("return_dt")		==null?"":rs.getString("return_dt"));
				bean.setReturn_id		(rs.getString("return_id")		==null?"":rs.getString("return_id"));
				bean.setReturn_amt		(rs.getString("return_amt")	==null?0:Integer.parseInt(rs.getString("return_amt")));
				bean.setRt_com_con_no	(rs.getString("rt_com_con_no")	==null?"":rs.getString("rt_com_con_no"));
				
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ConsignmentDatabase:getConsignmentPur]\n"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}				
	}

	public String insertConsignmentPur(ConsignmentBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		String cons_no = "";
		String query =  " insert into cons_pur "+
						" ( cons_no, rent_mng_id, rent_l_cd, req_id, reg_id, reg_dt, "+
						"   udt_mng_id, udt_mng_nm, udt_mng_tel, udt_firm, udt_addr "+
						" ) values "+
						" ( ?, ?, ?, ?, ?, sysdate, "+
						"   ?, ?, ?, ?, ?  "+
						" )";

		String qry_id = " select to_char(sysdate,'YYYYMMDD')||nvl(ltrim(to_char(to_number(max(substr(cons_no,9,4))+1), '0000')), '0001') cons_no"+
						" from cons_pur "+
						" where substr(cons_no,1,8)=to_char(sysdate,'YYYYMMDD')";


		try
		{
			conn.setAutoCommit(false);
			pstmt1 = conn.prepareStatement(qry_id);
		   	rs = pstmt1.executeQuery();
			while(rs.next())
			{
				cons_no = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt1.close();
			conn.commit();
		}catch(Exception e){					
	        try{
				System.out.println("[ConsignmentDatabase:insertConsignmentPur]"+e);
	            conn.rollback();
				e.printStackTrace();	
				flag = false;
	        }catch(SQLException _ignored){}
		}finally{
			try{
                if(rs != null )		rs.close();
	            if(pstmt1 != null)	pstmt1.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
		}

		try
		{
			conn.setAutoCommit(false);

			pstmt2 = conn.prepareStatement(query);
			
			if(bean.getCons_no().equals("")){
				pstmt2.setString(1,  cons_no		      );
			}else{
				pstmt2.setString(1,  bean.getCons_no	());
				cons_no = bean.getCons_no();
			}
			pstmt2.setString(2,  bean.getRent_mng_id	());
			pstmt2.setString(3,  bean.getRent_l_cd		());
			pstmt2.setString(4,  bean.getReq_id			());
			pstmt2.setString(5,  bean.getReg_id			());
			pstmt2.setString(6,  bean.getUdt_mng_id		());
			pstmt2.setString(7,  bean.getUdt_mng_nm		());
			pstmt2.setString(8,  bean.getUdt_mng_tel	());
			pstmt2.setString(9,  bean.getUdt_firm		());
			pstmt2.setString(10, bean.getUdt_addr		());

			pstmt2.executeUpdate();			
			pstmt2.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[ConsignmentDatabase:insertConsignmentPur]\n"+e);
			e.printStackTrace();
	  		flag = false;
			cons_no = "";
			conn.rollback();
		}finally{
			try{
	            if(pstmt2 != null)	pstmt2.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return cons_no;
		}
	}

	//탁송현황 리스트 조회
	public Vector getConsignmentPurMngList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT e.nm AS car_comp_nm, b.rpt_no, substr(b.dlv_est_dt,1,8) dlv_est_dt, b.DLV_ext, \n"+
				"        DECODE(b.udt_st,'1','서울본사','2','부산지점','3','대전지점','4','고객','5','대구지점','6','광주지점') udt_st_nm,  \n"+
				"        b.cons_amt1, h.car_off_nm, g.emp_nm, NVL(h.car_off_tel,g.emp_m_tel) emp_tel,  \n"+
				"        DECODE(a.cancel_dt,'',decode(i.cons_no,'','신규','변경'),'취소') use_st_nm, r.init_reg_dt,  \n"+
				"        DECODE(i.cng_st,'1','출고일변경','2','배달지변경') cng_st_nm,  \n"+
				"        i.cng_cont, j.user_nm AS req_nm, k.br_nm, m.car_nm, d.car_name, n.off_nm, \n"+
				"        decode(a.settle_dt,'','','확정') settle_st, "+
				"        a.*  \n"+
				" FROM   CONS_PUR a, cont l, CAR_PUR b, CAR_ETC c, CAR_NM d, car_mng m, car_reg r, \n"+
				"        (SELECT * FROM CODE WHERE c_st='0001') e, \n"+
				"        (SELECT * FROM COMMI WHERE agnt_st='2') f, \n"+
				"        CAR_OFF_EMP g, CAR_OFF h, \n"+
				"        (select * from CONS_PUR_CNG a where a.seq = (select max(seq) from CONS_PUR_CNG WHERE cons_no=a.cons_no)) i,   \n"+
				"        users j, BRANCH k, serv_off n "+
				" WHERE  a.driver_nm is null and a.dlv_dt is null and a.udt_dt is null and a.cancel_dt is null "+
				"        and a.rent_mng_id=l.rent_mng_id AND a.rent_l_cd=l.rent_l_cd \n"+
//				"        and nvl(l.use_yn,'Y')='Y' "+
//				"        and decode(b.off_id,'',nvl(l.use_yn,'Y'),'Y')='Y' "+
				"        and decode(l.use_yn,'Y',l.use_yn,'','Y','N',decode(b.off_id,'','N','Y'))='Y' "+
				"	     and a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd \n"+
				"        AND b.rent_mng_id=c.rent_mng_id AND b.rent_l_cd=c.rent_l_cd \n"+
				"        AND c.car_id=d.car_id AND c.car_seq=d.car_seq and d.car_comp_id=m.car_comp_id and d.car_cd=m.code \n"+
				"        AND d.car_comp_id=E.CODE \n"+
				"        AND b.rent_mng_id=f.rent_mng_id AND b.rent_l_cd=f.rent_l_cd \n"+
				"        AND f.emp_id=g.emp_id \n"+
				"        AND g.car_off_id=h.car_off_id \n"+
				"        AND a.cons_no=i.cons_no(+) and a.req_id=j.user_id AND j.br_id=k.br_id "+
				"        and b.off_id=n.off_id "+
				"        and l.car_mng_id=r.car_mng_id(+) "+
//			    "        and a.rent_l_cd not in ('S314HLFR00523','S614HLFR00412') "+
				" ";

		String dt1 = "to_char(a.reg_dt,'YYYYMM')";
		String dt2 = "to_char(a.reg_dt,'YYYYMMDD')";

		if(gubun6.equals("2")){
			dt1 = "substr(b.dlv_est_dt,1,6)";
			dt2 = "substr(b.dlv_est_dt,1,8)";
		}else if(gubun6.equals("3")){
			dt1 = "substr(a.dlv_dt,1,6)";
			dt2 = "a.dlv_dt";
		}else if(gubun6.equals("4")){
			dt1 = "substr(a.udt_dt,1,6)";
			dt2 = "a.udt_dt";
		}

		if(gubun1.equals("1"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun1.equals("3"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
		else if(gubun1.equals("4"))		query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";
		else if(gubun1.equals("5"))		query += " and "+dt2+" = to_char(sysdate+1,'YYYYMMDD')";
		else if(gubun1.equals("6"))		query += " and "+dt2+" = to_char(sysdate+2,'YYYYMMDD')";
		else if(gubun1.equals("7"))		query += " and "+dt2+" = to_char(sysdate+3,'YYYYMMDD')";
		else if(gubun1.equals("8"))		query += " and "+dt2+" = to_char(sysdate+4,'YYYYMMDD')";
		else if(gubun1.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		if(!gubun2.equals("")) {
			if (gubun2.equals("009026")) {
				query += " and b.off_id in('009026','011372') ";
			} else if (gubun2.equals("011372")) {
				query += " and b.off_id in('009026','011372') ";
			} else {
				query += " and b.off_id = '"+gubun2+"' ";
			}
		}

		if(gubun3.equals("1"))			query += " and d.car_comp_id = '0001' ";
		if(gubun3.equals("2"))			query += " and d.car_comp_id = '0002' ";
		if(gubun3.equals("3"))			query += " and d.car_comp_id > '0002' ";

		if(!gubun4.equals(""))			query += " and b.DLV_ext like upper('%"+gubun4+"%') ";

		if(!gubun5.equals(""))			query += " and b.udt_st = '"+gubun5+"' ";




		String search = "";
		String what = "";

		if(s_kd.equals("1"))	what = "upper(nvl(k.br_id||k.br_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(b.off_nm, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(b.rpt_no, ' '))";
		if(s_kd.equals("4"))	what = "upper(nvl(h.car_off_nm||g.emp_nm, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(j.user_nm, ' '))";
			
		if(!s_kd.equals("") && !t_wd.equals("")){			
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}else{

		}	


		query += " order by b.off_id, substr(b.dlv_est_dt,1,8), b.dlv_ext, b.udt_st, a.cons_no desc ";

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
	//		System.out.println("[ConsignmentDatabase:getConsignmentPurMngList]\n"+query);
		} catch (SQLException e) {
			System.out.println("[ConsignmentDatabase:getConsignmentPurMngList]\n"+e);
			System.out.println("[ConsignmentDatabase:getConsignmentPurMngList]\n"+query);
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

	//탁송현황 리스트 조회
	public Vector getConsignmentPurCngs(String cons_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT DECODE(a.cng_st,'1','배달지변경','2','출고일변경','3','출고취소') cng_st_nm,  \n"+
				"        a.*  \n"+
				" FROM   CONS_PUR_CNG a \n"+
				" WHERE  a.cons_no=? and a.cng_st<>'4' \n"+
		        " order by a.seq";

		try {
								
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, cons_no);
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
			System.out.println("[ConsignmentDatabase:getConsignmentPurCngs]\n"+e);
			System.out.println("[ConsignmentDatabase:getConsignmentPurCngs]\n"+query);
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

	//배달탁송 한건 조회
	public int getConsPurCngNextSeq(String cons_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int seq = 0;
		String query = "";

		query = " SELECT nvl(max(seq)+1,1) as next_seq from cons_pur_cng where cons_no=? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, cons_no);
		   	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{
				seq = rs.getInt("next_seq");
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ConsignmentDatabase:getConsPurCngNextSeq]\n"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return seq;
		}				
	}

	public boolean updateConsignmentPurSettle(ConsignmentBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update cons_pur set "+
						"   settle_dt=sysdate, settle_id=? "+
						" where cons_no=? ";


		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);			
			pstmt.setString(1,  bean.getSettle_id		());
			pstmt.setString(2,  bean.getCons_no			());
			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[ConsignmentDatabase:updateConsignmentPurSettle]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	public boolean updateConsignmentPur(ConsignmentBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update cons_pur set "+
						"   udt_mng_id=?, udt_mng_nm=?, udt_mng_tel=?, udt_firm=?, udt_addr=?, "+
						"   dlv_dt=replace(?,'-',''), etc=?, "+
						"   driver_nm=?, driver_m_tel=?, driver_ssn=?, to_est_dt=replace(?,'-',''), driver_nm2=?, driver_m_tel2=? "+
						" where cons_no=? ";


		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);			
			pstmt.setString(1,  bean.getUdt_mng_id		());
			pstmt.setString(2,  bean.getUdt_mng_nm		());
			pstmt.setString(3,  bean.getUdt_mng_tel		());
			pstmt.setString(4,  bean.getUdt_firm		());
			pstmt.setString(5,  bean.getUdt_addr		());
			pstmt.setString(6,  bean.getDlv_dt			());
			pstmt.setString(7,  bean.getEtc				());
			pstmt.setString(8,  bean.getDriver_nm		());
			pstmt.setString(9,  bean.getDriver_m_tel	());
			pstmt.setString(10, bean.getDriver_ssn		());
			pstmt.setString(11, bean.getTo_est_dt   	());
			pstmt.setString(12, bean.getDriver_nm2		());
			pstmt.setString(13, bean.getDriver_m_tel2	());
			pstmt.setString(14, bean.getCons_no			());
			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[ConsignmentDatabase:updateConsignmentPur]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	public boolean updateConsignmentPurUdt(ConsignmentBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update cons_pur set "+
						"   udt_yn=?, udt_dt=replace(?,'-',''), udt_id=? "+
						" where cons_no=? ";


		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);			
			pstmt.setString(1,  bean.getUdt_yn		());
			pstmt.setString(2,  bean.getUdt_dt		());
			pstmt.setString(3,  bean.getUdt_id		());
			pstmt.setString(4, bean.getCons_no		());
			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[ConsignmentDatabase:updateConsignmentPurUdt]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	public boolean updateConsignmentPurDlvdt(ConsignmentBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update cons_pur set "+
						"   dlv_dt=replace(?,'-','') "+
						" where cons_no=? ";


		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);			
			pstmt.setString(1, bean.getDlv_dt		());
			pstmt.setString(2, bean.getCons_no		());
			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[ConsignmentDatabase:updateConsignmentPurDlvdt]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	public boolean updateConsignmentPurUdtdt(ConsignmentBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update cons_pur set "+
						"   udt_dt=replace(?,'-','') "+
						" where cons_no=? ";


		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);			
			pstmt.setString(1, bean.getUdt_dt		());
			pstmt.setString(2, bean.getCons_no		());
			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[ConsignmentDatabase:updateConsignmentPurUdtdt]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}


	public boolean updateConsignmentPurCancel(ConsignmentBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update cons_pur set "+
						"   cancel_dt=sysdate, cancel_id=? "+
						" where cons_no=? ";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);			
			pstmt.setString(1,  bean.getCancel_id	());
			pstmt.setString(2, bean.getCons_no		());
			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[ConsignmentDatabase:updateConsignmentPurCancel]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	public boolean updateConsignmentPurReturn(ConsignmentBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update cons_pur set "+
						"   return_dt=replace(?,'-',''), return_id=?, return_amt=?, rt_com_con_no=? "+
						" where cons_no=? ";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);			
			pstmt.setString(1, bean.getReturn_dt());
			pstmt.setString(2, bean.getReturn_id());
			pstmt.setInt   (3, bean.getReturn_amt());
			pstmt.setString(4, bean.getRt_com_con_no());
			pstmt.setString(5, bean.getCons_no());
			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[ConsignmentDatabase:updateConsignmentPurReturn]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	public boolean insertConsignmentPurCng(ConsignmentBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " INSERT INTO cons_pur_cng  "+
						"   (cons_no, seq, cng_st, cng_cont, reg_id, reg_dt) "+
						" VALUES ( ?, ?, ?, ?, ?, sysdate) ";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);			
			pstmt.setString(1,  bean.getCons_no		());
			pstmt.setInt   (2,  bean.getSeq			());
			pstmt.setString(3,  bean.getCng_st		());
			pstmt.setString(4,  bean.getCng_cont	());
			pstmt.setString(5,  bean.getReg_id		());
			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[ConsignmentDatabase:insertConsignmentPurCng]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	public boolean updateConsignmentPurReqCode(String cons_no, String req_dt, String req_code)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update cons_pur set req_code=?, req_dt=replace(?,'-','') where cons_no=?";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);		
			pstmt.setString(1,  req_code);
			pstmt.setString(2,  req_dt);
			pstmt.setString(3,  cons_no);
			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[ConsignmentDatabase:updateConsignmentPurReqCode]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//문서처리 리스트 조회
	public Vector getConsignmentPurReqDocList(String s_kd, String t_wd, String gubun1, String gubun2, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String sub_query = "";
		String query = "";

		sub_query = " select b.off_id, b.off_nm, a.req_code, a.pay_dt, sum(cons_amt1) cons_amt1, min(a.dlv_dt) min_dt, max(a.dlv_dt) max_dt, count(a.cons_no) cnt "+
					" from   cons_pur a, car_pur b "+
					" where  a.udt_dt is not null and a.cancel_dt is null  "+
					"        and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd";

		if(gubun1.equals("1"))							query += " and a.udt_dt like to_char(sysdate,'YYYYMM')||'%'";
 		else if(gubun1.equals("4"))						query += " and a.udt_dt like to_char(add_months(sysdate,-1),'YYYY-MM')||'%'";
		else if(gubun1.equals("3"))						query += " and a.udt_dt = to_char(sysdate,'YYYYMMDD')";
		else if(gubun1.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and a.udt_dt like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and a.udt_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		sub_query += " group by b.off_id, b.off_nm, a.req_code, a.pay_dt ";

		query = " select"+
				" a.*, b.user_id1, b.user_id2, c.user_nm as user_nm1, d.user_nm as user_nm2, to_char(b.user_dt1,'YYYYMMDD') user_dt1, b.user_dt2, b.doc_no, e.br_nm"+
				" from ("+sub_query+") a, (select * from doc_settle where doc_st='34') b, users c, users d, branch e"+
				" where a.req_code=b.doc_id(+) and b.user_id1=c.user_id(+) and b.user_id2=d.user_id(+) and c.br_id=e.br_id(+)"+
				" ";


		if(gubun2.equals("1"))	query += " and nvl(b.doc_step,'1') <> '3'";
		if(gubun2.equals("2"))	query += " and nvl(b.doc_step,'1') =  '3'";


		String search = "";
		String what = "";

		if(s_kd.equals("2"))	what = "upper(nvl(a.off_nm, ' '))";	
			
		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		query += " order by a.off_id, a.pay_dt";


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
		//	System.out.println("[ConsignmentDatabase:getConsignmentPurReqDocList]\n"+sub_query);
		} catch (SQLException e) {
			System.out.println("[ConsignmentDatabase:getConsignmentPurReqDocList]\n"+e);
			System.out.println("[ConsignmentDatabase:getConsignmentPurReqDocList]\n"+query);
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

	//문서처리 리스트 조회
	public Vector getConsignmentPurReqDocList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String sub_query = "";
		String query = "";

		sub_query = " select b.off_id, b.off_nm, decode(a.req_code,'',substr(nvl(a.dlv_dt,a.udt_dt),1,6),'') dlv_ym, a.req_code, sum(decode(a.return_dt,'',b.cons_amt1,a.return_amt)) cons_amt1, min(nvl(a.dlv_dt,a.udt_dt)) min_dt, max(nvl(a.dlv_dt,a.udt_dt)) max_dt, count(a.cons_no) cnt "+
					" from   cons_pur a, car_pur b "+
					" where  (a.udt_dt is not null or a.return_dt is not null) and a.cancel_dt is null  "+
					"        and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd";



		sub_query += " group by b.off_id, b.off_nm, decode(a.req_code,'',substr(nvl(a.dlv_dt,a.udt_dt),1,6),''), a.req_code ";

		query = " select"+
				" a.*, b.user_id1, b.user_id2, c.user_nm as user_nm1, d.user_nm as user_nm2, to_char(b.user_dt1,'YYYYMMDD') user_dt1, b.user_dt2, b.doc_no, e.br_nm"+
				" from ("+sub_query+") a, (select * from doc_settle where doc_st='34') b, users c, users d, branch e"+
				" where a.req_code=b.doc_id(+) and b.user_id1=c.user_id(+) and b.user_id2=d.user_id(+) and c.br_id=e.br_id(+)"+
				" ";

		if(gubun2.equals("2")){
			if(gubun1.equals("1"))							query += " and to_char(b.user_dt1,'YYYYMM') = to_char(sysdate,'YYYYMM')";
 			else if(gubun1.equals("4"))						query += " and to_char(b.user_dt1,'YYYYMM') = to_char(add_months(sysdate,-1),'YYYY-MM')";
			else if(gubun1.equals("3"))						query += " and to_char(b.user_dt1,'YYYYMMDD') = to_char(sysdate,'YYYYMMDD')";
			else if(gubun1.equals("2")){
				if(!st_dt.equals("") && end_dt.equals(""))	query += " and to_char(b.user_dt1,'YYYYMMDD') like replace('"+st_dt+"%', '-','')";
				if(!st_dt.equals("") && !end_dt.equals("")) query += " and to_char(b.user_dt1,'YYYYMMDD') between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
			}
		}

		if(!gubun3.equals("")) {
			if (gubun3.equals("009026")) {
				query += " and a.off_id in('009026','011372') ";
			} else if (gubun3.equals("011372")) {
				query += " and a.off_id in('009026','011372') ";
			} else {
				query += " and a.off_id = '"+gubun3+"' ";
			}
		}

		if(gubun2.equals("1"))	query += " and nvl(b.doc_step,'1') <> '3'";
		if(gubun2.equals("2"))	query += " and nvl(b.doc_step,'1') =  '3'";


		String search = "";
		String what = "";

		if(s_kd.equals("2"))	what = "upper(nvl(a.off_nm, ' '))";	
			
		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		query += " order by nvl(b.doc_step,'1'), b.user_dt1 desc ";


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
//			System.out.println("[ConsignmentDatabase:getConsignmentPurReqDocList]\n"+sub_query);
		} catch (SQLException e) {
			System.out.println("[ConsignmentDatabase:getConsignmentPurReqDocList]\n"+e);
			System.out.println("[ConsignmentDatabase:getConsignmentPurReqDocList]\n"+query);
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

	//미지급현황 리스트 조회
	public Vector getConsignmentPurNotPayOffList(String off_id, String gubun1, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" a.*, b.off_nm, b.off_id, b.cons_amt1, f.nm as car_comp_nm, b.rpt_no, b.dlv_ext, "+
				" DECODE(b.udt_st,'1','서울본사','2','부산지점','3','대전지점','4','고객','5','대구지점','6','광주지점') udt_st_nm  \n"+
				" from cons_pur a, car_pur b, (select * from doc_settle where doc_st='34') c, car_etc d, car_nm e, (select * from code where c_st='0001') f "+
				" where a.udt_dt is not null and a.pay_dt is null and a.cancel_dt is null "+
				" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd "+
				" and a.req_code=c.doc_id(+) and c.doc_no is null "+
				" and b.off_id='"+off_id+"' "+
				" and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd and d.car_id=e.car_id and d.car_seq=e.car_seq and e.car_comp_id=f.code "+
				" ";

		if(gubun1.equals("1"))							query += " and a.udt_dt like to_char(sysdate,'YYYYMM')||'%'";
 		else if(gubun1.equals("4"))						query += " and a.udt_dt like to_char(add_months(sysdate,-1),'YYYY-MM')||'%'";
		else if(gubun1.equals("3"))						query += " and a.udt_dt = to_char(sysdate,'YYYYMMDD')";
		else if(gubun1.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and a.udt_dt like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and a.udt_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}


		query += " order by a.cons_no";


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
			System.out.println("[ConsignmentDatabase:getConsignmentPurNotPayOffList]\n"+e);
			System.out.println("[ConsignmentDatabase:getConsignmentPurNotPayOffList]\n"+query);
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

	//미지급현황 리스트 조회
	public Vector getConsignmentPurNotPayOffList(String off_id, String dlv_ym)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" a.*, b.off_nm, b.off_id, decode(a.return_dt,'',b.cons_amt1,a.return_amt) cons_amt1, f.nm as car_comp_nm, b.rpt_no, b.dlv_ext, "+
				" DECODE(b.udt_st,'1','서울본사','2','부산지점','3','대전지점','4','고객','5','대구지점','6','광주지점') udt_st_nm  \n"+
				" from cons_pur a, car_pur b, (select * from doc_settle where doc_st='34') c, car_etc d, car_nm e, (select * from code where c_st='0001') f "+
				" where (a.udt_dt is not null or a.return_dt is not null) and a.pay_dt is null and a.cancel_dt is null "+
				" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd "+
				" and a.req_code=c.doc_id(+) and c.doc_no is null "+
				" and b.off_id='"+off_id+"' and nvl(a.dlv_dt,a.udt_dt) like replace('%"+dlv_ym+"%', '-','') "+
				" and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd and d.car_id=e.car_id and d.car_seq=e.car_seq and e.car_comp_id=f.code "+
				" ";

		query += " order by a.cons_no";


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
			System.out.println("[ConsignmentDatabase:getConsignmentPurNotPayOffList]\n"+e);
			System.out.println("[ConsignmentDatabase:getConsignmentPurNotPayOffList]\n"+query);
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

	//청구서작성 리스트 조회
	public Vector getConsignmentPurReqDocList2(String req_code, String pay_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" a.*, b.off_nm, b.off_id, decode(a.return_dt,'',b.cons_amt1,a.return_amt) cons_amt1, f.nm as car_comp_nm, b.rpt_no, b.dlv_ext, "+
				" DECODE(b.udt_st,'1','서울본사','2','부산지점','3','대전지점','4','고객','5','대구지점','6','광주지점') udt_st_nm  \n"+
				" from cons_pur a, car_pur b, (select * from doc_settle where doc_st='34') c, car_etc d, car_nm e, (select * from code where c_st='0001') f "+
				" where "+
				" a.req_code='"+req_code+"' "+
//				" and a.req_dt is not null and a.cancel_dt is null "+
				" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd "+
				" and a.req_code=c.doc_id "+
				" and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd and d.car_id=e.car_id and d.car_seq=e.car_seq and e.car_comp_id=f.code "+
				" ";

//		if(!pay_dt.equals(""))	query +=" and a.pay_dt = replace('"+pay_dt+"','-','')";


		query += " order by b.off_id, a.dlv_dt, a.cons_no";


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
			System.out.println("[ConsignmentDatabase:getConsignmentPurReqDocList2]\n"+e);
			System.out.println("[ConsignmentDatabase:getConsignmentPurReqDocList2]\n"+query);
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


	public boolean insertConsCostMan(String off_id, String car_comp_id, String dlv_ext, String man_nm, String man_ssn, String man_tel)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query =  " insert into cons_pur_man "+
						" ( off_id, dlv_ext, car_comp_id, man_nm, man_ssn, man_tel, use_yn ) "+
						"  values "+
						" ( ?, ?, ?, ?, ?, ?, 'Y' "+
						" )";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);		
			pstmt.setString(1,  off_id);
			pstmt.setString(2,  dlv_ext);
			pstmt.setString(3,  car_comp_id);
			pstmt.setString(4,  man_nm);
			pstmt.setString(5,  man_ssn);
			pstmt.setString(6, man_tel);
			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[ConsignmentDatabase:insertConsCostMan]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}


	public boolean updateConsCostMan(String off_id, String car_comp_id, String dlv_ext, String man_nm, String man_ssn, String man_tel, String use_yn)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query =  " update cons_pur_man set "+
						"  man_nm=?, man_ssn=?, man_tel=?, use_yn=?, reg_dt=nvl(reg_dt,sysdate) "+
						" where off_id=? and dlv_ext=? and car_comp_id=? "+
						" ";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);		
			pstmt.setString(1,  man_nm);
			pstmt.setString(2,  man_ssn);
			pstmt.setString(3,  man_tel);
			pstmt.setString(4,  use_yn);
			pstmt.setString(5,  off_id);
			pstmt.setString(6,  dlv_ext);
			pstmt.setString(7,  car_comp_id);
			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[ConsignmentDatabase:updateConsCostMan]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//문서처리 리스트 조회
	public Vector getConsignmentPurManList(String car_comp_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String sub_query = "";
		String query = "";

		query = " SELECT c.nm AS car_comp_nm, b.off_nm, b.off_tel, a.* \n"+
                " FROM   cons_pur_man a, SERV_OFF b, (SELECT * FROM CODE WHERE c_st='0001') c \n"+
                " WHERE  nvl(a.use_yn,'Y')='Y' and a.off_id=b.OFF_id AND a.car_comp_id=c.code";

		if(!car_comp_id.equals("")) query += " and a.car_comp_id='"+car_comp_id+"'";

		query += " order by b.off_nm, a.car_comp_id, a.dlv_ext";


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
//			System.out.println("[ConsignmentDatabase:getConsignmentPurManList]\n"+sub_query);
		} catch (SQLException e) {
			System.out.println("[ConsignmentDatabase:getConsignmentPurManList]\n"+e);
			System.out.println("[ConsignmentDatabase:getConsignmentPurManList]\n"+query);
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

	//문서처리 리스트 조회
	public Vector getConsignmentPurManList(String car_comp_id, String off_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String sub_query = "";
		String query = "";

		query = " SELECT c.nm AS car_comp_nm, b.off_nm, b.off_tel, a.* \n"+
                " FROM   cons_pur_man a, SERV_OFF b, (SELECT * FROM CODE WHERE c_st='0001') c \n"+
                " WHERE  nvl(a.use_yn,'Y')='Y' and a.off_id=b.OFF_id AND a.car_comp_id=c.code";

		if(!car_comp_id.equals("")) query += " and a.car_comp_id='"+car_comp_id+"'";
		if(!off_id.equals(""))		query += " and a.off_id='"+off_id+"'";

		query += " order by a.off_id, a.car_comp_id, a.dlv_ext";


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
//			System.out.println("[ConsignmentDatabase:getConsignmentPurManList]\n"+sub_query);
		} catch (SQLException e) {
			System.out.println("[ConsignmentDatabase:getConsignmentPurManList]\n"+e);
			System.out.println("[ConsignmentDatabase:getConsignmentPurManList]\n"+query);
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

	//문서처리 리스트 조회
	public Vector getConsignmentPurManList(String car_comp_id, String off_id, String dlv_ext)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String sub_query = "";
		String query = "";

		query = " SELECT c.nm AS car_comp_nm, b.off_nm, b.off_tel, a.* \n"+
                " FROM   cons_pur_man a, SERV_OFF b, (SELECT * FROM CODE WHERE c_st='0001') c \n"+
                " WHERE  nvl(a.use_yn,'Y')='Y' and a.off_id=b.OFF_id AND a.car_comp_id=c.code";

		if(!car_comp_id.equals("")) query += " and a.car_comp_id='"+car_comp_id+"'";
		if(!off_id.equals(""))		query += " and a.off_id='"+off_id+"'";
		if(!dlv_ext.equals(""))		query += " and a.dlv_ext='"+dlv_ext+"'";

		query += " order by b.off_nm, a.car_comp_id, a.dlv_ext";


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
//			System.out.println("[ConsignmentDatabase:getConsignmentPurManList]\n"+sub_query);
		} catch (SQLException e) {
			System.out.println("[ConsignmentDatabase:getConsignmentPurManList]\n"+e);
			System.out.println("[ConsignmentDatabase:getConsignmentPurManList]\n"+query);
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

	//납품청구현황 리스트 조회
	public Hashtable getConsignmentPurMan(String car_comp_id, String dlv_ext, String off_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " SELECT c.nm AS car_comp_nm, b.off_nm, b.off_tel, a.* \n"+
                " FROM   cons_pur_man a, SERV_OFF b, (SELECT * FROM CODE WHERE c_st='0001') c \n"+
                " WHERE  a.car_comp_id=? and a.dlv_ext=? and a.off_id=decode(?,'',a.off_id,?) "+
				"        and nvl(a.use_yn,'Y')='Y' and a.off_id=b.OFF_id AND a.car_comp_id=c.code";

		try {
								
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  car_comp_id);
			pstmt.setString(2,  dlv_ext);
			pstmt.setString(3,  off_id);
			pstmt.setString(4,  off_id);
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
			System.out.println("[ConsignmentDatabase:getConsignmentPurMan]\n"+e);
			System.out.println("[ConsignmentDatabase:getConsignmentPurMan]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}		
	}

	/**
	 * 협력업체 출고대리인 조회
	 */	
	public Vector getPurManSearch(String off_id, String car_comp_id, String dlv_ext, String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT DISTINCT st, nm, ssn, m_tel "+
				" FROM  "+
				"        ( "+
				"          SELECT '건별' st, a.driver_nm AS nm, a.driver_ssn AS ssn, a.driver_m_tel AS m_tel "+
				"          FROM   CONS_PUR a, CAR_PUR b "+
				"          WHERE  to_char(a.reg_dt,'YYYYMMDD') > to_char(add_months(sysdate,-1),'YYYYMMDD') "+
				"                 AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd "+
				"                 AND b.off_id='"+off_id+"' "+
				"          UNION ALL "+
				"          SELECT '지정' st, a.man_nm AS nm, a.man_ssn AS ssn, a.man_tel AS m_tel "+
				"          FROM   CONS_PUR_MAN a "+
				"          WHERE  a.off_id='"+off_id+"' AND a.car_comp_id='"+car_comp_id+"' AND a.dlv_ext='"+dlv_ext+"' "+
				"        ) "+
				" where nm is not null ";

		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and nm like '%"+t_wd+"%'";		
		}

		query += " ORDER BY nm ";

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
			System.out.println("[ConsignmentDatabase:getPurManSearch]\n"+e);
			System.out.println("[ConsignmentDatabase:getPurManSearch]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		

	}

	//탁송현황 리스트 조회
	public Vector getConsignmentPurUseList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT e.nm AS car_comp_nm, b.rpt_no, substr(b.dlv_est_dt,1,8) dlv_est_dt, b.DLV_ext, \n"+
				"        DECODE(b.udt_st,'1','서울본사','2','부산지점','3','대전지점','4','고객','5','대구지점','6','광주지점') udt_st_nm,  \n"+
				"        b.cons_amt1, h.car_off_nm, g.emp_nm, NVL(h.car_off_tel,g.emp_m_tel) emp_tel,  \n"+
				"        DECODE(a.cancel_dt,'',decode(i.cons_no,'','신규','변경'),'취소') use_st_nm,  \n"+
				"        DECODE(i.cng_st,'1','출고일변경','2','배달지변경') cng_st_nm,  \n"+
				"        i.cng_cont, j.user_nm AS req_nm, k.br_nm, m.car_nm, d.car_name, n.off_nm, \n"+
				"        a.*  \n"+
				" FROM   CONS_PUR a, cont l, CAR_PUR b, CAR_ETC c, CAR_NM d, car_mng m,  \n"+
				"        (SELECT * FROM CODE WHERE c_st='0001') e, \n"+
				"        (SELECT * FROM COMMI WHERE agnt_st='2') f, \n"+
				"        CAR_OFF_EMP g, CAR_OFF h, \n"+
				"        (select * from CONS_PUR_CNG a where a.seq = (select max(seq) from CONS_PUR_CNG WHERE cons_no=a.cons_no)) i,   \n"+
				"        users j, BRANCH k, serv_off n "+
				" WHERE  a.driver_nm is not null and a.dlv_dt is null and a.udt_dt is null and a.cancel_dt is null "+
				"        and a.rent_mng_id=l.rent_mng_id AND a.rent_l_cd=l.rent_l_cd \n"+
//				"        and decode(a.rent_l_cd,'S414HACR00061','Y',nvl(l.use_yn,'Y'))='Y' "+
//				"        and decode(b.off_id,'',nvl(l.use_yn,'Y'),'Y')='Y' "+
				"        and decode(l.use_yn,'Y',l.use_yn,'','Y','N',decode(b.off_id,'','N','Y'))='Y' "+
				"	     and a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd \n"+
				"        AND b.rent_mng_id=c.rent_mng_id AND b.rent_l_cd=c.rent_l_cd \n"+
				"        AND c.car_id=d.car_id AND c.car_seq=d.car_seq and d.car_comp_id=m.car_comp_id and d.car_cd=m.code \n"+
				"        AND d.car_comp_id=E.CODE \n"+
				"        AND b.rent_mng_id=f.rent_mng_id AND b.rent_l_cd=f.rent_l_cd \n"+
				"        AND f.emp_id=g.emp_id \n"+
				"        AND g.car_off_id=h.car_off_id \n"+
				"        AND a.cons_no=i.cons_no(+) and a.req_id=j.user_id AND j.br_id=k.br_id "+
			    "        and b.off_id=n.off_id "+
				" ";

		String dt1 = "to_char(a.reg_dt,'YYYYMM')";
		String dt2 = "to_char(a.reg_dt,'YYYYMMDD')";

		if(gubun6.equals("2")){
			dt1 = "substr(b.dlv_est_dt,1,6)";
			dt2 = "substr(b.dlv_est_dt,1,8)";
		}else if(gubun6.equals("3")){
			dt1 = "substr(a.dlv_dt,1,6)";
			dt2 = "a.dlv_dt";
		}else if(gubun6.equals("4")){
			dt1 = "substr(a.udt_dt,1,6)";
			dt2 = "a.udt_dt";
		}

		if(gubun1.equals("1"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun1.equals("3"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
		else if(gubun1.equals("4"))		query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";
		else if(gubun1.equals("5"))		query += " and "+dt2+" = to_char(sysdate+1,'YYYYMMDD')";
		else if(gubun1.equals("6"))		query += " and "+dt2+" = to_char(sysdate+2,'YYYYMMDD')";
		else if(gubun1.equals("7"))		query += " and "+dt2+" = to_char(sysdate+3,'YYYYMMDD')";
		else if(gubun1.equals("8"))		query += " and "+dt2+" = to_char(sysdate+4,'YYYYMMDD')";
		else if(gubun1.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		// if(!gubun2.equals(""))			query += " and b.off_id = '"+gubun2+"' ";
		
		if(!gubun2.equals("")) {
			if (gubun2.equals("009026")) {
				query += " and b.off_id in('009026','011372') ";
			} else if (gubun2.equals("011372")) {
				query += " and b.off_id in('009026','011372') ";
			} else {
				query += " and b.off_id = '"+gubun2+"' ";
			}
		}

		if(gubun3.equals("1"))			query += " and d.car_comp_id = '0001' ";
		if(gubun3.equals("2"))			query += " and d.car_comp_id = '0002' ";
		if(gubun3.equals("3"))			query += " and d.car_comp_id > '0002' ";

		if(!gubun4.equals(""))			query += " and b.DLV_ext like upper('%"+gubun4+"%') ";

		if(!gubun5.equals(""))			query += " and b.udt_st = '"+gubun5+"' ";


		String search = "";
		String what = "";

		if(s_kd.equals("1"))	what = "upper(nvl(k.br_id||k.br_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(b.off_nm, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(b.rpt_no, ' '))";
		if(s_kd.equals("4"))	what = "upper(nvl(h.car_off_nm||g.emp_nm, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(j.user_nm, ' '))";
			
		if(!s_kd.equals("") && !t_wd.equals("")){
			if(s_kd.equals("3"))	query += " and "+what+" like replace('%"+t_wd+"%', '-','')";
			else					query += " and "+what+" like upper('%"+t_wd+"%') ";
		}else{

		}	


		query += " order by b.off_id, b.dlv_est_dt, b.udt_est_dt, b.dlv_ext, b.udt_st, a.cons_no desc ";

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
//			System.out.println("[ConsignmentDatabase:getConsignmentPurUseList]\n"+query);
		} catch (SQLException e) {
			System.out.println("[ConsignmentDatabase:getConsignmentPurUseList]\n"+e);
			System.out.println("[ConsignmentDatabase:getConsignmentPurUseList]\n"+query);
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

	//탁송현황 리스트 조회
	public Vector getConsignmentPurEndList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT e.nm AS car_comp_nm, b.rpt_no, substr(b.dlv_est_dt,1,8) dlv_est_dt, b.DLV_ext, \n"+
				"        DECODE(b.udt_st,'1','서울본사','2','부산지점','3','대전지점','4','고객','5','대구지점','6','광주지점') udt_st_nm,  \n"+
				"        b.cons_amt1, h.car_off_nm, g.emp_nm, NVL(h.car_off_tel,g.emp_m_tel) emp_tel,  \n"+
				"        DECODE(a.cancel_dt,'',decode(i.cons_no,'','신규','변경'),'취소') use_st_nm,  \n"+
				"        DECODE(i.cng_st,'1','출고일변경','2','배달지변경') cng_st_nm,  \n"+
				"        i.cng_cont, j.user_nm AS req_nm, k.br_nm, m.car_nm, d.car_name, n.off_nm, o.init_reg_dt, \n"+
				"        a.*  \n"+
				" FROM   CONS_PUR a, cont l, CAR_PUR b, CAR_ETC c, CAR_NM d, car_mng m,  \n"+
				"        (SELECT * FROM CODE WHERE c_st='0001') e, \n"+
				"        (SELECT * FROM COMMI WHERE agnt_st='2') f, \n"+
				"        CAR_OFF_EMP g, CAR_OFF h, \n"+
				"        (select * from CONS_PUR_CNG a where a.seq = (select max(seq) from CONS_PUR_CNG WHERE cons_no=a.cons_no)) i,   \n"+
				"        users j, BRANCH k, serv_off n, car_reg o "+
				" WHERE  a.dlv_dt is not null and a.udt_dt is null and a.cancel_dt is null and a.return_dt is null  "+
				"        and a.rent_mng_id=l.rent_mng_id AND a.rent_l_cd=l.rent_l_cd \n"+
				"        and decode(l.use_yn,'Y',l.use_yn,'','Y','N',decode(b.off_id,'','N','Y'))='Y' "+
				"	     and a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd \n"+
				"        AND b.rent_mng_id=c.rent_mng_id AND b.rent_l_cd=c.rent_l_cd \n"+
				"        AND c.car_id=d.car_id AND c.car_seq=d.car_seq and d.car_comp_id=m.car_comp_id and d.car_cd=m.code \n"+
				"        AND d.car_comp_id=E.CODE \n"+
				"        AND b.rent_mng_id=f.rent_mng_id AND b.rent_l_cd=f.rent_l_cd \n"+
				"        AND f.emp_id=g.emp_id \n"+
				"        AND g.car_off_id=h.car_off_id \n"+
				"        AND a.cons_no=i.cons_no(+) and a.req_id=j.user_id AND j.br_id=k.br_id "+
			    "        and b.off_id=n.off_id "+
			    "        and l.car_mng_id=o.car_mng_id(+) "+
				" ";

		String dt1 = "substr(a.dlv_dt,1,6)";
		String dt2 = "a.dlv_dt";

		if(gubun1.equals("1"))			query += " and "+dt1+" = to_char(sysdate,'YYYYMM')";
		else if(gubun1.equals("3"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
		else if(gubun1.equals("4"))		query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";
		else if(gubun1.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		// if(!gubun2.equals(""))			query += " and b.off_id = '"+gubun2+"' ";
		
		if(!gubun2.equals("")) {
			if (gubun2.equals("009026")) {
				query += " and b.off_id in('009026','011372') ";
			} else if (gubun2.equals("011372")) {
				query += " and b.off_id in('009026','011372') ";
			} else {
				query += " and b.off_id = '"+gubun2+"' ";
			}
		}
		
		if(gubun3.equals("1"))			query += " and d.car_comp_id = '0001' ";
		if(gubun3.equals("2"))			query += " and d.car_comp_id = '0002' ";
		if(gubun3.equals("3"))			query += " and d.car_comp_id > '0002' ";

		if(!gubun4.equals(""))			query += " and b.DLV_ext like upper('%"+gubun4+"%') ";

		if(!gubun5.equals(""))			query += " and b.udt_st = '"+gubun5+"' ";


		String search = "";
		String what = "";

		if(s_kd.equals("1"))	what = "upper(nvl(k.br_id||k.br_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(b.off_nm, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(b.rpt_no, ' '))";
		if(s_kd.equals("4"))	what = "upper(nvl(h.car_off_nm||g.emp_nm, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(j.user_nm, ' '))";
			
		if(!s_kd.equals("") && !t_wd.equals("")){
			if(s_kd.equals("3"))	query += " and "+what+" like replace('%"+t_wd+"%', '-','')";
			else					query += " and "+what+" like upper('%"+t_wd+"%') ";
		}else{

		}	


		query += " order by b.off_id, b.udt_est_dt, b.dlv_ext, b.udt_st, a.cons_no desc ";

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
//			System.out.println("[ConsignmentDatabase:getConsignmentPurEndList]\n"+query);
		} catch (SQLException e) {
			System.out.println("[ConsignmentDatabase:getConsignmentPurEndList]\n"+e);
			System.out.println("[ConsignmentDatabase:getConsignmentPurEndList]\n"+query);
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

	//탁송현황 리스트 조회
	public Vector getConsignmentPurCancelList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT e.nm AS car_comp_nm, b.rpt_no, substr(b.dlv_est_dt,1,8) dlv_est_dt, b.DLV_ext, \n"+
				"        DECODE(b.udt_st,'1','서울본사','2','부산지점','3','대전지점','4','고객','5','대구지점','6','광주지점') udt_st_nm,  \n"+
				"        b.cons_amt1, h.car_off_nm, g.emp_nm, NVL(h.car_off_tel,g.emp_m_tel) emp_tel,  \n"+
				"        DECODE(a.cancel_dt,'',decode(i.cons_no,'','신규','변경'),'취소') use_st_nm,  \n"+
				"        DECODE(i.cng_st,'1','출고일변경','2','배달지변경') cng_st_nm,  \n"+
				"        i.cng_cont, j.user_nm AS req_nm, k.br_nm, m.car_nm, d.car_name, \n"+
				"        a.*  \n"+
				" FROM   CONS_PUR a, cont l, CAR_PUR b, CAR_ETC c, CAR_NM d, car_mng m,  \n"+
				"        (SELECT * FROM CODE WHERE c_st='0001') e, \n"+
				"        (SELECT * FROM COMMI WHERE agnt_st='2') f, \n"+
				"        CAR_OFF_EMP g, CAR_OFF h, \n"+
				"        (select * from CONS_PUR_CNG a where a.seq = (select max(seq) from CONS_PUR_CNG WHERE cons_no=a.cons_no)) i,   \n"+
				"        users j, BRANCH k "+
				" WHERE  a.cancel_dt is not null "+
				"        and a.rent_mng_id=l.rent_mng_id AND a.rent_l_cd=l.rent_l_cd \n"+
				"	     and a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd \n"+
				"        AND b.rent_mng_id=c.rent_mng_id AND b.rent_l_cd=c.rent_l_cd \n"+
				"        AND c.car_id=d.car_id AND c.car_seq=d.car_seq and d.car_comp_id=m.car_comp_id and d.car_cd=m.code \n"+
				"        AND d.car_comp_id=E.CODE \n"+
				"        AND b.rent_mng_id=f.rent_mng_id AND b.rent_l_cd=f.rent_l_cd \n"+
				"        AND f.emp_id=g.emp_id \n"+
				"        AND g.car_off_id=h.car_off_id \n"+
				"        AND a.cons_no=i.cons_no(+) and a.req_id=j.user_id AND j.br_id=k.br_id "+
				" ";

		String dt1 = "to_char(a.cancel_dt,'YYYYMM')";
		String dt2 = "to_char(a.cancel_dt,'YYYYMMDD')";

		if(gubun1.equals("1"))			query += " and "+dt1+" = to_char(sysdate,'YYYYMM')";
		else if(gubun1.equals("3"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
		else if(gubun1.equals("4"))		query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";
		else if(gubun1.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		// if(!gubun2.equals(""))			query += " and b.off_id = '"+gubun2+"' ";
		
		if(!gubun2.equals("")) {
			if (gubun2.equals("009026")) {
				query += " and b.off_id in('009026','011372') ";
			} else if (gubun2.equals("011372")) {
				query += " and b.off_id in('009026','011372') ";
			} else {
				query += " and b.off_id = '"+gubun2+"' ";
			}
		}

		if(gubun3.equals("1"))			query += " and d.car_comp_id = '0001' ";
		if(gubun3.equals("2"))			query += " and d.car_comp_id = '0002' ";
		if(gubun3.equals("3"))			query += " and d.car_comp_id > '0002' ";

		if(!gubun4.equals(""))			query += " and b.DLV_ext like upper('%"+gubun4+"%') ";

		if(!gubun5.equals(""))			query += " and b.udt_st = '"+gubun5+"' ";


		String search = "";
		String what = "";

		if(s_kd.equals("1"))	what = "upper(nvl(k.br_id||k.br_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(b.off_nm, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(b.rpt_no, ' '))";
		if(s_kd.equals("4"))	what = "upper(nvl(h.car_off_nm||g.emp_nm, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(j.user_nm, ' '))";
			
		if(!s_kd.equals("") && !t_wd.equals("")){
			if(s_kd.equals("3"))	query += " and "+what+" like replace('%"+t_wd+"%', '-','')";
			else					query += " and "+what+" like upper('%"+t_wd+"%') ";
		}else{

		}	


		query += " order by a.cancel_dt desc ";

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
//			System.out.println("[ConsignmentDatabase:getConsignmentPurCancelList]\n"+query);
		} catch (SQLException e) {
			System.out.println("[ConsignmentDatabase:getConsignmentPurCancelList]\n"+e);
			System.out.println("[ConsignmentDatabase:getConsignmentPurCancelList]\n"+query);
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

	public boolean updateConsignmentPurCancel(String rent_mng_id, String rent_l_cd, String cancel_id)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update cons_pur set "+
						"   cancel_dt=sysdate, cancel_id=? "+
						" where rent_mng_id=? and rent_l_cd=? and cancel_dt is null ";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);			
			pstmt.setString(1, cancel_id);
			pstmt.setString(2, rent_mng_id);
			pstmt.setString(3, rent_l_cd);
			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[ConsignmentDatabase:updateConsignmentPurCancel]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}


//탁송기사별 리스트 조회
	public Vector getConsignmentReqDocListDrv(String req_code, String pay_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT driver_nm, SUM(cons_amt) cons_amt, SUM(wash_amt) wash_amt,  SUM(hipass_amt) hipass_amt, SUM(oil_amt) oil_amt, SUM(other_amt) other_amt, SUM(tot_amt) tot_amt from (select"+
				" a.*, c.user_nm as user_nm1, d.user_nm as user_nm2, b.user_dt1, b.user_dt2, f.nm as cons_cau_nm"+
				" from consignment a, (select * from doc_settle where doc_st='2') b, users c, users d, branch e, "+
				" (select * from code where c_st='0015' and code<>'0000') f, (select * from doc_settle where doc_st='3') g"+
				" where a.cons_no=b.doc_id(+) and b.user_id1=c.user_id(+) and b.user_id2=d.user_id(+) and c.br_id=e.br_id(+) and a.cons_cau=f.nm_cd(+) and a.req_code=g.doc_id"+
				" and a.req_dt is not null and a.conf_dt is not null and g.doc_id='"+req_code+"'";//and a.pay_dt is null 

		if(!pay_dt.equals(""))	query +=" and a.pay_dt = replace('"+pay_dt+"','-','')";
//		else					query +=" and a.pay_dt is null";

		query += " order by a.off_id, a.from_dt, a.cons_no, a.seq ) group by driver_nm  ORDER BY driver_nm ";

//System.out.println("[getConsignmentReqDocListDrv]:"+query);
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
			System.out.println("[ConsignmentDatabase:getConsignmentReqDocListDrv]\n"+e);
			System.out.println("[ConsignmentDatabase:getConsignmentReqDocListDrv]\n"+query);
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


//청구서작성 리스트 조회
	public Vector getConsignmentReqListDrv(String s_kd, String t_wd, String gubun1, String st_dt, String end_dt, String gubun2, String gubun3, String mode)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT driver_nm, SUM(cons_amt) cons_amt, SUM(wash_amt) wash_amt, SUM(wash_fee) wash_fee,  SUM(hipass_amt) hipass_amt, SUM(oil_amt) oil_amt, SUM(other_amt) other_amt, SUM(tot_amt) tot_amt from ( select"+
				" a.*, decode(a.off_nm,'코리아탁송','본사',e.br_nm) br_nm, b.doc_no, c.user_nm as user_nm1, d.user_nm as user_nm2, b.user_dt1, b.user_dt2, f.nm as cons_cau_nm, decode(a.cons_st,'1','편도','2','왕복') as cons_st_nm,"+
				" decode(a.conf_dt,'','미확인','확인') conf_st_nm, decode(b.user_dt6,'','미확인','확인') conf_st_nm2, decode(a.pay_st,'1','선불','2','후불') pay_st_nm, decode(a.cost_st,'1','아마존카','2','고객') cost_st_nm"+
				" from consignment a, (select * from doc_settle where doc_st='2') b, users c, users d, branch e, (select * from code where c_st='0015' and code<>'0000') f"+
				" where a.off_id<>'003158' and a.cons_no=b.doc_id(+) and b.user_id1=c.user_id(+) and b.user_id2=d.user_id(+) and c.br_id=e.br_id(+) and a.cons_cau=f.nm_cd(+)"+
				" and a.req_dt is not null and a.pay_dt is null and b.user_dt7 is null"; 

		String search = "";
		String what = "";

		if(s_kd.equals("2"))	what = "upper(nvl(a.off_nm, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(a.from_place||a.to_place||a.from_comp||a.to_comp, ' '))";
		if(s_kd.equals("4"))	what = "upper(nvl(a.car_no, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(c.user_nm, ' '))";
		if(s_kd.equals("6"))	what = "upper(nvl(a.cons_no, ' '))";
		if(s_kd.equals("7"))	what = "upper(nvl(a.OTHER, ' '))";
		if(s_kd.equals("8"))	what = "upper(nvl(a.DRIVER_NM, ' '))";
		if(s_kd.equals("9"))	what = "a.tot_amt";

			
		if(!s_kd.equals("") && !t_wd.equals("")){

				query += " and "+what+" like upper('"+t_wd+"%') ";

		}	

		if(gubun1.equals("1"))			query += " and a.req_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun1.equals("3"))		query += " and a.req_dt = to_char(sysdate,'YYYYMMDD')";
		else if(gubun1.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and a.req_dt like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and a.req_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}else if(gubun1.equals("4")){ //탁송출발 일시를 기간으로 검색
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and a.from_dt like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and substr(a.from_dt,0,8) between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		if(!gubun2.equals(""))			query += " and decode(a.off_nm,'코리아탁송','S1','(주)코리아탁송무역','S1',c.br_id)='"+gubun2+"'";

		if(gubun3.equals("1"))			query += " and b.user_dt5 is not null";
		if(gubun3.equals("2"))			query += " and b.user_dt6 is not null";
		if(gubun3.equals("3"))			query += " and b.user_dt5 is not null and b.user_dt6 is not null";
		if(gubun3.equals("4"))			query += " and b.user_dt5 is null";
		if(gubun3.equals("5"))			query += " and b.user_dt6 is null";

		if(gubun1.equals("4")){ //탁송출발 일시로 검색시 차량번호 뒤에 4자리로 정렬

			query += " order by substr(a.car_no, -4) ";

		}else if(mode.equals("p"))			query += " order by a.req_dt, a.cons_no, a.seq, a.from_dt ";
		else							query += " order by a.off_id, decode(decode(a.off_nm,'코리아탁송','S1',c.br_id),'S1',1,'B1',2,'D1',3), a.req_dt, a.cons_no, a.seq";

		query += ") GROUP BY driver_nm	order by driver_nm ";

//System.out.println("getConsignmentReqListDrv( "+s_kd);
//System.out.println("getConsignmentReqListDrv( "+t_wd);
//System.out.println("getConsignmentReqListDrv( "+query);
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
			System.out.println("[ConsignmentDatabase:getConsignmentReqListDrv]\n"+e);
			System.out.println("[ConsignmentDatabase:getConsignmentReqListDrv]\n"+query);
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

	//배달탁송현황
	public Vector getConsignmentPurStatList(String s_kd, String t_wd, String gubun1, String gubun2, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String sub_query = "";
		String query = "";

				sub_query = " select  g.nm, b.dlv_ext, b.off_nm, e.car_nm, b.udt_st, a.rent_l_cd, decode(a.return_dt,'',b.cons_amt1,a.return_amt) cons_amt1 "+
					" FROM   CONS_PUR a, CAR_PUR b, CAR_ETC c, CAR_NM d, CAR_MNG e, CONT f, (SELECT * FROM CODE WHERE c_st='0001') g "+
					" WHERE  a.rent_mng_id=b.RENT_mng_id AND a.rent_l_cd=b.RENT_L_CD "+
					"        AND b.rent_mng_id=c.rent_mng_id AND b.RENT_L_CD=c.rent_l_cd "+
					"        AND c.car_id=d.car_id AND c.CAR_seq=d.car_seq AND d.car_comp_id=e.car_comp_id AND d.car_cd=E.CODE "+
					"        AND a.rent_mng_id=f.rent_mng_id AND a.RENT_L_CD=f.rent_l_cd "+
					"        AND d.car_comp_id=G.CODE "+
					"        AND a.CANCEL_DT IS NULL "+
					" ";

		if(gubun1.equals("1"))							sub_query += " and f.dlv_dt like to_char(sysdate,'YYYYMM')||'%'";
 		else if(gubun1.equals("4"))						sub_query += " and f.dlv_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%'";
		else if(gubun1.equals("5"))						sub_query += " and f.dlv_dt like to_char(sysdate,'YYYY')||'%'";
		else if(gubun1.equals("6"))						sub_query += " and f.dlv_dt like to_char(add_months(sysdate,-12),'YYYY')||'%'";
		else if(gubun1.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	sub_query += " and f.dlv_dt like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) sub_query += " and f.dlv_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		String search = "";
		String what = "";

		if(s_kd.equals("2"))	what = "upper(nvl(b.off_nm, ' '))";	
			
		if(!s_kd.equals("") && !t_wd.equals("")){
			sub_query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		query = " select nm, dlv_ext, off_nm, car_nm, "+
				"        COUNT(DECODE(udt_st,'1',rent_l_cd)) cnt1,        "+
				"        MAX  (DECODE(udt_st,'1',cons_amt1)) d_cons_amt1, "+
				"        SUM  (DECODE(udt_st,'1',cons_amt1)) h_cons_amt1, "+
				"        COUNT(DECODE(udt_st,'2',rent_l_cd)) cnt2,        "+
				"        MAX  (DECODE(udt_st,'2',cons_amt1)) d_cons_amt2, "+
				"        SUM  (DECODE(udt_st,'2',cons_amt1)) h_cons_amt2, "+
				"        COUNT(DECODE(udt_st,'3',rent_l_cd)) cnt3,        "+
				"        MAX  (DECODE(udt_st,'3',cons_amt1)) d_cons_amt3, "+
				"        SUM  (DECODE(udt_st,'3',cons_amt1)) h_cons_amt3, "+
				"        COUNT(DECODE(udt_st,'5',rent_l_cd)) cnt4,        "+
				"        MAX  (DECODE(udt_st,'5',cons_amt1)) d_cons_amt4, "+
				"        SUM  (DECODE(udt_st,'5',cons_amt1)) h_cons_amt4, "+
				"        COUNT(DECODE(udt_st,'6',rent_l_cd)) cnt5,        "+
				"        MAX  (DECODE(udt_st,'6',cons_amt1)) d_cons_amt5, "+
				"        SUM  (DECODE(udt_st,'6',cons_amt1)) h_cons_amt5, "+
				"        COUNT(rent_l_cd) cnt6,                "+
				"        SUM  (cons_amt1) h_cons_amt6 "+
				" from   ("+sub_query+")  "+
				" GROUP BY nm, dlv_ext, off_nm, car_nm "+
				" ORDER BY nm, dlv_ext, off_nm, car_nm "+
				" ";


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
//			System.out.println("[ConsignmentDatabase:getConsignmentPurStatList]\n"+sub_query);
		} catch (SQLException e) {
			System.out.println("[ConsignmentDatabase:getConsignmentPurStatList]\n"+e);
			System.out.println("[ConsignmentDatabase:getConsignmentPurStatList]\n"+query);
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

	//월별 업체별 탁송료 현황
	public Vector getConsOffStat(String gubun1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " select"+
				" substr(a.pay_dt,1,6) ym,"+

				" count(a.cons_no) cnt0,"+
				" sum(a.tot_amt) amt0,"+

				" count(decode(a.off_nm,'(주)아마존카',a.cons_no)) cnt1,"+
				" sum(decode(a.off_nm,'(주)아마존카',a.tot_amt)) amt1,"+

				" count(decode(a.off_nm,'전국',a.cons_no)) cnt2,"+
				" sum(decode(a.off_nm,'전국',a.tot_amt)) amt2,"+

				" count(decode(a.off_nm,'(주)삼진특수',a.cons_no)) cnt3,"+
				" sum(decode(a.off_nm,'(주)삼진특수',a.tot_amt)) amt3,"+

				" count(decode(a.off_nm,'(주)영원물류',a.cons_no,'상원물류(주)',a.cons_no)) cnt4,"+
				" sum(decode(a.off_nm,'(주)영원물류',a.tot_amt,'상원물류(주)',a.tot_amt)) amt4,"+

				" count(decode(a.off_nm,'하이카콤(대전)',a.cons_no)) cnt5,"+
				" sum(decode(a.off_nm,'하이카콤(대전)',a.tot_amt)) amt5,"+

				" count(decode(a.off_nm,'하이카콤(부산)',a.cons_no)) cnt6,"+
				" sum(decode(a.off_nm,'하이카콤(부산)',a.tot_amt)) amt6,"+

				" count(decode(a.off_nm,'일등전국(부산)',a.cons_no,'에프앤티코리아(부산)',a.cons_no)) cnt7,"+
				" sum(decode(a.off_nm,'일등전국(부산)',a.tot_amt,'에프앤티코리아(부산)',a.tot_amt)) amt7,"+
				
				" count(decode(a.off_nm,'일등전국(광주)',a.cons_no,'에프앤티코리아(광주)',a.cons_no)) cnt8,"+
				" sum(decode(a.off_nm,'일등전국(광주)',a.tot_amt,'에프앤티코리아(광주)',a.tot_amt)) amt8,"+
				
				" count(decode(a.off_nm,'일등전국(대구)',a.cons_no,'에프앤티코리아(대구)',a.cons_no)) cnt9,"+
				" sum(decode(a.off_nm,'일등전국(대구)',a.tot_amt,'에프앤티코리아(대구)',a.tot_amt)) amt9,"+
				
				" count(decode(a.off_nm,'퍼스트드라이브(대전)',a.cons_no)) cnt10,"+
				" sum(decode(a.off_nm,'퍼스트드라이브(대전)',a.tot_amt)) amt10"+

				" from   consignment a, doc_settle b, users c"+
				" where  a.cons_no=b.doc_id and b.doc_st='2' and b.user_id1=c.user_id"+
                "        AND a.pay_dt <= TO_CHAR(SYSDATE,'YYYYMMDD') and a.tot_amt >0 "+ 
				" ";

		if(!gubun1.equals(""))		query += " and a.pay_dt like '"+gubun1+"%'";

		query += " group by substr(a.pay_dt,1,6) order by substr(a.pay_dt,1,6)";

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
			
			System.out.println("[ConsignmentDatabase:getConsOffStat]"+ e);
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

	//월별 업체별 탁송료 현황
	public Vector getConsBrStat(String gubun1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " select"+
				" substr(a.pay_dt,1,6) ym,"+

				" count(a.cons_no) cnt0,"+
				" sum(a.tot_amt) amt0,"+

				" count(decode(c.br_id,'S1',a.cons_no)) cnt1,"+
				" sum(decode(c.br_id,'S1',a.tot_amt)) amt1,"+

				" count(decode(c.br_id,'S2',a.cons_no)) cnt2,"+
				" sum(decode(c.br_id,'S2',a.tot_amt)) amt2,"+

				" count(decode(c.br_id,'J1',a.cons_no)) cnt3,"+
				" sum(decode(c.br_id,'J1',a.tot_amt)) amt3,"+

				" count(decode(c.br_id,'G1',a.cons_no)) cnt4,"+
				" sum(decode(c.br_id,'G1',a.tot_amt)) amt4,"+

				" count(decode(c.br_id,'D1',a.cons_no)) cnt5,"+
				" sum(decode(c.br_id,'D1',a.tot_amt)) amt5,"+

				" count(decode(c.br_id,'B1',a.cons_no)) cnt6,"+
				" sum(decode(c.br_id,'B1',a.tot_amt)) amt6,"+

				" count(decode(c.br_id,'K3',a.cons_no)) cnt7,"+
				" sum(decode(c.br_id,'K3',a.tot_amt)) amt7,"+

				" count(decode(c.br_id,'I1',a.cons_no)) cnt8,"+
				" sum(decode(c.br_id,'I1',a.tot_amt)) amt8"+

				" from   consignment a, doc_settle b, users c"+
				" where  a.cons_no=b.doc_id and b.doc_st='2' and b.user_id1=c.user_id"+
                "        AND a.pay_dt <= TO_CHAR(SYSDATE,'YYYYMMDD') and a.tot_amt >0 "+ 
				" ";

		if(!gubun1.equals(""))		query += " and a.pay_dt like '"+gubun1+"%'";

		query += " group by substr(a.pay_dt,1,6) order by substr(a.pay_dt,1,6)";

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
			
			System.out.println("[ConsignmentDatabase:getConsBrStat]"+ e);
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

	//사원별 탁송료 현황
	public Vector getConsUserStat(String gubun1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " select"+
				" d.nm, c.user_nm, c.user_id, "+

				" count(a.cons_no) cnt0,"+	
				" count(decode(substr(a.pay_dt,5,2),'01',a.cons_no)) cnt1,"+
				" count(decode(substr(a.pay_dt,5,2),'02',a.cons_no)) cnt2,"+
				" count(decode(substr(a.pay_dt,5,2),'03',a.cons_no)) cnt3,"+
				" count(decode(substr(a.pay_dt,5,2),'04',a.cons_no)) cnt4,"+
				" count(decode(substr(a.pay_dt,5,2),'05',a.cons_no)) cnt5,"+
				" count(decode(substr(a.pay_dt,5,2),'06',a.cons_no)) cnt6,"+
				" count(decode(substr(a.pay_dt,5,2),'07',a.cons_no)) cnt7,"+
				" count(decode(substr(a.pay_dt,5,2),'08',a.cons_no)) cnt8,"+
				" count(decode(substr(a.pay_dt,5,2),'09',a.cons_no)) cnt9,"+
				" count(decode(substr(a.pay_dt,5,2),'10',a.cons_no)) cnt10,"+
				" count(decode(substr(a.pay_dt,5,2),'11',a.cons_no)) cnt11,"+
				" count(decode(substr(a.pay_dt,5,2),'12',a.cons_no)) cnt12"+

				" from consignment a, doc_settle b, users c, (select * from code where c_st='0002' and code<>'0000') d"+
				" where a.cons_no=b.doc_id and b.doc_st='2' and b.user_id1=c.user_id and c.dept_id=d.code"+
                "        AND a.pay_dt <= TO_CHAR(SYSDATE,'YYYYMMDD') and a.tot_amt >0 "+ 
				" ";

		if(!gubun1.equals(""))		query += " and a.pay_dt like '"+gubun1+"%'";

		query += " group by d.nm, c.user_nm, c.user_id";

		query += " order by count(a.cons_no) desc";

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
			
			System.out.println("[ConsignmentDatabase:getConsUserStat]"+ e);
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



//차량인도결과 리스트 조회
	public Vector getConsignmentOKSMSList(String cons_no, String seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select * from CONS_OKSMS where cons_no = '"+cons_no+"' /* and seq = '"+seq+"' */ ";

		query += " order by seq ";

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
			System.out.println("[ConsignmentDatabase:getConsignmentOKSMSList]\n"+e);
			System.out.println("[ConsignmentDatabase:getConsignmentOKSMSList]\n"+query);
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


//주유카드로 주유시 oil_card_amt 에 금액 넣기
	public boolean updateConsignmentOil_card_amt2(String cons_no, int oil_card_amt)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update CONSIGNMENT set oil_card_amt=? where cons_no=?";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);		
			pstmt.setInt(1,  oil_card_amt);
			pstmt.setString(2,  cons_no);
			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[ConsignmentDatabase:updateConsignmentOil_card_amt]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

//주유카드로 주유시 oil_card_amt 에 금액 넣기 -car_mng_id 가 아닌 rent_l_cd
	public boolean updateConsignmentOil_card_amt(String cons_no,String seq,  String rent_l_cd, int oil_card_amt)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		int n_seq = 0;
		
		n_seq = Integer.parseInt(seq);
		
		String query =  " update CONSIGNMENT set oil_card_amt=? where cons_no=? and rent_l_cd = ? and seq = ? ";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);		
			pstmt.setInt(1,  oil_card_amt);
			pstmt.setString(2,  cons_no);
			pstmt.setString(3,  rent_l_cd);
			pstmt.setInt(4,  n_seq);
			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[ConsignmentDatabase:updateConsignmentOil_card_amt]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

//주유카드로 주유시 oil_card_amt 에 금액 넣기 -car_mng_id 가 아닌 rent_l_cd
	public boolean updateConsignmentWash_card_amt(String cons_no,String seq,  String rent_l_cd, int wash_card_amt)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		int n_seq = 0;
		
		n_seq = Integer.parseInt(seq);
		
		String query =  " update CONSIGNMENT set wash_card_amt=? where cons_no=? and rent_l_cd = ? and seq = ? ";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);		
			pstmt.setInt(1,  wash_card_amt);
			pstmt.setString(2,  cons_no);
			pstmt.setString(3,  rent_l_cd);
			pstmt.setInt(4,  n_seq);
			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[ConsignmentDatabase:updateConsignmentWash_card_amt]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}


	/**
     * 첨부파일 갱신
     */
    public int updateConsignmentParkingScan(String seq, String file_name, String cons_no, String gubun) 
    {
       	getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        int count = 0;

		if(gubun.equals("pk")){
		    query=" UPDATE consignment SET parking_file = ? WHERE seq = ? and cons_no = ? ";		
		}else{
			query=" UPDATE consignment SET psoilamt_file = ? WHERE seq = ? and cons_no = ? ";		
		}
	         
       try{

			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, file_name);
			pstmt.setString(2, seq);		      
			pstmt.setString(3, cons_no);
			count = pstmt.executeUpdate();             

			pstmt.close();
			
			conn.commit();
	


	  	} catch (Exception e) {
			System.out.println("[ConsignmentDatabase:updateConsignmentParkingScan]\n"+e);			
			System.out.println("[ConsignmentDatabase:updateConsignmentParkingScan]\n"+query);
	  		e.printStackTrace();
	  		count = 0;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}			
	}




//탁송인도인수문자관리 리스트 조회
	public Vector getConsignmentOksmsList(String s_kd, String t_wd, String gubun1, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String sub_query = "";
		String query = "";

		query = " select cons_no, seq, reg_nm, TO_CHAR(reg_dt,'YYYYMMDDHH24MISS') as reg_dt, reg_tel, car_no, client_nm, client_br, client_tel, dist_km, start_dt, end_dt, update_dt \n"+
				" from cons_oksms where";

		String search = "";
		String what = "";

		

		if(gubun1.equals("1"))			query += " TO_CHAR(reg_dt,'YYYYMM') = to_char(sysdate,'YYYYMM')";
		else if(gubun1.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and TO_CHAR(reg_dt,'YYYYMMDD') like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and TO_CHAR(reg_dt,'YYYYMMDD') between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		if(s_kd.equals("1"))	what = "upper(nvl(client_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(client_br, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(reg_nm, ' '))";
		if(s_kd.equals("4"))	what = "upper(nvl(car_no, ' '))";

			
		if(!s_kd.equals("") && !t_wd.equals("")){
								query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		query += " order by reg_dt desc, cons_no, seq ";

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
			System.out.println("[ConsignmentDatabase:getConsignmentOksmsList]\n"+e);
			System.out.println("[ConsignmentDatabase:getConsignmentOksmsList]\n"+query);
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

	//신차탁송인도일
	public String getContCarDeliDt(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String cons_dt = "";

		query = " select MIN(SUBSTR(NVL(REPLACE(REPLACE(to_dt,' ',''),'0000',''),REPLACE(REPLACE(to_req_dt,' ',''),'0000','')),1,8)) cons_dt from consignment WHERE rent_mng_id=? AND rent_l_cd=? AND cons_cau='1'";

		try {
								
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  rent_mng_id);
			pstmt.setString(2,  rent_l_cd);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{	
				cons_dt = rs.getString("cons_dt")==null?"":rs.getString("cons_dt");
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ConsignmentDatabase:getContCarDeliDt]\n"+e);
			System.out.println("[ConsignmentDatabase:getContCarDeliDt]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return cons_dt;
		}		
	}



//납품청구현황 리스트 조회
	public Hashtable getConsignment_Links(String cons_no, int seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " SELECT a.cons_no||a.seq AS cons_no, c.CON_AGNT_EMAIL, DECODE(a.cons_cau, '1','대여차량인도', '3','지연대차인도', '4','정비대차인도', '5','사고대차인도', '6','정비차량인도', '7','사고차량인도', '8','지연대차회수', '9','정비대차회수', '10','사고대차회수', '11','정비차량회수', '12','사고차량회수', '13','중도해지회수', '14','만기반납', '15','대여차량회수', '16','본사이동', '17','지점이동', '18','정기검사', '19','차량점검', '20','기타', '21','월렌트차량인도', '22','월렌트차량회수', '23','경매탁송') AS cons_cau,\n"+
				" CASE WHEN a.from_st = '1' OR a.from_st = '3' THEN a.to_comp ELSE  a.from_comp END AS firm_nm,  \n"+
				" CASE WHEN a.from_st = '1' OR a.from_st = '3' THEN a.to_place ELSE  a.from_place END AS firm_addr,  \n"+
				" CASE WHEN a.from_st = '1' OR a.from_st = '3' THEN a.to_tel   ELSE  a.from_tel   END AS firm_tel,  \n"+
				" CASE WHEN a.from_st = '1' OR a.from_st = '3' THEN a.to_m_tel ELSE  a.from_m_tel END AS firm_m_tel,  \n"+
				" a.car_no, a.CAR_NM, a.RENT_L_CD, NVL(c.ENP_NO,substr(TEXT_DECRYPT(c.ssn, 'pw' ) ,1,6) ) AS firm_ssn, b.USER_NM AS acar_mng,  \n"+
				" b.USER_M_TEL AS acar_tel, a.OFF_NM, a.DRIVER_NM AS off_drv, a.DRIVER_M_TEL AS off_drv_tel,  \n"+
				" decode(b.dept_id, '0001','영업팀', '0002','고객지원팀', '0003','총무팀', '0005', 'IT팀', '0007','부산지점', '0008','대전지점', '0009','강남지점', '0011','대구지점', '0010','광주지점', '0012','인천지점', '0013', '수원지점','0014', '강서지점','0015', '구로지점','0016', '울산지점','0017', '광화문지점','0018', '송파지점','1000','에이전트','-' ) AS dept_nm   \n"+
				" FROM CONSIGNMENT a, users b,  CLIENT c  \n"+
				" WHERE a.reg_id = b.user_id AND a.CLIENT_ID = c.CLIENT_ID AND a.cons_no = ? and a.seq = ?  ";

//	System.out.println("[ConsignmentDatabase:getConsignment_Links]\n"+query);
//	System.out.println("[ConsignmentDatabase:getConsignment_Links]cons_no:\n"+cons_no);
//	System.out.println("[ConsignmentDatabase:getConsignment_Links]seq:\n"+seq);

		try {
								
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  cons_no);
			pstmt.setInt(2,  seq);
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
			System.out.println("[ConsignmentDatabase:getConsignment_Links]\n"+e);
			System.out.println("[ConsignmentDatabase:getConsignment_Links]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}		
	}
	
	public Hashtable getConsignment_Links2(String cons_no_seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		
		query = " SELECT * FROM alink.CONSIGNMENT_LINK WHERE CONS_NO = ? ";
		
//	System.out.println("[ConsignmentDatabase:getConsignment_Links]\n"+query);
//	System.out.println("[ConsignmentDatabase:getConsignment_Links]cons_no:\n"+cons_no);
//	System.out.println("[ConsignmentDatabase:getConsignment_Links]seq:\n"+seq);
		
		try {
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  cons_no_seq);
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
			System.out.println("[ConsignmentDatabase:getConsignment_Links]\n"+e);
			System.out.println("[ConsignmentDatabase:getConsignment_Links]\n"+query);
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}		
	}


public String insertConsignment_Link(ConsignmentLinkBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		String cons_no = "";
		String tmsg_kncd = "";

		String query =  " insert into alink.CONSIGNMENT_LINK "+
						" ( CONS_NO, TMSG_SEQ, RENT_L_CD, DEPT_NM, CAR_NO, CAR_NM, REG_YMD, REG_TIME, CONS_CAU, FIRM_NM, FIRM_SSN, "+
						" FIRM_ADDR, FIRM_TEL, FIRM_M_TEL, FIRM_EMAIL, ACAR_MNG, ACAR_TEL, OFF_NM, OFF_DRV, OFF_DRV_TEL, CONS_YN, "+
						//채권양도통지서 및 위임장 데이터 추가(20181127)
						" B_TRF_YN, INS_COM_NM, FIRM_ZIP, CLIENT_NM, CLIENT_SSN, INS_REQ_AMT, INS_REQ_AMT_HAN, AC_CAR_NO, AC_CAR_NM, ACCID_DT, INS_USE_ST, INS_USE_ET,	"+
						" CLIENT_ST, CLIENT_ADDR	"+
						" ) values "+
						" ( ?, ?, ?, ?, ?,   ?, to_char(sysdate,'YYYYMMdd'), TO_CHAR(sysdate, 'hh24mi'), ?, ?, ?,"+
						"   ?, ?, ?, ?, ?,   ?, ?, ?, ?, 'Y', "+
						"	?, ?, ?, ?, ?, ?,   ?, ?, ?, ?, ?, ?, "+
						"	?, ? "+
						" )";

		//if(bean.getOff_nm().equals("주식회사 아마존탁송")){
			tmsg_kncd ="AC101";
		//}else if(bean.getOff_nm().equals("하이카콤(대전)")){
		//	tmsg_kncd ="AC201";
		//}else if(bean.getOff_nm().equals("에프앤티코리아(부산)")||bean.getOff_nm().equals("에프앤티코리아(광주)")||bean.getOff_nm().equals("에프앤티코리아(대구)")){
		//	tmsg_kncd ="AC301";
		//}



		String query2 =  " insert into alink.TMSG_QUEUE "+
						" ( TMSG_SEQ, SEND_ORG_CD, RECV_ORG_CD, TMSG_KNCD, TMSG_SECTION, TMSG_TYPE, REQ_YMD, REQ_TIME, UPD_YMD, UPD_TIME, STATUS "+
						" ) values "+
						" ( '"+bean.getTmsg_seq().trim()+"', 'AC001', 'DK001', '"+tmsg_kncd+"', '1', '1', "+
						" to_char(sysdate,'YYYYMMdd'), TO_CHAR(sysdate, 'hh24mi'), to_char(sysdate,'YYYYMMdd'), TO_CHAR(sysdate, 'hh24mi'), '0' "+
						"  )";


		try
		{
			conn.setAutoCommit(false);

			pstmt2 = conn.prepareStatement(query);
			
			pstmt2.setString(1, bean.getCons_no			());
			pstmt2.setString(2, bean.getTmsg_seq			());
			pstmt2.setString(3, bean.getRent_l_cd			());
			pstmt2.setString(4, bean.getDept_nm			());
			pstmt2.setString(5, bean.getCar_no				());
			pstmt2.setString(6, bean.getCar_nm				());
			pstmt2.setString(7, bean.getCons_cau			());
			pstmt2.setString(8, bean.getFirm_nm			());
			pstmt2.setString(9, bean.getFirm_ssn			());
			
			pstmt2.setString(10, bean.getFirm_addr		());
			pstmt2.setString(11, bean.getFirm_tel			());
			pstmt2.setString(12, bean.getFirm_m_tel		());
			pstmt2.setString(13, bean.getFirm_email		());
			pstmt2.setString(14, bean.getAcar_mng		());
			pstmt2.setString(15, bean.getAcar_tel			());
			pstmt2.setString(16, bean.getOff_nm			());
			pstmt2.setString(17, bean.getOff_drv			());
			pstmt2.setString(18, bean.getOff_drv_tel		());
			
			//채권양도통지서 및 위임장 데이터 추가(19~30)
			pstmt2.setString(19, bean.getB_trf_yn			());
			pstmt2.setString(20, bean.getIns_com_nm	());
			pstmt2.setString(21, bean.getFirm_zip			());
			pstmt2.setString(22, bean.getClient_nm		());
			pstmt2.setString(23, bean.getClient_ssn		());
			pstmt2.setString(24, bean.getIns_req_amt	());
			pstmt2.setString(25, bean.getIns_req_amt_han());
			pstmt2.setString(26, bean.getAc_car_no		());
			pstmt2.setString(27, bean.getAc_car_nm		());
			pstmt2.setString(28, bean.getAccid_dt			());
			pstmt2.setString(29, bean.getIns_use_st		());
			pstmt2.setString(30, bean.getIns_use_et		());
			pstmt2.setString(31, bean.getClient_st			());
			pstmt2.setString(32, bean.getClient_addr		());
			pstmt2.executeUpdate();	
			
			pstmt2 = conn.prepareStatement(query2);		
			pstmt2.executeUpdate();	

			pstmt2.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[ConsignmentDatabase:insertConsignment_Link]\n"+e);

			System.out.println("[bean.getCons_no		()]\n"+bean.getCons_no		());
			System.out.println("[bean.getTmsg_seq		()]\n"+bean.getTmsg_seq		());
			System.out.println("[bean.getRent_l_cd		()]\n"+bean.getRent_l_cd	());
			System.out.println("[bean.getDept_nm		()]\n"+bean.getDept_nm		());
			System.out.println("[bean.getCar_no			()]\n"+bean.getCar_no		());
			System.out.println("[bean.getCar_nm			()]\n"+bean.getCar_nm		());
			System.out.println("[bean.getCons_cau		()]\n"+bean.getCons_cau		());
			System.out.println("[bean.getFirm_nm		()]\n"+bean.getFirm_nm		());
			System.out.println("[bean.getFirm_ssn		()]\n"+bean.getFirm_ssn		());

			System.out.println("[bean.getFirm_addr		()]\n"+bean.getFirm_addr	());
			System.out.println("[bean.getFirm_tel		()]\n"+bean.getFirm_tel		());
			System.out.println("[bean.getFirm_m_tel		()]\n"+bean.getFirm_m_tel	());
			System.out.println("[bean.getFirm_email		()]\n"+bean.getFirm_email	());
			System.out.println("[bean.getAcar_mng		()]\n"+bean.getAcar_mng		());
			System.out.println("[bean.getAcar_tel		()]\n"+bean.getAcar_tel		());
			System.out.println("[bean.getOff_nm			()]\n"+bean.getOff_nm		());
			System.out.println("[bean.getOff_drv		()]\n"+bean.getOff_drv		());
			System.out.println("[bean.getOff_drv_tel	()]\n"+bean.getOff_drv_tel	());
			
			System.out.println("[bean.getB_trf_yn		()]\n"+bean.getB_trf_yn		());
			System.out.println("[bean.getIns_com_nm		()]\n"+bean.getIns_com_nm	());
			System.out.println("[bean.getFirm_zip		()]\n"+bean.getFirm_zip		());
			System.out.println("[bean.getClient_nm		()]\n"+bean.getClient_nm	());
			System.out.println("[bean.getClient_ssn		()]\n"+bean.getClient_ssn	());
			System.out.println("[bean.getIns_req_amt	()]\n"+bean.getIns_req_amt	());
			System.out.println("[bean.getIns_req_amt_han()]\n"+bean.getIns_req_amt_han());
			System.out.println("[bean.getAc_car_no		()]\n"+bean.getAc_car_no	());
			System.out.println("[bean.getAc_car_nm		()]\n"+bean.getAc_car_nm	());
			System.out.println("[bean.getAccid_dt		()]\n"+bean.getAccid_dt		());
			System.out.println("[bean.getIns_use_st		()]\n"+bean.getIns_use_st	());
			System.out.println("[bean.getIns_use_et		()]\n"+bean.getIns_use_et	());

			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt2 != null)	pstmt2.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return cons_no;
		}
	}


public String updateConsignment_Link(ConsignmentLinkBean bean, String tmsg_kncd)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		String cons_no = "";
		String query =  " UPDATE alink.CONSIGNMENT_LINK SET "+
						" TMSG_SEQ = ?, REG_YMD = to_char(sysdate,'YYYYMMdd') , REG_TIME = TO_CHAR(sysdate, 'hh24mi'), OFF_DRV = ?, OFF_DRV_TEL = ?, CONS_YN = ?, CAR_NO = ?, CAR_NM = ? "+
						" WHERE CONS_NO = ? ";

			
		String query2 =  " insert into alink.TMSG_QUEUE "+
						" ( TMSG_SEQ, SEND_ORG_CD, RECV_ORG_CD, TMSG_KNCD, TMSG_SECTION, TMSG_TYPE, REQ_YMD, REQ_TIME, UPD_YMD, UPD_TIME, STATUS "+
						" ) values "+
						" ( '"+bean.getTmsg_seq().trim()+"', 'AC001', 'DK001', '"+tmsg_kncd+"', '1', '1', "+
						" to_char(sysdate,'YYYYMMdd'), TO_CHAR(sysdate, 'hh24mi'), to_char(sysdate,'YYYYMMdd'), TO_CHAR(sysdate, 'hh24mi'), '0' "+
						"  )";


		try
		{
			conn.setAutoCommit(false);

			pstmt2 = conn.prepareStatement(query);			
			pstmt2.setString(1, bean.getTmsg_seq		());
			pstmt2.setString(2, bean.getOff_drv			());
			pstmt2.setString(3, bean.getOff_drv_tel		());
			pstmt2.setString(4, bean.getCons_yn			());
			pstmt2.setString(5, bean.getCar_no			());
			pstmt2.setString(6, bean.getCar_nm			());
			pstmt2.setString(7, bean.getCons_no			());
			pstmt2.executeUpdate();	
			pstmt2.close();
			
			pstmt1 = conn.prepareStatement(query2);		
			pstmt1.executeUpdate();	
			pstmt1.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[ConsignmentDatabase:updateConsignment_Link]\n"+e);

			System.out.println("[bean.getCons_no		()]\n"+bean.getCons_no		());
			System.out.println("[bean.getTmsg_seq		()]\n"+bean.getTmsg_seq		());
			System.out.println("[bean.getCons_yn		()]\n"+bean.getCons_yn		());
			System.out.println("[bean.getCar_no			()]\n"+bean.getCar_no		());
			System.out.println("[bean.getCar_nm			()]\n"+bean.getCar_nm		());
			System.out.println("[bean.getOff_drv		()]\n"+bean.getOff_drv		());
			System.out.println("[bean.getOff_drv_tel	()]\n"+bean.getOff_drv_tel	());

			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt2 != null)	pstmt2.close();
				if(pstmt1 != null)	pstmt1.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return cons_no;
		}
	}


//모바일 인도/인수증 사본 PDF 파일 보기 /www/acar/car_register/car_view.jsp
public Vector getConsignment_queue(String rent_mng_id, String rent_l_cd, String car_mng_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String sub_query = "";
		String query = "";

		query = " SELECT a.cons_no, a.OFF_NM, a.FROM_DT, b.CONTENT  FROM CONSIGNMENT a, alink.TMSG_QUEUE b "+
				" WHERE a.CONS_NO||a.seq = b.LINK_KEY "+
				" AND b.TMSG_TYPE ='2' "+
				" AND a.RENT_L_CD = '"+rent_l_cd+"' "+
				" ";


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
			System.out.println("[ConsignmentDatabase:getConsignment_queue]\n"+e);
			System.out.println("[ConsignmentDatabase:getConsignment_queue]\n"+query);
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



//에이전트 실 담당자 연락처 가저오기
public Hashtable getSearchAgent_emp_tel(String emp_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " SELECT emp_m_tel, emp_nm, emp_email FROM CAR_OFF_EMP WHERE emp_id = ? \n"+
				"   ";


		try {
								
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  emp_id);

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
			System.out.println("[ConsignmentDatabase:getSearchAgent_emp_tel]\n"+e);
			System.out.println("[ConsignmentDatabase:getSearchAgent_emp_tel]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}		
	}

	/**
	 * 동일한 고객에게 전송한 알림톡 내용이 일치하는지 확인한다.
	 * 2018.03.13
	 */
	public String checkAlimTalk(String table_name, String etc_text_1, String recipient_num){
		getConnection2();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String result = "";
		String query = "";
		
		query = " select content from "+table_name+" where etc_text_1 = '"+etc_text_1+"' and recipient_num = '"+recipient_num+"' ";
//System.out.println("query : " + query);
		try{
			pstmt = conn.prepareStatement(query);
		   	rs = pstmt.executeQuery();
			if(rs.next())
			{
				result = rs.getString("content");
			}
			rs.close();
			pstmt.close();
			System.out.println("[ConsignmentDatabase:checkAlimTalk]\n"+query);
		} catch (SQLException e) {
			System.out.println("[ConsignmentDatabase:checkAlimTalk]\n"+e);
			e.printStackTrace();
		} finally {
			try{
            if(rs != null )		rs.close();
            if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection2();
			return result;
		}
	}

	//채권양도통지서 및 위임장 등록(20181123)
	public boolean insertBondTransferDoc(String accid_id, String cons_no, String cons_st, String rent_mng_id, String rent_l_cd 
									   , String ins_com_id, String ins_com_nm, String client_id, String client_st, String client_nm
									   , String firm_nm, String birth, String enp_no, String zip, String addr, int ins_req_amt
									   , String car_mng_id, String car_no, String car_nm, String accid_dt, String ins_use_st, String ins_use_et) 	//22
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query =  " insert into bond_trf_doc "+
						" ( accid_id, cons_no, cons_st, rent_mng_id, rent_l_cd, ins_com_id, ins_com_nm, client_id, client_st, client_nm, firm_nm "+
						"	,birth , enp_no, zip, addr, ins_req_amt, car_mng_id, car_no, car_nm, accid_dt, ins_use_st, ins_use_et) "+
						"  values "+
						" ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? "+
						" )";
		
		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);		
			pstmt.setString(1,  accid_id	);
			pstmt.setString(2,  cons_no		);
			pstmt.setString(3,  cons_st		);
			pstmt.setString(4,  rent_mng_id	);
			pstmt.setString(5,  rent_l_cd	);
			pstmt.setString(6,  ins_com_id	);
			pstmt.setString(7,  ins_com_nm	);
			pstmt.setString(8,  client_id	);
			pstmt.setString(9,  client_st	);
			pstmt.setString(10,  client_nm	);
			pstmt.setString(11, firm_nm		);
			pstmt.setString(12, birth		);
			pstmt.setString(13, enp_no		);
			pstmt.setString(14, zip			);
			pstmt.setString(15, addr		);
			pstmt.setInt   (16, ins_req_amt	);
			pstmt.setString(17, car_mng_id	);
			pstmt.setString(18, car_no		);
			pstmt.setString(19, car_nm		);
			pstmt.setString(20, accid_dt	);
			pstmt.setString(21, ins_use_st	);
			pstmt.setString(22, ins_use_et	);
			
			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[ConsignmentDatabase:insertBondTransferDoc]\n"+e);
			System.out.println("[ConsignmentDatabase:insertBondTransferDoc]\n"+query);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	//채권양도통지서 및 위임장 데이터 1건 조회(20181126)	
	public Vector getBond_trf_doc(String cons_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		
		String query = " select * from bond_trf_doc"+
					   "  where cons_no = '"+cons_no+"'";

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
			System.out.println("[ConsignmentDatabase:getBond_trf_doc]\n"+e);
			System.out.println("[ConsignmentDatabase:getBond_trf_doc]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}
	
	//채권양도 통지서 및 위임장 삭제(20190311)
	public boolean deleteBond_trf_doc(String cons_no)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " delete from bond_trf_doc where cons_no=?";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);		
			pstmt.setString(1,  cons_no);
			pstmt.executeUpdate();
			
			pstmt.close();
			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[ConsignmentDatabase:deleteBond_trf_doc]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	//채권양도통지서 알림톡 발송위한 조회(20190325)
	public Hashtable getBondTrfDocInfo(String cons_no){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		
		query = "SELECT a.firm_nm, a.car_nm, a.car_no, a.ins_req_amt, a.acar_mng, a.acar_tel, a.b_trf_yn, \n"+
					 "			   subStr(a.ins_use_st,0,4)||'.'||subStr(a.ins_use_st,5,2)||'.'||subStr(a.ins_use_st,7,2) AS s_date, \n"+
					 "	  		   subStr(a.ins_use_st,9,2)||':'||subStr(a.ins_use_st,11) AS s_time, \n"+  
					 "			   subStr(a.ins_use_et,0,4)||'.'||subStr(a.ins_use_et,5,2)||'.'||subStr(a.ins_use_et,7,2) AS e_date, \n"+
					 "			   subStr(a.ins_use_et,9,2)||':'||subStr(a.ins_use_et,11) AS e_time, \n"+
					 "			   to_char(SYSDATE,'YYYY.MM.DD') AS today, \n"+
					 "			   (select z.rent_way FROM (select decode(y.rent_way,'1','일반식','기본식') as rent_way FROM alink.CONSIGNMENT_link x, fee y WHERE x.rent_l_cd = y.rent_l_cd AND x.cons_no LIKE '"+cons_no+"%' AND x.cons_cau = '사고차량인도')z WHERE rownum='1') as rent_way \n"+
//					 "			   b.rent_way	\n"+
					 "	 FROM alink.CONSIGNMENT_link a \n"+
					 "	 WHERE a.cons_no LIKE '"+cons_no+"%' and a.cons_cau = '사고대차회수'";

		try {								
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next()){				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ConsignmentDatabase:getBondTrfDocInfo]\n"+e);
			System.out.println("[ConsignmentDatabase:getBondTrfDocInfo]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}		
	}
	
	
	
	//탁송현황 리스트 조회
		public Vector getConsignmentMngListMobile(String s_kd, String t_wd, String gubun1, String st_dt, String end_dt, String gubun2, String cons_no)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Vector vt = new Vector();
			String query = "";

			query = " select"+
					"        a.TO_COMP AS firm_nm, a.TO_MAN AS client_nm, a.to_m_tel AS to_tel, g.CLIENT_id, a.*,"+
					"        nvl(a.from_dt,nvl(a.from_est_dt,a.from_req_dt)) f_dt,"+
					"        nvl(a.to_dt,nvl(a.to_est_dt,a.to_req_dt)) t_dt,"+
					"        c.br_id, b.user_id1, c.user_nm as user_nm1, "+
					"        decode(k.emp_m_tel,'',c.user_m_tel,k.emp_m_tel) AS user_m_tel1, "+
					"        d.user_nm as user_nm2, b.user_dt1, b.user_dt2, "+
					"        f.nm as cons_cau_nm, decode(a.cons_st,'1','편도','2','왕복') as cons_st_nm,"+
					"        decode(a.pay_st,'1','선불','2','후불') pay_st_nm, decode(a.cost_st,'1','아마존카','2','고객') cost_st_nm,"+
					"        decode((decode(b.user_dt1,'',0,1)+decode(b.user_dt2,'',0,1)+decode(b.user_dt3,'',0,1)+decode(a.req_dt,'',0,1)+decode(a.conf_dt,'',0,1)+decode(h.user_dt1,'',0,1)+decode(h.user_dt2,'',decode(c.br_id,'S1',0,decode(h.user_dt1,'',0,1)),1)+decode(a.pay_dt,'',0,1))"+
					"        ,1,'의뢰', 2,'수신', 3,'정산', 4,'청구', 5,'확인', 6,'결재', 7,'결재', 8,'지급'"+
					"        ) as step,"+
					"        (decode(b.user_dt1,'',0,1)+decode(b.user_dt2,'',0,1)+decode(b.user_dt3,'',0,1)+decode(a.req_dt,'',0,1)+decode(a.conf_dt,'',0,1)+decode(h.user_dt1,'',0,1)+decode(h.user_dt2,'',decode(c.br_id,'S1',0,decode(h.user_dt1,'',0,1)),1)+decode(a.pay_dt,'',0,1)) cnt,"+
					"        decode(substr(a.driver_nm,1,1),'0',i.user_nm,a.driver_nm) driver_nm2"+
					" from   CONSIGNMENT a, client g, car_off_emp k, "+
					"        (select * from doc_settle where doc_st='2') b, "+
					"        users c, users d, branch e, users i,"+
					"        (select * from doc_settle where doc_st='3') h, "+
					"        (select * from code where c_st='0015' and code<>'0000') f"+
					" where  a.cons_no=b.doc_id(+) and b.user_id1=c.user_id(+) and b.user_id2=d.user_id(+) and c.br_id=e.br_id(+)"+
					"        and a.req_code=h.doc_id(+)"+
					"        and a.cons_cau=f.nm_cd(+) and a.client_id=g.client_id(+) and a.driver_nm=i.user_id(+) and a.agent_emp_id=k.emp_id(+) ";

			String search = "";
			String what = "";

			if(s_kd.equals("1"))	what = "upper(nvl(e.br_id||e.br_nm, ' '))";
			if(s_kd.equals("2"))	what = "upper(nvl(a.off_nm, ' '))";	
			if(s_kd.equals("3"))	what = "upper(nvl(a.from_place||a.to_place||a.from_comp||a.to_comp, ' '))";
			if(s_kd.equals("4"))	what = "upper(nvl(a.car_no, ' '))";	
			if(s_kd.equals("5"))	what = "upper(nvl(c.user_nm, ' '))";
			if(s_kd.equals("6"))	what = "to_char(b.user_dt1,'YYYYMMDD')";
			if(s_kd.equals("7"))	what = "upper(nvl(g.firm_nm, ' '))";

			if(s_kd.equals("c_id"))	what = "upper(nvl(a.car_mng_id, ' '))";

				
			if(!s_kd.equals("") && !t_wd.equals("")){
				if(s_kd.equals("2"))	query += " and "+what+" like upper('%"+t_wd+"%') ";
				else if(s_kd.equals("6"))	query += " and "+what+" like replace('"+t_wd+"%', '-','')";
				else					query += " and "+what+" like upper('"+t_wd+"%') ";
			}else{
			
			}	

			String dt1 = "substr(nvl(a.from_dt,a.from_req_dt),1,6)";
			String dt2 = "substr(nvl(a.from_dt,a.from_req_dt),1,8)";

			if(gubun2.equals("1")){
				dt1 = "to_char(b.user_dt1,'YYYYMM')";
				dt2 = "to_char(b.user_dt1,'YYYYMMDD')";
			}else if(gubun2.equals("2")){
				dt1 = "to_char(b.user_dt2,'YYYYMM')";
				dt2 = "to_char(b.user_dt2,'YYYYMMDD')";
			}else if(gubun2.equals("3")){
				dt1 = "to_char(b.user_dt3,'YYYYMM')";
				dt2 = "to_char(b.user_dt3,'YYYYMMDD')";
			}else if(gubun2.equals("4")){
				dt1 = "to_char(b.user_dt4,'YYYYMM')";
				dt2 = "to_char(b.user_dt4,'YYYYMMDD')";
			}else if(gubun2.equals("5")){
				dt1 = "to_char(b.user_dt5,'YYYYMM')";
				dt2 = "to_char(b.user_dt5,'YYYYMMDD')";
			}else if(gubun2.equals("6")){
				dt1 = "to_char(h.user_dt1,'YYYYMM')";
				dt2 = "to_char(h.user_dt1,'YYYYMMDD')";
			}else if(gubun2.equals("8")){
				dt1 = "substr(a.pay_dt,1,6)";
				dt2 = "a.pay_dt";
			}

			if(gubun1.equals("1"))			query += " and "+dt1+" = to_char(sysdate,'YYYYMM')";
			else if(gubun1.equals("3"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
			else if(gubun1.equals("2")){
				if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
				if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
			}

			if(!gubun2.equals(""))			query += " and decode(b.user_dt1,'',0,1)+decode(b.user_dt2,'',0,1)+decode(b.user_dt3,'',0,1)+decode(a.req_dt,'',0,1)+decode(a.conf_dt,'',0,1)+decode(h.user_dt1,'',0,1)+decode(h.user_dt2,'',decode(c.br_id,'S1',0,decode(h.user_dt1,'',0,1)),1)+decode(a.pay_dt,'',0,1)='"+gubun2+"'";

			if(!cons_no.equals(""))			query += " and a.cons_no = '"+cons_no+"' ";

			query += " order by a.seq, a.off_id, nvl(a.from_dt,nvl(a.from_est_dt,a.from_req_dt)), a.cons_no";

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
	//System.out.println("[ConsignmentDatabase:getConsignmentMngListMobile]\n"+s_kd);
	//System.out.println("[ConsignmentDatabase:getConsignmentMngListMobile]\n"+t_wd);
	//System.out.println("[ConsignmentDatabase:getConsignmentMngListMobile]\n"+query);
			} catch (SQLException e) {
				System.out.println("[ConsignmentDatabase:getConsignmentMngListMobile]\n"+e);
				System.out.println("[ConsignmentDatabase:getConsignmentMngListMobile]\n"+query);
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
		
		//중복체크
		public int getCons_oksmsCheck(String cons_no, int seq, String reg_nm, String reg_tel, String car_no, String client_nm, String client_br, String client_tel, int dist_km){
			getConnection();
	        PreparedStatement pstmt = null;
	        ResultSet rs = null;
	        int count = 0;
	        String query = "";
	        
			query = "SELECT count(*) "+
					"  FROM CONS_OKSMS "+
					" WHERE cons_no = ? AND seq = ? AND car_no = ? AND client_nm = ? AND dist_km = ? ";
			
	        try{
	        	pstmt = conn.prepareStatement(query);
	        	pstmt.setString(1,  cons_no);
	        	pstmt.setInt(2,  seq);
	        	pstmt.setString(3,  car_no);
	        	pstmt.setString(4,  client_nm);
	        	pstmt.setInt(5,  dist_km);
	    		rs = pstmt.executeQuery();

	            if(rs.next()){                
					count = rs.getInt(1);
	            }

				rs.close();
				pstmt.close();

	        }catch(SQLException e){
				 System.out.println("[ConsignmentDatabase:getCons_oksmsCheck()]: "+e);
				 System.out.println("[ConsignmentDatabase:getCons_oksmsCheck()]: "+query);
				e.printStackTrace();
	        }finally{
	            try{
	                if(rs != null ) rs.close();
	                if(pstmt != null) pstmt.close();
	            }catch(Exception ignore){}
	            
				closeConnection();
				return count;
	        }
	    }	

		 
		//탁송기사가 도착하고 문자보내기\

		 public boolean updateCons_OkSms(String cons_no, int seq, String reg_nm, String reg_tel, String car_no, String client_nm, String client_br, String client_tel, int dist_km)
		 	{
		 		getConnection();
		 		boolean flag = true;
		 		PreparedStatement pstmt = null;

		 		/*String query =  " update CONS_OKSMS set "+
		 						"   end_dt=to_char(sysdate,'YYYYMMddhh24mi'), update_dt = sysdate, dist_km = ? "+
		 						" where cons_no = ? and seq=? and car_no = ? ";*/
		 		
		 		String query =  " update CONS_OKSMS set "+
                        " end_dt = to_char(sysdate,'YYYYMMddhh24mi'), update_dt = sysdate, dist_km = '"+dist_km+"' "+
                        " where cons_no = '"+cons_no+"' and seq="+seq+" and car_no = '"+car_no+"' ";

		 		try
		 		{
		 			conn.setAutoCommit(false);

		 			pstmt = conn.prepareStatement(query);		
		 			//	pstmt.setInt(1,  dist_km);
		 			//	pstmt.setString(2,  cons_no);
		 			//	pstmt.setInt(3,  seq);
		 			//	pstmt.setString(4,  car_no);
		 			pstmt.executeUpdate();			
		 			pstmt.close();

		 			conn.commit();
		 		    
		 	  	}catch(Exception e){
		 			System.out.println("[ConsignmentDatabase:updateCons_OkSms]\n"+e);
		 			e.printStackTrace();
		 	  		flag = false;
		 			conn.rollback();
		 		}finally{
		 			try{
		 	            if(pstmt != null)	pstmt.close();
		 				conn.setAutoCommit(true);
		 			}catch(Exception ignore){}
		 			closeConnection();
		 			return flag;
		 		}
		 	}

		 
		//탁송기사가 출발할때 문자 보내기
		 public boolean insertCons_OkSms(String cons_no, int seq, String reg_nm, String reg_tel, String car_no, String client_nm, String client_br, String client_tel, int dist_km)
		 	{
			 //추후 적용 예정
			//    int dup_cnt = getCons_oksmsCheck(cons_no, seq, reg_nm, reg_tel, car_no, client_nm, client_br, client_tel, dist_km);
			 
		 		getConnection();
		 		boolean flag = true;
		 		PreparedStatement pstmt = null;
		 			 	
		 		String query =  " insert into CONS_OKSMS "+
		 						" ( CONS_IDX , cons_no, seq, reg_nm, reg_dt, reg_tel, car_no, client_nm, client_br, client_tel, dist_km, start_dt ) "+
		 						"  values "+
		 						" ( CONS_OKSMS_SEQ.nextval, ?, ?, ?, sysdate, ?, ?, ?, ?, ?, ?, to_char(sysdate,'YYYYMMddhh24mi') "+
		 						" )";

		 		try
		 		{
		 			conn.setAutoCommit(false);
		 		
		 	//		if (dup_cnt < 1 ) {
		 					
			 			pstmt = conn.prepareStatement(query);		
			 			pstmt.setString(1,  cons_no);
			 			pstmt.setInt(2,  seq);
			 			pstmt.setString(3,  reg_nm);
			 			pstmt.setString(4,  reg_tel);
			 			pstmt.setString(5,  car_no);
			 			pstmt.setString(6,  client_nm);
			 			pstmt.setString(7,  client_br);
			 			pstmt.setString(8,  client_tel);
			 			pstmt.setInt(9,  dist_km);
			 			pstmt.executeUpdate();			
			 			pstmt.close();
		 	//		}	
		 		
		 			conn.commit();
		 		    
		 	  	}catch(Exception e){
		 			System.out.println("[ConsignmentDatabase:insertCons_OkSms]\n"+e);
		 			e.printStackTrace();
		 	  		flag = false;
		 			conn.rollback();
		 		}finally{
		 			try{
		 	            if(pstmt != null)	pstmt.close();
		 				conn.setAutoCommit(true);
		 			}catch(Exception ignore){}
		 			closeConnection();
		 			return flag;
		 		}
		 	}

		 
		//탁송출발 문자 발송여부 체크
			public Hashtable getCons_start_dtCheck(String cons_no, String seq)
			{
				getConnection();
				PreparedStatement pstmt = null;
				ResultSet rs = null;
				Hashtable ht = new Hashtable();
				String query = "";
				
				cons_no = cons_no.trim();
				seq = seq.trim();
				
				//System.out.println("cons_no = " + cons_no);
				//System.out.println("seq = " + seq);

				//query = " SELECT * FROM CONS_OKSMS where cons_no = ? and seq = ? \n";
				query = " SELECT * FROM CONS_OKSMS where cons_no = " + cons_no + " and seq = " + seq;

				try {
										
					pstmt = conn.prepareStatement(query);
					/*pstmt.setString(1, cons_no);
					pstmt.setString(2, seq);*/
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
				} catch (SQLException e) {
					System.out.println("[ConsignmentDatabase:getCons_start_dtCheck]\n"+e);
					System.out.println("[ConsignmentDatabase:getCons_start_dtCheck]\n"+query);
			  		e.printStackTrace();
				} finally {
					try{
		                if(rs != null )		rs.close();
		                if(pstmt != null)	pstmt.close();
					}catch(Exception ignore){}
					closeConnection();
					return ht;
				}		
			}
			
			//탁송 고객연락처 
			public Vector getConsignmentTelList(String rent_l_cd)
			{
				getConnection();
				PreparedStatement pstmt = null;
				ResultSet rs = null;
				Vector vt = new Vector();
								
				String query = " select * from ( " + 
							   "		select distinct  decode(from_st  , '2', from_man, to_man) man, decode(from_st  , '2', from_title,  to_title) title, " + 
							   "		decode(from_st  , '2', from_tel, to_tel) tel, decode(from_st  , '2', from_m_tel, to_m_tel) m_tel, substr(from_dt, 1, 6) ym " + 
							   "		 from  consignment where rent_l_cd =  '"+rent_l_cd+"' and ( from_st = '2' or to_st = '2' )  " + 
							   "		 order by 5 desc  " + 
							   "	) a where rownum < 10 ";
												
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
					System.out.println("[ConsignmentDatabase:getConsignmentTelList]\n"+e);
					System.out.println("[ConsignmentDatabase:getConsignmentTelList]\n"+query);
			  		e.printStackTrace();
				} finally {
					try{
						if ( rs != null )		rs.close();
						if ( pstmt != null )	pstmt.close();
					}catch(Exception ignore){}
					closeConnection();
					return vt;
				}		
			}
			
			public String getCarNo(String cons_no, int seq)
			{
				getConnection();
				PreparedStatement pstmt = null;
				ResultSet rs = null;
				String query = "";
				String car_no = "";
				query = "SELECT NVL(c.car_no, b.est_car_no) car_no "+
							"	FROM  consignment a, car_pur b, car_reg c, cont d "+  
							"	WHERE a.cons_no LIKE '%'||rtrim("+cons_no+")||'%' "+
							"	AND a.seq = ?" +
							"	AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd " +
							"	AND a.rent_mng_id=d.rent_mng_id AND a.rent_l_cd=d.rent_l_cd " +
							"	AND d.car_mng_id=c.car_mng_id ";
				try {
										
					pstmt = conn.prepareStatement(query);
					pstmt.setInt   (1, seq);
			    	rs = pstmt.executeQuery();
		    	
					if(rs.next())
					{	
						car_no = rs.getString("car_no")==null?"":rs.getString("car_no");
					}
					rs.close();
					pstmt.close();
				} catch (SQLException e) {
					System.out.println("[ConsignmentDatabase:getCarNo]\n"+e);
					System.out.println("[ConsignmentDatabase:getCarNo]\n"+query);
			  		e.printStackTrace();
				} finally {
					try{
		                if(rs != null )		rs.close();
		                if(pstmt != null)	pstmt.close();
					}catch(Exception ignore){}
					closeConnection();
					return car_no;
				}		
			}
			
			// 등록된 인도인수증 문서 조회
			public Vector getRegistedConsignmentLinkList(String cons_no){
				getConnection();
				PreparedStatement pstmt = null;
				ResultSet rs = null;
				Vector vt = new Vector();
				
				ConsignmentLinkBean bean = new ConsignmentLinkBean();
				
				String query = " SELECT a.*, DECODE(a.cons_yn, 'Y','등록','U','수정','D','취소') AS cons_yn_nm "
									+ ", decode(b.status, '0','대기','1','처리중','2','완료','9','에러') AS DOC_STAT "
									+ ", b.res_msg, b.status, TO_DATE(b.upd_ymd||b.upd_time,'YYYYMMDDhh24miss') reg_date "
									+ " FROM ALINK.CONSIGNMENT_LINK a, alink.tmsg_queue b "
									+ " WHERE a.TMSG_SEQ = b.TMSG_SEQ "
									+ " AND a.cons_no LIKE '" + cons_no + "%'"
									+ " AND a.cons_yn = 'Y' AND b.tmsg_kncd = 'AC101' "
									+ " ORDER BY cons_no ";
				
				try{
					
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
					System.out.println("[ConsignmentDatabase: getConsignmentLinkList]\n"+e);
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
			
			public boolean updateConsignment_link(ConsignmentLinkBean bean, String tmsg_kncd, String tmsg_seq)
			{
				getConnection();
				boolean flag = true;
				PreparedStatement pstmt1 = null;
				PreparedStatement pstmt2 = null;
				
				String query =  " UPDATE alink.CONSIGNMENT_LINK SET "+
						" TMSG_SEQ = ?, REG_YMD = to_char(sysdate,'YYYYMMdd') , REG_TIME = TO_CHAR(sysdate, 'hh24mi'), CONS_YN = ?"+
						" WHERE cons_no LIKE '" + bean.getCons_no() + "%' AND TMSG_SEQ = ?";
				
				
				String query2 =  " insert into alink.TMSG_QUEUE "+
						" ( TMSG_SEQ, SEND_ORG_CD, RECV_ORG_CD, TMSG_KNCD, TMSG_SECTION, TMSG_TYPE, REQ_YMD, REQ_TIME, UPD_YMD, UPD_TIME, STATUS "+
						" ) values "+
						" ( '"+bean.getTmsg_seq().trim()+"', 'AC001', 'DK001', '"+tmsg_kncd+"', '1', '1', "+
						" to_char(sysdate,'YYYYMMdd'), TO_CHAR(sysdate, 'hh24mi'), to_char(sysdate,'YYYYMMdd'), TO_CHAR(sysdate, 'hh24mi'), '0' "+
						"  )";
				
				
				try
				{
					conn.setAutoCommit(false);
					
					pstmt2 = conn.prepareStatement(query);			
					pstmt2.setString(1, bean.getTmsg_seq		());
					pstmt2.setString(2, bean.getCons_yn			());
					pstmt2.setString(3, tmsg_seq);
					pstmt2.executeUpdate();	
					pstmt2.close();
					
					pstmt1 = conn.prepareStatement(query2);		
					pstmt1.executeUpdate();	
					pstmt1.close();
					
					conn.commit();
					
				}catch(Exception e){
					System.out.println("[ConsignmentDatabase:updateConsignment_Link]\n"+e);
					
					System.out.println("[bean.getCons_no		()]\n"+bean.getCons_no		());
					System.out.println("[bean.getTmsg_seq		()]\n"+bean.getTmsg_seq		());
					System.out.println("[bean.getCons_yn		()]\n"+bean.getCons_yn		());
					System.out.println("[bean.getCar_no			()]\n"+bean.getCar_no		());
					System.out.println("[bean.getCar_nm			()]\n"+bean.getCar_nm		());
					System.out.println("[bean.getOff_drv		()]\n"+bean.getOff_drv		());
					System.out.println("[bean.getOff_drv_tel	()]\n"+bean.getOff_drv_tel	());
					
					e.printStackTrace();
					flag = false;
					conn.rollback();
				}finally{
					try{
						if(pstmt2 != null)	pstmt2.close();
						if(pstmt1 != null)	pstmt1.close();
						conn.setAutoCommit(true);
					}catch(Exception ignore){}
					closeConnection();
					return flag;
				}
			}
	public String getCarMngId(String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String c_id = "";
		String query = "";
		query = " select car_mng_id  from cont  where rent_l_cd='"+rent_l_cd+"' ";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next()){				
				c_id = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[InsDatabase:getInsSt]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
		                if(rs != null )		rs.close();
                		if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return c_id;
		}
	}
	// 대차 리스트
	public Vector getContRentList(String rent_l_cd, String car_mng_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT * FROM RENT_CONT WHERE SUB_L_CD = '"+rent_l_cd+"' AND CAR_MNG_ID = '"+car_mng_id+"' AND USE_ST IN ('1','2') ";

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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:getResStatList_New]"+e);
			System.out.println("[ResSearchDatabase:getResStatList_New]"+query);
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

	public String getDrivingAge(String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String driving_age = "";
		String query = "";
		query = " select driving_age  from cont  where rent_l_cd='"+rent_l_cd+"' ";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next()){				
				driving_age = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[InsDatabase:getInsSt]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
		                if(rs != null )		rs.close();
                		if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return driving_age;
		}
	}
	
	public boolean updateConsCostYn(String off_id, String cost_b_dt, String car_comp_id, String car_cd, String from_place, String car_nm, String use_yn)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query =  " update cons_cost set use_yn=? "+
						" where off_id=? and cost_b_dt=? and from_place=? and car_nm=? "+ 
						" ";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);		
			pstmt.setString(1,  use_yn);
			pstmt.setString(2,  off_id);
			pstmt.setString(3,  cost_b_dt);
			pstmt.setString(4,  from_place);
			pstmt.setString(5, car_nm);
			pstmt.executeUpdate();			
			pstmt.close();
			
			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[ConsignmentDatabase:updateConsCostYn]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
}
