package acar.incom;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;

public class IncomDatabase
{
	private Connection conn = null;
	public static IncomDatabase db;
	
	public static IncomDatabase getInstance()
	{
		if(IncomDatabase.db == null)
			IncomDatabase.db = new IncomDatabase();
		return IncomDatabase.db;
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
	
	
	//은행거래내역 리스트 조회 
	public Vector getIncomList(String s_kd, String t_wd, String gubun1, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" a.*, "+
				" decode(a.jung_type,'0','대기','1','정상처리', '2', '가수금', '3', '가수금정산', '4', '카드처리', '5', '카드정산') as jung_st_nm, "+
				" decode(a.ip_method,'1','계좌','2','카드', '3', '현금', '5', '보증금') as ip_me_nm "+
				" from incom a , users u "+
				" where a.reg_id = u.user_id(+) ";
		
		String search = "";
		String what = "";

		if(s_kd.equals("0"))			query += " and a.jung_type = '0' "; //대기
		else if(s_kd.equals("1"))		query += " and a.jung_type = '1' "; //정상처리
		else if(s_kd.equals("2"))		query += " and a.jung_type = '2' and a.incom_dt > '20131231' "; //가수금처리(2014부터)
		else if(s_kd.equals("C"))		query += " and a.jung_type = '1' and a.ip_method = '2' "; //카드미수금처리

		if(gubun1.equals("2"))			query += " and a.incom_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun1.equals("1"))		query += " and a.incom_dt = to_char(sysdate,'YYYYMMDD')";
		else if(gubun1.equals("4"))		query += " and a.incom_dt = to_char(to_date(to_char(sysdate,'YYYYMMDD')) - 1, 'yyyymmdd') ";
		else if(gubun1.equals("5"))		query += " and a.incom_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' ";
		else if(gubun1.equals("3")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and a.incom_dt like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and a.incom_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		query += " order by a.incom_dt, a.incom_seq ";

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
			System.out.println("[IncomDatabase:getIncomList]\n"+e);
			System.out.println("[IncomDatabase:getIncomList]\n"+query);
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
	
		
	//은행거래내역 리스트 조회 
	public Vector getIncomListChk(String s_kd, String t_wd, String gubun1, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select nvl(r.reply_cont, '00') ,"+
				" a.*, "+
				" decode(a.jung_type,'0','대기','1','정상처리', '2', '가수금', '3', '가수금정산', '4', '카드처리', '5', '카드정산') as jung_st_nm, "+
				" decode(a.ip_method,'1','계좌','2','카드', '3', '현금', '5', '보증금') as ip_me_nm "+
				" from incom a , users u , incom_reply r "+
				" where a.reg_id = u.user_id(+)  and a.jung_type = '2' and a.incom_dt = r.incom_dt(+) and a.incom_seq = r.incom_seq(+) and nvl(r.reply_cont, '00') = '00' and a.incom_dt >='20120101'";
		
		String search = "";
		String what = "";

		if(gubun1.equals("2"))			query += " and a.incom_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun1.equals("5"))		query += " and a.incom_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' ";
		else if(gubun1.equals("3")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and a.incom_dt like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and a.incom_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		if(t_wd.equals("Y"))			query += " and nvl(a.re_chk, 'N' ) <> 'Y'";
		
		query += " order by a.incom_dt desc, a.incom_seq ";

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
			System.out.println("[IncomDatabase:getIncomList]\n"+e);
			System.out.println("[IncomDatabase:getIncomList]\n"+query);
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
	
	
	//은행거래내역 리스트 조회 
	public Vector getIncomGubunList(String s_kd, String t_wd, String gubun1, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		
		query = " select  distinct a.* , \n"+
     			" decode(a.ip_method,'1','계좌','2','카드', '3', '현금', '4', 'CMS', '5', '대체') as ip_nm,  \n"+
     			" decode(a.p_gubun , '2', 'CMS', '4', decode(a.jung_type, '0','보험해지입금대기', '1', '완료')  , '3', decode(a.jung_type, '0','카드사입금대기', '1', '완료') , decode(a.jung_type,'0','대기','1','완료', '2', '가수금', '3', '가수금정산', '4', '카드처리', '6', '카드사입금완료')) as jung_st_nm \n" +
				" from incom a , incom_view i , cont_n_view c , car_reg cr \n"+
				" where  i.incom_dt = a.incom_dt and i.incom_seq = a.incom_seq  \n"+
				"  and i.rent_mng_id = c.rent_mng_id(+) and i.rent_l_cd = c.rent_l_cd(+) and c.car_mng_id = cr.car_mng_id(+) \n";                             
      
		
		String search = "";
		String what = "";

		
		
		if(gubun1.equals("2"))			query += " and a.incom_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun1.equals("1"))		query += " and a.incom_dt = to_char(sysdate,'YYYYMMDD')";
		else if(gubun1.equals("3")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and a.incom_dt like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and a.incom_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}
	
	
		if(s_kd.equals("0"))			query += " and a.jung_type = '0' "; // 전체
		else if(s_kd.equals("1"))		query += " and c.firm_nm like  '%"+t_wd+"%'";
		else if(s_kd.equals("2"))		query += " and c.rent_l_cd like  '%"+t_wd+"%'"; //계약번호
		else if(s_kd.equals("3"))		query += " and cr.car_no like  '%"+t_wd+"%'"; //차량번호

		query += " order by a.incom_dt, a.incom_seq ";

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
			System.out.println("[IncomDatabase:getIncomGubunList]\n"+e);
			System.out.println("[IncomDatabase:getIncomGubunList]\n"+query);
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
	
	
	//은행거래내역 집계 
	public Vector getIncomStat( String t_wd, String gubun1, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" a.bank_nm, a.bank_no, count(*) tot_cnt, sum(incom_amt) tot_amt "+
				" from incom a , users u "+
				" where a.reg_id = u.user_id(+) and a.ip_method = '1' ";
		
		String search = "";
		String what = "";


		if(gubun1.equals("2"))			query += " and a.incom_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun1.equals("1"))		query += " and a.incom_dt = to_char(sysdate,'YYYYMMDD')";
		else if(gubun1.equals("3")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and a.incom_dt like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and a.incom_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		query += " group by a.bank_nm, a.bank_no ";
		query += " order by a.bank_nm, a.bank_no ";

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
			System.out.println("[IncomDatabase:getIncomStat]\n"+e);
			System.out.println("[IncomDatabase:getIncomStat]\n"+query);
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

	//은행거래내역 리스트 조회 - s_kd-> 1:계좌, 2:카드(청구분)
	public Vector getIncomList(String s_kd, String t_wd, String gubun1, String st_dt, String end_dt, String bank_nm, String bank_no, String bank_code, String card_cd, String s_kd2, String t_wd2 )
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select   distinct a.*, "+
				" decode(a.p_gubun , '2', 'CMS', '4', decode(a.jung_type, '0','보험해지입금대기', '1', '완료')  , '3', decode(a.jung_type, '0','카드사입금대기', '1', '완료') , decode(a.jung_type,'0','대기','1','완료', '2', '가수금', '3', '가수금정산', '4', '카드처리', '6', '카드사입금완료')) as jung_st_nm, "+
				" decode(a.ip_method,'1','계좌','2','카드', '3', '현금', '5', '대체') as ip_me_nm "+
				" from incom a , incom_view i , cont_n_view c , car_reg cr  \n"+
				" where a.ip_method  in ( '1' , '2', '3', '5') \n"+
				"  and  a.incom_dt = i.incom_dt(+) and a.incom_seq = i.incom_seq(+)  \n"+
				"  and  i.rent_mng_id = c.rent_mng_id(+) and i.rent_l_cd = c.rent_l_cd(+)  and c.car_mng_id = cr.car_mng_id(+) \n";   
				
		
		String search = "";
		String what = "";

		if(gubun1.equals("2"))			query += " and a.incom_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun1.equals("1"))		query += " and a.incom_dt = to_char(sysdate,'YYYYMMDD')";
		else if(gubun1.equals("4"))		query += " and a.incom_dt = to_char(to_date(to_char(sysdate,'YYYYMMDD')) - 1, 'yyyymmdd') ";
		else if(gubun1.equals("5"))		query += " and a.incom_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' ";
		else if(gubun1.equals("3")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and a.incom_dt like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and a.incom_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		if(s_kd.equals("1"))			query += " and a.ip_method = '1'";
		else if(s_kd.equals("2"))		query += " and a.ip_method = '2'";
		else if(s_kd.equals("3"))		query += " and a.ip_method = '3'";
		else if(s_kd.equals("5"))		query += " and a.ip_method = '5'";
		
		
		if(!bank_nm.equals(""))		query += " and a.bank_nm ='" + bank_nm + "'";
		if(!bank_no.equals(""))		query += " and a.bank_no ='" + bank_no + "'";
		
		if(!bank_code.equals(""))		query += " and a.bank_nm  ='" + bank_code + "'";
		if(!card_cd.equals(""))			query += " and a.card_cd  ='" + card_cd + "'";
							
	
	    if (!t_wd2.equals("") ) {
			if(s_kd2.equals("1"))		query += " and c.firm_nm like  '%"+t_wd2+"%'"; //상호
			else if(s_kd2.equals("2"))		query += " and c.rent_l_cd like '%"+t_wd2+"%'";//계약번호
			else if(s_kd2.equals("3"))		query += " and cr.car_no like  '%"+t_wd2+"%'"; //차량번호
		}	
		
		query += " order by a.incom_dt, a.incom_seq ";

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
			System.out.println("[IncomDatabase:getIncomList]\n"+e);
			System.out.println("[IncomDatabase:getIncomList]\n"+query);
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
	
		//은행거래내역 리스트 조회 - s_kd-> 1:계좌, 2:카드(청구분)
	public Vector getIncomList(String s_kd, String t_wd, String gubun1, String st_dt, String end_dt, String bank_nm, String bank_no, String bank_code, String card_cd )
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" a.*, "+
				" decode(a.p_gubun , '2', 'CMS', '4', decode(a.jung_type, '0','보험해지입금대기', '1', '완료')  , '3', decode(a.jung_type, '0','카드사입금대기', '1', '완료') , decode(a.jung_type,'0','대기','1','완료', '2', '가수금', '3', '가수금정산', '4', '카드처리', '6', '카드사입금완료')) as jung_st_nm, "+
				" decode(a.ip_method,'1','계좌','2','카드', '3', '현금', '5', '대체') as ip_me_nm "+
				" from incom a  "+
				" where a.ip_method  in ( '1' , '2', '3', '5') ";
		
		String search = "";
		String what = "";

		if(gubun1.equals("2"))			query += " and a.incom_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun1.equals("1"))		query += " and a.incom_dt = to_char(sysdate,'YYYYMMDD')";
		else if(gubun1.equals("4"))		query += " and a.incom_dt = to_char(to_date(to_char(sysdate,'YYYYMMDD')) - 1, 'yyyymmdd') ";
		else if(gubun1.equals("5"))		query += " and a.incom_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' ";
		else if(gubun1.equals("3")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and a.incom_dt like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and a.incom_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		if(s_kd.equals("1"))			query += " and a.ip_method = '1'";
		else if(s_kd.equals("2"))		query += " and a.ip_method = '2'";
		else if(s_kd.equals("3"))		query += " and a.ip_method = '3'";
		else if(s_kd.equals("5"))		query += " and a.ip_method = '5'";
		
		
		if(!bank_nm.equals(""))		query += " and a.bank_nm ='" + bank_nm + "'";
		if(!bank_no.equals(""))		query += " and a.bank_no ='" + bank_no + "'";
		
		if(!bank_code.equals(""))		query += " and a.bank_nm  ='" + bank_code + "'";
		if(!card_cd.equals(""))			query += " and a.card_cd  ='" + card_cd + "'";
		
		query += " order by a.incom_dt, a.incom_seq ";

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
			System.out.println("[IncomDatabase:getIncomList]\n"+e);
			System.out.println("[IncomDatabase:getIncomList]\n"+query);
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
	
	
	//거래내역 조회 
	public IncomBean getIncomBase(String incom_dt, int incom_seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		IncomBean base = new IncomBean();
		String query = "";
		
		query = " select"+
				" decode(C.INCOM_DT, '', '', substr(C.INCOM_DT, 1, 4) || '-' || substr(C.INCOM_DT, 5, 2) || '-'||substr(C.INCOM_DT, 7, 2)) INCOM_DT,"+
				" C.INCOM_SEQ, C.INCOM_AMT, C.INCOM_GUBUN, C.JUNG_TYPE, C.IP_METHOD, C.BANK_NM, C.BANK_NO, C.REMARK, C.BANK_OFFICE, "+
				" C.CARD_NM, C.CARD_NO, C.CARD_OWNER, C.CARD_GET_ID, C.CASH_AREA, C.CASH_GET_ID, C.RENT_L_CD, C.REG_ID, C.CARD_DOC_CONT , C.CARD_CD, "+
				" C.RE_CHK, C.REASON \n"+
				" from INCOM C, USERS F "+
				" where C.incom_dt  = ? and C.incom_seq = ? and C.reg_id = F.user_id(+)";
				
		try
		{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, incom_dt);
			pstmt.setInt(2, incom_seq);
		   	rs = pstmt.executeQuery();
		
			while(rs.next())
			{
							
				base.setIncom_dt(rs.getString("INCOM_DT")==null?"":rs.getString("INCOM_DT"));
				base.setIncom_seq(rs.getString("INCOM_SEQ")==null?0:Integer.parseInt(rs.getString("INCOM_SEQ")));
				base.setIncom_amt	(rs.getString("INCOM_AMT")	==null? 0:Long.parseLong(rs.getString("INCOM_AMT")));
				base.setIncom_gubun(rs.getString("INCOM_GUBUN")==null?"":rs.getString("INCOM_GUBUN"));
				base.setJung_type(rs.getString("JUNG_TYPE")==null?"":rs.getString("JUNG_TYPE"));
				base.setIp_method(rs.getString("IP_METHOD")==null?"":rs.getString("IP_METHOD"));
				base.setBank_nm	(rs.getString("BANK_NM")==null?"":rs.getString("BANK_NM"));
				base.setBank_no	(rs.getString("BANK_NO")==null?"":rs.getString("BANK_NO"));
				base.setRemark	(rs.getString("REMARK")==null?"":rs.getString("REMARK"));
				base.setBank_office	(rs.getString("BANK_OFFICE")==null?"":rs.getString("BANK_OFFICE"));
		
				base.setCard_cd	(rs.getString("CARD_CD")==null?"":rs.getString("CARD_CD"));
				base.setCard_nm	(rs.getString("CARD_NM")==null?"":rs.getString("CARD_NM"));
				base.setCard_no	(rs.getString("CARD_NO")==null?"":rs.getString("CARD_NO"));
				base.setCard_owner	(rs.getString("CARD_OWNER")==null?"":rs.getString("CARD_OWNER"));
				base.setCard_get_id	(rs.getString("CARD_GET_ID")==null?"":rs.getString("CARD_GET_ID"));
				base.setCash_area	(rs.getString("CASH_AREA")==null?"":rs.getString("CASH_AREA"));
				base.setCash_get_id	(rs.getString("CASH_GET_ID")==null?"":rs.getString("CASH_GET_ID"));
				base.setRent_l_cd	(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				base.setReg_id		(rs.getString("REG_ID")==null?"":rs.getString("REG_ID"));
				base.setCard_doc_cont(rs.getString("CARD_DOC_CONT")==null?"":rs.getString("CARD_DOC_CONT"));
				base.setRe_chk(rs.getString("RE_CHK")==null?"":rs.getString("RE_CHK"));
				base.setReason(rs.getString("REASON")==null?"":rs.getString("REASON"));
		
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[IncomDatabase:getIncomBase]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return base;
		}
	}
	 
		
	//거래내역 조회 

	public IncomBean getIncomClientBase(String incom_dt, int incom_seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		IncomBean base = new IncomBean();
		String query = "";
		
		query = " select C.CLIENT_ID, C.PAY_GUR, C.PAY_GUR_NM, C.PAY_GUR_REL, C.PAY_REASON, C.PAY_SAC_ID, C.EXCEPT_ST1, "+
				" decode(C.INCOM_DT, '', '', substr(C.INCOM_DT, 1, 4) || '-' || substr(C.INCOM_DT, 5, 2) || '-'||substr(C.INCOM_DT, 7, 2)) INCOM_DT,"+
				" C.INCOM_SEQ, C.INCOM_AMT, C.INCOM_GUBUN, C.JUNG_TYPE, C.IP_METHOD, C.BANK_NM, C.BANK_NO, C.REMARK, C.BANK_OFFICE, "+
				" C.CARD_NM, C.CARD_NO, C.CARD_OWNER, C.CARD_GET_ID, C.CASH_AREA, C.CASH_GET_ID, C.RENT_L_CD, C.REG_ID, "+
				" C.CARD_TAX, C.PAY_GUR, C.PAY_GUR_NM, C.PAY_GUR_REL, C.CARD_CD, C.P_GUBUN  , c.ROW_ID "+
				" from INCOM C, USERS F  "+
				" where C.reg_id = F.user_id "+
				" and C.incom_dt  = ? and C.incom_seq = ?";
		try
		{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, incom_dt);
			pstmt.setInt(2, incom_seq);
		   	rs = pstmt.executeQuery();
		
			while(rs.next())
			{
							
				base.setIncom_dt(rs.getString("INCOM_DT")==null?"":rs.getString("INCOM_DT"));
				base.setIncom_seq(rs.getString("INCOM_SEQ")==null?0:Integer.parseInt(rs.getString("INCOM_SEQ")));
				base.setIncom_amt	(rs.getString("INCOM_AMT")	==null? 0:Long.parseLong(rs.getString("INCOM_AMT")));
				base.setIncom_gubun(rs.getString("INCOM_GUBUN")==null?"":rs.getString("INCOM_GUBUN"));
				base.setJung_type(rs.getString("JUNG_TYPE")==null?"":rs.getString("JUNG_TYPE"));
				base.setIp_method(rs.getString("IP_METHOD")==null?"":rs.getString("IP_METHOD"));
				base.setBank_nm	(rs.getString("BANK_NM")==null?"":rs.getString("BANK_NM"));
				base.setBank_no	(rs.getString("BANK_NO")==null?"":rs.getString("BANK_NO"));
				base.setRemark	(rs.getString("REMARK")==null?"":rs.getString("REMARK"));
				base.setBank_office	(rs.getString("BANK_OFFICE")==null?"":rs.getString("BANK_OFFICE"));
		
				base.setCard_cd	(rs.getString("CARD_CD")==null?"":rs.getString("CARD_CD"));
				base.setCard_nm	(rs.getString("CARD_NM")==null?"":rs.getString("CARD_NM"));
				base.setCard_no	(rs.getString("CARD_NO")==null?"":rs.getString("CARD_NO"));
				base.setCard_owner	(rs.getString("CARD_OWNER")==null?"":rs.getString("CARD_OWNER"));
				base.setCard_get_id	(rs.getString("CARD_GET_ID")==null?"":rs.getString("CARD_GET_ID"));
				base.setCash_area	(rs.getString("CASH_AREA")==null?"":rs.getString("CASH_AREA"));
				base.setCash_get_id	(rs.getString("CASH_GET_ID")==null?"":rs.getString("CASH_GET_ID"));
				base.setRent_l_cd	(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				base.setReg_id		(rs.getString("REG_ID")==null?"":rs.getString("REG_ID"));
				base.setClient_id	(rs.getString("CLIENT_ID")==null?"":rs.getString("CLIENT_ID"));
				base.setPay_gur		(rs.getString("PAY_GUR")==null?"":rs.getString("PAY_GUR"));
				base.setPay_gur_nm	(rs.getString("PAY_GUR_NM")==null?"":rs.getString("PAY_GUR_NM"));
				base.setPay_gur_rel	(rs.getString("PAY_GUR_REL")==null?"":rs.getString("PAY_GUR_REL"));
				base.setPay_reason	(rs.getString("PAY_REASON")==null?"":rs.getString("PAY_REASON"));
				base.setPay_sac_id	(rs.getString("PAY_SAC_ID")==null?"":rs.getString("PAY_SAC_ID"));
				base.setExcept_st1	(rs.getString("EXCEPT_ST1")==null?"":rs.getString("EXCEPT_ST1"));
				base.setCard_tax	(rs.getString("CARD_TAX")	==null? 0:Integer.parseInt(rs.getString("CARD_TAX")));
				
				base.setPay_gur	(rs.getString("PAY_GUR")==null?"":rs.getString("PAY_GUR"));
				base.setPay_gur_nm	(rs.getString("PAY_GUR_NM")==null?"":rs.getString("PAY_GUR_NM"));
				base.setPay_gur_rel	(rs.getString("PAY_GUR_REL")==null?"":rs.getString("PAY_GUR_REL"));
				base.setP_gubun(rs.getString("P_GUBUN")==null?"":rs.getString("P_GUBUN"));
				
				base.setRow_id(rs.getString("ROW_ID")==null?"":rs.getString("ROW_ID")); //neom row_id
			
					
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[IncomDatabase:getIncomClientBase]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return base;
		}
	}
		
	//입금처리전 수정
	public boolean updateIncom(IncomBean base)
	{
		getConnection();
		Statement stmt = null;
		boolean flag = true;
		
		String incom_dt = AddUtil.replace(base.getIncom_dt(),"-","");
		
		String query = " update INCOM set "+
						" JUNG_TYPE		= '"+base.getJung_type()+"',"+
						" REG_ID		= '"+base.getReg_id()+"',"+
						" REG_DT		= sysdate, "+
						" CLIENT_ID		= '"+base.getClient_id()+"',"+
						" PAY_GUR		= '"+base.getPay_gur()+"',"+
						" PAY_GUR_NM	= '"+base.getPay_gur_nm().trim()+"',"+
						" PAY_GUR_REL	= '"+base.getPay_gur_rel().trim()+"',"+
						" EXCEPT_ST1		= '"+base.getExcept_st1()+"',"+
						" EXCEPT_ST2		= '"+base.getExcept_st2()+"',"+
						" EXCEPT_ST3		= '"+base.getExcept_st3()+"',"+
						" PAY_REASON		= '"+base.getPay_reason().trim()+"',"+
						" PAY_SAC_ID		= '"+base.getPay_sac_id()+"',"+
						" NEOM_YN		= '"+base.getNeom_yn()+"',"+
						" VEN_CODE		= '"+base.getVen_code()+"',"+
						" CONT		= '"+base.getCont()+"',"+
						" TRUSBILL_YN		= '"+base.getTrusbill_yn()+"',"+
						" MAIL_YN		= '"+base.getMail_yn()+"'"+
														
						" where"+
						" INCOM_DT	= '"+incom_dt+"' and "+
						" INCOM_SEQ		= "+base.getIncom_seq();
		try 
		{
			conn.setAutoCommit(false);

			stmt = conn.createStatement();
			stmt.executeUpdate(query);
			stmt.close();
  			conn.commit();
		    
		} catch (Exception e) {
            try{
				System.out.println("[IncomDatabase:updateIncom]"+e);
                conn.rollback();
            }catch(SQLException _ignored){}
			e.printStackTrace();
	  		flag = false;
		} finally {
			try{
				conn.setAutoCommit(true);
                if(stmt != null)		stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	//변수
	String est_amt1 = "(a.ext_s_amt+a.ext_v_amt)";
	String est_amt2 = "(a.fee_s_amt+a.fee_v_amt)";
	String est_amt3 = "(a.paid_amt)";
	String est_amt4 = "(se.ext_s_amt+se.ext_v_amt)";
	String est_amt5 = "(a.req_amt)";
	String est_amt6 = "(a.ext_s_amt+a.ext_v_amt)";
	String est_amt7 = "(a.rent_s_amt+a.rent_v_amt)";

	String est_dt1 = "b.rent_start_dt";
	String est_dt2 = "a.r_fee_est_dt";
	String est_dt3 = "nvl(a.rec_plan_dt,nvl(a.dem_dt,a.paid_end_dt))";
	String est_dt4 = "nvl(se.ext_est_dt, a.cust_plan_dt)";

	String est_dt5 = "a.req_dt";
	String est_dt6 = "nvl(a.ext_est_dt,b.cls_dt)";
	String est_dt7 = "a.est_dt";
		
	String condition1	= "and a.ext_s_amt>0 and a.ext_pay_dt is null";
	String condition2	= "and a.fee_s_amt>0 and a.rc_dt is null and nvl(a.bill_yn,'Y')='Y'";
	String condition3	= "and a.paid_amt>0 and a.vio_cont not like '%통행료%' and a.coll_dt is null and nvl(a.bill_yn,'Y')='Y' and a.paid_st in ('3','4') and nvl(a.no_paid_yn,'N')='N'";
	String condition3_1	= "and a.paid_amt>0 and a.vio_cont not like '%통행료%' and a.coll_dt is null and nvl(a.bill_yn,'Y')='Y' and a.rent_s_cd is null and a.paid_st in ('3','4') and nvl(a.no_paid_yn,'N')='N'";
	String condition3_2 = "and a.paid_amt>0 and a.vio_cont not like '%통행료%' and a.coll_dt is null and nvl(a.bill_yn,'Y')='Y' and a.rent_s_cd is not null and a.paid_st in ('3','4') and nvl(a.no_paid_yn,'N')='N'";
	String condition4	= "and se.ext_s_amt>0 and se.ext_pay_dt is null and nvl(se.bill_yn,'Y')='Y' and nvl(a.no_dft_yn,'N')='N'";
//	String condition4	= "and se.ext_s_amt>0 and se.ext_pay_dt is null and nvl(a.bill_yn,'Y')='Y' and nvl(a.no_dft_yn,'N')='N'";
	String condition4_1	= "and se.ext_s_amt>0 and se.ext_pay_dt is null and nvl(se.bill_yn,'Y')='Y' and b.rent_s_cd is null and nvl(a.no_dft_yn,'N')='N'";
	String condition4_2 = "and se.ext_s_amt>0 and se.ext_pay_dt is null and nvl(se.bill_yn,'Y')='Y' and b.rent_s_cd is not null and nvl(a.no_dft_yn,'N')='N'";
	String condition5	= "and a.req_amt>0 and a.pay_dt is null";
	String condition6	= "and (a.ext_s_amt+a.ext_v_amt) > 0 and a.ext_pay_dt is null and nvl(a.bill_yn,'Y')='Y'";
	String condition7	= "and a.rent_s_amt>0 and a.pay_dt is null and nvl(a.bill_yn,'Y')='Y'";

	
	// 미수금정산 리스트 조회--장기/단기를 같이 조회
	public Vector getSettleList3(String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", sub_query = "";

		String settle_dt = " <= to_char(sysdate,'YYYYMMDD')";
		//임의일자
		if(gubun2.equals("6"))	settle_dt = " <= to_char(to_date('"+AddUtil.ChangeString(st_dt)+"', 'YYYYMMDD'), 'YYYYMMDD')";
	
	
		sub_query = " select a.item_id, b.tax_type, nvl(a.est_dt, ' ') est_dt, a.eval, a.remark, a.gubun2, \n"+
				 " decode(d.sub_l_cd,'',b.rent_l_cd,d.sub_l_cd) rent_l_cd, \n"+
				 " decode(d.sub_l_cd,'',b.rent_mng_id,g.rent_mng_id) rent_mng_id, \n"+
				 " nvl(c.car_mng_id,i.car_mng_id) car_mng_id, \n"+
				 " case when a.rent_seq = '1' then decode(a.rent_s_cd,'',e.client_id,decode(d.cust_st,'1',f.client_id,h.user_id)) else ff.client_id end client_id,  \n"+
				 " decode(a.rent_s_cd,'',e.firm_nm,decode(d.cust_st,'1',f.firm_nm,h.user_nm)) firm_nm,\n "+
				 " nvl(c.car_no,i.car_no) car_no, nvl(c.car_nm,i.car_nm) car_nm, \n"+
				 " nvl(d.rent_s_cd,' ') rent_s_cd, \n"+
				 " a.est_amt,  case when a.rent_seq = '1' then b.r_site else ff.r_site end r_site, \n"+
				 " decode(a.rent_s_cd,'',b.use_yn,nvl(g.use_yn,'Y')) use_yn \n"+
				 " from \n"+
				 " ( "+
				 "      select '1' as rent_seq, a.ext_tm item_id, '보증금' gubun2, '31100' eval, '-' remark, a.ext_est_dt est_dt, '' rent_s_cd, a.rent_l_cd, "+est_amt1+" est_amt from scd_ext a, fee b where a.ext_st  = '0'  and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st and nvl(a.bill_yn,'Y')='Y' and "+est_dt1+" "+settle_dt+" "+condition1+"\n"+
				 "      union all"+
				 "		select '1' as rent_seq, a.ext_tm item_id, '선납금' gubun2, '10800' eval, '-' remark, a.ext_est_dt est_dt, '' rent_s_cd, a.rent_l_cd, "+est_amt1+" est_amt from scd_ext a, fee b where a.ext_st = '1' and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st and nvl(a.bill_yn,'Y')='Y' and "+est_dt1+" "+settle_dt+" "+condition1+"\n"+
				 "      union all"+
				 " 		select '1' as rent_seq, a.ext_tm item_id, '개시대여료' gubun2, '10800' eval, '-' remark, a.ext_est_dt est_dt, '' rent_s_cd, a.rent_l_cd, "+est_amt1+" est_amt from scd_ext a, fee b where a.ext_st = '2'  and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st and nvl(a.bill_yn,'Y')='Y' and "+est_dt1+" "+settle_dt+" "+condition1+"\n"+
				 "      union all"+
				 "      select a.rent_seq, a.fee_tm item_id, '대여료' gubun2,  '10800' eval, a.fee_tm || '회차  ' || decode(a.tm_st1, '0','월대여료','잔액') remark, a.r_fee_est_dt est_dt, '' rent_s_cd, a.rent_l_cd, "+est_amt2+" est_amt from scd_fee a where "+est_dt2+" "+settle_dt+" "+condition2+"\n"+
				 "      union all"+ 
				 "      select '1' rent_seq, ' ' item_id, '연체이자' gubun2,  '93000' eval, '대여료연체이자' remark, to_char(sysdate,'YYYYMMdd') est_dt, '' rent_s_cd, a.rent_l_cd,  case when sum(a.dt) - sum(a.dt2) > 0 then sum(a.dt) - sum(a.dt2) else 0 end  est_amt  from (  select  a.rent_mng_id, a.rent_l_cd, sum(a.dly_fee) DT, 0 DT2  from scd_fee a    where  nvl(a.bill_yn,'Y')='Y' and nvl(to_number(a.dly_days), 0) > 0    group by  a.rent_mng_id, a.rent_l_cd    union all  select  b.rent_mng_id, b.rent_l_cd, 0 DT, sum(b.pay_amt) DT2  	 from  scd_dly b   group by  b.rent_mng_id, b.rent_l_cd	) a  group by a.rent_mng_id, a.rent_l_cd \n"+
				 "      union all"+ 
				 "      select '1' as rent_seq, to_char(a.seq_no) item_id, '과태료' gubun2,  '93000' eval, substr(a.vio_dt,1,8) || ' ' || a.vio_pla || ' ' || a.vio_cont  remark, nvl(a.rec_plan_dt,nvl(a.dem_dt,a.paid_end_dt)) est_dt, a.rent_s_cd, a.rent_l_cd, "+est_amt3+" est_amt from fine a where "+est_dt3+" "+settle_dt+" "+condition3+"\n"+
				 "      union all"+
				 "      select '1' as rent_seq, se.ext_id item_id, '면책금' gubun2,  '10800' eval, a.serv_dt ||' ' || c.off_nm remark, se.ext_est_dt est_dt, b.rent_s_cd, a.rent_l_cd, "+est_amt4+" est_amt from scd_ext se , service a, accident b, serv_off c where se.ext_st = '3' and se.rent_mng_id = a.rent_mng_id and se.rent_l_cd = a.rent_l_cd and se.ext_id = a.serv_id and  a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and a.off_id=c.off_id and "+est_dt4+" "+settle_dt+" "+condition4+"\n"+
				 "      union all"+
				 "      select '1' as rent_seq, a.ext_tm item_id, '위약금' gubun2,  decode( c.car_st, '1', '41400', '41800') eval, b.cls_dt || ' ' || decode(a.ext_tm, '1','위약금','잔액') remark, a.ext_est_dt est_dt, '' rent_s_cd, a.rent_l_cd, "+est_amt6+" est_amt from scd_ext a, cls_cont b, cont c where a.ext_st = '4' and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and  b.rent_mng_id = c.rent_mng_id and b.rent_l_cd = c.rent_l_cd and "+est_dt6+" "+settle_dt+" "+condition6+"\n"+
				 " ) a, cont b, car_reg c, rent_cont d, client e, client f, cont g, users h, car_reg i, client_site j , fee_rtn ff "+
				 " where"+
				 " a.rent_l_cd=b.rent_l_cd(+)\n" +	
				 " and b.car_mng_id=c.car_mng_id(+)\n" +	
				 " and a.rent_s_cd=d.rent_s_cd(+)\n" +	
				 " and b.client_id=e.client_id(+)\n" +	
				 " and b.client_id like '%"+t_wd+"%'\n" +	
				 " and b.client_id=j.client_id(+) and b.r_site=j.seq(+)"+
				 " and a.rent_l_cd = ff.rent_l_cd(+) and a.rent_seq = ff.rent_seq(+) \n" +	
				 " and d.cust_id=f.client_id(+)\n" +	
				 " and d.sub_l_cd=g.rent_l_cd(+)\n" +	
				 " and d.cust_id=h.user_id(+) and d.car_mng_id=i.car_mng_id(+)";

		query = " select "+
				" t.use_yn, nvl(t.item_id, ' ') item_id, t.est_dt, t.eval, t.remark, t.client_id, nvl(t.r_site,' ') r_site, t.gubun2, nvl(t.car_no, ' ') car_no,  t.rent_l_cd, t.rent_mng_id, t.rent_s_cd, t.est_amt, \n"+
				" decode(t.tax_type,'2',nvl(t.r_site,e.firm_nm),e.firm_nm) as ven_nm, \n"+
	 			" nvl(decode(t.TAX_TYPE,'2',nvl(t.r_site,e.ven_code),e.ven_code),' ') ven_code \n"+
				" from"+
				"	 ("+sub_query+")  t, client e,  client_site j  "+
				" where est_amt>0 and t.client_id=e.client_id(+) and t.client_id=j.client_id(+) and t.r_site=j.seq(+) \n";
		
		query += " order by use_yn desc, est_dt, ven_code ";

	
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
			System.out.println("[IncomDatabase:getSettleList3]\n"+e);
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
		
	// 미수금정산 리스트 조회--
	public Vector getSettleList4(String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", sub_query = "";
		String d_query="";

		String settle_dt = " < to_char(sysdate,'YYYYMMDD')";
		//임의일자
		if(gubun2.equals("6"))	settle_dt = " < to_char(to_date('"+AddUtil.ChangeString(st_dt)+"', 'YYYYMMDD'), 'YYYYMMDD')";
					
		String settle_dt1 = " >= to_char(sysdate,'YYYYMMDD')";

		if(gubun2.equals("6"))	settle_dt1 = " >= to_char(to_date('"+AddUtil.ChangeString(st_dt)+"', 'YYYYMMDD'), 'YYYYMMDD')";
				
		if ( s_kd.equals("1") ) d_query = " and c.client_id ='";
		
		if ( s_kd.equals("2") ) d_query = " and c.rent_l_cd ='";
						
		query =	 "	                    select  '보증금' gubun2, nvl(sum(a.ext_s_amt+a.ext_v_amt),0) est_amt from scd_ext a, fee b, cont_n_view c where a.ext_st  = '0'  and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd=b.rent_l_cd  and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and a.rent_st=b.rent_st and nvl(a.bill_yn,'Y')='Y' and "+est_dt1+" "+settle_dt+" "+condition1+ " " + d_query + t_wd+ "' \n"+
				 " 		  union all 	select  '개시대여료' gubun2, nvl(sum(a.ext_s_amt+a.ext_v_amt),0) est_amt from scd_ext a, fee b, cont_n_view c where a.ext_st = '2'  and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and a.rent_st=b.rent_st and nvl(a.bill_yn,'Y')='Y' and "+est_dt1+" "+settle_dt+" "+condition1+ " " + d_query + t_wd+ "' \n"+
				 "	      union all		select  '선납금' gubun2,  nvl(sum(a.ext_s_amt+a.ext_v_amt),0)  est_amt from scd_ext a, fee b, cont_n_view c  where a.ext_st = '1' and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and a.rent_st=b.rent_st and nvl(a.bill_yn,'Y')='Y'  and "+est_dt1+" "+settle_dt+" "+condition1+  " " + d_query + t_wd+ "' \n"+
				 "	      union all     select  '과태료' gubun2, nvl(sum(a.paid_amt),0) est_amt from fine a, cont_n_view c where  a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd  " + d_query +  t_wd+ "' and "+est_dt3+" "+settle_dt+" "+condition3+" \n"+
				 "	      union all     select  '면책금' gubun2, nvl(sum(se.ext_s_amt+se.ext_v_amt),0) est_amt from scd_ext se , service a, accident b, cont_n_view c where se.ext_st = '3' and se.rent_mng_id = a.rent_mng_id and se.rent_l_cd = a.rent_l_cd and se.rent_mng_id = c.rent_mng_id and se.rent_l_cd = c.rent_l_cd and se.ext_id = a.serv_id and  a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and "+est_dt4+" "+settle_dt+" "+condition4+ " " + d_query +  t_wd+ "' \n"+
				 "	      union all     select  '미납대여료' gubun2, nvl(sum(a.fee_s_amt+a.fee_v_amt),0) est_amt from scd_fee a , cont_n_view c where  a.rent_mng_id = c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and  "+est_dt2+" "+settle_dt+" "+condition2+ " " + d_query +  t_wd+ "' \n"+
				 "	      union all     select  '연체이자' gubun2,   case when sum(a.dt) - sum(a.dt2) > 0 then sum(a.dt) - sum(a.dt2) else 0 end  est_amt  from (  select  a.rent_mng_id, a.rent_l_cd, sum(a.dly_fee) DT, 0 DT2  from scd_fee a    where  nvl(a.bill_yn,'Y')='Y' and nvl(to_number(a.dly_days), 0) > 0    group by  a.rent_mng_id, a.rent_l_cd    union all  select  b.rent_mng_id, b.rent_l_cd, 0 DT, sum(b.pay_amt) DT2  	 from  scd_dly b   group by  b.rent_mng_id, b.rent_l_cd	) a , cont_n_view c where a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd " + d_query + t_wd+ "' and c.use_yn = 'Y' \n"+
				 "	      union all     select  '대여료' gubun2, nvl(sum(a.fee_s_amt+a.fee_v_amt),0) est_amt from scd_fee a , cont_n_view c,  (select rent_mng_id, rent_l_cd, min(to_number(fee_tm)) fee_tm from scd_fee where rc_dt is null and nvl(bill_yn,'Y')='Y'  group by rent_mng_id, rent_l_cd ) d where  a.rent_mng_id = c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and a.rent_mng_id = d.rent_mng_id and d.rent_l_cd=c.rent_l_cd  and a.fee_tm = d.fee_tm and "+est_dt2+" "+settle_dt1+" "+condition2+ " " + d_query + t_wd+ "' \n"+
				 "	      union all     select  '해지정산금' gubun2, nvl(sum(a.ext_s_amt+a.ext_v_amt),0) est_amt from scd_ext a, cls_cont b, cont c where a.ext_st = '4' and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and  b.rent_mng_id = c.rent_mng_id and b.rent_l_cd = c.rent_l_cd " +condition6+ " " + d_query + t_wd+ "'";
			
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
			System.out.println("[IncomDatabase:getSettleList4]\n"+e);
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
	 *	대여료 스케줄
	 */
	public Vector getFeeList(String m_id, String l_cd, String client_id, String mode, String gubun2, String st_dt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		//연체료 계산 기준일-현재
		String gubun2_query = "sysdate";
			 
				 
		String query = "";
		 query = "  select t.item_id, t.est_dt, t.eval, t.remark, t.client_id, nvl(t.r_site, ' ') r_site, t.gubun2, nvl(t.car_no, ' ') car_no,  t.rent_l_cd, t.rent_mng_id, t.rent_s_cd, t.est_amt, \n"+
		         "   decode(t.tax_type,'2',nvl(t.r_site,e.firm_nm),e.firm_nm) as ven_nm ,	\n"+
		 		 "   decode(t.TAX_TYPE,'2',nvl(t.r_site,e.ven_code),e.ven_code) ven_code 	from  (	\n"+
	   			 	 " select a.item_id,  a.rent_seq, a.gubun2, b.tax_type, \n"+
				 	 " case when a.rent_seq = '1' then b.client_id else f.client_id end client_id, \n"+
  				 	 " case when a.rent_seq = '1' then b.r_site else f.r_site end r_site, a.eval, nvl(a.car_no, ' ') car_no, a.rent_mng_id, a.rent_l_cd , a.remark, nvl(a.est_dt, ' ') est_dt, a.est_amt, ' ' rent_s_cd \n"+
	               	 "	from ( \n" +
				        " select '1' as rent_seq, b.ext_tm item_id, '보증금' gubun2,  '31100' eval, c.car_no, b.rent_mng_id, b.rent_l_cd, '-' remark, \n"+
						" b.ext_est_dt as est_dt, b.ext_s_amt as s_amt, b.ext_v_amt as v_amt, (b.ext_s_amt+b.ext_v_amt) est_amt \n "+ 
						" from cont a, scd_ext b, car_reg c \n"+
						" where b.ext_st  = '0' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.ext_s_amt > 0 and a.car_mng_id = c.car_mng_id(+) \n"+
						" and b.ext_pay_dt is null and nvl(b.bill_yn,'Y')='Y' \n" +
						" union all \n" +
						 " select '1' as rent_seq, b.ext_tm item_id, '선납금' gubun2,  '10800' eval, c.car_no, b.rent_mng_id, b.rent_l_cd, '-' remark, \n"+
						" b.ext_est_dt as est_dt, b.ext_s_amt as s_amt, b.ext_v_amt as v_amt, (b.ext_s_amt+b.ext_v_amt) est_amt \n "+ 
						" from cont a, scd_ext b, car_reg c \n"+
						" where b.ext_st  = '1' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.ext_s_amt > 0 and a.car_mng_id = c.car_mng_id(+) \n"+
						" and b.ext_pay_dt is null and nvl(b.bill_yn,'Y')='Y' \n" +
						" union all \n" +		
						" select '1' as rent_seq, b.ext_tm item_id, '개시대여료' gubun2,  '10800' eval, c.car_no, b.rent_mng_id, b.rent_l_cd, '-' remark, \n"+
						" b.ext_est_dt as est_dt, b.ext_s_amt as s_amt, b.ext_v_amt as v_amt, (b.ext_s_amt+b.ext_v_amt) est_amt \n"+ 
						" from cont a, scd_ext b, car_reg c \n"+
						" where b.ext_st  = '2' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.ext_s_amt > 0 and a.car_mng_id = c.car_mng_id(+) \n"+
						" and b.ext_pay_dt is null and nvl(b.bill_yn,'Y')='Y' \n" +
						" union all \n" +
						" select b.rent_seq, b.fee_tm item_id, '대여료' gubun2,  '10800' eval, c.car_no, b.rent_mng_id, b.rent_l_cd, b.fee_tm || '회차  ' || decode(b.tm_st1, '0','월대여료','잔액') remark, \n"+
						" b.fee_est_dt as est_dt, b.fee_s_amt as s_amt, b.fee_v_amt as v_amt, (b.fee_s_amt+b.fee_v_amt) est_amt \n"+ 
						" from cont a, scd_fee b, car_reg c \n"+
						" where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.fee_s_amt > 0 and a.car_mng_id = c.car_mng_id \n"+
						" and b.fee_est_dt >= to_char("+gubun2_query+", 'YYYYMMDD') and b.rc_dt is null and nvl(b.bill_yn,'Y')='Y' \n" +		
						" ) a, cont b, car_reg c,  fee_rtn f  \n" +	
						" where \n" +	
						" a.rent_l_cd=b.rent_l_cd(+) \n" +	
						" and a.rent_l_cd =f.rent_l_cd(+) and a.rent_seq = f.rent_seq(+) \n" +	
						" and b.car_mng_id=c.car_mng_id(+) and b.client_id='"+client_id+"' \n" +	
						" ) t, client e,  client_site j   \n" +
						" where t.client_id=e.client_id(+) and t.client_id=j.client_id(+) and t.r_site=j.seq(+)  \n" ;
						
	//	if(mode.equals("client"))	query += " and t.client_id='"+client_id+"'";
	//	else						query += " and t.rent_l_cd='"+l_cd+"'";

		query += " order by est_dt, ven_code";

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
			System.out.println("[SettleDatabase:getFeeList]\n"+e);
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
	
	
	 	//은행처리리스트내역 등록 
   
	public boolean insertIncomItem(IncomItemBean base)
	{
	
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
											    	
		String query = " insert into incom_item "+
						"(INCOM_DT,		INCOM_SEQ,		SEQ_ID,		ITEM_NM, 	 "+
						" ITEM_DT,	ITEM_SEQ ) values "+
						"(replace(?, '-', ''), ?, INCOM_ITEM_SEQ.nextval, ?, "+
						" replace(?, '-', ''), ?) ";
						
		try 
		{
			conn.setAutoCommit(false);			
			
			pstmt = conn.prepareStatement(query);
  			
			pstmt.setString(1, base.getIncom_dt());
			pstmt.setInt(2,    base.getIncom_seq());
			pstmt.setString(3, base.getItem_nm().trim());
			pstmt.setString(4, base.getItem_dt());			
			pstmt.setInt(5, base.getItem_seq());
			

		    pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
		} catch (Exception e) {
            try{
				System.out.println("[IncomDatabase:insertIncomItem]"+e);
                conn.rollback();
            }catch(SQLException _ignored){}
			e.printStackTrace();
	  		flag = false;
		} finally {
			try{
				conn.setAutoCommit(true);
              	if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}	
 
		
	//입금처리전 등록 
	
	public IncomBean insertIncom(IncomBean base)
	{
	
		getConnection();
		PreparedStatement pstmt = null;
		Statement stmt = null;
		ResultSet rs = null;
		  
		String query_seq = "";	
		int incom_seq = 0;		
		
		String incom_dt = AddUtil.replace(base.getIncom_dt(),"-","");
		String card_nm = "";
					
	    query_seq = "select nvl(max(incom_seq)+1, 1)  from incom where incom_dt = '" + incom_dt + "'";	
	
		String query = " insert into incom "+
						"(INCOM_DT,		INCOM_SEQ,		INCOM_AMT,	 INCOM_GUBUN,  JUNG_TYPE,	IP_METHOD, "+
						" BANK_NM,      BANK_NO,        REMARK,		 BANK_OFFICE,   " +
						" CARD_NM,      CARD_NO,        CARD_OWNER,  CARD_GET_ID,  CASH_AREA,   CASH_GET_ID, " +
						" RENT_L_CD,    CLIENT_ID,      NOT_YET,     PAY_GUR,      PAY_GUR_NM,  PAY_GUR_REL, "+
						" EXCEPT_ST1,   EXCEPT_ST2,     PAY_REASON,  PAY_SAC_ID,   NEOM_YN,     VEN_CODE, "+ 
						" CONT,         TRUSBILL_YN,    MAIL_YN,     REG_ID,       REG_DT,      SAC_ID,       SAC_DT, P_GUBUN, CARD_CD, ACCT_SEQ, TR_DATE_SEQ  ) values "+
						"(replace(?, '-', ''), ?, ?, ?, ?, ?, "+
						" ?, ?, ?, ?, "+
					    " ?, ?, ?, ?, ?, ?, "+
						" ?, ?, ?, ?, ?, ?, "+
						" ?, ?, ?, ?, ?, ?, "+
						" ?, ?, ?, ?, sysdate, ?, sysdate, ?, ?, ?, ?  )";
						
		try 
		{
			conn.setAutoCommit(false);
			
			stmt = conn.createStatement();
            rs = stmt.executeQuery(query_seq);
            if(rs.next())
            	incom_seq = rs.getInt(1);
            rs.close();
			stmt.close();
			
			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, incom_dt);
			pstmt.setInt(2, incom_seq);
			pstmt.setLong(3, base.getIncom_amt());
			pstmt.setString(4, base.getIncom_gubun());
		    pstmt.setString(5, base.getJung_type());			
			pstmt.setString(6, base.getIp_method());	
			pstmt.setString(7, base.getBank_nm().trim());			
			pstmt.setString(8, base.getBank_no().trim());
			pstmt.setString(9, base.getRemark().trim());
			pstmt.setString(10, base.getBank_office().trim());
				
			if (base.getCard_cd().equals("1")) { 	
			    card_nm = "BC";
			} else if (base.getCard_cd().equals("2")) { 
				card_nm = "국민";
			} else if (base.getCard_cd().equals("4")) { 
				card_nm = "하나";	
			} else if (base.getCard_cd().equals("5")) { 
				card_nm = "롯데";	
			} else if (base.getCard_cd().equals("6")) { 
				card_nm = "현대";
			} else if (base.getCard_cd().equals("7")) { 
				card_nm = "삼성";	
			} else if (base.getCard_cd().equals("8")) { 
				card_nm = "씨티";	
			} else if (base.getCard_cd().equals("9")) { 
				card_nm = "KCP";		
			} else if (base.getCard_cd().equals("10")) { 
				card_nm = "KCP2";	
			} else if (base.getCard_cd().equals("11")) { 
				card_nm = "나이스";	
			} else if (base.getCard_cd().equals("12")) { 
				card_nm = "페이엣";												
			} else if (base.getCard_cd().equals("3")) { 
				card_nm = "신한";		
			} else if (base.getCard_cd().equals("13")) { 
				card_nm = "이노페이";			
			}				
			
			pstmt.setString(11, card_nm);	
				
			pstmt.setString(12, base.getCard_no().trim());			
			pstmt.setString(13, base.getCard_owner().trim());			
			pstmt.setString(14, base.getCard_get_id().trim());
			pstmt.setString(15, base.getCash_area().trim());
			pstmt.setString(16, base.getCash_get_id().trim());
			pstmt.setString(17, base.getRent_l_cd().trim());
			pstmt.setString(18, base.getClient_id().trim());			
			pstmt.setString(19, base.getNot_yet());
			pstmt.setString(20, base.getPay_gur().trim());
			pstmt.setString(21, base.getPay_gur_nm().trim());
			pstmt.setString(22, base.getPay_gur_rel().trim());			
			pstmt.setString(23, base.getExcept_st1());			
			pstmt.setString(24, base.getExcept_st2());
			pstmt.setString(25, base.getPay_reason().trim());
			pstmt.setString(26, base.getPay_sac_id().trim());
			pstmt.setString(27, base.getNeom_yn());
			pstmt.setString(28, base.getVen_code().trim());			
			pstmt.setString(29, base.getCont().trim());
			pstmt.setString(30, base.getTrusbill_yn());
			pstmt.setString(31, base.getMail_yn());
			pstmt.setString(32, base.getReg_id().trim());			
			pstmt.setString(33, base.getSac_id().trim());	
			pstmt.setString(34, base.getP_gubun().trim());	
			pstmt.setString(35, base.getCard_cd().trim());			
			
			pstmt.setString(36, base.getAcct_seq().trim());			
			pstmt.setString(37, base.getTr_date_seq().trim());			
			
		    pstmt.executeUpdate();
	
			pstmt.close();
			conn.commit();
			
		} catch (SQLException e) {
			System.out.println("[IncomDatabase:insertIncom]\n"+e);
	  		e.printStackTrace();
	  		base = null;
			conn.rollback();
			base.setIncom_seq(0);
	  	} catch (Exception e) {
		  	System.out.println("[IncomDatabase:insertIncom]\n"+e);
	  		e.printStackTrace();
	  		base = null;
			conn.rollback();
			base.setIncom_seq(0);
		} finally {
			try{
			    if(rs != null) 		rs.close();
                if(stmt != null) 	stmt.close();
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			base.setIncom_seq(incom_seq);
			return base;
		}
	}
	
	//처리내역 리스트 조회  - 휴/대차료 추가할 것
	
	public Vector getIncomItemList(String incom_dt, int incom_seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
	
		
		query = " select  a.*, nvl(f.firm_nm, r.firm_nm) firm_nm, nvl(f.client_id, r.client_id) client_id, nvl(c.car_no, rc_c.car_no) car_no, c.car_nm, c.car_mng_id , \n"+
				" decode(a.gubun, '01', decode(a.tm1,'0','보증금','1', '선납금', '2','개시대여료', '5', '승계수수료', '7', '구매보조금' ), '02', decode(a.tm1,'0','대여료','대여료 잔액'), '03', '연체이자', '04', '과태료' , '05', '면책금' , '06', '휴차료', '07', '대차료', '09', '해지정산금' , '10',  decode(a.rent_st,'2', '정비대차', '6','월렌트보증금','월렌트료')  ) tm1_nm \n"+
			 	" from cont b, car_reg c, fee d, fee_rtn e, client f , client r , incom ic,  rent_cont rc ,  car_reg rc_c, \n"+
				" ( select '01' gubun, rent_mng_id, rent_l_cd, '' rent_s_cd, ext_tm tm, rent_st, rent_seq, ext_st tm1, ext_id tm2, ext_est_dt est_dt, (ext_s_amt+ext_v_amt) est_amt, ext_pay_amt pay_amt, seqid seqid \n"+
				"    from scd_ext  where incom_dt =  ? and incom_seq =  ?  and ext_st in ('0','1', '2', '5', '7') \n"+
				"   union all \n"+
				"  select '02' gubun, rent_mng_id, rent_l_cd, '' rent_s_cd,  fee_tm tm, rent_st, rent_seq, tm_st1 tm1, tm_st2 tm2, r_fee_est_dt est_dt, (fee_s_amt+ fee_v_amt) est_amt, rc_amt pay_amt, '' seqid \n"+
				"    from scd_fee  where incom_dt =  ? and incom_seq =  ? \n"+
				"   union all \n"+
				"  select '03' gubun, a.rent_mng_id, a.rent_l_cd, '' rent_s_cd,  '' tm, v.fee_rent_st rent_st, '' rent_seq, '' tm1, '' tm2, '' est_dt, 0 est_amt, pay_amt pay_amt, ''  seqid  \n"+
  				"    from scd_dly a, cont_n_view v  where a.incom_dt =   ?  and a.incom_seq =  ?  and a.rent_mng_id=v.rent_mng_id and a.rent_l_cd= v.rent_l_cd  \n"+
  				"   union all \n"+  		
				"  select '04' gubun, a.rent_mng_id, a.rent_l_cd, '' rent_s_cd, '' tm, '' rent_st, '' rent_seq, '' tm1, to_char(a.seq_no) tm2, nvl(proxy_dt, paid_end_dt) est_dt, paid_amt est_amt, case when coll_dt is null then 0 else  paid_amt end  pay_amt, '' seqid \n"+
  				"    from fine a  where a.incom_dt =   ?  and a.incom_seq =  ?     \n"+			 	
			 	"   union all \n"+
			 	"  select '05' gubun, s.rent_mng_id, s.rent_l_cd, '' rent_s_cd, ext_tm tm, v.fee_rent_st rent_st,  rent_seq , ext_st tm1, ext_id tm2, ext_est_dt est_dt, (ext_s_amt+ext_v_amt) est_amt, ext_pay_amt pay_amt, seqid seqid  \n"+
   				"    from scd_ext s, cont_n_view v  where s.incom_dt =  ? and s.incom_seq =  ? and s.ext_st = '3' and s.rent_mng_id = v.rent_mng_id and s.rent_l_cd = v.rent_l_cd \n"+
			 	"   union all \n"+
			 	"  select '09' gubun, s.rent_mng_id, s.rent_l_cd, '' rent_s_cd, ext_tm tm, v.fee_rent_st rent_st,  rent_seq , ext_st tm1, ext_id tm2, ext_est_dt est_dt, (ext_s_amt+ext_v_amt) est_amt, ext_pay_amt pay_amt, '' seqid  \n"+
   				"    from scd_ext s, cont_n_view v  where s.incom_dt =  ? and s.incom_seq =  ? and s.ext_st = '4' and s.rent_mng_id = v.rent_mng_id and s.rent_l_cd = v.rent_l_cd \n"+
   				"   union all \n"+
			 	"  select '10' gubun, '' rent_mng_id, '' rent_l_cd, s.rent_s_cd,  to_char(s.tm)  tm, v.rent_st,  '' rent_seq , '' tm1,  '' tm2, s.est_dt est_dt,  (s.rent_s_amt+s.rent_v_amt) est_amt, s.pay_amt pay_amt, '' seqid  \n"+
   				"    from scd_rent s, rent_cont v  where s.incom_dt =  ? and s.incom_seq =  ? and  s.rent_s_cd = v.rent_s_cd \n"+
			 	"   union all \n"+
			 	"  select decode(a.pay_gu, '1', '06', '07') gubun,  c.rent_mng_id, c.rent_l_cd , '' rent_s_cd, ext_tm tm, c.fee_rent_st rent_st , rent_seq, '' tm1,  to_char(a.seq_no) tm2, req_dt est_dt, (ext_s_amt+ext_v_amt) est_amt, ext_pay_amt pay_amt,'' seqid  \n"+
				" from scd_ext se, my_accid a, cont_n_view c \n"+
   				"    where   se.incom_dt = ? and se.incom_seq = ? and  se.rent_mng_id = c.rent_mng_id and se.rent_l_cd = c.rent_l_cd \n" +
   				"    and  c.car_mng_id = a.car_mng_id and substr(se.ext_id, 1, 6) = a.accid_id and substr(se.ext_id, 7) = to_char(a.seq_no) ) a \n"+
       		 	" where  ic.incom_dt  =  ? and ic.incom_seq =  ? and a.rent_mng_id=b.rent_mng_id(+) and a.rent_l_cd=b.rent_l_cd(+)  and a.rent_s_cd = rc.rent_s_cd(+)  and  b.car_mng_id=c.car_mng_id(+) and  rc.car_mng_id = rc_c.car_mng_id(+)  \n"+    
			    " and    a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+) and a.rent_st=d.rent_st(+)  \n"+ 
			    " and    a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+) and a.rent_st=e.rent_st(+) and a.rent_seq=e.rent_seq(+)   \n"+
			    " and    e.client_id=f.client_id(+) and b.client_id = r.client_id(+)   \n"+
			   	" order by a.gubun, a.est_dt,  a.tm  ";
      
		try {
								
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, incom_dt);
			pstmt.setInt(2, incom_seq);
			pstmt.setString(3, incom_dt);
			pstmt.setInt(4, incom_seq);
			pstmt.setString(5, incom_dt);
			pstmt.setInt(6, incom_seq);
			pstmt.setString(7, incom_dt);
			pstmt.setInt(8, incom_seq);
			pstmt.setString(9, incom_dt);
			pstmt.setInt(10, incom_seq);
			pstmt.setString(11, incom_dt);
			pstmt.setInt(12, incom_seq);
			pstmt.setString(13, incom_dt);
			pstmt.setInt(14, incom_seq);
			pstmt.setString(15, incom_dt);
			pstmt.setInt(16, incom_seq);
			pstmt.setString(17, incom_dt);
			pstmt.setInt(18, incom_seq);
			
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
			System.out.println("[IncomDatabase:getIncomItemList]\n"+e);
			System.out.println("[IncomDatabase:getIncomItemList]\n"+query);
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
	 *	//jip_cms  출금의뢰일 조회하기
	 */
	public Vector getAJipCmsDate()
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select adate from jip_cms where adate > '20201231' group by adate order by adate desc";

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
			System.out.println("[IncomDatabase:getAJipCmsDate]\n"+e);
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
	
	/*
	 *	jip_cms 데이타 생성  프로시져 호출
	*/
	public String call_sp_jip_cms_reg(String a_date)
	{
    	getConnection();
    	
    	String query = "{CALL P_JIP_CMS_REG (?,?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
			cstmt = conn.prepareCall(query);
			
			cstmt.setString(1, a_date);
			cstmt.registerOutParameter( 2, java.sql.Types.VARCHAR );
			
			cstmt.execute();
			sResult = cstmt.getString(2); // 결과값
			cstmt.close();
				
	
		} catch (SQLException e) {
			System.out.println("[IncomDatabase:call_sp_jip_cms_reg]\n"+e);
			e.printStackTrace();
		} finally {
			try{
			     if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}	

	/**
	 *	//jip_cms  출금의뢰일 조회하기
	 */
	public Vector getJipCmsDateList(String adate, String org_code, String s_kd, String t_wd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String d_query = "";
		String o_query = "";
		
		if ( !org_code.equals("") ) o_query = " and  nvl(a.org_code, '9951572587') =  '"+ org_code + "'";
			
		if ( s_kd.equals("1") ) d_query = " and nvl(f.r_site,c.firm_nm) like '%"+ t_wd + "%'";
		if ( s_kd.equals("1") ) d_query = " and nvl(f.r_site,c.firm_nm) like '%"+ t_wd + "%'";
		if ( s_kd.equals("2") ) d_query = " and  d.car_no like '%"+ t_wd + "%'";
		if ( s_kd.equals("3") ) d_query = " and  b.rent_l_cd like '%"+ t_wd + "%'";
		if ( s_kd.equals("4") ) d_query = " and  nvl(a.org_code, '9951572587') like '%"+ t_wd + "%'";

		query = " select a.*, decode(b.tax_type,'2',nvl(f.r_site,c.firm_nm),c.firm_nm) as firm_nm, d.car_no, nvl(a.org_code, '9951572587') r_org_code \n"+
			    " from jip_cms a, cont b, client c, car_reg d, client_site f \n"+
		 		" where  a.adate > '20151231' " + o_query + "  and a.adate = replace('"+ adate + "', '-','') " + d_query +
		 		" and a.acode=b.rent_l_cd and b.client_id=c.client_id and b.car_mng_id=d.car_mng_id(+) and b.client_id=f.client_id(+) and b.r_site=f.seq(+)"+
				"  order by a.org_code, a.seq ";

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
			System.out.println("[IncomDatabase:getJipCmsDateList]\n"+e);
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
	 *	//jip_cms  출금의뢰일 조회하기
	 */
	public Vector getJipCmsDateList(String adate, String s_kd, String t_wd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String d_query = "";
				
		if ( s_kd.equals("1") ) d_query = " and nvl(f.r_site,c.firm_nm) like '%"+ t_wd + "%'";
		if ( s_kd.equals("2") ) d_query = " and  d.car_no like '%"+ t_wd + "%'";
		if ( s_kd.equals("3") ) d_query = " and  b.rent_l_cd like '%"+ t_wd + "%'";
		if ( s_kd.equals("4") ) d_query = " and  nvl(a.org_code, '9951572587') like '%"+ t_wd + "%'";

		query = " select a.*, decode(b.tax_type,'2',nvl(f.r_site,c.firm_nm),c.firm_nm) as firm_nm, d.car_no, nvl(a.org_code, '9951572587') r_org_code \n"+
			    " from jip_cms a, cont b, client c, car_reg d, client_site f \n"+
		 		" where  a.adate > '20151231' and a.adate = replace('"+ adate + "', '-','') " + d_query +
		 		" and a.acode=b.rent_l_cd and b.client_id=c.client_id and b.car_mng_id=d.car_mng_id(+) and b.client_id=f.client_id(+) and b.r_site=f.seq(+)"+
				"  order by a.org_code, a.seq ";

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
			System.out.println("[IncomDatabase:getJipCmsDateList]\n"+e);
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
	
	//cms 인출 데이타 생성여부       
	public int  getCntCmsBit( String adate)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";		
		int cnt = 0;
					
		query = " select count(0) "+
 				"  from   jip_cms "+
				"  where  adate = replace('"+adate+"', '-', '') ";
				 			 		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		if(rs.next())
			{		
				cnt = rs.getInt(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[IncomDatabase:getCntCmsBit]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return cnt;
		}
	}
	
	//cms 인출 데이타 생성여부   -cmsbank에 사용할거 
	public int  getCntFile21CmsBit(String adate)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";		
		int cnt = 0;
					
		query = " select count(0) "+
 				"  from  cms.file_ea21 "+
				"  where  adate = replace('"+adate+"', '-', '') ";
				 			 		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		if(rs.next())
			{		
				cnt = rs.getInt(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[IncomDatabase:getCntFile21CmsBit]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return cnt;
		}
	}
	
	/*
	 *	jip_cms 데이타 생성  프로시져 호출
	*/
	public String call_sp_file21_cms_reg(String a_date)
	{
    	getConnection();
    	
    	String query = "{CALL P_FILE21_CMS_REG (?,?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
			cstmt = conn.prepareCall(query);
			
			cstmt.setString(1, a_date);
			cstmt.registerOutParameter( 2, java.sql.Types.VARCHAR );
			
			cstmt.execute();
			sResult = cstmt.getString(2); // 결과값
			cstmt.close();
				
	
		} catch (SQLException e) {
			System.out.println("[IncomDatabase:call_sp_file21_cms_reg]\n"+e);
			e.printStackTrace();
		} finally {
			try{
			     if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}	
	
	
	//cms 인출 데이타 생성후 ok-bank나 금융결재원에 데이타 처리를한 경우       
	public String  getJipCmsBit( String adate)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";		
		String jbit = "";
				
		query = " select distinct jbit "+
 				"  from   jip_cms "+
				"  where  adate = replace('"+adate+"', '-', '') ";
				 			 		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		if(rs.next())
			{		
				jbit = rs.getString(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[IncomDatabase:getJipCmsBit]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return jbit;
		}
	}
	
	public int  getJipCmsCnt( String adate)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";		
		int cnt = 0;
				
		query = " select count(0) "+
 				"  from   acms "+
				"  where  adate = replace('"+adate+"', '-', '') ";
				 			 		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		if(rs.next())
			{		
				cnt = rs.getInt(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[IncomDatabase:getJipCmsCnt]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return cnt;
		}
	}
	
	/**
	 *	cms 인출 삭제 
	 */
	public boolean deleteJipCms(String adate)
	{
		getConnection();
		boolean flag = true;
		String query = "delete from jip_cms  "+
						" where adate= replace(?, '-', '')";  //2
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(true);

			pstmt = conn.prepareStatement(query);
					
			pstmt.setString(1, adate);
		
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
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
	 *	//cms member 조회하기
	 */
	public Vector getMemberCmsList(String s_kd, String t_wd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String d_query = "";
		
	//	if ( s_kd.equals("1") ) d_query = " and nvl(f.r_site,c.firm_nm) like '%"+ t_wd + "%'";
	//	if ( s_kd.equals("2") ) d_query = " and  d.car_no like '%"+ t_wd + "%'";
	//	if ( s_kd.equals("3") ) d_query = " and  b.rent_l_cd like '%"+ t_wd + "%'";
			
	//	 변경건 	
	/*
		query = "select   d.cms_start_dt , cm.ama_id, a.rent_l_cd, b.firm_nm, g.car_no, d.cms_day, d.cms_dep_nm, replace(d.cms_dep_ssn, '-', '') cms_dep_ssn, f.cms_bk, d.cms_bank,d.cms_acc_no, \n"+
			     "	'0' cms_status,  nvl(al.cms_code, g.cms_code)   org_code , u.user_nm    \n"+	
			      "	from cont a, client b,  users u, cms.member_user c,  cont_etc et,  \n"+
			      "	     (select a.* from cms_mng a,   (select rent_mng_id, rent_l_cd, max(seq) seq from cms_mng  where app_dt is not null group by rent_mng_id, rent_l_cd) b   where a.rent_l_cd=b.rent_l_cd and a.seq=b.seq) d, \n"+
			      "	     (select * from code where c_st='0003') f, car_reg g,   allot al , cms_info cm \n"+			
			      "	where \n"+
			   	"      nvl(a.use_yn, 'Y') ='Y'  and a.bus_id= u.user_id(+)  \n"+ //살아있는계약 
				"      and a.client_id=b.client_id \n"+
				"      and a.rent_l_cd=c.cms_primary_seq(+) \n"+
				"      and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+) \n"+
				"      and a.rent_mng_id=al.rent_mng_id(+) and a.rent_l_cd=al.rent_l_cd(+)   \n"+
				"		 and a.rent_mng_id=et.rent_mng_id(+) and a.rent_l_cd=et.rent_l_cd(+)   \n"+
             "      and et.rent_suc_dt is null	   \n"+
             "      and nvl(al.cms_code, g.cms_code) = cm.org_code     \n"+
       	//	"      and al.cms_code = cm.org_code  \n"+       		
       		"      and  a.car_gu = '1' \n"+       		
				"      and d.cms_bank=f.nm(+) \n"+
				"      and a.car_mng_id=g.car_mng_id(+) \n"+
				"      and  ( c.cms_primary_seq is null  or  d.reg_st = '11'  ) \n"+  //--cust 미등록건 
				"      and d.rent_l_cd is not null \n"+    //--cms_mng 등록건 
				" union  \n"+
			   "  select   d.cms_start_dt , cm.ama_id, a.rent_l_cd, b.firm_nm, g.car_no, d.cms_day, d.cms_dep_nm, replace(d.cms_dep_ssn, '-', '') cms_dep_ssn, f.cms_bk, d.cms_bank,d.cms_acc_no, \n"+
			   "	'0' cms_status,  nvl(al.cms_code,  nvl(g.cms_code, '9951572587') )   org_code ,  u.user_nm    \n"+	
			   "	from cont a, client b,  users u, cms.member_user c, \n"+
			   "	     (select a.* from cms_mng a,   (select rent_mng_id, rent_l_cd, max(seq) seq from cms_mng  where app_dt is not null group by rent_mng_id, rent_l_cd) b   where a.rent_l_cd=b.rent_l_cd and a.seq=b.seq) d, \n"+
			   "	     (select * from code where c_st='0003') f, car_reg g,   allot al , cms_info cm \n"+			
			    "	where \n"+
			   	"      nvl(a.use_yn, 'Y') ='Y'  and a.bus_id= u.user_id(+)  \n"+ //살아있는계약 
				"      and a.client_id=b.client_id \n"+
				"      and a.rent_l_cd=c.cms_primary_seq(+) \n"+
				"      and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+) \n"+
				"      and a.rent_mng_id=al.rent_mng_id(+) and a.rent_l_cd=al.rent_l_cd(+)   \n"+
				"		and nvl(al.cms_code,  nvl(g.cms_code, '9951572587') )   = cm.org_code   \n"+
       //		"      and nvl(al.cms_code, '9951572587') = cm.org_code  \n"+     
       	   "      and ( a.car_gu not in ( '1') or c.cms_primary_seq is not null  ) 	\n"+     
				"      and d.cms_bank=f.nm(+)  \n"+
				"      and a.car_mng_id=g.car_mng_id(+) \n"+
				"      and  ( c.cms_primary_seq is null  or  d.reg_st = '11'  ) \n"+  //--cust 미등록건 
				"      and d.rent_l_cd is not null \n"+    //--cms_mng 등록건 
				" union  \n"+
			   "  select   d.cms_start_dt , cm.ama_id, a.rent_l_cd, b.firm_nm, g.car_no, d.cms_day, d.cms_dep_nm, replace(d.cms_dep_ssn, '-', '') cms_dep_ssn, f.cms_bk, d.cms_bank,d.cms_acc_no, \n"+
			   "	'0' cms_status,  nvl(al.cms_code,  nvl(g.cms_code, '9951572587') )   org_code , u.user_nm    \n"+	
			   "	from cont a, client b,  users u, cms.member_user c,  cont_etc et,  \n"+
			   "	     (select a.* from cms_mng a,   (select rent_mng_id, rent_l_cd, max(seq) seq from cms_mng  where app_dt is not null group by rent_mng_id, rent_l_cd) b   where a.rent_l_cd=b.rent_l_cd and a.seq=b.seq) d, \n"+
			   "	     (select * from code where c_st='0003') f, car_reg g,   allot al , cms_info cm \n"+			
			    "	where \n"+
			   	"      nvl(a.use_yn, 'Y') ='Y'  and a.bus_id= u.user_id(+)  \n"+ //살아있는계약 
				"      and a.client_id=b.client_id \n"+
				"      and a.rent_l_cd=c.cms_primary_seq(+) \n"+
				"      and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+) \n"+
				"      and a.rent_mng_id=al.rent_mng_id(+) and a.rent_l_cd=al.rent_l_cd(+)   \n"+
				"      and a.rent_mng_id=et.rent_mng_id and a.rent_l_cd=et.rent_l_cd  \n"+
             "      and et.rent_suc_dt is not null	  \n"+
             "	    and nvl(al.cms_code,  nvl(g.cms_code, '9951572587') )   = cm.org_code   \n"+
     //  		"      and nvl(al.cms_code, '9951572587') = cm.org_code \n"+     
       		"      and  a.car_gu   in ( '1' )  \n"+    		
				"      and d.cms_bank=f.nm(+) \n"+
				"      and a.car_mng_id=g.car_mng_id(+) \n"+
				"      and  ( c.cms_primary_seq is null  or  d.reg_st = '11'  ) \n"+  //--cust 미등록건 
				"      and d.rent_l_cd is not null \n"+    //--cms_mng 등록건 		
									
				" order by 1 , 2  , 3 ";				
	*/
		
		query = "select cm.ama_id,  a.rent_l_cd, b.firm_nm, g.car_no, d.cms_day, d.cms_dep_nm, replace(d.cms_dep_ssn, '-', '') cms_dep_ssn,    \n"+	
					" nvl(d.cms_bk, decode(f.cms_bk, '005', '081', f.cms_bk ) )  cms_bk ,  d.cms_bank, d.cms_acc_no, \n"+
			      "	'0' cms_status,  nvl(al.cms_code, '9951572587')  org_code , d.cms_start_dt , u.user_nm    \n"+	
			      "	from cont a, client b,  users u, cms.member_user c, \n"+
			      "	     (select a.* from cms_mng a,   (select rent_mng_id, rent_l_cd, max(seq) seq from cms_mng  where app_dt is not null group by rent_mng_id, rent_l_cd) b   where a.rent_l_cd=b.rent_l_cd and a.seq=b.seq) d, \n"+
			      "	     (select * from code where c_st='0003') f, car_reg g,   allot al , cms_info cm , fee_rm fr \n"+			
			      "	where \n"+
			   	"      nvl(a.use_yn, 'Y') ='Y'  and a.bus_id= u.user_id(+)  \n"+ //살아있는계약 
				"      and a.client_id=b.client_id \n"+
				"      and a.rent_l_cd=c.cms_primary_seq(+) \n"+
				"      and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+) \n"+
				"      and a.rent_mng_id=al.rent_mng_id(+) and a.rent_l_cd=al.rent_l_cd(+)   \n"+
				"      and nvl(al.cms_code,  nvl(g.cms_code, '9951572587') )   = cm.org_code  \n"+       		
				"      and a.rent_mng_id = fr.rent_mng_id(+) and a.rent_l_cd = fr.rent_l_cd(+) and nvl(fr.cms_type, 'cms') ='cms'  \n"+       		
       //		"      and nvl(al.cms_code, '9951572587') = cm.org_code(+)  \n"+       		
			//	"      and d.cms_bank=f.nm(+) \n"+
				"      and decode(d.cms_bank , '하나은행', 'KEB하나은행' , d.cms_bank)  =f.nm(+)  \n"+
				"      and a.car_mng_id=g.car_mng_id(+) \n"+
				"      and length(trim(d.cms_acc_no)) > 1 \n"+
				"      and  ( c.cms_primary_seq is null  or  d.reg_st = '11'  ) \n"+  //--cust 미등록건 
				"      and d.rent_l_cd is not null \n"+    //--cms_mng 등록건 
				"	   and nvl(d.cms_bk, decode(f.cms_bk, '005', '081', f.cms_bk ) ) is not null \n"+  
				" order by  d.cms_start_dt , cm.ama_id, a.rent_l_cd  ";
			
				
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
			System.out.println("[IncomDatabase:getMemberCmsList]\n"+e);
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
	
	//cms 인출 데이타 생성여부       
	public int  getCntMemberCmsBit()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";		
		int cnt = 0;
				
		query = " select count(0) "+
 				"  from   cms.member_user a "+
				"  where  a.cms_status in ( '0' , '1', '11',  '12' )  and  a.adate = to_char(sysdate,'YYYYMMdd') ";  //금일날짜 신청데이타가 있으면 				 			 		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		if(rs.next())
			{		
				cnt = rs.getInt(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[IncomDatabase:getCntMemberCmsBit]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return cnt;
		}
	}
			
	
	/**
	 *	//eb11 cms member 조회하기
	 */
	public Vector getMemberCmsEb11List()
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String d_query = "";
		
	
		
		query = "	 select c.client_id, c.rent_l_cd, a.ama_id, a.filename, a.seq_num, a.code org_code, a.reg_kind, a.user_no, a.bank_code, a.account_no, a.id_no,   \n"+
			      "         a.agent_code , b.bname , d.firm_nm ,  u.user_nm , c.use_yn , cr.car_no    \n"+
			      "	       from  cms.file_ea11 a, BNK b ,  cont c  , client d ,  users u   , car_reg cr   \n"+
			      "	        where a.adate is null and a.bank_code = b.bcode(+)              \n"+
			      "	      	     and trim(a.user_no)=c.rent_l_cd(+)  	   \n"+		 
			      "	   	     and c.bus_id= u.user_id(+)  	   \n"+			    
			      "                and c.client_id=d.client_id(+)	   \n"+		
			          "            and c.car_mng_id=cr.car_mng_id(+)	   \n"+				 
			      "		     order by a.ama_id , a.filename,  a.seq_num	";
			        	
				
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
			System.out.println("[IncomDatabase:getMemberCmsList]\n"+e);
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
	 *	//eb11 cms member 조회하기
	 */
	public Vector getMemberCmsEb11List(String s_kd, String t_wd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String d_query = "";
			
	   if ( s_kd.equals("2") ||  s_kd.equals("3") ) {
			if ( s_kd.equals("2") ) d_query = " and  cr.car_no like '%"+ t_wd + "%'";
			if ( s_kd.equals("3") ) d_query = " and  c.rent_l_cd like '%"+ t_wd + "%'";
		} else {
			d_query = " and  a.adate is null ";
		}	
		
		query = "	 select c.client_id, c.rent_l_cd, a.ama_id, a.filename, a.seq_num, a.code org_code, a.reg_kind, a.user_no, a.bank_code, a.account_no, a.id_no,   \n"+
			      "         a.agent_code , b.bname , d.firm_nm ,  u.user_nm , c.use_yn , cr.car_no , a.adate   \n"+
			      "	       from  cms.file_ea11 a, BNK b ,  cont c  , client d ,  users u   , car_reg cr   \n"+
			      "	        where a.bank_code = b.bcode(+)              \n"+
			      "	      	     and trim(a.user_no)=c.rent_l_cd(+)  	   \n"+		 
			      "	   	     and c.bus_id= u.user_id(+)  	   \n"+			    
			      "                and c.client_id=d.client_id(+)	   \n"+		
			          "            and c.car_mng_id=cr.car_mng_id(+)	    " + d_query + 				 
			      "		     order by a.ama_id , a.filename,  a.seq_num	";
			 
		//	 System.out.println( "getMemberCmsEb11List = " + query);      	
				
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
			System.out.println("[IncomDatabase:getMemberCmsList]\n"+e);
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
	
			
		
	/*
	 *	member_user 데이타 생성  프로시져 호출
	*/
	public String call_sp_member_user_cms_reg()
	{
    	getConnection();
    	
    	String query = "{CALL P_MEMBER_USER_CMS_REG (?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
			cstmt = conn.prepareCall(query);
			
			cstmt.registerOutParameter( 1, java.sql.Types.VARCHAR );
			
			cstmt.execute();
			sResult = cstmt.getString(1); // 결과값
			cstmt.close();
				
	
		} catch (SQLException e) {
			System.out.println("[IncomDatabase:call_sp_member_user_cms_reg]\n"+e);
			e.printStackTrace();
		} finally {
			try{
			     if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}	

	
		
	/*
	 *	member_user 데이타 생성  프로시져 호출
	*/
	public String call_sp_member_user_cms11_reg()
	{
    	getConnection();
    	
    	String query = "{CALL P_MEMBER_USER_CMS11_REG (?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
			cstmt = conn.prepareCall(query);
			
			cstmt.registerOutParameter( 1, java.sql.Types.VARCHAR );
			
			cstmt.execute();
			sResult = cstmt.getString(1); // 결과값
			cstmt.close();
				
	
		} catch (SQLException e) {
			System.out.println("[IncomDatabase:call_sp_member_user_cms11_reg]\n"+e);
			e.printStackTrace();
		} finally {
			try{
			     if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}	
	
	
	 // 계약관련 거래처 정보
	public Hashtable getCmsCont(String rent_l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";		
			
		query =" select  c.client_id, c.client_st, d.car_no , \n"+ 
			   " decode(b.tax_type,'2',nvl(f.r_site,c.firm_nm),c.firm_nm) as firm_nm, \n"+ 
			   " decode(b.tax_type,'2',nvl(TEXT_DECRYPT(f.enp_no, 'pw' ) ,TEXT_DECRYPT(c.ssn, 'pw' ) ),TEXT_DECRYPT(c.ssn, 'pw' ) ) as ssn, \n"+ 
			   " decode(b.tax_type,'2',nvl(f.enp_no,c.enp_no),c.enp_no) as enp_no, \n"+ 
			   " decode(b.TAX_TYPE,'2',nvl(f.ven_code,c.ven_code),c.ven_code) ven_code \n"+ 
			   " from cont b, client c, car_reg d, client_site f \n"+ 
			   " where b.rent_l_cd=  '" + rent_l_cd + "'  and b.client_id=c.client_id and b.car_mng_id=d.car_mng_id(+) and b.client_id=f.client_id(+) and b.r_site=f.seq(+)"; 	
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
			System.out.println("[IncomDatabase:getOffls_sui]\n"+e);			
			System.out.println("[IncomDatabase:getOffls_sui]\n"+query);			
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
	
	
	 /**
     * 과태료/범칙금 입금처리 수정
     */
    public boolean updateForfeitDetailCls(String rent_mng_id, String rent_l_cd, int seq_no, String coll_dt, String user_id, String incom_dt , int incom_seq) 
    {
      	getConnection();
        PreparedStatement pstmt = null;
        String query = "";
        boolean flag = true;
 		                
        query = " update fine set coll_dt= replace(?, '-', ''), update_id = ?, update_dt = to_char(sysdate,'YYYYMMdd'), incom_dt = replace(?, '-', ''), incom_seq = ?  "+
				" where seq_no=? and rent_mng_id=? and rent_l_cd=?";
         
       try{
            conn.setAutoCommit(false);
           
            pstmt = conn.prepareStatement(query);            
            pstmt.setString(1, coll_dt	);
            pstmt.setString(2, user_id	);
            pstmt.setInt   (3, seq_no		);
            pstmt.setString(4, incom_dt		);
            pstmt.setInt   (5, incom_seq	);            
            pstmt.setString(6, rent_mng_id	);
            pstmt.setString(7, rent_l_cd	);
            
            pstmt.executeUpdate();
             
            pstmt.close();
            conn.commit();

    
    	} catch (Exception e) {
    		System.out.println("[IncomDatabase:updateForfeitDetailCls]\n"+e);
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
     * 면책금 입금처리 수정
     */
    public boolean updateServiceDetailCls(String rent_mng_id, String rent_l_cd, String serv_id, int car_ja_amt, String ext_tm, String cls_dt, String user_id, String incom_dt, int incom_seq) 
    {
      	getConnection();
      	PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
        boolean flag = true;
 		
		String query = "";
		query = " UPDATE scd_ext SET ext_pay_dt=replace(?, '-', ''), ext_pay_amt=?, "+
				" update_dt=to_char(sysdate,'YYYYMMDD'), update_id=? , incom_dt = replace(?, '-', ''), incom_seq = ? "+
				" WHERE ext_st = '3' and rent_mng_id=? and rent_l_cd=? and ext_id = ? and ext_tm = ? ";
				
		String query1 = "";
		query1 = " UPDATE service SET cust_pay_dt =replace(?, '-', ''),  "+
				" update_dt=to_char(sysdate,'YYYYMMDD'), update_id=? "+
				" WHERE  rent_mng_id=? and rent_l_cd=? and serv_id = ?  ";		
             
       try{
            conn.setAutoCommit(false);           
        						 	
			pstmt1 = conn.prepareStatement(query);
			pstmt1.setString(1, cls_dt);
			pstmt1.setInt(2, car_ja_amt);
			pstmt1.setString(3, user_id);
			pstmt1.setString(4, incom_dt);
			pstmt1.setInt(5, incom_seq);
			pstmt1.setString(6, rent_mng_id);
			pstmt1.setString(7, rent_l_cd);
			pstmt1.setString(8, serv_id);		
			pstmt1.setString(9, ext_tm);
		    pstmt1.executeUpdate();		   				   
            pstmt1.close();
		   
		   // 정비 테이블 변경	
		   	pstmt2 = conn.prepareStatement(query1);
			pstmt2.setString(1, cls_dt);
			pstmt2.setString(2, user_id);
			pstmt2.setString(3, rent_mng_id);
			pstmt2.setString(4, rent_l_cd);
			pstmt2.setString(5, serv_id); //서비스 id
			pstmt2.executeUpdate();	  			
            pstmt2.close();
           
            conn.commit();

    
    	} catch (Exception e) {
			System.out.println("[IncomDatabase:updateServiceDetailCls]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{	
                if(pstmt1 != null)	pstmt1.close();
                if(pstmt2 != null)	pstmt2.close();
                conn.setAutoCommit(true);
			}
			catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}	
	 
	 /**
     * 연체료 상계 입금처리 수정
     */
    public boolean insertScdDlyCls(String rent_mng_id, String rent_l_cd, int dly_amt, String cls_dt, String user_id, String incom_dt, int incom_seq) 
    {
      	getConnection();
      	PreparedStatement dly_pstmt = null;
		PreparedStatement dly_pstmt2 = null;
        boolean flag = true;
       	ResultSet rs = null;
		String seq = "";
 	
		String dly_qry = " insert into SCD_DLY (RENT_MNG_ID, RENT_L_CD, SEQ, PAY_DT, PAY_AMT, REG_ID, REG_DT, ETC, INCOM_DT, INCOM_SEQ)"+
							" values (?, ?, ?, replace(?, '-', ''), ?, ?, to_char(sysdate,'YYYYMMDD'), ?, replace(?, '-', '' ), ?)";
							
		String dly_seq = " select nvl(to_char(max(to_number(seq))+1),'1') seq from scd_dly where rent_mng_id=? and rent_l_cd=?";
             
       try{
            conn.setAutoCommit(false);           
        						 	
			dly_pstmt = conn.prepareStatement(dly_seq);
			dly_pstmt.setString(1 , rent_mng_id);
			dly_pstmt.setString(2 , rent_l_cd);
			rs = dly_pstmt.executeQuery();
			if(rs.next()){
				seq = rs.getString(1);
			}
			rs.close();
			dly_pstmt.close();

			dly_pstmt2 = conn.prepareStatement(dly_qry);
			dly_pstmt2.setString(1, rent_mng_id);
			dly_pstmt2.setString(2, rent_l_cd);
			dly_pstmt2.setString(3, seq);
			dly_pstmt2.setString(4, cls_dt);
			dly_pstmt2.setInt   (5, dly_amt);
			dly_pstmt2.setString(6, user_id);
			dly_pstmt2.setString(7, "CMS 연체료 입금");
			dly_pstmt2.setString(8, incom_dt);
			dly_pstmt2.setInt   (9, incom_seq);			
			dly_pstmt2.executeUpdate();      
			dly_pstmt2.close();

            conn.commit();

    
    	} catch (Exception e) {
			System.out.println("[IncomDatabase:insertScdDlyCls]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{	
				if(rs != null)	rs.close();
                if(dly_pstmt != null)	dly_pstmt.close();
				if(dly_pstmt2 != null)	dly_pstmt2.close();
               
                conn.setAutoCommit(true);
			}
			catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
		
	/*
	 *	cms 처리 procedure 호출
	*/
	public String call_sp_incom_cms_magam(String adate, String user_id, String insert_id, String incom_dt, int incom_seq, long incom_amt, String gubun)
	{
       	getConnection();
     
    	String query = "{CALL P_INCOM_CMS_MAGAM (?,?,?,?,?,?,?,?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
						
			cstmt = conn.prepareCall(query);
					
			cstmt.setString(1, adate);
			cstmt.setString(2, user_id);
			cstmt.setString(3, insert_id);
			cstmt.setString(4, incom_dt);
			cstmt.setInt(5, incom_seq);
			cstmt.setLong(6, incom_amt);
			cstmt.setString(7, gubun);
			cstmt.registerOutParameter( 8, java.sql.Types.VARCHAR );
			cstmt.execute();
			sResult = cstmt.getString(8); // 결과값
			
			cstmt.close();
		
		} catch (SQLException e) {
			System.out.println("[IncomDatabase:call_sp_incom_cms_magam]"+e);
			e.printStackTrace();
		} finally {
			try{
            if(cstmt != null)	cstmt.close();
            }catch(SQLException _ignored){}
			closeConnection();			
		}
		return sResult;
	}
		
		
	/**
	 *	대여료일괄입금처리리스트
	 */
	public Vector getFeeScdSettleClientList(String s_c_id, String s_kd, String t_wd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		/*
		query = " select nvl(f.firm_nm, r.firm_nm) firm_nm, nvl(f.client_id, r.client_id) client_id, a.*, (a.fee_s_amt+a.fee_v_amt) fee_amt, decode(b.car_st, '4', '월렌트', ' ') ||  decode(a.tm_st1,'0','대여료','대여료 잔액')  tm_st1_nm, c.car_no, c.car_nm, c.car_mng_id \n"+
				" from   scd_fee a, cont b, car_reg c, fee d, fee_rtn e, client f , client r  \n"+
				" where  a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.car_mng_id=c.car_mng_id(+)  \n"+
				" and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd and a.rent_st=d.rent_st  \n"+
				" and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+) and a.rent_st=e.rent_st(+) and a.rent_seq=e.rent_seq(+)  \n"+
				" and e.client_id=f.client_id(+) and b.client_id = r.client_id and b.client_id in ( "+s_c_id +" )  \n"+
				" and a.rc_dt is null and a.bill_yn='Y' and a.fee_s_amt  <> 0  \n"; */
				
				
		query = " select nvl(f.r_site, r.firm_nm) firm_nm, nvl(f.client_id, r.client_id) client_id, nvl(f.seq, b.r_site) r_site,  a.*, (a.fee_s_amt+a.fee_v_amt) fee_amt, decode(b.car_st, '4', '월렌트', ' ') ||  decode(a.tm_st1,'0','대여료','대여료 잔액')  tm_st1_nm, c.car_no, c.car_nm, c.car_mng_id \n"+
				" from   scd_fee a, cont b, car_reg c, fee d, fee_rtn e, client_site f , client r  \n"+
				" where  a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.car_mng_id=c.car_mng_id(+)  \n"+
				" and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd and a.rent_st=d.rent_st  \n"+
				" and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+) and a.rent_st=e.rent_st(+) and a.rent_seq=e.rent_seq(+)  \n"+
				" and e.client_id=f.client_id(+) and e.r_site= f.seq(+) and nvl(e.client_id, b.client_id)  = r.client_id and b.client_id in ( "+s_c_id +" )  \n"+
				" and a.rc_dt is null and a.bill_yn='Y' and a.fee_s_amt  <> 0  \n";		
				
		if( s_kd.equals("3") && !t_wd.equals("")){
				query += " and c.car_no like '%"+t_wd+"%'";
		}			
				
		query += " order by  a.fee_est_dt, 2, nvl(d.rent_dt,b.rent_dt) ";

	
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
			System.out.println("[IncomDatabase:getFeeScdSettleClientList]\n"+e);
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
	 *	스케쥴 연체
	 */
	public int getFeeScdDlyClientCnt(String s_c_id, String s_kd, String t_wd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		int cnt = 0;
		String query = "";
		query = " select count(0) "+
				" from scd_fee a, cont b, car_reg c where a.rc_yn='0' and a.fee_est_dt < to_char(sysdate,'YYYYMMDD') and a.bill_yn='Y'"+
				" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.car_mng_id=c.car_mng_id(+) and b.client_id in ( "+s_c_id +" ) ";
				
		if( s_kd.equals("3") && !t_wd.equals("")){
				query += " and c.car_no like '%"+t_wd+"%'";
		}	
		
		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			if(rs.next())
			{
				cnt = rs.getInt(1);
			}
			rs.close();
			stmt.close();

		} catch (SQLException e) {
			System.out.println("[IncomDatabase:getFeeScdDlyClientCnt]\n"+e);
			System.out.println("[IncomDatabase:getFeeScdDlyClientCnt]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return cnt;
		}
	}	
	
	/**
	 *	대여료 연체이자 -  승계, 차종변경때문에 수정 -20130808  -> 20140307 계약별로 연체이자 회수
	 */
	public Vector getFeeScdDlyStatClient(String s_c_id, String s_kd, String t_wd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.client_id, cc.firm_nm,  a.rent_mng_id, a.rent_l_cd, c.dly_fee, d.pay_amt, (nvl(c.dly_fee,0)-nvl(d.pay_amt,0)) jan_amt, b.car_no, b.car_nm, b.car_mng_id, '' firm_nm, '' client_id, a.use_yn "+
				" from   cont a, car_reg b, client cc,  cls_cont cd, "+
				"        (select rent_mng_id, rent_l_cd, sum(dly_fee) dly_fee from scd_fee where bill_yn='Y' group by rent_mng_id, rent_l_cd ) c,"+
				"        (select rent_mng_id, rent_l_cd, sum(pay_amt) pay_amt from scd_dly group by rent_mng_id, rent_l_cd ) d"+
				" where  a.car_mng_id=b.car_mng_id(+)  and a.rent_l_cd not like 'RM%'  "+
				"        and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd = c.rent_l_cd(+)  "+
				"        and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd = d.rent_l_cd(+) "+
				"        and (nvl(c.dly_fee,0)-nvl(d.pay_amt,0))>0"+				
                       		"        and a.rent_mng_id = cd.rent_mng_id(+) and a.rent_l_cd= cd.rent_l_cd(+) and NVL(cd.cls_st , '0')  not in  ( '4' )  "+		
				"        and a.client_id = cc.client_id and a.client_id in ( "+s_c_id +" )";
				
		if( s_kd.equals("3") && !t_wd.equals("")){
				query += " and b.car_no like '%"+t_wd+"%'";
		}	
				
		query += " order by a.reg_dt";
	
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
			System.out.println("[IncomDatabase:getFeeScdDlyStatClient]\n"+e);
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
	 *	면책금일괄입금처리리스트
	 */
	public Vector getServScdStatClient(String s_c_id, String s_kd, String t_wd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
/*
		query = " select b.client_id, cc.firm_nm, a.*, (a.ext_s_amt+a.ext_v_amt) ext_amt, decode(a.ext_tm,'1','면책금','면책금 잔액') tm_st1_nm, c.car_no, c.car_nm, c.car_mng_id, d.accid_id, d.serv_id "+
				" from   scd_ext a, cont b, car_reg c, service d, client cc "+
				" where  a.ext_st='3' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.car_mng_id=c.car_mng_id(+)"+
				" and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd and a.ext_id=d.serv_id"+
				" and b.client_id = cc.client_id and b.client_id in ( "+s_c_id +" ) "+
				" and a.ext_pay_dt is null and a.bill_yn='Y'";
				decode(d.rent_st,'1','단기대여','9','보험대차','2','정비대차','3','사고대차','4','업무대여','5','업무대여')
*/		
		
		query = " select nvl(g.cust_id, b.client_id) client_id , cc.firm_nm, a.*, (a.ext_s_amt+a.ext_v_amt) ext_amt, decode(a.ext_tm,'1','면책금','면책금 잔액') tm_st1_nm, c.car_no, c.car_nm, c.car_mng_id, d.accid_id, d.serv_id, "+  
				" decode(g.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트') res_st "+
				" from   scd_ext a, cont b, car_reg c, service d, client cc, rent_cont g, accident e , cont dd  "+
				" where  a.ext_st='3' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.car_mng_id=c.car_mng_id(+) and b.rent_l_cd not like 'RM%' "+
				" and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd and a.ext_id=d.serv_id "+
				" and d.car_mng_id=e.car_mng_id and d.accid_id=e.accid_id "+
				" and e.rent_s_cd=g.rent_s_cd(+) and g.sub_l_cd=dd.rent_l_cd(+)  "+
				" and  ( b.client_id in ( "+s_c_id +" ) or  g.cust_id in ( "+s_c_id +"  ) )	"+			 
	  		          " and b.client_id = cc.client_id  and a.ext_pay_dt is null and a.bill_yn='Y' ";
				
		if( s_kd.equals("3") && !t_wd.equals("")){
				query += " and c.car_no like '%"+t_wd+"%'";
		}					
				
		query += "  order by a.ext_est_dt, b.rent_dt";
	
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
			System.out.println("[IncomDatabase:getServScdStatClient]\n"+e);
			System.out.println("[IncomDatabase:getServScdStatClient]\n"+query);
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
	 *	보증금일괄입금처리리스트
	 */
	public Vector getFeeScdGrtClientList(String s_c_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select b.client_id, cc.firm_nm, a.*, (a.ext_s_amt+a.ext_v_amt) ext_amt, decode(a.ext_tm,'1','보증금','보증금 잔액') tm_st1_nm, c.car_no, c.car_nm, c.car_mng_id "+
				" from   scd_ext a, cont b, car_reg c, client cc "+
				" where  a.ext_st='0' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.car_mng_id=c.car_mng_id(+) and b.rent_l_cd not like 'RM%' "+
				" and b.client_id = cc.client_id and b.client_id in ( "+s_c_id +" ) "+
				" and a.ext_pay_dt is null and nvl(a.bill_yn,'Y')='Y' and (a.ext_s_amt+a.ext_v_amt) > 0 "+
				" order by a.ext_est_dt, b.rent_dt";
	
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
			System.out.println("[IncomDatabase:getFeeScdGrtClientList]\n"+e);
			System.out.println("[IncomDatabase:getFeeScdGrtClientList]\n"+query);
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
	 *	선납금일괄입금처리리스트
	 */
	 
	public Vector getFeeScdPpClientList(String s_c_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select b.client_id, cc.firm_nm, a.*, (a.ext_s_amt+a.ext_v_amt) ext_amt, decode(a.ext_tm,'1','선납금','선납금 잔액') tm_st1_nm, c.car_no, c.car_nm, c.car_mng_id "+
				" from   scd_ext a, cont b, car_reg c, client cc "+
				" where  a.ext_st='1' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.car_mng_id=c.car_mng_id(+) and b.rent_l_cd not like 'RM%' "+
				" and b.client_id = cc.client_id and b.client_id in ( "+s_c_id +" ) "+
				" and a.ext_pay_dt is null and nvl(a.bill_yn,'Y')='Y' and (a.ext_s_amt+a.ext_v_amt) > 0 "+
				" order by a.ext_est_dt, b.rent_dt";
	
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
			System.out.println("[IncomDatabase:getFeeScdPpClientList]\n"+e);
			System.out.println("[IncomDatabase:getFeeScdPpClientList]\n"+query);
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
	 *	개시대여료일괄입금처리리스트
	 */
	public Vector getFeeScdRfeeClientList(String s_c_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select b.client_id, cc.firm_nm, a.*, (a.ext_s_amt+a.ext_v_amt) ext_amt, decode(a.ext_tm,'1','개시대여료','개시대여료 잔액') tm_st1_nm, c.car_no, c.car_nm, c.car_mng_id "+
				" from   scd_ext a, cont b, car_reg c, client cc \n"+
				" where  a.ext_st='2' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.car_mng_id=c.car_mng_id(+) and b.rent_l_cd not like 'RM%'"+
				" and b.client_id = cc.client_id and b.client_id in ( "+s_c_id +" ) "+
				" and a.ext_pay_dt is null and nvl(a.bill_yn,'Y')='Y' and (a.ext_s_amt+a.ext_v_amt) > 0 "+
				" order by a.ext_est_dt, b.rent_dt";
	
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
			System.out.println("[IncomDatabase:getFeeScdRfeeClientList]\n"+e);
			System.out.println("[IncomDatabase:getFeeScdRfeeClientList]\n"+query);
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
	 *	승계수수료일괄입금처리리스트
	 */
	public Vector getFeeScdChaClientList(String s_c_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
/*
		query = " select b.client_id, cc.firm_nm, a.*, (a.ext_s_amt+a.ext_v_amt) ext_amt, decode(a.ext_tm,'1','승계수수료','승계수수료 잔액') tm_st1_nm, c.car_no, c.car_nm, c.car_mng_id "+
				" from   scd_ext a, cont b, car_reg c, client cc,  \n"+
				" where  a.ext_st='5' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.car_mng_id=c.car_mng_id(+) and b.car_st <> '4' "+
				" and b.client_id = cc.client_id and b.client_id in ( "+s_c_id +" ) "+
				" and a.ext_pay_dt is null and nvl(a.bill_yn,'Y')='Y' and (a.ext_s_amt+a.ext_v_amt) > 0 "+
				" order by a.ext_est_dt, b.rent_dt";
		*/
		query = " select nvl(dd.suc_client_id, b.client_id) client_id , cc.firm_nm, a.*, (a.ext_s_amt+a.ext_v_amt) ext_amt, decode(a.ext_tm,'1','승계수수료','승계수수료 잔액') tm_st1_nm, c.car_no, c.car_nm, c.car_mng_id "+
				" from   scd_ext a, cont b, car_reg c, client cc,  \n"+
				" (select a.rent_mng_id suc_m_id, a.rent_l_cd suc_l_cd , b.client_id suc_client_id from cont_etc a, cont b  \n"+
		        "    where a.rent_suc_commi_pay_st = '1' and a.rent_suc_m_id = b.rent_mng_id and a.rent_suc_l_cd = b.rent_l_cd ) dd  \n"+
				" where  a.ext_st='5' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.car_mng_id=c.car_mng_id(+) and b.car_st <> '4' "+
				" and b.client_id = cc.client_id and b.client_id in ( "+s_c_id +" ) "+
				" and a.ext_pay_dt is null and nvl(a.bill_yn,'Y')='Y' and (a.ext_s_amt+a.ext_v_amt) > 0 "+
			    " and a.rent_mng_id = dd.suc_m_id(+) and a.rent_l_cd = dd.suc_l_cd(+)  "+
				" order by a.ext_est_dt, b.rent_dt";	
		
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
			System.out.println("[IncomDatabase:getFeeScdChaClientList]\n"+e);
			System.out.println("[IncomDatabase:getFeeScdChaClientList]\n"+query);
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
	 *	휴/대차료일괄입금처리리스트
	 */
	public Vector getServScdInshClient(String s_c_id, String s_kd, String t_wd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " select  c.client_id, a.car_mng_id, a.accid_id, nvl(c.firm_nm, c.client_nm) firm_nm, decode(e.ext_tm,'1','','잔액') tm_st1_nm, cr.car_no, cr.car_nm, \n"+
	   		    " (e.ext_s_amt+e.ext_v_amt) req_amt, c.use_yn, a.accid_dt, e.ext_est_dt req_dt, b.seq_no, e.*, decode(b.req_gu, '1','휴차료', '2','대차료') req_gu , b.ins_com , a.rent_s_cd , a.accid_dt , decode(j.item_id, null , 1 , 2) item_id \n"+
				"  from	accident a, my_accid b, cont_n_view c, scd_ext e , car_reg cr, \n"+
				" 	(select bb.tax_dt, aa.* from tax_item_list aa, tax  bb where aa.item_id=bb.item_id(+) and nvl(tax_st ,'O')  ='O' and aa.gubun in ('11','12')) j \n"+			
				"  where a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id \n"+
				" 		and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and c.car_mng_id = cr.car_mng_id  \n"+
				" 		and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd and e.ext_st = '6'  \n"+
				" 		and b.accid_id = substr(e.ext_id,1,6) and b.seq_no = substr(e.ext_id, 7)  and  nvl(e.ext_est_dt , to_char(sysdate,'YYYYMMdd' ) ) >= '20100101' \n"+   //20100101부터 진행 - 사장님지시 (20130724)
				" 		and e.ext_pay_dt is null and nvl(e.bill_yn, 'Y') ='Y' and (e.ext_s_amt+e.ext_v_amt) > 0 "+
				" 		and b.car_mng_id=j.car_mng_id(+) and b.accid_id=j.tm(+) and b.seq_no=j.rent_seq(+) \n"+										
				" 		and b.req_amt > 0 	and	c.client_id in ( "+s_c_id +" )  \n";	
				
		if( s_kd.equals("3") && !t_wd.equals("")){
				query += " and cr.car_no like '%"+t_wd+"%'";
		}		
			
		query += " order by  e.ext_est_dt, c.rent_dt2 ";
	
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
			System.out.println("[IncomDatabase:getServScdInshClient]\n"+e);
			System.out.println("[IncomDatabase:getServScdInshClient]\n"+query);
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
	 *	과태료 일괄입금처리리스트 - cust_st :4 직원 
	 */

	public Vector getFineScdStatClient(String s_c_id, String s_kd, String t_wd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
	
		query = " select \n"+
				" nvl(decode(g.cust_st, '4', '000228', g.cust_id), b.client_id) client_id, a.car_mng_id, a.seq_no, a.rent_mng_id, a.rent_l_cd, b.firm_nm, \n"+
				" cr.car_no, cr.car_nm, decode(a.fault_st, '1', a.paid_amt, '3', a.paid_amt, '2', decode(nvl(a.fault_amt,0), 0, a.paid_amt, a.fault_amt)) paid_amt,\n"+
				" b.use_yn, nvl(a.dem_dt, '') proxy_dt, \n"+
				" decode(g.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트') res_st, a.vio_cont, \n"+
				" case when  ( instr(vio_cont, '통행료') > 0)   then '1'  when  (instr(vio_cont, '주차요금') > 0)  then '2'  else '3' end  v_gubun  \n"+
				" from fine a, cont_n_view b, rent_cont g,  client h, users i , car_reg cr \n"+
				" where\n"+
				" a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd  and a.rent_s_cd=g.rent_s_cd(+) and b.car_mng_id = cr.car_mng_id(+) \n"+
				" and g.cust_id=h.client_id(+) and g.cust_id=i.user_id(+) \n"+
				" and  ( b.client_id in ( "+s_c_id +" ) or  g.cust_id in ( "+s_c_id +" ) ) \n"+
				" and a.paid_amt > 0 and nvl(a.no_paid_yn,'N') <> 'Y' and a.paid_st in ('2', '3','4') and decode(a.fault_st,'2','Y',nvl(a.bill_yn,'Y'))='Y' and a.coll_dt is null \n";
				
		if( s_kd.equals("3") && !t_wd.equals("")){
				query += " and cr.car_no like '%"+t_wd+"%'";
		}			
			
		query += " order by a.proxy_dt ";
		
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
			System.out.println("[IncomDatabase:getFineScdStatClient]\n"+e);
			System.out.println("[IncomDatabase:getFineScdStatClient]\n"+query);
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
	 *	해지정산금일괄입금처리리스트 - 과태료, 면책금, 대여료, 대여료이자, 해지위약금, 차량회수외주비용, 차량회수부대비용, 기타소해배상금
	 */
	public Vector getServScdClsClient(String s_c_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		
		query = " select  c.client_id, c.car_mng_id, e.*, (e.ext_s_amt+e.ext_v_amt) ext_amt, decode(e.ext_tm,'1','해지정산금','해지정산금 잔액') tm_st1_nm , c.firm_nm, cr.car_no, cr.car_nm \n"+
	   		    " from	cls_cont a, cls_etc b, cont_n_view c, scd_ext e , car_reg cr \n"+
				" where e.ext_st='4' and e.rent_mng_id=a.rent_mng_id and e.rent_l_cd=a.rent_l_cd "+
				" and   e.rent_mng_id=c.rent_mng_id and e.rent_l_cd=c.rent_l_cd  and c.car_mng_id = cr.car_mng_id(+) "+
				" and   e.rent_mng_id=b.rent_mng_id(+) and e.rent_l_cd=b.rent_l_cd(+) "+
				" and   c.client_id in ( "+s_c_id +" ) "+
				" and   e.ext_pay_dt is null and e.bill_yn='Y' " +
				" and  ( ( (e.ext_s_amt+e.ext_v_amt) > 0  )  or  (  a.cls_st = '14' and (e.ext_s_amt+e.ext_v_amt) < 0   )   )     "+
				" order by e.ext_est_dt, c.rent_dt2";		
			
	
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
			System.out.println("[IncomDatabase:getServScdClsClient]\n"+e);
			System.out.println("[IncomDatabase:getServScdClsClient]\n"+query);
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
	 *	단기 - 1차:월렌트 스케쥴리스트 rent_cont: rent_st -> 12:월렌트 , 2:정비대차
	 */
	 
	public Vector getRentContScdClient(String s_c_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = "  select  b.cust_id client_id, c.car_mng_id, a.*, (a.rent_s_amt+a.rent_v_amt) ext_amt, decode( b.rent_st, '2', '정비대차', decode(a.rent_st, '6', ' 보증금', '월렌트'))  || decode(a.tm,'1',' ',' 잔액') tm_st1_nm , nvl(d.firm_nm, d.client_nm) firm_nm, c.car_no, c.car_nm  \n "+
	   		      "  from	scd_rent  a,  rent_cont b , car_reg c , client d  \n"+
			      "	 where b.rent_s_cd = a.rent_s_cd and b.rent_st  in ( '12' , '2' )   \n"+
			       "    and   b.car_mng_id = c.car_mng_id  	and   b.cust_id = d.client_id \n"+
			       "    and   b.cust_id in ( "+s_c_id +" ) "+
			       "   and   a.pay_dt is null   and nvl(a.bill_yn, 'Y') ='Y' and (a.rent_s_amt+a.rent_v_amt) > 0 \n"+
			       "	 order by a.est_dt, b.rent_dt, b.rent_st, a.rent_st ";	
		
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
			System.out.println("[IncomDatabase:getRentContScdClient(]\n"+e);
			System.out.println("[IncomDatabase:getRentContScdClient(]\n"+query);
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
	 *	구매보조금 -일괄입금처리리스트
	 */
	public Vector getFeeScdGreenChaClientList(String s_c_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select b.client_id, cc.firm_nm, a.*, (a.ext_s_amt+a.ext_v_amt) ext_amt, decode(a.ext_tm,'1','구매보조금','구매보조금 잔액') tm_st1_nm, c.car_no, c.car_nm, c.car_mng_id "+
				" from   scd_ext a, cont b, car_reg c, client cc \n"+
				" where  a.ext_st='7' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.car_mng_id=c.car_mng_id(+) and b.car_st <> '4' "+
				" and b.client_id = cc.client_id and b.client_id in ( "+s_c_id +" ) "+
				" and a.ext_pay_dt is null and nvl(a.bill_yn,'Y')='Y' and (a.ext_s_amt+a.ext_v_amt) > 0 "+
				" order by a.ext_est_dt, b.rent_dt ";
	
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
			System.out.println("[IncomDatabase:getFeeScdChaClientList]\n"+e);
			System.out.println("[IncomDatabase:getFeeScdChaClientList]\n"+query);
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
     * 입금원장처리
     */
    public boolean updateIncomSet(String incom_dt , int incom_seq, String jung_type, int card_tax, String ip_method, String card_doc_cont, int cal_tax, String row_id) 
    {
      	getConnection();
        PreparedStatement pstmt = null;
        String query = "";
        boolean flag = true; 		
 			                
        query = " update incom set jung_type = ?, card_tax = ?, card_doc_cont = ?  , cal_tax = ? , row_id= ?   where incom_dt = replace(?, '-', '') and incom_seq = ? ";
			          
       try{
            conn.setAutoCommit(false);
           
            pstmt = conn.prepareStatement(query);            
            pstmt.setString(1, jung_type	);
            pstmt.setInt   (2, card_tax  	);    
            pstmt.setString(3, card_doc_cont);    
            pstmt.setInt(4, cal_tax);    
            pstmt.setString(5, row_id);    
            pstmt.setString(6, incom_dt		);
            pstmt.setInt   (7, incom_seq	);            
       
            pstmt.executeUpdate();
             
            pstmt.close();
            conn.commit();

    
    	} catch (Exception e) {
    		System.out.println("[IncomDatabase:updateIncomSet]\n"+e);
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
     * 입금원장처리
     */
    public boolean updateIncomSet(String incom_dt , int incom_seq, String not_yet_reason, String jung_type) 
    {
      	getConnection();
        PreparedStatement pstmt = null;
        String query = "";
        boolean flag = true;
 		                
        query = " update incom set jung_type = ? , remark = ? where incom_dt = replace(?, '-', '') and incom_seq = ? ";
			 
         
       try{
            conn.setAutoCommit(false);
           
            pstmt = conn.prepareStatement(query);            
            pstmt.setString(1, jung_type	);
            pstmt.setString(2, not_yet_reason);
            pstmt.setString(3, incom_dt		);
            pstmt.setInt   (4, incom_seq	);            
       
            pstmt.executeUpdate();
             
            pstmt.close();
            conn.commit();

    
    	} catch (Exception e) {
    		System.out.println("[IncomDatabase:updateIncomSet]\n"+e);
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
     * 입금원장처리
     */
    public boolean updateIncomSet(String incom_dt , int incom_seq, String jung_type) 
    {
      	getConnection();
        PreparedStatement pstmt = null;
        String query = "";
        boolean flag = true;
 		                
        query = " update incom set jung_type = ?  where incom_dt = replace(?, '-', '') and incom_seq = ? ";			 
         
       try{
            conn.setAutoCommit(false);
           
            pstmt = conn.prepareStatement(query);            
            pstmt.setString(1, jung_type	);
            pstmt.setString(2, incom_dt		);
            pstmt.setInt   (3, incom_seq	);            
       
            pstmt.executeUpdate();
             
            pstmt.close();
            conn.commit();

    
    	} catch (Exception e) {
    		System.out.println("[IncomDatabase:updateIncomSet]\n"+e);
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
     * 입금원장처리 - 대위변제
     */
     
    public boolean updateIncomFeeSet(String incom_dt , int incom_seq, String pay_gur, String pay_gur_nm, String pay_gur_rel) 
    {
      	getConnection();
        PreparedStatement pstmt = null;
        String query = "";
        boolean flag = true;
 		                
        query = " update incom set pay_gur = ? , pay_gur_nm = ?, pay_gur_rel = ? where incom_dt = replace(?, '-', '') and incom_seq = ? ";			 
         
       try{
            conn.setAutoCommit(false);
           
            pstmt = conn.prepareStatement(query);            
            pstmt.setString(1, pay_gur	);
            pstmt.setString(2, pay_gur_nm	);
            pstmt.setString(3, pay_gur_rel	);
     
            pstmt.setString(4, incom_dt		);
            pstmt.setInt   (5, incom_seq	);            
       
            pstmt.executeUpdate();
             
            pstmt.close();
            conn.commit();

    
    	} catch (Exception e) {
    		System.out.println("[IncomDatabase:updateIncomFeeSet]\n"+e);
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
     * 입금원장삭제 - 대기인 원장만 삭제가능 
     */
    public boolean deleteIncom(String incom_dt , int incom_seq) 
    {
      	getConnection();
        PreparedStatement pstmt = null;
        String query = "";
        boolean flag = true;
 		                
        query = " delete incom  where incom_dt = replace(?, '-', '') and incom_seq = ? and jung_type in ('0', '2') ";		
         
       try{
            conn.setAutoCommit(false);
           
            pstmt = conn.prepareStatement(query);            
            pstmt.setString(1, incom_dt		);
            pstmt.setInt   (2, incom_seq	);            
       
            pstmt.executeUpdate();
             
            pstmt.close();
            conn.commit();

    
    	} catch (Exception e) {
    		System.out.println("[IncomDatabase:deleteIncom]\n"+e);
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
     * 카드 승인후 취소건 -  입금원장삭제  
     */
    public boolean deleteIncomCard(String incom_dt , int incom_seq) 
    {
      	getConnection();
        PreparedStatement pstmt = null;
        String query = "";
        boolean flag = true;
 		                
        query = " delete incom  where incom_dt = replace(?, '-', '') and incom_seq = ? and jung_type  = '1' and ip_method  = '2' ";		
         
       try{
            conn.setAutoCommit(false);
           
            pstmt = conn.prepareStatement(query);            
            pstmt.setString(1, incom_dt		);
            pstmt.setInt   (2, incom_seq	);            
       
            pstmt.executeUpdate();
             
            pstmt.close();
            conn.commit();

    
    	} catch (Exception e) {
    		System.out.println("[IncomDatabase:deleteIncom]\n"+e);
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
	 *	해지정산금 항목별 미수 금액
	 */
	public Hashtable getClsEtcSub(String rent_mng_id, String rent_l_cd )
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";		
	/*	
		query = " select b.rent_mng_id, b.rent_l_cd, b.cls_seq, b.fine_amt_1 - nvl(b.fine_amt_2, 0) fine_amt_1 , \n" +
  			" b.car_ja_amt_1 - nvl(b.car_ja_amt_2,0) car_ja_amt_1 , b.dfee_amt_1 - nvl(b.dfee_amt_2,0)  dfee_amt_1, b.dly_amt_1 - nvl(b.dly_amt_2,0) dly_amt_1,  \n" +
   			" b.dft_amt_1 - nvl(b.dft_amt_2,0) dft_amt_1 , b.etc_amt_1 - nvl(b.etc_amt_2,0) etc_amt_1 , b.etc2_amt_1 - nvl(b.etc2_amt_2,0) etc2_amt_1, b.no_v_amt_1 - nvl(b.dfee_amt_2_v,0) - nvl(b.dft_amt_2_v,0) - nvl(b.etc_amt_2_v,0) - nvl(b.etc2_amt_2_v,0) - nvl(b.etc4_amt_2_v,0)  no_v_amt_1, \n" +
   			" b.etc4_amt_1 - nvl(b.etc4_amt_2,0) etc4_amt_1, ce.tax_chk0, ce.tax_chk1, ce.tax_chk2, ce.tax_chk3 \n" +
 			" from  scd_ext a, cls_etc ce, cls_etc_sub b, (select rent_mng_id, rent_l_cd, max(cls_seq) cls_seq from cls_etc_sub group by rent_mng_id, rent_l_cd) c \n" +
  			" where a.rent_mng_id = '"+ rent_mng_id + "' and a.rent_l_cd = '"+ rent_l_cd + "' and a.ext_st = '4' \n" +
  			" and a.rent_mng_id = b.rent_mng_id(+) and a.rent_l_cd = b.rent_l_cd(+) and a.rent_mng_id = ce.rent_mng_id(+) and a.rent_l_cd = ce.rent_l_cd(+) and a.rent_mng_id = c.rent_mng_id(+) and a.rent_l_cd = c.rent_l_cd(+) \n" +
       		" and b.cls_seq = c.cls_seq and nvl(a.bill_yn, 'Y')  = 'Y' and nvl(a.ext_pay_amt,0) = 0 ";
      */ 		
       		
		query = " select a.rent_mng_id, a.rent_l_cd, nvl(b.cls_seq, 0), nvl(b.fine_amt_1,0) - nvl(b.fine_amt_2, 0) fine_amt_1 , \n" +
  			" nvl(b.car_ja_amt_1,0) - nvl(b.car_ja_amt_2,0) car_ja_amt_1 , nvl(b.dfee_amt_1,0) - nvl(b.dfee_amt_2,0) dfee_amt_1, nvl(b.dly_amt_1,0) - nvl(b.dly_amt_2,0) dly_amt_1,  \n" +
   			" nvl(b.dft_amt_1,0) - nvl(b.dft_amt_2,0) dft_amt_1 , nvl(b.etc_amt_1,0) - nvl(b.etc_amt_2,0) etc_amt_1 , nvl(b.etc2_amt_1,0) - nvl(b.etc2_amt_2,0) etc2_amt_1, nvl(b.no_v_amt_1,0) - nvl(b.dfee_amt_2_v,0) - nvl(b.dft_amt_2_v,0) - nvl(b.etc_amt_2_v,0) - nvl(b.etc2_amt_2_v,0) - nvl(b.etc4_amt_2_v,0) - nvl(b.over_amt_2_v,0)  no_v_amt_1, \n" +
   			" nvl(b.etc4_amt_1,0) - nvl(b.etc4_amt_2,0) etc4_amt_1, ce.tax_chk0, ce.tax_chk1, ce.tax_chk2, ce.tax_chk3, \n" +
   			" nvl(b.over_amt_1,0) - nvl(b.over_amt_2,0) over_amt_1 , nvl(ce.tax_chk4, 'N') tax_chk4  \n" +
 			" from  scd_ext a, cls_etc ce, cls_etc_sub b \n" +
  			" where a.rent_mng_id = '"+ rent_mng_id + "' and a.rent_l_cd = '"+ rent_l_cd + "' and a.ext_st = '4' \n" +
  			" and a.rent_mng_id = b.rent_mng_id(+) and a.rent_l_cd = b.rent_l_cd(+) and a.rent_mng_id = ce.rent_mng_id(+) and a.rent_l_cd = ce.rent_l_cd(+)  \n" +
       		" and  nvl(a.bill_yn, 'Y')  = 'Y' and nvl(a.ext_pay_amt,0) = 0 ";
       			
   	
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
			System.out.println("[IncomDatabase:getClsEtcSub]\n"+e);			
			System.out.println("[IncomDatabase:getClsEtcSub]\n"+query);			
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
	
	public Vector getIncomCardList(String s_kd, String t_wd, String asc, String t_wd_chk)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select incom_dt, incom_seq, card_nm, card_no, remark, incom_amt, card_tax, card_cd  "+
				" from  incom "+
				" where ip_method = '2' and  jung_type = '1' ";
				
		if  ( t_wd.equals("비씨") ) {
			t_wd = "BC";
		}	
		if  ( t_wd.equals("케이씨피") ) {
			t_wd = "KCP";
		}	
				
		if(s_kd.equals("1"))		query += " and card_nm like '%"+t_wd+"%'" ;
		if(s_kd.equals("2"))		query += " and card_no  like '%"+t_wd+"%'";
		if(s_kd.equals("3"))		query += " and remark like '%"+t_wd+"%'";
				
		query+=" order by incom_dt, incom_seq ";
		
		if(asc.equals("0"))		query += " asc";
		else if(asc.equals("1"))	query += " desc";


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
			System.out.println("[IncomDatabase:getIncomCardList]\n"+e);
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
	
	public Vector getIncomCardList(String dt, String st_dt, String end_dt , String s_kd, String t_wd, String asc, String t_wd_chk)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select incom_dt, incom_seq, card_nm, card_no, remark, incom_amt, card_tax, card_cd  "+
				" from  incom "+
				" where ip_method = '2' and  jung_type = '1' ";
			
		if(dt.equals("2"))			query += " and incom_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(dt.equals("5"))		query += " and incom_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' ";
		else if(dt.equals("3")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and incom_dt like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and incom_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}
								
		if  ( t_wd.equals("비씨") ) {
			t_wd = "BC";
		}	
		if  ( t_wd.equals("케이씨피") ) {
			t_wd = "KCP";
		}	
					
		if(s_kd.equals("1"))		query += " and card_nm like '%"+t_wd+"%'" ;
		if(s_kd.equals("2"))		query += " and card_no  like '%"+t_wd+"%'";
		if(s_kd.equals("3"))		query += " and remark like '%"+t_wd+"%'";
				
		query+=" order by incom_dt, incom_seq ";
		
		if(asc.equals("0"))		query += " asc";
		else if(asc.equals("1"))	query += " desc";


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
			System.out.println("[IncomDatabase:getIncomCardList]\n"+e);
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
	 *	카드사 입금 처리 - 카드 청구내역 일괄입금처리리스트
	 */
	public Vector getScdCardClientList(String incom_in)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.* "+
				" from   incom a "+
				" where  "+ incom_in +			
				" order by a.incom_dt, a.incom_seq ";
	
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
			System.out.println("[IncomDatabase:getScdCardClientList]\n"+e);
			System.out.println("[IncomDatabase:getScdCardClientList]\n"+query);
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
	 *	고갹요청인 경우 세금계산서 발행 안함.
	 */
	public int getFeeScdStop(String m_id, String l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		String query = "";
		int cnt = 0;

		query = " select count(0)  from scd_fee_stop where rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"' and cancel_dt is null and stop_st = '2'";

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			if(rs.next())
			{				
				cnt	= rs.getInt(1);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[IncomDatabase:getFeeScdStop]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return cnt;
		}
	}
	
	
	// 기타입금 
   
	public boolean insertIncomEtc(IncomEtcBean base)
	{
	
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
											    	
		String query = " insert into incom_etc "+
						"(INCOM_DT,		INCOM_SEQ,		SEQ_ID,		N_VEN_CODE, 	N_VEN_NAME, "+
						" IP_ACCT,	IP_ACCT_AMT, REMARK, NEOM, ACCT_GUBUN ) values "+
						"(replace(?, '-', ''), ?, ?, ?, ?, "+
						" ?, ?, ?, ?, ?) ";
						
		try 
		{
			conn.setAutoCommit(false);			
			
			pstmt = conn.prepareStatement(query);
  			  		  			
			pstmt.setString(1, base.getIncom_dt());
			pstmt.setInt(2,    base.getIncom_seq());
			pstmt.setInt(3,    base.getSeq_id());
			pstmt.setString(4, base.getN_ven_code());
			pstmt.setString(5, base.getN_ven_name());
			pstmt.setString(6, base.getIp_acct());			
			pstmt.setLong(7, base.getIp_acct_amt());
			pstmt.setString(8, base.getRemark());	
			pstmt.setString(9, base.getNeom());		
			pstmt.setString(10, base.getAcct_gubun());				

		    pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
		} catch (Exception e) {
            try{
				System.out.println("[IncomDatabase:insertIncomEtc]"+e);
                conn.rollback();
            }catch(SQLException _ignored){}
			e.printStackTrace();
	  		flag = false;
		} finally {
			try{
				conn.setAutoCommit(true);
              	if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
		
	//입금 기타  조회 

	public IncomEtcBean getIncomIncomEtcBase(String incom_dt, int incom_seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		IncomEtcBean base = new IncomEtcBean();
		String query = "";
		
		query = " select C.N_VEN_CODE, C.N_VEN_NAME, C.IP_ACCT, C.IP_ACCT_AMT , C.REMARK, C.ACCT_GUBUN "+
			   " from INCOM_ETC C  where  C.incom_dt  = ? and C.incom_seq = ?";
		try
		{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, incom_dt);
			pstmt.setInt(2, incom_seq);
		   	rs = pstmt.executeQuery();
		
			while(rs.next())
			{					
				base.setIp_acct_amt	(rs.getString("IP_ACCT_AMT")	==null? 0:Long.parseLong(rs.getString("IP_ACCT_AMT")));
				base.setIp_acct(rs.getString("IP_ACCT")==null?"":rs.getString("IP_ACCT"));
				base.setN_ven_code(rs.getString("N_VEN_CODE")==null?"":rs.getString("N_VEN_CODE"));
				base.setN_ven_name(rs.getString("N_VEN_NAME")==null?"":rs.getString("N_VEN_NAME"));
				base.setRemark(rs.getString("REMARK")==null?"":rs.getString("REMARK"));
				base.setAcct_gubun(rs.getString("ACCT_GUBUN")==null?"":rs.getString("ACCT_GUBUN"));
								
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[IncomDatabase:getIncomIncomEtcBase]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return base;
		}
	}
	
	
	public Vector getIncomItemCardList(String incom_dt, int incom_seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select b.*, a.card_nm, a.card_no, a.remark, a.card_tax, a.incom_amt "+
				" from  incom a, incom_item b \n"+
				" where a.incom_dt = b.item_dt and a.incom_seq = b.item_seq and b.incom_dt = replace(?, '-', '') and b.incom_seq = ? ";
		
		query+=" order by  b.seq_id ";

		try {
				pstmt = conn.prepareStatement(query);
			    pstmt.setString(1, incom_dt		);
            	pstmt.setInt   (2, incom_seq	);    
				
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
			System.out.println("[IncomDatabase:getIncomItemCardList]\n"+e);
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
	

   /* KCP 카드 취소 */	
     public boolean updateIncomCardCanel(String incom_dt , int incom_seq) 
    {
      	getConnection();
        PreparedStatement pstmt = null;
        String query = "";
        boolean flag = true;
 		                
        query = " update incom set jung_type ='1' , card_tax = 0  where incom_dt = replace(?, '-', '') and incom_seq = ? ";			 
         
       try{
            conn.setAutoCommit(false);
           
            pstmt = conn.prepareStatement(query);            
        
            pstmt.setString(1, incom_dt		);
            pstmt.setInt   (2, incom_seq	);            
       
            pstmt.executeUpdate();
             
            pstmt.close();
            conn.commit();

    
    	} catch (Exception e) {
    		System.out.println("[IncomDatabase:updateIncomCardCanel]\n"+e);
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
     * 입금원장처리방식 등록  - 1 :해당건 처리, 3:카드사입금처리 4:보험사환급처리
     */
     
    public boolean updateIncomGubun(String incom_dt , int incom_seq, String p_gubun) 
    {
      	getConnection();
        PreparedStatement pstmt = null;
        String query = "";
        boolean flag = true;
 		                
        query = " update incom set p_gubun = ?  where incom_dt = replace(?, '-', '') and incom_seq = ? ";			 
         
       try{
            conn.setAutoCommit(false);
           
            pstmt = conn.prepareStatement(query);            
            pstmt.setString(1, p_gubun	);
               
            pstmt.setString(2, incom_dt		);
            pstmt.setInt   (3, incom_seq	);            
       
            pstmt.executeUpdate();
             
            pstmt.close();
            conn.commit();

    
    	} catch (Exception e) {
    		System.out.println("[IncomDatabase:updateIncomGubun]\n"+e);
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
     * 입금원장카드사변경등록
        */
     
    public boolean updatIncomCardCd(String incom_dt , int incom_seq, String card_cd) 
    {
      	getConnection();
        PreparedStatement pstmt = null;
        String query = "";
        boolean flag = true;
        
        String card_nm = "";
        
        if (card_cd.equals("1")) { 	
		    card_nm = "BC";
	} else if (card_cd.equals("2")) { 
		card_nm = "국민";
	} else if (card_cd.equals("4")) { 
		card_nm = "하나";	
	} else if (card_cd.equals("5")) { 
		card_nm = "롯데";	
	} else if (card_cd.equals("6")) { 
		card_nm = "현대";
	} else if (card_cd.equals("7")) { 
		card_nm = "삼성";	
	} else if (card_cd.equals("8")) { 
		card_nm = "씨티";	
	} else if (card_cd.equals("9")) { 
		card_nm = "KCP";	
	} else if (card_cd.equals("10")) { 
		card_nm = "KCP2";						
	} else if (card_cd.equals("11")) { 
		card_nm = "나이스";										
	} else if (card_cd.equals("12")) { 
		card_nm = "페이엣";																
	} else if (card_cd.equals("3")) { 
		card_nm = "신한";		
	}				
 		                
        query = " update incom set card_cd=? , card_nm =   ?  where incom_dt = replace(?, '-', '') and incom_seq = ? ";			 
         
       try{
            conn.setAutoCommit(false);
           
            pstmt = conn.prepareStatement(query);            
            pstmt.setString(1, card_cd	);
            pstmt.setString(2, card_nm	);
               
            pstmt.setString(3, incom_dt		);
            pstmt.setInt   (4, incom_seq	);            
       
            pstmt.executeUpdate();
             
            pstmt.close();
            conn.commit();

    
    	} catch (Exception e) {
    		System.out.println("[IncomDatabase:updatIncomCardCd]\n"+e);
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
		
	//은행거래내역 리스트 조회 - s_kd-> 1:계좌, 2:카드(청구분) - 1단계등록
	public Vector getIncomRegList(String s_kd, String t_wd, String gubun1, String st_dt, String end_dt, String bank_nm, String bank_no, String bank_code, String card_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" a.*, "+
				" decode( nvl(a.p_gubun, '0' ), '0', '1단계완료', '2단계완료' ) as p_gubun_nm, "+
				" decode(a.ip_method,'1','계좌','2','카드', '3', '현금', '5', '대체') as ip_me_nm "+
				" from incom a  "+
				" where a.ip_method  in ( '1' , '2', '3', '5') and a.jung_type not in ('1' , '2' , '6') ";
		
		String search = "";
		String what = "";

		if(gubun1.equals("2"))			query += " and a.incom_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun1.equals("1"))		query += " and a.incom_dt = to_char(sysdate,'YYYYMMDD')";
		else if(gubun1.equals("4"))		query += " and a.incom_dt = to_char(to_date(to_char(sysdate,'YYYYMMDD')) - 1, 'yyyymmdd') ";
		else if(gubun1.equals("5"))		query += " and a.incom_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' ";
		else if(gubun1.equals("3")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and a.incom_dt like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and a.incom_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		if(s_kd.equals("1"))			query += " and a.ip_method = '1'";
		else if(s_kd.equals("2"))		query += " and a.ip_method = '2'";
		else if(s_kd.equals("3"))		query += " and a.ip_method = '3'";
		else if(s_kd.equals("5"))		query += " and a.ip_method = '5'";
				
		if(!bank_nm.equals(""))		query += " and a.bank_nm ='" + bank_nm + "'";
		if(!bank_no.equals(""))		query += " and a.bank_no ='" + bank_no + "'";
		
		if(!bank_code.equals(""))		query += " and a.bank_nm  ='" + bank_code + "'";
		if(!card_cd.equals(""))			query += " and a.card_cd  ='" + card_cd + "'";
		
		query += " order by a.incom_dt, a.incom_seq ";

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
			System.out.println("[IncomDatabase:getIncomRegList]\n"+e);
			System.out.println("[IncomDatabase:getIncomRegList]\n"+query);
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
	
	
	//처리내역 리스트 조회  - 보험환급관련	
	public Vector getIncomInsList(String incom_dt, int incom_seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		
	 	query = " select  "+
				"        a.car_mng_id, a.ins_st, a.ins_sts, b.rent_mng_id, b.rent_l_cd, b.client_id, b.firm_nm, "+
				"        cr.car_no, cr.first_car_no, cr.car_nm, cn.car_name, b.use_yn, "+
				"        (decode(a.air_ds_yn,'Y',1,0)+decode(a.air_as_yn,'Y',1,0)) as air, decode(a.age_scp,'1','21세이상','2','26세이상','3','모든운전자') as age_scp, "+
				"        a.ins_com_id, d.ins_com_nm, e.ins_tm,  e.pay_amt, e.pay_yn, e.ins_tm2, "+
				"        decode(e.ins_tm2, '2', '해지', '1', '변경') ins_tm2_nm,  "+
				"        DECODE(a.ins_start_dt,'','',SUBSTR(a.ins_start_dt,1,4)||'-'||SUBSTR(a.ins_start_dt,5,2)||'-'||SUBSTR(a.ins_start_dt,7,2)) as ins_start_dt, "+
				"        DECODE(a.ins_exp_dt,'','',SUBSTR(a.ins_exp_dt,1,4)||'-'||SUBSTR(a.ins_exp_dt,5,2)||'-'||SUBSTR(a.ins_exp_dt,7,2)) as ins_exp_dt, "+
				"        DECODE(e.ins_est_dt,'','',SUBSTR(e.ins_est_dt,1,4)||'-'||SUBSTR(e.ins_est_dt,5,2)||'-'||SUBSTR(e.ins_est_dt,7,2)) as ins_est_dt, "+
				"        DECODE(e.r_ins_est_dt,'','',SUBSTR(e.r_ins_est_dt,1,4)||'-'||SUBSTR(e.r_ins_est_dt,5,2)||'-'||SUBSTR(e.r_ins_est_dt,7,2)) as r_ins_est_dt, "+
				"        DECODE(e.pay_dt,'','',SUBSTR(e.pay_dt,1,4)||'-'||SUBSTR(e.pay_dt,5,2)||'-'||SUBSTR(e.pay_dt,7,2)) as pay_dt \n"+
				" from   insur a, cont_n_view b, ins_com d, car_reg cr,  car_etc g, car_nm cn ,  scd_ins e, (select max(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%'  group by car_mng_id) f \n"+
				" where  a.car_mng_id=e.car_mng_id and a.ins_st=e.ins_st and a.ins_com_id=d.ins_com_id and a.car_mng_id=b.car_mng_id "+
				"	and a.car_mng_id = cr.car_mng_id  and b.rent_mng_id = g.rent_mng_id(+)  and b.rent_l_cd = g.rent_l_cd(+)  \n"+
                       		"	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+) \n"+
				"        and b.rent_l_cd=f.rent_l_cd  and nvl(e.pay_yn,'0')='1' \n"+
				"        and nvl(e.ins_tm2,'0') in ('2', '1') and replace(e.incom_dt, '-', '') = ? and e.incom_seq =  ?  \n"+
				" order by b.use_yn desc, a.ins_exp_dt  asc, b.firm_nm "; 
 
      
		try {
								
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, incom_dt);
			pstmt.setInt(2, incom_seq);				
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
			System.out.println("[IncomDatabase:getIncomInsList]\n"+e);
			System.out.println("[IncomDatabase:getIncomInsList]\n"+query);
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
     * 입금원장처리
     */
    public boolean updatIncomAmt(String incom_dt , int incom_seq, long incom_amt) 
    {
      	getConnection();
        PreparedStatement pstmt = null;
        String query = "";
        boolean flag = true;
 		                
        query = " update incom set incom_amt = ?  where incom_dt = replace(?, '-', '') and incom_seq = ? ";			 
         
       try{
            conn.setAutoCommit(false);
           
            pstmt = conn.prepareStatement(query);            
            pstmt.setLong(1, incom_amt	);
            pstmt.setString(2, incom_dt		);
            pstmt.setInt   (3, incom_seq	);            
       
            pstmt.executeUpdate();
             
            pstmt.close();
            conn.commit();

    
    	} catch (Exception e) {
    		System.out.println("[IncomDatabase:updatIncomAmt]\n"+e);
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
     * 입금원장처리
     */
    public boolean updatIncomReason(String incom_dt , int incom_seq, String re_chk, String reason) 
    {
      	getConnection();
        PreparedStatement pstmt = null;
        String query = "";
        boolean flag = true;
 		                
        query = " update incom set re_chk = ? , reason = ?  where incom_dt = replace(?, '-', '') and incom_seq = ? ";			 
         
       try{
            conn.setAutoCommit(false);
           
            pstmt = conn.prepareStatement(query);            
            pstmt.setString(1, re_chk	);
            pstmt.setString(2, reason	);
            pstmt.setString(3, incom_dt		);
            pstmt.setInt   (4, incom_seq	);            
       
            pstmt.executeUpdate();
             
            pstmt.close();
            conn.commit();

    
    	} catch (Exception e) {
    		System.out.println("[IncomDatabase:updatIncomReason]\n"+e);
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
	
	
	//연체료 입금표 발행여부
	public String  getPayEbillDly( String rent_mng_id, String rent_l_cd, String pay_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";		
		String pubcode = "";			
		
		query = " select c.pubcode "+
				"  from scd_dly a, payebill c, incom_ebill d "+
				"	     where a.RENT_MNG_ID = '"+ rent_mng_id + "' and a.RENT_L_CD = '"+rent_l_cd+"'  "+
				"	       and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd and a.incom_dt = d.pay_dt  and d.pay_dt =  replace('"+pay_dt+"', '-','')"  +
				"	       and a.pay_amt > 0 and  d.gubun= 'dly' and d.seqid=c.seqid ";
		 					
		try {
		
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();	  
	    	
	    	
    		if(rs.next())
			{		
				pubcode = rs.getString(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[IncomDatabase:getPayEbillDly]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return pubcode;
		}
	} 
	
	//면책금 입금표 발행여부
	public String  getPayEbillCar_ja( String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";		
		String pubcode = "";			
		
		query = " select c.pubcode "+
				"  from scd_ext a, payebill c, incom_ebill d "+
				"	     where a.RENT_MNG_ID = '"+ rent_mng_id + "' and a.RENT_L_CD = '"+rent_l_cd+"'  and a.ext_st = '3' "+
				"	       and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd and a.ext_pay_dt = d.pay_dt "+
				"	       and a.ext_pay_amt > 0 and  d.gubun= 'car_ja' and d.seqid=c.seqid ";
		 					
		try {
		
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();	  
	    	
	    	
    		if(rs.next())
			{		
				pubcode = rs.getString(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[IncomDatabase:getPayEbillCar_ja]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return pubcode;
		}
	}   
	
		//해지정산금 입금표 발행여부
	public String  getPayEbillExt( String rent_mng_id, String rent_l_cd, String pay_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";		
		String pubcode = "";			
		
		query = " select c.pubcode "+
				"  from scd_ext a, payebill c, incom_ebill d "+
				"	     where a.RENT_MNG_ID = '"+ rent_mng_id + "' and a.RENT_L_CD = '"+rent_l_cd+"'  and a.ext_st = '4' "+
				"	       and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd and a.ext_pay_dt = d.pay_dt and d.pay_dt =  replace('"+pay_dt+"', '-','')"  +
				"	       and a.ext_pay_amt > 0 and  d.gubun= 'ext' and d.seqid=c.seqid ";
		 					
		try {
		
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();	  
	    	
	    	
    		if(rs.next())
			{		
				pubcode = rs.getString(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[IncomDatabase:getPayEbillExt]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return pubcode;
		}
	}   
	
		//승계수수료 입금표 발행여부
	public String  getPayEbillCommi( String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";		
		String pubcode = "";			
		
		
		query = " select c.pubcode "+
				"  from scd_ext a, payebill c "+
				"	     where a.RENT_MNG_ID = '"+ rent_mng_id + "' and a.RENT_L_CD = '"+rent_l_cd+"'  and a.ext_st = '5' "+
				"	       and a.ext_pay_amt > 0 and  a.seqid=c.seqid ";	
				
		 					
		try {
		
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();	  
	    	
	    	
    		if(rs.next())
			{		
				pubcode = rs.getString(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[IncomDatabase:getPayEbillCommi]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return pubcode;
		}
	}   
	
		// 입금표 발행여부
	public String  getPayEbillScdExt( String rent_mng_id, String rent_l_cd, String  seqid, String gubun)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";		
		String pubcode = "";			
		
		query = " select c.pubcode "+
				"  from scd_ext a, payebill c "+
				"	     where a.RENT_MNG_ID = '"+ rent_mng_id + "' and a.RENT_L_CD = '"+rent_l_cd+"'  and a.ext_st = '" + gubun + "' "+
				"	       and a.ext_pay_amt > 0 and  a.seqid=c.seqid ";
		 					
		try {
		
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();	  
	    	
	    	
    		if(rs.next())
			{		
				pubcode = rs.getString(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[IncomDatabase:getPayEbillScdExt]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return pubcode;
		}
	}   
	
		// 입금표 발행여부 -  입금일 추가 
	public String  getPayEbillScdExt( String rent_mng_id, String rent_l_cd, String  seqid, String gubun, String incom_dt )
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";		
		String pubcode = "";			
		
		query = " select c.pubcode "+
				"  from scd_ext a, payebill c "+
				"	     where a.RENT_MNG_ID = '"+ rent_mng_id + "' and a.RENT_L_CD = '"+rent_l_cd+"'  and a.ext_st = '" + gubun + "' "+
				"	       and a.ext_pay_amt > 0 and  a.seqid=c.seqid  and a.incom_dt = '"+incom_dt +"'";
		 					
		try {
		
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();	  
	    	
	    	
    		if(rs.next())
			{		
				pubcode = rs.getString(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[IncomDatabase:getPayEbillScdExt]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return pubcode;
		}
	}   
	
	//보증금 입금표 발행여부
	public String  getPayEbillGrt( String rent_mng_id, String rent_l_cd, String  seqid )
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";		
		String pubcode = "";			
		
		query = " select c.pubcode "+
				"  from scd_ext a, payebill c "+
				"	     where a.RENT_MNG_ID = '"+ rent_mng_id + "' and a.RENT_L_CD = '"+rent_l_cd+"'  and a.ext_st = '0' "+
				"	       and a.ext_pay_amt > 0 and  a.seqid=c.seqid ";
		 					
		try {
		
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();	  
	    	
	    	
    		if(rs.next())
			{		
				pubcode = rs.getString(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[IncomDatabase:getPayEbillGrt]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return pubcode;
		}
	}   
	
	
	/**
	 *	분할처리
	 */
	public int getFeeRtnCnt(String m_id, String l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		String query = "";
		int cnt = 0;

		query = " select count(0)  from fee_rtn where rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"'" ;

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			if(rs.next())
			{				
				cnt	= rs.getInt(1);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[IncomDatabase:getFeeRtnCnt]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return cnt;
		}
	}

	
	//fee_rtn_ven_code
	public String  getFeeRtnVencode( String rent_mng_id, String rent_l_cd, String  rent_st, String rent_seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";		
		String ven_code = "";			
					
		query = "  select case when  a.r_site is null then decode(nvl(b.tax_type, '1'), '1', c.ven_code)  else s.ven_code end  \n"+ 
    			"   from fee_rtn a, client c, client_site s , cont b \n"+
                "  where a.RENT_MNG_ID = '"+ rent_mng_id + "'and a.RENT_L_CD = '"+rent_l_cd+"' and a.rent_st ='"+rent_st+"' and a.rent_seq = '"+rent_seq+"'"+
                "    and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd and a.client_id = c.client_id(+) \n"+ 
                "    and a.client_id = s.client_id(+)  and a.r_site = s.seq(+) "; 
			 					
		try {
		
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();	  	    	
	    	
    		if(rs.next())
			{		
				ven_code = rs.getString(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[IncomDatabase:getFeeRtnVencode]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ven_code;
		}
	}   
	
	
	/**
     * 미확인입금 reply처리 insertIncomReply(incom_dt, incom_seq, reply_id, reply_cont );
     */
    public boolean insertIncomReply(String incom_dt , int incom_seq, String reply_id, String reply_cont) 
    {
      	getConnection();
        PreparedStatement pstmt = null;
        String query = "";
        boolean flag = true; 		                
 												    	
		query = " insert into incom_reply "+
						"(INCOM_DT,	INCOM_SEQ,	REPLY_ID,	REPLY_CONT,	REG_DT ) values "+
						"(replace(?, '-', ''), ?, ?, ?, to_char(sysdate,'YYYYMMdd') ) ";              
 		                       
         
       try{
            conn.setAutoCommit(false);
           
            pstmt = conn.prepareStatement(query);            
      
            pstmt.setString(1, incom_dt		);
            pstmt.setInt   (2, incom_seq	);   
            pstmt.setString(3, reply_id		);
            pstmt.setString(4, reply_cont	);  
       
            pstmt.executeUpdate();
             
            pstmt.close();
            conn.commit();

    
    	} catch (Exception e) {
    		System.out.println("[IncomDatabase:insertIncomReply]\n"+e);
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
  //20220101 계약일 기준 연체
	public int getReCalDelayAmt(String m_id, String l_cd, String incom_dt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		String query = "";
		int cnt = 0;

		query = " select  (nvl(j.dly_fee,0)-nvl(k.pay_amt,0)) dly_fee " +
			//	"	 from cont a, (select a.rent_mng_id, a.rent_l_cd , sum((TRUNC(((decode(nvl(a.rc_amt,0),0,a.fee_s_amt+a.fee_v_amt,a.rc_amt))*(case when decode(c.rent_suc_dt,'',nvl(f.rent_dt,b.rent_dt),c.rent_suc_dt) >= '20220101' then 0.20 else 0.24 end)*TRUNC(TO_DATE(a.r_fee_est_dt, 'YYYYMMDD')- NVL(TO_DATE(a.rc_dt, 'YYYYMMDD'), to_date('"+incom_dt+"', 'yyyymmdd'))))/365) * -1)) dly_fee from scd_fee a, cont b, fee f, cont_etc c WHERE a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd  and  a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_st = f.rent_st and a.rent_l_cd=c.rent_l_cd and nvl(a.rc_dt, '"+ incom_dt +"') > a.r_fee_est_dt  and nvl(a.bill_yn, 'Y' ) = 'Y' group by a.rent_mng_id, a.rent_l_cd ) j, " +
		     	" from cont a, (select a.rent_mng_id, a.rent_l_cd , sum((TRUNC(((decode(nvl(a.rc_amt,0),0,a.fee_s_amt+a.fee_v_amt,a.rc_amt))*(case when decode(c.rent_suc_dt,'',decode(f.rent_st,'1',b.rent_dt,f.rent_dt),c.rent_suc_dt) >= '20220101' then 0.20 else 0.24 end)*TRUNC(TO_DATE(a.r_fee_est_dt, 'YYYYMMDD')- NVL(TO_DATE(a.rc_dt, 'YYYYMMDD'), to_date('"+incom_dt+"', 'yyyymmdd'))))/365) * -1)) dly_fee from scd_fee a, cont b, fee f, cont_etc c WHERE a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd  and  a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_st = f.rent_st and a.rent_l_cd=c.rent_l_cd and nvl(a.rc_dt, '"+ incom_dt +"') > a.r_fee_est_dt  and nvl(a.bill_yn, 'Y' ) = 'Y' group by a.rent_mng_id, a.rent_l_cd ) j, " +
				"	 (select rent_mng_id, rent_l_cd , sum(pay_amt) pay_amt from scd_dly group by rent_mng_id , rent_l_cd ) k  " +
				"	 where a.rent_mng_id='"+m_id+"' and a.rent_l_cd='"+l_cd+"'"  +
				"	 and a.rent_mng_id=j.rent_mng_id(+) and a.rent_l_cd = j.rent_l_cd(+)  and a.rent_mng_id=k.rent_mng_id(+) and a.rent_l_cd = k.rent_l_cd(+)  " ;	
		
		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			if(rs.next())
			{				
				cnt	= rs.getInt(1);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[IncomDatabase:getReCalDelayAmt]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return cnt;
		}
	}
	
	
	/**
	 *	연체이자 계산  - 해지된 건은 해지일로 기준해야 함. -  추가예정
	 */
	public boolean calReScdDly(String s_c_id)
	{
		getConnection();
		boolean flag = true;
		
		String query = "";
		
		query = "  UPDATE SCD_FEE a  SET  ( a.dly_days,  a.dly_fee) =  " +
		              "        ( select TRUNC(SYSDATE - TO_DATE(a.r_fee_est_dt, 'YYYYMMDD')),  " +
		              "           (TRUNC(((decode(a.rc_amt,0,a.fee_s_amt+a.fee_v_amt,a.rc_amt))*(case when decode(c.rent_suc_dt,'',nvl(f.rent_dt,b.rent_dt),c.rent_suc_dt) >= '20220101' then 0.20 else 0.24 end)*TRUNC(TO_DATE(a.r_fee_est_dt, 'YYYYMMDD')- sysdate))/365) * -1)  " +
		              "           from  cont b, fee f, cont_etc c    " +
		              "           where a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd  and  a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_st = f.rent_st and a.rent_l_cd=c.rent_l_cd   " +
		              "              and  nvl(a.bill_yn,'Y')='Y' and a.rc_dt is null and a.r_fee_est_dt <  to_char(sysdate,'YYYYMMDD')  " +
		              "              and  b.client_id  in  ( "+s_c_id +" )  ) "+                         
		      	    "  where exists ( select  'x'  from  cont b, fee f  where a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd  and  a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_st = f.rent_st   " +
		             "  and  nvl(a.bill_yn,'Y')='Y' and a.rc_dt is null and a.r_fee_est_dt <  to_char(sysdate,'YYYYMMDD')  " +
		             "  and  b.client_id  in ( "+s_c_id +" )  )" ;
		
		Statement stmt = null;

		try 
		{
			conn.setAutoCommit(true);

			stmt = conn.createStatement();
    		         stmt.executeUpdate(query);
			stmt.close();
			conn.commit();
		    
	  	} catch (Exception e) {
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	} 
	
	public int getCalTax(int pay_amt, double  rate)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		String query = "";
		int amt = 0;

		query = " select  round("+pay_amt+"*"+rate+") from dual ";
			
		try {
			stmt = conn.createStatement();
	    		rs = stmt.executeQuery(query);    	
			if(rs.next())
			{				
				amt	= rs.getInt(1);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[IncomDatabase:getCalTax]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return amt;
		}
	}
	
	//cms 인출 데이타 생성여부       
	public int  getCntCardMemberToday()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";		
		int cnt = 0;
				
		query = " select count(0) "+
 				"  from   cms.card_cms_mem a "+
				"  where  a.adate = to_char(sysdate,'YYYYMMdd') ";  //금일날짜 신청데이타가 있으면 				 			 		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		if(rs.next())
			{		
				cnt = rs.getInt(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[IncomDatabase:getCntCardMemberToday]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return cnt;
		}
	}
	
	//cms 인출 데이타 생성여부       
	public int  getCntCardMemberCmsBit()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";		
		int cnt = 0;
				
		query = " select count(0) "+
 				"  from   cms.card_cms_mem  "+
				"  where  cms_status = '1' ";  //금일날짜 신청데이타가 있으면 				 			 		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		if(rs.next())
			{		
				cnt = rs.getInt(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[IncomDatabase:getCntCardMemberCmsBit]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return cnt;
		}
	}
	
	/*
	 *	card member_user 데이타 생성  프로시져 호출
	*/
	public String call_sp_card_cms_member_reg()
	{
    	getConnection();
    	
    	String query = "{CALL P_CARD_CMS_MEMBER_REG (?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
			cstmt = conn.prepareCall(query);
			
			cstmt.registerOutParameter( 1, java.sql.Types.VARCHAR );
			
			cstmt.execute();
			sResult = cstmt.getString(1); // 결과값
			cstmt.close();
				
	
		} catch (SQLException e) {
			System.out.println("[IncomDatabase:call_sp_card_cms_member_reg]\n"+e);
			e.printStackTrace();
		} finally {
			try{
			     if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}	
	
	/**
	 *	//cms member 조회하기  -20200317 장기대여 추가 
	 */
	public Vector getCardMemberCmsList(String s_kd, String t_wd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String d_query = "";
		
	
		/*
		query = "select c.ama_id,  a.rent_l_cd, b.firm_nm, g.car_no, d.cms_day, d.cms_dep_nm, replace(d.cms_dep_ssn, '-', '') cms_dep_ssn, f.cms_bk, d.cms_bank,d.cms_acc_no, \n"+
			     "	'0' cms_status,  d.cms_start_dt , u.user_nm    \n"+	
			      "	from cont a, client b,  users u, cms.card_cms_mem c, \n"+
			      "	     (select a.* from card_cms_mng a,   (select rent_mng_id, rent_l_cd, max(seq) seq from card_cms_mng  where app_dt is not null group by rent_mng_id, rent_l_cd) b   where a.rent_l_cd=b.rent_l_cd and a.seq=b.seq) d, \n"+
			      "	     (select * from code where c_st='0003') f, car_reg g,   allot al  \n"+			
			      "	where \n"+
			   	"      nvl(a.use_yn, 'Y') ='Y'  and a.bus_id= u.user_id(+)  \n"+ //살아있는계약 
				"      and a.client_id=b.client_id \n"+
				"      and a.rent_l_cd=c.cms_primary_seq(+) \n"+
				"      and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+) \n"+
				"      and a.rent_mng_id=al.rent_mng_id(+) and a.rent_l_cd=al.rent_l_cd(+)   \n"+		
				"      and d.cms_bank=f.nm(+) \n"+
				"      and a.car_mng_id=g.car_mng_id(+) \n"+
				"      and  ( c.cms_primary_seq is null  or  d.reg_st = '11'  ) \n"+  //--cust 미등록건 
				"      and d.rent_l_cd is not null \n"+    //--cms_mng 등록건 
				" order by  d.cms_start_dt , c.ama_id, a.rent_l_cd  ";
			*/
			/*
			query = "	 select  decode(nvl(d.reg_st, '0') , '22', 'D', d.reg_st ) status, '30042445' ama_id, a.rent_l_cd, b.firm_nm,  g.car_no, d.cms_day, d.cms_bank,  d.cms_dep_ssn, d.cms_dep_nm ,  \n"+
						 "    replace(d.cms_acc_no, '-', '') card_no ,  d.c_yyyy||d.c_mm card_prid, d.seq	,  replace(nvl(d.cms_m_tel, m.client_user_tel) , '-', '') cms_m_tel, 	'0' cms_status 	\n"+	     	
						"			      	from cont a, client b, car_reg g,  cms.CARD_CMS_MEM c, fee_rm fr,  \n"+
						"                    (select a.* from CARD_CMS_MNG a,   (select rent_mng_id, rent_l_cd, max(seq) seq from CARD_CMS_MNG  where app_dt is not null group by rent_mng_id, rent_l_cd) b   where a.rent_l_cd=b.rent_l_cd and a.seq=b.seq ) d, \n"+
						"                    (SELECT * FROM alink.RM_RENT_LINK_M WHERE NVL(DOC_YN,'Y')<>'D' \n"+ // --AND cms_type='card' 
						"                            )m, \n"+  //--모바일 전자계약서 계약내용
						"                    (SELECT * FROM alink.TMSG_QUEUE WHERE res_msg='정상') e \n"+ //--모바일 전자계약서 처리상태	 	          
						"	  	where nvl(a.use_yn, 'Y' ) ='Y'   \n"+
						"		   and a.client_id=b.client_id  \n"+
						"		   and a.rent_l_cd=c.cms_primary_seq(+)  \n"+
						"		   and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+)  \n"+
						"         and  a.car_mng_id = g.car_mng_id(+)  \n"+
						"        and a.rent_mng_id = fr.rent_mng_id(+) and a.rent_l_cd = fr.rent_l_cd(+) and nvl(fr.cms_type, 'cms' ) = 'card'  \n"+
						"		   and ( c.cms_primary_seq is null   or d.reg_st in ('11' , '22')  )  \n"+ // --cust 미등록건  or reg_st = '11' :재신청인건 , 22:해지신청   )  
						"		   and d.rent_l_cd is not null  \n"+
						"		   and d.c_yyyy is not null  \n"+
						"		   and d.c_mm is not null  \n"+
						"         AND a.rent_l_cd=m.rent_l_cd(+)  \n"+
						"         AND m.tmsg_seq=e.tmsg_seq(+) ";
				*/		
						
					query = "	 select   decode(nvl(d.reg_st, '0') , '22', 'D', d.reg_st ) status, '30042445' ama_id, a.rent_l_cd, b.firm_nm,  g.car_no, d.cms_day, d.cms_bank,  d.cms_dep_ssn, d.cms_dep_nm ,  replace(d.cms_dep_nm, ' ', ''),  \n"+
         						"  trim(replace(d.cms_acc_no, '-', '')) card_no , SUBSTR(d.cms_acc_no,1,6)||'******'||SUBSTR(d.cms_acc_no,13,4) m_card_no , d.c_yyyy||d.c_mm card_prid, d.seq, replace(d.cms_m_tel,  '-', '') cms_m_tel ,  '0' cms_status 	\n"+		     	
   								"  from cont a, client b, car_reg g, cms.CARD_CMS_MEM c,  ( select * from fee_rm where rent_st = '1' ) fbr ,  \n"+
   								"  (select a.* from fee_rm a,   (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee_rm  group by rent_mng_id, rent_l_cd) b  where a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st) fr , \n"+
			      				"  (select a.* from CARD_CMS_MNG a,   (select rent_mng_id, rent_l_cd, max(seq) seq from CARD_CMS_MNG  where app_dt is not null group by rent_mng_id, rent_l_cd) b   where a.rent_l_cd=b.rent_l_cd and a.seq=b.seq) d	     \n"+	 	          
	  							" where nvl(a.use_yn, 'Y' ) ='Y'   \n"+
		   						" and a.client_id=b.client_id  \n"+
		   						" and  a.car_mng_id = g.car_mng_id(+)  \n"+
		   						" and a.rent_l_cd=c.cms_primary_seq(+)  \n"+
		   						" and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+)  \n"+
		   						" and ( c.cms_primary_seq is null   or d.reg_st in ('11' , '22')  )   --cust 미등록건  or reg_st = '11' :재신청인건 , 22:해지신청   )  \n"+
		   						" and a.rent_mng_id = fr.rent_mng_id(+) and a.rent_l_cd = fr.rent_l_cd(+)  \n"+
		   						" and a.rent_mng_id = fbr.rent_mng_id(+) and a.rent_l_cd = fbr.rent_l_cd(+) and nvl(fbr.cms_type, 'cms' ) = 'card'  \n"+
		  						" and d.rent_l_cd is not null \n"+
           					" and d.c_yyyy  is not null  \n"+
           					" and d.c_mm  is not null \n"+
           				    " union all \n"+ 
           			         " select   decode(nvl(d.reg_st, '0') , '22', 'D', d.reg_st ) status, '30042445' ama_id, a.rent_l_cd, b.firm_nm,  g.car_no, d.cms_day, d.cms_bank,  d.cms_dep_ssn, d.cms_dep_nm ,  replace(d.cms_dep_nm, ' ', ''),   \n"+
           			        " trim(replace(d.cms_acc_no, '-', '')) card_no , SUBSTR(d.cms_acc_no,1,6)||'******'||SUBSTR(d.cms_acc_no,13,4) m_card_no ,  d.c_yyyy||d.c_mm card_prid, d.seq, replace(d.cms_m_tel,  '-', '') cms_m_tel  ,  '0' cms_status   \n"+
           			        " from cont a, client b, car_reg g, cms.CARD_CMS_MEM c, ( select * from fee where rent_st = '1' ) fbr ,    \n"+
           			        "   (select a.* from fee a,   (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee  group by rent_mng_id, rent_l_cd) b  where a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st) fr ,   \n"+
           					"   (select a.* from CARD_CMS_MNG a,   (select rent_mng_id, rent_l_cd, max(seq) seq from CARD_CMS_MNG  where app_dt is not null group by rent_mng_id, rent_l_cd) b   where a.rent_l_cd=b.rent_l_cd and a.seq=b.seq) d   \n"+
           				  	" where nvl(a.use_yn, 'Y' ) ='Y' \n"+
           					"   and a.client_id=b.client_id \n"+
           					"   and  a.car_mng_id = g.car_mng_id(+)  \n"+
           					"   and a.rent_l_cd=c.cms_primary_seq(+) \n"+
           					"   and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+) \n"+
           			        "   and a.rent_mng_id = fr.rent_mng_id(+) and a.rent_l_cd = fr.rent_l_cd(+) \n"+
           			        "   and a.rent_mng_id = fbr.rent_mng_id(+) and a.rent_l_cd = fbr.rent_l_cd(+)   \n"+        
           			        "   and fbr.fee_pay_st = '6'  and a.car_st not in ('4') \n"+
           					"   and ( c.cms_primary_seq is null   or d.reg_st in ('11' , '22')  )   \n"+   
           					"   and d.rent_l_cd is not null \n"+
           			        "   and d.c_yyyy  is not null \n"+
           			        "   and d.c_mm  is not null ";  //장기대여 추가 2020-03-17	     						
              					
				
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
			System.out.println("[IncomDatabase:getMemberCmsList]\n"+e);
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
	
	//cms 인출 데이타 생성여부       
	public int  getCntCardPayCmsBit()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";		
		int cnt = 0;
				
		query = " select count(0) "+
 				"  from   cms.card_cms_pay  "+
				"  where  result in (  '0' )  and result_code is null  ";  //금일날짜 신청데이타가 있으면 				 			 		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		if(rs.next())
			{		
				cnt = rs.getInt(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[IncomDatabase:getCntCardPayCmsBit]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return cnt;
		}
	}
	
	
		//cms 인출 데이타 생성여부   -cmsbank에 사용할거 
	public int  getCntCardCmsBit(String adate)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";		
		int cnt = 0;
					
		query = " select count(0) "+
 				"  from  cms.CARD_CMS_PAY "+
				"  where  adate = replace('"+adate+"', '-', '') ";
				 			 		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		if(rs.next())
			{		
				cnt = rs.getInt(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[IncomDatabase:getCntCardCmsBit]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return cnt;
		}
	}
	
	/*
	 *	card_jip_cms 데이타 생성  프로시져 호출
	*/
	public String call_sp_card_cms_reg(String a_date)
	{
    	getConnection();
    	
    	String query = "{CALL P_CARD_CMS_PAY_REG (?,?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
			cstmt = conn.prepareCall(query);
			
			cstmt.setString(1, a_date);
			cstmt.registerOutParameter( 2, java.sql.Types.VARCHAR );
			
			cstmt.execute();
			sResult = cstmt.getString(2); // 결과값
			cstmt.close();
				
	
		} catch (SQLException e) {
			System.out.println("[IncomDatabase:call_sp_card_cms_reg]\n"+e);
			e.printStackTrace();
		} finally {
			try{
			     if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}	
	
		/**
	 *	//jip_cms  출금의뢰일 조회하기
	 */
	public Vector getACardJipCmsDate()
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select adate from card_jip_cms group by adate order by adate desc";

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
			System.out.println("[IncomDatabase:getACardJipCmsDate]\n"+e);
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
	 *	//card jip_cms  출금의뢰일 조회하기 - org_code는 ama_id로  
	 */
	public Vector getCardJipCmsDateList(String adate, String s_kd, String t_wd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String d_query = "";
		
		if ( s_kd.equals("1") ) d_query = " and nvl(f.r_site,c.firm_nm) like '%"+ t_wd + "%'";
		if ( s_kd.equals("2") ) d_query = " and  d.car_no like '%"+ t_wd + "%'";
		if ( s_kd.equals("3") ) d_query = " and  b.rent_l_cd like '%"+ t_wd + "%'";
	//	if ( s_kd.equals("4") ) d_query = " and  nvl(a.org_code, '30042445') like '%"+ t_wd + "%'";

		query = " select a.*, decode(b.tax_type,'2',nvl(f.r_site,c.firm_nm),c.firm_nm) as firm_nm, d.car_no, nvl(a.org_code, '30042445') r_org_code \n"+
			    " from card_jip_cms a, cont b, client c, car_reg d, client_site f \n"+
		 		" where adate = replace('"+ adate + "', '-','') " + d_query +
		 		" and a.acode=b.rent_l_cd and b.client_id=c.client_id and b.car_mng_id=d.car_mng_id(+) and b.client_id=f.client_id(+) and b.r_site=f.seq(+)"+
				"  order by a.org_code, a.seq ";

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
			System.out.println("[IncomDatabase:getCardJipCmsDateList]\n"+e);
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
	 *	//nice  cms member 조회하기
	 */
	public Vector getCardNiceMemberCmsList(String s_kd, String t_wd, String st_dt, String end_dt, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String period_gubun )
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

					
 		query = "	 select '30042445' ama_id, a.rent_l_cd, b.firm_nm,  d.cms_day, d.cms_bank, c.client_nm,  \n"+
 					 "	d.cms_dep_ssn,  SUBSTR(c.CARD_NO,1,6)||'******'||SUBSTR(c.CARD_NO,13,4)  card_no , c.card_prid,  c.cms_tel,   \n"+
 					 " decode(c.cms_status , '0', '신규신청',  '1', '전송', '3', '해지신청', 'Y', '정상', 'N', '오류', 'U', '수정', c.cms_status) cms_status , c.cms_error, c.cms_message ,		 \n"+
					"  decode(c.pross , '1', '신청',  '3', '해지', 'U', '수정', c.pross) pross , a.use_yn  , c.cms_message , c.adate \n"+
					 "	from cont a, client b, cms.CARD_CMS_MEM c,  \n"+
					 "		     (select a.* from CARD_CMS_MNG a,   (select rent_mng_id, rent_l_cd, max(seq) seq from CARD_CMS_MNG  where app_dt is not null group by rent_mng_id, rent_l_cd) b   where a.rent_l_cd=b.rent_l_cd and a.seq=b.seq ) d \n"+
					 "	where 	a.client_id=b.client_id \n"+
					 "	   and a.rent_l_cd=c.cms_primary_seq  \n"+
					 "	   and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+) ";
	
		//검색조건 추가???		
			
		String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";


		dt1 = "substr(d.app_dt,1,6)";
		dt2 = "d.app_dt";

		if(gubun3.equals("2"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun3.equals("1"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
		else if(gubun3.equals("4"))		query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";//전일
		else if(gubun3.equals("3")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}
	
		if(period_gubun.equals("Y"))	query += " and a.use_yn = 'Y' ";
		if(period_gubun.equals("N"))	query += " and a.use_yn = 'N' ";
				
		if(s_kd.equals("1"))	what = "upper(nvl(b.firm_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(a.rent_l_cd, ' '))";	
	//	if(s_kd.equals("3"))	what = "upper(nvl(d.car_no, ' '))";		
	
		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper(replace('%"+t_wd+"%','-','')) ";

		}	
				
		query += " order by decode(a.use_yn,'Y','2','N','3','1'), c.cms_status, c.adate desc ";
          				
				
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
			System.out.println("[IncomDatabase:getCardNiceMemberCmsList]\n"+e);
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
	 *	//nice  cms pay  조회하기
	 */
	public Vector getCardNicePayCmsList(String s_kd, String t_wd, String adate)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

					
 		query = "	 select c.ama_id, d.user_no,  c.client_nm, c.card_no , c.card_prid,  c.cms_tel,   d.adate ,   \n"+
 					 "	 d.amount, d.r_amount, d.commission, d.appr_no, d.result, d.result_code, d.result_info, d.pross , cr.car_no , d.seq_num  \n"+ 				
					 "	from  cms.CARD_CMS_MEM c,  cms.card_cms_pay d , cont b , car_reg cr  \n"+					
					 "	where 	d.user_no =c.cms_primary_seq  and c.cms_primary_seq = b.rent_l_cd and b.car_mng_id = cr.car_mng_id and d.adate = '" + adate + "'  \n"+
					 "	  ";
	
		//검색조건 추가???		
			
		String search = "";
		String what = "";
	
	
		if(s_kd.equals("1"))	what = "upper(nvl(c.client_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(d.user_no, ' '))";	

	
		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper(replace('%"+t_wd+"%','-','')) ";

		}	
		
		query += " order by d.seq_num,   d.user_no ";
          				
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
			System.out.println("[IncomDatabase:getCardNicePayCmsList]\n"+e);
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
     * 카드 cms 인출금액 수정 
     */
    public boolean updateCardCmsPayAmount(String adate, String rent_l_cd,  int amount) 
    {
      	getConnection();
        PreparedStatement pstmt = null;
        String query = "";
        boolean flag = true; 		                
 												    	
		query = " update CMS.CARD_CMS_PAY   "+
						" set amount = ?  "+
						" where adate = replace(?, '-', '')  and user_no = ? and result = '0' ";              
 		                       
         
       try{
            conn.setAutoCommit(false);
           
            pstmt = conn.prepareStatement(query);            
      
       	  pstmt.setInt   (1, amount	);   
            pstmt.setString(2, adate		);
            pstmt.setString  (3, rent_l_cd	);   
            
            pstmt.executeUpdate();
             
            pstmt.close();
            conn.commit();

    
    	} catch (Exception e) {
    		System.out.println("[IncomDatabase:updateCardCmsPayAmount]\n"+e);
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
	
	
	  	//card CMS 고객 리스트 조회 (gubun - 1:상호, 2:계약번호) - cont에서  incom 으로 - 20171019
	public Vector getCardCmsContRmList(String s_kd, String t_wd, String st_dt, String end_dt, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select  "+
				" a.rent_mng_id, a.rent_l_cd, a.client_id, a.car_mng_id, a.car_st, "+
				" a.rent_dt, c.firm_nm, d.car_no, b.rent_start_dt,"+
				" decode(nvl(e.cnt,0),0,'-','생성') scd_yn,"+
				" decode(f.reg_st,'1',decode(f.app_dt,'','-','신청'),'2','해지','-') reg_st,"+
				" decode(a.use_yn,'Y','진행','N','해지','미결') use_st,"+
				" f.cms_day, f.cms_bank,  SUBSTR(f.cms_acc_no,1,6)||'******'||SUBSTR(f.cms_acc_no,13,4) cms_acc_no, f.cms_dep_nm,"+		
				" decode(g.cms_status, '0', '신규', '1','신규신청중','Y','완료','11','해지','-') cbit, \n"+
				" h.user_nm, h2.user_nm as reg_nm, h3.user_nm as app_nm, f.app_dt, b.rent_st, i.rent_suc_dt, f.cms_start_dt , f.c_yyyy, f.c_mm  "+
				" from   cont a, fee b, client c, car_reg d, ( select * from fee_rm where rent_st = '1' ) fbr ,"+
				"        (select rent_mng_id, rent_l_cd, count(*) cnt from scd_fee group by rent_mng_id, rent_l_cd) e,"+
				"        (select a.* from fee_rm a,   (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee_rm  group by rent_mng_id, rent_l_cd) b  where a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st) fr , "+			
				"        card_cms_mng f, cms.CARD_CMS_MEM  g, users h, users h2, users h3, cont_etc i "+
				" where a.car_st = '4' "+
				" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_st='1'"+
				" and a.client_id=c.client_id "+
				" and a.car_mng_id=d.car_mng_id(+)"+
				" and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+) "+
				" and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd  "+
				" and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd  "+
				" and a.rent_mng_id = fr.rent_mng_id(+) and a.rent_l_cd = fr.rent_l_cd(+)   "+
				" and a.rent_mng_id = fbr.rent_mng_id(+) and a.rent_l_cd = fbr.rent_l_cd(+) and nvl(fbr.cms_type, 'cms' ) = 'card'  "+
				" and a.rent_l_cd=g.cms_primary_seq(+) "+
				" and decode(b.rent_st,'1',a.bus_id,b.ext_agnt)=h.user_id "+
				" and f.reg_id=h2.user_id(+) "+
    			" and f.app_id=h3.user_id(+) "+
				" and a.rent_mng_id=i.rent_mng_id(+) and a.rent_l_cd=i.rent_l_cd(+)"+				 		
				" " ;


		String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";


		dt1 = "substr(f.app_dt,1,6)";
		dt2 = "f.app_dt";

		if(gubun3.equals("2"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun3.equals("1"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
		else if(gubun3.equals("4"))		query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";//전일
		else if(gubun3.equals("3")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		if(!gubun4.equals("")){	
			if(gubun4.equals("9"))		query += " and g.cms_status is null and nvl(a.use_yn,'Y')='Y' and e.rent_l_cd||b.rent_start_dt is not null ";//
			else 						query += " and g.cms_status='"+gubun4+"'";
		}

		if(gubun1.equals("2"))			query += " and f.app_dt is not null and f.reg_st='2'";
		else{
			if(gubun1.equals("Y"))			query += " and f.app_dt is not null";
			else if(gubun1.equals("N"))		query += " and f.app_dt is null and nvl(a.use_yn,'Y')='Y' and e.rent_l_cd||b.rent_start_dt is not null ";// 
		}

		if(s_kd.equals("1"))	what = "upper(nvl(c.firm_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(a.rent_l_cd, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(d.car_no, ' '))";		
		if(s_kd.equals("4"))	what = "upper(nvl(h.user_nm, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(b.rent_start_dt, ' '))";	
		if(s_kd.equals("6"))	what = "upper(nvl(f.app_dt, ' '))";	
		if(s_kd.equals("7"))	what = "upper(nvl(f.cms_start_dt, ' '))";	
		if(s_kd.equals("8"))	what = "upper(nvl(h2.user_nm, ' '))";	
		if(s_kd.equals("9"))	what = "upper(nvl(f.cms_acc_no, ' '))";	
		if(s_kd.equals("10"))	what = "upper(nvl(h3.user_nm, ' '))";	


		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper(replace('%"+t_wd+"%','-','')) ";

		}else{
//			if(gubun1.equals(""))		query += " and nvl(a.use_yn,'Y')='Y' and f.app_dt is null and f.cms_dep_ssn is null ";
		}	
		
		if(s_kd.equals("6")) 		query += " order by h2.user_nm, decode(a.use_yn,'Y','2','N','3','1'), decode(g.cms_status,'',0,1), nvl(f.cms_acc_no, 'N' ) , f.cms_start_dt, b.rent_start_dt, a.rent_dt, a.rent_mng_id";
		else						query += " order by decode(a.use_yn,'Y','2','N','3','1'), decode(g.cms_status,'',0,1),nvl(f.cms_acc_no, 'N' ) ,   f.cms_start_dt,  b.rent_start_dt, a.rent_dt, a.rent_mng_id";

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

//			System.out.println("[IncomDatabase:getCmsContRmList]\n"+query);
		} catch (SQLException e) {
			System.out.println("[IncomDatabase:getCardCmsContRmList]\n"+e);
			System.out.println("[IncomDatabase:getCardCmsContRmList]\n"+query);
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

		 // 입금거래처 매칭관련 정보  (tr_branch, naeyong, jukyo);
	public Hashtable getInsideClient(String tr_branch, String naeyong, String jukyo )
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";		
		
		query = " select distinct  ct.client_id, cl.firm_nm || '( '|| cl.client_nm  || ' )'   firm_nm \n"  + 
			"	 from EBANK.IB_ACCTALL_TR_DD a, amazoncar.erp_bank b  , incom c , scd_fee sf , cont ct , client cl  \n"  + 
			"	 where a.tr_date between to_char(add_months(sysdate, -6) , 'yyyymmdd')  and  to_char(sysdate,'YYYYMMdd')  \n"  + 
			"	   and a.tr_date = c.incom_dt and trim(a.tr_date_seq) = c.tr_date_seq and trim(a.acct_seq) = c.acct_seq \n"  + 
			"	   and c.incom_dt = sf.incom_dt and c.incom_seq = sf.incom_seq \n"  +
			"	   and decode(a.acct_nb , '14989003035104', '05', trim(a.bank_id) )  = b.bank_id(+) \n"  + 
			"	   and decode(a.acct_nb , '14989003035104' , '02822080807', a.acct_nb )  = b.acct_num(+)  \n"  + 
			"	   and a.acct_nb <> '140007754041'  \n"  + 		
			"	   and sf.rent_mng_id = ct.rent_mng_id  and sf.rent_l_cd = ct.rent_l_cd and ct.client_id = cl.client_id \n"  + 
			"	   and a.br_nm = '"+tr_branch+ "' and a.naeyong= '" + naeyong +"' and a.jukyo = '" + jukyo + "'" ;    

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
			System.out.println("[IncomDatabase:getInsideClient]\n"+e);			
			System.out.println("[IncomDatabase:getInsideClient]\n"+query);			
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


		 // 보증금(선수금)  매칭관련 정보  (tr_branch, naeyong, jukyo);
	public Hashtable getInsideGrt(String tr_date,  int  pay_amt )
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";		
		
		query = "		    select distinct   c.client_id,  d.firm_nm || '( '|| d.client_nm  || ' )'  firm_nm "  + 
			"				from EBANK.IB_ACCTALL_TR_DD  a, scd_ext b  , cont c , client d  "  + 
			"				 where a.tr_date = '"+tr_date+ "' and a.tr_ipji_gbn = '1'  and a.erp_fms_yn = 'N'   "  + 
			"				   and  b.ext_st = '0' and b.ext_tm = '1' and b.ext_pay_amt = 0   "  + 
			"				   and round(a.tr_amt) = b.ext_s_amt + b.ext_v_amt  and b.bill_yn = 'Y'  and   round(a.tr_amt) = " + pay_amt + 
			"				   and b.rent_mng_id = c.rent_mng_id and b.rent_l_cd = c.rent_l_cd   "  + 
			"				   and c.client_id  = d.client_id ";

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
			System.out.println("[IncomDatabase:getInsideGrt]\n"+e);			
			System.out.println("[IncomDatabase:getInsideGrt]\n"+query);			
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
		
	/**
	 *	신용카드 매출 
	 */
	public Vector getCardPayList(String gubun0, String gubun2, String gubun3, String st_mon)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String d_query = "";
		String  sdt = "";
		String  edt = "";
		
		if (gubun2.equals("1") ) {
			sdt = "0101";
			edt = "0331";					
		} else if (gubun2.equals("2") ) {
			sdt = "0401";
			edt = "0630";					
		} else if (gubun2.equals("3") ) {
			sdt = "0701";
			edt = "0930";					
		} else if (gubun2.equals("4") ) {
			sdt = "1001";
			edt = "1231";					
		}
			
		
 		query = "	 select c.* \n"+ 				
					 "	from  card_jip_tax c \n"+					
					 "	where 	c.incom_dt like  '" + gubun0 + "%'  \n";
 		
 		if (!gubun2.equals("") ) {
			  query += " and c.incom_dt between '" +  gubun0 + sdt + "' and '" + gubun0 + edt + "' " ;
		}
 		
		if (!gubun3.equals("") ) {
			  query += " and c.card_cd = '" +  gubun3 +  "' " ;
		}
		
		if(st_mon.equals("1"))			query += " and to_number(substr(c.incom_dt, 5,2)) = '"+st_mon+"' \n";
		if(st_mon.equals("2"))			query += " and to_number(substr(c.incom_dt, 5,2)) = '"+st_mon+"' \n";
		if(st_mon.equals("3"))			query += " and to_number(substr(c.incom_dt, 5,2)) = '"+st_mon+"' \n";
		if(st_mon.equals("4"))			query += " and to_number(substr(c.incom_dt, 5,2)) = '"+st_mon+"' \n";
		if(st_mon.equals("5"))			query += " and to_number(substr(c.incom_dt, 5,2)) = '"+st_mon+"' \n";
		if(st_mon.equals("6"))			query += " and to_number(substr(c.incom_dt, 5,2)) = '"+st_mon+"' \n";
		if(st_mon.equals("7"))			query += " and to_number(substr(c.incom_dt, 5,2)) = '"+st_mon+"' \n";
		if(st_mon.equals("8"))			query += " and to_number(substr(c.incom_dt, 5,2)) = '"+st_mon+"' \n";
		if(st_mon.equals("9"))			query += " and to_number(substr(c.incom_dt, 5,2)) = '"+st_mon+"' \n";
		if(st_mon.equals("10"))			query += " and to_number(substr(c.incom_dt, 5,2)) = '"+st_mon+"' \n";
		if(st_mon.equals("11"))			query += " and to_number(substr(c.incom_dt, 5,2)) = '"+st_mon+"' \n";
		if(st_mon.equals("12"))			query += " and to_number(substr(c.incom_dt, 5,2)) = '"+st_mon+"' \n";
		
		query += " order by c.incom_dt,  c.card_cd ";
          				
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
			System.out.println("[IncomDatabase:getCardPayList]\n"+e);
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
	
	/*
	 *	신용카드 매출 집계표 생성  - 분기마감에서 월마감으로 변경 
	*/
	public String call_sp_car_jip_tax(String gubun0, String st_mon)
	{
    	getConnection();
    	
    	String query = "{CALL P_CARD_JIP_TAX (?,?,?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
			cstmt = conn.prepareCall(query);
			
			cstmt.setString(1, gubun0);
			cstmt.setString(2, st_mon);
			cstmt.registerOutParameter( 3, java.sql.Types.VARCHAR );
			
			cstmt.execute();
			sResult = cstmt.getString(3); // 결과값
			cstmt.close();
				
	
		} catch (SQLException e) {
			System.out.println("[IncomDatabase:call_sp_car_jip_tax]\n"+e);
			e.printStackTrace();//call_sp_car_cost
		} finally {
			try{
			     if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}	
	
	
	 /* 송금결과 조회   -    ebank.erp_trans 더이상 사용하지 않음 */
 	public Vector getIbBulkTranList(String dt, String st_dt, String end_dt, String asc, String chk)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		if ( chk.equals("c")) {
			
			query = "select a.* from ( \n " + 
				    " select a.tr_date, a.bank_nm , decode( a.acct_nb , '14989003035104' , '02822080807', a.acct_nb )   acct_nb, a.jukyo, a.br_nm, round(a.tr_amt, 0) ip_amt,  0 out_amt, 0 ss \n " + 
				    "    from EBANK.IB_ACCTALL_TR_DD a where a.jukyo ='현금' and a.tr_ipji_gbn = '2' \n " + 
				    "  union  all \n " + 
				    " select a.p_pay_dt tr_date ,'' bank_nm, '' acct_nb, b.p_cont jukyo, '' br_nm, 0 ip_amt, a.amt out_amt, 0 ss from pay a , pay_item b  \n " + 
				    " where a.p_way = '1'  and a.reg_st = 'D' and a.reqseq = b.reqseq and b.i_seq = '1' \n " + 
			     	" ) a  \n " ; 
				   
			if(dt.equals("1"))			query += " where a.tr_date like to_char(sysdate,'YYYYMM')||'%'";
			else if(dt.equals("2"))		query += " where a.tr_date like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' ";
			else if(dt.equals("4"))		query += " where a.tr_date like to_char(sysdate,'YYYY')||'%'";
			
			else if(dt.equals("3"))		query += " where a.tr_date between  to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -12), 'yyyymmdd')  and to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymmdd') ";  //직전1년
			else if(dt.equals("5")){
				if(!st_dt.equals("") && end_dt.equals(""))	query += " where a.tr_date like replace('"+st_dt+"%', '-','')";
				if(!st_dt.equals("") && !end_dt.equals("")) query += " where a.tr_date between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
			}
			
			query += "   order by  a.tr_date desc  ";
		} else {
				
			query = "select a.result_nm, a.bank_acc_nm, a.match_yn, decode(b.result_nm , null, 0, 1) ss,  count(0) cnt, sum (amt) amt from ( \n " + 
					" select	 a.bank_acc_nm ,  a.act_dt,   a.amt, \n " + 
				    "	       trim(nvl(d2.RESULT_NM, nvl(d2.remittee_nm, '-'))) result_nm, decode(d2.MATCH_YN,'Y','일치','N','불일치','X','처리전','E','오류','-') MATCH_YN  \n " + 
					"                  from  \n " + 
					"				        amazoncar.pay_act a, amazoncar.users b, \n " + 			
					"				        (select * from ebank.IB_BULK_TRAN where (upche_key,tran_dt_seq) in (select upche_key, max(tran_dt_seq) tran_dt_seq from ebank.IB_BULK_TRAN group by upche_key)) d, \n " + 
					"				        ebank.IB_REMITTEE_NM d2, 	\n " + 		
					"				        (select bank_code, bank_no, a_bank_no, min(reg_id) reg_id from amazoncar.PAY group by bank_code, bank_no, a_bank_no) e, users f \n " + 				
					"				 where \n " + 
					"				       a.reg_id=b.user_id(+) \n " + 			
					"				       and a.act_dt=d.tran_dt(+) and a.actseq=d.upche_key(+)  \n " + 
					"				       and to_char(a.reg_dt,'YYYYMMDD') >= '20091130' \n " + 
					"				       and a.bank_code=e.bank_code(+) and  a.bank_no=e.bank_no(+) and a.a_bank_no=e.a_bank_no(+) \n " + 
					"				       and e.reg_id=f.user_id(+)  \n " + 			
					"				       and a.actseq=d2.UDK01(+)	 \n " + 
					"				       and nvl(a.act_bit,'0')='1'   \n " +                  
					"                      and a.bank_acc_nm  <> '(주)아마존카' \n " ;//--집금제외		
			
			if(dt.equals("1"))			query += " and a.act_dt like to_char(sysdate,'YYYYMM')||'%'";
			else if(dt.equals("2"))		query += " and a.act_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' ";
			else if(dt.equals("4"))		query += " and a.act_dt like to_char(sysdate,'YYYY')||'%'";
			
			else if(dt.equals("3"))		query += " and a.act_dt between  to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -12), 'yyyymmdd')  and to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymmdd') ";  //직전1년
			else if(dt.equals("5")){
				if(!st_dt.equals("") && end_dt.equals(""))	query += " and a.act_dt like replace('"+st_dt+"%', '-','')";
				if(!st_dt.equals("") && !end_dt.equals("")) query += " and a.act_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
			}
			query += "       ) a, ib_result b  where a.result_nm= b.result_nm(+) and a.bank_acc_nm = b.bank_acc_nm(+) and a.match_yn = b.match_yn(+) \n " ; 	
			query += " group by  a.result_nm, a.bank_acc_nm, a.match_yn , decode(b.result_nm , null, 0, 1)   \n " ; 	
			
			if(asc.equals("1"))			query += "   order by  4, 5 desc , 6 desc ";
			if(asc.equals("2"))			query += "   order by  4, 6 desc , 5 desc  ";
			
		}
		
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
			System.out.println("[getIbBulkTranList]\n"+e);			
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
 	
 	 /* 송금결과 조회 */
 	public Vector getIbBulkTranLists(String result_nm, String bank_acc_nm, String match_yn, String dt , String st_dt , String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
						
		query = "select * from (  \n " + 
				"	 select	 trim(nvl(d2.RESULT_NM, nvl(d2.remittee_nm, '-')))  result_nm,  a.bank_acc_nm , a.act_dt, a.amt,  a.bank_nm, a.bank_no,  a.a_bank_nm, a.a_bank_no,  \n " +
				"					        decode(d2.MATCH_YN,'Y','일치','N','불일치','X','처리전','E','오류','-') MATCH_YN  ,  \n " + 
				"	                        cc.gubun_nm, cc.p_cont  \n " + 
				"	                  from  \n " + 
				"					        pay_act a, users b,  \n " + 
				"					        (select * from ebank.erp_trans where (actseq,tran_cnt) in (select actseq, max(tran_cnt) tran_cnt from ebank.erp_trans group by actseq)) c,   \n " + 
				" 					        (select * from ebank.IB_BULK_TRAN where (upche_key,tran_dt_seq) in (select upche_key, max(tran_dt_seq) tran_dt_seq from ebank.IB_BULK_TRAN group by upche_key)) d,   \n " + 
				"					        ebank.IB_REMITTEE_NM d2,   \n " + 			
				"					        (select bank_code, bank_no, a_bank_no, min(reg_id) reg_id from PAY group by bank_code,  bank_no, a_bank_no) e, users f,   \n " + 
				"					        (select * from bank_acc where off_st='tran' and seq='1') g ,  \n " + 
				"	                        ( SELECT a.bank_code, a.bank_no, a.a_bank_no,   \n " + 
				"	                                 decode(MIN(b.p_gubun),'01','자동차대금','06','중고차대금','07','사전계약계약금','08','계약금카드결제','02','영업수당','03','자동차보험료','04','할부금','05','할부금중도상환',   \n " + 
				"	                 					                    '11','정비비','14','정비비(정산)','15','피해사고공임부가세','16','피해사고부품부가세', '18','피해사고렌트부가세', '19','피해사고유리부가세',   \n " + 
				"	                 					                    '12','탁송료','13','용품비', '17','검사비',  \n " + 
				"	                 				                        '21','과태료','22','개별소비세','23','자동차세','24','환경개선부담금', '25','취득세',  \n " + 
				"	                 				                        '31','해지정산금환불','32','CMS과출금','33','계약승계보증금','34','대차승계보증금', '35','계약승계보증금환불', '36','연장계약보증금환불', '37','월렌트정산금환불',  \n " + 
				"	                 					                    '41','법인카드대금','42','법인카드대금(지방세)','43','법인카드대금(지방세)','44','법인카드대금(자동차대금)', '45','법인카드대금(지방세23일)', '46','법인카드대금(선불기타)',   \n " + 
				"	                 					                    '51','캠페인포상금','52','제안포상금','53','귀향여비','54','인터넷당직비', '55','당직비',  \n " + 
				"	                 					                    '60','자금집금','61','이체수수료','99',MIN(b.p_st2)||decode(count(0),1,'','외')) gubun_nm,  \n " + 
				"	                                 MIN(b.p_cont)||DECODE(count(0),1,'',' 외') p_cont  \n " + 
				"	                          FROM   PAY a, PAY_ITEM b  \n " + 
				"	                          WHERE  a.reqseq=b.reqseq  \n " + 
				"	                          GROUP BY a.bank_code, a.bank_no, a.a_bank_no  \n " + 
				"	                        ) cc  \n " + 
				"					 where  \n " + 
				"					       a.reg_id=b.user_id(+)  \n " + 
				"					       and a.act_dt=c.tran_dt(+) and a.actseq=c.actseq(+)  \n " + 
				"					       and a.act_dt=d.tran_dt(+) and a.actseq=d.upche_key(+)  \n " + 
				"					       and to_char(a.reg_dt,'YYYYMMDD') >= '20091130' \n " + 
				"					       and a.bank_code=e.bank_code(+) and a.bank_no=e.bank_no(+) and a.a_bank_no=e.a_bank_no(+)  \n " + 
				"					       and e.reg_id=f.user_id(+)  \n " + 
				"					       and a.bank_no=g.off_id(+) \n " + 
				"					       and a.actseq=d2.UDK01(+)	   \n " + 
				"					       and nvl(a.act_bit,'0')='1'     \n " +                
				"	                       and a.bank_acc_nm  <> '(주)아마존카'  \n " + //--집금제외
				"	                       AND a.bank_code=cc.bank_code AND  a.bank_no=cc.bank_no AND a.a_bank_no=cc.a_bank_no  \n " ;
					
	
		if(dt.equals("1"))			query += " and a.act_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(dt.equals("2"))		query += " and a.act_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' ";
		else if(dt.equals("4"))		query += " and a.act_dt like to_char(sysdate,'YYYY')||'%'";
		
		else if(dt.equals("3"))		query += " and a.act_dt between  to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -12), 'yyyymmdd')  and to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymmdd') ";  //직전1년
				
		else if(dt.equals("5")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and a.act_dt like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and a.act_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}
			
		query +=" ) where  trim(result_nm) = '"+ result_nm+ "' and trim(bank_acc_nm) = '"+bank_acc_nm+"' and trim(match_yn) = '"+ match_yn + "'" ;
		
		query +="order by 3 ";
		
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
			System.out.println("[getIbBulkTranLists]\n"+e);			
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
 	
 	public boolean insertIbResult(String result_nm ,String bank_acc_nm, String match_yn)
	{
	
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		boolean flag = true;
		int cnt = 0;
											    	
		String query = " insert into ib_result "+
						"(seq, result_nm,	bank_acc_nm , match_yn ) values "+
						"( IB_RESULT_SEQ.nextval, ?,  ?,  ?) ";
		
		String query_d = " delete from ib_result "+
			         	" where trim(result_nm) = ? and trim(bank_acc_nm) = ? and trim(match_yn) = ? ";		
						
		String query1 = " select count(0) from ib_result "+
						" where trim(result_nm) = ? and trim(bank_acc_nm) = ? and trim(match_yn) = ? ";		
		try 
		{
			conn.setAutoCommit(false);			
			
			pstmt1 = conn.prepareStatement(query1);
			pstmt1.setString(1, result_nm.trim());	
			pstmt1.setString(2, bank_acc_nm.trim());
			pstmt1.setString(3, match_yn.trim());
			
			rs = pstmt1.executeQuery();
			
			if(rs.next()){
				cnt = rs.getInt(1);
			}
			rs.close();
			pstmt1.close();
			
			if ( cnt < 1) {
				pstmt = conn.prepareStatement(query);
	  			
				pstmt.setString(1, result_nm.trim());	
				pstmt.setString(2, bank_acc_nm.trim());
				pstmt.setString(3, match_yn.trim());			
				
			    pstmt.executeUpdate();
				pstmt.close();
			} else {
				pstmt = conn.prepareStatement(query_d);
	  			
				pstmt.setString(1, result_nm.trim());	
				pstmt.setString(2, bank_acc_nm.trim());
				pstmt.setString(3, match_yn.trim());			
				
			    pstmt.executeUpdate();
				pstmt.close();
							
			}
						
			conn.commit();
			
		} catch (Exception e) {
            try{
				System.out.println("[IncomDatabase:insertIbResult]"+e);
                conn.rollback();
            }catch(SQLException _ignored){}
			e.printStackTrace();
	  		flag = false;
		} finally {
			try{
				conn.setAutoCommit(true);
              	if(pstmt != null)	pstmt.close();
             	if(pstmt1 != null)	pstmt1.close();
             	if(rs != null)	rs.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}	
 	
 	
 	//대차인 경우 면책금 원계약자 찾기 
	public Hashtable getOriRent(String rent_l_cd,  String ext_id )
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";		
						
		query = " select  s.rent_mng_id, s.rent_l_cd , dd.client_id "  + 
				"	from service s , accident a , rent_cont h, cont i , client  dd, cont b "  + 
				" where s.rent_l_cd = '"+rent_l_cd+ "' and s.serv_id ='"+ext_id+ "' "  + 
				"	and s.rent_mng_id = b.rent_mng_id and s.rent_l_cd = b.rent_l_cd "  + 
				"	and s.car_mng_id = a.car_mng_id and s.accid_id = a.accid_id "  + 
				" 	and a.rent_s_cd=h.rent_s_cd(+) and h.sub_l_cd=i.rent_l_cd(+) "  + 
				"	AND nvl(i.client_id, b.client_id)=dd.client_id" ;
				
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
			System.out.println("[IncomDatabase:getOriRent]\n"+e);			
			System.out.println("[IncomDatabase:getOriRent]\n"+query);			
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
 	
}
