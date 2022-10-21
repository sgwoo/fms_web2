package card;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.client.*;
import acar.common.*;
import acar.cont.*;
import acar.fee.*;
import acar.util.*;
import tax.*;
import acar.res_search.*;
import acar.user_mng.*;

import org.json.simple.JSONObject;
import org.json.simple.JSONArray;

public class CardDatabase
{
	private Connection conn = null;
	public static CardDatabase db;
	
	public static CardDatabase getInstance()
	{
		if(CardDatabase.db == null)
			CardDatabase.db = new CardDatabase();
		return CardDatabase.db;	
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
		}		
	}



	//법인카드관리------------------------------------------------------------------------------------------------------------------


	/**
	 *	사원검색 -- 전체선택시 채권팀제외,  에이전트제외, 외부업체제외
	 */	
	public Vector getUserSearchList(String br_id, String dept_id, String t_wd, String use_yn)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.*, b.br_nm, c.nm, nvl(d.jg_dt,a.enter_dt) jg_dt \n"+
				" from   USERS a, BRANCH b, (SELECT * FROM CODE WHERE c_st='0002') c, (SELECT user_id, max(jg_dt) jg_dt FROM INSA_POS GROUP BY user_id) d  \n"+ 
				" where  a.br_id=b.br_id AND a.dept_id=C.CODE AND a.user_id=d.user_id(+) \n"+
				"        and a.dept_id not in ('1000') and a.user_id not in ( '000102' , '000203' ) ";

		if(!br_id.equals(""))		query += " and nvl(b.br_id,'"+br_id+"') = '"+br_id+"'";

		if(!dept_id.equals(""))		query += " and a.dept_id='"+dept_id+"'";

		if(!t_wd.equals("")) {
				if (t_wd.equals("TT")) {
							query += " and a.user_id in ('000003', '000004', '000005', '000237', '000026', '000028') ";
				} else if ( t_wd.equals("AA")) {
							query += " and a.user_id not in ( '000102' , '000203' ,'000238', '000285', '000302', '000330' ) and a.id not like 'develop%' and a.dept_id <> '8888' ";	//외부개발자 3인 추가(20191007)
				} else 
				{
					        query += " and a.user_nm like '%"+t_wd+"%'";
				}			
		}
		
		if(!use_yn.equals(""))		query += " and a.use_yn='"+use_yn+"'";

		query += " order by decode(a.user_id, '000053', '6', DECODE(a.USER_POS, '대표이사', '1', '이사', '3', '부장', '4', '차장' , '5', '과장' , '6', '대리', '7', '사원', '8', '9' )) , a.dept_id,  nvl(d.jg_dt,a.enter_dt),  a.user_nm ";

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
			System.out.println("[CardDatabase:getUserSearchList]\n"+e);
			System.out.println("[CardDatabase:getUserSearchList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 *	사원검색 
	 */	
	public Vector getUserSearchList2(String br_id, String dept_id, String t_wd, String use_yn)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.*, b.br_nm, c.nm as dept_nm from users a, branch b, code c where a.br_id=b.br_id(+) and c.c_st='0002'   and a.dept_id=c.code "+
				" ";

		if(!br_id.equals(""))		query += " and nvl(b.br_id,'"+br_id+"') = '"+br_id+"'";

		if(!dept_id.equals(""))		query += " and a.dept_id='"+dept_id+"'";

		if(!t_wd.equals("")) {
				if (t_wd.equals("TT")) {
							query += " and  a.user_id in ('000003', '000004', '000005', '000237', '000026', '000028') ";
				} else 
				{
					        query += " and a.user_nm like '%"+t_wd+"%'";
				}			
		}
		
		if(!use_yn.equals(""))		query += " and a.use_yn='"+use_yn+"'";


		query += " order by a.user_nm ";


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
			System.out.println("[CardDatabase:getUserSearchList2]\n"+e);
			System.out.println("[CardDatabase:getUserSearchList2]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 *	관리자 리스트
	 */	
	public Vector getCardMngIds(String gubun, String s_br, String use_yn)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select b.user_id, nvl(b.user_nm,'미지정') user_nm from card a, users b where";

		if(!gubun.equals(""))		query += " a."+gubun+"=b.user_id(+)";

		if(!use_yn.equals(""))		query += " and a.use_yn='"+use_yn+"'";


		query += " group by b.user_id, nvl(b.user_nm,'미지정') ";
		query += " order by decode(b.user_id,'',0,1), nvl(b.user_nm,'미지정') ";

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
			System.out.println("[CardDatabase:getCardMngIds]\n"+e);
			System.out.println("[CardDatabase:getCardMngIds]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}


	/**
	 *	카드종류 리스트
	 */	
	public Vector getCardKinds(String s_br, String use_yn)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.card_kind from card a, users b where a.user_id=b.user_id(+)";

		if(!use_yn.equals(""))		query += " and a.use_yn='"+use_yn+"'";

		query += " group by a.card_kind ";


		if(s_br.equals("CODE")){

			query = " SELECT c_st, code, nm_cd, nm, nm AS card_kind FROM code WHERE c_st='0031' AND code<>'0000' order by nm ";
	
		}else if(s_br.equals("CARD")){

			query = " SELECT a.c_st, a.code, a.nm_cd, a.nm, a.nm AS card_kind "+
					" FROM   code a, (select card_kind_cd from card "+
					" ";

			if(!use_yn.equals(""))		query += " where use_yn='"+use_yn+"'";

			query +="        group by card_kind_cd) b "+
					" WHERE  a.c_st='0031' AND a.code<>'0000' and a.code=b.card_kind_cd "+
			        " order by a.nm ";

		}else if(s_br.equals("CARD_CONT")){

			query = " SELECT a.c_st, a.code, a.nm_cd, a.nm, a.nm AS card_kind "+
					" FROM   code a, (select card_kind from card_cont group by card_kind ) b "+
					" WHERE  a.c_st='0031' AND a.code<>'0000' and a.code=b.card_kind "+
			        " order by a.nm ";

		}else if(s_br.equals("CARD_SCD")){

			query = " SELECT a.c_st, a.code, a.nm_cd, a.nm, a.nm AS card_kind "+
					" FROM   code a, (select card_kind from card_stat_scd group by card_kind ) b "+
					" WHERE  a.c_st='0031' AND a.code<>'0000' and a.code=b.card_kind "+
			        " order by a.nm ";

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
			System.out.println("[CardDatabase:getCardKinds]\n"+e);
			System.out.println("[CardDatabase:getCardKinds]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 *	카드 리스트 -- 5840 페기처리 임시 조회토록 - 20090617 : 폐기된 카드로 입력하는 경우 많음
	 */	
	public Vector getCards(String s_br, String use_yn, String t_wd, String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select "+
				" a.*, b.*, d.br_nm, decode(a.card_chk, null, c.user_nm,'',c.user_nm, a.card_chk) user_nm,  nvl(b.user_id,c.user_id) user_code,"+
				" decode(a.limit_st,'1','개별','2','통합') limit_st_nm, decode(a.card_st,'1','구매자금용','2','공용','3','임/직원지급용','4','하이패스','5','세금납부용','6','포인트') card_st_nm"+
				" from card a, card_user b, users c, branch d, (select cardno, max(seq) seq from card_user group by cardno) f"+
				" where"+
				" a.cardno=b.cardno(+) and a.user_seq=b.seq(+) and b.cardno=f.cardno(+) and b.seq=f.seq(+) and b.user_id=c.user_id(+) and c.br_id=d.br_id(+)";

		if(!use_yn.equals(""))		query += " and (a.use_yn='"+use_yn+"' or a.cardno like '%5840%' or a.cardno like '%0965%') ";  

		if(!t_wd.equals("")) {
			if(user_id.equals("000223")){
				query += " and a.cardno||a.card_name||c.user_nm like '%"+t_wd+"%' and a.cardno||a.card_name||c.user_nm not like '%부산%'";
			} else if(user_id.equals("000263")) {
				query += " and a.cardno||a.card_name||c.user_nm like '%부산주유전용%'";
			} else {
				query += " and a.cardno||a.card_name||c.user_nm like '%"+t_wd+"%'";
			}
		}

		query += " order by a.cardno  ";

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
			System.out.println("[CardDatabase:getCards]\n"+e);
			System.out.println("[CardDatabase:getCards]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 *	카드 리스트
	 */	
	public Vector getPurCards(String card_st, String use_yn, String t_wd, String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		if(t_wd.equals("블루멤버스")) card_st = "6";
		if(t_wd.equals("레드멤버스")) card_st = "6";

		query = " select "+
				" a.*, b.*, d.br_nm, c.user_nm,  nvl(b.user_id,c.user_id) user_code,"+
				" decode(a.limit_st,'1','개별','2','통합') limit_st_nm, decode(a.card_st,'1','구매자금용','2','공용','3','임/직원지급용','4','하이패스','5','세금납부용','6','포인트') card_st_nm"+
				" from card a, card_user b, users c, branch d, (select cardno, max(seq) seq from card_user group by cardno) f"+
				" where"+
				" a.card_st not in ('3','4','5') AND a.use_yn='Y' and a.cardno=b.cardno(+) and a.user_seq=b.seq(+) and b.cardno=f.cardno(+) and b.seq=f.seq(+) and b.user_id=c.user_id(+) and c.br_id=d.br_id(+)";

		if(!use_yn.equals(""))		query += " and a.use_yn='"+use_yn+"'";

		if(!card_st.equals(""))		query += " and a.card_st like '%"+card_st+"%'";

		if(!t_wd.equals(""))		query += " and a.cardno||a.card_kind like '%"+t_wd+"%'";

		query += " order by a.cardno  ";

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
			System.out.println("[CardDatabase:getPurCards]\n"+e);
			System.out.println("[CardDatabase:getPurCards]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 *	장기렌트 리스트
	 */	
	public Vector getLRents(String s_br, String use_yn, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.*, b.car_no, b.car_nm  from cont_n_view  a, car_reg b ";

		if(!t_wd.equals(""))		query += " where a.car_mng_id = b.car_mng_id and b.car_no||a.firm_nm like '%"+t_wd+"%'";

		query += " order by a.use_yn desc, b.car_no";

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
			System.out.println("[CardDatabase:getLRents]\n"+e);
			System.out.println("[CardDatabase:getLRents]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 *	장기렌트 리스트
	 */	
	public Hashtable getLRent(String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select a.*, b.car_no, b.car_nm  from cont_n_view  a, car_reg b  where a.car_mng_id =  b.car_mng_id(+) and a.rent_l_cd='"+rent_l_cd+"'";

		try {
			pstmt = conn.prepareStatement(query);
		    rs = pstmt.executeQuery();
	    	ResultSetMetaData rsmd = rs.getMetaData();
    	
			if(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CardDatabase:getLRent]\n"+e);
			System.out.println("[CardDatabase:getLRent]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}		
	}

	/**
	 *	카드관리 리스트
	 */	
	public Vector getCardMngList(String s_br, String chk1, String chk2, String chk3, String chk4, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String st_dt, String end_dt, String s_kd, String t_wd1, String t_wd2, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";

		query = " select "+
				" a.*, b.*, d.br_nm, c.user_nm,"+
				" decode(a.limit_st,'1','개별','2','통합') limit_st_nm, decode(a.card_st,'1','구매자금용','2','공용','3','임/직원지급용','4','하이패스','5','세금납부용','6','포인트') card_st_nm"+
				" from card a, (select * from card_user where (cardno, seq) in (select cardno, max(seq) seq from card_user group by cardno)) b,"+
				" users c, branch d"+
				" where"+
				" a.cardno=b.cardno(+) and b.user_id=c.user_id(+) and c.br_id=d.br_id(+)";

		if(!s_br.equals(""))		query += " and c.br_id = '"+s_br+"'";

		//카드구분
		if(!gubun1.equals(""))		query += " and a.card_st = '"+gubun1+"'";
		//카드종류
		if(!gubun2.equals(""))		query += " and a.card_kind = '"+gubun2+"'";
		//부서
		if(!gubun3.equals(""))		query += " and c.dept_id = '"+gubun3+"'";
		//사용자
		if(!gubun4.equals(""))		query += " and c.user_id = '"+gubun4+"'";
		//카드관리자
		if(!gubun5.equals("0") && !gubun5.equals(""))	query += " and a.card_mng_id = '"+gubun5+"'";
		//전표승인자
		if(!gubun6.equals("0") && !gubun6.equals(""))	query += " and a.doc_mng_id = '"+gubun6+"'";
		//사용여부
		if(chk1.equals("Y"))		query += " and a.use_yn = 'Y'";
		if(chk1.equals("N"))		query += " and a.use_yn = 'N'";

		if(!t_wd1.equals(""))		query += " and a.cardno||a.card_name like '%"+t_wd1+"%'";

		query += " order by a.CARD_EDATE, a.card_kind, a.card_st, a.cardno";


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
			System.out.println("[CardDatabase:getCardMngList]\n"+e);
			System.out.println("[CardDatabase:getCardMngList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 *	카드만기예정현황 리스트
	 */	
	public Vector getCardEndList(String s_br, String chk1, String chk2, String chk3, String chk4, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String st_dt, String end_dt, String s_kd, String t_wd1, String t_wd2, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";

		query = " select "+
				" a.*, b.*, d.br_nm, c.user_nm,"+
				" decode(a.limit_st,'1','개별','2','통합') limit_st_nm, decode(a.card_st,'1','구매자금용','2','공용','3','임/직원지급용','4','하이패스','5','세금납부용','6','포인트') card_st_nm"+
				" from card a, card_user b, users c, branch d, (select cardno, max(seq) seq from card_user group by cardno) f"+
				" where a.use_yn='Y'"+
				" and a.cardno=b.cardno(+) and b.cardno=f.cardno(+) and b.seq=f.seq(+) and b.user_id=c.user_id(+) and c.br_id=d.br_id(+)";

		if(chk1.equals("1"))		query += " and a.card_edate = to_char(sysdate,'YYYYMMDD')";
		if(chk1.equals("2"))		query += " and a.card_edate like to_char(sysdate,'YYYYMM')||'%'";
		if(chk1.equals("3"))		query += " and a.card_edate between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		query += " order by a.card_edate";

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
			System.out.println("[CardDatabase:getCardEndList]\n"+e);
			System.out.println("[CardDatabase:getCardEndList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 *	카드사용자 리스트
	 */	
	public Vector getCardUserList(String s_br, String chk1, String chk2, String chk3, String chk4, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd1, String t_wd2, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";

		query = " select "+
				" a.*, b.*, d.br_nm, e.nm dept_nm, c.user_nm, decode(a.card_st,'1','구매자금용','2','공용','3','임/직원지급용','4','하이패스','5','세금납부용','6','포인트') card_st_nm"+
				" from card a, card_user b, users c, branch d, (select * from code where c_st='0002') e"+
				" where "+
				" a.cardno=b.cardno(+) and a.user_seq=b.seq(+) and b.user_id=c.user_id(+) and c.br_id=d.br_id(+) and c.dept_id=e.code(+)";

		//카드구분
		if(!gubun1.equals(""))		query += " and a.card_st = '"+gubun1+"'";
		//카드종류
		if(!gubun2.equals(""))		query += " and a.card_kind = '"+gubun2+"'";
		//영업소
		if(!s_br.equals(""))		query += " and c.br_id = '"+s_br+"'";
		//부서
		if(!gubun3.equals(""))		query += " and c.dept_id = '"+gubun3+"'";
		//사용자
		if(!gubun4.equals(""))		query += " and c.user_nm = '"+gubun4+"'";
		//지정여부
		if(chk2.equals("Y"))		query += " and b.user_id is not null";
		if(chk2.equals("N"))		query += " and b.user_id is null";

		if(!t_wd1.equals(""))		query += " and a.cardno||a.card_name like '%"+t_wd1+"%'";

		query += " order by a.card_kind, a.card_st, a.cardno";

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
			System.out.println("[CardDatabase:getCardUserList]\n"+e);
			System.out.println("[CardDatabase:getCardUserList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 *	카드별이력 리스트
	 */	
	public Vector getCardMngHList(String cardno)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";

		query = " select "+
				" a.*, b.*, d.br_nm, e.nm dept_nm, c.user_nm, decode(a.card_st,'1','구매자금용','2','공용','3','임/직원지급용','4','하이패스','5','세금납부용','6','포인트') card_st_nm"+
				" from card a, card_user b, users c, branch d, (select * from code where c_st='0002') e"+
				" where a.cardno='"+cardno+"'"+
				" and a.cardno=b.cardno and b.user_id=c.user_id and c.br_id=d.br_id and c.dept_id=e.code(+)";

		query += " order by b.use_s_dt";

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
			System.out.println("[CardDatabase:getCardMngHList]\n"+e);
			System.out.println("[CardDatabase:getCardMngHList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 *	사원별이력 리스트
	 */	
	public Vector getCardUserHList(String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";

		query = " select "+
				" a.*, b.*, d.br_nm, e.nm dept_nm, c.user_nm, decode(a.card_st,'1','구매자금용','2','공용','3','임/직원지급용','4','하이패스','5','세금납부용','6','포인트') card_st_nm"+
				" from card a, card_user b, users c, branch d, (select * from code where c_st='0002') e"+
				" where b.user_id='"+user_id+"'"+
				" and a.cardno=b.cardno and b.user_id=c.user_id and c.br_id=d.br_id and c.dept_id=e.code(+)";

		query += " order by b.use_s_dt, a.card_kind, a.cardno";


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
			System.out.println("[CardDatabase:getCardUserHList]\n"+e);
			System.out.println("[CardDatabase:getCardUserHList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 *	사원별이력 리스트
	 */	
	public Vector getCardUserHList2(String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";

		query = " select "+
				" a.*, b.*, d.br_nm, e.nm dept_nm, c.user_nm, decode(a.card_st,'1','구매자금용','2','공용','3','임/직원지급용','4','하이패스','5','세금납부용','6','포인트') card_st_nm"+
				" from card a, card_user b, users c, branch d, (select * from code where c_st='0002') e"+
				" where b.user_id='"+user_id+"' and a.card_st='3'"+
				" and a.cardno=b.cardno and b.user_id=c.user_id and c.br_id=d.br_id and c.dept_id=e.code(+)";

		query += " order by b.use_s_dt, a.card_kind, a.cardno";


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
			System.out.println("[CardDatabase:getCardUserHList]\n"+e);
			System.out.println("[CardDatabase:getCardUserHList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 *	카드종류 리스트
	 */	
	public Vector getCardMngStat(String s_br, String chk1, String chk2, String chk3, String chk4, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd1, String t_wd2, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";

		query = " select "+
				" a.*, b.user_nm, decode(a.limit_st,'1','개별','2','통합') limit_st_nm"+
				" from card a, users b"+
				" where"+
				" a.user_id=b.user_id(+)";

		if(!s_br.equals(""))				query += " and nvl(b.br_id,'"+s_br+"') like '"+s_br+"%'";

		//카드종류
		if(!gubun1.equals(""))				query += " and a.card_kind = '"+gubun1+"'";
		//사용여부
		if(chk1.equals("Y"))		query += " and a.use_yn = 'Y' and decode(length(a.card_edate), 6,a.card_edate||'31', a.card_edate) > to_char(sysdate,'YYYYMMDD')";
		if(chk1.equals("N"))		query += " and (a.use_yn = 'N' or decode(length(a.card_edate), 6,a.card_edate||'31', a.card_edate) < to_char(sysdate,'YYYYMMDD'))";

		query += " order by a.card_kind, a.cardno";

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
			System.out.println("[CardDatabase:getCardMngList]\n"+e);
			System.out.println("[CardDatabase:getCardMngList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 *	카드관리 중복 체크
	 *  
	 */	
	public boolean checkCardNo(String cardno)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		boolean flag = true;
		String query = "";
		int cnt = 0;

		query = " select count(0) from card where cardno=? ";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,	cardno);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{			
				cnt = rs.getInt(1);
			}

			if(cnt > 0) flag = false;

			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CardDatabase:checkCardNo(String cardno)]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}		
	}

	/**
	 *	카드관리 한건 조회
	 *  
	 */	
	public CardBean getCard(String cardno)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		CardBean bean = new CardBean();
		String query = "";

		query = " select * from card where cardno=? ";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,	cardno);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{			
				bean.setCardno		(rs.getString(1));
				bean.setCard_kind	(rs.getString(2));
				bean.setCard_name	(rs.getString(3));
				bean.setCom_code	(rs.getString(4));
				bean.setCard_sdate	(rs.getString(5));
				bean.setCard_edate	(rs.getString(6));
				bean.setLimit_st	(rs.getString(7));
				bean.setLimit_amt	(rs.getLong(8));
				bean.setPay_day		(rs.getString(9));
				bean.setUse_s_m		(rs.getString(10));
				bean.setUse_s_day	(rs.getString(11));
				bean.setUse_e_m		(rs.getString(12));
				bean.setUse_e_day	(rs.getString(13));
				bean.setUser_id		(rs.getString(14));
				bean.setEtc			(rs.getString(15));
				bean.setUse_yn		(rs.getString(16));
				bean.setCls_dt		(rs.getString(17));
				bean.setCls_cau		(rs.getString(18));
				bean.setCard_st		(rs.getString(19));
				bean.setReceive_dt	(rs.getString(20));
				bean.setCard_mng_id	(rs.getString(21));
				bean.setDoc_mng_id	(rs.getString(22));
				bean.setUser_seq	(rs.getString(23));
				bean.setCom_name	(rs.getString(24));
				bean.setMile_st		(rs.getString(25));
				bean.setMile_per	(rs.getString(26));
				bean.setMile_amt	(rs.getInt(27));
				bean.setCard_chk	(rs.getString(28));
				bean.setAcc_no 	    (rs.getString(29));
				bean.setCard_type   (rs.getString(30)==null?"":rs.getString(30));
				bean.setCard_paid   (rs.getString(31)==null?"":rs.getString(31));
				bean.setCard_kind_cd(rs.getString(32)==null?"":rs.getString(32));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CardDatabase:getCard(String cardno)]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}		
	}

	//카드 한건 등록
	public boolean insertCard(CardBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " INSERT INTO card ("+
				"	cardno,			"+
				"	card_st,	   	"+
				"	card_kind,  	"+
				"	card_name,  	"+
				"	com_code,   	"+
				"	card_sdate, 	"+
				"	card_edate, 	"+
				"	limit_st,		"+
				"	limit_amt,		"+
				"	pay_day,    	"+
				"	use_s_m,    	"+
				"	use_s_day,  	"+
				"	use_e_m,    	"+
				"	use_e_day,  	"+
				"	user_id,    	"+
				"	etc,        	"+
				"	use_yn,     	"+
				"	cls_dt,     	"+
				"	cls_cau,    	"+
				"	receive_dt,	   	"+
				"	card_mng_id,   	"+
				"	doc_mng_id,	   	"+
				"	user_seq,	   	"+
				"	com_name,  		"+
				"	mile_st,  		"+
				"	mile_per,  		"+
				"	mile_amt,  		"+
				"	card_type, 		"+
				"	acc_no, 		"+
				"	card_paid, 		"+
				"	card_kind_cd	"+
				" ) VALUES"+
				" ( ?, ?, ?, ?, ?, replace(?, '-', ''), replace(?, '-', ''),"+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, replace(?, '-', ''), ?,"+
				"   replace(?, '-', ''), ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

		try 
		{

			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getCardno		());
			pstmt.setString	(2,		bean.getCard_st		());
			pstmt.setString	(3,		bean.getCard_kind	());
			pstmt.setString	(4,		bean.getCard_name	());
			pstmt.setString	(5,		bean.getCom_code	());
			pstmt.setString	(6,		bean.getCard_sdate	());
			pstmt.setString	(7,		bean.getCard_edate	());
			pstmt.setString	(8,		bean.getLimit_st	());
			pstmt.setLong	(9,		bean.getLimit_amt	());
			pstmt.setString	(10,	bean.getPay_day		());
			pstmt.setString	(11,	bean.getUse_s_m		());
			pstmt.setString	(12,	bean.getUse_s_day	());
			pstmt.setString	(13,	bean.getUse_e_m		());
			pstmt.setString	(14,	bean.getUse_e_day	());
			pstmt.setString	(15,	bean.getUser_id		());
			pstmt.setString	(16,	bean.getEtc			());
			pstmt.setString	(17,	bean.getUse_yn		());
			pstmt.setString	(18,	bean.getCls_dt		());
			pstmt.setString	(19,	bean.getCls_cau		());
			pstmt.setString	(20,	bean.getReceive_dt	());
			pstmt.setString	(21,	bean.getCard_mng_id	());
			pstmt.setString	(22,	bean.getDoc_mng_id	());
			pstmt.setString	(23,	bean.getUser_seq	());
			pstmt.setString	(24,	bean.getCom_name	());
			pstmt.setString	(25,	bean.getMile_st		());
			pstmt.setString	(26,	bean.getMile_per	());
			pstmt.setInt	(27,	bean.getMile_amt	());
			pstmt.setString	(28,	bean.getCard_type	());
			pstmt.setString	(29,	bean.getAcc_no		());
			pstmt.setString	(30,	bean.getCard_paid	());
			pstmt.setString	(31,	bean.getCard_kind_cd());
			pstmt.executeUpdate();
			pstmt.close();
			
			conn.commit();
				
	  	} catch (Exception e) {
			System.out.println("[CardDatabase:insertCard(CardBean bean)]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//카드 한건 수정
	public boolean updateCard(CardBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " UPDATE card SET"+
				"   card_st		= ?,"+
				"	card_kind	= ?,"+
				"   card_name	= ?,"+
				"	com_code	= ?,"+
				"   card_sdate	= replace(?, '-', ''),"+
				"	card_edate	= replace(?, '-', ''),"+
				"   limit_st	= ?,"+
				"	limit_amt	= ?,"+
				"   pay_day		= ?,"+
				"	use_s_m		= ?,"+
				"   use_s_day	= ?,"+
				"	use_e_m		= ?,"+
				"   use_e_day	= ?,"+
				"	user_id		= ?,"+
				"   etc			= ?,"+
				"	use_yn		= ?,"+
				"   cls_dt		= replace(?, '-', ''),"+
				"	cls_cau		= ?,"+
				"   receive_dt	= replace(?, '-', ''),"+
				"	card_mng_id	= ?,"+
				"	doc_mng_id	= ?,"+
				"	user_seq	= ?,"+
				"	com_name	= ?,"+
				"	mile_st		= ?,"+
				"	mile_per	= ?,"+
				"	mile_amt	= ?,"+
				"	card_chk	= ?,"+
				"	acc_no		= ?,"+
				"	card_paid	= ?,"+
				"	card_kind_cd= ?"+
				" WHERE cardno =?";

		try 
		{

			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getCard_st		());
			pstmt.setString	(2,		bean.getCard_kind	());
			pstmt.setString	(3,		bean.getCard_name	());
			pstmt.setString	(4,		bean.getCom_code	());
			pstmt.setString	(5,		bean.getCard_sdate	());
			pstmt.setString	(6,		bean.getCard_edate	());
			pstmt.setString	(7,		bean.getLimit_st	());
			pstmt.setLong	(8,		bean.getLimit_amt	());
			pstmt.setString	(9,		bean.getPay_day		());
			pstmt.setString	(10,	bean.getUse_s_m		());
			pstmt.setString	(11,	bean.getUse_s_day	());
			pstmt.setString	(12,	bean.getUse_e_m		());
			pstmt.setString	(13,	bean.getUse_e_day	());
			pstmt.setString	(14,	bean.getUser_id		());
			pstmt.setString	(15,	bean.getEtc			());
			pstmt.setString	(16,	bean.getUse_yn		());
			pstmt.setString	(17,	bean.getCls_dt		());
			pstmt.setString	(18,	bean.getCls_cau		());
			pstmt.setString	(19,	bean.getReceive_dt	());
			pstmt.setString	(20,	bean.getCard_mng_id	());
			pstmt.setString	(21,	bean.getDoc_mng_id	());
			pstmt.setString	(22,	bean.getUser_seq	());
			pstmt.setString	(23,	bean.getCom_name	());
			pstmt.setString	(24,	bean.getMile_st		());
			pstmt.setString	(25,	bean.getMile_per	());
			pstmt.setInt	(26,	bean.getMile_amt	());
			pstmt.setString	(27,	bean.getCard_chk	());
			pstmt.setString	(28,	bean.getAcc_no		());
			pstmt.setString	(29,	bean.getCard_paid	());
			pstmt.setString	(30,	bean.getCard_kind_cd());
			pstmt.setString	(31,	bean.getCardno		());
			pstmt.executeUpdate();
			pstmt.close();
			
			conn.commit();
				
	  	} catch (Exception e) {
			System.out.println("[CardDatabase:updateCard]\n"+e);

			System.out.println("[bean.getCard_st		()]\n"+bean.getCard_st		());
			System.out.println("[bean.getCard_kind		()]\n"+bean.getCard_kind	());
			System.out.println("[bean.getCard_name		()]\n"+bean.getCard_name	());
			System.out.println("[bean.getCom_code		()]\n"+bean.getCom_code		());
			System.out.println("[bean.getCard_sdate		()]\n"+bean.getCard_sdate	());
			System.out.println("[bean.getCard_edate		()]\n"+bean.getCard_edate	());
			System.out.println("[bean.getLimit_st		()]\n"+bean.getLimit_st		());
			System.out.println("[bean.getLimit_amt		()]\n"+bean.getLimit_amt	());
			System.out.println("[bean.getPay_day		()]\n"+bean.getPay_day		());
			System.out.println("[bean.getUse_s_m		()]\n"+bean.getUse_s_m		());
			System.out.println("[bean.getUse_s_day		()]\n"+bean.getUse_s_day	());
			System.out.println("[bean.getUse_e_m		()]\n"+bean.getUse_e_m		());
			System.out.println("[bean.getUse_e_day		()]\n"+bean.getUse_e_day	());
			System.out.println("[bean.getUser_id		()]\n"+bean.getUser_id		());
			System.out.println("[bean.getEtc			()]\n"+bean.getEtc			());
			System.out.println("[bean.getUse_yn			()]\n"+bean.getUse_yn		());
			System.out.println("[bean.getCls_dt			()]\n"+bean.getCls_dt		());
			System.out.println("[bean.getCls_cau		()]\n"+bean.getCls_cau		());
			System.out.println("[bean.getReceive_dt		()]\n"+bean.getReceive_dt	());
			System.out.println("[bean.getCard_mng_id	()]\n"+bean.getCard_mng_id	());
			System.out.println("[bean.getDoc_mng_id		()]\n"+bean.getDoc_mng_id	());
			System.out.println("[bean.getUser_seq		()]\n"+bean.getUser_seq		());
			System.out.println("[bean.getCom_name		()]\n"+bean.getCom_name		());
			System.out.println("[bean.getMile_st		()]\n"+bean.getMile_st		());
			System.out.println("[bean.getMile_per		()]\n"+bean.getMile_per		());
			System.out.println("[bean.getMile_amt		()]\n"+bean.getMile_amt		());
			System.out.println("[bean.getCard_chk		()]\n"+bean.getCard_chk		());
			System.out.println("[bean.getAcc_no			()]\n"+bean.getAcc_no		());
			System.out.println("[bean.getCardno			()]\n"+bean.getCardno		());

			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	/**
	 *	카드사용자관리 한건 조회
	 */	
	public CardUserBean getCardUser(String cardno, String seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		CardUserBean bean = new CardUserBean();
		String query = "";

		query = " select * from card_user where cardno=? and seq=? ";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,	cardno);
			pstmt.setString	(2,	seq);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{			
				bean.setCardno		(rs.getString(1));
				bean.setSeq			(rs.getString(2));
				bean.setUser_id		(rs.getString(3));
				bean.setUse_s_dt	(rs.getString(4));
				bean.setUse_e_dt	(rs.getString(5));
				bean.setReg_id		(rs.getString(6));
				bean.setBack_id		(rs.getString(7));
				bean.setR_use_s_dt	(rs.getString(8));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CardDatabase:getCardUser(String cardno, String seq)]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}		
	}

	//카드사용자 카드별 일련번호 조회
	public String getCardUserSeqNext(String cardno)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String seq = "";
		String query = "";

		query = " select nvl(ltrim(to_char(to_number(max(seq)+1), '00')), '01') seq"+
				" from card_user "+
				" where cardno=?";

		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString	(1,	cardno);
		    	rs = pstmt.executeQuery();
   	
			if(rs.next())
			{				
				seq = rs.getString(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CardDatabase:getCardUserSeqNext]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return seq;
		}		
	}

	//카드사용자 한건 등록
	public boolean insertCardUser(CardUserBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " INSERT INTO card_user ("+
				"	cardno,		"+
				"	seq,	   	"+
				"	user_id,  	"+
				"	use_s_dt,  	"+
				"	use_e_dt,   "+
				"	reg_id, 	"+
				"	back_id, 	"+
				"	r_use_s_dt  "+
				" ) VALUES"+
				" ( ?, ?, ?, replace(?, '-', ''), replace(?, '-', ''), ?, ?, replace(?, '-', ''))";

		try 
		{
			conn.setAutoCommit(false);	

			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getCardno		());
			pstmt.setString	(2,		bean.getSeq			());
			pstmt.setString	(3,		bean.getUser_id		());
			pstmt.setString	(4,		bean.getUse_s_dt	());
			pstmt.setString	(5,		bean.getUse_e_dt	());
			pstmt.setString	(6,		bean.getReg_id		());
			pstmt.setString	(7,		bean.getBack_id		());
			pstmt.setString	(8,		bean.getR_use_s_dt	());
			pstmt.executeUpdate();
			pstmt.close();
						
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[CardDatabase:insertCardUser(CardUserBean bean)]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//카드 한건 수정
	public boolean updateCardUser(CardUserBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " UPDATE card_user SET"+
				"   user_id		= ?,"+
				"	use_s_dt	= replace(?, '-', ''),"+
				"   use_e_dt	= replace(?, '-', ''),"+
				"	reg_id		= ?,"+
				"   back_id		= ?,"+
				"	r_use_s_dt	= replace(?, '-', '')"+
				" WHERE cardno = ? and seq = ?";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getUser_id		());
			pstmt.setString	(2,		bean.getUse_s_dt	());
			pstmt.setString	(3,		bean.getUse_e_dt	());
			pstmt.setString	(4,		bean.getReg_id		());
			pstmt.setString	(5,		bean.getBack_id		());
			pstmt.setString	(6,		bean.getR_use_s_dt	());
			pstmt.setString	(7,		bean.getCardno		());
			pstmt.setString	(8,		bean.getSeq			());
			pstmt.executeUpdate();
			pstmt.close();
			
			conn.commit();
				
	  	} catch (Exception e) {
			System.out.println("[CardDatabase:updateCardUser]\n"+e);

			System.out.println("[bean.getUser_id	()]\n"+bean.getUser_id	());
			System.out.println("[bean.getUse_s_dt	()]\n"+bean.getUse_s_dt	());
			System.out.println("[bean.getUse_e_dt	()]\n"+bean.getUse_e_dt	());
			System.out.println("[bean.getReg_id		()]\n"+bean.getReg_id	());
			System.out.println("[bean.getBack_id	()]\n"+bean.getBack_id	());
			System.out.println("[bean.getCardno		()]\n"+bean.getCardno	());
			System.out.println("[bean.getSeq		()]\n"+bean.getSeq		());

			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}


	//법인카드전표관리------------------------------------------------------------------------------------------------------------------


	//카드별 전표 일련번호 조회
	public String getCardDocBuyIdNext(String cardno)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String buy_id = "";
		String query = "";

		query = " select nvl(ltrim(to_char(to_number(max(buy_id)+1), '000000')), '000001') buy_id"+
				" from card_doc "+
				" where cardno=?";

		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString	(1,	cardno);
		    	rs = pstmt.executeQuery();
   	
			if(rs.next())
			{				
				buy_id = rs.getString(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CardDatabase:getCardDocBuyIdNext]\n"+e);
			System.out.println("[CardDatabase:getCardDocBuyIdNext]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return buy_id;
		}		
	}

	/**
	 *	전표 한건 조회
	 *  
	 */	
	public CardDocBean getCardDoc(String cardno, String buy_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		CardDocBean bean = new CardDocBean();
		String query = "";

		query = " select * from card_doc where cardno=? and buy_id = ? ";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,	cardno);
			pstmt.setString	(2,	buy_id);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{			
				bean.setCardno				(rs.getString(1));
				bean.setBuy_id				(rs.getString(2));
				bean.setBuy_dt				(rs.getString(3));
				bean.setBuy_s_amt			(rs.getInt(4));
				bean.setBuy_v_amt			(rs.getInt(5));
				bean.setBuy_amt				(rs.getInt(6));
				bean.setVen_code			(rs.getString(7));
				bean.setVen_name			(rs.getString(8));
				bean.setAcct_code			(rs.getString(9));
				bean.setAcct_code_g			(rs.getString(10));
				bean.setAcct_code_g2		(rs.getString(11));
				bean.setItem_code			(rs.getString(12));
				bean.setItem_name			(rs.getString(13));
				bean.setAcct_cont			(rs.getString(14));
				bean.setUser_su				(rs.getString(15));
				bean.setUser_cont			(rs.getString(16));
				bean.setReg_id				(rs.getString(17));
				bean.setReg_dt				(rs.getString(18));
				bean.setApp_id				(rs.getString(19));
				bean.setApp_dt				(rs.getString(20));
				bean.setApp_code			(rs.getString(21));
				bean.setAutodocu_write_date	(rs.getString(22));
				bean.setAutodocu_data_no	(rs.getString(23));
				bean.setBuy_user_id			(rs.getString(24));
				bean.setRent_l_cd			(rs.getString(25));
				bean.setChief_id			(rs.getString(26));
				bean.setTax_yn				(rs.getString(27));
				bean.setVen_st				(rs.getString(28));
				bean.setO_cau				(rs.getString(31));
				bean.setCall_t_nm			(rs.getString(32));
				bean.setCall_t_tel			(rs.getString(33));
				bean.setCall_t_chk			(rs.getString(34));
				bean.setServ_id				(rs.getString(35));
				bean.setCard_file			(rs.getString("card_file")		==null?"":rs.getString("card_file"));
				bean.setM_doc_code			(rs.getString("m_doc_code")		==null?"":rs.getString("m_doc_code"));
				bean.setFile_path			(rs.getString("file_path")		==null?"":rs.getString("file_path"));
				bean.setOil_liter			(rs.getFloat("oil_liter"));
				bean.setTot_dist			(rs.getInt("tot_dist"));
				bean.setSiokno				(rs.getString("siokno")		==null?"":rs.getString("siokno"));
				bean.setR_buy_dt			(rs.getString("r_buy_dt")	==null?"":rs.getString("r_buy_dt"));
						
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CardDatabase:getCardDoc(String cardno)]\n"+e);
	  		e.printStackTrace();

		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}		
	}


	//전표 한건 등록  >> fms3 에서 복사
	public boolean insertCardDoc(CardDocBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";

		query = " INSERT INTO card_doc ("+
				"	cardno,				"+
				"	buy_id,				"+
				"	buy_dt,				"+
				"	buy_s_amt,			"+
				"	buy_v_amt,			"+
				"	buy_amt,			"+
				"	ven_code,			"+
				"	ven_name,			"+
				"	acct_code,			"+
				"	acct_code_g,		"+
				"	acct_code_g2,		"+
				"	item_code,			"+
				"	item_name,			"+
				"	acct_cont,			"+
				"	user_su,			"+
				"	user_cont,			"+
				"	reg_id,				"+
				"	reg_dt,				"+
				"	app_id,				"+
				"	app_dt,				"+
				"	app_code,			"+
				"	autodocu_write_date,"+
				"	autodocu_data_no,	"+
				"	buy_user_id,		"+
				"	rent_l_cd,			"+
				"	tax_yn,				"+
				"	ven_st,				"+
				"	o_cau,				"+
				"	call_t_nm,			"+
				"	call_t_tel,			"+
				"	call_t_chk,			"+		
				"	serv_id,			"+				
				"	card_file,			"+			
				"	file_path,			"+				
				"	oil_liter,			"+			
				"	tot_dist,			"+
				"	siokno,				"+
				"	cons_no				"+
				" ) VALUES"+
				" ( ?, ?, replace(?, '-', ''), ?, ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, ?, ?, ?, ?, ?, to_char(sysdate,'YYYYMMDD'), ?, ?,"+
				"   ?, replace(?, '-', ''), ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?  "+
				" )";

		try 
		{

			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getCardno				());
			pstmt.setString	(2,		bean.getBuy_id				());
			pstmt.setString	(3,		bean.getBuy_dt				());
			pstmt.setInt	(4,		bean.getBuy_s_amt			());
			pstmt.setInt	(5,		bean.getBuy_v_amt			());
			pstmt.setInt	(6,		bean.getBuy_amt				());
			pstmt.setString	(7,		bean.getVen_code			());
			pstmt.setString	(8,		bean.getVen_name			());
			pstmt.setString	(9,		bean.getAcct_code			());
			pstmt.setString	(10,	bean.getAcct_code_g			());
			pstmt.setString	(11,	bean.getAcct_code_g2		());
			pstmt.setString	(12,	bean.getItem_code			());
			pstmt.setString	(13,	bean.getItem_name			());
			pstmt.setString	(14,	bean.getAcct_cont			());
			pstmt.setString	(15,	bean.getUser_su				());
			pstmt.setString	(16,	bean.getUser_cont			());
			pstmt.setString	(17,	bean.getReg_id				());
			pstmt.setString	(18,	bean.getApp_id				());
			pstmt.setString	(19,	bean.getApp_dt				());
			pstmt.setString	(20,	bean.getApp_code			());
			pstmt.setString	(21,	bean.getAutodocu_write_date	());
			pstmt.setString	(22,	bean.getAutodocu_data_no	());
			pstmt.setString	(23,	bean.getBuy_user_id			());
			pstmt.setString	(24,	bean.getRent_l_cd			());
			pstmt.setString	(25,	bean.getTax_yn				());
			pstmt.setString	(26,	bean.getVen_st				());
			pstmt.setString	(27,	bean.getO_cau				());
			pstmt.setString	(28,	bean.getCall_t_nm			());
			pstmt.setString	(29,	bean.getCall_t_tel			());
			pstmt.setString	(30,	bean.getCall_t_chk			());
			pstmt.setString	(31,	bean.getServ_id				());
			pstmt.setString	(32,	bean.getCard_file			());
			pstmt.setString	(33,	bean.getFile_path			());
			pstmt.setFloat  (34,    bean.getOil_liter           ());
			pstmt.setFloat  (35,    bean.getTot_dist           ());
			pstmt.setString	(36,	bean.getSiokno				());
			pstmt.setString	(37,	bean.getCons_no				());
			pstmt.executeUpdate();
			pstmt.close();
			
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[CardDatabase:insertCardDoc(CardDocBean bean)]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
	  	} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}


	//전표 한건 수정
	public boolean updateCardDoc(CardDocBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " UPDATE card_doc SET \n"+
				"   buy_dt				= replace(?, '-', ''), \n"+
				"	buy_s_amt			= ?, \n"+
				"   buy_v_amt			= ?, \n"+
				"	buy_amt				= ?, \n"+
				"   ven_code			= ?, \n"+
				"	ven_name			= ?, \n"+
				"   acct_code			= ?, \n"+
				"	acct_code_g			= ?, \n"+
				"   acct_code_g2		= ?, \n"+
				"	item_code			= ?, \n"+
				"   item_name			= ?, \n"+
				"	acct_cont			= ?, \n"+
				"   user_su				= ?, \n"+
				"	user_cont			= ?, \n"+
				"   reg_id				= ?, \n"+
				"	reg_dt				= replace(?, '-', ''), \n"+
				"   app_id				= ?, \n"+
				"	app_dt				= replace(?, '-', ''), \n"+
				"   app_code			= ?,"+
				"	autodocu_write_date	= replace(?, '-', ''), \n"+
				"	autodocu_data_no	= ?, \n"+
				"   buy_user_id			= ?, \n"+
				"	rent_l_cd			= ?, \n"+
				"	chief_id			= ?, \n"+
				"	tax_yn				= ?, \n"+
				"	ven_st				= ?, \n"+
				"	o_cau				= ?, \n"+
				"	call_t_nm			= ?, \n"+
				"	call_t_tel			= ?, \n"+
				"	call_t_chk			= ?, \n"+
				"	serv_id				= ?, \n"+
				"	oil_liter			= ?, \n"+
				"   r_buy_dt			= replace(?, '-', '') "+
				" WHERE cardno =? and buy_id = ?";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getBuy_dt				());
			pstmt.setInt	(2,		bean.getBuy_s_amt			());
			pstmt.setInt	(3,		bean.getBuy_v_amt			());
			pstmt.setInt	(4,		bean.getBuy_amt				());
			pstmt.setString	(5,		bean.getVen_code			());
			pstmt.setString	(6,		bean.getVen_name			());
			pstmt.setString	(7,		bean.getAcct_code			());
			pstmt.setString	(8,		bean.getAcct_code_g			());
			pstmt.setString	(9,		bean.getAcct_code_g2		());
			pstmt.setString	(10,	bean.getItem_code			());
			pstmt.setString	(11,	bean.getItem_name			());
			pstmt.setString	(12,	bean.getAcct_cont			());
			pstmt.setString	(13,	bean.getUser_su				());
			pstmt.setString	(14,	bean.getUser_cont			());
			pstmt.setString	(15,	bean.getReg_id				());
			pstmt.setString	(16,	bean.getReg_dt				());
			pstmt.setString	(17,	bean.getApp_id				());
			pstmt.setString	(18,	bean.getApp_dt				());
			pstmt.setString	(19,	bean.getApp_code			());
			pstmt.setString	(20,	bean.getAutodocu_write_date	());
			pstmt.setString	(21,	bean.getAutodocu_data_no	());
			pstmt.setString	(22,	bean.getBuy_user_id			());
			pstmt.setString	(23,	bean.getRent_l_cd			());
			pstmt.setString	(24,	bean.getChief_id			());
			pstmt.setString	(25,	bean.getTax_yn				());
			pstmt.setString	(26,	bean.getVen_st				());
			pstmt.setString	(27,	bean.getO_cau				());
			pstmt.setString	(28,	bean.getCall_t_nm			());
			pstmt.setString	(29,	bean.getCall_t_tel			());
			pstmt.setString	(30,	bean.getCall_t_chk			());
			pstmt.setString	(31,	bean.getServ_id				());
			pstmt.setFloat	(32,	bean.getOil_liter			());
			pstmt.setString	(33,	bean.getR_buy_dt			());
			pstmt.setString	(34,	bean.getCardno				());
			pstmt.setString	(35,	bean.getBuy_id				());
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
			
	  	} catch (Exception e) {

			System.out.println("[CardDatabase:updateCardDoc]\n"+e);
			System.out.println("[bean.getBuy_dt				()]\n"+bean.getBuy_dt				());
			System.out.println("[bean.getBuy_s_amt			()]\n"+bean.getBuy_s_amt			());
			System.out.println("[bean.getBuy_v_amt			()]\n"+bean.getBuy_v_amt			());
			System.out.println("[bean.getBuy_amt			()]\n"+bean.getBuy_amt				());
			System.out.println("[bean.getVen_code			()]\n"+bean.getVen_code			());
			System.out.println("[bean.getVen_name			()]\n"+bean.getVen_name			());
			System.out.println("[bean.getAcct_code			()]\n"+bean.getAcct_code			());
			System.out.println("[bean.getAcct_code_g		()]\n"+bean.getAcct_code_g			());
			System.out.println("[bean.getAcct_code_g2		()]\n"+bean.getAcct_code_g2		());
			System.out.println("[bean.getItem_code			()]\n"+bean.getItem_code			());
			System.out.println("[bean.getItem_name			()]\n"+bean.getItem_name			());
			System.out.println("[bean.getAcct_cont			()]\n"+bean.getAcct_cont			());
			System.out.println("[bean.getUser_su			()]\n"+bean.getUser_su				());
			System.out.println("[bean.getUser_cont			()]\n"+bean.getUser_cont			());
			System.out.println("[bean.getReg_id				()]\n"+bean.getReg_id				());
			System.out.println("[bean.getReg_dt				()]\n"+bean.getReg_dt				());
			System.out.println("[bean.getApp_id				()]\n"+bean.getApp_id				());
			System.out.println("[bean.getApp_dt				()]\n"+bean.getApp_dt				());
			System.out.println("[bean.getApp_code			()]\n"+bean.getApp_code			());
			System.out.println("[bean.getAutodocu_write_date()]\n"+bean.getAutodocu_write_date	());
			System.out.println("[bean.getAutodocu_data_no	()]\n"+bean.getAutodocu_data_no	());
			System.out.println("[bean.getBuy_user_id		()]\n"+bean.getBuy_user_id			());
			System.out.println("[bean.getRent_l_cd			()]\n"+bean.getRent_l_cd			());
			System.out.println("[bean.getChief_id			()]\n"+bean.getChief_id			());
			System.out.println("[bean.getCardno				()]\n"+bean.getCardno				());
			System.out.println("[bean.getBuy_id				()]\n"+bean.getBuy_id				()); 

			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	/*전표 한건 수정
	 * author : 성승현
	 * date : 20161215
	 * from : updateCardDoc(CardDocBean bean)
	 */
	
		public boolean updateCardDocScard(CardDocBean bean)
		{
			getConnection();

			boolean flag = true;
			PreparedStatement pstmt = null;
			String query = "";
				
			query = " UPDATE card_doc SET"+
					"   buy_dt				= replace(?, '-', ''),"+
					"	buy_s_amt			= ?,"+
					"   buy_v_amt			= ?,"+
					"	buy_amt				= ?,"+
					"   ven_code			= ?,"+
					"	ven_name			= ?,"+
					"   acct_code			= ?,"+
					"	acct_code_g			= ?,"+
					"   acct_code_g2		= ?,"+
					"	item_code			= ?,"+
					"   item_name			= ?,"+
					"	acct_cont			= REPLACE(REPLACE(?, CHR(13), ''), CHR(10),''),"+
					"   user_su				= ?,"+
					"	user_cont			= ?,"+
					"   reg_id				= ?,"+
					"	reg_dt				= replace(?, '-', ''),"+
					"   app_id				= ?,"+
					"	app_dt				= replace(?, '-', ''),"+
					"   app_code			= ?,"+
					"	autodocu_write_date	= replace(?, '-', ''),"+
					"	autodocu_data_no	= ?,"+
					"   buy_user_id			= ?,"+
					"	rent_l_cd			= ?,"+
					"	chief_id			= ?,"+
					"	tax_yn				= ?,"+
					"	ven_st				= ?,"+
					"	o_cau				= ?,"+
					"	call_t_nm			= ?,"+
					"	call_t_tel			= ?,"+
					"	call_t_chk			= ?,"+
					"	serv_id				= ?,"+
					"	oil_liter			= ?, "+
					"	tot_dist			= ?, "+
					"	cons_no			= ? "+
					" WHERE cardno =? and buy_id = ?";

			try 
			{
				conn.setAutoCommit(false);
				
				pstmt = conn.prepareStatement(query);
				pstmt.setString	(1,		bean.getBuy_dt				());
				pstmt.setInt	(2,		bean.getBuy_s_amt			());
				pstmt.setInt	(3,		bean.getBuy_v_amt			());
				pstmt.setInt	(4,		bean.getBuy_amt				());
				pstmt.setString	(5,		bean.getVen_code			());
				pstmt.setString	(6,		bean.getVen_name			());
				pstmt.setString	(7,		bean.getAcct_code			());
				pstmt.setString	(8,		bean.getAcct_code_g			());
				pstmt.setString	(9,		bean.getAcct_code_g2		());
				pstmt.setString	(10,	bean.getItem_code			());
				pstmt.setString	(11,	bean.getItem_name			());
				pstmt.setString	(12,	bean.getAcct_cont			());
				pstmt.setString	(13,	bean.getUser_su				());
				pstmt.setString	(14,	bean.getUser_cont			());
				pstmt.setString	(15,	bean.getReg_id				());
				pstmt.setString	(16,	bean.getReg_dt				());
				pstmt.setString	(17,	bean.getApp_id				());
				pstmt.setString	(18,	bean.getApp_dt				());
				pstmt.setString	(19,	bean.getApp_code			());
				pstmt.setString	(20,	bean.getAutodocu_write_date	());
				pstmt.setString	(21,	bean.getAutodocu_data_no	());
				pstmt.setString	(22,	bean.getBuy_user_id			());
				pstmt.setString	(23,	bean.getRent_l_cd			());
				pstmt.setString	(24,	bean.getChief_id			());
				pstmt.setString	(25,	bean.getTax_yn				());
				pstmt.setString	(26,	bean.getVen_st				());
				pstmt.setString	(27,	bean.getO_cau				());
				pstmt.setString	(28,	bean.getCall_t_nm			());
				pstmt.setString	(29,	bean.getCall_t_tel			());
				pstmt.setString	(30,	bean.getCall_t_chk			());
				pstmt.setString	(31,	bean.getServ_id				());
				pstmt.setFloat	(32,	bean.getOil_liter			());
				pstmt.setFloat	(33,	bean.getTot_dist			());
				pstmt.setString	(34,	bean.getCons_no				());
				pstmt.setString	(35,	bean.getCardno				());
				pstmt.setString	(36,	bean.getBuy_id				());
				pstmt.executeUpdate();
				pstmt.close();
				
				conn.commit();
				
		  	} catch (Exception e) {

				System.out.println("[CardDatabase:updateCardDoc]\n"+e);
				System.out.println("[bean.getBuy_dt				()]\n"+bean.getBuy_dt				());
				System.out.println("[bean.getBuy_s_amt			()]\n"+bean.getBuy_s_amt			());
				System.out.println("[bean.getBuy_v_amt			()]\n"+bean.getBuy_v_amt			());
				System.out.println("[bean.getBuy_amt			()]\n"+bean.getBuy_amt				());
				System.out.println("[bean.getVen_code			()]\n"+bean.getVen_code			());
				System.out.println("[bean.getVen_name			()]\n"+bean.getVen_name			());
				System.out.println("[bean.getAcct_code			()]\n"+bean.getAcct_code			());
				System.out.println("[bean.getAcct_code_g		()]\n"+bean.getAcct_code_g			());
				System.out.println("[bean.getAcct_code_g2		()]\n"+bean.getAcct_code_g2		());
				System.out.println("[bean.getItem_code			()]\n"+bean.getItem_code			());
				System.out.println("[bean.getItem_name			()]\n"+bean.getItem_name			());
				System.out.println("[bean.getAcct_cont			()]\n"+bean.getAcct_cont			());
				System.out.println("[bean.getUser_su			()]\n"+bean.getUser_su				());
				System.out.println("[bean.getUser_cont			()]\n"+bean.getUser_cont			());
				System.out.println("[bean.getReg_id				()]\n"+bean.getReg_id				());
				System.out.println("[bean.getReg_dt				()]\n"+bean.getReg_dt				());
				System.out.println("[bean.getApp_id				()]\n"+bean.getApp_id				());
				System.out.println("[bean.getApp_dt				()]\n"+bean.getApp_dt				());
				System.out.println("[bean.getApp_code			()]\n"+bean.getApp_code			());
				System.out.println("[bean.getAutodocu_write_date()]\n"+bean.getAutodocu_write_date	());
				System.out.println("[bean.getAutodocu_data_no	()]\n"+bean.getAutodocu_data_no	());
				System.out.println("[bean.getBuy_user_id		()]\n"+bean.getBuy_user_id			());
				System.out.println("[bean.getRent_l_cd			()]\n"+bean.getRent_l_cd			());
				System.out.println("[bean.getChief_id			()]\n"+bean.getChief_id			());
				System.out.println("[bean.getCardno				()]\n"+bean.getCardno				());
				System.out.println("[bean.getBuy_id				()]\n"+bean.getBuy_id				()); 

				e.printStackTrace();
		  		flag = false;
		  		conn.rollback();
			} finally {
				try{
					conn.setAutoCommit(true);
					if ( pstmt != null )	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return flag;
			}
		}

	//전표 한건 삭제
	public boolean deleteCardDoc(CardDocBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
	
		String query = "";
			
		query = " DELETE FROM card_doc "+
				" WHERE cardno =? and buy_id = ?";

		String query2 = "";
			
		query2 = " DELETE FROM card_doc_user "+
				" WHERE cardno =? and buy_id = ?";
				
	
		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,	bean.getCardno());
			pstmt.setString	(2,	bean.getBuy_id());
			pstmt.executeUpdate();
			pstmt.close();

			pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString (1,	bean.getCardno());
			pstmt2.setString (2,	bean.getBuy_id());
			pstmt2.executeUpdate();
			pstmt2.close();

			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[CardDatabase:deleteCardDoc]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
				if ( pstmt2 != null )	pstmt2.close();
			
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}


	//전표 한건 승인
	public boolean approvalCardDoc(CardDocBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " UPDATE card_doc SET"+
				"   app_id				= ?,"+
				"	app_dt				= to_char(sysdate,'YYYYMMDD'),"+
				"   app_code			= ?"+
				" WHERE cardno =? and buy_id = ?";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,	bean.getApp_id				());
			pstmt.setString	(2,	bean.getApp_code			());
			pstmt.setString	(3,	bean.getCardno				());
			pstmt.setString	(4,	bean.getBuy_id				());
			pstmt.executeUpdate();
			pstmt.close();
			
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[CardDatabase:approvalCardDoc]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
	  		
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//단기계약 한건 조회
	public Hashtable getRentContCase(String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		query = " select a.rent_l_cd, c.user_nm, b.first_car_no, b.car_no, b.car_nm, a.rent_start_dt as deli_dt, a.rent_end_dt as ret_dt, a.car_mng_id, '' rent_s_cd, s.serv_dt, s.tot_dist "+
				" from   cont a, car_reg b, users c, client d, "+
				" (SELECT car_mng_id, MAX(serv_dt) AS serv_dt,  MAX(tot_dist) AS tot_dist FROM SERVICE  GROUP BY car_mng_id) s "+
				" where  a.car_st='5' and a.use_yn='Y' and a.car_mng_id=b.car_mng_id and c.user_id='"+user_id+"' and a.car_mng_id = s.car_mng_id(+) and a.client_id=d.client_id and c.user_nm=d.firm_nm ";

		try {

			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();
		
		} catch (SQLException e) {
			System.out.println("[ResSearchDatabase:getRentContCase]\n"+e);
			System.out.println("[ResSearchDatabase:getRentContCase]\n"+query);
			e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}		
	}	

	/**
	 *	전표승인 대기 리스트
	 */	
	public Vector getCardAppList(String s_br, String chk1, String chk2, String chk3, String chk4, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String st_dt, String end_dt, String s_kd, String t_wd1, String t_wd2, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";

		String acct_code_g_nm	= "decode(a.acct_code_g,'','-','1','식대','2','복지비','3','기타','30','포상휴가','13','가솔린','4','디젤','5','LPG','27','전기차충전','6','일반정비','7','자동차검사','8','정밀검사','9','출장비','10','기타교통비','11','식대','12','경조사','14','기타','18','번호판대금','19','차량등록세','20','하이패스','21', '재리스정비', '---')";
		String acct_code_g2_nm	= "decode(a.acct_code_g2,'1','-조식','2','-중식','3','-특근식','4','-회사전체모임','5','-부서별정기모임','6','-부서별부정기회식','7','-커피','8','-음료','9','-약품','10','-그외','11','-업무차량','12','-예비차량','13','-고객차량','---')";
		String acct_cont_nm		= "decode(a.item_name, '', decode(a.acct_cont, '', a.user_cont||' '||a.user_su||'명', a.acct_cont), a.item_name)";

		query = " select"+
				" a.*, decode(a.buy_v_amt,0,'비과세','과세') buy_st,"+
				" decode(a.acct_code, '00001','복리후생비', '00002','접대비', '00003','여비교통비', '00004','차량유류대', '00005','차량정비비', '00006','사고수리비', '00007','사무용품비', '00008','소모품비', '00009','통신비', '00010','도서인쇄비', '00011','지급수수료', '00012','비품', '00013','선급금', '00014','교육훈련비', '00015','세금과공과', '00016','대여사업차량', '00017','리스사업차량', '00018','운반비', '00019','주차요금', '00020', '보험료', '00021', '업무비선급금', '00023', '광고선전비') acct_code_nm,"+
				" "+acct_code_g_nm+" acct_code_g_nm,"+
				" "+acct_code_g2_nm+" acct_code_g2_nm,"+
				" "+acct_cont_nm+" acct_cont_nm,"+
				" c.user_nm,"+
				" b.card_mng_id, b.doc_mng_id"+
				" from card_doc a, card b, users c, neoe.MA_PARTNER d  "+ 
				" where a.autodocu_write_date is null and a.cardno<>'0000-0000-0000-0000' AND NVL(a.app_id,'-') NOT IN ('cancel','cance0')"+
				"	    and a.cardno=b.cardno "+
				"       and nvl(a.buy_user_id,a.reg_id)=c.user_id(+)"+
				"       and a.reg_id is not null "+
				"       ";


		//기간구분
		if(gubun1.equals("1") && !st_dt.equals("") && !end_dt.equals(""))		query += " and a.buy_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";
		if(gubun1.equals("2") && !st_dt.equals("") && !end_dt.equals(""))		query += " and a.reg_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		if(gubun1.equals("1") && !st_dt.equals("") && end_dt.equals(""))		query += " and a.buy_dt like replace('"+st_dt+"%','-','')";
		if(gubun1.equals("2") && !st_dt.equals("") && end_dt.equals(""))		query += " and a.reg_dt like replace('"+st_dt+"%','-','')";


		//계정과목
		if(!gubun2.equals(""))		query += " and a.acct_code = '"+gubun2+"'";

		//영업소
		if(!s_br.equals(""))		query += " and c.br_id = '"+s_br+"'";
		//부서
		if(!gubun3.equals(""))		query += " and c.dept_id = '"+gubun3+"'";
		//사용자
		if(!gubun4.equals(""))		query += " and c.user_nm = '"+gubun4+"'";
		//카드관리자
		if(!gubun5.equals("0") && !gubun5.equals(""))	query += " and b.card_mng_id = '"+gubun5+"'";
		//전표승인자
		if(!gubun6.equals("0") && !gubun6.equals(""))	query += " and b.doc_mng_id = '"+gubun6+"'";
		//과세유형
		if(!chk1.equals(""))		query += " and a.ven_st='"+chk1+"'";

		
		query += " and a.ven_code=d.CD_PARTNER(+) "; 


		if(!t_wd1.equals(""))		query += " and b.cardno||b.card_name like '%"+t_wd1+"%'";

		if(!t_wd2.equals("")){
			if(s_kd.equals("1"))	query += " and a.ven_name like '%"+t_wd2+"%'";
			if(s_kd.equals("2"))	query += " and a.acct_cont like '%"+t_wd2+"%'";
			if(s_kd.equals("3"))	query += " and "+acct_code_g_nm+"||"+acct_code_g2_nm+"||"+acct_cont_nm+" like '%"+t_wd2+"%'";
			if(s_kd.equals("4"))	query += " and "+acct_cont_nm+" like '%"+t_wd2+"%'";
			if(s_kd.equals("5"))	query += " and a.buy_amt like '%"+t_wd2+"%'";
			if(s_kd.equals("6"))	query += " and d.s_idno like '%"+t_wd2+"%'";
		}
		query += " order by a.buy_dt, decode(c.br_id,'S1',1,'B1',2,'S2',3), decode(c.dept_id,'0004',1,2), decode(c.user_pos,'대리','2','사원',3,1), c.user_id";

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
			System.out.println("[CardDatabase:getCardAppList]\n"+e);
			System.out.println("[CardDatabase:getCardAppList]\n"+query);
	  		e.printStackTrace();

		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	//선택리스트의 전표관련내용 조회
	public Hashtable getAppCardDocSelectList(String cardno, String buy_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select"+
				" b.card_name, b.card_st, b.com_code, b.com_name, d.user_nm, e.firm_nm,"+
				" a.*"+
				" from card_doc a, card b, cont c, users d, client e"+
				" where a.cardno='"+cardno+"' and a.buy_id='"+buy_id+"'"+
				" and a.cardno=b.cardno and a.rent_l_cd=c.rent_l_cd(+) and a.buy_user_id=d.user_id(+)"+
				" and c.client_id=e.client_id(+)";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			if(rs.next())
			{								
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CardDatabase:getAppCardDocSelectList]\n"+e);
	  		e.printStackTrace();

		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}		
	}	
	
	/**
	 *	미승인전표조회 
	 * date : 2017.02.14
	 * author : 성승현
	 */	
	public Vector getUnreceivedScard()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query =	"SELECT TRIM(REPLACE(TO_CHAR(t.cardno, '0000,0000,0000,0000'),',', '-')) AS CARDNO, c.card_name, t.ackdate, \n"+
					"	TO_SINGLE_BYTE(t.mercname) AS MERCNAME, t.ackamount, t.csamount, t.csvat, \n"+
					"	DECODE(t.cancleyn, 'Y', '취소', '승인') AS CANCELYN \n"+
					"FROM EBANK.TBLACKINFO t, CARD c \n"+
					"WHERE t.erp_fms_yn <> 'Y' AND t.ackdate>'20170206' AND TRIM(REPLACE(TO_CHAR(t.cardno, '0000,0000,0000,0000'),',', '-')) = c.cardno \n"+
					"ORDER BY t.ackdate desc \n";


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
			System.out.println("[CardDatabase:getUnreceivedScard]\n"+e);
			System.out.println(query);
			e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}
	
	
	/**
	 *	전표조회 리스트 수정 - 삼성카드 데이터 직접 불러오는 것으로 수정
	 * date : 2016.11.30
	 * author : 성승현
	 */	
	public Vector getCardDocSearchListScard(String s_br, String chk1, String chk2, String chk3, String chk4, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String gubun7, String gubun8, String st_dt, String end_dt, String s_kd, String t_wd1, String t_wd2, String sort, String asc, String cgs_ok)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";

		String acct_code_g_nm	= "decode(a.acct_code_g,'','-','1','식대','2','복지비','3','기타','30','포상휴가','13','가솔린','4','디젤','5','LPG','27','전기차충전','6','일반정비','7','자동차검사','8','정밀검사','9','출장비','10','기타교통비','11','식대','12','경조사','14','기타','18','번호판대금','19','차량등록세','20','하이패스', '21', '재리스정비', '---') \n";
		String acct_code_g2_nm	= "decode(a.acct_code_g2,'1','-조식','2','-중식','3','-특근식','4','-회사전체모임','5','-부서별정기모임','6','-부서별부정기회식','7','-커피','8','-음료','9','-약품','10','-그외','11','-업무차량','12','-예비차량','13','-고객차량','---') \n";

		query = " select \n"+
				" a.*, decode(a.buy_v_amt,0,'비과세','과세') buy_st, decode(a.app_id,'',decode(a.reg_id,'','1','2'),decode(a.app_id,'cancel','4','cance0','5','3')) app_status, decode(a.chief_id,'','미확인','확인') chief, \n"+
				" decode(a.acct_code, '00001','복리후생비', '00002','접대비', '00003','여비교통비', '00004','차량유류대', '00005','차량정비비', '00006','사고수리비', '00007','사무용품비', '00008','소모품비', '00009','통신비', '00010','도서인쇄비', '00011','지급수수료', '00012','비품', '00013','선급금', '00014','교육훈련비', '00015','세금과공과', '00016','대여사업차량', '00017','리스사업차량', '00018','운반비', '00019','주차요금', '00020', '보험료', '00021', '업무비선급금' , '00023', '광고선전비') acct_code_nm, \n"+
				" "+acct_code_g_nm+" acct_code_g_nm, \n"+
				" "+acct_code_g2_nm+" acct_code_g2_nm, \n"+
				" c.user_nm, cu.user_id, \n"+
				" decode(a.item_name, '', decode(a.acct_cont, '', a.user_cont||' '||a.user_su||'명', a.acct_cont), a.item_name) acct_cont_nm, \n"+
				" b.card_mng_id, b.doc_mng_id, d.user_nm as owner_nm, b.card_name, b.card_sdate, b.card_edate  \n"+
				" from card_doc a, card b, users c, card_user cu,  ( select cardno, max(seq) as seq from card_user group by cardno) u , (select user_id, user_nm from users ) d  \n"+
				" where a.cardno=b.cardno \n"+
				" and nvl(a.buy_user_id,a.reg_id)=c.user_id(+) \n" +
				" and a.cardno=u.cardno \n"+
				" and cu.cardno=u.cardno \n"+
				" and cu.seq=u.seq \n"+
				" and cu.user_id =d.user_id(+) \n";



		//기간구분
		if(gubun1.equals("1") && !st_dt.equals("") && !end_dt.equals(""))		query += " and a.buy_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') \n";
		if(gubun1.equals("2") && !st_dt.equals("") && !end_dt.equals(""))		query += " and a.reg_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') \n";
		if(gubun1.equals("3") && !st_dt.equals("") && !end_dt.equals(""))		query += " and a.app_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') \n";

		if(gubun1.equals("1") && !st_dt.equals("") && end_dt.equals(""))		query += " and a.buy_dt like replace('"+st_dt+"%','-','') \n";
		if(gubun1.equals("2") && !st_dt.equals("") && end_dt.equals(""))		query += " and a.reg_dt like replace('"+st_dt+"%','-','') \n";
		if(gubun1.equals("3") && !st_dt.equals("") && end_dt.equals(""))		query += " and a.app_dt like replace('"+st_dt+"%','-','') \n";

		//계정과목
	//	if(!gubun2.equals(""))		query += " and a.acct_code = '"+gubun2+"' \n";
	
		if(!gubun2.equals(""))		query += " and b.card_kind = '"+gubun2+"'";
	
		
		//영업소
		if(!s_br.equals(""))		query += " and c.br_id = '"+s_br+"' \n";
		//부서
		if(!gubun3.equals(""))		query += " and c.dept_id = '"+gubun3+"' \n";
		//사용자
		if(!gubun4.equals(""))		query += " and c.user_nm = '"+gubun4+"' \n";
		//카드관리자
		if(!gubun5.equals("0") && !gubun5.equals(""))	query += " and b.card_mng_id = '"+gubun5+"' \n";
		//전표승인자
		if(!gubun6.equals("0") && !gubun6.equals(""))	query += " and b.doc_mng_id = '"+gubun6+"' \n";
		//소유자
		if(!gubun7.equals(""))		query += " and d.user_nm = '"+gubun7+"' \n"; 
		//등록자
		if(!gubun8.equals(""))		query += " and a.reg_id = '"+gubun8+"' \n";

		//승인여부
		if(chk2.equals("1"))		query += " and a.app_id is not null and a.app_id not in ('cancel') \n";
		if(chk2.equals("2"))		query += " and a.reg_id is not null and a.app_id is null \n";
		if(chk2.equals("3"))		query += " and a.reg_id is null and a.app_id is null \n";
		if(chk2.equals("4"))		query += " and a.app_id in ('cancel', 'cance0') \n";

		//과세유형
		if(!chk1.equals(""))		query += " and a.ven_st='"+chk1+"' \n";

		if(!t_wd1.equals(""))		query += " and b.cardno||b.card_name like '%"+t_wd1+"%' \n";

		if(!t_wd2.equals("")){
			if(s_kd.equals("1"))	query += " and a.ven_name like '%"+t_wd2+"%' \n";
			if(s_kd.equals("2"))	query += " and a.acct_cont like '%"+t_wd2+"%' \n";
			if(s_kd.equals("3"))	query += " and "+acct_code_g_nm+"||"+acct_code_g2_nm+" like '%"+t_wd2+"%' \n";
			if(s_kd.equals("5"))	query += " and a.buy_amt like '%"+t_wd2+"%' \n";
		}

		query += " order by app_status, a.buy_dt, decode(a.app_id,'',1,2), decode(c.br_id,'S1',1,'B1',2,'S2',3), decode(c.dept_id,'0004',1,2), decode(c.user_pos,'대리','2','사원',3,1), c.user_id \n";

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
			System.out.println("[CardDatabase:getCardDocSearchListScard]\n"+e);
			System.out.println(query);
			e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 *	전표조회 리스트
	 */	
	public Vector getCardDocSearchList(String s_br, String chk1, String chk2, String chk3, String chk4, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String gubun7, String gubun8, String st_dt, String end_dt, String s_kd, String t_wd1, String t_wd2, String sort, String asc, String cgs_ok)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";

		String acct_code_g_nm	= "decode(a.acct_code_g,'','-','1','식대','2','복지비','3','기타','30','포상휴가','13','가솔린','4','디젤','5','LPG','27','전기차충전','6','일반정비','7','자동차검사','8','정밀검사','9','출장비','10','기타교통비','11','식대','12','경조사','14','기타','18','번호판대금','19','차량등록세','20','하이패스', '21', '재리스정비', '---')";
		String acct_code_g2_nm	= "decode(a.acct_code_g2,'1','-조식','2','-중식','3','-특근식','4','-회사전체모임','5','-부서별정기모임','6','-부서별부정기회식','7','-커피','8','-음료','9','-약품','10','-그외','11','-업무차량','12','-예비차량','13','-고객차량','---')";

		query = " select"+
				" a.*, decode(a.buy_v_amt,0,'비과세','과세') buy_st, decode(a.app_id,'','미승인','승인') app_st, decode(a.chief_id,'','미확인','확인') chief,"+
				" decode(a.acct_code, '00001','복리후생비', '00002','접대비', '00003','여비교통비', '00004','차량유류대', '00005','차량정비비', '00006','사고수리비', '00007','사무용품비', '00008','소모품비', '00009','통신비', '00010','도서인쇄비', '00011','지급수수료', '00012','비품', '00013','선급금', '00014','교육훈련비', '00015','세금과공과', '00016','대여사업차량', '00017','리스사업차량', '00018','운반비', '00019','주차요금', '00020', '보험료', '00021', '업무비선급금' ,'00023', '광고선전비' ) acct_code_nm,"+
				" "+acct_code_g_nm+" acct_code_g_nm,"+
				" "+acct_code_g2_nm+" acct_code_g2_nm,"+
				" c.user_nm,"+
				" decode(a.item_name, '', decode(a.acct_cont, '', a.user_cont||' '||a.user_su||'명', a.acct_cont), a.item_name) acct_cont_nm,"+
				" b.card_mng_id, b.doc_mng_id, d.user_nm as owner_nm "+
				" from card_doc a, card b, users c, card_user cu,  ( select cardno, max(seq) as seq from card_user group by cardno) u , (select user_id, user_nm from users ) d, users d2 "+
				" where a.cardno=b.cardno"+
				" and nvl(a.buy_user_id,a.reg_id)=c.user_id(+)" +
				" and a.cardno=u.cardno"+
				" and cu.cardno=u.cardno"+
				" and cu.seq=u.seq"+
				" and cu.user_id =d.user_id(+) and a.reg_id=d2.user_id(+) ";



		//기간구분
		if(gubun1.equals("1") && !st_dt.equals("") && !end_dt.equals(""))		query += " and a.buy_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";
		if(gubun1.equals("2") && !st_dt.equals("") && !end_dt.equals(""))		query += " and a.reg_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";
		if(gubun1.equals("3") && !st_dt.equals("") && !end_dt.equals(""))		query += " and a.app_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";
		if(gubun1.equals("4") && !st_dt.equals("") && !end_dt.equals(""))		query += " and nvl(a.r_buy_dt,a.buy_dt) between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		if(gubun1.equals("1") && !st_dt.equals("") && end_dt.equals(""))		query += " and a.buy_dt like replace('"+st_dt+"%','-','')";
		if(gubun1.equals("2") && !st_dt.equals("") && end_dt.equals(""))		query += " and a.reg_dt like replace('"+st_dt+"%','-','')";
		if(gubun1.equals("3") && !st_dt.equals("") && end_dt.equals(""))		query += " and a.app_dt like replace('"+st_dt+"%','-','')";
		if(gubun1.equals("4") && !st_dt.equals("") && end_dt.equals(""))		query += " and nvl(a.r_buy_dt,a.buy_dt) like replace('"+st_dt+"%','-','')";

		//계정과목
		if(!gubun2.equals(""))		query += " and a.acct_code = '"+gubun2+"'";

		//영업소
		if(!s_br.equals(""))		query += " and c.br_id = '"+s_br+"'";
		//부서
		if(!gubun3.equals(""))		query += " and c.dept_id = '"+gubun3+"'";
		//사용자
		if(!gubun4.equals(""))		query += " and c.user_nm = '"+gubun4+"'";
		//카드관리자
		if(!gubun5.equals("0") && !gubun5.equals(""))	query += " and b.card_mng_id = '"+gubun5+"'";
		//전표승인자
		if(!gubun6.equals("0") && !gubun6.equals(""))	query += " and b.doc_mng_id = '"+gubun6+"'";
		//소유자
		if(!gubun7.equals(""))		query += " and d.user_nm = '"+gubun7+"'"; 
		//등록자
		if(!gubun8.equals(""))		query += " and d2.user_nm = '"+gubun8+"'";

		
		if(chk2.equals("C")) {
			query += " and NVL(a.app_id,'-') IN ('cancel','cance0')";
		}else {
			query += " and NVL(a.app_id,'-') NOT IN ('cancel','cance0')";			
			//승인여부
			if(chk2.equals("Y"))		query += " and a.app_id is not null ";
			if(chk2.equals("N"))		query += " and a.app_id is null  ";			
		}
		

		//과세유형
		if(!chk1.equals(""))		query += " and a.ven_st='"+chk1+"'";

		if(!t_wd1.equals(""))		query += " and b.cardno||b.card_name like '%"+t_wd1+"%'";

		if(!t_wd2.equals("")){
			if(s_kd.equals("1"))	query += " and a.ven_name like '%"+t_wd2+"%'";
			if(s_kd.equals("2"))	query += " and a.acct_cont like '%"+t_wd2+"%'";
			if(s_kd.equals("3"))	query += " and "+acct_code_g_nm+"||"+acct_code_g2_nm+" like '%"+t_wd2+"%'";
			if(s_kd.equals("5"))	query += " and a.buy_amt like '%"+t_wd2+"%'";
		}

		query += " order by a.buy_dt, decode(a.app_id,'',1,2), decode(c.br_id,'S1',1,'B1',2,'S2',3), decode(c.dept_id,'0004',1,2), decode(c.user_pos,'대리','2','사원',3,1), c.user_id";

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
			System.out.println("[CardDatabase:getCardDocSearchList]\n"+e);
			System.out.println("[CardDatabase:getCardDocSearchList]\n"+query);			
			e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}




/**  Ryu gill sun 2011.12.20 추가
	 *	전표조회 리스트 2
	 */	
	public Vector getCardDocSearchList2(String s_br, String chk1, String chk2, String chk3, String chk4, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String gubun7, String gubun8, String gubun9, String st_dt, String end_dt, String s_kd, String t_wd1, String t_wd2, String sort, String asc, String cgs_ok)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";

		String acct_code_g_nm	= "decode(a.acct_code_g,'','-','1','식대','2','복지비','3','기타','13','가솔린','4','디젤','5','LPG','27','전기차충전','6','일반정비','7','자동차검사','8','정밀검사','9','출장비','10','기타교통비','11','식대','12','경조사','14','기타','18','번호판대금','19','차량등록세','20','하이패스', '21', '재리스정비', '---')";
		String acct_code_g2_nm	= "decode(a.acct_code_g2,'1','-조식','2','-중식','3','-특근식','4','-회사전체모임','5','-부서별정기모임','6','-부서별부정기회식','7','-커피','8','-음료','9','-약품','10','-그외','11','-업무차량','12','-예비차량','13','-고객차량','---')";

		query = " select"+
				" a.*, decode(a.buy_v_amt,0,'비과세','과세') buy_st, decode(a.app_id,'','미승인','승인') app_st, decode(a.chief_id,'','미확인','확인') chief,"+
				" decode(a.acct_code, '00001','복리후생비', '00002','접대비', '00003','여비교통비', '00004','차량유류대', '00005','차량정비비', '00006','사고수리비', '00007','사무용품비', '00008','소모품비', '00009','통신비', '00010','도서인쇄비', '00011','지급수수료', '00012','비품', '00013','선급금', '00014','교육훈련비', '00015','세금과공과', '00016','대여사업차량', '00017','리스사업차량', '00018','운반비', '00019','주차요금', '00020', '보험료' , '00021', '업무비선급금', '00023', '광고선전비') acct_code_nm,"+
				" "+acct_code_g_nm+" acct_code_g_nm,"+
				" "+acct_code_g2_nm+" acct_code_g2_nm,"+
				" c.user_nm,"+
				" decode(a.item_name, '', decode(a.acct_cont, '', a.user_cont||' '||a.user_su||'명', a.acct_cont), a.item_name) acct_cont_nm,"+
				" b.card_mng_id, b.doc_mng_id, d.user_nm as owner_nm "+
				" from card_doc a, card b, users c, card_user cu,  ( select cardno, max(seq) as seq from card_user group by cardno) u , (select user_id, user_nm from users ) d "+
				" where a.cardno=b.cardno"+
				" and nvl(a.buy_user_id,a.reg_id)=c.user_id(+)" +
				" and a.cardno=u.cardno"+
				" and cu.cardno=u.cardno"+
				" and cu.seq=u.seq"+
				" and cu.user_id =d.user_id(+)";



		//기간구분
		if(gubun1.equals("1") && !st_dt.equals("") && !end_dt.equals(""))		query += " and a.buy_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";
		if(gubun1.equals("2") && !st_dt.equals("") && !end_dt.equals(""))		query += " and a.reg_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";
		if(gubun1.equals("3") && !st_dt.equals("") && !end_dt.equals(""))		query += " and a.app_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		if(gubun1.equals("1") && !st_dt.equals("") && end_dt.equals(""))		query += " and a.buy_dt like replace('"+st_dt+"%','-','')";
		if(gubun1.equals("2") && !st_dt.equals("") && end_dt.equals(""))		query += " and a.reg_dt like replace('"+st_dt+"%','-','')";
		if(gubun1.equals("3") && !st_dt.equals("") && end_dt.equals(""))		query += " and a.app_dt like replace('"+st_dt+"%','-','')";

		//계정과목
		if(!gubun2.equals(""))		query += " and a.acct_code = '"+gubun2+"'";

		//영업소
		if(!s_br.equals(""))		query += " and c.br_id = '"+s_br+"'";
		//부서
		if(!gubun3.equals(""))		query += " and c.dept_id = '"+gubun3+"'";
		//사용자
		if(!gubun4.equals(""))		query += " and c.user_id = '"+gubun4+"'";
		//카드관리자
		if(!gubun5.equals("0") && !gubun5.equals(""))	query += " and b.card_mng_id = '"+gubun5+"'";
		//전표승인자
		if(!gubun6.equals("0") && !gubun6.equals(""))	query += " and b.doc_mng_id = '"+gubun6+"'";
		//소유자
		if(!gubun7.equals(""))		query += " and d.user_id = '"+gubun7+"'";
		//등록자
		if(!gubun8.equals(""))		query += " and a.reg_id = '"+gubun8+"'";
		
			//부서장확인여부
		if(gubun9.equals("Y"))		query += " and a.chief_id is null and a.buy_dt > '20130630'  and a.card_file is not  null  ";
	
		//승인여부
		if(chk2.equals("Y"))		query += " and a.app_id is not null ";
		if(chk2.equals("N"))		query += " and a.app_id is null";

		if(!t_wd1.equals(""))		query += " and b.cardno||b.card_name like '%"+t_wd1+"%'";

		if(!t_wd2.equals("")){
			if(s_kd.equals("1"))	query += " and a.ven_name like '%"+t_wd2+"%'";
			if(s_kd.equals("2"))	query += " and a.acct_cont like '%"+t_wd2+"%'";
			if(s_kd.equals("3"))	query += " and "+acct_code_g_nm+"||"+acct_code_g2_nm+" like '%"+t_wd2+"%'";
			if(s_kd.equals("5"))	query += " and a.buy_amt like '%"+t_wd2+"%'";
		}

		query += " order by a.cgs_ok desc, a.buy_dt, decode(a.app_id,'',1,2), decode(c.br_id,'S1',1,'B1',2,'S2',3), decode(c.dept_id,'0004',1,2), decode(c.user_pos,'대리','2','사원',3,1), c.user_id";

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
			System.out.println("[CardDatabase:getCardDocSearchList]\n"+e);
			System.out.println(query);
			e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}



	//카드현황----------------------------------------------------------------------------------------------------------------------------


	//카드보유현황 당일 등록건수 조회
	public int getCardDocTodayCnt()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int seq = 0;
		String query = "";

		query = " select count(0) from card_doc where buy_dt = to_char(sysdate,'YYYYMMDD')";

		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
   	
			if(rs.next())
			{				
				seq = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CardDatabase:getCardDocTodayCnt]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return seq;
		}		
	}

	/**
	 *	카드보유현황
	 */	
	public Vector getCardHoldStat()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";

		query = " select "+
				" a.card_kind, count(0) cnt00,"+
				" count(decode(a.card_st,'1',a.cardno)) cnt01,"+
				" count(decode(a.card_st,'2',a.cardno)) cnt02,"+
				" count(decode(a.card_st,'3',a.cardno)) cnt03,"+
				" count(decode(c.br_id,'S1',a.cardno,'',a.cardno)) cnt10,"+
				" count(decode(a.card_st,'1',decode(c.br_id,'S1',a.cardno,'',a.cardno))) cnt11,"+
				" count(decode(a.card_st,'2',decode(c.br_id,'S1',a.cardno,'',a.cardno))) cnt12,"+
				" count(decode(a.card_st,'3',decode(c.br_id,'S1',a.cardno,'',a.cardno))) cnt13,"+
				" count(decode(c.br_id,'B1',a.cardno)) cnt20,"+
				" count(decode(a.card_st,'1',decode(c.br_id,'B1',a.cardno))) cnt21,"+
				" count(decode(a.card_st,'2',decode(c.br_id,'B1',a.cardno))) cnt22,"+
				" count(decode(a.card_st,'3',decode(c.br_id,'B1',a.cardno))) cnt23"+
				" from card a, card_user b, users c"+
				" where a.use_yn='Y'"+
				" and a.cardno=b.cardno(+) and a.user_seq=b.seq(+)"+
				" and b.user_id=c.user_id(+)"+
				" group by a.card_kind order by count(0) desc";


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
			System.out.println("[CardDatabase:getCardHoldStat]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 *	카드사용현황-계정과목현황_부서별
	 */	
	public Vector getCardUseAcctStat(String s_br, String chk1, String chk2, String chk3, String chk4, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String st_dt, String end_dt, String s_kd, String t_wd1, String t_wd2, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";

		query = " select"+
				" c.nm, b.dept_id,"+
				" count(decode(a.acct_code,  '00001',a.buy_id)) cnt1,"+
				" nvl(sum(decode(a.acct_code,'00001',a.buy_amt)),0) amt1,"+
				" count(decode(a.acct_code,  '00002',a.buy_id)) cnt2,"+
				" nvl(sum(decode(a.acct_code,'00002',a.buy_amt)),0) amt2,"+
				" count(decode(a.acct_code,  '00003',a.buy_id)) cnt3,"+
				" nvl(sum(decode(a.acct_code,'00003',a.buy_amt)),0) amt3,"+
				" count(decode(a.acct_code,  '00004',a.buy_id)) cnt4,"+
				" nvl(sum(decode(a.acct_code,'00004',a.buy_amt)),0) amt4,"+
				" count(decode(a.acct_code,  '00005',a.buy_id)) cnt5,"+
				" nvl(sum(decode(a.acct_code,'00005',a.buy_amt)),0) amt5,"+
				" count(decode(a.acct_code,  '00006',a.buy_id)) cnt6,"+
				" nvl(sum(decode(a.acct_code,'00006',a.buy_amt)),0) amt6,"+
				" count(decode(a.acct_code,  '00007',a.buy_id)) cnt7,"+
				" nvl(sum(decode(a.acct_code,'00007',a.buy_amt)),0) amt7,"+
				" count(decode(a.acct_code,  '00008',a.buy_id)) cnt8,"+
				" nvl(sum(decode(a.acct_code,'00008',a.buy_amt)),0) amt8,"+
				" count(decode(a.acct_code,  '00009',a.buy_id)) cnt9,"+
				" nvl(sum(decode(a.acct_code,'00009',a.buy_amt)),0) amt9,"+
				" count(decode(a.acct_code,  '00010',a.buy_id)) cnt10,"+
				" nvl(sum(decode(a.acct_code,'00010',a.buy_amt)),0) amt10,"+
				" count(decode(a.acct_code,  '00011',a.buy_id)) cnt11,"+
				" nvl(sum(decode(a.acct_code,'00011',a.buy_amt)),0) amt11,"+
				" count(decode(a.acct_code,  '00012',a.buy_id)) cnt12,"+
				" nvl(sum(decode(a.acct_code,'00012',a.buy_amt)),0) amt12,"+
				" count(decode(a.acct_code,  '00013',a.buy_id)) cnt13,"+
				" nvl(sum(decode(a.acct_code,'00013',a.buy_amt)),0) amt13"+
				" from card_doc a, users b, (select * from code where c_st='0002') c"+
				" where a.buy_user_id=b.user_id and b.dept_id=c.code";

		//기간조회
		if(chk1.equals("1"))		query += " and a.buy_dt=to_char(sysdate,'YYYYMMDD')";
		if(chk1.equals("2"))		query += " and a.buy_dt like to_char(sysdate,'YYYYMM')||'%'";
		if(chk1.equals("3")){
			if(!st_dt.equals("") && !end_dt.equals(""))		query += " and a.buy_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";
			if(!st_dt.equals("") && end_dt.equals(""))		query += " and a.buy_dt = replace('"+st_dt+"','-','')";
		}
		//영업소
		if(!s_br.equals(""))		query += " and b.br_id = '"+s_br+"'";
		//부서
		if(!gubun3.equals(""))		query += " and b.dept_id = '"+gubun3+"'";

		query += " group by c.nm, b.dept_id"+
				 " order by count(0) desc";

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
			System.out.println("[CardDatabase:getCardUseAcctStat]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 *	카드사용현황-계정과목현황_계정과목별
	 */	
	public Vector getCardUseAcctStat2(String com_code, String s_br, String chk1, String chk2, String chk3, String chk4, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String st_dt, String end_dt, String s_kd, String t_wd1, String t_wd2, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";

		query = " select"+
				" a.acct_code,"+
				" decode(a.acct_code, '00001','복리후생비', '00002','접대비', '00003','여비교통비', '00004','차량유류대', '00005','차량정비비', '00006','사고수리비', '00007','사무용품비', '00008','소모품비', '00009','통신비', '00010','도서인쇄비', '00011','지급수수료', '00012','비품', '00013','선급금', '00014','교육훈련비', '00015','세금과공과', '00016','대여사업차량', '00017','리스사업차량', '00018','운반비', '00019','주차요금', '00020', '보험료', '00021', '업무비선금금' , '00023', '광고선전비') acct_code_nm,"+
				" count(a.buy_id) cnt0,"+//--합계
				" nvl(sum(a.buy_amt),0) amt0,"+
				" count(decode(b.dept_id,'0001',a.buy_id)) cnt1,"+//--영업팀
				" nvl(sum(decode(b.dept_id,'0001',a.buy_amt)),0) amt1,"+
				" count(decode(b.dept_id,'0002',a.buy_id)) cnt2,"+//--관리팀
				" nvl(sum(decode(b.dept_id,'0002',a.buy_amt)),0) amt2,"+
				" count(decode(b.dept_id,'0003',a.buy_id)) cnt3,"+//--총무팀
				" nvl(sum(decode(b.dept_id,'0003',a.buy_amt)),0) amt3,"+
				" count(decode(b.dept_id,'0004',a.buy_id)) cnt4,"+//--임원
				" nvl(sum(decode(b.dept_id,'0004',a.buy_amt)),0) amt4"+
				" from card_doc a, users b, (select * from code where c_st='0002') c, card d"+
				" where a.buy_user_id=b.user_id and b.dept_id=c.code and a.cardno=d.cardno(+)";

		//기간조회
		if(chk1.equals("1"))		query += " and a.buy_dt=to_char(sysdate,'YYYYMMDD')";
		if(chk1.equals("2"))		query += " and a.buy_dt like to_char(sysdate,'YYYYMM')||'%'";
		if(chk1.equals("3")){
			if(!st_dt.equals("") && !end_dt.equals(""))		query += " and a.buy_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";
			if(!st_dt.equals("") && end_dt.equals(""))		query += " and a.buy_dt = replace('"+st_dt+"','-','')";
		}
		//영업소
		if(!s_br.equals(""))		query += " and b.br_id = '"+s_br+"'";
		//부서
		if(!gubun3.equals(""))		query += " and b.dept_id = '"+gubun3+"'";

		//카드사
		if(!com_code.equals(""))		query += " and d.com_code = '"+com_code+"'";

		//카드
		if(!gubun5.equals(""))		query += " and a.cardno = '"+gubun5+"'";

		query += " group by a.acct_code"+
				 " order by nvl(sum(a.buy_amt),0) desc";

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
			System.out.println("[CardDatabase:getCardUseAcctStat]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 *	카드사용현황-계정과목현황_월간
	 */	
	public Vector getCardUseAcctMStat(String s_br, String chk1, String chk2, String chk3, String chk4, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String st_dt, String end_dt, String s_kd, String t_wd1, String t_wd2, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";

		query = " select"+
				" a.buy_dt,"+
				" count(a.buy_id) cnt0,"+//--소계
				" nvl(sum(a.buy_amt),0) amt0,"+
				" count(decode(a.acct_code,  '00001',a.buy_id)) cnt1,"+
				" nvl(sum(decode(a.acct_code,'00001',a.buy_amt)),0) amt1,"+
				" count(decode(a.acct_code,  '00002',a.buy_id)) cnt2,"+
				" nvl(sum(decode(a.acct_code,'00002',a.buy_amt)),0) amt2,"+
				" count(decode(a.acct_code,  '00003',a.buy_id)) cnt3,"+
				" nvl(sum(decode(a.acct_code,'00003',a.buy_amt)),0) amt3,"+
				" count(decode(a.acct_code,  '00004',a.buy_id)) cnt4,"+
				" nvl(sum(decode(a.acct_code,'00004',a.buy_amt)),0) amt4,"+
				" count(decode(a.acct_code,  '00005',a.buy_id)) cnt5,"+
				" nvl(sum(decode(a.acct_code,'00005',a.buy_amt)),0) amt5,"+
				" count(decode(a.acct_code,  '00006',a.buy_id)) cnt6,"+
				" nvl(sum(decode(a.acct_code,'00006',a.buy_amt)),0) amt6,"+
				" count(decode(a.acct_code,  '00007',a.buy_id)) cnt7,"+
				" nvl(sum(decode(a.acct_code,'00007',a.buy_amt)),0) amt7,"+
				" count(decode(a.acct_code,  '00008',a.buy_id)) cnt8,"+
				" nvl(sum(decode(a.acct_code,'00008',a.buy_amt)),0) amt8,"+
				" count(decode(a.acct_code,  '00009',a.buy_id)) cnt9,"+
				" nvl(sum(decode(a.acct_code,'00009',a.buy_amt)),0) amt9,"+
				" count(decode(a.acct_code,  '00010',a.buy_id)) cnt10,"+
				" nvl(sum(decode(a.acct_code,'00010',a.buy_amt)),0) amt10,"+
				" count(decode(a.acct_code,  '00011',a.buy_id)) cnt11,"+
				" nvl(sum(decode(a.acct_code,'00011',a.buy_amt)),0) amt11,"+
				" count(decode(a.acct_code,  '00012',a.buy_id)) cnt12,"+
				" nvl(sum(decode(a.acct_code,'00012',a.buy_amt)),0) amt12,"+
				" count(decode(a.acct_code,  '00013',a.buy_id)) cnt13,"+
				" nvl(sum(decode(a.acct_code,'00013',a.buy_amt)),0) amt13"+
				" from card_doc a, users b, (select * from code where c_st='0002') c"+
				" where a.buy_user_id=b.user_id and b.dept_id=c.code";

		//기간조회
		if(chk1.equals("1"))		query += " and a.buy_dt=to_char(sysdate,'YYYYMMDD')";
		if(chk1.equals("2"))		query += " and a.buy_dt like to_char(sysdate,'YYYYMM')||'%'";
		if(chk1.equals("3")){
			if(!st_dt.equals("") && !end_dt.equals(""))		query += " and a.buy_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";
			if(!st_dt.equals("") && end_dt.equals(""))		query += " and a.buy_dt = replace('"+st_dt+"','-','')";
		}
		//영업소
		if(!s_br.equals(""))		query += " and b.br_id = '"+s_br+"'";
		//부서
		if(!gubun3.equals(""))		query += " and b.dept_id = '"+gubun3+"'";

		//카드
		if(!gubun5.equals(""))		query += " and a.cardno = '"+gubun5+"'";

		query += " group by a.buy_dt"+
				 " order by a.buy_dt";

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
			System.out.println("[CardDatabase:getCardUseAcctStat]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 *	카드사용현황-계정과목현황_일간
	 */	
	public Vector getCardUseAcctDStat(String acct_code, String s_br, String chk1, String chk2, String chk3, String chk4, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String st_dt, String end_dt, String s_kd, String t_wd1, String t_wd2, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";

		query = " select"+
				" a.acct_code, a.acct_code_g,"+
				" decode(a.acct_code, '00001','복리후생비', '00002','접대비', '00003','여비교통비', '00004','차량유류대', '00005','차량정비비', '00006','사고수리비', '00007','사무용품비', '00008','소모품비', '00009','통신비', '00010','도서인쇄비', '00011','지급수수료', '00012','비품', '00013','선급금', '00014','교육훈련비', '00015','세금과공과', '00016','대여사업차량', '00017','리스사업차량', '00018','운반비', '00019','주차요금', '00020', '보험료', '00021', '업무비선급금' , '00023', '광고선전비') acct_code_nm,"+
				" decode(a.acct_code_g,'1','식대','2','복지비','3','기타','13','가솔린','4','디젤','5','LPG','27','전기차충전','6','일반정비','7','자동차검사','8','정밀검사','9','출장비','10','기타교통비','11','식대','12','경조사','14','기타','18','번호판대금','19','차량등록세','20','하이패스','소계') acct_code_g_nm,"+
				" count(a.buy_id) cnt0,"+//--합계
				" nvl(sum(a.buy_amt),0) amt0,"+
				" count(decode(b.dept_id,'0001',a.buy_id)) cnt1,"+//--영업팀
				" nvl(sum(decode(b.dept_id,'0001',a.buy_amt)),0) amt1,"+
				" count(decode(b.dept_id,'0002',a.buy_id)) cnt2,"+//--관리팀
				" nvl(sum(decode(b.dept_id,'0002',a.buy_amt)),0) amt2,"+
				" count(decode(b.dept_id,'0003',a.buy_id)) cnt3,"+//--총무팀
				" nvl(sum(decode(b.dept_id,'0003',a.buy_amt)),0) amt3,"+
				" count(decode(b.dept_id,'0004',a.buy_id)) cnt4,"+//--임원
				" nvl(sum(decode(b.dept_id,'0004',a.buy_amt)),0) amt4"+
				" from card_doc a, users b, (select * from code where c_st='0002') c"+
				" where a.buy_user_id=b.user_id and b.dept_id=c.code";

		//기간조회
		if(chk1.equals("1"))		query += " and a.buy_dt=to_char(sysdate,'YYYYMMDD')";
		if(chk1.equals("2"))		query += " and a.buy_dt like to_char(sysdate,'YYYYMM')||'%'";
		if(chk1.equals("3")){
			if(!st_dt.equals("") && !end_dt.equals(""))		query += " and a.buy_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";
			if(!st_dt.equals("") && end_dt.equals(""))		query += " and a.buy_dt = replace('"+st_dt+"','-','')";
		}

		//영업소
		if(!s_br.equals(""))		query += " and b.br_id = '"+s_br+"'";
		//부서
		if(!gubun3.equals(""))		query += " and b.dept_id = '"+gubun3+"'";
		//카드
		if(!gubun5.equals(""))		query += " and a.cardno = '"+gubun5+"'";

		//계정과목
		if(!acct_code.equals(""))	query += " and a.acct_code = '"+acct_code+"'";

		query += " group by a.acct_code, a.acct_code_g"+
				 " order by nvl(sum(a.buy_amt),0) desc";

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
			System.out.println("[CardDatabase:getCardUseAcctDStat]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 *	카드사용현황-계정과목현황_일간_리스트
	 */	
	public Vector getCardUseAcctDList(String com_code, String acct_code, String acct_code_g, String s_br, String chk1, String chk2, String chk3, String chk4, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String st_dt, String end_dt, String s_kd, String t_wd1, String t_wd2, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";

		query = " select"+
				" c.br_nm, d.nm, b.user_nm,"+
				" decode(a.acct_code, '00001','복리후생비', '00002','접대비', '00003','여비교통비', '00004','차량유류대', '00005','차량정비비', '00006','사고수리비', '00007','사무용품비', '00008','소모품비', '00009','통신비', '00010','도서인쇄비', '00011','지급수수료', '00012','비품', '00013','선급금', '00014','교육훈련비', '00015','세금과공과', '00016','대여사업차량', '00017','리스사업차량', '00018','운반비', '00019','주차요금', '00020', '보험료' , '00021', '업무비선급금' , '00023', '광고선전비') acct_code_nm,"+
				" decode(decode(a.acct_code_g,'',decode(a.acct_code,'00001','1','00002','11','00004','4','00005','6'),a.acct_code_g),"+
				"		'1', decode(a.acct_code_g2,'1','조식','2','중식','3','특근식')||'-'||a.user_su||'명/'||a.user_cont,"+
				"		'2', decode(a.acct_code_g2,'4','회사전체모임','5','부서별정기모임','6','부서별부정기회식'),"+
				"		'3', decode(a.acct_code_g2,'7','커피','8','음료','9','약품','10',a.acct_cont),"+
				"		'13', '가솔린'||'-'||a.item_name,"+
				"		'4', '디젤'||'-'||a.item_name,"+
				"		'5', 'LPG'||'-'||a.item_name,"+
				"		'27', '전기차충전'||'-'||a.item_name,"+
				"		'6', '일반정비'||'-'||a.item_name||'-'||a.acct_cont,"+
				"		'7', '자동차검사'||'-'||a.item_name,"+
				"		'8', '정밀검사'||'-'||a.item_name,"+
				"		'9', '출장비'||'-'||a.acct_cont,"+
				"		'10','기타교통비'||'-'||a.acct_cont,"+
				"		'11','식대'||'-'||a.acct_cont||'-'||a.user_su||'명/'||a.user_cont,"+
				"		'12','경조사'||'-'||a.acct_cont,"+
				"		'14','기타'||'-'||a.acct_cont,"+
				"		'18','번호판대금'||'-'||a.acct_cont,"+
				"		'19','차량등록세'||'-'||a.acct_cont,"+
				"		'21','재리스정비'||'-'||a.acct_cont,"+
				"		a.acct_cont) acct_cont_nm,"+
				" a.*"+
				" from card_doc a, users b, branch c, (select * from code where c_st='0002') d, card e"+
				" where a.buy_user_id=b.user_id"+
				" and b.br_id=c.br_id"+
				" and b.dept_id=d.code and a.cardno=e.cardno(+)";

		//기간조회
		if(chk1.equals("1"))		query += " and a.buy_dt=to_char(sysdate,'YYYYMMDD')";
		if(chk1.equals("2"))		query += " and a.buy_dt like to_char(sysdate,'YYYYMM')||'%'";
		if(chk1.equals("3")){
			if(!st_dt.equals("") && !end_dt.equals(""))		query += " and a.buy_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";
			if(!st_dt.equals("") && end_dt.equals(""))		query += " and a.buy_dt = replace('"+st_dt+"','-','')";
		}

		if(chk2.equals("2")){
			//계정과목
			if(!acct_code.equals(""))	query += " and a.acct_code = '"+acct_code+"'";
			//계정과목_구분
			if(!acct_code_g.equals(""))	query += " and a.acct_code_g = '"+acct_code_g+"'";
		}

		//영업소
		if(!s_br.equals(""))		query += " and b.br_id = '"+s_br+"'";
		//부서
		if(!gubun3.equals(""))		query += " and b.dept_id = '"+gubun3+"'";
		//카드사
		if(!com_code.equals(""))	query += " and e.com_code = '"+com_code+"'";

		//카드
		if(!gubun5.equals(""))		query += " and a.cardno = '"+gubun5+"'";

		query += " order by a.buy_dt";

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
			System.out.println("[CardDatabase:getCardUseAcctDStat]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 *	카드사용현황-계정과목현황_계정과목별
	 */	
	public Vector getCardUseAcctUStat(String s_br, String chk1, String chk2, String chk3, String chk4, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String st_dt, String end_dt, String s_kd, String t_wd1, String t_wd2, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";

		query = " select"+
				" a.cardno, decode(b.dept_id,'0001','영업팀','0002','고객지원팀','0003','총무팀','0007','부산지점','0008','대전지점','8888', '기타', '0004','임원', ' ') as dept_nm, "+
				" decode(min(d.card_st),'3',decode(min(d.card_chk), null,min(b.user_nm), '',min(b.user_nm), min(d.card_chk) ),'1','구매','2','공용') user_nm,"+
				" count(a.buy_id) cnt0,"+//--소계
				" nvl(sum(a.buy_amt),0) amt0,"+
				" count(decode(a.acct_code,  '00001',a.buy_id)) cnt1,"+
				" nvl(sum(decode(a.acct_code,'00001',a.buy_amt)),0) amt1,"+
				" count(decode(a.acct_code,  '00002',a.buy_id)) cnt2,"+
				" nvl(sum(decode(a.acct_code,'00002',a.buy_amt)),0) amt2,"+
				" count(decode(a.acct_code,  '00003',a.buy_id)) cnt3,"+
				" nvl(sum(decode(a.acct_code,'00003',a.buy_amt)),0) amt3,"+
				" count(decode(a.acct_code,  '00004',a.buy_id)) cnt4,"+
				" nvl(sum(decode(a.acct_code,'00004',a.buy_amt)),0) amt4,"+
				" count(decode(a.acct_code,  '00005',a.buy_id)) cnt5,"+
				" nvl(sum(decode(a.acct_code,'00005',a.buy_amt)),0) amt5,"+
				" count(decode(a.acct_code,  '00006',a.buy_id)) cnt6,"+
				" nvl(sum(decode(a.acct_code,'00006',a.buy_amt)),0) amt6,"+
				" count(decode(a.acct_code,  '00007',a.buy_id)) cnt7,"+
				" nvl(sum(decode(a.acct_code,'00007',a.buy_amt)),0) amt7,"+
				" count(decode(a.acct_code,  '00008',a.buy_id)) cnt8,"+
				" nvl(sum(decode(a.acct_code,'00008',a.buy_amt)),0) amt8,"+
				" count(decode(a.acct_code,  '00009',a.buy_id)) cnt9,"+
				" nvl(sum(decode(a.acct_code,'00009',a.buy_amt)),0) amt9,"+
				" count(decode(a.acct_code,  '00010',a.buy_id)) cnt10,"+
				" nvl(sum(decode(a.acct_code,'00010',a.buy_amt)),0) amt10,"+
				" count(decode(a.acct_code,  '00011',a.buy_id)) cnt11,"+
				" nvl(sum(decode(a.acct_code,'00011',a.buy_amt)),0) amt11,"+
				" count(decode(a.acct_code,  '00012',a.buy_id)) cnt12,"+
				" nvl(sum(decode(a.acct_code,'00012',a.buy_amt)),0) amt12,"+
				" count(decode(a.acct_code,  '00013',a.buy_id)) cnt13,"+
				" nvl(sum(decode(a.acct_code,'00013',a.buy_amt)),0) amt13,"+
				" count(decode(a.acct_code,  '00014',a.buy_id)) cnt14,"+
				" nvl(sum(decode(a.acct_code,'00014',a.buy_amt)),0) amt14,"+
				" count(decode(a.acct_code,  '00015',a.buy_id)) cnt15,"+
				" nvl(sum(decode(a.acct_code,'00015',a.buy_amt)),0) amt15,"+
				" count(decode(a.acct_code,  '00016',a.buy_id)) cnt16,"+
				" nvl(sum(decode(a.acct_code,'00016',a.buy_amt)),0) amt16,"+
				" count(decode(a.acct_code,  '00017',a.buy_id)) cnt17,"+
				" nvl(sum(decode(a.acct_code,'00017',a.buy_amt)),0) amt17"+
				" from card_doc a, card d, card_user e, users b"+
				" where a.cardno=d.cardno and d.cardno=e.cardno(+) and d.user_seq=e.seq(+) and e.user_id=b.user_id(+)";

		//기간조회
		if(chk1.equals("1"))		query += " and a.buy_dt=to_char(sysdate,'YYYYMMDD')";
		if(chk1.equals("2"))		query += " and a.buy_dt like to_char(sysdate,'YYYYMM')||'%'";
		if(chk1.equals("3")){
			if(!st_dt.equals("") && !end_dt.equals(""))		query += " and a.buy_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";
			if(!st_dt.equals("") && end_dt.equals(""))		query += " and a.buy_dt = replace('"+st_dt+"','-','')";
		}
		//영업소
		if(!s_br.equals(""))		query += " and b.br_id = '"+s_br+"'";
		//부서
		if(!gubun3.equals(""))		query += " and b.dept_id = '"+gubun3+"'";

		//카드
		if(!gubun5.equals(""))		query += " and a.cardno = '"+gubun5+"'";

		query += " group by a.cardno, b.dept_id "+
				 " order by b.dept_id , nvl(sum(a.buy_amt),0) desc";

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
			System.out.println("[CardDatabase:getCardUseAcctUStat]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}


	/**
	 *	카드사용현황-카드사별
	 */	
	public Vector getCardUseComStat(String s_br, String chk1, String chk2, String chk3, String chk4, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String st_dt, String end_dt, String s_kd, String t_wd1, String t_wd2, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";

		query = " select"+
				" d.com_name, min(d.com_code) com_code,"+
				" count(a.buy_id) cnt0,"+//--합계
				" nvl(sum(a.buy_amt),0) amt0,"+
				" count(decode(b.dept_id,'0001',a.buy_id)) cnt1,"+//--영업팀
				" nvl(sum(decode(b.dept_id,'0001',a.buy_amt)),0) amt1,"+
				" count(decode(b.dept_id,'0002',a.buy_id)) cnt2,"+//--관리팀
				" nvl(sum(decode(b.dept_id,'0002',a.buy_amt)),0) amt2,"+
				" count(decode(b.dept_id,'0003',a.buy_id)) cnt3,"+//--총무팀
				" nvl(sum(decode(b.dept_id,'0003',a.buy_amt)),0) amt3,"+
				" count(decode(b.dept_id,'0004',a.buy_id)) cnt4,"+//--임원
				" nvl(sum(decode(b.dept_id,'0004',a.buy_amt)),0) amt4"+
				" from card_doc a, users b, (select * from code where c_st='0002') c, card d"+
				" where a.buy_user_id=b.user_id and b.dept_id=c.code and a.cardno=d.cardno";

		//기간조회
		if(chk1.equals("1"))		query += " and a.buy_dt=to_char(sysdate,'YYYYMMDD')";
		if(chk1.equals("2"))		query += " and a.buy_dt like to_char(sysdate,'YYYYMM')||'%'";
		if(chk1.equals("3")){
			if(!st_dt.equals("") && !end_dt.equals(""))		query += " and a.buy_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";
			if(!st_dt.equals("") && end_dt.equals(""))		query += " and a.buy_dt = replace('"+st_dt+"','-','')";
		}
		//영업소
		if(!s_br.equals(""))		query += " and b.br_id = '"+s_br+"'";
		//부서
		if(!gubun3.equals(""))		query += " and b.dept_id = '"+gubun3+"'";

		query += " group by d.com_name"+
				 " order by nvl(sum(a.buy_amt),0) desc";

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
			System.out.println("[CardDatabase:getCardUseComStat]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 *	카드사용현황-카드사별_월간
	 */	
	public Vector getCardUseComMStat(String s_br, String chk1, String chk2, String chk3, String chk4, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String st_dt, String end_dt, String s_kd, String t_wd1, String t_wd2, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";
		int size = 0;
		int idx = 0;
		String  com_name[] = new String[20];

		try {

			query1 = "select com_name from card where com_name is not null group by com_name";
			pstmt1 = conn.prepareStatement(query1);
			rs1 = pstmt1.executeQuery();

			while(rs1.next())
			{				
				com_name[idx] = rs1.getString(1);
				idx++;
			}
			rs1.close();
			pstmt1.close();

		query = " select"+
				" a.buy_dt,"+
				" count(a.buy_id) cnt0,"+//--소계
				" nvl(sum(a.buy_amt),0) amt0,";

			for(int i = 0 ; i < idx ; i++){
				if(i+1 == idx){
					query += " count(decode(d.com_name,'"+com_name[i]+"',a.buy_id)) cnt"+(i+1)+","+
							 " nvl(sum(decode(d.com_name,'"+com_name[i]+"',a.buy_amt)),0) amt"+(i+1)+"";
				}else{
					query += " count(decode(d.com_name,'"+com_name[i]+"',a.buy_id)) cnt"+(i+1)+","+
							 " nvl(sum(decode(d.com_name,'"+com_name[i]+"',a.buy_amt)),0) amt"+(i+1)+",";
				}
			}

		query += " from card_doc a, users b, (select * from code where c_st='0002') c, card d"+
				" where a.buy_user_id=b.user_id and b.dept_id=c.code and a.cardno=d.cardno";

		//기간조회
		if(chk1.equals("1"))		query += " and a.buy_dt=to_char(sysdate,'YYYYMMDD')";
		if(chk1.equals("2"))		query += " and a.buy_dt like to_char(sysdate,'YYYYMM')||'%'";
		if(chk1.equals("3")){
			if(!st_dt.equals("") && !end_dt.equals(""))		query += " and a.buy_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";
			if(!st_dt.equals("") && end_dt.equals(""))		query += " and a.buy_dt = replace('"+st_dt+"','-','')";
		}
		//영업소
		if(!s_br.equals(""))		query += " and b.br_id = '"+s_br+"'";
		//부서
		if(!gubun3.equals(""))		query += " and b.dept_id = '"+gubun3+"'";

		query += " group by a.buy_dt"+
				 " order by a.buy_dt";

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
			System.out.println("[CardDatabase:getCardUseComMStat]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( rs1 != null )		rs1.close();
				if ( pstmt != null )	pstmt.close();
				if ( pstmt1 != null )	pstmt1.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 *	카드사용현황-카드사별_월간_카드사
	 */	
	public Vector getCardUseComMStatCD(String s_br, String chk1, String chk2, String chk3, String chk4, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String st_dt, String end_dt, String s_kd, String t_wd1, String t_wd2, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";

		query = "select com_name from card where com_name is not null group by com_name";

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
			System.out.println("[CardDatabase:getCardUseComMStatCD]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 *	카드사용현황-카드별
	 */	
	public Vector getCardUseCardStat(String s_br, String chk1, String chk2, String chk3, String chk4, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String gubun7, String st_dt, String end_dt, String s_kd, String t_wd1, String t_wd2, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";
		String t_date1 = "a.buy_dt, to_char(sysdate,'YYYYMMDD')";
		String t_date2 = "a.buy_dt, to_char(sysdate-1,'YYYYMMDD')";
		String t_date3 = "a.buy_dt, to_char(sysdate-2,'YYYYMMDD')";
		String t_date4 = "substr(a.buy_dt,1,6), to_char(sysdate,'YYYYMM')";
		String t_date5 = "substr(a.buy_dt,1,6), to_char(add_months(sysdate,-1),'YYYYMM')";
		String t_date6 = "substr(a.buy_dt,1,6), to_char(add_months(sysdate,-2),'YYYYMM')";

		String s_date1 = "", s_date2 = "", s_date3 = "";

		if(chk1.equals("1")){
			s_date1 = t_date1;
			s_date2 = t_date2;
			s_date3 = t_date3;
		}else{
			s_date1 = t_date4;
			s_date2 = t_date5;
			s_date3 = t_date6;
		}

		query = " select"+
				" a.cardno, min(d.card_kind) card_kind, "+
				" nvl(min(b.user_nm),decode(min(d.card_st),'2','공용','미지정')) user_nm, "+
				" nvl(min(c.nm),'총무부') dept_nm, "+
				" nvl(min(e.br_nm),'본사') br_nm,"+
				" to_char(sysdate,'YYYYMMDD') t1, to_char(sysdate-1,'YYYYMMDD') t2, to_char(sysdate-2,'YYYYMMDD') t3,"+
				" to_char(sysdate,'YYYYMM') t4, to_char(add_months(sysdate,-1),'YYYYMM') t5, to_char(add_months(sysdate,-2),'YYYYMM') t6,"+
				" count(a.buy_id) cnt0,"+//--합계
				" nvl(sum(a.buy_amt),0) amt0,"+
				" count(decode(  "+s_date1+", a.buy_id)) cnt1,"+//--당일
				" nvl(sum(decode("+s_date1+", a.buy_amt)),0) amt1,"+
				" count(decode(  "+s_date2+", a.buy_id)) cnt2,"+//--전일
				" nvl(sum(decode("+s_date2+", a.buy_amt)),0) amt2,"+
				" count(decode(  "+s_date3+", a.buy_id)) cnt3,"+//--전전일
				" nvl(sum(decode("+s_date3+", a.buy_amt)),0) amt3"+
				" from card_doc a, users b, (select * from code where c_st='0002') c, card d, branch e, (select cardno, max(seq) seq from card_user group by cardno) f, card_user g"+
				" where a.cardno=d.cardno and d.cardno=f.cardno(+) and f.cardno=g.cardno(+) and f.seq=g.seq(+) and g.user_id=b.user_id(+) and b.dept_id=c.code(+) and b.br_id=e.br_id(+)";

		//카드종류
		if(!gubun2.equals(""))		query += " and d.card_kind = '"+gubun2+"'";

		//기간조회
		if(chk1.equals("1"))		query += " and a.buy_dt between to_char(sysdate-2,'YYYYMMDD') and to_char(sysdate,'YYYYMMDD')";
		if(chk1.equals("2"))		query += " and substr(a.buy_dt,1,6) between to_char(add_months(sysdate,-2),'YYYYMM') and to_char(sysdate,'YYYYMM')";
		if(chk1.equals("3")){
			if(!st_dt.equals("") && !end_dt.equals(""))		query += " and a.buy_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";
			if(!st_dt.equals("") && end_dt.equals(""))		query += " and a.buy_dt = replace('"+st_dt+"','-','')";
		}
		//영업소
		if(!s_br.equals(""))		query += " and b.br_id = '"+s_br+"'";
		//부서
		if(!gubun3.equals(""))		query += " and b.dept_id = '"+gubun3+"'";
		//소유자
		if(!gubun7.equals(""))		query += " and b.user_id = '"+gubun7+"'";

	
		if(sort.equals("1")){//소유자
			query += " group by a.cardno"+
					 " order by decode(nvl(min(e.br_nm),'본사'),'본사',1,'부산지점',2,'대전지점',3), decode(nvl(min(c.nm),'총무부'),'영업팀',1,'고객지원팀',2,'총무팀',3,4), nvl(sum(a.buy_amt),0) desc";
		}else if(sort.equals("2")){//카드번호
			query += " group by a.cardno"+
					 " order by a.cardno";
		}else{
			query += " group by a.cardno"+
					 " order by decode(nvl(min(e.br_nm),'본사'),'본사',1,'부산지점',2,'대전지점',3), decode(nvl(min(c.nm),'총무부'),'영업팀',1,'고객지원팀',2,'총무팀',3,4), nvl(sum(a.buy_amt),0) desc";
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
			System.out.println("[CardDatabase:getCardUseCardStat]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 *	카드사용대금결제현황-결제일자별
	 */	
	public Vector getCardPayDtStat(String s_br, String chk1, String chk2, String chk3, String chk4, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String st_dt, String end_dt, String s_kd, String t_wd1, String t_wd2, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";

		query = " select"+
				" a.pay_day,"+
				" decode(min(a.limit_st),'1',sum(a.limit_st),'2',min(a.limit_amt)) limit_amt,"+
				" min(a.pay_est_dt1) pay_est_dt1, min(a.use_s_dt1) use_s_dt1, min(a.use_e_dt1) use_e_dt1, nvl(sum(b.buy_cnt1),0) buy_cnt1, sum(b.buy_amt1) buy_amt1,"+
				" min(a.pay_est_dt2) pay_est_dt2, min(a.use_s_dt2) use_s_dt2, min(a.use_e_dt2) use_e_dt2, nvl(sum(c.buy_cnt2),0) buy_cnt2, sum(c.buy_amt2) buy_amt2,"+
				" min(a.pay_est_dt3) pay_est_dt3, min(a.use_s_dt3) use_s_dt3, min(a.use_e_dt3) use_e_dt3, nvl(sum(d.buy_cnt3),0) buy_cnt3, sum(d.buy_amt3) buy_amt3"+
				" from"+
				" ("+
				"         select cardno, card_kind, com_name, limit_st, limit_amt, pay_day,"+
				"         to_char(add_months(sysdate,0),'YYYYMM')||pay_day pay_est_dt1,"+
				"         to_char(add_months(sysdate,to_number(use_s_m)),'YYYYMM')||decode(length(use_s_day),1,'0'||use_s_day,use_s_day) use_s_dt1,"+
				"         to_char(add_months(sysdate,to_number(use_e_m)),'YYYYMM')||decode(length(use_e_day),1,decode(use_e_day,'말',to_char(last_day(add_months(sysdate,to_number(use_e_m))),'DD'),'0'||use_e_day),use_e_day) use_e_dt1,"+
				"         to_char(add_months(sysdate,1),'YYYYMM')||pay_day pay_est_dt2,"+
				"         to_char(add_months(sysdate,to_number(use_s_m)+1),'YYYYMM')||decode(length(use_s_day),1,'0'||use_s_day,use_s_day) use_s_dt2,"+
				"         to_char(add_months(sysdate,to_number(use_e_m)+1),'YYYYMM')||decode(length(use_e_day),1,decode(use_e_day,'말',to_char(last_day(add_months(sysdate,to_number(use_e_m)+1)),'DD'),'0'||use_e_day),use_e_day) use_e_dt2,"+
				"         to_char(add_months(sysdate,2),'YYYYMM')||pay_day pay_est_dt3,"+
				"         to_char(add_months(sysdate,to_number(use_s_m)+2),'YYYYMM')||decode(length(use_s_day),1,'0'||use_s_day,use_s_day) use_s_dt3,"+
				"         to_char(add_months(sysdate,to_number(use_e_m)+2),'YYYYMM')||decode(length(use_e_day),1,decode(use_e_day,'말',to_char(last_day(add_months(sysdate,to_number(use_e_m)+2)),'DD'),'0'||use_e_day),use_e_day) use_e_dt3"+
				"         from card"+
				"         where use_yn='Y'"+
				"         and use_s_day is not null"+
				" ) a,"+
				" 	( select a.cardno, min(a.pay_est_dt) pay_est_dt1, min(a.use_s_dt) use_s_dt1, min(a.use_e_dt) use_e_dt1, sum(b.buy_amt) buy_amt1, count(b.buy_id) buy_cnt1"+
				"       from"+
				" 		("+
				" 			select cardno,"+
				"             to_char(add_months(sysdate,0),'YYYYMM')||pay_day pay_est_dt,"+
				"             to_char(add_months(sysdate,to_number(use_s_m)),'YYYYMM')||decode(length(use_s_day),1,'0'||use_s_day,use_s_day) use_s_dt,"+
				"             to_char(add_months(sysdate,to_number(use_e_m)),'YYYYMM')||decode(length(use_e_day),1,decode(use_e_day,'말',to_char(last_day(add_months(sysdate,to_number(use_e_m))),'DD'),'0'||use_e_day),use_e_day) use_e_dt"+
				"             from card"+
				"             where use_yn='Y' and use_s_day is not null"+
				" 		) a, card_doc b"+
				"       where a.cardno=b.cardno(+) and b.buy_dt between a.use_s_dt and a.use_e_dt"+
				"       group by a.cardno"+
				" 	) b,"+
				" 	( select a.cardno, min(a.pay_est_dt) pay_est_dt2, min(a.use_s_dt) use_s_dt2, min(a.use_e_dt) use_e_dt2, sum(b.buy_amt) buy_amt2, count(b.buy_id) buy_cnt2"+
				"       from"+
				" 		("+
				" 			select cardno,"+
				" 		        to_char(add_months(sysdate,1),'YYYYMM')||pay_day pay_est_dt,"+
				"             to_char(add_months(sysdate,to_number(use_s_m)+1),'YYYYMM')||decode(length(use_s_day),1,'0'||use_s_day,use_s_day) use_s_dt,"+
				"             to_char(add_months(sysdate,to_number(use_e_m)+1),'YYYYMM')||decode(length(use_e_day),1,decode(use_e_day,'말',to_char(last_day(add_months(sysdate,to_number(use_e_m)+1)),'DD'),'0'||use_e_day),use_e_day) use_e_dt"+
				"             from card"+
				"             where use_yn='Y' and use_s_day is not null"+
				" 		) a, card_doc b"+
				"       where a.cardno=b.cardno(+) and b.buy_dt between a.use_s_dt and a.use_e_dt"+
				"       group by a.cardno"+
				" 	) c,"+
				" 	( select a.cardno, min(a.pay_est_dt) pay_est_dt3, min(a.use_s_dt) use_s_dt3, min(a.use_e_dt) use_e_dt3, sum(b.buy_amt) buy_amt3, count(b.buy_id) buy_cnt3"+
				"       from"+
				" 		("+
				" 			select cardno,"+
				" 		        to_char(add_months(sysdate,2),'YYYYMM')||pay_day pay_est_dt,"+
				"             to_char(add_months(sysdate,to_number(use_s_m)+2),'YYYYMM')||decode(length(use_s_day),1,'0'||use_s_day,use_s_day) use_s_dt,"+
				"             to_char(add_months(sysdate,to_number(use_e_m)+2),'YYYYMM')||decode(length(use_e_day),1,decode(use_e_day,'말',to_char(last_day(add_months(sysdate,to_number(use_e_m)+2)),'DD'),'0'||use_e_day),use_e_day) use_e_dt"+
				"             from card"+
				"             where use_yn='Y' and use_s_day is not null"+
				" 		) a, card_doc b"+
				"       where a.cardno=b.cardno(+) and b.buy_dt between a.use_s_dt and a.use_e_dt"+
				"       group by a.cardno"+
				" 	) d"+
				" where a.cardno=b.cardno(+) and a.cardno=c.cardno(+) and a.cardno=d.cardno(+)"+
				" group by a.pay_day";


		query += " order by a.pay_day";

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
			System.out.println("[CardDatabase:getCardPayDtStat]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 *	카드사용대금결제현황-결제일자별
	 */	
	public Vector getCardPayStat(String s_br, String chk1, String chk2, String chk3, String chk4, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String st_dt, String end_dt, String s_kd, String t_wd1, String t_wd2, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";

		query = " select"+
				" a.com_name,"+
				" decode(min(a.limit_st),'1',sum(a.limit_st),'2',min(a.limit_amt)) limit_amt,"+
				" min(a.pay_est_dt1) pay_est_dt1, min(a.use_s_dt1) use_s_dt1, min(a.use_e_dt1) use_e_dt1, sum(b.buy_cnt1) buy_cnt1, sum(b.buy_amt1) buy_amt1,"+
				" min(a.pay_est_dt2) pay_est_dt2, min(a.use_s_dt2) use_s_dt2, min(a.use_e_dt2) use_e_dt2, sum(c.buy_cnt2) buy_cnt2, sum(c.buy_amt2) buy_amt2,"+
				" min(a.pay_est_dt3) pay_est_dt3, min(a.use_s_dt3) use_s_dt3, min(a.use_e_dt3) use_e_dt3, sum(d.buy_cnt3) buy_cnt3, sum(d.buy_amt3) buy_amt3"+
				" from"+
				" ("+
				"         select cardno, card_kind, com_name, limit_st, limit_amt, pay_day,"+
				"         to_char(add_months(sysdate,0),'YYYYMM')||pay_day pay_est_dt1,"+
				"         to_char(add_months(sysdate,to_number(use_s_m)),'YYYYMM')||decode(length(use_s_day),1,'0'||use_s_day,use_s_day) use_s_dt1,"+
				"         to_char(add_months(sysdate,to_number(use_e_m)),'YYYYMM')||decode(length(use_e_day),1,decode(use_e_day,'말',to_char(last_day(add_months(sysdate,to_number(use_e_m))),'DD'),'0'||use_e_day),use_e_day) use_e_dt1,"+
				"         to_char(add_months(sysdate,1),'YYYYMM')||pay_day pay_est_dt2,"+
				"         to_char(add_months(sysdate,to_number(use_s_m)+1),'YYYYMM')||decode(length(use_s_day),1,'0'||use_s_day,use_s_day) use_s_dt2,"+
				"         to_char(add_months(sysdate,to_number(use_e_m)+1),'YYYYMM')||decode(length(use_e_day),1,decode(use_e_day,'말',to_char(last_day(add_months(sysdate,to_number(use_e_m)+1)),'DD'),'0'||use_e_day),use_e_day) use_e_dt2,"+
				"         to_char(add_months(sysdate,2),'YYYYMM')||pay_day pay_est_dt3,"+
				"         to_char(add_months(sysdate,to_number(use_s_m)+2),'YYYYMM')||decode(length(use_s_day),1,'0'||use_s_day,use_s_day) use_s_dt3,"+
				"         to_char(add_months(sysdate,to_number(use_e_m)+2),'YYYYMM')||decode(length(use_e_day),1,decode(use_e_day,'말',to_char(last_day(add_months(sysdate,to_number(use_e_m)+2)),'DD'),'0'||use_e_day),use_e_day) use_e_dt3"+
				"         from card"+
				"         where use_yn='Y'"+
				"         and use_s_day is not null"+
				" ) a,"+
				" 	( select a.cardno, min(a.pay_est_dt) pay_est_dt1, min(a.use_s_dt) use_s_dt1, min(a.use_e_dt) use_e_dt1, sum(b.buy_amt) buy_amt1, count(b.buy_id) buy_cnt1"+
				"       from"+
				" 		("+
				" 			select cardno,"+
				"             to_char(add_months(sysdate,0),'YYYYMM')||pay_day pay_est_dt,"+
				"             to_char(add_months(sysdate,to_number(use_s_m)),'YYYYMM')||decode(length(use_s_day),1,'0'||use_s_day,use_s_day) use_s_dt,"+
				"             to_char(add_months(sysdate,to_number(use_e_m)),'YYYYMM')||decode(length(use_e_day),1,decode(use_e_day,'말',to_char(last_day(add_months(sysdate,to_number(use_e_m))),'DD'),'0'||use_e_day),use_e_day) use_e_dt"+
				"             from card"+
				"             where use_yn='Y' and use_s_day is not null"+
				" 		) a, card_doc b"+
				"       where a.cardno=b.cardno(+) and b.buy_dt between a.use_s_dt and a.use_e_dt"+
				"       group by a.cardno"+
				" 	) b,"+
				" 	( select a.cardno, min(a.pay_est_dt) pay_est_dt2, min(a.use_s_dt) use_s_dt2, min(a.use_e_dt) use_e_dt2, sum(b.buy_amt) buy_amt2, count(b.buy_id) buy_cnt2"+
				"       from"+
				" 		("+
				" 			select cardno,"+
				" 		        to_char(add_months(sysdate,1),'YYYYMM')||pay_day pay_est_dt,"+
				"             to_char(add_months(sysdate,to_number(use_s_m)+1),'YYYYMM')||decode(length(use_s_day),1,'0'||use_s_day,use_s_day) use_s_dt,"+
				"             to_char(add_months(sysdate,to_number(use_e_m)+1),'YYYYMM')||decode(length(use_e_day),1,decode(use_e_day,'말',to_char(last_day(add_months(sysdate,to_number(use_e_m)+1)),'DD'),'0'||use_e_day),use_e_day) use_e_dt"+
				"             from card"+
				"             where use_yn='Y' and use_s_day is not null"+
				" 		) a, card_doc b"+
				"       where a.cardno=b.cardno(+) and b.buy_dt between a.use_s_dt and a.use_e_dt"+
				"       group by a.cardno"+
				" 	) c,"+
				" 	( select a.cardno, min(a.pay_est_dt) pay_est_dt3, min(a.use_s_dt) use_s_dt3, min(a.use_e_dt) use_e_dt3, sum(b.buy_amt) buy_amt3, count(b.buy_id) buy_cnt3"+
				"       from"+
				" 		("+
				" 			select cardno,"+
				" 		        to_char(add_months(sysdate,2),'YYYYMM')||pay_day pay_est_dt,"+
				"             to_char(add_months(sysdate,to_number(use_s_m)+2),'YYYYMM')||decode(length(use_s_day),1,'0'||use_s_day,use_s_day) use_s_dt,"+
				"             to_char(add_months(sysdate,to_number(use_e_m)+2),'YYYYMM')||decode(length(use_e_day),1,decode(use_e_day,'말',to_char(last_day(add_months(sysdate,to_number(use_e_m)+2)),'DD'),'0'||use_e_day),use_e_day) use_e_dt"+
				"             from card"+
				"             where use_yn='Y' and use_s_day is not null"+
				" 		) a, card_doc b"+
				"       where a.cardno=b.cardno(+) and b.buy_dt between a.use_s_dt and a.use_e_dt"+
				"       group by a.cardno"+
				" 	) d"+
				" where a.cardno=b.cardno(+) and a.cardno=c.cardno(+) and a.cardno=d.cardno(+)";

		if(!gubun5.equals(""))	query += " and a.pay_day='"+gubun5+"'";

		query += " group by a.com_name";
		query += " order by a.com_name desc";

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
			System.out.println("[CardDatabase:getCardPayStat]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 *	카드사정보
	 */	
	public Hashtable getCardKind(String card_kind)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "", query1 = "", query2 = "";

		query = "select min(card_kind) card_kind, min(com_name) com_name, count(0) card_cnt from card where card_kind='"+card_kind+"' and use_yn='Y'";

		try {
			pstmt = conn.prepareStatement(query);
		    rs = pstmt.executeQuery();
	    	ResultSetMetaData rsmd = rs.getMetaData();
    	
			if(rs.next())
			{				
				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CardDatabase:getCardKind]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}		
	}

	/**
	 *	카드사용한도관리-카드별한도
	 */	
	public Vector getCardKindPayStat(String s_br, String chk1, String chk2, String chk3, String chk4, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String st_dt, String end_dt, String s_kd, String t_wd1, String t_wd2, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";

		query = " select"+
				" a.*,"+
				" decode(nvl(b.buy_amt1,0), 0, decode(nvl(c.buy_amt2,0), 0, d.buy_amt3, c.buy_amt2), b.buy_amt1) buy_amt"+
				" from"+
				" ("+
				"         select cardno, decode(card_st,'1','구매자금용','2','공용','3','임/직원지급용','4','하이패스','5','세금납부용','6','포인트') card_st, card_kind, card_name, com_name, limit_st, limit_amt, pay_day,"+
				"         to_char(add_months(sysdate,0),'YYYYMM')||pay_day pay_est_dt1,"+
				"         to_char(add_months(sysdate,to_number(use_s_m)),'YYYYMM')||decode(length(use_s_day),1,'0'||use_s_day,use_s_day) use_s_dt1,"+
				"         to_char(add_months(sysdate,to_number(use_e_m)),'YYYYMM')||decode(length(use_e_day),1,decode(use_e_day,'말',to_char(last_day(add_months(sysdate,to_number(use_e_m))),'DD'),'0'||use_e_day),use_e_day) use_e_dt1,"+
				"         to_char(add_months(sysdate,1),'YYYYMM')||pay_day pay_est_dt2,"+
				"         to_char(add_months(sysdate,to_number(use_s_m)+1),'YYYYMM')||decode(length(use_s_day),1,'0'||use_s_day,use_s_day) use_s_dt2,"+
				"         to_char(add_months(sysdate,to_number(use_e_m)+1),'YYYYMM')||decode(length(use_e_day),1,decode(use_e_day,'말',to_char(last_day(add_months(sysdate,to_number(use_e_m)+1)),'DD'),'0'||use_e_day),use_e_day) use_e_dt2,"+
				"         to_char(add_months(sysdate,2),'YYYYMM')||pay_day pay_est_dt3,"+
				"         to_char(add_months(sysdate,to_number(use_s_m)+2),'YYYYMM')||decode(length(use_s_day),1,'0'||use_s_day,use_s_day) use_s_dt3,"+
				"         to_char(add_months(sysdate,to_number(use_e_m)+2),'YYYYMM')||decode(length(use_e_day),1,decode(use_e_day,'말',to_char(last_day(add_months(sysdate,to_number(use_e_m)+2)),'DD'),'0'||use_e_day),use_e_day) use_e_dt3"+
				"         from card"+
				"         where use_yn='Y' and card_kind='"+gubun2+"'"+
				"         and use_s_day is not null"+
				" ) a,"+
				" 	( select a.cardno, min(a.pay_est_dt) pay_est_dt1, min(a.use_s_dt) use_s_dt1, min(a.use_e_dt) use_e_dt1, sum(b.buy_amt) buy_amt1, count(b.buy_id) buy_cnt1"+
				"       from"+
				" 		("+
				" 			select cardno,"+
				"             to_char(add_months(sysdate,0),'YYYYMM')||pay_day pay_est_dt,"+
				"             to_char(add_months(sysdate,to_number(use_s_m)),'YYYYMM')||decode(length(use_s_day),1,'0'||use_s_day,use_s_day) use_s_dt,"+
				"             to_char(add_months(sysdate,to_number(use_e_m)),'YYYYMM')||decode(length(use_e_day),1,decode(use_e_day,'말',to_char(last_day(add_months(sysdate,to_number(use_e_m))),'DD'),'0'||use_e_day),use_e_day) use_e_dt"+
				"             from card"+
				"             where use_yn='Y' and use_s_day is not null"+
				" 		) a, card_doc b"+
				"       where a.cardno=b.cardno(+) and b.buy_dt between a.use_s_dt and a.use_e_dt and to_char(sysdate,'YYYYMMDD') between a.use_s_dt and a.use_e_dt "+
				"       group by a.cardno"+
				" 	) b,"+
				" 	( select a.cardno, min(a.pay_est_dt) pay_est_dt2, min(a.use_s_dt) use_s_dt2, min(a.use_e_dt) use_e_dt2, sum(b.buy_amt) buy_amt2, count(b.buy_id) buy_cnt2"+
				"       from"+
				" 		("+
				" 			select cardno,"+
				" 		        to_char(add_months(sysdate,1),'YYYYMM')||pay_day pay_est_dt,"+
				"             to_char(add_months(sysdate,to_number(use_s_m)+1),'YYYYMM')||decode(length(use_s_day),1,'0'||use_s_day,use_s_day) use_s_dt,"+
				"             to_char(add_months(sysdate,to_number(use_e_m)+1),'YYYYMM')||decode(length(use_e_day),1,decode(use_e_day,'말',to_char(last_day(add_months(sysdate,to_number(use_e_m)+1)),'DD'),'0'||use_e_day),use_e_day) use_e_dt"+
				"             from card"+
				"             where use_yn='Y' and use_s_day is not null"+
				" 		) a, card_doc b"+
				"       where a.cardno=b.cardno(+) and b.buy_dt between a.use_s_dt and a.use_e_dt and to_char(sysdate,'YYYYMMDD') between a.use_s_dt and a.use_e_dt"+
				"       group by a.cardno"+
				" 	) c,"+
				" 	( select a.cardno, min(a.pay_est_dt) pay_est_dt3, min(a.use_s_dt) use_s_dt3, min(a.use_e_dt) use_e_dt3, sum(b.buy_amt) buy_amt3, count(b.buy_id) buy_cnt3"+
				"       from"+
				" 		("+
				" 			select cardno,"+
				" 		        to_char(add_months(sysdate,2),'YYYYMM')||pay_day pay_est_dt,"+
				"             to_char(add_months(sysdate,to_number(use_s_m)+2),'YYYYMM')||decode(length(use_s_day),1,'0'||use_s_day,use_s_day) use_s_dt,"+
				"             to_char(add_months(sysdate,to_number(use_e_m)+2),'YYYYMM')||decode(length(use_e_day),1,decode(use_e_day,'말',to_char(last_day(add_months(sysdate,to_number(use_e_m)+2)),'DD'),'0'||use_e_day),use_e_day) use_e_dt"+
				"             from card"+
				"             where use_yn='Y' and use_s_day is not null"+
				" 		) a, card_doc b"+
				"       where a.cardno=b.cardno(+) and b.buy_dt between a.use_s_dt and a.use_e_dt and to_char(sysdate,'YYYYMMDD') between a.use_s_dt and a.use_e_dt"+
				"       group by a.cardno"+
				" 	) d"+
				" where a.cardno=b.cardno(+) and a.cardno=c.cardno(+) and a.cardno=d.cardno(+)";

		query += " order by a.card_st, a.cardno desc";

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
			System.out.println("[CardDatabase:getCardKindPayStat]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 *	카드 결제일자 리스트
	 */	
	public Vector getCardPayDays(String s_br, String use_yn)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select pay_day from card";

		if(!use_yn.equals(""))		query += " where use_yn='"+use_yn+"'";

		query += " group by pay_day ";

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
			System.out.println("[CardDatabase:getCardPayDays]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	//카드전표사용자 한건 등록
	public boolean insertCardDocUser(CardDocUserBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " INSERT INTO card_doc_user ("+
				"	cardno,		"+
				"	buy_id,		"+
				"	seq,	   	"+
				"	user_st,  	"+
				"	firm_nm,  	"+
				"	doc_user,   "+
				"	doc_amt 	"+
				" ) VALUES"+
				" ( ?, ?, ?, ?, ?, ?, ?)";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getCardno	());
			pstmt.setString	(2,		bean.getBuy_id	());
			pstmt.setString	(3,		bean.getSeq		());
			pstmt.setString	(4,		bean.getUser_st ());
			pstmt.setString	(5,		bean.getFirm_nm ());
			pstmt.setString	(6,		bean.getDoc_user());
			pstmt.setInt	(7,		bean.getDoc_amt	());
			pstmt.executeUpdate();
			pstmt.close();
			
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[CardDatabase:insertCardDocUser(CardDocUserBean bean)]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	/**
	 *	전표 참가자 리스트
	 */	
	public Vector getCardDocUserList(String cardno, String buy_id, String user_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";

		query = " select "+
				" b.*, nvl(c.user_nm,b.doc_user) user_nm, c.dept_id"+
				" from card_doc a, card_doc_user b, users c"+
				" where a.cardno=b.cardno and a.buy_id=b.buy_id"+
				" and b.doc_user=c.user_id(+)";

		if(!cardno.equals(""))		query += " and b.cardno = '"+cardno+"'";
		if(!buy_id.equals(""))		query += " and b.buy_id = '"+buy_id+"'";
		if(!user_st.equals(""))		query += " and b.user_st = '"+user_st+"'";

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
			System.out.println("[CardDatabase:getCardDocUserList]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	//카드전표사용자 한건 등록
	public boolean deleteCardDocUser(String cardno, String buy_id)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " DELETE from card_doc_user where cardno=? and buy_id=?";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		cardno);
			pstmt.setString	(2,		buy_id);
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[CardDatabase:deleteCardDocUser(CardDocUserBean bean)]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	public Vector getCardJungDtStat(String dt, String ref_dt1, String ref_dt2, String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		String f_date1="";
		String t_date1="";
	
		String s_year = Integer.toString(AddUtil.getDate2(1));	
		String s_month =Integer.toString(AddUtil.getDate2(2));	
		s_month = AddUtil.addZero(s_month);
		
		if(dt.equals("2")) {
			f_date1 = s_year+ s_month + "01";
			t_date1 = s_year+ s_month + "31";
		}
		
		if(dt.equals("4")) {
			f_date1=  ref_dt1;
			t_date1=  ref_dt2;
		}

		query = "	select  a.user_id, a.jung_dt, decode(a.remark , 'W', '근무일', 'H', '공휴일', 'T', '토요일', 'S', '일요일', 'M', '기타' , 'N', ' ' ) as  remark_desc,  sum(a.w_cnt) as w_cnt, sum(a.basic_amt) as basic_amt, sum(a.real_amt) as real_amt, sum(a.remain_amt) as remain_amt , sum(a.g2_1_amt) as g2_1_amt, sum(a.g2_3_amt) as g2_3_amt, sum(a.g3_amt) as g3_amt, sum(a.g2_amt) as g2_amt " +
				"	from (		" +		
				"		select   u.user_id, u.jung_dt, a.remark, a.w_cnt, a.basic_amt, a.real_amt, a.remain_amt, b.g2_1_amt, c.g2_3_amt , d.g3_amt, e.g2_amt from  card_doc_jungsan u ,  	" +			
				"			 ( select   a.user_id,  a.jung_dt, a.remark, sum(decode(a.remark, 'W', 1, 0)) as w_cnt, sum(a.basic_amt) as basic_amt, sum(a.real_amt) as real_amt, sum(a.remain_amt) as remain_amt " +
				"					         from card_doc_jungsan a        where a.jung_dt  between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','')  group by a.user_id, a.jung_dt, a.remark ) a, " +
				"			 ( select  b.doc_user, a.buy_dt,  sum(b.doc_amt)  as g2_1_amt  from card_doc a, card_doc_user  b where a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and a.acct_code = '00001' and a.acct_code_g = '1' and a.acct_code_g2 = '1'  and   " +
				"				      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user, a.buy_dt ) b , " +
				"			 ( select  b.doc_user, a.buy_dt, sum(b.doc_amt)  as g2_3_amt from card_doc a, card_doc_user  b	where a.buy_dt  between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','')  and a.acct_code = '00001' and a.acct_code_g = '1' and a.acct_code_g2 = '3'  and   " +
				"				      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user, a.buy_dt ) c, " +
				"			 ( select  b.doc_user, a.buy_dt, sum(b.doc_amt)  as g3_amt from card_doc a, card_doc_user  b	where a.buy_dt  between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','')  and a.acct_code = '00001' and a.acct_code_g = '3' and   " +
				"				      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user, a.buy_dt ) d, " +
				"			 ( select  b.doc_user, a.buy_dt, sum(b.doc_amt)  as g2_amt from card_doc a, card_doc_user  b	where a.buy_dt  between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','')  and a.acct_code = '00001' and a.acct_code_g = '2' and   " +
				"				      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user, a.buy_dt ) e " +
				"		where u.user_id = a.user_id(+) and u.user_id = b.doc_user(+) and u.user_id = c.doc_user(+) and u.user_id = d.doc_user(+) and u.user_id = e.doc_user(+)" +
				"		      and u.jung_dt = a.jung_dt(+) and u.jung_dt = b.buy_dt(+) and u.jung_dt = c.buy_dt(+) and u.jung_dt = d.buy_dt(+)and u.jung_dt = e.buy_dt(+) " +
				"		      and u.jung_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') " +
				"			) a, users u " +
				"	 where a.user_id = u.user_id  and ( u.use_yn = 'Y' or u.out_dt > '" + f_date1 + "' )  " ;
		
		if(!user_id.equals(""))		query += " and a.user_id='"+user_id+"'";
				 
		query += "	group by a.user_id, a.jung_dt, a.remark order by  a.user_id, a.jung_dt ";
	
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
			System.out.println("[CardDatabase:getCardJungDtStat]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}
	
	
//집계
	public Vector getCardJungDtStatI(String dt, String ref_dt1, String ref_dt2, String br_id, String dept_id, String user_nm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
     	
		String f_date1="";
		String t_date1="";
	
		String s_year = Integer.toString(AddUtil.getDate2(1));	
		String s_month =Integer.toString(AddUtil.getDate2(2));	
		s_month = AddUtil.addZero(s_month);
		
		if(dt.equals("2")) {
			f_date1 = s_year+ s_month + "01";
			t_date1 = s_year+ s_month + "31";
		}
		
		if(dt.equals("4")) {
			f_date1=  ref_dt1;
			t_date1=  ref_dt2;
		}
		
	
	query = " select u.use_yn, a.user_id, u.id, u.user_nm,  u.user_pos, u.br_id, decode(u.br_id,'S1','본사','B1','부산지점','D1','대전지점','') as br_nm, decode(u.br_id,'S1','1','B1','2','D1','3','4') as br_sort, " +
				"	    decode(u.user_pos,'대표이사',1,'이사', 2, '팀장', 3, '차장', 4 ,  '과장', 5, '대리', 6, 9) pos_sort, u.dept_id, decode(u.dept_id,'0001','영업팀','0002','고객지원팀','0003','총무팀','0005','채권관리팀','0007','부산지점','0008','대전지점','8888', '아마존카외', '7777', '아르바이트', ' ') as dept_nm,   " +  
				"	    decode(u.dept_id,'0004',1,'0001', 2, '0002', 3, '0003', 4 , '8888', 5, 9) dept_sort, " +  
				" 		sum(a.w_cnt) as w_cnt, sum(a.basic_amt) as basic_amt, sum(a.real_amt) as real_amt, sum(a.remain_amt) as remain_amt , decode(sum(a.remain_amt) , 0, '1', '2') as remain_sort, sum(a.g2_1_amt) as g2_1_amt, sum(a.g2_3_amt) as g2_3_amt, sum(a.g3_amt) as g3_amt, sum(a.g2_amt) as g2_amt,  sum(a.g4_amt) as g4_amt, sum(a.budget_amt) as budget_amt, sum(a.g_2_4_amt) as g_2_4_amt " +
				" from  (  " +		
				"	select u.use_yn,  u.user_id, a.w_cnt, a.basic_amt, f.budget_amt, a.real_amt, a.remain_amt, b.g2_1_amt, c.g2_3_amt, d.g3_amt, e.g2_amt, g.g4_amt, h.g_2_4_amt from  users u ,  " +				
				"		 ( select   a.user_id,  sum(decode(a.remark, 'W', 1, 0)) as w_cnt, sum(a.basic_amt) as basic_amt, sum(a.real_amt) as real_amt, sum(a.remain_amt) as remain_amt " +
				"				         from card_doc_jungsan a       where a.jung_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') group by a.user_id ) a, " +
				"		 ( select  b.doc_user, sum(b.doc_amt)  as g2_1_amt  from card_doc a, card_doc_user  b	where a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and a.acct_code = '00001' and a.acct_code_g = '1' and a.acct_code_g2 = '1'  and  " +
				"			      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user ) b , " +
				"		 ( select  b.doc_user, sum(b.doc_amt)  as g2_3_amt from card_doc a, card_doc_user  b	where a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and a.acct_code = '00001' and a.acct_code_g = '1' and a.acct_code_g2 = '3'  and  " + 
				"			      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user ) c , " +
				"		 ( select  b.doc_user, sum(b.doc_amt)  as g3_amt from card_doc a, card_doc_user  b	where a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and a.acct_code = '00001' and a.acct_code_g = '3' and " + 
				"			      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user ) d , " +
				"		 ( select  b.doc_user, sum(b.doc_amt)  as g2_amt from card_doc a, card_doc_user  b	where a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and a.acct_code = '00001' and a.acct_code_g = '2' and " + 
				"			      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user ) e, " +
				"		 ( select  b.doc_user, sum(b.doc_amt)  as g4_amt from card_doc a, card_doc_user  b	where a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and a.acct_code = '00001' and a.acct_code_g = '4' and " + 
				"			      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user ) g, " +
				"		 ( select  b.doc_user, sum(b.doc_amt)  as g_2_4_amt from card_doc a, card_doc_user  b	where a.buy_dt like substr('" + f_date1 + "',1,4)||'%'  and a.acct_code = '00001' and a.acct_code_g  in ('2', '4') and " + 
				"			      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user ) h, " +
				"		 ( select  a.user_id, sum(a.prv+a.jan+a.feb+a.mar+a.apr+a.may+a.jun+a.jul+a.aug+a.sep+a.oct+a.nov+a.dec)  as budget_amt from budget a where a.byear = substr('" + f_date1 + "',1,4) and a.bgubun = '1' group by a.user_id ) f " +
				"	where u.user_id = a.user_id(+) and u.user_id = b.doc_user(+) and u.user_id = c.doc_user(+) and u.user_id = d.doc_user(+) and u.user_id = e.doc_user(+) and u.user_id = g.doc_user(+) and u.user_id = f.user_id(+) and u.user_id = h.doc_user(+)) a, users u " +
				" where a.user_id = u.user_id   and a.user_id not in ('000037', '000044', '000047' , '000071' , '000081', '000094', '000095', '000103', '000104', '000105','000004','000005','000006' ) and u.dept_id not in ('8888','1000' ) and ( u.use_yn = 'Y' or u.out_dt > replace('" + f_date1 + "','-','')  ) " ;


				
		if(!br_id.equals(""))	query += " and u.br_id='"+br_id+"' ";
		if(!dept_id.equals("")) query += " and u.dept_id='"+dept_id+"' ";
		if(!user_nm.equals("")) query += " and u.user_nm like '%"+user_nm+"%' ";		
						
		query += " group by u.use_yn, a.user_id, u.id, u.user_nm, u.user_pos, u.br_id, u.dept_id, u.bank_nm, u.bank_no ";
		query +="  order by 1 desc, remain_amt desc, decode(u.user_pos,'대표이사',1,'이사',2,'팀장',3,4), decode(u.br_id,'S1',1,'B1',2,'S2',3,4), decode(u.dept_id,'0004','0000',u.dept_id), decode(u.user_pos,'인턴사원','4','사원','3','대리','2','1') ,a.user_id";


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
			System.out.println("[CardDatabase:getCardJungDtStatI]\n"+e);
			System.out.println("[CardDatabase:getCardJungDtStatI]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}


    public Vector getCardJungDtStat(String dt, String ref_dt1, String ref_dt2, String br_id, String dept_id, String user_nm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
     	
		String f_date1="";
		String t_date1="";
	
		String s_year = Integer.toString(AddUtil.getDate2(1));	
		String s_month =Integer.toString(AddUtil.getDate2(2));	
		s_month = AddUtil.addZero(s_month);
		
		if(dt.equals("2")) {
			f_date1 = s_year+ s_month + "01";
			t_date1 = s_year+ s_month + "31";
		}
		
		if(dt.equals("4")) {
			f_date1=  ref_dt1;
			t_date1=  ref_dt2;
		}
		
			query = " select u.use_yn,  a.user_id, u.user_nm,  u.user_pos, u.br_id, decode(u.br_id,'S1','본사','B1','부산지점','D1','대전지점','') as br_nm, decode(u.br_id,'S1','1','B1','2','D1','3','4') as br_sort, " +
				"	    decode(u.user_pos,'대표이사',1,'이사', 2, '팀장', 3, '차장', 4 ,  '과장', 5, '대리', 6, 9 ) pos_sort, u.dept_id, decode(u.dept_id,'0001','영업팀','0002','고객지원팀','0003','총무팀','0007','부산지점','0008','대전지점','8888', '기타', ' ') as dept_nm,    " +  
				" 		sum(a.w_cnt) as w_cnt, sum(a.basic_amt) as basic_amt, sum(a.real_amt) as real_amt, sum(a.remain_amt) as remain_amt , sum(a.g2_1_amt) as g2_1_amt, sum(a.g2_3_amt) as g2_3_amt, sum(a.g3_amt) as g3_amt, sum(a.g2_amt) as g2_amt  " +
				" from  (  " +		
				"	select u.use_yn,  u.user_id, a.w_cnt, a.basic_amt, a.real_amt, a.remain_amt, b.g2_1_amt, c.g2_3_amt, d.g3_amt, e.g2_amt from  users u ,  " +				
				"		 ( select   a.user_id,  sum(decode(a.remark, 'W', 1, 0)) as w_cnt, sum(a.basic_amt) as basic_amt, sum(a.real_amt) as real_amt, sum(a.remain_amt) as remain_amt " +
				"				         from card_doc_jungsan a       where a.jung_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') group by a.user_id ) a, " +
				"		 ( select  b.doc_user, sum(b.doc_amt)  as g2_1_amt  from card_doc a, card_doc_user  b	where a.buy_dt  between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and a.acct_code = '00001' and a.acct_code_g = '1' and a.acct_code_g2 = '1'  and  " +
				"			      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user ) b , " +
				"		 ( select  b.doc_user, sum(b.doc_amt)  as g2_3_amt from card_doc a, card_doc_user  b	where a.buy_dt  between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and a.acct_code = '00001' and a.acct_code_g = '1' and a.acct_code_g2 = '3'  and  " + 
				"			      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user ) c , " +
				"		 ( select  b.doc_user, sum(b.doc_amt)  as g3_amt from card_doc a, card_doc_user  b	where a.buy_dt  between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and a.acct_code = '00001' and a.acct_code_g = '3' and " + 
				"			      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user ) d, " +
				"		 ( select  b.doc_user, sum(b.doc_amt)  as g2_amt from card_doc a, card_doc_user  b	where a.buy_dt  between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and a.acct_code = '00001' and a.acct_code_g = '2' and " + 
				"			      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user ) e " +
				"	where u.user_id = a.user_id(+) and u.user_id = b.doc_user(+) and u.user_id = c.doc_user(+) and u.user_id = d.doc_user(+) and u.user_id = e.doc_user(+)) a, users u " +
				" where a.user_id = u.user_id   and a.user_id not in ('000000', '000035', '000037', '000044', '000047', '000003', '000004', '000005', '000006', '000071' , '000081', '000084' )  and u.dept_id not in ('8888' ,  '1000')  and ( u.use_yn = 'Y' or u.out_dt > replace('" + f_date1 + "','-','')  ) " ;
							
				
		if(!br_id.equals(""))	query += " and u.br_id='"+br_id+"' ";
		if(!dept_id.equals("")) query += " and u.dept_id='"+dept_id+"' ";
		if(!user_nm.equals("")) query += " and u.user_nm like '%"+user_nm+"%' ";		
						
		query += " group by u.use_yn, a.user_id, u.user_nm, u.user_pos, u.br_id, u.dept_id	order by 1 desc, 7, 9, 8, 4, 3 ";
			


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
			System.out.println("[CardDatabase:getCardJungDtStat]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}
	
   	public boolean updateCardDocuJungWork(String s_year, String s_month)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " update card_doc_jungsan set remain_amt = basic_amt - real_amt where remark = 'W' and  jung_dt like '"+ s_year + s_month + "%'";

		try 
		{
			conn.setAutoCommit(false);
				
			pstmt = conn.prepareStatement(query);
			pstmt.executeUpdate();
			pstmt.close();
			
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[CardDatabase:updateCardDocuJungWork]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	public boolean updateCardDocuJungWorkO(String s_year, String s_month)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		String query = "";
		String query1 = "";
		
		query1 =  " select user_id from users where out_dt like '"+ s_year + s_month + "%'";
		
		
		query = " update card_doc_jungsan set remain_amt = 0 , basic_amt = 0 where user_id  = ? and  jung_dt like '"+ s_year + s_month + "%'";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt1 = conn.prepareStatement(query1);
		    rs = pstmt1.executeQuery();

			pstmt = conn.prepareStatement(query);

			while(rs.next()){				
				pstmt.setString(1,  rs.getString(1));
				pstmt.executeUpdate();				
			}
			pstmt.close();

			rs.close();
			pstmt1.close();
	
			conn.commit();
		
	  	} catch (Exception e) {
			System.out.println("[CardDatabase:updateCardDocuJungWorkO]\n"+e);
			e.printStackTrace();
	  		flag = false;
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
				if ( pstmt1 != null )	pstmt1.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	public boolean updateCardDocuJungWorkT(String s_year, String s_month)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
	
		String query = "";
			
		query = " update card_doc_jungsan set remain_amt = 0 , basic_amt = 0 where user_id  in ('000003', '000004', '000005', '000006', '000035' )and  jung_dt like '"+ s_year + s_month + "%'";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[CardDatabase:updateCardDocuJungWorkT]\n"+e);
			e.printStackTrace();
	  		flag = false;
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	public boolean deleteCardDocuJung(String s_year, String s_month)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " DELETE from card_doc_jungsan where jung_dt like '"+ s_year + s_month + "%'";

		try 
		{			
            conn.setAutoCommit(false);
            
			pstmt = conn.prepareStatement(query);
			pstmt.executeUpdate();
			pstmt.close();
			
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[CardDatabase:deleteCardDocuJung(CardJungBean bean)]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	public boolean insertCardDocuJung(CardJungBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " INSERT INTO card_doc_jungsan ("+
				"	jung_dt,				"+
				"	user_id,				"+
				"	acct_code,				"+
				"	acct_code_g,			"+
				"	acct_code_g2,			"+
				"	basic_amt,			"+
				"	real_amt,	"+
				"	jung_amt,		"+
				"	remain_amt,			"+
				"	remark				"+
				" ) VALUES"+
				" ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?"+
				" )";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getJung_dt				());
			pstmt.setString	(2,		bean.getUser_id				());
			pstmt.setString	(3,		bean.getAcct_code			());
			pstmt.setString	(4,		bean.getAcct_code_g			());
			pstmt.setString	(5,		bean.getAcct_code_g2		());
			pstmt.setInt	(6,		bean.getBasic_amt			());
			pstmt.setInt	(7,		bean.getReal_amt			());
			pstmt.setInt	(8,		bean.getJung_amt				());
			pstmt.setInt	(9,		bean.getRemain_amt				());
			pstmt.setString	(10,	bean.getRemark				());
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[CardDatabase:insertCardDocuJung(CardJungBean bean)]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
			
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	public boolean updateCardDocuJung(String user_id, String jung_dt, int doc_amt, int jung_amt )
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " UPDATE card_doc_jungsan set real_amt = ? , jung_amt = ? where  user_id=? and jung_dt=?";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setInt	(1,		doc_amt);
			pstmt.setInt	(2,		jung_amt);
			pstmt.setString	(3,		user_id);
			pstmt.setString	(4,		jung_dt);
			pstmt.executeUpdate();
			pstmt.close();
			
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[CardDatabase:updateCardDocuJung(CardJungBean bean)]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);			
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}	
	
	public Vector getCardUseDtStat(String s_year, String s_month)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = "  select a.buy_dt, b.doc_user, sum(b.doc_amt) doc_amt, sum(b.doc_amt) as jung_amt  from card_doc a, card_doc_user  b  " +
				"	where a.buy_dt  like '" + s_year + s_month + "%'  and a.acct_code = '00001' and a.acct_code_g = '1' and a.acct_code_g2 = '2'  and  " +
	      	    " 	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by a.buy_dt, b.doc_user "; 

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
			System.out.println("[CardDatabase:getCardJungDtStat]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
     * 기준금액.
     */
    public int checkMon(String ref_dt1, String ref_dt2)
    {
       	getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;	
		String query = "";
		     
        int cmon = 1;
           
        
        query="SELECT round(abs(MONTHS_BETWEEN(TO_DATE('"+ ref_dt1+ "') , TO_DATE('" + ref_dt2 + "')) ))  FROM dual"; 


        try{
          	pstmt = conn.prepareStatement(query);
		    rs = pstmt.executeQuery();
            
            if(rs.next())
                cmon = rs.getInt(1);

            rs.close();
            pstmt.close();
        } catch (SQLException e) {
			System.out.println("[CardDatabase:checkMon]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return cmon;
		}		
	}
	    
        
	//유류대
	public Vector getCardJungOilDtStat(String dt, String ref_dt1, String ref_dt2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query="";
		int amt=0;
		
		String f_date1="";
		String t_date1="";
		
				
		String s_year = Integer.toString(AddUtil.getDate2(1));	
		String s_month =Integer.toString(AddUtil.getDate2(2));	
		s_month = AddUtil.addZero(s_month);
		
		if(dt.equals("2")) {
			f_date1 = s_year+ s_month + "01";
			t_date1 = s_year+ s_month + "31";
		}
		
		if(dt.equals("3")) {
			f_date1 = s_year+ "0101";
			t_date1 = s_year+ "1231";
		}
		
		if(dt.equals("4")) {
			f_date1=  ref_dt1;
			t_date1=  ref_dt2;	
				
		}
		
		
		query = " select u.use_yn,  a.buy_user_id, u.user_nm,  u.user_pos, u.br_id, decode(u.br_id,'S1','본사','B1','부산지점','D1','대전지점','') as br_nm, decode(u.br_id,'S1','1','B1','2','D1','3','4') as br_sort, " +
	    		" decode(u.user_pos,'대표이사',1,'이사', 2, '팀장', 3, '차장', 4 , '과장', 5, '대리', 6,  9) pos_sort, u.dept_id, decode(u.dept_id,'0001','영업팀','0002','고객지원팀','0003','총무팀','0007','부산지점','0008','대전지점','8888', '기타', ' ') as dept_nm, " +				   
 				" sum(a.amt_11) as amt_11, sum(a.amt_12) as amt_12, sum(a.amt_13) as amt_13, f.bud_amt, ( f.bud_amt - sum(a.amt_11)) as amt_14   from ( " +
				" 	select d.buy_user_id, d.cardno, d.buy_id,  d.buy_dt, a.amt_11, b.amt_12, c.amt_13    from card_doc d, " +
				" 	(select buy_user_id, cardno, buy_id, buy_dt, sum(buy_amt) as amt_11 from card_doc where acct_code = '00004' and buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and acct_code_g2 = '11' group by buy_user_id, cardno, buy_id, buy_dt) a, " +
				"	(select buy_user_id, cardno, buy_id, buy_dt, sum(buy_amt) as amt_12 from card_doc where acct_code = '00004' and buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and acct_code_g2 = '12' group by buy_user_id, cardno, buy_id, buy_dt) b, " +
				"	(select buy_user_id, cardno, buy_id, buy_dt, sum(buy_amt) as amt_13 from card_doc where acct_code = '00004' and buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and acct_code_g2 = '13' group by buy_user_id, cardno, buy_id, buy_dt) c  " +
				" 	where  d.acct_code = '00004' and d.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') " +
				"		and d.buy_id=a.buy_id(+)  and d.cardno = a.cardno(+) and d.buy_dt = a.buy_dt(+) " +
				"		and d.buy_id=b.buy_id(+)  and d.cardno = b.cardno(+) and d.buy_dt = b.buy_dt(+) " +
				"		and d.buy_id=c.buy_id(+)  and d.cardno = c.cardno(+) and d.buy_dt = c.buy_dt(+) " +
				"	order by d.buy_user_id,d.buy_dt ) a , users u , " +
				" ( select  a.user_id, sum(a.bamt) as bud_amt from budget_view a where a.byear||a.mm between substr( replace('" + f_date1 + "','-',''), 0, 6) and substr( replace('" + t_date1 + "','-',''), 0, 6)  and a.bgubun = '2' group by a.user_id ) f " +
				" where a.buy_user_id = u.user_id  and  a.buy_user_id = f.user_id " +  
				"   and a.buy_user_id not in ('000000', '000035', '000037', '000044', '000047', '000003', '000004', '000005', '000006', '000071' , '000081' )  " +
				"  group by u.use_yn, a.buy_user_id, u.user_nm, u.user_pos, u.br_id, u.dept_id , f.bud_amt " +
				"  order by 1 desc, 7, 10, 8, 4, 3 ";

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
			System.out.println("[CardDatabase:getCardJungOilDtStat]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}
	
		//유류대
		
	public Vector getCardJungOilDtStatI(String dt, String ref_dt1, String ref_dt2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		Vector vt = new Vector();
		String query = "";
				
		String sub_query = "";
		
		String f_date1="";
		String t_date1="";
	
			
		String s_year = Integer.toString(AddUtil.getDate2(1));	
		String s_month =Integer.toString(AddUtil.getDate2(2));	
		s_month = AddUtil.addZero(s_month);
		
			
		if(dt.equals("2")) {
			f_date1 = s_year+ s_month + "01";
			t_date1 = s_year+ s_month + "31";
		}
		
		if(dt.equals("3")) {
			f_date1 = s_year+ "0101";
			t_date1 = s_year+ "1231";
		}
		
		if(dt.equals("4")) {
			f_date1=  ref_dt1;
			t_date1=  ref_dt2;
		}
			
	
		query = " select u.use_yn,  a.buy_user_id, u.user_nm,  u.user_pos, u.br_id,  c.br_nm, decode(u.br_id,'S1','1','B1','2','D1','3','4') as br_sort,  \n" +
	    		"        decode(u.user_pos,'대표이사',1,'이사', 2, '팀장', 3, '차장', 4 , '과장', 5, '대리', 6, 9) pos_sort, u.dept_id,  \n" +				   
 				"        sum(a.amt_11) as amt_11, sum(a.amt_12) as amt_12, sum(a.amt_13) as amt_13, f.bud_amt,  ( f.bud_amt - sum(a.amt_11)) as amt_14  \n" +
				" from ( \n" +
				" 		 select d.buy_user_id, d.cardno, d.buy_id,  d.buy_dt, a.amt_11, b.amt_12, c.amt_13    \n" +
				"        from   card_doc d, \n"  +
				" 	          ( select buy_user_id, cardno, buy_id, buy_dt, sum(buy_amt) as amt_11 from card_doc where acct_code = '00004' and buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and acct_code_g2 = '11' group by buy_user_id, cardno, buy_id, buy_dt) a, \n" +
				"	          ( select buy_user_id, cardno, buy_id, buy_dt, sum(buy_amt) as amt_12 from card_doc where acct_code = '00004' and buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and acct_code_g2 = '12' group by buy_user_id, cardno, buy_id, buy_dt) b, \n" +
				"	          ( select buy_user_id, cardno, buy_id, buy_dt, sum(buy_amt) as amt_13 from card_doc where acct_code = '00004' and buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and acct_code_g2 = '13' group by buy_user_id, cardno, buy_id, buy_dt) c  \n" +
				" 	     where  d.acct_code = '00004' and d.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') \n" +
				"		 and    d.buy_id=a.buy_id(+)  and d.cardno = a.cardno(+) and d.buy_dt = a.buy_dt(+)  \n" +
				"		 and    d.buy_id=b.buy_id(+)  and d.cardno = b.cardno(+) and d.buy_dt = b.buy_dt(+)  \n" +
				"		 and    d.buy_id=c.buy_id(+)  and d.cardno = c.cardno(+) and d.buy_dt = c.buy_dt(+)  \n" +
				"	     order by d.buy_user_id,d.buy_dt  \n" +
				"      ) a , users u ,  branch c, \n" +
				"      ( select  a.user_id, sum(a.bamt) as bud_amt from budget_view a where a.byear||a.mm between substr( replace('" + f_date1 + "','-',''), 0, 6) and substr( replace('" + t_date1 + "','-',''), 0, 6)  and a.bgubun = '2' group by a.user_id ) f \n" +
				" where a.buy_user_id = u.user_id and a.buy_user_id = f.user_id(+)  and u.use_yn = 'Y'   and u.br_id = c.br_id \n" +
				"  group by u.use_yn, a.buy_user_id, u.user_nm, u.user_pos, u.br_id, u.dept_id, f.bud_amt , c.br_nm  \n ";
				
				query +="  order by 1 desc, decode(u.user_pos,'대표이사',1,'이사',3,'팀장',4, 5), decode(u.dept_id,'0004','0000',u.dept_id),  decode(u.user_pos,'인턴사원','6','사원','5','대리','4', '과장', '3', '차장', '2', '1'),  a.buy_user_id  ";
				
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
			System.out.println("[CardDatabase:getCardJungOilDtStat]\n"+e);
	  		e.printStackTrace();
			System.out.println(query);
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}
	
		//유류대
	public Vector getCardJungOilDtStat(String dt, String ref_dt1, String ref_dt2, String user_id )
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		String f_date1="";
		String t_date1="";
	
			
		String s_year = Integer.toString(AddUtil.getDate2(1));	
		String s_month =Integer.toString(AddUtil.getDate2(2));	
		s_month = AddUtil.addZero(s_month);
		
		if(dt.equals("2")) {
			f_date1 = s_year+ s_month + "01";
			t_date1 = s_year+ s_month + "31";
		}
		
		if(dt.equals("3")) {
			f_date1 = s_year+ "0101";
			t_date1 = s_year+ s_month + "31";
		}
		
		if(dt.equals("4")) {
			f_date1=  ref_dt1;
			t_date1=  ref_dt2;
		}
	
				
		query = " select   a.buy_user_id, u.user_nm,  u.user_pos, u.br_id, decode(u.br_id,'S1','본사','B1','부산지점','D1','대전지점','') as br_nm, decode(u.br_id,'S1','1','B1','2','D1','3','4') as br_sort, " +
	    		" decode(u.user_pos,'대표이사',1,'이사', 2,'팀장', 3, '차장', 4 , '과장', 5, '대리', 6, 9) pos_sort, u.dept_id, decode(u.dept_id,'0001','영업팀','0002','고객지원팀','0003','총무팀',' ') as dept_nm, a.buy_dt, " +				   
 				" a.amt_11 as amt_11, a.amt_12 as amt_12, a.amt_13 as amt_13   from ( " +
				" 	select d.buy_user_id, d.buy_id,  d.buy_dt, a.amt_11, b.amt_12, c.amt_13    from card_doc d, " +
				" 	(select buy_user_id, cardno, buy_id, buy_dt, buy_amt as amt_11 from card_doc where acct_code = '00004' and buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and acct_code_g2 = '11' ) a, " +
				"	(select buy_user_id, cardno, buy_id, buy_dt, buy_amt as amt_12 from card_doc where acct_code = '00004' and buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and acct_code_g2 = '12' ) b, " +
				"	(select buy_user_id, cardno, buy_id, buy_dt, buy_amt as amt_13 from card_doc where acct_code = '00004' and buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and acct_code_g2 = '13' ) c  " +
				" 	where  d.acct_code = '00004' and d.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') " +
				"		and d.buy_id=a.buy_id(+)  and d.cardno = a.cardno(+)  and d.buy_dt = a.buy_dt(+) " +
				"		and d.buy_id=b.buy_id(+)  and d.cardno = b.cardno(+)  and d.buy_dt = a.buy_dt(+)" +
				"		and d.buy_id=c.buy_id(+)  and d.cardno = c.cardno(+)  and d.buy_dt = a.buy_dt(+)" +
				"	order by d.buy_user_id,d.buy_dt ) a , users u " +
				" where a.buy_user_id = u.user_id  and  a.buy_user_id ='" + user_id + "'  and (a.amt_11 > 0 or  a.amt_12 > 0 or a.amt_13 > 0 )  " +
			    "  order by  6, 9, 7, 3, 2  ";


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
			System.out.println("[CardDatabase:getCardJungOilDtStat]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}
		/**
	 *	사용자 리스트 조회
	 *  mode - CLIENT : 고객사용자, EMP : 사원사용자, BUS_EMP : 영업담당자, MNG_EMP : 관리담당자
	 */
	public Vector getUserList(String dept, String br_id, String mode, String s_year, String s_month)
	{
    	getConnection();
    	
        String query = " select user_id, user_nm , nvl(enter_dt,'99999999') as enter_dt, nvl(out_dt, '99999999') as out_dt from USERS where use_yn='Y' or out_dt > '"+ s_year + s_month + "01'";
        if(!dept.equals(""))				query += " and DEPT_ID = '"+ dept +"' ";
        if(!br_id.equals(""))				query += " and BR_ID = '"+ br_id +"' ";
		if(mode.equals("CLIENT"))			query += " and DEPT_ID is null ";
		else if(mode.equals("EMP"))			query += " and DEPT_ID in ('0001','0002','0003','0004','0006', '8888', '9999', '7777') ";
		else if(mode.equals("BUS_EMP"))		query += " and DEPT_ID = '0001' ";
		else if(mode.equals("MNG_EMP"))		query += " and DEPT_ID = '0002' ";
		else if(mode.equals("GEN_EMP"))		query += " and DEPT_ID = '0003' ";
		else if(mode.equals("BUS_MNG_EMP")) query += " and DEPT_ID in ('0001','0002') ";

		query += " ORDER BY user_id ";
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		
		
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
			System.out.println("[CardDatabase:getUserList]\n"+e);
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
	 *	카드정산 프로시져 호출
	*/
	public String call_sp_card_jungsan(String s_year, String s_month)
	{
    	getConnection();
    	
    	String query = "{CALL P_CARD_JUNGSAN (?,?,?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
			cstmt = conn.prepareCall(query);
			
			cstmt.setString(1, s_year);
			cstmt.setString(2, s_month);
			cstmt.registerOutParameter( 3, java.sql.Types.VARCHAR );
			
			cstmt.execute();
			sResult = cstmt.getString(3); // 결과값
			cstmt.close();
				
	
		} catch (SQLException e) {
			System.out.println("[CardDatabase:call_sp_card_jungsan]\n"+e);
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
     * 사용자 예산조회.
     */

    public Vector getUserBudgetAll(String byear, String bgubun) 
    {
       	getConnection();
        
        Statement stmt = null;
        ResultSet rs = null;
        Vector vt = new Vector();
        String query = "";
        
       query = "SELECT e.USER_ID,\n"        			 
        				+ " decode(a.user_pos,'대표이사',0,'이사', 1, '팀장', 2, '부장', 3, '차장', 4 , '과장', 5, '대리',  9) pos_sort ,\n"
        				+ " decode(a.dept_id,'0004',0 , '0020', '0', 9 ) DEPT_sort,\n"
        				+ "a.USER_NM,\n"
        				+ "e.BYEAR,\n"
        				+ "a.DEPT_ID,\n"
        				+ "c.NM AS DEPT_NM,\n"
        				+ "a.USER_POS,\n"
        				+ "a.ENTER_DT, e.PRV, \n"
        				+ "e.JAN + e.jan1 jan , e.FEB + e.feb1 feb, e.MAR + e.mar1 mar, e.APR + e.apr1 apr , \n"
        				+ "e.MAY + e.may1 may, e.JUN +e.jun1 jun, e.JUL+ e.jul1 jul, e.AUG+ e.aug1 aug,\n"
        				+ "e.SEP + e.sep1 sep, e.OCT + e.oct1 oct, e.NOV+e.nov1 nov, e.DEC + e.dec1 dec ,\n"
        			    + "a.out_dt, a.use_yn\n"
        		+ "FROM USERS a,  BUDGET e, (select * from CODE where c_st='0002') c\n"
        		+ "where e.user_id=a.user_id  and a.user_id not in ( '000035' ) \n"
        		+" and a.dept_id not in ('1000',  '8888' ) \n"
        	    +" and a.id not like 'develop%'  \n"
        		+ "and a.DEPT_ID = c.CODE(+) and a.use_yn = 'Y' \n";

		if(!byear.equals("")) query += " and e.BYEAR = '" + byear + "'";
		if(!bgubun.equals("")) query += " and e.BGUBUN = '" + bgubun + "'";
	
	//	query += " order by  3, 6 , decode(a.user_pos,'대표이사',1,'이사',2, 5), decode(a.user_id, '000237', '0', decode(a.user_pos, '팀장', 0, '부장', 1, '차장', 2, '과장',3,'대리', 4, 5)) , a.enter_dt ";
		query += " order by  decode(a.user_pos,'대표이사',1,'이사',2,'팀장',4, 5), DECODE(a.user_id, '000004',1,'000005',2,4), decode(a.dept_id,'0020','0000',a.dept_id), decode(a.user_id, '000237', '0', decode(a.user_pos, '팀장', 0, '부장', 1, '차장', 2, '과장',3,'대리', 4, 5)), a.user_id ";

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
			System.out.println("[CardDatabase:getUserBudgetAll]\n"+e);
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
	 *	개인별 예산 조회
	 *  
	 */	
	public BudgetBean getUserBudget(String user_id, String byear, String bgubun)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		BudgetBean bean = new BudgetBean();
		String query = "";

		query = " select b.*, u.user_nm, DECODE(u.enter_dt,'','',SUBSTR(u.enter_dt,1,4)||'-'||SUBSTR(u.enter_dt,5,2)||'-'||SUBSTR(u.enter_dt,7,2)) as enter_dt, DECODE(u.out_dt,'','',SUBSTR(u.out_dt,1,4)||'-'||SUBSTR(u.out_dt,5,2)||'-'||SUBSTR(u.out_dt,7,2)) as out_dt  from budget b, users u where b.user_id = u.user_id and  b.byear=? and b.user_id = ? and b.bgubun=?";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,	byear);
			pstmt.setString	(2,	user_id);
			pstmt.setString	(3,	bgubun);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{			
				bean.setUser_id		(rs.getString(1));
				bean.setByear		(rs.getString(2));
				bean.setBgubun		(rs.getString(3));
				bean.setPrv			(rs.getInt(4));
				bean.setJan			(rs.getInt(5));
				bean.setFeb			(rs.getInt(6));
				bean.setMar			(rs.getInt(7));
				bean.setApr			(rs.getInt(8));
				bean.setMay			(rs.getInt(9));
				bean.setJun			(rs.getInt(10));
				bean.setJul			(rs.getInt(11));
				bean.setAug			(rs.getInt(12));
				bean.setSep			(rs.getInt(13));
				bean.setOct			(rs.getInt(14));
				bean.setNov			(rs.getInt(15));
				bean.setDec			(rs.getInt(16)); //회식 
				bean.setJan1			(rs.getInt(17));
				bean.setFeb1			(rs.getInt(18));
				bean.setMar1			(rs.getInt(19));
				bean.setApr1			(rs.getInt(20));
				bean.setMay1			(rs.getInt(21));
				bean.setJun1			(rs.getInt(22));
				bean.setJul1			(rs.getInt(23));
				bean.setAug1			(rs.getInt(24));
				bean.setSep1			(rs.getInt(25));
				bean.setOct1			(rs.getInt(26));
				bean.setNov1			(rs.getInt(27));
				bean.setDec1			(rs.getInt(28)); //포상 
				
				bean.setUser_nm 	(rs.getString(29));
				bean.setEnter_dt 	(rs.getString(30));
				bean.setOut_dt 	(rs.getString(31));
			
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CardDatabase:getUserBudget]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}		
	}	

	 /**
     * 사용자예산 등록.
     */
    public int insertUserBudget(BudgetBean bean) 
    {
    	getConnection();
        PreparedStatement pstmt = null;
             
        String query = "";
        int count = 0;
                
        query="INSERT INTO BUDGET(USER_ID,\n"
								+ "BYEAR,\n"
								+ "BGUBUN, PRV,\n"
								+ "JAN, FEB, \n"
								+ "MAR, APR,\n"
								+ "MAY, JUN,\n"
								+ "JUL, AUG,\n"
								+ "SEP, OCT,\n"
							    + "NOV, DEC,\n"
								+ "JAN1, FEB1, \n"
								+ "MAR1, APR1,\n"
								+ "MAY1, JUN1,\n"
								+ "JUL1, AUG1,\n"
								+ "SEP1, OCT1,\n"
							    + "NOV1, DEC1)\n"
            + "values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "
            + "?, ?, ? ,? ,? ,? ,? ,? ,? ,? ,? ,? )";  //12

	 
       try{
            conn.setAutoCommit(false);
                   
            pstmt = conn.prepareStatement(query);

            pstmt.setString(1, bean.getUser_id().trim());
            pstmt.setString(2, bean.getByear().trim());
            pstmt.setString(3, bean.getBgubun().trim());
            pstmt.setInt(4, bean.getPrv());
            pstmt.setInt(5, bean.getJan());
       		pstmt.setInt(6, bean.getFeb());
			pstmt.setInt(7, bean.getMar());
			pstmt.setInt(8, bean.getApr());
			pstmt.setInt(9, bean.getMay());
			pstmt.setInt(10, bean.getJun());
			pstmt.setInt(11, bean.getJul());
			pstmt.setInt(12, bean.getAug());
			pstmt.setInt(13, bean.getSep());
			pstmt.setInt(14, bean.getOct());
			pstmt.setInt(15, bean.getNov());
			pstmt.setInt(16, bean.getDec());
			pstmt.setInt(17, bean.getJan1());
	       	pstmt.setInt(18, bean.getFeb1());
			pstmt.setInt(19, bean.getMar1());
			pstmt.setInt(20, bean.getApr1());
			pstmt.setInt(21, bean.getMay1());
			pstmt.setInt(22, bean.getJun1());
			pstmt.setInt(23, bean.getJul1());
			pstmt.setInt(24, bean.getAug1());
			pstmt.setInt(25, bean.getSep1());
			pstmt.setInt(26, bean.getOct1());
			pstmt.setInt(27, bean.getNov1());
			pstmt.setInt(28, bean.getDec1());
			count = pstmt.executeUpdate();             
            pstmt.close();
            conn.commit();
					
	   	}catch(SQLException e){
            try{
				System.out.println("[CardDatabase:insertUserBudget]"+e);
                conn.rollback();
            }catch(SQLException _ignored){}
			e.printStackTrace();
	
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			closeConnection();
		}
		return count;
	}


    /**
     * 사용자예산 수정.
     */
    public int updateUserBudget(BudgetBean bean)
    { 
    	getConnection();
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query="UPDATE BUDGET SET PRV=?,"
        	                	+ " JAN=?, FEB=?, \n"
								+ " MAR=?, APR=?, \n"
								+ " MAY=?, JUN=?, \n"
								+ " JUL=?, AUG=?, \n"
								+ " SEP=?, OCT=?, \n"
							    + " NOV=?, DEC=?, \n"
							    + " JAN1=?, FEB1=?, \n"
								+ " MAR1=?, APR1=?, \n"
								+ " MAY1=?, JUN1=?, \n"
								+ " JUL1=?, AUG1=?, \n"
								+ " SEP1=?, OCT1=?, \n"
							    + " NOV1=?, DEC1=? \n"
         					    + " WHERE USER_ID=? and BYEAR=? and BGUBUN = ? ";
 
       try{
            conn.setAutoCommit(false);
                       
            pstmt = conn.prepareStatement(query);
           
            pstmt.setInt(1, bean.getPrv());
            pstmt.setInt(2, bean.getJan());
       		pstmt.setInt(3, bean.getFeb());
			pstmt.setInt(4, bean.getMar());
			pstmt.setInt(5, bean.getApr());
			pstmt.setInt(6, bean.getMay());
			pstmt.setInt(7, bean.getJun());
			pstmt.setInt(8, bean.getJul());
			pstmt.setInt(9, bean.getAug());
			pstmt.setInt(10, bean.getSep());
			pstmt.setInt(11, bean.getOct());
			pstmt.setInt(12, bean.getNov());
			pstmt.setInt(13, bean.getDec()); //회식
		    pstmt.setInt(14, bean.getJan1());
       		pstmt.setInt(15, bean.getFeb1());
			pstmt.setInt(16, bean.getMar1());
			pstmt.setInt(17, bean.getApr1());
			pstmt.setInt(18, bean.getMay1());
			pstmt.setInt(19, bean.getJun1());
			pstmt.setInt(20, bean.getJul1());
			pstmt.setInt(21, bean.getAug1());
			pstmt.setInt(22, bean.getSep1());
			pstmt.setInt(23, bean.getOct1());
			pstmt.setInt(24, bean.getNov1());
			pstmt.setInt(25, bean.getDec1());  //포상
            pstmt.setString(26, bean.getUser_id().trim());
            pstmt.setString(27, bean.getByear().trim());
            pstmt.setString(28, bean.getBgubun().trim());
            count = pstmt.executeUpdate();             
            pstmt.close();
            conn.commit();
        
       	}catch(SQLException e){
            try{
				System.out.println("[CardDatabase:updateUserBudget]"+e);
                conn.rollback();
            }catch(SQLException _ignored){}
			e.printStackTrace();
	
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			closeConnection();
		}
		return count;
	}
  
 	//집계 - 팀장이상도 중식대 포함하여 일단 정산함.  이월시 복지비로만 이월 - 20120117
	public Vector getCardJungDtStatINew(String dt, String ref_dt1, String ref_dt2, String br_id, String dept_id, String user_nm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
     	
		String f_date1="";
		String t_date1="";
	
		String s_year = Integer.toString(AddUtil.getDate2(1));	
		String s_month =Integer.toString(AddUtil.getDate2(2));	
		s_month = AddUtil.addZero(s_month);
		
		if(dt.equals("2")) {
			f_date1 = s_year+ s_month + "01";
			t_date1 = s_year+ s_month + "31";
		}
		
		if(dt.equals("3")) {
			f_date1 = s_year+ "0101";
			t_date1 = s_year+ "1231";
		}
		
		if(dt.equals("4")) {
			f_date1=  ref_dt1;
			t_date1=  ref_dt2;
		}
		
		query = " select u.use_yn, a.user_id, u.user_nm,  u.user_pos, u.br_id,  c.br_nm, decode(u.br_id,'S1','B1','2','D1','3','4') as br_sort, " +
				"	    decode(u.user_pos,'대표이사',1,'이사', 2, '팀장', 3, '차장', 4 , '과장', 5, '대리', 6, 9) pos_sort, u.dept_id, e.nm  as dept_nm,   " +  
				"	    decode(u.dept_id,'0004',1,'0001', 2, '0002', 3, '0003', 4 , '8888', 5, 9) dept_sort, " +  
				" 		sum(a.w_cnt) as w_cnt, sum(a.basic_amt) as basic_amt, sum(a.real_amt) as real_amt, sum(a.remain_amt) as remain_amt , decode(sum(a.remain_amt) , 0, '1', '2') as remain_sort, sum(a.g2_1_amt) as g2_1_amt, sum(a.g2_3_amt) as g2_3_amt, sum(a.g3_amt) as g3_amt, sum(a.g2_amt) as g2_amt,  sum(a.g4_amt) as g4_amt,  sum(a.g15_amt) as g15_amt, sum(a.budget_amt) as budget_amt, sum(a.g_2_4_amt) as g_2_4_amt, sum(a.g30_amt) as g30_amt, sum(a.t_basic_amt) as t_basic_amt,  sum(a.t_real_amt) as t_real_amt, sum(a.oil_amt) as oil_amt " +
				" from  (  " +		
				"	     select u.use_yn,  u.user_id, a.w_cnt, a.basic_amt, f.budget_amt, a.real_amt, a.remain_amt, b.g2_1_amt, c.g2_3_amt, d.g3_amt, e.g2_amt, g.g4_amt, gg.g15_amt , h.g_2_4_amt, k.g30_amt, r.t_basic_amt, r.t_real_amt ,  oi.oil_amt "+
				"        from   users u ,  " +				
				"		        ( select a.user_id,  sum(decode(a.remark, 'W', 1, 0)) as w_cnt, sum(a.basic_amt) as basic_amt, sum(a.real_amt) as real_amt, sum(a.remain_amt) as remain_amt " +
				"				  from   card_doc_jungsan a "+
				"                 where  a.jung_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') "+
				"                 group by a.user_id ) a, " +
				"		        ( select b.doc_user, sum(b.doc_amt) as g2_1_amt "+
				"                 from   card_doc a, card_doc_user  b "+
				"                 where  a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and a.acct_code = '00001' and a.acct_code_g = '1' and a.acct_code_g2 = '1'  and  " +
				"			      	     a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  "+
				"                 group by b.doc_user ) b , " +
				"		        ( select  b.doc_user, sum(b.doc_amt) as g2_3_amt "+
				"                 from    card_doc a, card_doc_user b "+
				"                 where   a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and a.acct_code = '00001' and a.acct_code_g = '1' and a.acct_code_g2 = '3'  and  " + 
				"			      	      a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+) "+
				"                 group by b.doc_user ) c , " +
				"		        ( select  b.doc_user, sum(b.doc_amt)  as g3_amt from card_doc a, card_doc_user  b	where a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and a.acct_code = '00001' and a.acct_code_g = '3' and " + 
				"			      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user ) d , " +
				"		        ( select  b.doc_user, sum(b.doc_amt)  as g2_amt from card_doc a, card_doc_user  b	where a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and a.acct_code = '00001' and a.acct_code_g = '2' and " + 
				"			      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user ) e, " +
				"		        ( select  b.doc_user, sum(b.doc_amt)  as g4_amt from card_doc a, card_doc_user  b	where a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and a.acct_code = '00001' and a.acct_code_g = '4' and " + 
				"			      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user ) g, " +
				"		        ( select  b.doc_user, sum(b.doc_amt)  as g15_amt from card_doc a, card_doc_user  b	where a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and a.acct_code = '00001' and a.acct_code_g = '15' and " + 
				"			      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user ) gg, " +
				"		        ( select  b.doc_user, sum(b.doc_amt)  as g_2_4_amt from card_doc a, card_doc_user  b	where a.buy_dt like substr('" + f_date1 + "',1,4)||'%'  and a.acct_code = '00001' and a.acct_code_g  in ('2', '4') and " + 
				"			      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user ) h, " +
				"		        ( select  b.doc_user, sum(b.doc_amt)  as g30_amt from card_doc a, card_doc_user  b	where a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and a.acct_code = '00001' and a.acct_code_g  = '30' and " + 
				"			      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user ) k, " +
				"		        ( select  a.user_id, sum(a.jung_amt)  as oil_amt from stat_car_oil a where a.save_dt like substr('" + f_date1 + "',1,4)||'%' and magam = 'Y'  and a.save_dt < '20120601' group by a.user_id ) oi, " +
				"		        ( select  a.user_id, sum(a.prv+a.jan+a.feb+a.mar+a.apr+a.may+a.jun+a.jul+a.aug+a.sep+a.oct+a.nov+a.dec)  as budget_amt from budget a where a.byear = substr('" + f_date1 + "',1,4) and a.bgubun = '1' group by a.user_id ) f, " +
				"		        ( select  a.user_id, sum(a.basic_amt) as t_basic_amt, sum(a.real_amt)  as t_real_amt from card_doc_jungsan a where substr(a.jung_dt, 1, 4)  = substr('" + f_date1 + "',1,4)  group by a.user_id ) r " +
				"	     where u.user_id = a.user_id(+) and u.user_id = b.doc_user(+) and u.user_id = c.doc_user(+) and u.user_id = d.doc_user(+) and u.user_id = e.doc_user(+) and u.user_id = g.doc_user(+) and u.user_id = gg.doc_user(+) and u.user_id = f.user_id(+) and u.user_id = h.doc_user(+)  and u.user_id = k.doc_user(+) and u.user_id = r.user_id(+)and u.user_id = oi.user_id(+) "+
				"      ) a, " +
				"      users u, branch c, ( select c_st, code, nm_cd, nm from code where c_st = '0002' and code <> '0000'  )  e  \n"+
				" where a.user_id = u.user_id    and u.br_id=c.br_id and u.dept_id = e.code "+
				"      and a.user_id not in ('000035','000177','000203','000238','000285','000302','000329','000293','000330') and u.id not like 'develop%' and u.dept_id not in ('8888' , '1000')"+
				"      and nvl(u.m_yn, 'Y' ) = 'Y' "+
				"      and ( u.use_yn = 'Y' or u.out_dt > replace('" + f_date1 + "','-','')  ) " ;
							
				
		if(!br_id.equals(""))	query += " and u.br_id='"+br_id+"' ";
		if(!dept_id.equals("")) query += " and u.dept_id='"+dept_id+"' ";
		if(!user_nm.equals("")) query += " and u.user_nm like '%"+user_nm+"%' ";		
						
		query += " group by u.use_yn, a.user_id, u.user_nm, u.user_pos, u.br_id, u.dept_id  , c.br_nm, e.nm ";
		query +="  order by 1 desc, decode(u.user_pos,'대표이사',1,'이사',2,'팀장',4, 5), DECODE(a.user_id, '000004',1,'000005',2,'000237',3,4), decode(u.dept_id,'0004','0000',u.dept_id), decode(u.user_pos,'인턴사원','6','사원','5','대리','4', '과장', '3', '차장', '2', '1'),a.user_id ";
			
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
			System.out.println("[CardDatabase:getCardJungDtStatINew]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}


    public Vector getCardJungDtStatNew(String dt, String ref_dt1, String ref_dt2, String br_id, String dept_id, String user_nm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
     	
		String f_date1="";
		String t_date1="";
	
		String s_year = Integer.toString(AddUtil.getDate2(1));	
		String s_month =Integer.toString(AddUtil.getDate2(2));	
		s_month = AddUtil.addZero(s_month);
		
		if(dt.equals("2")) {
			f_date1 = s_year+ s_month + "01";
			t_date1 = s_year+ s_month + "31";
		}
		
		if(dt.equals("3")) {
			f_date1 = s_year+ "0101";
			t_date1 = s_year+ "1231";
		}
		
		if(dt.equals("4")) {
			f_date1=  ref_dt1;
			t_date1=  ref_dt2;
		}
		
			query = " select u.use_yn,  a.user_id, u.user_nm,  u.user_pos, u.br_id, decode(u.br_id,'S1','본사','B1','부산지점','D1','대전지점', '') as br_nm, decode(u.br_id,'S1','1','B1','2','D1','3','4') as br_sort, " +
				"	    decode(u.user_pos,'대표이사',1,'이사', 2, '팀장', 3, '차장', 4 ,  '과장', 5, '대리', 6, 9  ) pos_sort, u.dept_id, decode(u.dept_id,'0001','영업팀','0002','고객지원팀','0003','총무팀','0005', '채권관리팀','0007','부산지점','0008','대전지점','8888', '아마존카외', '7777', '아르바이트',' ') as dept_nm,    " +  
				" 		sum(a.w_cnt) as w_cnt, sum(a.basic_amt) as basic_amt, sum(a.real_amt) as real_amt, sum(a.remain_amt) as remain_amt , sum(a.g2_1_amt) as g2_1_amt, sum(a.g2_3_amt) as g2_3_amt, sum(a.g3_amt) as g3_amt, sum(a.g2_amt) as g2_amt , sum(a.g4_amt) as g4_amt, sum(a.g15_amt) as g15_amt,  sum(a.g30_amt) as g30_amt, sum(a.budget_amt) as budget_amt, sum(a.g_2_4_amt) as g_2_4_amt  " +
				" from  (  " +		
				"	select u.use_yn,  u.user_id, a.w_cnt, a.basic_amt,  f.budget_amt, a.real_amt, a.remain_amt, b.g2_1_amt, c.g2_3_amt, d.g3_amt, e.g2_amt, g.g4_amt, gg.g15_amt,  h.g_2_4_amt, k.g30_amt from  users u ,  " +				
				"		 ( select   a.user_id,  sum(decode(a.remark, 'W', 1, 0)) as w_cnt, sum(a.basic_amt) as basic_amt, sum(a.real_amt) as real_amt, sum(a.remain_amt) as remain_amt " +
				"				         from card_doc_jungsan a       where a.jung_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') group by a.user_id ) a, " +
				"		 ( select  b.doc_user, sum(b.doc_amt)  as g2_1_amt  from card_doc a, card_doc_user  b	where a.buy_dt  between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and a.acct_code = '00001' and a.acct_code_g = '1' and a.acct_code_g2 = '1'  and  " +
				"			      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user ) b , " +
				"		 ( select  b.doc_user, sum(b.doc_amt)  as g2_3_amt from card_doc a, card_doc_user  b	where a.buy_dt  between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and a.acct_code = '00001' and a.acct_code_g = '1' and a.acct_code_g2 = '3'  and  " + 
				"			      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user ) c , " +
				"		 ( select  b.doc_user, sum(b.doc_amt)  as g3_amt from card_doc a, card_doc_user  b	where a.buy_dt  between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and a.acct_code = '00001' and a.acct_code_g = '3' and " + 
				"			      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user ) d, " +
				"		 ( select  b.doc_user, sum(b.doc_amt)  as g2_amt from card_doc a, card_doc_user  b	where a.buy_dt  between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and a.acct_code = '00001' and a.acct_code_g = '2' and " + 
				"			      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user ) e, " +
				"		 ( select  b.doc_user, sum(b.doc_amt)  as g4_amt from card_doc a, card_doc_user  b	where a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and a.acct_code = '00001' and a.acct_code_g = '4' and " + 
				"			      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user ) g, " +
				"		 ( select  b.doc_user, sum(b.doc_amt)  as g15_amt from card_doc a, card_doc_user  b	where a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and a.acct_code = '00001' and a.acct_code_g = '15' and " + 
				"			      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user ) gg, " +
				"		 ( select  b.doc_user, sum(b.doc_amt)  as g_2_4_amt from card_doc a, card_doc_user  b	where substr(a.buy_dt,1,4) = substr('" + f_date1 + "',1,4) and a.acct_code = '00001' and a.acct_code_g  in ('2', '4') and " + 
				"			      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user ) h, " +
				"		 ( select  b.doc_user, sum(b.doc_amt)  as g30_amt from card_doc a, card_doc_user  b	where a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and a.acct_code = '00001' and a.acct_code_g  = '30' and " + 
				"			      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user ) k, " +
				"		 ( select  a.user_id, sum(a.prv+a.jan+a.feb+a.mar+a.apr+a.may+a.jun+a.jul+a.aug+a.sep+a.oct+a.nov+a.dec)  as budget_amt from budget a where a.byear = substr('" + f_date1 + "',1,4) and a.bgubun = '1' group by a.user_id ) f " +
				"	where u.user_id = a.user_id(+) and u.user_id = b.doc_user(+) and u.user_id = c.doc_user(+) and u.user_id = d.doc_user(+) and u.user_id = e.doc_user(+) and u.user_id = g.doc_user(+) and u.user_id = gg.doc_user(+) and u.user_id = f.user_id(+) and u.user_id = h.doc_user(+) and u.user_id = k.doc_user(+) ) a, users u " +
				" where a.user_id = u.user_id   and a.user_id not in ('000000', '000035', '000037', '000044', '000047', '000003', '000004', '000005', '000006', '000071' , '000081', '000084', '000094', '000095', '000103', '000104', '000105', '000102' ) and u.dept_id not in ('8888' ) and ( u.use_yn = 'Y' or u.out_dt > replace('" + f_date1 + "','-','')  ) " ;
							
				
		if(!br_id.equals(""))	query += " and u.br_id='"+br_id+"' ";
		if(!dept_id.equals("")) query += " and u.dept_id='"+dept_id+"' ";
		if(!user_nm.equals("")) query += " and u.user_nm like '%"+user_nm+"%' ";		
		
		query += " group by u.use_yn, a.user_id, u.user_nm, u.user_pos, u.br_id, u.dept_id ";
		query +="  order by 1 desc, decode(u.user_pos,'대표이사',1,'이사',2,'팀장',3,'차장', 4, 5), decode(u.br_id,'S1',1,'B1',2,'S2',3,4), decode(u.dept_id,'0004','0000',u.dept_id), decode(u.user_pos,'인턴사원','4','사원','3','대리','2','1') ,a.user_id";


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
			System.out.println("[CardDatabase:getCardJungDtStatNew]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}
	 
	 
	public Vector getCardJungDtStatNew(String dt, String ref_dt1, String ref_dt2, String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		String f_date1="";
		String t_date1="";
	
		String s_year = Integer.toString(AddUtil.getDate2(1));	
		String s_month =Integer.toString(AddUtil.getDate2(2));	
		s_month = AddUtil.addZero(s_month);
		
		if(dt.equals("2")) {
			f_date1 = s_year+ s_month + "01";
			t_date1 = s_year+ s_month + "31";
		}
		
		if(dt.equals("3")) {
			f_date1 = s_year+ "0101";
			t_date1 = s_year+ s_month + "31";
		}
		
		if(dt.equals("4")) {
			f_date1=  ref_dt1;
			t_date1=  ref_dt2;
		}

		query = "	select  a.user_id, a.jung_dt, decode(a.remark , 'W', '근무일', 'H', '공휴일', 'T', '토요일', 'S', '일요일', 'M', '기타' , 'N', ' ' ) as  remark_desc,  sum(a.w_cnt) as w_cnt, sum(a.basic_amt) as basic_amt, sum(a.real_amt) as real_amt, sum(a.remain_amt) as remain_amt , sum(a.g2_1_amt) as g2_1_amt, sum(a.g2_3_amt) as g2_3_amt, sum(a.g3_amt) as g3_amt, sum(a.g2_amt) as g2_amt, sum(a.g4_amt) as g4_amt, sum(a.g15_amt) as g15_amt, sum(a.g30_amt) as g30_amt \n" +
				"	from (		\n" +
				"		select   u.user_id, u.jung_dt, a.remark, a.w_cnt, a.basic_amt, a.real_amt, a.remain_amt, b.g2_1_amt, c.g2_3_amt , d.g3_amt, e.g2_amt, g.g4_amt, gg.g15_amt, k.g30_amt from  card_doc_jungsan u ,  	\n" +		
				"			 ( select   a.user_id,  a.jung_dt, a.remark, sum(decode(a.remark, 'W', 1, 0)) as w_cnt, sum(a.basic_amt) as basic_amt, sum(a.real_amt) as real_amt, sum(a.remain_amt) as remain_amt \n" +
				"					         from card_doc_jungsan a        where a.jung_dt  between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','')  group by a.user_id, a.jung_dt, a.remark ) a, \n" +
				"			 ( select  b.doc_user, a.buy_dt,  sum(b.doc_amt)  as g2_1_amt  from card_doc a, card_doc_user  b where a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and a.acct_code = '00001' and a.acct_code_g = '1' and a.acct_code_g2 = '1'  and   \n" +
				"				      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user, a.buy_dt ) b , \n" +
				"			 ( select  b.doc_user, a.buy_dt, sum(b.doc_amt)  as g2_3_amt from card_doc a, card_doc_user  b	where a.buy_dt  between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','')  and a.acct_code = '00001' and a.acct_code_g = '1' and a.acct_code_g2 = '3'  and  \n" +
				"				      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user, a.buy_dt ) c, \n" +
				"			 ( select  b.doc_user, a.buy_dt, sum(b.doc_amt)  as g3_amt from card_doc a, card_doc_user  b	where a.buy_dt  between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','')  and a.acct_code = '00001' and a.acct_code_g = '3' and   \n" +
				"				      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user, a.buy_dt ) d, \n" +
				"			 ( select  b.doc_user, a.buy_dt, sum(b.doc_amt)  as g2_amt from card_doc a, card_doc_user  b	where a.buy_dt  between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','')  and a.acct_code = '00001' and a.acct_code_g = '2' and   \n" +
				"				      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user, a.buy_dt ) e, \n" +
				"			 ( select  b.doc_user, a.buy_dt, sum(b.doc_amt)  as g15_amt from card_doc a, card_doc_user  b	where a.buy_dt  between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','')  and a.acct_code = '00001' and a.acct_code_g = '15' and   \n" +
				"				      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user, a.buy_dt ) gg, \n" +
				"			 ( select  b.doc_user, a.buy_dt, sum(b.doc_amt)  as g30_amt from card_doc a, card_doc_user  b	where a.buy_dt  between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','')  and a.acct_code = '00001' and a.acct_code_g = '30' and   \n" +
				"				      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user, a.buy_dt ) k, \n" +
				"		     ( select  b.doc_user, a.buy_dt, sum(b.doc_amt)  as g4_amt from card_doc a, card_doc_user  b	where a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and a.acct_code = '00001' and a.acct_code_g = '4' and \n" +
				"			      	         	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user,  a.buy_dt ) g \n" +
				"		where u.user_id = a.user_id(+) and u.user_id = b.doc_user(+) and u.user_id = c.doc_user(+) and u.user_id = d.doc_user(+) and u.user_id = e.doc_user(+) and u.user_id = gg.doc_user(+) and u.user_id = k.doc_user(+) and u.user_id = g.doc_user(+) \n" +
				"		      and u.jung_dt = a.jung_dt(+) and u.jung_dt = b.buy_dt(+) and u.jung_dt = c.buy_dt(+) and u.jung_dt = d.buy_dt(+)and u.jung_dt = e.buy_dt(+) and  u.jung_dt = g.buy_dt(+) and u.jung_dt = k.buy_dt(+)  and  u.jung_dt = gg.buy_dt(+) \n" +
				"		      and u.jung_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') \n" +
				"			) a, users u " +
				"	 where a.user_id = u.user_id  and ( u.use_yn = 'Y' or u.out_dt > '" + f_date1 + "' )  " ;
		
		if(!user_id.equals(""))		query += " and a.user_id='"+user_id+"'";
				 
		query += "	group by a.user_id, a.jung_dt, a.remark order by  a.user_id, a.jung_dt ";
	
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
			System.out.println("[CardDatabase:getCardJungDtStatNew]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}
	
	public Vector getCardJungDtStatMon(String st_year, String st_mon, String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		String f_date1="";
		String t_date1="";
	
		
		f_date1 = st_year+ st_mon + "01";
		t_date1 = st_year+ st_mon + "31";
				

		query = "	select  a.user_id, a.jung_dt, decode(a.remark , 'W', '근무일', 'H', '공휴일', 'T', '토요일', 'S', '일요일', 'M', '기타' , 'N', ' ' ) as  remark_desc,  sum(a.w_cnt) as w_cnt, sum(a.basic_amt) as basic_amt, sum(a.real_amt) as real_amt, sum(a.remain_amt) as remain_amt , sum(a.g2_1_amt) as g2_1_amt, sum(a.g2_3_amt) as g2_3_amt, sum(a.g3_amt) as g3_amt, sum(a.g2_amt) as g2_amt, sum(a.g4_amt) as g4_amt, sum(a.g15_amt) as g15_amt \n" +
				"	from (		\n" +
				"		select   u.user_id, u.jung_dt, a.remark, a.w_cnt, a.basic_amt, a.real_amt, a.remain_amt, b.g2_1_amt, c.g2_3_amt , d.g3_amt, e.g2_amt, g.g4_amt, gg.g15_amt from  card_doc_jungsan u ,  	\n" +		
				"			 ( select   a.user_id,  a.jung_dt, a.remark, sum(decode(a.remark, 'W', 1, 0)) as w_cnt, sum(a.basic_amt) as basic_amt, sum(a.real_amt) as real_amt, sum(a.remain_amt) as remain_amt \n" +
				"					         from card_doc_jungsan a        where a.jung_dt  between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','')  group by a.user_id, a.jung_dt, a.remark ) a, \n" +
				"			 ( select  b.doc_user, a.buy_dt,  sum(b.doc_amt)  as g2_1_amt  from card_doc a, card_doc_user  b where a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and a.acct_code = '00001' and a.acct_code_g = '1' and a.acct_code_g2 = '1'  and   \n" +
				"				      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user, a.buy_dt ) b , \n" +
				"			 ( select  b.doc_user, a.buy_dt, sum(b.doc_amt)  as g2_3_amt from card_doc a, card_doc_user  b	where a.buy_dt  between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','')  and a.acct_code = '00001' and a.acct_code_g = '1' and a.acct_code_g2 = '3'  and  \n" +
				"				      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user, a.buy_dt ) c, \n" +
				"			 ( select  b.doc_user, a.buy_dt, sum(b.doc_amt)  as g3_amt from card_doc a, card_doc_user  b	where a.buy_dt  between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','')  and a.acct_code = '00001' and a.acct_code_g = '3' and   \n" +
				"				      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user, a.buy_dt ) d, \n" +
				"			 ( select  b.doc_user, a.buy_dt, sum(b.doc_amt)  as g2_amt from card_doc a, card_doc_user  b	where a.buy_dt  between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','')  and a.acct_code = '00001' and a.acct_code_g = '2' and   \n" +
				"				      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user, a.buy_dt ) e, \n" +
				"			 ( select  b.doc_user, a.buy_dt, sum(b.doc_amt)  as g15_amt from card_doc a, card_doc_user  b	where a.buy_dt  between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','')  and a.acct_code = '00001' and a.acct_code_g = '15' and   \n" +
				"				      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user, a.buy_dt ) gg, \n" +
				"		     ( select  b.doc_user, a.buy_dt, sum(b.doc_amt)  as g4_amt from card_doc a, card_doc_user  b	where a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and a.acct_code = '00001' and a.acct_code_g = '4' and \n" +
				"			      	         	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user,  a.buy_dt ) g \n" +
				"		where u.user_id = a.user_id(+) and u.user_id = b.doc_user(+) and u.user_id = c.doc_user(+) and u.user_id = d.doc_user(+) and u.user_id = e.doc_user(+) and u.user_id = gg.doc_user(+) and u.user_id = g.doc_user(+) \n" +
				"		      and u.jung_dt = a.jung_dt(+) and u.jung_dt = b.buy_dt(+) and u.jung_dt = c.buy_dt(+) and u.jung_dt = d.buy_dt(+)and u.jung_dt = e.buy_dt(+) and  u.jung_dt = g.buy_dt(+) and  u.jung_dt = gg.buy_dt(+) \n" +
				"		      and u.jung_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') \n" +
				"			) a, users u " +
				"	 where a.user_id = u.user_id  and ( u.use_yn = 'Y' or u.out_dt > '" + f_date1 + "' )  " ;
		
		if(!user_id.equals(""))		query += " and a.user_id='"+user_id+"'";
				 
		query += "	group by a.user_id, a.jung_dt, a.remark order by  a.user_id, a.jung_dt ";
	
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
			System.out.println("[CardDatabase:getCardJungDtStatMon]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}
	
	/* 복지비 사용 내역 */
	 public Vector getCardJungDtStatG4New(String dt, String ref_dt1, String ref_dt2, String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
     	
		String f_date1="";
		String t_date1="";
	
		String s_year = Integer.toString(AddUtil.getDate2(1));	
		String s_month =Integer.toString(AddUtil.getDate2(2));	
		s_month = AddUtil.addZero(s_month);
		
		if(dt.equals("2")) {
			f_date1 = s_year+ s_month + "01";
			t_date1 = s_year+ s_month + "31";
		}
		
		if(dt.equals("3")) {
			f_date1 = s_year+ "0101";
			t_date1 = s_year+ s_month + "31";
		}
		
		if(dt.equals("4")) {
			f_date1=  ref_dt1;
			t_date1=  ref_dt2;
		}
		
		query =	"	select  u.user_id, h.buy_dt, h.doc_amt from  users u ,  " +				
				"		 ( select  b.doc_user, a.buy_dt, sum(b.doc_amt) doc_amt from card_doc a, card_doc_user  b	where substr(a.buy_dt,1,4) = substr('" + f_date1 + "',1,4) and a.acct_code = '00001' and a.acct_code_g  in ('2', '4') and " + 
				"			      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+) group by b.doc_user, a.buy_dt  ) h " +
				"	where u.user_id = h.doc_user(+)" ;
									
		if(!user_id.equals(""))		query += " and u.user_id='"+user_id+"'";

		query += "	order by   u.user_id, h.buy_dt ";

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
			System.out.println("[CardDatabase:getCardJungDtStatG4New]\n"+e);
	  		e.printStackTrace();
			System.out.println(query);
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}
	
	  
	/**
	 *	카드 리스트
	 */	
	public Vector getCardno(String use_yn, String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select "+
				" a.*, b.*, d.br_nm, c.user_nm,  nvl(b.user_id,c.user_id) user_code,"+
				" decode(a.limit_st,'1','개별','2','통합') limit_st_nm, decode(a.card_st,'1','구매자금용','2','공용','3','임/직원지급용','4','하이패스','5','세금납부용','6','포인트') card_st_nm"+
				" from card a, card_user b, users c, branch d, (select cardno, max(seq) seq from card_user group by cardno) f"+
				" where"+
				" a.cardno=b.cardno(+) and a.user_seq=b.seq(+) and b.cardno=f.cardno(+) and b.seq=f.seq(+) and b.user_id=c.user_id(+) and c.br_id=d.br_id(+)";

		if(!use_yn.equals(""))			query += " and a.use_yn='"+use_yn+"'";

		if(!t_wd.equals("")){
			if(s_kd.equals("1"))		query += " and a.cardno||a.card_name||c.user_nm like '%"+t_wd+"%'";
			else if(s_kd.equals("2"))	query += " and a.card_kind like '%"+t_wd+"%'";
		}

		query += " order by a.cardno  ";

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
			System.out.println("[CardDatabase:getCardno]\n"+e);
			System.out.println("[CardDatabase:getCardno]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}
	
	/*
	 *	년 잔액 이월 호출 - 복지비 잔액은 정산함.( -잔액은 급여공제, 이월잔액은 0 , +잔액은 이월됨)	
	*/
	public String call_sp_insert_user_budget(String s_year, String gubun, String user_id)
	{
        getConnection();
    	
    	String query = "{CALL P_INSERT_USER_BUDGET(?,?,?,?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
						
			cstmt = conn.prepareCall(query);
					
			cstmt.setString(1, s_year);
			cstmt.setString(2, gubun);
			cstmt.setString(3, user_id);
			cstmt.registerOutParameter( 4, java.sql.Types.VARCHAR );
			cstmt.execute();
			sResult = cstmt.getString(4); // 결과값
			
			cstmt.close();
			
		} catch (SQLException e) {
			System.out.println("[CardDatabase:call_sp_insert_user_budget]\n"+e);
			System.out.println("[CardDatabase:call_sp_insert_user_budget]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				
				if ( cstmt != null )	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}		
	}
	
	
	public String updateBudgetAmt(String s_year, String s_mon, String gubun, int s_amt )
	{
		getConnection();

		String   ret= "0";
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
					
	    if (s_mon.equals("1")) {
			query = " UPDATE budget  set jan = ? where byear = ? and  bgubun = '" + gubun +"' and user_id in (select user_id from users where use_yn = 'Y' and dept_id not in ('8888',  '1000') ) ";
		}else if (s_mon.equals("2")) {
			query = " UPDATE budget  set feb = ? where byear = ? and  bgubun = '" + gubun +"' and user_id in (select user_id from users where use_yn = 'Y' and dept_id not in ('8888',  '1000') ) ";
		}else if (s_mon.equals("3")) {
			query = " UPDATE budget  set mar = ? where byear = ? and  bgubun = '" + gubun +"' and user_id in (select user_id from users where use_yn = 'Y' and dept_id not in ('8888', '1000') ) ";
		}else if (s_mon.equals("4")) {
			query = " UPDATE budget  set apr = ? where byear = ? and  bgubun = '" + gubun +"' and user_id in (select user_id from users where use_yn = 'Y' and dept_id not in ('8888',  '1000') ) ";
		}else if (s_mon.equals("5")) {
			query = " UPDATE budget  set may = ? where byear = ? and  bgubun = '" + gubun +"' and user_id in (select user_id from users where use_yn = 'Y' and dept_id not in ('8888',  '1000') ) ";
		}else if (s_mon.equals("6")) {
			query = " UPDATE budget  set jun = ? where byear = ? and  bgubun = '" + gubun +"' and user_id in (select user_id from users where use_yn = 'Y' and dept_id not in ('8888',  '1000') ) ";
		}else if (s_mon.equals("7")) {
			query = " UPDATE budget  set jul = ? where byear = ? and  bgubun = '" + gubun +"' and user_id in (select user_id from users where use_yn = 'Y' and dept_id not in ('8888',  '1000') ) ";
		}else if (s_mon.equals("8")) {
			query = " UPDATE budget  set aug = ? where byear = ? and  bgubun = '" + gubun +"' and user_id in (select user_id from users where use_yn = 'Y' and dept_id not in ('8888', '1000') ) ";
		}else if (s_mon.equals("9")) {
			query = " UPDATE budget  set sep = ? where byear = ? and  bgubun  ='" + gubun +"' and user_id in (select user_id from users where use_yn = 'Y' and dept_id not in ('8888',  '1000') ) ";
		}else if (s_mon.equals("10")) {
			query = " UPDATE budget  set oct = ? where byear = ? and  bgubun = '" + gubun +"' and user_id in (select user_id from users where use_yn = 'Y' and dept_id not in ('8888',  '1000') ) ";
		}else if (s_mon.equals("11")) {
			query = " UPDATE budget  set nov = ? where byear = ? and  bgubun = '" + gubun +"' and user_id in (select user_id from users where use_yn = 'Y' and dept_id not in ('8888',  '1000') ) ";
		}else if (s_mon.equals("12")) {
			query = " UPDATE budget  set dec = ? where byear = ? and  bgubun = '" + gubun +"' and user_id in (select user_id from users where use_yn = 'Y' and dept_id not in ('8888',  '1000') ) ";
		}		

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setInt	(1,		s_amt);
			pstmt.setString	(2,		s_year);
			pstmt.executeUpdate();
			pstmt.close();
			
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[CardDatabase:updateBudgetAmt\n"+e);
			e.printStackTrace();
	  		ret = "1";
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);			
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ret;
		}
	}		
	
	 //유류대 내근직은 없음 - 본사 총무팀, 고객지원팀, 최은아대리
	public String updateBudgetAmtN(String s_year, String s_mon, String gubun, int s_amt )
	{
		getConnection();

		String   ret= "0";
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
					
	    if (s_mon.equals("1")) {
			query = " UPDATE budget  set jan = 0 where byear = ? and  bgubun = '" + gubun +"' and user_id in (select user_id from users where use_yn = 'Y' and nvl(loan_st, '3' ) = '3'  and user_id not in ( '000121', '000122', '000124', '000070', '000031', '000053') and user_pos in ('차장', '과장', '대리', '사원') ) ";
		}else if (s_mon.equals("2")) {
			query = " UPDATE budget  set feb = 0 where byear = ? and  bgubun = '" + gubun +"' and user_id in (select user_id from users where use_yn = 'Y' and nvl(loan_st, '3' ) = '3'  and user_id not in ( '000121', '000122', '000124', '000070', '000031', '000053') and user_pos in ('차장', '과장', '대리', '사원') ) ";
		}else if (s_mon.equals("3")) {
			query = " UPDATE budget  set mar = 0 where byear = ? and  bgubun = '" + gubun +"' and user_id in (select user_id from users where use_yn = 'Y' and nvl(loan_st, '3' ) = '3'  and user_id not in ( '000121', '000122', '000124', '000070', '000031', '000053') and user_pos in ('차장', '과장', '대리', '사원') ) ";
		}else if (s_mon.equals("4")) {
			query = " UPDATE budget  set apr = 0 where byear = ? and  bgubun = '" + gubun +"' and user_id in (select user_id from users where use_yn = 'Y' and nvl(loan_st, '3' ) = '3'  and user_id not in ( '000121', '000122', '000124', '000070', '000031', '000053') and user_pos in ('차장', '과장', '대리', '사원') ) ";
		}else if (s_mon.equals("5")) {
			query = " UPDATE budget  set may = 0 where byear = ? and  bgubun = '" + gubun +"' and user_id in (select user_id from users where use_yn = 'Y' and nvl(loan_st, '3' ) = '3'  and user_id not in ( '000121', '000122', '000124', '000070', '000031', '000053') and user_pos in ('차장', '과장', '대리', '사원') ) ";
		}else if (s_mon.equals("6")) {
			query = " UPDATE budget  set jun = 0 where byear = ? and  bgubun = '" + gubun +"' and user_id in (select user_id from users where use_yn = 'Y' and nvl(loan_st, '3' ) = '3'  and user_id not in ( '000121', '000122', '000124', '000070', '000031', '000053') and user_pos in ('차장', '과장', '대리', '사원') ) ";
		}else if (s_mon.equals("7")) {
			query = " UPDATE budget  set jul = 0 where byear = ? and  bgubun = '" + gubun +"' and user_id in (select user_id from users where use_yn = 'Y' and nvl(loan_st, '3' ) = '3'  and user_id not in ( '000121', '000122', '000124', '000070', '000031', '000053') and user_pos in ('차장', '과장', '대리', '사원') ) ";
		}else if (s_mon.equals("8")) {
			query = " UPDATE budget  set aug = 0 where byear = ? and  bgubun = '" + gubun +"' and user_id in (select user_id from users where use_yn = 'Y' and nvl(loan_st, '3' ) = '3'  and user_id not in ( '000121', '000122', '000124', '000070', '000031', '000053') and user_pos in ('차장', '과장', '대리', '사원') ) ";
		}else if (s_mon.equals("9")) {
			query = " UPDATE budget  set sep = 0 where byear = ? and  bgubun  ='" + gubun +"' and user_id in (select user_id from users where use_yn = 'Y' and nvl(loan_st, '3' ) = '3'  and user_id not in ( '000121', '000122', '000124', '000070', '000031', '000053') and user_pos in ('차장', '과장', '대리', '사원') ) ";
		}else if (s_mon.equals("10")) {
			query = " UPDATE budget  set oct = 0 where byear = ? and  bgubun = '" + gubun +"' and user_id in (select user_id from users where use_yn = 'Y' and nvl(loan_st, '3' ) = '3'  and user_id not in ( '000121', '000122', '000124', '000070', '000031', '000053') and user_pos in ('차장', '과장', '대리', '사원') ) ";
		}else if (s_mon.equals("11")) {
			query = " UPDATE budget  set nov = 0 where byear = ? and  bgubun = '" + gubun +"' and user_id in (select user_id from users where use_yn = 'Y' and nvl(loan_st, '3' ) = '3'  and user_id not in ( '000121', '000122', '000124', '000070', '000031', '000053') and user_pos in ('차장', '과장', '대리', '사원') ) ";
		}else if (s_mon.equals("12")) {
			query = " UPDATE budget  set dec = 0 where byear = ? and  bgubun = '" + gubun +"' and user_id in (select user_id from users where use_yn = 'Y' and nvl(loan_st, '3' ) = '3'  and user_id not in ( '000121', '000122', '000124', '000070', '000031', '000053') and user_pos in ('차장', '과장', '대리', '사원') ) ";
		}		

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		s_year);
			pstmt.executeUpdate();
			pstmt.close();
			
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[CardDatabase:updateBudgetAmtN\n"+e);
			e.printStackTrace();
	  		ret = "1";
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);			
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ret;
		}
	}		

//청구서 예정, 수령, 미정 확인등록 2008.12.22

public int updatecgs_ok(CardDocBean bean)
    { 
    	getConnection();
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " UPDATE card_doc SET"+
				" cgs_ok = ?,"+
				" cd_reg_id	= ?"+
				" WHERE cardno =? and buy_id = ?";

       try{
            conn.setAutoCommit(false);
                       
            pstmt = conn.prepareStatement(query);
           
            pstmt.setString	(1,	bean.getCgs_ok());
			pstmt.setString	(2,	bean.getCd_reg_id().trim());
			pstmt.setString	(3,	bean.getCardno().trim());
			pstmt.setString	(4,	bean.getBuy_id().trim());
            count = pstmt.executeUpdate();             
            pstmt.close();
            conn.commit();
        
       	}catch(SQLException e){
            try{
				System.out.println("[CardDatabase:updatecgs_ok]"+e);
				System.out.println("[CardDatabase:updatecgs_ok]"+query);
                conn.rollback();
            }catch(SQLException _ignored){}
			e.printStackTrace();
	
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			closeConnection();
		}
		return count;
	}

	/**
	 *	거래처별 카드전표 리스트
	 */	
	public Vector getCardDocVendorList(String ven_code)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select * from card_doc where ven_code='"+ven_code+"' order by buy_dt desc";

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
			System.out.println("[CardDatabase:getCardDocVendorList]\n"+e);
			System.out.println("[CardDatabase:getCardDocVendorList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 *	거래처별 카드전표 리스트
	 */	
	public Vector getCardDocVendorNowYearList(String ven_code)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select * from card_doc where ven_code='"+ven_code+"' and buy_dt like to_char(sysdate,'YYYY')||'%' order by buy_dt desc";


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
			System.out.println("[CardDatabase:getCardDocVendorNowYearList]\n"+e);
			System.out.println("[CardDatabase:getCardDocVendorNowYearList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 *	카드 리스트 -- 5840 페기처리 임시 조회토록 - 20090617 : 폐기된 카드로 입력하는 경우 많음
	 */	
	public Hashtable getCardSearchExcel(String cardno)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select "+
				" a.*, b.*, b.user_id as buy_user_id, c.user_nm as buy_user_nm, d.br_nm, decode(a.card_chk, null, c.user_nm,'',c.user_nm, a.card_chk) user_nm,  nvl(b.user_id,c.user_id) user_code,"+
				" decode(a.limit_st,'1','개별','2','통합') limit_st_nm, decode(a.card_st,'1','구매자금용','2','공용','3','임/직원지급용','4','하이패스','5','세금납부용','6','포인트') card_st_nm"+
				" from card a, card_user b, users c, branch d, (select cardno, max(seq) seq from card_user group by cardno) f"+
				" where"+
				" a.cardno like '%"+cardno+"' and a.cardno=b.cardno(+) and a.user_seq=b.seq(+) and b.cardno=f.cardno(+) and b.seq=f.seq(+) and b.user_id=c.user_id(+) and c.br_id=d.br_id(+)";

		try {
			pstmt = conn.prepareStatement(query);
		    rs = pstmt.executeQuery();
		    
	    	ResultSetMetaData rsmd = rs.getMetaData();
    	
			if(rs.next())
			{				
				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CardDatabase:getCardSearchExcel]\n"+e);
			System.out.println("[CardDatabase:getCardSearchExcel]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}		
	}

	/**
	 *	카드 리스트 -- 5840 페기처리 임시 조회토록 - 20090617 : 폐기된 카드로 입력하는 경우 많음
	 */	
	public Hashtable getCardSearchExcel(String card_st, String cardno)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select "+
				" a.*, b.*, b.user_id as buy_user_id, c.user_nm as buy_user_nm, d.br_nm, decode(a.card_chk, null, c.user_nm,'',c.user_nm, a.card_chk) user_nm,  nvl(b.user_id,c.user_id) user_code,"+
				" decode(a.limit_st,'1','개별','2','통합') limit_st_nm, decode(a.card_st,'1','구매자금용','2','공용','3','임/직원지급용','4','하이패스','5','세금납부용','6','포인트') card_st_nm"+
				" from card a, card_user b, users c, branch d, (select cardno, max(seq) seq from card_user group by cardno) f"+
				" where"+
				" replace(a.cardno,'-','') like replace('%"+cardno+"','-','') ";
		
		if(!card_st.equals("")) query += " and a.card_st='"+card_st+"'";

		query += " and a.cardno=b.cardno(+) and a.user_seq=b.seq(+) and b.cardno=f.cardno(+) and b.seq=f.seq(+) and b.user_id=c.user_id(+) and c.br_id=d.br_id(+)";

		try {
			pstmt = conn.prepareStatement(query);
		    rs = pstmt.executeQuery();
		    
	    	ResultSetMetaData rsmd = rs.getMetaData();
    	
			if(rs.next())
			{				
				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CardDatabase:getCardSearchExcel]\n"+e);
			System.out.println("[CardDatabase:getCardSearchExcel]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}		
	}

	/**
	 *	사원별이력 리스트
	 */	
	public Hashtable getCardUserInfo(String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "", query1 = "", query2 = "";

		query = " select "+
				" a.*, b.*, d.br_nm, e.nm dept_nm, c.user_nm, decode(a.card_st,'1','구매자금용','2','공용','3','임/직원지급용','4','하이패스','5','세금납부용','6','포인트') card_st_nm"+
				" from card a, card_user b, users c, branch d, (select * from code where c_st='0002') e, (select cardno, max(seq) seq from card_user group by cardno) f "+
				" where b.user_id='"+user_id+"' and a.card_st='3' and a.use_yn='Y'"+
				" and a.cardno=b.cardno and a.user_seq=b.seq "+
				" and b.user_id=c.user_id and c.br_id=d.br_id and c.dept_id=e.code(+) and b.cardno=f.cardno and b.seq=f.seq"+
				" and nvl(b.r_use_s_dt,substr(b.use_s_dt,1,8)) <=to_char(sysdate,'YYYYMMDD')"+
				" ";

		query += " order by nvl(b.r_use_s_dt,substr(b.use_s_dt,1,8)) desc, a.card_kind, a.cardno";


		try {
			pstmt = conn.prepareStatement(query);
		    rs = pstmt.executeQuery();
	    	ResultSetMetaData rsmd = rs.getMetaData();
    	
			if(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CardDatabase:getCardUserInfo]\n"+e);
			System.out.println("[CardDatabase:getCardUserInfo]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}		
	}

	/**
	 *	정비 - 명진 & 부경(002105)제외  - 부산은 부경도 카드로 결제가능하다고 함.  - 업무용차량은 카드 결재함. 20171024 수정 
	 */	
	public Vector getServiceList(String s_br, String use_yn, String t_wd, String buy_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

			
 		query = " select  /*+ leading(b)  merge(a) */ \n"+
				"         b.*, a.use_yn, e.firm_nm, d.car_no, c.off_nm , it.item item , it.cnt cnt ,"
				+ "       decode(b.serv_st, '2', '100',  '7', '100',  ac.our_fault_per ) our_fault_per \n"+
				" from    service b , serv_off c, cont a, car_reg d, client e,  accident ac , \n"+
 				"         ( SELECT ff.car_mng_id, ff.serv_id, min(to_char(ee.seq_no || '^' || ee.item ))  item , max(seq_no)  cnt \n"+
				"           FROM   serv_item ee, service ff \n"+
				"           WHERE  ff.car_mng_id= ee.car_mng_id and  ff.serv_id = ee.serv_id \n"+
				"           group by ff.car_mng_id, ff.serv_id \n"+
				"         ) it \n"+
	 			" where   b.serv_dt between '20160101' and  replace('"+buy_dt+"', '-', '') \n"+
				"         and b.serv_st in ( '2', '3', '4', '5', '7', '11' , '13', '12')   \n"+
				"         and b.off_id = c.off_id \n"+
				"         and b.car_mng_id = a.car_mng_id and b.rent_mng_id=a.rent_mng_id and b.rent_l_cd = a.rent_l_cd   and a.rent_l_cd not like 'RM%'  /* and a.car_st <> '4' */ \n"+
				"         and a.car_mng_id=d.car_mng_id and a.client_id=e.client_id \n"+
				"         and b.car_mng_id=ac.car_mng_id(+) and b.accid_id=ac.accid_id(+)  \n"+
				"         and d.car_no||e.firm_nm like '%"+t_wd+"%' \n"+
				"         and b.car_mng_id = it.car_mng_id and b.serv_id = it.serv_id \n"+
				"         and b.jung_st is null \n"+  //정비정산이 안된건만 보이게 -20201202
				"  order by a.use_yn desc, d.car_no, b.serv_dt desc \n";

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
			System.out.println("[CardDatabase:getServiceList]\n"+e);
			System.out.println("[CardDatabase:getServiceList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}
		
	
	//정비관련
	public boolean updateCardDocServiceItem(String car_mng_id, String serv_id, String buy_dt, String call_t_nm, String call_t_tel)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " UPDATE service  set  jung_st = 'C' , set_dt = replace('"+ buy_dt+ "', '-', ''), card_chk = '1' , call_t_nm =? , call_t_tel = ?  where  car_mng_id=? and serv_id=? ";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		call_t_nm);
			pstmt.setString	(2,		call_t_tel);
			pstmt.setString	(3,		car_mng_id);
			pstmt.setString	(4,		serv_id);
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
						
	  	} catch (Exception e) {
			System.out.println("[CardDatabase:updateCardDocServiceItem)]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
			
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}	
	
	
	//카드전표 - 정비내용 등록
	public boolean insertCardDocItem(CardDocItemBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
			
		query = " INSERT INTO card_doc_item ("+
				"	cardno,		"+
				"	buy_id,		"+
				"	seq,	   	"+
				"	ITEM_CODE, 	"+
				"	RENT_L_CD, 	"+
				"	SERV_ID,    "+
				"	ITEM_NAME,  "+
				"	ACCT_CONT,  "+
				"	CALL_T_NM,  "+
				"	CALL_T_CHK,  "+
				"	CALL_T_TEL,  "+						
				"	doc_amt ,  	 "+
				"	o_cau ,  	 "+
				"	oil_liter ,  	 "+
				"	tot_dist    	 "+
				
				" ) VALUES"+
				" ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? )";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getCardno	());
			pstmt.setString	(2,		bean.getBuy_id	());
			pstmt.setString	(3,		bean.getSeq		());
			pstmt.setString	(4,		bean.getItem_code ());
			pstmt.setString	(5,		bean.getRent_l_cd ());
			pstmt.setString	(6,		bean.getServ_id());
			pstmt.setString	(7,		bean.getItem_name	());
			pstmt.setString	(8,		bean.getAcct_cont	());
			pstmt.setString	(9,		bean.getCall_t_nm ());
			pstmt.setString	(10,	bean.getCall_t_chk ());
			pstmt.setString	(11,	bean.getCall_t_tel());			
			pstmt.setInt	(12,	bean.getDoc_amt	());
			pstmt.setString	(13,	bean.getO_cau());
			pstmt.setFloat	(14,	bean.getOil_liter	());
			pstmt.setInt	(15,	bean.getTot_dist	());
			pstmt.executeUpdate();
			pstmt.close();
			
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[CardDatabase:insertCardDocItem(CardDocItemBean bean)]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	
	/**
	 *	정비관련 내역 리스트
	 */	
	public Vector getCardDocItemList(String cardno, String buy_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";

		query = " select "+
				" b.*, s.scan_file "+
				" from card_doc a, card_doc_item b,  service  s "+
				" where a.cardno=b.cardno and a.buy_id=b.buy_id and b.item_code = s.car_mng_id(+) and b.serv_id = s.serv_id(+) ";				 

		if(!cardno.equals(""))		query += " and b.cardno = '"+cardno+"'";
		if(!buy_id.equals(""))		query += " and b.buy_id = '"+buy_id+"'";
		
		query += " order by b.seq ";
	 
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
			System.out.println("[CardDatabase:getCardDocItemList]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}
	
	//카드전표 - 정비관련 삭제
	public boolean deleteCardDocItem(String cardno, String buy_id)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " DELETE from card_doc_item where cardno=? and buy_id=?";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		cardno);
			pstmt.setString	(2,		buy_id);
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[CardDatabase:deleteCardDocItem]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
		
	//카드전표 - 정비관련 결재무효 처리
	public boolean updateCardDocItem(String car_mng_id, String serv_id)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " update service set jung_st = null , set_dt = null, card_chk = null where car_mng_id =? and serv_id=? ";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		car_mng_id);
			pstmt.setString	(2,		serv_id);
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[CardDatabase:deleteCardDocItem]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//카드전표 - 카드번호 수정
	public boolean updateCardDoc(String o_cardno, String o_buy_id, String cardno, String buy_id)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " update card_doc set cardno =  ? , buy_id = ? where cardno =? and buy_id=? ";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		cardno);
			pstmt.setString	(2,		buy_id);
			pstmt.setString	(3,		o_cardno);
			pstmt.setString	(4,		o_buy_id);
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[CardDatabase:updateCardDoc]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	//카드전표 - 카드번호사용자 수정
	public boolean updateCardDocUser(String o_cardno, String o_buy_id, String cardno, String buy_id)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " update card_doc_user set cardno =  ? , buy_id = ? where cardno =? and buy_id=? ";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		cardno);
			pstmt.setString	(2,		buy_id);
			pstmt.setString	(3,		o_cardno);
			pstmt.setString	(4,		o_buy_id);
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[CardDatabase:updateCardDocUser]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}


	//카드전표 - 카드번호차량 수정
	public boolean updateCardDocItem(String o_cardno, String o_buy_id, String cardno, String buy_id)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " update card_doc_item set cardno =  ?, buy_id = ? where cardno =? and buy_id=? ";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		cardno);
			pstmt.setString	(2,		buy_id);
			pstmt.setString	(3,		o_cardno);
			pstmt.setString	(4,		o_buy_id);
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[CardDatabase:updateCardDocItem]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	/**
	 *	카드존재확인
	 */	
	public Hashtable getCardSearchExcelChk(String cardno)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select * from card where replace(cardno,'-','') = replace('"+cardno+"','-','') ";

		try {
			pstmt = conn.prepareStatement(query);
		    rs = pstmt.executeQuery();
		    
	    	ResultSetMetaData rsmd = rs.getMetaData();
    	
			if(rs.next())
			{				
				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CardDatabase:getCardSearchExcelChk]\n"+e);
			System.out.println("[CardDatabase:getCardSearchExcelChk]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}		
	}

	/**
	 *	장기렌트 리스트
	 */	
	public Vector getLongRents(String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.use_yn, a.rent_mng_id, a.rent_l_cd, a.client_id, b.car_no, b.first_car_no, c.firm_nm, b.car_nm, a.car_mng_id, \n"+
				"        nvl(a.mng_id,a.bus_id2) as bus_id2, e.user_nm as bus_nm2, e.user_m_tel, decode(e.dept_id, '0001','영업팀', '0002','고객지원팀', '0003','총무팀', '0005', 'IT팀', '0007','부산지점', '0008','대전지점', '0009','강남지점', '0011','대구지점', '0010','광주지점', '0012','인천지점', '0013', '수원지점','0014', '강서지점','0015', '구로지점','0016', '울산지점','0017', '종로지점','0018', '송파지점' ) as DEPT_NM, \n"+
				"        a.bus_id, e2.user_nm as bus_nm, \n"+
				"        d.mgr_nm, nvl(d.mgr_m_tel,d.mgr_tel) mgr_tel, \n"+
				"        decode(f.rent_way,'1','일반식','기본식') rent_way \n"+
				" from   cont a, car_reg b, client c, car_mgr d, users e, users e2, fee f, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) g \n"+
				" where  a.car_mng_id=b.car_mng_id(+) \n"+
				" and    a.client_id=c.client_id \n"+
				" and    a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+) and nvl(d.mgr_st,'차량이용자')='차량이용자' \n"+
				" and    nvl(a.mng_id,a.bus_id2)=e.user_id "+
				" and    a.bus_id=e2.user_id "+
				" and    a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd "+
				" and    f.rent_mng_id=g.rent_mng_id and f.rent_l_cd=g.rent_l_cd and f.rent_st=g.rent_st "+
				" ";

		if(!t_wd.equals(""))		query += " and b.car_no||b.first_car_no||c.firm_nm like '%"+t_wd+"%'";

		query += " order by a.use_yn desc, b.car_no";


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
			System.out.println("[CardDatabase:getLongRents]\n"+e);
			System.out.println("[CardDatabase:getLongRents]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}


	/**
	 *	카드관리 리스트-기명식
	 */	
		public Hashtable getCardMngListKMS(String cardno, String name)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";


     	query = " select "+
				" a.*, b.*, d.br_nm, c.user_nm,"+
				" decode(a.limit_st,'1','개별','2','통합') limit_st_nm, decode(a.card_st,'1','구매자금용','2','공용','3','임/직원지급용','4','하이패스','5','세금납부용','6','포인트') card_st_nm"+
				" from card a, (select * from card_user where (cardno, seq) in (select cardno, max(seq) seq from card_user group by cardno)) b,"+
				" users c, branch d"+
				" where"+
				" a.cardno=b.cardno(+) and b.user_id=c.user_id(+) and c.br_id=d.br_id(+) AND a.card_name LIKE '%"+name+"%' and a.cardno =  '"+cardno+"'";

		query += " order by a.card_kind, a.card_st, a.cardno";

		
		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next())
			{								
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
		    rs.close();
            pstmt.close();	


		} catch (SQLException e) {
			System.out.println("[CardDatabase:getCardMngListKMS]\n"+e);
			System.out.println("[CardDatabase:getCardMngListKMS]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
    }


/**
	 *	사원검색 
	 */	
	public Vector getUserSearchListPP(String user_id, String br_id, String dept_id, String t_wd, String use_yn)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = " select a.*, b.br_nm, c.nm as dept_nm \n"+
				" from   users a, branch b, code c, (SELECT user_id, max(jg_dt) jg_dt FROM INSA_POS GROUP BY user_id) d \n"+
				" where  a.br_id=b.br_id(+) and c.c_st='0002' and a.dept_id=c.code AND a.user_id=d.user_id(+) \n"+
				"        and a.dept_id not in ('8888') \n"+
				"        and ( a.user_id = ( SELECT SUBSTR( user_group, 1, INSTR( user_group, '/', 1, 1 ) - 1 ) up1 FROM USERS WHERE user_id = '"+user_id+"' ) \n"+
				"           OR a.user_id = ( SELECT SUBSTR( user_group, INSTR( user_group, '/', 1, 1  ) + 1, INSTR( user_group, '/', 1, 2  ) - INSTR( user_group, '/', 1, 1  ) - 1 ) up2  FROM USERS WHERE user_id = '"+user_id+"' ) \n"+
				"           OR a.user_id = ( SELECT SUBSTR( user_group, INSTR( user_group, '/', 1, 2  ) + 1, INSTR( user_group, '/', 1, 3  ) - INSTR( user_group, '/', 1, 2  ) - 1 ) up3  FROM USERS WHERE user_id = '"+user_id+"' ) \n "+
				"           OR a.user_id = ( SELECT SUBSTR( user_group, INSTR( user_group, '/', 1, 3  ) + 1, INSTR( user_group, '/', 1, 4  ) - INSTR( user_group, '/', 1, 3  ) - 1 ) up4  FROM USERS WHERE user_id = '"+user_id+"' ) \n"+
				"           OR a.user_id = ( SELECT SUBSTR( user_group, INSTR( user_group, '/', 1, 4  ) + 1, INSTR( user_group, '/', 1, 5  ) - INSTR( user_group, '/', 1, 4  ) - 1 ) up5  FROM USERS WHERE user_id = '"+user_id+"' ) \n"+
				"           OR a.user_id = ( SELECT SUBSTR( user_group, INSTR( user_group, '/', 1, 5  ) + 1, INSTR( user_group, '/', 1, 6  ) - INSTR( user_group, '/', 1, 5  ) - 1 ) up6  FROM USERS WHERE user_id = '"+user_id+"' ) \n"+
				"           OR a.user_id = ( SELECT SUBSTR( user_group, INSTR( user_group, '/', 1, 6  ) + 1, INSTR( user_group, '/', 1, 7  ) - INSTR( user_group, '/', 1, 6  ) - 1 ) up7  FROM USERS WHERE user_id = '"+user_id+"' ) \n"+
				"           OR a.user_id = ( SELECT SUBSTR( user_group, INSTR( user_group, '/', 1, 7  ) + 1, INSTR( user_group, '/', 1, 8  ) - INSTR( user_group, '/', 1, 7  ) - 1 ) up8  FROM USERS WHERE user_id = '"+user_id+"' ) \n"+
				"           OR a.user_id = ( SELECT SUBSTR( user_group, INSTR( user_group, '/', 1, 8  ) + 1, INSTR( user_group, '/', 1, 9  ) - INSTR( user_group, '/', 1, 8  ) - 1 ) up9  FROM USERS WHERE user_id = '"+user_id+"' ) \n"+
				"           OR a.user_id = ( SELECT SUBSTR( user_group, INSTR( user_group, '/', 1, 9  ) + 1, INSTR( user_group, '/', 1, 10 ) - INSTR( user_group, '/', 1, 9  ) - 1 ) up10 FROM USERS WHERE user_id = '"+user_id+"' ) \n"+
				"           OR a.user_id = ( SELECT SUBSTR( user_group, INSTR( user_group, '/', 1, 10 ) + 1, INSTR( user_group, '/', 1, 11 ) - INSTR( user_group, '/', 1, 10 ) - 1 ) up11 FROM USERS WHERE user_id = '"+user_id+"' ) \n"+
				"        ) ";

		query += " order by decode(a.user_id, '000053', '6', DECODE(a.USER_POS, '대표이사', '1', '부장', '3', '팀장', '4', '차장' , '5', '과장' , '6', '대리', '7', '사원', '8', '9' )) , nvl(d.jg_dt,a.enter_dt), a.enter_dt, a.user_nm ";


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
			System.out.println("[CardDatabase:getUserSearchListPP]\n"+e);
			System.out.println("[CardDatabase:getUserSearchListPP]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}


/**
	 *	사원검색 -- 전체선택시 채권팀제외
	 */	
	public Vector getUserSearchListCD(String br_id, String dept_id, String t_wd, String use_yn)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query =	" select a.DEPT_ID, a.USER_ID, a.USER_NM, a.ID, a.USER_M_TEL, \n"+
				"        decode(a.user_pos,'대표이사',0,'부장', 1, '차장', 2, '팀장', 3, '과장', 4 , '대리', 5, 9) POS, \n"+
				"        a.enter_dt, nvl(b.jg_dt,a.enter_dt) jg_dt, '1' st \n"+
				" from   USERS a, (SELECT user_id, max(jg_dt) jg_dt FROM INSA_POS GROUP BY user_id) b \n"+
				" where  a.user_id=b.user_id(+) \n"+
				" ";


		if(!br_id.equals(""))	 query += " and nvl(a.br_id,'"+br_id+"') = '"+br_id+"'";
						
		if(!dept_id.equals(""))		query += " and a.dept_id='"+dept_id+"'";

		if(!t_wd.equals("")) {
				if (t_wd.equals("TT")) {
							query += " and a.user_nm in ('정채달', '안보국', '허승범', '조성희') ";
				} else if ( t_wd.equals("AA")) {
							query += " and a.user_id not in ( '000102', '000203') and a.dept_id not in ('1000', '8888')  ";
				}			
		}
		
		if(!use_yn.equals(""))		query += " and a.use_yn='"+use_yn+"'";

			query +=" union \n"+
					" SELECT a.dept_id, '10'||a.dept_id AS user_id, '='||MIN(b.nm)||'=' user_nm, '' id, '' user_m_tel, 9 AS pos, '' enter_dt, '' jg_dt, '0' st  \n"+
					" FROM   USERS a, (SELECT * FROM CODE WHERE c_st='0002') b  \n"+
					" WHERE  a.use_yn='Y' AND a.dept_id=B.CODE \n"+
					" GROUP BY a.dept_id HAVING count(0)>0 \n"+
					" ";

			       


		query += " ORDER BY dept_id, st, pos, jg_dt, enter_dt, user_nm ";



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
			System.out.println("[CardDatabase:getUserSearchListCD]\n"+e);
			System.out.println("[CardDatabase:getUserSearchListCD]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}




/**
     *  첨부 파일 삭제
     */
    public int updateCardScan(String cardno, String buy_id) {
		getConnection();
            
 		int result = 0;
		PreparedStatement pstmt = null;
		String query = "";


               query=" UPDATE  CARD_DOC SET card_file = '' WHERE cardno = '"+cardno+"' and buy_id = '"+buy_id+"' " ;				

	try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
		    result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
	  		System.out.println("[CardDatabase:updateCardScan]\n"+e);
			System.out.println("[CardDatabase:updateCardScan]\n"+query);
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return result;
		}
	}


	/**
     *  card 첨부 파일 수정
     */
    public int updateCardScan2(String cardno, String buy_id, String card_file) {
		getConnection();
            
 		int result = 0;
		PreparedStatement pstmt = null;
		String query = "";


               query=" UPDATE  CARD_DOC SET card_file = '"+card_file+"' WHERE cardno = '"+cardno+"' and buy_id = '"+buy_id+"' " ;				

	try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
		    result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
	  		System.out.println("[CardDatabase:updateCardScan]\n"+e);
			System.out.println("[CardDatabase:updateCardScan]\n"+query);
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return result;
		}
	}


       
	/**
	 *	부서장 카드전표 확인관련 - getCardDocList(s_kd, t_wd, st_dt, end_dt, gubun1, gubun2, gubun3, gubun4)
	 */	
	public Vector getCardDocList(String s_kd, String t_wd, String st_dt, String end_dt, String gubun1, String gubun2, String gubun3, String gubun4)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";

		query = " select  \n"+
				" c.dept_id, decode(c.dept_id,'0001','영업팀','0002','고객지원팀','0003','총무팀', '00004', '임원', '0005', '채권관리팀','0007','부산지점','0008','대전지점','기타') as dept_nm , \n"+
				" a.buy_dt,  a.chief_id,  \n"+
				 " count(a.buy_user_id) buy_cnt, sum(a.buy_amt) buy_amt  \n"+
				" from card_doc a, card b, users c \n"+
				" where a.cardno=b.cardno  and nvl(a.buy_user_id,a.reg_id)=c.user_id(+)  and a.card_file is not null \n"+
				"      and a.acct_code||a.acct_code_g||a.acct_code_g2 not in ('0000112')   and  a.acct_code||a.acct_code_g2 not in ('0000411') and a.acct_code||a.acct_code_g not in ('000012')  \n";
	
		//기간조회
		if(gubun1.equals("1"))		query += " and a.buy_dt=to_char(sysdate,'YYYYMMDD')";
		if(gubun1.equals("2"))		query += " and a.buy_dt=to_char(sysdate -1 ,'YYYYMMDD')";
		if(gubun1.equals("3"))		query += " and a.buy_dt like to_char(sysdate,'YYYYMM')||'%'";
		if(gubun1.equals("4"))		query += " and a.buy_dt like to_char(sysdate,'YYYYMM')||'%'";
		if(gubun1.equals("5")){
			if(!st_dt.equals("") && !end_dt.equals(""))		query += " and a.buy_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";
			if(!st_dt.equals("") && end_dt.equals(""))		query += " and a.buy_dt = replace('"+st_dt+"','-','')";
		}
		
		//확인여부
		if(gubun2.equals("2"))		query += " and a.chief_id is not null";
		if(gubun2.equals("1"))		query += " and a.chief_id is null";
		
		//계정과목
		if(!gubun3.equals(""))		query += " and a.acct_code = '"+gubun3+"'";
		
		//부서
				//부서
		if(!t_wd.equals(""))		query += " and c.dept_id = '"+t_wd+"'";
		
		query += " group by c.dept_id, a.buy_dt,  a.chief_id  \n";
		query += " order by decode(c.dept_id,'0004',1,2), c.dept_id,  a.buy_dt ";



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
			System.out.println("[CardDatabase:getCardDocList]\n"+e);
			System.out.println(query);
			e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

   
	/**
	 *	부서장 카드전표 확인관련 - getCardDocList(s_kd, t_wd, st_dt, end_dt, gubun1, gubun2, gubun3, gubun4)  - 중식대, 복지비,업무용차량 유류대 제외한 전체/	
	*/
public Vector getCardDocList2( String gubun1,  String gubun3,   String st_dt, String end_dt, String buy_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";

		String acct_code_g_nm	= "decode(a.acct_code_g,'','-','1','식대','2','복지비','15','경조사', '3','기타' , '30', '포상휴가', '13','가솔린','4','디젤','5','LPG','27','전기차충전','6','일반정비','7','자동차검사','8','정밀검사','9','출장비','10','기타교통비','11','식대','12','경조사','14','기타','18','번호판대금','19','차량등록세','20','하이패스', '21', '재리스정비', '---')";
		String acct_code_g2_nm	= "decode(a.acct_code_g2,'1','-조식','2','-중식','3','-특근식','4','-회사전체모임','5','-부서별정기모임','6','-부서별부정기회식','7','-커피','8','-음료','9','-약품','10','-그외','11','-업무차량','12','-예비차량','13','-고객차량','---')";

		query = " select \n"+
				" a.*,  decode(a.app_id,'','미승인','승인') app_st, decode(a.chief_id,'','미확인','확인') chief,\n"+
				" decode(a.acct_code, '00001','복리후생비', '00002','접대비', '00003','여비교통비', '00004','차량유류대', '00005','차량정비비', '00006','사고수리비', '00007','사무용품비', '00008','소모품비', '00009','통신비', '00010','도서인쇄비', '00011','지급수수료', '00012','비품', '00013','선급금', '00014','교육훈련비', '00015','세금과공과', '00016','대여사업차량', '00017','리스사업차량', '00018','운반비', '00019','주차요금', '00020', '보험료', '00021', '업무비선급금' , '00023', '광고선전비') acct_code_nm,\n"+
				" "+acct_code_g_nm+" acct_code_g_nm, \n"+
				" "+acct_code_g2_nm+" acct_code_g2_nm, \n"+
				" c.user_nm, \n"+
				" b.card_mng_id, b.doc_mng_id, d.user_nm as owner_nm \n"+
				" from card_doc a, card b, users c, card_user cu,  ( select cardno, max(seq) as seq from card_user group by cardno) u , (select user_id, user_nm from users ) d \n"+
				" where a.cardno=b.cardno   and a.card_file is not null \n"+
				" and nvl(a.buy_user_id,a.reg_id)=c.user_id(+) \n"+
				" and a.cardno=u.cardno \n"+
				" and cu.cardno=u.cardno \n"+
				" and cu.seq=u.seq and cu.user_id =d.user_id(+) \n"+
				" and a.acct_code||a.acct_code_g||a.acct_code_g2 not in ('0000112')  and  a.acct_code||a.acct_code_g2 not in ('0000411')  and a.acct_code||a.acct_code_g not in ('000012') ";


	 //기간조회
		if(gubun1.equals("1"))		query += " and a.buy_dt=to_char(sysdate,'YYYYMMDD')";
		if(gubun1.equals("2"))		query += " and a.buy_dt=to_char(sysdate -1 ,'YYYYMMDD')";
		if(gubun1.equals("3"))		query += " and a.buy_dt like to_char(sysdate,'YYYYMM')||'%'";
		if(gubun1.equals("4"))		query += " and a.buy_dt like to_char(sysdate,'YYYYMM')||'%'";
		if(gubun1.equals("5")){
			if(!st_dt.equals("") && !end_dt.equals(""))		query += " and a.buy_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";
			if(!st_dt.equals("") && end_dt.equals(""))		query += " and a.buy_dt = replace('"+st_dt+"','-','')";
		}
	
		//사용일
		if(!buy_dt.equals(""))		query += " and a.buy_dt = replace('"+buy_dt+"' , '-', '') ";
		
			//부서
		if(!gubun3.equals(""))		query += " and c.dept_id = '"+gubun3+"'";
								
		query += " order by  a.buy_dt, decode(a.app_id,'',1,2), decode(c.br_id,'S1',1,'B1',2,'S2',3), decode(c.dept_id,'0004',1,2), decode(c.user_pos,'대리','2','사원',3,1), c.user_id";



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
			System.out.println("[CardDatabase:getCardDocList2]\n"+e);
			System.out.println(query);
			e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	
	//카드전표 부서장 확인 등록
	public boolean updateCardDocChiefId(String cardno, String buy_id, String chief_id)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " update  card_doc set  cgs_ok = 'Y',  chief_id = ?  where cardno=? and buy_id=?";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		chief_id);
			pstmt.setString	(2,		cardno);
			pstmt.setString	(3,		buy_id);
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[CardDatabase:updateCardDocChiefId)]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	

	/**
	 *	전표 한건 조회
	 *  
	 */	
	public CardDocBean getCardDocCons(String car_no, String cons_no, String seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		CardDocBean bean = new CardDocBean();
		String query = "";

		query = " select * from card_doc where item_name = '"+car_no+"' and substr(cons_no,1,12) = '"+cons_no+"' and substr(cons_no, 13,1) = '"+seq+"' ";


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{			
				bean.setCardno				(rs.getString(1));
				bean.setBuy_id				(rs.getString(2));
				bean.setBuy_dt				(rs.getString(3));
				bean.setBuy_s_amt			(rs.getInt(4));
				bean.setBuy_v_amt			(rs.getInt(5));
				bean.setBuy_amt				(rs.getInt(6));
				bean.setVen_code			(rs.getString(7));
				bean.setVen_name			(rs.getString(8));
				bean.setAcct_code			(rs.getString(9));
				bean.setAcct_code_g			(rs.getString(10));
				bean.setAcct_code_g2		(rs.getString(11));
				bean.setItem_code			(rs.getString(12));
				bean.setItem_name			(rs.getString(13));
				bean.setAcct_cont			(rs.getString(14));
				bean.setUser_su				(rs.getString(15));
				bean.setUser_cont			(rs.getString(16));
				bean.setReg_id				(rs.getString(17));
				bean.setReg_dt				(rs.getString(18));
				bean.setApp_id				(rs.getString(19));
				bean.setApp_dt				(rs.getString(20));
				bean.setApp_code			(rs.getString(21));
				bean.setAutodocu_write_date	(rs.getString(22));
				bean.setAutodocu_data_no	(rs.getString(23));
				bean.setBuy_user_id			(rs.getString(24));
				bean.setRent_l_cd			(rs.getString(25));
				bean.setChief_id			(rs.getString(26));
				bean.setTax_yn				(rs.getString(27));
				bean.setVen_st				(rs.getString(28));
				bean.setO_cau				(rs.getString(31));
				bean.setCall_t_nm			(rs.getString(32));
				bean.setCall_t_tel			(rs.getString(33));
				bean.setCall_t_chk			(rs.getString(34));
				bean.setServ_id				(rs.getString(35));
				bean.setCard_file			(rs.getString("card_file")		==null?"":rs.getString("card_file"));
				bean.setM_doc_code			(rs.getString("m_doc_code")		==null?"":rs.getString("m_doc_code"));
				bean.setFile_path			(rs.getString("file_path")		==null?"":rs.getString("file_path"));
				bean.setOil_liter			(rs.getFloat("oil_liter"));
				bean.setTot_dist			(rs.getInt("tot_dist"));
				bean.setSiokno			(rs.getString("siokno")		==null?"":rs.getString("siokno"));
				bean.setCons_no			(rs.getString("cons_no")		==null?"":rs.getString("cons_no"));
						
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CardDatabase:getCardDocCons(String cardno)]\n"+e);
			System.out.println("[CardDatabase:getCardDocCons(String cardno)]\n"+query);
	  		e.printStackTrace();
			System.out.println(query);
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}		
	}

	/**
	 *	전표 한건 조회
	 *  
	 */	
	public CardDocBean getCardDocCons(String car_no, String cons_no, String seq, String gubun)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		CardDocBean bean = new CardDocBean();
		String query = "";

		String acct_code = "";
		if ( gubun.equals("o")) { 
			acct_code ="00004";  //유류대
		} else {
			acct_code ="00005";  //정비비 - 세차 
		}	
				
		query = " select * from card_doc where acct_code ='"+ acct_code + "' and item_name = '"+car_no+"' and substr(cons_no,1,12) = '"+cons_no+"' and substr(cons_no, 13,1) = '"+seq+"' ";


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{			
				bean.setCardno				(rs.getString(1));
				bean.setBuy_id				(rs.getString(2));
				bean.setBuy_dt				(rs.getString(3));
				bean.setBuy_s_amt			(rs.getInt(4));
				bean.setBuy_v_amt			(rs.getInt(5));
				bean.setBuy_amt				(rs.getInt(6));
				bean.setVen_code			(rs.getString(7));
				bean.setVen_name			(rs.getString(8));
				bean.setAcct_code			(rs.getString(9));
				bean.setAcct_code_g			(rs.getString(10));
				bean.setAcct_code_g2		(rs.getString(11));
				bean.setItem_code			(rs.getString(12));
				bean.setItem_name			(rs.getString(13));
				bean.setAcct_cont			(rs.getString(14));
				bean.setUser_su				(rs.getString(15));
				bean.setUser_cont			(rs.getString(16));
				bean.setReg_id				(rs.getString(17));
				bean.setReg_dt				(rs.getString(18));
				bean.setApp_id				(rs.getString(19));
				bean.setApp_dt				(rs.getString(20));
				bean.setApp_code			(rs.getString(21));
				bean.setAutodocu_write_date	(rs.getString(22));
				bean.setAutodocu_data_no	(rs.getString(23));
				bean.setBuy_user_id			(rs.getString(24));
				bean.setRent_l_cd			(rs.getString(25));
				bean.setChief_id			(rs.getString(26));
				bean.setTax_yn				(rs.getString(27));
				bean.setVen_st				(rs.getString(28));
				bean.setO_cau				(rs.getString(31));
				bean.setCall_t_nm			(rs.getString(32));
				bean.setCall_t_tel			(rs.getString(33));
				bean.setCall_t_chk			(rs.getString(34));
				bean.setServ_id				(rs.getString(35));
				bean.setCard_file			(rs.getString("card_file")		==null?"":rs.getString("card_file"));
				bean.setM_doc_code			(rs.getString("m_doc_code")		==null?"":rs.getString("m_doc_code"));
				bean.setFile_path			(rs.getString("file_path")		==null?"":rs.getString("file_path"));
				bean.setOil_liter			(rs.getFloat("oil_liter"));
				bean.setTot_dist			(rs.getInt("tot_dist"));
				bean.setSiokno			(rs.getString("siokno")		==null?"":rs.getString("siokno"));
				bean.setCons_no			(rs.getString("cons_no")		==null?"":rs.getString("cons_no"));
						
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CardDatabase:getCardDocCons(String cardno)]\n"+e);
			System.out.println("[CardDatabase:getCardDocCons(String cardno)]\n"+query);
	  		e.printStackTrace();
			System.out.println(query);
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}		
	}


	/* 복지비 사용 내역 */
	 public Vector getCardJungDtStatG4NewSubList(String dt, String user_id, String acct_code, String acct_code_g)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
     	
		
		query =	" select u.user_id, u.user_nm, s.user_nm as reg_nm, h.cardno, h.ven_name, h.acct_cont, h.buy_amt, h.reg_id, h.reg_dt, h.doc_amt  \n"+
				" from   users u ,  \n"+
				"		 ( select a.cardno, a.ven_name, a.acct_cont, a.buy_amt, a.reg_id, a.reg_dt, b.doc_user, b.doc_amt "+
				"          from   card_doc a, card_doc_user b "+
				"	       where  a.buy_dt='"+dt+"' and a.cardno = b.cardno and a.buy_id = b.buy_id \n";

		if(!acct_code.equals("")){
			query += " and a.acct_code = '"+acct_code+"' ";

			if(!acct_code_g.equals("")){
				query += " and a.acct_code_g = '"+acct_code_g+"' ";
			}
		}

		if(!user_id.equals("")){
			query += " and b.doc_user='"+user_id+"'";
		}

		query += "		 ) h, users s " +
				"	where u.user_id = h.doc_user and h.reg_id=s.user_id " ;									


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
			System.out.println("[CardDatabase:getCardJungDtStatG4NewSubList]\n"+e);
	  		e.printStackTrace();
			System.out.println(query);
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}



	//집계 - 팀장이상도 중식대 포함하여 일단 정산함.  이월시 복지비로만 이월 - 20120117
	//성승현 - 그리드로 변경하기 위해 json 형태로 변환 - 20160603
	public JSONArray getCardJungDtStatINewJson(String dt, String ref_dt1, String ref_dt2, String br_id, String dept_id, String user_nm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		String query = "";
   	
		String f_date1="";
		String t_date1="";
	
		String s_year = Integer.toString(AddUtil.getDate2(1));	
		String s_month =Integer.toString(AddUtil.getDate2(2));	
		s_month = AddUtil.addZero(s_month);
		
		if(dt.equals("2")) {
			f_date1 = s_year+ s_month + "01";
			t_date1 = s_year+ s_month + "31";
		}
		
		if(dt.equals("3")) {
			f_date1 = s_year+ "0101";
			t_date1 = s_year+ "1231";
		}
		
		if(dt.equals("4")) {
			f_date1=  ref_dt1;
			t_date1=  ref_dt2;
		}		
		
		query = " select u.use_yn, a.user_id, u.user_nm,  u.user_pos, u.br_id,  c.br_nm, decode(u.br_id,'S1','B1','2','D1','3','4') as br_sort, " +
				"	    decode(u.user_pos,'대표이사',1,'이사', 2, '팀장', 3, '차장', 4 , '과장', 5, '대리', 6, 9) pos_sort, u.dept_id, e.nm  as dept_nm,   " +  
				"	    decode(u.dept_id,'0004',1,'0001', 2, '0002', 3, '0003', 4 , '8888', 5, 9) dept_sort, " +  
				" 		sum(a.w_cnt) as w_cnt, sum(a.basic_amt) as basic_amt, sum(a.real_amt) as real_amt, sum(a.remain_amt) as remain_amt , decode(sum(a.remain_amt) , 0, '1', '2') as remain_sort, " +
				"		nvl(sum(a.g2_1_amt), 0) as g2_1_amt, nvl(sum(a.g2_3_amt), 0) as g2_3_amt, nvl(sum(a.g3_amt), 0) as g3_amt, nvl(sum(a.g2_amt), 0) as g2_amt,  sum(a.g4_amt) as g4_amt, nvl(sum(a.g15_amt), 0) as g15_amt, sum(a.budget_amt) as budget_amt, sum(a.sbudget_amt) as sbudget_amt, sum(a.ebudget_amt) as ebudget_amt, "+
				"		sum(a.g_2_4_amt) as g_2_4_amt, nvl(sum(a.g_3_4_amt), 0)  as g_3_4_amt,  nvl(sum(a.g30_amt), 0) as g30_amt, sum(a.t_basic_amt) as t_basic_amt,  sum(a.t_real_amt) as t_real_amt, sum(a.oil_amt) as oil_amt  " +
				" from  (  " +		
				"	select u.use_yn,  u.user_id, a.w_cnt, a.basic_amt, f.budget_amt,fs.sbudget_amt,  fe.ebudget_amt, a.real_amt, a.remain_amt, b.g2_1_amt, c.g2_3_amt, d.g3_amt, e.g2_amt, g.g4_amt, gg.g15_amt, h.g_2_4_amt, he.g_3_4_amt, k.g30_amt, r.t_basic_amt, r.t_real_amt ,  oi.oil_amt from  users u ,  " +				
				"		 ( select   a.user_id,  sum(decode(a.remark, 'W', 1, 0)) as w_cnt, sum(a.basic_amt) as basic_amt, sum(a.real_amt) as real_amt, sum(a.remain_amt) as remain_amt " +
				"				         from card_doc_jungsan a       where a.jung_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') group by a.user_id ) a, " +
				"		 ( select  b.doc_user, sum(b.doc_amt)  as g2_1_amt  from card_doc a, card_doc_user  b	where a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and a.acct_code = '00001' and a.acct_code_g = '1' and a.acct_code_g2 = '1'  and  " +
				"			      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user ) b , " +
				"		 ( select  b.doc_user, sum(b.doc_amt)  as g2_3_amt from card_doc a, card_doc_user  b	where a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and a.acct_code = '00001' and a.acct_code_g = '1' and a.acct_code_g2 = '3'  and  " + 
				"			      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user ) c , " +
				"		 ( select  b.doc_user, sum(b.doc_amt)  as g3_amt from card_doc a, card_doc_user  b	where a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and a.acct_code = '00001' and a.acct_code_g = '3' and " + 
				"			      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user ) d , " +
				"		 ( select  b.doc_user, sum(b.doc_amt)  as g2_amt from card_doc a, card_doc_user  b	where a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and a.acct_code = '00001' and a.acct_code_g = '2' and " + 
				"			      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user ) e, " +
				"		 ( select  b.doc_user, sum(b.doc_amt)  as g4_amt from card_doc a, card_doc_user  b	where a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and a.acct_code = '00001' and a.acct_code_g = '4' and " + 
				"			      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user ) g, " +
				"		 ( select  b.doc_user, sum(b.doc_amt)  as g15_amt from card_doc a, card_doc_user  b	where a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and a.acct_code = '00001' and a.acct_code_g = '15' and " + 
				"			      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user ) gg, " +
				"		 ( select  b.doc_user, sum(b.doc_amt)  as g_2_4_amt from card_doc a, card_doc_user  b	where a.buy_dt like substr('" + f_date1 + "',1,4)||'%'  and a.acct_code = '00001' and a.acct_code_g  in ('2', '4' , '30') and " + 
				"			      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user ) h, " +
				"		 ( select  b.doc_user, sum(b.doc_amt)  as g_3_4_amt from card_doc a, card_doc_user  b	where a.buy_dt like substr('" + f_date1 + "',1,4)||'%'  and a.acct_code = '00001' and a.acct_code_g  in ('3') and " + 
				"			      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user ) he, " +
				"		 ( select  b.doc_user, sum(b.doc_amt)  as g30_amt from card_doc a, card_doc_user  b	where a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and a.acct_code = '00001' and a.acct_code_g  = '30' and " + 
				"			      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user ) k, " +
				"		 ( select  a.user_id, sum(a.jung_amt)  as oil_amt from stat_car_oil a where a.save_dt like substr('" + f_date1 + "',1,4)||'%' and magam = 'Y'  and a.save_dt < '20120601' group by a.user_id ) oi, " +
				"		 ( select  a.user_id, sum(a.prv+a.jan+a.feb+a.mar+a.apr+a.may+a.jun+a.jul+a.aug+a.sep+a.oct+a.nov+a.dec)  as budget_amt from budget a where a.byear = substr('" + f_date1 + "',1,4) and a.bgubun = '1' group by a.user_id ) f, " +
				"        ( select  a.user_id, sum(a.jan1+a.feb1+a.mar1+a.apr1+a.may1+a.jun1+a.jul1+a.aug1+a.sep1+a.oct1+a.nov1+a.dec1)  as sbudget_amt from budget a where a.byear = substr('" + f_date1 + "',1,4) and a.bgubun = '1' group by a.user_id ) fs, " +
				"		 ( select  a.user_id, sum(a.prv+a.jan+a.feb+a.mar+a.apr+a.may+a.jun+a.jul+a.aug+a.sep+a.oct+a.nov+a.dec)  as ebudget_amt from budget a where a.byear = substr('" + f_date1 + "',1,4) and a.bgubun = '3' group by a.user_id ) fe, " +
				"		 ( select  a.user_id, sum(a.basic_amt) as t_basic_amt, sum(a.real_amt)  as t_real_amt from card_doc_jungsan a where a.jung_dt like substr('" + f_date1 + "',1,4)||'%'  group by a.user_id ) r " +
				"	where u.user_id = a.user_id(+) and u.user_id = b.doc_user(+) and u.user_id = c.doc_user(+) and u.user_id = d.doc_user(+) and u.user_id = e.doc_user(+) and u.user_id = g.doc_user(+) and u.user_id = gg.doc_user(+) and u.user_id = f.user_id(+) and u.user_id = fs.user_id(+) and u.user_id = fe.user_id(+) and u.user_id = h.doc_user(+)  and u.user_id = he.doc_user(+)  and u.user_id = k.doc_user(+) and u.user_id = r.user_id(+)and u.user_id = oi.user_id(+) ) a, users u ," +
				" branch c,  ( select c_st, code, nm_cd, nm from code where c_st = '0002' and code <> '0000'  )  e  \n"+
				" where a.user_id = u.user_id    and u.br_id=c.br_id and u.dept_id = e.code     and a.user_id not in ('000035','000177','000203','000238','000285','000302','000329','000293','000330') and u.id not like 'develop%'  and u.dept_id not in ('8888' , '1000') and nvl(u.m_yn, 'Y' ) = 'Y' and ( u.use_yn = 'Y' or u.out_dt > replace('" + f_date1 + "','-','')  ) " ;
							
				
		if(!br_id.equals(""))	query += " and u.br_id='"+br_id+"' ";
		if(!dept_id.equals("")) query += " and u.dept_id='"+dept_id+"' ";
		if(!user_nm.equals("")) query += " and u.user_nm like '%"+user_nm+"%' ";		
						
		query += " group by u.use_yn, a.user_id, u.user_nm, u.user_pos, u.br_id, u.dept_id  , c.br_nm, e.nm ";
		query +="  order by 1 desc, decode(u.user_pos,'대표이사',1,'이사',2,'팀장',4, 5), DECODE(a.user_id, '000004',1,'000005',2,4), decode(u.dept_id,'0020','0000',u.dept_id), decode(a.user_id, '000237', '0', decode(u.user_pos, '팀장', 0, '부장', 1, '차장', 2, '과장',3,'대리', 4, 5)),a.user_id ";
			
		try {
			pstmt = conn.prepareStatement(query);
		    rs = pstmt.executeQuery();
		    ResultSetMetaData rsmd = rs.getMetaData();
  		   
			while(rs.next())
			{	
				JSONObject obj = new JSONObject();
		       JSONArray jarr = new JSONArray();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 obj.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				
				jsonArray.add(obj);	
			}
				     
			rs.close();
			pstmt.close();
	          
		} catch (SQLException e) {
			System.out.println("[CardDatabase:getCardJungDtStatINewJson]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return jsonArray;
		}		
	}
	
	
public JSONObject getCardJungDtStatINewJsonT(String dt, String ref_dt1, String ref_dt2, String br_id, String dept_id, String user_nm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		JSONObject jsonroot=new JSONObject();
			
		List<JSONObject> resList = new ArrayList<JSONObject>();
				
		String query = "";
   	
		String f_date1="";
		String t_date1="";
	
		int count = 0;
			
			
		String s_year = Integer.toString(AddUtil.getDate2(1));	
		String s_month =Integer.toString(AddUtil.getDate2(2));	
		s_month = AddUtil.addZero(s_month);
		
		if(dt.equals("2")) {
			f_date1 = s_year+ s_month + "01";
			t_date1 = s_year+ s_month + "31";
		}
		
		if(dt.equals("3")) {
			f_date1 = s_year+ "0101";
			t_date1 = s_year+ "1231";
		}
		
		if(dt.equals("4")) {
			f_date1=  ref_dt1;
			t_date1=  ref_dt2;
		}
		
		query = " select  u.use_yn, a.user_id, u.user_nm,  u.user_pos, u.br_id,  c.br_nm, decode(u.br_id,'S1','B1','2','D1','3','4') as br_sort, " +
				"	    decode(u.user_pos,'대표이사',1,'이사', 2, '팀장', 3, '차장', 4 , '과장', 5, '대리', 6, 9) pos_sort, u.dept_id, e.nm  as dept_nm,   " +  
				"	    decode(u.dept_id,'0004',1,'0001', 2, '0002', 3, '0003', 4 , '8888', 5, 9) dept_sort, " +  
				" 		sum(a.w_cnt) as w_cnt, sum(a.basic_amt) as basic_amt, sum(a.real_amt) as real_amt, sum(a.remain_amt) as remain_amt , decode(sum(a.remain_amt) , 0, '1', '2') as remain_sort, " +
				"		nvl(sum(a.g2_1_amt), 0) as g2_1_amt, nvl(sum(a.g2_3_amt), 0) as g2_3_amt, nvl(sum(a.g3_amt), 0) as g3_amt, nvl(sum(a.g2_amt), 0) as g2_amt,  sum(a.g4_amt) as g4_amt, nvl(sum(a.g15_amt), 0) as g15_amt, sum(a.budget_amt) as budget_amt, "+
				"		sum(a.g_2_4_amt) as g_2_4_amt, nvl(sum(a.g30_amt), 0) as g30_amt, sum(a.t_basic_amt) as t_basic_amt,  sum(a.t_real_amt) as t_real_amt, sum(a.oil_amt) as oil_amt  " +
				" from  (  " +		
				"	select u.use_yn,  u.user_id, a.w_cnt, a.basic_amt, f.budget_amt, a.real_amt, a.remain_amt, b.g2_1_amt, c.g2_3_amt, d.g3_amt, e.g2_amt, g.g4_amt, gg.g15_amt , h.g_2_4_amt, k.g30_amt, r.t_basic_amt, r.t_real_amt ,  oi.oil_amt from  users u ,  " +				
				"		 ( select   a.user_id,  sum(decode(a.remark, 'W', 1, 0)) as w_cnt, sum(a.basic_amt) as basic_amt, sum(a.real_amt) as real_amt, sum(a.remain_amt) as remain_amt " +
				"				         from card_doc_jungsan a       where a.jung_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') group by a.user_id ) a, " +
				"		 ( select  b.doc_user, sum(b.doc_amt)  as g2_1_amt  from card_doc a, card_doc_user  b	where a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and a.acct_code = '00001' and a.acct_code_g = '1' and a.acct_code_g2 = '1'  and  " +
				"			      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user ) b , " +
				"		 ( select  b.doc_user, sum(b.doc_amt)  as g2_3_amt from card_doc a, card_doc_user  b	where a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and a.acct_code = '00001' and a.acct_code_g = '1' and a.acct_code_g2 = '3'  and  " + 
				"			      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user ) c , " +
				"		 ( select  b.doc_user, sum(b.doc_amt)  as g3_amt from card_doc a, card_doc_user  b	where a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and a.acct_code = '00001' and a.acct_code_g = '3' and " + 
				"			      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user ) d , " +
				"		 ( select  b.doc_user, sum(b.doc_amt)  as g2_amt from card_doc a, card_doc_user  b	where a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and a.acct_code = '00001' and a.acct_code_g = '2' and " + 
				"			      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user ) e, " +
				"		 ( select  b.doc_user, sum(b.doc_amt)  as g4_amt from card_doc a, card_doc_user  b	where a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and a.acct_code = '00001' and a.acct_code_g = '4' and " + 
				"			      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user ) g, " +
				"		 ( select  b.doc_user, sum(b.doc_amt)  as g15_amt from card_doc a, card_doc_user  b	where a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and a.acct_code = '00001' and a.acct_code_g = '15' and " + 
				"			      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user ) gg, " +
				"		 ( select  b.doc_user, sum(b.doc_amt)  as g_2_4_amt from card_doc a, card_doc_user  b	where a.buy_dt like substr('" + f_date1 + "',1,4)||'%'  and a.acct_code = '00001' and a.acct_code_g  in ('2', '4') and " + 
				"			      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user ) h, " +
				"		 ( select  b.doc_user, sum(b.doc_amt)  as g30_amt from card_doc a, card_doc_user  b	where a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and a.acct_code = '00001' and a.acct_code_g  = '30' and " + 
				"			      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user ) k, " +
				"		 ( select  a.user_id, sum(a.jung_amt)  as oil_amt from stat_car_oil a where substr(a.save_dt, 1, 4)  = substr('" + f_date1 + "',1,4) and magam = 'Y'  and a.save_dt < '20120601' group by a.user_id ) oi, " +
				"		 ( select  a.user_id, sum(a.prv+a.jan+a.feb+a.mar+a.apr+a.may+a.jun+a.jul+a.aug+a.sep+a.oct+a.nov+a.dec)  as budget_amt from budget a where a.byear = substr('" + f_date1 + "',1,4) and a.bgubun = '1' group by a.user_id ) f, " +
				"		 ( select  a.user_id, sum(a.basic_amt) as t_basic_amt, sum(a.real_amt)  as t_real_amt from card_doc_jungsan a where substr(a.jung_dt, 1, 4)  = substr('" + f_date1 + "',1,4)  group by a.user_id ) r " +
				"	where u.user_id = a.user_id(+) and u.user_id = b.doc_user(+) and u.user_id = c.doc_user(+) and u.user_id = d.doc_user(+) and u.user_id = e.doc_user(+) and u.user_id = g.doc_user(+) and u.user_id = gg.doc_user(+) and u.user_id = f.user_id(+) and u.user_id = h.doc_user(+)  and u.user_id = k.doc_user(+) and u.user_id = r.user_id(+)and u.user_id = oi.user_id(+) ) a, users u ," +
				" branch c,  ( select c_st, code, nm_cd, nm from code where c_st = '0002' and code <> '0000'  )  e  \n"+
				" where a.user_id = u.user_id    and u.br_id=c.br_id and u.dept_id = e.code     and a.user_id not in ('000035','000177','000203','000238','000285','000302','000329','000293','000330') and u.id not like 'develop%' and u.dept_id not in ('8888' , '1000') and nvl(u.m_yn, 'Y' ) = 'Y' and ( u.use_yn = 'Y' or u.out_dt > replace('" + f_date1 + "','-','')  ) " ;
							
				
		if(!br_id.equals(""))	query += " and u.br_id='"+br_id+"' ";
		if(!dept_id.equals("")) query += " and u.dept_id='"+dept_id+"' ";
		if(!user_nm.equals("")) query += " and u.user_nm like '%"+user_nm+"%' ";		
						
		query += " group by u.use_yn, a.user_id, u.user_nm, u.user_pos, u.br_id, u.dept_id  , c.br_nm, e.nm ";
		query +="  order by 1 desc, decode(u.user_pos,'대표이사',1,'이사',2,'팀장',4, 5), DECODE(a.user_id, '000004',1,'000005',2,'000237',3,4), decode(u.dept_id,'0004','0000',u.dept_id), decode(u.user_pos,'인턴사원','6','사원','5','대리','4', '과장', '3', '차장', '2', '1'),a.user_id ";
			
		try {
			pstmt = conn.prepareStatement(query);
		    rs = pstmt.executeQuery();
		    		      		   
  		    ResultSetMetaData rsMeta = rs.getMetaData();
	        int columnCnt = rsMeta.getColumnCount();
	        List<String> columnNames = new ArrayList<String>();
	        for(int i=1;i<=columnCnt;i++) {
	            columnNames.add(rsMeta.getColumnName(i).toUpperCase());
	        }
	        
			while(rs.next()) { 
	      		count++;	
	      		
				JSONObject obj = new JSONObject();
            
        		obj.put("id",count);
        	  
				for(int i=1;i<=columnCnt;i++) {
					String key = columnNames.get(i - 1);
					String value = rs.getString(i);
					obj.put(key, value);
				}
            
				resList.add(obj);
			}
			rs.close();
			pstmt.close();
        
			jsonroot.put("rows",resList);
	          
		} catch (SQLException e) {
			System.out.println("[CardDatabase:getCardJungDtStatINewJsonT]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return jsonroot;
		}		
	}

	/*탁송 입력한 전표 갯수 찾기
	 * author : 성승현
	 */

	public int getCardDocConsignmentSeq(String cons_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		int seq = 0;
	
		query = " select count(0) from card_doc where cons_no like '%"+cons_no+"%'";
	
		try {
			pstmt = conn.prepareStatement(query); 
	    	rs = pstmt.executeQuery();
		
			if(rs.next())
			{			
				seq = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		
		} catch (SQLException e) {
			System.out.println("[CardDatabase:getCardDocConsignmentSeq(String cons_no)]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return seq;
		}		
	}
	
	/*탁송에 법인전표 가격 입력된 갯수 찾기
	 * author : 성승현
	 */

		public int getConsignmentOilCardSeq(String cons_no)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String query = "";
			int seq = 0;
		
			query = " select count(0) from consignment where cons_no='"+cons_no+"' and NVL(OIL_card_AMT, 0) <> 0";
		
			try {
				pstmt = conn.prepareStatement(query); 
		    	rs = pstmt.executeQuery();
			
				if(rs.next())
				{			
					seq = rs.getInt(1);
				}
				
				rs.close();
				pstmt.close();

			} catch (SQLException e) {
				System.out.println("[CardDatabase:getConsignmentOilCardSeq(String cons_no)]\n"+e);
		  		e.printStackTrace();
			} finally {
				try{
					if ( rs != null )		rs.close();
					if ( pstmt != null )	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return seq;
			}		
		}
	
	
	//카드전표 - 적요 수정
	public boolean updateCardDoc(String o_cardno, String o_buy_id, String doc_acct)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " update card_doc set acct_cont =  ? where cardno =? and buy_id=? ";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		doc_acct);
			pstmt.setString	(2,		o_cardno);
			pstmt.setString	(3,		o_buy_id);
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[CardDatabase:updateCardDoc]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	/**
	 * 날짜 : 2017.10.19
	 * 작성 : 심병호
	 * 설명 : 삼성 카드인지 판별한다.
	 */
	public String checkSamSungCard(String cardno){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		int seq = 0;
		String result77 = "";
	
		query = " select decode(CARD_KIND,'삼성카드',1,0) as issscard from card where cardno ='" + cardno + "'";
		
		try {
			pstmt = conn.prepareStatement(query); 
	    	rs = pstmt.executeQuery();
		
			if(rs.next())
			{			
				result77 = rs.getString("ISSSCARD");
			}
			rs.close();
			pstmt.close();
		
		} catch (SQLException e) {
			System.out.println("### ERROR ### checkSamSungCard : "+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return result77;
		}
	}
	
	/**
	 * 날짜 : 2017.10.19
	 * 작성 : 심병호
	 * 설명 : card_doc 테이블의 하기 컬럼들을 null 처리 한다.
	 */
	public boolean updateSamSungCard(String cardNo, String buyId)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " update card_doc set acct_code = null , acct_code_g = null, acct_code_g2 = null, item_code = null, item_name = null, acct_cont = null, user_su = null,"
				+ "user_cont = null, reg_id = null, reg_dt = null, app_id = null, app_dt = null, app_code = null, autodocu_write_date = null, autodocu_data_no = null,"
				+ "buy_user_id = null, rent_l_cd = null, chief_id = null, tax_yn = null, ven_st = null, cgs_ok = null, cd_reg_id = null, o_cau = null, call_t_nm = null, call_t_tel = null,"
				+ "call_t_chk = null, serv_id = null, m_doc_code = null, m_amt = null, card_file = null, file_path = null, oil_liter = null, tot_dist = null, siokno = null, cons_no = null,"
				+ "ackno = null where cardno = ? and buy_id = ?";
		
		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		cardNo);
			pstmt.setString	(2,		buyId);
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("### ERROR ### updateSamSungCard : "+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	/**
	 *	카드 리스트 -- 20180718 : 하이패스 엑셀파일 변경
	 */	
	public Hashtable getCardSearchExcel(String card_st, String cardno_f, String cardno)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select "+
				" a.*, b.*, b.user_id as buy_user_id, c.user_nm as buy_user_nm, d.br_nm, decode(a.card_chk, null, c.user_nm,'',c.user_nm, a.card_chk) user_nm,  nvl(b.user_id,c.user_id) user_code,"+
				" decode(a.limit_st,'1','개별','2','통합') limit_st_nm, decode(a.card_st,'1','구매자금용','2','공용','3','임/직원지급용','4','하이패스','5','세금납부용','6','포인트') card_st_nm"+
				" from card a, card_user b, users c, branch d, (select cardno, max(seq) seq from card_user group by cardno) f"+
				" where"+
				" replace(a.cardno,'-','') like replace('"+cardno_f+"%"+cardno+"','-','') ";
		
		if(!card_st.equals("")) query += " and a.card_st='"+card_st+"'";

		query += " and a.cardno=b.cardno(+) and a.user_seq=b.seq(+) and b.cardno=f.cardno(+) and b.seq=f.seq(+) and b.user_id=c.user_id(+) and c.br_id=d.br_id(+)";

		try {
			pstmt = conn.prepareStatement(query);
		    rs = pstmt.executeQuery();
		    
	    	ResultSetMetaData rsmd = rs.getMetaData();
    	
			if(rs.next())
			{				
				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CardDatabase:getCardSearchExcel]\n"+e);
			System.out.println("[CardDatabase:getCardSearchExcel]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}		
	}


	//----------------------------------------------------
	//
	//       카드캐쉬백현황 card_cont, card_stat_base, card_stat_scd
	//
	//----------------------------------------------------


	//카드약정 한건 등록
	public boolean insertCardCont(CardContBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;

		String query = "";
		int seq = 0;

		String query_seq = "SELECT NVL(max(seq)+1,1) as SEQ FROM card_cont where cardno=? ";
			
		query = " INSERT INTO card_cont ("+
				"	cardno, seq, cont_dt, give_day, cont_amt, save_per1, save_per2, save_in_dt, save_in_st, "+
				"	agnt_nm, agnt_tel, agnt_m_tel, etc, reg_id, reg_dt, allot_link_yn, save_in_dt_st1, save_in_dt_st2, save_in_dt_st3, "+
				"   n_ven_code, n_ven_name, card_kind, give_day_st, master_nm, master_tel, master_m_tel "+
				" ) VALUES"+
				" ( ?, ?, replace(?, '-', ''), ?, ?, ?, ?, ?, ?, "+
				"   ?, ?, ?, ?, ?, to_char(sysdate,'YYYYMMDD'), ?, ?, ?, ?, "+
				"   ?, ?, ?, ?, ?, ?, ? "+
				" )";

		try 
		{
			conn.setAutoCommit(false);

			pstmt2 = conn.prepareStatement(query_seq);
			pstmt2.setString(1, bean.getCardno());
		    rs = pstmt2.executeQuery();
			if(rs.next())
			{
				bean.setSeq(rs.getInt("SEQ"));
			}
			rs.close();
			pstmt2.close();
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getCardno			());
			pstmt.setInt   	(2,		bean.getSeq				());
			pstmt.setString	(3,		bean.getCont_dt			());
			pstmt.setString	(4,		bean.getGive_day		());
			pstmt.setLong  	(5,		bean.getCont_amt		());
			pstmt.setFloat 	(6,		bean.getSave_per1		());
			pstmt.setFloat 	(7,		bean.getSave_per2		());
			pstmt.setString	(8,	    bean.getSave_in_dt		());
			pstmt.setString	(9,	    bean.getSave_in_st		());
			pstmt.setString	(10,	bean.getAgnt_nm			());
			pstmt.setString	(11,	bean.getAgnt_tel		());
			pstmt.setString	(12,	bean.getAgnt_m_tel		());
			pstmt.setString	(13,	bean.getEtc				());
			pstmt.setString	(14,	bean.getReg_id			());
			pstmt.setString	(15,	bean.getAllot_link_yn	());
			pstmt.setString	(16,	bean.getSave_in_dt_st1	());
			pstmt.setString	(17,	bean.getSave_in_dt_st2	());
			pstmt.setString	(18,	bean.getSave_in_dt_st3	());
			pstmt.setString	(19,	bean.getN_ven_code		());
			pstmt.setString	(20,	bean.getN_ven_name		());
			pstmt.setString	(21,	bean.getCard_kind		());
			pstmt.setString	(22,	bean.getGive_day_st		());
			pstmt.setString	(23,	bean.getMaster_nm		());
			pstmt.setString	(24,	bean.getMaster_tel		());
			pstmt.setString	(25,	bean.getMaster_m_tel	());
			
			pstmt.executeUpdate();
			pstmt.close();
			
			conn.commit();
				

	  	} catch (Exception e) {
			System.out.println("[CardDatabase:insertCardCont(CardContBean bean)]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(rs != null )		rs.close();
				if(pstmt2 != null)	pstmt2.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//카드약정 한건 수정
	public boolean updateCardCont(CardContBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";

		query = " update card_cont set "+
				"	cont_dt=replace(?, '-', ''), give_day=?, cont_amt=?, save_per1=?, save_per2=?, save_in_dt=?, save_in_st=?, "+
				"	agnt_nm=?, agnt_tel=?, agnt_m_tel=?, etc=?, allot_link_yn=?, save_in_dt_st1=?, save_in_dt_st2=?, save_in_dt_st3=?, "+
				"   n_ven_code=?, n_ven_name=?, give_day_st=?, master_nm=?, master_tel=?, master_m_tel=? "+
				" where cardno=? and seq=? "+
				" ";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getCont_dt			());
			pstmt.setString	(2,		bean.getGive_day		());
			pstmt.setLong  	(3,		bean.getCont_amt		());
			pstmt.setFloat 	(4,		bean.getSave_per1		());
			pstmt.setFloat 	(5,		bean.getSave_per2		());
			pstmt.setString	(6,		bean.getSave_in_dt		());
			pstmt.setString	(7,	    bean.getSave_in_st		());
			pstmt.setString	(8,  	bean.getAgnt_nm			());
			pstmt.setString	(9, 	bean.getAgnt_tel		());
			pstmt.setString	(10,	bean.getAgnt_m_tel		());
			pstmt.setString	(11,	bean.getEtc				());
			pstmt.setString	(12,	bean.getAllot_link_yn	());
			pstmt.setString	(13,	bean.getSave_in_dt_st1	());
			pstmt.setString	(14,	bean.getSave_in_dt_st2	());
			pstmt.setString	(15,	bean.getSave_in_dt_st3	());
			pstmt.setString	(16,	bean.getN_ven_code		());
			pstmt.setString	(17,	bean.getN_ven_name		());
			pstmt.setString	(18,	bean.getGive_day_st		());
			pstmt.setString	(19,  	bean.getMaster_nm		());
			pstmt.setString	(20, 	bean.getMaster_tel		());
			pstmt.setString	(21,	bean.getMaster_m_tel	());
			pstmt.setString	(22,	bean.getCardno			());
			pstmt.setInt   	(23,	bean.getSeq				());
			pstmt.executeUpdate();
			pstmt.close();
			
			conn.commit();
				
	  	} catch (Exception e) {
			System.out.println("[CardDatabase:updateCardCont(CardContBean bean)]\n"+e);
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

	//카드사용 한건 수정
	public boolean updateCardStatBase(CardStatBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";

		query = " update card_stat_base set "+
				"	use_yn='C', base_amt=?, save_amt=?, save_per=?, update_dt=to_char(sysdate,'YYYYMMDD'), update_id=?, magam_id='', ven_name=? "+
				" where serial=? "+
				" ";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setLong  	(1,		bean.getBase_amt	());
			pstmt.setLong  	(2,		bean.getSave_amt	());
			pstmt.setFloat 	(3,		bean.getSave_per	());
			pstmt.setString (4,		bean.getUpdate_id	());
			pstmt.setString (5,		bean.getVen_name	());
			pstmt.setInt   	(6,		bean.getSerial		());
			pstmt.executeUpdate();
			pstmt.close();
			
			conn.commit();
				
	  	} catch (Exception e) {
			System.out.println("[CardDatabase:updateCardStatBase(CardStatBean bean)]\n"+e);
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

	//카드사용 한건 취소
	public boolean updateCardStatCancel(CardStatBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";

		query = " update card_stat_base set "+
				"	use_yn='N', update_dt=to_char(sysdate,'YYYYMMDD'), update_id=? "+
				" where serial=? "+
				" ";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString (1,		bean.getUpdate_id	());
			pstmt.setInt   	(2,		bean.getSerial		());
			pstmt.executeUpdate();
			pstmt.close();
			
			conn.commit();
				
	  	} catch (Exception e) {
			System.out.println("[CardDatabase:updateCardStatCancel(CardStatBean bean)]\n"+e);
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

	//카드스케줄 한건 수정
	public boolean updateCardStatScd(CardStatBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";

		query = " update card_stat_scd set "+
				"	incom_dt=replace(?, '-', ''), incom_seq=?, incom_amt=?, m_amt=?, incom_bigo=?, bank_id=?, bank_nm=?, bank_no=? "+
				" where serial=? and tm=? "+
				" ";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getIncom_dt	());
			pstmt.setString	(2,		bean.getIncom_seq	());
			pstmt.setLong  	(3,		bean.getIncom_amt	());
			pstmt.setLong  	(4,		bean.getM_amt		());
			pstmt.setString	(5,		bean.getIncom_bigo	());
			pstmt.setString	(6,		bean.getBank_id		());
			pstmt.setString	(7,		bean.getBank_nm		());
			pstmt.setString	(8,		bean.getBank_no		());
			pstmt.setInt   	(9,		bean.getSerial		());
			pstmt.setInt   	(10,	bean.getTm			());
			pstmt.executeUpdate();
			pstmt.close();
			
			conn.commit();
				
	  	} catch (Exception e) {
			System.out.println("[CardDatabase:updateCardStatScd(CardStatBean bean)]\n"+e);
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

	//카드스케줄 한건 수정
	public boolean updateCardStatScdRe(CardStatBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";

		query = " update card_stat_scd set "+
				"	scd_amt = (SELECT sum(base_amt) b_base_amt FROM card_stat_base WHERE  card_kind=? AND base_dt=? AND est_dt=? AND reg_code=? and nvl(use_yn,'Y')<>'N' ), "+
				"	save_amt= (SELECT sum(save_amt) b_save_amt FROM card_stat_base WHERE  card_kind=? AND base_dt=? AND est_dt=? AND reg_code=? and nvl(use_yn,'Y')<>'N' )  "+
				" where tm='1' and card_kind=? AND scd_dt=? AND est_dt=? AND reg_code=? "+
				" ";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getCard_kind	());
			pstmt.setString	(2,		bean.getBase_dt		());
			pstmt.setString	(3,		bean.getEst_dt		());
			pstmt.setString	(4,		bean.getReg_code	());
			pstmt.setString	(5,		bean.getCard_kind	());
			pstmt.setString	(6,		bean.getBase_dt		());
			pstmt.setString	(7,		bean.getEst_dt		());
			pstmt.setString	(8,		bean.getReg_code	());
			pstmt.setString	(9,		bean.getCard_kind	());
			pstmt.setString	(10,	bean.getBase_dt		());
			pstmt.setString	(11,	bean.getEst_dt		());
			pstmt.setString	(12,	bean.getReg_code	());
			pstmt.executeUpdate();
			pstmt.close();
			
			conn.commit();
				
	  	} catch (Exception e) {
			System.out.println("[CardDatabase:updateCardStatScdRe(CardStatBean bean)]\n"+e);
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

	//카드스케줄 한건 삭제
	public boolean deleteCardStatScdRe(CardStatBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";

		query = " delete card_stat_scd "+
				" where tm='1' and card_kind=? AND scd_dt=? AND est_dt=? AND reg_code=? and NVL(save_amt,0)=0 "+
				" ";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getCard_kind	());
			pstmt.setString	(2,		bean.getBase_dt		());
			pstmt.setString	(3,		bean.getEst_dt		());
			pstmt.setString	(4,		bean.getReg_code	());
			pstmt.executeUpdate();
			pstmt.close();
			
			conn.commit();
				
	  	} catch (Exception e) {
			System.out.println("[CardDatabase:deleteCardStatScdRe(CardStatBean bean)]\n"+e);
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





	//카드스케줄 한건 등록
	public boolean insertCardStatScd(CardStatBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " INSERT INTO card_stat_scd ("+
				"	serial, tm, scd_dt, card_kind, scd_amt, save_amt, reg_code, est_dt, incom_bigo "+
				" ) VALUES"+
				" ( ?, ?, replace(?, '-', ''), ?, ?, ?, ?, replace(?, '-', ''), ? "+
				" )";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setInt   	(1,		bean.getSerial			());
			pstmt.setInt   	(2,		bean.getTm				());
			pstmt.setString	(3,		bean.getScd_dt			());
			pstmt.setString	(4,		bean.getCard_kind		());
			pstmt.setLong  	(5,		bean.getScd_amt			());
			pstmt.setLong  	(6,		bean.getSave_amt		());
			pstmt.setString	(7,	    bean.getReg_code		());
			pstmt.setString	(8,	    bean.getEst_dt			());
			pstmt.setString	(9,	    bean.getIncom_bigo		());
			pstmt.executeUpdate();
			pstmt.close();
			
			conn.commit();
				
	  	} catch (Exception e) {
			System.out.println("[CardDatabase:insertCardStatScd(CardStatBean bean)]\n"+e);
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
	 *	카드약정 한건 조회
	 *  
	 */	
	public CardContBean getCardCont(String cardno, String seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		CardContBean bean = new CardContBean();
		String query = "";

		query = " select cardno, seq, cont_dt, give_day, cont_amt, save_per1, save_per2, save_in_dt, save_in_st, "+
				"        agnt_nm, agnt_tel, agnt_m_tel, etc, reg_id, reg_dt, allot_link_yn, save_in_dt_st1, save_in_dt_st2, save_in_dt_st3, "+
				"        n_ven_code, n_ven_name, card_kind, give_day_st, master_nm, master_tel, master_m_tel "+
				" from   card_cont "+
				" where  cardno=? and seq=? ";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,	cardno);
			pstmt.setString	(2,	seq);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{			
				bean.setCardno			(rs.getString(1));
				bean.setSeq				(rs.getInt(2));
				bean.setCont_dt			(rs.getString(3));
				bean.setGive_day		(rs.getString(4));
				bean.setCont_amt		(rs.getLong(5));
				bean.setSave_per1		(rs.getFloat(6));
				bean.setSave_per2		(rs.getFloat(7));
				bean.setSave_in_dt		(rs.getString(8));
				bean.setSave_in_st		(rs.getString(9));
				bean.setAgnt_nm			(rs.getString(10));
				bean.setAgnt_tel		(rs.getString(11));
				bean.setAgnt_m_tel		(rs.getString(12));
				bean.setEtc				(rs.getString(13));
				bean.setReg_id			(rs.getString(14));
				bean.setReg_dt			(rs.getString(15));
				bean.setAllot_link_yn	(rs.getString(16));
				bean.setSave_in_dt_st1	(rs.getString(17));
				bean.setSave_in_dt_st2	(rs.getString(18));
				bean.setSave_in_dt_st3	(rs.getString(19));
				bean.setN_ven_code		(rs.getString(20));
				bean.setN_ven_name		(rs.getString(21));
				bean.setCard_kind		(rs.getString(22));
				bean.setGive_day_st		(rs.getString(23));
				bean.setMaster_nm		(rs.getString(24));
				bean.setMaster_tel		(rs.getString(25));
				bean.setMaster_m_tel	(rs.getString(26));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CardDatabase:getCardCont(String cardno, String seq)]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}		
	}

	/**
	 *	카드사용 한건 조회
	 *  
	 */	
	public CardStatBean getCardStatBase(int serial)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		CardStatBean bean = new CardStatBean();
		String query = "";

		query = " select serial, base_dt, cardno, base_g, card_kind, base_amt, save_per, save_amt, est_dt, reg_code, base_bigo, reqseq, magam_id, ven_name "+
				" from   card_stat_base "+
				" where  serial=? ";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setInt	(1,	serial);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{			
				bean.setSerial			(rs.getInt(1));
				bean.setBase_dt			(rs.getString(2));
				bean.setCardno			(rs.getString(3));
				bean.setBase_g			(rs.getString(4));
				bean.setCard_kind		(rs.getString(5));
				bean.setBase_amt		(rs.getLong(6));
				bean.setSave_per		(rs.getFloat(7));
				bean.setSave_amt		(rs.getLong(8));
				bean.setEst_dt			(rs.getString(9));
				bean.setReg_code		(rs.getString(10));
				bean.setBase_bigo		(rs.getString(11));
				bean.setReqseq			(rs.getString(12));
				bean.setMagam_id		(rs.getInt(13));
				bean.setVen_name		(rs.getString(14));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CardDatabase:getCardStatBase(String serial)]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}		
	}

	/**
	 *	카드스케줄 한건 조회
	 *  
	 */	
	public CardStatBean getCardStatScd(int serial, int tm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		CardStatBean bean = new CardStatBean();
		String query = "";

		query = " select serial, tm, scd_dt, card_kind, scd_amt, save_amt, incom_dt, incom_seq, incom_amt, reg_code, est_dt, incom_bigo, m_amt "+
				" from   card_stat_scd "+
				" where  serial=? and tm=? ";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setInt	(1,	serial);
			pstmt.setInt	(2,	tm);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{			
				bean.setSerial			(rs.getInt(1));
				bean.setTm				(rs.getInt(2));
				bean.setScd_dt			(rs.getString(3));
				bean.setCard_kind		(rs.getString(4));
				bean.setScd_amt			(rs.getLong(5));
				bean.setSave_amt		(rs.getLong(6));
				bean.setIncom_dt		(rs.getString(7));
				bean.setIncom_seq		(rs.getString(8));
				bean.setIncom_amt		(rs.getLong(9));
				bean.setReg_code		(rs.getString(10));
				bean.setEst_dt			(rs.getString(11));
				bean.setIncom_bigo		(rs.getString(12));
				bean.setM_amt			(rs.getLong(13));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CardDatabase:getCardStatScd(String serial, String tm)]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}		
	}



	/**
	 *	카드 조회 리스트
	 */	
	public Vector getCardSearch(String s_kd, String card_kind, String card_kind_nm, String cardno)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		//카드 조회
		query = " select * from card where card_kind_cd='"+card_kind+"'";

		if(!cardno.equals(""))		query += " and cardno||card_name like '%"+cardno+"%'";

		query += " order by cardno ";
		
		//담당자 조회
		if(s_kd.equals("agnt_nm") || s_kd.equals("master_nm")){
			query = " SELECT b.off_nm, b.note, a.* "+
					" from   serv_emp a, serv_off b, (SELECT off_id, max(seq) seq FROM serv_emp GROUP BY off_id) c  "+
					" WHERE  a.off_id=b.off_id AND b.note LIKE '%카드%' "+
					"        AND a.off_id=c.off_id AND a.seq=c.seq "+
					"        AND b.off_nm LIKE '%'||REPLACE('"+card_kind_nm+"','카드','')||'%'  "+
					" ";

			if(!cardno.equals(""))		query += " and b.off_nm||a.emp_nm like '%"+cardno+"%'";

			query += " order by b.off_nm, a.emp_nm ";

		//입금거래처 조회
		}else if(s_kd.equals("n_ven")){
			query = " SELECT n_ven_name, n_ven_code "+
					" from   incom_etc "+
					" WHERE  ip_acct='6' and incom_dt >= to_char(sysdate-365,'YYYYMMDD') "+
					" ";

			if(!cardno.equals(""))		query += " and n_ven_name like '%"+cardno+"%'";

			query += " group by n_ven_name, n_ven_code ";
			query += " order by n_ven_name, n_ven_code ";

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
			System.out.println("[CardDatabase:getCardSearch]\n"+e);
			System.out.println("[CardDatabase:getCardSearch]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 *	카드별 약정리스트 조회
	 */	
	public Vector getCardContList(String st, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		//카드 조회
		query = " select b.card_kind, b.card_name, decode(b.card_paid,'2','선불카드','3','후불카드','5','포인트','7','카드할부','후불카드') card_paid, "+
				"        decode(b.card_st,'1','구매자금용','2','공용','3','임/직원지급용','4','하이패스','5','세금납부용','6','포인트') card_st, a.* "+ 
				" from   card_cont a, card b, (select cardno, max(seq) seq from card_cont group by cardno) c "+
				" where  a.cardno=b.cardno  "+
				"        and a.cardno=c.cardno(+) and a.seq=c.seq(+) "+
				" ";

		if(st.equals("now")){
			query += " and b.card_kind='"+t_wd+"' and a.seq=c.seq ";
		}

		if(st.equals("card_h")){
			query += " and a.cardno='"+t_wd+"' ";
		}


		query += " order by a.cardno, a.reg_dt ";

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
			System.out.println("[CardDatabase:getCardContList]\n"+e);
			System.out.println("[CardDatabase:getCardContList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 *	카드별 등록현황 조회
	 */	
	public Vector getCardRegStat(String card_kind, String s_card)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		//카드 조회
		query = " select a.card_kind, d.nm as card_kind_nm, b.card_name, decode(b.card_paid,'2','선불카드','3','후불카드','5','포인트','7','카드할부','후불카드') card_paid, "+
				"        decode(b.card_st,'1','구매자금용','2','공용','3','임/직원지급용','4','하이패스','5','세금납부용','6','포인트') card_st, b.pay_day, a.* "+ 
				" from   card_cont a, card b, (select cardno, max(seq) seq from card_cont group by cardno) c, "+
				"        (select code, nm from code where c_st='0031' and code<>'0000') d "+
				" where  a.card_kind='"+card_kind+"' and a.cardno=b.cardno and b.use_yn='Y' AND b.card_edate >= TO_CHAR(SYSDATE,'YYYYMMDD') "+
				"        and a.cardno=c.cardno and a.seq=c.seq and a.card_kind=d.code "+
				" ";

		if(!s_card.equals("")){
			query += " and a.cardno||b.card_name like '%"+s_card+"%' ";
		}

		query += " order by decode(b.card_st,'1','1','5','2','3'), a.cardno, a.reg_dt ";

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
			System.out.println("[CardDatabase:getCardRegStat]\n"+e);
			System.out.println("[CardDatabase:getCardRegStat]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 *	카드별 약정현황 조회
	 */	
	public Vector getCardContStat()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		//카드 조회
		query = " select '1' st, a.card_kind, d.nm as card_kind_nm, a.cont_amt, d.code as card_kind_cd, a.cardno, a.reg_dt, a.cont_dt, a.cont_amt, a.give_day, a.give_day_st,  "+
				"        to_char(a.save_per1,'0.90') save_per1, to_char(a.save_per2,'0.90')  save_per2, "+
				"        b.card_name, b.card_edate, "+
				"        decode(b.card_st,'1','구매자금용','2','공용','3','임/직원지급용','4','하이패스','5','세금납부용','6','포인트') card_st, "+ 
				"        decode(b.card_paid,'2','선불카드','3','후불카드','5','포인트','7','카드할부','후불카드') card_paid, trunc(a.cont_amt/100000000) as s_cont_amt "+
				" from   card_cont a, card b, (select cardno, max(seq) seq from card_cont group by cardno) c, (select code, nm from code where c_st='0031' and code<>'0000') d "+
				" where  a.cardno=b.cardno and b.card_st='1' AND b.use_yn='Y' AND b.card_edate >= TO_CHAR(SYSDATE,'YYYYMMDD') "+
				"        and a.cardno=c.cardno and a.seq=c.seq and a.card_kind=d.code "+
				" ";

		query += " union all "+
				"  select '2' st, a.card_kind, max(d.nm) as card_kind_nm, sum(a.cont_amt) cont_amt, max(d.code) as card_kind_cd, count(0)||'개' cardno, '' reg_dt, max(a.cont_dt) cont_dt, sum(a.cont_amt) cont_amt, max(a.give_day) as give_day, max(a.give_day_st) as give_day_st, "+
				"        min(to_char(a.save_per1,'0.90')) save_per1, max(to_char(a.save_per2,'0.90')) save_per2, "+
				"        '' card_name, min(b.card_edate) card_edate, "+
				"        decode(b.card_st,'3','임/직원지급용','5','세금납부용') card_st, "+ 
				"        decode(max(b.card_paid),'2','선불카드','3','후불카드','5','포인트','7','카드할부','후불카드') card_paid, trunc(sum(a.cont_amt)/100000000) as s_cont_amt "+
				" from   card_cont a, card b, (select cardno, max(seq) seq from card_cont group by cardno) c, (select code, nm from code where c_st='0031' and code<>'0000') d "+
				" where  a.cardno=b.cardno and b.card_st in ('3','5') AND b.use_yn='Y' AND b.card_edate >= TO_CHAR(SYSDATE,'YYYYMMDD') "+
				"        and a.cardno=c.cardno and a.seq=c.seq and a.card_kind=d.code "+
				" group by a.card_kind, b.card_st "+	
				" ";


		query += " order by 4 desc, 3, 2, 1 ";

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
			System.out.println("[CardDatabase:getCardContStat]\n"+e);
			System.out.println("[CardDatabase:getCardContStat]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 *	일일현황 조회
	 */	
	public Vector getCardDayStat(String s_yy, String s_mm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT scd_dt, SUBSTR(scd_dt,7,2) day, "+
				"        '0007' card_kind1, "+ //롯데카드
				"        '0001' card_kind2, "+ //광주카드
				"        '0002' card_kind3, "+ //국민카드
				"        '0011' card_kind4, "+ //삼성카드
				"        '0016' card_kind5, "+ //우리비씨
				"        '0012' card_kind6, "+ //신한카드
				"        '0017' card_kind7, "+ //전북카드
				"        '0019' card_kind8, "+ //하나카드
				"        '0022' card_kind9, "+ //현대카드
				"        NVL(SUM(scd_amt),0) amt0,  "+
				"        NVL(SUM(DECODE(card_kind,'0007',scd_amt)),0) amt1, "+ //롯데카드
				"        NVL(SUM(DECODE(card_kind,'0001',scd_amt)),0) amt2, "+ //광주카드
				"        NVL(SUM(DECODE(card_kind,'0002',scd_amt)),0) amt3, "+ //국민카드
				"        NVL(SUM(DECODE(card_kind,'0011',scd_amt)),0) amt4, "+ //삼성카드
				"        NVL(SUM(DECODE(card_kind,'0016',scd_amt)),0) amt5, "+ //우리비씨
				"        NVL(SUM(DECODE(card_kind,'0012',scd_amt)),0) amt6, "+ //신한카드
				"        NVL(SUM(DECODE(card_kind,'0017',scd_amt)),0) amt7, "+ //전북카드
				"        NVL(SUM(DECODE(card_kind,'0019',scd_amt)),0) amt8, "+ //하나카드
				"        NVL(SUM(DECODE(card_kind,'0022',scd_amt)),0) amt9, "+ //현대카드
				"        NVL(SUM(DECODE(card_kind,'0007',0,'0001',0,'0002',0,'0011',0,'0016',0,'0012',0,'0017',0,'0019',0,'0022',0,scd_amt)),0) amt10 "+
				" FROM   card_stat_scd "+
				" WHERE  scd_dt LIKE '"+s_yy+""+s_mm+"%' and tm=1 "+
				" GROUP BY scd_dt "+
				" ORDER BY scd_dt "+
				" ";

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
			System.out.println("[CardDatabase:getCardDayStat]\n"+e);
			System.out.println("[CardDatabase:getCardDayStat]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 *	카드사별 일일현황 리스트 조회
	 */	
	public Vector getCardDayList(String s_yy, String s_mm, String scd_dt, String card_kind)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		if(card_kind.equals("그외")){

			query = " select a.incom_dt, a.incom_amt, b.* "+ 
					" from   card_stat_scd a, card_stat_base b "+
					" where  a.scd_dt=replace('"+scd_dt+"','-','') and a.tm=1 "+
					"        and a.card_kind not in ('0007','0001','0016','0011','0002','0012','0017') "+ 
					"        and a.scd_dt=b.base_dt and a.card_kind=b.card_kind and a.reg_code=b.reg_code and a.est_dt=b.est_dt and a.rtn_dt=b.rtn_dt and nvl(b.use_yn,'Y')<>'N' "+
					" ";

		}else{

			query = " select a.incom_dt, a.incom_amt, b.* "+ 
					" from   card_stat_scd a, card_stat_base b "+
					" where  a.tm=1  ";

			if(!card_kind.equals("")){
				query += " and a.card_kind='"+card_kind+"' ";
			}
			
			if(scd_dt.equals("")){
				query += " and a.scd_dt like '"+s_yy+s_mm+"%' ";
			}else{
				query += " and a.scd_dt=replace('"+scd_dt+"','-','') ";
			}

			query += "       and a.scd_dt=b.base_dt and a.card_kind=b.card_kind and a.reg_code=b.reg_code and a.est_dt=b.est_dt and a.rtn_dt=b.rtn_dt and nvl(b.use_yn,'Y')<>'N' "+
					" ";

		}

		query += " order by a.incom_dt, b.cardno, b.base_g, b.reqseq ";

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
			System.out.println("[CardDatabase:getCardDayList]\n"+e);
			System.out.println("[CardDatabase:getCardDayList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 *	월간현황 조회
	 */	
	public Vector getCardMonStat(String gubun1, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String s_dt_where = "";

		if(gubun1.equals("1")){
			s_dt_where = " like to_char(sysdate,'YYYYMM')||'%' ";
		}else if(gubun1.equals("2")){
			s_dt_where = " like to_char(add_months(sysdate,-1),'YYYYMM')||'%' ";	
		}else if(gubun1.equals("3")){
			s_dt_where = " between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') ";
		}

		query = " SELECT c.card_kind, c.card_kind_nm, a.amt0, a.amt1, a.amt2, a.amt3, b.incom_amt "+
				" FROM   (SELECT c.code as card_kind, c.nm as card_kind_nm  FROM card_cont a, (select code, nm from code where c_st='0031' and code<>'0000') c WHERE a.card_kind=c.code GROUP BY c.code, c.nm) c, "+
				"        ( "+
				"         SELECT a.card_kind, "+
				"                NVL(SUM(decode(a.card_kind||a.save_per,'0002.1',0,base_amt)),0) amt0, "+
				"                NVL(SUM(DECODE(a.base_g,'자동차대금',decode(a.card_kind||a.save_per,'0002.1',0,base_amt))),0) amt1, "+
				"                NVL(SUM(DECODE(a.base_g,'자동차대금',0,'가지급금',0,'대여사업차량',0,'리스사업차량',0,'세금과공과',0,'자동차세',0,decode(a.card_kind||a.save_per,'0002.1',0,base_amt))),0) amt2, "+
				"                NVL(SUM(DECODE(a.base_g,'가지급금',decode(a.card_kind||a.save_per,'0002.1',0,base_amt),'대여사업차량',decode(a.card_kind||a.save_per,'0002.1',0,base_amt),'리스사업차량',decode(a.card_kind||a.save_per,'0002.1',0,base_amt),'세금과공과',decode(a.card_kind||a.save_per,'0002.1',0,base_amt),'자동차세',decode(a.card_kind||a.save_per,'0002.1',0,base_amt))),0) amt3 "+
				"         FROM   card_stat_base a "+
				"         WHERE  a.base_dt "+s_dt_where+" AND nvl(a.use_yn,'Y')<>'N' "+
				"         GROUP BY a.card_kind "+
				"        ) a, "+
				"        (SELECT card_kind, SUM(incom_amt) incom_amt FROM card_stat_scd where incom_dt "+s_dt_where+" GROUP BY card_kind) b "+
				" WHERE  c.card_kind=a.card_kind(+) AND c.card_kind=b.card_kind(+) AND (NVL(a.amt1,0)+NVL(b.incom_amt,0)) >0 "+
				" order by a.amt1 desc "+
				" ";

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
			System.out.println("[CardDatabase:getCardMonStat]\n"+e);
			System.out.println("[CardDatabase:getCardMonStat]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 *	카드사별 월간현황 리스트 조회
	 */	
	public Vector getCardMonList(String gubun1, String st_dt, String end_dt, String st, String card_kind)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		String s_dt_where = "";

		if(gubun1.equals("1")){
			s_dt_where = " like to_char(sysdate,'YYYYMM')||'%' ";
		}else if(gubun1.equals("2")){
			s_dt_where = " like to_char(add_months(sysdate,-1),'YYYYMM')||'%' ";	
		}else if(gubun1.equals("3")){
			s_dt_where = " between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') ";
		}

		//적립금 수금액
		if(st.equals("5")){

			query = " select * "+ 
					" from   card_stat_scd "+
					" where  card_kind='"+card_kind+"' and incom_dt "+s_dt_where+" ";

			query += " order by incom_dt, serial ";

		//사용금액
		}else{

			//구매자금	
			if(st.equals("1")){
				s_dt_where += " and base_g='자동차대금' ";
			//업무용
			}else if(st.equals("2")){
				s_dt_where += " and base_g not in ('자동차대금', '가지급금','대여사업차량','리스사업차량','세금과공과') ";
			//국세/지방세
			}else if(st.equals("3")){
				s_dt_where += " and base_g in ('가지급금','대여사업차량','리스사업차량','세금과공과') ";
			}

			query = " select * "+ 
					" from   card_stat_base "+
					" where  card_kind='"+card_kind+"' and base_dt "+s_dt_where+" and nvl(use_yn,'Y')<>'N' ";

			query += " order by base_dt, serial ";

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
			System.out.println("[CardDatabase:getCardMonList]\n"+e);
			System.out.println("[CardDatabase:getCardMonList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}


	/**
	 *	입금원장(카드캐쉬백)
	 */	
	public Vector getCardIncomStat(String card_kind, String s_dt, String s_sort, String gubun1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.* "+
				" FROM   card_stat_scd a "+
				" WHERE  a.incom_dt IS NULL AND a.card_kind='"+card_kind+"' "+
				"        and a.est_dt >= '20180801' and a.save_amt <> 0 "+
				" ";

		if(!s_dt.equals("")){
			query += " and a.est_dt like replace('"+s_dt+"','-','')||'%' ";
		}
		
		if(gubun1.equals("1")){
			query += " and a.base_g='구매자금' ";
		}else if(gubun1.equals("2")){
			query += " and a.base_g='업무용' ";
		}else if(gubun1.equals("3")){
			query += " and a.base_g='세금' ";
		}

		if(s_sort.equals("2")){
			query += " ORDER BY a.est_dt, a.save_amt desc, a.scd_dt, a.serial ";
		}if(s_sort.equals("3")){
			query += " ORDER BY a.scd_dt, a.save_amt desc, a.est_dt, a.serial ";
		}else{
			query += " ORDER BY a.est_dt, a.scd_dt, a.serial ";
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
			System.out.println("[CardDatabase:getCardIncomStat]\n"+e);
			System.out.println("[CardDatabase:getCardIncomStat]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}
	
	/**
	 *	입금원장(카드캐쉬백)
	 */	
	public Vector getCardIncomStat(String card_kind, String s_dt, String s_sort, String gubun1, String s_scd_dt, String e_scd_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.* "+
				" FROM   card_stat_scd a "+
				" WHERE  a.incom_dt IS NULL AND a.card_kind='"+card_kind+"' "+
				"        and a.est_dt >= '20180801' and a.save_amt <> 0 "+
				" ";

		if(!s_dt.equals("")){
			query += " and a.est_dt like replace('"+s_dt+"','-','')||'%' ";
		}
		
		if(!s_scd_dt.equals("") && !e_scd_dt.equals("")){
			query += " and a.scd_dt between replace('"+s_scd_dt+"','-','') and replace('"+e_scd_dt+"','-','') ";
		}
		
		if(gubun1.equals("1")){
			query += " and a.base_g='구매자금' ";
		}else if(gubun1.equals("2")){
			query += " and a.base_g='업무용' ";
		}else if(gubun1.equals("3")){
			query += " and a.base_g='세금' ";
		}

		if(s_sort.equals("2")){
			query += " ORDER BY a.est_dt, a.save_amt desc, a.scd_dt, a.serial ";
		}else if(s_sort.equals("3")){
			query += " ORDER BY a.scd_dt, a.save_amt desc, a.est_dt, a.serial ";
		}else{
			query += " ORDER BY a.est_dt, a.scd_dt, a.serial ";
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
			System.out.println("[CardDatabase:getCardIncomStat]\n"+e);
			System.out.println("[CardDatabase:getCardIncomStat]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}	

	/**
	 *	입금원장(카드캐쉬백) 리스트
	 */	
	public Vector getCardIncomList(String scd_dt, String card_kind)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.* "+
				" FROM   card_stat_base a "+
				" WHERE  a.base_dt='"+scd_dt+"' AND a.card_kind='"+card_kind+"' and nvl(a.use_yn,'Y')<>'N' "+
				" ";

		query += " ORDER BY a.base_g, a.base_bigo ";

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
			System.out.println("[CardDatabase:getCardIncomList]\n"+e);
			System.out.println("[CardDatabase:getCardIncomList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 *	입금원장(카드캐쉬백) 리스트 - 일괄수정
	 */	
	public Vector getCardIncomListAll(String est_dt, String scd_dt, String card_kind)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT b.*, c.acct_code "+
				" FROM   card_stat_base b, card_stat_scd a, card_doc c  "+
				" WHERE  b.card_kind='"+card_kind+"' and nvl(b.use_yn,'Y')<>'N' "+
			    "        and a.scd_dt=b.base_dt and a.card_kind=b.card_kind and a.reg_code=b.reg_code and a.est_dt=b.est_dt and a.rtn_dt=b.rtn_dt and a.incom_dt is null "+
				"        AND b.cardno=c.cardno(+) AND b.reqseq=c.buy_id(+) "+
				" ";

		if(!est_dt.equals(""))	query += " AND b.est_dt=replace('"+est_dt+"','-','')";
		if(!scd_dt.equals(""))	query += " AND b.base_dt=replace('"+scd_dt+"','-','')";

		query += " ORDER BY decode(b.card_kind,'0011',c.acct_code,'00000'), b.ven_name, b.base_bigo, b.base_dt ";

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
			System.out.println("[CardDatabase:getCardIncomListAll]\n"+query);
		} catch (SQLException e) {
			System.out.println("[CardDatabase:getCardIncomListAll]\n"+e);
			System.out.println("[CardDatabase:getCardIncomListAll]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 *	입금원장(카드캐쉬백) 리스트 - 일괄수정
	 */	
	public Vector getCardIncomListAll(String est_dt, String scd_dt, String card_kind, String s_scd_dt, String e_scd_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT b.*, c.acct_code "+
				" FROM   card_stat_base b, card_stat_scd a, card_doc c  "+
				" WHERE  b.card_kind='"+card_kind+"' and nvl(b.use_yn,'Y')<>'N' "+
			    "        and a.scd_dt=b.base_dt and a.card_kind=b.card_kind and a.reg_code=b.reg_code and a.est_dt=b.est_dt and a.rtn_dt=b.rtn_dt and a.incom_dt is null "+
				"        AND b.cardno=c.cardno(+) AND b.reqseq=c.buy_id(+) "+
				" ";

		if(!est_dt.equals(""))	query += " AND b.est_dt=replace('"+est_dt+"','-','')";
		if(!scd_dt.equals(""))	query += " AND b.base_dt=replace('"+scd_dt+"','-','')";

		if(!s_scd_dt.equals("")) query += " AND a.scd_dt >= replace('"+s_scd_dt+"','-','') ";
		if(!e_scd_dt.equals("")) query += " AND a.scd_dt <= replace('"+e_scd_dt+"','-','') ";

		query += " ORDER BY decode(b.card_kind,'0011',c.acct_code,'00000'), b.ven_name, b.base_bigo, b.base_dt ";

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
			//System.out.println("[CardDatabase:getCardIncomListAll]\n"+query);
		} catch (SQLException e) {
			System.out.println("[CardDatabase:getCardIncomListAll]\n"+e);
			System.out.println("[CardDatabase:getCardIncomListAll]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 *	입금원장(카드캐쉬백) 리스트 - 사용처별 캐쉬백율 관리
	 */	
	public Vector getCardSaveList(String card_kind)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.* "+
				" FROM   card_stat_save a "+
				" WHERE  a.card_kind='"+card_kind+"' "+
				" ";

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
			System.out.println("[CardDatabase:getCardSaveList]\n"+e);
			System.out.println("[CardDatabase:getCardSaveList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}



	/**
	 *	카드사별수금현황
	 */	
	public Vector getCardPayStat(String card_kind, String s_yy, String s_mm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		String s_dt_where = " LIKE '"+s_yy+""+s_mm+"%'";
		
		query = " SELECT a.reg_code, a.card_kind, a.base_dt, a.est_dt, a.base_g, a.base_amt, b.save_amt, a.save_per,  "+
				"        nvl(b.incom_amt,0) incom_amt, b.incom_dt, b.save_amt-nvl(b.incom_amt,0)-nvl(b.m_amt,0) dly_amt, nvl(b.m_amt,0) m_amt "+
				" FROM   "+
				"        (select reg_code, card_kind, base_dt, est_dt, max(base_g) base_g, sum(decode(card_kind,'0002',decode(save_per,0.1,0,base_amt),base_amt)) base_amt, sum(save_amt) save_amt, max(save_per) save_per "+
				"         from   card_stat_base "+
				"         where  base_dt "+s_dt_where+" AND card_kind='"+card_kind+"' and nvl(use_yn,'Y')<>'N' "+
				"         group by reg_code, card_kind, base_dt, est_dt "+
				"        ) a, "+
				"        (select reg_code, card_kind, scd_dt, est_dt, sum(decode(tm,'1',scd_amt,0)) scd_amt, sum(decode(tm,'1',save_amt,0)) save_amt, sum(incom_amt) incom_amt, max(incom_dt) incom_dt, sum(DECODE(sign(m_amt),-1,0,m_amt)) m_amt "+
				"         from   card_stat_scd "+
				"         where  scd_dt "+s_dt_where+" and card_kind='"+card_kind+"' "+
				"         group by reg_code, card_kind, scd_dt, est_dt "+
				"        ) b "+
				" WHERE  a.reg_code=b.reg_code(+) and a.card_kind=b.card_kind(+) and a.base_dt=b.scd_dt(+) and a.est_dt=b.est_dt(+) "+
				" ORDER BY a.base_dt, a.est_dt, a.reg_code "+
				" ";

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
			System.out.println("[CardDatabase:getCardPayStat]\n"+e);
			System.out.println("[CardDatabase:getCardPayStat]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}
	
	/**
	 *	카드사별수금현황
	 */	
	public Vector getCardPayStat(String card_kind, String s_yy, String s_mm, String gubun1, String gubun2, String st_dt, String end_dt, String gubun3)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String base_amt_query = "base_amt";
		String sdtTarget = "";
		String sdtTarget2 = "";
		String sdtTarget3 = "";
		
		if(!gubun2.equals("")){
			base_amt_query = "decode(save_amt,0,0,base_amt)";  
		}

		String s_dt_where = " LIKE '"+s_yy+""+s_mm+"%'"; 
		
		if(gubun1.equals("2")){
			s_dt_where = " between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') ";
		}
		
		if(!card_kind.equals("")){
			s_dt_where += " AND card_kind='"+card_kind+"' ";  
		}
		
		if(gubun3.equals("2")) {
			sdtTarget = "incom_dt";
		} else {
			sdtTarget = "scd_dt";
		}
		
		if(gubun3.equals("2")) {
			sdtTarget2 = "";
		} else {
			sdtTarget2 = " and base_dt "+s_dt_where+" ";
		}
		
		if(gubun3.equals("2")) {
			sdtTarget3 = " a.base_dt=b.scd_dt";
		} else {
			sdtTarget3 = "a.base_dt=b.scd_dt(+)";
		}
		
		query = " SELECT a.reg_code, a.card_kind, a.base_dt, a.est_dt, a.base_g, a.base_amt, b.save_amt, a.save_per,  "+
				"        nvl(b.incom_amt,0) incom_amt, b.incom_dt, b.save_amt-nvl(b.incom_amt,0)-nvl(b.m_amt,0) dly_amt, nvl(b.m_amt,0) m_amt, b.bigo "+
				" FROM   "+
				"        (select reg_code, card_kind, base_dt, est_dt, max(base_g) base_g, sum(decode(card_kind,'0002',decode(save_per,0.1,0,base_amt),"+base_amt_query+")) base_amt, sum(save_amt) save_amt, max(save_per) save_per "+
				"         from   card_stat_base "+
				"          where nvl(use_yn,'Y')<>'N' "+
				"		   "+sdtTarget2+" " +
//				"         and  base_dt "+s_dt_where+""+
				"         group by reg_code, card_kind, base_dt, est_dt "+
				"        ) a, "+
				"        (select reg_code, card_kind, scd_dt, est_dt, sum(decode(tm,'1',scd_amt,0)) scd_amt, sum(decode(tm,'1',save_amt,0)) save_amt, sum(incom_amt) incom_amt, max(incom_dt) incom_dt, sum(DECODE(sign(m_amt),-1,0,m_amt)) m_amt, max(incom_bigo) bigo  "+
				"         from   card_stat_scd "+
				"         where  "+sdtTarget+" "+s_dt_where+" "+
				"         group by reg_code, card_kind, scd_dt, est_dt "+
				"        ) b "+
				" WHERE  a.reg_code=b.reg_code(+) and a.card_kind=b.card_kind(+) and "+sdtTarget3+" and a.est_dt=b.est_dt(+) "+
				" ORDER BY a.base_dt, a.card_kind, a.est_dt, a.reg_code "+
				" ";

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
			System.out.println("[CardDatabase:getCardPayStat]\n"+e);
			System.out.println("[CardDatabase:getCardPayStat]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}	
	
	/**
	 *	카드사별수금현황2
	 */	
	public Vector getCardPayStat2(String card_kind, String s_yy, String s_mm, String gubun1, String gubun2, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		String s_dt_where = " LIKE '"+s_yy+""+s_mm+"%'"; 
		
		query = "SELECT a.card_kind, d.nm,\r\n"
				+ "     COUNT(0) cnt1, SUM(a.save_amt) amt1,  \r\n"
				+ "		NVL(COUNT(DECODE(nvl(b.incom_amt,0),0,'',a.card_kind)),0) cnt2,\r\n"
				+ "		NVL(SUM  (DECODE(nvl(b.incom_amt,0),0,0,a.save_amt)),0) amt2,\r\n"
				+ "     NVL(COUNT(DECODE(nvl(b.incom_amt,0),0,a.card_kind)),0) cnt3,\r\n"
				+ "		NVL(SUM  (DECODE(nvl(b.incom_amt,0),0,a.save_amt)),0) amt3,\r\n"
				+ "     NVL(COUNT(CASE WHEN nvl(b.incom_amt,0)=0 AND a.est_dt> to_char(SYSDATE,'YYYYMMDD') THEN a.card_kind ELSE '' end),0) cnt4,\r\n"
				+ "		NVL(SUM  (CASE WHEN nvl(b.incom_amt,0)=0 AND a.est_dt> to_char(SYSDATE,'YYYYMMDD') THEN a.save_amt ELSE 0 end),0) amt4,\r\n"
				+ "     NVL(COUNT(CASE WHEN nvl(b.incom_amt,0)=0 AND a.est_dt< to_char(SYSDATE,'YYYYMMDD') THEN a.card_kind ELSE '' end),0) cnt5,\r\n"
				+ "		NVL(SUM  (CASE WHEN nvl(b.incom_amt,0)=0 AND a.est_dt< to_char(SYSDATE,'YYYYMMDD') THEN a.save_amt ELSE 0 end),0) amt5,\r\n"
				+ "     SUM(nvl(b.incom_amt,0)) amt6\r\n"
				+ "FROM \r\n"
				+ "       ( SELECT card_kind, reg_code, base_dt, est_dt, SUM(save_amt) save_amt \r\n"
				+ "         FROM   card_stat_base \r\n"
				+ "         WHERE  base_dt "+s_dt_where+" AND nvl(use_yn,'Y')<>'N'\r\n"
				+ "         GROUP BY card_kind, reg_code, base_dt, est_dt\r\n"
				+ "       ) a, \r\n"
				+ "       ( SELECT card_kind, reg_code, scd_dt, est_dt, NVL(SUM(incom_amt),0) incom_amt \r\n"
				+ "         FROM   card_stat_scd \r\n"
				+ "         WHERE  scd_dt "+s_dt_where+" \r\n"
				+ "         GROUP BY card_kind, reg_code, scd_dt, est_dt\r\n"
				+ "       ) b,\r\n"
				+ "       code d\r\n"
				+ "WHERE a.card_kind=b.card_kind AND a.reg_code=b.reg_code AND a.base_dt=b.scd_dt AND a.est_dt=b.est_dt\r\n"
				+ "AND a.card_kind=d.code AND d.c_st='0031' AND d.code<>'0000' \r\n"
				+ "GROUP BY a.card_kind, d.nm \r\n"
				+ "ORDER BY d.nm";
		

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
			System.out.println("[CardDatabase:getCardPayStat2]\n"+e);
			System.out.println("[CardDatabase:getCardPayStat2]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}		

	/**
	 *	기본현황 조회
	 */	
	public Vector getCardBaseStat()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = " SELECT card_kind, "+
				"        NVL(SUM(DECODE(SUBSTR(scd_dt,1,6),to_char(add_months(sysdate,-1),'YYYYMM'),scd_amt)),0) amt1, "+
				"        NVL(SUM(DECODE(SUBSTR(scd_dt,1,6),TO_CHAR(SYSDATE,'YYYYMM'),               scd_amt)),0) amt2, "+
				"        NVL(SUM(scd_amt),0) amt3, "+
				"        NVL(SUM(DECODE(SUBSTR(scd_dt,1,6),to_char(add_months(sysdate,-1),'YYYYMM'),save_amt)),0) amt4, "+
				"        NVL(SUM(DECODE(SUBSTR(scd_dt,1,6),to_char(add_months(sysdate,-1),'YYYYMM'),incom_amt)),0) amt5, "+
				"        NVL(SUM(DECODE(SUBSTR(scd_dt,1,6),TO_CHAR(SYSDATE,'YYYYMM'),               save_amt)),0) amt6, "+
				"        NVL(SUM(DECODE(SUBSTR(scd_dt,1,6),TO_CHAR(SYSDATE,'YYYYMM'),               incom_amt)),0) amt7, "+
				"        NVL(SUM(save_amt),0) amt8, "+
				"        NVL(SUM(incom_amt),0) amt9, "+
				"        NVL(SUM(save_amt),0)-NVL(SUM(incom_amt),0) amt10 "+
				" FROM   card_stat_scd  "+
				" where  scd_dt BETWEEN to_char(add_months(sysdate,-1),'YYYYMM')||'01' AND TO_CHAR(LAST_DAY(SYSDATE),'YYYYMMDD') "+
				"        AND tm=1 "+
				" GROUP BY card_kind "+
				" ORDER BY DECODE(card_kind,'0007',1,'0001',2,'0016',3,'0011',4,'0002',5,'0012',6,'0017',7,8) "+
				" ";	
		
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
			System.out.println("[CardDatabase:getCardBaseStat]\n"+e);
			System.out.println("[CardDatabase:getCardBaseStat]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 *	기본현황 리스트 조회
	 */	
	public Vector getCardBaseList(String st, String card_kind)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		String s_dt_where = "";

		//전월
		if(st.equals("1") || st.equals("4") || st.equals("5")){
			s_dt_where = " like to_char(add_months(sysdate,-1),'YYYYMM')||'%' ";	
		//당월
		}else if(st.equals("2")||st.equals("6")||st.equals("7")){
			s_dt_where = " like to_char(sysdate,'YYYYMM')||'%' ";
		}else{ 
			s_dt_where = " BETWEEN to_char(add_months(sysdate,-1),'YYYYMM')||'01' AND TO_CHAR(LAST_DAY(SYSDATE),'YYYYMMDD') ";
		}

		//사용금액
		if(st.equals("1")||st.equals("2")||st.equals("3")){
			s_dt_where += " and scd_amt > 0 ";
		//적립금액+손익
		}else if(st.equals("4")||st.equals("6")||st.equals("8")){
			s_dt_where += " and (save_amt+nvl(m_amt,0)) <> 0 ";
		//입금
		}else if(st.equals("5")||st.equals("7")||st.equals("9")){
			s_dt_where += " and nvl(incom_amt,0) > 0 ";
		}

		query = " select a.* "+ 
				" from   card_stat_scd a "+
				" where  a.card_kind='"+card_kind+"' and a.scd_dt "+s_dt_where+" and a.tm=1 "+
				" order by a.scd_dt";
		

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
			System.out.println("[CardDatabase:getCardBaseList]\n"+e);
			System.out.println("[CardDatabase:getCardBaseList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 *	카드사별 스케줄 리스트 조회
	 */	
	public Vector getCardStatScdList(String card_kind, String base_dt, String est_dt, String reg_code)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select b.b_save_amt, a.* "+ 
				" from   card_stat_scd a, "+
				"        ( SELECT sum(save_amt) b_save_amt "+
				"          FROM   card_stat_base "+
				"          WHERE  card_kind='"+card_kind+"' AND base_dt='"+base_dt+"' AND est_dt='"+est_dt+"' AND reg_code='"+reg_code+"' and nvl(use_yn,'Y')<>'N' "+
				"        ) b "+
				" where a.card_kind='"+card_kind+"' AND a.scd_dt='"+base_dt+"' AND est_dt='"+est_dt+"' AND a.reg_code='"+reg_code+"' "+
				" ";
			
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
			System.out.println("[CardDatabase:getCardStatScdList]\n"+e);
			System.out.println("[CardDatabase:getCardStatScdList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/**
	 *	카드거래처
	 */	
	public Hashtable getCardVener(CardStatBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " SELECT DISTINCT DECODE(c.n_ven_code,'',d.com_code,c.n_ven_code) n_ven_code, DECODE(c.n_ven_code,'',d.com_name,c.n_ven_name) n_ven_name "+
				" FROM   card_stat_scd a, card_stat_base b, card_cont c, card d "+
				" WHERE  a.scd_dt='"+bean.getScd_dt()+"' and a.card_kind='"+bean.getCard_kind()+"' and a.reg_code='"+bean.getReg_code()+"' "+
				"        and a.scd_dt=b.base_dt and a.card_kind=b.card_kind and a.reg_code=b.reg_code and a.est_dt=b.est_dt and a.rtn_dt=b.rtn_dt and nvl(b.use_yn,'Y')<>'N' "+
				"        and b.cardno=c.cardno "+
				"        and c.cardno=d.cardno "+
				" ";

		try {
			pstmt = conn.prepareStatement(query);
		    rs = pstmt.executeQuery();
	    	ResultSetMetaData rsmd = rs.getMetaData();
    	
			if(rs.next())
			{								
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}				
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CardDatabase:getCardVener]\n"+e);
			System.out.println("[CardDatabase:getCardVener]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}		
	}

	/**
	 *	카드거래처별 담당자
	 */	
	public Hashtable getCardAgnt(String card_kind, String off_nm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " SELECT '1' st, a.emp_nm, a.emp_mtel, a.emp_tel, a.emp_email, a.emp_addr  "+
				" from   serv_off b, serv_emp a, (SELECT off_id, max(seq) seq FROM serv_emp GROUP BY off_id) c  "+
				" WHERE  b.off_nm ='"+off_nm+"' "+
				"        and a.off_id=b.off_id "+
				"        AND a.off_id=c.off_id AND a.seq=c.seq "+
			    " union all "+
		        " SELECT DISTINCT '2' st, a.agnt_nm as emp_nm, a.agnt_m_tel as emp_mtel, a.agnt_tel as emp_tel, '' emp_email, '' emp_addr  "+
				" from   card_cont a, card b, (select code, nm from code where c_st='0031' and code<>'0000') c "+
				" WHERE  a.card_kind ='"+card_kind+"' and a.cardno=b.cardno and a.card_kind=c.code "+
				" order by 1 ";

		try {
			pstmt = conn.prepareStatement(query);
		    rs = pstmt.executeQuery();
	    	ResultSetMetaData rsmd = rs.getMetaData();
    	
			if(rs.next())
			{								
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}				
			}
			rs.close();
			pstmt.close();


		} catch (SQLException e) {
			System.out.println("[CardDatabase:getCardAgnt]\n"+e);
			System.out.println("[CardDatabase:getCardAgnt]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}		
	}



	/*
	 *	카드캐쉬백 프로시져 호출
	*/
	public String call_sp_card_cont_reg()
	{
    	getConnection();
    	
    	String query = "{CALL P_CARD_CONT_REG }";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
			cstmt = conn.prepareCall(query);
			cstmt.execute();
			cstmt.close();
	
		} catch (SQLException e) {
			System.out.println("[CardDatabase:call_sp_card_cont_reg]\n"+e);
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
	 *	카드사용 한건 조회
	 *  
	 */	
	public CardStatBean getCardStatSave(String card_kind, String ven_name)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		CardStatBean bean = new CardStatBean();
		String query = "";

		query = " select card_kind, ven_name, save_per "+
				" from   card_stat_save "+
				" where  card_kind=? and ven_name=? ";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,	card_kind);
			pstmt.setString(2,	ven_name);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{			
				bean.setCard_kind		(rs.getString(1));
				bean.setVen_name		(rs.getString(2));
				bean.setSave_per		(rs.getFloat(3));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CardDatabase:getCardStatSave]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}		
	}

	//카드사용 한건 수정
	public boolean updateCardStatSave(CardStatBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";

		query = " update card_stat_save set "+
				"	save_per=? "+
				" where card_kind=? and ven_name=? "+
				" ";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setFloat 	(1,		bean.getSave_per	());
			pstmt.setString (2,		bean.getCard_kind	());
			pstmt.setString (3,		bean.getVen_name	());
			pstmt.executeUpdate();
			pstmt.close();
			
			conn.commit();
				
	  	} catch (Exception e) {
			System.out.println("[CardDatabase:updateCardStatSave(CardStatBean bean)]\n"+e);
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
	 *	카드사별 스케줄 리스트 조회
	 */	
	public Vector getCardStatBaseMonList(String card_kind, String base_dt, String est_dt, String reg_code)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select * "+ 
				" from   card_stat_base "+
				" WHERE  card_kind='"+card_kind+"' AND base_dt='"+base_dt+"' AND est_dt='"+est_dt+"' AND reg_code='"+reg_code+"' and nvl(use_yn,'Y')<>'N' "+
				" ";
			
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
			System.out.println("[CardDatabase:getCardStatBaseMonList]\n"+e);
			System.out.println("[CardDatabase:getCardStatBaseMonList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}
	
	/* 전북카드 청구일 */
	public Vector getDemandDate()
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select charge_date from ebank.demand_data  group by charge_date order by charge_date desc ";

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
			System.out.println("[getDemandDate]\n"+e);
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

	
	/* 전북카드 청구일 */
	public Vector getDemandList(String charge_dt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
				
		query = "	select b.cardno , \n" +
				"			DECODE(grouping_id (b.cardno, b.card_name),1,'소계',3,'합계',MAX(b.card_name)) card_name, \n" +
				"			a.approve_date, a.vendor_name , sum(a.approve_total) amt \n" +
				"			from ebank.demand_data a, card b \n" +
				"			where a.card_num = replace(b.cardno , '-' , '') \n" +
				"			and a.charge_date  = '" + charge_dt +  "' and  a.approve_total > 0  \n" +
				"			group by grouping sets ((b.cardno, b.card_name, a.approve_date, a.vendor_name ), (b.cardno), ()) \n" +
				"			order by b.cardno, grouping_id(b.cardno, b.card_name) ";
		

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
			System.out.println("[getDemandList]\n"+e);
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
	
	/*탁송 입력한 전표 갯수 찾기
	 * author : 성승현
	 */

	public int getCardCorona(String cardno)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		int coamt = 0;
	
		query = " select sum(buy_amt) from card_doc where acct_code = '00001' and acct_code_g2 = '33' " +
				" and cardno ='"+cardno+"'";
	
		try {
			pstmt = conn.prepareStatement(query); 
	    	rs = pstmt.executeQuery();
		
			if(rs.next())
			{			
				coamt = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		
		} catch (SQLException e) {
			System.out.println("[getCardCorona(String cardno)]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return coamt;
		}		
	}
	
	public int getCardCoronaUser(String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		int coamt = 0;
	
	//	query = " select sum(buy_amt) from card_doc where acct_code = '00001' and acct_code_g2 = '33' " +
	//			" and buy_user_id ='"+user_id+"'";
		
		query = " SELECT  sum(b.doc_amt) doc_amt  FROM card_doc a, card_doc_user  b " +
				" WHERE  a.acct_code = '00001' AND  a.acct_code_g2 = '33' " +
				"  AND a.cardno = b.cardno(+) AND a.buy_id = b.buy_id(+) and b.doc_user = '"+user_id+"'";
				 
	
		try {
			pstmt = conn.prepareStatement(query); 
	    	rs = pstmt.executeQuery();
		
			if(rs.next())
			{			
				coamt = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		
		} catch (SQLException e) {
			System.out.println("[getCardCoronaUser(String user_id)]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return coamt;
		}		
	}
	
	/**
	 *	신용카드할부용 카드관리 한건 조회
	 *  
	 */	
	public CardBean getCardDept(String card_kind)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		CardBean bean = new CardBean();
		String query = "";

		query = " select * from card where card_kind=? and card_paid='7' and use_yn='Y' ";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,	card_kind);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{			
				bean.setCardno		(rs.getString(1));
				bean.setCard_kind	(rs.getString(2));
				bean.setCard_name	(rs.getString(3));
				bean.setCom_code	(rs.getString(4));
				bean.setCard_sdate	(rs.getString(5));
				bean.setCard_edate	(rs.getString(6));
				bean.setLimit_st	(rs.getString(7));
				bean.setLimit_amt	(rs.getLong(8));
				bean.setPay_day		(rs.getString(9));
				bean.setUse_s_m		(rs.getString(10));
				bean.setUse_s_day	(rs.getString(11));
				bean.setUse_e_m		(rs.getString(12));
				bean.setUse_e_day	(rs.getString(13));
				bean.setUser_id		(rs.getString(14));
				bean.setEtc			(rs.getString(15));
				bean.setUse_yn		(rs.getString(16));
				bean.setCls_dt		(rs.getString(17));
				bean.setCls_cau		(rs.getString(18));
				bean.setCard_st		(rs.getString(19));
				bean.setReceive_dt	(rs.getString(20));
				bean.setCard_mng_id	(rs.getString(21));
				bean.setDoc_mng_id	(rs.getString(22));
				bean.setUser_seq	(rs.getString(23));
				bean.setCom_name	(rs.getString(24));
				bean.setMile_st		(rs.getString(25));
				bean.setMile_per	(rs.getString(26));
				bean.setMile_amt	(rs.getInt(27));
				bean.setCard_chk	(rs.getString(28));
				bean.setAcc_no 	    (rs.getString(29));
				bean.setCard_type   (rs.getString(30)==null?"":rs.getString(30));
				bean.setCard_paid   (rs.getString(31)==null?"":rs.getString(31));
				bean.setCard_kind_cd(rs.getString(32)==null?"":rs.getString(32));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CardDatabase:getCardDept(String card_kind)]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}		
	}	
	
	/**
	 *	카드대금상환스케줄
	 */	
	public Vector getCardRtnStat(String card_kind, String s_yy, String s_mm, String gubun1, String gubun2, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		
		String s_dt_where = " and a.rtn_dt LIKE '"+s_yy+""+s_mm+"%'"; 
		
		if(gubun1.equals("2")){
			s_dt_where = " and a.rtn_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') ";
		}
		
		if(gubun1.equals("3")){
			s_dt_where = " AND a.use_e_dt >= TO_CHAR(SYSDATE,'YYYYMMDD') ";
		}
		
		if(!card_kind.equals("")){
			s_dt_where += " AND a.card_kind='"+card_kind+"' ";  
		}
		
		if(!gubun2.equals("")){
			s_dt_where += " and DECODE(a.card_st,'1','1','3','2','3') = '"+gubun2+"'";
		}
		
		
		query = " select c.nm, b.cont_amt, a.rtn_dt, a.o_rtn_dt, a.use_s_dt, a.use_e_dt, a.card_kind, a.card_st, \r\n"
				+ "       a.cardno, a.base_amt, a.save_amt, (b.cont_amt-NVL(a.base_amt,0)) jan_amt,\r\n"
				+ "       DECODE(a.card_st,'1','구매자금','기타') card_st_nm\r\n"
				+ "FROM \r\n"
				+ "       (SELECT nvl(a.r_rtn_dt,a.rtn_dt) rtn_dt, a.rtn_dt as o_rtn_dt, a.use_s_dt, a.use_e_dt, a.card_kind, a.cardno, b.card_st, SUM(a.base_amt) base_amt, SUM(a.save_amt) save_amt \r\n"
				+ "        FROM   card_stat_base a, card b \r\n"
				+ "        WHERE  a.base_dt>='20210701' AND a.cardno=b.cardno AND b.card_st<>'3' and nvl(b.card_paid,'3')<>'7' and nvl(a.use_yn,'Y')<>'N' \r\n"
				+ "        GROUP BY nvl(a.r_rtn_dt,a.rtn_dt), a.rtn_dt, a.use_s_dt, a.use_e_dt, a.card_kind, a.cardno, b.card_st\r\n"
				+ "       ) a,\r\n"
				+ "       card_cont b, \r\n"
				+ "       (SELECT cardno, MAX(seq) seq FROM card_cont group BY cardno) b2, \r\n"
				+ "       (SELECT * FROM code WHERE c_st='0031' AND code<>'0000') c\r\n"
				+ "WHERE  a.cardno=b.cardno \r\n"
				+ "       AND b.cardno=b2.cardno AND b.seq=b2.seq \r\n"
				+ "       AND a.card_kind=c.code\r\n"+s_dt_where
				+ "UNION ALL        \r\n"
				+ "select c.nm, e.cont_amt, a.rtn_dt, a.o_rtn_dt, a.use_s_dt, a.use_e_dt, a.card_kind, a.card_st, \r\n"
				+ "       a.cardno, a.base_amt, a.save_amt, (e.cont_amt-NVL(a.base_amt,0)) jan_amt,\r\n"
				+ "       '임/직원업무용' card_st_nm \r\n"
				+ "FROM \r\n"
				+ "       (SELECT nvl(a.r_rtn_dt,a.rtn_dt) rtn_dt, a.rtn_dt as o_rtn_dt, a.use_s_dt, a.use_e_dt, a.card_kind, b.card_st, '임/직원업무용' cardno, SUM(a.base_amt) base_amt, SUM(a.save_amt) save_amt \r\n"
				+ "        FROM   card_stat_base a, card b \r\n"
				+ "        WHERE  a.base_dt>='20210701' AND a.cardno=b.cardno AND b.card_st='3' and nvl(b.card_paid,'3')<>'7' and nvl(a.use_yn,'Y')<>'N'\r\n"
				+ "        GROUP BY nvl(a.r_rtn_dt,a.rtn_dt), a.rtn_dt, a.use_s_dt, a.use_e_dt, a.card_kind, b.card_st\r\n"
				+ "       ) a,\r\n"
				+ "       (SELECT * FROM code WHERE c_st='0031' AND code<>'0000') c,\r\n"
				+ "       (SELECT a.card_kind, SUM(a.cont_amt) cont_amt \r\n"
				+ "        FROM   card_cont a, (SELECT cardno, MAX(seq) seq FROM card_cont group BY cardno) b, card c \r\n"
				+ "        WHERE a.cardno=b.cardno AND a.seq=b.seq AND a.cardno=c.cardno AND c.card_st='3' and nvl(c.card_paid,'3')<>'7'\r\n"
				+ "        GROUP BY a.card_kind) e\r\n"
				+ "WHERE  a.card_kind=c.code\r\n"
				+ "       AND a.card_kind=e.card_kind \r\n"+s_dt_where
				+" ";
		
		if(gubun1.equals("3")){
			query += " ORDER BY 1, 5 ";	
		}else {		
			query += " ORDER BY 3, 4 ";
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
			System.out.println("[CardDatabase:getCardRtnStat]\n"+e);
			System.out.println("[CardDatabase:getCardRtnStat]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}	
	
	/**
	 *	카드대금상환스케줄
	 */	
	public Vector getCardRtnStat2(String card_kind, String s_yy, String s_mm, String gubun1, String gubun2, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String b_query = "";
		String query = "";
		
		
		String s_dt_where = " and a.rtn_dt LIKE '"+s_yy+""+s_mm+"%'"; 
		
		if(gubun1.equals("2")){
			s_dt_where = " and a.rtn_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') ";
		}
		
		if(!card_kind.equals("")){
			s_dt_where += " AND a.card_kind='"+card_kind+"' ";  
		}
		
		if(!gubun2.equals("")){
			s_dt_where += " and DECODE(a.card_st,'1','1','3','2','3') = '"+gubun2+"'";
		}
		
		
		b_query = " select c.nm, b.cont_amt, a.rtn_dt, a.card_kind, a.card_st, \r\n"
				+ "       a.cardno, a.base_amt, a.save_amt, (b.cont_amt-NVL(a.base_amt,0)) jan_amt,\r\n"
				+ "       DECODE(a.card_st,'1','구매자금','기타') card_st_nm, nvl(d.i_amt,0) i_amt \r\n"
				+ "FROM \r\n"
				+ "       (SELECT nvl(a.r_rtn_dt,a.rtn_dt) rtn_dt, a.card_kind, a.cardno, b.card_st, SUM(a.base_amt) base_amt, SUM(a.save_amt) save_amt \r\n"
				+ "        FROM   card_stat_base a, card b \r\n"
				+ "        WHERE  a.base_dt>='20210701' AND a.cardno=b.cardno AND b.card_st<>'3' and nvl(b.card_paid,'3')<>'7' and nvl(a.use_yn,'Y')<>'N' \r\n"
				+ "        GROUP BY nvl(a.r_rtn_dt,a.rtn_dt), a.card_kind, a.cardno, b.card_st \r\n"
				+ "       ) a,\r\n"
				+ "       card_cont b, \r\n"
				+ "       (SELECT cardno, MAX(seq) seq FROM card_cont group BY cardno) b2, \r\n"
				+ "       (SELECT * FROM code WHERE c_st='0031' AND code<>'0000') c,\r\n"
				+ "       (SELECT decode(b.p_pay_dt,a.p_cd1,a.p_cd1,b.p_pay_dt) AS rtn_dt, a.p_cd2 AS cardno, SUM(a.i_amt) i_amt FROM pay_item a, pay b WHERE a.reqseq=b.reqseq and a.p_st2 LIKE '법인카드대금%' GROUP BY decode(b.p_pay_dt,a.p_cd1,a.p_cd1,b.p_pay_dt), a.p_cd2) d \r\n"
				+ "WHERE  a.cardno=b.cardno \r\n"
				+ "       AND b.cardno=b2.cardno AND b.seq=b2.seq \r\n"
				+ "       AND a.card_kind=c.code and a.cardno=d.cardno(+) and a.rtn_dt=d.rtn_dt(+) \r\n"+s_dt_where
				+ "UNION ALL        \r\n"
				+ "select c.nm, e.cont_amt, a.rtn_dt, a.card_kind, a.card_st, \r\n"
				+ "       a.cardno, a.base_amt, a.save_amt, (e.cont_amt-NVL(a.base_amt,0)) jan_amt,\r\n"
				+ "       '임/직원업무용' card_st_nm, a.i_amt \r\n"
				+ "FROM \r\n"
				+ "       (SELECT a.rtn_dt, a.card_kind, a.card_st, '임/직원업무용' cardno, SUM(a.base_amt) base_amt, SUM(a.save_amt) save_amt, SUM(NVL(d.i_amt,0)) i_amt\r\n"
				+ "                   FROM ( \r\n"
				+ "                          SELECT nvl(a.r_rtn_dt,a.rtn_dt) rtn_dt, a.card_kind, b.card_st, a.cardno, SUM(a.base_amt) base_amt, SUM(a.save_amt) save_amt\r\n"
				+ "				                  FROM   card_stat_base a, card b\r\n"
				+ "				                  WHERE  a.base_dt>='20210701' AND a.cardno=b.cardno AND b.card_st='3' and nvl(b.card_paid,'3')<>'7' and nvl(a.use_yn,'Y')<>'N'\r\n"
				+ "				                  GROUP BY nvl(a.r_rtn_dt,a.rtn_dt), a.card_kind, b.card_st, a.cardno\r\n"
				+ "                         ) a,\r\n"
				+ "                         (SELECT decode(b.p_pay_dt,a.p_cd1,a.p_cd1,b.p_pay_dt) AS rtn_dt, a.p_cd2 AS cardno, SUM(a.i_amt) i_amt FROM pay_item a, pay b WHERE a.reqseq=b.reqseq and a.p_st2 LIKE '법인카드대금%' GROUP BY decode(b.p_pay_dt,a.p_cd1,a.p_cd1,b.p_pay_dt), a.p_cd2) d\r\n"
				+ "                   WHERE a.cardno=d.cardno(+) and a.rtn_dt=d.rtn_dt(+)      \r\n"
				+ "                   GROUP BY a.rtn_dt, a.card_kind, a.card_st \r\n"
				+ "       ) a,\r\n"
				+ "       (SELECT * FROM code WHERE c_st='0031' AND code<>'0000') c,\r\n"
				+ "       (SELECT a.card_kind, SUM(a.cont_amt) cont_amt \r\n"
				+ "        FROM   card_cont a, (SELECT cardno, MAX(seq) seq FROM card_cont group BY cardno) b, card c \r\n"
				+ "        WHERE a.cardno=b.cardno AND a.seq=b.seq AND a.cardno=c.cardno AND c.card_st='3' and nvl(c.card_paid,'3')<>'7'\r\n"
				+ "        GROUP BY a.card_kind) e\r\n"
				+ "WHERE  a.card_kind=c.code\r\n"
				+ "       AND a.card_kind=e.card_kind \r\n"+s_dt_where
				+" ";
		
		
		query += " select rtn_dt, sum(base_amt) base_amt, sum(i_amt) i_amt from ("+b_query+") group by rtn_dt order by 1 ";  

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
			System.out.println("[CardDatabase:getCardRtnStat2]\n"+e);
			System.out.println("[CardDatabase:getCardRtnStat2]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}		
	
	/**
	 *	카드별 상환스케줄
	 */	
	public Vector getCardRtnList(String rtn_dt, String cardno)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select * "+ 
				" from   card_stat_base "+
				" where  cardno='"+cardno+"' and nvl(r_rtn_dt,rtn_dt)='"+rtn_dt+"' and nvl(use_yn,'Y')<>'N' ";

		query += " order by base_dt, serial ";


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
			System.out.println("[CardDatabase:getCardRtnList]\n"+e);
			System.out.println("[CardDatabase:getCardRtnList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}	
	
	//카드사용 한건 수정
	public boolean updateCardDocCancel(String cardno ,String buy_id)
	{
			getConnection();

			boolean flag = true;
			PreparedStatement pstmt = null;
			String query = "";

			query = " update card_doc set "+
					"	app_id = null  "+
					" where cardno=? and buy_id=? "+
					" ";

			try 
			{
				conn.setAutoCommit(false);
				
				pstmt = conn.prepareStatement(query);
				pstmt.setString (1,		cardno);
				pstmt.setString (2,		buy_id);
			
				pstmt.executeUpdate();
				pstmt.close();
				
				conn.commit();
					
		  	} catch (Exception e) {
				System.out.println("[CardDatabase:updateCardDocCancel()]\n"+e);
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
	 *	카드대금상환스케줄
	 */	
	public Vector getCardRtnStat2(String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String b_query = "";
		String query = "";
		
		String s_dt_where = " and a.a_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') ";
		
		query = " SELECT a.a_dt, \r\n"
				+ "       b.b_amt, \r\n"
				+ "       c.rtn_dt, \r\n"
				+ "       c.c_amt, \r\n"
				+ "       a.a_amt, \r\n"
				+ "       d.d_dt, \r\n"
				+ "       d.d_amt, \r\n"
				+ "       (NVL(a.a_amt,0)-NVL(d.d_amt,0)) e_amt \r\n"
				+ "  FROM --기준 \r\n"
				+ "       (SELECT nvl(r_rtn_dt,rtn_dt) a_dt, \r\n"
				+ "              SUM(base_amt) a_amt \r\n"
				+ "         FROM card_stat_base \r\n"
				+ "        WHERE base_dt>='20210701' \r\n"
				+ "              AND nvl(use_yn,'Y')<>'N' \r\n"
				+ "        GROUP BY nvl(r_rtn_dt,rtn_dt)\r\n"
				+ "       ) a, \r\n"
				+ "       --정기상환 \r\n"
				+ "       (SELECT rtn_dt AS b_dt, \r\n"
				+ "              SUM(base_amt) b_amt \r\n"
				+ "         FROM card_stat_base \r\n"
				+ "        WHERE base_dt>='20210701' \r\n"
				+ "              AND nvl(use_yn,'Y')<>'N' \r\n"
				+ "        GROUP BY rtn_dt\r\n"
				+ "       ) b, \r\n"
				+ "       --조기상환 \r\n"
				+ "       (SELECT rtn_dt, \r\n"
				+ "              r_rtn_dt AS c_dt, \r\n"
				+ "              SUM(base_amt) c_amt \r\n"
				+ "         FROM card_stat_base \r\n"
				+ "        WHERE base_dt>='20210701' \r\n"
				+ "              AND nvl(use_yn,'Y')<>'N' \r\n"
				+ "              AND r_rtn_dt IS NOT NULL \r\n"
				+ "        GROUP BY rtn_dt, \r\n"
				+ "              r_rtn_dt\r\n"
				+ "       ) c, \r\n"
				+ "       --상환실행 \r\n"
				+ "       (SELECT bb.rtn_dt AS d_dt, \r\n"
				+ "              SUM(bb.i_amt) d_amt \r\n"
				+ "         FROM \r\n"
				+ "              (SELECT nvl(r_rtn_dt,rtn_dt) rtn_dt, \r\n"
				+ "                     cardno \r\n"
				+ "                FROM card_stat_base \r\n"
				+ "               WHERE base_dt>='20210701' \r\n"
				+ "                     AND nvl(use_yn,'Y')<>'N' \r\n"
				+ "               GROUP BY nvl(r_rtn_dt,rtn_dt), \r\n"
				+ "                     cardno\r\n"
				+ "              ) aa, \r\n"
				+ "              (SELECT decode(b.p_pay_dt,a.p_cd1,a.p_cd1,b.p_pay_dt) AS rtn_dt, \r\n"
				+ "                     a.p_cd2 AS cardno, \r\n"
				+ "                     SUM(a.i_amt) i_amt \r\n"
				+ "                FROM pay_item a, \r\n"
				+ "                     pay b \r\n"
				+ "               WHERE a.reqseq=b.reqseq \r\n"
				+ "                     AND a.p_st2 LIKE '법인카드대금%' \r\n"
				+ "                     AND b.p_pay_dt>='20210701' \r\n"
				+ "               GROUP BY decode(b.p_pay_dt,a.p_cd1,a.p_cd1,b.p_pay_dt), \r\n"
				+ "                     a.p_cd2\r\n"
				+ "              ) bb \r\n"
				+ "        WHERE aa.rtn_dt=bb.rtn_dt \r\n"
				+ "              AND aa.cardno=bb.cardno \r\n"
				+ "        GROUP BY bb.rtn_dt \r\n"
				+ "       ) d \r\n"
				+ " WHERE a.a_dt=b.b_dt(+) \r\n"
				+ "       AND a.a_dt=c.c_dt(+) \r\n"
				+ "       AND a.a_dt=d.d_dt(+) \r\n"
				+ s_dt_where
				+ "ORDER BY 1";
		
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
			System.out.println("[CardDatabase:getCardRtnStat2]\n"+e);
			System.out.println("[CardDatabase:getCardRtnStat2]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}		
}
	