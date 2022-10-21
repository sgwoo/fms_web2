package acar.speedmate;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;
import acar.account.*;
import acar.stat_applet.*;
import acar.common.*;

public class SpeedMateDatabase
{
	private Connection conn = null;
	public static SpeedMateDatabase db;
	
	public static SpeedMateDatabase getInstance()
	{
		if(SpeedMateDatabase.db == null)
			SpeedMateDatabase.db = new SpeedMateDatabase();
		return SpeedMateDatabase.db;
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
	 *	스피드메이트 제출자료
	 */
	public Vector SpeedMateExcelList(String s_kd, String st_dt, String end_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		

		query = " SELECT  '201009000211' AS 법인ID, u.sk_code AS 조직ID, '2010112022' AS 차고지ID, "+
				" x.SP_CODE AS 차정ID, b.car_no 차량번호, "+
				" decode( b.fuel_kd, '1', '210001', '2', '휘발유(무연)', '3', '210003', '4', '210002',  '5', '210004', '6', '휘발유(무연)+LPG겸용','7','210005', '8','210005','9','210006','10','210005' ) 연료구분코드, "+
				" decode( d.auto_yn, 'Y', '208002', decode( sign( instr( c.opt, '자동변속기' )), 1, '208002', '208001' )) 변속기종류코드, substr( b.init_reg_dt, 0, 6 ) AS 연식년월, "+
				" u.sk_code sk_code, u.user_nm 담당자, u.user_m_tel 연락처, decode(a.car_st,'2','예비',DECODE(nvl( a.use_yn, 'Y' ), 'Y','신규','N','해지') ) AS 구분 "+
				" FROM cont a, car_reg b, car_etc c, car_nm d, fee f, v_tot_dist v, users u, speed_car_code x  "+
				" WHERE  nvl( a.use_yn, 'Y' ) = 'Y'  AND  a.car_st <> '2'  AND nvl( b.prepare, '0' ) NOT IN ( '4', '5' )  AND a.car_mng_id = b.car_mng_id  "+
				" AND a.car_mng_id = v.car_mng_id(+)  AND a.rent_l_cd = c.rent_l_cd  AND c.car_id = d.car_id  AND c.car_seq = d.car_seq  "+
				" AND a.rent_mng_id = f.rent_mng_id  AND a.rent_l_cd = f.rent_l_cd  AND f.rent_st = '1' and d.jg_code = x.sh_code  AND (f.rent_way = '1' OR a.car_st = '2' )  AND nvl(a.mng_id,a.bus_id2) = u.user_id  ";

		if(s_kd.equals("1")){
			query += " and f.rent_start_dt like substr(to_char(sysdate,'YYYYMMDD'),1,6)||'%'";		
		}else if(s_kd.equals("3")){
			query += " and f.rent_start_dt like to_char(ADD_MONTHS(SYSDATE,-1), 'yyyymm')||'%'";		
		}else if(s_kd.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and f.rent_start_dt like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and f.rent_start_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		query += " ORDER BY d.jg_code ";



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
			System.out.println("[SpeedMateDatabase:SpeedMateExcelList]\n"+e);
			System.out.println("[SpeedMateDatabase:SpeedMateExcelList]\n"+query);
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
	 *	스피드메이트 제출자료 > 연체 추가 2018.03.23
	 */
	public Vector SpeedMateExcelList2(String s_kd, String st_dt, String end_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = "select aa.*, sf.dly_count from ("+
				" select  '201009000211' as 법인ID, u.sk_code as 조직ID, '2010112022' as 차고지ID, "+
				" x.SP_CODE AS 차정ID, b.car_no 차량번호, "+
				" decode( b.fuel_kd, '1', '210001', '2', '휘발유(무연)', '3', '210003', '4', '210002',  '5', '210004', '6', '휘발유(무연)+LPG겸용','7','210005', '8','210005','9','210006','10','210005' ) 연료구분코드, "+
				" decode( d.auto_yn, 'Y', '208002', decode( sign( instr( c.opt, '자동변속기' )), 1, '208002', '208001' )) 변속기종류코드, substr( b.init_reg_dt, 0, 6 ) as 연식년월, "+
				" u.sk_code sk_code, u.user_nm 담당자, u.user_m_tel 연락처, decode(a.car_st,'2','예비',DECODE(nvl( a.use_yn, 'Y' ), 'Y','신규','N','해지') ) as 구분, "+
				" a.rent_mng_id, a.rent_l_cd "+
				" from cont a, car_reg b, car_etc c, car_nm d, fee f, v_tot_dist v, users u, speed_car_code x  "+
				" where  nvl( a.use_yn, 'Y' ) = 'Y'  and  a.car_st <> '2'  and nvl( b.prepare, '0' ) NOT IN ( '4', '5' )  and a.car_mng_id = b.car_mng_id  "+
				" and a.car_mng_id = v.car_mng_id(+)  and a.rent_l_cd = c.rent_l_cd  and c.car_id = d.car_id  and c.car_seq = d.car_seq  "+
				" and a.rent_mng_id = f.rent_mng_id  and a.rent_l_cd = f.rent_l_cd  and f.rent_st = '1' and d.jg_code = x.sh_code  and (f.rent_way = '1' OR a.car_st = '2' )  and nvl(a.mng_id,a.bus_id2) = u.user_id  ";

		if(s_kd.equals("1")){
			query += " and f.rent_start_dt like substr(to_char(sysdate,'YYYYMMDD'),1,6)||'%'";		
		}else if(s_kd.equals("3")){
			query += " and f.rent_start_dt like to_char(ADD_MONTHS(SYSDATE,-1), 'yyyymm')||'%'";		
		}else if(s_kd.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and f.rent_start_dt like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and f.rent_start_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		query += " order by d.jg_code ) aa left outer join ";
		query += " (select rent_mng_id, rent_l_cd, max(use_e_dt) fee_est_dt, count(case when rc_dt is null and r_fee_est_dt < to_char(sysdate,'YYYYMMDD') then rent_l_cd else '' end) ";
		query += " dly_count from scd_fee where bill_yn='Y' group by rent_mng_id, rent_l_cd) sf on aa.rent_mng_id = sf.rent_mng_id and aa.rent_l_cd = sf.rent_l_cd ";

/*System.out.println("[SpeedMateDatabase:SpeedMateExcelList2]\n"+s_kd);
System.out.println("[SpeedMateDatabase:SpeedMateExcelList2]\n"+st_dt);
System.out.println("[SpeedMateDatabase:SpeedMateExcelList2]\n"+end_dt);
System.out.println("[SpeedMateDatabase:SpeedMateExcelList2]\n"+query);*/
		
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
			System.out.println("[SpeedMateDatabase:SpeedMateExcelList2]\n"+e);
			System.out.println("[SpeedMateDatabase:SpeedMateExcelList2]\n"+query);
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
	 *	스피드메이트 제출자료 //월렌트 차량도 포함. 2012.12.13
	 */
	public Vector SpeedMateExcelList_re(String s_kd, String st_dt, String end_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT '201009000211' AS 법인ID, u.sk_code AS 조직ID, '2010112022' AS 차고지ID, x.SP_CODE AS 차정ID, b.car_no 차량번호, "+
		        " e2.nm as 차종, "+
				" decode( b.fuel_kd, '1', '210001', '2', '휘발유(무연)', '3', '210003', '4', '210002',  '5', '210004', '6', '휘발유(무연)+LPG겸용','7','210005', '8','210005','9','210006','10','210005' ) 연료구분코드, "+
				" decode( d.auto_yn, 'Y', '208002', decode( sign( instr( c.opt, '자동변속기' )), 1, '208002', '208001' )) 변속기종류코드, substr( b.init_reg_dt, 0, 6 ) AS 연식년월, "+
				" b.car_nm 차명, d.car_name 차정, e.nm as 유종, NVL(v.tot_dist,0) AS 현주행거리,  "+
				" b.init_reg_dt AS 연식, decode( d.auto_yn, 'Y', '오토', decode( sign( instr( c.opt, '자동변속기' )), 1, '오토', '수동' )) 변속기, u.sk_code sk_code, u.user_nm 담당자, u.user_m_tel 연락처, decode(a.car_st,'2','예비',DECODE(nvl( a.use_yn, 'Y' ), 'Y','신규','N','해지') ) AS 구분 "+
				" FROM cont a, car_reg b, car_etc c, car_nm d, fee f, v_tot_dist v, users u , speed_car_code x,  "+
				"      (select * from code where c_st='0039') e, "+
				"      (select * from code where c_st='0041') e2 "+
				" WHERE nvl( b.prepare, '0' ) NOT IN ( '4', '5' )  AND a.car_mng_id = b.car_mng_id  "+
				" AND a.car_mng_id = v.car_mng_id(+)  AND a.rent_l_cd = c.rent_l_cd  AND c.car_id = d.car_id  AND c.car_seq = d.car_seq  "+
				" AND a.rent_mng_id = f.rent_mng_id  AND a.rent_l_cd = f.rent_l_cd   AND d.jg_code = x.sh_code  "+
				" AND f.rent_st = '1'  AND ( f.rent_way = '1' OR a.car_st = '2' )  AND a.mng_id = u.user_id AND b.OFF_LS NOT IN ('6') "+
				" and b.fuel_kd=e.nm_cd and b.car_kd=e2.nm_cd ";

		if(s_kd.equals("1")){
			query += " and DECODE(a.car_st ,'2',a.reg_dt, f.rent_start_dt) like to_char(sysdate,'YYYYMM')||'%'";		
		}else if(s_kd.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and DECODE(a.car_st ,'2',a.reg_dt, f.rent_start_dt) like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and DECODE(a.car_st ,'2',a.reg_dt, f.rent_start_dt) between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		query += " ORDER BY d.jg_code ";


		
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
			System.out.println("[SpeedMateDatabase:SpeedMateExcelList_re]\n"+e);
			System.out.println("[SpeedMateDatabase:SpeedMateExcelList_re]\n"+query);
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
	 *	스피드메이트 제출자료 // 월렌트 차량도 포함 2012.12.13 > 연체 추가 2018.03.21
	 */
	public Vector SpeedMateExcelList_re2(String s_kd, String st_dt, String end_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT aa.*, sf.dly_count "+
				" FROM   ( "+ 
				"          SELECT '201009000211' AS 법인ID, u.sk_code AS 조직ID, '2010112022' AS 차고지ID, x.SP_CODE AS 차정ID, b.car_no 차량번호, "+
				"                 e2.nm as 차종, "+
				"                 decode( b.fuel_kd, '1', '210001', '2', '휘발유(무연)', '3', '210003', '4', '210002',  '5', '210004', '6', '휘발유(무연)+LPG겸용','7','210005', '8','210005','9','210006','10','210005' ) 연료구분코드, "+
				"                 decode( d.auto_yn, 'Y', '208002', decode( sign( instr( c.opt, '자동변속기' )), 1, '208002', '208001' )) 변속기종류코드, substr( b.init_reg_dt, 0, 6 ) AS 연식년월, "+
				"                 b.car_nm 차명, d.car_name 차정, e.nm as 유종, NVL(v.tot_dist,0) AS 현주행거리,  "+
				"                 b.init_reg_dt AS 연식, decode( d.auto_yn, 'Y', '오토', decode( sign( instr( c.opt, '자동변속기' )), 1, '오토', '수동' )) 변속기, u.sk_code sk_code, u.user_nm 담당자, u.user_m_tel 연락처, "+
				"                 decode(a.car_st,'2','예비','4','월렌트',DECODE(nvl( a.use_yn, 'Y' ), 'Y','신규','N','해지') ) AS 구분, "+
				"                 a.rent_mng_id, a.rent_l_cd, a.car_st "+
				"          FROM   cont a, car_reg b, car_etc c, car_nm d, fee f, v_tot_dist v, users u , speed_car_code x, \n"+
				"                 (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) f2,  "+
				"                 (select * from code where c_st='0039') e, "+
				"                 (select * from code where c_st='0041') e2 "+
				"          WHERE  nvl( a.use_yn, 'Y' ) = 'Y' "+
				"                 AND a.car_mng_id = b.car_mng_id  "+
				"                 AND a.car_mng_id = v.car_mng_id(+)  "+
				"                 AND a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd "+
				"                 AND c.car_id = d.car_id  AND c.car_seq = d.car_seq  "+
				"                 AND a.rent_mng_id = f.rent_mng_id  AND a.rent_l_cd = f.rent_l_cd "+
				"                 AND f.rent_mng_id = f2.rent_mng_id  AND f.rent_l_cd = f2.rent_l_cd and f.rent_st=f2.rent_st "+
				"                 AND d.jg_code = x.sh_code  "+
				"                 AND ( f.rent_way = '1' OR a.car_st = '2' ) "+
				"                 AND a.mng_id = u.user_id "+
				"                 AND nvl( b.prepare, '0' ) NOT IN ( '4', '5' )  AND nvl(b.OFF_LS,'0') NOT IN ('6') and b.fuel_kd=e.nm_cd and b.car_kd=e2.nm_cd ";

		if(s_kd.equals("1")){
			query += " and DECODE(a.car_st ,'2',a.reg_dt, f.rent_start_dt) like to_char(sysdate,'YYYYMM')||'%'";		
		}else if(s_kd.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and DECODE(a.car_st ,'2',a.reg_dt, f.rent_start_dt) like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and DECODE(a.car_st ,'2',a.reg_dt, f.rent_start_dt) between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}
		query += " ORDER BY d.jg_code ) aa left outer join ";
		query += " (select rent_mng_id, rent_l_cd, max(use_e_dt) fee_est_dt, count(case when rc_dt is null and r_fee_est_dt < to_char(sysdate,'YYYYMMDD') then rent_l_cd else '' end) dly_count";
		query += " from scd_fee where bill_yn='Y' group by rent_mng_id, rent_l_cd) sf on aa.rent_mng_id = sf.rent_mng_id and aa.rent_l_cd = sf.rent_l_cd ";
		
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
			System.out.println("[SpeedMateDatabase:SpeedMateExcelList_re2]\n"+e);
			System.out.println("[SpeedMateDatabase:SpeedMateExcelList_re2]\n"+query);
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
	 *	삼성애니카랜드 제출자료
	 */
	public Vector AnycarExcelList(String s_kd, String st_dt, String end_dt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = " SELECT b.car_no 차량번호, e2.nm as 차종, "+
				" b.car_nm 차명, d.car_name 차정, e.nm as 유종, NVL(v.tot_dist,0) AS 현주행거리,  "+
				" b.init_reg_dt AS 연식, decode( d.auto_yn, 'Y', '오토', decode( sign( instr( c.opt, '자동변속기' )), 1, '오토', '수동' )) 변속기, u.user_nm 담당자, u.user_m_tel 연락처, decode(a.car_st,'2','예비',DECODE(nvl( a.use_yn, 'Y' ), 'Y','신규','N','해지') ) AS 구분 "+
				" FROM cont a, car_reg b, car_etc c, car_nm d, fee f, v_tot_dist v, users u,  "+
				"      (select * from code where c_st='0039') e, "+
				"      (select * from code where c_st='0041') e2 "+
				" WHERE a.car_st <> '2'  AND  nvl( b.prepare, '0' ) NOT IN ( '4', '5' )  AND a.car_mng_id = b.car_mng_id  "+
				" AND a.car_mng_id = v.car_mng_id(+)  AND a.rent_l_cd = c.rent_l_cd  AND c.car_id = d.car_id  AND c.car_seq = d.car_seq  "+
				" AND a.rent_mng_id = f.rent_mng_id  AND a.rent_l_cd = f.rent_l_cd  AND f.rent_st = '1'  AND ( f.rent_way = '1' OR a.car_st = '2' )  AND a.mng_id = u.user_id AND b.OFF_LS NOT IN ('6') "+
				" and b.fuel_kd=e.nm_cd and b.car_kd=e2.nm_cd ";

		if(s_kd.equals("1")){
			query += " and DECODE(a.car_st ,'2',a.reg_dt, f.rent_start_dt) like to_char(sysdate,'YYYYMM')||'%'";		
		}else if(s_kd.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and DECODE(a.car_st ,'2',a.reg_dt, f.rent_start_dt) like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and DECODE(a.car_st ,'2',a.reg_dt, f.rent_start_dt) between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		query += " ORDER BY d.jg_code ";


		
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
			System.out.println("[SpeedMateDatabase:SpeedMateExcelList]\n"+e);
			System.out.println("[SpeedMateDatabase:SpeedMateExcelList]\n"+query);
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

	
	public Vector SpeedMateExcelListN(String s_kd, String st_dt, String end_dt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = " SELECT b.car_no 차량번호, e2.nm as 차종, "+
				" b.car_nm 차명, d.car_name 차정, e.nm as 유종, v.tot_dist 현주행거리,  "+
				" b.init_reg_dt AS 연식, decode( d.auto_yn, 'Y', '오토', decode( sign( instr( c.opt, '자동변속기' )), 1, '오토', '수동' )) 변속기, u.user_nm 담당자, u.user_m_tel 연락처  "+
				" FROM cont a, car_reg b, car_etc c, car_nm d, fee f, v_tot_dist v, users u,  "+
				"      (select * from code where c_st='0039') e, "+
				"      (select * from code where c_st='0041') e2 "+				
				" WHERE nvl( a.use_yn, 'Y' ) = 'N'  AND a.car_st <> '2'  AND nvl( b.prepare, '0' ) NOT IN ( '4', '5' )  AND a.car_mng_id = b.car_mng_id  "+
				" AND a.car_mng_id = v.car_mng_id(+)  AND a.rent_l_cd = c.rent_l_cd  AND c.car_id = d.car_id  AND c.car_seq = d.car_seq  "+
				" AND a.rent_mng_id = f.rent_mng_id  AND a.rent_l_cd = f.rent_l_cd  AND f.rent_st = '1'  AND f.rent_way = '1'  AND a.bus_id2 = u.user_id  "+
				" and b.fuel_kd=e.nm_cd and b.car_kd=e2.nm_cd ";


		if(s_kd.equals("1")){
			query += " and b.init_reg_dt like to_char(sysdate,'YYYYMM')||'%'";		
		}else if(s_kd.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and a.rent_dt like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and a.rent_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		query += " ORDER BY d.jg_code ";

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
			System.out.println("[SpeedMateDatabase:SpeedMateExcelListN]\n"+e);
			System.out.println("[SpeedMateDatabase:SpeedMateExcelListN]\n"+query);
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
	 *	스피드메이트 정비품목 자료
	 */
	public Vector SpeedMateJBList(String jg_code, String gubun2, String gubun3, String st_dt, String end_dt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = " select replace(car_code, '|',', ') car_code , item, reg_dt, parts_amt, wages_amt, dist, re_mark from BASIC_PRICE where car_code like '%"+jg_code+"%'  ";

		if(gubun2.equals("1")){
			query += " and reg_dt like to_char(sysdate,'YYYYMM')||'%'";		
		}else if(gubun2.equals("3")){
			query += " and reg_dt like to_char(ADD_MONTHS(SYSDATE,-1), 'yyyymm')||'%'";		
		}else if(gubun2.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and reg_dt like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and reg_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		query += " ORDER BY car_code ";

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
			System.out.println("[SpeedMateDatabase:SpeedMateJBList]\n"+e);
			System.out.println("[SpeedMateDatabase:SpeedMateJBList]\n"+query);
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
	 *	전날짜 - working day 기준
	 */
	public String getWortPreDay(String work_dt, int p_day)
	{
		getConnection();
		
		String query = "";
		
		String sResult = "";
		CallableStatement cstmt = null;
	
			
		try {
			cstmt = conn.prepareCall("{ ? =  call F_getPreDay( ?, ? ) }");
	
			cstmt.registerOutParameter( 1, java.sql.Types.VARCHAR );			
		    cstmt.setString(2, work_dt );
		    cstmt.setInt(3, p_day );
	  	           
	        cstmt.execute();
	        sResult = cstmt.getString(1); // 결과값
	       	cstmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getWortPreDay]\n"+e);
			System.out.println("[AdminDatabase:getWortPreDay]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if(cstmt != null )		cstmt.close();			
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}
 



	/** 
	 *	삼성애니카랜드 제출자료
	 */
	public Vector getMasterCarComAcarExcelList()
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = " select decode(nvl(b.m1_chk, ''),'1','요청',' ') 요청, \n"+
				" '등록' 구분, b.init_reg_dt 등록일자, b.car_no 차량번호, b.car_nm||' '||d.car_name 차종, replace(e.nm,'자동차','') 제조사, substr(b.init_reg_dt,1,4) as 연식, \n"+
				" decode(d.auto_yn,'Y','오토',decode(sign(instr(c.opt,'자동변속기')),1,'오토','수동')) 미션, \n"+
				" e2.nm as 연료, \n"+
				" o.firm_nm 고객, \n"+
				" nvl(o.o_tel,o.con_agnt_o_tel) 사무실, \n"+
				" nvl(o.m_tel,o.con_agnt_m_tel) 휴대폰, \n"+
				" jj.mgr_m_tel  실운전자, \n"+
				" o.o_addr 주소, \n"+
				" o.CON_AGNT_EMAIL 이메일, \n"+
				" j.ins_com_nm 보험사, h.ins_start_dt||'~'||h.ins_exp_dt 대여기간, \n"+
				" '자배법시행령에서 정한 금액' 대인배상Ⅰ, \n"+
				" decode(h.vins_pcp_kd,'1','무한','2','유한') 대인배상Ⅱ, \n"+
				" decode(h.vins_gcp_kd,'1','3000만원','2','1500만원',  '3','1억원',   '4','5000만원','5','1000만원','미가입') 대물배상, \n"+
				" decode(h.vins_bacdt_kd,'1','3억원',   '2','1억5천만원','3','3000만원','4','1500만원','5','5000만원','6','1억원','미가입') 자기신체사고_사망장애, \n"+
				" decode(h.vins_bacdt_kc2,'1','3억원',   '2','1억5천만원','3','3000만원','4','1500만원','5','5000만원','6','1억원','미가입') 자기신체사고_부상, \n"+
				" decode(h.vins_cacdt_car_amt,0,'',h.vins_cacdt_car_amt||'만원') 자차차량, \n"+
				" decode(h.vins_cacdt_me_amt,0,'',h.vins_cacdt_me_amt||'만원') 자차자기부담금, \n"+
				" decode(h.vins_canoisr_amt,0,'','가입') 무보험, \n"+
				" decode(h.car_use,'1','영업용','2','업무용') 보험종류, \n"+
				" decode(h.age_scp,'1','21세이상','2','26세이상','3','모든운전자','4','24세이상') 연령범위, \n"+
				" decode(h.air_ds_yn,'Y',1,0)+decode(h.air_as_yn,'Y',1,0) 에어백, \n"+
				" h.con_f_nm 피보험자, b.init_reg_dt 최초등록일, hh.nm 등록지역, \n"+
				" decode(f.rent_way,'1','일반식','기본식') 대여방식, g.user_nm 관리담당자, g.user_m_tel 연락처 \n"+
				" from cont a, car_reg b, car_etc c, car_nm d, client o, \n"+
				" (select * from car_mgr where mgr_st='차량이용자') jj , (select * from code where c_st='0032' and code <> '0000'  ) hh ,  \n"+
				" (select * from code where c_st='0001') e, \n"+
				" (select * from code where c_st='0039') e2, \n"+
				" (select a.* from insur a, (select car_mng_id, max(ins_exp_dt) ins_exp_dt from insur group by car_mng_id) b \n"+
				"         where a.car_mng_id=b.car_mng_id and a.ins_exp_dt=b.ins_exp_dt \n"+
				" ) h, \n"+
				" ins_com j, fee f, users g \n"+
				" where \n"+
				" nvl(a.use_yn,'Y')='Y' \n"+
				" and nvl(b.prepare,'0') not in ('4','5') \n"+
				" and a.car_mng_id=b.car_mng_id \n"+
				" and a.rent_l_cd=c.rent_l_cd \n"+
				" and c.car_id=d.car_id and c.car_seq=d.car_seq \n"+
				" and d.car_comp_id=e.code \n"+
				" and a.client_id=o.client_id \n"+
				" and b.car_ext =hh.nm_cd \n"+
				" and b.fuel_kd =e2.nm_cd \n"+
				" and a.car_mng_id=h.car_mng_id(+) \n"+
				" and h.ins_com_id=j.ins_com_id(+) \n"+
				" and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd and f.rent_st='1' \n"+
				" and a.rent_mng_id=jj.rent_mng_id(+) and a.rent_l_cd=jj.rent_l_cd(+) \n"+
				" and nvl(a.mng_id,a.bus_id2)=g.user_id"+
				" ";
		query += " order by d.jg_code";

		
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
			System.out.println("[AdminDatabase:getMasterCarComAcarExcelList]\n"+e);
			System.out.println("[AdminDatabase:getMasterCarComAcarExcelList]\n"+query);
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
	 *	삼성애니카랜드 제출자료
	 */
	public Vector getMasterCarComAcarExcelList(String s_kd, String st_dt, String end_dt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = " select '1' gg, decode(nvl(b.m1_chk, ''),'1','요청',' ') 요청, \n"+
				" '등록' 구분, b.init_reg_dt 등록일자,  b.car_no 차량번호, b.car_nm||' '||d.car_name 차종, replace(e.nm,'자동차','') 제조사, substr(b.init_reg_dt,1,4) as 연식, \n"+
				" decode(d.auto_yn,'Y','오토',decode(sign(instr(c.opt,'자동변속기')),1,'오토','수동')) 미션, \n"+
				" e2.nm as 연료, \n"+
				" o.firm_nm 고객, \n"+
				" nvl(o.o_tel,o.con_agnt_o_tel) 사무실, \n"+
				" nvl(o.m_tel,o.con_agnt_m_tel) 휴대폰, \n"+
				" jj.mgr_m_tel  실운전자, \n"+
				" o.o_addr 주소, \n"+
				" o.CON_AGNT_EMAIL 이메일, \n"+
				" j.ins_com_nm 보험사, h.ins_start_dt||'~'||h.ins_exp_dt 대여기간, \n"+
				" '자배법시행령에서 정한 금액' 대인배상Ⅰ, \n"+
				" decode(h.vins_pcp_kd,'1','무한','2','유한') 대인배상Ⅱ, \n"+
				" decode(h.vins_gcp_kd,'1','3000만원','2','1500만원',  '3','1억원',   '4','5000만원','5','1000만원','미가입') 대물배상, \n"+
				" decode(h.vins_bacdt_kd,'1','3억원',   '2','1억5천만원','3','3000만원','4','1500만원','5','5000만원','6','1억원','미가입') 자기신체사고_사망장애, \n"+
				" decode(h.vins_bacdt_kc2,'1','3억원',   '2','1억5천만원','3','3000만원','4','1500만원','5','5000만원','6','1억원','미가입') 자기신체사고_부상, \n"+
				" decode(h.vins_cacdt_car_amt,0,'',h.vins_cacdt_car_amt||'만원') 자차차량, \n"+
				" decode(h.vins_cacdt_me_amt,0,'',h.vins_cacdt_me_amt||'만원') 자차자기부담금, \n"+
				" decode(h.vins_canoisr_amt,0,'','가입') 무보험, \n"+
				" decode(h.car_use,'1','영업용','2','업무용') 보험종류, \n"+
				" decode(h.age_scp,'1','21세이상','2','26세이상','3','모든운전자','4','24세이상') 연령범위, \n"+
				" decode(h.air_ds_yn,'Y',1,0)+decode(h.air_as_yn,'Y',1,0) 에어백, \n"+
				" h.con_f_nm 피보험자, b.init_reg_dt 최초등록일, hh.nm  등록지역, \n"+
				" decode(f.rent_way,'1','일반식','기본식') 대여방식, g.user_nm 관리담당자, g.user_m_tel 연락처 \n"+
				" from cont a, car_reg b, car_etc c, car_nm d, client o, \n"+
				" (select * from car_mgr where mgr_st='차량이용자') jj ,(select * from code where c_st='0032' and code <> '0000'  ) hh , \n"+
				" (select * from code where c_st='0001') e, \n"+
				" (select * from code where c_st='0039') e2, \n"+
				" (select a.* from insur a, (select car_mng_id, max(ins_exp_dt) ins_exp_dt from insur group by car_mng_id) b \n"+
				"         where a.car_mng_id=b.car_mng_id and a.ins_exp_dt=b.ins_exp_dt \n"+
				" ) h, \n"+
				" ins_com j, fee f, users g \n"+
				" where \n"+
				" nvl(a.use_yn,'Y')='Y' \n"+
				" and nvl(b.prepare,'0') not in ('4','5') \n"+
				" and a.car_mng_id=b.car_mng_id \n"+
				" and a.rent_l_cd=c.rent_l_cd \n"+
				" and c.car_id=d.car_id and c.car_seq=d.car_seq \n"+
				" and d.car_comp_id=e.code \n"+
				" and b.fuel_kd=e2.nm_cd \n"+
				" and a.client_id=o.client_id \n"+
				" and b.car_ext =hh.nm_cd \n"+
				" and a.car_mng_id=h.car_mng_id(+) \n"+
				" and h.ins_com_id=j.ins_com_id(+) \n"+
				" and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd and f.rent_st='1' \n"+
				" and a.rent_mng_id=jj.rent_mng_id(+) and a.rent_l_cd=jj.rent_l_cd(+) \n"+
				" and nvl(a.mng_id,a.bus_id2)=g.user_id"+
				" ";

		if(s_kd.equals("1"))			query += " and b.init_reg_dt = to_char(sysdate,'YYYYMMDD')";	
		else if(s_kd.equals("3"))		query += " and b.init_reg_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(s_kd.equals("4"))		query += " and b.init_reg_dt = to_char(to_date(to_char(sysdate,'YYYYMMDD')) - 1, 'yyyymmdd') ";
		else if(s_kd.equals("5"))		query += " and b.init_reg_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' ";
		else if(s_kd.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and b.init_reg_dt like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and b.init_reg_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		query += " union all";

		query += " select '2' gg, decode(nvl(b.m1_chk, ''),'1','요청',' ') 요청, \n"+
				" '매각' 구분, s.jan_pr_dt 등록일자, b.car_no 차량번호, b.car_nm||' '||d.car_name 차종, replace(e.nm,'자동차','') 제조사, substr(b.init_reg_dt,1,4) as 연식, \n"+
				" decode(d.auto_yn,'Y','오토',decode(sign(instr(c.opt,'자동변속기')),1,'오토','수동')) 미션, \n"+
				" e2.nm as 연료, \n"+
				" o.firm_nm 고객, \n"+
				" nvl(o.o_tel,o.con_agnt_o_tel) 사무실, \n"+
				" nvl(o.m_tel,o.con_agnt_m_tel) 휴대폰, \n"+
				" jj.mgr_m_tel  실운전자, \n"+
				" o.o_addr 주소, \n"+
				" o.CON_AGNT_EMAIL 이메일, \n"+
				" j.ins_com_nm 보험사, h.ins_start_dt||'~'||h.ins_exp_dt 대여기간, \n"+
				" '자배법시행령에서 정한 금액' 대인배상Ⅰ, \n"+
				" decode(h.vins_pcp_kd,'1','무한','2','유한') 대인배상Ⅱ, \n"+
				" decode(h.vins_gcp_kd,'1','3000만원','2','1500만원',  '3','1억원',   '4','5000만원','5','1000만원','미가입') 대물배상, \n"+
				" decode(h.vins_bacdt_kd,'1','3억원',   '2','1억5천만원','3','3000만원','4','1500만원','5','5000만원','6','1억원','미가입') 자기신체사고_사망장애, \n"+
				" decode(h.vins_bacdt_kc2,'1','3억원',   '2','1억5천만원','3','3000만원','4','1500만원','5','5000만원','6','1억원','미가입') 자기신체사고_부상, \n"+
				" decode(h.vins_cacdt_car_amt,0,'',h.vins_cacdt_car_amt||'만원') 자차차량, \n"+
				" decode(h.vins_cacdt_me_amt,0,'',h.vins_cacdt_me_amt||'만원') 자차자기부담금, \n"+
				" decode(h.vins_canoisr_amt,0,'','가입') 무보험, \n"+
				" decode(h.car_use,'1','영업용','2','업무용') 보험종류, \n"+
				" decode(h.age_scp,'1','21세이상','2','26세이상','3','모든운전자','4','24세이상') 연령범위, \n"+
				" decode(h.air_ds_yn,'Y',1,0)+decode(h.air_as_yn,'Y',1,0) 에어백, \n"+
				" h.con_f_nm 피보험자, b.init_reg_dt 최초등록일, hh.nm 등록지역, \n"+
				" decode(f.rent_way,'1','일반식','기본식') 대여방식, g.user_nm 관리담당자, g.user_m_tel 연락처 \n"+
				" from cont a, car_reg b, car_etc c, car_nm d, client o, \n"+
				" (select * from car_mgr where mgr_st='차량이용자') jj ,(select * from code where c_st='0032' and code <> '0000'  ) hh , \n"+
				" (select * from code where c_st='0001') e, \n"+
				" (select * from code where c_st='0039') e2, \n"+
				" (select a.* from insur a, (select car_mng_id, max(ins_exp_dt) ins_exp_dt from insur group by car_mng_id) b \n"+
				"         where a.car_mng_id=b.car_mng_id and a.ins_exp_dt=b.ins_exp_dt \n"+
				" ) h, \n"+
				" ins_com j, sui s, (select car_mng_id, max(rent_dt) rent_dt, max(reg_dt) reg_dt from cont where rent_l_cd not like 'RM%' group by car_mng_id) n, fee f, users g\n"+
				" where \n"+
				" nvl(a.use_yn,'Y')='N' \n"+
				" and nvl(b.prepare,'0') not in ('4','5','9') \n"+
				" and a.car_mng_id=b.car_mng_id \n"+
				" and a.rent_l_cd=c.rent_l_cd \n"+
				" and c.car_id=d.car_id and c.car_seq=d.car_seq \n"+
				" and d.car_comp_id=e.code \n"+
				" and b.fuel_kd=e2.nm_cd \n"+
				" and a.client_id=o.client_id \n"+
				" and a.car_mng_id=h.car_mng_id(+) \n"+
				" and h.ins_com_id=j.ins_com_id(+) \n"+
				" and a.car_mng_id=s.car_mng_id"+
				" and b.car_ext =hh.nm_cd \n"+
				" and a.car_mng_id=n.car_mng_id and a.rent_dt=n.rent_dt and a.reg_dt=n.reg_dt"+
				" and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd and f.rent_st='1' \n"+
				" and a.rent_mng_id=jj.rent_mng_id(+) and a.rent_l_cd=jj.rent_l_cd(+) \n"+
				" and nvl(a.mng_id,a.bus_id2)=g.user_id"+
				" ";

		if(s_kd.equals("1"))			query += " and s.jan_pr_dt = to_char(sysdate,'YYYYMMDD')";		
		else if(s_kd.equals("3"))		query += " and s.jan_pr_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(s_kd.equals("4"))		query += " and s.jan_pr_dt = to_char(to_date(to_char(sysdate,'YYYYMMDD')) - 1, 'yyyymmdd') ";
		else if(s_kd.equals("5"))		query += " and s.jan_pr_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' ";	
		else if(s_kd.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and s.jan_pr_dt like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and s.jan_pr_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}			

		query += " union all";


		query += " select '3' gg, decode(nvl(b.m1_chk, ''),'1','요청',' ') 요청, \n"+
				"  '검사' 구분, case when b.m1_chk ='1' then b.m1_dt else ' ' end 등록일자,  b.car_no 차량번호, b.car_nm||' '||d.car_name 차종, replace(e.nm,'자동차','') 제조사, substr(b.init_reg_dt,1,4) as 연식, \n"+
				" decode(d.auto_yn,'Y','오토',decode(sign(instr(c.opt,'자동변속기')),1,'오토','수동')) 미션, \n"+
				" e2.nm as 연료, \n"+
				" o.firm_nm 고객, \n"+
				" nvl(o.o_tel,o.con_agnt_o_tel) 사무실, \n"+
				" nvl(o.m_tel,o.con_agnt_m_tel) 휴대폰, \n"+
				" jj.mgr_m_tel  실운전자, \n"+
				" o.o_addr 주소, \n"+
				" o.CON_AGNT_EMAIL 이메일, \n"+
				" j.ins_com_nm 보험사, h.ins_start_dt||'~'||h.ins_exp_dt 대여기간, \n"+
				" '자배법시행령에서 정한 금액' 대인배상Ⅰ, \n"+
				" decode(h.vins_pcp_kd,'1','무한','2','유한') 대인배상Ⅱ, \n"+
				" decode(h.vins_gcp_kd,'1','3000만원','2','1500만원',  '3','1억원',   '4','5000만원','5','1000만원','미가입') 대물배상, \n"+
				" decode(h.vins_bacdt_kd,'1','3억원',   '2','1억5천만원','3','3000만원','4','1500만원','5','5000만원','6','1억원','미가입') 자기신체사고_사망장애, \n"+
				" decode(h.vins_bacdt_kc2,'1','3억원',   '2','1억5천만원','3','3000만원','4','1500만원','5','5000만원','6','1억원','미가입') 자기신체사고_부상, \n"+
				" decode(h.vins_cacdt_car_amt,0,'',h.vins_cacdt_car_amt||'만원') 자차차량, \n"+
				" decode(h.vins_cacdt_me_amt,0,'',h.vins_cacdt_me_amt||'만원') 자차자기부담금, \n"+
				" decode(h.vins_canoisr_amt,0,'','가입') 무보험, \n"+
				" decode(h.car_use,'1','영업용','2','업무용') 보험종류, \n"+
				" decode(h.age_scp,'1','21세이상','2','26세이상','3','모든운전자','4','24세이상') 연령범위, \n"+
				" decode(h.air_ds_yn,'Y',1,0)+decode(h.air_as_yn,'Y',1,0) 에어백, \n"+
				" h.con_f_nm 피보험자, b.init_reg_dt 최초등록일, hh.nm 등록지역, \n"+
				" decode(f.rent_way,'1','일반식','기본식') 대여방식, g.user_nm 관리담당자, g.user_m_tel 연락처 \n"+
				" from cont a, car_reg b, car_etc c, car_nm d, client o, \n"+
				" (select * from car_mgr where mgr_st='차량이용자') jj ,(select * from code where c_st='0032' and code <> '0000'  ) hh , \n"+
				" (select * from code where c_st='0001') e, \n"+
				" (select * from code where c_st='0039') e2, \n"+
				" (select a.* from insur a, (select car_mng_id, max(ins_exp_dt) ins_exp_dt from insur group by car_mng_id) b \n"+
				"         where a.car_mng_id=b.car_mng_id and a.ins_exp_dt=b.ins_exp_dt \n"+
				" ) h, \n"+
				" ins_com j, fee f, users g \n"+
				" where \n"+
				" nvl(a.use_yn,'Y')='Y' \n"+
				" and nvl(b.prepare,'0') not in ('4','5','9') \n"+
				" and a.car_mng_id=b.car_mng_id \n"+
				" and a.rent_l_cd=c.rent_l_cd \n"+
				" and c.car_id=d.car_id and c.car_seq=d.car_seq \n"+
				" and d.car_comp_id=e.code \n"+
				" and b.fuel_kd=e2.nm_cd \n"+
				" and a.client_id=o.client_id \n"+
				" and b.car_ext =hh.nm_cd \n"+
				" and a.car_mng_id=h.car_mng_id(+) \n"+
				" and h.ins_com_id=j.ins_com_id(+) \n"+
				" and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd and f.rent_st='1' \n"+
				" and a.rent_mng_id=jj.rent_mng_id(+) and a.rent_l_cd=jj.rent_l_cd(+) \n"+
				" and nvl(a.mng_id,a.bus_id2)=g.user_id and b.m1_chk = '1' "+
				" ";

		
		if(s_kd.equals("1"))			query += " and b.m1_dt = to_char(sysdate,'YYYYMMDD')";		
		else if(s_kd.equals("3"))		query += " and b.m1_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(s_kd.equals("4"))		query += " and b.m1_dt = to_char(to_date(to_char(sysdate,'YYYYMMDD')) - 1, 'yyyymmdd') ";
		else if(s_kd.equals("5"))		query += " and b.m1_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' ";	
		else if(s_kd.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and b.m1_dt like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and b.m1_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}
		
		query += " order by  1,  4  ";

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
			System.out.println("[AdminDatabase:getMasterCarComAcarExcelList]\n"+e);
			System.out.println("[AdminDatabase:getMasterCarComAcarExcelList]\n"+query);
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
	 *	삼성애니카랜드 제출자료
	 */
	public Vector getMasterCarComAcarExcelListAll()
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = " select decode(nvl(b.m1_chk, ''),'1','요청',' ') 요청, \n"+
				" '등록' 구분, b.init_reg_dt 등록일자, b.car_no 차량번호, b.car_nm||' '||d.car_name 차종, replace(e.nm,'자동차','') 제조사, substr(b.init_reg_dt,1,4) as 연식, \n"+
				" decode(d.auto_yn,'Y','오토',decode(sign(instr(c.opt,'자동변속기')),1,'오토','수동')) 미션, \n"+
				" e2.nm as 연료, \n"+
				" o.firm_nm 고객, \n"+
				" nvl(o.o_tel,o.con_agnt_o_tel) 사무실, \n"+
				" nvl(o.m_tel,o.con_agnt_m_tel) 휴대폰, \n"+
				" jj.mgr_m_tel  실운전자, \n"+
				" o.o_addr 주소, \n"+
				" o.CON_AGNT_EMAIL 이메일, \n"+
				" j.ins_com_nm 보험사, h.ins_start_dt||'~'||h.ins_exp_dt 대여기간, \n"+
				" '자배법시행령에서 정한 금액' 대인배상Ⅰ, \n"+
				" decode(h.vins_pcp_kd,'1','무한','2','유한') 대인배상Ⅱ, \n"+
				" decode(h.vins_gcp_kd,'1','3000만원','2','1500만원',  '3','1억원',   '4','5000만원','5','1000만원','미가입') 대물배상, \n"+
				" decode(h.vins_bacdt_kd,'1','3억원',   '2','1억5천만원','3','3000만원','4','1500만원','5','5000만원','6','1억원','미가입') 자기신체사고_사망장애, \n"+
				" decode(h.vins_bacdt_kc2,'1','3억원',   '2','1억5천만원','3','3000만원','4','1500만원','5','5000만원','6','1억원','미가입') 자기신체사고_부상, \n"+
				" decode(h.vins_cacdt_car_amt,0,'',h.vins_cacdt_car_amt||'만원') 자차차량, \n"+
				" decode(h.vins_cacdt_me_amt,0,'',h.vins_cacdt_me_amt||'만원') 자차자기부담금, \n"+
				" decode(h.vins_canoisr_amt,0,'','가입') 무보험, \n"+
				" decode(h.car_use,'1','영업용','2','업무용') 보험종류, \n"+
				" decode(h.age_scp,'1','21세이상','2','26세이상','3','모든운전자','4','24세이상') 연령범위, \n"+
				" decode(h.air_ds_yn,'Y',1,0)+decode(h.air_as_yn,'Y',1,0) 에어백, \n"+
				" h.con_f_nm 피보험자, b.init_reg_dt 최초등록일,  hh.nm 등록지역, \n"+
				" decode(f.rent_way,'1','일반식','기본식') 대여방식, g.user_nm 관리담당자, g.user_m_tel 연락처 \n"+
				" from cont a, car_reg b, car_etc c, car_nm d, client o, \n"+
				" (select * from car_mgr where mgr_st='차량이용자') jj ,(select * from code where c_st='0032' and code <> '0000'  ) hh , \n"+
				" (select * from code where c_st='0001') e, \n"+
				" (select * from code where c_st='0039') e2, \n"+
				" (select a.* from insur a, (select car_mng_id, max(ins_exp_dt) ins_exp_dt from insur group by car_mng_id) b \n"+
				"         where a.car_mng_id=b.car_mng_id and a.ins_exp_dt=b.ins_exp_dt \n"+
				" ) h, \n"+
				" ins_com j, fee f, users g \n"+
				" where \n"+
				" nvl(a.use_yn,'Y')='Y' \n"+
				" and nvl(b.prepare,'0') not in ('4','5') \n"+
				" and a.car_mng_id=b.car_mng_id \n"+
				" and a.rent_l_cd=c.rent_l_cd \n"+
				" and c.car_id=d.car_id and c.car_seq=d.car_seq \n"+
				" and d.car_comp_id=e.code \n"+
				" and b.fuel_kd=e2.nm_cd \n"+
				" and a.client_id=o.client_id \n"+
				" and b.car_ext =hh.nm_cd \n"+
				" and a.car_mng_id=h.car_mng_id(+) \n"+
				" and h.ins_com_id=j.ins_com_id(+) \n"+
				" and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd and f.rent_st='1' \n"+
				" and a.rent_mng_id=jj.rent_mng_id(+) and a.rent_l_cd=jj.rent_l_cd(+) \n"+
				" and nvl(a.mng_id,a.bus_id2)=g.user_id"+
				" ";

		query += " order by d.jg_code";

//System.out.println("[AdminDatabase:getMasterCarComAcarExcelListAll]\n"+query);
		
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
			System.out.println("[AdminDatabase:getMasterCarComAcarExcelListAll]\n"+e);
			System.out.println("[AdminDatabase:getMasterCarComAcarExcelListAll]\n"+query);
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
