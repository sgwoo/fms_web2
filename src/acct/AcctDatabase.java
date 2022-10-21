package acct;


import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;


public class AcctDatabase
{

	private Connection conn = null;
	public static AcctDatabase db;
	
	public static AcctDatabase getInstance()
	{
		if(AcctDatabase.db == null)
			AcctDatabase.db = new AcctDatabase();
		return AcctDatabase.db;
	}	
	
 	private DBConnectionManager connMgr = null;


	private void getConnection()
	{
    		try
    		{
	    		if(connMgr == null)
			{
				connMgr = DBConnectionManager.getInstance();
			}

			if(conn == null)
			{
		        	conn = connMgr.getConnection("acar");
		        }
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


	//내부관리마감 등록
	public boolean insertStatAcct(Vector vt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;

		String query =  " insert into stat_acct "+
						" ( save_dt, s_dt, e_dt, acct_st, seq, "+
						"   value1, value2, value3, value4, value5, value6, value7, value8, value9, value10, "+
						"   value11, value12, value13, value14, value15, value16, value17, value18, value19, value20, "+
						"   result, reg_id, reg_dt, value_size ) values "+
						" ( replace(?,'-',''), replace(?,'-',''), replace(?,'-',''), ?, ?, "+
						"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
						"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
						"   ?, ?, sysdate, ? )";


		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			for(int i = 0 ; i < vt.size() ; i++){

				Hashtable ht = (Hashtable)vt.elementAt(i);

				pstmt.setString(1,  String.valueOf(ht.get("SAVE_DT")));
				pstmt.setString(2,  String.valueOf(ht.get("S_DT")));
				pstmt.setString(3,  String.valueOf(ht.get("E_DT")));
				pstmt.setString(4,  String.valueOf(ht.get("ACCT_ST")));
				pstmt.setInt   (5,  i+1);
				pstmt.setString(6,  String.valueOf(ht.get("VALUE1")));
				pstmt.setString(7,  String.valueOf(ht.get("VALUE2")));
				pstmt.setString(8,  String.valueOf(ht.get("VALUE3")));
				pstmt.setString(9,  String.valueOf(ht.get("VALUE4")));
				pstmt.setString(10, String.valueOf(ht.get("VALUE5")));
				pstmt.setString(11, String.valueOf(ht.get("VALUE6")));
				pstmt.setString(12, String.valueOf(ht.get("VALUE7")));
				pstmt.setString(13, String.valueOf(ht.get("VALUE8")));
				pstmt.setString(14, String.valueOf(ht.get("VALUE9")));
				pstmt.setString(15, String.valueOf(ht.get("VALUE10")));
				pstmt.setString(16, String.valueOf(ht.get("VALUE11")));
				pstmt.setString(17, String.valueOf(ht.get("VALUE12")));
				pstmt.setString(18, String.valueOf(ht.get("VALUE13")));
				pstmt.setString(19, String.valueOf(ht.get("VALUE14")));
				pstmt.setString(20, String.valueOf(ht.get("VALUE15")));
				pstmt.setString(21, String.valueOf(ht.get("VALUE16")));
				pstmt.setString(22, String.valueOf(ht.get("VALUE17")));
				pstmt.setString(23, String.valueOf(ht.get("VALUE18")));
				pstmt.setString(24, String.valueOf(ht.get("VALUE19")));
				pstmt.setString(25, String.valueOf(ht.get("VALUE20")));
				pstmt.setString(26, String.valueOf(ht.get("RESULT")));
				pstmt.setString(27, String.valueOf(ht.get("REG_ID")));
				pstmt.setString(28, String.valueOf(ht.get("VALUE_SIZE")));
				pstmt.executeUpdate();
			}

			pstmt.close();
					    
			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AcctDatabase:insertStatAcct]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//내부관리마감 파일첨부
	public boolean updateAttFile(String save_dt, String acct_st, String s_dt, String e_dt, String seq, String savepath, String file_st, String filename)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;

		String query =  " update stat_acct set att_file =? where save_dt=? and acct_st=? and s_dt=? and e_dt=? and seq=? ";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  savepath+""+filename);
			pstmt.setString(2,  save_dt);
			pstmt.setString(3,  acct_st);
			pstmt.setString(4,  s_dt);
			pstmt.setString(5,  e_dt);
			pstmt.setInt   (6,  AddUtil.parseInt(seq));
			pstmt.executeUpdate();
			pstmt.close();
					    
			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AcctDatabase:updateAttFile]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//내부관리마감 확인
	public boolean updateApp(String save_dt, String acct_st, String s_dt, String e_dt, String seq, String user_id, String result)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;

		String query =  " update stat_acct set app_id =?, app_dt=sysdate, result=? where save_dt=? and acct_st=? and s_dt=? and e_dt=? and seq=? ";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  user_id);
			pstmt.setString(2,  result);
			pstmt.setString(3,  save_dt);
			pstmt.setString(4,  acct_st);
			pstmt.setString(5,  s_dt);
			pstmt.setString(6,  e_dt);
			pstmt.setInt   (7,  AddUtil.parseInt(seq));
			pstmt.executeUpdate();
			pstmt.close();
					    
			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AcctDatabase:updateApp]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	//내부관리마감 확인
	public boolean updateRes(String save_dt, String acct_st, String s_dt, String e_dt, String seq, String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;

		String query =  " update stat_acct set res_id =?, res_dt=sysdate where save_dt=? and acct_st=? and s_dt=? and e_dt=? and seq=? ";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  user_id);
			pstmt.setString(2,  save_dt);
			pstmt.setString(3,  acct_st);
			pstmt.setString(4,  s_dt);
			pstmt.setString(5,  e_dt);
			pstmt.setInt   (6,  AddUtil.parseInt(seq));
			pstmt.executeUpdate();
			pstmt.close();
					    
			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AcctDatabase:updateRes]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//내부관리마감 삭제
	public boolean deleteStatAcct(String save_dt, String s_dt, String e_dt, String acct_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;

		String query =  " delete from stat_acct where acct_st=? and s_dt=replace(?,'-','') and e_dt=replace(?,'-','')";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  acct_st);
			pstmt.setString(2,  s_dt);
			pstmt.setString(3,  e_dt);
			pstmt.executeUpdate();
			pstmt.close();
					    
			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AcctDatabase:deleteStatAcct]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	public String getAcctVarCase(String var_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String str = "";
		String query = "";

		query = " select var_sik from esti_sik_var where var_cd='"+var_cd+"' and a_a='1' and seq='01' ";

		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next()){				
				str = rs.getString(1)==null?"":rs.getString(1);
			}
		    rs.close();
            pstmt.close();	

		} catch (SQLException e) {
			System.out.println("[AcctDatabase:getAcctVarCase]\n"+e);
			System.out.println("[AcctDatabase:getAcctVarCase]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return str;
		}
    }

	public Vector getAcctRegIDList()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT b.user_id, b.user_nm  FROM STAT_ACCT a, USERS b WHERE a.app_dt IS NULL AND a.reg_id=b.user_id GROUP BY b.user_id, b.user_nm ORDER BY b.user_id, b.user_nm "+
				" ";

		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
		    rs.close();
            pstmt.close();	

		} catch (SQLException e) {
			System.out.println("[AcctDatabase:getAcctRegIDList]\n"+e);
			System.out.println("[AcctDatabase:getAcctRegIDList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }

	public Vector getAcctAppIDList()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT b.user_id, b.user_nm  FROM STAT_ACCT a, USERS b WHERE a.app_dt IS not NULL and a.res_dt is null AND a.reg_id=b.user_id GROUP BY b.user_id, b.user_nm ORDER BY b.user_id, b.user_nm "+
				" ";

		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
		    rs.close();
            pstmt.close();	

		} catch (SQLException e) {
			System.out.println("[AcctDatabase:getAcctAppIDList]\n"+e);
			System.out.println("[AcctDatabase:getAcctAppIDList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }

	public Vector getAcctDtList()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT s_dt, e_dt FROM STAT_ACCT WHERE res_dt is NOT null GROUP BY s_dt, e_dt ORDER BY  s_dt desc, e_dt "+
				" ";

		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
		    rs.close();
            pstmt.close();	

		} catch (SQLException e) {
			System.out.println("[AcctDatabase:getAcctDtList]\n"+e);
			System.out.println("[AcctDatabase:getAcctDtList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }

	public Hashtable getStatAcctCase(String save_dt, String acct_st, String s_dt, String e_dt, String seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " SELECT * from stat_acct where save_dt=? and acct_st=? and s_dt=? and e_dt=? and seq=? ";

		try 
		{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  save_dt);
			pstmt.setString(2,  acct_st);
			pstmt.setString(3,  s_dt);
			pstmt.setString(4,  e_dt);
			pstmt.setInt   (5,  AddUtil.parseInt(seq));
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
			System.out.println("[AcctDatabase:getStatAcctCase]\n"+e);
			System.out.println("[AcctDatabase:getStatAcctCase]\n"+query);
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

	public Vector getWaitMngList(String gubun1, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT d.m_nm AS cycle_nm, b.m_nm AS  process_nm, c.user_nm as reg_nm, a.* \n"+
				" FROM   STAT_ACCT a, (SELECT m_st, m_st2, m_cd, m_nm, url, SUBSTR(url,10,INSTR(url,'.')-10) url_str FROM MA_MENU WHERE m_st='19' AND m_cd<>'00') b, \n"+
				"        USERS c, (SELECT m_st2, m_nm FROM MA_MENU WHERE m_st='19' AND m_cd='00') d \n"+
				" WHERE  a.app_dt IS NULL AND a.acct_st=b.url_str(+) AND a.reg_id=c.user_id(+) \n"+
				"        AND b.m_st2=d.m_st2(+) "+
				" ";

		if(!gubun1.equals(""))	query += " and d.m_nm ='"+gubun1+"' ";

		if(!gubun2.equals(""))	query += " and a.reg_id ='"+gubun2+"' ";

		query += " ORDER BY d.m_st2, b.m_cd ";


		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
		    rs.close();
            pstmt.close();	

		} catch (SQLException e) {
			System.out.println("[AcctDatabase:getWaitMngList]\n"+e);
			System.out.println("[AcctDatabase:getWaitMngList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }

	public Vector getValueMngList(String gubun1, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT d.m_nm AS cycle_nm, b.m_nm AS  process_nm, c.user_nm as reg_nm, c2.user_nm as app_nm, a.* \n"+
				" FROM   STAT_ACCT a, (SELECT m_st, m_st2, m_cd, m_nm, url, SUBSTR(url,10,INSTR(url,'.')-10) url_str FROM MA_MENU WHERE m_st='19' AND m_cd<>'00') b, \n"+
				"        USERS c, users c2, (SELECT m_st2, m_nm FROM MA_MENU WHERE m_st='19' AND m_cd='00') d \n"+
				" WHERE  a.app_dt IS not NULL and a.res_dt is null AND a.acct_st=b.url_str(+) AND a.reg_id=c.user_id(+) AND a.app_id=c2.user_id(+) \n"+
				"        AND b.m_st2=d.m_st2(+) "+
				" ";

		if(!gubun1.equals(""))	query += " and d.m_nm ='"+gubun1+"' ";

		if(!gubun2.equals(""))	query += " and a.app_id ='"+gubun2+"' ";

		query += " ORDER BY d.m_st2, b.m_cd ";


		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
		    rs.close();
            pstmt.close();	

		} catch (SQLException e) {
			System.out.println("[AcctDatabase:getValueMngList]\n"+e);
			System.out.println("[AcctDatabase:getValueMngList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }

	public Vector getResultMngList(String gubun1, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT d.m_nm AS cycle_nm, b.m_nm AS  process_nm, c.user_nm as reg_nm, c2.user_nm as app_nm, c3.user_nm as res_nm, a.* \n"+
				" FROM   STAT_ACCT a, (SELECT m_st, m_st2, m_cd, m_nm, url, SUBSTR(url,10,INSTR(url,'.')-10) url_str FROM MA_MENU WHERE m_st='19' AND m_cd<>'00') b, \n"+
				"        USERS c, users c2, users c3, (SELECT m_st2, m_nm FROM MA_MENU WHERE m_st='19' AND m_cd='00') d \n"+
				" WHERE  a.res_dt IS not NULL AND a.acct_st=b.url_str(+) AND a.reg_id=c.user_id(+) AND a.app_id=c2.user_id(+) AND a.res_id=c3.user_id(+) \n"+
				"        AND b.m_st2=d.m_st2(+) "+
				" ";

		if(!gubun1.equals(""))	query += " and d.m_nm ='"+gubun1+"' ";

		if(!gubun2.equals(""))	query += " and a.s_dt||a.e_dt ='"+gubun2+"' ";

		query += " ORDER BY d.m_st2, b.m_cd ";

		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
		    rs.close();
            pstmt.close();	

		} catch (SQLException e) {
			System.out.println("[AcctDatabase:getResultMngList]\n"+e);
			System.out.println("[AcctDatabase:getResultMngList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }

	public Vector getRc1C1List(String st_dt, String end_dt, String s_cnt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select * \n"+
				" from \n"+
				"        (  \n"+
				"          select /*+ RULE */  \n"+
				" 			      a.rent_mng_id, a.rent_l_cd, a.rent_dt, c.firm_nm, \n"+
				"                 DECODE(b.eval_off,'1','크레탑','2','NICE') eval_off_nm, \n"+
				"                 d.nm AS eval_gr_nm, b.eval_nm, b.eval_s_dt \n"+
				"          from   cont a, (SELECT * FROM CONT_EVAL WHERE eval_off IS NOT NULL and eval_gr is not null) b, \n"+
				"                 CLIENT c, (SELECT * FROM CODE WHERE c_st='0013' AND CODE<>'0000') d  \n"+
				"          where  a.rent_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') \n"+
				"                 AND a.car_st<>'2' AND a.use_yn IS NOT null \n"+
				"                 AND a.rent_mng_id=b.rent_mng_id(+) AND a.rent_l_cd=b.rent_l_cd(+) \n"+
				"                 AND a.client_id=c.client_id  \n"+
				"                 AND DECODE(b.eval_off,'1','3','2','1')=d.app_st(+) AND b.eval_gr=d.nm_cd(+) \n"+
				"          order by DBMS_RANDOM.VALUE \n"+
				" )  \n"+
				" where  ROWNUM<"+s_cnt+"+1 "+
				" order by rent_dt "+
				" ";

		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
		    rs.close();
            pstmt.close();	

		} catch (SQLException e) {
			System.out.println("[AcctDatabase:getRc1C1List]\n"+e);
			System.out.println("[AcctDatabase:getRc1C1List]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }

	public Vector getRc1C2List(String st_dt, String end_dt, String s_cnt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select * \n"+
				" from \n"+
				"        (  \n"+
				"          select /*+ RULE */  \n"+
				" 			      a.rent_mng_id, a.rent_l_cd, a.rent_dt, c.firm_nm, \n"+
				"                 DECODE(b.dec_gr,'1','우량기업','2','초우량기업','3','신설법인','4','일반고객') dec_gr_nm, \n"+
				"                 d.user_id, d.user_nm as dec_f_id_nm, b.dec_f_dt \n"+
				"          from   cont a, cont_etc b, CLIENT c, users d  \n"+
				"          where  a.rent_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') \n"+
				"                 AND a.car_st<>'2' AND a.use_yn IS NOT null \n"+
				"                 AND a.rent_mng_id=b.rent_mng_id(+) AND a.rent_l_cd=b.rent_l_cd(+) \n"+
				"                 AND a.client_id=c.client_id  \n"+
				"                 and b.dec_f_id=d.user_id(+) \n"+
				"          order by DBMS_RANDOM.VALUE \n"+
				" )  \n"+
				" where  ROWNUM<"+s_cnt+"+1 "+
				" order by rent_dt "+
				" ";

		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
		    rs.close();
            pstmt.close();	

		} catch (SQLException e) {
			System.out.println("[AcctDatabase:getRc1C2List]\n"+e);
			System.out.println("[AcctDatabase:getRc1C2List]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }

	public Vector getRc2C1List(String st_dt, String end_dt, String s_cnt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select * \n"+
				" from \n"+
				"        (  \n"+
				"          select /*+ RULE */  \n"+
				" 			      a.rent_mng_id, a.rent_l_cd, a.rent_dt, c.firm_nm, \n"+
				"                 d.user_id, d.user_nm as sanction_id_nm, to_char(a.sanction_date,'YYYY-MM-DD') sanction_date \n"+
				"          from   cont a, fee b, CLIENT c, users d  \n"+
				"          where  a.rent_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') \n"+
				"                 AND a.car_st<>'2' AND a.use_yn IS NOT null \n"+
				"                 AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd \n"+
				"                 and a.rent_l_cd in (select rent_l_cd from fee group by rent_l_cd having count(0)=1) "+
				"                 AND a.client_id=c.client_id  \n"+
				"                 and a.sanction_id=d.user_id(+) \n"+
				"          order by DBMS_RANDOM.VALUE \n"+
				" )  \n"+
				" where  ROWNUM<"+s_cnt+"+1 "+
				" order by rent_dt "+
				" ";

		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
		    rs.close();
            pstmt.close();	

		} catch (SQLException e) {
			System.out.println("[AcctDatabase:getRc2C1List]\n"+e);
			System.out.println("[AcctDatabase:getRc2C1List]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }

	public Vector getPc1C4List(String st_dt, String end_dt, String s_cnt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		query = " select * \n"+
				" from \n"+
				"        (  \n"+
				"          select /*+ RULE */  \n"+
				" 			      tax_dt, recconame, autodocu_write_date, autodocu_data_no  \n"+
				"          from   tax  \n"+
				"          where  tax_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') \n"+
				"                 and tax_st<>'C' AND gubun='1' \n"+
				"                 \n"+
				"          order by DBMS_RANDOM.VALUE \n"+
				" )  \n"+
				" where  ROWNUM<"+s_cnt+"+1 "+
				" order by tax_dt "+
				" ";

		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
		    rs.close();
            pstmt.close();	

		} catch (SQLException e) {
			System.out.println("[AcctDatabase:getPc1C4List]\n"+e);
			System.out.println("[AcctDatabase:getPc1C4List]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }

	public Vector getPc4C2List(String st_dt, String end_dt, String s_cnt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		query = " select * \n"+
				" from \n"+
				"        (  \n"+
				"          select /*+ RULE */  \n"+
				" 			      b.*, d.firm_nm, e.car_no, e.car_nm, \n"+
				"                 decode(b.bad_debt_st,'1','채권추심','2','대손처리','3','기각') bad_debt_st_nm,  \n"+
				"                 decode(a.doc_step,'1','기안','2','결재','3','완료','대기') bit,  \n"+
				"                 a.doc_no, a.user_id1, a.user_id2, \n"+
				"                 to_char(a.user_dt1,'YYYY-MM-DD') user_dt1, to_char(a.user_dt2,'YYYY-MM-DD') user_dt2,  \n"+
				"                 f1.user_nm as user_nm1, f2.user_nm as user_nm2  \n"+
				"          from   doc_settle a, bad_debt_req b, cont c, client d, car_reg e, users f1, users f2  \n"+
				"          where  a.doc_st='46' and a.doc_step='3' and to_char(a.user_dt2,'YYYYMMDD') between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') \n"+
				"                 and    a.doc_id=b.rent_l_cd||b.seq  \n"+
				"                 and    b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd  \n"+
				"                 and    c.client_id=d.client_id  \n"+
				"                 and    c.car_mng_id=e.car_mng_id  \n"+
				"                 and    a.user_id1=f1.user_id  \n"+
				"                 and    a.user_id2=f2.user_id(+)  \n"+
				"                 \n"+
				"          order by DBMS_RANDOM.VALUE \n"+
				" )  \n"+
				" where  ROWNUM<"+s_cnt+"+1 "+
				" order by user_dt1 "+
				" ";

		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
		    rs.close();
            pstmt.close();	

		} catch (SQLException e) {
			System.out.println("[AcctDatabase:getPc4C2List]\n"+e);
			System.out.println("[AcctDatabase:getPc4C2List]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }

	public Vector getPc5C1List(String st_dt, String end_dt, String s_cnt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		query = " select * \n"+
				" from \n"+
				"        (  \n"+
				"          select /*+ RULE */  \n"+
				" 		 	      b.*, c.firm_nm, \n"+
				"        	      decode(b.bad_st,'1','승인','2','보류','3','기각') bad_st_nm,  \n"+
				"        	      decode(b.car_call_yn,'Y','회수','N','미회수','') car_call_yn_nm,  \n"+
				"        	      decode(a.doc_step,'1','기안','2','결재','3','완료','대기') bit,  \n"+
				"        	      a.doc_no, a.user_id1, a.user_id2, a.user_id3, "+
				"                 to_char(a.user_dt1,'YYYY-MM-DD') user_dt1, to_char(a.user_dt2,'YYYY-MM-DD') user_dt2, to_char(a.user_dt3,'YYYY-MM-DD') user_dt3, \n"+
				"        	      f1.user_nm as user_nm1, f2.user_nm as user_nm2, f3.user_nm as user_nm3,  \n"+
				"        	      TRUNC(decode(b.req_dt,'',0, months_between(to_date(nvl(b.id_cng_req_dt,to_char(sysdate,'YYYYMMDD')),'YYYYMMDD'), to_date(b.req_dt,'YYYYMMDD')))) req_mon  \n"+
				"          from   doc_settle a, bad_complaint_req b, (select bad_comp_cd, min(rent_l_cd) rent_l_cd from bad_complaint_req_list group by bad_comp_cd) bb, \n"+
			//	"                 cont c, client d, car_reg e, users f1, users f2, users f3  \n"+
				"   ( select c.* , b.firm_nm from cont c , client b , car_reg e where c.client_id = b.client_id and c.car_mng_id = e.car_mng_id ) c, users f1, users f2, users f3  \n"+
				"          where  a.doc_st='49' and a.doc_step='3' and to_char(a.user_dt3,'YYYYMMDD') between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') \n"+
				"                 and    bb.rent_l_cd=c.rent_l_cd  \n"+
				"                 and    a.doc_id=b.client_id||b.seq  \n"+
				"                 and    a.doc_id=bb.bad_comp_cd "+			
			//	"                 and    c.client_id=d.client_id  \n"+
			//	"                 and    c.car_mng_id=e.car_mng_id  \n"+
				"                 and    a.user_id1=f1.user_id  \n"+
				"                 and    a.user_id2=f2.user_id  \n"+
				"                 and    a.user_id3=f3.user_id  \n"+
				"                 \n"+
				"          order by DBMS_RANDOM.VALUE \n"+
				" )  \n"+
				" where  ROWNUM<"+s_cnt+"+1 "+
				" order by user_dt1 "+
				" ";
		                
		
	//	System.out.println("query="+ query);

		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
		    rs.close();
            pstmt.close();	

		} catch (SQLException e) {
			System.out.println("[AcctDatabase:getPc5C1List]\n"+e);
			System.out.println("[AcctDatabase:getPc5C1List]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }

	public Vector getRm1C1List(String st_dt, String end_dt, String s_cnt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		query = " select * \n"+
				" from \n"+
				"        (  \n"+
				"          select /*+ RULE */  \n"+
				" 			      a.rent_mng_id, a.rent_l_cd, a.dlv_dt, c.firm_nm, d2.car_nm, d.car_name, \n"+
				"        	      e.doc_no, e.user_id1, e.user_id5, \n"+
				"                 to_char(e.user_dt1,'YYYY-MM-DD') user_dt1, to_char(e.user_dt5,'YYYY-MM-DD') user_dt5, \n"+
				"        	      f1.user_nm as user_nm1, f5.user_nm as user_nm5  \n"+
				"          from   cont a, car_etc b, CLIENT c, car_nm d, car_mng d2, car_pur f, (select * from doc_settle where doc_st='4') e, users f1, users f5   \n"+
				"          where  a.dlv_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') \n"+
				"                 AND a.car_st<>'2' AND a.use_yn IS NOT null and a.car_gu='1' \n"+
				"                 AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd \n"+
				"                 AND a.client_id=c.client_id  \n"+
				"                 and b.car_id=d.car_id and b.car_seq=d.car_seq \n"+
				"                 and d.car_comp_id=d2.car_comp_id and d.car_cd=d2.code \n"+
				"                 AND a.rent_mng_id=f.rent_mng_id AND a.rent_l_cd=f.rent_l_cd \n"+
				"                 and a.rent_l_cd=e.doc_id(+) \n"+
				"                 and e.user_id1=f1.user_id(+) \n"+
				"                 and e.user_id5=f5.user_id(+) \n"+
				"          order by DBMS_RANDOM.VALUE \n"+
				" )  \n"+
				" where  ROWNUM<"+s_cnt+"+1 \n"+
				" order by dlv_dt "+
				" ";

		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
		    rs.close();
            pstmt.close();	

		} catch (SQLException e) {
			System.out.println("[AcctDatabase:getRm1C1List]\n"+e);
			System.out.println("[AcctDatabase:getRm1C1List]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }

	public Vector getRm1C2List(String st_dt, String end_dt, String s_cnt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		query = " select * \n"+
				" from \n"+
				"        (  \n"+
				"          select /*+ RULE */  \n"+
				" 			      a.rent_mng_id, a.rent_l_cd, a.dlv_dt, c.firm_nm, d2.car_nm, d.car_name, f.autodocu_write_date, f.autodocu_data_no, \n"+
				"        	      e.doc_no, e.user_id1, e.user_id2, \n"+
				"                 to_char(e.user_dt1,'YYYY-MM-DD') user_dt1, to_char(e.user_dt2,'YYYY-MM-DD') user_dt2, \n"+
				"        	      f1.user_nm as user_nm1, f2.user_nm as user_nm2  \n"+
				"          from   cont a, car_etc b, CLIENT c, car_nm d, car_mng d2, car_pur f, (select * from doc_settle where doc_st='5') e, users f1, users f2   \n"+
				"          where  a.dlv_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') \n"+
				"                 AND a.car_st<>'2' AND a.use_yn IS NOT null and a.car_gu='1' \n"+
				"                 AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd \n"+
				"                 AND a.client_id=c.client_id  \n"+
				"                 and b.car_id=d.car_id and b.car_seq=d.car_seq \n"+
				"                 and d.car_comp_id=d2.car_comp_id and d.car_cd=d2.code \n"+
				"                 AND a.rent_mng_id=f.rent_mng_id AND a.rent_l_cd=f.rent_l_cd and f.autodocu_write_date is not null \n"+
				"                 and f.req_code=e.doc_id(+) \n"+
				"                 and e.user_id1=f1.user_id(+) \n"+
				"                 and e.user_id2=f2.user_id(+) \n"+
				"          order by DBMS_RANDOM.VALUE \n"+
				" )  \n"+
				" where  ROWNUM<"+s_cnt+"+1 \n"+
				" order by dlv_dt "+
				" ";

		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
		    rs.close();
            pstmt.close();	

		} catch (SQLException e) {
			System.out.println("[AcctDatabase:getRm1C2List]\n"+e);
			System.out.println("[AcctDatabase:getRm1C2List]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }

	public Vector getRm2C1List(String st_dt, String end_dt, String s_cnt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		query = " select * \n"+
				" from \n"+
				"        (  \n"+
				"          select /*+ RULE */  \n"+
				" 			      b.off_nm, b.AUTODOCU_WRITE_DATE, b.AUTODOCU_DATA_NO, b.p_pay_dt, \n"+
				"        	      c.doc_no, c.user_id1, c.user_id2, \n"+
				"                 to_char(c.user_dt1,'YYYY-MM-DD') user_dt1, to_char(c.user_dt2,'YYYY-MM-DD') user_dt2, \n"+
				"        	      f1.user_nm as user_nm1, f2.user_nm as user_nm2  \n"+
				"          from   PAY_ITEM a, PAY b, (select * from doc_settle where doc_st='32') c, USERS f1, USERS f2   \n"+
				"          where  \n"+
				"                 a.p_st2 IN ('자동차보험료','리스차량선급보험료','대여차량선급보험료') \n"+
				"                 AND b.p_pay_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') \n"+
				"                 AND a.reqseq=b.reqseq \n"+
				"                 AND b.bank_code=c.doc_id(+)  \n"+
				"                 and c.user_id1=f1.user_id(+) \n"+
				"                 and c.user_id2=f2.user_id(+) \n"+
				"          order by DBMS_RANDOM.VALUE \n"+
				" )  \n"+
				" where  ROWNUM<"+s_cnt+"+1 \n"+
				" order by p_pay_dt "+
				" ";

		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
		    rs.close();
            pstmt.close();	

		} catch (SQLException e) {
			System.out.println("[AcctDatabase:getRm2C1List]\n"+e);
			System.out.println("[AcctDatabase:getRm2C1List]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }

	public Vector getRm3C1List(String st_dt, String end_dt, String s_cnt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		query = " select * \n"+
				" from \n"+
				"        (  \n"+
				"          select /*+ RULE */  \n"+
				" 			      io_dt, COUNT(0) cnt  \n"+
				"          from   PARK_IO   \n"+
				"          where  \n"+
				"                 io_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') \n"+
				"                 AND io_gubun='1' \n"+
				"          GROUP BY io_dt \n"+
				"          order by DBMS_RANDOM.VALUE \n"+
				" )  \n"+
				" where  ROWNUM<"+s_cnt+"+1 \n"+
				" order by io_dt "+
				" ";

		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
		    rs.close();
            pstmt.close();	

		} catch (SQLException e) {
			System.out.println("[AcctDatabase:getRm3C1List]\n"+e);
			System.out.println("[AcctDatabase:getRm3C1List]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }

	public Vector getRm4C1List(String st_dt, String end_dt, String s_cnt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		query = " select * \n"+
				" from \n"+
				"        (  \n"+
				"          select /*+ RULE */  \n"+
				" 			      io_dt, COUNT(0) cnt  \n"+
				"          from   PARK_IO   \n"+
				"          where  \n"+
				"                 io_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') \n"+
				"                 AND io_gubun='2' \n"+
				"          GROUP BY io_dt \n"+
				"          order by DBMS_RANDOM.VALUE \n"+
				" )  \n"+
				" where  ROWNUM<"+s_cnt+"+1 \n"+
				" order by io_dt "+
				" ";

		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
		    rs.close();
            pstmt.close();	

		} catch (SQLException e) {
			System.out.println("[AcctDatabase:getRm4C1List]\n"+e);
			System.out.println("[AcctDatabase:getRm4C1List]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }

	public Vector getRm6C1List(String st_dt, String end_dt, String s_cnt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		query = " select * \n"+
				" from \n"+
				"        (  \n"+
				"          select /*+ RULE */  \n"+
				" 			      b.off_nm, b.AUTODOCU_WRITE_DATE, b.AUTODOCU_DATA_NO, b.p_pay_dt, \n"+
				"        	      c.doc_no, c.user_id1, c.user_id2, \n"+
				"                 to_char(c.user_dt1,'YYYY-MM-DD') user_dt1, to_char(c.user_dt2,'YYYY-MM-DD') user_dt2, \n"+
				"        	      f1.user_nm as user_nm1, f2.user_nm as user_nm2  \n"+
				"          from   PAY_ITEM a, PAY b, (select * from doc_settle where doc_st='32') c, USERS f1, USERS f2   \n"+
				"          where  \n"+
				"                 a.p_st2 IN ('정비비','정비비(정산)','차량정비비','사고수리비','차량부품비') \n"+
				"                 AND b.p_pay_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') \n"+
				"                 AND a.reqseq=b.reqseq \n"+
				"                 AND b.bank_code=c.doc_id(+)  \n"+
				"                 and c.user_id1=f1.user_id(+) \n"+
				"                 and c.user_id2=f2.user_id(+) \n"+
				"          order by DBMS_RANDOM.VALUE \n"+
				" )  \n"+
				" where  ROWNUM<"+s_cnt+"+1 \n"+
				" order by p_pay_dt "+
				" ";

		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
		    rs.close();
            pstmt.close();	

		} catch (SQLException e) {
			System.out.println("[AcctDatabase:getRm6C1List]\n"+e);
			System.out.println("[AcctDatabase:getRm6C1List]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }

	public Vector getFc2C2List(String st_dt, String end_dt, String s_cnt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		query = " select * \n"+
				" from \n"+
				"        (  \n"+
				"          select /*+ RULE */  \n"+
				" 			      b.off_nm, b.AUTODOCU_WRITE_DATE, b.AUTODOCU_DATA_NO, b.p_pay_dt, \n"+
				"        	      c.doc_no, c.user_id1, c.user_id2, \n"+
				"                 to_char(c.user_dt1,'YYYY-MM-DD') user_dt1, to_char(c.user_dt2,'YYYY-MM-DD') user_dt2, \n"+
				"        	      f1.user_nm as user_nm1, f2.user_nm as user_nm2  \n"+
				"          from   PAY_ITEM a, PAY b, (select * from doc_settle where doc_st='32') c, USERS f1, USERS f2   \n"+
				"          where  \n"+
				"                 a.p_st2 IN ('할부금','할부금중도상환','장기차입금','유동성장기부채') \n"+
				"                 AND b.p_pay_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') \n"+
				"                 AND a.reqseq=b.reqseq \n"+
				"                 AND b.bank_code=c.doc_id(+)  \n"+
				"                 and c.user_id1=f1.user_id(+) \n"+
				"                 and c.user_id2=f2.user_id(+) \n"+
				"          order by DBMS_RANDOM.VALUE \n"+
				" )  \n"+
				" where  ROWNUM<"+s_cnt+"+1 \n"+
				" order by p_pay_dt "+
				" ";

		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
		    rs.close();
            pstmt.close();	

		} catch (SQLException e) {
			System.out.println("[AcctDatabase:getFc2C2List]\n"+e);
			System.out.println("[AcctDatabase:getFc2C2List]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }

	public Vector getFc3C1List(String st_dt, String end_dt, String s_cnt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		query = " select * \n"+
				" from \n"+
				"        (  \n"+
				"          select /*+ RULE */  \n"+
				" 			      a.off_nm, a.AUTODOCU_WRITE_DATE, a.AUTODOCU_DATA_NO, a.p_pay_dt, \n"+
				"        	      f1.user_nm as doc_user_nm2, f2.user_nm as act_user_nm2,  \n"+
				"                 to_char(b.user_dt3,'YYYY-MM-DD') doc_user_dt2, to_char(c.user_dt2,'YYYY-MM-DD') act_user_dt2 \n"+
				"          from   PAY a, (select * from doc_settle where doc_st='31') b, (select * from doc_settle where doc_st='32') c, USERS f1, USERS f2   \n"+
				"          where  \n"+
				"                 a.p_pay_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') \n"+
				"                 AND a.doc_code=b.doc_id(+)  \n"+
				"                 AND a.bank_code=c.doc_id(+)  \n"+
				"                 and b.user_id3=f1.user_id(+) \n"+
				"                 and c.user_id2=f2.user_id(+) \n"+
				"          order by DBMS_RANDOM.VALUE \n"+
				" )  \n"+
				" where  ROWNUM<"+s_cnt+"+1 \n"+
				" order by p_pay_dt "+
				" ";

		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
		    rs.close();
            pstmt.close();	

		} catch (SQLException e) {
			System.out.println("[AcctDatabase:getFc3C1List]\n"+e);
			System.out.println("[AcctDatabase:getFc3C1List]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }

	public Vector getFc4C3List(String st_dt, String end_dt, String s_cnt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		query = " select * \n"+
				" from \n"+
				"        (  \n"+
				"          select /*+ RULE */  \n"+
				" 			      a.reg_dt, a.buy_dt, a.buy_amt, a.VEN_NAME, a.cd_reg_id, f1.user_nm AS cd_reg_id_nm \n"+
				"          from   CARD_DOC a, USERS f1   \n"+
				"          where  \n"+
				"                 a.buy_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') \n"+
				"                 AND a.app_dt IS NOT NULL /*AND a.cgs_ok='Y' */ \n"+
				"                 and a.cd_reg_id=f1.user_id(+) \n"+
				"          order by DBMS_RANDOM.VALUE \n"+
				" )  \n"+
				" where  ROWNUM<"+s_cnt+"+1 \n"+
				" order by buy_dt "+
				" ";

		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
		    rs.close();
            pstmt.close();	

		} catch (SQLException e) {
			System.out.println("[AcctDatabase:getFc4C3List]\n"+e);
			System.out.println("[AcctDatabase:getFc4C3List]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }
    
    
    /*  중도해지/매각 승인품의서 */
    public Vector getPc2C1List(String st_dt, String end_dt, String s_cnt, String gubun)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		query = " select * \n"+
				" from \n"+
				"        (  \n"+
				"          select /*+ RULE */  \n"+
				" 		 	      b.*, d.firm_nm, \n"+
				"        	      decode(a.doc_step,'1','기안','2','결재','3','완료','대기') bit,  \n"+
				"        	      a.doc_no, a.user_id1, a.user_id5,  "+
				"                 to_char(a.user_dt1,'YYYY-MM-DD') user_dt1, to_char(a.user_dt5,'YYYY-MM-DD') user_dt5,  \n"+
				"        	      f1.user_nm as user_nm1, f2.user_nm as user_nm5 \n"+		
				"          from   doc_settle a,  cls_cont  b, \n"+
				"                 cont c, client d, car_reg e, users f1, users f2  \n"+
				"          where   a.doc_st='11' and a.doc_step='3' and to_char(a.user_dt1,'YYYYMMDD') between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') \n"+
				"                 and    a.doc_id=b.rent_l_cd  \n"+        
				"                 and    b.rent_mng_id = c.rent_mng_id and b.rent_l_cd = c.rent_l_cd   and  b.cls_st = '" + gubun + "'  \n"+        
				"                 and   c.client_id=d.client_id  \n"+
				"                 and    c.car_mng_id=e.car_mng_id  \n"+
				"                 and    a.user_id1=f1.user_id  \n"+
				"                 and    a.user_id5=f2.user_id(+)  \n"+			
				"                 \n"+
				"          order by DBMS_RANDOM.VALUE \n"+
				" )  \n"+
				" where  ROWNUM<"+s_cnt+"+1 "+
				" order by user_dt1 "+
				" ";

		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
		    rs.close();
            pstmt.close();	

		} catch (SQLException e) {
			System.out.println("[AcctDatabase:getPc2C1List]\n"+e);
			System.out.println("[AcctDatabase:getPc2C1List]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }
    
       /*  중도해지/계약만료  입금 전표  */
    public Vector getPc2C2List(String st_dt, String end_dt, String s_cnt, String gubun)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		query = " select * \n"+
				" from \n"+
				"        (  \n"+
				"          select /*+ RULE */  \n"+
				" 		 	      b.*, d.firm_nm, \n"+
				"        	      decode(a.doc_step,'1','기안','2','결재','3','완료','대기') bit,  \n"+
				"        	      a.doc_no, a.user_id1, a.user_id5,  "+
				"                 to_char(a.user_dt1,'YYYY-MM-DD') user_dt1, to_char(a.user_dt5,'YYYY-MM-DD') user_dt5,  \n"+
				"        	      f1.user_nm as user_nm1, f2.user_nm as user_nm5 \n"+		
				"          from   doc_settle a,  cls_etc  b, \n"+
				"                 cont c, client d, car_reg e, users f1, users f2  \n"+
				"          where   a.doc_st='11' and a.doc_step='3' and to_char(a.user_dt1,'YYYYMMDD') between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') \n"+
				"                 and    a.doc_id=b.rent_l_cd  \n"+        
				"                 and    b.rent_mng_id = c.rent_mng_id and b.rent_l_cd = c.rent_l_cd   and  b.cls_st = '"+ gubun + "' and  b.est_amt < 0 and b.dfee_amt_1 > 0 and b.ex_di_amt_1 > 0   \n"+        
				"                 and   c.client_id=d.client_id  \n"+
				"                 and    c.car_mng_id=e.car_mng_id  \n"+
				"                 and    a.user_id1=f1.user_id  \n"+
				"                 and    a.user_id5=f2.user_id(+)  \n"+			
				"                 \n"+
				"          order by DBMS_RANDOM.VALUE \n"+
				" )  \n"+
				" where  ROWNUM<"+s_cnt+"+1 "+
				" order by user_dt1 "+
				" ";				
		

		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
		    rs.close();
            pstmt.close();	

		} catch (SQLException e) {
			System.out.println("[AcctDatabase:getPc2C1List]\n"+e);
			System.out.println("[AcctDatabase:getPc2C1List]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }
    
        /*  매각대금 입금 전표 승인 */
    public Vector getPc3C2List(String st_dt, String end_dt, String s_cnt, String gubun)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		query = " select * \n"+
				" from \n"+
				"        (  \n"+
				"          select /*+ RULE */  \n"+
				" 		 	      b.*, d.firm_nm, \n"+
				"        	      decode(a.doc_step,'1','기안','2','결재','3','완료','대기') bit,  \n"+
				"        	      a.doc_no, a.user_id1, a.user_id5,  "+
				"                 to_char(a.user_dt1,'YYYY-MM-DD') user_dt1, to_char(a.user_dt5,'YYYY-MM-DD') user_dt5,  \n"+
				"        	      f1.user_nm as user_nm1, f2.user_nm as user_nm5 \n"+		
				"          from   doc_settle a,  cls_etc  b, \n"+
				"                 cont c, client d, car_reg e, users f1, users f2  \n"+
				"          where   a.doc_st='11' and a.doc_step='3' and to_char(a.user_dt1,'YYYYMMDD') between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') \n"+
				"                 and    a.doc_id=b.rent_l_cd  and b.opt_ip_dt1 is not null \n"+        
				"                 and    b.rent_mng_id = c.rent_mng_id and b.rent_l_cd = c.rent_l_cd   and  b.cls_st = '" + gubun + "'  \n"+        
				"                 and   c.client_id=d.client_id  \n"+
				"                 and    c.car_mng_id=e.car_mng_id  \n"+
				"                 and    a.user_id1=f1.user_id  \n"+
				"                 and    a.user_id5=f2.user_id(+)  \n"+			
				"                 \n"+
				"          order by DBMS_RANDOM.VALUE \n"+
				" )  \n"+
				" where  ROWNUM<"+s_cnt+"+1 "+
				" order by user_dt1 "+
				" ";

		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
		    rs.close();
            pstmt.close();	

		} catch (SQLException e) {
			System.out.println("[AcctDatabase:getPc2C1List]\n"+e);
			System.out.println("[AcctDatabase:getPc2C1List]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }

     /*  채권회수  입금 전표  */
    public Vector getPc4C1List(String st_dt, String end_dt, String s_cnt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
	  // 2022년 1월 변경 - acms table 사용안함 
		
	/*	query = " select * \n"+
		  	      " from \n"+
			      "        (  \n"+
			      "		select a.*, c.aipdate , d.firm_nm  from cls_cont a, jip_cms b , cms.file_ea21 c , client d , cont cc \n"+
			      "		where a.cls_st  in ( '1', '2')  and a.rent_l_cd = b.acode and b.acode = c.user_no and b.adate = c.adate and b.cls > 0 and c.amount - c.r_amount > 0  \n"+
			      "		and a.fdft_amt2 > 0	 \n"+
			      "           and a.rent_mng_id = cc.rent_mng_id and a.rent_l_cd = cc.rent_l_cd  and cc.client_id = d.client_id \n"+
			      "		and c.aipdate between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') \n"+
			      "          order by DBMS_RANDOM.VALUE \n"+
			      "  )  \n"+
			      " where  ROWNUM<"+s_cnt+"+1 "+
			      " order by aipdate "+
			      " ";
*/
		
		query = "select *  from \n"+ 
			    "     (  \n"+
				"		select a.incom_dt, a.incom_seq, a.card_doc_cont, a.incom_amt, a.row_id, e.ext_pay_amt,  e.rent_mng_id, e.rent_l_cd , d.firm_nm  \n"+
				" 		from incom a, scd_ext e , cont c , cls_cont cc , client d \n"+
				"		where a.card_doc_cont like '%해지정산%'  and a.row_id is not null \n"+
				"		 and a.incom_dt = e.incom_dt and a.incom_seq = e.incom_seq and e.ext_st = '4' \n"+
				"	 	 and e.rent_mng_id= c.rent_mng_id and e.rent_l_cd = c.rent_l_cd \n"+
				"	 	 and c.rent_mng_id= cc.rent_mng_id and c.rent_l_cd = cc.rent_l_cd and cc.cls_st  in ( '1', '2')   \n"+
				"	 	 and c.client_id = d.client_id \n"+
				"	  	 and a.incom_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') \n"+
				"		 order by DBMS_RANDOM.VALUE \n"+
				"  )  \n"+
				" where  ROWNUM<"+s_cnt+"+1 "+
				" order by incom_dt "+
				 " ";

		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
		    rs.close();
            pstmt.close();	

		} catch (SQLException e) {
			System.out.println("[AcctDatabase:getPc2C1List]\n"+e);
			System.out.println("[AcctDatabase:getPc2C1List]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }


//입력 및 조회  - 내부통제는 기준일자의 연도가 아닌 다음에에 등록되므로 쿼리 수정
public Vector getAcct_in_search(String st_dt, String end_dt, String s_cnt, String type)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		query = " SELECT * \n"+
				"  FROM  \n"+
				"	   (SELECT /*+ RULE */  \n"+
				"			 a.*, f1.USER_NM \n"+
				"		 FROM STAT_ACCT a,  \n"+
				"			  USERS f1  \n"+
				"		WHERE   \n"+
				"			  a.s_dt||a.e_dt = replace('"+st_dt+"','-','') || replace('"+end_dt+"','-','')  \n"+
		//		"			  TO_CHAR(a.reg_dt,'YYYYMMDD') BETWEEN replace('"+st_dt+"','-','') AND replace('"+end_dt+"','-','')  \n"+
				"			  AND a.reg_id=f1.user_id(+) \n"+
				"			  AND a.ACCT_ST = '"+type+"'  \n"+
				"	 ORDER BY DBMS_RANDOM.VALUE  \n"+
				"	   )  \n"+
				" WHERE ROWNUM<"+s_cnt+"+1  \n"+
				" ORDER BY reg_dt \n"+
				" ";


		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
		    rs.close();
            pstmt.close();	

		} catch (SQLException e) {
			System.out.println("[AcctDatabase:getAcct_in_search]\n"+e);
			System.out.println("[AcctDatabase:getAcct_in_search]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }


public Vector getRm5C1List(String st_dt, String end_dt, String s_cnt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select * \n"+
				" from \n"+
				"        (  \n"+
				"	select a.car_mng_id, c.car_no,  uc.actn_dt from sui a, car_reg c ,  \n"+
	 			"         (SELECT a.car_mng_id CAR_MNG_ID, a.seq SEQ, a.actn_st ACTN_ST, a.actn_dt ACTN_DT FROM auction a WHERE a.seq = (select max(seq) from auction where car_mng_id = a.car_mng_id)) uc  \n"+
				"	where a.car_mng_id = c.car_mng_id   \n"+
				"	  and a.car_mng_id = uc.car_mng_id(+)  \n"+
				"          and uc.actn_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')   and c.off_ls = '5'   \n"+
				"          order by DBMS_RANDOM.VALUE \n"+
		  		" )  \n"+
				" where  ROWNUM<"+s_cnt+"+1 \n"+
				" order by actn_dt "+
				" ";


		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
		    rs.close();
            pstmt.close();	

		} catch (SQLException e) {
			System.out.println("[AcctDatabase:getRm5C1List]\n"+e);
			System.out.println("[AcctDatabase:getRm5C1List]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }
	

	//내부관리마감 확인
	public boolean updateAcctScan(String save_dt, String acct_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;

		String query =  " update stat_acct set att_file ='' where save_dt=? and acct_st=?  ";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  save_dt);
			pstmt.setString(2,  acct_st);
			pstmt.executeUpdate();
			pstmt.close();
					    
			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AcctDatabase:updateAcctScan]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

}