package acar.stat_total;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;
import acar.account.*;
import acar.stat_applet.*;
import acar.common.*;
import acar.admin.*;
import acar.stat_bus.*;
import acar.stat_mng.*;
import acar.add_mark.*;

public class StatTotalDatabase
{
	private Connection conn = null;
	public static StatTotalDatabase db;
	
	public static StatTotalDatabase getInstance()
	{
		if(StatTotalDatabase.db == null)
			StatTotalDatabase.db = new StatTotalDatabase();
		return StatTotalDatabase.db;
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
	 *	리스트조회 - 공통
	 */
	public Vector getStatDebtList(String table_nm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query= " select"+
				" decode(save_dt, '', '', substr(save_dt, 1, 4)||'-'||substr(save_dt, 5, 2)||'-'||substr(save_dt, 7, 2)) save_dt"+
				" from "+table_nm+" where nvl(use_yn,'Y')='Y' group by save_dt order by save_dt desc ";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			while(rs.next())
			{				
				StatDebtBean sd = new StatDebtBean();
				sd.setSave_dt(rs.getString(1));		
				vt.add(sd);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[StatTotalDatabase:getStatDebt]"+table_nm+e);
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
	 *	마지막 등록일자 조회
	 */
	public String getMaxSaveDt(String table_nm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String save_dt = "";

		String query = "select max(save_dt) from "+table_nm;

		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next()){
				save_dt = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt.close();
		    
	  	} catch (Exception e) {
			System.out.println("[StatTotalDatabase:getMaxSaveDt]"+table_nm+e);
			e.printStackTrace();
		} finally {
			try{	
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return save_dt;
		}			
	}

	/**
	 *	중복등록 확인
	 */
	public int getInsertYn(String table_nm, String today)
	{
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		int count = 0;

		String query = "select count(0) from "+table_nm+" where save_dt="+today;

		String query2 = "delete from "+table_nm+" where save_dt="+today;

		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next()){
				count = rs.getInt(1);
			}
			rs.close();
		    pstmt.close();

			if(count > 0){
				pstmt2 = conn.prepareStatement(query2);
				pstmt2.executeUpdate();
				pstmt2.close();
				count = 0;
			}
		    
	  	} catch (Exception e) {
			System.out.println("[StatTotalDatabase:getInsertYn]"+table_nm+e);
			e.printStackTrace();
		} finally {
			try{	
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
				if(pstmt2 != null)	pstmt2.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}			
	}


	//사원별인사평점-------------------------------------------------------------------------------

	/**
	 *	사원별인사평점 조회 - 마감형식으로 변경 20130712
	 */
	public Vector getStatTotal(String br_id, String save_dt, String dept_id, String gubun_dt, String d1, String d2, String m1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		//관리현황 가중치 부여
		String cg_b1 = "0.1";
		String cg_b2 = "0.2";
		String cg_m1 = "0.7";
		String cb_b1 = "0.1";
		String cb_b2 = "0.2";
		String cb_m1 = "0";
		String cc_o = "2";
		String cc_t = "1";

		AddMarkDatabase am_db = AddMarkDatabase.getInstance();

		cg_b1 = am_db.getMarks(br_id, "", "3", "1", "0001", "1");
		cg_b2 = am_db.getMarks(br_id, "", "4", "1", "0001", "1");
		cg_m1 = am_db.getMarks(br_id, "", "5", "1", "0001", "1");
		cb_b1 = am_db.getMarks(br_id, "", "3", "9", "0001", "1");
		cb_b2 = am_db.getMarks(br_id, "", "4", "9", "0001", "1");
		cb_m1 = am_db.getMarks(br_id, "", "5", "9", "0001", "1");
		cc_o = am_db.getMarks(br_id, "", "1", "0", "0001", "1");
		cc_t = am_db.getMarks(br_id, "", "2", "0", "0001", "1");

		if(save_dt.equals("") && !gubun_dt.equals("")){
			query = " select f.nm, e.user_nm, e.user_id, e.enter_dt, "+
					" nvl(a1.cnt,0)*"+m1+" mng_ga, nvl(a2.cnt,0) dly_per, nvl(a3.cnt,0) bus_ga,"+
					" ( nvl(a1.cnt,0) + nvl(a2.cnt,0) + nvl(a3.cnt,0) ) tot_ga, nvl(a4.cnt,0) avg_ga, (("+d1+"-(nvl(a2.cnt,0)))*"+d2+") dly_ga"+
					" from  "+
					//담당직원
					" (select user_id from users where nvl(use_yn,'Y')='Y') u, "+
					//관리현황 평점
					" (select nvl(a.user_id,'999999') as user_id, (a.c_client_ga+a.cnt_b1_ga+a.cnt_b2_ga+a.cnt_m1_ga) cnt from stat_mng a where a.save_dt='"+gubun_dt+"') a1, ";
					//연체현황 평점
					if(AddUtil.parseInt(gubun_dt) < 20041029){
						query += " (select nvl(a.bus_id2,'999999') as user_id, (a.per1) cnt from stat_dly a where a.save_dt='"+gubun_dt+"') a2, ";
					}else{
						query += " (select nvl(a.bus_id2,'999999') as user_id, (a.per1) cnt from stat_settle a where a.save_dt='"+gubun_dt+"') a2, ";
					}
					//영업실적 평점
			query += " (select nvl(a.user_id,'999999') as user_id, (a.client_ga+a.gen_ga+a.put_ga+a.bas_ga) cnt from stat_bus a where a.save_dt='"+gubun_dt+"') a3, "+
					//연평균 평점
					" (select nvl(a.user_id,'999999') as user_id, avg(a.tot_ga) cnt from stat_total a where a.save_dt like to_char(sysdate, 'YYYY')||'%' group by a.user_id) a4, "+
					" users e, code f"+
					" where u.user_id=a1.user_id(+) and u.user_id=a2.user_id(+) and u.user_id=a3.user_id(+) and u.user_id=a4.user_id(+)"+
					" and u.user_id=e.user_id and e.dept_id=f.code(+) and f.c_st='0002' and f.code<>'0000' "+
					" and ( (nvl(a1.cnt,0)) + (nvl(a2.cnt,0)) ) > 0";
					
			if(!br_id.equals("")) query += " and e.br_id='"+br_id+"'";

			if(dept_id.equals("0004")){
  				query += " and e.loan_st is null";
			}else{
	  			query += " and e.dept_id='"+dept_id+"' and e.loan_st is not null ";
			}

			query += " order by ( (nvl(a1.cnt,0)*"+m1+") + (("+d1+"-(nvl(a2.cnt,0)))*"+d2+") ) desc";
					
		}else{
		
			
			query = "select c.nm, b.user_nm, b.user_id, b.enter_dt, "+
					" a.mng_ga, a.dly_per, a.bus_ga,  a.tot_ga, a.avg_ga, a.dly_ga \n "+ 
					" from stat_total a, users b, code c"+
					" where a.user_id=b.user_id and b.dept_id=c.code and c.c_st='0002' and c.code<>'0000' and b.loan_st in ('1', '2') "+
					" and a.save_dt=replace('"+save_dt+"', '-', '')";
								
			if(!br_id.equals("")) query += " and b.br_id='"+br_id+"'";

			if(dept_id.equals("0004")){
  				query += " and b.loan_st is null";
			} else if(dept_id.equals("all") ){
				query += "  and b.dept_id in ('0001','0002', '0007', '0008','0009','0010','0011', '0012', '0013','0014','0015','0016' , '0017', '0018'  )  "+
				                 "  and b.loan_st is not null \n";		
			} else {
				query += " and b.dept_id='"+dept_id+"' and b.loan_st is not null";
			}

			query += " order by b.dept_id, a.seq";

		}
		
	//	System.out.println("[StatTotalDatabase:getStatTotal]"+query);		

		try {

			pstmt = conn.prepareStatement(query);
	    		rs = pstmt.executeQuery();
			while(rs.next())
			{				
				StatTotalBean bean = new StatTotalBean();
				
				bean.setDept_nm(rs.getString(1));
				bean.setUser_nm(rs.getString(2));
				bean.setUser_id(rs.getString(3));
				bean.setEnter_dt(rs.getString(4));
				bean.setMng_ga(rs.getFloat(5));
				bean.setDly_per(rs.getFloat(6));
				bean.setBus_ga(rs.getFloat(7));
				bean.setTot_ga(rs.getFloat(8));
				bean.setAvg_ga(rs.getFloat(9));
				bean.setDly_ga(rs.getFloat(10));

				vt.add(bean);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[StatTotalDatabase:getStatTotal]"+e);
			System.out.println("[StatTotalDatabase:getStatTotal]"+query);
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
	 *	사원별인사평점 조회
	 */
	public Vector getStatTotalAvg(String br_id, String dept_id, String s_yy, String s_mm, String d1, String d2, String m1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+ 
				" c.nm, b.user_nm, b.enter_dt, a.* "+ 
				" from"+ 
				" (select user_id, avg(mng_ga+dly_ga) tot_ga, avg(mng_ga) mng_ga, avg(dly_ga) dly_ga, avg(dly_per) dly_per, avg(bus_ga) bus_ga"+
				" from stat_total where save_dt between replace('"+s_yy+"','-','') and replace('"+s_mm+"','-','') group by user_id) a,"+ 
				" users b, code c"+ 
				" where"+ 
				" a.user_id=b.user_id"+
				" and b.dept_id=c.code(+) and c.c_st='0002' and c.code<>'0000' and b.loan_st in ('1', '2') " ;
		
				 if(dept_id.equals("all") ){
					query += "  and b.dept_id in ('0001','0002', '0007', '0008','0009','0010','0011', '0012', '0013','0014','0015','0016' , '0017', '0018'  ) "+
					               "     and b.loan_st is not null \n";		
				} else {
					query += " and b.dept_id='"+dept_id+"' and b.loan_st is not null";
				}
		

			if(!br_id.equals("")) query += " and b.br_id='"+br_id+"'";

			query +=" order by b.dept_id, a.tot_ga desc";

		try {

			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			while(rs.next())
			{				
				StatTotalBean bean = new StatTotalBean();
				
				bean.setDept_nm(rs.getString(1));
				bean.setUser_nm(rs.getString(2));
				bean.setEnter_dt(rs.getString(3));
				bean.setUser_id(rs.getString(4));
				bean.setTot_ga(rs.getFloat(5));
				bean.setMng_ga(rs.getFloat(6));
				bean.setDly_ga(rs.getFloat(7));
				bean.setDly_per(rs.getFloat(8));
				bean.setBus_ga(rs.getFloat(9));
				vt.add(bean);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[StatTotalDatabase:getStatTotalAvg]"+e);
			System.out.println("[StatTotalDatabase:getStatTotalAvg]"+query);
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
	 *	사원별 영업실적현황 등록
	 */
	public boolean insertStatTotal(StatTotalBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query = " insert into stat_total (save_dt, seq, user_id,"+
						" mng_ga, dly_ga, bus_ga, tot_ga, avg_ga,"+
						" reg_id, reg_dt, use_yn, dly_per) values "+
						" (?, ?, ?,"+
						" ?, ?, ?, ?, ?,"+
						" ?, to_char(sysdate,'YYYYMMDD'), 'Y', ?)";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, bean.getSave_dt());		
			pstmt.setString(2, bean.getSeq());	
			pstmt.setString(3, bean.getUser_id());	
			pstmt.setFloat(4, bean.getMng_ga());
			pstmt.setFloat(5, bean.getDly_ga());
			pstmt.setFloat(6, bean.getBus_ga());
			pstmt.setFloat(7, bean.getTot_ga());
			pstmt.setFloat(8, bean.getAvg_ga());
			pstmt.setString(9, bean.getReg_id());	
			pstmt.setFloat(10, bean.getDly_per());			
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[StatTotalDatabase:insertStatTotal]"+e);
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
	 *	연체현황 통계자료
	 */
	public String getDlyPers(String gubun, String mode, String brch_id, String bus_id2, String st_dt, String end_dt, String d1, String d2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		LastDay ld = new LastDay();
		LastMonth lm = new LastMonth();
		String result = "";
		String jobday = "";
		String jobmonth = "";
		String day = "";
		String all = "";
		String table = "";
		String user_id ="a.user_id";
		String value = "";
		int day_minus = 0;
		int while_day = 0;
		int count =0;
		String query = "";

		if(gubun.equals("1")){
			table = "stat_total";
			value = "(a.mng_ga+a.dly_ga)";
		}else if(gubun.equals("2")){
			table = "stat_mng";
			value = "(a.cnt_b1_ga+a.cnt_b2_ga+a.cnt_m1_ga+a.c_client_ga)";
		}else if(gubun.equals("3")){
			table = "stat_dly";
			user_id = "a.bus_id2";
			value = "a.per1";
		}else if(gubun.equals("5")){
			table = "stat_settle";
			user_id = "a.bus_id2";
			value = "a.per1";
		}else if(gubun.equals("4")){
			table = "stat_bus";
			value = "(a.client_ga+a.gen_ga+a.put_ga+a.bas_ga)";
		}


		//일별통계
		if(mode.equals("d")){

			query = " select a.save_dt, to_char("+value+", 999) value "+
					" from "+table+" a, users c"+
					" where "+user_id+"=c.user_id"+
					" and a.save_dt between '"+st_dt+"' and '"+end_dt+"'"+
					" and c.br_id='"+brch_id+"' and c.user_id='"+bus_id2+"'";
			while_day = 31;

		//월별통계
		}else{

			query = " select a.save_dt save_dt, to_char(a.value, 999) value "+
					" from "+
					"      ( select "+user_id+", substr(a.save_dt,1,6) save_dt, avg("+value+") value "+
					"        from   "+table+" a"+
					"        group by "+user_id+", substr(a.save_dt,1,6)"+
					"      ) a, "+
					"      users c"+
					" where "+user_id+"=c.user_id"+
					" and a.save_dt between '"+st_dt.substring(0,6)+"' and '"+end_dt.substring(0,6)+"'"+
					" and c.br_id='"+brch_id+"' and c.user_id='"+bus_id2+"'";
			while_day = 12;
		}


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			day_minus = while_day;

			while (rs.next()) {

				if(mode.equals("d")){
					jobday = rs.getString("save_dt");
					day = ld.addDay(st_dt, while_day-day_minus);
					while ((!jobday.equals(day)) && day_minus > 0) {
						all = all + "/0";
						day_minus--;
						day = ld.addDay(st_dt, while_day-day_minus);
					}
					day_minus--;									
					all = all + "/" + rs.getString("value").trim() + "";
				}else{
					jobmonth = rs.getString("save_dt");
					day = lm.addMonth(st_dt, while_day-day_minus);
					while ((!jobmonth.equals(day)) && day_minus > 0) {
						all = all + "/0";
						day_minus--;
						day = lm.addMonth(st_dt, while_day-day_minus);
					}
					day_minus--;									
					all = all + "/" + rs.getString("value").trim() + "";			
				}
				count ++;
			}
			rs.close();
			pstmt.close();

			while (day_minus > 0) {
				all = all + "/0";
				if(mode.equals("d")){
					day = ld.addDay(st_dt, while_day-day_minus);
				}else{
					day = lm.addMonth(st_dt, while_day-day_minus);
				}
				day_minus--;
			}

			//레코드가 존재할 경우 처음 '/'는 제거한다.
			if (count > 0) all = all.substring(1);

		} catch (SQLException e) {
			System.out.println("[StatTotalDatabase:getDlyPers]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return all;
		}
	}	

	/**
	 *	연체현황 통계자료 리스트
	 */
	public String getDlyPersList(String gubun, String mode, String brch_id, String bus_id2, String st_dt, String end_dt, String d1, String d2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		LastDay ld = new LastDay();
		LastMonth lm = new LastMonth();
		String result = "";
		String jobday = "";
		String jobmonth = "";
		String day = "";
		String all = "";
		String table = "";
		String user_id ="a.user_id";
		String value = "";
		int day_minus = 0;
		int while_day = 0;
		int count =0;
		String query = "";

		if(gubun.equals("1")){
			table = "stat_total";
			value = "(a.mng_ga+a.dly_ga)";
		}else if(gubun.equals("2")){
			table = "stat_mng";
			value = "(a.cnt_b1_ga+a.cnt_b2_ga+a.cnt_m1_ga+a.c_client_ga)";
		}else if(gubun.equals("3")){
			table = "stat_dly";
			user_id = "a.bus_id2";
			value = "a.per1";
		}else if(gubun.equals("5")){
			table = "stat_settle";
			user_id = "a.bus_id2";
			value = "a.per1";
		}else if(gubun.equals("4")){
			table = "stat_bus";
			value = "(a.client_ga+a.gen_ga+a.put_ga+a.bas_ga)";
		}

		//일별통계
		if(mode.equals("d")){

			query = " select a.save_dt, "+value+" value "+
					" from "+table+" a, users c"+
					" where "+user_id+"=c.user_id"+
					" and a.save_dt between '"+st_dt+"' and '"+end_dt+"'"+
					" and c.br_id='"+brch_id+"' and c.user_id='"+bus_id2+"'";
			while_day = 31;

		//월별통계
		}else{

			query = " select a.save_dt, a.value "+
					" from "+
					"      ( select "+user_id+", substr(a.save_dt,1,6) save_dt, avg("+value+") value "+
					"        from "+table+" a"+
					"        group by "+user_id+", substr(a.save_dt,1,6) "+
					"      ) a, "+
					"      users c"+
					" where "+user_id+"=c.user_id"+
					" and a.save_dt between '"+st_dt.substring(0,6)+"' and '"+end_dt.substring(0,6)+"'"+
					" and c.br_id='"+brch_id+"' and c.user_id='"+bus_id2+"'";
			while_day = 12;
		}


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			day_minus = while_day;

			while (rs.next()) {

				if(mode.equals("d")){
					jobday = rs.getString("save_dt");
					day = ld.addDay(st_dt, while_day-day_minus);
					while ((!jobday.equals(day)) && day_minus > 0) {
						all = all + "/0";
						day_minus--;
						day = ld.addDay(st_dt, while_day-day_minus);
					}
					day_minus--;									
					all = all + "/" + rs.getString("value").trim() + "";
				}else{
					jobmonth = rs.getString("save_dt");
					day = lm.addMonth(st_dt, while_day-day_minus);
					while ((!jobmonth.equals(day)) && day_minus > 0) {
						all = all + "/0";
						day_minus--;
						day = lm.addMonth(st_dt, while_day-day_minus);
					}
					day_minus--;									
					all = all + "/" + rs.getString("value").trim() + "";			
				}
				count ++;
			}
			rs.close();
			pstmt.close();

			while (day_minus > 0) {
				all = all + "/0";
				if(mode.equals("d")){
					day = ld.addDay(st_dt, while_day-day_minus);
				}else{
					day = lm.addMonth(st_dt, while_day-day_minus);
				}
				day_minus--;
			}

			//레코드가 존재할 경우 처음 '/'는 제거한다.
			if (count > 0) all = all.substring(1);

		} catch (SQLException e) {
			System.out.println("[StatTotalDatabase:getDlyPers]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return all;
		}
	}	

	
	/**
	 *	개인별 세부리스트에서 담당자 리스트
	 */
	public Vector getStatMngUser()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.user_id, b.user_nm "+
				" from (select mng_id as user_id from cont where nvl(use_yn,'Y')='Y' and client_id not in ('000231', '000228') group by mng_id) a, users b"+
				" where a.user_id=b.user_id order by b.dept_id desc, b.enter_dt, b.user_id";
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
			System.out.println("[StatTotalDatabase:getStatMngUser]"+e);
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
	 *	개인별 관리업체 리스트
	 */
	public Vector getStatMngClientList(String s_user, String s_mng_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";
		String o_query = "";
		String t_query1 = "";
		String t_query2 = "";

		//단독
		o_query = " select DISTINCT '단독' mng_st, a.bus_id2, a.mng_id, a.client_id, a.r_site from cont a"+
				" where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228')"+
				" and a.bus_id2=nvl(a.mng_id,a.bus_id2) and a.bus_id2='"+s_user+"'";
		//공동
		t_query1 = " select DISTINCT '공동' mng_st, a.bus_id2, a.mng_id, a.client_id, a.r_site from cont a"+
				" where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228')"+
				" and a.bus_id2<>nvl(a.mng_id,a.bus_id2) and a.bus_id2='"+s_user+"'";
		//공동
		t_query2 = " select DISTINCT '공동' mng_st, a.bus_id2, a.mng_id, a.client_id, a.r_site from cont a"+
				" where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228')"+
				" and a.bus_id2<>nvl(a.mng_id,a.bus_id2) and a.mng_id='"+s_user+"'";

		if(s_mng_st.equals("1"))		sub_query = o_query;
		else if(s_mng_st.equals("2"))	sub_query = t_query1+" union all "+t_query2;
		else							sub_query = o_query+" union all "+t_query1+" union all "+t_query2;


		query = " select DISTINCT a.mng_st, a.client_id, a.r_site, nvl(b.firm_nm,b.client_nm) firm_nm, b.client_nm, c.r_site as r_site_nm, b.o_tel, b.m_tel, nvl(d.y_cnt,0) y_cnt, nvl(e.n_cnt,0) n_cnt"+
				" from ("+sub_query+") a,"+
				" client b, client_site c,"+
				" (select client_id, nvl(r_site,' ') r_site, count(0) as y_cnt from cont where nvl(use_yn,'Y')='Y' group by client_id, r_site) d,"+
				" (select client_id, nvl(r_site,' ') r_site, count(0) as n_cnt from cont where use_yn='N' group by client_id, r_site) e"+
				" where a.client_id=b.client_id and a.client_id=c.client_id(+) and a.r_site=c.seq(+)"+
				" and a.client_id=d.client_id(+) and nvl(a.r_site,' ')=d.r_site(+) and a.client_id=e.client_id(+) and nvl(a.r_site,' ')=e.r_site(+)"+
				" order by nvl(b.firm_nm,b.client_nm)";

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
			System.out.println("[StatTotalDatabase:getStatMngClientList]"+e);
			System.out.println("[StatTotalDatabase:getStatMngClientList]"+query);
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
	 *	개인별 관리업체 리스트 : 담당자들
	 */
	public String getStatMngClientUsers(String client_id, String r_site, String gubun)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String users = "";
		String query = "";
		String sub_query = "";

		if(r_site.equals("")){
			sub_query = "select "+gubun+" from cont where nvl(use_yn,'Y')='Y' and client_id='"+client_id+"' group by "+gubun;
		}else{
			sub_query = "select "+gubun+" from cont where nvl(use_yn,'Y')='Y' and client_id='"+client_id+"' and r_site='"+r_site+"' group by "+gubun;
		}

		query = " select b.user_nm"+
				" from ("+sub_query+") a, users b"+
				" where a."+gubun+"=b.user_id";

		try {

			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			while(rs.next())
			{				
				if(!users.equals("")) users = users+",";
				users = users + rs.getString(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[StatTotalDatabase:getStatMngClientUsers]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return users;
		}
	}	

	//개인별 관리업체 리스트 : 업체별 차량 리스트
	public Vector getClientCarList(String client_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector rtn = new Vector();
		String query = "";

		query = " select a.* from cont_n_view  a, car_reg c where  a.car_mng_id = c.car_mng_id(+) and a.client_id='"+ client_id +"'"+
				" order by a.use_yn desc, a.rent_dt, a.rent_mng_id";

		try	{
			pstmt = conn.prepareStatement(query);
		    rs = pstmt.executeQuery();

            while(rs.next())
            {
				RentListBean bean = new RentListBean();

			    bean.setRent_mng_id(rs.getString("RENT_MNG_ID"));		//계약관리ID
			    bean.setRent_l_cd(rs.getString("RENT_L_CD"));			//계약코드
			    bean.setRent_dt(rs.getString("RENT_DT"));				//계약일자
			    bean.setDlv_dt(rs.getString("DLV_DT"));					//출고일자
			    bean.setClient_id(rs.getString("CLIENT_ID"));					//고객ID
			    bean.setClient_nm(rs.getString("CLIENT_NM"));					//고객 대표자명
			    bean.setFirm_nm(rs.getString("FIRM_NM"));						//상호
			    bean.setBr_id(rs.getString("BR_ID"));						//상호
			    bean.setCar_mng_id(rs.getString("CAR_MNG_ID"));					//자동차관리ID
			    bean.setInit_reg_dt(rs.getString("INIT_REG_DT"));					//최초등록일
			    bean.setReg_gubun(rs.getString("REG_GUBUN"));					//최초등록일
			    bean.setCar_no(rs.getString("CAR_NO"));						//차량번호
			    bean.setCar_num(rs.getString("CAR_NUM"));						//차대번호
			    bean.setRent_way(rs.getString("RENT_WAY"));					//대여방식
			    bean.setCon_mon(rs.getString("CON_MON"));						//대여개월
			    bean.setCar_id(rs.getString("CAR_ID"));						//차명ID
			    bean.setRent_start_dt(rs.getString("RENT_START_DT"));				//대여개시일
			    bean.setRent_end_dt(rs.getString("RENT_END_DT"));					//대여종료일
			    bean.setReg_ext_dt(rs.getString("REG_EXT_DT"));					//등록예정일?
			    bean.setRpt_no(rs.getString("RPT_NO"));						//계출번호
			    bean.setCpt_cd(rs.getString("CPT_CD"));						//은행코드
			    bean.setBus_id2(rs.getString("BUS_ID2"));					
			    bean.setMng_id(rs.getString("MNG_ID"));					
				bean.setUse_yn(rs.getString("USE_YN"));					
				bean.setRent_st(rs.getString("RENT_ST"));					
				bean.setCls_st(rs.getString("CLS_ST"));					
				bean.setCar_st(rs.getString("CAR_ST"));					
				bean.setScan_file(rs.getString("SCAN_FILE"));					
				bean.setR_site(rs.getString("R_SITE"));					
				bean.setCar_nm(rs.getString("CAR_NM"));					
			    
			    rtn.add(bean);
            }
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[StatTotalDatabase:getContList_View]\n"+e);
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
	 *	개인별 관리차량 리스트
	 */
	public Vector getStatMngCarList(String s_user, String s_mng_way, String s_mng_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";
		String o_query = "";
		String t_query1 = "";
		String t_query2 = "";
		String where = "";

		if(!s_mng_way.equals(""))	where = " and a.rent_way_cd='"+s_mng_way+"'";
		
		//단독
		o_query = " select DISTINCT '단독' mng_st, a.rent_mng_id, a.rent_l_cd, a.bus_id2, a.mng_id, a.car_mng_id from cont_n_view a"+
				" where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and a.car_mng_id is not null"+
				" and a.bus_id2=nvl(a.mng_id,a.bus_id2) and a.bus_id2='"+s_user+"'"+where;
		//공동
		t_query1 = " select DISTINCT '공동' mng_st, a.rent_mng_id, a.rent_l_cd, a.bus_id2, a.mng_id, a.car_mng_id from cont_n_view a"+
				" where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and a.car_mng_id is not null"+
				" and a.bus_id2<>nvl(a.mng_id,a.bus_id2) and a.bus_id2='"+s_user+"'"+where;
		//공동
		t_query2 = " select DISTINCT '공동' mng_st, a.rent_mng_id, a.rent_l_cd, a.bus_id2, a.mng_id, a.car_mng_id from cont_n_view a"+
				" where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and a.car_mng_id is not null"+
				" and a.bus_id2<>nvl(a.mng_id,a.bus_id2) and a.mng_id='"+s_user+"'"+where;

		if(s_mng_st.equals("1"))		sub_query = o_query;
		else if(s_mng_st.equals("2"))	sub_query = t_query1+" union all "+t_query2;
		else							sub_query = o_query+" union all "+t_query1+" union all "+t_query2;


		query = " select a.mng_st, b.*, c.car_no, c.car_nm "+
				" from ("+sub_query+") a, cont_n_view b, car_reg c "+
				" where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				" and b.car_mng_id = c.car_mng_id(+) "+			   
				" order by nvl b.firm_nm";

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
			System.out.println("[StatTotalDatabase:getStatMngCarList]"+e);
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
