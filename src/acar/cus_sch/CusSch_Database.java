/**
 * 고객지원 -> 스케쥬관리
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2004. 8. 17.
 * @ last modify date : 
 */
package acar.cus_sch;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;
import acar.exception.DatabaseException;
import acar.exception.DataSourceEmptyException;
import acar.common.*;
import acar.cus0402.*;

public class CusSch_Database
{
	private Connection conn = null;
	public static CusSch_Database db;
	
	public static CusSch_Database getInstance()
	{
		if(CusSch_Database.db == null)
			CusSch_Database.db = new CusSch_Database();
		return CusSch_Database.db;
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

	/**
	*	거래처방문 조회 2004.08.17.
	*/
	public Cycle_vstBean[] getCycle_vst(String year, String mon, String user_id){
		getConnection();
		Collection<Cycle_vstBean> col = new ArrayList<Cycle_vstBean>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		Cus0402_Database c42_db = Cus0402_Database.getInstance();

		query = " SELECT a.client_id, a.seq, a.vst_dt, a.visiter, a.vst_title, a.vst_cont, a.vst_est_dt, a.vst_est_cont, a.update_id, a.update_dt  "+
				" FROM cycle_vst a,(SELECT DISTINCT client_id,mng_id FROM cont WHERE use_yn = 'Y') b "+
				" WHERE a.client_id = b.client_id "+
				" AND a.vst_est_dt like '"+year+mon+"%' "+
				" AND b.mng_id = '"+user_id+"' "+
				" UNION "+
				" SELECT a.client_id, a.seq, a.vst_dt, a.visiter, a.vst_title, a.vst_cont, a.vst_est_dt, a.vst_est_cont, a.update_id, a.update_dt  "+
				" FROM cycle_vst a,(SELECT DISTINCT client_id,mng_id FROM cont WHERE use_yn = 'Y') b "+
				" WHERE a.client_id = b.client_id "+
				" AND a.vst_dt like '"+year+mon+"%' "+
				" AND b.mng_id = '"+user_id+"' "+
				" UNION "+
				" SELECT a.client_id, a.seq, a.vst_dt, a.visiter, a.vst_title, a.vst_cont, a.vst_est_dt, a.vst_est_cont, a.update_id, a.update_dt "+
				" FROM cycle_vst a, client b "+
				" WHERE a.client_id = b.client_id "+
				" AND a.visiter = '"+user_id+"' "+
				" AND a.vst_dt like '"+year+mon+"%' ";

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();

			while(rs.next()){
				col.add(c42_db.makeCycle_vstBean(rs));
			}
			rs.close();
			pstmt.close();

		}catch(SQLException e){
			System.out.println("[CusSch_Database:getCycle_vst(String year, String mon, String user_id)]"+e);
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
	*	자동차 정비 스케쥴 조회 2004.08.17.
	 */
	public Vector getService(String year, String mon, String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query =	" select a.car_mng_id, a.serv_id, nvl(d.firm_nm, d.client_nm) firm_nm, b.car_no, a.serv_st, a.next_serv_dt, a.serv_dt "+
				" from service a, car_reg b, cont c, client d "+
				" where a.car_mng_id = b.car_mng_id "+
				" and b.car_mng_id = c.car_mng_id "+
				" and c.client_id = d.client_id "+
				" and c.use_yn = 'Y' "+
				" and a.serv_dt like '"+year+mon+"%' "+
				" and c.mng_id = '"+user_id+"' "+
				" union  "+
				" select a.car_mng_id, a.serv_id, nvl(d.firm_nm, d.client_nm) firm_nm, b.car_no, a.serv_st, a.next_serv_dt, a.serv_dt "+
				" from service a, car_reg b, cont c, client d "+
				" where a.car_mng_id = b.car_mng_id "+
				" and b.car_mng_id = c.car_mng_id "+
				" and c.client_id = d.client_id "+
				" and c.use_yn = 'Y' "+
				" and a.serv_dt like '"+year+mon+"%' "+
				" and a.checker = '"+user_id+"'"+
				" union  "+
				" select a.car_mng_id, a.serv_id, nvl(d.firm_nm, d.client_nm) firm_nm, b.car_no, a.serv_st, a.next_serv_dt, a.serv_dt "+
				" from service a, car_reg b, cont c, client d "+
				" where a.car_mng_id = b.car_mng_id "+
				" and b.car_mng_id = c.car_mng_id "+
				" and c.client_id = d.client_id "+
				" and c.use_yn = 'Y' "+
				" and a.next_serv_dt like '"+year+mon+"%' "+
				" and c.mng_id = '"+user_id+"' ";

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
			System.out.println("[CusSch_Database:getService(String year, String mon, String user_id)]"+e);
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
	*	자동차 정기검사/정기정밀검사 스케쥴 조회 2004.08.17.
	 */
	public Vector getCar_maint(String year, String mon, String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query ="SELECT nvl(c.firm_nm, c.client_nm) firm_nm, d.car_no, a.ckd, a.cmp, a.med, a.mcd "+
				" FROM v_car_maint a, cont b, client c, car_reg d "+
				" WHERE a.cmd = b.car_mng_id "+
				" AND b.client_id = c.client_id "+
				" AND a.cmd = d.car_mng_id "+
				" AND a.med like '"+year+mon+"%' "+
				" AND b.mng_id = '"+user_id+"'" +
				" and b.use_yn = 'Y' "+
				" union "+
				" select nvl(c.firm_nm, c.client_nm) firm_nm, d.car_no, a.che_kd CKD, a.che_comp CMP, a.che_dt MED, '' MCD "+
				" from car_maint a, cont b, client c, car_reg d "+
				" where a.car_mng_id = b.car_mng_id "+
				" and b.client_id = c.client_id "+
				" and a.car_mng_id = d.car_mng_id "+
				" and che_dt like '"+year+mon+"%' "+
				" and che_no='"+user_id+"' "+
				" and b.use_yn = 'Y' ";

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
			System.out.println("[CusSch_Database:getCar_maint(String year, String mon, String user_id)]"+e);
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

/*
*---------------------------관리부 스케쥴 전체 조회---------------------------------
*/
	/**
	*	거래처방문 조회 2004.08.18.
	*/
	public Cycle_vstBean[] getCycle_vstAll(String year, String mon, String day){
		getConnection();
		Collection<Cycle_vstBean> col = new ArrayList<Cycle_vstBean>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		Cus0402_Database c42_db = Cus0402_Database.getInstance();

		query = "SELECT a.client_id, a.seq, a.vst_dt, a.visiter, a.vst_title, a.vst_cont, a.vst_est_dt, a.vst_est_cont, a.update_dt, b.mng_id update_id"+
				" FROM cycle_vst a,(SELECT DISTINCT client_id,mng_id FROM cont WHERE use_yn = 'Y') b "+
				"  WHERE a.client_id = b.client_id "+
				"  AND a.vst_est_dt='"+year+mon+day+"' "+
				"  UNION "+
				" SELECT a.client_id, a.seq, a.vst_dt, a.visiter, a.vst_title, a.vst_cont, a.vst_est_dt, a.vst_est_cont, a.update_dt, b.mng_id update_id "+
				"  FROM cycle_vst a,(SELECT DISTINCT client_id,mng_id FROM cont WHERE use_yn = 'Y') b "+
				"  WHERE a.client_id = b.client_id "+
				"  AND a.vst_dt='"+year+mon+day+"' "+
				"  UNION "+
				"  SELECT a.client_id, a.seq, a.vst_dt, a.visiter, a.vst_title, a.vst_cont, a.vst_est_dt, a.vst_est_cont, a.update_dt, a.visiter update_id  "+
				"	 FROM cycle_vst a, client b "+
				"	 WHERE a.client_id = b.client_id "+
				"	 AND a.vst_dt = '"+year+mon+day+"' ";

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();

			while(rs.next()){
				col.add(c42_db.makeCycle_vstBean(rs));
			}
			rs.close();
			pstmt.close();

		}catch(SQLException e){
			System.out.println("[CusSch_Database:getCycle_vstAll(String year, String mon, String day)]"+e);
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
	*	자동차 정비 스케쥴 전체 조회 2004.08.18.
	 */
	public Vector getServiceAll(String year, String mon, String day){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query ="select a.car_mng_id, a.serv_id, nvl(d.firm_nm, d.client_nm) firm_nm, b.car_no, a.serv_st, a.next_serv_dt, a.serv_dt, c.mng_id "+
				" from service a, car_reg b, cont c, client d "+
				" where a.car_mng_id = b.car_mng_id "+
				" and b.car_mng_id = c.car_mng_id "+
				" and c.client_id = d.client_id "+
				" and c.use_yn = 'Y' "+
				" and a.next_serv_dt = '"+year+mon+day+"' "+
				" union  "+
				" select a.car_mng_id, a.serv_id, nvl(d.firm_nm, d.client_nm) firm_nm, b.car_no, a.serv_st, a.next_serv_dt, a.serv_dt, c.mng_id "+
				" from service a, car_reg b, cont c, client d "+
				" where a.car_mng_id = b.car_mng_id "+
				" and b.car_mng_id = c.car_mng_id "+
				" and c.client_id = d.client_id "+
				" and c.use_yn = 'Y' "+
				" and a.serv_dt = '"+year+mon+day+"' "+
				" union  "+
				" select a.car_mng_id, a.serv_id, nvl(d.firm_nm, d.client_nm) firm_nm, b.car_no, a.serv_st, a.next_serv_dt, a.serv_dt, a.checker MNG_ID "+
				" from service a, car_reg b, cont c, client d "+
				" where a.car_mng_id = b.car_mng_id "+
				" and b.car_mng_id = c.car_mng_id "+
				" and c.client_id = d.client_id "+
				" and c.use_yn = 'Y' "+
				" and a.serv_dt = '"+year+mon+day+"' ";

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
			System.out.println("[CusSch_Database:getServiceAll(String year, String mon, String day)]"+e);
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
	*	자동차 정기검사/정기정밀검사 전체 스케쥴 조회 2004.08.18.
	 */
	public Vector getCar_maintAll(String year, String mon, String day){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query ="SELECT nvl(c.firm_nm, c.client_nm) firm_nm, d.car_no, a.ckd, a.cmp, a.med, a.mcd, b.mng_id "+
				" FROM v_car_maint a, cont b, client c, car_reg d "+
				" WHERE a.cmd = b.car_mng_id "+
				" AND b.client_id = c.client_id "+
				" AND a.cmd = d.car_mng_id "+
				" AND a.med = '"+year+mon+day+"' "+
				" union "+
				" select nvl(c.firm_nm, c.client_nm) firm_nm, d.car_no, a.che_kd CKD, a.che_comp CMP, a.che_dt MED, '' MCD, a.che_no MNG_ID "+
				" from car_maint a, cont b, client c, car_reg d "+
				" where a.car_mng_id = b.car_mng_id "+
				" and b.client_id = c.client_id "+
				" and a.car_mng_id = d.car_mng_id "+
				" and che_dt='"+year+mon+day+"' "+
				" and b.use_yn = 'Y' ";

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
			System.out.println("[CusSch_Database:getCar_maintAll(String year, String mon, String day)]"+e);
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

	/****************************************************************************************
	*******************************************   smart
    ****************************************************************************************/
	
/**
	*	견젹업무
	 */
	public Vector getEstiUserHistory(String year, String mon, String day, String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		String reg_where1 = "";
		String reg_where2 = "";
		String reg_where3 = "";
		String reg_where4 = "";

		if(!user_id.equals("")){
			reg_where1 = " and a.reg_id='"+user_id+"'";
			reg_where2 = " and a.reg_id='"+user_id+"'";
			reg_where3 = " and b.user_id='"+user_id+"'";
			reg_where4 = " and reg_id='"+user_id+"'";
		}

		query = " "+
				" select * from ( "+
				//신차견적내기
				" select '1' sort, '신차견적' st, a.est_id, a.rent_dt, a.est_nm, a.mgr_nm,  a.est_tel, \n"+
				"        b.car_nm, c.car_name, \n"+
				"        decode(a.a_a,'11','리스일반식','12','리스기본식','21','렌트일반식','22','렌트기본식') a_a, \n"+
				"        a.a_b, \n"+
				"        (a.fee_s_amt+a.fee_v_amt) fee_amt, \n"+
				"        (nvl(a.gtr_amt,0)+nvl(a.pp_s_amt,0)+nvl(a.pp_v_amt,0)+nvl(a.ifee_s_amt,0)+nvl(a.ifee_v_amt,0)) pp_amt, \n"+
				"        '' note, a.reg_dt, a.reg_id \n"+
				" from   estimate a, car_mng b, car_nm c \n"+
				" where  a.rent_dt='"+year+mon+day+"' \n"+
					     reg_where1 +
				"        and substr(a.est_id,5,1) in ('F') and a.job='org' \n"+
				"        and a.car_comp_id=b.car_comp_id and a.car_cd=b.code \n"+
				"        and a.car_id=c.car_id and a.car_seq=c.car_seq \n"+
				//재리스견적내기
				" union "+
				" select '2' sort, '재리스견적' st, a.est_id, a.rent_dt, a.est_nm, d.car_no mgr_nm, a.est_tel, \n"+
				"        b.car_nm, c.car_name, \n"+
				"        decode(a.a_a,'11','리스일반식','12','리스기본식','21','렌트일반식','22','렌트기본식') a_a, \n"+
				"        a.a_b, \n"+
				"        (a.fee_s_amt+a.fee_v_amt) fee_amt, \n"+
				"        (nvl(a.gtr_amt,0)+nvl(a.pp_s_amt,0)+nvl(a.pp_v_amt,0)+nvl(a.ifee_s_amt,0)+nvl(a.ifee_v_amt,0)) pp_amt, \n"+
				"        '' note, a.reg_dt, a.reg_id \n"+
				" from   estimate a, car_mng b, car_nm c, car_reg d \n"+
				" where  a.rent_dt='"+year+mon+day+"' \n"+
					     reg_where2 +
				"        and substr(a.est_id,5,1) in ('S') "+
				"	     and a.est_st='1'\n"+
				"        and a.car_comp_id=b.car_comp_id and a.car_cd=b.code \n"+
				"        and a.car_id=c.car_id and a.car_seq=c.car_seq \n"+
				"        and a.mgr_nm=d.car_mng_id "+
				//스페셜견적+고객상담요청처리
				" union "+
				" select '3' sort, decode(a.est_st,'3','고객상담요청','스페셜견적') st, a.est_id, substr(b.reg_dt,1,8) as rent_dt, a.est_nm, a.est_agnt mgr_nm, a.est_tel, \n"+
				"        a.car_nm||decode(a.car_nm,'','',decode(a.car_nm2,'','','외')) car_nm, \n"+
				"        '' car_name, '' a_a, '' a_b, 0 fee_amt, 0 pp_amt, b.note, b.reg_dt, b.user_id as reg_id \n"+
				" from   esti_spe a, esti_m b \n"+
				" where  substr(b.reg_dt,1,8)='"+year+mon+day+"' \n"+
					     reg_where3 +
				"        and a.est_id=b.est_id \n"+
				"        and nvl(b.NOTE,' ') not in ('내용확인','부재중') \n"+
				//영업전화상담
				" union "+
				" select '4' sort, '영업상담결과' st, tel_mng_id est_id, substr(reg_dt,1,8) rent_dt, tel_firm_nm est_nm, tel_firm_mng mgr_nm, tel_firm_tel est_tel, \n"+
				"        tel_car as car_nm, \n"+
				"        '' car_name, '' a_a, '' a_b, 0 fee_amt, 0 pp_amt,  \n"+
				"        tel_note as note, to_char(reg_dt,'YYYYMMDDhh24miss') reg_dt, reg_id \n"+
				" from   biz_tel \n"+
				" where  to_char(reg_dt,'YYYYMMDD')='"+year+mon+day+"' \n"+
					     reg_where4 +
				" ) order by 1, reg_dt ";

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
			System.out.println("[CusSch_Database:getEstiUserHistory(String year, String mon, String day, String user_id)]"+e);
			System.out.println("[CusSch_Database:getEstiUserHistory(String year, String mon, String day, String user_id)]"+query);
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
	*	거래처방문 조회
	*/
	public Cycle_vstBean[] getCycle_vst(String year, String mon, String day, String user_id){
		getConnection();
		Collection<Cycle_vstBean> col = new ArrayList<Cycle_vstBean>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		Cus0402_Database c42_db = Cus0402_Database.getInstance();

				
		query = " "+
				//예정분-현재대여중
				" SELECT a.client_id, a.seq, a.vst_dt, a.visiter, a.vst_title, a.vst_cont, a.vst_est_dt, a.vst_est_cont, a.update_id, a.update_dt, a.vst_pur, a.sangdamja  "+
				" FROM   cycle_vst a, (SELECT client_id, mng_id FROM cont WHERE use_yn = 'Y' group by client_id,mng_id) b "+
				" WHERE  a.client_id = b.client_id "+
				"        AND a.vst_est_dt='"+year+mon+day+"' "+
				"        AND b.mng_id = '"+user_id+"' "+
				" UNION "+
				//방문분-현재대여중
				" SELECT a.client_id, a.seq, a.vst_dt, a.visiter, a.vst_title, a.vst_cont, a.vst_est_dt, a.vst_est_cont, a.update_id, a.update_dt, a.vst_pur, a.sangdamja  "+
				" FROM   cycle_vst a,(SELECT client_id, mng_id FROM cont WHERE use_yn = 'Y' group by client_id,mng_id) b "+
				" WHERE  a.client_id = b.client_id "+
				"        AND a.vst_dt='"+year+mon+day+"' "+
				"        AND b.mng_id = '"+user_id+"' "+
				//방문분 전부
				" UNION "+
				" SELECT a.client_id, a.seq, a.vst_dt, a.visiter, a.vst_title, a.vst_cont, a.vst_est_dt, a.vst_est_cont, a.update_id, a.update_dt, a.vst_pur, a.sangdamja "+
				" FROM   cycle_vst a, client b "+
				" WHERE  a.client_id = b.client_id "+
				"	     AND a.visiter = '"+user_id+"' "+
				"	     AND a.vst_dt = '"+year+mon+day+"' ";

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();

			while(rs.next()){
				col.add(c42_db.makeCycle_vstBean(rs));
			}
			rs.close();
			pstmt.close();

		}catch(SQLException e){
			System.out.println("[CusSch_Database:getCycle_vst(String year, String mon, String user_id)]"+e);
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
	*	자동차 정비 스케쥴 조회
	 */
	public Vector getService(String year, String mon, String day, String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query =	" "+
				//관리담당 정비
				" select a.car_mng_id, a.serv_id, nvl(d.firm_nm, d.client_nm) firm_nm, b.car_no, a.serv_st, a.next_serv_dt, a.serv_dt, c.rent_mng_id, c.rent_l_cd, c.client_id, c.r_site "+
				" from   service a, car_reg b, cont c, client d "+
				" where  a.serv_dt = '"+year+mon+day+"' "+
				" 		 and a.car_mng_id = b.car_mng_id "+
				" 		 and b.car_mng_id = c.car_mng_id "+
				" 		 and c.client_id = d.client_id "+
				" 		 and c.use_yn = 'Y' "+
				" 		 and c.mng_id = '"+user_id+"' "+
				" union  "+
				//점검자 정비
				" select a.car_mng_id, a.serv_id, nvl(d.firm_nm, d.client_nm) firm_nm, b.car_no, a.serv_st, a.next_serv_dt, a.serv_dt, c.rent_mng_id, c.rent_l_cd, c.client_id, c.r_site "+
				" from   service a, car_reg b, cont c, client d "+
				" where  a.serv_dt = '"+year+mon+day+"' "+
				"	     and a.car_mng_id = b.car_mng_id "+
				" 		 and a.car_mng_id = c.car_mng_id and a.rent_l_cd=c.rent_l_cd"+
				" 		 and c.client_id = d.client_id "+
				" 		 and a.checker = '"+user_id+"' and a.checker<>c.mng_id"+
				" union  "+
				//관리담당 예정
				" select a.car_mng_id, a.serv_id, nvl(d.firm_nm, d.client_nm) firm_nm, b.car_no, a.serv_st, a.next_serv_dt, a.serv_dt, c.rent_mng_id, c.rent_l_cd, c.client_id, c.r_site "+
				" from   service a, car_reg b, cont c, client d "+
				" where  a.next_serv_dt = '"+year+mon+day+"' "+
				"	     and a.car_mng_id = b.car_mng_id "+
				" 		 and a.car_mng_id = c.car_mng_id and a.rent_l_cd=c.rent_l_cd "+
				" 		 and c.client_id = d.client_id "+
				" 		 and c.mng_id = '"+user_id+"'";

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
			System.out.println("[CusSch_Database:getService(String year, String mon, String day, String user_id)]"+e);
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
	*	자동차 정기검사/정기정밀검사 스케쥴 조회
	 */
	public Vector getCar_maint(String year, String mon, String day, String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " "+
				//관리담당자
				" SELECT c.client_id, b.r_site, nvl(c.firm_nm, c.client_nm) firm_nm, d.car_no, a.ckd, a.cmp, a.med, a.mcd "+
				" FROM   v_car_maint a, cont b, client c, car_reg d "+
				" WHERE  a.med = '"+year+mon+day+"' "+
				"	     and a.cmd = b.car_mng_id "+
				"        AND b.client_id = c.client_id "+
				"        AND a.cmd = d.car_mng_id "+
				"        AND b.mng_id = '"+user_id+"'" +
				"        and b.use_yn = 'Y' "+
				//검사담당자
				" union "+
				" select c.client_id, b.r_site, nvl(c.firm_nm, c.client_nm) firm_nm, d.car_no, a.che_kd CKD, a.che_comp CMP, a.che_dt MED, '' MCD "+
				" from   car_maint a, cont b, client c, car_reg d "+
				" where  a.che_dt='"+year+mon+day+"' "+
				"	     and a.car_mng_id = b.car_mng_id "+
				"        and b.client_id = c.client_id "+
				"        and a.car_mng_id = d.car_mng_id "+
				"	     and a.che_no='"+user_id+"' "+
				"        and b.use_yn = 'Y' ";

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
			System.out.println("[CusSch_Database:getCar_maint(String year, String mon, String day, String user_id)]"+e);
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