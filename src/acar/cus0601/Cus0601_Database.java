/**
 * 고객관리 정비업체관리
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2004. 3. 10. 수.
 * @ last modify date : 
 */
package acar.cus0601;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;
import acar.common.*;
import acar.car_service.*;
import acar.exception.DatabaseException;
import acar.exception.DataSourceEmptyException;

public class Cus0601_Database
{
	private Connection conn = null;
	public static Cus0601_Database db;
	
	public static Cus0601_Database getInstance()
	{
		if(Cus0601_Database.db == null)
			Cus0601_Database.db = new Cus0601_Database();
		return Cus0601_Database.db;
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
	    	System.out.println("I can't get a connection........");
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
     * 정비업체 빈 생성 2004.03.11.
     */
    private ServOffBean makeServOffListBean(ResultSet results) throws DatabaseException {

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
			bean.setServ_cnt(results.getInt("SERV_CNT"));
			bean.setServ_amt(results.getInt("SERV_AMT"));
			
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}
	/**
     * 정비업체 빈 생성 2004.03.11.
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
			bean.setAcc_nm(results.getString("ACC_NM"));
			bean.setNote(results.getString("NOTE"));
			bean.setVen_code(results.getString("VEN_CODE"));
			bean.setEst_st(results.getString("EST_ST"));
			bean.setSsn(results.getString("SSN"));
			
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}

	/**
     * 정비내역 리스트 빈 생성 2004.03.12.
     */
    private ServListBean makeServListBean(ResultSet results) throws DatabaseException {

        try {
            ServListBean bean = new ServListBean();

		    bean.setCar_mng_id(results.getString("CAR_MNG_ID")); 
			bean.setCar_no(results.getString("CAR_NO")); 
			bean.setServ_id(results.getString("SERV_ID")); 
			bean.setAccid_id(results.getString("ACCID_ID")); 
			bean.setServ_dt(results.getString("SERV_DT")); 
			bean.setServ_st(results.getString("SERV_ST")); 
			bean.setChecker(results.getString("CHECKER")); 
			bean.setTot_amt(results.getInt("TOT_AMT")); 
			bean.setSet_dt(results.getString("SET_DT")); 
			bean.setRep_item(results.getString("REP_ITEM")); 
			bean.setRep_cont(results.getString("REP_CONT"));
			bean.setFirm_nm(results.getString("FIRM_NM"));
			
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}
    
    /**
	*	정비업체 리스트 2004.03.11.
	*	2016.05.12. - sql 문 수정. 
	*	수정자 : 성승현
	*  use_yn -> Y:사용 N:미사용
	*/
	public ServOffBean[] getServ_offList2(String s_kd, String t_wd, String sort_gubun, String sort, String off_type, String use_yn){

		getConnection();
		Collection<ServOffBean> col = new ArrayList<ServOffBean>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String subQuery = " ";
		String orderQuery = "";

		subQuery = " AND nvl(off_type, '1') = '" + off_type + "'" ;
		
		switch (AddUtil.parseInt(s_kd))
		{
			case 0 : subQuery = subQuery + " "; break;
			case 1 : subQuery = subQuery + " AND off_nm like '%"+t_wd+"%' "; break;
			//case 2 : subQuery = " AND car_comp_id = '"+t_wd+"' "; break;
			//case 3 : subQuery = " AND off_st = '"+t_wd+"' "; break;
			case 4 : subQuery = subQuery + " AND own_nm like '%"+t_wd+"%' "; break;
			case 5 : subQuery = subQuery + " AND ent_no like '%"+t_wd+"%' "; break;
			case 6 : subQuery = subQuery + " AND off_sta like '%"+t_wd+"%' "; break;
			case 7 : subQuery = subQuery + " AND off_item like '%"+t_wd+"%' "; break;
			case 8 : subQuery = subQuery + " AND off_addr like '%"+t_wd+"%' "; break;
			default : subQuery = subQuery + " "; break;
		}
		
		if(use_yn.equals("Y")){
			subQuery = subQuery+ " And nvl(use_yn, 'Y')='Y' ";
		}else if(use_yn.equals("N")){
			subQuery = subQuery+ " And use_yn='N' ";
		}			
					
		//정렬
		if(sort_gubun.equals("0")){
			orderQuery = " ORDER BY off_nm "+sort;
		}else if(sort_gubun.equals("1")){
			orderQuery = " ORDER BY own_nm "+sort;
		}else if(sort_gubun.equals("2")){
			orderQuery = " ORDER BY ent_no "+sort;
		}else if(sort_gubun.equals("3")){
			orderQuery = " ORDER BY off_addr "+sort;
		}else if(sort_gubun.equals("4")){
//			orderQuery = " ORDER BY serv_dt "+sort;
		}else if(sort_gubun.equals("5")){
			orderQuery = " ORDER BY serv_cnt "+sort;
		}else if(sort_gubun.equals("6")){
//			orderQuery = " ORDER BY init_reg_dt "+sort;
		}else{
			orderQuery = "";
		}			

		query = "SELECT a.off_id OFF_ID, a.car_comp_id CAR_COMP_ID, " + 
				"   decode(a.off_nm, '일등전국탁송(부산)','에프앤티코리아(부산)','일등전국탁송(대구)','에프앤티코리아(대구)','일등전국탁송(광주)','에프앤티코리아(광주)',a.off_nm) OFF_NM," +
				"   a.off_st OFF_ST, a.own_nm OWN_NM, a.ent_no ENT_NO, \n"+
				"	a.off_sta OFF_STA, a.off_item OFF_ITEM, a.off_tel OFF_TEL, a.off_fax OFF_FAX, a.homepage HOMEPAGE, a.off_post OFF_POST, a.off_addr OFF_ADDR, a.bank BANK, a.acc_no ACC_NO, a.acc_nm ACC_NM, a.note NOTE, a.num SERV_CNT, b.tot SERV_AMT \n"+
				"  FROM (SELECT e.*, nvl(f.cnt,0) num \n"+
				"		   FROM (select off_id, count(0) cnt from service group by off_id ) f, serv_off e \n"+
				"		  WHERE f.off_id(+) = e.off_id) a, \n"+
				"		(SELECT off_id, sum(nvl(tot_amt,0)) tot from service group by off_id) b \n"+
				" WHERE a.off_id = b.off_id(+) "+subQuery+orderQuery;

		try{
			

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();

			while(rs.next()){
				col.add(makeServOffListBean(rs));
			}
			rs.close();
			pstmt.close();	

		}catch(SQLException e){
			System.out.println("[Cus0601_Database:getServ_offList(String s_kd, String t_wd, String sort_gubun, String sort)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return (ServOffBean[])col.toArray(new ServOffBean[0]);
		}		
	}

	/**
	*	정비업체 리스트 2004.03.11.
	*	2004.03.17. - sql 문 수정. 
	*  off_type -> 1:정비업체 2:탁송업체 5:세차업체
	*/
	public ServOffBean[] getServ_offList(String s_kd, String t_wd, String sort_gubun, String sort, String off_type){

		getConnection();
		Collection<ServOffBean> col = new ArrayList<ServOffBean>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String subQuery = " ";
		String orderQuery = "";

		subQuery = " AND nvl(off_type, '1') = '" + off_type + "'" ;
		
		switch (AddUtil.parseInt(s_kd))
		{
			case 0 : subQuery = subQuery + " "; break;
			case 1 : subQuery = subQuery + " AND off_nm like '%"+t_wd+"%' "; break;
			//case 2 : subQuery = " AND car_comp_id = '"+t_wd+"' "; break;
			//case 3 : subQuery = " AND off_st = '"+t_wd+"' "; break;
			case 4 : subQuery = subQuery + " AND own_nm like '%"+t_wd+"%' "; break;
			case 5 : subQuery = subQuery + " AND ent_no like '%"+t_wd+"%' "; break;
			case 6 : subQuery = subQuery + " AND off_sta like '%"+t_wd+"%' "; break;
			case 7 : subQuery = subQuery + " AND off_item like '%"+t_wd+"%' "; break;
			case 8 : subQuery = subQuery + " AND off_addr like '%"+t_wd+"%' "; break;
			default : subQuery = subQuery + " "; break;
		}
		
		//정렬
		if(sort_gubun.equals("0")){
			orderQuery = " ORDER BY off_nm "+sort;
		}else if(sort_gubun.equals("1")){
			orderQuery = " ORDER BY own_nm "+sort;
		}else if(sort_gubun.equals("2")){
			orderQuery = " ORDER BY ent_no "+sort;
		}else if(sort_gubun.equals("3")){
			orderQuery = " ORDER BY off_addr "+sort;
		}else if(sort_gubun.equals("4")){
//			orderQuery = " ORDER BY serv_dt "+sort;
		}else if(sort_gubun.equals("5")){
			orderQuery = " ORDER BY serv_cnt "+sort;
		}else if(sort_gubun.equals("6")){
//			orderQuery = " ORDER BY init_reg_dt "+sort;
		}else{
			orderQuery = "";
		}			

		query = "SELECT a.off_id OFF_ID, a.car_comp_id CAR_COMP_ID, a.off_nm OFF_NM, a.off_st OFF_ST, a.own_nm OWN_NM, a.ent_no ENT_NO, \n"+
				"	a.off_sta OFF_STA, a.off_item OFF_ITEM, a.off_tel OFF_TEL, a.off_fax OFF_FAX, a.homepage HOMEPAGE, a.off_post OFF_POST, a.off_addr OFF_ADDR, a.bank BANK, a.acc_no ACC_NO, a.acc_nm ACC_NM, a.note NOTE, a.num SERV_CNT, b.tot SERV_AMT \n"+
				"  FROM (SELECT e.*, nvl(f.cnt,0) num \n"+
				"		   FROM (select off_id, count(0) cnt from service group by off_id ) f, serv_off e \n"+
				"		  WHERE f.off_id(+) = e.off_id) a, \n"+
				"		(SELECT off_id, sum(nvl(tot_amt,0)) tot from service group by off_id) b \n"+
				" WHERE a.off_id = b.off_id(+) "+subQuery+orderQuery;

		try{
			

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();

			while(rs.next()){
				col.add(makeServOffListBean(rs));
			}
			rs.close();
			pstmt.close();	

		}catch(SQLException e){
			System.out.println("[Cus0601_Database:getServ_offList(String s_kd, String t_wd, String sort_gubun, String sort)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return (ServOffBean[])col.toArray(new ServOffBean[0]);
		}		
	}

	/**
	*	정비업체 상세정보 2004.03.11.
	*/
	public ServOffBean getServOff(String off_id){
		getConnection();
		ServOffBean bean = new ServOffBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = "SELECT off_id, car_comp_id, off_nm, off_st, own_nm, ent_no, off_sta, off_item, off_tel, off_fax, homepage, off_post, off_addr, bank, acc_no, acc_nm, note, ven_code, est_st ,ssn "+
				" FROM serv_off WHERE off_id = ? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,off_id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				bean = makeServOffBean(rs);
			}
			rs.close();
			pstmt.close();	
		}catch(SQLException e){
			System.out.println("[Cus0601_Database:getServOff(String off_id)]"+e);
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
	*	정비업체정보 수정 2004.03.12.
	*/
	public int updateServOff(ServOffBean bean){
		getConnection();
		PreparedStatement pstmt = null;
		int result = -1;
		String query = "";

		query = "UPDATE serv_off SET "+
				" car_comp_id=?,off_nm=?,off_st=?,own_nm=?,ent_no=replace(?,'-',''),off_sta=?,off_item=?,"+
				" off_tel=?,off_fax=?,off_post=?,off_addr=?,bank=?,acc_no=?,acc_nm=?,note=?,"+
				" upd_dt=to_char(sysdate,'yyyymmdd'),upd_id=?, br_id=?, ven_code=?, bank_cd=?, est_st=? , ssn = ? "+
				" WHERE off_id = ? ";

		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getCar_comp_id());
			pstmt.setString(2, bean.getOff_nm()		);
			pstmt.setString(3, bean.getOff_st()		);
			pstmt.setString(4, bean.getOwn_nm()		);
			pstmt.setString(5, bean.getEnt_no()		);
			pstmt.setString(6, bean.getOff_sta()	);
			pstmt.setString(7, bean.getOff_item()	);
			pstmt.setString(8, bean.getOff_tel()	);
			pstmt.setString(9, bean.getOff_fax()	);
			pstmt.setString(10,bean.getOff_post()	);
			pstmt.setString(11,bean.getOff_addr()	);
			pstmt.setString(12,bean.getBank()		);
			pstmt.setString(13,bean.getAcc_no()		);
			pstmt.setString(14,bean.getAcc_nm().trim());
			pstmt.setString(15,bean.getNote()		);
			pstmt.setString(16,bean.getUpd_id()		);
			pstmt.setString(17,bean.getBr_id()		);
			pstmt.setString(18,bean.getVen_code()	);
			pstmt.setString(19,bean.getBank_cd()	);
			pstmt.setString(20,bean.getEst_st()	);
			pstmt.setString(21,bean.getSsn()	);
			pstmt.setString(22,bean.getOff_id()		);

			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		}catch(SQLException e){
			System.out.println("[Cus0601_Database:updateServ_off(ServOffBean bean)]"+e);
			System.out.println("[bean.getCar_comp_id()	]"+bean.getCar_comp_id());
			System.out.println("[bean.getOff_nm()		]"+bean.getOff_nm()		);
			System.out.println("[bean.getOff_st()		]"+bean.getOff_st()		);
			System.out.println("[bean.getOwn_nm()		]"+bean.getOwn_nm()		);
			System.out.println("[bean.getEnt_no()		]"+bean.getEnt_no()		);
			System.out.println("[bean.getOff_sta()		]"+bean.getOff_sta()	);
			System.out.println("[bean.getOff_item()		]"+bean.getOff_item()	);
			System.out.println("[bean.getOff_tel()		]"+bean.getOff_tel()	);
			System.out.println("[bean.getOff_fax()		]"+bean.getOff_fax()	);
			System.out.println("[bean.getOff_post()		]"+bean.getOff_post()	);
			System.out.println("[bean.getOff_addr()		]"+bean.getOff_addr()	);
			System.out.println("[bean.getBank()			]"+bean.getBank()		);
			System.out.println("[bean.getAcc_no()		]"+bean.getAcc_no()		);
			System.out.println("[bean.getAcc_nm()		]"+bean.getAcc_nm()		);
			System.out.println("[bean.getNote()			]"+bean.getNote()		);
			System.out.println("[bean.getUpd_id()		]"+bean.getUpd_id()		);
			System.out.println("[bean.getBr_id()		]"+bean.getBr_id()		);
			System.out.println("[bean.getVen_code()		]"+bean.getVen_code()	);
			System.out.println("[bean.getOff_id()		]"+bean.getOff_id()		);

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
	*	정비업체정보 삭제 2004.04.07.
	*/
	public int deleteServOff(String off_id){
		getConnection();
		PreparedStatement pstmt = null;
		int result = -1;
		String query = "";

		query = "DELETE serv_off WHERE off_id = ? ";

		try{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,off_id);

			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		}catch(SQLException e){
			System.out.println("[Cus0601_Database:deleteServ_off(String off_id)]"+e);
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
	*	정비업체정보 등록 2004.03.17.
	*/
	public int insertServOff(ServOffBean bean){
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
        ResultSet rs = null;
		int result = -1;
		String off_id = "";
		String query, query1 = "";

		query1= "SELECT NVL(LPAD(MAX(off_id)+1,6,'0'),'000001') FROM serv_off";
		query = " INSERT INTO serv_off "+
				" (off_id, car_comp_id, off_nm, off_st, own_nm, ent_no, off_sta, off_item, off_tel, off_fax, "+
				"  homepage, off_post, off_addr, bank, acc_no, acc_nm, note, reg_dt, reg_id, upd_dt, "+
				"  upd_id, br_id, off_type, ven_code, bank_cd, est_st, ssn )"+
			    " VALUES"+
			    " (?,?,?,?,?,replace(?,'-',''),?,?,?,?,"+
				"  ?,?,?,?,?,?,?,to_char(sysdate,'yyyymmdd'),?,?,"+
				"  ?,?,?,?,?,?, ?) ";

		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query1);
			rs = pstmt.executeQuery();

            if(rs.next()){
				off_id = rs.getString(1);
            }
			rs.close();
			pstmt.close();	
			
            pstmt2 = conn.prepareStatement(query);
			pstmt2.setString(1, off_id.trim());
			pstmt2.setString(2, bean.getCar_comp_id().trim()); 
			pstmt2.setString(3, bean.getOff_nm().trim()); 
			pstmt2.setString(4, bean.getOff_st().trim()); 
			pstmt2.setString(5, bean.getOwn_nm().trim()); 
			pstmt2.setString(6, bean.getEnt_no().trim()); 
			pstmt2.setString(7, bean.getOff_sta().trim()); 
			pstmt2.setString(8, bean.getOff_item().trim()); 
			pstmt2.setString(9, bean.getOff_tel().trim()); 
			pstmt2.setString(10, bean.getOff_fax().trim()); 
			pstmt2.setString(11, bean.getHomepage().trim()); 
			pstmt2.setString(12, bean.getOff_post().trim()); 
			pstmt2.setString(13, bean.getOff_addr().trim()); 
			pstmt2.setString(14, bean.getBank().trim()); 
			pstmt2.setString(15, bean.getAcc_no().trim()); 
			pstmt2.setString(16, bean.getAcc_nm().trim()); 
			pstmt2.setString(17, bean.getNote());
			pstmt2.setString(18, bean.getReg_id());	//등록자
			pstmt2.setString(19, bean.getUpd_dt());	//수정일
			pstmt2.setString(20, bean.getUpd_id());	//수정자
			pstmt2.setString(21, bean.getBr_id());	//영업소코드
			pstmt2.setString(22, bean.getOff_type());	//1:정비업체, 2:탁송업체
			pstmt2.setString(23, bean.getVen_code());	//네오엠거래처          
			pstmt2.setString(24, bean.getBank_cd().trim()); 
			pstmt2.setString(25, bean.getEst_st().trim()); 
			pstmt2.setString(26, bean.getSsn().trim()); 
			result = pstmt2.executeUpdate();			
			pstmt2.close();

			conn.commit();

		}catch(Exception e){
			System.out.println("[Cus0601_Database:insertServOff(ServOffBean bean)]"+e);
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
	*	정비업체별 정비내역 2004.03.12.
	*/
	public ServListBean[] getServList(String s_kd, String t_wd, String sort_gubun, String sort, String off_id, String year, String month){

		getConnection();
		Collection<ServListBean> col = new ArrayList<ServListBean>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String subQuery = "";
		String orderQuery = "";

		//검색 0:전체, 1:정비일자, 2:정비구분, 3:차량번호, 4:점검자, 5:정비품목, 6:결제일
		switch (AddUtil.parseInt(s_kd))
		{
			case 0 : subQuery = " "; break;
			case 1 : subQuery = " AND a.serv_dt like '"+t_wd+"%' "; break;
			case 2 : subQuery = " AND a.serv_st = '"+t_wd+"' "; break;
			case 3 : subQuery = " AND b.car_no like '%"+t_wd+"%' "; break;
			case 4 : subQuery = " AND a.checker like '%"+t_wd+"%' "; break;
			case 5 : subQuery = " AND a.rep_cont like '%"+t_wd+"%' "; break;
			case 6 : subQuery = " AND a.set_dt like '"+t_wd+"%' "; break;
			default : subQuery = " "; break;
		}
		
		//정렬 0:정비일자, 1:차량번호, 2:점검자, 3:정비품목, 4:정비비, 5:결제일
		if(sort_gubun.equals("0")){
			orderQuery = " ORDER BY serv_dt "+sort;
		}else if(sort_gubun.equals("1")){
			orderQuery = " ORDER BY car_no "+sort;
		}else if(sort_gubun.equals("2")){
			orderQuery = " ORDER BY checker "+sort;
		}else if(sort_gubun.equals("3")){
			orderQuery = " ORDER BY rep_cont "+sort;
		}else if(sort_gubun.equals("4")){
			orderQuery = " ORDER BY tot_amt "+sort;
		}else if(sort_gubun.equals("5")){
			orderQuery = " ORDER BY set_dt "+sort;
		}else{
			orderQuery = " ORDER BY serv_dt desc";
		}

		//year, month
		if(month.equals("")){
			subQuery += " AND serv_dt like '"+year+"%'";
		}else{
			subQuery += " AND serv_dt like '"+year+month+"%'";
		}

		query = "SELECT a.car_mng_id CAR_MNG_ID, b.car_no CAR_NO, a.serv_id SERV_ID, a.accid_id ACCID_ID, nvl(a.serv_dt,a.accid_dt) SERV_DT, a.serv_st SERV_ST, a.checker CHECKER, a.tot_amt TOT_AMT, a.set_dt SET_DT, a.rep_item REP_ITEM, a.rep_cont REP_CONT, NVL(d.firm_nm,client_nm) FIRM_NM "+
				" FROM service a, car_reg b, cont c, client d  "+
				" WHERE a.car_mng_id = b.car_mng_id "+
				" AND a.rent_mng_id = c.rent_mng_id "+
				" AND a.rent_l_cd = c.rent_l_cd "+ 
				" AND c.client_id = d.client_id "+
				" AND a.off_id = ? "+
				subQuery+
				orderQuery;
		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,off_id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				col.add(makeServListBean(rs));
			}
			rs.close();
			pstmt.close();	
		}catch(SQLException e){
			System.out.println("[Cus0601_Database:getServList(String s_kd, String t_wd, String sort_gubun, String sort, String off_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return (ServListBean[])col.toArray(new ServListBean[0]);
		}		
	}

	/**
	*	정비업체 리스트 2009.05.29.
	*  off_type -> 1:정비업체 2:탁송업체 3:용품업체
	*/

	public Vector getServ_offList_20090528(String s_kd, String t_wd, String gubun1, String sort_gubun, String sort, String off_type, String br_id){

		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String brid = "";
		if(br_id.equals("S1")) brid = "서울";
		if(br_id.equals("B1")) brid = "부산";
		if(br_id.equals("D1")) brid = "대전";
		if(br_id.equals("I1")) brid = "인천";
		if(br_id.equals("K1")) brid = "파주";
		if(br_id.equals("K2")) brid = "포천";
		if(br_id.equals("N1")) brid = "김해";

		
		query = " select a.*, decode(a.off_st,'6','기타',a.off_st||'급') off_st_nm, a.bank, a.acc_no , a.acc_nm, \n"+
			    "        nvl(b.serv_cnt,0) as serv_cnt, nvl(b.serv_amt,0) as serv_amt, b.serv_dt, c.nm as car_comp_nm \n"+
				" from   serv_off a, (select off_id, count(0) serv_cnt, sum(tot_amt) serv_amt, min(serv_dt) serv_dt from service group by off_id) b, (select * from code where c_st='0001') c \n"+
				" where  a.off_id=b.off_id(+) \n"+
				"        and a.car_comp_id=c.code(+)"+
				" ";
		
		if(!off_type.equals("")) query += " AND nvl(a.off_type, '1') = '" + off_type + "'" ;
		
		if (!gubun1.equals("")) query += " AND c.code = '" + gubun1 + "'" ;

		if (!br_id.equals("")) query += " AND a.off_addr like '%" + brid + "%'" ;



		if(!t_wd.equals("")){
			if(s_kd.equals("1"))	query += " and upper(a.off_nm) like upper('%"+t_wd+"%')"; //상호
		//	if(s_kd.equals("2"))	query += " and c.nm like '%"+t_wd+"%'";//지정업체
			if(s_kd.equals("3"))	query += " and decode(a.off_st,'6','기타',a.off_st||'급') like '%"+t_wd+"%'";//등급
			if(s_kd.equals("4"))	query += " and a.own_nm like '%"+t_wd+"%'";//대표자
			if(s_kd.equals("5"))	query += " and a.ent_no like '%"+t_wd+"%'";//사업자번호
			if(s_kd.equals("6"))	query += " and a.off_sta like '%"+t_wd+"%'";//업태
			if(s_kd.equals("7"))	query += " and a.off_item like '%"+t_wd+"%'";//종목
			if(s_kd.equals("8"))	query += " and a.off_addr like '%"+t_wd+"%'";//주소
			if(s_kd.equals("9"))	query += " and a.off_tel like '%"+t_wd+"%'";//전화
			if(s_kd.equals("10"))	query += " and a.off_fax like '%"+t_wd+"%'";//팩스
		}

		if(sort_gubun.equals("0"))	query += " order by a.off_nm "+sort;//상호
		if(sort_gubun.equals("1"))	query += " order by a.own_nm "+sort;//대표자
		if(sort_gubun.equals("2"))	query += " order by a.ent_no "+sort;//사업자번호
		if(sort_gubun.equals("3"))	query += " order by a.off_addr "+sort;//주소
		if(sort_gubun.equals("4"))	query += " order by b.serv_dt "+sort;//거래개시일
		if(sort_gubun.equals("5"))	query += " order by nvl(b.serv_cnt,0) "+sort;//정비건수



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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Cus0601_Database:getServ_offList_20090528(String s_kd, String t_wd, String sort_gubun, String sort)]"+e);
			System.out.println(query);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return vt;
		}		
	}

}