package acar.admin;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;
import acar.common.*;

public class FeeAmtDlySmsSend
{
	private Connection conn = null;
	public static FeeAmtDlySmsSend db;
	
	public static FeeAmtDlySmsSend getInstance()
	{
		if(FeeAmtDlySmsSend.db == null)
			FeeAmtDlySmsSend.db = new FeeAmtDlySmsSend();
		return FeeAmtDlySmsSend.db;
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
	 *	미납대여료 1회차 연체2일 경과후 SMS 문자 발송
	 */
	public Vector getFeeAmtDlyList()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String sub_query =  " select"+
						" d.client_id, b.rent_mng_id, b.rent_l_cd, b.fee_tm, b.rent_st, b.rent_seq, b.tm_st1, b.tm_st2, b.fee_est_dt, b.r_fee_est_dt, b.fee_s_amt, b.fee_v_amt, b.dly_days, b.dly_fee,"+
						" h.car_nm, h.car_no,"+
						" d.tax_type, e.firm_nm, e.client_nm, e.m_tel,"+
						" e.con_agnt_nm, e.con_agnt_m_tel, f.agnt_nm, f.agnt_m_tel,"+
						" g.mgr_nm as mgr_nm1, g.mgr_m_tel as mgr_tel1, i.mgr_nm as mgr_nm2, i.mgr_m_tel as mgr_tel2, j.mgr_nm as mgr_nm3, j.mgr_m_tel as mgr_tel3"+
						" from"+
						" /*1회차연체*/(select rent_mng_id, rent_l_cd from scd_fee where bill_yn='Y' and tm_st2<>'4' and rc_dt is null and r_fee_est_dt <=to_char(sysdate-4,'YYYYMMDD') group by rent_mng_id, rent_l_cd having count(*)=1) a,"+
						" scd_fee b,"+
						" /*발송확인*/(select * from dly_mm where reg_id='dlysms') c,"+
						" cont d, client e, client_site f,"+
						" (select * from car_mgr where mgr_st='회계관리자') g,"+
						" (select * from car_mgr where mgr_st='차량관리자') i,"+
						" (select * from car_mgr where mgr_st='차량이용자') j,"+
						" car_reg h"+
						" where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd "+
						" and b.bill_yn='Y' and b.tm_st2<>'4' and b.rc_dt is null and b.r_fee_est_dt <=to_char(sysdate-4,'YYYYMMDD')"+
						" and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd and d.use_yn='Y'"+
						" and b.rent_mng_id=c.rent_mng_id(+) and b.rent_l_cd=c.rent_l_cd(+) and b.rent_st=c.rent_st(+) and b.tm_st1=c.tm_st1(+) and b.fee_tm=c.fee_tm(+)"+
						" and c.rent_l_cd is null"+
						" and d.client_id=e.client_id"+
						" and d.client_id=f.CLIENT_ID(+) and d.r_site=f.seq(+)"+
						" and d.rent_mng_id=g.rent_mng_id and d.rent_l_cd=g.rent_l_cd"+
						" and d.rent_mng_id=i.rent_mng_id and d.rent_l_cd=i.rent_l_cd"+
						" and d.rent_mng_id=j.rent_mng_id and d.rent_l_cd=j.rent_l_cd"+
						" and d.car_mng_id=h.car_mng_id"+
						" order by e.firm_nm, b.r_fee_est_dt"+
						" ";

		String query =  " select"+
						" rent_mng_id, rent_l_cd, rent_st, tm_st1, fee_tm, client_id, substr(firm_nm,1,10) firm_nm, car_no, r_fee_est_dt, (fee_s_amt+fee_v_amt) fee_amt,"+
						" decode(con_agnt_m_tel,'',decode(mgr_tel1,'',decode(mgr_tel2,'',decode(mgr_tel3,'',client_nm,mgr_nm3),mgr_nm2),mgr_nm1), con_agnt_nm) nm,"+
						" decode(con_agnt_m_tel,'',decode(mgr_tel1,'',decode(mgr_tel2,'',decode(mgr_tel3,'',m_tel,mgr_tel3),mgr_tel2),mgr_tel1),con_agnt_m_tel) tel"+
						" from "+
						"	("+sub_query+") "+
						" order by client_id, firm_nm ";

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
			System.out.println("[FeeAmtDlySmsSend:getFeeAmtDlyList]"+e);
			System.out.println("[FeeAmtDlySmsSend:getFeeAmtDlyList]"+query);
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
	 *	미납대여료 1회차 연체2일 경과후 SMS 문자 발송
	 */
	public Vector getFeeAmtDlyMMList(String reg_code)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query =  " select"+
						" substr(c.firm_nm,1,10) firm_nm, a.content, a.speaker"+
						" from dly_mm a, cont b, client c"+
						" where a.reg_id='dlysms' and a.reg_dt_time='"+reg_code+"'"+
						" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.client_id=c.client_id ";

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
			System.out.println("[FeeAmtDlySmsSend:getFeeAmtDlyMMList]"+e);
			System.out.println("[FeeAmtDlySmsSend:getFeeAmtDlyMMList]"+query);
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