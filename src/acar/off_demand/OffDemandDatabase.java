package acar.off_demand;

import java.sql.*;
import java.util.*;
import acar.util.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.DatabaseException;

public class OffDemandDatabase
{
	private static OffDemandDatabase instance;
    private DBConnectionManager connMgr;   
    // Pool로 부터 Connection 객체를 가져올때 사용하는 Pool Name 
    private final String DATA_SOURCE = "acar"; 
 
    // 싱글톤 클래스로 구현 
    // 생성자를 private 로 선언
	public static synchronized OffDemandDatabase getInstance() {
        if (instance == null)
            instance = new OffDemandDatabase();
        return instance;
    }
    
   	private OffDemandDatabase()  {
        connMgr = DBConnectionManager.getInstance();
    }
	
	



	/**
	 *	 리스트 조회
	 * 
	 */
	public Vector getDemandCarList2(String sDate, String eDate,String k) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		int a = AddUtil.parseInt(k);

		query = " select substr(assch_date, 1, "+a+") year, count(asset_code) cnt, sum(sale_amt) amt, TRUNC(sum(sale_amt)/1.1) s_amt  "+
				" from fassetmove where assch_type = '3' and assch_date BETWEEN '"+AddUtil.ChangeString(sDate)+"' AND '"+AddUtil.ChangeString(eDate)+"' "+
				" group by substr(assch_date, 1, "+a+")" +
				" ";

		query += " order by 1 ";


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
			System.out.println("[OffDemandDataBase:getDemandCarList2]"+e);
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


	public Vector getDemandCarList1(String sDate, String eDate, String k) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		int a = AddUtil.parseInt(k);

		query = " select substr(c.dlv_dt, 1, "+a+") year, count(c.car_mng_id) cnt, sum(E.car_fs_amt+E.car_fv_amt+E.sd_cs_amt+E.sd_cv_amt-E.dc_cs_amt-E.dc_cv_amt) amt, TRUNC(sum(E.car_fs_amt+E.car_fv_amt+E.sd_cs_amt+E.sd_cv_amt-E.dc_cs_amt-E.dc_cv_amt)/1.1) s_amt  "+
				" from cont C, client L, car_reg R, car_pur P, car_etc E, cls_cont s ,  "+
				" (select /*+ index(doc_settle DOC_SETTLE_IDX2  ) */ * from doc_settle where doc_st='4' and doc_step='3') d " +
				" where C.client_id = L.client_id AND " +
				" C.car_mng_id = R.car_mng_id(+) AND " +
				" C.rent_mng_id = P.rent_mng_id AND " +
				" C.rent_l_cd = P.rent_l_cd AND " +
				" C.rent_mng_id = E.rent_mng_id and " +
				" C.rent_l_cd = E.rent_l_cd AND " +
				" C.dlv_dt BETWEEN '"+AddUtil.ChangeString(sDate)+"' AND '"+AddUtil.ChangeString(eDate)+"' " +
				" and C.car_gu ='1'  " +
				" and C.rent_mng_id=S.rent_mng_id(+) and C.reg_dt=S.reg_dt(+) and S.rent_l_cd is null  " +
				" and C.rent_l_cd=d.doc_id " +
				" group by    substr(c.dlv_dt, 1, "+a+") " +
				" ";

		query += " order by 1 ";


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
			System.out.println("[OffDemandDataBase:getDemandCarList1]"+e);
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
	 *	 리스트 조회2
	 * 
	 */
	public Vector getDemandTermList2(String sDate,String eDate) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT COUNT(0) cnt, TRUNC(SUM((fee_s_amt*con_mon)+(fee_s_amt/30*con_day))) amt " +
				" FROM ( " +
				" SELECT b.rent_st, b.fee_s_amt, b.con_mon, c.con_day " +
				" from   cont a, fee b, FEE_etc c, cls_cont d " +
				" where a.car_st='4' " +
				" and a.client_id not in ('000228','000231') " +
				" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd " +
				" and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd AND b.RENT_ST=c.rent_st " +
				" and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+) " +
				" AND a.rent_start_dt < d.cls_dt " +
				" AND b.rent_start_dt BETWEEN '"+sDate+"' AND '"+eDate+"' " +
				" UNION all " +
				" SELECT b.rent_st, b.fee_s_amt, c.add_tm AS con_mon, '0' con_day " +
				" from   cont a, FEE b, fee_im c, cls_cont d " +
				" where a.car_st='4' " +
				" and a.client_id not in ('000228','000231') " +
				" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd " +
				" and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd AND b.RENT_ST=c.rent_st " +
				" and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+) " +
				" AND a.rent_start_dt < d.cls_dt " +
				" AND c.rent_start_dt BETWEEN '"+sDate+"' AND '"+eDate+"' " +
				" ) " +
				" ";


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
			System.out.println("[OffDemandDataBase:getDemandTermList2]"+e);
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


	public Vector getDemandTermList1(String sDate, String eDate) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT car_gu, COUNT(0), " +
				" count(CASE WHEN CON_MON BETWEEN 0  AND  6 THEN rent_l_cd end) mon_d6, " +
				" count(CASE WHEN CON_MON BETWEEN 7  AND 12 THEN rent_l_cd end) mon_d12, " +
				" count(CASE WHEN CON_MON BETWEEN 13 AND 24 THEN rent_l_cd end) mon_d24, " +
				" count(CASE WHEN CON_MON BETWEEN 25 AND 36 THEN rent_l_cd end) mon_d36, " +
				" count(CASE WHEN CON_MON BETWEEN 37 AND 48 THEN rent_l_cd end) mon_d48, " +
				" count(CASE WHEN CON_MON BETWEEN 49 AND 99 THEN rent_l_cd end) mon_d99, " +
				" TRUNC(SUM(CASE WHEN CON_MON BETWEEN 0  AND  6 THEN (fee_s_amt*con_mon)+pp_s_amt end)) amt_d6, " +
				" TRUNC(SUM(CASE WHEN CON_MON BETWEEN 7  AND 12 THEN (fee_s_amt*con_mon)+pp_s_amt end)) amt_d12, " +
				" TRUNC(SUM(CASE WHEN CON_MON BETWEEN 13 AND 24 THEN (fee_s_amt*con_mon)+pp_s_amt end)) amt_d24, " +
				" TRUNC(SUM(CASE WHEN CON_MON BETWEEN 25 AND 36 THEN (fee_s_amt*con_mon)+pp_s_amt end)) amt_d36, " +
				" TRUNC(SUM(CASE WHEN CON_MON BETWEEN 37 AND 48 THEN (fee_s_amt*con_mon)+pp_s_amt end)) amt_d48, " +
				" TRUNC(SUM(CASE WHEN CON_MON BETWEEN 49 AND 99 THEN (fee_s_amt*con_mon)+pp_s_amt end)) amt_d99 " +
				" FROM ( " +
				" SELECT a.car_gu, b.con_mon, a.rent_l_cd, b.fee_s_amt, b.pp_s_amt " +
				" from cont a, fee b, cls_cont c, cls_cont d, fee_etc h, (select rent_mng_id, rent_l_cd, cls_dt, cls_st, nvl(reg_dt,cls_dt) reg_dt from cls_cont where cls_st in ('4','5')) g  " +
				" where " +
				" a.car_st not in ('2','4') and a.client_id not in ('000228','000231') " +
				" and a.car_gu NOT IN('2') " +
				" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd " +
				" and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) and nvl(c.cls_st,'0') not in ('7','10') " +
				" and a.rent_mng_id=d.rent_mng_id(+) and a.reg_dt=d.reg_dt(+) " +
				" and b.rent_mng_id=h.rent_mng_id(+) and b.rent_l_cd=h.rent_l_cd(+) and b.rent_st=h.rent_st(+) " +
				" and a.rent_mng_id=g.rent_mng_id(+) and a.reg_dt=g.reg_dt(+) " +
				" and case when g.rent_l_cd is not null and a.reg_dt < nvl(to_char(h.reg_dt,'YYYYMMDD'),g.reg_dt)  then '' else g.rent_l_cd end is NULL  " +
				" AND decode(b.rent_st,'1',a.rent_dt,b.rent_dt) BETWEEN '"+sDate+"' AND '"+eDate+"' " +
				" AND b.RENT_ST = '1'" +
				" UNION all " +
				" SELECT '6' car_gu, b.con_mon, a.rent_l_cd, b.fee_s_amt, b.pp_s_amt  " +
				" from cont a, fee b, cls_cont c, cls_cont d, fee_etc h, (select rent_mng_id, rent_l_cd, cls_dt, cls_st, nvl(reg_dt,cls_dt) reg_dt from cls_cont where cls_st in ('4','5')) g   " +
				" where " +
				" a.car_st not in ('2','4') and a.client_id not in ('000228','000231') " +
				" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd " +
				" and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) and nvl(c.cls_st,'0') not in ('7','10') " +
				" and a.rent_mng_id=d.rent_mng_id(+) and a.reg_dt=d.reg_dt(+)  " +
				" and b.rent_mng_id=h.rent_mng_id(+) and b.rent_l_cd=h.rent_l_cd(+) and b.rent_st=h.rent_st(+) " +
				" and a.rent_mng_id=g.rent_mng_id(+) and a.reg_dt=g.reg_dt(+)  " +
				" and case when g.rent_l_cd is not null and a.reg_dt < nvl(to_char(h.reg_dt,'YYYYMMDD'),g.reg_dt)  then '' else g.rent_l_cd end is NULL " +
				" AND decode(b.rent_st,'1',a.rent_dt,b.rent_dt) BETWEEN '"+sDate+"' AND '"+eDate+"' " +
				" AND b.RENT_ST > '1' " +
				" UNION all " +
				" SELECT '6' car_gu, e.add_tm AS con_mon, a.rent_l_cd, b.fee_s_amt, 0 pp_s_amt  " +
				" from cont a, fee b, cls_cont c, cls_cont d, fee_etc h, (select rent_mng_id, rent_l_cd, cls_dt, cls_st, nvl(reg_dt,cls_dt) reg_dt from cls_cont where cls_st in ('4','5')) g, FEE_IM e  " +
				" where " +
				" a.car_st not in ('2','4') and a.client_id not in ('000228','000231') " +
				" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd " +
				" and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) and nvl(c.cls_st,'0') not in ('7','10') " +
				" and a.rent_mng_id=d.rent_mng_id(+) and a.reg_dt=d.reg_dt(+)  " +
				" and b.rent_mng_id=h.rent_mng_id(+) and b.rent_l_cd=h.rent_l_cd(+) and b.rent_st=h.rent_st(+) " +
				" and b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd and b.rent_st=e.rent_st " +
				" and a.rent_mng_id=g.rent_mng_id(+) and a.reg_dt=g.reg_dt(+)  " +
				" and case when g.rent_l_cd is not null and a.reg_dt < nvl(to_char(h.reg_dt,'YYYYMMDD'),g.reg_dt)  then '' else g.rent_l_cd end is NULL " +
				" AND decode(b.rent_st,'1',a.rent_dt,b.rent_dt) BETWEEN '"+sDate+"' AND '"+eDate+"' " +
				" ) " +
				" GROUP BY car_gu " +
				" ORDER BY DECODE(car_gu,'1',0,'0',1,2) " +
				" ";


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
			System.out.println("[OffDemandDataBase:getDemandTermList2]"+e);
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
	 *	 리스트 조회3
	 * 
	 */
	public Vector getDemandMcList2(String sDate,String eDate) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String mDate1 = AddUtil.subDataCut(sDate,4);
		String mDate2 = AddUtil.subDataCut(eDate,4);
		int cDate1 = AddUtil.parseInt(mDate1);
		int cDate2 = AddUtil.parseInt(mDate2);
		String subQuery = "";
		for(int i = cDate1 ; i < cDate2; i++){
			subQuery += ", '"+i+"1231' ";
		}

		query = " SELECT save_dt,  \n" +
				"  COUNT(DISTINCT DECODE(client_st,'1',client_id)) co_count,  COUNT(DECODE(client_st,'1',client_id)) co_car,  \n" +
				"  COUNT(DISTINCT DECODE(client_st,'1','',client_id)) no_count, COUNT(DECODE(client_st,'1','',client_id)) no_car \n" +
				" from  ( \n" +
				" SELECT    --DISTINCT   --있으면 거래처수, 없으면 차량대수   \n" +
				"  a.save_dt, e.client_st, a.client_id \n" +
				" FROM   STAT_RENT_MONTH a, CAR_REG b, FEE c, CLIENT e, \n" +
				"  (select a.car_mng_id,  \n" +
				"   a.asset_code, a.asset_name, a.get_date, \n" +
				"   a.deprf_yn,  \n" +
				"   decode(  a.deprf_yn , '5', 0, ya.get_amt + ya.book_dr - ya.book_cr - ya.jun_reser - ya.dep_amt ) jangbu   \n" +
				"  from   fassetma_bak2 a, ( select * from  fassetmove_bak2 where assch_type = '3' ) m,  \n" +
				"   ( select * from  fyassetdep_bak2 where gisu = (select max(gisu) from fyassetdep_bak2 )) ya \n" +
				"  where  a.asset_code = ya.asset_code  and a.asset_code = m.asset_code(+) " +
				"  and a.deprf_yn <> '6'  \n" +
				"  ) d,  \n" +
				"    CAR_ETC f, CAR_NM g  \n" +
				"  WHERE  a.save_dt IN ('"+AddUtil.ChangeString(sDate)+"'"+subQuery+", '"+AddUtil.ChangeString(eDate)+"') \n" +
				"  AND a.car_st NOT IN ('2')  and a.client_id<>'000228' \n" +
				"  AND a.car_mng_id=b.car_mng_id  \n" +
				"  and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd AND a.fee_rent_st=c.rent_st  \n" +
				"   AND a.client_id=e.client_id  \n" +
				"   AND a.car_mng_id=d.car_mng_id(+)  \n" +
				"   and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd  \n" +
				"   AND f.car_id=g.car_id AND f.car_seq=g.car_seq   \n" +
				"   ) \n" +
				"  GROUP BY save_dt \n" +
				"  ORDER BY save_dt \n" +
				" ";


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
			System.out.println("[OffDemandDataBase:getDemandMcList2]"+e);
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
	 *	 리스트 조회3
	 * 
	 */
	public Vector getDemandMcList3(String gubun,String sDate,String eDate) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String mDate1 = AddUtil.subDataCut(sDate,4);
		String mDate2 = AddUtil.subDataCut(eDate,4);
		int cDate1 = AddUtil.parseInt(mDate1);
		int cDate2 = AddUtil.parseInt(mDate2);
		String subQuery = "";
		for(int i = cDate1 ; i < cDate2; i++){
			subQuery += ", '"+i+"1231' ";
		}
		String subQuery2 = "";
		
		if(gubun.equals("1")) { //장기대여
			subQuery2 = " and a.car_st in ('1','3','5') ";
		}else if(gubun.equals("3")) { //렌트
			subQuery2 = " and a.car_st in ('1','5') and a.car_use='1' ";
		}else if(gubun.equals("4")) { //리스
			subQuery2 = " and a.car_st in ('3','5') and a.car_use='2'  ";
		}else if(gubun.equals("2")) { //월렌트
			subQuery2 = " and a.car_st = '4' ";
		}

		query = " SELECT save_dt,  \n" +
				"        COUNT(DISTINCT DECODE(client_st,'1',client_id)) co_count,    COUNT(DECODE(client_st,'1',client_id)) co_car,  \n" +
				"        COUNT(DISTINCT DECODE(client_st,'1','',client_id)) no_count, COUNT(DECODE(client_st,'1','',client_id)) no_car \n" +
				" from   ( \n" +
				"          SELECT \n" +
				"                 a.save_dt, a.client_id, nvl(a.client_st,b.client_st) client_st \n" +
				"          FROM   stat_rent_month a, client b, fee c, car_reg d \n" +				
				"          WHERE  a.save_dt IN ('"+AddUtil.ChangeString(sDate)+"'"+subQuery+", '"+AddUtil.ChangeString(eDate)+"') \n" +
				"                 AND a.car_st NOT IN ('2') and a.prepare not in ('4') and a.client_id<>'000228' \n" +
				                  subQuery2 +
				"                 AND a.car_mng_id=d.car_mng_id  \n" +
				"                 AND a.client_id=b.client_id  \n" +		
				"                 and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and a.fee_rent_st=c.rent_st \n" +
				"        ) \n" +
				"  GROUP BY save_dt \n" +
				"  ORDER BY save_dt \n" +
				" ";


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
			System.out.println("[getDemandMcList3]"+e);
			System.out.println("[getDemandMcList3]"+query);
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
	 *	 차입/상환현황
	 * 
	 */
	public Vector getDemandDebtStat() throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT o.init_year, "+
				"        COUNT(DECODE(o.allot_st||o.allot_yn,'차입진행중',o.rent_l_cd)) cnt_1,   "+
				"        sum(DECODE(o.allot_st||o.allot_yn,'차입진행중',o.fee_amt)) fee_amt_1, "+
				"        sum(DECODE(o.allot_st||o.allot_yn,'차입진행중',o.allot_amt)) allot_amt_1, "+
				"        COUNT(DECODE(o.allot_st||o.allot_yn,'차입종료',o.rent_l_cd)) cnt_2,   "+
				"        sum(DECODE(o.allot_st||o.allot_yn,'차입종료',o.fee_amt)) fee_amt_2, "+
				"        COUNT(DECODE(o.allot_st,'무차입',o.rent_l_cd)) cnt_3,   "+
				"        sum(DECODE(o.allot_st,'무차입',o.fee_amt)) fee_amt_3,      "+         
				"        COUNT(0) cnt,  "+
				"        SUM(o.fee_amt) fee_amt,  "+
				"        SUM(DECODE(o.allot_st||o.allot_yn,'차입진행중',o.allot_amt)) allot_amt "+
				" FROM "+
				" ( "+
				" SELECT a.RENT_L_CD, b.CAR_NO, b.CAR_NM, e.LEND_ID, e.RTN_SEQ, "+
				"        b.init_reg_dt, (c.fee_s_amt+c.fee_v_amt) fee_amt,  "+
				"        CASE WHEN e.lend_id IS NULL AND e.lend_prn = 0 THEN '무차입' ELSE '차입' END allot_st, "+
				"        CASE WHEN NVL(f.alt_rest,0)+NVL(h.alt_rest,0) >0 THEN '진행중' ELSE '종료' END allot_yn, "+
				"        NVL(e.ALT_AMT,0)+NVL(i.avg_alt_amt,0) AS allot_amt,         "+
				"        e.ALT_AMT, f.alt_rest, i.avg_alt_amt, h.alt_rest, "+
				"        SUBSTR(b.init_reg_dt,1,4) init_year "+
				" FROM   cont a, car_reg b, fee c, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) d, allot e, "+
				"        (SELECT car_mng_id, max(alt_rest) alt_rest FROM scd_alt_case WHERE pay_yn='0' GROUP BY car_mng_id) f, "+
				"        bank_rtn g, "+
				"        (SELECT lend_id, rtn_seq, max(alt_rest) alt_rest FROM scd_bank WHERE pay_yn='0' GROUP BY lend_id, rtn_seq) h, "+
				"        (SELECT a.lend_id, b.rtn_seq, MAX(a.alt_amt) alt_amt, COUNT(0) alt_cnt, TRUNC(MAX(a.alt_amt)/COUNT(0)) avg_alt_amt  "+
				"         FROM   bank_rtn a, allot b, cont c, (select car_mng_id, max(rent_l_cd) rent_l_cd from cont WHERE car_mng_id IS NOT NULL group by car_mng_id ) d  "+
				"         WHERE  a.lend_id=b.lend_id AND a.seq=b.rtn_seq AND b.rent_mng_id=c.rent_mng_id AND b.rent_l_cd=c.rent_l_cd "+
				"                AND c.car_mng_id=d.car_mng_id AND c.rent_l_cd=d.rent_l_cd  "+
				"         GROUP BY a.LEND_ID, b.rtn_seq "+
				"        ) i "+
				" WHERE  (a.use_yn='Y' or a.use_yn IS NULL)  "+
				"        AND a.car_mng_id=b.car_mng_id and nvl(b.prepare,'0') NOT IN ('4') "+
				"        AND a.rent_mng_id=c.rent_mng_id AND a.rent_l_cd=c.rent_l_cd  "+
				"        AND c.rent_mng_id=d.rent_mng_id AND c.rent_l_cd=d.rent_l_cd AND c.rent_st=d.rent_st  "+
				"        AND a.rent_mng_id=e.rent_mng_id AND a.rent_l_cd=e.rent_l_cd   "+
				"        AND a.car_mng_id=f.car_mng_id(+) "+
				"        AND e.lend_id=g.lend_id(+) AND e.rtn_seq=g.seq(+) "+
				"        AND g.lend_id=h.lend_id(+) AND g.seq=h.rtn_seq(+) "+
				"        AND g.lend_id=i.lend_id(+) AND g.seq=i.rtn_seq(+) "+
				" ) o "+
				" GROUP BY o.init_year "+
				" ORDER BY o.init_year desc " +
				" ";


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
			System.out.println("[OffDemandDataBase:getDemandDebtStat]"+e);
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
	
	//영업현황 2.매출형태
	public Vector getOffDemandStat1(String mode, String sDate, String eDate) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String mDate1 = AddUtil.subDataCut(sDate,4);
		String mDate2 = AddUtil.subDataCut(eDate,4);
		int cDate1 = AddUtil.parseInt(mDate1);
		int cDate2 = AddUtil.parseInt(mDate2);
		String subQuery = "";
		for(int i = cDate1 ; i < cDate2; i++){
			subQuery += ", '"+i+"1231' ";
		}

		//보유대수
		query = " SELECT a.save_dt, COUNT(0) cnt \r\n"
				+ "FROM   STAT_RENT_MONTH a, CAR_REG b \n" +				
				"  WHERE  a.save_dt IN ('"+AddUtil.ChangeString(sDate)+"'"+subQuery+", '"+AddUtil.ChangeString(eDate)+"') \n" +
				"  AND a.car_mng_id=b.car_mng_id\r\n"
				+ "AND nvl(a.prepare,'0') NOT IN ('4')  \r\n"
				+ "GROUP BY a.save_dt\r\n"
				+ "ORDER BY a.save_dt \n" +
				" ";
		

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
			System.out.println("[OffDemandDataBase:getOffDemandStat1]"+e);
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
	
	//영업현황 2.사업용자동차보유현황
	public Vector getOffDemandStat2(String mode, String sDate, String eDate) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String mDate1 = AddUtil.subDataCut(sDate,4);
		String mDate2 = AddUtil.subDataCut(eDate,4);
		int cDate1 = AddUtil.parseInt(mDate1);
		int cDate2 = AddUtil.parseInt(mDate2);
		String subQuery = "";
		for(int i = cDate1 ; i < cDate2; i++){
			subQuery += ", '"+i+"1231' ";
		}

		//보유대수
		query = " SELECT a.save_dt, COUNT(0) cnt \r\n"
				+ "FROM   STAT_RENT_MONTH a, CAR_REG b \n" +				
				"  WHERE  a.save_dt IN ('"+AddUtil.ChangeString(sDate)+"'"+subQuery+", '"+AddUtil.ChangeString(eDate)+"') \n" +
				"  AND a.car_mng_id=b.car_mng_id\r\n"
				+ "AND nvl(a.prepare,'0') NOT IN ('4')  \r\n"
				+ "GROUP BY a.save_dt\r\n"
				+ "ORDER BY a.save_dt \n" +
				" ";
		
		
		if(mode.equals("2")) {
			//계약고
			query = "SELECT SUBSTR(a.cmp_dt,1,4) save_dt, \r\n"
					+ "       trunc(sum(decode(sign(f.con_mon-6),-1,0,(f.fee_s_amt*f.con_mon)+f.pp_s_amt))/100000000) cnt\r\n"
					+ "FROM   STAT_BUS_COST_cmp_base a, fee f\r\n"
					+ "WHERE  a.cost_st='1' AND a.gubun='2' \r\n"
					+ "       and a.cmp_dt between '"+mDate1+"0101"+"' and '"+AddUtil.ChangeString(eDate)+"'\r\n"
					+ "       and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_st = f.rent_st\r\n"
					+ "GROUP BY SUBSTR(a.cmp_dt,1,4) \r\n"
					+ "ORDER BY SUBSTR(a.cmp_dt,1,4)";
		}


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
			System.out.println("[OffDemandDataBase:getOffDemandStat2]"+e);
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
	
	//영업현황  - 매출액 등 변수관리
	public Vector getOffDemandVarStat(String mode, String sDate, String eDate) throws DatabaseException, DataSourceEmptyException
		{
	       Connection con = connMgr.getConnection(DATA_SOURCE);
			if(con == null)
	            throw new DataSourceEmptyException("Can't get Connection !!");

			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Vector vt = new Vector();
			String query = "";
			String mDate1 = AddUtil.subDataCut(sDate,4);
			String mDate2 = AddUtil.subDataCut(eDate,4);
			int cDate1 = AddUtil.parseInt(mDate1);
			int cDate2 = AddUtil.parseInt(mDate2);
			String subQuery = "";
			for(int i = cDate1 ; i < cDate2; i++){
				subQuery += ", '"+i+"1231' ";
			}

			query = " SELECT * \r\n"
					+ "FROM   stat_rent_month_var \n" +				
					"  WHERE  \n"+
					"  var_id='"+mode+"' \r\n";
					
			if(!sDate.equals("")) {
				query += " and save_dt IN ('"+AddUtil.ChangeString(sDate)+"'"+subQuery+", '"+AddUtil.ChangeString(eDate)+"') \n";	
			}
			
			query += "ORDER BY save_dt" ;
			
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
				System.out.println("[OffDemandDataBase:getOffDemandVarStat]"+e);
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
	
	//영업현황 4.매각현황
	public Vector getOffDemandStat4(String mode, String sDate, String eDate) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String mDate1 = AddUtil.subDataCut(sDate,4);
		String mDate2 = AddUtil.subDataCut(eDate,4);

		//매각형태별현황
		query = " SELECT SUBSTR(assch_date,1,4) assch_year, \r\n"
				+ "       COUNT(DECODE(client_id,'000502',asset_code)) cnt1, \r\n"
				+ "       COUNT(DECODE(client_id,'013011',asset_code)) cnt2,\r\n"
				+ "       COUNT(DECODE(client_id,'020385',asset_code)) cnt3,\r\n"
				+ "       COUNT(DECODE(client_id,'022846',asset_code)) cnt4,\r\n"
				+ "       COUNT(DECODE(client_id,'000502','','013011','','020385','','022846','','매입옵션','','폐차','','매각','',asset_code)) cnt5,\r\n"
				+ "       COUNT(DECODE(client_id,'매입옵션',asset_code)) cnt6,\r\n"
				+ "       COUNT(DECODE(client_id,'폐차',asset_code,'매각',asset_code)) cnt7,\r\n"
				+ "       COUNT(0) cnt8 ,\r\n"
				+ "       round(COUNT(DECODE(client_id,'000502',asset_code))/COUNT(0)*100,2) per1, \r\n"
				+ "       round(COUNT(DECODE(client_id,'013011',asset_code))/COUNT(0)*100,2) per2,\r\n"
				+ "       round(COUNT(DECODE(client_id,'020385',asset_code))/COUNT(0)*100,2) per3,\r\n"
				+ "       round(COUNT(DECODE(client_id,'022846',asset_code))/COUNT(0)*100,2) per4,\r\n"
				+ "       round(COUNT(DECODE(client_id,'000502','','013011','','020385','','022846','','매입옵션','','폐차','','매각','',asset_code))/COUNT(0)*100,2) per5,\r\n"
				+ "       round(COUNT(DECODE(client_id,'매입옵션',asset_code))/COUNT(0)*100,2) per6,\r\n"
				+ "       round(COUNT(DECODE(client_id,'폐차',asset_code,'매각',asset_code))/COUNT(0)*100,2) per7\r\n"
				+ "FROM   ( \r\n"
				+ "         select \r\n"
				+ "                a.asset_code, m.assch_date,                \r\n"
				+ "                DECODE(b.firm_nm,'',case when m.assch_rmk like '%폐차%' then '폐차' when m.assch_rmk like '%폐기%' then '폐차'  else m.assch_rmk END,b.firm_nm) firm_nm,\r\n"
				+ "                DECODE(b.firm_nm,'',case when m.assch_rmk like '%폐차%' then '폐차' when m.assch_rmk like '%폐기%' then '폐차'  else m.assch_rmk END,b.client_id) client_id\r\n"
				+ "         from   fassetma a,  fassetmove m,  \r\n"
				+ "					      ( select a.* from  fyassetdep a, (select asset_code, max(gisu) gisu from fyassetdep group by asset_code) b where a.asset_code = b.asset_code and a.gisu = b.gisu ) ya, \r\n"
				+ "			          ( select a.asset_code, a.gisu, a.jun_gdep, a.gdep_amt from  fyassetdep_green a, (select asset_code, max(gisu) gisu from fyassetdep_green group by asset_code) b where a.asset_code = b.asset_code and a.gisu = b.gisu ) yg,  \r\n"
				+ "					      car_reg c, apprsl s, \r\n"
				+ "					      ( select distinct ac.car_mng_id CAR_MNG_ID from accident ac, car_reg re where ac.car_mng_id=re.car_mng_id ) sq,\r\n"
				+ "                client b \r\n"
				+ "		     where a.asset_code = ya.asset_code and a.asset_code = m.asset_code and m.assch_type = '3'  \r\n"
				+ "		           and a.asset_code = yg.asset_code(+)\r\n"
				+ "		           and  a.car_mng_id = c.car_mng_id(+) and a.car_mng_id = s.car_mng_id(+) \r\n"
				+ "               and c.car_mng_id = sq.car_mng_id(+)\r\n"
				+ "               AND s.actn_id=b.client_id(+)\r\n"
				+ "               and m.assch_date BETWEEN '"+mDate1+"0101"+"' and '"+AddUtil.ChangeString(eDate)+"'\r\n"
				+ "         )      \r\n"
				+ "GROUP BY SUBSTR(assch_date,1,4)\r\n"
				+ "ORDER BY SUBSTR(assch_date,1,4)  \n" +
				" ";
		
		
		if(mode.equals("2")) {
			//계약고
			query = "SELECT SUBSTR(assch_date,1,4) assch_year, car_use, ROUND(AVG(use_mon),1) use_mon, ROUND(AVG(sup_amt)/1000) sup_amt \r\n"
					+ "FROM   ( \r\n"
					+ "         select \r\n"
					+ "                a.asset_code, m.assch_date,           \r\n"
					+ "                case when m.assch_rmk like '%폐차%' AND nvl(m.client_id2, '99')='99' then m.sale_amt when m.assch_rmk like '%폐기%' AND nvl(m.client_id2, '99')='99' then m.sale_amt else nvl(m.s_sup_amt, round(m.sale_amt/1.1)) end sup_amt,\r\n"
					+ "                TRUNC(MONTHS_BETWEEN(TO_DATE(replace(m.assch_date,'-',''), 'YYYYMMDD'), TO_DATE(replace(decode(a.car_gu , '2', a.dlv_dt, a.get_date),'-',''), 'YYYYMMDD'))) use_mon,\r\n"
					+ "                a.car_use                \r\n"
					+ "         from   fassetma a,  fassetmove m,  \r\n"
					+ "					      ( select a.* from  fyassetdep a, (select asset_code, max(gisu) gisu from fyassetdep group by asset_code) b where a.asset_code = b.asset_code and a.gisu = b.gisu ) ya, \r\n"
					+ "			          ( select a.asset_code, a.gisu, a.jun_gdep, a.gdep_amt from  fyassetdep_green a, (select asset_code, max(gisu) gisu from fyassetdep_green group by asset_code) b where a.asset_code = b.asset_code and a.gisu = b.gisu ) yg,  \r\n"
					+ "					      car_reg c, apprsl s, \r\n"
					+ "					      ( select distinct ac.car_mng_id CAR_MNG_ID from accident ac, car_reg re where ac.car_mng_id=re.car_mng_id ) sq,\r\n"
					+ "                client b \r\n"
					+ "		     where a.asset_code = ya.asset_code and a.asset_code = m.asset_code and m.assch_type = '3'  \r\n"
					+ "		           and a.asset_code = yg.asset_code(+)\r\n"
					+ "		           and  a.car_mng_id = c.car_mng_id(+) and a.car_mng_id = s.car_mng_id(+) \r\n"
					+ "               and c.car_mng_id = sq.car_mng_id(+)\r\n"
					+ "               AND s.actn_id=b.client_id(+)\r\n"
					+ "               and m.assch_date BETWEEN '"+mDate1+"0101"+"' and '"+AddUtil.ChangeString(eDate)+"'\r\n"
					+ "         )      \r\n"
					+ "GROUP BY SUBSTR(assch_date,1,4), car_use \r\n"
					+ "ORDER BY SUBSTR(assch_date,1,4), car_use";
		}


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
			System.out.println("[OffDemandDataBase:getOffDemandStat4]"+e);
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
	
	//영업현황 6.계약현황
	public Vector getOffDemandStat6(String mode, String sDate, String eDate) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String mDate1 = AddUtil.subDataCut(sDate,4);
		String mDate2 = AddUtil.subDataCut(eDate,4);

		//대여개시현황 - 신차,재리스,연장
		query = " SELECT st, car_gu,  \r\n"
				+ "			 count(DECODE(con_mon_st,1,rent_l_cd)) cnt1,\r\n"
				+ "			 count(DECODE(con_mon_st,2,rent_l_cd)) cnt2,\r\n"
				+ "			 count(DECODE(con_mon_st,3,rent_l_cd)) cnt3,\r\n"
				+ "			 count(DECODE(con_mon_st,4,rent_l_cd)) cnt4,\r\n"
				+ "			 count(DECODE(con_mon_st,5,rent_l_cd)) cnt5,\r\n"
				+ "			 count(DECODE(con_mon_st,6,rent_l_cd)) cnt6,\r\n"
				+ "			 round(count(DECODE(con_mon_st,1,rent_l_cd))/COUNT(0)*100,1) cnt_p1,\r\n"
				+ "			 round(count(DECODE(con_mon_st,2,rent_l_cd))/COUNT(0)*100,1) cnt_p2,\r\n"
				+ "			 round(count(DECODE(con_mon_st,3,rent_l_cd))/COUNT(0)*100,1) cnt_p3,\r\n"
				+ "			 round(count(DECODE(con_mon_st,4,rent_l_cd))/COUNT(0)*100,1) cnt_p4,\r\n"
				+ "			 round(count(DECODE(con_mon_st,5,rent_l_cd))/COUNT(0)*100,1) cnt_p5,\r\n"
				+ "			 round(count(DECODE(con_mon_st,6,rent_l_cd))/COUNT(0)*100,1) cnt_p6,\r\n"
				+ "          COUNT(0) cnt7,\r\n"
				+ "			 NVL(TRUNC(SUM(DECODE(con_mon_st,1,amt)/1000000)),0) amt1,\r\n"
				+ "			 NVL(TRUNC(SUM(DECODE(con_mon_st,2,amt)/1000000)),0) amt2,\r\n"
				+ "			 NVL(TRUNC(SUM(DECODE(con_mon_st,3,amt)/1000000)),0) amt3,\r\n"
				+ "			 NVL(TRUNC(SUM(DECODE(con_mon_st,4,amt)/1000000)),0) amt4,\r\n"
				+ "			 NVL(TRUNC(SUM(DECODE(con_mon_st,5,amt)/1000000)),0) amt5,\r\n"
				+ "			 NVL(TRUNC(SUM(DECODE(con_mon_st,6,amt)/1000000)),0) amt6,\r\n"
				+ "			 NVL(round(SUM(DECODE(con_mon_st,1,amt)/1000000)/(SUM(amt)/1000000)*100,1),0) amt_p1,\r\n"
				+ "			 NVL(round(SUM(DECODE(con_mon_st,2,amt)/1000000)/(SUM(amt)/1000000)*100,1),0) amt_p2,\r\n"
				+ "			 NVL(round(SUM(DECODE(con_mon_st,3,amt)/1000000)/(SUM(amt)/1000000)*100,1),0) amt_p3,\r\n"
				+ "			 NVL(round(SUM(DECODE(con_mon_st,4,amt)/1000000)/(SUM(amt)/1000000)*100,1),0) amt_p4,\r\n"
				+ "			 NVL(round(SUM(DECODE(con_mon_st,5,amt)/1000000)/(SUM(amt)/1000000)*100,1),0) amt_p5,\r\n"
				+ "			 NVL(round(SUM(DECODE(con_mon_st,6,amt)/1000000)/(SUM(amt)/1000000)*100,1),0) amt_p6,\r\n"
				+ "          TRUNC(SUM(amt)/1000000) amt7      \r\n"
				+ "FROM (\r\n"
				+ "         --신차,재리스,연장\r\n"
				+ "         SELECT DECODE(b.rent_st,'1',DECODE(a.car_gu,'0','2','1','1',''),'3') AS st, DECODE(b.rent_st,'1',DECODE(a.car_gu,'0','재리스','1','신차',''),'연장') AS car_gu, \r\n"
				+ "                CASE when b.con_mon BETWEEN 0 AND 6 THEN 1 \r\n"
				+ "                     when b.con_mon BETWEEN 7 AND 12 THEN 2\r\n"
				+ "                     when b.con_mon BETWEEN 13 AND 24 THEN 3\r\n"
				+ "                     when b.con_mon BETWEEN 25 AND 36 THEN 4\r\n"
				+ "                     when b.con_mon BETWEEN 37 AND 48 THEN 5\r\n"
				+ "                     when b.con_mon > 48 THEN 6\r\n"
				+ "                     END con_mon_st,                     \r\n"
				+ "                a.rent_l_cd, b.con_mon, (b.fee_s_amt*b.con_mon)+b.pp_s_amt AS amt \r\n"
				+ "				 from   cont a, fee b, cls_cont c, fee_etc h, \r\n"
				+ "                (select rent_mng_id, rent_l_cd, cls_dt, cls_st, nvl(reg_dt,cls_dt) reg_dt from cls_cont where cls_st in ('4','5')) g  \r\n"
				+ "				 where \r\n"
				+ "				        a.car_st NOT in ('2','4') and a.client_id not in ('000228','000231')\r\n"
				+ "				        and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \r\n"
				+ "				        and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) and nvl(c.cls_st,'0') not in ('7','10') \r\n"
				+ "				        and b.rent_mng_id=h.rent_mng_id and b.rent_l_cd=h.rent_l_cd and b.rent_st=h.rent_st \r\n"
				+ "				        and a.rent_mng_id=g.rent_mng_id(+) and a.reg_dt=g.reg_dt(+) \r\n"
				+ "				        and case when g.rent_l_cd is not null and a.reg_dt < nvl(to_char(h.reg_dt,'YYYYMMDD'),g.reg_dt)  then '' else g.rent_l_cd end is NULL  \r\n"
				+ "                     and b.rent_start_dt BETWEEN '"+mDate1+"0101"+"' and '"+AddUtil.ChangeString(eDate)+"'\r\n"				
				+ "         UNION ALL \r\n"
				+ "         --신차,재리스,연장 임의연장\r\n"
				+ "         SELECT '3' AS st, '연장' AS car_gu, \r\n"
				+ "                CASE when b.con_mon BETWEEN 0 AND 6 THEN 1 \r\n"
				+ "                     when b.con_mon BETWEEN 7 AND 12 THEN 2\r\n"
				+ "                     when b.con_mon BETWEEN 13 AND 24 THEN 3\r\n"
				+ "                     when b.con_mon BETWEEN 25 AND 36 THEN 4\r\n"
				+ "                     when b.con_mon BETWEEN 37 AND 48 THEN 5\r\n"
				+ "                     when b.con_mon > 48 THEN 6\r\n"
				+ "                     END con_mon_st,\r\n"
				+ "                a.rent_l_cd, e.add_tm AS con_mon, (b.fee_s_amt*e.add_tm) AS amt \r\n"
				+ "				 from   cont a, fee b, cls_cont c, fee_etc h, \r\n"
				+ "                (select rent_mng_id, rent_l_cd, cls_dt, cls_st, nvl(reg_dt,cls_dt) reg_dt from cls_cont where cls_st in ('4','5')) g, fee_im e   \r\n"
				+ "				 where \r\n"
				+ "				        a.car_st NOT in ('2','4') and a.client_id not in ('000228','000231')\r\n"
				+ "				        and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \r\n"
				+ "				        and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) and nvl(c.cls_st,'0') not in ('7','10') \r\n"
				+ "				        and b.rent_mng_id=h.rent_mng_id and b.rent_l_cd=h.rent_l_cd and b.rent_st=h.rent_st \r\n"
				+ "				        and a.rent_mng_id=g.rent_mng_id(+) and a.reg_dt=g.reg_dt(+) \r\n"
				+ "                     and b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd and b.rent_st=e.rent_st\r\n"
				+ "				        and case when g.rent_l_cd is not null and a.reg_dt < nvl(to_char(h.reg_dt,'YYYYMMDD'),g.reg_dt)  then '' else g.rent_l_cd end is NULL  \r\n"
				+ "                     and b.rent_start_dt BETWEEN '"+mDate1+"0101"+"' and '"+AddUtil.ChangeString(eDate)+"'\r\n"				
				+ ")        \r\n"
				+ "GROUP BY st, car_gu\r\n"
				+ "ORDER BY 1 \n" +
				" ";
		
		
		if(mode.equals("2")) {
			//대여개시현황 - 월렌트
			query = "SELECT COUNT(0) cnt, TRUNC(SUM(amt)/1000000) amt \r\n"
					+ "FROM   ( \r\n"
					+ "				 SELECT a.car_gu, trunc((b.fee_s_amt*b.con_mon)+(b.fee_s_amt/30*c.con_day)) amt \r\n"
					+ "				 from   cont a, fee b, FEE_etc c, cls_cont d \r\n"
					+ "				 where a.car_st='4' \r\n"
					+ "				 and a.client_id not in ('000228','000231') \r\n"
					+ "				 and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \r\n"
					+ "				 and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd AND b.RENT_ST=c.rent_st \r\n"
					+ "				 and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+) \r\n"
					+ "				 AND a.rent_start_dt < d.cls_dt \r\n"
					+ "              and b.rent_start_dt BETWEEN '"+mDate1+"0101"+"' and '"+AddUtil.ChangeString(eDate)+"'\r\n"					
					+ "				 UNION all \r\n"
					+ "				 SELECT a.car_gu, trunc(b.fee_s_amt*c.add_tm) amt \r\n"
					+ "				 from   cont a, FEE b, fee_im c, cls_cont d \r\n"
					+ "				 where a.car_st='4' \r\n"
					+ "				 and a.client_id not in ('000228','000231') \r\n"
					+ "				 and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \r\n"
					+ "				 and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd AND b.RENT_ST=c.rent_st \r\n"
					+ "				 and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+) \r\n"
					+ "				 AND a.rent_start_dt < d.cls_dt \r\n"
					+ "              and c.rent_start_dt BETWEEN '"+mDate1+"0101"+"' and '"+AddUtil.ChangeString(eDate)+"'\r\n"										
					+ "				 )";
		}


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
			System.out.println("[OffDemandDataBase:getOffDemandStat6]"+e);
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
	
	//영업현황 7.채권관리
	public Vector getOffDemandStat7(String mode, String sDate, String eDate) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		String mDate1 = AddUtil.subDataCut(sDate,4);
		String mDate2 = AddUtil.subDataCut(eDate,4);
		int cDate1 = AddUtil.parseInt(mDate1);
		int cDate2 = AddUtil.parseInt(mDate2);
		String subQuery = "";
		for(int i = cDate1 ; i < cDate2; i++){
			subQuery += ", '"+i+"0630', '"+i+"1231' ";
		}
		
		//대여개시현황 - 신차,재리스,연장
		query = " SELECT save_dt, \r\n"
				+ "       dly_cnt2, dly_amt2,\r\n"
				+ "       dly_cnt3, dly_amt3,\r\n"
				+ "       dly_cnt4, dly_amt4,\r\n"
				+ "       dly_cnt-nvl(dly_cnt2,0)-nvl(dly_cnt3,0)-nvl(dly_cnt4,0) dly_cnt5, dly_amt-nvl(dly_amt2,0)-nvl(dly_amt3,0)-nvl(dly_amt4,0) dly_amt5,\r\n"
				+ "       dly_cnt AS dly_cnt6, dly_amt AS dly_amt6, \r\n"
				+ "       round(dly_amt/1000000) dly_amt7,\r\n"
				+ "       round(est_amt/1000000) dly_amt8,\r\n"
				+ "       trunc(dly_amt/est_amt*100,2) dly_per\r\n"
				+ "FROM  STAT_INCOM_PAY \r\n"
				+ "WHERE save_dt IN ('"+AddUtil.ChangeString(sDate)+"'"+subQuery+", '"+AddUtil.ChangeString(eDate)+"') \r\n"				
				+ "      AND gubun_nm='대여료' AND gubun_st='미수금'\r\n"
				+ "ORDER BY save_dt \n" +
				" ";
		
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
			System.out.println("[OffDemandDataBase:getOffDemandStat7]"+e);
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
	
	//영업현황 10.부서 및 임직원현황
	public Vector getOffDemandStat10(String mode, String sDate, String eDate) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT br_gubun, sort_gubun, dept_gubun, COUNT(0) cnt, min(var1) work_cont \r\n"
				+ "FROM \r\n"
				+ "(\r\n"
				+ "SELECT DECODE(a.br_id,'S1','본사','지점') br_gubun,\r\n"
				+ "       CASE WHEN a.user_pos LIKE '%이사%' THEN 1\r\n"
				+ "            WHEN a.user_pos LIKE '%감사%' THEN 1\r\n"
				+ "            else TO_NUMBER(b.cms_bk) END sort_gubun, \r\n"
				+ "       CASE WHEN a.user_pos LIKE '%이사%' THEN '임원'\r\n"
				+ "            WHEN a.user_pos LIKE '%감사%' THEN '임원'\r\n"
				+ "            else b.nm END dept_gubun,\r\n"
				+ "       a.user_id, a.user_nm, a.br_id, a.dept_id, a.loan_st, a.user_work, a.user_pos,\r\n"
				+ "       b.var1 \r\n"
				+ "FROM  stat_user a, code b \r\n"
				+ "WHERE a.save_dt='"+AddUtil.ChangeString(eDate)+"'\r\n"
				+ "      AND a.dept_id=b.code AND b.c_st='0002'\r\n"
				+ ")\r\n"
				+ "GROUP BY br_gubun, sort_gubun, dept_gubun \r\n"
				+ "ORDER BY 1,2 \r\n"
				+" ";				
						
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
			System.out.println("[OffDemandDataBase:getOffDemandStat10]"+e);
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
