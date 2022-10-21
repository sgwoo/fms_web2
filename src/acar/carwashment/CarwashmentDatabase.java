package acar.carwashment;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;
import acar.common.*;
import oracle.jdbc.*;
import oracle.sql.*;

public class CarwashmentDatabase
{
	private Connection conn = null;
	public static CarwashmentDatabase db;
	
	public static CarwashmentDatabase getInstance()
	{
		if(CarwashmentDatabase.db == null)
			CarwashmentDatabase.db = new CarwashmentDatabase();
		return CarwashmentDatabase.db;
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
	
	//세차등록.

	public String insertCarwashment(CarwashmentBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		String wash_no = "";
		String query =  " insert into CARWASHMENT "+
						" ( wash_no, seq, off_id, off_nm, reg_id, reg_dt, car_mng_id, rent_mng_id, rent_l_cd, "+
						"   client_id, car_no, car_nm, cost_st, pay_st, driver_nm, driver_m_tel, wash_yn, oil_yn, oil_liter, oil_amt, etc, "+
						"   chk1, chk_input1, chk2, chk_input2, chk3, chk_input3, chk4, chk_input4, chk5, chk_input5, chk6, chk_input6, "+
						"   chk7, chk_input7, chk8, chk_input8, chk9, chk_input9, chk10, chk_input10, chk11, chk_input11, chk12, chk_input12, "+
						"   conf_dt, wash_amt "+
						" ) values "+
						" ( ?, ?, ?, ?, ?, replace(?,'-',''), ?, ?, ?, "+
						"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,	"+
						"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,	"+
						"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,	"+
						"   ?, ? "+
						" )";

		String qry_id = " select '세차'||to_char(sysdate,'YYYYMMDD')||nvl(ltrim(to_char(to_number(max(substr(wash_no,11,4))+1), '0000')), '0001') wash_no"+
						" from CARWASHMENT "+
						" where substr(wash_no,3,8)=to_char(sysdate,'YYYYMMDD')";

//System.out.println("[CarwashmentDatabase:insertCarwashment]"+qry_id);

		try
		{
			conn.setAutoCommit(false);
			pstmt1 = conn.prepareStatement(qry_id);
		   	rs = pstmt1.executeQuery();
			while(rs.next())
			{
				wash_no = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt1.close();
			conn.commit();
		}catch(Exception e){					
	        try{
				System.out.println("[CarwashmentDatabase:insertCarwashment]"+e);
				System.out.println("[CarwashmentDatabase:insertCarwashment]"+query);
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
			
			if(bean.getWash_no().equals("")){
				pstmt2.setString(1,  wash_no		      );
			}else{
				pstmt2.setString(1,  bean.getWash_no	());
				wash_no = bean.getWash_no();
			}
			pstmt2.setInt   (2,  bean.getSeq			());
			pstmt2.setString(3,  bean.getOff_id			());
			pstmt2.setString(4,  bean.getOff_nm			());
			pstmt2.setString(5, bean.getReg_id			());
			pstmt2.setString(6, bean.getReg_dt			());
			pstmt2.setString(7,  bean.getCar_mng_id		());
			pstmt2.setString(8,  bean.getRent_mng_id	());
			pstmt2.setString(9, bean.getRent_l_cd		());

			pstmt2.setString(10, bean.getClient_id		());
			pstmt2.setString(11, bean.getCar_no			());
			pstmt2.setString(12, bean.getCar_nm			());
			pstmt2.setString(13, bean.getCost_st		());
			pstmt2.setString(14, bean.getPay_st			());
			pstmt2.setString(15, bean.getDriver_nm		());
			pstmt2.setString(16, bean.getDriver_m_tel	());
			pstmt2.setString(17, bean.getWash_yn    	());
			pstmt2.setString(18, bean.getOil_yn     	());
			pstmt2.setInt   (19, bean.getOil_liter  	());
			pstmt2.setInt   (20, bean.getOil_amt		());
			pstmt2.setString(21, bean.getEtc			());

			pstmt2.setString(22, bean.getChk1			());
			pstmt2.setString(23, bean.getChk_input1		());
			pstmt2.setString(24, bean.getChk2			());
			pstmt2.setString(25, bean.getChk_input2		());
			pstmt2.setString(26, bean.getChk3			());
			pstmt2.setString(27, bean.getChk_input3		());
			pstmt2.setString(28, bean.getChk4			());
			pstmt2.setString(29, bean.getChk_input4		());
			pstmt2.setString(30, bean.getChk5			());
			pstmt2.setString(31, bean.getChk_input5		());
			pstmt2.setString(32, bean.getChk6			());
			pstmt2.setString(33, bean.getChk_input6		());
			pstmt2.setString(34, bean.getChk7			());
			pstmt2.setString(35, bean.getChk_input7		());
			pstmt2.setString(36, bean.getChk8			());
			pstmt2.setString(37, bean.getChk_input8		());
			pstmt2.setString(38, bean.getChk9			());
			pstmt2.setString(39, bean.getChk_input9		());
			pstmt2.setString(40, bean.getChk10			());
			pstmt2.setString(41, bean.getChk_input10	());
			pstmt2.setString(42, bean.getChk11			());
			pstmt2.setString(43, bean.getChk_input11	());
			pstmt2.setString(44, bean.getChk12			());
			pstmt2.setString(45, bean.getChk_input12	());

			pstmt2.setString(46, bean.getConf_dt     	());
			pstmt2.setInt   (47, bean.getWash_amt	  	());

			pstmt2.executeUpdate();			
			pstmt2.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[CarwashmentDatabase:insertCarwashment]\n"+e);

			System.out.println("[bean.getWash_no		()]\n"+bean.getWash_no		());
			System.out.println("[bean.getSeq			()]\n"+bean.getSeq			());
			System.out.println("[bean.getOff_id			()]\n"+bean.getOff_id		());
			System.out.println("[bean.getOff_nm			()]\n"+bean.getOff_nm		());
			System.out.println("[bean.getReg_id			()]\n"+bean.getReg_id		());
			System.out.println("[bean.getReg_dt			()]\n"+bean.getReg_dt		());
			System.out.println("[bean.getCar_mng_id		()]\n"+bean.getCar_mng_id	());
			System.out.println("[bean.getRent_mng_id	()]\n"+bean.getRent_mng_id	());
			System.out.println("[bean.getRent_l_cd		()]\n"+bean.getRent_l_cd	());
			System.out.println("[bean.getClient_id		()]\n"+bean.getClient_id	());
			System.out.println("[bean.getCar_no			()]\n"+bean.getCar_no		());
			System.out.println("[bean.getCar_nm			()]\n"+bean.getCar_nm		());
			System.out.println("[bean.getCost_st		()]\n"+bean.getCost_st		());
			System.out.println("[bean.getPay_st			()]\n"+bean.getPay_st		());
			System.out.println("[bean.getDriver_nm		()]\n"+bean.getDriver_nm	());
			System.out.println("[bean.getDriver_m_tel	()]\n"+bean.getDriver_m_tel	());
			System.out.println("[bean.getWash_yn    	()]\n"+bean.getWash_yn    	());
			System.out.println("[bean.getOil_yn     	()]\n"+bean.getOil_yn     	());
			System.out.println("[bean.getOil_liter  	()]\n"+bean.getOil_liter  	());
			System.out.println("[bean.getOil_est_amt	()]\n"+bean.getOil_amt	());
			System.out.println("[bean.getEtc			()]\n"+bean.getEtc			());

			System.out.println("[bean.getChk1			()]\n"+bean.getChk1			());
			System.out.println("[bean.getChk_input1		()]\n"+bean.getChk_input1	());
			System.out.println("[bean.getChk2			()]\n"+bean.getChk2			());
			System.out.println("[bean.getChk_input2		()]\n"+bean.getChk_input2	());
			System.out.println("[bean.getChk3			()]\n"+bean.getChk3			());
			System.out.println("[bean.getChk_input3		()]\n"+bean.getChk_input3	());
			System.out.println("[bean.getChk4			()]\n"+bean.getChk4			());
			System.out.println("[bean.getChk_input4		()]\n"+bean.getChk_input4	());
			System.out.println("[bean.getChk5			()]\n"+bean.getChk5			());
			System.out.println("[bean.getChk_input5		()]\n"+bean.getChk_input5	());
			System.out.println("[bean.getChk6			()]\n"+bean.getChk6			());
			System.out.println("[bean.getChk_input6		()]\n"+bean.getChk_input6	());
			System.out.println("[bean.getChk7			()]\n"+bean.getChk7			());
			System.out.println("[bean.getChk_input7		()]\n"+bean.getChk_input7	());
			System.out.println("[bean.getChk8			()]\n"+bean.getChk8			());
			System.out.println("[bean.getChk_input8		()]\n"+bean.getChk_input8	());
			System.out.println("[bean.getChk9			()]\n"+bean.getChk9			());
			System.out.println("[bean.getChk_input9		()]\n"+bean.getChk_input9	());
			System.out.println("[bean.getChk10			()]\n"+bean.getChk10		());
			System.out.println("[bean.getChk_input10	()]\n"+bean.getChk_input10	());
			System.out.println("[bean.getChk11			()]\n"+bean.getChk11		());
			System.out.println("[bean.getChk_input11	()]\n"+bean.getChk_input11	());
			System.out.println("[bean.getChk12			()]\n"+bean.getChk12		());
			System.out.println("[bean.getChk_input12	()]\n"+bean.getChk_input12	());



			e.printStackTrace();
	  		flag = false;
			wash_no = "";
			conn.rollback();
		}finally{
			try{
	            if(pstmt2 != null)	pstmt2.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return wash_no;
		}
	}

//세차현황 삭제
public boolean deleteCarwashment(String wash_no)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " delete from CARWASHMENT where wash_no=?";
		String query2 =  " delete from doc_settle where doc_st='61' and doc_id=?";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);		
			pstmt.setString(1,  wash_no);
			pstmt.executeUpdate();	
			
			pstmt = conn.prepareStatement(query2);		
			pstmt.setString(1,  wash_no);
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

//탁송현황 리스트 조회
	public Vector getCarwashmentMngList(String s_kd, String t_wd, String gubun1, String st_dt, String end_dt, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.WASH_NO,a.conf_dt, a.off_id, a.off_nm, a.driver_m_tel, a.oil_yn, a.oil_liter, a.req_dt, a.CAR_NO, "+
				" A.CAR_NM, a.REG_DT, a.DRIVER_NM, a.OIL_AMT, a.WASH_AMT, a.OIL_AMT + a.WASH_AMT AS tot_amt, b.user_nm "+
				" from carwashment a, users b WHERE a.reg_id = b.user_id(+) ";


		String dt1 = "a.REG_DT";
		String dt2 = "a.REG_DT";

		if(gubun1.equals("1"))			query += " and "+dt1+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun1.equals("3"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
		else if(gubun1.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		if(s_kd.equals("2"))	query += " and upper(nvl(a.off_nm, ' ')) like replace('%"+t_wd+"%', '-','') ";	
		if(s_kd.equals("4"))	query += " and upper(nvl(a.car_no, ' ')) like replace('%"+t_wd+"%', '-','')";	


		query += " order by a.off_id, a.wash_no, a.seq";

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
//			System.out.println("[CarwashmentDatabase:getCarwashmentMngList]\n"+query);
		} catch (SQLException e) {
			System.out.println("[CarwashmentDatabase:getCarwashmentMngList]\n"+e);
			System.out.println("[CarwashmentDatabase:getCarwashmentMngList]\n"+query);
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
	public Vector getCarwashmentReqList(String s_kd, String t_wd, String gubun1, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.*, "+
				" c.user_nm AS user_nm, "+
				" decode(a.pay_st,'1','선불','2','후불') pay_st_nm, "+
				" decode(a.cost_st,'1','아마존카','2','고객') cost_st_nm "+
				" FROM carwashment a,  "+
				" users c "+
				" WHERE a.reg_id=c.user_id(+) "+
				" AND a.req_dt IS NULL ";

		if(!gubun2.equals(""))	query += " and a.off_nm='"+gubun2+"'";

		String search = "";
		String what = "";

		if(s_kd.equals("4"))	what = "upper(nvl(a.car_no, ' '))";	
			
		if(!s_kd.equals("") && !t_wd.equals("")){
			if(s_kd.equals("6"))	query += " and "+what+" like replace('%"+t_wd+"%', '-','')";
			else					query += " and "+what+" like upper('%"+t_wd+"%') ";
		}else{

		}	

		query += " order by a.off_id, a.wash_no, a.seq";

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
			System.out.println("[CarwashmentDatabase:getConsignmentReqList]\n"+e);
			System.out.println("[CarwashmentDatabase:getConsignmentReqList]\n"+query);
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
	 * 한건 조회
	 */	
  public Hashtable  getCarwashment(String wash_no)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";


		query = " select * from carwashment where wash_no = '"+wash_no+"'";

      
		try {
			stmt = conn.createStatement();
		    rs = stmt.executeQuery(query);
		      		
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
			stmt.close();

		} catch (SQLException e) {
			System.out.println("[CarwashmentDatabase:getCarwashment]\n"+e);			
			System.out.println("[CarwashmentDatabase:getCarwashment]\n"+query);			
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


	//청구서작성 리스트 조회
	public Vector getConsignmentReqList2(String s_kd, String t_wd, String gubun1, String st_dt, String end_dt, String gubun2, String gubun3, String mode)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select * from carwashment";


		query += " order by conf_dt";
//System.out.println("[CarwashmentDatabase:getConsignmentReqList2]\n"+query);

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
			System.out.println("[CarwashmentDatabase:getConsignmentReqList2]\n"+e);
			System.out.println("[CarwashmentDatabase:getConsignmentReqList2]\n"+query);
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


public boolean updateCarwashmentReqDt(String wash_no, String req_dt, String req_code)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update carwashment set req_dt=replace(?,'-',''), req_code = ? where wash_no=?";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);		
			pstmt.setString(1,  req_dt);
			pstmt.setString(2,  req_code);
			pstmt.setString(3,  wash_no);
			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[CarwashmentDatabase:updateCarwashmentReqDt]\n"+e);
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
	 * 협력업체 운전자 조회
	 */	
	public Vector getManSearch3(String s_br, String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select distinct '운전자' gubun, driver_nm  nm, '' title, '' tel, replace(driver_m_tel,'-','') as m_tel from carwashment where driver_nm is not null and substr(reg_dt,1,8) > to_char(add_months(sysdate,-1),'YYYYMMDD')";

		if(!t_wd.equals(""))		query += " and off_nm like '%"+t_wd+"%'";

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
			System.out.println("[CarwashmentDatabase:getManSearch3]\n"+e);
			System.out.println("[CarwashmentDatabase:getManSearch3]\n"+query);
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



//문서처리 리스트 조회
	public Vector getCarwashmentReqDocList(String s_kd, String t_wd, String gubun1, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String sub_query = "";
		String query = "";

		sub_query = " select"+
				" f.doc_id as req_code, a.off_id, a.req_dt, decode(a.off_nm,'코리아탁송','S1',c.br_id) br_id, min(a.off_nm) off_nm, count(a.wash_no) cnt, "+
				" sum(a.oil_amt) oil_amt, sum(a.wash_amt) wash_amt, sum(a.wash_amt+a.oil_amt) tot_amt "+
				" from CARWASHMENT a, doc_settle b, users c, branch e, (select * from doc_settle where doc_st='62') f"+
				" where a.wash_no=b.doc_id(+) and b.user_id2=c.user_id(+) and c.br_id=e.br_id(+) and a.req_code=f.doc_id(+)"+
				" and a.req_dt is not null and a.conf_dt is not null";

		if(gubun1.equals("1"))							sub_query += " and a.req_dt like to_char(sysdate,'YYYYMM')||'%' ";
		else if(gubun1.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	sub_query += " and a.req_dt like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) sub_query += " and a.req_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		sub_query += " group by a.off_id, a.req_dt, decode(a.off_nm,'코리아탁송','S1',c.br_id), f.doc_id";

		query = " select"+
				" a.*, b.user_id1, b.user_id2, c.user_nm as user_nm1, d.user_nm as user_nm2, b.user_dt1, b.user_dt2, b.doc_no, e.br_nm"+
				" from ("+sub_query+") a, (select * from doc_settle where doc_st='62') b, users c, users d, branch e"+
				" where a.req_code=b.doc_id(+) and b.user_id1=c.user_id(+) and b.user_id2=d.user_id(+) and a.br_id=e.br_id(+)"+
				"  ";

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
//System.out.println("[CarwashmentDatabase:getCarwashmentReqDocList]\n"+sub_query);
		} catch (SQLException e) {
			System.out.println("[CarwashmentDatabase:getCarwashmentReqDocList]\n"+e);
			System.out.println("[CarwashmentDatabase:getCarwashmentReqDocList]\n"+query);
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

		query = " select a.WASH_NO,a.conf_dt, a.off_id, a.off_nm, a.driver_m_tel, a.oil_yn, a.oil_liter, a.req_dt, a.CAR_NO, A.CAR_NM, a.REG_DT, a.DRIVER_NM, a.OIL_AMT, a.WASH_AMT, a.OIL_AMT + a.WASH_AMT AS tot_amt, "+
				" c.user_nm as user_nm1, d.user_nm as user_nm2, b.user_dt1, b.user_dt2"+
				" from CARWASHMENT a, (select * from doc_settle where doc_st='61') b, users c, users d, branch e, "+
				" (select * from doc_settle where doc_st='62') g"+
				" where a.wash_no=b.doc_id(+) and b.user_id1=c.user_id(+) and b.user_id2=d.user_id(+) and c.br_id=e.br_id(+) and a.req_code=g.doc_id"+
				" and a.req_dt is not null and a.conf_dt is not null and g.doc_id='"+req_code+"'";//and a.pay_dt is null 

//		if(!pay_dt.equals(""))	query +=" and a.pay_dt = replace('"+pay_dt+"','-','')";
//		else					query +=" and a.pay_dt is null";

		query += " order by a.off_id, a.wash_no, a.seq";
//System.out.println("getConsignmentReqDocList2: "+query);
			
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
			System.out.println("[CarwashmentDatabase:getConsignmentReqDocList]\n"+e);
			System.out.println("[CarwashmentDatabase:getConsignmentReqDocList]\n"+query);
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

public boolean updateConsignmentReq(String wash_no)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update CARWASHMENT set req_dt=to_char(sysdate,'YYYYMMDD') where wash_no=?";

//System.out.println("updateConsignmentReq: "+wash_no);

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);		
			pstmt.setString(1,  wash_no);
			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[CarwashmentDatabase:updateConsignmentReq]\n"+e);
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


public boolean updateConsignmentReqCode(String wash_no, String req_code)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update CARWASHMENT set req_code=? where wash_no=?";

//System.out.println("updateConsignmentReqCode: "+req_code);
//System.out.println("updateConsignmentReqCode: "+wash_no);
		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);		
			pstmt.setString(1,  req_code);
			pstmt.setString(2,  wash_no);
			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[CarwashmentDatabase:updateConsignmentReqCode]\n"+e);
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
				" from CARWASHMENT a, (select * from doc_settle where doc_st='61') b"+
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
			System.out.println("[CarwashmentDatabase:getConsignmentReqTarget]\n"+e);
			System.out.println("[CarwashmentDatabase:getConsignmentReqTarget]\n"+query);
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

