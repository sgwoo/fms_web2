/**
 * 명함관리
 * @ author : 
 * @ e-mail : 
 * @ create date : 
 * @ last modify date : 
 */
package acar.partner;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;
import acar.common.*;
import acar.car_service.*;
import acar.cus0601.*;
import acar.exception.DatabaseException;
import acar.exception.DataSourceEmptyException;

public class Serv_EmpDatabase
{
	private Connection conn = null;
	public static Serv_EmpDatabase db;
	
	public static Serv_EmpDatabase getInstance()
	{
		if(Serv_EmpDatabase.db == null)
			Serv_EmpDatabase.db = new Serv_EmpDatabase();
		return Serv_EmpDatabase.db;
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
			bean.setBr_id(results.getString("BR_ID"));
			bean.setOff_tel(results.getString("OFF_TEL")); 
			bean.setOff_fax(results.getString("OFF_FAX")); 
			bean.setOff_post(results.getString("OFF_POST")); 
			bean.setOff_addr(results.getString("OFF_ADDR")); 
			bean.setBank(results.getString("BANK")); 
			bean.setAcc_no(results.getString("ACC_NO")); 
			bean.setNote(results.getString("NOTE"));

			bean.setAcc_note(results.getString("ACC_NOTE"));
			bean.setReg_id(results.getString("REG_ID"));
			bean.setUpd_id(results.getString("UPD_ID"));
			bean.setStart_dt(results.getString("START_DT"));
			bean.setClose_dt(results.getString("CLOSE_DT"));
			bean.setDeal_note(results.getString("DEAL_NOTE"));
			bean.setGubun_b(results.getString("GUBUN_B"));

			
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}
	

	/**
	*	정비업체정보 등록 2004.03.17.
	*/
	public int insertServOff(ServOffBean bean, String cpt_cd){
		getConnection();
		PreparedStatement pstmt = null;
        ResultSet rs = null;
		int result = -1;
		String off_id = "";
		String query, query1 = "";

		query1= "SELECT NVL(LPAD(MAX(off_id)+1,6,'0'),'000001') FROM serv_off";
		query = " INSERT INTO serv_off "+
				" (off_id, car_comp_id, off_nm, off_st, br_id, off_tel, off_fax, "+
				"  off_post, off_addr, bank, acc_no, note, reg_dt, reg_id, "+
				"  acc_note, start_dt, close_dt, deal_note, cpt_cd, gubun_b)"+
			    " VALUES"+
			    " (?, ?, ?, ?, ?, ?, ?,"+
				"  ?, ?, ?, ?, ?, to_char(sysdate,'yyyymmdd'), ?,"+
				"  ?, replace(?,'-',''), replace(?,'-',''), ?, '"+cpt_cd+"', ? ) ";

		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query1);
			rs = pstmt.executeQuery();

            if(rs.next()){
				off_id = rs.getString(1);
            }
			
            pstmt = conn.prepareStatement(query);

			pstmt.setString(1, off_id.trim());
			pstmt.setString(2, bean.getCar_comp_id().trim()); 
			pstmt.setString(3, bean.getOff_nm().trim()); 
			pstmt.setString(4, bean.getOff_st().trim()); 
			pstmt.setString(5, bean.getBr_id().trim());			
			pstmt.setString(6, bean.getOff_tel().trim()); 
			pstmt.setString(7, bean.getOff_fax().trim()); 
			pstmt.setString(8, bean.getOff_post().trim()); 
			pstmt.setString(9, bean.getOff_addr().trim()); 
			pstmt.setString(10, bean.getBank().trim()); 
			pstmt.setString(11, bean.getAcc_no().trim()); 
			pstmt.setString(12, bean.getNote().trim());
			pstmt.setString(13, bean.getReg_id());	
			pstmt.setString(14, bean.getAcc_note().trim());	
			pstmt.setString(15, bean.getStart_dt().trim());	
			pstmt.setString(16, bean.getClose_dt().trim());	
			pstmt.setString(17, bean.getDeal_note().trim());
			pstmt.setString(18, bean.getGubun_b().trim());
          
			result = pstmt.executeUpdate();
			
			rs.close();
			pstmt.close();
			conn.commit();

		}catch(Exception e){
			System.out.println("[Serv_EmpDatabase:insertServOff(ServOffBean bean)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
				if(rs != null) rs.close();
            			if(pstmt != null) pstmt.close();
				
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}		
	}


	/**
	*	정비업체정보 수정.
	*/

	public int updateServOff(ServOffBean bean){
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";
				
		query = " UPDATE SERV_OFF SET "+
				" car_comp_id =?, off_nm =?, off_st =?, br_id =?, off_tel =?, "+
				" off_post =?, off_addr =?, note =?, upd_dt =to_char(sysdate,'yyyymmdd'), upd_id =?, "+
				" start_dt=replace(?,'-',''), close_dt=replace(?,'-',''), deal_note =?, gubun_b=?, cpt_cd = ?   "+
			    " where off_id = ? "+
				"  ";
		
		
		try 
		{		
			conn.setAutoCommit(false);	
		
			pstmt = conn.prepareStatement(query);


			pstmt.setString(1, bean.getCar_comp_id().trim()); 
			pstmt.setString(2, bean.getOff_nm().trim()); 
			pstmt.setString(3, bean.getOff_st().trim()); 
			pstmt.setString(4, bean.getBr_id().trim());			
			pstmt.setString(5, bean.getOff_tel().trim()); 
			pstmt.setString(6, bean.getOff_post().trim()); 
			pstmt.setString(7, bean.getOff_addr().trim()); 
			pstmt.setString(8, bean.getNote().trim());
			pstmt.setString(9, bean.getUpd_id());	
			pstmt.setString(10, bean.getStart_dt().trim());	
			pstmt.setString(11, bean.getClose_dt().trim());	
			pstmt.setString(12, bean.getDeal_note().trim());
			pstmt.setString(13, bean.getGubun_b().trim());
			pstmt.setString(14, bean.getCpt_cd().trim());
			pstmt.setString(15, bean.getOff_id().trim());

			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
/*
			System.out.println("[Serv_EmpDatabase:updateServOff.getCar_comp_id()]\n"+bean.getCar_comp_id());
			System.out.println("[Serv_EmpDatabase:updateServOff.getOff_nm()]\n"+bean.getOff_nm());
			System.out.println("[Serv_EmpDatabase:updateServOff.getOff_st()]\n"+bean.getOff_st());
			System.out.println("[Serv_EmpDatabase:updateServOff.getBr_id()]\n"+bean.getBr_id());
			System.out.println("[Serv_EmpDatabase:updateServOff.getOff_tel()]\n"+bean.getOff_tel());
			System.out.println("[Serv_EmpDatabase:updateServOff.getOff_post()]\n"+bean.getOff_post());
			System.out.println("[Serv_EmpDatabase:updateServOff.getOff_addr()]\n"+bean.getOff_addr());
			System.out.println("[Serv_EmpDatabase:updateServOff.getNote()]\n"+bean.getNote());
			System.out.println("[Serv_EmpDatabase:updateServOff.getUpd_id()]\n"+bean.getUpd_id());
			System.out.println("[Serv_EmpDatabase:updateServOff.getStart_dt()]\n"+bean.getStart_dt());
			System.out.println("[Serv_EmpDatabase:updateServOff.getClose_dt()]\n"+bean.getClose_dt());
			System.out.println("[Serv_EmpDatabase:updateServOff.getDeal_note()]\n"+bean.getDeal_note());
			System.out.println("[Serv_EmpDatabase:updateServOff.getOff_id()]\n"+bean.getOff_id());
*/


		} catch (SQLException e) {
			System.out.println("[Serv_EmpDatabase:updateServOff]\n"+e);
			System.out.println("[Serv_EmpDatabase:updateServOff]\n"+query);
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

	/**
	*  off_st = '7' 명함관리
	*/

	public Vector getServ_offList_20150416(String s_kd, String t_wd, String gubun1, String gubun2, String sort_gubun, String sort, String off_type, String save_dt, String list_order){

		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String brid = "";

		
		query = " SELECT c.NM,  c.nm_cd, c.CODE, a.OFF_ID, a.CAR_COMP_ID, a.OFF_NM, a.off_tel, a.BANK, a.ACC_NO, a.ACC_NM, a.NOTE, a.REG_DT, a.REG_ID, a.UPD_DT, a.UPD_ID, a.BR_ID, a.START_DT, a.CLOSE_DT, a.DEAL_NOTE, a.CPT_CD, a.USE_YN, a.GUBUN_B, NVL(d.over_mon_amt,0) as over_mon_amt  "+ 
				" FROM serv_off a, (SELECT * FROM code  WHERE c_st='0025' ) c, "+
				" (SELECT cpt_cd, over_mon_amt FROM STAT_DEBT WHERE save_dt = '"+save_dt+"' )d "+
				" WHERE a.car_comp_id=c.code(+) and a.CPT_CD = d.cpt_cd(+) AND a.off_st = '7' ";

		
		if (!gubun1.equals("")){

			if(gubun1.equals("0001")){//금융

				if(gubun2.equals("00010")){ //금융전체, 00011:은행, 00012:저축은행, 00013:캐피탈, 00014:카드사
					query += " AND c.code = '" + gubun1 + "' " ;
				}else if(gubun2.equals("00011")){
					query += " AND c.code = '" + gubun1 + "' AND a.gubun_b = '1' " ;
				}else if(gubun2.equals("00012")){
					query += " AND c.code = '" + gubun1 + "' AND a.gubun_b = '2' " ;
				}else if(gubun2.equals("00013")){
					query += " AND c.code = '" + gubun1 + "' AND a.gubun_b = '3' " ;
				}else if(gubun2.equals("00014")){
					query += " AND c.code = '" + gubun1 + "' AND a.gubun_b = '4' " ;
				}else if(gubun2.equals("00015")){
					query += " AND c.code = '" + gubun1 + "' AND a.gubun_b = '5' " ;
				}else{
					query += " AND c.code = '" + gubun1 + "'" ;
				}

			}else{
				query += " AND c.code = '" + gubun1 + "'" ;
			}
		}else{
			query += "AND C.CODE NOT IN ('0001') ";
		}


		if(!t_wd.equals("")){
			if(s_kd.equals("1"))	query += " and a.off_nm like '%"+t_wd+"%'";//상호
			if(s_kd.equals("2"))	query += " and a.off_tel like '%"+t_wd+"%'";//전화
		}
		
		if(list_order.equals("2")) {
			query += " order by over_mon_amt desc";
		} else {
			query += " order by UPPER(a.off_nm) ";
		}
		
//System.out.println("[Serv_EmpDatabase:getServ_offList_20150416]\n"+query);

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
			System.out.println("[Serv_EmpDatabase:getServ_offList_20150416(String s_kd, String t_wd, String sort_gubun, String sort)]"+e);
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

	/**
	*  명합관리에서 담당자만 리스트 뽑기
	*/

	public Vector getServ_offList_ddj(String s_kd, String t_wd, String gubun1, String gubun2, String sort_gubun, String sort, String off_type, String br_id, String mail_yn){

		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String brid = "";

		
		query = " SELECT b.nm_cd, b.off_nm, b.off_id, b.off_tel, a.emp_nm, a.dept_nm,  NVL(a.pos, a.emp_level) EMP_POS, a.emp_tel, a.emp_htel, a.emp_mtel, a.emp_email, a.emp_role, a.reg_dt, a.upt_dt, a.emp_email_yn, b.gubun_b, b.code  \n"+ 
				" FROM (SELECT * FROM SERV_EMP WHERE emp_valid = '1' ) a, \n"+
				" (SELECT c.*, a.* FROM serv_off a, (SELECT * FROM code  WHERE c_st='0025' ) c WHERE a.car_comp_id=c.code(+)  AND a.off_st = '7' AND a.CAR_COMP_ID = '0001' ) b \n"+
				" WHERE a.OFF_ID = b.off_id "+
				" and a.emp_email_yn = '"+mail_yn+"' ";
		
		if (!gubun1.equals("")){

			if(gubun1.equals("0001")){//금융

				if(gubun2.equals("00010")){ //금융전체, 00011:은행, 00012:저축은행, 00013:캐피탈, 00014:카드사
					query += " AND b.code = '" + gubun1 + "' " ;
				}else if(gubun2.equals("00011")){
					query += " AND b.code = '" + gubun1 + "' AND b.gubun_b = '1' " ;
				}else if(gubun2.equals("00012")){
					query += " AND b.code = '" + gubun1 + "' AND b.gubun_b = '2' " ;
				}else if(gubun2.equals("00013")){
					query += " AND b.code = '" + gubun1 + "' AND b.gubun_b = '3' " ;
				}else if(gubun2.equals("00014")){
					query += " AND b.code = '" + gubun1 + "' AND b.gubun_b = '4' " ;
				}else{
					query += " AND b.code = '" + gubun1 + "'" ;
				}

			}else{
				query += " AND b.code = '" + gubun1 + "'" ;
			}
		}


		if(!t_wd.equals("")){
			if(s_kd.equals("1"))	query += " and b.off_nm like '%"+t_wd+"%'";//상호
			if(s_kd.equals("2"))	query += " and b.off_tel like '%"+t_wd+"%'";//사무실전화
			if(s_kd.equals("3"))	query += " and a.emp_nm like '%"+t_wd+"%'";//담당자
			if(s_kd.equals("4"))	query += " and a.emp_mtel like '%"+t_wd+"%'";//휴대전화 (20190109)

		}
		query += " order by DECODE(UPPER(b.off_nm),'아마존카',1,'아마존카2',2,'아마존카3',3,4), UPPER(b.off_nm) ";

//System.out.println("[Serv_EmpDatabase:getServ_offList_ddj]"+query);

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
			System.out.println("[Serv_EmpDatabase:getServ_offList_ddj(String s_kd, String t_wd, String sort_gubun, String sort)]"+e);
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


	public Hashtable getServ_emp_udt(String off_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

				 query = " SELECT upt_dt from (SELECT RANK() OVER(ORDER BY seq ASC) AS RANK, upt_dt FROM SERV_EMP  "+
						" WHERE off_id = '"+off_id+"' )  WHERE RANK = 1			 ";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();   
			
    			
			if(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[Serv_EmpDatabase:getServ_emp_udt]"+e);
			System.out.println("[Serv_EmpDatabase:getServ_emp_udt]"+query);
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
	*	 상세정보 2014.04.17
	*/
	public Hashtable getServOff(String off_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

				 query = " SELECT off_id, br_id, car_comp_id, off_nm, off_tel, off_post, off_addr, bank, acc_no, note, reg_dt, start_dt, close_dt, acc_note, cpt_cd, deal_note, gubun_b "+
						 " FROM serv_off WHERE off_id = '"+off_id+"'";



		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();   
			
    			
			if(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
		//	System.out.println("[Serv_EmpDatabase:getServOff]"+query);	
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[Serv_EmpDatabase:getServOff]"+e);
			System.out.println("[Serv_EmpDatabase:getServOff]"+query);
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

	public Vector getServ_empList(String s_kd, String t_wd, String sort_gubun, String sort, String off_id, String use_yn){
	
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String brid = "";
		String sub_query = "";
        
		int i_wd = AddUtil.parseInt(t_wd);
		
	//	if(!t_wd.equals("") ||  )	i_wd = 	AddUtil.parseInt(t_wd);

		if(use_yn.equals("all")){
			sub_query = " and emp_valid in ('1','2','3','4') ";
		}else{
			sub_query = " and emp_valid  in ('1') ";
		}
		
		query = " SELECT * from serv_emp WHERE off_id = '"+off_id+"'"+	sub_query+
				"";
		
	
		if( i_wd > 0 )	query += " and seq= "+i_wd;  //seq 		
		
	//	query += " ORDER BY emp_valid asc ";
		//부서, 직급으로 정렬(20190821)
		if(sort_gubun.equals("1")){	query += " ORDER BY dept_nm asc, " +
																	"	DECODE(emp_level, '지점장',1,'부지점장',3,'팀장',5,'차장',7,'과장',9,'대리',11," +
																	"					'',DECODE(pos,'지점장',2,'부지점장',4,'팀장',6,'차장',8,'과장',10,'대리',12),13) ASC ";		
		}else{									query += " ORDER BY dept_nm asc, " +
				 													"	DECODE(emp_level, '부장',1,'팀장',3,'차장',5,'과장',7,'대리',9," +
																	" 					'',DECODE(pos,'부장',2,'팀장',4,'차장',6,'과장',8,'대리',10),11) ASC ";		
		}
		
	//	System.out.println("getServ_empList query=" + query);
		
		try{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();    	
    		ResultSetMetaData rsmd = rs.getMetaData();    	

			while(rs.next()){				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Serv_EmpDatabase:getServ_empList()]"+e);
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

	/**
	*	업체 담당자 등록 2004.03.17.
	*/
	 public int insertServEmp(Serv_EmpBean bean) {
		getConnection();

        PreparedStatement pstmt = null;
		ResultSet rs = null;
		Statement stmt = null;
		int count = 0;
		String query = "";
		String query_seq = "";
		int seq = 0;


 	  	query_seq = " select nvl(max(seq)+1, 1) "
						+" from serv_emp ";	
                   
        query="INSERT INTO serv_emp (off_id, seq, emp_nm, dept_nm, pos, emp_level, emp_tel, emp_htel, emp_fax, emp_mtel, emp_email, reg_dt, emp_role, emp_valid, emp_addr, emp_post, emp_email_yn )\n"
                + "values( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, to_char(sysdate,'yyyymmdd'), ?, ?, ?, ?, ? \n"
				+ " )";

        try 
			{			
				conn.setAutoCommit(false);
				
	  			stmt = conn.createStatement();
	            rs = stmt.executeQuery(query_seq);
	         
	            if(rs.next())
	            	seq = rs.getInt(1);
	            rs.close();
				stmt.close();
					
				pstmt = conn.prepareStatement(query);
	
				pstmt.setString   (1, bean.getOff_id()	);
				pstmt.setInt   (2, seq				);
				pstmt.setString(3, bean.getEmp_nm()		);
				pstmt.setString(4, bean.getDept_nm()	);
				pstmt.setString(5, bean.getPos()	);
				pstmt.setString(6, bean.getEmp_level()	);
				pstmt.setString(7, bean.getEmp_tel()	);
				pstmt.setString(8, bean.getEmp_htel()	);
				pstmt.setString(9, bean.getEmp_fax()	);
				pstmt.setString(10, bean.getEmp_mtel()	);
				pstmt.setString(11, bean.getEmp_email()	);
				pstmt.setString(12, bean.getEmp_role()	);
				pstmt.setString(13, bean.getEmp_valid()	);
				pstmt.setString(14, bean.getEmp_addr()	);
				pstmt.setString(15, bean.getEmp_post()	);
				pstmt.setString(16, bean.getEmp_email_yn()	);
	
				count = pstmt.executeUpdate();
				pstmt.close();
				conn.commit();
			} catch (SQLException e) {
				System.out.println("[Serv_EmpDatabase:insertServEmp]\n"+e);
				System.out.println("[Serv_EmpDatabase:insertServEmp]\n"+query);
		  		e.printStackTrace();
		  		count = 0;
				conn.rollback();
		
			} finally {
				try{
					conn.setAutoCommit(true);
					if(rs != null) rs.close();
	                if(stmt != null) stmt.close();
					if(pstmt != null)	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return count;
			}
	}


	 //계좌추가
	 public int InsertServ_EmpBank_acc(String off_st, String off_id, String reg_id, String bank_id, String acc_no, String etc)
	{
			
		getConnection();

		PreparedStatement pstmt = null;
        PreparedStatement pstmt1 = null;
        ResultSet rs = null;
     
        String query = "";
        String seqQuery = "";
        int count = 0;
        int seq = 0;
				
		query = "	insert into bank_acc ( off_st, OFF_ID, seq, bank_id, acc_no, reg_id, etc, reg_dt) "+   //
					   "    values ( ?, ?, ?, ?, ?, ?, ?, to_char(sysdate,'YYYYMMDD') )  ";  //				
		
		seqQuery = "select nvl(max(seq),0 ) + 1  from bank_acc where off_st = 'serv_off' and off_id = '"+off_id+"' ";     

		try{
			conn.setAutoCommit(false);
			
			pstmt1 = conn.prepareStatement(seqQuery);
			rs = pstmt1.executeQuery();
            
            if(rs.next())
            	seq = rs.getInt(1);
            rs.close();
			pstmt1.close();

			pstmt = conn.prepareStatement(query);			

			pstmt.setString(1, off_st);
			pstmt.setString(2, off_id);
			pstmt.setInt(3, seq);
			pstmt.setString(4, bank_id);
			pstmt.setString(5, acc_no);
			pstmt.setString(6, reg_id);
			pstmt.setString(7, etc);	

			count = pstmt.executeUpdate();

			pstmt.close();
			conn.commit();

		}catch(SQLException e){
			count = 1;
			System.out.println("[Serv_EmpDatabase:InsertServ_EmpBank_acc]"+e);
			System.out.println("[Serv_EmpDatabase:InsertServ_EmpBank_acc]"+query);
			System.out.println("[Serv_EmpDatabase:InsertServ_EmpBank_acc]"+off_st);
			System.out.println("[Serv_EmpDatabase:InsertServ_EmpBank_acc]"+off_id);
			System.out.println("[Serv_EmpDatabase:InsertServ_EmpBank_acc]"+bank_id);
			System.out.println("[Serv_EmpDatabase:InsertServ_EmpBank_acc]"+acc_no);
			System.out.println("[Serv_EmpDatabase:InsertServ_EmpBank_acc]"+etc);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
				if(rs != null) rs.close();
                if(pstmt1 != null) pstmt1.close();
                if(pstmt != null)  pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	 //계좌정보 수정
	 public int UpdateServ_EmpBank_acc(int seq, String off_id, String reg_id, String bank_id, String acc_no, String etc )
	{
			
		getConnection();

		PreparedStatement pstmt = null;
        PreparedStatement pstmt1 = null;
        ResultSet rs = null;
     
        String query = "";
        String seqQuery = "";
        int count = 0;
				
		query = "	update bank_acc set  bank_id = ?, acc_no = ?, update_id = ?, etc = ?, update_dt = to_char(sysdate,'YYYYMMDD') "+   //
				"   where off_st = 'serv_off' and off_id = ? and seq = ? ";
		
		
		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			

			pstmt.setString(1, bank_id);
			pstmt.setString(2, acc_no);
			pstmt.setString(3, reg_id);
			pstmt.setString(4, etc);
			pstmt.setString(5, off_id);
			pstmt.setInt(6, seq);		

			count = pstmt.executeUpdate();

			pstmt.close();
			conn.commit();

		}catch(SQLException e){
			count = 1;
			System.out.println("[Serv_EmpDatabase:UpdateServ_EmpBank_acc]"+e);
			System.out.println("[Serv_EmpDatabase:UpdateServ_EmpBank_acc]"+query);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)  pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	 //계좌정보 삭제
	 public int DeleteServ_EmpBank_acc(int seq, String off_id, String bank_id)
	{			
		getConnection();

		PreparedStatement pstmt = null;
        PreparedStatement pstmt1 = null;
        ResultSet rs = null;
     
        String query = "";
        String seqQuery = "";
        int count = 0;
				
		query = "	delete from bank_acc "+   //
				"   where off_st = 'serv_off' and off_id = ? and seq = ? and bank_id = ? ";
			
		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, off_id);
			pstmt.setInt(2, seq);		
			pstmt.setString(3, bank_id);

			count = pstmt.executeUpdate();

			pstmt.close();
			conn.commit();

		}catch(SQLException e){
			count = 1;
			System.out.println("[Serv_EmpDatabase:DeleteServ_EmpBank_acc]"+e);
			System.out.println("[Serv_EmpDatabase:DeleteServ_EmpBank_acc]"+query);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)  pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	 //계좌정보 조회
	 public Vector Bank_accList(String off_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
        query = " select  * from bank_acc where  off_st = 'serv_off' and off_id= '"+off_id+"' ";


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
			System.out.println("[Serv_EmpDatabase:Bank_accList]"+e);
			System.out.println("[Serv_EmpDatabase:Bank_accList]"+query);
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


	 //계좌정보 수정 한건조회
	 public Hashtable Bank_accView(String off_id, String seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		 query = " SELECT * "+
				 " FROM bank_acc WHERE off_st = 'serv_off' and off_id = '"+off_id+"' and seq = '"+seq+"' ";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();   
			
    			
			if(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[Serv_EmpDatabase:Bank_accView]"+e);
			System.out.println("[Serv_EmpDatabase:Bank_accView]"+query);
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

	 //명함관리 1건조회.
	 public Hashtable getServ_emp_find(String off_id, String emp_nm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

				 query = " SELECT * FROM SERV_EMP WHERE off_id = '"+off_id+"' and emp_nm = '"+emp_nm+"'";



		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();   
			
    			
			if(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[Serv_EmpDatabase:getServ_emp_find]"+e);
			System.out.println("[Serv_EmpDatabase:getServ_emp_find]"+query);
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

	 //명함관리 1건조회.
	 public Hashtable getServ_emp_find(String off_id, String emp_nm, String seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable(); 
		String query = "";

		 query = " SELECT * FROM SERV_EMP WHERE off_id = '"+off_id+"' ";
				 
		 if(seq.equals("")) {
			 query += " and emp_nm = '"+emp_nm+"' "; 
		 }else {
			 query += " and seq=to_number('"+seq+"') ";		 
		 }


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
  		ResultSetMetaData rsmd = rs.getMetaData();    
			
  			
			if(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[Serv_EmpDatabase:getServ_emp_find]"+e);
			System.out.println("[Serv_EmpDatabase:getServ_emp_find]"+query);
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

	 //명함관리 담당자 정보 수정
	 public int updateServEmp(Serv_EmpBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";
				
		query = "	update SERV_EMP set  EMP_NM = ?, DEPT_NM = ?, POS = ?, EMP_LEVEL = ?,  EMP_TEL = ?,  EMP_HTEL = ?,  EMP_FAX = ?, EMP_MTEL = ?,  EMP_EMAIL = ?,  EMP_ROLE = ?, EMP_VALID = ?, EMP_ADDR = ?, EMP_POST = ?, UPT_DT = to_char(sysdate,'YYYYMMDD') "+   //
				"   where off_id = ? and seq = ? ";
				
		try 
		{		
			conn.setAutoCommit(false);	
		
			pstmt = conn.prepareStatement(query);


			pstmt.setString(1, bean.getEmp_nm()		);
			pstmt.setString(2, bean.getDept_nm()	);
			pstmt.setString(3, bean.getPos()		);
			pstmt.setString(4, bean.getEmp_level()	);
			pstmt.setString(5, bean.getEmp_tel()	);
			pstmt.setString(6, bean.getEmp_htel()	);
			pstmt.setString(7, bean.getEmp_fax()	);
			pstmt.setString(8, bean.getEmp_mtel()	);
			pstmt.setString(9, bean.getEmp_email()	);
			pstmt.setString(10, bean.getEmp_role()	);
			pstmt.setString(11, bean.getEmp_valid()	);
			pstmt.setString(12, bean.getEmp_addr()	);
			pstmt.setString(13, bean.getEmp_post()	);	
			pstmt.setString(14, bean.getOff_id()	);
			pstmt.setInt   (15, bean.getSeq()		);


			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

/*
			System.out.println("[Serv_EmpDatabase:updateServEmp_bean.getEmp_nm()]\n"+bean.getEmp_nm());
			System.out.println("[Serv_EmpDatabase:updateServEmp_bean.getDept_nm()]\n"+bean.getDept_nm());
			System.out.println("[Serv_EmpDatabase:updateServEmp_bean.getPos()]\n"+bean.getPos());
			System.out.println("[Serv_EmpDatabase:updateServEmp_bean.getEmp_level()]\n"+bean.getEmp_level());
			System.out.println("[Serv_EmpDatabase:updateServEmp_bean.getEmp_tel()]\n"+bean.getEmp_tel());
			System.out.println("[Serv_EmpDatabase:updateServEmp_bean.getEmp_htel()]\n"+bean.getEmp_htel());
			System.out.println("[Serv_EmpDatabase:updateServEmp_bean.getEmp_fax()]\n"+bean.getEmp_fax());
			System.out.println("[Serv_EmpDatabase:updateServEmp_bean.getEmp_mtel()]\n"+bean.getEmp_mtel());
			System.out.println("[Serv_EmpDatabase:updateServEmp_bean.getEmp_email()]\n"+bean.getEmp_email());
			System.out.println("[Serv_EmpDatabase:updateServEmp_bean.getEmp_role()]\n"+bean.getEmp_role());
			System.out.println("[Serv_EmpDatabase:updateServEmp_bean.getEmp_valid()]\n"+bean.getEmp_valid());
			System.out.println("[Serv_EmpDatabase:updateServEmp_bean.getEmp_addr()]\n"+bean.getEmp_addr());
			System.out.println("[Serv_EmpDatabase:updateServEmp_bean.getEmp_post()]\n"+bean.getEmp_post());
			System.out.println("[Serv_EmpDatabase:updateServEmp_bean.getOff_id()]\n"+bean.getOff_id());
			System.out.println("[Serv_EmpDatabase:updateServEmp_bean.getSeq()]\n"+bean.getSeq());
*/


		} catch (SQLException e) {
			System.out.println("[Serv_EmpDatabase:updateServEmp]\n"+e);
			System.out.println("[Serv_EmpDatabase:updateServEmp]\n"+query);
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

	/**
	*	금융기관 상담이력 등록시 serv_id 
	*/
	 public String getNextEvalServ_id(String off_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String serv_id = "";
		String query = "";
		query = "SELECT NVL(LPAD(MAX(serv_id)+1,6,'0'),'000001') from SERV_BC_ITEM where off_id= ?  ";
		try
		{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, off_id);
		   	rs = pstmt.executeQuery();
		
			if(rs.next())
			{
				serv_id = rs.getString(1);			
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[Serv_EmpDatabase:getNextEvalServ_id]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return serv_id;
		}
	}

	/**
	*	금융기관 상담이력 등록
	*/
	public int insertBCSD(BizcardBean bean){
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
        ResultSet rs = null;
		int result = -1;
		int seq_no = 0;
		String query, query1 = "";

		query1= " select nvl(max(seq_no)+1,1)  FROM SERV_BC_ITEM where off_id = ? and serv_id = ? ";

		query = " INSERT INTO SERV_BC_ITEM "+
				" (off_id, serv_id, seq_no, gubun, sd_dt, g_smng1, g_smng2, g_smng3, "+
				"  d_smng1, d_smng2, d_smng3, item1, item2, note, reg_id, reg_dt "+
				"  )"+
			    " VALUES"+
			    " (?, ?, ?, ?, replace(?,'-',''), ?, ?, ?, "+
				"  ?, ?, ?, ?, ?, ?, ?, to_char(sysdate,'yyyymmdd') "+
				"  ) ";

		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query1);
			pstmt.setString(1, bean.getOff_id().trim());
			pstmt.setString(2, bean.getServ_id().trim());
			rs = pstmt.executeQuery();

            if(rs.next()){
				seq_no = rs.getInt(1);
            }
			rs.close();
			pstmt.close();
			
            pstmt2 = conn.prepareStatement(query);
			pstmt2.setString(1, bean.getOff_id().trim());
			pstmt2.setString(2, bean.getServ_id().trim()); 
			pstmt2.setInt(3, seq_no); 
			pstmt2.setString(4, bean.getGubun().trim()); 
			pstmt2.setString(5, bean.getSd_dt().trim());			
			pstmt2.setString(6, bean.getG_smng1().trim()); 
			pstmt2.setString(7, bean.getG_smng2().trim()); 
			pstmt2.setString(8, bean.getG_smng3().trim()); 
			pstmt2.setString(9, bean.getD_smng1().trim()); 
			pstmt2.setString(10, bean.getD_smng2().trim()); 
			pstmt2.setString(11, bean.getD_smng3().trim()); 
			pstmt2.setString(12, bean.getItem1().trim());
			pstmt2.setString(13, bean.getItem2().trim());	
			pstmt2.setString(14, bean.getNote().trim());	
			pstmt2.setString(15, bean.getReg_id().trim());	          
			result = pstmt2.executeUpdate();		
			pstmt2.close();
			conn.commit();

		}catch(Exception e){
			System.out.println("[Serv_EmpDatabase:insertBCSD(BizcardBean bean)]"+e);
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

	//현황리스트
	public Vector getBCSD_List(String off_id){

		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String brid = "";
		
		query = " SELECT a.* FROM SERV_BC_ITEM a, (SELECT serv_id, MAX(seq_no) AS seq_no FROM SERV_BC_ITEM WHERE off_id = '"+off_id+"' GROUP BY serv_id ) b "+
				" WHERE a.SERV_ID= b.serv_id  AND a.SEQ_NO = b.seq_no  and a.off_id = '"+off_id+"' ";

		query += "ORDER BY  a.SERV_ID desc ";


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
			System.out.println("[Serv_EmpDatabase:getBCSD_List()]"+e);
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

	//현황 세부리스트
	public Vector getBCSD_SubList(String off_id, String serv_id){

		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String brid = "";

		
		query = " SELECT * FROM SERV_BC_ITEM  "+
				" WHERE off_id = '"+off_id+"' and serv_id = '"+serv_id+"' ";
		
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
			System.out.println("[Serv_EmpDatabase:getBCSD_SubList()]"+e);
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

	//대출거래현황리스트
	public Vector getBank_DCGR_List(String cpt_cd){

		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String brid = "";

		
		query = " SELECT b.nm AS 금융사, a.cont_dt AS 체결일자, a.cont_dt AS 실행개시일, a.cls_est_dt AS 실행종료일, DECODE(a.revolving,'Y','회전','Non') as 회전여부, \n"+
				"        a.cont_amt AS 약정한도금액, a.cont_amt-NVL(c.lend_bank_cont_amt,0) AS 약정한도잔액, \n"+
				"        d.rtn_cont_amt_24 AS 금액_24개월, d.int_24 AS 금리_24개월,  \n"+
				"        d.rtn_cont_amt_36 AS 금액_36개월, d.int_36 AS 금리_36개월, \n"+
				"        d.rtn_cont_amt_48 AS 금액_48개월, d.int_48 AS 금리_48개월, \n"+
				"        d.rtn_cont_amt_60 AS 금액_60개월, d.int_60 AS 금리_60개월, \n"+
				"        d.rtn_cont_amt AS 실행합계금액,          \n"+
				"        e.alt_prn_amt AS 상환금액, e.alt_rest AS 상환잔액 \n"+
				" FROM   WORKING_FUND a, (SELECT * FROM CODE WHERE c_st='0003') b, \n"+
				"        (SELECT fund_id, SUM(cont_amt) lend_bank_cont_amt FROM LEND_BANK GROUP BY fund_id \n"+
				"         union all \n"+
				"         SELECT a.fund_id, SUM(a.lend_prn) lend_bank_cont_amt  \n"+
				"         FROM   allot a, cont d, \n"+
				"                (select car_mng_id, max(reg_dt||rent_l_cd) rent_l_cd from CONT WHERE rent_l_cd NOT LIKE 'RM%' group by car_mng_id) H  \n"+
				"         where  a.lend_id is null and a.fund_id is not null \n"+
				"                and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd and d.car_mng_id=H.car_mng_id and d.reg_dt||d.rent_l_cd=H.rent_l_cd  \n"+
				"         GROUP BY a.fund_id \n"+
				"        ) c, \n"+
				"        (SELECT a.fund_id,  \n"+
				"               SUM(b.rtn_cont_amt) rtn_cont_amt, min(b.cont_start_dt) cont_start_dt, MAX(b.cont_end_dt) cont_end_dt, \n"+
				"                SUM(case when to_number(nvl(b.cont_term,0)) <= 29      then b.rtn_cont_amt else 0 end) rtn_cont_amt_24, max(case when to_number(nvl(b.cont_term,0)) <= 29      then a.lend_int else '0' end) int_24, \n"+
				"                SUM(case when to_number(b.cont_term) between 30 and 39 then b.rtn_cont_amt else 0 end) rtn_cont_amt_36, max(case when to_number(b.cont_term) between 30 and 39 then a.lend_int else '0' end) int_36, \n"+
				"                SUM(case when to_number(b.cont_term) between 40 and 49 then b.rtn_cont_amt else 0 end) rtn_cont_amt_48, max(case when to_number(b.cont_term) between 40 and 49 then a.lend_int else '0' end) int_48, \n"+
				"                SUM(case when to_number(b.cont_term) between 50 and 99 then b.rtn_cont_amt else 0 end) rtn_cont_amt_60, max(case when to_number(b.cont_term) between 50 and 99 then a.lend_int else '0' end) int_60       \n"+         
				"         FROM   LEND_BANK a, BANK_RTN b  \n"+
				"         WHERE a.lend_id=b.lend_id  \n"+
				"         GROUP BY a.fund_id \n"+
				"         union all \n"+
				"         SELECT a.fund_id,  \n"+
				"                SUM(a.lend_prn) rtn_cont_amt, min(a.alt_start_dt) cont_start_dt, MAX(a.alt_end_dt) cont_end_dt, \n"+
				"                SUM(case when to_number(nvl(a.tot_alt_tm,0)) <= 29      then a.lend_prn else 0 end) rtn_cont_amt_24, max(case when to_number(nvl(a.tot_alt_tm,0)) <= 29      then a.lend_int else '0' end) int_24, \n"+
				"                SUM(case when to_number(a.tot_alt_tm) between 30 and 39 then a.lend_prn else 0 end) rtn_cont_amt_36, max(case when to_number(a.tot_alt_tm) between 30 and 39 then a.lend_int else '0' end) int_36, \n"+
				"                SUM(case when to_number(a.tot_alt_tm) between 40 and 49 then a.lend_prn else 0 end) rtn_cont_amt_48, max(case when to_number(a.tot_alt_tm) between 40 and 49 then a.lend_int else '0' end) int_48, \n"+
				"                SUM(case when to_number(a.tot_alt_tm) between 50 and 99 then a.lend_prn else 0 end) rtn_cont_amt_60, max(case when to_number(a.tot_alt_tm) between 50 and 99 then a.lend_int else '0' end) int_60   \n"+             
				"         FROM   allot a, cont d, \n"+
				"                (select car_mng_id, max(reg_dt||rent_l_cd) rent_l_cd from CONT WHERE rent_l_cd NOT LIKE 'RM%' group by car_mng_id) H \n"+
				"         WHERE a.lend_id is null and a.fund_id is not null  \n"+
				"               and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd and d.car_mng_id=H.car_mng_id and d.reg_dt||d.rent_l_cd=H.rent_l_cd \n"+
				"         GROUP BY a.fund_id \n"+
				"        ) d, \n"+
				"        (SELECT fund_id, SUM(alt_prn_amt) alt_prn_amt, SUM(alt_rest) alt_rest \n"+
				"         FROM ( \n"+
				"                SELECT a.fund_id, a.lend_id, c.rtn_seq, SUM(alt_prn_amt) alt_prn_amt, MIN(alt_rest) alt_rest \n"+
				"                FROM   LEND_BANK a, BANK_RTN b, SCD_BANK c \n"+
				"                WHERE  a.lend_id=b.lend_id AND b.lend_id=c.lend_id AND b.seq=c.RTN_seq AND c.pay_yn='1' \n"+
				"                GROUP by a.fund_id, a.lend_id, c.rtn_seq \n"+
				"                union all \n"+
				"                SELECT a.fund_id, a.car_mng_id as lend_id, '' rtn_seq, SUM(alt_prn) alt_prn_amt, MIN(alt_rest) alt_rest \n"+
				"                FROM   allot a, scd_alt_case c, cont d,  \n"+
				"                       (select car_mng_id, max(reg_dt||rent_l_cd) rent_l_cd from CONT WHERE rent_l_cd NOT LIKE 'RM%' group by car_mng_id) H \n"+
				"                WHERE  a.lend_id is null and a.fund_id is not null AND a.car_mng_id=c.car_mng_id AND c.pay_yn='1' \n"+
				"                       and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd and d.car_mng_id=H.car_mng_id and d.reg_dt||d.rent_l_cd=H.rent_l_cd \n"+
				"                GROUP by a.fund_id, a.car_mng_id \n"+
				"              )  \n"+
				"         GROUP BY fund_id \n"+
				"        ) e \n"+
				" WHERE  a.CONT_BN=B.CODE AND a.fund_id=c.fund_id(+) AND a.fund_id=d.fund_id(+) AND a.fund_id=e.fund_id(+) \n";


				if(cpt_cd.equals("0077")){//SBI3+SBI4+SBI 통합
						query +=		" and a.CONT_BN in ('0068','0073','0077') \n"; //--금융사 코드별 조회 
				}else{
						query +=		" and a.CONT_BN='"+cpt_cd+"' \n"; //--금융사 코드별 조회 
				}

				query +=		" ORDER BY a.cont_dt desc \n";

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
			System.out.println("[Serv_EmpDatabase:getBank_DCGR_List()]"+e);
			System.out.println("[Serv_EmpDatabase:getBank_DCGR_List()]"+query);
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

	//금융 상담현황 표시 및 날짜 기준 new 표시
	public Vector Count_serv_bc_item(String off_id){

		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		
		query = " SELECT * FROM ( \n"+
				" SELECT OFF_ID, SERV_ID, SEQ_NO, GUBUN, SD_DT, END_YN \n"+
				" , RANK() OVER (PARTITION BY OFF_ID, SERV_ID ORDER BY  SEQ_NO DESC) RN \n"+
				" , DECODE(MAX(GUBUN) OVER (PARTITION BY OFF_ID, SERV_ID ORDER BY  SEQ_NO DESC),'6','Y','N') CLOSEYN \n"+
				" , CASE WHEN TO_DATE(SD_DT,'YYYYMMDD') >= TRUNC(SYSDATE) - 1 THEN 'NEW' ELSE '' END NEWYN \n"+
				" FROM SERV_BC_ITEM) WHERE RN = 1 AND CLOSEYN = 'N' AND NVL(END_YN,'N') = 'N' \n"+
				" and off_id = '"+off_id+"'  ";

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
			System.out.println("[Serv_EmpDatabase:Count_serv_bc_item()]"+e);
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


	public Vector getServ_empMailing(String gubun1, String gubun2){

		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String brid = "";

		
		query = " SELECT B.OFF_NM AS COM_NM, A.DEPT_NM AS BR_NM, A.EMP_NM AS AGNT_NM, NVL(A.POS,A.EMP_LEVEL) AS AGNT_TITLE, A.EMP_EMAIL AS FIN_EMAIL,   \n"+
				" A.EMP_MTEL AS FIN_M_TEL, NVL(A.EMP_TEL,A.EMP_HTEL) AS FIN_TEL, A.EMP_FAX AS FIN_FAX, A.EMP_POST AS FIN_ZIP, A.EMP_ADDR AS FIN_ADDR \n"+
				" FROM SERV_EMP A,(SELECT * FROM SERV_OFF WHERE OFF_ST ='7' AND CAR_COMP_ID = '0001') B, (SELECT * FROM code  WHERE c_st='0025' ) c \n"+
				" WHERE A.off_id = B.OFF_ID AND A.EMP_VALID = '1' AND b.car_comp_id=c.code(+)  "+
				" ";

		if (!gubun1.equals("")){

			if(gubun1.equals("0001")){//금융

				if(gubun2.equals("00010")){ //금융전체, 00011:은행, 00012:저축은행, 00013:캐피탈, 00014:카드사
					query += " AND c.code = '" + gubun1 + "' " ;
			}else if(gubun2.equals("00011")){
					query += " AND c.code = '" + gubun1 + "' AND a.gubun_b = '1' " ;
				}else if(gubun2.equals("00012")){
					query += " AND c.code = '" + gubun1 + "' AND a.gubun_b = '2' " ;
				}else if(gubun2.equals("00013")){
					query += " AND c.code = '" + gubun1 + "' AND a.gubun_b = '3' " ;
				}else if(gubun2.equals("00014")){
					query += " AND c.code = '" + gubun1 + "' AND a.gubun_b = '4' " ;
				}else if(gubun2.equals("00015")){
					query += " AND c.code = '" + gubun1 + "' AND a.gubun_b = '5' " ;
				}else{
					query += " AND c.code = '" + gubun1 + "'" ;
				}

			}else{
				query += " AND c.code = '" + gubun1 + "'" ;
			}
		}


		query += " ORDER BY B.OFF_NM, A.OFF_ID";

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
			System.out.println("[Serv_EmpDatabase:getServ_empMailing()]"+e);
			System.out.println("[Serv_EmpDatabase:getServ_empMailing()]"+query);
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

	//명함관리 금융거래 상담현황 종결처리
	public int updateEndBCSD(String reg_id, String end_yn, String off_id, String serv_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";
				
		query = "	update SERV_BC_ITEM set  END_YN = '"+end_yn+"', UPDATE_ID = '"+reg_id+"', UPDATE_DT = to_char(sysdate,'YYYYMMDD') "+   //
				"   where off_id = '"+off_id+"' and serv_id = '"+serv_id+"' ";
		
		
		try 
		{		
			conn.setAutoCommit(false);	
		
			pstmt = conn.prepareStatement(query);

			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[Serv_EmpDatabase:updateEndBCSD]\n"+e);
			System.out.println("[Serv_EmpDatabase:updateEndBCSD]\n"+query);
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

	//리스트 대출거래잔액 표시
	public Hashtable getServ_Bank_alt_rest(String cpt_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		 query = " SELECT * FROM (SELECT b.nm AS 금융사, a.cont_dt AS 체결일자, a.cont_dt AS 실행개시일, a.cls_est_dt AS 실행종료일, DECODE(a.revolving,'Y','회전','Non') AS 회전여부, a.cont_amt AS 약정한도금액, e.alt_prn_amt AS 상환금액, e.alt_rest AS 상환잔액 ,rank() over(ORDER BY a.cont_dt desc) AS rank "+
						 " FROM WORKING_FUND a, (SELECT nm, code FROM CODE WHERE c_st='0003' ) b, "+
						 " (SELECT fund_id, SUM(alt_prn_amt) alt_prn_amt, SUM(alt_rest) alt_rest FROM "+
						 " (SELECT a.fund_id, a.lend_id, c.rtn_seq, SUM(alt_prn_amt) alt_prn_amt, MIN(alt_rest) alt_rest FROM LEND_BANK a, BANK_RTN b, SCD_BANK c WHERE a.lend_id=b.lend_id AND b.lend_id=c.lend_id AND b.seq=c.RTN_seq AND c.pay_yn='1' GROUP BY a.fund_id, a.lend_id, c.rtn_seq "+
						 " UNION ALL "+
			             " SELECT a.fund_id, a.car_mng_id AS lend_id, '' rtn_seq, SUM(alt_prn) alt_prn_amt, MIN(alt_rest) alt_rest FROM allot a, "+
						 " scd_alt_case c, cont d, (SELECT max(reg_dt||rent_l_cd) rent_l_cd FROM CONT WHERE rent_l_cd NOT LIKE 'RM%' GROUP BY car_mng_id) H WHERE a.lend_id IS NULL AND a.fund_id IS NOT NULL AND a.car_mng_id=c.car_mng_id AND c.pay_yn='1' AND a.rent_mng_id=d.rent_mng_id AND a.rent_l_cd=d.rent_l_cd AND d.reg_dt||d.rent_l_cd=H.rent_l_cd GROUP BY a.fund_id, a.car_mng_id ) GROUP BY fund_id ) e "+
						 " WHERE a.CONT_BN=B.CODE AND a.fund_id=e.fund_id AND a.CONT_BN='"+cpt_cd+"' ORDER BY a.cont_dt desc  ) WHERE RANK = '1'		 ";


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();   
			
    			
			if(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[Serv_EmpDatabase:getServ_Bank_alt_rest]"+e);
			System.out.println("[Serv_EmpDatabase:getServ_Bank_alt_rest]"+query);
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


	//상담현황 1건 조회
	public Hashtable getsd_vidw_modify(String off_id, String serv_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " SELECT OFF_ID,SERV_ID,SEQ_NO,GUBUN,SD_DT,G_SMNG1,G_SMNG2,G_SMNG3,D_SMNG1,D_SMNG2,D_SMNG3,ITEM1,ITEM2,NOTE,REG_ID,REG_DT,END_YN,UPDATE_ID,UPDATE_DT "+
						 " FROM SERV_BC_ITEM where off_id='"+off_id+"' and serv_id='"+serv_id+"' ";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();   
			
    			
			if(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[Serv_EmpDatabase:getsd_vidw_modify]"+e);
			System.out.println("[Serv_EmpDatabase:getsd_vidw_modify]"+query);
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

	public int updatesd_vidw_modify(BizcardBean bean){
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";

		query = " update SERV_BC_ITEM set "+
				" gubun = ?, sd_dt = replace(?,'-',''), g_smng1 = ?, g_smng2 = ?, g_smng3 = ?, "+
				"  d_smng1 = ?, d_smng2 = ?, d_smng3 = ?, item1 = ?, item2 = ?, note = ?, UPDATE_ID = ?, UPDATE_DT  = to_char(sysdate,'yyyymmdd') "+
				"  where off_id = ? and serv_id = ?  "+
				"   ";

		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getGubun().trim()); 
			pstmt.setString(2, bean.getSd_dt().trim());			
			pstmt.setString(3, bean.getG_smng1().trim()); 
			pstmt.setString(4, bean.getG_smng2().trim()); 
			pstmt.setString(5, bean.getG_smng3().trim()); 
			pstmt.setString(6, bean.getD_smng1().trim()); 
			pstmt.setString(7, bean.getD_smng2().trim()); 
			pstmt.setString(8, bean.getD_smng3().trim()); 
			pstmt.setString(9, bean.getItem1().trim());
			pstmt.setString(10, bean.getItem2().trim());	
			pstmt.setString(11, bean.getNote().trim());	
			pstmt.setString(12, bean.getUpdate_id().trim());	
			pstmt.setString(13, bean.getOff_id().trim());
			pstmt.setString(14, bean.getServ_id().trim()); 
          
			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();


		} catch (SQLException e) {
			System.out.println("[Serv_EmpDatabase:updatesd_vidw_modify]\n"+e);
			System.out.println("[Serv_EmpDatabase:updatesd_vidw_modify]\n"+query);
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


	//메일발송 대상/비대상 처리
	public int update_email_yn(String off_id, String seq, String yn)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";

		query = " UPDATE SERV_EMP SET emp_email_yn = ?  \n"+
				" where off_id = ? and seq=? ";		

		try 
		{		
			conn.setAutoCommit(false);	
		
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, yn);
			pstmt.setString(2, off_id);
			pstmt.setString(3, seq);


			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[Serv_EmpDatabase:update_email_yn]\n"+e);
			System.out.println("[Serv_EmpDatabase:update_email_yn]\n"+query);
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

	public Hashtable getServOffChk(String off_nm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
	
		query = " SELECT off_id, br_id, car_comp_id, off_nm, off_tel, off_post, off_addr, bank, acc_no, note, reg_dt, start_dt, close_dt, acc_note, deal_note, gubun_b "+
						 " FROM serv_off WHERE off_nm = '"+off_nm+"'";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();   
			
				
			if(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();
	
		} catch (SQLException e) {
			System.out.println("[Serv_EmpDatabase:getServOffChk]"+e);
			System.out.println("[Serv_EmpDatabase:getServOffChk]"+query);
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

	public String getServOffId(String bank_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String off_id = "";
		String query = "";
	
		query = " SELECT off_id FROM serv_off WHERE off_st = '7' and cpt_cd = '"+bank_id+"'";
	
	
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();   
						
			if(rs.next())
			{
				off_id = rs.getString(1);			
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[Serv_EmpDatabase:getServOffId]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
	            if(rs != null )		rs.close();
	            if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return off_id;
		}
	}

	//대출담당자 
	public String getServEmpNm(String off_id, int seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String emp_nm = "";
		String query = "";
	
		query = " SELECT emp_nm FROM serv_emp WHERE off_id = '"+off_id+"' and seq = "+seq;
	
	
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();   
						
			if(rs.next())
			{
				emp_nm = rs.getString(1);			
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[Serv_EmpDatabase:getServEmpNm]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
	            if(rs != null )		rs.close();
	            if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return emp_nm;
		}
	}
	
	public Vector getServ_offList_Auction(){

		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		
		query = " SELECT a.off_id, a.off_nm, a.off_tel  \r\n" + 
				"FROM   serv_off a \r\n" + 
				"WHERE  a.off_nm LIKE '%탁송%' AND a.car_comp_id='0009'\r\n" + 
				"ORDER BY a.off_id ";
		
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
			System.out.println("[Serv_EmpDatabase:getServ_offList_Auction]"+e);
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

	public Vector getServ_offList_Auction_Cons(){

		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		
		query = " SELECT a.off_nm, a.off_tel, b.emp_nm, b.emp_fax, b.emp_mtel  \r\n" + 
				"FROM   serv_off a, serv_emp b \r\n" + 
				"WHERE  a.off_nm LIKE '%탁송%' AND a.car_comp_id='0009' AND a.off_id=b.off_id \r\n" + 
				"ORDER BY a.off_id, b.seq ";
		
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
			System.out.println("[Serv_EmpDatabase:getServ_offList_Auction_Cons]"+e);
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