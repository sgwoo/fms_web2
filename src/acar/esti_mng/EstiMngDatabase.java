package acar.esti_mng;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;


public class EstiMngDatabase
{
	private Connection conn = null;
	public static EstiMngDatabase db;
	
	public static EstiMngDatabase getInstance()
	{
		if(EstiMngDatabase.db == null)
			EstiMngDatabase.db = new EstiMngDatabase();
		return EstiMngDatabase.db;
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


	//select-----------------------------------------------------------------------------------------------------------------------------------------

	/*견적등록 (ESTI_REG 테이블) 한건 조회*/
	public EstiRegBean getEstiReg(String est_id)
	{
		getConnection();

		EstiRegBean bean = new EstiRegBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT * FROM esti_reg WHERE est_id=? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, est_id);
		   	rs = pstmt.executeQuery();

			while(rs.next())
			{
				bean.setEst_id		(rs.getString(1));
				bean.setEst_st		(rs.getString(2));
				bean.setCar_type	(rs.getString(3));
				bean.setEst_dt		(rs.getString(4));
				bean.setEst_nm		(rs.getString(5));
				bean.setEst_mgr		(rs.getString(6));
				bean.setEst_tel		(rs.getString(7));
				bean.setEst_fax		(rs.getString(8));
				bean.setCar_comp_id	(rs.getString(9));
				bean.setCar_name	(rs.getString(10));
				bean.setCar_amt		(rs.getInt(11));
				bean.setOpt_amt		(rs.getInt(12));
				bean.setO_1			(rs.getInt(13));
				bean.setCar_no		(rs.getString(14));
				bean.setCar_mng_id	(rs.getString(15));
				bean.setMng_id		(rs.getString(16));
				bean.setReg_id		(rs.getString(17));
				bean.setReg_dt		(rs.getString(18));	
				bean.setUpd_id		(rs.getString(19));
				bean.setUpd_dt		(rs.getString(20));
				bean.setEmp_id		(rs.getString(21));
				bean.setSpr_kd		(rs.getString(22));

			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[EstiMngDatabase:getEstiReg]\n"+e);
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

	/*견적내용 (ESTI_LIST 테이블) 한건 조회*/
	public EstiListBean getEstiList(String est_id, String seq)
	{
		getConnection();

		EstiListBean bean = new EstiListBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT * FROM esti_list WHERE est_id=? and seq=? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, est_id);
			pstmt.setString(2, seq);
		   	rs = pstmt.executeQuery();

			while(rs.next())
			{
				bean.setEst_id	(rs.getString(1));
				bean.setSeq		(rs.getString(2));
				bean.setA_a		(rs.getString(3));
				bean.setA_b		(rs.getString(4));
				bean.setFee_amt	(rs.getInt(5));   
				bean.setPp_amt	(rs.getInt(6));   
				bean.setRo_13	(rs.getString(7));
				bean.setGu_yn	(rs.getString(8));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[EstiMngDatabase:getEstiList]\n"+e);
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

	/*견적내용 (ESTI_LIST 테이블) 견적 한건에 대한 리스트 조회*/
	public Vector getEstiLists(String est_id)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	" SELECT * from esti_list WHERE est_id = ? ORDER BY seq ";
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, est_id);
			rs = pstmt.executeQuery();

			while(rs.next()){
				EstiListBean bean = new EstiListBean();
				bean.setEst_id	(rs.getString(1));
				bean.setSeq		(rs.getString(2));
				bean.setA_a		(rs.getString(3));
				bean.setA_b		(rs.getString(4));
				bean.setFee_amt	(rs.getInt(5));   
				bean.setPp_amt	(rs.getInt(6));   
				bean.setRo_13	(rs.getString(7));
				bean.setGu_yn	(rs.getString(8));
				vt.add(bean);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[EstiMngDatabase:getEstiLists]\n"+e);
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


	/*견적진행내용 (ESTI_CONT 테이블) 한건 조회*/
	public EstiContBean getEstiCont(String est_id, String seq)
	{
		getConnection();

		EstiContBean bean = new EstiContBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT * FROM esti_cont WHERE est_id=? and seq=? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, est_id);
			pstmt.setString(2, seq);
		   	rs = pstmt.executeQuery();

			while(rs.next())
			{
				bean.setEst_id	(rs.getString(1));
				bean.setSeq		(rs.getString(2));
				bean.setReg_dt	(rs.getString(3));
				bean.setReg_id	(rs.getString(4));
				bean.setTitle	(rs.getString(5));
				bean.setCont	(rs.getString(6));
				bean.setEnd_type(rs.getString(7));
				bean.setNend_st	(rs.getString(8));
				bean.setNend_cau(rs.getString(9));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[EstiMngDatabase:getEstiCont]\n"+e);
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

	/*견적진행내용 (ESTI_CONT 테이블) 한건 조회*/
	public EstiContBean getEstiContEnd(String est_id)
	{
		getConnection();

		EstiContBean bean = new EstiContBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT * FROM esti_cont WHERE est_id=? and end_type is not null";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, est_id);
		   	rs = pstmt.executeQuery();

			while(rs.next())
			{
				bean.setEst_id	(rs.getString(1));
				bean.setSeq		(rs.getString(2));
				bean.setReg_dt	(rs.getString(3));
				bean.setReg_id	(rs.getString(4));
				bean.setTitle	(rs.getString(5));
				bean.setCont	(rs.getString(6));
				bean.setEnd_type(rs.getString(7));
				bean.setNend_st	(rs.getString(8));
				bean.setNend_cau(rs.getString(9));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[EstiMngDatabase:getEstiCont]\n"+e);
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

	/*견적내용 (ESTI_CONT 테이블) 견적 한건에 대한 리스트 조회*/
	public Vector getEstiConts(String est_id)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	" SELECT * from esti_cont WHERE est_id = ? ORDER BY reg_dt, reg_time ";
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, est_id);
			rs = pstmt.executeQuery();

			while(rs.next()){
				EstiContBean bean = new EstiContBean();
				bean.setEst_id	(rs.getString(1));
				bean.setSeq		(rs.getString(2));
				bean.setReg_dt	(rs.getString(3));
				bean.setReg_id	(rs.getString(4));
				bean.setTitle	(rs.getString(5));
				bean.setCont	(rs.getString(6));
				bean.setEnd_type(rs.getString(7));
				bean.setNend_st	(rs.getString(8));
				bean.setNend_cau(rs.getString(9));
				bean.setReg_time(rs.getString(10));
				vt.add(bean);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[EstiMngDatabase:getEstiConts]\n"+e);
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

	/*견적관리 리스트 조회*/
	public Vector getEstiList(String est_yn, String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String st_dt, String end_dt, String s_br, String s_kd, String t_wd, String sort, String asc, String s_year, String s_mon, String s_day)
	{
		getConnection();

		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String dt = "nvl(d.reg_dt,a.est_dt)";
		String search = "", s_date = "";
		String t_wd_yn = "";

		query = " select"+ 
				" a.est_id, a.est_st, a.car_type, a.est_dt, a.est_nm, a.est_mgr, a.car_name, a.o_1, a.car_no, a.mng_id, "+ 
				" b.user_nm as mng_nm,"+ 
				" decode(a.est_st,'1','진행중','2','보류중','3','마감') est_st_nm,"+ 
				" decode(a.car_type,'1','신차','2','재리스') car_type_nm,"+ 
				" nvl(c.cnt,0) cnt,"+ 
				" nvl(d.reg_dt,a.est_dt) as cont_dt, d.title, d.cont,"+ 
				" e.reg_dt as end_dt, e.cont as end_cont,"+ 
				" decode(e.end_type,'Y','계약체결','N','계약미체결') end_type_nm,"+ 
				" decode(e.nend_st,'1','타사계약','2','자가용구입','3','장기보류','4','기타') nend_st_nm,"+ 
				" decode(e.nend_cau,'1','대여료','2','선수금','3','보증보험','4','신용','5','인지도') nend_cau_nm,"+ 
				" f.emp_nm, f.emp_m_tel, f.emp_pos, g.car_off_nm, g.car_off_fax, h.nm as car_comp_nm, a.spr_kd"+ 
				" from esti_reg a, users b, "+ 
				" (select est_id, max(seq) seq, count(0) cnt from esti_cont group by est_id) c, esti_cont d,"+ 
				" (select * from esti_cont where end_type is not null) e,"+ 
				" car_off_emp f, car_off g, (select * from code where c_st='0001') h"+ 
				" where a.mng_id=b.user_id(+)"+ 
				" and a.est_id=c.est_id(+)"+ 
				" and c.est_id=d.est_id(+) and c.seq=d.seq(+)"+ 
				" and a.est_id=e.est_id(+)"+ 
				" and a.emp_id=f.emp_id(+) and f.car_off_id=g.car_off_id(+)"+ 
				" and g.car_comp_id=h.code(+)";

		if(est_yn.equals("Y")){
									query += " and a.est_st in ('1','2')";
		}else if(est_yn.equals("N")){
									query += " and a.est_st = '3'";
									dt = "e.reg_dt";
		}


		if(s_kd.equals("1"))		search	= "replace(a.est_nm, '(주)', '')||a.est_mgr";
		if(s_kd.equals("2"))		search	= "a.car_name";
		if(s_kd.equals("3"))		search	= "e.emp_nm||f.car_off_nm";
		if(s_kd.equals("4"))		search	= "a.est_nm||a.est_mgr";
		if(s_kd.equals("5"))		search	= "a.emp_id";
		if(s_kd.equals("6"))		search	= "a.car_no";


		if(t_wd.equals("")){
			if(!gubun1.equals("0") && !gubun1.equals("") && !gubun1.equals(null))		
										query	+= " and a.mng_id='"+gubun1+"'";
			if(!gubun2.equals(""))		query	+= " and a.est_st='"+gubun2+"'";

			//일자조회
			if(gubun3.equals("1"))		query	+= " and "+dt+"=to_char(sysdate-2,'YYYYMMDD')";
			if(gubun3.equals("2"))		query	+= " and "+dt+"=to_char(sysdate-1,'YYYYMMDD')";
			if(gubun3.equals("3"))		query	+= " and "+dt+"=to_char(sysdate,'YYYYMMDD')";
			if(gubun3.equals("4"))		query	+= " and "+dt+"=to_char(sysdate+1,'YYYYMMDD')";
			if(gubun3.equals("5"))		query	+= " and "+dt+"=to_char(sysdate+2,'YYYYMMDD')";
			if(gubun3.equals("6"))		query	+= " and "+dt+" like to_char(sysdate,'YYYYMM')||'%'";
			if(gubun3.equals("7")){
				if(!st_dt.equals(""))	st_dt = AddUtil.replace(st_dt, "-","");
				if(!end_dt.equals(""))	end_dt = AddUtil.replace(end_dt, "-","");
				if(st_dt.length() == 8){
					query	+= " and "+dt+" between '"+st_dt+"' and '"+end_dt+"'";
				}else{
					query	+= " and "+dt+" like '%"+st_dt+"%'";
				}
			}

			if(!gubun4.equals(""))		query	+= " and e.end_type ='"+gubun4+"'";
			if(!gubun5.equals(""))		query	+= " and e.nend_st  ='"+gubun5+"'";
			if(!gubun6.equals(""))		query	+= " and e.nend_cau ='"+gubun6+"'";

			if(!s_year.equals(""))		query	+= " and "+dt+" like '%"+s_date+"%'";

		}else{
										query	+= " and  "+search+" like '%"+t_wd+"%'";
		}

		if(!t_wd.equals(""))			query	+= " order by "+search+", "+dt+" desc";
		else{
										query	+= " order by "+dt+" desc";
		}

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
			System.out.println("[EstiMngDatabase:getEstiList]\n"+e);
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

	/*견적관리 리스트 조회*/
	public Vector getEstiListSch(String s_user_id, String s_year, String s_month, String s_day)
	{
		getConnection();

		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String dt = "nvl(d.reg_dt,a.est_dt)";
		String search = "", s_date = "";
		String t_wd_yn = "";

		query = " select"+
				" a.mng_id, nvl(d.reg_dt,a.est_dt) dt"+
				" from esti_reg a,"+
				" (select est_id, max(seq) seq, count(0) cnt from esti_cont group by est_id) c, esti_cont d,"+
				" (select * from esti_cont where end_type is not null) e, users f"+
				" where "+
				" a.est_id=c.est_id(+)"+
				" and c.est_id=d.est_id(+) and c.seq=d.seq(+)"+
				" and a.est_id=e.est_id(+) and a.mng_id=f.user_id and f.dept_id='0001'";

		if(!s_user_id.equals(""))	query += " and a.mng_id='"+s_user_id+"'";
		if(!s_year.equals(""))		query += " and "+dt+" like '"+s_year+"%'";
		if(!s_month.equals(""))		query += " and substr("+dt+",5,2)='"+s_month+"'";
		if(!s_day.equals(""))		query += " and substr("+dt+",7,2)='"+s_day+"'";

		query += " and not exists (select * from sch_prv b where a.mng_id=b.user_id and start_year='"+s_year+"' and start_mon='"+s_month+"' and  start_day='"+s_day+"' ) ";
		query += " group by a.mng_id, nvl(d.reg_dt,a.est_dt) order by a.mng_id, nvl(d.reg_dt,a.est_dt)";

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
			System.out.println("[EstiMngDatabase:getEstiListSch]\n"+e);
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

	/*견적진행관리 리스트 조회*/
	public Vector getEstiIngList(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_br, String s_kd, String t_wd, String sort, String asc)
	{
		getConnection();

		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String dt = "a.est_dt";
		String search = "";
		String t_wd_yn = "";

		query = " select"+
				" a.*, b.user_nm as mng_nm, decode(a.est_st, '2','보류중','3','마감','진행중') est_st_nm, d.*, d.reg_dt as cont_dt, nvl(c.cnt,0) cnt,"+
				" e.emp_nm, f.car_off_nm, g.nm as car_comp_nm"+
				" from esti_reg a, users b, (select est_id, max(seq) seq, count(0) cnt from esti_cont group by est_id) c, esti_cont d, car_off_emp e, car_off f, code g"+
				" where a.est_st in ('1','2')"+
				" and a.mng_id=b.user_id(+)"+
				" and a.est_id=c.est_id(+)"+
				" and c.est_id=d.est_id(+) and c.seq=d.seq(+)"+
				" and a.emp_id=e.emp_id(+) and e.car_off_id=f.car_off_id(+)"+
				" and f.car_comp_id=g.code(+) and g.c_st='0001'";

		if(s_kd.equals("1"))		search	= "replace(a.est_nm, '(주)', '')||a.est_mgr";
		if(s_kd.equals("2"))		search	= "a.car_name";
		if(s_kd.equals("3"))		search	= "e.emp_nm||f.car_off_nm";

		if(t_wd.equals("")){
			if(!gubun1.equals("0"))		query	+= " and a.mng_id='"+gubun1+"'";
			if(!gubun2.equals(""))		query	+= " and a.est_st='"+gubun2+"'";

		}else{
										query	+= " and  "+search+" like '%"+t_wd+"%'";
		}

		if(!t_wd.equals(""))			query	+= " order by "+search+", a.est_dt desc";
		else 							query	+= " order by a.est_dt desc";

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
			System.out.println("[EstiMngDatabase:getEstiIngList]\n"+e);
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

	/*견적마감관리 리스트 조회*/
	public Vector getEstiEndList(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_br, String s_kd, String t_wd, String sort, String asc, String s_year, String s_mon, String s_day)
	{
		getConnection();

		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String dt = "b.reg_dt";
		String s_date = "";
		String search = "";

		query = " select"+
				" a.*, decode(a.est_st, '2','보류중','3','마감','진행중') est_st_nm, c.user_nm as mng_nm,"+
				" b.*, b.reg_dt as end_dt, decode(b.end_type,'Y','계약체결','N','계약미체결') end_type_nm,"+
				" decode(b.nend_st,'1','타사계약','2','자가용구입','3','장기보류','4','기타') nend_st_nm"+
				" from"+
				" esti_reg a, (select * from esti_cont where end_type is not null) b, users c"+
				" where"+ 
				" a.est_st='3' and a.est_id=b.est_id(+)"+
				" and a.mng_id=c.user_id(+)";

		if(s_kd.equals("1"))		search	= "replace(a.est_nm, '(주)', '')||a.est_mgr";
		if(s_kd.equals("2"))		search	= "a.car_name";

		if(t_wd.equals("")){
			if(!gubun1.equals("0"))		query	+= " and a.mng_id   ='"+gubun1+"'";
			if(!gubun2.equals(""))		query	+= " and b.end_type ='"+gubun2+"'";
			if(!gubun3.equals(""))		query	+= " and b.nend_st  ='"+gubun3+"'";
			if(!gubun4.equals(""))		query	+= " and b.nend_cau ='"+gubun4+"'";

			if(!s_year.equals(""))		s_date = s_year;
			if(!s_mon.equals(""))		s_date = s_year+s_mon;
			if(!s_day.equals(""))		s_date = s_year+s_mon+s_day;

			if(!s_year.equals(""))		query	+= " and "+dt+" like '"+s_date+"'";

		}else{
										query	+= " and  "+search+" like '%"+t_wd+"%'";
		}

		if(!t_wd.equals(""))			query	+= " order by "+search+", a.est_dt desc";
		else 							query	+= " order by b.reg_dt desc";

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
			System.out.println("[EstiMngDatabase:getEstiIngList]\n"+e);
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

	/*거래처별 견적이력 조회*/
	public Vector getEstiHisList(String t_wd)
	{
		getConnection();

		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String dt = "a.est_dt";
		String search = "";
		String t_wd_yn = "";

		query = " select"+
				" a.*, decode(a.est_st, '2','보류중','3','마감','진행중') est_st_nm, "+
				" decode(b.end_type,'Y','계약체결','N','계약미체결') end_type_nm,"+
				" decode(b.nend_st,'1','타사계약','2','자가용구입','3','장기보류','4','기타') nend_st_nm"+
				" from"+
				" esti_reg a, (select * from esti_cont where end_type is not null) b"+
				" where"+ 
				" a.est_id=b.est_id(+)";

		if(!t_wd.equals(""))		query	+= " and a.est_nm||a.est_mgr = '"+t_wd+"'";

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
			System.out.println("[EstiMngDatabase:getEstiHisList]\n"+e);
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

	/*견적관리 거래처가 영업사원일 경우 영업사원 조회*/
	public Vector getCarOffEmpList(String s_kd, String t_wd)
	{
		getConnection();

		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String search = "";

		query = " select a.emp_id as EMP_ID,\n"
						+ " a.car_off_id as CAR_OFF_ID,\n" 
						+ " b.car_off_nm as CAR_OFF_NM, b.car_off_st, b.owner_nm as OWNER_NM,\n"
						+ " b.car_comp_id as CAR_COMP_ID,\n"
						+ " c.nm as CAR_COMP_NM,\n"
						+ " a.cust_st as CUST_ST,\n"
						+ " a.emp_nm as EMP_NM,\n"
						+ " a.emp_ssn as EMP_SSN,\n"
						+ " b.car_off_tel as CAR_OFF_TEL,\n"
						+ " b.car_off_fax as CAR_OFF_FAX,\n"
						+ " a.emp_m_tel as EMP_M_TEL,\n"
						+ " a.emp_pos as EMP_POS,\n"
						+ " a.emp_email as EMP_EMAIL,\n"
						+ " a.emp_bank as EMP_BANK,\n"
						+ " a.emp_acc_no as EMP_ACC_NO,\n"
						+ " a.emp_acc_nm as EMP_ACC_NM,a.emp_post as EMP_POST,a.emp_addr as EMP_ADDR, a.etc as ETC,\n"
						+ " b.car_off_post as CAR_OFF_POST, b.car_off_addr as CAR_OFF_ADDR, \n"
						+ " a.reg_dt, a.reg_id, a.upd_dt, a.upd_id, \n"
						+ " a.emp_h_tel, a.emp_sex \n"
				+ " from car_off_emp a, car_off b, code c\n"
				+ " where \n"
				+ " a.car_off_id = b.car_off_id \n"
				+ " and b.car_comp_id = c.code\n"
				+ " and c.c_st = '0001'\n";

		if(!t_wd.equals("")){
			if(s_kd.equals("1"))		search	= "a.emp_nm";
			if(s_kd.equals("2"))		search	= "b.owner_nm||b.car_off_nm";
	
			query	+= " and  "+search+" like '%"+t_wd+"%'";

			query	+= " order by "+search;
		}

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
			System.out.println("[EstiMngDatabase:getCarOffEmpList]\n"+e);
			System.out.println("[EstiMngDatabase:getCarOffEmpList]\n"+query);
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

	/*견적등록 담당자 리스트  조회*/
	public Vector getEstiMngIdList(String br_id)
	{
		getConnection();

		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String dt = "a.est_dt";
		String search = "";
		String t_wd_yn = "";

		query = " select a.mng_id, b.user_nm as mng_nm, count(0) cnt"+
				" from esti_reg a, users b"+
				" where a.mng_id=b.user_id(+)"+
				" and a.mng_id>0"+
				" group by mng_id, user_nm order by mng_id, user_nm";

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
			System.out.println("[EstiMngDatabase:getEstiMngIdList]\n"+e);
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

	/*견적서관리번호 생성*/
	public String getNextEst_id()
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
        String query = "";
		String n_est_id = "";

		query = " SELECT to_char(sysdate,'YYMMDD')||'-'||nvl(ltrim(to_char(to_number(max(substr(est_id, 8, 10))+1), '0000')), '0001') ID"+
				" FROM esti_reg "+
				" where est_id like to_char(sysdate,'YYMMDD')||'%'";
		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();

            if(rs.next())
            	n_est_id = rs.getString("ID");

			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[EstiMngDatabase:getNextEst_id]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return n_est_id;
		}
	}

	//insert-----------------------------------------------------------------------------------------------------------------------------------------

	/*견적관리(esti_reg 테이블) 한건 등록*/
	public int insertEstiReg(EstiRegBean bean)
	{
		getConnection();

		PreparedStatement pstmt = null;
		String query = "";
		int count = 0;
			
		query = " INSERT INTO esti_reg VALUES"+
					" ( ?, ?, ?, replace(?, '-', ''), ?,   ?, ?, ?, ?, ?, "+
					"	?, ?, ?, ?, ?,   ?, ?, sysdate, ?, ?, ?, ?)";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getEst_id());
			pstmt.setString	(2,		bean.getEst_st());
			pstmt.setString	(3,		bean.getCar_type());
			pstmt.setString	(4,		bean.getEst_dt());
			pstmt.setString	(5,		bean.getEst_nm());
			pstmt.setString	(6,		bean.getEst_mgr());
			pstmt.setString	(7,		bean.getEst_tel());
			pstmt.setString	(8,		bean.getEst_fax());
			pstmt.setString	(9,		bean.getCar_comp_id());
			pstmt.setString	(10,	bean.getCar_name());
			pstmt.setInt	(11,	bean.getCar_amt());
			pstmt.setInt	(12,	bean.getOpt_amt());
			pstmt.setInt	(13,	bean.getO_1());
			pstmt.setString	(14,	bean.getCar_no());
			pstmt.setString	(15,	bean.getCar_mng_id());
			pstmt.setString	(16,	bean.getMng_id());
			pstmt.setString	(17,	bean.getReg_id());
			pstmt.setString	(18,	bean.getUpd_id());
			pstmt.setString	(19,	bean.getUpd_dt());
			pstmt.setString	(20,	bean.getEmp_id());
			pstmt.setString	(21,	bean.getSpr_kd());
			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[EstiMngDatabase:insertEstiReg]\n"+e);
			e.printStackTrace();
			conn.rollback();
		} finally {
			try{
                if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	/*견적내용(esti_list 테이블) 한건 등록*/
	public boolean insertEstiList(EstiListBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			

		query = " INSERT INTO esti_list VALUES"+
					" ( ?, ?, ?, ?, ?,   ?, ?, ?)";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getEst_id	()	);
			pstmt.setString	(2,		bean.getSeq		()	);
			pstmt.setString	(3,		bean.getA_a		()	);
			pstmt.setString	(4,		bean.getA_b		()	);
			pstmt.setInt	(5,		bean.getFee_amt	()	);
			pstmt.setInt	(6,		bean.getPp_amt	()	);
			pstmt.setString	(7,		bean.getRo_13	()	);
			pstmt.setString	(8,		bean.getGu_yn	()	);

			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[EstiMngDatabase:insertEstiList]\n"+e);
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

	/*견적진행내용(esti_cont 테이블) 한건 등록*/
	public boolean insertEstiCont(EstiContBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		String query = "", seq = "";
			
		String id_sql = " select nvl(ltrim(to_char(to_number(max(seq)+1), '00')), '01') seq from esti_cont where est_id=? ";

		query = " INSERT INTO esti_cont VALUES"+
					" ( ?, ?, replace(?, '-', ''), ?, ?,   ?, ?, ?, ?, sysdate)";

		try 
		{
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(id_sql);
			pstmt1.setString	(1,		bean.getEst_id		()	);
	    	rs = pstmt1.executeQuery();
	    	if(rs.next()){
	    		seq=rs.getString(1);
			}
			rs.close();
			pstmt1.close();

			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getEst_id		()	);
			pstmt.setString	(2,		seq						);
			pstmt.setString	(3,		bean.getReg_dt		()	);
			pstmt.setString	(4,		bean.getReg_id		()	);
			pstmt.setString	(5,		bean.getTitle		()	);
			pstmt.setString	(6,		bean.getCont		()	);
			pstmt.setString	(7,		bean.getEnd_type	()	);
			pstmt.setString	(8,		bean.getNend_st		()	);
			pstmt.setString	(9,		bean.getNend_cau	()	);
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[EstiMngDatabase:insertEstiCont]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
             		   	if(rs != null )		rs.close();
              		  	if(pstmt != null)	pstmt.close();
            		    	if(pstmt1 != null)	pstmt1.close();
				
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}


	//update-----------------------------------------------------------------------------------------------------------------------------------------

	/*견적관리(esti_reg 테이블) 한건 수정*/
	public boolean updateEstiReg(EstiRegBean bean)
	{
		getConnection();

		PreparedStatement pstmt = null;
		String query = "";
		boolean flag = true;
			
		query = " UPDATE esti_reg SET"+
					" est_st		= ?,"+
					" car_type		= ?,"+
					" est_dt		= replace(?, '-', ''),"+
					" est_nm		= ?,"+
					" est_mgr		= ?,"+
					" est_tel		= ?,"+
					" est_fax		= ?,"+  
					" car_comp_id	= ?,"+  
					" car_name		= ?,"+  
					" car_amt		= ?,"+  
					" opt_amt		= ?,"+  
					" o_1			= ?,"+  
					" car_no		= ?,"+  
					" car_mng_id	= ?,"+  
					" mng_id		= ?,"+  
					" upd_id		= ?,"+  
					" upd_dt		= sysdate,"+
					" emp_id		= ?,"+
					" spr_kd		= ?"+
				" WHERE est_id = ?";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString	(1,		bean.getEst_st());
			pstmt.setString	(2,		bean.getCar_type());
			pstmt.setString	(3,		bean.getEst_dt());
			pstmt.setString	(4,		bean.getEst_nm());
			pstmt.setString	(5,		bean.getEst_mgr());
			pstmt.setString	(6,		bean.getEst_tel());
			pstmt.setString	(7,		bean.getEst_fax());
			pstmt.setString	(8,		bean.getCar_comp_id());
			pstmt.setString	(9,		bean.getCar_name());
			pstmt.setInt	(10,	bean.getCar_amt());
			pstmt.setInt	(11,	bean.getOpt_amt());
			pstmt.setInt	(12,	bean.getO_1());
			pstmt.setString	(13,	bean.getCar_no());
			pstmt.setString	(14,	bean.getCar_mng_id());
			pstmt.setString	(15,	bean.getMng_id());
			pstmt.setString	(16,	bean.getUpd_id());
			pstmt.setString	(17,	bean.getEmp_id());
			pstmt.setString	(18,	bean.getSpr_kd());
			pstmt.setString	(19,	bean.getEst_id());
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[EstiMngDatabase:updateEstiReg]\n"+e);
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

	/*견적관리(esti_reg 테이블) 한건 수정*/
	public boolean updateEstiReg(String est_id, String est_st, String user_id)
	{
		getConnection();

		PreparedStatement pstmt = null;
		String query = "";
		boolean flag = true;
			
		query = " UPDATE esti_reg SET"+
					" est_st		= ?,"+
					" upd_id		= ?,"+  
					" upd_dt		= sysdate"+
				" WHERE est_id = ?";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString	(1,		est_st);
			pstmt.setString	(2,		user_id);
			pstmt.setString	(3,		est_id);
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[EstiMngDatabase:updateEstiReg(String est_id, String est_st)]\n"+e);
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

	/*견적관리(esti_list 테이블) 한건 수정*/
	public boolean updateEstiList(EstiListBean bean)
	{
		getConnection();

		PreparedStatement pstmt = null;
		String query = "";
		boolean flag = true;
			
		query = " UPDATE esti_list SET"+
					" a_a		= ?,"+
					" a_b		= ?,"+
					" fee_amt	= ?,"+
					" pp_amt	= ?,"+
					" ro_13		= ?,"+
					" gu_yn		= ?"+  
				" WHERE est_id = ? and seq = ?";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString	(1,		bean.getA_a		());
			pstmt.setString	(2,		bean.getA_b		());
			pstmt.setInt	(3,		bean.getFee_amt	());
			pstmt.setInt	(4,		bean.getPp_amt	());
			pstmt.setString	(5,		bean.getRo_13	());
			pstmt.setString	(6,		bean.getGu_yn	());
			pstmt.setString	(7,		bean.getEst_id	());
			pstmt.setString	(8,		bean.getSeq		());
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[EstiMngDatabase:updateEstiList]\n"+e);
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

	/*견적관리(esti_cont 테이블) 한건 수정*/
	public boolean updateEstiCont(EstiContBean bean)
	{
		getConnection();

		PreparedStatement pstmt = null;
		String query = "";
		boolean flag = true;
			
		query = " UPDATE esti_cont SET"+
					" reg_dt	= replace(?, '-', ''),"+
					" reg_id	= ?,"+
					" title		= ?,"+
					" cont		= ?,"+
					" end_type	= ?,"+
					" nend_st	= ?,"+ 
					" nend_cau	= ?,"+
					" reg_time	= ?"+
				" WHERE est_id = ? and seq = ?";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString	(1,		bean.getReg_dt	());
			pstmt.setString	(2,		bean.getReg_id	());
			pstmt.setString	(3,		bean.getTitle	());
			pstmt.setString	(4,		bean.getCont	());
			pstmt.setString	(5,		bean.getEnd_type());
			pstmt.setString	(6,		bean.getNend_st	());
			pstmt.setString	(7,		bean.getNend_cau());
			pstmt.setString	(8,		bean.getReg_time());
			pstmt.setString	(9,		bean.getEst_id	());
			pstmt.setString	(10,	bean.getSeq		());
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[EstiMngDatabase:updateEstiCont]\n"+e);
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

	//delete-----------------------------------------------------------------------------------------------------------------------------------------

	/*견적관리(esti_reg 테이블) 한건 수정*/
	public boolean deleteEstiReg(String est_id)
	{
		getConnection();

		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		String query1 = "", query2 = "", query3 = "";
		boolean flag = true;
			
		query1 = " DELETE FROM esti_cont WHERE est_id = ?";
		query2 = " DELETE FROM esti_list WHERE est_id = ?";
		query3 = " DELETE FROM esti_reg WHERE est_id = ?";

		try 
		{
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query1);
			pstmt1.setString	(1,		est_id);
			pstmt1.executeUpdate();
			pstmt1.close();

			pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString	(1,		est_id);
			pstmt2.executeUpdate();
			pstmt2.close();

			pstmt3 = conn.prepareStatement(query3);
			pstmt3.setString	(1,		est_id);
			pstmt3.executeUpdate();
			pstmt3.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[EstiMngDatabase:deleteEstiReg]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
                if(pstmt1 != null)	pstmt1.close();
                if(pstmt2 != null)	pstmt2.close();
                if(pstmt3 != null)	pstmt3.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

}
