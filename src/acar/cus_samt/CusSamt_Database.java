/**
 * 고객지원 - 정비비관리
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2004. 9. 7.
 * @ last modify date : 
 */
package acar.cus_samt;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;
import acar.exception.DatabaseException;
import acar.exception.DataSourceEmptyException;
import acar.common.*;
import acar.cont.*;
import acar.car_service.*;

public class CusSamt_Database
{
	private Connection conn = null;
	public static CusSamt_Database db;
	
	public static CusSamt_Database getInstance()
	{
		if(CusSamt_Database.db == null)
			CusSamt_Database.db = new CusSamt_Database();
		return CusSamt_Database.db;
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

	/*
	*	정비비 리스트 조회(지출현황) 20040908.
	*/
	public Vector getServiceList(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc){
        getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select  \n"+
				"        a.car_mng_id, a.serv_id, a.accid_id, a.rent_mng_id, a.rent_l_cd, b.firm_nm, b.client_nm,\n"+
				"        c.car_no, c.car_nm||' '||cn.car_name as car_nm, decode(a.set_dt, '','미수금','수금') gubun,\n"+
				"        decode(a.serv_st, '1','순회점검', '2','일반수리', '3','보증수리', '4','운행자차', '13', '자차','7','재리스정비','12', '해지수리', '')  serv_st, "+
				"        d.off_nm, a.rep_cont, a.tot_dist,"+
				"        nvl(a.checker,'미입력') checker, a.tot_amt, b.use_yn, b.mng_id,"+ 
				"        nvl2(a.serv_dt,substr(a.serv_dt,1,4)||'-'||substr(a.serv_dt,5,2)||'-'||substr(a.serv_dt,7,2),'') serv_dt,\n"+
				"        nvl2(a.set_dt,substr(a.set_dt,1,4)||'-'||substr(a.set_dt,5,2)||'-'||substr(a.set_dt,7,2),'') set_dt\n"+
				" from   service a, cont_n_view b, serv_off d,  car_reg c,  car_etc g, car_nm cn  \n"+
				" where\n"+
				"        a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"        and a.off_id=d.off_id(+)\n"+
				"        and a.rep_amt > 0 and a.tot_amt > 0 \n"+
				"	and a.car_mng_id = c.car_mng_id  and a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+)  \n"+
                       		"	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+) ";

		/*상세조회&&세부조회*/

		//당월-계획
		if(gubun2.equals("1") && gubun3.equals("1")){		query += " and a.serv_dt like to_char(SYSDATE, 'YYYYMM')||'%'";
		//당월-수금
		}else if(gubun2.equals("1") && gubun3.equals("2")){	query += " and a.serv_dt like to_char(SYSDATE, 'YYYYMM')||'%' and a.set_dt is not null";
		//당월-미수금
		}else if(gubun2.equals("1") && gubun3.equals("3")){	query += " and a.serv_dt like to_char(SYSDATE, 'YYYYMM')||'%' and a.set_dt is null";
		//당일-계획
		}else if(gubun2.equals("2") && gubun3.equals("1")){	query += " and a.serv_dt = to_char(SYSDATE, 'YYYYMMDD')";
		//당일-수금
		}else if(gubun2.equals("2") && gubun3.equals("2")){	query += " and a.serv_dt = to_char(SYSDATE, 'YYYYMMDD') and a.set_dt = to_char(SYSDATE, 'YYYYMMDD')";
		//당일-미수금
		}else if(gubun2.equals("2") && gubun3.equals("3")){	query += " and a.serv_dt = to_char(SYSDATE, 'YYYYMMDD') and a.set_dt is null";
		//연체-계획
		}else if(gubun2.equals("3") && gubun3.equals("1")){	query += " and a.serv_dt < to_char(SYSDATE, 'YYYYMMDD') and (a.set_dt is null or a.set_dt = to_char(SYSDATE, 'YYYYMMDD'))";
		//연체-수금
		}else if(gubun2.equals("3") && gubun3.equals("2")){	query += " and a.serv_dt < to_char(SYSDATE, 'YYYYMMDD') and a.set_dt = to_char(SYSDATE, 'YYYYMMDD')";
		//연체-미수금
		}else if(gubun2.equals("3") && gubun3.equals("3")){	query += " and a.serv_dt < to_char(SYSDATE, 'YYYYMMDD') and a.set_dt is null";
		//기간-계획
		}else if(gubun2.equals("4") && gubun3.equals("1")){	query += " and a.serv_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		//기간-수금
		}else if(gubun2.equals("4") && gubun3.equals("2")){	query += " and a.set_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.set_dt not null";
		//기간-미수금
		}else if(gubun2.equals("4") && gubun3.equals("3")){	query += " and a.serv_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.set_dt is null";
		//당일+연체-계획
		}else if(gubun2.equals("6") && gubun3.equals("1")){	query += " and a.serv_dt <= to_char(SYSDATE, 'YYYYMMDD') and (a.set_dt is null or a.set_dt = to_char(SYSDATE, 'YYYYMMDD'))";
		//당일+연체-수금
		}else if(gubun2.equals("6") && gubun3.equals("2")){	query += " and a.serv_dt <= to_char(SYSDATE, 'YYYYMMDD') and a.set_dt = to_char(SYSDATE, 'YYYYMMDD')";
		//당일+연체-미수금
		}else if(gubun2.equals("6") && gubun3.equals("3")){	query += " and a.serv_dt <= to_char(SYSDATE, 'YYYYMMDD') and a.set_dt is null";
		//검색-수금
		}else if(gubun2.equals("5") && gubun3.equals("2")){	query += " and a.set_dt not null";
		//검색-미수금
		}else if(gubun2.equals("5") && gubun3.equals("3")){	query += " and a.set_dt is null";
		}

		if(gubun4.equals("2"))			query += " and a.serv_st='1'";
		else if(gubun4.equals("3"))		query += " and a.serv_st='2'";
		else if(gubun4.equals("4"))		query += " and a.serv_st='3'";
		else if(gubun4.equals("5"))		query += " and a.serv_st in ('4','5')";

		/*검색조건*/
		if(s_kd.equals("1"))		query += " and nvl(b.firm_nm, '') like '%"+t_wd+"%'\n";			
		else if(s_kd.equals("2"))	query += " and nvl(b.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(b.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and nvl(c.car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("5"))	query += " and a.tot_amt_amt like '%"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	query += " and upper(b.brch_id) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("7"))	query += " and nvl(b.r_site, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("8"))	query += " and b.mng_id= '"+t_wd+"'\n";
		else if(s_kd.equals("9"))	query += " and nvl(c.car_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("10"))	query += " and nvl(a.serv_dt, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("11"))	query += " and nvl(d.off_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("12"))	query += " and upper(a.rep_cont) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("13"))	query += " and a.tot_dist like '%"+t_wd+"%'\n";

		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		/*정렬조건*/

		if(sort_gubun.equals("0"))		query += " order by b.use_yn desc, a.serv_dt "+sort+", a.set_dt, b.firm_nm";
		else if(sort_gubun.equals("1"))	query += " order by b.use_yn desc, b.firm_nm "+sort+", a.set_dt, a.serv_dt";
		else if(sort_gubun.equals("2"))	query += " order by b.use_yn desc, d.off_nm "+sort+", b.firm_nm, a.serv_dt";
		else if(sort_gubun.equals("3"))	query += " order by b.use_yn desc, a.tot_amt "+sort+", a.set_dt, b.firm_nm, a.serv_dt";
		else if(sort_gubun.equals("5"))	query += " order by b.use_yn desc, b.car_no "+sort+", b.firm_nm, a.serv_dt";
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
			System.out.println("[CusSamt_Database:getServiceList]\n"+e);
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
            closeConnection();
			return vt;
		}
	}
	
	/*
	*	정비비 리스트 조회(지출현황) 20040908. - 관리담당자 별도 
	*/
	public Vector getServiceList(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String s_bus, String sort_gubun, String asc){
        getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select \n"+
				"        a.car_mng_id, a.serv_id, a.accid_id, a.rent_mng_id, a.rent_l_cd, b.firm_nm, b.client_nm,\n"+
				"        c.car_no, c.car_nm||' '||cn.car_name as car_nm, decode(a.set_dt, '','미수금','수금') gubun,\n"+
				"       decode(a.serv_st, '1','순회점검', '2','일반수리', '3','보증수리', '4','운행자차', '13', '자차','7','재리스정비','12', '해지수리', '') serv_st, "+
				"        d.off_nm, a.rep_cont, a.tot_dist, decode(ac.accid_st, '1','피해','2','가해','3','쌍방','6','수해', '8', '단독', '') accid_st_nm , "+
				"        nvl(a.checker,'미입력') checker, a.tot_amt, b.use_yn, b.mng_id,"+ 
				"        nvl2(a.serv_dt,substr(a.serv_dt,1,4)||'-'||substr(a.serv_dt,5,2)||'-'||substr(a.serv_dt,7,2),'') serv_dt,\n"+
				"        nvl2(a.set_dt,substr(a.set_dt,1,4)||'-'||substr(a.set_dt,5,2)||'-'||substr(a.set_dt,7,2),'') set_dt\n"+
				" from   service a, cont_n_view b, serv_off d,  car_reg c,  car_etc g, car_nm cn , accident ac \n"+
				" where\n"+
				"        a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				" 		   and a.car_mng_id=ac.car_mng_id(+) and a.accid_id=ac.accid_id(+) \n"+
				"        and nvl(ac.accid_st, '9') || nvl(ac.settle_st, '9')  <> '11'      \n"+  //100%피해건이면서 종결처리  제외 
				"        and a.off_id=d.off_id(+)\n"+
				"        and a.rep_amt > 0 and a.tot_amt > 0 \n"+
				"	and a.car_mng_id = c.car_mng_id  and a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+)  \n"+
             "	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+) ";

		/*상세조회&&세부조회*/

		//당월-계획
		if(gubun2.equals("1") && gubun3.equals("1")){		query += " and a.serv_dt like to_char(SYSDATE, 'YYYYMM')||'%'";
		//당월-수금
		}else if(gubun2.equals("1") && gubun3.equals("2")){	query += " and a.serv_dt like to_char(SYSDATE, 'YYYYMM')||'%' and a.set_dt is not null";
		//당월-미수금
		}else if(gubun2.equals("1") && gubun3.equals("3")){	query += " and a.serv_dt like to_char(SYSDATE, 'YYYYMM')||'%' and a.set_dt is null";
		//당일-계획
		}else if(gubun2.equals("2") && gubun3.equals("1")){	query += " and a.serv_dt = to_char(SYSDATE, 'YYYYMMDD')";
		//당일-수금
		}else if(gubun2.equals("2") && gubun3.equals("2")){	query += " and a.serv_dt = to_char(SYSDATE, 'YYYYMMDD') and a.set_dt = to_char(SYSDATE, 'YYYYMMDD')";
		//당일-미수금
		}else if(gubun2.equals("2") && gubun3.equals("3")){	query += " and a.serv_dt = to_char(SYSDATE, 'YYYYMMDD') and a.set_dt is null";
		//연체-계획
		}else if(gubun2.equals("3") && gubun3.equals("1")){	query += " and a.serv_dt < to_char(SYSDATE, 'YYYYMMDD') and (a.set_dt is null or a.set_dt = to_char(SYSDATE, 'YYYYMMDD'))";
		//연체-수금
		}else if(gubun2.equals("3") && gubun3.equals("2")){	query += " and a.serv_dt < to_char(SYSDATE, 'YYYYMMDD') and a.set_dt = to_char(SYSDATE, 'YYYYMMDD')";
		//연체-미수금
		}else if(gubun2.equals("3") && gubun3.equals("3")){	query += " and a.serv_dt < to_char(SYSDATE, 'YYYYMMDD') and a.set_dt is null";
		//기간-계획
		}else if(gubun2.equals("4") && gubun3.equals("1")){	query += " and a.serv_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		//기간-수금
		}else if(gubun2.equals("4") && gubun3.equals("2")){	query += " and a.set_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.set_dt not null";
		//기간-미수금
		}else if(gubun2.equals("4") && gubun3.equals("3")){	query += " and a.serv_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.set_dt is null";
		//당일+연체-계획
		}else if(gubun2.equals("6") && gubun3.equals("1")){	query += " and a.serv_dt <= to_char(SYSDATE, 'YYYYMMDD') and (a.set_dt is null or a.set_dt = to_char(SYSDATE, 'YYYYMMDD'))";
		//당일+연체-수금
		}else if(gubun2.equals("6") && gubun3.equals("2")){	query += " and a.serv_dt <= to_char(SYSDATE, 'YYYYMMDD') and a.set_dt = to_char(SYSDATE, 'YYYYMMDD')";
		//당일+연체-미수금
		}else if(gubun2.equals("6") && gubun3.equals("3")){	query += " and a.serv_dt <= to_char(SYSDATE, 'YYYYMMDD') and a.set_dt is null";
		//검색-수금
		}else if(gubun2.equals("5") && gubun3.equals("2")){	query += " and a.set_dt not null";
		//검색-미수금
		}else if(gubun2.equals("5") && gubun3.equals("3")){	query += " and a.set_dt is null";
		}

		if(gubun4.equals("2"))			query += " and a.serv_st='1'";
		else if(gubun4.equals("3"))		query += " and a.serv_st='2'";
		else if(gubun4.equals("4"))		query += " and a.serv_st='3'";
		else if(gubun4.equals("5"))		query += " and a.serv_st in ('4','5')";

		/*검색조건*/
			
		if(s_kd.equals("1"))		query += " and nvl(b.firm_nm, '') like '%"+t_wd+"%'\n";			
		else if(s_kd.equals("2"))	query += " and nvl(b.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(b.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and nvl(c.car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("5"))	query += " and a.tot_amt_amt like '%"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	query += " and upper(b.brch_id) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("7"))	query += " and nvl(b.r_site, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("9"))	query += " and nvl(c.car_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("10"))	query += " and nvl(a.serv_dt, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("11"))	query += " and nvl(d.off_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("12"))	query += " and upper(a.rep_cont) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("13"))	query += " and a.tot_dist like '%"+t_wd+"%'\n";

  
		// 담당자  
		if ( !s_bus.equals(""))   query += " and b.mng_id= '"+s_bus+"'\n";
       
		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		/*정렬조건*/

		if(sort_gubun.equals("0"))		query += " order by b.use_yn desc, a.serv_dt "+sort+", a.set_dt, b.firm_nm";
		else if(sort_gubun.equals("1"))	query += " order by b.use_yn desc, b.firm_nm "+sort+", a.set_dt, a.serv_dt";
		else if(sort_gubun.equals("2"))	query += " order by b.use_yn desc, d.off_nm "+sort+", b.firm_nm, a.serv_dt";
		else if(sort_gubun.equals("3"))	query += " order by b.use_yn desc, a.tot_amt "+sort+", a.set_dt, b.firm_nm, a.serv_dt";
		else if(sort_gubun.equals("5"))	query += " order by b.use_yn desc, b.car_no "+sort+", b.firm_nm, a.serv_dt";
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
			System.out.println("[CusSamt_Database:getServiceList]\n"+e);
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
            closeConnection();
			return vt;
		}
	}

	/*
	*	정비비 건별 스케줄 리스트 조회(지출현황) 20040909.
	*/
	public Vector getServiceScd(String m_id, String l_cd, String c_id){
        getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select"+
					" a.accid_id, a.serv_id,"+
					" decode(a.serv_st, '1','순회점검', '2','일반수리', '3','보증수리', '4','운행자차', '5','사고자차','7','재리스정비', '12', ' 해지수리', '') serv_st,"+
					" nvl(a.checker,'미입력') checker, a.off_id, b.off_nm, a.tot_dist, a.rep_amt, a.dc, a.tot_amt,"+
					" nvl2(a.serv_dt,substr(a.serv_dt,1,4)||'-'||substr(a.serv_dt,5,2)||'-'||substr(a.serv_dt,7,2),' ') serv_dt,"+
					" nvl2(a.set_dt,substr(a.set_dt,1,4)||'-'||substr(a.set_dt,5,2)||'-'||substr(a.set_dt,7,2),' ') set_dt"+
					" from service a, serv_off b"+
					" where"+
					" a.off_id=b.off_id"+
					" and a.rep_amt > 0 "+
					"  and a.car_mng_id='"+c_id+"'"+
					" order by a.serv_dt desc";
	
		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
			while(rs.next())
			{				
	            ServiceBean bean = new ServiceBean();

				bean.setRent_mng_id(m_id); 
				bean.setRent_l_cd(l_cd); 
			    bean.setCar_mng_id(c_id); 					
				bean.setServ_id(rs.getString("serv_id")); 
				bean.setAccid_id(rs.getString("accid_id")); 				
				bean.setServ_st(rs.getString("serv_st")); 
				bean.setChecker(rs.getString("checker")); 
				bean.setOff_id(rs.getString("off_id"));
				bean.setOff_nm(rs.getString("off_nm")); 
				bean.setTot_dist(rs.getString("tot_dist")); 
				bean.setRep_amt(rs.getInt("rep_amt")); 
				bean.setDc(rs.getInt("dc")); 
				bean.setTot_amt(rs.getInt("tot_amt")); 
				bean.setServ_dt(rs.getString("serv_dt").trim());
				bean.setSet_dt(rs.getString("set_dt").trim());
				vt.add(bean);	
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[CusSamt_Database:getServiceScd]\n"+e);
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
	*	차량정비현황 - 업체
	*/
		
	public Vector getServList(String off_id, String gubun1, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc){
		getConnection();
		Vector vt = new Vector();
		Statement stmt = null;
		PreparedStatement pstmt = null;
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt3 = null;
        
		ResultSet rs = null;
		String query = "";
		
		
		String query1 = "select  TO_CHAR(TO_DATE(?), 'YYYYMM') ||'01' from dual";
		String query2 = "select  TO_CHAR(TO_DATE(?) -1, 'YYYYMMDD')  from dual ";
	 	
	 	String st_dt1 = "";
		String st_dt2 = "";
	   

		query = " SELECT  a.set_dt SET_DT, a.serv_st SERV_ST, tt.a_labor A_LABOR, cr.car_no CAR_NO , cr.car_nm CAR_NM, nvl2(a.serv_dt,substr(a.serv_dt,1,4)||'-'||substr(a.serv_dt,5,2)||'-'||substr(a.serv_dt,7,2),'') SERV_DT, \n"
		    + " nvl2(a.ipgodt, substr(a.ipgodt, 1, 8), '') IPGODT, nvl2(a.chulgodt, substr(a.chulgodt, 1, 8), '')  CHULGODT,  \n"
			+ " a.checker CHECKER,  nvl(c.firm_nm, c.client_nm) CLIENT_NM, it.item ITEM , it.cnt CNT,  \n"
			+ " si.labor LABOR, si.amt AMT, a.tot_dist TOT_DIST, a.rep_amt REP_AMT, a.sup_amt SUP_AMT, a.add_amt ADD_AMT, a.dc DC, a.tot_amt TOT_AMT,  \n"
 			+ " nvl2(a.cust_plan_dt,substr(a.cust_plan_dt,1,4)||'-'||substr(a.cust_plan_dt,5,2)||'-'||substr(a.cust_plan_dt,7,2),'') CUST_PLAN_DT, a.cust_amt CUST_AMT,  \n"
 			+ " decode(a.jung_st, '0', '미정산', '' , '미정산', null, '미정산', a.jung_st||'회차') JUNG_ST, \n"
 		    + " c.client_id CLIENT_ID ,  a.car_mng_id CAR_MNG_ID, a.serv_id SERV_ID, a.accid_id ACCID_ID, a.rent_mng_id RENT_MNG_ID, a.rent_l_cd RENT_L_CD, a.off_id OFF_ID, a.serv_st SERV_ST , cc.use_yn USE_YN  \n"
			+ " FROM service a , client c,  cont_n_view cc,   car_reg cr,  \n"
			+ " ( SELECT ff.car_mng_id, ff.serv_id, min(to_char(ee.seq_no || '^' || ee.item ))  item , max(seq_no)  cnt FROM serv_item ee, service ff WHERE ff.car_mng_id= ee.car_mng_id and  ff.serv_id = ee.serv_id group by ff.car_mng_id, ff.serv_id ) it, \n"
  			+ " (	SELECT  aa.car_mng_id, aa.serv_id, sum(dd.labor) labor, sum(dd.amt) amt	FROM serv_item dd , service aa	WHERE dd.car_mng_id= aa.car_mng_id and dd.serv_id = aa.serv_id group by aa.car_mng_id, aa.serv_id ) si ,  \n"
  			+ " (	SELECT  sum(dd.labor) a_labor	FROM serv_item dd , service aa	WHERE dd.car_mng_id= aa.car_mng_id and dd.serv_id = aa.serv_id AND  aa.off_id = ? AND aa.serv_dt  BETWEEN  ?  AND  ?  ) tt  \n"
			+ " WHERE  a.rep_amt > 0  and a.off_id = ? AND a.serv_dt  BETWEEN  replace(?,'-','') AND replace(?,'-','') and  a.rent_mng_id = cc.rent_mng_id and a.rent_l_cd = cc.rent_l_cd and cc.client_id = c.client_id  "
  			+ " and a.serv_id = si.serv_id and a.car_mng_id = si.car_mng_id "
  			+ " and a.serv_id = it.serv_id and a.car_mng_id = it.car_mng_id and a.car_mng_id= cr.car_mng_id ";
  		
  		
  			/*검색조건*/
			
		if(s_kd.equals("1"))		query += " and nvl(c.firm_nm, '') like '%"+t_wd+"%'\n";			
		else if(s_kd.equals("2"))	query += " and nvl(cr.car_no, '') like '%"+t_wd+"%'\n";
	
  			
  			
  			//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";
	

		/*정렬조건*/

		if(sort_gubun.equals("0"))		query += " order by jung_st, cc.use_yn desc, a.serv_dt "+sort+", c.firm_nm ";
		else if(sort_gubun.equals("1"))	query += " order by jung_st, cc.use_yn desc, c.firm_nm "+sort+", a.serv_dt";
		else if(sort_gubun.equals("5"))	query += " order by jung_st, cc.use_yn desc, a.serv_dt "+sort+", c.firm_nm ";
 			
 
		try {
			
			pstmt = conn.prepareStatement(query1);
			pstmt.setString(1, st_dt);
			rs = pstmt.executeQuery();

            if(rs.next()){
				st_dt1 = rs.getString(1);
            }
			pstmt.close();
                      
           	pstmt1 = conn.prepareStatement(query2);
           	pstmt1.setString(1, st_dt);
			rs = pstmt1.executeQuery();

            if(rs.next()){
				st_dt2 = rs.getString(1);
            }
			pstmt1.close();
           
			pstmt3 = conn.prepareStatement(query);			
			pstmt3.setString(1, off_id);
			pstmt3.setString(2, st_dt1);
			pstmt3.setString(3, st_dt2);
			pstmt3.setString(4, off_id);
			pstmt3.setString(5, st_dt);
			pstmt3.setString(6, end_dt);								
	    	rs = pstmt3.executeQuery();
    		
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
			pstmt3.close();

		} catch (SQLException e) {
			System.out.println("[CusSamt_Database:getServList]\n"+e);
		} finally {
			try{
				if(rs != null )		rs.close();
				if(pstmt3 != null)	pstmt3.close();
				if(pstmt1 != null)	pstmt1.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
            closeConnection();
			return vt;
		}
	}
	
	
	/**
	*	차량정비현황 - 업체 - 부경: card결재 제외
	*/
	
	public Vector getServNewList(String off_id, String gubun1, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc){
		getConnection();
		Vector vt = new Vector();
		Statement stmt = null;
		PreparedStatement pstmt = null;
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt3 = null;
        
		ResultSet rs = null;	
		String query = "";
		
		
		String query1 = "select  TO_CHAR(TO_DATE(?), 'YYYYMM') ||'01' from dual";
		String query2 = "select  TO_CHAR(TO_DATE(?) -1, 'YYYYMMDD')  from dual ";
	 	
	 	String st_dt1 = "";
		String st_dt2 = "";
	   
  	query = " SELECT  a.set_dt SET_DT,  substr(a.set_dt, 1, 6) SS_DT, nvl(a.jung_st, '0') SSS_ST, decode(a.serv_st, '1','순회점검', '2','일반수리', '3','보증수리', '4','운행자차', '13', '자차', '7', '재리스정비','12', '해지수리','') SERV_ST, cr.car_no CAR_NO , cr.car_nm CAR_NM, nvl2(a.serv_dt,substr(a.serv_dt,1,4)||'-'||substr(a.serv_dt,5,2)||'-'||substr(a.serv_dt,7,2),'') SERV_DT, "
		    + " nvl2(a.ipgodt, substr(a.ipgodt, 1, 8), '') IPGODT, nvl2(a.chulgodt, substr(a.chulgodt, 1, 8), '')  CHULGODT, "
			+ " decode(a.serv_st, '7', cc.bus_id, cc.mng_id) CHECKER,  nvl(c.firm_nm, c.client_nm) CLIENT_NM, it.item ITEM , it.cnt CNT, "
			+ " a.r_labor LABOR, a.r_j_amt AMT, a.tot_dist TOT_DIST, a.rep_amt REP_AMT, a.sup_amt SUP_AMT, a.add_amt ADD_AMT, a.dc DC,  trunc(nvl(a.dc, 0) / 1.1) DC_SUP_AMT,  a.tot_amt TOT_AMT, "
 			+ " nvl2(a.cust_plan_dt,substr(a.cust_plan_dt,1,4)||'-'||substr(a.cust_plan_dt,5,2)||'-'||substr(a.cust_plan_dt,7,2),'') CUST_PLAN_DT,  nvl(a.ext_amt, 0)  EXT_AMT,  "
 			+ " decode(a.jung_st, '0', '미정산', '' , '미정산', null, '미정산', a.jung_st||'회차') JUNG_ST,  a.scan_file,   nvl(a.cls_amt, 0)  CLS_AMT  , nvl(ff.cust_amt, a.cust_amt)  CUST_AMT ,  \n"
 		    + " c.client_id CLIENT_ID ,  a.car_mng_id CAR_MNG_ID, a.serv_id SERV_ID, a.accid_id ACCID_ID, a.rent_mng_id RENT_MNG_ID, a.rent_l_cd RENT_L_CD, a.off_id OFF_ID, a.serv_st SERV_ST , cc.use_yn USE_YN , nvl(a.acct_dt,'') ACCT_DT , nvl(a.reg_dt,'') REG_DT ,  "
		 	+ " nvl(h2.pic_cnt,0) pic_cnt, h2.attach_seq, h2.file_type, decode(a.serv_st, '2', '100',  '7', '100',  ac.our_fault_per ) our_fault_per  , nvl(a.req_dt, '미청구' )  req_dt , decode(a.accid_id , null, '1',  ac.settle_st) settle_st  , \n"
		 	+ "  decode(ac.accid_st, '1','피해','2','가해','3','쌍방','6','수해', '8', '단독', '') accid_st_nm , a.file_path , nvl(ins.con_f_nm , '아마존카' ) con_f_nm  \n"
		 	+ " FROM service a , client c,  cont cc, car_reg cr ,  accident ac, users u ,  \n"	
			+ " (SELECT ff.car_mng_id, ff.serv_id, min(to_char(ee.seq_no || '^' || ee.item ))  item , max(seq_no)  cnt FROM serv_item ee, service ff WHERE ff.car_mng_id= ee.car_mng_id and  ff.serv_id = ee.serv_id  and (ee.labor + ee.amt) <> 0  group by ff.car_mng_id, ff.serv_id ) it, \n"
			+ " (SELECT ff.car_mng_id, ff.accid_id, ff.off_id,  sum(ff.cust_amt) cust_amt FROM  service ff  where serv_dt is null   group by ff.car_mng_id, ff.accid_id, ff.off_id  ) ff, \n"
			+ " ( select SUBSTR(content_seq,1,6) car_mng_id, SUBSTR(content_seq,7) serv_id, count(0) pic_cnt, max(seq) attach_seq, MAX(file_type) file_type from ACAR_ATTACH_FILE where ISDELETED='N' and content_code='SERVICE' group by content_seq) h2 , \n"
			+ "  insur ins, ins_cls insc ,  \n"
			+ " (select a.car_mng_id from cont a, commi c  where  a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd and a.car_gu='2' and c.agnt_st = '6'   AND a.car_mng_id IS NOT NULL group by a.car_mng_id) acc \n"
	//		+ " ( select a.car_mng_id, a.con_f_nm  from insur a, ins_cls b, service c  where  a.car_mng_id = b.car_mng_id(+) and a.ins_st = b.ins_st(+)  and a.car_mng_id = c.car_mng_id and c.rep_amt >  0 and c.serv_dt between  to_char(to_date(a.ins_start_dt) + 1 , 'yyyymmdd')  and decode(b.car_mng_id, null, a.ins_exp_dt, b.exp_dt)   ) ins  \n"
	//		+ " (  select   car_mng_id, con_f_nm from insur where ins_sts='1' and ins_exp_dt > to_char(sysdate+1,'YYYYMMDD')   ) ins  \n"
   			+ " WHERE  a.rep_amt <> 0   and  a.rent_mng_id = cc.rent_mng_id and a.rent_l_cd = cc.rent_l_cd and cc.client_id = c.client_id  \n"
  			+ "  and  a.car_mng_id = ff.car_mng_id(+) and a.accid_id = ff.accid_id(+) and a.off_id = ff.off_id(+)  "  	
			+ "  and a.car_mng_id=ac.car_mng_id(+) and a.accid_id=ac.accid_id(+)"
  			+ "  and  a.serv_id = it.serv_id and a.car_mng_id = it.car_mng_id and nvl(a.card_chk, '0') = '0' and a.car_mng_id =cr.car_mng_id and a.car_mng_id = acc.car_mng_id(+)  \n" 	
  			+ "  and a.car_mng_id=h2.car_mng_id(+) and a.serv_id=h2.serv_id(+) \n"
  			+ "  and  a.car_mng_id = ins.car_mng_id and  ins.car_mng_id =  insc.car_mng_id(+) and  ins.car_mng_id = insc.car_mng_id(+) and ins.ins_st = insc.ins_st(+)   \n" 
  		   + "  and a.serv_dt between  decode(acc.car_mng_id, null, to_char(to_date(ins.ins_start_dt) + 1 , 'yyyymmdd'), decode(ins.ins_st, '0', cc.rent_dt, to_char(to_date(ins.ins_start_dt) + 1 , 'yyyymmdd')  )  )  and   decode(insc.car_mng_id, null, ins.ins_exp_dt, insc.exp_dt)  \n" 
       		
  		//	+ "  and (  ( a.serv_dt between  to_char(to_date(ins.ins_start_dt) + 1 , 'yyyymmdd')  and decode(insc.car_mng_id, null, ins.ins_exp_dt, insc.exp_dt) ) or ( acc.car_mng_id is not null  ) )    \n "   //중고차인 경우 보험가입기간일 예외적용?(20161215)
  		//	+ "  and  ( ( nvl(ins.con_f_nm , '아마존카' )  =  '아마존카' and a.serv_st  not in (  '1', '2', '3' ) )   or a.req_dt is not null )  \n"   //고객이 피보험인 경우 제외 - 20150831 ( 사고일때 )
  			
  			+ "  and  ( nvl(ins.con_f_nm , '아마존카' )  =  '아마존카'  or  a.serv_st  in (  '1', '2', '3' , '7' , '12' , '13' )    or a.req_dt is not null )  " 		 //고객이 피보험인 경우 제외 - 20150831 ( 사고일때 )
  			+ "  and  nvl(ac.accid_st, '')||nvl(ac.our_fault_per, '100')  <> '10'  \n"   //100% 피해제외 - 20150901
  			 + " and decode(a.serv_st, '7', cc.bus_id, cc.mng_id) = u.user_id  \n"
  			+ "  and a.car_mng_id=ins.car_mng_id(+)   \n";
  	
  		query += " and  a.serv_dt  BETWEEN  replace(?,'-','') AND replace(?,'-','') \n";		
  	  	
				
		if ( !off_id.equals("") ) {
		     	query += "and a.off_id  = '" + off_id + "'\n";
		}	
			
  			
  			/*검색조건*/
			
		if(s_kd.equals("1"))		query += " and nvl(c.firm_nm, '') like '%"+t_wd+"%'\n";			
		else if(s_kd.equals("2"))	query += " and nvl(cr.car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and nvl(a.jung_st, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("4"))	query += " and nvl(u.user_nm, '') like '%"+t_wd+"%'\n";
	  			 			
  			
  			//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";
	
		/*정렬조건*/

		if(sort_gubun.equals("0"))		query += " order by to_number(nvl(a.jung_st,'0')),  nvl(a.req_dt, '미청구' ) desc  ,   a.serv_dt "+sort+", c.firm_nm ";
		else if(sort_gubun.equals("1"))	query += " order by to_number(nvl(a.jung_st,'0')), nvl(a.req_dt, '미청구' ) desc ,  c.firm_nm "+sort+", a.serv_dt";
		else if(sort_gubun.equals("5"))	query += " order by to_number(nvl(a.jung_st,'0')), nvl(a.req_dt, '미청구' ) desc,   a.serv_dt "+sort+", c.firm_nm ";
		else if(sort_gubun.equals("7"))	query += " order by to_number(nvl(a.jung_st,'0')), nvl(a.req_dt, '미청구' ) desc,   a.serv_st "+sort+", c.firm_nm ";
 		 
	//	System.out.println("[CusSamt_Database:getServNewList]="+query);
 			
		try {
			
			pstmt = conn.prepareStatement(query1);
			pstmt.setString(1, st_dt);
			rs = pstmt.executeQuery();

            if(rs.next()){
				st_dt1 = rs.getString(1);
            }
			pstmt.close();
                      
           	pstmt1 = conn.prepareStatement(query2);
           	pstmt1.setString(1, st_dt);
			rs = pstmt1.executeQuery();

            if(rs.next()){
				st_dt2 = rs.getString(1);
            }
			pstmt1.close();
           					
			pstmt3 = conn.prepareStatement(query);		
			pstmt3.setString(1, st_dt);
			pstmt3.setString(2, end_dt);								
	    	rs = pstmt3.executeQuery();
    		
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
			pstmt3.close();
		} catch (SQLException e) {
			System.out.println("[CusSamt_Database:getServNewList]\n"+e);
			
		} finally {
			try{
				if(rs != null )		rs.close();
				if(pstmt3 != null)	pstmt3.close();
				if(pstmt1 != null)	pstmt1.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
            closeConnection();
			return vt;
		}
	}

		/**
	*	차량정비현황 - 업체 - 부경: card결재 제외  -보험만기가 +1일이기에 시작일을 +1로 하지 않으면 중복될수 있음.
	*   소송건인 경우 정비비결재 비율에 따름 (20190424 추가)
	*/
	
	public Vector getServNewList(String off_id, String gubun1, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc, String ref_dt1, String ref_dt2) {
		getConnection();
		Vector vt = new Vector();
	
       PreparedStatement pstmt3 = null;
       ResultSet rs = null;	
		String query = "";
							 	
	 		   
  	query = " SELECT  a.set_dt SET_DT,  substr(a.set_dt, 1, 6) SS_DT, nvl(a.jung_st, '0') SSS_ST, decode(a.serv_st, '1','순회점검', '2','일반수리', '3','보증수리', '4','운행자차', '13', '자차', '7', '재리스정비','12', '해지수리','') SERV_ST, cr.car_no CAR_NO , cr.car_nm CAR_NM, nvl2(a.serv_dt,substr(a.serv_dt,1,4)||'-'||substr(a.serv_dt,5,2)||'-'||substr(a.serv_dt,7,2),'') SERV_DT, "
		    + " nvl2(a.ipgodt, substr(a.ipgodt, 1, 8), '') IPGODT, nvl2(a.chulgodt, substr(a.chulgodt, 1, 8), '')  CHULGODT, "
			+ " decode(a.serv_st, '7', cc.bus_id, cc.mng_id) CHECKER,  nvl(c.firm_nm, c.client_nm) CLIENT_NM, it.item ITEM , it.cnt CNT, "
			+ " a.r_labor LABOR, a.r_j_amt AMT, a.tot_dist TOT_DIST, a.rep_amt REP_AMT, a.sup_amt SUP_AMT, a.add_amt ADD_AMT, a.dc DC,  trunc(nvl(a.dc, 0) / 1.1) DC_SUP_AMT,  a.tot_amt TOT_AMT, "
 			+ " nvl2(a.cust_plan_dt,substr(a.cust_plan_dt,1,4)||'-'||substr(a.cust_plan_dt,5,2)||'-'||substr(a.cust_plan_dt,7,2),'') CUST_PLAN_DT,  nvl(a.ext_amt, 0)  EXT_AMT,  "
 			+ " decode(a.jung_st, '0', '미정산', '' , '미정산', null, '미정산', a.jung_st||'회차') JUNG_ST,  a.scan_file,   nvl(a.cls_amt, 0)  CLS_AMT  , nvl(ff.cust_amt, a.cust_amt)  CUST_AMT ,  \n"
 		    + " c.client_id CLIENT_ID ,  a.car_mng_id CAR_MNG_ID, a.serv_id SERV_ID, a.accid_id ACCID_ID, a.rent_mng_id RENT_MNG_ID, a.rent_l_cd RENT_L_CD, a.off_id OFF_ID, a.serv_st SERV_ST , cc.use_yn USE_YN , nvl(a.acct_dt,'') ACCT_DT , nvl(a.reg_dt,'') REG_DT ,  "
		 	+ " nvl(h2.pic_cnt,0) pic_cnt, h2.attach_seq, h2.file_type, decode(a.serv_st, '2', '100',  '7', '100',  ac.our_fault_per ) our_fault_per  , nvl(a.req_dt, '미청구' )  req_dt , decode(a.accid_id , null, '1',  ac.settle_st) settle_st  , \n"
		 	+ "  decode(ac.accid_st, '1','피해','2','가해','3','쌍방','6','수해', '8', '단독', '') accid_st_nm , a.file_path , nvl(ins.con_f_nm , '아마존카' ) con_f_nm , nvl(ass.j_fault_per , 0) j_fault_per  \n"
		 	+ " FROM service a , client c,  cont cc, car_reg cr ,  accident ac, users u ,  accid_suit ass ,  \n"	
			+ " (SELECT ff.car_mng_id, ff.serv_id, min(to_char(ee.seq_no || '^' || ee.item ))  item , max(seq_no)  cnt FROM serv_item ee, service ff WHERE ff.car_mng_id= ee.car_mng_id and  ff.serv_id = ee.serv_id  and (ee.labor + ee.amt) <> 0  group by ff.car_mng_id, ff.serv_id ) it, \n"
			+ " (SELECT ff.car_mng_id, ff.accid_id, ff.off_id,  sum(ff.cust_amt) cust_amt FROM  service ff  where serv_dt is null   group by ff.car_mng_id, ff.accid_id, ff.off_id  ) ff, \n"
			+ " ( select SUBSTR(content_seq,1,6) car_mng_id, SUBSTR(content_seq,7) serv_id, count(0) pic_cnt, max(seq) attach_seq, MAX(file_type) file_type from ACAR_ATTACH_FILE where ISDELETED='N' and content_code='SERVICE' group by content_seq) h2 , \n"
			+ "  insur ins, ins_cls insc ,  \n"
			+ " (select a.car_mng_id from cont a, commi c where  a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd and a.car_gu='2' and c.agnt_st = '6'   AND a.car_mng_id IS NOT NULL group by a.car_mng_id) acc \n"
					
	//		+ " ( select a.car_mng_id, a.con_f_nm  from insur a, ins_cls b, service c  where  a.car_mng_id = b.car_mng_id(+) and a.ins_st = b.ins_st(+)  and a.car_mng_id = c.car_mng_id and c.rep_amt >  0 and c.serv_dt between  to_char(to_date(a.ins_start_dt) + 1 , 'yyyymmdd')  and decode(b.car_mng_id, null, a.ins_exp_dt, b.exp_dt)   ) ins  \n"
	//		+ " (  select   car_mng_id, con_f_nm from insur where ins_sts='1' and ins_exp_dt > to_char(sysdate+1,'YYYYMMDD')   ) ins  \n"
   			+ " WHERE  a.rep_amt <> 0  and abs(a.tot_amt) > 100  and  a.rent_mng_id = cc.rent_mng_id and a.rent_l_cd = cc.rent_l_cd and cc.client_id = c.client_id  \n"
  			+ "  and  a.car_mng_id = ff.car_mng_id(+) and a.accid_id = ff.accid_id(+) and a.off_id = ff.off_id(+)  "  	
			+ "  and a.car_mng_id=ac.car_mng_id(+) and a.accid_id=ac.accid_id(+)   and a.car_mng_id = acc.car_mng_id(+) \n"
			+ "  and  a.accid_id=ass.accid_id(+)  and a.car_mng_id = ass.car_mng_id(+) \n"
  			+ "  and  a.serv_id = it.serv_id and a.car_mng_id = it.car_mng_id and nvl(a.card_chk, '0') = '0' and a.car_mng_id =cr.car_mng_id and  nvl(a.jung_st, '0' )  not in ( 'C' ) " 		  		//카드 결재 제외  
  			+ "  and a.car_mng_id=h2.car_mng_id(+) and a.serv_id=h2.serv_id(+) \n"
  			+ "  and  a.car_mng_id = ins.car_mng_id and  ins.car_mng_id =  insc.car_mng_id(+) and  ins.car_mng_id = insc.car_mng_id(+) and ins.ins_st = insc.ins_st(+)   \n" 
  // 일반정비인 경우는 정비일부터 ???- 보험가입이 다 나옴.
  //		   + "  and a.serv_dt between  decode(a.serv_st , '2', a.serv_dt,  to_char(to_date(ins.ins_start_dt) + 1 , 'yyyymmdd') )  and  decode(insc.car_mng_id, null, ins.ins_exp_dt, insc.exp_dt)  \n" 
        + "  and a.serv_dt between   to_char(to_date(ins.ins_start_dt) + 1 , 'yyyymmdd')   and  decode(insc.car_mng_id, null, ins.ins_exp_dt, insc.exp_dt)  \n" 
       	
    //  	  + "  and a.serv_dt between  decode(acc.car_mng_id, null, to_char(to_date(ins.ins_start_dt) + 1 , 'yyyymmdd'), decode(ins.ins_st, null, a.serv_dt, '0', cc.rent_dt, to_char(to_date(ins.ins_start_dt) + 1 , 'yyyymmdd')  )  )  and   decode(insc.car_mng_id, null, ins.ins_exp_dt, insc.exp_dt)  \n" 
       	
  		//	+ "  and (  ( a.serv_dt between  to_char(to_date(ins.ins_start_dt) +1  , 'yyyymmdd')  and decode(insc.car_mng_id, null, ins.ins_exp_dt, insc.exp_dt) ) or ( acc.car_mng_id is not null ) )    \n "   //중고차인 경우 보험가입기간일 예외적용?(20161215)
  		//	+ "  and  ( ( nvl(ins.con_f_nm , '아마존카' )  =  '아마존카' and a.serv_st  not in (  '1', '2', '3' ) )   or a.req_dt is not null )  \n"   //고객이 피보험인 경우 제외 - 20150831 ( 사고일때 )
  			+ "  and  ( nvl(ins.con_f_nm , '아마존카' )  =  '아마존카'  or  a.serv_st  in (  '1', '2', '3' , '7' , '12' , '13' )    or a.req_dt is not null )  " 		 //고객이 피보험인 경우 제외 - 20150831 ( 사고일때 )
  			+ "  and ( nvl(ac.accid_st, '')||nvl(ac.our_fault_per, '100')  <> '10' or  nvl(ass.suit_type , 'x' )  in ( '1' , '2' ) )  \n"   //100% 피해제외 - 20150901   소송관련 100% 피해건은 포함(20190424)
  			 + " and decode(a.serv_st, '7', cc.bus_id, cc.mng_id) = u.user_id  \n"
  			+ "  and a.car_mng_id=ins.car_mng_id(+)   \n";  	
  		query += " and  a.serv_dt  BETWEEN  replace(?,'-','') AND replace(?,'-','') \n";	
				
		if ( !off_id.equals("") ) {
		     	query += "and a.off_id  = '" + off_id + "'\n";
		}	
		
  			
  			/*검색조건*/
			
		if(s_kd.equals("1"))	{ 	query += " and nvl(c.firm_nm, '') like '%"+t_wd+"%'\n";			}
		else if(s_kd.equals("2")) {	query += " and nvl(cr.car_no, '') like '%"+t_wd+"%'\n"; }
		else if(s_kd.equals("4")) {	query += " and nvl(u.user_nm, '') like '%"+t_wd+"%'\n"; }
		else if(s_kd.equals("3")) {
		      if ( t_wd.equals("미정산") )  				 { query += " and  a.req_dt is not null and decode(a.jung_st, '0', '미정산', '' , '미정산', null, '미정산', a.jung_st||'회차') = '미정산'"; 	} 		
		      else if   ( t_wd.equals("미청구") )  	 { query += " and  nvl(a.jung_st, '0') = '0' and nvl(a.req_dt, '미청구' ) = '미청구' ";	} 		
			   else  { query += " and nvl(a.jung_st, '') like '%"+t_wd+"%'\n";		} 		
		}		
		
		
//		query += " and nvl(a.jung_st, '') like '%"+t_wd+"%'\n";		 			
  			
  			//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";
	
		/*정렬조건*/

		if(sort_gubun.equals("0"))		query += " order by to_number(nvl(a.jung_st,'0')),  nvl(a.req_dt, '미청구' ) desc  ,   a.serv_dt "+sort+", c.firm_nm ";
		else if(sort_gubun.equals("1"))	query += " order by to_number(nvl(a.jung_st,'0')), nvl(a.req_dt, '미청구' ) desc ,  c.firm_nm "+sort+", a.serv_dt";
		else if(sort_gubun.equals("5"))	query += " order by to_number(nvl(a.jung_st,'0')), nvl(a.req_dt, '미청구' ) desc,   a.serv_dt "+sort+", c.firm_nm ";
		else if(sort_gubun.equals("7"))	query += " order by to_number(nvl(a.jung_st,'0')), nvl(a.req_dt, '미청구' ) desc,   a.serv_st "+sort+", c.firm_nm ";
 		 
	//	System.out.println("[CusSamt_Database:getServNewList]="+query);
 			
		try {
					           					
			pstmt3 = conn.prepareStatement(query);		
			
			 if ( !ref_dt1.equals("") &&  !ref_dt2.equals("") ) {
  	  			pstmt3.setString(1, ref_dt1);
				pstmt3.setString(2, ref_dt2);					
		    } else { 	    	
		  		pstmt3.setString(1, st_dt);
				pstmt3.setString(2, end_dt);		
		    }	
  	  	  					
	    	rs = pstmt3.executeQuery();
    		
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
			pstmt3.close();
		} catch (SQLException e) {
			System.out.println("[CusSamt_Database:getServNewList]\n"+e);
			
		} finally {
			try{
				if(rs != null )		rs.close();
				if(pstmt3 != null)	pstmt3.close();		
			}catch(Exception ignore){}
            closeConnection();
			return vt;
		}
	}
	
	/**
	*	차량정비현황 - 업체 - 부경: card결재 제외
	*/
		
	public Vector getServNewList3(String off_id, String gubun1, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc){
		getConnection();
		Vector vt = new Vector();
		Statement stmt = null;
		PreparedStatement pstmt = null;
          
		ResultSet rs = null;
		String query = "";
		   
/*
		query = " SELECT /a.set_dt SET_DT, substr(a.set_dt, 1, 6) SS_DT, nvl(a.jung_st, '0') SSS_ST, decode(a.serv_st, '1','순회점검', '2','일반수리', '3','보증수리', '4','운행자차', '5', '사고자차','7','재리스정비','12', '해지수리', '') SERV_ST, cr.car_no CAR_NO , cr.car_nm CAR_NM, nvl2(a.serv_dt,substr(a.serv_dt,1,4)||'-'||substr(a.serv_dt,5,2)||'-'||substr(a.serv_dt,7,2),'') SERV_DT,  \n"
		    + " nvl2(a.ipgodt, substr(a.ipgodt, 1, 8), '') IPGODT, nvl2(a.chulgodt, substr(a.chulgodt, 1, 8), '')  CHULGODT,  \n"
			+ " decode(cc.bus_id2, '000003', '000006', cc.bus_id2) CHECKER,  nvl(c.firm_nm, c.client_nm) CLIENT_NM, it.item ITEM , it.cnt CNT,  \n"
			+ " a.r_labor LABOR, a.r_j_amt AMT, a.tot_dist TOT_DIST, a.rep_amt REP_AMT, a.sup_amt SUP_AMT, a.add_amt ADD_AMT, a.dc DC, trunc(nvl(a.dc, 0) / 1.1) DC_SUP_AMT, a.tot_amt TOT_AMT,  \n"
 			+ " nvl2(a.cust_plan_dt,substr(a.cust_plan_dt,1,4)||'-'||substr(a.cust_plan_dt,5,2)||'-'||substr(a.cust_plan_dt,7,2),'') CUST_PLAN_DT, nvl(a.cust_amt, 0)  CUST_AMT,  nvl(a.ext_amt, 0)  EXT_AMT,  "
 			+ " decode(a.jung_st, '0', '미정산', '' , '미정산', null, '미정산', a.jung_st||'회차') JUNG_ST, \n"
 		    	+ " c.client_id CLIENT_ID ,  a.car_mng_id CAR_MNG_ID, a.serv_id SERV_ID, a.accid_id ACCID_ID, a.rent_mng_id RENT_MNG_ID, a.rent_l_cd RENT_L_CD, a.off_id OFF_ID, a.serv_st SERV_ST , cc.use_yn USE_YN , "
 		    	+ " h.pic_cnt , decode(a.serv_st, '2', '100',  '7', '100',  ac.our_fault_per ) our_fault_per, a.scan_file,  nvl(a.cls_amt, 0)  CLS_AMT   \n"
			+ " FROM service a , client c,  cont_n_view cc,  car_reg cr,  accident ac, \n"
			+ " (select car_mng_id, accid_id, count(*) pic_cnt from pic_accid group by car_mng_id, accid_id) h, \n"
			+ " ( SELECT ff.car_mng_id, ff.serv_id, min(to_char(ee.seq_no || '^' || ee.item ))  item , max(seq_no)  cnt FROM serv_item ee, service ff WHERE ff.car_mng_id= ee.car_mng_id and  ff.serv_id = ee.serv_id and (ee.labor + ee.amt) > 0  group by ff.car_mng_id, ff.serv_id ) it  \n"
  			+ " WHERE  a.rep_amt > 0  and a.off_id = ? and  a.rent_mng_id = cc.rent_mng_id and a.rent_l_cd = cc.rent_l_cd and cc.client_id = c.client_id   \n"
			+ "  and a.car_mng_id=h.car_mng_id(+) and a.accid_id=h.accid_id(+)"
			+ "  and a.car_mng_id=ac.car_mng_id(+) and a.accid_id=ac.accid_id(+)"
  			+ "  and a.serv_id = it.serv_id and a.car_mng_id = it.car_mng_id and nvl(a.card_chk , '0') = '0'  and a.car_mng_id = cr.car_mng_id \n";
  		
  */		
  		query = " SELECT  a.set_dt SET_DT, substr(a.set_dt, 1, 6) SS_DT, nvl(a.jung_st, '0') SSS_ST, decode(a.serv_st, '1','순회점검', '2','일반수리', '3','보증수리', '4','운행자차', '13', '자차','7','재리스정비','12', '해지수리', '') SERV_ST, cr.car_no CAR_NO , cr.car_nm CAR_NM, nvl2(a.serv_dt,substr(a.serv_dt,1,4)||'-'||substr(a.serv_dt,5,2)||'-'||substr(a.serv_dt,7,2),'') SERV_DT,  \n"
		    + " nvl2(a.ipgodt, substr(a.ipgodt, 1, 8), '') IPGODT, nvl2(a.chulgodt, substr(a.chulgodt, 1, 8), '')  CHULGODT,  \n"
			+ " decode(a.serv_st, '7', cc.bus_id, cc.mng_id) CHECKER,  nvl(c.firm_nm, c.client_nm) CLIENT_NM, it.item ITEM , it.cnt CNT,  \n"
			+ " a.r_labor LABOR, a.r_j_amt AMT, a.tot_dist TOT_DIST, a.rep_amt REP_AMT, a.sup_amt SUP_AMT, a.add_amt ADD_AMT, a.dc DC, trunc(nvl(a.dc, 0) / 1.1) DC_SUP_AMT, a.tot_amt TOT_AMT,  \n"
 			+ " nvl2(a.cust_plan_dt,substr(a.cust_plan_dt,1,4)||'-'||substr(a.cust_plan_dt,5,2)||'-'||substr(a.cust_plan_dt,7,2),'') CUST_PLAN_DT, nvl(a.ext_amt, 0)  EXT_AMT,    \n"
 			+ " decode(a.jung_st, '0', '미정산', '' , '미정산', null, '미정산', a.jung_st||'회차') JUNG_ST,  nvl(a.cls_amt, 0)  CLS_AMT  , nvl(ff.cust_amt, 0)  CUST_AMT ,   \n"
 		    	+ " c.client_id CLIENT_ID ,  a.car_mng_id CAR_MNG_ID, a.serv_id SERV_ID, a.accid_id ACCID_ID, a.rent_mng_id RENT_MNG_ID, a.rent_l_cd RENT_L_CD, a.off_id OFF_ID, a.serv_st SERV_ST , cc.use_yn USE_YN , "
 		    	+ " h2.pic_cnt as pic_cnt , decode(a.serv_st, '2', '100',  '7', '100',  ac.our_fault_per ) our_fault_per, a.scan_file , a.file_path \n"
			+ " FROM service a , client c,  cont_n_view cc,  car_reg cr,  accident ac, \n"
			+ " (select car_mng_id, accid_id, count(*) pic_cnt from pic_accid group by car_mng_id, accid_id) h, \n"
			+ " ( SELECT ff.car_mng_id, ff.serv_id, min(to_char(ee.seq_no || '^' || ee.item ))  item , max(seq_no)  cnt FROM serv_item ee, service ff WHERE ff.car_mng_id= ee.car_mng_id and  ff.serv_id = ee.serv_id and (ee.labor + ee.amt) <> 0  group by ff.car_mng_id, ff.serv_id ) it,  \n"
  			+ " ( SELECT ff.car_mng_id, ff.accid_id, nvl(ff.off_id, 'xx') off_id, sum(ff.cust_amt) cust_amt FROM  service ff WHERE ff.off_id= ?  group by ff.car_mng_id, ff.accid_id, nvl(ff.off_id, 'xx')  ) ff,  \n"
			+ " (select SUBSTR(content_seq,1,6) car_mng_id, SUBSTR(content_seq,7) accid_id, count(0) pic_cnt2 from ACAR_ATTACH_FILE where ISDELETED='N' and content_code='PIC_ACCID' group by content_seq) h2 \n"
  			+ " WHERE  a.rep_amt <> 0  and a.off_id = ? and  a.rent_mng_id = cc.rent_mng_id and a.rent_l_cd = cc.rent_l_cd and cc.client_id = c.client_id   \n"
			+ "  and a.car_mng_id=h.car_mng_id(+) and a.accid_id=h.accid_id(+)"
			+ "  and a.car_mng_id=ac.car_mng_id(+) and a.accid_id=ac.accid_id(+) \n"
			+ "  and  a.car_mng_id = ff.car_mng_id(+) and a.accid_id = ff.accid_id(+) and a.off_id = ff.off_id(+) "
  			+ "  and a.serv_id = it.serv_id and a.car_mng_id = it.car_mng_id and nvl(a.card_chk , '0') = '0'  and a.car_mng_id = cr.car_mng_id"
  			+ "  and a.car_mng_id=h2.car_mng_id(+) and a.accid_id=h2.accid_id(+)\n";
  		
  		
  			/*검색조건*/
			
		if(s_kd.equals("1"))		query += " and nvl(c.firm_nm, '') like '%"+t_wd+"%'\n";			
		else if(s_kd.equals("2"))	query += " and nvl(cr.car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and nvl(a.jung_st, '') like '%"+t_wd+"%'\n";
	
  		
  		if(gubun1.equals("1"))		query += " and  a.serv_dt  BETWEEN  replace(?,'-','') AND replace(?,'-','') \n";		
  		else if(gubun1.equals("2"))	query += " and  a.set_dt  BETWEEN  replace(?,'-','') AND replace(?,'-','') \n";		
    
  			//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";
	

		/*정렬조건*/

		if(sort_gubun.equals("0"))		query += " order by to_number(nvl(a.jung_st,'0')), cc.use_yn desc, a.serv_dt "+sort+", c.firm_nm ";
		else if(sort_gubun.equals("1"))	query += " order by to_number(nvl(a.jung_st,'0')), cc.use_yn desc, c.firm_nm "+sort+", a.serv_dt";
		else if(sort_gubun.equals("5"))	query += " order by to_number(nvl(a.jung_st,'0')), cc.use_yn desc, a.serv_dt "+sort+", c.firm_nm ";
 		 
// 		System.out.println("[CusSamt_Database:getServNewList3]="+query);
 			
		try {
			
							
			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, off_id);
			pstmt.setString(2, off_id);
			pstmt.setString(3, st_dt);
			pstmt.setString(4, end_dt);					
			
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
			System.out.println("[CusSamt_Database:getServNewList3]\n"+e);
			
		} finally {
			try{
				if(rs != null )		rs.close();			
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
            closeConnection();
			return vt;
		}
	}


  //주요거래처 정비비 정산현황
	public Vector getServNewJList(String off_id, String gubun1, String st_yy, String st_mm, String s_kd, String t_wd, String sort_gubun, String asc){
		getConnection();
		Vector vt = new Vector();
		Statement stmt = null;
		PreparedStatement pstmt = null;
      
		ResultSet rs = null;
		String query = "";
		int s_seq = 0;
	  
	   if ( s_kd.equals("3") ) {
			if (!t_wd.equals("")) {
		      	  	s_seq = Integer.parseInt(t_wd);
		          }   
		}
		
		query = " SELECT  sign( to_number(to_char(sysdate, 'yyyymm'))  - to_number(substr(a.serv_dt,1,6)) )   t_chk, a.set_dt SET_DT,  substr(a.set_dt, 1, 6) SS_DT, nvl(a.jung_st, '0') SSS_ST, decode(a.serv_st, '1','순회점검', '2','일반수리', '3','보증수리', '4','운행자차','7','재리스정비','12', '해지수리',    '13', '자차',  '') SERV_ST, tt.a_labor A_LABOR, cr.car_no CAR_NO , cr.car_nm CAR_NM, nvl2(a.serv_dt,substr(a.serv_dt,1,4)||'-'||substr(a.serv_dt,5,2)||'-'||substr(a.serv_dt,7,2),'') SERV_DT, "
		    + " nvl2(a.ipgodt, substr(a.ipgodt, 1, 8), '') IPGODT, nvl2(a.chulgodt, substr(a.chulgodt, 1, 8), '')  CHULGODT, "
			+ " decode(a.serv_st, '7', cc.bus_id, cc.mng_id) CHECKER,  nvl(c.firm_nm, c.client_nm) CLIENT_NM, it.item ITEM , it.cnt CNT, "
			+ " a.r_labor LABOR, a.r_j_amt AMT, a.tot_dist TOT_DIST, a.rep_amt REP_AMT, a.sup_amt SUP_AMT, a.add_amt ADD_AMT, a.dc DC,  trunc(nvl(a.dc, 0) / 1.1) DC_SUP_AMT,  a.tot_amt TOT_AMT, "
 			+ " nvl2(a.cust_plan_dt,substr(a.cust_plan_dt,1,4)||'-'||substr(a.cust_plan_dt,5,2)||'-'||substr(a.cust_plan_dt,7,2),'') CUST_PLAN_DT,  nvl(a.ext_amt, 0)  EXT_AMT,  "
 			+ " decode(a.jung_st, '0', '미정산', '' , '미정산', null, '미정산', a.jung_st||'회차') JUNG_ST,  a.scan_file,   nvl(a.cls_amt, 0)  CLS_AMT  , nvl(ff.cust_amt, a.cust_amt)  CUST_AMT ,  \n"
 		         + " c.client_id CLIENT_ID ,  a.car_mng_id CAR_MNG_ID, a.serv_id SERV_ID, a.accid_id ACCID_ID, a.rent_mng_id RENT_MNG_ID, a.rent_l_cd RENT_L_CD, a.off_id OFF_ID, a.serv_st SERV_ST , cc.use_yn USE_YN , nvl(a.acct_dt,'') ACCT_DT , nvl(a.reg_dt,'') REG_DT , \n" 
 		         + " a.req_dt , a.file_path, nvl(h2.pic_cnt,0) pic_cnt, h2.attach_seq, h2.file_type , nvl(ass.j_fault_per, '0' ) j_fault_per ,  \n"
 		         + " a.pre_set_dt PRE_SET_DT,  substr(a.pre_set_dt, 1, 6) PSS_DT  , to_char(last_day(to_date(a.serv_dt) ) , 'yyyymmdd' ) cal_set_dt " 
			+ " FROM service a , client c,  cont_n_view cc, car_reg cr , accid_suit ass,  \n"
			+ " ( SELECT ff.car_mng_id, ff.serv_id, min(to_char(ee.seq_no || '^' || ee.item ))  item , max(seq_no)  cnt FROM serv_item ee, service ff WHERE ff.car_mng_id= ee.car_mng_id and  ff.serv_id = ee.serv_id  and (ee.labor + ee.amt) <> 0  group by ff.car_mng_id, ff.serv_id ) it, \n"
			+ " ( SELECT ff.car_mng_id, ff.accid_id, nvl(ff.off_id, 'xx') off_id , sum(ff.cust_amt) cust_amt FROM  service ff WHERE ff.off_id= ?  and serv_dt is null  group by ff.car_mng_id, ff.accid_id, nvl(ff.off_id, 'xx')  ) ff , \n"
  //		+ " ( SELECT  sum(dd.labor) a_labor	FROM serv_item dd , service aa	WHERE dd.car_mng_id= aa.car_mng_id and dd.serv_id = aa.serv_id AND  aa.off_id = ? AND aa.set_dt  like  '" + st_yy+st_mm+"%' ) tt "
  			+ " ( SELECT  nvl(sum(dd.j_g_amt), 0)  a_labor	FROM mj_jungsan dd 	WHERE dd.j_acct= ? and  dd.j_yy = ? and dd.j_mm = ?  and to_number(dd.j_seq) <  ?  ) tt, "
			+ " ( select SUBSTR(content_seq,1,6) car_mng_id, SUBSTR(content_seq,7) serv_id, count(0) pic_cnt, max(seq) attach_seq, MAX(file_type) file_type from ACAR_ATTACH_FILE where ISDELETED='N' and content_code='SERVICE' group by content_seq) h2 \n"
  			+ " WHERE  a.rep_amt <> 0  and a.off_id = ?  and  a.rent_mng_id = cc.rent_mng_id and a.rent_l_cd = cc.rent_l_cd and cc.client_id = c.client_id  \n"
  			+ "  and  a.car_mng_id = ff.car_mng_id(+) and a.accid_id = ff.accid_id(+) and a.off_id = ff.off_id(+) \n"
  			+ "  and  a.car_mng_id = ass.car_mng_id(+) and a.accid_id = ass.accid_id(+) "
  			+ "  and a.jung_st is not null and a.serv_id = it.serv_id and a.car_mng_id = it.car_mng_id and nvl(a.card_chk, '0') = '0' and a.car_mng_id =cr.car_mng_id \n"
  			+ "  and a.car_mng_id=h2.car_mng_id(+) and a.serv_id=h2.serv_id(+)\n";
 		
		
		if(gubun1.equals("1"))		query +="and a.set_dt like '" + st_yy+st_mm + "%'\n";		//정산일	
		else if(gubun1.equals("2"))	query +="and a.serv_dt like '" + st_yy+st_mm + "%' \n";	    //정비일
		else if(gubun1.equals("3"))	query +="and a.pre_set_dt like '" + st_yy+st_mm + "%' \n";	//사전정산일
		
		/*검색조건*/
			
		if(s_kd.equals("1"))		query += " and nvl(c.firm_nm, '') like '%"+t_wd+"%'\n";			
		else if(s_kd.equals("2"))	query += " and nvl(cr.car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and nvl(a.jung_st, '') like '%"+t_wd+"%'\n";
	  		
	  	  			
  		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";
	

		/*정렬조건*/

		if(sort_gubun.equals("0"))		query += " order by to_number(nvl(a.jung_st,'0')),  a.serv_dt "+sort+", a.serv_st,  c.firm_nm ";
		else if(sort_gubun.equals("1"))	query += " order by to_number(nvl(a.jung_st,'0')),  c.firm_nm "+sort+", a.serv_dt";
		else if(sort_gubun.equals("5"))	query += " order by to_number(nvl(a.jung_st,'0')), a.serv_dt "+sort+", a.serv_st,  c.firm_nm ";
 		else if(sort_gubun.equals("6"))	query += " order by to_number(nvl(a.jung_st,'0')), a.set_dt "+sort+",  a.serv_st, c.firm_nm ";	
 		else if(sort_gubun.equals("7"))	query += " order by to_number(nvl(a.jung_st,'0')), 1 desc , a.serv_st "+sort+", a.serv_dt, c.firm_nm ";	
		
	//	System.out.println("query="+query);
 
		try {
	
				
			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, off_id);
			pstmt.setString(2, off_id);
			pstmt.setString(3, st_yy);
			pstmt.setString(4, st_mm);
			pstmt.setInt(5, s_seq);						
			pstmt.setString(6, off_id);
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
			System.out.println("[CusSamt_Database:getServNewJList]\n"+e);
		} finally {
			try{
				if(rs != null )		rs.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
            closeConnection();
			return vt;
		}
	}

	 //주요거래처 정비비 정산현황 - 계산서발행일로 처리 
		public Vector getServNewJList(String off_id, String gubun1, String st_yy, String st_mm, String st_day, String s_kd, String t_wd, String sort_gubun, String asc){
			getConnection();
			Vector vt = new Vector();
			Statement stmt = null;
			PreparedStatement pstmt = null;
	      
			ResultSet rs = null;
			String query = "";
			int s_seq = 0;
		  
		   if ( s_kd.equals("3") ) {
				if (!t_wd.equals("")) {
			      	  	s_seq = Integer.parseInt(t_wd);
			          }   
			}
			
		//	query = " SELECT  sign( to_number(to_char(sysdate, 'yyyymm'))  - to_number(substr(a.serv_dt,1,6)) )   t_chk, a.set_dt SET_DT,  substr(a.set_dt, 1, 6) SS_DT, nvl(a.jung_st, '0') SSS_ST, decode(a.serv_st, '1','순회점검', '2','일반수리', '3','보증수리', '4','운행자차','7','재리스정비','12', '해지수리',    '13', '자차',  '') SERV_ST, tt.a_labor A_LABOR, cr.car_no CAR_NO , cr.car_nm CAR_NM, nvl2(a.serv_dt,substr(a.serv_dt,1,4)||'-'||substr(a.serv_dt,5,2)||'-'||substr(a.serv_dt,7,2),'') SERV_DT, "
			query = " SELECT   to_number(to_char(sysdate, 'yyyymm'))  - to_number(substr(a.serv_dt,1,6))    t_chk, a.set_dt SET_DT,  substr(a.set_dt, 1, 6) SS_DT, nvl(a.jung_st, '0') SSS_ST, decode(a.serv_st, '1','순회점검', '2','일반수리', '3','보증수리', '4','운행자차','7','재리스정비','12', '해지수리',    '13', '자차',  '') SERV_ST, cr.car_no CAR_NO , cr.car_nm CAR_NM, nvl2(a.serv_dt,substr(a.serv_dt,1,4)||'-'||substr(a.serv_dt,5,2)||'-'||substr(a.serv_dt,7,2),'') SERV_DT, "
					+ " nvl2(a.ipgodt, substr(a.ipgodt, 1, 8), '') IPGODT, nvl2(a.chulgodt, substr(a.chulgodt, 1, 8), '')  CHULGODT, "
				+ " decode(a.serv_st, '7', cc.bus_id, cc.mng_id) CHECKER,  nvl(c.firm_nm, c.client_nm) CLIENT_NM, it.item ITEM , it.cnt CNT, "
				+ " a.r_labor LABOR, a.r_j_amt AMT, a.tot_dist TOT_DIST, a.rep_amt REP_AMT, a.sup_amt SUP_AMT, a.add_amt ADD_AMT, a.dc DC,  trunc(nvl(a.dc, 0) / 1.1) DC_SUP_AMT,  a.tot_amt TOT_AMT, "
	 			+ " nvl2(a.cust_plan_dt,substr(a.cust_plan_dt,1,4)||'-'||substr(a.cust_plan_dt,5,2)||'-'||substr(a.cust_plan_dt,7,2),'') CUST_PLAN_DT,  nvl(a.ext_amt, 0)  EXT_AMT,  "
	 			+ " decode(a.jung_st, '0', '미정산', '' , '미정산', null, '미정산', a.jung_st||'회차') JUNG_ST,  a.scan_file,   nvl(a.cls_amt, 0)  CLS_AMT  , nvl(ff.cust_amt, a.cust_amt)  CUST_AMT ,  \n"
	 		         + " c.client_id CLIENT_ID ,  a.car_mng_id CAR_MNG_ID, a.serv_id SERV_ID, a.accid_id ACCID_ID, a.rent_mng_id RENT_MNG_ID, a.rent_l_cd RENT_L_CD, a.off_id OFF_ID, a.serv_st SERV_ST , cc.use_yn USE_YN , nvl(a.acct_dt,'') ACCT_DT , nvl(a.reg_dt,'') REG_DT , \n" 
	 		         + " a.req_dt , a.file_path, nvl(h2.pic_cnt,0) pic_cnt, h2.attach_seq, h2.file_type , nvl(ass.j_fault_per, '0' ) j_fault_per ,  \n"
	 		         + " a.pre_set_dt PRE_SET_DT,  substr(a.pre_set_dt, 1, 6) PSS_DT  , to_char(last_day(to_date(a.serv_dt) ) , 'yyyymmdd' ) cal_set_dt " 
				+ " FROM service a , client c,  cont_n_view cc, car_reg cr , accid_suit ass,  \n"
				+ " ( SELECT ff.car_mng_id, ff.serv_id, min(to_char(ee.seq_no || '^' || ee.item ))  item , max(seq_no)  cnt FROM serv_item ee, service ff WHERE ff.car_mng_id= ee.car_mng_id and  ff.serv_id = ee.serv_id  and (ee.labor + ee.amt) <> 0  group by ff.car_mng_id, ff.serv_id ) it, \n"
				+ " ( SELECT ff.car_mng_id, ff.accid_id, nvl(ff.off_id, 'xx') off_id , sum(ff.cust_amt) cust_amt FROM  service ff WHERE ff.off_id= ?  and serv_dt is null  group by ff.car_mng_id, ff.accid_id, nvl(ff.off_id, 'xx')  ) ff , \n"
	  //		+ " ( SELECT  sum(dd.labor) a_labor	FROM serv_item dd , service aa	WHERE dd.car_mng_id= aa.car_mng_id and dd.serv_id = aa.serv_id AND  aa.off_id = ? AND aa.set_dt  like  '" + st_yy+st_mm+"%' ) tt "
	  	//		+ " ( SELECT  nvl(sum(dd.j_g_amt), 0)  a_labor	FROM mj_jungsan dd 	WHERE dd.j_acct= ? and  dd.j_yy = ? and dd.j_mm = ?  and to_number(dd.j_seq) <  ?  ) tt, "
				+ " ( select SUBSTR(content_seq,1,6) car_mng_id, SUBSTR(content_seq,7) serv_id, count(0) pic_cnt, max(seq) attach_seq, MAX(file_type) file_type from ACAR_ATTACH_FILE where ISDELETED='N' and content_code='SERVICE' group by content_seq) h2 \n"
	  			+ " WHERE  a.rep_amt <> 0  and a.off_id = ?  and  a.rent_mng_id = cc.rent_mng_id and a.rent_l_cd = cc.rent_l_cd and cc.client_id = c.client_id  \n"
	  			+ "  and  a.car_mng_id = ff.car_mng_id(+) and a.accid_id = ff.accid_id(+) and a.off_id = ff.off_id(+) \n"
	  			+ "  and  a.car_mng_id = ass.car_mng_id(+) and a.accid_id = ass.accid_id(+) "
	  			+ "  and a.pre_set_dt is not null and a.serv_id = it.serv_id and a.car_mng_id = it.car_mng_id and nvl(a.card_chk, '0') = '0' and a.car_mng_id =cr.car_mng_id \n"
	  			+ "  and a.car_mng_id=h2.car_mng_id(+) and a.serv_id=h2.serv_id(+)\n";
	 		
			
			if(gubun1.equals("1"))		query +="and a.set_dt like '" + st_yy+st_mm + "%'\n";		//정산일			
			else if(gubun1.equals("3"))	query +="and a.pre_set_dt like '" + st_yy+st_mm+st_day + "%' \n";	//사전정산일
								  		
	  		/*검색조건*/				
			if(s_kd.equals("1"))		query += " and nvl(c.firm_nm, '') like '%"+t_wd+"%'\n";			
			else if(s_kd.equals("2"))	query += " and nvl(cr.car_no, '') like '%"+t_wd+"%'\n";
			else if(s_kd.equals("3"))	query += " and nvl(a.jung_st, '') like '%"+t_wd+"%'\n";
		  		
		  	  			
	  			//검색일경우 해약건에대한 정렬위해
			String sort = asc.equals("0")?" asc":" desc";
		

			/*정렬조건*/

			if(sort_gubun.equals("0"))		query += " order by to_number(nvl(a.jung_st,'0')),  a.serv_dt "+sort+", a.serv_st,  c.firm_nm ";
			else if(sort_gubun.equals("1"))	query += " order by to_number(nvl(a.jung_st,'0')),  c.firm_nm "+sort+", a.serv_dt";
			else if(sort_gubun.equals("5"))	query += " order by  a.serv_dt "+sort+", to_number(nvl(a.jung_st,'0')), a.serv_st,  c.firm_nm ";
	 		else if(sort_gubun.equals("6"))	query += " order by to_number(nvl(a.jung_st,'0')), a.set_dt "+sort+",  a.serv_st, c.firm_nm ";	
	 		else if(sort_gubun.equals("7"))	query += " order by to_number(nvl(a.jung_st,'0')), 1 asc , a.serv_st "+sort+", a.serv_dt, c.firm_nm ";	
	 	
			
			try {
		
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, off_id);
				pstmt.setString(2, off_id);										
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
				System.out.println("[CusSamt_Database:getServNewJList]\n"+e);
			} finally {
				try{
					if(rs != null )		rs.close();
					if(pstmt != null)	pstmt.close();
				}catch(Exception ignore){}
	            closeConnection();
				return vt;
			}
		}


	 //주요거래처 정비비 정산현황
	public Vector getServNewCList(String off_id, String gubun1, String st_yy, String st_mm, String s_kd, String t_wd, String sort_gubun, String asc){
		getConnection();
		Vector vt = new Vector();
		Statement stmt = null;
		PreparedStatement pstmt = null;
      
		ResultSet rs = null;
		String query = "";
		int s_seq = 0;
			
	//	if (!t_wd.equals("")) {
	  //    	  	s_seq = Integer.parseInt(t_wd);
	 //         }   

		query = " SELECT  to_number(to_char(sysdate, 'yyyymm'))  - to_number(substr(a.serv_dt,1,6))    t_chk, a.set_dt SET_DT,  substr(a.set_dt, 1, 6) SS_DT, nvl(a.jung_st, '0') SSS_ST, decode(a.serv_st, '1','순회점검', '2','일반수리', '3','보증수리', '4','운행자차','7','재리스정비','12', '해지수리',  '13', '자차' ,   '') SERV_ST, cr.car_no CAR_NO , cr.car_nm CAR_NM,  a.serv_dt SERV_DT, "
		         + " nvl2(a.ipgodt, substr(a.ipgodt, 1, 8), '') IPGODT, nvl2(a.chulgodt, substr(a.chulgodt, 1, 8), '')  CHULGODT, "
			+ " decode(a.serv_st, '7', cc.bus_id, cc.mng_id) CHECKER,  nvl(c.firm_nm, c.client_nm) CLIENT_NM, it.item ITEM , it.cnt CNT, "
			+ " a.r_labor LABOR, a.r_j_amt AMT, a.tot_dist TOT_DIST, a.rep_amt REP_AMT, a.sup_amt SUP_AMT, a.add_amt ADD_AMT, a.dc DC,  trunc(nvl(a.dc, 0) / 1.1) DC_SUP_AMT,  a.tot_amt TOT_AMT, "
 			+ " nvl2(a.cust_plan_dt,substr(a.cust_plan_dt,1,4)||'-'||substr(a.cust_plan_dt,5,2)||'-'||substr(a.cust_plan_dt,7,2),'') CUST_PLAN_DT,  nvl(a.ext_amt, 0)  EXT_AMT,  "
 			+ " decode(a.jung_st, '0', '미정산', '' , '미정산', null, '미정산', a.jung_st||'회차') JUNG_ST,  a.scan_file,   nvl(a.cls_amt, 0)  CLS_AMT  , nvl(ff.cust_amt, a.cust_amt)  CUST_AMT ,  so.off_nm ,   \n"
 		    + " c.client_id CLIENT_ID ,  a.car_mng_id CAR_MNG_ID, a.serv_id SERV_ID, a.accid_id ACCID_ID, a.rent_mng_id RENT_MNG_ID, a.rent_l_cd RENT_L_CD, a.off_id OFF_ID, a.serv_st SERV_ST , cc.use_yn USE_YN , nvl(a.acct_dt,'') ACCT_DT , nvl(a.reg_dt,'') REG_DT , a.req_dt, \n "
			+  "  decode(ac.accid_st, '1','피해','2','가해','3','쌍방','6','수해', '8', '단독', '') accid_st_nm ,  decode(a.serv_st, '2', '100',  '7', '100',  ac.our_fault_per ) our_fault_per , a.file_path, nvl(h2.pic_cnt,0) pic_cnt, h2.attach_seq, h2.file_type , nvl(ass.j_fault_per, '0') j_fault_per, \n"
			+ " a.car_mng_id, a.serv_id , a.pre_set_dt , substr(a.pre_set_dt, 1, 6) PSS_DT \n "
			+ " FROM service a , client c,  cont_n_view cc, car_reg cr , serv_off so, accident ac, accid_suit ass , \n"
			+ " ( SELECT ff.car_mng_id, ff.serv_id, min(to_char(ee.seq_no || '^' || ee.item ))  item , max(seq_no)  cnt FROM serv_item ee, service ff WHERE ff.car_mng_id= ee.car_mng_id and  ff.serv_id = ee.serv_id  and (ee.labor + ee.amt) <> 0  group by ff.car_mng_id, ff.serv_id ) it, \n"
			+ " ( SELECT ff.car_mng_id, ff.accid_id, ff.off_id, sum(ff.cust_amt) cust_amt FROM  service ff  where serv_dt is null  group by ff.car_mng_id, ff.accid_id, ff.off_id  ) ff, \n"
			+ " ( select SUBSTR(content_seq,1,6) car_mng_id, SUBSTR(content_seq,7) serv_id, count(0) pic_cnt, max(seq) attach_seq, MAX(file_type) file_type from ACAR_ATTACH_FILE where ISDELETED='N' and content_code='SERVICE' group by content_seq) h2 \n"
    			+ " WHERE  a.rep_amt  <> 0 and abs(a.tot_amt) > 100  and  a.rent_mng_id = cc.rent_mng_id and a.rent_l_cd = cc.rent_l_cd and cc.client_id = c.client_id  \n"
  			+ "  and  a.car_mng_id = ff.car_mng_id(+) and a.accid_id = ff.accid_id(+) and a.off_id = ff.off_id(+) and  a.off_id = so.off_id(+) "
  			+ "  and a.car_mng_id=ac.car_mng_id(+) and a.accid_id=ac.accid_id(+) \n"
  			+ "  and a.car_mng_id=ass.car_mng_id(+) and a.accid_id=ass.accid_id(+) \n"
  			+ " and a.serv_id = it.serv_id and a.car_mng_id = it.car_mng_id and nvl(a.card_chk, '0') = '0' and a.car_mng_id =cr.car_mng_id \n"
  			+ "  and a.car_mng_id=h2.car_mng_id(+) and a.serv_id=h2.serv_id(+)\n";
 		  		  		  	
		query += "and a.req_dt like '"+st_yy+st_mm+"%'\n";
		
		if ( !off_id.equals("") ) {
		     	query += "and a.off_id  = '" + off_id + "'\n";
		}	
		  		
  			/*검색조건*/
			
		if(s_kd.equals("1"))		query += " and nvl(c.firm_nm, '') like '%"+t_wd+"%'\n";			
		else if(s_kd.equals("2"))	query += " and nvl(cr.car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and nvl(a.jung_st, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("4"))	query += " and nvl(a.serv_dt, '') like '%"+t_wd+"%'\n";
	  		
	  			
  			
  			//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";
	

		/*정렬조건           6:구분:사*/

		if(sort_gubun.equals("0"))		query += " order by to_number(nvl(a.jung_st,'0')),  a.off_id,  a.serv_dt "+sort+", c.firm_nm ";
		else if(sort_gubun.equals("1"))	query += " order by to_number(nvl(a.jung_st,'0')),  a.off_id,  c.firm_nm "+sort+", a.serv_dt";
		else if(sort_gubun.equals("5"))	query += " order by to_number(nvl(a.jung_st,'0')),  a.off_id,  a.serv_dt "+sort+", c.firm_nm ";
 		else if(sort_gubun.equals("6"))	query += " order by to_number(nvl(a.jung_st,'0')),  a.off_id, 1 asc ,  a.serv_st "+sort+", c.firm_nm ";
 
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
			System.out.println("[CusSamt_Database:getServNewJList]\n"+e);
		} finally {
			try{
				if(rs != null )		rs.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
            closeConnection();
			return vt;
		}
	}



	/* 서비스 내역 조회 */
	
 	public ServiceBean getServiceId( String car_mng_id, String serv_id )
 	{
        getConnection();
	    PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        ServiceBean bean = new ServiceBean();
        
        query = " select"+
				" a.car_mng_id, a.serv_id, a.accid_id, a.rent_mng_id, a.rent_l_cd, a.off_id, b.off_nm, c.car_no, "+
				" nvl2(a.serv_dt,substr(a.serv_dt,1,4)||'-'||substr(a.serv_dt,5,2)||'-'||substr(a.serv_dt,7,2),'') SERV_DT,"+
				" a.serv_st, a.checker, a.rep_amt, a.sup_amt, a.add_amt, a.dc, a.tot_amt, "+
				" nvl2(a.set_dt,substr(a.set_dt,1,4)||'-'||substr(a.set_dt,5,2)||'-'||substr(a.set_dt,7,2),'') SET_DT ,  decode(a.jung_st, '0', '미정산', '' , '미정산', null, '미정산', a.jung_st||'회차') JUNG_ST, a.jung_st jung_st_r , "+
			    " a.pre_set_dt \n"+
				" from service a, serv_off b, car_reg c \n"+
				" where a.car_mng_id='"+car_mng_id+"' and a.serv_id='"+serv_id+"'\n"+
				" and a.off_id=b.off_id and a.car_mng_id = c.car_mng_id \n";

        try{

			pstmt = conn.prepareStatement(query);
    		rs = pstmt.executeQuery();
    	    		
            if (rs.next()){
	         
			        bean.setCar_mng_id(rs.getString("CAR_MNG_ID")); 					
					bean.setServ_id(rs.getString("SERV_ID")); 
					bean.setAccid_id(rs.getString("ACCID_ID")); 
					bean.setRent_mng_id(rs.getString("RENT_MNG_ID")); 
					bean.setRent_l_cd(rs.getString("RENT_L_CD")); 
					bean.setCar_no(rs.getString("CAR_NO")); 
					bean.setOff_id(rs.getString("OFF_ID"));
					bean.setOff_nm(rs.getString("OFF_NM")); 
					bean.setServ_dt(rs.getString("SERV_DT")); 
					bean.setServ_st(rs.getString("SERV_ST")); 
					bean.setChecker(rs.getString("CHECKER")); 
					bean.setRep_amt(rs.getInt("REP_AMT")); 
					bean.setSup_amt(rs.getInt("SUP_AMT")); 
					bean.setAdd_amt(rs.getInt("ADD_AMT")); 
					bean.setDc(rs.getInt("DC")); 
					bean.setTot_amt(rs.getInt("TOT_AMT")); 
					bean.setSet_dt(rs.getString("SET_DT")); 
					bean.setJung_st(rs.getString("JUNG_ST")); 
					bean.setJung_st_r(rs.getString("JUNG_ST_R")); 
					bean.setPre_set_dt(rs.getString("PRE_SET_DT")); 
										                
			}
            
            rs.close();
            pstmt.close();

        }catch(SQLException e){
			System.out.println("[CusSamt_Database:getServiceId]\n"+e);
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
	 *	정산회차 등록 - tnwjd
	 */
	public boolean updateServiceAutoDocu(ServiceBean sr_bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
		query = " update service set "+
				" SET_DT=replace(?, '-', ''),"+
				" JUNG_ST= ? , "+			
				" UPDATE_DT= to_char(sysdate,'YYYYMMDD'), UPDATE_ID=? "+
				" where car_mng_id=? and serv_id= ? ";
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, sr_bean.getSet_dt().trim());
			pstmt.setString(2, sr_bean.getJung_st().trim());
			pstmt.setString(3, sr_bean.getUpdate_id	());
			pstmt.setString(4, sr_bean.getCar_mng_id	());
			pstmt.setString(5, sr_bean.getServ_id	());
		
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[CusSamt_Database:updateServiceAutoDocu]\n"+e);
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
	 *	정산회차 등록 - 정산현황II데이타를 정산 취소시 
	 */
	public boolean updateServiceAutoDocuNew(ServiceBean sr_bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
		query = " update service set "+
				" SET_DT=replace(?, '-', ''),"+
				" JUNG_ST= ? , "+			
				" pre_set_dt =  null , "+
				" UPDATE_DT= to_char(sysdate,'YYYYMMDD'), UPDATE_ID=? "+
				" where car_mng_id=? and serv_id= ? and acct_dt is null ";
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, sr_bean.getSet_dt().trim());
			pstmt.setString(2, sr_bean.getJung_st().trim());
			pstmt.setString(3, sr_bean.getUpdate_id	());
			pstmt.setString(4, sr_bean.getCar_mng_id	());
			pstmt.setString(5, sr_bean.getServ_id	());
		
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[CusSamt_Database:updateServiceAutoDocuNew]\n"+e);
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
	 *	req_dt 
	 */
	public boolean updateServiceAutoDocu(String car_mng_id, String serv_id)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
		query = " update service set "+
				" REQ_DT= ''  "+	
				" where car_mng_id=? and serv_id= ? ";
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
			pstmt.setString(2, serv_id	);
		
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[CusSamt_Database:updateServiceAutoDocu]\n"+e);
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
    * 자동차 정비건 작업 및 부품 중복조회
    */
    public String getOutFaultPer(String car_mng_id, String accid_id){
        getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String count = "";
        String query = "";
        
		query = "SELECT to_char(nvl(our_fault_per, 0)) || '^' || accid_st"+
				"  FROM accident "+
				" WHERE car_mng_id = ? AND accid_id = ? ";

        try{
            pstmt = conn.prepareStatement(query);
    		pstmt.setString(1, car_mng_id);
			pstmt.setString(2, accid_id);
	    		rs = pstmt.executeQuery();

            if(rs.next()){                
				count = rs.getString(1);
            }

			rs.close();
			pstmt.close();

        }catch(SQLException e){
			 System.out.println("[CusSamt_Database:getOutFaultPer]"+e);
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
    * 자동차 정비건 작업 및 부품 중복조회
    */
    public String getServMJ_PTOT(String acct, String s_year, String s_mon, String t_wd){
        getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String count = "";
        String query = "";
        int  s_seq = 0;
                      
        if (!t_wd.equals("")) {
       	s_seq = Integer.parseInt(t_wd);
        }
               
		query = "SELECT nvl( to_char(sum(nvl(j_g_amt, 0))) || '^' || to_char(sum(nvl(j_b_amt, 0))) || '^' || to_char(sum(nvl(j_g_dc_amt, 0))) || '^' || to_char(sum(nvl(j_dc_amt, 0))) || '^' ||  to_char(sum(nvl(j_ext_amt, 0))) , '0^0^0^0^0') "+
				"  FROM mj_jungsan "+
				" WHERE j_acct = ? and j_yy = ? AND j_mm = ? and to_number(j_seq) < ? ";

        try{
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, acct);
    		pstmt.setString(2, s_year);
			pstmt.setString(3, s_mon);
			pstmt.setInt(4, s_seq);
		
			
	    	rs = pstmt.executeQuery();
			
            if(rs.next()){                
				count = rs.getString(1);
            }

			
			rs.close();
			pstmt.close();

        }catch(SQLException e){
			 System.out.println("[CusSamt_Database:getServMJ_PTOT]"+e);
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
	 *	주여거래처 정산 회차 마감
	 */
	public boolean updateMJ_Jungsan(String acct, String s_yy, String s_mm, String s_seq, int j_g_amt, int j_b_amt, int j_g_dc_amt, int j_ext_amt,  int j_dc_amt, String user_id)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt_i = null;
		PreparedStatement pstmt_u = null;
		ResultSet rs = null;
		String query = "";
		String query_i = "";
		String query_u = "";
		int count = 0;
		
		query = " select count(*) from mj_jungsan where j_acct= ? and j_yy = ? and j_mm = ? and j_seq = ? ";
		
		query_i = " insert into mj_jungsan( j_acct, j_yy, j_mm, j_seq, j_g_amt, j_b_amt , j_g_dc_amt, j_ext_amt, j_dc_amt, update_dt, update_id ) values ( ?, ?, ?, ?, ?, ?, ?, ?,  ?, to_char(sysdate,'YYYYMMDD'), ? ) ";
							
		query_u = " update mj_jungsan set "+
				" j_g_amt = ?, j_b_amt = ? , j_g_dc_amt = ?, "+
			    " UPDATE_DT= to_char(sysdate,'YYYYMMDD'), UPDATE_ID=? , j_ext_amt  =  ? , j_dc_amt = ?  "+
				" where  j_acct= ? and j_yy = ? and j_mm = ? and j_seq = ?  ";		
		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, acct);
			pstmt.setString(2, s_yy);
			pstmt.setString(3, s_mm);
			pstmt.setString(4, s_seq);
				
		    rs = pstmt.executeQuery();

            if(rs.next()){                
				count = rs.getInt(1);
            }
	
			rs.close();
			pstmt.close();
		
			if (count > 0 ) {
				pstmt_u = conn.prepareStatement(query_u);
				pstmt_u.setInt(1, j_g_amt);
				pstmt_u.setInt(2, j_b_amt);
				pstmt_u.setInt(3, j_g_dc_amt);
				pstmt_u.setString(4, user_id);
				pstmt_u.setInt(5, j_ext_amt);
				pstmt_u.setInt(6, j_dc_amt);
				pstmt_u.setString(7, acct);
				pstmt_u.setString(8, s_yy);
				pstmt_u.setString(9, s_mm);
				pstmt_u.setString(10, s_seq);
				pstmt_u.executeUpdate();
				pstmt_u.close();
			}else {
				pstmt_i = conn.prepareStatement(query_i);
				pstmt_i.setString(1, acct);
				pstmt_i.setString(2, s_yy);
				pstmt_i.setString(3, s_mm);
				pstmt_i.setString(4, s_seq);
				pstmt_i.setInt(5, j_g_amt);
				pstmt_i.setInt(6, j_b_amt);
				pstmt_i.setInt(7, j_g_dc_amt);
				pstmt_i.setInt(8, j_ext_amt);
				pstmt_i.setInt(9, j_dc_amt);
				pstmt_i.setString(10, user_id);
				pstmt_i.executeUpdate();
				pstmt_i.close();
			}	
				
			conn.commit();

			
	  	} catch (Exception e) {
			System.out.println("[CusSamt_Database:updateMJ_Jungsan]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(rs != null ) rs.close();
				if(pstmt != null)	pstmt.close();
				if(pstmt_i != null)	pstmt_i.close();
				if(pstmt_u != null)	pstmt_u.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	/**	
	 *	주여거래처 정산 회차 마감
	 */
	public boolean updateMJ_Jungsan(String acct, String s_yy, String s_mm, String s_seq, int j_g_amt, int j_b_amt, int j_g_dc_amt, int j_ext_amt,  int j_dc_amt, String user_id, String set_dt)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt_i = null;
		PreparedStatement pstmt_u = null;
		ResultSet rs = null;
		String query = "";
		String query_i = "";
		String query_u = "";
		int count = 0;
		
		query = " select count(*) from mj_jungsan where j_acct= ? and j_yy = ? and j_mm = ? and j_seq = ? ";
		
		query_i = " insert into mj_jungsan( j_acct, j_yy, j_mm, j_seq, j_g_amt, j_b_amt , j_g_dc_amt, j_ext_amt, j_dc_amt, update_dt, update_id ) values ( ?, ?, ?, ?, ?, ?, ?, ?,  ?, replace(?, '-', ''), ? ) ";
							
		query_u = " update mj_jungsan set "+
				" j_g_amt = ?, j_b_amt = ? , j_g_dc_amt = ?, "+
			    " UPDATE_DT= replace(?, '-', ''), UPDATE_ID=? , j_ext_amt  =  ? , j_dc_amt = ?  "+
				" where  j_acct= ? and j_yy = ? and j_mm = ? and j_seq = ?  ";		
		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, acct);
			pstmt.setString(2, s_yy);
			pstmt.setString(3, s_mm);
			pstmt.setString(4, s_seq);
				
		    rs = pstmt.executeQuery();

            if(rs.next()){                
				count = rs.getInt(1);
            }
	
			rs.close();
			pstmt.close();
		
			if (count > 0 ) {
				pstmt_u = conn.prepareStatement(query_u);
				pstmt_u.setInt(1, j_g_amt);
				pstmt_u.setInt(2, j_b_amt);
				pstmt_u.setInt(3, j_g_dc_amt);
				pstmt_u.setString(4, set_dt);
				pstmt_u.setString(5, user_id);
				pstmt_u.setInt(6, j_ext_amt);
				pstmt_u.setInt(7, j_dc_amt);
				pstmt_u.setString(8, acct);
				pstmt_u.setString(9, s_yy);
				pstmt_u.setString(10, s_mm);
				pstmt_u.setString(11, s_seq);
				pstmt_u.executeUpdate();
				pstmt_u.close();
			}else {
				pstmt_i = conn.prepareStatement(query_i);
				pstmt_i.setString(1, acct);
				pstmt_i.setString(2, s_yy);
				pstmt_i.setString(3, s_mm);
				pstmt_i.setString(4, s_seq);
				pstmt_i.setInt(5, j_g_amt);
				pstmt_i.setInt(6, j_b_amt);
				pstmt_i.setInt(7, j_g_dc_amt);
				pstmt_i.setInt(8, j_ext_amt);
				pstmt_i.setInt(9, j_dc_amt);
				pstmt_i.setString(10, set_dt);
				pstmt_i.setString(11, user_id);
				pstmt_i.executeUpdate();
				pstmt_i.close();
			}	
				
			conn.commit();

			
	  	} catch (Exception e) {
			System.out.println("[CusSamt_Database:updateMJ_Jungsan]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(rs != null ) rs.close();
				if(pstmt != null)	pstmt.close();
				if(pstmt_i != null)	pstmt_i.close();
				if(pstmt_u != null)	pstmt_u.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	
	//주요거래처 - 월1회 정산 업체 (스피드, 타이어 등) 
	public boolean updateMJ_Jungsan(String acct, String s_yy, String s_mm, String s_seq, int j_g_amt, int j_b_amt, int j_g_dc_amt, int j_ext_amt,  int j_dc_amt, int add_amt, int add_dc_amt, String user_id)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt_i = null;
		PreparedStatement pstmt_u = null;
		ResultSet rs = null;
		String query = "";
		String query_i = "";
		String query_u = "";
		int count = 0;
		
		query = " select count(*) from mj_jungsan where j_acct= ? and j_yy = ? and j_mm = ? and j_seq = ? ";
		
		query_i = " insert into mj_jungsan( j_acct, j_yy, j_mm, j_seq, j_g_amt, j_b_amt , j_g_dc_amt, j_ext_amt, j_dc_amt, update_dt, update_id, j_add_amt, j_add_dc_amt  ) values ( ?, ?, ?, ?, ?, ?, ?, ?,  ?, to_char(sysdate,'YYYYMMDD'), ? , ? ,? ) ";
							
		query_u = " update mj_jungsan set "+
				" j_g_amt = ?, j_b_amt = ? , j_g_dc_amt = ?, "+
			    " UPDATE_DT= to_char(sysdate,'YYYYMMDD'), UPDATE_ID=? , j_ext_amt  =  ? , j_dc_amt = ? , j_add_amt = ?, j_add_dc_amt = ?   "+
				" where  j_acct= ? and j_yy = ? and j_mm = ? and j_seq = ?  ";		
		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, acct);
			pstmt.setString(2, s_yy);
			pstmt.setString(3, s_mm);
			pstmt.setString(4, s_seq);
				
		    rs = pstmt.executeQuery();

            if(rs.next()){                
				count = rs.getInt(1);
            }
	
			rs.close();
			pstmt.close();
		
			if (count > 0 ) {
				pstmt_u = conn.prepareStatement(query_u);
				pstmt_u.setInt(1, j_g_amt);
				pstmt_u.setInt(2, j_b_amt);
				pstmt_u.setInt(3, j_g_dc_amt);
				pstmt_u.setString(4, user_id);
				pstmt_u.setInt(5, j_ext_amt);
				pstmt_u.setInt(6, j_dc_amt);
				pstmt_u.setInt(7, add_amt);
				pstmt_u.setInt(8, add_dc_amt);
				pstmt_u.setString(9, acct);
				pstmt_u.setString(10, s_yy);
				pstmt_u.setString(11, s_mm);
				pstmt_u.setString(12, s_seq);
				pstmt_u.executeUpdate();
				pstmt_u.close();
			}else {
				pstmt_i = conn.prepareStatement(query_i);
				pstmt_i.setString(1, acct);
				pstmt_i.setString(2, s_yy);
				pstmt_i.setString(3, s_mm);
				pstmt_i.setString(4, s_seq);
				pstmt_i.setInt(5, j_g_amt);
				pstmt_i.setInt(6, j_b_amt);
				pstmt_i.setInt(7, j_g_dc_amt);
				pstmt_i.setInt(8, j_ext_amt);
				pstmt_i.setInt(9, j_dc_amt);
				pstmt_i.setString(10, user_id);
				pstmt_i.setInt(11, add_amt);
				pstmt_i.setInt(12, add_dc_amt);
				pstmt_i.executeUpdate();
				pstmt_i.close();
			}	
				
			conn.commit();

			
	  	} catch (Exception e) {
			System.out.println("[CusSamt_Database:updateMJ_Jungsan]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(rs != null ) rs.close();
				if(pstmt != null)	pstmt.close();
				if(pstmt_i != null)	pstmt_i.close();
				if(pstmt_u != null)	pstmt_u.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	/**	
	 *	정산회차 전표발행일 등록
	 */

	public boolean updateServiceAutoDocuDt(String s_yy, String s_mm, String jung_st, String off_id, String acct_dt, String user_id)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
		query = " update service set acct_dt=replace(?, '-', ''),"+
				" UPDATE_DT= to_char(sysdate,'YYYYMMDD'), UPDATE_ID=? "+
				" where off_id = ? and set_dt like '" + s_yy+s_mm + "%'" +
				" and   nvl(jung_st, '') = '"+jung_st+"'\n";
 
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, acct_dt);
			pstmt.setString(2, user_id);
			pstmt.setString(3, off_id);
				
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[CusSamt_Database:updateServiceAutoDocuDt]\n"+e);
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
	
	public boolean updateServiceAutoDocuDt(String s_yy, String s_mm, String s_dd, String jung_st, String off_id, String acct_dt, String user_id)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
		query = " update service set acct_dt=replace(?, '-', ''),"+
				" UPDATE_DT= to_char(sysdate,'YYYYMMDD'), UPDATE_ID=? "+
				" where off_id = ? and pre_set_dt like '" + s_yy+s_mm + s_dd+ "%'" +
				" and jung_st is not null \n";
 
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, acct_dt);
			pstmt.setString(2, user_id);
			pstmt.setString(3, off_id);
				
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[CusSamt_Database:updateServiceAutoDocuDt]\n"+e);
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
	 *	정산 -  청구등록
	 */

	public boolean updateServiceSetReqDt(String s_yy, String s_mm, String jung_st, String off_id, String user_id)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
		query = " update service set req_dt=to_char(sysdate,'YYYYMMDD'),"+
				" UPDATE_DT= to_char(sysdate,'YYYYMMDD'), UPDATE_ID=? "+
				" where off_id = ? and set_dt like '" + s_yy+s_mm + "%'" +
				" and  jung_st = '"+jung_st+"'\n";
 
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
		
			pstmt.setString(1, user_id);
			pstmt.setString(2, off_id);
				
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[CusSamt_Database:updateServiceSetReqDt]\n"+e);
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
	 *	정산 -  청구등록
	 */

	public boolean updateServiceSetReqDt(String car_mng_id, String serv_id, String user_id)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
		
		query = " update service set req_dt=to_char(sysdate,'YYYYMMDD'),"+
				" UPDATE_DT= to_char(sysdate,'YYYYMMDD'), UPDATE_ID=? "+
				" where  car_mng_id  = '"+car_mng_id +"' and  serv_id = '" + serv_id +  "'" ;
 
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
		
			pstmt.setString(1, user_id);
						
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[CusSamt_Database:updateServiceSetReqDt]\n"+e);
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
    * 청구시 견적서 유무
    */
 
    public int getScanFileCnt(String s_yy, String s_mm, String jung_st, String off_id) 
    {
        getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
       int count = 0;
        String query = "";
        
	query = "SELECT count(*) "+
				"  FROM service \n"+
				" where off_id = ? and set_dt like '" + s_yy+s_mm + "%'" +
				" and  jung_st = '"+jung_st+"'   and scan_file is null ";

        try{
           	pstmt = conn.prepareStatement(query);
    		
			pstmt.setString(1, off_id);
	    	rs = pstmt.executeQuery();

		    if(rs.next()){                
				count = rs.getInt(1);
		    }

			rs.close();
			pstmt.close();

        }catch(SQLException e){
			 System.out.println("[CusSamt_Database:getScanFileCnt]"+e);
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
	 *	주요거래처 정산 회차 및 정산일 
	 */
	public boolean updateServiceSetDt(String car_mng_id, String serv_id, String set_dt, String jung_st, String user_id )
	{
	getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
		
		query = " update service set set_dt=replace( ?, '-', '')  , jung_st = ?, "+
				" UPDATE_DT= to_char(sysdate,'YYYYMMDD'), UPDATE_ID=? "+
				" where  car_mng_id  = '"+car_mng_id +"' and  serv_id = '" + serv_id +  "'" ;
 
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
		
			pstmt.setString(1, set_dt);
			pstmt.setString(2, jung_st);
			pstmt.setString(3, user_id);
						
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[CusSamt_Database:updateServiceSetDt]\n"+e);
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
		 *	주요거래처 정산 회차 및 정산일 
	 */
	public boolean updateServicePreSetDt(String car_mng_id, String serv_id, String pre_set_dt,  String user_id )
	{
	getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
		
		query = " update service set pre_set_dt=replace( ?, '-', '') , "+
				" UPDATE_DT= to_char(sysdate,'YYYYMMDD'), UPDATE_ID=? "+
				" where  car_mng_id  = '"+car_mng_id +"' and  serv_id = '" + serv_id +  "'" ; 
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
		
			pstmt.setString(1, pre_set_dt);			
			pstmt.setString(2, user_id);
						
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[CusSamt_Database:updateServicePreSetDt]\n"+e);
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
    * 주요거래처 정비비정산 정산회차 
    */
    public String getAcctJung_st(String off_id, String set_dt){
        getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String count = "";
        String query = "";
                    
        query = " SELECT to_char(nvl(max(nvl(jung_st, 0)+1)) FROM service     " +
   			" WHERE off_id = ? AND substr(set_dt, 1, 6)  =   substr(replace(?, '-' , '') , 1, 6)";  

        try{
            pstmt = conn.prepareStatement(query);
    			pstmt.setString(1, off_id);
			pstmt.setString(2, set_dt);
	    		rs = pstmt.executeQuery();

            if(rs.next()){                
				count = rs.getString(1);
            }

			rs.close();
			pstmt.close();

        }catch(SQLException e){
			 System.out.println("[CusSamt_Database:getAcctJung_st]"+e);
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
     * 주요거래처 정비비정산 정산회차 
     */
     public int getAcctJung_stNew(String off_id, String set_dt){
         getConnection();
         PreparedStatement pstmt = null;
         ResultSet rs = null;
         int count = 0;
         String query = "";
                     
         query = " SELECT to_number(nvl(max(to_number(jung_st)), 0)) +1  FROM service     " +
    			" WHERE off_id = ? AND substr(set_dt, 1, 6)  =   substr(replace(?, '-' , '') , 1, 6) and jung_st <> 'C' ";  

         try{
             pstmt = conn.prepareStatement(query);
     			pstmt.setString(1, off_id);
     			pstmt.setString(2, set_dt);
 	    		rs = pstmt.executeQuery();

             if(rs.next()){                
 				count = rs.getInt(1);
             }

 			rs.close();
 			pstmt.close();

         }catch(SQLException e){
 			 System.out.println("[CusSamt_Database:getAcctJung_stNew]"+e);
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
     
     public String getServOffVenCode(String off_id){
        getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String ven_code = "";
        String query = "";
                    
        query = " SELECT nvl(ven_code, 'XX')  FROM serv_off      WHERE off_id = ? ";  

        try{
            pstmt = conn.prepareStatement(query);
    			pstmt.setString(1, off_id);
			
	    		rs = pstmt.executeQuery();

            if(rs.next()){                
			ven_code = rs.getString(1);
            }

			rs.close();
			pstmt.close();

        }catch(SQLException e){
			 System.out.println("[CusSamt_Database:getServOffVenCode)]"+e);
			e.printStackTrace();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(Exception ignore){}

			closeConnection();
			return ven_code;
        }        
    }
	
     public String insertSetCusSamt(String write_date,  Vector vt) {
    	 getConnection();

    	  PreparedStatement pstmt = null;
               
          String query = "";             
          String row_id = "";
                  			
 		 query =" insert into cus_samt_table  ( "+
 				" SEQIDX, ACCT_DT, SET_DT, SERV_DT, CAR_MNG_ID,  RENT_L_CD, "+   //6
 				" SERV_ST, JUNG_ST, OUR_FAULT, V_AMT, V_LABOR, V_CUST_AMT, V_EXT_AMT , "+   //7 			
 				" ID_INSERT, CAR_NO , OFF_ID )\n"+   //1
 				" values( "+
 				" CUS_SAMT_TABLE_SEQ.nextval, replace(?,'-',''),  replace(?,'-',''),  replace(?,'-',''),  ?,  ?,  "+  
 				"  ?,  ?,  ?,  ?,  ?,  ?,  ?,  "+
 				" sysdate , ? , ?  "+
 				" ) ";	

 	   try{

 		  conn.setAutoCommit(false);
 		  pstmt = conn.prepareStatement(query);
 		
 		  for(int i = 0 ; i < vt.size() ; i++){

 				Hashtable ht = (Hashtable)vt.elementAt(i);

 				pstmt.setString (1, String.valueOf(ht.get("ACCT_DT")));									
 				pstmt.setString (2, String.valueOf(ht.get("SET_DT")));
 				pstmt.setString (3, String.valueOf(ht.get("SERV_DT")));
 				pstmt.setString (4, String.valueOf(ht.get("CAR_MNG_ID")));
 				pstmt.setString (5, String.valueOf(ht.get("RENT_L_CD")));
 				 				
 				pstmt.setString (6, String.valueOf(ht.get("SERV_ST")));
 				pstmt.setString (7, String.valueOf(ht.get("JUNG_ST"))); 				
 				pstmt.setInt   (8, AddUtil.parseDigit(String.valueOf(ht.get("OUR_FAULT"))));
 				pstmt.setInt   (9, AddUtil.parseDigit(String.valueOf(ht.get("V_AMT"))));
 				pstmt.setInt   (10, AddUtil.parseDigit(String.valueOf(ht.get("V_LABOR"))));
 				pstmt.setInt   (11, AddUtil.parseDigit(String.valueOf(ht.get("V_CUST_AMT"))));
 				pstmt.setInt   (12, AddUtil.parseDigit(String.valueOf(ht.get("V_EXT_AMT"))));
 				pstmt.setString (13, String.valueOf(ht.get("CAR_NO")));
 				pstmt.setString (14, String.valueOf(ht.get("OFF_ID")));
 				
 				pstmt.executeUpdate();
 				
 			}

 			pstmt.close();
            conn.commit();
        
 	  } catch (Exception e) {
			System.out.println("[CusSamt_Database:insertSetCusSamt]\n"+e);
			e.printStackTrace();
			row_id = "0";
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return row_id;
		}
	}
     
}
