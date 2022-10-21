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
	 *	���ǵ����Ʈ �����ڷ�
	 */
	public Vector SpeedMateExcelList(String s_kd, String st_dt, String end_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		

		query = " SELECT  '201009000211' AS ����ID, u.sk_code AS ����ID, '2010112022' AS ������ID, "+
				" x.SP_CODE AS ����ID, b.car_no ������ȣ, "+
				" decode( b.fuel_kd, '1', '210001', '2', '�ֹ���(����)', '3', '210003', '4', '210002',  '5', '210004', '6', '�ֹ���(����)+LPG���','7','210005', '8','210005','9','210006','10','210005' ) ���ᱸ���ڵ�, "+
				" decode( d.auto_yn, 'Y', '208002', decode( sign( instr( c.opt, '�ڵ����ӱ�' )), 1, '208002', '208001' )) ���ӱ������ڵ�, substr( b.init_reg_dt, 0, 6 ) AS ���ĳ��, "+
				" u.sk_code sk_code, u.user_nm �����, u.user_m_tel ����ó, decode(a.car_st,'2','����',DECODE(nvl( a.use_yn, 'Y' ), 'Y','�ű�','N','����') ) AS ���� "+
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
	 *	���ǵ����Ʈ �����ڷ� > ��ü �߰� 2018.03.23
	 */
	public Vector SpeedMateExcelList2(String s_kd, String st_dt, String end_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = "select aa.*, sf.dly_count from ("+
				" select  '201009000211' as ����ID, u.sk_code as ����ID, '2010112022' as ������ID, "+
				" x.SP_CODE AS ����ID, b.car_no ������ȣ, "+
				" decode( b.fuel_kd, '1', '210001', '2', '�ֹ���(����)', '3', '210003', '4', '210002',  '5', '210004', '6', '�ֹ���(����)+LPG���','7','210005', '8','210005','9','210006','10','210005' ) ���ᱸ���ڵ�, "+
				" decode( d.auto_yn, 'Y', '208002', decode( sign( instr( c.opt, '�ڵ����ӱ�' )), 1, '208002', '208001' )) ���ӱ������ڵ�, substr( b.init_reg_dt, 0, 6 ) as ���ĳ��, "+
				" u.sk_code sk_code, u.user_nm �����, u.user_m_tel ����ó, decode(a.car_st,'2','����',DECODE(nvl( a.use_yn, 'Y' ), 'Y','�ű�','N','����') ) as ����, "+
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
	 *	���ǵ����Ʈ �����ڷ� //����Ʈ ������ ����. 2012.12.13
	 */
	public Vector SpeedMateExcelList_re(String s_kd, String st_dt, String end_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT '201009000211' AS ����ID, u.sk_code AS ����ID, '2010112022' AS ������ID, x.SP_CODE AS ����ID, b.car_no ������ȣ, "+
		        " e2.nm as ����, "+
				" decode( b.fuel_kd, '1', '210001', '2', '�ֹ���(����)', '3', '210003', '4', '210002',  '5', '210004', '6', '�ֹ���(����)+LPG���','7','210005', '8','210005','9','210006','10','210005' ) ���ᱸ���ڵ�, "+
				" decode( d.auto_yn, 'Y', '208002', decode( sign( instr( c.opt, '�ڵ����ӱ�' )), 1, '208002', '208001' )) ���ӱ������ڵ�, substr( b.init_reg_dt, 0, 6 ) AS ���ĳ��, "+
				" b.car_nm ����, d.car_name ����, e.nm as ����, NVL(v.tot_dist,0) AS ������Ÿ�,  "+
				" b.init_reg_dt AS ����, decode( d.auto_yn, 'Y', '����', decode( sign( instr( c.opt, '�ڵ����ӱ�' )), 1, '����', '����' )) ���ӱ�, u.sk_code sk_code, u.user_nm �����, u.user_m_tel ����ó, decode(a.car_st,'2','����',DECODE(nvl( a.use_yn, 'Y' ), 'Y','�ű�','N','����') ) AS ���� "+
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
	 *	���ǵ����Ʈ �����ڷ� // ����Ʈ ������ ���� 2012.12.13 > ��ü �߰� 2018.03.21
	 */
	public Vector SpeedMateExcelList_re2(String s_kd, String st_dt, String end_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT aa.*, sf.dly_count "+
				" FROM   ( "+ 
				"          SELECT '201009000211' AS ����ID, u.sk_code AS ����ID, '2010112022' AS ������ID, x.SP_CODE AS ����ID, b.car_no ������ȣ, "+
				"                 e2.nm as ����, "+
				"                 decode( b.fuel_kd, '1', '210001', '2', '�ֹ���(����)', '3', '210003', '4', '210002',  '5', '210004', '6', '�ֹ���(����)+LPG���','7','210005', '8','210005','9','210006','10','210005' ) ���ᱸ���ڵ�, "+
				"                 decode( d.auto_yn, 'Y', '208002', decode( sign( instr( c.opt, '�ڵ����ӱ�' )), 1, '208002', '208001' )) ���ӱ������ڵ�, substr( b.init_reg_dt, 0, 6 ) AS ���ĳ��, "+
				"                 b.car_nm ����, d.car_name ����, e.nm as ����, NVL(v.tot_dist,0) AS ������Ÿ�,  "+
				"                 b.init_reg_dt AS ����, decode( d.auto_yn, 'Y', '����', decode( sign( instr( c.opt, '�ڵ����ӱ�' )), 1, '����', '����' )) ���ӱ�, u.sk_code sk_code, u.user_nm �����, u.user_m_tel ����ó, "+
				"                 decode(a.car_st,'2','����','4','����Ʈ',DECODE(nvl( a.use_yn, 'Y' ), 'Y','�ű�','N','����') ) AS ����, "+
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
	 *	�Ｚ�ִ�ī���� �����ڷ�
	 */
	public Vector AnycarExcelList(String s_kd, String st_dt, String end_dt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = " SELECT b.car_no ������ȣ, e2.nm as ����, "+
				" b.car_nm ����, d.car_name ����, e.nm as ����, NVL(v.tot_dist,0) AS ������Ÿ�,  "+
				" b.init_reg_dt AS ����, decode( d.auto_yn, 'Y', '����', decode( sign( instr( c.opt, '�ڵ����ӱ�' )), 1, '����', '����' )) ���ӱ�, u.user_nm �����, u.user_m_tel ����ó, decode(a.car_st,'2','����',DECODE(nvl( a.use_yn, 'Y' ), 'Y','�ű�','N','����') ) AS ���� "+
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
		
		query = " SELECT b.car_no ������ȣ, e2.nm as ����, "+
				" b.car_nm ����, d.car_name ����, e.nm as ����, v.tot_dist ������Ÿ�,  "+
				" b.init_reg_dt AS ����, decode( d.auto_yn, 'Y', '����', decode( sign( instr( c.opt, '�ڵ����ӱ�' )), 1, '����', '����' )) ���ӱ�, u.user_nm �����, u.user_m_tel ����ó  "+
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
	 *	���ǵ����Ʈ ����ǰ�� �ڷ�
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
	 *	����¥ - working day ����
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
	        sResult = cstmt.getString(1); // �����
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
	 *	�Ｚ�ִ�ī���� �����ڷ�
	 */
	public Vector getMasterCarComAcarExcelList()
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = " select decode(nvl(b.m1_chk, ''),'1','��û',' ') ��û, \n"+
				" '���' ����, b.init_reg_dt �������, b.car_no ������ȣ, b.car_nm||' '||d.car_name ����, replace(e.nm,'�ڵ���','') ������, substr(b.init_reg_dt,1,4) as ����, \n"+
				" decode(d.auto_yn,'Y','����',decode(sign(instr(c.opt,'�ڵ����ӱ�')),1,'����','����')) �̼�, \n"+
				" e2.nm as ����, \n"+
				" o.firm_nm ��, \n"+
				" nvl(o.o_tel,o.con_agnt_o_tel) �繫��, \n"+
				" nvl(o.m_tel,o.con_agnt_m_tel) �޴���, \n"+
				" jj.mgr_m_tel  �ǿ�����, \n"+
				" o.o_addr �ּ�, \n"+
				" o.CON_AGNT_EMAIL �̸���, \n"+
				" j.ins_com_nm �����, h.ins_start_dt||'~'||h.ins_exp_dt �뿩�Ⱓ, \n"+
				" '�ڹ������ɿ��� ���� �ݾ�' ���ι��, \n"+
				" decode(h.vins_pcp_kd,'1','����','2','����') ���ι��, \n"+
				" decode(h.vins_gcp_kd,'1','3000����','2','1500����',  '3','1���',   '4','5000����','5','1000����','�̰���') �빰���, \n"+
				" decode(h.vins_bacdt_kd,'1','3���',   '2','1��5õ����','3','3000����','4','1500����','5','5000����','6','1���','�̰���') �ڱ��ü���_������, \n"+
				" decode(h.vins_bacdt_kc2,'1','3���',   '2','1��5õ����','3','3000����','4','1500����','5','5000����','6','1���','�̰���') �ڱ��ü���_�λ�, \n"+
				" decode(h.vins_cacdt_car_amt,0,'',h.vins_cacdt_car_amt||'����') ��������, \n"+
				" decode(h.vins_cacdt_me_amt,0,'',h.vins_cacdt_me_amt||'����') �����ڱ�δ��, \n"+
				" decode(h.vins_canoisr_amt,0,'','����') ������, \n"+
				" decode(h.car_use,'1','������','2','������') ��������, \n"+
				" decode(h.age_scp,'1','21���̻�','2','26���̻�','3','��������','4','24���̻�') ���ɹ���, \n"+
				" decode(h.air_ds_yn,'Y',1,0)+decode(h.air_as_yn,'Y',1,0) �����, \n"+
				" h.con_f_nm �Ǻ�����, b.init_reg_dt ���ʵ����, hh.nm �������, \n"+
				" decode(f.rent_way,'1','�Ϲݽ�','�⺻��') �뿩���, g.user_nm ���������, g.user_m_tel ����ó \n"+
				" from cont a, car_reg b, car_etc c, car_nm d, client o, \n"+
				" (select * from car_mgr where mgr_st='�����̿���') jj , (select * from code where c_st='0032' and code <> '0000'  ) hh ,  \n"+
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
	 *	�Ｚ�ִ�ī���� �����ڷ�
	 */
	public Vector getMasterCarComAcarExcelList(String s_kd, String st_dt, String end_dt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = " select '1' gg, decode(nvl(b.m1_chk, ''),'1','��û',' ') ��û, \n"+
				" '���' ����, b.init_reg_dt �������,  b.car_no ������ȣ, b.car_nm||' '||d.car_name ����, replace(e.nm,'�ڵ���','') ������, substr(b.init_reg_dt,1,4) as ����, \n"+
				" decode(d.auto_yn,'Y','����',decode(sign(instr(c.opt,'�ڵ����ӱ�')),1,'����','����')) �̼�, \n"+
				" e2.nm as ����, \n"+
				" o.firm_nm ��, \n"+
				" nvl(o.o_tel,o.con_agnt_o_tel) �繫��, \n"+
				" nvl(o.m_tel,o.con_agnt_m_tel) �޴���, \n"+
				" jj.mgr_m_tel  �ǿ�����, \n"+
				" o.o_addr �ּ�, \n"+
				" o.CON_AGNT_EMAIL �̸���, \n"+
				" j.ins_com_nm �����, h.ins_start_dt||'~'||h.ins_exp_dt �뿩�Ⱓ, \n"+
				" '�ڹ������ɿ��� ���� �ݾ�' ���ι��, \n"+
				" decode(h.vins_pcp_kd,'1','����','2','����') ���ι��, \n"+
				" decode(h.vins_gcp_kd,'1','3000����','2','1500����',  '3','1���',   '4','5000����','5','1000����','�̰���') �빰���, \n"+
				" decode(h.vins_bacdt_kd,'1','3���',   '2','1��5õ����','3','3000����','4','1500����','5','5000����','6','1���','�̰���') �ڱ��ü���_������, \n"+
				" decode(h.vins_bacdt_kc2,'1','3���',   '2','1��5õ����','3','3000����','4','1500����','5','5000����','6','1���','�̰���') �ڱ��ü���_�λ�, \n"+
				" decode(h.vins_cacdt_car_amt,0,'',h.vins_cacdt_car_amt||'����') ��������, \n"+
				" decode(h.vins_cacdt_me_amt,0,'',h.vins_cacdt_me_amt||'����') �����ڱ�δ��, \n"+
				" decode(h.vins_canoisr_amt,0,'','����') ������, \n"+
				" decode(h.car_use,'1','������','2','������') ��������, \n"+
				" decode(h.age_scp,'1','21���̻�','2','26���̻�','3','��������','4','24���̻�') ���ɹ���, \n"+
				" decode(h.air_ds_yn,'Y',1,0)+decode(h.air_as_yn,'Y',1,0) �����, \n"+
				" h.con_f_nm �Ǻ�����, b.init_reg_dt ���ʵ����, hh.nm  �������, \n"+
				" decode(f.rent_way,'1','�Ϲݽ�','�⺻��') �뿩���, g.user_nm ���������, g.user_m_tel ����ó \n"+
				" from cont a, car_reg b, car_etc c, car_nm d, client o, \n"+
				" (select * from car_mgr where mgr_st='�����̿���') jj ,(select * from code where c_st='0032' and code <> '0000'  ) hh , \n"+
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

		query += " select '2' gg, decode(nvl(b.m1_chk, ''),'1','��û',' ') ��û, \n"+
				" '�Ű�' ����, s.jan_pr_dt �������, b.car_no ������ȣ, b.car_nm||' '||d.car_name ����, replace(e.nm,'�ڵ���','') ������, substr(b.init_reg_dt,1,4) as ����, \n"+
				" decode(d.auto_yn,'Y','����',decode(sign(instr(c.opt,'�ڵ����ӱ�')),1,'����','����')) �̼�, \n"+
				" e2.nm as ����, \n"+
				" o.firm_nm ��, \n"+
				" nvl(o.o_tel,o.con_agnt_o_tel) �繫��, \n"+
				" nvl(o.m_tel,o.con_agnt_m_tel) �޴���, \n"+
				" jj.mgr_m_tel  �ǿ�����, \n"+
				" o.o_addr �ּ�, \n"+
				" o.CON_AGNT_EMAIL �̸���, \n"+
				" j.ins_com_nm �����, h.ins_start_dt||'~'||h.ins_exp_dt �뿩�Ⱓ, \n"+
				" '�ڹ������ɿ��� ���� �ݾ�' ���ι��, \n"+
				" decode(h.vins_pcp_kd,'1','����','2','����') ���ι��, \n"+
				" decode(h.vins_gcp_kd,'1','3000����','2','1500����',  '3','1���',   '4','5000����','5','1000����','�̰���') �빰���, \n"+
				" decode(h.vins_bacdt_kd,'1','3���',   '2','1��5õ����','3','3000����','4','1500����','5','5000����','6','1���','�̰���') �ڱ��ü���_������, \n"+
				" decode(h.vins_bacdt_kc2,'1','3���',   '2','1��5õ����','3','3000����','4','1500����','5','5000����','6','1���','�̰���') �ڱ��ü���_�λ�, \n"+
				" decode(h.vins_cacdt_car_amt,0,'',h.vins_cacdt_car_amt||'����') ��������, \n"+
				" decode(h.vins_cacdt_me_amt,0,'',h.vins_cacdt_me_amt||'����') �����ڱ�δ��, \n"+
				" decode(h.vins_canoisr_amt,0,'','����') ������, \n"+
				" decode(h.car_use,'1','������','2','������') ��������, \n"+
				" decode(h.age_scp,'1','21���̻�','2','26���̻�','3','��������','4','24���̻�') ���ɹ���, \n"+
				" decode(h.air_ds_yn,'Y',1,0)+decode(h.air_as_yn,'Y',1,0) �����, \n"+
				" h.con_f_nm �Ǻ�����, b.init_reg_dt ���ʵ����, hh.nm �������, \n"+
				" decode(f.rent_way,'1','�Ϲݽ�','�⺻��') �뿩���, g.user_nm ���������, g.user_m_tel ����ó \n"+
				" from cont a, car_reg b, car_etc c, car_nm d, client o, \n"+
				" (select * from car_mgr where mgr_st='�����̿���') jj ,(select * from code where c_st='0032' and code <> '0000'  ) hh , \n"+
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


		query += " select '3' gg, decode(nvl(b.m1_chk, ''),'1','��û',' ') ��û, \n"+
				"  '�˻�' ����, case when b.m1_chk ='1' then b.m1_dt else ' ' end �������,  b.car_no ������ȣ, b.car_nm||' '||d.car_name ����, replace(e.nm,'�ڵ���','') ������, substr(b.init_reg_dt,1,4) as ����, \n"+
				" decode(d.auto_yn,'Y','����',decode(sign(instr(c.opt,'�ڵ����ӱ�')),1,'����','����')) �̼�, \n"+
				" e2.nm as ����, \n"+
				" o.firm_nm ��, \n"+
				" nvl(o.o_tel,o.con_agnt_o_tel) �繫��, \n"+
				" nvl(o.m_tel,o.con_agnt_m_tel) �޴���, \n"+
				" jj.mgr_m_tel  �ǿ�����, \n"+
				" o.o_addr �ּ�, \n"+
				" o.CON_AGNT_EMAIL �̸���, \n"+
				" j.ins_com_nm �����, h.ins_start_dt||'~'||h.ins_exp_dt �뿩�Ⱓ, \n"+
				" '�ڹ������ɿ��� ���� �ݾ�' ���ι��, \n"+
				" decode(h.vins_pcp_kd,'1','����','2','����') ���ι��, \n"+
				" decode(h.vins_gcp_kd,'1','3000����','2','1500����',  '3','1���',   '4','5000����','5','1000����','�̰���') �빰���, \n"+
				" decode(h.vins_bacdt_kd,'1','3���',   '2','1��5õ����','3','3000����','4','1500����','5','5000����','6','1���','�̰���') �ڱ��ü���_������, \n"+
				" decode(h.vins_bacdt_kc2,'1','3���',   '2','1��5õ����','3','3000����','4','1500����','5','5000����','6','1���','�̰���') �ڱ��ü���_�λ�, \n"+
				" decode(h.vins_cacdt_car_amt,0,'',h.vins_cacdt_car_amt||'����') ��������, \n"+
				" decode(h.vins_cacdt_me_amt,0,'',h.vins_cacdt_me_amt||'����') �����ڱ�δ��, \n"+
				" decode(h.vins_canoisr_amt,0,'','����') ������, \n"+
				" decode(h.car_use,'1','������','2','������') ��������, \n"+
				" decode(h.age_scp,'1','21���̻�','2','26���̻�','3','��������','4','24���̻�') ���ɹ���, \n"+
				" decode(h.air_ds_yn,'Y',1,0)+decode(h.air_as_yn,'Y',1,0) �����, \n"+
				" h.con_f_nm �Ǻ�����, b.init_reg_dt ���ʵ����, hh.nm �������, \n"+
				" decode(f.rent_way,'1','�Ϲݽ�','�⺻��') �뿩���, g.user_nm ���������, g.user_m_tel ����ó \n"+
				" from cont a, car_reg b, car_etc c, car_nm d, client o, \n"+
				" (select * from car_mgr where mgr_st='�����̿���') jj ,(select * from code where c_st='0032' and code <> '0000'  ) hh , \n"+
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
	 *	�Ｚ�ִ�ī���� �����ڷ�
	 */
	public Vector getMasterCarComAcarExcelListAll()
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = " select decode(nvl(b.m1_chk, ''),'1','��û',' ') ��û, \n"+
				" '���' ����, b.init_reg_dt �������, b.car_no ������ȣ, b.car_nm||' '||d.car_name ����, replace(e.nm,'�ڵ���','') ������, substr(b.init_reg_dt,1,4) as ����, \n"+
				" decode(d.auto_yn,'Y','����',decode(sign(instr(c.opt,'�ڵ����ӱ�')),1,'����','����')) �̼�, \n"+
				" e2.nm as ����, \n"+
				" o.firm_nm ��, \n"+
				" nvl(o.o_tel,o.con_agnt_o_tel) �繫��, \n"+
				" nvl(o.m_tel,o.con_agnt_m_tel) �޴���, \n"+
				" jj.mgr_m_tel  �ǿ�����, \n"+
				" o.o_addr �ּ�, \n"+
				" o.CON_AGNT_EMAIL �̸���, \n"+
				" j.ins_com_nm �����, h.ins_start_dt||'~'||h.ins_exp_dt �뿩�Ⱓ, \n"+
				" '�ڹ������ɿ��� ���� �ݾ�' ���ι��, \n"+
				" decode(h.vins_pcp_kd,'1','����','2','����') ���ι��, \n"+
				" decode(h.vins_gcp_kd,'1','3000����','2','1500����',  '3','1���',   '4','5000����','5','1000����','�̰���') �빰���, \n"+
				" decode(h.vins_bacdt_kd,'1','3���',   '2','1��5õ����','3','3000����','4','1500����','5','5000����','6','1���','�̰���') �ڱ��ü���_������, \n"+
				" decode(h.vins_bacdt_kc2,'1','3���',   '2','1��5õ����','3','3000����','4','1500����','5','5000����','6','1���','�̰���') �ڱ��ü���_�λ�, \n"+
				" decode(h.vins_cacdt_car_amt,0,'',h.vins_cacdt_car_amt||'����') ��������, \n"+
				" decode(h.vins_cacdt_me_amt,0,'',h.vins_cacdt_me_amt||'����') �����ڱ�δ��, \n"+
				" decode(h.vins_canoisr_amt,0,'','����') ������, \n"+
				" decode(h.car_use,'1','������','2','������') ��������, \n"+
				" decode(h.age_scp,'1','21���̻�','2','26���̻�','3','��������','4','24���̻�') ���ɹ���, \n"+
				" decode(h.air_ds_yn,'Y',1,0)+decode(h.air_as_yn,'Y',1,0) �����, \n"+
				" h.con_f_nm �Ǻ�����, b.init_reg_dt ���ʵ����,  hh.nm �������, \n"+
				" decode(f.rent_way,'1','�Ϲݽ�','�⺻��') �뿩���, g.user_nm ���������, g.user_m_tel ����ó \n"+
				" from cont a, car_reg b, car_etc c, car_nm d, client o, \n"+
				" (select * from car_mgr where mgr_st='�����̿���') jj ,(select * from code where c_st='0032' and code <> '0000'  ) hh , \n"+
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
