package acar.stat_account;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.util.*;
import acar.database.*;
import acar.common.*;

public class StatAccountDatabase
{
	private Connection conn = null;
	public static StatAccountDatabase db;
	
	public static StatAccountDatabase getInstance()
	{
		if(StatAccountDatabase.db == null)
			StatAccountDatabase.db = new StatAccountDatabase();
		return StatAccountDatabase.db;
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


	//계약 검색 : 리스트 조회(cont,car_reg,client,fee,users,car_pur,car_etc,allot)
	public Vector getStatAccountList(String br_id, String s_kd, String t_wd, String brch_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector rtn = new Vector();
		
		String query = "";
		query = " select  a.*,  c.car_no,  c.car_nm, cn.car_name, b.car_id, '' scan_file, d.cls_st, '' cpt_cd,  '' rpt_no,  '' reg_ext_dt,  "+
				" c.car_num, a.rent_way, c.init_reg_dt,   decode(c.init_reg_dt, null, 'id', 'ud') as  reg_gubun \n"+				
				" from cont_n_view a, car_etc b, cls_cont d , car_reg c, car_nm cn  "+
				" where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd "+
				"	and a.car_mng_id = c.car_mng_id(+)   \n"+
                       		"	and b.car_id=cn.car_id(+)  and    b.car_seq=cn.car_seq(+)  \n"+
				" and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+) and a.rent_dt is not null";


		if(!brch_id.equals("")) query += " and a.brch_id like '%"+ brch_id +"%'";

		if(s_kd.equals("1"))			query += " and upper(nvl(a.rent_l_cd, ' ')) like upper('%"+ t_wd +"%')";
		else if(s_kd.equals("2"))		query += " and nvl(a.firm_nm, ' ') like '%"+ t_wd +"%' ";
		else if(s_kd.equals("3"))		query += " and (nvl(c.car_no, ' ') like '%"+ t_wd +"%' or nvl(c.first_car_no, ' ') like '%"+ t_wd +"%')";
		else if(s_kd.equals("4"))		query += " and nvl(a.substr(a.rent_l_cd,5,3), ' ') like '%"+ t_wd +"%' ";

		if(s_kd.equals("3"))	query +=" order by a.use_yn desc, a.rent_dt desc, a.reg_dt desc, a.rent_mng_id";
		else					query +=" order by a.use_yn desc, a.rent_dt, a.rent_mng_id";

		try 
		{
			pstmt = conn.prepareStatement(query);
		    rs = pstmt.executeQuery();

            while(rs.next())
            {
				RentListBean bean = new RentListBean();

			    bean.setRent_mng_id(rs.getString("RENT_MNG_ID"));		//계약관리ID
			    bean.setRent_l_cd(rs.getString("RENT_L_CD"));			//계약코드
			    bean.setRent_dt(rs.getString("RENT_DT"));				//계약일자
			    bean.setDlv_dt(rs.getString("DLV_DT"));					//출고일자
			    bean.setClient_id(rs.getString("CLIENT_ID"));			//고객ID
			    bean.setClient_nm(rs.getString("CLIENT_NM"));			//고객 대표자명
			    bean.setFirm_nm(rs.getString("FIRM_NM"));				//상호
			    bean.setBr_id(rs.getString("BRCD_ID"));					//상호
			    bean.setCar_mng_id(rs.getString("CAR_MNG_ID"));			//자동차관리ID
			    bean.setInit_reg_dt(rs.getString("INIT_REG_DT"));		//최초등록일
			    bean.setReg_gubun(rs.getString("REG_GUBUN"));			//최초등록일
			    bean.setCar_no(rs.getString("CAR_NO"));					//차량번호
			    bean.setCar_num(rs.getString("CAR_NUM"));				//차대번호
			    bean.setRent_way(rs.getString("RENT_WAY"));				//대여방식
			    bean.setCon_mon(rs.getString("CON_MON"));				//대여개월
			    bean.setCar_id(rs.getString("CAR_ID"));					//차명ID
			    bean.setRent_start_dt(rs.getString("RENT_START_DT"));	//대여개시일
			    bean.setRent_end_dt(rs.getString("RENT_END_DT"));		//대여종료일
			    bean.setReg_ext_dt(rs.getString("REG_EXT_DT"));			//등록예정일?
			    bean.setRpt_no(rs.getString("RPT_NO"));					//계출번호
			    bean.setCpt_cd(rs.getString("CPT_CD"));					//은행코드
			    bean.setBus_id2(rs.getString("BUS_ID2"));					
			    bean.setMng_id(rs.getString("MNG_ID"));					
				bean.setUse_yn(rs.getString("USE_YN"));					
				bean.setRent_st(rs.getString("RENT_ST"));					
				bean.setCls_st(rs.getString("CLS_ST"));					
				bean.setCar_st(rs.getString("CAR_ST"));					
				bean.setScan_file(rs.getString("SCAN_FILE"));					
				bean.setCar_nm(rs.getString("CAR_NM"));					
				bean.setCar_name(rs.getString("CAR_NAME"));					
			    
			    rtn.add(bean);
            }
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[StatAccountDatabase:getStatAccountList]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return rtn;
		}
    }

	/**
	 *	계약 리스트
	 */
	public Vector getContList(String mode, String value)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select  a.rent_mng_id, a.rent_l_cd, a.firm_nm, a.client_id, c.car_no, a.car_mng_id, c.car_nm, cn.car_name, b.car_id, a.rent_start_dt, a.rent_end_dt,"+
				" a.rent_way, a.bus_id2, decode(a.use_yn,'Y','대여','해지') use_yn_nm,\n"+
				" nvl2(d.cls_dt, substr(d.cls_dt,1,4)||'-'||substr(d.cls_dt,5,2)||'-'||substr(d.cls_dt,7,2),'') cls_dt "+
				" from cont_n_view a, car_etc b, cls_cont d , car_reg c, car_nm cn  "+
				" where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd "+
				"	and a.car_mng_id = c.car_mng_id(+)   \n"+
                       		"	and b.car_id=cn.car_id(+)  and    b.car_seq=cn.car_seq(+)  \n"+
				" and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+) and a.car_mng_id is not null";

		if(mode.equals("1")) query += " and a.rent_l_cd='"+value.trim()+"'";
		else if(mode.equals("2")) query += " and a.client_id='"+value.trim()+"'";
		else if(mode.equals("3")) query += " and a.car_mng_id='"+value.trim()+"'";
		else if(mode.equals("4")) query += " and substr(a.rent_l_cd,5,3)='"+value.trim()+"'";

		query += " order by a.use_yn desc";																
		
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
			System.out.println("[StatAccountDatabase:getContList]\n"+e);
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
	 *	수입지출금액 리스트 - 마감
	 */
	public Vector getAccountAmtList(String st, String save_dt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select * from stat_account where save_dt=replace('"+save_dt+"', '-', '') and st='"+st+"' order by seq" ;
		
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
			System.out.println("[StatAccountDatabase:getAccountAmtList]\n"+e);
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
	 *	수입지출금액 리스트
	 */
	public Vector getAccountAmtList(String table, String save_dt, String etc)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select a.st, a.gubun, sum(a.amt) amt"+
				" from "+table+" a, cont_n_view b"+
				" where a.rent_l_cd=b.rent_l_cd and a.car_mng_id=b.car_mng_id "+
				" and a.pay_dt<='"+save_dt+"' and a.pay_dt like to_char(sysdate, 'YYYY')||'%' "+
				" group by a.st, a.gubun order by a.st, a.gubun";																
		
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
			System.out.println("[StatAccountDatabase:getAccountAmtList]\n"+e);
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
	 *	수입지출금액 리스트
	 */
	public Vector getAccountAmtList(String table, String mode, String value, String save_dt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select a.st, a.gubun, sum(a.amt) amt"+
				" from "+table+" a, cont_n_view b"+
				" where a.rent_l_cd=b.rent_l_cd and a.car_mng_id=b.car_mng_id and (a.est_dt<='"+save_dt+"' or a.est_dt is null)";

		if(mode.equals("1")) query += " and a.rent_l_cd='"+value.trim()+"'";
		else if(mode.equals("2")) query += " and b.client_id='"+value.trim()+"'";
		else if(mode.equals("3")) query += " and a.car_mng_id='"+value.trim()+"'";
		else if(mode.equals("4")) query += " and substr(a.rent_l_cd,5,3)='"+value.trim()+"'";

		query += " group by a.st, a.gubun order by a.st, a.gubun";																
		
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
			System.out.println("[StatAccountDatabase:getAccountAmtList]\n"+e);
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
	 *	수입지출금액 항목별 세부리스트
	 */
	public Vector getAccountAmtCaseList(String table, String gubun, String mode, String value, String save_dt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select a.*, c.car_nm as car_nm2, cn.car_name"+
				" from "+table+" a, cont_n_view b, c car_reg c,  car_etc g, car_nm cn \n"+
				" where a.rent_l_cd=b.rent_l_cd and a.car_mng_id=b.car_mng_id"+
				"	and b.car_mng_id = c.car_mng_id(+)  and a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+)  \n"+
                       		"	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+)  \n"+
				" and (a.est_dt<='"+save_dt+"' or a.est_dt is null)";

		if(mode.equals("1"))	  query += " and a.rent_l_cd='"+value.trim()+"'";
		else if(mode.equals("2")) query += " and b.client_id='"+value.trim()+"'";
		else if(mode.equals("3")) query += " and a.car_mng_id='"+value.trim()+"'";
		else if(mode.equals("4")) query += " and substr(a.rent_l_cd,5,3)='"+value.trim()+"'";

		if(!gubun.equals("")) query += " and a.gubun='"+gubun.trim()+"'";

		query += " order by a.est_dt";																
		
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
			System.out.println("[StatAccountDatabase:getAccountAmtCaseList]\n"+e);
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
	 *	지출 리스트
	 */
	public Vector getExpList(String mode, String value, String save_dt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select a.st, a.gubun, sum(a.amt) amt"+
				" from stat_exp_view a, cont_n_view b"+
				" where a.rent_l_cd=b.rent_l_cd and a.car_mng_id=b.car_mng_id and replace(a.est_dt, '-', '') <='"+save_dt+"'";

		if(mode.equals("1")) query += " and a.rent_l_cd='"+value.trim()+"'";
		else if(mode.equals("2")) query += " and b.client_id='"+value.trim()+"'";
		else if(mode.equals("3")) query += " and a.car_mng_id='"+value.trim()+"'";
		else if(mode.equals("4")) query += " and substr(a.rent_l_cd,5,3)='"+value.trim()+"'";

		query += " group by a.st, a.gubun order by a.st, a.gubun";																
		
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
			System.out.println("[StatAccountDatabase:getExpList]\n"+e);
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
	 *	지출 세부내용 리스트
	 */
	public Vector getExpCaseList(String mode, String value, String save_dt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select a.*"+
				" from stat_exp_view a, cont_n_view b"+
				" where a.rent_l_cd=b.rent_l_cd and a.car_mng_id=b.car_mng_id and replace(a.est_dt, '-', '') <='"+save_dt+"'";

		if(mode.equals("1")) query += " and a.rent_l_cd='"+value.trim()+"'";
		else if(mode.equals("2")) query += " and b.client_id='"+value.trim()+"'";
		else if(mode.equals("3")) query += " and a.car_mng_id='"+value.trim()+"'";
		else if(mode.equals("4")) query += " and substr(a.rent_l_cd,5,3)='"+value.trim()+"'";

		query += " order by a.est_dt";																
		
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
			System.out.println("[StatAccountDatabase:getExpCaseList]\n"+e);
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
	 *	대손금액
	 */
	public int getCreditAmt(String mode, String value, String save_dt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		int amt=0;
		String query = "";
		query = " select sum(a.amt) amt"+
				" from credit_view a, cont_n_view b"+
				" where a.rent_l_cd=b.rent_l_cd and a.car_mng_id=b.car_mng_id and replace(a.cls_dt, '-', '') <='"+save_dt+"'";

		if(mode.equals("1")) query += " and a.rent_l_cd='"+value.trim()+"'";
		else if(mode.equals("2")) query += " and b.client_id='"+value.trim()+"'";
		else if(mode.equals("3")) query += " and a.car_mng_id='"+value.trim()+"'";
		else if(mode.equals("4")) query += " and substr(a.rent_l_cd,5,3)='"+value.trim()+"'";
	
		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
			if(rs.next()){
				amt = rs.getInt(1);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[StatAccountDatabase:getCreditAmt]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return amt;
		}
	}

	/**
	 *	대손금액 - 기간
	 */
	public int getCreditAmt(String save_dt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		int amt=0;
		String query = "";
		query = " select sum(a.amt) amt"+
				" from credit_view a, cont_n_view b"+
				" where a.rent_l_cd=b.rent_l_cd and a.car_mng_id=b.car_mng_id"+
				" and replace(a.cls_dt, '-', '') <='"+save_dt+"' and a.cls_dt like to_char(sysdate,'YYYY')||'%'";	

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
			if(rs.next()){
				amt = rs.getInt(1);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[StatAccountDatabase:getCreditAmt]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return amt;
		}
	}

	/**
	 *	대손 세부내용 리스트
	 */
	public Vector getCreditCaseList(String mode, String value, String save_dt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select a.*"+
				" from credit_view a, cont_n_view b"+
				" where a.rent_l_cd=b.rent_l_cd and a.car_mng_id=b.car_mng_id and a.cls_dt <= replace('"+save_dt+"', '-', '')";

		if(mode.equals("1")) query += " and a.rent_l_cd='"+value.trim()+"'";
		else if(mode.equals("2")) query += " and b.client_id='"+value.trim()+"'";
		else if(mode.equals("3")) query += " and a.car_mng_id='"+value.trim()+"'";
		else if(mode.equals("4")) query += " and substr(a.rent_l_cd,5,3)='"+value.trim()+"'";
		
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
			System.out.println("[StatAccountDatabase:getCreditCaseList]\n"+e);
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
	 *	수입지출현황 등록
	 */
	public boolean insertStatAccount(StatAccountBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query = "insert into stat_account values (?, ?, ?, ?, ?, ?, 'Y')";			

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, bean.getSave_dt());		
			pstmt.setString(2, bean.getSeq());	
			pstmt.setString(3, bean.getSt());	
			pstmt.setString(4, bean.getGubun());	
			pstmt.setLong(5, bean.getAmt());
			pstmt.setString(6, bean.getReg_id());		
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[StatAccountDatabase:insertStatAccount]"+e);
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



	//대여료/할부금 갭--------------------------------------------------------------------------------------------------------- 

	public Vector getStatMoney(String st_dt, String end_dt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.dt, a.fee_amt, a.fee_s_amt, a.fee_v_amt, "+
				" (nvl(b.alt_amt1,0)+nvl(d.alt_amt3,0)) alt_amt, \n"+
				" (nvl(b.alt_amt1,0)+nvl(d.alt_amt3,0)+nvl(c.prn_amt2,0)) g_alt_amt, \n"+
				" (nvl(b.prn_amt1,0)+nvl(d.prn_amt3,0)) prn_amt, \n"+
				" (nvl(b.int_amt1,0)+nvl(d.int_amt3,0)) int_amt, \n"+
				" nvl(c.prn_amt2,0) ls_prn_amt, \n"+
				" (a.fee_s_amt-(nvl(b.alt_amt1,0)+nvl(c.alt_amt2,0)+nvl(d.alt_amt3,0))) dly_amt, \n"+
				" trunc(((nvl(b.alt_amt1,0)+nvl(c.alt_amt2,0)+nvl(d.alt_amt3,0)))/a.fee_s_amt*100,0) dly_per \n"+
				" from \n"+ 
					" ( select substr(fee_est_dt,1,6) dt,   sum(fee_s_amt+fee_v_amt)     fee_amt,  sum(fee_s_amt)  fee_s_amt,  sum(fee_v_amt)		fee_v_amt from scd_fee		where nvl(bill_yn,'Y')='Y' and tm_st1='0' and tm_st2<>'4' and fee_est_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') group by substr(fee_est_dt,1,6) ) a, \n"+
					" ( select substr(S.alt_est_dt,1,6) dt, sum(S.alt_prn+S.alt_int)     alt_amt1, sum(S.alt_prn)  prn_amt1,   sum(S.alt_int)		int_amt1  "+
					"   from   SCD_ALT_CASE S, ALLOT A, CONT C, (select max(reg_dt||rent_l_cd) rent_l_cd from CONT WHERE rent_l_cd NOT LIKE 'RM%' group by car_mng_id) H	"+
					"   where  S.alt_est_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') "+
               		"	       AND    S.car_mng_id = A.car_mng_id and nvl(A.acct_code,'26400') in ('26400','29300') "+
                    "          AND    A.rent_mng_id = C.rent_mng_id AND    A.rent_l_cd = C.rent_l_cd "+
                    "          and    C.reg_dt||C.rent_l_cd=H.rent_l_cd "+
					"   group by substr(S.alt_est_dt,1,6) "+
					" ) b, \n"+
					" ( select substr(S.alt_est_dt,1,6) dt, sum(S.alt_prn+S.alt_int)     alt_amt2, sum(S.alt_prn+S.alt_int)  prn_amt2,   0 int_amt2  "+
					"   from   SCD_ALT_CASE S, ALLOT A, CONT C, (select max(reg_dt||rent_l_cd) rent_l_cd from CONT WHERE rent_l_cd NOT LIKE 'RM%' group by car_mng_id) H	"+
					"   where  S.alt_est_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') "+
               		"	       AND    S.car_mng_id = A.car_mng_id and nvl(A.acct_code,'26400')='45450' "+
                    "          AND    A.rent_mng_id = C.rent_mng_id AND    A.rent_l_cd = C.rent_l_cd "+
                    "          and    C.reg_dt||C.rent_l_cd=H.rent_l_cd "+
					"   group by substr(S.alt_est_dt,1,6) "+
					" ) c, \n"+
					" ( select substr(alt_est_dt,1,6) dt,   sum(alt_prn_amt+alt_int_amt) alt_amt3, sum(alt_prn_amt)	prn_amt3,   sum(alt_int_amt)	int_amt3  from scd_bank		where lend_id<>'0018' and alt_est_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') group by substr(alt_est_dt,1,6) ) d \n"+
				" where a.dt=b.dt(+) and a.dt=c.dt(+) and a.dt=d.dt(+) \n"+
				" order by a.dt \n";



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
			System.out.println("[StatAccountDatabase:getStatMoney]"+e);
			System.out.println("[StatAccountDatabase:getStatMoney]"+query);
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

	public Hashtable getStatMoneyMax(String st_dt, String end_dt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select max(a.fee_amt) fee_amt, "+
				"        max((nvl(b.alt_amt1,0)+nvl(c.alt_amt2,0)+nvl(d.alt_amt3,0))) alt_amt,"+
				"        max((a.fee_amt-(nvl(b.alt_amt1,0)+nvl(c.alt_amt2,0)+nvl(d.alt_amt3,0)))) dly_amt,\n"+
				"        max( trunc(((nvl(b.alt_amt1,0)+nvl(c.alt_amt2,0)+nvl(d.alt_amt3,0)))/ a.fee_amt * 100, 0)) dly_per\n"+
				" from\n"+ 
					" ( select substr(fee_est_dt,1,6) dt, sum(fee_s_amt) fee_amt from scd_fee where nvl(bill_yn,'Y')='Y' and tm_st1='0' and tm_st2<>'4' and fee_est_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') group by substr(fee_est_dt,1,6) ) a,\n"+
					" ( select substr(S.alt_est_dt,1,6) dt, sum(S.alt_prn+S.alt_int)     alt_amt1  "+
					"   from   SCD_ALT_CASE S, ALLOT A, CONT C, (select max(reg_dt||rent_l_cd) rent_l_cd from CONT WHERE rent_l_cd NOT LIKE 'RM%' group by car_mng_id) H	"+
					"   where  S.alt_est_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') "+
               		"	       AND    S.car_mng_id = A.car_mng_id and nvl(A.acct_code,'26400') in ('26400','29300') "+
                    "          AND    A.rent_mng_id = C.rent_mng_id AND    A.rent_l_cd = C.rent_l_cd "+
                    "          and    C.reg_dt||C.rent_l_cd=H.rent_l_cd "+
					"   group by substr(S.alt_est_dt,1,6) "+
					" ) b, \n"+
					" ( select substr(S.alt_est_dt,1,6) dt, sum(S.alt_prn+S.alt_int)     alt_amt2  "+
					"   from   SCD_ALT_CASE S, ALLOT A, CONT C, (select max(reg_dt||rent_l_cd) rent_l_cd from CONT WHERE rent_l_cd NOT LIKE 'RM%' group by car_mng_id) H	"+
					"   where  S.alt_est_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') "+
               		"	       AND    S.car_mng_id = A.car_mng_id and nvl(A.acct_code,'26400')='45450' "+
                    "          AND    A.rent_mng_id = C.rent_mng_id AND    A.rent_l_cd = C.rent_l_cd "+
                    "          and    C.reg_dt||C.rent_l_cd=H.rent_l_cd "+
					"   group by substr(S.alt_est_dt,1,6) "+
					" ) c, \n"+
					" ( select substr(alt_est_dt,1,6) dt, sum(alt_prn_amt+alt_int_amt) alt_amt3 from scd_bank where alt_est_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') group by substr(alt_est_dt,1,6) ) d\n"+
				" where a.dt=b.dt(+) and a.dt=c.dt(+) and a.dt=d.dt(+)";


		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
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
			stmt.close();

		} catch (SQLException e) {
			System.out.println("[StatAccountDatabase:getStatMoneyMax]"+e);
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}	

	public Vector getStatFeeDebtGap(String save_dt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select save_dt, seq, fee_amt, fee_s_amt, fee_v_amt, alt_amt, prn_amt, int_amt, dly_amt, dly_per, trunc(dly_per) dly_per2, reg_dt, ls_prn_amt, alt_amt+nvl(ls_prn_amt,0) g_alt_amt \n"+
				" from   stat_fee_debt_gap \n"+
				" where  save_dt=replace('"+save_dt+"','-','') \n"+
		        " order by seq";

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
			System.out.println("[StatAccountDatabase:getStatFeeDebtGap]"+e);
			System.out.println("[StatAccountDatabase:getStatFeeDebtGap]"+query);
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

	public Hashtable getStatFeeDebtGapMax(String save_dt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";


		query = " select max(fee_s_amt) fee_amt, max(alt_amt+nvl(ls_prn_amt,0)) alt_amt, max(dly_amt) dly_amt, trunc(max(dly_per)) dly_per, trunc(max(dly_per))+10 dly_per_add  "+
				" from   stat_fee_debt_gap \n"+ 
				" where  save_dt=replace('"+save_dt+"','-','') \n";


		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
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
			stmt.close();

		} catch (SQLException e) {
			System.out.println("[StatAccountDatabase:getStatFeeDebtGapMax]"+e);
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}
	
	//입출금현황 --------------------------------------------------------------------------------------------------------- 

	public Vector getStatFeeDebtIns(String gubun, String st_dt, String end_dt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String s_end_dt = "";
		String s_b_dt = "b_dt";

		if(gubun.equals("1"))	s_end_dt = "TO_CHAR(LAST_DAY(TO_date(substr('"+end_dt+"',1,6),'YYYYMM')),'YYYYMMDD')";
		else					s_end_dt = "'"+end_dt+"'";

		if(gubun.equals("2"))	s_b_dt = "substr(b_dt,1,6)";

		query = " SELECT "+s_b_dt+" as b_dt, ";

		if(!gubun.equals("2")) query += "TO_CHAR(TO_DATE(b_dt,'YYYYMMDD'),'DY') as b_dt_nm, ";

		query +="        SUM(DECODE(st1,'fee',DECODE(st2,'est',amt),0)) amt1, "+
				"        SUM(DECODE(st1,'fee',DECODE(st2,'pay',amt),0)) amt2, "+
				"        SUM(DECODE(st1,'debt',DECODE(st2,'est',amt),0)) amt3, "+
				"        SUM(DECODE(st1,'debt',DECODE(st2,'pay',amt),0)) amt4, "+
				"        SUM(DECODE(st1,'ins',DECODE(st2,'est',amt),0)) amt5, "+
				"        SUM(DECODE(st1,'ins',DECODE(st2,'pay',amt),0)) amt6 "+
				" FROM  \n"+
				" ( "+
//				"                  --날짜 "+
				" 				         SELECT 'day' st1, '' st2, TO_CHAR(TO_DATE('"+st_dt+"', 'YYYYMMDD') + NUM-1, 'YYYYMMDD') AS b_dt, 0 amt  "+
				" 				         FROM   (  "+
				" 				                  SELECT ROWNUM AS NUM   "+
				" 				                  FROM   DICTIONARY A,  "+
				"   				                       ( SELECT B.DAY AS BDAY, C.DAY AS CDAY   "+
				"   				                         FROM  "+
				"    				                                ( SELECT '"+st_dt+"' AS DAY FROM DUAL ) B,  "+
				"    				                                ( SELECT "+s_end_dt+" AS DAY FROM DUAL ) C  "+
				"   				                       ) B  "+
				" 				                  WHERE ROWNUM <= TO_DATE(B.CDAY, 'YYYYMMDD') - TO_DATE(B.BDAY, 'YYYYMMDD')  + 1 "+
				" 				                ) \n"+
				" 	               UNION all "+
//				" 					       --대여료 예정    "+
				" 				         SELECT 'fee' AS st1, 'est' AS st2, r_est_dt AS b_dt, amt AS amt  "+
				" 				         FROM   v_settle  "+
				" 				         where  r_est_dt BETWEEN '"+st_dt+"' AND "+s_end_dt+" \n"+
				"                  UNION all "+
//				" 					       --대여료 입금    "+
				" 				         SELECT 'fee' AS st1, 'pay' AS st2, pay_dt AS b_dt, amt as amt  "+
				" 				         FROM   v_settle  "+
				" 				         where  pay_dt BETWEEN '"+st_dt+"' AND "+s_end_dt+" \n"+
				"                  UNION all "+
//				" 					       --할부금 예정    "+
				" 				         SELECT 'debt' AS st1, 'est' AS st2, r_alt_est_dt AS b_dt, (alt_prn_amt+alt_int_amt) AS amt  "+
				" 				         FROM   scd_bank  "+
				" 				         where  r_alt_est_dt BETWEEN '"+st_dt+"' AND "+s_end_dt+" \n"+
				"                  UNION all         "+
//				" 					       --할부금 출금   "+
				" 				         SELECT 'debt' AS st1, 'pay' AS st2, pay_dt AS b_dt, (alt_prn_amt+alt_int_amt) as amt  "+
				" 				         FROM   scd_bank  "+
				" 				         where  pay_dt BETWEEN '"+st_dt+"' AND "+s_end_dt+" \n"+
				"                  UNION all "+
//				" 					       --할부금 예정    "+
				" 				         SELECT 'debt' AS st1, 'est' AS st2, r_alt_est_dt AS b_dt, (alt_prn+alt_int) AS amt  "+
				" 				         FROM   scd_alt_case  "+
				" 				         where  r_alt_est_dt BETWEEN '"+st_dt+"' AND "+s_end_dt+" \n"+
				"                  UNION all         "+
//				" 					       --할부금 출금   "+
				" 				         SELECT 'debt' AS st1, 'pay' AS st2, pay_dt AS b_dt, (alt_prn+alt_int) as amt  "+
				" 				         FROM   scd_alt_case  "+
				" 				         where  pay_dt BETWEEN '"+st_dt+"' AND "+s_end_dt+" \n"+
				"                  UNION all  "+
//				" 					       --보험료 예정    "+
				" 				         SELECT 'ins' AS st1, 'est' AS st2, r_ins_est_dt AS b_dt, decode(ins_tm2,'2',-pay_amt,pay_amt) AS amt  "+
				" 				         FROM   scd_ins  "+
				" 				         where  r_ins_est_dt BETWEEN '"+st_dt+"' AND "+s_end_dt+" \n"+
				"                  UNION all  "+
//				" 					       --보험료 출금    "+
				" 				         SELECT 'ins' AS st1, 'pay' AS st2, pay_dt AS b_dt, decode(ins_tm2,'2',-pay_amt,pay_amt) AS amt  "+
				" 				         FROM   scd_ins a  "+
				" 				         where  pay_dt BETWEEN '"+st_dt+"' AND "+s_end_dt+" \n"+
				" )  \n"+
				" GROUP BY "+s_b_dt+" \n"+
				" ORDER BY "+s_b_dt+" \n";


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
			System.out.println("[StatAccountDatabase:getStatFeeDebtIns]"+e);
			System.out.println("[StatAccountDatabase:getStatFeeDebtIns]"+query);
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

	public Vector getStatMoneyDebtList(String s_ym)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT cpt_nm, \r\n" + 
				"       TO_CHAR(ADD_MONTHS(TO_DATE('"+s_ym+"','YYYY-MM'),-2),'YYYY-MM') mm1,\r\n" + 
				"       TO_CHAR(ADD_MONTHS(TO_DATE('"+s_ym+"','YYYY-MM'),-1),'YYYY-MM') mm2,\r\n" + 
				"       TO_CHAR(ADD_MONTHS(TO_DATE('"+s_ym+"','YYYY-MM'),0),'YYYY-MM') mm3,\r\n" + 
				"       TO_CHAR(ADD_MONTHS(TO_DATE('"+s_ym+"','YYYY-MM'),1),'YYYY-MM') mm4,\r\n" + 
				"       TO_CHAR(ADD_MONTHS(TO_DATE('"+s_ym+"','YYYY-MM'),2),'YYYY-MM') mm5,       \r\n" + 
				"       SUM(DECODE(SUBSTR(alt_est_dt,1,7),TO_CHAR(ADD_MONTHS(TO_DATE('"+s_ym+"','YYYY-MM'),-3),'YYYY-MM'),alt_prn)) amt0,\r\n" +				
				"       SUM(DECODE(SUBSTR(alt_est_dt,1,7),TO_CHAR(ADD_MONTHS(TO_DATE('"+s_ym+"','YYYY-MM'),-2),'YYYY-MM'),alt_prn)) amt1,\r\n" + 
				"       SUM(DECODE(SUBSTR(alt_est_dt,1,7),TO_CHAR(ADD_MONTHS(TO_DATE('"+s_ym+"','YYYY-MM'),-1),'YYYY-MM'),alt_prn)) amt2,\r\n" + 
				"       SUM(DECODE(SUBSTR(alt_est_dt,1,7),TO_CHAR(ADD_MONTHS(TO_DATE('"+s_ym+"','YYYY-MM'),0),'YYYY-MM'),alt_prn)) amt3,\r\n" + 
				"       SUM(DECODE(SUBSTR(alt_est_dt,1,7),TO_CHAR(ADD_MONTHS(TO_DATE('"+s_ym+"','YYYY-MM'),1),'YYYY-MM'),alt_prn)) amt4,\r\n" + 
				"       SUM(DECODE(SUBSTR(alt_est_dt,1,7),TO_CHAR(ADD_MONTHS(TO_DATE('"+s_ym+"','YYYY-MM'),2),'YYYY-MM'),alt_prn)) amt5,\r\n" + 
				"       '' etc\r\n" + 
				"FROM   debt_pay_view \r\n" + 
				"where  alt_est_dt BETWEEN TO_CHAR(ADD_MONTHS(TO_DATE('"+s_ym+"','YYYY-MM'),-3),'YYYY-MM') AND TO_CHAR(ADD_MONTHS(TO_DATE('"+s_ym+"','YYYY-MM'),3),'YYYY-MM')\r\n" + 
				"GROUP BY cpt_nm\r\n" + 
				"ORDER BY cpt_nm";

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
			System.out.println("[StatAccountDatabase:getStatMoneyDebtList]"+e);
			System.out.println("[StatAccountDatabase:getStatMoneyDebtList]"+query);
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
	
}
