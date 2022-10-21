/**
 * 중고차리스 견적
 * @ create date : 2008. 10. 6
 */
package acar.used_car;

import java.util.*;
import java.sql.*;
import acar.util.*;
import java.io.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.UnknownDataException;
import acar.exception.DatabaseException;

public class UsedCarDatabase {

    private static UsedCarDatabase instance;
    private DBConnectionManager connMgr;   
    // Pool로 부터 Connection 객체를 가져올때 사용하는 Pool Name 
    private final String DATA_SOURCE = "acar"; 
 
    // 싱글톤 클래스로 구현 
    // 생성자를 private 로 선언
    public static synchronized UsedCarDatabase getInstance() throws DatabaseException {
        if (instance == null)
            instance = new UsedCarDatabase();
        return instance;
    }
    
    private UsedCarDatabase() throws DatabaseException {
        connMgr = DBConnectionManager.getInstance();
    }

    /**
	 *	제조사 리스트
	 */
	public Vector getCarCompList(String app_st) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select * from CODE where c_st='0001'";

		if(!app_st.equals("")) query += " and app_st='"+app_st+"'";


		try {
		    pstmt = con.prepareStatement(query);
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
			System.out.println("[UsedCarDatabase:getCarCompList]"+e);
			System.out.println("[UsedCarDatabase:getCarCompList]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

    /**
	 *	차종 리스트
	 */
	public Vector getCarNmList(String car_comp_id) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select b.code as code, b.car_nm as name"+
				" from (select car_comp_id, car_cd from car_nm where car_b_p>0 group by car_comp_id, car_cd) a, car_mng b"+
				" where a.car_comp_id=? and a.car_comp_id=b.car_comp_id and a.car_cd=b.code"+
				" order by b.ab_nm, b.code ";

		try {
		    pstmt = con.prepareStatement(query);
			pstmt.setString(1, car_comp_id);
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
			System.out.println("[UsedCarDatabase:getCarNmList]"+e);
			System.out.println("[UsedCarDatabase:getCarNmList]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

    /**
	 *	엔진분류 리스트
	 */
	public Vector getJgCodeList(String car_comp_id, String car_cd) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.jg_code as code, max(b.cars) name "+
				" from CAR_NM a, esti_jg_var b "+
				" where a.car_comp_id=? and a.car_cd=? and a.car_b_p>0 and a.jg_code=b.sh_code "+
				" group by a.jg_code order by a.jg_code";

		try {
		    pstmt = con.prepareStatement(query);
			pstmt.setString(1, car_comp_id);
			pstmt.setString(2, car_cd);
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
			System.out.println("[UsedCarDatabase:getJgCodeList]"+e);
			System.out.println("[UsedCarDatabase:getJgCodeList]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

    /**
	 *	신차등록월 리스트
	 */
	public Vector getCarBDtList(String car_comp_id, String car_cd, String jg_code) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select substr(a.car_b_dt,1,6) as code, substr(substr(a.car_b_dt,1,6),1,4)||'년'||substr(substr(a.car_b_dt,1,6),5,2)||'월' as name "+
				" from CAR_NM a"+
				" where a.car_comp_id=? and a.car_cd=? and a.jg_code=? and a.car_b_p>0 "+
				" group by substr(a.car_b_dt,1,6) order by substr(a.car_b_dt,1,6)";

		try {
		    pstmt = con.prepareStatement(query);
			pstmt.setString(1, car_comp_id);
			pstmt.setString(2, car_cd);
			pstmt.setString(3, jg_code);
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
			System.out.println("[UsedCarDatabase:getCarBDtList]"+e);
			System.out.println("[UsedCarDatabase:getCarBDtList]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

    /**
	 *	세부모델 리스트
	 */
	public Vector getCarIdList(String car_comp_id, String car_cd, String jg_code, String car_b_dt) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		String car_e_dt = "nvl(to_char(to_date(b.car_b_dt,'YYYYMMDD')-1,'YYYYMMDD'),'99999999')";

		query = " select a.*, "+car_e_dt+" as car_e_dt"+
				" from car_nm a, car_nm b"+
				" where a.car_comp_id='"+car_comp_id+"' and a.car_cd='"+car_cd+"' and a.jg_code='"+jg_code+"' and a.car_b_p > 0 and a.car_b_dt > '20031231' "+
				" and a.car_id=b.car_id(+) and lpad(to_number(a.car_seq)+1,2,'0')=b.car_seq(+)";

		if(car_b_dt.length() == 6)	query += " and '"+car_b_dt+"' between substr(a.car_b_dt,1,6) and substr("+car_e_dt+",1,6)";
		if(car_b_dt.length() == 4)	query += " and '"+car_b_dt+"' between substr(a.car_b_dt,1,4) and substr("+car_e_dt+",1,4)";

		query += " order by a.car_b_dt, a.car_b_p";


		try {
		    pstmt = con.prepareStatement(query);
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
			System.out.println("[UsedCarDatabase:getCarIdList]"+e);
			System.out.println("[UsedCarDatabase:getCarIdList]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}


}
