package acar.cus_reg;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;
import acar.common.*;
import acar.beans.ExcelBean;
import acar.exception.DatabaseException;
import acar.exception.DataSourceEmptyException;

public class CusReg_Database
{
	private Connection conn = null;
	public static CusReg_Database db;
	
	public static CusReg_Database getInstance()
	{
		if(CusReg_Database.db == null)
			CusReg_Database.db = new CusReg_Database();
		return CusReg_Database.db;
	}	
	

 	private DBConnectionManager connMgr = null;

    private void getConnection()
    {
    	try
    	{
	    	if(connMgr == null)
				connMgr = DBConnectionManager.getInstance();
			if(conn == null)
			{
	        	conn = connMgr.getConnection("acar");				
			}
	    }catch(Exception e){
	    	System.out.println(" I can't get a connection........");
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
	*	거래처별 순회방문 리스트 Bean에 데이터 넣기 2003.11.26. 수.
	* 수정 : 20040702. sangdamja 추가.
	*/
	 private Cycle_vstBean makeCycle_vstBean(ResultSet results) throws DatabaseException {

        try {
            Cycle_vstBean bean = new Cycle_vstBean();

		    bean.setClient_id(results.getString("CLIENT_ID"));
			bean.setSeq(results.getString("SEQ"));
			bean.setVst_dt(results.getString("VST_DT"));
			bean.setVisiter(results.getString("VISITER"));
			bean.setVst_pur(results.getString("VST_PUR"));
			bean.setVst_title(results.getString("VST_TITLE"));
			bean.setVst_cont(results.getString("VST_CONT"));
			bean.setVst_est_dt(results.getString("VST_EST_DT"));
			bean.setVst_est_cont(results.getString("VST_EST_CONT"));
			bean.setUpdate_id(results.getString("UPDATE_ID"));
			bean.setUpdate_dt(results.getString("UPDATE_DT"));
			bean.setSangdamja(results.getString("SANGDAMJA"));

			return bean;

        }catch (SQLException e) {
			System.out.println("[CusReg_Database:makeCycle_vstBean(ResultSet results)]"+e);
            throw new DatabaseException(e.getMessage());
        }
	}

	/**
	*	차량정보 Bean에 데이터 넣기 2003.10.21. Tue.
	* - cus0401에서 2004.7.8.
	*/
	 private CarInfoBean makeCarInfoBean(ResultSet results) throws DatabaseException {

        try {
            CarInfoBean bean = new CarInfoBean();

		    bean.setCar_mng_id(results.getString("CAR_MNG_ID"));			//자동차관리번호
			bean.setRent_mng_id(results.getString("RENT_MNG_ID"));			//계약관리번호
			bean.setRent_l_cd(results.getString("RENT_L_CD"));				//계약번호
			bean.setCar_no(results.getString("CAR_NO"));
			bean.setCar_jnm(results.getString("CAR_JNM"));
			bean.setCar_nm(results.getString("CAR_NM"));
			bean.setCar_num(results.getString("CAR_NUM"));
			bean.setInit_reg_dt(results.getString("INIT_REG_DT"));
			bean.setCar_kd(results.getString("CAR_KD"));
			bean.setCar_use(results.getString("CAR_USE"));
			bean.setCar_form(results.getString("CAR_FORM"));
			bean.setCar_y_form(results.getString("CAR_Y_FORM"));
			bean.setMot_form(results.getString("MOT_FORM"));
			bean.setColo(results.getString("COLO"));
			bean.setDpm(results.getString("DPM"));
			bean.setConti_rat(results.getString("CONTI_RAT"));
			bean.setFuel_kd(results.getString("FUEL_KD"));
			bean.setAge_scp(results.getString("AGE_SCP"));
			bean.setIns_com_nm(results.getString("INS_COM_NM"));
			bean.setIns_start_dt(results.getString("INS_START_DT"));
			bean.setIns_exp_dt(results.getString("INS_EXP_DT"));
			bean.setAgnt_imgn_tel(results.getString("AGNT_IMGN_TEL"));
			bean.setAcc_tel(results.getString("ACC_TEL"));
			bean.setVins_spe(results.getString("VINS_SPE"));
			bean.setVins_cacdt_amt(results.getString("VINS_CACDT_AMT"));
			bean.setChe_st_dt(results.getString("CHE_ST_DT"));
			bean.setChe_end_dt(results.getString("CHE_END_DT"));
			bean.setFirst_serv_dt(results.getString("FIRST_SERV_DT"));
			bean.setCycle_serv(results.getString("CYCLE_SERV"));
			bean.setTot_serv(results.getString("TOT_SERV"));
			bean.setMng_id(results.getString("MNG_ID"));
			bean.setGuar_gen_y(results.getString("GUAR_GEN_Y"));
			bean.setGuar_gen_km(results.getString("GUAR_GEN_KM"));
			bean.setGuar_endur_y(results.getString("GUAR_ENDUR_Y"));
			bean.setGuar_endur_km(results.getString("GUAR_ENDUR_KM"));
			bean.setTot_dist(results.getString("TOT_DIST"));
			bean.setAverage_dist(results.getString("AVERAGE_DIST"));
			bean.setToday_dist(results.getString("TODAY_DIST"));
			bean.setMaint_st_dt(results.getString("MAINT_ST_DT"));
			bean.setMaint_end_dt(results.getString("MAINT_END_DT"));
			bean.setTest_st_dt(results.getString("TEST_ST_DT"));
			bean.setTest_end_dt(results.getString("TEST_END_DT"));
			
			bean.setCar_end_dt(results.getString("CAR_END_DT"));
			bean.setCar_ext(results.getString("CAR_EXT"));
			
			return bean;

        }catch (SQLException e) {
			System.out.println("[CusReg_Database:makeCarInfoBean(ResultSet results)]"+e);
            throw new DatabaseException(e.getMessage());
        }
	}

	/**
	*	차량정비 정보 Bean에 데이터 넣기 2007.7.19.
	*/
	private ServInfoBean makeServInfoBean(ResultSet results) throws DatabaseException {

        try {
            ServInfoBean bean = new ServInfoBean();

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
			bean.setIpgoza(results.getString("IPGOZA"));
			bean.setIpgodt(results.getString("IPGODT"));
			bean.setChulgoza(results.getString("CHULGOZA"));
			bean.setChulgodt(results.getString("CHULGODT"));
			bean.setSpdchk_dt(results.getString("SPDCHK_DT"));
			bean.setChecker_st(results.getString("CHECKER_ST"));
			bean.setCust_act_dt(results.getString("CUST_ACT_DT"));
			bean.setCust_nm(results.getString("CUST_NM"));
			bean.setCust_tel(results.getString("CUST_TEL"));
			bean.setCust_rel(results.getString("CUST_REL"));
			bean.setReg_id(results.getString("REG_ID"));
			bean.setReg_dt(results.getString("REG_DT"));
			bean.setUpdate_id(results.getString("UPDATE_ID"));
			bean.setR_labor(results.getInt("R_LABOR")); 
			bean.setR_amt(results.getInt("R_AMT")); 
			bean.setR_dc(results.getInt("R_DC")); 
			bean.setR_j_amt(results.getInt("R_J_AMT")); 
			bean.setJung_st(results.getString("JUNG_ST"));
			bean.setR_dc_per(results.getInt("R_DC_PER")); 
			bean.setScan_file(results.getString("scan_file"));
			bean.setEstimate_num(results.getString("estimate_num"));
			bean.setSh_amt(results.getInt("SH_AMT")); 
			bean.setCall_t_nm(results.getString("CALL_T_NM"));
			bean.setCall_t_tel(results.getString("CALL_T_TEL"));
			bean.setSac_yn(results.getString("sac_yn"));
			bean.setBus_id2(results.getString("BUS_ID2")); 
			bean.setFile_path(results.getString("FILE_PATH")); 
			bean.setSettle_st(results.getString("SETTLE_ST")); 
			
            return bean;
        }catch (SQLException e) {
			e.printStackTrace();
            throw new DatabaseException(e.getMessage());
        }
	}

	/**
     * 점검품목 2004.7.26.
     */
	private Serv_ItemBean makeServ_ItemBean(ResultSet results) throws DatabaseException {

        try {
            Serv_ItemBean bean = new Serv_ItemBean();

		    bean.setCar_mng_id(results.getString("CAR_MNG_ID"));
			bean.setServ_id(results.getString("SERV_ID"));
			bean.setSeq_no(results.getInt("SEQ_NO"));
			bean.setItem_st(results.getString("ITEM_ST"));
			bean.setItem_id(results.getString("ITEM_ID"));
			bean.setItem_cd(results.getString("ITEM_CD"));
			bean.setItem(results.getString("ITEM"));
			bean.setWk_st(results.getString("WK_ST"));
			bean.setCount(results.getInt("COUNT"));
			bean.setPrice(results.getInt("PRICE"));
			bean.setAmt(results.getInt("AMT"));
			bean.setLabor(results.getInt("LABOR"));
			bean.setBpm(results.getString("BPM"));

            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}

/*----------------거래처 방문 등록-------------------------------------------------------*/
	/**
    * 거래처 순회방문 스케쥴 생성 2004.7.1.
    */
	public int createScdVst(String client_id, String first_vst_dt, int cycle_vst_mon, int cycle_vst_day, int tot_vst){

		getConnection();
		PreparedStatement pstmt = null;
		String query,query1 = "";
		int result = 0;
		CommonDataBase c_db = CommonDataBase.getInstance();

		query = "INSERT INTO cycle_vst(client_id,seq,vst_dt,vst_est_dt,vst_est_cont) VALUES(?,?,?,?,'순회방문')";
		query1 = "UPDATE client SET first_vst_dt=?, cycle_vst=?, tot_vst=? WHERE client_id = ? ";
		
		try{
			conn.setAutoCommit(false);

			String cycle_vst_dt = "";
			for(int i=0; i<tot_vst; i++ ){				
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, client_id);				
				pstmt.setString(2, AddUtil.addZero2(i+1));
				if(i==0){
					pstmt.setString(3,"");
					pstmt.setString(4, AddUtil.ChangeString(first_vst_dt));
					cycle_vst_dt = first_vst_dt;
				}else{
					pstmt.setString(3,"");
					pstmt.setString(4, AddUtil.ChangeString((c_db.addDay(c_db.addMonth(cycle_vst_dt,cycle_vst_mon),cycle_vst_day))));
					cycle_vst_dt = c_db.addDay(c_db.addMonth(cycle_vst_dt,cycle_vst_mon),cycle_vst_day);
				}				
				result = pstmt.executeUpdate();
				if(result<=0) break;
			}
			if(result>0){
				pstmt = conn.prepareStatement(query1);
				pstmt.setString(1,first_vst_dt);
				pstmt.setString(2,AddUtil.addZero2(cycle_vst_mon)+AddUtil.addZero2(cycle_vst_day));
				pstmt.setString(3,Integer.toString(tot_vst));
				pstmt.setString(4,client_id);
				result = pstmt.executeUpdate();
			}
			conn.commit();
			pstmt.close();
			
		}catch(Exception e){
			 try{
                conn.rollback();
            }catch(SQLException _ignored){}
			System.out.println("[CusReg_Database:createScdVst(String client_id, String first_vst_dt, int cycle_vst_mon, int cycle_vst_day, int tot_vst)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(result<=0) conn.rollback(); else conn.commit();
				conn.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return result;			
		}
		
	}   

	/**
    * 거래처 순회방문 스케쥴 추가 2004.7.7.
    */
	public int extendScdVst(String client_id){
		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		int result = 0;

		query = "INSERT INTO cycle_vst(client_id,seq,vst_est_dt,vst_est_cont) "+
				" VALUES(?,(select LPAD(max(seq)+1,2,'0') from cycle_vst  where client_id = ?), "+
				"	(select to_char(add_months(to_date(max(vst_est_dt), 'YYYY-MM-DD'), 1), 'YYYYMMDD') from cycle_vst where client_id = ?), "+
				"	'순회방문')";
		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, client_id);				
			pstmt.setString(2, client_id);
			pstmt.setString(3, client_id);
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
					
		}catch(Exception e){
			System.out.println("[CusReg_Database:extendScdVst(String client_id)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
			conn.setAutoCommit(true);
               		 if(pstmt != null) pstmt.close();
				
			}catch(Exception ignore){}

			closeConnection();	
			return result;		
		}
		
	}

	/**
    * 거래처 순회방문 연장 스케쥴 추가-최종계약만료일까지 2004.9.2.
    */
	public int extendLastCont(String client_id, String first_vst_dt, int cycle_vst_mon, int cycle_vst_day, int tot_vst){

		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs2 = null;
		PreparedStatement pstmt3 = null;
		String max_vst_est_dt="";
		String last_cont_dt = "";
		String query, query1, query2 = "";
		int result = 0;
		CommonDataBase c_db = CommonDataBase.getInstance();
		query2 = "SELECT b.rent_end_dt FROM cont a, "+
				"       (select * from fee a where a.rent_st = (select max(b.rent_st) from fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd)) b "+
				" WHERE a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd AND a.client_id=?"+
				" AND a.use_yn = 'Y' ";

		query1 = "SELECT max(vst_est_dt) FROM cycle_vst WHERE client_id = ?";
		query = "INSERT INTO cycle_vst(client_id,seq,vst_est_dt,vst_est_cont) "+
				" VALUES(?,(select lpad(max(seq)+1,2,'0') from cycle_vst where client_id=?),?,'순회방문')";
		
		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query2);
			pstmt.setString(1,client_id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				last_cont_dt = rs.getString(1);
			}
			rs.close();
			pstmt.close();

			pstmt2 = conn.prepareStatement(query1);
			pstmt2.setString(1,client_id);
			rs2 = pstmt2.executeQuery();
			while(rs2.next()){
				max_vst_est_dt = rs2.getString(1);
			}
			rs2.close();
			pstmt2.close();

			//최초방문일이 없을경우에는 마지막 방문일 부터 재연장. 
			if(first_vst_dt.equals(""))	first_vst_dt = AddUtil.ChangeString((c_db.addDay(c_db.addMonth(max_vst_est_dt,cycle_vst_mon),cycle_vst_day)));

			pstmt3 = conn.prepareStatement(query);
			for(int i=0; i<tot_vst; i++ ){								
				pstmt3.setString(1, client_id);				
				pstmt3.setString(2, client_id);
				pstmt3.setString(3, AddUtil.ChangeString(first_vst_dt));
				first_vst_dt = c_db.addDay(c_db.addMonth(first_vst_dt,cycle_vst_mon),cycle_vst_day);

				if(AddUtil.parseInt(AddUtil.ChangeString(first_vst_dt)) > AddUtil.parseInt(last_cont_dt)) break;
				result = pstmt3.executeUpdate();
				if(result<=0) break;
			}
			pstmt3.close();

			conn.commit();
		}catch(Exception e){
			System.out.println("[CusReg_Database:extendLastCont(String client_id, String first_vst_dt, int cycle_vst_mon, int cycle_vst_day, int tot_vst)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
				if(rs != null) rs.close();
              	if(pstmt != null) pstmt.close();
				if(rs2 != null) rs2.close();
              	if(pstmt2 != null) pstmt2.close();
              	if(pstmt3 != null) pstmt3.close();
				
			}catch(Exception ignore){}

			closeConnection();	
			return result;		
		}
	
	}

	/**
    * 거래처 순회방문 부정기 등록 2004.7.22.
    */
	public String insertVst(Cycle_vstBean bean){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt2 = null;
		String query, query1 = "";
		String seq = "";
		int result = 0;

		query1 = "select nvl(lpad(max(to_number(seq))+1,3,'00'),'001') from cycle_vst  where client_id = ?";

		query = "INSERT INTO cycle_vst(client_id,seq,vst_dt,visiter,vst_pur,vst_title,vst_cont,vst_est_dt,vst_est_cont,update_id,update_dt,sangdamja) "+
				" VALUES(?,?,?,?,?,?,?,?,?,?,?,?)";
		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query1);
			pstmt.setString(1, bean.getClient_id());
			rs = pstmt.executeQuery();
			while(rs.next()){
				seq = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt.close();

			pstmt2 = conn.prepareStatement(query);
			pstmt2.setString(1, bean.getClient_id());				
			pstmt2.setString(2, seq);
			pstmt2.setString(3, bean.getVst_dt());
			pstmt2.setString(4, bean.getVisiter());
			pstmt2.setString(5, bean.getVst_pur());
			pstmt2.setString(6, bean.getVst_title());
			pstmt2.setString(7, bean.getVst_cont());
			pstmt2.setString(8, bean.getVst_est_dt());
			pstmt2.setString(9, bean.getVst_est_cont());
			pstmt2.setString(10, bean.getUpdate_id());
			pstmt2.setString(11, bean.getUpdate_dt());
			pstmt2.setString(12, bean.getSangdamja());
			result = pstmt2.executeUpdate();
			pstmt2.close();
			if(result<=0)	seq = "";

			conn.commit();

		}catch(Exception e){
			System.out.println("[CusReg_Database:insertVst(Cycle_vstBean bean)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
				if(rs != null)	rs.close();
               	if(pstmt != null) pstmt.close();
				if(pstmt2 != null) pstmt2.close();
			
			}catch(Exception ignore){}

			closeConnection();
			return seq;
			
		}
		
	}

	/**
    * 거래처 순회방문 스케쥴 삭제 2004.7.7.
    */
	public int deleteScdVst(String client_id, String seq){
		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		int result = 0;

		query = "DELETE cycle_vst WHERE client_id=? AND seq=?";
		
		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, client_id);
			pstmt.setString(2, seq);
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
		}catch(SQLException e){
			System.out.println("[CusReg_Database:deleteScdVst(String client_id, String seq)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
			  conn.setAutoCommit(true);
               		  if(pstmt != null) pstmt.close();
              
			}catch(Exception ignore){}

			closeConnection();
			return result;			
		}
		
	}

	/**
	*	거래처별 순회방문 리스트 2003.11.26.수.
	* 수정:20040702.
	*/
	public Cycle_vstBean[] getCycle_vstList(String client_id){
		getConnection();
		Collection<Cycle_vstBean> col = new ArrayList<Cycle_vstBean>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = "SELECT client_id, seq, vst_dt, visiter, vst_pur, vst_title, vst_cont, vst_est_dt, vst_est_cont, update_id, update_dt, sangdamja "+
				" FROM cycle_vst "+
				" WHERE client_id = ? "+
				" ORDER BY vst_est_dt, seq ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,client_id);
			rs = pstmt.executeQuery();

			while(rs.next()){
				col.add(makeCycle_vstBean(rs));
			}
			rs.close();
			pstmt.close();

		}catch(SQLException e){
			System.out.println("[CusReg_Database:getCycle_vstList(String client_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return (Cycle_vstBean[])col.toArray(new Cycle_vstBean[0]);
		}		
	}	

	/**
	*	거래처별 순회방문 건별 조회 2004.07.05.
	*/
	public Cycle_vstBean getCycle_vst(String client_id, String seq){
		getConnection();
		Cycle_vstBean bean = new Cycle_vstBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = "SELECT client_id, seq, vst_dt, visiter, vst_pur, vst_title, vst_cont, vst_est_dt, vst_est_cont, update_id, update_dt, sangdamja "+
				" FROM cycle_vst "+
				" WHERE client_id=? AND seq=? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,client_id);
			pstmt.setString(2, seq);
			rs = pstmt.executeQuery();

			while(rs.next()){
				bean = makeCycle_vstBean(rs);
			}
			rs.close();
			pstmt.close();

		}catch(SQLException e){
			System.out.println("[CusReg_Database:getCycle_vst(String client_id, String seq)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return bean;
		}		
	}	

	/**
	*	거래처별 관리담당자 조회 2004.07.05.
	*/
	public Vector getMng(String client_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = " SELECT DISTINCT mng_id FROM cont WHERE client_id=?  AND nvl(use_yn,'Y') = 'Y'";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,client_id);
			rs = pstmt.executeQuery();

			while(rs.next()){
				String mng_id = rs.getString(1)==null?"":rs.getString(1);
				vt.add(mng_id);
			}
			rs.close();
			pstmt.close();

		}catch(Exception e){
			System.out.println("[CusReg_Database:getMng(String client_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return vt;
		}
	}

	/**
	*	거래처별 순회방문 조회 2004.07.05. 최초방문일, 방문주기(월,일), 총방문횟수
	*/
	public Hashtable getCycle_vst(String client_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = " SELECT first_vst_dt, substr(cycle_vst,1,2) cycle_vst_mon, substr(cycle_vst,3,4) cycle_vst_day, tot_vst FROM client WHERE client_id=?";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,client_id);
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
		}catch(Exception e){
			System.out.println("[CusReg_Database:getCycle_vst(String client_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return ht;
		}
	}

	/**
     * 거래처 순회방문 수정 2003.11.26.수.
    */
	public int updateCycle_vst(Cycle_vstBean bean){

		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		int result = 0;
		query = "UPDATE cycle_vst SET vst_dt=replace(?,'-',''),visiter=?,vst_pur=?,vst_title=?,vst_cont=?,vst_est_dt=replace(?,'-',''),vst_est_cont=?,update_id=?,update_dt=replace(?,'-',''),sangdamja=? "+
				" WHERE client_id=? AND seq=?";

		try{
		
		    conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,bean.getVst_dt());
			pstmt.setString(2,bean.getVisiter());
			pstmt.setString(3,bean.getVst_pur());
			pstmt.setString(4,bean.getVst_title());
			pstmt.setString(5,bean.getVst_cont());
			pstmt.setString(6,bean.getVst_est_dt());
			pstmt.setString(7,bean.getVst_est_cont());
			pstmt.setString(8,bean.getUpdate_id());
			pstmt.setString(9,bean.getUpdate_dt());
			pstmt.setString(10,bean.getSangdamja());
			pstmt.setString(11,bean.getClient_id());
			pstmt.setString(12,bean.getSeq());
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();			
			
		}catch(SQLException e){
			System.out.println("[CusReg_Database:updateCycle_vst(Cycle_vstBean bean)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
			  conn.setAutoCommit(true);
               		  if(pstmt != null) pstmt.close();
               
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}
		
	}
	
	/**
     * 순회방문 다음방문예정일 수정시 순번 조회 2004.07.07.
    */
	public Vector getScdVstSeq(String client_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = 	" SELECT seq FROM cycle_vst WHERE vst_dt is null AND client_id='"+client_id+"' ORDER BY seq ";

		try {
			stmt = conn.createStatement();
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

		} catch (SQLException e) {
			System.out.println("[CusReg_Database:getScdVstSeq(String client_id)]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
     * 거래처 순회방문 수정 2004.7.7.
    */
	public int modifyScdVst(String client_id, String seq, String vst_est_dt, String vst_cng_cau, String h_all){

		getConnection();
		CommonDataBase c_db = CommonDataBase.getInstance();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		String query, query1 = "";
		int result=0;
		int max_seq = 0;

		query = "select max(seq) from cycle_vst where client_id =?";

		try{
			conn.setAutoCommit(false);
			    
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,client_id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				max_seq = AddUtil.parseInt(rs.getString(1)==null?"00":rs.getString(1));
			}
			rs.close();
			pstmt.close();

			//방문예정일 변경
			query1 = "UPDATE cycle_vst SET vst_est_dt=replace(?,'-',''),vst_cng_cau=? WHERE client_id=? AND seq=?";
			pstmt2 = conn.prepareStatement(query1);
			if(h_all.equals("N")){
				pstmt2.setString(1,vst_est_dt);
				pstmt2.setString(2,vst_cng_cau);
				pstmt2.setString(3,client_id);
				pstmt2.setString(4,seq);
				result = pstmt2.executeUpdate();
			}else{				
				for(int i=AddUtil.parseInt(seq); i<=max_seq; i++){					
					if(i==AddUtil.parseInt(seq)){
						pstmt2.setString(1, AddUtil.ChangeString(vst_est_dt));
					}else{
						pstmt2.setString(1, AddUtil.ChangeString((c_db.addMonth(vst_est_dt,1))));
						vst_est_dt = c_db.addMonth(vst_est_dt,1);
					}
					pstmt2.setString(2, vst_cng_cau);
					pstmt2.setString(3, client_id);
					pstmt2.setString(4, AddUtil.addZero2(i));
					result = pstmt2.executeUpdate();
					if(result<=0) break;
				}
			}
			pstmt2.close();
			conn.commit();
		}catch(SQLException e){
			System.out.println("[CusReg_Database:modifyScdVst(String client_id, String seq, String vst_est_dt, String vst_cng_cau, String h_all)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
			     	conn.setAutoCommit(true);
					if(rs != null) rs.close();
           			if(pstmt != null) pstmt.close();
					if(pstmt2 != null) pstmt2.close();
           
			}catch(Exception ignore){}

			closeConnection();
			return result;
			
		}
		
	}

/*----------------자동차 정비 등록-------------------------------------------------------*/
	/**
     * 사고등록시 계약번호, 상호, 차량번호로 계약리스트 조회 : car_rent_list.jsp
	 * 2004.7.8. 변경. - 현재 살아있는 계약건 
	 * 매각되기전에 고치는 경우도 있음. - 20151105 수정
     */
    public Vector getCarList(String car_no){
        getConnection();        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
		Vector vt = new Vector();

       	String query =	" SELECT distinct a.use_yn, a.client_id, a.car_mng_id, b.car_no, d.car_nm, c.car_name "+
						" FROM cont a, car_reg b, car_nm c, car_mng d, car_etc e, car_change f, cls_cont g "+
						" WHERE a.car_mng_id=b.car_mng_id "+
						" AND a.rent_mng_id = e.rent_mng_id "+
						" AND a.rent_l_cd = e.rent_l_cd /* and a.car_st <> '4' */ and a.rent_l_cd not like 'RM%' "+
						" AND a.car_mng_id = f.car_mng_id(+) "+
						" AND e.car_id=c.car_id AND e.car_seq=c.car_seq AND c.car_comp_id=d.car_comp_id AND c.car_cd=d.code "+
						" and a.rent_mng_id=g.rent_mng_id(+) and a.rent_l_cd=g.rent_l_cd(+) "+
						" and (nvl(a.use_yn,'Y')='Y' or nvl(g.cls_st,'0') in ('8' ,'6') )"+
						" AND f.car_no like '%"+car_no+"%'"+
						" ORDER BY d.car_nm ";
//System.out.println("[CusReg_Database:getCarList(String car_no)]"+query);
        try{
			pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery(query);

			
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
		}catch(SQLException e){
			System.out.println("[CusReg_Database:getCarList(String car_no)]"+e);
			System.out.println("[CusReg_Database:getCarList(String car_no)]"+query);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return vt;
		}
    }

	/**
	*	차량리스트 상세정보 2003.10.15.
	* -cus0401 에서 2004.7.8.
	*/
	public CarInfoBean getCarInfo(String car_mng_id){
		getConnection();
		CarInfoBean carinfo = new CarInfoBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = "SELECT a.car_mng_id CAR_MNG_ID, b.rent_mng_id RENT_MNG_ID, b.rent_l_cd RENT_L_CD, a.car_no CAR_NO, n.car_nm CAR_JNM, d.car_name CAR_NM, a.car_num CAR_NUM, a.init_reg_dt INIT_REG_DT, a.car_kd CAR_KD, a.car_use CAR_USE, a.car_form CAR_FORM, a.car_y_form CAR_Y_FORM, a.mot_form MOT_FORM, c.colo COLO, a.dpm DPM, a.conti_rat CONTI_RAT, a.fuel_kd FUEL_KD, e.age_scp AGE_SCP, e.ins_com_nm INS_COM_NM, e.ins_start_dt INS_START_DT, e.ins_exp_dt INS_EXP_DT, e.agnt_imgn_tel AGNT_IMGN_TEL, e.acc_tel ACC_TEL, e.vins_spe VINS_SPE, e.vins_cacdt_amt VINS_CACDT_AMT, f.che_st_dt CHE_ST_DT, f.che_end_dt CHE_END_DT, a.first_serv_dt FIRST_SERV_DT, a.cycle_serv CYCLE_SERV, a.tot_serv TOT_SERV, b.mng_id MNG_ID, a.guar_gen_y GUAR_GEN_Y, a.guar_gen_km, a.guar_endur_y, a.guar_endur_km, a.maint_st_dt, a.maint_end_dt, a.test_st_dt, a.test_end_dt \n "+ 
					", vt.tot_dist as TOT_DIST \n "+ 
					", decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(b.dlv_dt,a.init_reg_dt),0,round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(b.dlv_dt,a.init_reg_dt),'YYYYMMDD'))))) as AVERAGE_DIST \n "+ 
					", decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(b.dlv_dt,a.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(b.dlv_dt,a.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST  \n "+ 
					", a.car_end_dt CAR_END_DT, a.car_ext CAR_EXT \n "+ 
			" FROM car_reg a, cont b, car_etc c, car_nm d, car_mng n, v_tot_dist vt  "+
				", (select ir.car_mng_id CAR_MNG_ID, ic.ins_com_nm INS_COM_NM, ir.ins_start_dt INS_START_DT, ir.ins_exp_dt INS_EXP_DT, ir.age_scp AGE_SCP, ir.agnt_imgn_tel AGNT_IMGN_TEL, ir.acc_tel ACC_TEL, ir.vins_spe VINS_SPE, ir.vins_cacdt_amt VINS_CACDT_AMT from insur ir, ins_com ic where ir.ins_com_id = ic.ins_com_id and ir.ins_st = (select max(ins_st) from insur where car_mng_id = ir.car_mng_id)) e \n "+ 
				", (select a.car_mng_id CAR_MNG_ID, a.che_st_dt CHE_ST_DT, a.che_end_dt CHE_END_DT from car_maint a where seq_no = (select max(seq_no) from car_maint where a.car_mng_id= car_mng_id)) f \n "+ 
				", (select max(a.serv_dt) as serv_dt from (select '0' as serv_dt from dual union all select to_char(serv_dt) as serv_dt from service where car_mng_id=? and serv_dt||serv_id = (select max(serv_dt||serv_id) from service where car_mng_id=?)) a) i \n "+ 
			" WHERE a.car_mng_id = b.car_mng_id \n "+ 
			" AND nvl(b.use_yn,'Y') = 'Y' \n "+ 
			" AND b.rent_mng_id = c.rent_mng_id \n "+ 
			" AND b.rent_l_cd = c.rent_l_cd  /*and b.car_st <> '4'*/ and b.rent_l_cd not like 'RM%' \n "+ 
			" AND c.car_id = d.car_id \n "+ 
			" AND c.car_seq = d.car_seq \n "+ 
			" AND d.car_comp_id = n.car_comp_id \n "+ 
			" AND d.car_cd = n.code \n "+ 
			" AND a.car_mng_id = vt.car_mng_id(+) \n "+ 
			" AND a.car_mng_id = e.car_mng_id  \n "+ 
			" AND a.car_mng_id = f.car_mng_id(+) \n "+ 
			" AND a.car_mng_id = ? ";


		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
			pstmt.setString(2,car_mng_id);
			pstmt.setString(3,car_mng_id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				carinfo = makeCarInfoBean(rs);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[CusReg_Database:getCarInfo(String car_mng_id)]"+e);
			System.out.println("[CusReg_Database:getCarInfo(String car_mng_id)]"+query);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return carinfo;
		}		
	}

	/**
	*	차량리스트 상세정보 2003.10.15.
	* -cus0401 에서 2004.7.8.
	*/
	public CarInfoBean getCarInfo(String car_mng_id, String rent_l_cd){
		getConnection();
		CarInfoBean carinfo = new CarInfoBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = "SELECT a.car_mng_id CAR_MNG_ID, b.rent_mng_id RENT_MNG_ID, b.rent_l_cd RENT_L_CD, a.car_no CAR_NO, n.car_nm CAR_JNM, d.car_name CAR_NM, a.car_num CAR_NUM, a.init_reg_dt INIT_REG_DT, a.car_kd CAR_KD, a.car_use CAR_USE, a.car_form CAR_FORM, a.car_y_form CAR_Y_FORM, a.mot_form MOT_FORM, c.colo COLO, a.dpm DPM, a.conti_rat CONTI_RAT, a.fuel_kd FUEL_KD, e.age_scp AGE_SCP, e.ins_com_nm INS_COM_NM, e.ins_start_dt INS_START_DT, e.ins_exp_dt INS_EXP_DT, e.agnt_imgn_tel AGNT_IMGN_TEL, e.acc_tel ACC_TEL, e.vins_spe VINS_SPE, e.vins_cacdt_amt VINS_CACDT_AMT, f.che_st_dt CHE_ST_DT, f.che_end_dt CHE_END_DT, a.first_serv_dt FIRST_SERV_DT, a.cycle_serv CYCLE_SERV, a.tot_serv TOT_SERV, b.mng_id MNG_ID, a.guar_gen_y GUAR_GEN_Y, a.guar_gen_km, a.guar_endur_y, a.guar_endur_km, a.maint_st_dt, a.maint_end_dt, a.test_st_dt, a.test_end_dt "+
					", vt.tot_dist as TOT_DIST "+
					", decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(b.dlv_dt,a.init_reg_dt),0,round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(b.dlv_dt,a.init_reg_dt),'YYYYMMDD'))))) as AVERAGE_DIST " +
					", decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(b.dlv_dt,a.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(b.dlv_dt,a.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST " +
					", a.car_end_dt CAR_END_DT, c.car_ext CAR_EXT \n "+ 
			" FROM car_reg a, cont b, car_etc c, car_nm d, car_mng n, v_tot_dist vt "+
				", (select ir.car_mng_id CAR_MNG_ID, ic.ins_com_nm INS_COM_NM, ir.ins_start_dt INS_START_DT, ir.ins_exp_dt INS_EXP_DT, ir.age_scp AGE_SCP, ir.agnt_imgn_tel AGNT_IMGN_TEL, ir.acc_tel ACC_TEL, ir.vins_spe VINS_SPE, ir.vins_cacdt_amt VINS_CACDT_AMT from insur ir, ins_com ic where ir.ins_com_id = ic.ins_com_id and ir.ins_st = (select max(ins_st) from insur where car_mng_id = ir.car_mng_id)) e "+
				", (select a.car_mng_id CAR_MNG_ID, a.che_st_dt CHE_ST_DT, a.che_end_dt CHE_END_DT from car_maint a where seq_no = (select max(seq_no) from car_maint where a.car_mng_id= car_mng_id)) f "+
				", (select max(a.serv_dt) as serv_dt, max(a.tot_dist) as tot_dist from (select '0' as serv_dt, '0' as tot_dist from dual union all select to_char(serv_dt) as serv_dt, to_char(tot_dist) as tot_dist  from service where car_mng_id=? and serv_dt||serv_id = (select max(serv_dt||serv_id) from service where car_mng_id=?)) a) i "+
			" WHERE a.car_mng_id = b.car_mng_id "+
			" AND b.rent_mng_id = c.rent_mng_id "+
			" AND b.rent_l_cd = c.rent_l_cd  /*and b.car_st <> '4'*/ and b.rent_l_cd not like 'RM%'   "+
			" AND c.car_id = d.car_id "+
			" AND c.car_seq = d.car_seq "+
			" AND d.car_comp_id = n.car_comp_id "+
			" AND d.car_cd = n.code "+
			" AND a.car_mng_id = vt.car_mng_id(+) "+
			" AND a.car_mng_id = e.car_mng_id "+
			" AND a.car_mng_id = f.car_mng_id(+) "+
			" AND a.car_mng_id = ? and b.rent_l_cd=?";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
			pstmt.setString(2,car_mng_id);
			pstmt.setString(3,car_mng_id);
			pstmt.setString(4,rent_l_cd);
			rs = pstmt.executeQuery();
			while(rs.next()){
				carinfo = makeCarInfoBean(rs);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[CusReg_Database:getCarInfo((String car_mng_id, String rent_l_cd))]"+e);
			System.out.println("[CusReg_Database:getCarInfo((String car_mng_id, String rent_l_cd))]"+query);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return carinfo;
		}		
	}

	/**
	*	차량정비건 상세정보 2004.7.19.
	*/
	public ServInfoBean getServInfo(String car_mng_id, String serv_id){
		getConnection();
		ServInfoBean servinfo = new ServInfoBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = "SELECT a.car_mng_id CAR_MNG_ID, a.serv_id SERV_ID, a.accid_id ACCID_ID, a.rent_mng_id RENT_MNG_ID, a.rent_l_cd RENT_L_CD, a.off_id OFF_ID, b.off_nm OFF_NM, " 
			    + "     nvl2(a.serv_dt,substr(a.serv_dt,1,4)||'-'||substr(a.serv_dt,5,2)||'-'||substr(a.serv_dt,7,2),'') SERV_DT, "
				+ "     a.serv_st SERV_ST, a.checker CHECKER, a.tot_dist TOT_DIST, a.rep_nm REP_NM, a.rep_tel REP_TEL, a.rep_m_tel REP_M_TEL, "
				+ "     a.rep_amt REP_AMT, a.sup_amt SUP_AMT, a.add_amt ADD_AMT, "
			    + "     a.dc DC, a.tot_amt TOT_AMT, nvl2(a.sup_dt,substr(a.sup_dt,1,4)||'-'||substr(a.sup_dt,5,2)||'-'||substr(a.sup_dt,7,2),'') SUP_DT, "
				+ "     nvl2(a.set_dt,substr(a.set_dt,1,4)||'-'||substr(a.set_dt,5,2)||'-'||substr(a.set_dt,7,2),'') SET_DT, a.bank BANK, a.acc_no ACC_NO, a.acc_nm ACC_NM, "
				+ "     a.rep_item REP_ITEM, a.rep_cont REP_CONT, "
			    + "     nvl2(a.cust_plan_dt,substr(a.cust_plan_dt,1,4)||'-'||substr(a.cust_plan_dt,5,2)||'-'||substr(a.cust_plan_dt,7,2),'') CUST_PLAN_DT, "
				+ "     a.cust_amt CUST_AMT, a.cust_agnt CUST_AGNT, a.accid_dt ACCID_DT, a.bill_doc_yn, a.bill_mon, a.serv_jc SERV_JC, a.cust_serv_dt CUST_SERV_DT, "
				+ "     a.next_serv_dt NEXT_SERV_DT, a.next_rep_cont NEXT_REP_CONT, a.spdchk SPDCHK, " 
			    + "     a.ipgoza IPGOZA, a.ipgodt IPGODT, a.chulgoza CHULGOZA, a.chulgodt CHULGODT, a.spdchk_dt SPDCHK_DT, a.checker_st CHECKER_ST, "
				+ "     a.cust_act_dt, a.cust_nm, a.cust_tel, a.cust_rel, a.reg_id, a.update_id, a.reg_dt, a.update_dt, "
			    + "     a.r_labor R_LABOR , a.r_amt R_AMT, a.r_dc R_DC, a.r_j_amt R_J_AMT, decode(a.jung_st, '0', '', a.jung_st) JUNG_ST, a.r_dc_per R_DC_PER, "
				+ "     a.scan_file, a.estimate_num, a.sh_amt, " 
				+ "     a.call_t_nm CALL_T_NM, a.call_t_tel CALL_T_TEL, a.sac_yn, a.bus_id2 , a.file_path , '' settle_st  "
				+ "FROM service a, serv_off b, cont c "
				+ "WHERE a.car_mng_id= ? AND a.serv_id= ?  and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd "
				+ "AND a.off_id=b.off_id(+) ";


		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
			pstmt.setString(2,serv_id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				servinfo = makeServInfoBean(rs);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[CusReg_Database:getServInfo(String car_mng_id,String serv_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return servinfo;
		}		
	}

    /**
     *		차량별 정비 전체 조회 2004.7.20.
     */
    public ServInfoBean[] getServiceAll( String car_mng_id ){
        getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Collection<ServInfoBean> col = new ArrayList<ServInfoBean>();
        String query = "";
        
		query = " SELECT '1' gubun, a.car_mng_id CAR_MNG_ID, a.serv_id SERV_ID, a.accid_id ACCID_ID, a.rent_mng_id RENT_MNG_ID, a.rent_l_cd RENT_L_CD, " //6
				+ "		 a.off_id OFF_ID, b.off_nm OFF_NM, decode(serv_st,'4',nvl(a.serv_dt,SUBSTR(c.accid_dt,1,8)),a.serv_dt) SERV_DT, a.serv_st SERV_ST, a.checker CHECKER, "  //5
				+ "		 a.tot_dist TOT_DIST, a.rep_nm REP_NM, a.rep_tel REP_TEL, a.rep_m_tel REP_M_TEL, a.rep_amt REP_AMT, a.sup_amt SUP_AMT, a.add_amt ADD_AMT, a.dc DC, a.tot_amt TOT_AMT, "  //9
				+ "      nvl2(a.sup_dt,substr(a.sup_dt,1,4)||'-'||substr(a.sup_dt,5,2)||'-'||substr(a.sup_dt,7,2),'') SUP_DT, nvl2(a.set_dt,substr(a.set_dt,1,4)||'-'||substr(a.set_dt,5,2)||'-'||substr(a.set_dt,7,2),'') SET_DT, "  //2
				+ "      a.bank BANK, a.acc_no ACC_NO, a.acc_nm ACC_NM, a.rep_item REP_ITEM, a.rep_cont REP_CONT, nvl2(a.cust_plan_dt,substr(a.cust_plan_dt,1,4)||'-'||substr(a.cust_plan_dt,5,2)||'-'||substr(a.cust_plan_dt,7,2),'') CUST_PLAN_DT, "  //6
				+ "      a.cust_amt CUST_AMT, a.cust_agnt CUST_AGNT, a.accid_dt ACCID_DT, a.bill_doc_yn, a.bill_mon, a.serv_jc SERV_JC, a.cust_serv_dt CUST_SERV_DT, "  //7
				+ "      nvl(a.next_serv_dt,a.serv_dt) NEXT_SERV_DT, a.next_rep_cont NEXT_REP_CONT, a.spdchk SPDCHK, a.ipgoza IPGOZA, a.ipgodt IPGODT, a.chulgoza CHULGOZA, a.chulgodt CHULGODT, a.spdchk_dt SPDCHK_DT, "  //8
				+ "      a.checker_st CHECKER_ST, a.cust_act_dt, a.cust_nm, a.cust_tel, a.cust_rel, "  //5
				+ "      a.reg_id, a.update_id, a.r_labor, a.r_amt, a.r_dc, a.r_j_amt ,a.jung_st, a.r_dc_per, a.scan_file, a.estimate_num , a.sh_amt , " // 11
				+ "      a.call_t_nm, a.call_t_tel, a.sac_yn, a.bus_id2, a.reg_dt, a.update_dt , a.file_path , c.settle_st " //8
				+ "FROM service a, serv_off b, accident c "
				+ "WHERE a.car_mng_id=? "
				+ "AND a.off_id=b.off_id(+) "+
				"  and a.car_mng_id=c.car_mng_id(+) and a.accid_id=c.accid_id(+) "+
				" union "+
				" select '2' gubun, car_mng_id, '','','','', "+  //6
				" '','',che_dt as serv_dt,decode(che_kd,'1','8','2','9','3','10',''), che_no, "+ //5
				" che_km,'','','', 0, 0, 0, 0, 0,"+   //9
				" '', '', "+  //2
				" '', '','','', che_comp, '', "+ //6 
				" 0,'','','','','1', '', "+ //7
				" che_dt as next_serv_dt,'','', '','','','','', "+  //8
				" '','','','','',"+  //5
				" '', '', 0, 0, 0, 0, '', 0, '' , '', 0, "+  //11
				" '', '', '', '', reg_dt, '' , '' , ''  "+ //8
				" from car_maint where car_mng_id=? "+
				" ORDER BY serv_dt desc, next_serv_dt, gubun ";

        try{
            pstmt = conn.prepareStatement(query);
    		pstmt.setString(1, car_mng_id);    		
			pstmt.setString(2, car_mng_id);
    		rs = pstmt.executeQuery();
            while(rs.next()){                
				col.add(makeServInfoBean(rs)); 
            }
			rs.close();
			pstmt.close();
        }catch(SQLException e){
			 System.out.println("[CusReg_Database:getServiceAll( String car_mng_id )]"+e);
			e.printStackTrace();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(Exception ignore){}

			closeConnection();
			return (ServInfoBean[])col.toArray(new ServInfoBean[0]);
        }        
    }

	/**
    * 거래처 자동차 순회점검 스케쥴 생성 2004.7.9.
    */
	public int createScdServ(String car_mng_id, String first_serv_dt, int cycle_serv_mon, int cycle_serv_day, int tot_serv)
		 throws DatabaseException, DataSourceEmptyException{

		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		ResultSet rs = null;
		String query,query1,query2 = "";
		int result = 0;
		int serv_cnt = 0;
		CommonDataBase c_db = CommonDataBase.getInstance();
		Hashtable ht = c_db.getRent_id(car_mng_id);
		String rent_mng_id = (String)ht.get("RENT_MNG_ID");
		String rent_l_cd = (String)ht.get("RENT_L_CD");

		query2 = "select to_number(NVL(LPAD(MAX(serv_id)+1,6,'0'),'000001')) cnt from service where car_mng_id=? and serv_id not like 'N%' ";

		query = "INSERT INTO service(car_mng_id,serv_id,rent_mng_id,rent_l_cd,serv_dt,next_serv_dt,serv_jc,reg_dt) VALUES(?, ?, ?, ?, replace(?,'-',''), replace(?,'-',''), '1', to_char(sysdate,'YYYYMMDD'))";

		query1 = "UPDATE car_reg SET first_serv_dt=replace(?,'-',''), cycle_serv=?, tot_serv=? WHERE car_mng_id = ? ";
		
		try{
			conn.setAutoCommit(false);

			pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString(1, car_mng_id);		
		    rs = pstmt2.executeQuery();
			if(rs.next())
			{				
				serv_cnt = rs.getInt("cnt");	
			}
			rs.close();
			pstmt2.close();


			String cycle_serv_dt = "";
			pstmt = conn.prepareStatement(query);
			for(int i=0; i<tot_serv; i++ ){								
				pstmt.setString(1, car_mng_id);				
				pstmt.setString(2, "0000"+AddUtil.addZero2(i+serv_cnt));
				pstmt.setString(3, rent_mng_id);
				pstmt.setString(4, rent_l_cd);
				if(i==0){
					pstmt.setString(5, "");
					pstmt.setString(6, AddUtil.ChangeString(first_serv_dt));
					cycle_serv_dt = first_serv_dt;
				}else{
					pstmt.setString(5,"");
					pstmt.setString(6, AddUtil.ChangeString((c_db.addDay(c_db.addMonth(cycle_serv_dt,cycle_serv_mon),cycle_serv_day))));
					cycle_serv_dt = c_db.addDay(c_db.addMonth(cycle_serv_dt,cycle_serv_mon),cycle_serv_day);
				}				
				result = pstmt.executeUpdate();
				if(result<=0) break;
			}
			pstmt.close();

			if(result>0){
				pstmt3 = conn.prepareStatement(query1);
				pstmt3.setString(1,first_serv_dt);
				pstmt3.setString(2,AddUtil.addZero2(cycle_serv_mon)+AddUtil.addZero2(cycle_serv_day));
				pstmt3.setString(3,Integer.toString(tot_serv));
				pstmt3.setString(4,car_mng_id);
				result = pstmt3.executeUpdate();
				pstmt3.close();
			}

			conn.commit();
		}catch(Exception e){
			 try{
                conn.rollback();
            }catch(SQLException _ignored){}
			System.out.println("[CusReg_Database:createScdServ(String car_mng_id, String first_serv_dt, int cycle_serv_mon, int cycle_serv_day, int tot_serv)]"+e);

			System.out.println("[serv_cnt]"+serv_cnt);
			System.out.println("[car_mng_id]"+car_mng_id);
			System.out.println("[first_serv_dt]"+first_serv_dt);
			System.out.println("[cycle_serv_mon]"+cycle_serv_mon);
			System.out.println("[cycle_serv_day]"+cycle_serv_day);
			System.out.println("[tot_serv]"+tot_serv);

			e.printStackTrace();
		}finally{
			try{
				if(result<=0) conn.rollback(); else conn.commit();
				conn.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
				if(rs != null) rs.close();
				if(pstmt2 != null) pstmt2.close();
				if(pstmt3 != null) pstmt3.close();
			}catch(Exception ignore){}

			closeConnection();	
			return result;		
		}
		
	}   

	/**
    * 자동차 순회점검 스케쥴 추가 2004.7.12.
    */
	public int extendScdServ(String car_mng_id) throws DatabaseException, DataSourceEmptyException{
		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		int result = 0;
		CommonDataBase c_db = CommonDataBase.getInstance();
		Hashtable ht = c_db.getRent_id(car_mng_id);
		String rent_mng_id = (String)ht.get("RENT_MNG_ID");
		String rent_l_cd = (String)ht.get("RENT_L_CD");

		query = "INSERT INTO service(car_mng_id,serv_id,rent_mng_id, rent_l_cd, next_serv_dt,serv_jc,reg_dt) "+
				" VALUES(?,(SELECT NVL(LPAD(MAX(serv_id)+1,6,'0'),'000001') FROM service WHERE car_mng_id=? and serv_id not like 'N%'),?,?, "+
				" (select to_char(add_months(to_date(max(next_serv_dt), 'YYYY-MM-DD'), 1), 'YYYYMMDD') from service where car_mng_id = ?), "+
				" 1, to_char(sysdate,'YYYYMMDD') )";
		
		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);				
			pstmt.setString(2, car_mng_id);
			pstmt.setString(3, rent_mng_id);
			pstmt.setString(4, rent_l_cd);
			pstmt.setString(5, car_mng_id);
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		}catch(Exception e){
			System.out.println("[CusReg_Database:extendScdServ(String car_mng_id)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
			conn.setAutoCommit(true);
              		 if(pstmt != null) pstmt.close();
				
			}catch(Exception ignore){}

			closeConnection();		
			return result;	
		}
		
	}

	/**
    * 거래처 자동차 순회점검 스케쥴 생성 연장 2004.9.2.
    */
	public int extend_last_cont_s(String car_mng_id, String first_serv_dt, int cycle_serv_mon, int cycle_serv_day, int tot_serv) throws DatabaseException, DataSourceEmptyException{

		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		ResultSet rs = null;
		String query,query1,query2,rent_end_dt = "";
		int result = 0;
		CommonDataBase c_db = CommonDataBase.getInstance();
		Hashtable ht = c_db.getRent_id(car_mng_id);

		query = "INSERT INTO service(car_mng_id,serv_id,rent_mng_id,rent_l_cd,next_serv_dt,serv_jc,reg_dt) VALUES(?,(SELECT NVL(LPAD(MAX(serv_id)+1,6,'0'),'000001') FROM service WHERE car_mng_id=? and serv_id not like 'N%'), ?, ?, replace(?,'-',''), '1', to_char(sysdate,'YYYYMMDD'))";

		query1 = "UPDATE car_reg SET first_serv_dt=replace(?,'-',''), cycle_serv=?, tot_serv=? WHERE car_mng_id = ? ";

		query2 = "SELECT b.rent_end_dt FROM cont a, "+
				"       (select * from fee a where a.rent_st = (select max(b.rent_st) from fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd)) b "+
				"WHERE a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd AND car_mng_id=? AND nvl(use_yn,'Y') = 'Y' ";
			
		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query2);
			pstmt.setString(1, car_mng_id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				rent_end_dt = rs.getString(1);
			}
			rs.close();
			pstmt.close();

			pstmt2 = conn.prepareStatement(query);
			for(int i=0; i<tot_serv; i++ ){
				pstmt2.setString(1, car_mng_id);				
				pstmt2.setString(2, car_mng_id);
				pstmt2.setString(3, (String)ht.get("RENT_MNG_ID"));
				pstmt2.setString(4, (String)ht.get("RENT_L_CD"));
				pstmt2.setString(5, AddUtil.ChangeString(first_serv_dt));
				if(AddUtil.parseInt(AddUtil.ChangeString(first_serv_dt)) > AddUtil.parseInt(rent_end_dt)){
					break;
				}
				first_serv_dt = c_db.addDay(c_db.addMonth(first_serv_dt,cycle_serv_mon),cycle_serv_day);
				result = pstmt2.executeUpdate();
				if(result<=0) break;
			}
			pstmt2.close();

			if(result>0){
				pstmt3 = conn.prepareStatement(query1);
				pstmt3.setString(1,AddUtil.ChangeString(first_serv_dt));
				pstmt3.setString(2,AddUtil.addZero2(cycle_serv_mon)+AddUtil.addZero2(cycle_serv_day));
				pstmt3.setString(3,Integer.toString(tot_serv));
				pstmt3.setString(4,car_mng_id);
				result = pstmt3.executeUpdate();
			}
			pstmt3.close();

			conn.commit();

		}catch(Exception e){
			 try{
                conn.rollback();
            }catch(SQLException _ignored){}
			System.out.println("[CusReg_Database:extend_last_cont_s(String car_mng_id, String first_serv_dt, int cycle_serv_mon, int cycle_serv_day, int tot_serv)]"+e);
			System.out.println("[car_mng_id)]"		+car_mng_id);
			System.out.println("[RENT_MNG_ID]"		+(String)ht.get("RENT_MNG_ID"));
			System.out.println("[RENT_L_CD]"		+(String)ht.get("RENT_L_CD"));
			System.out.println("[first_serv_dt)]"	+ AddUtil.ChangeString(first_serv_dt));
			System.out.println("[cycle_serv_mon)]"	+AddUtil.addZero2(cycle_serv_mon));
			System.out.println("[cycle_serv_day)]"	+AddUtil.addZero2(cycle_serv_day));
			System.out.println("[tot_serv)]"		+tot_serv);
			e.printStackTrace();
		}finally{
			try{
				if(result<=0) conn.rollback(); else conn.commit();
				conn.setAutoCommit(true);
				if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
				if(pstmt2 != null) pstmt2.close();
				if(pstmt3 != null) pstmt3.close();
			}catch(Exception ignore){}

			closeConnection();	
			return result;		
		}
		
	}   

	/**
     * 자동차 다음정비예정일 수정시 순번 조회 2004.07.13.
    */
	public Vector getScdServ_id(String car_mng_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = 	" SELECT serv_id FROM service WHERE next_serv_dt is null AND car_mng_id='"+car_mng_id+"' AND serv_jc='1' ORDER BY serv_id ";

		try {
			stmt = conn.createStatement();
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
		} catch (SQLException e) {
			System.out.println("[CusReg_Database:getScdServ_id(String car_mng_id)]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
     * 거래처 순회방문 수정 2004.7.7.
    */
	public int modifyScdServ(String car_mng_id, String serv_id, String next_serv_dt, String serv_cng_cau, String h_all){

		getConnection();
		CommonDataBase c_db = CommonDataBase.getInstance();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		String query, query1 = "";
		int result=0;
		int max_serv_id = 0;

		query = "select max(serv_id) from service where car_mng_id = ?";

		try{
			
			conn.setAutoCommit(false);
				
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				max_serv_id = AddUtil.parseInt(rs.getString(1)==null?"000000":rs.getString(1));
			}
			rs.close();
			pstmt.close();

			//방문예정일 변경
			query1 = "UPDATE service SET next_serv_dt=replace(?,'-',''),serv_cng_cau=? WHERE car_mng_id=? AND serv_id=?";
			pstmt2 = conn.prepareStatement(query1);
			if(h_all.equals("N")){
				pstmt2.setString(1,next_serv_dt);
				pstmt2.setString(2,serv_cng_cau);
				pstmt2.setString(3,car_mng_id);
				pstmt2.setString(4,serv_id);
				result = pstmt2.executeUpdate();
			}else{				
				for(int i=AddUtil.parseInt(serv_id); i<=max_serv_id; i++){					
					if(i==AddUtil.parseInt(serv_id)){
						pstmt2.setString(1, AddUtil.ChangeString(next_serv_dt));
					}else{
						pstmt2.setString(1, AddUtil.ChangeString((c_db.addMonth(next_serv_dt,1))));
						next_serv_dt = c_db.addMonth(next_serv_dt,1);
					}
					pstmt2.setString(2, serv_cng_cau);
					pstmt2.setString(3, car_mng_id);
					pstmt2.setString(4, "0000"+AddUtil.addZero2(i));
					result = pstmt2.executeUpdate();
					if(result<=0) break;
				}
			}
			pstmt2.close();

			conn.commit();
			
		}catch(SQLException e){
			System.out.println("[CusReg_Database:modifyScdServ(String car_mng_id, String serv_id, String next_serv_dt, String serv_cng_cau, String h_all)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
			   	conn.setAutoCommit(true);
				if(rs != null) rs.close();
              	if(pstmt != null) pstmt.close();
				if(pstmt2 != null) pstmt2.close();
            
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}
	}

	/**
	*	 차량진단빈 조회 (speedcheck) 2003.12.23.화.
	*	- 20040715 점검품목리스트.
	*/
	public SpdchkBean[] getSpdchk()
	{
		getConnection();
		Collection<SpdchkBean> col = new ArrayList<SpdchkBean>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;		
		String query = " SELECT chk_id, chk_nm, chk_cont FROM speedcheck ";
		try{
			pstmt = conn.prepareStatement(query);
		    rs = pstmt.executeQuery();    	
			while(rs.next()){
				SpdchkBean bean = new SpdchkBean();
			    bean.setChk_id(rs.getString("CHK_ID"));
				bean.setChk_nm(rs.getString("CHK_NM"));
				bean.setChk_cont(rs.getString("CHK_CONT"));
				col.add(bean);
			}
			rs.close();
			pstmt.close();
		} catch (Exception e) {
			System.out.println("[CusReg_Database:getSpdchk()]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return (SpdchkBean[])col.toArray(new SpdchkBean[0]);
		}			
	}

	/**
	*	 순회점검 등록 2004.7.19.
	*/
	public int updateService(ServInfoBean bean){
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		String query, query1, query2 = "";
		int result = 0;

	
		query2 = "INSERT INTO service(car_mng_id, serv_id, rent_mng_id, rent_l_cd, off_id, serv_st, serv_dt, " +  //7
			     " checker, spdchk_dt, tot_dist, next_serv_dt, rep_cont, next_rep_cont, checker_st, spdchk,  " +  //8
			     " accid_id, ipgoza, ipgodt, chulgoza, chulgodt, sup_amt, add_amt, rep_amt, " +  //8
			     " dc, tot_amt, set_dt, reg_id, reg_dt ) VALUES ( " + //5
			     " ?, ?, ?, ?, ?, ?, replace(?,'-',''), " + //7
			     " ?, replace(?,'-',''), ?, replace(?,'-',''), ?, ?, ?, ?, " + //8
			     " ?, ?, replace(?,'-',''), ?, replace(?,'-',''), ?, ?, ?, " + //8
			     " ?, ?, replace(?,'-',''), ?, to_char(sysdate,'YYYYMMDD')) ";
			     
		query1 = "SELECT car_mng_id, serv_id FROM service WHERE car_mng_id=? AND serv_id=? ";
		query = " UPDATE service SET rent_mng_id=?,rent_l_cd=?,off_id=?,serv_st=?,serv_dt=?,checker=?,spdchk_dt=?,tot_dist=?,next_serv_dt=?,rep_cont=?,next_rep_cont=?,checker_st=?,spdchk=?,accid_id=?,ipgoza=?,ipgodt=?,chulgoza=?,chulgodt=?,sup_amt=?, add_amt=?, rep_amt=?, dc=?, tot_amt=?, set_dt=?, update_id=?, update_dt=to_char(sysdate,'YYYYMMDD') WHERE car_mng_id = ? AND serv_id = ? ";

		try{

			conn.setAutoCommit(false);

			if(bean.getRent_mng_id().equals("")||bean.getRent_l_cd().equals("")){
				CommonDataBase c_db = CommonDataBase.getInstance();
				Hashtable ht = c_db.getRent_id(bean.getCar_mng_id());
				bean.setRent_mng_id((String)ht.get("RENT_MNG_ID"));
				bean.setRent_l_cd((String)ht.get("RENT_L_CD"));
			}
			if(bean.getServ_st().equals("1"))	bean.setOff_id("000086");	//순회점검

			pstmt = conn.prepareStatement(query1);
			pstmt.setString(1, bean.getCar_mng_id());
			pstmt.setString(2, bean.getServ_id());
			rs = pstmt.executeQuery();
			if(rs.next()){
				pstmt2 = conn.prepareStatement(query);
				pstmt2.setString(1, bean.getRent_mng_id());
				pstmt2.setString(2, bean.getRent_l_cd());
				pstmt2.setString(3, bean.getOff_id());
				pstmt2.setString(4, bean.getServ_st());
				pstmt2.setString(5, bean.getServ_dt());
				pstmt2.setString(6, bean.getChecker());
				pstmt2.setString(7, bean.getSpdchk_dt());
				pstmt2.setInt   (8, AddUtil.parseInt(bean.getTot_dist()));
				pstmt2.setString(9, bean.getNext_serv_dt());
				pstmt2.setString(10, bean.getRep_cont());
				pstmt2.setString(11, bean.getNext_rep_cont());
				pstmt2.setString(12, bean.getChecker_st());
				pstmt2.setString(13, bean.getSpd_chk());
				pstmt2.setString(14, bean.getAccid_id());
				pstmt2.setString(15, bean.getIpgoza());
				pstmt2.setString(16, bean.getIpgodt());
				pstmt2.setString(17, bean.getChulgoza());
				pstmt2.setString(18, bean.getChulgodt());
				pstmt2.setInt   (19, bean.getSup_amt());
				pstmt2.setInt   (20, bean.getAdd_amt());
				pstmt2.setInt   (21, bean.getRep_amt());
				pstmt2.setInt   (22, bean.getDc());
				pstmt2.setInt   (23, bean.getTot_amt());
				pstmt2.setString(24, bean.getSet_dt());
				pstmt2.setString(25, bean.getReg_id());
				pstmt2.setString(26, bean.getCar_mng_id());
				pstmt2.setString(27, bean.getServ_id());
				result = pstmt2.executeUpdate();
				pstmt2.close();
			}else{ //등록
				pstmt2 = conn.prepareStatement(query2);
				pstmt2.setString(1, bean.getCar_mng_id());
				pstmt2.setString(2, bean.getServ_id());
				pstmt2.setString(3, bean.getRent_mng_id());
				pstmt2.setString(4, bean.getRent_l_cd());
				pstmt2.setString(5, bean.getOff_id());
				pstmt2.setString(6, bean.getServ_st());
				pstmt2.setString(7, bean.getServ_dt());
				pstmt2.setString(8, bean.getChecker());
				pstmt2.setString(9, bean.getSpdchk_dt());
				pstmt2.setInt   (10, AddUtil.parseInt(bean.getTot_dist()));
				pstmt2.setString(11, bean.getNext_serv_dt());
				pstmt2.setString(12, bean.getRep_cont());
				pstmt2.setString(13, bean.getNext_rep_cont());
				pstmt2.setString(14, bean.getChecker_st());
				pstmt2.setString(15, bean.getSpd_chk());
				pstmt2.setString(16, bean.getAccid_id());
				pstmt2.setString(17, bean.getIpgoza());
				pstmt2.setString(18, bean.getIpgodt());
				pstmt2.setString(19, bean.getChulgoza());
				pstmt2.setString(20, bean.getChulgodt());
				pstmt2.setInt   (21, bean.getSup_amt());
				pstmt2.setInt   (22, bean.getAdd_amt());
				pstmt2.setInt   (23, bean.getRep_amt());
				pstmt2.setInt   (24, bean.getDc());
				pstmt2.setInt   (25, bean.getTot_amt());
				pstmt2.setString(26, bean.getSet_dt());
				pstmt2.setString(27, bean.getReg_id());
				result = pstmt2.executeUpdate();
				pstmt2.close();
			}
			rs.close();
			pstmt.close();
						
			conn.commit();
		}catch(Exception e){
			System.out.println("[CusReg_Database:updateService(ServInfoBean bean)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
			    conn.setAutoCommit(true);
			    if(rs != null) rs.close();
            	if(pstmt != null) pstmt.close();
				if(pstmt2 != null) pstmt2.close();
				
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}
	}

	/**
	*	 일반정비/보증정비 등록 2004.8.2.
	*/
	public int updateService_g(ServInfoBean bean){
		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		int result = 0;
				
		query = " UPDATE service SET "+
				"   rent_mng_id	=?,"+
				"   rent_l_cd	=?,"+
				"	serv_st		=?,"+
				"	serv_jc		=?,"+
				"	serv_dt		=replace(?,'-',''),"+
				"	off_id		=?,"+
				"	ipgoza		=?,"+
				"	ipgodt		=replace(?,'-',''),"+
				"	chulgoza	=?,"+
				"	chulgodt	=replace(?,'-',''),"+
				"	cust_nm		=?,"+
				"	cust_tel	=?,"+
				"	cust_rel	=?,"+
				"	sup_amt		=?,"+
				"	add_amt		=?,"+
				"	rep_amt		=?,"+
				"	dc			=?,"+
				"	tot_amt		=?,"+
				"	checker		=?,"+
				"	spdchk_dt	=replace(?,'-',''),"+
				"	tot_dist	=?,"+
				"	next_serv_dt=replace(?,'-',''),"+
				"	rep_cont	=?,"+
				"	checker_st	=?,"+ 
				"	accid_id	=?,"+
				"	cust_act_dt	=replace(?,'-',''),"+
				"	set_dt		=replace(?,'-',''),"+
				"	update_id	=?,"+
				"	update_dt	=to_char(sysdate,'YYYYMMDD'), "+
				"	r_labor		=?,"+
				"	r_amt		=?,"+
				"	r_dc		=?,"+
				"	r_dc_per	=?,"+
				"	r_j_amt		=?, "+
				"	sh_amt		=?, "+
				"	bus_id2		=? "+
				" WHERE car_mng_id=? AND serv_id=? ";
		
		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  bean.getRent_mng_id	());
			pstmt.setString(2,  bean.getRent_l_cd	());
			pstmt.setString(3,  bean.getServ_st		());
			pstmt.setString(4,  bean.getServ_jc		());
			pstmt.setString(5,  bean.getServ_dt		());
			pstmt.setString(6,  bean.getOff_id		());
			pstmt.setString(7,  bean.getIpgoza		());
			pstmt.setString(8,  bean.getIpgodt		());
			pstmt.setString(9,  bean.getChulgoza	());
			pstmt.setString(10, bean.getChulgodt	());
			pstmt.setString(11, bean.getCust_nm		());
			pstmt.setString(12, bean.getCust_tel	());
			pstmt.setString(13, bean.getCust_rel	());
			pstmt.setInt   (14, bean.getSup_amt		());
			pstmt.setInt   (15, bean.getAdd_amt		());
			pstmt.setInt   (16, bean.getRep_amt		());
			pstmt.setInt   (17, bean.getDc			());
			pstmt.setInt   (18, bean.getTot_amt		());
			pstmt.setString(19, bean.getChecker		());
			pstmt.setString(20, bean.getSpdchk_dt	());
			pstmt.setInt   (21, AddUtil.parseInt(bean.getTot_dist()));
			pstmt.setString(22, bean.getNext_serv_dt());
			pstmt.setString(23, bean.getRep_cont	());
			pstmt.setString(24, bean.getChecker_st	());
			pstmt.setString(25, bean.getAccid_id	());
			pstmt.setString(26, bean.getCust_act_dt	());
			pstmt.setString(27, bean.getSet_dt		());
			pstmt.setString(28, bean.getUpdate_id	());
			pstmt.setInt   (29, bean.getR_labor		());
			pstmt.setInt   (30, bean.getR_amt		());
			pstmt.setInt   (31, bean.getR_dc		());
			pstmt.setInt   (32, bean.getR_dc_per		());
			pstmt.setInt   (33, bean.getR_j_amt		());	
			pstmt.setInt   (34, bean.getSh_amt		());	
			pstmt.setString(35, bean.getBus_id2	());	
			pstmt.setString(36, bean.getCar_mng_id	());
			pstmt.setString(37, bean.getServ_id		());
						
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		}catch(Exception e){
			System.out.println("[CusReg_Database:updateService_g(ServInfoBean bean)]"+e);

			System.out.println("[bean.getRent_mng_id	()]"+bean.getRent_mng_id	());
			System.out.println("[bean.getRent_l_cd		()]"+bean.getRent_l_cd		());
			System.out.println("[bean.getServ_st		()]"+bean.getServ_st		());
			System.out.println("[bean.getServ_jc		()]"+bean.getServ_jc		());
			System.out.println("[bean.getServ_dt		()]"+bean.getServ_dt		());
			System.out.println("[bean.getOff_id			()]"+bean.getOff_id			());
			System.out.println("[bean.getIpgoza			()]"+bean.getIpgoza			());
			System.out.println("[bean.getIpgodt			()]"+bean.getIpgodt			());
			System.out.println("[bean.getChulgoza		()]"+bean.getChulgoza		());
			System.out.println("[bean.getChulgodt		()]"+bean.getChulgodt		());
			System.out.println("[bean.getCust_nm		()]"+bean.getCust_nm		());
			System.out.println("[bean.getCust_tel		()]"+bean.getCust_tel		());
			System.out.println("[bean.getCust_rel		()]"+bean.getCust_rel		());
			System.out.println("[bean.getSup_amt		()]"+bean.getSup_amt		());
			System.out.println("[bean.getAdd_amt		()]"+bean.getAdd_amt		());
			System.out.println("[bean.getRep_amt		()]"+bean.getRep_amt		());
			System.out.println("[bean.getDc				()]"+bean.getDc				());
			System.out.println("[bean.getTot_amt		()]"+bean.getTot_amt		());
			System.out.println("[bean.getChecker		()]"+bean.getChecker		());
			System.out.println("[bean.getSpdchk_dt		()]"+bean.getSpdchk_dt		());
			System.out.println("[bean.getTot_dist		()]"+bean.getTot_dist		());
			System.out.println("[bean.getNext_serv_dt	()]"+bean.getNext_serv_dt	());
			System.out.println("[bean.getRep_cont		()]"+bean.getRep_cont		());
			System.out.println("[bean.getChecker_st		()]"+bean.getChecker_st		());
			System.out.println("[bean.getAccid_id		()]"+bean.getAccid_id		());
			System.out.println("[bean.getCust_act_dt	()]"+bean.getCust_act_dt	());
			System.out.println("[bean.getSet_dt			()]"+bean.getSet_dt			());
			System.out.println("[bean.getUpdate_id		()]"+bean.getUpdate_id		());
			System.out.println("[bean.getR_labor		()]"+bean.getR_labor		());
			System.out.println("[bean.getR_amt			()]"+bean.getR_amt			());
			System.out.println("[bean.getR_dc			()]"+bean.getR_dc			());
			System.out.println("[bean.getR_j_amt		()]"+bean.getR_j_amt		());
			System.out.println("[bean.getCar_mng_id		()]"+bean.getCar_mng_id		());
			System.out.println("[bean.getServ_id		()]"+bean.getServ_id		());

			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
            			if(pstmt != null) pstmt.close();
			
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}
	}

	/**
	*	 일반정비/보증정비 등록 2004.8.2.
	*/
	public int updateService_g1(ServInfoBean bean){
		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		int result = 0;
				
		query = " UPDATE service SET "+
				"	serv_st		=?,"+
				"	update_id	=?,"+
				"	update_dt	=to_char(sysdate,'YYYYMMDD') "+				
				" WHERE car_mng_id=? AND serv_id=? ";
		
		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
		
			pstmt.setString(1, bean.getServ_st());
			pstmt.setString(2, bean.getUpdate_id());
			pstmt.setString(3, bean.getCar_mng_id());
			pstmt.setString(4, bean.getServ_id());
						
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		}catch(Exception e){
			System.out.println("[CusReg_Database:updateService_g1(ServInfoBean bean)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
			conn.setAutoCommit(true);
              		  if(pstmt != null) pstmt.close();
				
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}
	}
	
	
	
	/**
	*	 주행거리만 수정 - 20120903
	*/
	public int updateService_g2(ServInfoBean bean){
		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		int result = 0;
				
		query = " UPDATE service SET "+
				"	tot_dist		=?,"+
				"	update_id	=?,"+
				"	update_dt	=to_char(sysdate,'YYYYMMDD') "+				
				" WHERE car_mng_id=? AND serv_id=? ";
		
		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
		
			pstmt.setInt   (1, AddUtil.parseInt(bean.getTot_dist()));
			pstmt.setString(2, bean.getUpdate_id());
			pstmt.setString(3, bean.getCar_mng_id());
			pstmt.setString(4, bean.getServ_id());
						
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		}catch(Exception e){
			System.out.println("[CusReg_Database:updateService_g2(ServInfoBean bean)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
			conn.setAutoCommit(true);
               		 if(pstmt != null) pstmt.close();
				
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}
	}
	
	/**
	 * 차량관리번호로 정비순번 조회 2004.7.19.
	 */
	public String getServ_id(String car_mng_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String serv_id = "";

		query = "SELECT NVL(LPAD(MAX(serv_id)+1,6,'0'),'000001') FROM service WHERE car_mng_id=? and serv_id not like 'NN%'";
		
		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				serv_id = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[CusReg_Database:getServ_id(String car_mng_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null)	rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return serv_id;
		}
	}

	/**
    * 자동차 순회정비 스케쥴 삭제 2004.7.19.
    */
	public int deleteScdServ(String car_mng_id, String serv_id){
		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		int result = 0;

		query = "DELETE service WHERE car_mng_id=? AND serv_id=?";
		
		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
			pstmt.setString(2, serv_id);
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		}catch(SQLException e){
			System.out.println("[CusReg_Database:deleteScdServ(String car_mng_id, String serv_id)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
			  conn.setAutoCommit(true);
              		  if(pstmt != null) pstmt.close();
              
			}catch(Exception ignore){}

			closeConnection();	
			return result;		
		}		
		
	}

	/**
	 * 자동차회사,차종(진행중인 계약)으로 주작업 조회 2004.7.21.
	 */
	public Vector getWork_main(String car_mng_id, String wm_nm){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		Vector vt = new Vector();

		query = "SELECT f.wm_id, f.wm_nm "+
				"	FROM car_reg a,cont b,car_etc c,car_nm d, work_main f "+
				"	WHERE a.car_mng_id = b.car_mng_id "+
				"	AND b.rent_mng_id = c.rent_mng_id "+
				"	AND b.rent_l_cd = c.rent_l_cd "+
				"	AND c.car_id = d.car_id "+
				"	AND c.car_seq = d.car_seq "+
				"	AND d.car_comp_id = f.car_comp_id(+) "+
				"	AND d.car_cd = f.code(+) "+
				"	AND nvl(b.use_yn,'Y') = 'Y' "+
				"	AND a.car_mng_id = ? AND f.wm_nm LIKE '%"+wm_nm+"%' ";
		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
			rs = pstmt.executeQuery();
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
		}catch(SQLException e){
			System.out.println("[CusReg_Database:getWork_main(String car_mng_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null)	rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return vt;
		}
	}

	/**
	 * 자동차회사,차종(진행중인 계약)으로 부수 작업 조회 2004.7.22.
	 */
	public Vector getWork_sub(String car_mng_id, String wm_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		Vector vt = new Vector();

		query = "SELECT ws_id, ws_nm "+
				" FROM car_reg a,cont b,car_etc c,car_nm d,work_sub f "+
				" WHERE a.car_mng_id = b.car_mng_id "+
				" AND b.rent_mng_id = c.rent_mng_id "+
				" AND b.rent_l_cd = c.rent_l_cd "+
				" AND c.car_id=d.car_id "+
				" AND c.car_seq = d.car_seq "+
				" AND d.car_comp_id = f.car_comp_id(+) "+
				" AND d.car_cd=f.code(+) "+
				" AND nvl(b.use_yn,'Y') ='Y' "+
				" AND a.car_mng_id=? "+
				" AND f.wm_id = ? ";
		
		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
			pstmt.setString(2, wm_id);
			rs = pstmt.executeQuery();
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
		}catch(SQLException e){
			System.out.println("[CusReg_Database:getWork_sub(String wm_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null)	rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return vt;
		}
	}

	/**
	 * 자동차회사,차종(진행중인 계약)으로 부품 작업 조회 2004.7.22.
	 */
	public Vector getWork_part(String car_mng_id,String wm_id,String ws_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query, subQuery = "";
		Vector vt = new Vector();
		if((!wm_id.equals(""))&&(!ws_id.equals(""))){
			subQuery = " AND wm_id='"+wm_id+"' and ws_id='"+ws_id+"' ";
		}else if((!wm_id.equals(""))&&(ws_id.equals(""))){
			subQuery = " AND wm_id='"+wm_id+"' ";
		}else{
			subQuery = " AND wm_id='"+wm_id+"' and ws_id='"+ws_id+"' ";
		}

		query = "SELECT wp_id, wp_nm "+
				" FROM car_reg a,cont b,car_etc c,car_nm d,work_part f "+
				" WHERE a.car_mng_id = b.car_mng_id "+
				" AND b.rent_mng_id = c.rent_mng_id "+
				" AND b.rent_l_cd = c.rent_l_cd "+
				" AND c.car_id=d.car_id "+
				" AND c.car_seq = d.car_seq "+
				" AND d.car_comp_id = f.car_comp_id(+) "+
				" AND d.car_cd=f.code(+) "+
				" AND nvl(b.use_yn,'Y') ='Y' "+
				" AND a.car_mng_id=? "+subQuery;


		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
			rs = pstmt.executeQuery();
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
		}catch(SQLException e){
			System.out.println("[CusReg_Database:getWork_part(String wm_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null)	rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return vt;
		}
	}

/*----------------자동차 정비부품-------------------------------------------------------*/
	/**
    * 자동차 정비건 견적서 ; 부품,작업 등록 2004.7.26.
    */
	public int insertServItem(Serv_ItemBean bean){

		getConnection();
		PreparedStatement pstmt = null;
		//PreparedStatement pstmt2 = null;
		//PreparedStatement pstmt3 = null;
		//ResultSet rs = null;
		//ResultSet rs2 = null;
		String query,query1 = "";
		int result = 0;
		int seq_no = 0;		
		int chk = 0;
	
		/*
		query  = " INSERT INTO serv_item ("+
				 "               car_mng_id, serv_id, seq_no, item_st, item_id, "+
				 "               item, wk_st, count, price, amt, "+
				 "               labor, bpm, item_cd, reg_id, reg_dt "+
				 " 	           ) VALUES ( "+
				 "               ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,to_char(sysdate,'YYYYMMDD') "+
				 "             )";

		query1 = " SELECT NVL(MAX(seq_no)+1,1) FROM serv_item WHERE car_mng_id=? AND serv_id=?";
		
		//입력체크
		String query2 = "select count(0) from serv_item where car_mng_id=? and serv_id=? and seq_no=?";
		*/

		query  = " INSERT INTO serv_item ("+
				 "               car_mng_id, serv_id, seq_no, item_st, item_id, "+
				 "               item, wk_st, count, price, amt, "+
				 "               labor, bpm, item_cd, reg_id, reg_dt "+
				 " 	           ) "+
				 "	SELECT ?,?,NVL(MAX(seq_no)+1,1),?,?, SUBSTRb(?,1,100),?,?,?,?, ?,?,?,?,to_char(sysdate,'YYYYMMDD') FROM serv_item WHERE car_mng_id=? AND serv_id=?";


		try{
			conn.setAutoCommit(false);

/*
			pstmt2 = conn.prepareStatement(query1);
			pstmt2.setString(1, bean.getCar_mng_id());
			pstmt2.setString(2, bean.getServ_id());
			rs = pstmt2.executeQuery();
			if(rs.next()){
				seq_no = rs.getInt(1);
			}
			rs.close();
			pstmt2.close();

			pstmt3 = conn.prepareStatement(query2);
			pstmt3.setString(1, bean.getCar_mng_id());
			pstmt3.setString(2, bean.getServ_id());
			pstmt3.setInt	(3, seq_no);
	    		rs2 = pstmt3.executeQuery();
			if(rs2.next()){
				chk = rs2.getInt(1);	
			}
			rs2.close();
			pstmt3.close();

			if(seq_no>0 && chk==0){
*/
				pstmt = conn.prepareStatement(query);

				if(bean.getItem_st	().equals("")) bean.setItem_st	("-");
				if(bean.getItem_id	().equals("")) bean.setItem_id	("-");
				if(bean.getItem_cd	().equals("")) bean.setItem_cd	("-");
				if(bean.getWk_st	().equals("")) bean.setWk_st	("-");

				pstmt.setString	(1,  bean.getCar_mng_id	());
				pstmt.setString	(2,  bean.getServ_id	());
//				pstmt.setInt	(3,  seq_no				  );
				pstmt.setString	(3,  bean.getItem_st	());
				pstmt.setString	(4,  bean.getItem_id	());
				pstmt.setString	(5,  bean.getItem		());
				pstmt.setString	(6,  bean.getWk_st		());
				pstmt.setInt	(7,  bean.getCount		());
				pstmt.setInt	(8,  bean.getPrice		());
				pstmt.setInt	(9, bean.getAmt			());
				pstmt.setInt	(10, bean.getLabor		());
				pstmt.setString	(11, bean.getBpm		());
				pstmt.setString	(12, bean.getItem_cd	());
				pstmt.setString	(13, bean.getReg_id		());
				pstmt.setString (14, bean.getCar_mng_id());
				pstmt.setString (15, bean.getServ_id());
				result = pstmt.executeUpdate();			
				pstmt.close();
			
//			}
			conn.commit();		
		
		}catch(Exception e){
			System.out.println("[CusReg_Database:insertServItem(Serv_ItemBean bean)]"+e);

			System.out.println("[bean.getCar_mng_id	()]"+bean.getCar_mng_id	()+"|");
			System.out.println("[bean.getServ_id	()]"+bean.getServ_id	()+"|");
			System.out.println("[seq_no				  ]"+seq_no				  +"|");
			System.out.println("[bean.getItem_st	()]"+bean.getItem_st	()+"|");
			System.out.println("[bean.getItem_id	()]"+bean.getItem_id	()+"|");
			System.out.println("[bean.getItem		()]"+bean.getItem		()+"|");
			System.out.println("[bean.getWk_st		()]"+bean.getWk_st		()+"|");
			System.out.println("[bean.getCount		()]"+bean.getCount		()+"|");
			System.out.println("[bean.getPrice		()]"+bean.getPrice		()+"|");
			System.out.println("[bean.getAmt		()]"+bean.getAmt		()+"|");
			System.out.println("[bean.getLabor		()]"+bean.getLabor		()+"|");
			System.out.println("[bean.getBpm		()]"+bean.getBpm		()+"|");
			System.out.println("[bean.getItem_cd	()]"+bean.getItem_cd	()+"|");
			System.out.println("[bean.getReg_id		()]"+bean.getReg_id		()+"|");
			e.printStackTrace();
			conn.rollback();
			result = 0;	
		}finally{
			try{
				conn.setAutoCommit(true);
				//if(rs != null) rs.close();
				//if(rs2 != null) rs2.close();
			    //   if(pstmt2 != null) pstmt2.close();
			    //    if(pstmt3 != null) pstmt3.close();
			        if(pstmt != null) pstmt.close();
								
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}	
	} 
		

	/**
    * 자동차 정비건 작업 및 부품 조회 2004.7.26.
    */
    public Serv_ItemBean[] getServ_item(String car_mng_id, String serv_id, String sort){
        getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Collection<Serv_ItemBean> col = new ArrayList<Serv_ItemBean>();
        String query = "";
        
		query = "SELECT car_mng_id,serv_id,seq_no,item_st,item_id,item,wk_st,count,price,amt,labor,bpm,item_cd "+
				"  FROM serv_item "+
				" WHERE car_mng_id = ? AND serv_id = ? "+
				" ORDER BY seq_no "+sort;
        try{
         	pstmt = conn.prepareStatement(query);
    		pstmt.setString(1, car_mng_id);
			pstmt.setString(2, serv_id);
    		rs = pstmt.executeQuery();
	        while(rs.next()){                
				col.add(makeServ_ItemBean(rs)); 
	        }
	        rs.close();
			pstmt.close();
        }catch(SQLException e){
			System.out.println("[CusReg_Database:getServ_item(String car_mng_id, String serv_id)]"+e);
			e.printStackTrace();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(Exception ignore){}

			closeConnection();
			return (Serv_ItemBean[])col.toArray(new Serv_ItemBean[0]);
        }        
    }

	/**
	*	정비작업 이나 부품 선택 삭제하기 2004.7.27.
	*/
	public int delServ_item(String car_mng_id, String serv_id, String[] seqs){
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = "DELETE serv_item WHERE car_mng_id=? AND serv_id=? AND seq_no in (";		
		
		for(int i=0 ; i<seqs.length ; i++){
			if(i == (seqs.length -1))	query += seqs[i];
			else						query += seqs[i]+", ";
		}
		query+=")";


		try{
			conn.setAutoCommit(false);
				
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
			pstmt.setString(2, serv_id);
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		
		}catch(Exception e){
			System.out.println("[CusReg_Database:delServ_item(String car_mng_id, String serv_id, String[] seqs)]"+e);
			System.out.println("[car_mng_id		]"+car_mng_id	);
			System.out.println("[serv_id		]"+serv_id		);
			e.printStackTrace();
			conn.rollback();
			result = 0;
		}finally{
			try{
				conn.setAutoCommit(true);
             			if(pstmt != null) pstmt.close();
				
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}
	}
				


	/**
	*	정비작업 이나 부품 전체 삭제하기 2004.7.27.
	*/
	public int delServ_item_all(String car_mng_id, String serv_id){
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = "DELETE serv_item WHERE car_mng_id=? AND serv_id=? ";		

	try{

			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
			pstmt.setString(2, serv_id);
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
		}catch(Exception e){
			System.out.println("[CusReg_Database:delServ_item_all(String car_mng_id, String serv_id)]"+e);
			System.out.println("[car_mng_id		]"+car_mng_id	);
			System.out.println("[serv_id		]"+serv_id		);
			e.printStackTrace();
			conn.rollback();
			result = 0;
		}finally{
			try{
				conn.setAutoCommit(true);
             			if(pstmt != null) pstmt.close();
				
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}
	}


	/**
    * 자동차 정비건 견적서 ; 부품,작업 등록 2004.7.26.
    */
	public int updateServItem(Serv_ItemBean bean){

		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		int result = 0;

		query = "UPDATE serv_item SET item_st=?,item_id=?,item=?,wk_st=?,count=?,price=?,amt=?,labor=?,bpm=?,item_cd=? WHERE car_mng_id=? AND serv_id=? AND seq_no=? ";
				
		try{

			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, bean.getItem_st());
			pstmt.setString(2, bean.getItem_id());
			pstmt.setString(3, bean.getItem());
			pstmt.setString(4, bean.getWk_st());
			pstmt.setInt(5, bean.getCount());
			pstmt.setInt(6, bean.getPrice());
			pstmt.setInt(7, bean.getAmt());
			pstmt.setInt(8, bean.getLabor());
			pstmt.setString(9, bean.getBpm());
			pstmt.setString(10, bean.getItem_cd());
			pstmt.setString(11, bean.getCar_mng_id());
			pstmt.setString(12, bean.getServ_id());
			pstmt.setInt(13, bean.getSeq_no());

			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
		}catch(Exception e){
			System.out.println("[CusReg_Database:updateServItem(Serv_ItemBean bean)]"+e);
			e.printStackTrace();
			conn.rollback();
			result = 0;
		}finally{
			try{
				conn.setAutoCommit(true);
             			if(pstmt != null) pstmt.close();
				
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}
	}
	
		

/*----------------자동차 검사(정밀검사) 등록-------------------------------------------------------*/
    /**
     * 정기검사 등록.2004.8.3.
	 * 2004.01.31. 정기점검일경우 등록증상에 점검유효기간 업데이트.
     */
    public int insertCarMaint(Car_MaintBean bean){
        getConnection();
        PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
        ResultSet rs = null;
        String query, query1, query2 = "";
        String car_mng_id = "";
        int seq_no = 0;
		int count = 0;
		
        query = " INSERT INTO CAR_MAINT(car_mng_id,seq_no,che_kd,che_st_dt,che_end_dt,che_dt,che_no,che_comp,che_amt,che_km,reg_id, reg_dt, che_remark) "+
				" VALUES(?,?,?,replace(?, '-', ''),replace(?, '-', ''),replace(?, '-', ''),?,?,?,?,?,to_char(sysdate,'YYYYMMDD'), ?) ";
		query1 = "SELECT nvl(max(seq_no)+1,1) FROM car_maint WHERE car_mng_id=? ";

		if(bean.getChe_kd().equals("3")){
			query2 = "UPDATE car_reg SET test_st_dt =replace(?,'-', ''), test_end_dt=replace(?, '-', '') , m1_chk = null, update_id = ?, update_dt = sysdate WHERE car_mng_id=? ";
		}else{
			query2 = "UPDATE car_reg SET maint_st_dt =replace(?, '-', ''), maint_end_dt=replace(?, '-', '') , m1_chk = null, update_id = ?, update_dt = sysdate WHERE car_mng_id=? ";
		}
       try{
            conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query2);
			pstmt.setString(1, bean.getMaint_st_dt());
			pstmt.setString(2, bean.getMaint_end_dt());
			pstmt.setString(3, bean.getUpdate_id());
			pstmt.setString(4, bean.getCar_mng_id());
			count = pstmt.executeUpdate();
			pstmt.close();

			if(count>0){
				pstmt2 = conn.prepareStatement(query1);
				pstmt2.setString(1, bean.getCar_mng_id());
				rs = pstmt2.executeQuery();
				while(rs.next()){
					seq_no = rs.getInt(1);
				}
				rs.close();
				pstmt2.close();

				pstmt3 = conn.prepareStatement(query);
				pstmt3.setString(1, bean.getCar_mng_id()		);
				pstmt3.setInt   (2, seq_no						);
				pstmt3.setString(3, bean.getChe_kd().trim()		);
				pstmt3.setString(4, bean.getChe_st_dt().trim()	);
				pstmt3.setString(5, bean.getChe_end_dt().trim()	);
				pstmt3.setString(6, bean.getChe_dt().trim()		);
				pstmt3.setString(7, bean.getChe_no().trim()		);
				pstmt3.setString(8, bean.getChe_comp().trim()	);
				pstmt3.setInt   (9, bean.getChe_amt()			);
				pstmt3.setInt   (10, bean.getChe_km()			);
				pstmt3.setString(11, bean.getReg_id().trim()	);		
				pstmt3.setString(12, bean.getChe_remark().trim()	);				
				count = pstmt3.executeUpdate();
				pstmt3.close();
				if(count>0){		            
		            conn.commit();
				}
			}
			conn.commit();
        }catch(Exception se){
            System.out.println("[CusReg_Database:insertCarMaint)]"+se);	

            System.out.println("[CusReg_Database:bean.getCar_mng_id()		]"+bean.getCar_mng_id()			);	
            System.out.println("[CusReg_Database:seq_no						]"+seq_no						);	
            System.out.println("[CusReg_Database:bean.getChe_kd().trim()	]"+bean.getChe_kd().trim()		);	
            System.out.println("[CusReg_Database:bean.getChe_st_dt().trim()	]"+bean.getChe_st_dt().trim()	);	
            System.out.println("[CusReg_Database:bean.getChe_end_dt().trim()]"+bean.getChe_end_dt().trim()	);	
            System.out.println("[CusReg_Database:bean.getChe_dt().trim()	]"+bean.getChe_dt().trim()		);	
            System.out.println("[CusReg_Database:bean.getChe_no().trim()	]"+bean.getChe_no().trim()		);	
            System.out.println("[CusReg_Database:bean.getChe_comp().trim()	]"+bean.getChe_comp().trim()	);	
            System.out.println("[CusReg_Database:bean.getChe_amt()			]"+bean.getChe_amt()			);	
            System.out.println("[CusReg_Database:bean.getChe_km()			]"+bean.getChe_km()				);	

            try{            
                conn.rollback();
            }catch(SQLException _ignored){}
        }finally{
            try{
                conn.setAutoCommit(true);
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
				if(pstmt2 != null) pstmt2.close();
				if(pstmt3 != null) pstmt3.close();
            }catch(SQLException _ignored){}
            closeConnection();
        }

        return seq_no;
    }

    /**
     * 정기검사 수정. 2003.8.4.
	 * 2004.01.31. 정기점검일경우 등록증상에 점검유효기간 업데이트.
	 */
    public int updateCarMaint(Car_MaintBean bean){
        getConnection();
        PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
        String query, query2 = "";
        int count = 0;
                
        query="UPDATE car_maint SET che_kd=?, che_st_dt=replace(?, '-', ''), che_end_dt=replace(?, '-', ''), che_dt=replace(?, '-', ''), che_no=?, che_comp=?, che_amt=?, che_km=? , reg_id = ? , reg_dt = to_char(sysdate,'YYYYMMdd') , che_remark = ?  WHERE car_mng_id=? AND seq_no=? ";
        if(bean.getChe_kd().equals("3")){
			query2 = "UPDATE car_reg SET test_st_dt =replace(?, '-', ''), test_end_dt=replace(?, '-', '') , m1_chk = null, update_id = ?, update_dt = sysdate WHERE car_mng_id=? ";
		}else{
			query2 = "UPDATE car_reg SET maint_st_dt =replace(?, '-', ''), maint_end_dt=replace(?, '-', '') , m1_chk = null, update_id = ?, update_dt = sysdate WHERE car_mng_id=? ";
		}

	   try{
            conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query2);
			pstmt.setString(1, bean.getMaint_st_dt());
			pstmt.setString(2, bean.getMaint_end_dt());
			pstmt.setString(3, bean.getUpdate_id());
			pstmt.setString(4, bean.getCar_mng_id());
			count = pstmt.executeUpdate();
			pstmt.close();
			if(count>0){
				pstmt2 = conn.prepareStatement(query);
				pstmt2.setString(1, bean.getChe_kd().trim()		);
				pstmt2.setString(2, bean.getChe_st_dt().trim()	);
				pstmt2.setString(3, bean.getChe_end_dt().trim()	);
				pstmt2.setString(4, bean.getChe_dt().trim()		);
				pstmt2.setString(5, bean.getChe_no().trim()		);
				pstmt2.setString(6, bean.getChe_comp().trim()	);
				pstmt2.setInt   (7, bean.getChe_amt()			);				//추가 2004.01.07.
				pstmt2.setInt   (8, bean.getChe_km()				);				//추가 2004.01.13.
				pstmt2.setString(9, bean.getUpdate_id());
				pstmt2.setString(10, bean.getChe_remark().trim()	);
				pstmt2.setString(11, bean.getCar_mng_id().trim()	);
				pstmt2.setInt   (12, bean.getSeq_no()				);
				count = pstmt2.executeUpdate();
				pstmt2.close();
		        if(count>0){					
					conn.commit();
				}
			}
			conn.commit();
        }catch(Exception se){
            System.out.println("[CusReg_Database:updateCarMaint)]"+se);	

            System.out.println("[bean.getChe_kd().trim()		]"+bean.getChe_kd().trim()		);	
            System.out.println("[bean.getChe_st_dt().trim()		]"+bean.getChe_st_dt().trim()	);	
            System.out.println("[bean.getChe_end_dt().trim()	]"+bean.getChe_end_dt().trim()	);	
            System.out.println("[bean.getChe_dt().trim()		]"+bean.getChe_dt().trim()		);	
            System.out.println("[bean.getChe_no().trim()		]"+bean.getChe_no().trim()		);	
            System.out.println("[bean.getChe_comp().trim()		]"+bean.getChe_comp().trim()	);	
            System.out.println("[bean.getChe_amt()				]"+bean.getChe_amt()			);	
            System.out.println("[bean.getChe_km()				]"+bean.getChe_km()				);	
            System.out.println("[bean.getCar_mng_id().trim()	]"+bean.getCar_mng_id().trim()	);	
            System.out.println("[bean.getSeq_no()				]"+bean.getSeq_no()				);	

            try{
                conn.rollback();
            }catch(SQLException _ignored){}
        }finally{
            try{
                conn.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
				if(pstmt2 != null) pstmt2.close();
            }catch(SQLException _ignored){}
            closeConnection();
        }

        return bean.getSeq_no();
    }

	/**
    * 자동차 정비건 작업 및 부품 중복조회
    */
    public int getServ_itemCheck(String car_mng_id, String serv_id, String item, int labor, int amt){
        getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int count = 0;
        String query = "";
        
		query = "SELECT count(0) "+
		"  FROM serv_item "+
		" WHERE car_mng_id = ? AND serv_id = ? AND item = ? AND labor = ? AND amt = ? ";

        try{
            pstmt = conn.prepareStatement(query);
    		pstmt.setString(1, car_mng_id);
			pstmt.setString(2, serv_id);
			pstmt.setString(3, item);
			pstmt.setInt   (4, labor);
			pstmt.setInt   (5, amt);
    		rs = pstmt.executeQuery();

	        if(rs.next()){                
				count = rs.getInt(1);
	        }

			rs.close();
			pstmt.close();

        }catch(SQLException e){
		 System.out.println("[CusReg_Database:getServ_itemCheck()]"+e);
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

	/**
	*	 정비등록
	*/
	public int insertService(String car_mng_id, String serv_id, String accid_id, String rent_mng_id, String rent_l_cd, String reg_id){
		getConnection();
		PreparedStatement pstmt = null;
		String query, query1, query2 = "";
		int result = 0;
		
		query = "INSERT INTO service(car_mng_id, serv_id, accid_id, rent_mng_id, rent_l_cd, reg_id, reg_dt ) VALUES(?,?,?,?,?,?,to_char(sysdate,'YYYYMMDD')) ";
		
		try{

			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id	);
			pstmt.setString(2, serv_id		);
			pstmt.setString(3, accid_id		);
			pstmt.setString(4, rent_mng_id	);
			pstmt.setString(5, rent_l_cd	);
			pstmt.setString(6, reg_id		);
			result = pstmt.executeUpdate();

			pstmt.close();
			conn.commit();
		}catch(Exception e){
			System.out.println("[CusReg_Database:insertService()]"+e);
			System.out.println("[car_mng_id		]"+car_mng_id	);
			System.out.println("[serv_id		]"+serv_id		);
			System.out.println("[accid_id		]"+accid_id		);
			System.out.println("[rent_mng_id	]"+rent_mng_id	);
			System.out.println("[rent_l_cd		]"+rent_l_cd	);
			System.out.println("[reg_id			]"+reg_id		);
			e.printStackTrace();
			conn.rollback();
			result = 0;
		}finally{
			try{
				conn.setAutoCommit(true);
             			if(pstmt != null) pstmt.close();
				
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}
	}
	
	// 협력업체 결재처리 - 타이어휠타운, 스피트메이트등 - 5 
	public int updateServiceSet(String car_mng_id, String serv_id, String update_id, String set_dt, String req_code ){
		getConnection();
		PreparedStatement pstmt = null;
		String query, query1, query2 = "";
		int result = 0;
		
		query = "update service set set_dt  = replace(?, '-', '') ,  jung_st = '1', update_id = ? , update_dt = to_char(sysdate,'YYYYMMdd' ) , req_code = ?  WHERE car_mng_id=? AND serv_id=?";
		
		try{
			conn.setAutoCommit(false);				
			
			pstmt = conn.prepareStatement(query);	
			pstmt.setString(1, set_dt);	
			pstmt.setString(2, update_id);
			pstmt.setString(3, req_code);
			pstmt.setString(4, car_mng_id);
			pstmt.setString(5,  serv_id);
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		}catch(SQLException e){
			System.out.println("[CusReg_Database:updateServiceSet(String car_mng_id, String serv_id, String update_id)]"+e);
			e.printStackTrace();
			conn.rollback();
			result = 0;
		}finally{
			try{
			    conn.setAutoCommit(true);
              		  if(pstmt != null) pstmt.close();
            
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}
	}

		// 협력업체 결재처리 - 타이어휠타운, 스피트메이트등 
	public int updateServiceSet(String id, String gubun2, String st_dt , String end_dt, String update_id, String set_dt , String req_code ){
		getConnection();
		PreparedStatement pstmt = null;
		String query, subquery = "";
		int result = 0;
		
		
		if(gubun2.equals("1"))			subquery = " and serv_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))		subquery = " and serv_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%'";
		else if(gubun2.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	subquery = " and serv_dt like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) subquery = " and serv_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}
         
      	String id2 = "";

		if(id.equals("000256")){
			id2="008634";
		}
		else if(id.equals("000148")){
			id2="000092";
		}
		else if(id.equals("000156")){
			id2="006470";
		}
		      		               		
               		
		query = "update service set  set_dt  = replace(?, '-', '') ,  jung_st = '1', update_id = ? , update_dt = to_char(sysdate,'YYYYMMdd' ) , req_code = ?  "+ 
					  "       WHERE off_id=? AND jung_st is null and  set_dt is null  " + subquery + "" ;
		
		try{
			conn.setAutoCommit(false);				
			
			pstmt = conn.prepareStatement(query);	
			pstmt.setString(1, set_dt);	
			pstmt.setString(2, update_id);
			pstmt.setString(3, req_code);
			pstmt.setString(4, id2);
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		}catch(SQLException e){
			System.out.println("[CusReg_Database:updateServiceSet(String off_id, String gubun2, String st_dt , String end_dt, String update_id, String set_dt , String reg_code )]"+e);
			e.printStackTrace();
			conn.rollback();
			result = 0;
		}finally{
			try{
			    conn.setAutoCommit(true);
              		  if(pstmt != null) pstmt.close();
            
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}
	}
		
	
	// 협력업체 결재처리 - 타이어휠타운, 스피트메이트등 - 5  (청산일은 set_dt 처리 - 20211022) - 정산일자 변경
		public boolean updateServiceJungDt(String req_code, String update_id, String jung_dt ){
				getConnection();
				PreparedStatement pstmt = null;
				String query, query1, query2 = "";
				boolean flag = true;
				
				query = "update service set set_dt  = replace(?, '-', '') , update_id = ? , update_dt = to_char(sysdate,'YYYYMMdd' )  WHERE req_code = ? ";
				
				try{
					conn.setAutoCommit(false);				
					
					pstmt = conn.prepareStatement(query);	
					pstmt.setString(1, jung_dt);	
					pstmt.setString(2, update_id);
					pstmt.setString(3, req_code);				
					pstmt.executeUpdate();			
					pstmt.close();

					conn.commit();
				}catch(SQLException e){
					System.out.println("[CusReg_Database:updateServiceJungDt(String req_code, String update_id, String jung_dt)]"+e);
					e.printStackTrace();
					flag = false;
					conn.rollback();
				
				}finally{
					try{
					    conn.setAutoCommit(true);
		        	    if(pstmt != null) pstmt.close();
		            
					}catch(Exception ignore){}

					closeConnection();
					return flag;
				}
		}
		
			
	/**
	*	 미등록 정비 삭제
	*/
	public int deleteServiceNItem(){		
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		String query, query0, query1, query2 = "";
		String car_mng_id = "";
		int result = 0;
		int count = 0;
		
		query0 = " select count(0)            from service where reg_dt < to_char(sysdate,'YYYYMMDD') and serv_dt is null and serv_st is null and next_serv_dt is null and off_id is null and checker is null and sac_yn is null ";

		query  = " select car_mng_id, serv_id from service where reg_dt < to_char(sysdate,'YYYYMMDD') and serv_dt is null and serv_st is null and next_serv_dt is null and off_id is null and checker is null and sac_yn is null ";

		query1 = " delete from serv_item where (car_mng_id, serv_id) in ("+query+")";
		query2 = " delete from service   where (car_mng_id, serv_id) in ("+query+")";
		
		try{

			conn.setAutoCommit(false);


            pstmt = conn.prepareStatement(query0);
    		rs = pstmt.executeQuery();
            if(rs.next()){                
				count = rs.getInt(1);
            }
			rs.close();
			pstmt.close();

			if(count >0){
				pstmt1 = conn.prepareStatement(query1);
				pstmt1.executeUpdate();
				pstmt1.close();

				pstmt2 = conn.prepareStatement(query2);
				pstmt2.executeUpdate();
				pstmt2.close();

				result = 1;
			}

			conn.commit();
		}catch(Exception e){
			System.out.println("[CusReg_Database:deleteServiceNItem()]"+e);
			System.out.println("[CusReg_Database:deleteServiceNItem()]"+count);
			System.out.println("[CusReg_Database:deleteServiceNItem()]"+query1);
			System.out.println("[CusReg_Database:deleteServiceNItem()]"+query2);
			e.printStackTrace();
			conn.rollback();
			result = 0;
		}finally{
			try{
				conn.setAutoCommit(true);
		        if(rs != null)     rs.close();
		        if(pstmt != null)  pstmt.close();
				if(pstmt1 != null) pstmt1.close();
             	if(pstmt2 != null) pstmt2.close();
				
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}
	}
	
	/**
	 * 차량관리번호, 서비스번호로 정비업체조회 - 명진 정비비 관련 .
	 */
	public String getServOff_id(String car_mng_id, String serv_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String off_id = "";

		query = "SELECT off_id FROM service WHERE car_mng_id=? and serv_id = ? ";
		
		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
			pstmt.setString(2, serv_id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				off_id = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[CusReg_Database:getServOff_id]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null)	rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return off_id;
		}
	}

	//출금원장에서 조회하기
	public ServInfoBean getServInfoPay(String car_mng_id, String serv_dt, String off_id, int rep_amt){
		getConnection();
		ServInfoBean servinfo = new ServInfoBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = "SELECT a.car_mng_id CAR_MNG_ID, a.serv_id SERV_ID, a.accid_id ACCID_ID, a.rent_mng_id RENT_MNG_ID, a.rent_l_cd RENT_L_CD, a.off_id OFF_ID, b.off_nm OFF_NM, " 
			    + " nvl2(a.serv_dt,substr(a.serv_dt,1,4)||'-'||substr(a.serv_dt,5,2)||'-'||substr(a.serv_dt,7,2),'') SERV_DT, a.serv_st SERV_ST, a.checker CHECKER, a.tot_dist TOT_DIST, a.rep_nm REP_NM, a.rep_tel REP_TEL, a.rep_m_tel REP_M_TEL, a.rep_amt REP_AMT, a.sup_amt SUP_AMT, a.add_amt ADD_AMT, "
			    + " a.dc DC, a.tot_amt TOT_AMT, nvl2(a.sup_dt,substr(a.sup_dt,1,4)||'-'||substr(a.sup_dt,5,2)||'-'||substr(a.sup_dt,7,2),'') SUP_DT, nvl2(a.set_dt,substr(a.set_dt,1,4)||'-'||substr(a.set_dt,5,2)||'-'||substr(a.set_dt,7,2),'') SET_DT, a.bank BANK, a.acc_no ACC_NO, a.acc_nm ACC_NM, a.rep_item REP_ITEM, a.rep_cont REP_CONT, "
			    + " nvl2(a.cust_plan_dt,substr(a.cust_plan_dt,1,4)||'-'||substr(a.cust_plan_dt,5,2)||'-'||substr(a.cust_plan_dt,7,2),'') CUST_PLAN_DT, a.cust_amt CUST_AMT, a.cust_agnt CUST_AGNT, a.accid_dt ACCID_DT, a.bill_doc_yn, a.bill_mon, a.serv_jc SERV_JC, a.cust_serv_dt CUST_SERV_DT, a.next_serv_dt NEXT_SERV_DT, a.next_rep_cont NEXT_REP_CONT, a.spdchk SPDCHK, " 
			    + " a.ipgoza IPGOZA, a.ipgodt IPGODT, a.chulgoza CHULGOZA, a.chulgodt CHULGODT, a.spdchk_dt SPDCHK_DT, a.checker_st CHECKER_ST, a.cust_act_dt, a.cust_nm, a.cust_tel, a.cust_rel, a.reg_id, a.update_id, a.reg_dt, a.update_dt, "
			    + " a.r_labor R_LABOR , a.r_amt R_AMT, a.r_dc R_DC, a.r_j_amt R_J_AMT, decode(a.jung_st, '0', '', a.jung_st) JUNG_ST , a.r_dc_per R_DC_PER, a.scan_file, a.estimate_num , a.sh_amt,  " 
				+ " a.call_t_nm CALL_T_NM, a.call_t_tel CALL_T_TEL, a.sac_yn , a.file_path , '' settle_st  "
				+ "FROM service a, serv_off b "
				+ "WHERE a.car_mng_id= ? and a.serv_dt=replace(?,'-','') and a.off_id=? and a.rep_amt=?"
				+ "AND a.off_id=b.off_id(+)";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id	);
			pstmt.setString(2, serv_dt		);
			pstmt.setString(3, off_id		);
			pstmt.setInt   (4, rep_amt		);
			rs = pstmt.executeQuery();
			while(rs.next()){
				servinfo = makeServInfoBean(rs);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[CusReg_Database:getServInfoPay(String car_mng_id, String serv_dt, String off_id, int rep_amt)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return servinfo;
		}		
	}

	//출금원장에서 조회하기
	public ServInfoBean getServInfoPay(String car_mng_id, String serv_dt, String off_id, int rep_amt, String rep_cont){
		getConnection();
		ServInfoBean servinfo = new ServInfoBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = "SELECT a.car_mng_id CAR_MNG_ID, a.serv_id SERV_ID, a.accid_id ACCID_ID, a.rent_mng_id RENT_MNG_ID, a.rent_l_cd RENT_L_CD, a.off_id OFF_ID, b.off_nm OFF_NM, " 
			    + " nvl2(a.serv_dt,substr(a.serv_dt,1,4)||'-'||substr(a.serv_dt,5,2)||'-'||substr(a.serv_dt,7,2),'') SERV_DT, a.serv_st SERV_ST, a.checker CHECKER, a.tot_dist TOT_DIST, a.rep_nm REP_NM, a.rep_tel REP_TEL, a.rep_m_tel REP_M_TEL, a.rep_amt REP_AMT, a.sup_amt SUP_AMT, a.add_amt ADD_AMT, "
			    + "  a.dc DC, a.tot_amt TOT_AMT, nvl2(a.sup_dt,substr(a.sup_dt,1,4)||'-'||substr(a.sup_dt,5,2)||'-'||substr(a.sup_dt,7,2),'') SUP_DT, nvl2(a.set_dt,substr(a.set_dt,1,4)||'-'||substr(a.set_dt,5,2)||'-'||substr(a.set_dt,7,2),'') SET_DT, a.bank BANK, a.acc_no ACC_NO, a.acc_nm ACC_NM, a.rep_item REP_ITEM, a.rep_cont REP_CONT, "
			    + " nvl2(a.cust_plan_dt,substr(a.cust_plan_dt,1,4)||'-'||substr(a.cust_plan_dt,5,2)||'-'||substr(a.cust_plan_dt,7,2),'') CUST_PLAN_DT, a.cust_amt CUST_AMT, a.cust_agnt CUST_AGNT, a.accid_dt ACCID_DT, a.bill_doc_yn, a.bill_mon, a.serv_jc SERV_JC, a.cust_serv_dt CUST_SERV_DT, a.next_serv_dt NEXT_SERV_DT, a.next_rep_cont NEXT_REP_CONT, a.spdchk SPDCHK, " 
			    + " a.ipgoza IPGOZA, a.ipgodt IPGODT, a.chulgoza CHULGOZA, a.chulgodt CHULGODT, a.spdchk_dt SPDCHK_DT, a.checker_st CHECKER_ST, a.cust_act_dt, a.cust_nm, a.cust_tel, a.cust_rel, a.reg_id, a.update_id, a.reg_dt, a.update_dt, "
			    + " a.r_labor R_LABOR , a.r_amt R_AMT, a.r_dc R_DC, a.r_j_amt R_J_AMT, decode(a.jung_st, '0', '', a.jung_st) JUNG_ST , a.r_dc_per R_DC_PER, a.scan_file, a.estimate_num , a.sh_amt,  " 
				+ " a.call_t_nm CALL_T_NM, a.call_t_tel CALL_T_TEL, a.sac_yn, a.bus_id2 , a.file_path, '' settle_st "
				+ "FROM service a, serv_off b "
				+ "WHERE a.car_mng_id= ? and a.serv_dt=replace(?,'-','') and a.off_id=? and a.rep_amt=? and a.rep_cont=?"
				+ "AND a.off_id=b.off_id(+)";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id	);
			pstmt.setString(2, serv_dt		);
			pstmt.setString(3, off_id		);
			pstmt.setInt   (4, rep_amt		);
			pstmt.setString(5, rep_cont		);
			rs = pstmt.executeQuery();
			while(rs.next()){
				servinfo = makeServInfoBean(rs);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[CusReg_Database:getServInfoPay(String car_mng_id, String serv_dt, String off_id, int rep_amt)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return servinfo;
		}		
	}

	/**
	 * 차량관리번호, 서비스번호로 정비업체조회 - 명진 정비비 관련 .
	 */
	public int getRentContChk(String car_mng_id, String serv_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		int res_cnt = 0;

		query = "SELECT count(0) FROM rent_cont WHERE sub_c_id=? and serv_id = ? ";
		
		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
			pstmt.setString(2, serv_id);
			rs = pstmt.executeQuery();
			if(rs.next()){
				res_cnt = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[CusReg_Database:getRentContChk]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null)	rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return res_cnt;
		}
	}

	/**
	 * 정비미청구현황
	 */
	public Vector getServSettleList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String st_dt, String end_dt, String sort){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		Vector vt = new Vector();

		query = " select   a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.serv_id, a.accid_id, d.client_id, \n"+
				"        a.serv_dt, a.tot_dist, a.serv_st, \n"+
				"        decode(a.serv_st,'1','순회점검','2','일반정비','3','보증정비','7','재리스정비','4','운행자차','5','사고자차', '12', '해지정비','13','자차') serv_st_nm, \n"+
				"        a.r_labor, a.r_amt, a.rep_amt, \n"+
				"        b.off_nm, d.firm_nm, e.car_no, e.car_nm, e.car_num, g.user_nm, \n"+
				"        p1.p_st3 pay_st1, \n"+
				"        p2.p_st3 pay_st2, \n"+
				"        decode(p3.item_code,'','','법인카드') pay_st3,  \n"+
				"        decode(p4.j_seq,'','',a.jung_st||'회차') pay_st4 \n"+
				" from   service a, serv_off b, cont c, client d, car_reg e, \n"+
				"        (select * from doc_settle where doc_st='41') f, \n"+
				"        users g, BRANCH g2,\n"+
				"        /*출금조회*/(select * from pay_item where p_gubun='11') p1, \n"+
				"        /*출금직접*/(select * from pay_item where p_gubun='99' and acct_code in ('45700','45600') and p_cd5 is not null) p2, \n"+
				"        /*법인카드*/(select * from card_doc_item) p3, \n"+
				"        /*정비정산*/(select a.*, a.j_yy||a.j_mm yymm from mj_jungsan a where a.j_g_amt>0 and a.j_yy||a.j_mm > '200912') p4 \n"+
				" where  a.serv_dt >= '20100101' \n"+
				"        and a.off_id=b.off_id \n"+
				"        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd  and c.car_st <> '4' \n"+
				"        and c.client_id=d.client_id \n"+
				"        and a.car_mng_id=e.car_mng_id \n"+
				"        and a.car_mng_id||a.serv_id = f.doc_id(+) \n"+
				"        and a.checker=g.user_id \n"+
				"        and g.br_id=g2.br_id \n"+
				"        and a.car_mng_id=p1.p_cd1(+) and a.serv_id=p1.p_cd2(+)  \n"+
				"        and a.car_mng_id=p2.p_cd3(+) and a.serv_id=p2.p_cd5(+)  \n"+
				"        and a.car_mng_id=p3.item_code(+) and a.serv_id=p3.serv_id(+)  \n"+
				"        and a.off_id=p4.j_acct(+) and a.jung_st=p4.j_seq(+) and substr(a.set_dt,1,6)=p4.yymm(+)  \n"+
				"        and f.doc_no is null \n"+
				"        and decode(p1.p_cd2,'',0,1)+decode(p2.p_cd5,'',0,1)+decode(p3.serv_id,'',0,1)+decode(p4.j_seq,'',0,1)=0 \n"+
				"        and a.set_dt is null \n"+
				"        and a.rep_amt <>0 \n"+
				" ";

		String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";

		if(gubun3.equals("1")){
			dt1		= "substr(a.serv_dt,1,6)";
			dt2		= "a.serv_dt";
		}else if(gubun3.equals("2")){
			dt1		= "substr(a.ipgodt,1,6)";
			dt2		= "a.ipgodt";
		}else if(gubun3.equals("3")){
			dt1		= "substr(a.chulgodt,1,6)";
			dt2		= "a.chulgodt";
		}else if(gubun3.equals("4")){
			dt1		= "substr(a.reg_dt,1,6)";
			dt2		= "a.reg_dt";
		}

		if(gubun2.equals("1"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))		query += " and "+dt2+" like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun2.equals("4"))		query += " and "+dt2+" like to_char(sysdate+1,'YYYYMMDD')||'%'";
		else if(gubun2.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		if(!gubun1.equals(""))	query += " and j.off_nm like '%"+gubun1+"%'";

		if(s_kd.equals("1"))	what = "upper(nvl(g.br_id||g2.br_nm, ' '))";	
		if(s_kd.equals("2"))	what = "upper(nvl(g.user_nm, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(e.car_nm, ' '))";	
		if(s_kd.equals("4"))	what = "upper(nvl(e.car_num, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(d.firm_nm, ' '))";
		if(s_kd.equals("6"))	what = "upper(nvl(e.car_no, ' '))";	
			
		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		if(sort.equals("1"))	query += " order by b.off_nm, decode(g.br_id,'S1',1,'B1',2,'D1')";	
		if(sort.equals("2"))	query += " order by b.off_nm, g.user_nm";	
		if(sort.equals("3"))	query += " order by b.off_nm, e.car_nm";	
		if(sort.equals("4"))	query += " order by b.off_nm, e.car_num";	
		if(sort.equals("5"))	query += " order by b.off_nm, d.firm_nm";
		if(sort.equals("6"))	query += " order by b.off_nm, a.reg_dt";	
		if(sort.equals("7"))	query += " order by b.off_nm, a.serv_dt";	

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
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
		}catch(SQLException e){
			System.out.println("[CusReg_Database:getServSettleList()]"+e);
			System.out.println("[CusReg_Database:getServSettleList()]"+query);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null)	rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return vt;
		}
	}

	/**
	 * 정비미청구현황
	 */
	public Vector getServConfList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String st_dt, String end_dt, String sort){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		Vector vt = new Vector();

		query = " select  a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.serv_id, a.accid_id, d.client_id, \n"+
				"        a.serv_dt, a.tot_dist, a.serv_st, \n"+
				"        decode(a.serv_st,'1','순회점검','2','일반정비','3','보증정비','7','재리스정비','4','운행자차','5','사고자차', '12', '해지정비','13','자차') serv_st_nm, \n"+
				"        a.r_labor, nvl(a.r_j_amt, a.r_amt) r_amt, a.rep_amt, \n"+
				"        b.off_nm, d.firm_nm, e.car_no, e.car_nm, e.car_num, g.user_nm, \n"+
				"        p1.p_st3 pay_st1, p1.p_pay_dt pay_dt1, p1.reqseq||p1.i_seq pay_id1, \n"+
				"        p2.p_st3 pay_st2, p2.p_pay_dt pay_dt2, p2.reqseq||p2.i_seq pay_id2, \n"+
				"        decode(p3.item_code,'','','법인카드') pay_st3, p3.buy_dt pay_dt3, p3.cardno||p3.buy_id pay_id3, \n"+
				"        decode(p4.j_seq,'','',a.jung_st||'회차') pay_st4, p4.pay_dt pay_dt4, \n"+
				"        f.user_id1, to_char(f.user_dt1,'YYYYMMDD') user_dt1, g3.user_nm as user_nm1 "+
				" from   service a, serv_off b, cont c, client d, car_reg e, \n"+
				"        (select * from doc_settle where doc_st='41') f, \n"+
				"        users g, BRANCH g2, users g3,\n"+
				"        /*출금조회*/(select a.*, b.p_pay_dt from pay_item a, pay b where a.p_gubun='11' and a.reqseq=b.reqseq) p1, \n"+
				"        /*출금직접*/(select a.*, b.p_pay_dt from pay_item a, pay b where a.p_gubun='99' and a.reqseq=b.reqseq and a.acct_code in ('45700','45600') and a.p_cd5 is not null) p2, \n"+
				"        /*법인카드*/(select a.*, b.buy_dt from card_doc_item a, card_doc b where a.cardno=b.cardno and a.buy_id=b.buy_id) p3, \n"+
				"        /*정비정산*/(select a.*, a.j_yy||a.j_mm yymm from mj_jungsan a where a.j_g_amt>0 and a.j_yy||a.j_mm > '200912') p4 \n"+
				" where  a.serv_dt >= '20100101' \n"+
				"        and a.off_id=b.off_id \n"+
				"        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and c.car_st <> '4' \n"+
				"        and c.client_id=d.client_id \n"+
				"        and a.car_mng_id=e.car_mng_id \n"+
				"        and a.car_mng_id||a.serv_id = f.doc_id(+) \n"+
				"        and a.checker=g.user_id \n"+
				"        and g.br_id=g2.br_id \n"+
				"        and f.user_id1=g3.user_id(+) \n"+
				"        and a.car_mng_id=p1.p_cd1(+) and a.serv_id=p1.p_cd2(+)  \n"+
				"        and a.car_mng_id=p2.p_cd3(+) and a.serv_id=p2.p_cd5(+)  \n"+
				"        and a.car_mng_id=p3.item_code(+) and a.serv_id=p3.serv_id(+)  \n"+
				"        and a.off_id=p4.j_acct(+) and a.jung_st=p4.j_seq(+) and substr(a.set_dt,1,6)=p4.yymm(+)  \n"+
//				"        and ( decode(p1.p_cd2,'',0,1)+decode(p2.p_cd5,'',0,1)+decode(p3.serv_id,'',0,1)+decode(p4.j_seq,'',0,1)>0 or  ) \n"+
				"        and a.rep_amt <>0 \n"+
				"        and f.user_dt2 is null \n"+
				" ";

		String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";

		if(gubun3.equals("1")){
			dt1		= "substr(a.serv_dt,1,6)";
			dt2		= "a.serv_dt";
		}else if(gubun3.equals("2")){
			dt1		= "substr(a.ipgodt,1,6)";
			dt2		= "a.ipgodt";
		}else if(gubun3.equals("3")){
			dt1		= "substr(a.chulgodt,1,6)";
			dt2		= "a.chulgodt";
		}else if(gubun3.equals("4")){
			dt1		= "substr(a.reg_dt,1,6)";
			dt2		= "a.reg_dt";
		}

		if(gubun2.equals("1"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))		query += " and "+dt2+" like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun2.equals("4"))		query += " and "+dt2+" like to_char(sysdate+1,'YYYYMMDD')||'%'";
		else if(gubun2.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		if(!gubun1.equals(""))	query += " and j.off_nm like '%"+gubun1+"%'";

		if(s_kd.equals("1"))	what = "upper(nvl(g.br_id||g2.br_nm, ' '))";	
		if(s_kd.equals("2"))	what = "upper(nvl(g.user_nm, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(e.car_nm, ' '))";	
		if(s_kd.equals("4"))	what = "upper(nvl(e.car_num, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(d.firm_nm, ' '))";
		if(s_kd.equals("6"))	what = "upper(nvl(e.car_no, ' '))";	
			
		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		if(sort.equals("1"))	query += " order by j.off_nm, decode(g.br_id,'S1',1,'B1',2,'D1')";	
		if(sort.equals("2"))	query += " order by j.off_nm, g.user_nm";	
		if(sort.equals("3"))	query += " order by j.off_nm, e.car_nm";	
		if(sort.equals("4"))	query += " order by j.off_nm, e.car_num";	
		if(sort.equals("5"))	query += " order by j.off_nm, d.firm_nm";
		if(sort.equals("6"))	query += " order by j.off_nm, a.reg_dt";	
		if(sort.equals("7"))	query += " order by j.off_nm, a.serv_dt";	



		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
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

		}catch(SQLException e){
			System.out.println("[CusReg_Database:getServConfList()]"+e);
			System.out.println("[CusReg_Database:getServConfList()]"+query);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null)	rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return vt;
		}
	}

	/**
	 * 정비미청구현황
	 */
	public Vector getServReqList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String st_dt, String end_dt, String sort){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		Vector vt = new Vector();

		query = " select  a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.serv_id, a.accid_id, d.client_id, \n"+
				"        a.serv_dt, a.tot_dist, a.serv_st, \n"+
				"        decode(a.serv_st,'1','순회점검','2','일반정비','3','보증정비','7','재리스정비','4','운행자차','5','사고자차', '12', '해지정비','13','자차') serv_st_nm, \n"+
				"        a.r_labor, a.r_amt, a.rep_amt, \n"+
				"        b.off_nm, d.firm_nm, e.car_no, e.car_nm, e.car_num, g.user_nm, \n"+
				"        p1.p_st3 pay_st1, p1.p_pay_dt pay_dt1, p1.reqseq||p1.i_seq pay_id1, \n"+
				"        p2.p_st3 pay_st2, p2.p_pay_dt pay_dt2, p2.reqseq||p2.i_seq pay_id2, \n"+
				"        decode(p3.item_code,'','','법인카드') pay_st3, p3.buy_dt pay_dt3, p3.cardno||p3.buy_id pay_id3, \n"+
				"        decode(p4.j_seq,'','',a.jung_st||'회차') pay_st4, p4.pay_dt pay_dt4, \n"+
				"        f.user_id1, to_char(f.user_dt1,'YYYYMMDD') user_dt1, g3.user_nm as user_nm1, "+
				"        f.user_id2, to_char(f.user_dt2,'YYYYMMDD') user_dt2, g4.user_nm as user_nm2 "+
				" from   service a, serv_off b, cont c, client d, car_reg e, \n"+
				"        (select * from doc_settle where doc_st='41') f, \n"+
				"        users g, BRANCH g2, users g3, users g4,\n"+
				"        /*출금조회*/(select a.*, b.p_pay_dt from pay_item a, pay b where a.p_gubun='11' and a.reqseq=b.reqseq) p1, \n"+
				"        /*출금직접*/(select a.*, b.p_pay_dt from pay_item a, pay b where a.p_gubun='99' and a.reqseq=b.reqseq and a.acct_code in ('45700','45600') and a.p_cd5 is not null) p2, \n"+
				"        /*법인카드*/(select a.*, b.buy_dt from card_doc_item a, card_doc b where a.cardno=b.cardno and a.buy_id=b.buy_id) p3, \n"+
				"        /*정비정산*/(select a.*, a.j_yy||a.j_mm yymm from mj_jungsan a where a.j_g_amt>0 and a.j_yy||a.j_mm > '200912') p4 \n"+
				" where  a.serv_dt >= '20100101' \n"+
				"        and a.off_id=b.off_id \n"+
				"        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and c.car_st<> '4' \n"+
				"        and c.client_id=d.client_id \n"+
				"        and a.car_mng_id=e.car_mng_id \n"+
				"        and a.car_mng_id||a.serv_id = f.doc_id(+) \n"+
				"        and a.checker=g.user_id \n"+
				"        and g.br_id=g2.br_id \n"+
				"        and f.user_id1=g3.user_id(+) \n"+
				"        and f.user_id2=g4.user_id(+) \n"+
				"        and a.car_mng_id=p1.p_cd1(+) and a.serv_id=p1.p_cd2(+)  \n"+
				"        and a.car_mng_id=p2.p_cd3(+) and a.serv_id=p2.p_cd5(+)  \n"+
				"        and a.car_mng_id=p3.item_code(+) and a.serv_id=p3.serv_id(+)  \n"+
				"        and a.off_id=p4.j_acct(+) and a.jung_st=p4.j_seq(+) and substr(a.set_dt,1,6)=p4.yymm(+)  \n"+
//				"        and ( decode(p1.p_cd2,'',0,1)+decode(p2.p_cd5,'',0,1)+decode(p3.serv_id,'',0,1)+decode(p4.j_seq,'',0,1)>0 or  ) \n"+
				"        and a.rep_amt <>0 \n"+
				"        and f.user_dt3 is null \n"+
				" ";

		String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";

		if(gubun3.equals("1")){
			dt1		= "substr(a.serv_dt,1,6)";
			dt2		= "a.serv_dt";
		}else if(gubun3.equals("2")){
			dt1		= "substr(a.ipgodt,1,6)";
			dt2		= "a.ipgodt";
		}else if(gubun3.equals("3")){
			dt1		= "substr(a.chulgodt,1,6)";
			dt2		= "a.chulgodt";
		}else if(gubun3.equals("4")){
			dt1		= "substr(a.reg_dt,1,6)";
			dt2		= "a.reg_dt";
		}

		if(gubun2.equals("1"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("4"))		query += " and "+dt2+" = to_char(sysdate+1,'YYYYMMDD')";
		else if(gubun2.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		if(!gubun1.equals(""))	query += " and j.off_nm like '%"+gubun1+"%'";

		if(s_kd.equals("1"))	what = "upper(nvl(g.br_id||g2.br_nm, ' '))";	
		if(s_kd.equals("2"))	what = "upper(nvl(g.user_nm, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(e.car_nm, ' '))";	
		if(s_kd.equals("4"))	what = "upper(nvl(e.car_num, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(d.firm_nm, ' '))";
		if(s_kd.equals("6"))	what = "upper(nvl(e.car_no, ' '))";	
			
		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		if(sort.equals("1"))	query += " order by j.off_nm, decode(g.br_id,'S1',1,'B1',2,'D1')";	
		if(sort.equals("2"))	query += " order by j.off_nm, g.user_nm";	
		if(sort.equals("3"))	query += " order by j.off_nm, e.car_nm";	
		if(sort.equals("4"))	query += " order by j.off_nm, e.car_num";	
		if(sort.equals("5"))	query += " order by j.off_nm, d.firm_nm";
		if(sort.equals("6"))	query += " order by j.off_nm, a.reg_dt";	
		if(sort.equals("7"))	query += " order by j.off_nm, a.serv_dt";	

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
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

		}catch(SQLException e){
			System.out.println("[CusReg_Database:getServReqList()]"+e);
			System.out.println("[CusReg_Database:getServReqList()]"+query);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null)	rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return vt;
		}
	}


	/**
	 * 정비미청구현황 
	 */
	public Vector getServConfList(String m_gubun, String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String st_dt, String end_dt, String sort ){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		Vector vt = new Vector();

		query = " select a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.serv_id, a.accid_id, d.client_id, a.set_dt , a.jung_st ,  \n"+
				"        a.serv_dt, a.tot_dist, a.serv_st, \n"+
				"        decode(a.serv_st,'1','순회점검','2','일반정비','3','보증정비','7','재리스정비','4','운행자차','5','사고자차', '12', '해지정비','13','자차') serv_st_nm, \n"+
				"        a.r_labor, nvl(a.r_j_amt, a.r_amt) r_amt, a.sup_amt, a.add_amt,  a.rep_amt, \n"+
				"        b.off_nm, d.firm_nm, e.car_no, e.car_nm, e.car_num, g.user_nm, decode(fe.rent_way,'1','일반식','2','맞춤식','3','기본식') rent_way, \n"+
				"        p1.p_st3 pay_st1, p1.p_pay_dt pay_dt1, p1.reqseq||p1.i_seq pay_id1, \n"+
				"        p2.p_st3 pay_st2, p2.p_pay_dt pay_dt2, p2.reqseq||p2.i_seq pay_id2, \n"+
				"        decode(p3.item_code,'','','법인카드') pay_st3, p3.buy_dt pay_dt3, p3.cardno||p3.buy_id pay_id3, \n"+
				"        decode(p4.j_seq,'','',a.jung_st||'회차') pay_st4, p4.pay_dt pay_dt4, \n"+
				"        f.user_id1, to_char(f.user_dt1,'YYYYMMDD') user_dt1, g3.user_nm as user_nm1, "+
				"        f.user_id2, to_char(f.user_dt2,'YYYYMMDD') user_dt2, g4.user_nm as user_nm2, "+
				"        f.user_id3, to_char(f.user_dt3,'YYYYMMDD') user_dt3, g5.user_nm as user_nm3, "+
				"        f.user_id4, to_char(f.user_dt4,'YYYYMMDD') user_dt4, g6.user_nm as user_nm4 "+
				" from   service a, serv_off b, cont_n_view c, client d, car_reg e, fee fe, \n"+
				"        (select * from doc_settle where doc_st='41') f, \n"+
				"        users g, BRANCH g2, users g3, users g4, users g5, users g6,\n"+
				"        /*출금조회*/(select a.*, b.p_pay_dt from pay_item a, pay b where a.p_gubun='11' and a.reqseq=b.reqseq) p1, \n"+
				"        /*출금직접*/(select a.*, b.p_pay_dt from pay_item a, pay b where a.p_gubun='99' and a.reqseq=b.reqseq and a.acct_code in ('45700','45600') and a.p_cd5 is not null) p2, \n"+
				"        /*법인카드*/(select a.*, b.buy_dt from card_doc_item a, card_doc b where a.cardno=b.cardno and a.buy_id=b.buy_id) p3, \n"+
				"        /*정비정산*/(select a.*, a.j_yy||a.j_mm yymm from mj_jungsan a where a.j_g_amt>0 and a.j_yy||a.j_mm > '200912') p4 \n"+
			//	" where  a.serv_dt >= '20100101' \n"+
				" where a.off_id=b.off_id \n"+
				"        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd  and c.fee_rent_st = fe.rent_st /* and c.car_st <> '4' */\n"+
				"        and a.rent_mng_id=fe.rent_mng_id and a.rent_l_cd=fe.rent_l_cd \n"+
				"        and c.client_id=d.client_id \n"+
				"        and c.mng_id =g.user_id(+) \n"+  //계약의 담당자 
				"        and a.car_mng_id=e.car_mng_id \n"+
				"        and a.car_mng_id||a.serv_id = f.doc_id(+) \n"+
			//	"        and a.checker=g.user_id(+) \n"+
			//	"        and c.mng_id =g.user_id(+) \n"+  //계약의 담당자 
				"        and g.br_id=g2.br_id \n"+
				"        and f.user_id1=g3.user_id(+) \n"+
				"        and f.user_id2=g4.user_id(+) \n"+
				"        and f.user_id3=g5.user_id(+) \n"+
				"        and f.user_id4=g6.user_id(+) \n"+
				"        and a.car_mng_id=p1.p_cd1(+) and a.serv_id=p1.p_cd2(+)  \n"+
				"        and a.car_mng_id=p2.p_cd3(+) and a.serv_id=p2.p_cd5(+)  \n"+
				"        and a.car_mng_id=p3.item_code(+) and a.serv_id=p3.serv_id(+)  \n"+
				"        and a.off_id=p4.j_acct(+) and a.jung_st=p4.j_seq(+) and substr(a.set_dt,1,6)=p4.yymm(+)  \n"+
				"        and a.rep_amt <>0    \n"+
				" ";

		if(!m_gubun.equals(""))		query += " and f.user_dt"+m_gubun+" is null \n";

		if(m_gubun.equals("2"))		query += " and b.car_comp_id in ('0041','0043') and a.serv_dt > '20100531'";

		if(gubun1.equals("스피드메이트"))	query += " and b.car_comp_id = '0041' and nvl(a.reg_dt,a.serv_dt) > '20121031' ";
		else if(gubun1.equals("애니카"))	query += " and b.car_comp_id = '0043' and nvl(a.reg_dt,a.serv_dt) > '20121031'";
		else								query += " and nvl(a.reg_dt,a.serv_dt) > '20121031'";

		String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";

		if(gubun3.equals("1")){
			dt1		= "substr(a.serv_dt,1,6)";
			dt2		= "substr(a.serv_dt,1,8)";
	
		}else if(gubun3.equals("4")){
			dt1		= "substr(nvl(a.reg_dt,a.update_dt),1,6)";
			dt2		= "substr(nvl(a.reg_dt,a.update_dt),1,8)";
//			dt1		= "to_char(k.user_dt3,'YYYYMM')";
//			dt2		= "to_char(k.user_dt3,'YYYYMMDD')";
		}

		if(gubun2.equals("1"))			query += " and "+dt1+" = to_char(sysdate,'YYYYMM')";
		else if(gubun2.equals("3"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("4"))		query += " and "+dt2+" = to_char(sysdate+1,'YYYYMMDD')";
		else if(gubun2.equals("5"))		query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";
		else if(gubun2.equals("6"))		query += " and "+dt1+" = to_char(to_date(to_char(sysdate,'YYYYMM'),'YYYYMM')-1,'YYYYMM')";
		else if(gubun2.equals("7"))		query += " and "+dt1+" = to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm') ";
		else if(gubun2.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		if(gubun4.equals("1"))	query += " and a.serv_st in ('2')";
		if(gubun4.equals("2"))	query += " and a.serv_st in ('4','5','13')";
		if(gubun4.equals("3"))	query += " and a.serv_st in ('7')";

		if(gubun5.equals("1"))	query += " and p4.j_seq is not null";
		if(gubun5.equals("2"))	query += " and p1.p_st3||p2.p_st3 is not null";
		if(gubun5.equals("3"))	query += " and p3.item_code is not null";
		if(gubun5.equals("4"))	query += " and p4.j_seq||p1.p_st3||p2.p_st3||p3.item_code is null";

		if(!m_gubun.equals("2")){		
			if(!gubun1.equals(""))	query += " and b.off_nm like '%"+gubun1+"%'";
		}

		if(s_kd.equals("1"))	what = "upper(nvl(g.br_id||g2.br_nm, ' '))";	
		if(s_kd.equals("2"))	what = "upper(nvl(g.user_nm, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(e.car_nm, ' '))";	
		if(s_kd.equals("4"))	what = "upper(nvl(e.car_num, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(d.firm_nm, ' '))";
		if(s_kd.equals("6"))	what = "upper(nvl(e.car_no, ' '))";	
		
		if(s_kd.equals("13"))	what = "upper(nvl(b.ent_no, ' '))";	
		
		if(s_kd.equals("7"))	query += " and b.car_comp_id = '0041'";  //스피드메이트(협력업체)
		if(s_kd.equals("8"))	query += " and b.off_id = '000092'";  //두꺼비카센타(협력업체)
		if(s_kd.equals("9"))	query += " and b.car_comp_id = '0043'";  //애니카랜드(협력업체)
		if(s_kd.equals("10"))	query += " and b.off_id = '008634'";  //타이어휠타운(협력업체)
		
		if(s_kd.equals("11"))	query += " and b.off_id = '005392'";  //본동자동차
		
		if(s_kd.equals("14"))	query += " and b.off_id = '011605'";  //영남제일자동차
		if(s_kd.equals("15"))	query += " and b.off_id = '011771'";  //바로차유리

			
		if(!s_kd.equals("") && !what.equals("") && !t_wd.equals("")){
			if ( s_kd.equals("7") || s_kd.equals("8") || s_kd.equals("9") ){
			} else {	
				query += " and "+what+" like upper('%"+t_wd+"%') ";
			}
		}	
		
		if(sort.equals("1"))	query += " order by decode(g.br_id,'S1',1,'B1',2,'D1',3)";	
		if(sort.equals("2"))	query += " order by g.user_nm";	
		if(sort.equals("3"))	query += " order by e.car_nm";	
		if(sort.equals("4"))	query += " order by e.car_num";	
		if(sort.equals("5"))	query += " order by d.firm_nm";
		if(sort.equals("6"))	query += " order by decode(a.jung_st, 'C' , 9 , 1), a.reg_dt";	
		if(sort.equals("7"))	query += " order by decode(a.jung_st, 'C' , 9 , 1), a.serv_dt,e.car_no";	

	//	System.out.println("getServConfList( "+query);

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
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

		}catch(SQLException e){
			System.out.println("[CusReg_Database:getServConfList()]"+e);
			System.out.println("[CusReg_Database:getServConfList()]"+query);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null)	rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return vt;
		}
	}

/**
	 * 정비미청구현황 
	 */
	public Vector getServConfList(String m_gubun, String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String st_dt, String end_dt, String sort, String set_dt ){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		Vector vt = new Vector();

		query = " select a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.serv_id, a.accid_id, d.client_id, a.set_dt , a.jung_st ,  \n"+
				"        a.serv_dt, a.tot_dist, a.serv_st, \n"+
				"        decode(a.serv_st,'1','순회점검','2','일반정비','3','보증정비','7','재리스정비','4','운행자차','5','사고자차', '12', '해지정비','13','자차') serv_st_nm, \n"+
				"        a.r_labor, nvl(a.r_j_amt, a.r_amt) r_amt, a.sup_amt, a.add_amt,  a.rep_amt, \n"+
				"        b.off_nm, d.firm_nm, e.car_no, e.car_nm, e.car_num, g.user_nm, decode(fe.rent_way,'1','일반식','2','맞춤식','3','기본식') rent_way, \n"+
				"        p1.p_st3 pay_st1, p1.p_pay_dt pay_dt1, p1.reqseq||p1.i_seq pay_id1, \n"+
				"        p2.p_st3 pay_st2, p2.p_pay_dt pay_dt2, p2.reqseq||p2.i_seq pay_id2, \n"+
				"        decode(p3.item_code,'','','법인카드') pay_st3, p3.buy_dt pay_dt3, p3.cardno||p3.buy_id pay_id3, \n"+
				"        decode(p4.j_seq,'','',a.jung_st||'회차') pay_st4, p4.pay_dt pay_dt4, \n"+
				"        f.user_id1, to_char(f.user_dt1,'YYYYMMDD') user_dt1, g3.user_nm as user_nm1, "+
				"        f.user_id2, to_char(f.user_dt2,'YYYYMMDD') user_dt2, g4.user_nm as user_nm2, "+
				"        f.user_id3, to_char(f.user_dt3,'YYYYMMDD') user_dt3, g5.user_nm as user_nm3, "+
				"        f.user_id4, to_char(f.user_dt4,'YYYYMMDD') user_dt4, g6.user_nm as user_nm4 "+
				" from   service a, serv_off b, cont c, client d, car_reg e, fee fe, \n"+
				"        (select * from doc_settle where doc_st='41') f, \n"+
				"        users g, BRANCH g2, users g3, users g4, users g5, users g6,\n"+
				"        /*출금조회*/(select a.*, b.p_pay_dt from pay_item a, pay b where a.p_gubun='11' and a.reqseq=b.reqseq) p1, \n"+
				"        /*출금직접*/(select a.*, b.p_pay_dt from pay_item a, pay b where a.p_gubun='99' and a.reqseq=b.reqseq and a.acct_code in ('45700','45600') and a.p_cd5 is not null) p2, \n"+
				"        /*법인카드*/(select a.*, b.buy_dt from card_doc_item a, card_doc b where a.cardno=b.cardno and a.buy_id=b.buy_id) p3, \n"+
				"        /*정비정산*/(select a.*, a.j_yy||a.j_mm yymm from mj_jungsan a where a.j_g_amt>0 and a.j_yy||a.j_mm > '200912') p4 \n"+
			//	" where  a.serv_dt >= '20100101' \n"+
				"  where  a.off_id=b.off_id \n"+
				"        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd /* and c.car_st <> '4' */\n"+
				"        and a.rent_mng_id=fe.rent_mng_id and a.rent_l_cd=fe.rent_l_cd \n"+
				"        and c.client_id=d.client_id \n"+
				"        and a.car_mng_id=e.car_mng_id \n"+
				"        and a.car_mng_id||a.serv_id = f.doc_id(+) \n"+
				"        and a.checker=g.user_id(+) \n"+
				"        and g.br_id=g2.br_id \n"+
				"        and f.user_id1=g3.user_id(+) \n"+
				"        and f.user_id2=g4.user_id(+) \n"+
				"        and f.user_id3=g5.user_id(+) \n"+
				"        and f.user_id4=g6.user_id(+) \n"+
				"        and a.car_mng_id=p1.p_cd1(+) and a.serv_id=p1.p_cd2(+)  \n"+
				"        and a.car_mng_id=p2.p_cd3(+) and a.serv_id=p2.p_cd5(+)  \n"+
				"        and a.car_mng_id=p3.item_code(+) and a.serv_id=p3.serv_id(+)  \n"+
				"        and a.off_id=p4.j_acct(+) and a.jung_st=p4.j_seq(+) and substr(a.set_dt,1,6)=p4.yymm(+)  \n"+
				"        and a.rep_amt <>0  and a.set_dt = replace('"+set_dt+"', '-','') and a.jung_st = '1'   \n"+
				" ";

		if(!m_gubun.equals(""))		query += " and f.user_dt"+m_gubun+" is null \n";

		if(m_gubun.equals("2"))		query += " and b.car_comp_id in ('0041','0043') and a.serv_dt > '20100531'";

		if(gubun1.equals("스피드메이트"))	query += " and b.car_comp_id = '0041' and nvl(a.reg_dt,a.serv_dt) > '20121031' ";
		else if(gubun1.equals("애니카"))	query += " and b.car_comp_id = '0043' and nvl(a.reg_dt,a.serv_dt) > '20121031'";
		else								query += " and nvl(a.reg_dt,a.serv_dt) > '20121031'";

		String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";

		if(gubun3.equals("1")){
			dt1		= "substr(a.serv_dt,1,6)";
			dt2		= "substr(a.serv_dt,1,8)";
	
		}else if(gubun3.equals("4")){
			dt1		= "substr(nvl(a.reg_dt,a.update_dt),1,6)";
			dt2		= "substr(nvl(a.reg_dt,a.update_dt),1,8)";
//			dt1		= "to_char(k.user_dt3,'YYYYMM')";
//			dt2		= "to_char(k.user_dt3,'YYYYMMDD')";
		}

		if(gubun2.equals("1"))			query += " and "+dt1+" = to_char(sysdate,'YYYYMM')";
		else if(gubun2.equals("3"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("4"))		query += " and "+dt2+" = to_char(sysdate+1,'YYYYMMDD')";
		else if(gubun2.equals("5"))		query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";
		else if(gubun2.equals("6"))		query += " and "+dt1+" = to_char(to_date(to_char(sysdate,'YYYYMM'),'YYYYMM')-1,'YYYYMM')";
		else if(gubun2.equals("7"))		query += " and "+dt1+" = to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm') ";
		else if(gubun2.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		if(gubun4.equals("1"))	query += " and a.serv_st in ('2')";
		if(gubun4.equals("2"))	query += " and a.serv_st in ('4','5','13')";
		if(gubun4.equals("3"))	query += " and a.serv_st in ('7')";

		if(gubun5.equals("1"))	query += " and p4.j_seq is not null";
		if(gubun5.equals("2"))	query += " and p1.p_st3||p2.p_st3 is not null";
		if(gubun5.equals("3"))	query += " and p3.item_code is not null";
		if(gubun5.equals("4"))	query += " and p4.j_seq||p1.p_st3||p2.p_st3||p3.item_code is null";

		if(!m_gubun.equals("2")){		
			if(!gubun1.equals(""))	query += " and b.off_nm like '%"+gubun1+"%'";
		}

		if(s_kd.equals("1"))	what = "upper(nvl(g.br_id||g2.br_nm, ' '))";	
		if(s_kd.equals("2"))	what = "upper(nvl(g.user_nm, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(e.car_nm, ' '))";	
		if(s_kd.equals("4"))	what = "upper(nvl(e.car_num, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(d.firm_nm, ' '))";
		if(s_kd.equals("6"))	what = "upper(nvl(e.car_no, ' '))";	
		
		if(s_kd.equals("7"))	query += " and b.car_comp_id = '0041'";  //스피드메이트(협력업체)
		if(s_kd.equals("8"))	query += " and b.off_id = '000092'";  //두꺼비카센타(협력업체)
		if(s_kd.equals("9"))	query += " and b.car_comp_id = '0043'";  //애니카랜드(협력업체)
		if(s_kd.equals("10"))	query += " and b.off_id = '008634'";  //타이어휠타운(협력업체)
		if(s_kd.equals("11"))	query += " and b.off_id = '005392'";  //본동자동차(협력업체)

			
		if(!s_kd.equals("") && !what.equals("") && !t_wd.equals("")){
			if ( s_kd.equals("7") || s_kd.equals("8") || s_kd.equals("9") ){
			} else {	
				query += " and "+what+" like upper('%"+t_wd+"%') ";
			}
		}	
		
		if(sort.equals("1"))	query += " order by decode(g.br_id,'S1',1,'B1',2,'D1',3)";	
		if(sort.equals("2"))	query += " order by g.user_nm";	
		if(sort.equals("3"))	query += " order by e.car_nm";	
		if(sort.equals("4"))	query += " order by e.car_num";	
		if(sort.equals("5"))	query += " order by d.firm_nm";
		if(sort.equals("6"))	query += " order by decode(a.jung_st, 'C' , 9 ,1), a.reg_dt";	
		if(sort.equals("7"))	query += " order by decode(a.jung_st, 'C' , 9 , 1), a.serv_dt,e.car_no";	

//System.out.println("getServConfList( "+query);

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
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

		}catch(SQLException e){
			System.out.println("[CusReg_Database:getServConfList()]"+e);
			System.out.println("[CusReg_Database:getServConfList()]"+query);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null)	rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return vt;
		}
	}


		/**
	 * 정비미청구현황 
	 */
	public Vector getServConfList1(String allvarnum){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		Vector vt = new Vector();

		query = " select a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.serv_id, a.accid_id, d.client_id, a.set_dt , a.jung_st ,  \n"+
				"        a.serv_dt, a.tot_dist, a.serv_st, \n"+
				"        decode(a.serv_st,'1','순회점검','2','일반정비','3','보증정비','7','재리스정비','4','운행자차','5','사고자차', '12', '해지정비','13','자차') serv_st_nm, \n"+
				"        a.r_labor, nvl(a.r_j_amt, a.r_amt) r_amt, a.sup_amt, a.add_amt,  a.rep_amt, \n"+
				"        b.off_nm, d.firm_nm, e.car_no, e.car_nm, e.car_num, g.user_nm, decode(fe.rent_way,'1','일반식','2','맞춤식','3','기본식') rent_way, \n"+
				"        p1.p_st3 pay_st1, p1.p_pay_dt pay_dt1, p1.reqseq||p1.i_seq pay_id1, \n"+
				"        p2.p_st3 pay_st2, p2.p_pay_dt pay_dt2, p2.reqseq||p2.i_seq pay_id2, \n"+
				"        decode(p3.item_code,'','','법인카드') pay_st3, p3.buy_dt pay_dt3, p3.cardno||p3.buy_id pay_id3, \n"+
				"        decode(p4.j_seq,'','',a.jung_st||'회차') pay_st4, p4.pay_dt pay_dt4, \n"+
				"        f.user_id1, to_char(f.user_dt1,'YYYYMMDD') user_dt1, g3.user_nm as user_nm1, "+
				"        f.user_id2, to_char(f.user_dt2,'YYYYMMDD') user_dt2, g4.user_nm as user_nm2, "+
				"        f.user_id3, to_char(f.user_dt3,'YYYYMMDD') user_dt3, g5.user_nm as user_nm3, "+
				"        f.user_id4, to_char(f.user_dt4,'YYYYMMDD') user_dt4, g6.user_nm as user_nm4 "+
				" from   service a, serv_off b, cont_n_view c, client d, car_reg e, fee fe,  \n"+
				"        (select * from doc_settle where doc_st='41') f, \n"+
				"        users g, BRANCH g2, users g3, users g4, users g5, users g6,\n"+
				"        /*출금조회*/(select a.*, b.p_pay_dt from pay_item a, pay b where a.p_gubun='11' and a.reqseq=b.reqseq) p1, \n"+
				"        /*출금직접*/(select a.*, b.p_pay_dt from pay_item a, pay b where a.p_gubun='99' and a.reqseq=b.reqseq and a.acct_code in ('45700','45600') and a.p_cd5 is not null) p2, \n"+
				"        /*법인카드*/(select a.*, b.buy_dt from card_doc_item a, card_doc b where a.cardno=b.cardno and a.buy_id=b.buy_id) p3, \n"+
				"        /*정비정산*/(select a.*, a.j_yy||a.j_mm yymm from mj_jungsan a where a.j_g_amt>0 and a.j_yy||a.j_mm > '200912') p4 \n"+
				" where  a.serv_dt >= '20100101' \n"+
				"        and a.off_id=b.off_id \n"+
				"        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and c.fee_rent_st = fe.rent_st  /* and c.car_st <> '4' */\n"+
				"        and a.rent_mng_id=fe.rent_mng_id and a.rent_l_cd=fe.rent_l_cd \n"+
				"        and c.client_id=d.client_id \n"+
				"        and a.car_mng_id=e.car_mng_id \n"+
				"        and a.car_mng_id||a.serv_id = f.doc_id(+) \n"+
				"        and c.mng_id =g.user_id(+) \n"+  //계약의 담당자 		     	
				"        and g.br_id=g2.br_id \n"+
				"        and f.user_id1=g3.user_id(+) \n"+
				"        and f.user_id2=g4.user_id(+) \n"+
				"        and f.user_id3=g5.user_id(+) \n"+
				"        and f.user_id4=g6.user_id(+) \n"+
				"        and a.car_mng_id=p1.p_cd1(+) and a.serv_id=p1.p_cd2(+)  \n"+
				"        and a.car_mng_id=p2.p_cd3(+) and a.serv_id=p2.p_cd5(+)  \n"+
				"        and a.car_mng_id=p3.item_code(+) and a.serv_id=p3.serv_id(+)  \n"+
				"        and a.off_id=p4.j_acct(+) and a.jung_st=p4.j_seq(+) and substr(a.set_dt,1,6)=p4.yymm(+)  \n"+
				"        and a.rep_amt <>0 \n"+
				"       and a.car_mng_id||a.serv_id in ( "+allvarnum +" ) ";
	
			query += " order by decode(a.jung_st, null , 1 , 9) desc , a.serv_dt,e.car_no";	

		//	System.out.println("getServConfList1( "+query);

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
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

		}catch(SQLException e){
			System.out.println("[CusReg_Database:getServConfList()]"+e);
			System.out.println("[CusReg_Database:getServConfList()]"+query);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null)	rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return vt;
		}
	}



	public String getMaster_dt(String car_mng_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String m1_dt = "";

		query = "SELECT m1_dt FROM car_reg WHERE car_mng_id=?  ";
		
		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
		
			rs = pstmt.executeQuery();
			if(rs.next()){
				m1_dt = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt.close();

		}catch(SQLException e){
			System.out.println("[CusReg_Database:getMaster_dt]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null)	rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return m1_dt;
		}
	}
	
	
	/**
	 * 정비미청구현황
	 */
	public Vector getStatServSearch(String gubun, String br_id, String s_yy, String s_mm, String dept_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		Vector vt = new Vector();		
		
		
		query = " select u.user_id, u.user_nm ,  nvl( c0.cnt0 , 0 ) c0, \n"+
				"	u.dept_id, u.g_nm, u.user_pos ,  u.dept_nm , \n"+
		//		''  decode(u.dept_id, '0001', '영업팀', '0002', '고객지원팀', '0003', '총무팀', '0007', '부산지점', '0008', '대전지점',  '0009', '강남지점',  '0010', '광주지점',  '0011', '대구지점') dept_nm ,  u.user_pos , \n"+			
				"        nvl(c1.su1, 0) cnt1, nvl(c2.su2, 0) cnt2, nvl(c3.su3, 0) cnt3, nvl(c4.su4, 0) cnt4, nvl(c5.su5, 0) cnt5, nvl(c6.su6, 0) cnt6,   nvl(c7.su7, 0) cnt7,  nvl(c8.su8, 0) cnt8, nvl(c9.su9, 0) cnt9,  nvl(c10.su10, 0) cnt10, \n"+
				"        nvl(c11.su11, 0) cnt11, nvl(c12.su12, 0) cnt12,  nvl(c13.su13, 0) cnt13, nvl(c14.su14, 0) cnt14, nvl(c15.su15, 0) cnt15, nvl(c16.su16, 0) cnt16, nvl(c17.su17, 0) cnt17,  nvl(c18.su18, 0) cnt18,   nvl(c19.su19, 0) cnt19, \n"+
  				"        nvl(c1.amt1,0) amt1, nvl(c2.amt2,0) amt2, nvl(c3.amt3,0) amt3, nvl(c4.amt4,0) amt4, nvl(c5.amt5,0) amt5, nvl(c6.amt6,0) amt6, nvl(c7.amt7,0) amt7, nvl(c8.amt8,0) amt8, nvl(c9.amt9,0) amt9 ,  nvl(c10.amt10,0) amt10 , \n"+
				"        nvl(c11.amt11,0) amt11,   nvl(c12.amt12,0) amt12,  nvl(c13.amt13,0) amt13,  nvl(c14.amt14,0) amt14,  nvl(c15.amt15,0) amt15, nvl(c16.amt16,0) amt16, nvl(c17.amt17,0) amt17, nvl(c18.amt18,0) amt18,  nvl(c19.amt19,0) amt19   \n"+
				"	from	 \n"+
				"   (select user_id, user_nm, decode(dept_id, '0009', '0001' , '0012', '0001', '0014', '0002', '0015', '0002', dept_id ) dept_id,  user_pos, enter_dt, decode(dept_id, '0001', '영업팀', '0002', '고객지원팀', '0003', '총무팀', '0007', '부산지점', '0008', '대전지점',  '0009', '영업팀',  '0010', '광주지점',  '0011', '대구지점',  '0012', '영업팀',  '0013', '수원지점',  '0014', '고객지원팀',  '0015', '고객지원팀',  '0016', '울산지점') dept_nm , \n"+
				"		       case when dept_id = '0001' then ' 본사'    when dept_id = '0009' then '강남'  when dept_id = '0012' then '인천'  \n"+
				"		            when dept_id = '0014'  then '강서'    when dept_id = '0015'  then '구로' \n"+
				"		            when dept_id = '0007' and loan_st = '1' then '1군'	            when dept_id = '0007' and loan_st = '2' then '2군' \n"+
				"		            when dept_id = '0008' and loan_st = '1' then '1군'	            when dept_id = '0008' and loan_st = '2' then '2군' \n"+
				"		            when dept_id = '0010' and loan_st = '1' then '1군'	            when dept_id = '0010' and loan_st = '2' then '2군' \n"+
				"		            when dept_id = '0013' and loan_st = '1' then '1군'	            when dept_id = '0013' and loan_st = '2' then '2군' \n"+			
				"		            when dept_id = '0016' and loan_st = '1' then '1군'	            when dept_id = '0016' and loan_st = '2' then '2군' \n"+
				"		            when dept_id = '0011' and loan_st = '1' then '1군'	            when dept_id = '0011' and loan_st = '2' then '2군'      else 'x' end g_nm  \n"+
				"		            from users where use_yn = 'Y' and loan_st in ( '1', '2' )  )  u ,	\n"+		
				"	( select v.bus_id2, count(*) cnt0 from cont v where v.use_yn = 'Y' and v.car_st <> '4'  group by v.bus_id2 ) c0, \n"+
				"	( select nvl(a.bus_id2, v.bus_id2) bus_id2 , count(*) su1, sum(r_labor + nvl(r_j_amt, r_amt)) amt1  from service a, serv_off o , cont v \n"+
				"	where  a.serv_dt between replace('"+s_yy+"', '-','') and replace('"+s_mm+"', '-','') and a.off_id = o.off_id and o.car_comp_id = '0041'  \n"+
				"	  and a.rent_mng_id = v.rent_mng_id and a.rent_l_cd = v.rent_l_cd  group by nvl(a.bus_id2, v.bus_id2) ) c1, \n"+
				"	( select nvl(a.bus_id2, v.bus_id2) bus_id2, count(*) su2, sum(r_labor + nvl(r_j_amt, r_amt)) amt2  from service a, serv_off o , cont v \n"+
				"	where  a.serv_dt between replace('"+s_yy+"', '-','') and replace('"+s_mm+"', '-','') and a.off_id = o.off_id and o.car_comp_id = '0043'  \n"+
				"	  and a.rent_mng_id = v.rent_mng_id and a.rent_l_cd = v.rent_l_cd  group by nvl(a.bus_id2, v.bus_id2) ) c2, \n"+
				"	( select nvl(a.bus_id2, v.bus_id2) bus_id2, count(*) su3, sum(r_labor + nvl(r_j_amt, r_amt)) amt3 from service a, serv_off o , cont v \n"+
				"	where  a.serv_dt between replace('"+s_yy+"', '-','') and replace('"+s_mm+"', '-','') and a.off_id = o.off_id and o.off_id  = '000620'  \n"+
				"	  and a.rent_mng_id = v.rent_mng_id and a.rent_l_cd = v.rent_l_cd  group by nvl(a.bus_id2, v.bus_id2) ) c3 , \n"+
				"	( select nvl(a.bus_id2, v.bus_id2) bus_id2 , count(*) su4, sum(r_labor + nvl(r_j_amt, r_amt)) amt4  from service a, serv_off o , cont v \n"+
				"	where  a.serv_dt between replace('"+s_yy+"', '-','') and replace('"+s_mm+"', '-','') and a.off_id = o.off_id and o.off_id =  '006858'  \n"+
				"	  and a.rent_mng_id = v.rent_mng_id and a.rent_l_cd = v.rent_l_cd  group by nvl(a.bus_id2, v.bus_id2) ) c4 , \n"+
				"	( select nvl(a.bus_id2, v.bus_id2) bus_id2 , count(*) su5, sum(r_labor + nvl(r_j_amt, r_amt)) amt5  from service a, serv_off o , cont v \n"+
				"	where  a.serv_dt between replace('"+s_yy+"', '-','') and replace('"+s_mm+"', '-','') and a.off_id = o.off_id and o.off_id  = '000286'  \n"+
				"	  and a.rent_mng_id = v.rent_mng_id and a.rent_l_cd = v.rent_l_cd  group by nvl(a.bus_id2, v.bus_id2) ) c5 , \n"+
				"	( select nvl(a.bus_id2, v.bus_id2) bus_id2 , count(*) su6, sum(r_labor + nvl(r_j_amt, r_amt)) amt6  from service a, serv_off o , cont v \n"+
				"	where  a.serv_dt between replace('"+s_yy+"', '-','') and replace('"+s_mm+"', '-','') and a.off_id = o.off_id and o.off_id  = '002105'  \n"+				
				"	  and a.rent_mng_id = v.rent_mng_id and a.rent_l_cd = v.rent_l_cd  group by nvl(a.bus_id2, v.bus_id2)  ) c6,  \n"+		
				"	( select nvl(a.bus_id2, v.bus_id2) bus_id2 , count(*) su7, sum(r_labor + nvl(r_j_amt, r_amt)) amt7  from service a, serv_off o , cont v \n"+
				"	where  a.serv_dt between replace('"+s_yy+"', '-','') and replace('"+s_mm+"', '-','') and a.off_id = o.off_id and o.off_id  = '001816'  \n"+				
				"	  and a.rent_mng_id = v.rent_mng_id and a.rent_l_cd = v.rent_l_cd  group by nvl(a.bus_id2, v.bus_id2)  ) c7,  \n"+		
				"	( select nvl(a.bus_id2, v.bus_id2) bus_id2 , count(*) su8, sum(r_labor + nvl(r_j_amt, r_amt)) amt8  from service a, serv_off o , cont v \n"+
				"	where  a.serv_dt between replace('"+s_yy+"', '-','') and replace('"+s_mm+"', '-','') and a.off_id = o.off_id and o.off_id  = '002734'  \n"+				//현대카독크
				"	  and a.rent_mng_id = v.rent_mng_id and a.rent_l_cd = v.rent_l_cd  group by nvl(a.bus_id2, v.bus_id2)  ) c8,  \n"+	
				"	( select nvl(a.bus_id2, v.bus_id2) bus_id2 , count(*) su9, sum(r_labor + nvl(r_j_amt, r_amt)) amt9  from service a, serv_off o , cont v \n"+        //두꺼비
				"	where  a.serv_dt between replace('"+s_yy+"', '-','') and replace('"+s_mm+"', '-','') and a.off_id = o.off_id and o.off_id  = '000092'  \n"+				
				"	  and a.rent_mng_id = v.rent_mng_id and a.rent_l_cd = v.rent_l_cd  group by nvl(a.bus_id2, v.bus_id2)  ) c9,  \n"+				
				"	( select nvl(a.bus_id2, v.bus_id2) bus_id2 , count(*) su10, sum(r_labor + nvl(r_j_amt, r_amt)) amt10  from service a, serv_off o , cont v \n"+
				"	where  a.serv_dt between replace('"+s_yy+"', '-','') and replace('"+s_mm+"', '-','') and a.off_id = o.off_id and o.off_id  = '006470'  \n"+		//티스테이션시청		
				"	  and a.rent_mng_id = v.rent_mng_id and a.rent_l_cd = v.rent_l_cd  group by nvl(a.bus_id2, v.bus_id2)  ) c10,  \n"+		
				"	( select nvl(a.bus_id2, v.bus_id2) bus_id2 , count(*) su11, sum(r_labor + nvl(r_j_amt, r_amt)) amt11  from service a, serv_off o , cont v \n"+   //티스테이션대전
				"	where  a.serv_dt between replace('"+s_yy+"', '-','') and replace('"+s_mm+"', '-','') and a.off_id = o.off_id and o.off_id  = '007455'  \n"+				
				"	  and a.rent_mng_id = v.rent_mng_id and a.rent_l_cd = v.rent_l_cd  group by nvl(a.bus_id2, v.bus_id2)  ) c11,  \n"+		
				"	( select nvl(a.bus_id2, v.bus_id2) bus_id2 , count(*) su12, sum(r_labor + nvl(r_j_amt, r_amt)) amt12  from service a, serv_off o , cont v \n"+   //노블래스
				"	where  a.serv_dt between replace('"+s_yy+"', '-','') and replace('"+s_mm+"', '-','') and a.off_id = o.off_id and o.off_id  = '007603'  \n"+				
				"	  and a.rent_mng_id = v.rent_mng_id and a.rent_l_cd = v.rent_l_cd  group by nvl(a.bus_id2, v.bus_id2)  ) c12,  \n"+		
				"	( select nvl(a.bus_id2, v.bus_id2) bus_id2 , count(*) su13, sum(r_labor + nvl(r_j_amt, r_amt)) amt13  from service a, serv_off o , cont v \n"+   //1급금호대전
				"	where  a.serv_dt between replace('"+s_yy+"', '-','') and replace('"+s_mm+"', '-','') and a.off_id = o.off_id and o.off_id  = '007897'  \n"+				
				"	  and a.rent_mng_id = v.rent_mng_id and a.rent_l_cd = v.rent_l_cd  group by nvl(a.bus_id2, v.bus_id2)  ) c13 , \n"+	
				"	( select nvl(a.bus_id2, v.bus_id2) bus_id2 , count(*) su14, sum(r_labor + nvl(r_j_amt, r_amt)) amt14  from service a, serv_off o , cont v \n"+   
				"	where  a.serv_dt between replace('"+s_yy+"', '-','') and replace('"+s_mm+"', '-','') and a.off_id = o.off_id and o.off_id  = '007155'  \n"+			//jt네트웍스	
				"	  and a.rent_mng_id = v.rent_mng_id and a.rent_l_cd = v.rent_l_cd  group by nvl(a.bus_id2, v.bus_id2)  ) c14 , \n"+
				"     ( select nvl(a.req_id, v.bus_id2) bus_id2 , count(*) su15, sum(tot_amt - oil_amt) amt15  from consignment a, cont v  \n"+
				"	where  a.req_dt between  replace('"+s_yy+"', '-','') and replace('"+s_mm+"', '-','')  and a.off_id  = '002740' 	 \n"+
				"	  and a.rent_mng_id = v.rent_mng_id and a.rent_l_cd = v.rent_l_cd  group by nvl(a.req_id, v.bus_id2)  ) c15,	 \n"+			// 전국탁송
				"     ( select nvl(a.req_id, v.bus_id2) bus_id2 , count(*) su16, sum(tot_amt - oil_amt) amt16  from consignment a, cont v  \n"+
				"	where  a.req_dt between  replace('"+s_yy+"', '-','') and replace('"+s_mm+"', '-','')  and a.off_id  = '007547' 	 \n"+
				"	  and a.rent_mng_id = v.rent_mng_id and a.rent_l_cd = v.rent_l_cd  group by nvl(a.req_id, v.bus_id2)  ) c16,	 \n"+			// 하이카콤 - 부산
				"     ( select nvl(a.req_id, v.bus_id2) bus_id2 , count(*) su17, sum(tot_amt - oil_amt) amt17  from consignment a, cont v  \n"+
				"	where  a.req_dt between  replace('"+s_yy+"', '-','') and replace('"+s_mm+"', '-','')  and a.off_id  = '004171' 	 \n"+
				"	  and a.rent_mng_id = v.rent_mng_id and a.rent_l_cd = v.rent_l_cd  group by nvl(a.req_id, v.bus_id2)  ) c17,	 \n"+			//하이카콤 - 대전
				"   ( select bus_id  bus_id2,  count(*) su18,  sum(sbgb_amt) amt18 from master_car   \n"+
				"        where js_dt  between  replace('"+s_yy+"', '-','') and replace('"+s_mm+"', '-','') and gubun = '1' group by bus_id  ) c18,  \n"+   //마스타자동차
				"   (select a.mng_id  bus_id2, count(*) su19,  sum(a.che_amt) amt19 from car_maint_req  a    \n"+
				"        where a.che_dt  between  replace('"+s_yy+"', '-','') and replace('"+s_mm+"', '-','') and a.m1_chk = '3' group by mng_id  ) c19  \n"+   //성수자동차
				"	 where u.user_id = c1.bus_id2(+) \n"+
				"	  and  u.user_id = c2.bus_id2(+) \n"+
				"	  and  u.user_id = c3.bus_id2(+) \n"+
				"	  and  u.user_id = c4.bus_id2(+) \n"+
				"	  and  u.user_id = c5.bus_id2(+) \n"+
				"	  and  u.user_id = c6.bus_id2(+) \n"+
				"	  and  u.user_id = c7.bus_id2(+) \n"+
				"	  and  u.user_id = c8.bus_id2(+) \n"+
				"	  and  u.user_id = c9.bus_id2(+) \n"+
				"	  and  u.user_id = c10.bus_id2(+) \n"+
				"	  and  u.user_id = c11.bus_id2(+) \n"+
				"	  and  u.user_id = c12.bus_id2(+) \n"+
				"	  and  u.user_id = c13.bus_id2(+) \n"+
				"	  and  u.user_id = c14.bus_id2(+) \n"+
				"	  and  u.user_id = c15.bus_id2(+) \n"+
				"	  and  u.user_id = c16.bus_id2(+) \n"+
				"	  and  u.user_id = c17.bus_id2(+) \n"+
				"	  and  u.user_id = c18.bus_id2(+) \n"+
				"	  and  u.user_id = c19.bus_id2(+) \n"+
				"	  and  u.user_id = c0.bus_id2(+) \n"+
			//	"	  and u.use_yn ='Y' and u.dept_id in ( '0001', '0002', '0003', '0007', '0008', '0009', '0010', '0011') and u.loan_st in  ( '1', '2') \n"+
				"	 order by u.dept_id, u.g_nm,  u.enter_dt ";  
								
//		System.out.println("getStatServSearch=" + query);		

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
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

		}catch(SQLException e){
			System.out.println("[CusReg_Database:getStatServSearch()]"+e);
			System.out.println("[CusReg_Database:getStatServSearch()]"+query);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null)	rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return vt;
		}
	}	
	
	
	/**
    * 재리스수리비 공제금액.
    */
	public int updateShAmt(String car_mng_id, String serv_id, int sh_amt, String bus_id2){
		getConnection();
		PreparedStatement pstmt = null;
		String query = "";		
		int result = 0;		
		
		query = "update service set sh_amt = ? , bus_id2 = ? WHERE car_mng_id=? AND serv_id=?";
		
		try{
			conn.setAutoCommit(false);				
			
			pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, sh_amt);
			pstmt.setString(2, bus_id2);
			pstmt.setString(3, car_mng_id);
			pstmt.setString(4, serv_id);
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		}catch(SQLException e){
			System.out.println("[CusReg_Database:updateShAmt(String car_mng_id, String serv_id, int sh_amt, String bus_id2)]"+e);
			e.printStackTrace();
			conn.rollback();
			result = 0;
		}finally{
			try{
			    conn.setAutoCommit(true);
              		  if(pstmt != null) pstmt.close();
            
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}
	}

	   /**
	    * 정비 날짜 수정(순회점검일, 정비일, 입고일, 출고일)
	    */
	public int updateDt(String car_mng_id, String serv_id,  String gubun, String dt){
		getConnection();
		PreparedStatement pstmt = null;
		String query = "";		
		int result = 0;			
		
		if (gubun.equals("1")) query = " update service set spdchk_dt = replace(? , '-', '')  where  car_mng_id=? AND serv_id=?";
		if (gubun.equals("2")) query = " update service set serv_dt  =  replace(? , '-', '')  where  car_mng_id=? AND serv_id=?";
		if (gubun.equals("3")) query = " update service set ipgodt  =   replace(? , '-', '')  where  car_mng_id=? AND serv_id=?";
		if (gubun.equals("4")) query = " update service set chulgodt =  replace(? , '-', '')  where  car_mng_id=? AND serv_id=?";
			
		try{
			conn.setAutoCommit(false);				
			
			pstmt = conn.prepareStatement(query);			
			pstmt.setString(1, dt);
			pstmt.setString(2, car_mng_id);
			pstmt.setString(3, serv_id);
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		}catch(SQLException e){
			System.out.println("[CusReg_Database:updateDt(String car_mng_id, String serv_id, String gubun, String dt)]"+e);
			e.printStackTrace();
			conn.rollback();
			result = 0;
		}finally{
			try{
			    conn.setAutoCommit(true);
              		  if(pstmt != null) pstmt.close();
            
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}
	}
		
	/**
    * 정비 call 정보 수정.
    */
	public int updateServCallInfo(String car_mng_id, String serv_id, String call_t_nm, String call_t_tel){
		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		int result = 0;

		query = "update service set call_t_nm = ? , call_t_tel = ?  WHERE car_mng_id=? AND serv_id=?";
		
		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, call_t_nm);
			pstmt.setString(2, call_t_tel);
			pstmt.setString(3, car_mng_id);
			pstmt.setString(4, serv_id);
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		}catch(SQLException e){
			System.out.println("[CusReg_Database:updateServCallInfo(String car_mng_id, String serv_id, String call_t_nm, String call_t_tel)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
			  conn.setAutoCommit(true);
               		 if(pstmt != null) pstmt.close();
              
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}
	}
	
	
	/**
	 * 정비업체별 거래현황
	 */
	public Hashtable  getServjListNew(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String st_dt, String end_dt, String off_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		Hashtable ht = new Hashtable();
		
		
		String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";
		String dt3 = "";
		String dt4 = "";
		String dt5 = "";
		String dt6 = "";
		
		String s1_query = "";
		String s2_query = "";
		String s3_query = "";
		String s4_query = "";
		String s5_query = "";		
		String s6_query = "";		
		   		
		if(gubun2.equals("2"))	{	
			dt1		= "substr(a.ipgodt,1,8)";
			dt2		= "substr(a.chulgodt,1,8)";	
			dt3		= "substr(a.acct_dt,1,8)";		
			dt4		= "substr(a.acct_dt,1,8)";		
			dt5		= "substr(a.pay_dt,1,8)";		
			dt6		= "substr(a.buy_dt,1,8) ";		
	 	} else {
	 		dt1		= "substr(a.ipgodt,1,6)";
			dt2		= "substr(a.chulgodt,1,6)";	
			dt3		= "substr(a.acct_dt,1,6)";		
			dt4		= "substr(a.acct_dt,1,6)";		
			dt5		= "substr(a.pay_dt,1,6)";	
			dt6		= "substr(a.buy_dt,1,6) ";	 			 		
	 	}

		
		if(gubun2.equals("1"))	{	
			s1_query = "  "+dt1+" = to_char(sysdate,'YYYYMM')";
			s2_query = "  "+dt2+" = to_char(sysdate,'YYYYMM')";
			s3_query = "  "+dt3+" = to_char(sysdate,'YYYYMM')";
			s4_query = "  "+dt4+" = to_char(sysdate,'YYYYMM')";
			s5_query = "  "+dt5+" = to_char(sysdate,'YYYYMM')";
			s6_query = "  "+dt6+" = to_char(sysdate,'YYYYMM')";
		} else if(gubun2.equals("6"))	{
			s1_query ="  "+dt1+" = to_char(to_date(to_char(sysdate,'YYYYMM'),'YYYYMM')-1,'YYYYMM')";
			s2_query = " "+dt2+" = to_char(to_date(to_char(sysdate,'YYYYMM'),'YYYYMM')-1,'YYYYMM')";
			s3_query = "  "+dt3+" = to_char(to_date(to_char(sysdate,'YYYYMM'),'YYYYMM')-1,'YYYYMM')";
			s4_query = "  "+dt4+" = to_char(to_date(to_char(sysdate,'YYYYMM'),'YYYYMM')-1,'YYYYMM')";
			s5_query = "  "+dt5+" = to_char(to_date(to_char(sysdate,'YYYYMM'),'YYYYMM')-1,'YYYYMM')";
			s6_query = "  "+dt6+" = to_char(to_date(to_char(sysdate,'YYYYMM'),'YYYYMM')-1,'YYYYMM')";
		} else if(gubun2.equals("2")){	
			if(!st_dt.equals("") && end_dt.equals(""))   {
				s1_query = "  "+dt1 +" like replace('"+st_dt+"%', '-','')";
				s2_query = " "+dt2  +" like replace('"+st_dt+"%', '-','')";
				s3_query = "  "+dt3 +" like replace('"+st_dt+"%', '-','')";
				s4_query = "  "+dt4 +" like replace('"+st_dt+"%', '-','')";
				s5_query = "  "+dt5 +" like replace('"+st_dt+"%', '-','')";			
				s6_query = "  "+dt6 +" like replace('"+st_dt+"%', '-','')";			
			}				
			if(!st_dt.equals("") && !end_dt.equals(""))  {
				s1_query = "  "+dt1 +" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
				s2_query = " "+dt2  +" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
				s3_query = "  "+dt3 +" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
				s4_query = "  "+dt4 +" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
				s5_query = "  "+dt5 +" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";	
				s6_query = "  "+dt6 +" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";	
			}	
	        }
	
	
	/*
		if(s_kd.equals("1"))	what = "upper(nvl(g.br_id||g2.br_nm, ' '))";	
		if(s_kd.equals("2"))	what = "upper(nvl(g.user_nm, ' '))";	
	
		if(!s_kd.equals("") && !t_wd.equals("")){
				query += " and "+what+" like upper('%"+t_wd+"%') ";
		}						
	*/					                
		query =     "  select  decode(o.off_id, '000620', '1', '006858', '1' , '000286', '1', '009290', '1', '002105', '2' , '001816', '2',  '002734', '3', '007603', '3' , '007897', '3'  ) gubun1 ,  \n"+
				"      decode(o.off_id, '000620', '1', '006858', '2' , '000286', '3', '002105', '4' , '001816', '5',  '002734', '6', '007603', '7' , '007897', '7' ) gubun2,  \n"+
		//		"      o.off_id , o.off_nm,   a.ip_cnt, b.ch_cnt, ta.tot_cnt,  c.r_labor+c.r_j_amt   tot_amt , ca.r_labor+ca.r_j_amt, d.jg_amt+d.jb_amt  pay_amt  \n"+
				"      o.off_id , o.off_nm, nvl(a.ip_cnt, 0) ip_cnt, nvl(b.ch_cnt, 0) ch_cnt, nvl(ta.tot_cnt, 0) tot_cnt,  nvl(round(c.r_labor),0) labor_amt,   nvl(round(c.r_j_amt),0) r_j_amt,   nvl(round(c.r_labor+c.r_j_amt),0) tot_amt,  \n"+
				"      nvl(d.jg_amt+d.jb_amt, 0) pay_amt , nvl(p.p_s_amt, 0) parts_amt \n"+
				"      from serv_off o,   \n"+
				"		 ( select a.off_id, count(*) ip_cnt    from service a       \n"+          
				"		     where " + s1_query + "  \n"+
				"		        and a.off_id  ='" + off_id + "'   \n"+
				"		  group by a.off_id ) a,    \n"+
				"		 ( select a.off_id, count(*) ch_cnt   from service a             \n"+    
				"		     where " + s2_query + "  \n"+
				"		        and a.off_id  ='" + off_id + "'   \n"+
				"		   group by a.off_id ) b, \n"+
				"                 ( select a.off_id, count(*) tot_cnt   from service a      \n"+            
				"	     		where  " + s3_query + "  \n"+
				"		        and a.off_id  ='" + off_id + "'   \n"+  
				"		  group by a.off_id ) ta,      \n"+      
			//	"		 (     select  a.off_id,  round(sum(a.r_labor*(decode(b.accid_st, '8', 100, '6', 100, null, 100, b.our_fault_per))/100),0) r_labor,   \n"+
		        //		"		                round(sum(a.r_j_amt*(decode(b.accid_st, '8', 100, '6', 100, null, 100, b.our_fault_per))/100),0) r_j_amt   \n"+
		//		"		    from service a,  accident b   \n"+
		//		"		    where  a.acct_dt  between '20121201' and '20121231'   \n"+
		//		"		    and a.car_mng_id = b.car_mng_id(+) and a.accid_id  = b.accid_id(+)  \n"+
		//		"		        and a.off_id  ='" + off_id + "'   \n"+
		//		"		    and a.tot_amt > 0  \n"+
		//		"		    group by a.off_id  ) ca,  \n"+		
				"		 (   select  a.off_id, sum(decode(a.serv_st ,'13', b.our_fault_per*a.r_labor/100, a.r_labor)) r_labor,  sum(decode(a.serv_st, '13', b.our_fault_per*a.r_j_amt/100, a.r_j_amt)) r_j_amt   from service a,  accident b   \n"+
				"		    where " + s4_query + "  \n"+
				"		    and a.car_mng_id = b.car_mng_id(+) and a.accid_id  = b.accid_id(+)  \n"+
				"		        and a.off_id  ='" + off_id + "'   \n"+
			//	"		    and a.tot_amt > 0  \n"+
				"		    group by a.off_id  ) c,	  \n"+				    
				"		 ( select a.j_acct, sum(a.j_g_amt) jg_amt, sum(a.j_b_amt) jb_amt     from  mj_jungsan a   \n"+
				"		    where " + s5_query + "  \n"+
				"		      and   a.j_acct ='" + off_id  + "'  \n"+
				"		      group by j_acct ) d,  \n"+		
				"                 (  select    decode(pi.location, 'M', '000620', '006858' ) off_id,  sum(b.o_s_amt) p_s_amt    \n"+
				"		       from parts_order a, parts_item b ,parts p   , parts_ipgo i ,parts_item_ip pi     \n"+
				"				where a.reqseq= b.reqseq and b.parts_no = p.parts_no    \n"+
				"			      and a.reqseq = i.o_reqseq and i.reqseq = pi.reqseq  and b.parts_no = pi.parts_no  and " + s6_query + "    \n"+	
				"                  group by decode(pi.location, 'M', '000620', '006858' )  )  p \n"+	
				"		  where o.off_id = a.off_id(+)  \n"+
				"		    and o.off_id = b.off_id(+)  \n"+
				"		    and o.off_id = c.off_id(+)  \n"+
				"		    and o.off_id = ta.off_id(+)  \n"+
			//	"		    and o.off_id = ca.off_id(+)  \n"+
				"		    and o.off_id = d.j_acct(+)  \n"+
				"		    and o.off_id = p.off_id(+)  \n"+
				"		    and  o.off_id  ='" + off_id + "'   \n"+
				"		    order by 1, 2    ";
          
		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			
	//	System.out.println("getServjListNew=" + query);
			
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
			System.out.println("[CusReg_Database:getServjListNew]\n"+e);			
			System.out.println("[CusReg_Database:getServjListNew]\n"+query);			
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
			         if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}	
	}	
		
	/**
	 * 정비업체별 거래현황
	 */
	public Hashtable  getServjList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String st_dt, String end_dt, String off_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		Hashtable ht = new Hashtable();
		

		query =     "	select decode(a.off_id, '000620', '1', '006858', '1' , '000286', '1', '002105', '2' , '002734', '3', '007603', '4'  ) gubun1 , \n"+
				"	       decode(a.off_id, '000620', '1', '006858', '2' , '000286', '3', '002105', '4' , '002734', '5', '007603', '5' ) gubun2 ,  \n"+
				"	       a.off_id, a.off_nm, count(ipgodt) ip_cnt, count(chulgodt) ch_cnt , count(off_id) tot_cnt, sum(r_labor + r_amt) tot_amt , sum(decode(pay_st4, null, 0, r_labor + r_amt) ) pay_amt \n"+
				"	from ( \n"+
				"	    select a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.serv_id, a.serv_dt,     \n"+
				"	            a.r_labor, a.r_amt,  a.ipgodt, a.chulgodt, \n"+
				"	            a.off_id, b.off_nm,  e.car_no, g.user_nm,       \n"+ 
				"	            decode(p4.j_seq,'','',a.jung_st||'회차') pay_st4, p4.pay_dt pay_dt4 \n"+
				"	             from   service a, serv_off b, cont c, client d, car_reg e,       \n"+
				"	            users g, BRANCH g2 ,  \n"+
				"	            /*정비정산*/(select a.*, a.j_yy||a.j_mm yymm from mj_jungsan a where a.j_g_amt>0 and a.j_yy||a.j_mm > '200812') p4  \n"+
				"	     where  a.serv_dt >= '20080101' \n"+
				"	            and a.off_id=b.off_id and a.off_id  ='" + off_id + "'       \n"+
				"	            and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and c.car_st<> '4'\n"+
				"	            and c.client_id=d.client_id \n"+
				"	            and a.car_mng_id=e.car_mng_id       \n"+
				"	            and a.checker=g.user_id \n"+
				"	            and g.br_id=g2.br_id      \n"+
				"	            and a.off_id=p4.j_acct(+) and a.jung_st=p4.j_seq(+) and substr(a.set_dt,1,6)=p4.yymm(+)  \n"+
				"	            and a.rep_amt>0   \n"+
				" ";
				
				String search = "";
				String what = "";
				String dt2 = "";
		
				if(gubun3.equals("1")){
					dt2		= "a.serv_dt";			
				}else if(gubun3.equals("4")){
					dt2		= "a.reg_dt";		
				}
		
				if(gubun2.equals("1"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%'";
				else if(gubun2.equals("6"))		query += " and "+dt2+" like to_char(to_date(to_char(sysdate,'YYYYMM'),'YYYYMM')-1,'YYYYMM')||'%'";
				else if(gubun2.equals("2")){
					if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
					if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
				}	
					
		
				if(s_kd.equals("1"))	what = "upper(nvl(g.br_id||g2.br_nm, ' '))";	
				if(s_kd.equals("2"))	what = "upper(nvl(g.user_nm, ' '))";	
	
					
				if(!s_kd.equals("") && !t_wd.equals("")){
					query += " and "+what+" like upper('%"+t_wd+"%') ";
				}						
					
								
				query +=	"	  ) a   \n"+
						"  group by a.off_id , a.off_nm  \n";
							


		try{
			pstmt = conn.prepareStatement(query);
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
			System.out.println("[CusReg_Database:getServjList]\n"+e);			
			System.out.println("[CusReg_Database:getServjList]\n"+query);			
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
			         if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}	
	}	
		

	public Vector getServjListNew(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String off_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		Vector vt = new Vector();		
			
	/*
		if(s_kd.equals("1"))	what = "upper(nvl(g.br_id||g2.br_nm, ' '))";	
		if(s_kd.equals("2"))	what = "upper(nvl(g.user_nm, ' '))";	
	
		if(!s_kd.equals("") && !t_wd.equals("")){
				query += " and "+what+" like upper('%"+t_wd+"%') ";
		}						
	*/					                
	
	
//	query =     "	select  substr(serv_dt, 5, 2)  serv_mm, count(ipgodt) ip_cnt, count(chulgodt) ch_cnt , count(off_id) tot_cnt, sum(r_labor + r_amt) tot_amt , sum(decode(pay_st4, null, 0, r_labor + r_amt) ) pay_amt \n"+
//				"	from ( \n"+
//				"	    select a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.serv_id, a.serv_dt,     \n"+
//				"	            a.r_labor, a.r_amt,  a.ipgodt, a.chulgodt, \n"+
//				"	            a.off_id, b.off_nm,  e.car_no, g.user_nm,       \n"+ 
//				"	            decode(p4.j_seq,'','',a.jung_st||'회차') pay_st4, p4.pay_dt pay_dt4 \n"+
//				"	             from   service a, serv_off b, cont c, client d, car_reg e,       \n"+
//				"	            users g, BRANCH g2 ,  \n"+
//				"	            /*정비정산*/(select a.*, a.j_yy||a.j_mm yymm from mj_jungsan a where a.j_g_amt>0 and a.j_yy||a.j_mm > '200812') p4  \n"+
//				"	     where  a.serv_dt >= '20080101' \n"+
//				"	            and a.off_id=b.off_id and a.off_id  ='" + off_id + "'   \n"+
//				"	            and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"+
//				"	            and c.client_id=d.client_id \n"+
//				"	            and a.car_mng_id=e.car_mng_id       \n"+
//				"	            and a.checker=g.user_id \n"+
//				"	            and g.br_id=g2.br_id      \n"+
//				"	            and a.off_id=p4.j_acct(+) and a.jung_st=p4.j_seq(+) and substr(a.set_dt,1,6)=p4.yymm(+)  \n"+
//				"	            and a.rep_amt>0   \n"+
//				" ";
					
				query =     "	select substr(aa.serv_dt, 5, 2)  serv_mm , a.ip_cnt, b.ch_cnt, ta.tot_cnt, round(c.r_labor+c.r_j_amt) tot_amt , round(d.jg_amt+ d.jb_amt)  pay_amt  \n"+
						"		  from   \n"+
						"		   ( select  '"+gubun2+"'||'01' serv_dt from dual  \n"+
						"		     union  \n"+
						"		     select  '"+gubun2+"'||'02' serv_dt from dual  \n"+
						"		      union  \n"+
						"		      select  '"+gubun2+"'||'03' serv_dt from dual  \n"+
						"		      union \n"+
						"		      select  '"+gubun2+"'||'04' serv_dt from dual  \n"+
						"		      union  \n"+
						"		      select  '"+gubun2+"'||'05' serv_dt from dual  \n"+
						"		      union  \n"+
						"		      select  '"+gubun2+"'||'06' serv_dt from dual  \n"+
						"		      union  \n"+
						"		      select  '"+gubun2+"'||'07' serv_dt from dual  \n"+
						"		      union  \n"+
						"		      select  '"+gubun2+"'||'08' serv_dt from dual  \n"+
						"		      union  \n"+
						"		      select  '"+gubun2+"'||'09' serv_dt from dual  \n"+
						"		      union  \n"+
						"		      select  '"+gubun2+"'||'10' serv_dt from dual  \n"+
						"		      union  \n"+
						"		      select  '"+gubun2+"'||'11' serv_dt from dual  \n"+
						"		      union  \n"+
						"		      select  '"+gubun2+"'||'12' serv_dt from dual  \n"+
						"		  ) aa,   \n"+
						"		 ( select a.off_id,  substr(a.ipgodt, 1, 6) serv_dt,  count(*) ip_cnt    from service a          \n"+     
						"		     where a.ipgodt like '"+ gubun2 + "%' \n" +
						"		          and a.off_id ='" + off_id + "'   \n"+
						"		  group by a.off_id,  substr(a.ipgodt, 1, 6) ) a,     \n"+
						"		 ( select a.off_id, substr(a.chulgodt, 1, 6) serv_dt, count(*) ch_cnt   from service a             \n"+
						"		     where a.chulgodt like '"+ gubun2 + "%' \n" +
						"		        and a.off_id  ='" + off_id + "'   \n"+
						"		   group by a.off_id, substr(a.chulgodt, 1, 6) ) b,  \n"+
						"               ( select a.off_id, substr(a.serv_dt, 1, 6) serv_dt, count(*) tot_cnt   from service a           \n"+     
						"	     		where a.serv_dt like '"+ gubun2 + "%' \n" +
						"		        and a.off_id ='" + off_id + "'   \n"+
						"		  group by a.off_id, substr(a.serv_dt,1,6)  ) ta,        \n"+
						"		 (   select  a.off_id,  substr(a.acct_dt,1,6) serv_dt, sum(decode(a.serv_st ,'13', b.our_fault_per*a.r_labor/100, a.r_labor)) r_labor,   \n"+
		                                     "                                   sum(decode(a.serv_st, '13', b.our_fault_per*a.r_j_amt/100, a.r_j_amt)) r_j_amt   from service a,  accident b  \n"+
						"		    where  a.acct_dt like '"+ gubun2 + "%' \n" +
						"		    and a.car_mng_id = b.car_mng_id(+) and a.accid_id  = b.accid_id(+)  \n"+
						"		        and a.off_id ='" + off_id + "'   \n"+
						"		    group by a.off_id , substr(a.acct_dt,1,6) ) c,	 \n"+		    
						"		 ( select a.j_acct, substr(a.pay_dt,1,6) serv_dt , sum(a.j_g_amt) jg_amt, sum(a.j_b_amt) jb_amt     from  mj_jungsan a   \n"+
						"		    where a.pay_dt like '"+ gubun2 + "%' \n" +
						"		      and   a.j_acct ='" + off_id + "'   \n"+
						"		      group by a.j_acct , substr(a.pay_dt,1,6) ) d	 	\n"+
						"		         where aa.serv_dt = a.serv_dt(+) \n"+
						"		          and  aa.serv_dt = b.serv_dt(+) \n"+
						"		          and  aa.serv_dt = ta.serv_dt(+) \n"+
						"		          and  aa.serv_dt = c.serv_dt(+) \n"+
						"		          and  aa.serv_dt = d.serv_dt(+) \n"+					
						"                      order by 1 ";								             
                       
		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
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
		}catch(SQLException e){
			System.out.println("[CusReg_Database:getServjListNew()]"+e);
			System.out.println("[CusReg_Database:getServjListNew()]"+query);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null)	rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return vt;
		}
	}		
				
	
	public Vector getServjList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String off_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		Vector vt = new Vector();		
		
		
		query =     "	select  substr(serv_dt, 5, 2)  serv_mm, count(ipgodt) ip_cnt, count(chulgodt) ch_cnt , count(off_id) tot_cnt, sum(r_labor + r_amt) tot_amt , sum(decode(pay_st4, null, 0, r_labor + r_amt) ) pay_amt \n"+
				"	from ( \n"+
				"	    select a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.serv_id, a.serv_dt,     \n"+
				"	            a.r_labor, a.r_amt,  a.ipgodt, a.chulgodt, \n"+
				"	            a.off_id, b.off_nm,  e.car_no, g.user_nm,       \n"+ 
				"	            decode(p4.j_seq,'','',a.jung_st||'회차') pay_st4, p4.pay_dt pay_dt4 \n"+
				"	             from   service a, serv_off b, cont c, client d, car_reg e,       \n"+
				"	            users g, BRANCH g2 ,  \n"+
				"	            /*정비정산*/(select a.*, a.j_yy||a.j_mm yymm from mj_jungsan a where a.j_g_amt>0 and a.j_yy||a.j_mm > '200812') p4  \n"+
				"	     where  a.serv_dt >= '20080101' \n"+
				"	            and a.off_id=b.off_id and a.off_id  ='" + off_id + "'   \n"+
				"	            and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"+
				"	            and c.client_id=d.client_id \n"+
				"	            and a.car_mng_id=e.car_mng_id       \n"+
				"	            and a.checker=g.user_id \n"+
				"	            and g.br_id=g2.br_id      \n"+
				"	            and a.off_id=p4.j_acct(+) and a.jung_st=p4.j_seq(+) and substr(a.set_dt,1,6)=p4.yymm(+)  \n"+
				"	            and a.rep_amt>0   \n"+
				" ";
				
				String search = "";
				String what = "";
				String dt1 = "";
				String dt2 = "";
		
				if(gubun3.equals("1")){
					query += " and a.serv_dt like '" + gubun2 + "%' ";							
				}else if(gubun3.equals("4")){
					query += " and a.reg_dt like '" + gubun2 + "%' ";							
				}
				
				
				if(s_kd.equals("1"))	what = "upper(nvl(g.br_id||g2.br_nm, ' '))";	
				if(s_kd.equals("2"))	what = "upper(nvl(g.user_nm, ' '))";	
														
				if(!s_kd.equals("") && !t_wd.equals("")){
					query += " and "+what+" like upper('%"+t_wd+"%') ";
				}						
														
				query +=	"	  ) a   \n"+
						"  group by  substr(serv_dt, 5, 2)  order by 1 \n";
								
		
		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();

		//	System.out.println("getServjList = " + query);
			
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
		}catch(SQLException e){
			System.out.println("[CusReg_Database:getServjList()]"+e);
			System.out.println("[CusReg_Database:getServjList()]"+query);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null)	rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return vt;
		}
	}		

	//차량별 예상주행거리 표본리스트
	public Vector getCarDistViewList(String car_mng_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		Vector vt = new Vector();		
				
		query = " select * from v_dist where car_mng_id='"+car_mng_id+"' order by nvl(reg_dt,tot_dt) ";
						
		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
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


		}catch(SQLException e){
			System.out.println("[CusReg_Database:getCarDistViewList()]"+e);
			System.out.println("[CusReg_Database:getCarDistViewList()]"+query);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null)	rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return vt;
		}
	}		



//고객지원-차령만료예정현황-배기량표시
	public String getCar_dpm(String car_mng_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String dpm = "";

		query = "SELECT dpm FROM car_reg WHERE car_mng_id=?  ";
		
		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
		
			rs = pstmt.executeQuery();
			while(rs.next()){
				dpm = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[CusReg_Database:getCar_dpm]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null)	rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return dpm;
		}
	}


	/**
	*	 car_reg 계기판 교환 정보 update.
	*/
	public int updateCarDistCng(String car_mng_id, String add_cng, String user_id ){
		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		int result = 0;
				
		query = " UPDATE car_reg SET  dist_cng = dist_cng  || '" +  add_cng + "' ,	update_id	= ?,	update_dt	= to_char(sysdate,'YYYYMMDD') "+				
				" WHERE car_mng_id=? ";
		
		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
		
			pstmt.setString(1, user_id);
			pstmt.setString(2, car_mng_id);
								
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		}catch(Exception e){
			System.out.println("[CusReg_Database:updateCarDistCng]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
			conn.setAutoCommit(true);
              		  if(pstmt != null) pstmt.close();
				
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}
	}


	  /**
     * 구조장치변경사항 등록. insertCarCha(car_mng_id, serv_id,  serv_dt, serv_st, b_dist, a_dist, cha_nm, off_nm,rep_cont );
     */
    public int insertCarCha(String car_mng_id, String serv_id, String serv_dt,  String b_dist, String a_dist, String cha_nm, String off_nm, String rep_cont ){
        getConnection();
        PreparedStatement pstmt = null;
        String query = "";
       
        int result = 0;
                    
        query="INSERT INTO CAR_CHA(CAR_MNG_ID,SEQ_NO,SERV_ID, CHA_ST, CHA_ST_DT, CHA_ITEM, CHA_NM, OFF_NM, B_DIST, A_DIST  )\n"
            + "SELECT '" + car_mng_id + "',nvl(max(SEQ_NO)+1,1), ?,  '4' , replace(?, '-', ''), ?, ?, ?, ?, ? \n"
            + "FROM CAR_CHA WHERE CAR_MNG_ID='" + car_mng_id + "'\n";
            
       try{
            conn.setAutoCommit(false);
            
            pstmt = conn.prepareStatement(query);

            pstmt.setString(1, serv_id);   //계기판 변경 내용은 service table에서 
            pstmt.setString(2, serv_dt);   //계기판 변경 내용은 service table에서 
            pstmt.setString(3, rep_cont);   //계기판 변경 내용은 service table에서 
            pstmt.setString(4, cha_nm);   //계기판 변경 내용은 service table에서 
            pstmt.setString(5, off_nm);   //계기판 변경 내용은 service table에서 
            pstmt.setInt(6, AddUtil.parseInt(b_dist) );   //계기판 변경 내용은 service table에서 
            pstmt.setInt(7, AddUtil.parseInt(a_dist) );   //계기판 변경 내용은 service table에서 
                         
            result = pstmt.executeUpdate();
             
            pstmt.close();
            conn.commit();
       
       	}catch(Exception e){
			System.out.println("[CusReg_Database:updateCarDistCng]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
			conn.setAutoCommit(true);
              		  if(pstmt != null) pstmt.close();
				
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}
	}
     
	
	/**
	 * 차량관리번호, 서비스번호로 정비업체조회 - 명진 정비비 관련 .
	 */
	public String getServCarNo(String car_mng_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String car_no = "";

		query = "SELECT car_no FROM car_reg WHERE car_mng_id=? ";
		
		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);		
			rs = pstmt.executeQuery();
			while(rs.next()){
				car_no = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[CusReg_Database:getServCarNo]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null)	rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return car_no;
		}
	}
	
	
	/*----------------자동차 정비부품-------------------------------------------------------*/
	/**
    * excel  견적서 ; 부품,작업 등록 2004.7.26.
    */
   
	public int insertExcelServ(ExcelBean bean)
	{

		getConnection();
		PreparedStatement pstmt = null;		
		String query = "";
		int result = 0;		

		query  = " INSERT INTO gtt_excel ("+
				 "              cell01, cell02, cell03, cell04, cell05, cell06, cell07, "+
				 "              cell08, cell09, cell10, cell11, cell12, cell13, cell14, cell15, "+
				 "             cell16, cell17, cell18, cell19 , cell20  , reg_dt  "+
				 " 	           ) VALUES ( "+
				 "               ?,?,?,?,?,?,?,  ?,?,?,?,?,?,?,?,  ?,?,?,?,? , sysdate ) "+
				 "             )";

			try{
				conn.setAutoCommit(false);

				pstmt = conn.prepareStatement(query);
			
				pstmt.setString	(1,  bean.getCell01	());
				pstmt.setString	(2,  bean.getCell02	());
				pstmt.setString	(3,  bean.getCell03	());
				pstmt.setString	(4,  bean.getCell04	());
				pstmt.setString	(5,  bean.getCell05	());
				pstmt.setString	(6,  bean.getCell06	());
				pstmt.setString	(7,  bean.getCell07	());
				pstmt.setString	(8,  bean.getCell08	());
				pstmt.setString	(9,  bean.getCell09	());
				pstmt.setString	(10,  bean.getCell10	());
				pstmt.setString	(11,  bean.getCell11	());
				pstmt.setString	(12,  bean.getCell12	());
				pstmt.setString	(13,  bean.getCell13	());
				pstmt.setString	(14,  bean.getCell14	());
				pstmt.setString	(15,  bean.getCell15	());
				pstmt.setString	(16,  bean.getCell16	());
				pstmt.setString	(17,  bean.getCell17	());
				pstmt.setString	(18,  bean.getCell18	());
				pstmt.setString	(19,  bean.getCell19	());
				pstmt.setString	(20,  bean.getCell20	());
				
	//			System.out.println("gtt_excel 1 =" + bean.getCell01());
	//			System.out.println("gtt_excel 2=" + bean.getCell02());
	//			System.out.println("gtt_excel 3=" + bean.getCell03());
	//			System.out.println("gtt_excel 4=" + bean.getCell04());
	//			System.out.println("gtt_excel 5=" + bean.getCell05());
	//			System.out.println("gtt_excel 6=" + bean.getCell06());
			
				result = pstmt.executeUpdate();			
	//			System.out.println(result);
			   pstmt.close();
            conn.commit();
       
       	}catch(Exception e){
			System.out.println("[CusReg_Database:insertExcelServ]"+e);
			e.printStackTrace();
			conn.rollback();
			result = 0;	
		}finally{
			try{
				conn.setAutoCommit(true);
            if(pstmt != null) pstmt.close();
				
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}
	}
	
	
		
	/** 
	 *	  정비 excel  프로시저호출 
	 */

	public String call_sp_insertExcelService(String car_mng_id, String serv_id, String user_id, String reg_code)
	{
		getConnection();
     
    	String query = "{CALL P_INSERT_EXCEL_SERVICE (?,?,?,?,?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
						
			cstmt = conn.prepareCall(query);
					
			cstmt.setString(1, car_mng_id);
			cstmt.setString(2, serv_id);
			cstmt.setString(3, user_id);
			cstmt.setString(4, reg_code);
			cstmt.registerOutParameter( 5, java.sql.Types.VARCHAR );
			cstmt.execute();
			sResult = cstmt.getString(5); // 결과값
			
			cstmt.close();
		
		} catch (SQLException e) {
			System.out.println("[CusReg_Database:call_sp_insertExcelService]"+e);
			e.printStackTrace();
		} finally {
			try{
            if(cstmt != null)	cstmt.close();
            }catch(SQLException _ignored){}
			closeConnection();			
		}
		return sResult;
	}
		
	//정비 문서처리 리스트 조회  - 주거래처 (20211022 수정 - 결재문서처리)
	public Vector getCarServDocList(String s_kd, String t_wd, String gubun1, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String sub_query = "";
		String query = "";

		sub_query = " select \n"+
				" b.doc_id as req_code, a.set_dt jung_dt, count(a.serv_id) cnt,  sum(a.tot_amt) che_amt, \n"+
				" min(substr(a.serv_dt,1,8)) min_dt, max(substr(a.serv_dt,1,8)) max_dt, max(a.off_id) off_nm  \n"+
				" from service  a,\n"+
				" (select b.doc_id, a.doc_step  from doc_settle a, ( select doc_id from doc_settle  where doc_st = '54' group by doc_id ) b  where a.doc_id = b.doc_id) b \n"+
				" where a.req_code=b.doc_id and a.set_dt is not null \n";

		if(gubun1.equals("1"))							sub_query += " and a.set_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun1.equals("4"))						sub_query += " and a.set_dt like to_char( add_months( sysdate, - 1 ), 'YYYYMM' )||'%'";
		else if(gubun1.equals("3"))						sub_query += " and ( a.set_dt like to_char(sysdate,'YYYY')||'%' or  b.doc_step <> '3'  ) "; //미결이 있따면 포함 
		else if(gubun1.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	sub_query += " and a.set_dt like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) sub_query += " and a.set_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		sub_query += " group by  a.set_dt, b.doc_id";

		query = " select \n"+
				" a.*, b.user_id1, b.user_id2, b.user_id3, c.user_nm as user_nm1, d.user_nm as user_nm2, e.user_nm as user_nm3,  b.user_dt1, b.user_dt2, b.user_dt3, b.doc_no, b.etc  \n"+
				" from ("+sub_query+") a, (select * from doc_settle where doc_st='54') b, users c, users d , users e \n"+
				" where a.req_code=b.doc_id(+) and b.user_id1=c.user_id(+) and b.user_id2=d.user_id(+) and b.user_id3=e.user_id(+) \n"+
				" order by a.jung_dt desc";

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
			System.out.println("[CusReg_Database:getCarServReqDocList]\n"+e);
			System.out.println("[CusReg_Database:getCarServReqDocList]\n"+query);
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
	public Vector getCarServDocList2(String req_code, String pay_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" a.*, c.user_nm as user_nm1, d.user_nm as user_nm2, b.user_dt1, b.user_dt2, v.firm_nm , \n"+
				"       decode(a.serv_st,'1','순회점검','2','일반정비','3','보증정비','7','재리스정비','4','운행자차','5','사고자차', '12', '해지정비','13','자차') serv_st_nm, \n"+
				" cr.car_no, cr.car_nm  "+
				" from service a, (select * from doc_settle where doc_st='54') b, users c, users d , cont_n_view v, car_reg cr  "+		
				" where a.req_code=b.doc_id(+) and b.user_id1=c.user_id(+) and b.user_id2=d.user_id(+) and a.rent_l_cd = v.rent_l_cd "+
				" and v.car_mng_id = cr.car_mng_id(+) and a.set_dt is not null  and b.doc_id='"+req_code+"'";//and a.pay_dt is null 

		if(!pay_dt.equals(""))	query +=" and a.acct_dt = replace('"+pay_dt+"','-','')";
//		else					query +=" and a.pay_dt is null";

		query += " order by a.serv_dt, a.rent_l_cd ";
		
	//	System.out.println("getCarServDocList2= "+ query);
			
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
			System.out.println("[CusReg_Database:getCarServDocList2]\n"+e);
			System.out.println("[CusReg_Database:getCarServDocList2]\n"+query);
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
	
	public Hashtable getCar_cha(String car_mng_id, String serv_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = " SELECT * FROM car_cha WHERE car_mng_id=? and serv_id = ?  ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
			pstmt.setString(2,serv_id);
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
		}catch(Exception e){
			System.out.println("[getCar_cha(String car_mng_id, String serv_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return ht;
		}
	}
		
	
	public Hashtable getMj_jungsan(String acct, String yy, String mm, String seq){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		
		String query = " SELECT a.*  FROM mj_jungsan a where a.j_acct= ? and a.j_yy = ? and a.j_mm = ? and a.j_seq = ?  ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,acct);
			pstmt.setString(2,yy);
			pstmt.setString(3,mm);
			pstmt.setString(4,seq);
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
		}catch(Exception e){
			System.out.println("[getMj_jungsan(String acct, String yy, String mm, String seq)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return ht;
		}
	}
	
}

